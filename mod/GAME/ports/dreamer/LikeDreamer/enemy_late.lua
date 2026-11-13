-- Stage 5-10 non-boss enemy behavior reconstructed from the original game.
-- Coordinates and angles stay in Like Dreamer's 600x720, y-down space.

LikeDreamer = LikeDreamer or {}

local Core = assert(LikeDreamer.Core)
local Projectile = assert(LikeDreamer.Projectile)

local M = {}
LikeDreamer.LateEnemy = M

local sin, cos, sqrt = math.sin, math.cos, math.sqrt
local floor, abs = math.floor, math.abs
local min, max = math.min, math.max
local pi = math.pi
local tau = pi * 2

local handlers = {}

local EnemyDispatcher = {}
EnemyDispatcher.__index = EnemyDispatcher

function EnemyDispatcher.new(handlerMap, markerTypes, hiddenTypes)
    return setmetatable({
        handlers = handlerMap,
        markerTypes = markerTypes,
        hiddenTypes = hiddenTypes,
    }, EnemyDispatcher)
end

M.Dispatcher = EnemyDispatcher

local function difficulty(rt)
    return Core.clamp(rt.difficulty or 1, 0, 4)
end

local function diff(rt, values)
    return values[difficulty(rt) + 1]
end

local function playerPosition()
    return Core.playerLD()
end

local function aim(self, x, y)
    local px, py = playerPosition()
    return Core.aim16(x or self.ldX, y or self.ldY, px, py)
end

local function move(self, angle, speed)
    local dx, dy = Core.polar(angle or self.angle16, speed or self.speed)
    self.ldX, self.ldY = self.ldX + dx, self.ldY + dy
end

local function randomUnit(self, rt, salt)
    local entity = self.entityId or 0
    local frame = (rt.frame or 0) + (self.age or 0) * 0x45d9
    return Core.randomUnit(frame, entity * 0x9e37 + salt)
end

local function randomRange(self, rt, salt, lo, hi)
    return lo + (hi - lo) * randomUnit(self, rt, salt)
end

local function randomInt(self, rt, salt, lo, hi)
    return floor(randomRange(self, rt, salt, lo, hi + 1))
end

local function quantize(angle, step)
    return Core.angle16(floor((Core.angle16(angle) + step * 0.5) / step) * step)
end

local function adaptiveTurn(current, target, divisor)
    return Core.turn16(current, target,
        floor(abs(Core.angleDelta(current, target)) / divisor) + 0x30)
end

local function fire(visual, projectileId, x, y, angle, speed, travel, radius, arg)
    return Projectile.spawn(visual, projectileId, x, y, angle,
        travel or 0, speed, radius or 1, arg or 0)
end

local function fan(visual, projectileId, x, y, angle, speed, count, spread,
                   travel, radius, arg)
    return Projectile.spread(visual, projectileId, x, y, angle,
        travel or 0, speed, radius or 1, count, spread, arg or 0)
end

local function fireArea(x, y, margin)
    return Core.inside(x, y, margin or 0)
end

local function farFromPlayer(x, y, distance)
    local px, py = playerPosition()
    return Core.distance(x, y, px, py) >= distance
end

local function markDead(self)
    self.targetable = false
    self.deadRequested = true
end

local function markRemoved(self)
    self.targetable = false
    self.removeRequested = true
end

local function dead(self)
    return (self.hp or 1) <= 0
end

local function normalDeath(self)
    if dead(self) then
        markDead(self)
        return true
    end
    return false
end

local function spawnDeathRewardOnce(self, payoutWindow, rewardWeight)
    if self._ldRewardSpawned then return false end
    local reward = LikeDreamer.Reward
    if not reward or not reward.spawnEnemyDeathRewardBurst then return false end
    self._ldRewardSpawned = true
    if rewardWeight ~= nil then self.rewardWeight = rewardWeight end
    reward.spawnEnemyDeathRewardBurst(self, payoutWindow)
    return true
end

local function updateDeathExplosion(self, timer)
    local reward = LikeDreamer.Reward
    if not reward then return false end
    if reward.spawnStage02DeathExplosionChain then
        reward.spawnStage02DeathExplosionChain(self, timer)
    end
    if timer >= 60 and reward.spawnEnemyDeathEffects then
        reward.spawnEnemyDeathEffects(self, 2)
        self._ldDeathEffectsSpawned = true
        return true
    end
    return false
end

local function outside(self, margin, minimumAge)
    if (self.helperTimer or 0) >= (minimumAge or 0) and
       not Core.inside(self.ldX, self.ldY, margin or 0) then
        markRemoved(self)
        return true
    end
    return false
end

local function clampEntry(self, margin)
    self.ldX, self.ldY = Core.clampToPlayfield(
        self.ldX, self.ldY, -(margin or 20))
end

local function setState(self, state)
    self.state = state
    self.helperTimer = -1
end

local function enterStateNow(self, state)
    self.state = state
    self.helperTimer = 0
end

local function activateAfterMarker(self, rt, margin, initializer)
    self.targetable = false
    if self.helperTimer < 20 then return false end
    clampEntry(self, margin)
    if initializer then initializer(self, rt) end
    enterStateNow(self, 1)
    self.targetable = true
    return true
end

local function parentOf(self, expectedType)
    local parent = self.parent or self._ldParent
    if not parent or parent.removeRequested or parent.deadRequested or
       parent.active == false then
        return nil
    end
    if expectedType and parent.spawnType ~= expectedType then return nil end
    return parent
end

local function spawnChild(rt, parent, spawnType, hp, offsetX, offsetY, index,
                          angle, speed)
    if not rt.spawnChild then return nil end
    local child = rt:spawnChild(parent, spawnType, hp,
        parent.ldX + offsetX, parent.ldY + offsetY,
        offsetX, offsetY, index or 0, angle or 0, speed or 0)
    if child then
        child._ldParent = parent
        child._ldOffsetX, child._ldOffsetY = offsetX, offsetY
        child._ldIndex = index or 0
        child.angle16 = Core.angle16(angle or child.angle16 or 0)
        child.speed = speed or child.speed or 0
        child.targetable = false
    end
    return child
end

local function steerTarget(self, step)
    local target = Core.aim16(self.ldX, self.ldY,
        self._ldTargetX or self.ldX, self._ldTargetY or self.ldY)
    self.angle16 = Core.turn16(self.angle16, target, step)
end

local function scrollDelta(rt)
    return rt.scrollDelta or rt.stageScrollDelta or 1
end

-- Stage 5 ------------------------------------------------------------------

handlers[0x44] = function(self, rt)
    if self.state == 0 then
        self._ldEntryX, self._ldEntryY = self._ldEntryX or self.ldX,
                                             self._ldEntryY or self.ldY
        if not activateAfterMarker(self, rt, 20, function(e)
            local jitter = randomInt(e, rt, 0x4401, 0, 3000)
            if e._ldEntryY <= 0 then e.angle16 = 0x3a24 + jitter end
            if e._ldEntryX <= 0 then e.angle16 = -0x5dc + jitter end
            if e._ldEntryX >= 720 then e.angle16 = 0x7a24 + jitter end
            e.angle16 = Core.angle16(e.angle16)
            e.speed = (rt.stage or 5) >= 9 and 6 or 3
        end) then return end
    end

    if dead(self) then
        local px, py = playerPosition()
        if Core.distance(self.ldX, self.ldY, px, py) >= 50 and
           (difficulty(rt) ~= 0 or (self.entityId or 0) % 2 == 0) then
            local a = Core.aim16(self.ldX, self.ldY, px, py)
            local speed = diff(rt, {5.5, 6.5, 7, 6.5, 7.5})
            fire(9, 2, self.ldX, self.ldY, a, speed)
            if difficulty(rt) > 2 then fire(9, 2, self.ldX, self.ldY, a, speed + 2) end
            if difficulty(rt) > 3 then
                for _, offset in ipairs({-0xd05, 0xd05}) do
                    fire(9, 2, self.ldX, self.ldY, a + offset, speed)
                    fire(9, 2, self.ldX, self.ldY, a + offset, speed + 2)
                end
            end
        end
        markDead(self)
        return
    end
    if outside(self, 180) then return end

    if self.helperTimer < 200 then
        self.angle16 = Core.turn16(self.angle16, aim(self), 0xff)
    end
    self.speed = self.speed + 0.1
    move(self)
end

handlers[0x45] = function(self, rt)
    if self.state == 0 then
        self._ldEntryX = self._ldEntryX or self.ldX
        if not activateAfterMarker(self, rt, 20, function(e)
            e.speed = randomRange(e, rt, 0x4501, 6, 8)
            if e._ldEntryX <= 0 then e.angle16 = 0 end
            if e._ldEntryX >= 720 then e.angle16 = 0x8000 end
        end) then return end
    end
    if normalDeath(self) or outside(self, 180) then return end

    local t = self.helperTimer
    if t < 150 then
        if self.speed > 2 then self.speed = max(2, self.speed - 0.1) end
        self.angle16 = Core.turn16(self.angle16, aim(self), 0x80)
    else
        self.speed = self.speed + 0.1
        self.angle16 = Core.turn16(self.angle16, 0xc000, 0x100)
    end
    move(self)

    local start = diff(rt, {20, 14, 10, 5, 5})
    local cadence = diff(rt, {55, 30, 24, 21, 16})
    local fireY = self.ldY + 20 + sin((t - 15) * tau / 48)
    if t >= start and t < 150 and (t - start) % cadence == 0 and
       fireArea(self.ldX, fireY, -40) and self.ldX < 520 then
        local a = quantize(aim(self, self.ldX, fireY), 0x800)
        local speed = diff(rt, {5, 6, 6.5, 7.5, 9})
        fire(8, 0, self.ldX, fireY, a, speed, 10)
        if difficulty(rt) == 2 then fire(8, 0, self.ldX, fireY, a, speed + 0.5, 10) end
        if difficulty(rt) > 2 then
            fire(8, 0, self.ldX, fireY, a - 2000, speed - 1.5, 10)
            fire(8, 0, self.ldX, fireY, a + 2000, speed - 1.5, 10)
        end
    end
end

handlers[0x46] = function(self, rt)
    if self.state == 0 then
        self._ldEntryX = self._ldEntryX or self.ldX
        if not activateAfterMarker(self, rt, 50, function(e)
            e.speed = 12
            if e._ldEntryX <= 0 then e.angle16 = 2000 end
            if e._ldEntryX >= 720 then e.angle16 = 0x7830 end
        end) then return end
    end
    if normalDeath(self) then return end
    local t = self.helperTimer
    if t >= 120 and outside(self, 128) then return end

    if t < 100 then
        self.speed = self.speed - 0.12
        self.angle16 = Core.turn16(self.angle16, aim(self), 0x20)
    elseif t < 240 then
        if t == 100 then self.angle16 = aim(self) end
        if t < 130 then self.speed = self.speed + 0.05 end
        self.angle16 = Core.turn16(self.angle16, aim(self), 0x80)
    else
        self.speed = self.speed - 0.1
    end
    move(self)

    if t >= 64 and t < 240 then
        local cadence = diff(rt, {96, 64, 50, 40, 36})
        local localTime = (t - 64) % cadence
        local fireY = self.ldY + 5
        if localTime == 0 then self.secondaryAngle16 = aim(self, self.ldX, fireY) end
        if localTime < 30 and localTime % 5 == 0 and
           fireArea(self.ldX, fireY, 0) then
            local speed = diff(rt, {6, 7, 7.5, 8, 9}) + localTime * 0.06
            local spread = diff(rt, {0, 0x8ae, 0xd05, 0xd05, 0xd05})
            fire(7, 0, self.ldX, fireY, self.secondaryAngle16, speed, 10)
            if difficulty(rt) > 0 then
                fan(7, 0, self.ldX, fireY, self.secondaryAngle16,
                    speed - 1, 2, spread, 10)
            end
            if difficulty(rt) > 2 then
                fire(7, 0, self.ldX, fireY, self.secondaryAngle16, speed + 1.8, 10)
                fan(7, 0, self.ldX, fireY, self.secondaryAngle16,
                    speed + 0.8, 2, spread, 10)
            end
        end
        self.secondaryAngle16 = Core.turn16(self.secondaryAngle16,
            aim(self, self.ldX, fireY), 0x20)
    end
