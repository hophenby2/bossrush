local type = type
local max = math.max
local int = math.floor
local sin = lstg.sin
local cos = lstg.cos
local Color = lstg.Color
local SetImageState = lstg.SetImageState
local GetTextureSize = lstg.GetTextureSize
local Render = lstg.Render
local Render4V = lstg.Render4V
local RenderTexture = lstg.RenderTexture

local COLOR_WHITE = Color(255, 255, 255, 255)
local COLOR_BLACK = Color(255, 0, 0, 0)

local M = effect

--- 绘制反色圈
---@param x number
---@param y number
---@param r number
---@param div number
function M.drawInverseColorCircle(x, y, r, div)
    SetImageState("white", "add+sub", COLOR_WHITE)
    local ang = 360 / (2 * div)
    local x1, y1, x2, y2 = 0.0, 0.0, 0.0, 0.0
    for angle = 0, 359.9, 360 / div do
        x1, y1 = x + r * cos(angle + ang), y + r * sin(angle + ang)
        x2, y2 = x + r * cos(angle - ang), y + r * sin(angle - ang)
        Render4V("white",
                x, y, 0.5,
                x, y, 0.5,
                x1, y1, 0.5,
                x2, y2, 0.5)
    end
end

--- 绘制反色圈，从中心向外发色效果逐渐增强
---@param x number
---@param y number
---@param r number
---@param div number
function M.drawInverseColorCircle2(x, y, r, div)
    SetImageState("white", "add+sub",
            COLOR_WHITE, COLOR_WHITE, COLOR_BLACK, COLOR_BLACK)
    local ang = 360 / (2 * div)
    local x1, y1, x2, y2 = 0.0, 0.0, 0.0, 0.0
    for angle = 0, 359.9, 360 / div do
        x1, y1 = x + r * cos(angle + ang), y + r * sin(angle + ang)
        x2, y2 = x + r * cos(angle - ang), y + r * sin(angle - ang)
        Render4V("white",
                x, y, 0.5,
                x, y, 0.5,
                x1, y1, 0.5,
                x2, y2, 0.5)
    end
    SetImageState("white", "", COLOR_WHITE)
end

---纹理平铺
---@param tex string @texture res
---@param blend string @blendmode
---@param color lstg.Color|table
---@param x number
---@param y number
---@param rot number
---@param hscale number
---@param vscale number
---@param u number
---@param v number
---@param uvrot number
---@param uvhscale number
---@param uvvscale number
function M.drawTile(tex, blend, color, x, y, rot, hscale, vscale, u, v, uvrot, uvhscale, uvvscale)
    --设置采样方式
    lstg.SetTextureSamplerState("address", "wrap")
    --计算顶点坐标
    local texw, texh = GetTextureSize(tex)
    local texw2, texh2 = texw / 2, texh / 2
    local texpos = {
        x = { -texw2 * hscale, texw2 * hscale, texw2 * hscale, -texw2 * hscale },
        y = { texh2 * vscale, texh2 * vscale, -texh2 * vscale, -texh2 * vscale },
    }
    for s = 1, 4 do
        texpos.x[s], texpos.y[s] = texpos.x[s] * cos(rot) - texpos.y[s] * sin(rot), texpos.x[s] * sin(rot) + texpos.y[s] * cos(rot)
        texpos.x[s], texpos.y[s] = texpos.x[s] + x, texpos.y[s] + y
    end
    --计算uv坐标
    local uvpos = {
        u = { -texw2 * uvhscale, texw2 * uvhscale, texw2 * uvhscale, -texw2 * uvhscale },
        v = { -texh2 * uvvscale, -texh2 * uvvscale, texh2 * uvvscale, texh2 * uvvscale },
    }
    for s = 1, 4 do
        uvpos.u[s], uvpos.v[s] = uvpos.u[s] * cos(uvrot) - uvpos.v[s] * sin(uvrot), uvpos.u[s] * sin(uvrot) + uvpos.v[s] * cos(uvrot)
        uvpos.u[s], uvpos.v[s] = uvpos.u[s] + texw2 - u, uvpos.v[s] + texh2 + v--uv坐标中心点在左上角
    end
    --填充数据
    local vertex = {
        { texpos.x[1], texpos.y[1], 0.5, uvpos.u[1], uvpos.v[1], },
        { texpos.x[2], texpos.y[2], 0.5, uvpos.u[2], uvpos.v[2], },
        { texpos.x[3], texpos.y[3], 0.5, uvpos.u[3], uvpos.v[3], },
        { texpos.x[4], texpos.y[4], 0.5, uvpos.u[4], uvpos.v[4], },
    }
    if type(color) == "table" then
        for s = 1, 4 do
            vertex[s][6] = color[s]
        end
    else
        for s = 1, 4 do
            vertex[s][6] = color
        end
    end
    --渲染
    RenderTexture(tex, blend, vertex[1], vertex[2], vertex[3], vertex[4])
    --恢复采样方式
    lstg.SetTextureSamplerState("address", "clamp")
