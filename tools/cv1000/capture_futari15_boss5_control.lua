-- 第五面关底主任务的独立入口/返回、直接接口和场景标志探针；需要 -nodrc。
-- 不改血量、坐标或任务条件，只按正常按键射击并可补残机。
local machine=manager.machine
assert(emu.romname()=='futari15')
local cpu=machine.devices[':maincpu']
local program=cpu.spaces.program
local memory=emu.item(assert(cpu.items['0/:mainram']))
local prefix=assert(os.getenv('CV1000_TRACE'))
local state=assert(os.getenv('CV1000_STATE'))
local resume=assert(tonumber(os.getenv('CV1000_RESUME_FRAME')))
local last=assert(tonumber(os.getenv('CV1000_LAST')))
local file=assert(io.open(prefix..'.control','wb'))
local ops=assert(io.open(prefix..'.control-ops','w'))
local context=assert(io.open(prefix..'.control-context','w'))
local parts=assert(io.open(prefix..'.control-parts','w'))
local counter=assert(io.open(prefix..'.control-counter','w'))
local fire=machine.ioport.ports[':PORT_D'].fields['P1 Button 1']
local from,to=(os.getenv('CV1000_FIRE')or''):match('^(%d+),(%d+)$')
from,to=tonumber(from),tonumber(to)
local taps,tracked,helpers={},{},{}
local frame,loading,sampling,failed,count=resume-1,true,false,false,0
local pending
local function signed(n)return(n+2147483648)%4294967296-2147483648 end
local function guard(fn)
    return function(...)
        if sampling or failed then return end
        sampling=true
        local ok,err=xpcall(fn,debug.traceback,...)
        sampling=false
        if not ok then failed=true;io.stderr:write(tostring(err),'\n');io.stderr:flush();machine:exit()end
    end
end
local function block(a,size)
    if a==0 then return string.rep('\0',size)end
    assert(a%8==0,'保存项地址不是八字节对齐')
    return memory:read_block(a-0xc000000,size)
end
local function vars(at)return block(program:read_u32(at+96),128)end
local function external(root,body)
    local manager=program:read_u32(body+0x25a0)
    local box=manager~=0 and program:read_u32(manager+28)or 0
    return {program:read_i32(root+168)+program:read_i32(root+184),program:read_u16(root+96),
        program:read_i32(0xc41b498),program:read_i32(0xc41b49c),
        program:read_i32(0xc41b4a0),program:read_i32(0xc41b4a4),
        box~=0 and program:read_i32(box+24+20)or 0}
end
local function finish()
    if not pending then return end
    assert(#helpers==0,'主任务接口返回缺失')
    local p=pending
    file:write(p.header,string.pack('>I4I4',program:read_u32(p.slot+12),program:read_u16(p.slot+6)),
        p.before,block(p.body,0x27a8),p.config,p.vars,vars(p.slot))
    context:write(p.id,' ',table.concat(p.external,' '),' ',table.concat(external(p.root,p.body),' '),'\n')
    pending=nil
end
local function track(root)
    local body=program:read_u32(root+0x900)
    if tracked[body]then return end
    tracked[body]=true
    local manager=program:read_u32(body+24)
    taps[#taps+1]=program:install_read_tap(manager,manager+0x20f,'第五面主任务分派',guard(function(address)
        local pc=cpu.state.PC.value
        if pc==0xc077d74 or pc==0xc077d90 then finish();return end
        if pc~=0xc077e5a then return end
        local at=cpu.state.R8.value
        assert(at>=manager and at<=manager+4*0x68 and(at-manager)%0x68==0)
        assert(not pending)
        count=count+1
        pending={id=count,root=root,body=body,slot=at,entry=program:read_u32(at+12),external=external(root,body),
            header=string.pack('>I4I4I4I4I4',frame+1,count,(at-manager)//0x68,program:read_u16(at+4),program:read_u32(at+12)),
            before=block(body,0x27a8),config=block(at+16,80),vars=vars(at)}
        counter:write(count,' ',program:read_u8(0xc38a4a3),'\n')
    end))
    taps[#taps+1]=program:install_read_tap(manager+0x1658,manager+0x1667,'第五面移动入口查询',guard(function()
        if not pending or cpu.state.PC.value~=0xc07881a then return end
        local target=cpu.state.R5.value
        local args={manager,target}
        for i=3,20 do args[i]=0 end
        ops:write(pending.id,' ',0xc078810,' ',cpu.state.PR.value,' ',table.concat(args,' '),' ',
            program:read_u32(manager+0x165c)==target and 1 or 0,'\n')
    end))
