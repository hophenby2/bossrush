-- PGM 的 448×224 画面逆时针转为 224×448。
return function(code)
    local path = 'mod/GAME/' .. code .. '/'
    local M = dofile(path .. 'assets.lua')
    local resource = 'Resources/' .. code .. '/'
    local floor, byte = math.floor, string.byte
    local halfWidth,halfHeight=M.halfWidth or 112,M.halfHeight or 224

    function M.world(x, y)
        return y / 64 - halfWidth, x / 64 - halfHeight
    end

    local function loadAtlas(name, rects, stageNumber)
        local pages, images = {}, {}
        local suffix = stageNumber and '_s' .. stageNumber or ''
        local directory = stageNumber and resource .. 'stage' .. stageNumber .. '/' or resource
        for i, rect in ipairs(rects) do
            local page, x, y, w, h = unpack(rect)
            local tex = code .. suffix .. '_' .. name .. page
            if not pages[page] then
                LoadTexture(tex, directory .. name .. page .. '.png')
                SetTextureSamplerState(tex, 'point+clamp')
                pages[page] = true
            end
            local img = code .. suffix .. '_' .. name .. '_' .. i
            LoadImage(img, tex, x, y, w, h)
            images[i] = {img, w, h}
        end
        return images, pages
    end

    function M.loadImages()
        if M.image and CheckRes('img',M.image[1][1]) then return end
        if not M.stageFiles then M.tile = loadAtlas('tiles', M.tiles) end
        M.image = loadAtlas('sprites', M.sprites)
    end

    function M.load(stageNumber)
        if not stageNumber and M.data then return M.data end
        local filename = stageNumber and 'stage' .. stageNumber .. '.bin' or 'stage1.bin'
        local data = assert(lstg.LoadTextFile(path .. filename), '无法加载街机关卡数据')
        local version = data:sub(1,4)
        assert(version=='KET1' or version=='PGM3','PGM 数据版本错误')
        local cursor = 5
        local function u8()
            local value = byte(data, cursor)
            cursor = cursor + 1
            return value
        end
        local function u16()
            local a, b = byte(data, cursor, cursor + 1)
            cursor = cursor + 2
            return a * 256 + b
        end
        local function i16()
            local value = u16()
            return value < 32768 and value or value - 65536
        end
        local function tick()
            if version=='KET1' then return u16() end
            local hi=u16()
            return hi*65536+u16()
        end
        local nEnemy, nShot, nBackground = tick(), tick(), tick()
        local enemies, shots, backgrounds = {}, {}, {}
        local function at(tableByFrame, frame, value)
            local list = tableByFrame[frame]
            if not list then list = {}; tableByFrame[frame] = list end
            list[#list + 1] = value
        end
        for id = 1, nEnemy do
            local time, kind, hp, a, b, phase, duration = tick(), u16(), u16(), u16(), u16(), u16(), u16()
            local frames = {}
            local boxes = M.bossBoxes and {}
            -- 位置与多部件帧保留紧凑字符串，避免把上万帧展开成独立 Lua 表。
            for f = 1, duration do
                local count = byte(data, cursor + 4)
                local size = 5 + count * 6
                frames[f] = data:sub(cursor, cursor + size - 1)
                cursor = cursor + size
                if boxes then
                    local n = u8()*13
                    boxes[f] = data:sub(cursor,cursor+n-1)
                    cursor = cursor+n
                end
            end
            at(enemies, time, {id=id,time=time,kind=kind,hp=hp,a=a/64,b=b/64,phase=phase,frames=frames,boxes=boxes})
        end
        for _ = 1, nShot do
            local time, owner, x, y, vx, vy = tick(), u16(), i16(), i16(), i16(), i16()
            local a, b, proc, speed, bank, image, aimed = u16(), u16(), u16(), u16(), u16(), u16(), u16()
            local count = u16()
            local changes = {}
            for i = 1, count do changes[i] = {u16(), i16(), i16()} end
            local life = M.shotLifetime and u16()
            local visuals
            if M.shotVisuals then
                visuals = {}
                for i = 1, u16() do visuals[i] = {u16(),u16(),i16(),i16(),u8()==1} end
            end
            at(shots, time, {owner=owner, x=x, y=y, dx=vx, dy=vy, a=a/64, b=b/64,
                proc=proc, speed=speed, bank=bank, image=image, aimed=aimed==1, changes=changes,
                life=life, visuals=visuals})
        end
        for _ = 1, nBackground do
            local time, camera, scroll, count = tick(), u16(), u16(), u16()
            local cells = {}
            for i = 1, count do cells[i] = {u16(), u16()} end
            local scenery
            if M.scenery then
                local size = u16() * 6
                scenery = data:sub(cursor, cursor+size-1)
                cursor = cursor+size
            end
            backgrounds[time] = {camera, scroll, cells, scenery}
        end
        assert(cursor == #data + 1, 'PGM 关卡数据长度错误')
        local result = {enemies=enemies, shots=shots, backgrounds=backgrounds}
        if not stageNumber then M.data = result end
        return result
    end

    function M.loadStage(run, stageNumber)
        M.unloadStage(run)
        local stage = dofile(path .. 'stage' .. stageNumber .. '.lua')
        local pool = GetResourceStatus()
        local tile, tilePages = loadAtlas('tiles', stage.tiles, stageNumber)
        local image, imagePages = loadAtlas('sprites', stage.sprites, stageNumber)
        run.data, run.tileAtlas, run.imageAtlas = M.load(stageNumber), tile, image
        run.releaseStageResources = function()
            for _, atlas in ipairs({tile, image}) do
                for _, sprite in ipairs(atlas) do RemoveResource(pool, 2, sprite[1]) end
            end
            for page in pairs(tilePages) do RemoveResource(pool, 1, code .. '_s' .. stageNumber .. '_tiles' .. page) end
            for page in pairs(imagePages) do RemoveResource(pool, 1, code .. '_s' .. stageNumber .. '_sprites' .. page) end
        end
        run.frame, run.last, run.loop, run.stageRoutes = 0, stage.last, stage.loop, stage.routes
        run.tiles, run.camera, run.scroll, run.scenery = {}, 0, 0, nil
    end

    function M.unloadStage(run)
        if run.releaseStageResources then
            run.releaseStageResources()
            run.releaseStageResources=nil
        end
    end

    local function word(data, offset)
        local a, b = byte(data, offset, offset + 1)
        return (a < 128 and a or a - 256) * 256 + b
    end

    function M.pose(o, data)
        o.x, o.y = M.world(word(data, 1), word(data, 3))
        o.pose = data
    end

    function M.drawPose(o)
        local images = o.run.imageAtlas or M.image
        for i = 6, #o.pose, 6 do
            local a, b = byte(o.pose, i, i+1)
            local image = images[a*256+b]
            Render(image[1], floor(o.x)+word(o.pose,i+4)+image[2]/2,
                floor(o.y)+word(o.pose,i+2)+image[3]/2)
        end
    end

    function M.eachBox(data)
        local i = -12
        return function()
            i=i+13
            if i>#data then return end
            local x,y = M.world(word(data,i+1),word(data,i+3))
            local front,back,right,left = word(data,i+5),word(data,i+7),word(data,i+9),word(data,i+11)
            return byte(data,i),x+(right-left)/128,y+(front-back)/128,(right+left)/128,(front+back)/128
        end
    end

    M.Background = Class(background, {
        init = function(o, run)
            background.init(o, false)
            o.run, o.layer = run, LAYER.BG
        end,
        render = function(o)
            local run = o.run
            local camera, scroll = run.camera, run.scroll
            local row0, col0 = floor(camera/32), floor(scroll/32)
            local x0, y0 = 16-camera%32-112, 16-scroll%32-224
            for row = 0, 7 do
                local base = (row0+row)%16*64
                for col = 0, 14 do
                    local id = run.tiles[base+(col0+col)%64]
                    if id then Render(M.tile[id][1], x0+row*32, y0+col*32) end
                end
            end
            local scenery = run.scenery
            if scenery then
                for i = 1, #scenery, 6 do
                    local a, b = byte(scenery,i,i+1)
                    local img = (M.cvTiles and (run.tileAtlas or M.tile) or M.image)[a*256+b]
                    Render(img[1],word(scenery,i+4)-halfWidth+img[2]/2,
                        word(scenery,i+2)-halfHeight+img[3]/2)
                end
            end
        end,
    })

    function M.updateBackground(run, frame)
        local value = run.data.backgrounds[frame]
        if not value then return end
        run.camera, run.scroll, run.scenery = value[1], value[2], value[4]
        for _, cell in ipairs(value[3]) do run.tiles[cell[1]] = cell[2] end
    end

    return M
end
