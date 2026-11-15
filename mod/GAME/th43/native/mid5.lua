-- 五面 0x63。0x13af74 挂载五组回调，0x13cc7e 分别结算本体和炮台的伤害。
return function(program, bullets, effects, scroll, score)
    local band = require('bit').band
    local floor, min, max = math.floor, math.min, math.max
    local s16, world = program.s16, program.world
    local data = program.mid5
    local M = {}
    local move, events, emitters, aux = {}, {}, {}, {}
    local partOffsets = {{0,0},{0,0},{0x3300,-0x5c0},{0x3300,0x7c0},{0x1a00,-0xb00},{0x1a00,0xb40}}

    local function damage(p, amount)
        p.damagePending = p.damagePending + amount
    end

    local Part = Class(object, {
        init = function(p, o, index)
            p.host, p.run, p.hitPool, p.hp = o, o.run, 2, data.hp[index]
            p.damage, p.damagePending, p.direction = damage, 0, 0
            p.group, p.layer, p.bound, p.colli = GROUP.ENEMY, LAYER.ENEMY, false, false
            p.lockable = index ~= 2
            if index >= 3 then p.multiplierDivisor = 30 end
            p.front, p.back, p.right, p.left = unpack(data.boxes[index])
        end,
    })

    local function updateParts(o)
        for index, p in ipairs(o.parts) do
            local dh, dl = unpack(partOffsets[index])
            if index > 2 then p.h, p.l = program.add(o.h, o.l, dh, dl)
            else p.h, p.l = o.h, o.l end
            p.x, p.y = world(p.h, p.l)
        end
    end

    local function has(slots, id)
        for _, slot in pairs(slots) do if slot.id == id then return true end end
        return false
    end

    local function remove(slots, id)
        for index, slot in pairs(slots) do if slot.id == id then slots[index] = nil end end
    end

    local function register(slots, id, count)
        if has(slots, id) then return end
        for index = 1, count do
            if not slots[index] then
                slots[index] = {id=id}
                return
            end
        end
    end

    local function dispatch(o, slots, definitions, count)
        for index = 1, count do
            local s = slots[index]
            if s and not s.suspended then
                local callbacks = definitions[s.id]
                if not s.started then
                    s.started = true
                    callbacks[1](o, s)
                elseif callbacks[2](o, s) then
                    slots[index] = nil
                end
            end
        end
    end

    local function event(o, id) register(o.events, id, 5) end
    local function emitter(o, id) register(o.emitters, id, 20) end
    local function auxiliary(o, id) register(o.auxiliary, id, 25) end

    local function tick(s, reset, field)
        field = field or 'clock'
        s[field] = s[field] - 1
        if s[field] < 0 then
            s[field] = reset
            return true
        end
    end

    local function signedRandom(run, values)
        local n = program.random(run, values)
        return n < 128 and n or n - 256
    end

    local function fly(o)
        o.h = s16(o.h + program.vector(o.speed, 0))
    end

    move[0] = {
        function(o, s)
            o.speed, o.h, o.l = 1, 0x5c00, 0x1c00 - o.run.cameraOffset
            s.delay, s.clock, s.interval, s.cruise = 0x180, 6, 6, 0x20
        end,
        function(o, s)
            if s.delay > 0 then
                s.delay = s.delay - 1
                if s.delay == 0 then auxiliary(o, 0) end
                return
            end
            if not s.ready and tick(s, s.interval) then
                s.interval = max(3, s.interval - 1)
                s.clock = s.interval
                if o.speed < 8 then
                    o.speed = o.speed + 1
                else
                    s.cruise = s.cruise - 1
                    if s.cruise == 0 then
                        s.ready, o.damageLocked = true, false
                        for index, p in ipairs(o.parts) do p.colli = index ~= 2 end
                        auxiliary(o, 8)
                        event(o, 3)
                    end
                end
            end
            fly(o)
        end,
    }

    move[1] = {function(o) o.speed = 3 end, fly}

    -- 各移动槽共用速度调整，保留原来各槽的高低阈值和加速上限。
    for index, cfg in ipairs({
        {0x3800,0x3c00,6}, {0x4000,0x4200,8}, {0x3600,0x3800,6,2},
        {0x2e00,0x3000,6}, {0x3200,0x3600,4,nil,2},
    }) do
        local low, high, limit, startSpeed, minimum = unpack(cfg, 1, 5)
        minimum = minimum or 4
        move[index + 1] = {
            function(o, s)
                s.upClock, s.downClock = 6, 0x18
                if startSpeed then o.speed = startSpeed end
            end,
            function(o, s)
                fly(o)
                local height = band(o.h, 0xffff)
                if height < low then
                    o.engineInterval = 0
                    if o.speed < limit and tick(s, 6, 'upClock') then
                        o.speed = band(o.speed + signedRandom(o.run, program.randomSign), 0xff)
                    end
                elseif height >= high then
                    o.engineInterval = 1
                    if o.speed > minimum and tick(s, 0x18, 'downClock') then
                        o.speed = max(minimum, o.speed - signedRandom(o.run, program.randomSign))
                    end
                end
            end,
        }
    end

    move[7] = {
        function(o) o.speed = 10 end,
        fly,
    }

    events[0] = {function(o) o.nextMove = 0 end, function() return true end}

    local function explosion(o, s, base)
        local kind, attr, dh, dl = unpack(data.breakup[s.index])
        local run = o.run
        local speed = base + floor(signedRandom(run, program.effectRandom) / 2)
        local angle = 0x60 + program.random(run, program.enemyRandom)
        effects.spawn(run, o.h, o.l, {{0,kind,attr,dh,dl,speed,angle}}, false, true)
        s.index = s.index % 16 + 1
        return s.index == 1
    end

    -- 击破事件结束后才登记卷轴解锁，解锁事件还负责后续的两架杂兵。
    events[1] = {
        function(o, s)
            s.phase, s.index, s.laps, s.clock, s.interval = 0, 1, 2, 2, 2
            o.nextMove = 1
        end,
        function(o, s)
            if s.phase == 0 and tick(s, 2) then
                if s.index % 2 == 1 then program.random(o.run, program.randomParity) end
                if explosion(o, s, 12) then
                    s.laps = s.laps - 1
                    if s.laps == 0 then s.phase, s.decay = 1, 0x11 end
                end
            elseif s.phase == 1 then
                if tick(s, 0x11, 'decay') then s.interval = max(0, s.interval - 1) end
                if tick(s, s.interval) and explosion(o, s, 11 + floor((2 - s.interval) / 2))
                    and s.interval == 0 then
                    s.phase, s.clock = 2, 0x30
                end
            elseif s.phase == 2 and tick(s, 0) then
                for _, slot in pairs(o.auxiliary) do slot.suspended = true end
                s.phase, s.clock = 3, 7
            elseif s.phase == 3 and tick(s, 0) then
                local commands = {}
                for index, r in ipairs(data.finalBreak) do
                    commands[index] = {r[10],r[1],0,r[3],r[4],r[6],r[7]}
                end
                effects.spawn(o.run, o.h + 0x1800, o.l, commands, false, true)
                o.hidden = true
                s.phase, s.clock = 4, 0x3f
            elseif s.phase == 4 and tick(s, 0) then
                event(o, 11)
                return true
            end
        end,
    }

    events[2] = {
        function(_, s) s.clock = 0x3f end,
        function(o, s)
            if tick(s, 0) then
                o.damageLocked = false
                event(o, 7)
                return true
            end
        end,
    }

    events[3] = {
        function(o)
            if o.parts[5].broken and o.parts[6].broken then return end
            o.run.capacity, o.nextMove = 150, 2
            auxiliary(o, 1)
            auxiliary(o, 2)
            emitter(o, 0)
        end,
        function(o)
            if not has(o.emitters, 0) then event(o, 4); return true end
        end,
    }

    events[4] = {
        function(o, s)
            o.run.capacity, o.nextMove, s.clock = 190, 3, 0x60
        end,
        function(o, s)
            if s.clock > 0 then
                s.clock = s.clock - 1
                if s.clock == 0 then auxiliary(o, 3) end
            end
            if s.clock == 0 and not has(o.auxiliary, 3) then
                emitter(o, 1)
                event(o, 5)
                return true
            end
        end,
    }

    events[5] = {
        function(_, s) s.clock = 0x40 end,
        function(o, s)
            if has(o.emitters, 1) then return end
            if s.clock > 0 then
                s.clock = s.clock - 1
                if s.clock == 0 then auxiliary(o, 4) end
            end
            if s.clock == 0 and not has(o.auxiliary, 4) then event(o, 6); return true end
        end,
    }

    events[6] = {
        function(o, s)
            s.clock = 0x20
            if o.parts[3].broken and o.parts[4].broken then return end
            o.run.capacity = 150
            emitter(o, 2)
        end,
        function(o, s)
            if has(o.emitters, 2) then return end
            if o.phase == 1 then event(o, 7); return true end
            if tick(s, 0) then event(o, 3); return true end
        end,
    }

    events[7] = {
        function(o, s)
            o.run.capacity, o.nextMove, s.clock = 190, 5, 0x40
        end,
        function(o, s)
            if s.clock > 0 then
                s.clock = s.clock - 1
                if s.clock == 0 then auxiliary(o, 5) end
            end
            if s.clock == 0 and not has(o.auxiliary, 5) then
                emitter(o, 3)
                event(o, 8)
                return true
            end
        end,
    }

    events[8] = {
        function() end,
        function(o)
            if not has(o.emitters, 3) and not has(o.auxiliary, 6) then
                event(o, 6)
                return true
            end
        end,
    }

    events[9] = {
        function(o) auxiliary(o, 5); o.nextMove = 6 end,
        function(o)
            if not has(o.auxiliary, 5) then emitter(o, 4); event(o, 10); return true end
        end,
    }

    events[10] = {
        function(o, s) auxiliary(o, 6); s.clock = 0xc0 end,
        function(o, s)
            if not has(o.emitters, 4) and not has(o.auxiliary, 6) and tick(s, 0) then
                event(o, 9)
                return true
            end
        end,
    }

    events[11] = {
        function(o, s) scroll.release(o.run, 0x1bc); s.clock = 0 end,
        function(o, s)
            local run = o.run
            -- 0x13bf06 首次立即登记，随后从事件参数的 +3 取重载值 04。
            if tick(s, 4) then
                local def = program.spawnTypes[0x1a]
                for _ = 1, 2 do
                    local l = 0x2400 + program.random(run, program.spawnJitter) * 2
                    local pending = run.pendingSpawns
                    if #pending < 40 then
                        pending[#pending + 1] = {run.major,run.minor,0x1a,0x40,0,0,0,0,def[1],def[2],
                            h=0x7400,l=l,path=data.exitPath}
                    end
                end
            end
            local wreckCleared = o.dead and run.major == (run.route.loop == 0 and 0x1c4 or 0x1be)
            if wreckCleared or (o.retreating and band(o.h, 0xffff) >= 0x7c00) then
                o.retire = true
                return true
            end
        end,
    }

    aux[0] = {
        function(_, s) s.clock = 1 end,
        function(o, s) if tick(s, o.engineInterval) then o.engine = (o.engine + 1) % 8 end end,
    }
    for id, field in ipairs({'gunLeft','gunRight'}) do
        aux[id] = {
            function(_, s) s.clock = 0 end,
            function(o, s) if tick(s, 2) then o[field] = (o[field] + 1) % 8 end end,
        }
    end
    for id = 3, 4 do
        local change, target = id == 3 and 1 or -1, id == 3 and 7 or 0
        aux[id] = {
            function(_, s) s.clock = 3 end,
            function(o, s)
                if tick(s, 3) then
                    o.coverFrame = max(0, min(7, o.coverFrame + change))
                    return o.coverFrame == target
                end
            end,
        }
    end
    aux[5] = {
        function(o) o.parts[2].colli = true end,
        function(o)
            if o.extensionWidth < 0x480 then
                o.extensionWidth = o.extensionWidth + 0x40
                local p = o.parts[2]
                p.left, p.right = p.left + 0x80, p.right + 0x80
            else
                o.extensionHeight = o.extensionHeight + 0x40
                return o.extensionHeight == 0x280
            end
        end,
    }
    aux[6] = {
        function() end,
        function(o)
            if o.extensionHeight > 0 then o.extensionHeight = o.extensionHeight - 0x40; return end
            local p = o.parts[2]
            o.extensionWidth = max(0, o.extensionWidth - 0x40)
            p.left, p.right = max(0, p.left - 0x80), max(0, p.right - 0x80)
            if o.extensionWidth == 0 then p.colli = false; return true end
        end,
    }
    aux[7] = {
        function(_, s) s.clock = 0 end,
        function(o, s) if tick(s, 2) then o.extensionFrame = (o.extensionFrame + 1) % 4 end end,
    }
    aux[8] = {
        function() end,
        function(o)
            if not o.run.pilotH then return end
            for i = 3, 4 do
                local p = o.parts[i]
                local angle = program.angle(p.h, p.l, o.run.pilotH, o.run.pilotL, p.direction)
                p.direction = program.turnToward(p.direction, angle)
            end
        end,
    }

    local function aim(run, h, l, current)
        if run.pilotH then return program.aimByte(h, l, run.pilotH, run.pilotL, current) end
        return current
    end

    local function muzzle(positions, angle, dh, dl)
        local r = positions[band(angle + 2, 0xfc) / 4 + 1]
        return program.add(r[1], r[2], dh, dl)
    end

    local function nextWave(s, rest, increase, limit)
        s.remaining = s.remaining - 1
        if s.remaining >= 0 then return end
        s.clock, s.length, s.rounds = rest, min(limit, s.length + increase), s.rounds - 1
        s.remaining = s.length
        return s.rounds < 0
    end

    emitters[0] = {
        function(o, s)
            local progress = o.progress[1]
            s.clock, s.length, s.rounds = 0x60, 4 + progress.length, 4 + progress.rounds
            s.remaining = s.length
            s.side = signedRandom(o.run, program.randomParity) < 0 and 1 or 0
        end,
        function(o, s)
            local left, right, run = o.parts[5], o.parts[6], o.run
            if left.broken and right.broken then remove(o.auxiliary, 1); remove(o.auxiliary, 2); return true end
            if not tick(s, 1) then return end
            if s.remaining == s.length then
                if not run.pilotH then return end
                local side = signedRandom(run, program.randomParity) < 0 and 1 or 0
                s.side = side == s.side and 1 - side or side
                s.leftAim, s.rightAim = aim(run, left.h + 0x180, left.l - 0x180, 0),
                    aim(run, right.h + 0x180, right.l + 0x180, 0)
                s.leftBrake, s.rightBrake = s.leftAim, s.rightAim
            end
            local primary, secondary, primaryAngle, secondaryAngle, primarySide
            if s.side == 0 then
                primary, secondary = left, right
                primaryAngle, secondaryAngle, primarySide = s.leftAim, s.leftBrake, -1
                s.leftAim, s.leftBrake = s.leftAim + 2, s.leftBrake - 2
            else
                primary, secondary = right, left
                primaryAngle, secondaryAngle, primarySide = s.rightAim, s.rightBrake, 1
                s.rightAim, s.rightBrake = s.rightAim - 2, s.rightBrake + 2
            end
            if primary.broken then primary = secondary end
            if secondary.broken then secondary = primary end
            for offset = -0x18, 0x18, 0x18 do
                local angle = primaryAngle + offset
                local dh, dl = muzzle(program.boss1FanMuzzle, angle, 0x180, primarySide * 0x180)
                bullets.emitLongPair(run, 7, 5, angle, primary.h, primary.l, dh, dl)
            end
            for offset = -0x18, 0x18, 0x18 do
                local angle = secondaryAngle + offset
                local dh, dl = muzzle(program.boss1FanMuzzle, angle, 0x180, -primarySide * 0x180)
                local emit = s.side == 0 and bullets.emitMotion or bullets.emitLongPair
                emit(run, 0x34, 0x1a, angle, secondary.h, secondary.l, dh, dl, {0x18})
            end
            if nextWave(s, 0x30, 2, 12) then
                local progress = o.progress[1]
                progress.rounds, progress.length = min(2, progress.rounds + 1), min(6, progress.length + 2)
                remove(o.auxiliary, 1)
                remove(o.auxiliary, 2)
                return true
            end
        end,
    }

    emitters[1] = {
        function(o, s)
            local run, progress = o.run, o.progress[2]
            s.angle = program.random(run, program.randomParity)
            s.turn = signedRandom(run, program.randomParity) < 0 and 6 or -6
            s.clock, s.length, s.rounds = 0x40 - progress.delay, 0x0e, 2 + progress.rounds
            s.remaining, s.limit = s.length, 0x1a + progress.limit
        end,
        function(o, s)
            if not o.coverGone then
                if not tick(s, 2) then return end
                if s.remaining == s.length then
                    if o.run.pilotH then
                        s.angle = aim(o.run, o.h + 0x700, o.l, s.angle) + 0x80
                            + signedRandom(o.run, program.effectRandom) * 2
                    end
                end
                if s.remaining ~= s.length or o.run.pilotH then
                    for i = -1, 3 do
                        local angle = s.angle + i * 0x18
                        local dh, dl = muzzle(data.coverMuzzle, angle, 0x700, 0)
                        bullets.emitMotion(o.run, 0x35, 0x0e, angle, o.h, o.l, dh, dl, {s.limit})
                    end
                    s.angle = s.angle + s.turn
                end
                if s.remaining == 0 then s.turn = -s.turn end
                if not nextWave(s, 0x40, 5, 0x1d) then return end
                local progress = o.progress[2]
                progress.rounds = min(2, progress.rounds + 1)
                progress.delay, progress.limit = min(0x10, progress.delay + 8), min(4, progress.limit + 2)
            end
            o.nextMove = 4
            return true
        end,
    }

    emitters[2] = {
        function(o, s)
            local progress = o.progress[3]
            s.clock, s.length, s.rounds = 0x50, 9 + progress.length, 1 + progress.rounds
            s.remaining, s.modifier = s.length, 4 + progress.modifier
        end,
        function(o, s)
            local left, right = o.parts[3], o.parts[4]
            if left.broken and right.broken then return true end
            if not tick(s, 3) then return end
            for i = 1, 2 do
                local p = i == 1 and left or right
                if p.broken then p = i == 1 and right or left end
                local r = data.turretMuzzle[floor(p.direction / 2) + 1]
                local angle = p.direction * 4 + program.random(o.run, program.enemyRandom) - 0x20
                for offset = -0x0c, 0x0c, 0x0c do
                    bullets.emitSpread(o.run, 0x36, s.modifier, angle + offset, p.h, p.l, r[1], r[2], {0x28,10})
                end
            end
            if nextWave(s, 0x40, 4, 0x11) then
                local progress = o.progress[3]
                progress.rounds = min(2, progress.rounds + 1)
                progress.length, progress.modifier = min(8, progress.length + 4), min(2, progress.modifier + 1)
                return true
            end
        end,
    }

    emitters[3] = {
        function(o, s)
            local progress = o.progress[4]
            s.clock, s.length, s.rounds = 0x20, 5 + progress.length, 7 + progress.rounds
            s.remaining = s.length
        end,
        function(o, s)
            if not tick(s, 3) then return end
            local run = o.run
            if s.remaining == s.length then
                s.angle = program.random(run, program.randomParity)
                s.turn = signedRandom(run, program.randomParity) < 0 and -2 or 2
            end
            local alternate = s.remaining % 2 == 1
            for i = 0, run.route.loop == 0 and 7 or 6 do
                local angle = s.angle + i * 0x20
                local dh, dl = muzzle(data.ringMuzzle, angle, 0x1a00, 0)
                if alternate then
                    bullets.emitMotion(run, 0x1d, 4, angle, o.h, o.l, dh, dl, {0x20,1,-1,0x10})
                else
                    bullets.emitAngle(run, 2, 4, angle, o.h, o.l, dh, dl)
                end
            end
            for i = 0, 3 do
                local angle = s.angle + 1 + i * 0x40
                local dh, dl = muzzle(data.ringMuzzle, angle, 0x1a00, 0)
                local emit = i % 2 == 0 and bullets.emitMotion or bullets.emitLongPair
                emit(run, 0x38, 0x0e, angle, o.h, o.l, dh, dl, {alternate and 0x14 or 0x18})
            end
            s.angle = s.angle + s.turn
            if nextWave(s, 0x40, 2, 0x10) then
                local progress = o.progress[4]
                progress.rounds, progress.length = min(4, progress.rounds + 1), min(0x10, progress.length + 2)
                auxiliary(o, 6)
                return true
            end
        end,
    }

    emitters[4] = {
        function(_, s) s.delay, s.clock, s.remaining = 0x40, 8, 8 end,
        function(o, s)
            if s.delay >= 0 then
                s.delay = s.delay - 1
                if s.delay >= 0 then return end
            end
            if not tick(s, 0) then return end
            for i, r in ipairs(data.extensionMuzzle) do
                bullets.emitLongPair(o.run, i <= 6 and 0x0c or 3, i <= 6 and 4 or 8, 0x80,
                    o.h + 0x1e00 - o.extensionHeight, o.l, r[1], r[2])
            end
            s.remaining = s.remaining - 1
            return s.remaining == 0
        end,
    }

    local function breakPart(o, index)
        local p = o.parts[index]
        if p.broken then return end
        p.hp, p.broken, p.colli = -1, true, false
        effects.spawn(o.run, p.h, p.l, data.partBreak[index - 2], false)
        bullets.clearFor(o.run, 0x40)
        if o.run.onPartBreak then o.run.onPartBreak(o, p) end
    end

    local function applyDamage(o)
        local core, extension = o.parts[1], o.parts[2]
        if not o.damageLocked then
            local hit = core.damagePending >= extension.damagePending and core or extension
            o.hp = o.hp - max(core.damagePending, extension.damagePending)
            core.hp = o.hp
            if o.hp < 0 then
                score.kill(hit,0xc80,nil,nil,core)
                o.dead, o.damageLocked, core.colli, extension.colli = true, true, false, false
                o.events, o.emitters = {}, {}
                remove(o.auxiliary, 5)
                remove(o.auxiliary, 6)
                breakPart(o, 3)
                breakPart(o, 4)
                bullets.clearFor(o.run, 0x400)
                event(o, 1)
            else
                for _, i in ipairs({5,6,3,4}) do
                    local p = o.parts[i]
                    if not p.broken then
                        p.hp = p.hp - p.damagePending
                        if p.hp < 0 then
                            score.kill(p,i <= 4 and 0xa8c or 0x708)
                            breakPart(o, i)
                        end
                    end
                end
                if o.phase == 0 and o.hp <= 0x15200 and not (o.parts[5].broken and o.parts[6].broken) then
                    score.kill(hit,0x1838,nil,nil,core)
                end
            end
        end
        for _, p in ipairs(o.parts) do p.damagePending = 0 end
    end

    local function updatePhase(o)
        if o.dead or o.retreating then return end
        if o.phase == 0 then
            o.phaseClock = o.phaseClock - 1
            if o.phaseClock ~= 0 and (o.damageLocked or
                (o.hp > 0x15200 and not (o.parts[5].broken and o.parts[6].broken))) then return end
            o.phase, o.damageLocked, o.coverGone = 1, true, true
            o.events, o.emitters = {}, {}
            auxiliary(o, 7)
            effects.spawn(o.run, o.h, o.l, data.coverBreak, false)
            bullets.clearFor(o.run, 1)
            breakPart(o, 5)
            breakPart(o, 6)
            event(o, 2)
        else
            o.retreatClock = o.retreatClock - 1
            if o.retreatClock ~= 0 then return end
            o.retreating, o.damageLocked, o.nextMove = true, true, 7
            o.events, o.emitters = {}, {}
            event(o, 11)
        end
    end

    local function draw(o, id, dh, dl, part, flipped)
        local image = o.run.art.sprites[id]
        part = part or o
        Render(image[1], floor((part.l + dl) / 64) - 112 + image[2] / 2,
            floor((part.h + dh) / 64) - 224 + image[3] / 2, 0, flipped and -1 or 1, 1)
    end

    local Mid = Class(object, {
        init = function(o, run)
            o.run, o.h, o.l, o.hp, o.maxhp = run, 0x3800, 0x1c00, data.hp[1], data.hp[1]
            o.group, o.layer, o.bound, o.colli = GROUP.GHOST, LAYER.ENEMY, false, false
            o.parts, o.events, o.emitters, o.auxiliary = {}, {}, {}, {}
            o.progress = {{length=0,rounds=0}, {delay=0,limit=0,rounds=0},
                {length=0,modifier=0,rounds=0}, {length=0,rounds=0}}
            o.phase, o.phaseClock, o.retreatClock, o.damageLocked = 0, 0xe10, 0xe10, true
            o.engine, o.engineInterval, o.gunLeft, o.gunRight, o.coverFrame = 0, 1, 0, 0, 0
            o.extensionFrame, o.extensionWidth, o.extensionHeight = 0, 0, 0
            for i = 1, #data.boxes do o.parts[i] = New(Part, o, i) end
            updateParts(o)
            event(o, 0)
        end,
        render = function(o)
            if o.hidden or o.run.major < 0x1a1 then return end
            local hull = data.hull
            if o.dead then draw(o, hull[1], 0xe00, -0xa00) end
            draw(o, hull[2], -0xe00, -0xa00)
            draw(o, hull[3], 0x1000, -0x1400)
            draw(o, hull[4], 0x1000, 0x0a00)
            draw(o, data.engineLeft[o.engine + 1], -0x1000, -0x1600)
            draw(o, data.engineRight[o.engine + 1], -0x1000, 0x800)
            draw(o, hull[5], 0xe00, -0xa00)
            draw(o, data.extension[o.extensionFrame + 1], 0x1600 - o.extensionHeight, -0x500)
            draw(o, hull[6], 0x1600, -0x800 - o.extensionWidth)
            draw(o, hull[7], 0x1600, o.extensionWidth)
            draw(o, hull[8], 0x2200, -0xa00)
            if not o.coverGone then draw(o, data.cover[o.coverFrame + 1], -0x800, -0x800) end
            if not o.parts[5].broken then draw(o, data.gunLeft[o.gunLeft + 1], -0x600, -0x500, o.parts[5]) end
            if not o.parts[6].broken then draw(o, data.gunRight[o.gunRight + 1], -0x600, -0x500, o.parts[6]) end
            for i = 3, 4 do
                local p = o.parts[i]
                local direction = floor(p.direction / 2) + 1
                if not p.broken then
                    draw(o, data.turret[direction], -0x400, data.turretOffset[direction] - 0x400,
                        p, data.turretFlip[direction] ~= 0)
                end
            end
        end,
    })

    function M.spawn(run)
        run.mid5 = New(Mid, run)
        return run.mid5
    end

    function M.step(o)
        if o.run.freeze then return end
        dispatch(o, o.auxiliary, aux, 25)
        dispatch(o, o.events, events, 5)
        if o.nextMove then
            o.movement, o.movementState, o.nextMove = move[o.nextMove], {}, nil
            o.movement[1](o, o.movementState)
        elseif o.movement then
            o.movement[2](o, o.movementState)
        end
        if o.movement then
            o.h, o.l = s16(o.h - o.run.scrollStep * 64), s16(o.l - o.run.cameraStep)
        end
        updateParts(o)
        dispatch(o, o.emitters, emitters, 20)
        applyDamage(o)
        updatePhase(o)
        if o.retire then M.close(o) end
    end

    function M.close(o)
        o.run.mid5 = nil
        for _, p in ipairs(o.parts) do object.RawDel(p) end
        object.RawDel(o)
    end

    return M
end
