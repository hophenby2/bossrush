-- 第五面关底的独立指令探针：只记录真实调用，不改血量、坐标或换段条件。
-- 需要 -nodrc；保存项字节按八字节反序，文本字段则直接读 CPU 地址。
local machine=manager.machine
assert(emu.romname()=='futari15','只支持 Futari 1.5')
local cpu=machine.devices[':maincpu']
local program=cpu.spaces.program
local memory=emu.item(assert(cpu.items['0/:mainram']))
local prefix=assert(os.getenv('CV1000_TRACE'))
local state=assert(os.getenv('CV1000_STATE'))
local resume=assert(tonumber(os.getenv('CV1000_RESUME_FRAME')))
local last=assert(tonumber(os.getenv('CV1000_LAST')))
local file=assert(io.open(prefix..'.core','w'))
local bodies=assert(io.open(prefix..'.birth','wb'))
local poses=os.getenv('CV1000_POSE')=='1'and assert(io.open(prefix..'.pose','wb'))
local motions=os.getenv('CV1000_MOTION')=='1'and assert(io.open(prefix..'.motion','wb'))
local randoms=motions and assert(io.open(prefix..'.motion-randoms','w'))
local motionInputs=motions and assert(io.open(prefix..'.motion-inputs','w'))
local motionFX=motions and assert(io.open(prefix..'.motion-fx','w'))
local debugFile=os.getenv('CV1000_DEBUG')=='1'and assert(io.open(prefix..'.debug','w'))
local fire=machine.ioport.ports[':PORT_D'].fields['P1 Button 1']
local fireFrom,fireTo=(os.getenv('CV1000_FIRE')or''):match('^(%d+),(%d+)$')
fireFrom,fireTo=tonumber(fireFrom),tonumber(fireTo)
local bomb=machine.ioport.ports[':PORT_D'].fields['P1 Button 2']
local bombFrom,bombTo=(os.getenv('CV1000_BOMB')or''):match('^(%d+),(%d+)$')
bombFrom,bombTo=tonumber(bombFrom),tonumber(bombTo)
local keepLives=os.getenv('CV1000_KEEP_LIVES')=='1'
local fields={0x2604,0x2610,0x2634,0x2636,0x2638,0x263c,0x2640,
    0x2664,0x2668,0x267c,0x2680,0x2684,0x2688,0x268c,0x2690,
    0x2694,0x2698,0x269c,0x26a0,0x26a4,0x26a8,0x26ac,0x26b0,
    0x26b4,0x26b8,0x26bc,0x26c0,0x26c4,0x26c8,0x26cc}
local taps,returns,pending={},{},{}
local frame,loading,sequence,birthRoot=resume-1,true,0,nil
local poseCount,pendingPose,pendingMotion=0,nil,nil
local sampling=false
local pendingFX=nil
local function controls(body)
    local global=program:read_u32(0xc285720)
    local layer=program:read_u32(body+32)
    return program:read_u32(0xc38a4a4)==0 and program:read_i32(global+0xbc+layer*4)or 0,
        program:read_i32(global+0xcc+layer*4),program:read_i32(0xc38aaf4),program:read_i32(0xc38aaf8),
        program:read_u16(0xc38ab3c)==0 and 1 or 0
end
local function block(at,size)
    if at==0 then return string.rep('\0',size)end
    assert(at%8==0,'保存项不是八字节对齐')
    return memory:read_block(at-0xc000000,size)
