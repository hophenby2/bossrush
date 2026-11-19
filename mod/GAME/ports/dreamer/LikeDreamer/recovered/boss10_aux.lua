-- 由 tools/generate_likedreamer_native_bosses.py 从本地复原源码生成。

-- 生成物是普通 Lua 状态机；修改源逻辑或生成规则后重新生成并核对轨迹。

local cpp = assert(LikeDreamer.Recovered)

local f32, trunc, u32, s16 = cpp.f32, cpp.trunc, cpp.u32, cpp.s16

local bit = require("bit")

local M = {}

local kPi = 3.1415926535897931

local kTau = (kPi * 2)

local kEntityCap = 512

local angle16

local radians16

local angleTo

local scriptRand

local scriptAngle

local scriptRandomHundredth

local paletteColor

local frameHandle

local isMaterializingEmitter

local isPhase151Emitter

angle16 = function(value)
    do return (bit.band(value, 65535) % 65536) end
end

radians16 = function(value)
    value = (value % 65536);
    do return ((value * kTau) / 65536) end
end

angleTo = function(x0, y0, x1, y1)
    x0 = f32(x0);
    y0 = f32(y0);
    x1 = f32(x1);
    y1 = f32(y1);
    do return angle16(trunc(((math.atan2(f32((y1 - y0)), f32((x1 - x0))) * 65536) / kTau))) end
end

scriptRand = function(seed)
    seed = u32(seed);
    local u = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(seed, 30)), seed)), 1812433253) + 1));
    local a = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(u, 30)), u)), 1812433253) + 2));
    local b = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(a, 30)), a)), 1812433253) + 3));
    local c = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(b, 30)), b)), 1812433253) + 4));
    local mixed = u32(bit.bxor(cpp.mul32(u, 2048), u));
    do return u32(bit.bxor(u32(bit.bxor(u32(bit.rshift(u32(bit.bxor(u32(bit.rshift(c, 11)), mixed)), 8)), c)), mixed)) end
end

scriptAngle = function(seed)
    seed = u32(seed);
    local value = scriptRand(seed);
    do return angle16((s16(value) - s16(trunc(value / 65537)))) end
end

scriptRandomHundredth = function(seed, minimum100, maximum100)
    seed = u32(seed);
    do return ((minimum100 + math.fmod(scriptRand(seed), u32(((maximum100 - minimum100) + 1)))) / 100) end
end

paletteColor = function(index)
    local kColors = {{255, 120, 120}, {255, 200, 110}, {255, 255, 120}, {120, 255, 120}, {120, 255, 255}, {120, 120, 255}, {220, 120, 255}};
    do return (kColors)[math.fmod(index, 7) + 1] end
end

