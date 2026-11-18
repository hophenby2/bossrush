-- 由 tools/generate_likedreamer_native_bosses.py 从本地复原源码生成。

-- 生成物是普通 Lua 状态机；修改源逻辑或生成规则后重新生成并核对轨迹。

local cpp = assert(LikeDreamer.Recovered)

local f32, trunc, u32, s16 = cpp.f32, cpp.trunc, cpp.u32, cpp.s16

local bit = require("bit")

local M = {}

local kBoss09Pi = 3.1415926535897931

local kBoss09Tau = (kBoss09Pi * 2)

local boss09Angle

local boss09Radians

local boss09AngleTo

local boss09Approach

local boss09Rand

local boss09Smooth

local boss09SineEase

local boss09EaseBetween

local boss09ReverseEaseBetween

local boss09Periodic

local boss09BurstPeriodic

local boss09NodeUpdateCase

local boss09NormalMoveState

local boss09NormalMoveTarget

local boss09NormalMoveDuration

local boss09CombatState

boss09Angle = function(value)
    do return (bit.band(value, 65535) % 65536) end
end

boss09Radians = function(angle)
    angle = (angle % 65536);
    do return ((angle * kBoss09Tau) / 65536) end
end

boss09AngleTo = function(x0, y0, x1, y1)
    x0 = f32(x0);
    y0 = f32(y0);
    x1 = f32(x1);
    y1 = f32(y1);
    do return boss09Angle(trunc(((math.atan2(f32((y1 - y0)), f32((x1 - x0))) * 65536) / kBoss09Tau))) end
end

boss09Approach = function(current, target, step)
    current = (current % 65536);
    target = (target % 65536);
    local delta = (target - current);
    if (delta > 32768) then
        delta = (delta - 65536)
    end;
    if (delta < (-32768)) then
        delta = (delta + 65536)
    end;
    do return boss09Angle((current + cpp.clamp(delta, (-step), step))) end
end

boss09Rand = function(seed)
    local value = u32(seed);
    local u = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(value, 30)), value)), 1812433253) + 1));
    local a = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(u, 30)), u)), 1812433253) + 2));
    local b = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(a, 30)), a)), 1812433253) + 3));
    local c = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(b, 30)), b)), 1812433253) + 4));
    local mixed = u32(bit.bxor(cpp.mul32(u, 2048), u));
    do return u32(bit.bxor(u32(bit.bxor(u32(bit.rshift(u32(bit.bxor(u32(bit.rshift(c, 11)), mixed)), 8)), c)), mixed)) end
end

boss09Smooth = function(value)
    value = cpp.clamp(value, 0, 1);
    do return ((value * value) * (3 - (2 * value))) end
end

boss09SineEase = function(value)
    value = cpp.clamp(value, 0, 1);
    do return math.sin(((value * kBoss09Pi) * 0.5)) end
end

boss09EaseBetween = function(timer, start, v_end, from, to)
    if (timer <= start) then
        do return from end
    end;
    if (timer >= v_end) then
        do return to end
    end;
    local t = ((timer - start) / (v_end - start));
    do return (from + ((to - from) * boss09SineEase(t))) end
end

boss09ReverseEaseBetween = function(timer, start, v_end, from, to)
    if (timer <= start) then
        do return from end
    end;
    if (timer >= v_end) then
        do return to end
    end;
    local t = ((timer - start) / (v_end - start));
    do return (from + ((to - from) * (1 - math.cos(((t * kBoss09Pi) * 0.5))))) end
end

boss09Periodic = function(timer, start, v_end, interval)
    do return (((timer >= start) and ((v_end == 0) or (timer < v_end))) and (math.fmod((timer - start), interval) == 0)) end
end

boss09BurstPeriodic = function(timer, start, v_end, period, activeLength, interval)
    if ((timer < start) or ((v_end ~= 0) and (timer >= v_end))) then
        do return false end
    end;
    local phase = math.fmod((timer - start), period);
    do return ((phase < activeLength) and (math.fmod(phase, interval) == 0)) end
end

boss09NodeUpdateCase = function(spawnType)
    if (spawnType == 195) then
        do return 117 end
    end;
    if (spawnType == 205) then
        do return 124 end
    end;
    if ((spawnType >= 206) and (spawnType <= 217)) then
        do return 125 end
    end;
    if ((spawnType >= 218) and (spawnType <= 221)) then
        do return 126 end
    end;
    do return (-1) end
end

boss09NormalMoveState = function(state)
    do return (((state >= 12) and (state <= 16)) or ((state >= 18) and (state <= 22))) end
end

boss09NormalMoveTarget = function(state)
    do
        local __switch2 = state
        if __switch2 == 12 then goto __case3
        elseif __switch2 == 21 then goto __case4
        elseif __switch2 == 13 then goto __case5
        elseif __switch2 == 20 then goto __case6
        elseif __switch2 == 14 then goto __case7
        elseif __switch2 == 19 then goto __case8
        elseif __switch2 == 15 then goto __case9
        elseif __switch2 == 18 then goto __case10
        elseif __switch2 == 16 then goto __case11
        elseif __switch2 == 22 then goto __case12
        else goto __case13 end
        ::__case3::;
        ::__case4::;
        do return {f32(500), f32(370)} end;
        ::__case5::;
        ::__case6::;
        do return {f32(200), f32(200)} end;
        ::__case7::;
        ::__case8::;
        do return {f32(520), f32(200)} end;
        ::__case9::;
        ::__case10::;
        do return {f32(255), f32(370)} end;
        ::__case11::;
        ::__case12::;
        do return {f32(360), f32(100)} end;
        ::__case13::;
        do return {f32(360), f32(190)} end
        ::__switch_end1::
    end
end

boss09NormalMoveDuration = function(state)
    do return (function() if (state >= 18) then return 20 else return 30 end end)() end
end

boss09CombatState = function(state)
    do return (((((((state == 1) or (state == 6)) or ((state >= 11) and (state <= 27))) or (state == 61)) or (state == 62)) or ((state >= 111) and (state <= 117))) or (state == 161)) end
end

M.isStage09BossNodeType = function(ctx, spawnType)
    do return ((spawnType == 195) or ((spawnType >= 205) and (spawnType <= 221))) end
end

