-- 0x16e702 分配道具槽。0x16f816 / 0x16f9b2 分别推进大、小精灵石。
return function(program,art,bullets)
    local band = require('bit').band
    local floor,min = math.floor,math.min
    local M = {}

    local Reward = Class(object,{
        init = function(o,run,slot,kind,h,l,speed)
            local data = program.rewards[kind]
            o.run,o.slot,o.h,o.l = run,slot,h,l
            o.offsetH,o.offsetL,o.speed,o.angle,o.value,o.score = unpack(data.field)
            o.speed,o.images,o.frameIndex = o.speed + speed,data.images,1
            o.dh,o.dl = 0,0
            o.group,o.layer,o.bound,o.colli = GROUP.GHOST,LAYER.PLAYER_BULLET,false,false
            o.x,o.y = program.world(h,l)
        end,
        render = function(o)
            local assets = o.run.art
            if assets then art.draw(assets.sprites[o.images[o.frameIndex]],o.h,o.l,o.offsetH,o.offsetL) end
        end,
    })

    local function spawn(run,kind,h,l,defer)
        for slot = 1,100 do
            if not run.rewards[slot] then
                local speed = 8 + program.s8(program.random(run,program.rewardSpeed))
                local o = New(Reward,run,slot,kind,h,l,speed)
                o.firstUpdate = run.frame + (defer and 1 or 0)
                run.rewards[slot] = o
                return
            end
        end
    end

    function M.fromCancelledBullet(run,kind,h,l)
        spawn(run,kind,h,l,true)
    end

    local function goldKind(p)
        return math.min(9,floor((p.goldStock or 0) / 100)) * 4
    end

    -- 0x178140 的常规击破优先给大石，0x178694 的阶段奖励受 250 颗阈值影响。
    function M.drop(owner,h,l,weight,flags,phase,hitMode)
        local run = owner.run
        local p = run.player
        if not p or not p.active or p.guard or p.pose == 22 or (p.pendingHit and p.protect == 0) then return end
        local gems,level = p.gems or 0,p.overLevel or 0
        local kind,count,alternate = goldKind(p),1,false
        local small = band(flags,0x0200) ~= 0
        local stage = run.stageNumber - 1
        local mode = hitMode or owner.rewardMode or 0
        if mode == 2 and run.nativePlayer then
            local cost = small and (5 + (phase and stage or floor(stage / 2))) or (25 + stage*2) * (phase and 2 or 1)
            p.gems = math.max(1,p.gems - cost)
            bullets.convert(owner,p,kind)
            return
        end
        if band(flags,0x0400) ~= 0 then return end
        if mode == 1 then
            if level == 0 then count = floor(weight / 2) + 1
            elseif level == 1 then count = weight - floor(weight / 4) + 1
            else count = weight + (level == 3 and (small and 2 or 3) or 1) end
        elseif gems < 0x1f4 then
            local amount = floor((weight + level) / 2)
            if small then amount = floor(amount / 2) end
            count = amount + 1 + (h >= 0x5c00 and 1 or 0)
            kind = phase and gems >= 250 and 0x2c or 0x28
            alternate = gems > 50 and (not phase or gems < 250)
        end
        for _ = 1,count do
            if run.nativePlayer then
                local shift = program.rewardScatter[program.nextRandom(run,63)]
                local dh,dl = program.addPacked(h,l,shift)
                spawn(run,kind,dh,dl,false)
            elseif phase then
                -- 受控原版轨迹用固定坐标代替自机，仍需要经过同一随机序列。
                program.nextRandom(run)
                program.nextRandom(run)
            end
            if alternate then kind = kind == 0x28 and 0x2c or 0x28 end
        end
    end

    function M.remove(o)
        o.run.rewards[o.slot] = nil
        object.RawDel(o)
    end

    local function move(o,p)
        if o.speed >= 0x20 then
            if not p.active then return false end
            local speedChanged = o.homing and o.speed < 0x30
            if speedChanged then o.speed = o.speed + 2 end
            if not o.homing then
                o.angle = program.angle8(o.h,o.l,p,o.angle)
            elseif band(o.run.frame,o.speed) == 0 then
                local angle = program.angle8(o.h,o.l,p,o.angle)
                speedChanged,o.angle = speedChanged or angle ~= o.angle,angle
            end
            if not o.homing or speedChanged then o.dh,o.dl = program.vector(o.speed,o.angle) end
            o.homing = true
        else
            o.h = o.h + 0x100
            if o.run.frame % 2 == 0 then
                o.speed = o.speed + (p.awakeningMode == 1 and 4 or 2)
                o.dh,o.dl = program.vector(o.speed,o.angle)
            end
        end
        o.h = program.s16(o.h + o.dh)
        if o.homing or o.speed < 0x18 then o.l = program.s16(o.l + o.dl) end
        return o.h > -0x1800 and o.h < 0x9000 and o.l > -0x1800 and o.l < 0x5000
    end

    function M.step(run,p)
        for slot = 1,100 do
            local o = run.rewards[slot]
            if o and run.frame >= o.firstUpdate then
                if o.collect then
                    p.gems = min(0x1f4,p.gems + o.value)
                    if o.score > 0 then
                        p.score = min(999999999,p.score + o.score)
                        p.goldStock = min(1000,p.goldStock + 1)
                    end
                    M.remove(o)
                else
                    o.l = program.s16(o.l-run.cameraStep)
                    o.frameIndex = o.frameIndex % #o.images + 1
                    if move(o,p) then o.x,o.y = program.world(o.h,o.l)
                    else M.remove(o) end
                end
            end
        end
    end

    -- 0x11b26c 扩大道具一侧的判定框，标记留待下一次道具回调消费。
    function M.collect(run,p)
        if not p.active or run.frame % 2 ~= 0 then return end
        for _,o in pairs(run.rewards) do
            if run.frame >= o.firstUpdate and o.h - 0x6c0 <= p.h + p.front and p.h - p.back <= o.h + 0x6c0
                and o.l - 0x480 <= p.l + p.right and p.l - p.left <= o.l + 0x480 then
                o.collect = true
            end
        end
    end

    return M
end