end

local function updateRingRoot(self, rt)
    local t = self.helperTimer
    if self.state == 0 then
        self.targetable = false
        if t == 60 and not self._ldChildrenSpawned then
            self._ldChildrenSpawned = true
            local count = diff(rt, {5, 7, 9, 9, 8})
            for i = 0, count - 1 do
                spawnChild(rt, self, 0x49, 1200, 0, 0, i,
                    i * floor(0x10000 / count) - 0x4000, 0)
            end
        end
        local entrance = min(t, 90)
        local wave = sin(entrance * pi / 180)
        local radius = 90 - floor(wave * 90)
        local a = Core.angle16((self.spawnType == 0x47 and 1 or -1) *
            floor(wave * 0x10000))
        local dx, dy = Core.polar(a, radius)
        self.ldX, self.ldY = self.originX + dx, self.originY + dy
        if t < 90 then return end
        self.ldX, self.ldY = self.originX, self.originY
        self.speed = 0.5
        self.angle16 = self.angle16 or aim(self)
        self.targetable = true
        enterStateNow(self, 1)
        t = 0
    end
    if normalDeath(self) or outside(self, 128) then return end

    if t < 121 and self.speed > 1.2 then self.speed = self.speed - 0.1 end
    self.angle16 = Core.turn16(self.angle16, aim(self), 0x80)
    if t > 299 then self.speed = self.speed - 0.1 end
    move(self)

    local cadence = diff(rt, {150, 120, 90, 90, 70})
    if t >= 80 and t < 300 and (t - 80) % cadence == 0 then
        local count = diff(rt, {3, 5, 7, 7, 9})
        local step = diff(rt, {0x12c0, 0xe10, 0x834, 0x834, 0x708})
        local speed = diff(rt, {4, 5, 5.5, 6.5, 7.5})
        local a = aim(self)
        fan(11, 0, self.ldX, self.ldY, a, speed,
            count, (count - 1) * step)
        if difficulty(rt) > 2 then
            fan(11, 0, self.ldX, self.ldY, a, speed - 1.5,
                count, floor((count - 1) * step * 1.4))
        end
    end
end

handlers[0x47] = updateRingRoot
handlers[0x48] = updateRingRoot

handlers[0x49] = function(self, rt)
    local parent = parentOf(self)
    if not parent or (parent.spawnType ~= 0x47 and parent.spawnType ~= 0x48) then
        markRemoved(self)
        return
    end
    if dead(parent) then markRemoved(self); return end
    if normalDeath(self) then return end

    local t = self.helperTimer
    if self.state == 0 then
        self.targetable = false
        local radius = t < 30 and sin(t * pi / 60) * 180 or 0
        local ox, oy = Core.polar(self.angle16, radius)
        self.ldX = self.ldX + (parent.ldX + ox - self.ldX) / 30
        self.ldY = self.ldY + (parent.ldY + oy - self.ldY) / 30
        self.angle16 = Core.angle16(self.angle16 +
            (parent.spawnType == 0x47 and 0x1bc or -0x1bc))
        if t < 30 then return end
        self.targetable = true
        enterStateNow(self, 1)
        t = 0
    else
        self.ldX = self.ldX + (parent.ldX - self.ldX) / 30
        self.ldY = self.ldY + (parent.ldY - self.ldY) / 30
        self.angle16 = Core.angle16(self.angle16 +
            (parent.spawnType == 0x47 and 0x1bc or -0x1bc))
    end

    local cadence = diff(rt, {150, 120, 90, 90, 70})
    local localTime = t % cadence
    local step = diff(rt, {12, 7, 5, 5, 4})
    if parent.helperTimer < 300 and localTime < 30 and localTime % step == 0 then
        local speed = diff(rt, {3.5, 4.5, 5, 5, 6})
        fire(4, 0, self.ldX, self.ldY, self.angle16 - 0x8000, speed)
        if difficulty(rt) > 2 then
            fire(4, 0, self.ldX, self.ldY, self.angle16 - 0x8000, speed + 1.1)
        end
    end
end

handlers[0x4a] = function(self, rt)
    if self.state == 0 then
        if not self._ldChildrenSpawned then
            self._ldChildrenSpawned = true
            local mounts = {{190, -20, -1000}, {-190, -20, 1000},
                            {90, -80, -3000}, {-90, -80, 3000}}
            for i, p in ipairs(mounts) do
                spawnChild(rt, self, 0x4b, 99999999,
                    p[1], p[2], i - 1, p[3], 0)
            end
        end
        if not activateAfterMarker(self, rt, 50, function(e)
            e.speed = 7
            e._ldBaseX, e._ldBaseY = e.ldX, e.ldY
        end) then return end
    end
    if normalDeath(self) or outside(self, 128) then return end

    local t = self.helperTimer
    if t <= 120 and self.speed > 0.8 then self.speed = max(0.8, self.speed - 0.09) end
    local baseAim = Core.aim16(self._ldBaseX, self._ldBaseY,
        playerPosition())
    self.angle16 = Core.turn16(self.angle16, baseAim, 0x80)
    if t > 289 then self.speed = self.speed - 0.1 end
    local dx, dy = Core.polar(self.angle16, self.speed)
    self._ldBaseX, self._ldBaseY = self._ldBaseX + dx, self._ldBaseY + dy
    local targetX = self._ldBaseX + sin((rt.frame or 0) * tau / 244) * 100
    self.ldX = self.ldX + (targetX - self.ldX) / 30
    self.ldY = self.ldY + (self._ldBaseY - self.ldY) / 30

    local cadence = diff(rt, {32, 24, 20, 20, 16})
    if t >= 50 and t < 290 then
        local localTime = (t - 50) % 120
        if localTime < cadence * 3 and localTime % cadence == 0 then
            local count = diff(rt, {5, 7, 9, 7, 9})
            local speed = diff(rt, {5, 5.5, 6, 6.5, 8})
            local fireY = self.ldY - 37 + sin(t * tau / 44) * 2
            local a = aim(self, self.ldX, fireY)
            fan(4, 0, self.ldX, fireY, a, speed, count, 17000)
            if difficulty(rt) > 2 and count > 1 then
                fan(4, 0, self.ldX, fireY, a, speed + 1.4,
                    count - 1, floor(17000 / (count - 1)) * (count - 2))
            end
        end
    end
end

handlers[0x4b] = function(self, rt)
    local parent = parentOf(self, 0x4a)
    if not parent or dead(parent) then markRemoved(self); return end
    self.targetable = false
    local tx = parent.ldX + self._ldOffsetX
    local ty = parent.ldY + self._ldOffsetY
    self.ldX = self.ldX + (tx - self.ldX) / 8
    self.ldY = self.ldY + (ty - self.ldY) / 8

    local interval = diff(rt, {60, 40, 34, 30, 25})
    local start = (self._ldIndex + 1) * interval + 44
    if self.helperTimer >= start and parent.state == 1 and
       parent.helperTimer < 290 and
       (self.helperTimer - start) % (interval * 5) == 0 and
       fireArea(self.ldX, self.ldY, -10) then
        spawnChild(rt, parent, 0x4c, 400,
            self.ldX - parent.ldX, self.ldY - parent.ldY,
            self._ldIndex, aim(self, self.ldX, self.ldY + 30), 3.6)
    end
end

handlers[0x4c] = function(self, rt)
    move(self)
    if self.state == 0 then
        self.targetable = false
        if self.helperTimer < 20 then return end
        self.radius = difficulty(rt) <= 1 and 64 or 80
        self.targetable = true
        enterStateNow(self, 1)
    end
    if dead(self) then
        local px, py = playerPosition()
        if Core.distance(self.ldX, self.ldY, px, py) >= (self.radius or 64) + 30 and
           self.ldY < 520 and self.ldY < py then
            local count = difficulty(rt) < 2 and 15 or 19
            local speed = diff(rt, {4.5, 5.5, 6.5, 5.5, 7})
            local ringRadius = (self.radius or 64) - 15
            for i = 0, count - 1 do
                local ox, oy = Core.polar(i * 0x10000 / count, ringRadius)
                local x, y = self.ldX + ox, self.ldY + oy
                local a = Core.aim16(x, y, px, py)
                fire(13, 2, x, y, a, speed)
                if difficulty(rt) > 2 then fire(13, 2, x, y, a, speed + 2) end
            end
        end
        local parent = self.parent or self._ldParent
        if parent and parent.spawnType == 0x4a and not self._ldDamageTransferred then
            self._ldDamageTransferred = true
            parent.hp = max(0, parent.hp - (self.maxhp or 400))
        end
        markDead(self)
        return
    end
    outside(self, 180)
end

handlers[0x4d] = function(self, rt)
    if self.state == 2 then
        self.targetable = false
        local timer = self.helperTimer
        updateDeathExplosion(self, timer)
        self.ldY = self.ldY + timer * 0.06
        if timer >= 60 then markDead(self) end
        return
    end
    if self.state == 0 then
        self._ldEntryX = self._ldEntryX or self.ldX
        if not activateAfterMarker(self, rt, 50, function(e)
            e.speed = 9
            e.angle16 = e._ldEntryX <= 0 and 0 or 0x8000
            local mounts = {{16, 99}, {79, 70}, {-61, 67}}
            for i, p in ipairs(mounts) do
                spawnChild(rt, e, 0x4e, 1200, p[1], p[2], i - 1,
                    i * 0x5555, 0)
            end
        end) then return end
    end
    if dead(self) then
        spawnDeathRewardOnce(self, 500)
        self.hp = 1
        self.targetable = false
        self.ldY = self.ldY + 230
        self.radius = 150
        setState(self, 2)
        return
    end
    if outside(self, 180) then return end

    local t = self.helperTimer
    if t < 90 and self.speed > 0.5 then self.speed = max(0.5, self.speed - 0.1) end
    self.angle16 = Core.turn16(self.angle16, aim(self), min(0x40, t * 4))
    if t > 359 then self.speed = self.speed - 0.1 end
    move(self)

    if t >= 90 and t < 360 then
        local cadence = diff(rt, {101, 72, 65, 60, 60})
        local rootLocal = t - 90
        if rootLocal % cadence == 0 then self.secondaryAngle16 = aim(self) end
        local burst = diff(rt, {20, 30, 35, 35, 35})
        local turn = diff(rt, {33, 55, 66, 99, 120})
        local count = diff(rt, {5, 9, 11, 11, 13})
        local speed = diff(rt, {6.6, 8, 9, 10, 12})
        local direction = (self.originX or self.ldX) >= 360 and 1 or -1
        local function sweep(localTime, sign)
            if localTime >= 0 and localTime < burst and localTime % 5 == 0 then
                fan(3, 7, self.ldX, self.ldY,
                    self.secondaryAngle16 + sign * direction * localTime * turn,
                    speed, count, 30000, 10)
            end
        end
        sweep(rootLocal % (cadence * 2), 1)
        sweep((t - cadence - 90) % (cadence * 2), -1)
    end
end

handlers[0x4e] = function(self, rt)
    local parent = parentOf(self, 0x4d)
    if not parent or parent.state == 2 or dead(parent) then markRemoved(self); return end
    if normalDeath(self) then return end
    self.targetable = true
    local mountAngle = Core.angle16(self._ldIndex * 0x5555 + (rt.frame or 0) * 0x100)
    local ox, oy = Core.polar(mountAngle, 30)
    local tx = parent.ldX + self._ldOffsetX + ox
    local ty = parent.ldY + self._ldOffsetY + oy
    self.ldX = self.ldX + (tx - self.ldX) / 8
    self.ldY = self.ldY + (ty - self.ldY) / 8
    self.secondaryAngle16 = adaptiveTurn(self.secondaryAngle16 or aim(self), aim(self), 10)
    local cadence = diff(rt, {41, 23, 20, 17, 14})
    local stagger = (self._ldIndex * floor(cadence / 3)) % cadence
    if (self.helperTimer + stagger) % cadence == 0 and
       fireArea(self.ldX, self.ldY, 0) then
        local a = quantize(self.secondaryAngle16, 0x400)
        local speed = diff(rt, {3.6, 4.5, 5.5, 6, 8})
        fire(0, 0, self.ldX, self.ldY, a, speed)
        if difficulty(rt) > 2 then fire(0, 0, self.ldX, self.ldY, a, speed - 1.8) end
    end
