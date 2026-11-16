-- 0x19a7e4 与 0x19aebe。部件动画可从调度或攻击槽独立挂载。
return function(program, bullets, effects, scheduler, body)
    local bit = require('bit')
    local band = bit.band
    local attach, contains, stop = scheduler.attach, scheduler.contains, scheduler.stop
    local s16 = program.s16
    local floor = math.floor
    local data = program.boss3
    local components,directors = {},{}
    local attacks = dofile('mod/GAME/th44/native/boss3_attacks.lua')(program, bullets, scheduler)

    local function pair(init, update)
        return {function(o,t) init(o,t); update(o,t) end,update}
    end

    local function done(o,t)
        o.components[t.slot] = nil
    end

    local function drawSlots(o, first, last, enabled)
        for index = first,last do o.draws[index] = enabled end
    end

    components[0] = pair(function(o,t) o.tailFrame,t.clock = 0,0 end,function(o,t)
        if not o.final then
            t.clock = t.clock - 1
            if t.clock >= 0 then return end
            t.clock = 1
        end
        o.tailFrame = (o.tailFrame + 1) % 16
    end)

    components[1] = pair(function(_,t) t.clock = 0 end,function(o,t)
        t.clock = t.clock - 1
        if t.clock >= 0 then return end
        t.clock = 1
        local pilot = o.run.player
        if not pilot or not pilot.active or o.dying then return end
        for i, wing in ipairs(o.wings) do
            local l = i == 1 and 0x80 or -0x80
            local from = o.turretAngles[i]
            local target = program.angle(s16(wing.h + 0x1100),s16(wing.l + l),pilot.h,pilot.l,from)
            o.turretAngles[i] = program.turn64(from,target)
        end
    end)

    local function shiftWing(o,t)
        t.clock = t.clock - 1
        if t.clock >= 0 then return end
        t.clock = 1
        o.wingH,o.wingL = unpack(data.wingShift[t.cursor])
        t.cursor = t.cursor + t.direction
        if t.cursor >= 38 then
            done(o,t)
            attach(o.attacks,0)
            attach(o.components,3)
        elseif t.cursor == 0 then
            done(o,t)
            attach(o.components,2)
            drawSlots(o,2,3,true)
        end
    end

    components[2] = pair(function(_,t) t.clock,t.cursor,t.direction = 0x80,2,1 end,shiftWing)
    components[3] = pair(function(_,t) t.clock,t.cursor,t.direction = 0x60,34,-1 end,shiftWing)

    local function moveCover(o,t)
        t.clock = t.clock - 1
        if t.clock >= 0 then return end
        t.clock = t.gap
        o.coverFrame = o.coverFrame + t.direction
        if o.coverFrame == t.last then done(o,t) end
    end

    components[4] = {function(o,t)
        t.gap,t.direction,t.last = 1,1,6
        moveCover(o,t)
    end,moveCover}
    components[5] = pair(function(_,t)
        t.clock,t.gap,t.direction,t.last = 0,1,-1,0
    end,moveCover)

    components[6] = pair(function(o,t) o.wingFrame,t.clock = 0,0 end,function(o,t)
        if not o.final then
            t.clock = t.clock - 1
            if t.clock >= 0 then return end
            t.clock = 0
        end
        o.wingFrame = (o.wingFrame + 1) % 8
    end)

    components[7] = pair(function(o,t)
        o.openingFrame,t.cycles,t.clock,t.frameClock = 0,0xc0,1,2
    end,function(o,t)
        if t.cycles > 0 then
            t.cycles = t.cycles - 1
            if t.cycles == 0 then o.openingFrame = 0xc0
            else
                t.frameClock = t.frameClock - 1
                if t.frameClock >= 0 then return end
                t.frameClock = 2
                o.openingFrame = o.openingFrame + 12
                if o.openingFrame ~= 0xc0 then return end
                o.openingFrame = 0
                t.cycles = t.cycles - 1
                if t.cycles == 0 then o.openingFrame = 0x60 end
                return
            end
        end
        t.clock = t.clock - 1
        if t.clock >= 0 then return end
        t.clock = 1
        o.openingFrame = o.openingFrame + 12
        if o.openingFrame == 0x1e0 then
            done(o,t)
            body.setBoxes(o,true)
            o.protected = false
            o.draws[9] = false
            drawSlots(o,0,8,true)
            for _, index in ipairs({0,1,6}) do attach(o.components,index) end
        end
    end)

    local function directorDone(o,t)
        o.directors[t.slot] = nil
    end

    local function advance(o,t,next)
        attach(o.directors,next)
        directorDone(o,t)
    end

    directors[0] = {function(o,t)
        body.phase(o,0)
        attach(o.components,7)
        directorDone(o,t)
    end,directorDone}

    local function wreck(o,row,delay,speed,direction)
        effects.emit(o,{{row[1],delay,row[3],row[4],speed,direction,flip=band(row[2],0x40) ~= 0}})
    end

    local function deathStep(o,t)
        local run = o.run
        if t.stage == 4 then
            t.wait = t.wait - 1
            if t.wait == 0 then o.finished = true; directorDone(o,t) end
        elseif t.stage == 3 then
            for i,row in ipairs(data.wreck) do
                local speed = program.bossRandom(run) + 4 + t.acceleration
                wreck(o,row,i - 1,speed,program.bossWideRandom(run))
            end
            t.stage,t.wait = 4,0x80
        elseif t.stage == 2 then
            t.wait = t.wait - 1
            if t.wait == 0 then
                t.stage,o.wipe = 3,nil
                drawSlots(o,0,9,false)
            else o.wipe = math.min(8,11 - t.wait) end
        elseif t.stage == 1 then
            t.scatterClock = t.scatterClock - 1
            if t.scatterClock < 0 then
                t.scatterClock = 0x20
                local angle = program.bossWideRandom(run)
                local dl = floor(program.bossJitter(run) / 4)
                local dh = floor(program.bossJitter(run) / 2) - 0x1000
                effects.emit(o,{{4,0,dh,dl,4,angle}})
            end
            t.accelClock = t.accelClock - 1
            if t.accelClock < 0 then
                t.accelClock = 0x11
                if t.reload > 2 then t.reload,t.acceleration = t.reload - 1,t.acceleration + 1 end
            end
            t.clock = t.clock - 1
            if t.clock < 0 then
                t.clock = t.reload
                wreck(o,data.wreck[t.cursor],0,floor(program.bossRandom(run)/4) + 2 + floor(t.acceleration/2),
                    program.bossWideRandom(run))
                t.cursor = t.cursor % #data.wreck + 1
                if t.cursor == 1 and t.reload == 2 then
                    t.stage,t.wait,o.wipe = 2,9,1
                end
            end
        else
            t.clock = t.clock - 1
            if t.clock >= 0 then return end
            t.clock = 1
            if t.cursor % 2 == 1 then program.bossWideRandom(run) end
            wreck(o,data.wreck[t.cursor],0)
            t.cursor = t.cursor % #data.wreck + 1
            if t.cursor == 1 then t.stage,t.clock,t.reload,t.accelClock = 1,0x20,0x10,0x11 end
        end
    end

    directors[1] = pair(function(o,t)
        t.stage,t.clock,t.cursor,t.acceleration,t.scatterClock = 0,1,1,0,0x20
        bullets.clearWithFade(o.run,o.credit)
    end,deathStep)

    directors[2] = pair(function(o)
        body.phase(o,1)
        attach(o.attacks,6)
        attach(o.attacks,7)
    end,function(o,t)
        if not contains(o.attacks,6) then advance(o,t,3) end
    end)

    directors[3] = pair(function(o)
        body.phase(o,2)
        attach(o.components,4,{clock=o.coverWait})
        if o.coverWait > 0x10 then o.coverWait = o.coverWait - 0x30 end
    end,function(o,t)
        if not contains(o.components,4) then
            attach(o.attacks,5)
            advance(o,t,6)
        end
    end)

    directors[6] = {function(o,t)
        if contains(o.attacks,5) or contains(o.components,5) then return end
        advance(o,t,4)
    end}
    directors[6][2] = directors[6][1]

    directors[4] = pair(function(o)
        body.phase(o,3)
        attach(o.attacks,3)
        attach(o.attacks,4)
    end,function(o,t)
        if not contains(o.attacks,4) then advance(o,t,5) end
    end)

    directors[5] = pair(function(o)
        attach(o.components,4,{clock=0x50})
    end,function(o,t)
        if contains(o.components,4) then return end
        attach(o.attacks,8)
        advance(o,t,7)
    end)

    directors[7] = pair(function(_,t) t.ready = false end,function(o,t)
        if t.ready then advance(o,t,2)
        else t.ready = not contains(o.attacks,8) and not contains(o.components,5) end
    end)

    directors[8] = pair(function(o,t)
        body.phase(o,1)
        t.clock = 0x80
    end,function(o,t)
        t.clock = t.clock - 1
        if t.clock >= 0 then return end
        attach(o.components,2)
        attach(o.attacks,1)
        attach(o.attacks,2)
        o.protected = false
        directorDone(o,t)
    end)

    local function wreckOffset(run)
        run.randomByte = band(run.randomByte + 1,0xff)
        return data.wreckOffsets[band(run.randomByte,0x3f) + 1][1]
    end

    directors[9] = pair(function(_,t)
        t.wait,t.clock,t.count = 0x40,4,0x17
    end,function(o,t)
        if t.wait > 0 then
            t.wait = t.wait - 1
            if t.wait == 0 then o.draws[8] = false end
        end
        t.clock = t.clock - 1
        if t.clock >= 0 then return end
        t.clock = 4
        local run = o.run
        program.bossWideRandom(run)
        local kind = data.wreckKinds[band(program.bossWideRandom(run),7) + 1][1]
        local direction = program.randomEnemy(run) + 0x60
        local dh,dl = floor(s16(wreckOffset(run)) / 2) - 0x19c0,s16(wreckOffset(run))
        effects.emit(o,{{kind,0,dh,dl + floor(dl / 2),2,direction}})
        t.count = t.count - 1
        if t.count < 0 then advance(o,t,8) end
    end)

    return {directors=directors,components=components,attacks=attacks}
end
