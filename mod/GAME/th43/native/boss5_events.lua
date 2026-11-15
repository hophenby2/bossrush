-- 0x126e50 的事件槽与 0x128552 的辅助槽分别推进。发射槽由事件显式登记。
return function(program, bullets, effects, api)
    local band = require('bit').band
    local min, max = math.min, math.max
    local wait, aux, event, emit, move = api.wait, api.aux, api.event, api.emit, api.move
    local pending, stop = api.pending, api.stop
    local data = program.boss5
    local events, auxiliary = {}, {}

    local function awaitAux(o, ...)
        for j = 1, select('#', ...) do
            local id = select(j, ...)
            while pending(o.auxiliary, id) do wait(1) end
        end
    end

    local function awaitEmitter(o, ...)
        for j = 1, select('#', ...) do
            local id = select(j, ...)
            while pending(o.emitters, id) do wait(1) end
        end
    end

    local function approach(o, h, speed, cruise, pause)
        move(o, 3, speed, h, 0x1c00)
        wait(1)
        while not o.move or o.move.id ~= 2 do wait(1) end
        if pause then wait(pause) end
        move(o, 5, cruise, h, 0x1c00)
    end

    local function extinguish(o)
        stop(o.emitters, 0, 2, 4, 5, 6)
    end

    local function updateRotary(o, sign)
        for i = 1, 4 do
            o.rotaryPosition[i] = (o.rotaryPosition[i] + sign) % 256
            o.offsets[i+8] = data.rotaryTravel[o.rotaryPosition[i]+1]
        end
    end

    auxiliary[0] = function(o)
        while true do
            wait(2)
            o.wheel = (o.wheel + o.wheelStep) % 14
            for i = 1, 4 do o.rotary[i] = (o.rotary[i] + o.wheelStep) % 56 end
        end
    end

    -- 0x128744 的四张位置表各自决定炮架何时离开机身。
    auxiliary[1] = function(o)
        for index = 2, 17 do
            wait(2)
            o.travel = index
            for i = 1, 4 do o.offsets[i+8] = data.cannonTravel[i][index] end
        end
        o.travel, o.rotaryVisible = 1, true
        aux(o, 0)
    end

    auxiliary[2] = function(o)
        o.rotaryVisible = true
        wait(5)
        while true do
            updateRotary(o, o.sweepDirection)
            wait(1)
        end
    end

    auxiliary[3] = function(o)
        for cycle = 0, 4 do
            for _ = 1, 0x39 do
                wait(cycle+1)
                updateRotary(o, o.sweepDirection)
            end
        end
    end

    auxiliary[4] = function(o)
        stop(o.auxiliary, 0)
        while o.wheel ~= 14 do wait(2); o.wheel = (o.wheel + o.wheelStep) % 15 end
        while o.wheel < 29 do wait(2); o.wheel = o.wheel + 1 end
    end

    auxiliary[5] = function(o)
        repeat
            wait(2)
            o.wheel = max(0, o.wheel-1)
        until o.wheel <= 13
        o.wheel, o.wheelStep, o.rotary = 0, -o.wheelStep, {0,14,28,42}
    end

    for i = 1, 2 do
        local side = i
        auxiliary[5+i] = function(o)
            while not o.parts[side+6].broken do
                local p, run = o.parts[side+6], o.run
                if run.pilotH and o.sideAimHold ~= side then
                    local goal = program.angle(p.h,p.l,run.pilotH,run.pilotL,o.sideAim[side])
                    o.sideAim[side] = program.turnToward(o.sideAim[side], goal)
                end
                wait(1)
            end
        end
    end

    -- 0x129d74 推开阵形，旋转由另外两个辅助槽驱动。
    auxiliary[0x1a] = function(o)
        local f = o.formation
        for radius = 0, 0x97 do
            f.radius = radius
            api.drones.offsets(f)
            wait(1)
        end
        wait(0x3f)
        while not api.drones.align(f) do wait(1) end
        f.mode = 1
    end

    local function rotateFormation(f)
        f.clock = f.clock-1
        if f.clock < 0 then
            f.clock = f.interval
            f.angle = band(f.angle+f.turn,0xff)
            api.drones.offsets(f)
        end
    end

    auxiliary[0x1b] = function(o)
        local f, clock = o.formation, 0x10
        while true do
            clock = clock-1
            if clock < 0 then clock, f.interval = 0x10, max(1,f.interval-1) end
            rotateFormation(f)
            wait(1)
        end
    end

    auxiliary[0x1c] = function(o)
        local f, run, age = o.formation, o.run, 0
        local h, l
        local function retarget()
            h = 0x3c00 + program.random(run, program.boss3.target)[2]
            l = 0x1c00 + program.random(run, program.boss3.target)[2]
        end
        retarget()
        while true do
            local targetL = l - run.cameraOffset
            local goal = program.angle(f.h,f.l,h,targetL,f.heading)
            f.heading = program.turnToward(f.heading,goal)
            age = age+1
            if age == 0x30 or program.distance(f.h,f.l,h,targetL) <= 0x100 then
                age = 0
                retarget()
            end
            local dh, dl = program.vector(1,f.heading*4)
            f.h, f.l = program.s16(f.h+dh), program.s16(f.l+dl-run.cameraStep)
            wait(1)
        end
    end

    auxiliary[0x1d] = function(o)
        local f, clock = o.formation, 0x10
        while true do
            clock = clock-1
            if clock < 0 then
                clock, f.interval = 0x10, f.interval+1
                if f.interval == 0x10 then f.turn = -f.turn; return end
            end
            rotateFormation(f)
            wait(1)
        end
    end

    auxiliary[8] = function(o)
        while o.wheel > 0 do wait(2); o.wheel = (o.wheel+1) % 14 end
    end

    auxiliary[9] = function(o)
        while o.underside < #data.center[1]-1 do
            wait(2)
            o.underside = o.underside+1
        end
    end

    auxiliary[13] = function(o)
        stop(o.auxiliary, 0, 2)
        o.landing = true
        o.rotaryVisible = true
        for i = 1, 4 do o.rotaryGun[i] = 0x20 end
        api.arms.open(o)
    end

    for i = 1, 2 do
        local side = i
        auxiliary[13+i] = function(o)
            o.cover = o.cover or {0,0}
            for frame = o.cover[side], 16 do
                o.cover[side] = frame
                wait(2)
            end
        end

        auxiliary[15+i] = function(o)
            for frame = 16, 0, -1 do
                o.cover[side] = frame
                wait(2)
            end
        end

        auxiliary[17+i] = function(o)
            aux(o, 15+side)
            wait(0x40)
            emit(o, 11+side)
            awaitEmitter(o, 11+side)
        end
    end

    events[0] = function(o)
        move(o, 0, 0)
    end

    -- 0x126f24 在炮架回收后才切换到第二套本体箱。
    events[1] = function(o)
        stop(o.auxiliary, 0, 3)
        if pending(o.auxiliary, 4) then stop(o.auxiliary, 4); aux(o, 5) end
        approach(o, 0x5000, 3, 3)
        awaitAux(o, 5)
        aux(o, 8)
        awaitAux(o, 8)
        aux(o, 9)
        awaitAux(o, 9)
        aux(o, 13)
        aux(o, 14)
        aux(o, 15)
        o.phase, o.locked = 1, false
        api.active(o, 1)
        event(o, 9)
    end

    events[2] = function(o)
        o.phase = 2
        wait(1)
        event(o, o.run.route.ura and 3 or 13)
    end

    -- 0x1270cc。通常路线结算，里路线重新加载第二组机身。
    events[3] = function(o)
        move(o, 8, 3)
        aux(o, 3)
        wait(0x10)
        effects.spawn(o.run, o.h-0x1400, o.l, data.explosions[5], false)
        wait(0x24)
        local limit = o.run.route.ura and 0 or 0x2800
        local index = 1
        while true do
            local offset = data.openingExplosionOffsets[index]
            local h, l = program.add(o.h-0x1400, o.l, offset[1], offset[2])
            effects.spawn(o.run, h, l, data.explosions[7], false)
            if o.h <= limit then break end
            index = index % 3 + 1
            wait(13)
        end
        o.move = nil
        wait(9)
        wait(8)
        o.h = program.s16(o.h + 0x1800)
        if o.run.route.ura then
            move(o, 9, 8)
        else
            o.hidden = true
            wait(0x80)
            o.retire = true
        end
    end

    events[4] = function(o)
        local run = o.run
        effects.spawn(run, o.h, o.l, data.explosions[6], false)
        -- 0x1275a4 先倒数 0x20，再以 0x10 重装三处爆炸的位置游标。
        wait(0x30)
        for i = 1, 10 do
            local offset = data.finalExplosionOffsets[(i-1) % 3 + 1]
            local h, l = program.add(o.h, o.l, offset[1], offset[2])
            effects.spawn(run, h, l, data.explosions[7], false)
            if i < 10 then wait(0x11) end
        end
        -- 0xc1da2 的调色板过渡结束后，机体上移，退场时钟才开始。
        wait(9)
        wait(8)
        o.h = program.s16(o.h + 0x2000)
        o.hidden = true
        wait(0x80)
        o.retire = true
    end

    -- 0x12a194 等移动回到 2，再挂旋转发射器 0 和瞄准发射器 6。
    events[5] = function(o)
        approach(o, 0x5c00, 2, 2)
        wait(1)
        if not o.launchRails then o.launchRails = true; aux(o, 1) end
        awaitAux(o, 1)
        aux(o, 2)
        emit(o, 0)
        emit(o, 6)
        if o.locked then
            o.locked, o.run.bossPresent, o.run.uraBoss = false, true, true
            api.active(o, 0)
        end
        wait(0x100)
        event(o, 6)
    end

    events[6] = function(o)
        approach(o, 0x5c00, 2, 2, 0x81)
        stop(o.auxiliary, 2)
        aux(o, 3)
        awaitAux(o, 3)
        o.sweepDirection = -o.sweepDirection
        extinguish(o)
        wait(0x81)
        aux(o, 4)
        awaitAux(o, 4)
        emit(o, 1)
        emit(o, 3)
        wait(0x101)
        stop(o.emitters, 1)
        aux(o, 5)
        awaitAux(o, 5)
        aux(o, 0)
        event(o, 7)
    end

    events[7] = function(o)
        approach(o, 0x5c00, 2, 2, 0x40)
        aux(o, 2)
        emit(o, 0x18)
        emit(o, 4)
        emit(o, 5)
        aux(o, 0)
        wait(0x200)
        stop(o.emitters, 0x18)
        event(o, 8)
    end

    events[8] = function(o)
        approach(o, 0x5c00, 2, 2)
        extinguish(o)
        wait(0x11)
        aux(o, 4)
        awaitAux(o, 4)
        emit(o, 7)
        emit(o, 0x18)
        awaitEmitter(o, 7)
        wait(0x41)
        aux(o, 5)
        awaitAux(o, 5)
        aux(o, 0)
        stop(o.emitters, 0x18)
        event(o, 5)
    end

    events[9] = function(o)
        approach(o, 0x6000, 3, 5)
        awaitAux(o, 14, 15)
        emit(o, 8)
        emit(o, 11)
        awaitEmitter(o, 8)
        wait(0x60)
        stop(o.emitters, 11)
        event(o, 10)
    end

    local function fireAlternating(o, finite)
        approach(o, 0x6000, 3, 5)
        if not finite then
            api.active(o, 2)
            o.locked = false
        end
        stop(o.auxiliary, 16,17,18,19)
        aux(o, 14)
        aux(o, 15)
        awaitAux(o, 14, 15)
        local cycle = o.alternating or 0
        local settings = ({ {0x80,2},{0x20,2},{0x40,4} })[cycle+1]
        while true do
            emit(o, 9, finite and settings or {0x60,2})
            awaitEmitter(o, 9)
            emit(o, 10, finite and settings or {0x60,2})
            awaitEmitter(o, 10)
            if finite then
                wait(0xc0)
                o.alternating = (cycle+1) % 3
                event(o, 11)
                return
            end
        end
    end

    events[10] = function(o) fireAlternating(o, true) end
    events[13] = function(o) fireAlternating(o, false) end

    local function pointAttacks(o)
        approach(o, 0x4a00, 3, 3)
        stop(o.auxiliary, 16, 17)
        aux(o, 14)
        aux(o, 15)
        awaitAux(o, 14, 15)
        local count, pulses, period = o.pointCount or 3, o.pointPulses or 4, o.pointPeriod or 8
        o.pointCount, o.pointPulses, o.pointPeriod = min(5,count+1), min(8,pulses+2), max(4,period-1)
        local difficulty = o.run.difficulty
        local initial = o.run.route.loop == 1 and 0x14 or 0x12
        if difficulty == 0 then initial = 0x18 end
        if difficulty == 3 then initial = 0x10 end
        for i = 1, count do
            aux(o, i % 2 == 1 and 18 or 19)
            awaitAux(o, i % 2 == 1 and 18 or 19)
            emit(o, 14, {initial, difficulty == 0 and 4 or pulses, period})
            pulses = min(16,pulses+(difficulty == 2 and 2 or 1))
            wait(0x20)
        end
        event(o, 9)
    end

    events[11], events[12] = pointAttacks, pointAttacks

    events[14] = function(o)
        move(o,5,6,0x5a00,0x1c00)
        for i = 0,8 do
            o.underside = i
            wait(2)
        end
        o.locked = false
        api.active(o, 3)
        wait(0x10)
        event(o, 16)
    end

    -- 0x12b006 与 0x12b150 分别登记五向弹和刹停母弹。
    events[15] = function(o)
        approach(o,0x5a00,2,0x14)
        local direction, duration, delay = -1,8,0x10
        for _ = 1,8 do
            awaitEmitter(o,15)
            wait(delay+1)
            emit(o,15,{duration,direction})
            direction,duration,delay = -direction,min(16,duration+4),delay+2
            o.move.speed=max(8,o.move.speed-2)
        end
        stop(o.emitters,16)
        awaitEmitter(o,15)
        wait(0x40)
        event(o,18)
    end

    events[16] = function(o)
        approach(o,0x5a00,4,6)
        emit(o,16)
        local delay = o.finalSeedDelay or 0xe
        local count = o.finalSeedCount or 0x1c
        o.finalSeedDelay,o.finalSeedCount = max(6,delay-2),min(0x30,count+8)
        for i=1,count do
            if i > 1 then wait(delay+1) end
            emit(o,17)
            awaitEmitter(o,17)
        end
        stop(o.emitters,16)
        wait(0x40)
        event(o,15)
    end

    events[17] = function(o)
        approach(o,0x4c00,4,4)
        local delay,angle,step = 0x20,0xa0,4
        local count = o.finalSpiralCount or 6
        o.finalSpiralCount = min(16,count+5)
        for i=1,count do
            if i > 1 then wait(delay+1) end
            delay=max(6,delay-8)
            emit(o,18,{angle,step})
            awaitEmitter(o,18)
            angle,step=0x100-angle,-step
        end
        wait(0x40)
        event(o,16)
    end

    events[18] = function(o)
        approach(o,0x4600,4,4)
        wait(0x21)
        emit(o,19)
        awaitEmitter(o,19)
        wait(0x40)
        event(o,17)
    end

    events[19] = function(o)
        api.drones.prepare(o)
        approach(o,0x4000,2,1)
        o.formation.h, o.formation.l, o.formation.heading = o.h, o.l, o.heading
        aux(o, 0x1c)
        aux(o, 0x1a)
        emit(o,20)
        awaitEmitter(o,20)
        wait(0x40)
        o.locked = false
        event(o,20)
    end

    events[20] = function(o)
        approach(o,0x5e00,2,1)
        aux(o, 0x1b)
        wait(0x180)
        stop(o.auxiliary, 0x1b)
        aux(o, 0x1d)
        awaitAux(o, 0x1d)
        event(o,21)
    end

    events[21] = function(o)
        o.formation.mode=1
        aux(o, 0x1b)
        emit(o,23)
        wait(0x40)
        stop(o.auxiliary, 0x1b)
        aux(o, 0x1d)
        awaitEmitter(o, 23)
        wait(0x80)
        o.formation.mode=2
        wait(0x40)
        stop(o.auxiliary, 0x1d)
        o.formation.mode=1
        event(o,20)
    end

    events[23] = function(o)
        approach(o,0x5a00,2,8,0x20)
        o.locked = false
        emit(o,25)
        awaitEmitter(o,25)
        wait(0x60)
        emit(o,26)
    end

    return events, auxiliary
end