end
local wanted={
    [0xc078130]=true,[0xc077ea0]=true,[0xc0783f0]=true,[0xc0780a0]=true,[0xc078330]=true,[0xc0631f0]=true,
    [0xc078470]=false,[0xc0784e0]=false,[0xc0780c0]=false,[0xc078380]=false,[0xc0786a0]=false,[0xc078730]=false,
    [0xc10ea20]=false,[0xc10ef10]=false,[0xc068150]=false,[0xc075d30]=false,[0xc075c00]=false,
    [0xc1b06f0]=false,[0xc1b0250]=false,[0xc1b4650]=false,[0xc1b57d0]=false,[0xc1b5830]=true,
    [0xc1b5860]=false,[0xc1b9160]=false,[0xc078020]=false,[0xc078560]=false,[0xc0782b0]=false,
    [0xc1bbac0]=false,
    [0xc1b9440]=false,[0xc1bbbc0]=false,[0xc1bbd30]=false,[0xc1bbda0]=false,
    [0xc110a10]=false,[0xc110a30]=false,[0xc10f9b0]=false,[0xc075bd0]=false,
    [0xc0768f0]=true,[0xc076870]=true,[0xc06b920]=true,
    [0xc093e90]=false,[0xc06b370]=false,[0xc0680b0]=false,
    [0xc0966d0]=false,[0xc096830]=false,[0xc096930]=false,[0xc096870]=false,[0xc096890]=false,
    [0xc0968b0]=false,[0xc0968d0]=false,[0xc096910]=false,[0xc096950]=false,
    [0xc0992c0]=false,[0xc099380]=false,[0xc099c90]=false,[0xc1b92f0]=false,
    [0xc09c4c0]=false,[0xc1b45f0]=false,[0xc1bbf40]=false,[0xc1bbea0]=false,[0xc1bbfe0]=false,
    [0xc10ee50]=false,[0xc10ed70]=false,[0xc10efd0]=false,
    [0xc0689e0]=false,[0xc068a00]=false,[0xc068d00]=false,[0xc076850]=false,
    [0xc063740]=false,[0xc05e424]=false,[0xc05e328]=false,[0xc05e338]=false,
}
local leaves={[0xc0768f0]=true,[0xc076870]=true,[0xc06b920]=true}
local entries={}
for at,needsReturn in pairs(wanted)do
    -- 这里只在第一处栈保存取参数；它之前的指令不改 r4..r7。
    local offset=(at==0xc078730 or at==0xc10ea20 or at==0xc0689e0)and 4
        or(at==0xc0680b0 or at==0xc068d00)and 6 or at==0xc05e424 and 12 or 2
    entries[at+offset]={at,needsReturn}
end
local function emit(h,result)
    ops:write(h.id,' ',h.at,' ',h.caller,' ',table.concat(h.args,' '),' ',signed(result),'\n')
end
taps[#taps+1]=program:install_write_tap(0xc7fe000,0xc7fffff,'第五面主任务接口入栈',guard(function()
    if not pending then return end
    local spec=entries[cpu.state.PC.value]
    if not spec then return end
    local caller=cpu.state.PR.value
    if caller<0xc1b6750 or caller>=0xc1be000 then return end
    if(caller>=0xc1b9160 and caller<0xc1b95f0)or caller>=0xc1bbac0 then return end
    local args={}
    for r=4,7 do args[#args+1]=signed(cpu.state['R'..r].value)end
    local config=cpu.state.R6.value
    for i=0,7 do args[#args+1]=config>=0xc000000 and config+32<=0xc800000 and program:read_i32(config+i*4)or 0 end
    for i=0,7 do args[#args+1]=program:read_i32(cpu.state.R15.value+4+i*4)end
    local h={id=pending.id,at=spec[1],caller=caller,args=args,leaf=leaves[spec[1]]}
    if spec[1]==0xc1b9160 or spec[1]==0xc1b9440 then
        parts:write(pending.id,' ',spec[1],' ',caller,' ',args[2]-args[1],' ',args[3],' ',args[4],
            ' ',program:read_i32(args[13]),' ',program:read_i32(args[13]+4),' ',args[14],' ',args[15],'\n')
    end
    if spec[1]==0xc1b92f0 then
        parts:write(pending.id,' ',spec[1],' ',caller,' -1 ',args[1],' ',args[2],
            ' ',program:read_i32(args[3]),' ',program:read_i32(args[3]+4),' ',args[4],' ',args[13],'\n')
    end
    if spec[2]then helpers[#helpers+1]=h else emit(h,0)end
end))
taps[#taps+1]=program:install_read_tap(0xc7fe000,0xc7fffff,'第五面主任务接口出栈',guard(function()
    if not pending or #helpers==0 then return end
    local pc=cpu.state.PC.value
    local h=helpers[#helpers]
    -- 叶函数在 rts 的延迟槽读回 r14，此时 PC 已经是调用方的返回地址。
    if h.leaf and pc==h.caller then
        emit(h,cpu.state.R0.value);helpers[#helpers]=nil;return
    end
    if program:read_u16(pc-2)~=0x4f26 then return end
    if program:read_u32(cpu.state.R15.value)~=h.caller then return end
    emit(h,cpu.state.R0.value);helpers[#helpers]=nil
end))
taps[#taps+1]=program:install_write_tap(0xc41b498,0xc41b4a7,'第五面主任务场景标志',guard(function(address,data,mask)
    if not pending then return end
    local pc=cpu.state.PC.value
    if (pc<0xc1b6750 or pc>=0xc1be000)and pc~=0xc078470 and pc~=0xc10ea20 then return end
    for i=0,1 do
        local at=address+i*4
        local shift=(1-i)*32
        -- MAME 会把高半掩码以 double 传入，超过有符号 int64，不能直接做位移。
        if math.floor(mask/2^shift)%4294967296~=0 then
            local h={id=pending.id,at=at,caller=pc,args={signed(math.floor(data/2^shift)%4294967296)}}
            for n=2,20 do h.args[n]=0 end
            emit(h,0)
        end
    end
end))
emu.register_frame_done(guard(function()
    frame=frame+1
    if loading then loading=false;machine:load(state);return end
    local root=program:read_u32(0xc31c33c)
    if root~=0 then track(root)end
    fire:set_value(from and frame>=from and frame<=to and 1 or 0)
    if os.getenv('CV1000_KEEP_LIVES')=='1'then
        local lives=program:read_u32(0xc38aabc)
        if lives&0xffffff00==0x01000000 and lives&255<3 then program:write_u32(0xc38aabc,0x01000003)end
    end
    if frame>=last then
        assert(not pending and #helpers==0,'主任务没有完整返回')
        for _,tap in ipairs(taps)do tap:remove()end
        file:close();ops:close();context:close();parts:close();counter:close();machine:exit()
    end
end))
