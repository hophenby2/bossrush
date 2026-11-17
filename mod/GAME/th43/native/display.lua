local data = dofile('mod/GAME/th43/native/rom_display.lua')
local floor, min, max = math.floor, math.min, math.max
local M = {rects=data.rects, options=data.options}

-- 一面入场的三层云分别每帧移动 4、8、12 像素。帧区间以地图开始推进为原点。
-- 各列为起止帧、图号、翻转、初始底边和每帧位移。绘制顺序沿用原版精灵表。
local clouds = {
    {0,120,4,1,32,4}, {0,8,1,1,-416,4}, {8,232,3,1,448,4},
    {0,64,2,2,64,8}, {64,176,4,2,448,8},
    {0,8,3,2,-384,8}, {8,120,1,2,448,8}, {120,232,3,2,448,8},
    {0,46,4,1,96,12}, {0,8,1,1,-352,12}, {8,83,3,1,448,12},
}

local function sprite(images, id, x, y)
    local image = images[id]
    Render(image[1], x + image[2]/2, y + image[3]/2)
end

function M.background(run)
    if run.stageNumber == 1 and not run.practice then
        local age = run.frame
        -- PGM 后登记的精灵先画。
        for i = #clouds, 1, -1 do
            local first, last, id, flip, y, speed = unpack(clouds[i])
            if age >= first and age < last then
                sprite(run.art.display, data.clouds[flip][id], -112, y-(age-first)*speed-224)
            end
        end
    end
    local p = run.player
    if p and not p.defeated and p.respawn == 0 and p.protect == 0 and run.route.loop == 0 then
        -- 0xb5dec 以 (112,80) 为投影基准折半，再把 16×32 的影子落到地面。
        local x = floor((p.l+0x1c00)/128) - 8 - 112
        local y = floor((p.h+0x1400)/128) - 16 - 224
        sprite(run.art.display, data.shadow[p.model][p.turn+9], x, y)
    end
end

function M.shield(p)
    local x = floor((p.l-0x700)/64)-112
    local y = floor((p.h-0xa00)/64)-224
    local images = p.run.art.display
    sprite(images, data.shield[p.model][16-p.shieldFrame%16], x, y)
    local fan = data.shieldFan[p.model][p.turn+9]
    x = floor((p.l+fan[2])/64)-112
    y = floor((p.h+fan[1])/64)-224
    sprite(images, fan[6-p.shieldFrame%4], x, y)
end

local function optionBeam(p, x, y, targetX, targetY)
    local dx, dy = targetX-x, targetY-y
    local length = math.sqrt(dx*dx+dy*dy)
    if length == 0 then return end
    local frames = data.optionBeam[p.model][p.level]
    local image = p.run.art.display[frames[#frames-floor(p.run.frame/2)%#frames]]
    local angle = math.deg(math.atan2(dy,dx)) - 90
    Render(image[1], (x+targetX)/2, (y+targetY)/2, angle, 1, length/image[3])
end

function M.option(o, targetX, targetY)
    local image = o.run.art.display[o.sprite]
    local x = floor((o.l+o.drawL)/64)-112+image[2]/2
    local y = floor((o.h+o.drawH)/64)-224+image[3]/2
    -- 从僚机精灵内部起画，随后用僚机覆盖光束根部。
    if targetX then optionBeam(o.pilot, x, y, targetX, targetY) end
    Render(image[1], x, y, 0, 1, o.angle >= 128 and -1 or 1)
end

function M.hull(p)
    local x = floor((p.l-0x400)/64)-112
    local y = floor((p.h+p.profile.hullOffsetH)/64)-224
    sprite(p.run.art.display, data.hull[p.model][p.turn+9], x, y)
end

local function bossMeter(run, boss, images)
    local width = max(0, min(208, floor(boss.reserve / floor(boss.maxReserve / 208))))
    if width == 0 then return end
    local frame = floor(run.frame/4)%#data.bossMeter+1
    local _, _, height, texture, u, v = unpack(images[data.bossMeter[frame]])
    local left, bottom = -104, 192
    local right, top = left+width, bottom+height
    local color = Color(255,255,255,255)
    RenderTexture(texture, '', {left,top,.5,u+.25,v+.25,color}, {right,top,.5,u+width-.25,v+.25,color},
        {right,bottom,.5,u+width-.25,v+height-.25,color}, {left,bottom,.5,u+.25,v+height-.25,color})
end

function M.hud(run)
    local p = run.player
    if not p then return end
    local images = run.art.display
    local function tile(id, column, row)
        -- IGS023 文本层有一个像素的横卷轴，ROT270 后落在纵轴上。
        sprite(images, id, row*8-112, column*8-225)
    end
    local title = data.title[floor(run.frame/4)%#data.title+1]
    for i, id in ipairs(title) do tile(id, 55, i) end
    if p.score > 0 then
        local digits = ('%d'):format(floor(p.score) % 10000000000)
        for i = 1, #digits do tile(data.digits[digits:byte(i)-47], 54, 9-#digits+i) end
    end
    local life = data.life[p.model]
    local boss = run.boss5
    local showDoom = boss and boss.phase >= 3 and not boss.hidden
    local lifeRow = showDoom and 51 or 53
    if showDoom then
        bossMeter(run, boss, images)
        for i = 1, 28 do
            tile(data.bossPanel[1][i], 53, i-1)
            tile(data.bossPanel[2][i], 52, i-1)
        end
    end
    for row = 0,min(8,max(0,p.life))-1 do
        tile(life[1], lifeRow, row)
        tile(life[2], lifeRow-1, row)
    end
    for row = 0,27 do
        local panel
        if row == 0 then panel = 1
        elseif row == 27 then panel = 2
        elseif row <= p.bombs*2 then panel = row%2 == 1 and 5 or 6
        elseif row == 13 then panel = 7
        elseif row == 14 then panel = 8
        else panel = row%2 == 1 and 3 or 4 end
        for column, id in ipairs(data.bombPanel[panel]) do tile(id, column-1, row) end
    end
    if showDoom then
        local banner = data.pleaseWait[floor(run.frame/4)%#data.pleaseWait+1]
        for i = 1, 12 do
            tile(banner[i], 55, 14+i)
            tile(banner[12+i], 54, 14+i)
        end
    else
        for i, id in ipairs(data.insertCoin[1]) do
            tile(id, 55, 15+i)
            tile(data.insertCoin[2][i], 54, 15+i)
        end
    end
end

return M