end

-- Stage 6 ------------------------------------------------------------------

local function updateStage6Heavy(self, rt)
    if self.state == 0 then
        if not activateAfterMarker(self, rt, 50, function(e)
            e.angle16 = e.spawnType == 0x57 and 0x58f0 or 0x2710
            e.speed = 9
        end) then return end
    end
    local pendingDeath = dead(self)
    local t = self.helperTimer
    if not pendingDeath and t >= 120 and outside(self, 128) then return end
    if t < 100 then
        self.speed = self.speed - 0.09
        self.angle16 = Core.turn16(self.angle16, aim(self), 0x20)
    elseif t < 240 then
        if t == 100 then self.angle16 = aim(self) end
        if t < 130 then self.speed = self.speed + 0.05 end
        self.angle16 = Core.turn16(self.angle16, aim(self), 0x80)
    else
        self.speed = self.speed - 0.1
    end
    move(self)

    if t >= 40 and t < 240 then
        local localTime = (t - 40) % 160
        if localTime == 0 then
            local count = diff(rt, {3, 5, 7, 9, 13})
            local speed = diff(rt, {5.2, 6, 6.5, 6.5, 7.5})
            local a = aim(self)
            fan(11, 0, self.ldX, self.ldY, a, speed, count, 18000)
            if difficulty(rt) > 2 then
                fan(11, 0, self.ldX, self.ldY, a, speed + 1.1, count, 18000)
            end
        end
        local cadence = diff(rt, {47, 19, 15, 15, 10})
        local gunSpeed = diff(rt, {3.6, 4.5, 5, 5, 6})
        for i = 0, 2 do
            local orbit = Core.angle16((rt.frame or 0) * 0x29a + i * 0x5555)
            local ox, oy = Core.ellipse(orbit, 36, 20, 0)
            local x, y = self.ldX + ox, self.ldY + 20 + oy
            if (t + i * floor(cadence / 3)) % cadence == 0 and fireArea(x, y, 0) then
                local a = Core.aim16(x, y, playerPosition())
                fire(4, 0, x, y, a, gunSpeed)
                if difficulty(rt) > 2 then
                    fire(4, 0, x, y, a - 0x92e, gunSpeed)
                    fire(4, 0, x, y, a + 0x92e, gunSpeed)
                end
            end
        end
    end
    if pendingDeath then markDead(self) end
end

handlers[0x57] = updateStage6Heavy
handlers[0x58] = updateStage6Heavy

handlers[0x59] = function(self, rt)
    if self.state == 0 then
        self._ldEntryX = self._ldEntryX or self.ldX
        if not activateAfterMarker(self, rt, 50, function(e)
            e._ldBaseY = e.ldY
            e._ldSide = e._ldEntryX < 360 and -1 or 1
            e.angle16 = aim(e)
        end) then return end
    end
    local pendingDeath = dead(self)
    local t = self.helperTimer
    if not pendingDeath and t > 119 and outside(self, 128) then return end
    local amplitude = 160
    if t < 118 then amplitude = 460 - sin(t * pi / 236) * 300 end
    self.ldX = 360 + sin((t + 59) * tau / 236) * amplitude * self._ldSide
    self.ldY = self._ldBaseY + sin(t * tau / 172) * -70
    if t > 300 then
        self._ldExitSpeed = (self._ldExitSpeed or 0) + 0.1
        self._ldBaseY = self._ldBaseY - self._ldExitSpeed
    end

    if t >= 50 and t < 300 then
        local period = diff(rt, {180, 140, 100, 90, 70})
        local step = diff(rt, {50, 33, 27, 24, 18})
        local localTime = (t - 50) % period
        if localTime == 0 then self.secondaryAngle16 = aim(self) end
        if localTime < step * 3 and localTime % step == 0 then
            local baseCount = diff(rt, {3, 3, 5, 5, 7})
            local scale = diff(rt, {1, 3, 3, 3, 1})
            local count = baseCount + floor(localTime / step) * scale
            local spreadStep = diff(rt, {5000, 3000, 2500, 2200, 1900})
            local speed = diff(rt, {3.8, 4.5, 5, 6, 7.2}) + localTime * 0.007
            fan(5, 0, self.ldX, self.ldY, self.secondaryAngle16,
                speed, count, (count - 1) * spreadStep)
        end
    end
    if pendingDeath then markDead(self) end
end

handlers[0x5a] = function(self, rt)
    self.originY = (self.originY or self.ldY) + scrollDelta(rt)
    if self.state == 0 then
        self.ldY = self.originY
        self.targetable = false
        if self.originY < -80 then return end
        enterStateNow(self, 1)
    end
    local t = self.helperTimer
    self.ldX = self.originX + sin((t - (self.entityId or 0) * 7) * tau / 53) * 2
    self.ldY = self.originY + sin((t - (self.entityId or 0) * 11) * tau / 73) * 2
    if self.originY >= 0 then self.targetable = true end
    local pendingDeath = dead(self)
    if not pendingDeath and self.ldY >= 760 then markRemoved(self); return end

    local a = aim(self, self.ldX, self.ldY + 7)
    self.angle16 = adaptiveTurn(self.angle16, a, 10)
    if t > 69 and self.originY < 400 then
        local period = diff(rt, {77, 48, 36, 36, 32})
        local localTime = (t - 70) % period
        if localTime == 0 then self.secondaryAngle16 = a end
        local speed = diff(rt, {5, 6, 6.6, 6.6, 7.7})
        if localTime < 12 and localTime % 4 == 0 then
            fire(4, 0, self.ldX, self.ldY + 7, self.secondaryAngle16, speed)
        end
        if difficulty(rt) > 2 and t > 89 and (t - 90) % period == 0 then
            fire(5, 0, self.ldX, self.ldY + 7, self.secondaryAngle16 - 800, speed + 0.5)
            fire(5, 0, self.ldX, self.ldY + 7, self.secondaryAngle16 + 800, speed + 0.5)
        end
    end
    if pendingDeath then markDead(self) end
end

local function updateStage6Cross(self, rt)
    self.ldY = self.ldY + scrollDelta(rt)
    if self.state == 0 then
        self.targetable = false
        if self.helperTimer < 20 then return end
        self.speed = 1.5
        self.angle16 = self.ldX <= 0 and 0 or 0x8000
        if self.spawnType == 0x5c then
            self.angle16 = self.originX <= 360 and 0xe0c0 or 0x9f40
        end
        enterStateNow(self, 1)
    end
    local pendingDeath = dead(self)
    local t = self.helperTimer
    if self.spawnType == 0x5c then
        self.angle16 = Core.angle16(self.angle16 +
            (self.originX <= 360 and 0x13 or -0x12))
    end
    move(self)
    if fireArea(self.ldX, self.ldY, 20) then self.targetable = true end
    if not pendingDeath and self.targetable and outside(self, 100) then return end

    local cadence = diff(rt, {44, 21, 15, 9, 7})
    local localTime = t % (cadence * 5)
    local y = self.ldY + sin((t % 50) * pi / 50) * -10 - 5
    if localTime < cadence * 3 and localTime % cadence == 0 and
       y < 360 and farFromPlayer(self.ldX, y, 50) then
        local a = quantize(aim(self, self.ldX, y), 0x800)
        local speed = diff(rt, {4.5, 5, 5.5, 5.5, 7})
        fire(1, 0, self.ldX, y, a, speed)
        if difficulty(rt) > 2 then fire(1, 0, self.ldX, y, a, speed + 1.5) end
    end
    if pendingDeath then markDead(self) end
end

handlers[0x5b] = updateStage6Cross
handlers[0x5c] = updateStage6Cross

handlers[0x5d] = function(self, rt)
    self.ldY = self.ldY + scrollDelta(rt)
    if self.state == 0 then
        self.targetable = false
        if self.ldY < -100 then return end
        enterStateNow(self, 1)
    end
    local t = self.helperTimer
    if t >= 60 then self.targetable = true end
    local pendingDeath = dead(self)
    if not pendingDeath and self.ldY >= 820 then markRemoved(self); return end
    if t < 110 or self.ldY >= 400 then
        if pendingDeath then markDead(self) end
        return
    end

    local cadence = diff(rt, {180, 100, 80, 70, 50})
    local localTime = (t - 110) % cadence
    local sourceY = self.ldY + 12
    if localTime == 0 then self.secondaryAngle16 = aim(self, self.ldX, sourceY) end
    self.secondaryAngle16 = Core.turn16(self.secondaryAngle16,
        aim(self, self.ldX, sourceY), 0x20)
    if localTime < 20 and localTime % 10 == 0 then
        local speed = diff(rt, {5.5, 6.5, 7.5, 6.5, 8})
        for _, side in ipairs({-1, 1}) do
            local x = self.ldX + side * 55
            fire(13, 0, x, sourceY, self.secondaryAngle16, speed, 10)
            if difficulty(rt) > 0 then
                fire(13, 0, x, sourceY,
                    self.secondaryAngle16 + side * 8000, speed, 10)
            end
            if difficulty(rt) > 2 then
                fire(13, 0, x, sourceY, self.secondaryAngle16, speed + 2, 10)
                fire(13, 0, x, sourceY,
                    self.secondaryAngle16 + side * 8000, speed + 2, 10)
            end
        end
    end
    if pendingDeath then markDead(self) end
end

handlers[0x5e] = function(self, rt)
    self.originY = (self.originY or self.ldY) + scrollDelta(rt)
    if self.state == 0 then
        self.targetable = false
        self.ldY = self.originY
        if self.originY < -140 then return end
        enterStateNow(self, 1)
    end
    local t = self.helperTimer
    self.ldX = self.originX + sin((t - (self.entityId or 0) * 7) * tau / 83) * 3
    self.ldY = self.originY + sin((t - (self.entityId or 0) * 11) * tau / 100) * 3
    if self.originY >= -40 then self.targetable = true end
    local pendingDeath = dead(self)
    if not pendingDeath and self.ldY >= 820 then markRemoved(self); return end
    if t < 120 or self.ldY >= 360 then
        if pendingDeath then markDead(self) end
        return
    end

    local period = diff(rt, {120, 60, 50, 45, 45})
    local window = diff(rt, {16, 16, 20, 24, 30})
    local localTime = (t - 120) % period
    local spin = sin(t * tau / 177) * 2000
    local side = self.originX < 360 and 1 or -1
    local sourceAngle = Core.angle16((side > 0 and 0x0a00 or 0x7600) + spin)
    local ox, oy = Core.polar(sourceAngle, sqrt(1700))
    local x, y = self.ldX + ox, self.ldY + oy
    if localTime == 0 then self.secondaryAngle16 = aim(self, x, y) end
    local speed = diff(rt, {6, 6.8, 7.5, 8.5, 9.5})
    if localTime < window and localTime % 4 == 0 then
        local count = floor(localTime / 4) + 1
        fan(9, 0, x, y, self.secondaryAngle16,
            speed, count, (count - 1) * 400, 10)
    end
    local second = period + 130 + window
    if t >= second and (t - second) % (period * 2) == 0 then
        local count = diff(rt, {9, 11, 13, 13, 15})
        fan(14, 0, x, y, self.secondaryAngle16, speed - 2, count, 27000)
        if difficulty(rt) > 2 then
            fan(14, 0, x, y, self.secondaryAngle16, speed - 1, count, 27000)
        end
    end
    if pendingDeath then markDead(self) end
end

handlers[0x5f] = function(self, rt)
    if self.state == 2 then
        self.targetable = false
        local timer = self.helperTimer
        updateDeathExplosion(self, timer)
        if timer >= 60 then markDead(self) end
        return
    end
    self.originY = (self.originY or self.ldY) + scrollDelta(rt)
    if self.state == 0 then
        self.targetable = false
        self.ldY = self.originY
        if self.originY < -100 then return end
        enterStateNow(self, 1)
    end
    local t = self.helperTimer
    self.ldY = self.originY
    if t >= 80 then self.targetable = true end
    if t == 90 and not self._ldChildrenSpawned then
        self._ldChildrenSpawned = true
        local count = diff(rt, {5, 5, 7, 7, 9})
        for i = 0, count - 1 do
            spawnChild(rt, self, 0x60, 99999999, 0, 0, i,
                i * floor(0x10000 / count), 0)
        end
    end
    if dead(self) then
        spawnDeathRewardOnce(self, 0x708)
        self.hp = 1
        self.targetable = false
        setState(self, 2)
        return
    end
    if self.ldY >= 820 then markRemoved(self) end
