-- IGS023 图块和精灵以 224×448 的坐标系绘制，纹理仅载入当前资源池。
return function(program)
    local M = {}

    local function loadAtlas(kind,rects)
        local textures,images = {},{}
        for id,rect in ipairs(rects) do
            local page,x,y,w,h = unpack(rect)
            local texture = textures[page]
            if not texture then
                texture = 'th45_native_' .. kind .. '_' .. page
                LoadTexture(texture,'Resources/th45/native/native_' .. kind .. page .. '.png')
                SetTextureSamplerState(texture,'point+clamp')
                textures[page] = texture
            end
            local image = 'th45_native_' .. kind .. '_image_' .. id
            LoadImage(image,texture,x,y,w,h)
            images[id] = {image,w,h}
        end
        return images
    end

    function M.draw(image,h,l,dh,dl,flipX)
        local x,y = program.world(h + dh,l + dl)
        Render(image[1],math.floor(x) + image[2] / 2,math.floor(y) + image[3] / 2,0,flipX and -1 or 1,1)
    end

    local Background = Class(object,{
        init = function(o,run)
            o.run = run
            o.group,o.layer,o.bound,o.colli = GROUP.GHOST,LAYER.BG,false,false
        end,
        render = function(o)
            local run = o.run
            local lane,tiles = run.scroll[1],run.stage.tiles
            local x = -128 - math.floor(run.cameraOffset / 64) - lane.lPixels
            local y = -208 - (lane.hPixels % 32)
            local base = math.floor(lane.hBlock / 4)
            for row = 1,15 do
                for column,id in ipairs(tiles[(base + row - 1) % #tiles + 1]) do
                    Render(run.art.tiles[id][1],x + (column - 1) * 32,y + (row - 1) * 32)
                end
            end
        end,
    })

    local art
    function M.load(run)
        if not art or not lstg.CheckRes(2,art.tiles[1][1]) then
            art = {tiles=loadAtlas('tiles',program.tileRects),sprites=loadAtlas('sprites',program.spriteRects)}
        end
        run.art = art
        run.background = New(Background,run)
    end

    return M
end
