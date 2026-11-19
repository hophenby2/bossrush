-- 由 tools/generate_likedreamer_native_bosses.py 从本地复原源码生成。

-- 生成物是普通 Lua 状态机；修改源逻辑或生成规则后重新生成并核对轨迹。

local cpp = assert(LikeDreamer.Recovered)

local f32, trunc, u32, s16 = cpp.f32, cpp.trunc, cpp.u32, cpp.s16

local bit = require("bit")

local M = {}

local kPi = 3.1415926535897931

local kTau = (kPi * 2)

local kEntityCap = 512

local sceneAngle

local sceneRadians

local approachSceneAngle

local sceneScriptRand

local sceneRandomAngle

local sceneRandomHundredth

local sceneCombatWindow

local isStructuralSceneNode

local sceneUpdateCase

local frameAt

sceneAngle = function(angle)
    do return (bit.band(angle, 65535) % 65536) end
end

sceneRadians = function(angle)
    angle = (angle % 65536);
    do return ((angle * kTau) / 65536) end
end

approachSceneAngle = function(current, target, step)
    current = (current % 65536);
    target = (target % 65536);
    local delta = (target - current);
    if (delta > 32768) then
        delta = (delta - 65536)
    end;
    if (delta < (-32768)) then
        delta = (delta + 65536)
    end;
    do return sceneAngle((current + cpp.clamp(delta, (-step), step))) end
end

sceneScriptRand = function(seed)
    seed = u32(seed);
    local u = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(seed, 30)), seed)), 1812433253) + 1));
    local a = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(u, 30)), u)), 1812433253) + 2));
    local b = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(a, 30)), a)), 1812433253) + 3));
    local c = u32((cpp.mul32(u32(bit.bxor(u32(bit.rshift(b, 30)), b)), 1812433253) + 4));
    local mixed = u32(bit.bxor(cpp.mul32(u, 2048), u));
    do return u32(bit.bxor(u32(bit.bxor(u32(bit.rshift(u32(bit.bxor(u32(bit.rshift(c, 11)), mixed)), 8)), c)), mixed)) end
end

sceneRandomAngle = function(seed)
    seed = u32(seed);
    local random = sceneScriptRand(seed);
    do return (u32((random - trunc(random / 65537))) % 65536) end
end

sceneRandomHundredth = function(seed, minimum, maximum)
    seed = u32(seed);
    local minimum100 = trunc((minimum * 100));
    local maximum100 = trunc((maximum * 100));
    local width = u32(((maximum100 - minimum100) + 1));
    do return ((minimum100 + math.fmod(sceneScriptRand(seed), width)) / 100) end
end

sceneCombatWindow = function(spawnType)
    if ((((spawnType >= 228) and (spawnType <= 231)) or (spawnType == 242)) or (spawnType == 243)) then
        do
            do return {startFrame = 1300, endFrame = 3000} end
        end
    end;
    if (((spawnType >= 232) and (spawnType <= 236)) or ((spawnType >= 244) and (spawnType <= 247))) then
        do
            do return {startFrame = 2000, endFrame = 5500} end
        end
    end;
    if (spawnType == 237) then
        do return {startFrame = 5700, endFrame = 6600} end
    end;
    if (spawnType == 248) then
        do return {startFrame = 5700, endFrame = 8500} end
    end;
    if (spawnType == 238) then
        do return {startFrame = 7900, endFrame = 8800} end
    end;
    if (spawnType == 249) then
        do return {startFrame = 7900, endFrame = 9100} end
    end;
    if ((spawnType == 239) or (spawnType == 240)) then
        do return {startFrame = 9300, endFrame = 10600} end
    end;
    if (spawnType == 241) then
        do return {startFrame = 10600, endFrame = 11500} end
    end;
    do return {startFrame = 0, endFrame = 0} end
end

isStructuralSceneNode = function(spawnType)
    do return ((spawnType >= 222) and (spawnType <= 227)) end
end

