-- 第五面关底八种弹型的原版构造、运动、图形及真实消弹探针；不修改敌弹或炮台。
local machine=manager.machine
assert(emu.romname()=='futari15')
local cpu=machine.devices[':maincpu'];local program=cpu.spaces.program
local memory=emu.item(assert(cpu.items['0/:mainram']))
local prefix=assert(os.getenv('CV1000_TRACE'))
local resume=assert(tonumber(os.getenv('CV1000_RESUME_FRAME')))
local last=assert(tonumber(os.getenv('CV1000_LAST')))
local state=assert(os.getenv('CV1000_STATE'))
local fire=machine.ioport.ports[':PORT_D'].fields['P1 Button 1']
local movement={}
for _,name in ipairs({'Left','Right','Up','Down'})do
    local from,to=(os.getenv('CV1000_'..name:upper())or''):match('^(%d+),(%d+)$')
    if from then movement[#movement+1]={machine.ioport.ports[':PORT_D'].fields['P1 '..name],tonumber(from),tonumber(to)}end
end
local file=assert(io.open(prefix..'.bullet-steps','wb'))
local ops=assert(io.open(prefix..'.bullet-ops','w'))
local factories=assert(io.open(prefix..'.bullet-factories','w'))
local results=assert(io.open(prefix..'.bullet-results','w'))
local frame,loading,count=resume-1,true,0
local taps,tracked,counts={}, {}, {}
local pending,allocation,helperReturn=nil,nil,nil
local job,jobCount=nil,0
local selected={[18]=true,[19]=true,[21]=true,[37]=true,[46]=true,[51]=true,[58]=true,[59]=true}
local limit=tonumber(os.getenv('CV1000_BULLET_LIMIT'))or 8
local firstBullet=tonumber(os.getenv('CV1000_BULLET_FROM'))or resume
local function signed(n)return(n+2147483648)%4294967296-2147483648 end
local sampling,failed=false,false
local function guard(fn)
    return function(...)
        if sampling or failed then return end
        sampling=true
        local ok,err=xpcall(fn,debug.traceback,...)
        sampling=false
        if not ok then
            failed=true;io.stderr:write(tostring(err),'\n');io.stderr:flush();machine:exit()
        end
    end
end
local function fetch(at,fn)
    local aligned=at-at%8
    taps[#taps+1]=program:install_read_tap(aligned,aligned+7,'关底弹型探针',guard(function()
        if cpu.state.PC.value==at then fn()end
    end))
end
local function allocate()
    assert(not allocation,'构造重入')
    local stack=cpu.state.R15.value+4
    local kind=cpu.state.R4.value
    allocation={kind=kind,x=cpu.state.R5.value,y=cpu.state.R6.value,speed=cpu.state.R7.value,
        angle=program:read_u32(stack),rank=program:read_u32(0xc38a4ac),base=program:read_u16(0xc3c4562),
        depthFlag=program:read_i32(stack+8),camera=0,enabled=selected[kind]and frame+1>=firstBullet}
    if job then allocation.job=job end
end
local function allocated()
    local a=allocation;if not a then return end
    local ptr=cpu.state.R0.value
    if a.job then
        factories:write('A ',a.job,' ',a.kind,' ',signed(a.x),' ',signed(a.y),' ',signed(a.speed),
            ' ',a.angle,' ',a.depthFlag,' ',ptr~=0 and 1 or 0,'\n')
    end
    local key=a.kind..':'..a.depthFlag..':'..math.floor((a.base+signed(a.speed)+math.floor(a.rank/32))/32)
    if ptr~=0 and a.enabled and(counts[key]or 0)<limit then
        counts[key]=(counts[key]or 0)+1
        a.id=(counts.total or 0)+1;counts.total=a.id;tracked[ptr]=a
    else tracked[ptr]=nil end
    allocation=nil
end
fetch(0xc06e3f6,function()if allocation then allocation.camera=signed(cpu.state.R0.value)end end)
local function start(fn)
    local ptr=fn==0xc06e6f0 and cpu.state.R6.value or cpu.state.R4.value
    local a=tracked[ptr];if not a then return end
    if program:read_u8(ptr+9)~=a.kind then tracked[ptr]=nil;return end
    assert(not pending)
    count=count+1
    pending={ptr=ptr,id=count,fn=fn,
        header={frame+1,count,fn,ptr,a.id,a.kind,a.x,a.y,a.angle,a.speed,a.rank,a.base,
            program:read_u32(0xc3c456c),program:read_u32(0xc3c4568),
            fn==0xc06e6f0 and program:read_u32(cpu.state.R4.value)or 0,a.depthFlag%4294967296,a.camera%4294967296},
        before=memory:read_block(ptr-ptr%8-0xc000000,160)}
