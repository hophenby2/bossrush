-- 由 tools/generate_likedreamer_native_bosses.py 从本地复原源码生成。

-- 生成物是普通 Lua 状态机；修改源逻辑或生成规则后重新生成并核对轨迹。

local cpp = assert(LikeDreamer.Recovered)

local f32, trunc, u32, s16 = cpp.f32, cpp.trunc, cpp.u32, cpp.s16

local bit = require("bit")

local M = {}

local kPi = 3.1415926535897931

local kTau = (kPi * 2)

local kUseScheduledY = 2147483647

local kLateStageEntityCap = 512

local kLateSpawnSpecs = {{spawnType = 68, updateCase = 50, entityKind = 5, radius = 30, forcedY = kUseScheduledY}, {spawnType = 69, updateCase = 51, entityKind = 7, radius = 40, forcedY = kUseScheduledY}, {spawnType = 70, updateCase = 52, entityKind = 12, radius = 70, forcedY = kUseScheduledY}, {spawnType = 71, updateCase = 53, entityKind = 20, radius = 80, forcedY = kUseScheduledY}, {spawnType = 72, updateCase = 53, entityKind = 20, radius = 80, forcedY = kUseScheduledY}, {spawnType = 73, updateCase = 54, entityKind = 5, radius = 35, forcedY = kUseScheduledY}, {spawnType = 74, updateCase = 55, entityKind = 42, radius = 90, forcedY = (-100)}, {spawnType = 75, updateCase = 28, entityKind = 1, radius = 20, forcedY = kUseScheduledY}, {spawnType = 76, updateCase = 56, entityKind = 4, radius = 80, forcedY = kUseScheduledY}, {spawnType = 77, updateCase = 57, entityKind = 80, radius = 90, forcedY = kUseScheduledY}, {spawnType = 78, updateCase = 58, entityKind = 8, radius = 30, forcedY = kUseScheduledY}, {spawnType = 79, updateCase = 59, entityKind = 120, radius = 160, forcedY = kUseScheduledY}, {spawnType = 80, updateCase = 60, entityKind = 0, radius = 100, forcedY = kUseScheduledY}, {spawnType = 81, updateCase = 60, entityKind = 0, radius = 100, forcedY = kUseScheduledY}, {spawnType = 82, updateCase = 60, entityKind = 0, radius = 100, forcedY = kUseScheduledY}, {spawnType = 83, updateCase = 61, entityKind = 1, radius = 40, forcedY = kUseScheduledY}, {spawnType = 84, updateCase = 62, entityKind = 0, radius = 40, forcedY = kUseScheduledY}, {spawnType = 85, updateCase = 63, entityKind = 2, radius = 25, forcedY = kUseScheduledY}, {spawnType = 86, updateCase = 64, entityKind = 1, radius = 40, forcedY = kUseScheduledY}, {spawnType = 87, updateCase = 65, entityKind = 12, radius = 60, forcedY = kUseScheduledY}, {spawnType = 88, updateCase = 65, entityKind = 12, radius = 60, forcedY = kUseScheduledY}, {spawnType = 89, updateCase = 66, entityKind = 20, radius = 60, forcedY = kUseScheduledY}, {spawnType = 90, updateCase = 67, entityKind = 6, radius = 40, forcedY = kUseScheduledY}, {spawnType = 91, updateCase = 68, entityKind = 6, radius = 40, forcedY = kUseScheduledY}, {spawnType = 92, updateCase = 68, entityKind = 6, radius = 40, forcedY = kUseScheduledY}, {spawnType = 93, updateCase = 69, entityKind = 20, radius = 60, forcedY = kUseScheduledY}, {spawnType = 94, updateCase = 70, entityKind = 36, radius = 95, forcedY = kUseScheduledY}, {spawnType = 95, updateCase = 71, entityKind = 77, radius = 120, forcedY = kUseScheduledY}, {spawnType = 96, updateCase = 72, entityKind = 1, radius = 25, forcedY = kUseScheduledY}, {spawnType = 112, updateCase = 79, entityKind = 10, radius = 40, forcedY = kUseScheduledY}, {spawnType = 113, updateCase = 80, entityKind = 24, radius = 80, forcedY = kUseScheduledY}, {spawnType = 114, updateCase = 80, entityKind = 24, radius = 80, forcedY = kUseScheduledY}, {spawnType = 115, updateCase = 81, entityKind = 36, radius = 100, forcedY = (-100)}, {spawnType = 116, updateCase = 82, entityKind = 10, radius = 40, forcedY = kUseScheduledY}, {spawnType = 117, updateCase = 83, entityKind = 15, radius = 50, forcedY = kUseScheduledY}, {spawnType = 118, updateCase = 84, entityKind = 64, radius = 110, forcedY = kUseScheduledY}, {spawnType = 119, updateCase = 85, entityKind = 100, radius = 60, forcedY = kUseScheduledY}, {spawnType = 120, updateCase = 86, entityKind = 12, radius = 40, forcedY = kUseScheduledY}, {spawnType = 149, updateCase = 98, entityKind = 5, radius = 45, forcedY = kUseScheduledY}, {spawnType = 150, updateCase = 99, entityKind = 5, radius = 40, forcedY = kUseScheduledY}, {spawnType = 151, updateCase = 100, entityKind = 7, radius = 50, forcedY = kUseScheduledY}, {spawnType = 152, updateCase = 100, entityKind = 7, radius = 50, forcedY = kUseScheduledY}, {spawnType = 153, updateCase = 100, entityKind = 7, radius = 50, forcedY = kUseScheduledY}, {spawnType = 154, updateCase = 101, entityKind = 80, radius = 140, forcedY = kUseScheduledY}, {spawnType = 155, updateCase = 102, entityKind = 24, radius = 70, forcedY = kUseScheduledY}, {spawnType = 156, updateCase = 102, entityKind = 24, radius = 70, forcedY = kUseScheduledY}, {spawnType = 158, updateCase = 102, entityKind = 24, radius = 70, forcedY = kUseScheduledY}, {spawnType = 159, updateCase = 102, entityKind = 24, radius = 70, forcedY = kUseScheduledY}, {spawnType = 161, updateCase = 102, entityKind = 24, radius = 70, forcedY = kUseScheduledY}, {spawnType = 162, updateCase = 102, entityKind = 24, radius = 70, forcedY = kUseScheduledY}, {spawnType = 164, updateCase = 103, entityKind = 120, radius = 90, forcedY = kUseScheduledY}, {spawnType = 173, updateCase = 108, entityKind = 5, radius = 40, forcedY = (-10)}, {spawnType = 250, updateCase = 130, entityKind = 5, radius = 45, forcedY = kUseScheduledY}, {spawnType = 251, updateCase = 131, entityKind = 5, radius = 45, forcedY = (-20)}, {spawnType = 252, updateCase = 132, entityKind = 10, radius = 60, forcedY = (-60)}, {spawnType = 253, updateCase = 133, entityKind = 16, radius = 50, forcedY = (-50)}, {spawnType = 254, updateCase = 134, entityKind = 24, radius = 70, forcedY = kUseScheduledY}, {spawnType = 255, updateCase = 28, entityKind = 1, radius = 20, forcedY = kUseScheduledY}, {spawnType = 256, updateCase = 135, entityKind = 24, radius = 70, forcedY = kUseScheduledY}, {spawnType = 257, updateCase = 28, entityKind = 1, radius = 20, forcedY = kUseScheduledY}, {spawnType = 258, updateCase = 136, entityKind = 36, radius = 90, forcedY = (-100)}, {spawnType = 259, updateCase = 137, entityKind = 48, radius = 90, forcedY = kUseScheduledY}, {spawnType = 260, updateCase = 137, entityKind = 48, radius = 90, forcedY = kUseScheduledY}}

local kStage10FinalBossNodeSpecs = {{spawnType = 273, updateCase = 141, spawnY = f32(250), radius = 150, parentBreakState = 20}, {spawnType = 274, updateCase = 142, spawnY = f32(250), radius = 100, parentBreakState = 40}, {spawnType = 275, updateCase = 143, spawnY = f32(300), radius = 80, parentBreakState = 60}, {spawnType = 277, updateCase = 145, spawnY = f32(250), radius = 150, parentBreakState = 80}, {spawnType = 282, updateCase = 147, spawnY = f32(250), radius = 170, parentBreakState = 100}, {spawnType = 285, updateCase = 149, spawnY = f32(320), radius = 150, parentBreakState = 120}, {spawnType = 293, updateCase = 152, spawnY = f32(250), radius = 150, parentBreakState = 140}, {spawnType = 294, updateCase = 152, spawnY = f32(250), radius = 150, parentBreakState = 140}, {spawnType = 295, updateCase = 153, spawnY = f32(250), radius = 150, parentBreakState = 142}, {spawnType = 301, updateCase = 156, spawnY = f32(230), radius = 230, parentBreakState = 152}}

local kStage10Type11fLaunchSides = {0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0}

local kLateBossSpecs = {{spawnType = 316, updateCase = 163, spawnX = f32(360), spawnY = f32(200), targetX = f32(360), targetY = f32(200), speed = 0.29999999999999999, radius = 175, breaks = 6}, {spawnType = 317, updateCase = 164, spawnX = f32(480), spawnY = f32(150), targetX = f32(480), targetY = f32(150), speed = 0.29999999999999999, radius = 175, breaks = 5}, {spawnType = 318, updateCase = 165, spawnX = f32(360), spawnY = f32(250), targetX = f32(360), targetY = f32(200), speed = 0.20000000000000001, radius = 210, breaks = 5}, {spawnType = 319, updateCase = 166, spawnX = f32(360), spawnY = f32(180), targetX = f32(360), targetY = f32(180), speed = 0.29999999999999999, radius = 130, breaks = 6}, {spawnType = 320, updateCase = 167, spawnX = f32(360), spawnY = f32(190), targetX = f32(360), targetY = f32(190), speed = 0.10000000000000001, radius = 140, breaks = 4}, {spawnType = 321, updateCase = 168, spawnX = f32(360), spawnY = f32(320), targetX = f32(360), targetY = f32(200), speed = 0.40000000000000002, radius = 80, breaks = 16}, {spawnType = 323, updateCase = 169, spawnX = f32(400), spawnY = f32(240), targetX = f32(400), targetY = f32(240), speed = 0.29999999999999999, radius = 80, breaks = 1}, {spawnType = 324, updateCase = 170, spawnX = f32(360), spawnY = f32(900), targetX = f32(360), targetY = f32(200), speed = 0.29999999999999999, radius = 50, breaks = 1}, {spawnType = 325, updateCase = 171, spawnX = f32(360), spawnY = f32(900), targetX = f32(360), targetY = f32(200), speed = 0.29999999999999999, radius = 50, breaks = 1}, {spawnType = 326, updateCase = 172, spawnX = f32(360), spawnY = f32(200), targetX = f32(360), targetY = f32(200), speed = 0.29999999999999999, radius = 160, breaks = 1}, {spawnType = 327, updateCase = 173, spawnX = f32(360), spawnY = f32(270), targetX = f32(360), targetY = f32(200), speed = 0.29999999999999999, radius = 220, breaks = 1}, {spawnType = 328, updateCase = 174, spawnX = f32(360), spawnY = f32(200), targetX = f32(360), targetY = f32(200), speed = 4.5, radius = 150, breaks = 1}, {spawnType = 329, updateCase = 175, spawnX = f32(360), spawnY = f32(200), targetX = f32(360), targetY = f32(200), speed = 0.29999999999999999, radius = 200, breaks = 1}, {spawnType = 330, updateCase = 176, spawnX = f32(360), spawnY = f32(200), targetX = f32(360), targetY = f32(200), speed = 0.29999999999999999, radius = 175, breaks = 1}, {spawnType = 331, updateCase = 177, spawnX = f32(360), spawnY = f32(240), targetX = f32(360), targetY = f32(200), speed = 1.6000000000000001, radius = 175, breaks = 1}, {spawnType = 332, updateCase = 178, spawnX = f32(360), spawnY = f32((-f32(2400))), targetX = f32(360), targetY = f32(250), speed = 0, radius = 200, breaks = 3}}

local lateSpawnSpec

local lateBossSpec

local stage10FinalBossNodeSpec

local isStage10FinalBossAuxNodeType

local isStage06BossNodeType

local normalizeAngle16

local fixedAngleRadians

local radiansToAngle16

local approachAngle16

local frameHandle

local lateBossFrameRand

local lateEnemyDeathRewardWindow

local lateEnemyDeathEffectMode

local lateEnemyProjectileSpeed

local lateStageScriptRand

lateSpawnSpec = function(spawnType)
    do

        for _, spec in ipairs(kLateSpawnSpecs) do
            do
                if ((spec).spawnType == spawnType) then
                    do
                        do return spec end
                    end
                end
            end
        end
    end;
    do return nil end
end

lateBossSpec = function(spawnType)
    do

        for _, spec in ipairs(kLateBossSpecs) do
            do
                if ((spec).spawnType == spawnType) then
                    do
                        do return spec end
                    end
                end
            end
        end
    end;
    do return nil end
end

stage10FinalBossNodeSpec = function(spawnType)
    do

        for _, spec in ipairs(kStage10FinalBossNodeSpecs) do
            do
                if ((spec).spawnType == spawnType) then
                    do
                        do return spec end
                    end
                end
            end
        end
    end;
    do return nil end
end

isStage10FinalBossAuxNodeType = function(spawnType)
    do return (((((spawnType == 276) or ((spawnType >= 278) and (spawnType <= 281))) or (spawnType == 283)) or (spawnType == 284)) or ((spawnType >= 286) and (spawnType <= 290))) end
end

isStage06BossNodeType = function(spawnType)
    do return ((spawnType >= 100) and (spawnType <= 111)) end
end

normalizeAngle16 = function(angle)
    do return (bit.band(angle, 65535) % 65536) end
end

fixedAngleRadians = function(angle)
    angle = (angle % 65536);
    do return ((angle * kTau) / 65536) end
end

radiansToAngle16 = function(radians)
    do return normalizeAngle16(trunc(((radians * 65536) / kTau))) end
end

approachAngle16 = function(current, target, step)
    current = (current % 65536);
    target = (target % 65536);
    local delta = (target - current);
    if (delta > 32768) then
        delta = (delta - 65536)
    end;
    if (delta < (-32768)) then
        delta = (delta + 65536)
    end;
    delta = cpp.clamp(delta, (-step), step);
    do return normalizeAngle16((current + delta)) end
end

frameHandle = function(frames, index)
    do return (function() if ((index >= 0) and (index < (#frames))) then return (frames)[index + 1] else return (-1) end end)() end
end

lateBossFrameRand = function(frame)
    local seed = u32(frame);
    local u = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(seed, 30)), seed)), 1812433253) + 1));
    local a = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(u, 30)), u)), 1812433253) + 2));
    local b = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(a, 30)), a)), 1812433253) + 3));
    local c = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(b, 30)), b)), 1812433253) + 4));
    local mixed = u32(bit.bxor(cpp.mul32(u, 2048), u));
    do return u32(bit.bxor(u32(bit.bxor(u32(bit.rshift(u32(bit.bxor(u32(bit.rshift(c, 11)), mixed)), 8)), c)), mixed)) end
end

lateEnemyDeathRewardWindow = function(spawnType)
    do
        local __switch8 = spawnType
        if __switch8 == 68 then __switch8 = 1
        elseif __switch8 == 69 then __switch8 = 2
        elseif __switch8 == 70 then __switch8 = 3
        elseif __switch8 == 71 then __switch8 = 4
        elseif __switch8 == 72 then __switch8 = 5
        elseif __switch8 == 73 then __switch8 = 6
        elseif __switch8 == 74 then __switch8 = 7
        elseif __switch8 == 77 then __switch8 = 8
        elseif __switch8 == 113 then __switch8 = 9
        elseif __switch8 == 114 then __switch8 = 10
        elseif __switch8 == 115 then __switch8 = 11
        elseif __switch8 == 78 then __switch8 = 12
        elseif __switch8 == 76 then __switch8 = 13
        elseif __switch8 == 112 then __switch8 = 14
        elseif __switch8 == 116 then __switch8 = 15
        elseif __switch8 == 117 then __switch8 = 16
        elseif __switch8 == 118 then __switch8 = 17
        elseif __switch8 == 79 then __switch8 = 18
        elseif __switch8 == 119 then __switch8 = 19
        else __switch8 = 20 end
        repeat
            if __switch8 <= 1 then
                do return 200 end;
            end
            if __switch8 <= 2 then
                do return 240 end;
            end
            if __switch8 <= 12 then
                do return 500 end;
            end
            if __switch8 <= 13 then
                do return 300 end;
            end
            if __switch8 <= 14 then
                do return 360 end;
            end
            if __switch8 <= 16 then
                do return 600 end;
            end
            if __switch8 <= 17 then
                do return 800 end;
            end
            if __switch8 <= 19 then
                do return 1800 end;
            end
            if __switch8 <= 20 then
                do return 0 end
            end
        until true
    end
end

lateEnemyDeathEffectMode = function(spawnType)
    do
        local __switch30 = spawnType
        if __switch30 == 68 then __switch30 = 1
        elseif __switch30 == 69 then __switch30 = 2
        elseif __switch30 == 76 then __switch30 = 3
        elseif __switch30 == 78 then __switch30 = 4
        elseif __switch30 == 73 then __switch30 = 5
        elseif __switch30 == 112 then __switch30 = 6
        elseif __switch30 == 116 then __switch30 = 7
        elseif __switch30 == 70 then __switch30 = 8
        elseif __switch30 == 71 then __switch30 = 9
        elseif __switch30 == 72 then __switch30 = 10
        elseif __switch30 == 74 then __switch30 = 11
        elseif __switch30 == 113 then __switch30 = 12
        elseif __switch30 == 114 then __switch30 = 13
        elseif __switch30 == 115 then __switch30 = 14
        elseif __switch30 == 117 then __switch30 = 15
        elseif __switch30 == 77 then __switch30 = 16
        elseif __switch30 == 79 then __switch30 = 17
        elseif __switch30 == 118 then __switch30 = 18
        elseif __switch30 == 119 then __switch30 = 19
        else __switch30 = 20 end
        repeat
            if __switch30 <= 7 then
                do return 0 end;
            end
            if __switch30 <= 15 then
                do return 1 end;
            end
            if __switch30 <= 19 then
                do return 2 end;
            end
            if __switch30 <= 20 then
                do return 0 end
            end
        until true
    end
end

lateEnemyProjectileSpeed = function(difficulty, values)
    do return (values)[cpp.clamp(difficulty, 0, 4) + 1] end
end

lateStageScriptRand = function(seed)
    local value = u32(seed);
    local u = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(value, 30)), value)), 1812433253) + 1));
    local a = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(u, 30)), u)), 1812433253) + 2));
    local b = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(a, 30)), a)), 1812433253) + 3));
    local c = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(b, 30)), b)), 1812433253) + 4));
    local mixed = u32(bit.bxor(cpp.mul32(u, 2048), u));
    do return u32(bit.bxor(u32(bit.bxor(u32(bit.rshift(u32(bit.bxor(u32(bit.rshift(c, 11)), mixed)), 8)), c)), mixed)) end
end

M.isStage10FinalBossNodeType = function(ctx, spawnType)
    do return (((stage10FinalBossNodeSpec(spawnType) ~= nil) or isStage10FinalBossAuxNodeType(spawnType)) or ctx:isStage10FinalBossEmitterType(spawnType)) end
end

M.clearLateStageGate = function(ctx, stage)
    do
        local __switch52 = stage
        if __switch52 == 5 then __switch52 = 1
        elseif __switch52 == 6 then __switch52 = 2
        elseif __switch52 == 7 then __switch52 = 3
        elseif __switch52 == 8 then __switch52 = 4
        elseif __switch52 == 9 then __switch52 = 5
        elseif __switch52 == 10 then __switch52 = 6
        else __switch52 = 7 end
        repeat
            if __switch52 <= 1 then
                (ctx).stage05GateFlag_ = false;
                do break end;
            end
            if __switch52 <= 2 then
                (ctx).stage06GateFlag_ = false;
                do break end;
            end
            if __switch52 <= 3 then
                (ctx).stage07GateFlag_ = false;
                do break end;
            end
            if __switch52 <= 4 then
                (ctx).stage08GateFlag_ = false;
                do break end;
            end
            if __switch52 <= 5 then
                (ctx).stage09GateFlag_ = false;
                do break end;
            end
            if __switch52 <= 6 then
                (ctx).stage10GateFlag_ = false;
                do break end;
            end
            if __switch52 <= 7 then
                do break end
            end
        until true
    end
end

