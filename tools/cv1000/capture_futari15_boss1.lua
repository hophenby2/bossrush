-- 第一面关底专用采样：从现有状态续采，保存本体、真实伤害回调及三类炮台状态与出膛参数。
-- 不注入血量、不改自机坐标；CV1000_KEEP_LIVES 只沿用通用工具的补残机选项。
local machine=manager.machine
assert(emu.romname()=='futari15','只支持 Futari 1.5')
local cpu=machine.devices[':maincpu']
local program=cpu.spaces.program
local memory=emu.item(assert(cpu.items['0/:mainram']))
local prefix=assert(os.getenv('CV1000_TRACE'))
local state=assert(os.getenv('CV1000_STATE'))
local resume=assert(tonumber(os.getenv('CV1000_RESUME_FRAME')))
local first=tonumber(os.getenv('CV1000_FIRST'))or resume+1
local last=assert(tonumber(os.getenv('CV1000_LAST')))
local fireFrom,fireTo=(os.getenv('CV1000_FIRE')or''):match('^(%d+),(%d+)$')
fireFrom,fireTo=tonumber(fireFrom),tonumber(fireTo)
local fire=machine.ioport.ports[':PORT_D'].fields['P1 Button 1']
local movement={}
for _,name in ipairs({'Left','Right','Up','Down'})do
    local from,to=(os.getenv('CV1000_'..name:upper())or''):match('^(%d+),(%d+)$')
    if from then movement[#movement+1]={machine.ioport.ports[':PORT_D'].fields['P1 '..name],tonumber(from),tonumber(to)}end
end
local keepLives=os.getenv('CV1000_KEEP_LIVES')=='1'
local actors=assert(io.open(prefix..'.actors','wb'))
local hits=assert(io.open(prefix..'.hits','w'))
local guns=assert(io.open(prefix..'.guns','w'))
local scene=assert(io.open(prefix..'.scene','w'))
local shots=assert(io.open(prefix..'.shots','w'))
local poses=os.getenv('CV1000_POSE')=='1'and assert(io.open(prefix..'.pose','wb'))
local motions=os.getenv('CV1000_MOTION')=='1'and assert(io.open(prefix..'.motion','wb'))
local motionRandoms=motions and assert(io.open(prefix..'.motion-randoms','w'))
local draws=os.getenv('CV1000_DRAW')=='1'and assert(io.open(prefix..'.draw','wb'))
local drawOps=draws and assert(io.open(prefix..'.draw-ops','w'))
local drawOrder=draws and assert(io.open(prefix..'.draw-order','w'))
local drawnSprites={}
local pendingDraw,drawCount,pendingSprite=nil,0,nil
local taps,tracked={},{}
local poseStacks,pendingPose,poseCount={},nil,0
local activeBoss,pendingMotion
local controlFile=os.getenv('CV1000_CONTROL')=='1'and assert(io.open(prefix..'.control','wb'))
local controlOps=controlFile and assert(io.open(prefix..'.control-ops','w'))
local pendingControl,controlCount,pendingReturn=nil,0,nil
local taskFile=os.getenv('CV1000_TASKS')=='1'and assert(io.open(prefix..'.tasks','wb'))
local taskOps=taskFile and assert(io.open(prefix..'.task-ops','w'))
local callbackOrder=taskFile and assert(io.open(prefix..'.callback-order','w'))
local callbackCount,pendingTask,taskReturn=0,nil,nil
local extraGuns=os.getenv('CV1000_GUNS')=='1'and assert(io.open(prefix..'.extra-guns','wb'))
local extraGunOps=extraGuns and assert(io.open(prefix..'.extra-gun-ops','w'))
local pendingGun,gunReturn,gunCount=nil,nil,0
local saves={}
for number in(os.getenv('CV1000_SAVE_FRAMES')or''):gmatch('%d+')do saves[tonumber(number)]=true end
local frame,loading=resume-1,true
local function signed(n)return(n+2147483648)%4294967296-2147483648 end
local function controls(body)
    local global=program:read_u32(0xc285720)
    local layer=program:read_u32(body+44)
    return program:read_u32(0xc38a4a4)==0 and program:read_i32(global+0xbc+layer*4)or 0,
        program:read_i32(global+0xcc+layer*4),program:read_i32(0xc38aaf4),program:read_i32(0xc38aaf8),
        program:read_u16(0xc38ab3c)==0 and 1 or 0
end
if motions then
    -- -nodrc 下取指也经过读取探针。只在首条指令和 rts 前保存，不改写原指令。
    local returns={[0xc14f630]=0xc14f670,[0xc14f690]=0xc14f6b2,[0xc14f6d0]=0xc14f76c,
        [0xc14f7e0]=0xc14f84c,[0xc14f870]=0xc14f924,[0xc14f960]=0xc14f9ba,
        [0xc14fa20]=0xc14fa5a,[0xc14fa80]=0xc14fb34}
    for entry,leave in pairs(returns)do
        local start=entry-entry%8
        taps[#taps+1]=program:install_read_tap(start,start+7,'关底移动入口',function()
            if cpu.state.PC.value~=entry or not activeBoss or frame+1<first then return end
            assert(not pendingMotion,'移动调用没有成对结束')
            local task=cpu.state.R6.value
            local params=program:read_u32(task+96)
            local config=cpu.state.R7.value
            local cfg={0,0,0}
            if entry==0xc14f7e0 or entry==0xc14f870 then
                for i=1,3 do cfg[i]=program:read_i32(config+(i-1)*4)end
            end
            local dx,camera,px,py,alive=controls(activeBoss)
            pendingMotion={body=activeBoss,task=task,leave=leave,
                header=string.pack('>I4I4i4i4i4i4I4i4i4i4',frame+1,entry,dx,camera,px,py,alive,table.unpack(cfg)),
                before=memory:read_block(activeBoss-0xc000000,0x3f50),
                params=params~=0 and memory:read_block(params-0xc000000,48)or string.rep('\0',48)}
        end)
        local finish=leave-leave%8
        taps[#taps+1]=program:install_read_tap(finish,finish+7,'关底移动返回',function()
            if not pendingMotion or cpu.state.PC.value~=pendingMotion.leave then return end
            local m=pendingMotion
            local params=program:read_u32(m.task+96)
            motions:write(m.header,string.pack('>I4',program:read_u32(m.task+4)),m.before,
                memory:read_block(m.body-0xc000000,0x3f50),m.params,
                params~=0 and memory:read_block(params-0xc000000,48)or string.rep('\0',48))
            pendingMotion=nil
        end)
    end
    taps[#taps+1]=program:install_read_tap(0xc063228,0xc06322f,'移动随机数返回',function()
        if cpu.state.PC.value~=0xc063228 or not pendingMotion then return end
        motionRandoms:write(frame+1,' ',cpu.state.PR.value,' ',signed(cpu.state.R0.value),'\n')
    end)
end
if draws then
    local function fetch(at,name,fn)
        local aligned=at-at%8
        taps[#taps+1]=program:install_read_tap(aligned,aligned+7,name,function()
            if cpu.state.PC.value==at then fn()end
        end)
    end
    fetch(0xc14c260,'关底绘制入口',function()
        if not activeBoss or frame+1<first then return end
        assert(not pendingDraw,'绘制调用没有成对结束')
        drawCount=drawCount+1
        local body,root,config=activeBoss,cpu.state.R4.value,cpu.state.R7.value
        local layer=program:read_u32(root+0x8fc)
        local color,alpha=program:read_u32(config),program:read_u32(config+4)
        pendingDraw={body=body,id=drawCount,
            header=string.pack('>I4I4i4i4i4i4i4',frame+1,drawCount,color==0 and -1 or color-body,
                alpha==0 and -1 or alpha-body,program:read_i32(root+0xa8)+program:read_i32(root+0xb8),
                -program:read_i32(layer+0x8c),-program:read_i32(layer+0x90)),
            before=memory:read_block(body-0xc000000,0x3f50)}
    end)
    fetch(0xc14d2a4,'关底绘制返回',function()
        if not pendingDraw then return end
        assert(not pendingSprite,'精灵调用没有成对结束')
        draws:write(pendingDraw.header,pendingDraw.before,memory:read_block(pendingDraw.body-0xc000000,0x3f50))
        pendingDraw=nil
    end)
    fetch(0xc063740,'关底精灵入口',function()
        if not pendingDraw then return end
        assert(not pendingSprite)
        pendingSprite={cpu.state.R4.value,signed(cpu.state.R5.value),signed(cpu.state.R6.value),signed(cpu.state.R7.value)}
    end)
    fetch(0xc063764,'关底精灵返回',function()
        if not pendingSprite then return end
        drawOps:write(pendingDraw.id,' S ',cpu.state.R0.value,' ',table.concat(pendingSprite,' '),'\n')
        drawnSprites[cpu.state.R0.value]={pendingDraw.id,pendingSprite[4]}
        pendingSprite=nil
    end)
    fetch(0xc05e534,'关底精灵提交顺序',function()
        local row=drawnSprites[cpu.state.R4.value]
        if row then drawOrder:write(frame+1,' ',row[1],' ',cpu.state.R4.value,' ',row[2],'\n')end
    end)
    for _,at in ipairs({0xc05e328,0xc05e2d8,0xc05e424})do
        fetch(at,'关底精灵属性',function()
            if not pendingDraw then return end
            drawOps:write(pendingDraw.id,' C ',at,' ',cpu.state.R4.value,' ',signed(cpu.state.R5.value),
                ' ',signed(cpu.state.R6.value),' ',signed(cpu.state.R7.value),'\n')
        end)
    end
    for _,at in ipairs({0xc09c4c0,0xc154b40,0xc10faf0})do
        fetch(at,'关底脚步事件',function()
            if pendingDraw then drawOps:write(pendingDraw.id,' E ',at,' ',cpu.state.R4.value,' ',cpu.state.R5.value,'\n')end
        end)
    end
end
if controlFile then
    local function fetch(at,name,fn)
        local aligned=at-at%8
        taps[#taps+1]=program:install_read_tap(aligned,aligned+7,name,function()
            if cpu.state.PC.value==at then fn()end
        end)
    end
    local function slot(manager,id)
        for i=0,4 do
            local at=manager+i*0x68
            if program:read_u16(at+6)~=0 and program:read_u16(at+4)==id%65536 then return at end
        end
        error('主任务句柄找不到槽位：'..id)
    end
    local function variables(at)
        local ptr=program:read_u32(at+96)
        return ptr~=0 and memory:read_block(ptr-0xc000000,80)or string.rep('\0',80)
    end
    local returns={[0xc14fe20]=0xc14fe52,[0xc14fbf0]=0xc14fc8e,[0xc14fe70]=0xc14ffb8,
        [0xc151610]=0xc1516a0,[0xc151880]=0xc15195e,[0xc1516e0]=0xc15171e,[0xc151ba0]=0xc151bf0,
        [0xc151740]=0xc151790,[0xc151d50]=0xc151da4,[0xc1517b0]=0xc1517f0,[0xc151eb0]=0xc151f04,
        [0xc151810]=0xc151860,[0xc1520b0]=0xc152104,[0xc1502a0]=0xc150304,[0xc1510a0]=0xc151110}
    for entry,leave in pairs(returns)do
        fetch(entry,'关底主任务入口',function()
            if not activeBoss or frame+1<first then return end
            assert(not pendingControl,'主任务调用没有成对结束')
            local id=cpu.state.R6.value
            local at=slot(cpu.state.R5.value,id)
            controlCount=controlCount+1
            pendingControl={body=activeBoss,at=at,leave=leave,entry=entry,id=controlCount,
                header=string.pack('>I4I4I4I4',frame+1,controlCount,entry,id),
                before=memory:read_block(activeBoss-0xc000000,0x3f50),vars=variables(at)}
        end)
        fetch(leave,'关底主任务返回',function()
            local c=pendingControl
            if not c or cpu.state.PC.value~=c.leave then return end
            assert(not pendingReturn,'主任务的辅助调用没有返回')
            controlFile:write(c.header,string.pack('>I4I4I4',program:read_u32(c.at+12),
                program:read_u16(c.at+6),cpu.state.R0.value),c.before,
                memory:read_block(c.body-0xc000000,0x3f50),c.vars,variables(c.at))
            pendingControl=nil
        end)
    end
    local returnSites={}
    local function helper(at)
        fetch(at,'关底主任务辅助调用',function()
            local c=pendingControl
            if not c then return end
            local pr=cpu.state.PR.value
            -- 嵌套的特效函数另行移植；这里仅记录主任务直接调用的接口。
            if pr<0xc14fbf0 or pr>=0xc152210 then return end
            assert(not pendingReturn,'主任务辅助调用发生嵌套')
            local values={}
            for i=4,7 do values[#values+1]=signed(cpu.state['R'..i].value)end
            local config=cpu.state.R6.value
            for i=0,7 do values[#values+1]=config>=0xc000000 and config+32<=0xc800000 and program:read_i32(config+i*4)or 0 end
            pendingReturn={pr=pr,id=c.id,at=at,values=values}
            if not returnSites[pr]then
                returnSites[pr]=true
                fetch(pr,'关底主任务辅助返回',function()
                    local h=pendingReturn
                    if not h or h.pr~=cpu.state.PC.value then return end
                    controlOps:write(h.id,' ',h.at,' ',table.concat(h.values,' '),' ',signed(cpu.state.R0.value),'\n')
                    pendingReturn=nil
                end)
            end
        end)
    end
    for _,at in ipairs({0xc078130,0xc077ea0,0xc0783f0,0xc078470,0xc0784e0,0xc0780a0,0xc078330,
        0xc0780c0,0xc0786a0,0xc078730,0xc0631f0,0xc14e290,0xc14e230,0xc14b5b0,0xc10ea20,
        0xc068150,0xc155960,0xc1561a0,0xc1561c0})do helper(at)end
    taps[#taps+1]=program:install_write_tap(0xc41b4a0,0xc41b4a7,'关底场景标志写入',function(_,data,mask)
        if not pendingControl or mask~=0xffffffff then return end
        local pc=cpu.state.PC.value
        if pc<0xc14fbf0 or pc>=0xc152210 then return end
        controlOps:write(pendingControl.id,' ',0xc41b4a4,' ',data&0xffffffff,
            ' 0 0 0 0 0 0 0 0 0 0 0 0\n')
    end)
end
if taskFile then
    local function fetch(at,name,fn)
        local aligned=at-at%8
        taps[#taps+1]=program:install_read_tap(aligned,aligned+7,name,function()
            if cpu.state.PC.value==at then fn()end
        end)
    end
    local ends={[0xc154a10]=0xc154b40,[0xc1548a0]=0xc154a10,[0xc154c80]=0xc154ce0,
        [0xc154ce0]=0xc154d30,[0xc1569e0]=0xc156a40,[0xc156130]=0xc1561a0,
        [0xc157b00]=0xc157be0,[0xc155060]=0xc1550d0,[0xc1550d0]=0xc155140,
        [0xc154ff0]=0xc155060,[0xc154ee0]=0xc154f80,[0xc154e40]=0xc154ee0,
        [0xc155750]=0xc1557b0,[0xc1556d0]=0xc155750,[0xc1558e0]=0xc155960,
        [0xc1557b0]=0xc155850,[0xc155850]=0xc1558e0,[0xc155ea0]=0xc155ef0,
        [0xc154dc0]=0xc154e40,[0xc154d30]=0xc154dc0,[0xc155660]=0xc1556d0,
        [0xc1555c0]=0xc155660,[0xc1551c0]=0xc155230,[0xc155230]=0xc1552a0,
        [0xc155140]=0xc1551c0,[0xc157150]=0xc157410,
        [0xc155da0]=0xc155ea0,[0xc156f10]=0xc157150}
    local function vars(at)
        local ptr=program:read_u32(at+96)
        return ptr~=0 and memory:read_block(ptr-0xc000000,128)or string.rep('\0',128)
    end
    for pc,pool in pairs({[0xc077e20]=2,[0xc077e40]=1,[0xc077e60]=0,[0xc077e72]=3})do
        fetch(pc,'关底任务分派前',function()
            if not activeBoss or frame+1<first or cpu.state.R10.value~=program:read_u32(activeBoss+36)then return end
            local fn=pool==3 and cpu.state.R1.value or cpu.state.R0.value
            callbackCount=callbackCount+1
            callbackOrder:write(frame+1,' ',callbackCount,' ',pool,' ',fn,' ',cpu.state.R6.value,' ',cpu.state.R9.value,'\n')
            if pool~=2 or not ends[fn]then return end
            assert(not pendingTask,'演出子任务没有成对结束')
            local at=cpu.state.R8.value
            pendingTask={body=activeBoss,at=at,entry=fn,last=ends[fn],id=callbackCount,
                leave=pc+4,header=string.pack('>I4I4I4I4I4I4',frame+1,callbackCount,pool,fn,
                    cpu.state.R6.value,cpu.state.R9.value),
                before=memory:read_block(activeBoss-0xc000000,0x3f50),vars=vars(at),
                config=memory:read_block(at+16-0xc000000,80)}
        end)
        fetch(pc+4,'关底任务分派后',function()
            local t=pendingTask
            if not t or cpu.state.PC.value~=t.leave then return end
            assert(not taskReturn,'演出子任务辅助调用没有返回')
            taskFile:write(t.header,string.pack('>I4I4I4',program:read_u32(t.at+12),program:read_u16(t.at+6),cpu.state.R0.value),
                t.before,memory:read_block(t.body-0xc000000,0x3f50),t.config,t.vars,vars(t.at))
            pendingTask=nil
        end)
    end
    local returns={}
    for _,helper in ipairs({0xc078130,0xc0781c0,0xc078230,0xc156240,0xc156420,0xc14e230,
        0xc14e2f0,0xc14e250,0xc14e270,0xc09c300,0xc09c330,0xc09c4c0,0xc0966d0,
        0xc0760b0,0xc0760d0,0xc156670})do
        fetch(helper,'关底子任务辅助调用',function()
            local t=pendingTask
            if not t then return end
            local pr=cpu.state.PR.value
            if pr<t.entry or pr>=t.last then return end
            assert(not taskReturn,'演出子任务辅助调用嵌套')
            local row={}
            for r=4,7 do row[#row+1]=signed(cpu.state['R'..r].value)end
            local config=cpu.state.R6.value
            for i=0,7 do row[#row+1]=config>=0xc000000 and config+32<=0xc800000 and program:read_i32(config+i*4)or 0 end
            for i=0,7 do row[#row+1]=program:read_i32(cpu.state.R15.value+i*4)end
            local point=cpu.state.R7.value
            row[#row+1]=point>=0xc000000 and point+8<=0xc800000 and program:read_i32(point)or 0
            row[#row+1]=point>=0xc000000 and point+8<=0xc800000 and program:read_i32(point+4)or 0
            taskReturn={pr=pr,id=t.id,helper=helper,row=row}
            if not returns[pr]then
                returns[pr]=true
                fetch(pr,'关底子任务辅助返回',function()
                    local h=taskReturn
                    if not h or h.pr~=cpu.state.PC.value then return end
                    taskOps:write(h.id,' ',h.helper,' ',table.concat(h.row,' '),' ',signed(cpu.state.R0.value),'\n')
                    taskReturn=nil
                end)
            end
        end)
    end
end
if extraGuns then
    local function fetch(at,name,fn)
        local aligned=at-at%8
        taps[#taps+1]=program:install_read_tap(aligned,aligned+7,name,function()
            if cpu.state.PC.value==at then fn()end
        end)
    end
    local selected={[0xc157d80]=true,[0xc158430]=true,[0xc157e30]=true,[0xc1585e0]=true}
    local function vars(slot)
        local ptr=program:read_u32(slot+96)
        return ptr~=0 and memory:read_block(ptr-0xc000000,96)or string.rep('\0',96)
    end
    fetch(0xc077e40,'关底跳跃及宽幅炮入口',function()
        if not activeBoss or frame+1<first or not selected[cpu.state.R0.value]then return end
        assert(not pendingGun)
        local slot=cpu.state.R8.value
        gunCount=gunCount+1
        pendingGun={id=gunCount,slot=slot,body=activeBoss,
            header={frame+1,gunCount,cpu.state.R0.value,cpu.state.R6.value,cpu.state.R9.value},
            before=memory:read_block(activeBoss-0xc000000,0x3f50),vars=vars(slot),
            config=memory:read_block(slot+16-0xc000000,80),
            inputs={program:read_u32(0xc38aaf4),program:read_u32(0xc38aaf8),program:read_u16(0xc38ab3c),
                program:read_u32(0xc3c4560),program:read_u32(cpu.state.R4.value+8)}}
    end)
    fetch(0xc077e44,'关底跳跃及宽幅炮返回',function()
        local g=pendingGun;if not g then return end
        assert(not gunReturn)
        local h=g.header;h[6],h[7]=program:read_u32(g.slot+12),program:read_u16(g.slot+6)
        for _,v in ipairs(g.inputs)do h[#h+1]=v end
        extraGuns:write(string.pack('>I4I4I4I4I4I4I4I4I4I4I4I4',table.unpack(h)),g.before,
            memory:read_block(g.body-0xc000000,0x3f50),g.config,g.vars,vars(g.slot))
        pendingGun=nil
    end)
    local returns={}
    for _,entry in ipairs({0xc0631f0,0xc154f80,0xc076b70,0xc076c10,0xc075750})do
        fetch(entry,'关底跳跃及宽幅炮接口',function()
            local g=pendingGun;if not g then return end
            local pr=cpu.state.PR.value
            if not((pr>=0xc157d80 and pr<0xc157ed0)or(pr>=0xc158430 and pr<0xc158780))then return end
            assert(not gunReturn)
            local values={}
            for i=4,7 do values[#values+1]=signed(cpu.state['R'..i].value)end
            for i=0,7 do values[#values+1]=program:read_i32(cpu.state.R15.value+i*4)end
            local cfg=cpu.state.R7.value
            for i=0,7 do values[#values+1]=cfg>=0xc000000 and cfg+32<=0xc800000 and program:read_i32(cfg+i*4)or 0 end
            gunReturn={pr=pr,id=g.id,entry=entry,values=values}
            if not returns[pr]then
                returns[pr]=true
                fetch(pr,'关底跳跃及宽幅炮接口返回',function()
                    local h=gunReturn;if not h or h.pr~=cpu.state.PC.value then return end
                    extraGunOps:write(h.id,' ',h.entry,' ',table.concat(h.values,' '),' ',signed(cpu.state.R0.value),'\n')
                    gunReturn=nil
                end)
            end
        end)
    end
end
local functions={[0xc158070]=15,[0xc157f80]=16,[0xc1581d0]=18}
local emitters={[0xc158114]=0xc158070,[0xc158016]=0xc157f80,
    [0xc15827e]=0xc1581d0,[0xc1582de]=0xc1581d0,[0xc15831c]=0xc1581d0}
-- 读取发弹禁入计数时，寄存器仍保留调用参数。以 PR 限定炮台，避免混入其它敌机。
taps[#taps+1]=program:install_read_tap(0xc38a4a8,0xc38a4af,'关底头炮发弹',function(_,data)
    local fn=emitters[cpu.state.PR.value]
    if not fn or(cpu.state.PC.value~=0xc076974 and cpu.state.PC.value~=0xc076b84)then return end
    local stack=cpu.state.R14.value
    shots:write(frame+1,' ',signed(cpu.state.R6.value),' ',signed(cpu.state.R7.value),' ',program:read_i32(stack+92),
        ' ',program:read_i32(stack+88),' ',cpu.state.R5.value,' ',(data>>32)&0xffffffff,' ',fn,
        ' ',fn==0xc157f80 and program:read_u32(stack+96)or 1,
        ' ',fn==0xc157f80 and program:read_u32(stack+100)or 0,'\n')
end)
local function track(body)
    activeBoss=body
    if tracked[body]then return end
    tracked[body]=true
    if poses then
        taps[#taps+1]=program:install_read_tap(body+48,body+55,'关底关节入口',function()
            if cpu.state.PC.value~=0xc14e46a then return end
            assert(not pendingPose,'关节调用没有成对结束')
            local stack=cpu.state.R14.value+88
            local aligned=stack-stack%8
            if not poseStacks[aligned]then
                poseStacks[aligned]=true
                taps[#taps+1]=program:install_read_tap(aligned,aligned+7,'关底关节返回',function()
                    if not pendingPose or cpu.state.PC.value~=0xc14eade then return end
                    poses:write(pendingPose.header,pendingPose.before,memory:read_block(pendingPose.body-0xc000000,0x3f50))
                    pendingPose=nil
                end)
            end
            local global=program:read_u32(0xc285720)
            local layer=program:read_u32(body+44)
            poseCount=poseCount+1
            local dx=program:read_u32(0xc38a4a4)==0 and program:read_i32(global+0xbc+layer*4)or 0
            pendingPose={body=body,before=memory:read_block(body-0xc000000,0x3f50),
                header=string.pack('>I4I4I4i4i4i4i4I4',frame+1,poseCount,cpu.state.PR.value,dx,
                    program:read_i32(global+0xcc+layer*4),program:read_i32(0xc38aaf4),program:read_i32(0xc38aaf8),
                    program:read_u16(0xc38ab3c)==0 and 1 or 0)}
        end)
    end
    taps[#taps+1]=program:install_write_tap(body+0x1ff8,body+0x2007,'关底血量',function(_,data,mask)
        hits:write('H ',frame+1,' ',cpu.state.PC.value,' ',data,' ',mask,'\n')
    end)
    taps[#taps+1]=program:install_write_tap(body+0x2008,body+0x200f,'关底受弹入口',function()
        if cpu.state.PC.value~=0xc14b6b8 then return end
        local event=cpu.state.R13.value
        hits:write('I ',frame+1,' ',program:read_i32(body+0x1ffc),' ',program:read_i32(body+0x22ec),
            ' ',program:read_i16(body+0x22ea),' ',program:read_i32(event+4),' ',program:read_i32(event),
            ' ',program:read_u32(0xc38a65c),'\n')
    end)
end

emu.register_frame_done(function()
    frame=frame+1
    if loading then loading=false;machine:load(state);return end
    drawnSprites={}
    fire:set_value(fireFrom and frame>=fireFrom and frame<=fireTo and 1 or 0)
    for _,key in ipairs(movement)do key[1]:set_value(frame>=key[2]and frame<=key[3]and 1 or 0)end
    if keepLives then
        local lives=program:read_u32(0xc38aabc)
        if lives&0xffffff00==0x01000000 and lives&255<3 then program:write_u32(0xc38aabc,0x01000003)end
    end
    if frame>=first then
        for slot=0,127 do
            local root=0xc41b560+slot*0x920
            if program:read_u32(root)==1 and program:read_u32(root+0x910)==0xc14b1b0 then
                local body=program:read_u32(root+0x900)
                assert(body%8==0,'本体没有按保存项的八字节边界对齐')
                actors:write(string.pack('>I4I4I4I4I4',frame,program:read_u32(0xc38a4a0),root,body,program:read_u32(root+0x40)))
                actors:write(memory:read_block(body-0xc000000,0x3f50))
                actors:write(memory:read_block(root-0xc000000,0x920))
                track(body)
                local manager=program:read_u32(body+36)
                for index=0,29 do
                    local task=manager+0x208+index*0x68
                    local fn=program:read_u32(task+12)
                    if functions[fn] and program:read_u16(task+6)~=0 then
                        local params=program:read_u32(task+96)
                        local row={frame,task,fn,program:read_u16(task+4),program:read_i32(body+8),program:read_i32(body+12),
                            program:read_i32(0xc38aaf4),program:read_i32(0xc38aaf8),program:read_u16(0xc38ab3c)}
                        for at=0,(functions[fn]-1)*4,4 do row[#row+1]=program:read_i32(params+at)end
                        guns:write(table.concat(row,' '),'\n')
                    end
                end
            end
        end
        scene:write(frame,' ',program:read_u32(0xc38a4a0),' ',program:read_u32(0xc38a4a4),' ',program:read_u32(0xc38a65c),
            ' ',program:read_u32(0xc38a4a8),'\n')
    end
    if saves[frame]then machine:save(prefix..'.state.'..frame..'.sta')end
    if frame>=last then
        for _,tap in ipairs(taps)do tap:remove()end
        if draws then assert(not pendingDraw);draws:close();drawOps:close();drawOrder:close()end
        if controlFile then assert(not pendingControl);controlFile:close();controlOps:close()end
        if taskFile then assert(not pendingTask);taskFile:close();taskOps:close();callbackOrder:close()end
        if extraGuns then assert(not pendingGun);extraGuns:close();extraGunOps:close()end
        if poses then assert(not pendingPose);poses:close()end
        if motions then assert(not pendingMotion);motions:close();motionRandoms:close()end
        actors:close();hits:close();guns:close();scene:close();shots:close();machine:exit()
    end
end)