sceneUpdateCase = function(spawnType)
    if (spawnType <= 227) then
        do return 127 end
    end;
    if (spawnType <= 241) then
        do return 128 end
    end;
    do return 129 end
end

frameAt = function(frames, index)
    do return (function() if ((index >= 0) and (index < (#frames))) then return (frames)[index + 1] else return (-1) end end)() end
end

M.isStage10GuardNodeType = function(ctx, spawnType)
    do return (spawnType == 310) end
end

M.maybeSpawnStage10GuardNode = function(ctx, owner)
    do
        local __switch2 = (owner).spawnType
        if __switch2 == 273 then __switch2 = 1
        elseif __switch2 == 274 then __switch2 = 2
        elseif __switch2 == 275 then __switch2 = 3
        elseif __switch2 == 277 then __switch2 = 4
        elseif __switch2 == 282 then __switch2 = 5
        elseif __switch2 == 285 then __switch2 = 6
        elseif __switch2 == 293 then __switch2 = 7
        elseif __switch2 == 294 then __switch2 = 8
        elseif __switch2 == 301 then __switch2 = 9
        else __switch2 = 10 end
        repeat
            if __switch2 <= 9 then
                do break end;
            end
            if __switch2 <= 10 then
                do return end
            end
        until true
    end;
    if (((ctx).player_).invulnerableFrames < 61) then
        do
            (owner).guardSpawnLatched = false
        end
    end;
    local playerInBlockingState = ((((ctx).player_).playerStateTimer > 0) or (((ctx).player_).playerStateTimer < (-100)));
    if ((((not (owner).targetable) or (not playerInBlockingState)) or (owner).guardSpawnLatched) or (((#(ctx).enemies_) + (#(ctx).pendingEnemies_)) >= kEntityCap)) then
        do
            do return end
        end
    end;
    local guard = cpp.newEnemy();
    (guard).entityId = (function() local __old = (ctx).nextEntityId_; (ctx).nextEntityId_ = (ctx).nextEntityId_ + 1; return __old end)();
    (guard).spawnType = 310;
    (guard).updateCase = 117;
    (guard).sourceHitPoints = 99999999;
    (guard).sourceDispatchKind = 1;
    (guard).sourceDispatchField = 20;
    (guard).rewardWeight = 1;
    (guard).parentEntityId = (owner).entityId;
    (guard).parentSpawnType = (owner).spawnType;
    (guard).sourceNote = "S10 FUN_14004a4a0 player-state guard";
    (guard).x = f32((owner).x);
    (guard).y = f32((owner).y);
    (guard).hp = 99999999;
    (guard).maxHp = (guard).hp;
    (guard).drawHp = (guard).hp;
    (guard).radius = 20;
    (guard).activationDelay = 0;
    (guard).targetable = true;
    cpp.push((ctx).pendingEnemies_, guard);
    (owner).guardSpawnLatched = true
end

M.updateStage10GuardNode = function(ctx, enemy)
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
    (enemy).x = f32((owner).x);
    (enemy).y = f32((owner).y);
    (enemy).targetable = true;
    if ((enemy).helperState == 0) then
        do
            if ((enemy).helperTimer == 0) then
                do
                    local spark = frameAt((ctx).playerFrames_, 14);
                    do
                        local i = 0
                        while (i < 32) do
                            do
                                local angleSeed = u32(((ctx).frame_ + (i * 88)));
                                local scaleSeed = u32(((ctx).frame_ + (i * 8888)));
                                local speedSeed = u32(((ctx).frame_ + (i * 888)));
                                local scale = sceneRandomHundredth(scaleSeed, 1.1000000000000001, 2.2000000000000002);
                                ctx:spawnStageEffect(44, spark, 72, 72, (enemy).x, (enemy).y, sceneRandomAngle(angleSeed), sceneRandomHundredth(speedSeed, 16, 26), scale, scale, 0, 255, 255, 255, 192, 0)
                            end
                            i = i + 1
                        end
                    end
                end
            end;
            local timer = cpp.clamp((enemy).helperTimer, 0, 32);
            local expansion = math.sin(((timer * kPi) / 64));
            (enemy).radius = trunc((expansion * 360));
            if (((ctx).player_).invulnerableFrames < 61) then
                do
                    (enemy).helperState = 1;
                    (enemy).helperTimer = 0
                end
            end
        end
    else
        if (((enemy).helperState == 1) and ((enemy).helperTimer >= 16)) then
            do
                (enemy).targetable = false;
                (enemy).active = false
            end
        end
    end
end

M.isSharedHitboxProxyType = function(ctx, spawnType)
    do return ((spawnType == 337) or (spawnType == 338)) end
end

M.spawnSharedHitboxProxy = function(ctx, parent, spawnType, offsetX, offsetY, radius)
    offsetX = f32(offsetX);
    offsetY = f32(offsetY);
    if ((not ctx:isSharedHitboxProxyType(spawnType)) or (((#(ctx).enemies_) + (#(ctx).pendingEnemies_)) >= kEntityCap)) then
        do
            do return false end
        end
    end;
    local proxy = cpp.newEnemy();
    (proxy).entityId = (function() local __old = (ctx).nextEntityId_; (ctx).nextEntityId_ = (ctx).nextEntityId_ + 1; return __old end)();
    (proxy).spawnType = spawnType;
    (proxy).updateCase = 180;
    (proxy).sourceHitPoints = 99999999;
    (proxy).sourceDispatchKind = 1;
    (proxy).sourceDispatchField = radius;
    (proxy).rewardWeight = 1;
    (proxy).parentEntityId = (parent).entityId;
    (proxy).parentSpawnType = (parent).spawnType;
    (proxy).sourceNote = (function() if (spawnType == 337) then return "S08 FUN_1400ab110 shared-HP hitbox" else return "S08 FUN_1400465d0 shared-HP hitbox" end end)();
    (proxy).originX = f32(offsetX);
    (proxy).originY = f32(offsetY);
    (proxy).sourceX = cpp.lround(offsetX);
    (proxy).sourceY = cpp.lround(offsetY);
    (proxy).x = f32(f32(((parent).x + offsetX)));
    (proxy).y = f32(f32(((parent).y + offsetY)));
    (proxy).hp = 99999999;
    (proxy).maxHp = (proxy).hp;
    (proxy).drawHp = (proxy).hp;
    (proxy).radius = radius;
    (proxy).activationDelay = 0;
    (proxy).targetable = (parent).targetable;
    cpp.push((ctx).pendingEnemies_, proxy);
    do return true end
end

M.updateSharedHitboxProxy = function(ctx, enemy)
    (enemy).vx = f32(f32(0));
    (enemy).vy = f32(f32(0));
    (enemy).drawBodyThisFrame = false;
    (enemy).drawMarkerThisFrame = false;
    local owner = ctx:findEnemyById((enemy).parentEntityId);
    if (((owner == nil) or (not (owner).active)) or ((owner).spawnType ~= (enemy).parentSpawnType)) then
        do
            (enemy).targetable = false;
            (enemy).active = false;
            do return end
        end
    end;
    (enemy).x = f32(f32(((owner).x + (enemy).originX)));
    (enemy).y = f32(f32(((owner).y + (enemy).originY)));
    (enemy).targetable = (owner).targetable;
    if ((enemy).hp < (owner).hp) then
        do
            (owner).hp = ((owner).hp - ((owner).hp - (enemy).hp))
        end
    else
        if ((owner).hp < (enemy).hp) then
            do
                (enemy).hp = (owner).hp
            end
        end
    end;
    if ((enemy).hp < 1) then
        do
            (owner).hp = ((owner).hp - (owner).hp)
        end
    end;
    (enemy).hp = math.min((enemy).hp, (owner).hp);
    (enemy).maxHp = (owner).maxHp;
    (enemy).drawHp = (owner).drawHp
end

cpp.install(M)

return M
