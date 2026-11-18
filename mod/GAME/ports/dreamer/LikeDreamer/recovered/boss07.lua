-- 由 tools/generate_likedreamer_native_bosses.py 从本地复原源码生成。

-- 生成物是普通 Lua 状态机；修改源逻辑或生成规则后重新生成并核对轨迹。

local cpp = assert(LikeDreamer.Recovered)

local f32, trunc, u32, s16 = cpp.f32, cpp.trunc, cpp.u32, cpp.s16

local bit = require("bit")

local M = {}

local kPi = 3.1415926535897931

local kTau = (kPi * 2)

local kStage07EntityCap = 512

local normalizeStage07Angle

local stage07AngleRadians

local stage07RadiansToAngle

local approachStage07Angle

local stage07ScriptRand

local stage07RandomRange

local stage07PolarX

local stage07PolarY

local stage07Distance

local stage07NodeUpdateCase

local isStage07HeadType

local isStage07FirstFormPart

local isStage07CombatState

local frameHandle07

normalizeStage07Angle = function(angle)
    do return (bit.band(angle, 65535) % 65536) end
end

stage07AngleRadians = function(angle)
    angle = (angle % 65536);
    do return ((angle * kTau) / 65536) end
end

stage07RadiansToAngle = function(radians)
    do return normalizeStage07Angle(trunc(((radians * 65536) / kTau))) end
end

approachStage07Angle = function(current, target, step)
    current = (current % 65536);
    target = (target % 65536);
    local delta = (target - current);
    if (delta > 32768) then
        delta = (delta - 65536)
    end;
    if (delta < (-32768)) then
        delta = (delta + 65536)
    end;
    do return normalizeStage07Angle((current + cpp.clamp(delta, (-step), step))) end
end

stage07ScriptRand = function(seed)
    local value = u32(seed);
    local u = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(value, 30)), value)), 1812433253) + 1));
    local a = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(u, 30)), u)), 1812433253) + 2));
    local b = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(a, 30)), a)), 1812433253) + 3));
    local c = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(b, 30)), b)), 1812433253) + 4));
    local mixed = u32(bit.bxor(cpp.mul32(u, 2048), u));
    do return u32(bit.bxor(u32(bit.bxor(u32(bit.rshift(u32(bit.bxor(u32(bit.rshift(c, 11)), mixed)), 8)), c)), mixed)) end
end

stage07RandomRange = function(seed, minimum, maximum)
    local low = trunc((minimum * 100));
    local high = trunc((maximum * 100));
    do return ((low + math.fmod(stage07ScriptRand(seed), u32(((high - low) + 1)))) / 100) end
end

stage07PolarX = function(angle, radius)
    angle = (angle % 65536);
    do return f32((math.cos(stage07AngleRadians(angle)) * radius)) end
end

stage07PolarY = function(angle, radius)
    angle = (angle % 65536);
    do return f32((math.sin(stage07AngleRadians(angle)) * radius)) end
end

stage07Distance = function(x1, y1, x2, y2)
    x1 = f32(x1);
    y1 = f32(y1);
    x2 = f32(x2);
    y2 = f32(y2);
    do return cpp.hypot(f32((x2 - x1)), f32((y2 - y1))) end
end

stage07NodeUpdateCase = function(spawnType)
    if (spawnType == 128) then
        do return 89 end
    end;
    if (spawnType <= 130) then
        do return 90 end
    end;
    if (spawnType <= 132) then
        do return 91 end
    end;
    if (spawnType <= 134) then
        do return 92 end
    end;
    if (spawnType <= 136) then
        do return 93 end
    end;
    if (spawnType <= 138) then
        do return 94 end
    end;
    if (spawnType <= 142) then
        do return 95 end
    end;
    if (spawnType <= 146) then
        do return 96 end
    end;
    do return 97 end
end

isStage07HeadType = function(spawnType)
    do return ((spawnType == 131) or (spawnType == 132)) end
end

isStage07FirstFormPart = function(spawnType)
    do return ((spawnType >= 133) and (spawnType <= 138)) end
end

isStage07CombatState = function(state)
    do return (((((((((state == 1) or (state == 11)) or (state == 12)) or (state == 13)) or (state == 21)) or (state == 31)) or (state == 41)) or (state == 51)) or (state == 61)) end
end

