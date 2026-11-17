-- V100 二面关底 0x18f0ac。主体、舱门与炮口共用原版的十个部件槽。
return function(program,bullets,art,effects)
    local directory = 'mod/GAME/th45/native/'
    local tasks = dofile('mod/GAME/th44/native/boss_tasks.lua')
    local attacks = dofile(directory .. 'boss2_attacks.lua')(program,bullets,tasks)
    local data = program.boss2
    local band = require('bit').band
    local abs, floor = math.abs, math.floor
    local s16, addPacked = program.s16, program.addPacked
    local M = {parts=10}
    local aux, events = {},{}

    local offsets = {0,0,0xefffefc0,0xf0001040,0x0c7fee80,0x0c801180}
    local activeParts = {1,3,4,5,6}

    local function attachParts(o)
        for index,offset in ipairs(offsets) do
            local p = o.extraParts[index]
            p.h,p.l = addPacked(o.h,o.l,offset)
            if index >= 3 and not o.run.freeze then
                local delta = program.s8(p.aim - p.barrel)
                p.barrel = band(p.barrel + math.max(-4,math.min(4,delta)),255)
            end
        end
    end

    local function nextPoint(o)
        local run = o.run
        o.target.h = o.wanderCenter + data.wanderH[program.nextRandom(run,63)]
        o.target.l = 0x1c00 + data.wanderL[program.nextRandom(run,63)]
        o.wanderClock = 0
    end

    local function startWander(o,speed,center)
        o.speed,o.wanderCenter = speed,center
        o.direct = 'wander'
        o.target = {active=true}
        nextPoint(o)
    end

    local function distance(o,h,l)
        local dh,dl = abs(s16(o.h-h)),abs(s16(o.l-l))
        dh = dh-floor(dh/4)
        return math.max(dh,dl)+floor(math.min(dh,dl)/2)
    end

    local function turn(o,h,l)
        local target = o.target
        target.h,target.l = h,l
        o.direction = program.towards(o.direction,program.angle(o.h,o.l,target,o.direction))
    end

    local function driftPoint(o)
        local drift = o.drift
        local change = data.wanderPacked[program.nextRandom(o.run,63)]
        drift.h,drift.l = addPacked(drift.centerH,drift.centerL,change)
    end

    local function flyTo(o,h,l)
        o.direct,o.speed = 'flyTo',2
        o.target = {active=true,h=h,l=l}
        o.flyMidpoint,o.flyClock = floor(distance(o,h,l)/2),0
        o.direction = program.angle(o.h,o.l,o.target,o.direction)
    end

    -- 0x18f678 与 0x18f9f8 共用 0x18f5b8 的部件更新。
    local function move(o)
        local run = o.run
        if not run.freeze then
            if o.approachClock > 0 then
                o.approachClock = o.approachClock - 1
            elseif o.approaching then
                o.brakeClock = o.brakeClock - 1
                if o.brakeClock < 0 then
                    o.speed,o.brakeClock = o.speed - 1,4
                    if o.speed == 2 then
                        o.approaching,o.protected,o.flags = false,false,0xa001
                        for _,index in ipairs(activeParts) do o.extraParts[index].flags = 0xa001 end
                        tasks.attach(o.events,5)
                    end
                end
            elseif o.direct == 'wander' then
                local target = o.target
                turn(o,target.h,target.l)
                o.wanderClock = o.wanderClock + 1
                if o.wanderClock == 0x30 or distance(o,target.h,target.l) <= 0x100 then
                    nextPoint(o)
                end
            elseif o.direct == 'flyTo' then
                local target = o.target
                turn(o,target.h,target.l)
                local d = distance(o,target.h,target.l)
                o.flyClock = o.flyClock - 1
                if o.flyClock < 0 then
                    o.flyClock = 2
                    o.speed = o.speed + (d >= o.flyMidpoint and 1 or -1)
                end
                if d <= 0x200 or o.speed == 0 then o.direct = 'beginDrift' end
            elseif o.direct == 'beginDrift' or o.direct == 'drift' then
                if o.direct == 'beginDrift' then
                    o.direct,o.speed = 'drift',3
                    o.drift = {centerH=o.h,centerL=o.l}
                    driftPoint(o)
                end
                local h,l = o.drift.h,s16(o.drift.l-o.run.cameraOffset)
                turn(o,h,l)
                if distance(o,h,l) <= 0x100 then driftPoint(o) end
            end
        end
        if not run.stopPathClock then
            local dh,dl = program.vector(o.speed,o.direction * 4,run.slowVectors)
            o.h,o.l = s16(o.h + dh),s16(o.l + dl)
        end
        attachParts(o)
    end

    local function animate(field,frames)
        local function tick(o) o[field] = (o[field] + 1) % frames end
        return {tick,tick}
    end

    aux[0],aux[1] = animate('rotor',8),animate('wing',8)

    local function spinCore(o)
        o.coreClock = o.coreClock - 1
        if o.coreClock < 0 then
            o.coreClock = o.corePeriod
            o.coreFrame = (o.coreFrame + 1) % 16
        end
    end

    local function charge(o,t)
        t.clock = t.clock - 1
        if t.clock < 0 then
            t.clock = 2
            o.corePeriod = math.min(4,o.corePeriod + 1)
        end
        spinCore(o)
    end

    aux[2] = {function(o,t)
        o.coreClock,o.corePeriod,t.clock = 0,0,2
        charge(o,t)
    end,charge}

    local function spinDown(o,t)
        t.clock = t.clock - 1
        if t.clock < 0 then
            t.clock = 2
            o.corePeriod = math.max(0,o.corePeriod - 1)
        end
        spinCore(o)
    end

    aux[8] = {function(o,t)
        t.clock = 0
        spinDown(o,t)
    end,spinDown}

    -- 0x18fc38 先读上一帧的炮位，移动任务再把炮位推到这一帧。
    local function track(o)
        if o.trackSuspended then return end
        for index = 3,6 do
            local p = o.extraParts[index]
            if not p.locked then p.aim = program.angle8(p.h,p.l,o.run.player,p.aim) end
        end
    end

    aux[3] = {track,track}

    local function cover(direction,last)
        local function tick(o,t)
            t.clock = t.clock - 1
            if t.clock >= 0 then return end
            o.cover = math.max(0,math.min(7,o.cover + direction))
            t.clock = 3
            if o.cover == last then o.aux[t.slot] = nil end
        end
        return {function(o,t) t.clock = 0; tick(o,t) end,tick}
    end

    aux[4],aux[5] = cover(1,7),cover(-1,0)

    local function extendWings(o,t)
        t.clock = t.clock - 1
        if t.clock < 0 then
            o.wingExtension = o.wingExtension + 1
            t.clock = 2
            if o.wingExtension == 15 then o.aux[t.slot] = nil end
        end
        local f,b,r,l = unpack(data.wingBounds[o.wingExtension + 1])
        local p,q = o.extraParts[3],o.extraParts[4]
        p.front,p.back,p.right,p.left = f,b,r,l
        q.front,q.back,q.right,q.left = f,b,l,r
    end

    aux[6] = {function(o,t) t.clock = 0; extendWings(o,t) end,extendWings}
    aux[7] = animate('hull',8)

    local function nextEvent(o,t,index)
        tasks.attach(o.events,index)
        o.events[t.slot] = nil
    end

    -- 0x19054e 先降低游走中心，等环射回收后才挂下一事件。
    local function circleAttack(o,t)
        if t.phase == 0 then
            t.clock = t.clock - 1
            if t.clock < 0 then t.phase,t.clock = 1,0x40 end
        end
        if t.phase == 1 then
            t.clock = t.clock - 1
            if t.clock < 0 then
                t.phase = 2
                tasks.attach(o.attacks,3)
            end
        end
        if t.phase == 2 and not tasks.contains(o.attacks,3) then t.phase,t.clock = 3,0x30 end
        if t.phase == 3 then
            t.clock = t.clock - 1
            if t.clock < 0 then nextEvent(o,t,6) end
        end
    end

    events[4] = {function(o,t)
        t.phase,t.clock = 0,1
        startWander(o,1,0x5800)
        circleAttack(o,t)
    end,circleAttack}

    local function sweepAttack(o,t)
        t.clock = t.clock-1
        if t.clock ~= 0 then return end
        tasks.stop(o.attacks,9)
        o.trackSuspended = false
        nextEvent(o,t,7)
    end

    -- 0x1907d2 用固定计数控制四个炮口扫射，事件结束时恢复自机瞄准。
    events[6] = {function(o,t)
        t.clock = 0x200
        startWander(o,1,0x5e00)
        tasks.attach(o.attacks,9)
        sweepAttack(o,t)
    end,sweepAttack}

    local function burstAttack(o,t)
        if t.phase == 0 then
            t.clock=t.clock-1
            if t.clock < 0 then
                tasks.attach(o.attacks,14)
                t.phase = 1
            end
        end
        if t.phase == 1 then
            t.delay = t.delay-1
            if t.delay < 0 then
                local offset = data.sweepOffsets[t.volley]
                if t.mirrored then
                    offset = floor(offset/0x10000)*0x10000+band(-offset,0xffff)
                end
                tasks.attach(o.attacks,15,{angle=t.angle,offset=offset})
                t.delay,t.repeatDelay = t.repeatDelay,t.repeatDelay-8
                t.angle,t.volley = band(t.angle+0x80,255),t.volley+1
                if t.volley > #data.sweepOffsets then t.phase = 2 end
            end
        end
        if t.phase == 2 and not tasks.contains(o.attacks,15) then
            tasks.stop(o.attacks,14)
            o.trackSuspended = false
            t.phase,t.clock = 3,0x30
        end
        if t.phase == 3 then
            t.clock=t.clock-1
            if t.clock < 0 then nextEvent(o,t,5) end
        end
    end

    -- 0x190844：六条交错扫射结束后才返回入场后的循环。
    events[7] = {function(o,t)
        t.phase,t.clock,t.delay,t.repeatDelay,t.volley = 0,0x20,0x30,0x20,1
        t.mirrored = band(program.random(o.run,program.randomByte),1) == 0
        t.angle = t.mirrored and 0x40 or 0xc0
        startWander(o,5,0x5e00)
        burstAttack(o,t)
    end,burstAttack}

    -- 0x1905f6：机身游走期间，炮口、核心与舱门各自使用原程序的任务计数。
    local function opening(o,t)
        if t.roundPending and not tasks.contains(o.attacks,7) then
            t.roundClock = t.roundClock - 1
            if t.roundClock < 0 then
                t.roundClock,t.roundPending = 0x30,false
                if t.roundCount == 4 then
                    tasks.stop(o.aux,2)
                    tasks.attach(o.aux,8)
                end
                tasks.attach(o.attacks,7,{count=t.roundCount})
                t.roundCount = t.roundCount + 1
            end
        end
        if t.phase == 0 then
            t.clock = t.clock - 1
            if t.clock < 0 then
                t.cannon = tasks.attach(o.attacks,6)
                t.phase,t.clock = 1,0x40
            end
        end
        if t.phase == 1 then
            t.clock = t.clock - 1
            if t.clock < 0 then t.phase = 2 end
        end
        if t.phase == 2 then
            t.roundPending = true
            t.wingClock = t.wingClock - 1
            if t.wingClock < 0 then
                t.wingClock,t.phase = 0x50,3
                tasks.attach(o.aux,4)
            end
        end
        if t.phase == 3 then
            t.roundPending = true
            if not tasks.contains(o.aux,4) then
                tasks.attach(o.attacks,8,{groups=t.groups,spread=t.spread})
                t.phase,t.groups,t.spread = 4,math.min(4,t.groups+2),t.spread-2
            end
        end
        if t.phase == 4 then
            t.roundPending = true
            if not tasks.contains(o.attacks,8) then
                tasks.attach(o.aux,5)
                t.wingCycles,t.phase = t.wingCycles - 1,2
                if t.wingCycles == 0 then t.phase,t.cannon.stopping = 5,true end
            end
        end
        if t.phase == 5 and not t.roundPending and not tasks.contains(o.attacks,7) then
            nextEvent(o,t,4)
        end
    end

    events[5] = {function(o,t)
        t.phase,t.clock,t.wingClock,t.wingCycles = 0,0x30,0x50,2
        t.roundClock,t.roundCount,t.groups,t.spread = 0,4,2,0x14
        startWander(o,1,0x5e00)
        opening(o,t)
    end,opening}

    local function debris(effect)
        -- 0x17a0ea 每颗闪光碎屑读取五次随机表，碎屑的单独绘制尚未移植。
        for _ = 1,5 do program.nextRandom(effect.run) end
    end

    local function explosion(o,part,rows)
        local origin = {run=o.run,h=part.h,l=part.l}
        for _,row in ipairs(rows) do
            local kind,dh,dl,motion,delay = unpack(row)
            local jitter = program.random(o.run,program.randomNarrow)
            local effect = effects.emit(origin,kind,floor(motion / 256),band(motion + jitter,255),
                dh * 0x10000 + band(dl,0xffff),false,delay)
            if effect then effect.onStart = debris end
        end
    end

    local brokenParts = {5,6,3,4}
    local function detach(o)
        for index,id in ipairs(brokenParts) do
            local part = o.extraParts[id]
            part.broken = true
            if id >= 5 then part.flags = 0x8000 end
            explosion(o,part,data.explosions[index + 1])
        end
        o.damaged = true
        tasks.stop(o.aux,2)
        tasks.attach(o.aux,7)
    end

    -- 0x18ff5c 关舱后炸掉四个炮口，展开的侧翼接替内侧炮的碰撞框。
    local function refit(o,t)
        if t.phase == 0 then
            t.clock = t.clock - 1
            if t.clock < 0 then
                detach(o)
                t.phase,t.clock = 1,0x40
            end
        end
        if t.phase == 1 then
            if t.clock > 0 then t.clock = t.clock - 1 end
            if t.clock == 0 and not tasks.contains(o.aux,5) then
                t.phase = 2
                tasks.attach(o.aux,4)
                tasks.attach(o.aux,6)
            end
        end
        if t.phase == 2 and not tasks.contains(o.aux,6) then
            o.protected = false
            nextEvent(o,t,8)
        end
    end

    events[1] = {function(o,t)
        t.phase,t.clock = 0,0x12
        tasks.stop(o.aux,4)
        tasks.attach(o.aux,5)
        refit(o,t)
    end,refit}

    -- 0x19097e 挂载交叉绕行球。球瞄准的是自机与机腹之间 3/8 的位置。
    local function crossOrbs(o,t)
        if t.clock > 0 then
            t.clock = t.clock-1
            if t.clock == 0 then tasks.attach(o.attacks,10) end
        end
        local p = o.run.player
        if p and p.active then
            local dh,dl = floor((s16(o.h-0x1e00)-p.h)/2),floor((o.l-p.l)/2)
            o.orbTarget.h,o.orbTarget.l = p.h+dh-floor(dh/4),p.l+dl-floor(dl/4)
        end
    end

    events[8] = {function(o,t)
        t.clock = 0x30
        o.run.bulletCapacity = 150
        o.orbsFire,o.orbTarget = false,{active=true,h=0,l=0}
        flyTo(o,0x6e00,0x1c00)
        crossOrbs(o,t)
    end,crossOrbs}

    local function finalAttack(o,t)
        if t.first then
            t.first,o.protected = false,false
            tasks.attach(o.attacks,2)
        end
        if tasks.contains(o.attacks,0) then return end
        t.clock = t.clock-1
        if t.clock >= 0 then return end
        tasks.attach(o.attacks,0,{count=t.count,turn=t.turn})
        t.clock,t.repeatDelay = t.repeatDelay,math.max(0x22,t.repeatDelay-4)
        t.count,t.turn = math.min(7,t.count+1),-t.turn
        t.remaining = t.remaining-1
        if t.remaining == 0 then
            t.clock,t.count = t.clock+0x30,3
            t.remaining,t.repeatCount = t.repeatCount,math.min(4,t.repeatCount+1)
        end
    end

    -- 0x190a56：分离雷持续生成，大弹按原等待和轮数交替发射。
    events[12] = {function(o,t)
        t.first,t.clock,t.repeatDelay,t.remaining,t.repeatCount,t.count = true,0x60,0x40,2,3,4
        t.turn = program.s8(program.random(o.run,data.finalTurn))*2
        o.run.bulletCapacity = 190
        startWander(o,2,0x5800)
        finalAttack(o,t)
    end,finalAttack}

    -- 0x190486：每五次更新爆散一处，十处爆散之后恢复受击。
    local function finalBreak(o,t)
        t.clock = t.clock-1
        if t.clock >= 0 then return end
        local run = o.run
        program.nextRandom(run) -- 0x1904a6 选择爆炸音。
        local kind = data.recoilEffects[band(program.random(run,program.randomByte),7)+1]
        local angle = program.random(run,program.randomHalf,127)-0x20
        local dh = floor(data.recoilOffsets[program.nextRandom(run,63)]/2)-0x800
        local dl = data.recoilOffsets[program.nextRandom(run,63)]
        local effect = effects.emit(o,kind,2,angle,dh*0x10000+band(dl+floor(dl/2),0xffff),false)
        if effect then effect.onStart = debris end
        t.remaining,t.clock = t.remaining-1,4
        if t.remaining == 0 then nextEvent(o,t,12) end
    end

    events[13] = {function(o,t)
        t.clock,t.remaining = 4,10
        finalBreak(o,t)
    end,finalBreak}

    local function emitBlast(o,origin,row,jitter)
        local kind,_,dh,dl,ground,motion,_,_,delay = unpack(row)
        local speed,angle = floor(motion/256),band(motion,255)
        if jitter then
            speed = speed+floor(program.s8(program.random(o.run,program.randomNarrow))/2)
            angle = angle+program.s8(program.random(o.run,program.randomNarrow))
        end
        local e = effects.emit(origin,kind,speed,band(angle,255),dh*0x10000+band(dl,0xffff),ground~=0,delay)
        if e then e.onStart = debris end
    end

    local function collapse(o,t)
        local run = o.run
        if t.phase == 3 then
            t.clock = t.clock-1
            if t.clock == 0 then o.finished = true end
            return
        end
        if t.phase == 2 then
            t.clock = t.clock-1
            if t.clock == 0 then
                o.h,o.hidden = s16(o.h+0xc00),true
                for slot=1,80 do
                    local effect = run.effects[slot]
                    if effect then effects.remove(effect) end
                end
                for _,row in ipairs(data.defeatBlast) do emitBlast(o,o,row,false) end
                t.phase,t.clock = 3,0x80
            end
            return
        end
        if t.phase == 1 then
            t.clock = t.clock-1
            if t.clock == 0 then t.phase,t.clock = 2,8 end
            return
        end
        if t.clock > 0 then
            t.clock = t.clock-1
            if t.clock > 0 then return end
        end
        t.sound = t.sound-1
        if t.sound < 0 then
            t.sound = 8
            program.nextRandom(run)
        end
        t.blastClock = t.blastClock-1
        if t.blastClock >= 0 then return end
        local h,l = addPacked(o.h,o.l,data.defeatOffsets[t.offset])
        emitBlast(o,{run=run,h=h,l=l},data.defeatCycle[t.row],true)
        t.blastClock,t.remaining = 1,t.remaining-1
        t.offset,t.row = t.offset%#data.defeatOffsets+1,t.row%#data.defeatCycle+1
        if t.remaining == 0 then t.phase,t.clock = 1,9 end
    end

    -- 0x190032：机身按原路径下沉，六十次小爆炸结束后登记整批最终爆炸。
    events[3] = {function(o,t)
        o.direct,o.speed,o.direction = 'defeat',3,0x20
        t.phase,t.clock,t.sound,t.blastClock,t.remaining,t.offset,t.row = 0,0x10,0,0x20,0x3c,1,1
        explosion(o,o,data.explosions[6])
    end,collapse}

    local function clearPhaseTasks(o)
        tasks.clear(o.attacks)
        tasks.clear(o.events)
        for index = 3,6 do o.extraParts[index].locked = false end
        bullets.clear(o.run,1)
        o.orbsFire = false
    end

    local function changePhase(o,hit)
        clearPhaseTasks(o)
        o.phase,o.protected,o.extraParts[1].flags = 1,true,0x8000
        o.recoil = 0x10
        -- 0x17871c 为第一段击破的九档奖励推进十次随机表。
        if hit then for _ = 1,10 do program.nextRandom(o.run) end end
        explosion(o,o,data.explosions[1])
        tasks.attach(o.events,1)
    end

    local function changeFinalPhase(o,hit)
        clearPhaseTasks(o)
        o.phase,o.protected = 2,true
        -- 0x190ebc 的奖励登记在爆散前消耗随机表。V100 对照路线实测推进 0x16 次。
        if hit then for _ = 1,0x16 do program.nextRandom(o.run) end end
        tasks.attach(o.events,13)
    end

    local function startDefeat(o,hit)
        clearPhaseTasks(o)
        o.dying,o.protected,o.flags = true,true,0x8000
        for _,index in ipairs({2,3,4}) do o.extraParts[index].flags = 0x8000 end
        -- 0x191096 设置 0x1d 档奖励，之后 0x19134c 停掉发射。
        if hit then for _ = 1,0x1e do program.nextRandom(o.run) end end
        tasks.attach(o.events,3)
    end

    local phaseChange = {[0]=changePhase,[1]=changeFinalPhase,[2]=startDefeat}
    local healthLimit = {[0]=data.health[1]-data.health[2],[1]=data.health[4],[2]=0}

    local function damage(o)
        local total,impact = (o.damage or 0)+(o.mineDamage or 0),o.impact or (o.mineDamage or 0)>0
        o.damage,o.impact,o.hp = 0,nil,0x7fff
        o.mineDamage = 0
        for index = 1,6 do
            local part = o.extraParts[index]
            total,impact = total + (part.damage or 0),impact or part.impact
            part.damage,part.impact,part.hp = 0,nil,0x7fff
        end
        o.flash = impact and not o.flash
        if not o.protected and total > 0 then
            o.health = o.health-band(total,0xffff)
            if o.health <= healthLimit[o.phase] then phaseChange[o.phase](o,true) end
        end
    end

    function M.init(o)
        o.h,o.l = 0x49ff,s16(-0x2000-o.run.cameraOffset)
        o.phase,o.health = 0,data.health[1]
        o.clocks = {unpack(data.timeout)}
        o.protected,o.approaching,o.approachClock,o.brakeClock = true,true,0xa0,0
        o.speed,o.direction = 12,0x0d
        o.rotor,o.wing,o.coreFrame,o.cover,o.hull,o.wingExtension = 0,0,0,0,0,0
        o.extraParts = {}
        for i,row in ipairs(data.parts) do
            local p = i == 1 and o or {h=0,l=0}
            p.flags,p.front,p.back,p.right,p.left,p.hp,p.aim = unpack(row)
            p.barrel = p.aim
            if i > 1 then o.extraParts[i-1] = p end
        end
        o.aux = {limit=25,unique=true,handlers=aux,label='二面关底辅助'}
        o.events = {limit=5,unique=true,handlers=events,label='二面关底阶段'}
        o.attacks = {limit=20,handlers=attacks,label='二面关底发弹'}
        o.run.boss2 = o
        return true
    end

    function M.step(o)
        if o.finished then
            o.run.boss2,o.run.stageCleared = nil,true
            return false
        end
        o.age = (o.age or 0) + 1
        if o.age == 1 then
            move(o)
            for index = 0,3 do tasks.attach(o.aux,index) end
        else
            if not o.run.freeze then tasks.tick(o,o.aux) end
            if not o.run.freeze and not o.run.stopPathClock then tasks.tick(o,o.events) end
            move(o)
            if not o.run.freeze and not o.run.stopPathClock then tasks.tick(o,o.attacks) end
            if not o.dying then damage(o) end
        end
        -- 0x18e3b4 在受击处理后推机身，其他部件下一帧才跟上。
        if (o.recoil or 0) > 0 then
            local dh,dl = program.vector(o.recoil,0,o.run.slowVectors)
            o.h,o.l = s16(o.h+dh),s16(o.l+dl)
            o.recoil = o.recoil-1
        end
        if not o.dying and not o.run.freeze and not o.run.stopPathClock then
            local i = o.phase+1
            o.clocks[i] = o.clocks[i]-1
            if o.clocks[i] == 0 then
                if o.run.player and o.run.player.active then phaseChange[o.phase](o,false)
                else o.clocks[i] = 0x78 end
            end
        end
        return true
    end

    function M.render(o)
        local assets = o.run.art
        if not assets or o.hidden then return end
        local function draw(name,bank,frame,offset,part,mirror)
            local images = data.images[name][o.flash and 31 or bank]
            local h,l = addPacked(part.h,part.l,offset)
            art.draw(assets.sprites[images[frame+1]],h,l,0,0,mirror)
        end
        for index = 6,3,-1 do
            local p = o.extraParts[index]
            if not p.broken then draw('cannon',17,floor(p.barrel/8),0xf600f800,p) end
        end
        if o.damaged then
            draw('hull',15,o.hull,0xf200f200,o)
            draw('openCockpit',15,0,0xe8000000+0xf600f800,o)
        end
        if o.wingExtension > 0 then
            draw('damagedWing',17,o.wingExtension,0xe5fff000+0xec00f500,o)
            draw('damagedWing',17,o.wingExtension,0xe6001000+0xec00f500,o,true)
        else
            draw('wing',17,o.wing,0xedfff000+0xf200f500,o)
            draw('wing',17,o.wing,0xee001000+0xf200f500,o,true)
        end
        if not o.damaged then
            draw('cockpit',15,o.cover,0xf200f200,o)
            draw('rotor',17,o.rotor,0x06bfec00+0xf600f700,o)
            draw('rotor',17,o.rotor,0x06c01400+0xf600f700,o,true)
            draw('engine',13,0,0xee000000+0xe600f700,o)
            draw('core',17,o.coreFrame,0xea800000+0xf800fc00,o)
        end
        draw('nose',13,0,0x14000000+0xfa00f600,o)
    end

    return M
end
