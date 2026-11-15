-- 用 ShmupMAME 导出解密程序，并核对运行时实际写入敌机和弹槽的回调。
local machine = manager.machine
assert(emu.romname() == 'ddpdoj', '请使用日版大往生 V101')
local cpu = machine.devices[':maincpu']
local mem = cpu.spaces.program
local program = assert(io.open('ddpdoj-program.bin', 'wb'))
program:write(mem:read_range(0, 0x2fffff, 8))
program:close()

local output = assert(io.open('ddpdoj-callbacks.tsv', 'w'))
local frame = 0
local hooks = {}
local function install()
    -- 写低字时高字已写入。原程序 0x161eba 把回调指针存到敌机槽 +0x4c。
    hooks[1] = mem:install_write_tap(0x813288, 0x8144a7, '敌机回调', function(address, value)
        if (address - 0x813288) % 0x50 ~= 0x4e then return end
        local slot = address - 0x4e
        local kind = mem:read_u8(slot + 0xc)
        local path = mem:read_u32(slot + 0x12)
        local callback = mem:read_u16(address - 2) * 0x10000 + value
        output:write(('enemy\t%02x\t%06x\t%06x\t%06x\n'):format(kind, path, cpu.state.CURPC.value, callback))
    end)
    hooks[2] = mem:install_write_tap(0x817d30, 0x81b1af, '敌弹回调', function(address, value)
        if (address - 0x817d30) % 0x40 ~= 0x24 then return end
        local slot = address - 0x24
        local flags = mem:read_u16(slot)
        local callback = mem:read_u16(address - 2) * 0x10000 + value
        if flags < 0x8000 or callback == 0 then return end
        output:write(('bullet\t%02x\t%06x\t%06x\n'):format(flags & 0x3f, cpu.state.CURPC.value, callback))
    end)
end

local function input(port, name, from, to)
    machine.ioport.ports[port].fields[name]:set_value(frame >= from and frame < to and 1 or 0)
end

emu.register_frame_done(function()
    frame = frame + 1
    input(':Service', 'Coin 1', 880, 886)
    input(':P1P2', '1 Player Start', 940, 952)
    machine.ioport.ports[':P1P2'].fields['P1 Button 1']:set_value(
        (frame >= 1030 and frame < 1042 or frame >= 1058 and frame < 1070) and 1 or 0)
    if frame == 1420 then install() end
    if frame == 2450 then
        output:close()
        machine:exit()
    end
end)