end

---纹理平铺符卡背景
---@param tex string @texture res
---@param blend string @blendmode
---@param color lstg.Color
---@param u number
---@param v number
---@param uvrot number
---@param uvhscale number
---@param uvvscale number
function M.drawTileSCBG(tex, blend, color, u, v, uvrot, uvhscale, uvvscale)
    local world = lstg.world
    local worldw, worldh = world.r - world.l, world.t - world.b
    local w, h = GetTextureSize(tex)
    local scale = max(worldw / w, worldh / h)
    M.drawTile(tex, blend, color,
            0, 0, 0, scale, scale,
            u, v, uvrot, scale / uvhscale, scale / uvvscale)
end

---纹理平铺符卡背景（老方法，无法旋转、缩放）
---@param img string @texture res & image res
---@param x number
---@param y number
function M.drawOldTileSCBG(img, x, y)
    local world = lstg.world
    local w, h = GetTextureSize(img)
    for i = -int((world.r + 16 + x) / w + 0.5), int((world.r + 16 - x) / w + 0.5) do
        for j = -int((world.t + 16 + y) / h + 0.5), int((world.t + 16 - y) / h + 0.5) do
            Render(img, x + i * w, y + j * h)
        end
    end
end

---以极坐标的方式将纹理渲染成一个环
---@param tex string @texture res name
---@param blend string @blend mode
---@param color lstg.Color
---@param x number
---@param y number
---@param r1 number
---@param r2 number
---@param rot number @ring rotate
---@param div number @integer, division count
---@param rep number @integer, repeat count
---@param t number @( 0 ~ 1 ), lerp
function M.drawTexturePolarAnnulus(tex, blend, color, x, y, r1, r2, rot, div, rep, t)
    local w, h = GetTextureSize(tex)
    local n = div * rep--分成多少扇渲染，总扇数为分割数*重复数
    local perunit = h / div--但是v坐标的步进还是除以分割数
    local da = 360 / n--每个扇的圆心角
    local r12 = r1 + (r2 - r1) * t--中间半径
    local as = rot--起始渲染角度
    for i = 0, (rep - 1) do
        for j = 0, (div - 1) do
            local a1, a2 = as, as - da--顶点朝向
            local u0, u1, u2 = 0, w - w * t, w--u坐标位置
            local v1, v2 = j * perunit, (j + 1) * perunit--v坐标位置
            --内半部分
            RenderTexture(tex, blend,
                    { x + r1 * cos(a1), y + r1 * sin(a1), 0.5, u1, v1, color },
                    { x + r12 * cos(a1), y + r12 * sin(a1), 0.5, u2, v1, color },
                    { x + r12 * cos(a2), y + r12 * sin(a2), 0.5, u2, v2, color },
                    { x + r1 * cos(a2), y + r1 * sin(a2), 0.5, u1, v2, color })
            --外半部分
            RenderTexture(tex, blend,
                    { x + r12 * cos(a1), y + r12 * sin(a1), 0.5, u0, v1, color },
                    { x + r2 * cos(a1), y + r2 * sin(a1), 0.5, u1, v1, color },
                    { x + r2 * cos(a2), y + r2 * sin(a2), 0.5, u1, v2, color },
                    { x + r12 * cos(a2), y + r12 * sin(a2), 0.5, u0, v2, color })
            as = as - da
        end
    end
