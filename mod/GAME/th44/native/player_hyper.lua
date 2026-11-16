-- 0x17d816 推进空中道具，0x148b0c 切换武器，0x183e80 消费库存和计时。
return function(program, bullets, laser, items)
    local band = require('bit').band
    local floor,min = math.floor,math.min
    local s16,world = program.s16,program.world
    local data = program.pilotHyper
    local M = {}

    local function draw(run,id,h,l)
        if not run.art then return end
        local image = run.art[id]
        local x,y = world(h,l)
        Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2)
    end

    local Pickup = Class(object,{
        init = function(o,run,slot,h,cursor)
            o.run,o.slot,o.h,o.cursor = run,slot,h,cursor
            o.l,o.animation,o.clock = 0,1,2
            o.group,o.layer,o.bound,o.colli = GROUP.GHOST,LAYER.ENEMY + 5 / 4,false,false
        end,
        render = function(o)
            if o.textFrame then
                draw(o.run,data.text[o.textFrame],o.h - 0x400,o.l - 0xa00)
            elseif o.drifting ~= nil then
                draw(o.run,data.item,o.h - 0x700,o.l - 0x600)
                draw(o.run,data.shine[o.animation],o.h - 0x400,o.l - 0x300)
            end
        end,
    })

    local Aura = Class(object,{
        init = function(o,p,frames)
            o.pilot,o.frames,o.cursor,o.clock = p,frames,1,1
            o.group,o.layer,o.bound,o.colli = GROUP.GHOST,LAYER.PLAYER + 1,false,false
        end,
        render = function(o)
            local p = o.pilot
            if p.active then draw(p.run,o.frames[o.cursor],p.h - 0xe00,p.l - 0xa00) end
        end,
    })

    local function remove(o)
        o.run.hyperItems[o.slot] = nil
        object.RawDel(o)
    end

    local function spawn(run,h)
        for slot = 1,6 do
            if not run.hyperItems[slot] then
                local cursor = run.hyperMotionCursor
                run.hyperItems[slot] = New(Pickup,run,slot,h,cursor)
                local nextCursor = cursor + 2
                if nextCursor == 27 then nextCursor = 1
                elseif nextCursor == 28 then nextCursor = 2 end
                run.hyperMotionCursor = nextCursor
                return
            end
        end
    end

    -- 0x17df74 从击破部件继承定点坐标，位移表游标从零起步。
    function M.drop(run,part)
        for slot = 1,6 do
            if not run.hyperItems[slot] then
                local o = New(Pickup,run,slot,part.h,1)
                o.l,o.placed = part.l,true
                run.hyperItems[slot] = o
                return o
            end
        end
    end

    local function dropLocked(p)
        return p.run.hyperDropsLocked and (not p.active or p.bombs ~= 0)
    end

    local function flush(p)
        local run,count = p.run,p.hyperQueued
        if count == 0 or not p.active or dropLocked(p) then return end
        if p.hyperGauge == 0x95f then
            p.hyperGauge,count = 0,count + 1
        end
        for i = 0,count - 1 do spawn(run,0x7000 + 0x800 * i) end
        p.hyperQueued = 0
    end

    -- 0x1859d4 满槽后申请道具。Hyper 中以及关底锁定期间把申请留到退场。
    function M.gain(p,amount)
        p.hyperGauge = p.hyperGauge + amount
        if p.hyperGauge <= 0x95f then return end
        if p.hyperStock == 5 or p.hyperQueued == 4 then
            p.hyperGauge = 0x95f
            return
        end
        p.hyperGauge = 0
        if p.hyperPower or dropLocked(p) then p.hyperQueued = p.hyperQueued + 1
        else spawn(p.run,0x7000) end
    end

    local function removeCombo(p)
        p.comboClock,p.comboHits,p.comboSeed,p.comboValue = 0,0,0,0
    end

    local function addHit(p,amount)
        if p.comboSeed ~= 0 then
            p.comboHits,p.comboValue,p.comboSeed = 1,p.comboSeed,0
        end
        p.comboHits = (p.comboHits + 1) % 10000
        p.comboValue = p.comboValue + amount
        p.score = p.score + p.comboValue
    end

    -- 0x1849fc 留下当前敌机的计分标志。二周目的非激光击破直接补满计时。
    local function refill(p,flags,isLaser)
        local run = p.run
        local maximum = data.comboMax[run.loop == 0 and 1 or 2]
        if isLaser or run.loop == 0 then
            p.comboClock = min(maximum,p.comboClock + data.comboRefill[p.model])
        else p.comboClock = maximum end
        if p.comboClock ~= maximum or band(flags,0x8000) ~= 0 then return end
        local amount
        if p.hyperPower then amount = data.activeKillCharge[run.stageNumber]
        else amount = data.killCharge[run.stageNumber] + data.stockCharge[p.hyperStock + 1] end
        if p.hyperStock ~= 5 and not isLaser then amount = amount * 2 end
        M.gain(p,amount)
    end

    local function killHit(p,flags,isLaser,points)
        local run = p.run
        if run.scoreOnlyKills or run.bombMode == 'shot' and not p.bombHadCombo then
            if not run.scoreOnlyKills then p.comboHits = 0 end
            p.score = p.score + points
            p.comboSeed,p.comboValue = points,0
        else
            p.laserHitWait = p.hyperPower and 1 or 30
            if p.comboClock == 0 then
                refill(p,flags,isLaser)
                p.score = p.score + points
                p.comboSeed,p.comboHits,p.comboValue = points,0,0
            else
                addHit(p,points)
                refill(p,flags,isLaser)
            end
        end
    end

    -- 0x1845cc 先结算击破，再按当前 Hyper 数追加连击，每次追加只带入十分之一的连击分。
    function M.kill(run,flags,points)
        local p = run.player
        if not p or band(flags,p.hitFlags) == 0 then return end
        local isLaser = band(flags,0x400) ~= 0
        killHit(p,flags,isLaser,points)
        if p.hyperPower then
            local value = p.comboValue
            for _=1,p.hyperPower do
                p.comboValue = floor(value / 10)
                killHit(p,flags,isLaser,0)
            end
            p.comboValue = value
        end
    end

    local function laserCharge(p,amount)
        p.hyperHitWait = p.hyperHitWait - 1
        if p.hyperHitWait < 0 then
            M.gain(p,amount)
            p.hyperHitWait = 8
        end
    end

    local function laserChain(p,points)
        local gap = 5 - p.laserLevel
        if p.comboClock == 0 and not p.bomb then
            removeCombo(p)
            p.comboClock = 10
            p.hyperHitWait = 18 + gap * 3
            p.laserHitWait = p.hyperHitWait - (p.hyperPower and 12 or 0)
            return
        end
        laserCharge(p,16)
        p.laserHitWait = p.laserHitWait - 1
        if p.laserHitWait < 0 then
            p.laserHitWait = p.hyperPower and 6 - p.hyperPower or 18 + gap * 3 - (p.doll == 1 and 0 or 3)
            addHit(p,points)
        end
        p.comboClock = math.max(p.comboClock,p.hyperPower and 25 or 10)
    end

    local function bossLaser(p,flags,points,bomb)
        local gap = (5 - p.laserLevel) * 2
        if p.bossComboClock == 0 and (bomb or not p.bomb) then
            p.bossComboClock,p.bossHits,p.laserHitWait = 10,0,8 + gap
            return
        end
        local immediate = bomb and p.run.bossLowHealth
        local add = immediate
        if not add then
            laserCharge(p,p.hyperPower and 48 or 4)
            p.laserHitWait = p.laserHitWait - 1
            add = p.laserHitWait < 0
        end
        if add then
            -- 0x184e44 的低耐久炸弹分支直接累加 HIT，保留普通激光的等待计数。
            if not immediate then
                p.laserHitWait = p.hyperPower and 0 or 8 + gap - (p.doll == 1 and 0 or 3)
            end
            local hit = 1 + (p.hyperPower or 0)
            p.bossHits = p.bossHits + (band(flags,0x4000) == 0 and hit or 2 * hit)
        end
        p.bossComboClock = 10
        p.score = p.score + points
    end

    -- 0x184504。由敌机在消费受击位时调用。两套激光连击共用原版的充能间隔。
    function M.hit(part,flags)
        local run = part.run
        local p = run.player
        if not p or band(flags,p.hitFlags) == 0 or band(part.flags,0x200) ~= 0 then return end
        local points = p.hyperPower and 2 or 1
        if run.bossHyper and run.bombMode == 'laser' then bossLaser(p,flags,points,true) end
        if band(flags,0x400) == 0 then p.score = p.score + points
        elseif run.bossHyper then bossLaser(p,flags,points)
        else laserChain(p,points) end
    end

    -- 0x17e43a 以 20 HIT 为一档充能，0x17e4c8 用完整 HIT 数计算地蜂分值。
    function M.bee(p)
        local clock,hits = p.comboClock,p.comboHits
        if p.run.beetlesUseBossHits then clock,hits = p.bossComboClock,p.bossHits end
        if clock == 0 or hits <= 0 then return 1 end
        if not p.hyperPower and hits >= 20 then M.gain(p,72 * floor(min(hits,200) / 20)) end
        return hits
    end

    function M.bombEnd(p)
        if p.bombHadCombo then removeCombo(p) end
        p.bombHadCombo = nil
    end

    local function drift(o)
        if o.run.freeze then return end
        if o.drifting then
            o.h = s16(o.h - 0x40)
            if band(o.h,0xffff) < 0x800 then o.drifting = false end
        else
            o.h = s16(o.h + 0x18)
            if band(o.h,0xffff) >= 0x7800 then remove(o); return end
        end
        o.motionClock = o.motionClock - 1
        if o.motionClock == 0 then
            o.cursor,o.motionClock,o.dh,o.dl = unpack(data.motion[o.cursor])
        end
        o.h,o.l = s16(o.h + o.dh),s16(o.l + o.dl)
    end

    local function advance(o,p)
        local run = o.run
        o.l = s16(o.l - run.cameraStep)
        if o.textFrame then
            local dh,dl = program.vector(o.textSpeed,o.textAngle * 4)
            if not run.freeze then o.h,o.l = s16(o.h + dh),s16(o.l + dl) end
            o.clock = o.clock - 1
            if o.clock == 0 then
                o.clock,o.textFrame = 2,o.textFrame + 1
                if o.textFrame > #data.text then remove(o) end
            end
            return
        end
        if o.drifting == nil then
            o.drifting = true
            if not o.placed then o.l = 0x1400 end
            o.cursor,o.motionClock,o.dh,o.dl = unpack(data.motion[o.cursor])
        end
        if p.hyperPower or p.hyperStock == 5 then
            items.emit(o,0x1c)
            remove(o)
        elseif o.taken then
            p.hyperStock,p.hyperClock = p.hyperStock + 1,0x95f
            p.score = p.score + 10
            o.textFrame,o.clock = 1,2
            o.textAngle = o.l + run.cameraStep < 0x1c00 and 0x10 or 0x30
            o.textSpeed = band(math.abs(program.bossRandom(run)),6) + 7
        else
            drift(o)
            o.clock = o.clock - 1
            if o.clock < 0 then o.animation,o.clock = o.animation % #data.shine + 1,2 end
        end
    end

    local function aura(p,frames)
        if p.hyperAura then object.RawDel(p.hyperAura) end
        p.hyperAura = New(Aura,p,frames)
    end

    local function finish(p)
        if not p.hyperPower then return end
        p.hyperPower,p.run.hyper,p.hyperClock = nil,false,0
        laser.weaponChanged(p)
        aura(p,data.ending)
        flush(p)
    end

    function M.input(p,pressed)
        local edge = pressed and not p.hyperKey
        p.hyperKey = pressed
        if not edge or p.run.major < 4 or p.run.freeze or p.run.bossEnding then return false end
        if p.hyperAura and p.hyperAura.frames == data.aura then return false end
        if p.bomb then return false end
        if p.hyperStock == 0 then
            if p.hyperPower and p.bombs > 0 then
                p.hyperRank = math.max(0,p.hyperRank - 3)
                finish(p)
            end
            return true
        end
        p.hyperPower,p.hyperStock = p.hyperStock,0
        p.hyperRank = min(15,p.hyperRank + p.hyperPower)
        p.run.hyper,p.protect = true,0x50
        if p.comboClock > 0 then p.comboClock = data.comboMax[p.run.loop == 0 and 1 or 2] end
        laser.weaponChanged(p)
        bullets.clearWithFade(p.run)
        aura(p,data.aura)
        return false
    end

    function M.rank(p)
        local rank = p.hyperPower and p.hyperRank or floor(p.hyperRank / 4)
        local run = p.run
        local extra = rank > 0 and data.rank[rank] or 0
        if run.ranks and run.loop ~= 0 then extra = extra + 1 end
        run.hyperBulletRank = extra
    end

    function M.step(p)
        local run = p.run
        if run.bossHyper and not run.bossLowHealth and run.bombMode ~= 'laser'
            and (run.loop == 0 or run.stageNumber ~= 5) then
            local boss = run['boss' .. run.stageNumber]
            -- 0x182eec 在关底血条下降到阈值后锁存，最终关二周目跳过。
            if boss and boss.health >= 0 and boss.health <= 0x6fb8 then run.bossLowHealth = true end
        end
        for slot = 1,6 do
            local o = run.hyperItems[slot]
            if o then
                advance(o,p)
                if run.hyperItems[slot] then o.x,o.y = world(o.h,o.l) end
            end
        end
        if p.hyperPower and not run.freeze and not run.bossEnding then
            p.hyperClock = p.hyperClock - 2
            if p.hyperClock < 0 then finish(p) end
        elseif not p.hyperPower then flush(p) end
        if p.comboClock > 0 then
            p.comboClock = p.comboClock - 1
            if p.comboClock == 0 then p.comboSeed,p.comboValue = 0,0 end
        end
        if run.bossHyper and p.bossComboClock > 0 and not run.bossEnding then
            p.bossComboClock = p.bossComboClock - 1
            if p.bossComboClock == 0 and p.bossHits > 0 then
                p.bossHits,p.bossComboClock = p.bossHits - 1,run.dual and 18 or 10
                if p.bossHits == 0 then p.bossComboClock = 0 end
            end
        end
        local o = p.hyperAura
        if o then
            o.x,o.y = p.x,p.y
            o.clock = o.clock - 1
            if o.clock < 0 then
                o.cursor,o.clock = o.cursor + 1,1
                if not o.frames[o.cursor] then object.RawDel(o); p.hyperAura = nil end
            end
        end
    end

    function M.contact(p)
        if p.run.frame % 2 == 0 then return end
        for slot = 1,6 do
            local o = p.run.hyperItems[slot]
            if o and o.drifting ~= nil and not o.textFrame
                and p.h + p.front >= o.h - 0x600 and p.h - p.back <= o.h + 0x600
                and p.l + p.right >= o.l - 0x500 and p.l - p.left <= o.l + 0x500 then
                o.taken = true
            end
        end
    end

    function M.miss(p)
        removeCombo(p)
        p.hyperRank,p.hyperStock = floor(p.hyperRank / 4),0
        p.hyperGauge = min(p.hyperGauge + 0x258,0x95e)
        finish(p)
        p.hyperClock = 0
    end

    function M.close(p)
        for _,o in pairs(p.run.hyperItems) do remove(o) end
        if p.hyperAura then object.RawDel(p.hyperAura); p.hyperAura = nil end
    end

    return M
end
