-- 五面关底 0x64。0x1254fe 绑定事件、移动、辅助、发射以及碰撞入口。
return function(program, bullets, effects, score, scroll)
    local bit = require('bit')
    local band, bor = bit.band, bit.bor
    local abs, floor, max, min = math.abs, math.floor, math.max, math.min
    local data = program.boss5
    local s16, add = program.s16, program.add
    local M = {}
    local resume, yield = coroutine.resume, coroutine.yield
    local events, auxiliary, emitters
    local arms = dofile('mod/GAME/th43/native/boss5_arms.lua')(program,bullets,effects)
    local drones = dofile('mod/GAME/th43/native/boss5_drones.lua')(program,bullets,effects)
    local boxes = {
        [0]={1,7,8,9,10,11,12}, {2,9,10,11,12}, {3}, {4}, {5}, {6},
    }
    local bodyBoxes = {true,true,true,true,true,true,true,true}
    local threshold = {[0]=0x3e900,0x14500,0,0x4ed00,0x2be00,0}
    local uraThreshold = {[0]=0x2a400,0}
    local phasePoints = {[0]=0x2d0,0x33e,0x384,[5]=0x1388}
    local weakFlash = {[0]=0x51e66,0xec99,0xe380,0x61279,0x381a6,0x15f00}

    local Part = Class(object, {
        init = function(p, boss, bounds, contact)
            p.host, p.run, p.hitPool = boss, boss.run, 2
            p.group, p.layer, p.bound, p.colli = GROUP.ENEMY, LAYER.ENEMY, false, false
            p.front, p.back, p.right, p.left = unpack(bounds)
            p.bodyContact, p.hp, p.damagePending = contact, 0x7fff, 0
            p.damage = function(part, value) part.damagePending = part.damagePending + value end
        end,
    })

    local function wait(frames)
        for _ = 1, frames do yield() end
    end

    local function tickSlots(slots, capacity)
        for i = 1, capacity do
            local job = slots[i]
            if job then
                local ok, message = resume(job.task)
                if not ok then error(debug.traceback(job.task, tostring(message)), 0) end
                if slots[i] == job and coroutine.status(job.task) == 'dead' then slots[i] = nil end
            end
        end
    end

    local function register(slots, handlers, capacity, o, id, argument)
        local handler = assert(handlers[id], ('五面关底尚缺回调 %02x'):format(id))
        for i = 1, capacity do
            if not slots[i] then
                slots[i] = {id=id, task=coroutine.create(function() handler(o, argument) end)}
                return
            end
        end
    end

    local function stop(slots, ...)
        for j = 1, select('#', ...) do
            local id = select(j, ...)
            for i, entry in pairs(slots) do
                if entry.id == id then slots[i] = nil end
            end
        end
    end

    local function pending(slots, id)
        for _, entry in pairs(slots) do if entry.id == id then return true end end
        return false
    end

    local function event(o, id) register(o.events, events, 5, o, id) end
    local function aux(o, id, v)
        if not pending(o.auxiliary,id) then register(o.auxiliary,auxiliary,25,o,id,v) end
    end
    local function emit(o, id, v) register(o.emitters, emitters, 20, o, id, v) end

    local function move(o, id, speed, h, l)
        if o.move and o.move.id == id then return end
        o.nextMove = {id=id, speed=speed, h=h, l=l, fresh=true, age=0}
    end

    local function fly(o, m)
        local dh, dl = program.vector(m.speed, o.heading * 4)
        o.h, o.l = s16(o.h + dh), s16(o.l + dl)
    end

    local function target(o, h, l, direct)
        local angle = program.angle(o.h, o.l, h, l, o.heading)
        o.heading = direct and angle or program.turnToward(o.heading, angle)
        return program.distance(o.h, o.l, h, l)
    end

    local function randomTarget(o, m)
        local run, id = o.run, m.id
        if id == 2 then
            m.targetH, m.targetL = add(m.h, m.l, unpack(program.random(run, program.boss3.target)))
        else
            local dh = program.random(run, program.boss3.target)[1]
            local l = id == 4 and run.pilotL and run.pilotL + run.cameraOffset or m.l
            local offsets = id == 4 and not run.pilotL and program.boss3.target or program.patrol43.debris
            m.targetH, m.targetL = s16(m.h + dh), s16(l + program.random(run, offsets)[2])
        end
        m.age = 0
    end

    local movement = {}
    movement[0] = function(o, m)
        if m.age <= 0x180 then
            o.h = s16(o.h - o.run.scrollStep * 64)
            if m.age < 0x180 then return end
            aux(o, 6)
            aux(o, 7)
        end
        fly(o, m)
        if (m.age - 0x180) % 17 == 16 then m.speed = min(8, m.speed + 1) end
        if o.h >= 0x5c00 and not m.ready then m.ready = true; event(o, 5) end
    end

    movement[1] = fly

    local function wander(o, m)
        if m.fresh then
            if m.id == 2 or m.id == 4 then m.h, m.l = o.h, o.l end
            randomTarget(o, m)
            return
        end
        local l = m.targetL - ((m.id == 2 or m.id == 4) and o.run.cameraOffset or 0)
        local distance = target(o, m.targetH, l)
        if distance <= 0x100 or (m.id ~= 2 and m.age == 0x30) then randomTarget(o, m) end
        if m.id == 6 then o.l = s16(o.l + o.run.cameraStep) end
        fly(o, m)
    end
    movement[2], movement[4], movement[5], movement[6] = wander, wander, wander, wander

    movement[3] = function(o, m)
        if m.fresh then
            local timing = data.approach[band(m.speed, 15) + 1]
            m.clock, m.reload = floor(timing[1] / 256), band(timing[1], 0xff)
            m.delta, m.speed = timing[2], 2
            m.half = floor(target(o, m.h, m.l, true) / 2)
            return
        end
        local distance = target(o, m.h, m.l)
        m.clock = m.clock - 1
        if m.clock < 0 then
            m.clock = m.reload
            m.speed = band(m.speed + (distance < m.half and -m.delta or m.delta), 0xff)
        end
        if distance <= 0x200 or m.speed == 0 then move(o, 2, 3) end
        fly(o, m)
    end

    movement[7] = function(o, m)
        local a = data.orbitTargets[m.point]
        if m.fresh then target(o, a[1], a[2], true); return end
        target(o, a[1], a[2])
        fly(o, m)
        if program.distance(o.h, o.l, a[1], a[2]) <= 0x100 then
            m.point = m.point % #data.orbitTargets + 1
            m.speed = 5 - band(program.random(o.run, program.randomSign), 1)
        end
    end

    movement[8] = function(o, m)
        if m.fresh then o.heading, m.speed = 0x20, 3; return end
        if m.age >= 0x40 and m.age % 9 == 1 then m.speed = m.speed + 1 end
        fly(o, m)
    end

    movement[9] = function(o, m)
        if m.fresh then
            o.phase, o.heading, m.speed = 3, 0, 8
            aux(o, 0x17)
            scroll.beginDoom(o.run)
            return
        end
        if o.h < 0x5000 then
            m.speed = min(0x18, m.speed + 1)
        else
            m.speed = max(0, m.speed - 1)
            if m.speed == 0 and not m.ready then m.ready = true; event(o, 0xe) end
        end
        fly(o, m)
    end

    local function active(o, phase)
        for _, part in ipairs(o.parts) do part.colli = false end
        for _, index in ipairs(boxes[phase]) do o.parts[index].colli = true end
    end

    function M.breakPart(o, index, effect)
        local p = o.parts[index]
        if p.broken then return end
        p.colli, p.broken = false, true
        effects.spawn(o.run, p.h, p.l, data.explosions[effect], false, true)
    end

    local function change(o)
        local phase = o.phase
        o.events, o.emitters, o.locked = {}, {}, true
        for _, part in ipairs(o.parts) do part.colli, part.damagePending = false, 0 end
        bullets.clearFor(o.run, (phase == 2 or phase == 5) and 0x400 or 0x10)
        if phase == 0 then
            effects.spawn(o.run, o.h, o.l, data.explosions[1], false, true)
            M.breakPart(o, 7, 2)
            M.breakPart(o, 8, 3)
            stop(o.auxiliary, 6, 7)
            event(o, 1)
        elseif phase == 1 then
            for i = 9, 12 do M.breakPart(o, i, 4) end
            if o.run.route.ura then o.hp = -1 end
            event(o, 2)
        elseif phase == 2 then
            o.hp = -1
            if not o.run.route.ura then score.finishBoss(o.run) end
            event(o, 3)
        elseif phase == 3 then
            o.phase = 4
            active(o, 4)
            event(o, 0x13)
        elseif phase == 4 then
            o.phase = 5
            active(o, 5)
            stop(o.auxiliary, 0x1a,0x1b,0x1c,0x1d)
            event(o, 0x17)
        else
            o.reserve = -1
            score.finishBoss(o.run)
            event(o, 4)
        end
    end

    local function damage(o)
        local phase = o.phase
        if o.transitionPhase == phase then return end
        local amount, hit = 0, nil
        for _, i in ipairs(boxes[phase]) do
            local p = o.parts[i]
            if p.damagePending > amount then amount,hit = p.damagePending,p end
        end
        for _, p in ipairs(o.parts) do p.damagePending = 0 end
        local meter = phase < 3 and 'hp' or 'reserve'
        local cut = o.run.route.ura and uraThreshold[phase] or threshold[phase]
        o.hitFlash = amount > 0 and o.hitFlash ~= 2 and 2 or 1
        if amount == 0 then
            local flash = phase == 0 and o.run.route.ura and 0x3d966 or weakFlash[phase]
            local remaining = (phase == 3 or phase == 4) and o.hp or o[meter]
            if remaining >= 0 and remaining <= flash and band(o.run.frame, 0x0e) == 0 then o.hitFlash = 3 end
        elseif not o.locked then
            o[meter] = o[meter] - amount
            if o[meter] <= cut then
                if (phase == 2 or phase == 5) and not o.run.pilotH then
                    o[meter] = 0x200
                else
                    if phasePoints[phase] then
                        score.kill(hit,phasePoints[phase],nil,nil,o,phase==2)
                    end
                    o.transitionPhase = phase
                    change(o)
                    return
                end
            end
        end
        o.timeouts[phase+1] = o.timeouts[phase+1] - 1
        if o.timeouts[phase+1] == 0 then
            if o.run.pilotH then o.transitionPhase = phase; change(o)
            else o.timeouts[phase+1] = 0x78 end
        end
    end

    local function position(o)
        o.x, o.y = program.world(o.h, o.l)
        for i, p in ipairs(o.parts) do
            local d = o.offsets[i]
            if d then p.h, p.l = add(o.h, o.l, d[1], d[2])
            else p.h, p.l = o.h, o.l end
            p.x, p.y = program.world(p.h, p.l)
        end
    end

    local function sprite(o, id, h, l)
        local image = o.run.art.sprites[id]
        if image then
            local x, y = program.world(h, l)
            Render(image[1], floor(x) + image[2] / 2, floor(y) + image[3] / 2)
        end
    end

    local Boss = Class(object, {
        init = function(o, run)
            o.run, o.group, o.layer = run, GROUP.GHOST, LAYER.ENEMY
            o.colli, o.bound, o.locked = false, false, true
            o.h, o.l, o.heading, o.phase = s16(0x9000), 0x1c00-run.cameraOffset, 0, 0
            o.hp, o.reserve = run.route.ura and 0x61800 or data.hp[1], data.hp[2]
            o.maxReserve = o.reserve
            o.timeouts, o.parts = {unpack(data.timeouts)}, {}
            o.events, o.auxiliary, o.emitters = {}, {}, {}
            o.children = {}
            o.offsets = {[7]={0xabf,-0xac0},[8]={0xac0,0xac0}}
            for i, bounds in ipairs(data.parts) do o.parts[i] = New(Part, o, bounds, bodyBoxes[i] or false) end
            o.sideAim, o.wheel, o.wheelStep = {0,0}, 0, 1
            o.rotary, o.rotaryPosition, o.rotaryGun = {0,14,28,42}, {0,64,128,192}, {0,0,0,0}
            o.underside, o.travel, o.hitFlash, o.sweepDirection = 0, 1, 1, 1
            o.finalHull = 0
            o.burstLength, o.circleLength, o.fanLength = 0x0a, 4, 2
            o.fanAngle = 8
            o.armFanLength = 3
            run.capacity = 190
            event(o, 0)
        end,
        render = function(o)
            if o.hidden then return end
            local color = o.hitFlash
            if o.phase >= 3 then
                if o.finalWing then
                    local wing = data.lastWings[o.finalWing+1]
                    sprite(o, wing[1], add(o.h,o.l,-0x1200,0))
                    sprite(o, wing[2], add(o.h,o.l,-0x1200,-0x1200))
                end
                sprite(o, data.lastHull[color][o.finalHull+1][1], add(o.h,o.l,-0x800,-0x600))
                return
            end
            if o.landing then
                local tiles = data.landingWheels[color]
                local right = o.rotaryPosition[1] % 64
                sprite(o, tiles[right+1][1], add(o.h,o.l,-0x2e00,0))
                sprite(o, tiles[(-right)%64+1][2], add(o.h,o.l,-0x2e00,-0x1c00))
            else
                local tiles = data.wheels[color]
                sprite(o, tiles[o.wheel+1][1], add(o.h,o.l,-0x1200,0))
                sprite(o, tiles[o.wheel+1][2], add(o.h,o.l,-0x1200,-0x1000))
            end
            local front = data.center[color][o.underside+1]
            sprite(o, front[1], add(o.h,o.l,front[3],front[4]))
            sprite(o, front[2], add(o.h,o.l,front[3],front[5]))
            for i = 1, 6 do
                local part = o.parts[i+6]
                if not part.broken and (i <= 2 or o.rotaryVisible) then
                    local gun = i <= 2 and data.sideGuns[color] or data.rotaryGuns[color]
                    local a = i <= 2 and o.sideAim[i] or o.rotaryGun[i-2]
                    sprite(o, gun[floor(a/2)+1][1], add(part.h,part.l,i<=2 and -0x600 or -0x400,i<=2 and -0x400 or -0x200))
                end
            end
        end,
    })

    local api = {wait=wait, event=event, aux=aux, emit=emit, move=move, pending=pending, stop=stop,
        active=active, breakPart=M.breakPart, arms=arms, drones=drones}
    local directory = 'mod/GAME/th43/native/'
    events, auxiliary = dofile(directory .. 'boss5_events.lua')(program, bullets, effects, api)
    emitters = dofile(directory .. 'boss5_emitters.lua')(program, bullets, api)

    function M.spawn(run)
        run.boss5 = New(Boss, run)
        position(run.boss5)
        return run.boss5
    end

    function M.step(o)
        local run = o.run
        if run.freeze then return end
        o.l = s16(o.l - run.cameraStep)
        tickSlots(o.auxiliary, 25)
        tickSlots(o.events, 5)
        if o.nextMove then o.move, o.nextMove = o.nextMove, nil end
        local m = o.move
        if m then
            if m.fresh then m.point, m.speed = 1, m.speed or 0 end
            movement[m.id](o, m)
            m.fresh, m.age = false, m.age+1
        end
        position(o)
        arms.step(o)
        tickSlots(o.emitters, 20)
        drones.step(o)
        damage(o)
        if o.retire then
            run.stageCleared, run.campaignCleared = true, true
            M.close(o)
        end
    end

    function M.touch(o, h, l, front, back, right, left)
        for _, p in ipairs(o.parts) do
            if p.colli and p.bodyContact and program.overlap(p, h, l, front, back, right, left) then
                p.damage(p, 1)
                return p
            end
        end
    end

    function M.close(o)
        o.run.boss5, o.run.bossPresent, o.run.uraBoss = nil, false, false
        o.run.boss5Aim, o.run.boss5Beat = nil, nil
        arms.close(o)
        drones.close(o)
        for _, p in ipairs(o.parts) do if IsValid(p) then object.RawDel(p) end end
        if IsValid(o) then object.RawDel(o) end
    end

    return M
end
