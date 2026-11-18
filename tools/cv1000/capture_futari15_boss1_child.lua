-- 0xa2 子敌机的构造、更新和绘制独立探针；只补残机，不修改敌机或自机坐标。
local machine=manager.machine
assert(emu.romname()=='futari15')
local cpu=machine.devices[':maincpu'];local program=cpu.spaces.program
local memory=emu.item(assert(cpu.items['0/:mainram']))
local prefix=assert(os.getenv('CV1000_TRACE'))
local resume=assert(tonumber(os.getenv('CV1000_RESUME_FRAME')))
local last=assert(tonumber(os.getenv('CV1000_LAST')))
local state=assert(os.getenv('CV1000_STATE'))
local fire=machine.ioport.ports[':PORT_D'].fields['P1 Button 1']
local file=assert(io.open(prefix..'.child-steps','wb'))
local ops=assert(io.open(prefix..'.child-ops','w'))
local frame,loading,count=resume-1,true,0
local taps,pending,helperReturn={},nil,nil
local function signed(n)return(n+2147483648)%4294967296-2147483648 end
local function fetch(at,fn)
    local aligned=at-at%8
    taps[#taps+1]=program:install_read_tap(aligned,aligned+7,'关底子敌机探针',function()
        if cpu.state.PC.value==at then fn()end
    end)
end
local function start(kind)
    assert(not pending)
    count=count+1
    local root=cpu.state.R4.value
    local body=kind==0 and 0 or program:read_u32(root+0x900)
    pending={kind=kind,root=root,id=count,
        header={frame+1,count,kind,root,program:read_u32(root+0x914)},
        before=body~=0 and memory:read_block(body-0xc000000,160)or string.rep('\0',160),
        config=memory:read_block(root+120-0xc000000,48),
        x=program:read_u32(root+32),y=program:read_u32(root+36)}
end
local function finish()
    local p=assert(pending);assert(not helperReturn)
    local body=program:read_u32(p.root+0x900)
    -- c075a90 先置 +112 的待回收标记，根槽到队列末尾才清空；不能把它继续算作存活。
    local active=program:read_u32(p.root)==1 and program:read_u32(p.root+112)==0 and 1 or 0
    local h=p.header;h[6],h[7],h[8],h[9]=body,active,p.x,p.y
    file:write(string.pack('>I4I4I4I4I4I4I4I4I4',table.unpack(h)),p.before,
        body~=0 and memory:read_block(body-0xc000000,160)or string.rep('\0',160),p.config)
    pending=nil
end
fetch(0xc15e250,function()start(0)end)
fetch(0xc15e386,finish)
fetch(0xc15e450,function()start(1)end)
fetch(0xc15e4a0,finish)
fetch(0xc15e1a0,function()start(2)end)
fetch(0xc15e22a,finish)
local returns={}
for _,entry in ipairs({0xc0631f0,0xc068c80,0xc076030,0xc076780,0xc063740,0xc15e600,0xc076960})do
    fetch(entry,function()
        local p=pending;if not p then return end
        local pr=cpu.state.PR.value
        if pr<0xc15e1a0 or pr>=0xc15e600 then return end
        assert(not helperReturn)
        local values={}
        for i=4,7 do values[#values+1]=signed(cpu.state['R'..i].value)end
        for i=0,3 do values[#values+1]=program:read_i32(cpu.state.R15.value+i*4)end
        helperReturn={pr=pr,id=p.id,entry=entry,values=values}
        if not returns[pr]then
            returns[pr]=true
            fetch(pr,function()
                local h=helperReturn;if not h or cpu.state.PC.value~=h.pr then return end
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
    local lives=program:read_u32(0xc38aabc)
    if lives&0xffffff00==0x01000000 and lives&255<3 then program:write_u32(0xc38aabc,0x01000003)end
    if frame>=last then
        assert(not pending and not helperReturn)
        file:close();ops:close();for _,tap in ipairs(taps)do tap:remove()end
        machine:exit()
    end
end)