end

handlers[0x60] = function(self, rt)
    local parent = parentOf(self, 0x5f)
    if not parent or parent.state == 2 or dead(parent) or parent.ldY >= 450 then
        markRemoved(self)
        return
    end
    self.targetable = false
    local t = self.helperTimer
    local rx = sin(min(t, 120) * pi / 240) * 90
    local ry = sin(min(t, 120) * pi / 240) * 50
    local lift = sin(min(t, 180) * pi / 360) * 120
    self.angle16 = Core.angle16(self.angle16 -
        floor(sin((rt.frame or 0) * tau / 470) * 130))
    local ox, oy = Core.ellipse(self.angle16, rx, ry, 0)
    self.ldX, self.ldY = parent.ldX + ox, parent.ldY + oy - lift
    self.secondaryAngle16 = Core.angle16(self.angle16 - 0x4000)

    if t > 39 then
        local period = diff(rt, {36, 32, 32, 32, 32})
        local window = diff(rt, {16, 16, 20, 20, 20})
        local localTime = (t - 40) % period
        if localTime < window and localTime % 4 == 0 then
            local count = diff(rt, {1, 2, 2, 2, 2})
            local speed = diff(rt, {4.8, 5.5, 6, 6, 7.5})
            fan(5, 0, self.ldX, self.ldY, self.secondaryAngle16,
                speed, count, 4000)
            if difficulty(rt) > 2 then
                fan(5, 0, self.ldX, self.ldY, self.secondaryAngle16,
                    speed + 0.5, count, 4000)
            end
        end
    end
end

-- Stage 7 ------------------------------------------------------------------

handlers[0x70] = function(self, rt)
    if self.state == 0 then
        self._ldEntryX, self._ldEntryY = self._ldEntryX or self.ldX,
                                             self._ldEntryY or self.ldY
        if not activateAfterMarker(self, rt, 20, function(e)
            e.speed = randomRange(e, rt, 0x7001, 6, 9)
            if e._ldEntryX <= 0 then e.angle16 = 0 end
            if e._ldEntryX >= 720 then e.angle16 = 0x8000 end
            if e._ldEntryY >= 720 then
                e.speed = randomRange(e, rt, 0x7002, 11, 12)
                e.angle16 = 0xc000
            end
            e.secondaryAngle16 = 0x4000
            e._ldBaseX, e._ldBaseY = e.ldX, e.ldY
        end) then return end
    end
    local pendingDeath = dead(self)
    if not pendingDeath and outside(self, 180) then return end
    local t = self.helperTimer
    local px, py = playerPosition()
    local aimed = Core.aim16(self.ldX, self.ldY + 24, px, py)
    if aimed < 4000 or aimed > 0xf0c0 then
        aimed = 4000
    elseif aimed > 0x7060 then
        aimed = 0x7060
    end
    if t < 200 then
        if self.speed > 0.5 then self.speed = self.speed - 0.1 end
        if self.speed < 1.2 then self.angle16 = Core.turn16(self.angle16, aimed, 0x40) end
    else
        self.angle16 = Core.turn16(self.angle16, 0xc000, 0x200)
        self.speed = self.speed + 0.05
    end
    move(self)
    self.secondaryAngle16 = adaptiveTurn(self.secondaryAngle16, aimed, 10)

    local start = self._ldEntryY >= 720 and 70 or 20
    local cadence = diff(rt, {60, 45, 33, 30, 20})
    if t >= start and t < 200 and (t - start) % cadence == 0 then
        local angleRadians = Core.angleToRadians(self.secondaryAngle16)
        local x = self.ldX + cos(angleRadians) * 20
        local y = self.ldY + 24 + sin(angleRadians) * 20
        local count = diff(rt, {3, 5, 5, 5, 7})
        local speed = diff(rt, {5, 6, 7, 9, 9})
        fan(0x0c, 0, x, y, self.secondaryAngle16,
            speed, count, (count - 1) * 0x1c2)
        if difficulty(rt) > 2 then
            fan(0x0c, 0, x, y, self.secondaryAngle16,
                speed - 1.5, count, 3000)
        end
    end
    if pendingDeath then markDead(self) end
end

local function updateStage7Arc(self, rt)
    if self.state == 0 then
        if not self._ldPrepared then
            self._ldPrepared = true
            local side = self.spawnType == 0x71 and 1 or -1
            self.ldX = self.originX + side * 640
            self.originY = self.originY - 120
        end
        if not activateAfterMarker(self, rt, 50, function(e)
            e.speed = 1
            e.angle16 = aim(e)
        end) then return end
    end
    local pendingDeath = dead(self)
    local t = self.helperTimer
    if not pendingDeath and t > 150 and outside(self, 128) then return end
    if t < 120 then
        local phase = t * tau / 480
        local side = self.spawnType == 0x71 and 1 or -1
        self.ldX = self.originX + side * 640 - side * sin(phase) * 640
        self.ldY = self.originY - sin(phase) * 60
        self.originY = self.originY + 1
    else
        if t < 130 then self.speed = self.speed + 0.05 end
        self.angle16 = Core.turn16(self.angle16, aim(self), 0x80)
        if t > 299 then self.speed = self.speed - 0.1 end
        move(self)
    end

    local period = diff(rt, {150, 120, 90, 80, 80})
    if t >= 70 and t < 300 then
        local localTime = (t - 70) % period
        local rightX, leftX, y = self.ldX + 40, self.ldX - 40, self.ldY - 40
        if localTime == 0 then
            self.secondaryAngle16 = aim(self, rightX, y)
            self.targetAngle16 = aim(self, leftX, y)
        end
        local step = diff(rt, {19, 12, 12, 10, 8})
        if localTime < 50 and localTime % step == 0 then
            local turn = localTime * 0x20
            local speed = diff(rt, {6, 7, 7.5, 8.5, 9.5})
            fire(9, 0, rightX, y, self.secondaryAngle16 - turn, speed, 10)
            fire(9, 0, leftX, y, self.targetAngle16 + turn, speed, 10)
            if difficulty(rt) > 1 then
                fire(9, 0, rightX, y, self.secondaryAngle16 - turn - 4000, speed, 10)
                fire(9, 0, leftX, y, self.targetAngle16 + turn + 4000, speed, 10)
            end
        end
    end
    if t >= 125 and t < 300 and (t - 125) % period == 0 then
        local count = diff(rt, {3, 5, 5, 5, 7})
        local speed = diff(rt, {4.2, 5, 6, 6, 7})
        local a = aim(self, self.ldX, self.ldY - 30)
        fan(4, 0, self.ldX, self.ldY - 30, a, speed, count, 12000)
        if difficulty(rt) > 2 and count > 1 then
            fan(4, 0, self.ldX, self.ldY - 30, a, speed + 1.2,
                count - 1, floor(12000 * (count - 2) / (count - 1)))
        end
    end
    if pendingDeath then markDead(self) end
end

handlers[0x71] = updateStage7Arc
handlers[0x72] = updateStage7Arc

handlers[0x73] = function(self, rt)
    if self.state == 0 then
        if not activateAfterMarker(self, rt, 50, function(e)
            e.speed = 7
            e.secondaryAngle16 = 0x4000
            e.angle16 = aim(e)
        end) then return end
    end
    local pendingDeath = dead(self)
    local t = self.helperTimer
    if not pendingDeath and t > 150 and outside(self, 128) then return end
    if t < 121 and self.speed > 0.6 then self.speed = self.speed - 0.1 end
    self.angle16 = Core.turn16(self.angle16, aim(self), 0x40)
    if t > 359 then self.speed = self.speed - 0.1 end
    move(self)
    self.secondaryAngle16 = adaptiveTurn(self.secondaryAngle16,
        aim(self, self.ldX, self.ldY + 25), 10)

    local spinCadence = diff(rt, {18, 10, 8, 6, 5})
    if t >= 30 and t < 360 and (t - 30) % spinCadence == 0 then
        local spin = t * diff(rt, {150, 200, 240, 270, 320})
        local count = difficulty(rt) == 0 and 1 or 2
        local speed = diff(rt, {4.8, 5, 5.8, 6.5, 7.5})
        local sources = {
            {85, 50, -0x6000 - spin}, {-85, 50, -0x2000 + spin},
            {-83, -35, -0x4000 - spin}, {83, -35, -0x4000 + spin},
        }
        for _, source in ipairs(sources) do
            fan(7, 0, self.ldX + source[1], self.ldY + source[2],
                source[3], speed, count, 0x10000, 10)
        end
    end
    local aimPeriod = diff(rt, {160, 120, 90, 90, 70})
    local aimLocal = (t - 50) % aimPeriod
    if t >= 50 and t < 360 and aimLocal < 50 and aimLocal % 18 == 0 then
        local ox, oy = Core.polar(self.secondaryAngle16, 45)
        local x, y = self.ldX + ox, self.ldY + 25 + oy
        local count = diff(rt, {1, 3, 3, 3, 3})
        local speed = diff(rt, {6, 6.6, 7, 7, 8.5})
        fan(0x0c, 0, x, y, self.secondaryAngle16, speed, count, 5000, 10)
        if difficulty(rt) > 2 and count > 1 then
            fan(0x0c, 0, x, y, self.secondaryAngle16,
                speed + 1, count, 5000, 10)
        end
    end
    if pendingDeath then markDead(self) end
end

local function platformPosition(self, t, riseFrames, holdEnd, fallEnd,
                                lift, exitBase, sway)
    if sway then self.ldX = self.originX + sin(t * tau / 320) * sway
    else self.ldX = self.originX end
    local baseY = self.originY
    if t < riseFrames then
        self.ldY = baseY - floor(sin(t * pi / (riseFrames * 2)) * lift)
    elseif t < holdEnd then
        self.ldY = baseY - lift
    elseif t < fallEnd then
        local fallDuration = fallEnd - holdEnd
        self.ldY = baseY - floor(sin((t - holdEnd + fallDuration) *
            pi / (fallDuration * 2)) * lift)
    else
        self.ldY = baseY
        self.originY = self.originY + exitBase + (t - fallEnd) * 0.05
    end
end

handlers[0x74] = function(self, rt)
    if self.state == 0 and not activateAfterMarker(self, rt, 20) then return end
    local pendingDeath = dead(self)
    local t = self.helperTimer
    platformPosition(self, t, 120, 300, 480, 800, 1, 32)
    if not pendingDeath and outside(self, 180) then return end
    if t >= 70 and t < 480 and self.ldY < 360 and fireArea(self.ldX, self.ldY) then
        local period = diff(rt, {72, 48, 40, 40, 32})
        local localTime = (t - 70) % period
        if localTime == 0 then self.secondaryAngle16 = aim(self) end
        if localTime < 18 and localTime % 6 == 0 and
           farFromPlayer(self.ldX, self.ldY, 50) then
            local jitter = randomInt(self, rt, 0x7400 + t, -800, 800)
            local speed = diff(rt, {4.2, 5.4, 6, 5.5, 7})
            fire(1, 0, self.ldX, self.ldY, self.secondaryAngle16 + jitter, speed)
            if difficulty(rt) > 2 then
                fire(1, 0, self.ldX, self.ldY,
                    self.secondaryAngle16 + jitter, speed + 2.4)
            end
        end
    end
    if pendingDeath then markDead(self) end
end

