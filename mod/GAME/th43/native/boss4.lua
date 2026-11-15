-- 四面关底 0x79。移动 0x120086、事件 0x120612、辅助 0x122e9a 与发射 0x121e18 独立推进。
return function(program, bullets, effects, score)
    local data = program.boss4
    local band = require('bit').band
    local floor, min, max = math.floor, math.min, math.max
    local s16, add = program.s16, program.add
    local M = {}
    local events, movement = {}, {}
    local resume, yield = coroutine.resume, coroutine.yield
    local children = dofile('mod/GAME/th43/native/boss4_children.lua')(program, bullets, effects, data)
    local emitters = dofile('mod/GAME/th43/native/boss4_emitters.lua')(program, bullets, data, children)
    local center = 0x1c00
    local thresholds = {0x51400, 0x1a000, -1}
    local phasePoints = {0x1ae,0x26c,0x320}

    local function damage(p, amount)
        p.damagePending = p.damagePending + amount
    end

    local Part = Class(object, {
        init = function(p, o, bounds)
            p.host, p.run, p.hitPool = o, o.run, 2
            p.hp, p.damagePending, p.damage = o.hp, 0, damage
            p.front, p.back, p.right, p.left = unpack(bounds)
            p.group, p.layer, p.bound, p.colli = GROUP.ENEMY, LAYER.ENEMY, false, false
        end,
    })

    local function sleep(frames)
        for _ = 1, frames do yield() end
    end

    local function advance(script)
        local ok, message = resume(script)
        if not ok then error(debug.traceback(script, tostring(message)), 0) end
        return coroutine.status(script) == 'dead'
    end

    local function runCallback(callback, o, arg)
        return coroutine.create(function() callback(o, arg) end)
    end

    local function event(o, id)
        o.eventId, o.event = id, runCallback(events[id], o)
    end

    local function has(o, id)
        for _, s in pairs(o.emitters) do if s.id == id then return true end end
        return false
    end

    local function emit(o, id, arg)
        for i = 1, 20 do
            if not o.emitters[i] then
                o.emitters[i] = {id=id, callback=runCallback(emitters[id], o, arg)}
                return
            end
        end
    end

    local function stop(o, id)
        for i, s in pairs(o.emitters) do
            if s.id == id then o.emitters[i] = nil end
        end
    end

    local function awaitEmitter(o, id)
        yield()
        while has(o, id) do yield() end
    end

    local function move(o, id, speed, h, l)
        o.mover = {id=id, speed=speed, h=h, l=l}
    end

    local function awaitDrift(o)
        while o.mover.id ~= 2 do yield() end
    end

    local function fly(o, speed, direction)
        local dh, dl = program.vector(speed, direction * 4)
        o.h, o.l = s16(o.h + dh), s16(o.l + dl)
    end

    movement[0] = function(o)
        if not o.carrierReady then return end
        o.run.bossPresent, o.run.uraBoss, o.active = true, true, true
        o.parts[1].colli, o.locked = true, false
        event(o, 4)
        move(o, 2, 0, o.h, o.l + o.run.cameraOffset)
    end

    movement[1] = function(o) fly(o, 1, 0x20) end

    local function aim(o, h, l, snap)
        local angle = program.angle(o.h, o.l, h, l, o.angle)
        o.angle = snap and angle or program.turnToward(o.angle, angle)
    end

    -- 0x1201ca 的目标保留卷轴基准，每次转向限制为一个方向单位。
    movement[2] = function(o, m)
        if not m.targetH or program.distance(o.h, o.l, m.targetH, m.targetL - o.run.cameraOffset) <= 0x100 then
            m.targetH, m.targetL = add(m.h, m.l, unpack(program.random(o.run, program.boss3.target)))
        end
        aim(o, m.targetH, m.targetL - o.run.cameraOffset)
        fly(o, m.speed, o.angle)
    end

    movement[3] = function(o, m)
        local distance = program.distance(o.h, o.l, m.h, m.l)
        if not m.half then
            local row = program.boss3.lift[band(m.speed, 0xf) + 1][1]
            m.half, m.rate = floor(distance / 2), floor(row / 0x1000000)
            m.reload, m.delta, m.velocity = band(floor(row / 0x10000), 0xff), band(row, 0xff), 2
            aim(o, m.h, m.l, true)
        else
            aim(o, m.h, m.l)
        end
        m.rate = m.rate - 1
        if m.rate < 0 then
            m.rate = m.reload
            m.velocity = band(m.velocity + (distance >= m.half and m.delta or -m.delta), 0xff)
        end
        if distance <= 0x200 or m.velocity == 0 then move(o, 2, 3, o.h, o.l) end
        fly(o, m.velocity, o.angle)
    end

    for id = 4, 6 do
        local mode = id
        movement[id] = function(o, m)
            local run = o.run
            if not m.targetH or m.age == 0x30 or program.distance(o.h, o.l, m.targetH, m.targetL) <= 0x100 then
                m.targetH = s16(m.h + program.random(run, program.boss3.target)[2])
                local l = mode == 4 and run.pilotL or m.l
                local source = mode == 4 and not run.pilotL and program.boss3.target or program.patrol43.debris
                m.targetL, m.age = s16(l + program.random(run, source)[2]), 0
            end
            m.age = m.age + 1
            aim(o, m.targetH, m.targetL - (mode == 4 and run.cameraOffset or 0))
            if mode == 6 then o.l = s16(o.l + run.cameraStep) end
            fly(o, m.speed, o.angle)
        end
    end

    movement[7] = function(o, m)
        aim(o, m.h, m.l)
        if program.distance(o.h, o.l, m.h, m.l) <= 0x100 then move(o, 2, 3, o.h, o.l) end
        fly(o, m.speed, o.angle)
    end

    local function setAux(o, id)
        o.auxiliary[id] = 0
    end

    local function stopAux(o, id)
        o.auxiliary[id] = nil
    end

    local function awaitAux(o, id)
        while o.auxiliary[id] do yield() end
    end

    local function updateAuxiliary(o)
        for id, age in pairs(o.auxiliary) do
            if id == 0 and age % 2 == 1 then
                o.wingAssembly = min(0x1c, o.wingAssembly + 4)
                if o.wingAssembly == 0x1c then o.auxiliary[id] = nil end
            elseif id == 1 then
                for i = 1, 2 do o.turret[i] = program.turnToward(o.turret[i], 0x20) end
                if o.turret[1] == 0x20 and o.turret[2] == 0x20 then o.auxiliary[id] = nil end
            elseif (id == 2 or id == 3) and age % 2 == 1 then
                o.hatch = id == 2 and max(0, o.hatch - 4) or min(0x3c, o.hatch + 4)
                if o.hatch == (id == 2 and 0 or 0x3c) then o.auxiliary[id] = nil end
            elseif id == 4 and age % 2 == 1 then
                for i = 1, 2 do
                    local angle = o.outerGun[i]
                    o.outerGun[i] = angle == 0x20 and angle or angle + (angle < 0x20 and 1 or -1)
                end
                if o.outerGun[1] == 0x20 and o.outerGun[2] == 0x20 then o.auxiliary[id] = nil end
            elseif id == 5 then
                o.flame = band(o.flame + 1, 7)
            elseif id == 6 and age % 2 == 1 then
                o.nozzle = band(o.nozzle - 1, 3)
            elseif id == 7 and o.run.pilotH then
                local h, l = add(o.h, o.l, 0xb40, 0)
                o.eyeAngle = program.turnToward(o.eyeAngle, program.angle(h, l, o.run.pilotH, o.run.pilotL))
            end
            if o.auxiliary[id] then o.auxiliary[id] = age + 1 end
        end
    end

    local function openHull(o, phase)
        o.phase, o.locked = phase, false
        o.parts[phase+1].colli = true
    end

    local function advancePhase(o)
        for _, p in ipairs(o.parts) do p.colli, p.damagePending = false, 0 end
        o.locked, o.emitters = true, {}
        bullets.clearFor(o.run, o.phase == 2 and 0x400 or 0x10)
        if o.phase == 2 then
            o.hp, o.dead = -1, true
            score.finishBoss(o.run)
        end
        o.timerPhase = min(3,o.phase+2)
        event(o, o.phase + 1)
    end

    local function applyDamage(o)
        local phase = o.phase + 1
        local part = o.parts[phase]
        if not o.locked then
            o.hp = o.hp - part.damagePending
            if o.hp <= thresholds[phase] then
                if o.phase < 2 or o.run.pilotH then
                    score.kill(part,phasePoints[phase],nil,nil,o,o.phase==2)
                    advancePhase(o)
                    return
                end
                o.hp = 0x200
            end
        end
        part.hp = o.hp
        for _, p in ipairs(o.parts) do p.damagePending = 0 end
        if o.dead then return end
        local timer = o.timerPhase
        o.timeouts[timer] = o.timeouts[timer] - 1
        if o.timeouts[timer] == 0 then
            if o.run.pilotH then advancePhase(o)
            else o.timeouts[timer] = 0x78 end
        end
    end

    -- 0x120682 先产生组装机和四个 0x7a，移动 0 要等组装机回报后才开放本体判定。
    events[0] = function(o)
        setAux(o, 6)
        children.carrier(o)
        children.thrusters(o)
        move(o, 0, 0)
    end

    events[1] = function(o)
        move(o, 3, 3, 0x4400, center)
        o.turret[1], o.turret[2] = 0x20, 0x20
        stopAux(o, 4)
        stopAux(o, 5)
        stopAux(o, 6)
        for _ = 1, 5 do
            sleep(5)
            effects.spawn(o.run, o.h, o.l, {{0,0x8b,0,0,0,0,o.angle*4}}, false, true)
        end
        children.wing(o, 1)
        sleep(24)
        children.wing(o, 2)
        awaitDrift(o)
        move(o, 5, 1, 0x4400, center)
        while not o.wingReady[1] or not o.wingReady[2] do yield() end
        setAux(o, 0)
        awaitAux(o, 0)
        openHull(o, 1)
        event(o, 11)
    end

    events[2] = function(o)
        openHull(o, 2)
        o.auxiliary = {}
        effects.spawn(o.run, o.h, o.l, data.death, false)
        sleep(16)
        event(o, 13)
    end

    events[3] = function(o)
        move(o, 1, 1)
        local h, l = add(o.h, o.l, -0x1800, 0)
        effects.spawn(o.run, h, l, data.death, false)
        sleep(0x10 + 0x21)
        for i = 1, 10 do
            local dh, dl = unpack(data.deathOffsets[(i-1) % 3+1])
            h, l = add(o.h, o.l, dh - 0x2000, dl)
            effects.spawn(o.run, h, l, data.deathTrail, false)
            sleep(0x11)
        end
        sleep(8)
        o.h, o.hidden = s16(o.h + 0x1c00), true
        sleep(0x80)
        o.retire = true
    end

    -- 0x121158 与 0x121296/0x12135a 切换主机和四个炮架的命令。
    events[4] = function(o)
        move(o, 3, 3, 0x6200, center)
        sleep(0x60)
        o.childCommand = 1
        local sweep = {interval=o.sweepInterval, ending=false}
        emit(o, 9, sweep)
        o.sweepInterval = max(2, o.sweepInterval - 1)
        for count = 4, 9 do
            emit(o, 1, count)
            awaitEmitter(o, 1)
            if count < 9 then sleep(0x15) end
        end
        sweep.ending = true
        awaitEmitter(o, 9)
        o.childCommand = 2
        setAux(o, 4)
        o.opening = 1 - o.opening
        event(o, o.opening == 1 and 5 or 6)
    end

    events[5] = function(o)
        move(o, 3, 2, 0x5800, center)
        awaitDrift(o)
        move(o, 5, 1, 0x5800, center)
        o.childCommand = 3
        sleep(0x200)
        o.childCommand = 2
        event(o, 4)
    end

    events[6] = function(o)
        local d = o.run.difficulty + 1
        local interval, count = ({0x20,0x20,0x18,0x10})[d], ({1,3,3,4})[d]
        move(o, 3, 3, 0x5800, center)
        awaitDrift(o)
        sleep(0x21)
        move(o, 7, 0xa, 0xc00, center)
        while o.mover.id ~= 2 do
            if not has(o, 0) then
                emit(o, 0, count)
                count = count + 1
                for _ = 1, interval + 1 do
                    yield()
                    if o.mover.id == 2 then break end
                end
            else
                yield()
            end
        end
        awaitEmitter(o, 0)
        move(o, 2, 1, o.h, o.l)
        sleep(0x18)
        event(o, 7)
    end

    events[7] = function(o)
        local duration = o.returnDelay
        o.returnDelay = min(0x200, duration + 0x80)
        sleep(0x11)
        emit(o, 3)
        sleep(0x40)
        move(o, 7, 4, 0x3400, center)
        emit(o, 2)
        sleep(duration)
        stop(o, 2)
        move(o, 3, 3, 0x6e00, center)
        o.childCommand = 4
        awaitDrift(o)
        o.childCommand = 2
        event(o, 4)
    end
    events[8] = events[7]

    local function approach(o, height, speed)
        move(o, 3, 2, height, center)
        awaitDrift(o)
        move(o, 5, speed, height, center)
    end

    events[9] = function(o)
        approach(o, 0x5400, 3)
        stopAux(o, 7)
        emit(o, 5)
        sleep(0x18)
        emit(o, 4, o.run.difficulty == 0 and 5 or 10)
        awaitEmitter(o, 4)
        setAux(o, 1)
        sleep(0x60)
        stop(o, 5)
        setAux(o, 7)
        event(o, 12)
    end

    events[10] = function(o)
        move(o, 3, 2, 0x5400, center)
        awaitDrift(o)
        move(o, 3, 2, 0xc00, center)
        awaitDrift(o)
        move(o, 7, 2, 0x4c00, center)
        emit(o, 6)
        children.wingPulse(o, o.pulseInterval)
        o.pulseInterval = max(8, o.pulseInterval - 4)
        while o.mover.id ~= 2 and not o.pulseDone do yield() end
        stop(o, 6)
        move(o, 3, 2, 0x5400, center)
        awaitDrift(o)
        setAux(o, 1)
        awaitAux(o, 1)
        event(o, 12)
    end

    events[11] = function(o)
        approach(o, 0x5400, 2)
        setAux(o, 2)
        awaitAux(o, 2)
        sleep(8)
        emit(o, 8, {interval=o.carrierInterval, count=0x12})
        awaitEmitter(o, 8)
        sleep(0x18)
        setAux(o, 3)
        awaitAux(o, 3)
        o.carrierInterval = max(0x18, o.carrierInterval - 8)
        event(o, 12)
    end

    events[12] = function(o)
        local d = o.run.difficulty + 1
        local count = d == 1 and 3 or o.hatchWaves
        local pause = ({12,4,3,2})[d]
        if d >= 3 then o.hatchWaves = o.hatchWaves + d - 2 end
        approach(o, 0x5400, 2)
        setAux(o, 2)
        awaitAux(o, 2)
        sleep(8)
        for _ = 1, count do
            sleep(pause+1)
            emit(o, 10)
            awaitEmitter(o, 10)
        end
        sleep(0x10)
        setAux(o, 3)
        awaitAux(o, 3)
        local id = ({10,9,11})[o.hatchNext]
        o.hatchNext = o.hatchNext % 3 + 1
        o.hatchWaves = min(8, o.hatchWaves + 1)
        setAux(o, 1)
        event(o, id)
    end

    events[13] = function(o)
        approach(o, 0x3800, 1)
        children.orbits(o)
        while not o.orbitsReady do yield() end
        emit(o, 11)
        sleep(0x40)
        o.orbitsTurn = true
    end

    local function draw(o, rows, frame, h, l, right)
        local image = o.run.art.sprites[rows[frame][right and 2 or 1]]
        h, l = add(o.h, o.l, h, l)
        Render(image[1], floor(l/64) - 112 + image[2]/2, floor(h/64) - 224 + image[3]/2)
    end

    local Boss = Class(object, {
        init = function(o, run)
            o.run, o.hp, o.maxhp = run, data.hp, data.hp
            o.h, o.l, o.angle = 0x4a00, center - run.cameraOffset, 0
            o.phase, o.locked, o.timerPhase, o.timeouts = 0, true, 1, {unpack(data.timeouts)}
            o.group, o.layer, o.colli, o.bound = GROUP.GHOST, LAYER.ENEMY, false, false
            o.parts, o.children, o.emitters, o.auxiliary = {}, {}, {}, {}
            o.turret, o.outerGun, o.wingReady = {0x20,0x20}, {0x20,0x20}, {}
            o.wingAssembly, o.hatch, o.flame, o.nozzle, o.eyeAngle = 0, 0x3c, 0, 0, 0x20
            o.opening, o.childCommand = 0, 0
            o.sweepInterval, o.returnDelay, o.pulseInterval = 3, 0x80, 0x18
            o.carrierInterval, o.hatchWaves, o.hatchNext = 0x48, 3, 1
            for i, bounds in ipairs(data.parts) do o.parts[i] = New(Part, o, bounds) end
            event(o, 0)
            run.capacity = 190
        end,
        render = function(o)
            if o.hidden then return end
            draw(o, data.hull, 1, 0x980, -0x800)
            draw(o, data.deck, 1, -0x2680, 0)
            draw(o, data.deck, 1, -0x2681, -0xa00, true)
            if o.phase == 0 then
                draw(o, data.cover, 1, 0x280, 0x500)
                draw(o, data.cover, 1, 0x280, -0xd00, true)
                draw(o, data.sideEngine, o.nozzle+1, -0x1080, 0x880)
                draw(o, data.sideEngine, o.nozzle+1, -0x1080, -0xe80, true)
            else
                draw(o, data.turret, floor(o.turret[1]/2)+1, -0x500, 0x640)
                draw(o, data.turret, floor(o.turret[2]/2)+1, -0x500, -0xe40)
                draw(o, data.eye, floor(o.eyeAngle/2)+1, 0x740, -0x200)
                if o.phase == 1 then
                    draw(o, data.wingOpen, floor(o.hatch/4)+1, -0xc01, -0x2200, true)
                    draw(o, data.wingOpen, floor(o.hatch/4)+1, -0xc00, 0x200)
                end
            end
            draw(o, data.rearEngine, o.nozzle+1, -0x1d00, 0x540)
            draw(o, data.rearEngine, o.nozzle+1, -0x1d00, -0xd40, true)
            draw(o, data.engineFlash, o.flame+1, -0x1d80, -0x200)
        end,
    })

    local function position(o)
        o.x, o.y = program.world(o.h, o.l)
        for _, p in ipairs(o.parts) do
            p.h, p.l, p.x, p.y = o.h, o.l, o.x, o.y
        end
    end

    function M.spawn(run)
        run.boss4 = New(Boss, run)
        position(run.boss4)
        return run.boss4
    end

    function M.step(o)
        local run = o.run
        if run.freeze then return end
        o.l = s16(o.l - run.cameraStep)
        updateAuxiliary(o)
        local script = o.event
        if script and advance(script) and o.event == script then o.event = nil end
        if o.mover then movement[o.mover.id](o, o.mover) end
        position(o)
        for i = 1, 20 do
            local slot = o.emitters[i]
            if slot and advance(slot.callback) and o.emitters[i] == slot then o.emitters[i] = nil end
        end
        children.step(o)
        applyDamage(o)
        if o.retire then
            run.stageCleared, run.nextStageNumber = true, 5
            M.close(o)
        end
    end

    function M.close(o)
        o.run.boss4, o.run.bossPresent, o.run.uraBoss = nil, false, false
        children.close(o)
        for _, part in ipairs(o.parts) do if IsValid(part) then object.RawDel(part) end end
        if IsValid(o) then object.RawDel(o) end
    end

    return M
end
