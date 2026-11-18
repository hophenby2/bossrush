-- 复原状态机到 LuaSTG 原生敌机的字段与资源适配。游戏运行时只执行 Lua 函数。
-- 差异 1：装饰粒子沿用宿主的绘制代理；战斗发弹、运动、判定部件和阶段计时独立按原版执行。
LikeDreamer = LikeDreamer or {}
local Core = assert(LikeDreamer.Core)
local R = {methods = {}}
LikeDreamer.Recovered = R
local bit = require('bit')
local ffi = require('ffi')
ffi.cdef('double hypot(double x, double y); double _hypot(double x, double y);')
local hasHypot, hypot = pcall(function() return ffi.C.hypot end)
if not hasHypot then hypot = ffi.C._hypot end
local floor, ceil = math.floor, math.ceil
R.f32 = Core.float32
function R.trunc(x) return x < 0 and ceil(x) or floor(x) end
function R.u32(x) return x % 4294967296 end
function R.s16(x) return (x + 32768) % 65536 - 32768 end
function R.mul32(a, b)
    local al, bl = a % 65536, b % 65536
    return (al * bl + ((floor(a / 65536) * bl + floor(b / 65536) * al) % 65536) * 65536) % 4294967296
end
function R.clamp(x, lo, hi) return math.max(lo, math.min(hi, x)) end
function R.lround(x) return x < 0 and ceil(x - 0.5) or floor(x + 0.5) end
function R.hypot(x, y) return tonumber(hypot(x, y)) end
function R.ref(get, set) return {get = get, set = set} end
function R.get(ref) return ref.get() end
function R.set(ref, value) ref.set(value); return value end
function R.count_if(array, _, predicate)
    local count = 0
    for _, value in ipairs(array) do if predicate(value) then count = count + 1 end end
    return count
end
function R.any_of(array, last, predicate) return R.count_if(array, last, predicate) > 0 end
function R.install(methods) for name, fn in pairs(methods) do R.methods[name] = fn end end
local function copy(value)
    if type(value) ~= 'table' then return value end
    local result = {}
    for key, item in pairs(value) do result[key] = copy(item) end
    return result
