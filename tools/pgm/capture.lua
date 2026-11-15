-- ShmupMAME 5.4 离线采样。运行游戏时无需模拟器。
local machine = manager.machine
local mem = machine.devices[':maincpu'].spaces.program
local game = assert(os.getenv('PGM_GAME'))
local output = assert(io.open(assert(os.getenv('PGM_TRACE')), 'wb'))
local shifted = os.getenv('PGM_MODE') == 'shift'
local doj = game == 'ddpdoj'
local p1 = doj and 0x81035a or 0x80ee96
local protect = p1 + (doj and 0x3e or 0x39)
local first = tonumber(os.getenv('PGM_FIRST')) or 1300
local last = assert(tonumber(os.getenv('PGM_LAST')))
local route = os.getenv('PGM_BOSS_ROUTE')
local observe = os.getenv('PGM_OBSERVE') == '1'
local ramStart = 0x80ee00
local ramEnd = 0x81b7ff
local frame = 0

local function input(port, name, first, duration)
    machine.ioport.ports[port].fields[name]:set_value(frame >= first and frame < first + duration and 1 or 0)
end

emu.register_frame_done(function()
    frame = frame + 1
    input(':Service', 'Coin 1', doj and 880 or 2170, 6)
    input(':P1P2', '1 Player Start', doj and 940 or 2210, 12)
    local a = doj and (frame >= 1030 and frame < 1042 or frame >= 1058 and frame < 1070)
        or not doj and (frame >= 2290 and frame < 2302 or frame >= 2460 and frame < 2510)
    machine.ioport.ports[':P1P2'].fields['P1 Button 1']:set_value(a and 1 or 0)
    input(':P1P2', 'P1 Down', 2420, doj and 0 or 10)
    input(':P1P2', 'P1 Right', doj and 1500 or 2880, shifted and 30 or 0)
    if frame >= 1150 and mem:read_u16(p1) >= 0x8000 then mem:write_u8(protect, 0x70) end
    if route then
        -- 离线触发原作状态迁移，采样程序实际生成的部件和弹幕。
        local group = doj and 0x813648 or 0x814b40
        if doj and mem:read_u16(group+12)==0x0e80 then
            if frame==8350 and route~='right' then mem:write_u32(group+0x1a,0xfffffffe) end
            if frame==8350 and route=='right' then mem:write_u32(group+0x1e,0xfffffffe) end
            if frame==9200 then mem:write_u32(group+0x16,0xfffffffe) end
        elseif not doj and mem:read_u16(group+12)==0x6080 then
            local part = mem:read_u32(group+6)
            if frame==8700 then
                mem:write_u32(group+0x1a,0xfffffffe)
                mem:write_u8(part,0xe0)
            elseif frame==9550 then
                mem:write_u32(group+0x1e,0xfffffffe)
                mem:write_u8(part,0xe0)
            end
        end
        if route=='campaign' or route=='stage3' or route=='later' or route=='final' or route=='clear' then
            local nextGroup = doj and 0x813648 or 0x8149b0
            if doj and frame==21100 and mem:read_u16(nextGroup+12)==0x3080 then
                mem:write_u32(nextGroup+0x16,0xfffffffe)
            elseif not doj and mem:read_u16(nextGroup+12)==0x6a80 then
                local nextPart=mem:read_u32(nextGroup+6)
                if frame==20400 then
                    mem:write_u32(nextGroup+0x16,0x192ff)
                    mem:write_u8(nextPart,0xe1)
                elseif frame==21100 then
                    mem:write_u32(nextGroup+0x16,0xfffffff0)
                    mem:write_u8(nextPart,0xe1)
                elseif frame==21800 then
                    mem:write_u32(nextGroup+0x16,0xfffffff0)
                    mem:write_u8(nextPart,0xe1)
                end
            end
        end
        if route=='later' or route=='final' or route=='clear' then
            local group3 = doj and 0x8135a8 or 0x814960
            local kind = doj and 0xa080 or 0x6d80
            if mem:read_u16(group3+12)==kind then
                local part = mem:read_u32(group3+6)
                if frame==35200 then
                    mem:write_u32(group3+0x16,doj and 0x117ff or 0x33cc0)
                    mem:write_u8(part,0xe1)
                elseif frame==36500 then
                    mem:write_u32(group3+0x16,doj and 0xfffffffe or 0x168c0)
                    mem:write_u8(part,0xe1)
                elseif not doj and frame==37500 then
                    mem:write_u32(group3+0x16,0xfffffffe)
                    mem:write_u8(part,0xe1)
                end
            end
        end
        if route=='final' or route=='clear' then
            local group4 = doj and 0x8135a8 or 0x814910
            if mem:read_u16(group4+12)==(doj and 0x4080 or 0x7181) then
                local part = mem:read_u32(group4+6)
                if frame==49750 then
                    if doj then
                        mem:write_u32(group4+0x16,0x22fff)
                    else
                        mem:write_u32(group4+0x1a,0xfffffffe)
                        mem:write_u16(part+0x20,1)
                        mem:write_u8(part,0xe1)
                    end
                elseif frame==50300 then
                    if doj then
                        mem:write_u32(group4+0x16,0xc3ff)
                    else
                        mem:write_u32(group4+0x1e,0xfffffffe)
                        mem:write_u16(part+0x20,1)
                        mem:write_u8(part,0xe1)
                    end
                elseif frame==50850 then
                    mem:write_u32(group4+0x16,0xfffffffe)
                    mem:write_u8(part,0xe1)
                    if not doj then mem:write_u16(part+0x20,1) end
                end
            end
        end
        if route=='clear' then
            local group5 = doj and 0x813698 or 0x8147d0
            if mem:read_u16(group5+12)==(doj and 0xb080 or 0xc080) then
                local part=mem:read_u32(group5+6)
                if doj and frame==78300 then
                    mem:write_u32(group5+0x16,0x29fff)
                elseif doj and frame==80100 then
                    mem:write_u32(group5+0x16,0xfffffffe)
                    mem:write_u8(part,0xe1)
                elseif not doj and frame==80100 then
                    mem:write_u32(group5+0x1e,0xfffffffe)
                    mem:write_u8(part+0x24,0xe1)
                end
            end
        end
    end
    if observe and frame%12==0 and frame>=first then
        local base = doj and 0x813288 or 0x814410
        for group=base,base+57*80,80 do
            if mem:read_u16(group)&0x8000~=0 and mem:read_u16(group+4)>=4 then
                output:write(string.pack('>I4I4I2',frame,group,mem:read_u16(0xb03000)),
                    mem:read_range(group,group+79,8))
            end
        end
    end
    if not observe and frame == first then output:write('PGM2',string.pack('>I4I4',ramStart,ramEnd)) end
    if not observe and frame >= first then
        output:write(string.pack('>I4', frame), mem:read_range(0x800000, 0x8009ff, 8))
        output:write(mem:read_range(ramStart,ramEnd,8))
        output:write(mem:read_range(0x900000, 0x900fff, 8),
            mem:read_range(0x907000, 0x9071bf, 8), mem:read_range(0xa00000, 0xa011ff, 8))
        for _, address in ipairs({0xb02000, 0xb03000, 0xb0e000}) do
            output:write(string.pack('>I2', mem:read_u16(address)))
        end
    end
    if frame == last then output:close(); machine:exit() end
end)