handlers[0x75] = function(self, rt)
    if self.state == 0 and not activateAfterMarker(self, rt, 20) then return end
    local pendingDeath = dead(self)
    local t = self.helperTimer
    platformPosition(self, t, 120, 300, 480, 800, 0.5)
    if not pendingDeath and outside(self, 300) then return end
    local divisor = difficulty(rt) == 0 and 82 or 41
    local y = self.ldY + 20
    if t >= 60 and t < 480 and (rt.frame or 0) % divisor == 0 and
       y < 360 and fireArea(self.ldX, y) and farFromPlayer(self.ldX, y, 50) then
        local a = aim(self, self.ldX, y)
        local speed = diff(rt, {4, 5.5, 6.5, 6.5, 7.7})
        if difficulty(rt) == 0 then
            fire(5, 0, self.ldX, y, a - 1000, speed + 1)
            fire(5, 0, self.ldX, y, a + 1000, speed + 1)
        else
            for _, offset in ipairs({-2000, 0, 2000}) do
                fire(5, 0, self.ldX, y, a + offset, speed)
            end
            if difficulty(rt) ~= 1 then
                fire(5, 0, self.ldX, y, a - 1000, speed + 1)
                fire(5, 0, self.ldX, y, a + 1000, speed + 1)
            end
            if difficulty(rt) > 2 then
                for _, offset in ipairs({-4000, 4000}) do fire(5, 0, self.ldX, y, a + offset, speed) end
                for _, offset in ipairs({-3000, 3000}) do fire(5, 0, self.ldX, y, a + offset, speed + 1) end
            end
        end
    end
    if pendingDeath then markDead(self) end
end

handlers[0x76] = function(self, rt)
    if self.state == 0 then
        if not activateAfterMarker(self, rt, 50, function(e)
            e.secondaryAngle16 = 0x4000
        end) then return end
    end
    local pendingDeath = dead(self)
    local t = self.helperTimer
    platformPosition(self, t, 120, 420, 600, 750, 0.25)
    if not pendingDeath and outside(self, 180) then return end
    local aimed = aim(self, self.ldX, self.ldY + 24)
    if aimed < 6000 or aimed > 0xf000 then aimed = 6000
    elseif aimed > 0x6890 then aimed = 0x6890 end
    local cycle = (t - 70) % 164
    if t < 70 or cycle > 99 then
        self.secondaryAngle16 = adaptiveTurn(self.secondaryAngle16, aimed, 20)
    end
    if t < 70 or t >= 600 or self.ldY >= 360 then
        if pendingDeath then markDead(self) end
        return
    end

    local bob = sin((t - 2) * pi / 4) * 2
    local ox, oy = Core.polar(self.secondaryAngle16, 88)
    local muzzleX, muzzleY = self.ldX + ox, self.ldY + bob + oy
    local bx, by = Core.polar(self.secondaryAngle16, -60)
    local centerX, centerY = self.ldX + bx, self.ldY + bob + by
    local lx, ly = Core.polar(self.secondaryAngle16 - 0x32c8, 87)
    local rx, ry = Core.polar(self.secondaryAngle16 + 0x32c8, 87)
    local leftX, leftY = centerX + lx, centerY + ly
    local rightX, rightY = centerX + rx, centerY + ry

    if cycle < 32 and cycle % 4 == 0 then
        local speed = diff(rt, {6, 7, 8, 9, 11})
        if difficulty(rt) > 1 then
            fire(10, 0, muzzleX, muzzleY, self.secondaryAngle16 - 1500, speed - 1.6, 10)
            fire(10, 0, muzzleX, muzzleY, self.secondaryAngle16 + 1500, speed - 1.6, 10)
        end
        fire(10, 0, muzzleX, muzzleY, self.secondaryAngle16 - 750, speed - 0.8, 10)
        fire(10, 0, muzzleX, muzzleY, self.secondaryAngle16 + 750, speed - 0.8, 10)
        fire(10, 0, muzzleX, muzzleY, self.secondaryAngle16, speed, 10)
    end

    local pairCadence = diff(rt, {30, 20, 20, 20, 20})
    local pairCount = diff(rt, {1, 2, 3, 5, 7})
    local pairStep = diff(rt, {8000, 4800, 4000, 3200, 2700})
    if cycle == 20 then self.targetAngle16 = (pairCount - 1) * pairStep / 2 end
    if cycle >= 20 and cycle < 80 then
        local sub = (cycle - 20) % pairCadence
        local spread = (pairCount - 1) * pairStep
        local speed = diff(rt, {10, 7, 8, 9, 10})
        local leftAngle = self.secondaryAngle16 - self.targetAngle16
        local rightAngle = self.secondaryAngle16 + self.targetAngle16
        if sub < 12 and sub % 3 == 0 then
            fan(7, 0, leftX, leftY, leftAngle, speed, pairCount, spread, 10)
            fan(7, 0, rightX, rightY, rightAngle, speed, pairCount, spread, 10)
        end
        if sub == 0 then
            fan(0x0f, 0, leftX, leftY, leftAngle, speed, pairCount, spread, 20)
            fan(0x0f, 0, rightX, rightY, rightAngle, speed, pairCount, spread, 20)
        end
    end
    if cycle >= 35 and cycle < 70 and (cycle - 35) % pairCadence == 0 then
        self.targetAngle16 = Core.angle16(self.targetAngle16 +
            diff(rt, {5000, 3000, 2700, 2400, 2000}))
    end
    local aimCadence = diff(rt, {36, 20, 18, 18, 16})
    if cycle >= 50 and cycle < 100 and (cycle - 50) % aimCadence == 0 then
        local count = diff(rt, {5, 9, 11, 9, 11})
        local speed = diff(rt, {6, 8, 10, 10, 12})
        local a = aim(self, centerX, centerY)
        fan(2, 7, centerX, centerY, a, speed, count, 27000, 10)
        if difficulty(rt) > 2 then
            fan(2, 7, centerX, centerY, a, speed + 1.5, count, 27000, 10)
        end
    end
    if pendingDeath then markDead(self) end
end

handlers[0x77] = function(self, rt)
    if self.state == 2 then
        self.targetable = false
        local timer = self.helperTimer
        updateDeathExplosion(self, timer)
        self.ldY = self.ldY + timer * 0.1
        if timer >= 60 then
            rt.gate = false
            markDead(self)
        end
        return
    end
    if self.state == 0 then
        if not activateAfterMarker(self, rt, 50, function(e)
            spawnChild(rt, e, 0x78, 1800, -40, 140, 0, 0x4000, 0)
            spawnChild(rt, e, 0x78, 1800, 40, 70, 1, 0x4000, 0)
        end) then return end
    end
    local t = self.helperTimer
    platformPosition(self, t, 150, 1020, 1200, 900, 0.25)
    local pendingDeath = dead(self)
    local function enterDeathState()
        spawnDeathRewardOnce(self, 0x708)
        self.hp = 1
        self.targetable = false
        setState(self, 2)
    end
    if not pendingDeath and outside(self, 240) then rt.gate = false; return end
    if t < 120 or t >= 1200 or self.ldY >= 360 then
        if pendingDeath then enterDeathState() end
        return
    end

    local localTime = (t - 120) % 328
    local ringCadence = diff(rt, {19, 13, 11, 10, 8})
    local ringCount = diff(rt, {6, 8, 9, 10, 10})
    local direction = self.originX >= 360 and -1 or 1
    local center = direction * t * diff(rt, {80, 100, 100, 120, 150})
    if localTime < 120 and localTime % ringCadence == 0 then
        local speed = diff(rt, {5.4, 6, 6.5, 7, 8})
        fan(4, 0, self.ldX, self.ldY + 10, center,
            speed, ringCount, 0x10000)
        fan(4, 0, self.ldX, self.ldY + 10,
            center + direction * floor(0x10000 / (ringCount * 3)),
            speed - 0.5, ringCount, 0x10000)
    end
    local sourceCadence = diff(rt, {32, 15, 15, 15, 12})
    local sourceCount = diff(rt, {3, 3, 5, 5, 7})
    local sourceSpeed = diff(rt, {4.4, 5, 5.5, 6, 7})
    local bob = sin(t * pi / 4) * 2
    local baseAim = aim(self, self.ldX, self.ldY + bob)
    local sources = {{-125, 125}, {125, 125}, {125, 40}, {-125, 40}}
    for i, p in ipairs(sources) do
        local start = 160 + (i - 1) * sourceCadence
        if localTime >= start and localTime < 300 and
           (localTime - start) % (sourceCadence * 5) == 0 then
            local bias = (i - 1) % 2 == 0 and -8000 or -2000
            local jitter = randomInt(self, rt, 0x7700 + t, 0, 10000) + bias
            local spread = (sourceCount - 1) * 0x960
            fan(0x0c, 0, self.ldX + p[1], self.ldY + p[2],
                baseAim + jitter, sourceSpeed, sourceCount, spread, bob)
            if difficulty(rt) > 2 then
                fan(0x0c, 0, self.ldX + p[1], self.ldY + p[2],
                    baseAim + jitter, sourceSpeed + 1, sourceCount, spread, bob)
            end
        end
    end
    if pendingDeath then enterDeathState() end
end

handlers[0x78] = function(self, rt)
    local parent = parentOf(self, 0x77)
    if not parent or parent.state ~= 1 or dead(parent) then markRemoved(self); return end
    local t = self.helperTimer
    self.ldX = parent.ldX + self._ldOffsetX
    self.ldY = parent.ldY + self._ldOffsetY + sin(parent.helperTimer * pi / 4) * 2
    self.targetable = true
    local pendingDeath = dead(self)
    local start = (self._ldIndex + 1) * 0x29 + 0x46
    if t < start then
        self.angle16 = adaptiveTurn(self.angle16, aim(self), 10)
    end
    if t >= start and self.ldY < 360 then
        local cadence = diff(rt, {164, 123, 82, 82, 82})
        local localTime = (t - start) % cadence
        if localTime < 16 and localTime % 4 == 0 then
            local speed = diff(rt, {5.5, 6.6, 7.2, 7.7, 8.8})
            local ox, oy = Core.polar(self.angle16, 40)
            for _, offset in ipairs({-600, 0, 600}) do
                fire(0x0d, 0, self.ldX + ox, self.ldY + oy,
                    self.angle16 + offset, speed, 10)
            end
            if difficulty(rt) > 2 then
                for _, offset in ipairs({-4000, 4000}) do
                    fire(0x0d, 0, self.ldX + ox, self.ldY + oy,
                        self.angle16 + offset, speed - 1, 10)
                end
            end
        end
    end
    if pendingDeath then markDead(self) end
end

-- Stage 8/9 ---------------------------------------------------------------

handlers[0x95] = function(self, rt)
    local t = self.helperTimer
    self.ldY = self.ldY + scrollDelta(rt)
    if t == 0 then self.speed = 1 end
    if t % 30 > 19 then move(self) end
    if fireArea(self.ldX, self.ldY, -40) then self.targetable = true end

    local cadence = diff(rt, {39, 24, 18, 14, 12})
    local shotX = self.ldX - 25
    local shotY = self.ldY + sin((t - 6) * tau / 30) * -2 - 57
    if t % cadence == 0 and shotY < 360 and fireArea(shotX, shotY) and
       farFromPlayer(shotX, shotY, 50) then
        local a = quantize(aim(self, shotX, shotY), 0x1000)
        local speed = diff(rt, {5.5, 6.5, 7, 7.5, 9})
        fire(9, 0, shotX, shotY, a, speed, 10)
        fire(9, 0, shotX, shotY, a, speed + 0.2, 10)
    end
    if normalDeath(self) then return end
    if self.targetable then outside(self, 100) end
end

handlers[0x96] = function(self, rt)
    local t = self.helperTimer
    self.ldY = self.ldY + scrollDelta(rt)
    if self.state == 0 then
        self.targetable = false
        if t < 20 then return end
        self.state = 1
        self.targetable = true
    end
    local cadence = diff(rt, {18, 11, 8, 9, 7})
    if t % cadence == 0 then
        local shotX = self.ldX - 25
        local shotY = self.ldY - sin(t * tau / 80) - 10
        if shotY < 360 and fireArea(shotX, shotY) and
           farFromPlayer(shotX, shotY, 50) then
            local a = aim(self, shotX, shotY) +
                randomInt(self, rt, 0x9600 + t, -600, 600)
            local speed = diff(rt, {4.5, 5.5, 6, 5.5, 6.6})
            fire(7, 0, shotX, shotY, a, speed, 10)
            if difficulty(rt) > 2 then fire(7, 0, shotX, shotY, a, speed + 1.5, 10) end
        end
    end
    if normalDeath(self) then return end
    outside(self, 100)
end

