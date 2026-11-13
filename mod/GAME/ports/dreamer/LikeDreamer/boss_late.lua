-- Stage 8-10 boss state machines reconstructed from Like Dreamer.
-- Coordinates and angles stay in the original 600x720, y-down space.

LikeDreamer = LikeDreamer or {}

local Core = assert(LikeDreamer.Core)
local Projectile = assert(LikeDreamer.Projectile)

local M = {}
LikeDreamer.BossLate = M

local sin, cos, abs = math.sin, math.cos, math.abs
local floor, min, max = math.floor, math.min, math.max
local pi = math.pi
local tau = pi * 2

local handlers = {}
local ensureRenderProxies
local stageEffectClass
local spawnTerminalComponents

M.Dispatcher = {}
M.Dispatcher.__index = M.Dispatcher

function M.Dispatcher.new(handlerMap)
    return setmetatable({handlers = handlerMap}, M.Dispatcher)
end

-- The original renderer orders enemies by small integer queue layers. Keep
-- entities sharing one exact layer on the same LuaSTG layer so their creation
-- order remains the tie breaker.
local exactLayerByType = {
    -- Stage 8 boss nodes.
    [0xa7] = 0x1d, [0xa8] = 0x1d, [0xa9] = 0x1d, [0xaa] = 0x1d,
    [0xab] = 0x20, [0xac] = 0x1f,
    [0xb8] = 0x20, [0xb9] = 0x1e, [0xba] = 0x1f,

    -- Stage 9 midbosses and attached nodes.
    [0x146] = 0x1e, [0x147] = 0x20, [0x148] = 0x20,
    [0x149] = 0x1e, [0x14a] = 0x1f, [0x14b] = 0x19,
    [0xc4] = 0x23, [0xc5] = 0x23, [0xc6] = 0x23,
    [0xc7] = 0x21, [0xc8] = 0x23, [0xc9] = 0x1c, [0xca] = 0x1a,
    [0xcd] = 0x1d,

    -- Stage 10 scene structure. Combat nodes are state-dependent below.
    [0x14c] = 0x11,
    [0xde] = 0x13, [0xdf] = 0x12, [0xe0] = 0x11,
    [0xe1] = 0x12, [0xe2] = 0x11, [0xe3] = 0x10,

    -- Stage 10 final boss and its single-layer devices.
    [0x141] = 0x1e,
    [0x111] = 0x1e, [0x112] = 0x1e, [0x113] = 0x1e,
    [0x114] = 0x1c, [0x115] = 0x1e,
    [0x11a] = 0x1e, [0x11b] = 0x1d, [0x11c] = 0x1c,
    [0x11d] = 0x1e, [0x11e] = 0x20, [0x11f] = 0x1f,
    [0x120] = 0x20, [0x121] = 0x1f, [0x122] = 0x1d,
    [0x125] = 0x1e, [0x126] = 0x1e, [0x127] = 0x1e,
    [0x12d] = 0x1e,
    [0x123] = 0x23, [0x124] = 0x23,
    [0x12b] = 0x23, [0x12c] = 0x23,
}

for typeId = 0xad, 0xb7 do exactLayerByType[typeId] = 0x24 end
for typeId = 0xbc, 0xc2 do exactLayerByType[typeId] = 0x24 end
for typeId = 0xce, 0xd9 do exactLayerByType[typeId] = 0x20 end
for typeId = 0xda, 0xdd do exactLayerByType[typeId] = 0x23 end
for typeId = 0xf2, 0xf9 do exactLayerByType[typeId] = 0x17 end
for typeId = 0x105, 0x110 do exactLayerByType[typeId] = 0x24 end
for typeId = 0x12e, 0x135 do exactLayerByType[typeId] = 0x24 end

local function trunc(value)
    return value < 0 and math.ceil(value) or floor(value)
end

local function exactBodyLayer(self)
    local typeId = self.spawnType
    local state = self.state or 0
    local timer = self.helperTimer or 0
    if typeId == 0x13f then
        local coreVisible = (state >= 21 and state <= 29) or
            (state == 20 and timer >= 130) or
            (state == 30 and timer < 130)
        return coreVisible and 0x1d or 0x1e
    elseif typeId == 0x140 then
        local late = state > 10 or (state == 10 and timer >= 250)
        return late and 0x23 or 0x1e
    elseif typeId >= 0xe4 and typeId <= 0xf1 then
        return state == 2 and 0x14 or 0x17
    elseif typeId >= 0x116 and typeId <= 0x119 then
        return Core.clamp(0x19 + trunc((self.ldY or 0) / 100), 0, 0x24)
    end
    return exactLayerByType[typeId]
end

local function exactToLuaLayer(exactLayer)
    return (rawget(_G, "LAYER_ENEMY") or 0) +
        (exactLayer - 0x23) * 0.01
end

local function applyExactLayer(self)
    local typeId = self.spawnType
    if typeId == 0xc3 or typeId == 0x136 then
        local playerLayer = rawget(_G, "LAYER_PLAYER")
        self.layer = playerLayer and playerLayer + 1 or
            (rawget(_G, "LAYER_ENEMY_BULLET") or -200) - 0x14
        return
    end
    local exactLayer = exactBodyLayer(self)
    if exactLayer and exactLayer <= 0x24 then
        self.layer = exactToLuaLayer(exactLayer)
    end
end

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

local function ring(visual, projectileId, x, y, angle, speed, count, arg)
    return fan(visual, projectileId, x, y, angle, speed, count, 0x10000,
        0, 1, arg)
end

local function randomUnit(self, rt, salt)
    local frame = (rt.frame or 0) + (self.age or 0) * 0x45d9
    return Core.randomUnit(frame, (self.entityId or 0) * 0x9e37 + salt)
end

local function randomRange(self, rt, salt, lo, hi)
    return lo + (hi - lo) * randomUnit(self, rt, salt)
end

local function randomInt(self, rt, salt, lo, hi)
    return min(hi, floor(randomRange(self, rt, salt, lo, hi + 1)))
end

local function setState(self, state)
    self.state = state
    self.helperTimer = -1
end

local function parentOf(self)
    local parent = self.parent or self._blParent
    if not parent or parent.active == false or parent.removeRequested or
       parent.deadRequested then
        return nil
    end
    return parent
end

local function rootOf(self)
    local root = self
    local guard = 0
    while root and (root.parent or root._blParent) and guard < 8 do
        root = root.parent or root._blParent
        guard = guard + 1
    end
    if root and root.active ~= false and not root.removeRequested then return root end
    return nil
end

local function configureVisual(self, frame, radius, sheet)
    self.sheet = sheet or "boss"
    self.visualFrame = (frame or 0) % 30
    self.radius = radius or self.radius or 30
end

local function spawnChild(rt, parent, spawnType, hp, offsetX, offsetY,
                          index, angle, speed, note)
    if not rt.spawnChild then return nil end
    local child = rt:spawnChild(parent, spawnType, hp or 1000,
        parent.ldX + (offsetX or 0), parent.ldY + (offsetY or 0),
        note or "Like Dreamer boss child")
    if child then
        child._blParent = parent
        child._blOffsetX = offsetX or 0
        child._blOffsetY = offsetY or 0
        child._blIndex = index or 0
        child.angle16 = Core.angle16(angle or child.angle16 or 0)
        child.speed = speed or 0
        child.targetable = false
        child.protect = false
        applyExactLayer(child)
    end
    return child
end

local function follow(self, parent, offsetX, offsetY, divisor)
    local tx = parent.ldX + (offsetX or self._blOffsetX or 0)
    local ty = parent.ldY + (offsetY or self._blOffsetY or 0)
    divisor = divisor or 1
    self.ldX = self.ldX + (tx - self.ldX) / divisor
    self.ldY = self.ldY + (ty - self.ldY) / divisor
end

local function remove(self)
    self.targetable = false
    self.protect = true
    self.removeRequested = true
end

local function protectPlayer(frames)
    local p = rawget(_G, "player")
    if p then p.invulnerableFrames = max(p.invulnerableFrames or 0, frames) end
end

local function spawnPostDeathCounter(enemy, lifetime)
    local reward = LikeDreamer.Reward
    if reward and reward.spawnPostDeathCounter then
        return reward.spawnPostDeathCounter(enemy, lifetime)
    end
end

local function spawnPostDeathCounterOnce(enemy, lifetime, key)
    key = key or "_blPostDeathCounter"
    if enemy[key] then return nil end
    enemy[key] = true
    return spawnPostDeathCounter(enemy, lifetime)
end

function M.spawnEnemyDeathRewardBurstOnce(enemy, payoutWindow, rewardWeight)
    if enemy._blDeathRewardBurst or enemy._ldRewardSpawned then return false end
    local reward = LikeDreamer.Reward
    if not reward or not reward.spawnEnemyDeathRewardBurst then return false end
    enemy._blDeathRewardBurst = true
    enemy._ldRewardSpawned = true
    enemy.rewardWeight = rewardWeight
    reward.spawnEnemyDeathRewardBurst(enemy, payoutWindow)
    return true
end

function M.spawnPlayerCancel(source)
    local p = rawget(_G, "player")
    local playerClass = LikeDreamer.PlayerClass
    if p and playerClass and p.class == playerClass and
            type(playerClass._spawnSpecial) == "function" then
        playerClass._spawnSpecial(p, 0x18,
            source.ldX, source.ldY, 0, 0, 0, 0)
    end
end

local function clearForBreak(source, timeout)
    if timeout then
        Projectile.clear()
        protectPlayer(100)
    else
        M.spawnPlayerCancel(source)
    end
end

local function stageFrameRand(seed)
    if Core.frameRand then return Core.frameRand(seed) end
    return floor(Core.randomUnit(seed, 0) * 0x100000000) % 0x100000000
end

local function stageRandomAngle(seed)
    if Core.randomAngle then return Core.randomAngle(seed, 0) end
    local random = stageFrameRand(seed)
    return Core.angle16(random - floor(random / 0x10001))
end

local function scriptRandomHundredth(seed, minimum, maximum)
    local minimum100 = trunc(minimum * 100)
    local maximum100 = trunc(maximum * 100)
    if minimum100 == maximum100 then return minimum end
    return (minimum100 + stageFrameRand(seed) %
        (maximum100 - minimum100 + 1)) / 100
end

local function stageEffectLayer(exactLayer)
    return (rawget(_G, "LAYER_ENEMY_BULLET") or -200) + exactLayer - 0x50
end

