-- 从 ShmupMAME 5.4 的 EP1C12 保存项提取命令流和素材显存。
local machine = manager.machine
local items = machine.devices[':blitter'].items
local pointer = emu.item(assert(items['0/m_gfx_addr_shadowcopy']))
local clipX = emu.item(assert(items['0/m_gfx_clip_x_shadowcopy']))
local clipY = emu.item(assert(items['0/m_gfx_clip_y_shadowcopy']))
local ram = emu.item(assert(items['0/m_ram16_copy']))
local vram = emu.item(assert(items['0/*m_bitmaps']))
local output = assert(os.getenv('CV1000_TRACE'))
local uploadPath = os.getenv('CV1000_UPLOADS')
local uploads = uploadPath and assert(io.open(uploadPath,'wb'))
local first = assert(tonumber(os.getenv('CV1000_FIRST')))
local last = assert(tonumber(os.getenv('CV1000_LAST')))
local vramFrame = tonumber(os.getenv('CV1000_VRAM')) or last
local vramFrames = {}
for value in (os.getenv('CV1000_EXTRA_VRAM') or ''):gmatch('%d+') do
    vramFrames[tonumber(value)] = true
end
local crops = {}
for rect in (os.getenv('CV1000_CROPS') or ''):gmatch('[^;]+') do
    local x,y,w,h = rect:match('^(%d+),(%d+),(%d+),(%d+)$')
    if x then crops[#crops+1]={tonumber(x),tonumber(y),tonumber(w),tonumber(h)} end
end
local state = os.getenv('CV1000_STATE')
local snapshotOnly = os.getenv('CV1000_SNAPSHOT_ONLY')=='1'
local visibleOnly = os.getenv('CV1000_VISIBLE_ONLY')=='1'
local file = assert(io.open(output, 'wb'))
local resume = tonumber(os.getenv('CV1000_RESUME_FRAME'))
local frame = resume and resume-1 or 0
local loading = state~=nil
local drawFormat = '>'..string.rep('I2',10)
local profiles = {
    futari15={0x0c38aaf4,0x0c38aabc}, espgal2={0x0c37d72c,0x0c37d6fc},
    futariblj={0x0c383a68,0x0c383a1c},
}
local pilotAddress,livesAddress = table.unpack(profiles[emu.romname()] or {})
local keepLives = os.getenv('CV1000_KEEP_LIVES')=='1'
local cpu = machine.devices[':maincpu']
local program = cpu.spaces.program
local pilot = pilotAddress and assert(io.open(output..'.pilot','w'))
local motionTrace = os.getenv('CV1000_MOTION_TRACE')
local motionFile,motionTap
if motionTrace then
    assert(emu.romname()=='futari15','目前只核对了 Futari 1.5 的定点位移槽')
    motionFile = assert(io.open(motionTrace,'w'))
    motionFile:write('frame\tpc\tpr\taddress\tmask\tdata\n')
end
local ramFrames = {}
for value in (os.getenv('CV1000_RAM_FRAMES') or ''):gmatch('%d+') do
    ramFrames[tonumber(value)] = true
end
local previewFrames = {}
for value in (os.getenv('CV1000_PREVIEW') or ''):gmatch('%d+') do
    previewFrames[tonumber(value)] = true
end
local saveFrames = {}
for value in (os.getenv('CV1000_SAVE_FRAMES') or ''):gmatch('%d+') do
    saveFrames[tonumber(value)] = true
end
local previewInterval = tonumber(os.getenv('CV1000_PREVIEW_INTERVAL'))
if previewInterval and previewInterval<1 then previewInterval=nil end
local startPressed = machine.ioport.ports[':PORT_D'].fields['P1 Button 1']
local workRam = next(ramFrames) and emu.item(assert(machine.devices[':maincpu'].items['0/:mainram']))
local schedule = {
    {':PORT_C', 'Coin 1', 4200, 4207},
    {':PORT_C', '1 Player Start', 4280, 4289},
    {':PORT_D', 'P1 Button 1', 4450, 4479},
    {':PORT_D', 'P1 Button 1', 4930, 4949},
    {':PORT_D', 'P1 Button 1', 5020, 5039},
    {':PORT_D', 'P1 Button 1', 5190, 5209},
}
if os.getenv('CV1000_SHIFT') == '1' then
    schedule[#schedule+1] = {':PORT_D','P1 Right',5500,5523}
end
local fireFrom,fireTo = (os.getenv('CV1000_FIRE') or ''):match('^(%d+),(%d+)$')
if fireFrom then
    schedule[#schedule+1] = {':PORT_D','P1 Button 1',tonumber(fireFrom),tonumber(fireTo)}
end

local keys = {}
for _, event in ipairs(schedule) do
    local port, name, down, up = table.unpack(event)
    local field = assert(machine.ioport.ports[port].fields[name])
    keys[down], keys[up+1] = {field,1}, {field,0}
end

local function word(offset)
    return ram:read((offset % (ram.size * ram.count) // 2) ~ 3)
end

local function writeUpload(index, width, height)
    local x,y=word(index+8)&8191,word(index+10)&4095
    if y<3744 or width>8192-x or height>4096-y then return end
    local size=ram.size*ram.count
    local start=(index+16)%size
    local offset=start%8
    local from=start-offset
    local length=(offset+width*height*2+7)&~7
    local head=math.min(size-from,length)
    local pixels=ram:read_block(from,head)
    if head<length then pixels=pixels..ram:read_block(0,length-head) end
    uploads:write(string.pack('>I4I2I2I2I2I2',frame,x,y,width,height,offset),pixels)
end

local function commands(cx, cy, scanOnly)
    local base = pointer:read(0) % (ram.size * ram.count)
    local out, index = {}, base
    while index-base < ram.size * ram.count do
        local attr = word(index)
        local kind = attr >> 12
        if kind == 0 or kind == 0xf then break end
        if kind == 1 then
            if not scanOnly then
                local x,y,w,h=word(index+8),word(index+10),word(index+12),word(index+14)
                local dx,dy=(x~32768)-32768-cx,(y~32768)-32768-cy
                if not visibleOnly or dx<320 and dy<240 and dx+(w&8191)>=0 and dy+(h&4095)>=0 then
                    out[#out+1] = string.pack(drawFormat,attr,word(index+2),word(index+4),word(index+6),
                        x,y,w,h,word(index+16),word(index+18))
                end
            end
            index=index+20
        elseif kind == 0xc then
            index=index+4
        elseif kind == 2 then
            local width = (word(index+12) & 0x1fff)+1
            local height = (word(index+14) & 0x0fff)+1
            if uploads then writeUpload(index,width,height) end
            index=index+16+width*height*2
        else
            error(('第 %d 帧地址 %08x 的绘制指令 %04x 未识别'):format(frame,index,attr))
        end
    end
    return out
end

file:write('CVB1')
if uploads then uploads:write('CVU1') end
emu.register_frame_done(function()
    frame=frame+1
    if loading then
        loading=false
        machine:load(state)
        return
    end
    if motionFile and not motionTap and frame >= first-1 then
        -- 保留 64 位总线的原始写掩码。保存项的字排列与 CPU 地址不同，不能用位移槽的字段序号代替。
        local x = 0x0c517ed8
        motionTap = program:install_write_tap(x,x+128*0x54-1,'Futari 1.5 位移槽',function(address,data,mask)
            motionFile:write(('%d\t%08x\t%08x\t%08x\t%016x\t%016x\n'):format(
                frame+1,cpu.state.PC.value,cpu.state.PR.value,address,mask,data))
        end)
    end
    local key = keys[frame]
    if resume and frame==resume+1 and fireFrom then startPressed:set_value(1)
    elseif key and (not state or resume) then key[1]:set_value(key[2]) end
    if keepLives and livesAddress then
        local value = program:read_u32(livesAddress)
        if value&0xffffff00==0x01000000 and value&0xff<3 then
            program:write_u32(livesAddress,0x01000003)
        end
    end
    if frame>=first and not snapshotOnly then
        local cx,cy=clipX:read(0),clipY:read(0)
        local draw = commands(cx,cy)
        file:write(string.pack('>I4I2I2I2',frame,cx,cy,#draw))
        file:write(table.concat(draw))
        if pilot then
            pilot:write(('%d,%d,%d\n'):format(frame,program:read_i32(pilotAddress),program:read_i32(pilotAddress+4)))
        end
    elseif uploads and frame>=first then
        commands(0,0,true)
    end
    if frame==vramFrame or vramFrames[frame] then
        local suffix = frame==vramFrame and '' or '.'..frame
        local assets = assert(io.open(output..'.vram'..suffix,'wb'))
        if #crops==0 then
            assets:write(vram:read_block(0,vram.size*vram.count))
        else
            for _,rect in ipairs(crops) do
                local x,y,w,h=table.unpack(rect)
                for dy=0,h-1 do assets:write(vram:read_block(((y+dy)*8192+x)*4,w*4)) end
            end
        end
        assets:close()
    end
    if ramFrames[frame] then
        local memory = assert(io.open(output..'.ram.'..frame,'wb'))
        memory:write(workRam:read_block(0,workRam.size*workRam.count))
        memory:close()
    end
    if previewFrames[frame] or previewInterval and frame>=first and (frame-first)%previewInterval==0 then
        machine.screens[':screen']:snapshot()
    end
    if saveFrames[frame] then machine:save(output..'.state.'..frame..'.sta') end
    if frame==last then
        if motionTap then motionTap:remove() end
        if motionFile then motionFile:close() end
        file:close()
        if uploads then uploads:close() end
        if pilot then pilot:close() end
        machine:exit()
    end
end)
