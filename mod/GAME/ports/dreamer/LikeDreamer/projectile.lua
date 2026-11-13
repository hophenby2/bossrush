-- Enemy projectile runtime. visualSelector chooses art; projectileId chooses motion.

LikeDreamer = LikeDreamer or {}

local Core = LikeDreamer.Core
local M = {}
LikeDreamer.Projectile = M

local sin, pi = math.sin, math.pi
local floor, ceil = math.floor, math.ceil
local min, max = math.min, math.max

local function trunc(value)
    if value < 0 then return ceil(value) end
    return floor(value)
end

local function atan2(y, x)
    if math.atan2 then return math.atan2(y, x) end
    if x > 0 then return math.atan(y / x) end
    if x < 0 and y >= 0 then return math.atan(y / x) + pi end
    if x < 0 then return math.atan(y / x) - pi end
    if y > 0 then return pi * 0.5 end
    if y < 0 then return -pi * 0.5 end
    return 0
end

-- Projectile helpers in the original use static_cast<int>, not lround.
local function aim16(x1, y1, x2, y2)
    return Core.angle16(trunc(atan2(y2 - y1, x2 - x1) * 10430.378350470464))
end

local function scriptRandomAngle(seed)
    local random = Core.frameRand(seed)
    return Core.angle16(random - floor(random / 0x10001))
end

local function scriptRandomHundredth(seed, minimum, maximum)
    local minimum100 = trunc(minimum * 100)
    local maximum100 = trunc(maximum * 100)
    if minimum100 == maximum100 then return minimum end
    return (minimum100 + Core.frameRand(seed) % (maximum100 - minimum100 + 1)) / 100
end

local direct = {
    [0x0c] = true, [0x0e] = true, [0x23] = true, [0x24] = true,
    [0x25] = true, [0x26] = true, [0x27] = true, [0x2c] = true,
    [0x2d] = true, [0x35] = true, [0x36] = true,
}

local common = {
    [0x00] = true, [0x01] = true, [0x02] = true, [0x03] = true,
    [0x04] = true, [0x05] = true, [0x06] = true, [0x07] = true,
    [0x09] = true, [0x0a] = true, [0x0b] = true, [0x0d] = true,
    [0x0f] = true, [0x10] = true, [0x11] = true, [0x12] = true,
    [0x16] = true,
}

local emitter = {
    [0x17] = true, [0x18] = true, [0x19] = true, [0x1a] = true,
    [0x1b] = true, [0x1c] = true, [0x1d] = true, [0x1e] = true,
    [0x21] = true, [0x22] = true, [0x28] = true, [0x29] = true,
    [0x2a] = true, [0x2b] = true, [0x2e] = true, [0x2f] = true,
    [0x30] = true, [0x31] = true, [0x32] = true, [0x33] = true,
    [0x34] = true, [0x37] = true, [0x38] = true, [0x39] = true,
    [0x3c] = true,
}

local lowerLayer = { [0x03] = true, [0x04] = true, [0x05] = true }
local upperLayer = {
    [0x18] = true, [0x19] = true, [0x1a] = true, [0x1b] = true,
    [0x1c] = true, [0x1d] = true, [0x1e] = true, [0x2f] = true,
    [0x30] = true, [0x32] = true, [0x3c] = true,
}

local trailLayer = {
    [0x1a] = -1, [0x1b] = -1, [0x1c] = -1, [0x1d] = -1,
    [0x1e] = -1, [0x32] = -1, [0x3c] = -1,
    [0x29] = -2, [0x2a] = -2, [0x2b] = -2, [0x2e] = -2,
}

local visualFrames = {
    [0x00] = 0, [0x01] = 1, [0x02] = 2, [0x03] = 3,
    [0x04] = 4, [0x05] = 5, [0x06] = 6, [0x07] = 7,
    [0x08] = 8, [0x09] = 9, [0x0a] = 20, [0x0b] = 21,
    [0x0c] = 22, [0x0d] = 23, [0x0e] = 24, [0x0f] = 25,
    [0x10] = 26, [0x11] = 4, [0x12] = 5, [0x13] = 5,
    [0x14] = 4,
}

local spinSteps = {
    [0x00] = 2000, [0x01] = 2000,
    [0x02] = 999, [0x03] = 999, [0x0e] = 999, [0x0f] = 999,
    [0x04] = 0x682, [0x05] = 0x682, [0x11] = 0x682,
    [0x12] = 0x682, [0x13] = 0x682, [0x14] = 0x682,
}

local rainbowPalette = {
    {0xff, 0x78, 0x78}, {0xff, 0xc8, 0x6e}, {0xff, 0xff, 0x78},
    {0x78, 0xff, 0x78}, {0x78, 0xff, 0xff}, {0x78, 0x78, 0xff},
    {0xdc, 0x78, 0xff},
}

local function runtime()
    return LikeDreamer.runtime
end

-- The source keeps projectiles in one linked list and uses the current list
-- index to seed cancel/graze feedback.  Keep the same stable order until the
-- next gameplay tick removes nodes that became inactive this tick.
local ProjectileRegistry = {}
ProjectileRegistry.__index = ProjectileRegistry
M.ProjectileRegistry = ProjectileRegistry

function ProjectileRegistry.new()
    return setmetatable({
        runtime = nil,
        frame = nil,
        projectiles = {},
        playerStateTimer = nil,
    }, ProjectileRegistry)
end

function ProjectileRegistry:reset(rt)
    self.runtime = rt
    self.frame = nil
    self.projectiles = {}
    self.playerStateTimer = nil
end

function ProjectileRegistry:bind(rt)
    if self.runtime ~= rt then self:reset(rt) end
end

