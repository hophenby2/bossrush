-- Like Dreamer score items, death payouts, and post-death Counter entities.

LikeDreamer = LikeDreamer or {}

local Core = assert(LikeDreamer.Core, "LikeDreamer.Core is required")
local Projectile = assert(LikeDreamer.Projectile, "LikeDreamer.Projectile is required")
local M = {}
LikeDreamer.Reward = M

local floor, ceil = math.floor, math.ceil
local min, max = math.min, math.max
local sin, pi = math.sin, math.pi

local ITEM_CAP = 0x2000
local ENTITY_CAP = 0x200
local LIFE_CAP = 8
local SCORE_ITEM_BASE = 100
local STOCK_THRESHOLDS = { 56000, 70000, 70000, 70000, 70000 }
local EXTEND_THRESHOLDS = {
    { 4000000, 16000000, 80000000, 400000000, 2000000000 },
    { 6000000, 24000000, 120000000, 600000000, 3000000000 },
    { 8000000, 32000000, 160000000, 800000000, 4000000000 },
    { 10000000, 40000000, 200000000, 1000000000, 5000000000 },
    { 10000000, 40000000, 200000000, 1000000000, 5000000000 },
}
local COUNTER_INTERVALS = { 5, 4, 3, 2, 2 }
local COUNTER_MINIMUM_SPEED = { 3.5, 4.0, 4.5, 5.5, 6.5 }

local rewardWeights = {
    [0x06]=30,[0x07]=30,[0x08]=30,[0x09]=0,[0x0a]=10,[0x0b]=5,
    [0x0c]=7,[0x0d]=5,[0x0e]=24,[0x0f]=30,[0x10]=120,[0x11]=1,
    [0x12]=0,[0x13]=0,[0x14]=0,[0x15]=10,[0x16]=10,[0x17]=10,
    [0x19]=6,[0x1a]=5,[0x1b]=20,[0x1c]=30,[0x1d]=5,[0x1e]=7,
    [0x1f]=50,[0x20]=120,[0x21]=32,[0x22]=0,[0x23]=0,[0x24]=0,
    [0x25]=8,[0x26]=20,[0x27]=24,[0x28]=1,[0x29]=24,[0x2a]=1,
    [0x2b]=64,[0x2c]=7,[0x2d]=30,[0x2e]=120,[0x2f]=1,
    [0x35]=5,[0x36]=5,[0x37]=5,[0x38]=24,[0x39]=50,[0x3a]=50,
    [0x3b]=5,[0x3c]=10,[0x3d]=48,[0x3e]=1,[0x3f]=120,

    [0x44]=5,[0x45]=7,[0x46]=12,[0x47]=20,[0x48]=20,[0x49]=5,
    [0x4a]=42,[0x4b]=1,[0x4c]=4,[0x4d]=80,[0x4e]=8,[0x4f]=120,
    [0x50]=0,[0x51]=0,[0x52]=0,[0x53]=1,[0x54]=0,[0x55]=2,
    [0x56]=1,[0x57]=12,[0x58]=12,[0x59]=20,[0x5a]=6,[0x5b]=6,
    [0x5c]=6,[0x5d]=20,[0x5e]=36,[0x5f]=77,[0x60]=1,
    [0x70]=10,[0x71]=24,[0x72]=24,[0x73]=36,[0x74]=10,[0x75]=15,
    [0x76]=64,[0x77]=100,[0x78]=12,
    [0x95]=5,[0x96]=5,[0x97]=7,[0x98]=7,[0x99]=7,[0x9a]=80,
    [0x9b]=24,[0x9c]=24,[0x9e]=24,[0x9f]=24,[0xa1]=24,[0xa2]=24,
    [0xa4]=120,[0xad]=5,
    [0xfa]=5,[0xfb]=5,[0xfc]=10,[0xfd]=16,[0xfe]=24,[0xff]=1,
    [0x100]=24,[0x101]=1,[0x102]=36,[0x103]=48,[0x104]=48,
}

local rewardWindows = {
    [0x06]=500,[0x07]=500,[0x08]=500,[0x0a]=400,[0x0b]=300,
    [0x0c]=0x168,[0x0d]=0x1e0,[0x0e]=500,[0x0f]=500,
    [0x10]=0x708,[0x11]=0x4b0,
    [0x19]=300,[0x1a]=300,[0x1b]=500,[0x1c]=500,[0x1d]=1000,
    [0x1e]=1000,[0x1f]=0x708,[0x20]=0x708,[0x21]=1000,
    [0x25]=300,[0x26]=500,[0x27]=500,[0x29]=500,[0x2b]=1000,
    [0x2c]=1000,[0x2d]=1000,[0x2e]=0x708,
    [0x35]=200,[0x36]=300,[0x37]=300,[0x38]=500,[0x39]=1000,
    [0x3a]=1000,[0x3b]=1000,[0x3c]=1000,[0x3d]=500,[0x3f]=0x708,

    [0x44]=200,[0x45]=0xf0,[0x46]=500,[0x47]=500,[0x48]=500,
    [0x49]=500,[0x4a]=500,[0x4c]=300,[0x4d]=500,[0x4e]=500,
    [0x4f]=0x708,
    [0x57]=500,[0x58]=500,[0x59]=500,[0x5a]=1000,[0x5b]=1000,
    [0x5c]=1000,[0x5d]=1000,[0x5e]=1000,[0x5f]=0x708,
    [0x70]=0x168,[0x71]=500,[0x72]=500,[0x73]=500,[0x74]=600,
    [0x75]=600,[0x76]=800,[0x77]=0x708,[0x78]=0x708,
    [0x95]=1000,[0x96]=1000,[0x97]=1000,[0x98]=1000,[0x99]=1000,
    [0x9a]=0x708,[0x9b]=500,[0x9c]=500,[0x9e]=500,[0x9f]=500,
    [0xa1]=500,[0xa2]=500,[0xa4]=0x960,[0xa6]=0x960,
    [0xfa]=200,[0xfb]=200,[0xfc]=300,[0xfd]=300,[0xfe]=500,
    [0x100]=500,[0x102]=500,[0x103]=500,[0x104]=500,
}

local feedbackStrength = {
    [0x06]=12,[0x07]=12,[0x08]=12,[0x0a]=5,[0x0b]=3,[0x0c]=3,
    [0x0d]=3,[0x0e]=8,[0x0f]=8,[0x10]=30,[0x11]=10,[0x15]=8,
    [0x16]=8,[0x17]=8,[0x19]=3,[0x1a]=3,[0x1b]=8,[0x1c]=8,
    [0x1d]=5,[0x1e]=5,[0x1f]=12,[0x20]=30,[0x21]=9,[0x25]=4,
    [0x26]=8,[0x27]=8,[0x28]=8,[0x29]=8,[0x2b]=16,[0x2c]=5,
    [0x2d]=10,[0x2e]=30,[0x30]=8,[0x32]=1,[0x33]=1,[0x34]=5,
    [0x35]=2,[0x36]=3,[0x37]=3,[0x38]=8,[0x39]=10,[0x3a]=10,
    [0x3b]=1,[0x3c]=1,[0x3d]=8,[0x3f]=30,[0x40]=8,
}

local deathEffectModes = {
    [0x06]=1,[0x07]=1,[0x08]=1,[0x0e]=1,[0x0f]=1,[0x11]=1,
    [0x15]=1,[0x16]=1,[0x17]=1,[0x1b]=1,[0x1c]=1,[0x21]=1,
    [0x22]=1,[0x23]=1,[0x24]=1,[0x26]=1,[0x27]=1,[0x29]=1,
    [0x2d]=1,[0x38]=1,[0x39]=1,[0x3a]=1,[0x3d]=1,
    [0x46]=1,[0x47]=1,[0x48]=1,[0x4a]=1,
    [0x57]=1,[0x58]=1,[0x59]=1,[0x5d]=1,[0x5e]=1,
    [0x71]=1,[0x72]=1,[0x73]=1,[0x75]=1,[0x78]=1,
    [0x76]=2,
    [0x9b]=1,[0x9c]=1,[0x9e]=1,[0x9f]=1,[0xa1]=1,[0xa2]=1,
    [0xfe]=1,[0x100]=1,[0x102]=1,[0x103]=1,[0x104]=1,
}

