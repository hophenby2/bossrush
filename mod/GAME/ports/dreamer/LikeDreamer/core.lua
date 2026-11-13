-- Like Dreamer compatibility math and deterministic runtime helpers.
-- Gameplay state remains in the original 600x720, y-down coordinate system.

LikeDreamer = LikeDreamer or {}

local M = {}
LikeDreamer.Core = M

local bit = require("bit")
local floor = math.floor
local ceil = math.ceil
local abs = math.abs
local sin = math.sin
local cos = math.cos
local atan = math.atan
local pi = math.pi

M.WIDTH = 600
M.HEIGHT = 720
M.FULL_ANGLE = 0x10000

local function u32(v)
    v = bit.tobit(v)
    if v < 0 then
        return v + 0x100000000
    end
    return v
end
M.u32 = u32

-- Exact low 32-bit product without relying on double precision above 2^53.
local function mul32(a, b)
    a, b = u32(a), u32(b)
    local al, ah = a % 0x10000, floor(a / 0x10000)
    local bl, bh = b % 0x10000, floor(b / 0x10000)
    local low = al * bl
    local cross = (al * bh + ah * bl) % 0x10000
    return (low + cross * 0x10000) % 0x100000000
end
M.mul32 = mul32

function M.angle16(a)
    return a % 0x10000
end

function M.angleToRadians(a)
    return M.angle16(a) * (2 * pi / 0x10000)
end

function M.angleToDeg(a)
    return -M.angle16(a) * (360 / 0x10000)
end

function M.polar(a, distance)
    local r = M.angleToRadians(a)
    return cos(r) * distance, sin(r) * distance
end

local function atan2(y, x)
    if x > 0 then
        return atan(y / x)
    elseif x < 0 and y >= 0 then
        return atan(y / x) + pi
    elseif x < 0 then
        return atan(y / x) - pi
    elseif y > 0 then
        return pi * 0.5
    elseif y < 0 then
        return -pi * 0.5
    end
    return 0
end

function M.aim16(x1, y1, x2, y2)
	local value = atan2(y2 - y1, x2 - x1) * 0x10000 / (2 * pi)
	return M.angle16(value < 0 and ceil(value) or floor(value))
end

function M.angleDelta(current, target)
    local d = M.angle16(target) - M.angle16(current)
    if d > 0x8000 then d = d - 0x10000 end
    if d < -0x8000 then d = d + 0x10000 end
    return d
end

function M.turn16(current, target, step)
    local d = M.angleDelta(current, target)
    if d > step then d = step end
    if d < -step then d = -step end
    return M.angle16(current + d)
end

-- Original helpers use separate ellipse radii and an independent inclination.
function M.ellipse(angle, radiusX, radiusY, inclination)
    local r = M.angleToRadians(angle)
    local x, y = cos(r) * radiusX, sin(r) * radiusY
    if inclination and inclination ~= 0 then
        local t = M.angleToRadians(inclination)
        local c, s = cos(t), sin(t)
        x, y = x * c - y * s, x * s + y * c
    end
    return x, y
end

function M.clamp(v, lo, hi)
    if v < lo then return lo end
    if v > hi then return hi end
    return v
end

function M.approach(v, target, step)
    if v < target then return math.min(target, v + step) end
    if v > target then return math.max(target, v - step) end
    return v
end

function M.diff(values, difficulty)
    local d = M.clamp(difficulty or 1, 0, 4)
    return values[d + 1]
end

function M.playerLD()
    local p = rawget(_G, "player")
    if p and p.ldX then
        return p.ldX, p.ldY
    end
    return 360, 600
end

function M.cameraX()
    local x = M.playerLD()
    return x
end

function M.playfieldOriginX(cameraX)
    return (cameraX or M.cameraX()) / 6
end