M.spawnStage05BossChild = function(ctx, parent, spawnType, offsetX, offsetY, angle16, speed, radius, hitPoints, kind, note)
    offsetX = f32(offsetX);
    offsetY = f32(offsetY);
    angle16 = (angle16 % 65536);
    local spec = lateSpawnSpec(spawnType);
    if ((((((parent).spawnType ~= 316) or (spec == nil)) or (spawnType < 84)) or (spawnType > 86)) or (((#(ctx).enemies_) + (#(ctx).pendingEnemies_)) >= kLateStageEntityCap)) then
        do
            do return false end
        end
    end;
    local child = cpp.newEnemy();
    (child).entityId = (function() local __old = (ctx).nextEntityId_; (ctx).nextEntityId_ = (ctx).nextEntityId_ + 1; return __old end)();
    (child).spawnType = spawnType;
    (child).updateCase = (spec).updateCase;
    (child).sourceHitPoints = hitPoints;
    (child).sourceX = cpp.lround(offsetX);
    (child).sourceY = cpp.lround(offsetY);
    (child).sourceNote = note;
    (child).sourceDispatchKind = kind;
    (child).sourceDispatchField = radius;
    (child).rewardWeight = kind;
    (child).parentEntityId = (parent).entityId;
    (child).parentSpawnType = (parent).spawnType;
    (child).childIndex = (parent).liveChildCount;
    (child).originX = f32(offsetX);
    (child).originY = f32(offsetY);
    (child).x = f32(f32(((parent).x + offsetX)));
    (child).y = f32(f32(((parent).y + offsetY)));
    (child).markerDrawX = f32((child).x);
    (child).markerDrawY = f32((child).y);
    (child).sourceAngle16 = (angle16 % 65536);
    (child).secondaryAngle16 = (angle16 % 65536);
    (child).targetAngle16 = (angle16 % 65536);
    (child).angle = f32(f32(fixedAngleRadians(angle16)));
    (child).sourceSpeed = speed;
    (child).speed = f32(f32(speed));
    local easyScale = (function() if (((ctx).config_).difficulty == 0) then return 0.80000000000000004 else return 1 end end)();
    (child).hp = math.max(1, trunc((hitPoints * easyScale)));
    (child).maxHp = (child).hp;
    (child).drawHp = (child).hp;
    (child).radius = radius;
    (child).activationDelay = 0;
    (child).targetable = false;
    cpp.push((ctx).pendingEnemies_, child);
    (parent).liveChildCount = (parent).liveChildCount + 1;
    do return true end
end

M.emitStage05BossProjectiles = function(ctx, enemy)
    local difficulty = cpp.clamp(((ctx).config_).difficulty, 0, 4);
    local timer = (enemy).helperTimer;
    local aimFrom = function(x, y)
        x = f32(x);
        y = f32(y);
        do return radiansToAngle16(math.atan2(f32((((ctx).player_).y - y)), f32((((ctx).player_).x - x)))) end
    end;
    local modulo = function(value, divisor)
        local result = math.fmod(value, divisor);
        do return (function() if (result < 0) then return (result + divisor) else return result end end)() end
    end;
    if ((enemy).helperState == 1) then
        do
            local kSources = {{f32((-f32(95))), f32(80)}, {f32(90), f32(35)}, {f32((-f32(2))), f32((-f32(110)))}};
            local kRingCount = {7, 11, 17, 15, 17};
            local kRingStep = {330, 370, 400, 400, 560};
            local kRingSpeed = {5.7000000000000002, 7, 7.5, 8, 9.5};
            local kFanInterval = {21, 14, 12, 11, 10};
            local kFanCount = {3, 5, 7, 5, 7};
            local kFanSpeed = {6, 7.4000000000000004, 8.5, 8.5, 10};
            local cycle = (modulo)((timer - 30), 690);
            do
                local source = 0
                while (source < 3) do
                    do
                        local x = f32(((enemy).x + ((kSources)[source + 1])[0 + 1]));
                        local y = f32(((enemy).y + ((kSources)[source + 1])[1 + 1]));
                        local ringStart = (source * 40);
                        if (((cycle >= ringStart) and (cycle < (ringStart + 36))) and (math.fmod((cycle - ringStart), 4) == 0)) then
                            do
                                local step = ((kRingStep)[difficulty + 1] + (source * 30));
                                if (source == 1) then
                                    step = (-step)
                                end;
                                if ((source == 0) and (cycle == 0)) then
                                    do
                                        (enemy).secondaryAngle16 = ((aimFrom)(x, y) % 65536)
                                    end
                                end;
                                local center = (enemy).secondaryAngle16;
                                local count = (kRingCount)[difficulty + 1];
                                local speed = (((kRingSpeed)[difficulty + 1] + ((cycle - ringStart) * 0.029999999999999999)) + (source * 0.80000000000000004));
                                ctx:spawnProjectileSpread(3, 0, x, y, center, f32(10), speed, 1, count, 65536, 0);
                                if (difficulty > 2) then
                                    do
                                        local offset = (trunc(65536 / (count * 2)) - step);
                                        ctx:spawnProjectileSpread(5, 0, x, y, normalizeAngle16((center + offset)), f32(10), (speed - 1.5), 1, count, 65536, 0)
                                    end
                                end;
                                ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19);
                                (enemy).secondaryAngle16 = (normalizeAngle16(((enemy).secondaryAngle16 + step)) % 65536)
                            end
                        end;
                        local fanStart = ((source + 1) * 160);
                        local interval = (kFanInterval)[difficulty + 1];
                        if (((cycle >= fanStart) and (cycle < (fanStart + 180))) and (math.fmod((cycle - fanStart), interval) == 0)) then
                            do
                                local count = (kFanCount)[difficulty + 1];
                                local spread = math.max(0, (27000 - ((cycle - fanStart) * 145)));
                                local speed = ((kFanSpeed)[difficulty + 1] + source);
                                local cachedAim = (function() if (bit.band(source, 1) == 0) then return cpp.ref(function() return (enemy).secondaryAngle16 end, function(value) (enemy).secondaryAngle16 = value end) else return cpp.ref(function() return (enemy).targetAngle16 end, function(value) (enemy).targetAngle16 = value end) end end)();
                                if (cycle == fanStart) then
                                    do
                                        cpp.set(cachedAim, ((aimFrom)(x, y) % 65536))
                                    end
                                end;
                                ctx:spawnProjectileSpread(13, 0, x, y, cpp.get(cachedAim), f32(0), speed, 1, count, spread, 0);
                                if (difficulty > 2) then
                                    do
                                        ctx:spawnProjectileSpread(13, 0, x, y, cpp.get(cachedAim), f32(0), (speed - 2), 1, count, (spread + 2000), 0)
                                    end
                                end;
                                ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                            end
                        end
                    end
                    source = source + 1
                end
            end;
            do return end
        end
    end;
    if ((enemy).helperState == 3) then
        do
            local kSources = {{f32(60), f32(90)}, {f32((-f32(67))), f32((-f32(60)))}, {f32(153), f32(5)}, {f32((-f32(153))), f32(0)}};
            local kFanInterval = {41, 27, 19, 15, 12};
            local kSpreadUnit = {6000, 4000, 3300, 3000, 2700};
            local kFanSpeed = {4.4000000000000004, 5.7000000000000002, 6.2000000000000002, 7, 9};
            local kPairSpeed = {5, 6, 7, 8, 9};
            if (timer >= 240) then
                do
                    local cycle = (modulo)((timer - 240), 510);
                    do
                        local source = 0
                        while (source < 2) do
                            repeat
                                do
                                    local start = (source * 210);
                                    local interval = (kFanInterval)[difficulty + 1];
                                    if (((cycle < start) or (cycle >= (start + 210))) or (math.fmod((cycle - start), interval) ~= 0)) then
                                        do
                                            do break end
                                        end
                                    end;
                                    local x = f32(((enemy).x + ((kSources)[source + 1])[0 + 1]));
                                    local y = f32(((enemy).y + ((kSources)[source + 1])[1 + 1]));
                                    local shot = trunc((cycle - start) / interval);
                                    local cachedAim = (function() if (source == 0) then return cpp.ref(function() return (enemy).secondaryAngle16 end, function(value) (enemy).secondaryAngle16 = value end) else return cpp.ref(function() return (enemy).targetAngle16 end, function(value) (enemy).targetAngle16 = value end) end end)();
                                    if (cycle == start) then
                                        do
                                            cpp.set(cachedAim, ((aimFrom)(x, y) % 65536))
                                        end
                                    end;
                                    ctx:spawnProjectileSpread(3, 0, x, y, cpp.get(cachedAim), f32(10), (kFanSpeed)[difficulty + 1], 1, (shot + 1), (shot * (kSpreadUnit)[difficulty + 1]), 0);
                                    cpp.set(cachedAim, (approachAngle16(cpp.get(cachedAim), (aimFrom)(x, y), 444) % 65536));
                                    ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                                end
                            until true
                            source = source + 1
                        end
                    end
                end
            end;
            if (timer >= 10) then
                do
                    local cycle = (modulo)((timer - 10), 240);
                    do
                        local source = 2
                        while (source < 4) do
                            do
                                local offset = ((source - 1) * 60);
                                local x = f32(((enemy).x + ((kSources)[source + 1])[0 + 1]));
                                local y = f32(((enemy).y + ((kSources)[source + 1])[1 + 1]));
                                local axis = ((function() if (source == 2) then return 0 else return 32768 end end)() % 65536);
                                if (cycle == (offset - 60)) then
                                    do
                                        ctx:playPlayerSound((ctx).bossSe2SecondSoundHandle_, 19)
                                    end
                                end;
                                if (cycle == (offset - 20)) then
                                    do
                                        ctx:spawnProjectileNode(17, 12, x, y, axis, f32(0), (kPairSpeed)[difficulty + 1], 1, 0);
                                        ctx:playPlayerSound((ctx).bullet2SoundHandle_, 19)
                                    end
                                end;
                                if ((difficulty > 2) and (cycle == offset)) then
                                    do
                                        ctx:spawnProjectileNode(17, 12, x, y, normalizeAngle16((axis - 3333)), f32(0), (kPairSpeed)[difficulty + 1], 1, 0);
                                        ctx:spawnProjectileNode(17, 12, x, y, normalizeAngle16((axis + 3333)), f32(0), (kPairSpeed)[difficulty + 1], 1, 0);
                                        ctx:playPlayerSound((ctx).bullet2SoundHandle_, 19)
                                    end
                                end
                            end
                            source = source + 1
                        end
                    end
                end
            end;
            do return end
        end
    end;
    if ((enemy).helperState == 5) then
        do
            local kSources = {{f32(90), f32(30)}, {f32((-f32(95))), f32(30)}, {f32((-f32(2))), f32(100)}, {f32((-f32(2))), f32((-f32(55)))}};
            local kRingInterval = {22, 16, 12, 13, 11};
            local kRingCount = {5, 7, 8, 8, 9};
            local kRotationStep = {40, 40, 50, 50, 50};
            local kRingSpeed = {5.2000000000000002, 6.5, 7.7000000000000001, 7, 8.5};
            local kPairInterval = {70, 45, 36, 36, 36};
            local kNarrowCount = {3, 5, 7, 7, 9};
            local kWideCount = {8, 12, 16, 18, 20};
            local kPairSpeed = {4, 5.2999999999999998, 6, 6, 7.5};
            do
                local source = 0
                while (source < 2) do
                    repeat
                        do
                            local interval = (kRingInterval)[difficulty + 1];
                            if ((timer < 30) or (math.fmod((timer - 30), interval) ~= 0)) then
                                do break end
                            end;
                            local x = f32(((enemy).x + ((kSources)[source + 1])[0 + 1]));
                            local y = f32(((enemy).y + ((kSources)[source + 1])[1 + 1]));
                            local rotation = (timer * (kRotationStep)[difficulty + 1]);
                            if (source == 1) then
                                rotation = (-rotation)
                            end;
                            local center = normalizeAngle16((16384 + rotation));
                            local count = (kRingCount)[difficulty + 1];
                            local speed = (kRingSpeed)[difficulty + 1];
                            ctx:spawnProjectileSpread(13, 0, x, y, center, f32(0), speed, 1, count, 65536, 0);
                            if (difficulty > 2) then
                                do
                                    ctx:spawnProjectileSpread(13, 0, x, y, center, f32(0), (speed + 2), 1, count, 65536, 0)
                                end
                            end;
                            ctx:playPlayerSound((ctx).bullet1SoundHandle_, 16)
                        end
                    until true
                    source = source + 1
                end
            end;
            if (timer >= 120) then
                do
                    local interval = (kPairInterval)[difficulty + 1];
                    local x0 = f32(((enemy).x + ((kSources)[2 + 1])[0 + 1]));
                    local y0 = f32(((enemy).y + ((kSources)[2 + 1])[1 + 1]));
                    if (math.fmod((timer - 120), (interval * 3)) == 0) then
                        do
                            local count = (kNarrowCount)[difficulty + 1];
                            ctx:spawnProjectileSpread(2, 0, x0, y0, (aimFrom)(x0, y0), f32(10), (kPairSpeed)[difficulty + 1], 1, count, ((count * 700) - 700), 0);
                            ctx:playPlayerSound((ctx).bullet2SoundHandle_, 19)
                        end
                    end;
                    local x1 = f32(((enemy).x + ((kSources)[3 + 1])[0 + 1]));
                    local y1 = f32(((enemy).y + ((kSources)[3 + 1])[1 + 1]));
                    if ((timer >= (120 + interval)) and (math.fmod((timer - (120 + interval)), (interval * 3)) == 0)) then
                        do
                            ctx:spawnProjectileSpread(2, 0, x1, y1, (aimFrom)(x1, y1), f32(10), ((kPairSpeed)[difficulty + 1] + 1), 1, (kWideCount)[difficulty + 1], 32768, 0);
                            ctx:playPlayerSound((ctx).bullet2SoundHandle_, 19)
                        end
                    end
                end
            end;
            do return end
        end
    end;
    if ((enemy).helperState ~= 7) then
        do return end
    end;
    local kSources = {{f32(90), f32((-f32(20)))}, {f32((-f32(95))), f32((-f32(20)))}, {f32(156), f32(50)}, {f32((-f32(156))), f32(50)}, {f32(156), f32((-f32(100)))}, {f32((-f32(156))), f32((-f32(100)))}};
    local kRingInterval = {19, 15, 16, 16, 16};
    local kRingWindow = {8, 8, 10, 10, 10};
    local kRingCount = {2, 3, 4, 6, 8};
    local kRingSpeed = {4.5, 5.5, 6, 7.2000000000000002, 8.5999999999999996};
    local kArcInterval = {68, 51, 44, 39, 33};
    local kArcWindow = {14, 20, 24, 24, 24};
    local kArcSpeed = {7.2000000000000002, 8.5, 9.5, 10, 11};
    local cycle = (modulo)((timer - 30), 880);
    do
        local source = 0
        while (source < 2) do
            do
                local x = f32(((enemy).x + ((kSources)[source + 1])[0 + 1]));
                local y = f32(((enemy).y + ((kSources)[source + 1])[1 + 1]));
                if (cycle < 421) then
                    do
                        local interval = (kRingInterval)[difficulty + 1];
                        local v_local = math.fmod(cycle, interval);
                        if ((v_local < (kRingWindow)[difficulty + 1]) and (bit.band(v_local, 1) == 0)) then
                            do
                                local sweepPhase = math.fmod((cycle + 50), 480);
                                local sweep = 0;
                                if (source == 0) then
                                    do
                                        sweep = (function() if (sweepPhase <= 239) then return (sweepPhase * 248) else return (((-sweepPhase) * 248) - 12032) end end)()
                                    end
                                else
                                    do
                                        sweep = (function() if (sweepPhase <= 239) then return (((-sweepPhase) * 248) - 32768) else return ((sweepPhase * 248) - 20736) end end)()
                                    end
                                end;
                                ctx:spawnProjectileSpread(3, 0, x, y, normalizeAngle16(sweep), f32(0), (kRingSpeed)[difficulty + 1], 1, (kRingCount)[difficulty + 1], 65536, 0);
                                ctx:playPlayerSound((ctx).bullet1SoundHandle_, 16)
                            end
                        end
                    end
                end;
                if ((cycle >= 580) and (cycle < 810)) then
                    do
                        local interval = (kArcInterval)[difficulty + 1];
                        local v_local = math.fmod((cycle - 580), interval);
                        local cachedAim = (function() if (source == 0) then return cpp.ref(function() return (enemy).secondaryAngle16 end, function(value) (enemy).secondaryAngle16 = value end) else return cpp.ref(function() return (enemy).targetAngle16 end, function(value) (enemy).targetAngle16 = value end) end end)();
                        if (v_local == 0) then
                            do
                                cpp.set(cachedAim, ((aimFrom)(x, y) % 65536))
                            end
                        end;
                        if ((v_local < (kArcWindow)[difficulty + 1]) and (math.fmod(v_local, 3) == 0)) then
                            do
                                ctx:spawnProjectileNode(7, 0, x, y, cpp.get(cachedAim), f32(10), (kArcSpeed)[difficulty + 1], 1, 0);
                                if (difficulty > 2) then
                                    do
                                        ctx:spawnProjectileNode(7, 0, x, y, normalizeAngle16((cpp.get(cachedAim) - 675)), f32(10), ((kArcSpeed)[difficulty + 1] - 0.69999999999999996), 1, 0);
                                        ctx:spawnProjectileNode(7, 0, x, y, normalizeAngle16((cpp.get(cachedAim) + 675)), f32(10), ((kArcSpeed)[difficulty + 1] - 0.69999999999999996), 1, 0)
                                    end
                                end;
                                ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                            end
                        end
                    end
                end
            end
            source = source + 1
        end
    end;
    local kPairInterval = {71, 43, 31, 27, 24};
    local kPairSpeed = {5, 6, 7, 8, 9};
    local pairInterval = (kPairInterval)[difficulty + 1];
    do
        local source = 2
        while (source < 6) do
            do
                local sourceOffset = ((source - 2) * pairInterval);
                local x = f32(((enemy).x + ((kSources)[source + 1])[0 + 1]));
                local y = f32(((enemy).y + ((kSources)[source + 1])[1 + 1]));
                local effectStart = (440 + sourceOffset);
                if (((cycle >= effectStart) and (cycle < 800)) and (math.fmod((cycle - effectStart), (pairInterval * 4)) == 0)) then
                    do
                        ctx:playPlayerSound((ctx).bossSe2SecondSoundHandle_, 19)
                    end
                end;
                local shotStart = (480 + sourceOffset);
                if (((cycle >= shotStart) and (cycle < 840)) and (math.fmod((cycle - shotStart), (pairInterval * 4)) == 0)) then
                    do
                        local axis = (bit.lshift(source, 15) % 65536);
                        ctx:spawnProjectileNode(17, 12, x, y, axis, f32(0), (kPairSpeed)[difficulty + 1], 1, 0);
                        ctx:playPlayerSound((ctx).bullet2SoundHandle_, 19)
                    end
                end
            end
            source = source + 1
        end
    end
end

M.updateStage05BossChild = function(ctx, enemy)
    (enemy).vx = f32(f32(0));
    (enemy).vy = f32(f32(0));
    (enemy).drawBodyThisFrame = true;
    (enemy).drawMarkerThisFrame = false;
    local parent = ctx:findEnemyById((enemy).parentEntityId);
    local release = function()
        if ((parent ~= nil) and ((parent).liveChildCount > 0)) then
            do
                (parent).liveChildCount = (parent).liveChildCount - 1
            end
        end;
        (enemy).targetable = false;
        (enemy).active = false
    end;
    if (((parent == nil) or (not (parent).active)) or ((parent).spawnType ~= 316)) then
        do
            (release)();
            do return end
        end
    end;
    local difficulty = cpp.clamp(((ctx).config_).difficulty, 0, 4);
    local aimAtPlayer16 = function()
        do return radiansToAngle16(math.atan2(f32((((ctx).player_).y - (enemy).y)), f32((((ctx).player_).x - (enemy).x)))) end
    end;
    local syncSharedHp = function()
        if ((enemy).hp < (parent).hp) then
            do
                (parent).hp = (enemy).hp
            end
        else
            if ((parent).hp < (enemy).hp) then
                do
                    (enemy).hp = (parent).hp
                end
            end
        end;
        (enemy).maxHp = (parent).maxHp;
        (enemy).drawHp = (parent).drawHp
    end;
    if ((enemy).spawnType == 84) then
        do
            if (((parent).helperState ~= 8) and ((parent).helperState ~= 9)) then
                do
                    if ((parent).hp < 1) then
                        do
                            ctx:spawnEnemyDeathEffects(enemy, 1, true)
                        end
                    end;
                    (release)();
                    do return end
                end
            end;
            local timer = (enemy).helperTimer;
            if (timer == 0) then
                do
                    (enemy).x = f32(f32(((parent).x + f32(5))));
                    (enemy).y = f32(f32(((parent).y + f32(30))))
                end
            end;
            local targetX = f32(((parent).x + f32((math.sin(((timer * kTau) / 277)) * 200))));
            local targetY = f32(((parent).y + f32(((math.sin(((timer * kTau) / 413)) * (-90)) - (math.sin(((timer * kTau) / 688)) * 60)))));
            (enemy).x = f32(f32(((enemy).x + f32((f32((targetX - (enemy).x)) / f32(30))))));
            (enemy).y = f32(f32(((enemy).y + f32((f32((targetY - (enemy).y)) / f32(30))))));
            if ((enemy).helperState == 0) then
                do
                    (enemy).targetable = false;
                    if (timer ~= 172) then
                        do
                            do return end
                        end
                    end;
                    (enemy).helperState = 1;
                    (enemy).hp = (parent).hp;
                    (enemy).maxHp = (parent).maxHp;
                    (enemy).drawHp = (parent).drawHp;
                    (enemy).targetable = true;
                    (enemy).targetableTimer = 0
                end
            end;
            (syncSharedHp)();
            (enemy).targetable = true;
            local v_local = math.fmod((timer - 172), 700);
            local kAimInterval = {83, 51, 33, 45, 33};
            local kFireInterval = {10, 6, 3, 4, 3};
            local kSweepSpeed = {3.6000000000000001, 4.5, 5, 4, 6};
            local aimInterval = (kAimInterval)[difficulty + 1];
            local fireInterval = (kFireInterval)[difficulty + 1];
            local sweepLocal = (v_local - 120);
            if (((v_local >= 120) and (v_local < 480)) and (math.fmod(sweepLocal, aimInterval) == 0)) then
                do
                    (enemy).secondaryAngle16 = ((aimAtPlayer16)() % 65536)
                end
            end;
            if (((v_local >= 120) and (v_local < 480)) and (math.fmod(sweepLocal, fireInterval) == 0)) then
                do
                    local phase = math.fmod(sweepLocal, (aimInterval * 2));
                    local triangle = (function() if (phase < aimInterval) then return phase else return ((aimInterval * 2) - phase) end end)();
                    local sweep = ((triangle * trunc(32768 / aimInterval)) - 16784);
                    local center = normalizeAngle16(((enemy).secondaryAngle16 + sweep));
                    local speed = ((kSweepSpeed)[difficulty + 1] + ((v_local - 120) * 0.0060000000000000001));
                    do
                        local i = 0
                        while (i < 3) do
                            do
                                ctx:spawnProjectileNode(13, 0, (enemy).x, f32(((enemy).y + f32(10))), normalizeAngle16((center + (i * 400))), f32(10), speed, 1, 0)
                            end
                            i = i + 1
                        end
                    end;
                    if (difficulty > 2) then
                        do
                            do
                                local i = 0
                                while (i < 3) do
                                    do
                                        ctx:spawnProjectileNode(13, 0, (enemy).x, f32(((enemy).y + f32(10))), normalizeAngle16(((center + 1111) + (i * 400))), f32(10), (speed + 1), 1, 0)
                                    end
                                    i = i + 1
                                end
                            end
                        end
                    end;
                    ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                end
            end;
            if ((v_local == 460) or (v_local == 560)) then
                do
                    ctx:spawnStageEffect(49, frameHandle((ctx).effectMediumFrames_, 4), 200, 35, f32(0), f32(0), (0 % 65536), 0, 5, 5, 40, 255, 255, 255, 192, (enemy).entityId);
                    ctx:playPlayerSound((ctx).bossSe2SecondSoundHandle_, 19)
                end
            end;
            local kBurstStep = {18, 9, 6, 4, 3};
            local kBurstWindow = {40, 50, 55, 60, 66};
            local kBurstSpeed = {5, 6, 7, 8, 9};
            local burstStep = (kBurstStep)[difficulty + 1];
            local burstWindow = (kBurstWindow)[difficulty + 1];
            local firstBurst = (((v_local >= 500) and (v_local < (500 + burstWindow))) and (math.fmod((v_local - 500), burstStep) == 0));
            local secondBurst = (((v_local >= 600) and (v_local < (600 + burstWindow))) and (math.fmod((v_local - 600), burstStep) == 0));
            if (firstBurst or secondBurst) then
                do
                    local random = lateStageScriptRand(timer);
                    local jitter = (math.fmod(random, 40001) - 20000);
                    ctx:spawnProjectileNode(17, 12, (enemy).x, f32(((enemy).y + f32(10))), normalizeAngle16(((aimAtPlayer16)() + jitter)), f32(0), (kBurstSpeed)[difficulty + 1], 1, 0);
                    ctx:playPlayerSound((ctx).bullet2SoundHandle_, 19)
                end
            end;
            do return end
        end
    end;
    if ((enemy).spawnType == 85) then
        do
            if (((parent).helperState ~= 9) or ((ctx).lateStageBossPhaseMode_ ~= 1)) then
                do
                    if ((parent).hp < 1) then
                        do
                            ctx:spawnEnemyDeathEffects(enemy, 0, true)
                        end
                    end;
                    (release)();
                    do return end
                end
            end;
            local timer = (enemy).helperTimer;
            local radians = fixedAngleRadians((enemy).sourceAngle16);
            (enemy).x = f32(f32(((enemy).x + f32((math.cos(radians) * (enemy).sourceSpeed)))));
            (enemy).y = f32(f32(((enemy).y + f32((f32((math.sin(radians) * (enemy).sourceSpeed)) + f32((f32(timer) * f32(0.150000006))))))));
            (enemy).targetable = (timer >= 50);
            (enemy).drawHp = (enemy).hp;
            if ((enemy).hp < 1) then
                do
                    local kSpeed = {3.6000000000000001, 4.5, 5, 5, 6.4000000000000004};
                    local dx = f32((((ctx).player_).x - (enemy).x));
                    local dy = f32((((ctx).player_).y - (enemy).y));
                    local minimumDistance = f32(((enemy).radius + 30));
                    if (((f32((f32((dx * dx)) + f32((dy * dy)))) >= f32((minimumDistance * minimumDistance))) and ((enemy).y < f32(520))) and ((enemy).y < ((ctx).player_).y)) then
                        do
                            local snapped = normalizeAngle16(bit.band(((aimAtPlayer16)() + 1024), bit.bnot(2047)));
                            ctx:spawnProjectileNode(0, 0, (enemy).x, (enemy).y, snapped, f32(10), (kSpeed)[difficulty + 1], 1, 0);
                            if (difficulty > 2) then
                                do
                                    ctx:spawnProjectileNode(0, 0, (enemy).x, (enemy).y, snapped, f32(10), ((kSpeed)[difficulty + 1] + 1.5), 1, 0)
                                end
                            end
                        end
                    end;
                    ctx:spawnEnemyDeathRewardBurst(enemy, 200, false);
                    ctx:spawnEnemyDeathEffects(enemy, 0, true);
                    (release)();
                    do return end
                end
            end;
            local horizontalOrigin = f32((((ctx).player_).x / f32(6)));
            if (((((enemy).x < f32((horizontalOrigin - f32(180)))) or ((enemy).x > f32((horizontalOrigin + f32(780))))) or ((enemy).y < f32((-f32(180))))) or ((enemy).y > f32(900))) then
                do
                    (release)()
                end
            end;
            do return end
        end
    end;
    if ((((parent).helperState < 11) or ((parent).helperState > 13)) or ((ctx).lateStageBossPhaseMode_ ~= 1)) then
        do
            if ((parent).hp < 1) then
                do
                    ctx:spawnEnemyDeathEffects(enemy, 1, true)
                end
            end;
            (release)();
            do return end
        end
    end;
    if ((enemy).helperState == 0) then
        do
            local targetX = f32(((parent).x + (enemy).originX));
            local targetY = f32(((parent).y + (enemy).originY));
            (enemy).x = f32(f32(((enemy).x + f32((f32((targetX - (enemy).x)) / f32(30))))));
            (enemy).y = f32(f32(((enemy).y + f32((f32((targetY - (enemy).y)) / f32(30))))));
            (enemy).targetable = false;
            if ((enemy).helperTimer >= 30) then
                do
                    (enemy).helperState = 1;
                    (enemy).helperTimer = 0;
                    (enemy).hp = (parent).hp;
                    (enemy).maxHp = (parent).maxHp;
                    (enemy).drawHp = (parent).drawHp;
                    (enemy).targetable = true;
                    (enemy).targetableTimer = 0
                end
            end;
            if ((enemy).helperState == 0) then
                do
                    do return end
                end
            end
        end
    end;
    local targetX = f32(((parent).x + (enemy).originX));
    local targetY = f32(((parent).y + (enemy).originY));
    (enemy).x = f32(f32(((enemy).x + f32((f32((targetX - (enemy).x)) / f32(30))))));
    (enemy).y = f32(f32(((enemy).y + f32((f32((targetY - (enemy).y)) / f32(30))))));
    (syncSharedHp)();
    (enemy).targetable = true;
    local v_local = math.fmod((enemy).helperTimer, 1200);
    local kAimInterval = {83, 61, 47, 41, 36};
    local kSweepStep = {15, 7, 5, 4, 3};
    local kRandomStep = {18, 8, 6, 4, 3};
    local kSpeed = {4, 4, 4.5, 5, 6.4000000000000004};
    local aimInterval = (kAimInterval)[difficulty + 1];
    local sweepStep = (kSweepStep)[difficulty + 1];
    if ((v_local == 0) or (v_local == 380)) then
        do
            ctx:spawnStageEffect(49, frameHandle((ctx).effectMediumFrames_, 4), 200, 35, f32(0), f32(0), (0 % 65536), 0, 5, 5, 40, 255, 255, 255, 192, (enemy).entityId);
            ctx:playPlayerSound((ctx).bossSe2SecondSoundHandle_, 19)
        end
    end;
    if (((v_local >= 40) and (v_local < 200)) and (math.fmod((v_local - 40), aimInterval) == 0)) then
        do
            (enemy).secondaryAngle16 = ((aimAtPlayer16)() % 65536)
        end
    end;
    if (((v_local >= 40) and (v_local < 200)) and (math.fmod((v_local - 40), sweepStep) == 0)) then
        do
            local phase = math.fmod((v_local - 40), (aimInterval * 2));
            local triangle = (function() if (phase < aimInterval) then return phase else return ((aimInterval * 2) - phase) end end)();
            local sweep = ((triangle * trunc(28000 / aimInterval)) - 14000);
            if ((enemy).originX < f32(0)) then
                sweep = (-sweep)
            end;
            ctx:spawnProjectileNode(17, 13, (enemy).x, f32(((enemy).y + f32(10))), normalizeAngle16(((enemy).secondaryAngle16 + sweep)), f32(10), (kSpeed)[difficulty + 1], 1, 0);
            ctx:playPlayerSound((ctx).bossSe7SoundHandle_, 16)
        end
    end;
    local randomStep = (kRandomStep)[difficulty + 1];
    if (((v_local >= 210) and (v_local < 340)) and (math.fmod((v_local - 210), randomStep) == 0)) then
        do
            local random = lateStageScriptRand(((enemy).helperTimer + (enemy).childIndex));
            local jitter = (math.fmod(random, 28001) - 14000);
            ctx:spawnProjectileNode(17, 13, (enemy).x, f32(((enemy).y + f32(10))), normalizeAngle16(((aimAtPlayer16)() + jitter)), f32(10), (kSpeed)[difficulty + 1], 1, 0);
            ctx:playPlayerSound((ctx).bossSe7SoundHandle_, 16)
        end
    end;
    if (v_local == 440) then
        do
            (enemy).secondaryAngle16 = (radiansToAngle16(math.atan2(f32((((ctx).player_).y - (parent).y)), f32((((ctx).player_).x - (parent).x)))) % 65536);
            if ((enemy).secondaryAngle16 > 32768) then
                do
                    (enemy).secondaryAngle16 = (normalizeAngle16(((enemy).secondaryAngle16 + 32768)) % 65536)
                end
            end;
            (enemy).targetAngle16 = ((enemy).secondaryAngle16 % 65536)
        end
    end;
    if ((v_local >= 460) and (v_local <= 560)) then
        do
            local delta = (16384 - (enemy).secondaryAngle16);
            if (delta > 32768) then
                delta = (delta - 65536)
            end;
            if (delta < (-32768)) then
                delta = (delta + 65536)
            end;
            (enemy).secondaryAngle16 = (approachAngle16((enemy).secondaryAngle16, (16384 % 65536), trunc(math.abs(delta) / 120)) % 65536)
        end
    end;
    if ((v_local >= 560) and (v_local < 1190)) then
        do
            local kTurnInterval = {160, 135, 80, 60, 40};
            local kTurnWindow = {90, 75, 60, 60, 40};
            local kTurnBase = {40, 60, 100, 120, 180};
            local kTurnGrowth = {12, 15, 10, 5, 3};
            local interval = (kTurnInterval)[difficulty + 1];
            local window = (kTurnWindow)[difficulty + 1];
            local offset = (v_local - 560);
            local phase = math.fmod(offset, (interval * 4));
            local turn = ((kTurnBase)[difficulty + 1] + (trunc(offset / interval) * (kTurnGrowth)[difficulty + 1]));
            if ((enemy).targetAngle16 > 16384) then
                do
                    turn = (-turn)
                end
            end;
            if ((phase < window) or ((phase >= (interval * 3)) and (phase < ((interval * 3) + window)))) then
                do
                    (enemy).secondaryAngle16 = (normalizeAngle16(((enemy).secondaryAngle16 + turn)) % 65536)
                end
            else
                if (((phase >= interval) and (phase < (interval + window))) or ((phase >= (interval * 2)) and (phase < ((interval * 2) + window)))) then
                    do
                        (enemy).secondaryAngle16 = (normalizeAngle16(((enemy).secondaryAngle16 - turn)) % 65536)
                    end
                end
            end
        end
    end;
    if (((v_local >= 440) and (v_local < 1190)) and (math.fmod((v_local - 440), 3) == 0)) then
        do
            local spread = (function() if (v_local < 500) then return ((545 - v_local) * 600) else return 27000 end end)();
            local shotAngle = (enemy).secondaryAngle16;
            local parentAim = radiansToAngle16(math.atan2(f32((((ctx).player_).y - (parent).y)), f32((((ctx).player_).x - (parent).x))));
            local delta = (parentAim - shotAngle);
            if (delta > 32768) then
                delta = (delta - 65536)
            end;
            if (delta < (-32768)) then
                delta = (delta + 65536)
            end;
            if (math.abs(delta) > 16384) then
                do
                    shotAngle = (normalizeAngle16((shotAngle - 32768)) % 65536)
                end
            end;
            ctx:spawnProjectileSpread(6, 0, (enemy).x, f32(((enemy).y + f32(10))), shotAngle, f32(10), 14, 1, 5, math.max(27000, spread), 0);
            ctx:playPlayerSound((ctx).bullet1SoundHandle_, 16)
        end
    end
end

M.updateStage05Boss = function(ctx, enemy)
    local difficulty = cpp.clamp(((ctx).config_).difficulty, 0, 4);
    local oldTarget = radiansToAngle16(math.atan2(f32(((ctx).lateStageBossTargetY_ - (enemy).y)), f32(((ctx).lateStageBossTargetX_ - (enemy).x))));
    if (math.fmod((ctx).frame_, 50) == 0) then
        do
            (ctx).lateStageBossTargetX_ = f32(f32((f32(210) + f32(math.fmod(lateBossFrameRand((ctx).frame_), 301)))));
            (ctx).lateStageBossTargetY_ = f32(f32((f32(150) + f32(math.fmod(lateBossFrameRand((((ctx).selectedStage_ * 111) + (ctx).frame_)), 101)))))
        end
    end;
    if (((ctx).lateStageBossPhaseMode_ == 1) and (((enemy).hp < 1) or ((ctx).lateStageBossCountdown_ < 1))) then
        do
            local countdownExpired = ((ctx).lateStageBossCountdown_ < 1);
            if countdownExpired then
                do
                    ctx:flushEnemyProjectilesToEffects();
                    ((ctx).player_).invulnerableFrames = math.max(((ctx).player_).invulnerableFrames, 100)
                end
            else
                do
                    ctx:spawnPlayerSideObject(24, (enemy).x, (enemy).y, 0, (0 % 65536), 0, f32(0))
                end
            end;
            ctx:spawnBossPhaseBreakFeedback(enemy, (ctx).lateStageBossCountdown_);
            ctx:spawnPostDeathCounterEntity(enemy, 140);
            (enemy).targetable = false;
            (enemy).targetableTimer = 0;
            (enemy).helperTimer = 0;
            (enemy).liveChildCount = 0;
            (enemy).radius = 200;
            do
                local __switch77 = (ctx).lateStageBossBreaksRemaining_
                if __switch77 == 6 then __switch77 = 1
                elseif __switch77 == 5 then __switch77 = 2
                elseif __switch77 == 4 then __switch77 = 3
                elseif __switch77 == 3 then __switch77 = 4
                elseif __switch77 == 2 then __switch77 = 5
                elseif __switch77 == 1 then __switch77 = 6
                else __switch77 = 7 end
                repeat
                    if __switch77 <= 1 then
                        (enemy).helperState = 2;
                        (ctx).lateStageBossPhaseMode_ = 2;
                        do break end;
                    end
                    if __switch77 <= 2 then
                        (enemy).helperState = 4;
                        (ctx).lateStageBossPhaseMode_ = 2;
                        do break end;
                    end
                    if __switch77 <= 3 then
                        (enemy).helperState = 6;
                        (ctx).lateStageBossPhaseMode_ = 2;
                        do break end;
                    end
                    if __switch77 <= 4 then
                        (enemy).helperState = 8;
                        (ctx).lateStageBossPhaseMode_ = 2;
                        do break end;
                    end
                    if __switch77 <= 5 then
                        (enemy).helperState = 10;
                        (ctx).lateStageBossPhaseMode_ = 2;
                        do break end;
                    end
                    if __switch77 <= 6 then
                        (enemy).helperState = 14;
                        (ctx).lateStageBossPhaseMode_ = (-1);
                        (ctx).lateStageClearStarted_ = true;
                        (ctx).lateStageClearTimer_ = 0;
                        ((ctx).player_).invulnerableFrames = math.max(((ctx).player_).invulnerableFrames, 360);
                        do break end;
                    end
                    if __switch77 <= 7 then
                        do break end
                    end
                until true
            end;
            (ctx).lateStageBossBreaksRemaining_ = math.max(0, ((ctx).lateStageBossBreaksRemaining_ - 1));
            (ctx).lateStageBossPhaseIndex_ = (ctx).lateStageBossPhaseIndex_ + 1
        end
    end;
    local steerAndMove = function(speed)
        (enemy).sourceAngle16 = (approachAngle16((enemy).sourceAngle16, oldTarget, 512) % 65536);
        (enemy).angle = f32(f32(fixedAngleRadians((enemy).sourceAngle16)));
        (enemy).sourceSpeed = speed;
        (enemy).speed = f32(f32(speed));
        (enemy).x = f32(f32(((enemy).x + f32((math.cos((enemy).angle) * speed)))));
        (enemy).y = f32(f32(((enemy).y + f32((math.sin((enemy).angle) * speed)))))
    end;
    local openPhase = function(state, hitPoints, countdown, speed, radius, phaseIndex)
        (enemy).helperState = state;
        (enemy).helperTimer = 0;
        (enemy).hp = hitPoints;
        (enemy).maxHp = hitPoints;
        (enemy).drawHp = hitPoints;
        (enemy).sourceSpeed = speed;
        (enemy).speed = f32(f32(speed));
        (enemy).radius = radius;
        (enemy).targetable = true;
        (enemy).targetableTimer = 0;
        (ctx).lateStageBossMaxHp_ = hitPoints;
        (ctx).lateStageBossCountdown_ = countdown;
        (ctx).lateStageBossCountdownDraw_ = countdown;
        (ctx).lateStageBossPhaseIndex_ = phaseIndex;
        (ctx).lateStageBossPhaseMode_ = 1
    end;
    local timer = (enemy).helperTimer;
    do
        local __switch86 = (enemy).helperState
        if __switch86 == 0 then __switch86 = 1
        elseif __switch86 == 1 then __switch86 = 2
        elseif __switch86 == 3 then __switch86 = 3
        elseif __switch86 == 5 then __switch86 = 4
        elseif __switch86 == 7 then __switch86 = 5
        elseif __switch86 == 2 then __switch86 = 6
        elseif __switch86 == 4 then __switch86 = 7
        elseif __switch86 == 6 then __switch86 = 8
        elseif __switch86 == 8 then __switch86 = 9
        elseif __switch86 == 9 then __switch86 = 10
        elseif __switch86 == 10 then __switch86 = 11
        elseif __switch86 == 11 then __switch86 = 12
        elseif __switch86 == 12 then __switch86 = 13
        elseif __switch86 == 13 then __switch86 = 14
        elseif __switch86 == 14 then __switch86 = 15
        else __switch86 = 16 end
        repeat
            if __switch86 <= 1 then
                do
                    if (timer == 0) then
                        do
                            ctx:playPlayerSound((ctx).bossSe9SoundHandle_, 25)
                        end
                    end;
                    if (timer <= 200) then
                        do
                            local entrance = math.sin(((timer * kPi) / 400));
                            (enemy).y = f32(f32((f32(2800) + f32((entrance * f32(((enemy).originY - f32(2800))))))))
                        end
                    else
                        do
                            (enemy).y = f32(f32(((enemy).y + f32(0.100000001))))
                        end
                    end;
                    (enemy).targetable = false;
                    if (timer == 240) then
                        do
                            (openPhase)(1, 60000, 1500, 0.29999999999999999, 175, 0)
                        end
                    end;
                    do break end
                end;
            end
            if __switch86 <= 5 then
                (steerAndMove)(0.29999999999999999);
                ctx:emitStage05BossProjectiles(enemy);
                do break end;
            end
            if __switch86 <= 8 then
                (enemy).targetable = false;
                if (timer == 1) then
                    do
                        ctx:spawnStageEffect(54, (-1), 0, 40, (enemy).x, (enemy).y, (0 % 65536), 0, 1, 1, 0, 255, 255, 255, 255, 0)
                    end
                end;
                if (timer < 90) then
                    do
                        ctx:spawnStage02DeathExplosionChain(enemy);
                        (enemy).y = f32(f32(((enemy).y + f32((f32(timer) * f32(0.0900000035))))))
                    end
                else
                    do
                        (steerAndMove)(0.29999999999999999)
                    end
                end;
                if (timer == 90) then
                    do
                        ctx:playPlayerSound((ctx).blast2SoundHandle_, 25);
                        ctx:spawnStageEffect(17, (-1), 0, 40, (enemy).x, (enemy).y, (0 % 65536), 0, 1, 1, 0, 255, 255, 255, 255, 0)
                    end
                end;
                if (timer == 100) then
                    do
                        (enemy).y = f32(f32(((enemy).y - f32(444))))
                    end
                end;
                if ((timer >= 100) and (timer < 180)) then
                    do
                        (enemy).y = f32(f32(((enemy).y - f32((1 - math.sin((((timer - 100) * kPi) / 280)))))))
                    end
                end;
                if (timer == 180) then
                    do
                        if ((enemy).helperState == 2) then
                            do
                                (openPhase)(3, 55000, 1500, 0.29999999999999999, 175, 1)
                            end
                        else
                            if ((enemy).helperState == 4) then
                                do
                                    (openPhase)(5, 55000, 1500, 0.29999999999999999, 175, 2)
                                end
                            else
                                do
                                    (openPhase)(7, 70000, 1800, 0.29999999999999999, 175, 3)
                                end
                            end
                        end
                    end
                end;
                do break end;
            end
            if __switch86 <= 9 then
                (enemy).targetable = false;
                if (timer < 120) then
                    do
                        ctx:spawnStage02DeathExplosionChain(enemy)
                    end
                end;
                if (timer < 120) then
                    do
                        (enemy).y = f32(f32(((enemy).y + f32((f32(timer) * f32(0.0199999996))))))
                    end
                else
                    if (timer >= 130) then
                        do
                            (steerAndMove)(0.29999999999999999)
                        end
                    end
                end;
                if (timer == 120) then
                    do
                        ctx:playPlayerSound((ctx).blast2SoundHandle_, 25);
                        ctx:spawnStageEffect(17, (-1), 0, 40, (enemy).x, (enemy).y, (0 % 65536), 0, 1, 1, 0, 255, 255, 255, 255, 0)
                    end
                end;
                if (timer == 130) then
                    do
                        (enemy).y = f32(f32(((enemy).y - f32(40))))
                    end
                end;
                if (timer == 210) then
                    do
                        ctx:spawnStage05BossChild(enemy, 84, f32(0), f32(0), (16384 % 65536), 1, 40, 99999999, 0, "S05 FUN_14001c8b0 state 8 timer 210 child 0x54")
                    end
                end;
                if (timer == 380) then
                    do
                        (openPhase)(9, 45000, 1800, 0.29999999999999999, 80, 4)
                    end
                end;
                do break end;
            end
            if __switch86 <= 10 then
                do
                    (steerAndMove)(0.29999999999999999);
                    local kInterval = {60, 40, 36, 36, 30};
                    local kAngles = {(50352 % 65536), (51552 % 65536), (52752 % 65536), (47952 % 65536), (46752 % 65536), (45552 % 65536)};
                    if (timer >= 10) then
                        do
                            local v_local = math.fmod((timer - 10), 700);
                            local interval = (kInterval)[difficulty + 1];
                            if ((v_local < 360) and (math.fmod(v_local, interval) == 0)) then
                                do
                                    do

                                        for _, angle in ipairs(kAngles) do
                                            do
                                                ctx:spawnStage05BossChild(enemy, 85, f32(0), f32((-f32(20))), angle, 6, 25, 10, 2, "S05 FUN_14001c8b0 state 9 child 0x55")
                                            end
                                        end
                                    end;
                                    ctx:playPlayerSound((ctx).bullet2SoundHandle_, 19)
                                end
                            end
                        end
                    end;
                    do break end
                end;
            end
            if __switch86 <= 11 then
                (enemy).targetable = false;
                (enemy).y = f32(f32(((enemy).y + f32(0.100000001))));
                if (timer == 1) then
                    do
                        ctx:playPlayerSound((ctx).enemyDown3SoundHandle_, 25);
                        ctx:spawnStageEffect(54, (-1), 0, 40, (enemy).x, (enemy).y, (0 % 65536), 0, 1, 1, 0, 255, 255, 255, 255, 0)
                    end
                end;
                if (timer < 90) then
                    do
                        ctx:spawnStage02DeathExplosionChain(enemy)
                    end
                end;
                if (timer == 180) then
                    do
                        (openPhase)(11, 80000, 2100, 0.29999999999999999, 200, 5)
                    end
                end;
                do break end;
            end
            if __switch86 <= 12 then
                (steerAndMove)(0.29999999999999999);
                if (timer == 60) then
                    do
                        ctx:spawnStage05BossChild(enemy, 86, f32(90), f32((-f32(30))), (16384 % 65536), 1, 40, 99999999, 1, "S05 FUN_14001c8b0 state 11 timer 60 right 0x56");
                        ctx:spawnStage05BossChild(enemy, 86, f32((-f32(90))), f32((-f32(30))), (16384 % 65536), 1, 40, 99999999, 1, "S05 FUN_14001c8b0 state 11 timer 60 left 0x56");
                        ctx:playPlayerSound((ctx).bossSe1SoundHandle_, 25)
                    end
                end;
                if (timer == 450) then
                    do
                        (enemy).originX = f32((enemy).x);
                        (enemy).originY = f32((enemy).y);
                        (enemy).helperState = 12;
                        (enemy).helperTimer = 0
                    end
                end;
                do break end;
            end
            if __switch86 <= 13 then
                do
                    if (timer == 1) then
                        do
                            (enemy).originX = f32((enemy).x);
                            (enemy).originY = f32((enemy).y);
                            (enemy).markerDrawX = f32(cpp.clamp(((ctx).player_).x, f32(210), f32(510)));
                            (enemy).markerDrawY = f32(cpp.clamp(f32((((ctx).player_).y - f32(320))), f32(200), f32(350)))
                        end
                    end;
                    local t = math.sin(((cpp.clamp(timer, 0, 60) * kPi) / 120));
                    (enemy).x = f32(f32(((enemy).originX + f32((f32(((enemy).markerDrawX - (enemy).originX)) * t)))));
                    (enemy).y = f32(f32(((enemy).originY + f32((f32(((enemy).markerDrawY - (enemy).originY)) * t)))));
                    if (timer == 60) then
                        do
                            (enemy).helperState = 13;
                            (enemy).helperTimer = 0;
                            (enemy).sourceSpeed = 0.10000000000000001;
                            (enemy).speed = f32(f32(0.100000001))
                        end
                    end;
                    do break end
                end;
            end
            if __switch86 <= 14 then
                (steerAndMove)(0.10000000000000001);
                if ((timer >= 40) and (timer < 120)) then
                    do
                        (enemy).y = f32(f32(((enemy).y - f32((math.sin((((timer - 40) * kPi) / 80)) * 2.3999999999999999)))))
                    end
                end;
                if (timer == 780) then
                    do
                        (enemy).helperState = 11;
                        (enemy).helperTimer = 90;
                        (enemy).sourceSpeed = 0.29999999999999999;
                        (enemy).speed = f32(f32(0.300000012))
                    end
                end;
                do break end;
            end
            if __switch86 <= 15 then
                (enemy).targetable = false;
                if (timer < 240) then
                    do
                        (enemy).y = f32(f32(((enemy).y + f32(0.200000003))));
                        ctx:spawnStage02DeathExplosionChain(enemy)
                    end
                end;
                if (timer == 240) then
                    do
                        ctx:playPlayerSound((ctx).blast2SoundHandle_, 25);
                        ctx:spawnStageEffect(16, (-1), 0, 40, (enemy).x, (enemy).y, (0 % 65536), 0, 1, 1, 0, 255, 255, 255, 255, 0)
                    end
                end;
                if (timer >= 480) then
                    do
                        ctx:clearLateStageGate(5);
                        (enemy).active = false
                    end
                end;
                do break end;
            end
            if __switch86 <= 16 then
                do break end
            end
        until true
    end;
    (enemy).drawHp = (enemy).hp;
    (ctx).lateStageBossCountdownDraw_ = (ctx).lateStageBossCountdown_;
    if ((ctx).lateStageBossPhaseMode_ == 1) then
        do
            ctx:updateBossCountdownAudio((enemy).hp, (ctx).lateStageBossCountdown_);
            (ctx).lateStageBossCountdown_ = (ctx).lateStageBossCountdown_ - 1
        end
    end
end

M.spawnStage06BossNode = function(ctx, parent, spawnType, childIndex, offsetX, offsetY, angle16, radius)
    offsetX = f32(offsetX);
    offsetY = f32(offsetY);
    angle16 = (angle16 % 65536);
    if ((not isStage06BossNodeType(spawnType)) or (((#(ctx).enemies_) + (#(ctx).pendingEnemies_)) >= kLateStageEntityCap)) then
        do
            do return false end
        end
    end;
    local updateCase = 0;
    if (spawnType <= 101) then
        updateCase = 74
    else
        if (spawnType <= 106) then
            updateCase = 75
        else
            if (spawnType <= 109) then
                updateCase = 76
            else
                if (spawnType == 110) then
                    updateCase = 77
                else
                    updateCase = 78
                end
            end
        end
    end;
    local node = cpp.newEnemy();
    (node).entityId = (function() local __old = (ctx).nextEntityId_; (ctx).nextEntityId_ = (ctx).nextEntityId_ + 1; return __old end)();
    (node).spawnType = spawnType;
    (node).updateCase = updateCase;
    (node).sourceHitPoints = 99999999;
    (node).sourceX = cpp.lround(offsetX);
    (node).sourceY = cpp.lround(offsetY);
    (node).sourceNote = "S06 FUN_140023260 recovered boss apparatus";
    (node).sourceDispatchKind = 0;
    (node).sourceDispatchField = radius;
    (node).parentEntityId = (parent).entityId;
    (node).parentSpawnType = (parent).spawnType;
    (node).childIndex = childIndex;
    (node).originX = f32(offsetX);
    (node).originY = f32(offsetY);
    (node).sourceAngle16 = (angle16 % 65536);
    (node).secondaryAngle16 = (angle16 % 65536);
    (node).targetAngle16 = (angle16 % 65536);
    (node).angle = f32(f32(fixedAngleRadians(angle16)));
    (node).sourceSpeed = 1;
    (node).speed = f32(f32(1));
    (node).hp = 99999999;
    (node).maxHp = (node).hp;
    (node).drawHp = (node).hp;
    (node).radius = radius;
    (node).activationDelay = 0;
    (node).rewardWeight = 0;
    (node).targetable = false;
    if (spawnType == 110) then
        do
            (node).x = f32(f32(((parent).x + offsetX)));
            (node).y = f32(f32(((parent).y + offsetY)))
        end
    else
        do
            local radians = fixedAngleRadians(angle16);
            (node).x = f32(f32(((parent).x + f32((math.cos(radians) * offsetX)))));
            (node).y = f32(f32((f32(((parent).y + f32((math.sin(radians) * offsetX)))) + offsetY)))
        end
    end;
    (node).markerDrawX = f32((node).x);
    (node).markerDrawY = f32((node).y);
    cpp.push((ctx).pendingEnemies_, node);
    if ((spawnType >= 102) and (spawnType <= 106)) then
        do
            (parent).liveChildCount = (parent).liveChildCount + 1
        end
    end;
    do return true end
end

M.updateStage06BossNode = function(ctx, enemy)
    (enemy).vx = f32(f32(0));
    (enemy).vy = f32(f32(0));
    (enemy).drawMarkerThisFrame = false;
    (enemy).drawBodyThisFrame = true;
    (enemy).drawHp = (enemy).hp;
    local parent = ctx:findEnemyById((enemy).parentEntityId);
    local release = function(destroyed)
        if destroyed then
            do
                ctx:spawnEnemyDeathRewardBurst(enemy, 3000, false);
                ctx:spawnEnemyDeathEffects(enemy, 1, true);
                if (((parent ~= nil) and ((enemy).spawnType >= 102)) and ((enemy).spawnType <= 106)) then
                    do
                        ctx:spawnDelayedOwnerDamageNode(20000, (parent).entityId, (parent).spawnType, "S06 destructible arm delayed-damage node 0x153")
                    end
                end
            end
        end;
        if ((((parent ~= nil) and ((enemy).spawnType >= 102)) and ((enemy).spawnType <= 106)) and ((parent).liveChildCount > 0)) then
            do
                (parent).liveChildCount = (parent).liveChildCount - 1
            end
        end;
        (enemy).targetable = false;
        (enemy).active = false
    end;
    if (((parent == nil) or (not (parent).active)) or ((parent).spawnType ~= (enemy).parentSpawnType)) then
        do
            (release)(false);
            do return end
        end
    end;
    local timer = (enemy).helperTimer;
    local difficulty = cpp.clamp(((ctx).config_).difficulty, 0, 4);
    local aimAtPlayer = function()
        do return radiansToAngle16(math.atan2(f32((((ctx).player_).y - (enemy).y)), f32((((ctx).player_).x - (enemy).x)))) end
    end;
    local fired = false;
    if (((enemy).spawnType == 100) or ((enemy).spawnType == 101)) then
        do
            if (((parent).helperState > 4) or (((parent).helperState == 4) and ((parent).helperTimer >= 130))) then
                do
                    (release)(false);
                    do return end
                end
            end;
            if ((enemy).spawnType == 100) then
                do
                    if ((((parent).helperState == 1) or ((parent).helperState == 2)) and (math.fmod((timer + 20), 60) > 39)) then
                        do
                            (enemy).sourceAngle16 = (normalizeAngle16(((enemy).sourceAngle16 + 273)) % 65536)
                        end
                    else
                        if (((parent).helperState > 2) and (math.fmod(timer, 30) > 19)) then
                            do
                                (enemy).sourceAngle16 = (normalizeAngle16(((enemy).sourceAngle16 + 546)) % 65536)
                            end
                        end
                    end
                end
            end;
            local radians = fixedAngleRadians((enemy).sourceAngle16);
            (enemy).x = f32(f32(((parent).x + f32((math.cos(radians) * (enemy).originX)))));
            (enemy).y = f32(f32(((parent).y + f32((math.sin(radians) * (enemy).originX)))));
            if ((enemy).spawnType == 101) then
                do
                    local playerAngle = (aimAtPlayer)();
                    local playerRadians = fixedAngleRadians(playerAngle);
                    (enemy).x = f32(f32(((enemy).x + f32((math.cos(playerRadians) * 24)))));
                    (enemy).y = f32(f32(((enemy).y + f32((math.sin(playerRadians) * 24)))))
                end
            end;
            if ((((parent).helperState == 3) and ((parent).helperTimer == 30)) and ((enemy).liveChildCount == 0)) then
                do
                    if ctx:spawnStage06BossNode(enemy, (function() if ((enemy).spawnType == 100) then return 108 else return 109 end end)(), 0, f32(0), f32(0), (0 % 65536), 50) then
                        do
                            (enemy).liveChildCount = 1
                        end
                    end
                end
            end;
            do return end
        end
    end;
    if (((enemy).spawnType >= 102) and ((enemy).spawnType <= 106)) then
        do
            if (((parent).helperState > 1) or ((ctx).lateStageBossCountdown_ < 1)) then
                do
                    (release)(false);
                    do return end
                end
            end;
            if (((enemy).helperState == 0) and ((parent).helperState == 1)) then
                do
                    (enemy).helperState = 1;
                    (enemy).helperTimer = 0;
                    timer = 0;
                    (enemy).hp = 33000;
                    (enemy).maxHp = 33000;
                    (enemy).drawHp = 33000;
                    (enemy).targetable = true;
                    (enemy).targetableTimer = 0
                end
            end;
            if ((enemy).helperState == 0) then
                do
                    if (timer == 0) then
                        do
                            (enemy).originX = f32(f32(980));
                            if ((enemy).spawnType == 103) then
                                (enemy).sourceAngle16 = ((55818 % 65536) % 65536)
                            end;
                            if ((enemy).spawnType == 106) then
                                (enemy).sourceAngle16 = ((42486 % 65536) % 65536)
                            end
                        end
                    end;
                    if ((timer >= 0) and (timer < 31)) then
                        do
                            (enemy).originX = f32(f32(((enemy).originX - f32(40))))
                        end
                    end;
                    local introRadians = fixedAngleRadians((enemy).sourceAngle16);
                    (enemy).x = f32(f32(((parent).x + f32((math.cos(introRadians) * (enemy).originX)))));
                    (enemy).y = f32(f32(((parent).y + f32((math.sin(introRadians) * (enemy).originX)))));
                    do return end
                end
            end;
            local brokenArmCount = cpp.clamp((5 - (parent).liveChildCount), 0, 5);
            local period = math.max(225, ((8 - brokenArmCount) * 75));
            local mountRadians = fixedAngleRadians((enemy).sourceAngle16);
            (enemy).x = f32(f32(((parent).x + f32((math.cos(mountRadians) * 180)))));
            (enemy).y = f32(f32(((parent).y + f32((math.sin(mountRadians) * 180)))));
            if ((enemy).hp < 1) then
                do
                    (release)(true);
                    do return end
                end
            end;
            if (((enemy).spawnType == 102) and (timer >= 120)) then
                do
                    local kShotPeriod = {24, 21, 21, 21, 21};
                    local kBurstWidth = {9, 15, 18, 21, 24};
                    local kAngleStep = {200, 160, 140, 130, 130};
                    local kRingBase = {2, 3, 4, 5, 5};
                    local kSpeed = {3.2000000000000002, 4, 4.5, 5, 6};
                    local v_local = math.fmod((timer - 120), period);
                    local shotPhase = math.fmod(v_local, (kShotPeriod)[difficulty + 1]);
                    if (v_local == 0) then
                        do
                            (enemy).secondaryAngle16 = (normalizeAngle16(((aimAtPlayer)() - 16384)) % 65536)
                        end
                    end;
                    local turn = (kAngleStep)[difficulty + 1];
                    (enemy).secondaryAngle16 = (normalizeAngle16(((enemy).secondaryAngle16 + (function() if (v_local > 149) then return (-turn) else return turn end end)())) % 65536);
                    local count = ((kRingBase)[difficulty + 1] + brokenArmCount);
                    if (brokenArmCount == 4) then
                        count = count - 1
                    end;
                    if (((v_local < 300) and (shotPhase < (kBurstWidth)[difficulty + 1])) and (math.fmod(shotPhase, 3) == 0)) then
                        do
                            local speed = (((kSpeed)[difficulty + 1] + (shotPhase * 0.14999999999999999)) + (brokenArmCount * 0.5));
                            ctx:spawnProjectileSpread(10, 0, (enemy).x, (enemy).y, (enemy).secondaryAngle16, f32(10), speed, 1, count, 65536, 0);
                            if (brokenArmCount == 4) then
                                do
                                    ctx:spawnProjectileSpread(11, 0, (enemy).x, (enemy).y, normalizeAngle16(((enemy).secondaryAngle16 + trunc(65536 / math.max(1, (count * 2))))), f32(10), speed, 1, count, 65536, 0)
                                end
                            end;
                            fired = true
                        end
                    end;
                    (enemy).sourceAngle16 = (normalizeAngle16(((enemy).sourceAngle16 + 66)) % 65536)
                end
            else
                if (((enemy).spawnType == 103) and (timer >= 240)) then
                    do
                        local kInterval = {70, 41, 35, 33, 30};
                        local kCount = {3, 5, 7, 9, 11};
                        local kSpread = {5000, 3800, 3300, 3000, 2700};
                        local kSpeed = {3, 3.6000000000000001, 4, 4.2000000000000002, 4.7999999999999998};
                        local v_local = math.fmod((timer - 240), period);
                        local aimed = (aimAtPlayer)();
                        local wave = trunc((math.sin((((timer * 516.03149606299212) * kPi) / 32768)) * 4321));
                        local target = normalizeAngle16((aimed + wave));
                        local delta = (target - (enemy).sourceAngle16);
                        delta = (bit.band((delta + 32768), 65535) - 32768);
                        (enemy).sourceAngle16 = (approachAngle16((enemy).sourceAngle16, target, (trunc(math.abs(delta) / 20) + 48)) % 65536);
                        local cadence = math.max(1, ((kInterval)[difficulty + 1] - (brokenArmCount * 4)));
                        if ((v_local < 300) and (math.fmod(v_local, cadence) == 0)) then
                            do
                                local radians = fixedAngleRadians((enemy).sourceAngle16);
                                local fireX = f32(((enemy).x + f32((math.cos(radians) * 70))));
                                local fireY = f32(((enemy).y + f32((math.sin(radians) * 70))));
                                ctx:spawnProjectileSpread(3, 0, fireX, fireY, (enemy).sourceAngle16, f32(10), (((kSpeed)[difficulty + 1] + (v_local * 0.0060000000000000001)) + (brokenArmCount * 0.20000000000000001)), 1, ((kCount)[difficulty + 1] + (brokenArmCount * 2)), ((((kCount)[difficulty + 1] + (brokenArmCount * 2)) - 1) * (kSpread)[difficulty + 1]), 0);
                                fired = true
                            end
                        end
                    end
                else
                    if (((enemy).spawnType == 104) and (timer >= 360)) then
                        do
                            local kInterval = {16, 10, 8, 8, 7};
                            local kAngleStep = {130, 170, 190, 200, 240};
                            local kSpeed = {2.7999999999999998, 3.5, 3.7999999999999998, 4, 5};
                            local v_local = math.fmod((timer - 360), period);
                            local cadence = math.max(1, ((kInterval)[difficulty + 1] - brokenArmCount));
                            if ((v_local < 300) and (math.fmod(v_local, cadence) == 0)) then
                                do
                                    do
                                        local quadrant = 0
                                        while (quadrant < 4) do
                                            do
                                                local sourceAngle = normalizeAngle16(((enemy).sourceAngle16 + (quadrant * 16384)));
                                                local radians = fixedAngleRadians(sourceAngle);
                                                local fireX = f32(((enemy).x + f32((math.cos(radians) * 55))));
                                                local fireY = f32(((enemy).y + f32((math.sin(radians) * 55))));
                                                local angle = normalizeAngle16((((enemy).sourceAngle16 + (quadrant * 16384)) + ((kAngleStep)[difficulty + 1] * timer)));
                                                local speed = ((kSpeed)[difficulty + 1] + (brokenArmCount * 0.40000000000000002));
                                                ctx:spawnProjectileNode(7, 0, fireX, fireY, angle, f32(10), speed, 1, 0);
                                                if (difficulty > 2) then
                                                    do
                                                        ctx:spawnProjectileNode(7, 0, fireX, fireY, angle, f32(10), (speed + 1.2), 1, 0)
                                                    end
                                                end;
                                                if (brokenArmCount == 4) then
                                                    do
                                                        local extraAngle = normalizeAngle16((angle + 6660));
                                                        ctx:spawnProjectileNode(7, 0, fireX, fireY, extraAngle, f32(10), speed, 1, 0);
                                                        if (difficulty > 2) then
                                                            do
                                                                ctx:spawnProjectileNode(7, 0, fireX, fireY, extraAngle, f32(10), (speed + 1.2), 1, 0)
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            quadrant = quadrant + 1
                                        end
                                    end;
                                    fired = true
                                end
                            end;
                            (enemy).sourceAngle16 = (normalizeAngle16(((enemy).sourceAngle16 + 99)) % 65536)
                        end
                    else
                        if (((enemy).spawnType == 105) and (timer >= 480)) then
                            do
                                local kInterval = {17, 11, 10, 10, 9};
                                local kPairs = {1, 2, 3, 4, 5};
                                local kAngleStep = {150, 240, 270, 300, 340};
                                local kSpeed = {2.7999999999999998, 3.5, 3.7999999999999998, 4, 5};
                                local v_local = math.fmod((timer - 480), period);
                                local cadence = math.max(1, ((kInterval)[difficulty + 1] - brokenArmCount));
                                (enemy).sourceAngle16 = (normalizeAngle16(trunc((math.sin((((timer * 422.81290322580645) * kPi) / 32768)) * 2444))) % 65536);
                                if ((v_local < 300) and (math.fmod(v_local, cadence) == 0)) then
                                    do
                                        local pairCount = ((kPairs)[difficulty + 1] + (function() if (brokenArmCount == 4) then return 2 else return 0 end end)());
                                        local rootRadians = fixedAngleRadians((enemy).sourceAngle16);
                                        local ellipsePoint = function(orbitAngle)
                                            orbitAngle = (orbitAngle % 65536);
                                            local orbit = fixedAngleRadians(orbitAngle);
                                            local px = f32(((enemy).x + f32((((math.cos(rootRadians) * math.cos(orbit)) * 90) - ((math.sin(rootRadians) * math.sin(orbit)) * 25)))));
                                            local py = f32(((enemy).y + f32((((math.cos(rootRadians) * math.sin(orbit)) * 25) + ((math.sin(rootRadians) * math.cos(orbit)) * 90)))));
                                            do return {px, py} end
                                        end;
                                        local orbitBase = ((kAngleStep)[difficulty + 1] * timer);
                                        local first = (ellipsePoint)(normalizeAngle16(orbitBase));
                                        local second = (ellipsePoint)(normalizeAngle16((orbitBase + 32768)));
                                        do
                                            local i = 0
                                            while (i < pairCount) do
                                                do
                                                    local speed = (((kSpeed)[difficulty + 1] + (brokenArmCount * 0.40000000000000002)) + (i * 0.40000000000000002));
                                                    ctx:spawnProjectileNode(4, 0, (first)[1], (first)[2], normalizeAngle16(((orbitBase + (i * 3333)) - 32768)), f32(0), speed, 1, 0);
                                                    ctx:spawnProjectileNode(4, 0, (second)[1], (second)[2], normalizeAngle16((orbitBase + (i * 3333))), f32(0), speed, 1, 0)
                                                end
                                                i = i + 1
                                            end
                                        end;
                                        fired = true
                                    end
                                end
                            end
                        else
                            if ((enemy).spawnType == 106) then
                                do
                                    local kInterval = {90, 60, 55, 50, 50};
                                    local kBurstWidth = {16, 16, 20, 24, 28};
                                    local kSpeed = {5, 6, 6.5, 7, 9};
                                    local v_local = math.fmod(timer, period);
                                    local oldRadians = fixedAngleRadians((enemy).sourceAngle16);
                                    local fireX = f32(((enemy).x + f32((math.cos(oldRadians) * 80))));
                                    local fireY = f32(((enemy).y + f32((math.sin(oldRadians) * 80))));
                                    local aimed = radiansToAngle16(math.atan2(f32((((ctx).player_).y - fireY)), f32((((ctx).player_).x - fireX))));
                                    local cadence = (kInterval)[difficulty + 1];
                                    if (math.fmod(v_local, cadence) == 0) then
                                        do
                                            (enemy).secondaryAngle16 = (aimed % 65536)
                                        end
                                    end;
                                    (enemy).sourceAngle16 = (normalizeAngle16((trunc((math.sin((((timer * 422.81290322580645) * kPi) / 32768)) * 2444)) - 23050)) % 65536);
                                    local shotPhase = math.fmod(v_local, cadence);
                                    if (((v_local < 300) and (shotPhase < ((kBurstWidth)[difficulty + 1] + (brokenArmCount * 4)))) and (math.fmod(shotPhase, 4) == 0)) then
                                        do
                                            local layer = trunc(shotPhase / 4);
                                            local count = (layer + 1);
                                            local spread = (layer * ((brokenArmCount * 40) + 300));
                                            local speed = ((kSpeed)[difficulty + 1] + (brokenArmCount * 0.69999999999999996));
                                            ctx:spawnProjectileSpread(9, 0, fireX, fireY, (enemy).secondaryAngle16, f32(10), speed, 1, count, spread, 0);
                                            if (brokenArmCount == 4) then
                                                do
                                                    ctx:spawnProjectileSpread(9, 0, fireX, fireY, normalizeAngle16(((enemy).secondaryAngle16 + 7000)), f32(10), speed, 1, count, spread, 0);
                                                    ctx:spawnProjectileSpread(9, 0, fireX, fireY, normalizeAngle16(((enemy).secondaryAngle16 - 7000)), f32(10), speed, 1, count, spread, 0)
                                                end
                                            end;
                                            fired = true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        if ((enemy).spawnType == 107) then
            do
                if ((parent).helperState ~= 3) then
                    do
                        (release)(false);
                        do return end
                    end
                end;
                local radians = fixedAngleRadians((enemy).sourceAngle16);
                (enemy).x = f32(f32(((parent).x + f32((math.cos(radians) * (enemy).originX)))));
                (enemy).y = f32(f32(((parent).y + f32((math.sin(radians) * (enemy).originX)))));
                local kWindow = {40, 55, 65, 75, 65};
                local kCount = {5, 7, 7, 7, 9};
                local kSpeed = {5.5, 6.4000000000000004, 7, 7, 8};
                if (timer < 300) then
                    do
                        local v_local = math.fmod(timer, 100);
                        if (v_local == 0) then
                            (enemy).secondaryAngle16 = ((aimAtPlayer)() % 65536)
                        end;
                        if ((v_local < (kWindow)[difficulty + 1]) and (math.fmod(v_local, 5) == 0)) then
                            do
                                local speed = ((kSpeed)[difficulty + 1] + (timer * 0.0040000000000000001));
                                ctx:spawnProjectileSpread(10, 0, (enemy).x, (enemy).y, normalizeAngle16(((enemy).secondaryAngle16 + 300)), f32(10), speed, 1, (kCount)[difficulty + 1], 30000, 0);
                                ctx:spawnProjectileSpread(10, 0, (enemy).x, (enemy).y, normalizeAngle16(((enemy).secondaryAngle16 - 300)), f32(10), speed, 1, (kCount)[difficulty + 1], 30000, 0);
                                fired = true
                            end
                        end
                    end
                end;
                if (timer >= 600) then
                    do
                        local kFinalSpread = {8200, 7000, 6600, 6000, 5500};
                        local kSweepPeriod = {320, 280, 240, 240, 240};
                        if (timer == 600) then
                            (enemy).secondaryAngle16 = ((aimAtPlayer)() % 65536)
                        end;
                        if (timer < 750) then
                            do
                                local delta = (16384 - (enemy).secondaryAngle16);
                                delta = (bit.band((delta + 32768), 65535) - 32768);
                                (enemy).secondaryAngle16 = (approachAngle16((enemy).secondaryAngle16, (16384 % 65536), trunc(math.abs(delta) / 120)) % 65536)
                            end
                        end;
                        local center = (enemy).secondaryAngle16;
                        if (timer > 749) then
                            do
                                local periodValue = (kSweepPeriod)[difficulty + 1];
                                local phase = math.fmod(((trunc(periodValue / 4) + timer) - 750), periodValue);
                                local slope = trunc(12000 / trunc(periodValue / 2));
                                center = (center + ((function() if (phase < trunc(periodValue / 2)) then return (phase * slope) else return ((periodValue - phase) * slope) end end)() - 6000))
                            end
                        end;
                        if ((enemy).y > ((ctx).player_).y) then
                            center = (center + 32768)
                        end;
                        if ((timer > 601) and (math.fmod((timer - 602), 5) == 0)) then
                            do
                                local spread = ((kFinalSpread)[difficulty + 1] * 3);
                                if (timer < 750) then
                                    do
                                        spread = (spread + (trunc((65530 - ((kFinalSpread)[difficulty + 1] * 3)) / 150) * (750 - timer)))
                                    end
                                end;
                                ctx:spawnProjectileSpread(11, 0, (enemy).x, (enemy).y, normalizeAngle16(center), f32(10), 12, 1, 4, spread, 0);
                                fired = true
                            end
                        end
                    end
                end
            end
        else
            if (((enemy).spawnType == 108) or ((enemy).spawnType == 109)) then
                do
                    if (((parent).spawnType ~= 100) and ((parent).spawnType ~= 101)) then
                        do
                            (release)(false);
                            do return end
                        end
                    end;
                    (enemy).x = f32((parent).x);
                    (enemy).y = f32((parent).y);
                    if (((enemy).spawnType == 108) and (timer < 300)) then
                        do
                            local kCadence = {9, 5, 4, 5, 4};
                            local kBaseCount = {1, 2, 3, 3, 3};
                            local kSpeed = {3.3999999999999999, 4, 4.4000000000000004, 4, 5};
                            local half = math.fmod(timer, 150);
                            (enemy).secondaryAngle16 = (normalizeAngle16((function() if (half < 75) then return ((timer * 436) + (trunc(timer / 150) * 136)) else return (((timer * (-436)) + (trunc(timer / 150) * (-136))) - 136) end end)()) % 65536);
                            if (math.fmod(timer, (kCadence)[difficulty + 1]) == 0) then
                                do
                                    local count = ((kBaseCount)[difficulty + 1] + trunc(timer / 75));
                                    local speed = (((kSpeed)[difficulty + 1] + (math.fmod(timer, 75) * 0.029999999999999999)) + (trunc(timer / 75) * 0.40000000000000002));
                                    ctx:spawnProjectileSpread(3, 0, (enemy).x, (enemy).y, (enemy).secondaryAngle16, f32(10), speed, 1, count, 65536, 0);
                                    if (difficulty > 2) then
                                        do
                                            ctx:spawnProjectileSpread(3, 0, (enemy).x, (enemy).y, normalizeAngle16(((enemy).secondaryAngle16 + (function() if (half < 75) then return (-1200) else return 1200 end end)())), f32(10), (speed + 1.2), 1, count, 65536, 0)
                                        end
                                    end;
                                    fired = true
                                end
                            end
                        end
                    end;
                    local kMiddleCadence = {35, 27, 24, 22, 18};
                    if (((timer >= 320) and (timer < 600)) and (math.fmod((timer - 320), (kMiddleCadence)[difficulty + 1]) == 0)) then
                        do
                            local kRingCount = {7, 9, 9, 8, 9};
                            local kLayerCount = {3, 4, 5, 6, 6};
                            local kSpeed = {4.7999999999999998, 5.4000000000000004, 6, 6.5, 7.7000000000000001};
                            local random = lateStageScriptRand((timer + (function() if ((enemy).spawnType == 109) then return 1 else return 0 end end)()));
                            local randomAngle = u32((random - trunc(random / 65537)));
                            do
                                local layer = 0
                                while (layer < (kLayerCount)[difficulty + 1]) do
                                    do
                                        local direction = (function() if ((enemy).spawnType == 108) then return 1 else return (-1) end end)();
                                        ctx:spawnProjectileSpread((function() if ((enemy).spawnType == 108) then return 5 else return 4 end end)(), 0, (enemy).x, (enemy).y, normalizeAngle16((((direction * layer) * 600) + randomAngle)), f32(0), (kSpeed)[difficulty + 1], 1, (kRingCount)[difficulty + 1], 65536, 0)
                                    end
                                    layer = layer + 1
                                end
                            end;
                            fired = true
                        end
                    end;
                    if (timer >= 770) then
                        do
                            local kCadence = {75, 45, 39, 36, 30};
                            local kCount = {1, 3, 3, 5, 5};
                            local kSpeed = {5.5, 6.5999999999999996, 7.2000000000000002, 7.7000000000000001, 9};
                            local cadence = (kCadence)[difficulty + 1];
                            local start = (770 + (function() if ((enemy).spawnType == 108) then return cadence else return 0 end end)());
                            if (timer >= start) then
                                do
                                    local v_local = (timer - start);
                                    local phase = math.fmod(v_local, (cadence * 2));
                                    if (phase == 0) then
                                        (enemy).secondaryAngle16 = ((aimAtPlayer)() % 65536)
                                    end;
                                    if ((phase < 12) and (math.fmod(phase, 4) == 0)) then
                                        do
                                            local count = (kCount)[difficulty + 1];
                                            ctx:spawnProjectileSpread(12, 0, (enemy).x, (enemy).y, (enemy).secondaryAngle16, f32(10), (kSpeed)[difficulty + 1], 1, count, ((count * 2400) - 2400), 0);
                                            fired = true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            else
                if ((enemy).spawnType == 110) then
                    do
                        if ((parent).hp < 1) then
                            do
                                ctx:spawnEnemyDeathEffects(enemy, 1, true);
                                (release)(false);
                                do return end
                            end
                        end;
                        local kRouteX = {f32(100), f32((-f32(100))), f32(210), f32((-f32(210)))};
                        local kRouteY = {f32((-f32(120))), f32((-f32(120))), f32((-f32(70))), f32((-f32(70)))};
                        local kAimOffset = {(-2000), 2000, (-4000), 4000};
                        local route = cpp.clamp((enemy).childIndex, 0, 3);
                        local moveToward = function(targetX, targetY)
                            targetX = f32(targetX);
                            targetY = f32(targetY);
                            local dx = f32((targetX - (enemy).x));
                            local dy = f32((targetY - (enemy).y));
                            local distance = math.sqrt(((dx * dx) + (dy * dy)));
                            (enemy).sourceSpeed = (distance / 10);
                            (enemy).speed = f32(f32((enemy).sourceSpeed));
                            (enemy).x = f32(f32(((enemy).x + f32((dx * f32(0.100000001))))));
                            (enemy).y = f32(f32(((enemy).y + f32((dy * f32(0.100000001))))))
                        end;
                        local angleTo = function(fromX, fromY, toX, toY)
                            fromX = f32(fromX);
                            fromY = f32(fromY);
                            toX = f32(toX);
                            toY = f32(toY);
                            do return radiansToAngle16(math.atan2(f32((toY - fromY)), f32((toX - fromX)))) end
                        end;
                        local aimFrom = function(x, y)
                            x = f32(x);
                            y = f32(y);
                            do return (angleTo)(x, y, ((ctx).player_).x, ((ctx).player_).y) end
                        end;
                        local clampTrackedPoint = function(x, y)
                            x = f32(x);
                            y = f32(y);
                            local horizontalOrigin = f32((((ctx).player_).x / f32(6)));
                            do return {cpp.clamp(x, f32((horizontalOrigin + f32(180))), f32((horizontalOrigin + f32(420)))), cpp.clamp(y, f32(180), f32(540))} end
                        end;
                        local angleDelta = ((enemy).secondaryAngle16 - (enemy).sourceAngle16);
                        angleDelta = (bit.band((angleDelta + 32768), 65535) - 32768);
                        (enemy).sourceAngle16 = (approachAngle16((enemy).sourceAngle16, (enemy).secondaryAngle16, (trunc(math.abs(angleDelta) / 10) + 128)) % 65536);
                        (enemy).angle = f32(f32(fixedAngleRadians((enemy).sourceAngle16)));
                        local routeX = f32(((parent).x + (kRouteX)[route + 1]));
                        local routeY = f32(((parent).y + (kRouteY)[route + 1]));
                        if ((enemy).helperState == 0) then
                            do
                                if (timer == 0) then
                                    do
                                        (enemy).x = f32(f32(((parent).x - f32(33))));
                                        (enemy).y = f32(f32(((parent).y - f32(83))))
                                    end
                                else
                                    do
                                        (moveToward)(routeX, routeY)
                                    end
                                end
                            end
                        end;
                        local enteredAttackThisFrame = false;
                        if (((enemy).helperState == 0) and (timer == 40)) then
                            do
                                (enemy).helperState = 1;
                                (enemy).helperTimer = 0;
                                timer = 0;
                                enteredAttackThisFrame = true
                            end
                        end;
                        if ((enemy).helperState == 1) then
                            do
                                local cycle = math.fmod(timer, 1200);
                                local targetX = routeX;
                                local targetY = routeY;
                                if ((cycle >= 400) and (cycle < 660)) then
                                    do
                                        if (cycle == 400) then
                                            do
                                                local tracked = (clampTrackedPoint)(((ctx).player_).x, ((ctx).player_).y);
                                                (enemy).markerDrawX = f32((tracked)[1]);
                                                (enemy).markerDrawY = f32((tracked)[2])
                                            end
                                        end;
                                        local trackedAngle = (angleTo)((enemy).x, (enemy).y, (enemy).markerDrawX, (enemy).markerDrawY);
                                        local trackedRadians = fixedAngleRadians(trackedAngle);
                                        targetX = f32(f32(((enemy).markerDrawX + f32((math.cos(trackedRadians) * 250)))));
                                        targetY = f32(f32(((enemy).markerDrawY + f32((math.sin(trackedRadians) * 250)))));
                                        local playerAngle = (aimFrom)((enemy).markerDrawX, (enemy).markerDrawY);
                                        local playerRadians = fixedAngleRadians(playerAngle);
                                        (enemy).markerDrawX = f32(f32(((enemy).markerDrawX + f32((math.cos(playerRadians) * 0.5)))));
                                        (enemy).markerDrawY = f32(f32(((enemy).markerDrawY + f32((math.sin(playerRadians) * 0.5)))));
                                        local tracked = (clampTrackedPoint)((enemy).markerDrawX, (enemy).markerDrawY);
                                        (enemy).markerDrawX = f32((tracked)[1]);
                                        (enemy).markerDrawY = f32((tracked)[2])
                                    end
                                else
                                    if ((cycle >= 660) and (cycle < 1160)) then
                                        do
                                            local kOrbitStep = {80, 140, 160, 140, 160};
                                            if (cycle == 660) then
                                                do
                                                    (enemy).targetAngle16 = (normalizeAngle16(((route * 16384) + 8192)) % 65536)
                                                end
                                            end;
                                            local orbitDelta = trunc((math.sin((((timer - 660) * kPi) / 1000)) * (kOrbitStep)[difficulty + 1]));
                                            (enemy).targetAngle16 = (normalizeAngle16(((enemy).targetAngle16 + orbitDelta)) % 65536);
                                            local wobbleAngle = normalizeAngle16(trunc((math.sin(((timer * kPi) / 90)) * 2000)));
                                            local orbitRadians = fixedAngleRadians((enemy).targetAngle16);
                                            local wobbleRadians = fixedAngleRadians(wobbleAngle);
                                            local wobbleCos = math.cos(wobbleRadians);
                                            local wobbleSin = math.sin(wobbleRadians);
                                            local orbitCos = math.cos(orbitRadians);
                                            local orbitSin = math.sin(orbitRadians);
                                            targetX = f32(f32(((parent).x + f32((((wobbleCos * orbitCos) * 240) - ((wobbleSin * orbitSin) * 110))))));
                                            targetY = f32(f32(((parent).y + f32((((wobbleCos * orbitSin) * 110) + ((wobbleSin * orbitCos) * 240))))));
                                            (enemy).secondaryAngle16 = ((aimFrom)((parent).x, f32((-f32(720)))) % 65536)
                                        end
                                    end
                                end;
                                if (not enteredAttackThisFrame) then
                                    do
                                        (moveToward)(targetX, targetY)
                                    end
                                end;
                                local bodyRadians = fixedAngleRadians((enemy).sourceAngle16);
                                local muzzleX = f32(((enemy).x + f32((math.cos(bodyRadians) * 38))));
                                local muzzleY = f32(((enemy).y + f32((math.sin(bodyRadians) * 38))));
                                if ((cycle < 240) or (cycle > 1160)) then
                                    do
                                        local kCadence = {120, 90, 60, 50, 50};
                                        local start = (function() if (route < 2) then return 10 else return 30 end end)();
                                        (enemy).secondaryAngle16 = (normalizeAngle16(((aimFrom)(routeX, routeY) + (kAimOffset)[route + 1])) % 65536);
                                        if (((cycle >= start) and (cycle < 240)) and (math.fmod((cycle - start), (kCadence)[difficulty + 1]) == 0)) then
                                            do
                                                ctx:spawnProjectileNode(2, (29 + bit.band(route, 1)), muzzleX, muzzleY, (enemy).sourceAngle16, f32(10), 12, 1, 0);
                                                fired = true
                                            end
                                        end
                                    end
                                end;
                                if ((cycle >= 250) and (cycle < 390)) then
                                    do
                                        local kCount = {3, 5, 7, 9, 9};
                                        if (cycle < 270) then
                                            do
                                                (enemy).secondaryAngle16 = ((aimFrom)((enemy).x, (enemy).y) % 65536)
                                            end
                                        end;
                                        if ((cycle >= 273) and (math.fmod((cycle - 273), 3) == 0)) then
                                            do
                                                ctx:spawnProjectileSpread(6, 0, muzzleX, muzzleY, (enemy).sourceAngle16, f32(10), 6, 1, (kCount)[difficulty + 1], ((cycle * (-320)) + 136400), 0);
                                                fired = true
                                            end
                                        end
                                    end
                                end;
                                if ((cycle >= 400) and (cycle < 660)) then
                                    do
                                        local kTurn = {250, 350, 420, 420, 480};
                                        local kSpeed = {3, 3.6000000000000001, 4.7999999999999998, 6, 7.5};
                                        (enemy).secondaryAngle16 = (normalizeAngle16(((((kTurn)[difficulty + 1] * timer) + (route * 16384)) - 32768)) % 65536);
                                        if (((cycle >= 450) and (cycle < 600)) and (math.fmod((cycle - 450), 3) == 0)) then
                                            do
                                                local aimed = (angleTo)(muzzleX, muzzleY, (enemy).markerDrawX, (enemy).markerDrawY);
                                                local speed = (kSpeed)[difficulty + 1];
                                                if ((difficulty > 2) or (bit.band(route, 1) ~= 0)) then
                                                    do
                                                        ctx:spawnProjectileNode(7, 3, muzzleX, muzzleY, aimed, f32(0), speed, 1, 0)
                                                    end
                                                end;
                                                ctx:spawnProjectileNode(7, 3, muzzleX, muzzleY, normalizeAngle16((aimed + 21846)), f32(0), speed, 1, 0);
                                                ctx:spawnProjectileNode(7, 3, muzzleX, muzzleY, normalizeAngle16((aimed + 43691)), f32(0), speed, 1, 0);
                                                fired = true
                                            end
                                        end
                                    end
                                end;
                                if ((cycle >= 660) and (cycle < 1160)) then
                                    do
                                        local kBurstPeriod = {60, 40, 40, 48, 40};
                                        local kBurstWidth = {16, 20, 24, 20, 24};
                                        local kPrimarySpeed = {3.2000000000000002, 3.6000000000000001, 4, 4, 5};
                                        local kSecondaryPeriod = {120, 100, 90, 90, 90};
                                        local kSecondaryCount = {6, 8, 9, 8, 9};
                                        local kSecondarySpeed = {3.7999999999999998, 4.5, 5, 5, 6};
                                        if ((cycle >= 700) and (cycle < 1150)) then
                                            do
                                                local burst = math.fmod((cycle - 700), (kBurstPeriod)[difficulty + 1]);
                                                if ((burst < (kBurstWidth)[difficulty + 1]) and (math.fmod(burst, 4) == 0)) then
                                                    do
                                                        local count = (function() if (difficulty > 2) then return 2 else return 1 end end)();
                                                        local speed = (kPrimarySpeed)[difficulty + 1];
                                                        ctx:spawnProjectileSpread(2, 1, muzzleX, muzzleY, (enemy).sourceAngle16, f32(10), speed, 1, count, 3000, 0);
                                                        ctx:spawnProjectileNode(2, 1, muzzleX, muzzleY, normalizeAngle16(((enemy).sourceAngle16 + 21846)), f32(0), speed, 1, 0);
                                                        ctx:spawnProjectileNode(2, 1, muzzleX, muzzleY, normalizeAngle16(((enemy).sourceAngle16 + 43691)), f32(0), speed, 1, 0);
                                                        fired = true
                                                    end
                                                end
                                            end
                                        end;
                                        if (((cycle >= 800) and (math.fmod((cycle - 800), (kSecondaryPeriod)[difficulty + 1]) == 0)) and (bit.band(route, 1) == 0)) then
                                            do
                                                local count = (kSecondaryCount)[difficulty + 1];
                                                local speed = (kSecondarySpeed)[difficulty + 1];
                                                ctx:spawnProjectileSpread(5, 0, muzzleX, muzzleY, (enemy).sourceAngle16, f32(0), speed, 1, count, 16000, 0);
                                                if (difficulty > 2) then
                                                    do
                                                        local innerCount = (count - 1);
                                                        ctx:spawnProjectileSpread(5, 0, muzzleX, muzzleY, (enemy).sourceAngle16, f32(0), (speed + 0.80000000000000004), 1, innerCount, (trunc(16000 / innerCount) * (innerCount - 1)), 0)
                                                    end
                                                end;
                                                fired = true
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    do
                        if ((parent).hp < 1) then
                            do
                                ctx:spawnEnemyDeathEffects(enemy, 1, true);
                                (release)(false);
                                do return end
                            end
                        end;
                        if ((enemy).helperState == 0) then
                            do
                                if (timer == 0) then
                                    do
                                        (enemy).secondaryAngle16 = ((16384 % 65536) % 65536)
                                    end
                                end;
                                local unfold = (function() if (timer < 40) then return math.sin(((timer * kPi) / 80)) else return 1 end end)();
                                if (timer < 40) then
                                    do
                                        local anchorX = f32(((parent).x - f32(33)));
                                        local anchorY = f32(((parent).y - f32(83)));
                                        (enemy).markerDrawX = f32(f32((anchorX + f32((f32((f32(360) - anchorX)) * unfold)))));
                                        (enemy).markerDrawY = f32(f32((anchorY + f32((f32((f32(360) - anchorY)) * unfold)))))
                                    end
                                end;
                                local radians = fixedAngleRadians((enemy).sourceAngle16);
                                local radial = f32((function() if (timer < 40) then return trunc((unfold * 800)) else return 800 end end)());
                                local vertical = f32((function() if (timer < 40) then return trunc((unfold * 350)) else return 350 end end)());
                                (enemy).x = f32(f32(((enemy).markerDrawX + f32((math.cos(radians) * radial)))));
                                (enemy).y = f32(f32(((enemy).markerDrawY + f32((math.sin(radians) * vertical)))))
                            end
                        end;
                        if (((enemy).helperState == 0) and ((parent).helperTimer >= 160)) then
                            do
                                (enemy).helperState = 1;
                                (enemy).helperTimer = 0;
                                timer = 0
                            end
                        end;
                        if ((enemy).helperState == 1) then
                            do
                                local kBurstPeriod = {90, 60, 60, 60, 60};
                                local kBurstWidth = {16, 20, 24, 24, 32};
                                local kCount = {1, 1, 1, 2, 2};
                                local kSecondPeriod = {40, 30, 20, 20, 15};
                                local kSpeed = {3.6000000000000001, 4.2000000000000002, 4.5999999999999996, 5, 6.5};
                                local cycle = math.fmod(timer, 1200);
                                local turn = trunc((math.sin(((timer * kPi) / 600)) * 80));
                                (enemy).sourceAngle16 = (normalizeAngle16(((enemy).sourceAngle16 + turn)) % 65536);
                                local orbitRadians = fixedAngleRadians((enemy).sourceAngle16);
                                (enemy).x = f32(f32(((enemy).markerDrawX + f32((math.cos(orbitRadians) * 800)))));
                                (enemy).y = f32(f32(((enemy).markerDrawY + f32((math.sin(orbitRadians) * 350)))));
                                local sourceRadians = fixedAngleRadians((enemy).secondaryAngle16);
                                local firstX = f32(((enemy).x + f32((math.cos(sourceRadians) * 38))));
                                local firstY = f32(((enemy).y + f32((math.sin(sourceRadians) * 38))));
                                local oppositeAngle = normalizeAngle16(((enemy).secondaryAngle16 + 32768));
                                local oppositeRadians = fixedAngleRadians(oppositeAngle);
                                local secondX = f32(((enemy).x + f32((math.cos(oppositeRadians) * 38))));
                                local secondY = f32(((enemy).y + f32((math.sin(oppositeRadians) * 38))));
                                local burstPeriod = (kBurstPeriod)[difficulty + 1];
                                local burstWidth = (kBurstWidth)[difficulty + 1];
                                local count = (kCount)[difficulty + 1];
                                local secondPeriod = (kSecondPeriod)[difficulty + 1];
                                local speed = (kSpeed)[difficulty + 1];
                                if (cycle < 580) then
                                    do
                                        local burst = math.fmod(cycle, burstPeriod);
                                        if ((burst < burstWidth) and (math.fmod(burst, 4) == 0)) then
                                            do
                                                ctx:spawnProjectileSpread(5, 0, firstX, firstY, (enemy).secondaryAngle16, f32(10), speed, 1, count, 4000, 0);
                                                fired = true
                                            end
                                        end;
                                        if (math.fmod(cycle, secondPeriod) == 0) then
                                            do
                                                ctx:spawnProjectileNode(8, 0, secondX, secondY, normalizeAngle16(((enemy).secondaryAngle16 - 32768)), f32(10), (speed - 1.6000000000000001), 1, 0);
                                                fired = true
                                            end
                                        end
                                    end
                                else
                                    if ((cycle >= 640) and (cycle < 1140)) then
                                        do
                                            local v_local = (cycle - 640);
                                            local burst = math.fmod(v_local, burstPeriod);
                                            if ((burst < burstWidth) and (math.fmod(burst, 4) == 0)) then
                                                do
                                                    ctx:spawnProjectileNode(5, 0, secondX, secondY, normalizeAngle16(((enemy).secondaryAngle16 - 32768)), f32(10), (speed - 1.6000000000000001), 1, 0);
                                                    fired = true
                                                end
                                            end;
                                            if (math.fmod(v_local, secondPeriod) == 0) then
                                                do
                                                    ctx:spawnProjectileSpread(8, 0, firstX, firstY, (enemy).secondaryAngle16, f32(10), speed, 1, count, 4000, 0);
                                                    fired = true
                                                end
                                            end
                                        end
                                    end
                                end;
                                if (math.fmod(cycle, 4) == 0) then
                                    do
                                        local horizontalOrigin = f32((((ctx).player_).x / f32(6)));
                                        local insideBoundary = function(px, py)
                                            px = f32(px);
                                            py = f32(py);
                                            do return ((((px >= f32((horizontalOrigin - f32(30)))) and (px <= f32((horizontalOrigin + f32(630))))) and (py >= f32((-f32(30))))) and (py <= f32(750))) end
                                        end;
                                        if (((enemy).sourceAngle16 > 32767) and (insideBoundary)(firstX, firstY)) then
                                            do
                                                ctx:spawnProjectileNode(14, 0, firstX, firstY, (enemy).sourceAngle16, f32(0), 2, 1, 0);
                                                fired = true
                                            end
                                        end;
                                        if (((enemy).sourceAngle16 < 32768) and (insideBoundary)(secondX, secondY)) then
                                            do
                                                ctx:spawnProjectileNode(14, 0, secondX, secondY, (enemy).sourceAngle16, f32(0), 2, 1, 0);
                                                fired = true
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
    if fired then
        do
            ctx:playPlayerSound((ctx).bullet2SoundHandle_, 19)
        end
    end
end

M.updateStage06Boss = function(ctx, enemy)
    local difficulty = cpp.clamp(((ctx).config_).difficulty, 0, 4);
    if (((ctx).lateStageBossPhaseMode_ == 1) and (((enemy).hp < 1) or ((ctx).lateStageBossCountdown_ < 1))) then
        do
            (enemy).targetable = false;
            (enemy).targetableTimer = 0;
            local countdownExpired = ((ctx).lateStageBossCountdown_ < 1);
            if countdownExpired then
                do
                    ctx:flushEnemyProjectilesToEffects();
                    ((ctx).player_).invulnerableFrames = math.max(((ctx).player_).invulnerableFrames, 100)
                end
            else
                do
                    ctx:spawnPlayerSideObject(24, (enemy).x, (enemy).y, 0, (0 % 65536), 0, f32(0))
                end
            end;
            ctx:spawnBossPhaseBreakFeedback(enemy, (ctx).lateStageBossCountdown_);
            ctx:spawnPostDeathCounterEntity(enemy, 140);
            (enemy).helperTimer = 0;
            do
                local __switch112 = (ctx).lateStageBossBreaksRemaining_
                if __switch112 == 5 then __switch112 = 1
                elseif __switch112 == 4 then __switch112 = 2
                elseif __switch112 == 3 then __switch112 = 3
                elseif __switch112 == 2 then __switch112 = 4
                elseif __switch112 == 1 then __switch112 = 5
                else __switch112 = 6 end
                repeat
                    if __switch112 <= 1 then
                        (enemy).helperState = 2;
                        (ctx).lateStageBossPhaseMode_ = 2;
                        do break end;
                    end
                    if __switch112 <= 2 then
                        (enemy).helperState = 4;
                        (ctx).lateStageBossPhaseMode_ = 2;
                        do break end;
                    end
                    if __switch112 <= 3 then
                        (enemy).helperState = 6;
                        (ctx).lateStageBossPhaseMode_ = 2;
                        do break end;
                    end
                    if __switch112 <= 4 then
                        (enemy).helperState = 8;
                        (ctx).lateStageBossPhaseMode_ = 2;
                        do break end;
                    end
                    if __switch112 <= 5 then
                        (enemy).helperState = 10;
                        (ctx).lateStageBossPhaseMode_ = (-1);
                        (ctx).lateStageClearStarted_ = true;
                        (ctx).lateStageClearTimer_ = 0;
                        ((ctx).player_).invulnerableFrames = math.max(((ctx).player_).invulnerableFrames, 360);
                        do break end;
                    end
                    if __switch112 <= 6 then
                        do break end
                    end
                until true
            end;
            (ctx).lateStageBossBreaksRemaining_ = math.max(0, ((ctx).lateStageBossBreaksRemaining_ - 1))
        end
    end;
    if (math.fmod((ctx).frame_, 50) == 0) then
        do
            (ctx).lateStageBossTargetX_ = f32(f32((f32(210) + f32(math.fmod(lateBossFrameRand((ctx).frame_), 301)))));
            (ctx).lateStageBossTargetY_ = f32(f32((f32(140) + f32(math.fmod(lateBossFrameRand((((ctx).selectedStage_ * 222) + (ctx).frame_)), 101)))))
        end
    end;
    local steerAndMove = function(speed)
        local target = radiansToAngle16(math.atan2(f32(((ctx).lateStageBossTargetY_ - (enemy).y)), f32(((ctx).lateStageBossTargetX_ - (enemy).x))));
        (enemy).sourceAngle16 = (approachAngle16((enemy).sourceAngle16, target, 512) % 65536);
        local radians = fixedAngleRadians((enemy).sourceAngle16);
        (enemy).x = f32(f32(((enemy).x + f32((math.cos(radians) * speed)))));
        (enemy).y = f32(f32(((enemy).y + f32((math.sin(radians) * speed)))))
    end;
    local openPhase = function(state, hitPoints, countdown, speed, phaseIndex)
        (enemy).helperState = state;
        (enemy).helperTimer = 0;
        (enemy).hp = hitPoints;
        (enemy).maxHp = hitPoints;
        (enemy).drawHp = hitPoints;
        (enemy).sourceSpeed = speed;
        (enemy).speed = f32(f32(speed));
        (enemy).targetable = true;
        (enemy).targetableTimer = 0;
        (ctx).lateStageBossMaxHp_ = hitPoints;
        (ctx).lateStageBossCountdown_ = countdown;
        (ctx).lateStageBossPhaseIndex_ = phaseIndex;
        (ctx).lateStageBossPhaseMode_ = 1
    end;
    local timer = (enemy).helperTimer;
    do
        local __switch120 = (enemy).helperState
        if __switch120 == 0 then __switch120 = 1
        elseif __switch120 == 1 then __switch120 = 2
        elseif __switch120 == 2 then __switch120 = 3
        elseif __switch120 == 3 then __switch120 = 4
        elseif __switch120 == 4 then __switch120 = 5
        elseif __switch120 == 5 then __switch120 = 6
        elseif __switch120 == 6 then __switch120 = 7
        elseif __switch120 == 8 then __switch120 = 8
        elseif __switch120 == 7 then __switch120 = 9
        elseif __switch120 == 9 then __switch120 = 10
        elseif __switch120 == 10 then __switch120 = 11
        else __switch120 = 12 end
        repeat
            if __switch120 <= 1 then
                do
                    if (timer == 0) then
                        do
                            ctx:playPlayerSound((ctx).bossSe8SoundHandle_, 25)
                        end
                    end;
                    if ((timer >= 60) and (timer < 160)) then
                        do
                            local t = ((timer - 60) / 100);
                            local ease = math.sin(((t * kPi) * 0.5));
                            (enemy).x = f32(f32((f32((f32(480) + f32(((360 - 480) * ease)))) + f32((math.sin((t * kPi)) * 45)))));
                            (enemy).y = f32(f32((f32((f32(150) + f32(((240 - 150) * ease)))) - f32((math.sin((t * kPi)) * 30)))))
                        end
                    else
                        if (timer >= 160) then
                            do
                                (enemy).y = f32(f32(((enemy).y + f32(0.100000001))))
                            end
                        end
                    end;
                    local kTypes = {106, 105, 104, 103, 102};
                    local kAngleOrder = {3, 1, 4, 2, 8};
                    do
                        local i = 0
                        while (i < 5) do
                            do
                                if (timer == (150 + (i * 10))) then
                                    do
                                        ctx:spawnStage06BossNode(enemy, (kTypes)[i + 1], i, f32(75), f32(0), normalizeAngle16((((kAngleOrder)[i + 1] * 13107) + 16384)), 60)
                                    end
                                end
                            end
                            i = i + 1
                        end
                    end;
                    if (timer == 220) then
                        do
                            ctx:spawnStage06BossNode(enemy, 100, 0, f32(75), f32(0), (32768 % 65536), 40);
                            ctx:spawnStage06BossNode(enemy, 101, 1, f32(75), f32(0), (0 % 65536), 40)
                        end
                    end;
                    if (timer == 240) then
                        do
                            (openPhase)(1, 100000, 3600, 0.29999999999999999, 0)
                        end
                    end;
                    do break end
                end;
            end
            if __switch120 <= 2 then
                (steerAndMove)(0.29999999999999999);
                do break end;
            end
            if __switch120 <= 3 then
                if (timer < 90) then
                    do
                        (enemy).y = f32(f32(((enemy).y + f32((f32(timer) * f32(0.00999999977))))))
                    end
                end;
                if (timer == 100) then
                    do
                        (enemy).sourceSpeed = 1.6000000000000001;
                        (enemy).speed = f32(f32(1.60000002))
                    end
                end;
                if (timer >= 100) then
                    do
                        (steerAndMove)(1.6000000000000001)
                    end
                end;
                if (timer == 180) then
                    do
                        (openPhase)(3, 86000, 2100, 1.6000000000000001, 1)
                    end
                end;
                do break end;
            end
            if __switch120 <= 4 then
                (steerAndMove)(1.6000000000000001);
                if (timer == 30) then
                    do
                        ctx:spawnStage06BossNode(enemy, 107, 0, f32(90), f32(0), (16384 % 65536), 40)
                    end
                end;
                do break end;
            end
            if __switch120 <= 5 then
                if (timer < 120) then
                    do
                        (enemy).y = f32(f32(((enemy).y + f32((f32(timer) * f32(0.0199999996))))))
                    end
                end;
                if (timer == 130) then
                    do
                        (enemy).y = f32(f32(((enemy).y - f32(75))));
                        (enemy).sourceSpeed = 0.59999999999999998;
                        (enemy).speed = f32(f32(0.600000024))
                    end
                end;
                if (timer >= 130) then
                    do
                        (steerAndMove)(0.59999999999999998)
                    end
                end;
                if (timer == 380) then
                    do
                        (openPhase)(5, 68000, 1800, 0.59999999999999998, 2)
                    end
                end;
                do break end;
            end
            if __switch120 <= 6 then
                (steerAndMove)(0.59999999999999998);
                if (timer == 10) then
                    do
                        local kOffsetX = {f32(100), f32((-f32(100))), f32(210), f32((-f32(210)))};
                        local kOffsetY = {f32((-f32(120))), f32((-f32(120))), f32((-f32(70))), f32((-f32(70)))};
                        do
                            local i = 0
                            while (i < 4) do
                                do
                                    ctx:spawnStage06BossNode(enemy, 110, i, (kOffsetX)[i + 1], (kOffsetY)[i + 1], (16384 % 65536), 40)
                                end
                                i = i + 1
                            end
                        end;
                        ctx:playPlayerSound((ctx).bossSe8SoundHandle_, 25)
                    end
                end;
                do break end;
            end
            if __switch120 <= 8 then
                (enemy).y = f32(f32(((enemy).y + f32(0.100000001))));
                if (timer == 1) then
                    do
                        ctx:playPlayerSound((ctx).enemyDown3SoundHandle_, 25)
                    end
                end;
                if (timer < 90) then
                    do
                        ctx:spawnStage02DeathExplosionChain(enemy)
                    end
                end;
                if (timer == 180) then
                    do
                        if ((enemy).helperState == 6) then
                            do
                                (openPhase)(7, 70000, 2100, 0.59999999999999998, 3)
                            end
                        else
                            do
                                (openPhase)(9, 80000, 2100, 0.59999999999999998, 4)
                            end
                        end
                    end
                end;
                do break end;
            end
            if __switch120 <= 9 then
                do
                    (steerAndMove)(0.59999999999999998);
                    local kCount = {17, 21, 25, 25, 27};
                    local count = (kCount)[difficulty + 1];
                    local step = math.max(1, trunc(100 / count));
                    do
                        local i = 0
                        while (i < count) do
                            do
                                if (timer == (10 + (i * step))) then
                                    do
                                        ctx:spawnStage06BossNode(enemy, 111, i, f32(0), f32(0), normalizeAngle16(((i * trunc(65536 / count)) - 16384)), 40)
                                    end
                                end
                            end
                            i = i + 1
                        end
                    end;
                    do break end
                end;
            end
            if __switch120 <= 10 then
                do
                    (steerAndMove)(0.59999999999999998);
                    local baseInterval = (function() if (difficulty == 0) then return 120 else return 100 end end)();
                    local switchFrame = ((baseInterval + 12) * 5);
                    local interval = (function() if (timer >= switchFrame) then return trunc(baseInterval / 2) else return baseInterval end end)();
                    if ((timer > 59) and (math.fmod((timer - 60), interval) == 0)) then
                        do
                            local firstFamily = (function() if (timer < switchFrame) then return (math.fmod((timer - 60), (interval * 2)) == 0) else return (u32(bit.band(lateStageScriptRand(timer), 1)) == 0) end end)();
                            local kRingCount = {15, 19, 21, 12, 9};
                            local count = (kRingCount)[difficulty + 1];
                            local random = lateStageScriptRand(timer);
                            local baseAngle = normalizeAngle16(u32((random - trunc(random / 65537))));
                            local visual = (function() if firstFamily then return 2 else return 3 end end)();
                            local projectileId = (function() if firstFamily then return 31 else return 32 end end)();
                            local direction = (function() if firstFamily then return (-1) else return 1 end end)();
                            local extraLayers = (function() if (difficulty == 4) then return 4 else return (function() if (difficulty == 3) then return 2 else return 0 end end)() end end)();
                            do
                                local layer = 0
                                while (layer <= extraLayers) do
                                    do
                                        local angle = normalizeAngle16((baseAngle + ((direction * layer) * 1200)));
                                        local shotX = (function() if (bit.band(layer, 1) == 0) then return f32(((enemy).x - f32(33))) else return (enemy).x end end)();
                                        local shotY = (function() if (bit.band(layer, 1) == 0) then return f32(((enemy).y - f32(83))) else return (enemy).y end end)();
                                        do
                                            local i = 0
                                            while (i < count) do
                                                do
                                                    ctx:spawnProjectileNode(visual, projectileId, shotX, shotY, normalizeAngle16((angle + (i * trunc(65536 / count)))), f32(0), 0, 1, 0)
                                                end
                                                i = i + 1
                                            end
                                        end
                                    end
                                    layer = layer + 1
                                end
                            end;
                            ctx:playPlayerSound((ctx).bullet2SoundHandle_, 19)
                        end
                    end;
                    do break end
                end;
            end
            if __switch120 <= 11 then
                (enemy).targetable = false;
                if (timer < 240) then
                    do
                        (enemy).y = f32(f32(((enemy).y + f32(0.200000003))));
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
                        ctx:clearLateStageGate(6);
                        (enemy).active = false
                    end
                end;
                do break end;
            end
            if __switch120 <= 12 then
                do break end
            end
        until true
    end;
    (enemy).drawHp = (enemy).hp;
    (ctx).lateStageBossCountdownDraw_ = (ctx).lateStageBossCountdown_;
    if ((ctx).lateStageBossPhaseMode_ == 1) then
        do
            ctx:updateBossCountdownAudio((enemy).hp, (ctx).lateStageBossCountdown_);
            (ctx).lateStageBossCountdown_ = (ctx).lateStageBossCountdown_ - 1
        end
    end
end

M.spawnStage10FinalBossNode = function(ctx, parent, spawnType)
    local spec = stage10FinalBossNodeSpec(spawnType);
    if (((spec == nil) or ((parent).spawnType ~= 321)) or (((#(ctx).enemies_) + (#(ctx).pendingEnemies_)) >= kLateStageEntityCap)) then
        do
            do return false end
        end
    end;
    local alreadyPresent = function(node)
        do return (((node).active and ((node).spawnType == spawnType)) and ((node).parentEntityId == (parent).entityId)) end
    end;
    if (cpp.any_of((ctx).enemies_, (ctx).enemies_, alreadyPresent) or cpp.any_of((ctx).pendingEnemies_, (ctx).pendingEnemies_, alreadyPresent)) then
        do
            do return false end
        end
    end;
    local note = nil;
    do
        local __switch144 = spawnType
        if __switch144 == 273 then __switch144 = 1
        elseif __switch144 == 274 then __switch144 = 2
        elseif __switch144 == 275 then __switch144 = 3
        elseif __switch144 == 277 then __switch144 = 4
        elseif __switch144 == 282 then __switch144 = 5
        elseif __switch144 == 285 then __switch144 = 6
        elseif __switch144 == 293 then __switch144 = 7
        elseif __switch144 == 294 then __switch144 = 8
        elseif __switch144 == 295 then __switch144 = 9
        elseif __switch144 == 301 then __switch144 = 10
        else __switch144 = 11 end
        repeat
            if __switch144 <= 1 then
                note = "S10 FUN_140052fb0 state 11 timer 30 node 0x111";
                do break end;
            end
            if __switch144 <= 2 then
                note = "S10 FUN_140052fb0 state 31 timer 30 node 0x112";
                do break end;
            end
            if __switch144 <= 3 then
                note = "S10 FUN_140052fb0 state 51 timer 30 node 0x113";
                do break end;
            end
            if __switch144 <= 4 then
                note = "S10 FUN_140052fb0 state 71 timer 30 node 0x115";
                do break end;
            end
            if __switch144 <= 5 then
                note = "S10 FUN_140052fb0 state 91 timer 30 node 0x11a";
                do break end;
            end
            if __switch144 <= 6 then
                note = "S10 FUN_140052fb0 state 111 timer 30 node 0x11d";
                do break end;
            end
            if __switch144 <= 7 then
                note = "S10 FUN_140052fb0 state 131 timer 30 node 0x125";
                do break end;
            end
            if __switch144 <= 8 then
                note = "S10 FUN_140052fb0 state 131 timer 30 node 0x126";
                do break end;
            end
            if __switch144 <= 9 then
                note = "S10 FUN_140052fb0 state 141 timer 30 node 0x127";
                do break end;
            end
            if __switch144 <= 10 then
                note = "S10 FUN_140052fb0 state 151 timer 30 node 0x12d";
                do break end;
            end
            if __switch144 <= 11 then
                do break end
            end
        until true
    end;
    local node = cpp.newEnemy();
    (node).entityId = (function() local __old = (ctx).nextEntityId_; (ctx).nextEntityId_ = (ctx).nextEntityId_ + 1; return __old end)();
    (node).spawnType = spawnType;
    (node).updateCase = (spec).updateCase;
    (node).sourceHitPoints = 99999999;
    (node).sourceX = 360;
    (node).sourceY = trunc((spec).spawnY);
    (node).sourceNote = note;
    (node).sourceDispatchKind = 0;
    (node).sourceDispatchField = (spec).radius;
    (node).parentEntityId = (parent).entityId;
    (node).parentSpawnType = 321;
    (node).x = f32(f32(360));
    (node).y = f32((spec).spawnY);
    (node).originX = f32((node).x);
    (node).originY = f32((node).y);
    (node).markerDrawX = f32((node).x);
    (node).markerDrawY = f32((node).y);
    (node).sourceAngle16 = ((16384 % 65536) % 65536);
    (node).secondaryAngle16 = ((16384 % 65536) % 65536);
    (node).targetAngle16 = ((16384 % 65536) % 65536);
    (node).angle = f32(f32(fixedAngleRadians((node).sourceAngle16)));
    (node).sourceSpeed = 1;
    (node).speed = f32(f32(1));
    (node).hp = (function() if (((ctx).config_).difficulty == 0) then return 79999999 else return 99999999 end end)();
    (node).maxHp = (node).hp;
    (node).drawHp = (node).hp;
    (node).radius = (spec).radius;
    (node).activationDelay = 0;
    (node).rewardWeight = 0;
    (node).targetable = false;
    cpp.push((ctx).pendingEnemies_, node);
    (parent).liveChildCount = (parent).liveChildCount + 1;
    do return true end
end

M.updateStage10FinalBossNode = function(ctx, enemy)
    if ctx:isStage10FinalBossEmitterType((enemy).spawnType) then
        do
            ctx:updateStage10FinalBossEmitter(enemy);
            do return end
        end
    end;
    ctx:maybeSpawnStage10GuardNode(enemy);
    if isStage10FinalBossAuxNodeType((enemy).spawnType) then
        do
            (enemy).vx = f32(f32(0));
            (enemy).vy = f32(f32(0));
            (enemy).drawMarkerThisFrame = false;
            (enemy).drawBodyThisFrame = true;
            local owner = ctx:findEnemyById((enemy).parentEntityId);
            if (((owner == nil) or (not (owner).active)) or ((owner).spawnType ~= (enemy).parentSpawnType)) then
                do
                    (enemy).targetable = false;
                    (enemy).active = false;
                    do return end
                end
            end;
            local timer = (enemy).helperTimer;
            if ((enemy).spawnType == 276) then
                do
                    if (((owner).hp < 1) or ((ctx).lateStageBossCountdown_ < 1)) then
                        do
                            (enemy).targetable = false;
                            (enemy).active = false;
                            do return end
                        end
                    end;
                    local kNearX = {f32(100), f32((-f32(100))), f32(200), f32((-f32(200)))};
                    local kNearY = {f32((-f32(70))), f32((-f32(70))), f32((-f32(30))), f32((-f32(30)))};
                    local kFarX = {f32((-f32(140))), f32(140), f32((-f32(90))), f32(90)};
                    local kFarY = {f32(0), f32(0), f32((-f32(80))), f32((-f32(80)))};
                    local kFarBaseAngle = {(-32768), 0, (-32768), 0};
                    local kFarTurn = {(-750), 750, 750, (-750)};
                    local index = cpp.clamp((enemy).childIndex, 0, 3);
                    if (((enemy).helperState == 0) and (timer == 0)) then
                        do
                            (enemy).x = f32((owner).x);
                            (enemy).y = f32((owner).y)
                        end
                    end;
                    local cycle = (-1);
                    local useFarMount = false;
                    if (((enemy).helperState == 1) and (timer >= 40)) then
                        do
                            cycle = math.fmod((timer - 40), 1200);
                            useFarMount = (cycle >= 420)
                        end
                    end;
                    local targetX = f32(((owner).x + (function() if useFarMount then return (kFarX)[index + 1] else return (kNearX)[index + 1] end end)()));
                    local targetY = f32(((owner).y + (function() if useFarMount then return (kFarY)[index + 1] else return (kNearY)[index + 1] end end)()));
                    (enemy).x = f32(f32(((enemy).x + f32((f32((targetX - (enemy).x)) * f32(0.200000003))))));
                    (enemy).y = f32(f32(((enemy).y + f32((f32((targetY - (enemy).y)) * f32(0.200000003))))));
                    if useFarMount then
                        do
                            local turnFrames = math.max(0, (cycle - 450));
                            (enemy).targetAngle16 = (normalizeAngle16(((kFarBaseAngle)[index + 1] + ((kFarTurn)[index + 1] * turnFrames))) % 65536)
                        end
                    else
                        if ((enemy).helperState == 1) then
                            do
                                (enemy).targetAngle16 = (radiansToAngle16(math.atan2(f32((((ctx).player_).y - (enemy).y)), f32((((ctx).player_).x - (enemy).x)))) % 65536)
                            end
                        end
                    end;
                    local angleDelta = ((enemy).targetAngle16 - (enemy).sourceAngle16);
                    if (angleDelta > 32768) then
                        angleDelta = (angleDelta - 65536)
                    end;
                    if (angleDelta < (-32768)) then
                        angleDelta = (angleDelta + 65536)
                    end;
                    (enemy).sourceAngle16 = (approachAngle16((enemy).sourceAngle16, (enemy).targetAngle16, (128 + trunc(math.abs(angleDelta) / 10))) % 65536);
                    (enemy).targetable = false;
                    if (((enemy).helperState == 0) and (timer >= 40)) then
                        do
                            (enemy).helperState = 1;
                            (enemy).helperTimer = 0;
                            do return end
                        end
                    end;
                    if (cycle >= 0) then
                        do
                            local fire = false;
                            local speed = 0;
                            if ((cycle >= 20) and (cycle < 400)) then
                                do
                                    local v_local = math.fmod((cycle - 20), 35);
                                    fire = ((v_local <= 19) and (math.fmod(v_local, 5) == 0));
                                    speed = 8
                                end
                            else
                                if (((cycle >= 450) and (cycle < 1160)) and (math.fmod((cycle - 450), 3) == 0)) then
                                    do
                                        fire = true;
                                        speed = 5
                                    end
                                end
                            end;
                            if fire then
                                do
                                    local heading = fixedAngleRadians((enemy).sourceAngle16);
                                    local muzzleX = f32(((enemy).x + f32((math.cos(heading) * 15))));
                                    local muzzleY = f32(((enemy).y + f32((math.sin(heading) * 15))));
                                    ctx:spawnProjectileNode(10, 1, muzzleX, muzzleY, (enemy).sourceAngle16, f32(10), speed, 1, 0);
                                    ctx:playPlayerSound((ctx).bullet2SoundHandle_, 9)
                                end
                            end
                        end
                    end
                end
            else
                if (((enemy).spawnType >= 278) and ((enemy).spawnType <= 281)) then
                    do
                        if (((owner).helperState == 99) and ((enemy).helperState < 99)) then
                            do
                                ctx:spawnPostDeathCounterEntity(enemy, ((enemy).radius * 0.59999999999999998));
                                (enemy).helperState = 99;
                                (enemy).helperTimer = 0;
                                (enemy).targetable = false;
                                ctx:spawnStage02DeathExplosionChain(enemy);
                                do return end
                            end
                        end;
                        if ((enemy).helperState == 99) then
                            do
                                (enemy).targetable = false;
                                if (timer < 90) then
                                    do
                                        ctx:spawnStage02DeathExplosionChain(enemy);
                                        (enemy).y = f32(f32(((enemy).y + f32((f32(timer) * f32(0.0199999996))))))
                                    end
                                end;
                                if (timer == 90) then
                                    do
                                        ctx:playPlayerSound((ctx).blast2SoundHandle_, 25);
                                        ctx:spawnEnemyDeathEffects(enemy, 1, false)
                                    end
                                end;
                                if (timer >= 140) then
                                    do
                                        (enemy).active = false
                                    end
                                end
                            end
                        else
                            do
                                if (((enemy).helperState == 0) and (((owner).helperState == 1) or (timer >= 190))) then
                                    do
                                        (enemy).helperState = 1;
                                        (enemy).helperTimer = 0;
                                        (enemy).targetable = false;
                                        do return end
                                    end
                                else
                                    if (((enemy).helperState == 1) or ((enemy).helperState == 3)) then
                                        do
                                            (enemy).targetable = true;
                                            if (timer == 1) then
                                                do
                                                    (enemy).markerDrawX = f32((enemy).x);
                                                    (enemy).markerDrawY = f32((enemy).y)
                                                end
                                            end;
                                            local moveRight = ((((enemy).originX < f32(360)) and ((enemy).helperState == 1)) or (((enemy).originX >= f32(360)) and ((enemy).helperState == 3)));
                                            local targetX = f32(((enemy).markerDrawX + (function() if moveRight then return f32(50) else return f32((-f32(50))) end end)()));
                                            local verticalStep = (function() if ((enemy).markerDrawY < f32(0)) then return f32(180) else return (function() if ((enemy).markerDrawY < f32(600)) then return f32(120) else return f32(300) end end)() end end)();
                                            local targetY = f32(((enemy).markerDrawY + verticalStep));
                                            local travelPhase = ((timer * kPi) / 80);
                                            local bobPhase = ((timer * kPi) / 40);
                                            local travel = math.sin(travelPhase);
                                            (enemy).x = f32(f32(((enemy).markerDrawX + f32((travel * f32((targetX - (enemy).markerDrawX)))))));
                                            (enemy).y = f32(f32(((enemy).markerDrawY + f32(((travel * f32((targetY - (enemy).markerDrawY))) - (80 * math.sin(bobPhase)))))));
                                            if (timer >= 40) then
                                                do
                                                    (enemy).helperState = (enemy).helperState + 1;
                                                    (enemy).helperTimer = 0
                                                end
                                            end
                                        end
                                    else
                                        if (((enemy).helperState == 2) or ((enemy).helperState == 4)) then
                                            do
                                                (enemy).targetable = true;
                                                if ((enemy).y < f32(400)) then
                                                    do
                                                        local aimFrom = function(x, y)
                                                            x = f32(x);
                                                            y = f32(y);
                                                            do return radiansToAngle16(math.atan2(f32((((ctx).player_).y - y)), f32((((ctx).player_).x - x)))) end
                                                        end;
                                                        local v_local = (timer - 10);
                                                        if (((((enemy).spawnType == 278) and (v_local >= 0)) and (v_local < 30)) and (math.fmod(v_local, 4) == 0)) then
                                                            do
                                                                local fireY = f32(((enemy).y + f32(95)));
                                                                if (timer == 10) then
                                                                    do
                                                                        (enemy).targetAngle16 = ((aimFrom)((enemy).x, fireY) % 65536)
                                                                    end
                                                                end;
                                                                local narrow = (v_local * 50);
                                                                local wide = ((v_local + 120) * 50);
                                                                do

                                                                    for _, offset in ipairs({(-narrow), narrow, (-wide), wide}) do
                                                                        do
                                                                            ctx:spawnProjectileNode(11, 1, (enemy).x, fireY, normalizeAngle16(((enemy).targetAngle16 + offset)), f32(10), 5, 1, 0)
                                                                        end
                                                                    end
                                                                end;
                                                                ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                                                            end
                                                        else
                                                            if ((((enemy).spawnType == 279) and (v_local >= 0)) and (v_local < 30)) then
                                                                do
                                                                    local fireY = f32(((enemy).y + f32(90)));
                                                                    local aimed = (aimFrom)((enemy).x, fireY);
                                                                    local ownerTimer = (owner).helperTimer;
                                                                    local xJitter = (math.fmod(lateBossFrameRand(ownerTimer), 81) - 40);
                                                                    local angleJitter = (math.fmod(lateBossFrameRand((ownerTimer + 4444)), 36001) - 18000);
                                                                    local speed = (3 + (math.fmod(lateBossFrameRand((ownerTimer + 444)), 301) / 100));
                                                                    ctx:spawnProjectileNode(12, 2, f32(((enemy).x + f32(xJitter))), fireY, normalizeAngle16((aimed + angleJitter)), f32(10), speed, 1, 0);
                                                                    ctx:playPlayerSound((ctx).bullet2SoundHandle_, 12)
                                                                end
                                                            else
                                                                if (((((enemy).spawnType == 280) and (v_local >= 0)) and (v_local < 50)) and (math.fmod(v_local, 15) == 0)) then
                                                                    do
                                                                        local fireY = f32(((enemy).y + f32(90)));
                                                                        local aimed = (aimFrom)((enemy).x, fireY);
                                                                        do
                                                                            local i = 0
                                                                            while (i < 5) do
                                                                                do
                                                                                    ctx:spawnProjectileNode(3, 1, (enemy).x, fireY, normalizeAngle16(((aimed - 6000) + (i * 3000))), f32(10), 2.3999999999999999, 1, 0)
                                                                                end
                                                                                i = i + 1
                                                                            end
                                                                        end;
                                                                        ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                                                                    end
                                                                else
                                                                    if (((((enemy).spawnType == 281) and (v_local >= 0)) and (v_local < 50)) and (math.fmod(v_local, 5) == 0)) then
                                                                        do
                                                                            local fireY = f32(((enemy).y + f32(95)));
                                                                            if (timer == 10) then
                                                                                do
                                                                                    (enemy).targetAngle16 = ((aimFrom)((enemy).x, fireY) % 65536)
                                                                                end
                                                                            end;
                                                                            local sweep = (v_local * 650);
                                                                            local speed = (2.5 + (v_local * 0.14000000000000001));
                                                                            ctx:spawnProjectileNode(4, 0, f32(((enemy).x - f32(15))), fireY, normalizeAngle16((((enemy).targetAngle16 + sweep) - 16384)), f32(0), speed, 1, 0);
                                                                            ctx:spawnProjectileNode(4, 0, f32(((enemy).x + f32(15))), fireY, normalizeAngle16((((enemy).targetAngle16 - sweep) + 16384)), f32(0), speed, 1, 0);
                                                                            ctx:playPlayerSound((ctx).bullet2SoundHandle_, 12)
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end;
                                                if (timer >= 80) then
                                                    do
                                                        (enemy).helperState = (function() if ((enemy).helperState == 4) then return 1 else return ((enemy).helperState + 1) end end)();
                                                        (enemy).helperTimer = 0
                                                    end
                                                end;
                                                if ((enemy).hp < 1) then
                                                    do
                                                        local bossRoot = ctx:findEnemyById((owner).parentEntityId);
                                                        local specialActive = (((((ctx).player_).bombLock > 0) or (((ctx).player_).bombLock < (-100))) or (((ctx).player_).specialGauge < (-100)));
                                                        if ((((not specialActive) and (bossRoot ~= nil)) and ((bossRoot).spawnType == 321)) and (bossRoot).active) then
                                                            do
                                                                ctx:spawnDelayedOwnerDamageNode((enemy).maxHp, (bossRoot).entityId, (bossRoot).spawnType, "S10 launcher delayed-damage node 0x153")
                                                            end
                                                        end;
                                                        ctx:spawnEnemyDeathRewardBurst(enemy, 2400, false);
                                                        ctx:spawnEnemyDeathEffects(enemy, 2, true);
                                                        (enemy).targetable = false;
                                                        (enemy).active = false;
                                                        do return end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end;
                        if ((enemy).active and ((enemy).y >= f32(860))) then
                            do
                                (enemy).targetable = false;
                                (enemy).active = false
                            end
                        end
                    end
                else
                    if (((enemy).spawnType == 283) or ((enemy).spawnType == 284)) then
                        do
                            if (((owner).helperState == 99) and ((enemy).helperState < 99)) then
                                do
                                    (enemy).helperState = 99;
                                    (enemy).helperTimer = 0;
                                    (enemy).targetable = false;
                                    do return end
                                end
                            end;
                            (enemy).targetable = false;
                            local targetX = f32(((owner).x + (enemy).originX));
                            local targetY = f32(((owner).y + (enemy).originY));
                            if ((enemy).helperState == 0) then
                                do
                                    (enemy).x = f32(targetX);
                                    (enemy).y = f32(targetY);
                                    if ((owner).helperState >= 1) then
                                        do
                                            (enemy).helperState = 1;
                                            (enemy).helperTimer = 0
                                        end
                                    end
                                end
                            else
                                do
                                    local divisor = f32(math.max(1, (enemy).sourceSpeed));
                                    (enemy).x = f32(f32(((enemy).x + f32((f32((targetX - (enemy).x)) / divisor)))));
                                    (enemy).y = f32(f32(((enemy).y + f32((f32((targetY - (enemy).y)) / divisor)))))
                                end
                            end;
                            if (((enemy).helperState == 99) and (timer >= 100)) then
                                do
                                    (enemy).active = false
                                end
                            end
                        end
                    else
                        do
                            if (((owner).helperState == 99) and ((enemy).helperState < 99)) then
                                do
                                    (enemy).helperState = 99;
                                    (enemy).helperTimer = 0;
                                    (enemy).targetable = false;
                                    do return end
                                end
                            end;
                            local targetX = f32(((owner).x + (enemy).originX));
                            local targetY = f32(((owner).y + (enemy).originY));
                            if ((enemy).helperState == 0) then
                                do
                                    (enemy).x = f32(targetX);
                                    (enemy).y = f32(targetY);
                                    if ((owner).helperState >= 1) then
                                        do
                                            (enemy).helperState = 1;
                                            (enemy).helperTimer = 0
                                        end
                                    end
                                end
                            else
                                do
                                    local divisor = f32(math.max(1, (enemy).sourceSpeed));
                                    (enemy).x = f32(f32(((enemy).x + f32((f32((targetX - (enemy).x)) / divisor)))));
                                    (enemy).y = f32(f32(((enemy).y + f32((f32((targetY - (enemy).y)) / divisor)))))
                                end
                            end;
                            if (((owner).helperState == 1) and ((enemy).helperState == 1)) then
                                do
                                    local ownerTimer = (owner).helperTimer;
                                    local fireY = f32(((enemy).y + f32(130)));
                                    local aimed = radiansToAngle16(math.atan2(f32((((ctx).player_).y - fireY)), f32((((ctx).player_).x - (enemy).x))));
                                    if ((((enemy).spawnType == 286) and (ownerTimer >= 70)) and (ownerTimer < 390)) then
                                        do
                                            local v_local = math.fmod((ownerTimer - 70), 210);
                                            if ((v_local < 110) and (math.fmod(v_local, 8) == 0)) then
                                                do
                                                    local randomOffset = (1500 - math.fmod(lateBossFrameRand((enemy).helperTimer), 3001));
                                                    ctx:spawnProjectileNode(3, 0, (enemy).x, fireY, normalizeAngle16((aimed + randomOffset)), f32(0), 7.5, 1, 0);
                                                    do
                                                        local i = 0
                                                        while (i < 7) do
                                                            do
                                                                ctx:spawnProjectileNode(7, 0, (enemy).x, fireY, normalizeAngle16(((aimed - 18000) + (i * 2000))), f32(0), 8.5, 1, 0);
                                                                ctx:spawnProjectileNode(7, 0, (enemy).x, fireY, normalizeAngle16(((aimed + 6000) + (i * 2000))), f32(0), 8.5, 1, 0)
                                                            end
                                                            i = i + 1
                                                        end
                                                    end;
                                                    ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                                                end
                                            end
                                        end
                                    else
                                        if ((((enemy).spawnType == 288) and (ownerTimer >= 30)) and (ownerTimer < 390)) then
                                            do
                                                local v_local = math.fmod((ownerTimer - 30), 210);
                                                if ((v_local < 150) and (math.fmod(v_local, 10) == 0)) then
                                                    do
                                                        local left = ((enemy).originX < f32((-f32(1))));
                                                        local firstOffset = (function() if left then return 0 else return (-10000) end end)();
                                                        local secondOffset = (function() if left then return (-2500) else return (-7500) end end)();
                                                        do
                                                            local i = 0
                                                            while (i < 3) do
                                                                do
                                                                    ctx:spawnProjectileNode(4, 0, (enemy).x, fireY, normalizeAngle16(((aimed + firstOffset) + (i * 5000))), f32(0), 5.5, 1, 0);
                                                                    ctx:spawnProjectileNode(0, 0, (enemy).x, fireY, normalizeAngle16(((aimed + secondOffset) + (i * 5000))), f32(0), 6.5, 1, 0)
                                                                end
                                                                i = i + 1
                                                            end
                                                        end;
                                                        ctx:playPlayerSound((ctx).bullet2SoundHandle_, 12)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end;
                            if ((owner).helperState == 2) then
                                do
                                    local ownerTimer = (owner).helperTimer;
                                    if (((((enemy).spawnType == 287) and (ownerTimer >= 50)) and (ownerTimer < 720)) and (math.fmod((ownerTimer - 50), 48) == 0)) then
                                        do
                                            local eventIndex = trunc((ownerTimer - 50) / 48);
                                            local rightSide = ((enemy).originX > f32(0));
                                            local selectedRight = ((kStage10Type11fLaunchSides)[eventIndex + 1] == 0);
                                            if ((rightSide and 1 or 0) == (selectedRight and 1 or 0)) then
                                                do
                                                    ctx:spawnStage10FinalBossEmitter(enemy, 291, (enemy).x, (enemy).y, (16384 % 65536), 0, eventIndex)
                                                end
                                            end
                                        end
                                    end;
                                    if (((((enemy).spawnType == 290) and (ownerTimer >= 10)) and (ownerTimer < 720)) and (math.fmod((ownerTimer - 10), 30) == 0)) then
                                        do
                                            ctx:spawnStage10FinalBossEmitter(enemy, 292, (enemy).x, (enemy).y, (16384 % 65536), 0, trunc((ownerTimer - 10) / 30))
                                        end
                                    end
                                end
                            end;
                            if ((enemy).helperState == 99) then
                                do
                                    (enemy).targetable = false;
                                    if (timer >= 100) then
                                        do
                                            (enemy).active = false
                                        end
                                    end
                                end
                            else
                                do
                                    (enemy).targetable = (owner).targetable;
                                    if (enemy).targetable then
                                        do
                                            if ((enemy).hp < (owner).hp) then
                                                do
                                                    (owner).hp = (enemy).hp
                                                end
                                            else
                                                if ((owner).hp < (enemy).hp) then
                                                    do
                                                        (enemy).hp = (owner).hp
                                                    end
                                                end
                                            end;
                                            (enemy).drawHp = (owner).drawHp
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end;
            do return end
        end
    end;
    local spec = stage10FinalBossNodeSpec((enemy).spawnType);
    if (spec == nil) then
        do
            (enemy).active = false;
            do return end
        end
    end;
    (enemy).vx = f32(f32(0));
    (enemy).vy = f32(f32(0));
    (enemy).drawMarkerThisFrame = false;
    (enemy).drawBodyThisFrame = true;
    (enemy).drawHp = (enemy).hp;
    local parent = ctx:findEnemyById((enemy).parentEntityId);
    if (((parent == nil) or ((parent).spawnType ~= 321)) or (not (parent).active)) then
        do
            (enemy).targetable = false;
            (enemy).active = false;
            do return end
        end
    end;
    local spawnAuxNode = function(spawnType, parentEntityId, parentSpawnType, childIndex, x, y, offsetX, offsetY, hitPoints, radius)
        x = f32(x);
        y = f32(y);
        offsetX = f32(offsetX);
        offsetY = f32(offsetY);
        if (((#(ctx).enemies_) + (#(ctx).pendingEnemies_)) >= kLateStageEntityCap) then
            do
                do return 0 end
            end
        end;
        local updateCase = 0;
        if (spawnType == 276) then
            updateCase = 144
        else
            if ((spawnType >= 278) and (spawnType <= 281)) then
                updateCase = 146
            else
                if ((spawnType == 283) or (spawnType == 284)) then
                    updateCase = 148
                else
                    if ((spawnType >= 286) and (spawnType <= 290)) then
                        updateCase = 150
                    else
                        do return 0 end
                    end
                end
            end
        end;
        local node = cpp.newEnemy();
        (node).entityId = (function() local __old = (ctx).nextEntityId_; (ctx).nextEntityId_ = (ctx).nextEntityId_ + 1; return __old end)();
        (node).spawnType = spawnType;
        (node).updateCase = updateCase;
        (node).sourceHitPoints = hitPoints;
        (node).sourceX = cpp.lround(offsetX);
        (node).sourceY = cpp.lround(offsetY);
        (node).sourceNote = "S10 final-boss recovered auxiliary node";
        (node).sourceDispatchKind = (function() if ((spawnType >= 278) and (spawnType <= 281)) then return 80 else return 0 end end)();
        (node).sourceDispatchField = radius;
        (node).parentEntityId = parentEntityId;
        (node).parentSpawnType = parentSpawnType;
        (node).childIndex = childIndex;
        (node).x = f32(x);
        (node).y = f32(y);
        (node).originX = f32(offsetX);
        (node).originY = f32(offsetY);
        (node).markerDrawX = f32(x);
        (node).markerDrawY = f32(y);
        (node).sourceAngle16 = ((16384 % 65536) % 65536);
        (node).secondaryAngle16 = ((16384 % 65536) % 65536);
        (node).targetAngle16 = ((16384 % 65536) % 65536);
        (node).angle = f32(f32(fixedAngleRadians((16384 % 65536))));
        (node).sourceSpeed = (function() if ((spawnType == 283) or (spawnType == 284)) then return 10 else return 1 end end)();
        (node).speed = f32(f32((node).sourceSpeed));
        local hpScale = (function() if (((ctx).config_).difficulty == 0) then return 0.80000000000000004 else return 1 end end)();
        (node).hp = math.max(1, trunc((hitPoints * hpScale)));
        (node).maxHp = (node).hp;
        (node).drawHp = (node).hp;
        (node).radius = radius;
        (node).activationDelay = 0;
        (node).rewardWeight = (node).sourceDispatchKind;
        (node).targetable = false;
        cpp.push((ctx).pendingEnemies_, node);
        do return (node).entityId end
    end;
    if (((enemy).helperState == 0) and ((enemy).helperTimer == 0)) then
        do
            if ((enemy).spawnType == 277) then
                do
                    (spawnAuxNode)(278, (enemy).entityId, (enemy).spawnType, 0, f32(170), f32(150), f32(170), f32(150), 7000, 120);
                    (spawnAuxNode)(279, (enemy).entityId, (enemy).spawnType, 1, f32(550), f32(150), f32(550), f32(150), 7000, 120)
                end
            else
                if ((enemy).spawnType == 282) then
                    do
                        local centerId = (spawnAuxNode)(283, (enemy).entityId, (enemy).spawnType, 0, (enemy).x, (enemy).y, f32(0), f32((-f32(80))), 99999999, 100);
                        if (centerId ~= 0) then
                            do
                                (spawnAuxNode)(284, centerId, 283, 0, (enemy).x, f32(((enemy).y - f32(80))), f32(0), f32(80), 99999999, 100)
                            end
                        end
                    end
                else
                    if ((enemy).spawnType == 285) then
                        do
                            local kTypes = {286, 287, 287, 288, 288, 289, 289, 290, 290};
                            local kOffsetX = {f32(0), f32(70), f32((-f32(70))), f32(160), f32((-f32(160))), f32(240), f32((-f32(240))), f32(300), f32((-f32(300)))};
                            local kOffsetY = {f32((-f32(300))), f32((-f32(180))), f32((-f32(180))), f32((-f32(260))), f32((-f32(260))), f32((-f32(310))), f32((-f32(310))), f32((-f32(240))), f32((-f32(240)))};
                            local kSpeed = {10, 20, 20, 30, 30, 40, 40, 50, 50};
                            do
                                local i = 0
                                while (i < (#kTypes)) do
                                    do
                                        local entityId = (spawnAuxNode)((kTypes)[i + 1], (enemy).entityId, (enemy).spawnType, i, (enemy).x, (enemy).y, (kOffsetX)[i + 1], (kOffsetY)[i + 1], 99999999, 60);
                                        if ((entityId ~= 0) and (not (#(ctx).pendingEnemies_ == 0))) then
                                            do
                                                (((ctx).pendingEnemies_)[#(ctx).pendingEnemies_]).sourceSpeed = (kSpeed)[i + 1];
                                                (((ctx).pendingEnemies_)[#(ctx).pendingEnemies_]).speed = f32(f32((kSpeed)[i + 1]));
                                                (((ctx).pendingEnemies_)[#(ctx).pendingEnemies_]).hp = (enemy).hp;
                                                (((ctx).pendingEnemies_)[#(ctx).pendingEnemies_]).maxHp = (enemy).maxHp;
                                                (((ctx).pendingEnemies_)[#(ctx).pendingEnemies_]).drawHp = (enemy).drawHp
                                            end
                                        end
                                    end
                                    i = i + 1
                                end
                            end
                        end
                    end
                end
            end
        end
    end;
    if (((enemy).helperState < 98) and (((parent).helperState == (spec).parentBreakState) or ((parent).helperState == 200))) then
        do
            if (((enemy).spawnType ~= 295) and ((enemy).spawnType ~= 301)) then
                do
                    if ((ctx).lateStageBossCountdown_ < 1) then
                        do
                            ctx:flushEnemyProjectilesToEffects();
                            ((ctx).player_).invulnerableFrames = math.max(((ctx).player_).invulnerableFrames, 100)
                        end
                    else
                        do
                            ctx:spawnPlayerSideObject(24, (enemy).x, (enemy).y, 0, (0 % 65536), 0, f32(0))
                        end
                    end;
                    ctx:spawnBossPhaseBreakFeedback(enemy, (ctx).lateStageBossCountdown_)
                end
            end;
            if (((enemy).spawnType ~= 277) and ((enemy).spawnType ~= 295)) then
                do
                    local spawnCounter = true;
                    if ((enemy).spawnType == 301) then
                        do
                            spawnCounter = ((ctx).lateStageBossCountdown_ >= 1500);
                            if spawnCounter then
                                do
                                    ctx:spawnPlayerSideObject(25, (enemy).x, (enemy).y, 0, (0 % 65536), 0, f32(0))
                                end
                            else
                                do
                                    ((ctx).player_).invulnerableFrames = math.max(((ctx).player_).invulnerableFrames, 100)
                                end
                            end
                        end
                    end;
                    if spawnCounter then
                        do
                            ctx:spawnPostDeathCounterEntity(enemy, ((enemy).radius * 0.59999999999999998))
                        end
                    end
                end
            end;
            (enemy).helperState = (function() if ((enemy).spawnType == 295) then return 98 else return 99 end end)();
            (enemy).helperTimer = 0;
            (enemy).targetable = false;
            (enemy).targetableTimer = 0;
            if (((enemy).spawnType ~= 295) and ((enemy).spawnType ~= 301)) then
                do
                    ctx:spawnStage02DeathExplosionChain(enemy)
                end
            end
        end
    end;
    if (((enemy).helperState == 99) and ((enemy).spawnType ~= 295)) then
        do
            (enemy).targetable = false;
            (enemy).drawBodyThisFrame = ((enemy).helperTimer < 100);
            if ((enemy).spawnType == 301) then
                do
                    if ((enemy).helperTimer == 1) then
                        do
                            ctx:spawnStageEffect(54, (-1), 0, 40, (enemy).x, (enemy).y, (0 % 65536), 0, 1, 1, 0, 255, 255, 255, 255, 0)
                        end
                    end;
                    if (((enemy).helperTimer < 90) and (math.fmod((enemy).helperTimer, 3) == 0)) then
                        do
                            ctx:spawnStage02DeathExplosionChain(enemy)
                        end
                    end;
                    if ((enemy).helperTimer == 90) then
                        do
                            ctx:playPlayerSound((ctx).blast2SoundHandle_, 25);
                            ctx:spawnStageEffect(17, (-1), 0, 40, (enemy).x, (enemy).y, (0 % 65536), 0, 1, 1, 0, 255, 255, 255, 255, 0)
                        end
                    end
                end
            else
                if ((enemy).helperTimer < 90) then
                    do
                        (enemy).y = f32(f32(((enemy).y + f32((f32((enemy).helperTimer) * f32(0.0199999996))))));
                        if (math.fmod((enemy).helperTimer, 6) == 0) then
                            do
                                ctx:spawnStage02DeathExplosionChain(enemy)
                            end
                        end
                    end
                end
            end;
            if (((enemy).spawnType ~= 301) and ((enemy).helperTimer == 90)) then
                do
                    ctx:playPlayerSound((ctx).blast2SoundHandle_, 25);
                    ctx:spawnEnemyDeathEffects(enemy, 1, false)
                end
            end;
            if ((enemy).helperTimer >= 140) then
                do
                    (enemy).active = false;
                    if ((parent).liveChildCount > 0) then
                        do
                            (parent).liveChildCount = (parent).liveChildCount - 1
                        end
                    end
                end
            end;
            do return end
        end
    end;
    if ((enemy).helperState == 0) then
        do
            (enemy).targetable = false;
            local materializeLength = 190;
            if ((((enemy).spawnType == 293) or ((enemy).spawnType == 294)) or ((enemy).spawnType == 301)) then
                do
                    materializeLength = 250
                end
            else
                if ((enemy).spawnType == 295) then
                    do
                        materializeLength = 270
                    end
                end
            end;
            if ((enemy).helperTimer >= materializeLength) then
                do
                    (enemy).helperState = 1;
                    (enemy).helperTimer = 0;
                    if ((enemy).spawnType == 277) then
                        do
                            do return end
                        end
                    end;
                    (enemy).hp = math.max(1, (parent).hp);
                    (enemy).maxHp = math.max(1, (parent).maxHp);
                    (enemy).drawHp = (parent).drawHp;
                    (enemy).targetable = false;
                    (enemy).targetableTimer = 0;
                    do
                        local __switch167 = (enemy).spawnType
                        if __switch167 == 273 then __switch167 = 1
                        elseif __switch167 == 274 then __switch167 = 2
                        elseif __switch167 == 275 then __switch167 = 3
                        elseif __switch167 == 277 then __switch167 = 4
                        elseif __switch167 == 282 then __switch167 = 5
                        elseif __switch167 == 285 then __switch167 = 6
                        elseif __switch167 == 293 then __switch167 = 7
                        elseif __switch167 == 294 then __switch167 = 8
                        elseif __switch167 == 295 then __switch167 = 9
                        elseif __switch167 == 301 then __switch167 = 10
                        else __switch167 = 11 end
                        repeat
                            if __switch167 <= 1 then
                                (enemy).sourceSpeed = 0.29999999999999999;
                                do break end;
                            end
                            if __switch167 <= 2 then
                                (enemy).sourceSpeed = 30;
                                (enemy).markerDrawX = f32(f32(540));
                                (enemy).markerDrawY = f32(f32(330));
                                do break end;
                            end
                            if __switch167 <= 3 then
                                (enemy).sourceSpeed = 0.5;
                                do break end;
                            end
                            if __switch167 <= 4 then
                                (enemy).sourceSpeed = 1;
                                do break end;
                            end
                            if __switch167 <= 5 then
                                (enemy).sourceSpeed = 70;
                                (enemy).markerDrawX = f32(f32(300));
                                (enemy).markerDrawY = f32(f32(140));
                                do break end;
                            end
                            if __switch167 <= 6 then
                                (enemy).sourceSpeed = 20;
                                (enemy).markerDrawX = f32(f32(320));
                                (enemy).markerDrawY = f32(f32(220));
                                do break end;
                            end
                            if __switch167 <= 7 then
                                (enemy).sourceSpeed = 0.29999999999999999;
                                (enemy).markerDrawX = f32(f32(510));
                                (enemy).markerDrawY = f32(f32(250));
                                do break end;
                            end
                            if __switch167 <= 8 then
                                (enemy).sourceSpeed = 0.29999999999999999;
                                (enemy).markerDrawX = f32(f32(210));
                                (enemy).markerDrawY = f32(f32(250));
                                do break end;
                            end
                            if __switch167 <= 9 then
                                (enemy).sourceSpeed = 0.29999999999999999;
                                (enemy).markerDrawX = f32(f32(360));
                                (enemy).markerDrawY = f32(f32(250));
                                do break end;
                            end
                            if __switch167 <= 10 then
                                (enemy).sourceSpeed = 0.29999999999999999;
                                (enemy).markerDrawX = f32(f32(360));
                                (enemy).markerDrawY = f32(f32(290));
                                do break end;
                            end
                            if __switch167 <= 11 then
                                do break end
                            end
                        until true
                    end
                end
            end;
            do return end
        end
    end;
    if ((enemy).spawnType == 277) then
        do
            (enemy).targetable = false
        end
    else
        do
            if ((enemy).hp < (parent).hp) then
                do
                    (parent).hp = (enemy).hp
                end
            else
                if ((parent).hp < (enemy).hp) then
                    do
                        (enemy).hp = (parent).hp
                    end
                end
            end;
            if (((parent).hp < 1) or ((enemy).hp < 1)) then
                do
                    (parent).hp = math.min((parent).hp, (enemy).hp);
                    (enemy).hp = (parent).hp
                end
            end;
            (enemy).drawHp = (parent).drawHp;
            (enemy).targetable = true
        end
    end;
    local timer = (enemy).helperTimer;
    local aimAt = function(x, y)
        x = f32(x);
        y = f32(y);
        do return radiansToAngle16(math.atan2(f32((((ctx).player_).y - y)), f32((((ctx).player_).x - x)))) end
    end;
    local steerAndMove = function(targetX, targetY, turnStep, speed)
        targetX = f32(targetX);
        targetY = f32(targetY);
        local target = radiansToAngle16(math.atan2(f32((targetY - (enemy).y)), f32((targetX - (enemy).x))));
        (enemy).sourceAngle16 = (approachAngle16((enemy).sourceAngle16, target, turnStep) % 65536);
        local radians = fixedAngleRadians((enemy).sourceAngle16);
        (enemy).x = f32(f32(((enemy).x + f32((math.cos(radians) * speed)))));
        (enemy).y = f32(f32(((enemy).y + f32((math.sin(radians) * speed)))))
    end;
    local moveByDivisor = function(targetX, targetY, divisor)
        targetX = f32(targetX);
        targetY = f32(targetY);
        local dx = f32((targetX - (enemy).x));
        local dy = f32((targetY - (enemy).y));
        (enemy).x = f32(f32(((enemy).x + f32((dx / f32(math.max(1, divisor)))))));
        (enemy).y = f32(f32(((enemy).y + f32((dy / f32(math.max(1, divisor)))))));
        (enemy).sourceAngle16 = (radiansToAngle16(math.atan2(dy, dx)) % 65536)
    end;
    local fired = false;
    do
        local __switch180 = (enemy).spawnType
        if __switch180 == 273 then __switch180 = 1
        elseif __switch180 == 274 then __switch180 = 2
        elseif __switch180 == 275 then __switch180 = 3
        elseif __switch180 == 277 then __switch180 = 4
        elseif __switch180 == 282 then __switch180 = 5
        elseif __switch180 == 285 then __switch180 = 6
        elseif __switch180 == 293 then __switch180 = 7
        elseif __switch180 == 294 then __switch180 = 8
        elseif __switch180 == 295 then __switch180 = 9
        elseif __switch180 == 301 then __switch180 = 10
        else __switch180 = 11 end
        repeat
            if __switch180 <= 1 then
                do
                    if (math.fmod(timer, 50) == 0) then
                        do
                            (enemy).markerDrawX = f32(f32((f32(210) + f32(math.fmod(lateBossFrameRand(((ctx).frame_ + (enemy).entityId)), 301)))));
                            (enemy).markerDrawY = f32(f32((f32(200) + f32(math.fmod(lateBossFrameRand((((ctx).frame_ + 1111) + (enemy).entityId)), 101)))))
                        end
                    end;
                    (steerAndMove)((enemy).markerDrawX, (enemy).markerDrawY, 512, 0.29999999999999999);
                    if (timer >= 30) then
                        do
                            local v_local = math.fmod((timer - 30), 920);
                            local shortFan = ((((v_local >= 30) and (v_local < 70)) or ((v_local >= 480) and (v_local < 520))) and (bit.band(v_local, 3) == 0));
                            if shortFan then
                                do
                                    local aimed = (aimAt)(f32(((enemy).x - f32(99))), f32(((enemy).y - f32(120))));
                                    ctx:spawnProjectileSpread(11, 0, f32(((enemy).x - f32(99))), f32(((enemy).y - f32(120))), aimed, f32(0), 11.1, 6, 5, 10000, 0);
                                    fired = true
                                end
                            end;
                            if (v_local == 80) then
                                do
                                    (enemy).secondaryAngle16 = (normalizeAngle16(((aimAt)(f32(((enemy).x + f32(108))), f32(((enemy).y - f32(105)))) - 16384)) % 65536)
                                end
                            end;
                            if (((v_local >= 80) and (v_local < 390)) and (bit.band(v_local, 1) == 0)) then
                                do
                                    local speed = (5.5 + ((v_local - 80) * 0.025000000000000001));
                                    ctx:spawnProjectileNode(2, 57, f32(((enemy).x + f32(108))), f32(((enemy).y - f32(105))), (enemy).secondaryAngle16, f32(0), speed, 6, 0);
                                    ctx:spawnProjectileNode(3, 9, f32(((enemy).x + f32(108))), f32(((enemy).y - f32(105))), (enemy).secondaryAngle16, f32(0), (speed + 2), 6, 0);
                                    (enemy).secondaryAngle16 = (normalizeAngle16(((enemy).secondaryAngle16 - 2400)) % 65536);
                                    fired = true
                                end
                            end;
                            if (((v_local >= 520) and (v_local < 900)) and (bit.band((v_local - 520), 7) == 0)) then
                                do
                                    local aimed = (aimAt)(f32(((enemy).x + f32(108))), f32(((enemy).y - f32(105))));
                                    local oscillation = trunc((math.sin(((timer * kTau) / 150)) * 12000));
                                    local speed = (5 + ((v_local - 520) * 0.016));
                                    ctx:spawnProjectileSpread(2, 0, f32(((enemy).x + f32(108))), f32(((enemy).y - f32(105))), normalizeAngle16((aimed + oscillation)), f32(0), speed, 6, 9, 24000, 0);
                                    fired = true
                                end
                            end
                        end
                    end;
                    do break end
                end;
            end
            if __switch180 <= 2 then
                do
                    local v_local = math.fmod(timer, 1100);
                    if (v_local == 1) then
                        do
                            (enemy).markerDrawX = f32(f32(540));
                            (enemy).markerDrawY = f32(f32(330));
                            (enemy).sourceSpeed = 10
                        end
                    else
                        if (v_local == 40) then
                            do
                                (enemy).markerDrawX = f32(f32(120));
                                (enemy).markerDrawY = f32(f32(240));
                                (enemy).sourceSpeed = 20
                            end
                        else
                            if (v_local == 110) then
                                do
                                    (enemy).markerDrawX = f32(f32(500));
                                    (enemy).markerDrawY = f32(f32(190))
                                end
                            else
                                if (v_local == 180) then
                                    do
                                        (enemy).markerDrawX = f32(f32(150));
                                        (enemy).markerDrawY = f32(f32(160))
                                    end
                                else
                                    if (v_local == 250) then
                                        do
                                            (enemy).markerDrawX = f32(f32(380));
                                            (enemy).markerDrawY = f32(f32(60))
                                        end
                                    else
                                        if (((v_local >= 360) and (v_local < 600)) and (math.fmod(v_local, 20) == 0)) then
                                            do
                                                (enemy).markerDrawX = f32(f32((f32(160) + f32(math.fmod(lateBossFrameRand(((ctx).frame_ + (enemy).entityId)), 361)))));
                                                (enemy).markerDrawY = f32(f32((f32(80) + f32(math.fmod(lateBossFrameRand(((ctx).frame_ + 5555)), 221)))));
                                                (enemy).sourceSpeed = 5
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end;
                    (moveByDivisor)((enemy).markerDrawX, (enemy).markerDrawY, math.max(5, (enemy).sourceSpeed));
                    if ((v_local >= 40) and (v_local < 320)) then
                        do
                            local segment = math.fmod((v_local - 40), 70);
                            if ((segment <= 35) and (bit.band(segment, 1) == 0)) then
                                do
                                    local aimed = (aimAt)((enemy).x, (enemy).y);
                                    local kBaseSpeeds = {5, 7, 9, 11, 13};
                                    do

                                        for _, baseSpeed in ipairs(kBaseSpeeds) do
                                            do
                                                ctx:spawnProjectileNode(13, 4, (enemy).x, (enemy).y, aimed, f32(0), (baseSpeed + (segment * 0.29999999999999999)), 1, 0)
                                            end
                                        end
                                    end;
                                    fired = true
                                end
                            end;
                            if (((v_local >= 90) and (v_local < 320)) and (math.fmod((v_local - 90), 70) == 0)) then
                                do
                                    local ringTime = (v_local - 90);
                                    local base = normalizeAngle16(lateBossFrameRand(timer));
                                    ctx:spawnProjectileSpread(10, 0, (enemy).x, (enemy).y, base, f32(0), (3 + (ringTime * 0.012)), 1, 25, 65536, 0);
                                    ctx:spawnProjectileSpread(10, 0, (enemy).x, (enemy).y, (aimAt)((enemy).x, (enemy).y), f32(0), (4 + (ringTime * 0.017000000000000001)), 1, 25, 65536, 0);
                                    fired = true
                                end
                            end
                        end
                    end;
                    if (((v_local >= 360) and (v_local < 600)) and (math.fmod(v_local, 20) == 0)) then
                        do
                            local aimed = (aimAt)((enemy).x, (enemy).y);
                            local speed = (5 + ((v_local - 350) * 0.0070000000000000001));
                            do
                                local i = 0
                                while (i < 7) do
                                    do
                                        local angle = normalizeAngle16(((aimed - 2000) + (i * 666)));
                                        ctx:spawnProjectileNode(13, 1, (enemy).x, (enemy).y, angle, f32(0), speed, 1, 0);
                                        ctx:spawnProjectileNode(13, 1, (enemy).x, (enemy).y, angle, f32(0), (speed + 1), 1, 0)
                                    end
                                    i = i + 1
                                end
                            end;
                            fired = true
                        end
                    end;
                    if ((v_local >= 640) and (v_local < 1060)) then
                        do
                            local speed = (3.6000000000000001 + ((v_local - 640) * 0.0070000000000000001));
                            ctx:spawnProjectileNode(13, 3, (enemy).x, (enemy).y, normalizeAngle16((timer * 2400)), f32(0), speed, 1, 0);
                            if (bit.band(v_local, 1) == 0) then
                                do
                                    ctx:spawnProjectileNode(12, 3, (enemy).x, (enemy).y, normalizeAngle16(((-timer) * 1000)), f32(0), (speed + 1.1499999999999999), 1, 0)
                                end
                            end;
                            fired = true
                        end
                    end;
                    do break end
                end;
            end
            if __switch180 <= 3 then
                do
                    if (timer == 1) then
                        do
                            local kOffsetX = {f32(100), f32((-f32(100))), f32(210), f32((-f32(210)))};
                            local kOffsetY = {f32((-f32(120))), f32((-f32(120))), f32((-f32(70))), f32((-f32(70)))};
                            do
                                local i = 0
                                while (i < (#kOffsetX)) do
                                    do
                                        (spawnAuxNode)(276, (enemy).entityId, (enemy).spawnType, i, (enemy).x, (enemy).y, (kOffsetX)[i + 1], (kOffsetY)[i + 1], 99999999, 40)
                                    end
                                    i = i + 1
                                end
                            end
                        end
                    end;
                    if (math.fmod(timer, 50) == 0) then
                        do
                            (enemy).markerDrawX = f32(f32((f32(240) + f32(math.fmod(lateBossFrameRand(((ctx).frame_ + (enemy).entityId)), 241)))));
                            (enemy).markerDrawY = f32(f32((f32(150) + f32(math.fmod(lateBossFrameRand(((ctx).frame_ + 3333)), 101)))))
                        end
                    end;
                    local speed = (function() if (timer < 180) then return (0.5 + (3.5 * math.sin(((timer * kPi) / 360)))) else return 4 end end)();
                    (steerAndMove)((enemy).markerDrawX, (enemy).markerDrawY, 768, speed);
                    if (timer >= 40) then
                        do
                            local v_local = math.fmod((timer - 40), 1200);
                            local burst = math.fmod(v_local, 80);
                            if (burst == 0) then
                                do
                                    (enemy).secondaryAngle16 = (((function() if (v_local < 420) then return (function() if ((enemy).y <= ((ctx).player_).y) then return 16384 else return 49152 end end)() else return (aimAt)((enemy).x, f32(((enemy).y + f32(20)))) end end)() % 65536) % 65536)
                                end
                            end;
                            if ((burst < 40) and (math.fmod(burst, 5) == 0)) then
                                do
                                    ctx:spawnProjectileNode(7, 1, f32(((enemy).x + f32(20))), f32(((enemy).y + f32(20))), (enemy).secondaryAngle16, f32(10), 8, 1, 0);
                                    ctx:spawnProjectileNode(7, 1, f32(((enemy).x - f32(20))), f32(((enemy).y + f32(20))), (enemy).secondaryAngle16, f32(10), 8, 1, 0);
                                    fired = true
                                end
                            end
                        end
                    end;
                    do break end
                end;
            end
            if __switch180 <= 4 then
                do
                    local scheduleClock = timer;
                    local scheduledTimer = 20;
                    do
                        local i = 0
                        while (i < 30) do
                            do
                                if ((scheduleClock >= 20) and (scheduleClock < scheduledTimer)) then
                                    do
                                        local isActive = function(node)
                                            do return (node).active end
                                        end;
                                        local activeCount = (cpp.count_if((ctx).enemies_, (ctx).enemies_, isActive) + cpp.count_if((ctx).pendingEnemies_, (ctx).pendingEnemies_, isActive));
                                        if (activeCount < 3) then
                                            do
                                                scheduleClock = scheduledTimer;
                                                (enemy).helperTimer = scheduledTimer
                                            end
                                        end
                                    end
                                end;
                                if (scheduleClock == scheduledTimer) then
                                    do
                                        local selector = bit.band(i, 3);
                                        local type = (function() if (selector == 0) then return 280 else return (function() if (selector == 1) then return 281 else return (function() if (selector == 2) then return 278 else return 279 end end)() end end)() end end)();
                                        local spawnX = f32(170);
                                        if (math.fmod(i, 3) == 0) then
                                            do
                                                spawnX = f32(f32((f32(260) + f32(math.fmod(lateBossFrameRand(scheduleClock), 201)))))
                                            end
                                        else
                                            if (math.fmod(i, 3) == 2) then
                                                do
                                                    spawnX = f32(f32(550))
                                                end
                                            end
                                        end;
                                        (spawnAuxNode)(type, (enemy).entityId, (enemy).spawnType, (i + 2), spawnX, f32((-f32(150))), spawnX, f32((-f32(150))), 10000, 120)
                                    end
                                end;
                                if (math.fmod(i, 3) ~= 1) then
                                    do
                                        scheduledTimer = (scheduledTimer + 260)
                                    end
                                end
                            end
                            i = i + 1
                        end
                    end;
                    do break end
                end;
            end
            if __switch180 <= 5 then
                do
                    if (((enemy).helperState == 1) or ((enemy).helperState == 3)) then
                        do
                            if (math.fmod(timer, 90) == 0) then
                                do
                                    (enemy).markerDrawX = f32(f32((f32(210) + f32(math.fmod(lateBossFrameRand(((ctx).frame_ + (enemy).entityId)), 301)))));
                                    (enemy).markerDrawY = f32(f32((f32(200) + f32(math.fmod(lateBossFrameRand(((ctx).frame_ + 5555)), 101)))))
                                end
                            end;
                            (moveByDivisor)((enemy).markerDrawX, (enemy).markerDrawY, math.max(10, (enemy).sourceSpeed));
                            if (((timer >= 30) and (timer < 360)) and (math.fmod((timer - 30), 30) == 0)) then
                                do
                                    ctx:spawnProjectileSpread(3, 0, (enemy).x, f32(((enemy).y - f32(100))), (aimAt)((enemy).x, f32(((enemy).y - f32(100)))), f32(0), 8.8000000000000007, 6, 5, 11248, 0);
                                    fired = true
                                end
                            end;
                            local ringCadence = (function() if ((enemy).helperState == 3) then return 13 else return 27 end end)();
                            if (((timer >= 30) and (timer < 360)) and (math.fmod((timer - 30), ringCadence) == 0)) then
                                do
                                    ctx:spawnProjectileSpread(4, 0, (enemy).x, f32(((enemy).y - f32(100))), normalizeAngle16((timer * 60)), f32(0), 6.7999999999999998, 6, 29, 65536, 0);
                                    fired = true
                                end
                            end;
                            if (timer >= 360) then
                                do
                                    (enemy).helperState = 2;
                                    (enemy).helperTimer = 0;
                                    (enemy).sourceSpeed = 30
                                end
                            end
                        end
                    else
                        if ((enemy).helperState == 2) then
                            do
                                local phase = f32((math.sin(((timer * kTau) / 220)) * 180));
                                (enemy).markerDrawX = f32(f32((f32(360) + phase)));
                                (enemy).markerDrawY = f32(f32(((enemy).markerDrawY - f32(0.100000001))));
                                (moveByDivisor)((enemy).markerDrawX, (enemy).markerDrawY, 30);
                                local fireMirrorBurst = function(right)
                                    local sideX = f32(((enemy).x + (function() if right then return f32(120) else return f32((-f32(120))) end end)()));
                                    local fireY = f32(((enemy).y - f32(70)));
                                    do
                                        local i = 0
                                        while (i < 30) do
                                            do
                                                local jitterX = (math.fmod(lateBossFrameRand((timer + (i * 55))), 41) - 20);
                                                local angle3 = normalizeAngle16((15884 + math.fmod(lateBossFrameRand((timer + (i * 5555))), 1001)));
                                                local angle5 = normalizeAngle16((15884 + math.fmod(lateBossFrameRand((timer + (i * 55555))), 1001)));
                                                ctx:spawnProjectileNode(3, 0, f32((sideX + f32(jitterX))), fireY, angle3, f32(0), (8 + i), 1, 0);
                                                ctx:spawnProjectileNode(5, 0, f32((sideX + f32(jitterX))), fireY, angle5, f32(0), (8.3000000000000007 + i), 1, 0)
                                            end
                                            i = i + 1
                                        end
                                    end;
                                    local ringSeed = (math.fmod(lateBossFrameRand(timer), 1001) - 30384);
                                    do
                                        local i = 0
                                        while (i < 27) do
                                            do
                                                ctx:spawnProjectileNode(2, 0, sideX, fireY, normalizeAngle16((ringSeed + (i * 1038))), f32(0), 11.1, 1, 0)
                                            end
                                            i = i + 1
                                        end
                                    end;
                                    local kSpeeds = {5, 6, 7};
                                    local kRightBases = {13768, 15768, 17768};
                                    local kLeftBases = {(-11000), (-13000), (-15000)};
                                    do
                                        local layer = 0
                                        while (layer < (#kSpeeds)) do
                                            do
                                                local base = (function() if right then return (kRightBases)[layer + 1] else return (kLeftBases)[layer + 1] end end)();
                                                do
                                                    local i = 0
                                                    while (i < 11) do
                                                        do
                                                            ctx:spawnProjectileNode(4, 0, (enemy).x, (enemy).y, normalizeAngle16((base + (i * 3000))), f32(0), (kSpeeds)[layer + 1], 1, 0)
                                                        end
                                                        i = i + 1
                                                    end
                                                end
                                            end
                                            layer = layer + 1
                                        end
                                    end
                                end;
                                if (((timer >= 60) and (timer < 620)) and (math.fmod((timer - 60), 72) == 0)) then
                                    do
                                        (fireMirrorBurst)(true);
                                        fired = true
                                    end
                                end;
                                if (((timer >= 96) and (timer < 620)) and (math.fmod((timer - 96), 72) == 0)) then
                                    do
                                        (fireMirrorBurst)(false);
                                        fired = true
                                    end
                                end;
                                if (timer >= 640) then
                                    do
                                        (enemy).helperState = 3;
                                        (enemy).helperTimer = 19;
                                        (enemy).sourceSpeed = 70
                                    end
                                end
                            end
                        end
                    end;
                    do break end
                end;
            end
            if __switch180 <= 6 then
                do
                    if ((enemy).helperState == 1) then
                        do
                            if (timer == 1) then
                                do
                                    (enemy).markerDrawX = f32(f32(320));
                                    (enemy).markerDrawY = f32(f32(220))
                                end
                            else
                                if ((timer >= 210) and (timer < 421)) then
                                    do
                                        local phase = (((timer - 210) * kTau) / 210);
                                        (enemy).markerDrawX = f32(f32((f32(360) - f32((math.sin(phase) * 240)))));
                                        (enemy).markerDrawY = f32(f32((f32(250) + f32((math.cos(phase) * 80)))))
                                    end
                                end
                            end;
                            (moveByDivisor)((enemy).markerDrawX, (enemy).markerDrawY, 20);
                            if (timer >= 450) then
                                do
                                    (enemy).helperState = 2;
                                    (enemy).helperTimer = 0;
                                    (enemy).sourceSpeed = 0.69999999999999996
                                end
                            end
                        end
                    else
                        if ((enemy).helperState == 2) then
                            do
                                if (math.fmod(timer, 50) == 0) then
                                    do
                                        (enemy).markerDrawX = f32(f32((f32(210) + f32(math.fmod(lateBossFrameRand(((ctx).frame_ + (enemy).entityId)), 301)))));
                                        (enemy).markerDrawY = f32(f32((f32(220) + f32(math.fmod(lateBossFrameRand(((ctx).frame_ + 1111)), 101)))))
                                    end
                                end;
                                (steerAndMove)((enemy).markerDrawX, (enemy).markerDrawY, 512, 0.69999999999999996);
                                if (timer >= 800) then
                                    do
                                        (enemy).helperState = 1;
                                        (enemy).helperTimer = 0;
                                        (enemy).sourceSpeed = 20
                                    end
                                end
                            end
                        end
                    end;
                    do break end
                end;
            end
            if __switch180 <= 8 then
                do
                    local right = ((enemy).spawnType == 293);
                    if (math.fmod(timer, 50) == 0) then
                        do
                            (enemy).markerDrawX = f32(f32(((function() if right then return f32(460) else return f32(160) end end)() + f32(math.fmod(lateBossFrameRand(((ctx).frame_ + (enemy).entityId)), 101)))));
                            (enemy).markerDrawY = f32(f32((f32(200) + f32(math.fmod(lateBossFrameRand(((ctx).frame_ + ((enemy).entityId * 7777))), 101)))))
                        end
                    end;
                    (steerAndMove)((enemy).markerDrawX, (enemy).markerDrawY, 512, 0.29999999999999999);
                    if (timer < 10) then
                        do
                            do break end
                        end
                    end;
                    local v_local = math.fmod((timer - 10), 1800);
                    local muzzleX = f32(((enemy).x + (function() if right then return f32((-f32(88))) else return f32(80) end end)()));
                    local muzzleY = f32(((enemy).y + (function() if right then return f32((-f32(120))) else return f32((-f32(122))) end end)()));
                    local aimed = (aimAt)(muzzleX, muzzleY);
                    local kFanBases = {0, 420, 870};
                    do

                        for _, base in ipairs(kFanBases) do
                            do
                                if (v_local == (base + 30)) then
                                    do
                                        (enemy).secondaryAngle16 = (aimed % 65536)
                                    end
                                end;
                                if (((v_local >= (base + 30)) and (v_local < (base + 70))) and (math.fmod(((v_local - base) - 30), 4) == 0)) then
                                    do
                                        local visual = (function() if right then return 11 else return 10 end end)();
                                        local speed = (6 + (((v_local - base) - 30) * 0.29999999999999999));
                                        do
                                            local i = 0
                                            while (i < 5) do
                                                do
                                                    ctx:spawnProjectileNode(visual, 0, muzzleX, muzzleY, normalizeAngle16((((enemy).secondaryAngle16 - 3000) + (i * 1500))), f32(10), speed, 1, 0)
                                                end
                                                i = i + 1
                                            end
                                        end;
                                        (enemy).secondaryAngle16 = (approachAngle16((enemy).secondaryAngle16, aimed, 320) % 65536);
                                        fired = true
                                    end
                                end
                            end
                        end
                    end;
                    local earlyStart = (function() if right then return 60 else return 74 end end)();
                    if (((v_local >= earlyStart) and (v_local < 420)) and (math.fmod((v_local - earlyStart), 28) == 0)) then
                        do
                            local amplitude = (function() if right then return 9000 else return (-14162) end end)();
                            local oscillation = trunc((math.sin((((timer - 90) * kTau) / 180)) * amplitude));
                            local speed = (4 + ((v_local - 60) * 0.016));
                            do
                                local i = 0
                                while (i < 13) do
                                    do
                                        ctx:spawnProjectileNode((function() if right then return 3 else return 2 end end)(), 0, muzzleX, muzzleY, normalizeAngle16((((aimed + oscillation) - 12000) + (i * 2000))), f32(10), speed, 1, 0)
                                    end
                                    i = i + 1
                                end
                            end;
                            fired = true
                        end
                    end;
                    if (((right and (v_local >= 480)) and (v_local < 870)) and (math.fmod((v_local - 480), 36) == 0)) then
                        do
                            local speed = (4.5999999999999996 + ((v_local - 480) * 0.0080000000000000002));
                            do
                                local i = 0
                                while (i < 11) do
                                    do
                                        ctx:spawnProjectileNode(5, 0, muzzleX, muzzleY, normalizeAngle16(((aimed - 2000) + (i * 400))), f32(0), speed, 1, 0);
                                        ctx:spawnProjectileNode(5, 0, muzzleX, muzzleY, normalizeAngle16(((aimed + 6000) + (i * 400))), f32(0), speed, 1, 0);
                                        ctx:spawnProjectileNode(5, 0, muzzleX, muzzleY, normalizeAngle16(((aimed - 10000) + (i * 400))), f32(0), speed, 1, 0)
                                    end
                                    i = i + 1
                                end
                            end;
                            fired = true
                        end
                    end;
                    if ((((not right) and (v_local >= 480)) and (v_local < 870)) and (math.fmod((v_local - 480), 6) == 0)) then
                        do
                            local speed = ((5 + ((v_local - 480) * 0.012)) + (math.sin((((timer - 480) * kTau) / 180)) * 0.80000000000000004));
                            do
                                local i = 0
                                while (i < 7) do
                                    do
                                        ctx:spawnProjectileNode(8, 0, muzzleX, muzzleY, normalizeAngle16(((((enemy).secondaryAngle16 + (v_local * 240)) + 15872) + (i * 9362))), f32(0), speed, 1, 0)
                                    end
                                    i = i + 1
                                end
                            end;
                            fired = true
                        end
                    end;
                    local spiralStart = (function() if right then return 930 else return 946 end end)();
                    if (v_local == spiralStart) then
                        do
                            (enemy).secondaryAngle16 = (aimed % 65536)
                        end
                    end;
                    if ((v_local >= spiralStart) and (v_local < 1790)) then
                        do
                            local offset = (v_local - spiralStart);
                            local within32 = bit.band(offset, 31);
                            if ((within32 < 18) and (math.fmod(within32, 3) == 0)) then
                                do
                                    local speed = (5.5 + ((v_local - 930) * 0.01));
                                    do
                                        local i = 0
                                        while (i < 13) do
                                            do
                                                ctx:spawnProjectileNode((function() if right then return 11 else return 10 end end)(), 0, muzzleX, muzzleY, normalizeAngle16(((enemy).secondaryAngle16 + (i * 5041))), f32(10), speed, 1, 0)
                                            end
                                            i = i + 1
                                        end
                                    end;
                                    fired = true
                                end
                            end;
                            local curve = (60 + trunc((v_local - 930) / 16));
                            (enemy).secondaryAngle16 = (normalizeAngle16(((enemy).secondaryAngle16 + (function() if right then return (-curve) else return curve end end)())) % 65536)
                        end
                    end;
                    do break end
                end;
            end
            if __switch180 <= 9 then
                do
                    local advance = function(endTimer)
                        if ((enemy).helperTimer == endTimer) then
                            do
                                (enemy).helperState = (enemy).helperState + 1;
                                (enemy).helperTimer = 0
                            end
                        end
                    end;
                    local state = (enemy).helperState;
                    local travelState = ((((((((((state >= 1) and (state <= 4)) or (state == 6)) or (state == 7)) or (state == 9)) or (state == 11)) or (state == 14)) or (state == 16)) or (state == 25)) or (state == 98));
                    if travelState then
                        do
                            if (timer == 1) then
                                do
                                    (enemy).originX = f32((enemy).x);
                                    (enemy).originY = f32((enemy).y);
                                    local random = lateBossFrameRand((((ctx).frame_ + (enemy).entityId) + (state * 8765)));
                                    (enemy).markerDrawX = f32(f32((f32(160) + f32(math.fmod(random, 401)))));
                                    (enemy).markerDrawY = f32(f32((f32(200) + f32(math.fmod(u32(bit.rshift(random, 8)), 301)))));
                                    if ((state == 14) or (state == 25)) then
                                        do
                                            (enemy).markerDrawX = f32(f32(360));
                                            (enemy).markerDrawY = f32(f32(250))
                                        end
                                    else
                                        if (state == 16) then
                                            do
                                                (enemy).markerDrawX = f32(f32(280));
                                                (enemy).markerDrawY = f32(f32(360))
                                            end
                                        else
                                            if (state == 98) then
                                                do
                                                    (enemy).markerDrawX = f32((parent).x);
                                                    (enemy).markerDrawY = f32((parent).y);
                                                    (enemy).targetable = false
                                                end
                                            end
                                        end
                                    end
                                end
                            end;
                            local p = cpp.clamp((timer / 35), 0, 1);
                            local eased = math.sin(((p * kPi) * 0.5));
                            (enemy).x = f32(f32(((enemy).originX + f32((f32(((enemy).markerDrawX - (enemy).originX)) * eased)))));
                            (enemy).y = f32(f32(((enemy).originY + f32((f32(((enemy).markerDrawY - (enemy).originY)) * eased)))));
                            (enemy).sourceAngle16 = (normalizeAngle16(trunc(((math.atan2(f32(((enemy).markerDrawY - (enemy).y)), f32(((enemy).markerDrawX - (enemy).x))) * 65536) / kTau))) % 65536);
                            (advance)(35);
                            do break end
                        end
                    end;
                    if (((((state == 5) or (state == 8)) or (state == 10)) or (state == 12)) or (state == 13)) then
                        do
                            (steerAndMove)(((ctx).player_).x, ((ctx).player_).y, 512, 0.29999999999999999);
                            if (timer == 40) then
                                do
                                    local emitterType = (function() if (state == 13) then return 300 else return 299 end end)();
                                    local aimed = (aimAt)((enemy).x, (enemy).y);
                                    do
                                        local i = 0
                                        while (i < 4) do
                                            do
                                                ctx:spawnStage10FinalBossEmitter(enemy, emitterType, (enemy).x, (enemy).y, normalizeAngle16((aimed + (i * 16384))), 5, i)
                                            end
                                            i = i + 1
                                        end
                                    end;
                                    if (state ~= 13) then
                                        do
                                            ctx:spawnProjectileSpread(12, 1, (enemy).x, (enemy).y, aimed, f32(0), 5, 1, 20, 65536, 0)
                                        end
                                    end;
                                    fired = true
                                end
                            end;
                            (advance)((function() if (state == 12) then return 60 else return (function() if (state == 13) then return 120 else return 90 end end)() end end)());
                            do break end
                        end
                    end;
                    if (state == 15) then
                        do
                            if (timer < 100) then
                                do
                                    (steerAndMove)(((ctx).player_).x, ((ctx).player_).y, 512, 0.29999999999999999)
                                end
                            end;
                            if (timer == 90) then
                                do
                                    do
                                        local i = 0
                                        while (i < 32) do
                                            do
                                                local random = lateBossFrameRand((((enemy).entityId + (i * 88)) + timer));
                                                local heading = normalizeAngle16(u32(bit.band(random, 65535)));
                                                local speed = (4 + (math.fmod(u32(bit.rshift(random, 16)), 401) / 100));
                                                ctx:spawnStage10FinalBossEmitter(enemy, 297, (enemy).x, (enemy).y, heading, speed, i)
                                            end
                                            i = i + 1
                                        end
                                    end;
                                    fired = true
                                end
                            end;
                            if (timer == 100) then
                                do
                                    (enemy).originX = f32((enemy).x);
                                    (enemy).originY = f32((enemy).y);
                                    (enemy).x = f32(f32((-f32(1000))));
                                    (enemy).y = f32(f32((-f32(1000))))
                                end
                            end;
                            if ((timer >= 150) and (timer < 690)) then
                                do
                                    local cadence = (function() if (timer < 246) then return 24 else return 6 end end)();
                                    if (math.fmod((timer - 150), cadence) == 0) then
                                        do
                                            local random = lateBossFrameRand(((enemy).entityId + (timer * 88888)));
                                            local x = f32((f32(60) + f32(math.fmod(random, 601))));
                                            local angle = normalizeAngle16((((aimAt)(x, f32((-f32(20)))) - 1800) + math.fmod(u32(bit.rshift(random, 16)), 3601)));
                                            ctx:spawnProjectileNode(2, 60, x, f32((-f32(20))), angle, f32(0), 7, 1, 0);
                                            fired = true
                                        end
                                    end
                                end
                            end;
                            (advance)(720);
                            do break end
                        end
                    end;
                    if (state == 17) then
                        do
                            (enemy).targetable = false;
                            (advance)(20);
                            do break end
                        end
                    end;
                    if ((state >= 18) and (state <= 20)) then
                        do
                            if (timer == 50) then
                                do
                                    local base = normalizeAngle16(lateBossFrameRand(((enemy).entityId + (state * 77))));
                                    ctx:spawnProjectileSpread(5, 0, (enemy).x, (enemy).y, base, f32(0), (5 + ((state - 18) * 0.5)), 1, 17, 65536, 0);
                                    fired = true
                                end
                            end;
                            (advance)(50);
                            do break end
                        end
                    end;
                    if ((state >= 21) and (state <= 24)) then
                        do
                            if ((timer == 70) and (state ~= 24)) then
                                do
                                    local base = normalizeAngle16(lateBossFrameRand(((enemy).entityId + (state * 888))));
                                    do
                                        local i = 0
                                        while (i < 4) do
                                            do
                                                ctx:spawnProjectileSpread((function() if (bit.band(i, 1) == 0) then return 5 else return 3 end end)(), 0, (enemy).x, (enemy).y, normalizeAngle16((base + (i * 16384))), f32(0), (3 + (i * 0.40000000000000002)), 1, (27 + (i * 2)), 65536, 0)
                                            end
                                            i = i + 1
                                        end
                                    end;
                                    local stateScale = (function() if (state == 21) then return (1.1000000000000001 + (math.sin(((timer * kPi) / 140)) * 0.5)) else return 1.6000000000000001 end end)();
                                    local radiusWave = math.sin(((timer * kPi) / 70));
                                    local verticalRadius = (((1 - (radiusWave * 0.5)) * stateScale) * 120);
                                    local horizontalRadius = (((0.5 + radiusWave) * stateScale) * 120);
                                    do
                                        local i = 0
                                        while (i < 128) do
                                            do
                                                local positionRandom = lateBossFrameRand((state + (i * 99)));
                                                local orbitAngle = normalizeAngle16((math.fmod(positionRandom, 25601) - 29184));
                                                local orbitRadians = fixedAngleRadians(orbitAngle);
                                                local shotX = f32(((enemy).x + f32((math.cos(orbitRadians) * horizontalRadius))));
                                                local shotY = f32(((enemy).y + f32((math.sin(orbitRadians) * verticalRadius))));
                                                local angleRandom = lateBossFrameRand(((state * 44) + (i * 9999)));
                                                local shotAngle = normalizeAngle16((math.fmod(angleRandom, 25601) - 29184));
                                                local speedRandom = lateBossFrameRand((state + (i * 999)));
                                                local speed = (5 + (math.fmod(speedRandom, 1301) / 100));
                                                ctx:spawnProjectileNode(12, 0, shotX, shotY, shotAngle, f32(0), speed, 1, 0)
                                            end
                                            i = i + 1
                                        end
                                    end;
                                    fired = true
                                end
                            end;
                            (advance)((function() if (state == 24) then return 35 else return 120 end end)());
                            do break end
                        end
                    end;
                    if (state == 26) then
                        do
                            if (timer == 80) then
                                do
                                    do
                                        local i = 0
                                        while (i < 155) do
                                            do
                                                local random = lateBossFrameRand((((enemy).entityId + (timer * 3333)) + (i * 999)));
                                                ctx:spawnProjectileNode(12, 0, (enemy).x, (enemy).y, normalizeAngle16(u32(bit.band(random, 65535))), f32(0), (2.5 + (math.fmod(u32(bit.rshift(random, 16)), 351) / 100)), 1, 0)
                                            end
                                            i = i + 1
                                        end
                                    end;
                                    fired = true
                                end
                            end;
                            if (timer < 120) then
                                do
                                    (steerAndMove)(((ctx).player_).x, ((ctx).player_).y, 512, 0.29999999999999999)
                                end
                            else
                                do
                                    local phase = (((timer - 120) * kTau) / 120);
                                    (enemy).x = f32(f32(((enemy).originX + f32((math.cos(phase) * 80)))));
                                    (enemy).y = f32(f32(((enemy).originY + f32((math.sin(phase) * 90)))))
                                end
                            end;
                            (advance)(240);
                            do break end
                        end
                    end;
                    if ((state >= 27) and (state <= 31)) then
                        do
                            if (timer == 1) then
                                do
                                    local kX = {f32(870), f32((-f32(150))), f32(870), f32(120), f32(400)};
                                    local kY = {f32(100), f32(240), f32(480), f32(870), f32((-f32(150)))};
                                    local kAngle = {30768, 2000, 30768, 51152, 14384};
                                    local index = (state - 27);
                                    (enemy).x = f32((kX)[index + 1]);
                                    (enemy).y = f32((kY)[index + 1]);
                                    (enemy).sourceAngle16 = (normalizeAngle16((kAngle)[index + 1]) % 65536);
                                    (enemy).sourceSpeed = 10
                                end
                            end;
                            if (timer > 49) then
                                do
                                    local radians = fixedAngleRadians((enemy).sourceAngle16);
                                    (enemy).x = f32(f32(((enemy).x + f32((math.cos(radians) * (enemy).sourceSpeed)))));
                                    (enemy).y = f32(f32(((enemy).y + f32((math.sin(radians) * (enemy).sourceSpeed)))));
                                    (enemy).sourceSpeed = ((enemy).sourceSpeed + 0.050000000000000003);
                                    local radiusRandom = lateBossFrameRand(((timer * 88) + state));
                                    local burstRadius = math.fmod(radiusRandom, 111);
                                    local orbitRandom = lateBossFrameRand(((timer * 888) + state));
                                    local burstOrbit = normalizeAngle16(math.fmod(orbitRandom, 65537));
                                    local burstOrbitRadians = fixedAngleRadians(burstOrbit);
                                    local burstX = f32(((enemy).x + f32((math.cos(burstOrbitRadians) * burstRadius))));
                                    local burstY = f32(((enemy).y + f32((math.sin(burstOrbitRadians) * burstRadius))));
                                    local horizontalOrigin = f32((((ctx).player_).x / f32(6)));
                                    if ((((burstX >= f32((horizontalOrigin + f32(20)))) and (burstX <= f32((horizontalOrigin + f32(580))))) and (burstY >= f32(20))) and (burstY <= f32(700))) then
                                        do
                                            local headingRandom = lateBossFrameRand(((timer * 555) + state));
                                            local burstHeading = normalizeAngle16((((enemy).sourceAngle16 + 26102) + math.fmod(headingRandom, 7333)));
                                            local speedRandom = lateBossFrameRand(((timer * 5555) + state));
                                            local burstSpeed = (1 + (math.fmod(speedRandom, 151) / 100));
                                            ctx:spawnProjectileNode(2, 18, burstX, burstY, burstHeading, f32(0), burstSpeed, 1, 0);
                                            fired = true
                                        end
                                    end;
                                    if (timer < 140) then
                                        do
                                            local projectEllipse = function(orbitAngle, verticalRadius, horizontalRadius)
                                                orbitAngle = (orbitAngle % 65536);
                                                local tilt = fixedAngleRadians((enemy).sourceAngle16);
                                                local orbit = fixedAngleRadians(orbitAngle);
                                                local tiltCos = math.cos(tilt);
                                                local tiltSin = math.sin(tilt);
                                                local orbitCos = math.cos(orbit);
                                                local orbitSin = math.sin(orbit);
                                                do return {f32(((enemy).x + f32((((tiltCos * orbitCos) * horizontalRadius) - ((tiltSin * orbitSin) * verticalRadius))))), f32(((enemy).y + f32((((tiltCos * orbitSin) * verticalRadius) + ((tiltSin * orbitCos) * horizontalRadius)))))} end
                                            end;
                                            local insideFireArea = function(x, y)
                                                x = f32(x);
                                                y = f32(y);
                                                local horizontalOrigin = f32((((ctx).player_).x / f32(6)));
                                                do return ((((x >= f32((horizontalOrigin + f32(20)))) and (x <= f32((horizontalOrigin + f32(580))))) and (y >= f32(20))) and (y <= f32(700))) end
                                            end;
                                            local orbitAngle = normalizeAngle16((timer * 2500));
                                            local first = (projectEllipse)(orbitAngle, 132, 110);
                                            local secondOrbit = normalizeAngle16((orbitAngle + 32768));
                                            local second = (projectEllipse)(secondOrbit, 100, 80);
                                            local firstHeading = normalizeAngle16(((enemy).sourceAngle16 + orbitAngle));
                                            local secondHeading = normalizeAngle16((firstHeading + 32768));
                                            if (insideFireArea)((first)[1], (first)[2]) then
                                                do
                                                    ctx:spawnProjectileNode(13, 3, (first)[1], (first)[2], firstHeading, f32(0), 5.2999999999999998, 1, 0);
                                                    fired = true
                                                end
                                            end;
                                            if (insideFireArea)((second)[1], (second)[2]) then
                                                do
                                                    ctx:spawnProjectileNode(13, 3, (second)[1], (second)[2], secondHeading, f32(0), 5.2999999999999998, 1, 0);
                                                    fired = true
                                                end
                                            end
                                        end
                                    end
                                end
                            end;
                            (advance)(140);
                            do break end
                        end
                    end;
                    if (state == 99) then
                        do
                            (enemy).targetable = false;
                            if (timer < 180) then
                                do
                                    (enemy).drawBodyThisFrame = false
                                end
                            end;
                            if ((timer < 280) and (bit.band(timer, 1) == 0)) then
                                do
                                    local random = lateBossFrameRand(((enemy).entityId + (timer * 88888)));
                                    ctx:spawnStage10FinalBossEmitter(enemy, 298, (enemy).x, (enemy).y, normalizeAngle16(u32(bit.band(random, 65535))), 12, trunc(timer / 2))
                                end
                            end;
                            if (timer >= 300) then
                                do
                                    (enemy).active = false;
                                    if ((parent).liveChildCount > 0) then
                                        do
                                            (parent).liveChildCount = (parent).liveChildCount - 1
                                        end
                                    end
                                end
                            end
                        end
                    end;
                    do break end
                end;
            end
            if __switch180 <= 10 then
                do
                    (enemy).x = f32(f32(((enemy).x + f32((f32(((parent).x - (enemy).x)) * f32(0.200000003))))));
                    (enemy).y = f32(f32(((enemy).y + f32((f32((f32(((parent).y + f32(60))) - (enemy).y)) * f32(0.200000003))))));
                    if (((enemy).helperState == 1) and ((enemy).hp < trunc(((enemy).maxHp * 3) / 4))) then
                        do
                            (enemy).helperState = 2;
                            (enemy).helperTimer = 0;
                            do return end
                        end
                    end;
                    if (((enemy).helperState == 2) and ((enemy).hp < trunc((enemy).maxHp / 2))) then
                        do
                            (enemy).helperState = 3;
                            (enemy).helperTimer = 0;
                            do return end
                        end
                    end;
                    if (((enemy).helperState >= 1) and ((enemy).helperState <= 3)) then
                        do
                            if ((timer >= 10) and (math.fmod((timer - 10), 360) == 0)) then
                                do
                                    local type = (302 + (((enemy).helperState - 1) * 2));
                                    ctx:spawnStage10FinalBossEmitter(enemy, type, f32(0), f32((-f32(123))), normalizeAngle16(lateBossFrameRand((timer + (enemy).entityId))), 0, trunc(timer / 360))
                                end
                            end;
                            if ((timer >= 190) and (math.fmod((timer - 190), 360) == 0)) then
                                do
                                    local type = (303 + (((enemy).helperState - 1) * 2));
                                    ctx:spawnStage10FinalBossEmitter(enemy, type, f32(0), f32((-f32(123))), normalizeAngle16(lateBossFrameRand((timer + (enemy).entityId))), 0, trunc(timer / 360))
                                end
                            end
                        end
                    end;
                    do break end
                end;
            end
            if __switch180 <= 11 then
                do break end
            end
        until true
    end;
    if fired then
        do
            ctx:playPlayerSound((function() if (((enemy).spawnType == 277) or ((enemy).spawnType == 285)) then return (ctx).bullet2SoundHandle_ else return (ctx).bullet1SoundHandle_ end end)(), 19)
        end
    end
end

M.updateLateStageBoss = function(ctx, enemy)
    (enemy).vx = f32(f32(0));
    (enemy).vy = f32(f32(0));
    (enemy).drawBodyThisFrame = true;
    (enemy).drawMarkerThisFrame = false;
    (enemy).drawHp = (enemy).hp;
    if ((enemy).spawnType == 323) then
        do
            ctx:updateStage06Midboss(enemy);
            do return end
        end
    end;
    if ctx:isStage06MidbossNodeType((enemy).spawnType) then
        do
            ctx:updateStage06MidbossNode(enemy);
            do return end
        end
    end;
    if ctx:isStage09MidbossType((enemy).spawnType) then
        do
            ctx:updateStage09Midboss(enemy);
            do return end
        end
    end;
    if ctx:isStage09MidbossNodeType((enemy).spawnType) then
        do
            ctx:updateStage09MidbossNode(enemy);
            do return end
        end
    end;
    if ctx:isStage07MidbossNodeType((enemy).spawnType) then
        do
            ctx:updateStage07MidbossNode(enemy);
            do return end
        end
    end;
    if isStage06BossNodeType((enemy).spawnType) then
        do
            ctx:updateStage06BossNode(enemy);
            do return end
        end
    end;
    if ctx:isStage07BossNodeType((enemy).spawnType) then
        do
            ctx:updateStage07BossNode(enemy);
            do return end
        end
    end;
    if (((enemy).parentSpawnType == 319) and ctx:isStage08BossNodeType((enemy).spawnType)) then
        do
            ctx:updateStage08BossNode(enemy);
            do return end
        end
    end;
    if (((enemy).parentSpawnType == 320) and ctx:isStage09BossNodeType((enemy).spawnType)) then
        do
            ctx:updateStage09BossNode(enemy);
            do return end
        end
    end;
    if ctx:isStage10FinalBossNodeType((enemy).spawnType) then
        do
            ctx:updateStage10FinalBossNode(enemy);
            do return end
        end
    end;
    (ctx).lateStageBossCountdownDraw_ = (ctx).lateStageBossCountdown_;
    if ctx:isStage07MidbossType((enemy).spawnType) then
        do
            ctx:updateStage07Midboss(enemy);
            do return end
        end
    end;
    if ((enemy).spawnType == 317) then
        do
            ctx:updateStage06Boss(enemy);
            do return end
        end
    end;
    if ((enemy).spawnType == 318) then
        do
            ctx:updateStage07Boss(enemy);
            do return end
        end
    end;
    if ((enemy).spawnType == 319) then
        do
            ctx:updateStage08Boss(enemy);
            do return end
        end
    end;
    if ((enemy).spawnType == 320) then
        do
            ctx:updateStage09Boss(enemy);
            do return end
        end
    end;
    if ((enemy).spawnType == 316) then
        do
            ctx:updateStage05Boss(enemy);
            do return end
        end
    end;
    local playBossTrack = function(oldIndex, newIndex)
        if ((oldIndex >= 0) and (oldIndex < (#(ctx).bossBgmHandles_))) then
            do
                local oldHandle = ((ctx).bossBgmHandles_)[oldIndex + 1];
                if (oldHandle ~= (-1)) then
                    ctx:audio("StopSoundMem", oldHandle)
                end
            end
        end;
        if ((newIndex >= 0) and (newIndex < (#(ctx).bossBgmHandles_))) then
            do
                (ctx).activeBossBgmIndex_ = newIndex;
                local handle = ((ctx).bossBgmHandles_)[newIndex + 1];
                if (handle ~= (-1)) then
                    do
                        ctx:audio("ChangeVolumeSoundMem", trunc((((ctx).config_).bgmVolume * 25.5)), handle);
                        ctx:audio("PlaySoundMem", handle, DX_PLAYTYPE_LOOP, TRUE)
                    end
                end
            end
        end
    end;
    local emitStage10ScenePattern = function()
        local timer = (enemy).helperTimer;
        local aimFrom = function(x, y)
            x = f32(x);
            y = f32(y);
            do return radiansToAngle16(math.atan2(f32((((ctx).player_).y - y)), f32((((ctx).player_).x - x)))) end
        end;
        if (((enemy).helperState == 2) and (timer >= 40)) then
            do
                local cycle = math.fmod((timer - 40), 860);
                local rightX = f32(((enemy).x + f32(68)));
                local leftX = f32(((enemy).x - f32(68)));
                local sourceY = f32(((enemy).y + f32(95)));
                local rightAim = (aimFrom)(rightX, sourceY);
                local leftAim = (aimFrom)(leftX, sourceY);
                if (cycle < 400) then
                    do
                        if (math.fmod(cycle, 100) == 0) then
                            do
                                (enemy).secondaryAngle16 = (rightAim % 65536);
                                (enemy).targetAngle16 = (leftAim % 65536);
                                do
                                    local layer = 0
                                    while (layer < 4) do
                                        do
                                            local speed = (4.4000000000000004 - (layer * 1.3));
                                            do
                                                local i = 0
                                                while (i < 8) do
                                                    do
                                                        ctx:spawnProjectileNode(10, 53, rightX, sourceY, normalizeAngle16((((rightAim + (i * 5000)) - (layer * 2800)) - 21500)), f32(0), speed, 1, 0);
                                                        ctx:spawnProjectileNode(10, 54, leftX, sourceY, normalizeAngle16((((leftAim + (i * 3571)) + (layer * 2800)) - 8500)), f32(0), speed, 1, 0)
                                                    end
                                                    i = i + 1
                                                end
                                            end
                                        end
                                        layer = layer + 1
                                    end
                                end;
                                ctx:playPlayerSound((ctx).bullet2SoundHandle_, 12)
                            end
                        end;
                        if ((math.fmod(cycle, 100) < 30) and (math.fmod(cycle, 5) == 0)) then
                            do
                                ctx:spawnProjectileNode(11, 0, rightX, sourceY, (enemy).secondaryAngle16, f32(10), 8, 1, 0);
                                ctx:spawnProjectileNode(11, 0, leftX, sourceY, (enemy).targetAngle16, f32(10), 8, 1, 0);
                                (enemy).secondaryAngle16 = (approachAngle16((enemy).secondaryAngle16, rightAim, 500) % 65536);
                                (enemy).targetAngle16 = (approachAngle16((enemy).targetAngle16, leftAim, 500) % 65536);
                                ctx:playPlayerSound((ctx).bullet1SoundHandle_, 12)
                            end
                        end
                    end
                end;
                local emitAlternating = function(right, localCycle)
                    local random = lateBossFrameRand((timer + (function() if right then return 0 else return 1111 end end)()));
                    local jitter = math.fmod(random, 2001);
                    local base = (aimFrom)((enemy).x, (enemy).y);
                    do
                        local i = 0
                        while (i < 15) do
                            do
                                local angle = (function() if right then return (((base + 6384) + jitter) + (i * 1285)) else return (((base - 24384) - jitter) + (i * 1285)) end end)();
                                ctx:spawnProjectileNode((function() if right then return 3 else return 2 end end)(), 8, (function() if right then return rightX else return leftX end end)(), sourceY, normalizeAngle16(angle), f32(10), 7.2000000000000002, 1, 0)
                            end
                            i = i + 1
                        end
                    end;
                    ctx:playPlayerSound((ctx).bullet2SoundHandle_, 12)
                end;
                if ((cycle >= 400) and (cycle < 800)) then
                    do
                        local v_local = math.fmod((cycle - 400), 200);
                        if ((v_local < 60) and (math.fmod(v_local, 12) == 0)) then
                            do
                                (emitAlternating)(true, v_local)
                            end
                        end
                    end
                end;
                if ((cycle >= 500) and (cycle < 800)) then
                    do
                        local v_local = math.fmod((cycle - 500), 200);
                        if ((v_local < 60) and (math.fmod(v_local, 12) == 0)) then
                            do
                                (emitAlternating)(false, v_local)
                            end
                        end
                    end
                end;
                do return end
            end
        end;
        if (((enemy).helperState == 4) and (timer > 30)) then
            do
                local rightX = f32(((enemy).x + f32(68)));
                local leftX = f32(((enemy).x - f32(68)));
                local burstY = f32(((enemy).y + f32(155)));
                local streamY = f32(((enemy).y + f32(95)));
                if (timer >= 60) then
                    do
                        local burst = math.fmod((timer - 60), 150);
                        if (burst == 0) then
                            do
                                (enemy).secondaryAngle16 = ((aimFrom)((enemy).x, burstY) % 65536)
                            end
                        end;
                        if ((burst < 40) and (math.fmod(burst, 13) == 0)) then
                            do
                                do
                                    local i = 0
                                    while (i < 2) do
                                        do
                                            ctx:spawnProjectileNode(13, 0, (enemy).x, burstY, normalizeAngle16((((enemy).secondaryAngle16 + (i * 2000)) - 1000)), f32(10), 9, 1, 0)
                                        end
                                        i = i + 1
                                    end
                                end;
                                do
                                    local i = 0
                                    while (i < 3) do
                                        do
                                            ctx:spawnProjectileNode(13, 0, (enemy).x, burstY, normalizeAngle16((((enemy).secondaryAngle16 + (i * 2000)) - 2000)), f32(10), 8, 1, 0)
                                        end
                                        i = i + 1
                                    end
                                end;
                                (enemy).secondaryAngle16 = (approachAngle16((enemy).secondaryAngle16, (aimFrom)((enemy).x, burstY), 1200) % 65536);
                                ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                            end
                        end
                    end
                end;
                if (timer >= 130) then
                    do
                        local v_local = math.fmod((timer - 130), 540);
                        if ((v_local < 250) and (math.fmod(v_local, 6) == 0)) then
                            do
                                do
                                    local i = 0
                                    while (i < 2) do
                                        do
                                            ctx:spawnProjectileNode(2, 55, leftX, streamY, normalizeAngle16(((timer * 356) - (i * 32768))), f32(10), 5, 1, 0)
                                        end
                                        i = i + 1
                                    end
                                end;
                                ctx:playPlayerSound((ctx).bullet2SoundHandle_, 12)
                            end
                        end
                    end
                end;
                if (timer >= 400) then
                    do
                        local v_local = math.fmod((timer - 400), 540);
                        if ((v_local < 250) and (math.fmod(v_local, 6) == 0)) then
                            do
                                do
                                    local i = 0
                                    while (i < 2) do
                                        do
                                            ctx:spawnProjectileNode(2, 55, rightX, streamY, normalizeAngle16((((-timer) * 356) - (i * 32768))), f32(10), 5, 1, 0)
                                        end
                                        i = i + 1
                                    end
                                end;
                                ctx:playPlayerSound((ctx).bullet2SoundHandle_, 12)
                            end
                        end
                    end
                end;
                do return end
            end
        end;
        if ((((enemy).helperState == 6) and (timer > 0)) and (math.fmod((timer - 1), 5) == 0)) then
            do
                local random = lateBossFrameRand((timer + ((ctx).frame_ * 1111)));
                local random2 = lateBossFrameRand(((timer + ((ctx).frame_ * 1111)) + 1));
                local randomAngle = normalizeAngle16(u32(bit.band(random, 65535)));
                local randomAngle2 = normalizeAngle16(u32(bit.band(random2, 65535)));
                local firstX = f32(((enemy).x + f32((math.sin(fixedAngleRadians(randomAngle)) * 36))));
                local secondX = f32(((enemy).x + f32((math.sin(fixedAngleRadians(randomAngle2)) * 36))));
                local sourceY = f32(((enemy).y + f32(140)));
                local firstAngle = normalizeAngle16((trunc((math.sin(fixedAngleRadians(normalizeAngle16(u32((random + u32(4951)))))) * 14000)) - 16384));
                local secondAngle = normalizeAngle16((trunc((math.sin(fixedAngleRadians(normalizeAngle16(u32((random2 + u32(9320)))))) * 14000)) - 16384));
                do

                    for _, speed in ipairs({7, 11}) do
                        do
                            ctx:spawnProjectileNode(13, 11, firstX, sourceY, firstAngle, f32(10), speed, 1, 0);
                            ctx:spawnProjectileNode(13, 11, secondX, sourceY, secondAngle, f32(10), speed, 1, 0)
                        end
                    end
                end;
                ctx:playPlayerSound((ctx).bullet2SoundHandle_, 12)
            end
        end
    end;
    if ((enemy).spawnType == 332) then
        do
            ctx:ensureStage10SceneRootNode(enemy);
            if (((enemy).helperState == 0) and (((ctx).config_).rawStartFrame >= 12000)) then
                do
                    (enemy).helperState = 7;
                    (enemy).helperTimer = 240;
                    (enemy).targetable = false;
                    (ctx).lateStageBossBreaksRemaining_ = 0;
                    (ctx).lateStageBossPhaseMode_ = (-1);
                    (ctx).stage10GateFlag_ = true
                end
            end;
            local beginSceneBossBreak = function()
                if (((ctx).lateStageBossPhaseMode_ ~= 1) or (((enemy).hp > 0) and ((ctx).lateStageBossCountdown_ > 0))) then
                    do
                        do return false end
                    end
                end;
                (enemy).targetable = false;
                (enemy).targetableTimer = 0;
                (enemy).radius = 250;
                local countdownExpired = ((ctx).lateStageBossCountdown_ < 1);
                if countdownExpired then
                    do
                        ctx:flushEnemyProjectilesToEffects();
                        ((ctx).player_).invulnerableFrames = math.max(((ctx).player_).invulnerableFrames, 100)
                    end
                else
                    do
                        ctx:spawnPlayerSideObject(24, (enemy).x, (enemy).y, 0, (0 % 65536), 0, f32(0))
                    end
                end;
                ctx:spawnBossPhaseBreakFeedback(enemy, (ctx).lateStageBossCountdown_);
                ctx:spawnPostDeathCounterEntity(enemy, 140);
                if ((ctx).lateStageBossBreaksRemaining_ == 3) then
                    do
                        (ctx).lateStageBossBreaksRemaining_ = 2;
                        (ctx).lateStageBossPhaseIndex_ = 1;
                        (ctx).lateStageBossPhaseMode_ = 2;
                        (enemy).helperState = 3
                    end
                else
                    if ((ctx).lateStageBossBreaksRemaining_ == 2) then
                        do
                            (ctx).lateStageBossBreaksRemaining_ = 1;
                            (ctx).lateStageBossPhaseIndex_ = 2;
                            (ctx).lateStageBossPhaseMode_ = 2;
                            (enemy).helperState = 5
                        end
                    else
                        do
                            (ctx).lateStageBossBreaksRemaining_ = 0;
                            (ctx).lateStageBossPhaseMode_ = (-1);
                            (enemy).helperState = 7;
                            do

                                for _, handle in ipairs((ctx).stageBgmHandles_) do
                                    do
                                        if (handle ~= (-1)) then
                                            ctx:audio("StopSoundMem", handle)
                                        end
                                    end
                                end
                            end;
                            do

                                for _, handle in ipairs((ctx).bossBgmHandles_) do
                                    do
                                        if (handle ~= (-1)) then
                                            ctx:audio("StopSoundMem", handle)
                                        end
                                    end
                                end
                            end;
                            (ctx).activeBossBgmIndex_ = (-1)
                        end
                    end
                end;
                (enemy).helperTimer = 0;
                do return true end
            end;
            if (((enemy).helperState == 0) and ((enemy).helperTimer == 0)) then
                do
                    (enemy).markerDrawX = f32((enemy).x);
                    (enemy).markerDrawY = f32((enemy).y)
                end
            end;
            if ((enemy).helperState ~= 7) then
                do
                    local xPeriod = (function() if ((enemy).helperState == 6) then return 11 else return 100 end end)();
                    local xAmplitude = (function() if ((enemy).helperState == 6) then return 10 else return 18 end end)();
                    local desiredX = f32(((enemy).markerDrawX + f32((math.sin((((ctx).frame_ * kTau) / xPeriod)) * xAmplitude))));
                    local desiredY = f32(((enemy).markerDrawY + f32((math.sin((((ctx).frame_ * kTau) / 177)) * 10))));
                    local dx = f32((desiredX - (enemy).x));
                    local dy = f32((desiredY - (enemy).y));
                    local distance = math.sqrt(f32((f32((dx * dx)) + f32((dy * dy)))));
                    local heading = radiansToAngle16(math.atan2(dy, dx));
                    local headingRadians = fixedAngleRadians(heading);
                    (enemy).x = f32(f32(((enemy).x + f32((math.cos(headingRadians) * (distance / 5))))));
                    (enemy).y = f32(f32(((enemy).y + f32((math.sin(headingRadians) * (distance / 5))))))
                end
            end;
            if (((enemy).helperState == 0) or ((enemy).helperState == 1)) then
                do
                    local preAttackState = ((enemy).helperState == 1);
                    if preAttackState then
                        do
                            (ctx).stage10GateFlag_ = true;
                            (enemy).targetable = false
                        end
                    end;
                    local targetX = (enemy).markerDrawX;
                    local targetY = (enemy).markerDrawY;
                    if ((ctx).frame_ < 1200) then
                        do

                        end
                    else
                        if ((ctx).frame_ < 3000) then
                            do
                                local phase = ((((ctx).frame_ - 1200) * kTau) / 7200);
                                targetX = f32(f32(360));
                                targetY = f32(f32(((math.sin(phase) * 800) - 2400)))
                            end
                        else
                            if ((ctx).frame_ < 4700) then
                                do
                                    local phase = ((((ctx).frame_ - 3000) * kTau) / 6800);
                                    targetX = f32(f32(360));
                                    targetY = f32(f32(((math.sin(phase) * 850) - 1600)))
                                end
                            else
                                if ((ctx).frame_ < 6600) then
                                    do
                                        local phase = ((((ctx).frame_ - 4700) * kTau) / 7600);
                                        local wave = math.sin(phase);
                                        targetX = f32(f32(((wave * (-560)) + 360)));
                                        targetY = f32(f32(((wave * 100) - 750)))
                                    end
                                else
                                    if ((ctx).frame_ < 8500) then
                                        do
                                            local primaryPhase = ((((ctx).frame_ - 6600) * kTau) / 7600);
                                            local secondaryPhase = ((((ctx).frame_ - 6600) * kTau) / 3800);
                                            local primaryWave = math.sin(primaryPhase);
                                            targetX = f32(f32(((primaryWave * 1120) - 200)));
                                            targetY = f32(f32(((primaryWave * (50 - (math.sin(secondaryPhase) * 150))) - 650)))
                                        end
                                    else
                                        if ((ctx).frame_ < 9100) then
                                            do
                                                local phase = ((((ctx).frame_ - 8500) * kTau) / 2400);
                                                local wave = math.sin(phase);
                                                targetX = f32(f32(((wave * (-560)) + 920)));
                                                targetY = f32(f32(((wave * (-100)) - 600)))
                                            end
                                        else
                                            if ((ctx).frame_ < 11300) then
                                                do
                                                    local phase = ((((ctx).frame_ - 9100) * kTau) / 8800);
                                                    targetX = f32(f32(360));
                                                    targetY = f32(f32(((math.sin(phase) * 450) - 700)))
                                                end
                                            else
                                                if ((ctx).frame_ < 12000) then
                                                    do
                                                        local phase = ((((ctx).frame_ - 11300) * kTau) / 2800);
                                                        targetX = f32(f32(360));
                                                        targetY = f32(f32(((math.sin(phase) * 400) - 250)))
                                                    end
                                                else
                                                    do
                                                        targetX = f32(f32(360));
                                                        targetY = f32(f32(150))
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end;
                    (enemy).markerDrawX = f32(targetX);
                    (enemy).markerDrawY = f32(targetY);
                    if ((not preAttackState) and ((enemy).helperTimer == 0)) then
                        do
                            (enemy).x = f32(targetX);
                            (enemy).y = f32(targetY)
                        end
                    end;
                    if (not preAttackState) then
                        do
                            (enemy).targetable = false;
                            (ctx).stage10GateFlag_ = false
                        end
                    end;
                    if (((not preAttackState) and ((ctx).frame_ >= 11900)) and ((ctx).frame_ < 11911)) then
                        do
                            (enemy).helperState = 1;
                            (enemy).helperTimer = 0;
                            (enemy).hp = 55000;
                            (enemy).maxHp = 55000;
                            (enemy).drawHp = 55000;
                            (ctx).lateStageBossMaxHp_ = 55000;
                            (ctx).lateStageBossCountdown_ = 1500;
                            (ctx).lateStageBossCountdownDraw_ = (ctx).lateStageBossCountdown_;
                            (ctx).lateStageBossPhaseMode_ = 0;
                            (enemy).targetable = false;
                            (enemy).targetableTimer = 0;
                            (ctx).stage10GateFlag_ = true
                        end
                    else
                        if (preAttackState and ((ctx).frame_ == 12000)) then
                            do
                                (enemy).helperState = 2;
                                (enemy).helperTimer = 0;
                                (ctx).lateStageBossPhaseMode_ = 1;
                                (enemy).targetable = true;
                                (enemy).targetableTimer = 0
                            end
                        end
                    end;
                    if (preAttackState and ((ctx).lateStageBossCountdown_ > 0)) then
                        do
                            ctx:updateBossCountdownAudio((enemy).hp, (ctx).lateStageBossCountdown_);
                            (ctx).lateStageBossCountdown_ = (ctx).lateStageBossCountdown_ - 1
                        end
                    end
                end
            else
                if ((((enemy).helperState == 2) or ((enemy).helperState == 4)) or ((enemy).helperState == 6)) then
                    do
                        (ctx).stage10GateFlag_ = true;
                        (enemy).targetable = true;
                        if (beginSceneBossBreak)() then
                            do
                                do return end
                            end
                        end;
                        (emitStage10ScenePattern)();
                        if ((ctx).lateStageBossCountdown_ > 0) then
                            do
                                ctx:updateBossCountdownAudio((enemy).hp, (ctx).lateStageBossCountdown_);
                                (ctx).lateStageBossCountdown_ = (ctx).lateStageBossCountdown_ - 1
                            end
                        end
                    end
                else
                    if (((enemy).helperState == 3) or ((enemy).helperState == 5)) then
                        do
                            (enemy).targetable = false;
                            (ctx).stage10GateFlag_ = true;
                            if (((enemy).helperTimer < 90) and (math.fmod((enemy).helperTimer, 3) == 0)) then
                                do
                                    ctx:spawnStage02DeathExplosionChain(enemy)
                                end
                            end;
                            if ((enemy).helperTimer >= 120) then
                                do
                                    local secondTransition = ((enemy).helperState == 5);
                                    (enemy).helperState = (function() if secondTransition then return 6 else return 4 end end)();
                                    (enemy).helperTimer = 0;
                                    (enemy).hp = (function() if secondTransition then return 66000 else return 55000 end end)();
                                    (enemy).maxHp = (enemy).hp;
                                    (enemy).drawHp = (enemy).hp;
                                    (ctx).lateStageBossMaxHp_ = (enemy).hp;
                                    (ctx).lateStageBossCountdown_ = (function() if secondTransition then return 1800 else return 1500 end end)();
                                    (ctx).lateStageBossCountdownDraw_ = (ctx).lateStageBossCountdown_;
                                    (ctx).lateStageBossPhaseMode_ = 1;
                                    (enemy).radius = 200;
                                    (enemy).targetable = true;
                                    (enemy).targetableTimer = 0
                                end
                            end
                        end
                    else
                        if ((enemy).helperState == 7) then
                            do
                                (enemy).targetable = false;
                                (ctx).stage10GateFlag_ = true;
                                if ((enemy).helperTimer < 150) then
                                    do
                                        (enemy).y = f32(f32(((enemy).y + f32((f32((enemy).helperTimer) * f32(0.00999999977))))))
                                    end
                                end;
                                if (((enemy).helperTimer < 150) and (math.fmod((enemy).helperTimer, 3) == 0)) then
                                    do
                                        ctx:spawnStage02DeathExplosionChain(enemy)
                                    end
                                end;
                                if ((enemy).helperTimer == 150) then
                                    do
                                        ctx:playPlayerSound((ctx).blast2SoundHandle_, 25);
                                        ctx:spawnStageEffect(17, (-1), 0, 40, (enemy).x, (enemy).y, (0 % 65536), 0, 1, 1, 0, 255, 255, 255, 255, 0)
                                    end
                                end;
                                if (((enemy).helperTimer >= 240) and (not (ctx).stage10FinalBossSpawned_)) then
                                    do
                                        if ((ctx).activeBossBgmIndex_ ~= 4) then
                                            do
                                                local stageHandle = ((ctx).stageBgmHandles_)[9 + 1];
                                                if (stageHandle ~= (-1)) then
                                                    do
                                                        ctx:audio("StopSoundMem", stageHandle)
                                                    end
                                                end;
                                                (playBossTrack)((-1), 4)
                                            end
                                        end;
                                        local before = (#(ctx).enemies_);
                                        ctx:spawnEnemy({frame = (ctx).frame_, spawnType = 321, hitPoints = 100000, x = 360, y = 320, sourceNote = "S10 FUN_1400ef010 state-7 timer 240 final root 0x141"});
                                        if ((#(ctx).enemies_) > before) then
                                            do
                                                (ctx).stage10FinalBossSpawned_ = true;
                                                (enemy).active = false
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end;
            do return end
        end
    end;
    if ((enemy).spawnType == 321) then
        do
            local kPhaseHp = {75000, 70000, 65000, 50000, 75000, 50000, 60000, 100000, 45000, 80000, 65000, 75000, 85000, 128000, 32000, 270000};
            local kPhaseCountdown = {2400, 2400, 2100, 2400, 2400, 2400, 2100, 3300, 2100, 2400, 2400, 2400, 2400, 3300, 5400, 6000};
            local kBreakModeByRemaining = {(-1), (-1), 3, 3, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3};
            local kTransitionCompleteMode = {0, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 2, 1};
            local aimFrom = function(x, y)
                x = f32(x);
                y = f32(y);
                do return radiansToAngle16(math.atan2(f32((((ctx).player_).y - y)), f32((((ctx).player_).x - x)))) end
            end;
            local moveTowardScriptTarget = function(speed, refreshTarget)
                if (refreshTarget and (math.fmod((ctx).frame_, 50) == 0)) then
                    do
                        (ctx).lateStageBossTargetX_ = f32(f32((f32(210) + f32(math.fmod(lateBossFrameRand((ctx).frame_), 301)))));
                        (ctx).lateStageBossTargetY_ = f32(f32((f32(180) + f32(math.fmod(lateBossFrameRand((((ctx).selectedStage_ * 1111) + (ctx).frame_)), 101)))))
                    end
                end;
                local target = radiansToAngle16(math.atan2(f32(((ctx).lateStageBossTargetY_ - (enemy).y)), f32(((ctx).lateStageBossTargetX_ - (enemy).x))));
                (enemy).sourceAngle16 = (approachAngle16((enemy).sourceAngle16, target, 512) % 65536);
                local radians = fixedAngleRadians((enemy).sourceAngle16);
                (enemy).x = f32(f32(((enemy).x + f32((math.cos(radians) * speed)))));
                (enemy).y = f32(f32(((enemy).y + f32((math.sin(radians) * speed)))))
            end;
            local emitFinalRootPattern = function()
                local state = (enemy).helperState;
                local timer = (enemy).helperTimer;
                local fired = false;
                local ring = function(visual, projectileId, angle, speed, count, spread)
                    angle = (angle % 65536);
                    ctx:spawnProjectileSpread(visual, projectileId, (enemy).x, (enemy).y, angle, f32(0), speed, 1, count, spread, 0);
                    fired = true
                end;
                if ((state == 1) and (timer >= 30)) then
                    do
                        local fastHalf = (timer >= 380);
                        local halfPeriod = (function() if fastHalf then return 90 else return 120 end end)();
                        local start = (function() if fastHalf then return 310 else return 30 end end)();
                        local sweep = math.fmod((timer - start), halfPeriod);
                        local speed = (4 + ((timer - 30) * 0.0030000000000000001));
                        local first = math.fmod((timer - start), (halfPeriod * 2));
                        if (((first >= 0) and (first < 72)) and (math.fmod(first, 5) == 0)) then
                            do
                                local sourceX = f32((f32(720) - f32((f32(sweep) * f32(10)))));
                                fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 261, sourceX, f32((-f32(10))), (aimFrom)(sourceX, f32((-f32(10)))), speed, trunc(first / 5)) and 1 or 0)) ~= 0)
                            end
                        end;
                        local secondStart = (start + halfPeriod);
                        local second = (function() if (timer >= secondStart) then return math.fmod((timer - secondStart), (halfPeriod * 2)) else return (-1) end end)();
                        if (((second >= 0) and (second < 72)) and (math.fmod(second, 5) == 0)) then
                            do
                                local sourceX = f32((f32(25) + f32((f32(sweep) * f32(10)))));
                                fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 261, sourceX, f32((-f32(10))), (aimFrom)(sourceX, f32((-f32(10)))), speed, trunc(second / 5)) and 1 or 0)) ~= 0)
                            end
                        end
                    end
                else
                    if ((state == 21) and (timer >= 30)) then
                        do
                            local v_local = (timer - 30);
                            local speed = (6 + (v_local * 0.0040000000000000001));
                            local first = math.fmod(v_local, 300);
                            if ((first < 90) and (math.fmod(first, 14) == 0)) then
                                do
                                    fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 262, (enemy).x, (enemy).y, normalizeAngle16(7000), speed, trunc(first / 14)) and 1 or 0)) ~= 0)
                                end
                            end;
                            local second = (function() if (timer >= 180) then return math.fmod((timer - 180), 300) else return (-1) end end)();
                            if (((second >= 0) and (second < 90)) and (math.fmod(second, 14) == 0)) then
                                do
                                    fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 262, (enemy).x, (enemy).y, normalizeAngle16(25768), speed, trunc(second / 14)) and 1 or 0)) ~= 0)
                                end
                            end;
                            if ((timer >= 210) and (math.fmod((timer - 210), 100) == 0)) then
                                do
                                    local aimed = (aimFrom)((enemy).x, (enemy).y);
                                    local burstSpeed = (5 + ((timer - 210) * 0.002));
                                    (ring)(3, 0, aimed, burstSpeed, 7, 12288);
                                    (ring)(3, 0, aimed, (burstSpeed - 1.5), 20, 65536)
                                end
                            end
                        end
                    else
                        if ((state == 41) and (timer >= 30)) then
                            do
                                local v_local = (timer - 30);
                                local sweep = math.fmod(v_local, 100);
                                local nodeSpeed = (3 + (v_local * 0.001));
                                if ((math.fmod(v_local, 300) < 60) and (math.fmod(math.fmod(v_local, 300), 5) == 0)) then
                                    do
                                        local sourceX = f32((f32(720) - f32((f32(sweep) * f32(10)))));
                                        fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 263, sourceX, f32((-f32(10))), normalizeAngle16(((sweep * 150) + 500)), nodeSpeed, trunc(v_local / 5)) and 1 or 0)) ~= 0)
                                    end
                                end;
                                local second = (function() if (timer >= 130) then return math.fmod((timer - 130), 300) else return (-1) end end)();
                                if (((second >= 0) and (second < 60)) and (math.fmod(second, 5) == 0)) then
                                    do
                                        local sourceX = f32((f32(85) + f32((f32(sweep) * f32(10)))));
                                        fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 263, sourceX, f32((-f32(10))), normalizeAngle16((32268 - (sweep * 150))), nodeSpeed, trunc(second / 5)) and 1 or 0)) ~= 0)
                                    end
                                end;
                                local third = (function() if (timer >= 230) then return math.fmod((timer - 230), 300) else return (-1) end end)();
                                if (((third >= 0) and (third < 60)) and (math.fmod(third, 7) == 0)) then
                                    do
                                        local aimed = (aimFrom)((enemy).x, (enemy).y);
                                        fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 263, (enemy).x, (enemy).y, normalizeAngle16((aimed - 6144)), nodeSpeed, (trunc(third / 7) * 2)) and 1 or 0)) ~= 0);
                                        fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 263, (enemy).x, (enemy).y, normalizeAngle16((aimed + 6144)), nodeSpeed, ((trunc(third / 7) * 2) + 1)) and 1 or 0)) ~= 0)
                                    end
                                end;
                                if (timer >= 280) then
                                    do
                                        local burst = math.fmod((timer - 280), 100);
                                        if ((burst < 32) and (bit.band(burst, 3) == 0)) then
                                            do
                                                (ring)(3, 0, (aimFrom)((enemy).x, (enemy).y), (6.4000000000000004 + (v_local * 0.0030000000000000001)), 3, 6144)
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            if ((state == 61) and (timer >= 30)) then
                                do
                                    local fastHalf = (timer >= 430);
                                    local halfPeriod = (function() if fastHalf then return 75 else return 100 end end)();
                                    local start = (function() if fastHalf then return 430 else return 30 end end)();
                                    local v_local = (timer - start);
                                    local speed = (5 + ((timer - 30) * 0.002));
                                    if ((v_local >= 0) and (math.fmod(v_local, (halfPeriod * 2)) == 0)) then
                                        do
                                            local random = lateBossFrameRand(timer);
                                            local base = normalizeAngle16(u32(bit.band(random, 65535)));
                                            do
                                                local i = 0
                                                while (i < 15) do
                                                    do
                                                        fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 268, (enemy).x, (enemy).y, normalizeAngle16((base + (i * 4369))), speed, i) and 1 or 0)) ~= 0)
                                                    end
                                                    i = i + 1
                                                end
                                            end
                                        end
                                    end;
                                    if ((v_local >= halfPeriod) and (math.fmod((v_local - halfPeriod), (halfPeriod * 2)) == 0)) then
                                        do
                                            local random = lateBossFrameRand((timer + 1));
                                            local base = normalizeAngle16(u32(bit.band(random, 65535)));
                                            do
                                                local i = 0
                                                while (i < 15) do
                                                    do
                                                        fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 269, (enemy).x, (enemy).y, normalizeAngle16((base + (i * 4369))), speed, i) and 1 or 0)) ~= 0)
                                                    end
                                                    i = i + 1
                                                end
                                            end
                                        end
                                    end
                                end
                            else
                                if ((state == 81) and (timer >= 30)) then
                                    do
                                        local v_local = (timer - 30);
                                        local aimed = (aimFrom)((enemy).x, (enemy).y);
                                        if (timer == 30) then
                                            (enemy).secondaryAngle16 = (aimed % 65536)
                                        end;
                                        if (bit.band(v_local, 3) == 0) then
                                            do
                                                (enemy).secondaryAngle16 = (approachAngle16((enemy).secondaryAngle16, aimed, 120) % 65536);
                                                fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 270, (enemy).x, (enemy).y, (enemy).secondaryAngle16, (2 + (v_local * 0.0015)), trunc(v_local / 4)) and 1 or 0)) ~= 0)
                                            end
                                        end;
                                        if ((timer >= 150) and (math.fmod((timer - 150), 100) == 0)) then
                                            do
                                                local speed = (6.5999999999999996 + (v_local * 0.0015));
                                                (ring)(3, 0, aimed, speed, 15, 65536);
                                                (ring)(3, 0, aimed, (speed - 1.6000000000000001), 15, 65536)
                                            end
                                        end
                                    end
                                else
                                    if ((state == 101) and (timer >= 30)) then
                                        do
                                            local v_local = (timer - 30);
                                            local first = math.fmod(v_local, 744);
                                            if (math.fmod(first, 372) == 0) then
                                                do
                                                    local reverse = (first > 371);
                                                    fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, (function() if reverse then return 265 else return 264 end end)(), (enemy).x, (enemy).y, normalizeAngle16((((function() if reverse then return (-1) else return 1 end end)() * timer) * 1024)), 16, trunc(first / 372)) and 1 or 0)) ~= 0)
                                                end
                                            end;
                                            if ((timer >= 216) and (math.fmod((timer - 216), 372) == 0)) then
                                                do
                                                    local reverse = (bit.band(trunc((timer - 216) / 372), 1) ~= 0);
                                                    fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, (function() if reverse then return 265 else return 264 end end)(), (enemy).x, (enemy).y, normalizeAngle16((timer * (-1024))), 16, trunc((timer - 216) / 372)) and 1 or 0)) ~= 0)
                                                end
                                            end;
                                            if ((timer >= 45) and (math.fmod((timer - 45), 93) == 0)) then
                                                do
                                                    (ring)(2, 0, (aimFrom)((enemy).x, (enemy).y), 3.2000000000000002, 21, 65536)
                                                end
                                            end
                                        end
                                    else
                                        if ((state == 121) and (timer >= 30)) then
                                            do
                                                local scheduled = 30;
                                                local interval = 140;
                                                do
                                                    local index = 0
                                                    while (index < 30) do
                                                        do
                                                            if (timer == scheduled) then
                                                                do
                                                                    local speed = math.min(40, (29 + ((timer - 30) * 0.025999999999999999)));
                                                                    local type = (function() if (bit.band(index, 1) == 0) then return 271 else return 272 end end)();
                                                                    local targetX = (function() if (type == 271) then return f32(10) else return f32(590) end end)();
                                                                    fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, type, targetX, (enemy).y, normalizeAngle16(49152), speed, index) and 1 or 0)) ~= 0);
                                                                    do break end
                                                                end
                                                            end;
                                                            scheduled = (scheduled + math.max(interval, 80));
                                                            interval = (interval - 10)
                                                        end
                                                        index = index + 1
                                                    end
                                                end
                                            end
                                        else
                                            if ((state == 131) and (timer >= 290)) then
                                                do
                                                    local v_local = math.fmod((timer - 290), 1800);
                                                    local leftX = f32(200);
                                                    local rightX = f32(520);
                                                    local leftAim = (aimFrom)(leftX, f32(240));
                                                    local rightAim = (aimFrom)(rightX, f32(240));
                                                    if ((v_local < 360) and (math.fmod(v_local, 28) == 0)) then
                                                        do
                                                            ctx:spawnProjectileSpread(11, 0, leftX, f32(240), leftAim, f32(0), 6, 1, 13, 24000, 0);
                                                            ctx:spawnProjectileSpread(10, 0, rightX, f32(240), rightAim, f32(0), 6, 1, 13, 24000, 0);
                                                            fired = true
                                                        end
                                                    end;
                                                    if (((v_local >= 480) and (v_local < 870)) and (math.fmod((v_local - 480), 36) == 0)) then
                                                        do
                                                            ctx:spawnProjectileSpread(5, 0, leftX, f32(240), leftAim, f32(0), 5, 1, 11, 12288, 0);
                                                            ctx:spawnProjectileSpread(8, 0, rightX, f32(240), rightAim, f32(0), 5, 1, 7, 24576, 0);
                                                            fired = true
                                                        end
                                                    end
                                                end
                                            else
                                                if (((state == 141) and (timer < 210)) and (bit.band(timer, 1) == 0)) then
                                                    do
                                                        local random = lateBossFrameRand(timer);
                                                        fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 296, (enemy).x, (enemy).y, normalizeAngle16(u32(bit.band(random, 65535))), 0, trunc(timer / 2)) and 1 or 0)) ~= 0)
                                                    end
                                                else
                                                    if ((state == 153) and (timer >= 30)) then
                                                        do
                                                            if (math.fmod((timer - 30), 360) == 0) then
                                                                do
                                                                    local random = lateBossFrameRand(timer);
                                                                    fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 308, f32(0), f32(0), normalizeAngle16(u32(bit.band(random, 65535))), 0, trunc((timer - 30) / 360)) and 1 or 0)) ~= 0)
                                                                end
                                                            end;
                                                            if ((timer >= 210) and (math.fmod((timer - 210), 360) == 0)) then
                                                                do
                                                                    local random = lateBossFrameRand((timer + 1));
                                                                    fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 309, f32(0), f32(0), normalizeAngle16(u32(bit.band(random, 65535))), 0, trunc((timer - 210) / 360)) and 1 or 0)) ~= 0)
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
                        end
                    end
                end;
                if fired then
                    do
                        ctx:playPlayerSound((ctx).bullet2SoundHandle_, 12)
                    end
                end
            end;
            if ((enemy).helperState == 0) then
                do
                    (moveTowardScriptTarget)(0.40000000000000002, true);
                    if ((enemy).helperTimer >= 260) then
                        do
                            (enemy).helperState = 1;
                            (enemy).helperTimer = 0;
                            (enemy).hp = (kPhaseHp)[0 + 1];
                            (enemy).maxHp = (enemy).hp;
                            (enemy).drawHp = (enemy).hp;
                            (enemy).targetable = true;
                            (enemy).targetableTimer = 0;
                            (ctx).lateStageBossBreaksRemaining_ = 16;
                            (ctx).lateStageBossPhaseIndex_ = 0;
                            (ctx).lateStageBossMaxHp_ = (enemy).hp;
                            (ctx).lateStageBossCountdown_ = (kPhaseCountdown)[0 + 1];
                            (ctx).lateStageBossCountdownDraw_ = (ctx).lateStageBossCountdown_;
                            (ctx).lateStageBossPhaseMode_ = 1
                        end
                    end;
                    do return end
                end
            end;
            local regularCombatState = (((enemy).helperState == 1) or ((((enemy).helperState >= 11) and ((enemy).helperState <= 151)) and (math.fmod((enemy).helperState, 10) == 1)));
            local extendedCombatState = (((enemy).helperState == 142) or ((enemy).helperState == 153));
            if (regularCombatState or extendedCombatState) then
                do
                    local state = (enemy).helperState;
                    local sharedNodePhase = (((state >= 11) and (state <= 111)) and (math.fmod(state, 20) == 11));
                    if (sharedNodePhase and ((enemy).helperTimer == 220)) then
                        do
                            (ctx).lateStageBossPhaseMode_ = 1
                        end
                    end;
                    if (((state == 131) or (state == 151)) and ((enemy).helperTimer == 280)) then
                        do
                            (ctx).lateStageBossPhaseMode_ = 1
                        end
                    end;
                    if ((state == 141) and ((enemy).helperTimer == 310)) then
                        do
                            (ctx).lateStageBossPhaseMode_ = 1
                        end
                    end;
                    if (((ctx).lateStageBossPhaseMode_ == 1) and (((enemy).hp < 1) or ((ctx).lateStageBossCountdown_ < 1))) then
                        do
                            (enemy).targetable = false;
                            (enemy).targetableTimer = 0;
                            local countdownExpired = ((ctx).lateStageBossCountdown_ < 1);
                            if countdownExpired then
                                do
                                    ctx:flushEnemyProjectilesToEffects();
                                    ((ctx).player_).invulnerableFrames = math.max(((ctx).player_).invulnerableFrames, 100)
                                end
                            else
                                do
                                    ctx:spawnPlayerSideObject(24, (enemy).x, (enemy).y, 0, (0 % 65536), 0, f32(0))
                                end
                            end;
                            ctx:spawnBossPhaseBreakFeedback(enemy, (ctx).lateStageBossCountdown_);
                            ctx:spawnPostDeathCounterEntity(enemy, 140);
                            if ((ctx).lateStageBossBreaksRemaining_ > 1) then
                                do
                                    local remaining = cpp.clamp((ctx).lateStageBossBreaksRemaining_, 2, 16);
                                    (enemy).helperState = ((17 - remaining) * 10);
                                    (ctx).lateStageBossPhaseMode_ = (kBreakModeByRemaining)[remaining + 1];
                                    (ctx).lateStageBossBreaksRemaining_ = (ctx).lateStageBossBreaksRemaining_ - 1;
                                    (ctx).lateStageBossPhaseIndex_ = (ctx).lateStageBossPhaseIndex_ + 1
                                end
                            else
                                do
                                    (ctx).lateStageBossBreaksRemaining_ = 0;
                                    (enemy).helperState = 200;
                                    (ctx).lateStageBossPhaseMode_ = (-1);
                                    (ctx).lateStageClearStarted_ = true;
                                    (ctx).lateStageClearTimer_ = 0;
                                    ((ctx).player_).invulnerableFrames = math.max(((ctx).player_).invulnerableFrames, 360)
                                end
                            end;
                            (enemy).helperTimer = 0;
                            do return end
                        end
                    end;
                    if ((state == 151) and (((enemy).hp < trunc((ctx).lateStageBossMaxHp_ / 4)) or ((ctx).lateStageBossCountdown_ < 1500))) then
                        do
                            (enemy).helperState = 152;
                            (enemy).helperTimer = 0;
                            (enemy).targetable = false;
                            (enemy).targetableTimer = 0;
                            do return end
                        end
                    end;
                    local moveThisFrame = true;
                    local refreshTarget = true;
                    if (sharedNodePhase and ((enemy).helperTimer >= 220)) then
                        do
                            moveThisFrame = false;
                            refreshTarget = false
                        end
                    end;
                    if ((state == 131) and ((enemy).helperTimer >= 280)) then
                        do
                            moveThisFrame = false;
                            refreshTarget = false
                        end
                    end;
                    if ((state == 141) and ((enemy).helperTimer >= 270)) then
                        do
                            moveThisFrame = false;
                            refreshTarget = false
                        end
                    end;
                    if moveThisFrame then
                        do
                            (moveTowardScriptTarget)((function() if ((enemy).sourceSpeed > 0) then return (enemy).sourceSpeed else return 0.40000000000000002 end end)(), refreshTarget)
                        end
                    end;
                    (emitFinalRootPattern)();
                    if ((enemy).helperTimer == 30) then
                        do
                            local nodeType = 0;
                            do
                                local __switch257 = (enemy).helperState
                                if __switch257 == 11 then __switch257 = 1
                                elseif __switch257 == 31 then __switch257 = 2
                                elseif __switch257 == 51 then __switch257 = 3
                                elseif __switch257 == 71 then __switch257 = 4
                                elseif __switch257 == 91 then __switch257 = 5
                                elseif __switch257 == 111 then __switch257 = 6
                                elseif __switch257 == 141 then __switch257 = 7
                                elseif __switch257 == 151 then __switch257 = 8
                                else __switch257 = 9 end
                                repeat
                                    if __switch257 <= 1 then
                                        nodeType = 273;
                                        do break end;
                                    end
                                    if __switch257 <= 2 then
                                        nodeType = 274;
                                        do break end;
                                    end
                                    if __switch257 <= 3 then
                                        nodeType = 275;
                                        do break end;
                                    end
                                    if __switch257 <= 4 then
                                        nodeType = 277;
                                        do break end;
                                    end
                                    if __switch257 <= 5 then
                                        nodeType = 282;
                                        do break end;
                                    end
                                    if __switch257 <= 6 then
                                        nodeType = 285;
                                        do break end;
                                    end
                                    if __switch257 <= 7 then
                                        nodeType = 295;
                                        do break end;
                                    end
                                    if __switch257 <= 8 then
                                        nodeType = 301;
                                        do break end;
                                    end
                                    if __switch257 <= 9 then
                                        do break end
                                    end
                                until true
                            end;
                            if (nodeType ~= 0) then
                                do
                                    ctx:spawnStage10FinalBossNode(enemy, nodeType)
                                end
                            end;
                            if ((enemy).helperState == 131) then
                                do
                                    ctx:spawnStage10FinalBossNode(enemy, 293);
                                    ctx:spawnStage10FinalBossNode(enemy, 294)
                                end
                            end
                        end
                    end;
                    if ((state == 141) and ((enemy).helperTimer == 3360)) then
                        do
                            (enemy).helperState = 142;
                            (enemy).helperTimer = 0;
                            (enemy).sourceSpeed = 0.10000000000000001;
                            do return end
                        end
                    end;
                    if (((ctx).lateStageBossPhaseMode_ == 1) and ((ctx).lateStageBossCountdown_ > 0)) then
                        do
                            ctx:updateBossCountdownAudio((enemy).hp, (ctx).lateStageBossCountdown_);
                            (ctx).lateStageBossCountdown_ = (ctx).lateStageBossCountdown_ - 1
                        end
                    end;
                    do return end
                end
            end;
            if ((enemy).helperState == 152) then
                do
                    (moveTowardScriptTarget)((function() if ((enemy).sourceSpeed > 0) then return (enemy).sourceSpeed else return 0.10000000000000001 end end)(), true);
                    (enemy).targetable = false;
                    if ((enemy).helperTimer >= 150) then
                        do
                            (enemy).helperState = 153;
                            (enemy).helperTimer = 0;
                            (enemy).sourceSpeed = 0.40000000000000002;
                            (enemy).targetable = true;
                            (enemy).targetableTimer = 0
                        end
                    end;
                    if (((ctx).lateStageBossPhaseMode_ == 1) and ((ctx).lateStageBossCountdown_ > 0)) then
                        do
                            ctx:updateBossCountdownAudio((enemy).hp, (ctx).lateStageBossCountdown_);
                            (ctx).lateStageBossCountdown_ = (ctx).lateStageBossCountdown_ - 1
                        end
                    end;
                    do return end
                end
            end;
            if ((((enemy).helperState >= 10) and ((enemy).helperState <= 150)) and (math.fmod((enemy).helperState, 10) == 0)) then
                do
                    local transitionIndex = trunc((enemy).helperState / 10);
                    if (bit.band(transitionIndex, 1) ~= 0) then
                        do
                            (enemy).y = f32(f32(((enemy).y + f32(0.100000001))))
                        end
                    else
                        do
                            (moveTowardScriptTarget)((function() if ((enemy).sourceSpeed > 0) then return (enemy).sourceSpeed else return 0.40000000000000002 end end)(), true)
                        end
                    end;
                    if (((enemy).helperTimer < 90) and (math.fmod((enemy).helperTimer, 3) == 0)) then
                        do
                            ctx:spawnStage02DeathExplosionChain(enemy)
                        end
                    end;
                    local transitionLength = (function() if (bit.band(transitionIndex, 1) ~= 0) then return 180 else return 200 end end)();
                    if ((enemy).helperTimer >= transitionLength) then
                        do
                            local phase = cpp.clamp((ctx).lateStageBossPhaseIndex_, 0, 15);
                            (enemy).helperState = (enemy).helperState + 1;
                            (enemy).helperTimer = 0;
                            (enemy).hp = (kPhaseHp)[phase + 1];
                            (enemy).maxHp = (enemy).hp;
                            (enemy).drawHp = (enemy).hp;
                            (ctx).lateStageBossMaxHp_ = (enemy).hp;
                            (ctx).lateStageBossCountdown_ = (kPhaseCountdown)[phase + 1];
                            (ctx).lateStageBossCountdownDraw_ = (ctx).lateStageBossCountdown_;
                            (ctx).lateStageBossPhaseMode_ = (kTransitionCompleteMode)[transitionIndex + 1];
                            if ((enemy).helperState == 141) then
                                do
                                    (enemy).sourceSpeed = 0.10000000000000001
                                end
                            else
                                if ((enemy).helperState == 151) then
                                    do
                                        (enemy).sourceSpeed = 0.20000000000000001
                                    end
                                end
                            end;
                            (enemy).targetable = true;
                            (enemy).targetableTimer = 0
                        end
                    end;
                    do return end
                end
            end;
            if ((enemy).helperState == 200) then
                do
                    (enemy).targetable = false;
                    (enemy).y = f32(f32(((enemy).y + f32(0.200000003))));
                    if (((enemy).helperTimer < 180) and (math.fmod((enemy).helperTimer, 3) == 0)) then
                        do
                            ctx:spawnStage02DeathExplosionChain(enemy)
                        end
                    end;
                    if ((enemy).helperTimer == 240) then
                        do
                            ctx:playPlayerSound((ctx).blast2SoundHandle_, 25);
                            ctx:spawnEnemyDeathEffects(enemy, 2, true)
                        end
                    end;
                    if ((enemy).helperTimer >= 480) then
                        do
                            ctx:clearLateStageGate((ctx).selectedStage_);
                            (enemy).active = false
                        end
                    end;
                    do return end
                end
            end
        end
    end;
    (enemy).targetable = false;
    (enemy).drawBodyThisFrame = false