local function updateStage8Turret(self, rt)
    self.ldY = self.ldY + scrollDelta(rt)
    if self.state == 0 then
        self.targetable = false
        if self.helperTimer < 20 then return end
        if self.spawnType == 0x97 then
            self.speed = 0
        else
            self.angle16 = self.originX > 360 and 0x8000 or 0
            self.speed = self.spawnType == 0x98 and 1.5 or 6
        end
        self.targetAngle16 = aim(self, self.ldX, self.ldY - 31)
        self.secondaryAngle16 = 0
        enterStateNow(self, 1)
    end
    local t = self.helperTimer
    if fireArea(self.ldX, self.ldY) then self.targetable = true end
    move(self)
    local sign = self.originX > 360 and -1 or 1
    self.secondaryAngle16 = Core.angle16(self.secondaryAngle16 -
        floor(self.speed * 522 * sign))
    if self.spawnType == 0x99 then
        if t <= 100 and self.speed > 0 then self.speed = max(0, self.speed - 0.06) end
        if t >= 100 then self.speed = 0 end
    end

    local period = diff(rt, {90, 60, 44, 60, 44})
    local step = diff(rt, {30, 18, 12, 12, 10})
    local localTime = t >= 30 and (t - 30) % period or period
    local liveAim = aim(self, self.ldX, self.ldY - 31)
    if not (localTime <= step * 2 and self.ldY < 360) then
        self.targetAngle16 = adaptiveTurn(self.targetAngle16, liveAim, 10)
    end
    if t >= 30 and localTime < step * 3 and localTime % step == 0 then
        local ox, oy = Core.polar(self.secondaryAngle16, 38)
        local x, y = self.ldX + ox, self.ldY - 30 + oy
        if y < 360 and fireArea(x, y) and farFromPlayer(x, y, 50) then
            local speed = diff(rt, {5.5, 6.4, 7, 7, 8})
            if difficulty(rt) > 2 then
                fire(7, 0, x, y, self.targetAngle16 - 2000, speed - 0.5, 10)
                fire(7, 0, x, y, self.targetAngle16 + 2000, speed - 0.5, 10)
            end
            fire(7, 0, x, y, self.targetAngle16, speed, 10)
        end
    end
    if normalDeath(self) then return end
    if self.targetable and self.ldY >= 820 then markRemoved(self) end
end

handlers[0x97] = updateStage8Turret
handlers[0x98] = updateStage8Turret
handlers[0x99] = updateStage8Turret

handlers[0x9a] = function(self, rt)
    self.ldY = self.ldY + scrollDelta(rt)
    if self.state == 0 then
        self.targetable = false
        if self.ldY < -140 then return end
        enterStateNow(self, 1)
        self.targetable = true
    end
    if self.state == 2 then
        self.targetable = false
        local timer = self.helperTimer
        updateDeathExplosion(self, timer)
        if timer >= 60 then markDead(self) end
        return
    end
    local t = self.helperTimer
    if t < 400 then
        local localTime = (t - 40) % 200
        local sources = {{self.ldX - 87, self.ldY + 150},
                         {self.ldX + 90, self.ldY + 100}}
        local count = diff(rt, {15, 24, 27, 27, 27})
        local baseSpeed = diff(rt, {5.5, 6.5, 7.5, 6.5, 7.7})
        local decay = diff(rt, {0.12, 0.16, 0.18, 0.18, 0.18})
        for i, source in ipairs(sources) do
            local phase = localTime - (i - 1) * 50
            if phase == 0 then
                if i == 1 then self.angle16 = aim(self, source[1], source[2])
                else self.secondaryAngle16 = aim(self, source[1], source[2]) end
            end
            local saved = i == 1 and self.angle16 or self.secondaryAngle16
            if phase >= 0 and phase < count then
                local speed = baseSpeed - phase * decay
                local spread = floor(30000 / count) * phase
                if phase % 3 == 0 then
                    fan(3, 0, source[1], source[2], saved,
                        speed, 2, spread, 10)
                    if difficulty(rt) > 2 then
                        fan(3, 0, source[1], source[2], saved,
                            speed + 2.4, 2, spread, 10)
                    end
                end
                if phase >= 1 and (phase - 1) % 3 == 0 then
                    fan(5, 0, source[1], source[2], saved,
                        speed - 1.2, 2, spread, 10)
                    if difficulty(rt) > 2 then
                        fan(5, 0, source[1], source[2], saved,
                            speed + 1.2, 2, spread, 10)
                    end
                end
            end
        end
        local centerX, centerY = self.ldX, self.ldY + 5
        if localTime == 110 then self.targetAngle16 = aim(self, centerX, centerY) end
        if localTime >= 110 and localTime <= 149 and
           (localTime - 110) % 5 == 0 then
            local speed = diff(rt, {6.5, 7.5, 8.5, 8.5, 11.1})
            for _, offset in ipairs({-900, 0, 900}) do
                fire(10, 0, centerX, centerY, self.targetAngle16 + offset, speed, 10)
            end
            if difficulty(rt) > 2 then
                fire(10, 0, centerX, centerY, self.targetAngle16 - 1650, speed - 0.8, 10)
                fire(10, 0, centerX, centerY, self.targetAngle16 + 1650, speed - 0.8, 10)
            end
        end
    end
    if dead(self) then
        spawnDeathRewardOnce(self, 0x708)
        self.hp = 1
        self.targetable = false
        setState(self, 2)
        return
    end
    if self.ldY >= 1020 then markRemoved(self) end
end

local compositeFamily = {
    [0x9b] = {0x9d, 11.4, 2.4, 7}, [0x9c] = {0x9d, 11.4, 2.4, 7},
    [0x9e] = {0xa0, 12.2, 3.2, 9}, [0x9f] = {0xa0, 12.2, 3.2, 9},
    [0xa1] = {0xa3, 11.8, 2.8, 7}, [0xa2] = {0xa3, 11.8, 2.8, 7},
}

local function updateStage8Composite(self, rt)
    local family = compositeFamily[self.spawnType]
    if self.state == 0 then
        if not self._ldPrepared then
            self._ldPrepared = true
            self._ldScheduledX = self.ldX
            self.ldX = self.ldX < 360 and -100 or 820
            self.ldY = -100
        end
        self.targetable = false
        if self.helperTimer < 20 then return end
        local offsets, angles
        if family[1] == 0x9d then
            offsets = {{80, -40}, {-80, -40}, {160, 0}, {-160, 0}}
            angles = {0, 0, 0, 0}
        elseif family[1] == 0xa0 then
            offsets = {{55, -50}, {-55, -50}, {100, 0}, {-100, 0}}
            angles = {200, -200, 500, -500}
        else
            offsets = {{90, -40}, {-90, -40}, {180, 0}, {-180, 0}}
            angles = {-600, 600, -1200, 1200}
        end
        for i, offset in ipairs(offsets) do
            spawnChild(rt, self, family[1], 99999999,
                offset[1], offset[2], i - 1, angles[i], 0)
        end
        self.speed = family[2]
        self.angle16 = aim(self)
        self.targetAngle16 = self.angle16
        self._ldTargetX, self._ldTargetY = Core.clampToPlayfield(
            self.ldX, self.ldY, 50)
        self.targetable = true
        enterStateNow(self, 1)
    end
    local t = self.helperTimer
    if t < 280 then
        if t >= 60 and (t - 60) % 50 == 0 then
            self._ldTargetX = randomRange(self, rt, 0x9800 + t, 120, 600)
            self._ldTargetY = t + randomRange(self, rt, 0x9801 + t, 0, 100)
        end
        if t <= 60 and self.speed > family[3] then
            self.speed = max(family[3], self.speed - 0.15)
        end
    else
        self._ldTargetY = -500
        self.speed = self.speed + 0.1
    end
    steerTarget(self, 0x280)
    move(self)

    if t >= 60 and t < 280 then
        local period = diff(rt, {90, 75, 60, 60, 50})
        local window = diff(rt, {25, 40, 40, 40, 40})
        local localTime = (t - 60) % period
        if localTime == 0 then
            local y = self.ldY + (family[1] == 0x9d and 12 or
                (family[1] == 0xa3 and 16 or 0))
            self.targetAngle16 = aim(self, self.ldX, y)
        end
        if localTime < window and localTime % 5 == 0 then
            local y = self.ldY + (family[1] == 0x9d and 12 or
                (family[1] == 0xa3 and 16 or 0))
            local speed = diff(rt, {7, 8, 9, 8.5, 9.5}) + localTime * 0.08
            fire(family[4], 0, self.ldX, y, self.targetAngle16, speed, 10)
            if difficulty(rt) > 2 then
                fire(family[4], 0, self.ldX, y, self.targetAngle16, speed + 2, 10)
            end
        end
    end
    if normalDeath(self) then return end
    if t > 240 then outside(self, 128) end
end

handlers[0x9b] = updateStage8Composite
handlers[0x9c] = updateStage8Composite
handlers[0x9e] = updateStage8Composite
handlers[0x9f] = updateStage8Composite
handlers[0xa1] = updateStage8Composite
handlers[0xa2] = updateStage8Composite

local function updateStage8CompositeChild(self, rt)
    local parent = parentOf(self)
    if not parent or not compositeFamily[parent.spawnType] or dead(parent) then
        markRemoved(self)
        return
    end
    self.targetable = false
    local tx, ty = parent.ldX + self._ldOffsetX, parent.ldY + self._ldOffsetY
    if self.helperTimer == 0 then
        self.ldX, self.ldY = parent.ldX, parent.ldY
    else
        self.ldX = self.ldX + (tx - self.ldX) / 8
        self.ldY = self.ldY + (ty - self.ldY) / 8
    end
    local facing
    if self.spawnType == 0x9d then
        facing = aim(self)
    else
        facing = aim(parent) + (self._ldIndex < 2 and
            (self._ldIndex == 0 and 1 or -1) * (self.spawnType == 0xa0 and 200 or -600) or
            (self._ldIndex == 2 and 1 or -1) * (self.spawnType == 0xa0 and 500 or -1200))
    end
    self.angle16 = adaptiveTurn(self.angle16, facing, 10)

    local t = self.helperTimer
    if t >= 60 and t < 280 then
        local period = diff(rt, {90, 75, 60, 60, 50})
        local window = diff(rt, {25, 40, 40, 40, 40})
        local localTime = (t - 60) % period
        if localTime == 0 then self.targetAngle16 = facing end
        if localTime < window and localTime % 4 == 0 then
            local visual = self.spawnType == 0xa0 and 9 or 7
            local x, y = self.ldX, self.ldY
            if self.spawnType ~= 0xa3 then
                local ox, oy = Core.polar(self.angle16,
                    self.spawnType == 0xa0 and 8 or 15)
                x, y = x + ox, y + oy
            end
            local speed = diff(rt, {7, 8, 9, 8, 9.5}) + localTime * 0.08
            fire(visual, 0, x, y, self.targetAngle16, speed, 10)
            if difficulty(rt) > 2 then
                fire(visual, 0, x, y, self.targetAngle16, speed + 2.5, 10)
            end
        end
    end
end

handlers[0x9d] = updateStage8CompositeChild
handlers[0xa0] = updateStage8CompositeChild
handlers[0xa3] = updateStage8CompositeChild

