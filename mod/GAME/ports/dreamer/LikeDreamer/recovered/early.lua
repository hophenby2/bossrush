-- 由 tools/generate_likedreamer_native_bosses.py 从本地复原源码生成。

-- 生成物是普通 Lua 状态机；修改源逻辑或生成规则后重新生成并核对轨迹。

local cpp = assert(LikeDreamer.Recovered)

local f32, trunc, u32, s16 = cpp.f32, cpp.trunc, cpp.u32, cpp.s16

local bit = require("bit")

local M = {}

local kPi = 3.14159265358979

local kTau = (kPi * 2)

local kFixedAngleFullCircle = 65536

local kStageEntityCap = 512

local fixedAngleToRadiansDouble

local normalizeAngle16

local distanceSquared

local approachAngle16

local radiansToFixedAngleTrunc

local stageScriptRandFromFrame

local scriptRandomAngle

local projectileHorizontalOrigin

local stageRandomIntInclusive

fixedAngleToRadiansDouble = function(angle)
    angle = (angle % 65536);
    local kPiDouble = 3.14159265358979;
    do return ((angle * kPiDouble) / 32768) end
end

normalizeAngle16 = function(angle)
    do return (bit.band(angle, 65535) % 65536) end
end

distanceSquared = function(ax, ay, bx, by)
    ax = f32(ax);
    ay = f32(ay);
    bx = f32(bx);
    by = f32(by);
    local dx = f32((ax - bx));
    local dy = f32((ay - by));
    do return f32((f32((dx * dx)) + f32((dy * dy)))) end
end

approachAngle16 = function(current, target, maxStep)
    current = (current % 65536);
    target = (target % 65536);
    local delta = (target - current);
    if (delta > 32768) then
        delta = (delta - 65536)
    end;
    if (delta < (-32768)) then
        delta = (delta + 65536)
    end;
    delta = math.max((-maxStep), math.min(maxStep, delta));
    do return normalizeAngle16((current + delta)) end
end

radiansToFixedAngleTrunc = function(radians)
    local kFixedAnglePerRadian = 10430.378350470464;
    do return normalizeAngle16(trunc((radians * kFixedAnglePerRadian))) end
end

stageScriptRandFromFrame = function(frame)
    local seed = u32(frame);
    local u = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(seed, 30)), seed)), 1812433253) + 1));
    local a = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(u, 30)), u)), 1812433253) + 2));
    local b = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(a, 30)), a)), 1812433253) + 3));
    local c = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(b, 30)), b)), 1812433253) + 4));
    local mixed = u32(bit.bxor(cpp.mul32(u, 2048), u));
    do return u32(bit.bxor(u32(bit.bxor(u32(bit.rshift(u32(bit.bxor(u32(bit.rshift(c, 11)), mixed)), 8)), c)), mixed)) end
end

scriptRandomAngle = function(seed)
    seed = u32(seed);
    local random = stageScriptRandFromFrame(seed);
    do return (u32((random - trunc(random / 65537))) % 65536) end
end

projectileHorizontalOrigin = function(playerX)
    playerX = f32(playerX);
    do return f32((playerX / f32(6))) end
end

stageRandomIntInclusive = function(seed, minimum, maximum)
    seed = u32(seed);
    if (minimum == maximum) then
        do
            do return minimum end
        end
    end;
    do return (minimum + math.fmod(stageScriptRandFromFrame(seed), u32(((maximum - minimum) + 1)))) end
end

