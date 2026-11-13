-- Stage 5-7 midboss and boss runtime reconstructed from the original game.
-- Coordinates use Like Dreamer's 600x720, y-down logical playfield.

LikeDreamer = LikeDreamer or {}

local Core = assert(LikeDreamer.Core)
local Projectile = assert(LikeDreamer.Projectile)

local M = {}
LikeDreamer.BossMiddle = M

local sin, cos, sqrt = math.sin, math.cos, math.sqrt
local floor, abs = math.floor, math.abs
local min, max = math.min, math.max
local pi, tau = math.pi, math.pi * 2

local handlers = {}

local function exactToLuaLayer(exactLayer)
    if exactLayer <= 0x24 then
        return (rawget(_G,"LAYER_ENEMY") or 0)+
            (exactLayer-0x23)*0.01
    end
    return (rawget(_G,"LAYER_ENEMY_BULLET") or -200)+
        exactLayer-0x50
end

local handled = {
    [0x4f] = true, [0x50] = true, [0x51] = true, [0x52] = true,
    [0x53] = true, [0x54] = true, [0x55] = true, [0x56] = true,
    [0x61] = true, [0x62] = true, [0x63] = true,
    [0x64] = true, [0x65] = true, [0x66] = true, [0x67] = true,
    [0x68] = true, [0x69] = true, [0x6a] = true, [0x6b] = true,
    [0x6c] = true, [0x6d] = true, [0x6e] = true, [0x6f] = true,
    [0x77] = true, [0x78] = true,
    [0x79] = true, [0x7a] = true, [0x7b] = true, [0x7c] = true,
    [0x7d] = true, [0x7e] = true, [0x7f] = true,
    [0x80] = true, [0x81] = true, [0x82] = true, [0x83] = true,
    [0x84] = true, [0x85] = true, [0x86] = true, [0x87] = true,
    [0x88] = true, [0x89] = true, [0x8a] = true, [0x8b] = true,
    [0x8c] = true, [0x8d] = true, [0x8e] = true, [0x8f] = true,
    [0x90] = true, [0x91] = true, [0x92] = true, [0x93] = true,
    [0x94] = true,
    [0x13c] = true, [0x13d] = true, [0x13e] = true,
    [0x143] = true, [0x144] = true, [0x145] = true,
}

-- Original atlas/frame pairs. Frame indices are zero-based, matching the
-- reconstructed C++ tables and converted to LuaSTG's one-based image names.
local visualSpec = {
    [0x4f] = {"l", 22}, [0x50] = {"l", 24},
    [0x51] = {"l", 25}, [0x52] = {"l", 27},
    [0x53] = {"boss", 50}, [0x13c] = {"boss", 40},
    [0x54] = {"boss", 50}, [0x55] = {"s", 57},
    [0x56] = {"boss", 50}, [0x143] = {"boss", 60},
    [0x61] = {"s", 71}, [0x62] = {"s", 71}, [0x63] = {"s", 71},
    [0x13d] = {"boss", 56}, [0x64] = {"l", 40},
    [0x65] = {"m", 101}, [0x66] = {"m", 104},
    [0x67] = {"m", 105}, [0x68] = {"m", 106},
    [0x69] = {"m", 107}, [0x6a] = {"m", 108},
    [0x6b] = {"s", 72, true}, [0x6c] = {"s", 72, true},
    [0x6d] = {"s", 72, true}, [0x6e] = {"s", 72},
    [0x6f] = {"s", 72}, [0x77] = {"m", 124},
    [0x78] = {"m", 123}, [0x144] = {"m", 127},
    [0x145] = {"m", 131}, [0x79] = {"s", 0, true},
    [0x7a] = {"m", 134}, [0x7b] = {"m", 135},
    [0x7c] = {"s", 100}, [0x7d] = {"s", 100},
    [0x7e] = {"s", 101}, [0x7f] = {"s", 105},
    -- 0x13e is an Enemy_l deck in the exact renderer; Boss[72] is only the
    -- generic late-boss fallback after the dedicated branch.
    [0x13e] = {"l", 49}, [0x80] = {"s", 80},
    [0x81] = {"boss", 88}, [0x82] = {"boss", 98},
    [0x83] = {"boss", 80}, [0x84] = {"boss", 96},
    [0x85] = {"s", 117}, [0x86] = {"s", 117},
    [0x87] = {"m", 138}, [0x88] = {"s", 109},
    [0x89] = {"s", 100}, [0x8a] = {"s", 100},
    [0x8b] = {"s", 101}, [0x8c] = {"s", 105},
    [0x8d] = {"s", 101}, [0x8e] = {"s", 105},
    [0x8f] = {"s", 117}, [0x90] = {"s", 117},
    [0x91] = {"s", 118}, [0x92] = {"s", 118},
    [0x93] = {"s", 117}, [0x94] = {"s", 118},
}

local radiusByType = {
    [0x4f] = 160, [0x50] = 100, [0x51] = 40, [0x52] = 40,
    [0x53] = 40, [0x13c] = 175, [0x54] = 40, [0x55] = 25,
    [0x56] = 40, [0x143] = 80, [0x61] = 20, [0x62] = 20,
    [0x63] = 20, [0x13d] = 175, [0x64] = 40, [0x65] = 40,
    [0x66] = 60, [0x67] = 60, [0x68] = 60, [0x69] = 60,
    [0x6a] = 60, [0x6b] = 40, [0x6c] = 50, [0x6d] = 50,
    [0x6e] = 40, [0x6f] = 40, [0x77] = 60, [0x78] = 40,
    [0x144] = 50, [0x145] = 50, [0x79] = 70, [0x7a] = 45,
    [0x7b] = 45, [0x7c] = 40, [0x7d] = 40, [0x7e] = 20,
    [0x7f] = 20, [0x13e] = 210, [0x80] = 30, [0x81] = 80,
    [0x82] = 80, [0x83] = 70, [0x84] = 70, [0x85] = 50,
    [0x86] = 50, [0x87] = 60, [0x88] = 24, [0x89] = 20,
    [0x8a] = 20, [0x8b] = 20, [0x8c] = 20, [0x8d] = 20,
    [0x8e] = 20, [0x8f] = 20, [0x90] = 20, [0x91] = 20,
    [0x92] = 20, [0x93] = 20, [0x94] = 20,
}

local function difficulty(rt)
    return Core.clamp(rt.difficulty or 1, 0, 4)
end

local function diff(rt, values)
    return values[difficulty(rt) + 1]
end

local function playerPosition()
    return Core.playerLD()
end

local function aim(x, y)
    local px, py = playerPosition()
    return Core.aim16(x, y, px, py)
end

local function fire(visual, projectileId, x, y, angle, speed, travel, radius, arg)
    return Projectile.spawn(visual, projectileId, x, y, angle,
        travel or 0, speed or 0, radius or 1, arg or 0)
end

local function fan(visual, projectileId, x, y, angle, speed, count, spread,
                   travel, radius, arg)
    return Projectile.spread(visual, projectileId, x, y, angle,
        travel or 0, speed or 0, radius or 1, count or 1, spread or 0,
        arg or 0)
end

local function moveAngle(self, angle, speed)
    local dx, dy = Core.polar(angle, speed)
    self.ldX, self.ldY = self.ldX + dx, self.ldY + dy
end

local function steerAndMove(self, tx, ty, speed, step)
    self._bmMoveAngle = Core.turn16(self._bmMoveAngle or 0x4000,
        Core.aim16(self.ldX, self.ldY, tx, ty), step or 0x200)
    moveAngle(self, self._bmMoveAngle, speed)
end

local function randomTarget(self, rt, x0, width, y0, height, salt)
    if rt.frame % 50 == 0 or not self._bmTargetX then
        self._bmTargetX = x0 + Core.frameRand(rt.frame + (salt or 0)) % (width + 1)
        self._bmTargetY = y0 + Core.frameRand(rt.frame + (salt or 0) +
            (rt.stage or 0) * 0xde) % (height + 1)
    end
    return self._bmTargetX, self._bmTargetY
end

local function setState(self, state, timer)
    self.state = state
    self.helperTimer = (timer or 0) - 1
end

local function setAppearance(self)
    if self._bmAppearance then return end
    self._bmAppearance = true
    local spec = visualSpec[self.spawnType] or {"boss", 0}
    self.sheet = spec[1]
    self.visualFrame = spec[2]
    if spec[3] then self._bmHidden = true end
    self.radius = radiusByType[self.spawnType] or self.radius
    local visual = LikeDreamer.BossMiddleVisual
    local exactLayer = visual and visual.primaryLayer and
        visual.primaryLayer(self)
    if exactLayer then
        self.layer = exactToLuaLayer(exactLayer)
    else
        self.layer = (LAYER_ENEMY or 0) + 1
    end
    self._bmDrawAngle = 0
end

local function refreshVisual(self, rt)
    local typeId = self.spawnType
    local t = max(0, self.helperTimer or 0)
    if typeId == 0x51 then
        self.visualFrame = (self._bmOffsetX or 0) < 0 and 26 or 25
    elseif typeId == 0x52 then
        self.visualFrame = (self._bmOffsetX or 0) < 0 and 28 or 27
    elseif typeId == 0x53 then
        local start = Core.clamp(self._bmIndex or 1, 1, 4) * 20
        if self._bmShared and t >= start + 40 then
            self.visualFrame = 55 + floor((t - start - 40) / 5) % 3
        elseif self._bmShared and t >= start + 30 then
            self.visualFrame = 53 + floor((t - start - 30) / 5) % 2
        else
            self.visualFrame = 50 + floor(t / 7) % 3
        end
    elseif typeId == 0x13c then
        self.sheet = "boss"
        if self.state == 8 then
            if t < 210 then self.visualFrame = 40 + floor(t / 7) % 4
            elseif t < 220 then self.visualFrame = 43 + floor((t - 210) / 5) % 2
            else self.visualFrame = 45 + floor((t - 220) / 5) % 4 end
        elseif self.state == 9 or (self.state >= 11 and self.state <= 13) then
            self.visualFrame = 45 + floor(t / 5) % 4
        elseif self.state == 10 or self.state == 14 then
            self.visualFrame = 48 + floor(t / 5) % 2
        else
            self.visualFrame = 40 + floor(t / 7) % 4
        end
    elseif typeId == 0x54 or typeId == 0x56 then
        self.visualFrame = 50 + floor(t / 7) % 3
    elseif typeId == 0x143 then
        if self.state == 0 then
            self.visualFrame = t < 110 and 60 + floor(t / 5) % 3
                or 63 + floor((t - 110) / 5) % 3
        elseif self.state >= 1 and self.state <= 4 then
            self.visualFrame = 65 + floor(t / 7) % 3
        else
            self.visualFrame = 68 + floor(t / 5) % 2
        end
    elseif typeId == 0x13d then
        if self.state < 4 or (self.state == 4 and t < 130) then
            self.sheet = "l"
            self.visualFrame = 37
        else
            self.sheet = "boss"
            if self.state == 10 then
                self.visualFrame = 78 + floor(t / 5) % 2
            elseif self.state % 2 == 1 then
                self.visualFrame = t < 10 and 73 + floor(t / 5) % 2
                    or 75 + floor((t - 10) / 5) % 3
            else
                self.visualFrame = 70 + floor(t / 5) % 3
            end
        end
    elseif typeId == 0x6e or typeId == 0x6f then
        self.visualFrame = 72 + floor((rt.frame or 0) / 4) % 6
    elseif typeId == 0x144 or typeId == 0x145 then
        local base = typeId == 0x144 and 127 or 131
        self.visualFrame = base
        if self.state == 2 then self.visualFrame = base + 2
        elseif self.state == 3 then self.visualFrame = base + min(2, floor(t / 3))
        elseif self.state == 1 and t % 184 < 20 then
            self.visualFrame = base + min(2, floor((t % 20) / 5))
        end
    elseif typeId == 0x7a then
        self.visualFrame = self._bmBroken and 136 or 134
    elseif typeId == 0x7b then
        self.visualFrame = self._bmBroken and 137 or 135
    elseif typeId == 0x7e then
        self.visualFrame = ({101, 102, 103, 102})[floor((rt.frame or 0) / 3) % 4 + 1]
    elseif typeId == 0x7f then
        self.visualFrame = ({105, 106, 107, 106})[floor((rt.frame or 0) / 3) % 4 + 1]
    elseif typeId == 0x83 then
        local frames = {80,81,82,83,84,85,87,86,87,86,85,84,83,82,80,81}
        self.visualFrame = frames[floor((rt.frame or 0) / 5) % 16 + 1]
        if self._bmRoot and self._bmRoot.state == 10 and self._bmRoot.helperTimer < 210 then
            self.visualFrame = 88 + floor(self._bmRoot.helperTimer / 5) % 2
        end
    elseif typeId == 0x84 then
        local frames = {96,95,94,93,92,90,91,90,91,92,93,94,95,97,96,97}
        self.visualFrame = frames[floor((rt.frame or 0) / 5) % 16 + 1]
        if self._bmRoot and self._bmRoot.state == 10 and self._bmRoot.helperTimer < 210 then
            self.visualFrame = 98 + floor(self._bmRoot.helperTimer / 5) % 2
        end
    elseif typeId >= 0x8b and typeId <= 0x8e then
        local base = (typeId == 0x8c or typeId == 0x8e) and 105 or 101
        self.visualFrame = base + ({0,1,2,1})[floor((rt.frame or 0) / 3) % 4 + 1]
    end
end

local function remove(self)
    self.targetable = false
    self.protect = true
    self.removeRequested = true
end

local function rootOf(self, expected)
    local root = self._bmRoot or self.parent
    while root and root.parent and root.spawnType ~= expected do root = root.parent end
    if not root or root.active == false or root.removeRequested then return nil end
    if expected and root.spawnType ~= expected then return nil end
    return root
end

local function child(rt, parent, typeId, hp, ox, oy, index, angle, speed,
                     radius, absolute)
    if not rt.spawnChild then return nil end
    local x, y = ox, oy
    if not absolute then x, y = parent.ldX + ox, parent.ldY + oy end
    local e = rt:spawnChild(parent, typeId, hp, x, y,
        string.format("Like Dreamer exact middle boss node 0x%x", typeId))
    if not e then return nil end
    e._bmRoot = parent._bmRoot or parent
    e._bmOffsetX, e._bmOffsetY = ox, oy
    e._bmIndex = index or 0
    e.angle16 = Core.angle16(angle or 0x4000)
    e.secondaryAngle16 = e.angle16
    e.targetAngle16 = e.angle16
    e.speed = speed or 0
    e.radius = radius or radiusByType[typeId] or e.radius
    e.hp, e.maxhp = hp, hp
    e.targetable = false
    setAppearance(e)
    return e
