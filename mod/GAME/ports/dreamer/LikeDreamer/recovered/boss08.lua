-- 由 tools/generate_likedreamer_native_bosses.py 从本地复原源码生成。

-- 生成物是普通 Lua 状态机；修改源逻辑或生成规则后重新生成并核对轨迹。

local cpp = assert(LikeDreamer.Recovered)

local f32, trunc, u32, s16 = cpp.f32, cpp.trunc, cpp.u32, cpp.s16

local bit = require("bit")

local M = {}

local kBoss08Pi = 3.1415926535897931

local kBoss08Tau = (kBoss08Pi * 2)

local boss08Angle

local boss08Radians

local boss08AngleTo

local boss08Approach

local boss08Rand

local boss08Smooth

local boss08UpdateCase

local boss08EntityKind

local boss08CombatState

boss08Angle = function(value)
    do return (bit.band(value, 65535) % 65536) end
end

boss08Radians = function(angle)
    angle = (angle % 65536);
    do return ((angle * kBoss08Tau) / 65536) end
end

boss08AngleTo = function(x0, y0, x1, y1)
    x0 = f32(x0);
    y0 = f32(y0);
    x1 = f32(x1);
    y1 = f32(y1);
    do return boss08Angle(trunc(((math.atan2(f32((y1 - y0)), f32((x1 - x0))) * 65536) / kBoss08Tau))) end
end

boss08Approach = function(current, target, step)
    current = (current % 65536);
    target = (target % 65536);
    local delta = (target - current);
    if (delta > 32768) then
        delta = (delta - 65536)
    end;
    if (delta < (-32768)) then
        delta = (delta + 65536)
    end;
    do return boss08Angle((current + cpp.clamp(delta, (-step), step))) end
end

boss08Rand = function(frame)
    local seed = u32(frame);
    local u = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(seed, 30)), seed)), 1812433253) + 1));
    local a = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(u, 30)), u)), 1812433253) + 2));
    local b = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(a, 30)), a)), 1812433253) + 3));
    local c = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(b, 30)), b)), 1812433253) + 4));
    local mixed = u32(bit.bxor(cpp.mul32(u, 2048), u));
    do return u32(bit.bxor(u32(bit.bxor(u32(bit.rshift(u32(bit.bxor(u32(bit.rshift(c, 11)), mixed)), 8)), c)), mixed)) end
end

boss08Smooth = function(value)
    value = cpp.clamp(value, 0, 1);
    do return ((value * value) * (3 - (2 * value))) end
end

boss08UpdateCase = function(spawnType)
    if ((spawnType >= 167) and (spawnType <= 170)) then
        do return 105 end
    end;
    if (spawnType == 171) then
        do return 106 end
    end;
    if (spawnType == 172) then
        do return 107 end
    end;
    if (spawnType == 173) then
        do return 108 end
    end;
    if ((spawnType == 174) or (spawnType == 175)) then
        do return 109 end
    end;
    if ((spawnType >= 176) and (spawnType <= 179)) then
        do return 110 end
    end;
    if ((spawnType == 180) or (spawnType == 181)) then
        do return 111 end
    end;
    if (spawnType == 182) then
        do return 112 end
    end;
    if (spawnType == 183) then
        do return 113 end
    end;
    if ((spawnType >= 184) and (spawnType <= 186)) then
        do return 114 end
    end;
    if (spawnType == 187) then
        do return 115 end
    end;
    if ((spawnType >= 188) and (spawnType <= 194)) then
        do return 116 end
    end;
    if (spawnType == 195) then
        do return 117 end
    end;
    do return (-1) end
end

boss08EntityKind = function(spawnType)
    if ((spawnType >= 167) and (spawnType <= 170)) then
        do return 0 end
    end;
    if (spawnType == 171) then
        do return 24 end
    end;
    if (spawnType == 172) then
        do return 120 end
    end;
    if ((spawnType >= 173) and (spawnType <= 179)) then
        do return 5 end
    end;
    if (spawnType == 182) then
        do return 7 end
    end;
    if (spawnType == 183) then
        do return 5 end
    end;
    if (spawnType == 187) then
        do return 77 end
    end;
    if ((((spawnType >= 180) and (spawnType <= 181)) or ((spawnType >= 184) and (spawnType <= 186))) or ((spawnType >= 188) and (spawnType <= 195))) then
        do
            do return 1 end
        end
    end;
    do return 0 end
end

boss08CombatState = function(state)
    do return (((((((((state == 1) or (state == 2)) or (state == 11)) or (state == 21)) or (state == 31)) or (state == 41)) or (state == 51)) or (state == 52)) or ((state >= 62) and (state <= 67))) end
end

M.isStage08BossNodeType = function(ctx, spawnType)
    do return ((spawnType >= 167) and (spawnType <= 195)) end
end