end
local function finish()
    local p=pending;if not p then return end
    assert(not helperReturn)
    results:write(p.id,' ',signed(cpu.state.R0.value),'\n')
    file:write(string.pack('>I4I4I4I4I4I4I4I4I4I4I4I4I4I4I4I4I4',table.unpack(p.header)),p.before,
        memory:read_block(p.ptr-p.ptr%8-0xc000000,160))
    pending=nil
end
local returns={
    [0xc06ef00]=0xc06efa4,[0xc06efd0]=0xc06f074,[0xc06fc10]=0xc06fcaa,
    [0xc0710f0]=0xc071192,[0xc06f6a0]=0xc06f73a,[0xc0721b0]=0xc07224a,
    [0xc070960]=0xc070a02,[0xc06f200]=0xc06f29a,[0xc06f0a0]=0xc06f1a4,
    [0xc06f770]=0xc06f870,[0xc0711c0]=0xc0712c4,[0xc06eb50]=0xc06ec34,
    [0xc070660]=0xc070764,[0xc06e6f0]=0xc06e744,
    [0xc06df20]=0xc06df6e,
}
local entries={};for fn in pairs(returns)do entries[fn+2]=fn end
local function helper(entry)
    if not pending then return end
    local values={};for i=4,7 do values[#values+1]=signed(cpu.state['R'..i].value)end
    if entry==0xc063740 then
        assert(not helperReturn,'精灵请求重入')
        helperReturn={id=pending.id,entry=entry,values=values}
    else ops:write(pending.id,' ',entry,' ',table.concat(values,' '),' 0\n')end
end
-- 第一次入栈与自身 PR 弹栈都走数据探针，避免取指预读漏掉早退路径。
taps[#taps+1]=program:install_write_tap(0xc7fe000,0xc7fffff,'敌弹入口',guard(function()
    local pc=cpu.state.PC.value
    if pc==0xc06e352 then allocate()
    elseif entries[pc]then start(entries[pc])
    elseif pc==0xc063742 then helper(0xc063740)end
    if pc==0xc093cd2 then helper(0xc093cd0)end
end))
taps[#taps+1]=program:install_read_tap(0xc7fe000,0xc7fffff,'敌弹返回',guard(function()
    local pc=cpu.state.PC.value
    if pc==0xc06e558 then allocated()
    elseif pc==0xc063760 and helperReturn then
        local h=helperReturn
        ops:write(h.id,' ',h.entry,' ',table.concat(h.values,' '),' ',signed(cpu.state.R0.value),'\n')
        helperReturn=nil
    elseif pending and returns[pending.fn]==pc then finish()end
end))
for _,entry in ipairs({0xc05e2d8,0xc05e424})do fetch(entry,function()helper(entry)end)end
local function finishJob()if job then factories:write('E ',job,'\n');job=nil end end
local function jobTap()
    local root=program:read_u32(0xc28503c)
    if root==0 then return end
    local first=root+0x4845c
    taps[#taps+1]=program:install_read_tap(first-first%8,math.ceil((first+500*0x68)/8)*8-1,'敌弹队列展开',guard(function()
        if cpu.state.PC.value~=0xc06dcbc then return end
        finishJob()
        local at=cpu.state.R13.value
        local mode=program:read_u8(at)
        if mode~=1 and mode~=2 then return end
        local kind=program:read_u8(at+1)
        if not selected[kind]or program:read_u32(at+32)~=program:read_u32(0xc31c33c)then return end
        jobCount=jobCount+1;job=jobCount
        local values={kind,program:read_i32(at+4),program:read_i32(at+8),program:read_i16(at+12),
            program:read_u16(at+14),program:read_i16(at+16),mode,
            program:read_u16(at+18),program:read_u16(at+20),program:read_u16(at+22),
            program:read_u16(at+24),program:read_u16(at+26),program:read_i16(at+28),
            program:read_i32(root+0x4843c+12),program:read_i32(root+0x4843c+16)}
        factories:write('J ',frame+1,' ',job,' ',table.concat(values,' '),'\n')
    end))
end
local attached=false
emu.register_frame_done(guard(function()
    frame=frame+1
    if loading then loading=false;machine:load(state);return end
    if not attached then jobTap();attached=true end
    finishJob()
    fire:set_value(1)
    for _,key in ipairs(movement)do key[1]:set_value(frame>=key[2]and frame<=key[3]and 1 or 0)end
    local lives=program:read_u32(0xc38aabc)
    if lives&0xffffff00==0x01000000 and lives&255<3 then program:write_u32(0xc38aabc,0x01000003)end
    if frame>=last then
        assert(not pending and not allocation and not helperReturn)
        file:close();ops:close();factories:close();results:close();for _,tap in ipairs(taps)do tap:remove()end
        machine:exit()
    end
end))
