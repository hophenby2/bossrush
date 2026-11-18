-- Drive the actual BossLate handlers, including children appended in the current frame.
dofile("mod/GAME/ports/dreamer/LikeDreamer/core.lua")
local Core = LikeDreamer.Core
local frame, actor

local function traceBullet(visual, id, x, y, angle, travel, speed, radius, aux)
    print(("b %d %d %d %d %.6f %.6f %d %.6f %.6f %d %d"):format(
        frame, actor, visual, id, Core.float32(x), Core.float32(y),
        angle % 65536, speed, travel, radius, aux))
end

LikeDreamer.Projectile = {
    spawn = traceBullet,
    clear = function() end,
    spread = function(visual, id, x, y, angle, travel, speed, radius, count, spread, aux)
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
    end,
}
dofile("mod/GAME/ports/dreamer/LikeDreamer/boss_recovered.lua")
for _, unit in ipairs({"defaults", "early", "boss07", "boss08", "boss09", "late", "boss10_aux", "guard"}) do
    dofile("mod/GAME/ports/dreamer/LikeDreamer/recovered/" .. unit .. ".lua")
end
dofile("mod/GAME/ports/dreamer/LikeDreamer/boss_late.lua")
local Boss = LikeDreamer.BossLate
Del = function(enemy) enemy.removeRequested = true end

local index, difficulty, scenario = tonumber(arg[1]), tonumber(arg[2]), tonumber(arg[3])
local runtime = {stage = 9, difficulty = difficulty, frame = 6000}
local function newEnemy(kind, hp, x, y, parent)
    return {
        spawnType = kind, hp = hp, maxhp = hp, ldX = x, ldY = y,
        originX = x, originY = y, parent = parent, active = true,
        age = 0, helperTimer = 0, state = 0, speed = 0,
        angle16 = 0, secondaryAngle16 = 0, targetAngle16 = 0,
    }
end
local root = newEnemy(326 + index, 100000, 360, index == 1 and 270 or index == 5 and 240 or 200)
root.entityId = 1
local enemies = {root}
function runtime:spawnChild(parent, kind, hp, x, y)
    local enemy = newEnemy(kind, hp, x, y, parent)
    enemy.entityId = #enemies + 1
    enemies[#enemies + 1] = enemy
    return enemy
end

player = {ldX = 360, ldY = 600, bombLock = 0}
runtime.player = player
LikeDreamer.Reward = {spawnEnemyDeathRewardBurst = function() end}
for age = 0, 2599 do
    frame, runtime.frame = 6000 + age, 6000 + age
    player.ldX, player.ldY = 200 + age % 200, 500 + age % 100
    if scenario == 1 and age == 1000 then root.hp = 0 end
    if scenario == 2 and age == 1000 then root.countdown = 0 end
    local index = 1
    while index <= #enemies do
        local enemy = enemies[index]
        index = index + 1
        if enemy.active then
            actor = enemy.entityId
            if scenario == 3 and age == 700 and enemy.spawnType == 200 then enemy.hp = 0 end
            Boss.update(enemy, runtime)
            if enemy.removeRequested then enemy.active = false end
            print(("s %d %d %d %d %.6f %.6f %d %d %d %d %d"):format(
                frame, enemy.entityId, enemy.state, enemy.helperTimer,
                enemy.ldX, enemy.ldY, enemy.angle16, enemy.secondaryAngle16,
                enemy.targetAngle16, enemy.hp, enemy.active and 1 or 0))
            enemy.helperTimer, enemy.age = enemy.helperTimer + 1, enemy.age + 1
        end
    end
end
