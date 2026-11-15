-- 三面关底 0x76。0x1196b4 的各组指令独立挂在母机上，受击盒用原槽号。
return function(program, bullets, effects, score)
    local band = require('bit').band
    local floor, max, min = math.floor, math.max, math.min
    local s16, add = program.s16, program.add
    local data = program.boss3
    local M, movement, events, auxiliary, emitters = {}, {}, {}, {}, {}
    local offsets = {[0]={0,0},{0,0},{0,0},{0x7c0,0x940},{0x7bf,-0x940},
        {0x5ff,-0xf00},{0x600,0xf00},{0xc00,0x1a00},{0xbff,-0x1a00},
        {0x800,0xd00},{0x7ff,-0xd00},{0,0},{0,0},{0,0},{0,0}}
    local hull = {[0]={0,1,2},{11,12},{13,14}}
    local hullPoints = {0x122,0x140,0x2bc}
    local partPoints = {[3]=0x6e,0x6e,0xe6,0xe6,0x5a,0x5a,0x168,0x168}

    local function damage(p, amount)
        p.damagePending = p.damagePending + amount
    end

    local Part = Class(object, {
        init = function(p, boss, row)
            p.host, p.run, p.hitPool = boss, boss.run, 2
            p.hp, p.front, p.back, p.right, p.left = unpack(row)
            p.damage, p.damagePending = damage, 0
            p.group, p.layer, p.bound, p.colli = GROUP.ENEMY, LAYER.ENEMY, false, false
        end,
    })

    local function updateParts(o)
        for raw = 0, 14 do
            local p = o.parts[raw + 1]
            p.h, p.l = add(o.h, o.l, unpack(offsets[raw]))
            if raw >= 7 and raw <= 10 then p.h = s16(p.h + o.wingLift[raw % 2 + 1]) end
            p.x, p.y = program.world(p.h, p.l)
        end
        o.x, o.y = program.world(o.h, o.l)
    end

    local function enable(o, ...)
        for i = 1, select('#', ...) do o.parts[select(i, ...) + 1].colli = true end
    end

    local function register(slots, limit, id, state)
        for i = 1, limit do
            if not slots[i] then
                state = state or {}
                state.id, slots[i] = id, state
                return state
            end
        end
    end

    local function event(o, id) return register(o.events, 5, id) end
    local function aux(o, id) return register(o.auxiliary, 25, id) end
    local function emit(o, id, state) return register(o.emitters, 20, id, state) end

    local function present(slots, id)
        for _, s in pairs(slots) do if s.id == id then return true end end
        return false
    end

    local function remove(slots, id)
        for i, s in pairs(slots) do if s.id == id then slots[i] = nil end end
    end

    local function dispatch(o, slots, callbacks, limit)
        for i = 1, limit do
            local s = slots[i]
            if s then
                local callback = callbacks[s.id]
                if callback then
                    if s.started then
                        if callback[2](o, s) and slots[i] == s then slots[i] = nil end
                    else
                        s.started = true
                        if callback[1](o, s) and slots[i] == s then slots[i] = nil end
                    end
                else
                    error(('绊地狱三面关底缺少已登记的回调 %02x'):format(s.id))
                end
            end
        end
    end

    local function tick(s, reload, field)
        field = field or 'clock'
        s[field] = s[field] - 1
        if s[field] < 0 then
            s[field] = reload
            return true
        end
    end

    local function installMove(o, id, speed, h, l)
        o.nextMove = {id=id, speed=speed, h=h, l=l}
    end

    auxiliary[0] = {
        function(o) o.flameTick = (o.flameTick + 8) % 0x20 end,
        function(o) o.flameTick = (o.flameTick + 8) % 0x20 end,
    }

    auxiliary[1] = {
        function(_, s) s.clock = 0 end,
        function(o, s)
            if tick(s, 1) then o.hullHatch = o.hullHatch + 1 end
            return o.hullHatch == 15
        end,
    }

    for i, angles in ipairs({{0x30,0x10},{0x20,0x20}}) do
        local left = i == 1 and 5 or 3
        local function resetGuns(o)
            o.guns[left] = program.turnToward(o.guns[left], angles[1])
            o.guns[left+1] = program.turnToward(o.guns[left+1], angles[2])
            return o.guns[left] == angles[1] and o.guns[left+1] == angles[2]
        end
        auxiliary[i+1] = {resetGuns,resetGuns}
    end

    for side = 1, 2 do
        local wing = side
        auxiliary[side+4] = {
            function(_, s) s.rising = true end,
            function(o, s)
                local h = o.wingLift[wing]
                if s.rising then
                    h = min(0x800, h + 0x140)
                    if h == 0x800 then s.rising = false end
                end
                if not s.rising then h = max(0, h - 0x40) end
                o.wingLift[wing] = h
                return h == 0
            end,
        }
    end

    local function fly(o)
        local dh, dl = program.vector(o.speed, o.angle * 4)
        o.h, o.l = s16(o.h + dh), s16(o.l + dl)
    end

    local function activate(o, phase, ...)
        o.phase, o.damageLocked = phase, false
        enable(o, ...)
    end

    movement[0] = {
        function(o, s)
            o.speed, o.angle, s.clock = 7, 0x20, 0x100
            fly(o)
        end,
        function(o, s)
            if s.clock > 0 then
                if s.clock == 0x80 then o.run.bossPresent = true end
                s.clock = s.clock - 1
                o.shellPosition = band(o.shellPosition + 0x10, 0x7f)
                if s.clock == 0 then o.speed, o.angle = 0, 0 end
            end
            if s.clock == 0 and band(o.run.frame, 1) == 0 then
                o.speed, o.shellPosition = o.speed + 1, o.shellPosition + 0x10
                if o.shellPosition >= 0x180 then
                    activate(o, 0, 0, 2, 3, 4, 5, 6)
                    o.run.bossEngaged, o.run.uraBoss = true, true
                    event(o, 4)
                    return
                end
            end
            fly(o)
        end,
    }

    movement[1] = {function(o) o.speed, o.angle = 1, 0x20 end, fly}

    local function aimAt(o, s)
        local nextAngle = program.angle(o.h, o.l, s.targetH, s.targetL, o.angle)
        o.angle = program.turnToward(o.angle, nextAngle)
    end

    local function driftTarget(o, s)
        local offset = program.random(o.run, data.target)
        s.targetH, s.targetL = add(s.h, s.l, unpack(offset))
    end

    movement[2] = {
        function(o, s)
            o.speed = s.speed
            driftTarget(o, s)
            fly(o)
        end,
        function(o, s)
            if program.distance(o.h, o.l, s.targetH, s.targetL) <= 0x100 then driftTarget(o, s) end
            aimAt(o, s)
            fly(o)
        end,
    }

    movement[3] = {
        function(o, s)
            o.speed = 2
            s.targetH, s.targetL = s.h, s.l - o.run.cameraOffset
            s.halfDistance = floor(program.distance(o.h, o.l, s.targetH, s.targetL) / 2)
            local word = data.lift[band(s.speed, 0xf) + 1][1]
            s.clock, s.interval, s.acceleration = floor(word / 0x1000000), band(floor(word / 0x10000), 0xff), band(word, 0xff)
            o.angle = program.angle(o.h, o.l, s.targetH, s.targetL, o.angle)
            fly(o)
        end,
        function(o, s)
            local distance = program.distance(o.h, o.l, s.targetH, s.targetL)
            if distance <= 0x200 then
                installMove(o, 2, 3, o.h, o.l)
            elseif tick(s, s.interval) then
                o.speed = o.speed + (distance >= s.halfDistance and s.acceleration or -s.acceleration)
                if o.speed <= 0 then installMove(o, 2, 3, o.h, o.l) end
            end
            aimAt(o, s)
            fly(o)
        end,
    }

    for id = 4, 6 do
        local mode = id
        local function target(o, s)
            s.targetH = s16(s.h + program.random(o.run, data.target)[2])
            local center = mode == 4 and o.run.pilotL or s.l
            local offset = (mode == 4 and not o.run.pilotL) and data.target or program.patrol43.debris
            s.targetL = s16(center + program.random(o.run, offset)[2])
            s.clock = 0x2f
        end
        movement[id] = {
            function(o, s)
                if mode == 4 then s.h, s.l = o.h, o.l end
                o.speed = s.speed
                target(o, s)
                aimAt(o, s)
                fly(o)
            end,
            function(o, s)
                if mode == 6 then o.l = s16(o.l + o.run.cameraStep) end
                if tick(s, 0x30) or program.distance(o.h, o.l, s.targetH, s.targetL) <= 0x100 then target(o, s) end
                aimAt(o, s)
                fly(o)
            end,
        }
    end

    local function breakPart(o, raw)
        local p = o.parts[raw + 1]
        if p.broken then return end
        p.broken, p.colli = true, false
        local h, l = add(o.h, o.l, unpack(offsets[raw]))
        effects.spawn(o.run, h, l, data.breakup[raw - 2], false)
        if raw == 9 then breakPart(o, 7) elseif raw == 10 then breakPart(o, 8) end
    end

    local function advancePhase(o)
        o.events, o.emitters, o.damageLocked = {}, {}, true
        for _, p in ipairs(o.parts) do p.colli = false end
        if o.phase == 0 then
            for raw = 3, 6 do breakPart(o, raw) end
            effects.spawn(o.run, o.h, o.l, data.change, false)
        elseif o.phase == 1 then
            for raw = 7, 10 do breakPart(o, raw) end
        else
            o.hp, o.dead = -1, true
            score.finishBoss(o.run)
        end
        bullets.clearFor(o.run, o.dead and 0x400 or 0x20)
        event(o, o.phase + 1)
    end

    local function applyDamage(o)
        if not o.damageLocked then
            local damageMax, hit = 0, nil
            for _, raw in ipairs(hull[o.phase]) do
                local p = o.parts[raw + 1]
                if p.damagePending > damageMax then damageMax,hit = p.damagePending,p end
            end
            o.hp = o.hp - damageMax
            for raw = 3, 10 do
                local p = o.parts[raw + 1]
                if p.colli then
                    p.hp = p.hp - p.damagePending
                    if p.hp < 0 then
                        if o.run.pilotH then
                            score.kill(p,partPoints[raw])
                            breakPart(o, raw)
                        else p.hp = 0x200 end
                    end
                end
            end
            local index = o.phase + 1
            o.timeouts[index] = o.timeouts[index] - 1
            if not o.run.pilotH then
                if o.timeouts[index] == 0 then o.timeouts[index] = 0x78 end
                if o.phase == 2 and o.hp < 0 then o.hp = 0x200 end
            end
            local hpThreshold = (o.phase == 0 and o.hp <= 0x1ad00)
                or (o.phase == 1 and o.hp <= 0xf700) or (o.phase == 2 and o.hp < 0)
            if hpThreshold and hit then score.kill(hit,hullPoints[index],nil,nil,o,o.phase==2) end
            if hpThreshold or o.timeouts[index] == 0
                or (o.phase == 1 and o.parts[10].broken and o.parts[11].broken) then
                advancePhase(o)
            end
        end
        for _, p in ipairs(o.parts) do p.damagePending = 0 end
        for _, raw in ipairs(hull[o.phase]) do o.parts[raw + 1].hp = o.hp end
    end

    events[0] = {function(o) aux(o, 0); installMove(o, 0); return true end}

    events[1] = {
        function(o, s)
            s.clock = 32
            installMove(o, 5, 3, 0x4600, 0x1c00)
        end,
        function(o, s)
            if s.clock > 0 then
                s.clock = s.clock - 1
                if s.clock == 0 then aux(o, 1) end
            end
            if o.hullHatch == 15 then
                activate(o, 1, 7, 8, 9, 10, 11, 12)
                event(o, 6)
                return true
            end
        end,
    }

    events[2] = {function(o) activate(o, 2, 13, 14); event(o, 9); return true end}

    events[3] = {
        function(o, s)
            installMove(o, 1)
            effects.spawn(o.run, o.h, o.l, data.deathBurst, false)
            s.state, s.pause, s.clock, s.bursts = 0, 0x10, 0x20, 0
        end,
        function(o, s)
            if s.pause > 0 then s.pause = s.pause - 1; return end
            if s.state == 0 and tick(s, 0x10) then
                local h, l = add(o.h, o.l, unpack(data.deathPositions[s.bursts % 3 + 1]))
                effects.spawn(o.run, h, l, data.deathTrail, false)
                s.bursts = s.bursts + 1
                if s.bursts == 10 then s.state, s.pause = 1, 8 end
            elseif s.state == 1 then
                o.h, o.hidden, s.state, s.pause = s16(o.h + 0x2000), true, 2, 0x80
            elseif s.state == 2 then
                o.retire = true
                return true
            end
        end,
    }

    events[4] = {
        function(o, s)
            installMove(o, 5, 4, 0x5000, 0x1c00)
            s.clock, s.waves, s.shots, s.repeatIndex = 0x40, o.openingSpread and 2 or 3, 3, 1
            s.reload = ({0x30,0x1c,0x16,0x10})[o.run.difficulty + 1]
        end,
        function(o, s)
            if not s.guns then
                emit(o, 1)
                emit(o, 2, {shots=o.cheekShots})
                s.guns = true
            end
            if s.waiting and not present(o.emitters, s.waiting) then
                s.waves, s.waiting = s.waves - 1, nil
                s.shots, s.repeatIndex = s.shots - s.repeatIndex, s.repeatIndex + 1
                if s.waves == 0 then
                    remove(o.emitters, 1)
                    remove(o.emitters, 2)
                    aux(o, 2)
                    aux(o, 3)
                    event(o, o.opening % 2 == 0 and 5 or 10)
                    o.opening, o.cheekShots, o.centerShots = o.opening + 1, min(4, o.cheekShots + 1), min(5, o.centerShots + 1)
                    o.openingSpread = not o.openingSpread
                    return true
                end
            elseif not s.waiting and tick(s, s.reload) then
                s.waiting = o.openingSpread and 0x12 or 0
                emit(o, s.waiting, {shots=o.centerShots, bursts=max(1, s.shots)})
            end
        end,
    }

    events[5] = {
        function(_, s) s.clock, s.state = 0x3f, 0 end,
        function(o, s)
            if s.state == 0 and tick(s, 0) then
                local side = program.random(o.run, program.randomSign) == 0 and -1 or 1
                installMove(o, 6, 8, 0x5000, 0x1c00 + side * 0x1200)
                emit(o, 3, {bursts=o.edgeBursts, initialClock=o.edgeClock})
                emit(o, 7)
                s.state = 1
            elseif s.state == 1 and not present(o.emitters, 3) then
                remove(o.emitters, 7)
                o.edgeBursts, o.edgeClock = min(5, o.edgeBursts + 1), max(0x10, o.edgeClock - 4)
                event(o, 4)
                return true
            end
        end,
    }

    for _, id in ipairs({6, 8}) do
        local eventId = id
        local height, other = id == 6 and 0x4600 or 0x5c00, id == 6 and 8 or 6
        local sequence = id == 6 and {10,9,11} or {12}
        events[id] = {
            function(o, s)
                installMove(o, 3, 3, height, 0x1c00)
                s.state, s.clock, s.index = 0, 1, 1
            end,
            function(o, s)
                if s.state == 0 and o.mover.id == 2 then
                    installMove(o, 5, 3, height, 0x1c00)
                    if eventId == 6 then emit(o, 16); emit(o, 8) end
                    s.state = 1
                elseif s.state == 1 and tick(s, 1) then
                    o.weaponHatch = o.weaponHatch + 1
                    if o.weaponHatch == 15 then
                emit(o, sequence[1], eventId == 8 and {waves=o.run.difficulty == 0 and 2 or 4} or {width=o.wingShots})
                        s.state = 2
                    end
                elseif s.state == 2 and not present(o.emitters, sequence[s.index]) then
                    s.index = s.index + 1
                    if sequence[s.index] then
                        emit(o, sequence[s.index], sequence[s.index] == 9 and {waves=o.wingFans} or nil)
                        o.wingShots, o.wingFans = min(6, o.wingShots + 1), min(4, o.wingFans + 1)
                    else s.state, s.pause = 3, eventId == 6 and 0x30 or 0x80 end
                elseif s.state == 3 and tick(s, 0, 'pause') then
                    s.state = 4
                elseif s.state == 4 and tick(s, 1) then
                    o.weaponHatch = o.weaponHatch - 1
                    if o.weaponHatch == 0 then
                        remove(o.emitters, 8)
                        remove(o.emitters, 16)
                        event(o, other)
                        return true
                    end
                end
            end,
        }
    end

    local finalAngles = {0,0x20,0x40,0x60,0x80,0xe0,0xc0,0xa0,0x10,0x30,0x50,0x70,0xf0,0xd0,0xb0,0x90}
    events[9] = {
        function(o, s)
            installMove(o, 5, 8, 0x4000, 0x1c00)
            s.clock = 0x3f
        end,
        function(o, s)
            if not tick(s, 0) then return end
            emit(o, 17)
            for i, angle in ipairs(finalAngles) do
                emit(o, 13, {angle=angle, turn=i <= 8 and 1 or -1})
            end
            return true
        end,
    }

    events[10] = {
        function(o, s)
            installMove(o, 5, 4, 0x5000, 0x1c00)
            s.clock, s.state = 0x3f, 0
        end,
        function(o, s)
            if s.state == 0 and tick(s, 0) then
                emit(o, 6, {count=o.sweepCount})
                s.state = 1
            elseif s.state == 1 and not present(o.emitters, 6) then
                s.state, s.clock = 2, 0x5f
            elseif s.state == 2 and tick(s, 0) then
                o.sweepCount = min(6, o.sweepCount + 1)
                event(o, 4)
                return true
            end
        end,
    }

    local function signedRandom(run, values)
        local n = program.random(run, values)
        return n < 128 and n or n - 256
    end

    local function pickSide(run)
        return band(program.random(run, program.randomSign), 1) + 1
    end

    local function aim(o, h, l, fallback)
        local run = o.run
        if run.pilotH then return program.aimByte(h, l, run.pilotH, run.pilotL, fallback) end
        return fallback
    end

    local muzzle = {{{0x100,-0x900},{0x100,-0x740},{0x100,-0x580}},
                    {{0x100,0x900},{0x100,0x740},{0x100,0x580}}}

    for _, id in ipairs({0, 0x12}) do
        local fixedAim = id == 0x12
        emitters[id] = {
            function(o, s)
                s.clock, s.inner, s.remaining = 0, 0, 0
                s.speed = fixedAim and 16 or ({16,16,18,20})[o.run.difficulty + 1]
            end,
            function(o, s)
                local run = o.run
                if not run.pilotH then return end
                if s.remaining == 0 then
                    if not tick(s, fixedAim and 3 or 11) then return end
                    s.side, s.remaining = pickSide(run), s.shots * (fixedAim and 2 or 1)
                    local h, l = add(o.h, o.l, unpack(muzzle[s.side][2]))
                    if fixedAim then
                        s.angle = aim(o, h, l, 0x80)
                    else
                        s.angle = 0x80 + 2 * signedRandom(run, program.effectRandom)
                        s.turn = pickSide(run) == 1 and -6 or 6
                    end
                end
                if not tick(s, fixedAim and 4 or 0, 'inner') then return end
                local h, l = add(o.h, o.l, unpack(muzzle[s.side][2]))
                if fixedAim then
                    bullets.emitFasterInLoop(run, 0x15, s.speed, s.angle, h, l)
                else
                    bullets.emitLongPair(run, 0x15, s.speed, s.angle, h, l)
                    s.angle = band(s.angle + s.turn, 0xff)
                end
                s.remaining = s.remaining - 1
                if s.remaining == 0 then s.bursts = s.bursts - 1; return s.bursts == 0 end
            end,
        }
    end

    emitters[1] = {
        function(o, s)
            s.target = {program.random(o.run, program.enemyRandom), program.random(o.run, program.enemyRandom)}
            s.left, s.right, s.clock, s.aimClock = 0x38, 8, 0, 0
        end,
        function(o, s)
            if not s.ready then
                for i = 1, 2 do o.guns[4+i] = program.turnToward(o.guns[4+i], s.target[i]) end
                s.ready = o.guns[5] == s.target[1] and o.guns[6] == s.target[2]
            end
            if not s.ready or not o.run.pilotH then return end
            if tick(s, 4, 'aimClock') then
                s.left, s.right = max(0x20, s.left - 1), min(0x20, s.right + 1)
            end
            o.guns[5], o.guns[6] = band(o.guns[5]+1, 0x3f), band(o.guns[6]+1, 0x3f)
            if not tick(s, 2) then return end
            for raw = 5, 6 do
                local p = o.parts[raw + 1]
                if not p.broken then
                    local offsets = raw == 5 and data.leftMuzzle or data.rightMuzzle
                    local h, l = add(p.h, p.l, unpack(offsets[floor(o.guns[raw] / 2) + 1]))
                    bullets.emitWidePair(o.run, 3, 8, (raw == 5 and s.left or s.right) * 4, h, l)
                end
            end
        end,
    }

    emitters[2] = {
        function(o, s)
            s.side, s.clock, s.inner, s.remaining = 1, {0x10,0x10}, {0,0}, {0,0}
            s.interval = ({0x20,0x10,0xc,8})[o.run.difficulty + 1]
            s.speed = ({6,6,8,10})[o.run.difficulty + 1]
        end,
        function(o, s)
            if not o.run.pilotH then return end
            for i = 1, 2 do
                if i == s.side then
                    local raw = i + 2
                    local p = o.parts[raw + 1]
                    if p.broken then
                        s.side = 3 - i
                    else
                        if s.remaining[i] == 0 then
                            o.guns[raw] = program.turnToward(o.guns[raw],
                                program.angle(p.h, p.l, o.run.pilotH, o.run.pilotL, o.guns[raw]))
                            s.clock[i] = s.clock[i] - 1
                            if s.clock[i] < 0 then s.clock[i], s.remaining[i] = s.interval, s.shots end
                        end
                        if s.remaining[i] > 0 then
                            s.inner[i] = s.inner[i] - 1
                            if s.inner[i] < 0 then
                                s.inner[i], s.remaining[i] = 3, s.remaining[i] - 1
                                local a = band(o.guns[raw], 0x3e)
                                local h, l = add(p.h, p.l, unpack(data.muzzle[a / 2 + 1]))
                                bullets.emitDirect(o.run, 9, s.speed, a, h, l)
                                if s.remaining[i] == 0 then s.side = 3 - i end
                            end
                        end
                    end
                end
            end
        end,
    }

    emitters[3] = {
        function(_, s) s.clock, s.inner, s.remaining, s.width = s.initialClock, 0, 0, 6 end,
        function(o, s)
            local run = o.run
            if not run.pilotH then return end
            if s.remaining == 0 then
                if not tick(s, 0x10) then return end
                s.remaining, s.width, s.speed, s.angles = s.width, s.width + 3, 0, {}
                local scatter = pickSide(run) == 2
                for i = 1, 2 do
                    local h, l = add(o.h, o.l, unpack(muzzle[i][2]))
                    local a = aim(o, h, l, 0x80)
                    s.angles[i] = {a,a,a}
                    if scatter then
                        for j, da in ipairs({0,0x20,-0x20}) do
                            s.angles[i][j] = a + da + signedRandom(run, program.effectRandom)
                        end
                    end
                end
            end
            if not tick(s, 1, 'inner') then return end
            for i = 1, 2 do
                for j, k in ipairs({2,1,3}) do
                    local h, l = add(o.h, o.l, unpack(muzzle[i][k]))
                    local fire = j == 2 and bullets.emitAngle or bullets.emitSpread
                    fire(run, 0xc, s.speed, s.angles[i][j], h, l)
                end
            end
            s.remaining, s.speed = s.remaining - 1, s.speed + 3
            if s.remaining == 0 then s.bursts = s.bursts - 1; return s.bursts == 0 end
        end,
    }

    emitters[7] = {
        function(o, s)
            s.reload, s.speed = ({16,6,3,1})[o.run.difficulty + 1], ({0,0,2,4})[o.run.difficulty + 1]
            s.clock = 0
        end,
        function(o, s)
            local run = o.run
            if not run.pilotH or not tick(s, s.reload) then return end
            local h, l = add(o.h, o.l, 0x1800, 0)
            local a = aim(o, h, l, 0x80) + 4 * signedRandom(run, program.effectRandom)
            bullets.emitLongPair(run, 7, s.speed, a, h, l)
        end,
    }

    emitters[8] = {
        function(_, s) s.guns = {{clock=0x10,inner=0,shots=0},{clock=0x10,inner=0,shots=0}} end,
        function(o, s)
            if not o.run.pilotH then return end
            for i, gun in ipairs(s.guns) do
                local p = o.parts[7 + i]
                if not p.broken then
                    if gun.shots == 0 and tick(gun, 0) then
                        gun.clock = band(0x10 + signedRandom(o.run, program.effectRandom), 0xff)
                        gun.shots = 6
                    end
                    if gun.shots > 0 and tick(gun, 2, 'inner') then
                        local h, l = add(p.h, p.l, i == 1 and -0x701 or -0x700, i == 1 and -0x300 or 0x300)
                        bullets.emitFasterInLoop(o.run, 0xc, 6, 0x80, h, l)
                        gun.shots = gun.shots - 1
                    end
                end
            end
        end,
    }

    local function radial(o, angle)
        local h, l = add(o.h, o.l, 0x1800, 0)
        return add(h, l, unpack(data.radialMuzzle[floor(band(angle + 2, 0xff) / 4) + 1]))
    end

    local function sweepMuzzle(h, l, angle)
        return add(h, l, unpack(data.sweepMuzzle[floor(band(angle + 2, 0xff) / 4) + 1]))
    end

    -- 0x11db2c 每帧推进左右炮盘的相位，各自的计数器决定这一帧是否发射。
    emitters[6] = {
        function(o, s)
            local interval = o.run.route.loop == 1 and 0x40 or 0x30
            s.guns = {{a=0,clock=0,fire=0,hold=1,interval=interval,turn=8,spread=0x40},
                      {a=0,clock=0,fire=0,hold=0,interval=interval,turn=-8,spread=0xc0}}
            s.speed = o.run.route.loop == 1 and 8 or 1
        end,
        function(o, s)
            local run = o.run
            for i, gun in ipairs(s.guns) do
                if gun.fire == 0 then
                    gun.fire, gun.clock, gun.hold = gun.interval, 8, 1 - gun.hold
                end
                if run.pilotH and tick(gun, 0) then
                    if gun.hold == 0 then
                        local h, l = add(o.h, o.l, unpack(muzzle[i][1]))
                        h, l = sweepMuzzle(h, l, gun.a)
                        bullets.emitFasterInLoop(run, 0x1c, s.speed, gun.a, h, l, {gun.spread})
                        if run.route.loop == 1 then bullets.emitAngle(run, 4, -2, gun.a, h, l) end
                    end
                    gun.fire = gun.fire - 1
                    if i == 1 and gun.fire == 0 and gun.hold == 0 then
                        s.count = s.count - 1
                        if s.count == 0 then return true end
                    end
                end
                gun.a = band(gun.a + gun.turn, 0xff)
            end
        end,
    }

    local function sideMuzzle(o, side, angle)
        local h, l = add(o.h, o.l, side == 1 and 0x1dff or 0x1e00, side == 1 and -0xe40 or 0xe40)
        return add(h, l, unpack(data.wingMuzzle[floor(band(angle, 0x3e) / 2) + 1]))
    end

    -- 0x11dd3c 瞄准后在 0x11deea / 0x11e2c2 两套角表间交替。
    emitters[9] = {
        function(o, s)
            s.side, s.state, s.waves, s.gaps = pickSide(o.run), 0, s.waves or 2, 2
        end,
        function(o, s)
            if (o.parts[10].broken or o.parts[11].broken) and o.parts[s.side == 1 and 11 or 10].broken then
                s.side = 3 - s.side
            end
            if s.state == 0 then
                local h, l = add(o.h, o.l, s.side == 1 and 0x1dff or 0x1e00, s.side == 1 and -0xe40 or 0xe40)
                s.angle = floor(aim(o, h, l, 0x80) / 4)
                s.state = 1
            end
            if s.state == 1 then
                o.wingAngle[s.side] = program.turnToward(o.wingAngle[s.side], s.angle)
                if o.wingAngle[s.side] ~= s.angle then return end
                s.clock, s.state = 0x1a, 2
                s.pattern = band(program.random(o.run, program.randomSign), 1)
            end
            local interval = (o.parts[10].broken or o.parts[11].broken) and 0x1c or 0x14
            if not o.run.pilotH or not tick(s, interval) then return end
            local h, l = sideMuzzle(o, s.side, s.angle)
            local bases = s.pattern == 0 and {0,0x20,-0x20} or {0x10,0x30,-0x10}
            for j, base in ipairs(bases) do
                local a = s.angle * 4 + base
                for ray = 0, 5 do
                    local bh, bl = sweepMuzzle(h, l, a + 2 * ray)
                    bullets.emitFasterInLoop(o.run, 3, 6, a + 2 * ray, bh, bl)
                end
                local start = j == 3 and 0 or 1
                for ray = start, 5 do
                    local bh, bl = sweepMuzzle(h, l, a - 2 * ray)
                    bullets.emitFasterInLoop(o.run, 3, 6, a - 2 * ray, bh, bl)
                end
            end
            s.pattern, s.waves = 1 - s.pattern, s.waves - 1
            if s.waves == 0 then
                s.gaps = s.gaps - 1
                if s.gaps == 0 then return true end
                s.waves, s.side, s.state = 2, 3 - s.side, 0
            end
        end,
    }

    -- 0x11e8ec 瞄准两座翼炮，同时沿着与瞄准方向垂直的轴移动外侧炮口。
    emitters[10] = {
        function(o, s)
            local d = o.run.difficulty + 1
            s.clock, s.reload, s.inner, s.remaining = 4, ({0x20,0x1a,0x18,0x14})[d], 0, 0
            s.width, s.waves = s.width or 2, d == 1 and 2 or (d >= 3 or o.parts[10].broken or o.parts[11].broken) and 4 or 3
            s.spacing, s.turn, s.speed = 0x70, 8, 8
        end,
        function(o, s)
            local run = o.run
            if not run.pilotH then return end
            if s.remaining == 0 then
                if not tick(s, s.reload) then return end
                s.remaining = s.width
            end
            if not tick(s, 2, 'inner') then return end
            for side = 1, 2 do
                if not o.parts[side == 1 and 11 or 10].broken then
                    local ah, al = add(o.h, o.l, 0x1e00, side == 1 and -0xe40 or 0xe40)
                    local a = aim(o, ah, al, 0x80)
                    o.wingAngle[side] = floor(a / 4)
                    local h, l = sideMuzzle(o, side, o.wingAngle[side])
                    if s.spacing > 0x20 then
                        local dh, dl = program.vector(s.spacing, a + 0x40)
                        local bh, bl = add(h, l, dh, dl)
                        bullets.emitSpread(run, 0xb, s.speed, a, bh, bl)
                    end
                    bullets.emitFasterInLoop(run, 3, s.speed, a, h, l)
                    local dh, dl = program.vector(s.spacing, a - 0x40)
                    local bh, bl = add(h, l, dh, dl)
                    bullets.emitSpread(run, 0xb, s.speed, a, bh, bl)
                end
            end
            s.spacing = s.spacing + s.turn
            if s.spacing <= 0 or s.spacing >= 0x70 then
                s.spacing, s.turn = max(0, min(0x70, s.spacing)), -s.turn
            end
            s.remaining = s.remaining - 1
            if s.remaining == 0 then
                s.speed, s.waves = s.speed + 6, s.waves - 1
                return s.waves == 0
            end
        end,
    }

    emitters[11] = {
        function(o, s)
            s.clock, s.inner, s.remaining, s.waves = 0x20, 0, 0, o.run.difficulty == 3 and 5 or 4
            s.reload = ({8,4,3,2})[o.run.difficulty + 1]
            o.wingAngle[1], o.wingAngle[2] = 0x30, 0x10
        end,
        function(o, s)
            local run = o.run
            if not run.pilotH then return end
            if s.remaining == 0 then
                if not tick(s, s.reload) then return end
                s.remaining, s.bend = 0x20, {2*(pickSide(run)-1),2*(pickSide(run)-1)}
            end
            if not tick(s, 0, 'inner') then return end
            for side = 1, 2 do
                local a = o.wingAngle[side]
                local h, l = sideMuzzle(o, side, a)
                local extra = (o.run.difficulty == 3 and 0 or 1) + s.bend[side]
                local motion = {0,1,1,extra}
                bullets.emitFasterInLoop(run, 0x1d, -20, a*4, h, l, motion)
                if side == 2 and (o.parts[10].broken or o.parts[11].broken) then
                    bullets.emitFasterInLoop(run, 0x1d, -18, (a+1)*4, h, l, motion)
                end
                o.wingAngle[side] = band(a + (side == 1 and 2 or -2), 0x3f)
            end
            s.remaining = s.remaining - 1
            if s.remaining == 0 then s.waves = s.waves - 1; return s.waves == 0 end
        end,
    }

    emitters[12] = {
        function(o, s)
            s.clock, s.side = 0x10, pickSide(o.run)
            s.waves = s.waves or 3
            s.reload = o.run.route.loop == 1 and 3 or ({0x10,5,4,3})[o.run.difficulty + 1]
        end,
        function(o, s)
            local run = o.run
            if not run.pilotH or not tick(s, s.reload) then return end
            local side = s.side
            if o.parts[side == 1 and 11 or 10].broken then side = 3 - side end
            local kick = side + 4
            remove(o.auxiliary, kick)
            aux(o, kick)
            local h, l = add(o.h, o.l, side == 1 and -0x1c1 or -0x1c0, side == 1 and -0xbc0 or 0xbc0)
            local a = aim(o, h, l, 0x80)
            local motion = {side == 1 and -1 or 1,4,s.reload}
            for _, angle in ipairs({0,17,34,51,-17,-34,-51}) do
                bullets.emitFasterInLoop(run, 0x1f, 12, a + angle, h, l, motion)
            end
            s.waves, s.side = s.waves - 1, 3 - side
            return s.waves == 0
        end,
    }

    emitters[13] = {
        function(_, s) s.clock, s.inner, s.remaining, s.offset = 0x10, 0, 0, 0 end,
        function(o, s)
            if not o.run.pilotH then return end
            if s.remaining == 0 then
                if not tick(s, 0xc) then return end
                s.remaining = 5
            end
            if not tick(s, 2, 'inner') then return end
            local angle = band(s.angle + s.offset, 0xff)
            if angle >= 0x20 and angle < 0xe0 then
                local h, l = radial(o, angle)
                bullets.emitLongPair(o.run, 0xb, 4 - s.remaining, angle, h, l)
            end
            s.remaining = s.remaining - 1
            if s.remaining == 0 then s.offset = s.offset + 2 * s.turn end
        end,
    }

    emitters[16] = {
        function(o, s) s.clock, s.inner, s.remaining, s.side = 0, 0, 0, pickSide(o.run) end,
        function(o, s)
            if not o.run.pilotH then return end
            if s.remaining == 0 then
                if not tick(s, 0) then return end
                s.remaining = 6
            end
            if not tick(s, 2, 'inner') then return end
            local h, l = add(o.h, o.l, s.side == 1 and -0x441 or -0x440, s.side == 1 and -0x580 or 0x580)
            bullets.emit(o.run, 0xc, 4, 0x20, h, l)
            s.remaining = s.remaining - 1
            if s.remaining == 0 then s.side = 3 - s.side end
        end,
    }

    emitters[17] = {
        function(o, s)
            local d = o.run.difficulty + 1
            s.clock, s.inner, s.remaining, s.speed = 0x60, 0, 0, 1
            s.reload = ({0x20,0x1c,0x18,0x14})[d]
            s.interval, s.width, s.parameter = ({12,6,5,4})[d], ({1,1,4,8})[d], ({0,0,2,4})[d]
        end,
        function(o, s)
            local run = o.run
            if not run.pilotH then return end
            if s.remaining == 0 then
                if o.hp <= 0xace6 or not tick(s, s.reload) then return end
                s.remaining, s.width = s.width, band(s.width + 1, 0xff)
            end
            if not tick(s, s.interval, 'inner') then return end
            local step, count = run.route.loop == 1 and 14 or 16, run.route.loop == 1 and 18 or 15
            for i = 0, count do
                local angle = i * step
                if angle >= 0x20 and angle < 0xe0 then
                    local h, l = radial(o, angle)
                    bullets.emitFasterInLoop(run, 0x18, s.speed, angle, h, l)
                    bullets.emitAngle(run, 0x1a, s.parameter, angle, h, l)
                end
            end
            s.remaining, s.speed = s.remaining - 1, -s.speed
        end,
    }

    local function draw(o, id, dh, dl)
        local h, l = add(o.h, o.l, dh, dl)
        local image = o.run.art.sprites[id]
        Render(image[1], floor(l / 64) - 112 + image[2] / 2, floor(h / 64) - 224 + image[3] / 2)
    end

    local Boss = Class(object, {
        init = function(o, run)
            o.run, o.h, o.l = run, s16(0x8800), 0x1c00 - run.cameraOffset
            o.group, o.layer, o.colli, o.bound = GROUP.GHOST, LAYER.ENEMY, false, false
            o.events, o.auxiliary, o.emitters, o.parts = {}, {}, {}, {}
            o.phase, o.damageLocked, o.timeouts = 0, true, {unpack(data.timeouts)}
            o.shellPosition, o.hullHatch, o.weaponHatch, o.flameTick = 0, 0, 0, 0
            o.wingLift = {0,0}
            o.opening, o.cheekShots, o.centerShots, o.sweepCount = 0, 2, 3, 4
            o.edgeBursts, o.edgeClock = 3, 0x1c
            o.wingShots, o.wingFans = 4, 2
            o.guns = {[3]=0x20,[4]=0x20,[5]=0x38,[6]=8,[7]=0x10,[8]=0x30}
            o.wingAngle = {0x30,0x10}
            for i, row in ipairs(data.parts) do o.parts[i] = New(Part, o, row) end
            o.hp, o.maxhp = o.parts[1].hp, o.parts[1].hp
            updateParts(o)
            event(o, 0)
            run.capacity = 190
        end,
        render = function(o)
            if o.hidden then return end
            local flame = floor(o.flameTick / 4) + 1
            if o.phase >= 2 then
                draw(o, unpack(data.base[5]))
                draw(o, data.engines[4][flame], 0xe00, -0xa00)
                return
            end
            if o.phase == 0 and o.hullHatch == 0 then
                draw(o, unpack(data.base[1]))
                draw(o, data.engines[1][flame], 0xe00, -0xa00)
                draw(o, unpack(data.base[2]))
                draw(o, unpack(data.base[3]))
                draw(o, data.engines[2][flame], -0x400, -0x1a00)
                draw(o, data.engines[3][flame], -0x3ff, 0x1200)
                draw(o, unpack(data.base[4]))
                for raw = 3, 6 do
                    if not o.parts[raw + 1].broken then
                        local offset = offsets[raw]
                        local bank = raw <= 4 and 3 or raw - 4
                        draw(o, data.guns[bank][floor(o.guns[raw] / 2) + 1], offset[1] - 0x440, offset[2] - 0x600)
                    end
                end
            else
                local hatch = o.hullHatch + 1
                draw(o, data.engines[5][hatch], -0x1a00, -0x1400)
                draw(o, data.engines[6][hatch], -0x400, -0x2200)
                draw(o, data.engines[7][hatch], -0x3ff, 0x1400)
                for side = 1, 2 do
                    local raw = side == 1 and 10 or 9
                    if not o.parts[raw + 1].broken then
                        local l = side == 1 and -0x1900 or 0x500
                        draw(o, data.wings[3 * side - 2][o.weaponHatch + 1], -0x400 + o.wingLift[side], l)
                    end
                end
                draw(o, data.engines[4][flame], 0xe00, -0xa00)
            end
        end,
    })

    function M.spawn(run)
        run.boss3 = New(Boss, run)
        return run.boss3
    end

    function M.step(o)
        local run = o.run
        if run.freeze then return end
        o.l = s16(o.l - run.cameraStep)
        dispatch(o, o.auxiliary, auxiliary, 25)
        dispatch(o, o.events, events, 5)
        local init = o.nextMove ~= nil
        if init then o.mover, o.nextMove = o.nextMove, nil end
        if o.mover then movement[o.mover.id][init and 1 or 2](o, o.mover) end
        updateParts(o)
        dispatch(o, o.emitters, emitters, 20)
        applyDamage(o)
        if o.retire then
            run.stageCleared, run.nextStageNumber = true, 4
            M.close(o)
        end
    end

    function M.touch(o, h, l, front, back, right, left)
        for _, p in ipairs(o.parts) do
            if p.colli and band(p.h + 0x2800 - p.back, 0xffff) < 0xf800
                and program.overlap(p, h, l, front, back, right, left) then
                damage(p, 1)
                return p
            end
        end
    end

    function M.close(o)
        local run = o.run
        run.boss3, run.bossPresent, run.bossEngaged, run.uraBoss = nil, false, false, false
        for _, p in ipairs(o.parts) do if IsValid(p) then object.RawDel(p) end end
        if IsValid(o) then object.RawDel(o) end
    end

    return M
end
