-- 0x18c744 分离核心，等护航机到位，再交替执行两种回收前炮击。
return function(program,art,actors,mounts,tasks,enter,request,move,escortMode,escortsReady)
    local band = require('bit').band
    local abs,floor,min,max = math.abs,math.floor,math.min,math.max
    local s16 = program.s16
    local data = program.boss1Core
    local displacement = program.boss1.displacement
    local direct,aux,attacks = {},{},{}

    local function aim(o,h,l)
        return program.angle(o.h,o.l,{h=h,l=l,active=true},o.heading)
    end

    -- 0x189880 退到屏幕上沿，抵达后由漫游回调接管。
    direct[6] = {function(o,t)
        o.heading,o.speed,t.clock = aim(o,t.h,s16(t.l-o.run.cameraOffset)),1,t.initialClock
    end,function(o,t)
        if not o.run.stopPathClock then
            if o.speed ~= t.limit then
                t.clock = t.clock-1
                if t.clock < 0 then t.clock,o.speed = t.initialClock,o.speed+1 end
            end
            local l = s16(t.l-o.run.cameraOffset)
            o.heading = program.towards(o.heading,aim(o,t.h,l))
            if mounts.distance(o,t.h,l) <= 0x200 then
                request(o,2,nil,o.h,s16(o.l+o.run.cameraOffset),o.heading)
            end
        end
        move(o)
    end}

    -- 0x189922 追赶的目标在核心上方 0x1600，速度上限每四次更新变动一次。
    direct[7] = {function(o,t)
        o.speed,t.cap,t.clock = 2,2,3
    end,function(o,t)
        if not o.run.stopPathClock then
            local h,l = s16(o.core.h+0x1600),o.core.l
            local distance = mounts.distance(o,h,l)
            local speed = mounts.speed(distance,data.rendezvousSpeeds,0x18)
            local angle = program.angle8(o.h,o.l,{h=h,l=l,active=true},o.heading*4)
            o.heading = floor(angle/4)
            if speed < t.cap then t.cap = t.cap-1
            elseif speed > t.cap then
                t.clock = t.clock-1
                if t.clock < 0 then t.clock,t.cap = 3,t.cap+1 end
            end
            o.speed = t.cap
            if distance <= 0x200 then o.coreReached = true end
        end
        move(o)
    end}

    aux[7] = enter(function(o,t)
        o.core.flags,o.core.frame,t.clock = 0xa001,0,0
    end,function(o,t)
        t.clock = 1-t.clock
        if t.clock == 0 then return end
        local frame = o.core.frame+4
        o.core.frame = frame > 0x5c and 0x40 or frame
    end)

    aux[8] = enter(function(o,t)
        tasks.stop(o.aux,7)
        o.core.flags,o.core.frame,t.clock = 0x8000,0x3c,0
    end,function(o,t)
        t.clock = 1-t.clock
        if t.clock == 0 then return end
        o.core.frame = o.core.frame-4
        if o.core.frame == 0 then
            o.core.frame,o.aux[t.slot] = nil,nil
        end
    end)

    local function coreMove(o,t)
        local core = o.core
        if t.accelerating then
            t.speedClock = t.speedClock-1
            if t.speedClock < 0 then
                t.speedClock = t.speedGap
                core.speed = band(core.speed+1,255)
            end
        end
        local h,l = program.vector(core.speed,core.direction*4,o.run.slowVectors)
        core.h,core.l = s16(core.h+h),s16(core.l+l-o.run.cameraStep)
    end

    local function beginGathering(o,t)
        request(o,7)
        tasks.attach(o.aux,5)
        t.travel = 3
    end

    local function gather(o,t)
        -- 还未激活充能时，散点计时器按前后两处指令分别减一。
        if not o.core.charging then
            t.orbClock = t.orbClock-1
            if t.orbClock < 0 then t.orbClock = 1 end
        end
        t.orbClock = t.orbClock-1
        if t.orbClock < 0 then
            t.orbClock = 1
            actors.queue(o,0x68)
        end
        t.ringClock = t.ringClock-1
        if t.ringClock >= 0 then return end
        t.ringClock,t.ringsLeft = 8,t.ringsLeft-1
        o.core.charging = true
        local row = actors.queue(o,0x67)
        row.radius,row.spinStep = t.ringRadius,t.spinStep
        t.ringRadius,t.spinStep = t.ringRadius+4,-t.spinStep
        if t.ringsLeft == 0 then
            t.travel,t.clock,t.afterReach = 4,1,o.coreExposed and 1 or 0x30
        end
    end

    local function followBody(o)
        local core = o.core
        local h = s16(core.h+0x1600)
        local angle = program.angle8(h,core.l,{h=o.h,l=o.l,active=true},core.direction*4)
        core.direction = floor(angle/4)
        local distance = mounts.distance(core,s16(o.h-0x1600),o.l)
        core.speed = mounts.speed(distance,data.coreSpeeds,0x13)
    end

    local function startExit(o,t)
        request(o,6,nil,0x7000,o.l)
        o.requested.initialClock = o.coreExposed and 0 or 2
        o.requested.limit = o.coreExposed and 0x10 or 7
        tasks.attach(o.attacks,o.coreExposed and 7 or 3)
    end

    local event = enter(function(o,t)
        t.stage,t.travel = 0,0
        t.ringClock,t.ringsLeft,t.ringRadius,t.spinStep,t.orbClock = 0x60,6,0x80,4,0x10
        t.speedGap = o.coreExposed and 0x18 or 0x20
        t.speedClock = t.speedGap
        o.coreReached = false
        local h = 0x5400+floor(displacement[program.nextRandom(o.run,127)]/4)
        local l
        repeat l = abs(displacement[program.nextRandom(o.run,127)]) until l >= 0x200
        local side = program.random(o.run,program.randomByte)%2 == 0 and -1 or 1
        local core = o.core
        core.h,core.l = h,0x1c00+(o.coreExposed and 0 or min(0x800,l)*side)
        core.speed,core.direction,core.charging = 0,0x20,false
        request(o,3,2,0x5400,0x1c00)
    end,function(o,t)
        coreMove(o,t)
        if t.travel == 1 then
            request(o,3,4,0x5000,o.core.l>0x1c00 and 0x800 or 0x3000)
            tasks.attach(o.attacks,6)
            t.accelerating,t.travel = true,2
        end
        if t.travel == 2 and o.phase == 2 and not o.requested then beginGathering(o,t) end
        if t.travel == 3 then gather(o,t) end
        if t.travel == 4 and o.coreReached then
            if t.afterReach > 0 then
                t.accelerating = false
                t.afterReach = t.afterReach-1
                if t.afterReach == 0 then startExit(o,t) end
            elseif not tasks.contains(o.attacks,3) and not tasks.contains(o.attacks,7) then
                t.stage,t.travel = 4,-1
                tasks.attach(o.aux,8)
                o.finishTurn = true
            end
            followBody(o)
        end
        if t.stage == 2 then
            t.clock = t.clock-1
            if t.clock == 0 then
                t.stage,o.escortsVisible = 3,false
            end
        end
        if t.stage == 0 then
            t.stage,t.travel = 1,1
            escortMode(o,16)
        end
        if t.stage == 1 and escortsReady(o,20) then
            tasks.attach(o.aux,7)
            t.stage,t.clock = 2,6
        end
        if t.stage == 4 and not tasks.contains(o.aux,8) then
            o.escortsVisible,o.coreExposed = true,not o.coreExposed
            o.events[t.slot] = nil
            tasks.attach(o.events,8)
        end
    end)

    attacks[3] = enter(function(o,t)
        local side = o.core.l>0x1c00 and 1 or -1
        t.rest,t.clock,t.left,t.angle,t.step,t.twin = 0x10,0,0,0x30*side,-2*side,false
    end,function(o,t)
        if t.left == 0 then
            t.rest = t.rest-1
            if t.rest >= 0 then return end
            t.left = 0x20
        end
        t.clock = t.clock-1
        if t.clock >= 0 then return end
        t.clock = 6
        if not o.run.blockEnemyFire then
            local row = actors.queue(o,0x66,s16(o.core.h-0x1380),o.core.l)
            row.angle,row.twin = band(t.angle,255),t.twin
        end
        t.angle,t.twin,t.left = t.angle+t.step,not t.twin,t.left-1
        if t.left == 0 then o.attacks[t.slot] = nil end
    end)

    attacks[6] = enter(function(_,t)
        t.delay,t.clock,t.left,t.rounds,t.waves,t.modifier = 0x70,0,0,2,3,4
    end,function(o,t)
        local player = o.run.player
        if t.left == 0 then
            t.delay = t.delay-1
            if t.delay >= 0 then return end
            t.delay,t.left,t.waves,t.aim = 0x20,t.waves,t.waves+2,program.angle8(o.h,o.l,player,0x80)
            if t.rounds==1 then t.modifier = 5 end
        end
        t.clock = t.clock-1
        if t.clock >= 0 then return end
        t.clock = 3
        if not player or not player.active then return end
        local target = program.angle8(o.h,o.l,player,t.aim)
        local delta = program.s8(target-t.aim)
        t.aim = band(t.aim+max(-2,min(2,delta)),255)
        for _,offset in ipairs({0,0x14,-0x14,-0x28,0x28}) do
            actors.shot(o,15,t.modifier,t.aim+offset)
        end
        t.left = t.left-1
        if t.left == 0 then
            t.rounds = t.rounds-1
            if t.rounds == 0 then o.attacks[t.slot] = nil end
        end
    end)

    attacks[7] = enter(function(_,t) t.delay = 0x50 end,function(o,t)
        t.delay = t.delay-1
        if t.delay >= 0 then return end
        if not o.run.blockEnemyFire then
            actors.queue(o,0x65,s16(o.core.h-0x1380),o.core.l)
        end
        o.attacks[t.slot] = nil
    end)

    local function render(o)
        local core = o.core
        if not core.frame then return end
        local id = data.coreImages[o.corePalette][floor(core.frame/4)+1]
        local h,l = program.addPacked(core.h,core.l,0xe800f700)
        art.draw(o.run.art.sprites[id],h,l,0,0)
    end

    return event,direct,aux,attacks,render
end
