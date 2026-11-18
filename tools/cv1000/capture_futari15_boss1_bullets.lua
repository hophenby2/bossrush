-- 第一面关底四种弹型的分配参数、首次绘制、更新和消弹独立探针；不改动敌弹。
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
local frame,loading,count=resume-1,true,0
local taps,tracked,counts={}, {}, {}
local pending,allocation,helperReturn=nil,nil,nil
local selected={[0x13]=true,[0x25]=true,[0x31]=true,[0x34]=true}
local limit=tonumber(os.getenv('CV1000_BULLET_LIMIT'))or 12
local function signed(n)return(n+2147483648)%4294967296-2147483648 end
local function fetch(at,fn)
    local aligned=at-at%8
    taps[#taps+1]=program:install_read_tap(aligned,aligned+7,'关底弹型探针',function()
        if cpu.state.PC.value==at then fn()end
    end)
end
fetch(0xc06e350,function()
    local kind=cpu.state.R4.value
    assert(not allocation)
    local stack=cpu.state.R15.value
    allocation={kind=kind,x=cpu.state.R5.value,y=cpu.state.R6.value,speed=cpu.state.R7.value,
        angle=program:read_u32(stack),rank=program:read_u32(0xc38a4ac),base=program:read_u16(0xc3c4562),
        enabled=selected[kind]and frame+1>=11093}
end)
fetch(0xc06e564,function()
    local a=allocation;if not a then return end
    local ptr=cpu.state.R0.value
    if ptr~=0 and a.enabled and(counts[a.kind]or 0)<limit then
        counts[a.kind]=(counts[a.kind]or 0)+1
        a.id=a.kind*1000+counts[a.kind];tracked[ptr]=a
    else tracked[ptr]=nil end
    allocation=nil
end)
local function start(fn)
    local ptr=fn==0xc06e6f0 and cpu.state.R6.value or cpu.state.R4.value
    local a=tracked[ptr];if not a then return end
    if program:read_u8(ptr+9)~=a.kind then tracked[ptr]=nil;return end
    assert(not pending)
    count=count+1
    pending={ptr=ptr,id=count,fn=fn,
        header={frame+1,count,fn,ptr,a.id,a.kind,a.x,a.y,a.angle,a.speed,a.rank,a.base,
            program:read_u32(0xc3c456c),program:read_u32(0xc3c4568),
            fn==0xc06e6f0 and program:read_u32(cpu.state.R4.value)or 0},
        before=memory:read_block(ptr-ptr%8-0xc000000,160)}
end
local function finish()
    local p=pending;if not p then return end
    assert(not helperReturn)
    file:write(string.pack('>I4I4I4I4I4I4I4I4I4I4I4I4I4I4I4',table.unpack(p.header)),p.before,
        memory:read_block(p.ptr-p.ptr%8-0xc000000,160))
    pending=nil
end
for entry,leave in pairs({[0xc06efd0]=0xc06f07c,[0xc06f0a0]=0xc06f1b0,
    [0xc0710f0]=0xc07119a,[0xc0711c0]=0xc0712d0,[0xc071330]=0xc0713e0,
    [0xc071400]=0xc071510,[0xc06f6a0]=0xc06f742,[0xc06eb50]=0xc06ec40,
    [0xc06e6f0]=0xc06e74a})do
    fetch(entry,function()start(entry)end);fetch(leave,finish)
end
local returns={}
for _,entry in ipairs({0xc063740,0xc05e2d8,0xc05e424})do
    fetch(entry,function()
        local p=pending;if not p then return end
        assert(not helperReturn)
        local pr=cpu.state.PR.value
        local values={}
        for i=4,7 do values[#values+1]=signed(cpu.state['R'..i].value)end
        helperReturn={pr=pr,id=p.id,entry=entry,values=values}
        if not returns[pr]then
            returns[pr]=true
            fetch(pr,function()
                local h=helperReturn;if not h or h.pr~=cpu.state.PC.value then return end
                ops:write(h.id,' ',h.entry,' ',table.concat(h.values,' '),' ',signed(cpu.state.R0.value),'\n')
                helperReturn=nil
            end)
        end
    end)
end
emu.register_frame_done(function()
    frame=frame+1
    if loading then loading=false;machine:load(state);return end
    fire:set_value(1)
    for _,key in ipairs(movement)do key[1]:set_value(frame>=key[2]and frame<=key[3]and 1 or 0)end
    local lives=program:read_u32(0xc38aabc)
    if lives&0xffffff00==0x01000000 and lives&255<3 then program:write_u32(0xc38aabc,0x01000003)end
    if frame>=last then
        assert(not pending and not allocation and not helperReturn)
        file:close();ops:close();for _,tap in ipairs(taps)do tap:remove()end
        machine:exit()
    end
end)