M.spawnStage08BossNode = function(ctx, parent, spawnType, childIndex, offsetX, offsetY, angle16, speed, hitPoints, radius, attached)
    offsetX = f32(offsetX);
    offsetY = f32(offsetY);
    angle16 = (angle16 % 65536);
    if ((not ctx:isStage08BossNodeType(spawnType)) or (((#(ctx).enemies_) + (#(ctx).pendingEnemies_)) >= 512)) then
        do
            do return false end
        end
    end;
    local node = cpp.newEnemy();
    (node).entityId = (function() local __old = (ctx).nextEntityId_; (ctx).nextEntityId_ = (ctx).nextEntityId_ + 1; return __old end)();
    (node).spawnType = spawnType;
    (node).updateCase = boss08UpdateCase(spawnType);
    (node).sourceHitPoints = hitPoints;
    (node).hp = math.max(1, hitPoints);
    (node).maxHp = (node).hp;
    (node).drawHp = (node).hp;
    (node).parentEntityId = (parent).entityId;
    (node).parentSpawnType = 319;
    (node).childIndex = childIndex;
    (node).originX = f32(offsetX);
    (node).originY = f32(offsetY);
    (node).x = f32((function() if attached then return f32(((parent).x + offsetX)) else return offsetX end end)());
    (node).y = f32((function() if attached then return f32(((parent).y + offsetY)) else return offsetY end end)());
    (node).sourceX = trunc((node).x);
    (node).sourceY = trunc((node).y);
    (node).sourceAngle16 = (angle16 % 65536);
    (node).secondaryAngle16 = (angle16 % 65536);
    (node).targetAngle16 = (angle16 % 65536);
    (node).angle = f32(f32(boss08Radians(angle16)));
    (node).sourceSpeed = speed;
    (node).speed = f32(f32(speed));
    (node).radius = radius;
    local kind = boss08EntityKind(spawnType);
    (node).sourceDispatchKind = kind;
    (node).sourceDispatchField = radius;
    (node).rewardWeight = kind;
    (node).activationDelay = 0;
    (node).targetable = false;
    (node).drawBodyThisFrame = true;
    (node).sourceNote = "S08 FUN_140038190 internal boss node";
    cpp.push((ctx).pendingEnemies_, node);
    (parent).liveChildCount = (parent).liveChildCount + 1;
    do return true end
end

M.emitStage08BossProjectiles = function(ctx, enemy)
    local difficulty = cpp.clamp(((ctx).config_).difficulty, 0, 4);
    local timer = (enemy).helperTimer;
    if ((enemy).helperState == 1) then
        do
            local cycle = math.fmod((timer - 30), 1800);
            local interval = (function() if (difficulty == 0) then return 120 else return 80 end end)();
            local fanCount = ({5, 7, 9, 7, 9})[difficulty + 1];
            local fanBaseSpeed = ({4, 4.5, 5, 4.5, 5.5})[difficulty + 1];
            local rightX = f32(((enemy).x + f32(110)));
            local leftX = f32(((enemy).x - f32(110)));
            local muzzleY = f32(((enemy).y - f32(76)));
            local rightAim = boss08AngleTo(rightX, muzzleY, ((ctx).player_).x, ((ctx).player_).y);
            local leftAim = boss08AngleTo(leftX, muzzleY, ((ctx).player_).x, ((ctx).player_).y);
            local fireFanPair = function(count, spread, speed)
                ctx:spawnProjectileSpread(12, 0, rightX, muzzleY, rightAim, f32(0), speed, 1, count, spread, 0);
                ctx:spawnProjectileSpread(12, 0, leftX, muzzleY, leftAim, f32(0), speed, 1, count, spread, 0)
            end;
            local fireOpeningWindow = function(start, count, spread)
                if (((cycle < start) or (cycle >= 640)) or (math.fmod((cycle - start), interval) ~= 0)) then
                    do
                        do return end
                    end
                end;
                local speed = (fanBaseSpeed + (cycle * 0.0050000000000000001));
                (fireFanPair)(count, spread, speed);
                if (difficulty >= 3) then
                    do
                        (fireFanPair)(count, spread, (speed + 1.2))
                    end
                end;
                ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
            end;
            (fireOpeningWindow)(30, fanCount, 16000);
            local insetCount = (fanCount - 1);
            local insetSpread = (trunc(16000 / (fanCount - 1)) * (fanCount - 2));
            (fireOpeningWindow)(50, insetCount, insetSpread);
            local aimedStart = (function() if (difficulty < 2) then return 760 else return 740 end end)();
            local aimedInterval = (function() if (difficulty < 2) then return 150 else return 100 end end)();
            if ((cycle >= aimedStart) and (cycle < 960)) then
                do
                    local phase = math.fmod((cycle - aimedStart), aimedInterval);
                    if (phase == 0) then
                        do
                            (enemy).secondaryAngle16 = (rightAim % 65536);
                            (enemy).targetAngle16 = (leftAim % 65536)
                        end
                    end;
                    if ((phase < 30) and (math.fmod(phase, 4) == 0)) then
                        do
                            local speed = ({7, 8, 8, 9, 10})[difficulty + 1];
                            ctx:spawnProjectileNode(9, 0, rightX, muzzleY, (enemy).secondaryAngle16, f32(10), speed, 1, 0);
                            ctx:spawnProjectileNode(9, 0, leftX, muzzleY, (enemy).targetAngle16, f32(10), speed, 1, 0);
                            if (difficulty >= 1) then
                                do
                                    local spread = ({0, 1000, 1500, 2000, 2400})[difficulty + 1];
                                    ctx:spawnProjectileSpread(9, 0, rightX, muzzleY, (enemy).secondaryAngle16, f32(10), (speed - 0.69999999999999996), 1, 2, spread, 0);
                                    ctx:spawnProjectileSpread(9, 0, leftX, muzzleY, (enemy).targetAngle16, f32(10), (speed - 0.69999999999999996), 1, 2, spread, 0)
                                end
                            end;
                            ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                        end
                    end
                end
            end;
            if ((cycle >= 1000) and (cycle < 1760)) then
                do
                    local phase = math.fmod((cycle - 1000), 32);
                    local activeFrames = ({20, 25, 30, 30, 30})[difficulty + 1];
                    if ((phase < activeFrames) and (math.fmod(phase, 5) == 0)) then
                        do
                            local count = ({3, 4, 5, 5, 7})[difficulty + 1];
                            local baseSpeed = ({4.4000000000000004, 5, 5.5, 6, 7.2000000000000002})[difficulty + 1];
                            local speed = ((baseSpeed + ((cycle - 1000) * 0.0040000000000000001)) + (phase * 0.080000000000000002));
                            local angleCycle = math.fmod((cycle - 810), 760);
                            local angleProduct = (angleCycle * 21);
                            local angleOffset = (function() if (angleCycle < 380) then return (angleProduct - 4000) else return (11960 - angleProduct) end end)();
                            local angleA = boss08Angle((16384 + angleOffset));
                            local angleB = boss08Angle((16384 - angleOffset));
                            local fireBurstPair = function(burstSpeed)
                                ctx:spawnProjectileSpread(9, 0, (enemy).x, f32(10), angleA, f32(10), burstSpeed, 1, count, 16000, 0);
                                ctx:spawnProjectileSpread(9, 0, (enemy).x, f32(10), angleB, f32(10), burstSpeed, 1, count, 16000, 0)
                            end;
                            (fireBurstPair)(speed);
                            if (difficulty >= 3) then
                                do
                                    (fireBurstPair)((speed + 0.80000000000000004))
                                end
                            end;
                            ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                        end
                    end
                end
            end;
            do return end
        end
    end;
    if ((enemy).helperState == 2) then
        do
            local index = difficulty;
            local kIntervals = {160, 120, 120, 120, 120};
            local kNodeCounts = {13, 17, 19, 19, 21};
            local kRingCounts = {21, 33, 37, 33, 37};
            local kRingSpeeds = {2.5, 3.2000000000000002, 4, 3, 4};
            local interval = (kIntervals)[index + 1];
            local doubleInterval = (interval * 2);
            local nodeCount = (kNodeCounts)[index + 1];
            local muzzleY = f32(((enemy).y - f32(76)));
            local leftX = f32(((enemy).x - f32(110)));
            local rightX = f32(((enemy).x + f32(110)));
            local centerAim = boss08AngleTo((enemy).x, f32(((enemy).y - f32(143))), ((ctx).player_).x, ((ctx).player_).y);
            local spawnNodeRing = function(type)
                do
                    local i = 0
                    while (i < nodeCount) do
                        do
                            local angle = boss08Angle((centerAim + (i * trunc(65536 / nodeCount))));
                            ctx:spawnStage08BossNode(enemy, type, i, (enemy).x, f32(((enemy).y - f32(143))), angle, 0, 600, 45, false)
                        end
                        ::__continue2::
                        i = i + 1
                    end
                    ::__loop_end1::
                end;
                ctx:playPlayerSound((ctx).bullet2SoundHandle_, 25)
            end;
            if ((timer >= 0) and (math.fmod(timer, doubleInterval) == 0)) then
                do
                    (spawnNodeRing)(174)
                end
            end;
            if ((timer >= interval) and (math.fmod((timer - interval), doubleInterval) == 0)) then
                do
                    (spawnNodeRing)(175)
                end
            end;
            local fireRing = function(x, angle)
                x = f32(x);
                angle = (angle % 65536);
                local ringCount = (kRingCounts)[index + 1];
                local speed = (kRingSpeeds)[index + 1];
                ctx:spawnProjectileSpread(2, 0, x, muzzleY, angle, f32(0), speed, 1, ringCount, 65536, 0);
                if (difficulty > 2) then
                    do
                        ctx:spawnProjectileSpread(2, 0, x, muzzleY, boss08Angle((angle + trunc(65536 / ringCount))), f32(0), (speed + 2), 1, ringCount, 65536, 0)
                    end
                end
            end;
            local fireLeft = (((timer >= 70) and (math.fmod((timer - 70), doubleInterval) == 0)) or ((timer >= (interval + 90)) and (math.fmod((timer - (interval + 90)), doubleInterval) == 0)));
            if fireLeft then
                do
                    (fireRing)(leftX, boss08AngleTo(leftX, muzzleY, ((ctx).player_).x, ((ctx).player_).y))
                end
            end;
            local fireRight = (((timer >= 90) and (math.fmod((timer - 90), doubleInterval) == 0)) or ((timer >= (interval + 70)) and (math.fmod((timer - (interval + 70)), doubleInterval) == 0)));
            if fireRight then
                do
                    (fireRing)(rightX, boss08AngleTo(rightX, muzzleY, ((ctx).player_).x, ((ctx).player_).y))
                end
            end;
            do return end
        end
    end;
    if ((enemy).helperState == 11) then
        do
            if (timer < 60) then
                do return end
            end;
            local index = difficulty;
            local cycle = math.fmod((timer - 60), 1600);
            local centerY = f32(((enemy).y - f32(143)));
            local sideY = f32(((enemy).y - f32(76)));
            local rightX = f32(((enemy).x + f32(110)));
            local leftX = f32(((enemy).x - f32(110)));
            local centerAim = boss08AngleTo((enemy).x, centerY, ((ctx).player_).x, ((ctx).player_).y);
            local rightAim = boss08AngleTo(rightX, sideY, ((ctx).player_).x, ((ctx).player_).y);
            local leftAim = boss08AngleTo(leftX, sideY, ((ctx).player_).x, ((ctx).player_).y);
            local kFanStarts = {0, 60, 140, 240};
            local kFanLengths = {32, 52, 72, 80};
            local kFanCounts = {3, 3, 3, 5, 7};
            local kFanSpreads = {800, 1000, 1200, 2400, 2400};
            local kFanSpeeds = {6, 7, 7.5, 7.5, 8.8000000000000007};
            do
                local wave = 0
                while (wave < (#kFanStarts)) do
                    do
                        local v_local = (cycle - (kFanStarts)[wave + 1]);
                        if (((v_local < 0) or (v_local >= (kFanLengths)[wave + 1])) or (math.fmod(v_local, 4) ~= 0)) then
                            do
                                goto __continue4
                            end
                        end;
                        if (v_local == 0) then
                            (enemy).secondaryAngle16 = (centerAim % 65536)
                        end;
                        ctx:spawnProjectileSpread(11, 0, (enemy).x, centerY, (enemy).secondaryAngle16, f32(10), ((kFanSpeeds)[index + 1] + (v_local * 0.14999999999999999)), 1, (kFanCounts)[index + 1], (kFanSpreads)[index + 1], 0);
                        ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19);
                        (enemy).secondaryAngle16 = (boss08Approach((enemy).secondaryAngle16, centerAim, 200) % 65536);
                        goto __loop_end3
                    end
                    ::__continue4::
                    wave = wave + 1
                end
                ::__loop_end3::
            end;
            local kRingPeriods = {14, 14, 12, 14, 14};
            local kRingActive = {4, 5, 5, 7, 7};
            local kRingCounts = {3, 5, 7, 7, 7};
            local kRingSpeeds = {3.5, 4.5, 5, 5, 6.4000000000000004};
            if (((cycle >= 20) and (cycle < 300)) and (math.fmod((cycle - 20), (kRingPeriods)[index + 1]) < (kRingActive)[index + 1])) then
                do
                    local turn = trunc((math.sin(((cycle * kBoss08Pi) / 320)) * 31000));
                    local speed = ((kRingSpeeds)[index + 1] + (cycle * 0.0080000000000000002));
                    local fireRingPair = function(pairSpeed)
                        ctx:spawnProjectileSpread(8, 0, rightX, sideY, boss08Angle((16384 - turn)), f32(10), pairSpeed, 1, (kRingCounts)[index + 1], 65536, 0);
                        ctx:spawnProjectileSpread(8, 0, leftX, sideY, boss08Angle((16384 + turn)), f32(10), pairSpeed, 1, (kRingCounts)[index + 1], 65536, 0)
                    end;
                    (fireRingPair)(speed);
                    if (difficulty >= 3) then
                        (fireRingPair)((speed + 0.40000000000000002))
                    end;
                    ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                end
            end;
            local kLayerIntervals = {90, 60, 50, 60, 50};
            local kLayerCounts = {7, 9, 11, 11, 13};
            local kLayerSpeeds = {4, 5, 5.5, 5.5, 6.5};
            if (((cycle >= 380) and (cycle < 640)) and (math.fmod((cycle - 380), (kLayerIntervals)[index + 1]) == 0)) then
                do
                    local count = (kLayerCounts)[index + 1];
                    local speed = ((kLayerSpeeds)[index + 1] + ((cycle - 380) * 0.0050000000000000001));
                    local fireLayer = function(layerSpeed, layerCount, spread)
                        ctx:spawnProjectileSpread(3, 0, (enemy).x, centerY, centerAim, f32(10), layerSpeed, 1, layerCount, spread, 0)
                    end;
                    (fireLayer)(speed, count, 32768);
                    (fireLayer)((speed + 0.69999999999999996), count, 32768);
                    (fireLayer)((speed + 1.3999999999999999), count, 32768);
                    if (difficulty >= 3) then
                        do
                            local insetCount = (count - 1);
                            local insetSpread = (trunc(32768 / insetCount) * (count - 2));
                            (fireLayer)((speed - 1), insetCount, insetSpread);
                            (fireLayer)((speed - 0.59999999999999998), insetCount, insetSpread)
                        end
                    end;
                    ctx:playPlayerSound((ctx).bullet2SoundHandle_, 19)
                end
            end;
            local kCrossUnits = {12, 8, 6, 5, 4};
            local kCrossSpreads = {6400, 5800, 5400, 5000, 4500};
            local kCrossSpeeds = {4.5, 5.5, 6, 6, 6};
            if ((cycle >= 700) and (cycle < 960)) then
                do
                    local v_local = (cycle - 700);
                    local unit = (kCrossUnits)[index + 1];
                    local ring = trunc(v_local / (unit * 2));
                    local count = (ring + 1);
                    local spreadStep = ((kCrossSpreads)[index + 1] - (v_local * 10));
                    local spread = (ring * spreadStep);
                    local speed = ((kCrossSpeeds)[index + 1] + (v_local * 0.029999999999999999));
                    if (math.fmod(v_local, (unit * 2)) == 0) then
                        do
                            ctx:spawnProjectileSpread(13, 0, rightX, sideY, rightAim, f32(10), speed, 1, count, spread, 0);
                            ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                        end
                    end;
                    if ((v_local >= unit) and (math.fmod((v_local - unit), (unit * 2)) == 0)) then
                        do
                            ctx:spawnProjectileSpread(12, 0, leftX, sideY, leftAim, f32(10), speed, 1, count, spread, 0);
                            ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                        end
                    end
                end
            end;
            if (cycle == 960) then
                do
                    local kOuterCounts = {5, 5, 7, 7, 7};
                    local kInnerCounts = {2, 3, 4, 4, 5};
                    local kBurstSpeeds = {5, 6.5999999999999996, 7.2000000000000002, 7.7000000000000001, 8.8000000000000007};
                    local outerCount = (kOuterCounts)[index + 1];
                    local baseCount = (function() if (difficulty == 0) then return 5 else return 7 end end)();
                    do
                        local outer = 0
                        while (outer < outerCount) do
                            do
                                local angleOffset = ((((outer * 2) - outerCount) + 1) * 180);
                                local rightAngle = boss08Angle((rightAim + angleOffset));
                                local leftAngle = boss08Angle((leftAim + angleOffset));
                                do
                                    local inner = 0
                                    while (inner < (kInnerCounts)[index + 1]) do
                                        do
                                            local count = (baseCount - inner);
                                            local spread = (trunc(32768 / (count - 1)) * (count - 2));
                                            local innerValue = inner;
                                            local speed = ((kBurstSpeeds)[index + 1] - (innerValue * (1.8 - (innerValue * 0.20000000000000001))));
                                            local fireBurstPair = function(pairSpeed)
                                                ctx:spawnProjectileSpread(4, 0, rightX, sideY, rightAngle, f32(10), pairSpeed, 1, count, spread, 0);
                                                ctx:spawnProjectileSpread(4, 0, leftX, sideY, leftAngle, f32(10), pairSpeed, 1, count, spread, 0)
                                            end;
                                            (fireBurstPair)(speed);
                                            if (difficulty >= 3) then
                                                (fireBurstPair)((speed + 0.29999999999999999))
                                            end
                                        end
                                        ::__continue8::
                                        inner = inner + 1
                                    end
                                    ::__loop_end7::
                                end
                            end
                            ::__continue6::
                            outer = outer + 1
                        end
                        ::__loop_end5::
                    end;
                    ctx:playPlayerSound((ctx).bullet2SoundHandle_, 19)
                end
            end;
            local kFinalHalfPeriods = {6, 4, 4, 4, 3};
            local kFinalCounts = {5, 7, 9, 11, 12};
            local kFinalSpeeds = {4, 5.5, 6, 7, 7.7999999999999998};
            if (((cycle >= 1060) and (cycle < 1550)) and (math.fmod((cycle - 1060), ((kFinalHalfPeriods)[index + 1] * 2)) == 0)) then
                do
                    local spread = (17000 + trunc((math.sin((((cycle - 1050) * kBoss08Pi) / 100)) * 5000)));
                    local speed = ((kFinalSpeeds)[index + 1] + ((cycle - 1060) * 0.0070000000000000001));
                    local angle = boss08Angle((cycle * 360));
                    ctx:spawnProjectileSpread(4, 0, (enemy).x, centerY, angle, f32(10), speed, 1, (kFinalCounts)[index + 1], spread, 0);
                    ctx:spawnProjectileSpread(4, 0, (enemy).x, centerY, boss08Angle((angle + 32768)), f32(10), speed, 1, (kFinalCounts)[index + 1], spread, 0);
                    ctx:playPlayerSound((ctx).bullet2SoundHandle_, 19)
                end
            end;
            do return end
        end
    end;
    if ((enemy).helperState == 21) then
        do
            local index = difficulty;
            local cycle = (function() if (timer >= 60) then return math.fmod((timer - 60), 1400) else return (-1) end end)();
            local muzzleWave = trunc((math.sin((((ctx).frame_ * kBoss08Pi) / 60)) * 2000));
            local angleARadians = boss08Radians(boss08Angle((muzzleWave - 7600)));
            local angleBRadians = boss08Radians(boss08Angle((40368 - muzzleWave)));
            local muzzleAX = f32((f32(((enemy).x + f32(10))) + f32((math.cos(angleARadians) * 70))));
            local muzzleAY = f32((f32(((enemy).y - f32(15))) + f32((math.sin(angleARadians) * 70))));
            local muzzleBX = f32((f32(((enemy).x - f32(10))) + f32((math.cos(angleBRadians) * 70))));
            local muzzleBY = f32((f32(((enemy).y - f32(15))) + f32((math.sin(angleBRadians) * 70))));
            local aimA = boss08AngleTo(muzzleAX, muzzleAY, ((ctx).player_).x, ((ctx).player_).y);
            local aimB = boss08AngleTo(muzzleBX, muzzleBY, ((ctx).player_).x, ((ctx).player_).y);
            if ((((cycle == 0) or (cycle == 180)) or (cycle == 360)) or (cycle == 540)) then
                do
                    local kTypes = {178, 177, 176, 179};
                    local kNodeCounts = {7, 7, 9, 9, 9};
                    local kSlowTurns = {150, 180, 222, 222, 222};
                    local kFastTurns = {330, 300, 300, 280, 280};
                    local type = (kTypes)[trunc(cycle / 180) + 1];
                    local count = (kNodeCounts)[index + 1];
                    local turn = (function() if (type < 178) then return (kSlowTurns)[index + 1] else return (kFastTurns)[index + 1] end end)();
                    do
                        local i = 0
                        while (i < count) do
                            do
                                ctx:spawnStage08BossNode(enemy, type, i, f32(0), f32(0), boss08Angle((i * trunc(65536 / count))), turn, 1600, 45, false)
                            end
                            ::__continue10::
                            i = i + 1
                        end
                        ::__loop_end9::
                    end;
                    ctx:playPlayerSound((ctx).bossSe1SoundHandle_, 25)
                end
            end;
            local kAimActive = {80, 100, 100, 120, 120};
            local kAimCounts = {3, 5, 7, 7, 9};
            local kAimSpeeds = {5, 6.5, 7, 7, 8};
            if ((cycle >= 100) and (cycle < 800)) then
                do
                    local v_local = math.fmod((cycle - 100), 180);
                    local segment = trunc((cycle - 100) / 180);
                    if (v_local == 0) then
                        do
                            (enemy).secondaryAngle16 = (aimA % 65536);
                            (enemy).targetAngle16 = (aimB % 65536)
                        end
                    end;
                    if ((v_local < (kAimActive)[index + 1]) and (math.fmod(v_local, 4) == 0)) then
                        do
                            local count = (kAimCounts)[index + 1];
                            local spread = (function() if (cycle < 640) then return ((6 - segment) * 5000) else return ((count - 1) * 640) end end)();
                            local speed = ((kAimSpeeds)[index + 1] + (v_local * 0.14999999999999999));
                            ctx:spawnProjectileSpread(2, 0, muzzleAX, muzzleAY, (enemy).secondaryAngle16, f32(0), speed, 1, count, spread, 0);
                            ctx:spawnProjectileSpread(2, 0, muzzleBX, muzzleBY, (enemy).targetAngle16, f32(0), speed, 1, count, spread, 0);
                            (enemy).secondaryAngle16 = (boss08Approach((enemy).secondaryAngle16, aimA, 120) % 65536);
                            (enemy).targetAngle16 = (boss08Approach((enemy).targetAngle16, aimB, 120) % 65536);
                            ctx:playPlayerSound((ctx).bullet2SoundHandle_, 19)
                        end
                    end
                end
            end;
            local kNeedleIntervals = {5, 4, 4, 4, 3};
            local kNeedleCounts = {3, 4, 5, 7, 7};
            local kNeedleSpeeds = {5, 5, 4.5, 4, 4};
            if ((cycle >= 820) and (cycle < 860)) then
                do
                    local v_local = (cycle - 820);
                    if (v_local == 0) then
                        (enemy).secondaryAngle16 = (aimA % 65536)
                    end;
                    if (math.fmod(v_local, (kNeedleIntervals)[index + 1]) == 0) then
                        do
                            do
                                local i = 0
                                while (i < (kNeedleCounts)[index + 1]) do
                                    do
                                        local angle = boss08Angle(((((enemy).secondaryAngle16 + (cycle * 704)) + 11724) - (i * 333)));
                                        ctx:spawnProjectileNode(5, 40, muzzleAX, muzzleAY, angle, f32(0), ((kNeedleSpeeds)[index + 1] + i), 1, 0)
                                    end
                                    ::__continue12::
                                    i = i + 1
                                end
                                ::__loop_end11::
                            end;
                            ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                        end
                    end
                end
            end;
            if ((cycle >= 970) and (cycle < 1010)) then
                do
                    local v_local = (cycle - 970);
                    if (v_local == 0) then
                        (enemy).secondaryAngle16 = (aimB % 65536)
                    end;
                    if (math.fmod(v_local, (kNeedleIntervals)[index + 1]) == 0) then
                        do
                            do
                                local i = 0
                                while (i < (kNeedleCounts)[index + 1]) do
                                    do
                                        local angle = boss08Angle(((((enemy).secondaryAngle16 - (cycle * 705)) + 38490) + (i * 333)));
                                        ctx:spawnProjectileNode(5, 40, muzzleBX, muzzleBY, angle, f32(0), ((kNeedleSpeeds)[index + 1] + i), 1, 0)
                                    end
                                    ::__continue14::
                                    i = i + 1
                                end
                                ::__loop_end13::
                            end;
                            ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                        end
                    end
                end
            end;
            if (cycle >= 1100) then
                do
                    local v_local = (cycle - 1100);
                    if (v_local == 0) then
                        do
                            (enemy).secondaryAngle16 = (aimA % 65536);
                            (enemy).targetAngle16 = (aimB % 65536)
                        end
                    end;
                    local kConvergeSpreads = {3200, 2500, 2000, 1500, 1500};
                    if (math.fmod(v_local, 3) == 0) then
                        do
                            local converge = math.sin(((v_local * kBoss08Pi) / 600));
                            local spreadStep = (20000 + trunc((converge * ((kConvergeSpreads)[index + 1] - 20000))));
                            local speed = (function() if (cycle < 1200) then return (8 + (math.sin(((v_local * kBoss08Pi) / 200)) * 7)) else return 15 end end)();
                            do
                                local layer = 1
                                while (layer <= 3) do
                                    do
                                        local spread = (layer * spreadStep);
                                        ctx:spawnProjectileSpread(7, 0, muzzleAX, muzzleAY, (enemy).secondaryAngle16, f32(10), speed, 1, 2, spread, 0);
                                        ctx:spawnProjectileSpread(7, 0, muzzleBX, muzzleBY, (enemy).targetAngle16, f32(10), speed, 1, 2, spread, 0)
                                    end
                                    ::__continue16::
                                    layer = layer + 1
                                end
                                ::__loop_end15::
                            end;
                            local step = (function() if (cycle < 1200) then return (200 - trunc((math.sin(((v_local * kBoss08Pi) / 200)) * 190))) else return 10 end end)();
                            (enemy).secondaryAngle16 = (boss08Approach((enemy).secondaryAngle16, aimA, step) % 65536);
                            (enemy).targetAngle16 = (boss08Approach((enemy).targetAngle16, aimB, step) % 65536);
                            ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                        end
                    end;
                    local kClosingCounts = {3, 5, 7, 9, 11};
                    local kClosingSpeeds = {5, 6, 7, 8, 9};
                    local groupCount = (function() if (difficulty == 0) then return 2 else return 3 end end)();
                    local groupGap = (function() if (difficulty == 0) then return 70 else return 50 end end)();
                    local start = 1160;
                    local accumulatedGap = 0;
                    do
                        local group = 0
                        while (group < groupCount) do
                            do
                                local count = (kClosingCounts)[index + 1];
                                local speed = (kClosingSpeeds)[index + 1];
                                local v_end = ((start + 12) + accumulatedGap);
                                if (((cycle >= start) and (cycle < v_end)) and (math.fmod((cycle - start), 12) == 0)) then
                                    do
                                        ctx:spawnProjectileSpread(12, 0, muzzleAX, muzzleAY, aimA, f32(10), speed, 1, count, 24000, 0);
                                        ctx:spawnProjectileSpread(12, 0, muzzleBX, muzzleBY, aimB, f32(10), speed, 1, count, 24000, 0);
                                        ctx:playPlayerSound((ctx).bullet2SoundHandle_, 19)
                                    end
                                end;
                                if (((cycle >= (start + 6)) and (cycle < v_end)) and (math.fmod((cycle - (start + 6)), 12) == 0)) then
                                    do
                                        local insetCount = (count - 1);
                                        local insetSpread = (trunc(24000 / insetCount) * (count - 2));
                                        ctx:spawnProjectileSpread(12, 0, muzzleAX, muzzleAY, aimA, f32(10), speed, 1, insetCount, insetSpread, 0);
                                        ctx:spawnProjectileSpread(12, 0, muzzleBX, muzzleBY, aimB, f32(10), speed, 1, insetCount, insetSpread, 0);
                                        ctx:playPlayerSound((ctx).bullet2SoundHandle_, 19)
                                    end
                                end;
                                start = (start + (accumulatedGap + groupGap));
                                accumulatedGap = (accumulatedGap + 12)
                            end
                            ::__continue18::
                            group = group + 1
                        end
                        ::__loop_end17::
                    end
                end
            end;
            do return end
        end
    end;
    if ((enemy).helperState == 31) then
        do
            if (timer == 10) then
                do
                    ctx:spawnStage08BossNode(enemy, 180, 0, f32(0), f32(0), (57344 % 65536), 444, 99999999, 45, true);
                    ctx:playPlayerSound((ctx).bullet2SoundHandle_, 25)
                end
            end;
            if (timer == 100) then
                do
                    ctx:spawnStage08BossNode(enemy, 181, 1, f32(0), f32(0), (40960 % 65536), 555, 99999999, 45, true);
                    ctx:playPlayerSound((ctx).bullet2SoundHandle_, 25)
                end
            end;
            do return end
        end
    end;
    if ((enemy).helperState == 41) then
        do
            local cycle = math.fmod(timer, 1600);
            if (cycle < 1050) then
                do
                    local v_local = math.fmod(cycle, 350);
                    local spawnPair = function(hitPoints, speed)
                        ctx:spawnStage08BossNode(enemy, 182, (cycle * 2), (enemy).x, (enemy).y, boss08Angle(((v_local * 550) - 3216)), speed, hitPoints, 45, false);
                        ctx:spawnStage08BossNode(enemy, 182, ((cycle * 2) + 1), (enemy).x, (enemy).y, boss08Angle((35984 - (v_local * 550))), speed, hitPoints, 45, false)
                    end;
                    if (((v_local >= 40) and (v_local < 80)) and (math.fmod((v_local - 40), 8) == 0)) then
                        do
                            (spawnPair)(2000, 8);
                            ctx:playPlayerSound((ctx).bullet2SoundHandle_, 25)
                        end
                    end;
                    if (((cycle >= 390) and (cycle < 430)) and (math.fmod((cycle - 390), 6) == 0)) then
                        do
                            (spawnPair)(1500, 12);
                            ctx:playPlayerSound((ctx).bullet2SoundHandle_, 25)
                        end
                    end;
                    if (cycle > 699) then
                        do
                            local ringStep = (v_local - 40);
                            if (((ringStep >= 0) and (ringStep < 60)) and (math.fmod(ringStep, 40) == 0)) then
                                do
                                    local ringIndex = trunc(ringStep / 40);
                                    local count = (11 - (ringIndex * 4));
                                    local speed = (12 - (ringIndex * 5));
                                    local random = boss08Rand(timer);
                                    local base = boss08Angle(u32((random - trunc(random / 65537))));
                                    do
                                        local i = 0
                                        while (i < count) do
                                            do
                                                ctx:spawnStage08BossNode(enemy, 182, ((cycle * 16) + i), (enemy).x, (enemy).y, boss08Angle((base + (i * trunc(65536 / count)))), speed, 1000, 45, false)
                                            end
                                            ::__continue20::
                                            i = i + 1
                                        end
                                        ::__loop_end19::
                                    end;
                                    ctx:playPlayerSound((ctx).bullet2SoundHandle_, 25)
                                end
                            end
                        end
                    end
                end
            else
                do
                    local interval = ({9, 6, 5, 5, 5})[difficulty + 1];
                    if (((cycle >= 1140) and (cycle < 1500)) and (math.fmod((cycle - 1140), interval) == 0)) then
                        do
                            local angle = boss08Angle((math.fmod(boss08Rand(timer), 12801) - 22784));
                            ctx:spawnStage08BossNode(enemy, 183, cycle, (enemy).x, (enemy).y, angle, 9, 500, 40, false);
                            ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                        end
                    end
                end
            end;
            do return end
        end
    end;
    if (((enemy).helperState == 51) or ((enemy).helperState == 52)) then
        do
            if (((enemy).helperState == 51) and (timer == 60)) then
                do
                    ctx:spawnStage08BossNode(enemy, 184, 0, f32(0), f32(0), (0 % 65536), 0, 99999999, 110, true)
                end
            end;
            if ((((enemy).helperState == 51) and (timer >= 90)) and (timer <= 100)) then
                do
                    (enemy).y = f32(f32(((enemy).y - f32((12 - ((timer - 90) * 1.2))))))
                end
            end;
            if ((((enemy).helperState == 51) and (timer >= 110)) and (timer <= 120)) then
                do
                    (enemy).y = f32(f32(((enemy).y + f32((12 - ((timer - 110) * 1.2))))))
                end
            end;
            if (((enemy).helperState == 51) and (timer == 140)) then
                do
                    ctx:playPlayerSound((ctx).bullet2SoundHandle_, 25)
                end
            end;
            do return end
        end
    end;
    if (((enemy).helperState >= 62) and ((enemy).helperState <= 67)) then
        do
            local family = math.fmod(((enemy).helperState - 62), 3);
            local interval = (function() if (family == 0) then return ({50, 36, 32, 32, 28})[difficulty + 1] else return (function() if (family == 1) then return ({40, 28, 25, 25, 21})[difficulty + 1] else return ({30, 20, 18, 18, 16})[difficulty + 1] end end)() end end)();
            if ((timer > 100) and (math.fmod((timer - 100), interval) == 0)) then
                do
                    local variants = (2 + (family * 2));
                    local random = boss08Rand(timer);
                    local variant = math.fmod(random, u32((variants + 1)));
                    local type = (188 + math.min(6, variant));
                    local angle = boss08Angle((math.fmod(random, 30001) - 31384));
                    local speed = (3 + (math.fmod(random, 401) / 100));
                    ctx:spawnStage08BossNode(enemy, type, trunc(timer / interval), (enemy).x, (enemy).y, angle, speed, 99999999, 40, false);
                    ctx:playPlayerSound((ctx).bullet2SoundHandle_, 25)
                end
            end
        end
    end
end

M.updateStage08BossNode = function(ctx, enemy)
    (enemy).vx = f32(f32(0));
    (enemy).vy = f32(f32(0));
    (enemy).drawBodyThisFrame = true;
    (enemy).drawMarkerThisFrame = false;
    local parent = ctx:findEnemyById((enemy).parentEntityId);
    if (((parent == nil) or ((parent).spawnType ~= 319)) or (not (parent).active)) then
        do
            (enemy).active = false;
            do return end
        end
    end;
    local timer = (enemy).helperTimer;
    local difficulty = cpp.clamp(((ctx).config_).difficulty, 0, 4);
    local aimed = function()
        do return boss08AngleTo((enemy).x, (enemy).y, ((ctx).player_).x, ((ctx).player_).y) end
    end;
    local move = function(speed)
        local radians = boss08Radians((enemy).sourceAngle16);
        (enemy).x = f32(f32(((enemy).x + f32((math.cos(radians) * speed)))));
        (enemy).y = f32(f32(((enemy).y + f32((math.sin(radians) * speed)))))
    end;
    local smallFrame = function(index)
        do return (function() if ((index >= 0) and (index < (#(ctx).enemySmallFrames_))) then return ((ctx).enemySmallFrames_)[index + 1] else return (-1) end end)() end
    end;
    local mediumEffectFrame = function(index)
        do return (function() if ((index >= 0) and (index < (#(ctx).effectMediumFrames_))) then return ((ctx).effectMediumFrames_)[index + 1] else return (-1) end end)() end
    end;
    local mediumFrame = function(index)
        do return (function() if ((index >= 0) and (index < (#(ctx).enemyMediumFrames_))) then return ((ctx).enemyMediumFrames_)[index + 1] else return (-1) end end)() end
    end;
    local spawnTrail = function(type, handle, layer, x, y, angle, scale, lifetime)
        x = f32(x);
        y = f32(y);
        angle = (angle % 65536);
        ctx:spawnStageEffect(type, handle, 0, layer, x, y, angle, 0, scale, scale, lifetime, 255, 255, 255, 96, 0)
    end;
    local spawnTwinTrail = function(scale, radius, bladeAngle)
        bladeAngle = (bladeAngle % 65536);
        local radians = boss08Radians((enemy).sourceAngle16);
        local dx = f32((math.cos(radians) * radius));
        local dy = f32((math.sin(radians) * radius));
        (spawnTrail)(5, (smallFrame)(136), 35, f32(((enemy).x + dx)), f32(((enemy).y + dy)), bladeAngle, scale, 16);
        (spawnTrail)(7, (smallFrame)(136), 35, f32(((enemy).x - dx)), f32(((enemy).y - dy)), boss08Angle((bladeAngle + 32768)), scale, 24);
        (spawnTrail)(5, (smallFrame)(135), 35, (enemy).x, (enemy).y, (0 % 65536), scale, 24)
    end;
    do
        local __switch22 = (enemy).spawnType
        if __switch22 == 167 then goto __case23
        elseif __switch22 == 168 then goto __case24
        elseif __switch22 == 169 then goto __case25
        elseif __switch22 == 170 then goto __case26
        elseif __switch22 == 171 then goto __case27
        elseif __switch22 == 172 then goto __case34
        elseif __switch22 == 173 then goto __case41
        elseif __switch22 == 174 then goto __case42
        elseif __switch22 == 175 then goto __case43
        elseif __switch22 == 176 then goto __case44
        elseif __switch22 == 177 then goto __case45
        elseif __switch22 == 178 then goto __case46
        elseif __switch22 == 179 then goto __case47
        elseif __switch22 == 180 then goto __case48
        elseif __switch22 == 181 then goto __case49
        elseif __switch22 == 182 then goto __case50
        elseif __switch22 == 183 then goto __case51
        elseif __switch22 == 184 then goto __case52
        elseif __switch22 == 185 then goto __case53
        elseif __switch22 == 186 then goto __case60
        elseif __switch22 == 187 then goto __case63
        elseif __switch22 == 188 then goto __case66
        elseif __switch22 == 189 then goto __case67
        elseif __switch22 == 190 then goto __case68
        elseif __switch22 == 191 then goto __case69
        elseif __switch22 == 192 then goto __case70
        elseif __switch22 == 193 then goto __case71
        elseif __switch22 == 194 then goto __case72
        elseif __switch22 == 195 then goto __case91
        else goto __case94 end
        ::__case23::;
        ::__case24::;
        do
            local side = (function() if (bit.band((enemy).childIndex, 1) == 0) then return f32(1) else return f32((-f32(1))) end end)();
            local sway = f32((math.sin(((((ctx).frame_ + ((enemy).childIndex * 17)) * kBoss08Tau) / 180)) * 12));
            (enemy).x = f32(f32((f32(((parent).x + (enemy).originX)) + f32((side * sway)))));
            (enemy).y = f32(f32(((parent).y + (enemy).originY)));
            if (((((parent).helperState == 11) and ((parent).helperTimer <= 3)) and ((enemy).helperState == 0)) and ((enemy).spawnType == 167)) then
                do
                    ctx:spawnStage08BossNode(parent, 169, (enemy).childIndex, (enemy).originX, (enemy).originY, (0 % 65536), 0, 99999999, 50, true);
                    (enemy).helperState = 1
                end
            end;
            if (((((parent).helperState == 11) and ((parent).helperTimer <= 3)) and ((enemy).helperState == 0)) and ((enemy).spawnType == 168)) then
                do
                    ctx:spawnStage08BossNode(parent, 170, (enemy).childIndex, (enemy).originX, (enemy).originY, (0 % 65536), 0, 99999999, 50, true);
                    (enemy).helperState = 1
                end
            end;
            if ((parent).helperState >= 20) then
                (enemy).active = false
            end;
            goto __switch_end21
        end;
        ::__case25::;
        ::__case26::;
        do
            if ((parent).helperState ~= 11) then
                do
                    (enemy).active = false;
                    goto __switch_end21
                end
            end;
            if ((enemy).hp < (parent).hp) then
                do
                    (parent).hp = math.max(0, ((parent).hp - ((parent).hp - (enemy).hp)))
                end
            end;
            (enemy).hp = (parent).hp;
            (enemy).maxHp = (parent).maxHp;
            (enemy).drawHp = (parent).drawHp;
            (enemy).targetable = true;
            (enemy).x = f32(f32(((parent).x + (enemy).originX)));
            (enemy).y = f32(f32(((parent).y + (enemy).originY)));
            goto __switch_end21
        end;
        ::__case27::;
        do
            (enemy).x = f32(f32(((parent).x + (enemy).originX)));
            (enemy).y = f32(f32(((parent).y + (enemy).originY)));
            if ((enemy).helperState == 0) then
                do
                    (enemy).targetable = false;
                    if ((enemy).y < f32((-f32(50)))) then
                        goto __switch_end21
                    end;
                    (enemy).helperState = 1;
                    (enemy).helperTimer = 0;
                    (enemy).targetable = true;
                    timer = (enemy).helperTimer
                end
            end;
            if ((enemy).helperState == 2) then
                do
                    (enemy).targetable = false;
                    if (((parent).helperState > 19) or ((enemy).y >= f32(900))) then
                        do
                            (enemy).active = false
                        end
                    end;
                    goto __switch_end21
                end
            end;
            if ((enemy).hp < 1) then
                do
                    ctx:spawnEnemyDeathRewardBurst(enemy, 1800, false);
                    ctx:spawnEnemyDeathEffects(enemy, 1, true);
                    (enemy).targetable = false;
                    (enemy).helperState = 2;
                    (enemy).helperTimer = 0;
                    goto __switch_end21
                end
            end;
            if ((parent).helperState >= 10) then
                do
                    ctx:spawnEnemyDeathEffects(enemy, 1, true);
                    (enemy).targetable = false;
                    (enemy).helperState = 2;
                    (enemy).helperTimer = 0;
                    if (((parent).helperState > 19) or ((enemy).y >= f32(900))) then
                        do
                            (enemy).active = false
                        end
                    end;
                    goto __switch_end21
                end
            end;
            if ((enemy).helperState ~= 1) then
                do
                    (enemy).active = false;
                    goto __switch_end21
                end
            end;
            (enemy).targetable = true;
            local kInterval = {90, 70, 55, 55, 55};
            local kSpeed = {8, 9, 9.5, 10, 11.1};
            local interval = (kInterval)[difficulty + 1];
            local v_local = math.fmod((timer - 30), interval);
            local target = (aimed)();
            local firingWindow = ((((timer >= 30) and ((enemy).y < f32(350))) and (v_local >= 0)) and (v_local <= 24));
            if (not firingWindow) then
                do
                    local delta = (target - (enemy).sourceAngle16);
                    if (delta > 32768) then
                        delta = (delta - 65536)
                    end;
                    if (delta < (-32768)) then
                        delta = (delta + 65536)
                    end;
                    (enemy).sourceAngle16 = (boss08Approach((enemy).sourceAngle16, target, (trunc(math.abs(delta) / 10) + 48)) % 65536)
                end
            end;
            if ((firingWindow and (v_local < 24)) and (math.fmod(v_local, 4) == 0)) then
                do
                    local radians = boss08Radians((enemy).sourceAngle16);
                    local fireX = f32(((enemy).x + f32((math.cos(radians) * 25))));
                    local fireY = f32(((enemy).y + f32((math.sin(radians) * 25))));
                    local speed = (kSpeed)[difficulty + 1];
                    ctx:spawnProjectileNode(7, 0, fireX, fireY, (enemy).sourceAngle16, f32(40), speed, 1, 0);
                    do

                        for _, offset in ipairs({(-600), 600}) do
                            do
                                ctx:spawnProjectileNode(7, 0, fireX, fireY, boss08Angle(((enemy).sourceAngle16 + offset)), f32(40), (speed - 0.80000000000000004), 1, 0)
                            end
                            ::__continue29::
                        end
                        ::__loop_end28::
                    end;
                    if (difficulty > 0) then
                        do
                            do

                                for _, offset in ipairs({(-1200), 1200}) do
                                    do
                                        ctx:spawnProjectileNode(7, 0, fireX, fireY, boss08Angle(((enemy).sourceAngle16 + offset)), f32(40), (speed - 1.6000000000000001), 1, 0)
                                    end
                                    ::__continue31::
                                end
                                ::__loop_end30::
                            end
                        end
                    end;
                    if (difficulty > 2) then
                        do
                            do

                                for _, offset in ipairs({(-1800), 1800}) do
                                    do
                                        ctx:spawnProjectileNode(7, 0, fireX, fireY, boss08Angle(((enemy).sourceAngle16 + offset)), f32(40), (speed - 0.80000000000000004), 1, 0)
                                    end
                                    ::__continue33::
                                end
                                ::__loop_end32::
                            end
                        end
                    end
                end
            end;
            goto __switch_end21
        end;
        ::__case34::;
        do
            local mountX = (function() if ((enemy).childIndex == 0) then return f32(205) else return f32((-f32(205))) end end)();
            local baseY = f32(((parent).y - f32(90)));
            (enemy).originX = f32(mountX);
            (enemy).originY = f32(f32((-f32(90))));
            (enemy).x = f32(f32(((parent).x + mountX)));
            (enemy).y = f32(f32((f32((baseY - f32(108))) + f32((math.sin(((timer * kBoss08Pi) / 50)) * 3)))));
            (enemy).sourceAngle16 = ((0 % 65536) % 65536);
            if ((enemy).helperState == 0) then
                do
                    (enemy).targetable = false;
                    if (baseY < f32((-f32(120)))) then
                        goto __switch_end21
                    end;
                    (enemy).helperState = 1;
                    (enemy).helperTimer = 0
                end
            end;
            if ((enemy).helperState == 1) then
                do
                    (enemy).radius = 120;
                    (enemy).targetable = ((((parent).helperState == 1) and ((parent).hp > 50000)) and ((enemy).hp > 0));
                    if ((parent).helperState == 1) then
                        do
                            local liveMounts = 0;
                            do

                                for _, candidate in ipairs((ctx).enemies_) do
                                    do
                                        if ((((candidate).active and ((candidate).spawnType == 172)) and ((candidate).parentEntityId == (parent).entityId)) and ((candidate).helperState < 2)) then
                                            do
                                                liveMounts = liveMounts + 1
                                            end
                                        end
                                    end
                                    ::__continue36::
                                end
                                ::__loop_end35::
                            end;
                            do

                                for _, candidate in ipairs((ctx).pendingEnemies_) do
                                    do
                                        if ((((candidate).active and ((candidate).spawnType == 172)) and ((candidate).parentEntityId == (parent).entityId)) and ((candidate).helperState < 2)) then
                                            do
                                                liveMounts = liveMounts + 1
                                            end
                                        end
                                    end
                                    ::__continue38::
                                end
                                ::__loop_end37::
                            end;
                            local cycle = math.fmod(((parent).helperTimer - 30), 1800);
                            local aim = (aimed)();
                            if ((cycle >= 0) and (cycle < 640)) then
                                do
                                    local kCount = {4, 6, 8, 8, 10};
                                    local kAngleStep = {200, 240, 240, 300, 300};
                                    local kSpeed = {4.7999999999999998, 5.5, 6, 6, 7};
                                    local start = 0;
                                    local growth = 0;
                                    do
                                        local burst = 0
                                        while (growth < 36) do
                                            do
                                                local length = (20 + growth);
                                                local assignedToThisMount = ((liveMounts < 2) or (function() if (mountX < f32(0)) then return (bit.band(burst, 1) ~= 0) else return (burst == 0) end end)());
                                                if (cycle == start) then
                                                    (enemy).secondaryAngle16 = (aim % 65536)
                                                end;
                                                if (((assignedToThisMount and (cycle >= start)) and (cycle < (start + length))) and (math.fmod((cycle - start), 4) == 0)) then
                                                    do
                                                        ctx:spawnProjectileSpread(13, 0, (enemy).x, (enemy).y, (enemy).secondaryAngle16, f32(30), ((kSpeed)[difficulty + 1] + (cycle * 0.0070000000000000001)), 1, (kCount)[difficulty + 1], 30000, 0);
                                                        local step = (kAngleStep)[difficulty + 1];
                                                        (enemy).secondaryAngle16 = (boss08Angle(((enemy).secondaryAngle16 + (function() if (bit.band(burst, 1) == 0) then return step else return (-step) end end)())) % 65536);
                                                        ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                                                    end
                                                end;
                                                start = (start + (56 + growth))
                                            end
                                            ::__continue40::
                                            (function() local __ignored = (function() local __old = burst; burst = burst + 1; return burst end)(); return (function() growth = (growth + 4); return growth end)() end)()
                                        end
                                        ::__loop_end39::
                                    end
                                end
                            else
                                if ((cycle >= 680) and (cycle < 960)) then
                                    do
                                        local kInterval = {150, 150, 100, 100, 100};
                                        local kCount = {7, 11, 11, 13, 15};
                                        local kSpeed = {4.2000000000000002, 4.7999999999999998, 5.5, 5.5, 6};
                                        local interval = (kInterval)[difficulty + 1];
                                        local v_local = (cycle - 680);
                                        local phase = math.fmod(v_local, interval);
                                        if ((phase < 48) and (math.fmod(phase, 16) == 0)) then
                                            do
                                                local count = (kCount)[difficulty + 1];
                                                if (liveMounts < 2) then
                                                    count = (count + 2)
                                                end;
                                                local minimumSpread = ((count * 400) - 400);
                                                local spread = (function() if (phase < 40) then return (trunc((math.sin(((phase * kBoss08Pi) / 80)) * (32768 - minimumSpread))) + minimumSpread) else return 32768 end end)();
                                                local speed = (((kSpeed)[difficulty + 1] + (v_local * 0.0089999999999999993)) - (phase * 0.040000000000000001));
                                                ctx:spawnProjectileSpread(2, 0, (enemy).x, (enemy).y, aim, f32(0), speed, 1, count, spread, 0);
                                                if ((difficulty > 2) and (math.fmod(v_local, 100) == 0)) then
                                                    do
                                                        local insetCount = (count - 2);
                                                        local insetSpread = (trunc(spread / insetCount) * (insetCount - 1));
                                                        ctx:spawnProjectileSpread(2, 0, (enemy).x, (enemy).y, aim, f32(0), (speed + 1), 1, insetCount, insetSpread, 0)
                                                    end
                                                end;
                                                ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                                            end
                                        end
                                    end
                                else
                                    if ((cycle >= 1000) and (cycle < 1740)) then
                                        do
                                            local kInterval = {160, 120, 100, 85, 72};
                                            local kCount = {8, 12, 14, 16, 16};
                                            local phase = math.fmod((cycle - 1000), (kInterval)[difficulty + 1]);
                                            if ((phase < 40) and (math.fmod(phase, 8) == 0)) then
                                                do
                                                    local count = (kCount)[difficulty + 1];
                                                    ctx:spawnProjectileSpread(2, 9, (enemy).x, (enemy).y, boss08Angle((aim - 32768)), f32(0), (4 + (phase * 0.29999999999999999)), 1, count, ((count - 1) * 3333), 0);
                                                    ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end;
                    local destroyed = ((enemy).hp < 1);
                    if ((destroyed or ((parent).hp < 50001)) or ((parent).helperState > 9)) then
                        do
                            if destroyed then
                                do
                                    ctx:spawnEnemyDeathRewardBurst(enemy, 4000, false);
                                    ctx:spawnDelayedOwnerDamageNode((enemy).maxHp, (parent).entityId, (parent).spawnType, "S08 mount delayed-damage node 0x153");
                                    ctx:spawnPlayerSideObject(25, (enemy).x, (enemy).y, 0, (0 % 65536), 0, f32(0))
                                end
                            end;
                            ctx:spawnEnemyDeathEffects(enemy, 2, true);
                            (enemy).targetable = false;
                            (enemy).helperState = 2;
                            (enemy).helperTimer = 0
                        end
                    end
                end
            else
                do
                    (enemy).targetable = false
                end
            end;
            if (((parent).helperState > 19) or ((enemy).y >= f32(920))) then
                do
                    (enemy).active = false
                end
            end;
            goto __switch_end21
        end;
        ::__case41::;
        do
            local horizontalOrigin = f32((((ctx).player_).x / f32(6)));
            local activeTimer = timer;
            if ((enemy).helperState == 0) then
                do
                    (enemy).drawBodyThisFrame = false;
                    (enemy).drawMarkerThisFrame = true;
                    (enemy).markerDrawTimer = timer;
                    (enemy).markerDrawX = f32(cpp.clamp((enemy).x, f32((horizontalOrigin - f32(20))), f32((horizontalOrigin + f32(620)))));
                    (enemy).markerDrawY = f32(cpp.clamp((enemy).y, f32((-f32(20))), f32(740)));
                    if (timer < 20) then
                        goto __switch_end21
                    end;
                    (enemy).x = f32((enemy).markerDrawX);
                    (enemy).y = f32((enemy).markerDrawY);
                    (enemy).sourceAngle16 = (boss08Angle((14884 + math.fmod(boss08Rand((ctx).frame_), 3001))) % 65536);
                    (enemy).sourceSpeed = 6;
                    (enemy).speed = f32(f32(6));
                    (enemy).helperState = 1;
                    (enemy).helperTimer = 0;
                    activeTimer = 0;
                    (enemy).targetable = true;
                    (enemy).drawBodyThisFrame = true;
                    (enemy).drawMarkerThisFrame = false
                end
            end;
            if ((enemy).helperState == 1) then
                do
                    if (activeTimer < 200) then
                        do
                            (enemy).sourceAngle16 = (boss08Approach((enemy).sourceAngle16, (aimed)(), 255) % 65536)
                        end
                    end;
                    (enemy).sourceSpeed = ((enemy).sourceSpeed + 0.10000000000000001);
                    (enemy).speed = f32(f32((enemy).sourceSpeed));
                    (move)((enemy).sourceSpeed);
                    if (activeTimer < 200) then
                        do
                            local radians = boss08Radians((enemy).sourceAngle16);
                            local fireX = f32(((enemy).x + f32((math.cos(radians) * 20))));
                            local fireY = f32(((enemy).y + f32((math.sin(radians) * 20))));
                            if ((((fireX >= f32((horizontalOrigin + f32(40)))) and (fireX <= f32((horizontalOrigin + f32(560))))) and (fireY >= f32(40))) and (fireY <= f32(680))) then
                                do
                                    local kInterval = {18, 10, 6, 8, 6};
                                    local kSpeed = {6.5, 7.2000000000000002, 8, 8.5, 9.5};
                                    local interval = (kInterval)[difficulty + 1];
                                    if (activeTimer > 4) then
                                        do
                                            local phase = math.fmod((activeTimer - 5), (interval * 5));
                                            local dx = f32((((ctx).player_).x - fireX));
                                            local dy = f32((((ctx).player_).y - fireY));
                                            if (((phase < (interval * 3)) and (math.fmod(phase, interval) == 0)) and (f32((f32((dx * dx)) + f32((dy * dy)))) >= f32((f32(90) * f32(90))))) then
                                                do
                                                    local snapped = boss08Angle((bit.arshift((boss08AngleTo(fireX, fireY, ((ctx).player_).x, ((ctx).player_).y) + 1024), 11) * 2048));
                                                    local speed = (kSpeed)[difficulty + 1];
                                                    ctx:spawnProjectileNode(0, 0, fireX, fireY, snapped, f32(0), speed, 1, 0);
                                                    if (difficulty > 2) then
                                                        do
                                                            ctx:spawnProjectileNode(0, 0, fireX, fireY, boss08Angle((snapped - 2000)), f32(0), (speed - 1), 1, 0);
                                                            ctx:spawnProjectileNode(0, 0, fireX, fireY, boss08Angle((snapped + 2000)), f32(0), (speed - 1), 1, 0)
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
                    if (bit.band(activeTimer, 1) == 0) then
                        do
                            local radius = (math.sin(((activeTimer * kBoss08Pi) / 30)) * 4);
                            (spawnTwinTrail)(1, radius, (enemy).sourceAngle16)
                        end
                    end
                end
            end;
            if ((enemy).hp < 1) then
                do
                    ctx:spawnEnemyDeathRewardBurst(enemy, 200, false);
                    ctx:spawnEnemyDeathEffects(enemy, 0, true);
                    (enemy).active = false
                end
            end;
            if (((((enemy).x < f32((horizontalOrigin - f32(180)))) or ((enemy).x > f32((horizontalOrigin + f32(780))))) or ((enemy).y < f32((-f32(180))))) or ((enemy).y > f32(900))) then
                do
                    (enemy).active = false
                end
            end;
            goto __switch_end21
        end;
        ::__case42::;
        ::__case43::;
        do
            local horizontalOrigin = f32((((ctx).player_).x / f32(6)));
            if ((enemy).helperState ~= 0) then
                do
                    (enemy).active = false;
                    goto __switch_end21
                end
            end;
            (enemy).targetable = true;
            if (timer == 0) then
                do
                    (enemy).radius = 5
                end
            end;
            if (timer < 30) then
                do
                    (enemy).speed = f32(f32((math.sin(((timer * kBoss08Pi) / 60)) * 200)))
                end
            else
                if (timer > 59) then
                    do
                        (enemy).speed = f32(f32(((enemy).speed + f32(((timer - 60) * 0.14999999999999999)))))
                    end
                end
            end;
            (enemy).angle = f32(f32(((enemy).angle + f32(0.0500000007))));
            local turn = (function() if (timer < 60) then return (400 - trunc((math.sin(((timer * kBoss08Pi) / 120)) * 340))) else return 60 end end)();
            (enemy).sourceAngle16 = (boss08Angle(((enemy).sourceAngle16 + (function() if ((enemy).spawnType == 174) then return turn else return (-turn) end end)())) % 65536);
            local radians = boss08Radians((enemy).sourceAngle16);
            (enemy).x = f32(f32(((enemy).originX + f32((math.cos(radians) * (enemy).speed)))));
            (enemy).y = f32(f32(((enemy).originY + f32(((math.sin(radians) * (enemy).speed) * f32(0.5))))));
            local kInterval = {17, 11, 9, 10, 9};
            local kSpeed = {4, 5, 6, 5.5, 6.5};
            local interval = (kInterval)[difficulty + 1];
            if ((timer > 59) and (math.fmod((timer - 60), interval) == 0)) then
                do
                    local dx = f32((((ctx).player_).x - (enemy).x));
                    local dy = f32((((ctx).player_).y - (enemy).y));
                    if ((((((enemy).x >= horizontalOrigin) and ((enemy).x <= f32((horizontalOrigin + f32(600))))) and ((enemy).y >= f32(0))) and ((enemy).y <= f32(720))) and (f32((f32((dx * dx)) + f32((dy * dy)))) >= f32((f32(60) * f32(60))))) then
                        do
                            local sweep = ((timer * 80) - 4800);
                            local heading = boss08Angle(((enemy).sourceAngle16 + (function() if ((enemy).spawnType == 174) then return sweep else return (-sweep) end end)()));
                            local speed = (kSpeed)[difficulty + 1];
                            ctx:spawnProjectileNode(7, 2, (enemy).x, (enemy).y, heading, f32(0), speed, 1, 0);
                            ctx:spawnProjectileNode(7, 2, (enemy).x, (enemy).y, boss08Angle((heading - 32768)), f32(0), speed, 1, 0);
                            if (difficulty > 2) then
                                do
                                    ctx:spawnProjectileNode(7, 2, (enemy).x, (enemy).y, heading, f32(0), (speed + 1.2), 1, 0);
                                    ctx:spawnProjectileNode(7, 2, (enemy).x, (enemy).y, boss08Angle((heading - 32768)), f32(0), (speed + 1.2), 1, 0)
                                end
                            end;
                            ctx:playPlayerSound((ctx).bullet1SoundHandle_, 12)
                        end
                    end
                end
            end;
            if ((enemy).hp < 1) then
                do
                    ctx:spawnEnemyDeathRewardBurst(enemy, 300, false);
                    if (((ctx).player_).bombLock == 0) then
                        do
                            ctx:spawnDelayedOwnerDamageNode((enemy).maxHp, (parent).entityId, (parent).spawnType, "S08 spiral node delayed-damage node 0x153")
                        end
                    end;
                    ctx:spawnEnemyDeathEffects(enemy, 0, true);
                    (enemy).active = false
                end
            end;
            if ((((((parent).helperState > 9) or ((enemy).x < f32((horizontalOrigin - f32(200))))) or ((enemy).x > f32((horizontalOrigin + f32(800))))) or ((enemy).y < f32((-f32(200))))) or ((enemy).y > f32(920))) then
                do
                    (enemy).active = false
                end
            end;
            goto __switch_end21
        end;
        ::__case44::;
        ::__case45::;
        ::__case46::;
        ::__case47::;
        do
            local horizontalOrigin = f32((((ctx).player_).x / f32(6)));
            if ((enemy).helperState ~= 0) then
                do
                    (enemy).active = false;
                    goto __switch_end21
                end
            end;
            (enemy).targetable = true;
            local kNodeCount = {7, 7, 9, 9, 9};
            local kSlowTurn = {150, 180, 222, 222, 222};
            local kFastTurn = {330, 300, 300, 280, 280};
            if (timer == 0) then
                do
                    local count = (kNodeCount)[difficulty + 1];
                    (enemy).sourceAngle16 = (boss08Angle(((enemy).childIndex * trunc(65536 / count))) % 65536);
                    (enemy).speed = f32(f32(0));
                    (enemy).radius = 5
                end
            end;
            if (timer < 30) then
                do
                    (enemy).speed = f32(f32((math.sin(((timer * kBoss08Pi) / 60)) * 200)))
                end
            end;
            local reverse = (((enemy).spawnType == 177) or ((enemy).spawnType == 179));
            local turn = (function() if ((enemy).spawnType < 178) then return (kSlowTurn)[difficulty + 1] else return (kFastTurn)[difficulty + 1] end end)();
            (enemy).sourceSpeed = (function() if reverse then return (-turn) else return turn end end)();
            (enemy).sourceAngle16 = (boss08Angle(((enemy).sourceAngle16 + trunc((enemy).sourceSpeed))) % 65536);
            local parentPhase = (math.sin(((((parent).helperState * 257.00392156862745) * kBoss08Pi) / 32768)) * (function() if reverse then return (-2500) else return 2500 end end)());
            local phase = boss08Radians(boss08Angle(trunc(parentPhase)));
            local orbit = boss08Radians((enemy).sourceAngle16);
            local radius = (enemy).speed;
            (enemy).originX = f32(f32(0));
            (enemy).originY = f32(f32(0));
            (enemy).x = f32(f32(((parent).x + f32((((math.cos(phase) * math.cos(orbit)) * radius) - (((math.sin(phase) * math.sin(orbit)) * radius) * 0.5))))));
            (enemy).y = f32(f32(((parent).y + f32(((((math.cos(phase) * math.sin(orbit)) * radius) * 0.5) + ((math.sin(phase) * math.cos(orbit)) * radius))))));
            if ((enemy).spawnType < 178) then
                do
                    local kInterval = {20, 11, 9, 7, 6};
                    local kSpeed = {3, 4, 4.5, 5, 6};
                    local interval = (kInterval)[difficulty + 1];
                    if ((timer > 49) and (math.fmod((timer - 50), interval) == 0)) then
                        do
                            local speed = ((kSpeed)[difficulty + 1] + (timer * 0.0060000000000000001));
                            local first = boss08Angle(((enemy).sourceAngle16 - 2777));
                            ctx:spawnProjectileNode(1, 0, (enemy).x, (enemy).y, first, f32(0), speed, 1, 0);
                            ctx:spawnProjectileNode(1, 0, (enemy).x, (enemy).y, boss08Angle((first + 5555)), f32(0), speed, 1, 0);
                            ctx:playPlayerSound((ctx).bullet1SoundHandle_, 12)
                        end
                    end
                end
            else
                do
                    local kPeriod = {18, 11, 10, 11, 10};
                    local kActive = {3, 5, 5, 7, 7};
                    local kSpeed = {4.2000000000000002, 5, 5.5, 6, 7};
                    local phaseIndex = math.fmod((timer - 50), (kPeriod)[difficulty + 1]);
                    if (((timer > 49) and (phaseIndex >= 0)) and (phaseIndex < (kActive)[difficulty + 1])) then
                        do
                            ctx:spawnProjectileNode(1, 0, (enemy).x, (enemy).y, (enemy).sourceAngle16, f32(0), ((kSpeed)[difficulty + 1] + (phaseIndex * 0.25)), 1, 0);
                            ctx:playPlayerSound((ctx).bullet1SoundHandle_, 12)
                        end
                    end
                end
            end;
            if ((timer > 29) and (math.fmod((timer - 30), 72) == 0)) then
                do
                    local kRearSpeed = {3, 3.5, 4, 4, 4.5};
                    ctx:spawnProjectileNode(5, 2, (enemy).x, (enemy).y, boss08Angle(((enemy).sourceAngle16 - 32768)), f32(0), (kRearSpeed)[difficulty + 1], 1, 0)
                end
            end;
            if ((enemy).hp < 1) then
                do
                    ctx:spawnEnemyDeathRewardBurst(enemy, 300, false);
                    if (((ctx).player_).bombLock == 0) then
                        do
                            ctx:spawnDelayedOwnerDamageNode((enemy).maxHp, (parent).entityId, (parent).spawnType, "S08 orbit node delayed-damage node 0x153")
                        end
                    end;
                    ctx:spawnEnemyDeathEffects(enemy, 0, true);
                    (enemy).active = false
                end
            end;
            if ((((((timer == 250) or ((parent).helperState > 29)) or ((enemy).x < f32((horizontalOrigin - f32(200))))) or ((enemy).x > f32((horizontalOrigin + f32(800))))) or ((enemy).y < f32((-f32(200))))) or ((enemy).y > f32(920))) then
                do
                    (enemy).active = false
                end
            end;
            goto __switch_end21
        end;
        ::__case48::;
        ::__case49::;
        do
            if (((parent).hp < 1) or ((ctx).lateStageBossCountdown_ < 1)) then
                do
                    (enemy).active = false;
                    goto __switch_end21
                end
            end;
            local direction = (function() if ((enemy).spawnType == 180) then return 1 else return (-1) end end)();
            local radialPhase = ((cpp.clamp(timer, 0, 120) * kBoss08Pi) / 240);
            local horizontalRadius = f32((math.sin(radialPhase) * 150));
            local verticalRadius = f32((horizontalRadius * f32(0.5)));
            (enemy).sourceAngle16 = (boss08Angle(((enemy).sourceAngle16 + (direction * trunc((enemy).sourceSpeed)))) % 65536);
            (enemy).secondaryAngle16 = (boss08Angle(((enemy).secondaryAngle16 + (direction * 77))) % 65536);
            local tilt = boss08Radians((enemy).secondaryAngle16);
            local orbit = boss08Radians((enemy).sourceAngle16);
            local tiltCos = math.cos(tilt);
            local tiltSin = math.sin(tilt);
            local orbitCos = math.cos(orbit);
            local orbitSin = math.sin(orbit);
            (enemy).x = f32(f32((f32(((parent).x + (enemy).originX)) + f32((((tiltCos * orbitCos) * horizontalRadius) - ((tiltSin * orbitSin) * verticalRadius))))));
            (enemy).y = f32(f32((f32(((parent).y + (enemy).originY)) + f32((((tiltCos * orbitSin) * verticalRadius) + ((tiltSin * orbitCos) * horizontalRadius))))));
            (enemy).targetable = false;
            local interval = ({3, 2, 1, 1, 1})[difficulty + 1];
            if ((timer >= 50) and (math.fmod((timer - 50), interval) == 0)) then
                do
                    local selector = (function() if ((enemy).spawnType == 180) then return 13 else return 12 end end)();
                    ctx:spawnProjectileNode(selector, 1, (enemy).x, (enemy).y, (enemy).secondaryAngle16, f32(0), 0, 1, 0);
                    if (difficulty > 2) then
                        do
                            ctx:spawnProjectileNode(selector, 1, (enemy).x, (enemy).y, (enemy).secondaryAngle16, f32(0), 0.5, 1, 0)
                        end
                    end;
                    if (difficulty > 3) then
                        do
                            ctx:spawnProjectileNode(selector, 1, (enemy).x, (enemy).y, boss08Angle(((enemy).secondaryAngle16 - 32768)), f32(0), 0, 1, 0)
                        end
                    end;
                    local angleStep = ({3300, 2300, 2100, 2100, 2100})[difficulty + 1];
                    (enemy).secondaryAngle16 = (boss08Angle(((enemy).secondaryAngle16 + (direction * angleStep))) % 65536);
                    ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                end
            end;
            if (bit.band(timer, 1) == 0) then
                do
                    local appendageScale = 0;
                    if (timer >= 30) then
                        do
                            appendageScale = 1
                        end
                    else
                        if (timer >= 10) then
                            do
                                appendageScale = math.sin((((timer - 10) * kBoss08Pi) / 40))
                            end
                        end
                    end;
                    (spawnTrail)(5, (smallFrame)(137), 35, (enemy).x, (enemy).y, boss08Angle((timer * 777)), appendageScale, 16)
                end
            end;
            goto __switch_end21
        end;
        ::__case50::;
        do
            if (((parent).hp < 1) or ((ctx).lateStageBossCountdown_ < 1)) then
                do
                    (enemy).active = false;
                    goto __switch_end21
                end
            end;
            (enemy).targetable = true;
            if ((enemy).hp < 1) then
                do
                    ctx:spawnEnemyDeathRewardBurst(enemy, 300, false);
                    if (((ctx).player_).bombLock == 0) then
                        do
                            ctx:spawnDelayedOwnerDamageNode((enemy).maxHp, (parent).entityId, (parent).spawnType, "S08 launched node delayed-damage node 0x153")
                        end
                    end;
                    ctx:spawnEnemyDeathEffects(enemy, 0, true);
                    (enemy).active = false;
                    goto __switch_end21
                end
            end;
            local liveSpeed = 0;
            if (timer < 60) then
                do
                    liveSpeed = ((enemy).sourceSpeed * (1 - math.sin(((timer * kBoss08Pi) / 120))))
                end
            end;
            (move)(liveSpeed);
            local parentCycle = math.fmod((parent).helperTimer, 1600);
            local v_local = math.fmod(parentCycle, 350);
            local start = ({130, 110, 100, 100, 100})[difficulty + 1];
            local interval = ({150, 60, 50, 40, 40})[difficulty + 1];
            local count = ({3, 5, 7, 7, 9})[difficulty + 1];
            local shotSpeed = ({5, 6, 6.5, 7.5, 8.5})[difficulty + 1];
            if (((v_local >= start) and (v_local < 240)) and (math.fmod((v_local - start), interval) == 0)) then
                do
                    local spread = ((count - 1) * 360);
                    ctx:spawnProjectileSpread(13, 0, (enemy).x, (enemy).y, (aimed)(), f32(10), shotSpeed, 1, count, spread, 0);
                    if (difficulty > 2) then
                        do
                            ctx:spawnProjectileSpread(13, 0, (enemy).x, (enemy).y, (aimed)(), f32(10), (shotSpeed + 0.59999999999999998), 1, (count - 1), math.max(0, (spread - 360)), 0)
                        end
                    end;
                    ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                end
            end;
            if (timer == 200) then
                do
                    local ringCount = ({17, 25, 31, 23, 27})[difficulty + 1];
                    local ringSpeed = ({4.5, 5.5, 6, 6.5, 7.5})[difficulty + 1];
                    local selector = (function() if (difficulty > 2) then return 4 else return 2 end end)();
                    if (difficulty > 2) then
                        do
                            ctx:spawnProjectileSpread(4, 7, (enemy).x, (enemy).y, boss08Angle(((enemy).sourceAngle16 + trunc(65536 / (ringCount * 2)))), f32(0), (ringSpeed - 1), 1, ringCount, 65536, 0)
                        end
                    end;
                    ctx:spawnProjectileSpread(selector, 7, (enemy).x, (enemy).y, (enemy).sourceAngle16, f32(0), ringSpeed, 1, ringCount, 65536, 0);
                    (enemy).active = false
                end
            end;
            if (((((enemy).x < f32((-f32(150)))) or ((enemy).x > f32(870))) or ((enemy).y < f32((-f32(150))))) or ((enemy).y > f32(870))) then
                do
                    (enemy).active = false
                end
            end;
            goto __switch_end21
        end;
        ::__case51::;
        do
            if (((parent).hp < 1) or ((ctx).lateStageBossCountdown_ < 1)) then
                do
                    (enemy).active = false;
                    goto __switch_end21
                end
            end;
            (enemy).targetable = true;
            if ((enemy).hp < 1) then
                do
                    ctx:spawnEnemyDeathRewardBurst(enemy, 200, false);
                    if (((ctx).player_).bombLock == 0) then
                        do
                            ctx:spawnDelayedOwnerDamageNode((enemy).maxHp, (parent).entityId, (parent).spawnType, "S08 blade node delayed-damage node 0x153")
                        end
                    end;
                    ctx:spawnEnemyDeathEffects(enemy, 0, true);
                    (enemy).active = false;
                    goto __switch_end21
                end
            end;
            if ((enemy).helperState == 0) then
                do
                    local scale = (function() if (timer < 50) then return (0.20000000000000001 + (math.sin(((timer * kBoss08Pi) / 100)) * 0.80000000000000004)) else return 1 end end)();
                    (move)(((enemy).sourceSpeed * scale));
                    if (timer == 50) then
                        do
                            local horizontalOrigin = f32((((ctx).player_).x / f32(6)));
                            (enemy).x = f32(cpp.clamp((enemy).x, f32((horizontalOrigin - f32(20))), f32((horizontalOrigin + f32(620)))));
                            (enemy).y = f32(cpp.clamp((enemy).y, f32((-f32(20))), f32(740)));
                            (enemy).sourceSpeed = 8;
                            (enemy).sourceAngle16 = (boss08Angle((math.fmod(boss08Rand((ctx).frame_), 3001) + 14884)) % 65536);
                            (enemy).helperState = 1;
                            (enemy).helperTimer = 0
                        end
                    end
                end
            else
                if ((enemy).helperState == 1) then
                    do
                        (enemy).sourceSpeed = ((enemy).sourceSpeed + 0.10000000000000001);
                        (move)((enemy).sourceSpeed);
                        local interval = ({22, 15, 9, 7, 6})[difficulty + 1];
                        local shotSpeed = ({5, 6, 6.5, 7, 8.8000000000000007})[difficulty + 1];
                        local dx = f32((((ctx).player_).x - (enemy).x));
                        local dy = f32((((ctx).player_).y - (enemy).y));
                        if (((timer < 40) and (math.fmod(timer, interval) == 0)) and (((dx * dx) + (dy * dy)) >= (90 * 90))) then
                            do
                                local snapped = (bit.arshift(((aimed)() + 1024), 11) * 2048);
                                ctx:spawnProjectileNode(12, 0, (enemy).x, (enemy).y, boss08Angle(snapped), f32(0), shotSpeed, 1, 0);
                                if (difficulty > 2) then
                                    do
                                        ctx:spawnProjectileNode(12, 0, (enemy).x, (enemy).y, boss08Angle((snapped - 5550)), f32(0), (shotSpeed - 1), 1, 0);
                                        ctx:spawnProjectileNode(12, 0, (enemy).x, (enemy).y, boss08Angle((snapped + 5550)), f32(0), (shotSpeed - 1), 1, 0)
                                    end
                                end;
                                ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                            end
                        end
                    end
                end
            end;
            if (bit.band(timer, 1) == 0) then
                do
                    local scale = (function() if (((enemy).helperState == 0) and (timer < 50)) then return (0.20000000000000001 + (math.sin(((timer * kBoss08Pi) / 100)) * 0.80000000000000004)) else return 1 end end)();
                    local radius = ((math.sin(((timer * kBoss08Pi) / 30)) * 8) * scale);
                    (spawnTwinTrail)(scale, radius, (enemy).sourceAngle16)
                end
            end;
            if (((((enemy).x < f32((-f32(150)))) or ((enemy).x > f32(870))) or ((enemy).y < f32((-f32(150))))) or ((enemy).y > f32(870))) then
                do
                    (enemy).active = false
                end
            end;
            goto __switch_end21
        end;
        ::__case52::;
        do
            if ((parent).helperState >= 60) then
                do
                    if ((enemy).helperState ~= 9) then
                        do
                            (enemy).helperState = 9;
                            (enemy).helperTimer = 0;
                            goto __switch_end21
                        end
                    end;
                    (enemy).targetable = false;
                    if (timer >= 120) then
                        (enemy).active = false
                    end;
                    goto __switch_end21
                end
            end;
            local enterOffset = (function() if (timer < 30) then return f32((math.sin((((timer + 30) * kBoss08Pi) / 60)) * 600)) else return f32(0) end end)();
            (enemy).x = f32(f32(((parent).x + (enemy).originX)));
            (enemy).y = f32(f32((f32(((parent).y + (enemy).originY)) + enterOffset)));
            if (((enemy).helperState == 0) and (timer == 20)) then
                do
                    ctx:spawnStage08BossNode(parent, 185, 0, f32(0), f32((-f32(180))), (0 % 65536), 0, 99999999, 80, true)
                end
            end;
            if (((enemy).helperState == 0) and (timer == 50)) then
                do
                    ctx:spawnStage08BossNode(parent, 186, 0, f32(185), f32((-f32(60))), (16384 % 65536), 0, 99999999, 110, true);
                    ctx:spawnStage08BossNode(parent, 186, 1, f32((-f32(185))), f32((-f32(60))), (16384 % 65536), 0, 99999999, 110, true)
                end
            end;
            if (((parent).helperState == 52) and ((enemy).helperState == 0)) then
                do
                    (enemy).helperState = 1;
                    (enemy).helperTimer = 0
                end
            end;
            goto __switch_end21
        end;
        ::__case53::;
        do
            if ((parent).helperState >= 60) then
                do
                    if ((enemy).helperState ~= 9) then
                        do
                            (enemy).helperState = 9;
                            (enemy).helperTimer = 0;
                            goto __switch_end21
                        end
                    end;
                    (enemy).targetable = false;
                    if (timer >= 60) then
                        (enemy).active = false
                    end;
                    goto __switch_end21
                end
            end;
            local enterOffset = (function() if (timer < 30) then return f32((math.sin((((timer + 30) * kBoss08Pi) / 60)) * 600)) else return f32(0) end end)();
            (enemy).x = f32(f32(((parent).x + (enemy).originX)));
            (enemy).y = f32(f32((f32(((parent).y + (enemy).originY)) - enterOffset)));
            if (((parent).helperState == 52) and ((enemy).helperState == 0)) then
                do
                    ctx:spawnSharedHitboxProxy(enemy, 338, f32(145), f32((-f32(50))), 90);
                    ctx:spawnSharedHitboxProxy(enemy, 338, f32((-f32(145))), f32((-f32(50))), 90);
                    (enemy).helperState = 1;
                    (enemy).helperTimer = 0
                end
            end;
            if ((enemy).helperState == 1) then
                do
                    if ((enemy).hp > (parent).hp) then
                        (enemy).hp = (parent).hp
                    end;
                    if ((enemy).hp < (parent).hp) then
                        (parent).hp = (enemy).hp
                    end;
                    (enemy).targetable = true;
                    local phaseTimer = (enemy).helperTimer;
                    local cycle = (function() if (phaseTimer >= 100) then return math.fmod((phaseTimer - 100), 1800) else return (-1) end end)();
                    local rightX = f32(((enemy).x + f32(135)));
                    local leftX = f32(((enemy).x - f32(135)));
                    local fireY = f32(((enemy).y - f32(15)));
                    if ((cycle >= 0) and (cycle < 550)) then
                        do
                            local interval = ({14, 11, 9, 10, 9})[difficulty + 1];
                            if (math.fmod(cycle, interval) == 0) then
                                do
                                    local rows = (function() if (difficulty == 0) then return 3 else return 5 end end)();
                                    local speed = (({3.5, 4.5, 4.5, 5, 6.5999999999999996})[difficulty + 1] + (cycle * 0.0050000000000000001));
                                    local rightAim = boss08AngleTo(rightX, fireY, ((ctx).player_).x, ((ctx).player_).y);
                                    local leftAim = boss08AngleTo(leftX, fireY, ((ctx).player_).x, ((ctx).player_).y);
                                    do
                                        local i = 0
                                        while (i < rows) do
                                            do
                                                local offset = (function() if (rows == 1) then return 0 else return ((-10000) + (i * trunc(20000 / (rows - 1)))) end end)();
                                                ctx:spawnProjectileNode(4, 0, rightX, fireY, boss08Angle((rightAim + offset)), f32(0), speed, 1, 0);
                                                ctx:spawnProjectileNode(4, 0, leftX, fireY, boss08Angle((leftAim - offset)), f32(0), speed, 1, 0);
                                                if (difficulty > 2) then
                                                    do
                                                        ctx:spawnProjectileNode(4, 0, rightX, fireY, boss08Angle((rightAim + offset)), f32(0), (speed + 0.59999999999999998), 1, 0);
                                                        ctx:spawnProjectileNode(4, 0, leftX, fireY, boss08Angle((leftAim - offset)), f32(0), (speed + 0.59999999999999998), 1, 0)
                                                    end
                                                end
                                            end
                                            ::__continue55::
                                            i = i + 1
                                        end
                                        ::__loop_end54::
                                    end;
                                    ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                                end
                            end
                        end
                    else
                        if ((cycle >= 720) and (cycle < 1250)) then
                            do
                                local interval = ({90, 60, 48, 32, 27})[difficulty + 1];
                                if (math.fmod((cycle - 720), interval) == 0) then
                                    do
                                        local speed = ({5, 6, 7, 8, 9})[difficulty + 1];
                                        do

                                            for _, fireX in ipairs({leftX, rightX}) do
                                                do
                                                    local center = boss08AngleTo(fireX, fireY, ((ctx).player_).x, ((ctx).player_).y);
                                                    do

                                                        for _, offset in ipairs({(-1111), 0, 1111}) do
                                                            do
                                                                ctx:spawnProjectileNode(13, 0, fireX, fireY, boss08Angle((center + offset)), f32(0), (speed - (function() if (offset == 0) then return 0 else return 0.59999999999999998 end end)()), 1, 0)
                                                            end
                                                            ::__continue59::
                                                        end
                                                        ::__loop_end58::
                                                    end
                                                end
                                                ::__continue57::
                                            end
                                            ::__loop_end56::
                                        end;
                                        ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                                    end
                                end
                            end
                        else
                            if ((cycle >= 1300) and (cycle < 1740)) then
                                do
                                    local count = ({4, 5, 6, 8, 9})[difficulty + 1];
                                    local interval = ({5, 4, 4, 4, 3})[difficulty + 1];
                                    if (math.fmod((cycle - 1300), (interval * 2)) == 0) then
                                        do
                                            local speed = ({4.5, 5, 5, 5, 6.5})[difficulty + 1];
                                            ctx:spawnProjectileSpread(4, 0, rightX, fireY, (enemy).secondaryAngle16, f32(0), speed, 1, count, 65536, 0);
                                            ctx:spawnProjectileSpread(4, 0, leftX, fireY, (enemy).targetAngle16, f32(0), speed, 1, count, 65536, 0);
                                            ctx:playPlayerSound((ctx).bullet1SoundHandle_, 12)
                                        end
                                    end;
                                    local step = ({240, 240, 220, 200, 220})[difficulty + 1];
                                    (enemy).secondaryAngle16 = (boss08Angle(((enemy).secondaryAngle16 - step)) % 65536);
                                    (enemy).targetAngle16 = (boss08Angle(((enemy).targetAngle16 + step)) % 65536)
                                end
                            end
                        end
                    end
                end
            end;
            goto __switch_end21
        end;
        ::__case60::;
        do
            local left = ((enemy).originX < f32(0));
            if ((parent).helperState >= 60) then
                do
                    if ((enemy).helperState ~= 9) then
                        do
                            (enemy).helperState = 9;
                            (enemy).helperTimer = 0;
                            goto __switch_end21
                        end
                    end;
                    (enemy).targetable = false;
                    local v_end = (function() if left then return 100 else return 80 end end)();
                    if (timer >= v_end) then
                        (enemy).active = false
                    end;
                    goto __switch_end21
                end
            end;
            local enterOffset = (function() if (timer < 30) then return f32((math.sin((((timer + 30) * kBoss08Pi) / 60)) * (function() if left then return (-600) else return 600 end end)())) else return f32(0) end end)();
            (enemy).x = f32(f32((f32(((parent).x + (enemy).originX)) + enterOffset)));
            (enemy).y = f32(f32(((parent).y + (enemy).originY)));
            if (((parent).helperState == 51) and (timer < 30)) then
                do
                    local trailAngle = boss08Angle(((enemy).sourceAngle16 + (function() if left then return 32768 else return 0 end end)()));
                    (spawnTrail)((function() if left then return 7 else return 5 end end)(), (smallFrame)(136), 29, (enemy).x, (enemy).y, trailAngle, 1, 16)
                end
            end;
            if (((parent).helperState == 52) and ((enemy).helperState == 0)) then
                do
                    ctx:spawnStage08BossNode(parent, 187, (enemy).childIndex, (enemy).originX, (enemy).originY, ((function() if left then return 63036 else return 2500 end end)() % 65536), 0, 40000, 50, true);
                    (enemy).helperState = 1;
                    (enemy).helperTimer = 0
                end
            end;
            if ((enemy).helperState == 1) then
                do
                    if ((enemy).hp > (parent).hp) then
                        (enemy).hp = (parent).hp
                    end;
                    if ((enemy).hp < (parent).hp) then
                        (parent).hp = (enemy).hp
                    end;
                    (enemy).targetable = true;
                    local phaseTimer = (enemy).helperTimer;
                    local cycle = (function() if (phaseTimer >= 100) then return math.fmod((phaseTimer - 100), 1800) else return (-1) end end)();
                    if ((cycle >= 600) and (cycle < 1250)) then
                        do
                            local fanCount = ({7, 7, 9, 11, 11})[difficulty + 1];
                            local groups = (function() if (difficulty == 0) then return 9 else return 11 end end)();
                            local interval = ({44, 33, 33, 33, 27})[difficulty + 1];
                            local phase = (cycle - 600);
                            local slot = math.fmod(phase, (interval * 10));
                            if ((slot < (interval * 4)) and (math.fmod(slot, interval) == 0)) then
                                do
                                    local speed = (({3.5, 4.5, 5, 5, 6})[difficulty + 1] + ((cycle - 600) * 0.0040000000000000001));
                                    do
                                        local i = 0
                                        while (i < groups) do
                                            do
                                                local center = boss08Angle(((enemy).secondaryAngle16 + (i * trunc(65536 / groups))));
                                                ctx:spawnProjectileSpread(4, 0, (enemy).x, (enemy).y, center, f32(0), speed, 1, fanCount, ((fanCount - 1) * 360), 0);
                                                if (difficulty > 2) then
                                                    do
                                                        ctx:spawnProjectileSpread(4, 0, (enemy).x, (enemy).y, center, f32(0), (speed + 0.5), 1, fanCount, math.max(0, ((fanCount - 2) * 360)), 0)
                                                    end
                                                end
                                            end
                                            ::__continue62::
                                            i = i + 1
                                        end
                                        ::__loop_end61::
                                    end;
                                    local turn = trunc(65536 / (fanCount * 3));
                                    (enemy).secondaryAngle16 = (boss08Angle(((enemy).secondaryAngle16 + (function() if left then return (-turn) else return turn end end)())) % 65536);
                                    ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                                end
                            end
                        end
                    else
                        if ((cycle >= 1300) and (cycle < 1740)) then
                            do
                                local count = ({3, 4, 5, 7, 8})[difficulty + 1];
                                local interval = ({6, 5, 5, 5, 4})[difficulty + 1];
                                if ((((cycle - 1300) - (function() if left then return interval else return 0 end end)()) >= 0) and (math.fmod(((cycle - 1300) - (function() if left then return interval else return 0 end end)()), (interval * 2)) == 0)) then
                                    do
                                        local speed = ({4, 5, 5.5, 6, 7})[difficulty + 1];
                                        ctx:spawnProjectileSpread(2, 0, (enemy).x, (enemy).y, (enemy).secondaryAngle16, f32(0), speed, 1, count, 65536, 0);
                                        ctx:playPlayerSound((ctx).bullet1SoundHandle_, 12)
                                    end
                                end;
                                local step = ({220, 220, 200, 180, 210})[difficulty + 1];
                                (enemy).secondaryAngle16 = (boss08Angle(((enemy).secondaryAngle16 + (function() if left then return step else return (-step) end end)())) % 65536)
                            end
                        end
                    end
                end
            end;
            goto __switch_end21
        end;
        ::__case63::;
        if ((parent).helperState ~= 52) then
            do
                (enemy).active = false;
                goto __switch_end21
            end
        end;
        do
            local wing = nil;
            do

                for _, candidate in ipairs((ctx).enemies_) do
                    do
                        if ((((candidate).active and ((candidate).spawnType == 186)) and ((candidate).parentEntityId == (parent).entityId)) and ((candidate).childIndex == (enemy).childIndex)) then
                            do
                                wing = candidate;
                                goto __loop_end64
                            end
                        end
                    end
                    ::__continue65::
                end
                ::__loop_end64::
            end;
            if (wing == nil) then
                do
                    (enemy).active = false;
                    goto __switch_end21
                end
            end;
            (enemy).targetable = true;
            local orbitAngle = boss08Angle(((wing).sourceAngle16 + (enemy).secondaryAngle16));
            (enemy).x = f32(f32(((wing).x + f32((math.cos(boss08Radians(orbitAngle)) * 170)))));
            (enemy).y = f32(f32(((wing).y + f32((math.sin(boss08Radians(orbitAngle)) * 170)))));
            local cycle = math.fmod((wing).helperTimer, 300);
            if (cycle == 1) then
                do
                    local pulse = (mediumEffectFrame)(20);
                    ctx:spawnStageEffect(65, pulse, 0, 80, (enemy).x, (enemy).y, (enemy).sourceAngle16, 0, 0.59999999999999998, 0.59999999999999998, 100, 255, 255, 255, 128, (enemy).entityId);
                    ctx:playPlayerSound((ctx).bossSe2SecondSoundHandle_, 25);
                    (enemy).sourceAngle16 = ((wing).sourceAngle16 % 65536)
                end
            end;
            if (cycle <= 50) then
                do
                    (enemy).sourceAngle16 = (boss08Approach((enemy).sourceAngle16, (aimed)(), 48) % 65536)
                end
            end;
            if ((enemy).hp < 1) then
                do
                    ctx:spawnEnemyDeathRewardBurst(enemy, 4000, false);
                    ctx:spawnDelayedOwnerDamageNode((enemy).maxHp, (parent).entityId, (parent).spawnType, "S08 wing controller delayed-damage node 0x153");
                    ctx:spawnPlayerSideObject(25, (enemy).x, (enemy).y, 0, (0 % 65536), 0, f32(0));
                    ctx:spawnEnemyDeathEffects(enemy, 2, true);
                    (enemy).active = false;
                    goto __switch_end21
                end
            end;
            if (((cycle >= 100) and (cycle < 300)) and (math.fmod((cycle - 100), 3) == 0)) then
                do
                    local spread = (function() if (cycle < 160) then return 0 else return ((cycle - 160) * ({0, 30, 50, 80, 100})[difficulty + 1]) end end)();
                    ctx:spawnProjectileSpread(3, 0, (enemy).x, (enemy).y, (enemy).sourceAngle16, f32(10), 12, 1, 4, spread, 0);
                    ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                end
            end
        end;
        goto __switch_end21;
        ::__case66::;
        ::__case67::;
        ::__case68::;
        ::__case69::;
        ::__case70::;
        ::__case71::;
        ::__case72::;
        do
            local nodeTimer = timer;
            local fireBaseX = (enemy).x;
            local fireBaseY = (enemy).y;
            local fireAngle = (enemy).sourceAngle16;
            local fireX = f32((fireBaseX + f32((math.cos(boss08Radians(fireAngle)) * 20))));
            local fireY = f32((fireBaseY + f32((math.sin(boss08Radians(fireAngle)) * 20))));
            local homeTowardPlayer = function()
                local target = (aimed)();
                local delta = (target - (enemy).sourceAngle16);
                if (delta > 32768) then
                    delta = (delta - 65536)
                end;
                if (delta < (-32768)) then
                    delta = (delta + 65536)
                end;
                local step = (trunc(math.abs(delta) / 10) + 48);
                (enemy).sourceAngle16 = (boss08Approach((enemy).sourceAngle16, target, step) % 65536)
            end;
            local family = cpp.clamp((function() if ((parent).helperState >= 65) then return ((parent).helperState - 65) else return ((parent).helperState - 62) end end)(), 0, 2);
            local familySpeed = (family * 0.5);
            if ((enemy).helperState == 0) then
                do
                    (homeTowardPlayer)();
                    local entranceSpeed = (((enemy).sourceSpeed - (((enemy).sourceSpeed * nodeTimer) / 60)) + 0.5);
                    (move)(entranceSpeed);
                    if (nodeTimer == 60) then
                        do
                            (enemy).helperState = 1;
                            (enemy).helperTimer = 0;
                            (enemy).sourceSpeed = 0.5;
                            nodeTimer = 0
                        end
                    else
                        if (bit.band(nodeTimer, 1) == 0) then
                            do
                                local wave = math.sin(((nodeTimer * kBoss08Pi) / 120));
                                local scale = (0.20000000000000001 + (wave * 0.80000000000000004));
                                local entranceTurn = (-trunc((wave * 131072)));
                                local bladeAngle = boss08Angle(((enemy).secondaryAngle16 + entranceTurn));
                                (spawnTwinTrail)(scale, ((-4) * scale), bladeAngle)
                            end
                        end
                    end
                end
            end;
            if ((enemy).helperState == 1) then
                do
                    (move)((enemy).sourceSpeed);
                    local duration = 40;
                    local fired = false;
                    do
                        local __switch74 = (enemy).spawnType
                        if __switch74 == 188 then goto __case75
                        elseif __switch74 == 189 then goto __case76
                        elseif __switch74 == 190 then goto __case77
                        elseif __switch74 == 191 then goto __case82
                        elseif __switch74 == 192 then goto __case87
                        elseif __switch74 == 193 then goto __case88
                        elseif __switch74 == 194 then goto __case89
                        else goto __case90 end
                        ::__case75::;
                        do
                            duration = 50;
                            (homeTowardPlayer)();
                            local v_local = (nodeTimer - 5);
                            if (((v_local >= 0) and (v_local < 45)) and (math.fmod(v_local, 18) == 0)) then
                                do
                                    local baseCount = ({2, 3, 4, 5, 7})[difficulty + 1];
                                    local count = (baseCount + trunc(v_local / 18));
                                    local step = ({4200, 3300, 3000, 2700, 2400})[difficulty + 1];
                                    local speed = (({4.5, 5.5, 6, 6.5, 7.5})[difficulty + 1] + familySpeed);
                                    ctx:spawnProjectileSpread(12, 0, fireX, fireY, (enemy).sourceAngle16, f32(0), speed, 1, count, ((count - 1) * step), 0);
                                    fired = true
                                end
                            end;
                            goto __switch_end73
                        end;
                        ::__case76::;
                        do
                            duration = 20;
                            (homeTowardPlayer)();
                            if (nodeTimer == 5) then
                                do
                                    local count = ({17, 25, 29, 25, 29})[difficulty + 1];
                                    local speed = (({5, 6, 6.5, 7, 8})[difficulty + 1] + familySpeed);
                                    ctx:spawnProjectileSpread(3, 0, fireX, fireY, (enemy).sourceAngle16, f32(0), speed, 1, count, 65536, 0);
                                    if (difficulty > 2) then
                                        do
                                            ctx:spawnProjectileSpread(3, 0, fireX, fireY, boss08Angle(((enemy).sourceAngle16 + trunc(65536 / (count * 2)))), f32(0), (speed - 1.2), 1, count, 65536, 0)
                                        end
                                    end;
                                    fired = true
                                end
                            end;
                            goto __switch_end73
                        end;
                        ::__case77::;
                        do
                            duration = 30;
                            if (nodeTimer < 5) then
                                (homeTowardPlayer)()
                            end;
                            if (((nodeTimer >= 5) and (nodeTimer < 30)) and (math.fmod((nodeTimer - 5), 4) == 0)) then
                                do
                                    local speed = (({7.4000000000000004, 8.1999999999999993, 9, 9, 10})[difficulty + 1] + familySpeed);
                                    ctx:spawnProjectileNode(7, 0, fireX, fireY, (enemy).sourceAngle16, f32(0), speed, 1, 0);
                                    if (difficulty > 0) then
                                        do
                                            do

                                                for _, offset in ipairs({(-350), 350}) do
                                                    do
                                                        ctx:spawnProjectileNode(7, 0, fireX, fireY, boss08Angle(((enemy).sourceAngle16 + offset)), f32(0), (speed - 0.40000000000000002), 1, 0)
                                                    end
                                                    ::__continue79::
                                                end
                                                ::__loop_end78::
                                            end
                                        end
                                    end;
                                    if (difficulty > 2) then
                                        do
                                            do

                                                for _, offset in ipairs({(-700), 700}) do
                                                    do
                                                        ctx:spawnProjectileNode(7, 0, fireX, fireY, boss08Angle(((enemy).sourceAngle16 + offset)), f32(0), (speed - 0.80000000000000004), 1, 0)
                                                    end
                                                    ::__continue81::
                                                end
                                                ::__loop_end80::
                                            end
                                        end
                                    end;
                                    fired = true
                                end
                            end;
                            goto __switch_end73
                        end;
                        ::__case82::;
                        do
                            duration = 20;
                            (homeTowardPlayer)();
                            if (nodeTimer == 5) then
                                do
                                    local count = ({5, 7, 9, 9, 11})[difficulty + 1];
                                    local speed = (({4, 5, 5.5, 6, 7})[difficulty + 1] + familySpeed);
                                    do

                                        for _, offset in ipairs({0, 8000, (-8000)}) do
                                            do
                                                ctx:spawnProjectileSpread(5, 0, fireX, fireY, boss08Angle(((enemy).sourceAngle16 + offset)), f32(0), speed, 1, count, ((count - 1) * 400), 0)
                                            end
                                            ::__continue84::
                                        end
                                        ::__loop_end83::
                                    end;
                                    if (difficulty > 2) then
                                        do
                                            do

                                                for _, offset in ipairs({0, 8000, (-8000)}) do
                                                    do
                                                        ctx:spawnProjectileSpread(5, 0, fireX, fireY, boss08Angle(((enemy).sourceAngle16 + offset)), f32(0), (speed + 0.5), 1, (count - 1), ((count - 2) * 400), 0)
                                                    end
                                                    ::__continue86::
                                                end
                                                ::__loop_end85::
                                            end
                                        end
                                    end;
                                    fired = true
                                end
                            end;
                            goto __switch_end73
                        end;
                        ::__case87::;
                        do
                            duration = 60;
                            if (nodeTimer < 5) then
                                (homeTowardPlayer)()
                            end;
                            local interval = ({8, 5, 4, 4, 4})[difficulty + 1];
                            if (((nodeTimer >= 5) and (nodeTimer < 60)) and (math.fmod((nodeTimer - 5), interval) == 0)) then
                                do
                                    local spread = (((nodeTimer - 5) * 700) + ({4200, 3600, 3300, 3000, 3000})[difficulty + 1]);
                                    local speed = ((({5.5, 6.2000000000000002, 6.5999999999999996, 6.5999999999999996, 7.5})[difficulty + 1] - ((nodeTimer - 5) * 0.050000000000000003)) + familySpeed);
                                    ctx:spawnProjectileSpread(11, 0, fireX, fireY, (enemy).sourceAngle16, f32(0), speed, 1, 2, spread, 0);
                                    if (difficulty > 2) then
                                        do
                                            ctx:spawnProjectileSpread(11, 0, fireX, fireY, (enemy).sourceAngle16, f32(0), (speed + 1), 1, 2, (spread + (interval * 400)), 0)
                                        end
                                    end;
                                    fired = true
                                end
                            end;
                            goto __switch_end73
                        end;
                        ::__case88::;
                        do
                            duration = 80;
                            (homeTowardPlayer)();
                            local interval = ({20, 16, 14, 12, 10})[difficulty + 1];
                            local v_local = (nodeTimer - 5);
                            if (((v_local >= 0) and (v_local < 75)) and (math.fmod(v_local, interval) == 0)) then
                                do
                                    local volley = trunc(v_local / interval);
                                    local spreadStep = ({3300, 2600, 2300, 2000, 1800})[difficulty + 1];
                                    local speed = ({5.5, 6.5, 7, 7.5, 8.5})[difficulty + 1];
                                    local quantized = boss08Angle((bit.arshift(((enemy).sourceAngle16 + 1024), 11) * 2048));
                                    ctx:spawnProjectileSpread(8, 0, fireX, fireY, quantized, f32(0), speed, 1, (volley + 1), (volley * spreadStep), 0);
                                    fired = true
                                end
                            end;
                            goto __switch_end73
                        end;
                        ::__case89::;
                        do
                            duration = 20;
                            (homeTowardPlayer)();
                            if (nodeTimer == 5) then
                                do
                                    local count = ({9, 13, 15, 17, 19})[difficulty + 1];
                                    local speed = ({7, 8.5, 10, 8, 9})[difficulty + 1];
                                    local spread = ((count - 1) * 2550);
                                    ctx:spawnProjectileSpread(2, 9, fireX, fireY, (enemy).sourceAngle16, f32(0), speed, 1, count, spread, 0);
                                    if (difficulty > 2) then
                                        do
                                            ctx:spawnProjectileSpread(2, 9, fireX, fireY, boss08Angle(((enemy).sourceAngle16 + trunc(65536 / (count * 2)))), f32(0), (speed + 4), 1, count, spread, 0)
                                        end
                                    end;
                                    fired = true
                                end
                            end;
                            goto __switch_end73
                        end;
                        ::__case90::;
                        goto __switch_end73
                        ::__switch_end73::
                    end;
                    if fired then
                        ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                    end;
                    if (nodeTimer == duration) then
                        do
                            (enemy).helperState = 2;
                            (enemy).helperTimer = 0
                        end
                    end
                end
            else
                if (((enemy).helperState == 2) and (nodeTimer >= 40)) then
                    do
                        (enemy).active = false
                    end
                end
            end;
            if (((((parent).helperState < 62) or ((parent).helperState > 67)) or ((parent).hp < 1)) or ((ctx).lateStageBossCountdown_ < 1)) then
                do
                    (enemy).active = false
                end
            end;
            goto __switch_end21
        end;
        ::__case91::;
        do
            (enemy).x = f32((parent).x);
            (enemy).y = f32((parent).y);
            (enemy).sourceAngle16 = (boss08Angle(((ctx).frame_ * 384)) % 65536);
            if (((enemy).helperState == 0) and (timer == 0)) then
                do
                    local randomHundredth = function(seed, minimum, steps)
                        do return (minimum + (math.fmod(boss08Rand(seed), u32(steps)) / 100)) end
                    end;
                    local particle = (function() if ((#(ctx).playerFrames_) > 14) then return ((ctx).playerFrames_)[14 + 1] else return (-1) end end)();
                    do
                        local index = 0
                        while (index < 32) do
                            do
                                local angle = boss08Angle(math.fmod(boss08Rand(((ctx).frame_ + (index * 88))), 65537));
                                local scale = (randomHundredth)(((ctx).frame_ + (index * 8888)), 1.1000000000000001, 111);
                                local speed = (randomHundredth)(((ctx).frame_ + (index * 888)), 16, 901);
                                ctx:spawnStageEffect(44, particle, 0, 72, (enemy).x, (enemy).y, angle, speed, scale, scale, 0, 255, 255, 255, 192, 0)
                            end
                            ::__continue93::
                            index = index + 1
                        end
                        ::__loop_end92::
                    end
                end
            end;
            if (((enemy).helperState == 0) and (((parent).helperState < 65) or ((parent).helperState > 67))) then
                do
                    (enemy).helperState = 1;
                    (enemy).helperTimer = 0
                end
            else
                if (((enemy).helperState == 1) and (timer >= 16)) then
                    do
                        (enemy).active = false
                    end
                end
            end;
            goto __switch_end21
        end;
        ::__case94::;
        (enemy).active = false;
        goto __switch_end21
        ::__switch_end21::
    end;
    (enemy).drawHp = (enemy).hp
end

M.updateStage08Boss = function(ctx, enemy)
    local timer = (enemy).helperTimer;
    local state = (enemy).helperState;
    local openPhase = function(nextState, hp, countdown, phaseIndex)
        (enemy).helperState = nextState;
        (enemy).helperTimer = 0;
        (enemy).hp = hp;
        (enemy).maxHp = hp;
        (enemy).drawHp = hp;
        (enemy).targetable = true;
        (enemy).targetableTimer = 0;
        (ctx).lateStageBossMaxHp_ = hp;
        (ctx).lateStageBossCountdown_ = countdown;
        (ctx).lateStageBossCountdownDraw_ = countdown;
        (ctx).lateStageBossPhaseIndex_ = phaseIndex;
        (ctx).lateStageBossPhaseMode_ = 1
    end;
    local beginBreak = function(nextState)
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
        ctx:spawnBossPhaseBreakFeedback(enemy, (ctx).lateStageBossCountdown_);
        ctx:spawnPostDeathCounterEntity(enemy, 140);
        (enemy).targetable = false;
        (enemy).targetableTimer = 0;
        (enemy).helperState = nextState;
        (enemy).helperTimer = 0;
        (enemy).liveChildCount = 0;
        (ctx).lateStageBossPhaseMode_ = 2;
        (ctx).lateStageBossPhaseIndex_ = (ctx).lateStageBossPhaseIndex_ + 1
    end;
    local startBoss3 = function()
        if ((ctx).activeBossBgmIndex_ == 2) then
            do return end
        end;
        if (((ctx).bossBgmHandles_)[1 + 1] ~= (-1)) then
            ctx:audio("StopSoundMem", ((ctx).bossBgmHandles_)[1 + 1])
        end;
        (ctx).activeBossBgmIndex_ = 2;
        if (((ctx).bossBgmHandles_)[2 + 1] ~= (-1)) then
            do
                ctx:audio("ChangeVolumeSoundMem", trunc((((ctx).config_).bgmVolume * 25.5)), ((ctx).bossBgmHandles_)[2 + 1]);
                ctx:audio("PlaySoundMem", ((ctx).bossBgmHandles_)[2 + 1], DX_PLAYTYPE_LOOP, TRUE)
            end
        end
    end;
    if ((state >= 62) and (state <= 64)) then
        do
            local specialActive = ((((ctx).player_).bombLock > 0) or (((ctx).player_).bombLock < (-100)));
            if specialActive then
                do
                    ctx:spawnStage08BossNode(enemy, 195, 0, f32(0), f32(0), (0 % 65536), 0, 99999999, 20, true);
                    (enemy).helperState = ((enemy).helperState + 3);
                    state = (enemy).helperState;
                    (enemy).targetable = false
                end
            end
        end
    else
        if ((state >= 65) and (state <= 67)) then
            do
                if (((ctx).player_).invulnerableFrames < 61) then
                    do
                        (enemy).helperState = ((enemy).helperState - 3);
                        state = (enemy).helperState;
                        (enemy).targetable = true
                    end
                else
                    do
                        (enemy).targetable = false
                    end
                end
            end
        end
    end;
    if ((boss08CombatState(state) and ((ctx).lateStageBossPhaseMode_ == 1)) and (((enemy).hp < 1) or ((ctx).lateStageBossCountdown_ < 1))) then
        do
            local nextState = 70;
            if (state >= 62) then
                do
                    (ctx).lateStageBossBreaksRemaining_ = 0;
                    (ctx).lateStageBossPhaseMode_ = (-1);
                    (ctx).lateStageClearStarted_ = true;
                    (ctx).lateStageClearTimer_ = 0;
                    ((ctx).player_).invulnerableFrames = math.max(((ctx).player_).invulnerableFrames, 360)
                end
            else
                do
                    do
                        local __switch96 = (ctx).lateStageBossBreaksRemaining_
                        if __switch96 == 6 then goto __case97
                        elseif __switch96 == 5 then goto __case98
                        elseif __switch96 == 4 then goto __case99
                        elseif __switch96 == 3 then goto __case100
                        elseif __switch96 == 2 then goto __case101
                        elseif __switch96 == 1 then goto __case102
                        else goto __case103 end
                        ::__case97::;
                        nextState = 10;
                        goto __switch_end95;
                        ::__case98::;
                        nextState = 20;
                        goto __switch_end95;
                        ::__case99::;
                        nextState = 30;
                        goto __switch_end95;
                        ::__case100::;
                        nextState = 40;
                        goto __switch_end95;
                        ::__case101::;
                        nextState = 50;
                        goto __switch_end95;
                        ::__case102::;
                        nextState = 60;
                        goto __switch_end95;
                        ::__case103::;
                        nextState = 70;
                        goto __switch_end95
                        ::__switch_end95::
                    end;
                    (ctx).lateStageBossBreaksRemaining_ = math.max(0, ((ctx).lateStageBossBreaksRemaining_ - 1))
                end
            end;
            (beginBreak)(nextState);
            if ((nextState == 60) or (nextState == 70)) then
                do
                    (ctx).lateStageBossPhaseMode_ = (-1)
                end
            end;
            do return end
        end
    end;
    if boss08CombatState(state) then
        do
            if (math.fmod((ctx).frame_, 50) == 0) then
                do
                    (ctx).lateStageBossTargetX_ = f32(f32((f32(210) + f32(math.fmod(boss08Rand((ctx).frame_), 301)))));
                    local targetYBase = f32(150);
                    if (state == 11) then
                        targetYBase = f32(f32(180))
                    else
                        if ((state >= 51) and (state <= 59)) then
                            targetYBase = f32(f32(130))
                        else
                            if ((state >= 61) and (state <= 69)) then
                                targetYBase = f32(f32(200))
                            end
                        end
                    end;
                    (ctx).lateStageBossTargetY_ = f32(f32((targetYBase + f32(math.fmod(boss08Rand(((ctx).frame_ + ((ctx).selectedStage_ * 222))), 101)))))
                end
            end;
            local target = boss08AngleTo((enemy).x, (enemy).y, (ctx).lateStageBossTargetX_, (ctx).lateStageBossTargetY_);
            (enemy).sourceAngle16 = (boss08Approach((enemy).sourceAngle16, target, 512) % 65536);
            local radians = boss08Radians((enemy).sourceAngle16);
            local speed = (function() if (state >= 62) then return 0.34999999999999998 else return 0.29999999999999999 end end)();
            (enemy).x = f32(f32(((enemy).x + f32((math.cos(radians) * speed)))));
            (enemy).y = f32(f32(((enemy).y + f32((math.sin(radians) * speed)))));
            ctx:emitStage08BossProjectiles(enemy);
            if ((state == 1) and ((enemy).hp <= 50000)) then
                do
                    ctx:spawnPlayerSideObject(24, (enemy).x, (enemy).y, 0, (0 % 65536), 0, f32(0));
                    ctx:spawnEnemyDeathEffects(enemy, 2, true);
                    (enemy).helperState = 2
                end
            else
                if ((state == 51) and (timer >= 210)) then
                    do
                        (enemy).helperState = 52;
                        (enemy).helperTimer = 0
                    end
                else
                    if ((state >= 62) and (state <= 64)) then
                        do
                            local phaseState = state;
                            if ((phaseState == 62) and ((enemy).hp < trunc(((ctx).lateStageBossMaxHp_ * 2) / 3))) then
                                do
                                    (enemy).helperState = 63;
                                    phaseState = 63;
                                    ctx:spawnEnemyDeathEffects(enemy, 2, true);
                                    ctx:spawnPlayerSideObject(25, (enemy).x, (enemy).y, 0, (0 % 65536), 0, f32(0))
                                end
                            end;
                            if ((phaseState == 63) and ((enemy).hp < trunc((ctx).lateStageBossMaxHp_ / 3))) then
                                do
                                    (enemy).helperState = 64;
                                    phaseState = 64;
                                    ctx:spawnEnemyDeathEffects(enemy, 2, true);
                                    ctx:spawnPlayerSideObject(25, (enemy).x, (enemy).y, 0, (0 % 65536), 0, f32(0))
                                end
                            end;
                            if (((phaseState == 62) or (phaseState == 63)) and ((ctx).lateStageBossCountdown_ < 1500)) then
                                do
                                    (enemy).helperState = 64;
                                    ctx:spawnEnemyDeathEffects(enemy, 2, true);
                                    ctx:flushEnemyProjectilesToEffects();
                                    ((ctx).player_).invulnerableFrames = math.max(((ctx).player_).invulnerableFrames, 100)
                                end
                            end
                        end
                    end
                end
            end;
            (enemy).drawHp = (enemy).hp;
            (ctx).lateStageBossCountdownDraw_ = (ctx).lateStageBossCountdown_;
            ctx:updateBossCountdownAudio((enemy).hp, (ctx).lateStageBossCountdown_);
            if ((ctx).lateStageBossCountdown_ > 0) then
                (ctx).lateStageBossCountdown_ = (ctx).lateStageBossCountdown_ - 1
            end;
            do return end
        end
    end;
    (enemy).targetable = false;
    do
        local __switch105 = state
        if __switch105 == 0 then goto __case106
        elseif __switch105 == 10 then goto __case109
        elseif __switch105 == 20 then goto __case110
        elseif __switch105 == 30 then goto __case111
        elseif __switch105 == 40 then goto __case112
        elseif __switch105 == 50 then goto __case113
        elseif __switch105 == 60 then goto __case114
        elseif __switch105 == 61 then goto __case115
        elseif __switch105 == 70 then goto __case116
        elseif __switch105 == 99 then goto __case117
        else goto __case118 end
        ::__case106::;
        do
            if (timer == 0) then
                do
                    ctx:playPlayerSound((ctx).bossSe9SoundHandle_, 25);
                    ctx:spawnStage08BossNode(enemy, 168, 0, f32(70), f32((-f32(60))), (49152 % 65536), 0, 99999999, 40, true);
                    ctx:spawnStage08BossNode(enemy, 168, 1, f32((-f32(70))), f32((-f32(60))), (49152 % 65536), 0, 99999999, 40, true);
                    ctx:spawnStage08BossNode(enemy, 167, 0, f32(90), f32((-f32(50))), (49152 % 65536), 0, 99999999, 40, true);
                    ctx:spawnStage08BossNode(enemy, 167, 1, f32((-f32(90))), f32((-f32(50))), (49152 % 65536), 0, 99999999, 40, true);
                    local kNodeX = {f32(210), f32((-f32(210))), f32(88), f32((-f32(88)))};
                    local kNodeY = {f32(146), f32(146), f32(72), f32(72)};
                    do
                        local i = 0
                        while (i < 4) do
                            do
                                ctx:spawnStage08BossNode(enemy, 171, i, (kNodeX)[i + 1], (kNodeY)[i + 1], (49152 % 65536), 0, 4000, 50, true)
                            end
                            ::__continue108::
                            i = i + 1
                        end
                        ::__loop_end107::
                    end;
                    ctx:spawnStage08BossNode(enemy, 172, 0, f32(205), f32((-f32(90))), (49152 % 65536), 0, 25000, 40, true);
                    ctx:spawnStage08BossNode(enemy, 172, 1, f32((-f32(205))), f32((-f32(90))), (49152 % 65536), 0, 25000, 40, true)
                end
            end;
            local t = boss08Smooth((timer / 1200));
            (enemy).x = f32((enemy).originX);
            (enemy).y = f32(f32(((enemy).originY - f32(((1 - t) * 1000)))));
            local firstRain = (((timer >= 30) and (timer < 360)) and (math.fmod((timer - 30), 12) == 0));
            local secondRain = (((timer >= 460) and (timer < 660)) and (math.fmod((timer - 460), 24) == 0));
            local finalRain = (((timer >= 720) and (timer < 900)) and (math.fmod((timer - 720), 8) == 0));
            if ((firstRain or secondRain) or finalRain) then
                do
                    local x = f32((f32(60) + f32(math.fmod(boss08Rand(timer), 601))));
                    ctx:spawnStage08BossNode(enemy, 173, timer, x, f32((-f32(10))), (16384 % 65536), 1, 300, 40, false)
                end
            end;
            if (timer >= 1200) then
                do
                    (enemy).x = f32((enemy).originX);
                    (enemy).y = f32((enemy).originY);
                    (ctx).lateStageBossBreaksRemaining_ = 6;
                    (openPhase)(1, 145000, 3300, 0)
                end
            end;
            goto __switch_end104
        end;
        ::__case109::;
        if ((timer < 120) and (math.fmod(timer, 3) == 0)) then
            ctx:spawnStage02DeathExplosionChain(enemy)
        end;
        if (timer >= 200) then
            do
                (startBoss3)();
                (openPhase)(11, 105000, 2700, 1)
            end
        end;
        goto __switch_end104;
        ::__case110::;
        if ((timer < 130) and (math.fmod(timer, 3) == 0)) then
            ctx:spawnStage02DeathExplosionChain(enemy)
        end;
        (enemy).x = f32(f32(((enemy).x + f32((f32(timer) * f32(0.00150000001))))));
        if (timer >= 380) then
            (openPhase)(21, 80000, 2400, 2)
        end;
        goto __switch_end104;
        ::__case111::;
        if ((timer < 120) and (math.fmod(timer, 3) == 0)) then
            ctx:spawnStage02DeathExplosionChain(enemy)
        end;
        if (timer >= 200) then
            (openPhase)(31, 40000, 1500, 3)
        end;
        goto __switch_end104;
        ::__case112::;
        if (timer == 1) then
            ctx:playPlayerSound((ctx).blast1SoundHandle_, 25)
        end;
        if ((timer < 90) and (math.fmod(timer, 3) == 0)) then
            ctx:spawnStage02DeathExplosionChain(enemy)
        end;
        (enemy).y = f32(f32(((enemy).y + f32(0.0799999982))));
        if (timer >= 180) then
            (openPhase)(41, 80000, 2400, 4)
        end;
        goto __switch_end104;
        ::__case113::;
        if (timer == 1) then
            ctx:playPlayerSound((ctx).blast1SoundHandle_, 25)
        end;
        if ((timer < 90) and (math.fmod(timer, 3) == 0)) then
            ctx:spawnStage02DeathExplosionChain(enemy)
        end;
        (enemy).y = f32(f32(((enemy).y + f32(0.0799999982))));
        if (timer >= 180) then
            (openPhase)(51, 148000, 3300, 5)
        end;
        goto __switch_end104;
        ::__case114::;
        if ((timer < 180) and (math.fmod(timer, 3) == 0)) then
            ctx:spawnStage02DeathExplosionChain(enemy)
        end;
        if (timer == 180) then
            ctx:playPlayerSound((ctx).bossSe9SoundHandle_, 25)
        end;
        if (timer >= 300) then
            do
                (enemy).x = f32(f32(360));
                (enemy).y = f32(f32(200));
                (enemy).helperState = 61;
                (enemy).helperTimer = 0;
                (enemy).hp = 150000;
                (enemy).maxHp = 150000;
                (enemy).drawHp = 150000;
                (ctx).lateStageBossMaxHp_ = 150000;
                (ctx).lateStageBossCountdown_ = 4800;
                (ctx).lateStageBossCountdownDraw_ = 4800;
                (ctx).lateStageBossBreaksRemaining_ = 1;
                (ctx).lateStageBossPhaseMode_ = 0
            end
        end;
        goto __switch_end104;
        ::__case115::;
        if (timer == 90) then
            ctx:playPlayerSound((ctx).bullet2SoundHandle_, 25)
        end;
        if (timer >= 120) then
            do
                (enemy).helperState = 62;
                (enemy).helperTimer = 0;
                (enemy).targetable = true;
                (enemy).targetableTimer = 0;
                (ctx).lateStageBossPhaseMode_ = 1;
                (ctx).lateStageBossPhaseIndex_ = 6
            end
        end;
        goto __switch_end104;
        ::__case116::;
        ::__case117::;
        if ((timer < 240) and (math.fmod(timer, 3) == 0)) then
            ctx:spawnStage02DeathExplosionChain(enemy)
        end;
        (enemy).y = f32(f32(((enemy).y + f32(0.150000006))));
        if (timer == 240) then
            do
                ctx:playPlayerSound((ctx).blast2SoundHandle_, 25);
                ctx:spawnEnemyDeathEffects(enemy, 2, true)
            end
        end;
        if (timer >= 480) then
            do
                ctx:clearLateStageGate(8);
                (enemy).active = false
            end
        end;
        goto __switch_end104;
        ::__case118::;
        goto __switch_end104
        ::__switch_end104::
    end;
    (enemy).drawHp = (enemy).hp;
    (ctx).lateStageBossCountdownDraw_ = (ctx).lateStageBossCountdown_
end

cpp.install(M)

return M