M.spawnStage09BossNode = function(ctx, parent, spawnType, childIndex, offsetX, offsetY, angle16, speed, radius, attached)
    offsetX = f32(offsetX);
    offsetY = f32(offsetY);
    angle16 = (angle16 % 65536);
    if ((not ctx:isStage09BossNodeType(spawnType)) or (((#(ctx).enemies_) + (#(ctx).pendingEnemies_)) >= 512)) then
        do
            do return false end
        end
    end;
    local node = cpp.newEnemy();
    (node).entityId = (function() local __old = (ctx).nextEntityId_; (ctx).nextEntityId_ = (ctx).nextEntityId_ + 1; return __old end)();
    (node).spawnType = spawnType;
    (node).updateCase = boss09NodeUpdateCase(spawnType);
    (node).sourceHitPoints = 99999999;
    (node).hp = 99999999;
    (node).maxHp = 99999999;
    (node).drawHp = 99999999;
    (node).parentEntityId = (parent).entityId;
    (node).parentSpawnType = 320;
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
    (node).angle = f32(f32(boss09Radians(angle16)));
    (node).sourceSpeed = speed;
    (node).speed = f32(f32(speed));
    (node).radius = radius;
    (node).sourceDispatchKind = 1;
    (node).sourceDispatchField = (function() if attached then return 1 else return 0 end end)();
    (node).activationDelay = 0;
    (node).targetable = false;
    (node).drawBodyThisFrame = true;
    (node).sourceNote = "S09 FUN_14004a970 internal boss node";
    cpp.push((ctx).pendingEnemies_, node);
    (parent).liveChildCount = (parent).liveChildCount + 1;
    do return true end
end

M.emitStage09BossProjectiles = function(ctx, enemy)
    local difficulty = cpp.clamp(((ctx).config_).difficulty, 0, 4);
    local state = (enemy).helperState;
    local timer = (enemy).helperTimer;
    local fireY = f32(((enemy).y + f32(5)));
    local aimed = boss09AngleTo((enemy).x, fireY, ((ctx).player_).x, ((ctx).player_).y);
    local fired = false;
    local firedBullet2 = false;
    if ((state == 11) or (state == 27)) then
        do
            local kRingInterval = {19, 15, 13, 11, 11};
            local kFanInterval = {11, 9, 9, 7, 7};
            local kWaveUnit = {18, 12, 10, 10, 10};
            local kRingCount = {7, 9, 9, 9, 9};
            local kFanCount = {5, 5, 6, 7, 7};
            local kWaveCount = {5, 7, 7, 7, 7};
            local kBaseSpeed = {5, 5.5, 6, 6, 6};
            local index = difficulty;
            local speed = ((kBaseSpeed)[index + 1] + ((timer - 70) * 0.0040000000000000001));
            if boss09Periodic(timer, 70, 860, (kRingInterval)[index + 1]) then
                do
                    local spread = (20000 + trunc((math.sin(((timer * kBoss09Tau) / 77)) * 3000)));
                    local angle = boss09Angle((timer * 277));
                    ctx:spawnProjectileSpread(12, 0, (enemy).x, fireY, angle, f32(0), speed, 1, (kRingCount)[index + 1], spread, 0);
                    ctx:spawnProjectileSpread(12, 0, (enemy).x, fireY, boss09Angle((angle + 32768)), f32(0), speed, 1, (kRingCount)[index + 1], spread, 0);
                    fired = true
                end
            end;
            if boss09Periodic(timer, 190, 860, (kFanInterval)[index + 1]) then
                do
                    ctx:spawnProjectileSpread(3, 0, (enemy).x, fireY, boss09Angle((timer * 65125)), f32(10), (speed + 1), 1, (kFanCount)[index + 1], 65536, 0);
                    fired = true
                end
            end;
            local unit = (kWaveUnit)[index + 1];
            local period = (unit * 6);
            if boss09Periodic(timer, 330, 860, period) then
                do
                    (enemy).secondaryAngle16 = (aimed % 65536)
                end
            end;
            if boss09BurstPeriodic(timer, 330, 860, period, (unit * 4), (unit * 2)) then
                do
                    ctx:spawnProjectileSpread(9, 0, (enemy).x, fireY, (enemy).secondaryAngle16, f32(10), (speed + 0.5), 1, (kWaveCount)[index + 1], 24000, 0);
                    fired = true
                end
            end;
            if boss09BurstPeriodic(timer, (330 + unit), 860, period, (unit * 4), (unit * 2)) then
                do
                    local count = ((kWaveCount)[index + 1] - 1);
                    local spread = (trunc(24000 / (count + 1)) * count);
                    ctx:spawnProjectileSpread(9, 0, (enemy).x, fireY, (enemy).secondaryAngle16, f32(10), (speed + 0.5), 1, count, spread, 0);
                    fired = true
                end
            end
        end
    else
        if (state == 17) then
            do
                if (timer == 30) then
                    do
                        local count = ({9, 11, 13, 15, 15})[difficulty + 1];
                        ctx:spawnProjectileSpread(3, 43, (enemy).x, fireY, aimed, f32(10), 8, 1, count, 65536, 0);
                        ctx:spawnProjectileSpread(3, 43, (enemy).x, fireY, boss09Angle((aimed + trunc(65536 / (count * 2)))), f32(10), 10, 1, count, 65536, 0);
                        fired = true
                    end
                end
            end
        else
            if (state == 23) then
                do
                    local kInterval = {15, 12, 9, 7, 7};
                    local kInitialCount = {9, 13, 13, 13, 13};
                    local kBurstInterval = {24, 18, 16, 14, 14};
                    local kBurstCount = {18, 20, 22, 22, 22};
                    local kSpeed = {5.5, 6, 6.5, 7, 7};
                    local index = difficulty;
                    local interval = (kInterval)[index + 1];
                    local count = ((kInitialCount)[index + 1] + trunc((timer - 50) / (interval * 2)));
                    local speed = ((kSpeed)[index + 1] + ((timer - 50) * 0.040000000000000001));
                    if boss09Periodic(timer, 50, 230, (interval * 2)) then
                        do
                            (enemy).secondaryAngle16 = (aimed % 65536);
                            ctx:spawnProjectileSpread(12, 0, (enemy).x, fireY, (enemy).secondaryAngle16, f32(0), speed, 1, count, 65536, 0);
                            firedBullet2 = true
                        end
                    end;
                    if boss09Periodic(timer, (50 + interval), 230, (interval * 2)) then
                        do
                            ctx:spawnProjectileSpread(13, 0, (enemy).x, fireY, boss09Angle(((enemy).secondaryAngle16 + trunc(65536 / (count * 2)))), f32(0), speed, 1, count, 65536, 0);
                            firedBullet2 = true
                        end
                    end;
                    if (timer == 240) then
                        (enemy).secondaryAngle16 = (aimed % 65536)
                    end;
                    local burstInterval = (kBurstInterval)[index + 1];
                    local burstCount = (kBurstCount)[index + 1];
                    local burstSpeed = ((kSpeed)[index + 1] + 5);
                    if boss09Periodic(timer, 240, 420, (burstInterval * 2)) then
                        do
                            do

                                for _, offset in ipairs({(-500), 0, 500}) do
                                    do
                                        ctx:spawnProjectileSpread(5, 0, (enemy).x, fireY, boss09Angle(((enemy).secondaryAngle16 + offset)), f32(0), burstSpeed, 1, burstCount, 65536, 0)
                                    end
                                    ::__continue15::
                                end
                                ::__loop_end14::
                            end;
                            fired = true
                        end
                    end;
                    if boss09Periodic(timer, (240 + burstInterval), 420, (burstInterval * 2)) then
                        do
                            local halfStep = trunc(65536 / (burstCount * 2));
                            do

                                for _, offset in ipairs({(-500), 0, 500}) do
                                    do
                                        ctx:spawnProjectileSpread(4, 0, (enemy).x, fireY, boss09Angle((((enemy).secondaryAngle16 + halfStep) + offset)), f32(0), burstSpeed, 1, burstCount, 65536, 0)
                                    end
                                    ::__continue17::
                                end
                                ::__loop_end16::
                            end;
                            fired = true
                        end
                    end
                end
            else
                if (state == 24) then
                    do
                        local kCount = {3, 5, 6, 7, 7};
                        local kAngleStep = {1111, 800, 660, 770, 770};
                        local kSpeed = {6, 7, 7.5, 7.5, 7.5};
                        local index = difficulty;
                        local interval = (function() if (timer < 220) then return 50 else return 30 end end)();
                        if (boss09Periodic(timer, 20, 220, interval) or boss09Periodic(timer, 220, 340, interval)) then
                            do
                                (enemy).secondaryAngle16 = (aimed % 65536)
                            end
                        end;
                        local positiveBurst = (boss09BurstPeriodic(timer, 20, 220, (interval * 2), 40, 3) or boss09BurstPeriodic(timer, 220, 340, (interval * 2), 25, 3));
                        if positiveBurst then
                            do
                                ctx:spawnProjectileSpread(2, 44, (enemy).x, fireY, boss09Angle(((enemy).secondaryAngle16 + (timer * (kAngleStep)[index + 1]))), f32(0), (kSpeed)[index + 1], 1, (kCount)[index + 1], 65536, 0);
                                firedBullet2 = true
                            end
                        end;
                        local negativeBurst = (boss09BurstPeriodic(timer, (20 + interval), 220, (interval * 2), 40, 3) or boss09BurstPeriodic(timer, (220 + interval), 340, (interval * 2), 25, 3));
                        if negativeBurst then
                            do
                                ctx:spawnProjectileSpread(3, 45, (enemy).x, fireY, boss09Angle(((enemy).secondaryAngle16 - (timer * (kAngleStep)[index + 1]))), f32(0), (kSpeed)[index + 1], 1, (kCount)[index + 1], 65536, 0);
                                firedBullet2 = true
                            end
                        end
                    end
                else
                    if (state == 25) then
                        do
                            local kInterval = {8, 7, 7, 6, 6};
                            local interval = (kInterval)[difficulty + 1];
                            if (timer == 30) then
                                do
                                    (enemy).secondaryAngle16 = (boss09AngleTo((enemy).x, fireY, f32(128), f32(0)) % 65536)
                                end
                            end;
                            if boss09Periodic(timer, 30, 720, interval) then
                                do
                                    ctx:spawnProjectileSpread(4, 46, (enemy).x, fireY, (enemy).secondaryAngle16, f32(0), 6, 1, 1, 0, 0);
                                    fired = true
                                end
                            end;
                            if boss09Periodic(timer, 820, 900, 10) then
                                do
                                    ctx:spawnProjectileSpread(4, 46, (enemy).x, fireY, (enemy).secondaryAngle16, f32(0), 6, 1, 3, 65536, 0);
                                    fired = true
                                end
                            end;
                            (enemy).secondaryAngle16 = (boss09Angle(((enemy).secondaryAngle16 + (function() if (timer < 800) then return 230 else return 1777 end end)())) % 65536)
                        end
                    else
                        if (state == 26) then
                            do
                                local kInterval = {10, 8, 8, 7, 7};
                                local kCount = {6, 10, 12, 12, 12};
                                local kSpeed = {6.4000000000000004, 7, 7.5, 8, 8};
                                local index = difficulty;
                                local interval = (kInterval)[index + 1];
                                local count = (kCount)[index + 1];
                                if (timer == 1) then
                                    do
                                        (enemy).secondaryAngle16 = (aimed % 65536);
                                        (enemy).targetAngle16 = (aimed % 65536)
                                    end
                                end;
                                if boss09Periodic(timer, 1, 150, interval) then
                                    do
                                        local targetSpread = trunc(65536 / count);
                                        local spread = trunc((65535 + ((targetSpread - 65535) * boss09SineEase((timer / 150)))));
                                        ctx:spawnProjectileSpread(4, 0, (enemy).x, fireY, (enemy).secondaryAngle16, f32(0), (kSpeed)[index + 1], 1, 2, spread, 0);
                                        ctx:spawnProjectileSpread(1, 0, (enemy).x, fireY, (enemy).targetAngle16, f32(0), ((kSpeed)[index + 1] - 1.5), 1, 2, spread, 0);
                                        fired = true
                                    end
                                end;
                                if boss09Periodic(timer, 150, 1120, interval) then
                                    do
                                        local halfStep = trunc(65536 / (count * 2));
                                        ctx:spawnProjectileSpread(4, 0, (enemy).x, fireY, boss09Angle(((enemy).secondaryAngle16 + halfStep)), f32(0), (kSpeed)[index + 1], 1, count, 65536, 0);
                                        ctx:spawnProjectileSpread(1, 0, (enemy).x, fireY, boss09Angle(((enemy).targetAngle16 + halfStep)), f32(0), ((kSpeed)[index + 1] - 1.5), 1, count, 65536, 0);
                                        fired = true
                                    end
                                end;
                                if (timer < 150) then
                                    do
                                        local turn = trunc((1280 + ((64 - 1280) * boss09SineEase((timer / 150)))));
                                        (enemy).secondaryAngle16 = (boss09Approach((enemy).secondaryAngle16, aimed, turn) % 65536);
                                        (enemy).targetAngle16 = (boss09Approach((enemy).targetAngle16, aimed, turn) % 65536)
                                    end
                                else
                                    do
                                        if (timer >= 180) then
                                            do
                                                (enemy).secondaryAngle16 = (boss09Angle(((enemy).secondaryAngle16 + trunc((timer - 180) / 2))) % 65536)
                                            end
                                        end;
                                        if (timer >= 220) then
                                            do
                                                (enemy).targetAngle16 = (boss09Angle(((enemy).targetAngle16 - trunc((timer - 220) / 2))) % 65536)
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            if ((state == 111) or (state == 117)) then
                                do
                                    (enemy).secondaryAngle16 = (boss09Angle((16384 + trunc((math.sin((((timer + 69) * kBoss09Tau) / 555)) * 65536)))) % 65536);
                                    (enemy).targetAngle16 = (boss09Angle(((-32768) + trunc((math.sin((((timer - 189) * kBoss09Tau) / 666)) * 65536)))) % 65536);
                                    local speed = (9.9000000000000003 + ((timer - 70) * 0.001));
                                    if boss09BurstPeriodic(timer, 70, 310, 40, 20, 4) then
                                        do
                                            ctx:spawnProjectileSpread(13, 0, (enemy).x, fireY, (enemy).secondaryAngle16, f32(0), speed, 1, 11, 65536, 0);
                                            fired = true
                                        end
                                    end;
                                    if boss09BurstPeriodic(timer, 90, 310, 40, 20, 4) then
                                        do
                                            ctx:spawnProjectileSpread(12, 0, (enemy).x, fireY, (enemy).targetAngle16, f32(0), speed, 1, 11, 65536, 0);
                                            fired = true
                                        end
                                    end;
                                    if boss09Periodic(timer, 310, 720, 8) then
                                        do
                                            ctx:spawnProjectileSpread(13, 0, (enemy).x, fireY, (enemy).secondaryAngle16, f32(0), speed, 1, 22, 65536, 0);
                                            fired = true
                                        end
                                    end;
                                    if boss09Periodic(timer, 314, 720, 8) then
                                        do
                                            ctx:spawnProjectileSpread(12, 0, (enemy).x, fireY, (enemy).secondaryAngle16, f32(0), speed, 1, 22, 65536, 0);
                                            fired = true
                                        end
                                    end;
                                    if (timer == 720) then
                                        do
                                            ctx:spawnProjectileSpread(2, 47, (enemy).x, fireY, (enemy).secondaryAngle16, f32(0), 10, 1, 22, 65536, 0);
                                            firedBullet2 = true
                                        end
                                    end;
                                    if (timer == 800) then
                                        do
                                            ctx:spawnProjectileSpread(3, 48, (enemy).x, fireY, (enemy).secondaryAngle16, f32(0), 10, 1, 22, 65536, 0);
                                            firedBullet2 = true
                                        end
                                    end
                                end
                            else
                                if (state == 112) then
                                    do
                                        if (timer == 20) then
                                            (enemy).secondaryAngle16 = (aimed % 65536)
                                        end;
                                        if boss09Periodic(timer, 20, 500, 2) then
                                            do
                                                ctx:spawnProjectileSpread(11, 49, (enemy).x, fireY, (enemy).secondaryAngle16, f32(10), 7.7000000000000001, 1, 1, 0, 0);
                                                fired = true
                                            end
                                        end;
                                        (enemy).secondaryAngle16 = (boss09Angle(((enemy).secondaryAngle16 + (function() if (timer < 270) then return 640 else return (-640) end end)())) % 65536)
                                    end
                                else
                                    if (state == 113) then
                                        do
                                            if (timer == 20) then
                                                do
                                                    (enemy).secondaryAngle16 = (boss09Angle((aimed - 16384)) % 65536)
                                                end
                                            end;
                                            if boss09Periodic(timer, 20, 540, 6) then
                                                do
                                                    ctx:spawnProjectileSpread(2, 50, (enemy).x, fireY, (enemy).secondaryAngle16, f32(10), 13, 1, 1, 0, 0);
                                                    fired = true
                                                end
                                            end;
                                            if (timer == 153) then
                                                do
                                                    (enemy).targetAngle16 = (boss09Angle((aimed + 16384)) % 65536)
                                                end
                                            end;
                                            if boss09Periodic(timer, 153, 540, 6) then
                                                do
                                                    ctx:spawnProjectileSpread(3, 50, (enemy).x, fireY, (enemy).targetAngle16, f32(10), 13, 1, 1, 0, 0);
                                                    fired = true
                                                end
                                            end;
                                            (enemy).secondaryAngle16 = (boss09Angle(((enemy).secondaryAngle16 + 666)) % 65536);
                                            (enemy).targetAngle16 = (boss09Angle(((enemy).targetAngle16 - 666)) % 65536)
                                        end
                                    else
                                        if (state == 114) then
                                            do
                                                local interval = (function() if (timer < 190) then return 32 else return 16 end end)();
                                                if boss09Periodic(timer, 10, 500, interval) then
                                                    do
                                                        local angle = boss09Angle(math.fmod(boss09Rand(timer), 65537));
                                                        ctx:spawnProjectileSpread(3, 44, (enemy).x, fireY, angle, f32(0), 6, 1, 21, 65536, 0);
                                                        ctx:spawnProjectileSpread(2, 45, (enemy).x, fireY, angle, f32(0), 6, 1, 21, 65536, 0);
                                                        fired = true
                                                    end
                                                end
                                            end
                                        else
                                            if (state == 115) then
                                                do
                                                    local speed = (9.5999999999999996 + (timer * 0.01));
                                                    if boss09Periodic(timer, 10, 550, 30) then
                                                        do
                                                            (enemy).secondaryAngle16 = (aimed % 65536)
                                                        end
                                                    end;
                                                    local phase = math.fmod((timer - 10), 30);
                                                    local angleOffset = (phase * 60);
                                                    if boss09BurstPeriodic(timer, 10, 550, 60, 24, 3) then
                                                        do
                                                            ctx:spawnProjectileSpread(11, 0, (enemy).x, fireY, boss09Angle(((enemy).secondaryAngle16 + angleOffset)), f32(0), speed, 1, 6, 32768, 0);
                                                            ctx:spawnProjectileSpread(11, 0, (enemy).x, fireY, boss09Angle(((enemy).secondaryAngle16 - angleOffset)), f32(0), speed, 1, 6, 32768, 0);
                                                            fired = true
                                                        end
                                                    end;
                                                    if boss09BurstPeriodic(timer, 40, 550, 60, 24, 3) then
                                                        do
                                                            local kInsetSpread = (trunc(32768 / 5) * 4);
                                                            ctx:spawnProjectileSpread(11, 0, (enemy).x, fireY, boss09Angle(((enemy).secondaryAngle16 + angleOffset)), f32(0), speed, 1, 5, kInsetSpread, 0);
                                                            ctx:spawnProjectileSpread(11, 0, (enemy).x, fireY, boss09Angle(((enemy).secondaryAngle16 - angleOffset)), f32(0), speed, 1, 5, kInsetSpread, 0);
                                                            fired = true
                                                        end
                                                    end;
                                                    if boss09Periodic(timer, 70, 550, 60) then
                                                        do
                                                            ctx:spawnProjectileSpread(12, 51, (enemy).x, fireY, boss09Angle((aimed - 32768)), f32(0), 6.4000000000000004, 1, 13, 20000, 0);
                                                            fired = true
                                                        end
                                                    end;
                                                    if boss09Periodic(timer, 130, 550, 30) then
                                                        do
                                                            ctx:spawnProjectileSpread(5, 0, (enemy).x, fireY, aimed, f32(0), 5.5, 1, 17, 30000, 0);
                                                            ctx:spawnProjectileSpread(5, 0, (enemy).x, fireY, aimed, f32(0), 8.5, 1, 17, 30000, 0);
                                                            firedBullet2 = true
                                                        end
                                                    end
                                                end
                                            else
                                                if (state == 116) then
                                                    do
                                                        if (timer == 10) then
                                                            (enemy).secondaryAngle16 = ((0 % 65536) % 65536)
                                                        end;
                                                        if boss09Periodic(timer, 10, 1120, 2) then
                                                            do
                                                                local count = (function() if (timer < 180) then return 3 else return (function() if (timer < 360) then return 4 else return (function() if (timer < 600) then return 5 else return (function() if (timer < 840) then return 6 else return 7 end end)() end end)() end end)() end end)();
                                                                local baseSpeed = (3 + (timer * 0.0015));
                                                                do
                                                                    local i = 0
                                                                    while (i < count) do
                                                                        do
                                                                            local speed = (baseSpeed + (i * 2));
                                                                            ctx:spawnProjectileSpread(5, 0, (enemy).x, fireY, boss09Angle((((enemy).secondaryAngle16 - (i * 3213)) - 16384)), f32(0), speed, 1, 1, 0, 0);
                                                                            ctx:spawnProjectileSpread(4, 0, (enemy).x, fireY, boss09Angle((((i * 3213) - (enemy).secondaryAngle16) - 16384)), f32(0), speed, 1, 1, 0, 0)
                                                                        end
                                                                        ::__continue19::
                                                                        i = i + 1
                                                                    end
                                                                    ::__loop_end18::
                                                                end;
                                                                fired = true
                                                            end
                                                        end;
                                                        (enemy).secondaryAngle16 = (boss09Angle((((enemy).secondaryAngle16 + timer) + 999)) % 65536)
                                                    end
                                                else
                                                    if ((state == 61) or (state == 62)) then
                                                        do
                                                            if (timer >= 100) then
                                                                do
                                                                    local cycle = math.fmod((timer - 100), 360);
                                                                    local spawnOrbitGroup = function(clockwiseType, counterclockwiseType)
                                                                        local random = boss09Rand(timer);
                                                                        local type = (function() if (u32(bit.band(random, 1)) == u32(0)) then return clockwiseType else return counterclockwiseType end end)();
                                                                        local angularSpeed = (function() if (type == clockwiseType) then return 200 else return (-200) end end)();
                                                                        local radius = (150 + math.fmod(random, 31));
                                                                        do
                                                                            local i = 0
                                                                            while (i < 4) do
                                                                                do
                                                                                    ctx:spawnStage09BossNode(enemy, type, i, f32(0), f32(0), boss09Angle((i * 16384)), angularSpeed, radius, true)
                                                                                end
                                                                                ::__continue21::
                                                                                i = i + 1
                                                                            end
                                                                            ::__loop_end20::
                                                                        end;
                                                                        ctx:playPlayerSound((ctx).bullet2SoundHandle_, 19)
                                                                    end;
                                                                    if (cycle == 0) then
                                                                        do
                                                                            (spawnOrbitGroup)(218, 219)
                                                                        end
                                                                    end;
                                                                    if ((state == 62) and (cycle == 180)) then
                                                                        do
                                                                            (spawnOrbitGroup)(220, 221)
                                                                        end
                                                                    end;
                                                                    if ((state == 61) and (timer >= 340)) then
                                                                        do
                                                                            local kInterval = {16, 10, 8, 6, 6};
                                                                            local kSpeed = {5.5, 5.5, 6.5, 7, 7};
                                                                            local kCount = {30, 30, 32, 32, 32};
                                                                            local shotCycle = math.fmod((timer - 340), 360);
                                                                            local interval = (kInterval)[difficulty + 1];
                                                                            if (shotCycle == 30) then
                                                                                do
                                                                                    (enemy).secondaryAngle16 = (aimed % 65536)
                                                                                end
                                                                            end;
                                                                            if (((shotCycle >= 30) and (shotCycle < 130)) and (math.fmod((shotCycle - 30), interval) == 0)) then
                                                                                do
                                                                                    local halfRange = ((shotCycle - 30) * 10);
                                                                                    local randomOffset = 0;
                                                                                    if (halfRange > 0) then
                                                                                        do
                                                                                            randomOffset = (math.fmod(boss09Rand(timer), u32(((halfRange * 2) + 1))) - halfRange)
                                                                                        end
                                                                                    end;
                                                                                    ctx:spawnProjectileSpread(2, 1, (enemy).x, fireY, boss09Angle(((enemy).secondaryAngle16 + randomOffset)), f32(0), (kSpeed)[difficulty + 1], 1, (kCount)[difficulty + 1], 65536, 0);
                                                                                    fired = true
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    else
                                                        if ((state == 161) and (timer >= 100)) then
                                                            do
                                                                local cycle = math.fmod((timer - 100), 600);
                                                                local spawnOrbitGroup = function(clockwiseType, counterclockwiseType)
                                                                    local type = (function() if (u32(bit.band(boss09Rand((ctx).frame_), 1)) == u32(0)) then return clockwiseType else return counterclockwiseType end end)();
                                                                    local angularSpeed = (function() if (type == clockwiseType) then return 200 else return (-200) end end)();
                                                                    local radius = (150 + math.fmod(boss09Rand(timer), 31));
                                                                    do
                                                                        local i = 0
                                                                        while (i < 7) do
                                                                            do
                                                                                ctx:spawnStage09BossNode(enemy, type, i, f32(0), f32(0), boss09Angle((i * 9362)), angularSpeed, radius, true)
                                                                            end
                                                                            ::__continue23::
                                                                            i = i + 1
                                                                        end
                                                                        ::__loop_end22::
                                                                    end;
                                                                    ctx:playPlayerSound((ctx).bullet2SoundHandle_, 19)
                                                                end;
                                                                if ((cycle == 0) or (cycle == 300)) then
                                                                    do
                                                                        (spawnOrbitGroup)(218, 219)
                                                                    end
                                                                end;
                                                                if (cycle == 150) then
                                                                    do
                                                                        (spawnOrbitGroup)(220, 221)
                                                                    end
                                                                end;
                                                                if (timer >= 300) then
                                                                    do
                                                                        local shotCycle = math.fmod((timer - 600), 600);
                                                                        if (shotCycle == 30) then
                                                                            do
                                                                                (enemy).secondaryAngle16 = (aimed % 65536)
                                                                            end
                                                                        end;
                                                                        if (((shotCycle >= 30) and (shotCycle < 150)) and (math.fmod((shotCycle - 30), 8) == 0)) then
                                                                            do
                                                                                local halfRange = (shotCycle * 27);
                                                                                local randomOffset = 0;
                                                                                if (halfRange > 0) then
                                                                                    do
                                                                                        randomOffset = (math.fmod(boss09Rand(timer), u32(((halfRange * 2) + 1))) - halfRange)
                                                                                    end
                                                                                end;
                                                                                ctx:spawnProjectileSpread(4, 1, (enemy).x, fireY, boss09Angle(((enemy).secondaryAngle16 + randomOffset)), f32(0), 8.8000000000000007, 1, 40, 65536, 0);
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
        ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
    end;
    if firedBullet2 then
        ctx:playPlayerSound((ctx).bullet2SoundHandle_, 19)
    end
end

M.updateStage09BossNode = function(ctx, enemy)
    (enemy).vx = f32(f32(0));
    (enemy).vy = f32(f32(0));
    (enemy).drawBodyThisFrame = true;
    (enemy).drawMarkerThisFrame = false;
    (enemy).targetable = false;
    local root = ctx:findEnemyById((enemy).parentEntityId);
    if (((root == nil) or ((root).spawnType ~= 320)) or (not (root).active)) then
        do
            (enemy).active = false;
            do return end
        end
    end;
    local difficulty = cpp.clamp(((ctx).config_).difficulty, 0, 4);
    local timer = (enemy).helperTimer;
    local aimed = function()
        do return boss09AngleTo((enemy).x, (enemy).y, ((ctx).player_).x, ((ctx).player_).y) end
    end;
    if ((enemy).spawnType == 195) then
        do
            (enemy).x = f32((root).x);
            (enemy).y = f32((root).y);
            (enemy).sourceAngle16 = (boss09Angle(((ctx).frame_ * 1024)) % 65536);
            if (((enemy).helperState == 0) and (timer == 0)) then
                do
                    local randomHundredth = function(seed, minimum, steps)
                        do return (minimum + (math.fmod(boss09Rand(seed), u32(steps)) / 100)) end
                    end;
                    local particle = (function() if ((#(ctx).playerFrames_) > 14) then return ((ctx).playerFrames_)[14 + 1] else return (-1) end end)();
                    do
                        local index = 0
                        while (index < 32) do
                            do
                                local angle = boss09Angle(math.fmod(boss09Rand(((ctx).frame_ + (index * 88))), 65537));
                                local scale = (randomHundredth)(((ctx).frame_ + (index * 8888)), 1.1000000000000001, 111);
                                local speed = (randomHundredth)(((ctx).frame_ + (index * 888)), 16, 901);
                                ctx:spawnStageEffect(44, particle, 0, 72, (enemy).x, (enemy).y, angle, speed, scale, scale, 0, 255, 255, 255, 192, 0)
                            end
                            ::__continue25::
                            index = index + 1
                        end
                        ::__loop_end24::
                    end
                end
            end;
            if ((((ctx).player_).invulnerableFrames < 61) or ((ctx).lateStageBossPhaseMode_ ~= 1)) then
                do
                    if ((enemy).helperState == 0) then
                        do
                            (enemy).helperState = 1;
                            (enemy).helperTimer = 0
                        end
                    else
                        if (timer >= 16) then
                            do
                                (enemy).active = false
                            end
                        end
                    end
                end
            end;
            do return end
        end
    end;
    if ((enemy).spawnType == 205) then
        do
            local shieldAlive = cpp.any_of((ctx).enemies_, (ctx).enemies_, function(node)
                do return ((((node).active and ((node).spawnType == 195)) and ((node).parentEntityId == (root).entityId)) and ((node).parentSpawnType == 320)) end
            end);
            if (shieldAlive and ((enemy).helperTimer < 164)) then
                do
                    (enemy).helperTimer = 164
                end
            end;
            local radians = boss09Radians((enemy).sourceAngle16);
            (enemy).x = f32(f32(((enemy).x + f32((math.cos(radians) * (enemy).sourceSpeed)))));
            (enemy).y = f32(f32(((enemy).y + f32((math.sin(radians) * (enemy).sourceSpeed)))));
            if (timer >= 180) then
                (enemy).active = false
            end;
            do return end
        end
    end;
    if (((enemy).spawnType >= 218) and ((enemy).spawnType <= 221)) then
        do
            if ((((not (root).targetable) or ((ctx).lateStageBossPhaseMode_ ~= 1)) or ((root).hp < 1)) or ((ctx).lateStageBossCountdown_ < 1)) then
                do
                    (enemy).active = false;
                    do return end
                end
            end;
            local type = (enemy).spawnType;
            local angularVelocity = trunc((enemy).sourceSpeed);
            (enemy).sourceAngle16 = (boss09Angle(((enemy).sourceAngle16 + angularVelocity)) % 65536);
            local radiusPhase = cpp.clamp((timer / 300), 0, 1);
            local orbitRadius = ((enemy).radius * math.sin((radiusPhase * kBoss09Pi)));
            local orbitRadians = boss09Radians((enemy).sourceAngle16);
            (enemy).x = f32(f32(((root).x + f32((math.cos(orbitRadians) * orbitRadius)))));
            (enemy).y = f32(f32(((root).y + f32((math.sin(orbitRadians) * orbitRadius)))));
            local kInterval = {6, 5, 4, 3, 3};
            local kTurn = {200, 230, 270, 340, 470};
            local kBaseSpeed = {5, 5.5, 6.5, 7, 7};
            if (timer == 30) then
                do
                    local random = boss09Rand((root).helperTimer);
                    (enemy).secondaryAngle16 = (boss09Angle((((enemy).sourceAngle16 - trunc(random / 65537)) + (random % 65536))) % 65536)
                end
            end;
            local fired = false;
            local interval = (kInterval)[difficulty + 1];
            if (((timer >= 30) and (timer < 270)) and (math.fmod((timer - 30), interval) == 0)) then
                do
                    local speed = ((kBaseSpeed)[difficulty + 1] + ((timer - 30) * (function() if (difficulty == 4) then return 0.02 else return 0.012 end end)()));
                    if (difficulty < 4) then
                        do
                            local selector = (function() if (type < 220) then return 3 else return 2 end end)();
                            ctx:spawnProjectileSpread(selector, 0, (enemy).x, (enemy).y, (enemy).secondaryAngle16, f32(0), speed, 1, 2, 65536, 0)
                        end
                    else
                        do
                            local selector = (function() if (type < 220) then return 13 else return 12 end end)();
                            local projectileId = (function() if ((type == 218) or (type == 220)) then return 44 else return 45 end end)();
                            ctx:spawnProjectileSpread(selector, projectileId, (enemy).x, (enemy).y, (enemy).secondaryAngle16, f32(0), speed, 1, 1, 0, 0)
                        end
                    end;
                    fired = true
                end
            end;
            local turn = (kTurn)[difficulty + 1];
            (enemy).secondaryAngle16 = (boss09Angle((((enemy).secondaryAngle16 + angularVelocity) + (function() if ((type == 218) or (type == 220)) then return turn else return (-turn) end end)())) % 65536);
            if fired then
                ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
            end;
            if (timer >= 300) then
                (enemy).active = false
            end;
            do return end
        end
    end;
    if ((enemy).sourceDispatchField ~= 0) then
        do
            (enemy).x = f32(f32(((root).x + (enemy).originX)));
            (enemy).y = f32(f32(((root).y + (enemy).originY)))
        end
    end;
    if ((enemy).helperState == 0) then
        do
            local type = (enemy).spawnType;
            local aimsDuringEntry = (((((type == 206) or (type == 211)) or (type == 212)) or (type == 213)) or (type == 216));
            if aimsDuringEntry then
                do
                    local target = (aimed)();
                    local delta = (target - (enemy).sourceAngle16);
                    if (delta > 32768) then
                        delta = (delta - 65536)
                    end;
                    if (delta < (-32768)) then
                        delta = (delta + 65536)
                    end;
                    (enemy).sourceAngle16 = (boss09Approach((enemy).sourceAngle16, target, (trunc(math.abs(delta) / 5) + 64)) % 65536)
                end
            else
                do
                    local entryRotation = (function() if (timer < 20) then return trunc((math.sin(((timer * kBoss09Pi) / 40)) * 65536)) else return 0 end end)();
                    (enemy).sourceAngle16 = (boss09Angle(((enemy).secondaryAngle16 + entryRotation)) % 65536)
                end
            end;
            if (timer >= 20) then
                do
                    (enemy).helperState = 1;
                    (enemy).helperTimer = 0
                end
            end;
            do return end
        end
    end;
    if ((enemy).helperState == 2) then
        do
            if (timer >= 20) then
                (enemy).active = false
            end;
            do return end
        end
    end;
    if ((((not (root).targetable) or ((ctx).lateStageBossPhaseMode_ ~= 1)) or ((root).hp < 1)) or ((ctx).lateStageBossCountdown_ < 1)) then
        do
            (enemy).helperState = 2;
            (enemy).helperTimer = 0;
            do return end
        end
    end;
    local type = (enemy).spawnType;
    local lifetime = 50;
    if (type == 217) then
        lifetime = 36
    else
        if ((type == 207) or (type == 208)) then
            lifetime = 240
        else
            if ((type == 209) or (type == 210)) then
                lifetime = 90
            else
                if (type == 211) then
                    lifetime = 330
                else
                    if ((type == 212) or (type == 213)) then
                        lifetime = 320
                    else
                        if ((type == 214) or (type == 215)) then
                            lifetime = 720
                        else
                            if (type == 216) then
                                lifetime = 600
                            end
                        end
                    end
                end
            end
        end
    end;
    (enemy).targetAngle16 = ((aimed)() % 65536);
    local muzzleAngle = (enemy).sourceAngle16;
    local muzzleRadians = boss09Radians(muzzleAngle);
    local shotX = f32(((enemy).x + f32((math.cos(muzzleRadians) * 10))));
    local shotY = f32(((enemy).y + f32((math.sin(muzzleRadians) * 10))));
    local fired = false;
    if ((type == 206) or (type == 217)) then
        do
            local kSpeed = {6, 7, 8, 9, 11};
            local v_end = (function() if (type == 206) then return 50 else return 36 end end)();
            if (((timer >= 10) and (timer < v_end)) and (math.fmod((timer - 10), 4) == 0)) then
                do
                    local speed = ((kSpeed)[difficulty + 1] + (timer * 0.10000000000000001));
                    ctx:spawnProjectileSpread(10, 0, shotX, shotY, (enemy).sourceAngle16, f32(10), speed, 1, 1, 0, 0);
                    ctx:spawnProjectileSpread(10, 0, shotX, shotY, (enemy).sourceAngle16, f32(10), (speed - 0.5), 1, 2, 1200, 0);
                    if (difficulty > 2) then
                        do
                            ctx:spawnProjectileSpread(10, 0, shotX, shotY, (enemy).sourceAngle16, f32(10), (speed - 1.2), 1, 2, 2000, 0)
                        end
                    end;
                    if (type == 217) then
                        do
                            ctx:spawnProjectileSpread(11, 0, shotX, shotY, boss09Angle(((enemy).sourceAngle16 + 32768)), f32(10), speed, 1, 2, 21845, 0)
                        end
                    end;
                    fired = true
                end
            end
        end
    else
        if ((type == 207) or (type == 208)) then
            do
                local kInterval = {11, 7, 6, 7, 6};
                local kCount = {1, 1, 1, 2, 2};
                local kSpeed = {5, 6, 6.5, 7, 8.5};
                local index = difficulty;
                if (((timer >= 10) and (timer < 240)) and (math.fmod((timer - 10), (kInterval)[index + 1]) == 0)) then
                    do
                        ctx:spawnProjectileSpread(13, 0, shotX, shotY, (enemy).sourceAngle16, f32(10), (kSpeed)[index + 1], 1, (kCount)[index + 1], 2222, 0);
                        fired = true
                    end
                end;
                (enemy).sourceAngle16 = (boss09Angle(((enemy).sourceAngle16 + (function() if (type == 207) then return 222 else return (-222) end end)())) % 65536)
            end
        else
            if ((type == 209) or (type == 210)) then
                do
                    local kTurn = {100, 110, 120, 128, 128};
                    if (((timer >= 10) and (timer < 90)) and (math.fmod((timer - 10), 5) == 0)) then
                        do
                            local center = boss09Angle(((enemy).sourceAngle16 + (function() if (((ctx).player_).y <= (enemy).y) then return 32768 else return 0 end end)()));
                            ctx:spawnProjectileSpread(3, 0, shotX, shotY, center, f32(10), (6 + (timer * 0.02)), 1, 2, 8192, 0);
                            fired = true
                        end
                    end;
                    (enemy).sourceAngle16 = (boss09Angle(((enemy).sourceAngle16 + (function() if (type == 209) then return (kTurn)[difficulty + 1] else return (-(kTurn)[difficulty + 1]) end end)())) % 65536)
                end
            else
                if (type == 211) then
                    do
                        local kInterval = {40, 30, 24, 24, 20};
                        local kCount = {5, 7, 9, 7, 9};
                        local kBaseSpeed = {5, 5.5, 6, 6, 7};
                        local target = (aimed)();
                        local delta = (target - (enemy).secondaryAngle16);
                        if (delta > 32768) then
                            delta = (delta - 65536)
                        end;
                        if (delta < (-32768)) then
                            delta = (delta + 65536)
                        end;
                        (enemy).secondaryAngle16 = (boss09Approach((enemy).secondaryAngle16, target, (trunc(math.abs(delta) / 20) + 48)) % 65536);
                        (enemy).sourceAngle16 = (boss09Angle(((enemy).secondaryAngle16 + trunc((math.sin(((timer * kBoss09Tau) / 71)) * 1234)))) % 65536);
                        local index = difficulty;
                        if (((timer >= 10) and (timer < 330)) and (math.fmod((timer - 10), (kInterval)[index + 1]) == 0)) then
                            do
                                local speed = ((kBaseSpeed)[index + 1] - (timer * 0.0080000000000000002));
                                ctx:spawnProjectileSpread(8, 0, shotX, shotY, (enemy).sourceAngle16, f32(10), speed, 1, (kCount)[index + 1], 12000, 0);
                                if (difficulty > 2) then
                                    do
                                        local insetCount = ((kCount)[index + 1] - 1);
                                        local insetSpread = (trunc(12000 / insetCount) * (insetCount - 1));
                                        ctx:spawnProjectileSpread(8, 0, shotX, shotY, (enemy).sourceAngle16, f32(10), (speed + 1), 1, insetCount, insetSpread, 0)
                                    end
                                end;
                                fired = true
                            end
                        end
                    end
                else
                    if ((type == 212) or (type == 213)) then
                        do
                            local kGrowthInterval = {32, 24, 20, 16, 16};
                            local kBaseCount = {9, 13, 15, 15, 17};
                            local kBaseSpeed = {4, 4.5, 5, 5, 6.4000000000000004};
                            (enemy).sourceAngle16 = (boss09Approach((enemy).sourceAngle16, (aimed)(), 24) % 65536);
                            local index = difficulty;
                            if (((timer >= 10) and (timer < 320)) and (math.fmod((timer - 10), 4) == 0)) then
                                do
                                    local count = ((kBaseCount)[index + 1] + trunc((timer - 10) / (kGrowthInterval)[index + 1]));
                                    ctx:spawnProjectileSpread((function() if (type == 212) then return 13 else return 12 end end)(), 0, shotX, shotY, (enemy).sourceAngle16, f32(10), ((kBaseSpeed)[index + 1] + (timer * 0.01)), 1, count, 65536, 0);
                                    fired = true
                                end
                            end
                        end
                    else
                        if ((type == 214) or (type == 215)) then
                            do
                                local kInterval = {14, 10, 8, 8, 7};
                                local kCount = {2, 3, 3, 4, 5};
                                local kTurn = {120, 160, 200, 200, 250};
                                local index = difficulty;
                                if (((timer >= 10) and (timer < 720)) and (math.fmod((timer - 10), (kInterval)[index + 1]) == 0)) then
                                    do
                                        local baseSpeed = (function() if (difficulty == 4) then return 6 else return 5 end end)();
                                        do
                                            local i = 0
                                            while (i < (kCount)[index + 1]) do
                                                do
                                                    local offset = ((i * 320) * (function() if (type == 214) then return (-1) else return 1 end end)());
                                                    ctx:spawnProjectileSpread(9, 0, shotX, shotY, boss09Angle(((enemy).sourceAngle16 + offset)), f32(10), (baseSpeed + (i * 1.5)), 1, 1, 0, 0)
                                                end
                                                ::__continue27::
                                                i = i + 1
                                            end
                                            ::__loop_end26::
                                        end;
                                        fired = true
                                    end
                                end;
                                (enemy).sourceAngle16 = (boss09Angle(((enemy).sourceAngle16 + (function() if (type == 214) then return (kTurn)[index + 1] else return (-(kTurn)[index + 1]) end end)())) % 65536)
                            end
                        else
                            if (type == 216) then
                                do
                                    local kInterval = {120, 100, 80, 80, 60};
                                    local kSpeed = {6, 7, 7.5, 6, 7.5};
                                    local target = (aimed)();
                                    local delta = (target - (enemy).sourceAngle16);
                                    if (delta > 32768) then
                                        delta = (delta - 65536)
                                    end;
                                    if (delta < (-32768)) then
                                        delta = (delta + 65536)
                                    end;
                                    (enemy).sourceAngle16 = (boss09Approach((enemy).sourceAngle16, target, (trunc(math.abs(delta) / 20) + 48)) % 65536);
                                    local index = difficulty;
                                    if (((timer >= 30) and (timer < 600)) and (math.fmod((timer - 30), (kInterval)[index + 1]) == 0)) then
                                        do
                                            ctx:spawnProjectileSpread(12, 0, shotX, shotY, (enemy).sourceAngle16, f32(10), (kSpeed)[index + 1], 1, 1, 0, 0);
                                            if (difficulty > 2) then
                                                do
                                                    ctx:spawnProjectileSpread(12, 0, shotX, shotY, (enemy).sourceAngle16, f32(10), ((kSpeed)[index + 1] + 3), 1, 1, 0, 0)
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
    end;
    if fired then
        ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
    end;
    if (timer >= lifetime) then
        do
            (enemy).helperState = 2;
            (enemy).helperTimer = 0
        end
    end
end

M.updateStage09Boss = function(ctx, enemy)
    (enemy).vx = f32(f32(0));
    (enemy).vy = f32(f32(0));
    (enemy).drawBodyThisFrame = true;
    (enemy).drawMarkerThisFrame = false;
    (enemy).drawHp = (enemy).hp;
    local difficulty = cpp.clamp(((ctx).config_).difficulty, 0, 4);
    local state = (enemy).helperState;
    local timer = (enemy).helperTimer;
    if ((state == 11) or (state == 111)) then
        do
            (enemy).angle = f32(f32(((enemy).angle + f32((f32(timer) * f32(0.00999999977))))))
        end
    end;
    local aimed = function()
        do return boss09AngleTo((enemy).x, (enemy).y, ((ctx).player_).x, ((ctx).player_).y) end
    end;
    local playBoss4 = function()
        if (((ctx).bossBgmHandles_)[2 + 1] ~= (-1)) then
            ctx:audio("StopSoundMem", ((ctx).bossBgmHandles_)[2 + 1])
        end;
        (ctx).activeBossBgmIndex_ = 3;
        if (((ctx).bossBgmHandles_)[3 + 1] ~= (-1)) then
            do
                ctx:audio("ChangeVolumeSoundMem", trunc((((ctx).config_).bgmVolume * 25.5)), ((ctx).bossBgmHandles_)[3 + 1]);
                ctx:audio("PlaySoundMem", ((ctx).bossBgmHandles_)[3 + 1], DX_PLAYTYPE_LOOP, TRUE)
            end
        end
    end;
    local openPhase = function(nextState, hp, countdown, phaseIndex)
        (enemy).helperState = nextState;
        (enemy).helperTimer = 0;
        (enemy).hp = hp;
        (enemy).maxHp = hp;
        (enemy).drawHp = hp;
        (enemy).sourceHitPoints = hp;
        (enemy).targetable = true;
        (enemy).targetableTimer = 0;
        (ctx).lateStageBossMaxHp_ = hp;
        (ctx).lateStageBossCountdown_ = countdown;
        (ctx).lateStageBossCountdownDraw_ = countdown;
        (ctx).lateStageBossPhaseMode_ = 1;
        (ctx).lateStageBossPhaseIndex_ = phaseIndex
    end;
    local spawnPolarNode = function(spawnType, index, offsetAngle, distance, sourceAngle)
        offsetAngle = (offsetAngle % 65536);
        distance = f32(distance);
        sourceAngle = (sourceAngle % 65536);
        local radians = boss09Radians(offsetAngle);
        do return ctx:spawnStage09BossNode(enemy, spawnType, index, f32((math.cos(radians) * distance)), f32((math.sin(radians) * distance)), sourceAngle, 0, 30, true) end
    end;
    local shieldEligible = (boss09CombatState(state) and ((ctx).lateStageBossPhaseMode_ == 1));
    if shieldEligible then
        do
            local specialActive = ((((ctx).player_).bombLock > 0) or (((ctx).player_).bombLock < (-100)));
            if ((not (enemy).guardSpawnLatched) and specialActive) then
                do
                    ctx:spawnStage09BossNode(enemy, 195, 0, f32(0), f32(0), (0 % 65536), 0, 120, true);
                    (enemy).guardSpawnLatched = true
                end
            end;
            if (enemy).guardSpawnLatched then
                do
                    (enemy).targetable = false;
                    if (((ctx).player_).invulnerableFrames < 61) then
                        do
                            (enemy).guardSpawnLatched = false;
                            (enemy).targetable = true
                        end
                    end
                end
            end
        end
    end;
    if ((((ctx).lateStageBossPhaseMode_ == 1) and boss09CombatState(state)) and (((enemy).hp < 1) or ((ctx).lateStageBossCountdown_ < 1))) then
        do
            (enemy).targetable = false;
            (enemy).targetableTimer = 0;
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
            local remaining = (ctx).lateStageBossBreaksRemaining_;
            if (remaining >= 4) then
                do
                    (enemy).helperState = 5;
                    (ctx).lateStageBossPhaseMode_ = 2
                end
            else
                if (remaining == 3) then
                    do
                        (enemy).helperState = 10;
                        (ctx).lateStageBossPhaseMode_ = 2
                    end
                else
                    if (remaining == 2) then
                        do
                            (enemy).helperState = (function() if (difficulty < 4) then return 60 else return 160 end end)();
                            (ctx).lateStageBossPhaseMode_ = 2
                        end
                    else
                        do
                            (enemy).helperState = (function() if (difficulty < 4) then return 99 else return 199 end end)();
                            (ctx).lateStageBossPhaseMode_ = (-1);
                            (ctx).lateStageClearStarted_ = true;
                            (ctx).lateStageClearTimer_ = (-120);
                            ((ctx).player_).invulnerableFrames = math.max(((ctx).player_).invulnerableFrames, 360)
                        end
                    end
                end
            end;
            (enemy).helperTimer = 0;
            (enemy).helperState = math.max(0, (enemy).helperState);
            (enemy).guardSpawnLatched = false;
            (ctx).lateStageBossBreaksRemaining_ = math.max(0, (remaining - 1));
            (ctx).lateStageBossPhaseIndex_ = math.min(3, ((ctx).lateStageBossPhaseIndex_ + 1));
            do return end
        end
    end;
    do
        local __switch29 = state
        if __switch29 == 0 then goto __case30
        elseif __switch29 == 1 then goto __case31
        elseif __switch29 == 5 then goto __case32
        elseif __switch29 == 6 then goto __case33
        elseif __switch29 == 10 then goto __case38
        elseif __switch29 == 60 then goto __case39
        elseif __switch29 == 160 then goto __case40
        elseif __switch29 == 99 then goto __case41
        elseif __switch29 == 199 then goto __case42
        else goto __case43 end
        ::__case30::;
        (enemy).targetable = false;
        if (timer == 0) then
            ctx:playPlayerSound((ctx).bossSe8SoundHandle_, 25)
        end;
        if (timer >= 240) then
            (openPhase)(1, 100000, 2400, 0)
        end;
        goto __switch_end28;
        ::__case31::;
        do
            (enemy).x = f32(f32(((enemy).originX + f32((math.sin(((timer * kBoss09Tau) / 151)) * 10)))));
            (enemy).y = f32(f32(((enemy).originY + f32((math.sin(((timer * kBoss09Tau) / 127)) * 10)))));
            if (timer > 9) then
                do
                    local cycle = math.fmod((timer - 10), 1600);
                    local kCeInterval = {90, 70, 60, 48, 40};
                    if ((cycle < 780) and (math.fmod(cycle, (kCeInterval)[difficulty + 1]) == 0)) then
                        do
                            local random = boss09Rand(timer);
                            local offsetAngle = boss09Angle(math.fmod(random, 65537));
                            local distance = f32((f32(30) + f32(math.fmod(random, 51))));
                            local radians = boss09Radians(offsetAngle);
                            local ox = f32((math.cos(radians) * distance));
                            local oy = f32((math.sin(radians) * distance));
                            local sourceAngle = boss09Angle((boss09AngleTo(f32(((enemy).x + ox)), f32(((enemy).y + oy)), ((ctx).player_).x, ((ctx).player_).y) - 32768));
                            (spawnPolarNode)(206, cycle, offsetAngle, distance, sourceAngle)
                        end
                    end;
                    if (((cycle >= 90) and (cycle < 330)) and (math.fmod((cycle - 90), 30) == 0)) then
                        do
                            (spawnPolarNode)(207, cycle, boss09Angle(((cycle * 150) - 29884)), f32(120), boss09Angle(((-5884) - (cycle * 50))))
                        end
                    end;
                    if (((cycle >= 360) and (cycle < 600)) and (math.fmod((cycle - 360), 30) == 0)) then
                        do
                            (spawnPolarNode)(208, cycle, boss09Angle((37616 - (cycle * 150))), f32(120), boss09Angle((25152 + (cycle * 50))))
                        end
                    end;
                    if (cycle == 810) then
                        do
                            ctx:spawnStage09BossNode(enemy, 211, cycle, f32(0), f32((-f32(100))), (16384 % 65536), 0, 30, true)
                        end
                    end;
                    local fixedAim = boss09AngleTo(f32(360), f32((-f32(100))), ((ctx).player_).x, ((ctx).player_).y);
                    local satelliteOffset = boss09Angle(((cycle * 60) + 31520));
                    local phase = ((cycle * 55) + 19336);
                    if (((cycle >= 840) and (cycle < 1110)) and (math.fmod((cycle - 840), 40) == 0)) then
                        do
                            (spawnPolarNode)(209, cycle, satelliteOffset, f32(120), boss09Angle(((fixedAim + phase) - 24000)))
                        end
                    end;
                    if (((cycle >= 850) and (cycle < 1110)) and (math.fmod((cycle - 850), 40) == 0)) then
                        do
                            (spawnPolarNode)(210, cycle, satelliteOffset, f32(120), boss09Angle(((fixedAim - phase) + 24000)))
                        end
                    end;
                    if (cycle == 1240) then
                        do
                            ctx:spawnStage09BossNode(enemy, 212, cycle, f32(60), f32(20), (49152 % 65536), 0, 30, true);
                            ctx:spawnStage09BossNode(enemy, 213, cycle, f32((-f32(60))), f32((-f32(20))), (49152 % 65536), 0, 30, true)
                        end
                    end
                end
            end;
            goto __switch_end28
        end;
        ::__case32::;
        do
            (enemy).targetable = false;
            if (timer == 1) then
                ctx:spawnStage02DeathExplosionChain(enemy)
            end;
            if (timer < 120) then
                do
                    local t = boss09Smooth((timer / 120));
                    (enemy).x = f32(f32(((enemy).x + f32((f32((f32(360) - (enemy).x)) * f32((0.040000000000000001 + (t * 0.059999999999999998))))))));
                    (enemy).y = f32(f32(((enemy).y + f32((f32((f32(190) - (enemy).y)) * f32((0.040000000000000001 + (t * 0.059999999999999998))))))))
                end
            end;
            if (timer >= 150) then
                (openPhase)(6, 100000, 2400, 1)
            end;
            goto __switch_end28
        end;
        ::__case33::;
        do
            (enemy).x = f32(f32(((enemy).originX + f32((math.sin((((ctx).frame_ * kBoss09Tau) / 151)) * 10)))));
            (enemy).y = f32(f32(((enemy).originY + f32((math.sin((((ctx).frame_ * kBoss09Tau) / 127)) * 10)))));
            if (timer > 9) then
                do
                    local cycle = math.fmod((timer - 10), 1600);
                    if (cycle == 0) then
                        do
                            local kSourceOffsets = {0, (-26768), (-6000), 29768, 3000, (-32768)};
                            do
                                local i = 0
                                while (i < 6) do
                                    do
                                        local type = (function() if (bit.band(i, 1) == 0) then return 214 else return 215 end end)();
                                        local offsetAngle = boss09Angle((i * 10922));
                                        local sourceAngle = boss09Angle(((i * 10922) + (kSourceOffsets)[i + 1]));
                                        (spawnPolarNode)(type, i, offsetAngle, f32(110), sourceAngle)
                                    end
                                    ::__continue35::
                                    i = i + 1
                                end
                                ::__loop_end34::
                            end;
                            ctx:playPlayerSound((ctx).bullet2SoundHandle_, 19)
                        end
                    end;
                    if (cycle == 120) then
                        do
                            do
                                local i = 0
                                while (i < 6) do
                                    do
                                        local offsetAngle = boss09Angle(((i * 10922) + 5461));
                                        local radians = boss09Radians(offsetAngle);
                                        local ox = f32((math.cos(radians) * 80));
                                        local oy = f32((math.sin(radians) * 80));
                                        local angle = boss09AngleTo(f32(((enemy).x + ox)), f32(((enemy).y + oy)), ((ctx).player_).x, ((ctx).player_).y);
                                        ctx:spawnStage09BossNode(enemy, 216, i, ox, oy, boss09Angle((angle - 32768)), 0, 30, true)
                                    end
                                    ::__continue37::
                                    i = i + 1
                                end
                                ::__loop_end36::
                            end;
                            ctx:playPlayerSound((ctx).bullet2SoundHandle_, 19)
                        end
                    end;
                    local ceInterval = (function() if (difficulty == 0) then return 60 else return 40 end end)();
                    if (((cycle >= 780) and (cycle < 880)) and (math.fmod((cycle - 780), ceInterval) == 0)) then
                        do
                            local random = boss09Rand(timer);
                            local offsetAngle = boss09Angle(math.fmod(random, 65537));
                            local distance = f32((f32(30) + f32(math.fmod(random, 81))));
                            local radians = boss09Radians(offsetAngle);
                            local ox = f32((math.cos(radians) * distance));
                            local oy = f32((math.sin(radians) * distance));
                            local sourceAngle = boss09Angle((boss09AngleTo(f32(((enemy).x + ox)), f32(((enemy).y + oy)), ((ctx).player_).x, ((ctx).player_).y) - 32768));
                            (spawnPolarNode)(206, cycle, offsetAngle, distance, sourceAngle)
                        end
                    end;
                    local d9Interval = {10, 8, 7, 8, 7};
                    if (((cycle >= 920) and (cycle < 1540)) and (math.fmod((cycle - 920), (d9Interval)[difficulty + 1]) == 0)) then
                        do
                            local random = boss09Rand(timer);
                            local offsetAngle = boss09Angle(math.fmod(random, 65537));
                            local distance = f32((f32(30) + f32(math.fmod(random, 81))));
                            local radians = boss09Radians(offsetAngle);
                            local ox = f32((math.cos(radians) * distance));
                            local oy = f32((math.sin(radians) * distance));
                            local sourceAngle = boss09Angle(((boss09AngleTo(f32(((enemy).x + ox)), f32(((enemy).y + oy)), ((ctx).player_).x, ((ctx).player_).y) + math.fmod(random, 18001)) - 9000));
                            (spawnPolarNode)(217, cycle, offsetAngle, distance, sourceAngle)
                        end
                    end
                end
            end;
            goto __switch_end28
        end;
        ::__case38::;
        (enemy).targetable = false;
        if ((((timer == 1) or (timer == 60)) or (timer == 120)) or (timer == 240)) then
            do
                ctx:spawnStage02DeathExplosionChain(enemy)
            end
        end;
        if (timer == 320) then
            (playBoss4)()
        end;
        if (timer >= 540) then
            do
                if (difficulty < 4) then
                    (openPhase)(11, 200000, 5400, 2)
                else
                    (openPhase)(111, 180000, 5400, 2)
                end
            end
        end;
        goto __switch_end28;
        ::__case39::;
        ::__case40::;
        (enemy).targetable = false;
        if (timer == 0) then
            do
                ctx:playPlayerSound((ctx).bossSe6SoundHandle_, 25);
                (enemy).sourceSpeed = 0.29999999999999999
            end
        end;
        if (timer < 50) then
            do
                local angle = ((timer * kBoss09Tau) / 50);
                (enemy).x = f32(f32((f32(360) + f32(((math.cos(angle) * (50 - timer)) * 2)))));
                (enemy).y = f32(f32((f32(190) + f32(((math.sin(angle) * (50 - timer)) * 2)))))
            end
        else
            do
                (enemy).sourceAngle16 = (boss09Approach((enemy).sourceAngle16, (aimed)(), 768) % 65536);
                local radians = boss09Radians((enemy).sourceAngle16);
                (enemy).x = f32(f32(((enemy).x + f32((math.cos(radians) * 0.29999999999999999)))));
                (enemy).y = f32(f32(((enemy).y + f32((math.sin(radians) * 0.29999999999999999)))))
            end
        end;
        if (timer >= 150) then
            do
                if (state == 60) then
                    (openPhase)(61, 150000, 6000, 3)
                else
                    (openPhase)(161, 180000, 7680, 3)
                end
            end
        end;
        goto __switch_end28;
        ::__case41::;
        ::__case42::;
        (enemy).targetable = false;
        if ((timer < 240) and (math.fmod(timer, 3) == 0)) then
            do
                ctx:spawnStage02DeathExplosionChain(enemy)
            end
        end;
        (enemy).y = f32(f32(((enemy).y + f32(0.200000003))));
        if (timer == 240) then
            do
                ctx:playPlayerSound((ctx).blast2SoundHandle_, 25);
                ctx:spawnEnemyDeathEffects(enemy, 2, true)
            end
        end;
        if (timer >= 600) then
            do
                ctx:clearLateStageGate(9);
                (enemy).active = false
            end
        end;
        goto __switch_end28;
        ::__case43::;
        if boss09NormalMoveState(state) then
            do
                local __pair44 = boss09NormalMoveTarget(state)
                local targetX = __pair44[1]
                local targetY = __pair44[2];
                local duration = boss09NormalMoveDuration(state);
                if (timer == 0) then
                    do
                        (enemy).originX = f32((enemy).x);
                        (enemy).originY = f32((enemy).y)
                    end
                end;
                if (timer == 8) then
                    do
                        (enemy).secondaryAngle16 = (boss09AngleTo((enemy).x, (enemy).y, targetX, targetY) % 65536);
                        ctx:playPlayerSound((ctx).bossSe1SoundHandle_, 19)
                    end
                end;
                local moveT = boss09SineEase((cpp.clamp((timer - 8), 0, 8) / 8));
                (enemy).x = f32(f32(((enemy).originX + f32((f32((targetX - (enemy).originX)) * f32(moveT))))));
                (enemy).y = f32(f32(((enemy).originY + f32((f32((targetY - (enemy).originY)) * f32(moveT))))));
                if (timer == 20) then
                    do
                        local kCount = {21, 27, 31, 31, 31};
                        local kSpeed = {6, 7, 8, 8, 8};
                        local count = (kCount)[difficulty + 1];
                        if (difficulty >= 3) then
                            do
                                ctx:spawnProjectileSpread(5, 0, (enemy).x, (enemy).y, boss09Angle(trunc(65536 / (count * 2))), f32((-f32(30))), 4, 1, count, 65536, 0)
                            end
                        end;
                        ctx:spawnProjectileSpread(3, 0, (enemy).x, (enemy).y, (0 % 65536), f32((-f32(30))), (kSpeed)[difficulty + 1], 1, count, 65536, 0);
                        ctx:playPlayerSound((ctx).bullet1SoundHandle_, 19)
                    end
                end;
                if (timer >= duration) then
                    do
                        (enemy).helperState = ((enemy).helperState + 1);
                        (enemy).helperTimer = 0;
                        (enemy).originX = f32((enemy).x);
                        (enemy).originY = f32((enemy).y);
                        (enemy).sourceSpeed = 0.5
                    end
                end
            end
        else
            if boss09CombatState(state) then
                do
                    if (state == 11) then
                        do
                            (enemy).sourceSpeed = boss09EaseBetween(timer, 60, 240, 0.10000000000000001, 3)
                        end
                    else
                        if (state == 24) then
                            do
                                (enemy).sourceSpeed = boss09EaseBetween(timer, 0, 120, 0.5, 3)
                            end
                        else
                            if (state == 25) then
                                do
                                    (enemy).sourceSpeed = boss09EaseBetween(timer, 0, 60, 3, 0.5)
                                end
                            else
                                if (state == 26) then
                                    do
                                        (enemy).sourceSpeed = boss09ReverseEaseBetween(timer, 0, 1150, 0.5, 3)
                                    end
                                else
                                    if ((state == 111) or (state == 117)) then
                                        do
                                            (enemy).sourceSpeed = boss09EaseBetween(timer, 60, 480, 0.10000000000000001, 2)
                                        end
                                    else
                                        if (state == 112) then
                                            do
                                                (enemy).sourceSpeed = boss09ReverseEaseBetween(timer, 0, 60, 2, 0.5)
                                            end
                                        else
                                            if (state == 113) then
                                                do
                                                    (enemy).sourceSpeed = boss09EaseBetween(timer, 0, 180, 0.5, 2.3999999999999999)
                                                end
                                            else
                                                if (state == 116) then
                                                    do
                                                        (enemy).sourceSpeed = boss09EaseBetween(timer, 600, 1150, 2.3999999999999999, 0.10000000000000001)
                                                    end
                                                else
                                                    if (state == 161) then
                                                        do
                                                            (enemy).sourceSpeed = boss09EaseBetween(timer, 0, 300, 0.29999999999999999, 2.3999999999999999)
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
                    if (math.fmod((ctx).frame_, 50) == 0) then
                        do
                            (ctx).lateStageBossTargetX_ = f32(f32((f32(210) + f32(math.fmod(boss09Rand((ctx).frame_), 301)))));
                            local targetYBase = (function() if ((state == 25) or (state == 112)) then return f32(200) else return f32(150) end end)();
                            (ctx).lateStageBossTargetY_ = f32(f32((targetYBase + f32(math.fmod(boss09Rand(((ctx).frame_ + ((ctx).selectedStage_ * 999))), 101)))))
                        end
                    end;
                    local target = boss09AngleTo((enemy).x, (enemy).y, (ctx).lateStageBossTargetX_, (ctx).lateStageBossTargetY_);
                    (enemy).sourceAngle16 = (boss09Approach((enemy).sourceAngle16, target, 768) % 65536);
                    ctx:emitStage09BossProjectiles(enemy);
                    local radians = boss09Radians((enemy).sourceAngle16);
                    (enemy).x = f32(f32(((enemy).x + f32((math.cos(radians) * (enemy).sourceSpeed)))));
                    (enemy).y = f32(f32(((enemy).y + f32((math.sin(radians) * (enemy).sourceSpeed)))));
                    local nextState = (-1);
                    do
                        local __switch46 = state
                        if __switch46 == 11 then goto __case47
                        elseif __switch46 == 27 then goto __case48
                        elseif __switch46 == 17 then goto __case49
                        elseif __switch46 == 23 then goto __case50
                        elseif __switch46 == 24 then goto __case51
                        elseif __switch46 == 25 then goto __case52
                        elseif __switch46 == 26 then goto __case53
                        elseif __switch46 == 111 then goto __case54
                        elseif __switch46 == 117 then goto __case55
                        elseif __switch46 == 112 then goto __case56
                        elseif __switch46 == 113 then goto __case57
                        elseif __switch46 == 114 then goto __case58
                        elseif __switch46 == 115 then goto __case59
                        elseif __switch46 == 116 then goto __case60
                        else goto __case61 end
                        ::__case47::;
                        ::__case48::;
                        if (timer >= 900) then
                            nextState = 12
                        end;
                        goto __switch_end45;
                        ::__case49::;
                        if (timer >= 140) then
                            nextState = 18
                        end;
                        goto __switch_end45;
                        ::__case50::;
                        if (timer >= 440) then
                            nextState = 24
                        end;
                        goto __switch_end45;
                        ::__case51::;
                        if (timer >= 350) then
                            nextState = 25
                        end;
                        goto __switch_end45;
                        ::__case52::;
                        if (timer >= 1120) then
                            nextState = 26
                        end;
                        goto __switch_end45;
                        ::__case53::;
                        if (timer >= 1150) then
                            nextState = 27
                        end;
                        goto __switch_end45;
                        ::__case54::;
                        ::__case55::;
                        if (timer >= 900) then
                            nextState = 112
                        end;
                        goto __switch_end45;
                        ::__case56::;
                        if (timer >= 580) then
                            nextState = 113
                        end;
                        goto __switch_end45;
                        ::__case57::;
                        if (timer >= 600) then
                            nextState = 114
                        end;
                        goto __switch_end45;
                        ::__case58::;
                        if (timer >= 560) then
                            nextState = 115
                        end;
                        goto __switch_end45;
                        ::__case59::;
                        if (timer >= 600) then
                            nextState = 116
                        end;
                        goto __switch_end45;
                        ::__case60::;
                        if (timer >= 1150) then
                            nextState = 117
                        end;
                        goto __switch_end45;
                        ::__case61::;
                        goto __switch_end45
                        ::__switch_end45::
                    end;
                    if ((((state == 61) and ((enemy).hp < trunc((enemy).maxHp / 2))) and (timer > 100)) and (math.fmod((timer - 100), 360) == 170)) then
                        do
                            (enemy).helperState = 62
                        end
                    end;
                    if (nextState >= 0) then
                        do
                            (enemy).helperState = nextState;
                            (enemy).helperTimer = 0;
                            (enemy).originX = f32((enemy).x);
                            (enemy).originY = f32((enemy).y)
                        end
                    end
                end
            end
        end;
        goto __switch_end28
        ::__switch_end28::
    end;
    local currentState = (enemy).helperState;
    local trailState = ((currentState < 60) or ((currentState >= 111) and (currentState < 160)));
    local trailReady = ((currentState ~= 5) and ((currentState ~= 0) or ((enemy).helperTimer >= 190)));
    if ((trailState and trailReady) and (((ctx).player_).invulnerableFrames < 61)) then
        do
            local interval = (function() if (currentState < 5) then return 50 else return 25 end end)();
            if (((enemy).helperTimer >= 0) and (math.fmod((enemy).helperTimer, interval) == 0)) then
                do
                    local random = boss09Rand((ctx).frame_);
                    local distance = (150 + math.fmod(random, 131));
                    local offsetAngle = boss09Angle((math.fmod(random, 32769) - 32768));
                    local radians = boss09Radians(offsetAngle);
                    local spawnX = f32(((enemy).x + f32((math.cos(radians) * distance))));
                    local spawnY = f32((f32(((enemy).y + f32(70))) + f32((math.sin(radians) * distance))));
                    local angle = boss09Angle(math.fmod(random, 65537));
                    ctx:spawnStage09BossNode(enemy, 205, (enemy).helperTimer, spawnX, spawnY, angle, 0.20000000000000001, 40, false)
                end
            end
        end
    end;
    (enemy).drawHp = (enemy).hp;
    (ctx).lateStageBossCountdownDraw_ = (ctx).lateStageBossCountdown_;
    if (((ctx).lateStageBossPhaseMode_ == 1) and boss09CombatState((enemy).helperState)) then
        do
            ctx:updateBossCountdownAudio((enemy).hp, (ctx).lateStageBossCountdown_);
            if ((ctx).lateStageBossCountdown_ > 0) then
                (ctx).lateStageBossCountdown_ = (ctx).lateStageBossCountdown_ - 1
            end
        end
    end
end

cpp.install(M)

return M