frameHandle07 = function(frames, index)
    do return (function() if ((index >= 0) and (index < (#frames))) then return (frames)[index + 1] else return (-1) end end)() end
end

M.isStage07BossNodeType = function(ctx, spawnType)
    do return ((spawnType >= 128) and (spawnType <= 148)) end
end

M.spawnStage07BossNode = function(ctx, parent, spawnType, childIndex, offsetX, offsetY, angle16, speed, radius, hitPoints)
    offsetX = f32(offsetX);
    offsetY = f32(offsetY);
    angle16 = (angle16 % 65536);
    if ((not ctx:isStage07BossNodeType(spawnType)) or (((#(ctx).enemies_) + (#(ctx).pendingEnemies_)) >= kStage07EntityCap)) then
        do
            do return false end
        end
    end;
    local node = cpp.newEnemy();
    (node).entityId = (function() local __old = (ctx).nextEntityId_; (ctx).nextEntityId_ = (ctx).nextEntityId_ + 1; return __old end)();
    (node).spawnType = spawnType;
    (node).updateCase = stage07NodeUpdateCase(spawnType);
    (node).sourceHitPoints = hitPoints;
    (node).sourceX = cpp.lround(offsetX);
    (node).sourceY = cpp.lround(offsetY);
    (node).sourceNote = "S07 FUN_14002b680 recovered boss apparatus";
    (node).sourceDispatchKind = 1;
    (node).sourceDispatchField = radius;
    (node).parentEntityId = (parent).entityId;
    (node).parentSpawnType = (parent).spawnType;
    (node).childIndex = childIndex;
    (node).originX = f32(offsetX);
    (node).originY = f32(offsetY);
    (node).sourceAngle16 = (angle16 % 65536);
    (node).secondaryAngle16 = (angle16 % 65536);
    (node).targetAngle16 = (angle16 % 65536);
    (node).angle = f32(f32(stage07AngleRadians(angle16)));
    (node).sourceSpeed = speed;
    (node).speed = f32(f32(speed));
    (node).hp = hitPoints;
    (node).maxHp = hitPoints;
    (node).drawHp = hitPoints;
    (node).radius = radius;
    (node).activationDelay = 0;
    (node).rewardWeight = 0;
    (node).targetable = false;
    if (spawnType == 128) then
        do
            (node).x = f32(offsetX);
            (node).y = f32(offsetY)
        end
    else
        do
            (node).x = f32(f32(((parent).x + offsetX)));
            (node).y = f32(f32(((parent).y + offsetY)))
        end
    end;
    (node).markerDrawX = f32((node).x);
    (node).markerDrawY = f32((node).y);
    cpp.push((ctx).pendingEnemies_, node);
    do return true end
end

M.updateStage07Boss = function(ctx, enemy)
    local difficulty = cpp.clamp(((ctx).config_).difficulty, 0, 4);
    local findHead = function(index)
        do

            for _, candidate in ipairs((ctx).enemies_) do
                do
                    if ((((candidate).parentEntityId == (enemy).entityId) and isStage07HeadType((candidate).spawnType)) and ((candidate).childIndex == index)) then
                        do
                            do return candidate end
                        end
                    end
                end
                ::__continue2::
            end
            ::__loop_end1::
        end;
        do return nil end
    end;
    local openPhase = function(state, hitPoints, countdown, phaseIndex)
        (enemy).helperState = state;
        (enemy).helperTimer = 0;
        (enemy).hp = hitPoints;
        (enemy).maxHp = hitPoints;
        (enemy).drawHp = hitPoints;
        (enemy).targetable = false;
        (enemy).targetableTimer = 0;
        (ctx).lateStageBossMaxHp_ = hitPoints;
        (ctx).lateStageBossCountdown_ = countdown;
        (ctx).lateStageBossCountdownDraw_ = countdown;
        (ctx).lateStageBossPhaseIndex_ = phaseIndex;
        (ctx).lateStageBossPhaseMode_ = 1
    end;
    if (((ctx).lateStageBossPhaseMode_ == 1) and (((enemy).hp < 1) or ((ctx).lateStageBossCountdown_ < 1))) then
        do
            local first = (findHead)(0);
            local second = (findHead)(1);
            local firstHp = (function() if (first ~= nil) then return (first).hp else return 0 end end)();
            local secondHp = (function() if (second ~= nil) then return (second).hp else return 0 end end)();
            local combatState = (enemy).helperState;
            local expired = ((ctx).lateStageBossCountdown_ < 1);
            local emitBreakFeedback = function(source)
                if expired then
                    do
                        ctx:flushEnemyProjectilesToEffects();
                        ((ctx).player_).invulnerableFrames = math.max(((ctx).player_).invulnerableFrames, 100)
                    end
                else
                    do
                        ctx:spawnPlayerSideObject(24, (source).x, (source).y, 0, (0 % 65536), 0, f32(0))
                    end
                end;
                ctx:spawnBossPhaseBreakFeedback(source, (ctx).lateStageBossCountdown_)
            end;
            (enemy).targetable = false;
            (enemy).targetableTimer = 0;
            (enemy).helperTimer = 0;
            do
                local __switch4 = (ctx).lateStageBossBreaksRemaining_
                if __switch4 == 5 then goto __case5
                elseif __switch4 == 4 then goto __case6
                elseif __switch4 == 3 then goto __case7
                elseif __switch4 == 2 then goto __case8
                elseif __switch4 == 1 then goto __case9
                else goto __case10 end
                ::__case5::;
                (emitBreakFeedback)(enemy);
                ctx:spawnPostDeathCounterEntity(enemy, 140);
                (enemy).helperState = 10;
                (ctx).lateStageBossPhaseMode_ = 2;
                goto __switch_end3;
                ::__case6::;
                do
                    local leftSurvived = ((combatState == 12) or ((combatState == 11) and (firstHp >= secondHp)));
                    if (combatState == 11) then
                        do
                            local lost = (function() if leftSurvived then return second else return first end end)();
                            if (lost ~= nil) then
                                do
                                    ctx:spawnStage07BossNode(enemy, (function() if leftSurvived then return 130 else return 129 end end)(), (function() if leftSurvived then return 1 else return 0 end end)(), f32(((lost).x - (enemy).x)), f32(((lost).y - (enemy).y)), (16384 % 65536), 0, 80, 99999999)
                                end
                            end
                        end
                    end;
                    local survivor = (function() if leftSurvived then return first else return second end end)();
                    if (survivor ~= nil) then
                        do
                            (emitBreakFeedback)(survivor);
                            ctx:spawnPostDeathCounterEntity(survivor, 140);
                            ctx:spawnEnemyDeathEffects(survivor, 1, true)
                        end
                    else
                        do
                            (emitBreakFeedback)(enemy);
                            ctx:spawnPostDeathCounterEntity(enemy, 140)
                        end
                    end;
                    (enemy).helperState = (function() if leftSurvived then return 20 else return 40 end end)();
                    (ctx).lateStageBossPhaseMode_ = 2;
                    goto __switch_end3
                end;
                ::__case7::;
                if (combatState == 21) then
                    do
                        if (first ~= nil) then
                            do
                                (emitBreakFeedback)(first);
                                ctx:spawnPostDeathCounterEntity(first, 140);
                                ctx:spawnEnemyDeathEffects(first, 1, true)
                            end
                        else
                            do
                                (emitBreakFeedback)(enemy);
                                ctx:spawnPostDeathCounterEntity(enemy, 140)
                            end
                        end;
                        (enemy).helperState = 30
                    end
                else
                    do
                        if (second ~= nil) then
                            do
                                (emitBreakFeedback)(second);
                                ctx:spawnPostDeathCounterEntity(second, 140);
                                ctx:spawnEnemyDeathEffects(second, 1, true)
                            end
                        else
                            do
                                (emitBreakFeedback)(enemy);
                                ctx:spawnPostDeathCounterEntity(enemy, 140)
                            end
                        end;
                        (enemy).helperState = 50
                    end
                end;
                (ctx).lateStageBossPhaseMode_ = 2;
                goto __switch_end3;
                ::__case8::;
                do
                    local broken = (function() if (combatState == 31) then return first else return second end end)();
                    local source = (function() if (broken ~= nil) then return broken else return enemy end end)();
                    (emitBreakFeedback)(source);
                    ctx:spawnPostDeathCounterEntity(source, 140);
                    (enemy).helperState = (function() if (combatState == 31) then return 59 else return 60 end end)();
                    (ctx).lateStageBossPhaseMode_ = 2;
                    goto __switch_end3
                end;
                ::__case9::;
                if (first ~= nil) then
                    do
                        (emitBreakFeedback)(first);
                        ctx:spawnPostDeathCounterEntity(first, 140)
                    end
                end;
                if (second ~= nil) then
                    do
                        (emitBreakFeedback)(second);
                        ctx:spawnPostDeathCounterEntity(second, 140)
                    end
                end;
                if ((first == nil) and (second == nil)) then
                    do
                        (emitBreakFeedback)(enemy);
                        ctx:spawnPostDeathCounterEntity(enemy, 140)
                    end
                end;
                if (first ~= nil) then
                    ctx:spawnEnemyDeathEffects(first, 1, true)
                end;
                if (second ~= nil) then
                    ctx:spawnEnemyDeathEffects(second, 1, true)
                end;
                (enemy).helperState = 70;
                (ctx).lateStageBossPhaseMode_ = (-1);
                (ctx).lateStageClearStarted_ = true;
                (ctx).lateStageClearTimer_ = 0;
                ((ctx).player_).invulnerableFrames = math.max(((ctx).player_).invulnerableFrames, 360);
                goto __switch_end3;
                ::__case10::;
                goto __switch_end3
                ::__switch_end3::
            end;
            (ctx).lateStageBossBreaksRemaining_ = math.max(0, ((ctx).lateStageBossBreaksRemaining_ - 1));
            (ctx).lateStageBossPhaseIndex_ = math.min(4, ((ctx).lateStageBossPhaseIndex_ + 1))
        end
    end;
    if (math.fmod((ctx).frame_, 50) == 0) then
        do
            (ctx).lateStageBossTargetX_ = f32(f32((f32(260) + f32(math.fmod(stage07ScriptRand((ctx).frame_), 201)))));
            (ctx).lateStageBossTargetY_ = f32(f32((f32(230) + f32(math.fmod(stage07ScriptRand(((ctx).frame_ + (difficulty * 222))), 51)))))
        end
    end;
    local timer = (enemy).helperTimer;
    do
        local __switch12 = (enemy).helperState
        if __switch12 == 0 then goto __case13
        elseif __switch12 == 1 then goto __case14
        elseif __switch12 == 10 then goto __case15
        elseif __switch12 == 11 then goto __case16
        elseif __switch12 == 12 then goto __case17
        elseif __switch12 == 13 then goto __case18
        elseif __switch12 == 20 then goto __case19
        elseif __switch12 == 30 then goto __case20
        elseif __switch12 == 40 then goto __case21
        elseif __switch12 == 50 then goto __case22
        elseif __switch12 == 59 then goto __case23
        elseif __switch12 == 60 then goto __case24
        elseif __switch12 == 21 then goto __case25
        elseif __switch12 == 31 then goto __case26
        elseif __switch12 == 41 then goto __case27
        elseif __switch12 == 51 then goto __case28
        elseif __switch12 == 61 then goto __case29
        elseif __switch12 == 70 then goto __case30
        else goto __case31 end
        ::__case13::;
        if (timer == 0) then
            do
                ctx:spawnStage07BossNode(enemy, 131, 0, f32((-f32(80))), f32(0), (16384 % 65536), 0.29999999999999999, 70, 99999999);
                ctx:spawnStage07BossNode(enemy, 132, 1, f32(80), f32(0), (16384 % 65536), 0.29999999999999999, 70, 99999999);
                ctx:spawnStage07BossNode(enemy, 133, 2, f32((-f32(115))), f32((-f32(120))), (16384 % 65536), 1, 50, 99999999);
                ctx:spawnStage07BossNode(enemy, 134, 3, f32(115), f32((-f32(120))), (16384 % 65536), 1, 50, 99999999);
                ctx:spawnStage07BossNode(enemy, 135, 4, f32(230), f32((-f32(70))), (16384 % 65536), 1, 60, 20000);
                ctx:spawnStage07BossNode(enemy, 135, 5, f32((-f32(230))), f32((-f32(70))), (16384 % 65536), 1, 60, 20000);
                ctx:spawnStage07BossNode(enemy, 136, 6, f32(70), f32(145), (16384 % 65536), 1, 24, 10000);
                ctx:spawnStage07BossNode(enemy, 136, 7, f32((-f32(70))), f32(145), (16384 % 65536), 1, 24, 10000);
                ctx:spawnStage07BossNode(enemy, 136, 8, f32(185), f32(115), (16384 % 65536), 1, 24, 10000);
                ctx:spawnStage07BossNode(enemy, 136, 9, f32((-f32(185))), f32(115), (16384 % 65536), 1, 24, 10000);
                ctx:spawnStage07BossNode(enemy, 137, 10, f32(50), f32((-f32(190))), (16384 % 65536), 1, 20, 99999999);
                ctx:spawnStage07BossNode(enemy, 138, 11, f32((-f32(50))), f32((-f32(190))), (16384 % 65536), 1, 20, 99999999);
                ctx:spawnStage07BossNode(enemy, 138, 12, f32(200), f32((-f32(190))), (16384 % 65536), 1, 20, 99999999);
                ctx:spawnStage07BossNode(enemy, 137, 13, f32((-f32(200))), f32((-f32(190))), (16384 % 65536), 1, 20, 99999999);
                ctx:spawnStage07BossNode(enemy, 128, 14, f32(460), f32(800), (16384 % 65536), 1, 30, 99999999);
                ctx:spawnStage07BossNode(enemy, 128, 15, f32(265), f32(800), (16384 % 65536), 1, 30, 99999999);
                ctx:playPlayerSound((ctx).bossSe8SoundHandle_, 25)
            end
        end;
        if (timer == 20) then
            do
                ctx:spawnStage07BossNode(enemy, 128, 16, f32(110), f32(800), (16384 % 65536), 1, 30, 99999999);
                ctx:spawnStage07BossNode(enemy, 128, 17, f32(610), f32(800), (16384 % 65536), 1, 30, 99999999)
            end
        end;
        if (timer == 80) then
            do
                ctx:playPlayerSound((ctx).bossSe7SoundHandle_, 25)
            end
        end;
        if (timer < 80) then
            do
                (enemy).y = f32(f32(1000))
            end
        else
            if (timer < 200) then
                do
                    local t = ((timer - 80) / 120);
                    (enemy).y = f32(f32((f32(1000) + f32(((250 - 1000) * (0.5 - (math.cos((t * kPi)) * 0.5)))))))
                end
            else
                do
                    (enemy).y = f32(f32(((enemy).y + f32(0.100000001))))
                end
            end
        end;
        if (timer == 240) then
            do
                (ctx).lateStageBossBreaksRemaining_ = 5;
                (openPhase)(1, 148000, 3600, 0)
            end
        end;
        goto __switch_end11;
        ::__case14::;
        do
            (enemy).targetable = false;
            local target = stage07RadiansToAngle(math.atan2(f32(((ctx).lateStageBossTargetY_ - (enemy).y)), f32(((ctx).lateStageBossTargetX_ - (enemy).x))));
            (enemy).sourceAngle16 = (approachStage07Angle((enemy).sourceAngle16, target, 512) % 65536);
            local radians = stage07AngleRadians((enemy).sourceAngle16);
            (enemy).x = f32(f32(((enemy).x + f32((math.cos(radians) * 0.20000000000000001)))));
            (enemy).y = f32(f32(((enemy).y + f32((math.sin(radians) * 0.20000000000000001)))));
            goto __switch_end11
        end;
        ::__case15::;
        (enemy).targetable = false;
        if (timer < 90) then
            do
                (enemy).y = f32(f32(((enemy).y + f32((f32(timer) * f32(0.0500000007))))))
            end
        end;
        if ((timer == 1) or (timer == 90)) then
            do
                ctx:spawnStage02DeathExplosionChain(enemy)
            end
        end;
        if (timer == 90) then
            ctx:playPlayerSound((ctx).blast1SoundHandle_, 25)
        end;
        if (timer == 390) then
            (openPhase)(11, 70000, 2100, 1)
        end;
        goto __switch_end11;
        ::__case16::;
        ::__case17::;
        ::__case18::;
        do
            (enemy).targetable = false;
            local first = (findHead)(0);
            local second = (findHead)(1);
            local firstHp = (function() if (first ~= nil) then return (first).hp else return 0 end end)();
            local secondHp = (function() if (second ~= nil) then return (second).hp else return 0 end end)();
            if ((enemy).helperState == 11) then
                do
                    local lost = nil;
                    local detachedType = 0;
                    if (firstHp < 0) then
                        do
                            (enemy).helperState = 13;
                            lost = first;
                            detachedType = 129
                        end
                    else
                        if (secondHp < 0) then
                            do
                                (enemy).helperState = 12;
                                lost = second;
                                detachedType = 130
                            end
                        end
                    end;
                    if (lost ~= nil) then
                        do
                            ctx:spawnStage07BossNode(enemy, detachedType, (function() if (detachedType == 129) then return 0 else return 1 end end)(), f32(((lost).x - (enemy).x)), f32(((lost).y - (enemy).y)), (16384 % 65536), 0, 80, 99999999);
                            ctx:spawnPlayerSideObject(25, (lost).x, (lost).y, 0, (0 % 65536), 0, f32(80))
                        end
                    end
                end
            end;
            (enemy).hp = (math.max(0, firstHp) + math.max(0, secondHp));
            goto __switch_end11
        end;
        ::__case19::;
        ::__case20::;
        ::__case21::;
        ::__case22::;
        ::__case23::;
        ::__case24::;
        (enemy).targetable = false;
        if (timer == 180) then
            do
                local hitPoints = (function() if ((enemy).helperState >= 59) then return 80000 else return 70000 end end)();
                (openPhase)((function() if ((enemy).helperState >= 59) then return 61 else return ((enemy).helperState + 1) end end)(), hitPoints, 2100, cpp.clamp((5 - (ctx).lateStageBossBreaksRemaining_), 1, 4))
            end
        end;
        goto __switch_end11;
        ::__case25::;
        ::__case26::;
        ::__case27::;
        ::__case28::;
        ::__case29::;
        do
            (enemy).targetable = false;
            local first = (findHead)(0);
            local second = (findHead)(1);
            local firstHp = (function() if (first ~= nil) then return (first).hp else return 0 end end)();
            local secondHp = (function() if (second ~= nil) then return (second).hp else return 0 end end)();
            (enemy).hp = math.min((enemy).hp, math.min(firstHp, secondHp));
            goto __switch_end11
        end;
        ::__case30::;
        (enemy).targetable = false;
        if ((timer < 240) and (math.fmod(timer, 3) == 0)) then
            do
                ctx:spawnStage02DeathExplosionChain(enemy)
            end
        end;
        if (timer == 240) then
            do
                ctx:playPlayerSound((ctx).blast2SoundHandle_, 25);
                ctx:spawnEnemyDeathEffects(enemy, 2, true)
            end
        end;
        if (timer >= 480) then
            do
                ctx:clearLateStageGate(7);
                (enemy).active = false
            end
        end;
        goto __switch_end11;
        ::__case31::;
        goto __switch_end11
        ::__switch_end11::
    end;
    (enemy).drawHp = (enemy).hp;
    (ctx).lateStageBossCountdownDraw_ = (ctx).lateStageBossCountdown_;
    if (((ctx).lateStageBossPhaseMode_ == 1) and isStage07CombatState((enemy).helperState)) then
        do
            ctx:updateBossCountdownAudio((enemy).hp, (ctx).lateStageBossCountdown_);
            (ctx).lateStageBossCountdown_ = (ctx).lateStageBossCountdown_ - 1
        end
    end
end

M.updateStage07BossNode = function(ctx, enemy)
    (enemy).vx = f32(f32(0));
    (enemy).vy = f32(f32(0));
    (enemy).drawMarkerThisFrame = false;
    (enemy).drawBodyThisFrame = true;
    (enemy).drawHp = (enemy).hp;
    local parent = ctx:findEnemyById((enemy).parentEntityId);
    local root = parent;
    if ((root ~= nil) and ((root).spawnType ~= 318)) then
        do
            root = ctx:findEnemyById((root).parentEntityId)
        end
    end;
    if (((root == nil) or ((root).spawnType ~= 318)) or (not (root).active)) then
        do
            (enemy).targetable = false;
            (enemy).active = false;
            do return end
        end
    end;
    local difficulty = cpp.clamp(((ctx).config_).difficulty, 0, 4);
    local aimAtPlayer = function(x, y)
        x = f32(x);
        y = f32(y);
        do return stage07RadiansToAngle(math.atan2(f32((((ctx).player_).y - y)), f32((((ctx).player_).x - x)))) end
    end;
    local fireSound = function()
        ctx:playPlayerSound((ctx).bullet2SoundHandle_, 19)
    end;
    if ((enemy).spawnType == 128) then
        do
            local timer = (enemy).helperTimer;
            local amplitude = (function() if (bit.band(((enemy).entityId - (root).entityId), 1) == 0) then return 4000 else return (-4000) end end)();
            (enemy).sourceAngle16 = (normalizeStage07Angle((16384 - trunc((math.sin(((timer * kTau) / 328)) * amplitude)))) % 65536);
            local baseY = f32((-f32(100)));
            if ((timer >= 0) and (timer < 120)) then
                do
                    baseY = f32(f32((f32(800) - f32((f32(900) * f32(math.sin(((timer * kPi) / 240))))))))
                end
            end;
            if ((((enemy).helperState == 0) and ((root).helperState == 70)) and ((root).helperTimer == 1)) then
                do
                    (enemy).helperState = 1
                end
            end;
            if ((enemy).helperState == 1) then
                do
                    baseY = f32(f32(((enemy).markerDrawY + f32((f32((root).helperTimer) * f32(0.150000006))))));
                    if ((root).helperTimer == 80) then
                        do
                            ctx:spawnEnemyDeathEffects(enemy, 0, false);
                            (enemy).active = false
                        end
                    end
                end
            end;
            (enemy).markerDrawX = f32((enemy).originX);
            (enemy).markerDrawY = f32(baseY);
            (enemy).markerDrawTimer = (root).helperTimer;
            (enemy).x = f32(f32(((enemy).originX + stage07PolarX((enemy).sourceAngle16, 20))));
            (enemy).y = f32(f32((f32((baseY + f32(24))) + stage07PolarY((enemy).sourceAngle16, 20))));
            do return end
        end
    end;
    if (((enemy).spawnType == 129) or ((enemy).spawnType == 130)) then
        do
            (enemy).targetable = false;
            if ((enemy).helperTimer == 1) then
                do
                    ctx:spawnEnemyDeathEffects(enemy, 0, false)
                end
            end;
            if ((enemy).helperTimer < 90) then
                do
                    ctx:spawnStage02DeathExplosionChain(enemy)
                end
            end;
            (enemy).y = f32(f32(((enemy).y + f32((f32((enemy).helperTimer) * f32(0.100000001))))));
            if ((root).helperState == 70) then
                (enemy).active = false
            end;
            do return end
        end
    end;
    if isStage07HeadType((enemy).spawnType) then
        do
            local state = (root).helperState;
            local timer = (root).helperTimer;
            (enemy).helperState = state;
            (enemy).helperTimer = timer;
            local phaseEntry = ((timer == 1) and (((((((state == 1) or (state == 11)) or (state == 21)) or (state == 31)) or (state == 41)) or (state == 51)) or (state == 61)));
            if phaseEntry then
                do
                    local hitPoints = (root).hp;
                    if (state == 11) then
                        do
                            hitPoints = math.max(1, trunc((root).hp / 2))
                        end
                    end;
                    (enemy).hp = hitPoints;
                    (enemy).maxHp = hitPoints;
                    (enemy).sourceHitPoints = hitPoints
                end
            end;
            if ((state == 1) and (not phaseEntry)) then
                do
                    local damage = math.max(0, ((enemy).sourceHitPoints - (enemy).hp));
                    if (damage > 0) then
                        (root).hp = math.max(0, ((root).hp - damage))
                    end;
                    (enemy).hp = math.min((enemy).hp, (root).hp);
                    (enemy).sourceHitPoints = (enemy).hp
                end
            else
                if ((state == 61) and (not phaseEntry)) then
                    do
                        (enemy).hp = math.min((enemy).hp, (root).hp);
                        (enemy).sourceHitPoints = (enemy).hp
                    end
                end
            end;
            local leftHead = ((enemy).spawnType == 131);
            local headEnabled = (((((((state == 1) or (state == 11)) or ((state == 12) and leftHead)) or ((state == 13) and (not leftHead))) or (state == 61)) or (((state == 21) or (state == 31)) and leftHead)) or (((state == 41) or (state == 51)) and (not leftHead)));
            (enemy).targetable = ((isStage07CombatState(state) and headEnabled) and ((enemy).hp > 0));
            (enemy).drawBodyThisFrame = (headEnabled or (not isStage07CombatState(state)));
            if (state == 70) then
                do
                    (enemy).targetable = false;
                    local exitTimer = (function() if leftHead then return 220 else return 240 end end)();
                    if (timer >= exitTimer) then
                        (enemy).active = false
                    end
                end
            end;
            local transitionState = ((((((state == 20) or (state == 30)) or (state == 40)) or (state == 50)) or (state == 59)) or (state == 60));
            local attached = ((state <= 1) or ((state == 10) and (timer < 100)));
            if attached then
                do
                    (enemy).x = f32(f32(((root).x + (enemy).originX)));
                    (enemy).y = f32(f32(((root).y + (enemy).originY)))
                end
            else
                if (((state == 12) or (state == 13)) and (not headEnabled)) then
                    do
                        (enemy).x = f32(f32(0));
                        (enemy).y = f32(f32(3.0E+4))
                    end
                else
                    if (((((state == 21) or (state == 31)) or (state == 41)) or (state == 51)) and (not headEnabled)) then
                        do
                            (enemy).y = f32(f32(1.0E+4))
                        end
                    else
                        if (not transitionState) then
                            do
                                if (math.fmod((ctx).frame_, 50) == 0) then
                                    do
                                        local wideRange = ((state > 20) and (state < 59));
                                        local xBase = (function() if leftHead then return 210 else return (function() if wideRange then return 310 else return 410 end end)() end end)();
                                        local xRange = (function() if wideRange then return 201 else return 101 end end)();
                                        (enemy).sourceX = (xBase + math.fmod(stage07ScriptRand(((ctx).frame_ + ((enemy).childIndex * 111))), u32(xRange)));
                                        (enemy).sourceY = (200 + math.fmod(stage07ScriptRand(((ctx).frame_ + ((enemy).childIndex * 333))), 51))
                                    end
                                end;
                                local travelTarget = stage07RadiansToAngle(math.atan2(f32((f32((enemy).sourceY) - (enemy).y)), f32((f32((enemy).sourceX) - (enemy).x))));
                                (enemy).sourceAngle16 = (approachStage07Angle((enemy).sourceAngle16, travelTarget, 512) % 65536);
                                local travel = stage07AngleRadians((enemy).sourceAngle16);
                                (enemy).x = f32(f32(((enemy).x + f32((math.cos(travel) * (enemy).sourceSpeed)))));
                                (enemy).y = f32(f32(((enemy).y + f32((math.sin(travel) * (enemy).sourceSpeed)))))
                            end
                        end
                    end
                end
            end;
            if transitionState then
                do
                    local dyingHead = (((((state == 20) or (state == 30)) or (state == 59)) and leftHead) or ((((state == 40) or (state == 50)) or (state == 60)) and (not leftHead)));
                    if dyingHead then
                        do
                            (enemy).targetable = false;
                            if (timer < 90) then
                                ctx:spawnStage02DeathExplosionChain(enemy)
                            end;
                            (enemy).y = f32(f32(((enemy).y + f32(0.100000001))))
                        end
                    else
                        if (((state == 20) and (not leftHead)) or ((state == 40) and leftHead)) then
                            do
                                (enemy).x = f32(f32(0));
                                (enemy).y = f32(f32(3.0E+4))
                            end
                        else
                            if ((state == 59) or (state == 60)) then
                                do
                                    (enemy).x = f32((function() if leftHead then return f32(220) else return f32(500) end end)());
                                    (enemy).y = f32(f32((f32(900) - f32((f32(660) * f32(math.sin(((timer * kPi) / 360))))))))
                                end
                            end
                        end
                    end
                end
            end;
            if (not (enemy).targetable) then
                do return end
            end;
            local muzzleOrbit = ((((ctx).frame_ * 399.60975609756099) * kPi) / 32768);
            local shotX = f32(((enemy).x + f32((math.cos(muzzleOrbit) * 24))));
            local shotY = f32((f32(((enemy).y - f32(120))) + f32((math.sin(muzzleOrbit) * 24))));
            local shotAim = function()
                do return (aimAtPlayer)(shotX, shotY) end
            end;
            local firedQuiet = false;
            local firedLoud = false;
            if ((state >= 11) and (state <= 13)) then
                do
                    local cycle = math.fmod(timer, 1200);
                    local index = difficulty;
                    local kOpeningCount = {17, 21, 23, 25, 27};
                    local kOpeningWindow = {15, 25, 35, 45, 45};
                    local kOpeningTurn = {180, 250, 300, 360, 420};
                    local kOpeningSpeed = {5, 6, 6.5, 7, 8};
                    if ((cycle >= 40) and (cycle < 320)) then
                        do
                            local v_local = (cycle - 40);
                            if (math.fmod(v_local, 80) == 0) then
                                (enemy).secondaryAngle16 = ((shotAim)() % 65536)
                            end;
                            local burstFrame = math.fmod(v_local, 80);
                            local window = ((kOpeningWindow)[index + 1] + (function() if (state == 11) then return 0 else return 10 end end)());
                            if ((burstFrame < window) and (math.fmod(burstFrame, 5) == 0)) then
                                do
                                    local alternate = (math.fmod(v_local, 160) < 80);
                                    local subtype = (function() if leftHead then return (function() if alternate then return 9 else return 0 end end)() else return (function() if alternate then return 0 else return 9 end end)() end end)();
                                    ctx:spawnProjectileSpread((function() if leftHead then return 2 else return 3 end end)(), subtype, shotX, shotY, (enemy).secondaryAngle16, f32(10), ((kOpeningSpeed)[index + 1] + (v_local * 0.0080000000000000002)), 1, (kOpeningCount)[index + 1], 65536, 0);
                                    local turn = ((kOpeningTurn)[index + 1] + v_local);
                                    (enemy).secondaryAngle16 = (normalizeStage07Angle(((enemy).secondaryAngle16 + (function() if leftHead then return turn else return (-turn) end end)())) % 65536);
                                    firedQuiet = true
                                end
                            end
                        end
                    end;
                    local kMiddleCadence = {12, 9, 7, 6, 6};
                    local kMiddleCount = {4, 6, 7, 9, 10};
                    local kMiddleSpreadStep = {1500, 1500, 1300, 1000, 900};
                    local kMiddleTurn = {400, 680, 750, 750, 750};
                    local kMiddleSpeed = {5.5, 6.5, 7, 7.5, 7.5};
                    local kLayerDrop = {0.90000000000000002, 0.80000000000000004, 0.69999999999999996, 0.59999999999999998, 0.59999999999999998};
                    if ((cycle >= 360) and (cycle < 540)) then
                        do
                            local cadence = (kMiddleCadence)[index + 1];
                            if (state ~= 11) then
                                do
                                    local kSoloCadence = {8, 6, 5, 4, 4};
                                    cadence = (kSoloCadence)[index + 1]
                                end
                            end;
                            if (cycle == 360) then
                                (enemy).secondaryAngle16 = ((49152 % 65536) % 65536)
                            end;
                            if (math.fmod((cycle - 360), cadence) == 0) then
                                do
                                    local selector = (function() if leftHead then return (function() if (difficulty > 2) then return 4 else return 2 end end)() else return (function() if (difficulty > 2) then return 5 else return 3 end end)() end end)();
                                    ctx:spawnProjectileNode(selector, 0, shotX, shotY, (enemy).secondaryAngle16, f32(10), (kMiddleSpeed)[index + 1], 1, 0);
                                    local spread = 0;
                                    do
                                        local layer = 0
                                        while (layer < (kMiddleCount)[index + 1]) do
                                            do
                                                ctx:spawnProjectileSpread(selector, 0, shotX, shotY, (enemy).secondaryAngle16, f32(10), ((kMiddleSpeed)[index + 1] - (layer * (kLayerDrop)[index + 1])), 1, 2, spread, 0);
                                                spread = (spread + (kMiddleSpreadStep)[index + 1])
                                            end
                                            ::__continue33::
                                            layer = layer + 1
                                        end
                                        ::__loop_end32::
                                    end;
                                    firedQuiet = true
                                end
                            end;
                            (enemy).secondaryAngle16 = (normalizeStage07Angle(((enemy).secondaryAngle16 + (function() if leftHead then return (-(kMiddleTurn)[index + 1]) else return (kMiddleTurn)[index + 1] end end)())) % 65536)
                        end
                    end;
                    if (((cycle >= 600) and (cycle < 1160)) and leftHead) then
                        do
                            local kCadence = {40, 30, 24, 20, 16};
                            local kCount = {7, 9, 11, 13, 13};
                            local kSpeed = {5, 5.5, 6, 6, 7.2000000000000002};
                            local cadence = (kCadence)[index + 1];
                            local count = (kCount)[index + 1];
                            local speed = ((kSpeed)[index + 1] + ((cycle - 600) * 0.0050000000000000001));
                            local aim = (shotAim)();
                            local fireLeftFan = function(fanCount, spread)
                                ctx:spawnProjectileSpread(4, 10, shotX, shotY, aim, f32(10), speed, 1, fanCount, spread, 0);
                                if (state == 12) then
                                    do
                                        ctx:spawnProjectileSpread(4, 10, shotX, shotY, aim, f32(10), speed, 1, fanCount, spread, 0);
                                        ctx:spawnProjectileSpread(4, 10, shotX, shotY, normalizeStage07Angle((aim - 600)), f32(10), speed, 1, fanCount, spread, 0)
                                    end
                                end
                            end;
                            if (math.fmod((cycle - 600), (cadence * 2)) == 0) then
                                do
                                    (fireLeftFan)(count, 44000);
                                    firedQuiet = true
                                end
                            end;
                            if ((cycle >= (600 + cadence)) and (math.fmod((cycle - (600 + cadence)), (cadence * 2)) == 0)) then
                                do
                                    local fanCount = (count - 1);
                                    (fireLeftFan)(fanCount, (trunc(44000 / fanCount) * (fanCount - 1)));
                                    firedQuiet = true
                                end
                            end
                        end
                    end;
                    if (((cycle >= 600) and (cycle < 1160)) and (not leftHead)) then
                        do
                            local kCadence = {110, 78, 60, 50, 50};
                            local kCount = {3, 5, 7, 9, 11};
                            local kSpreadStep = {4500, 3300, 2700, 2400, 2000};
                            local kSpeed = {6, 6.5, 7, 7, 8};
                            local cadence = (kCadence)[index + 1];
                            if ((cycle >= 660) and (math.fmod((cycle - 660), cadence) == 0)) then
                                do
                                    (enemy).secondaryAngle16 = ((shotAim)() % 65536)
                                end
                            end;
                            if (cycle >= 660) then
                                do
                                    local v_local = math.fmod((cycle - 660), cadence);
                                    local speed = ((kSpeed)[index + 1] + (v_local * 0.080000000000000002));
                                    local fireRightFan = function(count)
                                        local spread = ((count - 1) * (kSpreadStep)[index + 1]);
                                        ctx:spawnProjectileSpread(9, 0, shotX, shotY, (enemy).secondaryAngle16, f32(10), speed, 1, count, spread, 0);
                                        if (state == 13) then
                                            do
                                                ctx:spawnProjectileSpread(9, 0, shotX, shotY, (enemy).secondaryAngle16, f32(10), (speed - 0.5), 1, count, spread, 0);
                                                ctx:spawnProjectileSpread(9, 0, shotX, shotY, normalizeStage07Angle(((enemy).secondaryAngle16 - 400)), f32(10), (speed - 0.5), 1, count, spread, 0)
                                            end
                                        end
                                    end;
                                    local first = math.fmod((cycle - 660), (cadence * 2));
                                    if ((first < 50) and (math.fmod(first, 5) == 0)) then
                                        do
                                            (fireRightFan)((kCount)[index + 1]);
                                            firedQuiet = true
                                        end
                                    end;
                                    local secondStart = (660 + cadence);
                                    if (cycle >= secondStart) then
                                        do
                                            local second = math.fmod((cycle - secondStart), (cadence * 2));
                                            if ((second < 50) and (math.fmod(second, 5) == 0)) then
                                                do
                                                    (fireRightFan)(((kCount)[index + 1] - 1));
                                                    firedQuiet = true
                                                end
                                            end
                                        end
                                    end
                                end
                            end;
                            (enemy).secondaryAngle16 = (approachStage07Angle((enemy).secondaryAngle16, (shotAim)(), 16) % 65536)
                        end
                    end
                end
            else
                if (state == 21) then
                    do
                        local index = difficulty;
                        if (math.fmod(timer, 860) == 10) then
                            do
                                local secondOrbit = (u32((timer - 100)) < 901);
                                ctx:spawnStage07BossNode(enemy, (function() if secondOrbit then return 144 else return 143 end end)(), trunc(timer / 860), f32(0), f32(0), ((function() if secondOrbit then return 32768 else return 0 end end)() % 65536), 1, 100, 99999999);
                                firedLoud = true
                            end
                        end;
                        local kWindow = {20, 25, 30, 40, 40};
                        local kCount = {15, 19, 23, 25, 27};
                        local kTurn = {320, 420, 460, 480, 500};
                        local kSpeed = {5.5999999999999996, 6.4000000000000004, 7, 7.7000000000000001, 8.5};
                        local cycle = math.fmod(timer, 860);
                        local start = (function() if (cycle >= 760) then return 760 else return 660 end end)();
                        if ((cycle == 660) or (cycle == 760)) then
                            do
                                (enemy).secondaryAngle16 = ((shotAim)() % 65536)
                            end
                        end;
                        if (((cycle >= start) and (cycle < (start + (kWindow)[index + 1]))) and (math.fmod((cycle - start), 5) == 0)) then
                            do
                                ctx:spawnProjectileSpread(3, (function() if (start == 660) then return 33 else return 34 end end)(), shotX, shotY, (enemy).secondaryAngle16, f32(10), (kSpeed)[index + 1], 1, (kCount)[index + 1], 65536, 0);
                                (enemy).secondaryAngle16 = (normalizeStage07Angle(((enemy).secondaryAngle16 + (function() if (start == 660) then return (-(kTurn)[index + 1]) else return (kTurn)[index + 1] end end)())) % 65536);
                                firedQuiet = true
                            end
                        end
                    end
                else
                    if (state == 31) then
                        do
                            if (((timer >= 10) and (timer < 90)) and (math.fmod((timer - 10), 3) == 0)) then
                                do
                                    local random = stage07ScriptRand(timer);
                                    local angle = (((s16(trunc(random / 48001)) * 17535) + s16(random)) + 25152);
                                    ctx:spawnStage07BossNode(enemy, 147, timer, f32((shotX - (enemy).x)), f32((shotY - (enemy).y)), normalizeStage07Angle(angle), 5, 20, 99999999);
                                    firedQuiet = true
                                end
                            end;
                            if (timer > 100) then
                                do
                                    local index = difficulty;
                                    local kPeriod = {240, 180, 160, 160, 150};
                                    local kTopCadence = {9, 6, 5, 5, 5};
                                    local kSideCadence = {11, 8, 7, 7, 7};
                                    local kSpeed = {3, 4, 4, 4, 5};
                                    local elapsed = (timer - 100);
                                    local period = (kPeriod)[index + 1];
                                    local phase = math.fmod(elapsed, (period * 4));
                                    local v_local = math.fmod(elapsed, period);
                                    if ((phase < 60) and (math.fmod(phase, (kTopCadence)[index + 1]) == 0)) then
                                        do
                                            ctx:spawnProjectileNode(19, 35, f32((f32(v_local) * f32(12))), f32(0), normalizeStage07Angle(((16384 - (v_local * 120)) + 3200)), f32(0), (kSpeed)[index + 1], 1, 0);
                                            firedLoud = true
                                        end
                                    end;
                                    if (((phase >= period) and (phase < (period + 60))) and (math.fmod((phase - period), (kTopCadence)[index + 1]) == 0)) then
                                        do
                                            ctx:spawnProjectileNode(19, 35, f32((f32((f32(720) - f32((f32(v_local) * f32(12))))) + f32((f32((kTopCadence)[index + 1]) * f32(6))))), f32(0), normalizeStage07Angle(((v_local * 120) + 13184)), f32(0), (kSpeed)[index + 1], 1, 0);
                                            firedLoud = true
                                        end
                                    end;
                                    if (((phase >= (period * 2)) and (phase < ((period * 2) + 60))) and (math.fmod((phase - (period * 2)), (kSideCadence)[index + 1]) == 0)) then
                                        do
                                            ctx:spawnProjectileNode(19, 36, f32(720), f32((f32(v_local) * f32(12))), normalizeStage07Angle((32768 - ((v_local * 60) - 1000))), f32(0), (kSpeed)[index + 1], 1, 0);
                                            firedLoud = true
                                        end
                                    end;
                                    if (((phase >= (period * 3)) and (phase < ((period * 3) + 60))) and (math.fmod((phase - (period * 3)), (kSideCadence)[index + 1]) == 0)) then
                                        do
                                            ctx:spawnProjectileNode(19, 36, f32(0), f32((f32(v_local) * f32(12))), normalizeStage07Angle(((v_local * 60) - 1000)), f32(0), (kSpeed)[index + 1], 1, 0);
                                            firedLoud = true
                                        end
                                    end
                                end
                            end
                        end
                    else
                        if (state == 41) then
                            do
                                local index = difficulty;
                                if (math.fmod(timer, 860) == 10) then
                                    do
                                        local secondOrbit = (u32((timer - 100)) < 901);
                                        ctx:spawnStage07BossNode(enemy, (function() if secondOrbit then return 146 else return 145 end end)(), trunc(timer / 860), f32(0), f32(0), ((function() if secondOrbit then return 0 else return 32768 end end)() % 65536), 1, 100, 99999999);
                                        firedLoud = true
                                    end
                                end;
                                local kInterval = {4, 3, 2, 2, 2};
                                local kCount = {5, 6, 6, 7, 8};
                                local kTurn = {3500, 4300, 3200, 3900, 3200};
                                local kSpeed = {5, 6, 6.5, 7, 8};
                                local cycle = math.fmod(timer, 860);
                                local start = (function() if (cycle >= 760) then return 760 else return 660 end end)();
                                if ((cycle == 660) or (cycle == 760)) then
                                    do
                                        (enemy).secondaryAngle16 = ((shotAim)() % 65536)
                                    end
                                end;
                                if (((cycle >= start) and (cycle < (start + 40))) and (math.fmod((cycle - start), (kInterval)[index + 1]) == 0)) then
                                    do
                                        ctx:spawnProjectileSpread(3, (function() if (start == 660) then return 34 else return 33 end end)(), shotX, shotY, (enemy).secondaryAngle16, f32(10), (kSpeed)[index + 1], 1, (kCount)[index + 1], 65536, 0);
                                        (enemy).secondaryAngle16 = (normalizeStage07Angle(((enemy).secondaryAngle16 + (function() if (start == 660) then return (-(kTurn)[index + 1]) else return (kTurn)[index + 1] end end)())) % 65536);
                                        firedQuiet = true
                                    end
                                end
                            end
                        else
                            if (state == 51) then
                                do
                                    local index = difficulty;
                                    local kSegment = {120, 90, 70, 70, 70};
                                    local kRest = {800, 800, 660, 660, 580};
                                    local kPathCadence = {11, 7, 6, 5, 4};
                                    local segment = (kSegment)[index + 1];
                                    local cycle = math.fmod((timer - 10), ((kRest)[index + 1] + (segment * 5)));
                                    local kStart = {{f32(30), f32(0)}, {f32(0), f32(0)}, {f32(690), f32(0)}, {f32(720), f32(0)}, {f32(30), f32(720)}};
                                    local kEnd = {{f32(690), f32(0)}, {f32(0), f32(720)}, {f32(30), f32(0)}, {f32(720), f32(720)}, {f32(690), f32(720)}};
                                    local aimPoint = function(x, y)
                                        x = f32(x);
                                        y = f32(y);
                                        do return stage07RadiansToAngle(math.atan2(f32((y - shotY)), f32((x - shotX)))) end
                                    end;
                                    if ((cycle >= 0) and (cycle < (segment * 5))) then
                                        do
                                            local path = trunc(cycle / segment);
                                            local v_local = math.fmod(cycle, segment);
                                            if (v_local == 0) then
                                                do
                                                    (enemy).secondaryAngle16 = ((aimPoint)(((kStart)[path + 1])[0 + 1], ((kStart)[path + 1])[1 + 1]) % 65536);
                                                    (enemy).targetAngle16 = ((aimPoint)(((kEnd)[path + 1])[0 + 1], ((kEnd)[path + 1])[1 + 1]) % 65536)
                                                end
                                            end;
                                            if ((v_local < 40) and (math.fmod(v_local, (kPathCadence)[index + 1]) == 0)) then
                                                do
                                                    local delta = ((enemy).targetAngle16 - (enemy).secondaryAngle16);
                                                    if (delta > 32768) then
                                                        delta = (delta - 65536)
                                                    end;
                                                    if (delta < (-32768)) then
                                                        delta = (delta + 65536)
                                                    end;
                                                    local angle = normalizeStage07Angle(((enemy).secondaryAngle16 + (trunc(delta / 40) * v_local)));
                                                    ctx:spawnStage07BossNode(enemy, 148, timer, f32((shotX - (enemy).x)), f32((shotY - (enemy).y)), angle, 6, 20, 99999999);
                                                    firedLoud = true
                                                end
                                            end
                                        end
                                    end;
                                    local kCornerPeriod = {250, 250, 200, 200, 180};
                                    local kCornerCadence = {17, 9, 5, 4, 3};
                                    local kCornerWindow = {160, 160, 120, 120, 120};
                                    local cornerStart = ((segment * 5) + 30);
                                    local period = (kCornerPeriod)[index + 1];
                                    if ((cycle >= cornerStart) and (cycle < (cornerStart + (period * 3)))) then
                                        do
                                            local elapsed = (cycle - cornerStart);
                                            local pairPhase = math.fmod(elapsed, (period * 2));
                                            if (pairPhase == 0) then
                                                do
                                                    (enemy).secondaryAngle16 = ((aimPoint)(f32(0), f32(0)) % 65536)
                                                end
                                            else
                                                if (pairPhase == period) then
                                                    do
                                                        (enemy).secondaryAngle16 = ((aimPoint)(f32(720), f32(0)) % 65536)
                                                    end
                                                end
                                            end;
                                            local v_local = math.fmod(elapsed, period);
                                            if ((v_local < (kCornerWindow)[index + 1]) and (math.fmod(v_local, (kCornerCadence)[index + 1]) == 0)) then
                                                do
                                                    local sweep = (v_local * trunc(65536 / (kCornerWindow)[index + 1]));
                                                    if (pairPhase >= period) then
                                                        sweep = (-sweep)
                                                    end;
                                                    ctx:spawnStage07BossNode(enemy, 148, timer, f32((shotX - (enemy).x)), f32((shotY - (enemy).y)), normalizeStage07Angle(((enemy).secondaryAngle16 + sweep)), 6, 20, 99999999);
                                                    firedLoud = true
                                                end
                                            end
                                        end
                                    end
                                end
                            else
                                if (state == 61) then
                                    do
                                        local index = difficulty;
                                        if (timer < 480) then
                                            do
                                                local kBaseCount = {11, 17, 19, 21, 23};
                                                local kTurn = {300, 360, 450, (-550), (-640)};
                                                local kSpeed = {6, 7, 7, 7, 7};
                                                local count = ((kBaseCount)[index + 1] + (trunc((timer - 80) / 100) * 2));
                                                local start = (function() if leftHead then return 80 else return 180 end end)();
                                                if ((timer >= start) and (math.fmod((timer - start), 200) == 0)) then
                                                    do
                                                        (enemy).secondaryAngle16 = (normalizeStage07Angle(((shotAim)() + trunc(65536 / (count * 2)))) % 65536)
                                                    end
                                                end;
                                                if (timer >= start) then
                                                    do
                                                        local phase = math.fmod((timer - start), 200);
                                                        if ((phase < 80) and (math.fmod(phase, 4) == 0)) then
                                                            do
                                                                ctx:spawnProjectileSpread((function() if leftHead then return 12 else return 13 end end)(), 1, shotX, shotY, (enemy).secondaryAngle16, f32(10), (kSpeed)[index + 1], 1, count, 65536, 0);
                                                                local v_local = math.fmod((timer - start), 100);
                                                                local firstPair = (timer < (start + 200));
                                                                local narrowHalf = (v_local < 40);
                                                                local turn = (kTurn)[index + 1];
                                                                if leftHead then
                                                                    do
                                                                        turn = (function() if ((firstPair and 1 or 0) == (narrowHalf and 1 or 0)) then return trunc(turn / 3) else return (-turn) end end)()
                                                                    end
                                                                else
                                                                    do
                                                                        turn = (function() if ((firstPair and 1 or 0) == (narrowHalf and 1 or 0)) then return (-trunc(turn / 3)) else return turn end end)()
                                                                    end
                                                                end;
                                                                (enemy).secondaryAngle16 = (normalizeStage07Angle(((enemy).secondaryAngle16 + turn)) % 65536);
                                                                firedLoud = true
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        else
                                            do
                                                local kInterval = {70, 50, 40, 30, 24};
                                                local kFirstCount = {13, 13, 13, 11, 13};
                                                local kSecondCount = {13, 15, 15, 15, 17};
                                                local kTurn = {20, 30, 40, 40, 40};
                                                local kFirstSpeed = {2.2000000000000002, 2.6000000000000001, 3, 3, 4};
                                                local kSecondSpeed = {2.2000000000000002, 2.7000000000000002, 3.2000000000000002, 3.6000000000000001, 4.5999999999999996};
                                                local interval = (kInterval)[index + 1];
                                                local start = (480 + (function() if leftHead then return 0 else return interval end end)());
                                                if ((timer >= start) and (math.fmod((timer - start), (interval * 2)) == 0)) then
                                                    do
                                                        ctx:spawnProjectileSpread((function() if leftHead then return 19 else return 20 end end)(), 38, shotX, shotY, normalizeStage07Angle((timer * (kTurn)[index + 1])), f32(0), (kFirstSpeed)[index + 1], 1, (kFirstCount)[index + 1], 65536, 0);
                                                        local aim = (shotAim)();
                                                        if (not leftHead) then
                                                            do
                                                                aim = (normalizeStage07Angle((aim + trunc(65536 / ((kSecondCount)[index + 1] * 2)))) % 65536)
                                                            end
                                                        end;
                                                        ctx:spawnProjectileSpread((function() if leftHead then return 2 else return 3 end end)(), 0, shotX, shotY, aim, f32(10), (kSecondSpeed)[index + 1], 1, (kSecondCount)[index + 1], 65536, 0);
                                                        firedLoud = true
                                                    end
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
            if firedQuiet then
                ctx:playPlayerSound((ctx).bullet2SoundHandle_, 12)
            end;
            if firedLoud then
                (fireSound)()
            end;
            do return end
        end
    end;
    if isStage07FirstFormPart((enemy).spawnType) then
        do
            local timer = (root).helperTimer;
            (enemy).markerDrawTimer = (function() if ((root).helperState == 1) then return timer else return (-1) end end)();
            local delayedDamagePart = (((enemy).spawnType == 135) or ((enemy).spawnType == 136));
            local immediateDetach = ((((enemy).spawnType == 137) or ((enemy).spawnType == 138)) and ((root).helperState > 9));
            if ((immediateDetach or ((root).helperState > 10)) or (((root).helperState == 10) and (timer >= 100))) then
                do
                    (enemy).targetable = false;
                    if immediateDetach then
                        ctx:spawnEnemyDeathEffects(enemy, 1, false)
                    end;
                    (enemy).active = false;
                    do return end
                end
            end;
            if (((not delayedDamagePart) and ((root).helperState == 1)) and (timer <= 1)) then
                do
                    (enemy).hp = (root).hp;
                    (enemy).maxHp = (root).maxHp;
                    (enemy).sourceHitPoints = (enemy).hp
                end
            end;
            if (((not delayedDamagePart) and ((root).helperState == 1)) and (timer > 1)) then
                do
                    local damage = math.max(0, ((enemy).sourceHitPoints - (enemy).hp));
                    if (damage > 0) then
                        (root).hp = math.max(0, ((root).hp - damage))
                    end;
                    (enemy).hp = math.min((enemy).hp, (root).hp);
                    (enemy).sourceHitPoints = (enemy).hp
                end
            end;
            (enemy).targetable = ((((root).helperState == 1) and ((enemy).helperState == 0)) and ((enemy).hp > 0));
            (enemy).x = f32(f32(((root).x + (enemy).originX)));
            (enemy).y = f32(f32(((root).y + (enemy).originY)));
            if ((delayedDamagePart and ((enemy).helperState == 0)) and ((enemy).hp < 1)) then
                do
                    ctx:spawnEnemyDeathRewardBurst(enemy, 3900, false);
                    ctx:spawnEnemyDeathEffects(enemy, (function() if ((enemy).spawnType == 135) then return 2 else return 1 end end)(), true);
                    ctx:spawnDelayedOwnerDamageNode((enemy).maxHp, (root).entityId, (root).spawnType, (function() if ((enemy).spawnType == 135) then return "S07 type 0x87 delayed-damage node 0x153" else return "S07 type 0x88 delayed-damage node 0x153" end end)());
                    (enemy).targetable = false;
                    (enemy).helperState = 1;
                    (enemy).helperTimer = 0;
                    do return end
                end
            end;
            if (delayedDamagePart and ((enemy).helperState ~= 0)) then
                do return end
            end;
            if (((root).helperState ~= 1) or ((enemy).hp < 1)) then
                do return end
            end;
            local cycle = math.fmod(timer, 2600);
            local fired = false;
            if (((enemy).spawnType == 133) or ((enemy).spawnType == 134)) then
                do
                    local right = ((enemy).spawnType == 134);
                    local start = (function() if right then return 480 else return 60 end end)();
                    local kLeftInterval = {20, 16, 14, 12, 12};
                    local kRightInterval = {18, 14, 12, 9, 9};
                    local interval = ((function() if right then return kRightInterval else return kLeftInterval end end)())[difficulty + 1];
                    if (((cycle >= start) and (cycle < (start + 120))) and (math.fmod((cycle - start), interval) == 0)) then
                        do
                            local angle = normalizeStage07Angle(math.fmod(stage07ScriptRand(timer), 32769));
                            ctx:spawnStage07BossNode(enemy, (function() if right then return 140 else return 139 end end)(), timer, f32(0), f32(38), angle, stage07RandomRange(timer, 4, (function() if right then return 12 else return 7 end end)()), 20, 900);
                            fired = true
                        end
                    end;
                    local heavyStart = (function() if right then return 2120 else return 1970 end end)();
                    if (((cycle >= heavyStart) and (cycle < 2500)) and (math.fmod((cycle - heavyStart), 300) == 0)) then
                        do
                            ctx:spawnStage07BossNode(enemy, (function() if right then return 142 else return 141 end end)(), timer, f32(0), f32(38), (aimAtPlayer)((enemy).x, f32(((enemy).y + f32(38)))), 5, 20, 3600);
                            fired = true
                        end
                    end
                end
            else
                if ((enemy).spawnType == 135) then
                    do
                        local positiveSide = ((enemy).originX >= f32(0));
                        local shotX = f32(((enemy).x + (function() if positiveSide then return f32((-f32(10))) else return f32(10) end end)()));
                        local shotY = f32(((enemy).y + f32(45)));
                        local opening = (function() if (timer >= 20) then return math.fmod((timer - 20), 82) else return (-1) end end)();
                        if (((opening >= 0) and (opening < 30)) and (math.fmod(opening, 5) == 0)) then
                            do
                                local kSpeed = {5, 6, 7, 8, 9.5};
                                do
                                    local i = 0
                                    while (i < 3) do
                                        do
                                            local angle = (function() if positiveSide then return ((i * 14000) - 14000) else return ((i * 14000) + 18768) end end)();
                                            ctx:spawnProjectileNode(2, 0, shotX, shotY, normalizeStage07Angle(angle), f32(10), (kSpeed)[difficulty + 1], 1, 0)
                                        end
                                        ::__continue35::
                                        i = i + 1
                                    end
                                    ::__loop_end34::
                                end;
                                fired = true
                            end
                        end;
                        local sweepStart = (function() if positiveSide then return 750 else return 330 end end)();
                        local kSweepCadence = {6, 5, 4, 4, 4};
                        local kSweepCount = {5, 7, 9, 11, 11};
                        local kSweepSpeed = {3.2000000000000002, 3.6000000000000001, 4, 4, 5.5};
                        if (cycle == sweepStart) then
                            do
                                (enemy).secondaryAngle16 = (((function() if positiveSide then return 40960 else return 57344 end end)() % 65536) % 65536)
                            end
                        end;
                        if ((cycle >= sweepStart) and (cycle < (sweepStart + 150))) then
                            do
                                local v_local = (cycle - sweepStart);
                                if (math.fmod(v_local, (kSweepCadence)[difficulty + 1]) == 0) then
                                    do
                                        local count = (kSweepCount)[difficulty + 1];
                                        ctx:spawnProjectileSpread((function() if positiveSide then return 3 else return 3 end end)(), 0, shotX, shotY, (enemy).secondaryAngle16, f32(10), ((kSweepSpeed)[difficulty + 1] + (v_local * 0.0050000000000000001)), 1, count, 65536, 0);
                                        fired = true
                                    end
                                end;
                                (enemy).secondaryAngle16 = (normalizeStage07Angle(((enemy).secondaryAngle16 + (function() if positiveSide then return (-900) else return 900 end end)())) % 65536)
                            end
                        end;
                        local kRingCadence = {19, 13, 11, 11, 10};
                        local kRingCount = {3, 4, 5, 5, 6};
                        local kRingSpeed = {3.5, 4, 4.5, 4.5, 5.5};
                        if (cycle == 1050) then
                            (enemy).secondaryAngle16 = ((49152 % 65536) % 65536)
                        end;
                        if ((cycle >= 990) and (cycle < 1560)) then
                            do
                                if ((cycle >= 1050) and (math.fmod((cycle - 1050), (kRingCadence)[difficulty + 1]) == 0)) then
                                    do
                                        ctx:spawnProjectileSpread(5, 0, shotX, shotY, (enemy).secondaryAngle16, f32(0), (kRingSpeed)[difficulty + 1], 1, (kRingCount)[difficulty + 1], 65536, 0);
                                        fired = true
                                    end
                                end;
                                (enemy).secondaryAngle16 = (normalizeStage07Angle(((enemy).secondaryAngle16 + (function() if positiveSide then return (-160) else return 160 end end)())) % 65536)
                            end
                        end;
                        local aimedStart = (function() if positiveSide then return 1790 else return 1650 end end)();
                        local kAimedCadence = {40, 30, 24, 20, 24};
                        local kAimedCount = {7, 9, 9, 9, 11};
                        local kAimedSpeed = {5.5, 6.5, 7, 7.5, 8.5};
                        if (cycle == aimedStart) then
                            do
                                (enemy).secondaryAngle16 = ((aimAtPlayer)(shotX, shotY) % 65536)
                            end
                        end;
                        if ((cycle >= aimedStart) and (cycle < (aimedStart + 120))) then
                            do
                                local cadence = (kAimedCadence)[difficulty + 1];
                                local v_local = (cycle - aimedStart);
                                if ((math.fmod(v_local, cadence) == 0) or (math.fmod(v_local, cadence) == trunc(cadence / 2))) then
                                    do
                                        local count = (kAimedCount)[difficulty + 1];
                                        local angleOffset = (function() if (math.fmod(v_local, cadence) == 0) then return 0 else return 5500 end end)();
                                        ctx:spawnProjectileSpread(3, 0, shotX, shotY, normalizeStage07Angle(((enemy).secondaryAngle16 + (function() if positiveSide then return angleOffset else return (-angleOffset) end end)())), f32(0), (kAimedSpeed)[difficulty + 1], 1, count, ((count * 660) - 660), 0);
                                        fired = true
                                    end
                                end
                            end
                        end
                    end
                else
                    if ((enemy).spawnType == 136) then
                        do
                            local kCadence = {164, 123, 81, 81, 81};
                            local kSpeed = {4.5, 5, 5.5, 6, 7};
                            if (timer > 40) then
                                do
                                    local v_local = math.fmod((timer - 41), (kCadence)[difficulty + 1]);
                                    if (v_local == 0) then
                                        do
                                            (enemy).secondaryAngle16 = (normalizeStage07Angle(((aimAtPlayer)((enemy).x, (enemy).y) + 1024)) % 65536)
                                        end
                                    end;
                                    if ((v_local < 9) and (math.fmod(v_local, 3) == 0)) then
                                        do
                                            local angle = normalizeStage07Angle(bit.band((enemy).secondaryAngle16, 63488));
                                            ctx:spawnProjectileNode(15, 0, (enemy).x, (enemy).y, angle, f32(0), (kSpeed)[difficulty + 1], 1, 0);
                                            if (difficulty > 2) then
                                                do
                                                    ctx:spawnProjectileNode(15, 0, (enemy).x, (enemy).y, angle, f32(0), ((kSpeed)[difficulty + 1] + 1.2), 1, 0)
                                                end
                                            end;
                                            fired = true
                                        end
                                    end
                                end
                            end
                        end
                    else
                        do
                            local baseX = (enemy).x;
                            local baseY = (enemy).y;
                            local leftCannon = ((enemy).spawnType == 137);
                            local target = (aimAtPlayer)(baseX, baseY);
                            if ((cycle < 960) or (cycle >= 1600)) then
                                do
                                    target = (stage07RadiansToAngle(math.atan2(f32((f32(((root).y + f32(60))) - baseY)), f32((f32(((root).x + (function() if leftCannon then return f32((-f32(80))) else return f32(80) end end)())) - baseX)))) % 65536)
                                end
                            end;
                            local delta = (target - (enemy).sourceAngle16);
                            if (delta > 32768) then
                                delta = (delta - 65536)
                            end;
                            if (delta < (-32768)) then
                                delta = (delta + 65536)
                            end;
                            (enemy).sourceAngle16 = (approachStage07Angle((enemy).sourceAngle16, target, (48 + trunc(math.abs(delta) / 10))) % 65536);
                            (enemy).x = f32(f32((baseX + stage07PolarX((enemy).sourceAngle16, 20))));
                            (enemy).y = f32(f32((baseY + stage07PolarY((enemy).sourceAngle16, 20))));
                            local kCadence = {45, 36, 30, 24, 20};
                            local kSpeed = {5.5, 6.5, 7, 8, 9};
                            if ((cycle >= 980) and (cycle < 1600)) then
                                do
                                    local v_local = math.fmod((cycle - 980), (kCadence)[difficulty + 1]);
                                    if ((v_local < 9) and (math.fmod(v_local, 3) == 0)) then
                                        do
                                            local muzzleX = f32((baseX + stage07PolarX((enemy).sourceAngle16, 50)));
                                            local muzzleY = f32((baseY + stage07PolarY((enemy).sourceAngle16, 50)));
                                            ctx:spawnProjectileNode(6, 0, muzzleX, muzzleY, (enemy).sourceAngle16, f32(10), (kSpeed)[difficulty + 1], 1, 0);
                                            fired = true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end;
            if fired then
                (fireSound)()
            end;
            do return end
        end
    end;
    if (((enemy).spawnType >= 139) and ((enemy).spawnType <= 142)) then
        do
            local timer = (enemy).helperTimer;
            if ((enemy).helperState == 0) then
                do
                    (enemy).targetable = false;
                    local entrySpeed = ((enemy).sourceSpeed * (1 - (cpp.clamp(timer, 0, 40) / 40)));
                    (enemy).x = f32(f32(((enemy).x + stage07PolarX((enemy).sourceAngle16, entrySpeed))));
                    (enemy).y = f32(f32(((enemy).y + stage07PolarY((enemy).sourceAngle16, entrySpeed))));
                    if (timer == 0) then
                        (enemy).secondaryAngle16 = ((16384 % 65536) % 65536)
                    end;
                    if (timer == 40) then
                        do
                            local aimed = (aimAtPlayer)((enemy).x, (enemy).y);
                            if ((enemy).spawnType == 139) then
                                do
                                    (enemy).sourceSpeed = 1.2;
                                    (enemy).sourceAngle16 = (normalizeStage07Angle(((aimed + math.fmod(stage07ScriptRand((ctx).frame_), 4445)) - 2222)) % 65536)
                                end
                            else
                                if ((enemy).spawnType == 140) then
                                    do
                                        (enemy).sourceSpeed = 0;
                                        (enemy).sourceAngle16 = ((16384 % 65536) % 65536);
                                        (enemy).secondaryAngle16 = ((aimAtPlayer)((enemy).markerDrawX, (enemy).markerDrawY) % 65536)
                                    end
                                else
                                    do
                                        (enemy).sourceSpeed = 1;
                                        (enemy).sourceAngle16 = (aimed % 65536);
                                        (enemy).secondaryAngle16 = (aimed % 65536)
                                    end
                                end
                            end;
                            (enemy).helperState = 1;
                            (enemy).helperTimer = 0;
                            (enemy).targetable = ((enemy).hp > 0)
                        end
                    end;
                    do return end
                end
            end;
            (enemy).targetable = ((enemy).hp > 0);
            local muzzleX = f32(((enemy).x + stage07PolarX((enemy).sourceAngle16, 14)));
            local muzzleY = f32(((enemy).y + stage07PolarY((enemy).sourceAngle16, 14)));
            local fired = false;
            if ((enemy).spawnType == 139) then
                do
                    local kCadence = {120, 60, 45, 45, 40};
                    local kSpeed = {3.7999999999999998, 4.5, 5, 5, 6};
                    local horizontalOrigin = f32((((ctx).player_).x / f32(6)));
                    local inFireArea = ((((muzzleX >= f32((horizontalOrigin + f32(40)))) and (muzzleX <= f32((horizontalOrigin + f32(560))))) and (muzzleY >= f32(40))) and (muzzleY <= f32(680)));
                    if ((((timer < 150) and (math.fmod(timer, (kCadence)[difficulty + 1]) == 0)) and inFireArea) and (stage07Distance(muzzleX, muzzleY, ((ctx).player_).x, ((ctx).player_).y) > 50)) then
                        do
                            local aimed = (aimAtPlayer)(muzzleX, muzzleY);
                            local jitter = (math.fmod(stage07ScriptRand(((root).helperTimer + timer)), 24001) - 12700);
                            do
                                local i = 0
                                while (i < 3) do
                                    do
                                        ctx:spawnProjectileNode(4, 0, muzzleX, muzzleY, normalizeStage07Angle(((aimed + jitter) + (i * 700))), f32(0), (kSpeed)[difficulty + 1], 1, 0)
                                    end
                                    ::__continue37::
                                    i = i + 1
                                end
                                ::__loop_end36::
                            end;
                            if (difficulty > 2) then
                                do
                                    local extraJitter = (math.fmod(stage07ScriptRand((((root).helperTimer + timer) + 1)), 24001) - 13400);
                                    do
                                        local i = 0
                                        while (i < 2) do
                                            do
                                                ctx:spawnProjectileNode(4, 0, muzzleX, muzzleY, normalizeStage07Angle(((aimed + extraJitter) + (i * 2800))), f32(0), (kSpeed)[difficulty + 1], 1, 0)
                                            end
                                            ::__continue39::
                                            i = i + 1
                                        end
                                        ::__loop_end38::
                                    end
                                end
                            end;
                            fired = true
                        end
                    end
                end
            else
                if ((enemy).spawnType == 140) then
                    do
                        local delta = ((aimAtPlayer)((enemy).x, (enemy).y) - (enemy).sourceAngle16);
                        if (delta > 32768) then
                            delta = (delta - 65536)
                        end;
                        if (delta < (-32768)) then
                            delta = (delta + 65536)
                        end;
                        (enemy).sourceAngle16 = (approachStage07Angle((enemy).sourceAngle16, (enemy).secondaryAngle16, (48 + trunc(math.abs(delta) / 10))) % 65536);
                        if (timer > 29) then
                            do
                                local kAcceleration = {0.059999999999999998, 0.080000000000000002, 0.10000000000000001, 0.12, 0.14999999999999999};
                                (enemy).sourceSpeed = ((enemy).sourceSpeed + (kAcceleration)[difficulty + 1]);
                                local horizontalOrigin = f32((((ctx).player_).x / f32(6)));
                                if (((((bit.band(timer, 1) == 0) and ((enemy).x >= horizontalOrigin)) and ((enemy).x <= f32((horizontalOrigin + f32(600))))) and ((enemy).y >= f32(0))) and ((enemy).y <= f32(720))) then
                                    do
                                        local shotX = f32(((enemy).x + stage07PolarX((enemy).sourceAngle16, 14)));
                                        local shotY = f32(((enemy).y + stage07PolarY((enemy).sourceAngle16, 14)));
                                        ctx:spawnProjectileNode(4, 3, shotX, shotY, (enemy).sourceAngle16, f32(0), 12, 1, 0);
                                        fired = true
                                    end
                                end
                            end
                        end
                    end
                else
                    do
                        local kTurnPeriod = {100, 100, 75, 75, 65};
                        local kTurnAmplitude = {4000, 4500, 4500, 5000, 5000};
                        local kRingCount = {6, 8, 9, 11, 13};
                        local kRingSpeed = {4.5, 5, 5.5, 6, 7};
                        local kSecondaryCadence = {80, 60, 50, 40, 32};
                        local kSecondaryCount = {13, 17, 23, 27, 31};
                        local kSecondarySpeed = {3, 3.5, 4, 4, 5};
                        local period = (kTurnPeriod)[difficulty + 1];
                        local phase = math.fmod(timer, period);
                        local half = trunc(period / 2);
                        local triangle = (function() if (phase < half) then return phase else return (period - phase) end end)();
                        local signedTurn = trunc((triangle * (kTurnAmplitude)[difficulty + 1]) / math.max(1, half));
                        local ringAngle = normalizeStage07Angle(((enemy).secondaryAngle16 + (function() if ((enemy).spawnType == 141) then return signedTurn else return (-signedTurn) end end)()));
                        local horizontalOrigin = f32((((ctx).player_).x / f32(6)));
                        local inFireArea = (((((muzzleX >= f32((horizontalOrigin + f32(40)))) and (muzzleX <= f32((horizontalOrigin + f32(560))))) and (muzzleY >= f32(40))) and (muzzleY <= f32(680))) and (stage07Distance(muzzleX, muzzleY, ((ctx).player_).x, ((ctx).player_).y) > 50));
                        if (((timer < 150) and inFireArea) and (math.fmod(timer, 3) == 0)) then
                            do
                                ctx:spawnProjectileSpread(9, 0, muzzleX, muzzleY, ringAngle, f32(10), ((kRingSpeed)[difficulty + 1] + (timer * 0.040000000000000001)), 1, (kRingCount)[difficulty + 1], 65536, 0);
                                fired = true
                            end
                        end;
                        if (((timer < 150) and inFireArea) and (math.fmod(timer, (kSecondaryCadence)[difficulty + 1]) == 0)) then
                            do
                                ctx:spawnProjectileSpread(4, 0, muzzleX, muzzleY, (aimAtPlayer)(muzzleX, muzzleY), f32(0), (kSecondarySpeed)[difficulty + 1], 1, (kSecondaryCount)[difficulty + 1], 65536, 0);
                                fired = true
                            end
                        end
                    end
                end
            end;
            if ((enemy).spawnType ~= 140) then
                do
                    (enemy).x = f32(f32(((enemy).x + stage07PolarX((enemy).sourceAngle16, (enemy).sourceSpeed))));
                    (enemy).y = f32(f32(((enemy).y + stage07PolarY((enemy).sourceAngle16, (enemy).sourceSpeed))));
                    if (timer > 179) then
                        (enemy).sourceSpeed = ((enemy).sourceSpeed + 0.10000000000000001)
                    end
                end
            else
                do
                    (enemy).x = f32(f32(((enemy).x + stage07PolarX((enemy).sourceAngle16, (enemy).sourceSpeed))));
                    (enemy).y = f32(f32(((enemy).y + stage07PolarY((enemy).sourceAngle16, (enemy).sourceSpeed))))
                end
            end;
            if fired then
                (fireSound)()
            end;
            if ((enemy).hp < 1) then
                do
                    local transferDamage = (((ctx).player_).invulnerableFrames == 0);
                    ctx:spawnEnemyDeathRewardBurst(enemy, 300, false);
                    ctx:spawnEnemyDeathEffects(enemy, 0, true);
                    if transferDamage then
                        do
                            ctx:spawnDelayedOwnerDamageNode((enemy).maxHp, (root).entityId, (root).spawnType, "S07 type 0x8b..0x8e delayed-damage node 0x153")
                        end
                    end;
                    (enemy).targetable = false;
                    (enemy).active = false;
                    do return end
                end
            end;
            if (((root).hp < 1) or ((ctx).lateStageBossCountdown_ < 1)) then
                do
                    ctx:spawnEnemyDeathEffects(enemy, 0, true);
                    (enemy).targetable = false;
                    (enemy).active = false;
                    do return end
                end
            end;
            local horizontalOrigin = f32((((ctx).player_).x / f32(6)));
            if (((((enemy).x < f32((horizontalOrigin - f32(100)))) or ((enemy).x > f32((horizontalOrigin + f32(700))))) or ((enemy).y < f32((-f32(100))))) or ((enemy).y > f32(820))) then
                do
                    (enemy).targetable = false;
                    (enemy).active = false
                end
            end;
            do return end
        end
    end;
    if (((enemy).spawnType >= 143) and ((enemy).spawnType <= 146)) then
        do
            if ((parent == nil) or (not isStage07HeadType((parent).spawnType))) then
                do
                    (enemy).active = false;
                    do return end
                end
            end;
            (enemy).targetable = false;
            local timer = (enemy).helperTimer;
            local centerPhase = ((((ctx).frame_ * 399.60975609756099) * kPi) / 32768);
            local centerSwing = ((function() if ((parent).spawnType == 131) then return 1200 else return (-1200) end end)() * math.sin(centerPhase));
            local centerAngle = normalizeStage07Angle((16384 + trunc(centerSwing)));
            local centerX = f32(((parent).x + stage07PolarX(centerAngle, 24)));
            local centerY = f32((f32(((parent).y - f32(120))) + stage07PolarY(centerAngle, 24)));
            local verticalRadius = f32(0);
            local horizontalRadius = f32(0);
            if (timer >= 540) then
                do
                    verticalRadius = f32(f32(50));
                    horizontalRadius = f32(f32(200))
                end
            else
                if (timer >= 0) then
                    do
                        local radiusPhase = (((timer * 30.340740740740738) * kPi) / 32768);
                        local radiusScale = math.sin(radiusPhase);
                        verticalRadius = f32(f32(trunc((radiusScale * 50))));
                        horizontalRadius = f32(f32(trunc((radiusScale * 200))))
                    end
                end
            end;
            local tiltPhase = ((((timer - 270) * 60.681481481481477) * kPi) / 32768);
            local tiltAmplitude = (function() if (((enemy).spawnType == 143) or ((enemy).spawnType == 146)) then return (-4000) else return 4000 end end)();
            local tiltAngle = normalizeStage07Angle(trunc((math.sin(tiltPhase) * tiltAmplitude)));
            local tiltRadians = stage07AngleRadians(tiltAngle);
            local orbitRadians = stage07AngleRadians((enemy).sourceAngle16);
            local tiltCos = math.cos(tiltRadians);
            local tiltSin = math.sin(tiltRadians);
            local orbitCos = math.cos(orbitRadians);
            local orbitSin = math.sin(orbitRadians);
            (enemy).x = f32(f32((centerX + f32((((tiltCos * orbitCos) * horizontalRadius) - ((tiltSin * orbitSin) * verticalRadius))))));
            (enemy).y = f32(f32((centerY + f32((((tiltCos * orbitSin) * verticalRadius) + ((tiltSin * orbitCos) * horizontalRadius))))));
            local spin = (function() if (((enemy).spawnType == 143) or ((enemy).spawnType == 146)) then return (-485) else return 485 end end)();
            (enemy).sourceAngle16 = (normalizeStage07Angle(((enemy).sourceAngle16 + spin)) % 65536);
            local fired = false;
            if ((enemy).spawnType <= 144) then
                do
                    local kCadence = {11, 8, 7, 8, 7};
                    local kCount = {3, 5, 7, 7, 8};
                    local kSpeed = {3.5, 4.5, 5, 4.5, 6};
                    if ((timer > 9) and (math.fmod((timer - 10), (kCadence)[difficulty + 1]) == 0)) then
                        do
                            local speed = ((kSpeed)[difficulty + 1] + (timer * 0.0030000000000000001));
                            local angle = normalizeStage07Angle((timer * (-280)));
                            ctx:spawnProjectileSpread(4, 0, (enemy).x, (enemy).y, angle, f32(0), speed, 1, (kCount)[difficulty + 1], (((kCount)[difficulty + 1] * 3000) - 3000), 0);
                            ctx:spawnProjectileSpread(4, 0, (enemy).x, (enemy).y, normalizeStage07Angle((angle - 32768)), f32(0), speed, 1, (kCount)[difficulty + 1], (((kCount)[difficulty + 1] * 3000) - 3000), 0);
                            if (difficulty > 2) then
                                do
                                    do
                                        local i = 0
                                        while (i < 4) do
                                            do
                                                ctx:spawnProjectileNode(5, 0, (enemy).x, (enemy).y, normalizeStage07Angle((((i * 3000) + (timer * 300)) - 4500)), f32(0), (speed + 1), 1, 0);
                                                ctx:spawnProjectileNode(5, 0, (enemy).x, (enemy).y, normalizeStage07Angle((((i * 3000) + (timer * 300)) + 28268)), f32(0), (speed + 1), 1, 0)
                                            end
                                            ::__continue41::
                                            i = i + 1
                                        end
                                        ::__loop_end40::
                                    end
                                end
                            end;
                            fired = true
                        end
                    end
                end
            else
                do
                    local kPeriod = {50, 39, 39, 50, 50};
                    local kWindow = {12, 21, 27, 36, 36};
                    local kBaseCount = {10, 14, 16, 18, 20};
                    local kSpeed = {4, 4.5, 5.2000000000000002, 6, 7};
                    local kRingCadence = {90, 60, 48, 36, 26};
                    local kRingCount = {20, 32, 36, 40, 44};
                    local index = difficulty;
                    local period = (kPeriod)[index + 1];
                    if ((timer >= 10) and (math.fmod((timer - 10), period) == 0)) then
                        do
                            (enemy).secondaryAngle16 = ((aimAtPlayer)((enemy).x, (enemy).y) % 65536)
                        end
                    end;
                    local count = ((kBaseCount)[index + 1] + trunc(math.max(0, (timer - 10)) / (period * 2)));
                    local speed = ((kSpeed)[index + 1] + (timer * 0.0040000000000000001));
                    local firstPhase = (function() if (timer >= 10) then return math.fmod((timer - 10), (period * 2)) else return (period * 2) end end)();
                    if ((firstPhase < (kWindow)[index + 1]) and (math.fmod(firstPhase, 3) == 0)) then
                        do
                            ctx:spawnProjectileSpread(11, 0, (enemy).x, (enemy).y, (enemy).secondaryAngle16, f32(10), speed, 1, count, 65536, 0);
                            fired = true
                        end
                    end;
                    local secondStart = (period + 10);
                    local secondPhase = (function() if (timer >= secondStart) then return math.fmod((timer - secondStart), (period * 2)) else return (period * 2) end end)();
                    if ((secondPhase < (kWindow)[index + 1]) and (math.fmod(secondPhase, 3) == 0)) then
                        do
                            ctx:spawnProjectileSpread(11, 0, (enemy).x, (enemy).y, normalizeStage07Angle(((enemy).secondaryAngle16 + trunc(65536 / (count * 2)))), f32(10), speed, 1, count, 65536, 0);
                            fired = true
                        end
                    end;
                    if (((timer >= 26) and (timer < 450)) and (math.fmod((timer - 26), (kRingCadence)[index + 1]) == 0)) then
                        do
                            ctx:spawnProjectileSpread(4, 0, (enemy).x, (enemy).y, (enemy).secondaryAngle16, f32(0), (speed * 0.59999999999999998), 1, (kRingCount)[index + 1], 65536, 0);
                            fired = true
                        end
                    end;
                    (enemy).secondaryAngle16 = (approachStage07Angle((enemy).secondaryAngle16, (aimAtPlayer)((enemy).x, (enemy).y), 48) % 65536)
                end
            end;
            if fired then
                (fireSound)()
            end;
            if (timer == 540) then
                do
                    local kFinalCount = {20, 36, 44, 50, 55};
                    local kFinalLayers = {1, 2, 3, 5, 6};
                    local kFinalBaseSpeed = {4.5, 4.5, 4, 4, 4};
                    local index = difficulty;
                    local aimed = (aimAtPlayer)((enemy).x, (enemy).y);
                    local count = (kFinalCount)[index + 1];
                    do
                        local layer = 0
                        while (layer < (kFinalLayers)[index + 1]) do
                            do
                                local selector = (function() if ((parent).spawnType == 131) then return 3 else return 2 end end)();
                                ctx:spawnProjectileSpread(selector, 0, (enemy).x, (enemy).y, normalizeStage07Angle((aimed + ((layer * trunc(65536 / (count * 5))) * 2))), f32(10), ((kFinalBaseSpeed)[index + 1] + (layer * 0.90000000000000002)), 1, count, 65536, 0)
                            end
                            ::__continue43::
                            layer = layer + 1
                        end
                        ::__loop_end42::
                    end;
                    ctx:spawnEnemyDeathEffects(enemy, 0, false);
                    (enemy).active = false;
                    do return end
                end
            end;
            if (((parent).hp < 1) or ((ctx).lateStageBossCountdown_ < 1)) then
                do
                    ctx:spawnEnemyDeathEffects(enemy, 0, false);
                    (enemy).active = false
                end
            end;
            do return end
        end
    end;
    if (((enemy).spawnType == 147) or ((enemy).spawnType == 148)) then
        do
            (enemy).targetable = false;
            local speed = (enemy).sourceSpeed;
            (enemy).x = f32(f32(((enemy).x + stage07PolarX((enemy).sourceAngle16, speed))));
            (enemy).y = f32(f32(((enemy).y + stage07PolarY((enemy).sourceAngle16, speed))));
            (enemy).sourceSpeed = ((enemy).sourceSpeed + 0.10000000000000001);
            local horizontalOrigin = f32((((ctx).player_).x / f32(6)));
            local hitShotBoundary = (((((enemy).x < f32((horizontalOrigin - f32(30)))) or ((enemy).x > f32((horizontalOrigin + f32(630))))) or ((enemy).y < f32((-f32(180))))) or ((enemy).y > f32(750)));
            if (((enemy).spawnType == 148) and hitShotBoundary) then
                do
                    (enemy).x = f32(f32(((enemy).x + stage07PolarX((enemy).sourceAngle16, (-30)))));
                    (enemy).y = f32(f32(((enemy).y + stage07PolarY((enemy).sourceAngle16, (-30)))));
                    local kShotSpeed = {2, 3, 4, 4, 5};
                    ctx:spawnProjectileNode(20, 37, (enemy).x, (enemy).y, (aimAtPlayer)((enemy).x, (enemy).y), f32(0), (kShotSpeed)[difficulty + 1], 1, 0);
                    (enemy).active = false;
                    do return end
                end
            end;
            if ((((parent == nil) or (not isStage07HeadType((parent).spawnType))) or ((parent).hp < 1)) or ((ctx).lateStageBossCountdown_ < 1)) then
                do
                    ctx:spawnEnemyDeathEffects(enemy, 0, false);
                    (enemy).active = false;
                    do return end
                end
            end;
            if (((((enemy).x < f32((horizontalOrigin - f32(180)))) or ((enemy).x > f32((horizontalOrigin + f32(780))))) or ((enemy).y < f32((-f32(180))))) or ((enemy).y > f32(900))) then
                do
                    (enemy).active = false
                end
            end
        end
    end
end

cpp.install(M)

return M
