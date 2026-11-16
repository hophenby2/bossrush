-- 0x19612a、0x196eb0、0x197b42 是第二面关底的三组任务入口。
return function(program, bullets, effects, scheduler, body)
    local band = require('bit').band
    local attach, contains, stop = scheduler.attach, scheduler.contains, scheduler.stop
    local s16, floor, min, max = program.s16, math.floor, math.min, math.max
    local data = program.boss2
    local phase, turn, blast, jitter = body.phase, body.turn, body.blast, body.jitter
    local components, directors = {},{}

    local function forget(bank, task)
        bank[task.slot] = nil
    end

    local function pair(init, update)
        return {function(o, t) init(o,t); update(o,t) end,update}
    end

    local function angle(o, part, current)
        local pilot = o.run.player
        if not pilot or not pilot.active then return current end
        return program.angle(part.h,part.l,pilot.h,pilot.l,current)
    end

    local function cycle(field, count, clock, start)
        return {function(o,t) t.clock=clock; o[field]=start or 0 end,function(o,t)
            t.clock = t.clock - 1
            if t.clock < 0 then
                t.clock, o[field] = clock,(o[field] + 1) % count
            end
        end}
    end

    components[0] = cycle('motorFrame',8,2)
    components[11] = cycle('bottomFrame',14,2)

    local function chooseTop(o,t)
        t.clock = 0
        t.interval = program.bossSmallRandom(o.run)
        t.target = program.randomEnemy(o.run) % 64
        t.pause = program.randomEnemy(o.run)
    end

    components[1] = pair(chooseTop,function(o,t)
        t.pause = t.pause - 1
        if t.pause >= 0 then return end
        t.clock = t.clock - 1
        if t.clock < 0 then
            t.clock = t.interval
            o.topAngle = turn(o.topAngle,t.target)
            if o.topAngle == t.target then chooseTop(o,t) end
        end
    end)

    local closedRotor = {0,1,2,3,2,1}
    components[2] = {function(_,t) t.clock,t.frame=0,1 end,function(o,t)
        t.clock = t.clock - 1
        if t.clock < 0 then
            t.clock, o.rotorFrame = 3,closedRotor[t.frame]
            t.frame = t.frame % #closedRotor + 1
        end
    end}
    components[3] = pair(function(o,t)
        t.delta = program.bossSmallRandom(o.run) == 0 and -1 or 1
    end,function(o,t) o.topAngle = band(o.topAngle + t.delta,0x3f) end)

    local function aimWing(o, fixed)
        for i = 5,6 do
            local b = o.boxes[i]
            local bias = fixed and (i == 5 and 0x14 or 0x2c) or 0
            b.angle = turn(b.angle,band(angle(o,b,b.angle) + bias,0x3f))
        end
    end
    local function normalAim(o) aimWing(o,false) end
    local function spreadAim(o) aimWing(o,true) end
    components[4], components[5] = {normalAim,normalAim},{spreadAim,spreadAim}
    components[6] = {function(_,t) t.clock=2 end,function(o,t)
        t.clock = t.clock - 1
        if t.clock >= 0 then return end
        t.clock = 2
        o.rotorFrame = min(7,o.rotorFrame + 1)
        if o.rotorFrame == 7 then forget(o.components,t) end
    end}
    components[7] = {function(_,t) t.clock=0x20 end,function(o,t)
        t.clock = t.clock - 1
        if t.clock >= 0 then return end
        t.clock = 2
        o.rotorFrame = max(0,o.rotorFrame - 1)
        if o.rotorFrame == 0 then
            forget(o.components,t)
            attach(o.components,2)
        end
    end}
    components[8] = {function(_,t) t.clock,t.rising=4,true end,function(o,t)
        t.clock = t.clock - 1
        if t.rising then
            o.hullLift = o.hullLift + 0x100
            if t.clock < 0 then
                o.hullFrame,t.clock = o.hullFrame + 4,0
                if o.hullFrame == 8 then t.rising = false end
            end
        else
            o.hullLift = max(0,o.hullLift - 0x20)
            if t.clock < 0 then
                o.hullFrame,t.clock = o.hullFrame + 1,4
                if o.hullFrame == 16 then o.hullFrame,o.hullLift=0,0; forget(o.components,t) end
            end
        end
    end}
    local function hullDoor(delta, target)
        return {function(_,t) t.clock=0 end,function(o,t)
            t.clock = t.clock - 1
            if t.clock < 0 then
                o.hullFrame,t.clock = delta > 0 and min(target,o.hullFrame + delta)
                    or max(target,o.hullFrame + delta),1
                if o.hullFrame == target then forget(o.components,t) end
            end
        end}
    end
    components[9],components[10] = hullDoor(1,8),hullDoor(-1,0)
    components[12] = {function(o,t)
        t.clock = 1
        o.wingFrames[1] = band(program.bossWideRandom(o.run),0x0f) * 4
        o.wingFrames[2] = band(program.bossWideRandom(o.run),0x0f) * 4
    end,function(o,t)
        t.clock = t.clock - 1
        if t.clock < 0 then
            t.clock = 1
            for i = 1,2 do o.wingFrames[i] = band(o.wingFrames[i] + 4,0x3f) end
        end
    end}

    local function deploy(o, kind, part, h, l, speed, facing)
        local run = o.run
        local callback = program.actorCallbacks[kind][2]
        run.spawnQueue[#run.spawnQueue + 1] = {
            run.major,0,kind,0x20,false,false,callback,
            h=s16(part.h + h),l=s16(part.l + l),speed=speed,direction=facing,
        }
    end

    local trailPositions = {{-0x1000,-0xb00},{-0x1000,0x200},{-0xb80,-0xf00},{-0xb80,0x400}}
    components[13] = {function(_,t) t.cursor=1 end,function(o,t)
        local offset = trailPositions[t.cursor]
        deploy(o,0x4d,o.boxes[2],offset[1],offset[2],0,0)
        t.cursor = t.cursor % #trailPositions + 1
    end}

    directors[0] = {function(o,t)
        phase(o,0)
        for _, index in ipairs({0,2,11,12,13}) do attach(o.components,index) end
        forget(o.directors,t)
    end}

    directors[1] = pair(function(o,t)
        phase(o,3)
        o.assembled, o.protected, o.boxes[9].flags = true,true,0x8000
        o.flags,o.boxes[2].flags = 0xa000,0xa000
        t.clock = 0x10
        blast(o,data.bodyWreck)
    end,function(o,t)
        t.clock = t.clock - 1
        if t.clock == 0 then
            stop(o.components,2)
            forget(o.directors,t)
            attach(o.directors,4)
        end
    end)

    local function deathBlast(o,t,row,scatter)
        local speed, direction = 0,0
        if scatter then
            local variation = program.bossRandom(o.run)
            speed = scatter == 1 and 2 + floor(variation / 4) + floor(t.acceleration / 2)
                or 4 + variation + t.acceleration
            direction = program.bossWideRandom(o.run)
        end
        effects.emit(o,{{row[1],0,row[3],row[4],band(speed,0xff),direction}})
    end

    directors[2] = {function(o,t)
        phase(o,1)
        t.step,t.cursor,t.clock,t.rate,t.acceleration = 0,1,1,1,0
        t.ramp,t.smallClock,t.shakeClock = 0,0x20,4
    end,function(o,t)
        if t.step == 4 then
            t.clock = t.clock - 1
            if t.clock == 0 then o.finished = true; forget(o.directors,t) end
            return
        elseif t.step == 3 then
            for _, row in ipairs(data.deathBlasts) do deathBlast(o,t,row,2) end
            o.hiddenAll = true
            t.step,t.clock = 4,0x80
            return
        elseif t.step == 2 then
            t.clock = t.clock - 1
            if t.clock == 0 then t.step = 3 end
            return
        end
        if t.step == 1 then
            t.smallClock = t.smallClock - 1
            if t.smallClock < 0 then
                t.smallClock = 0x20
                program.bossWideRandom(o.run)
                local l,h = floor(jitter(o.run) / 4),floor(jitter(o.run) / 2) - 0x1000
                effects.emit(o,{{8,0,h,l}})
            end
            t.ramp = t.ramp - 1
            if t.ramp < 0 then
                t.ramp = 0x11
                if t.rate ~= 2 then t.rate,t.acceleration = t.rate - 1,t.acceleration + 1 end
            end
        end
        t.clock = t.clock - 1
        if t.clock >= 0 then return end
        t.clock = t.rate
        deathBlast(o,t,data.deathBlasts[t.cursor],t.step == 1 and 1)
        t.cursor = t.cursor + 1
        if t.cursor <= #data.deathBlasts then return end
        t.cursor = 1
        if t.step == 0 then
            t.step,t.clock,t.rate,t.ramp = 1,0x20,0x10,0x11
        elseif t.rate == 2 then
            t.step,t.clock = 2,9
        end
    end}

    local patrolShots = {{6,0x40},{7,0xa0},{8,0x40},{9,0x30}}
    local function patrolBusy(o)
        for id = 6,9 do if contains(o.attacks,id) then return true end end
        return false
    end
    directors[3] = pair(function(o,t)
        phase(o,2)
        stop(o.components,1)
        attach(o.components,3)
        t.step,t.wait,t.choice,t.rounds,t.longCycle = 0,0x40,0,0,2
    end,function(o,t)
        if t.step == 0 then
            if t.wait > 0 then
                t.wait = t.wait - 1
                if t.wait == 0 then
                    o.protected = false
                    attach(o.attacks,6,{count=0xa0})
                end
            elseif not contains(o.attacks,6) then t.step = 2 end
        end
        if t.step == 2 and not patrolBusy(o) then
            local index
            repeat index = band(program.randomEnemy(o.run),3) until index ~= t.choice
            t.choice = index
            local row = patrolShots[index + 1]
            attach(o.attacks,row[1],{count=row[2]})
            t.rounds = t.rounds + 1
            if t.rounds == 3 then t.rounds,t.step,t.wait = 0,3,0x40 end
        end
        if t.step == 3 and not patrolBusy(o) then
            if t.wait > 0 then
                t.wait = t.wait - 1
                if t.wait == 0 then t.delay,t.spacing,t.repeats = 0x20,0x40,4 end
                return
            end
            if not contains(o.attacks,11) then
                attach(o.attacks,11,{count=4,spacing=t.spacing})
                t.spacing,t.repeats = max(0x10,t.spacing - 8),t.repeats - 1
                if t.repeats == 0 then t.step = 2; return end
            end
            if not contains(o.attacks,10) then
                t.delay = t.delay - 1
                if t.delay < 0 then
                    t.delay = 0
                    attach(o.attacks,10,{count=t.longCycle + band(program.randomEnemy(o.run),3)})
                end
            end
        end
    end)

    directors[4] = pair(function(o,t)
        t.step,t.wait,t.wingWait,t.centerWait,t.fanWidth = 0,0x60,0x20,0x30,0x1e
        t.wingRound,t.side,t.hatchWait,t.hatchBursts = 3,1,0x20,3
        t.hatchGap,t.centerCycle,t.sideMode = 0x20,0x60,1
    end,function(o,t)
        if t.step == 0 then
            t.wait = t.wait - 1
            if t.wait ~= 0 then return end
            stop(o.components,2)
            attach(o.components,6)
            t.step = 2
        end
        if t.sideMode == 1 and not contains(o.attacks,1) and not contains(o.attacks,14) then
            t.wingWait = t.wingWait - 1
            if t.wingWait < 0 then
                t.wingWait = o.health >= 0x7700 and 0x24 or 8
                t.wingRound = t.wingRound - 1
                local last = t.wingRound < 0
                attach(o.attacks,14,{wait=last and 4 or 2,spacing=last and -6 or -5,
                    kind=last and 11 or 4,secondKind=last and 12 or 5})
                if last then t.wingRound,t.sideMode=3,2 end
            end
        end
        if t.sideMode == 2 and not contains(o.attacks,1) then
            t.centerCycle = t.centerCycle - 1
            if t.centerCycle < 0 then
                attach(o.attacks,1,{sign=t.side,count=t.fanWidth})
                t.side,t.fanWidth,t.centerCycle,t.sideMode = -t.side,min(0x28,t.fanWidth + 1),0x60,1
            end
        end
        if t.step == 2 and not contains(o.components,10) and not contains(o.attacks,12) then
            t.centerWait = t.centerWait - 1
            if t.centerWait < 0 then t.centerWait,t.step,t.wait=0x40,3,0x20 end
        end
        if t.step == 3 and not contains(o.attacks,12) then
            t.wait = t.wait - 1
            if t.wait == 0 then attach(o.components,9); t.step = 4 end
        end
        if t.step == 4 and not contains(o.components,9) and not contains(o.attacks,13) then
            t.hatchWait = t.hatchWait - 1
            if t.hatchWait < 0 then
                t.hatchWait = t.hatchGap
                attach(o.attacks,13,{count=4})
                t.hatchBursts = t.hatchBursts - 1
                if t.hatchBursts == 0 then
                    t.hatchBursts,t.hatchGap,t.step = 3,max(0x10,t.hatchGap - 4),5
                    t.hatchWait = t.hatchGap
                end
            end
        end
        if t.step == 5 and not contains(o.attacks,13) then attach(o.components,10); t.step = 2 end
    end)

    directors[8] = {function(o,t)
        attach(o.components,10)
        attach(o.attacks,15,{count=0x10,wait=0x20,reload=0xa})
    end,function() end}

    return {
        components=components,directors=directors,
        attacks=dofile('mod/GAME/th44/native/boss2_attack.lua')(program, bullets, angle, turn, deploy, jitter),
    }
end