local deferredDeathEffects = {
    [0x10]=true,[0x1f]=true,[0x20]=true,[0x2b]=true,[0x2e]=true,
    [0x3f]=true,[0x4f]=true,
}

local deferredDeathMotion = {
    [0x10]=0.1,[0x20]=1,[0x2b]=0.1,[0x2e]=0.1,[0x3f]=0.06,
    [0x4f]=0.15,
}

local noGenericReward = {
    [0x09]=true,[0x12]=true,[0x13]=true,[0x14]=true,[0x22]=true,
    [0x23]=true,[0x24]=true,[0x28]=true,[0x2a]=true,[0x31]=true,
    [0x3e]=true,[0x4b]=true,[0x50]=true,[0x51]=true,[0x52]=true,
    [0x53]=true,[0x54]=true,[0x55]=true,[0x56]=true,[0x60]=true,
    [0xff]=true,[0x101]=true,[0x137]=true,[0x153]=true,
}

local function trunc(value)
    return value < 0 and ceil(value) or floor(value)
end

local function randomAngle(seed)
    local value = Core.frameRand(seed)
    return Core.angle16(value - floor(value / 0x10001))
end

local function randomItemDriftAngle(seed)
    return Core.angle16(Core.frameRand(seed) % 0x801 + 0x3c00)
end

local function randomInt(seed, minimum, maximum)
    if minimum == maximum then return minimum end
    return minimum + Core.frameRand(seed) % (maximum - minimum + 1)
end

local function randomHundredth(seed, minimum, maximum)
    local minimum100 = trunc(minimum * 100)
    local maximum100 = trunc(maximum * 100)
    if minimum100 == maximum100 then return minimum end
    return (minimum100 + Core.frameRand(seed) %
        (maximum100 - minimum100 + 1)) / 100
end

local function runtime()
    return LikeDreamer.runtime
end

local function currentPlayer(rt)
    return (rt and rt.player) or rawget(_G, "player")
end

local function playerPosition(rt)
    local p = currentPlayer(rt)
    return p and p.ldX or 360, p and p.ldY or 600
end

local function playerStateTimer(rt)
    local p = currentPlayer(rt)
    return p and (p.playerStateTimer or 0) or 0
end

local function runScore()
    if rawget(_G, "system") and type(system.getScore) == "function" then
        return tonumber(system.getScore()) or 0
    end
    return tonumber(lstg.var and lstg.var.score) or 0
end

local function addRunScore(amount)
    if amount <= 0 then return end
    if rawget(_G, "system") and type(system.addScore) == "function" then
        system.addScore(amount)
    else
        lstg.var = lstg.var or {}
        lstg.var.score = max(0, (tonumber(lstg.var.score) or 0) + amount)
    end
end

local function play(name, volume)
    if lstg.CheckRes(5, name) then lstg.PlaySound(name, volume or 0.45, 0) end
end

local function setSpecialGauge(rt, value)
    local p = currentPlayer(rt)
    if p then p.specialGauge = value end
    if rt then
        rt.specialGauge = value
        rt.special_gauge = value
    end
    if lstg.var then lstg.var.like_dreamer_special_gauge = value end
end

function M.addSpecialGauge(rt, amount)
    rt = rt or runtime()
    local p = currentPlayer(rt)
    local value = p and p.specialGauge or
        (rt and (rt.specialGauge or rt.special_gauge)) or
        (lstg.var and lstg.var.like_dreamer_special_gauge) or 0
    if value < 0 or amount <= 0 then return value end
    value = max(0, value + trunc(amount))
    setSpecialGauge(rt, value)
    return value
end

function M.flashGauge(rt, frames)
    rt = rt or runtime()
    if rt then rt.hudSpecialGaugeFlashTimer = max(0, trunc(frames or 60)) end
end

local function stockThreshold(rt)
    local difficulty = Core.clamp(rt and rt.difficulty or 1, 0, 4)
    return STOCK_THRESHOLDS[difficulty + 1]
end

local function tokenStock(rt)
    local p = currentPlayer(rt)
    -- THEIS consumes bombs through lstg.var; keep that authoritative so a
    -- post-award cached player field cannot hide later bomb use.
    local value = lstg.var and lstg.var.bomb
    if value == nil and p then value = p.tokenStock end
    if value == nil and rt then value = rt.tokenStock end
    return Core.clamp(trunc(tonumber(value) or 0), 0, 3)
end

local function setTokenStock(rt, value)
    value = Core.clamp(trunc(value), 0, 3)
    local p = currentPlayer(rt)
    if p then p.tokenStock = value end
    if rt then rt.tokenStock = value end
    lstg.var = lstg.var or {}
    lstg.var.bomb = value
end

local function lifeStock()
    local value = tonumber(lstg.var and lstg.var.lifeleft) or 0
    if rawget(_G, "system") and type(system.getLife) == "function" then
        value = tonumber(system.getLife()) or value
    end
    return floor(value)
end

local function setLifeStock(value)
    value = Core.clamp(floor(tonumber(value) or 0), -1, LIFE_CAP)
    lstg.var = lstg.var or {}
    if rawget(_G, "system") and type(system.setLife) == "function" then
        value = tonumber(system.setLife(value, true)) or value
    end
    lstg.var.lifeleft = value
    return value
end

local function persistProgress(rt)
    if not rt then return end
    lstg.var = lstg.var or {}
    lstg.var.like_dreamer_stock_progress = rt.stockProgress
    lstg.var.like_dreamer_score_item_base = rt.scoreItemBaseValue
    lstg.var.like_dreamer_extend_index = rt.extendIndex
end

local function inferExtendIndex(rt)
    local thresholds = EXTEND_THRESHOLDS[Core.clamp(
        floor(tonumber(rt and rt.difficulty) or 1), 0, 4) + 1]
    local score = runScore()
    local index = 0
    while index < #thresholds and score >= thresholds[index + 1] do
        index = index + 1
    end
    return index
end

