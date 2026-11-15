-- 采集 Atlus Cave 基板的工作 RAM、当前精灵库和三层图块。
local machine=manager.machine
local program=machine.devices[':maincpu'].spaces.program
local shares=machine.memory.shares
local game=emu.romname()
local main=assert(({ddonpach=0x100000,ddonpachj=0x100000,ddonpachl2=0x100000,guwange=0x200000})[game])
local file=assert(io.open(assert(os.getenv('CAVE_TRACE')),'wb'))
local first=assert(tonumber(os.getenv('CAVE_FIRST')))
local last=assert(tonumber(os.getenv('CAVE_LAST')))
local state=os.getenv('CAVE_STATE')
local coin=tonumber(os.getenv('CAVE_COIN'))
local start=tonumber(os.getenv('CAVE_START'))
local shot=tonumber(os.getenv('CAVE_SHOT'))
local registers=shares[':videoregs.0']
local function press(port,name,at,frame)
    if at and (frame==at or frame==at+12) then
        machine.ioport.ports[port].fields[name]:set_value(frame==at and 1 or 0)
    end
end

local function range(address,size)
    return program:read_range(address,address+size-1,8)
end

file:write('CV68')
local frame=0
emu.register_frame_done(function()
    frame=frame+1
    if frame==1 and state then
        machine:load(state)
        return
    end
    press(game=='guwange' and ':IN1' or ':IN0','Coin 1',coin,frame)
    press(':IN0','1 Player Start',start,frame)
    press(':IN0','P1 Button 1',shot,frame)
    if frame<first then return end
    -- 这两款使用 get_sprite_info 的即时库选择。
    local spriteBank=registers:read_u16(8)&3
    file:write(string.pack('>I4I2',frame,spriteBank))
    for word=0,63 do file:write(string.pack('>I2',registers:read_u16(word*2))) end
    file:write(range(main,0x10000),range(0x400000+spriteBank*0x4000,0x4000),range(0xc00000,0x10000))
    for layer=0,2 do
        local address=0x500000+layer*0x100000
        file:write(range(address,(game~='guwange' and layer==2) and 0x4000 or 0x8000))
        file:write(range(0x900000+layer*0x100000,6))
    end
    if frame==last then file:close(); machine:exit() end
end)
