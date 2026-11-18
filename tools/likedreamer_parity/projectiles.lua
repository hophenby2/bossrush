-- Run the real movement dispatcher with rendering and collision responses omitted.
dofile("mod/GAME/ports/dreamer/LikeDreamer/core.lua")
local Core = LikeDreamer.Core

object = {}
Class = function(base) return setmetatable({}, {__index = base}) end
New = function() return {} end
Del = function() end
GROUP_ENEMY_BULLET, GROUP_GHOST, LAYER_ENEMY_BULLET = 2, 0, 2
dofile("mod/GAME/ports/dreamer/LikeDreamer/projectile.lua")
local Projectile = LikeDreamer.Projectile
local frame

local function traceBullet(visual, id, x, y, angle, travel, speed, radius, aux)
    print(("b %d %d %d %.6f %.6f %d %.6f %.6f %d %d"):format(
        frame, visual, id, x, y, angle % 65536, speed, travel, radius, aux))
end

Projectile.spawn = traceBullet
Projectile.spread = function(visual, id, x, y, angle, travel, speed, radius, count, spread, aux)
    local first, step = angle, 0
    if count > 1 then
        if spread == 65536 then
            step = math.floor(65536 / count)
        else
            first = angle - math.floor(spread / 2)
            step = spread > 0 and math.floor(spread / (count - 1)) or 0
        end
    end
    for i = 0, count - 1 do
        traceBullet(visual, id, x, y, first + i * step, travel, speed, radius, aux)
    end
end

local id, difficulty, direction, scenario = unpack(arg)
id, difficulty, direction, scenario = tonumber(id), tonumber(difficulty), tonumber(direction), tonumber(scenario)
LikeDreamer.runtime = {
    difficulty = difficulty,
    enemiesById = {[1] = {helperTimer = 930}},
}
player = {}
local projectile = {
    projectileId = id, visualSelector = 3, radius = 1, arg = 1,
    ldX = 300, ldY = 300, anchorX = 300, anchorY = 300, prevX = 300, prevY = 300,
    travel = 30, speed = 2.5, baseSpeed = 2.5,
    angle16 = direction * 8192, prevAngle16 = direction * 8192,
    active = true, collisionEnabled = true,
}
if scenario == 1 then
    projectile.ldX, projectile.anchorX, projectile.prevX = 80, 80, 80
    projectile.ldY, projectile.anchorY, projectile.prevY = 15, 15, 15
    projectile.speed, projectile.baseSpeed, projectile.travel = 9.7, 9.7, 0
elseif scenario == 2 then
    projectile.ldX, projectile.anchorX, projectile.prevX = 615, 615, 615
    projectile.ldY, projectile.anchorY, projectile.prevY = 710, 710, 710
    projectile.speed, projectile.baseSpeed, projectile.travel = 0.1, 0.1, 120
end

for age = 0, 359 do
    projectile.age, frame = age, 1000 + age
    LikeDreamer.runtime.frame = frame
    LikeDreamer.runtime.enemiesById[1].helperTimer = 900 + age
    player.ldX, player.ldY = 200 + age % 200, 500 + age % 100
    Projectile.motionDispatcher:update(projectile)
    print(("s %d %.6f %.6f %d %.6f %.6f %d %d"):format(
        age, projectile.ldX, projectile.ldY, projectile.angle16,
        projectile.speed, projectile.travel,
        projectile.active and 1 or 0, projectile.collisionEnabled and 1 or 0))
    if not projectile.active then break end
end