function M.processScoreExtends(rt)
    if not rt then return end
    local thresholds = EXTEND_THRESHOLDS[Core.clamp(
        floor(tonumber(rt.difficulty) or 1), 0, 4) + 1]
    local index = Core.clamp(floor(tonumber(rt.extendIndex) or 0), 0, #thresholds)
    local score = runScore()
    if index < #thresholds and score >= thresholds[index + 1] then
        play("ld_se_Extend", 0.5)
        setLifeStock(max(0, lifeStock()) + 1)
        index = index + 1
    end
    rt.extendIndex = index
    lstg.var.like_dreamer_extend_index = index
end

function M.processStockProgress(rt, gain)
    if not rt then return end
    local threshold = stockThreshold(rt)
    rt.stockProgress = min(threshold * 3,
        (rt.stockProgress or 0) + max(0, trunc(gain or 0)))
    local stock = tokenStock(rt)
    if stock < 3 and rt.stockProgress >= (stock + 1) * threshold then
        setTokenStock(rt, stock + 1)
        play("ld_se_DreamPower", 0.5)
    end
    persistProgress(rt)
end

function M.onGraze(rt, p)
    rt = rt or runtime()
    p = p or currentPlayer(rt)
    local count = (p and p.graze or rt and rt.graze or
        lstg.var and lstg.var.graze or 0) + 1
    if p then p.graze = count end
    if rt then rt.graze = count end
    lstg.var = lstg.var or {}
    lstg.var.graze = count
    M.flashGauge(rt, 60)
    play("ld_se_Graze", 0.5)
    return count
end

function M.applyGrazeReward(rt)
    rt = rt or runtime()
    if not rt then return end
    rt.scoreItemBaseValue = (rt.scoreItemBaseValue or SCORE_ITEM_BASE) + 1
    local difficultyScale = max(0.6,
        1 - floor((rt.difficulty or 0) / 2) * 0.1)
    M.addSpecialGauge(rt, difficultyScale * 30)
    persistProgress(rt)
end

local function effectLayer(sourceLayer)
    return (rawget(_G, "LAYER_ENEMY_BULLET") or -200) + sourceLayer - 0x50
end

local function registerEffect(self, rt)
    self.runtime = rt
    self._counted = true
    rt.projectileEffectCount = (rt.projectileEffectCount or 0) + 1
end

local function releaseEffect(self)
    if not self._counted then return end
    self._counted = false
    local rt = self.runtime
    if rt then
        rt.projectileEffectCount = max(0,
            (rt.projectileEffectCount or 1) - 1)
    end
end

local deathEffectClass = Class(object)
M.EnemyDeathEffectClass = deathEffectClass

function deathEffectClass:init(rt, kind, image, x, y, angle16, speed, scale,
                               lifetime, alpha, layer, sourceFrame)
    self.kind = kind
    self.image = image
    self.ldX, self.ldY = x, y
    self.angle16 = Core.angle16(angle16 or 0)
    self.speed = speed or 0
    self.scale = scale or 1
    self.lifetime = lifetime or 0
    self.alpha = alpha or 0xff
    self.sourceFrame = sourceFrame or (rt and rt.frame or 0)
    self.age = -1
    self.drawAge = -1
    self.group = GROUP_GHOST
    self.layer = effectLayer(layer or 0x3e)
    self.bound = false
    self.colli = false
    if kind == "spark" then
        self.random = Core.frameRand(self.angle16 + self.sourceFrame)
        self.lifetime = self.random % 21 + 30
        self.pulseStart = self.random % 26 + 5
    end
    registerEffect(self, rt)
    Core.syncObject(self, x, y)
end

function deathEffectClass:del() releaseEffect(self) end
function deathEffectClass:kill() releaseEffect(self) end

function deathEffectClass:frame()
    self.age = self.age + 1
    local age = self.age
    self.drawAge = age
    if self.kind == "burst" then
        local dx, dy = Core.polar(self.angle16, self.speed)
        self.ldX, self.ldY = self.ldX + dx, self.ldY + dy
        self.drawAngle16 = Core.angle16(self.angle16 + age * 0x640)
        self.drawScaleX, self.drawScaleY = self.scale, self.scale
        self.drawAlpha = self.alpha
        if age >= self.lifetime - 8 then
            self.drawAlpha = self.alpha - trunc(
                ((age - self.lifetime) + 8) * self.alpha * 0.125)
        end
    elseif self.kind == "spark" then
        local moveSpeed = self.speed *
            (1 - sin(age * pi / (2 * self.lifetime)))
        local dx, dy = Core.polar(self.angle16, moveSpeed)
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
    elseif self.kind == "ring" then
        local drawScale = sin(age * pi / (2 * max(1, self.lifetime))) *
            self.scale
        self.drawScaleX, self.drawScaleY = drawScale, drawScale
        self.drawAngle16 = self.angle16
        self.drawAlpha = self.alpha
        if age >= self.lifetime - 8 then
            self.drawAlpha = self.alpha - trunc(
                ((age - self.lifetime) + 8) * self.alpha * 0.125)
        end
    elseif self.kind == "center" then
        self.scale = self.scale + 0.1
        self.drawScaleX, self.drawScaleY = self.scale, self.scale
        self.drawAngle16 = 0
        self.drawAlpha = age > 0x1f and 0x2ff - age * 0x10 or 0xff
    end
    Core.syncObject(self, self.ldX, self.ldY)
    if age >= self.lifetime then Del(self) end
end

function deathEffectClass:render()
    local age = self.drawAge
    if age < 0 or age >= self.lifetime then return end
    local scaleX = self.drawScaleX or self.scale
    local scaleY = self.drawScaleY or self.scale
    if self.kind == "burst" and age < 8 then
        local entrance = sin(age * pi / 16)
        scaleX, scaleY = scaleX * entrance, scaleY * entrance
    end
    local alpha = Core.clamp(trunc(self.drawAlpha or self.alpha), 0, 0xff)
    if alpha <= 0 then return end
    SetImageState(self.image, self.kind == "center" and "mul+add" or "",
        Color(alpha, 255, 255, 255))
    Render(self.image, self.x, self.y,
        Core.angleToDeg(self.drawAngle16 or self.angle16),
        scaleX * 1, scaleY * 1)
    SetImageState(self.image, "", Color(255, 255, 255, 255))
end

local function spawnDeathEffect(rt, kind, image, x, y, angle16, speed, scale,
                                lifetime, alpha, layer, sourceFrame)
    if not rt or (rt.projectileEffectCount or 0) >= 0x1000 then return nil end
    if rt.stageEffectTrace then
        rt.stageEffectTrace[#rt.stageEffectTrace + 1] = {
            kind = "enemy_death_" .. kind, img = image, x = x, y = y,
            angle16 = angle16, speed = speed, scale = scale,
            lifetime = lifetime, alpha = alpha, layer = layer,
        }
    end
    return New(deathEffectClass, rt, kind, image, x, y, angle16, speed,
        scale, lifetime, alpha, layer, sourceFrame)
end

local rewardItemClass = Class(object)
M.ItemClass = rewardItemClass

local function releaseItem(self)
    if not self._counted then return end
    self._counted = false
    local rt = self.runtime
    if rt then rt.rewardItemCount = max(0, (rt.rewardItemCount or 1) - 1) end
end

function rewardItemClass:init(itemType, x, y, angle16, speed, radiusOrScale)
    self.itemType = trunc(itemType or 0)
    self.ldX, self.ldY = x, y
    self.angle16 = Core.angle16(trunc(angle16 or 0))
    self.speed = speed or 0
    self.radiusOrScale = radiusOrScale or 12
    self.age, self.drawAge = 0, 0
    self.homing = false
    self.active = true
    self.runtime = runtime()
    self.group = GROUP_GHOST
    self.layer = effectLayer(self.itemType >= 6 and 0x4c or 0x41)
    self.bound = false
    self.colli = false
    self._counted = true
    if self.runtime then
        self.runtime.rewardItemCount = (self.runtime.rewardItemCount or 0) + 1
    end
    Core.syncObject(self, self.ldX, self.ldY)
end

function rewardItemClass:del() releaseItem(self) end
function rewardItemClass:kill() releaseItem(self) end

local scorePopupClass = Class(object)
M.ScorePopupClass = scorePopupClass

function scorePopupClass:init(rt, x, y, angle16, value, speed, scale)
    self.ldX, self.ldY = x, y
    self.angle16 = Core.angle16(angle16)
    self.value = max(0, trunc(value or 0))
    self.speed = speed
    self.displayScale = scale
    self.lifetime = 40
    self.age, self.drawAge = 0, 0
    self.group = GROUP_GHOST
    self.layer = effectLayer(0x42)
    self.bound = false
    self.colli = false
    registerEffect(self, rt)
    Core.syncObject(self, x, y)
end

function scorePopupClass:del() releaseEffect(self) end
function scorePopupClass:kill() releaseEffect(self) end

function scorePopupClass:frame()
    self.drawAge = self.age
    local dx, dy = Core.polar(self.angle16, self.speed)
    self.ldX, self.ldY = self.ldX + dx, self.ldY + dy
    Core.syncObject(self, self.ldX, self.ldY)
    if self.age == self.lifetime then Del(self); return end
    self.age = self.age + 1
end

function scorePopupClass:render()
    local age = self.drawAge
    if age < 0 or age >= self.lifetime then return end
    local entrance = age < 5 and sin(age * pi / 10) or 1
    local alpha = 0x80
    if age >= self.lifetime - 8 then
        alpha = trunc(sin((age - (self.lifetime - 16)) * pi / 16) * alpha)
    end
    if alpha <= 0 or entrance <= 0 then return end

    local value = self.value
    if age < 20 then value = trunc(value / 20) * age end
    local digitCount = 1
    local n = value
    while n >= 10 do
        digitCount = digitCount + 1
        n = trunc(n / 10)
    end
    local scale = self.displayScale * entrance
    local digitStep = self.displayScale * 16
    local groupGap = self.displayScale * 5
    local offset = (digitCount - 1) * digitStep * 0.5
    if digitCount > 3 then
        offset = offset + trunc(digitCount / 3) * groupGap * 0.5
    end

    local function drawFrame(frame, logicalOffset)
        local image = "ld_num_s_" .. tostring(frame + 1)
        SetImageState(image, "", Color(alpha, 255, 255, 255))
        Render(image, self.x + logicalOffset * Core.worldScale(), self.y, 0,
            scale * 1, scale * 1)
        SetImageState(image, "", Color(255, 255, 255, 255))
    end

    local remaining, ordinal = value, 0
    while remaining >= 10 do
        drawFrame(remaining % 10, offset)
        offset = offset - digitStep
        if ordinal % 3 == 2 and remaining >= 10 then
            offset = offset - groupGap
            drawFrame(10, offset + digitStep)
        end
        remaining = trunc(remaining / 10)
        ordinal = ordinal + 1
    end
    drawFrame(remaining, offset)
end

local stockPortraitClass = Class(object)
M.StockPortraitClass = stockPortraitClass

function stockPortraitClass:init(rt, setupGroup, frameOffset, lifetime)
    -- Resource names are one-based while the source PlayerFrame handle table
    -- is zero-based.
    self.image = "ld_player_frame_" ..
        tostring((frameOffset or 2) + setupGroup * 10 + 1)
    self.lifetime = lifetime or 0x78
    self.age, self.drawAge = 0, 0
    self.group = GROUP_GHOST
    self.layer = (rawget(_G, "LAYER_TOP") or 0) + 97
    self.bound = false
    self.colli = false
    registerEffect(self, rt)
end

function stockPortraitClass:del() releaseEffect(self) end
function stockPortraitClass:kill() releaseEffect(self) end

function stockPortraitClass:frame()
    self.drawAge = self.age
    if self.age == self.lifetime then Del(self); return end
    self.age = self.age + 1
end

function stockPortraitClass:render()
    local age = self.drawAge
    if age < 0 or age >= self.lifetime or not lstg.CheckRes(2, self.image) then
        return
    end
    local alpha = 0xff
    if age < 8 then
        alpha = trunc(sin(age * pi / 16) * alpha)
    elseif age >= self.lifetime - 8 then
        alpha = alpha - trunc(
            sin((age - (self.lifetime - 8)) * pi / 16) * alpha)
    end
    if alpha <= 0 then return end
    LikeDreamer.Viewport.draw(function()
        local box = LikeDreamer.Viewport.capture()
        SetImageState(self.image, "", Color(alpha, 255, 255, 255))
        lstg.Render(self.image, box:mapX(430), box:mapY(360), 0, box.scale, box.scale)
        SetImageState(self.image, "", Color(255, 255, 255, 255))
    end)
end

local lifeBannerClass = Class(object)
M.LifeBannerClass = lifeBannerClass

function lifeBannerClass:init(rt, x, y, angle16)
    self.ldX, self.ldY = x, y
    self.angle16 = Core.angle16(angle16)
    self.lifetime = 0x78
    self.age, self.drawAge = 0, 0
    self.group = GROUP_GHOST
    self.layer = effectLayer(0x4b)
    self.bound = false
    self.colli = false
    registerEffect(self, rt)
    Core.syncObject(self, x, y)
end

function lifeBannerClass:del() releaseEffect(self) end
function lifeBannerClass:kill() releaseEffect(self) end

function lifeBannerClass:frame()
    self.drawAge = self.age
    local dx, dy = Core.polar(self.angle16, 1)
    self.ldX, self.ldY = self.ldX + dx, self.ldY + dy
    Core.syncObject(self, self.ldX, self.ldY)
    if self.age == self.lifetime then Del(self); return end
    self.age = self.age + 1
end

function lifeBannerClass:render()
    local age = self.drawAge
    if age < 0 or age >= self.lifetime or not lstg.CheckRes(2, "ld_state_20") then
        return
    end
    local entrance = age < 5 and sin(age * pi / 10) or 1
    local alpha = 0x80
    if age >= self.lifetime - 8 then
        alpha = trunc(sin((age - (self.lifetime - 16)) * pi / 16) * alpha)
    end
    if alpha <= 0 or entrance <= 0 then return end
    local scale = 1
    SetImageState("ld_state_20", "", Color(alpha, 255, 255, 255))
    Render("ld_state_20", self.x, self.y, 0, scale, entrance * scale)
    if age % 3 == 0 then
        SetImageState("ld_state_20", "mul+add", Color(alpha, 255, 255, 255))
        Render("ld_state_20", self.x, self.y, 0, scale, entrance * scale)
    end
    SetImageState("ld_state_20", "", Color(255, 255, 255, 255))
end

function M.spawnPlayerPortrait(rt, frameOffset, lifetime)
    if not rt or (rt.projectileEffectCount or 0) >= 0x1000 then return nil end
    local p = currentPlayer(rt)
    local setupGroup = Core.clamp(trunc(
        (p and p.setupGroup) or rt.setupGroup or 0), 0, 2)
    return New(stockPortraitClass, rt, setupGroup, frameOffset, lifetime)
end

function M.spawnStockPortrait(rt)
    return M.spawnPlayerPortrait(rt, 2, 0x78)
end

function M.spawnLifeBanner(rt)
    if not rt or (rt.projectileEffectCount or 0) >= 0x1000 then return nil end
    local px, py = playerPosition(rt)
    local random = Core.frameRand(rt.frame or 0)
    local angle = Core.angle16(random % 0x2ee1 - 0x5770)
    return New(lifeBannerClass, rt, px, py - 120, angle)
end

local function collectItem(self)
    local rt = self.runtime or runtime()
    local itemType = self.itemType
    local multiplier = (itemType == 0 or itemType == 3) and 1 or nil
    if itemType == 1 or itemType == 4 then multiplier = 5 end
    if itemType == 2 or itemType == 5 then multiplier = 10 end
    if multiplier then
        local value = (rt and rt.scoreItemBaseValue or SCORE_ITEM_BASE) * multiplier
        if rt and (rt.projectileEffectCount or 0) < 0x1000 then
            local px, py = playerPosition(rt)
            local speed = multiplier == 1 and 2 or (multiplier == 5 and 2.3 or 2.6)
            local scale = multiplier == 1 and 0.8 or (multiplier == 5 and 1 or 1.2)
            New(scorePopupClass, rt, self.ldX, self.ldY,
                Core.aim16(px, py, self.ldX, self.ldY), value, speed, scale)
        end
        addRunScore(value)
        local stage = rt and (rt.stageNumber or rt.stage) or 1
        local gaugeScale = max(0.6, 1 - floor(stage / 2) * 0.1)
        M.addSpecialGauge(rt, trunc(gaugeScale * multiplier * 10))
        play("ld_se_Item1", 0.45)
    elseif itemType == 6 then
        if tokenStock(rt) < 3 then
            rt.stockProgress = (rt.stockProgress or 0) + stockThreshold(rt)
        end
        play("ld_se_Item3", 0.5)
        M.spawnStockPortrait(rt)
    elseif itemType == 7 then
        setLifeStock(max(0, lifeStock()) + 1)
        M.spawnLifeBanner(rt)
        play("ld_se_Extend", 0.5)
    elseif itemType == 8 then
        rt.stockProgress = (rt.stockProgress or 0) + 99999
        setLifeStock(LIFE_CAP)
    end
    M.flashGauge(rt, 60)
    persistProgress(rt)
    self.active = false
    self._deleteNextFrame = true
end

function rewardItemClass:frame()
    if self._deleteNextFrame then
        self._deleteNextFrame = false
        Del(self)
        return
    end
    if not self.active then Del(self); return end
    self.drawAge = self.age
    local rt = self.runtime or runtime()
    local px, py = playerPosition(rt)
    local preX, preY = self.ldX, self.ldY
    local dx, dy = px - preX, py - preY
    local distanceSquared = dx * dx + dy * dy
    local stateTimer = playerStateTimer(rt)
    local movementSpeed = self.speed
    local ordinary = self.itemType >= 0 and self.itemType <= 5
    local special = self.itemType >= 6 and self.itemType <= 8
    if self.age > 0x1f and stateTimer < 0xb4 and py <= 300 and
       (ordinary or self.itemType == 8) then
        self.homing = true
    end

    if ordinary then
        if not self.homing then
            if self.age < 0x21 then
                movementSpeed = self.speed * (1 - sin(self.age * pi / 33))
            end
            if self.age == 0x20 then
                self.speed = 0
                self.angle16 = randomItemDriftAngle((rt and rt.frame or 0) +
                    trunc(preX + preY))
                if stateTimer < 0xb5 then
                    if self.itemType >= 3 then self.homing = true
                    else self.age = 0x21 end
                end
            end
            if self.age > 0x20 and self.speed < 5 then
                self.speed = min(5, self.speed + 0.05)
            end
            local radius = self.radiusOrScale + 160
            if self.age > 0x1f and stateTimer < 0xb5 and
               distanceSquared < radius * radius then
                self.homing = true
            end
        else
            self.angle16 = Core.turn16(self.angle16,
                Core.aim16(preX, preY, px, py), 0x1000)
            self.speed = 12
            movementSpeed = self.speed
            if stateTimer == 0x103 then
                self.age = 0x28
                self.speed = 0
                self.homing = false
                self.angle16 = randomItemDriftAngle((rt and rt.frame or 0) +
                    trunc(preX + preY))
            end
        end
    elseif special then
        if not self.homing then
            local radius = self.radiusOrScale + 80
            if stateTimer < 0xb5 and distanceSquared < radius * radius and
               (tokenStock(rt) ~= 3 or self.itemType ~= 6) then
                self.homing = true
                self.angle16 = Core.aim16(preX, preY, px, py)
            end
        else
            self.angle16 = Core.turn16(self.angle16,
                Core.aim16(preX, preY, px, py), 0x1000)
            self.speed = 12
            if stateTimer > 0xb4 then
                self.homing = false
                self.speed = 4
            end
        end
        movementSpeed = self.speed
    else
        self.active = false
        self._deleteNextFrame = true
        self.age = self.age + 1
        return
    end

    local mx, my = Core.polar(self.angle16, movementSpeed)
    self.ldX, self.ldY = preX + mx, preY + my
    if special and self.age < 0x4b0 then
        local origin = Core.playfieldOriginX(px)
        local original = self.angle16
        local reflected = -0x8000 - original
        if self.ldX >= origin + 30 then reflected = original end
        if self.ldX > origin + 570 then reflected = -0x8000 - original end
        if self.ldY < 30 or self.ldY > 690 then reflected = -original end
        self.angle16 = Core.angle16(reflected)
        self.ldX = Core.clamp(self.ldX, origin + 30, origin + 570)
        self.ldY = Core.clamp(self.ldY, 30, 690)
    end

    local collectRadius = self.radiusOrScale + 36
    if (special or self.age > 0x20) and stateTimer < 0xb5 and
       distanceSquared < collectRadius * collectRadius then
        collectItem(self)
        self.age = self.age + 1
        Core.syncObject(self, self.ldX, self.ldY)
        return
    end
    local origin = Core.playfieldOriginX(px)
    if self.ldX < origin - 128 or self.ldX > origin + 728 or
       self.ldY < -128 or self.ldY > 848 then
        self.active = false
        self._deleteNextFrame = true
    end
    self.age = self.age + 1
    Core.syncObject(self, self.ldX, self.ldY)
end

function rewardItemClass:render()
    if not self.active and not self._deleteNextFrame then return end
    local itemType = self.itemType
    local image, scale, alpha
    local red, green, blue = 255, 255, 255
    if itemType >= 0 and itemType <= 5 then
        if itemType == 0 or itemType == 3 then scale = 0.75
        elseif itemType == 1 or itemType == 4 then scale = 1.0
        elseif itemType == 2 then scale = 1.5
        else return end
        local rt = self.runtime or runtime()
        local var = lstg.var or {}
        local likeStyle = tonumber((rt and rt.likeStyle) or
            var.like_dreamer_like_style) == 1
        local itemVisibility = tonumber((rt and rt.itemVisibility) or
            var.like_dreamer_item_visibility) == 1
        image = likeStyle and "ld_item_14" or "ld_item_1"
        scale = scale * (1 + 0.2 * sin(self.drawAge * pi / 33))
        alpha = likeStyle and 200 or (itemVisibility and 128 or 160)
    elseif itemType == 6 then
        image, scale, alpha = "ld_item_12", 1, 255
    elseif itemType == 7 then
        image, scale, alpha = "ld_item_13", 1, 255
    elseif itemType == 8 then
        image, scale, alpha = "ld_enemy_s_12", 1, 255
        red, green, blue = 255, 32, 255
    else
        return
    end
    if itemType >= 6 then
        scale = scale * (1 + 0.1 * sin(self.drawAge * pi / 32))
    end
    SetImageState(image, "", Color(alpha, red, green, blue))
    Render(image, self.x, self.y, 0,
        scale * 1, scale * 1)
    SetImageState(image, "", Color(255, 255, 255, 255))
end

function M.spawnItem(itemType, x, y, angle16, speed, radiusOrScale)
    local rt = runtime()
    if rt and (rt.rewardItemCount or 0) >= ITEM_CAP then return nil end
    return New(rewardItemClass, itemType, x, y, angle16, speed, radiusOrScale)
end

function M.cancelProjectile(projectile, sourceType, ordinal, pointX, pointY,
                            sourceFrame)
    if not projectile then return nil end
    if sourceType ~= nil and type(sourceType) ~= "number" then
        local ok, objectType = pcall(function()
            return sourceType.specialType or sourceType.type
        end)
        if ok and objectType ~= nil then sourceType = objectType end
    end
    if sourceType == 0x16 or sourceType == 0x1e then return nil end
    local itemType = (projectile.radius or 0) < 2 and 3 or 4
    local rt = runtime()
    local frame = sourceFrame
    if frame == nil then frame = rt and rt.frame or 0 end
    local angle = randomAngle(frame + (ordinal or 0) + 1)
    return M.spawnItem(itemType,
        pointX or projectile.ldX or projectile.x or 0,
        pointY or projectile.ldY or projectile.y or 0,
        angle, 2, itemType == 4 and 45 or 30)
end

local counterFeedbackClass = Class(object)
M.CounterFeedbackClass = counterFeedbackClass
M.ValueFeedbackClass = counterFeedbackClass

function counterFeedbackClass:init(rt, x, y, angle16, multiplier,
                                   gaugeFactor, displayScale, drawLayer)
    self.ldX, self.ldY = x, y
    self.angle16 = Core.angle16(angle16)
    self.multiplier = max(0, trunc(multiplier or 1))
    self.gaugeFactor = gaugeFactor or 10
    self.displayScale = displayScale or 0.5
    self.lifetime = 50
    self.age, self.drawAge = 0, 0
    self.group = GROUP_GHOST
    self.layer = effectLayer(drawLayer or 0x49)
    self.bound = false
    self.colli = false
    registerEffect(self, rt)
    Core.syncObject(self, x, y)
end

function counterFeedbackClass:del() releaseEffect(self) end
function counterFeedbackClass:kill() releaseEffect(self) end

function counterFeedbackClass:frame()
    local rt = self.runtime
    self.drawAge = self.age
    if self.age == 0 then
        rt.scoreItemBaseValue = (rt.scoreItemBaseValue or SCORE_ITEM_BASE) +
            self.multiplier
        local difficultyScale = max(0.6,
            1 - floor((rt.difficulty or 0) / 2) * 0.1)
        M.addSpecialGauge(rt,
            difficultyScale * self.multiplier * self.gaugeFactor)
        M.flashGauge(rt, 60)
        persistProgress(rt)
    end
    local dx, dy = Core.polar(self.angle16, 1)
    self.ldX, self.ldY = self.ldX + dx, self.ldY + dy
    Core.syncObject(self, self.ldX, self.ldY)
    if self.age == self.lifetime then Del(self); return end
    self.age = self.age + 1
end

function counterFeedbackClass:render()
    local age = self.drawAge
    if age < 0 or age >= self.lifetime then return end
    local scale = age < 5 and sin(age * pi / 10) or 1
    local alpha = 0xc0
    if age >= self.lifetime - 8 then
        alpha = trunc(sin((age - (self.lifetime - 16)) * pi / 16) * 0xc0)
    end
    if alpha <= 0 then return end
    local frameIndex = age < self.multiplier * 2 and
        floor(age / 2) + 1 or self.multiplier
    local image = "ld_item_" .. tostring(frameIndex + 1)
    SetImageState(image, "", Color(alpha, 255, 255, 255))
    Render(image, self.x, self.y, 0,
        scale * self.displayScale * 1,
        scale * self.displayScale * 1)
    SetImageState(image, "", Color(255, 255, 255, 255))
end

local feedbackClass = Class(object)
M.DeathFeedbackClass = feedbackClass

function feedbackClass:init(rt, x, y, multiplier, radius, lifetime)
    self.ldX, self.ldY = x, y
    self.multiplier = max(0, trunc(multiplier or 1))
    self.radius = max(0, trunc(radius or 0))
    self.lifetime = max(0, trunc(lifetime or 0))
    self.age = 0
    self.group = GROUP_GHOST
    self.layer = effectLayer(0)
    self.bound = false
    self.colli = false
    registerEffect(self, rt)
    Core.syncObject(self, x, y)
end

function feedbackClass:del() releaseEffect(self) end
function feedbackClass:kill() releaseEffect(self) end

function feedbackClass:frame()
    local age = self.age
    local rt = self.runtime
    if age % 3 == 1 then
        local frame = rt.frame or 0
        local pointSeed = age * 0x378 + frame
        local distanceSeed = age * 0x22b8 + frame
        local sampleAngle = Core.angle16(randomAngle(pointSeed) - 0x4000)
        local distance = randomInt(distanceSeed, 0, self.radius)
        local ox, oy = Core.polar(sampleAngle, distance)
        local pointX, pointY = self.ldX + ox, self.ldY + oy
        local childAngle = Core.angle16(
            Core.frameRand(distanceSeed) % 12001 - 22384)
        if (rt.projectileEffectCount or 0) < 0x1000 then
            New(counterFeedbackClass, rt, pointX, pointY, childAngle,
                self.multiplier, 30, self.multiplier * 0.1 + 0.5, 0x42)
        end
        play("ld_se_Item2", 0.45)
    end
    if age == self.lifetime then Del(self); return end
    self.age = age + 1
end

local counterRingClass = Class(object)
M.CounterRingClass = counterRingClass

function counterRingClass:init(rt, x, y)
    self.ldX, self.ldY = x, y
    self.age, self.drawAge = 0, 0
    self.group = GROUP_GHOST
    self.layer = effectLayer(0x3d)
    self.bound = false
    self.colli = false
    registerEffect(self, rt)
    Core.syncObject(self, x, y)
end

function counterRingClass:del() releaseEffect(self) end
function counterRingClass:kill() releaseEffect(self) end

function counterRingClass:frame()
    self.drawAge = self.age
    if self.age == 16 then Del(self); return end
    self.age = self.age + 1
end

function counterRingClass:render()
    local age = self.drawAge
    if age < 0 or age >= 16 then return end
    local scale = sin(age * pi / 32) * 0.6
    local alpha = 0xff
    if age >= 8 then
        alpha = alpha - trunc((age - 8) * alpha * 0.125)
    end
    SetImageState("ld_effect_m_5", "", Color(alpha, 255, 255, 255))
    Render("ld_effect_m_5", self.x, self.y, 0,
        scale * 1, scale * 1)
    SetImageState("ld_effect_m_5", "", Color(255, 255, 255, 255))
end

function M.spawnCounterSuccessFeedback(rt, x, y, angle16)
    if not rt then return end
    if (rt.projectileEffectCount or 0) < 0x1000 then
        New(counterFeedbackClass, rt, x, y, angle16)
    end
    if (rt.projectileEffectCount or 0) < 0x1000 then
        New(counterRingClass, rt, x, y)
    end
end

local counterClass = Class(object)
M.CounterClass = counterClass

local function releaseCounter(self)
    if not self._counted then return end
    self._counted = false
    local rt = self.runtime
    if rt then
        rt.postDeathCounterCount = max(0,
            (rt.postDeathCounterCount or 1) - 1)
        if rt.postDeathCountersById then
            rt.postDeathCountersById[self.entityId] = nil
        end
    end
end

function counterClass:init(rt, enemy, lifetime)
    self.runtime = rt
    self.entityId = rt.nextEntityId
    rt.nextEntityId = rt.nextEntityId + 1
    self.spawnType = 0x137
    self.ldX, self.ldY = enemy.ldX, enemy.ldY
    self.radius = max(0, trunc(enemy.radius or 0))
    self.sourceSpeed = lifetime
    self.helperTimer = 0
    self.active = true
    self.targetable = false
    self.group = GROUP_GHOST
    self.layer = LAYER_ENEMY
    self.bound = false
    self.colli = false
    self._counted = true
    rt.postDeathCounterCount = (rt.postDeathCounterCount or 0) + 1
    rt.postDeathCountersById = rt.postDeathCountersById or {}
    rt.postDeathCountersById[self.entityId] = self
    Core.syncObject(self, self.ldX, self.ldY)
end

function counterClass:del() releaseCounter(self) end
function counterClass:kill() releaseCounter(self) end

function counterClass:frame()
    if not self.active then Del(self); return end
    local rt = self.runtime
    if rt.counterMode ~= 1 then
        self.active = false
        Del(self)
        return
    end

    local difficulty = Core.clamp(rt.difficulty or 0, 0, 4)
    local interval = COUNTER_INTERVALS[difficulty + 1]
    local timer = self.helperTimer
    local px, py = playerPosition(rt)
    if runScore() ~= 0 and timer >= 0 and timer % interval == 0 and
       self.ldY < 600 then
        local entityId = self.entityId
        local radialAngle = randomAngle(timer * 666 + entityId)
        local radialLength = randomInt(timer * 6666 + entityId,
            0, self.radius)
        local ox, oy = Core.polar(radialAngle, radialLength)
        local pointX, pointY = self.ldX + ox, self.ldY + oy
        local aimed = Core.aim16(pointX, pointY, px, py)
        local jitter = randomInt(timer * 3333 + entityId, -1000, 1000)
        local heading = Core.angle16(aimed + jitter)
        local threshold = randomInt(timer * 777 + entityId, 180, 480)
        local itemSeed = timer * 7777 + entityId
        local distance = Core.distance(pointX, pointY, px, py)
        if distance <= 480 and distance < threshold then
            M.spawnItem(0, pointX, pointY, randomAngle(itemSeed),
                randomHundredth(itemSeed, 0, 16), 30)
            local feedbackAngle = Core.angle16(
                randomAngle(timer * 77777 + entityId) + heading + 0x4000)
            M.spawnCounterSuccessFeedback(rt, pointX, pointY, feedbackAngle)
        else
            local minimum = COUNTER_MINIMUM_SPEED[difficulty + 1] +
                (rt.stageNumber or rt.stage or 1) * 0.1
            Projectile.spawn(0x0f, 0x16, pointX, pointY, heading, 0,
                randomHundredth(itemSeed, minimum, minimum + 2), 1, 0)
        end
    end

    local lifetime = trunc(self.sourceSpeed)
    if difficulty == 0 then lifetime = trunc(lifetime / 2) end
    if timer == lifetime then
        self.active = false
        Del(self)
        return
    end
    self.helperTimer = timer + 1
end

function M.spawnPostDeathCounter(enemy, lifetime)
    local rt = enemy and enemy.runtime or runtime()
    if not rt or not enemy then return nil end
    if (rt.enemyCount or 0) + (rt.postDeathCounterCount or 0) >= ENTITY_CAP then
        return nil
    end
    return New(counterClass, rt, enemy,
        lifetime or (enemy.radius or 0) * 0.6)
end

local function enemyTypeId(enemyOrType)
    if type(enemyOrType) == "number" then return enemyOrType end
    if enemyOrType == nil then return nil end
    local ok, typeId = pcall(function() return enemyOrType.spawnType end)
    return ok and typeId or nil
end

function M.deathEffectMode(enemyOrType)
    local typeId = enemyTypeId(enemyOrType)
    return deathEffectModes[typeId] or 0
end

function M.defersEnemyDeathEffects(enemyOrType)
    local typeId = enemyTypeId(enemyOrType)
    return deferredDeathEffects[typeId] == true
end

function M.spawnEnemyDeathEffects(enemy, mode, playSound)
    if not enemy or mode == nil or mode < 0 or mode > 2 then return 0 end
    local rt = enemy.runtime or runtime()
    if not rt then return 0 end
    if playSound ~= false then
        play(({"ld_se_EnemyDown1", "ld_se_EnemyDown2", "ld_se_EnemyDown3"})
            [mode + 1], 0.45)
    end

    local radius = max(0, trunc(enemy.radius or 0))
    local frame = rt.frame or 0
    local entityId = enemy.entityId or 0
    local count = randomInt(entityId * 111 + frame,
        floor(radius / 4), floor(radius / 3))
    local baseSeed = entityId * 666 + frame
    for index = 0, count - 1 do
        local burstSeed = baseSeed + index
        local distance = randomInt(burstSeed, 0, radius + 60)
        local burstAngle = randomAngle(burstSeed)
        local ox, oy = Core.polar(burstAngle, distance)
        local burstScale = randomHundredth(burstSeed,
            radius / 200 + 0.4, radius / 200 + 0.7)
        spawnDeathEffect(rt, "burst", "ld_player_fx_m_6",
            enemy.ldX + ox, enemy.ldY + oy, burstAngle, 1, burstScale,
            0x18, 0xff, 0x3e, frame)

        local angleSeed, scaleSeed, speedSeed = frame, baseSeed, frame
        local scaleMinimum, scaleMaximum = 0.7, 1
        local speedMinimum, speedMaximum = 6, 9
        if mode == 0 then
            angleSeed = angleSeed + index * 11
            scaleSeed = scaleSeed + index * 1111
            speedSeed = speedSeed + index * 555
        elseif mode == 1 then
            angleSeed = angleSeed + index * 22
            scaleSeed = scaleSeed + index * 2222
            speedSeed = speedSeed + index * 222
            scaleMinimum, scaleMaximum = 0.9, 1.5
            speedMinimum, speedMaximum = 10, 15
        else
            angleSeed = angleSeed + index * 33
            scaleSeed = scaleSeed + index * 3333
            speedSeed = baseSeed + index * 333
            scaleMinimum, scaleMaximum = 1, 2.2
            speedMinimum, speedMaximum = 16, 26
        end
        spawnDeathEffect(rt, "spark", "ld_player_15",
            enemy.ldX, enemy.ldY, randomAngle(angleSeed),
            randomHundredth(speedSeed, speedMinimum, speedMaximum),
            randomHundredth(scaleSeed, scaleMinimum, scaleMaximum),
            0, 0xc0, 0x3e, frame)
    end

    if mode == 2 then
        spawnDeathEffect(rt, "center", "ld_player_fx_l_1",
            enemy.ldX, enemy.ldY, 0, 0, 0, 0x30, 0xff, 0x5b, frame)
    else
        local p = currentPlayer(rt)
        local gauge = p and p.specialGauge or rt.specialGauge or 0
        if gauge >= 0 then
            spawnDeathEffect(rt, "ring", "ld_player_fx_m_5",
                enemy.ldX, enemy.ldY, 0, 0, radius / 16,
                0x18, 0x60, 0x3d, frame)
        end
    end
    return count
end

function M.spawnStage02DeathExplosionChain(enemy, timer)
    if not enemy then return end
    local rt = enemy.runtime or runtime()
    if not rt then return end
    timer = trunc(timer == nil and (enemy.helperTimer or 0) or timer)
    local radius = max(0, trunc(enemy.radius or 0))
    local frame = rt.frame or 0
    if timer % 3 == 0 then
        local random = Core.frameRand(timer)
        local burstAngle = randomAngle(timer)
        local distance = random % max(1, radius + 51)
        local ox, oy = Core.polar(burstAngle, distance)
        local x, y = enemy.ldX + ox, enemy.ldY + oy
        local scaleBase = radius / 200 + 0.1
        spawnDeathEffect(rt, "burst", "ld_player_fx_m_6", x, y,
            burstAngle, 1,
            randomHundredth(frame, scaleBase, scaleBase + 0.3),
            0x18, 0xff, 0x3e, frame)
        spawnDeathEffect(rt, "spark", "ld_player_15", x, y,
            randomAngle(timer * 0x37),
            randomHundredth(frame * 0x22b, 14, 22),
            randomHundredth(timer * 0x15b3, 0.8, 1.6),
            0, 0xc0, 0x48, frame)
        local stage = rt.stageNumber or rt.stage or 0
        if stage >= 1 and stage <= 4 and rt.gate and runScore() ~= 0 then
            M.spawnItem(3, x, y, randomAngle(frame),
                randomHundredth(frame + 0x22b, 0, 8), 30)
            local feedbackAngle = Core.angle16(
                Core.frameRand(frame) % 0x8001 + 0x8000)
            if (rt.projectileEffectCount or 0) < 0x1000 then
                New(counterFeedbackClass, rt, x, y, feedbackAngle,
                    3, 30, 0.8, 0x42)
            end
        end
    end
    if timer % 6 == 0 then play("ld_se_Blast1", 0.4) end
end

function M.beginDeferredEnemyDeath(enemy)
    if not enemy or enemy._ldDeferredDeath then return false end
    local typeId = enemy.spawnType
    if not M.defersEnemyDeathEffects(typeId) then return false end
    enemy._ldDeferredDeath = true
    enemy.targetable = false
    enemy.protect = true
    enemy.hp = max(1, enemy.hp or 1)
    enemy.state = 2
    enemy.helperTimer = 0
    if typeId == 0x4f then enemy.radius = 240 end
    M.onEnemyDeath(enemy)
    M.spawnStage02DeathExplosionChain(enemy, 0)
    enemy.helperTimer = 1
    return true
end

function M.updateDeferredEnemyDeath(enemy)
    if not enemy or not enemy._ldDeferredDeath then return false end
    local timer = enemy.helperTimer or 0
    M.spawnStage02DeathExplosionChain(enemy, timer)
    local motion = deferredDeathMotion[enemy.spawnType]
    if motion then enemy.ldY = enemy.ldY + timer * motion end
    if timer >= 60 then
        M.spawnEnemyDeathEffects(enemy, 2)
        enemy._ldDeathEffectsSpawned = true
        return true
    end
    enemy.helperTimer = timer + 1
    return false
end

local function enemyFeedbackMultiplier(enemy, feverActive)
    local rt = enemy.runtime or runtime()
    local px, py = playerPosition(rt)
    local proximity = trunc(Core.distance(px, py, enemy.ldX, enemy.ldY)) -
        (enemy.radius or 0)
    local multiplier = 1
    if proximity <= 150 then multiplier = 10
    elseif proximity < 450 then multiplier = max(1, trunc((450 - proximity) / 30)) end
    if feverActive then multiplier = 10 end
    return multiplier, proximity
end

function M.spawnEnemyDeathRewardBurst(enemy, payoutWindow, options)
    if not enemy then return nil end
    options = options or {}
    local rt = enemy.runtime or runtime()
    if not rt then return nil end
    payoutWindow = payoutWindow == nil and (enemy.rewardWindow or 0) or payoutWindow
    local weight = enemy.rewardWeight
    if weight == nil then weight = rewardWeights[enemy.spawnType] or 1 end
    local targetableTimer = enemy.targetableTimer or 0
    local payout = 1
    if payoutWindow - targetableTimer > 0 then
        payout = trunc(((payoutWindow - targetableTimer) / payoutWindow) * weight)
    end
    local p = currentPlayer(rt)
    local feverActive = p and (p.specialGauge or 0) < 0
    if feverActive then payout = payout * 2 end

    local highCount = 0
    if payout > 49 then
        highCount = trunc(payout / 20)
        payout = payout - highCount * 10
    end
    local mediumCount = 0
    if payout > 9 then
        mediumCount = trunc(payout / 10)
        payout = payout - mediumCount * 5
    end
    local lowCount = max(0, payout)
    local frame = rt.frame or 0
    local function emit(itemType, count, angleOffset, speedOffset, radius)
        for index = 0, count - 1 do
            M.spawnItem(itemType, enemy.ldX, enemy.ldY,
                randomAngle(frame + angleOffset + index),
                randomHundredth(frame + speedOffset + index, 0, 16), radius)
        end
    end
    emit(2, highCount, 666, 555, 60)
    emit(1, mediumCount, 444, 333, 45)
    emit(0, lowCount, 222, 111, 30)

    local multiplier, proximity = enemyFeedbackMultiplier(enemy, feverActive)
    local strength = feedbackStrength[enemy.spawnType] or
        max(1, trunc((enemy.radius or 0) / 10))
    if (rt.projectileEffectCount or 0) < 0x1000 then
        New(feedbackClass, rt, enemy.ldX, enemy.ldY, multiplier,
            (enemy.radius or 0) + 60, strength * 3)
    end
    local progressScale = proximity <= 500 and 1 + (500 - proximity) / 200 or 1
    rt.stockProgress = (rt.stockProgress or 0) +
        trunc(((enemy.radius or 0) + 100) * progressScale)
    persistProgress(rt)
    local playerClass = LikeDreamer.PlayerClass
    if feverActive and p and playerClass and p.class == playerClass and
            type(playerClass._spawnSpecial) == "function" then
        playerClass._spawnSpecial(p, 0x1a,
            enemy.ldX, enemy.ldY, 0, 0, 0,
            (enemy.radius or 0) * 1.5 + 60)
    end
    M.spawnPostDeathCounter(enemy, (enemy.radius or 0) * 0.6)
    return { high = highCount, medium = mediumCount, low = lowCount }
end

function M.configureEnemy(enemy)
    local typeId = enemy.spawnType
    enemy.rewardWeight = rewardWeights[typeId]
    if enemy.rewardWeight == nil then enemy.rewardWeight = 1 end
    if typeId == 0x11 and enemy.parentSpawnType == 0x10 then
        enemy.rewardWeight = 0x28
    end
    enemy.rewardWindow = rewardWindows[typeId] or 0
    enemy.rewardEligible = not noGenericReward[typeId]
    enemy.targetableTimer = enemy.targetableTimer or 0
    return enemy
end

function M.onEnemyDeath(enemy)
    if not enemy then return nil end
    local result
    if not enemy._ldRewardSpawned and enemy.rewardEligible ~= false then
        enemy._ldRewardSpawned = true
        result = M.spawnEnemyDeathRewardBurst(enemy, enemy.rewardWindow or 0)
        if enemy.spawnType >= 0x06 and enemy.spawnType <= 0x08 then
            local frame = enemy.runtime and enemy.runtime.frame or 0
            M.spawnItem(6, enemy.ldX, enemy.ldY,
                Core.angle16(Core.frameRand(frame) % 0x4001 + 0x2000), 4, 30)
        end
    end
    if not enemy._ldDeathEffectsSpawned and not enemy._ldDeferredDeath and
       not M.defersEnemyDeathEffects(enemy) then
        enemy._ldDeathEffectsSpawned = true
        M.spawnEnemyDeathEffects(enemy, M.deathEffectMode(enemy))
    end
    return result
end

local RewardRuntimeController = {}
RewardRuntimeController.__index = RewardRuntimeController
M.RuntimeController = RewardRuntimeController

function RewardRuntimeController.new(rt)
    return setmetatable({ runtime = rt }, RewardRuntimeController)
end

local function runtimeController(rt)
    local controller = rt._rewardRuntimeController
    if not controller or controller.runtime ~= rt then
        controller = RewardRuntimeController.new(rt)
        rt._rewardRuntimeController = controller
    end
    return controller
end

function RewardRuntimeController:initialize()
    local rt = self.runtime
    local var = lstg.var or {}
    rt.rewardItemCount = rt.rewardItemCount or 0
    rt.projectileEffectCount = rt.projectileEffectCount or 0
    rt.postDeathCounterCount = rt.postDeathCounterCount or 0
    rt.postDeathCountersById = rt.postDeathCountersById or {}
    rt.hudSpecialGaugeFlashTimer = rt.hudSpecialGaugeFlashTimer or 0
    rt.enemyProjectileSpawnsThisSecond =
        rt.enemyProjectileSpawnsThisSecond or 0
    rt.enemyProjectileSpawnsLastSecond =
        rt.enemyProjectileSpawnsLastSecond or 0
    local sampleFrame = max(0, floor(tonumber(rt.frame) or
        tonumber(rt.rawStartFrame) or 0))
    rt.enemyProjectileSampleSecond = floor(sampleFrame / 60)
    rt.enemyProjectileSampleClock = sampleFrame % 60
    rt.scoreItemBaseValue = tonumber(var.like_dreamer_score_item_base) or
        SCORE_ITEM_BASE
    local savedExtendIndex = tonumber(var.like_dreamer_extend_index)
    if runScore() <= 0 then savedExtendIndex = 0 end
    rt.extendIndex = savedExtendIndex == nil and inferExtendIndex(rt) or
        Core.clamp(floor(savedExtendIndex), 0, 5)
    local progress
    if rt.routeMode == 2 and rt.mentalProgressSteps ~= nil then
        local threshold = stockThreshold(rt)
        local steps = Core.clamp(trunc(rt.mentalProgressSteps), 0, 20)
        progress = threshold * tokenStock(rt) + trunc(threshold / 20) * steps
        if steps == 20 then progress = progress - 1 end
    else
        progress = tonumber(var.like_dreamer_stock_progress)
        if progress == nil then progress = stockThreshold(rt) * tokenStock(rt) end
    end
    rt.stockProgress = progress
    rt.graze = tonumber(var.graze) or 0
    persistProgress(rt)
end

function M.initializeRuntime(rt)
    runtimeController(rt):initialize()
end

local clockClass = Class(object)
M.ClockClass = clockClass

function clockClass:init(rt)
    self.runtime = rt
    self.controller = runtimeController(rt)
    self.group = GROUP_GHOST
    self.layer = LAYER_ENEMY
    self.bound = false
    self.colli = false
end

function RewardRuntimeController:update()
    local rt = self.runtime
    M.processStockProgress(rt, 0)
    M.processScoreExtends(rt)
    local sampleFrame = max(0, floor(tonumber(rt.frame) or
        tonumber(rt.rawStartFrame) or 0))
    local sampleSecond = floor(sampleFrame / 60)
    if sampleSecond ~= rt.enemyProjectileSampleSecond then
        rt.enemyProjectileSampleSecond = sampleSecond
        rt.enemyProjectileSpawnsLastSecond =
            rt.enemyProjectileSpawnsThisSecond or 0
        rt.enemyProjectileSpawnsThisSecond = 0
    end
    rt.enemyProjectileSampleClock = sampleFrame % 60
    local hasSource = (rt.rewardItemCount or 0) > 0
    if not hasSource then
        for _, enemy in pairs(rt.enemiesById or {}) do
            if enemy.active and enemy.targetable then hasSource = true; break end
        end
    end
    if (rt.hudSpecialGaugeFlashTimer or 0) > 0 and hasSource then
        rt.hudSpecialGaugeFlashTimer = rt.hudSpecialGaugeFlashTimer - 1
    end
end

function clockClass:frame()
    self.controller:update()
end

function M.attachRuntime(rt)
    M.initializeRuntime(rt)
    if not rt._rewardClock then rt._rewardClock = New(clockClass, rt) end
    return rt._rewardClock
end

return M