end
local function values(body)
    local out={}
    for _,at in ipairs(fields)do
        out[#out+1]=(at==0x2634 or at==0x2636 or at==0x263c)
            and program:read_i16(body+at)or program:read_i32(body+at)
    end
    return table.concat(out,' ')
end
local function fetch(at,name,fn)
    local a=at-at%8
    taps[#taps+1]=program:install_read_tap(a,a+7,name,function()
        if cpu.state.PC.value==at then fn()end
    end)
end
local tracked,stacks,randomStacks={},{},{}
local function trackMovement(body,root)
    if tracked[body]or(not poses and not motions)then return end
    tracked[body]=true
    if debugFile then
        for _,offset in ipairs({8,32})do
            taps[#taps+1]=program:install_read_tap(body+offset,body+offset+7,'第五面入口排查',function(a)
                if not sampling then debugFile:write(('read %d %08x %08x\n'):format(frame+1,cpu.state.PC.value,a))end
            end)
        end
        taps[#taps+1]=program:install_write_tap(body+8,body+15,'第五面坐标排查',function(a)
            debugFile:write(('write %d %08x %08x\n'):format(frame+1,cpu.state.PC.value,a))
        end)
    end
    if poses then
      -- 数据访问时 PC 已前进两字节；采样读取还会经过同一探针，必须用 sampling 避免重入。
      taps[#taps+1]=program:install_read_tap(body+32,body+39,'第五面关底姿态数据入口',function()
        if sampling or cpu.state.PC.value~=0xc1b4c9a then return end
        sampling=true
        assert(not pendingPose)
        local dx,camera,px,py,alive=controls(body)
        poseCount=poseCount+1
        pendingPose={body=body,before=block(body,0x27a8),
            header=string.pack('>I4I4I4i4i4i4i4I4',frame+1,poseCount,cpu.state.PR.value,dx,camera,px,py,alive)}
        local stack=cpu.state.R14.value+52
        if debugFile then debugFile:write(('pose %08x %08x\n'):format(cpu.state.R14.value,stack))end
        stack=stack-stack%8
        if not stacks[stack]then
            stacks[stack]=true
            taps[#taps+1]=program:install_read_tap(stack,stack+7,'第五面关底姿态数据返回',function()
                if sampling then return end
                if debugFile then debugFile:write(('stack %08x\n'):format(cpu.state.PC.value))end
                if cpu.state.PC.value~=0xc1b5528 or not pendingPose then return end
                poses:write(pendingPose.header,pendingPose.before,block(pendingPose.body,0x27a8))
                pendingPose=nil
            end)
        end
        sampling=false
      end)
    end
    if not motions then return end
    local manager=program:read_u32(body+24)
    taps[#taps+1]=program:install_read_tap(manager+0x1658,manager+0x165f,'第五面关底移动槽数据入口',function()
        if sampling or cpu.state.PC.value~=0xc077d62 then return end
        local task=manager+0x1658
        sampling=true
        local fn=program:read_u32(task+4)
        if fn==0 then sampling=false;return end
        assert(not pendingMotion)
        local dx,camera,px,py,alive=controls(body)
        local cfg={}
        for at=0,24,4 do cfg[#cfg+1]=program:read_i32(task+16+at)end
        pendingMotion={body=body,task=task,before=block(body,0x27a8),params=block(program:read_u32(task+96),64),
            header=string.pack('>I4I4i4i4i4i4I4i4i4i4i4i4i4i4',frame+1,fn,dx,camera,px,py,alive,table.unpack(cfg))}
        motionInputs:write(frame+1,' ',program:read_u32(0xc38a4a0),'\n')
        sampling=false
    end)
    taps[#taps+1]=program:install_read_tap(manager,manager+7,'第五面关底移动槽数据返回',function()
        if sampling or cpu.state.PC.value~=0xc077d74 or not pendingMotion then return end
        sampling=true
        local p=pendingMotion
        motions:write(p.header,string.pack('>I4',program:read_u32(p.task+4)),p.before,block(p.body,0x27a8),
            p.params,block(program:read_u32(p.task+96),64))
        pendingMotion=nil
        sampling=false
    end)
end
if motions then
    taps[#taps+1]=program:install_read_tap(0xc517cb8,0xc517cbf,'第五面退场粒子请求',function()
        if sampling or not pendingMotion or cpu.state.PC.value~=0xc0966e0 then return end
        pendingFX={frame+1,cpu.state.R4.value,cpu.state.R8.value,cpu.state.R9.value,cpu.state.R7.value}
    end)
    -- 连分配失败的请求也保留；不能只看成功写入的粒子，把满池误当成控制器少发。
    taps[#taps+1]=program:install_write_tap(0xc7fe000,0xc7fffff,'第五面退场粒子速度请求',function()
        if not pendingMotion or not pendingFX or cpu.state.PC.value~=0xc096836 then return end
        motionFX:write(table.concat(pendingFX,' '),' ',cpu.state.R5.value,' ',cpu.state.R6.value,'\n')
        pendingFX=nil
    end)
    taps[#taps+1]=program:install_read_tap(0xc1ed590,0xc1ed597,'第五面移动随机入口数据',function()
        if sampling or cpu.state.PC.value~=0xc063204 or not pendingMotion then return end
        local stack=cpu.state.R14.value
        stack=stack-stack%8
        if randomStacks[stack]then return end
        randomStacks[stack]=true
        taps[#taps+1]=program:install_read_tap(stack,stack+7,'第五面移动随机返回数据',function()
            if not sampling and pendingMotion and cpu.state.PC.value==0xc063228 then
                sampling=true
                randoms:write(frame+1,' ',program:read_u32(cpu.state.R15.value),' ',cpu.state.R0.value,'\n')
                sampling=false
            end
        end)
    end)
end
local function installReturn(at)
    if returns[at]then return end
    returns[at]=true
    fetch(at,'第五面关底回调返回',function()
        local p=pending[#pending]
        if not p or p.leave~=at then return end
        file:write('R ',p.id,' ',cpu.state.R0.value,' ',values(p.body),'\n')
        pending[#pending]=nil
    end)
end
local function begin(kind,body,extra)
    assert(body>=0xc460000 and body<0xc800000,'本体指针超界')
    local leave=cpu.state.PR.value
    installReturn(leave)
    sequence=sequence+1
    local p={id=sequence,body=body,leave=leave}
    pending[#pending+1]=p
    file:write('I ',sequence,' ',frame+1,' ',kind,' ',extra or'',' ',values(body),'\n')
end
fetch(0xc1b09b0,'第五面关底累积伤害',function()
    local body=program:read_u32(cpu.state.R4.value+0x900)
    begin('body',body,tostring(program:read_u32(body+0x264c)))
end)
fetch(0xc1b07f0,'第五面关底真实伤害',function()
    local event,root=cpu.state.R4.value,cpu.state.R6.value
    local body=program:read_u32(root+0x900)
    local e={}
    for at=0,16,4 do e[#e+1]=program:read_i32(event+at)end
    begin('hit',body,table.concat(e,' '))
end)
fetch(0xc1b0dd0,'第五面关底倒数',function()
    begin('clock',cpu.state.R4.value,tostring(program:read_u32(0xc38a4a4)))
end)
fetch(0xc1b0fe0,'第五面关底换段',function()
    begin('change',cpu.state.R5.value,tostring(cpu.state.R4.value))
end)
fetch(0xc1b0290,'第五面关底构造入口',function()birthRoot=cpu.state.R4.value end)
fetch(0xc1b0642,'第五面关底构造返回',function()
    local root=assert(birthRoot)
    local body=program:read_u32(root+0x900)
    bodies:write(string.pack('>I4I4I4',frame+1,root,body),memory:read_block(body-0xc000000,0x27a8))
    file:write('B ',frame+1,' ',program:read_u32(body+28),' ',values(body),'\n')
    trackMovement(body,root)
end)
-- 将外部查询的结果单独记录，避免拿固定的自机复活倒数替代管理器状态。
for _,at in ipairs({0xc1b087e,0xc1b0c40,0xc1b0e5a})do
    fetch(at,'第五面击破抑制查询',function()
        if #pending>0 then file:write('Q ',pending[#pending].id,' ',cpu.state.R0.value,'\n')end
    end)
end
for _,at in ipairs({0xc1b094c,0xc1b095a,0xc1b0960,0xc1b096e,0xc1b0974,
    0xc1b0906,0xc1b0914,0xc1b091a,0xc1b092a,0xc1b0930,
    0xc1b089e,0xc1b08ac,0xc1b08b2,0xc1b08c2,0xc1b08c8,
    0xc1b0bec,0xc1b0bfa,0xc1b0c00,0xc1b0c10,0xc1b0c16,
    0xc1b0cb2,0xc1b0cc0,0xc1b0cc6,0xc1b0cd6,0xc1b0cda,
    0xc1b0c5e,0xc1b0c6a,0xc1b0c70,0xc1b0c80,0xc1b0c86})do
    fetch(at,'第五面关底来源查询返回',function()
        if #pending>0 then file:write('V ',pending[#pending].id,' ',at,' ',cpu.state.R0.value,'\n')end
    end)
end
for _,at in ipairs({0xc06ae10,0xc06b350,0xc06b4b0,0xc076900,0xc076680,0xc1b01a0})do
    fetch(at,'第五面关底事件接口',function()
        local p=pending[#pending]
        if p then file:write('E ',p.id,' ',at,' ',cpu.state.R4.value,' ',cpu.state.R5.value,
            ' ',cpu.state.R6.value,' ',cpu.state.R7.value,'\n')end
    end)
end
emu.register_frame_done(function()
    frame=frame+1
    if loading then loading=false;machine:load(state);return end
    local root=program:read_u32(0xc31c33c)
    if root~=0 then trackMovement(program:read_u32(root+0x900),root)end
    fire:set_value(fireFrom and frame>=fireFrom and frame<=fireTo and 1 or 0)
    bomb:set_value(bombFrom and frame>=bombFrom and frame<=bombTo and 1 or 0)
    if keepLives then
        local lives=program:read_u32(0xc38aabc)
        if lives&0xffffff00==0x01000000 and lives&255<3 then program:write_u32(0xc38aabc,0x01000003)end
    end
    if frame>=last then
        assert(#pending==0,'回调没有成对结束')
        assert(not sampling and not pendingPose and not pendingMotion,'姿态或移动没有成对结束')
        for _,tap in ipairs(taps)do tap:remove()end
        if poses then poses:close()end
        if motions then motions:close();randoms:close();motionInputs:close();motionFX:close()end
        if debugFile then debugFile:close()end
        file:close();bodies:close();machine:exit()
    end
end)