local function playStageSound(rt, name, volume)
    if rt and rt.stageSoundTrace then
        rt.stageSoundTrace[#rt.stageSoundTrace + 1] = name
    end
    local engine = rawget(_G, "lstg")
    if not engine or type(engine.PlaySound) ~= "function" then return end
    if type(engine.CheckRes) ~= "function" or engine.CheckRes(5, name) then
        engine.PlaySound(name, volume or 0.5, 0)
    end
end

local function spawnStageEffect(rt, spec)
    if rt and (rt.stageEffectCount or 0) >= 0x1000 then return nil end
    if rt and rt.stageEffectTrace then
        local trace = {}
        for key, value in pairs(spec) do trace[key] = value end
        rt.stageEffectTrace[#rt.stageEffectTrace + 1] = trace
    end
    local constructor = rawget(_G, "New")
    if not stageEffectClass or type(constructor) ~= "function" then return nil end
    return constructor(stageEffectClass, rt, spec)
end

local function spawnSceneDeathExplosionChain(self, rt)
    local timer = self.helperTimer or 0
    if timer % 3 ~= 0 then return end

    local frame = rt.frame or 0
    local radius = floor(self.radius or 0)
    local random = stageFrameRand(timer)
    local burstAngle = stageRandomAngle(timer)
    local distance = random % max(1, radius + 51)
    local dx, dy = Core.polar(burstAngle, distance)
    local x, y = self.ldX + dx, self.ldY + dy
    local scaleBase = radius / 200 + 0.1
    local burstScale = scriptRandomHundredth(
        frame, scaleBase, scaleBase + 0.3)
    spawnStageEffect(rt, {
        kind = "death_burst", img = "ld_player_fx_m_6",
        x = x, y = y, angle16 = burstAngle, speed = 1,
        scale = burstScale, lifetime = 0x18, alpha = 0xff,
        layer = stageEffectLayer(0x3e), sourceFrame = frame,
    })

    local sparkAngle = stageRandomAngle(timer * 0x37)
    spawnStageEffect(rt, {
        kind = "death_spark", img = "ld_player_15",
        x = x, y = y, angle16 = sparkAngle,
        speed = scriptRandomHundredth(frame * 0x22b, 14, 22),
        scale = scriptRandomHundredth(timer * 0x15b3, 0.8, 1.6),
        alpha = 0xc0, layer = stageEffectLayer(0x48),
        sourceFrame = frame,
    })
    if timer % 6 == 0 then playStageSound(rt, "ld_se_Blast1", 0.4) end
end

spawnTerminalComponents = function(rt, x, y, frame)
    for index = 0, 0x2f do
        spawnStageEffect(rt, {
            kind = "terminal_radial", img = "ld_player_fx_m_4",
            x = x, y = y, angle16 = stageRandomAngle(frame + index),
            speed = 3 + index * 0.4, scale = 0.1 + index * 0.02,
            alpha = 0xff, layer = stageEffectLayer(0x4f),
            initialAge = -1, sourceFrame = frame,
        })
    end
    for index = 0, 0x1f do
        spawnStageEffect(rt, {
            kind = "death_spark", img = "ld_player_15",
            x = x, y = y,
            angle16 = stageRandomAngle(frame + index * 0x37),
            speed = scriptRandomHundredth(frame + index * 0x22b, 16, 26),
            scale = scriptRandomHundredth(frame + index * 0x15b3, 1.1, 2.2),
            alpha = 0xc0, layer = stageEffectLayer(0x48),
            initialAge = -1, sourceFrame = frame,
        })
    end
    spawnStageEffect(rt, {
        kind = "terminal_center", img = "ld_player_fx_l_1",
        x = x, y = y, angle16 = 0, scale = 0,
        alpha = 0xff, layer = stageEffectLayer(0x5b),
        initialAge = -1, sourceFrame = frame,
    })
end

local function spawnSceneTerminalBlast(self, rt)
    playStageSound(rt, "ld_se_Blast2", 0.5)
    spawnStageEffect(rt, {
        kind = "terminal_driver", x = self.ldX, y = self.ldY,
        angle16 = 0, layer = stageEffectLayer(0x28),
        sourceFrame = rt.frame or 0,
    })
end

local function bossTarget(self, rt, interval, x1, x2, y1, y2, salt)
    local t = self.helperTimer or 0
    if not self._blTargetX or t % (interval or 50) == 0 then
        self._blTargetX = randomRange(self, rt, (salt or 0) + t, x1 or 210, x2 or 510)
        self._blTargetY = randomRange(self, rt, (salt or 0) + t + 1, y1 or 150, y2 or 280)
    end
    local a = Core.aim16(self.ldX, self.ldY, self._blTargetX, self._blTargetY)
    self.angle16 = Core.turn16(self.angle16, a, self._blTurn or 0x200)
end

local function bossMove(self, rt, speed, interval, x1, x2, y1, y2, salt)
    bossTarget(self, rt, interval, x1, x2, y1, y2, salt)
    move(self, self.angle16, speed)
end

local function battleTelemetry(self, rt)
    rt.boss = self
    rt.bossState = self.state
    rt.bossTimer = self.helperTimer
    if rt.stage == 8 then
        rt.stage08BossState = self.state
        rt.stage08BossTimer = self.helperTimer
    elseif rt.stage == 9 then
        rt.stage09BossState = self.state
        rt.stage09BossTimer = self.helperTimer
    end
end

local function setBattle(self, state, hp, countdown)
    self.hp = hp
    self.maxhp = hp
    self.countdown = countdown
    self.targetable = true
    self.protect = false
    setState(self, state)
    self.portPhase = (self.portPhase or 0)+1
end

local function tickCountdown(self)
    self.countdown = max(0, (self.countdown or 1) - 1)
    return self.countdown <= 0
end

local function playerBlocking()
    local p = rawget(_G, "player")
    return p and ((p.bombLock or 0) > 0 or (p.playerStateTimer or 0) >= 180)
end

local function updateShield(self, rt, shieldType)
    local blocking = playerBlocking()
    if blocking then
        self.protect = true
        if not self._blShield or self._blShield.active == false or
           self._blShield.removeRequested then
            self._blShield = spawnChild(rt, self, shieldType or 0xc3, 1,
                0, 0, 0, 0, 0, "boss blocking shield")
        end
    elseif self._blShield then
        self._blShield._blFade = true
        self.protect = false
    end
end

local function pairedFan(visual, projectileId, self, angle, speed,
                         count, spread, offsetX, offsetY)
    local ox, oy = offsetX or 70, offsetY or 20
    fan(visual, projectileId, self.ldX - ox, self.ldY + oy,
        angle, speed, count, spread)
    fan(visual, projectileId, self.ldX + ox, self.ldY + oy,
        angle, speed, count, spread)
end

-- Stage 8 boss ------------------------------------------------------------

local stage8Transition = {
    [10] = {200, 11, 105000, 2700},
    [20] = {380, 21, 80000, 2400},
    [30] = {200, 31, 40000, 1500},
    [40] = {180, 41, 80000, 2400},
    [50] = {180, 51, 148000, 3300},
    [60] = {300, 61, 150000, 4800},
}

local stage8NextTransition = {
    [1] = 10, [2] = 10, [11] = 20, [21] = 30,
    [31] = 40, [41] = 50, [51] = 60, [52] = 60,
}

local function stage8Move(self, rt, finalSegment)
    bossMove(self, rt, finalSegment and 0.35 or 0.3,
        50, 210, 510, 150, 250, 0x13f0)
end

local function stage8Pattern1(self, rt)
    local t = self.helperTimer
    local cycle = (t - 30) % 1800
    local d = difficulty(rt)
    if cycle <= 640 then
        local interval = diff(rt, {120, 80, 80, 80, 80})
        if cycle % interval == 0 then
            local count = diff(rt, {5, 7, 9, 7, 9})
            local speed = diff(rt, {4, 4.5, 5, 4.5, 5.5}) + cycle * 0.005
            pairedFan(0x0d, 0, self, aim(self), speed, count, 15000, 95, 20)
            pairedFan(2, 0, self, aim(self) + 0x8000, speed + 0.6,
                count, 15000, 95, 20)
            if d >= 3 then
                pairedFan(0x0d, 0, self, aim(self), speed + 1.2,
                    count, 15000, 95, 20)
            end
        end
    elseif cycle >= 740 and cycle < 960 then
        local interval = diff(rt, {150, 100, 100, 100, 100})
        local localTime = (cycle - 740) % interval
        if localTime == 0 then self._blAim = aim(self) end
        if localTime < 30 and localTime % 4 == 0 then
            local speed = diff(rt, {7, 8, 8, 9, 10}) + localTime * 0.04
            pairedFan(7, 0, self, self._blAim, speed,
                d >= 1 and 3 or 1, d >= 1 and 1800 or 0, 100, 25)
        end
    elseif cycle >= 1000 and cycle < 1760 and cycle % 32 == 0 then
        local wave = floor((cycle - 1000) / 32)
        local count = diff(rt, {3, 4, 5, 5, 7})
        local angle = t * 0x91 + sin(wave * pi / 8) * 6000
        ring(9, 1, self.ldX - 85, self.ldY + 15, angle,
            3.2 + wave * 0.05, count)
        ring(9, 1, self.ldX + 85, self.ldY + 15, -angle,
            3.2 + wave * 0.05, count)
    end
end

local function stage8Pattern2(self, rt)
    local t = self.helperTimer
    local interval = diff(rt, {160, 120, 120, 120, 120})
    if t >= 30 and t % interval == 0 then
        local count = diff(rt, {13, 17, 19, 19, 21})
        local childType = floor(t / interval) % 2 == 0 and 0xae or 0xaf
        for i = 0, count - 1 do
            spawnChild(rt, self, childType, 1200, 0, 0, i,
                floor(i * 0x10000 / count), 0, "stage8 orbit emitter")
        end
    end
    if t >= 70 and ((t - 70) % (interval * 2) == 0 or
                    (t - 90) % (interval * 2) == 0) then
        local count = diff(rt, {21, 33, 37, 33, 37})
        local speed = diff(rt, {2.5, 3.2, 4, 3, 4})
        ring(3, 0, self.ldX - 90, self.ldY + 20, t * 73, speed, count)
        ring(5, 0, self.ldX + 90, self.ldY + 20, -t * 73, speed, count)
        if difficulty(rt) > 2 then
            ring(3, 0, self.ldX, self.ldY + 20,
                t * 73 + floor(0x8000 / count), speed + 2, count)
        end
    end
end

local function stage8Pattern11(self, rt)
    local t = self.helperTimer
    if t < 60 then return end
    local cycle = (t - 60) % 1600
    if cycle < 300 then
        local localTime = cycle % 75
        if localTime == 0 then self._blAim = aim(self) end
        if localTime < 30 and localTime % 5 == 0 then
            local count = diff(rt, {3, 3, 3, 5, 7})
            pairedFan(7, 0, self, self._blAim,
                diff(rt, {6, 7, 7.5, 7.5, 8.8}) + localTime * 0.15,
                count, 8000 + localTime * 240, 100, 20)
        end
        if cycle % 30 == 0 then
            ring(3, 1, self.ldX, self.ldY, cycle * 173,
                diff(rt, {3.5, 4.5, 5, 5, 6.4}),
                diff(rt, {3, 5, 7, 7, 7}))
        end
    elseif cycle >= 380 and cycle < 640 and cycle % 36 == 0 then
        local count = diff(rt, {7, 9, 11, 11, 13})
        for layer = 0, diff(rt, {2, 3, 4, 4, 5}) - 1 do
            fan(5, 0, self.ldX, self.ldY + 20, aim(self),
                4.5 + layer * 0.8, count, 0x8000)
        end
    elseif cycle >= 700 and cycle < 960 and cycle % 32 == 0 then
        local count = 3 + floor((cycle - 700) / 64)
        pairedFan(4, 1, self, cycle * 211, 4.8, count,
            min(0xc000, count * 4000), 100, 15)
    elseif cycle == 960 then
        pairedFan(8, 0, self, aim(self), 6.5,
            diff(rt, {9, 13, 17, 19, 23}), 22000, 100, 15)
    elseif cycle >= 1060 and cycle < 1550 and
           cycle % diff(rt, {12, 8, 8, 8, 6}) == 0 then
        local count = diff(rt, {5, 7, 9, 11, 12})
        local spread = 17000 + sin(cycle * pi / 120) * 5000
        fan(3, 1, self.ldX, self.ldY, cycle * 197, 5, count, spread)
        fan(5, 1, self.ldX, self.ldY, cycle * 197 + 0x8000,
            5, count, spread)
    end
end

local function stage8Pattern21(self, rt)
    local t = self.helperTimer
    local cycle = (t - 60) % 1400
    local orbitTypes = {[0] = 0xb2, [180] = 0xb1, [360] = 0xb0, [540] = 0xb3}
    local childType = orbitTypes[cycle]
    if childType then
        local count = diff(rt, {7, 9, 11, 11, 13})
        for i = 0, count - 1 do
            spawnChild(rt, self, childType, 2500, 0, 0, i,
                floor(i * 0x10000 / count), 0, "stage8 ellipse orbit")
        end
    end
    if cycle >= 100 and cycle < 800 and cycle % 12 == 0 then
        local k = (cycle - 100) % 120
        pairedFan(7, 0, self, aim(self), 8.5 - k * 0.025,
            diff(rt, {3, 5, 7, 9, 11}), max(1000, 12000 - k * 70),
            95, 15)
    elseif ((cycle >= 820 and cycle < 860) or
            (cycle >= 970 and cycle < 1010)) and cycle % 4 == 0 then
        pairedFan(0x0d, 0, self, aim(self), 9.5, 3, 1800, 95, 15)
    elseif cycle >= 1100 and cycle % 30 == 0 then
        for layer = 0, 2 do
            pairedFan(3 + layer, 0, self, aim(self), 4.5 + layer * 1.2,
                diff(rt, {5, 7, 9, 11, 13}), 0xa000, 95, 15)
        end
    end
end

local function stage8Pattern41(self, rt)
    local t = self.helperTimer
    local cycle = t % 1600
    if ((cycle >= 40 and cycle <= 80 and cycle % 8 == 0) or
        (cycle >= 390 and cycle <= 430 and cycle % 6 == 0)) then
        spawnChild(rt, self, 0xb6, 4500,
            randomRange(self, rt, cycle, -100, 100), 0, cycle,
            aim(self), 5, "stage8 breakable shot")
        spawnChild(rt, self, 0xb6, 4500,
            randomRange(self, rt, cycle + 1, -100, 100), 0, cycle + 1,
            aim(self) + 0x8000, 5, "stage8 breakable shot")
    elseif cycle >= 700 and cycle < 1050 and cycle % 60 == 0 then
        local count = difficulty(rt) > 2 and 11 or 7
        for i = 0, count - 1 do
            spawnChild(rt, self, 0xb6, 3500, 0, 0, i,
                floor(i * 0x10000 / count), 4, "stage8 radial breakable")
        end
    elseif cycle >= 1140 and cycle < 1500 and
           cycle % diff(rt, {9, 6, 5, 5, 5}) == 0 then
        spawnChild(rt, self, 0xb7, 900, 0, 0, cycle,
            randomInt(self, rt, cycle, 0x1800, 0x6800), 0,
            "stage8 knife emitter")
    end
end

local function stage8FinalPattern(self, rt)
    local state = self.state
    local family = (state == 62 or state == 65) and 0 or
                   ((state == 63 or state == 66) and 1 or 2)
    local intervals = {
        diff(rt, {50, 36, 32, 32, 28}),
        diff(rt, {40, 28, 25, 25, 21}),
        diff(rt, {30, 20, 18, 18, 16}),
    }
    local choices = ({3, 5, 7})[family + 1]
    if self.helperTimer > 100 and self.helperTimer % intervals[family + 1] == 0 then
        local typeId = 0xbc + randomInt(self, rt, self.helperTimer, 0, choices - 1)
        spawnChild(rt, self, typeId, 1800, 0, 0, family,
            randomInt(self, rt, self.helperTimer + 1, 0, 0xffff),
            6 + family * 0.5, "stage8 final family")
    end
end

local function stage8Break(self, rt)
    local timeout = (self.countdown or 0) <= 0
    clearForBreak(self, timeout)
    spawnPostDeathCounter(self, 140)
    self.targetable = false
    self.protect = true
    if self.state >= 62 and self.state <= 67 then
        self.hp = 1
        self.countdown = 1
        setState(self, 70)
        protectPlayer(360)
        return
    end
    local transition = stage8NextTransition[self.state]
    if transition then
        self.hp = 1
        self.countdown = 1
        setState(self, transition)
    end
end

handlers[0x13f] = function(self, rt)
    configureVisual(self, 0, 130)
    battleTelemetry(self, rt)
    if not self._blInit then
        self._blInit = true
        self.targetable = false
        self.protect = true
        self.state = 0
        self.helperTimer = 0
        self._blChildren = {}
        local fixed = {
            {0xa7, -150, 20}, {0xa8, 150, 20},
            {0xab, -130, -55}, {0xab, -55, -80},
            {0xab, 55, -80}, {0xab, 130, -55},
            {0xac, -205, -90}, {0xac, 205, -90},
        }
        for i, v in ipairs(fixed) do
            self._blChildren[#self._blChildren + 1] = spawnChild(rt, self,
                v[1], v[1] == 0xac and 24000 or 9000, v[2], v[3], i,
                0, 0, "stage8 fixed boss part")
        end
    end

    local state, t = self.state, self.helperTimer
    if state == 0 then
        self.targetable = false
        if t >= 120 and t < 720 and t % 24 == 0 then
            local x = randomRange(self, rt, t, 60, 660)
            spawnChild(rt, self, 0xad, 400, x - self.ldX,
                -80 - self.ldY, t, 0x4000, 6, "stage8 boss entry rain")
        end
        if t >= 1200 then setBattle(self, 1, 145000, 3300) end
        return
    end

    local transition = stage8Transition[state]
    if transition then
        self.targetable = false
        self.protect = true
        self.ldY = self.ldY + 0.1
        if t >= transition[1] then
            setBattle(self, transition[2], transition[3], transition[4])
        end
        return
    end

    if state == 70 then
        self.targetable = false
        self.protect = true
        self.ldY = self.ldY + 0.2
        if t >= 480 then
            self.active = false
            Del(self)
            rt.gate = false
            rt.boss = nil
            rt.complete = true
        end
        return
    end

    if state ~= 61 then
        updateShield(self, rt, 0xc3)
        stage8Move(self, rt, state >= 62)
    end
    if state == 1 then
        stage8Pattern1(self, rt)
        if self.hp <= 50000 then setState(self, 2) end
    elseif state == 2 then
        stage8Pattern2(self, rt)
    elseif state == 11 then
        stage8Pattern11(self, rt)
    elseif state == 21 then
        stage8Pattern21(self, rt)
    elseif state == 31 then
        if t == 10 then spawnChild(rt, self, 0xb4, 6000, 0, 0, 0, 0, 0) end
        if t == 100 then spawnChild(rt, self, 0xb5, 6000, 0, 0, 1, 0, 0) end
    elseif state == 41 then
        stage8Pattern41(self, rt)
    elseif state == 51 then
        if t == 60 then spawnChild(rt, self, 0xb8, self.hp, 0, 0, 0, 0, 0) end
        if t >= 210 then setState(self, 52) end
    elseif state == 52 then
        -- The b9/ba/bb assembly owns this phase's fire.
    elseif state == 61 then
        if t >= 120 then setState(self, 62) end
    elseif state >= 62 and state <= 67 then
        stage8FinalPattern(self, rt)
        if (state == 62 or state == 65) and self.hp <= 100000 then
            setState(self, state + 1)
        elseif (state == 63 or state == 66) and
               (self.hp <= 50000 or self.countdown < 1500) then
            setState(self, state + 1)
        end
    end

    local combatActive = state ~= 61
    local timeout = combatActive and tickCountdown(self) or false
    if combatActive and (self.hp <= 0 or timeout) then stage8Break(self, rt) end
end

M.childDeathRewards = {
    [0xab] = {0x708, 24}, [0xac] = {4000, 120},
    [0xae] = {300, 5}, [0xaf] = {300, 5},
    [0xb0] = {300, 5}, [0xb1] = {300, 5},
    [0xb2] = {300, 5}, [0xb3] = {300, 5},
    [0xb6] = {300, 7}, [0xb7] = {200, 5},
    [0xbb] = {4000, 77},
    [0xc4] = {300, 5}, [0xc5] = {300, 5},
}

local function transferChildDamage(self, owner)
    if self.hp > 0 or self._blTransferred then return false end
    self._blTransferred = true
    local reward = M.childDeathRewards[self.spawnType]
    if reward then
        M.spawnEnemyDeathRewardBurstOnce(self, reward[1], reward[2])
    end
    owner.hp = owner.hp - max(1, self.maxhp or 1)
    self.hp = 1
    remove(self)
    return true
end

local function stage8FixedPart(self, rt)
    local owner = parentOf(self)
    if not owner or owner.spawnType ~= 0x13f then remove(self); return end
    configureVisual(self, self.spawnType - 0xa7 + 1, self.spawnType >= 0xab and 35 or 50)
    local t = self.helperTimer
    if self.spawnType == 0xa7 or self.spawnType == 0xa8 then
        follow(self, owner, self._blOffsetX,
            self._blOffsetY + sin((owner.helperTimer + self._blIndex * 30) * pi / 90) * 12, 4)
        if owner.state == 11 and not self._blProxy then
            local proxyType = self.spawnType == 0xa7 and 0xa9 or 0xaa
            self._blProxy = spawnChild(rt, owner, proxyType, owner.hp,
                self._blOffsetX, self._blOffsetY, self._blIndex, 0, 0,
                "stage8 shared hit surface")
        end
        if owner.state >= 20 then remove(self) end
        return
    end

    follow(self, owner, self._blOffsetX, self._blOffsetY, 3)
    if self.spawnType == 0xab then
        self.targetable = owner.state == 1 or owner.state == 2
        if transferChildDamage(self, owner) then return end
        if self.targetable then
            local period = diff(rt, {90, 70, 55, 55, 55})
            local q = (t + self._blIndex * 13) % period
            if q < 24 and q % 4 == 0 then
                fan(7, 0, self.ldX, self.ldY, aim(self),
                    diff(rt, {5.5, 6.5, 7, 7.5, 8.8}),
                    diff(rt, {3, 5, 7, 7, 7}), 7000)
            end
        end
        if owner.state >= 10 then remove(self) end
    else
        self.targetable = owner.state == 1 and owner.hp > 50000
        if transferChildDamage(self, owner) then return end
        if self.targetable then
            local cycle = (owner.helperTimer - 30) % 1800
            if cycle <= 640 and cycle % diff(rt, {120, 80, 80, 80, 80}) == 0 then
                fan(0x0d, 0, self.ldX, self.ldY, aim(self),
                    diff(rt, {4.5, 5, 5.5, 5.5, 6.5}) + cycle * 0.005,
                    diff(rt, {5, 7, 9, 9, 11}), 16000)
            elseif cycle >= 680 and cycle < 960 and cycle % 32 == 0 then
                ring(8, 1, self.ldX, self.ldY, cycle * 113,
                    3.5 + (cycle - 680) * 0.005,
                    diff(rt, {7, 9, 11, 13, 15}))
            elseif cycle >= 1000 and cycle < 1740 and cycle % 20 == 0 then
                fan(2, 9, self.ldX, self.ldY, aim(self) + 0x8000,
                    5.5, diff(rt, {3, 5, 7, 7, 9}), 12000)
            end
        end
        if owner.state ~= 1 or owner.hp <= 50000 then remove(self) end
    end
end

handlers[0xa7] = stage8FixedPart
handlers[0xa8] = stage8FixedPart
handlers[0xab] = stage8FixedPart
handlers[0xac] = stage8FixedPart

local function sharedHitSurface(self, rt)
    local owner = parentOf(self)
    if not owner then remove(self); return end
    configureVisual(self, self.spawnType - 0xa9 + 4, 36)
    follow(self, owner, self._blOffsetX, self._blOffsetY, 2)
    self.targetable = owner.targetable and not owner.protect
    local shared = min(self.hp, owner.hp)
    self.hp, owner.hp = shared, shared
    if owner.state >= 20 or shared <= 0 then remove(self) end
end

handlers[0xa9] = sharedHitSurface
handlers[0xaa] = sharedHitSurface

local function stage8OrbitEmitter(self, rt)
    local owner = parentOf(self)
    if not owner then remove(self); return end
    configureVisual(self, self.spawnType - 0xae + 8, 20)
    self.targetable = true
    if transferChildDamage(self, owner) then return end
    local t = self.helperTimer
    local sign = self.spawnType == 0xae and 1 or -1
    local radius
    if t < 30 then radius = sin(t * pi / 60) * 200
    else radius = 200 + (t - 30) * (t - 30) * 0.006 end
    self.angle16 = Core.angle16((self.angle16 or 0) + sign * (0x120 + t * 3))
    local dx, dy = Core.ellipse(self.angle16, radius, radius * 0.55,
        sign * 0x900)
    self.ldX, self.ldY = owner.ldX + dx, owner.ldY + dy
    if t > 60 and t % diff(rt, {17, 11, 9, 10, 9}) == 0 then
        local tangent = self.angle16 + sign * 0x4000
        local speed = diff(rt, {5, 6, 6.5, 7, 8})
        fire(7, 2, self.ldX, self.ldY, tangent, speed)
        fire(7, 2, self.ldX, self.ldY, tangent + 0x8000, speed)
        if difficulty(rt) > 2 then
            fire(7, 2, self.ldX, self.ldY, tangent, speed + 2)
        end
    end
    if t > 260 or not Core.inside(self.ldX, self.ldY, 220) then remove(self) end
end

handlers[0xae] = stage8OrbitEmitter
handlers[0xaf] = stage8OrbitEmitter

local function stage8EllipseNode(self, rt)
    local owner = parentOf(self)
    if not owner then remove(self); return end
    configureVisual(self, self.spawnType - 0xb0 + 10, 24)
    self.targetable = true
    if transferChildDamage(self, owner) then return end
    local t = self.helperTimer
    local sign = (self.spawnType == 0xb0 or self.spawnType == 0xb2) and 1 or -1
    local radius = sin(min(t, 30) * pi / 60) * 200
    local orbit = Core.angle16((self.angle16 or 0) + sign * t * 0x120)
    local tilt = sign * 0x1300
    local dx, dy = Core.ellipse(orbit, radius, radius * 0.55, tilt)
    self.ldX, self.ldY = owner.ldX + dx, owner.ldY + dy
    if self.spawnType <= 0xb1 then
        if t >= 30 and t % diff(rt, {20, 11, 9, 7, 6}) == 0 then
            fire(1, 0, self.ldX, self.ldY, orbit + 0x3000, 5)
            fire(1, 0, self.ldX, self.ldY, orbit - 0x3000, 5)
        end
    elseif t >= 30 and t % diff(rt, {18, 11, 10, 11, 10}) < 3 then
        fire(1, 0, self.ldX, self.ldY, aim(self), 6)
    end
    if t % 72 == 0 then fire(1, 0, self.ldX, self.ldY, orbit + 0x8000, 4.5) end
    if t >= 250 then remove(self) end
end

handlers[0xb0] = stage8EllipseNode
handlers[0xb1] = stage8EllipseNode
handlers[0xb2] = stage8EllipseNode
handlers[0xb3] = stage8EllipseNode

local function stage8DenseOrbit(self, rt)
    local owner = parentOf(self)
    if not owner then remove(self); return end
    configureVisual(self, self.spawnType - 0xb4 + 14, 28)
    self.targetable = false
    local t = self.helperTimer
    local sign = self.spawnType == 0xb4 and 1 or -1
    local scale = sin(min(t, 120) * pi / 240)
    local orbit = Core.angle16((self.angle16 or 0) + sign * t * 0x160)
    local tilt = Core.angle16(sign * t * 0x83)
    local dx, dy = Core.ellipse(orbit, 150 * scale, 75 * scale, tilt)
    self.ldX, self.ldY = owner.ldX + dx, owner.ldY + dy
    local cadence = diff(rt, {3, 2, 1, 1, 1})
    if t >= 50 and t % cadence == 0 then
        local step = diff(rt, {0xce4, 0x8fc, 0x834, 0x834, 0x834})
        fire(8, 1, self.ldX, self.ldY, sign * t * step, 0)
    end
    if owner.state ~= 31 then remove(self) end
end

handlers[0xb4] = stage8DenseOrbit
handlers[0xb5] = stage8DenseOrbit

handlers[0xb6] = function(self, rt)
    local owner = parentOf(self)
    if not owner then remove(self); return end
    configureVisual(self, 18, 24)
    self.targetable = true
    if transferChildDamage(self, owner) then return end
    local t = self.helperTimer
    if t < 60 then self.speed = max(0.5, self.speed - 0.07) end
    move(self)
    local cycle = t % 350
    if cycle < 80 and cycle % 10 == 0 then
        fan(7, 0, self.ldX, self.ldY, aim(self),
            diff(rt, {5.5, 6.5, 7, 8, 9.5}),
            diff(rt, {3, 5, 7, 9, 11}), 9000)
    end
    if t == 200 then
        ring(5, 0, self.ldX, self.ldY, self.angle16,
            diff(rt, {4, 5, 5.5, 6, 7}),
            diff(rt, {13, 17, 21, 25, 29}))
        remove(self)
    end
end

handlers[0xb7] = function(self, rt)
    local owner = parentOf(self)
    if not owner then remove(self); return end
    configureVisual(self, 19, 18)
    self.targetable = true
    if transferChildDamage(self, owner) then return end
    local t = self.helperTimer
    if t >= 50 then self.speed = self.speed + 0.1 end
    move(self, self.angle16, t < 50 and 0 or 8 + (t - 50) * 0.1)
    if t < 40 and t % diff(rt, {22, 15, 9, 7, 6}) == 0 then
        local a = floor((aim(self) + 0x400) / 0x800) * 0x800
        fire(0, 0, self.ldX, self.ldY, a, diff(rt, {6, 7, 8, 9, 10}))
        if difficulty(rt) > 2 then
            fire(0, 0, self.ldX, self.ldY, a - 0x15ae, 7)
            fire(0, 0, self.ldX, self.ldY, a + 0x15ae, 7)
        end
    end
    if t > 100 or not Core.inside(self.ldX, self.ldY, 180) then remove(self) end
end

handlers[0xb8] = function(self, rt)
    local owner = parentOf(self)
    if not owner then remove(self); return end
    configureVisual(self, 20, 80)
    local t = self.helperTimer
    if owner.state >= 60 then
        if self.state ~= 9 then setState(self, 9); return end
        self.targetable = false
        if self.helperTimer >= 120 then remove(self) end
        return
    end
    local enter = t < 30 and sin((t + 30) * pi / 60) * 600 or 0
    follow(self, owner, 0, 35 + enter, 1)
    self.targetable = false
    if self.state == 0 and t == 20 then
        spawnChild(rt, self, 0xb9, owner.hp, 0, 30, 0, 0, 0)
    elseif self.state == 0 and t == 50 then
        spawnChild(rt, self, 0xba, owner.hp, -150, 15, 0, 0, 0)
        spawnChild(rt, self, 0xba, owner.hp, 150, 15, 1, 0, 0)
    end
    if owner.state == 52 and self.state == 0 then setState(self, 1); return end
    if owner.state ~= 51 and owner.state ~= 52 then remove(self) end
end

local function stage8Assembly(self, rt)
    local assembly = parentOf(self)
    local owner = assembly and parentOf(assembly)
    if not assembly or not owner then remove(self); return end
    configureVisual(self, self.spawnType - 0xb9 + 21, self.spawnType == 0xb9 and 70 or 45)
    local timer = self.helperTimer
    if owner.state >= 60 then
        if self.state ~= 9 then setState(self, 9); return end
        self.targetable = false
        local endTimer = self.spawnType == 0xb9 and 60 or
            ((self._blOffsetX or 0) < 0 and 100 or 80)
        if self.helperTimer >= endTimer then remove(self) end
        return
    end
    local enter = timer < 30 and sin((timer + 30) * pi / 60) * 600 or 0
    if self.spawnType == 0xb9 then
        follow(self, assembly, self._blOffsetX,
            (self._blOffsetY or 0) - enter, 1)
    else
        local signed = (self._blOffsetX or 0) < 0 and -enter or enter
        follow(self, assembly, (self._blOffsetX or 0) + signed,
            self._blOffsetY, 1)
    end
    if owner.state == 52 and self.state == 0 then setState(self, 1); return end
    self.targetable = owner.state == 52
    if self.targetable then
        local shared = min(self.hp, owner.hp)
        self.hp, owner.hp = shared, shared
    end
    local t = owner.helperTimer
    if owner.state == 52 and self.spawnType == 0xb9 then
        if owner.state == 52 and not self._blProxy then
            self._blProxy = true
            spawnChild(rt, self, 0x152, self.hp, -55, 0, 0, 0, 0)
            spawnChild(rt, self, 0x152, self.hp, 55, 0, 1, 0, 0)
        end
        local cycle = t % 1800
        if cycle < 550 and cycle % 12 == 0 then
            pairedFan(7, 0, self, cycle * 193, 6.5,
                diff(rt, {3, 5, 7, 9, 11}), 9000, 55, 0)
        elseif cycle >= 720 and cycle < 1250 and cycle % 18 == 0 then
            for offset = -1, 1 do
                fire(8, 0, self.ldX, self.ldY, aim(self) + offset * 1400,
                    7.5 + abs(offset))
            end
        elseif cycle >= 1300 and cycle < 1740 and cycle % 8 == 0 then
            ring(3, 1, self.ldX - 45, self.ldY, cycle * 131, 4.5,
                diff(rt, {7, 9, 11, 13, 15}))
            ring(5, 1, self.ldX + 45, self.ldY, -cycle * 131, 4.5,
                diff(rt, {7, 9, 11, 13, 15}))
        end
    elseif owner.state == 52 then
        if owner.state == 52 and not self._blGun then
            self._blGun = spawnChild(rt, self, 0xbb, self.hp,
                self._blIndex == 0 and -170 or 170, 0, self._blIndex, 0, 0)
        end
        local cycle = t % 1800
        if cycle >= 600 and cycle < 1250 and cycle % 14 == 0 then
            fan(self._blIndex == 0 and 3 or 5, 1, self.ldX, self.ldY,
                (self._blIndex == 0 and 1 or -1) * cycle * 171,
                5.5, diff(rt, {3, 5, 7, 9, 11}), 12000)
        elseif cycle >= 1300 and cycle < 1740 and cycle % 30 == 0 then
            ring(self._blIndex == 0 and 3 or 5, 0, self.ldX, self.ldY,
                cycle * 101, 4.5, diff(rt, {13, 17, 21, 25, 29}))
        end
    end
    if owner.state ~= 51 and owner.state ~= 52 then remove(self) end
end

handlers[0xb9] = stage8Assembly
handlers[0xba] = stage8Assembly

handlers[0xbb] = function(self, rt)
    local wing = parentOf(self)
    local assembly = wing and parentOf(wing)
    local owner = assembly and parentOf(assembly)
    if not wing or not owner then remove(self); return end
    configureVisual(self, 24, 30)
    follow(self, wing, self._blOffsetX, 0, 4)
    self.targetable = owner.state == 52
    if owner.state == 52 and transferChildDamage(self, owner) then return end
    local q = self.helperTimer % 300
    if q == 0 then self._blAim = aim(self) end
    if q >= 100 and q < 300 and q % 3 == 0 then
        local spread = min(16000, (q - 100) * 80)
        fan(7, 0, self.ldX, self.ldY, self._blAim,
            5 + (q - 100) * 0.025, 4, spread)
    end
    if owner.state ~= 52 then remove(self) end
end

local function stage8FinalChild(self, rt)
    local owner = parentOf(self)
    if not owner then remove(self); return end
    configureVisual(self, self.spawnType - 0xbc + 23, 20)
    self.targetable = false
    local t = self.helperTimer
    if t < 60 then
        self.speed = max(0.5, self.speed - 0.09)
        self.angle16 = Core.turn16(self.angle16, aim(self), 0x100)
    else
        self.speed = 0.5
    end
    move(self)
    local family = self._blIndex or 0
    local bonus = family * 0.5
    local kind = self.spawnType - 0xbc
    if kind == 0 and t >= 5 and t <= 50 and t % 8 == 0 then
        fan(7, 0, self.ldX, self.ldY, aim(self), 6 + bonus,
            2 + floor(t / 10), min(16000, t * 260))
    elseif kind == 1 and t == 5 then
        ring(5, 0, self.ldX, self.ldY, self.angle16, 5 + bonus,
            diff(rt, {13, 17, 21, 25, 29}))
    elseif kind == 2 and t >= 5 and t <= 30 and t % 4 == 0 then
        fan(0x0d, 0, self.ldX, self.ldY, aim(self), 8 + bonus, 3, 1800)
    elseif kind == 3 and t == 5 then
        for offset = -1, 1 do
            fan(3, 0, self.ldX, self.ldY, aim(self) + offset * 0x3000,
                5.5 + bonus, 5, 6000)
        end
    elseif kind == 4 and t >= 5 and t <= 60 and t % 5 == 0 then
        fire(4, 0, self.ldX, self.ldY, aim(self) - 1000, 5 + t * 0.08 + bonus)
        fire(4, 0, self.ldX, self.ldY, aim(self) + 1000, 5 + t * 0.08 + bonus)
    elseif kind == 5 and t >= 5 and t <= 80 and t % 8 == 0 then
        local count = 3 + floor(t / 16)
        fan(7, 0, self.ldX, self.ldY,
            floor((aim(self) + 0x400) / 0x800) * 0x800,
            6 + bonus, count, count * 1200)
    elseif kind == 6 and t == 5 then
        fan(9, 9, self.ldX, self.ldY, aim(self), 5.5 + bonus,
            diff(rt, {17, 21, 25, 29, 33}), 0x8000)
    end
    local lifetime = ({50, 20, 40, 30, 70, 90, 30})[kind + 1]
    if t >= lifetime + 40 then remove(self) end
end

for typeId = 0xbc, 0xc2 do handlers[typeId] = stage8FinalChild end

handlers[0xc3] = function(self, rt)
    local owner = parentOf(self)
    if not owner then remove(self); return end
    configureVisual(self, 29, 180)
    follow(self, owner, 0, 0, 2)
    self.targetable = false
    self.protect = true
    if self._blFade or not playerBlocking() then
        self._blFadeTimer = (self._blFadeTimer or 0) + 1
        if self._blFadeTimer >= 16 then
            owner.protect = false
            remove(self)
        end
    else
        owner.protect = true
    end
end

local function sharedProxy(self, rt)
    local owner = parentOf(self)
    if not owner then remove(self); return end
    self.radius = self.radius or 80
    self.targetable = owner.targetable and not owner.protect
    follow(self, owner, self._blOffsetX, self._blOffsetY, 1)
    local shared = min(self.hp, owner.hp)
    self.hp, owner.hp = shared, shared
    if shared <= 0 then remove(self) end
end

handlers[0x151] = sharedProxy
handlers[0x152] = sharedProxy

handlers[0x153] = function(self, rt)
    local owner = parentOf(self)
    if not owner then remove(self); return end
    self.targetable = false
    local remaining = self._blDamageRemaining or self.maxhp or 30
    local damage = min(remaining, max(1, floor((self.maxhp or remaining) / 30)))
    owner.hp = owner.hp - damage
    self._blDamageRemaining = remaining - damage
    if self._blDamageRemaining <= 0 then remove(self) end
end

-- Stage 9 midbosses -------------------------------------------------------

local midbossConfig = {
    [0x146] = {240, 85000, 1800, 0.3, 160},
    [0x147] = {210, 66000, 1500, 0.3, 220},
    [0x148] = {180, 64000, 1800, 4.5, 150},
    [0x149] = {240, 70000, 1800, 0.3, 200},
    [0x14a] = {140, 64000, 1500, 0.3, 175},
    [0x14b] = {150, 80000, 1800, 1.6, 175},
}

local function midbossIndex(typeId)
    return typeId - 0x146 + 1
end

local function midbossEnterMotion(self)
    local t = self.helperTimer
    local typeId = self.spawnType
    local x, y = self.originX, self.originY
    if typeId == 0x146 then
        local q = min(t, 180) / 180
        self.ldX = x + sin(q * tau) * (1 - q) * 600
        self.ldY = 600 + (y - 600) * sin(q * pi * 0.5)
    elseif typeId == 0x147 then
        local q = min(t, 180) / 180
        self.ldX = x
        self.ldY = 1100 + (y - 1100) * sin(q * pi * 0.5)
    elseif typeId == 0x148 then
        if t <= 60 then
            local q = t / 60
            self.ldY = y - 400 + sin(q * pi * 0.5) * 600
        else
            local q = min(1, (t - 60) / 120)
            self.ldY = y + 200 - sin(q * pi * 0.5) * 200
        end
    elseif typeId == 0x149 then
        local q = min(t, 240) / 240
        self.ldY = y + 500 * (1 - sin(q * pi * 0.5))
    elseif typeId == 0x14a then
        local q = min(t, 120) / 120
        self.ldY = 1500 + (y - 1500) * sin(q * pi * 0.5)
    else
        local q = min(t, 150) / 150
        self.ldX = x + sin(q * tau * 1.5) * (1 - q) * 260
        self.ldY = 1000 + (y - 1000) * sin(q * pi * 0.5)
    end
end

local function midbossPattern146(self, rt)
    local t = self.helperTimer
    local cycle = (t - 30) % 1100
    if cycle < 500 then
        local interval = diff(rt, {140, 120, 110, 102, 102})
        if cycle % interval == 0 then
            local nodeCount = diff(rt, {7, 9, 11, 11, 13})
            local childType = floor(cycle / interval) % 2 == 0 and 0xc4 or 0xc5
            for i = 0, nodeCount - 1 do
                spawnChild(rt, self, childType, 2600, 0, 0, i,
                    floor(i * 0x10000 / nodeCount), 1.5,
                    "stage9 first midboss spiral")
            end
            ring(2, 0, self.ldX, self.ldY, cycle * 113,
                diff(rt, {2.5, 3, 3.5, 4, 5}),
                diff(rt, {15, 19, 23, 25, 30}))
        end
    elseif cycle >= 580 and cycle < 1060 then
        if cycle % diff(rt, {45, 35, 35, 35, 35}) == 0 then
            pairedFan(3, 0, self, aim(self) + sin(cycle * pi / 120) * 5000,
                diff(rt, {3.2, 4, 5, 5, 6.4}),
                diff(rt, {6, 8, 10, 10, 10}), 15000, 75, 15)
        end
        if cycle % diff(rt, {14, 9, 9, 8, 7}) == 0 then
            pairedFan(0x0d, 0, self, aim(self),
                diff(rt, {4.5, 5.5, 6, 7, 8.8}),
                diff(rt, {3, 5, 6, 7, 8}), 6000, 75, 15)
        end
        if cycle >= 700 and cycle % diff(rt, {80, 60, 50, 40, 32}) == 0 then
            local a = aim(self)
            for layer = 0, 2 do fire(7, 0, self.ldX, self.ldY, a, 5 + layer * 1.3) end
        end
    end
end

local function midbossPattern148(self, rt)
    local t = self.helperTimer
    local cycle = t % 1200
    if cycle >= 30 and cycle < 360 and
       cycle % diff(rt, {8, 6, 6, 6, 6}) == 0 then
        local count = diff(rt, {2, 3, 4, 5, 6})
        local speed = diff(rt, {4.4, 5.5, 6.5, 7, 8.5}) + cycle * 0.004
        ring(3, 1, self.ldX, self.ldY, cycle * 251, speed, count)
        ring(5, 1, self.ldX, self.ldY, -cycle * 251, speed, count)
    elseif cycle >= 450 and cycle < 770 and
           cycle % diff(rt, {100, 90, 80, 80, 80}) == 0 then
        local fanCount = diff(rt, {6, 8, 10, 12, 14})
        for i = 0, fanCount - 1 do
            fan(7, 0, self.ldX, self.ldY, aim(self),
                9 - i * 0.32, 3, 2600 + i * 300)
        end
        for layer = 0, diff(rt, {2, 2, 3, 4, 5}) - 1 do
            fan(8, 0, self.ldX, self.ldY, aim(self),
                5 + layer * 0.8, 7, 5000)
        end
    end
end

local function midbossPattern149(self, rt)
    local t = self.helperTimer
    if t >= 64 and t % diff(rt, {200, 160, 160, 160, 160}) == 0 then
        local layers = diff(rt, {12, 15, 18, 18, 20})
        local top = diff(rt, {4.5, 5.5, 6, 6.5, 7.7})
        for i = 0, layers - 1 do
            local speed = top - i * top / layers * 0.7
            local spread = floor(i * 0x10000 / max(1, layers - 1))
            fan(3, 0, self.ldX, self.ldY, aim(self), speed, 2, spread)
            if difficulty(rt) > 2 and i < layers - 1 then
                fan(5, 0, self.ldX, self.ldY, aim(self),
                    speed - top / layers * 0.35, 2, spread + 800)
            end
        end
    end
    if t >= 1200 then setState(self, 1) end
end

local stage9ShipMuzzles = {
    {-90, -45}, {90, -45}, {-150, 0}, {-55, 45}, {55, 45}, {150, 0},
}

local function midbossPattern14a(self, rt)
    local t = self.helperTimer
    local cycle = t % 1100
    for i, muzzle in ipairs(stage9ShipMuzzles) do
        local x, y = self.ldX + muzzle[1], self.ldY + muzzle[2]
        if cycle < 400 then
            if i <= 2 then
                local cadence = diff(rt, {160, 120, 80, 60, 50})
                if (cycle + (i - 1) * floor(cadence / 2)) % cadence == 0 then
                    ring(3 + i, 0, x, y, cycle * 97,
                        diff(rt, {2.5, 3, 3.5, 4, 5.5}),
                        diff(rt, {15, 21, 27, 30, 33}))
                end
            elseif (cycle + i * 17) % diff(rt, {120, 90, 60, 40, 36}) == 0 then
                fire(0x0d, 0x0e, x, y, aim(self, x, y), 5.5)
            end
        elseif cycle >= 560 and cycle < 600 and i <= 2 and cycle % 4 == 0 then
            self.secondaryAngle16 = Core.turn16(self.secondaryAngle16,
                aim(self, x, y), 0x80)
            ring(7, 0, x, y, self.secondaryAngle16,
                8, diff(rt, {13, 17, 21, 25, 29}))
        elseif cycle >= 630 and cycle < 1070 and
               cycle % diff(rt, {12, 7, 6, 6, 5}) == 0 then
            local visual = i <= 2 and 3 or 5
            local spin = (i % 2 == 0 and -1 or 1) * cycle * 173
            fire(visual, 1, x, y, spin, 4.5 + (cycle - 630) * 0.01)
            fire(visual, 1, x, y, spin + 0x8000, 4.5 + (cycle - 630) * 0.01)
            if difficulty(rt) > 2 then fire(visual, 1, x, y, spin, 3.5) end
        end
    end
end

local function midbossDefeat(self, rt, timeout)
    clearForBreak(self, timeout)
    spawnPostDeathCounter(self, 140)
    rt.stage09BossDefeatFrames = rt.stage09BossDefeatFrames or
        {-1, -1, -1, -1, -1, -1}
    rt.stage09BossDefeatFrames[midbossIndex(self.spawnType)] = rt.frame
    self.targetable = false
    self.protect = true
    self.hp = 1
    self.countdown = 1
    setState(self, 2)
end

local function updateStage9Midboss(self, rt)
    local config = midbossConfig[self.spawnType]
    configureVisual(self, (self.spawnType - 0x146) * 4 + 2, config[5])
    battleTelemetry(self, rt)
    if not self._blInit then
        self._blInit = true
        self.state = 0
        self.helperTimer = 0
        self.targetable = false
        self.protect = true
        self._blStartX, self._blStartY = self.ldX, self.ldY
        if self.spawnType == 0x148 then
            spawnChild(rt, self, 0xc7, 8000, -100, -100, 0, 0, 0)
            spawnChild(rt, self, 0xc7, 8000, 100, -100, 1, 0, 0)
        elseif self.spawnType == 0x14b then
            spawnChild(rt, self, 0xc9, 9000, -75, 0, 0, 0, 0)
            spawnChild(rt, self, 0xca, 9000, 75, 0, 1, 0, 0)
        end
    end

    local t = self.helperTimer
    if self.state == 0 then
        midbossEnterMotion(self)
        if self.spawnType == 0x147 and t == 120 then
            local offsets = {{-70, -50}, {70, -50}, {-140, -110}, {140, -110}}
            for i, v in ipairs(offsets) do
                spawnChild(rt, self, 0xc6, 5000, v[1], v[2], i - 1, 0, 0)
            end
        elseif self.spawnType == 0x149 and t == 180 then
            for i = 0, 5 do
                local a = floor(i * 0x10000 / 6)
                local dx, dy = Core.polar(a, 110)
                spawnChild(rt, self, 0xc8, 8000, dx, dy, i, a, 0)
            end
        end
        if t >= config[1] then
            self.speed = config[4]
            self._blTurn = self.spawnType == 0x148 and 0x309 or 0x200
            setBattle(self, 1, config[2], config[3])
        end
        return
    elseif self.state == 2 then
        self.targetable = false
        self.protect = true
        if t < 90 then self.ldY = self.ldY + t * 0.002 end
        if t >= 150 then
            self.active = false
            Del(self)
            rt.gate = false
            if rt.boss == self then rt.boss = nil end
        end
        return
    end

    updateShield(self, rt, 0xc3)
    bossMove(self, rt, self.speed, 50, 190, 530, 140, 280,
        self.spawnType * 17)
    if self.spawnType == 0x146 then
        midbossPattern146(self, rt)
    elseif self.spawnType == 0x147 then
        -- Its four c6 mounts perform the complete attack.
    elseif self.spawnType == 0x148 then
        midbossPattern148(self, rt)
    elseif self.spawnType == 0x149 then
        midbossPattern149(self, rt)
    elseif self.spawnType == 0x14a then
        midbossPattern14a(self, rt)
    else
        self._blMountAngle = Core.angle16((self._blMountAngle or 0) + 0x180)
        self.targetAngle16 = self._blMountAngle
        self.secondaryAngle16 = Core.turn16(self.secondaryAngle16,
            aim(self), 0x40)
    end

    local timeout = tickCountdown(self)
    if self.hp <= 0 or timeout then midbossDefeat(self, rt, timeout) end
end

for typeId = 0x146, 0x14b do handlers[typeId] = updateStage9Midboss end

local function stage9SpiralNode(self, rt)
    local owner = parentOf(self)
    if not owner or owner.state ~= 1 then remove(self); return end
    configureVisual(self, self.spawnType - 0xc4 + 5, 22)
    self.targetable = true
    if transferChildDamage(self, owner) then return end
    local t = self.helperTimer
    local sign = self.spawnType == 0xc4 and 1 or -1
    self.angle16 = Core.angle16(self.angle16 + sign * (0x160 + t * 5))
    local radius = t * (1.2 + t * 0.012)
    local dx, dy = Core.polar(self.angle16, radius)
    self.ldX, self.ldY = owner.ldX + dx, owner.ldY + dy
    if t >= 30 then
        local cadence = diff(rt, {26, 22, 20, 20, 20})
        local window = diff(rt, {6, 8, 10, 10, 12})
        local q = (t - 30) % cadence
        if q < window and q % 2 == 0 then
            local speed = diff(rt, {5, 6, 6.4, 7.2, 8.5})
            fire(7, 0, self.ldX, self.ldY, aim(self), speed)
            if difficulty(rt) > 2 then fire(7, 0, self.ldX, self.ldY, aim(self), speed + 2) end
        end
    end
    if not Core.inside(self.ldX, self.ldY, 200) then remove(self) end
end

handlers[0xc4] = stage9SpiralNode
handlers[0xc5] = stage9SpiralNode

handlers[0xc6] = function(self, rt)
    local owner = parentOf(self)
    if not owner or owner.state == 2 then remove(self); return end
    configureVisual(self, 11, 30)
    follow(self, owner, self._blOffsetX, self._blOffsetY, 5)
    self.targetable = false
    if owner.state ~= 1 or self.helperTimer < 110 then return end
    local cycle = (self.helperTimer - 110) % 1000
    local index = self._blIndex or 0
    if index < 2 and cycle < 460 then
        local interval = diff(rt, {120, 80, 70, 60, 60})
        local q = (cycle + index * floor(interval / 2)) % interval
        if q == 0 then self._blAim = aim(self) end
        if q < 24 and q % 3 == 0 then
            local speed = diff(rt, {6.4, 8, 8.5, 9.5, 11.1})
            fire(7, 0, self.ldX, self.ldY, self._blAim, speed)
            fan(7, 0, self.ldX, self.ldY, self._blAim, speed - 0.6, 2, 1800)
        end
    elseif index >= 2 and cycle < 400 and
           cycle % diff(rt, {60, 48, 36, 25, 25}) == 0 then
        for layer = 0, 4 do
            ring(5, 0, self.ldX, self.ldY, cycle * 131 + layer * 700,
                diff(rt, {3.2, 4, 4.5, 5, 6.4}) + layer * 0.35,
                diff(rt, {9, 9, 11, 11, 13}))
        end
    end
    if cycle >= 500 and cycle < 900 then
        if cycle % diff(rt, {8, 5, 4, 3, 2}) == 0 then
            fire(0x0d, 8, self.ldX, self.ldY,
                randomInt(self, rt, cycle + index, 0, 0xffff),
                randomRange(self, rt, cycle + index + 1, 3, 7))
        end
        local q = cycle % diff(rt, {120, 100, 80, 60, 50})
        if q < 40 and q % 5 == 0 then
            fire(0x0c, 9, self.ldX, self.ldY, aim(self), 6 + q * 0.05)
        end
    end
end

handlers[0xc7] = function(self, rt)
    local owner = parentOf(self)
    if not owner or owner.state == 2 then remove(self); return end
    configureVisual(self, 12, 35)
    follow(self, owner, self._blOffsetX, self._blOffsetY, 4)
    self.targetable = false
    self.angle16 = Core.turn16(self.angle16, aim(self), 0x80)
    if owner.state ~= 1 then return end
    local cycle = owner.helperTimer % 1200
    if cycle < 360 then
        local interval = diff(rt, {70, 48, 36, 36, 36})
        if (cycle + (self._blIndex or 0) * floor(interval / 2)) % interval == 0 then
            fan(7, 0, self.ldX, self.ldY, self.angle16,
                diff(rt, {5.5, 6.5, 7, 8, 9}),
                diff(rt, {9, 13, 15, 15, 17}), 27000)
        end
    elseif cycle >= 770 and cycle < 1120 and
           cycle % diff(rt, {12, 9, 8, 7, 5}) == 0 then
        local a = self.angle16 + randomInt(self, rt, cycle, -1800, 1800)
        fan(8, 0, self.ldX, self.ldY, a, 7.5, 3, 2200)
    end
end

handlers[0xc8] = function(self, rt)
    local owner = parentOf(self)
    if not owner then remove(self); return end
    configureVisual(self, 13, 30)
    local t = self.helperTimer
    if self.state == -1 then
        self.targetable = false
        if owner.state == 1 and t >= 200 then
            self.hp = self.maxhp
            self._blDeathRewardBurst = false
            self._ldRewardSpawned = false
            setState(self, 1)
        elseif owner.state ~= 1 and t >= 80 then remove(self) end
        return
    end
    if self.hp <= 0 then
        M.spawnEnemyDeathRewardBurstOnce(self,2000,0)
        owner.hp = owner.hp - max(1, self.maxhp or 1)
        self.hp = 1
        setState(self, -1)
        return
    end
    self.targetable = owner.state == 1
    local index = self._blIndex or 0
    local orbit = Core.angle16(index * floor(0x10000 / 6) + owner.helperTimer * 0x80)
    local ox, oy = Core.ellipse(orbit, 110, 70, 0x900)
    if self.state == 0 and t >= 60 then setState(self, 1); return end
    if self.state == 1 then
        follow(self, owner, ox, oy, 4)
        local T = owner.helperTimer
        if T == index * 15 + 10 or T == index * 20 + 330 or
           T == 680 or T == 950 then
            self._blDashTargetX, self._blDashTargetY = playerPosition()
            setState(self, 2)
        end
    elseif self.state == 2 then
        if t < 50 then
            self.angle16 = Core.aim16(self.ldX, self.ldY,
                self._blDashTargetX, self._blDashTargetY)
        elseif t == 90 then
            self.speed = 10
        elseif t > 90 then
            move(self)
            self.speed = self.speed + 0.2
            if Core.inside(self.ldX, self.ldY, 0) and t % 4 == 0 then
                fire(index % 2 == 0 and 3 or 5, 0, self.ldX, self.ldY,
                    self.angle16 + 0x8000, 4.5)
            end
            if not Core.inside(self.ldX, self.ldY, -20) then
                local count = diff(rt, {12, 24, 32, 20, 24})
                ring(5, 0, self.ldX, self.ldY, self.angle16,
                    diff(rt, {3.5, 4.5, 5, 5.5, 6.6}), count)
                if difficulty(rt) > 2 then
                    ring(3, 0, self.ldX, self.ldY,
                        self.angle16 + floor(0x8000 / count), 7, count * 2)
                end
                setState(self, 3)
            end
        end
    else
        follow(self, owner, ox, oy, 8)
        if t >= 90 then setState(self, 1) end
    end
end

local function stage9LastMount(self, rt)
    local owner = parentOf(self)
    if not owner or owner.state == 2 then remove(self); return end
    configureVisual(self, self.spawnType - 0xc9 + 14, 36)
    local sign = self.spawnType == 0xc9 and -1 or 1
    local orbit = Core.angle16((owner._blMountAngle or 0) +
        (self.spawnType == 0xc9 and 0x8000 or 0))
    local dx, dy = Core.polar(orbit, 75)
    follow(self, owner, dx, dy, 3)
    self.targetable = false
    if self.spawnType == 0xca then
        local a = aim(self)
        local ex, ey = Core.polar(a, 24)
        self.ldX, self.ldY = self.ldX + ex, self.ldY + ey
    end
    if owner.state == 1 and owner.helperTimer == 10 and not self._blEmitter then
        self._blEmitter = spawnChild(rt, self,
            self.spawnType == 0xc9 and 0xcb or 0xcc, 1,
            sign * 20, 0, self._blIndex, 0, 0)
    end
end

handlers[0xc9] = stage9LastMount
handlers[0xca] = stage9LastMount

local function stage9LastEmitter(self, rt)
    local mount = parentOf(self)
    local owner = mount and parentOf(mount)
    if not mount or not owner or owner.state ~= 1 then remove(self); return end
    configureVisual(self, self.spawnType - 0xcb + 16, 24)
    follow(self, mount, self._blOffsetX, self._blOffsetY, 2)
    self.targetable = false
    local t = self.helperTimer
    local cycle = t % 1300
    local side = self.spawnType == 0xcb and -1 or 1
    if cycle < 540 then
        local cadence = diff(rt, {40, 34, 30, 30, 30})
        local q = (cycle + (side > 0 and floor(cadence / 2) or 0)) % cadence
        if q < 20 and q % 5 == 0 then
            ring(side < 0 and 3 or 5, 1, self.ldX, self.ldY,
                side * cycle * 193, diff(rt, {7, 8.9, 8.5, 9, 10}),
                diff(rt, {11, 17, 19, 19, 23}))
        end
    elseif cycle == 640 then
        ring(8, side < 0 and 0x29 or 0x2a, self.ldX, self.ldY,
            side * cycle * 97, 3, diff(rt, {9, 11, 13, 15, 17}))
    elseif cycle >= 840 and cycle < 1260 and cycle % 4 == 0 then
        local localTime = cycle - 840
        local direction = floor(localTime / diff(rt, {60, 30, 30, 30, 30}))
        ring(side < 0 and 3 or 5, 1, self.ldX, self.ldY,
            side * localTime * (110 + direction * 12),
            diff(rt, {5, 6, 6, 6, 7}) + localTime * 0.02,
            diff(rt, {9, 13, 15, 17, 19}))
    end
end

handlers[0xcb] = stage9LastEmitter
handlers[0xcc] = stage9LastEmitter

-- Stage 9 final boss ------------------------------------------------------

local function spawnStage9Attack(rt, owner, typeId, offsetX, offsetY,
                                 index, angle, speed)
    local child = spawnChild(rt, owner, typeId, 1, offsetX, offsetY,
        index, angle, speed, "stage9 boss attack node")
    if child then child._blOwnerPhase = owner._blPhase end
    return child
end

local function stage9OpenPhase(self, rt, phase)
    self._blPhase = phase
    if phase == 1 then
        setBattle(self, 1, 100000, 2400)
    elseif phase == 2 then
        setBattle(self, 6, 100000, 2400)
    elseif phase == 3 then
        if difficulty(rt) == 4 then
            setBattle(self, 0x6f, 180000, 5400)
        else
            setBattle(self, 0x0b, 200000, 5400)
        end
    else
        if difficulty(rt) == 4 then
            setBattle(self, 0xa1, 180000, 7680)
        else
            setBattle(self, 0x3d, 150000, 6000)
        end
    end
end

local function stage9Break(self, rt)
    local timeout = (self.countdown or 0) <= 0
    clearForBreak(self, timeout)
    spawnPostDeathCounter(self, 140)
    self.targetable = false
    self.protect = true
    self.hp = 1
    self.countdown = 1
    if self._blPhase == 1 then
        setState(self, 5)
    elseif self._blPhase == 2 then
        setState(self, 10)
    elseif self._blPhase == 3 then
        setState(self, difficulty(rt) == 4 and 0xa0 or 0x3c)
    else
        setState(self, difficulty(rt) == 4 and 199 or 99)
        protectPlayer(360)
    end
end

local function stage9StateSpeed(state, t)
    if state == 0x0b or state == 0x1b then
        if t < 60 then return 0.1 end
        return min(3, 0.1 + (t - 60) * 2.9 / 180)
    elseif state == 0x18 then
        return min(3, 0.5 + t * 2.5 / 120)
    elseif state == 0x19 then
        return max(0.5, 3 - t * 2.5 / 60)
    elseif state == 0x1a then
        if t < 575 then return 0.5 + t * 2.5 / 575 end
        return max(0.5, 3 - (t - 575) * 2.5 / 575)
    elseif state == 0x6f or state == 0x75 then
        if t < 60 then return 0.1 end
        return min(2, 0.1 + (t - 60) * 1.9 / 420)
    elseif state == 0x70 then
        return max(0.5, 2 - t * 1.5 / 580)
    elseif state == 0x71 then
        return min(2.4, 0.5 + t * 1.9 / 600)
    elseif state == 0x74 then
        if t < 600 then return 2.4 end
        return max(0.1, 2.4 - (t - 600) * 2.3 / 550)
    elseif state == 0xa1 then
        return min(2.4, 0.3 + t * 2.1 / 300)
    end
    return 0.3
end

local function stage9PatternPhase1(self, rt)
    local t = self.helperTimer
    local cycle = t % 1600
    if cycle == 0 then
        spawnStage9Attack(rt, self, 0xce,
            randomRange(self, rt, t, -80, 80),
            randomRange(self, rt, t + 1, -30, 60), 0, aim(self), 0)
        spawnStage9Attack(rt, self, 0xcf, -100, 0, 0, 0, 0)
        spawnStage9Attack(rt, self, 0xd0, 100, 0, 1, 0, 0)
    elseif cycle == 180 then
        spawnStage9Attack(rt, self, 0xd1, -80, 20, 0, 0, 0)
        spawnStage9Attack(rt, self, 0xd2, 80, 20, 1, 0, 0)
    elseif cycle == 360 then
        spawnStage9Attack(rt, self, 0xd3, 0, 30, 0, aim(self), 0)
    elseif cycle == 540 then
        spawnStage9Attack(rt, self, 0xd4, -95, 15, 0, aim(self), 0)
        spawnStage9Attack(rt, self, 0xd5, 95, 15, 1, aim(self), 0)
    end
end

local function stage9PatternPhase2(self, rt)
    local t = self.helperTimer
    local cycle = t % 1600
    if cycle == 0 then
        for i = 0, 5 do
            local typeId = i % 2 == 0 and 0xd6 or 0xd7
            spawnStage9Attack(rt, self, typeId, 0, 0, i,
                floor(i * 0x10000 / 6), 0)
        end
    elseif cycle == 120 then
        for i = 0, 5 do
            spawnStage9Attack(rt, self, 0xd8, 0, 0, i,
                floor(i * 0x10000 / 6), 0)
        end
    elseif cycle >= 780 and cycle < 880 and cycle % 10 == 0 then
        spawnStage9Attack(rt, self, 0xce,
            randomRange(self, rt, cycle, -120, 120),
            randomRange(self, rt, cycle + 1, -30, 80), cycle, aim(self), 0)
    elseif cycle >= 920 and cycle < 1540 and cycle % 8 == 0 then
        spawnStage9Attack(rt, self, 0xd9,
            randomRange(self, rt, cycle, -130, 130),
            randomRange(self, rt, cycle + 1, -20, 100), cycle, aim(self), 0)
    end
end

local function stage9PatternNormalLong(self, rt)
    local state, t = self.state, self.helperTimer
    if state == 0x0b or state == 0x1b then
        if t >= 70 and t < 860 then
            if t % diff(rt, {19, 15, 13, 11, 11}) == 0 then
                ring(0x0c, 1, self.ldX, self.ldY,
                    sin(t * pi / 120) * 10000,
                    diff(rt, {3.5, 4, 4.5, 5, 6}),
                    diff(rt, {7, 9, 9, 9, 9}))
                ring(3, 1, self.ldX, self.ldY,
                    -sin(t * pi / 120) * 10000,
                    diff(rt, {4, 4.5, 5, 5.5, 6.5}),
                    diff(rt, {7, 9, 9, 9, 9}))
            end
            if t % diff(rt, {11, 9, 9, 7, 7}) == 0 then
                fan(9, 0, self.ldX, self.ldY, aim(self),
                    6 + sin(t * pi / 90),
                    diff(rt, {5, 5, 6, 7, 7}), 12000)
            end
        end
    elseif state == 0x11 and t == 30 then
        local count = diff(rt, {9, 11, 13, 15, 15})
        ring(8, 0x2b, self.ldX, self.ldY, 0, 3.5, count)
        ring(8, 0x2b, self.ldX, self.ldY, floor(0x8000 / count), 5.5, count)
    elseif state == 0x17 then
        if t >= 50 and t < 230 and t % 10 == 0 then
            ring(floor(t / 10) % 2 == 0 and 0x0c or 0x0d, 0,
                self.ldX, self.ldY, t * 157, 3 + t * 0.012,
                diff(rt, {13, 17, 21, 25, 29}))
        elseif t >= 240 and t < 420 and t % 60 == 0 then
            for layer = 0, 2 do
                ring(5, 0, self.ldX, self.ldY, t * 137 + layer * 500,
                    7 + layer * 1.4, diff(rt, {17, 21, 25, 29, 33}))
            end
        end
    elseif state == 0x18 and t >= 20 and t < 340 and t % 2 == 0 then
        fire(3, 0x2c, self.ldX, self.ldY, t * 313, 5)
        fire(5, 0x2d, self.ldX, self.ldY, -t * 313, 5)
    elseif state == 0x19 then
        if t >= 30 and t < 720 and t % diff(rt, {8, 7, 7, 6, 6}) == 0 then
            fire(8, 0x2e, self.ldX, self.ldY, t * 317, 4.5)
        elseif t >= 820 and t < 900 and t % 8 == 0 then
            fan(8, 0x2e, self.ldX, self.ldY, t * 317, 5.5, 3, 0x10000)
        end
    elseif state == 0x1a and t >= 1 and t < 1120 then
        local spread = t < 150 and floor(0x10000 * (150 - t) / 150) or 0x10000
        if t % 6 == 0 then
            fan(3, 1, self.ldX, self.ldY, t * 211, 4.5,
                diff(rt, {7, 9, 11, 13, 15}), spread)
            fan(5, 1, self.ldX, self.ldY, -t * 211, 5.5,
                diff(rt, {7, 9, 11, 13, 15}), spread)
        end
    end
end

local function stage9PatternLunaticLong(self, rt)
    local state, t = self.state, self.helperTimer
    if state == 0x6f or state == 0x75 then
        if t >= 70 and t < 720 and t % 8 == 0 then
            local count = t < 310 and 11 or 22
            ring(3, 1, self.ldX, self.ldY, sin(t * pi / 120) * 9000,
                5.5, count)
            ring(5, 1, self.ldX, self.ldY, -sin(t * pi / 120) * 9000,
                6.5, count)
        elseif t == 720 then
            ring(8, 0x2f, self.ldX, self.ldY, 0, 4, 27)
        elseif t == 800 then
            ring(8, 0x30, self.ldX, self.ldY, 0x400, 5, 27)
        end
    elseif state == 0x70 and t >= 20 and t < 500 and t % 2 == 0 then
        fire(8, 0x31, self.ldX, self.ldY, t * 307, 4.5)
    elseif state == 0x71 then
        if t >= 20 and t % 6 == 0 then fire(3, 0x32, self.ldX, self.ldY, t * 251, 4.5) end
        if t >= 153 and (t - 153) % 6 == 0 then
            fire(5, 0x32, self.ldX, self.ldY, -t * 251, 5.5)
        end
    elseif state == 0x72 and t >= 10 and t < 500 and t % 15 == 0 then
        local a = randomInt(self, rt, t, 0, 0xffff)
        ring(3, 0x2c, self.ldX, self.ldY, a, 5, 21)
        ring(2, 0x2d, self.ldX, self.ldY, a + 0x400, 6.5, 21)
    elseif state == 0x73 and t % 8 == 0 then
        fan(3, 0, self.ldX, self.ldY, aim(self) + sin(t * pi / 90) * 8000,
            6, 6, 0x8000)
        fan(5, 0, self.ldX, self.ldY, aim(self) - sin(t * pi / 90) * 8000,
            6.5, 5, 0x8000)
        fan(8, 0x33, self.ldX, self.ldY, aim(self) + 0x8000, 5, 7, 12000)
    elseif state == 0x74 and t >= 10 and t < 1120 and t % 2 == 0 then
        local layers = 3 + floor((t / 180) % 5)
        for layer = 0, layers - 1 do
            fire(3, 1, self.ldX, self.ldY, t * 173, 3 + layer * 2)
            fire(5, 1, self.ldX, self.ldY, -t * 173, 3 + layer * 2)
        end
    end
end

local normalLongNext = {
    [0x0b] = {900, 0x0c}, [0x0c] = {30, 0x0d},
    [0x0d] = {30, 0x0e}, [0x0e] = {30, 0x0f},
    [0x0f] = {30, 0x10}, [0x10] = {30, 0x11},
    [0x11] = {140, 0x12}, [0x12] = {30, 0x13},
    [0x13] = {30, 0x14}, [0x14] = {30, 0x15},
    [0x15] = {30, 0x16}, [0x16] = {30, 0x17},
    [0x17] = {440, 0x18}, [0x18] = {350, 0x19},
    [0x19] = {1120, 0x1a}, [0x1a] = {1150, 0x1b},
    [0x1b] = {900, 0x0b},
}

local lunaticLongNext = {
    [0x6f] = {900, 0x70}, [0x70] = {580, 0x71},
    [0x71] = {600, 0x72}, [0x72] = {560, 0x73},
    [0x73] = {600, 0x74}, [0x74] = {1150, 0x75},
    [0x75] = {900, 0x6f},
}

local function stage9AdvanceLongState(self, rt)
    local row = normalLongNext[self.state] or lunaticLongNext[self.state]
    if not row or self.helperTimer < row[1] then return end
    local nextState = row[2]
    if nextState >= 0x0c and nextState <= 0x16 then
        self._blTargetX = 200 + ((nextState * 97) % 320)
        self._blTargetY = 150 + ((nextState * 53) % 130)
    end
    setState(self, nextState)
end

local function stage9PatternPhase4(self, rt)
    local t = self.helperTimer
    if self.state == 0x3d or self.state == 0x3e then
        local cycle = t % 360
        if cycle == 0 then
            for i = 0, 3 do
                local typeId = i % 2 == 0 and 0xda or 0xdb
                spawnStage9Attack(rt, self, typeId, 0, 0, i,
                    floor(i * 0x10000 / 4), 0)
            end
            if self.state == 0x3e then
                spawnStage9Attack(rt, self, 0xdc, 0, 0, 4, 0, 0)
                spawnStage9Attack(rt, self, 0xdd, 0, 0, 5, 0x8000, 0)
            end
        end
        if self.state == 0x3d and cycle >= 30 and cycle < 130 and cycle % 8 == 0 then
            ring(4, 1, self.ldX, self.ldY,
                randomInt(self, rt, cycle, 0, 0xffff),
                randomRange(self, rt, cycle + 1, 3.5, 7), 25)
        end
        if self.state == 0x3d and self.hp < self.maxhp * 0.5 and cycle > 150 then
            setState(self, 0x3e)
        end
    else
        local cycle = t % 600
        if cycle == 0 or cycle == 300 then
            for i = 0, 6 do
                local typeId = i % 2 == 0 and 0xda or 0xdb
                spawnStage9Attack(rt, self, typeId, 0, 0, i,
                    floor(i * 0x10000 / 7), 0)
            end
        elseif cycle == 150 then
            for i = 0, 6 do
                local typeId = i % 2 == 0 and 0xdc or 0xdd
                spawnStage9Attack(rt, self, typeId, 0, 0, i,
                    floor(i * 0x10000 / 7), 0)
            end
        end
        if t >= 300 and cycle >= 30 and cycle < 150 and cycle % 8 == 0 then
            ring(4, 1, self.ldX, self.ldY,
                randomInt(self, rt, cycle, 0, 0xffff), 6, 40)
        end
    end
end

handlers[0x140] = function(self, rt)
    configureVisual(self, 4, 140)
    battleTelemetry(self, rt)
    if not self._blInit then
        self._blInit = true
        self.state = 0
        self.helperTimer = 0
        self._blPhase = 0
        self.targetable = false
        self.protect = true
    end
    local state, t = self.state, self.helperTimer
    if state == 0 then
        bossMove(self, rt, 0.3, 50, 210, 510, 150, 250, 0x1400)
        if t >= 240 then stage9OpenPhase(self, rt, 1) end
        return
    elseif state == 5 then
        self.ldY = self.ldY + 0.1
        if t >= 150 then stage9OpenPhase(self, rt, 2) end
        return
    elseif state == 10 then
        self.ldY = self.ldY + 0.1
        if t >= 540 then stage9OpenPhase(self, rt, 3) end
        return
    elseif state == 0x3c or state == 0xa0 then
        self.ldY = self.ldY + 0.1
        if t >= 150 then stage9OpenPhase(self, rt, 4) end
        return
    elseif state == 99 or state == 199 then
        self.targetable = false
        self.protect = true
        self.ldY = self.ldY + 0.2
        if t >= 600 then
            self.active = false
            Del(self)
            rt.gate = false
            rt.boss = nil
            rt.complete = true
        end
        return
    end

    updateShield(self, rt, 0xc3)
    if self._blPhase == 1 then
        stage9PatternPhase1(self, rt)
    elseif self._blPhase == 2 then
        stage9PatternPhase2(self, rt)
    elseif self._blPhase == 3 then
        if difficulty(rt) == 4 then stage9PatternLunaticLong(self, rt)
        else stage9PatternNormalLong(self, rt) end
    else
        stage9PatternPhase4(self, rt)
    end

    local speed = stage9StateSpeed(state, t)
    bossMove(self, rt, speed, 50, 190, 530, 140, 280, 0x1401)
    if self._blPhase == 3 then stage9AdvanceLongState(self, rt) end
    local timeout = tickCountdown(self)
    if self.hp <= 0 or timeout then stage9Break(self, rt) end
end

local function validStage9AttackOwner(self)
    local owner = parentOf(self)
    if not owner or owner.spawnType ~= 0x140 or
       owner._blPhase ~= self._blOwnerPhase or not owner.targetable then
        return nil
    end
    return owner
end

local function stage9AttackNode(self, rt)
    local typeId = self.spawnType
    local regularNode = typeId >= 0xce and typeId <= 0xd9
    local function beginFade()
        if not regularNode or self._blVisualState == 2 then return false end
        self._blVisualState = 2
        self._blVisualTimer = 0
        self.targetable = false
        return true
    end
    if regularNode then
        self._blVisualState = self._blVisualState or 0
        self._blVisualTimer = (self._blVisualTimer or -1) + 1
        if self._blVisualState == 2 then
            if self._blVisualTimer >= 20 then remove(self) end
            return
        elseif self._blVisualState == 0 and self._blVisualTimer >= 20 then
            self._blVisualState = 1
            self._blVisualTimer = 0
        end
    end
    local owner = validStage9AttackOwner(self)
    if not owner then
        if not beginFade() then remove(self) end
        return
    end
    configureVisual(self, (self.spawnType - 0xcd + 7) % 30, 20)
    self.targetable = false
    local t = self.helperTimer
    if typeId == 0xcd then
        move(self, self.angle16, 0.2)
        if t >= 180 then remove(self) end
    elseif typeId == 0xce or typeId == 0xd9 then
        if t < 20 then
            follow(self, owner, self._blOffsetX, self._blOffsetY, 3)
            self.angle16 = Core.turn16(self.angle16, aim(self), 0x100)
        else
            local limit = typeId == 0xce and 50 or 36
            if t <= 20 + limit and (t - 20) % 4 == 0 then
                local speed = diff(rt, {6, 7, 8, 9, 11}) + (t - 20) * 0.1
                fan(10, 0, self.ldX, self.ldY, self.angle16, speed,
                    diff(rt, {3, 5, 7, 9, 11}), 4000)
                if typeId == 0xd9 then
                    fire(11, 0, self.ldX, self.ldY, self.angle16 + 0x8000,
                        speed - 1)
                end
            end
            if t > 80 then beginFade() end
        end
    elseif typeId == 0xcf or typeId == 0xd0 then
        local sign = typeId == 0xcf and 1 or -1
        local a = Core.angle16((self.angle16 or 0) + sign * t * 0xde)
        local dx, dy = Core.ellipse(a, 105, 60, sign * 0x800)
        self.ldX, self.ldY = owner.ldX + dx, owner.ldY + dy
        if t >= 10 and t < 240 and
           t % diff(rt, {11, 7, 6, 7, 6}) == 0 then
            fan(0x0d, 0, self.ldX, self.ldY, a + sign * 0x4000, 5.5,
                diff(rt, {1, 1, 1, 2, 2}), 2500)
        end
        if t >= 250 then beginFade() end
    elseif typeId == 0xd1 or typeId == 0xd2 then
        local sign = typeId == 0xd1 and 1 or -1
        local a = Core.angle16((self.angle16 or 0) + sign * t * 0x180)
        local dx, dy = Core.polar(a, 90)
        self.ldX, self.ldY = owner.ldX + dx, owner.ldY + dy
        if t >= 10 and t < 90 and t % 5 == 0 then
            local px, py = playerPosition()
            local center = py < self.ldY and 0xc000 or 0x4000
            fan(3, 0, self.ldX, self.ldY, center, 6.5, 2, 3500)
        end
        if t >= 110 then beginFade() end
    elseif typeId == 0xd3 then
        follow(self, owner, self._blOffsetX, self._blOffsetY, 3)
        self.angle16 = Core.turn16(self.angle16, aim(self), 0x80)
        if t >= 10 and t < 330 and
           t % diff(rt, {40, 30, 24, 24, 20}) == 0 then
            local a = self.angle16 + sin(t * pi / 71) * 1800
            fan(8, 0, self.ldX, self.ldY, a,
                diff(rt, {5.5, 6.5, 7, 8, 9}),
                diff(rt, {5, 7, 9, 7, 9}), 12000)
            if difficulty(rt) > 2 then
                fan(8, 0, self.ldX, self.ldY, a, 10.5,
                    diff(rt, {5, 7, 9, 7, 9}), 12000)
            end
        end
        if t >= 350 then beginFade() end
    elseif typeId == 0xd4 or typeId == 0xd5 then
        follow(self, owner, self._blOffsetX, self._blOffsetY, 3)
        self.angle16 = Core.turn16(self.angle16, aim(self), 0x18)
        if t >= 10 and t < 320 and t % 4 == 0 then
            local count = min(29, 3 + floor(t / 20))
            ring(typeId == 0xd4 and 0x0d or 0x0c, 0,
                self.ldX, self.ldY, self.angle16, 4.5 + t * 0.01, count)
        end
        if t >= 340 then beginFade() end
    elseif typeId == 0xd6 or typeId == 0xd7 then
        local sign = typeId == 0xd6 and 1 or -1
        local a = Core.angle16((self.angle16 or 0) + sign * t * 0x120)
        local dx, dy = Core.polar(a, min(160, t * 1.2))
        self.ldX, self.ldY = owner.ldX + dx, owner.ldY + dy
        if t >= 10 and t < 720 and
           t % diff(rt, {14, 10, 8, 8, 7}) == 0 then
            for i = 0, diff(rt, {2, 3, 3, 4, 5}) - 1 do
                fire(9, 0, self.ldX, self.ldY, a + sign * 0x4000,
                    3.5 + i * 1.1)
            end
        end
        if t >= 730 then beginFade() end
    elseif typeId == 0xd8 then
        local a = Core.angle16((self.angle16 or 0) + t * 0x80)
        local dx, dy = Core.polar(a, min(130, t))
        self.ldX, self.ldY = owner.ldX + dx, owner.ldY + dy
        self.secondaryAngle16 = Core.turn16(self.secondaryAngle16, aim(self), 0x20)
        if t >= 30 and t < 600 and
           t % diff(rt, {120, 100, 80, 80, 60}) == 0 then
            fire(7, 0, self.ldX, self.ldY, self.secondaryAngle16, 6.5)
            if difficulty(rt) > 2 then
                fire(7, 0, self.ldX, self.ldY, self.secondaryAngle16, 9.5)
            end
        end
        if t >= 620 then beginFade() end
    else
        local sign = (typeId == 0xda or typeId == 0xdc) and 1 or -1
        local radius = sin(min(t, 300) * pi / 300) * 190
        local orbit = Core.angle16((self.angle16 or 0) + sign * t * 200)
        local dx, dy = Core.ellipse(orbit, radius, radius * 0.55, sign * 0xa00)
        self.ldX, self.ldY = owner.ldX + dx, owner.ldY + dy
        if t >= 30 and t < 270 and
           t % diff(rt, {6, 5, 4, 3, 3}) == 0 then
            local id = difficulty(rt) == 4 and
                (sign > 0 and 0x2c or 0x2d) or 0
            fire(typeId <= 0xdb and 3 or 5, id, self.ldX, self.ldY,
                orbit + sign * 0x4000, 5.5)
            fire(typeId <= 0xdb and 3 or 5, id, self.ldX, self.ldY,
                orbit + sign * 0x4000 + 900, 7)
        end
        if t >= 300 then remove(self) end
    end
end

for typeId = 0xcd, 0xdd do handlers[typeId] = stage9AttackNode end

-- Stage 10 scene boss -----------------------------------------------------

local sceneWindows = {
    [0xe4] = {1300, 3000}, [0xe5] = {1300, 3000},
    [0xe6] = {1300, 3000}, [0xe7] = {1300, 3000},
    [0xe8] = {2000, 5500}, [0xe9] = {2000, 5500},
    [0xea] = {2000, 5500}, [0xeb] = {2000, 5500},
    [0xec] = {2000, 5500}, [0xed] = {5700, 6600},
    [0xee] = {7900, 8800}, [0xef] = {9300, 10600},
    [0xf0] = {9300, 10600}, [0xf1] = {10600, 11500},
    [0xf2] = {1300, 3000}, [0xf3] = {1300, 3000},
    [0xf4] = {2000, 5500}, [0xf5] = {2000, 5500},
    [0xf6] = {2000, 5500}, [0xf7] = {2000, 5500},
    [0xf8] = {5700, 8500}, [0xf9] = {7900, 9100},
}

local function sceneTarget(frame)
    local x, y = 360, -2400
    if frame < 1200 then
        return x, y
    elseif frame < 3000 then
        y = sin((frame - 1200) * tau / 7200) * 800 - 2400
    elseif frame < 4700 then
        y = sin((frame - 3000) * tau / 6800) * 850 - 1600
    elseif frame < 6600 then
        local wave = sin((frame - 4700) * tau / 7600)
        x, y = wave * -560 + 360, wave * 100 - 750
    elseif frame < 8500 then
        local wave = sin((frame - 6600) * tau / 7600)
        local secondary = sin((frame - 6600) * tau / 3800)
        x = wave * 1120 - 200
        y = wave * (50 - secondary * 150) - 650
    elseif frame < 9100 then
        local wave = sin((frame - 8500) * tau / 2400)
        x, y = wave * -560 + 920, wave * -100 - 600
    elseif frame < 11300 then
        x = 360
        y = sin((frame - 9100) * tau / 8800) * 450 - 700
    elseif frame < 12000 then
        x = 360
        y = sin((frame - 11300) * tau / 2800) * 400 - 250
    else
        x, y = 360, 150
    end
    return x, y
end

local function moveSceneRoot(self, rt)
    local tx, ty = sceneTarget(rt.frame or 0)
    local f = rt.frame or 0
    local xPeriod = self.state == 6 and 11 or 100
    local xAmplitude = self.state == 6 and 10 or 18
    local desiredX = tx + sin(f * tau / xPeriod) * xAmplitude
    local desiredY = ty + sin(f * tau / 177) * 10
    self.ldX = self.ldX + (desiredX - self.ldX) / 5
    self.ldY = self.ldY + (desiredY - self.ldY) / 5
end

local function scenePattern2(self, rt)
    local t = self.helperTimer
    if t < 40 then return end
    local cycle = (t - 40) % 0x35c
    local rightX, leftX = self.ldX + 68, self.ldX - 68
    local sourceY = self.ldY + 95
    if cycle < 400 then
        local localCycle = cycle % 100
        local rightAim = aim(self, rightX, sourceY)
        local leftAim = aim(self, leftX, sourceY)
        if localCycle == 0 then
            self._blRightAim, self._blLeftAim = rightAim, leftAim
            for layer = 0, 3 do
                local speed = 4.4 - layer * 1.3
                for i = 0, 7 do
                    fire(10, 0x35, rightX, sourceY,
                        rightAim + i * 5000 - layer * 0x0af0 - 0x53fc,
                        speed)
                    fire(10, 0x36, leftX, sourceY,
                        leftAim + i * 0x0df3 + layer * 0x0af0 - 0x2134,
                        speed)
                end
            end
        end
        if localCycle < 30 and localCycle % 5 == 0 then
            fire(0x0b, 0, rightX, sourceY, self._blRightAim, 8, 10)
            fire(0x0b, 0, leftX, sourceY, self._blLeftAim, 8, 10)
            self._blRightAim = Core.turn16(self._blRightAim, rightAim, 500)
            self._blLeftAim = Core.turn16(self._blLeftAim, leftAim, 500)
        end
    end

    local function emitAlternating(right)
        local jitter = Core.frameRand(t + (right and 0 or 0x457)) % 2001
        local base = aim(self)
        for i = 0, 14 do
            local angle = right and
                (base + 0x18f0 + jitter + i * 0x0505) or
                (base - 0x5f40 - jitter + i * 0x0505)
            fire(right and 3 or 2, 8,
                right and rightX or leftX, sourceY, angle, 7.2, 10)
        end
    end
    if cycle >= 400 and cycle < 800 then
        local localCycle = (cycle - 400) % 200
        if localCycle < 60 and localCycle % 12 == 0 then
            emitAlternating(true)
        end
    end
    if cycle >= 500 and cycle < 800 then
        local localCycle = (cycle - 500) % 200
        if localCycle < 60 and localCycle % 12 == 0 then
            emitAlternating(false)
        end
    end
end

local function scenePattern4(self, rt)
    local t = self.helperTimer
    if t <= 30 then return end
    local rightX, leftX = self.ldX + 68, self.ldX - 68
    local burstY, streamY = self.ldY + 155, self.ldY + 95
    if t >= 60 then
        local burst = (t - 60) % 150
        if burst == 0 then self.secondaryAngle16 = aim(self, self.ldX, burstY) end
        if burst < 40 and burst % 13 == 0 then
            for i = 0, 1 do
                fire(0x0d, 0, self.ldX, burstY,
                    self.secondaryAngle16 + i * 2000 - 1000, 9, 10)
            end
            for i = 0, 2 do
                fire(0x0d, 0, self.ldX, burstY,
                    self.secondaryAngle16 + i * 2000 - 2000, 8, 10)
            end
            self.secondaryAngle16 = Core.turn16(self.secondaryAngle16,
                aim(self, self.ldX, burstY), 0x04b0)
        end
    end
    if t >= 130 then
        local localCycle = (t - 130) % 0x21c
        if localCycle < 250 and localCycle % 6 == 0 then
            for i = 0, 1 do
                fire(2, 0x37, leftX, streamY,
                    t * 0x164 - i * 0x8000, 5, 10)
            end
        end
    end
    if t >= 400 then
        local localCycle = (t - 400) % 0x21c
        if localCycle < 250 and localCycle % 6 == 0 then
            for i = 0, 1 do
                fire(2, 0x37, rightX, streamY,
                    -t * 0x164 - i * 0x8000, 5, 10)
            end
        end
    end
end

local function scenePattern6(self, rt)
    local t = self.helperTimer
    if t > 0 and (t - 1) % 5 == 0 then
        local seed = t + (rt.frame or 0) * 0x457
        local random = Core.frameRand(seed)
        local random2 = Core.frameRand(seed + 1)
        local randomAngle = random % 0x10000
        local randomAngle2 = random2 % 0x10000
        local firstX = self.ldX + sin(Core.angleToRadians(randomAngle)) * 36
        local secondX = self.ldX + sin(Core.angleToRadians(randomAngle2)) * 36
        local sourceY = self.ldY + 140
        local firstAngle = trunc(sin(Core.angleToRadians(
            Core.angle16(random + 0x1357))) * 14000) - 0x4000
        local secondAngle = trunc(sin(Core.angleToRadians(
            Core.angle16(random2 + 0x2468))) * 14000) - 0x4000
        for _, speed in ipairs({7, 11}) do
            fire(0x0d, 0x0b, firstX, sourceY, firstAngle, speed, 10)
            fire(0x0d, 0x0b, secondX, sourceY, secondAngle, speed, 10)
        end
    end
end

local function sceneBreak(self, rt, nextState)
    clearForBreak(self, (self.countdown or 0) <= 0)
    spawnPostDeathCounter(self, 140)
    self.targetable = false
    self.protect = true
    self.hp = 1
    self.countdown = 1
    self.radius = 250
    setState(self, nextState)
end

local function spawnSceneNode(rt, parent, typeId, offsetX, offsetY,
                              index, angle, hp, radius, absoluteFirstFrame)
    local child = spawnChild(rt, parent, typeId, hp, offsetX, offsetY,
        index, angle, 1, "stage10 recovered scene apparatus")
    if not child then return nil end
    child._blSourceAngle16 = Core.angle16(angle or 0x4000)
    child.radius = radius
    child.targetable = false
    child.protect = true
    if absoluteFirstFrame then
        child.ldX, child.ldY = offsetX, offsetY
    end
    return child
end

handlers[0x14c] = function(self, rt)
    self.sheet = "xl"
    self.visualFrame = 0
    battleTelemetry(self, rt)
    if not self._blInit then
        self._blInit = true
        self.radius = 200
        self.state = 0
        self.helperTimer = 0
        self.targetable = false
        self.protect = true
        spawnSceneNode(rt, self, 0xde, 0, 500, 0, 0x4000,
            99999999, 300, false)
        if (rt.rawStartFrame or 0) >= 12000 then
            self.state = 7
            self.helperTimer = 240
            rt.gate = true
        end
    end

    local state, t, f = self.state, self.helperTimer, rt.frame or 0
    if state == 0 then
        moveSceneRoot(self, rt, false)
        if f >= 11900 and f < 11911 then
            self.hp, self.maxhp, self.countdown = 55000, 55000, 1500
            rt.gate = true
            setState(self, 1)
        end
        return
    elseif state == 1 then
        moveSceneRoot(self, rt, false)
        if f >= 12000 then
            self.targetable = true
            self.protect = false
            setState(self, 2)
            self.portPhase = 1
        end
        return
    elseif state == 3 then
        moveSceneRoot(self, rt, true)
        if t < 90 then spawnSceneDeathExplosionChain(self, rt) end
        if t >= 120 then
            self.radius = 200
            setBattle(self, 4, 55000, 1500)
        end
        return
    elseif state == 5 then
        moveSceneRoot(self, rt, true)
        if t < 90 then spawnSceneDeathExplosionChain(self, rt) end
        if t >= 120 then
            self.radius = 200
            setBattle(self, 6, 66000, 1800)
        end
        return
    elseif state == 7 then
        self.targetable = false
        self.protect = true
        if t < 150 then self.ldY = self.ldY + t * 0.01 end
        if t < 150 then spawnSceneDeathExplosionChain(self, rt) end
        if t == 150 then spawnSceneTerminalBlast(self, rt) end
        if t >= 240 then
            if not self._blHandoff then
                self._blHandoff = true
                rt:spawn(0x141, 100000, 360, 320,
                    "Stage 10 final boss handoff")
            end
            self.active = false
            Del(self)
            if rt.boss == self then rt.boss = nil end
        end
        return
    end

    updateShield(self, rt, 0xc3)
    moveSceneRoot(self, rt, true)
    if state == 2 then scenePattern2(self, rt)
    elseif state == 4 then scenePattern4(self, rt)
    elseif state == 6 then scenePattern6(self, rt) end
    local timeout = tickCountdown(self)
    if self.hp <= 0 or timeout then sceneBreak(self, rt, state + 1) end
end

local function sceneWave(rt, offset, amplitude, base)
    return Core.angle16((base or 0) + trunc(sin(((rt.frame or 0) + offset) *
        tau / 100) * amplitude))
end

local function sceneOrbit(x, y, angle, radius)
    local dx, dy = Core.polar(angle, radius)
    return x + dx, y + dy
end

local function sceneMarker(parent)
    return parent._blMarkerX or parent.ldX, parent._blMarkerY or parent.ldY
end

local function spawnSceneStructureChildren(self, rt)
    local typeId = self.spawnType
    if typeId == 0xde then
        spawnSceneNode(rt, self, 0xdf, 0, 440, 0, 0x4000,
            99999999, 300, false)
        spawnSceneNode(rt, self, 0xe0, 170, -240, 0, 0x4000,
            99999999, 100, false)
        spawnSceneNode(rt, self, 0xe0, -170, -240, 1, 0x4000,
            99999999, 100, false)
        spawnSceneNode(rt, self, 0xef, 210, 140, 0, 0x4000,
            7000, 60, false)
        spawnSceneNode(rt, self, 0xf0, -180, 0, 1, 0x4000,
            7000, 60, false)
        spawnSceneNode(rt, self, 0xf1, 0, 0, 2, 0x4000,
            20000, 60, false)
    elseif typeId == 0xdf then
        spawnSceneNode(rt, self, 0xe2, 175, 35, 0, 0x43e8,
            99999999, 100, false)
        spawnSceneNode(rt, self, 0xe2, -175, 35, 1, 0x3830,
            99999999, 100, false)
        spawnSceneNode(rt, self, 0xe8, -55, 195, 0, 0x4000,
            7000, 60, false)
        spawnSceneNode(rt, self, 0xe9, -250, 100, 1, 0x4000,
            7000, 60, false)
        spawnSceneNode(rt, self, 0xea, 225, 70, 2, 0x4000,
            7000, 60, false)
        spawnSceneNode(rt, self, 0xeb, 25, -20, 3, 0x4000,
            7000, 60, false)
        spawnSceneNode(rt, self, 0xec, -195, -35, 4, 0x4000,
            7000, 60, false)
        spawnSceneNode(rt, self, 0xf4, 75, 185, 0, 0x4000,
            3000, 40, false)
        spawnSceneNode(rt, self, 0xf5, 15, 95, 1, 0x4000,
            3000, 40, false)
        spawnSceneNode(rt, self, 0xf6, -90, 70, 2, 0x4000,
            3000, 40, false)
        spawnSceneNode(rt, self, 0xf7, 160, -50, 3, 0x4000,
            3000, 40, false)
    elseif typeId == 0xe0 then
        local right = (self._blIndex or 0) == 0
        spawnSceneNode(rt, self, 0xe1, right and 10 or -10, -3000,
            self._blIndex, 0x4000, 99999999, 100, true)
    elseif typeId == 0xe1 then
        if (self._blIndex or 0) == 0 then
            spawnSceneNode(rt, self, 0xed, 0, 0, 0, 0x4000,
                20000, 60, false)
            spawnSceneNode(rt, self, 0xf8, 0, 0, 0, 0x4000,
                4000, 40, false)
        else
            spawnSceneNode(rt, self, 0xee, 0, 0, 1, 0x4000,
                20000, 60, false)
            spawnSceneNode(rt, self, 0xf9, 0, 0, 1, 0x4000,
                4000, 40, false)
        end
    elseif typeId == 0xe2 then
        local right = (self._blIndex or 0) == 0
        spawnSceneNode(rt, self, 0xe3, right and 10 or -10, -3000,
            self._blIndex, right and 0x3830 or 0x4fa0,
            99999999, 100, true)
    elseif typeId == 0xe3 then
        if (self._blIndex or 0) == 0 then
            spawnSceneNode(rt, self, 0xe4, 0, 0, 0, 0x4000,
                7000, 60, false)
            spawnSceneNode(rt, self, 0xe5, 0, 0, 1, 0x4000,
                7000, 60, false)
            spawnSceneNode(rt, self, 0xf2, 0, 0, 0, 0x4000,
                3000, 40, false)
        else
            spawnSceneNode(rt, self, 0xe6, 0, 0, 0, 0x4000,
                7000, 60, false)
            spawnSceneNode(rt, self, 0xe7, 0, 0, 1, 0x4000,
                7000, 60, false)
            spawnSceneNode(rt, self, 0xf3, 0, 0, 0, 0x4000,
                3000, 40, false)
        end
    end
end

local function sceneStructure(self, rt)
    local parent = parentOf(self)
    local root = rootOf(self)
    if not parent or not root or root.spawnType ~= 0x14c then remove(self); return end
    -- 这些部件由 renderSceneNode 组装。基础图像仍使用同一张八帧图集。
    configureVisual(self, self.spawnType - 0xde,
        self.spawnType == 0xde and 300 or 100, "xl")
    self.targetable = false
    self.protect = true
    local typeId, t = self.spawnType, self.helperTimer
    if t == 0 then spawnSceneStructureChildren(self, rt) end

    if typeId == 0xde then
        self.ldX = parent.ldX + (self._blOffsetX or 0)
        self.ldY = parent.ldY + (self._blOffsetY or 0) +
            sin(((rt.frame or 0) + 20) * tau / 100) * 3
        self._blMarkerX = self.ldX
        self._blMarkerY = self.ldY - 100 +
            sin(((rt.frame or 0) + 30) * tau / 100) * 3
        self.angle16 = 0
    elseif typeId == 0xdf then
        self.ldX = parent.ldX + (self._blOffsetX or 0)
        self.ldY = parent.ldY + (self._blOffsetY or 0) +
            sin(((rt.frame or 0) + 40) * tau / 100) * 3
        self.angle16 = 0
    elseif typeId == 0xe0 then
        self.ldX = parent.ldX + (self._blOffsetX or 0)
        self.ldY = parent.ldY + (self._blOffsetY or 0)
        local right = (self._blOffsetX or 0) >= 0
        local drawAngle = right and sceneWave(rt, 20, 400, 0x3060) or
            sceneWave(rt, 0, -400, -0x3060)
        local orbitAngle = right and drawAngle or Core.angle16(drawAngle + 0x8000)
        self._blBodyX, self._blBodyY = sceneOrbit(
            self.ldX, self.ldY, orbitAngle, 200)
        self._blMarkerX, self._blMarkerY = sceneOrbit(
            self.ldX, self.ldY, orbitAngle, 390)
        self.angle16, self.secondaryAngle16 = drawAngle, orbitAngle
    elseif typeId == 0xe1 then
        local previousX, previousY = self.ldX, self.ldY
        self.ldX, self.ldY = sceneMarker(parent)
        local right = (self._blOffsetX or 0) >= 0
        local drawAngle = right and sceneWave(rt, 30, 700, 0x24a8) or
            sceneWave(rt, 30, -400, -0x24a8)
        local orbitAngle = right and drawAngle or Core.angle16(drawAngle + 0x8000)
        local centerX, centerY = self.ldX, self.ldY
        if right then centerX, centerY = previousX, previousY end
        self._blBodyX, self._blBodyY = sceneOrbit(
            centerX, centerY, orbitAngle, 200)
        self._blMarkerX, self._blMarkerY = sceneOrbit(
            self.ldX, self.ldY, orbitAngle, 313)
        self.angle16, self.secondaryAngle16 = drawAngle, orbitAngle
        self.targetAngle16 = sceneWave(rt, 40, right and 800 or -800, 0)
    elseif typeId == 0xe2 then
        self.ldX = parent.ldX + (self._blOffsetX or 0)
        self.ldY = parent.ldY + (self._blOffsetY or 0)
        local right = (self._blOffsetX or 0) >= 0
        local bodyAngle = Core.angle16((self._blSourceAngle16 or self.angle16) +
            trunc(sin(((rt.frame or 0) + 70) * tau / 100) *
                (right and 200 or -200)))
        self._blBodyX, self._blBodyY = sceneOrbit(
            self.ldX, self.ldY, bodyAngle, 300)
        self._blMarkerX, self._blMarkerY = sceneOrbit(
            self.ldX, self.ldY, bodyAngle, right and 560 or 490)
        self.secondaryAngle16 = bodyAngle
    elseif typeId == 0xe3 then
        local previousX, previousY = self.ldX, self.ldY
        if t > 0 then self.ldX, self.ldY = sceneMarker(parent) end
        local right = (self._blOffsetX or 0) >= 0
        local bodyAngle = Core.angle16((self._blSourceAngle16 or self.angle16) +
            trunc(sin(((rt.frame or 0) + 80) * tau / 100) *
                (right and 400 or -300)))
        self._blBodyX, self._blBodyY = sceneOrbit(
            previousX, previousY, bodyAngle, 300)
        self._blMarkerX, self._blMarkerY = sceneOrbit(
            self.ldX, self.ldY, bodyAngle, right and 490 or 420)
        self.secondaryAngle16 = bodyAngle
        self.targetAngle16 = sceneWave(rt, 88,
            right and 800 or -600, right and 1000 or 0)
    end
    if root.state == 7 and root.helperTimer >= 160 then remove(self) end
end

for typeId = 0xde, 0xe3 do handlers[typeId] = sceneStructure end

local function sceneCombatNode(self, rt)
    local root = rootOf(self)
    if not root or root.spawnType ~= 0x14c then remove(self); return end
    local typeId = self.spawnType
    local window = sceneWindows[typeId]
    local f = rt.frame or 0
    local medium = typeId <= 0xf1
    configureVisual(self, (typeId - 0xe4 + 3) % 30,
        medium and 60 or 40, medium and "m" or "s")

    local parent = parentOf(self)
    if not parent then remove(self); return end
    local targetX = parent.ldX + (self._blOffsetX or 0)
    local targetY = parent.ldY + (self._blOffsetY or 0)
    local function orbitTarget(centerX, centerY, angle, radius)
        targetX, targetY = sceneOrbit(centerX, centerY, angle, radius)
    end
    self.secondaryAngle16 = 0
    if typeId == 0xe4 then
        self.secondaryAngle16 = sceneWave(rt, 88, 800, 0)
        local mx, my = sceneMarker(parent)
        orbitTarget(mx, my, Core.angle16(parent.targetAngle16 + 0x5770), 70)
    elseif typeId == 0xe5 then
        self.secondaryAngle16 = sceneWave(rt, 80, 400, 0)
        orbitTarget(parent.ldX, parent.ldY,
            Core.angle16(parent.secondaryAngle16 + 1000), 270)
    elseif typeId == 0xe6 then
        self.secondaryAngle16 = sceneWave(rt, 88, -800, 0)
        local mx, my = sceneMarker(parent)
        orbitTarget(mx, my, Core.angle16(parent.targetAngle16 + 0x3060), 60)
    elseif typeId == 0xe7 then
        self.secondaryAngle16 = sceneWave(rt, 80, -400, 0)
        orbitTarget(parent.ldX, parent.ldY,
            Core.angle16(parent.secondaryAngle16 - 1000), 260)
    elseif typeId == 0xed then
        self.secondaryAngle16 = sceneWave(rt, 30, 700, 0)
        orbitTarget(parent.ldX, parent.ldY, sceneWave(rt, 30, 700, 0x20c0), 300)
    elseif typeId == 0xee then
        self.secondaryAngle16 = sceneWave(rt, 30, -700, 0)
        orbitTarget(parent.ldX, parent.ldY, sceneWave(rt, 30, -400, 0x5f40), 300)
    elseif typeId == 0xf1 then
        targetX, targetY = sceneMarker(parent)
        targetX = targetX + (self._blOffsetX or 0)
        targetY = targetY + (self._blOffsetY or 0)
    elseif typeId == 0xf2 or typeId == 0xf3 then
        local sign = typeId == 0xf2 and 1 or -1
        self.secondaryAngle16 = sceneWave(rt, 80, 400, 0)
        orbitTarget(parent.ldX, parent.ldY,
            Core.angle16(parent.angle16 + trunc(sin((f + 80) * tau / 100) *
                400 * sign)), typeId == 0xf2 and 400 or 370)
    elseif typeId == 0xf8 then
        self.secondaryAngle16 = sceneWave(rt, 30, 700, 0)
        orbitTarget(parent.ldX, parent.ldY, sceneWave(rt, 30, 700, 0x1cd8), 190)
    elseif typeId == 0xf9 then
        self.secondaryAngle16 = sceneWave(rt, 30, -700, 0)
        orbitTarget(parent.ldX, parent.ldY, sceneWave(rt, 30, -400, 0x6328), 190)
    end
    local distance = Core.distance(self.ldX, self.ldY, targetX, targetY)
    if distance > 0 then
        local heading = Core.aim16(self.ldX, self.ldY, targetX, targetY)
        local dx, dy = Core.polar(heading, distance / 3)
        self.ldX, self.ldY = self.ldX + dx, self.ldY + dy
    end

    if self.state == 0 then
        local missed = self.helperTimer == 0 and f >= window[1]
        if missed then
            self.targetable = false
            if medium then self.state = 2 else remove(self); return end
        else
            local lo, hi = medium and 90 or 60, medium and 630 or 660
            if f >= window[1] and self.ldX >= lo and self.ldX <= hi and
               self.ldY >= lo and self.ldY <= hi then
                self.state = 1
                self.helperTimer = -1
                self.targetable = true
                self.protect = false
                return
            elseif root.state > 0 then
                self.targetable = false
                self.state = medium and 3 or 2
            end
        end
    end
    if self.state ~= 1 then
        if root.state == 7 and root.helperTimer >= 160 then remove(self) end
        return
    end

    local t = self.helperTimer
    local firing = f < window[2] and self.targetable
    if typeId >= 0xf2 then
        if firing and t >= 20 then
            local q = (t - 20) % 50
            if q == 0 then self._blAim = aim(self) end
            if q < 24 and q % 4 == 0 then
                local speed = 6.4 + q * 0.2
                fire(0x0d, 0, self.ldX, self.ldY, self._blAim, speed)
                fire(0x0d, 0, self.ldX, self.ldY, self._blAim, speed + 2)
                self._blAim = Core.turn16(self._blAim, aim(self), 0x100)
            end
        end
    elseif typeId == 0xed or typeId == 0xee then
        if firing and t >= 20 and (t - 20) % 7 == 0 then
            local first = (typeId == 0xed) == (t < 420)
            local visual = first and 3 or 2
            for layer = 0, 3 do
                local speed = 6.4 + layer * 0.9
                local base = t * (first and 500 or -500) +
                    layer * (first and 900 or -900) +
                    (first and -10000 or 10000)
                fire(visual, 0, self.ldX, self.ldY, base, speed)
                fire(visual, 0, self.ldX, self.ldY, base + 0x8000, speed)
            end
        end
    elseif typeId == 0xf1 then
        if firing and t >= 20 and t < 420 and (t - 20) % 5 == 0 then
            for layer = 0, 3 do
                local spin = t * 0x1e0
                fire(3, 0, self.ldX, self.ldY,
                    spin + layer * 600 - 0x2580, 6.4 + layer * 0.7)
                fire(3, 0, self.ldX, self.ldY,
                    spin + layer * 600 + 0x5a80, 6.4 + layer * 0.7)
                fire(10, 0, self.ldX, self.ldY,
                    -spin - layer * 0xaf0 + 0x12c0, 5.2 + layer * 0.8)
                fire(10, 0, self.ldX, self.ldY,
                    -spin - layer * 0xaf0 - 0x6d40, 5.2 + layer * 0.8)
            end
        elseif firing and t >= 440 and (t - 440) % 5 == 0 then
            for layer = 0, 3 do
                local spin = t * 0x1e0
                fire(0x0b, 0, self.ldX, self.ldY,
                    spin + layer * 0xaf0 - 0x2580, 5.2 + layer * 0.8)
                fire(0x0b, 0, self.ldX, self.ldY,
                    spin + layer * 0xaf0 + 0x5a80, 5.2 + layer * 0.8)
                fire(2, 0, self.ldX, self.ldY,
                    -spin - layer * 600 + 0x12c0, 6.4 + layer * 0.7)
                fire(2, 0, self.ldX, self.ldY,
                    -spin - layer * 600 - 0x6d40, 6.4 + layer * 0.7)
            end
        end
    elseif firing and t >= 20 then
        local q = (t - 20) % 75
        if q == 0 then self._blAim = aim(self) end
        if q < 32 and q % 4 == 0 then
            local speed = 8 + q * 0.07
            fire(0x0b, 0, self.ldX, self.ldY, self._blAim, speed)
            fire(0x0b, 0, self.ldX, self.ldY, self._blAim - 1000, speed - 1)
            fire(0x0b, 0, self.ldX, self.ldY, self._blAim + 1000, speed - 1)
            self._blAim = Core.turn16(self._blAim, aim(self), 0x80)
        end
    end

    local origin = Core.playfieldOriginX()
    self.targetable = self.ldX >= origin and self.ldX <= origin + 600 and
        self.ldY >= 0 and self.ldY <= 720
    if (typeId == 0xed or typeId == 0xee or typeId == 0xf1) and
       not self.targetable then
        self.state = 3
    end
    if self.hp < 1 then
        self.targetable = false
        if medium then
            self.hp = 1
            self.protect = true
            self.state = self.state + 1
        else
            self.deadRequested = true
        end
    end
    if root.state == 7 and root.helperTimer >= 160 then remove(self) end
end

for typeId = 0xe4, 0xf9 do
    if sceneWindows[typeId] then handlers[typeId] = sceneCombatNode end
end

-- Stage 10 final boss -----------------------------------------------------

local finalPhaseHp = {
    75000, 70000, 65000, 50000, 75000, 50000, 60000, 100000,
    45000, 80000, 65000, 75000, 85000, 128000, 32000, 270000,
}

local finalPhaseTime = {
    2400, 2400, 2100, 2400, 2400, 2400, 2100, 3300,
    2100, 2400, 2400, 2400, 2400, 3300, 5400, 6000,
}

local finalMainType = {
    [2] = 0x111, [4] = 0x112, [6] = 0x113, [8] = 0x115,
    [10] = 0x11a, [12] = 0x11d, [16] = 0x12d,
}

local function finalBattleState(phase)
    return (phase - 1) * 10 + 1
end

local function stage10OpenPhase(self, rt, phase)
    self._blPhase = phase
    local state = finalBattleState(phase)
    setBattle(self, state, finalPhaseHp[phase], finalPhaseTime[phase])
    local mainType = finalMainType[phase]
    if mainType then
        self._blMain = spawnChild(rt, self, mainType, self.hp,
            0, 0, 0, 0, 0, "stage10 final main apparatus")
    elseif phase == 14 then
        self._blMain = spawnChild(rt, self, 0x125, self.hp,
            100, 0, 0, 0, 0, "stage10 mirrored right apparatus")
        self._blMain2 = spawnChild(rt, self, 0x126, self.hp,
            -100, 0, 1, 0, 0, "stage10 mirrored left apparatus")
    end
end

local function stage10Break(self, rt)
    local timeout = (self.countdown or 0) <= 0
    clearForBreak(self, timeout)
    spawnPostDeathCounter(self, 140)
    self.targetable = false
    self.protect = true
    self.hp = 1
    self.countdown = 1
    if self._blPhase < 16 then
        setState(self, self._blPhase * 10)
    else
        setState(self, 200)
        protectPlayer(360)
    end
end

local function spawnFinalAux(rt, owner, typeId, offsetX, offsetY,
                             index, angle, speed)
    local child = spawnChild(rt, owner, typeId, 1, offsetX, offsetY,
        index, angle, speed, "stage10 final emitter")
    if child then child._blOwnerPhase = owner._blPhase end
    return child
end

local function finalPattern1(self, rt)
    local t = self.helperTimer
    if t < 30 then return end
    local localTime = t - 30
    local half = localTime % 210
    local side = half < 120 and -1 or 1
    local q = half < 120 and half or half - 120
    local active = side < 0 and 72 or 72
    if q < active and q % 5 == 0 then
        local x = self.ldX + side * (140 - q * 1.4)
        spawnFinalAux(rt, self, 0x105, x - self.ldX, -80,
            localTime, side < 0 and 0x3000 or 0x5000,
            4 + localTime * 0.003)
    end
end

local function finalPattern21(self, rt)
    local t = self.helperTimer
    if t < 30 then return end
    local cycle = (t - 30) % 300
    if cycle <= 90 and cycle % 14 == 0 then
        spawnFinalAux(rt, self, 0x106, -100, -40, cycle, 7000, 5)
    elseif cycle >= 180 and cycle <= 270 and (cycle - 180) % 14 == 0 then
        spawnFinalAux(rt, self, 0x106, 100, -40, cycle, 0x64a8, 5)
    end
    if t >= 210 and (t - 210) % 100 == 0 then
        local a = aim(self)
        fan(7, 0, self.ldX, self.ldY, a, 7,
            diff(rt, {5, 7, 7, 9, 11}), 12000)
        ring(3, 0, self.ldX, self.ldY, a, 4,
            diff(rt, {15, 17, 20, 20, 24}))
        ring(5, 0, self.ldX, self.ldY, a + 0x400, 6,
            diff(rt, {15, 17, 20, 20, 24}))
    end
end

local function finalPattern41(self, rt)
    local t = self.helperTimer
    if t < 30 then return end
    local cycle = (t - 30) % 300
    if cycle < 90 and cycle % 5 == 0 then
        local side = floor(cycle / 45) == 0 and -1 or 1
        spawnFinalAux(rt, self, 0x107, side * 130, -60,
            cycle, side < 0 and 0x3000 or 0x5000, 4.5)
    end
    if t >= 280 then
        local q = (t - 280) % 100
        if q < 32 and q % 4 == 0 then
            fan(7, 0, self.ldX, self.ldY, aim(self), 7 + q * 0.06, 3, 2400)
        end
    end
end

local function finalPattern61(self, rt)
    local t = self.helperTimer
    if t < 30 then return end
    local half = t >= 430 and 75 or 100
    local q = (t - 30) % (half * 2)
    if q == 0 or q == half then
        local typeId = q == 0 and 0x10c or 0x10d
        local count = 15
        for i = 0, count - 1 do
            spawnFinalAux(rt, self, typeId, 0, 0, i,
                floor(i * 0x10000 / count), 5 + (t - 30) * 0.002)
        end
    end
end

local function finalPattern81(self, rt)
    local t = self.helperTimer
    if t >= 30 and t % 4 == 0 then
        spawnFinalAux(rt, self, 0x10e,
            randomRange(self, rt, t, -80, 80), -40, t,
            aim(self), 2 + (t % 600) * 0.0015)
    end
    if t >= 150 and (t - 150) % 100 == 0 then
        local a = aim(self)
        ring(7, 0, self.ldX, self.ldY, a, 4.5, 15)
        ring(8, 0, self.ldX, self.ldY, a + 0x400, 7, 15)
    end
end

local function finalPattern101(self, rt)
    local t = self.helperTimer
    if t >= 30 and (t - 30) % 372 == 0 then
        spawnFinalAux(rt, self, 0x108, 0, 0, t, 0x3000, 5)
    end
    if t >= 246 and (t - 246) % 372 == 0 then
        spawnFinalAux(rt, self, 0x109, 0, 0, t, 0x5000, 5)
    end
    if t >= 45 and (t - 45) % 93 == 0 then
        ring(7, 0, self.ldX, self.ldY, aim(self), 3.5, 21)
    end
end

local function finalPattern121(self, rt)
    local t = self.helperTimer
    if t < 30 then return end
    local interval = max(80, 140 - floor((t - 30) / 400) * 10)
    if (t - 30) % interval == 0 then
        local side = floor((t - 30) / interval) % 2 == 0 and -1 or 1
        local typeId = side < 0 and 0x10f or 0x110
        local targetX = side < 0 and 10 or 590
        local speed = min(40, 29 + floor((t - 30) / interval))
        spawnFinalAux(rt, self, typeId, targetX - self.ldX, -60,
            t, side < 0 and 0x4000 or 0xc000, speed)
    end
end

local function finalPattern131(self, rt)
    local t = self.helperTimer
    if t < 290 then return end
    local cycle = (t - 290) % 1800
    local points = {{200, 240}, {520, 240}}
    for i, p in ipairs(points) do
        if cycle <= 360 and cycle % 28 == 0 then
            fan(7, 0, p[1], p[2],
                Core.aim16(p[1], p[2], playerPosition()), 7,
                13, 11000)
        elseif cycle >= 480 and cycle < 870 and cycle % 36 == 0 then
            local visual = i == 1 and 5 or 8
            fan(visual, 0, p[1], p[2],
                Core.aim16(p[1], p[2], playerPosition()),
                i == 1 and 7 or 6, i == 1 and 11 or 7,
                i == 1 and 8000 or 18000)
        end
    end
end

local function finalPattern141(self, rt)
    local t = self.helperTimer
    if t < 210 and t % 2 == 0 then
        spawnFinalAux(rt, self, 0x128, 0, 0, t,
            randomInt(self, rt, t, 0, 0xffff), 0)
    end
    if t == 30 and not self._blMain then
        self._blMain = spawnChild(rt, self, 0x127, self.hp,
            0, 0, 0, 0, 0, "stage10 phase15 apparatus")
    end
    if t >= 3360 then setState(self, 142) end
end

local function finalPattern151(self, rt)
    local t = self.helperTimer
    if self.state == 151 then
        if t == 30 and not self._blMain then
            self._blMain = spawnChild(rt, self, 0x12d, self.hp,
                0, 60, 0, 0, 0, "stage10 phase16 apparatus")
        end
        if self.hp < self.maxhp * 0.25 or self.countdown < 1500 then
            -- Child dispatch can run after this frame's countdown tick.
            self._bl12dCounterAllowed = self.countdown >= 1500
            self.targetable = false
            self.protect = true
            setState(self, 152)
        end
    elseif self.state == 152 then
        if t >= 150 then
            self.targetable = true
            self.protect = false
            setState(self, 153)
        end
    elseif self.state == 153 then
        if t >= 30 and (t - 30) % 360 == 0 then
            spawnFinalAux(rt, self, 0x134, 0, 60, t, 0, 0)
        end
        if t >= 210 and (t - 210) % 360 == 0 then
            spawnFinalAux(rt, self, 0x135, 0, 60, t, 0x8000, 0)
        end
    end
end

local finalRootPatterns = {
    [1] = finalPattern1, [21] = finalPattern21, [41] = finalPattern41,
    [61] = finalPattern61, [81] = finalPattern81,
    [101] = finalPattern101, [121] = finalPattern121,
    [131] = finalPattern131, [141] = finalPattern141,
    [151] = finalPattern151, [152] = finalPattern151,
    [153] = finalPattern151,
}

local function finalRootShouldMove(state, t)
    if (state == 11 or state == 31 or state == 51 or state == 71 or
        state == 91 or state == 111) and t >= 220 then return false end
    if state == 131 and t >= 280 then return false end
    if state == 141 and t >= 270 then return false end
    return true
end

handlers[0x141] = function(self, rt)
    configureVisual(self, 8, 80)
    battleTelemetry(self, rt)
    if not self._blInit then
        self._blInit = true
        self.state = 0
        self.helperTimer = 0
        self._blPhase = 0
        self._blMain = nil
        self.targetable = false
        self.protect = true
    end
    local state, t = self.state, self.helperTimer
    if state == 0 then
        bossMove(self, rt, 0.4, 50, 210, 510, 180, 280, 0x1410)
        if t >= 260 then stage10OpenPhase(self, rt, 1) end
        return
    elseif state == 200 then
        self.targetable = false
        self.protect = true
        self.ldY = self.ldY + 0.2
        if t == 240 then Projectile.clear() end
        if t >= 480 then
            self.active = false
            Del(self)
            rt.gate = false
            rt.boss = nil
            rt.complete = true
        end
        return
    elseif state % 10 == 0 then
        self.targetable = false
        self.protect = true
        local transitionIndex = floor(state / 10)
        local duration = transitionIndex % 2 == 1 and 180 or 200
        if transitionIndex % 2 == 1 then
            self.ldY = self.ldY + 0.1
        else
            bossMove(self, rt, 0.4, 50, 210, 510, 180, 280, 0x1411)
        end
        if t >= duration then
            self._blMain, self._blMain2 = nil, nil
            stage10OpenPhase(self, rt, self._blPhase + 1)
        end
        return
    end

    updateShield(self, rt, 0x136)
    local pattern = finalRootPatterns[state]
    if pattern then pattern(self, rt) end
    if finalRootShouldMove(state, t) then
        bossMove(self, rt, 0.4, 50, 210, 510, 180, 280, 0x1412)
    end
    local combatActive = not (
        (self._blPhase >= 2 and self._blPhase <= 12 and
            self._blPhase % 2 == 0 and t < 220) or
        (self._blPhase == 14 and t < 280) or
        (self._blPhase == 15 and t < 310))
    local timeout = combatActive and tickCountdown(self) or false
    if combatActive and (self.hp <= 0 or timeout) then stage10Break(self, rt) end
end

local finalDevicePhase = {
    [0x111] = 2, [0x112] = 4, [0x113] = 6, [0x115] = 8,
    [0x11a] = 10, [0x11d] = 12, [0x125] = 14, [0x126] = 14,
}

local function breakFinalDevice(self, owner)
    local phase = finalDevicePhase[self.spawnType]
    if not phase or owner.state ~= phase * 10 then return false end
    if not self._blDeviceBreaking then
        self._blDeviceBreaking = true
        self._blDeviceBreakTimer = 0
        if self.spawnType ~= 0x115 then
            spawnPostDeathCounterOnce(self, 140)
        end
    end
    self.targetable = false
    self.protect = true
    self._blDeviceBreakTimer = self._blDeviceBreakTimer + 1
    if self._blDeviceBreakTimer >= 140 then remove(self) end
    return true
end

local function finalDeviceOwner(self)
    local owner = parentOf(self)
    if not owner or owner.spawnType ~= 0x141 then return nil end
    local phase = finalDevicePhase[self.spawnType]
    if phase and owner._blPhase ~= phase then return nil end
    return owner
end

local function materializeDevice(self, owner, duration, attackable)
    if self._blMaterialized then return true end
    self.targetable = false
    self.protect = true
    follow(self, owner, self._blOffsetX, self._blOffsetY, 8)
    if self.helperTimer < duration then return false end
    self._blMaterialized = true
    self.hp = owner.hp
    self.maxhp = owner.maxhp
    self.targetable = attackable
    self.protect = not attackable
    setState(self, 1)
    return false
end

local function syncDeviceHp(self, owner)
    if not self.targetable then return end
    local shared = min(self.hp, owner.hp)
    self.hp, owner.hp = shared, shared
end

local function pattern111(self, rt, owner)
    local t = self.helperTimer
    bossMove(self, rt, 0.3, 50, 190, 530, 160, 300, 0x1110)
    local cycle = (t - 30) % 920
    if ((cycle >= 30 and cycle < 70) or
        (cycle >= 480 and cycle < 520)) and cycle % 4 == 0 then
        fan(7, 0, self.ldX - 65, self.ldY, aim(self), 11.1, 5, 7000)
    elseif cycle >= 80 and cycle < 390 and cycle % 2 == 0 then
        fire(8, 0x39, self.ldX + 65, self.ldY, -cycle * 0x960, 4.5)
        fire(8, 0x39, self.ldX + 65, self.ldY, -cycle * 0x960, 7)
    elseif cycle >= 520 and cycle < 900 and cycle % 8 == 0 then
        fan(9, 0, self.ldX + 65, self.ldY,
            aim(self) + sin(cycle * pi / 120) * 9000,
            7, 9, 24000)
    end
end

local function pattern112(self, rt, owner)
    local t = self.helperTimer
    local cycle = t % 1100
    if cycle == 1 then
        self._blTargetX, self._blTargetY = 260, 190
    elseif cycle == 40 or cycle == 110 or cycle == 180 or cycle == 250 or
           (cycle >= 360 and cycle <= 600 and cycle % 20 == 0) then
        self._blTargetX = randomRange(self, rt, cycle, 160, 560)
        self._blTargetY = randomRange(self, rt, cycle + 1, 140, 360)
    end
    local divisor = max(5, min(30, 5 + floor(cycle / 40)))
    self.ldX = self.ldX + ((self._blTargetX or owner.ldX) - self.ldX) / divisor
    self.ldY = self.ldY + ((self._blTargetY or owner.ldY) - self.ldY) / divisor
    if cycle >= 40 and cycle < 320 then
        local q = (cycle - 40) % 70
        if q == 0 then self._blAim = aim(self) end
        if q < 36 and q % 2 == 0 then
            for layer = 0, 4 do
                fire(7, 0, self.ldX, self.ldY, self._blAim,
                    4.5 + layer * 1.25 + q * 0.03)
            end
        end
        if cycle >= 90 and (cycle - 90) % 70 == 0 then
            local a = randomInt(self, rt, cycle, 0, 0xffff)
            ring(3, 0, self.ldX, self.ldY, a, 4, 25)
            ring(5, 0, self.ldX, self.ldY, aim(self), 6, 25)
        end
    elseif cycle >= 360 and cycle <= 600 and cycle % 20 == 0 then
        local a = randomInt(self, rt, cycle, 0, 0xffff)
        for i = 0, 6 do
            fire(0x0d, 1, self.ldX, self.ldY,
                a + floor(i * 0x10000 / 7), 5)
            fire(0x0d, 1, self.ldX, self.ldY,
                a + floor(i * 0x10000 / 7), 7.5)
        end
    elseif cycle >= 640 and cycle < 1060 then
        fire(3, 1, self.ldX, self.ldY, cycle * 0x280, 5)
        if cycle % 2 == 0 then
            fire(5, 1, self.ldX, self.ldY, -cycle * 0x280, 6)
        end
    end
end

local function pattern113(self, rt, owner)
    local t = self.helperTimer
    if t == 1 and not self._blSatellites then
        self._blSatellites = true
        local offsets = {{-80, -50}, {80, -50}, {-140, 30}, {140, 30}}
        for i, v in ipairs(offsets) do
            spawnChild(rt, self, 0x114, 1, v[1], v[2], i - 1, 0, 0,
                "stage10 phase6 satellite")
        end
    end
    bossTarget(self, rt, 50, 170, 550, 150, 320, 0x1130)
    local speed = t < 180 and 0.5 + sin(t * pi / 360) * 3.5 or 4
    move(self, self.angle16, speed)
    if t >= 40 then
        local q = (t - 40) % 80
        if q == 0 then self._blAim = aim(self) end
        if q < 40 and q % 5 == 0 then
            fire(7, 0, self.ldX - 60, self.ldY, self._blAim, 8)
            fire(7, 0, self.ldX + 60, self.ldY, self._blAim, 8)
        end
    end
end

local finalDroneSequence = {0x118, 0x119, 0x116, 0x117}

local function pattern115(self, rt, owner)
    local t = self.helperTimer
    follow(self, owner, 0, 20, 5)
    if t == 0 and not self._blInitialDrones then
        self._blInitialDrones = true
        spawnChild(rt, self, 0x116, 9000, -160, -120, 0, 0, 0)
        spawnChild(rt, self, 0x117, 9000, 160, -120, 1, 0, 0)
    end
    if t >= 20 then
        local event = floor((t - 20) / 260)
        if event < 30 and (t - 20) % 260 == 0 then
            local typeId = finalDroneSequence[event % 4 + 1]
            local side = event % 2 == 0 and -1 or 1
            spawnChild(rt, self, typeId, 9000, side * 220, -180,
                event, side < 0 and 0x3000 or 0x5000, 0)
        end
    end
end

local function pattern11a(self, rt, owner)
    local t = self.helperTimer
    if not self._blStructure then
        self._blStructure = true
        spawnChild(rt, self, 0x11b, 1, -100, 35, 0, 0, 0)
        spawnChild(rt, self, 0x11c, 1, 100, 35, 1, 0, 0)
    end
    if self.state == 1 or self.state == 3 then
        if t % 90 == 0 then
            self._blTargetX = randomRange(self, rt, t, 170, 550)
            self._blTargetY = randomRange(self, rt, t + 1, 160, 330)
        end
        self.ldX = self.ldX + ((self._blTargetX or owner.ldX) - self.ldX) / 10
        self.ldY = self.ldY + ((self._blTargetY or owner.ldY) - self.ldY) / 10
        if t >= 30 and t < 360 and t % 30 == 0 then
            fan(7, 0, self.ldX, self.ldY, aim(self), 7.5, 5, 9000)
        end
        if t < 360 and t % 27 == 0 then
            ring(3, 0, self.ldX, self.ldY, t * 131, 4.5, 29)
        end
        if t < 360 and t % 13 == 0 then
            ring(5, 0, self.ldX, self.ldY, -t * 131, 6, 29)
        end
        if t >= 360 then setState(self, 2) end
    else
        local tx = owner.ldX + sin(t * pi / 180) * 180
        local ty = owner.ldY - min(80, t * 0.15)
        self.ldX = self.ldX + (tx - self.ldX) / 8
        self.ldY = self.ldY + (ty - self.ldY) / 8
        if t >= 60 and t % 72 == 0 then
            local side = floor(t / 72) % 2 == 0 and -1 or 1
            for i = 1, 30 do
                local x = self.ldX + randomRange(self, rt, t + i, -100, 100)
                local y = self.ldY + randomRange(self, rt, t + i + 100, -50, 80)
                fire(side < 0 and 3 or 5, 0, x, y,
                    randomInt(self, rt, t + i + 200, 0, 0xffff),
                    randomRange(self, rt, t + i + 300, 7, 12))
            end
            ring(8, 0, self.ldX, self.ldY, t * 101, 5.5, 27)
            for layer = 0, 2 do
                fan(7, 0, self.ldX, self.ldY, aim(self),
                    5 + layer * 1.5, 11, 15000)
            end
        end
        if t >= 640 then self.state = 3; self.helperTimer = 19 end
    end
end

local batteryLayout = {
    {0x11e, 0, 20}, {0x11f, -70, 0}, {0x11f, 70, 0},
    {0x120, -120, 30}, {0x120, 120, 30},
    {0x121, -170, 55}, {0x121, 170, 55},
    {0x122, -220, 80}, {0x122, 220, 80},
}

local function pattern11d(self, rt, owner)
    local t = self.helperTimer
    if not self._blBatteries then
        self._blBatteries = true
        for i, v in ipairs(batteryLayout) do
            spawnChild(rt, self, v[1], self.hp, v[2], v[3], i - 1, 0, 0,
                "stage10 phase12 battery")
        end
    end
    if self.state == 1 then
        if t < 210 then
            self.ldX = self.ldX + (320 - self.ldX) / 20
            self.ldY = self.ldY + (220 - self.ldY) / 20
        elseif t <= 420 then
            local a = floor((t - 210) * 0x10000 / 210)
            local dx, dy = Core.ellipse(a, 160, 75, 0x900)
            self.ldX, self.ldY = 320 + dx, 220 + dy
        elseif t >= 450 then
            setState(self, 2)
        end
    else
        bossMove(self, rt, 0.7, 50, 170, 550, 160, 340, 0x11d0)
        if t >= 800 then setState(self, 1) end
    end
end

local function pattern125(self, rt, owner)
    local t = self.helperTimer
    local right = self.spawnType == 0x125
    bossMove(self, rt, 0.3, 50,
        right and 360 or 80, right and 600 or 320, 160, 320,
        self.spawnType)
    local cycle = (t - 10) % 1800
    if cycle == 30 or cycle == 450 or cycle == 900 then
        fan(7, 0, self.ldX, self.ldY, aim(self), 8, 5, 6000)
    end
    if cycle >= 60 and cycle < 420 and cycle % 28 == (right and 0 or 14) then
        fan(7, 0, self.ldX, self.ldY,
            aim(self) + sin(cycle * pi / 100) * (right and 5000 or -5000),
            7.5, 13, 12000)
    elseif cycle >= 480 and cycle < 870 then
        if right and cycle % 36 == 0 then
            for offset = -1, 1 do
                fan(5, 0, self.ldX, self.ldY, aim(self) + offset * 7000,
                    7, 11, 7000)
            end
        elseif not right and cycle % 6 == 0 then
            for arm = 0, 6 do
                fire(8, 1, self.ldX, self.ldY,
                    -cycle * 211 + floor(arm * 0x10000 / 7), 5.5)
            end
        end
    elseif cycle >= 930 and cycle < 1790 and cycle % 32 < 18 and cycle % 3 == 0 then
        local sign = right and 1 or -1
        for arm = 0, 12 do
            fire(right and 3 or 5, 1, self.ldX, self.ldY,
                sign * cycle * 173 + floor(arm * 0x10000 / 13),
                5 + (cycle % 32) * 0.08)
        end
    end
end

local finalDevicePatterns = {
    [0x111] = pattern111, [0x112] = pattern112,
    [0x113] = pattern113, [0x115] = pattern115,
    [0x11a] = pattern11a, [0x11d] = pattern11d,
    [0x125] = pattern125, [0x126] = pattern125,
}

local function finalMainDevice(self, rt)
    local owner = finalDeviceOwner(self)
    if not owner then remove(self); return end
    configureVisual(self, (self.spawnType - 0x111 + 10) % 30,
        self.spawnType == 0x115 and 40 or 70)
    if breakFinalDevice(self, owner) then return end
    local duration = (self.spawnType == 0x125 or self.spawnType == 0x126) and 250 or 190
    local attackable = self.spawnType ~= 0x115
    if not materializeDevice(self, owner, duration, attackable) then return end
    syncDeviceHp(self, owner)
    local pattern = finalDevicePatterns[self.spawnType]
    pattern(self, rt, owner)
end

for typeId, _ in pairs(finalDevicePatterns) do handlers[typeId] = finalMainDevice end

handlers[0x114] = function(self, rt)
    local device = parentOf(self)
    local owner = device and parentOf(device)
    if not device or not owner or owner._blPhase ~= 6 then remove(self); return end
    configureVisual(self, 15, 22)
    self.targetable = false
    local t = self.helperTimer
    if t < 40 then follow(self, device, self._blOffsetX, self._blOffsetY, 5); return end
    local cycle = (t - 40) % 1200
    local index = self._blIndex or 0
    if cycle < 420 then
        follow(self, device, self._blOffsetX, self._blOffsetY, 4)
        self.angle16 = Core.turn16(self.angle16, aim(self), 0x80)
        local q = cycle % 35
        if cycle >= 20 and q < 20 and q % 5 == 0 then
            fire(10, 1, self.ldX, self.ldY, self.angle16, 8)
        end
    else
        local sign = index % 2 == 0 and 1 or -1
        local a = Core.angle16(index * 0x4000 + cycle * sign * 750)
        local dx, dy = Core.polar(a, 150)
        follow(self, device, dx, dy, 4)
        if cycle >= 450 and cycle < 1160 and cycle % 3 == 0 then
            fire(10, 1, self.ldX, self.ldY, a + sign * 0x4000, 5)
        end
    end
end

local droneWaypoint = {
    {-220, -100}, {-120, 80}, {0, -40}, {120, 80}, {220, -100}, {0, 180},
}

local function finalDrone(self, rt)
    local controller = parentOf(self)
    local owner = controller and parentOf(controller)
    if not controller or not owner or owner._blPhase ~= 8 then remove(self); return end
    configureVisual(self, self.spawnType - 0x116 + 16, 28)
    if controller._blDeviceBreaking then
        spawnPostDeathCounterOnce(self, 72)
        self.targetable = false
        self.protect = true
        local reward = LikeDreamer.Reward
        if not self._blDroneBreaking then
            self._blDroneBreaking = true
            self._blDroneBreakTimer = 1
            if reward and reward.spawnStage02DeathExplosionChain then
                reward.spawnStage02DeathExplosionChain(self, 0)
            end
            return
        end
        local timer = self._blDroneBreakTimer or 1
        if timer < 90 then
            if reward and reward.spawnStage02DeathExplosionChain then
                reward.spawnStage02DeathExplosionChain(self, timer)
            end
            self.ldY = self.ldY + timer * 0.02
        elseif timer == 90 then
            playStageSound(rt, "ld_se_Blast2", 0.5)
            if reward and reward.spawnEnemyDeathEffects then
                reward.spawnEnemyDeathEffects(self, 1, false)
            end
        end
        self._blDroneBreakTimer = timer + 1
        if timer >= 140 then remove(self) end
        return
    end
    if self.hp <= 0 then
        spawnPostDeathCounterOnce(self, 72)
        owner.hp = owner.hp - max(1, self.maxhp or 1)
        local reward = LikeDreamer.Reward
        if reward and reward.spawnEnemyDeathEffects then
            reward.spawnEnemyDeathEffects(self, 2)
        end
        self.hp = 1
        remove(self)
        return
    end
    self.targetable = owner.targetable
    if not self._blDroneInit then
        self._blDroneInit = true
        self.state = 1
        self.helperTimer = 0
        self._blWaypoint = (self._blIndex or 0) % #droneWaypoint + 1
        self._blFromX, self._blFromY = self.ldX, self.ldY
    end
    local t = self.helperTimer
    if self.state == 1 or self.state == 3 then
        local target = droneWaypoint[self._blWaypoint]
        local tx, ty = owner.ldX + target[1], owner.ldY + target[2]
        local q = min(1, t / 40)
        local ease = sin(q * pi * 0.5)
        self.ldX = self._blFromX + (tx - self._blFromX) * ease
        self.ldY = self._blFromY + (ty - self._blFromY) * ease
        if t >= 40 then
            self._blWaypoint = self._blWaypoint % #droneWaypoint + 1
            setState(self, self.state + 1)
        end
    else
        local q = t
        if self.spawnType == 0x116 and q >= 10 and q <= 40 and q % 4 == 0 then
            if q == 10 then self._blAim = aim(self) end
            fan(0x0b, 1, self.ldX, self.ldY, self._blAim,
                7, 4, (q - 10) * 350)
        elseif self.spawnType == 0x117 and q >= 10 and q <= 40 then
            fire(0x0c, 2,
                self.ldX + randomRange(self, rt, q, -20, 20), self.ldY,
                randomInt(self, rt, q + 1, 0, 0xffff),
                randomRange(self, rt, q + 2, 3, 6))
        elseif self.spawnType == 0x118 and q >= 10 and q <= 60 and q % 15 == 0 then
            fan(3, 1, self.ldX, self.ldY, aim(self), 7, 5, 9000)
        elseif self.spawnType == 0x119 and q >= 10 and q <= 60 and q % 5 == 0 then
            local a = aim(self) + sin(q * pi / 50) * 9000
            fire(4, 0, self.ldX - 20, self.ldY, a, 2.5 + q * 0.14)
            fire(4, 0, self.ldX + 20, self.ldY, a + 0x8000, 2.5 + q * 0.14)
        end
        if t >= 80 then
            self._blFromX, self._blFromY = self.ldX, self.ldY
            setState(self, self.state == 2 and 3 or 1)
        end
    end
    if self.ldY > 860 then remove(self) end
end

for typeId = 0x116, 0x119 do handlers[typeId] = finalDrone end

local function finalStructure(self, rt)
    local device = parentOf(self)
    local owner = device and parentOf(device)
    if not device or not owner or owner._blPhase ~= 10 then remove(self); return end
    configureVisual(self, self.spawnType - 0x11b + 20, 28)
    follow(self, device, self._blOffsetX, self._blOffsetY, 5)
    self.targetable = false
end

handlers[0x11b] = finalStructure
handlers[0x11c] = finalStructure

local function finalBattery(self, rt)
    local device = parentOf(self)
    local owner = device and parentOf(device)
    if not device or not owner or owner._blPhase ~= 12 then remove(self); return end
    configureVisual(self, (self.spawnType - 0x11e + 22) % 30, 24)
    follow(self, device, self._blOffsetX, self._blOffsetY, 4)
    self.targetable = device.targetable and owner.targetable
    if self.targetable then
        local shared = min(self.hp, device.hp, owner.hp)
        self.hp, device.hp, owner.hp = shared, shared, shared
    end
    local T = device.helperTimer
    if device.state == 1 then
        if self.spawnType == 0x11e and T >= 70 and T < 390 then
            local q = (T - 70) % 210
            if q < 110 and q % 8 == 0 then
                local a = aim(self) + randomInt(self, rt, T, -1200, 1200)
                fire(7, 0, self.ldX, self.ldY, a, 7.5)
                fan(7, 0, self.ldX, self.ldY, aim(self), 6, 7, 9000)
                fan(8, 0, self.ldX, self.ldY, aim(self), 8, 7, 9000)
            end
        elseif self.spawnType == 0x120 and T >= 30 and T < 390 then
            local q = (T - 30) % 210
            if q < 150 and q % 10 == 0 then
                local sign = self._blOffsetX < 0 and -1 or 1
                fan(sign < 0 and 4 or 0, 0, self.ldX, self.ldY,
                    aim(self) + sign * 3000, 7, 3, 3000)
            end
        end
    elseif device.state == 2 then
        if self.spawnType == 0x11f and T >= 50 and T < 720 and
           (T - 50) % 48 == 0 then
            local slot = floor((T - 50) / 48) % 14
            local useLeft = slot % 2 == 0
            if (self._blOffsetX < 0) == useLeft then
                spawnChild(rt, self, 0x123, 1, 0, 0, slot,
                    aim(self), 0, "stage10 battery burst")
            end
        elseif self.spawnType == 0x122 and T >= 10 and T < 720 and
               (T - 10) % 30 == 0 then
            spawnChild(rt, self, 0x124, 1, 0, 0, T,
                aim(self), 0, "stage10 battery burst")
        end
    end
end

for typeId = 0x11e, 0x122 do handlers[typeId] = finalBattery end

local phase15TravelStates = {
    [1] = true, [2] = true, [3] = true, [4] = true,
    [6] = true, [7] = true, [9] = true, [11] = true,
    [14] = true, [16] = true, [25] = true,
}

local phase15AttackStates = {
    [5] = 90, [8] = 60, [10] = 90, [12] = 120, [13] = 120,
}

handlers[0x127] = function(self, rt)
    local owner = parentOf(self)
    if not owner or owner.spawnType ~= 0x141 or owner._blPhase ~= 15 then
        remove(self)
        return
    end
    configureVisual(self, 26, 70)
    if not materializeDevice(self, owner, 270, true) then return end
    syncDeviceHp(self, owner)
    local t = self.helperTimer
    if owner.state == 142 and self.state < 98 then
        self._blFromX, self._blFromY = self.ldX, self.ldY
        setState(self, 98)
        return
    elseif self.state == 98 then
        local q = min(1, t / 35)
        local ease = sin(q * pi * 0.5)
        self.ldX = self._blFromX + (owner.ldX - self._blFromX) * ease
        self.ldY = self._blFromY + (owner.ldY - self._blFromY) * ease
        if t >= 35 then setState(self, 99) end
        return
    elseif self.state == 99 then
        self.targetable = false
        if t < 180 and t % 2 == 0 then
            spawnChild(rt, self, 0x12a, 1, 0, 0, t,
                randomInt(self, rt, t, 0, 0xffff), 0)
        end
        if t >= 300 then remove(self) end
        return
    end

    if phase15TravelStates[self.state] then
        if t == 1 or not self._blTravelX then
            self._blFromX, self._blFromY = self.ldX, self.ldY
            self._blTravelX = randomRange(self, rt, self.state * 100, 160, 560)
            self._blTravelY = randomRange(self, rt, self.state * 100 + 1, 200, 500)
        end
        local q = min(1, t / 35)
        local ease = sin(q * pi * 0.5)
        self.ldX = self._blFromX + (self._blTravelX - self._blFromX) * ease
        self.ldY = self._blFromY + (self._blTravelY - self._blFromY) * ease
        if t >= 35 then
            self._blTravelX, self._blTravelY = nil, nil
            setState(self, self.state + 1)
        end
    elseif phase15AttackStates[self.state] then
        local px, py = playerPosition()
        self.ldX = self.ldX + (px - self.ldX) / 80
        self.ldY = self.ldY + (py - 180 - self.ldY) / 80
        if t == 40 then
            local emitterType = self.state == 13 and 0x12c or 0x12b
            for i = 0, 3 do
                spawnChild(rt, self, emitterType, 1, 0, 0, i,
                    floor(i * 0x10000 / 4), 4)
            end
            if self.state ~= 13 then ring(0x0c, 1, self.ldX, self.ldY, 0, 4.5, 20) end
        end
        if t >= phase15AttackStates[self.state] then setState(self, self.state + 1) end
    elseif self.state == 15 then
        if t == 90 then
            for i = 0, 31 do
                spawnChild(rt, self, 0x129, 1, 0, 0, i,
                    randomInt(self, rt, i, 0, 0xffff),
                    randomRange(self, rt, i + 50, 2, 6))
            end
        elseif t == 100 then
            self.ldX, self.ldY = -1000, -1000
            self.targetable = false
        elseif t >= 150 and t < 690 then
            local cadence = t < 500 and 24 or 6
            if (t - 150) % cadence == 0 then
                local x = randomRange(self, rt, t, 40, 680)
                fire(8, 0x3c, x, -20,
                    randomInt(self, rt, t + 1, 0x2800, 0x5800),
                    randomRange(self, rt, t + 2, 4, 8))
            end
        elseif t >= 720 then
            self.ldX, self.ldY = owner.ldX, owner.ldY
            self.targetable = true
            setState(self, 16)
        end
    elseif self.state == 17 then
        self.targetable = false
        if t >= 20 then self.targetable = true; setState(self, 18) end
    elseif self.state >= 18 and self.state <= 20 then
        if t == 50 then
            ring(7, 0, self.ldX, self.ldY,
                randomInt(self, rt, t + self.state, 0, 0xffff),
                5 + self.state - 18, 17)
        elseif t >= 90 then setState(self, self.state + 1) end
    elseif self.state >= 21 and self.state <= 23 then
        if t == 70 then
            for layer = 0, 3 do
                ring(3 + layer % 2, 0, self.ldX, self.ldY,
                    randomInt(self, rt, t + layer, 0, 0xffff),
                    4 + layer * 1.2, 27 + layer * 2)
            end
            for i = 1, 128 do
                local orbit = randomInt(self, rt, i + self.state * 200, 0, 0xffff)
                local dx, dy = Core.ellipse(orbit, 96, 192,
                    randomInt(self, rt, i + 300, 0, 0xffff))
                fire(i % 2 == 0 and 3 or 5, 0,
                    self.ldX + dx, self.ldY + dy,
                    randomInt(self, rt, i + 400, 0, 0xffff),
                    randomRange(self, rt, i + 500, 5, 18))
            end
        elseif t >= 120 then setState(self, self.state + 1) end
    elseif self.state == 24 then
        if t >= 35 then setState(self, 25) end
    elseif self.state == 26 then
        if t < 120 then
            local px, py = playerPosition()
            self.ldX = self.ldX + (px - self.ldX) / 50
            self.ldY = self.ldY + (py - 150 - self.ldY) / 50
        else
            local a = Core.angle16(t * 0x180)
            local dx, dy = Core.ellipse(a, 80, 90, 0x900)
            self.ldX, self.ldY = owner.ldX + dx, owner.ldY + dy
        end
        if t == 80 then
            for i = 1, 155 do
                fire(i % 2 == 0 and 3 or 5, 0, self.ldX, self.ldY,
                    randomInt(self, rt, i, 0, 0xffff),
                    randomRange(self, rt, i + 200, 2, 12))
            end
        elseif t >= 180 then setState(self, 27) end
    elseif self.state >= 27 and self.state <= 31 then
        if t == 0 then
            local side = self.state % 2 == 0 and -1 or 1
            self.ldX = side < 0 and -80 or 800
            self.ldY = 80 + (self.state - 27) * 110
            self.angle16 = side < 0 and 0 or 0x8000
            self.speed = 0
        elseif t > 49 then
            self.speed = self.speed + 0.15
            move(self)
            local a = randomInt(self, rt, t + self.state * 100, 0, 0xffff)
            local r = randomRange(self, rt, t + self.state * 101, 0, 110)
            local dx, dy = Core.polar(a, r)
            if Core.inside(self.ldX + dx, self.ldY + dy, 0) then
                fire(7, 0, self.ldX + dx, self.ldY + dy,
                    self.angle16 + randomInt(self, rt, t + 2, -8000, 8000),
                    randomRange(self, rt, t + 3, 1, 2.5))
            end
            if t < 140 then
                local orbit = Core.angle16(t * 0x9c4)
                local x1, y1 = Core.ellipse(orbit, 110, 132, self.angle16)
                local x2, y2 = Core.ellipse(-orbit, 80, 100, self.angle16)
                fire(8, 0, self.ldX + x1, self.ldY + y1,
                    self.angle16, 3)
                fire(8, 0, self.ldX + x2, self.ldY + y2,
                    self.angle16, 3)
            end
        end
        if t >= 180 then
            if self.state < 31 then setState(self, self.state + 1)
            else setState(self, 1) end
        end
    end
end

handlers[0x12d] = function(self, rt)
    local owner = parentOf(self)
    if not owner or owner.spawnType ~= 0x141 or owner._blPhase ~= 16 then
        remove(self)
        return
    end
    configureVisual(self, 27, 75)
    if owner.state == 152 or owner.state == 153 or owner.state == 200 then
        if not self._blDeviceBreaking then
            self._blDeviceBreaking = true
            local counterAllowed = owner._bl12dCounterAllowed
            if counterAllowed == nil then
                counterAllowed = (owner.countdown or 0) >= 1500
            end
            if counterAllowed then
                spawnPostDeathCounterOnce(self, 140)
            end
        end
        self.targetable = false
        self.protect = true
        self._blDeathTimer = (self._blDeathTimer or 0) + 1
        if self._blDeathTimer >= 140 then remove(self) end
        return
    end
    if not materializeDevice(self, owner, 250, true) then return end
    syncDeviceHp(self, owner)
    follow(self, owner, 0, 60, 5)
    if self.state == 1 and owner.hp < owner.maxhp * 0.75 then setState(self, 2)
    elseif self.state == 2 and owner.hp < owner.maxhp * 0.5 then setState(self, 3) end
    local base = ({0x12e, 0x130, 0x132})[self.state] or 0x12e
    local t = self.helperTimer
    if t >= 10 and (t - 10) % 360 == 0 then
        spawnChild(rt, self, base, 1, 0, 0, t, 0, 0,
            "stage10 final even emitter")
    end
    if t >= 190 and (t - 190) % 360 == 0 then
        spawnChild(rt, self, base + 1, 1, 0, 0, t, 0x8000, 0,
            "stage10 final odd emitter")
    end
end

local function finalAuxOwner(self)
    local owner = parentOf(self)
    if not owner then return nil end
    local root = rootOf(self)
    if not root or root.spawnType ~= 0x141 then return nil end
    return owner, root
end

local function finalMovingEmitter(self, rt)
    local owner, root = finalAuxOwner(self)
    if not owner or (self._blOwnerPhase and root._blPhase ~= self._blOwnerPhase) then
        remove(self)
        return
    end
    configureVisual(self, (self.spawnType - 0x105) % 30, 16)
    self.targetable = false
    local typeId, t = self.spawnType, self.helperTimer
    if typeId == 0x10a or typeId == 0x10b then
        remove(self)
        return
    end
    if not self._blAuxInit then
        self._blAuxInit = true
        self.secondaryAngle16 = self.angle16
        if typeId == 0x128 then
            local dx, dy = Core.polar(self.angle16, 600)
            self.ldX, self.ldY = owner.ldX + dx, owner.ldY + dy
        end
    end

    if typeId == 0x105 then
        self.speed = self.speed + 0.15
        move(self)
        fire(0x0f, 0x0f, self.ldX, self.ldY, self.angle16, 0)
        if t == 16 then fire(3, 2, self.ldX, self.ldY, aim(self), 7.5) end
    elseif typeId == 0x106 then
        self.angle16 = Core.angle16(self.angle16 + sin(t * pi / 60) * 360)
        move(self)
        fire(0x10, 0x10, self.ldX, self.ldY, self.angle16, 0)
    elseif typeId == 0x107 then
        self.speed = self.speed + 0.07
        move(self)
        if not self._blReflected and not Core.inside(self.ldX, self.ldY, -5) then
            self.angle16 = Core.angle16(0x8000 - self.angle16)
            self.ldX, self.ldY = Core.clampToPlayfield(self.ldX, self.ldY, 0)
            self._blReflected = true
        end
        fire(0x10, 0x10, self.ldX, self.ldY, self.angle16, 0)
    elseif typeId == 0x108 or typeId == 0x109 then
        local sign = typeId == 0x108 and 1 or -1
        self.angle16 = Core.angle16(self.angle16 + sign * 0x400)
        move(self)
        if t % 2 == 0 then
            fan(0x0d, 3, self.ldX, self.ldY, self.angle16,
                5.5, 5, 0x10000)
        end
        fire(0x10, 0x10, self.ldX, self.ldY, self.angle16, 0)
        if t >= 64 then remove(self) end
    elseif typeId == 0x10c or typeId == 0x10d then
        local sign = typeId == 0x10c and 1 or -1
        self.angle16 = Core.angle16(self.angle16 + sign *
            floor(sin(t * pi / 60) * 280))
        move(self)
        fire(0x10, 0x10, self.ldX, self.ldY, self.angle16, 0)
        if t == 25 then fire(3, 2, self.ldX, self.ldY, aim(self), 8) end
    elseif typeId == 0x10e then
        self.speed = self.speed + 0.07
        move(self)
        if not self._blReflected and not Core.inside(self.ldX, self.ldY, -5) then
            local left = Core.playfieldOriginX()
            if self.ldX <= left or self.ldX >= left + 600 then
                self.angle16 = Core.angle16(0x8000 - self.angle16)
            else
                self.angle16 = Core.angle16(-self.angle16)
            end
            self._blReflected = true
        end
        fire(0x0f, 0x0f, self.ldX, self.ldY, self.angle16, 0)
    elseif typeId == 0x10f or typeId == 0x110 then
        if not self._blEdgeInit then
            self._blEdgeInit = true
            self._blTurns = 0
        end
        move(self)
        local left = Core.playfieldOriginX()
        if self.ldY <= 0 or self.ldY >= 720 or
           self.ldX <= left or self.ldX >= left + 600 then
            self.angle16 = Core.angle16(self.angle16 +
                (typeId == 0x10f and 0x4000 or -0x4000))
            self._blTurns = self._blTurns + 1
            self.ldX, self.ldY = Core.clampToPlayfield(self.ldX, self.ldY, 0)
        end
        if t % 2 == 0 then
            local a = aim(self)
            fire(7, 0, self.ldX, self.ldY, a, 6)
            fire(7, 0, self.ldX, self.ldY, a, 9)
        end
        if self._blTurns >= 4 then remove(self) end
    end
    if t > 20 and not Core.inside(self.ldX, self.ldY, 180) then remove(self) end
end

for typeId = 0x105, 0x110 do handlers[typeId] = finalMovingEmitter end

local function finalBurstEmitter(self, rt)
    local owner = parentOf(self)
    local root = rootOf(self)
    if not owner or not root or root.spawnType ~= 0x141 then remove(self); return end
    configureVisual(self, self.spawnType - 0x123 + 24, 14)
    self.targetable = false
    local t = self.helperTimer
    local lifetime = self.spawnType == 0x123 and 70 or 50
    if t >= 10 then
        self.speed = 2 * sin(min(1, (t - 10) / max(1, lifetime - 10)) * pi * 0.5)
        move(self)
    end
    if t == lifetime then
        local layers = self.spawnType == 0x123 and 5 or 3
        local projectileId = self.spawnType == 0x123 and 0x3a or 0x3b
        for layer = 0, layers - 1 do
            fan(8, projectileId, self.ldX, self.ldY, self.angle16,
                0, diff(rt, {9, 13, 17, 21, 25}), 0x10000,
                layer * 25)
        end
        remove(self)
    end
end

handlers[0x123] = finalBurstEmitter
handlers[0x124] = finalBurstEmitter

local function phase15Aux(self, rt)
    local owner = parentOf(self)
    local root = rootOf(self)
    if not owner or not root or root.spawnType ~= 0x141 then remove(self); return end
    configureVisual(self, (self.spawnType - 0x128 + 25) % 30, 12)
    self.targetable = false
    local typeId, t = self.spawnType, self.helperTimer
    if typeId == 0x128 then
        if not self._blCollapseStart then
            self._blCollapseStart = true
            local dx, dy = Core.polar(self.angle16, 600)
            self._blFromX, self._blFromY = owner.ldX + dx, owner.ldY + dy
        end
        local q = min(1, t / 60)
        self.ldX = self._blFromX + (owner.ldX - self._blFromX) * sin(q * pi * 0.5)
        self.ldY = self._blFromY + (owner.ldY - self._blFromY) * sin(q * pi * 0.5)
        if t >= 60 then remove(self) end
    elseif typeId == 0x129 then
        move(self)
        self.ldY = self.ldY - t * 0.2
        if not Core.inside(self.ldX, self.ldY, 50) then remove(self) end
    elseif typeId == 0x12a then
        self.speed = self.speed + 0.3
        move(self)
        if not Core.inside(self.ldX, self.ldY, 50) then remove(self) end
    else
        self.angle16 = Core.angle16(self.angle16 + 0x51e)
        self.secondaryAngle16 = Core.angle16(self.secondaryAngle16 + 0x834)
        move(self)
        for i = -1, 1 do
            fire(8, 0x11, self.ldX, self.ldY,
                self.secondaryAngle16 + i * 0x5555, 0)
        end
        if typeId == 0x12c and t < 50 and t % 2 == 0 then
            fire(8, 3, self.ldX, self.ldY, self.angle16 + 0x3000, 6)
            fire(8, 3, self.ldX, self.ldY, self.angle16 - 0x3000, 6)
        end
        if t >= 50 then remove(self) end
    end

    if typeId >= 0x128 and typeId <= 0x12a then
        local seed = t * 0x22b8 + (self.entityId or 0)
        local radius = stageFrameRand(seed) % 0x11
        local offsetAngle = stageRandomAngle(
            t * 0x378 + (self.entityId or 0))
        local offsetX, offsetY = Core.polar(offsetAngle, radius)
        local palette = {
            {0xff, 0x78, 0x78}, {0xff, 0xc8, 0x6e},
            {0xff, 0xff, 0x78}, {0x78, 0xff, 0x78},
            {0x78, 0xff, 0xff}, {0x78, 0x78, 0xff},
            {0xdc, 0x78, 0xff},
        }
        local color = palette[floor(t / 3) % #palette + 1]
        spawnStageEffect(rt, {
            kind = "phase15_particle", img = "ld_effect_s_18",
            x = self.ldX + offsetX, y = self.ldY + offsetY,
            angle16 = stageRandomAngle(t * 0x58 + (self.entityId or 0)),
            scale = scriptRandomHundredth(
                t * 0x15b38 + (self.entityId or 0), 0.5, 1.0),
            lifetime = 0x10, alpha = 0xc0,
            red = color[1], green = color[2], blue = color[3],
            layer = stageEffectLayer(0x22), initialAge = -1,
            sourceFrame = rt.frame or 0,
        })
    end
end

for typeId = 0x128, 0x12c do handlers[typeId] = phase15Aux end

local function phase16Emitter(self, rt)
    local owner = parentOf(self)
    local root = rootOf(self)
    local typeId = self.spawnType
    local wrongSubphase = (typeId <= 0x133 and root and root.state ~= 151) or
                          (typeId >= 0x134 and root and root.state ~= 153)
    if not owner or not root or root.spawnType ~= 0x141 or
       root.state == 200 or wrongSubphase then
        remove(self)
        return
    end
    configureVisual(self, (self.spawnType - 0x12e + 4) % 30, 16)
    self.targetable = false
    local t = self.helperTimer
    local sign = self.spawnType % 2 == 0 and 1 or -1
    local orbit = Core.angle16((self.angle16 or 0) + sign * t * 0x180)
    local dx, dy = Core.polar(orbit, t * 0.48)
    self.ldX, self.ldY = owner.ldX + dx, owner.ldY + dy
    if t >= 30 and t < 390 then
        local localTime = t - 30
        if self.spawnType == 0x12e or self.spawnType == 0x12f then
            if localTime % 5 == 0 then
                for arm = 0, 5 do
                    fire(self.spawnType == 0x12e and 4 or 5, 1,
                        self.ldX, self.ldY,
                        sign * localTime * 180 + floor(arm * 0x10000 / 6),
                        6 + localTime * 0.01)
                end
            end
        elseif self.spawnType == 0x130 or self.spawnType == 0x131 then
            if localTime % 10 < 5 then
                for arm = 0, 3 do
                    fire(self.spawnType == 0x130 and 0x0c or 0x0d, 0,
                        self.ldX, self.ldY,
                        sign * localTime * 160 + floor(arm * 0x10000 / 4),
                        5.5 + localTime * 0.008)
                end
            end
        elseif self.spawnType == 0x132 or self.spawnType == 0x133 then
            if localTime % 6 == 0 then
                for layer = 0, 3 do
                    fire(7, 0, self.ldX, self.ldY,
                        orbit + sign * 0x4000, 7.2 + localTime * 0.006 + layer)
                    fire(8, 0, self.ldX, self.ldY,
                        orbit - sign * 0x4000, 7.2 + localTime * 0.006 + layer)
                end
            end
        else
            if localTime % 7 == 0 then
                for arm = 0, 3 do
                    local a = floor(arm * 0x10000 / 4) + sign * localTime * 150
                    fire(self.spawnType == 0x134 and 0x0c or 0x0d, 0,
                        self.ldX, self.ldY, a, 5.5 + localTime * 0.009)
                    fire(self.spawnType == 0x134 and 2 or 3, 0,
                        self.ldX, self.ldY, a + 0x2000, 5.5 + localTime * 0.009)
                end
            end
        end
    end
    if t >= 410 then remove(self) end
end

for typeId = 0x12e, 0x135 do handlers[typeId] = phase16Emitter end

handlers[0x136] = function(self, rt)
    local owner = parentOf(self)
    if not owner then remove(self); return end
    configureVisual(self, 29, 180)
    follow(self, owner, 0, 0, 2)
    self.targetable = false
    self.protect = true
    if not playerBlocking() or self._blFade then
        self._blFadeTimer = (self._blFadeTimer or 0) + 1
        if self._blFadeTimer >= 16 then
            owner.protect = false
            remove(self)
        end
    else
        owner.protect = true
    end
end

function M.Dispatcher:initialize(entity)
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
    if entity.protect == nil then entity.protect = false end
end

function M.Dispatcher:update(entity, rt)
    if entity.spawnType == 0xad and entity.parentSpawnType ~= 0x13f then
        return false
    end
    local handler = self.handlers[entity.spawnType]
    if not handler then return false end

    self:initialize(entity)
    handler(entity, rt)
    applyExactLayer(entity)
    if ensureRenderProxies then ensureRenderProxies(entity) end
    -- Late boss nodes own their off-screen parking and removal.  Several
    -- devices intentionally keep firing outside the playfield before they
    -- return, so enemy.lua's generic seen/out-of-bounds cull must not apply.
    entity.seen = false
    return true
end

M._dispatcher = M.Dispatcher.new(handlers)

function M.update(self, rt)
    return M._dispatcher:update(self, rt)
end

local invisibleTypes = {
    [0x151] = true, [0x152] = true, [0x153] = true,
}

local rootTypes = {
    [0x13f] = true, [0x140] = true, [0x141] = true, [0x14c] = true,
    [0x146] = true, [0x147] = true, [0x148] = true,
    [0x149] = true, [0x14a] = true, [0x14b] = true,
}

local function imageExists(name)
    return not lstg or not lstg.CheckRes or lstg.CheckRes(2, name)
end

local function atlas(prefix, frame, self, offsetX, offsetY,
                     angle16, scaleX, scaleY, reverse)
    local name = prefix .. tostring(frame + 1)
    if not imageExists(name) then return false end
    local sx = (scaleX or 1)
    local sy = (scaleY or scaleX or 1)
    if reverse then sx = -sx end
    Render(name,
        self.x + (offsetX or 0) * Core.worldScale(),
        self.y - (offsetY or 0) * Core.worldScaleY(),
        Core.angleToDeg(angle16 or 0), sx, sy)
    return true
end

function M.atlasStyled(prefix, frame, self, offsetX, offsetY,
                       angle16, scaleX, scaleY, reverse,
                       blend, alpha, red, green, blue)
    local name = prefix .. tostring(frame + 1)
    if not imageExists(name) or (alpha ~= nil and alpha <= 0) then return false end
    local setter = rawget(_G, "SetImageState") or
        (rawget(_G, "lstg") and lstg.SetImageState)
    local color = rawget(_G, "Color")
    if type(setter) == "function" and type(color) == "function" then
        setter(name, blend or "", color(
            floor(Core.clamp(alpha == nil and 255 or alpha, 0, 255)),
            floor(Core.clamp(red == nil and 255 or red, 0, 255)),
            floor(Core.clamp(green == nil and 255 or green, 0, 255)),
            floor(Core.clamp(blue == nil and 255 or blue, 0, 255))))
    end
    local drew = atlas(prefix, frame, self, offsetX, offsetY,
        angle16, scaleX, scaleY, reverse)
    if type(setter) == "function" and type(color) == "function" then
        setter(name, "", color(255, 255, 255, 255))
    end
    return drew
end

function M.smoothStep(value)
    value = Core.clamp(value, 0, 1)
    return value * value * (3 - 2 * value)
end

function M.pulseAlpha(timer)
    return floor(Core.clamp(0x80 + sin((timer or 0) * pi / 20) * 128,
        0, 255))
end

M.stage8Palette = {
    {0xff, 0x78, 0x78}, {0xff, 0xc8, 0x6e},
    {0xff, 0xff, 0x78}, {0x78, 0xff, 0x78},
    {0x78, 0xff, 0xff}, {0x78, 0x78, 0xff},
    {0xdc, 0x78, 0xff},
}

local function bossFrame(frame, self, ox, oy, angle, sx, sy, reverse)
    return atlas("ld_boss_", frame, self, ox, oy, angle, sx, sy, reverse)
end

local function largeFrame(frame, self, ox, oy, angle, sx, sy, reverse)
    return atlas("ld_enemy_l_", frame, self, ox, oy, angle, sx, sy, reverse)
end

local function extraLargeFrame(frame, self, ox, oy, angle, sx, sy, reverse)
    return atlas("ld_enemy_xl_", frame, self, ox, oy, angle, sx, sy, reverse)
end

local function mediumFrame(frame, self, ox, oy, angle, sx, sy, reverse)
    return atlas("ld_enemy_m_", frame, self, ox, oy, angle, sx, sy, reverse)
end

local function smallFrame(frame, self, ox, oy, angle, sx, sy, reverse)
    return atlas("ld_enemy_s_", frame, self, ox, oy, angle, sx, sy, reverse)
end

local gaugeProxyClass
local sceneBodyProxyClass
local sceneMarkerProxyClass

local function drawGauge(self, kind, offsetY)
    if self.spawnType >= 0x138 and self.spawnType <= 0x14c then return end
    if not self.targetable or not self.maxhp or self.maxhp <= 0 then return end
    local name = kind == 2 and "ld_enemy_gauge_1" or "ld_boss_gauge_1"
    if not imageExists(name) then return end
    Render(name, self.x,
        self.y - (offsetY or -(self.radius or 80) * 0.55) * Core.worldScaleY(),
        0, 0.6, 0.6)
end

local function renderGauge(self, kind, offsetY)
    -- Headless render mocks load this module without Class/New. Preserve that
    -- fallback while the game always draws gauges through the proxy below.
    if not gaugeProxyClass then drawGauge(self, kind, offsetY) end
end

local function renderShield(self)
    local t = self.helperTimer or 0
    local guard = self.spawnType == 0x136
    local peak = guard and 1.8 or 1.2
    local amplitude = guard and 1.7 or 1.1
    local scale = t < 32 and 0.1 + sin(t * pi / 64) * amplitude or peak
    local fade = self._blFadeTimer or 0
    local alpha = fade > 0 and
        floor(Core.clamp(sin((fade + 16) * pi / 32) * 255, 0, 255)) or 255
    local turn = (self.runtime and self.runtime.frame or t) * 0x400
    M.atlasStyled("ld_effect_l_", 6, self, 0, 0, turn,
        scale, scale, false, guard and "" or "mul+add", alpha)
    M.atlasStyled("ld_effect_l_", 6, self, 0, 0, -turn,
        scale, scale, true, guard and "" or "mul+add", alpha)
end

local function renderStage8Root(self)
    local state, t = self.state, self.helperTimer
    local source = max(0, (self.runtime and self.runtime.frame or 0) - 1)
    if state < 20 or (state == 20 and t < 130) then
        local fixedOffset = 360 - self.ldX
        local settled = state > 10 or (state == 10 and t > 120)
        local shellY = (settled and 12 or 8) +
            (settled and 0 or sin((source - 60) * tau / 180) * 3)
        M.atlasStyled("ld_stageback2_", 6, self, fixedOffset, 240, 0,
            1, 1, false, "", 255)
        largeFrame(56, self, fixedOffset, shellY)
        largeFrame(54, self)
        if state == 1 and t >= 0 and t < 24 then
            M.atlasStyled("ld_enemy_l_", 54, self, 0, 0, 0,
                1, 1, false, "mul+add", Core.clamp(32 + t * 7, 0, 160))
        end
        largeFrame(55, self, fixedOffset, shellY)
    end
    local coreVisible = (state >= 21 and state <= 29) or
                        (state == 20 and t >= 130) or
                        (state == 30 and t < 130)
    if coreVisible then
        local swing = sin(source * tau / 120) * 2000
        local pulse = 1 + sin(source * tau / 5) * 0.1
        local flareOffsets = {{20, -35}, {-20, -35}, {24, -48}, {-24, -48}}
        for index, offset in ipairs(flareOffsets) do
            M.atlasStyled("ld_effect_s_", 14, self,
                offset[1], offset[2], 0, 1, pulse, index % 2 == 0,
                "mul+add", 225)
        end
        bossFrame(59, self, 10, -15, swing)
        bossFrame(59, self, -10, -15, -swing, 1, 1, true)
        bossFrame(58, self)
    elseif state == 70 and t < 300 then
        local imageFrame = 108 + floor(t / 5) % 2
        bossFrame(imageFrame, self)
        M.atlasStyled("ld_boss_", imageFrame, self, 0, 0, 0,
            1, 1, false, "mul+add", 0x60)
    end
    renderGauge(self, 1)
end

local function renderStage8Node(self)
    local typeId, t = self.spawnType, self.helperTimer
    if typeId >= 0xa7 and typeId <= 0xaa then
        local reverse = (self._blIndex or 0) % 2 == 1
        mediumFrame(168, self, 0, 0, self.angle16, 1, 1, reverse)
        mediumFrame(167, self, 0, 0, self.angle16, 1, 1, reverse)
    elseif typeId == 0xab then
        M.atlasStyled("ld_enemy_m_", 166, self, 16, 9, self.angle16,
            1, 1, false, "", 0x40, 0, 0, 0)
        mediumFrame(166, self, 0, 0, self.angle16)
        if self.state == 2 then
            M.atlasStyled("ld_effect_m_", 18, self, 0, 0, self.angle16,
                0.8, 0.5, false, "", 0xc0)
        end
    elseif typeId == 0xac then
        local wave = sin(t * pi / 50)
        local baseY = 108 - wave * 3
        if self.state == 2 then
            mediumFrame(169, self, 0, baseY)
        else
            mediumFrame(163, self, 0, baseY)
            mediumFrame(164, self)
            if t >= 0 and t < 24 then
                M.atlasStyled("ld_enemy_m_", 164, self, 0, 0, 0,
                    1, 1, false, "mul+add",
                    sin((t + 24) * pi / 48) * 192)
            end
            mediumFrame(165, self, 0, baseY - 225 + wave * 6)
        end
    elseif typeId == 0xad then
        local radius = sin(t * pi / 30) * 4
        local dx, dy = Core.polar(self.angle16, radius)
        smallFrame(136, self, dx, dy, self.angle16)
        smallFrame(136, self, -dx, -dy, self.angle16 + 0x8000, 1, 1, true)
        smallFrame(135, self)
        M.atlasStyled("ld_enemy_s_", 135, self, 0, 0, 0,
            1, 1, false, "mul+add", M.pulseAlpha(t))
    elseif typeId >= 0xae and typeId <= 0xb6 then
        local entry = t < 10 and 0 or (t < 30 and sin((t - 10) * pi / 40) or 1)
        local blend, alpha = "", 255
        local red, green, blue = 255, 255, 255
        if typeId == 0xb4 or typeId == 0xb5 then
            blend, alpha = "mul+add", 0xc0
        elseif typeId == 0xb6 and t >= 60 then
            local envelope = t < 200 and sin((t - 60) * pi / 280) or 1
            entry = entry + 0.2 * sin(t * pi / 3.5) * envelope
            local tint = t < 200 and 255 - floor(envelope * 191) or 0x40
            green, blue = tint, tint
        end
        M.atlasStyled("ld_enemy_s_", 137, self, 0, 0, t * 0x309,
            entry, entry, false, blend, alpha, red, green, blue)
        local coreScale = t < 20 and 0.1 + sin(t * pi / 40) * 0.9 or 1
        smallFrame(135, self, 0, 0, 0, coreScale, coreScale)
        M.atlasStyled("ld_enemy_s_", 135, self, 0, 0, 0,
            coreScale, coreScale, false, "mul+add", M.pulseAlpha(t))
    elseif typeId == 0xb7 then
        local scale = self.state == 0 and t < 50 and
            (0.2 + sin(t * pi / 100) * 0.8) or 1
        local radius = sin(t * pi / 30) * 8 * scale
        local dx, dy = Core.polar(self.angle16, radius)
        smallFrame(136, self, dx, dy, self.angle16, scale, scale)
        smallFrame(136, self, -dx, -dy, self.angle16 + 0x8000,
            scale, scale, true)
        smallFrame(135, self, 0, 0, 0, scale, scale)
        M.atlasStyled("ld_enemy_s_", 135, self, 0, 0, 0,
            scale, scale, false, "mul+add", M.pulseAlpha(t))
    elseif typeId >= 0xb8 and typeId <= 0xba then
        local frame = typeId == 0xb8 and 57 or
                     (typeId == 0xb9 and 58 or (self.state == 0 and 60 or 59))
        local reverse = typeId == 0xba and (self._blOffsetX or 0) < 0
        local scale = 1
        if self.state == 1 then
            scale = typeId == 0xba and
                ({3.5, 4.5, 5, 5, 6})[difficulty(self.runtime or {}) + 1] or 3.5
        end
        local angle = reverse and self.angle16 + 0x8000 or self.angle16
        local red, green, blue = 255, 255, 255
        local breaking = self.state == 9 and t < 150
        if breaking then
            local first = floor(t / 20) % #M.stage8Palette + 1
            local second = first % #M.stage8Palette + 1
            local mix = (self.runtime and self.runtime.frame or 0) % 20 / 20
            red = M.stage8Palette[first][1] +
                (M.stage8Palette[second][1] - M.stage8Palette[first][1]) * mix
            green = M.stage8Palette[first][2] +
                (M.stage8Palette[second][2] - M.stage8Palette[first][2]) * mix
            blue = M.stage8Palette[first][3] +
                (M.stage8Palette[second][3] - M.stage8Palette[first][3]) * mix
        end
        M.atlasStyled("ld_enemy_l_", frame, self, 0, 0, angle,
            scale, scale, reverse, "", 255, red, green, blue)
        if breaking then
            M.atlasStyled("ld_enemy_l_", frame, self, 0, 0, angle,
                scale, scale, reverse, "mul+add", 255, red, green, blue)
        end
    elseif typeId == 0xbb then
        return
    elseif typeId >= 0xbc and typeId <= 0xc2 then
        local scale = self.state == 0 and t < 60 and
            (0.2 + sin(t * pi / 120) * 0.8) or 1
        local radius = -4 * scale
        local dx, dy = Core.polar(self.angle16, radius)
        local entranceTurn = self.state == 0 and t < 60 and
            -sin(t * pi / 120) * 0x20000 or 0
        local bladeAngle = self.secondaryAngle16 + entranceTurn
        local color = M.stage8Palette[typeId - 0xbc + 1]
        M.atlasStyled("ld_enemy_s_", 136, self, dx, dy, bladeAngle,
            scale, scale, false, "", 255, color[1], color[2], color[3])
        M.atlasStyled("ld_enemy_s_", 136, self, -dx, -dy,
            bladeAngle + 0x8000, scale, scale, true, "", 255,
            color[1], color[2], color[3])
        smallFrame(135, self, 0, 0, 0, scale, scale)
        M.atlasStyled("ld_enemy_s_", 135, self, 0, 0, 0,
            scale, scale, false, "mul+add", M.pulseAlpha(t))
    end
    if self.targetable and typeId ~= 0xb4 and typeId ~= 0xb5 then
        renderGauge(self, 2, -80)
    end
end

local function renderStage9Midboss(self)
    local typeId, state, t = self.spawnType, self.state, self.helperTimer
    local frame = max(0, (self.runtime and self.runtime.frame or 0) - 1)
    local deathAlpha = state == 2 and t >= 90 and
        Core.clamp((100 - t) * 25, 0, 255) or 255
    if typeId == 0x146 then
        M.atlasStyled("ld_enemy_l_", 0, self, 0, 0, 0,
            1, 1, false, "", deathAlpha)
    elseif typeId == 0x147 then
        for i = 0, 3 do
            M.atlasStyled("ld_enemy_l_", 8, self, 0, 90,
                frame * 600 + i * 0x4000, 1, 1, false, "", deathAlpha)
        end
        M.atlasStyled("ld_enemy_l_", 7, self, 0, 0, 0,
            1, 1, false, "", deathAlpha)
        local bf = state == 2 and 108 + floor(t / 5) % 2 or
            ({100, 101, 102, 101})[floor(t / 6) % 4 + 1]
        local orbit = {}
        for i = 0, 12 do
            local a = frame * 0xde + i * 0x13b1
            local dx, dy = Core.ellipse(a, 215, 120, 0)
            orbit[#orbit + 1] = {angle = Core.angle16(a), x = dx, y = dy}
            if Core.angle16(a) > 0x8000 then
                M.atlasStyled("ld_enemy_m_", 48, self, dx, dy, 0,
                    1, 1, true, "", deathAlpha)
            end
        end
        M.atlasStyled("ld_boss_", bf, self, 0, -160, 0,
            1, 1, false, "", min(deathAlpha, 0xc0), 0, 0, 0)
        M.atlasStyled("ld_boss_", bf, self, 0, -160, 0,
            1, 1, false, "", min(deathAlpha, 0xc0))
        for _, node in ipairs(orbit) do
            if node.angle <= 0x8000 then
                M.atlasStyled("ld_enemy_m_", 48, self, node.x, node.y, 0,
                    1, 1, false, "", deathAlpha)
            end
        end
    elseif typeId == 0x148 then
        M.atlasStyled("ld_enemy_l_", 13, self, 0, 0, 0,
            1, 1, false, "", deathAlpha)
        for i = 0, 3 do
            M.atlasStyled("ld_enemy_l_", 15, self, 0, -255,
                frame * 0x500 + i * 0x4000,
                1, 1, false, "", deathAlpha)
        end
    elseif typeId == 0x149 then
        local scale = state == 0 and (t < 180 and 0.3 + 0.7 * sin(t * pi / 360) or 0.3) or 1
        local brightness, alpha = 255, deathAlpha
        if state == 0 then
            brightness = 0
            if t < 60 then
                alpha = min(alpha, sin(t * pi / 120) * 255)
            elseif t < 180 then
                brightness = sin((t - 60) * pi / 240) * 255
            end
        end
        M.atlasStyled("ld_enemy_l_", 19, self, 0, 0, 0,
            scale, scale, false, "", alpha,
            brightness, brightness, brightness)
        local secondScale = scale
        local pulse = frame % 40
        if pulse < 11 then
            secondScale = secondScale - scale * 0.1 * sin(pulse * pi / 10)
        end
        M.atlasStyled("ld_enemy_l_", 20, self, 0, 0, 0,
            secondScale, secondScale, false, "", alpha,
            brightness, brightness, brightness)
    elseif typeId == 0x14a then
        M.atlasStyled("ld_enemy_l_", 29, self, 0, -110, 0,
            1, 1, false, "", deathAlpha)
        M.atlasStyled("ld_enemy_l_", 33, self, 0, -110, 0,
            1, 1, false, "", deathAlpha)
        local bf = state == 2 and 113 + floor(t / 5) % 2 or
            ({110, 111, 112, 111})[floor(t / 6) % 4 + 1]
        M.atlasStyled("ld_boss_", bf, self, 0, 0, 0,
            1, 1, false, "", min(deathAlpha, 0xc0))
        M.atlasStyled("ld_enemy_l_", 34, self, 0, -495, 0,
            1, 1, false, "", deathAlpha)
        local mx = {90, 156, -95, -156, 156, -156}
        local my = {-20, -20, 50, 50, -100, -100}
        local s = (t < 30 and 0.1 + 0.6 * sin(t * pi / 60) or 0.7) +
            0.2 * sin(t * tau / 9)
        for i = 1, 6 do
            M.atlasStyled("ld_enemy_s_", 56, self, mx[i], my[i], 0,
                s, s, false, "", min(deathAlpha, 0xc0))
        end
    else
        local spin = frame * 0xb6
        M.atlasStyled("ld_enemy_l_", 36, self, 0, 0, -spin,
            1, 1, false, "", deathAlpha)
        M.atlasStyled("ld_enemy_l_", 36, self, 0, 0, spin,
            1, 1, false, "", deathAlpha)
        M.atlasStyled("ld_enemy_l_", 37, self, 0, 0, self.secondaryAngle16,
            1, 1, false, "", deathAlpha)
        M.atlasStyled("ld_enemy_l_", 39, self, 0, 0, self.targetAngle16,
            1, 1, false, "", deathAlpha)
        M.atlasStyled("ld_enemy_l_", 38, self, 0, 0, self.targetAngle16,
            1, 1, false, "", deathAlpha)
        local dx, dy = Core.polar(self.targetAngle16, 90)
        M.atlasStyled("ld_enemy_m_", 103, self, dx, dy, self.targetAngle16,
            1, 1, false, "", deathAlpha)
    end
    renderGauge(self, 1)
end

local function renderStage9MidNode(self)
    local typeId, t = self.spawnType, self.helperTimer
    if typeId == 0xc4 or typeId == 0xc5 then
        local a = (t - 10) * 0x500
        local dx, dy = Core.polar(a, 40)
        smallFrame(14, self, dx, dy, a)
        smallFrame(14, self, -dx, dy, -a, 1, 1, true)
        smallFrame(11, self)
    elseif typeId == 0xc6 then
        local alpha = self.state == 0 and Core.clamp(t * 255 / 30, 0, 255) or 255
        M.atlasStyled("ld_enemy_m_", 170, self, 0, -50, 0,
            1, 1, false, "", 0x40, 0, 0, 0)
        M.atlasStyled("ld_enemy_m_", 170, self, 0, 50, 0,
            1, 1, false, "", alpha)
        M.atlasStyled("ld_enemy_s_", 20 + floor(t / 3) % 3,
            self, 0, -60, 0, 1, 1, false, "", alpha)
    elseif typeId == 0xc7 then
        mediumFrame(62, self, 0, 0, self.angle16)
    elseif typeId == 0xc8 then
        local parent = parentOf(self)
        if parent then
            local chainX = {50, 100, -50, -100, 140, -140}
            local chainY = {150, 140, 150, 140, 120, 120}
            local index = Core.clamp((self._blIndex or 0) + 1, 1, 6)
            local anchorX = parent.x + chainX[index] * Core.worldScale()
            local anchorY = parent.y - chainY[index] * Core.worldScaleY()
            local source = self.runtime and self.runtime.frame or 0
            for segment = 0, 19 do
                if not (self.state == -1 and t > 60 - segment * 3) then
                    local scale = 1
                    if self.state == 0 then
                        local start = segment * 2
                        if t < start then scale = 0
                        elseif t < start + 8 then
                            scale = sin((t - start) * pi / 16)
                        end
                    end
                    local q = segment / 20
                    local wx = anchorX + (self.x - anchorX) * q +
                        4 * Core.worldScale() * sin((source - segment * 7) * tau / 80)
                    local wy = anchorY + (self.y - anchorY) * q
                    M.atlasStyled("ld_enemy_s_", 43, self,
                        (wx - self.x) / Core.worldScale(),
                        (self.y - wy) / Core.worldScaleY(),
                        self.angle16, scale, scale, false, "", 255)
                end
            end
        end
        if self.state ~= -1 then
            local scale = 1
            if self.state == 0 then
                if t < 40 then scale = 0
                elseif t < 48 then scale = sin((t - 40) * pi / 16) end
            end
            mediumFrame(75, self, 0, 0, self.angle16, scale, scale)
        end
    elseif typeId == 0xc9 then
        local parent = parentOf(self)
        if parent then
            local scale, alpha = 1, 255
            if t < 20 then
                scale = 2 - sin(t * pi / 40)
                alpha = sin(t * pi / 40) * 255
            end
            M.atlasStyled("ld_enemy_l_", 40, self, 0, 0,
                (parent.targetAngle16 or 0) + (self.targetAngle16 or 0),
                scale, scale, false, "", alpha)
        end
    elseif typeId == 0xca then
        local parent = parentOf(self)
        if parent then
            local scale = t < 20 and sin(t * pi / 40) or 1
            mediumFrame(101, self, 0, 0, parent.targetAngle16 or 0,
                scale, scale)
        end
    end
    if self.targetable then renderGauge(self, 2, -80) end
end

local function normalStage9MoveState(state)
    return (state >= 0x0c and state <= 0x10) or
           (state >= 0x12 and state <= 0x16)
end

local function renderStage9Boss(self)
    local state, t = self.state, self.helperTimer
    local early = state < 0x3c or (state >= 0x6f and state < 0xa0)
    if early then
        largeFrame(62, self)
        largeFrame(61, self, 360 - self.ldX, 120)
        if state == 0 and t < 0xbe then
            M.atlasStyled("ld_enemy_l_", 61, self, 360 - self.ldX, 120, 0,
                1, 1, false, "mul+add", t * 255 / 0xbe)
        end
        if state ~= 0 or t >= 0x3c then
            local spacing = 55
            if state == 0 then
                spacing = spacing * Core.clamp((t - 0x3c) / 20, 0, 1)
            end
            local source = self.runtime and self.runtime.frame or 0
            for link = 0, 5 do
                local distance = spacing * link
                local phase = (source - link * 10) % 120
                local pulse = phase <= 0x20 and state < 10 and
                    1 + sin(phase * pi / 0x20) * 0.1 or 1
                local rdx, rdy = Core.polar(0x9770, distance)
                local ldx, ldy = Core.polar(0xe890, distance)
                smallFrame(0x8a, self, 730 - self.ldX + rdx,
                    420 + rdy, 0x9770, pulse, pulse)
                smallFrame(0x8a, self, -10 - self.ldX + ldx,
                    420 + ldy, 0xe890, pulse, pulse, true)
                rdx, rdy = Core.polar(0x6890, distance)
                ldx, ldy = Core.polar(0x1770, distance)
                smallFrame(0x8b, self, 730 - self.ldX + rdx,
                    -30 + rdy, 0x6890, pulse, pulse)
                smallFrame(0x8b, self, -10 - self.ldX + ldx,
                    -30 + ldy, 0x1770, pulse, pulse, true)
            end
        end
    end
    local late = state > 10 or (state == 10 and t >= 250)
    if late then
        local swing = sin((self.runtime and self.runtime.frame or 0) * tau / 120) * 3000
        local side = difficulty(self.runtime or {}) > 3 and 0x90 or 0x81
        local scale = 0.7 + sin((self.runtime and self.runtime.frame or 0) * tau / 120) * 0.3
        bossFrame(side, self, 24, -20, swing, scale, scale)
        bossFrame(side, self, -24, -20, -swing, scale, scale, true)
        local body = 0x73 + floor(t / 5) % 3
        if normalStage9MoveState(state) then
            local duration = state >= 0x12 and 20 or 30
            if t < 10 or t >= duration - 10 then
                body = 0x76 + floor(t / 5) % 2
            else
                body = 0x78 + floor(t / 5) % 3
            end
        elseif state == 0x3c or state == 0xa0 then
            if t < 0x6e then
                body = 0x7f + floor(t / 5) % 2
            elseif t < 0x78 then
                body = 0x7e - floor(t / 5) % 2
            end
        elseif state == 99 or state == 199 then
            if t >= 0xf0 then renderGauge(self, 1); return end
            body = 0x7f + floor(t / 5) % 2
        end
        bossFrame(body, self)
    end
    renderGauge(self, 1)
end

local function renderStage9BossNode(self)
    local typeId, t = self.spawnType, self.helperTimer
    if typeId == 0xcd then
        local scale = 1
        if t < 0x10 then
            scale = sin(t * pi / 32)
        elseif t >= 0xa4 then
            scale = t < 0xb4 and sin((t - 0x94) * pi / 32) or 0
        end
        local alpha = 0xc0 + sin(t * pi / 2) * 32
        M.atlasStyled("ld_enemy_m_", 0xab + floor(t / 5) % 3,
            self, 0, 0, 0, scale, scale, false, "", alpha)
    elseif typeId >= 0xda and typeId <= 0xdd then
        local scale = t < 30 and sin(t * pi / 60) or
            (t >= 270 and max(0, sin((t - 240) * pi / 60)) or 1)
        smallFrame(140, self, 0, 0, self.angle16, scale, scale)
        smallFrame(141, self, 0, 0, self.secondaryAngle16, scale, scale)
    else
        local scale, alpha = 1, 255
        local visualState = self._blVisualState or self.state
        local visualTimer = self._blVisualTimer or t
        local sourceAngle = self.angle16
        if visualState == 0 then
            scale = M.smoothStep(visualTimer / 20)
            local aimsDuringEntry = typeId == 0xce or typeId == 0xd3 or
                typeId == 0xd4 or typeId == 0xd5 or typeId == 0xd8
            if not aimsDuringEntry then
                sourceAngle = self.secondaryAngle16 +
                    sin(visualTimer * pi / 40) * 0x10000
            end
        elseif visualState == 2 then
            scale = 1 - M.smoothStep(visualTimer / 20)
            alpha = 255 - visualTimer * 13
        end
        M.atlasStyled("ld_enemy_s_", 140, self, 0, 0,
            self.secondaryAngle16, scale, scale, false, "", alpha)
        M.atlasStyled("ld_enemy_s_", 141, self, 0, 0,
            sourceAngle, scale, scale, false, "", alpha)
    end
end

local function renderSceneUpper(self)
    local frame = self.runtime and self.runtime.frame or 0
    local upper = sin((frame - 16) * tau / 100) * 1600
    local a = upper + 0x2000
    local ux, uy = Core.polar(a, 200)
    largeFrame(70, self, 150 + ux, -120 + uy, a)
    largeFrame(70, self, -150 - ux, -120 + uy, -0x2000 - upper, 1, 1, true)
end

local function renderSceneBody(self)
    local frame = self.runtime and self.runtime.frame or 0
    local body = self.state <= 2 and 63 or (self.state == 4 and 64 or
        (self.state == 6 and 65 or 66))
    largeFrame(body, self)
    local lower = sin(frame * tau / 100) * 700
    largeFrame(67, self, 148, -70, lower + 0x3da8)
    largeFrame(67, self, -148, -70, -0x3da8 - lower, 1, 1, true)
    largeFrame(68, self, 0, sin(frame * tau / 100) * 2)
    largeFrame(69, self, 0, sin((frame - 8) * tau / 100) * 2 - 100)
end

local function renderSceneRoot(self)
    renderSceneUpper(self)
    if not sceneBodyProxyClass then renderSceneBody(self) end
    renderGauge(self, 1)
end

local function renderSceneE1Marker(self)
    local right = (self._blOffsetX or 0) >= 0
    largeFrame(73, self,
        (self._blMarkerX or self.ldX) - self.ldX,
        (self._blMarkerY or self.ldY) - self.ldY,
        self.targetAngle16, 1, 1, not right)
end

local function renderSceneNode(self)
    local typeId = self.spawnType
    if typeId == 0xde then
        extraLargeFrame(0, self)
        largeFrame(71, self, 0, -240)
        local source = max(0, (self.runtime and self.runtime.frame or 0) - 1)
        local markerScale = 1 + sin((source + 30) * tau / 100) * 0.1
        largeFrame(72, self,
            (self._blMarkerX or self.ldX) - self.ldX,
            (self._blMarkerY or self.ldY) - self.ldY,
            0, markerScale, markerScale)
    elseif typeId == 0xdf then
        extraLargeFrame(1, self)
    elseif typeId == 0xe0 then
        local right = (self._blOffsetX or 0) >= 0
        extraLargeFrame(2, self,
            (self._blBodyX or self.ldX) - self.ldX,
            (self._blBodyY or self.ldY) - self.ldY,
            self.angle16, 1, 1, not right)
    elseif typeId == 0xe1 then
        local right = (self._blOffsetX or 0) >= 0
        extraLargeFrame(3, self,
            (self._blBodyX or self.ldX) - self.ldX,
            (self._blBodyY or self.ldY) - self.ldY,
            self.angle16, 1, 1, not right)
        if not sceneMarkerProxyClass then renderSceneE1Marker(self) end
    elseif typeId == 0xe2 then
        local right = (self._blOffsetX or 0) >= 0
        extraLargeFrame(right and 4 or 6, self,
            (self._blBodyX or self.ldX) - self.ldX,
            (self._blBodyY or self.ldY) - self.ldY,
            self.secondaryAngle16)
    elseif typeId == 0xe3 then
        local right = (self._blOffsetX or 0) >= 0
        local markerX, markerY = self._blMarkerX or self.ldX,
            self._blMarkerY or self.ldY
        local satelliteAngle = Core.angle16(self.targetAngle16 +
            (right and 0x5770 or 0x3060))
        local satelliteX, satelliteY = sceneOrbit(markerX, markerY,
            satelliteAngle, right and 70 or 60)
        largeFrame(right and 75 or 77, self,
            markerX - self.ldX, markerY - self.ldY, self.targetAngle16)
        extraLargeFrame(right and 5 or 7, self,
            (self._blBodyX or self.ldX) - self.ldX,
            (self._blBodyY or self.ldY) - self.ldY,
            self.secondaryAngle16)
        local scale = 1 + sin(((self.runtime and self.runtime.frame or 0) + 88) *
            tau / 100) * 0.1
        largeFrame(right and 74 or 76, self,
            satelliteX - self.ldX, satelliteY - self.ldY,
            self.targetAngle16, scale, scale)
    elseif typeId <= 0xf1 then
        local frame = 174 + typeId - 0xe4 + (self.state == 2 and 14 or 0)
        mediumFrame(frame, self, 0, 0, self.secondaryAngle16)
        if self.state == 1 and (self.helperTimer or 0) < 40 then
            M.atlasStyled("ld_enemy_m_", frame, self, 0, 0,
                self.secondaryAngle16, 1, 1, false, "",
                sin(((self.helperTimer or 0) + 40) * pi / 80) * 255)
        end
        if self.targetable then renderGauge(self, 2, -60) end
    else
        local frame = 144 + typeId - 0xf2
        smallFrame(frame, self, 0, 0, self.secondaryAngle16)
        if self.state == 1 and (self.helperTimer or 0) < 40 then
            M.atlasStyled("ld_enemy_s_", frame, self, 0, 0,
                self.secondaryAngle16, 1, 1, false, "",
                sin(((self.helperTimer or 0) + 40) * pi / 80) * 255)
        end
        if self.targetable then renderGauge(self, 2, -40) end
    end
end

local function renderFinalRoot(self)
    local state, t = self.state, self.helperTimer
    if (state == 142 and t <= 40) or (state == 200 and t >= 60) then return end
    local idle = {0x91, 0x92, 0x93, 0x92}
    local windup = {0x94, 0x95}
    local attack = {0x96, 0x97, 0x98, 0x99, 0x98, 0x97}
    local special = {0x9a, 0x9b, 0x9c, 0x9d}
    local transition = {0x9e, 0x9f}
    local frame = idle[floor(t / 5) % #idle + 1]
    if state == 142 then
        frame = special[floor(t / 5) % #special + 1]
    elseif state == 152 or state == 200 or
           (state >= 10 and state <= 150 and state % 20 == 10) then
        frame = transition[floor(t / 5) % #transition + 1]
    else
        local delayed = state >= 11 and state <= 151 and state % 20 == 11
        local windupStart = delayed and 30 or 20
        if t >= windupStart + 10 then
            frame = attack[floor((t - windupStart - 10) / 5) % #attack + 1]
        elseif t >= windupStart then
            frame = windup[floor((t - windupStart) / 5) % #windup + 1]
        end
    end
    bossFrame(frame, self)
    renderGauge(self, 1)
end

local function renderFinalNode(self)
    local typeId = self.spawnType
    local launcher = typeId >= 0x116 and typeId <= 0x119
    local state = self.state or 0
    local t = self.helperTimer or 0
    if launcher and self._blDroneBreakTimer then
        state, t = 99, self._blDroneBreakTimer
    elseif self._blDeviceBreaking then
        state, t = 99, self._blDeviceBreakTimer or 0
    end
    local alpha = 255
    if not launcher and state == 0 then
        alpha = Core.clamp(t * 255 / 150, 0, 255)
    elseif not launcher and state == 99 and typeId ~= 0x127 then
        alpha = Core.clamp((100 - t) * 255 / 100, 0, 255)
    end
    local function drawLarge(imageFrame, ox, oy, angle, sx, sy, reverse,
                             blend, drawAlpha)
        return M.atlasStyled("ld_enemy_l_", imageFrame, self, ox, oy, angle,
            sx, sy, reverse, blend or "", drawAlpha == nil and alpha or drawAlpha)
    end
    local function drawMedium(imageFrame, ox, oy, angle, sx, sy, reverse,
                              blend, drawAlpha)
        return M.atlasStyled("ld_enemy_m_", imageFrame, self, ox, oy, angle,
            sx, sy, reverse, blend or "", drawAlpha == nil and alpha or drawAlpha)
    end
    local function drawSmall(imageFrame, ox, oy, angle, sx, sy, reverse,
                             blend, drawAlpha)
        return M.atlasStyled("ld_enemy_s_", imageFrame, self, ox, oy, angle,
            sx, sy, reverse, blend or "", drawAlpha == nil and alpha or drawAlpha)
    end
    if typeId == 0x114 then
        drawSmall(0xa6 + floor(t / 5) % 3, 0, 0, self.angle16,
            1, 1, (self._blOffsetX or 0) < 0)
    elseif launcher then
        local body = 0x5a + typeId - 0x116
        local function drawLauncher(imageFrame, drawAlpha, sx, sy, blend)
            drawLarge(imageFrame, 0, 120, 0, sx or 1, sy or sx or 1,
                false, blend or "", drawAlpha)
        end
        if state == 0 then
            if t < 150 then
                drawLauncher(body, sin(t * pi / 300) * 255)
            elseif t < 180 then
                local bodyAlpha = sin((t - 150) * pi / 60) * 255
                local appearAlpha = sin((t - 120) * pi / 60) * 255
                drawLauncher(body, bodyAlpha)
                drawLauncher(0x59, bodyAlpha / 2)
                drawLauncher(body, appearAlpha, 1, 1, "mul+add")
            else
                drawLauncher(body, 255)
                drawLauncher(0x59, 0x7f)
            end
        elseif state == 99 then
            if t < 100 then
                local wave = sin(t * tau / 15)
                local sx, sy = 1 - wave * 0.2, 1 + wave * 0.2
                drawLauncher(body, 255, sx, sy)
                drawLauncher(0x59, 0x7f, sx, 1)
            end
        elseif state == 1 or state == 3 then
            local wave = sin(t * pi / 40)
            local sx, sy = 1 - wave * 0.3, 1 + wave * 0.3
            drawLauncher(body, 255, sx, sy)
            drawLauncher(0x59, 0x7f, sx, 1)
        elseif state == 2 or state == 4 then
            local wobble = 0.05 * sin(t * pi / 30)
            if t < 60 then
                wobble = wobble + 0.1 * sin(t * tau / 15) *
                    sin((t + 60) * pi / 120)
            end
            drawLauncher(body, 255, 1 + wobble, 1 - wobble)
            drawLauncher(0x59, 0x7f, 1 + wobble, 1)
        else
            drawLauncher(body, 255)
            drawLauncher(0x59, 0x7f)
        end
    elseif typeId == 0x11b then
        drawLarge(0x5f)
    elseif typeId == 0x11c then
        drawLarge(0x60, -20, 0, 0, 1, 1, true)
        drawLarge(0x60, 20, 0)
    elseif typeId >= 0x11e and typeId <= 0x122 then
        local frame = typeId == 0x11e and 0x62 or 0x63
        local a = Core.aim16(0, 0, -(self._blOffsetX or 0), -(self._blOffsetY or 0))
        drawLarge(frame, 0, -70, a, 1, 1, (self._blOffsetX or 0) < 0)
    elseif typeId == 0x111 then
        drawLarge(0x4e, 0, 0, self.angle16)
    elseif typeId == 0x112 then
        local swing = sin(t * tau / 140)
        local upper = self.angle16 + swing * 0x1000
        drawLarge(0x56, 0, -110, upper)
        drawLarge(0x55, -82, -35, upper - 0x1400)
        drawLarge(0x55, 82, -35, 0x8000 - upper + 0x1400, 1, 1, true)
        drawLarge(state == 99 and 0x57 or 0x54, 0, 0, self.angle16)
        if state == 99 then
            drawLarge(0x58, 0, t * t * 0.02, t * 0x115c)
        end
    elseif typeId == 0x113 then
        drawMedium(floor(t / 5) % 3, 0, 0, self.angle16)
    elseif typeId == 0x115 then
        return
    elseif typeId == 0x11a then
        drawLarge(0x5e, 0, 0, self.angle16)
    elseif typeId == 0x11d then
        drawLarge(0x61, 0, -80, self.angle16)
    elseif typeId == 0x125 then
        local frame = state == 0 and (t < 0x78 and 0x4e or (t < 0xb4 and 0x50 or 0x52)) or 0x52
        drawLarge(frame, 0, 0, self.angle16)
    elseif typeId == 0x126 then
        local frame = state == 0 and (t < 0x78 and 0x4f or (t < 0xb4 and 0x51 or 0x53)) or 0x53
        drawLarge(frame, 0, 0, self.angle16, 1, 1, true)
    elseif typeId == 0x127 then
        local mf = 0xdd
        if state == 0 then mf = t < 0x28 and 0xde or 0xdf
        elseif state == 17 then mf = 0xde
        elseif state >= 18 and state <= 20 then mf = t <= 0x18 and 0xdf or 0xde
        elseif state >= 21 and state <= 24 then mf = t < 0x23 and 0xdf or 0xde
        elseif state == 26 then mf = t < 0x5a and 0xde or 0xe0
        elseif (state >= 27 and state <= 31) or state == 99 then mf = 0xe0 end
        drawLarge(0x64, 0, 0, self.angle16)
        drawMedium(mf, 0, 0, self.angle16)
        if state >= 17 and state <= 24 then drawLarge(0x65) end
        if state >= 18 and state <= 24 then
            drawLarge(0x59)
            if t % 2 == 0 then
                drawLarge(0x65, 0, 0, self.angle16, 1.02, 1.02,
                    false, "mul+add", 0x60)
            end
        end
        local finalShell = (state == 26 and t >= 0x50) or
            (state >= 27 and state <= 31 and t >= 0x32)
        if finalShell then
            drawLarge(0x66, 0, 0, self.angle16, 1, 1,
                false, "mul+add", 0xa0)
            drawLarge(0x66, 0, 0, self.angle16, 1.015, 1.015,
                true, "mul+add", 0x60)
        end
    elseif typeId == 0x12d then
        drawLarge(0x67 + min(3, max(0, state)), 0, 0, self.angle16)
    end
    if self.targetable then renderGauge(self, 2, -80) end
end

local function renderFinalEmitter(self)
    local typeId, t = self.spawnType, self.helperTimer
    if typeId >= 0x128 and typeId <= 0x12a then return end
    local frame
    local prefix = "ld_enemy_m_"
    if typeId >= 0x105 and typeId <= 0x110 then
        prefix, frame = "ld_enemy_s_", 169
    elseif typeId == 0x123 then frame = 219
    elseif typeId == 0x124 then frame = 220
    elseif typeId == 0x12b or typeId == 0x12c then frame = 225
    else frame = 226 end
    local scale, angle = 1, 0
    local materializing = (typeId >= 0x105 and typeId <= 0x10b) or
        typeId == 0x10f or typeId == 0x110
    if materializing and self.state == 0 then
        scale = sin(Core.clamp(t, 0, 60) * pi / 120)
    elseif typeId == 0x123 or typeId == 0x124 then
        scale = sin(min(t, 10) * pi / 20)
        angle = sin(t * pi / (typeId == 0x123 and 32 or 24)) * 3000
    elseif typeId == 0x12b or typeId == 0x12c then
        scale, angle = sin(t * pi / 50), self.secondaryAngle16
    elseif typeId >= 0x12e then
        scale = t < 30 and sin(t * pi / 60) or
            (t < 0x186 and 1 or max(0, cos((t - 0x186) * pi / 40)))
        angle = sin(t * pi / 44) * 1280
    end
    atlas(prefix, frame, self, 0, 0, angle, scale, scale)
end

local function gaugeSpec(self)
    local typeId = self.spawnType
    if rootTypes[typeId] then return nil end
    if typeId >= 0xa7 and typeId <= 0xc2 and
       typeId ~= 0xb4 and typeId ~= 0xb5 and typeId ~= 0xbb then
        return 2, -80
    elseif typeId >= 0xc4 and typeId <= 0xcc then
        return 2, -80
    elseif typeId >= 0xe4 and typeId <= 0xf1 then
        return 2, -60
    elseif typeId >= 0xf2 and typeId <= 0xf9 then
        return 2, -40
    elseif (typeId >= 0x111 and typeId <= 0x122 and typeId ~= 0x115) or
           (typeId >= 0x125 and typeId <= 0x127) or typeId == 0x12d then
        return 2, -80
    end
end

M.RenderProxyManager = {}
M.RenderProxyManager.__index = M.RenderProxyManager

function M.RenderProxyManager.new()
    return setmetatable({}, M.RenderProxyManager)
end

function M.RenderProxyManager:ownerValid(owner)
    local valid = owner and owner.active ~= false and
        owner.status ~= "del" and owner.status ~= "kill" and
        not owner.removeRequested and not owner.deadRequested
    local engine = rawget(_G, "lstg")
    if valid and engine and type(engine.IsValid) == "function" then
        valid = engine.IsValid(owner)
    end
    return valid
end

function M.RenderProxyManager:proxyUsable(proxy)
    if not proxy or proxy.active == false or proxy.status == "del" or
       proxy.status == "kill" then
        return false
    end
    local engine = rawget(_G, "lstg")
    return not engine or type(engine.IsValid) ~= "function" or
        engine.IsValid(proxy)
end

function M.RenderProxyManager:delete(proxy, owner, key)
    if owner and owner[key] == proxy then owner[key] = nil end
    local deleter = rawget(_G, "Del")
    if type(deleter) == "function" then
        deleter(proxy)
    else
        proxy.status, proxy.active = "del", false
    end
end

M._renderProxyManager = M.RenderProxyManager.new()

if type(rawget(_G, "Class")) == "function" and
   type(rawget(_G, "object")) == "table" and
   type(rawget(_G, "New")) == "function" then
    local function releaseStageEffect(self)
        if not self._blCounted then return end
        self._blCounted = false
        local rt = self._runtime
        if rt then
            rt.stageEffectCount = max(0, (rt.stageEffectCount or 1) - 1)
        end
    end

    local function finishStageEffect(self)
        local deleter = rawget(_G, "Del")
        if type(deleter) == "function" then
            deleter(self)
        else
            self.status, self.active = "del", false
            releaseStageEffect(self)
        end
    end

    stageEffectClass = Class(object)
    M.StageEffectClass = stageEffectClass

    function stageEffectClass:init(rt, spec)
        self._runtime = rt
        self.kind = spec.kind
        self.img = spec.img
        self.ldX, self.ldY = spec.x or 0, spec.y or 0
        self.angle16 = Core.angle16(spec.angle16 or 0)
        self.speed = spec.speed or 0
        self.scale = spec.scale or 1
        self.lifetime = spec.lifetime or 0
        self.alpha = spec.alpha or 0xff
        self.red = spec.red or 0xff
        self.green = spec.green or 0xff
        self.blue = spec.blue or 0xff
        self.layer = spec.layer or stageEffectLayer(0x48)
        self.sourceFrame = spec.sourceFrame or (rt and rt.frame or 0)
        -- Enemy updates precede the original stage-effect pass. LuaSTG visits
        -- objects appended by the enemy later in the same ObjFrame walk, so -1
        -- makes their first observed helper age exactly zero on that frame.
        self.age = spec.initialAge or -1
        self.group = rawget(_G, "GROUP_GHOST") or 0
        self.bound = false
        self.colli = false
        self.active = true
        self._blCounted = true
        if rt then rt.stageEffectCount = (rt.stageEffectCount or 0) + 1 end
        if self.kind == "death_spark" then
            self.random = stageFrameRand(self.angle16 + self.sourceFrame)
            self.lifetime = self.random % 21 + 30
            self.pulseStart = self.random % 26 + 5
        end
        Core.syncObject(self, self.ldX, self.ldY)
    end

    function stageEffectClass:del() releaseStageEffect(self) end
    function stageEffectClass:kill() releaseStageEffect(self) end

    function stageEffectClass:frame()
        self.age = self.age + 1
        local age = self.age
        if age < 0 then
            Core.syncObject(self, self.ldX, self.ldY)
            return
        end

        if self.kind == "terminal_driver" then
            spawnTerminalComponents(self._runtime, self.ldX, self.ldY,
                self._runtime and self._runtime.frame or self.sourceFrame + 1)
            finishStageEffect(self)
            return
        elseif self.kind == "death_burst" then
            local dx, dy = Core.polar(self.angle16, self.speed)
            self.ldX, self.ldY = self.ldX + dx, self.ldY + dy
            self.drawAngle16 = Core.angle16(self.angle16 + age * 0x640)
            self.drawScaleX, self.drawScaleY = self.scale, self.scale
            self.drawAlpha = self.alpha
            if age >= self.lifetime - 8 then
                self.drawAlpha = self.alpha - trunc(
                    ((age - self.lifetime) + 8) * self.alpha * 0.125)
            end
        elseif self.kind == "death_spark" then
            local speed = self.speed * (1 - sin(
                age * pi / (2 * self.lifetime)))
            local dx, dy = Core.polar(self.angle16, speed)
            self.ldX, self.ldY = self.ldX + dx, self.ldY + dy
            local pulse = sin((age - self.pulseStart) * pi /
                (2 * self.pulseStart))
            self.drawScaleX = pulse * self.scale
            self.scale = self.scale + 0.005
            self.drawScaleY = self.scale
            self.drawAngle16 = Core.angle16(self.angle16 +
                (self.random % 571 + 30) * age)
            local fadeStart = self.lifetime - 12
            if age >= self.lifetime then
                self.drawAlpha = 0
            elseif age >= fadeStart then
                self.drawAlpha = trunc(sin((age - (self.lifetime - 24)) *
                    pi / 24) * self.alpha)
            else
                self.drawAlpha = self.alpha
            end
        elseif self.kind == "phase15_particle" then
            self.drawAngle16 = self.angle16
            self.drawScaleX, self.drawScaleY = self.scale, self.scale
            self.drawAlpha = self.alpha - trunc(
                self.alpha / max(1, self.lifetime) * age)
        elseif self.kind == "terminal_radial" then
            local random = stageFrameRand(self.angle16 + age)
            local palette = {
                {0xff, 0x78, 0x78}, {0xff, 0xc8, 0x6e},
                {0xff, 0xff, 0x78}, {0x78, 0xff, 0x78},
                {0x78, 0xff, 0xff}, {0x78, 0x78, 0xff},
                {0xdc, 0x78, 0xff},
            }
            if age % 2 == 0 then
                local color = palette[random % #palette + 1]
                self.red, self.green, self.blue = color[1], color[2], color[3]
            else
                self.red, self.green, self.blue = 0xff, 0xff, 0xff
            end
            self.scale = self.scale + 0.02
            local dx, dy = Core.polar(self.angle16, self.speed)
            self.ldX = self.ldX + dx
            self.ldY = self.ldY + dy + age * 0.4
            self.drawAngle16 = Core.angle16(self.angle16 + age * 0x400)
            self.drawScaleX, self.drawScaleY = self.scale, self.scale
            self.drawAlpha = age > 0x30 and 0x3ff - age * 0x10 or 0xff
            self.lifetime = 0x40
        elseif self.kind == "terminal_center" then
            self.scale = self.scale + 0.1
            self.drawAngle16 = 0
            self.drawScaleX, self.drawScaleY = self.scale, self.scale
            self.drawAlpha = age > 0x1f and 0x2ff - age * 0x10 or 0xff
            self.lifetime = 0x30
        end

        Core.syncObject(self, self.ldX, self.ldY)
        if age >= self.lifetime then finishStageEffect(self) end
    end

    function stageEffectClass:render()
        if self.age < 0 or self.status == "del" or not self.img or
           not imageExists(self.img) then
            return
        end
        local scaleX = self.drawScaleX or self.scale
        local scaleY = self.drawScaleY or self.scale
        if self.kind == "death_burst" and self.age < 8 then
            local entrance = sin(self.age * pi / 16)
            scaleX, scaleY = scaleX * entrance, scaleY * entrance
        end
        local alpha = Core.clamp(self.drawAlpha or self.alpha, 0, 0xff)
        if alpha <= 0 then return end
        local setImageState = rawget(_G, "SetImageState")
        local color = rawget(_G, "Color")
        if type(setImageState) == "function" and type(color) == "function" then
            setImageState(self.img, "", color(alpha,
                self.red, self.green, self.blue))
        end
        Render(self.img, self.x, self.y,
            Core.angleToDeg(self.drawAngle16 or self.angle16),
            scaleX, scaleY)
        if type(setImageState) == "function" and type(color) == "function" then
            setImageState(self.img, "", color(255, 255, 255, 255))
        end
    end

    gaugeProxyClass = Class(object)

    function gaugeProxyClass:init(owner)
        self.owner = owner
        self.layer = (rawget(_G, "LAYER_ENEMY_BULLET") or -200) + 0x14
        self.group = rawget(_G, "GROUP_GHOST") or 0
        self.bound = false
        self.colli = false
        self.x, self.y = owner.x, owner.y
    end

    function gaugeProxyClass:frame()
        local owner = self.owner
        if not M._renderProxyManager:ownerValid(owner) then
            M._renderProxyManager:delete(self, owner, "_blGaugeRenderProxy")
            return
        end
        self.x, self.y = owner.x, owner.y
    end

    function gaugeProxyClass:render()
        local owner = self.owner
        if not M._renderProxyManager:ownerValid(owner) then return end
        local kind, offsetY = gaugeSpec(owner)
        if kind then drawGauge(owner, kind, offsetY) end
    end

    sceneBodyProxyClass = Class(object)

    function sceneBodyProxyClass:init(owner)
        self.owner = owner
        self.layer = exactToLuaLayer(0x19)
        self.group = rawget(_G, "GROUP_GHOST") or 0
        self.bound = false
        self.colli = false
        self.x, self.y = owner.x, owner.y
    end

    function sceneBodyProxyClass:frame()
        local owner = self.owner
        if not M._renderProxyManager:ownerValid(owner) then
            M._renderProxyManager:delete(self, owner,
                "_blSceneBodyRenderProxy")
            return
        end
        self.x, self.y = owner.x, owner.y
    end

    function sceneBodyProxyClass:render()
        if M._renderProxyManager:ownerValid(self.owner) then
            renderSceneBody(self.owner)
        end
    end

    sceneMarkerProxyClass = Class(object)

    function sceneMarkerProxyClass:init(owner)
        self.owner = owner
        self.layer = exactToLuaLayer(0x11)
        self.group = rawget(_G, "GROUP_GHOST") or 0
        self.bound = false
        self.colli = false
        self.x, self.y = owner.x, owner.y
    end

    function sceneMarkerProxyClass:frame()
        local owner = self.owner
        if not M._renderProxyManager:ownerValid(owner) then
            M._renderProxyManager:delete(self, owner,
                "_blSceneMarkerRenderProxy")
            return
        end
        self.x, self.y = owner.x, owner.y
    end

    function sceneMarkerProxyClass:render()
        if M._renderProxyManager:ownerValid(self.owner) then
            renderSceneE1Marker(self.owner)
        end
    end
end

function M.RenderProxyManager:ensure(owner, key, class)
    local proxy = owner[key]
    if not self:proxyUsable(proxy) then
        proxy = New(class, owner)
        owner[key] = proxy
    end
end

function M.RenderProxyManager:sync(owner)
    if not self:ownerValid(owner) then return end
    if gaugeProxyClass and gaugeSpec(owner) then
        self:ensure(owner, "_blGaugeRenderProxy", gaugeProxyClass)
    end
    if sceneBodyProxyClass and owner.spawnType == 0x14c then
        self:ensure(owner, "_blSceneBodyRenderProxy", sceneBodyProxyClass)
    end
    if sceneMarkerProxyClass and owner.spawnType == 0xe1 then
        self:ensure(owner, "_blSceneMarkerRenderProxy",
            sceneMarkerProxyClass)
    end
end

ensureRenderProxies = function(self)
    return M._renderProxyManager:sync(self)
end

M.Renderer = {}
M.Renderer.__index = M.Renderer

function M.Renderer.new(handlerMap, hiddenTypes)
    return setmetatable({
        handlers = handlerMap,
        hiddenTypes = hiddenTypes,
    }, M.Renderer)
end

function M.Renderer:render(entity)
    if entity.spawnType == 0xad and entity.parentSpawnType ~= 0x13f then
        return false
    end
    if not self.handlers[entity.spawnType] then return false end
    if not entity.active or self.hiddenTypes[entity.spawnType] then
        return true
    end
    local typeId = entity.spawnType
    if typeId == 0x13f then renderStage8Root(entity)
    elseif typeId >= 0xa7 and typeId <= 0xc2 then renderStage8Node(entity)
    elseif typeId == 0xc3 or typeId == 0x136 then renderShield(entity)
    elseif typeId >= 0x146 and typeId <= 0x14b then
        renderStage9Midboss(entity)
    elseif typeId >= 0xc4 and typeId <= 0xcc then renderStage9MidNode(entity)
    elseif typeId == 0x140 then renderStage9Boss(entity)
    elseif typeId >= 0xcd and typeId <= 0xdd then renderStage9BossNode(entity)
    elseif typeId == 0x14c then renderSceneRoot(entity)
    elseif typeId >= 0xde and typeId <= 0xf9 then renderSceneNode(entity)
    elseif typeId == 0x141 then renderFinalRoot(entity)
    elseif (typeId >= 0x105 and typeId <= 0x110) or
           (typeId >= 0x123 and typeId <= 0x135) then
        renderFinalEmitter(entity)
    elseif typeId >= 0x111 and typeId <= 0x12d then renderFinalNode(entity)
    end
    return true
end

M._renderer = M.Renderer.new(handlers, invisibleTypes)

function M.render(self)
    return M._renderer:render(self)
end

return M
