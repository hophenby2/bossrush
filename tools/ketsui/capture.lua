-- ShmupMAME 5.4 自动启动脚本。由 export.py 在独立目录中启动。
local machine = manager.machine
local mem = machine.devices[':maincpu'].spaces.program
local mode = assert(os.getenv('KET_MODE'))
local file = assert(io.open(assert(os.getenv('KET_TRACE')), 'wb'))
local function dump(address, size)
    file:write(mem:read_range(address, address + size - 1, 8))
end

dump(0, 0x200000)
local frame = 0
local function input(port, name, active)
    machine.ioport.ports[port].fields[name]:set_value(active and 1 or 0)
end
emu.register_frame_done(function()
    frame = frame + 1
    input(':Service', 'Coin 1', frame >= 1860 and frame < 1900)
    input(':P1P2', '1 Player Start', frame >= 1930 and frame < 1970)
    input(':P1P2', 'P1 Button 1', frame >= 2100 and frame < 2140
        or mode == 'short' and frame >= 2600 and frame % 4 < 2)
    input(':P1P2', 'P1 Right', mode == 'shift' and frame >= 2700 and frame < 2720)
    -- 保留原作敌机及发弹时钟，避免采样在关底前因游戏结束中断。
    if frame >= 2580 and mem:read_u16(0x80fea2) >= 0x8000 then
        mem:write_u8(0x80fedc, 0x70)
    end
    -- 分开采集掉血后阶段。扣血走原作的阶段转换逻辑。
    if mode == 'short' and frame == 5520 then mem:write_u16(0x814b06, 0xffff) end
    if mode == 'short' and frame == 10180 then mem:write_u16(0x814d52, 0xffff) end
    if frame >= 1880 then
        file:write(string.pack('>I4', frame))
        dump(0x800000, 0xa00)
        dump(0x80fea0, 0x72)
        dump(0x812440, 0x110)
        dump(0x812744, 0x335e)
        dump(0x81719e, 0x348a)
        dump(0x900000, 0x1000)
        dump(0x907000, 0x1c0)
        dump(0xa00000, 0x1200)
        for _, address in ipairs({0xb00000, 0xb02000, 0xb03000, 0xb04000, 0xb05000, 0xb06000, 0xb07000, 0xb0e000}) do
            dump(address, 2)
        end
    end
    if frame == 12001 then
        file:close()
        machine:exit()
    end
end)