frameHandle = function(frames, index)
    do return (function() if ((index >= 0) and (index < (#frames))) then return (frames)[index + 1] else return (-1) end end)() end
end

isMaterializingEmitter = function(spawnType)
    do return ((((spawnType >= 261) and (spawnType <= 267)) or (spawnType == 271)) or (spawnType == 272)) end
end

isPhase151Emitter = function(spawnType)
    do return ((spawnType >= 302) and (spawnType <= 309)) end
end

M.isStage10FinalBossEmitterType = function(ctx, spawnType)
    do return ((((((spawnType >= 261) and (spawnType <= 272)) or (spawnType == 291)) or (spawnType == 292)) or ((spawnType >= 296) and (spawnType <= 300))) or isPhase151Emitter(spawnType)) end
end

M.spawnStage10FinalBossEmitter = function(ctx, parent, spawnType, targetX, targetY, angle, speed, childIndex)
    targetX = f32(targetX);
    targetY = f32(targetY);
    angle = (angle % 65536);
    if ((not ctx:isStage10FinalBossEmitterType(spawnType)) or (((#(ctx).enemies_) + (#(ctx).pendingEnemies_)) >= kEntityCap)) then
        do
            do return false end
        end
    end;
    local updateCase = (-1);
    if (spawnType <= 267) then
        updateCase = 138
    else
        if (spawnType <= 270) then
            updateCase = 139
        else
            if (spawnType <= 272) then
                updateCase = 140
            else
                if (spawnType <= 292) then
                    updateCase = 151
                else
                    if (spawnType <= 298) then
                        updateCase = 154
                    else
                        if (spawnType <= 300) then
                            updateCase = 155
                        else
                            updateCase = 157
                        end
                    end
                end
            end
        end
    end;
    local node = cpp.newEnemy();
    (node).entityId = (function() local __old = (ctx).nextEntityId_; (ctx).nextEntityId_ = (ctx).nextEntityId_ + 1; return __old end)();
    (node).spawnType = spawnType;
    (node).updateCase = updateCase;
    (node).sourceHitPoints = (function() if (spawnType >= 302) then return 10 else return 99999999 end end)();
    (node).sourceX = cpp.lround(targetX);
    (node).sourceY = cpp.lround(targetY);
    (node).sourceNote = "S10 recovered final-root transient emitter";
    (node).sourceDispatchKind = 0;
    (node).sourceDispatchField = (function() if (spawnType == 291) then return 50 else return (function() if (spawnType == 292) then return 30 else return (function() if (spawnType >= 291) then return 40 else return 20 end end)() end end)() end end)();
    (node).parentEntityId = (parent).entityId;
    (node).parentSpawnType = (parent).spawnType;
    (node).childIndex = childIndex;
    (node).originX = f32(targetX);
    (node).originY = f32(targetY);
    (node).markerDrawX = f32((parent).x);
    (node).markerDrawY = f32((parent).y);
    if isMaterializingEmitter(spawnType) then
        do
            (node).x = f32((parent).x);
            (node).y = f32((parent).y);
            (node).helperState = 0
        end
    else
        do
            (node).x = f32(targetX);
            (node).y = f32(targetY);
            (node).helperState = (function() if (spawnType == 270) then return 0 else return 1 end end)()
        end
    end;
    (node).sourceAngle16 = (angle % 65536);
    (node).secondaryAngle16 = (angle % 65536);
    (node).targetAngle16 = (angle % 65536);
    (node).angle = f32(f32(radians16(angle)));
    (node).sourceSpeed = speed;
    (node).speed = f32(f32(speed));
    (node).hp = 99999999;
    (node).maxHp = (node).hp;
    (node).drawHp = (node).hp;
    (node).radius = (function() if (spawnType == 291) then return 50 else return (function() if (spawnType == 292) then return 30 else return (function() if (spawnType >= 291) then return 20 else return 8 end end)() end end)() end end)();
    (node).activationDelay = 0;
    (node).rewardWeight = 0;
    (node).targetable = false;
    cpp.push((ctx).pendingEnemies_, node);
    (parent).liveChildCount = (parent).liveChildCount + 1;
    do return true end
end

M.updateStage10FinalBossEmitter = function(ctx, enemy)
    (enemy).vx = f32(f32(0));
    (enemy).vy = f32(f32(0));
    (enemy).drawMarkerThisFrame = false;
    (enemy).drawBodyThisFrame = true;
    (enemy).targetable = false;
    local parent = ctx:findEnemyById((enemy).parentEntityId);
    local release = function()
        if (not (enemy).active) then
            do
                do return end
            end
        end;
        if ((parent ~= nil) and ((parent).liveChildCount > 0)) then
            do
                (parent).liveChildCount = (parent).liveChildCount - 1
            end
        end;
        (enemy).active = false
    end;
    if ((parent == nil) or (not (parent).active)) then
        do
            (release)();
            do return end
        end
    end;
    local type = (enemy).spawnType;
    local timer = (enemy).helperTimer;
    if (isMaterializingEmitter(type) and ((enemy).helperState == 0)) then
        do
            if (timer == 0) then
                do
                    (enemy).markerDrawX = f32((parent).x);
                    (enemy).markerDrawY = f32((parent).y)
                end
            end;
            if ((type == 271) or (type == 272)) then
                do
                    (enemy).originX = f32(f32((f32((((ctx).player_).x / f32(6))) + (function() if (type == 271) then return f32(10) else return f32(590) end end)())))
                end
            end;
            if (timer < 60) then
                do
                    local p = cpp.clamp((timer / 60), 0, 1);
                    local eased = math.sin(((p * kPi) * 0.5));
                    local wobble = (math.sin((p * kPi)) * 100);
                    local direction = radians16(angle16((((((ctx).config_).difficulty * 2) - timer) * 360)));
                    (enemy).x = f32(f32(((enemy).markerDrawX + f32(((f32(((enemy).originX - (enemy).markerDrawX)) * eased) + (math.cos(direction) * wobble))))));
                    (enemy).y = f32(f32(((enemy).markerDrawY + f32(((f32(((enemy).originY - (enemy).markerDrawY)) * eased) + (math.sin(direction) * wobble))))));
                    do return end
                end
            end;
            (enemy).x = f32((enemy).originX);
            (enemy).y = f32((enemy).originY);
            (enemy).helperState = 1;
            (enemy).helperTimer = 0;
            timer = 0
        end
    end;
    local move = function()
        local heading = radians16((enemy).sourceAngle16);
        (enemy).x = f32(f32(((enemy).x + f32((math.cos(heading) * (enemy).sourceSpeed)))));
        (enemy).y = f32(f32(((enemy).y + f32((math.sin(heading) * (enemy).sourceSpeed)))));
        (enemy).speed = f32(f32((enemy).sourceSpeed));
        (enemy).angle = f32(f32(heading))
    end;
    local aim = function(x, y)
        x = f32(x);
        y = f32(y);
        do return angleTo(x, y, ((ctx).player_).x, ((ctx).player_).y) end
    end;
    local horizontalOrigin = f32((((ctx).player_).x / f32(6)));
    local outside = function(node)
        do return (((((node).x < f32((horizontalOrigin - f32(180)))) or ((node).x > f32((horizontalOrigin + f32(780))))) or ((node).y < f32((-f32(180))))) or ((node).y > f32(900))) end
    end;
    local outsideMargin = function(margin)
        margin = f32(margin);
        do return (((((enemy).x < f32((horizontalOrigin + margin))) or ((enemy).x > f32((f32((horizontalOrigin + f32(600))) - margin)))) or ((enemy).y < margin)) or ((enemy).y > f32((f32(720) - margin)))) end
    end;
    local clampToMargin = function(margin)
        margin = f32(margin);
        (enemy).x = f32(cpp.clamp((enemy).x, f32((horizontalOrigin + margin)), f32((f32((horizontalOrigin + f32(600))) - margin))));
        (enemy).y = f32(cpp.clamp((enemy).y, margin, f32((f32(720) - margin))))
    end;
    local fired = false;
    local shotSoundHandle = (-1);
    local shotSoundPriority = 0;
    if ((timer == 0) and (((type >= 261) and (type <= 263)) or ((type >= 268) and (type <= 270)))) then
        do
            ctx:playPlayerSound((ctx).bossSe7SoundHandle_, 19)
        end
    end;
    do
        local __switch2 = type
        if __switch2 == 261 then __switch2 = 1
        elseif __switch2 == 262 then __switch2 = 2
        elseif __switch2 == 263 then __switch2 = 3
        elseif __switch2 == 264 then __switch2 = 4
        elseif __switch2 == 265 then __switch2 = 5
        elseif __switch2 == 266 then __switch2 = 6
        elseif __switch2 == 267 then __switch2 = 7
        elseif __switch2 == 268 then __switch2 = 8
        elseif __switch2 == 269 then __switch2 = 9
        elseif __switch2 == 270 then __switch2 = 10
        elseif __switch2 == 271 then __switch2 = 11
        elseif __switch2 == 272 then __switch2 = 12
        elseif __switch2 == 291 then __switch2 = 13
        elseif __switch2 == 292 then __switch2 = 14
        elseif __switch2 == 296 then __switch2 = 15
        elseif __switch2 == 297 then __switch2 = 16
        elseif __switch2 == 298 then __switch2 = 17
        elseif __switch2 == 299 then __switch2 = 18
        elseif __switch2 == 300 then __switch2 = 19
        else __switch2 = 20 end
        repeat
            if __switch2 <= 1 then
                (enemy).sourceSpeed = ((enemy).sourceSpeed + 0.14999999999999999);
                (move)();
                if (timer == 16) then
                    do
                        ctx:spawnProjectileNode(3, 2, (enemy).x, (enemy).y, (aim)((enemy).x, (enemy).y), f32(0), 7, 1, 0);
                        fired = true
                    end
                end;
                ctx:spawnProjectileNode(4, 15, (enemy).x, (enemy).y, (enemy).sourceAngle16, f32(0), 0, 1, 0);
                do break end;
            end
            if __switch2 <= 2 then
                do
                    if (timer == 0) then
                        do
                            (clampToMargin)(f32((-f32(10))))
                        end
                    end;
                    local sign = (function() if ((enemy).originX < f32(360)) then return (-1) else return 1 end end)();
                    (enemy).sourceAngle16 = (angle16(((enemy).sourceAngle16 + trunc(((math.sin(((timer * kPi) / 60)) * sign) * 360)))) % 65536);
                    (move)();
                    ctx:spawnProjectileNode(4, 16, (enemy).x, (enemy).y, (enemy).sourceAngle16, f32(0), 0, 1, 0);
                    do break end
                end;
            end
            if __switch2 <= 3 then
                (enemy).sourceSpeed = ((enemy).sourceSpeed + 0.070000000000000007);
                (move)();
                if ((((enemy).helperState == 1) and ((enemy).y >= f32(1))) and (outsideMargin)(f32(0))) then
                    do
                        if (((enemy).x < horizontalOrigin) or ((enemy).x > f32((horizontalOrigin + f32(600))))) then
                            do
                                (enemy).sourceAngle16 = (angle16((32768 - (enemy).sourceAngle16)) % 65536)
                            end
                        end;
                        (clampToMargin)(f32(0));
                        (enemy).helperState = (enemy).helperState + 1
                    end
                end;
                ctx:spawnProjectileNode(4, 16, (enemy).x, (enemy).y, (enemy).sourceAngle16, f32(0), 0, 1, 0);
                do break end;
            end
            if __switch2 <= 5 then
                do
                    local oldAngle = (enemy).sourceAngle16;
                    (move)();
                    local direction = (function() if (type == 264) then return 1024 else return (-1024) end end)();
                    (enemy).sourceAngle16 = (angle16((oldAngle + direction)) % 65536);
                    if (bit.band(timer, 1) == 0) then
                        do
                            local base = (function() if (type == 264) then return (oldAngle + 17408) else return (oldAngle - 17408) end end)();
                            do
                                local i = 0
                                while (i < 2) do
                                    do
                                        ctx:spawnProjectileNode(13, 3, (enemy).x, (enemy).y, angle16(((base + 16384) - (i * 32768))), f32(0), 5, 1, 0);
                                        ctx:spawnProjectileNode(13, 3, (enemy).x, (enemy).y, angle16(((base + 24576) + (i * 16384))), f32(0), 6.4000000000000004, 1, 0)
                                    end
                                    i = i + 1
                                end
                            end;
                            ctx:spawnProjectileNode(13, 3, (enemy).x, (enemy).y, angle16(base), f32(0), 5, 1, 0);
                            fired = true;
                            shotSoundHandle = (ctx).bullet1SoundHandle_;
                            shotSoundPriority = 16
                        end
                    end;
                    ctx:spawnProjectileNode(4, 16, (enemy).x, (enemy).y, (enemy).sourceAngle16, f32(0), 0, 1, 0);
                    if (timer == 64) then
                        (release)()
                    end;
                    do break end
                end;
            end
            if __switch2 <= 7 then
                do break end;
            end
            if __switch2 <= 9 then
                do
                    (move)();
                    local sign = (function() if (type == 268) then return (-1) else return 1 end end)();
                    (enemy).sourceAngle16 = (angle16(((enemy).sourceAngle16 + trunc(((math.sin(((timer * kPi) / 38.5)) * sign) * 550)))) % 65536);
                    if (timer == 25) then
                        do
                            ctx:spawnProjectileNode(3, 2, (enemy).x, (enemy).y, (aim)((enemy).x, (enemy).y), f32(0), 6, 1, 0);
                            fired = true;
                            shotSoundHandle = (ctx).bullet2SoundHandle_;
                            shotSoundPriority = 12
                        end
                    end;
                    ctx:spawnProjectileNode(4, 16, (enemy).x, (enemy).y, (enemy).sourceAngle16, f32(0), 0, 1, 0);
                    do break end
                end;
            end
            if __switch2 <= 10 then
                (move)();
                (enemy).sourceSpeed = ((enemy).sourceSpeed + 0.070000000000000007);
                if (((enemy).helperState == 0) and (outsideMargin)(f32(0))) then
                    do
                        local oldAngle = (enemy).sourceAngle16;
                        if (((enemy).x < horizontalOrigin) or ((enemy).x > f32((horizontalOrigin + f32(600))))) then
                            do
                                (enemy).sourceAngle16 = (angle16((32768 - oldAngle)) % 65536)
                            end
                        end;
                        if (((enemy).y < f32(0)) or ((enemy).y > f32(720))) then
                            do
                                (enemy).sourceAngle16 = (angle16((-oldAngle)) % 65536)
                            end
                        end;
                        (clampToMargin)(f32(0));
                        (enemy).helperState = (enemy).helperState + 1
                    end
                end;
                ctx:spawnProjectileNode(4, 15, (enemy).x, (enemy).y, (enemy).sourceAngle16, f32(0), 0, 1, 0);
                do break end;
            end
            if __switch2 <= 12 then
                do
                    (move)();
                    if (((enemy).helperState == 1) or ((enemy).helperState == 3)) then
                        do
                            (enemy).x = f32(f32((horizontalOrigin + (function() if (type == 271) then return f32(10) else return f32(590) end end)())))
                        end
                    end;
                    if (outsideMargin)(f32((-f32(10)))) then
                        do
                            if ((enemy).helperState >= 4) then
                                do
                                    (release)();
                                    do break end
                                end
                            end;
                            (enemy).sourceAngle16 = (angle16(((enemy).sourceAngle16 + (function() if (type == 271) then return 49152 else return 16384 end end)())) % 65536);
                            (clampToMargin)(f32(10));
                            (enemy).helperState = (enemy).helperState + 1
                        end
                    end;
                    if (bit.band(timer, 1) == 0) then
                        do
                            local speed = (5 + (((parent).helperTimer - 90) * 0.0050000000000000001));
                            local visual = (function() if (type == 271) then return 13 else return 12 end end)();
                            local aimed = (aim)((enemy).x, (enemy).y);
                            ctx:spawnProjectileNode(visual, 0, (enemy).x, (enemy).y, aimed, f32(0), speed, 1, 0);
                            ctx:spawnProjectileNode(visual, 0, (enemy).x, (enemy).y, aimed, f32(0), (speed + 1), 1, 0);
                            fired = true;
                            shotSoundHandle = (ctx).bullet1SoundHandle_;
                            shotSoundPriority = 16
                        end
                    end;
                    do break end
                end;
            end
            if __switch2 <= 14 then
                do
                    (move)();
                    local warmup = (function() if (type == 291) then return 50 else return 30 end end)();
                    if (timer < 10) then
                        (enemy).sourceSpeed = 0
                    else
                        if (timer < warmup) then
                            do
                                (enemy).sourceSpeed = (2 * math.sin(((((timer - 10) * kPi) / (warmup - 10)) * 0.5)))
                            end
                        else
                            do
                                (enemy).sourceSpeed = 2
                            end
                        end
                    end;
                    local lifetime = (function() if (type == 291) then return 70 else return 50 end end)();
                    if (timer == lifetime) then
                        do
                            local layers = (function() if (type == 291) then return 5 else return 3 end end)();
                            local projectileId = (function() if (type == 291) then return 58 else return 59 end end)();
                            do
                                local layer = layers
                                while (layer > 0) do
                                    do
                                        local randomAngle = scriptAngle(u32(((parent).helperTimer + (layer * 66))));
                                        local visual = (function() if (layer < (function() if (type == 291) then return 4 else return 3 end end)()) then return 3 else return 2 end end)();
                                        local count = math.max(1, trunc((layer * kTau)));
                                        ctx:spawnProjectileSpread(visual, projectileId, (enemy).x, (enemy).y, randomAngle, f32((f32(layer) * f32(32))), 0, 1, count, 65536, 0)
                                    end
                                    layer = layer - 1
                                end
                            end;
                            ctx:spawnProjectileNode(3, projectileId, (enemy).x, (enemy).y, (0 % 65536), f32(0), 0, 1, 0);
                            fired = true;
                            (release)()
                        end
                    end;
                    do break end
                end;
            end
            if __switch2 <= 15 then
                do
                    local radius = (function() if (timer < 60) then return (600 - (math.sin(((timer * kPi) / 120)) * 600)) else return 0 end end)();
                    local heading = radians16((enemy).sourceAngle16);
                    (enemy).x = f32(f32(((parent).x + f32((math.cos(heading) * radius)))));
                    (enemy).y = f32(f32(((parent).y + f32((math.sin(heading) * radius)))));
                    if (timer == 60) then
                        (release)()
                    end;
                    do break end
                end;
            end
            if __switch2 <= 16 then
                (move)();
                (enemy).y = f32(f32(((enemy).y - f32((f32(timer) * f32(0.200000003))))));
                if (((((enemy).x < f32((horizontalOrigin - f32(50)))) or ((enemy).x > f32((horizontalOrigin + f32(650))))) or ((enemy).y < f32((-f32(50))))) or ((enemy).y > f32(770))) then
                    do
                        (release)()
                    end
                end;
                do break end;
            end
            if __switch2 <= 17 then
                (move)();
                (enemy).sourceSpeed = ((enemy).sourceSpeed + 0.29999999999999999);
                if (((((enemy).x < f32((horizontalOrigin - f32(50)))) or ((enemy).x > f32((horizontalOrigin + f32(650))))) or ((enemy).y < f32((-f32(50))))) or ((enemy).y > f32(770))) then
                    do
                        (release)()
                    end
                end;
                do break end;
            end
            if __switch2 <= 19 then
                do
                    (move)();
                    (enemy).sourceAngle16 = (angle16(((enemy).sourceAngle16 + 1310)) % 65536);
                    (enemy).secondaryAngle16 = (angle16(((enemy).secondaryAngle16 + 2100)) % 65536);
                    if (((type == 300) and (timer < 50)) and (bit.band(timer, 1) == 0)) then
                        do
                            local offset = f32((math.sin(((timer * kTau) / 100)) * 40));
                            local heading = radians16((enemy).sourceAngle16);
                            local sourceX = f32(((enemy).x + f32((math.cos(heading) * offset))));
                            local sourceY = f32(((enemy).y + f32((math.sin(heading) * offset))));
                            ctx:spawnProjectileNode(8, 3, sourceX, sourceY, angle16((((enemy).sourceAngle16 - (timer * 200)) - 9000)), f32(0), 6, 1, 0);
                            ctx:spawnProjectileNode(8, 3, sourceX, sourceY, angle16((((enemy).sourceAngle16 - (timer * 200)) - 5667)), f32(0), 7.2000000000000002, 1, 0);
                            fired = true;
                            shotSoundHandle = (ctx).bullet1SoundHandle_;
                            shotSoundPriority = 12
                        end
                    end;
                    local offset = f32((math.sin(((timer * kTau) / 100)) * 50));
                    do
                        local i = 0
                        while (i < 3) do
                            do
                                local heading = radians16(angle16(((enemy).secondaryAngle16 + ((i + 3) * 16384))));
                                ctx:spawnProjectileNode(5, 17, f32(((enemy).x + f32((math.cos(heading) * offset)))), f32(((enemy).y + f32((math.sin(heading) * offset)))), (enemy).sourceAngle16, f32(0), 0, 1, 0)
                            end
                            i = i + 1
                        end
                    end;
                    if (timer == 50) then
                        (release)()
                    end;
                    do break end
                end;
            end
            if __switch2 <= 20 then
                if isPhase151Emitter(type) then
                    do
                        local reverse = ((((type == 303) or (type == 305)) or (type == 307)) or (type == 309));
                        local radius = f32((f32(timer) * f32(0.479999989)));
                        local heading = radians16((enemy).sourceAngle16);
                        (enemy).x = f32(f32((f32(((parent).x + (enemy).originX)) + f32((math.cos(heading) * radius)))));
                        (enemy).y = f32(f32((f32(((parent).y + (enemy).originY)) + f32((math.sin(heading) * radius)))));
                        (enemy).sourceAngle16 = (angle16(((enemy).sourceAngle16 + (function() if reverse then return (-360) else return 360 end end)())) % 65536);
                        if ((timer >= 30) and (timer < 390)) then
                            do
                                local v_local = (timer - 30);
                                local base = (enemy).secondaryAngle16;
                                if (((type == 302) or (type == 303)) and (math.fmod(v_local, 5) == 0)) then
                                    do
                                        local spin = (timer * (function() if (type == 302) then return 420 else return (-420) end end)());
                                        local visual = (function() if (type == 302) then return 4 else return 5 end end)();
                                        local speed = (6 + (v_local * 0.01));
                                        do
                                            local i = 0
                                            while (i < 3) do
                                                do
                                                    ctx:spawnProjectileNode(visual, 0, (enemy).x, (enemy).y, angle16((((base + spin) - 7500) + (i * 7500))), f32(0), speed, 1, 0);
                                                    ctx:spawnProjectileNode(visual, 0, (enemy).x, (enemy).y, angle16((((base + spin) + 25268) + (i * 7500))), f32(0), speed, 1, 0)
                                                end
                                                i = i + 1
                                            end
                                        end;
                                        fired = true;
                                        shotSoundHandle = (ctx).bullet1SoundHandle_;
                                        shotSoundPriority = 16
                                    end
                                else
                                    if (((type == 304) or (type == 305)) and (math.fmod(v_local, 10) < 5)) then
                                        do
                                            local spin = (timer * (function() if (type == 304) then return 480 else return (-480) end end)());
                                            local visual = (function() if (type == 304) then return 12 else return 13 end end)();
                                            local speed = (5.5 + (v_local * 0.0080000000000000002));
                                            do
                                                local i = 0
                                                while (i < 4) do
                                                    do
                                                        ctx:spawnProjectileNode(visual, 0, (enemy).x, (enemy).y, angle16(((base + spin) + (i * 16384))), f32(0), speed, 1, 0)
                                                    end
                                                    i = i + 1
                                                end
                                            end;
                                            fired = true;
                                            shotSoundHandle = (ctx).bullet1SoundHandle_;
                                            shotSoundPriority = 12
                                        end
                                    else
                                        if (((type == 306) or (type == 307)) and (math.fmod(v_local, 6) == 0)) then
                                            do
                                                local sweep = (timer * (function() if (type == 306) then return 700 else return (-700) end end)());
                                                local visual = (function() if (type == 306) then return 10 else return 11 end end)();
                                                local speed = (7.2000000000000002 + (v_local * 0.0060000000000000001));
                                                do
                                                    local layer = 0
                                                    while (layer < 4) do
                                                        do
                                                            local offset = (1500 - (layer * 500));
                                                            ctx:spawnProjectileSpread(visual, 0, (enemy).x, (enemy).y, angle16((base + sweep)), f32(0), (speed + (layer * 0.5)), 1, 2, offset, 0);
                                                            ctx:spawnProjectileSpread(visual, 0, (enemy).x, (enemy).y, angle16(((base + sweep) - 32768)), f32(0), (speed + (layer * 0.5)), 1, 2, offset, 0)
                                                        end
                                                        layer = layer + 1
                                                    end
                                                end;
                                                fired = true;
                                                shotSoundHandle = (ctx).bullet1SoundHandle_;
                                                shotSoundPriority = 16
                                            end
                                        else
                                            if (((type == 308) or (type == 309)) and (math.fmod(v_local, 7) == 0)) then
                                                do
                                                    local sweep = (timer * (function() if (type == 308) then return 250 else return (-250) end end)());
                                                    local visual = (function() if (type == 308) then return 12 else return 13 end end)();
                                                    local secondVisual = (function() if (type == 308) then return 2 else return 3 end end)();
                                                    local speed = (5.5 + (v_local * 0.0089999999999999993));
                                                    ctx:spawnProjectileSpread(visual, 0, (enemy).x, (enemy).y, angle16((base + sweep)), f32(0), speed, 1, 4, 65536, 0);
                                                    ctx:spawnProjectileSpread(secondVisual, 0, (enemy).x, (enemy).y, angle16(((base + sweep) + 8192)), f32(0), (speed + 1), 1, 4, 65536, 0);
                                                    fired = true;
                                                    shotSoundHandle = (ctx).bullet1SoundHandle_;
                                                    shotSoundPriority = 16
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end;
                        local phaseEnded = (function() if (type <= 303) then return ((parent).helperState > 1) else return (function() if (type <= 305) then return ((parent).helperState > 2) else return (function() if (type <= 307) then return ((parent).helperState == 99) else return (((parent).helperState == 200) or ((ctx).lateStageBossCountdown_ < 1)) end end)() end end)() end end)();
                        if (phaseEnded or (timer == 410)) then
                            (release)()
                        end
                    end
                end;
                do break end
            end
        until true
    end;
    if ((type >= 296) and (type <= 298)) then
        do
            local radius = math.fmod(scriptRand(u32(((timer * 8888) + (enemy).entityId))), 17);
            local offsetAngle = scriptAngle(u32(((timer * 888) + (enemy).entityId)));
            local offsetRadians = radians16(offsetAngle);
            local effectX = f32(((enemy).x + f32((math.cos(offsetRadians) * radius))));
            local effectY = f32(((enemy).y + f32((math.sin(offsetRadians) * radius))));
            local scale = scriptRandomHundredth(u32(((timer * 88888) + (enemy).entityId)), 50, 100);
            local color = paletteColor(math.fmod(trunc(timer / 3), 7));
            local graph = frameHandle((ctx).effectSmallFrames_, 17);
            ctx:spawnStageEffect(4, graph, 100, 34, effectX, effectY, scriptAngle(u32(((timer * 88) + (enemy).entityId))), 0, scale, scale, 16, (color)[0 + 1], (color)[1 + 1], (color)[2 + 1], 192, 0)
        end
    end;
    if ((type == 299) or (type == 300)) then
        do
            local scale = math.sin(((timer * kPi) / 50));
            ctx:spawnStageEffect(5, frameHandle((ctx).enemyMediumFrames_, 225), 200, 35, (enemy).x, (enemy).y, (0 % 65536), 0, scale, scale, 12, 255, 255, 255, 96, 0)
        end
    end;
    if (isPhase151Emitter(type) and (bit.band(timer, 1) == 0)) then
        do
            local scale = (function() if (timer < 30) then return math.sin(((timer * kPi) / 60)) else return (function() if (timer < 390) then return 1 else return (function() if (timer < 410) then return math.cos((((timer - 390) * kPi) / 40)) else return 0 end end)() end end)() end end)();
            local drawAngle = angle16(trunc((math.sin(((timer * kPi) / 44)) * 1280)));
            ctx:spawnStageEffect(5, frameHandle((ctx).enemyMediumFrames_, 226), 200, 35, (enemy).x, (enemy).y, drawAngle, 0, scale, scale, 16, 255, 255, 255, 96, 0)
        end
    end;
    if (((outside)(enemy) and (type >= 261)) and (type <= 272)) then
        do
            (release)()
        end
    end;
    if (((type == 291) or (type == 292)) and ((parent).helperState == 99)) then
        do
            (release)()
        end
    end;
    if ((type <= 272) and ((((parent).spawnType ~= 321) or ((parent).hp < 1)) or ((ctx).lateStageBossCountdown_ < 1))) then
        do
            (release)()
        end
    end;
    if (fired and (shotSoundHandle ~= (-1))) then
        do
            ctx:playPlayerSound(shotSoundHandle, shotSoundPriority)
        end
    end
end

cpp.install(M)

return M