handlers[0xa4] = function(self, rt)
    if self.state == 3 then
        self.targetable = false
        local timer = self.helperTimer
        updateDeathExplosion(self, timer)
        self.ldY = self.ldY + timer * 0.1
        if timer >= 60 then
            rt.gate = false
            markDead(self)
        end
        return
    end
    if self.state == 0 then
        self._ldEntryLeft = self.ldX <= 360
        if not activateAfterMarker(self, rt, 50, function(e)
            local specs = {
                {0xa5, 20, -10, -6000}, {0xa5, -20, -10, -26768},
                {0xa6, 10, 0, -3000}, {0xa6, -10, 0, -29768},
            }
            for i, spec in ipairs(specs) do
                local child = spawnChild(rt, e, spec[1], e.hp,
                    spec[2], spec[3], i - 1, spec[4], 0)
                if child then child.maxhp = e.maxhp; child.targetable = true end
            end
            e.originX, e.originY = 360, e.ldY
            e.speed = 0
        end) then return end
    end
    local life = self.age
    local amplitude = life < 198 and 650 - sin(life * pi / 198) * 550 or 100
    if self._ldEntryLeft then amplitude = -amplitude end
    local retreatStart = (rt.stage or 8) == 9 and 1200 or 2000
    if life > retreatStart then
        self.speed = self.speed + 0.1
        self.originY = self.originY - self.speed
    end
    local phase = (life + 99) * tau / 396
    self.ldX = self.originX + sin(phase) * amplitude
    self.ldY = self.originY + sin(phase * 1.5) * 50

    if self.state == 1 and self.hp <= self.maxhp * 0.4 then
        setState(self, 2)
    end
    local t = self.helperTimer
    if self.state == 2 and t >= 160 then
        local period = diff(rt, {180, 140, 130, 120, 120})
        if (t - 160) % period == 0 then
            local count = diff(rt, {11, 15, 17, 17, 19})
            local speed = diff(rt, {4.5, 5.5, 6, 5, 6})
            local a = aim(self, self.ldX, self.ldY - 40 + sin((t - 32) * tau / 88) * 2)
            local outerCount = max(1, count - 1)
            local outerSpread = floor(0x8000 / outerCount) * max(0, count - 2)
            fan(5, 0, self.ldX, self.ldY, a, speed,
                outerCount, outerSpread)
            fan(3, 0, self.ldX, self.ldY, a, speed + 1.2, count, 0x8000)
            if difficulty(rt) > 2 then
                fan(5, 0, self.ldX, self.ldY, a, speed + 2.4,
                    outerCount, outerSpread)
                fan(3, 0, self.ldX, self.ldY, a, speed + 3.6, count, 0x8000)
            end
        end
    end
    if dead(self) then
        spawnDeathRewardOnce(self, 0x960)
        self.hp = 1
        self.targetable = false
        setState(self, 3)
    end
end

local function updateCarrierChild(self, rt)
    local parent = parentOf(self, 0xa4)
    if not parent then markRemoved(self); return end
    local t = self.helperTimer
    local phase = t * tau / 144
    local side = self._ldOffsetX < 0 and -1 or 1
    local orbit = self.angle16 + side * sin(phase) * 1200
    local tip = orbit + side * (sin(phase - pi * 0.5) * 1200 + 7000)
    local ox, oy = Core.polar(orbit, self.spawnType == 0xa5 and 150 or 90)
    self.ldX = parent.ldX + self._ldOffsetX + ox
    self.ldY = parent.ldY + self._ldOffsetY + oy
    self.targetAngle16 = Core.angle16(tip)

    if self.hp < parent.hp then parent.hp = self.hp else self.hp = parent.hp end
    if self.spawnType == 0xa6 and
       parent.hp <= floor((parent.maxhp or parent.hp) * 0.4) then
        spawnDeathRewardOnce(self, 0x960, 30)
        markRemoved(self)
        return
    end
    self.targetable = parent.state == 1 or parent.state == 2
    local retreatStart = (rt.stage or 8) == 9 and 1200 or 2000
    if parent.state == 1 and parent.age < retreatStart then
        if self.spawnType == 0xa5 then
            local start = diff(rt, {90, 80, 70, 70, 70})
            local step = diff(rt, {60, 40, 30, 30, 30})
            if t >= start then
                local localTime = (t - start) % 240
                if localTime < 120 then
                    local lane = localTime % (step * 2)
                    local speed = diff(rt, {5.4, 6.4, 7, 7, 8}) +
                        (localTime % step) * 0.1
                    if localTime == 0 then self._ldCachedAim = aim(self) end
                    if lane < 30 and lane % 4 == 0 then
                        fan(7, 0, self.ldX, self.ldY,
                            self._ldCachedAim or aim(self), speed, 5, 20000, 10)
                        if difficulty(rt) > 2 then
                            fan(7, 0, self.ldX, self.ldY,
                                self._ldCachedAim or aim(self), speed + 1.5, 5, 20000, 10)
                        end
                    end
                    local alternate = (localTime - step) % (step * 2)
                    if localTime >= step and alternate < 30 and alternate % 4 == 0 then
                        fan(7, 0, self.ldX, self.ldY,
                            self._ldCachedAim or aim(self), speed, 4, 15000, 10)
                    end
                end
            end
        elseif t > 120 then
            local cadence = diff(rt, {18, 13, 11, 11, 11})
            if (t - 120) % cadence == 0 then
                local layers = diff(rt, {2, 4, 5, 3, 4})
                local count = diff(rt, {1, 1, 1, 2, 2})
                local baseSpeed = diff(rt, {4, 4, 4, 5, 6})
                for layer = 0, layers - 1 do
                    local offset = layer * 800 - 0x4038
                    local speed = baseSpeed + layer
                    fan(0x0c, 0, self.ldX, self.ldY,
                        self.targetAngle16 + side * offset, speed, count, 9000, 10)
                    fan(0x0c, 0, self.ldX, self.ldY,
                        self.targetAngle16 - side * offset, speed, count, 9000, 10)
                end
            end
        end
    elseif parent.state == 2 and self.spawnType == 0xa5 and parent.helperTimer > 60 then
        local period = diff(rt, {180, 140, 130, 120, 120})
        local localTime = (parent.helperTimer - 60) % period
        if localTime == 0 then self._ldCachedAim = aim(self) end
        local speed = diff(rt, {7, 8, 9, 10, 11}) - localTime * 0.03
        if localTime < 64 and localTime % 3 == 0 then
            local spread = floor(diff(rt, {1600, 2400, 2700, 3000, 3000}) / 75) * localTime
            for _, offset in ipairs({0, 10000, -10000}) do
                fan(9, 0, self.ldX, self.ldY,
                    (self._ldCachedAim or aim(self)) + offset,
                    speed, 2, spread, 10)
            end
        end
    end
end

handlers[0xa5] = updateCarrierChild
handlers[0xa6] = updateCarrierChild

handlers[0xad] = function(self, rt)
    if self.state == 0 then
        if not activateAfterMarker(self, rt, 20, function(e)
            e.angle16 = 0x3a24 + randomInt(e, rt, 0xad01, 0, 3000)
            e.speed = 6
        end) then return end
    end
    local t = self.helperTimer
    if t < 200 then self.angle16 = Core.turn16(self.angle16, aim(self), 0xff) end
    self.speed = self.speed + 0.1
    move(self)
    if t < 200 then
        local interval = diff(rt, {18, 10, 6, 8, 6})
        local localTime = (t - 5) % (interval * 5)
        if localTime < interval * 3 and localTime % interval == 0 and
           fireArea(self.ldX, self.ldY) and farFromPlayer(self.ldX, self.ldY, 90) then
            local a = quantize(aim(self), 0x800)
            local speed = diff(rt, {6.5, 7.2, 8, 8.5, 9.5})
            fire(0, 0, self.ldX, self.ldY, a, speed)
            if difficulty(rt) > 2 then
                fire(0, 0, self.ldX, self.ldY, a - 2000, speed - 1)
                fire(0, 0, self.ldX, self.ldY, a + 2000, speed - 1)
            end
        end
    end
    if normalDeath(self) then return end
    outside(self, 180)
end

-- Stage 10 -----------------------------------------------------------------

local function emitStage10(self, rt)
    local t = self.helperTimer
    if self.spawnType == 0xfa then
        if t >= 200 or (rt.frame or 0) % 10 ~= 0 then return end
        local ox, oy = Core.polar(self.angle16, 45)
        local x, y = self.ldX + ox, self.ldY + oy
        if fireArea(x, y, -20) and y < 520 and farFromPlayer(x, y, 90) then
            fire(9, 0, x, y, quantize(self.secondaryAngle16, 0x800), 7.7)
        end
    elseif self.spawnType == 0xfb then
        if t >= 200 or t % 18 ~= 0 or self.ldY >= 420 or
           not fireArea(self.ldX, self.ldY, -20) then return end
        local ox, oy = Core.polar(self.angle16, 45)
        local x, y = self.ldX + ox, self.ldY + oy
        if farFromPlayer(x, y, 90) then fire(8, 0, x, y, self.angle16, 7.7) end
    elseif self.spawnType == 0xfc then
        if t < 40 or t >= 180 then return end
        local localTime = (t - 40) % 50
        if localTime >= 20 or localTime % 5 ~= 0 then return end
        local y = self.ldY + sin(t * pi / 25) - 20
        if localTime == 0 then self.secondaryAngle16 = aim(self, self.ldX, y) end
        if not fireArea(self.ldX, y) then return end
        local speed = 8.8 + localTime * 0.1
        fire(0x0c, 0, self.ldX, y, self.secondaryAngle16, speed)
        fire(4, 0, self.ldX + 25, y - 30, self.secondaryAngle16, speed)
        fire(4, 0, self.ldX - 25, y - 30, self.secondaryAngle16, speed)
    elseif self.spawnType == 0xfd then
        if t < 10 or t >= 90 then return end
        local localTime = (t - 10) % 60
        if localTime >= 24 or localTime % 4 ~= 0 then return end
        local y = self.ldY + 40
        if localTime == 0 then self.secondaryAngle16 = aim(self, self.ldX, y) end
        local count = floor(localTime / 4) + 1
        fan(0x0d, 0, self.ldX, y, self.secondaryAngle16,
            9, count, (count - 1) * 400, 10)
    elseif self.spawnType == 0xff then
        local parent = self.parent or self._ldParent
        if not parent or parent.helperTimer >= 240 or t < 75 then return end
        local localTime = (t - 75) % 60
        if localTime >= 40 or localTime % 5 ~= 0 then return end
        if localTime == 0 then self.secondaryAngle16 = aim(parent) end
        fire(7, 0, self.ldX, self.ldY,
            self.angle16 + self.secondaryAngle16,
            7.5 + localTime * 0.08, 10)
    elseif self.spawnType == 0x100 then
        if t < 70 or t >= 240 then return end
        local localTime = (t - 70) % 60
        if localTime >= 40 or localTime % 5 ~= 0 then return end
        if localTime == 0 then self.secondaryAngle16 = aim(self) end
        local speed = 7.2 + localTime * 0.08
        fire(7, 0, self.ldX + 16, self.ldY + 16,
            self.secondaryAngle16, speed, 10)
        fire(7, 0, self.ldX - 16, self.ldY + 16,
            self.secondaryAngle16, speed, 10)
    elseif self.spawnType == 0x101 then
        local parent = self.parent or self._ldParent
        if not parent or parent.helperTimer >= 240 or t < 70 or
           (t - 70) % 14 ~= 0 then return end
        local a = aim(parent)
        local localTime = (t - 70) % 120
        local center
        if self._ldOffsetX < 0 then
            center = localTime < 60 and -localTime * 400 + 12000 or
                localTime * 400 + 0x7360
        else
            center = localTime < 60 and localTime * 400 - 12000 or
                -localTime * 400 - 0x7360
        end
        center = center + a
        for i = 0, 4 do fire(4, 0, self.ldX, self.ldY, center - 900 + i * 450, 6) end
    elseif self.spawnType == 0x102 then
        if t < 24 or t >= 300 then return end
        local wave = 2 * sin((t - 36) * tau / 70)
        local leftX, leftY = self.ldX - 68, self.ldY + wave - 50
        local rightX, rightY = self.ldX + 65, self.ldY + wave + 27
        local localTime = (t - 24) % 50
        local liveAim = aim(self, leftX, leftY)
        if localTime == 0 then self.secondaryAngle16 = liveAim end
        if localTime < 40 and fireArea(leftX, leftY) then
            local scatterAngle = Core.randomAngle((rt.frame or 0) + t, (self.entityId or 0) * 4)
            local radius = randomInt(self, rt, 0x10201 + t, 0, 10)
            local ox, oy = Core.polar(scatterAngle, radius)
            local jitter = randomInt(self, rt, 0x10202 + t, -800, 800)
            fire(0x0d, 0, leftX + ox, leftY + oy,
                self.secondaryAngle16 + jitter, 6 + localTime * 0.2)
            self.secondaryAngle16 = Core.turn16(self.secondaryAngle16, liveAim, 0x48)
        end
        if t >= 64 and (t - 64) % 100 == 0 then
            local rightAim = aim(self, rightX, rightY)
            for i = 0, 14 do
                local scatterAngle = Core.randomAngle((rt.frame or 0) + t,
                    (self.entityId or 0) * 4444 + i)
                local radius = randomInt(self, rt, 0x10210 + i, 0, 32)
                local ox, oy = Core.polar(scatterAngle, radius)
                local jitter = randomInt(self, rt, 0x10230 + i, -12000, 12000)
                local speed = randomRange(self, rt, 0x10250 + i, 3, 7)
                fire(0, 0, rightX + ox, rightY + oy,
                    rightAim + jitter, speed)
            end
        end
    elseif self.spawnType == 0x103 or self.spawnType == 0x104 then
        if t < 50 or t >= 240 then return end
        local localTime = (t - 50) % 100
        if localTime == 0 then
            self.secondaryAngle16 = aim(self, self.ldX, self.ldY - 64)
        end
        if localTime >= 30 or localTime % 5 ~= 0 then return end
        local sources = {
            {24, -36, -1500}, {-24, -36, 1500},
            {49, -64, -3600}, {-49, -64, 3600},
        }
        for _, source in ipairs(sources) do
            local x, y = self.ldX + source[1], self.ldY + source[2]
            if fireArea(x, y) then
                fire(4, 0x34, x, y,
                    self.secondaryAngle16 + source[3], 7)
            end
        end
    end