function ProjectileRegistry:register(projectile, rt)
    self:bind(rt)
    projectile._linkedOrdinal = #self.projectiles
    self.projectiles[#self.projectiles + 1] = projectile
end

function ProjectileRegistry:prepare(rt)
    self:bind(rt)
    local frame = rt and rt.frame or 0
    if self.frame == frame then return end
    self.frame = frame
    local p = rawget(_G, "player")
    self.playerStateTimer = p and p.playerStateTimer or nil
    local compact = {}
    for _, projectile in ipairs(self.projectiles) do
        if (projectile.active or projectile._deactivatedFrame == frame) and
           projectile.status ~= "del" and projectile.status ~= "kill" then
            projectile._linkedOrdinal = #compact
            compact[#compact + 1] = projectile
        end
    end
    self.projectiles = compact
end

function ProjectileRegistry:ordinal(projectile, rt)
    self:prepare(rt)
    return projectile._linkedOrdinal or 0
end

function ProjectileRegistry:activeOrdinal(projectile, rt)
    self:prepare(rt)
    local ordinal = 0
    for _, candidate in ipairs(self.projectiles) do
        if candidate == projectile then return ordinal end
        if candidate.active then ordinal = ordinal + 1 end
    end
    return ordinal
end

function ProjectileRegistry:spawnPlayerStateTimer(rt, current)
    if self.runtime == rt and self.frame == (rt and rt.frame or 0) and
       self.playerStateTimer ~= nil then
        return self.playerStateTimer
    end
    return current
end

local projectileRegistry = ProjectileRegistry.new()
M.registry = projectileRegistry

local function difficulty()
    local rt = runtime()
    return rt and rt.difficulty or 1
end

local function playerPosition()
    local p = rawget(_G, "player")
    if p and p.ldX then return p.ldX, p.ldY end
    return 360, 600
end

local function inPlayfield(x, y)
    return Core.inside(x, y, 0)
end

local function deactivate(self)
    if self.active then
        self.active = false
        self.collisionEnabled = false
        self.colli = false
        local rt = runtime()
        self._deactivatedFrame = rt and rt.frame or 0
        -- The source unlinks inactive nodes at the beginning of the following
        -- update, after their terminal frame has already been drawn.
        self._deleteNextFrame = true
    end
end

local function sync(self)
    Core.syncObject(self, self.ldX, self.ldY)
    self.a = max(0.1, self.radius * Core.worldScale())
    self.b = max(0.1, self.radius * Core.worldScaleY())

end

local function sourceLayer(layer)
    return LAYER_ENEMY_BULLET + layer - 0x50
end

local function projectileLayer(projectileId)
    if lowerLayer[projectileId] then return sourceLayer(0x4f) end
    if upperLayer[projectileId] then return sourceLayer(0x51) end
    return sourceLayer(0x50)
end

local function visualScale(visual, age)
    local scaleA = 1.1 + sin(age * 2 * pi / 11) * 0.1
    local scaleB = 1.1 + sin((age - 6) * 2 * pi / 11) * 0.2
    if (visual >= 0 and visual <= 5) or visual == 0x0e or visual == 0x0f then
        return scaleA, scaleA
    elseif (visual >= 6 and visual <= 9) or visual == 0x10 then
        return 1, scaleB
    end
    return scaleA, scaleB
end

local function visualAngle(visual, age, angle16)
    local step = spinSteps[visual]
    if step then return Core.angle16(age * step) end
    return angle16
end

local projectileEffectClass = Class(object)

function projectileEffectClass:init(kind, img, x, y, angle16, scaleX, scaleY,
                                    lifetime, alpha, red, green, blue, layer, blend)
    self.kind = kind
    self.img = img
    self.ldX, self.ldY = x, y
    self.angle16 = Core.angle16(angle16 or 0)
    self.scaleX, self.scaleY = scaleX or 1, scaleY or scaleX or 1
    self.lifetime = max(1, lifetime or 1)
    self.alpha = alpha or 0xff
    self.red, self.green, self.blue = red or 0xff, green or 0xff, blue or 0xff
    self.layer = layer or LAYER_ENEMY_BULLET - 2
    self.blend = blend or ""
    self.group = GROUP_GHOST
    self.bound = false
    self.colli = false
    -- LuaSTG updates objects appended during ObjFrame later in that same walk.
    -- Source stage effects have already completed their update pass when a
    -- projectile creates one, so consume that first callback without drawing.
    self.age = -2
    self._counted = true
    local rt = runtime()
    self._runtime = rt
    if rt then rt.projectileEffectCount = (rt.projectileEffectCount or 0) + 1 end
    Core.syncObject(self, x, y)
end

local function releaseEffectCount(self)
    if not self._counted then return end
    self._counted = false
    local rt = self._runtime
    if rt then
        rt.projectileEffectCount = max(0, (rt.projectileEffectCount or 1) - 1)
    end
end

function projectileEffectClass:del() releaseEffectCount(self) end
function projectileEffectClass:kill() releaseEffectCount(self) end

function projectileEffectClass:frame()
    self.age = self.age + 1
    Core.syncObject(self, self.ldX, self.ldY)
    if self.age > self.lifetime then Del(self) end
end

function projectileEffectClass:render()
    if self.age < 0 or self.age > self.lifetime then return end
    local scaleX, scaleY = self.scaleX, self.scaleY
    local alpha
    if self.kind == "terminal" then
        scaleX = sin(self.age * pi / (2 * self.lifetime)) * self.scaleX
        scaleY = scaleX
        alpha = self.alpha
        if self.age >= self.lifetime - 8 then
            alpha = alpha - trunc(((self.age - self.lifetime) + 8) * alpha * 0.125)
        end
    else
        alpha = self.alpha - trunc(self.alpha / self.lifetime * self.age)
    end
    alpha = max(0, min(255, alpha))
    SetImageState(self.img, self.blend,
                  Color(alpha, self.red, self.green, self.blue))
    Render(self.img, self.x, self.y, Core.angleToDeg(self.angle16),
           scaleX, scaleY)
    SetImageState(self.img, "", Color(255, 255, 255, 255))
end

local function spawnProjectileEffect(kind, img, x, y, angle16, scaleX, scaleY,
                                     lifetime, alpha, red, green, blue, layer, blend)
    local rt = runtime()
    if rt and (rt.projectileEffectCount or 0) >= 0x1000 then return nil end
    return New(projectileEffectClass, kind, img, x, y, angle16, scaleX, scaleY,
               lifetime, alpha, red, green, blue, layer, blend)
end

local function terminalEffect(x, y)
    spawnProjectileEffect("terminal", "ld_effect_m_5", x, y, 0, 0.6, 0.6,
                          0x10, 0xff, 0xff, 0xff, 0xff,
                          sourceLayer(0x3d), "")
end

local applyDeferredGrazeReward
local grazeFeedbackClass = Class(object)
M.GrazeFeedbackClass = grazeFeedbackClass

function grazeFeedbackClass:init(x, y, angle16)
    self.ldX, self.ldY = x, y
    self.angle16 = Core.angle16(angle16)
    self.age = -2
    self.lifetime = 50
    self.group = GROUP_GHOST
    self.layer = sourceLayer(0x42)
    self.bound = false
    self.colli = false
    self._counted = true
    self._runtime = runtime()
    if self._runtime then
        self._runtime.projectileEffectCount =
            (self._runtime.projectileEffectCount or 0) + 1
    end
    Core.syncObject(self, x, y)
end

function grazeFeedbackClass:del() releaseEffectCount(self) end
function grazeFeedbackClass:kill() releaseEffectCount(self) end

function grazeFeedbackClass:frame()
    self.age = self.age + 1
    if self.age >= 0 then
        if self.age == 0 then applyDeferredGrazeReward(self._runtime) end
        local dx, dy = Core.polar(self.angle16, 1)
        self.ldX, self.ldY = self.ldX + dx, self.ldY + dy
    end
    Core.syncObject(self, self.ldX, self.ldY)
    if self.age > self.lifetime then Del(self) end
end

function grazeFeedbackClass:render()
    local age = self.age
    if age < 0 or age > self.lifetime then return end
    local entrance = age < 5 and sin(age * pi / 10) or 1
    local alpha = 0xc0
    if age >= self.lifetime then
        alpha = 0
    elseif age >= self.lifetime - 8 then
        alpha = trunc(sin((age - (self.lifetime - 16)) * pi / 16) * 0xc0)
    end
    if alpha <= 0 then return end
    SetImageState("ld_item_2", "", Color(alpha, 255, 255, 255))
    Render("ld_item_2", self.x, self.y, 0,
           entrance * 0.5,
           entrance * 0.5)
    SetImageState("ld_item_2", "", Color(255, 255, 255, 255))
end

local grazeParticleClass = Class(object)
M.GrazeParticleClass = grazeParticleClass

function grazeParticleClass:init(x, y, angle16, speed)
    self.ldX, self.ldY = x, y
    self.angle16 = Core.angle16(angle16)
    self.speed = speed
    self.scale = 0.3
    self.age = -2
    self.random = nil
    self.lifetime = 20
    self.group = GROUP_GHOST
    self.layer = sourceLayer(0x44)
    self.bound = false
    self.colli = false
    self._counted = true
    self._runtime = runtime()
    if self._runtime then
        self._runtime.projectileEffectCount =
            (self._runtime.projectileEffectCount or 0) + 1
    end
    Core.syncObject(self, x, y)
end

function grazeParticleClass:del() releaseEffectCount(self) end
function grazeParticleClass:kill() releaseEffectCount(self) end

function grazeParticleClass:frame()
    self.age = self.age + 1
    local age = self.age
    if age >= 0 then
        if age == 0 then
            local rt = self._runtime or runtime()
            self.random = Core.frameRand(self.angle16 + (rt and rt.frame or 0))
            self.lifetime = self.random % 11 + 10
        end
        local dx, dy = Core.polar(self.angle16, self.speed)
        self.ldX, self.ldY = self.ldX + dx, self.ldY + dy
        self.scale = self.scale + 0.01
    end
    Core.syncObject(self, self.ldX, self.ldY)
    if age > self.lifetime then Del(self) end
end

function grazeParticleClass:render()
    local age = self.age
    if age < 0 or age > self.lifetime or not self.random then return end
    local randomPhase = self.random % 11
    local alpha = 0xff
    local fadeStart = randomPhase + 2
    if age >= self.lifetime then
        alpha = 0
    elseif age >= fadeStart then
        alpha = trunc(sin((age - (randomPhase - 6)) * pi / 16) * 0xff)
    end
    if alpha <= 0 then return end
    local angle = Core.angle16(self.angle16 + (self.random % 571 + 30) * age)
    SetImageState("ld_player_15", "", Color(alpha, 255, 255, 255))
    Render("ld_player_15", self.x, self.y, Core.angleToDeg(angle),
           self.scale, self.scale)
    SetImageState("ld_player_15", "", Color(255, 255, 255, 255))
end

local cancelRewardDriverClass = Class(object)
M.CancelRewardDriverClass = cancelRewardDriverClass

function cancelRewardDriverClass:init(projectile, sourceType, ordinal, sourceFrame)
    self.projectile = {
        radius = projectile.radius,
        ldX = projectile.ldX,
        ldY = projectile.ldY,
    }
    self.sourceType = sourceType
    self.ordinal = ordinal
    self.sourceFrame = sourceFrame
    self.age = -2
    self.group = GROUP_GHOST
    self.layer = sourceLayer(0x49)
    self.bound = false
    self.colli = false
end

function cancelRewardDriverClass:frame()
    self.age = self.age + 1
    if self.age < 0 then return end
    local Reward = LikeDreamer.Reward
    if Reward then
        local projectile = self.projectile
        if type(Reward.cancelProjectile) == "function" then
            Reward.cancelProjectile(projectile, self.sourceType, self.ordinal,
                projectile.ldX, projectile.ldY, self.sourceFrame)
        elseif type(Reward.spawnItem) == "function" then
            local itemType = projectile.radius < 2 and 3 or 4
            Reward.spawnItem(itemType, projectile.ldX, projectile.ldY,
                scriptRandomAngle(self.sourceFrame + self.ordinal + 1),
                2, itemType == 4 and 45 or 30)
        end
    end
    Del(self)
end

applyDeferredGrazeReward = function(rt)
    if not rt then return end
    local Reward = LikeDreamer.Reward
    if Reward and type(Reward.applyGrazeReward) == "function" then
        Reward.applyGrazeReward(rt)
        rt.hudSpecialGaugeFlashTimer = 60
        return
    end
    rt.scoreItemBaseValue = (rt.scoreItemBaseValue or 100) + 1
    lstg.var = lstg.var or {}
    lstg.var.like_dreamer_score_item_base = rt.scoreItemBaseValue
    local amount = trunc(max(0.6,
        1 - floor((rt.difficulty or 0) / 2) * 0.1) * 30)
    if Reward and type(Reward.addSpecialGauge) == "function" then
        Reward.addSpecialGauge(rt, amount)
    else
        local p = rawget(_G, "player")
        local gauge = p and p.specialGauge or rt.specialGauge or rt.special_gauge or 0
        if gauge >= 0 then
            gauge = gauge + amount
            if p then p.specialGauge = gauge end
            rt.specialGauge, rt.special_gauge = gauge, gauge
            lstg.var.like_dreamer_special_gauge = gauge
        end
    end
    rt.hudSpecialGaugeFlashTimer = 60
end

local function spawnGrazeEffects(projectile, playerObject, x, y, ordinal)
    local rt = runtime()
    local frame = rt and rt.frame or 0
    local aim = aim16(x, y, playerObject.ldX, playerObject.ldY)
    local feedback = Core.angle16(scriptRandomAngle(frame + 112 + ordinal) +
                                  aim + 0x4000)
    if not rt or (rt.projectileEffectCount or 0) < 0x1000 then
        New(grazeFeedbackClass, x, y, feedback)
    end
    if not rt or (rt.projectileEffectCount or 0) < 0x1000 then
        New(grazeParticleClass,
            (x + playerObject.ldX) * 0.5,
            (y + playerObject.ldY) * 0.5,
            scriptRandomAngle(frame + 1 + ordinal),
            scriptRandomHundredth(frame + 0x2710 + ordinal, 5, 8))
    end
end

local projectileUnderlayClass = Class(object)

function projectileUnderlayClass:init(owner, visual)
    self.owner = owner
    self.visual = visual
    self.group = GROUP_GHOST
    self.bound = false
    self.colli = false
    -- Selectors 0x13/0x14 queue their overlay at enemy layer 0x23,
    -- before the player and the projectile's own 0x4f..0x51 body pass.
    self.layer = (visual == 0x11 or visual == 0x12)
                     and owner.layer - 1 or LAYER_ENEMY + 0.01
end

function projectileUnderlayClass:frame()
    local owner = self.owner
    if not owner or not lstg.IsValid(owner) or owner.status ~= "normal" then
        Del(self)
        return
    end
    self.x, self.y = owner.x, owner.y
end

function projectileUnderlayClass:render()
    local owner = self.owner
    if not owner or not lstg.IsValid(owner) or owner.status ~= "normal"
       or not owner.drawQueued then return end
    local visual, age = self.visual, owner.drawAge
    if visual == 0x11 or visual == 0x12 then
        local pulseY = 0.6 + sin(age * 2 * pi / 17) * 0.4
        SetImageState("ld_effect_s_8", "", Color(0xc0, 255, 255, 255))
        Render("ld_effect_s_8", owner.x, owner.y, Core.angleToDeg(owner.angle16),
               1, pulseY)
        SetImageState("ld_effect_s_8", "", Color(255, 255, 255, 255))
        return
    end
    local clockwise = visual == 0x14
    Render(clockwise and "ld_enemy_s_119" or "ld_enemy_s_118",
           owner.x, owner.y,
           Core.angleToDeg((clockwise and 1 or -1) * age * 0x457),
           (clockwise and -1 or 1), 1)
end

local bulletClass = Class(object)
M.Class = bulletClass

function bulletClass:init(visual, projectileId, x, y, angle, initialTravel, speed, radius, arg)
    self.visualSelector = visual or 0
    self.projectileId = projectileId or 0
    self.ldX, self.ldY = x, y
    self.anchorX, self.anchorY = x, y
    self.prevX, self.prevY = x, y
    self.angle16 = Core.angle16(trunc(angle or 0))
    self.prevAngle16 = self.angle16
    self.travel = initialTravel or 0
    self.speed = speed or 0
    self.baseSpeed = self.speed
    self.radius = radius or 1
    self.arg = arg or 0
    self.age = 0
    self.active = true
    self.collisionEnabled = true
    self.grazed = false
    self.drawAge = 0
    self.drawQueued = false
    self.bound = false
    self.group = GROUP_ENEMY_BULLET
    self.layer = projectileLayer(self.projectileId)
    self.rect = false
    self.img = "ld_bullet_" .. tostring((visualFrames[self.visualSelector] or 0) + 1)
    self._counted = true
    local rt = runtime()
    self._runtime = rt
    if rt then
        rt.bulletCount = (rt.bulletCount or 0) + 1
        rt.enemyProjectileSpawnsThisSecond =
            (rt.enemyProjectileSpawnsThisSecond or 0) + 1
    end
    projectileRegistry:register(self, rt)
    sync(self)
    if self.visualSelector >= 0x11 and self.visualSelector <= 0x14 then
        self._underlay = New(projectileUnderlayClass, self, self.visualSelector)
    end
end

local function releaseCount(self)
    if self._counted then
        self._counted = false
        local rt = self._runtime
        if rt then rt.bulletCount = max(0, (rt.bulletCount or 1) - 1) end
    end
end

function bulletClass:del()
    releaseCount(self)
end

function bulletClass:kill()
    releaseCount(self)
end

function bulletClass:colli(other)
    if other and other.group == GROUP_SPELL then
        deactivate(self)
    end
end

local function trail(visual, self, radius, allowed)
    if allowed == nil then allowed = Core.inside(self.ldX, self.ldY, 30) end
    if allowed then
        M.spawn(visual, 0x0f, self.ldX, self.ldY, self.angle16, 0, 0, radius or self.radius, 0)
    end
end

local function updateCommon(self)
    self.travel = self.travel + self.speed
    local dx, dy = Core.polar(self.angle16, self.travel)
    local x, y = self.anchorX + dx, self.anchorY + dy
    local id, age, d = self.projectileId, self.age, difficulty()

    if id == 0x01 then
        self.speed = self.speed + Core.diff({0.06, 0.07, 0.08, 0.10, 0.10}, d)
    elseif id == 0x02 then
        if age == 0 then self.speed = 0.1 + self.baseSpeed / 30
        elseif age <= 30 then self.speed = self.speed + self.baseSpeed / 30 end
    elseif id == 0x03 then
        if age == 0 then self.speed = 0.1
        elseif age >= 30 and age <= 90 then self.speed = self.speed + self.baseSpeed / 60 end
    elseif id == 0x04 then
        if age == 0 then self.speed = 0.1
        elseif age >= 12 and age <= 72 then self.speed = self.speed + self.baseSpeed / 60 end
    elseif id == 0x05 then
        if age == 0 then self.speed = self.baseSpeed * 0.5
        elseif age >= 60 and age <= 120 then self.speed = self.speed + self.baseSpeed / 120 end
    elseif id == 0x06 then
        if age == 0 then self.baseSpeed = self.speed / 5 end
        if age <= 30 and self.baseSpeed < self.speed then self.speed = self.speed - self.baseSpeed / 6 end
    elseif id == 0x07 then
        if age < 40 then self.speed = self.speed - self.baseSpeed / 40
        elseif age <= 99 then self.speed = self.speed + self.baseSpeed / 60 end
    elseif id == 0x09 then
        if age < 30 then
            self.speed = self.speed - self.baseSpeed / 30
        else
            if age == 30 then
                local px, py = playerPosition()
                self.anchorX, self.anchorY = x, y
                self.angle16 = aim16(x, y, px, py)
                self.travel = 0
            end
            self.prevAngle16 = self.angle16
            self.speed = self.speed + Core.diff({0.13, 0.15, 0.175, 0.20, 0.20}, d)
        end
    elseif id == 0x0a then
        if age < 40 then
            self.speed = self.baseSpeed * 1.8 * (1 - age / 40)
        elseif age == 40 then
            local px, py = playerPosition()
            self.anchorX, self.anchorY = x, y
            self.angle16 = aim16(self.prevX, self.prevY, px, py)
            self.prevAngle16 = self.angle16
            self.travel = 0
            self.speed = self.baseSpeed / 60
        elseif age <= 99 then
            self.speed = self.speed + self.baseSpeed / 60
        end
    elseif id == 0x0b then
        if age < 50 then
            self.speed = self.speed - self.baseSpeed / 50
        else
            if age == 50 then
                local px, py = playerPosition()
                self.anchorX, self.anchorY = x, y
                self.angle16 = aim16(self.prevX, self.prevY - 200, px, py)
                self.prevAngle16 = self.angle16
                self.travel = 0
                self.speed = 0
            end
            self.speed = self.speed + 0.07
        end
    elseif id == 0x0d then
        if age > 23 then self.speed = self.speed + Core.diff({0.15, 0.17, 0.18, 0.20, 0.20}, d) end
        if Core.inside(x, y, 30) then M.spawn(4, 0x0f, x, y, self.angle16, 0, 0, self.radius, 0) end
    elseif id == 0x0f and age == 20 then deactivate(self)
    elseif id == 0x10 and age == 40 then deactivate(self)
    elseif id == 0x11 and age == 10 then deactivate(self)
    elseif id == 0x12 and age == 60 then
        terminalEffect(x, y)
        deactivate(self)
    end

    self.ldX, self.ldY = x, y
    if not Core.inside(x, y, 30) then deactivate(self) end
end

local function updateReflect(self)
    self.travel = self.travel + self.speed
    local dx, dy = Core.polar(self.angle16, self.travel)
    local x, y = self.anchorX + dx, self.anchorY + dy
    self.ldX, self.ldY = x, y
    local left = Core.playfieldOriginX()
    local r = self.radius
    if x < left - r or x > left + 600 + r or y < -r or y > 720 + r then
        local a = self.angle16
        if x < left or x > left + 600 then a = -0x8000 - a end
        if y < 0 then a = -a end
        self.angle16 = Core.angle16(a)
        M.spawn(self.visualSelector, 0, x, y, self.angle16, 0, self.speed, r, 0)
        deactivate(self)
    end
    if not Core.inside(x, y, 30) then deactivate(self) end
end

local function updateDirect(self)
    local px, py = playerPosition()
    local target = aim16(self.ldX, self.ldY, px, py)
    local dx, dy = Core.polar(self.angle16, self.speed)
    self.prevX, self.prevY = self.ldX, self.ldY
    self.ldX, self.ldY = self.ldX + dx, self.ldY + dy
    local id, age, d = self.projectileId, self.age, difficulty()

    if id == 0x0c then
        if age < 60 then
            if age == 0 then self.speed = 8 end
            if self.speed > 1.4 then self.speed = self.speed - 0.11 end
            self.angle16 = Core.turn16(self.angle16, target, 0x29a)
        else
            if age == 60 then self.speed = self.baseSpeed + 0.1 else self.speed = self.speed + 0.1 end
            self.angle16 = Core.turn16(self.angle16, target, Core.diff({120,160,200,250,300}, d))
        end
        trail(4, self)
    elseif id == 0x0e then
        local phase = (age + 30) * 2 * pi / 120
        local step = 200
        if age < 240 then
            self.speed = (self.baseSpeed + 3) * 0.5 + sin(phase) * (self.baseSpeed - 3) * 0.5
            local base = Core.diff({200,240,270,300,300}, d)
            step = age < 30 and base + 500 or base + 300 - trunc(sin(phase) * 300)
        else
            self.speed = self.speed + 0.1
        end
        self.angle16 = Core.turn16(self.angle16, target, step)
        trail(5, self)
    elseif id == 0x23 or id == 0x24 then
        if id == 0x24 and age == 0 then
            self.ldX, self.ldY = Core.clampToPlayfield(self.ldX, self.ldY, 30)
        end
        local interval = Core.diff({15,11,9,9,8}, d)
        if age % interval == 0 and inPlayfield(self.ldX, self.ldY) then
            local spread = id == 0x23 and 0x7448 or 0x85dc
            local speed = Core.diff({3.5,4.5,5.5,5.0,6.0}, d)
            M.spread(8, 3, self.ldX, self.ldY, self.angle16, 0, speed, 1, 2, spread, 0)
            if d > 2 then M.spread(8, 3, self.ldX, self.ldY, self.angle16, 0, speed + 1.5, 1, 2, spread, 0) end
        end
        trail(5, self, 1)
        self.speed = self.speed + 0.1
    elseif id == 0x25 then
        trail(4, self)
        if d > 2 then self.angle16 = Core.turn16(self.angle16, target, 0xa0) end
        self.speed = self.speed + 0.1
    elseif id == 0x26 or id == 0x27 then
        trail(id == 0x26 and 5 or 4, self)
        local sign = id == 0x26 and -1 or 1
        self.angle16 = Core.angle16(self.angle16 + sign * Core.diff({150,170,180,195,211}, d))
        self.speed = self.speed + 0.05
    elseif id == 0x2c or id == 0x2d then
        local sign = id == 0x2c and -1 or 1
        self.angle16 = Core.angle16(self.angle16 + sign * Core.diff({150,170,180,195,180}, d))
        self.speed = self.speed + 0.05
    elseif id == 0x35 or id == 0x36 then
        if age < 90 then
            self.angle16 = Core.angle16(self.angle16 + (id == 0x35 and 0x5a or -0x5a))
            self.speed = self.speed + 0.05
        end
    end

    if not Core.inside(self.ldX, self.ldY, 250) then deactivate(self) end
end

local function ownerById(id)
    local rt = runtime()
    return rt and rt.enemiesById and rt.enemiesById[id]
end

local function updateEmitter(self)
    self.travel = self.travel + self.speed
    local dx, dy = Core.polar(self.angle16, self.travel)
    local x, y = self.anchorX + dx, self.anchorY + dy
    self.ldX, self.ldY = x, y
    local id, age, d = self.projectileId, self.age, difficulty()
    local frame = runtime() and runtime().frame or 0
    local px, py = playerPosition()

    if id == 0x17 and age == 25 then
        M.spawn(3, 1, x, y, aim16(x, y, px, py), 0, 2, self.radius, 0)
    elseif id == 0x18 or id == 0x19 then
        local finish = 16 + Core.diff({12,16,20,20,20}, d)
        if age >= 16 and age < finish and age % 2 == 0 then
            local cw = id == 0x19
            local offset = cw and age * 200 + 0x36a0 or -age * 200 - 0x36a0
            M.spawn(cw and 0x0d or 0x0c, 1, x, y, self.angle16 + offset, 0, 1.5, self.radius, 0)
        elseif age == finish then
            terminalEffect(x, y)
            deactivate(self)
        end
    elseif id == 0x1a or id == 0x1b then
        local interval = Core.diff({10,8,6,5,5}, d)
        if age % interval == 0 and inPlayfield(x, y) then
            local mirror = id == 0x1b
            local a = mirror and self.angle16 + age * 250 - 30000 or self.angle16 + (120 - age) * 250
            local s = Core.diff({5,6,6.5,6,7}, d)
            M.spawn(mirror and 9 or 8, 2, x, y, a, 0, s, self.radius, 0)
            if d > 2 then M.spawn(mirror and 9 or 8, 2, x, y, a, 0, s + 1.5, self.radius, 0) end
        end
    elseif id == 0x1c then
        local half = floor((age + frame) / 2)
        local period = Core.diff({18,18,15,16,14}, d)
        if half % period < Core.diff({6,7,8,10,10}, d) and inPlayfield(x, y) then
            local s = Core.diff({3.2,4,4.5,4.5,5.5}, d)
            M.spawn(9, 2, x, y, self.angle16 - 0x4000, 0, s, self.radius, 0)
            M.spawn(9, 2, x, y, self.angle16 + 0x4000, 0, s, self.radius, 0)
        end
    elseif id == 0x1d or id == 0x1e then
        local wave = sin(frame * 2 * 992.969696969697 * pi / 32768) * age
        local lx, ly = Core.polar(self.angle16 + (id == 0x1d and -0x4000 or 0x4000), wave)
        x, y = x + lx, y + ly
        self.ldX, self.ldY = x, y
        local interval = Core.diff({4,3,3,3,2}, d)
        local half, cycle = floor((age + frame) / 2), interval * 2
        local s = Core.diff({2.5,3.2,3.6,4,5}, d)
        if inPlayfield(x, y) and half % cycle == 0 then M.spawn(0x0d, 2, x, y, self.angle16 + 0x4000, 0, s, self.radius, 0) end
        if inPlayfield(x, y) and half >= interval and (half - interval) % cycle == 0 then M.spawn(0x0d, 2, x, y, self.angle16 - 0x4000, 0, s, self.radius, 0) end
    elseif id == 0x21 or id == 0x22 then
        if age == 36 then M.spawn(2, 4, x, y, self.angle16 + (id == 0x21 and 12000 or -12000), 0, self.baseSpeed + 1.2, self.radius, 0) end
    elseif id == 0x28 then
        local parent = ownerById(self.arg)
        if parent then
            local phase = (parent.helperTimer - 60) % 1400
            if phase == 870 or phase == 1020 then
                M.spawn(8, 4, x, y, self.angle16 - 9000, 0, self.baseSpeed - 1, self.radius, 0)
                M.spawn(8, 4, x, y, self.angle16 + 9000, 0, self.baseSpeed - 1, self.radius, 0)
            end
        end
    elseif id == 0x29 or id == 0x2a then
        local interval = Core.diff({8,6,5,5,5}, d)
        if age % interval == 0 and inPlayfield(x, y) then
            local rev = id == 0x2a
            local a = self.angle16 + (rev and (-age * 200 + 24000) or (age * 200 - 24000))
            M.spawn(rev and 9 or 8, 4, x, y, a, 0, Core.diff({3,3.5,3.5,4,5}, d), self.radius, 0)
        end
    elseif id == 0x2b then
        if age == 0 then self.prevX, self.prevY = px, py end
        if age <= 35 and age % 3 == 0 and inPlayfield(x, y) then
            M.spread(0x0c, 4, x, y, aim16(x, y, self.prevX, self.prevY), 0,
                Core.diff({8,10,11,12,12}, d), self.radius,
                Core.diff({1,3,5,7,7}, d), 20000, 0)
        end
    elseif id == 0x2e then
        if not inPlayfield(x, y) then
            local left, a = Core.playfieldOriginX(), self.angle16
            if x < left or x > left + 600 then a = 0x8000 - a end
            if y < 0 or y > 720 then a = -a end
            self.angle16 = Core.angle16(a)
            self.anchorX, self.anchorY = Core.clampToPlayfield(x, y, 0)
            M.spread(0x0d, 5, x, y, self.angle16, 0, Core.diff({4.5,5,5,5.5,5.5}, d), self.radius,
                Core.diff({3,5,6,7,7}, d), 32000, 0)
            deactivate(self)
        end
    elseif id == 0x2f or id == 0x30 then
        if age >= 4 and age < 36 and age % 2 == 0 then
            local rev = id == 0x30
            local a = self.angle16 + (rev and (-age * 0x309 - 12000) or (age * 0x309 + 12000))
            M.spawn(rev and 0x0d or 0x0c, 2, x, y, a, 0, 8.5, self.radius, 0)
        elseif age == 36 then
            terminalEffect(x, y)
            deactivate(self)
        end
    elseif id == 0x31 then
        local left, r = Core.playfieldOriginX(), self.radius
        if x < left - r or x > left + 600 + r or y < -r or y > 720 + r then
            local a = self.angle16
            if x < left or x > left + 600 then a = 0x8000 - a end
            if y < 0 or y > 720 then a = -a end
            self.angle16 = Core.angle16(a)
            self.anchorX, self.anchorY = Core.clampToPlayfield(self.anchorX, self.anchorY, 0)
            M.spawn(10, 0, x, y, self.angle16, 0, self.speed, self.radius, 0)
            deactivate(self)
        end
    elseif id == 0x32 then
        if age % 9 == 0 and (self.visualSelector == 2 or self.visualSelector == 3) then
            local v = self.visualSelector == 2 and 8 or 9
            M.spawn(v, 4, x, y, self.angle16 - 0x115c, 0, 6.4, self.radius, 0)
            M.spawn(v, 4, x, y, self.angle16 + 0x115c, 0, 6.4, self.radius, 0)
        end
    elseif id == 0x33 then
        local left, r = Core.playfieldOriginX(), self.radius
        if x < left-r or x > left+600+r or y < -r or y > 720+r then
            M.spawn(self.visualSelector, 1, x, y, aim16(x, y, px, py), 0, 4, r, 0)
            deactivate(self)
        end
    elseif id == 0x34 and age == 20 then
        M.spawn(5, 1, x, y, aim16(x, y, px, py), 0, 3, self.radius, 0)
    elseif id == 0x37 or id == 0x38 then
        if age < 51 then
            if self.speed > 0 then self.speed = self.speed - self.baseSpeed / 50 end
            if age == 50 then
                local parent = ownerById(self.arg)
                if parent then
                    local base = self.angle16 + (id == 0x37 and 1 or -1) * ((parent.helperTimer % 0x10000) * 0x14d)
                    for i = 0, 2 do M.spawn(8, 2, x, y, base + i * 0x5555, 0, 4.8, self.radius, 0) end
                end
                terminalEffect(x, y)
                deactivate(self)
            end
        end
    elseif id == 0x39 then
        if age < 30 then self.speed = self.speed - self.baseSpeed / 30 end
        if age == 30 then
            M.spawn(2, 2, x, y, self.angle16 - 15000, 0, 5.2, self.radius, 0)
            M.spawn(2, 2, x, y, self.angle16 + 15000, 0, 5.2, self.radius, 0)
            deactivate(self)
        end
    elseif id == 0x3c then
        self.speed = self.speed + 0.15
        local a = scriptRandomAngle(age * 0x5c49 + frame)
        local r = Core.frameRand(age * 0xeac + frame) % 0x0b
        local ox, oy = Core.polar(a, r)
        M.spawn(4, 0x11, x + ox, y + oy, self.angle16, 0, 0, 1, 0)

        local effectRadius = Core.frameRand(age * 0x22b8 + frame) % 0x11
        local effectAngle = scriptRandomAngle(age * 0x378 + frame)
        local ex, ey = Core.polar(effectAngle, effectRadius)
        local effectScale = scriptRandomHundredth(age * 0x15b38 + frame, 0.5, 1.0)
        local color = rainbowPalette[floor(age / 3) % 7 + 1]
        spawnProjectileEffect("snapshot", "ld_effect_s_18", x + ex, y + ey,
                              scriptRandomAngle(age * 0x58 + frame),
                              effectScale, effectScale, 0x10, 0xc0,
                              color[1], color[2], color[3],
                              sourceLayer(0x22), "")
    end

    if not Core.inside(self.ldX, self.ldY, 30) then deactivate(self) end
end

local function updateOrbit(self)
    local age, d = self.age, difficulty()
    local rx, ry = 320, 150
    if age < 40 then
        local ramp = sin(age * pi / 80)
        rx, ry = floor(ramp * 320), floor(ramp * 150)
    end
    if age == 40 then
        local px, py = playerPosition()
        self.prevAngle16 = aim16(self.prevX, self.prevY, px, py)
    elseif age > 40 then
        if self.speed < 4 then self.speed = self.speed + 0.05 end
        local dx, dy = Core.polar(self.prevAngle16, self.speed)
        self.prevX, self.prevY = self.prevX + dx, self.prevY + dy
    end
    local turn = Core.diff({0x46,0x78,0x8c,0xb4,0xdc}, d)
    self.angle16 = Core.angle16(self.angle16 + (self.projectileId == 0x1f and turn or -turn))
    local ox, oy = Core.ellipse(self.angle16, rx, ry, 0)
    self.ldX, self.ldY = self.prevX + ox, self.prevY + oy
    self.anchorX, self.anchorY = self.ldX, self.ldY
    if not Core.inside(self.ldX, self.ldY, 256) then deactivate(self) end
end

local function updateSpiral(self)
    local age = self.age
    if age == 0 then
        self.baseRadius = self.travel
        local _, py = playerPosition()
        self.prevAngle16 = self.anchorY > py and 0xc000 or 0x4000
    end
    local radius = self.baseRadius or self.travel
    if age < 0 then radius = 0 elseif age < 10 then radius = sin(age * pi / 20) * radius end
    self.travel = radius
    self.speed = age * 0.35 - 2
    local dx, dy = Core.polar(self.angle16, self.speed)
    self.anchorX, self.anchorY = self.anchorX + dx, self.anchorY + dy
    self.angle16 = Core.angle16(self.angle16 + (self.projectileId == 0x3a and 0x1bc or -0x1bc))
    dx, dy = Core.polar(self.angle16, radius)
    self.ldX, self.ldY = self.anchorX + dx, self.anchorY + dy
    if not Core.inside(self.anchorX, self.anchorY, floor((self.baseRadius or 0) + 50)) then deactivate(self) end
end

local function queueAfterimages(self)
    local visual, age = self.visualSelector, self.drawAge
    if visual == 0x13 or visual == 0x14 then
        local clockwise = visual == 0x14
        spawnProjectileEffect("snapshot", clockwise and "ld_enemy_s_119" or "ld_enemy_s_118",
                              self.ldX, self.ldY,
                              (clockwise and 1 or -1) * age * 0x457,
                              1, 1, 0x10, 0x60,
                              0xff, 0xff, 0xff, sourceLayer(0x22),
                              "mul+add")
    end
    local layerOffset = trailLayer[self.projectileId]
    if layerOffset then
        local sx, sy = visualScale(visual, age)
        spawnProjectileEffect("snapshot", self.img, self.ldX, self.ldY,
                              visualAngle(visual, age, self.angle16), sx, sy,
                              0x0c, 0x40, 0xff, 0xff, 0xff,
                              sourceLayer(0x50 + layerOffset), "mul+add")
    end
end

local ProjectileMotionDispatcher = {}
ProjectileMotionDispatcher.__index = ProjectileMotionDispatcher
M.MotionDispatcher = ProjectileMotionDispatcher

function ProjectileMotionDispatcher.new(commonTypes, directTypes, emitterTypes)
    return setmetatable({
        commonTypes = commonTypes,
        directTypes = directTypes,
        emitterTypes = emitterTypes,
    }, ProjectileMotionDispatcher)
end

function ProjectileMotionDispatcher:update(projectile)
    local id = projectile.projectileId
    if self.commonTypes[id] then
        updateCommon(projectile)
        projectile.drawQueued = true
    elseif id == 0x08 then
        updateReflect(projectile)
        projectile.drawQueued = true
    elseif self.directTypes[id] then
        updateDirect(projectile)
        projectile.drawQueued = true
    elseif self.emitterTypes[id] then
        updateEmitter(projectile)
        projectile.drawQueued = true
    elseif id == 0x1f or id == 0x20 then
        updateOrbit(projectile)
        projectile.drawQueued = true
    elseif id == 0x3a or id == 0x3b then
        updateSpiral(projectile)
        projectile.drawQueued = true
    elseif id == 0x13 or id == 0x15 then
        if projectile.age == 0 then
            projectile.collisionEnabled = false
            projectile.grazed = true
            projectile.group = GROUP_GHOST
        elseif projectile.age == 1 then
            deactivate(projectile)
        end
    elseif id == 0x14 then
        if projectile.age == 0 then
            projectile.collisionEnabled = false
            projectile.grazed = true
            projectile.group = GROUP_GHOST
        elseif projectile.age == 3 then
            deactivate(projectile)
        end
    else
        deactivate(projectile)
    end
end

local motionDispatcher = ProjectileMotionDispatcher.new(common, direct, emitter)
M.motionDispatcher = motionDispatcher

local function projectileCollisionPoint(self)
    local x, y
    if direct[self.projectileId] then
        x, y = self.ldX, self.ldY
    else
        x, y = self.anchorX, self.anchorY
    end
    local dx, dy = Core.polar(self.angle16, self.travel)
    return x + dx, y + dy
end

function M.hitPlayer(projectile)
    if not projectile then return end
    deactivate(projectile)
end

function M.cancelFromPlayer(projectile, source, ordinal)
    if not projectile or not source then return false end
    local resolvedOrdinal = ordinal
    if resolvedOrdinal == nil then
        resolvedOrdinal = projectileRegistry:ordinal(projectile, runtime())
    end
    projectile.active = false
    projectile.collisionEnabled = false
    projectile.grazed = true
    projectile.colli = false
    projectile.group = GROUP_GHOST
    projectile._deleteNextFrame = true
    local rt = runtime()
    projectile._deactivatedFrame = rt and rt.frame or 0

    local sourceType = source.specialType or source.type
    local noReward = source._ldCancelNoReward or
        sourceType == 0x16 or sourceType == 0x1e
    if not noReward then
        New(cancelRewardDriverClass, projectile, sourceType, resolvedOrdinal,
            rt and rt.frame or 0)
    end
    return true
end

local noPlayerSideCancelObjects = {}

local function playerSideCancelObjects()
    local rt = runtime()
    if rt then
        local objects = rt.playerSideObjects
        if not objects then return noPlayerSideCancelObjects end
        local frame = rt.frame or 0
        if rt._ldPlayerSideCancelListFrame ~= frame then
            rt._ldPlayerSideCancelListFrame = frame
            local compact = {}
            for _, object in ipairs(objects) do
                if object.status ~= "del" and object.status ~= "kill" and
                   (object.active or object._ldFinishedFrame == frame) then
                    compact[#compact + 1] = object
                end
            end
            rt.playerSideObjects = compact
            objects = compact
        end
        return objects
    end
    local objects, seen = {}, {}
    local function collect(group)
        if group == nil or type(ObjList) ~= "function" then return end
        for _, object in ObjList(group) do
            if not seen[object] and object._ldProjectileCancel then
                seen[object] = true
                objects[#objects + 1] = object
            end
        end
    end
    collect(rawget(_G, "GROUP_SPELL"))
    collect(rawget(_G, "GROUP_GHOST"))
    return objects
end

local function updatePlayerSideCancels(self)
    local objects = playerSideCancelObjects()
    if #objects == 0 then return end
    local ordinal = projectileRegistry:ordinal(self, runtime())
    for _, object in ipairs(objects) do
        if object.status ~= "del" and object.status ~= "kill" and
           object._ldProjectileCancel then
            local ignoresFlags = object._ldCancelIgnoresFlags or
                object.specialType == 0x18 or object.specialType == 0x19 or
                object.specialType == 0x1a
            local flagsAllow = self.active and self.collisionEnabled and self.radius ~= 0
            if ignoresFlags or flagsAllow then
                local objectRadius = max(0, object.radius or 0)
                local radius = objectRadius + self.radius
                local dx = (object.ldX or 0) - self.ldX
                local dy = (object.ldY or 0) - self.ldY
                if dx * dx + dy * dy < radius * radius then
                    M.cancelFromPlayer(self, object, ordinal)
                end
            end
        end
    end
end

local function grazeAllowed(rt)
    if rt and (tonumber(rt.routeMode or 0) or 0) < 0 then return false end
    if not rt then return true end
    local state = rt.pauseFlowState or rt.pause_flow_state
    return not (rt.gameOverDelay or rt.game_over_delay or
                state == "GameOverDelay" or state == "game_over_delay")
end

local function updatePlayerHitAndGraze(self)
    if not self.active or self.radius <= 0 then return end
    local p = rawget(_G, "player")
    if not p or not p.ldX or not p.ldY then return end
    local x, y = projectileCollisionPoint(self)
    local dx, dy = p.ldX - x, p.ldY - y
    local distanceSquared = dx * dx + dy * dy
    local focus = (p.focusTransition or 0) + 2
    local playerHitRadius = (focus < 0 or focus > 4) and 3 or 4
    local hitRadius = self.radius + playerHitRadius
    if distanceSquared <= hitRadius * hitRadius then
        local playerClass = LikeDreamer.PlayerClass
        if playerClass and p.class == playerClass and
                type(playerClass._takeHit) == "function" then
            playerClass._takeHit(p, self)
        else
            M.hitPlayer(self)
            if (p.invulnerableFrames or 0) == 0 then
                p.playerStateTimer = 280
                p.invulnerableFrames = 300
            end
        end
        return
    end
    if not self.collisionEnabled or self.grazed then return end
    local rt = runtime()
    if not grazeAllowed(rt) then return end
    local grazeRadius = self.radius + 48
    if distanceSquared > grazeRadius * grazeRadius then return end

    self.grazed = true
    local ordinal = projectileRegistry:activeOrdinal(self, rt)
    spawnGrazeEffects(self, p, x, y, ordinal)
    local Reward = LikeDreamer.Reward
    if Reward and type(Reward.onGraze) == "function" then
        Reward.onGraze(rt, p)
    else
        local count = (p.graze or 0) + 1
        p.graze = count
        lstg.var = lstg.var or {}
        lstg.var.graze = count
        if rt then
            rt.graze = count
            rt.hudSpecialGaugeFlashTimer = 60
        end
        if lstg.CheckRes(5, "ld_se_Graze") then
            lstg.PlaySound("ld_se_Graze", 0.5, 0)
        end
    end
end

function bulletClass:frame()
    projectileRegistry:prepare(runtime())
    if self._deleteNextFrame then
        self._deleteNextFrame = false
        Del(self)
        return
    end
    if not self.active then
        Del(self)
        return
    end
    self.drawAge = self.age
    self.drawQueued = false
    motionDispatcher:update(self)
    if self.drawQueued then queueAfterimages(self) end
    self.age = self.age + 1
    sync(self)
    local x,y = projectileCollisionPoint(self)
    self.x,self.y = Core.toWorld(x,y)
    self.colli = self.active and self.collisionEnabled and self.radius > 0
    if self.colli then self.group = GROUP_ENEMY_BULLET end
end

function bulletClass:render()
    if not self.drawQueued then return end
    local v, age = self.visualSelector, self.drawAge
    local sx, sy = visualScale(v, age)
    local drawAngle = visualAngle(v, age, self.angle16)
    local x,y = Core.toWorld(self.ldX,self.ldY)
    Render(self.img, x, y, Core.angleToDeg(drawAngle),
           sx, sy)
end

function M.spawn(visual, projectileId, x, y, angle, initialTravel, speed, radius, arg)
    local p = rawget(_G, "player")
    local playerStateTimer = p and p.playerStateTimer
    local rt = runtime()
    playerStateTimer = projectileRegistry:spawnPlayerStateTimer(rt, playerStateTimer)
    if playerStateTimer and playerStateTimer >= 0x79 and playerStateTimer <= 0x103 then
        return nil
    end
    if rt and (rt.bulletCount or 0) >= 0x800 then return nil end
    return New(bulletClass, visual, projectileId, x, y,
               Core.angle16(trunc(angle or 0)),
               initialTravel or 0, speed or 0, radius or 1, arg or 0)
end

function M.spread(visual, projectileId, x, y, center, initialTravel, speed, radius, count, spread, arg)
    count = trunc(count or 1)
    if count <= 0 then return end
    center = Core.angle16(trunc(center or 0))
    spread = trunc(spread or 0)
    if count == 1 then
        M.spawn(visual, projectileId, x, y, center, initialTravel, speed, radius, arg)
        return
    end
    if spread == 0x10000 then
        local step = trunc(0x10000 / count)
        for i = 0, count - 1 do
            M.spawn(visual, projectileId, x, y, center + i * step,
                    initialTravel, speed, radius, arg)
        end
    else
        local start = center - trunc(spread / 2)
        local step = spread > 0 and trunc(spread / (count - 1)) or 0
        for i = 0, count - 1 do
            M.spawn(visual, projectileId, x, y, start + i * step,
                    initialTravel, speed, radius, arg)
        end
    end
end

function M.clear()
    local bullets, seen = {}, {}
    local function collect(group)
        for _, b in ObjList(group) do
            if b.class == bulletClass and not seen[b] then
                seen[b] = true
                bullets[#bullets + 1] = b
            end
        end
    end
    collect(GROUP_ENEMY_BULLET)
    collect(GROUP_GHOST)

    for _, b in ipairs(bullets) do
        local x, y = projectileCollisionPoint(b)
        terminalEffect(x, y)
        b.active = false
        b.collisionEnabled = false
        b.colli = false
        b.group = GROUP_GHOST
        b._deleteNextFrame = false
        releaseCount(b)
        Del(b)
    end
end

return M
