-- 逐对象诊断共用环境：原版与移植版均只记录直接发弹，省略绘制与碰撞。
dofile("mod/GAME/ports/dreamer/LikeDreamer/core.lua")
local fixture = {frame = 0, Core = LikeDreamer.Core}
local function shot(visual, id, x, y, angle, travel, speed, radius, extra)
    print(("b %d %d %d %.5f %.5f %d %.5f %.5f %d %d"):format(
        fixture.frame, visual, id, fixture.Core.float32(x), fixture.Core.float32(y),
        math.floor(angle) % 65536, speed, travel, radius, extra))
end
LikeDreamer.Projectile = {
    spawn = shot,
    spread = function(visual, id, x, y, angle, travel, speed, radius, count, width, extra)
        local start, step = angle, 0
        if count > 1 then
            if width == 65536 then
                step = math.floor(65536 / count)
            else
                start = angle - math.floor(width / 2)
                step = width > 0 and math.floor(width / (count - 1)) or 0
            end
        end
        for i = 0, count - 1 do
            shot(visual, id, x, y, start + i * step, travel, speed, radius, extra)
        end
    end,
}
lstg = {CheckRes = function() return false end}
LikeDreamer.Enemy = {Class = {die = function(o) o.removeRequested = true end}}
LikeDreamer.Reward = {}
dofile("mod/GAME/ports/dreamer/LikeDreamer/boss_recovered.lua")
for _, unit in ipairs({"defaults", "early", "boss07", "boss08", "boss09", "late", "boss10_aux", "guard"}) do
    dofile("mod/GAME/ports/dreamer/LikeDreamer/recovered/" .. unit .. ".lua")
end
for _, module in ipairs({"boss_early", "boss_middle", "boss_late"}) do
    dofile("mod/GAME/ports/dreamer/LikeDreamer/" .. module .. ".lua")
end
player = {}
function fixture.spawnChild(rt, parent, kind, hp, x, y)
    return {parent = parent, spawnType = kind, hp = hp, maxhp = hp, ldX = x, ldY = y}
end
function fixture.update(self, rt)
    if rt.stage <= 4 then return LikeDreamer.BossEarly.update(self, rt)
    elseif rt.stage <= 7 then return LikeDreamer.BossMiddle.update(self, rt)
    else return LikeDreamer.BossLate.update(self, rt) end
end
function fixture.findFunctions()
    local functions, visited = {}, {}
    local function scan(value)
        if visited[value] then return end
        if type(value) == "table" then
            visited[value] = true
            for _, child in pairs(value) do scan(child) end
        elseif type(value) == "function" then
            visited[value] = true
            for i = 1, 100 do
                local name, child = debug.getupvalue(value, i)
                if not name then break end
                if name == "finalRootPatterns" then functions[name] = child end
                if type(child) == "function" then
                    functions[name] = child
                    scan(child)
                elseif type(child) == "table" and name ~= "_G" and
                        name ~= "Core" and name ~= "Projectile" then
                    scan(child)
                end
            end
        end
    end
    scan(LikeDreamer.BossEarly)
    scan(LikeDreamer.BossMiddle)
    scan(LikeDreamer.BossLate)
    return functions
end
return fixture