M.updateStage02BossChild = function(ctx, enemy)
    (enemy).vx = f32(f32(0));
    (enemy).vy = f32(f32(0));
    (enemy).targetable = false;
    (enemy).drawBodyThisFrame = true;
    (enemy).drawHelperState = (enemy).helperState;
    (enemy).drawHelperTimer = (enemy).helperTimer;
    local parent = ctx:findEnemyById((enemy).parentEntityId);
    if ((parent == nil) or ((parent).spawnType ~= 313)) then
        do
            ctx:spawnEnemyDeathEffects(enemy, 1, true);
            (enemy).active = false;
            do return end
        end
    end;
    if (not (parent).active) then
        do
            (enemy).active = false;
            do return end
        end
    end;
    local timer = (enemy).helperTimer;
    if ((enemy).spawnType == 34) then
        do
            (enemy).x = f32(f32(((parent).x + (enemy).originX)));
            (enemy).y = f32(f32(((parent).y + (enemy).originY)));
            local attachedToSecondPhase = (((parent).helperState == 2) or ((parent).helperState == 3));
            local livePhaseEnded = (((parent).helperState == 3) and ((((parent).hp < 1) or ((ctx).stage02BossCountdown_ < 1)) or ((ctx).stage02BossPhaseMode_ ~= 1)));
            if ((not attachedToSecondPhase) or livePhaseEnded) then
                do
                    if ((((parent).helperState > 3) or ((parent).hp < 1)) or ((ctx).stage02BossCountdown_ < 1)) then
                        do
                            ctx:spawnEnemyDeathEffects(enemy, 1, true)
                        end
                    end;
                    (enemy).active = false;
                    do return end
                end
            end;
            if (((enemy).helperState == 0) and (timer == 50)) then
                do
                    (enemy).helperState = 1;
                    (enemy).helperTimer = 0
                end
            end;
            if ((enemy).helperState == 1) then
                do
                    ctx:emitStage02BossChildProjectiles(enemy, parent)
                end
            end;
            do return end
        end
    end;
    local expectedParentState = (function() if ((enemy).spawnType == 35) then return 5 else return 7 end end)();
    if (((((parent).helperState ~= expectedParentState) or ((parent).hp < 1)) or ((ctx).stage02BossCountdown_ < 1)) or ((ctx).stage02BossPhaseMode_ ~= 1)) then
        do
            if (((parent).hp < 1) or ((ctx).stage02BossCountdown_ < 1)) then
                do
                    ctx:spawnEnemyDeathEffects(enemy, 1, true)
                end
            end;
            (enemy).active = false;
            do return end
        end
    end;
    local orbitRadius = (enemy).originX;
    if ((enemy).helperState == 0) then
        do
            local entry = math.sin(((timer * kPi) / 100));
            local entryTurn = (trunc((entry * 3000)) - 3000);
            (enemy).secondaryAngle16 = (normalizeAngle16(((enemy).secondaryAngle16 + entryTurn)) % 65536);
            local radians = fixedAngleToRadiansDouble((enemy).secondaryAngle16);
            (enemy).x = f32(f32(((parent).x + f32(((math.cos(radians) * orbitRadius) * entry)))));
            (enemy).y = f32(f32(((parent).y + f32(((math.sin(radians) * orbitRadius) * entry)))));
            (enemy).sourceAngle16 = (normalizeAngle16(((enemy).secondaryAngle16 + ((parent).helperTimer * 333))) % 65536);
            local trailHandle = (function() if ((#(ctx).enemySmallFrames_) > 23) then return ((ctx).enemySmallFrames_)[23 + 1] else return (-1) end end)();
            local trailScale = (1 + (0.10000000000000001 * math.sin((((parent).helperTimer * kTau) / 44))));
            ctx:spawnStageEffect(56, trailHandle, 100, 28, (enemy).x, (enemy).y, (enemy).sourceAngle16, 0, trailScale, trailScale, 16, 255, 255, 255, 96, 0);
            if (timer == 50) then
                do
                    (enemy).helperState = 1;
                    (enemy).helperTimer = 0
                end
            end
        end
    end;
    if ((enemy).helperState == 1) then
        do
            local orbitDelta = (function() if ((enemy).spawnType == 35) then return trunc((math.sin((((enemy).helperTimer * kTau) / 480)) * 777)) else return trunc((math.sin((((enemy).helperTimer * kTau) / 240)) * 400)) end end)();
            (enemy).secondaryAngle16 = (normalizeAngle16(((enemy).secondaryAngle16 + orbitDelta)) % 65536);
            local radians = fixedAngleToRadiansDouble((enemy).secondaryAngle16);
            (enemy).x = f32(f32(((parent).x + f32((math.cos(radians) * orbitRadius)))));
            (enemy).y = f32(f32(((parent).y + f32((math.sin(radians) * orbitRadius)))));
            (enemy).sourceAngle16 = (normalizeAngle16(((enemy).secondaryAngle16 + ((parent).helperTimer * 333))) % 65536);
            ctx:emitStage02BossChildProjectiles(enemy, parent)
        end
    end
end

M.emitStage02BossChildProjectiles = function(ctx, enemy, parent)
    local difficulty = cpp.clamp(((ctx).config_).difficulty, 0, 4);
    local timer = (enemy).helperTimer;
    local aimFrom = function(x, y)
        x = f32(x);
        y = f32(y);
        do return radiansToFixedAngleTrunc(math.atan2(f32((((ctx).player_).y - y)), f32((((ctx).player_).x - x)))) end
    end;
    if ((enemy).spawnType == 34) then
        do
            if (timer < 20) then
                do
                    do return end
                end
            end;
            local kSpinPeriod = {24, 20, 18, 20, 20};
            local kSpinWidth = {6, 8, 10, 12, 12};
            local kCount = {2, 4, 5, 6, 7};
            local kSpinSpeed = {3.5, 4.5, 5.5, 6, 7.5};
            local kAimCadence = {120, 80, 60, 48, 48};
            local kAimSpeed = {5, 6.5999999999999996, 8, 9, 11};
            local kRingPeriod = {90, 60, 40, 40, 36};
            local kRingCount = {15, 23, 27, 25, 27};
            local kAngleStep = {150, 180, 200, 200, 200};
            local q = math.fmod((timer - 20), 1200);
            local index = bit.band((enemy).childIndex, 3);
            if (q == 0) then
                do
                    (enemy).secondaryAngle16 = (normalizeAngle16((trunc(kFixedAngleFullCircle / ((kCount)[difficulty + 1] * 4)) * index)) % 65536)
                end
            end;
            local direction = (function() if ((index == 0) or (index == 3)) then return 1 else return (-1) end end)();
            (enemy).secondaryAngle16 = (normalizeAngle16(((enemy).secondaryAngle16 + (direction * (kAngleStep)[difficulty + 1]))) % 65536);
            local sourceY = f32(((enemy).y - f32(60)));
            local emitAimedBurst = function(start)
                if ((q < start) or (q >= (start + 240))) then
                    do
                        do return end
                    end
                end;
                local phase = math.fmod((q - start), (kAimCadence)[difficulty + 1]);
                if (phase == 0) then
                    do
                        (enemy).targetAngle16 = ((aimFrom)((enemy).x, sourceY) % 65536)
                    end
                end;
                if ((phase < 24) and (math.fmod(phase, 3) == 0)) then
                    do
                        local visual = (function() if (index < 2) then return 12 else return 13 end end)();
                        local speed = (kAimSpeed)[difficulty + 1];
                        ctx:spawnProjectileNode(visual, 0, (enemy).x, sourceY, (enemy).targetAngle16, f32(10), speed, 1, 0);
                        if (difficulty >= 3) then
                            do
                                ctx:spawnProjectileNode(visual, 0, (enemy).x, sourceY, normalizeAngle16(((enemy).targetAngle16 - 800)), f32(10), speed, 1, 0);
                                ctx:spawnProjectileNode(visual, 0, (enemy).x, sourceY, normalizeAngle16(((enemy).targetAngle16 + 800)), f32(10), speed, 1, 0)
                            end
                        end
                    end
                end
            end;
            local emitSpin = function(visual, phase, period, width)
                if ((((period <= 0) or (width <= 0)) or (math.fmod(phase, period) >= width)) or (math.fmod(math.fmod(phase, period), 2) ~= 0)) then
                    do
                        do return end
                    end
                end;
                local count = (kCount)[difficulty + 1];
                local speed = (kSpinSpeed)[difficulty + 1];
                ctx:spawnProjectileSpread(visual, 0, (enemy).x, sourceY, (enemy).secondaryAngle16, f32(0), speed, 1, count, kFixedAngleFullCircle, 0);
                if (difficulty == 4) then
                    do
                        ctx:spawnProjectileSpread(visual, 0, (enemy).x, sourceY, (enemy).secondaryAngle16, f32(0), (speed + 0.80000000000000004), 1, count, kFixedAngleFullCircle, 0)
                    end
                end
            end;
            if (index < 2) then
                do
                    (emitAimedBurst)(60);
                    if ((q >= 330) and (q < 630)) then
                        do
                            (emitSpin)(12, (q - 330), ((kSpinPeriod)[difficulty + 1] - 2), ((kSpinWidth)[difficulty + 1] - 2))
                        end
                    end
                end
            else
                do
                    if (q < 300) then
                        do
                            (emitSpin)(13, q, (kSpinPeriod)[difficulty + 1], (kSpinWidth)[difficulty + 1])
                        end
                    end;
                    (emitAimedBurst)(390)
                end
            end;
            local ringPeriod = (kRingPeriod)[difficulty + 1];
            local ringStart = (650 + (ringPeriod * index));
            if (((q >= ringStart) and (q <= 1149)) and (math.fmod((q - ringStart), (ringPeriod * 4)) == 0)) then
                do
                    local count = (kRingCount)[difficulty + 1];
                    local aim = (aimFrom)((enemy).x, sourceY);
                    local movement = (function() if (bit.band(index, 1) == 0) then return 24 else return 25 end end)();
                    ctx:spawnProjectileSpread(3, movement, (enemy).x, sourceY, aim, f32(10), 7, 1, count, kFixedAngleFullCircle, 0);
                    if (difficulty >= 3) then
                        do
                            ctx:spawnProjectileSpread(3, movement, (enemy).x, sourceY, aim, f32(10), 8.1999999999999993, 1, count, kFixedAngleFullCircle, 0)
                        end
                    end
                end
            end;
            do return end
        end
    end;
    if ((enemy).spawnType == 35) then
        do
            local kPeriod = {9, 5, 5, 5, 4};
            local kSpeed = {4, 5, 6, 6.5, 7.5};
            local period = (kPeriod)[difficulty + 1];
            if (((math.fmod(timer, 480) < 420) and (math.fmod(timer, period) == 0)) and (distanceSquared((enemy).x, (enemy).y, ((ctx).player_).x, ((ctx).player_).y) >= f32((f32(80) * f32(80))))) then
                do
                    local angle = normalizeAngle16(((enemy).secondaryAngle16 - ((parent).helperTimer * 180)));
                    local speed = (kSpeed)[difficulty + 1];
                    ctx:spawnProjectileNode(1, 0, (enemy).x, (enemy).y, angle, f32(10), speed, 1, 0);
                    if (difficulty >= 3) then
                        do
                            ctx:spawnProjectileNode(1, 0, (enemy).x, (enemy).y, angle, f32(10), (speed + 0.59999999999999998), 1, 0)
                        end
                    end
                end
            end;
            do return end
        end
    end;
    if (((enemy).spawnType == 36) and (timer >= 30)) then
        do
            local kPeriod = {240, 210, 180, 180, 160};
            local kWidth = {16, 25, 32, 32, 32};
            local kBaseSpeed = {4, 5, 6, 6, 7.7000000000000001};
            local v_local = math.fmod((timer - 30), (kPeriod)[difficulty + 1]);
            local liveAim = (aimFrom)((enemy).x, (enemy).y);
            if (v_local == 0) then
                do
                    (enemy).targetAngle16 = (liveAim % 65536)
                end
            end;
            if ((v_local < (kWidth)[difficulty + 1]) and (math.fmod(v_local, 3) == 0)) then
                do
                    ctx:spawnProjectileNode(11, 0, (enemy).x, (enemy).y, (enemy).targetAngle16, f32(10), ((kBaseSpeed)[difficulty + 1] + (v_local * 0.20000000000000001)), 1, 0)
                end
            end;
            (enemy).targetAngle16 = (approachAngle16((enemy).targetAngle16, liveAim, 48) % 65536)
        end
    end
end

M.updateStage03Type34 = function(ctx, enemy, parent)
    local timer = (enemy).helperTimer;
    (enemy).drawHelperState = (enemy).helperState;
    (enemy).drawHelperTimer = timer;
    (enemy).drawBodyThisFrame = true;
    local goalX = f32(((parent).x + (enemy).markerDrawX));
    local goalY = f32(((parent).y + (enemy).markerDrawY));
    (enemy).x = f32(f32(((enemy).x + f32((f32((goalX - (enemy).x)) / f32(10))))));
    (enemy).y = f32(f32(((enemy).y + f32((f32((goalY - (enemy).y)) / f32(10))))));
    if ((enemy).helperState == 0) then
        do
            if (timer == 0) then
                do
                    (enemy).x = f32((parent).x);
                    (enemy).y = f32((parent).y)
                end
            end;
            local entry = math.sin(((timer * kPi) / 80));
            (enemy).markerDrawX = f32(f32((entry * (enemy).originX)));
            (enemy).markerDrawY = f32(f32((entry * (enemy).originY)));
            if (bit.band(timer, 1) == 0) then
                do
                    local trail = (function() if ((#(ctx).enemySmallFrames_) > 29) then return ((ctx).enemySmallFrames_)[29 + 1] else return (-1) end end)();
                    local scale = math.max(0, entry);
                    ctx:spawnStageEffect(56, trail, 100, 34, (enemy).x, (enemy).y, (0 % 65536), 0, scale, scale, 24, 255, 255, 255, 96, 0)
                end
            end;
            if (timer == 40) then
                do
                    (enemy).helperState = 1;
                    (enemy).helperTimer = 0;
                    (enemy).targetable = true;
                    (enemy).targetableTimer = 0
                end
            end
        end
    end;
    if ((enemy).helperState == 1) then
        do
            if ((parent).helperTimer >= 80) then
                do
                    local difficulty = cpp.clamp(((ctx).config_).difficulty, 0, 4);
                    local p = math.fmod(((parent).helperTimer - 80), 380);
                    local index = bit.band((enemy).childIndex, 3);
                    local horizontalOrigin = projectileHorizontalOrigin(((ctx).player_).x);
                    local insideFiringArea = (((((enemy).x >= horizontalOrigin) and ((enemy).x <= f32((horizontalOrigin + f32(600))))) and ((enemy).y >= f32(0))) and ((enemy).y <= f32(720)));
                    if (p <= 200) then
                        do
                            local kBurstLength = {6, 9, 12, 12, 12};
                            local kRingCount = {15, 23, 27, 27, 25};
                            local kAngleStep = {50, 70, 80, 80, 120};
                            local kSpeed = {4.5, 6.4000000000000004, 7.5, 8, 9};
                            local start = (index * 50);
                            local v_end = ((kBurstLength)[difficulty + 1] + (index * 56));
                            if (p == start) then
                                do
                                    (enemy).targetAngle16 = (radiansToFixedAngleTrunc(math.atan2(f32((((ctx).player_).y - (enemy).y)), f32((((ctx).player_).x - (enemy).x)))) % 65536)
                                end
                            end;
                            if ((((insideFiringArea and (p < 200)) and (p >= start)) and (p < v_end)) and (math.fmod((p - start), 3) == 0)) then
                                do
                                    local count = (kRingCount)[difficulty + 1];
                                    local speed = ((kSpeed)[difficulty + 1] + (index * 0.59999999999999998));
                                    ctx:spawnProjectileSpread(4, 0, (enemy).x, (enemy).y, (enemy).targetAngle16, f32(0), speed, 1, count, kFixedAngleFullCircle, 0);
                                    if (difficulty >= 3) then
                                        do
                                            ctx:spawnProjectileSpread(4, 0, (enemy).x, (enemy).y, (enemy).targetAngle16, f32(0), (speed + 1.2), 1, count, kFixedAngleFullCircle, 0)
                                        end
                                    end
                                end
                            end;
                            local direction = (function() if (bit.band(index, 1) == 0) then return 1 else return (-1) end end)();
                            (enemy).targetAngle16 = (normalizeAngle16(((enemy).targetAngle16 + (direction * ((kAngleStep)[difficulty + 1] + (index * 10))))) % 65536)
                        end
                    end;
                    if (p >= 200) then
                        do
                            local kSpacing = {32, 18, 16, 16, 10};
                            local kCount = {23, 31, 35, 35, 35};
                            local kSpeed = {3.6000000000000001, 5, 5.5, 5.5, 6.5};
                            local spacing = (kSpacing)[difficulty + 1];
                            local start = (200 + (index * spacing));
                            if (((insideFiringArea and (p >= start)) and (p < 330)) and (math.fmod((p - start), (spacing * 5)) == 0)) then
                                do
                                    local count = ((kCount)[difficulty + 1] + (index * 2));
                                    local speed = ((kSpeed)[difficulty + 1] + (index * 0.29999999999999999));
                                    local randomAngle = scriptRandomAngle(u32(p));
                                    ctx:spawnProjectileSpread(3, 0, (enemy).x, (enemy).y, randomAngle, f32(0), speed, 1, count, kFixedAngleFullCircle, 0);
                                    if (difficulty >= 3) then
                                        do
                                            local u = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(u32(p), 30)), u32(p))), 1812433253) + 1));
                                            local a = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(u, 30)), u)), 1812433253) + 2));
                                            local b = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(a, 30)), a)), 1812433253) + 3));
                                            local c = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(b, 30)), b)), 1812433253) + 4));
                                            local mixed1 = u32(bit.bxor(u32(bit.lshift(u, 11)), u));
                                            local mixed2 = u32(bit.bxor(u32(bit.lshift(mixed1, 11)), mixed1));
                                            local result = u32(bit.bxor(u32(bit.bxor(u32(bit.rshift(u32(bit.bxor(u32(bit.rshift(c, 11)), mixed2)), 8)), mixed2)), c));
                                            local secondAngle = (u32((result - trunc(result / 65537))) % 65536);
                                            ctx:spawnProjectileSpread(3, 0, (enemy).x, (enemy).y, secondAngle, f32(0), (speed + 1), 1, count, kFixedAngleFullCircle, 0)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end;
    (enemy).secondaryAngle16 = (normalizeAngle16(((enemy).secondaryAngle16 + 2000)) % 65536);
    (enemy).drawHp = (enemy).hp;
    if ((enemy).hp < 1) then
        do
            ctx:spawnEnemyDeathRewardBurst(enemy, 1800, true);
            ctx:spawnStage03DeathNode(enemy, math.max(1, trunc((enemy).maxHp / 2)), (parent).entityId);
            (parent).liveChildCount = math.max(0, ((parent).liveChildCount - 1));
            (enemy).active = false
        end
    end;
    if (((parent).hp < 1) or ((ctx).stage03BossCountdown_ < 1)) then
        do
            ctx:spawnEnemyDeathEffects(enemy, 1, true);
            (enemy).active = false
        end
    end
