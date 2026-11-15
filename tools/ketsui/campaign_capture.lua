-- 采集绊地狱通关流程。首个关底用实测可复现的受击输入触发击破。
local machine = manager.machine
local mem = machine.devices[':maincpu'].spaces.program
local mode = os.getenv('KET_MODE') or 'campaign'
local first = assert(tonumber(os.getenv('KET_FIRST')))
local last = assert(tonumber(os.getenv('KET_LAST')))
local observer = os.getenv('KET_OBSERVE')=='1'
local file = assert(io.open(assert(os.getenv('KET_TRACE')), 'wb'))
local ramStart,ramEnd = 0x80fe00,0x81a7ff
local frame=0

local function key(port, name, down)
    machine.ioport.ports[port].fields[name]:set_value(down and 1 or 0)
end

local function press(a,b)
    return frame>=a and frame<b
end

local function dump(address, size)
    file:write(mem:read_range(address,address+size-1,8))
end

local function observe()
    local groups={}
    for group=0x812744,0x813914,80 do
        if mem:read_u16(group)&0x8000~=0 and mem:read_u16(group+4)>=3 then
            local part=mem:read_u32(group+6)
            if part>=0x813964 and part+42<=0x815aa2 then
                groups[#groups+1]={group,part}
            end
        end
    end
    file:write(string.pack('>I4I2I2I2I2',frame,mem:read_u16(0xb03000),
        mem:read_u16(0x8124a6),mem:read_u16(0x812440),#groups))
    for _,g in ipairs(groups) do
        file:write(string.pack('>I4',g[1]))
        dump(g[1],80)
        dump(g[2],42)
    end
end

local function stageOneDamage()
    if frame~=10000 and frame~=10600 and frame~=11500 and frame~=12900 and frame~=14000 then return end
    for group=0x812744,0x813914,80 do
        if mem:read_u16(group)&0x8000~=0 and mem:read_u16(group+12)==0x7080 then
            if frame==10000 or frame==10600 then
                for _,offset in ipairs({0x1a,0x1e,0x22,0x26,0x2a,0x2e}) do
                    mem:write_u32(group+offset,0xfffffffe)
                end
            else
                local part=mem:read_u32(group+6)
                mem:write_u32(group+0x16,0xfffffffe)
                mem:write_u16(part+0x18,0x7ffe)
                mem:write_u8(part,0xe0)
            end
        end
    end
end

emu.register_frame_done(function()
    frame=frame+1
    key(':Service','Coin 1',press(1860,1900))
    key(':P1P2','1 Player Start',press(1930,1970))
    key(':P1P2','P1 Button 1',press(2100,2140) or frame>=2700 and frame%4<2)
    key(':P1P2','P1 Right',mode=='shift' and press(2700,2720))
    if frame>=2580 and mem:read_u16(0x80fea2)>=0x8000 then mem:write_u8(0x80fedc,0x70) end
    stageOneDamage()
    if not observer and frame==first then file:write('PGM2',string.pack('>I4I4',ramStart,ramEnd)) end
    if observer and frame>=first and frame%12==0 then
        observe()
    elseif not observer and frame>=first then
        file:write(string.pack('>I4',frame))
        dump(0x800000,0xa00)
        dump(ramStart,ramEnd-ramStart+1)
        dump(0x900000,0x1000)
        dump(0x907000,0x1c0)
        dump(0xa00000,0x1200)
        for _,address in ipairs({0xb02000,0xb03000,0xb0e000}) do dump(address,2) end
    end
    if frame==last then file:close();machine:exit() end
end)
