-- 0x190b0a 先结算部件耐久，再经 0x1586e4 推进首面关底挂载的回调。
return function(program, bullets, effects, remove)
    local bit = require('bit')
    local band, bor = bit.band, bit.bor
    local abs, floor, min, max = math.abs, math.floor, math.min, math.max
    local s16, world, vector = program.s16, program.world, program.vector
    local data = program.boss1
    local M = {parts=9}

    -- 0x1588c2、0x158a18、0x158ace。三组任务都先占槽，执行顺序取决于槽号。
    local function attach(bank, index, fields)
        local empty
        for i = 1, bank.limit do
            local task = bank[i]
            if not task and not empty then empty = i end
            if bank.unique and task and task.index == index then return end
        end
        if empty then
            local task = fields or {}
            task.index, task.slot = index, empty
            bank[empty] = task
        end
    end

    local function contains(bank, index)
        for i = 1, bank.limit do
            if bank[i] and bank[i].index == index then return true end
        end
        return false
    end

    local function stop(bank, index)
        for i = 1, bank.limit do
            if bank[i] and bank[i].index == index then bank[i] = nil end
        end
    end

    local function tick(o, bank)
        for i = 1, bank.limit do
            local task = bank[i]
            if task then
                local handlers = assert(bank.handlers[task.index],
                    ('尚未翻译一面关底%s回调 %02x'):format(bank.label, task.index))
                if task.running then handlers[2](o, task)
                else
                    task.running = true
                    handlers[1](o, task)
                end
            end
        end
    end

    local function request(o, phase)
        o.nextPhase = phase
    end

    local function add(o, dh, dl)
        o.h, o.l = s16(o.h + dh), s16(o.l + dl)
    end

    local function move(o)
        local dh, dl = vector(o.speed, o.direction * 4)
        add(o, dh, dl)
    end

    local function turn(from, into)
        local diff = band(into - from, 0x3f)
        if diff == 0 then return from end
        return band(from + (diff < 0x20 and 1 or -1), 0x3f)
    end

    local function steer(o, h, l, gradual)
        local angle = program.angle(o.h, o.l, h, l, o.direction)
        o.direction = gradual and turn(o.direction, angle) or angle
    end

    local function start(init, update)
        return function(o, clock)
            init(o, clock)
            update(o, clock)
        end
    end

    local function distance(o, h, l)
        local dh, dl = abs(s16(o.h - h)), abs(s16(o.l - l))
        dh = dh - floor(dh / 4)
        return max(dh, dl) + floor(min(dh, dl) / 2)
    end

    local function position(part, h, l)
        part.h, part.l = s16(h), s16(l)
        part.x, part.y = world(part.h, part.l)
    end

    -- 0x191354 用四帧前的船身位置跟随。翅膀的伸缩和摆动另由各自任务修改。
    local function positionParts(o)
        local history = o.history
        local earliest = history[4]
        for i = 4, 2, -1 do history[i] = history[i - 1] end
        history[1] = {o.h,o.l}
        local tail = o.tail
        local h, l = program.addPacked(o.h, o.l, tail.offsetH - 0x2000, tail.offsetL)
        position(tail, h, l)
        for i, wing in ipairs(o.wings) do
            if not wing.broken then
                local h, l = program.addPacked(earliest[1], earliest[2], wing.offsetH, wing.offsetL)
                local dh, dl = vector(wing.arm, wing.angle)
                position(wing, h + dh * 2 - 0x280 - wing.extension, l + dl * 4 + (i == 1 and 0x80 or -0x80))
            end
        end
    end

    local function activate(o)
        request(o, 2)
        attach(o.directors, 1)
        for _, id in ipairs({0,1,2,3,7}) do attach(o.components, id) end
        o.vulnerable = true
        o.flags = 0xa001
        for _, wing in ipairs(o.wings) do wing.flags = 0xa001 end
        o.showHull, o.showPlate = true, false
    end

    local function arrivalInit(o, clock)
        o.speed, o.direction = 0x1e, 0x20
        clock.brake, clock.plate = 1, 1
    end

    -- 0x191424：接近屏幕中心后减速，舱盖走完才开放射击与机体碰撞。
    local function arrival(o, clock)
        local h, l = 0x5400, 0x1c00 - o.run.cameraOffset
        steer(o, h, l, true)
        move(o)
        for i = 1, 4 do o.history[i] = {o.h,o.l} end
        if distance(o, h, l) <= 0x1800 then
            clock.close = true
            clock.brake = clock.brake - 1
            if clock.brake < 0 then
                clock.brake, o.speed = 1, max(0, o.speed - 1)
            end
        end
        if clock.close then
            clock.plate = clock.plate - 1
            if clock.plate < 0 then
                clock.plate = 1
                o.plate = o.plate + 1
                if o.plate == 24 then activate(o) end
            end
        else
            o.plate = (o.plate + 1) % 4
        end
        positionParts(o)
    end

    local function depart(o)
        add(o, -0x10, 0)
        local h, l = program.addPacked(o.h, o.l, o.tail.offsetH - 0x2200, o.tail.offsetL)
        position(o.tail, h, l)
    end

    local function newTarget(o, clock)
        clock.target = band(program.randomEnemy(o.run), 7) + 1
        clock.speed = band(program.randomEnemy(o.run), 3) + 2
    end

    local function drift(o, clock)
        local h, l = unpack(data.targets[o.phase][clock.target])
        steer(o, h, l, true)
        if o.speed ~= clock.speed then o.speed = o.speed + (o.speed < clock.speed and 1 or -1) end
        move(o)
        if distance(o, h, l) <= 0x100 then newTarget(o, clock) end
        positionParts(o)
    end

    local function straight(h, nextPhase)
        return function(o)
            local l = 0x1c00
            steer(o, h, l, false)
            local d = distance(o, h, l)
            local speed = floor(d / 0x80)
            if d <= 0x100 then request(o, nextPhase) end
            if o.speed ~= speed then o.speed = o.speed + (o.speed < speed and 1 or -1) end
            move(o)
            positionParts(o)
        end
    end

    local function seekInit(o)
        o.speed = o.wings[1].broken and o.wings[2].broken and 8 or 4
    end

    local function seek(o)
        steer(o, 0x5c00, 0x1c00, false)
        if distance(o, 0x5c00, 0x1c00) <= 0x100 then request(o, 2) end
        move(o)
        positionParts(o)
    end

    local phases = {
        [0]={start(arrivalInit,arrival), arrival}, [1]={depart, depart},
        [2]={start(function(o, clock) o.speed,o.direction=0,0x20; newTarget(o,clock) end,drift), drift},
        [3]={straight(0x6a00,4), straight(0x6a00,4)}, [4]={start(newTarget,drift), drift},
        [5]={start(seekInit,seek), seek}, [6]={straight(0x7400,7), straight(0x7400,7)},
        [7]={start(newTarget,drift), drift}, [8]={straight(0x7400,4), straight(0x7400,4)},
    }

    local directory = 'mod/GAME/th44/native/'
    local attacks = dofile(directory .. 'boss1_attack.lua')(program, bullets, turn)
    local bind = {attach=attach, stop=stop, contains=contains, phase=request}
    local tasks = dofile(directory .. 'boss1_tasks.lua')(program, bind, position, effects)

    local function consume(part, protected)
        if band(part.flags, 0x5c00) == 0 then part.flash = false; return end
        part.credit = band(part.flags, 0x5c00)
        part.flags = band(part.flags, 0xa3ff)
        if not protected then part.health = part.health - band(0x7fff - part.hp, 0xffff) end
        part.hp, part.flash = 0x7fff, not part.flash
    end

    local function breakWing(o, index)
        local wing = o.wings[index]
        if wing.broken then return end
        wing.broken, wing.flags, wing.health = true, 0x8000, -1
        for _, id in ipairs({0,2,8,10,12}) do stop(o.components, id + index - 1) end
        attach(o.components, index + 3)
    end

    local function destroy(o)
        o.dying, o.flags, o.health = true, 0x8000, -1
        o.run.bossEnding = true
        if o.run.player then o.run.player.protect = 0xff end
        breakWing(o, 1)
        breakWing(o, 2)
        for i = 1, o.directors.limit do o.directors[i] = nil end
        for i = 1, o.attacks.limit do o.attacks[i] = nil end
        request(o, 1)
        attach(o.components, 6)
    end

    local function damageState(o)
        if o.dying then return end
        consume(o, not o.vulnerable)
        if o.health < 0 then
            if o.run.player and o.run.player.active then destroy(o); return end
            o.health = 0x200
        end
        for i, wing in ipairs(o.wings) do
            if not wing.broken then
                consume(wing, not o.vulnerable)
                -- 0x192e9c、0x192f80。另一翼已脱离时也进入本翼的拆解回调。
                if o.wings[3 - i].broken then
                    breakWing(o, i)
                elseif wing.health < 0 then
                    breakWing(o, i)
                    o.clearClock = 0x6e
                end
            end
        end
        if o.wings[1].broken and o.wings[2].broken and not contains(o.directors,5) then attach(o.directors,5) end
        if (o.wings[1].broken or o.wings[2].broken) and not contains(o.directors,4) then attach(o.directors,4) end
        if not o.run.freeze then
            o.timeout = o.timeout - 1
            if o.timeout == 0 then
                if o.run.player and o.run.player.active then destroy(o)
                else o.timeout = 0x78 end
            end
        end
    end

    function M.init(o)
        o.h, o.l = s16(0x97ff), s16(-0x200 - o.run.cameraOffset)
        local boxes = {o,unpack(o.extraParts)}
        for i, part in ipairs(boxes) do
            part.flags, part.front, part.back, part.right, part.left, part.hp = unpack(data.boxes[i])
            part.flags = 0x8000
            if i > 1 then position(part, 0, 0) end
        end
        o.health, o.timeout = data.health[1], data.health[4]
        o.wings, o.tail = {boxes[2],boxes[4]}, boxes[6]
        for i, wing in ipairs(o.wings) do
            wing.health = data.health[i + 1]
            wing.arm, wing.angle, wing.extension = 0x82, i == 1 and 0x40 or 0xc0, 0
            wing.offsetH, wing.offsetL, wing.form = 0, 0, 0
        end
        o.tail.offsetH, o.tail.offsetL, o.tail.form, o.tail.pitch = 0, 0, 0, 0
        o.plate, o.showPlate, o.guns = 0, true, {0x20,0x20,0x20,0x20}
        o.speed, o.direction = 0x10, 0
        o.history = {{0,0},{0,0},{0,0},{0,0}}
        o.directors = {limit=5,handlers=tasks.directors,label='流程'}
        o.components = {limit=10,handlers=tasks.components,label='部件'}
        o.attacks = {limit=10,handlers=attacks,label='攻击'}
        attach(o.directors, 0)
        o.run.bulletCapacity = max(o.run.bulletCapacity, 160)
        o.run.boss1 = o
        return true
    end

    function M.step(o)
        damageState(o)
        if o.clearClock and o.clearClock > 0 then
            o.clearClock = o.clearClock - 1
            bullets.clearWithFade(o.run)
        end
        if o.dying then bullets.clearWithFade(o.run) end
        if not o.run.freeze then
            tick(o, o.directors)
            if o.nextPhase then
                o.phase, o.nextPhase, o.phaseClock = o.nextPhase, nil, {}
                phases[o.phase][1](o,o.phaseClock)
            elseif o.phase then
                phases[o.phase][2](o,o.phaseClock)
            end
            tick(o, o.attacks)
            tick(o, o.components)
        end
        if o.finished then
            o.run.boss1 = nil
            o.run.stageCleared = true
            remove(o)
        else
            o.x, o.y = world(o.h, o.l)
        end
    end

    local function draw(o, imageId, h, l, dh, dl)
        local image = o.run.art[imageId]
        local h, l = program.addPacked(h, l, dh, dl)
        local x, y = world(h, l)
        Render(image[1], floor(x) + image[2] / 2, floor(y) + image[3] / 2)
    end

    function M.render(o)
        if not o.run.art then return end
        if o.showHull then
            draw(o, data.hull[o.flash and 31 or 19], o.h, o.l, -0x1a00, -0xc00)
            for i, wing in ipairs(o.wings) do
                if not wing.hidden then
                    local images = (i == 1 and data.left or data.right)[wing.flash and 31 or 21]
                    draw(o, images[wing.form + 1], wing.h, wing.l, -0x1400, -0xc00)
                end
            end
            local tail = o.tail
            if not o.hideTail then
                draw(o, data.tail[o.flash and 31 or 22][(tail.pitch + 7) * 8 + tail.form + 1],
                    tail.h, tail.l, -0xa00, -0x800)
            end
            draw(o, data.base, o.h, o.l, -0x1200, -0x400)
            local offsets = {{0x5c0,0x100},{0x5bf,-0x6c0},{0xb40,0x300},{0xb3f,-0x940}}
            if o.showGuns ~= false then
                for i, angle in ipairs(o.guns) do
                    local offset = offsets[i]
                    draw(o, data.guns[floor(angle / 2) + 1], o.h, o.l, offset[1], offset[2])
                end
            end
        end
        if o.showPlate then
            local frame = data.hatch[o.plate + 1]
            local h, l = program.addPacked(o.h, o.l, -0x800, 0x80)
            if o.plate <= 11 then h, l = program.addPacked(h, l, -0x200, 0x100) end
            draw(o, frame[1], h, l, frame[2], frame[3])
        end
        if o.wipe then
            draw(o, data.wipe[o.wipe], 0, max(0,0x1c00 - o.wipe * 0x400), 0, 0)
        end
    end

    function M.damage(part, amount, flags)
        part.hp, part.flags = s16(part.hp - amount), bor(part.flags, flags)
    end

    return M
end