end

M.updateStage04BossChild = function(ctx, enemy)
    (enemy).vx = f32(f32(0));
    (enemy).vy = f32(f32(0));
    (enemy).drawBodyThisFrame = true;
    (enemy).drawMarkerThisFrame = false;
    local parent = ctx:findEnemyById((enemy).parentEntityId);
    if (((parent == nil) or ((parent).spawnType ~= 315)) or (not (parent).active)) then
        do
            (enemy).active = false;
            do return end
        end
    end;
    if ((enemy).spawnType == 64) then
        do
            ctx:updateStage04Type40(enemy, parent)
        end
    else
        if ((enemy).spawnType == 65) then
            do
                ctx:updateStage04Type41(enemy, parent)
            end
        else
            do
                ctx:updateStage04Type42Or43(enemy, parent)
            end
        end
    end
end

M.updateStage04Type40 = function(ctx, enemy, parent)
    local difficulty = cpp.clamp(((ctx).config_).difficulty, 0, 4);
    local index = cpp.clamp((enemy).childIndex, 0, 5);
    local parentTimer = (parent).helperTimer;
    local sourceOnScreen = function(x, y)
        x = f32(x);
        y = f32(y);
        local horizontalOrigin = projectileHorizontalOrigin(((ctx).player_).x);
        do return ((((x >= horizontalOrigin) and (x <= f32((horizontalOrigin + f32(600))))) and (y >= f32(0))) and (y <= f32(720))) end
    end;
    local aimFrom = function(x, y)
        x = f32(x);
        y = f32(y);
        do return radiansToFixedAngleTrunc(math.atan2(f32((((ctx).player_).y - y)), f32((((ctx).player_).x - x)))) end
    end;
    local turnStepFor = function(current, target, base)
        current = (current % 65536);
        target = (target % 65536);
        local delta = (target - current);
        if (delta > 32768) then
            delta = (delta - 65536)
        end;
        if (delta < (-32768)) then
            delta = (delta + 65536)
        end;
        do return (trunc(math.abs(delta) / 10) + base) end
    end;
    local mountX = function()
        do return f32(((parent).x + (enemy).originX)) end
    end;
    local mountY = function()
        do return f32(((parent).y + (enemy).originY)) end
    end;
    local mountAngleAtEntry = radiansToFixedAngleTrunc(math.atan2(f32(((mountY)() - (enemy).y)), f32(((mountX)() - (enemy).x))));
    local followMount = function()
        (enemy).secondaryAngle16 = (approachAngle16((enemy).secondaryAngle16, mountAngleAtEntry, 1111) % 65536);
        local radians = fixedAngleToRadiansDouble((enemy).secondaryAngle16);
        (enemy).x = f32(f32(((enemy).x + f32((math.cos(radians) * (enemy).sourceSpeed)))));
        (enemy).y = f32(f32(((enemy).y + f32((math.sin(radians) * (enemy).sourceSpeed)))))
    end;
    local easeToMount = function()
        (enemy).x = f32(f32(((enemy).x + f32((f32(((mountX)() - (enemy).x)) / f32(20))))));
        (enemy).y = f32(f32(((enemy).y + f32((f32(((mountY)() - (enemy).y)) / f32(20))))))
    end;
    if ((enemy).helperState == 0) then
        do
            local timer = (enemy).helperTimer;
            if (timer == 0) then
                do
                    (enemy).x = f32((mountX)());
                    (enemy).y = f32((mountY)())
                end
            end;
            if (timer == 60) then
                do
                    (enemy).secondaryAngle16 = (((function() if (((index == 0) or (index == 3)) or (index == 4)) then return 1000 else return 31768 end end)() % 65536) % 65536);
                    (enemy).helperState = 1;
                    (enemy).helperTimer = 0;
                    (enemy).sourceSpeed = 1;
                    (enemy).speed = f32(f32(1));
                    (enemy).targetable = true;
                    (parent).liveChildCount = (parent).liveChildCount + 1
                end
            end;
            if (timer == 40) then
                do
                    ctx:playPlayerSound((ctx).bossSe1SoundHandle_, 19)
                end
            end
        end
    end;
    if ((enemy).helperState == 1) then
        do
            (followMount)();
            if ((enemy).helperTimer > 29) then
                do
                    if (parentTimer < 600) then
                        do
                            (enemy).helperState = 2;
                            (enemy).helperTimer = 0
                        end
                    else
                        if (parentTimer < 940) then
                            do
                                (enemy).helperState = 3;
                                (enemy).helperTimer = 0
                            end
                        else
                            if ((parentTimer >= 1950) and (parentTimer < 2550)) then
                                do
                                    (enemy).helperState = 6;
                                    (enemy).helperTimer = 0
                                end
                            end
                        end
                    end
                end
            end;
            if (parentTimer == (960 + (index * 150))) then
                do
                    (enemy).helperState = 4;
                    (enemy).helperTimer = 0
                end
            end;
            if (((parentTimer == 2600) or (parentTimer == 2870)) or (parentTimer == 3140)) then
                do
                    (enemy).helperState = 7;
                    (enemy).helperTimer = 0
                end
            end
        end
    end;
    if ((enemy).helperState == 2) then
        do
            (followMount)();
            if (parentTimer < 580) then
                do
                    local kPeriod = {79, 79, 61, 48, 39};
                    local kPairStep = {12, 12, 10, 8, 7};
                    local kSpeed = {2.5, 3.5, 3.7999999999999998, 4.5, 5.5};
                    local kWaveSign = {2222, (-2222), (-2222), 2222, 2222, (-2222)};
                    local baseAim = radiansToFixedAngleTrunc(math.atan2(f32((((ctx).player_).y - (enemy).y)), f32((((ctx).player_).x - (parent).x))));
                    local shotAngle = normalizeAngle16((baseAim + trunc((math.sin((((parentTimer - 32) * kPi) / 72)) * (kWaveSign)[index + 1]))));
                    (enemy).sourceAngle16 = (approachAngle16((enemy).sourceAngle16, shotAngle, (turnStepFor)((enemy).sourceAngle16, shotAngle, 48)) % 65536);
                    local start = (32 + (trunc(index / 2) * (kPairStep)[difficulty + 1]));
                    if ((parentTimer >= start) and (math.fmod((parentTimer - start), (kPeriod)[difficulty + 1]) == 0)) then
                        do
                            if (sourceOnScreen)((enemy).x, (enemy).y) then
                                do
                                    ctx:playPlayerSound((ctx).bullet1SoundHandle_, 12)
                                end
                            end;
                            local speed = (kSpeed)[difficulty + 1];
                            ctx:spawnProjectileNode(13, 0, (enemy).x, (enemy).y, shotAngle, f32(0), speed, 1, 0);
                            if (difficulty > 0) then
                                do
                                    ctx:spawnProjectileNode(13, 0, (enemy).x, (enemy).y, normalizeAngle16((shotAngle - 4444)), f32(0), (speed - 0.29999999999999999), 1, 0);
                                    ctx:spawnProjectileNode(13, 0, (enemy).x, (enemy).y, normalizeAngle16((shotAngle + 4444)), f32(0), (speed - 0.29999999999999999), 1, 0)
                                end
                            end
                        end
                    end
                end
            end;
            if (parentTimer == 600) then
                do
                    (enemy).helperState = 3;
                    (enemy).helperTimer = 0
                end
            end
        end
    end;
    if ((enemy).helperState == 3) then
        do
            (easeToMount)();
            (enemy).sourceAngle16 = (approachAngle16((enemy).sourceAngle16, (16384 % 65536), (turnStepFor)((enemy).sourceAngle16, (16384 % 65536), 48)) % 65536);
            if ((parentTimer >= 660) and (parentTimer < 920)) then
                do
                    local kPeriod = {65, 44, 38, 44, 38};
                    local kBaseSpeed = {4.2000000000000002, 5.5, 6, 6, 8};
                    local kIndexOffset = {0, 0, (-1000), 1000, (-2000), 2000};
                    local period = (kPeriod)[difficulty + 1];
                    local v_local = math.fmod((parentTimer - 660), period);
                    if (v_local == 0) then
                        do
                            (enemy).targetAngle16 = (normalizeAngle16((((aimFrom)((enemy).x, (enemy).y) + (kIndexOffset)[index + 1]) + trunc((math.sin((((parentTimer - (660 - trunc(period / 2))) * kPi) / period)) * ((parentTimer - 660) * 16))))) % 65536)
                        end
                    end;
                    if ((v_local <= 20) and (math.fmod(v_local, 4) == 0)) then
                        do
                            if (sourceOnScreen)((enemy).x, (enemy).y) then
                                do
                                    ctx:playPlayerSound((ctx).bullet1SoundHandle_, 12)
                                end
                            end;
                            local speed = ((kBaseSpeed)[difficulty + 1] + (v_local * 0.10000000000000001));
                            ctx:spawnProjectileNode(9, 0, (enemy).x, (enemy).y, (enemy).targetAngle16, f32(0), speed, 1, 0);
                            if (difficulty >= 3) then
                                do
                                    ctx:spawnProjectileNode(9, 0, (enemy).x, (enemy).y, normalizeAngle16(((enemy).targetAngle16 - 3888)), f32(0), (speed - 0.59999999999999998), 1, 0);
                                    ctx:spawnProjectileNode(9, 0, (enemy).x, (enemy).y, normalizeAngle16(((enemy).targetAngle16 + 3889)), f32(0), (speed - 0.59999999999999998), 1, 0)
                                end
                            end
                        end
                    end
                end
            end;
            if (parentTimer == 940) then
                do
                    (enemy).helperState = 1;
                    (enemy).helperTimer = 0
                end
            end
        end
    end;
    if (((enemy).helperState == 4) or ((enemy).helperState == 7)) then
        do
            local dashState = (enemy).helperState;
            local timer = (enemy).helperTimer;
            if (timer < 50) then
                do
                    local aimed = (aimFrom)((enemy).x, (enemy).y);
                    (enemy).sourceAngle16 = (approachAngle16((enemy).sourceAngle16, aimed, (turnStepFor)((enemy).sourceAngle16, aimed, 48)) % 65536)
                end
            end;
            if (timer == 1) then
                do
                    ctx:playPlayerSound((ctx).bossSe2SecondSoundHandle_, 25);
                    local handle = (function() if ((#(ctx).effectMediumFrames_) > 20) then return ((ctx).effectMediumFrames_)[20 + 1] else return (-1) end end)();
                    ctx:spawnStageEffect(65, handle, 80, 78, (enemy).x, (enemy).y, (enemy).sourceAngle16, 0, 0.69999999999999996, 0.69999999999999996, 90, 255, 255, 255, 128, (enemy).entityId)
                end
            end;
            if (timer == 90) then
                do
                    ctx:playPlayerSound((ctx).bossSe5SoundHandle_, 25);
                    (enemy).sourceSpeed = 10;
                    (enemy).speed = f32(f32(10))
                end
            end;
            if (timer >= 90) then
                do
                    local radians = fixedAngleToRadiansDouble((enemy).sourceAngle16);
                    (enemy).x = f32(f32(((enemy).x + f32((math.cos(radians) * (enemy).sourceSpeed)))));
                    (enemy).y = f32(f32(((enemy).y + f32((math.sin(radians) * (enemy).sourceSpeed)))));
                    (enemy).sourceSpeed = ((enemy).sourceSpeed + 0.20000000000000001);
                    (enemy).speed = f32(f32((enemy).sourceSpeed));
                    local horizontalOrigin = projectileHorizontalOrigin(((ctx).player_).x);
                    local inside = (((((enemy).x >= horizontalOrigin) and ((enemy).x <= f32((horizontalOrigin + f32(600))))) and ((enemy).y >= f32(0))) and ((enemy).y <= f32(720)));
                    if inside then
                        do
                            ctx:playPlayerSound((ctx).bullet1SoundHandle_, 12);
                            local muzzleX = f32(((enemy).x + f32((math.cos(radians) * 60))));
                            local muzzleY = f32(((enemy).y + f32((math.sin(radians) * 60))));
                            local reverse = normalizeAngle16(((enemy).sourceAngle16 + 32768));
                            ctx:spawnProjectileNode(3, 1, muzzleX, muzzleY, normalizeAngle16((reverse + stageRandomIntInclusive(u32(((ctx).frame_ + 444)), (-1200), 1200))), f32(0), 10, 1, 0);
                            ctx:spawnProjectileNode(5, 1, muzzleX, muzzleY, normalizeAngle16((reverse + stageRandomIntInclusive(u32((ctx).frame_), (-1500), 1500))), f32(0), 9, 1, 0);
                            if (dashState == 4) then
                                do
                                    local kPeriod = {4, 1, 1, 1, 1};
                                    local kCount = {1, 1, 2, 2, 3};
                                    local kSpeed = {2, 2.7999999999999998, 3.2000000000000002, 3.6000000000000001, 5};
                                    local kSpin = {2000, 3800, 3600, 3600, 3200};
                                    local period = (kPeriod)[difficulty + 1];
                                    if (math.fmod((timer - 90), period) == 0) then
                                        do
                                            local direction = (function() if (bit.band(index, 1) == 0) then return (-1) else return 1 end end)();
                                            local ringAngle = normalizeAngle16(((enemy).sourceAngle16 + ((direction * (kSpin)[difficulty + 1]) * timer)));
                                            local count = (kCount)[difficulty + 1];
                                            local speed = (kSpeed)[difficulty + 1];
                                            ctx:spawnProjectileSpread(12, 3, muzzleX, muzzleY, ringAngle, f32(0), speed, 1, count, kFixedAngleFullCircle, 0);
                                            if (difficulty >= 3) then
                                                do
                                                    ctx:spawnProjectileSpread(12, 3, muzzleX, muzzleY, ringAngle, f32(0), (speed - 0.59999999999999998), 1, count, kFixedAngleFullCircle, 0)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end;
            if ((timer >= 100) and (((((enemy).x < f32(40)) or ((enemy).x > f32(680))) or ((enemy).y < f32(40))) or ((enemy).y > f32(680)))) then
                do
                    ctx:playPlayerSound((ctx).bossSe6SoundHandle_, 20);
                    local body = (function() if ((#(ctx).enemyMediumFrames_) > 75) then return ((ctx).enemyMediumFrames_)[75 + 1] else return (-1) end end)();
                    ctx:spawnStageEffect(34, body, 80, 36, (enemy).x, (enemy).y, (enemy).sourceAngle16, 0, 3, 3, 24, 255, 255, 255, 128, 0);
                    (enemy).helperState = (dashState + 1);
                    (enemy).helperTimer = 0
                end
            end
        end
    end;
    if (((enemy).helperState == 5) or ((enemy).helperState == 8)) then
        do
            local returnState = (enemy).helperState;
            local timer = (enemy).helperTimer;
            if (timer >= 90) then
                do
                    (easeToMount)();
                    (enemy).sourceAngle16 = (approachAngle16((enemy).sourceAngle16, (16384 % 65536), (turnStepFor)((enemy).sourceAngle16, (16384 % 65536), 48)) % 65536)
                end
            end;
            if (returnState == 8) then
                do
                    local kDivisor = {7, 4, 3, 2, 2};
                    local kWindow = {14, 18, 20, 20, 23};
                    local kSpeed = {3.5, 4.5, 5, 5.5, 7.5};
                    local kChainX = {f32(50), f32((-f32(50))), f32(100), f32((-f32(100))), f32(140), f32((-f32(140)))};
                    local kChainY = {f32(150), f32(150), f32(140), f32(140), f32(120), f32(120)};
                    local start = ((index * 12) + 8);
                    if (((timer >= start) and (timer < (start + (kWindow)[difficulty + 1]))) and (math.fmod((timer - start), 3) == 0)) then
                        do
                            local anchorX = f32(((parent).x + (kChainX)[index + 1]));
                            local anchorY = f32(((parent).y + (kChainY)[index + 1]));
                            local chainAngle = radiansToFixedAngleTrunc(math.atan2(f32(((enemy).y - anchorY)), f32(((enemy).x - anchorX))));
                            do
                                local segment = 0
                                while (segment < 20) do
                                    repeat
                                        do
                                            if (math.fmod(segment, (kDivisor)[difficulty + 1]) ~= 0) then
                                                do
                                                    do break end
                                                end
                                            end;
                                            local fraction = f32((f32(segment) / f32(20)));
                                            local wave = f32((f32(4) * math.sin(((((ctx).frame_ - (segment * 7)) * kTau) / 80))));
                                            local sourceX = f32((f32((anchorX + f32((f32(((enemy).x - anchorX)) * fraction)))) + wave));
                                            local sourceY = f32((anchorY + f32((f32(((enemy).y - anchorY)) * fraction))));
                                            if (sourceOnScreen)(sourceX, sourceY) then
                                                do
                                                    ctx:playPlayerSound((ctx).bullet1SoundHandle_, 9)
                                                end
                                            end;
                                            ctx:spawnProjectileSpread(4, 0, sourceX, sourceY, normalizeAngle16((chainAngle + 32768)), f32(0), ((kSpeed)[difficulty + 1] + ((timer - start) * 0.10000000000000001)), 1, 2, (16384 + (segment * 1638)), 0)
                                        end
                                    until true
                                    segment = segment + 1
                                end
                            end
                        end
                    end
                end
            end;
            if (((timer == 120) or (parentTimer == 2868)) or (parentTimer == 3138)) then
                do
                    (enemy).helperState = 1;
                    (enemy).helperTimer = 0;
                    (enemy).sourceSpeed = 1;
                    (enemy).speed = f32(f32(1))
                end
            end
        end
    end;
    if ((enemy).helperState == 6) then
        do
            (easeToMount)();
            local kPhaseStart = {14, 21, 7, 27, 0, 35};
            local kPhaseOffset = {0, 0, (-2000), 2000, (-4000), 4000};
            local wave = ((kPhaseOffset)[index + 1] + trunc((math.sin((((parentTimer - (kPhaseStart)[index + 1]) * kTau) / 155)) * 2400)));
            local heading = normalizeAngle16((wave + 16384));
            if ((enemy).y >= ((ctx).player_).y) then
                do
                    heading = (normalizeAngle16((heading + 32768)) % 65536)
                end
            end;
            (enemy).sourceAngle16 = (approachAngle16((enemy).sourceAngle16, heading, (turnStepFor)((enemy).sourceAngle16, (16384 % 65536), 48)) % 65536);
            local kPeriod = {72, 44, 32, 32, 28};
            local kWindow = {12, 16, 16, 16, 20};
            local kCount = {1, 1, 1, 2, 2};
            local kBase = {3, 3.7999999999999998, 4.5, 4.5, 5.5};
            local start = (2000 + (trunc(index / 2) * 8));
            if (parentTimer >= start) then
                do
                    local remainder = (parentTimer - start);
                    local phase = math.fmod(remainder, (kPeriod)[difficulty + 1]);
                    if ((phase < (kWindow)[difficulty + 1]) and (math.fmod(remainder, 4) == 0)) then
                        do
                            if (sourceOnScreen)((enemy).x, (enemy).y) then
                                do
                                    ctx:playPlayerSound((ctx).bullet1SoundHandle_, 9)
                                end
                            end;
                            local speed = ((kBase)[difficulty + 1] + ((parentTimer - 2000) * 0.0050000000000000001));
                            ctx:spawnProjectileSpread(13, 0, (enemy).x, (enemy).y, heading, f32(0), speed, 1, (kCount)[difficulty + 1], 3333, 0);
                            local opposite = normalizeAngle16((heading + 32768));
                            ctx:spawnProjectileNode(13, 0, (enemy).x, (enemy).y, normalizeAngle16((opposite - 10922)), f32(0), speed, 1, 0);
                            ctx:spawnProjectileNode(13, 0, (enemy).x, (enemy).y, normalizeAngle16((opposite + 10923)), f32(0), speed, 1, 0)
                        end
                    end
                end
            end;
            if (parentTimer == 2550) then
                do
                    (enemy).helperState = 1;
                    (enemy).helperTimer = 0
                end
            end
        end
    end;
    if ((enemy).helperState == (-1)) then
        do
            local timer = (enemy).helperTimer;
            local kChainX = {f32(50), f32((-f32(50))), f32(100), f32((-f32(100))), f32(140), f32((-f32(140)))};
            local kChainY = {f32(150), f32(150), f32(140), f32(140), f32(120), f32(120)};
            local anchorX = f32(((parent).x + (kChainX)[index + 1]));
            local anchorY = f32(((parent).y + (kChainY)[index + 1]));
            do
                local segment = 0
                while (segment < 20) do
                    repeat
                        do
                            if (timer ~= (60 - (segment * 3))) then
                                do
                                    do break end
                                end
                            end;
                            local fraction = f32((f32(segment) / f32(20)));
                            local pointX = f32((f32((anchorX + f32((f32(((enemy).x - anchorX)) * fraction)))) + (f32(4) * math.sin(((((ctx).frame_ - (segment * 7)) * kTau) / 80)))));
                            local pointY = f32((anchorY + f32((f32(((enemy).y - anchorY)) * fraction))));
                            local burst = (function() if ((#(ctx).effectMediumFrames_) > 5) then return ((ctx).effectMediumFrames_)[5 + 1] else return (-1) end end)();
                            local spark = (function() if ((#(ctx).playerFrames_) > 14) then return ((ctx).playerFrames_)[14 + 1] else return (-1) end end)();
                            ctx:spawnStageEffect(42, burst, 200, 29, pointX, pointY, scriptRandomAngle(u32((timer + segment))), 0, 1, 1, 24, 255, 255, 255, 192, 0);
                            ctx:spawnStageEffect(44, spark, 80, 62, pointX, pointY, scriptRandomAngle(u32(((ctx).frame_ + segment))), 8, 1, 1, 0, 255, 255, 255, 192, 0);
                            ctx:playPlayerSound((ctx).enemyDown1SoundHandle_, 19)
                        end
                    until true
                    segment = segment + 1
                end
            end;
            if (((parent).helperState ~= 1) and (timer >= 80)) then
                do
                    (enemy).active = false
                end
            end;
            if (timer == 200) then
                do
                    (enemy).hp = (enemy).maxHp;
                    (enemy).drawHp = (enemy).hp;
                    (enemy).x = f32((mountX)());
                    (enemy).y = f32((mountY)());
                    (enemy).helperState = 0;
                    (enemy).helperTimer = 0;
                    (enemy).targetable = false
                end
            end
        end
    end;
    (enemy).drawHelperState = (enemy).helperState;
    (enemy).drawHelperTimer = (enemy).helperTimer;
    (enemy).drawHp = (enemy).hp;
    if (((enemy).hp < 1) and ((enemy).helperState >= 1)) then
        do
            ctx:spawnEnemyDeathRewardBurst(enemy, 2000, false);
            ctx:spawnEnemyDeathEffects(enemy, 1, true);
            ctx:spawnStage04DeathNode(enemy, (enemy).maxHp, (parent).entityId);
            (parent).liveChildCount = math.max(0, ((parent).liveChildCount - 1));
            (enemy).targetable = false;
            (enemy).helperState = (-1);
            (enemy).helperTimer = 0
        end
    else
        if (((enemy).helperState >= 1) and (not ((((parent).hp > 0) and ((ctx).stage04BossCountdown_ > 0)) and ((parent).helperState < 2)))) then
            do
                ctx:spawnEnemyDeathEffects(enemy, 1, true);
                (enemy).targetable = false;
                (enemy).helperState = (-1);
                (enemy).helperTimer = 0
            end
        end
    end
end

M.updateStage04Type41 = function(ctx, enemy, parent)
    local difficulty = cpp.clamp(((ctx).config_).difficulty, 0, 4);
    local stateAtEntry = (enemy).helperState;
    local timer = (enemy).helperTimer;
    local entryScale = 1;
    if ((enemy).helperState == 0) then
        do
            entryScale = math.sin(((timer * kPi) / 100));
            if (timer == 50) then
                do
                    (enemy).helperState = 1;
                    (enemy).helperTimer = 0;
                    entryScale = 1
                end
            end
        end
    end;
    if ((enemy).helperState == 1) then
        do
            local liveTimer = (enemy).helperTimer;
            local maximumStep = (function() if (difficulty == 0) then return 333 else return 555 end end)();
            local step = 0;
            if (liveTimer < 600) then
                do
                    step = trunc((math.sin(((liveTimer * kPi) / 1200)) * maximumStep))
                end
            else
                if (liveTimer < 1200) then
                    do
                        step = maximumStep
                    end
                else
                    if (liveTimer < 1800) then
                        do
                            step = trunc((math.sin((((liveTimer - 600) * kPi) / 1200)) * maximumStep))
                        end
                    end
                end
            end;
            (enemy).secondaryAngle16 = (normalizeAngle16(((enemy).secondaryAngle16 + step)) % 65536);
            local kInterval = {8, 5, 3, 4, 3};
            local kSpeed = {4.7999999999999998, 6, 7, 7, 9};
            local interval = (kInterval)[difficulty + 1];
            do
                local wave = 0
                while (wave < 25) do
                    do
                        local start = ((10 + (24 * wave)) + trunc(((interval * wave) * (wave - 1)) / 2));
                        if (((liveTimer >= start) and (liveTimer <= (start + (wave * interval)))) and (math.fmod((liveTimer - start), interval) == 0)) then
                            do
                                ctx:playPlayerSound((ctx).bullet1SoundHandle_, 12);
                                local speed = (kSpeed)[difficulty + 1];
                                ctx:spawnProjectileNode(3, 0, (enemy).x, f32(((enemy).y + f32(15))), (enemy).secondaryAngle16, f32(0), speed, 1, 0);
                                if (difficulty >= 3) then
                                    do
                                        ctx:spawnProjectileNode(9, 0, (enemy).x, f32(((enemy).y + f32(15))), (enemy).secondaryAngle16, f32(0), (speed - 2.3999999999999999), 1, 0)
                                    end
                                end
                            end
                        end
                    end
                    wave = wave + 1
                end
            end
        end
    end;
    local verticalRadius = ((enemy).originX * entryScale);
    local horizontalRadius = ((enemy).originY * entryScale);
    local tiltAngle16 = 0;
    if (stateAtEntry == 0) then
        do
            verticalRadius = trunc(verticalRadius);
            horizontalRadius = trunc(horizontalRadius)
        end
    else
        do
            verticalRadius = ((enemy).originX * math.sin((((timer + 80) * kPi) / 160)));
            horizontalRadius = (enemy).originY;
            tiltAngle16 = trunc((math.sin(((timer * kPi) / 115)) * 2222))
        end
    end;
    local tilt = fixedAngleToRadiansDouble(normalizeAngle16(tiltAngle16));
    local orbit = fixedAngleToRadiansDouble((enemy).secondaryAngle16);
    local tiltCos = math.cos(tilt);
    local tiltSin = math.sin(tilt);
    local orbitCos = math.cos(orbit);
    local orbitSin = math.sin(orbit);
    (enemy).x = f32(f32(((parent).x + f32((((tiltCos * orbitCos) * horizontalRadius) - ((tiltSin * orbitSin) * verticalRadius))))));
    (enemy).y = f32(f32(((parent).y + f32((((tiltCos * orbitSin) * verticalRadius) + ((tiltSin * orbitCos) * horizontalRadius))))));
    if (((stateAtEntry == 0) and (timer < 50)) and (bit.band(timer, 1) == 0)) then
        do
            local base = (entryScale * (0.90000000000000002 + (0.10000000000000001 * math.sin(fixedAngleToRadiansDouble((enemy).secondaryAngle16)))));
            local pulse0 = (base * (1 + (0.10000000000000001 * math.sin((((parent).helperTimer * kPi) / 22)))));
            local pulse10 = (base * (1 + (0.10000000000000001 * math.sin(((((parent).helperTimer - 10) * kPi) / 22)))));
            local layer = (function() if ((enemy).secondaryAngle16 <= 32768) then return 31 else return 28 end end)();
            ctx:spawnStageEffect(5, (function() if ((#(ctx).enemySmallFrames_) > 44) then return ((ctx).enemySmallFrames_)[44 + 1] else return (-1) end end)(), 16, (layer + 1), (enemy).x, (enemy).y, (0 % 65536), 0, pulse10, base, 16, 255, 255, 255, 96, 0);
            ctx:spawnStageEffect(5, (function() if ((#(ctx).enemySmallFrames_) > 45) then return ((ctx).enemySmallFrames_)[45 + 1] else return (-1) end end)(), 16, (layer + 1), (enemy).x, (enemy).y, (0 % 65536), 0, pulse0, base, 16, 255, 255, 255, 96, 0)
        end
    end;
    (enemy).drawHelperState = (enemy).helperState;
    (enemy).drawHelperTimer = (enemy).helperTimer;
    (enemy).drawHp = (enemy).hp;
    if (((parent).hp < 1) or ((ctx).stage04BossCountdown_ < 1)) then
        do
            ctx:spawnEnemyDeathEffects(enemy, 0, true);
            (enemy).active = false
        end
    end
end

M.updateStage04Type42Or43 = function(ctx, enemy, parent)
    local difficulty = cpp.clamp(((ctx).config_).difficulty, 0, 4);
    local stateAtEntry = (enemy).helperState;
    local timerAtEntry = (enemy).helperTimer;
    local centerX = (parent).x;
    local centerY = f32(((parent).y - f32(60)));
    local entryScale = 1;
    if ((enemy).helperState == 0) then
        do
            if (timerAtEntry == 0) then
                do
                    (enemy).sourceAngle16 = ((16384 % 65536) % 65536)
                end
            end;
            entryScale = math.sin(((timerAtEntry * kPi) / 100));
            local radians = fixedAngleToRadiansDouble((enemy).secondaryAngle16);
            (enemy).x = f32(f32((centerX + f32(((math.cos(radians) * (enemy).originX) * entryScale)))));
            (enemy).y = f32(f32((centerY + f32(((math.sin(radians) * (enemy).originX) * entryScale)))));
            if (timerAtEntry == 50) then
                do
                    (enemy).maxHp = (parent).maxHp;
                    (enemy).hp = (parent).hp;
                    (enemy).drawHp = (enemy).hp;
                    (enemy).helperState = 1;
                    (enemy).helperTimer = 0;
                    (enemy).targetable = true;
                    (enemy).targetableTimer = 0;
                    entryScale = 1
                end
            end
        end
    end;
    if ((enemy).helperState == 1) then
        do
            local timer = (enemy).helperTimer;
            local oldX = (enemy).x;
            local oldY = (enemy).y;
            local oldHeading = (enemy).sourceAngle16;
            local oldHeadingRadians = fixedAngleToRadiansDouble(oldHeading);
            local muzzleX = f32((oldX + f32((math.cos(oldHeadingRadians) * 50))));
            local muzzleY = f32((oldY + f32((math.sin(oldHeadingRadians) * 50))));
            if ((enemy).spawnType == 66) then
                do
                    local cycle = math.fmod(timer, 1200);
                    local rotationStep = trunc((math.sin(((timer * kPi) / 1200)) * 550));
                    (enemy).secondaryAngle16 = (normalizeAngle16(((enemy).secondaryAngle16 + rotationStep)) % 65536);
                    local kRadiusAmplitude = {(-120), (-80), (-60), (-60), (-40)};
                    local radius = (180 + (math.sin(((cycle * kPi) / 1200)) * (kRadiusAmplitude)[difficulty + 1]));
                    local orbitRadians = fixedAngleToRadiansDouble((enemy).secondaryAngle16);
                    (enemy).x = f32(f32((centerX + f32((math.cos(orbitRadians) * radius)))));
                    (enemy).y = f32(f32((centerY + f32((math.sin(orbitRadians) * radius)))));
                    local aimed = radiansToFixedAngleTrunc(math.atan2(f32((((ctx).player_).y - centerY)), f32((((ctx).player_).x - centerX))));
                    local delta = (aimed - (enemy).sourceAngle16);
                    if (delta > 32768) then
                        delta = (delta - 65536)
                    end;
                    if (delta < (-32768)) then
                        delta = (delta + 65536)
                    end;
                    (enemy).sourceAngle16 = (approachAngle16((enemy).sourceAngle16, aimed, (trunc(math.abs(delta) / 10) + 48)) % 65536);
                    local kPeriodA = {90, 44, 33, 50, 44};
                    local kBurstA = {18, 21, 24, 24, 24};
                    local kBaseA = {4, 5, 6, 6.5, 7.5};
                    if (cycle < 280) then
                        do
                            local phase = math.fmod(cycle, (kPeriodA)[difficulty + 1]);
                            if (phase == 0) then
                                do
                                    (enemy).targetAngle16 = ((enemy).sourceAngle16 % 65536)
                                end
                            end;
                            if ((phase < (kBurstA)[difficulty + 1]) and (math.fmod(phase, 3) == 0)) then
                                do
                                    ctx:playPlayerSound((ctx).bullet1SoundHandle_, 12);
                                    local speed = ((kBaseA)[difficulty + 1] + (phase * 0.10000000000000001));
                                    ctx:spawnProjectileNode(13, 0, muzzleX, muzzleY, (enemy).targetAngle16, f32(10), speed, 1, 0);
                                    if (difficulty >= 3) then
                                        do
                                            ctx:spawnProjectileNode(13, 0, muzzleX, muzzleY, normalizeAngle16(((enemy).targetAngle16 - 3333)), f32(10), (speed - 0.80000000000000004), 1, 0);
                                            ctx:spawnProjectileNode(13, 0, muzzleX, muzzleY, normalizeAngle16(((enemy).targetAngle16 + 3333)), f32(10), (speed - 0.80000000000000004), 1, 0)
                                        end
                                    end
                                end
                            end
                        end
                    end;
                    local kAnchors = {410, 570, 730, 800};
                    local kBaseB = {3.5, 4.5, 5, 5, 6};
                    local kSlopeB = {0.10000000000000001, 0.14999999999999999, 0.20000000000000001, 0.20000000000000001, 0.23999999999999999};
                    do

                        for _, anchor in ipairs(kAnchors) do
                            do
                                if (cycle == anchor) then
                                    do
                                        (enemy).targetAngle16 = ((enemy).sourceAngle16 % 65536)
                                    end
                                end;
                                if (((cycle >= anchor) and (cycle < (anchor + 60))) and (math.fmod((cycle - anchor), 4) == 0)) then
                                    do
                                        ctx:playPlayerSound((ctx).bullet1SoundHandle_, 12);
                                        local speed = ((kBaseB)[difficulty + 1] + ((cycle - anchor) * (kSlopeB)[difficulty + 1]));
                                        ctx:spawnProjectileNode(2, 0, muzzleX, muzzleY, (enemy).targetAngle16, f32(10), speed, 1, 0);
                                        if (difficulty >= 3) then
                                            do
                                                ctx:spawnProjectileNode(2, 0, muzzleX, muzzleY, normalizeAngle16(((enemy).targetAngle16 - 13500)), f32(10), speed, 1, 0);
                                                ctx:spawnProjectileNode(2, 0, muzzleX, muzzleY, normalizeAngle16(((enemy).targetAngle16 + 13500)), f32(10), speed, 1, 0)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end;
                    local kIntervalC = {48, 30, 18, 14, 12};
                    local kSpeedC = {4, 5, 5.5, 6.5, 7.7000000000000001};
                    if (((cycle >= 880) and (cycle < 1150)) and (math.fmod((cycle - 880), (kIntervalC)[difficulty + 1]) == 0)) then
                        do
                            ctx:playPlayerSound((ctx).bullet1SoundHandle_, 12);
                            local speed = (kSpeedC)[difficulty + 1];
                            ctx:spawnProjectileNode(13, 0, muzzleX, muzzleY, (enemy).sourceAngle16, f32(10), speed, 1, 0);
                            if (difficulty > 0) then
                                do
                                    ctx:spawnProjectileNode(13, 0, muzzleX, muzzleY, normalizeAngle16(((enemy).sourceAngle16 - 3888)), f32(10), speed, 1, 0);
                                    ctx:spawnProjectileNode(13, 0, muzzleX, muzzleY, normalizeAngle16(((enemy).sourceAngle16 + 3889)), f32(10), speed, 1, 0)
                                end
                            end
                        end
                    end
                end
            else
                do
                    local rotationStep = 0;
                    if (timer < 600) then
                        do
                            rotationStep = trunc((math.sin(((timer * kPi) / 1200)) * 240))
                        end
                    else
                        if (timer < 1200) then
                            do
                                rotationStep = 240
                            end
                        else
                            if (timer < 1800) then
                                do
                                    rotationStep = (240 - trunc((math.sin((((timer - 1200) * kPi) / 1200)) * 240)))
                                end
                            end
                        end
                    end;
                    (enemy).secondaryAngle16 = (normalizeAngle16(((enemy).secondaryAngle16 + rotationStep)) % 65536);
                    local orbitRadians = fixedAngleToRadiansDouble((enemy).secondaryAngle16);
                    (enemy).x = f32(f32((centerX + f32((math.cos(orbitRadians) * 130)))));
                    (enemy).y = f32(f32((centerY + f32((math.sin(orbitRadians) * 130)))));
                    local aimed = radiansToFixedAngleTrunc(math.atan2(f32((((ctx).player_).y - oldY)), f32((((ctx).player_).x - oldX))));
                    local delta = (aimed - (enemy).sourceAngle16);
                    if (delta > 32768) then
                        delta = (delta - 65536)
                    end;
                    if (delta < (-32768)) then
                        delta = (delta + 65536)
                    end;
                    (enemy).sourceAngle16 = (approachAngle16((enemy).sourceAngle16, aimed, (trunc(math.abs(delta) / 10) + 48)) % 65536);
                    local kPeriod = {75, 40, 36, 32, 26};
                    local kBase = {5.5, 6.5, 7, 7.5, 9.5};
                    local period = (kPeriod)[difficulty + 1];
                    local start = (20 + ((enemy).childIndex * period));
                    if (timer >= start) then
                        do
                            local cycle = math.fmod((timer - start), (period * 3));
                            if (cycle == 0) then
                                do
                                    (enemy).targetAngle16 = ((enemy).sourceAngle16 % 65536)
                                end
                            end;
                            if ((cycle < 24) and (math.fmod(cycle, 3) == 0)) then
                                do
                                    ctx:playPlayerSound((ctx).bullet1SoundHandle_, 12);
                                    local speed = ((kBase)[difficulty + 1] + (math.fmod((timer - start), period) * 0.070000000000000007));
                                    ctx:spawnProjectileNode(13, 0, muzzleX, muzzleY, (enemy).targetAngle16, f32(10), speed, 1, 0);
                                    if (difficulty >= 3) then
                                        do
                                            ctx:spawnProjectileNode(13, 0, muzzleX, muzzleY, normalizeAngle16(((enemy).targetAngle16 - 750)), f32(10), (speed - 0.5), 1, 0);
                                            ctx:spawnProjectileNode(13, 0, muzzleX, muzzleY, normalizeAngle16(((enemy).targetAngle16 + 750)), f32(10), (speed - 0.5), 1, 0)
                                        end
                                    end
                                end
                            end
                        end
                    end;
                    (enemy).targetAngle16 = (approachAngle16((enemy).targetAngle16, aimed, 48) % 65536)
                end
            end
        end
    end;
    if (((stateAtEntry == 0) and (timerAtEntry < 50)) and (bit.band(timerAtEntry, 1) == 0)) then
        do
            local pulse0 = (entryScale * (1 + (0.10000000000000001 * math.sin((((parent).helperTimer * kPi) / 33)))));
            local pulse12 = (entryScale * (1 + (0.10000000000000001 * math.sin(((((parent).helperTimer - 12) * kPi) / 33)))));
            local headingRadians = fixedAngleToRadiansDouble((enemy).sourceAngle16);
            ctx:spawnStageEffect(5, (function() if ((#(ctx).enemyMediumFrames_) > 77) then return ((ctx).enemyMediumFrames_)[77 + 1] else return (-1) end end)(), 20, 36, f32(((enemy).x + f32(((math.cos(headingRadians) * 30) * entryScale)))), f32(((enemy).y + f32(((math.sin(headingRadians) * 30) * entryScale)))), (enemy).sourceAngle16, 0, entryScale, pulse12, 20, 255, 255, 255, 96, 0);
            ctx:spawnStageEffect(5, (function() if ((#(ctx).enemyMediumFrames_) > 76) then return ((ctx).enemyMediumFrames_)[76 + 1] else return (-1) end end)(), 20, 36, (enemy).x, (enemy).y, (0 % 65536), 0, entryScale, pulse0, 20, 255, 255, 255, 96, 0)
        end
    end;
    (enemy).drawHelperState = (enemy).helperState;
    (enemy).drawHelperTimer = (enemy).helperTimer;
    (enemy).drawHp = (enemy).hp;
    if ((enemy).helperState == 1) then
        do
            if ((enemy).hp < (parent).hp) then
                do
                    (parent).hp = (enemy).hp
                end
            end;
            if ((parent).hp < (enemy).hp) then
                do
                    (enemy).hp = (parent).hp
                end
            end;
            if ((enemy).hp < 1) then
                do
                    (parent).hp = 0
                end
            end;
            if (((parent).hp < 1) or ((ctx).stage04BossCountdown_ < 1)) then
                do
                    ctx:spawnEnemyDeathEffects(enemy, 1, true);
                    (enemy).active = false
                end
            end
        end
    end
end

M.spawnDelayedOwnerDamageNode = function(ctx, hitPoints, ownerEntityId, ownerSpawnType, note)
    if (((#(ctx).enemies_) + (#(ctx).pendingEnemies_)) >= kStageEntityCap) then
        do
            do return end
        end
    end;
    local node = cpp.newEnemy();
    (node).entityId = (function() local __old = (ctx).nextEntityId_; (ctx).nextEntityId_ = (ctx).nextEntityId_ + 1; return __old end)();
    (node).spawnType = 339;
    (node).sourceHitPoints = hitPoints;
    (node).sourceX = (-100);
    (node).sourceY = (-100);
    (node).sourceNote = note;
    (node).updateCase = 181;
    (node).sourceDispatchKind = 1;
    (node).sourceDispatchField = 10;
    (node).parentEntityId = ownerEntityId;
    (node).parentSpawnType = ownerSpawnType;
    (node).x = f32(f32((-f32(100))));
    (node).y = f32(f32((-f32(100))));
    (node).originX = f32(f32((-f32(100))));
    (node).originY = f32(f32((-f32(100))));
    (node).sourceAngle16 = ((16384 % 65536) % 65536);
    (node).sourceSpeed = 1;
    (node).speed = f32(f32(1));
    (node).hp = math.max(1, hitPoints);
    (node).maxHp = (node).hp;
    (node).drawHp = (node).hp;
    (node).radius = 10;
    (node).activationDelay = 0;
    (node).rewardWeight = 1;
    (node).targetable = false;
    cpp.push((ctx).pendingEnemies_, node)
end

M.updateStage03DeathNode = function(ctx, enemy)
    (enemy).vx = f32(f32(0));
    (enemy).vy = f32(f32(0));
    (enemy).drawBodyThisFrame = false;
    (enemy).drawMarkerThisFrame = false;
    local owner = ctx:findEnemyById((enemy).parentEntityId);
    if (((owner == nil) or ((owner).spawnType ~= (enemy).parentSpawnType)) or (not (owner).active)) then
        do
            (enemy).active = false;
            do return end
        end
    end;
    local chunk = math.max(1, trunc((enemy).maxHp / 30));
    local damage = math.min((enemy).hp, chunk);
    (enemy).hp = ((enemy).hp - damage);
    (owner).hp = ((owner).hp - damage);
    (enemy).drawHp = (enemy).hp;
    if ((enemy).hp < 1) then
        do
            (enemy).active = false
        end
    end
end

cpp.install(M)

return M
