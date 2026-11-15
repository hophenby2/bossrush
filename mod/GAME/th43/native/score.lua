-- 0xfdff4 累加分数，0xfd048 在计分更新时消费下一个增机门槛。
return function(program, chips, bullets)
    local floor, min, max = math.floor, math.min, math.max
    local band = require('bit').band
    local distances = {0x4000,0x3600,0x2c00,0x2200,0x1800}
    local returnHeights = {0x3000,0x3e00,0x4a00,0x5600,0x6200}
    local data = program.chip
    local M = {}

    function M.add(pilot, points)
        pilot.score = math.min(0x3b9ac9ff, pilot.score + points)
    end

    function M.extraLife(pilot)
        if pilot.life == 8 then return false end
        pilot.life = pilot.life + 1
        return true
    end

    function M.step(pilot)
        local limits = pilot.extends == 0 and program.item.extend or program.item.extendAgain
        local threshold = pilot.extends < 2 and limits[pilot.extendSetting + 1]
        if threshold and threshold >= 0 and pilot.score >= threshold then
            pilot.extends = pilot.extends + 1
            M.extraLife(pilot)
        end
    end

    -- 共享耐久的装甲合并各判定盒的命中标志，锁定与炸弹优先于速射。
    function M.source(owner, parts)
        local frame = owner.run.frame-1
        local source = owner
        for _,p in ipairs(parts) do
            if p.scoreStamp == frame and (source.scoreStamp ~= frame or p.scoreHit == 'bomb'
                or p.scoreHit == 'lock' and source.scoreHit == 'shot') then
                source = p
            end
        end
        return source
    end

    -- 0xfd18c 直接加分，车体初次受损换成残骸时会走这条入口。
    function M.base(o,points)
        local run = o.run
        if run.player and o.scoreHit and o.scoreStamp == run.frame-1 then M.add(run.player,points) end
    end

    -- 0xfd1c2 / 0xfd7f0 在击破回调读命中标志，速射按纵向距离决定面值。
    function M.kill(o, points, offsetH, offsetL, origin, ending)
        local run = o.run or o.host.run
        local p = run.player
        if not p or not o.scoreHit or o.scoreStamp ~= run.frame-1 then return end
        local bomb = o.scoreHit == 'bomb' or next(p.bombObjects)
        ending = ending or run.stageEnding
        local locked = o.scoreHit == 'lock' or ending
        local boss = run.bossPresent
        origin = origin or o
        local spawnFlags = origin.spawnFlags or o.spawnFlags or 0
        local h,l = program.add(origin.h,origin.l,offsetH or 0,offsetL or 0)
        if not bomb and not ending then
            local kind, duration = 1, 2
            if not locked then
                if run.route.loop == 1 then kind = nil
                else
                    local dh = max(0,program.s16(h-p.h-(boss and 0xc00 or 0)))
                    kind = nil
                    for i=5,1,-1 do
                        if dh < distances[i] then kind = i; break end
                    end
                    if kind then
                        chips.spawn(run,kind,h,l)
                        duration = run.chipTime > 0 and kind <= run.chipKind and 6 or 0x37
                    end
                end
            end
            if kind then
                if band(spawnFlags,0x80) ~= 0 then duration = duration + 0x18 end
                run.chipTime,run.chipKind = min(0x37,run.chipTime+duration),max(run.chipKind,kind)
            end
        end
        if not bomb and locked then
            local key = boss and 'bossMultiplier' or 'stageMultiplier'
            local factor = run[key]
            points = points * max(1,factor)
            if factor > 1 and not (boss and ending) then
                local divisor = boss and 10 or o.multiplierDivisor or band(o.flags or 0,0x200) ~= 0 and 30
                    or band(spawnFlags,0x80) ~= 0 and 10 or 20
                if not boss and run.route.ura then divisor = divisor/2 end
                run[key] = max(1,factor-floor(factor/divisor))
            end
        end
        M.add(p,points)
    end

    -- 0xae49a 在末段击破时禁止自机武装，方向输入继续生效。
    function M.finishBoss(run)
        run.stageEnding = true
        if run.player then
            run.player.protect,run.player.clearHitbox = 0xff,true
        end
    end

    -- 0xfded0 取结算时的后备机、炸弹和关底倍率。里二周目再乘二。
    function M.stageBonus(run)
        local p = run.player
        if not p or p.defeated or run.stageBonus then return end
        local points = (500*(p.life+1)+50*p.bombs)*run.bossMultiplier
        if run.route.ura then points = points*2 end
        run.stageBonus = points
        M.add(p,points)
        -- 0x106556 分次入账，因此同一面结算可以兑现两档增机。
        M.step(p)
        M.step(p)
    end

    -- 0x1056fa 在第五面结算完毕后读取整局坠毁与耗弹数。
    function M.secondLoop(pilot)
        if pilot.defeated then return end
        if pilot.misses == 0 and pilot.bombsUsed == 0 and pilot.score >= 120000000 then return 'ura' end
        if pilot.misses < 7 and pilot.bombsUsed <= 6-pilot.misses then return 'omote' end
    end

    function M.tickCombo(run)
        if run.chipTime == 0 then return end
        local filled = run.chipCount >= 40
        run.chipTime = max(0,run.chipTime-(filled and 2 or 1))
        if run.chipTime == 0 then run.chipKind = 0 end
    end

    local function addReturnMultiplier(run)
        run.stageMultiplier = min(999,run.stageMultiplier+1)
        run.bossMultiplier = min(9999,run.bossMultiplier+1)
    end

    -- 0xff15e 的二周目爆炸槽定时执行反击弹。有些位置只增加倍率。
    local function returnStep(o)
        local run = o.run
        if o.returnCount == 0 or run.bossPresent or run.stageEnding then return end
        if o.returnClock > 0 then o.returnClock = o.returnClock - 1; return end
        local ura = run.route.ura
        o.returnClock, o.returnCount = ura and 5 or 7, o.returnCount-1
        local bounds = data.returnBounds[run.stageNumber]
        local p = run.player
        if band(o.h,0xffff) < (ura and 0x1800 or 0x2000) or not p or p.defeated or p.respawn > 0
            or band(o.l-bounds[2],0xffff)+bounds[1] >= 0x10000 then return end
        local distance = program.distance(o.h,o.l,p.h,p.l)
        if not ura and distance < 0x2000 then return end
        -- 0xae2e4 在单人局仍消耗选自机的随机数。
        program.random(run,data.returnRoll)
        if not ura or distance >= 0x1800 then
            local angle
            if ura then angle = program.aimByte(o.h,o.l,p.h,p.l,0x80)+program.random(run,program.effectRandom)
            else angle = band(program.angle(o.h,o.l,p.h,p.l,0x20),0x3e)*4 end
            local scatter = program.random(run,data.returnScatter)
            bullets.emitReturn(run,ura,angle,o.h,o.l,scatter[1],scatter[2])
        end
        addReturnMultiplier(run)
    end

    -- 0xff10a 在一周目的爆炸首帧分派筹码，二周目则挂反击弹时钟。
    function M.fromEffect(o)
        local run, p = o.run,o.run.player
        if run.route.loop == 1 then
            if run.bossPresent or run.stageEnding then return end
            local ura = run.route.ura
            local count = 0
            for _,height in ipairs(returnHeights) do
                if band(o.h,0xffff) >= height then count = count+1 end
            end
            if ura then count = min(5,count+1) end
            if run.chipTime > 0 then count = count+(ura and 2 or 1) end
            o.returnClock,o.returnCount,o.onFrame = ura and 5 or 7,count,returnStep
        elseif p and p.locked and not run.stageEnding and (run.chipTime > 0 or o.chipLatched) then
            chips.spawn(run,max(1,run.chipKind),o.h,o.l)
        end
    end

    -- 0xf5868 在坠毁时扣倍率的四分之一。
    function M.miss(run)
        run.stageMultiplier = max(1,run.stageMultiplier-floor(run.stageMultiplier/4))
        run.bossMultiplier = max(1,run.bossMultiplier-floor(run.bossMultiplier/4))
    end

    return M
end