end

local function prepareStage10Marker(self)
    if self._ldPrepared then return end
    self._ldPrepared = true
    if self.spawnType == 0xfe or self.spawnType == 0x100 then
        self._ldDestinationX, self._ldDestinationY = self.originX, self.originY
        self.ldX = self.originX < 360 and -100 or 820
        self.ldY = -100
    elseif self.spawnType == 0x103 then
        self.angle16 = 0x64a8
    elseif self.spawnType == 0x104 then
        self.angle16 = 7000
    end
end

local function activateStage10(self, rt)
    prepareStage10Marker(self)
    self.targetable = false
    if self.helperTimer < 20 then
        if dead(self) then markDead(self) end
        return false
    end
    local t = self.spawnType
    if t <= 0xfd then
        local margin = t == 0xfc and 60 or (t == 0xfd and 50 or 20)
        clampEntry(self, margin)
    end
    if t == 0xfa then
        self.speed = 7
        if self.originY > 0 then
            if self.originX <= 0 then self.angle16 = 0 end
            if self.originX >= 720 then self.angle16 = 0x8000 end
        else
            self.angle16 = self.originX < 360 and 0x18f1 or 0x670f
        end
        self.secondaryAngle16 = aim(self)
    elseif t == 0xfb then
        self.speed = 5
        self.angle16 = 0x3a24 + randomInt(self, rt, 0xfb01, 0, 3000)
    elseif t == 0xfc then
        self.speed, self.angle16 = 2, 0x4000
        self.originX, self.originY = self.ldX, self.ldY
        self._ldSwaySign = randomUnit(self, rt, 0xfc01) < 0.5 and 1 or -1
    elseif t == 0xfd then
        self.speed = 6
        if self.ldX <= 0 then self.angle16 = 0
        elseif self.ldX >= 720 then self.angle16 = 0x8000 end
    elseif t == 0xfe then
        local specs = {{50, -50, 0}, {-50, -50, 0},
                       {100, -20, 0x1130}, {-100, -20, 0xeed0}}
        for i, spec in ipairs(specs) do
            spawnChild(rt, self, 0xff, 99999999,
                spec[1], spec[2], i - 1, spec[3], 0)
        end
        self.speed = 11.5
        self.originX, self.originY = self._ldDestinationX, self._ldDestinationY
        self.angle16 = Core.aim16(self.ldX, self.ldY, self.originX, self.originY)
    elseif t == 0x100 then
        spawnChild(rt, self, 0x101, 99999999, 70, -40, 0, 0, 0)
        spawnChild(rt, self, 0x101, 99999999, -70, -40, 1, 0, 0)
        self.speed = 11.5
        self.originX, self.originY = self._ldDestinationX, self._ldDestinationY
        self.angle16 = Core.aim16(self.ldX, self.ldY, self.originX, self.originY)
    elseif t == 0x102 then
        self.speed = 7
    elseif t == 0x103 or t == 0x104 then
        self.speed = 12
    end
    self.targetable = true
    enterStateNow(self, 1)
    return true
end

local function updateStage10Root(self, rt)
    if self.state == 0 and not activateStage10(self, rt) then return end
    local pendingDeath = dead(self)
    local t = self.helperTimer

    if self.spawnType == 0xfa then
        local aimed = aim(self)
        local turn
        if self.originY > 0 then
            turn = t > 109 and 0x3c or 400
            if (self.originX <= 0 and self.originY >= 250) or
               (self.originX >= 720 and self.originY < 250) then turn = -turn end
        else
            turn = t > 89 and 0x3c or 400
            if self.originX >= 360 then turn = -turn end
        end
        self.angle16 = Core.angle16(self.angle16 + turn)
        move(self)
        self.secondaryAngle16 = adaptiveTurn(self.secondaryAngle16, aimed, 10)
        if not pendingDeath then outside(self, 180) end
    elseif self.spawnType == 0xfb then
        if t < 200 then self.angle16 = Core.turn16(self.angle16, aim(self), 0xff) end
        self.speed = self.speed + 0.05
        move(self)
        if not pendingDeath then outside(self, 180) end
    elseif self.spawnType == 0xfc then
        if t < 180 then
            local dx, dy = Core.polar(self.angle16, self.speed)
            self.originX, self.originY = self.originX + dx, self.originY + dy
            self.ldX = self.originX + sin(t * pi / 120) * 60 * self._ldSwaySign
            self.ldY = self.originY
            self.angle16 = Core.turn16(self.angle16,
                Core.aim16(self.originX, self.originY, playerPosition()), 0x40)
        else
            move(self)
            self.angle16 = Core.turn16(self.angle16, 0xc000, 0xa0)
            self.speed = self.speed + 0.1
        end
        if not pendingDeath then outside(self, 180) end
    elseif self.spawnType == 0xfd then
        if t < 90 then
            if self.speed > 2 then self.speed = max(2, self.speed - 0.05) end
            self.angle16 = Core.turn16(self.angle16, aim(self), 0x30)
        else
            self.angle16 = Core.turn16(self.angle16, 0xc000, 0x200)
            self.speed = self.speed + 0.1
        end
        move(self)
        if not pendingDeath then outside(self, 180) end
    elseif self.spawnType == 0xfe or self.spawnType == 0x100 then
        if t < 240 then
            local first = self.spawnType == 0xfe and 60 or 70
            if t >= first and (t - first) % 50 == 0 then
                self.originX = randomRange(self, rt, self.spawnType * 31 + t, 120, 600)
                self.originY = t + randomRange(self, rt, self.spawnType * 37 + t, 0, 100)
            end
            local minimum = self.spawnType == 0xfe and 3 or 2.5
            if t < 61 and self.speed > minimum then self.speed = max(minimum, self.speed - 0.15) end
        else
            self.speed = self.speed + 0.1
            self.originY = -500
        end
        self.angle16 = Core.turn16(self.angle16,
            Core.aim16(self.ldX, self.ldY, self.originX, self.originY), 0x200)
        move(self)
        if not pendingDeath and t > 239 then outside(self, 128) end
    elseif self.spawnType == 0x102 then
        if t < 121 and self.speed > 1.2 then self.speed = max(1.2, self.speed - 0.1) end
        self.angle16 = Core.turn16(self.angle16, aim(self), 0x80)
        if t > 299 then self.speed = self.speed - 0.1 end
        move(self)
        if not pendingDeath then outside(self, 128) end
    elseif self.spawnType == 0x103 or self.spawnType == 0x104 then
        local aimed = aim(self)
        if t < 100 then
            self.speed = self.speed - 0.12
            self.angle16 = Core.turn16(self.angle16, aimed, 0x20)
        elseif t < 240 then
            if t == 100 then self.angle16 = aimed end
            if t < 130 then self.speed = self.speed + 0.05 end
            self.angle16 = Core.turn16(self.angle16, aimed, 0x80)
        else
            self.speed = self.speed - 0.1
        end
        move(self)
        if not pendingDeath and t > 119 then outside(self, 128) end
    end

    emitStage10(self, rt)
    if pendingDeath then
        self.removeRequested = false
        markDead(self)
    end
end

handlers[0xfa] = updateStage10Root
handlers[0xfb] = updateStage10Root
handlers[0xfc] = updateStage10Root
handlers[0xfd] = updateStage10Root
handlers[0xfe] = updateStage10Root
handlers[0x100] = updateStage10Root
handlers[0x102] = updateStage10Root
handlers[0x103] = updateStage10Root
handlers[0x104] = updateStage10Root

local function updateStage10Child(self, rt)
    local parent = self.parent or self._ldParent
    local expected = self.spawnType == 0xff and 0xfe or 0x100
    if not parent or parent.spawnType ~= expected or parent.removeRequested then
        markRemoved(self)
        return
    end
    local tx, ty = parent.ldX + self._ldOffsetX, parent.ldY + self._ldOffsetY
    if self.helperTimer == 0 then
        self.ldX, self.ldY = parent.ldX, parent.ldY
    else
        self.ldX = self.ldX + (tx - self.ldX) / 8
        self.ldY = self.ldY + (ty - self.ldY) / 8
    end
    self.targetable = false
    emitStage10(self, rt)
    if dead(parent) or parent.deadRequested or parent.active == false then
        markRemoved(self)
    end
end

handlers[0xff] = updateStage10Child
handlers[0x101] = updateStage10Child

local markerOnlyTypes = {
    [0x44] = true, [0x45] = true, [0x46] = true,
    [0x4a] = true,
    [0x57] = true, [0x58] = true, [0x59] = true,
    [0x5b] = true, [0x5c] = true,
    [0x70] = true, [0x71] = true, [0x72] = true,
    [0x73] = true, [0x74] = true, [0x75] = true, [0x76] = true,
}

local hiddenStateZeroTypes = {
    [0x4d] = true,
    [0x5a] = true, [0x5d] = true, [0x5e] = true,
}

function EnemyDispatcher:initialize(entity)
    entity.ldX = entity.ldX or entity.originX or 360
    entity.ldY = entity.ldY or entity.originY or -20
    entity.originX = entity.originX or entity.ldX
    entity.originY = entity.originY or entity.ldY
    entity.age = entity.age or 0
    entity.helperTimer = entity.helperTimer or 0
    entity.state = entity.state or 0
    entity.speed = entity.speed or 0
    entity.angle16 = Core.angle16(entity.angle16 or 0x4000)
    entity.secondaryAngle16 = Core.angle16(
        entity.secondaryAngle16 or entity.angle16)
    entity.targetAngle16 = Core.angle16(
        entity.targetAngle16 or entity.angle16)
    entity.hp = entity.hp or 1
    entity.maxhp = entity.maxhp or entity.hp
    entity.radius = entity.radius or 20
    if entity.targetable == nil then entity.targetable = false end
end

function EnemyDispatcher:captureVisualState(entity, rt)
    entity._ldDrawState = entity.state
    entity._ldDrawTimer = entity.helperTimer
    entity._ldSourceFrame = max(0, (rt.frame or 0) - 1)
    entity._ldDrawMarker = self.markerTypes[entity.spawnType] and
        entity.state == 0
    entity._ldMarkerTimer = entity.helperTimer
    entity._ldMarkerX = entity._ldMarkerX or entity.originX or entity.ldX
    entity._ldMarkerY = entity._ldMarkerY or entity.originY or entity.ldY
    local hiddenStateZero = self.hiddenTypes[entity.spawnType] and
        entity.state == 0
    entity._ldDrawBody = entity.active ~= false and
        not entity.removeRequested and not entity._ldDrawMarker and
        not hiddenStateZero
end

function EnemyDispatcher:update(entity, rt)
    local handler = self.handlers[entity.spawnType]
    if not handler then return false end

    self:initialize(entity)
    handler(entity, rt)
    self:captureVisualState(entity, rt)
    return true
end

local dispatcher = EnemyDispatcher.new(
    handlers, markerOnlyTypes, hiddenStateZeroTypes)

function M.update(self, rt)
    return dispatcher:update(self, rt)
end

return M
