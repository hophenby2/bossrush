-- 二面 0x90。0x112962 把移动、事件、辅助、发射与受击分开挂载。
return function(program, bullets, effects, score)
    local band = require('bit').band
    local floor, min, max = math.floor, math.min, math.max
    local s16, vector = program.s16, program.vector
    local data = program.boss2
    local M = {}
    local movement, events, auxiliary, emitters = {}, {}, {}, {}
    local spawnPod, limitAim
    local partOffsets = {{0,0},{0x780,0},{-0x1c80,-0xa80},{-0x1c80,0xa80},
        {0x100,-0xd00},{0x100,0xd00},{0,0}}
    local breakSlots = {[2]=9,[3]=11,[4]=12,[5]=13,[6]=14}
    local breakKicks = {[2]={14,0},[3]={8,0x30},[4]={8,0xd0},[5]={12,0x40},[6]={12,0xc0}}

    local function damage(p, amount)
        p.damagePending = p.damagePending + amount
    end

    local Part = Class(object, {
        init = function(p, boss, index)
            p.host, p.run, p.hitPool = boss, boss.run, 2
            p.hp, p.front, p.back, p.right, p.left = unpack(data.parts[index])
            p.damage, p.damagePending = damage, 0
            p.group, p.layer, p.bound, p.colli = GROUP.ENEMY, LAYER.ENEMY, false, false
        end,
    })

    local function updateParts(o)
        for index, p in ipairs(o.parts) do
            local h, l = unpack(partOffsets[index])
            p.h, p.l = s16(o.h + h), s16(o.l + l)
            p.x, p.y = program.world(p.h, p.l)
        end
    end

    local function has(slots, id)
        for _, s in pairs(slots) do if s.id == id then return true end end
        return false
    end

    local function remove(slots, id)
        for key, s in pairs(slots) do if s.id == id then slots[key] = nil end end
    end

    local function register(slots, id, limit)
        if has(slots, id) then return end
        for key = 1, limit do
            if not slots[key] then
                slots[key] = {id=id}
                return
            end
        end
    end

    local function event(o, id) register(o.events, id, 5) end
    local function aux(o, id) register(o.auxiliary, id, 25) end
    local function emit(o, id) register(o.emitters, id, 20) end

    local function dispatch(o, slots, definitions, limit)
        for key = 1, limit do
            local s = slots[key]
            if s then
                local callbacks = definitions[s.id]
                assert(callbacks, ('绊地狱二面关底缺少回调 %d'):format(s.id))
                if not s.started then
                    s.started = true
                    callbacks[1](o, s)
                elseif callbacks[2](o, s) and slots[key] == s then
                    slots[key] = nil
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

    local function signedRandom(run, values)
        local n = program.random(run, values)
        return n < 128 and n or n - 256
    end

    local function setSideScroll(o, value)
        o.run.bossScrollL = value
        o.swayTotal = s16(o.swayTotal + value)
    end

    local function resetAttack(o)
        o.events, o.emitters = {}, {}
        o.coverFiring, o.tailLocked, o.coreFiring = false, false, false
        o.innerLocked[1], o.innerLocked[2] = false, false
    end

    local function fly(o)
        local dh = vector(o.speed, 0)
        o.h = s16(o.h + dh - o.run.scrollStep * 64)
    end

    local function coast(o)
        o.h = s16(o.h - o.run.scrollStep * 64)
    end

    movement[0] = {
        function(o, s)
            o.speed, o.h, o.l = 1, s16(0xa600), 0x1c00 - o.run.cameraOffset
            s.arrival, s.deploy, s.interval, s.clock = 0x200, 0x40, 6, 6
        end,
        function(o, s)
            if s.arrival > 0 then
                s.arrival = s.arrival - 1
                if s.arrival > 0 then coast(o); return end
                aux(o, 2)
                o.run.bossPresent = true
            end
            if s.deploy > 0 then
                s.deploy = s.deploy - 1
                if s.deploy == 0 then aux(o, 4) end
                coast(o)
                return
            end
            if not o.ready and tick(s, s.interval) then
                s.interval = max(3, s.interval - 1)
                s.clock = s.interval
                if o.speed < 0xe then
                    o.speed = o.speed + 1
                else
                    aux(o, 1)
                    aux(o, 15)
                    aux(o, 17)
                    event(o, 2)
                    for index = 2, 6 do o.parts[index].colli = true end
                    o.ready, o.damageLocked, o.run.uraBoss = true, false, true
                end
            end
            fly(o)
        end,
    }

    local function sway(o)
        if o.swayState == -1 then setSideScroll(o, 0); return end
        local _, dl = vector(2, o.swayAngle)
        setSideScroll(o, dl)
        if tick(o, 1, 'swayClock') then
            local a = band(o.swayAngle + o.swayTurn, 0xff)
            if o.swayState == 1 and (a == 0x40 or a == 0xc0) then
                o.swayState = -1
            else
                o.swayAngle = a
            end
        end
    end

    for id, limits in pairs({[1]={0x5000,0x5800},[2]={0x4400,0x4800,true},
        [3]={0x4000,0x4800,true},[10]={0x4a00,0x5000,true}}) do
        local low, high, variable = unpack(limits)
        local function nextLow(o)
            return low + (variable and signedRandom(o.run, data.movementRandom) * 128 or 0)
        end
        movement[id] = {
            function(o, s)
                s.up, s.down, s.low = 6, 24, nextLow(o)
                o.h = s16(o.h + vector(o.speed, 0))
                coast(o)
            end,
            function(o, s)
                sway(o)
                o.h = s16(o.h + vector(o.speed, 0))
                local height = band(o.h, 0xffff)
                o.engineMode = 0
                if height < s.low then
                    o.engineMode = 2
                    if o.speed < 0x13 and tick(s, 6, 'up') then
                        o.speed = o.speed + program.random(o.run, program.randomSign)
                    end
                elseif height >= high then
                    o.engineMode = 4
                    s.low = nextLow(o)
                    if o.speed > 0x10 and tick(s, 24, 'down') then
                        o.speed = o.speed - program.random(o.run, program.randomSign)
                    end
                end
                coast(o)
            end,
        }
    end

    movement[8] = {
        function(o) o.speed = 0x10; o.run.bossScrollL = 0 end,
        function(o)
            fly(o)
            local undo = max(-8, min(8, -o.swayTotal))
            setSideScroll(o, undo)
        end,
    }

    events[0] = {
        function(o)
            o.swayAngle = signedRandom(o.run, program.randomParity) < 0 and 0xc0 or 0x40
            o.swayTurn = signedRandom(o.run, program.randomParity) < 0 and -1 or 1
            o.nextMove = 0
        end,
        function() return true end,
    }

    events[2] = {
        function(o)
            o.nextMove = 1
            emit(o, 0)
            emit(o, 1)
        end,
        function(o)
            if not has(o.emitters, 1) then
                event(o, o.parts[5].broken and o.parts[6].broken and 7 or 3)
                return true
            end
        end,
    }

    events[3] = {
        function(o)
            o.nextMove, o.swayState = 2, 1
            aux(o, 5)
        end,
        function(o)
            if not has(o.auxiliary, 5) then
                emit(o, 2)
                remove(o.emitters, 3)
                emit(o, 3)
                event(o, 9)
                return true
            end
        end,
    }

    events[4] = {
        function(o)
            o.nextMove, o.swayState = 1, 1
            emit(o, 5)
            remove(o.emitters, 0)
        end,
        function(o)
            if not has(o.emitters, 5) then
                local count = 0
                for _ in pairs(o.run.bullets) do count = count + 1 end
                if count < 0x40 then
                    o.swayState = 0
                    event(o, 2)
                    return true
                end
            end
        end,
    }

    events[7] = {
        function(o)
            o.nextMove = 1
            emit(o, 4)
            remove(o.auxiliary, 1)
        end,
        function(o)
            if not has(o.emitters, 4) then event(o, 4); return true end
        end,
    }

    events[9] = {
        function() end,
        function(o)
            if not has(o.emitters, 2) and not has(o.auxiliary, 6) then
                o.swayState = 0
                event(o, 7)
                return true
            end
        end,
    }

    auxiliary[1] = {
        function(_, s) s.clock = 0 end,
        function(o, s)
            if not o.coverFiring and tick(s, 1) then o.coverAngle = limitAim(o, o.coverAngle, 0x780, 0x10, 0x30) end
        end,
    }

    auxiliary[2] = {
        function(o, s) s.clock, s.index, o.deployment = 2, 1, 0x60 end,
        function(o, s)
            if s.sliding then s.index = s.index + 1 end
            if tick(s, 2) then
                s.sliding = true
                o.deployment = o.deployment - 0xc
            end
            o.h = s16(o.h + data.deployment[s.index])
            return o.deployment == 0
        end,
    }

    auxiliary[4] = {
        function(o, s) s.clock, o.flameFrame = 1, 1 end,
        function(o, s)
            if tick(s, o.engineMode == 2 and 0 or 1) then
                o.flameFrame = o.flameFrame % 3 + 1
            end
        end,
    }

    local function track(o, h, l, old)
        local run = o.run
        if not run.pilotH then return old end
        local target = program.angle(s16(o.h + h), s16(o.l + l), run.pilotH, run.pilotL, old)
        return program.turnToward(old, target)
    end

    auxiliary[15] = {
        function(_, s) s.clock = 0 end,
        function(o, s)
            if tick(s, 1) then
                o.outerAngle[1] = track(o, -0x1980, -0xac0, o.outerAngle[1])
                o.outerAngle[2] = track(o, -0x1980, 0xac0, o.outerAngle[2])
            end
        end,
    }

    auxiliary[17] = {
        function(_, s) s.clock = 0 end,
        function(o, s)
            if tick(s, 1) then
                o.forwardAngle[1] = track(o, 0x1780, -0xbc0, o.forwardAngle[1])
                o.forwardAngle[2] = track(o, 0x1780, 0xbc0, o.forwardAngle[2])
            end
        end,
    }

    local function commands(raw)
        local result = {}
        for index, row in ipairs(raw) do
            result[index] = {row[10],row[1],0,row[3],row[4],row[6],row[7]}
        end
        return result
    end

    local function breakEffect(raw)
        local burst = commands(raw)
        return {
            function(o, s)
                s.clock = 12
                effects.spawn(o.run, o.h, o.l, burst, false, true)
            end,
            function(_, s)
                s.clock = s.clock - 1
                return s.clock == 0
            end,
        }
    end

    for index, id in pairs(breakSlots) do
        auxiliary[id] = breakEffect(data.partBurst[index == 2 and 1 or index])
    end

    auxiliary[10] = breakEffect(data.partBurst[2])

    local function rowFor(o, tableName) return data[tableName][o.run.difficulty + 1] end
    local function b(row, off) return row:byte(off - 1) end
    local function w(row, off) return program.word(row, off - 1) end

    local function coverMuzzle(o, aim)
        local run = o.run
        local dh, dl = unpack(data.coverMuzzle[o.coverAngle - 0x10 + 1])
        local h, l = program.add(o.h, o.l, dh, dl)
        local angle = o.coverAngle * 4
        if aim and run.pilotH and program.distance(o.h + 0x880, o.l, run.pilotH, run.pilotL) < 0x1000 then
            angle = program.aimByte(s16(o.h + 0x880 + dh), s16(o.l + dl), run.pilotH, run.pilotL, angle, true)
        end
        return h, l, angle
    end

    limitAim = function(o, old, h, low, high)
        local run = o.run
        if not run.pilotH then return old end
        local target = program.angle(o.h + h, o.l, run.pilotH, run.pilotL, old)
        if target == old then return old end
        local forward = band(target - old, 63) < 32
        if target < low or target > high then
            local targetIsLeft = band(target - 0x20, 63) >= 32
            local currentIsLeft = band(old - target, 63) <= 32
            if targetIsLeft ~= currentIsLeft then forward = not forward end
        end
        return max(low, min(high, old + (forward and 1 or -1)))
    end

    -- 0x116648 发射槽一直跟随外侧炮塔的角度，直至事件 4 注销它。
    emitters[0] = {
        function(o, s)
            local row = rowFor(o, 'outerFire')
            s.clock, s.delay, s.burstDelay = b(row, 2), b(row, 3), b(row, 5)
            s.shots, s.reset = w(row, 6), w(row, 8)
            s.speed, s.count, s.spread = s16(w(row, 0xc)), w(row, 0x10), w(row, 0x12)
        end,
        function(o, s)
            if not tick(s, s.delay) then return end
            for side = 1, 2 do
                if not o.parts[side + 2].broken then
                    local sign, a = side == 1 and -1 or 1, o.outerAngle[side]
                    local h, l = program.add(o.h, o.l, -0x1980, sign * 0xac0)
                    h, l = program.add(h, l, unpack(data.outerMuzzle[floor(a / 2) + 1]))
                    for i = 0, s.count do
                        bullets.emitLongPair(o.run, 9, s.speed, a * 4 + sign * (s.spread - i * 8), h, l)
                    end
                end
            end
            if tick(s, s.reset, 'shots') then s.clock = s.burstDelay end
        end,
    }

    -- 0x116850 的两套扇形按当前波次切换。内侧炮损坏会增加扇形的边缘弹。
    emitters[1] = {
        function(o, s)
            local row = rowFor(o, 'coverFire')
            s.clock, s.shots, s.repeatShots = b(row, 2) - o.coverDelay, w(row, 4), w(row, 6)
            s.delay, s.burstDelay, s.waves = b(row, 8), b(row, 9), b(row, 0xa) + o.coverWaves
            s.speed, s.odd, s.even = s16(w(row, 0xc)) + o.coverSpeed, w(row, 0x12), w(row, 0x14)
            s.spread = w(row, 0x16) - o.coverSpread
        end,
        function(o, s)
            if not tick(s, s.delay) then return end
            local run = o.run
            o.coverFiring = true
            local h, l, a = coverMuzzle(o, true)
            local odd = s.waves % 2 == 1
            local speed = s.speed + (odd and 0 or 2)
            local function shot(angle, central)
                local mh, ml = unpack(program.boss1FanMuzzle[floor(band(angle + 2, 0xff) / 4) + 1])
                local ph, pl = program.add(h, l, mh + 0x880, ml)
                if central then
                    bullets.emitAngle(run, 3, speed, angle, ph, pl)
                    if run.route.loop == 1 then
                        bullets.emitAngle(run, 3, speed, angle - 4, ph, pl)
                        bullets.emitAngle(run, 3, speed, angle + 4, ph, pl)
                    end
                else
                    bullets.emitSpread(run, 3, speed, angle, ph, pl)
                end
            end
            if odd then shot(a, true) end
            local count = (odd and s.odd or s.even) + 1 + o.coverRays
            local centering = odd and 0 or floor(s.spread / 2)
            local left, right = a + centering, a - centering
            for _ = 1, count do left = left - s.spread; shot(left) end
            for _ = 1, count do right = right + s.spread; shot(right) end
            for index = 5, 6 do
                if o.parts[index].broken then
                    left, right = left - s.spread, right + s.spread
                    shot(left)
                    shot(right)
                end
            end
            if tick(s, s.repeatShots, 'shots') then
                o.coverFiring = false
                s.waves, s.speed = s.waves - 1, s.speed + 1
                s.burstDelay = max(12, s.burstDelay - 6)
                s.clock = s.burstDelay
                if s.waves < 0 then
                    o.coverWaves, o.coverSpeed = min(8, o.coverWaves + 2), min(6, o.coverSpeed + 3)
                    o.coverDelay = min(16, o.coverDelay + 8)
                    o.coverRays, o.coverSpread = min(4, o.coverRays + 2), min(4, o.coverSpread + 2)
                    return true
                end
            end
        end,
    }

    local function muzzleFor(tableData, angle)
        return unpack(tableData[floor(band(angle + 2, 0xff) / 4) + 1])
    end

    local function addMuzzle(h, l, tableData, a, dh, dl)
        local mh, ml = program.add(dh, dl, muzzleFor(tableData, a))
        return s16(h + mh), s16(l + ml)
    end

    local function rotate(current, target, steps)
        for _ = 1, steps do current = program.turnToward(current, target) end
        return current
    end

    -- 0x116cce 每个仍存活的内侧部件独立瞄准。切换波次时收紧扇形。
    emitters[2] = {
        function(o, s)
            local row = rowFor(o, 'edgeFire')
            s.clock, s.shots, s.shotReset = b(row, 2) - o.edgeDelay, b(row, 4) + o.edgeShots, b(row, 5) + o.edgeShots
            s.speed, s.waves, s.waveReset = w(row, 6), b(row, 0xa), b(row, 0xb)
            s.delay, s.podReset, s.podClock = b(row, 0xc), b(row, 0xd), b(row, 0xe)
            s.rounds, s.roundDelay = b(row, 0x1c), b(row, 0x1e)
            s.offsets, s.angles = {0,0}, {0,0}
            s.turn = program.random(o.run, program.randomSign) == 1 and -1 or 1
        end,
        function(o, s)
            local run = o.run
            if tick(s, s.delay) then
                if not run.pilotH then return end
                for side = 1, 2 do
                    if not o.parts[4 + side].broken then
                        local l = o.l + (side == 1 and -0xf80 or 0x12c0)
                        if s16(run.pilotH - (o.h - 0xc0)) >= -0x1000 or not s.holdAim then
                            s.angles[side] = program.aimByte(o.h - 0xc0, l, run.pilotH, run.pilotL, s.angles[side], true)
                        end
                        local a = s.angles[side] + s.offsets[side]
                        local sign = side == 1 and -1 or 1
                        local outside, inside = o.l + (side == 1 and -0x1400 or 0x14c0),
                            o.l + (side == 1 and -0x1100 or 0x12c0)
                        bullets.emitSpread(run, 0xb, s.speed, a - sign * 0x10, o.h - 0xc0, outside)
                        if s.rounds <= 1 then
                            bullets.emitAngle(run, 0xb, s.speed, a - sign * 0x20, o.h - 0xc0, outside)
                        end
                        bullets.emitSpread(run, 0xb, s.speed, a + sign * 0x10, o.h - 0xc0, inside)
                        if s.rounds == 0 then
                            bullets.emitAngle(run, 0xb, s.speed, a + sign * 0x20, o.h - 0xc0, inside)
                        end
                    end
                end
                for side = 1, 2 do s.offsets[side] = band(s.offsets[side] + s.turn, 255) end
                if tick(s, s.shotReset, 'shots') then
                    s.turn, s.holdAim = -s.turn, true
                    if tick(s, s.waveReset + 1, 'waves') then
                        s.waveReset, s.speed, s.clock = s.waveReset + 1, s.speed + 4, s.roundDelay
                        s.holdAim, s.rounds = false, s.rounds - 1
                        if s.rounds < 0 then
                            o.edgeShots, o.edgeDelay = min(6, o.edgeShots + 2), min(10, o.edgeDelay + 2)
                            aux(o, 6)
                            return true
                        end
                    end
                end
            end
            if tick(s, s.podReset, 'podClock') then
                for side = 1, 2 do
                    if o.parts[2 + side].broken and not o.parts[4 + side].broken then
                        spawnPod(o, side)
                    end
                end
            end
        end,
    }

    emitters[3] = {
        function(o, s)
            local row = rowFor(o, 'edgePause')
            s.clock, s.pause, s.shots, s.reset, s.delay = row:byte(1, 5)
        end,
        function(_, s)
            if tick(s, s.delay) and tick(s, s.reset, 'shots') then s.clock = s.pause end
        end,
    }

    -- 0x117354 炮盖先找到起始角，然后边扫边发。到边界才切换扫向。
    emitters[4] = {
        function(o, s)
            local row = rowFor(o, 'sweepFire')
            s.clock, s.delay, s.rest = b(row, 2) - o.sweepStart, b(row, 8) - o.sweepRate, b(row, 9)
            s.waves, s.speed, s.aim = b(row, 0xa) + o.sweepWaves, s16(w(row, 0xc)) + o.sweepSpeed, b(row, 5)
            local sign = signedRandom(o.run, program.effectRandom) < 0 and -1 or 1
            s.from, s.target = band(b(row, 0xe) * sign, 63), band(b(row, 0xf) * sign, 63)
            s.count, s.offset = {w(row, 0x16), w(row, 0x14)}, {w(row, 0x1a), w(row, 0x18)}
        end,
        function(o, s)
            if not s.ready then
                s.clock = max(0, s.clock - 1)
                o.coverAngle = rotate(o.coverAngle, s.from, 1)
                s.ready = o.coverAngle == s.from
                return
            end
            if not tick(s, s.delay) then return end
            local run = o.run
            local h, l, a = coverMuzzle(o, s.aim % 2 == 1)
            local parity = s.waves % 2 + 1
            a = a - s.offset[parity]
            local left = a - 11
            for _ = 0, s.count[parity] do
                local bh, bl = addMuzzle(h, l, data.sweepMuzzle, a, 0x880, 0)
                bullets.emitSpread(run, 2, s.speed, a, bh, bl)
                a = a + 11
            end
            for side = 1, 2 do
                if o.parts[4 + side].broken then
                    local ray = side == 1 and a or left
                    local bh, bl = addMuzzle(h, l, data.sweepMuzzle, ray, 0x880, 0)
                    bullets.emitLongPair(run, 2, s.speed, ray, bh, bl)
                end
            end
            o.coverAngle = rotate(o.coverAngle, s.target, 2)
            if o.coverAngle == s.target then
                s.target, s.speed = band(-s.target, 63), s.speed + 4
                local limit = parity == 1 and 3 or 2
                if s.count[parity] < limit then
                    s.count[parity], s.offset[parity] = s.count[parity] + 2, s.offset[parity] + 11
                end
                s.clock, s.waves = s.rest, s.waves - 1
                if s.waves < 0 then
                    o.sweepWaves, o.sweepSpeed = min(2, o.sweepWaves + 1), min(4, o.sweepSpeed + 2)
                    o.sweepStart, o.sweepRate = min(32, o.sweepStart + 8), 1
                    aux(o, 1)
                    return true
                end
            end
        end,
    }

    -- 0x1176c4 先逐次收窄成对弹，再发一轮扩散弹。炮口角在这一轮中锁住。
    emitters[5] = {
        function(o, s)
            local row = rowFor(o, 'innerFire')
            s.clock, s.delay, s.shortDelay, s.pause = b(row, 2) - o.innerDelay, b(row, 3) - o.innerDelay, b(row, 4), b(row, 5)
            s.shots, s.reset, s.spread, s.spreadReset = b(row, 6), b(row, 7), b(row, 8), b(row, 9)
            s.waves, s.slow, s.kind = b(row, 0xa), s16(w(row, 0xe)), w(row, 0x10)
            s.fast, s.fastKind, s.count, s.wide = s16(w(row, 0x12)), w(row, 0x14), w(row, 0x16), w(row, 0x18)
            s.childSpeed = s16(w(row, 0x1a)) + o.innerSpeed
            s.childModifier = w(row, 0x1c) - o.innerChildDelay * 0x100
            s.childPeriod = w(row, 0x1e)
        end,
        function(o, s)
            if not tick(s, s.finale and s.delay or s.shortDelay) then return end
            local function fire(side)
                local run, sign = o.run, side == 1 and -1 or 1
                o.innerLocked[side] = true
                local a = o.innerAngle[side]
                local mh, ml = unpack(data.innerMuzzle[floor(a / 2) + 1])
                local dh, dl = 0x500, sign * 0x9c0
                local h, l = o.h + dh, o.l + dl
                if run.pilotH and program.distance(h, l, run.pilotH, run.pilotL) < 0x1000 then
                    a = program.angle(h + mh, l + ml, run.pilotH, run.pilotL, a)
                    if s.finale then mh, ml = unpack(data.innerMuzzle[floor(a / 2) + 1]) end
                end
                h, l = program.add(o.h, o.l, mh, ml)
                a = a * 4
                local function shot(angle)
                    local bh, bl = addMuzzle(h, l, program.boss1FanMuzzle, angle, dh, dl)
                    if s.finale then
                        local speed = s.fast + (run.route.loop == 1 and 4 or 0)
                        local cycle = run.route.loop == 1 and 0x0604 or s.childPeriod
                        local motion = {floor(cycle / 256),cycle % 256,s16(s.childSpeed),s16(s.childModifier)}
                        bullets.emitMotion(run, s.fastKind, speed, angle, bh, bl, nil, nil, motion)
                    else
                        bullets.emitSpread(run, s.kind, s.slow, angle, bh, bl)
                    end
                end
                if s.finale and s.waves == 0 then
                    local start = a + sign * (s.wide + 24)
                    for i = 0, s.count + 6 do shot(start - sign * i * 4) end
                elseif s.finale then
                    for _, d in ipairs({-1,1}) do
                        for i = 0, s.count do shot(a + d * (s.wide - i * 4)) end
                    end
                else
                    shot(a - s.spread)
                    shot(a + s.spread)
                end
            end
            if s.waves % 2 == 0 then fire(1) end
            if s.waves % 2 == 1 or s.waves == 0 then fire(2) end
            if s.finale then
                o.innerLocked[1], o.innerLocked[2], s.finale = false, false, false
                s.waves, s.clock = s.waves - 1, s.delay
                if s.waves < 0 then
                    o.innerDelay, o.innerSpeed = min(32, o.innerDelay + 8), min(12, o.innerSpeed + 4)
                    o.innerChildDelay = min(40, o.innerChildDelay + 20)
                    return true
                end
            else
                if s.spread ~= 8 then s.spread = s.spread - 1 end
                if tick(s, s.reset, 'shots') then s.spread, s.clock, s.finale = s.spreadReset, s.pause, true end
            end
        end,
    }

    -- 0x1181fc 的主炮在一轮开始时记住后炮角和随机偏角，两种发射各自查炮口。
    emitters[6] = {
        function(o, s)
            local row = rowFor(o, 'coreFire')
            s.clock, s.shots, s.reset = b(row, 2) - o.coreDelay, w(row, 4), w(row, 6)
            s.delay, s.rest, s.waves = b(row, 8), b(row, 9), b(row, 0xa) + o.coreWaves
            s.speed = s16(w(row, 0xc)) + o.coreSpeed
            s.odd, s.even, s.spread = w(row, 0x12) + o.coreRays, w(row, 0x14) + o.coreRays, w(row, 0x16) - o.coreSpread
        end,
        function(o, s)
            if not tick(s, s.delay) then return end
            local run = o.run
            if s.shots == s.reset then
                o.tailLocked = true
                s.stored = o.tailAngle
                s.angle = s.stored * 4 + floor(signedRandom(run, program.effectRandom) / 2)
            end
            local odd = s.shots % 2 == 1
            local a, from = s.angle, s.stored
            if odd and run.pilotH and program.distance(o.h - 0x1140, o.l, run.pilotH, run.pilotL) < 0x1000 then
                local dh, dl = unpack(data.coreMuzzle[floor(o.tailAngle / 2) + 1])
                a, from = program.aimByte(o.h - 0x1140 + dh, o.l + dl, run.pilotH, run.pilotL, a, true), o.tailAngle
            end
            local h, l = program.add(o.h, o.l, unpack(data.coreMuzzle[floor(from / 2) + 1]))
            local speed = s.speed + (s.reset - s.shots) * 2 + (odd and 0 or 7)
            local function shot(angle)
                local bh, bl = addMuzzle(h, l, program.boss1FanMuzzle, angle, -0x1140, 0)
                if odd then bullets.emitAngle(run, 9, speed + (run.route.loop == 1 and 4 or 0), angle, bh, bl)
                else bullets.emitSpread(run, 9, speed, angle, bh, bl) end
            end
            if odd then shot(a) end
            local centering = odd and 0 or floor(s.spread / 2)
            for _, sign in ipairs({-1,1}) do
                for i = 1, (odd and s.odd or s.even) + 1 do shot(a + sign * (i * s.spread - centering)) end
            end
            if tick(s, s.reset, 'shots') then
                o.tailLocked, s.speed, s.waves = false, s.speed + 1, s.waves - 1
                s.rest = max(2, s.rest - 4)
                s.clock = s.rest
                if s.waves < 0 then
                    o.coreWaves, o.coreSpeed = min(3, o.coreWaves + 1), min(4, o.coreSpeed + 2)
                    o.coreDelay = min(16, o.coreDelay + 8)
                    o.coreRays, o.coreSpread = min(2, o.coreRays + 1), min(4, o.coreSpread + 2)
                    o.nextMove = 3
                    return true
                end
            end
        end,
    }

    emitters[7] = {
        function(o, s)
            local row = rowFor(o, 'tailFire')
            s.clock, s.delay, s.rest = b(row, 2) - o.forwardDelay, b(row, 3), b(row, 5)
            s.shots, s.reset = w(row, 6) + o.forwardShots, w(row, 8) + o.forwardShots
            s.waves, s.speed, s.kind = b(row, 0xa), s16(w(row, 0xc)) + o.forwardSpeed, w(row, 0xe)
            s.rays, s.spread = w(row, 0x10) + o.forwardRays, w(row, 0x12)
        end,
        function(o, s)
            if not tick(s, s.delay) then return end
            for side = 1, 2 do
                local a = o.forwardAngle[side]
                local h, l = program.add(o.h, o.l, unpack(data.forwardMuzzle[floor(a / 2) + 1]))
                a = a * 4 - (s.shots % 2 == 1 and s.spread or 0)
                for i = 0, s.rays do
                    bullets.emitSpeedPair(o.run, s.kind, s.speed, a + 2 * i, h, l, 0x1780,
                        side == 1 and -0xbc0 or 0xbc0, {0,0,2,0x7f})
                end
            end
            if tick(s, s.reset, 'shots') then
                s.clock, s.waves = s.rest, s.waves - 1
                if s.waves < 0 then
                    o.forwardDelay, o.forwardShots = min(16, o.forwardDelay + 8), min(8, o.forwardShots + 4)
                    o.forwardSpeed, o.forwardRays = 1, min(2, o.forwardRays + 1)
                    return true
                end
            end
        end,
    }

    local function addChild(o, child)
        for i = 1, 48 do
            if not o.children[i] and not o.run.enemies[i + 10] then
                o.children[i] = child
                return
            end
        end
        object.RawDel(child)
    end

    local function childDamage(p, amount)
        p.damagePending = p.damagePending + amount
    end

    local function podFrame(p)
        local run, owner = p.run, p.host
        if p.hp < 0 or owner.phase ~= 0 then
            if run.pilotH and program.distance(p.h, p.l, run.pilotH, run.pilotL) >= 0x1000 then
                local a = program.aimByte(p.h, p.l, run.pilotH, run.pilotL, 0x80)
                local spread = run.route.loop == 1 and 2 or 0
                bullets.emitAngle(run, 9, -7, a - spread, p.h, p.l, 0x100)
                if spread > 0 then bullets.emitAngle(run, 9, -7, a + spread, p.h, p.l, 0x100) end
            end
            effects.spawn(run, p.h, p.l, {{4,0x8b,0,0,0,p.speed,p.angle}}, false, true)
            return true
        end
        p.image = (p.image - 2) % 8 + 1
        if tick(p, 3, 'speedClock') then p.speed = min(0x24, p.speed + 1) end
    end

    local function carrierFrame(p)
        local run = p.run
        if p.host.dead then
            effects.spawn(run, p.h, p.l, {{0,0x8b,0,0,0,p.speed,p.angle}}, false, true)
            return true
        end
        p.image = (p.image - 2) % 32 + 1
        if not p.firing and (band(p.h - 0x600, 0xffff) >= 0x6800 or band(p.l, 0xffff) >= 0x3800) then
            p.firing, p.speed, p.angle, p.shotClock, p.bodyContact = true, 0x20, 0, -1, false
        end
        if not p.firing or not tick(p, 4, 'shotClock') then return end
        local turn = p.shotAngle >= 0x80 and 5 or -5
        local h, l = p.h, p.l
        local driftHeight = p.shotDrift < 0 and -1 or 0
        local spread = run.route.loop == 1 and 1 or 0
        local motion = {p.extraStep}
        for i = 0, 7 do
            local a, speed = p.shotAngle + turn * i, -16 + p.shotMod * i
            bullets.emitMotion(run, 0x14, speed, a - spread, h, l, nil, nil, motion)
            if spread > 0 then bullets.emitMotion(run, 0x14, speed, a + spread, h, l, nil, nil, motion) end
            h, l = program.add(h, l, driftHeight, p.shotDrift)
        end
        bullets.emitWidePair(run, 0x0d, -16, 0x80, p.h, p.l, driftHeight, p.shotDrift * 3, {8,1,2,0x20})
        effects.spawn(run, p.h, p.l, {{0,0x8b,0,0,0,0,0}}, false, true)
        p.repeats = p.repeats - 1
        return p.repeats < 0
    end

    local Child = Class(object, {
        init = function(p, o, kind, h, l, speed, angle)
            p.host, p.run, p.hitPool = o, o.run, 1
            p.kind, p.h, p.l, p.speed, p.angle = kind, h, l, speed, angle
            p.group, p.layer, p.bound, p.colli = GROUP.ENEMY, LAYER.ENEMY, false, kind == 0x93
            p.front, p.back, p.right, p.left = 0x280, 0x280, 0x280, 0x280
            p.hp, p.damagePending, p.damage = kind == 0x93 and 0x100 or 0x1000, 0, childDamage
            p.update, p.bodyContact = kind == 0x93 and podFrame or carrierFrame, true
            p.x, p.y = program.world(h, l)
        end,
        render = function(p)
            local id
            if p.kind == 0x93 then id = data.podBody[p.image]
            elseif p.firing then id = data.carrierBody[p.image]
            else id = data.carrierFlight[p.image] end
            local image = p.run.art.sprites[id]
            Render(image[1], p.x - 16 + image[2] / 2, p.y - 24 + image[3] / 2)
        end,
    })

    spawnPod = function(o, side)
        local h, l = program.add(o.h, o.l, 0xa40, side == 1 and -0xfc0 or 0x1140)
        local p = New(Child, o, 0x93, h, l, 8, side == 1 and 0x86 or 0x7a)
        p.image = 8 - band(program.random(o.run, program.randomParity), 7)
        p.speedClock = 0
        addChild(o, p)
    end

    local function spawnCarrier(o, s)
        local left = s.target == 0x1a
        local odd = s.shots % 2 == 1
        local muzzle = left == odd and data.leftCarrier or data.rightCarrier
        local h, l = program.add(o.h, o.l, unpack(muzzle[o.coreAngle - 0x18 + 1]))
        local p = New(Child, o, 0x94, h, l, s.speed, o.coreAngle * 4)
        p.image = floor(band(program.random(o.run, program.enemyRandom), 0x3e) / 2) + 1
        p.shotClock, p.shotAngle = 6, s.shotAngle
        p.repeats, p.shotDrift, p.shotMod, p.extraStep = odd and 4 or 8, left and -0x100 or 0x100, s.step, s.extraStep
        addChild(o, p)
    end

    emitters[8] = {
        function(o, s)
            local row = rowFor(o, 'carrierFire')
            s.clock, s.delay, s.pause = b(row, 2) - o.carrier.start, b(row, 8) - o.carrier.rate, b(row, 9) - o.carrier.pause
            if o.run.route.loop == 1 then s.delay = s.delay + 16 end
            s.shots, s.reset, s.waves = w(row, 4), w(row, 6), b(row, 0xa) + o.carrier.waves
            local sign = signedRandom(o.run, program.effectRandom) < 0 and -1 or 1
            s.target, s.finish = band(b(row, 0xe) * sign, 63), band(b(row, 0xf) * sign, 63)
            s.shotAngle, s.speed, s.step = band(b(row, 0x11) * sign, 0xff), b(row, 0xc), w(row, 0x1c) + o.carrier.step
            s.extraStep = w(row, 0x1a) - o.carrier.drift
            s.phase = 0
            o.coreFiring = true
        end,
        function(o, s)
            if s.phase == 0 then
                if s.clock > 0 then s.clock = s.clock - 1; return end
                o.coreAngle = rotate(o.coreAngle, s.target, 1)
                if o.coreAngle == s.target then
                    s.phase, s.clock = 1, s.startedCarriers and s.delay or 0x10
                    s.startedCarriers = true
                end
            elseif s.phase == 1 then
                if not tick(s, 0x48) then return end
                spawnCarrier(o, s)
                if tick(s, s.reset, 'shots') then
                    s.clock, s.phase = s.pause, 0
                    s.target, s.finish, s.shotAngle = band(-s.target, 63), band(-s.finish, 63), band(-s.shotAngle, 0xff)
                    if s.waves == 1 then s.phase, s.finish, s.finishClock = 2, 0x20, 0 end
                    s.waves = s.waves - 1
                end
            elseif s.finishClock == 0 then
                o.coreAngle = rotate(o.coreAngle, s.finish, 1)
                if o.coreAngle == s.finish then s.finishClock = 0x40 end
            else
                s.finishClock = s.finishClock - 1
                if s.finishClock == 0 then
                    local v = o.carrier
                    v.waves, v.start, v.rate = min(4, v.waves + 2), min(32, v.start + 16), 16
                    v.pause, v.step = 12, min(2, v.step + 1)
                    v.drift = min(0x80, v.drift + 0x20)
                    o.coreFiring = false
                    return true
                end
            end
        end,
    }

    local function stepChildren(o)
        local run = o.run
        for index = 1, 48 do
            local p = o.children[index]
            if p then
                local pod = p.kind == 0x93
                local dh, dl = vector(p.speed, p.angle)
                p.h, p.l = s16(p.h + dh), s16(p.l + dl - (p.firing and 0 or run.cameraStep))
                local inBounds = band(p.h + (pod and 0x200 or 0x400), 0xffff) < (pod and 0x7400 or 0x7800)
                    and band(p.l + 0xa00 + run.cameraOffset, 0xffff) < 0x4c00
                p.hp, p.damagePending = p.hp - p.damagePending, 0
                if p.update(p) or p.entered and not inBounds and not p.firing then
                    o.children[index] = nil
                    object.RawDel(p)
                else
                    p.entered = p.entered or inBounds
                    p.x, p.y = program.world(p.h, p.l)
                end
            end
        end
    end

    local function hatchSlot(clock, start, endFrame, step)
        return {
            function(o, s) s.clock, o.hatch = clock, start end,
            function(o, s)
                if tick(s, 1) then
                    o.hatch = o.hatch + step
                    return o.hatch == endFrame
                end
            end,
        }
    end

    auxiliary[5], auxiliary[6] = hatchSlot(0x40, 1, 16, 1), hatchSlot(0, 16, 1, -1)

    auxiliary[7] = {
        function(o, s) s.clock, o.frontSlide = 0x40, 32 end,
        function(o, s)
            if not tick(s, 1) then return end
            o.frontSlide = o.frontSlide - 1
            if o.frontSlide == 1 then
                o.parts[1].colli, o.parts[7].colli, o.damageLocked = true, true, false
                bullets.clearFor(o.run, 0)
                remove(o.auxiliary, 15)
                aux(o, 0)
                aux(o, 8)
                aux(o, 16)
                return true
            end
        end,
    }

    auxiliary[0] = {
        function(_, s) s.clock = 0 end,
        function(o, s)
            if not o.tailLocked and tick(s, 0) then o.tailAngle = track(o, -0x1140, 0, o.tailAngle) end
        end,
    }

    auxiliary[8] = {
        function(_, s) s.clock = 0 end,
        function(o, s)
            if not o.coreFiring and tick(s, 1) then o.coreAngle = limitAim(o, o.coreAngle, 0xd80, 0x18, 0x28) end
        end,
    }

    auxiliary[16] = {
        function(_, s) s.clock = 0 end,
        function(o, s)
            if tick(s, 1) then
                if not o.innerLocked[1] then o.innerAngle[1] = track(o, 0x500, -0x9c0, o.innerAngle[1]) end
                if not o.innerLocked[2] then o.innerAngle[2] = track(o, 0x500, 0x9c0, o.innerAngle[2]) end
            end
        end,
    }

    events[5] = {
        function(o) o.nextMove = 10; aux(o, 7) end,
        function(o)
            if not has(o.auxiliary, 7) then event(o, 12); return true end
        end,
    }

    events[6] = {
        function(_, s) s.clock, s.count = 0x20, 24 end,
        function(o, s)
            if not tick(s, 3) then return end
            local run = o.run
            program.random(run, program.randomParity)
            local kind = data.phaseBurst[band(program.random(run, program.randomParity), 7) + 1]
            local angle = program.random(run, program.enemyRandom) - 32
            local dh = 0x1000 + 2 * program.random(run, data.phaseOffset)
            local dl = 2 * program.random(run, data.phaseOffset)
            effects.spawn(run, o.h, o.l, {{7,kind,0,dh,dl,2,angle}}, false, true)
            s.count = s.count - 1
            if s.count == 0 then event(o, 5); return true end
        end,
    }

    for _, order in ipairs({{12,10,6,10},{10,3,7,8},{8,1,8,12}}) do
        local id, mover, attack, nextEvent = unpack(order)
        events[id] = {
            function(o)
                o.nextMove = mover
                if id == 8 then o.swayState = 1 end
                emit(o, attack)
            end,
            function(o)
                if not has(o.emitters, attack) then
                    if id == 8 then o.swayState = 0 end
                    event(o, nextEvent)
                    return true
                end
            end,
        }
    end

    events[1] = {
        function(o, s) o.nextMove, s.phase, s.clock, s.index = 8, 0, 4, 1 end,
        function(o, s)
            if s.phase <= 1 then
                if s.phase == 1 and tick(s, 0x11, 'decay') then s.interval = max(1, s.interval - 1) end
                if tick(s, s.phase == 0 and 4 or s.interval) then
                    local kind, attr, dh, dl = unpack(data.breakup[s.index])
                    local speed, angle = 0, 0
                    if s.phase == 1 then
                        speed = 7 + floor(signedRandom(o.run, program.effectRandom) / 2) + floor((4 - s.interval) / 2)
                        angle = program.random(o.run, program.randomParity)
                    end
                    effects.spawn(o.run, o.h, o.l, {{0,kind,attr,dh,dl,speed,angle}}, false, true)
                    s.index = s.index % #data.breakup + 1
                    if s.index == 1 then
                        if s.phase == 0 then s.phase, s.interval, s.decay = 1, 4, 0x11
                        elseif s.interval == 1 then s.phase, s.clock = 2, 7 end
                    end
                end
            elseif s.phase == 2 and tick(s, 0) then
                o.hidden, s.phase, s.clock = true, 3, 0x7f
            elseif s.phase == 3 and s.clock > 0 then
                s.clock = s.clock - 1
            elseif s.phase == 3 and o.swayTotal == 0 then
                o.retire = true
                return true
            end
        end,
    }

    local function breakPart(o, index)
        local p = o.parts[index]
        if p.broken then return end
        p.broken, p.colli, p.hp = true, false, -1
        bullets.clearFor(o.run, 0x10)
        aux(o, breakSlots[index])
        if o.run.onPartBreak then o.run.onPartBreak(o, p) end
    end

    local function changePhase(o)
        for _, index in ipairs({2,5,6}) do breakPart(o, index) end
        o.phase, o.damageLocked, o.swayState = 1, true, 0
        o.run.bossScrollL = 0
        resetAttack(o)
        bullets.clearFor(o.run, 0x400)
        event(o, 6)
    end

    local function defeat(o, part)
        o.dead, o.hp = true, -1
        score.finishBoss(o.run)
        if part then score.kill(part,0x258) end
        resetAttack(o)
        for _, p in ipairs(o.parts) do p.colli = false end
        breakPart(o, 3)
        breakPart(o, 4)
        aux(o, 10)
        bullets.clearFor(o.run, 0x20)
        event(o, 1)
    end

    -- 0x114d4e 取两个核心盒的最大伤害，炮盖在 0x114e66 同步扣本体血。
    local function applyDamage(o)
        local p = o.parts
        if o.dead then return end
        local phase = o.phase
        if not o.damageLocked then
            if phase == 1 then
                o.hp = o.hp - max(p[1].damagePending, p[7].damagePending)
                if o.hp < 0 then
                    if o.run.pilotH then
                        local hit = p[1].damagePending >= p[7].damagePending and p[1] or p[7]
                        defeat(o,hit)
                        return
                    end
                    o.hp = 0x200
                end
            end
            for index = 2, 6 do
                local part = p[index]
                if part.colli then
                    part.hp = part.hp - part.damagePending
                    if index == 2 then o.hp = o.hp - part.damagePending end
                    if part.hp < 0 then
                        if o.run.pilotH then
                            local points = index == 2 and 0xfa or index < 5 and 0x64 or 0xe6
                            score.kill(part,points)
                            breakPart(o, index)
                            o.kickSpeed, o.kickAngle = unpack(breakKicks[index])
                        else
                            part.hp = 0x200
                        end
                    end
                end
            end
        end
        for _, part in ipairs(p) do part.damagePending = 0 end
        p[1].hp = o.hp
        if phase == 0 and (p[2].broken or o.hp <= 0xd000) then changePhase(o) end
        if o.kickSpeed > 0 then
            local dh, dl = vector(o.kickSpeed, o.kickAngle)
            o.h, o.l, o.kickSpeed = s16(o.h + dh), s16(o.l + dl), o.kickSpeed - 1
        end
        o.timeouts[phase + 1] = o.timeouts[phase + 1] - 1
        if o.timeouts[phase + 1] == 0 then
            if not o.run.pilotH then
                o.timeouts[phase + 1] = 0x78
            elseif phase == 0 and o.phase == 0 then
                changePhase(o)
            elseif phase == 1 then
                defeat(o)
            end
        end
    end

    local function draw(o, id, dh, dl)
        local h, l = program.add(o.h, o.l, dh, dl)
        local image = o.run.art.sprites[id]
        Render(image[1], floor(l / 64) - 112 + image[2] / 2, floor(h / 64) - 224 + image[3] / 2)
    end

    local Boss = Class(object, {
        init = function(o, run)
            o.run, o.h, o.l = run, 0x3800, 0x1c00 - run.cameraOffset
            o.group, o.layer, o.colli, o.bound = GROUP.GHOST, LAYER.ENEMY, false, false
            o.events, o.auxiliary, o.emitters, o.parts, o.children = {}, {}, {}, {}, {}
            o.phase, o.damageLocked, o.timeouts = 0, true, {0x3f48,0x3f48}
            o.swayState, o.swayClock, o.swayTotal, o.kickSpeed = 0, 1, 0, 0
            o.coverDelay, o.coverWaves, o.coverSpeed, o.coverRays, o.coverSpread = 0, 0, 0, 0, 0
            o.edgeDelay, o.edgeShots = 0, 0
            o.sweepStart, o.sweepWaves, o.sweepSpeed, o.sweepRate = 0, 0, 0, 0
            o.innerDelay, o.innerSpeed, o.innerChildDelay, o.innerLocked = 0, 0, 0, {}
            o.coreDelay, o.coreWaves, o.coreSpeed, o.coreRays, o.coreSpread = 0, 0, 0, 0, 0
            o.forwardDelay, o.forwardShots, o.forwardSpeed, o.forwardRays = 0, 0, 0, 0
            o.carrier = {start=0,rate=0,pause=0,waves=0,step=0,drift=0}
            o.coverAngle, o.coreAngle, o.tailAngle = 0x20, 0x20, 0
            o.outerAngle, o.forwardAngle, o.innerAngle = {0,0},{0,0},{0x28,0x18}
            o.engineMode, o.deployment, o.flameFrame, o.hatch, o.frontSlide = 0, 0x60, 1, 1, 32
            for i = 1, #partOffsets do o.parts[i] = New(Part, o, i) end
            o.hp, o.maxhp = o.parts[1].hp, o.parts[1].hp
            updateParts(o)
            event(o, 0)
            run.capacity = run.route.loop == 0 and 150 or 190
        end,
        render = function(o)
            if o.hidden then return end
            for i = 1, 2 do
                local spec = data.hull[i]
                local hatch = (i == 1 and data.hatchLeft or data.hatchRight)[o.hatch]
                if o.hatch > 1 then draw(o, unpack(hatch)) else draw(o, unpack(spec)) end
            end
            for i = 1, 2 do
                local sign = i == 1 and -1 or 1
                if not o.parts[i + 2].broken then
                    draw(o, unpack(data.nacelle[i][floor(o.deployment / 12) + 1][o.flameFrame]))
                    draw(o, data.outer[floor(o.outerAngle[i] / 2) + 1], -0x1f80, sign * 0xac0 - 0x400)
                end
                if not o.parts[i + 4].broken then
                    draw(o, unpack(data.nacelle[i + 2][floor(o.deployment / 12) + 1][o.flameFrame]))
                end
                local images = i == 1 and data.innerLeft or data.innerRight
                draw(o, images[floor(o.forwardAngle[i] / 2) + 1], 0xec0, sign * 0xbc0 - 0x600)
            end
            if not o.parts[2].broken then
                draw(o, data.cover[o.coverAngle - 0x10 + 1], -0x680, -0x800)
            else
                draw(o, unpack(data.hull[3]))
            end
            if o.phase == 1 then
                for side = 1, 2 do
                    draw(o, data.forward[floor(o.innerAngle[side] / 2) + 1], -0x100,
                        (side == 1 and -0x9c0 or 0x9c0) - 0x400)
                end
                draw(o, o.dead and data.tailWreck or data.tail[floor(o.tailAngle / 2) + 1], -0x1d40, -0x600)
                if o.frontSlide == 1 then draw(o, unpack(data.frontAim[o.coreAngle - 0x18 + 1]))
                else draw(o, unpack(data.frontSlide[o.frontSlide])) end
            end
        end,
    })

    function M.spawn(run)
        run.boss2 = New(Boss, run)
        return run.boss2
    end

    function M.step(o)
        local run = o.run
        if run.freeze then return end
        o.l = s16(o.l - run.cameraStep)
        dispatch(o, o.auxiliary, auxiliary, 25)
        dispatch(o, o.events, events, 5)
        local init = o.nextMove ~= nil and (not o.mover or o.nextMove ~= o.mover.id)
        if init then o.mover = {id=o.nextMove} end
        o.nextMove = nil
        if o.mover then movement[o.mover.id][init and 1 or 2](o, o.mover) end
        updateParts(o)
        dispatch(o, o.emitters, emitters, 20)
        stepChildren(o)
        applyDamage(o)
        if o.retire then
            run.stageCleared, run.nextStageNumber = true, 3
            run.bossPresent, run.uraBoss = false, false
            M.close(o)
        end
    end

    function M.close(o)
        o.run.boss2, o.run.bossScrollL = nil, nil
        for _, child in pairs(o.children) do if IsValid(child) then object.RawDel(child) end end
        for _, part in ipairs(o.parts) do if IsValid(part) then object.RawDel(part) end end
        if IsValid(o) then object.RawDel(o) end
    end

    return M
end
