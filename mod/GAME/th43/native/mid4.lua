-- 四面道中 0x77。0xc17a8 按辅助槽、事件槽、移动槽、发射槽的顺序分派。
return function(program, bullets, effects, scroll, score)
    local band = require('bit').band
    local floor, max, min = math.floor, math.max, math.min
    local s16, world = program.s16, program.world
    local data = program.mid4
    local M = {}
    local move, events, emitters, auxiliary = {}, {}, {}, {}

    local function damage(p, amount)
        p.damagePending = p.damagePending + amount
    end

    local function draw(run, sprite, h, l)
        local image = run.art.sprites[sprite]
        Render(image[1], floor(l / 64) - 112 + image[2] / 2, floor(h / 64) - 224 + image[3] / 2)
    end

    local Part = Class(object, {
        init = function(p, o, index)
            p.host, p.hitPool, p.damagePending, p.damage = o, 2, 0, damage
            p.group, p.layer, p.bound, p.colli = GROUP.ENEMY, LAYER.ENEMY, false, index == 1
            p.lockable = index == 1
            p.front, p.back, p.right, p.left = unpack(data.boxes[index])
        end,
    })

    local Pod = Class(object, {
        init = function(p, o, side)
            p.host, p.side, p.run = o, side, o.run
            p.h, p.l = program.add(o.h, o.l, -0xd80, side * 0x180)
            p.group, p.layer, p.bound, p.colli = GROUP.ENEMY, LAYER.ENEMY, false, true
            p.hitPool, p.hp, p.damage, p.damagePending = 1, 0x80, damage, 0
            p.front, p.back, p.right, p.left = 0x380, 0x380, 0x400, 0x400
            p.speed, p.animation, p.clock, p.speedClock = 0x18, 7, 1, 1
            p.coverGone = o.coverGone
        end,
        render = function(p)
            draw(p.run, data.pods[p.animation + (p.side < 0 and 0 or 7)], p.h - 0x400, p.l - 0x300)
        end,
    })

    local function updateParts(o)
        for i, p in ipairs(o.parts) do
            p.h, p.l = s16(o.h + (i - 1) * 0x800), o.l
            p.x, p.y = world(p.h, p.l)
        end
    end

    local function register(slots, definitions, id, size)
        for index = 1, size do
            if not slots[index] then
                slots[index] = {id=id, callback=definitions[id]}
                return
            end
        end
    end

    local function dispatch(o, slots, size)
        for index = 1, size do
            local slot = slots[index]
            if slot and not slot.suspended then
                if not slot.started then
                    slot.started = true
                    slot.callback[1](o, slot)
                elseif slot.callback[2](o, slot) then
                    slots[index] = nil
                end
            end
        end
    end

    local function setMove(o, id)
        o.nextMovement = id
    end

    local function addEvent(o, id)
        register(o.events, events, id, 5)
    end

    local function addEmitter(o, id)
        register(o.emitters, emitters, id, 20)
    end

    local function addAux(o, id)
        for _, a in pairs(o.auxiliary) do if a.id == id then return end end
        register(o.auxiliary, auxiliary, id, 25)
    end

    local function has(slots, id)
        for _, slot in pairs(slots) do if slot.id == id then return true end end
        return false
    end

    local function removeSlot(slots, id)
        for index, slot in pairs(slots) do if slot.id == id then slots[index] = nil end end
    end

    local function tick(s, reset, key)
        key = key or 'clock'
        s[key] = s[key] - 1
        if s[key] < 0 then
            s[key] = reset
            return true
        end
    end

    local function fly(o)
        local dh, dl = program.vector(o.speed, o.direction * 4)
        o.h, o.l = s16(o.h + dh), s16(o.l + dl)
    end

    -- 0x103dea 到 0x103f9a 在血条亮起期间锁伤。入场移动与亮起各自计时。
    move[0] = {
        function(o, s)
            o.speed, s.phase, s.clock = 0x18, 0, 0
            fly(o)
        end,
        function(o, s)
            if s.phase == 0 and o.run.major >= 0x100 then
                o.hpReveal, s.phase = 0x20 + 0x68, 1
            end
            if o.h >= 0x3000 and s.phase < 2 then s.phase, s.clock = 2, 2 end
            if s.phase == 2 and tick(s, 2) then
                o.speed = o.speed - 1
                if o.speed == 0 then setMove(o, 2); return end
            end
            fly(o)
        end,
    }

    local function chooseDestination(o, s)
        local offset = program.random(o.run, data.destination)
        s.targetH, s.targetL = program.add(s.originH, s.originL, offset[1], offset[2])
    end

    move[2] = {
        function(o, s)
            o.speed = 10
            s.originH, s.originL = o.h, o.l
            chooseDestination(o, s)
            addEvent(o, 2)
            move[2][2](o, s)
        end,
        function(o, s)
            s.originL, s.targetL = s16(s.originL - o.run.cameraStep), s16(s.targetL - o.run.cameraStep)
            local target = program.angle(o.h, o.l, s.targetH, s.targetL, o.direction)
            o.direction = program.turnToward(program.turnToward(o.direction, target), target)
            if program.distance(o.h, o.l, s.targetH, s.targetL) <= 0x200 then chooseDestination(o, s) end
            fly(o)
            o.roll = floor(s16(s.originL - o.l) / 64)
        end,
    }

    move[3] = {
        function(o)
            o.speed, o.direction = 10, 0
            move[3][2](o)
        end,
        function(o)
            fly(o)
            if band(o.h + 0x1e00, 0xffff) >= 0xac00 then
                scroll.release(o.run, 0x114)
                o.retire = true
            end
        end,
    }

    local function randomSign(n)
        return n < 128 and n or n - 256
    end

    local function explosion(o, index, cover, speedBase)
        local r, run = (cover and data.coverBreak or data.breakup)[index], o.run
        local delay, kind, attr, dh, dl
        if cover then
            delay, kind, attr, dh, dl = unpack(r)
        else
            kind, attr, dh, dl = unpack(r)
            delay = 0
        end
        local speed = (speedBase or 12) + floor(randomSign(program.random(run, program.effectRandom)) / 2)
        local angle = cover and 0x80 or 0x60 + program.random(run, program.enemyRandom)
        effects.spawn(run, o.h, o.l, {{delay,kind,attr,dh,dl,speed,angle}}, false, true)
    end

    events[0] = {
        function(o)
            addAux(o, 0)
            addAux(o, 3)
            setMove(o, 0)
        end,
        function() return true end,
    }

    -- 0x13918c 逐个写爆炸槽。两轮结束后才逐步缩短间隔并登记卷轴解锁。
    events[1] = {
        function(o, s)
            s.index, s.laps, s.clock, s.interval, s.phase, s.acceleration = 1, 2, 2, 2, 0, 0
            o.nextMovement, o.movement = nil, nil
        end,
        function(o, s)
            if s.phase == 0 and tick(s, 2) then
                if s.index % 2 == 1 then program.random(o.run, program.randomParity) end
                explosion(o, s.index)
                s.index = s.index % 16 + 1
                if s.index == 1 then
                    s.laps = s.laps - 1
                    if s.laps == 0 then s.phase, s.decay = 1, 0x11 end
                end
            elseif s.phase == 1 then
                if tick(s, 0x11, 'decay') and s.interval > 0 then
                    s.interval, s.acceleration = s.interval - 1, s.acceleration + 1
                end
                if tick(s, s.interval) then
                    explosion(o, s.index, false, 7 + floor(s.acceleration / 2))
                    s.index = s.index % 16 + 1
                    if s.index == 1 and s.interval == 0 then
                        scroll.release(o.run, 0x114)
                        s.phase, s.clock = 2, 0x30
                    end
                end
            elseif s.phase == 2 and tick(s, 0) then
                o.auxiliary = {}
                local commands = {}
                for index, r in ipairs(data.finalBreak) do
                    commands[index] = {r[10],r[1],0,r[3],r[4],r[6],r[7]}
                end
                effects.spawn(o.run, o.h + 0xc00, o.l, commands, false, true)
                o.retireAfterDeath = true
                return true
            end
        end,
    }

    events[2] = {
        function(o)
            addEmitter(o, 1)
            addEmitter(o, 2)
        end,
        function(o)
            if not has(o.emitters, 2) then
                removeSlot(o.emitters, 1)
                addEvent(o, 3)
                return true
            end
        end,
    }

    events[3] = {
        function(o)
            addEmitter(o, 0)
        end,
        function(o)
            if not has(o.emitters, 0) then addEvent(o, 4); return true end
        end,
    }

    events[4] = {
        function(o, s) addAux(o, 1); s.phase = 0 end,
        function(o, s)
            if s.phase == 0 and not has(o.auxiliary, 1) then
                addEmitter(o, 3)
                s.phase = 1
            elseif s.phase == 1 and not has(o.emitters, 3) then
                addAux(o, 2)
                s.phase = 2
            elseif s.phase == 2 and not has(o.auxiliary, 2) then
                s.phase, s.clock = 3, 0x50
            elseif s.phase == 3 and tick(s, 0) then
                o.cycles = o.cycles + 1
                if o.cycles == 3 then
                    o.damageLocked = true
                    o.hpReveal = nil
                    setMove(o, 3)
                else
                    addEvent(o, 2)
                end
                return true
            end
        end,
    }

    auxiliary[0] = {
        function(o, s) o.jets, s.clock = {0,1,2,3,2,1}, 0 end,
        function(o, s)
            if tick(s, 0) then
                for i, value in ipairs(o.jets) do o.jets[i] = (value + (i <= 3 and 1 or -1)) % 4 end
            end
        end,
    }
    auxiliary[1] = {
        function(_, s)
            s.clock = 1
        end,
        function(o, s)
            if tick(s, 1) then
                o.coverFrame = o.coverFrame + 1
                return o.coverFrame == 15
            end
        end,
    }
    auxiliary[2] = {
        function(_, s) s.clock = 1 end,
        function(o, s)
            if tick(s, 1) then
                o.coverFrame = max(0, o.coverFrame - 1)
                return o.coverFrame == 0
            end
        end,
    }
    auxiliary[3] = {
        function(_, s) s.clock = 0 end,
        function(o, s)
            local run = o.run
            if not o.rotatingGun and tick(s, 0) and run.pilotH then
                local desired = program.angle(o.h + 0x800, o.l, run.pilotH, run.pilotL, o.gun)
                o.gun = program.turnToward(o.gun, desired)
            end
        end,
    }
    auxiliary[4] = {
        function(_, s) s.clock, s.count = 3, 15 end,
        function(o, s)
            if tick(s, 3) then
                program.random(o.run, program.randomParity)
                s.count = s.count - 1
                return s.count == 0
            end
        end,
    }

    local function muzzle(index, angle)
        return unpack(data.muzzle[index][band(angle + 2, 0xfc) / 4 + 1])
    end

    emitters[0] = {
        function(o, s)
            local c = o.turretProgress
            s.clock, s.waves, s.interval, s.breakTime = 0x30, 0x15 + c[4], 2, 8
            s.turns, s.roundSpeed, s.turn = 0x14 + c[1], c[2], 1
            s.turnClock, s.turnInterval, s.needleSpeed = 0xf + c[5], 0xf + c[5], -6 + c[3]
            if program.random(o.run, program.randomParity) < 0x80 then s.turn = -1 end
        end,
        function(o, s)
            if o.coverGone then
                o.rotatingGun = false
                return true
            end
            if not tick(s, s.interval) then return end
            local run, h, angle = o.run, o.h + 0x800, o.gun * 4
            local lh, ll = unpack(data.muzzle[1][floor(o.gun / 2) + 1])
            local rh, rl = unpack(data.muzzle[2][floor(o.gun / 2) + 1])
            if s.waves > 0 then
                bullets.emitShortPair(run, 7, s.roundSpeed, o.gun, h, o.l, lh, ll)
                bullets.emitAngle(run, 7, s.roundSpeed + (run.route.loop == 1 and 4 or 0), angle, h, o.l, rh, rl)
                s.roundSpeed, s.waves = s.roundSpeed + 2, s.waves - 1
                if s.waves == 0 then
                    o.rotatingGun, s.clock, s.interval = true, s.breakTime, 0
                end
                return
            end
            if s.turnClock % 2 == 1 then
                bullets.emitShortPair(run, 8, s.needleSpeed, o.gun, h, o.l, lh, ll)
            else
                bullets.emitAngle(run, 0x23, 6 + (run.route.loop == 1 and 4 or 0), angle, h, o.l, rh, rl)
            end
            o.gun = band(o.gun + s.turn, 0x3f)
            if not tick(s, s.turnInterval, 'turnClock') then return end
            s.needleSpeed = s.needleSpeed + 1
            s.turns = s.turns - 1
            if s.turns < 0 then
                local c = o.turretProgress
                c[1], c[2], c[3], c[4], c[5] = min(8,c[1]+4), min(3,c[2]+1), min(3,c[3]+1),
                    min(6,c[4]+3), min(4,c[5]+2)
                o.rotatingGun = false
                return true
            end
        end,
    }

    local function initSpiral(o, s)
        s.clock, s.waves, s.cycles, s.angle, s.turn = 0x10, 0x13, 1,
            program.random(o.run, program.randomParity), -1
        if program.random(o.run, program.randomParity) < 0x80 then s.turn = 1 end
    end

    emitters[1] = {
        initSpiral,
        function(o, s)
            if not tick(s, 0x24) then return end
            local angle, kind, speed = s.angle, 2, -1
            for index = 0xe, 0, -1 do
                local h, l = muzzle(3, angle)
                if kind == 2 then
                    bullets.emitAngle(o.run, kind, speed, angle, o.h, o.l, h - 0x300, l)
                    bullets.emitAngle(o.run, kind, speed, angle + 0x80, o.h, o.l, h - 0x300, l)
                    kind = 0x1d
                else
                    local motion = {0x10,1,2,0x18}
                    bullets.emitAcceleration(o.run, kind, speed, angle, s16(o.h + h - 0x300), s16(o.l + l), motion)
                    bullets.emitAcceleration(o.run, kind, speed, angle + 0x80,
                        s16(o.h + h - 0x300), s16(o.l + l), motion)
                    kind = 2
                end
                speed = index % 2 == 0 and -7 or -1
                angle = angle + 4 * s.turn
            end
            s.angle, s.waves = s.angle + s.turn, s.waves - 1
            if s.waves < 0 then
                s.clock, s.waves, s.turn, s.cycles = 0x20, 0x13, -s.turn, s.cycles - 1
                if s.cycles < 0 then initSpiral(o, s) end
            end
        end,
    }

    emitters[2] = {
        function(o, s)
            local p = o.fanProgress
            s.clock, s.waves, s.nextWaves, s.cycles, s.speed = 0x70 - p[3], 2, 2, 1 + p[2], 8 + p[1]
        end,
        function(o, s)
            if not tick(s, 3) then return end
            local run = o.run
            if run.pilotH then
                for _, side in ipairs({-1, 1}) do
                    local h, l = o.h - 0x700, o.l + side * 0x580
                    local angle = program.aimByte(h, l, run.pilotH, run.pilotL, 0x80)
                    local rays = o.coverGone and 4 or 0
                    for ray = 0, rays do
                        local a = angle + (ray - rays / 2) * 0xc
                        local dh, dl = muzzle(3, a)
                        local speed = s.speed + (o.coverGone and 1 or 0)
                        bullets.emitAngle(run, 0x16, speed, a, h, l, dh, dl)
                        if run.route.loop == 1 then
                            local spread = o.coverGone and 2 or 8
                            bullets.emitAngle(run, 0x16, speed, a - spread, h, l, dh, dl)
                            bullets.emitAngle(run, 0x16, speed, a + spread, h, l, dh, dl)
                        end
                    end
                end
            end
            s.waves = s.waves - 1
            if s.waves >= 0 then return end
            s.nextWaves = min(5, s.nextWaves + 1)
            s.clock, s.waves, s.cycles = 0x40, s.nextWaves, s.cycles - 1
            if s.cycles < 0 then
                local p = o.fanProgress
                p[1], p[2], p[3] = p[1] < 3 and p[1] + 2 or p[1], min(2,p[2]+1), 0x30
                return true
            end
        end,
    }

    emitters[3] = {
        function(o, s)
            s.clock, s.waves, s.interval = 0x30 - o.podProgress[2], 9 + o.podProgress[1], 0x12
        end,
        function(o, s)
            if not tick(s, s.interval) then return end
            local side = s.waves % 2 == 1 and -1 or 1
            for index = 1, 48 do
                if not o.pods[index] then o.pods[index] = New(Pod, o, side); break end
            end
            for i = 0, 9 do
                local angle = side * (0x18 + 6 * i)
                local h, l = muzzle(5, angle)
                local dh, dl = -4, -side * 8
                bullets.emitDrift(o.run, -i, angle, o.h, o.l, h + 0x400, l + (side < 0 and -0x700 or 0xb00),
                    {dh,1+16*i,1,dl,0x10,1})
                h, l = muzzle(4, angle + 3 * side)
                local a = angle + 3 * side
                local hOffset, lOffset = h + 0x400, l + (side < 0 and -0x900 or 0x900)
                local motion = {-12,1+8*i,1,side*2,0x10,1}
                if o.run.route.loop == 1 then
                    bullets.emitDrift(o.run, -4-i, a-8, o.h, o.l, hOffset, lOffset, motion)
                    bullets.emitDrift(o.run, -4-i, a+8, o.h, o.l, hOffset, lOffset, motion)
                else
                    bullets.emitDrift(o.run, -4-i, a, o.h, o.l, hOffset, lOffset, motion)
                end
            end
            s.waves = s.waves - 1
            if s.waves < 0 then
                o.podProgress[1], o.podProgress[2] = min(20,o.podProgress[1]+10), min(24,o.podProgress[2]+12)
                return true
            end
        end,
    }

    local function stepPods(o)
        local run = o.run
        for index = 1, 48 do
            local p = o.pods[index]
            if p then
                p.hp, p.damagePending = p.hp - p.damagePending, 0
                if p.hp < 0 or p.h < 0x600 or o.dead then
                    if p.hp < 0 and run.pilotH and not o.dead then
                        local angle = program.aimByte(p.h, p.l, run.pilotH, run.pilotL, 0x80)
                        local step = program.random(run, program.randomSign) < 0x80 and 10 or 2
                        local count = p.coverGone and 6 or 4
                        local speed = p.coverGone and -11 or -16
                        for i = 0, count do
                            local a = angle + (i - count / 2) * step
                            local h, l = muzzle(3, a)
                            bullets.emitAcceleration(run, 0x25, speed + (run.route.loop == 1 and 4 or 0), a,
                                s16(p.h + h), s16(p.l + l), {1,1,1,0x18})
                        end
                    end
                    effects.spawn(run, p.h, p.l, {{0,11,0,0,0,0,0}}, false)
                    object.RawDel(p)
                    o.pods[index] = nil
                else
                    p.l = s16(p.l - run.cameraStep)
                    if tick(p, 1) then
                        p.animation = p.animation - 1
                        if p.animation <= 4 and not p.flying then
                            p.flying, p.l = true, s16(p.l + p.side * 0x180)
                        elseif p.animation < 1 then
                            p.animation = 4
                        end
                    end
                    if p.flying then
                        if p.speed < 0x20 and tick(p, 1, 'speedClock') then p.speed = p.speed + 1 end
                        p.h = s16(p.h + program.vector(p.speed, 0x80))
                    end
                    p.x, p.y = world(p.h, p.l)
                end
            end
        end
    end

    local function applyDamage(o)
        local hull, turret = unpack(o.parts)
        local hit = hull.damagePending >= turret.damagePending and hull or turret
        local damageValue = max(hull.damagePending, turret.damagePending)
        hull.damagePending, turret.damagePending = 0, 0
        if o.damageLocked or o.hpReveal or o.dead or damageValue == 0 then return end
        o.hp = o.hp - damageValue
        if not o.coverGone and o.hp <= 0x17900 then
            score.kill(hit,0xa28,nil,nil,hull)
            o.coverGone, turret.broken, turret.colli = true, true, false
            for _, slot in pairs(o.auxiliary) do
                if slot.id == 3 then slot.suspended = true end
            end
            bullets.clear(o.run)
            addAux(o, 4)
            for index = 1, #data.coverBreak do explosion(o, index, true) end
            if o.run.onPartBreak then o.run.onPartBreak(o, turret) end
        elseif o.hp < 0 then
            score.kill(hit,0x14b4,nil,nil,hull)
            o.dead, hull.colli, turret.colli = true, false, false
            o.events, o.emitters = {}, {}
            o.damageLocked = true
            bullets.clear(o.run)
            addEvent(o, 1)
        end
    end

    local Mid = Class(object, {
        init = function(o, run)
            o.run, o.h, o.l, o.hp, o.maxhp = run, -0x1400, 0x1c00, data.hp, data.hp
            o.group, o.layer, o.bound, o.colli = GROUP.GHOST, LAYER.ENEMY, false, false
            o.parts, o.pods, o.events, o.emitters, o.auxiliary = {}, {}, {}, {}, {}
            o.turretProgress, o.fanProgress, o.podProgress = {0,0,0,0,0}, {0,0,0}, {0,0}
            o.cycles, o.coverFrame, o.gun, o.roll, o.direction = 0, 0, 0, 0, 0
            o.jets = {0,1,2,3,2,1}
            o.parts[1], o.parts[2] = New(Part, o, 1), New(Part, o, 2)
            updateParts(o)
            addEvent(o, 0)
            run.capacity = 150
        end,
        render = function(o)
            local run, h, l = o.run, o.h, o.l
            local roll = min(8, max(-8, floor(o.roll / 4)))
            for wing = 1, 2 do
                local sign = wing == 1 and 1 or -1
                local index = 9 + roll * sign
                local offsets = data.jetsOffset[index]
                for j = 1, 3 do
                    draw(run, data.jets[o.jets[(wing - 1) * 3 + j] + 1],
                        h - 0x7c0 + offsets[j*2-1], l - 0x500 + (0x1080 + offsets[j*2]) * sign)
                end
                draw(run, data.wing[wing][index], h - 0x13c0, l - 0xc00 + 0x1080 * sign)
            end
            draw(run, data.hull, h - 0xa00, l - 0x900)
            draw(run, data.turret[floor(o.gun / 2) + 1], h, l - 0x700)
            draw(run, data.cover[o.coverFrame + 1], h - 0x1640, l - 0xa00)
        end,
    })

    function M.spawn(run)
        run.mid4 = New(Mid, run)
        return run.mid4
    end

    function M.step(o)
        if o.run.freeze then return end
        if o.hpReveal then
            o.hpReveal = o.hpReveal - 1
            if o.hpReveal == 0 then o.hpReveal = nil end
        end
        o.l = s16(o.l - o.run.cameraStep)
        dispatch(o, o.auxiliary, 25)
        dispatch(o, o.events, 5)
        if o.nextMovement then
            o.movement = move[o.nextMovement]
            o.movementState, o.nextMovement = {}, nil
            o.movement[1](o, o.movementState)
        elseif o.movement then
            o.movement[2](o, o.movementState)
        end
        updateParts(o)
        dispatch(o, o.emitters, 20)
        stepPods(o)
        applyDamage(o)
        if o.retire or o.retireAfterDeath then M.close(o) end
    end

    function M.close(o)
        o.run.mid4 = nil
        for _, pod in pairs(o.pods) do object.RawDel(pod) end
        for _, part in ipairs(o.parts) do object.RawDel(part) end
        object.RawDel(o)
    end

    return M
end