-- 世界边界和显示视口独立。逻辑坐标贴齐四边，贴图保持原作像素比例。
function M.worldScale()
    local world = lstg.world
    return (world.r-world.l)/M.WIDTH, (world.t-world.b)/M.HEIGHT
end

function M.worldScaleY()
    local _,sy = M.worldScale()
    return sy
end

function M.renderScale()
    local w = lstg.world
    local pixelX = (w.scrr-w.scrl)/M.WIDTH
    local pixelY = (w.scrt-w.scrb)/M.HEIGHT
    local pixel = math.min(pixelX,pixelY)
    local sx,sy = M.worldScale()
    return sx*pixel/pixelX, sy*pixel/pixelY
end

function M.toWorld(ldX, ldY, cameraX)
    local origin = M.playfieldOriginX(cameraX)
    local sx,sy = M.worldScale()
    return lstg.world.l+(ldX-origin)*sx, lstg.world.t-ldY*sy
end

function M.fromWorld(x, y, cameraX)
    local sx,sy = M.worldScale()
    return (x-lstg.world.l)/sx+M.playfieldOriginX(cameraX), (lstg.world.t-y)/sy
end

function M.playerWorldPosition(x, y)
    local localX,logicalY = M.fromWorld(x,y,0)
    return localX*6/5,logicalY
end

function M.syncObject(obj, ldX, ldY, cameraX)
    obj.x, obj.y = M.toWorld(ldX, ldY, cameraX)
end

function M.inside(ldX, ldY, margin, cameraX)
    margin = margin or 0
    local left = M.playfieldOriginX(cameraX)
    return ldX >= left - margin and ldX <= left + M.WIDTH + margin
       and ldY >= -margin and ldY <= M.HEIGHT + margin
end

function M.clampToPlayfield(ldX, ldY, margin, cameraX)
    margin = margin or 0
    local left = M.playfieldOriginX(cameraX)
    return M.clamp(ldX, left - margin, left + M.WIDTH + margin),
           M.clamp(ldY, -margin, M.HEIGHT + margin)
end

function M.distance(x1, y1, x2, y2)
    local dx, dy = x2 - x1, y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

-- MT-style frame mixer recovered from the reconstructed original schedules.
function M.frameRand(seed)
    seed = u32(seed)
    local u = u32(mul32(bit.bxor(bit.rshift(seed, 30), seed), 0x6c078965) + 1)
    local a = u32(mul32(bit.bxor(bit.rshift(u, 30), u), 0x6c078965) + 2)
    local b = u32(mul32(bit.bxor(bit.rshift(a, 30), a), 0x6c078965) + 3)
    local c = u32(mul32(bit.bxor(bit.rshift(b, 30), b), 0x6c078965) + 4)
    local mixed = u32(bit.bxor(mul32(u, 0x800), u))
    return u32(bit.bxor(bit.rshift(bit.bxor(bit.rshift(c, 11), mixed), 8), c, mixed))
end

function M.randomCoord(frame, modulus, base)
    return M.frameRand(frame) % modulus + base
end

function M.randomUnit(frame, salt)
    local v = u32(mul32(frame, 1103515245) + mul32(salt, 12345) + 0x314159)
    v = u32(bit.bxor(v, bit.rshift(v, 16)))
    return bit.band(v, 0xffff) / 65535
end

function M.randomAngle(frame, salt)
    local value = M.frameRand((frame or 0) + (salt or 0))
    return M.angle16(value - floor(value / 0x10001))
end

function M.window(frame, start, duration, step)
    local t = frame - start
    return t >= 0 and t < duration and t % step == 0
end

function M.easeSinIn(frame, duration, distance)
    if duration <= 0 then return distance end
    return sin(M.clamp(frame / duration, 0, 1) * pi * 0.5) * distance
end

function M.easeSinOut(frame, duration, distance)
    if duration <= 0 then return 0 end
    return (1 - sin(M.clamp(frame / duration, 0, 1) * pi * 0.5)) * distance
end

return M