end
function R.newEnemy() return copy(assert(R.enemyDefaults)) end
function R.clear(array) for i = #array, 1, -1 do array[i] = nil end end
function R.push(array, value)
    array[#array + 1] = value
    if array._push then return array._push(value) end
end

local aliases = {
    x = 'ldX', y = 'ldY', helperState = 'state', maxHp = 'maxhp',
    sourceAngle16 = 'angle16', drawHp = '_ldExactDrawHp',
    drawHelperState = '_ldDrawState', drawHelperTimer = '_ldDrawTimer',
    drawBodyThisFrame = '_ldDrawBody', drawMarkerThisFrame = '_ldDrawMarker',
}
local direct = {
    spawnType = true, age = true, hp = true, radius = true, visualFrame = true,
    helperTimer = true, targetableTimer = true, targetable = true, entityId = true,
    parentEntityId = true, parentSpawnType = true, secondaryAngle16 = true,
    targetAngle16 = true, liveChildCount = true, speed = true, rewardWeight = true,
    updateCase = true, activationDelay = true, sourceHitPoints = true, sourceNote = true,
    sourceDispatchKind = true, sourceDispatchField = true,
}
local function native(enemy) return rawget(enemy, '_native') or enemy end
local function view(ctx, object)
    if not object then return nil end
    if rawget(object, '_native') then return object end
    if object._ldExactView then return object._ldExactView end
    local data = object._ldExactData or {}
    object._ldExactData = data
    local proxy = {_native = object, _data = data}
    setmetatable(proxy, {
        __index = function(_, key)
            if key == 'hp' and object._ldExactHpSentinel and object.hp == 1 then return data.hp end
            local field = aliases[key] or (direct[key] and key)
            if field then
                local value = object[field]
                if value ~= nil then return value end
            end
            if data[key] ~= nil then return data[key] end
            if key == 'active' then return object.active ~= false and not object.removeRequested end
            if key == 'originX' and object.spawnType == 0x41 then return object._beVerticalRadius or 100 end
            if key == 'originY' and object.spawnType == 0x41 then return object._beHorizontalRadius or 200 end
            if key == 'originX' and (object.spawnType == 0x23 or object.spawnType == 0x24 or object.spawnType == 0x42 or object.spawnType == 0x43) then return object._beOrbitRadius or 120 end
            if key == 'originX' then return object._blOffsetX or object._bmOffsetX or object._beOffsetX or object.originX or 0 end
            if key == 'originY' then return object._blOffsetY or object._bmOffsetY or object._beOffsetY or object.originY or 0 end
            if key == 'childIndex' then return object._blIndex or object._bmIndex or object._beIndex or 0 end
            if key == 'sourceSpeed' then return object._bmSourceSpeed or object.speed or 0 end
            if key == 'sourceHitPoints' then return object.maxhp or object.hp end
            return R.enemyDefaults[key]
        end,
        __newindex = function(_, key, value)
            if key == 'hp' then object._ldExactHpSentinel = false end
            local field = aliases[key] or (direct[key] and key)
            if field then object[field] = value else data[key] = value end
            if key == 'targetable' then object.protect = not value end
            if key == 'active' and value == false then object.removeRequested = true end
        end,
    })
    object._ldExactView = proxy
    return proxy
end
R.view = view
local methods = {}
function methods:findEnemyById(id)
    if id == 0 then return nil end
    return view(self, self.rt.enemiesById and self.rt.enemiesById[id])
end
function methods:spawnProjectileNode(...) return LikeDreamer.Projectile.spawn(...) end
function methods:spawnProjectileSpread(...) return LikeDreamer.Projectile.spread(...) end
function methods:playPlayerSound(handle, volume)
    if type(handle) == 'string' and PlaySound and lstg.CheckRes(5, handle) then PlaySound(handle, (volume or 12) / 25.5, 0) end
end
function methods:audio(operation, handle, extra)
    if operation == 'ChangeVolumeSoundMem' then return end
    if type(handle) ~= 'string' or not handle:match('^ld_bgm_') or not lstg.CheckRes(4, handle) then return end
    if operation == 'StopSoundMem' and StopMusic then StopMusic(handle)
    elseif operation == 'PlaySoundMem' and PlayMusic and lstg.CheckRes(4, handle) then PlayMusic(handle, 1, 0) end
end
function methods:updateBossCountdownAudio(hp, countdown)
    if hp < 8001 and self.frame_ % 16 == 0 then self:playPlayerSound(self.bossWeakenSoundHandle_, 16) end
    if countdown > 0 and countdown <= 600 and countdown % 60 == 0 then
        self:playPlayerSound(self.timerSoundHandle_, countdown <= 300 and 25 or 16)
    end
end
function methods:flushEnemyProjectilesToEffects()
    if LikeDreamer.Projectile.clear then LikeDreamer.Projectile.clear() end
end
function methods:spawnEnemyDeathEffects(enemy, mode)
    local reward = LikeDreamer.Reward
    if reward and reward.spawnEnemyDeathEffects then reward.spawnEnemyDeathEffects(native(enemy), mode, false) end
end
function methods:spawnEnemyDeathRewardBurst(enemy, window, silent)
    local reward = LikeDreamer.Reward
    if reward and reward.spawnEnemyDeathRewardBurst then reward.spawnEnemyDeathRewardBurst(native(enemy), window, {silent = silent}) end
end
function methods:spawnPostDeathCounterEntity(enemy, lifetime)
    local reward = LikeDreamer.Reward
    if reward and reward.spawnPostDeathCounter then reward.spawnPostDeathCounter(native(enemy), lifetime) end
end
function methods:spawnStage02DeathExplosionChain(enemy)
    local reward = LikeDreamer.Reward
    if reward and reward.spawnStage02DeathExplosionChain then reward.spawnStage02DeathExplosionChain(native(enemy), enemy.helperTimer) end
end
function methods:spawnPlayerSideObject(kind, x, y, speed, angle, damage, radius)
    local cls = LikeDreamer.PlayerClass
    if cls and cls._spawnSpecial and player and player.class == cls then
        cls._spawnSpecial(player, kind, x, y, speed, angle, damage, radius)
    end
end
function methods:spawnBossPhaseBreakFeedback(enemy)
    local presentation = LikeDreamer.Presentation
    if presentation and presentation.phaseBreak then presentation.phaseBreak(native(enemy)) end
end
function methods:spawnStageEffect(kind, image, extent, layer, x, y, angle, speed,
                                  sx, sy, lifetime, red, green, blue, alpha, owner)
    if self.isolated then return end
    local boss = LikeDreamer.BossLate
    if boss and boss.spawnRecoveredEffect then
        return boss.spawnRecoveredEffect(self.rt, kind, image, layer, x, y, angle,
            speed, sx, sy, lifetime, red, green, blue, alpha, owner)
    end
end
function methods:spawnStage03DeathNode(owner, amount, id)
    return self:spawnDelayedOwnerDamageNode(amount, id, owner.parentSpawnType, '原版附肢伤害转移')
end
methods.spawnStage04DeathNode = methods.spawnStage03DeathNode
function methods:isStage06MidbossNodeType() return false end
function methods:isStage09MidbossType() return false end
function methods:isStage09MidbossNodeType() return false end
function methods:isStage07MidbossType() return false end
function methods:isStage07MidbossNodeType() return false end
function methods:spawnEnemy(event)
    if self.isolated then return end
    return self.rt:spawn(event.spawnType or event[2], event.hitPoints or event[3], event.x or event[4], event.y or event[5], event.sourceNote or event[6])
end
local function create(ctx, spec)
    if ctx.isolated then return end
    local parent = ctx.rt.enemiesById and ctx.rt.enemiesById[spec.parentEntityId]
    -- 由原版构造函数分配的编号直接交给原生构造，避免双重递增。
    ctx.rt.nextEntityId = spec.entityId
    local object
    if parent then object = ctx.rt:spawnChild(parent, spec.spawnType, spec.hp, spec.x, spec.y, spec.sourceNote)
    else object = ctx.rt:spawn(spec.spawnType, spec.hp, spec.x, spec.y, spec.sourceNote) end
    if not object then return end
    local proxy = view(ctx, object)
    for key, value in pairs(spec) do proxy[key] = value end
    object._blOffsetX, object._blOffsetY, object._blIndex = spec.originX, spec.originY, spec.childIndex
    object._bmOffsetX, object._bmOffsetY, object._bmIndex = spec.originX, spec.originY, spec.childIndex
    object._beOffsetX, object._beOffsetY, object._beIndex = spec.originX, spec.originY, spec.childIndex
    object._blOwnerPhase = parent and parent._blPhase
    object.protect = not spec.targetable
    ctx.state.nextEntityId_ = ctx.rt.nextEntityId
end
local rootTypes = {[0x13c] = 6, [0x13d] = 5, [0x13e] = 5, [0x13f] = 6, [0x140] = 4, [0x141] = 16}
local worldMeta = {
    __index = function(ctx, key)
        if key == 'lateStageBossCountdown_' and ctx.state.rootObject then
            return ctx.state.rootObject.countdown or ctx.state[key]
        end
        if methods[key] then return methods[key] end
        local method = R.methods[key]
        if method then
            if ctx.isolated and key:match('^spawnStage%d%d') then return function() return true end end
            return method
        end
        return ctx.state[key]
    end,
    __newindex = function(ctx, key, value)
        ctx.state[key] = value
        if key == 'lateStageBossCountdown_' and ctx.state.rootObject then ctx.state.rootObject.countdown = value end
    end,
}
function R.context(rt, object)
    local ctx = rt._ldExactWorld
    if not ctx then
        ctx = setmetatable({rt = rt, state = copy(R.worldDefaults), isolated = rt._ldAuditIsolated == true}, worldMeta)
        rawset(ctx, 'config_', {})
        rawset(ctx, 'player_', {})
        rawset(ctx, 'enemies_', {})
        rawset(ctx, 'pendingEnemies_', {_push = function(spec) create(ctx, spec) end})
        rt._ldExactWorld = ctx
        if not ctx.isolated then
            local atlases = {
                playerFrames_ = {'ld_player_', 120}, enemySmallFrames_ = {'ld_enemy_s_', 170},
                enemyMediumFrames_ = {'ld_enemy_m_', 140}, enemyLargeFrames_ = {'ld_enemy_l_', 100},
                enemyExtraLargeFrames_ = {'ld_enemy_xl_', 100}, effectSmallFrames_ = {'ld_effect_s_', 20},
                effectMediumFrames_ = {'ld_player_fx_m_', 30}, effectLargeFrames_ = {'ld_player_fx_l_', 30},
            }
            for key, spec in pairs(atlases) do
                local frames = {}
                for i = 1, spec[2] do frames[i] = spec[1] .. i end
                ctx.state[key] = frames
            end
            ctx.state.stageBgmHandles_, ctx.state.bossBgmHandles_ = {}, {}
            for i = 1, 10 do ctx.state.stageBgmHandles_[i] = 'ld_bgm_Stage' .. i end
            for i = 1, 5 do ctx.state.bossBgmHandles_[i] = 'ld_bgm_Boss' .. i end
            for field, name in pairs({blast2SoundHandle_ = 'Blast2', enemyDown1SoundHandle_ = 'EnemyDown1',
                enemyDown3SoundHandle_ = 'EnemyDown3', bullet1SoundHandle_ = 'Shot1', bullet2SoundHandle_ = 'Shot1',
                bossSe4SoundHandle_ = 'BossSE4', bossWeakenSoundHandle_ = 'Shothit', timerSoundHandle_ = 'Alert'}) do
                ctx.state[field] = 'ld_se_' .. name
            end
        end
    end
    local stage = rt.stage or 1
    ctx.frame_, ctx.selectedStage_ = rt.frame or 0, stage
    ctx.config_.stage, ctx.config_.difficulty = stage, rt.difficulty or 0
    ctx.config_.specialMode, ctx.config_.specialStageFlag = rt.specialMode or 0, rt.specialStageFlag or 0
    ctx.config_.rawStartFrame, ctx.config_.bgmVolume = rt.rawStartFrame or 0, 10
    local p = rawget(_G, 'player') or {}
    ctx.player_.x, ctx.player_.y = R.f32(p.ldX or 360), R.f32(p.ldY or 600)
    ctx.player_.invulnerableFrames = tonumber(p.invulnerableFrames) or tonumber(p.protect) or 0
    ctx.player_.playerStateTimer = p.playerStateTimer or 0
    ctx.player_.bombLock, ctx.player_.specialGauge = p.bombLock or 0, p.specialGauge or 0
    R.clear(ctx.enemies_)
    R.clear(ctx.pendingEnemies_)
    for _, e in pairs(rt.enemiesById or {}) do ctx.enemies_[#ctx.enemies_ + 1] = view(ctx, e) end
    table.sort(ctx.enemies_, function(a, b) return a.entityId < b.entityId end)
    ctx.state.nextEntityId_ = rt.nextEntityId or 3
    local parent = object and object.parent
    if parent and parent.spawnType >= 0x139 and parent.spawnType <= 0x13b then
        local prefix = ('stage%02dBoss'):format(parent.spawnType - 0x137)
        ctx[prefix .. 'Countdown_'] = parent.countdown or 9999
        ctx[prefix .. 'PhaseMode_'] = parent._bePhaseMode or 1
    end
    if object and rootTypes[object.spawnType] and ctx.state.rootEntityId ~= object.entityId then
        ctx.state.rootEntityId = object.entityId
        ctx.state.rootObject = object
        ctx.lateStageBossBreaksRemaining_ = rootTypes[object.spawnType]
        ctx.lateStageBossPhaseMode_ = ctx.isolated and 1 or 0
        ctx.lateStageBossCountdown_ = object.countdown or 5000
        ctx.lateStageBossPhaseIndex_ = math.max(0, (object._blPhase or 1) - 1)
        ctx.lateStageBossMaxHp_ = object.maxhp or 100000
    elseif ctx.isolated and not ctx.state.auditInitialized then
        ctx.lateStageBossPhaseMode_, ctx.lateStageBossCountdown_ = 1, 5000
    end
    if ctx.isolated then ctx.state.auditInitialized = true end
    return ctx
end
function R.call(name, object, rt)
    local ctx = R.context(rt, object)
    local proxy = view(ctx, object)
    if name == 'updateStage03Type34' then
        local parent = object.parent
        if not parent or parent.active == false or parent._bePhaseMode ~= 1 then
            object.removeRequested, object.targetable = true, false
            return true
        end
        R.methods[name](ctx, proxy, view(ctx, parent))
    else
        assert(R.methods[name], name)(ctx, proxy)
    end
    if rootTypes[object.spawnType] then
        object._bmInit, object._blInit = true, true
        object._bmCombat = ctx.lateStageBossPhaseMode_ == 1
        object._bmBreaks = ctx.lateStageBossBreaksRemaining_
        object.phaseIndex = ctx.lateStageBossPhaseIndex_
        object._blPhase = ctx.lateStageBossPhaseIndex_ + 1
        if object._bmCombat then object.portPhase = object._blPhase end
        object.countdown, object._phaseMaxHp = ctx.lateStageBossCountdown_, ctx.lateStageBossMaxHp_
        rt.boss, rt.bossState, rt.bossTimer = object, object.state, object.helperTimer
        if rt.stage == 8 then rt.stage08BossState, rt.stage08BossTimer = object.state, object.helperTimer end
        if rt.stage == 9 then rt.stage09BossState, rt.stage09BossTimer = object.state, object.helperTimer end
        if not proxy.active then rt.boss, rt.gate, rt.complete = nil, false, true end
    end
    object.protect = not object.targetable
    object.seen = false
    if object.removeRequested and object.hp <= 0 then object.hp = 1 end
    if not rootTypes[object.spawnType] and object.hp <= 0 and proxy.active then
        -- 原版的脚本死亡阶段会暂存零 HP；宿主需要正数哨兵才能继续执行这些帧。
        object._ldExactData.hp = object.hp
        object.hp, object._ldExactHpSentinel = 1, true
    end
    local p = rawget(_G, 'player')
    if p then
        p.invulnerableFrames = math.max(p.invulnerableFrames or 0, ctx.player_.invulnerableFrames)
    end
    return true
end
function R.handles(kind)
    return rootTypes[kind] ~= nil or (kind >= 0x22 and kind <= 0x24) or kind == 0x34 or
        (kind >= 0x40 and kind <= 0x43) or (kind >= 0x54 and kind <= 0x56) or
        (kind >= 0x64 and kind <= 0x6f) or (kind >= 0x80 and kind <= 0x94) or
        (kind >= 0xa7 and kind <= 0xc3) or (kind >= 0xcd and kind <= 0xdd) or
        (kind >= 0x105 and kind <= 0x136) or (kind >= 0x151 and kind <= 0x153)
end
function R.seekPracticePhase(object, phase)
    -- 过场会先装入下一段的时限，再延迟开放战斗；此时写零会把目标段也跳掉。
    if object.portPhase and object.portPhase < phase and object._bmCombat then
        object.countdown = 0
    end
end
function R.update(object, rt)
    local kind, method = object.spawnType
    if not R.handles(kind) then return false end
    if kind >= 0x22 and kind <= 0x24 then method = 'updateStage02BossChild'
    elseif kind == 0x34 then method = 'updateStage03Type34'
    elseif kind >= 0x40 and kind <= 0x43 then method = 'updateStage04BossChild'
    elseif kind == 0x136 then method = 'updateStage10GuardNode'
    elseif kind == 0x151 or kind == 0x152 then method = 'updateSharedHitboxProxy'
    elseif kind == 0x153 then method = 'updateStage03DeathNode'
    elseif kind == 0x13c then method = 'updateStage05Boss'
    elseif kind == 0x13d then method = 'updateStage06Boss'
    elseif kind == 0x13e then method = 'updateStage07Boss'
    elseif kind == 0x13f then method = 'updateStage08Boss'
    elseif kind == 0x140 then method = 'updateStage09Boss'
    elseif kind == 0x141 then method = 'updateLateStageBoss'
    elseif kind <= 0x56 then method = 'updateStage05BossChild'
    elseif kind <= 0x6f then method = 'updateStage06BossNode'
    elseif kind <= 0x94 then method = 'updateStage07BossNode'
    elseif kind == 0xc3 and object.parentSpawnType == 0x140 then method = 'updateStage09BossNode'
    elseif kind <= 0xc3 then method = 'updateStage08BossNode'
    elseif kind <= 0xdd then method = 'updateStage09BossNode'
    else method = 'updateStage10FinalBossNode' end
    return R.call(method, object, rt)
end
return R