end

---@param imgs string @texture res name
---@param div number @integer, imgs division count
---@param blend string @blend mode
---@param color lstg.Color
---@param x number
---@param y number
---@param r1 number
---@param r2 number
---@param rot number @ring rotate
---@param rep number @integer, repeat count
---@param rev boolean
function M.drawSpriteSequenceAnnulusV(imgs, div, blend, color, x, y, r1, r2, rot, rep, rev)
    local img = {}
    for i = 1, div do
        img[i] = imgs .. i
        SetImageState(img[i], blend, color)
    end
    local n = div * rep
    local as = rot
    local da = 360 / n
    if rev then
        for _ = 1, rep do
            for i = 1, div do
                local a1, a2 = as, as + da
                local _sin1, _cos1 = sin(a1), cos(a1)
                local _sin2, _cos2 = sin(a2), cos(a2)
                Render4V(img[i],
                        x + r2 * _cos1, y + r2 * _sin1, 0.5,
                        x + r1 * _cos1, y + r1 * _sin1, 0.5,
                        x + r1 * _cos2, y + r1 * _sin2, 0.5,
                        x + r2 * _cos2, y + r2 * _sin2, 0.5)
                as = as + da
            end
        end
    else
        for _ = 1, rep do
            for i = 1, div do
                local a1, a2 = as, as - da
                local _sin1, _cos1 = sin(a1), cos(a1)
                local _sin2, _cos2 = sin(a2), cos(a2)
                Render4V(img[i],
                        x + r1 * _cos1, y + r1 * _sin1, 0.5,
                        x + r2 * _cos1, y + r2 * _sin1, 0.5,
                        x + r2 * _cos2, y + r2 * _sin2, 0.5,
                        x + r1 * _cos2, y + r1 * _sin2, 0.5)
                as = as - da
            end
        end
    end
end

---@param imgs string @texture res name
---@param div number @integer, imgs division count
---@param blend string @blend mode
---@param color lstg.Color
---@param x number
---@param y number
---@param r1 number
---@param r2 number
---@param rot number @ring rotate
---@param rep number @integer, repeat count
---@param rev boolean
function M.drawSpriteSequenceAnnulusH(imgs, div, blend, color, x, y, r1, r2, rot, rep, rev)
    local img = {}
    for i = 1, div do
        img[i] = imgs .. i
        SetImageState(img[i], blend, color)
    end
    local n = div * rep
    local as = rot
    local da = 360 / n
    if rev then
        for _ = 1, rep do
            for i = 1, div do
                local a1, a2 = as, as + da
                local _sin1, _cos1 = sin(a1), cos(a1)
                local _sin2, _cos2 = sin(a2), cos(a2)
                Render4V(img[i],
                        x + r1 * _cos1, y + r1 * _sin1, 0.5,
                        x + r1 * _cos2, y + r1 * _sin2, 0.5,
                        x + r2 * _cos2, y + r2 * _sin2, 0.5,
                        x + r2 * _cos1, y + r2 * _sin1, 0.5)
                as = as + da
            end
        end
    else
        for _ = 1, rep do
            for i = 1, div do
                local a1, a2 = as, as - da
                local _sin1, _cos1 = sin(a1), cos(a1)
                local _sin2, _cos2 = sin(a2), cos(a2)
                Render4V(img[i],
                        x + r2 * _cos1, y + r2 * _sin1, 0.5,
                        x + r2 * _cos2, y + r2 * _sin2, 0.5,
                        x + r1 * _cos2, y + r1 * _sin2, 0.5,
                        x + r1 * _cos1, y + r1 * _sin1, 0.5)
                as = as - da
            end
        end
    end
end
