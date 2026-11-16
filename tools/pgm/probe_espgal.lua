-- 在 ShmupMAME 5.4 中导出 V100 解密程序，核对一面初期的原版指针挂载。
assert(emu.romname() == 'espgal', '请使用 Espgaluda V100')
local machine = manager.machine
local cpu = machine.devices[':maincpu']
local mem = cpu.spaces.program
local program = assert(io.open('espgaluda-program.bin', 'wb'))
program:write(mem:read_range(0,0x1fffff,8))
program:close()

local output = assert(io.open('espgaluda-callbacks.tsv', 'w'))
local frame = 0
local hooks = {}
local enemyBase,bulletBase = 0x814410,0x818352

local function install()
    -- 0x14ef84 写入 +0x4c。收到低字写入时，高字已经写入槽中。
    hooks[1] = mem:install_write_tap(enemyBase,enemyBase + 58 * 0x50 - 1,'敌机回调',function(address,value)
        if (address - enemyBase) % 0x50 ~= 0x4e then return end
        local slot = address - 0x4e
        local callback = mem:read_u16(address - 2) * 0x10000 + value
        if callback == 0 or mem:read_u16(slot) < 0x8000 then return end
        output:write(('enemy\t%d\t%02x\t%06x\t%06x\t%06x\t%06x\n'):format(frame + 1,
            mem:read_u8(slot + 0xc),mem:read_u32(slot + 0x12),cpu.state.CURPC.value,callback,
            mem:read_u32(slot + 6)))
    end)
    -- 0x1710d4 写入 +0x22。0x17103a 保存发射部件。0x172492 通过此指针调度弹体。
    hooks[2] = mem:install_write_tap(bulletBase,bulletBase + 200 * 0x40 - 1,'敌弹回调',function(address,value)
        if (address - bulletBase) % 0x40 ~= 0x24 then return end
        local slot = address - 0x24
        local callback = mem:read_u16(address - 2) * 0x10000 + value
        if callback == 0 or mem:read_u16(slot) < 0x8000 then return end
        output:write(('bullet\t%d\t%06x\t%06x\t%06x\n'):format(frame + 1,
            mem:read_u32(slot + 0x2a),cpu.state.CURPC.value,callback))
    end)
end

local function input(port,name,first,last)
    machine.ioport.ports[port].fields[name]:set_value(frame >= first and frame < last and 1 or 0)
end

emu.register_frame_done(function()
    frame = frame + 1
    input(':Service','Coin 1',2170,2176)
    input(':P1P2','1 Player Start',2210,2222)
    input(':P1P2','P1 Down',2420,2430)
    local shoot = frame >= 2290 and frame < 2302 or frame >= 2460 and frame < 2510
    machine.ioport.ports[':P1P2'].fields['P1 Button 1']:set_value(shoot and 1 or 0)
    if frame == 2750 then install() end
    if frame == 3700 then
        for _,hook in ipairs(hooks) do hook:remove() end
        output:close()
        machine:exit()
    end
end)