end

M.emitRecoveredFinalRootPattern = function(ctx, enemy)
    local aimFrom = function(x, y)
        x = f32(x);
        y = f32(y);
        do return radiansToAngle16(math.atan2(f32((((ctx).player_).y - y)), f32((((ctx).player_).x - x)))) end
    end;
    local state = (enemy).helperState;
    local timer = (enemy).helperTimer;
    local fired = false;
    local ring = function(visual, projectileId, angle, speed, count, spread)
        angle = (angle % 65536);
        ctx:spawnProjectileSpread(visual, projectileId, (enemy).x, (enemy).y, angle, f32(0), speed, 1, count, spread, 0);
        fired = true
    end;
    if ((state == 1) and (timer >= 30)) then
        do
            local fastHalf = (timer >= 380);
            local halfPeriod = (function() if fastHalf then return 90 else return 120 end end)();
            local start = (function() if fastHalf then return 310 else return 30 end end)();
            local sweep = math.fmod((timer - start), halfPeriod);
            local speed = (4 + ((timer - 30) * 0.0030000000000000001));
            local first = math.fmod((timer - start), (halfPeriod * 2));
            if (((first >= 0) and (first < 72)) and (math.fmod(first, 5) == 0)) then
                do
                    local sourceX = f32((f32(720) - f32((f32(sweep) * f32(10)))));
                    fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 261, sourceX, f32((-f32(10))), (aimFrom)(sourceX, f32((-f32(10)))), speed, trunc(first / 5)) and 1 or 0)) ~= 0)
                end
            end;
            local secondStart = (start + halfPeriod);
            local second = (function() if (timer >= secondStart) then return math.fmod((timer - secondStart), (halfPeriod * 2)) else return (-1) end end)();
            if (((second >= 0) and (second < 72)) and (math.fmod(second, 5) == 0)) then
                do
                    local sourceX = f32((f32(25) + f32((f32(sweep) * f32(10)))));
                    fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 261, sourceX, f32((-f32(10))), (aimFrom)(sourceX, f32((-f32(10)))), speed, trunc(second / 5)) and 1 or 0)) ~= 0)
                end
            end
        end
    else
        if ((state == 21) and (timer >= 30)) then
            do
                local v_local = (timer - 30);
                local speed = (6 + (v_local * 0.0040000000000000001));
                local first = math.fmod(v_local, 300);
                if ((first < 90) and (math.fmod(first, 14) == 0)) then
                    do
                        fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 262, (enemy).x, (enemy).y, normalizeAngle16(7000), speed, trunc(first / 14)) and 1 or 0)) ~= 0)
                    end
                end;
                local second = (function() if (timer >= 180) then return math.fmod((timer - 180), 300) else return (-1) end end)();
                if (((second >= 0) and (second < 90)) and (math.fmod(second, 14) == 0)) then
                    do
                        fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 262, (enemy).x, (enemy).y, normalizeAngle16(25768), speed, trunc(second / 14)) and 1 or 0)) ~= 0)
                    end
                end;
                if ((timer >= 210) and (math.fmod((timer - 210), 100) == 0)) then
                    do
                        local aimed = (aimFrom)((enemy).x, (enemy).y);
                        local burstSpeed = (5 + ((timer - 210) * 0.002));
                        (ring)(3, 0, aimed, burstSpeed, 7, 12288);
                        (ring)(3, 0, aimed, (burstSpeed - 1.5), 20, 65536)
                    end
                end
            end
        else
            if ((state == 41) and (timer >= 30)) then
                do
                    local v_local = (timer - 30);
                    local sweep = math.fmod(v_local, 100);
                    local nodeSpeed = (3 + (v_local * 0.001));
                    if ((math.fmod(v_local, 300) < 60) and (math.fmod(math.fmod(v_local, 300), 5) == 0)) then
                        do
                            local sourceX = f32((f32(720) - f32((f32(sweep) * f32(10)))));
                            fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 263, sourceX, f32((-f32(10))), normalizeAngle16(((sweep * 150) + 500)), nodeSpeed, trunc(v_local / 5)) and 1 or 0)) ~= 0)
                        end
                    end;
                    local second = (function() if (timer >= 130) then return math.fmod((timer - 130), 300) else return (-1) end end)();
                    if (((second >= 0) and (second < 60)) and (math.fmod(second, 5) == 0)) then
                        do
                            local sourceX = f32((f32(85) + f32((f32(sweep) * f32(10)))));
                            fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 263, sourceX, f32((-f32(10))), normalizeAngle16((32268 - (sweep * 150))), nodeSpeed, trunc(second / 5)) and 1 or 0)) ~= 0)
                        end
                    end;
                    local third = (function() if (timer >= 230) then return math.fmod((timer - 230), 300) else return (-1) end end)();
                    if (((third >= 0) and (third < 60)) and (math.fmod(third, 7) == 0)) then
                        do
                            local aimed = (aimFrom)((enemy).x, (enemy).y);
                            fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 263, (enemy).x, (enemy).y, normalizeAngle16((aimed - 6144)), nodeSpeed, (trunc(third / 7) * 2)) and 1 or 0)) ~= 0);
                            fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 263, (enemy).x, (enemy).y, normalizeAngle16((aimed + 6144)), nodeSpeed, ((trunc(third / 7) * 2) + 1)) and 1 or 0)) ~= 0)
                        end
                    end;
                    if (timer >= 280) then
                        do
                            local burst = math.fmod((timer - 280), 100);
                            if ((burst < 32) and (bit.band(burst, 3) == 0)) then
                                do
                                    (ring)(3, 0, (aimFrom)((enemy).x, (enemy).y), (6.4000000000000004 + (v_local * 0.0030000000000000001)), 3, 6144)
                                end
                            end
                        end
                    end
                end
            else
                if ((state == 61) and (timer >= 30)) then
                    do
                        local fastHalf = (timer >= 430);
                        local halfPeriod = (function() if fastHalf then return 75 else return 100 end end)();
                        local start = (function() if fastHalf then return 430 else return 30 end end)();
                        local v_local = (timer - start);
                        local speed = (5 + ((timer - 30) * 0.002));
                        if ((v_local >= 0) and (math.fmod(v_local, (halfPeriod * 2)) == 0)) then
                            do
                                local random = lateBossFrameRand(timer);
                                local base = normalizeAngle16(u32(bit.band(random, 65535)));
                                do
                                    local i = 0
                                    while (i < 15) do
                                        do
                                            fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 268, (enemy).x, (enemy).y, normalizeAngle16((base + (i * 4369))), speed, i) and 1 or 0)) ~= 0)
                                        end
                                        i = i + 1
                                    end
                                end
                            end
                        end;
                        if ((v_local >= halfPeriod) and (math.fmod((v_local - halfPeriod), (halfPeriod * 2)) == 0)) then
                            do
                                local random = lateBossFrameRand((timer + 1));
                                local base = normalizeAngle16(u32(bit.band(random, 65535)));
                                do
                                    local i = 0
                                    while (i < 15) do
                                        do
                                            fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 269, (enemy).x, (enemy).y, normalizeAngle16((base + (i * 4369))), speed, i) and 1 or 0)) ~= 0)
                                        end
                                        i = i + 1
                                    end
                                end
                            end
                        end
                    end
                else
                    if ((state == 81) and (timer >= 30)) then
                        do
                            local v_local = (timer - 30);
                            local aimed = (aimFrom)((enemy).x, (enemy).y);
                            if (timer == 30) then
                                (enemy).secondaryAngle16 = (aimed % 65536)
                            end;
                            if (bit.band(v_local, 3) == 0) then
                                do
                                    (enemy).secondaryAngle16 = (approachAngle16((enemy).secondaryAngle16, aimed, 120) % 65536);
                                    fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 270, (enemy).x, (enemy).y, (enemy).secondaryAngle16, (2 + (v_local * 0.0015)), trunc(v_local / 4)) and 1 or 0)) ~= 0)
                                end
                            end;
                            if ((timer >= 150) and (math.fmod((timer - 150), 100) == 0)) then
                                do
                                    local speed = (6.5999999999999996 + (v_local * 0.0015));
                                    (ring)(3, 0, aimed, speed, 15, 65536);
                                    (ring)(3, 0, aimed, (speed - 1.6000000000000001), 15, 65536)
                                end
                            end
                        end
                    else
                        if ((state == 101) and (timer >= 30)) then
                            do
                                local v_local = (timer - 30);
                                local first = math.fmod(v_local, 744);
                                if (math.fmod(first, 372) == 0) then
                                    do
                                        local reverse = (first > 371);
                                        fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, (function() if reverse then return 265 else return 264 end end)(), (enemy).x, (enemy).y, normalizeAngle16((((function() if reverse then return (-1) else return 1 end end)() * timer) * 1024)), 16, trunc(first / 372)) and 1 or 0)) ~= 0)
                                    end
                                end;
                                if ((timer >= 216) and (math.fmod((timer - 216), 372) == 0)) then
                                    do
                                        local reverse = (bit.band(trunc((timer - 216) / 372), 1) ~= 0);
                                        fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, (function() if reverse then return 265 else return 264 end end)(), (enemy).x, (enemy).y, normalizeAngle16((timer * (-1024))), 16, trunc((timer - 216) / 372)) and 1 or 0)) ~= 0)
                                    end
                                end;
                                if ((timer >= 45) and (math.fmod((timer - 45), 93) == 0)) then
                                    do
                                        (ring)(2, 0, (aimFrom)((enemy).x, (enemy).y), 3.2000000000000002, 21, 65536)
                                    end
                                end
                            end
                        else
                            if ((state == 121) and (timer >= 30)) then
                                do
                                    local scheduled = 30;
                                    local interval = 140;
                                    do
                                        local index = 0
                                        while (index < 30) do
                                            do
                                                if (timer == scheduled) then
                                                    do
                                                        local speed = math.min(40, (29 + ((timer - 30) * 0.025999999999999999)));
                                                        local type = (function() if (bit.band(index, 1) == 0) then return 271 else return 272 end end)();
                                                        local targetX = (function() if (type == 271) then return f32(10) else return f32(590) end end)();
                                                        fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, type, targetX, (enemy).y, normalizeAngle16(49152), speed, index) and 1 or 0)) ~= 0);
                                                        do break end
                                                    end
                                                end;
                                                scheduled = (scheduled + math.max(interval, 80));
                                                interval = (interval - 10)
                                            end
                                            index = index + 1
                                        end
                                    end
                                end
                            else
                                if ((state == 131) and (timer >= 290)) then
                                    do
                                        local v_local = math.fmod((timer - 290), 1800);
                                        local leftX = f32(200);
                                        local rightX = f32(520);
                                        local leftAim = (aimFrom)(leftX, f32(240));
                                        local rightAim = (aimFrom)(rightX, f32(240));
                                        if ((v_local < 360) and (math.fmod(v_local, 28) == 0)) then
                                            do
                                                ctx:spawnProjectileSpread(11, 0, leftX, f32(240), leftAim, f32(0), 6, 1, 13, 24000, 0);
                                                ctx:spawnProjectileSpread(10, 0, rightX, f32(240), rightAim, f32(0), 6, 1, 13, 24000, 0);
                                                fired = true
                                            end
                                        end;
                                        if (((v_local >= 480) and (v_local < 870)) and (math.fmod((v_local - 480), 36) == 0)) then
                                            do
                                                ctx:spawnProjectileSpread(5, 0, leftX, f32(240), leftAim, f32(0), 5, 1, 11, 12288, 0);
                                                ctx:spawnProjectileSpread(8, 0, rightX, f32(240), rightAim, f32(0), 5, 1, 7, 24576, 0);
                                                fired = true
                                            end
                                        end
                                    end
                                else
                                    if (((state == 141) and (timer < 210)) and (bit.band(timer, 1) == 0)) then
                                        do
                                            local random = lateBossFrameRand(timer);
                                            fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 296, (enemy).x, (enemy).y, normalizeAngle16(u32(bit.band(random, 65535))), 0, trunc(timer / 2)) and 1 or 0)) ~= 0)
                                        end
                                    else
                                        if ((state == 153) and (timer >= 30)) then
                                            do
                                                if (math.fmod((timer - 30), 360) == 0) then
                                                    do
                                                        local random = lateBossFrameRand(timer);
                                                        fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 308, f32(0), f32(0), normalizeAngle16(u32(bit.band(random, 65535))), 0, trunc((timer - 30) / 360)) and 1 or 0)) ~= 0)
                                                    end
                                                end;
                                                if ((timer >= 210) and (math.fmod((timer - 210), 360) == 0)) then
                                                    do
                                                        local random = lateBossFrameRand((timer + 1));
                                                        fired = (bit.bor((fired and 1 or 0), (ctx:spawnStage10FinalBossEmitter(enemy, 309, f32(0), f32(0), normalizeAngle16(u32(bit.band(random, 65535))), 0, trunc((timer - 210) / 360)) and 1 or 0)) ~= 0)
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
            end
        end
    end;
    if fired then
        do
            ctx:playPlayerSound((ctx).bullet2SoundHandle_, 12)
        end
    end
end

cpp.install(M)

return M