end

local function children(rt, root, typeId)
    local result = {}
    for _, e in pairs(rt.enemiesById or {}) do
        if e.active ~= false and (e._bmRoot == root or e.parent == root) and
           (not typeId or e.spawnType == typeId) then
            result[#result + 1] = e
        end
    end
    return result
end

local function findChild(rt, root, typeId, index)
    for _, e in pairs(rt.enemiesById or {}) do
        if e.active ~= false and (e._bmRoot == root or e.parent == root) and
           e.spawnType == typeId and (index == nil or e._bmIndex == index) then
            return e
        end
    end
end

local function queueDamage(root, amount)
    root._bmDamageQueue = root._bmDamageQueue or {}
    root._bmDamageQueue[#root._bmDamageQueue + 1] = {
        remaining = amount,
        chunk = max(1, floor(amount / 30)),
    }
end

local function applyQueuedDamage(root)
    local queue = root._bmDamageQueue
    if not queue then return end
    for i = #queue, 1, -1 do
        local q = queue[i]
        local damage = min(q.remaining, q.chunk)
        q.remaining = q.remaining - damage
        root.hp = root.hp - damage
        if q.remaining <= 0 then table.remove(queue, i) end
    end
end

local function clearPhase(rt, invulnerability)
    Projectile.clear()
    local p = rawget(_G, "player")
    if p then
        p.invulnerableFrames = max(p.invulnerableFrames or 0,
            invulnerability or 100)
    end
end

local function spawnPlayerCancel(source)
    local p = rawget(_G, "player")
    local playerClass = LikeDreamer.PlayerClass
    if p and playerClass and p.class == playerClass and
            type(playerClass._spawnSpecial) == "function" then
        playerClass._spawnSpecial(p, 0x18,
            source.ldX, source.ldY, 0, 0, 0, 0)
    end
end

local function spawnPostDeathCounter(enemy, lifetime)
    local reward = LikeDreamer.Reward
    if reward and reward.spawnPostDeathCounter then
        return reward.spawnPostDeathCounter(enemy, lifetime)
    end
end

local function spawnEnemyDeathRewardBurstOnce(enemy, payoutWindow, rewardWeight)
    if enemy._bmDeathRewardBurst or enemy._ldRewardSpawned then return false end
    local reward = LikeDreamer.Reward
    if not reward or not reward.spawnEnemyDeathRewardBurst then return false end
    enemy._bmDeathRewardBurst = true
    enemy._ldRewardSpawned = true
    enemy.rewardWeight = rewardWeight
    reward.spawnEnemyDeathRewardBurst(enemy, payoutWindow)
    return true
end

local function openPhase(self, state, hp, countdown, phaseIndex)
    self.state = state
    self.helperTimer = -1
    self.hp, self.maxhp = hp, hp
    self.countdown = countdown
    self.phaseIndex = phaseIndex or self.phaseIndex or 0
    self.targetable = true
    self.protect = false
    self._bmCombat = true
    self.portPhase = (self.portPhase or 0)+1
end

local function bossStatus(self, rt)
    rt.boss = self
    rt.bossState = self.state
    rt.bossTimer = self.helperTimer
    rt.bossCountdown = self.countdown or 0
end

local function finishStage(self, rt)
    rt.gate = false
    rt.complete = true
    remove(self)
end

local function combatTick(self, rt, rewardOwnsCounter)
    if not self._bmCombat then return false end
    self.countdown = (self.countdown or 1) - 1
    if self.hp > 0 and self.countdown > 0 then return false end
    local timedOut = self.countdown <= 0
    if timedOut then clearPhase(rt, 100) else spawnPlayerCancel(self) end
    if not rewardOwnsCounter then spawnPostDeathCounter(self, 140) end
    self._bmCombat = false
    self.targetable = false
    self.protect = true
    self.hp = 1
    return true
end

-- Stage 5 midboss ---------------------------------------------------------

local function stage05MidbossFire(self, rt)
    local t = self.helperTimer
    local cadence = diff(rt, {2, 1, 1, 1, 1})
    local count = difficulty(rt) < 2 and 1 or 2
    local step = diff(rt, {0x578, 0x9c4, 0x898, 0x898, 0x898})
    local speed = diff(rt, {4.5, 5.5, 6, 6, 8})
    if t >= 20 and t < 120 and (t - 20) % cadence == 0 then
        local a = Core.angle16((t - 20) * step - 0x4000)
        local ox, oy = Core.polar(a, (t - 20) * 1.5)
        fan(10, 2, self.ldX + ox, self.ldY + oy, a, speed, count,
            count * 7000 - 7000, 10)
        if difficulty(rt) > 2 then
            fan(10, 2, self.ldX + ox, self.ldY + oy, a, speed + 1.5,
                count, count * 12000 - 12000, 10)
        end
    elseif t >= 120 and t < 220 and (t - 120) % cadence == 0 then
        local a = Core.angle16((100 - t) * step + 0x4000)
        local ox, oy = Core.polar(a, (t - 120) * 1.5)
        fan(11, 2, self.ldX + ox, self.ldY + oy, a, speed, count,
            count * 7000 - 7000, 10)
        if difficulty(rt) > 2 then
            fan(11, 2, self.ldX + ox, self.ldY + oy, a, speed + 1,
                count, count * 12000 - 12000, 10)
        end
    end
    local late = diff(rt, {95, 54, 45, 45, 35})
    if t >= 480 and (t - 480) % late == 0 then
        local a = aim(self.ldX, -1200)
        fire(3, 0x1c, self.ldX + 65, self.ldY + 40, a - 0x4000, 12)
        fire(3, 0x1c, self.ldX + 65, self.ldY + 40, a - 0xc000, 12)
    end
end

handlers[0x4f] = function(self, rt)
    if not self._bmInit then
        self._bmInit = true
        self.state = 0
        self.targetable = false
        self.protect = true
        self._bmEntryY = self.originY
        self.countdown = 1800
    end
    local t = self.helperTimer
    if self.state == 0 then
        if t == 0 then child(rt, self, 0x50, 99999999, 0, 210, 0) end
        local q = min(100, max(0, t))
        self.ldY = 580 + sin(q * pi / 200) * (self._bmEntryY - 580)
        if t >= 100 then
            self.ldY = self._bmEntryY
            openPhase(self, 1, self.hp > 0 and self.hp or 60000, 1800, 0)
        end
        return
    end
    if self.state == 1 then
        local rewardOwnsCounter = self.hp <= 0 and
            spawnEnemyDeathRewardBurstOnce(self, 0x708, 120)
        if combatTick(self, rt, rewardOwnsCounter) then setState(self, 2); return end
        local offsets = {
            [220] = {220, -40}, [230] = {-220, -40},
            [240] = {120, -120}, [250] = {-120, -120},
        }
        local p = offsets[t]
        if p then child(rt, self, 0x53, 99999999, p[1], p[2],
            floor((t - 210) / 10)) end
        if t < 1200 then
            local tx, ty = randomTarget(self, rt, 210, 300, 150, 100, 0x15b3)
            steerAndMove(self, tx, ty, 0.4, 0x200)
        else
            self.ldY = self.ldY - (t - 1200) * 0.1
        end
        stage05MidbossFire(self, rt)
        return
    end
    self.hp = 1
    self.targetable = false
    self.protect = true
    self.ldY = self.ldY + t * 0.15
    if t >= 60 then rt.gate = false; remove(self) end
end

handlers[0x50] = function(self, rt)
    local parent = rootOf(self, 0x4f)
    if not parent then remove(self); return end
    if not self._bmBuilt then
        self._bmBuilt = true
        child(rt, self, 0x51, 99999999, 60, 120, 0)
        child(rt, self, 0x51, 99999999, -60, 120, 1)
        child(rt, self, 0x52, 99999999, 70, -50, 2)
        child(rt, self, 0x52, 99999999, -70, -50, 3)
    end
    local scale = sin(min(100, self.helperTimer) * pi / 200)
    local tx, ty = parent.ldX, parent.ldY + self._bmOffsetY * scale
    self.ldX = self.ldX + (tx - self.ldX) / 5
    self.ldY = self.ldY + (ty - self.ldY) / 5
    self.targetable = false
    if parent.state == 2 and parent.helperTimer >= 60 then remove(self) end
end

local function stage05Decoration(self)
    local parent = self.parent
    if not parent or parent.active == false or parent.spawnType ~= 0x50 then
        remove(self); return
    end
    local scale = sin(min(100, self.helperTimer) * pi / 200)
    local tx = parent.ldX + self._bmOffsetX * scale
    local ty = parent.ldY + self._bmOffsetY * scale
    self.ldX = self.ldX + (tx - self.ldX) / 5
    self.ldY = self.ldY + (ty - self.ldY) / 5
    self.targetable = false
end
handlers[0x51] = stage05Decoration
handlers[0x52] = stage05Decoration

handlers[0x53] = function(self, rt)
    local parent = rootOf(self, 0x4f)
    if not parent or parent.state ~= 1 then remove(self); return end
    local tx, ty = parent.ldX + self._bmOffsetX, parent.ldY + self._bmOffsetY
    self.ldX = self.ldX + (tx - self.ldX) / 30
    self.ldY = self.ldY + (ty - self.ldY) / 30
    if self.helperTimer < 30 then self.targetable = false; return end
    if not self._bmShared then
        self._bmShared = true
        self.hp, self.maxhp = parent.hp, parent.maxhp
    end
    local shared = min(parent.hp, self.hp)
    parent.hp, self.hp = shared, shared
    self.targetable = true
    local sequence = Core.clamp(self._bmIndex or 1, 1, 4)
    local start = sequence * 20
    local period = diff(rt, {320, 270, 240, 240, 240})
    if self.helperTimer >= start + 40 and
       (self.helperTimer - start - 40) % period == 0 then
        local speed = diff(rt, {5, 6, 7, 8, 9})
        fire(17, 0x0c, self.ldX, self.ldY + 10, 0x4000, speed)
        if difficulty(rt) > 2 then
            fire(17, 0x0c, self.ldX, self.ldY + 10, 0x0b44, speed)
            fire(17, 0x0c, self.ldX, self.ldY + 10, 0x74bc, speed)
        end
    end
end

-- Stage 5 final boss ------------------------------------------------------

local function stage05BossFire(self, rt)
    local state, t, d = self.state, self.helperTimer, difficulty(rt)
    if state == 1 then
        local sources = {{-95,80},{90,35},{-2,-110}}
        local cycle = (t - 30) % 690
        for i, p in ipairs(sources) do
            local ringStart = (i - 1) * 40
            if cycle >= ringStart and cycle < ringStart + 36 and
               (cycle - ringStart) % 4 == 0 then
                if i == 1 and cycle == 0 then self.secondaryAngle16 = aim(self.ldX+p[1],self.ldY+p[2]) end
                local count = ({7,11,17,15,17})[d+1]
                local speed = ({5.7,7,7.5,8,9.5})[d+1] +
                    (cycle-ringStart)*0.03+(i-1)*0.8
                fan(3,0,self.ldX+p[1],self.ldY+p[2],self.secondaryAngle16,
                    speed,count,0x10000,10)
                local turn = ({330,370,400,400,560})[d+1] + (i-1)*30
                if i == 2 then turn=-turn end
                self.secondaryAngle16=Core.angle16(self.secondaryAngle16+turn)
            end
            local fanStart=i*160
            local interval=({21,14,12,11,10})[d+1]
            if cycle>=fanStart and cycle<fanStart+180 and
               (cycle-fanStart)%interval==0 then
                local x,y=self.ldX+p[1],self.ldY+p[2]
                local cache=i%2==1 and "secondaryAngle16" or "targetAngle16"
                if cycle==fanStart then self[cache]=aim(x,y) end
                local count=({3,5,7,5,7})[d+1]
                fan(0x0d,0,x,y,self[cache],({6,7.4,8.5,8.5,10})[d+1]+i-1,
                    count,max(0,27000-(cycle-fanStart)*0x91))
            end
        end
    elseif state == 3 then
        local sources={{60,90},{-67,-60},{153,5},{-153,0}}
        if t>=240 then
            local cycle=(t-240)%510
            for i=1,2 do
                local start=(i-1)*210
                local interval=({41,27,19,15,12})[d+1]
                if cycle>=start and cycle<start+210 and (cycle-start)%interval==0 then
                    local x,y=self.ldX+sources[i][1],self.ldY+sources[i][2]
                    local cache=i==1 and "secondaryAngle16" or "targetAngle16"
                    if cycle==start then self[cache]=aim(x,y) end
                    local n=(cycle-start)/interval+1
                    fan(3,0,x,y,self[cache],({4.4,5.7,6.2,7,9})[d+1],n,
                        (n-1)*({6000,4000,3300,3000,2700})[d+1],10)
                    self[cache]=Core.turn16(self[cache],aim(x,y),0x1bc)
                end
            end
        end
        local cycle=(t-10)%240
        for i=3,4 do
            local offset=(i-2)*60
            if cycle==offset-20 then
                local axis=i==3 and 0 or 0x8000
                local x,y=self.ldX+sources[i][1],self.ldY+sources[i][2]
                fire(0x11,0x0c,x,y,axis,({5,6,7,8,9})[d+1])
                if d>2 then
                    fire(0x11,0x0c,x,y,axis-0xd05,({5,6,7,8,9})[d+1])
                    fire(0x11,0x0c,x,y,axis+0xd05,({5,6,7,8,9})[d+1])
                end
            end
        end
    elseif state == 5 then
        local sources={{90,30},{-95,30},{-2,100},{-2,-55}}
        local interval=({22,16,12,13,11})[d+1]
        for i=1,2 do
            if t>=30 and (t-30)%interval==0 then
                local count=({5,7,8,8,9})[d+1]
                local turn=t*({40,40,50,50,50})[d+1]*(i==1 and 1 or -1)
                fan(0x0d,0,self.ldX+sources[i][1],self.ldY+sources[i][2],
                    0x4000+turn,({5.2,6.5,7.7,7,8.5})[d+1],count,0x10000)
            end
        end
        local pair=({70,45,36,36,36})[d+1]
        if t>=120 and (t-120)%(pair*3)==0 then
            local x,y=self.ldX-2,self.ldY+100
            local count=({3,5,7,7,9})[d+1]
            fan(2,0,x,y,aim(x,y),({4,5.3,6,6,7.5})[d+1],count,count*700-700,10)
        elseif t>=120+pair and (t-120-pair)%(pair*3)==0 then
            local x,y=self.ldX-2,self.ldY-55
            fan(2,0,x,y,aim(x,y),({5,6.3,7,7,8.5})[d+1],
                ({8,12,16,18,20})[d+1],0x8000,10)
        end
    elseif state == 7 then
        local sources={{90,-20},{-95,-20},{156,50},{-156,50},{156,-100},{-156,-100}}
        local cycle=(t-30)%880
        for i=1,2 do
            local x,y=self.ldX+sources[i][1],self.ldY+sources[i][2]
            local interval=({19,15,16,16,16})[d+1]
            local localt=cycle%interval
            if cycle<421 and localt<({8,8,10,10,10})[d+1] and localt%2==0 then
                fan(3,0,x,y,Core.angle16((i==1 and 1 or -1)*(cycle+50)*0xf8),
                    ({4.5,5.5,6,7.2,8.6})[d+1],({2,3,4,6,8})[d+1],0x10000)
            end
            if cycle>=0x244 and cycle<0x32a then
                local ci=({68,51,44,39,33})[d+1]
                local q=(cycle-0x244)%ci
                local cache=i==1 and "secondaryAngle16" or "targetAngle16"
                if q==0 then self[cache]=aim(x,y) end
                if q<({14,20,24,24,24})[d+1] and q%3==0 then
                    fire(7,0,x,y,self[cache],({7.2,8.5,9.5,10,11})[d+1],10)
                end
            end
        end
        local pair=({71,43,31,27,24})[d+1]
        for i=3,6 do
            local start=0x1e0+(i-3)*pair
            if cycle>=start and cycle<0x348 and (cycle-start)%(pair*4)==0 then
                fire(0x11,0x0c,self.ldX+sources[i][1],self.ldY+sources[i][2],
                    Core.angle16(i*0x8000),({5,6,7,8,9})[d+1])
            end
        end
    end
end

handlers[0x13c] = function(self, rt)
    if not self._bmInit then
        self._bmInit=true;self.state=0;self.targetable=false;self.protect=true
        self._bmEntryY=self.originY;self._bmMoveAngle=0x4000;self.phaseIndex=0
    end
    applyQueuedDamage(self)
    local t=self.helperTimer
    if self._bmCombat and combatTick(self,rt) then
        local nextState=({[1]=2,[3]=4,[5]=6,[7]=8,[9]=10,[11]=14,[12]=14,[13]=14})[self.state]
        setState(self,nextState or 14)
        if nextState==14 then self._bmFinalDeath=true end
        bossStatus(self,rt);return
    end
    if self.state==0 then
        self.ldY=2800+sin(min(t,200)*pi/400)*(self._bmEntryY-2800)
        if t==240 then openPhase(self,1,60000,1500,0) end
    elseif self.state==1 or self.state==3 or self.state==5 or self.state==7 then
        local tx,ty=randomTarget(self,rt,210,300,150,100,111)
        steerAndMove(self,tx,ty,0.3,0x200);stage05BossFire(self,rt)
    elseif self.state==2 or self.state==4 or self.state==6 then
        self.hp=1;self.targetable=false;self.protect=true
        if t<90 then self.ldY=self.ldY+t*0.09 else
            local tx,ty=randomTarget(self,rt,210,300,150,100,111)
            steerAndMove(self,tx,ty,0.3,0x200)
        end
        if t==100 then self.ldY=self.ldY-444 end
        if t>=100 and t<180 then self.ldY=self.ldY-(1-sin((t-100)*pi/280)) end
        if t==180 then
            if self.state==2 then openPhase(self,3,55000,1500,1)
            elseif self.state==4 then openPhase(self,5,55000,1500,2)
            else openPhase(self,7,70000,1800,3) end
        end
    elseif self.state==8 then
        self.hp=1;self.targetable=false;self.protect=true
        if t<120 then self.ldY=self.ldY+t*0.02 elseif t>=130 then
            local tx,ty=randomTarget(self,rt,210,300,150,100,111)
            steerAndMove(self,tx,ty,0.3,0x200)
        end
        if t==130 then self.ldY=self.ldY-40 end
        if t==210 then child(rt,self,0x54,99999999,0,0,0,0x4000,1,40) end
        if t==380 then openPhase(self,9,45000,1800,4);self.radius=80 end
    elseif self.state==9 then
        local tx,ty=randomTarget(self,rt,210,300,150,100,111)
        steerAndMove(self,tx,ty,0.3,0x200)
        local localt=(t-10)%700
        if t>=10 and localt<360 and localt%diff(rt,{60,40,36,36,30})==0 then
            for _,a in ipairs({0xc4b0,0xc960,0xce10,0xbb50,0xb6a0,0xb1f0}) do
                child(rt,self,0x55,10,0,-20,a,a,6,25)
            end
        end
    elseif self.state==10 then
        self.hp=1;self.targetable=false;self.protect=true;self.ldY=self.ldY+0.1
        if t==180 then openPhase(self,11,80000,2100,5);self.radius=200 end
    elseif self.state==11 then
        local tx,ty=randomTarget(self,rt,210,300,150,100,111)
        steerAndMove(self,tx,ty,0.3,0x200)
        if t==60 then
            child(rt,self,0x56,99999999,90,-30,0,0x4000,1,40)
            child(rt,self,0x56,99999999,-90,-30,1,0x4000,1,40)
        elseif t==450 then
            self._bmFromX,self._bmFromY=self.ldX,self.ldY;setState(self,12)
        end
    elseif self.state==12 then
        if t==0 then
            local px,py=playerPosition()
            self._bmFromX,self._bmFromY=self.ldX,self.ldY
            self._bmTargetX=Core.clamp(px,210,510)
            self._bmTargetY=Core.clamp(py-320,200,350)
        end
        local q=sin(min(60,t)*pi/120)
        self.ldX=self._bmFromX+(self._bmTargetX-self._bmFromX)*q
        self.ldY=self._bmFromY+(self._bmTargetY-self._bmFromY)*q
        if t==60 then setState(self,13) end
    elseif self.state==13 then
        local tx,ty=randomTarget(self,rt,210,300,150,100,111)
        steerAndMove(self,tx,ty,0.1,0x200)
        if t>=40 and t<120 then self.ldY=self.ldY-sin((t-40)*pi/80)*2.4 end
        if t==780 then setState(self,11,90) end
    elseif self.state==14 then
        self.hp=1;self.targetable=false;self.protect=true
        if t<240 then self.ldY=self.ldY+0.2 end
        if t>=480 then finishStage(self,rt) end
    end
    bossStatus(self,rt)
end

handlers[0x54] = function(self,rt)
    local root=rootOf(self,0x13c)
    if not root or (root.state~=8 and root.state~=9) then remove(self);return end
    local t=self.helperTimer
    local tx=root.ldX+sin(t*tau/277)*200
    local ty=root.ldY-sin(t*tau/413)*90-sin(t*tau/688)*60
    self.ldX=self.ldX+(tx-self.ldX)/30;self.ldY=self.ldY+(ty-self.ldY)/30
    if t<172 then self.targetable=false;return end
    if not self._bmShared then self._bmShared=true;self.hp=root.hp;self.maxhp=root.maxhp end
    local hp=min(root.hp,self.hp);root.hp,self.hp=hp,hp;self.targetable=true
    local localt=(t-172)%700
    local ai=diff(rt,{83,51,33,45,33});local fi=diff(rt,{10,6,3,4,3})
    if localt>=120 and localt<480 and (localt-120)%ai==0 then self.secondaryAngle16=aim(self.ldX,self.ldY) end
    if localt>=120 and localt<480 and (localt-120)%fi==0 then
        local q=(localt-120)%(ai*2);local tri=q<ai and q or ai*2-q
        local center=self.secondaryAngle16+tri*floor(0x8000/ai)-0x4190
        local speed=diff(rt,{3.6,4.5,5,4,6})+(localt-120)*0.006
        for i=0,2 do fire(0x0d,0,self.ldX,self.ldY+10,center+i*400,speed,10) end
    end
    local bs=diff(rt,{18,9,6,4,3});local bw=diff(rt,{40,50,55,60,66})
    if ((localt>=500 and localt<500+bw and (localt-500)%bs==0) or
        (localt>=600 and localt<600+bw and (localt-600)%bs==0)) then
        local jitter=Core.frameRand(t)%40001-20000
        fire(0x11,0x0c,self.ldX,self.ldY+10,aim(self.ldX,self.ldY)+jitter,
            diff(rt,{5,6,7,8,9}))
    end
end

handlers[0x55] = function(self,rt)
    local root=rootOf(self,0x13c)
    if not root or root.state~=9 or not root._bmCombat then remove(self);return end
    local dx,dy=Core.polar(self.angle16,self.speed)
    self.ldX=self.ldX+dx;self.ldY=self.ldY+dy+self.helperTimer*0.15
    self.targetable=self.helperTimer>=50
    if self.hp<=0 then
        spawnEnemyDeathRewardBurstOnce(self,200,2)
        local px,py=playerPosition()
        if self.ldY<520 and self.ldY<py and Core.distance(self.ldX,self.ldY,px,py)>=self.radius+30 then
            local a=aim(self.ldX,self.ldY);a=floor((a+0x400)/0x800)*0x800
            fire(0,0,self.ldX,self.ldY,a,diff(rt,{3.6,4.5,5,5,6.4}),10)
        end
        self.hp=1;remove(self)
    elseif not Core.inside(self.ldX,self.ldY,180) then remove(self) end
end

handlers[0x56] = function(self,rt)
    local root=rootOf(self,0x13c)
    if not root or root.state<11 or root.state>13 or not root._bmCombat then remove(self);return end
    local tx,ty=root.ldX+self._bmOffsetX,root.ldY+self._bmOffsetY
    self.ldX=self.ldX+(tx-self.ldX)/30;self.ldY=self.ldY+(ty-self.ldY)/30
    if self.helperTimer<30 then self.targetable=false;return end
    if not self._bmShared then self._bmShared=true;self.hp=root.hp;self.maxhp=root.maxhp end
    local hp=min(root.hp,self.hp);root.hp,self.hp=hp,hp;self.targetable=true
    local t=self.helperTimer%1200
    local ai=diff(rt,{83,61,47,41,36});local step=diff(rt,{15,7,5,4,3})
    if t>=40 and t<200 and (t-40)%ai==0 then self.secondaryAngle16=aim(self.ldX,self.ldY) end
    if t>=40 and t<200 and (t-40)%step==0 then
        local q=(t-40)%(ai*2);local tri=q<ai and q or ai*2-q
        local sweep=tri*floor(28000/ai)-14000
        if self._bmOffsetX<0 then sweep=-sweep end
        fire(0x11,0x0d,self.ldX,self.ldY+10,self.secondaryAngle16+sweep,
            diff(rt,{4,4,4.5,5,6.4}),10)
    end
    local rs=diff(rt,{18,8,6,4,3})
    if t>=210 and t<340 and (t-210)%rs==0 then
        fire(0x11,0x0d,self.ldX,self.ldY+10,aim(self.ldX,self.ldY)+
            Core.frameRand(self.helperTimer+self._bmIndex)%28001-14000,
            diff(rt,{4,4,4.5,5,6.4}),10)
    end
    if t>=560 and t<1190 and t%3==0 then
        local phase=(t-560)%640;local tri=phase<320 and phase or 640-phase
        local a=0x4000+(self._bmOffsetX<0 and -1 or 1)*(tri*100-16000)
        fan(4,0,self.ldX,self.ldY,a,14,5,12000)
    end
end

-- Stage 6 midboss ---------------------------------------------------------

handlers[0x143] = function(self,rt)
    if not self._bmInit then
        self._bmInit=true;self.state=0;self.targetable=false;self.protect=true
        self._bmEntryX,self._bmEntryY=self.ldX,self.ldY;self._bmMoveAngle=0x4000
    end
    local t=self.helperTimer
    self._bmDrawOffsetX,self._bmDrawOffsetY=0,0
    if self._bmCombat and combatTick(self,rt) then setState(self,5);return end
    if self.state==0 then
        if t<=110 then
            self.ldX=self._bmEntryX-500+sin(t*pi/220)*500
            self.ldY=self._bmEntryY+sin(t*pi/110)*100
        end
        if t==120 then openPhase(self,1,50000,1680,0) end
    elseif self.state==1 or self.state==3 then
        local tx,ty=randomTarget(self,rt,210,300,150,100,111)
        steerAndMove(self,tx,ty,0.3,0x200)
        if t==1 then
            local left=child(rt,self,0x61,99999999,0,0,0,0xc000,330,20)
            local right=child(rt,self,0x61,99999999,0,0,1,0x4000,330,20)
            if left then left._bmRadius=100 end
            if right then right._bmRadius=100 end
        elseif t==10 then
            local primary=difficulty(rt)==0 and 4 or 8
            local secondary=difficulty(rt)<2 and 0 or (difficulty(rt)==2 and 4 or 8)
            local pt=self.state==1 and 0x62 or 0x63
            local st=self.state==1 and 0x63 or 0x62
            for i=0,primary-1 do
                local e=child(rt,self,pt,99999999,0,0,i+2,
                    i*floor(0x10000/primary)-0x4000,-260,20)
                if e then e._bmRadius=150 end
            end
            for i=0,secondary-1 do
                local e=child(rt,self,st,99999999,0,0,i+2+primary,
                    i*floor(0x10000/secondary)+0x1000,220,20)
                if e then e._bmRadius=200 end
            end
        elseif t==650 then
            setState(self,self.state+1)
            self.targetable=false
            self.protect=true
        end
    elseif self.state==2 or self.state==4 then
        if t==0 then
            self._bmFromX,self._bmFromY=self.ldX,self.ldY
            self._bmTargetX,self._bmTargetY=self.state==2 and 220 or 450,
                self.state==2 and 150 or 210
        end
        local q=sin(min(t,80)*pi/160)
        self.ldX=self._bmFromX+(self._bmTargetX-self._bmFromX)*q
        self.ldY=self._bmFromY+(self._bmTargetY-self._bmFromY)*q
        local randomAngle=Core.frameRand(rt.frame or 0)%0x10000
        local radians=Core.angleToRadians(randomAngle)
        local signedLimit=sin(radians)*300
        local randomUnit=floor(Core.frameRand((rt.frame or 0)+
            (self.entityId or 0)*111)/0x100)/0x1000000
        local drawRadius=randomUnit*signedLimit
        self._bmDrawOffsetX=cos(radians)*drawRadius
        self._bmDrawOffsetY=sin(radians)*drawRadius
        if t==80 then
            setState(self,self.state==4 and 1 or 3)
            self.targetable=true
            self.protect=false
        end
    elseif self.state==5 then
        self.hp=1;self.targetable=false;self.protect=true;self.ldY=self.ldY+0.1
        if t>=120 then rt.gate=false;remove(self) end
    end
    bossStatus(self,rt)
end

local function stage06MidbossNode(self,rt)
    local root=rootOf(self,0x143)
    if not root or root.state==5 or not root._bmCombat then remove(self);return end
    local t=self.helperTimer
    self.targetable=false
    if self.state==0 then
        local sign=self.speed>=0 and 1 or -1
        local u=Core.randomUnit(rt.frame+self.entityId*0x457+t*3,self.entityId)
        self.angle16=Core.angle16(self.angle16+floor((1-u)*3000)*sign)
        local radius=Core.randomUnit(rt.frame+self.entityId*0x15b3+t*5,self.entityId)*
            (self._bmRadius or 100)
        local ox,oy=Core.polar(self.angle16,radius)
        self.ldX,self.ldY=root.ldX+ox,root.ldY+oy
        if t==40 then setState(self,1) end
        return
    end
    if self.state==1 then
        self.angle16=Core.angle16(self.angle16+floor(sin(t*tau/600)*self.speed))
        local ox,oy=Core.polar(self.angle16,self._bmRadius or 100)
        self.ldX,self.ldY=root.ldX+ox,root.ldY+oy
        if self.spawnType==0x61 then
            local interval=diff(rt,{180,120,90,90,60});local localt=(t-50)%interval
            if t>=50 and t<560 and localt==0 then self.targetAngle16=aim(self.ldX,self.ldY) end
            if t>=50 and t<560 and localt<20 and localt%4==0 then
                local speed=diff(rt,{5,6,6.5,5,7})+localt*0.1
                fire(0x0b,0,self.ldX,self.ldY,self.targetAngle16,speed,10)
                if difficulty(rt)>2 then fire(0x0b,0,self.ldX,self.ldY,self.targetAngle16,speed+2,10) end
            end
            self.targetAngle16=Core.turn16(self.targetAngle16,aim(self.ldX,self.ldY),0x30)
        else
            local interval=diff(rt,{9,6,7,7,6})
            local window=t<interval*3 or t>=interval*35 or (t-interval*3)%(interval*5)>=interval*2
            if t<560 and t%interval==0 and window then
                local dir=self.spawnType==0x63 and -1 or 1
                fire(self.spawnType==0x63 and 5 or 4,0,self.ldX,self.ldY,
                    self.angle16+dir*t*0x14-0x8000,
                    diff(rt,{3.2,3.8,4.2,4.5,5.5})+t*0.0042)
            end
        end
        if t==600 then setState(self,self.spawnType==0x61 and 2 or 3);self._bmFlyX,self._bmFlyY=self.ldX,self.ldY end
    elseif self.state==2 then
        if t>=30 then remove(self) end
    else
        self._bmRadius=(self._bmRadius or 100)+1;self.speed=self.speed+0.1
        local dir=self.spawnType==0x63 and -1 or 1
        self.angle16=Core.angle16(self.angle16+dir*t*2)
        local dx,dy=Core.polar(self.angle16,self.speed)
        self._bmFlyX,self._bmFlyY=self._bmFlyX+dx,self._bmFlyY+dy
        local ox,oy=Core.polar(self.angle16,self._bmRadius)
        self.ldX,self.ldY=self._bmFlyX+ox,self._bmFlyY+oy
        fire(5,0x0f,self.ldX,self.ldY,self.angle16,0)
        if not Core.inside(self.ldX,self.ldY,50) then remove(self) end
    end
end
for t=0x61,0x63 do handlers[t]=stage06MidbossNode end

-- Stage 6 final boss ------------------------------------------------------

handlers[0x13d] = function(self,rt)
    if not self._bmInit then
        self._bmInit=true;self.state=0;self.targetable=false;self.protect=true
        self._bmMoveAngle=0x4000;self._bmLiveArms=5;self.phaseIndex=0
    end
    applyQueuedDamage(self)
    local t=self.helperTimer
    if self._bmCombat and combatTick(self,rt) then
        local nextState=({[1]=2,[3]=4,[5]=6,[7]=8,[9]=10})[self.state] or 10
        setState(self,nextState);bossStatus(self,rt);return
    end
    if self.state==0 then
        if t>=60 and t<160 then
            local q=(t-60)/100;local ease=sin(q*pi/2)
            self.ldX=480+(360-480)*ease+sin(q*pi)*45
            self.ldY=150+(240-150)*ease-sin(q*pi)*30
        elseif t>=160 then self.ldY=self.ldY+0.1 end
        local types={0x6a,0x69,0x68,0x67,0x66};local order={3,1,4,2,8}
        for i=1,5 do if t==140+i*10 then
            child(rt,self,types[i],99999999,75,0,i-1,order[i]*0x3333+0x4000,1,60)
        end end
        if t==220 then
            child(rt,self,0x64,99999999,75,0,0,0x8000,1,40)
            child(rt,self,0x65,99999999,75,0,1,0,1,40)
        elseif t==240 then openPhase(self,1,100000,3600,0) end
    elseif self.state==1 then
        local tx,ty=randomTarget(self,rt,210,300,140,100,0xde)
        steerAndMove(self,tx,ty,0.3,0x200)
    elseif self.state==2 then
        self.hp=1;self.targetable=false;self.protect=true
        if t<90 then self.ldY=self.ldY+t*0.01 end
        if t>=100 then local tx,ty=randomTarget(self,rt,210,300,140,100,0xde);steerAndMove(self,tx,ty,1.6,0x200) end
        if t==180 then openPhase(self,3,86000,2100,1) end
    elseif self.state==3 then
        local tx,ty=randomTarget(self,rt,210,300,140,100,0xde);steerAndMove(self,tx,ty,1.6,0x200)
        if t==30 then child(rt,self,0x6b,99999999,90,0,0,0x4000,1,40) end
    elseif self.state==4 then
        self.hp=1;self.targetable=false;self.protect=true
        if t<120 then self.ldY=self.ldY+t*0.02 end
        if t==130 then self.ldY=self.ldY-75 end
        if t>=130 then local tx,ty=randomTarget(self,rt,210,300,140,100,0xde);steerAndMove(self,tx,ty,0.6,0x200) end
        if t==380 then openPhase(self,5,68000,1800,2) end
    elseif self.state==5 then
        local tx,ty=randomTarget(self,rt,210,300,140,100,0xde);steerAndMove(self,tx,ty,0.6,0x200)
        if t==10 then for i,p in ipairs({{100,-120},{-100,-120},{210,-70},{-210,-70}}) do
            child(rt,self,0x6e,99999999,p[1],p[2],i-1,0x4000,1,40)
        end end
    elseif self.state==6 or self.state==8 then
        self.hp=1;self.targetable=false;self.protect=true;self.ldY=self.ldY+0.1
        if t==180 then
            if self.state==6 then openPhase(self,7,70000,2100,3)
            else openPhase(self,9,80000,2100,4) end
        end
    elseif self.state==7 then
        local tx,ty=randomTarget(self,rt,210,300,140,100,0xde);steerAndMove(self,tx,ty,0.6,0x200)
        local count=diff(rt,{17,21,25,25,27});local step=max(1,floor(100/count))
        for i=0,count-1 do if t==10+i*step then child(rt,self,0x6f,99999999,0,0,i,
            i*floor(0x10000/count)-0x4000,1,40) end end
    elseif self.state==9 then
        local tx,ty=randomTarget(self,rt,210,300,140,100,0xde);steerAndMove(self,tx,ty,0.6,0x200)
        local base=difficulty(rt)==0 and 120 or 100;local switch=(base+12)*5
        local interval=t>=switch and floor(base/2) or base
        if t>59 and (t-60)%interval==0 then
            local first=t<switch and (t-60)%(interval*2)==0 or Core.frameRand(t)%2==0
            local count=diff(rt,{15,19,21,12,9});local a=Core.randomAngle(t,self.entityId)
            local extra=difficulty(rt)==4 and 4 or (difficulty(rt)==3 and 2 or 0)
            for layer=0,extra do
                local x,y=(layer%2==0 and self.ldX-33 or self.ldX),
                    (layer%2==0 and self.ldY-83 or self.ldY)
                fan(first and 2 or 3,first and 0x1f or 0x20,x,y,
                    a+(first and -1 or 1)*layer*0x4b0,0,count,0x10000)
            end
        end
    else
        self.hp=1;self.targetable=false;self.protect=true
        if t>=480 then finishStage(self,rt) end
    end
    bossStatus(self,rt)
end

local function stage06Mount(self,rt)
    local root=rootOf(self,0x13d)
    if not root or root.state>4 or (root.state==4 and root.helperTimer>=130) then remove(self);return end
    if self.spawnType==0x64 then
        if ((root.state==1 or root.state==2) and (self.helperTimer+20)%60>39) then
            self.angle16=Core.angle16(self.angle16+0x111)
        elseif root.state>2 and self.helperTimer%30>19 then self.angle16=Core.angle16(self.angle16+0x222) end
    end
    local ox,oy=Core.polar(self.angle16,self._bmOffsetX)
    self.ldX,self.ldY=root.ldX+ox,root.ldY+oy
    if self.spawnType==0x65 then local a=aim(self.ldX,self.ldY);local px,py=Core.polar(a,24);self.ldX=self.ldX+px;self.ldY=self.ldY+py end
    self.targetable=false
    if root.state==3 and root.helperTimer==30 and not self._bmSpawnedGun then
        self._bmSpawnedGun=true;child(rt,self,self.spawnType==0x64 and 0x6c or 0x6d,
            99999999,0,0,0,0,1,50)
    end
end
handlers[0x64]=stage06Mount;handlers[0x65]=stage06Mount

local function stage06Arm(self,rt)
    local root=rootOf(self,0x13d)
    if not root or root.state>1 or not root._bmCombat then remove(self);return end
    local t=self.helperTimer
    if self.state==0 then
        if not self._bmIntroRadius then
            self._bmIntroRadius=980
            if self.spawnType==0x67 then self.angle16=0xda0a elseif self.spawnType==0x6a then self.angle16=0xa5f6 end
        end
        if t<31 then self._bmIntroRadius=self._bmIntroRadius-40 end
        local ox,oy=Core.polar(self.angle16,self._bmIntroRadius)
        self.ldX,self.ldY=root.ldX+ox,root.ldY+oy
        if root.state==1 then
            setState(self,1);self.hp=33000;self.maxhp=33000;self.targetable=true;self.protect=false
        end
        return
    end
    local ox,oy=Core.polar(self.angle16,180);self.ldX,self.ldY=root.ldX+ox,root.ldY+oy
    if self.hp<=0 then
        spawnEnemyDeathRewardBurstOnce(self,3000,0)
        queueDamage(root,20000);root._bmLiveArms=max(0,(root._bmLiveArms or 1)-1)
        self.hp=1;remove(self);return
    end
    self.targetable=true
    local broken=Core.clamp(5-(root._bmLiveArms or 5),0,5)
    local period=max(225,(8-broken)*75);local localt
    if self.spawnType==0x66 and t>=120 then
        localt=(t-120)%period;local shot=localt%diff(rt,{24,21,21,21,21})
        if localt==0 then self.secondaryAngle16=aim(self.ldX,self.ldY)-0x4000 end
        self.secondaryAngle16=Core.angle16(self.secondaryAngle16+(localt>149 and -1 or 1)*diff(rt,{200,160,140,130,130}))
        if localt<300 and shot<diff(rt,{9,15,18,21,24}) and shot%3==0 then
            local count=diff(rt,{2,3,4,5,5})+broken;if broken==4 then count=count-1 end
            fan(10,0,self.ldX,self.ldY,self.secondaryAngle16,
                diff(rt,{3.2,4,4.5,5,6})+shot*0.15+broken*0.5,count,0x10000,10)
        end
        self.angle16=Core.angle16(self.angle16+0x42)
    elseif self.spawnType==0x67 and t>=240 then
        localt=(t-240)%period;local cadence=max(1,diff(rt,{70,41,35,33,30})-broken*4)
        local target=aim(self.ldX,self.ldY)+floor(sin(t*tau/127)*4321)
        self.angle16=Core.turn16(self.angle16,target,floor(abs(Core.angleDelta(self.angle16,target))/20)+0x30)
        if localt<300 and localt%cadence==0 then
            local count=diff(rt,{3,5,7,9,11})+broken*2
            fan(3,0,self.ldX,self.ldY,self.angle16,diff(rt,{3,3.6,4,4.2,4.8})+
                localt*0.006+broken*0.2,count,(count-1)*diff(rt,{5000,3800,3300,3000,2700}),10)
        end
    elseif self.spawnType==0x68 and t>=360 then
        localt=(t-360)%period;local cadence=max(1,diff(rt,{16,10,8,8,7})-broken)
        if localt<300 and localt%cadence==0 then for i=0,3 do
            local a=self.angle16+i*0x4000+diff(rt,{130,170,190,200,240})*t
            fire(7,0,self.ldX,self.ldY,a,diff(rt,{2.8,3.5,3.8,4,5})+broken*0.4,10)
        end end
        self.angle16=Core.angle16(self.angle16+99)
    elseif self.spawnType==0x69 and t>=480 then
        localt=(t-480)%period;local cadence=max(1,diff(rt,{17,11,10,10,9})-broken)
        if localt<300 and localt%cadence==0 then
            local pairs=diff(rt,{1,2,3,4,5})+(broken==4 and 2 or 0)
            local orbit=diff(rt,{150,240,270,300,340})*t
            for side=0,1 do local ex,ey=Core.ellipse(orbit+side*0x8000,90,25,self.angle16)
                for i=0,pairs-1 do fire(4,0,self.ldX+ex,self.ldY+ey,
                    orbit+i*0xd05+(side==0 and -0x8000 or 0),
                    diff(rt,{2.8,3.5,3.8,4,5})+broken*0.4+i*0.4) end
            end
        end
    else
        localt=t%period;local cadence=diff(rt,{90,60,55,50,50})
        local a=aim(self.ldX,self.ldY)
        if localt%cadence==0 then self.secondaryAngle16=a end
        local shot=localt%cadence
        if localt<300 and shot<diff(rt,{16,16,20,24,28})+broken*4 and shot%4==0 then
            local count=shot/4+1;local spread=(count-1)*(broken*40+300)
            fan(9,0,self.ldX,self.ldY,self.secondaryAngle16,
                diff(rt,{5,6,6.5,7,9})+broken*0.7,count,spread,10)
            if broken==4 then
                fan(9,0,self.ldX,self.ldY,self.secondaryAngle16-7000,diff(rt,{5,6,6.5,7,9})+broken*0.7,count,spread,10)
                fan(9,0,self.ldX,self.ldY,self.secondaryAngle16+7000,diff(rt,{5,6,6.5,7,9})+broken*0.7,count,spread,10)
            end
        end
    end
end
for t=0x66,0x6a do handlers[t]=stage06Arm end

handlers[0x6b] = function(self,rt)
    local root=rootOf(self,0x13d);if not root or root.state~=3 then remove(self);return end
    local a=self.angle16+self.helperTimer*0x30;local ox,oy=Core.polar(a,90)
    self.ldX,self.ldY=root.ldX+ox,root.ldY+oy;self.targetable=false
    local t=self.helperTimer
    if t<300 then
        local q=t%100;if q==0 then self.secondaryAngle16=aim(self.ldX,self.ldY) end
        if q<50 and q%5==0 then fan(3,0,self.ldX,self.ldY,self.secondaryAngle16,
            diff(rt,{4,5,5.5,6,7}),diff(rt,{5,7,9,11,13}),28000,10) end
    elseif t>=600 and t%5==0 then
        self.secondaryAngle16=Core.turn16(self.secondaryAngle16,0x4000,0x80)
        fan(9,0,self.ldX,self.ldY,self.secondaryAngle16,diff(rt,{7,8,9,10,12}),4,12000,10)
    end
end

local function stage06SideGun(self,rt)
    local mount=self.parent;local root=rootOf(self,0x13d)
    if not mount or not root or root.state~=3 then remove(self);return end
    self.ldX,self.ldY=mount.ldX,mount.ldY;self.targetable=false
    local t=self.helperTimer
    if self.spawnType==0x6c and t<300 and t%diff(rt,{18,12,9,8,7})==0 then
        fan(4,0,self.ldX,self.ldY,t*diff(rt,{180,240,300,360,420}),
            diff(rt,{3.5,4,4.5,5,6}),diff(rt,{7,9,11,13,15}),0x10000)
    elseif t>=320 and t<600 and t%diff(rt,{60,45,36,30,24})==0 then
        fan(self.spawnType==0x6c and 4 or 5,0,self.ldX,self.ldY,Core.randomAngle(rt.frame,self.entityId),
            diff(rt,{4,5,5.5,6,7}),diff(rt,{9,13,17,19,23}),0x10000)
    elseif t>=770 then
        local cadence=diff(rt,{75,45,39,36,30});local q=(t-770)%cadence
        if q<20 and q%4==0 then fire(7,0,self.ldX,self.ldY,aim(self.ldX,self.ldY),
            diff(rt,{5,6,7,8,9}),10) end
    end
end
handlers[0x6c]=stage06SideGun;handlers[0x6d]=stage06SideGun

handlers[0x6e] = function(self,rt)
    local root=rootOf(self,0x13d);if not root or root.state~=5 then remove(self);return end
    local route=self._bmIndex or 0;local t=self.helperTimer
    local offsets={{100,-120},{-100,-120},{210,-70},{-210,-70}}
    local p=offsets[route+1];local tx,ty=root.ldX+p[1],root.ldY+p[2]
    if t==0 then self.ldX,self.ldY=root.ldX-33,root.ldY-83 end
    local cycle=max(0,t-40)%1200
    if cycle>=400 and cycle<660 then
        if cycle==400 then local px,py=playerPosition();self._bmTrackX=Core.clamp(px,180,540);self._bmTrackY=Core.clamp(py,180,540) end
        local a=Core.aim16(self.ldX,self.ldY,self._bmTrackX,self._bmTrackY)
        local ox,oy=Core.polar(a,250);tx,ty=self._bmTrackX+ox,self._bmTrackY+oy
    elseif cycle>=660 and cycle<1160 then
        self.targetAngle16=Core.angle16((self.targetAngle16 or route*0x4000+0x2000)+
            floor(sin((t-660)*pi/1000)*diff(rt,{80,140,160,140,160})))
        local ox,oy=Core.ellipse(self.targetAngle16,240,110,floor(sin(t*pi/90)*2000))
        tx,ty=root.ldX+ox,root.ldY+oy
    end
    self.ldX=self.ldX+(tx-self.ldX)*0.1;self.ldY=self.ldY+(ty-self.ldY)*0.1
    if t<40 then return end
    self.targetable=false
    local muzzle=aim(self.ldX,self.ldY)
    if cycle<240 then
        local start=route<2 and 10 or 30
        if cycle>=start and (cycle-start)%diff(rt,{120,90,60,50,50})==0 then
            fire(2,0x1d+(route%2),self.ldX,self.ldY,muzzle,12,10)
        end
    elseif cycle>=273 and cycle<390 and (cycle-273)%3==0 then
        fan(6,0,self.ldX,self.ldY,muzzle,6,diff(rt,{3,5,7,9,9}),max(0,cycle*-320+136400),10)
    elseif cycle>=450 and cycle<600 and (cycle-450)%3==0 then
        local speed=diff(rt,{3,3.6,4.8,6,7.5})
        fire(7,3,self.ldX,self.ldY,muzzle,speed);fire(7,3,self.ldX,self.ldY,muzzle+0x5556,speed);fire(7,3,self.ldX,self.ldY,muzzle+0xaaab,speed)
    elseif cycle>=700 and cycle<1150 then
        local period=diff(rt,{60,40,40,48,40});local q=(cycle-700)%period
        if q<diff(rt,{16,20,24,20,24}) and q%4==0 then
            fan(2,1,self.ldX,self.ldY,muzzle,diff(rt,{3.2,3.6,4,4,5}),difficulty(rt)>2 and 2 or 1,3000,10)
        end
    end
end

handlers[0x6f] = function(self,rt)
    local root=rootOf(self,0x13d);if not root or root.state~=7 then remove(self);return end
    local t=self.helperTimer
    if not self._bmCenterX then self._bmCenterX,self._bmCenterY=360,360;self.secondaryAngle16=0x4000 end
    local unfold=sin(min(40,t)*pi/80);local rx,ry=800*unfold,350*unfold
    if root.helperTimer>=160 then self._bmActive=true end
    if self._bmActive then
        self.angle16=Core.angle16(self.angle16+floor(sin(t*pi/600)*80));rx,ry=800,350
    end
    local ox,oy=Core.ellipse(self.angle16,rx,ry,0)
    self.ldX,self.ldY=self._bmCenterX+ox,self._bmCenterY+oy;self.targetable=false
    if not self._bmActive then return end
    local cycle=t%1200;local period=diff(rt,{90,60,60,60,60});local width=diff(rt,{16,20,24,24,32})
    local count=diff(rt,{1,1,1,2,2});local speed=diff(rt,{3.6,4.2,4.6,5,6.5})
    if cycle<580 then
        if cycle%period<width and cycle%period%4==0 then fan(5,0,self.ldX,self.ldY,self.secondaryAngle16,speed,count,4000,10) end
        if cycle%diff(rt,{40,30,20,20,15})==0 then fire(8,0,self.ldX,self.ldY,self.secondaryAngle16-0x8000,speed-1.6,10) end
    elseif cycle>=640 and cycle<1140 then
        local q=cycle-640
        if q%period<width and q%period%4==0 then fire(5,0,self.ldX,self.ldY,self.secondaryAngle16-0x8000,speed-1.6,10) end
        if q%diff(rt,{40,30,20,20,15})==0 then fan(8,0,self.ldX,self.ldY,self.secondaryAngle16,speed,count,4000,10) end
    end
end

-- Stage 7 gate owner ------------------------------------------------------

handlers[0x77] = function(self,rt)
    if not self._bmInit then self._bmInit=true;self.state=0;self.targetable=false;self.protect=true end
    local t=self.helperTimer
    if self.state==0 then
        if t==20 then
            child(rt,self,0x78,1800,-40,140,0,0x4000,0,40)
            child(rt,self,0x78,1800,40,70,1,0x4000,0,40)
            setState(self,1);self.targetable=true;self.protect=false
        end
        return
    elseif self.state==2 then
        self.hp=1;self.targetable=false;self.ldY=self.ldY+t*0.1
        if t>=60 then rt.gate=false;remove(self) end
        return
    end
    if self.hp<=0 then
        spawnEnemyDeathRewardBurstOnce(self,0x708,100)
        spawnPlayerCancel(self)
        self.hp=1;setState(self,2);return
    end
    local baseY=self.originY
    if t<150 then self.ldY=baseY-sin(t*pi/300)*800
    elseif t<1020 then self.ldY=baseY-800
    elseif t<1200 then self.ldY=baseY-800+sin((t-1020)*pi/360)*800
    else self.ldY=self.ldY+(t-1200)*0.01 end
    local cycle=(t-120)%328
    if t>=120 and t<1200 and cycle<120 and cycle%diff(rt,{19,13,11,10,8})==0 then
        local count=diff(rt,{6,8,9,10,10});local a=t*diff(rt,{80,100,100,120,150})
        fan(4,0,self.ldX,self.ldY+10,a,diff(rt,{5.4,6,6.5,7,8}),count,0x10000)
        fan(4,0,self.ldX,self.ldY+10,a+floor(0x10000/(count*3)),diff(rt,{4.9,5.5,6,6.5,7.5}),count,0x10000)
    end
end

handlers[0x78] = function(self,rt)
    local root=rootOf(self,0x77);if not root or root.state~=1 then remove(self);return end
    self.ldX=root.ldX+self._bmOffsetX;self.ldY=root.ldY+self._bmOffsetY+sin(root.helperTimer*pi/4)*2
    self.targetable=true
    if self.hp<=0 then
        spawnEnemyDeathRewardBurstOnce(self,0x708,12)
        self.hp=1;remove(self);return
    end
    local start=(self._bmIndex+1)*41+70;local t=self.helperTimer
    if t<start then self.angle16=Core.turn16(self.angle16,aim(self.ldX,self.ldY),floor(abs(Core.angleDelta(self.angle16,aim(self.ldX,self.ldY)))/10)+0x30) end
    local period=diff(rt,{164,123,82,82,82});local q=(t-start)%period
    if t>=start and q<16 and q%4==0 then
        local speed=diff(rt,{5.5,6.6,7.2,7.7,8.8})
        for _,off in ipairs({-600,0,600}) do fire(0x0d,0,self.ldX,self.ldY,self.angle16+off,speed,10) end
    end
end

-- Stage 7 midbosses -------------------------------------------------------

local function stage07MidbossRoot(self,rt)
    if not self._bmInit then
        self._bmInit=true;self.state=0;self.targetable=false;self.protect=true
        self._bmSourceX=self.originX;self._bmLiveParts=0
    end
    applyQueuedDamage(self)
    local t=self.helperTimer
    self.ldX=self._bmSourceX+sin(rt.frame*tau/555)*(self.spawnType==0x144 and 10 or -10)
    if self._bmCombat and combatTick(self,rt) then setState(self,3);return end
    if self.state==0 then
        if t==0 then
            child(rt,self,0x79,99999999,0,130,0,0x4000,1,70)
            if self.spawnType==0x144 then
                for i,p in ipairs({{188,110},{-188,110}}) do local e=child(rt,self,0x7a,20000,p[1],p[2],i,0x4000,1,45);if e then e._bmCounts=true end end
                for i,p in ipairs({{110,-70},{-110,-70}}) do local e=child(rt,self,0x7c,10000,p[1],p[2],i+2,0x4000,1,40);if e then e._bmCounts=true end end
                self._bmLiveParts=4
            else
                for i,p in ipairs({{188,110},{-188,110}}) do local e=child(rt,self,0x7b,15000,p[1],p[2],i,0x4000,1,45);if e then e._bmCounts=true end end
                for i,x in ipairs({60,-60,150,-150}) do local e=child(rt,self,0x7d,6000,x,-70,i+2,0x4000,1,40);if e then e._bmCounts=true end end
                self._bmLiveParts=6
            end
        end
        self.ldY=t<120 and 900-floor(sin(t*pi/240)*800) or 100
        if t==130 then openPhase(self,1,self.spawnType==0x144 and 80000 or 60000,2100,0) end
        return
    elseif self.state==3 then
        self.hp=1;self.targetable=false;self.protect=true;self.ldY=self.ldY+t*0.1
        if t>=120 then rt.gate=false;remove(self) end
        return
    end
    self.ldY=125-sin((t+222)*tau/888)*25
    self.targetable=true;self.protect=false
    if self.state==1 and (self._bmLiveParts or 0)<=0 then self.state=2 end
    local cycle=t%1400;local d=difficulty(rt)
    if self.spawnType==0x144 then
        local period=self.state==1 and 164 or 84;local localt=(cycle-10)%period
        if cycle>=10 and localt<60 and localt%({18,12,10,8,8})[d+1]==0 and (self.state==2 or cycle<600) then
            local e=child(rt,self,0x7e,500,0,40,t,Core.frameRand(t)%0x8001,
                5+(Core.frameRand(t+1)%501)/100,20)
            if e then e._bmRewardWeight=self.state==1 and 3 or 0 end
        end
        if self.state==1 and cycle>=800 and cycle<1360 and (cycle-800)%82==0 then
            fan(3,0,self.ldX,self.ldY+40,aim(self.ldX,self.ldY+40),
                ({3.2,3.5,4,4.5,5.5})[d+1]+(cycle-800)*0.002,
                ({7,9,11,13,15})[d+1],0x8000,10)
        elseif self.state==2 and t%41==0 then
            fan(3,0,self.ldX,self.ldY+40,aim(self.ldX,self.ldY+40),
                ({5.2,5.5,6,6.5,7.5})[d+1],({7,9,11,13,15})[d+1],0x8000,10)
        end
    else
        local localt=(cycle-10)%184
        if cycle>9 and localt<({40,60,80,100,100})[d+1] and localt%10==0 and (self.state==2 or cycle<560) then
            local e=child(rt,self,0x7f,500,0,40,t,Core.frameRand(t+2)%0x8001,
                5+(Core.frameRand(t+3)%501)/100,20)
            if e then e._bmRewardWeight=3 end
        end
        local start=self.state==1 and 600 or 0;local period=({164,123,82,82,41})[d+1]
        local q=(cycle-start)%period
        if cycle>=start and q==0 then self.secondaryAngle16=aim(self.ldX,self.ldY+40) end
        if cycle>=start and q<({120,100,80,80,40})[d+1] and q%({11,6,4,4,3})[d+1]==0 then
            local sweep=floor(0x8000/({120,100,80,80,40})[d+1])*q-0x4000
            local speed=(self.state==1 and ({4,4.5,5,4,6})[d+1] or ({5.5,6,6.5,5.5,6.5})[d+1])
            for _,a in ipairs({self.secondaryAngle16+sweep-2000,self.secondaryAngle16-sweep+2000,
                self.secondaryAngle16+sweep-0x8000,self.secondaryAngle16-sweep-0x8000}) do
                fire(0x0d,2,self.ldX,self.ldY+40,a,speed)
            end
        end
    end
    bossStatus(self,rt)
end
handlers[0x144]=stage07MidbossRoot;handlers[0x145]=stage07MidbossRoot

handlers[0x79] = function(self)
    local root=rootOf(self,self.parent and self.parent.spawnType)
    if not root or root.state==3 then remove(self);return end
    self.ldX,self.ldY=root.ldX,root.ldY+130;self._bmHidden=true
    self.targetable=(root.state==1 or root.state==2) and root.targetable
    if self.targetable then
        if not self._bmShared then self._bmShared=true;self.hp=root.hp;self.maxhp=root.maxhp end
        local hp=min(root.hp,self.hp);root.hp,self.hp=hp,hp
    end
end

local function breakMidbossPart(self,root)
    if self._bmBroken then return end
    local rewardWeight=(self.spawnType==0x7a or self.spawnType==0x7b) and 60 or 30
    spawnEnemyDeathRewardBurstOnce(self,0x960,rewardWeight)
    self._bmBroken=true;self.targetable=false;self.protect=true;self.hp=1
    queueDamage(root,self.maxhp or 1)
    if self._bmCounts then root._bmLiveParts=max(0,(root._bmLiveParts or 1)-1) end
    if self.spawnType==0x7a or self.spawnType==0x7b then setState(self,1) else remove(self) end
end

local function stage07MidbossPart(self,rt)
    local root=rootOf(self,self._bmRoot and self._bmRoot.spawnType)
    if not root or root.state==3 then remove(self);return end
    local baseX,baseY=root.ldX+self._bmOffsetX,root.ldY+self._bmOffsetY
    if self._bmBroken then
        self.ldX,self.ldY=baseX,baseY+self.helperTimer*0.1
        if self.helperTimer>=90 then remove(self) end
        return
    end
    if self.hp<=0 then breakMidbossPart(self,root);return end
    self.targetable=root.state==1;self.protect=not self.targetable
    local t=root.helperTimer;local d=difficulty(rt)
    if self.spawnType==0x7a or self.spawnType==0x7b then
        self.ldX,self.ldY=baseX,baseY
        if self.spawnType==0x7a then
            local period=({164,123,123,123,123})[d+1];local q=(t-90)%period
            if t>=90 and q<40 and q%5==0 then
                local n=floor(q/5)+1;fan(3,0,self.ldX,self.ldY,aim(self.ldX,self.ldY),
                    ({4.5,5.5,6,6.5,7.5})[d+1],n,(n-1)*1200,10)
            end
        else
            local alive=0;for _,e in ipairs(children(rt,root,0x7b)) do if not e._bmBroken then alive=alive+1 end end
            local period=alive<=1 and 82 or 164;local q=(t+(self._bmIndex or 0)*82)%period
            if q<32 and q%4==0 then fan(4,0,self.ldX,self.ldY,t*(self._bmIndex==1 and -240 or 240),
                ({3.5,4,4.5,5,6})[d+1],({7,9,11,13,15})[d+1],0x10000) end
        end
    else
        local a=self.angle16;local turn
        if self.spawnType==0x7c then
            if t<600 then a=Core.turn16(a,Core.aim16(baseX,baseY,root.ldX,root.ldY),0x100)
            elseif t<700 then a=Core.turn16(a,self._bmOffsetX>0 and 0 or 0x8000,0x200)
            else a=Core.angle16(a+(self._bmOffsetX>0 and 0x180 or -0x180)) end
            turn=diff(rt,{12,8,7,6,5})
        else
            if t>=620 and t<660 then a=Core.turn16(a,aim(baseX,baseY),0x400) else a=Core.turn16(a,aim(baseX,baseY),0x80) end
            turn=diff(rt,{33,27,27,27,21})
        end
        self.angle16=a;local ox,oy=Core.polar(a,20);self.ldX,self.ldY=baseX+ox,baseY+oy
        if self.spawnType==0x7c and t>700 and t%turn==0 then fan(6,0,self.ldX,self.ldY,a,
            diff(rt,{4,5,5.5,6,7}),diff(rt,{3,5,7,9,11}),18000,10)
        elseif self.spawnType==0x7d then local q=t%turn;if q<12 and q%3==0 then
            fire(6,0,self.ldX,self.ldY,a,diff(rt,{4.5,5,5.5,6,7}),10)
            if d>2 then fire(6,0,self.ldX,self.ldY,a,diff(rt,{6.5,7,7.5,8,9}),10) end
        end end
    end
end
for t=0x7a,0x7d do handlers[t]=stage07MidbossPart end

local function stage07MidbossMinion(self,rt)
    local root=rootOf(self,self._bmRoot and self._bmRoot.spawnType)
    if not root or root.state==3 then remove(self);return end
    local t=self.helperTimer
    if self.state==0 then
        self.speed=max(1.2,self.speed-0.15);moveAngle(self,self.angle16,self.speed)
        if t>=40 then
            setState(self,1);self.targetable=true;self.protect=false
            self.angle16=Core.angle16(aim(self.ldX,self.ldY)+Core.frameRand(rt.frame+self.entityId)%4445-2222)
        end
        return
    end
    if self.hp<=0 then
        spawnEnemyDeathRewardBurstOnce(self,300,self._bmRewardWeight or 3)
        self.hp=1;remove(self);return
    end
    self.targetable=true
    if self.spawnType==0x7e then
        moveAngle(self,self.angle16,self.speed)
        local period=diff(rt,{120,80,60,60,50});local q=t%period
        if t<150 and q<16 and q%4==0 then fire(7,0,self.ldX,self.ldY,aim(self.ldX,self.ldY),diff(rt,{4,5,5.5,6,7}),10) end
        if t>=180 then self.speed=self.speed+0.1 end
    else
        self.angle16=Core.turn16(self.angle16,self.secondaryAngle16 or aim(self.ldX,self.ldY),0x80)
        if t>29 then self.speed=self.speed+diff(rt,{0.06,0.08,0.1,0.12,0.15}) end
        moveAngle(self,self.angle16,self.speed)
        if t>29 and t%2==0 then fire(4,3,self.ldX,self.ldY,self.angle16,12) end
    end
    if not Core.inside(self.ldX,self.ldY,100) then remove(self) end
end
handlers[0x7e]=stage07MidbossMinion;handlers[0x7f]=stage07MidbossMinion

-- Stage 7 final double boss ----------------------------------------------

local combat07 = {[1]=true,[0x0b]=true,[0x0c]=true,[0x0d]=true,
    [0x15]=true,[0x1f]=true,[0x29]=true,[0x33]=true,[0x3d]=true}

local function resetHeads(rt,root,state,hp)
    local each=state==0x0b and max(1,floor(hp/2)) or hp
    for _,typeId in ipairs({0x83,0x84}) do
        local e=findChild(rt,root,typeId)
        if e then
            e.hp,e.maxhp,e._bmLastHp=each,each,each
            e._bmBroken=false;e._bmDefeated=false;e.protect=false;e.targetable=false
        end
    end
end

local function open07(self,rt,state,hp,countdown,phase)
    openPhase(self,state,hp,countdown,phase)
    self.targetable=false;self.protect=true
    resetHeads(rt,self,state,hp)
end

local function break07(self,rt)
    local timedOut=self.countdown<=0
    if timedOut then clearPhase(rt,100) end
    self._bmCombat=false;self.targetable=false;self.protect=true;self.hp=1
    local left=findChild(rt,self,0x83);local right=findChild(rt,self,0x84)
    local leftHp=left and left.hp or 0;local rightHp=right and right.hp or 0
    if self._bmBreaks==5 then
        if not timedOut then spawnPlayerCancel(self) end
        spawnPostDeathCounter(self,140)
        setState(self,10)
    elseif self._bmBreaks==4 then
        local leftSurvived=self.state==0x0c or (self.state==0x0b and leftHp>=rightHp)
        local source
        if leftSurvived then source=left else source=right end
        if not timedOut then spawnPlayerCancel(source or self) end
        spawnPostDeathCounter(source or self,140)
        self._bmSurvivor=leftSurvived and 0x83 or 0x84
        setState(self,leftSurvived and 0x14 or 0x28)
    elseif self._bmBreaks==3 then
        local source
        if self.state==0x15 then source=left else source=right end
        if not timedOut then spawnPlayerCancel(source or self) end
        spawnPostDeathCounter(source or self,140)
        setState(self,self.state==0x15 and 0x1e or 0x32)
    elseif self._bmBreaks==2 then
        local source
        if self.state==0x1f then source=left else source=right end
        if not timedOut then spawnPlayerCancel(source or self) end
        spawnPostDeathCounter(source or self,140)
        setState(self,self.state==0x1f and 0x3b or 0x3c)
    else
        if not timedOut then
            if left then spawnPlayerCancel(left) end
            if right then spawnPlayerCancel(right) end
            if not left and not right then spawnPlayerCancel(self) end
        end
        if left then spawnPostDeathCounter(left,140) end
        if right then spawnPostDeathCounter(right,140) end
        if not left and not right then spawnPostDeathCounter(self,140) end
        setState(self,70);self._bmFinalDeath=true
        local p=rawget(_G,"player");if p then p.invulnerableFrames=max(p.invulnerableFrames or 0,360) end
    end
    self._bmBreaks=max(0,(self._bmBreaks or 1)-1)
    self.phaseIndex=min(4,(self.phaseIndex or 0)+1)
end

handlers[0x13e] = function(self,rt)
    if not self._bmInit then
        self._bmInit=true;self.state=0;self.targetable=false;self.protect=true
        self._bmMoveAngle=0x4000;self._bmBreaks=5;self.phaseIndex=0
    end
    applyQueuedDamage(self)
    local t=self.helperTimer
    if self._bmCombat then
        self.countdown=self.countdown-1
        if self.hp<=0 or self.countdown<=0 then break07(self,rt);bossStatus(self,rt);return end
    end
    if self.state==0 then
        if t==0 then
            child(rt,self,0x83,99999999,-80,0,0,0x4000,0.3,70)
            child(rt,self,0x84,99999999,80,0,1,0x4000,0.3,70)
            for i,p in ipairs({{-115,-120,0x85},{115,-120,0x86},{230,-70,0x87},{-230,-70,0x87},
                {70,145,0x88},{-70,145,0x88},{185,115,0x88},{-185,115,0x88},
                {50,-190,0x89},{-50,-190,0x8a},{200,-190,0x8a},{-200,-190,0x89}}) do
                local hp=(p[3]==0x87 and 20000) or (p[3]==0x88 and 10000) or 99999999
                child(rt,self,p[3],hp,p[1],p[2],i+1,0x4000,1,radiusByType[p[3]])
            end
            child(rt,self,0x80,99999999,460,800,14,0x4000,1,30,true)
            child(rt,self,0x80,99999999,265,800,15,0x4000,1,30,true)
        elseif t==20 then
            child(rt,self,0x80,99999999,110,800,16,0x4000,1,30,true)
            child(rt,self,0x80,99999999,610,800,17,0x4000,1,30,true)
        end
        if t<80 then self.ldY=1000 elseif t<200 then
            local q=(t-80)/120;self.ldY=1000+(250-1000)*(0.5-cos(q*pi)*0.5)
        else self.ldY=self.ldY+0.1 end
        if t==240 then open07(self,rt,1,148000,3600,0) end
    elseif self.state==1 then
        local tx,ty=randomTarget(self,rt,260,200,230,50,difficulty(rt)*0xde)
        steerAndMove(self,tx,ty,0.2,0x200)
    elseif self.state==10 then
        self.hp=1;self._bmHidden=t>=100
        if t<90 then self.ldY=self.ldY+t*0.05 end
        if t==390 then self._bmHidden=true;open07(self,rt,0x0b,70000,2100,1) end
    elseif self.state==0x0b or self.state==0x0c or self.state==0x0d then
        local left=findChild(rt,self,0x83);local right=findChild(rt,self,0x84)
        if self.state==0x0b then
            if left and left.hp<0 then self.state=0x0d;left._bmDefeated=true;child(rt,self,0x81,99999999,left.ldX-self.ldX,left.ldY-self.ldY,0,0x4000,0,80)
            elseif right and right.hp<0 then self.state=0x0c;right._bmDefeated=true;child(rt,self,0x82,99999999,right.ldX-self.ldX,right.ldY-self.ldY,1,0x4000,0,80) end
        end
        local leftHp=left and not left._bmDefeated and left.hp or 0
        local rightHp=right and not right._bmDefeated and right.hp or 0
        self.hp=max(0,leftHp)+max(0,rightHp)
    elseif self.state==0x14 or self.state==0x1e or self.state==0x28 or self.state==0x32 or self.state==0x3b or self.state==0x3c then
        self.hp=1
        if t==180 then
            if self.state>=0x3b then open07(self,rt,0x3d,80000,2100,4)
            else open07(self,rt,self.state+1,70000,2100,self.state<0x28 and (self.state==0x14 and 2 or 3) or (self.state==0x28 and 2 or 3)) end
        end
    elseif self.state==0x15 or self.state==0x1f or self.state==0x29 or self.state==0x33 then
        local head=findChild(rt,self,self.state<0x28 and 0x83 or 0x84)
        self.hp=min(self.hp,head and head.hp or self.hp)
    elseif self.state==0x3d then
        local left=findChild(rt,self,0x83);local right=findChild(rt,self,0x84)
        self.hp=min(self.hp,left and left.hp or self.hp,right and right.hp or self.hp)
    elseif self.state==70 then
        self.hp=1;self._bmHidden=true
        if t>=480 then finishStage(self,rt) end
    end
    bossStatus(self,rt)
end

handlers[0x80] = function(self)
    local root=rootOf(self,0x13e);if not root then remove(self);return end
    local t=self.helperTimer;local amp=((self.entityId-root.entityId)%2==0) and 4000 or -4000
    self.angle16=Core.angle16(0x4000-floor(sin(t*tau/328)*amp))
    local baseY=t<120 and 800-900*sin(t*pi/240) or -100
    if root.state==70 then
        self._bmTrailExiting=true
        self._bmTrailFadeTimer=root.helperTimer
        baseY=(self._bmTrailY or baseY)+root.helperTimer*0.15
        self._bmTrailY=baseY
    end
    local ox,oy=Core.polar(self.angle16,20);self.ldX=self._bmOffsetX+ox;self.ldY=baseY+24+oy
    self.targetable=false
    if root.state==70 and root.helperTimer>=80 then remove(self) end
end

local function stage07Wreck(self)
    local root=rootOf(self,0x13e);if not root or root.state==70 then remove(self);return end
    self.targetable=false;self.ldY=self.ldY+self.helperTimer*0.1
end
handlers[0x81]=stage07Wreck;handlers[0x82]=stage07Wreck

local function headEnabled(typeId,state)
    local left=typeId==0x83
    return state==1 or state==0x0b or (state==0x0c and left) or
        (state==0x0d and not left) or state==0x3d or
        ((state==0x15 or state==0x1f) and left) or
        ((state==0x29 or state==0x33) and not left)
end

local function stage07HeadFire(self,rt,root)
    local state,t,d=root.state,root.helperTimer,difficulty(rt)
    local x,y=self.ldX,self.ldY-120
    if state>=0x0b and state<=0x0d then
        local cycle=t%1200
        if cycle>=40 and cycle<320 then
            local localt=cycle-40;if localt%80==0 then self.secondaryAngle16=aim(x,y) end
            local q=localt%80;local window=({15,25,35,45,45})[d+1]+(state==0x0b and 0 or 10)
            if q<window and q%5==0 then
                fan(self.spawnType==0x83 and 2 or 3,(self.spawnType==0x83) and ((localt%160<80) and 9 or 0) or ((localt%160<80) and 0 or 9),
                    x,y,self.secondaryAngle16,({5,6,6.5,7,8})[d+1]+localt*0.008,
                    ({17,21,23,25,27})[d+1],0x10000,10)
                self.secondaryAngle16=Core.angle16(self.secondaryAngle16+(self.spawnType==0x83 and 1 or -1)*(({180,250,300,360,420})[d+1]+localt))
            end
        elseif cycle>=360 and cycle<540 and (cycle-360)%({12,9,7,6,6})[d+1]==0 then
            local selector=self.spawnType==0x83 and (d>2 and 4 or 2) or (d>2 and 5 or 3)
            local count=({4,6,7,9,10})[d+1]
            for layer=0,count-1 do fan(selector,0,x,y,0xc000+(self.spawnType==0x83 and -1 or 1)*(cycle-360)*({400,680,750,750,750})[d+1],
                ({5.5,6.5,7,7.5,7.5})[d+1]-layer*({0.9,0.8,0.7,0.6,0.6})[d+1],2,layer*({1500,1500,1300,1000,900})[d+1],10) end
        elseif cycle>=600 and cycle<1160 then
            if self.spawnType==0x83 then
                local c=({40,30,24,20,16})[d+1]
                if (cycle-600)%c==0 then fan(4,10,x,y,aim(x,y),({5,5.5,6,6,7.2})[d+1]+(cycle-600)*0.005,({7,9,11,13,13})[d+1],44000,10) end
            else
                local c=({110,78,60,50,50})[d+1];local q=(cycle-660)%c
                if cycle>=660 and q==0 then self.secondaryAngle16=aim(x,y) end
                if cycle>=660 and q<50 and q%5==0 then fan(9,0,x,y,self.secondaryAngle16,({6,6.5,7,7,8})[d+1]+q*0.08,({3,5,7,9,11})[d+1],(({3,5,7,9,11})[d+1]-1)*({4500,3300,2700,2400,2000})[d+1],10) end
            end
        end
    elseif state==0x15 then
        local cycle=t%860
        if cycle==10 then child(rt,self,(t<985) and 0x90 or 0x8f,99999999,0,0,floor(t/860),0,1,20) end
        local start=cycle>=760 and 760 or 660
        if cycle==start then self.secondaryAngle16=aim(x,y) end
        if cycle>=start and cycle<start+({20,25,30,40,40})[d+1] and (cycle-start)%5==0 then
            fan(3,start==660 and 0x21 or 0x22,x,y,self.secondaryAngle16,({5.6,6.4,7,7.7,8.5})[d+1],({15,19,23,25,27})[d+1],0x10000,10)
        end
    elseif state==0x1f then
        if t>=10 and t<90 and (t-10)%3==0 then child(rt,self,0x93,99999999,0,-120,t,Core.randomAngle(t,self.entityId)+0x2240,5,20) end
        if t>100 then
            local period=({240,180,160,160,150})[d+1];local q=(t-100)%(period*4);local localt=(t-100)%period
            if q<60 and q%({9,6,5,5,5})[d+1]==0 then fire(0x13,0x23,localt*12,0,0x4000-localt*120+3200,({3,4,4,4,5})[d+1])
            elseif q>=period and q<period+60 and (q-period)%({9,6,5,5,5})[d+1]==0 then fire(0x13,0x23,720-localt*12,0,localt*120+0x3380,({3,4,4,4,5})[d+1])
            elseif q>=period*2 and q<period*2+60 and (q-period*2)%({11,8,7,7,7})[d+1]==0 then fire(0x13,0x24,720,localt*12,0x8000-(localt*60-1000),({3,4,4,4,5})[d+1])
            elseif q>=period*3 and q<period*3+60 and (q-period*3)%({11,8,7,7,7})[d+1]==0 then fire(0x13,0x24,0,localt*12,localt*60-1000,({3,4,4,4,5})[d+1]) end
        end
    elseif state==0x29 then
        local cycle=t%860;if cycle==10 then child(rt,self,(t<985) and 0x92 or 0x91,99999999,0,0,floor(t/860),0,1,20) end
        local start=cycle>=760 and 760 or 660;if cycle==start then self.secondaryAngle16=aim(x,y) end
        if cycle>=start and cycle<start+40 and (cycle-start)%({4,3,2,2,2})[d+1]==0 then
            fan(3,start==660 and 0x22 or 0x21,x,y,self.secondaryAngle16,({5,6,6.5,7,8})[d+1],({5,6,6,7,8})[d+1],0x10000,10)
            self.secondaryAngle16=Core.angle16(self.secondaryAngle16+(start==660 and -1 or 1)*({3500,4300,3200,3900,3200})[d+1])
        end
    elseif state==0x33 then
        local segment=({120,90,70,70,70})[d+1];local cycle=(t-10)%(({800,800,660,660,580})[d+1]+segment*5)
        if cycle<segment*5 then local path=floor(cycle/segment);local q=cycle%segment
            if q<40 and q%({11,7,6,5,4})[d+1]==0 then
                local starts={{30,0},{0,0},{690,0},{720,0},{30,720}};local ends={{690,0},{0,720},{30,0},{720,720},{690,720}}
                local a0=Core.aim16(x,y,starts[path+1][1],starts[path+1][2]);local a1=Core.aim16(x,y,ends[path+1][1],ends[path+1][2])
                child(rt,self,0x94,99999999,0,-120,t,a0+floor(Core.angleDelta(a0,a1)*q/40),6,20)
            end
        end
    elseif state==0x3d then
        if t<480 and t%diff(rt,{24,18,15,12,10})==0 then
            fan(self.spawnType==0x83 and 2 or 3,0,x,y,t*(self.spawnType==0x83 and 320 or -320),diff(rt,{4.5,5,5.5,6,7}),diff(rt,{9,13,17,19,23}),0x10000,10)
        elseif t>=480 and t%diff(rt,{18,13,11,10,9})==0 then
            local count=diff(rt,{11,15,19,21,25});fan(4,0,x,y,t*(self.spawnType==0x83 and 240 or -240),diff(rt,{5,5.5,6,6.5,7.5}),count,0x10000,10)
            fan(5,0,x,y,aim(x,y),diff(rt,{4,4.5,5,5.5,6.5}),count,0x10000,10)
        end
    end
end

local function stage07Head(self,rt)
    local root=rootOf(self,0x13e);if not root then remove(self);return end
    local state,t,left=root.state,root.helperTimer,self.spawnType==0x83
    self._bmHidden=false
    local enabled=headEnabled(self.spawnType,state)
    local transition=state==0x14 or state==0x1e or state==0x28 or state==0x32 or state==0x3b or state==0x3c
    if state<=1 or (state==10 and t<100) then
        self.ldX,self.ldY=root.ldX+self._bmOffsetX,root.ldY+self._bmOffsetY
    elseif (state==0x0c or state==0x0d) and not enabled then self._bmHidden=true;self.ldY=30000
    elseif (state==0x15 or state==0x1f or state==0x29 or state==0x33) and not enabled then self._bmHidden=true;self.ldY=10000
    elseif transition then
        local dying=((state==0x14 or state==0x1e or state==0x3b) and left) or ((state==0x28 or state==0x32 or state==0x3c) and not left)
        if dying then self.ldY=self.ldY+0.1
        elseif (state==0x14 and not left) or (state==0x28 and left) then self._bmHidden=true;self.ldY=30000
        elseif state==0x3b or state==0x3c then self.ldX=left and 220 or 500;self.ldY=900-660*sin(t*pi/360) end
    elseif enabled then
        if rt.frame%50==0 or not self._bmTargetX then
            local wide=state>0x14 and state<0x3b;local xb=left and 210 or (wide and 310 or 410)
            local xr=wide and 200 or 100;self._bmTargetX=xb+Core.frameRand(rt.frame+(self._bmIndex or 0)*0x6f)% (xr+1)
            self._bmTargetY=200+Core.frameRand(rt.frame+(self._bmIndex or 0)*0x14d)%51
        end
        steerAndMove(self,self._bmTargetX,self._bmTargetY,self.speed or 0.3,0x200)
    end
    if state==70 then self.targetable=false;if t>=(left and 220 or 240) then remove(self) end;return end
    if state==0x0b and enabled and self.hp<=0 and not self._bmDefeated then
        self._bmDefeated=true
        root.state=left and 0x0d or 0x0c
        child(rt,root,left and 0x81 or 0x82,99999999,
            self.ldX-root.ldX,self.ldY-root.ldY,left and 0 or 1,0x4000,0,80)
        self.hp=1
        enabled=false
        self._bmHidden=true
    elseif combat07[state] and enabled and self.hp<=0 then
        root.hp=0
        self.hp=1
        enabled=false
    end
    self.targetable=combat07[state] and enabled and not self._bmDefeated
    self.protect=not self.targetable
    if state==1 and self.targetable then
        local previous=self._bmLastHp or root.hp;local damage=max(0,previous-self.hp)
        if damage>0 then root.hp=max(0,root.hp-damage) end
        self.hp=min(self.hp,root.hp)
        if root.hp<=0 then self.hp=1 end
        self._bmLastHp=self.hp
    elseif state==0x3d and self.targetable then
        local hp=min(root.hp,self.hp);root.hp,self.hp=hp,hp;self._bmLastHp=hp
    else self._bmLastHp=self.hp end
    if self.targetable then stage07HeadFire(self,rt,root) end
end
handlers[0x83]=stage07Head;handlers[0x84]=stage07Head

local function boss07FirstPart(self,rt)
    local root=rootOf(self,0x13e);if not root or root.state~=1 or not root._bmCombat then remove(self);return end
    local t=root.helperTimer;self.ldX=root.ldX+self._bmOffsetX;self.ldY=root.ldY+self._bmOffsetY
    if self.spawnType==0x89 or self.spawnType==0x8a then
        local target=(t%2600>=980 and t%2600<1600) and aim(self.ldX,self.ldY) or Core.aim16(self.ldX,self.ldY,root.ldX,root.ldY)
        self.angle16=Core.turn16(self.angle16,target,0x180);local ox,oy=Core.polar(self.angle16,20);self.ldX,self.ldY=self.ldX+ox,self.ldY+oy
        local period=diff(rt,{45,36,30,24,20});local q=t%period
        if q<9 and q%3==0 then fire(6,0,self.ldX,self.ldY,self.angle16,diff(rt,{4,5,5.5,6,7}),10) end
        local previous=self._bmLastHp or root.hp;local damage=max(0,previous-self.hp)
        if damage>0 then root.hp=max(0,root.hp-damage) end
        self.hp=min(self.hp,root.hp)
        if root.hp<=0 then self.hp=1 end
        self._bmLastHp=self.hp;self.targetable=true;return
    end
    if self.spawnType==0x85 or self.spawnType==0x86 then
        self.targetable=false;local cycle=t%2600;local start=self.spawnType==0x85 and 60 or 480
        if cycle>=start and cycle<start+720 and (cycle-start)%diff(rt,{120,80,60,50,45})==0 then
            child(rt,self,self.spawnType==0x85 and 0x8b or 0x8c,900,0,0,t,aim(self.ldX,self.ldY),6,20)
        end
        if cycle>=1970 and (cycle-(self.spawnType==0x85 and 1970 or 2120))%300==0 then
            child(rt,self,self.spawnType==0x85 and 0x8d or 0x8e,3600,0,0,t,aim(self.ldX,self.ldY),5,20)
        end
    elseif self.spawnType==0x87 then
        self.targetable=true
        if self.hp<=0 then
            spawnEnemyDeathRewardBurstOnce(self,0xf3c,0)
            queueDamage(root,self.maxhp);self.hp=1;remove(self);return
        end
        local cycle=t%2600;local q=(t-20)%82
        if q<30 and q%5==0 then fan(3,0,self.ldX,self.ldY,0x4000,diff(rt,{4,5,5.5,6,7}),3,12000,10) end
        local start=self._bmOffsetX>0 and 330 or 750
        if cycle>=start and cycle<start+150 and (cycle-start)%diff(rt,{6,5,4,4,4})==0 then
            fan(4,0,self.ldX,self.ldY,(cycle-start)*300,diff(rt,{4,5,5.5,6,7}),diff(rt,{5,7,9,11,11}),0x10000,10)
        end
    else
        self.targetable=true
        if self.hp<=0 then
            spawnEnemyDeathRewardBurstOnce(self,0xf3c,0)
            queueDamage(root,self.maxhp);self.hp=1;remove(self);return
        end
        local period=diff(rt,{164,123,81,81,81});local q=t%period
        if q==0 then self.secondaryAngle16=floor((aim(self.ldX,self.ldY)+0x400)/0x800)*0x800 end
        if q<16 and q%4==0 then fire(0x0f,0,self.ldX,self.ldY,self.secondaryAngle16,diff(rt,{4,5,5.5,6,7}),10) end
    end
    if self.spawnType==0x85 or self.spawnType==0x86 then
        local previous=self._bmLastHp or root.hp;local damage=max(0,previous-self.hp)
        if damage>0 then root.hp=max(0,root.hp-damage) end
        self.hp=min(self.hp,root.hp)
        if root.hp<=0 then self.hp=1 end
        self._bmLastHp=self.hp;self.targetable=true
    end
end
for t=0x85,0x8a do handlers[t]=boss07FirstPart end

local function boss07Minion(self,rt)
    local root=rootOf(self,0x13e);if not root or not root._bmCombat then remove(self);return end
    local t=self.helperTimer
    if self.state==0 then
        self.speed=max(0,self.speed-0.15);moveAngle(self,self.angle16,self.speed)
        if t>=40 then
            setState(self,1);self.targetable=true;self.protect=false
            if self.spawnType==0x8b then self.speed=1.2;self.angle16=aim(self.ldX,self.ldY)+Core.frameRand(rt.frame)%4445-2222
            elseif self.spawnType==0x8c then self.speed=0;self.secondaryAngle16=aim(self.ldX,self.ldY)
            else self.speed=1;self.angle16=aim(self.ldX,self.ldY);self.secondaryAngle16=self.angle16 end
        end
        return
    end
    if self.hp<=0 then
        spawnEnemyDeathRewardBurstOnce(self,300,0)
        queueDamage(root,self.maxhp or 1);self.hp=1;remove(self);return
    end
    self.targetable=true
    if self.spawnType==0x8b then
        if t<150 and t%diff(rt,{120,60,45,45,40})==0 then
            local a=aim(self.ldX,self.ldY)+Core.frameRand(root.helperTimer+t)%24001-12700
            for i=0,2 do fire(4,0,self.ldX,self.ldY,a+i*700,diff(rt,{3.8,4.5,5,5,6})) end
        end
    elseif self.spawnType==0x8c then
        self.angle16=Core.turn16(self.angle16,self.secondaryAngle16,0x30+floor(abs(Core.angleDelta(self.angle16,self.secondaryAngle16))/10))
        if t>29 then self.speed=self.speed+diff(rt,{0.06,0.08,0.1,0.12,0.15});if t%2==0 then fire(4,3,self.ldX,self.ldY,self.angle16,12) end end
    else
        local period=diff(rt,{100,100,75,75,65});local phase=t%period;local half=floor(period/2);local tri=phase<half and phase or period-phase
        local turn=floor(tri*diff(rt,{4000,4500,4500,5000,5000})/max(1,half))
        if t<150 and t%3==0 then fan(9,0,self.ldX,self.ldY,self.secondaryAngle16+(self.spawnType==0x8d and turn or -turn),
            diff(rt,{4.5,5,5.5,6,7})+t*0.04,diff(rt,{6,8,9,11,13}),0x10000,10) end
        if t<150 and t%diff(rt,{80,60,50,40,32})==0 then fan(4,0,self.ldX,self.ldY,aim(self.ldX,self.ldY),
            diff(rt,{3,3.5,4,4,5}),diff(rt,{13,17,23,27,31}),0x10000) end
    end
    moveAngle(self,self.angle16,self.speed);if t>179 and self.spawnType~=0x8c then self.speed=self.speed+0.1 end
    if not Core.inside(self.ldX,self.ldY,100) then remove(self) end
end
for t=0x8b,0x8e do handlers[t]=boss07Minion end

local function boss07Orbit(self,rt)
    local head=self.parent;local root=rootOf(self,0x13e)
    if not head or not root or not root._bmCombat then remove(self);return end
    local t=self.helperTimer;self.targetable=false
    local centerAngle=0x4000+floor(sin(rt.frame*tau/164)*(head.spawnType==0x83 and 1200 or -1200))
    local cx,cy=head.ldX,head.ldY-120;local cox,coy=Core.polar(centerAngle,24);cx,cy=cx+cox,cy+coy
    local scale=sin(min(540,t)*pi/1080);local rx,ry=200*scale,50*scale
    local tilt=floor(sin((t-270)*pi/540)*((self.spawnType==0x8f or self.spawnType==0x92) and -4000 or 4000))
    local ox,oy=Core.ellipse(self.angle16,rx,ry,tilt);self.ldX,self.ldY=cx+ox,cy+oy
    self.angle16=Core.angle16(self.angle16+((self.spawnType==0x8f or self.spawnType==0x92) and -0x1e5 or 0x1e5))
    if self.spawnType<=0x90 then
        if t>9 and (t-10)%diff(rt,{11,8,7,8,7})==0 then local a=-t*0x118;local count=diff(rt,{3,5,7,7,8});local speed=diff(rt,{3.5,4.5,5,4.5,6})+t*0.003
            fan(4,0,self.ldX,self.ldY,a,speed,count,count*3000-3000);fan(4,0,self.ldX,self.ldY,a-0x8000,speed,count,count*3000-3000) end
    else
        local period=diff(rt,{50,39,39,50,50});if t>=10 and (t-10)%period==0 then self.secondaryAngle16=aim(self.ldX,self.ldY) end
        local count=diff(rt,{10,14,16,18,20})+floor(max(0,t-10)/(period*2));local q=(t-10)%(period*2)
        if q<diff(rt,{12,21,27,36,36}) and q%3==0 then fan(0x0b,0,self.ldX,self.ldY,self.secondaryAngle16,
            diff(rt,{4,4.5,5.2,6,7})+t*0.004,count,0x10000,10) end
    end
    if t>=540 then
        local count=diff(rt,{20,36,44,50,55});for layer=0,diff(rt,{1,2,3,5,6})-1 do
            fan(head.spawnType==0x83 and 3 or 2,0,self.ldX,self.ldY,aim(self.ldX,self.ldY)+layer*floor(0x10000/(count*5))*2,
                diff(rt,{4.5,4.5,4,4,4})+layer*0.9,count,0x10000,10) end
        remove(self)
    end
end
for t=0x8f,0x92 do handlers[t]=boss07Orbit end

local function boss07Tracer(self,rt)
    local root=rootOf(self,0x13e);if not root then remove(self);return end
    moveAngle(self,self.angle16,self.speed);self.speed=self.speed+0.1;self.targetable=false
    if self.spawnType==0x94 and not Core.inside(self.ldX,self.ldY,30) then
        local bx,by=Core.polar(self.angle16,-30);self.ldX,self.ldY=self.ldX+bx,self.ldY+by
        fire(0x14,0x25,self.ldX,self.ldY,aim(self.ldX,self.ldY),diff(rt,{2,3,4,4,5}));remove(self)
    elseif not Core.inside(self.ldX,self.ldY,180) then remove(self) end
end
handlers[0x93]=boss07Tracer;handlers[0x94]=boss07Tracer

local BossMiddleController={}
BossMiddleController.__index=BossMiddleController

function BossMiddleController.new(entityHandlers)
    return setmetatable({entityHandlers=entityHandlers},BossMiddleController)
end

function BossMiddleController:update(entity,rt)
    local fn=self.entityHandlers[entity.spawnType]
    if not fn then return false end
    setAppearance(entity)
    fn(entity,rt)
    refreshVisual(entity,rt)
    entity._bmDrawAngle=Core.angleToDeg(entity.angle16 or 0x4000)+90
    -- Boss bodies use movement headings internally, but the original queues
    -- their character art upright. enemy.lua may consume this in M.render.
    if entity.spawnType>=0x13c or entity.spawnType==0x4f or entity.spawnType==0x143 or
       entity.spawnType==0x144 or entity.spawnType==0x145 or
       entity.spawnType==0x83 or entity.spawnType==0x84 then
        entity._bmDrawAngle=0
    end
    -- These entities own their off-screen lifetime. In particular, the two
    -- Stage 7 heads are parked outside the playfield and reused next phase.
    entity.seen=false
    return true
end

local controller=BossMiddleController.new(handlers)

function M.update(self,rt)
    return controller:update(self,rt)
end

local function renderGauge(self)
    if self.spawnType>=0x138 and self.spawnType<=0x14c then return end
    if self._bmHidden or not self.img or not self.targetable or
       not self.maxhp or self.maxhp<=0 or self.radius<80 then return end
    local gauge=self.radius>=130 and "ld_boss_gauge_1" or "ld_enemy_gauge_1"
    if lstg.CheckRes(2,gauge) then
        Render(gauge,self.x,self.y+self.radius*Core.worldScaleY()*0.55,0,
            0.6,0.6)
    end
end

local gaugeProxyClass
if type(rawget(_G,"Class"))=="function" and
   type(rawget(_G,"object"))=="table" and
   type(rawget(_G,"New"))=="function" then
    gaugeProxyClass=Class(object)

    function gaugeProxyClass:init(owner)
        self.owner=owner
        self.layer=(rawget(_G,"LAYER_ENEMY_BULLET") or -200)+0x14
        self.group=rawget(_G,"GROUP_GHOST") or 0
        self.bound=false
        self.colli=false
        self.x,self.y=owner.x,owner.y
    end

    function gaugeProxyClass:frame()
        local owner=self.owner
        local valid=owner and owner.active~=false and
            owner.status~="del" and owner.status~="kill"
        local engine=rawget(_G,"lstg")
        if valid and engine and type(engine.IsValid)=="function" then
            valid=engine.IsValid(owner)
        end
        if not valid then
            if owner and owner._bmGaugeProxy==self then owner._bmGaugeProxy=nil end
            Del(self)
            return
        end
        self.x,self.y=owner.x,owner.y
    end

    function gaugeProxyClass:render()
        if self.owner then renderGauge(self.owner) end
    end
end

local function renderGaugeOnExactLayer(self)
    if self.spawnType>=0x138 and self.spawnType<=0x14c then return end
    if not self.maxhp or self.maxhp<=0 or not self.radius or self.radius<80 then return end
    if gaugeProxyClass then
        local proxy=self._bmGaugeProxy
        local engine=rawget(_G,"lstg")
        if proxy and engine and type(engine.IsValid)=="function" and
           not engine.IsValid(proxy) then
            proxy=nil
        end
        if not proxy then
            proxy=New(gaugeProxyClass,self)
            self._bmGaugeProxy=proxy
        end
        if proxy then return end
    end
    renderGauge(self)
end

local visualLayerProxyClass
if type(rawget(_G,"Class"))=="function" and
   type(rawget(_G,"object"))=="table" and
   type(rawget(_G,"New"))=="function" then
    visualLayerProxyClass=Class(object)

    function visualLayerProxyClass:init(owner,exactLayer)
        self.owner=owner
        self.exactLayer=exactLayer
        self.layer=exactToLuaLayer(exactLayer)
        self.group=rawget(_G,"GROUP_GHOST") or 0
        self.bound=false
        self.colli=false
        self.x,self.y=owner.x,owner.y
    end

    function visualLayerProxyClass:frame()
        local owner=self.owner
        local valid=owner and owner.active~=false and
            owner.status~="del" and owner.status~="kill"
        local engine=rawget(_G,"lstg")
        if valid and engine and type(engine.IsValid)=="function" then
            valid=engine.IsValid(owner)
        end
        if not valid then
            Del(self)
            return
        end
        self.x,self.y=owner.x,owner.y
    end

    function visualLayerProxyClass:render()
        local owner=self.owner
        local visual=LikeDreamer.BossMiddleVisual
        if owner and visual and visual.render then
            visual.render(owner,self.exactLayer)
        end
    end
end

local VisualLayerProxyPool={}
VisualLayerProxyPool.__index=VisualLayerProxyPool

function VisualLayerProxyPool.new(proxyClass,ownerField,layersFor)
    return setmetatable({
        proxyClass=proxyClass,
        ownerField=ownerField,
        layersFor=layersFor,
    },VisualLayerProxyPool)
end

function VisualLayerProxyPool:ensure(owner)
    local visual=LikeDreamer.BossMiddleVisual
    local layers=visual and self.layersFor(visual,owner)
    if not self.proxyClass or not layers then return false end
    owner[self.ownerField]=owner[self.ownerField] or {}
    local proxies=owner[self.ownerField]
    local engine=rawget(_G,"lstg")
    for _,exactLayer in ipairs(layers) do
        local proxy=proxies[exactLayer]
        if proxy and engine and type(engine.IsValid)=="function" and
           not engine.IsValid(proxy) then
            proxy=nil
        end
        if not proxy then
            proxy=New(self.proxyClass,owner,exactLayer)
            proxies[exactLayer]=proxy
        end
        if not proxy then return false end
    end
    return true
end

local visualLayerProxies=VisualLayerProxyPool.new(
    visualLayerProxyClass,"_bmLayerProxies",
    function(visual,owner)
        return visual.extraLayers and visual.extraLayers(owner)
    end)

function M.render(self)
    if not handled[self.spawnType] then return false end
    if self._bmHidden or not self.img then return true end
    local visual=LikeDreamer.BossMiddleVisual
    local layered=visualLayerProxies:ensure(self)
    local exactLayer=layered and visual and visual.primaryLayer and
        visual.primaryLayer(self) or nil
    if visual and visual.render(self,exactLayer) then
        renderGaugeOnExactLayer(self)
        return true
    end
    local scale=1
    if self.sheet=="s" then scale=scale*0.55 elseif self.sheet=="m" then scale=scale*0.42 end
    if self.spawnType==0x13e then
        local function drawLarge(frame,ox,oy)
            local img="ld_enemy_l_"..tostring(frame+1)
            if lstg.CheckRes(2,img) then
                Render(img,self.x+(ox or 0)*Core.worldScale(),
                    self.y-(oy or 0)*Core.worldScaleY(),0,scale,scale)
            end
        end
        drawLarge(45,0,20)
        if Core.frameRand(max(0,(LikeDreamer.runtime and LikeDreamer.runtime.frame or 0)-1))%5~=0 then
            drawLarge(51,0,0)
        end
        drawLarge(49,0,0)
        drawLarge(50,0,0)
        renderGaugeOnExactLayer(self)
        return true
    end
    Render(self.img,self.x,self.y,self._bmDrawAngle or 0,
        (self._bmFlipX and -1 or 1)*scale,scale)
    renderGaugeOnExactLayer(self)
    return true
end

M.handled = handled

return M
