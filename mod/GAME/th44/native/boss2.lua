-- 0x1955ea 在本体更新前结算日版 V101 第二面关底的部件伤害。
return function(program, bullets, effects, remove, hyper)
    local directory = 'mod/GAME/th44/native/'
    local scheduler = dofile(directory .. 'boss_tasks.lua')
    local attach, clear, stop, tick = scheduler.attach, scheduler.clear, scheduler.stop, scheduler.tick
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local s16, world = program.s16, program.world
    local abs, floor, min, max = math.abs, math.floor, math.min, math.max
    local data = program.boss2
    local M = {parts=12}
    local offsets = {
        {-0x1800,0x300}, {-0x11c0,0x6c0}, {-0x11c0,-0x6c0}, {-0x40,0xcc0},
        {-0x40,-0xcc0}, {0x540,0x1480}, {0x540,-0x1480}, {-0x300,0},
    }
    local hullGroup = {1,2,7,8}
    local rearGroup = {9,7,8}
    local turretPalette = {17,17,18,18}
    local basePalette = {18,23,19,16,19,13,17}
    local heavyWrecks = {data.outerWreckR,data.outerWreckL}
    local centerH, centerL = 0x5c00, 0x1c00

    local function turn(from, target)
        local delta = band(target - from,0x3f)
        if delta == 0 then return from end
        return band(from + (delta < 0x20 and 1 or -1),0x3f)
    end

    local function distance(o, h, l)
        local dh, dl = abs(s16(o.h - h)), abs(s16(o.l - l))
        dh = dh - floor(dh / 4)
        return max(dh,dl) + floor(min(dh,dl) / 2)
    end

    local function place(o)
        o.x, o.y = world(o.h,o.l)
        for index, offset in ipairs(offsets) do
            local part = o.boxes[index + 1]
            part.h, part.l = s16(o.h + offset[1]), s16(o.l + offset[2])
            part.x, part.y = world(part.h,part.l)
        end
    end

    local function phase(o, index, h, l)
        o.pendingPhase = {index=index,h=h,l=l}
    end

    local function aim(o, h, l, gradual)
        local target = program.angle(o.h,o.l,h,l,o.direction)
        o.direction = gradual and turn(o.direction,target) or target
    end

    local function move(o)
        local dh, dl = program.vector(o.speed,o.direction * 4)
        o.h, o.l = s16(o.h + dh), s16(o.l + dl)
    end

    local function nudgeSpeed(o, target)
        if o.speed ~= target then o.speed = o.speed + (o.speed < target and 1 or -1) end
    end

    local function launch(o, clock)
        o.h = s16(o.h - o.run.scrollStep * 64)
        if clock.delay > 0 then
            clock.delay = clock.delay - 1
            return
        end
        clock.velocity = min(0x100,clock.velocity + 3)
        o.h = s16(o.h + clock.velocity)
        if o.h >= 0x6200 then
            o.run.beetlesUseBossHits = true
            attach(o.directors,3)
            o.boxes[9].flags = 0xa000
            o.phase = -1
        end
    end

    local function patrol(o, clock)
        local point = data.patrol[clock.cursor]
        aim(o,point[1],point[2],true)
        move(o)
        if distance(o,point[1],point[2]) <= 0x100 then
            clock.cursor = clock.cursor % #data.patrol + 1
            o.speed = 4 - program.bossSmallRandom(o.run)
        end
    end

    local function home(o, clock)
        local threshold = o.phase == 6 and 0x200 or 0x100
        local interval = o.phase == 4 and 1 or 4
        local h, l = clock.h or centerH, clock.l or centerL
        local targetSpeed = 2
        if not clock.arrived then
            aim(o,h,l,false)
            local range = distance(o,h,l)
            targetSpeed = floor(range / (o.phase == 3 and 256 or 128))
            if range <= threshold then
                if o.phase == 6 then
                    clock.arrived, targetSpeed, interval = true, 2, 1
                    clock.speedClock = 1
                else
                    if o.phase == 3 then o.protected = false end
                    phase(o,5)
                end
            end
        elseif o.phase == 6 then
            interval = 1
            if o.speed <= 2 then
                o.speed = 2
                phase(o,5)
            end
        end
        if o.phase == 6 then targetSpeed = max(2,targetSpeed) end
        clock.speedClock = clock.speedClock - 1
        if clock.speedClock < 0 then
            clock.speedClock = interval
            nudgeSpeed(o,targetSpeed)
        end
        move(o)
    end

    local function jitter(run)
        run.randomByte = band(run.randomByte + 1,0xff)
        return data.jitter[band(run.randomByte,0x7f) + 1]
    end

    local function chooseWander(o, clock)
        clock.h = s16(clock.homeH + floor(jitter(o.run) / 4))
        clock.l = s16(clock.homeL + floor(jitter(o.run) / 4))
    end

    local function wander(o, clock)
        aim(o,clock.h,clock.l,true)
        nudgeSpeed(o,2)
        move(o)
        if distance(o,clock.h,clock.l) <= 0x100 then chooseWander(o,clock) end
    end

    local function retreat(o, clock)
        local point = data.retreat[clock.cursor]
        aim(o,point[1],point[2],true)
        move(o)
        if distance(o,point[1],point[2]) <= 0x200 then
            clock.cursor = band(program.randomEnemy(o.run),7) + 1
        end
    end

    local phases = {
        [0] = {function(_, c) c.delay, c.velocity = 0x1c0,0 end,launch},
        [1] = {function(o) o.h = s16(o.h - 0x10) end,function(o) o.h = s16(o.h - 0x10) end},
        [2] = {function(o, c)
            c.cursor, o.speed = 1,4
            local dest = data.patrol[1]
            aim(o,dest[1],dest[2],false)
        end,patrol},
        [3] = {function(_, c) c.speedClock = 4 end,home},
        [4] = {function(_, c) c.speedClock = 1 end,home},
        [5] = {function(o, c) c.homeH,c.homeL = o.h,o.l; chooseWander(o,c) end,wander},
        [6] = {function(_, c) c.speedClock = 4 end,home},
        [7] = {function(o, c) o.speed,c.cursor = 8,1 end,retreat},
    }
    for _, index in ipairs({0,2,3,4,5,6,7}) do
        local handlers = phases[index]
        local init, update = handlers[1], handlers[2]
        handlers[1] = function(o, clock) init(o,clock); update(o,clock) end
    end

    local function tickPhase(o)
        if o.pendingPhase then
            o.phaseClock, o.phase = o.pendingPhase, o.pendingPhase.index
            o.pendingPhase = nil
        end
        local clock = o.phaseClock
        if o.phase >= 0 then
            local entry = clock.running and 2 or 1
            clock.running = true
            phases[o.phase][entry](o,clock)
        end
        place(o)
    end

    local function blast(host, commands)
        for _, line in ipairs(commands) do
            local delay, kind, flags, dh, dl, velocity = unpack(line)
            effects.emit(host,{{kind,delay,dh,dl,floor(velocity / 256),band(velocity,0xff),
                flip=band(flags,0x40) ~= 0}})
        end
    end

    local function disableGun(o, index)
        local gun = o.boxes[index + 2]
        if gun.broken then return end
        gun.flags, gun.hp, gun.broken = 0x8000,-1,true
        o.hidden[index + 5] = true
        if index <= 2 then
            effects.emit(gun,{{index == 1 and 0x87 or 0x84,0,0,0}})
        else
            blast(gun,heavyWrecks[index - 2])
            program.bossWideRandom(o.run)
        end
    end

    local function settleShared(o, group)
        local damage, credit = 0,0
        for _, index in ipairs(group) do
            local part = o.boxes[index]
            credit = bor(credit,band(part.flags,0x5c00))
            damage = max(damage,band(0x7fff - part.hp,0xffff))
        end
        if credit == 0 then return end
        hyper.hit(o,credit)
        if not o.protected then o.health = o.health - damage end
        for _, index in ipairs(group) do
            local part = o.boxes[index]
            part.flags, part.hp = band(part.flags,0xa3ff),0x7fff
        end
        o.bodyHit, o.credit = true,credit
    end

    local function startDeath(o)
        if not o.run.player or not o.run.player.active then o.health = 0x200; return false end
        clear(o.attacks)
        clear(o.directors)
        stop(o.components,13)
        attach(o.directors,2)
        o.health, o.dying, o.run.bossEnding = -1,true,true
        o.bodyFlash = false
        o.run.player.protect = 0xff
        for _, index in ipairs(hullGroup) do o.boxes[index].flags = 0x8000 end
        return true
    end

    local function damageState(o)
        if o.dying then return end
        o.bodyHit = false
        if o.assembled then settleShared(o,hullGroup) end
        if o.health < 0 and startDeath(o) then return end
        local broken = 0
        for index = 1,4 do
            local part = o.boxes[index + 2]
            local hit = band(part.flags,0x5c00)
            part.flash = hit ~= 0 and not part.flash
            if hit ~= 0 then
                part.flags = band(part.flags,0xa3ff)
                hyper.hit(o,hit)
                if o.protected then part.hp = 0x5000 end
                if part.hp < 0 then
                    hyper.kill(o.run,hit,800)
                    disableGun(o,index)
                end
            end
            if part.broken then broken = broken + 1 end
        end
        if o.boxes[9].flags ~= 0x8000 then settleShared(o,rearGroup) end
        if not o.assembled and not o.assembling and (broken == 4 or o.health < 0xefc0) then
            clear(o.attacks)
            clear(o.directors)
            attach(o.directors,1)
            for index = 1,4 do disableGun(o,index) end
            o.assembling = true
            bullets.clearWithFade(o.run)
        end
        if not o.final and o.health <= 0x7700 then
            o.final = true
            clear(o.attacks)
            clear(o.directors)
            attach(o.directors,8)
        end
        if not o.run.freeze then
            o.timeout = o.timeout - 1
            if o.timeout == 0 and not startDeath(o) then o.timeout = 0x78 end
        end
        o.bodyFlash = o.bodyHit and not o.bodyFlash
    end

    local callbacks = dofile(directory .. 'boss2_tasks.lua')(program, bullets, effects, scheduler, {
        phase=phase, turn=turn, blast=blast, jitter=jitter,
    })

    function M.init(o)
        o.run.bossHyper,o.run.hyperDropsLocked = true,true
        o.boxes = {o,unpack(o.extraParts)}
        o.h, o.l = s16(0x9c00), s16(0x1c00 - o.run.cameraOffset)
        o.protected, o.health, o.timeout = true,0x2bdc0,0x2a30
        o.speed, o.direction = 0,0
        o.phase, o.hidden = -1,{}
        o.motorFrame, o.rotorFrame, o.hullFrame, o.hullLift, o.bottomFrame, o.topAngle = 0,0,0,0,0,0
        o.wingFrames = {0x28,0x30}
        for i, box in ipairs(o.boxes) do
            box.flags = 0x8000
            if data.boxes[i] then
                local _, front, back, right, left, hp, angle = unpack(data.boxes[i])
                box.front, box.back, box.right, box.left, box.hp = s16(front),s16(back),s16(right),s16(left),s16(hp)
                box.angle = band(angle,0xff)
            end
        end
        o.directors = {label='二面关底调度',limit=5,handlers=callbacks.directors}
        o.attacks = {label='二面关底攻击',limit=10,handlers=callbacks.attacks}
        o.components = {label='二面关底部件',limit=10,unique=true,handlers=callbacks.components}
        attach(o.directors,0)
        o.run.boss2 = o
        o.run.bulletCapacity = max(o.run.bulletCapacity,o.run.loop == 0 and 160 or 190)
        place(o)
        return true
    end

    function M.damage(part, amount, flags)
        part.flags,part.hp = bor(part.flags,flags),s16(part.hp - amount)
    end

    function M.step(o)
        local run = o.run
        -- 0x15869e 置位后，0x1586e4 在下一次进入关底回调时退场。
        if o.finished then
            run.boss2 = nil
            run.stageCleared = true
            remove(o)
            return
        end
        damageState(o)
        if not run.freeze then
            tick(o,o.directors)
            tickPhase(o)
            tick(o,o.attacks)
            tick(o,o.components)
        end
    end

    local function draw(o, hidden, part, name, palette, frame, dh, dl)
        if o.hidden[hidden] then return end
        local art = o.run.art[data.images[name][palette][frame + 1]]
        local x,y = world(s16(part.h + dh),s16(part.l + dl))
        Render(art[1], floor(x) + art[2] / 2, floor(y) + art[3] / 2)
    end

    function M.render(o)
        if not o.run.art or o.hiddenAll then return end
        local colors = basePalette
        if o.bodyFlash then colors = {31,31,31,31,31,31,31}
        elseif o.health <= 0x7700 and not o.dying then colors = {25,25,25,25,25,25,25} end
        draw(o,0,o.boxes[2],'motor',colors[1],o.motorFrame,-0x1400,-0x1300)
        draw(o,1,o,'hull',colors[2],o.hullFrame,-0xe00 + o.hullLift,-0x1300)
        draw(o,2,o,'bottom',colors[3],o.bottomFrame,-0x1600,-0x1300)
        draw(o,3,o,'rotor',colors[4],o.rotorFrame,-0x1200,-0x600)
        draw(o,4,o.boxes[7],'rightWing',colors[5],o.wingFrames[1] / 4,-0xa00 + o.hullLift,-0x400)
        draw(o,5,o.boxes[8],'leftWing',colors[6],o.wingFrames[2] / 4,-0xa00 + o.hullLift,-0x400)
        for index = 1,4 do
            local part = o.boxes[index + 2]
            local large = index > 2
            local bank = part.flash and 31 or band(part.hp,0xffff) <= 0x1800 and 25 or turretPalette[index]
            draw(o,index + 5,part,large and 'wingGun' or 'sideGun',bank,
                band(part.angle + 1,0x3e) / 2,large and -0xa00 or -0x600,large and -0x600 or -0x400)
        end
        draw(o,10,o.boxes[9],'topGun',colors[7],band(o.topAngle + 1,0x3e) / 2,-0x400,-0x300)
    end

    return M
end
