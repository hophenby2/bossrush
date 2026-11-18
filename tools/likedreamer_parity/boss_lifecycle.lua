-- 完整原生对象池检查：覆盖入场、击破/超时换段、新建部件、退出与结算。
local fixture = dofile('tools/likedreamer_parity/boss_fixture.lua')
local R = LikeDreamer.Recovered
local stage, difficulty, scenario = tonumber(arg[1]), tonumber(arg[2]), tonumber(arg[3]) or 0
local expected = ({[5] = 6, [6] = 5, [7] = 5, [8] = 7, [9] = 4, [10] = 16})[stage]
local targetFrames = 0
local objects, bullets, phases, created = {}, 0, {}, 0
LikeDreamer.Projectile.spawn = function() bullets = bullets + 1 end
LikeDreamer.Projectile.spread = function(_, _, _, _, _, _, _, _, count) bullets = bullets + count end
LikeDreamer.Projectile.clear = function() end
Del = function(e) e.removeRequested = true end
local rt = {stage = stage, difficulty = difficulty, frame = 1000, nextEntityId = 1, enemiesById = {}, enemyCount = 0}
local function spawn(kind, hp, x, y, parent)
    local e = {
        spawnType = kind, hp = hp, maxhp = hp, ldX = x, ldY = y, originX = x, originY = y,
        active = true, age = 0, helperTimer = 0, state = 0, speed = 1, radius = 40,
        angle16 = 0x4000, secondaryAngle16 = 0x4000, targetAngle16 = 0x4000,
        entityId = rt.nextEntityId, parent = parent, parentEntityId = parent and parent.entityId or 0,
        parentSpawnType = parent and parent.spawnType or 0, targetable = false, protect = false,
        runtime = rt,
    }
    rt.nextEntityId = rt.nextEntityId + 1
    rt.enemiesById[e.entityId] = e
    rt.enemyCount = rt.enemyCount + 1
    objects[#objects + 1] = e
    created = created + 1
    return e
end
function rt:spawn(kind, hp, x, y) return spawn(kind, hp, x, y) end
function rt:spawnChild(parent, kind, hp, x, y) return spawn(kind, hp, x, y, parent) end
local root = spawn(0x137 + stage, 100000, stage == 6 and 480 or 360, stage == 10 and 320 or 200)
for t = 0, 24000 do
    rt.frame, fixture.frame = t + 1000, t
    player.ldX, player.ldY = 200 + t % 200, 500 + t % 100
    player.invulnerableFrames = scenario == 2 and t % 500 < 100 and 150 or 0
    player.playerStateTimer = scenario == 2 and t % 500 < 100 and 1 or 0
    if scenario == 4 then R.seekPracticePhase(root, expected) end
    local index = 1
    while index <= #objects do
        local object = objects[index]
        index = index + 1
        if object.active then
            fixture.update(object, rt)
            assert(object.ldX == object.ldX and object.ldY == object.ldY, '坐标不是有限数')
            if scenario == 3 and object ~= root and object.targetable and object.helperTimer >= 90 then
                object.hp = 0
            end
            if object == root and object._bmCombat then
                assert(object.portPhase == object._blPhase, '练习入口的阶段编号未同步')
                phases[object._blPhase or object.phaseIndex + 1] = true
                if scenario == 4 then
                    if object.portPhase == expected then
                        targetFrames = targetFrames + 1
                        if targetFrames >= 900 then object.hp = 0 end
                    end
                elseif object.helperTimer >= 180 then
                    if scenario == 1 then object.countdown = 0
                    else object.hp = 0 end
                end
            end
            if object.removeRequested then
                object.active = false
                rt.enemiesById[object.entityId] = nil
                rt.enemyCount = rt.enemyCount - 1
            else
                object.helperTimer, object.age = object.helperTimer + 1, object.age + 1
                if object.targetable then object.targetableTimer = (object.targetableTimer or 0) + 1 end
            end
        end
    end
    if rt.complete then break end
end
local count = 0
for _ in pairs(phases) do count = count + 1 end
assert(count == expected, ('阶段遗漏：stage=%d got=%d expected=%d state=%d t=%d'):format(stage, count, expected, root.state, root.helperTimer))
assert(rt.complete and not root.active, '根对象未完成退出与结算')
if scenario == 4 then assert(targetFrames >= 900, '练习入口提前跳过了目标阶段') end
print(('stage=%d difficulty=%d scenario=%d phases=%d bullets=%d created=%d remaining=%d'):format(stage, difficulty, scenario, count, bullets, created, rt.enemyCount))
