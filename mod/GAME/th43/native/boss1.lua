-- 第一面关底的部件血量、入场与换段事件。事件和部件状态跟随同一个原生对象。
return function(program, bullets, effects, score)
    local floor = math.floor
    local band = require('bit').band
    local s16, world = program.s16, program.world
    local M = {}
    local events = {}

    local function explode(o, index, h, l, mode)
        effects.spawn(o.run, h, l, program.boss1Explosions[index], mode)
    end

    local function destroy(part)
        part.hp, part.broken, part.colli = -1, true, false
    end

    local function damage(part, value)
        local boss = part.host
        if boss.damageLocked or part.broken then return end
        part.damagePending = part.damagePending + value
    end

    local Part = Class(object, {
        init = function(o, boss, id, setup)
            o.run, o.host, o.id, o.hp = boss.run, boss, id, setup[1]
            o.offsetH, o.offsetL = setup[2], setup[3]
            o.front, o.back, o.right, o.left = setup[4], setup[5], setup[6], setup[7]
            o.group, o.layer, o.bound, o.colli = GROUP.ENEMY, LAYER.ENEMY, false, false
            o.broken, o.damagePending, o.damage = false, 0, damage
            o.hitPool = 2
            o.a, o.b, o.rect = (o.right + o.left) / 128, (o.front + o.back) / 128, true
        end,
    })

    local function updateParts(o)
        for index, part in ipairs(o.parts) do
            local h, l = o.h, o.l
            if index == 4 or index == 5 then
                h, l = program.add(h, l, o.wingH, (index == 4 and o.wingL or -o.wingL) % 65536)
            end
            part.h, part.l = program.add(h, l, part.offsetH, part.offsetL)
            part.x, part.y = world(part.h, part.l)
        end
    end

    local function addEvent(boss, id, payload)
        local callbacks = events[id]
        local event = {id=id, payload=payload, callbacks=callbacks}
        for i = 1, 5 do
            if not boss.events[i] then
                boss.events[i] = event
                return event
            end
        end
    end

    local function addEmitter(boss, id, init, step)
        for i = 1, 20 do
            if not boss.emitters[i] then
                local emitter = {id=id, init=init, step=step}
                boss.emitters[i] = emitter
                return emitter
            end
        end
    end

    local function dispatchEmitters(o)
        for i = 1, 20 do
            local emitter = o.emitters[i]
            if emitter then
                if emitter.init then
                    emitter.init(o, emitter)
                    emitter.init = nil
                elseif emitter.step(o, emitter) == false then
                    o.emitters[i] = nil
                end
            end
        end
    end

    local function emitterActive(o, id)
        for _, e in pairs(o.emitters) do if e.id == id then return true end end
        return false
    end

    local function moveToward(o, speed, h, l, stop)
        if program.distance(o.h, o.l, h, l) <= stop then return true end
        local direction = program.angle(o.h, o.l, h, l, o.direction)
        o.direction = program.turnToward(o.direction, direction)
        local dh, dl = program.vector(speed, o.direction * 4)
        o.h, o.l = s16(o.h + dh), s16(o.l + dl)
    end

    local function fanDirection(o, kind, angle)
        local muzzle = program.boss1FanMuzzle[band(angle + 2, 0xfc) / 4 + 1]
        bullets.emitCenterAndWide(o.run, kind, 0, angle, o.h, o.l, s16(muzzle[1] - 0xe00), muzzle[2])
    end

    -- 0x1115f0 / 0x111632 在同一发射槽里交替登记两种主炮扇形。
    local function fanEmitter(o, bursts)
        addEmitter(o, 0, function(boss, e)
            e.timer, e.interval, e.volleys, e.alternate = ({28,20,16,8})[boss.run.difficulty + 1], 0, bursts, false
        end, function(boss, e)
            e.timer = e.timer - 1
            if e.timer >= 0 then return end
            if e.volleys == 0 then return false end
            e.timer = e.interval
            local step, kind = e.alternate and 0x14 or 0x18, e.alternate and 2 or 1
            local function ray(i)
                local base = 0x80 + i * step
                if kind == 1 then
                    fanDirection(boss, kind, base - 1)
                    fanDirection(boss, kind, base + 1)
                else
                    fanDirection(boss, kind, base)
                end
            end
            for i = 0, e.alternate and 4 or 3 do ray(i) end
            for i = 1, e.alternate and 4 or 3 do ray(-i) end
            e.alternate = not e.alternate
            e.volleys = e.volleys - 1
            return e.volleys ~= 0
        end)
    end

    -- 0x1119ea / 0x111a2c。两门炮分别沿相反方向旋转，每次打三个间隔 0x55 的角度。
    local function spiralEmitter(o)
        addEmitter(o, 2, function(_, e)
            e.guns = {{16,16,0,3,0,-1,-0x401,-0x880}, {12,12,0,3,0,1,-0x400,0x880}}
        end, function(boss, e)
            for _, gun in ipairs(e.guns) do
                if gun[3] == 0 then
                    gun[1] = gun[1] - 1
                    if gun[1] < 0 then gun[1], gun[3] = gun[2], 4 end
                end
                if gun[3] > 0 then
                    gun[4] = gun[4] - 1
                    if gun[4] < 0 then
                        gun[4] = 0
                        for i = 0, 2 do
                            local angle = gun[5] + 0x55 * i
                            bullets.emitWidePair(boss.run, 2, 0, angle, boss.h, boss.l, gun[7], gun[8])
                        end
                        gun[3], gun[5] = gun[3] - 1, gun[5] + gun[6]
                        if gun[3] == 0 then gun[5] = gun[5] + gun[6] * 8 end
                    end
                end
            end
        end)
    end

    -- 0x111ac0 / 0x111b46，旋转炮工作时主炮另起四轮追踪射击。
    local function aimedEmitter(o)
        addEmitter(o, 3, function(boss, e)
            local rank = boss.run.difficulty
            e.waves, e.interval, e.speed, e.spread = 4, ({64,48,32,16})[rank + 1], ({0,0,2,4})[rank + 1], 2
            e.clock, e.trail, e.repeatCount = e.interval, 3, boss.aimedBurst or 0
            boss.aimedBurst = math.min(8, e.repeatCount + 2)
        end, function(boss, e)
            local run = boss.run
            if e.remaining == nil or e.remaining == 0 then
                e.clock = e.clock - 1
                if e.clock >= 0 then return end
                e.remaining = e.repeatCount == 0 and 0x100 or e.repeatCount
                e.repeatCount, e.clock = math.min(24, e.repeatCount * 2), 0
                if run.pilotH then
                    e.angle = program.aimByte(boss.h, boss.l, run.pilotH, run.pilotL, e.angle or 0)
                end
            end
            e.trail = e.trail - 1
            if e.trail >= 0 then return end
            e.trail = 0
            local angle = e.angle or 0
            if run.pilotH then
                local target = program.aimByte(boss.h, boss.l, run.pilotH, run.pilotL, angle)
                local delta = band(target - angle + 128, 0xff) - 128
                angle = band(angle + math.max(-2, math.min(2, delta)), 0xff)
                e.angle = angle
            end
            bullets.emitAngle(run, 0xc, e.speed, angle, boss.h, boss.l, -0x600, 0)
            bullets.emitWidePair(run, 0xc, e.speed, angle + e.spread, boss.h, boss.l, -0x600, 0)
            bullets.emitWidePair(run, 0xc, e.speed, angle - e.spread, boss.h, boss.l, -0x600, 0)
            local boost = run.route.loop == 1 and 4 or 0
            bullets.emitAngle(run, 9, e.speed + 10 + boost, angle + 0x28, boss.h, boss.l, -0x600, 0)
            bullets.emitAngle(run, 9, e.speed + 10 + boost, angle - 0x28, boss.h, boss.l, -0x600, 0)
            e.remaining = e.remaining - 1
            if e.remaining == 0 then
                e.waves, e.spread, e.speed = e.waves - 1, math.min(6, e.spread + 1), math.min(16, e.speed + 2)
                return e.waves ~= 0
            end
        end)
    end

    local function stopEmitter(o, id)
        for i, emitter in pairs(o.emitters) do
            if emitter.id == id then o.emitters[i] = nil end
        end
    end

    local function childDamage(o, value, source)
        if not o.colli then return end
        o.hp = o.hp - value
        if o.hp < 0 then o.hitSource = source end
    end

    -- 0x11112e 的子机先减速转向，再按自己的两个发弹计数运行。
    local Child = Class(object, {
        init = function(p, o, kind, h, l, speed, direction, muzzle, turn, burstIndex)
            p.run, p.kind, p.h, p.l = o.run, kind, h, l
            p.group, p.layer, p.bound, p.colli = GROUP.ENEMY, LAYER.ENEMY, false, true
            p.hitPool, p.hp, p.damage = 1, kind == 0x73 and 0x80 or muzzle <= 4 and 0x500 or 0x600, childDamage
            p.front, p.back = 0x480, 0x480
            p.right, p.left = kind == 0x73 and 0x180 or 0x300, kind == 0x73 and 0x180 or 0x300
            p.direction, p.speed = direction, speed
            p.muzzle, p.turn, p.burstIndex = muzzle, turn, burstIndex
            p.braking, p.hSpeed, p.lSpeed = true, 0, 0
            p.dropTime, p.maxDropSpeed = muzzle <= 4 and 0x20 or 0x48, muzzle <= 4 and 0x20 or 0x68
            p.sideClock, p.speedClock, p.angleClock, p.shotClock = 1, 0, 2, 4
            p.repeatDelay, p.shots, p.fired = ({0x44,0x38,0x28,0x18})[o.run.difficulty + 1], 0, true
            p.x, p.y = world(h, l)
        end,
        render = function(p)
            local image = p.run.art.sprites[program.boss1ChildArt[band(p.direction, 0x3e) / 2 + 1]]
            Render(image[1], floor((p.l - 0x200) / 64) - 112 + image[2] / 2,
                floor((p.h - 0x400) / 64) - 224 + image[3] / 2)
        end,
    })

    local function stepChild(p)
        local run = p.run
        if p.hp < 0 then
            if p.kind == 0x73 then
                effects.spawn(run, p.h, p.l, {{0,0x82,0,0,0,0,p.direction*4}}, false)
                return true
            elseif not p.destroyed then
                p.destroyed, p.colli = true, false
            end
            p.burstIndex = p.burstIndex - 1
            if p.burstIndex >= 0 then return end
            effects.spawn(run, p.h, p.l, {{0,6,0,0,0,math.min(p.speed,4)*8,p.direction*4}}, false)
            if p.hitSource and run.pilotH and (p.muzzle >= 8 or not p.fired) then
                local angle = program.angle(p.h, p.l, run.pilotH, run.pilotL, p.direction)
                bullets.emitAcceleration(run, 0x12, -20, angle * 4, p.h, p.l,
                    {run.difficulty == 3 and 0 or 1,1,1,0x7f}, true)
            end
            return true
        end
        p.l = s16(p.l - run.cameraStep)
        if p.kind == 0x72 then
            if p.dropTime > 0 then
                p.hSpeed = math.min(p.hSpeed + 1, p.maxDropSpeed)
                p.dropTime = p.dropTime - 1
            elseif p.hSpeed > 0 then
                p.hSpeed = p.hSpeed - 1
            else
                p.sideClock = p.sideClock - 1
                if p.sideClock < 0 then
                    p.sideClock = 1
                    p.lSpeed = p.lSpeed + (p.muzzle % 8 == 0 and 1 or -1)
                end
                p.l = s16(p.l + p.lSpeed)
            end
            p.h = s16(p.h - p.hSpeed)
            if p.braking then
                p.direction = band(p.direction + p.turn, 0x3f)
                p.speed = p.speed - 1
                if p.speed <= 4 then
                    p.braking, p.speed, p.shotClock = false, 4, 4
                    p.angleClock = 2
                end
            else
                p.shotClock = p.shotClock - 1
                if p.shotClock < 0 then
                    local modifier = run.difficulty == 3 and 4 or p.muzzle >= 8 and 0 or -1
                    bullets.emit(run, 9, modifier, p.direction, p.h, p.l)
                    p.fired, p.shots, p.shotClock = run.difficulty ~= 3, p.shots + 1, 3
                    if p.shots == 2 then
                        p.shots, p.shotClock = 0, p.repeatDelay
                        p.repeatDelay = math.max(0x14, p.repeatDelay - 2)
                    end
                end
                if p.shots == 0 then
                    p.angleClock = p.angleClock - 1
                    if p.angleClock < 0 then
                        p.angleClock, p.direction = 2, band(p.direction + p.turn, 0x3f)
                    end
                end
            end
        end
        local dh, dl = program.vector(p.speed, p.direction * 4)
        p.h, p.l = s16(p.h + dh), s16(p.l + dl)
        p.x, p.y = world(p.h, p.l)
        return band(p.h + 0x800, 0xffff) >= 0x8000
            or band(p.l + 0x1c00 + run.cameraOffset, 0xffff) >= 0x7000
    end

    local formation = program.boss1Formation

    local function formationAim(p, h, l, angle)
        if p.run.pilotH then return program.aimByte(h, l, p.run.pilotH, p.run.pilotL, angle) end
        return angle
    end

    local function formationTrack(p, h, l, divisor)
        p.angle = program.aimByte(p.h, p.l, h, l, p.angle)
        local distance = program.distance(p.h, p.l, h, l)
        p.speed = 0x40
        for _, r in ipairs(formation.speed) do
            if distance <= r[1] then p.speed = r[2]; break end
        end
        p.speed = floor(p.speed / divisor)
        return distance
    end

    local function formationState(p, mode)
        p.mode, p.clock, p.modeFrame = mode, 0, 0
    end

    -- 0x1101c6 将姿态和发射分别绑在 0x71 子机上，关底事件只给出队形与开炮信号。
    local function stepFormation(p)
        local o, run = p.host, p.run
        if p.hp < 0 or o.phase == 2 then
            effects.spawn(run, p.h, p.l, {{0,0x88,0,0,0,p.speed,p.angle}}, false, true)
            return true
        end
        p.l = s16(p.l - run.cameraStep)
        local mode, group = p.mode, o.formation
        if mode == 0 then
            if p.modeFrame == 0 then
                local r = formation.spread[p.index]
                p.speed, p.angle = r[1] + program.random(run, program.effectRandom),
                    r[2] + 2 * program.random(run, program.effectRandom)
                local sign = program.random(run, program.randomParity) % 2
                p.turn, p.clock = sign == 0 and -1 or 2, 0x40
            end
            p.speed, p.gun, p.clock = math.max(2, p.speed - 1), band(p.gun + p.turn, 0x3f), p.clock - 1
            if p.clock == 0 then
                p.colli = true
                formationState(p, group.mode)
            end
        elseif mode == 8 or mode == 0x14 or mode == 0x1c or mode == 0x0c then
            local place = group.positions[p.index]
            if mode == 0x1c then
                p.gun = program.turnToward(p.gun, band(floor(group.aim / 4), 0x3f))
                local muzzle = formation.muzzle[band(p.gun, 0x3e) / 2 + 1]
                local depth = 0x10 - floor(place.depth / 0x100)
                if group.fire == 1 then
                    for offset = 0, group.returning and 3 or 2 do
                        bullets.emitLongPair(run, 9, floor(depth / 4) - 6, group.aim + offset,
                            p.h, p.l, muzzle[1], muzzle[2])
                    end
                elseif group.fire == 2 then
                    local modifier = floor(depth / 8) - 8
                    bullets.emitCenterAndWide(run, 9, modifier, group.aim, p.h, p.l, muzzle[1], muzzle[2])
                end
            else
                p.gun = program.turnToward(p.gun, floor(formationAim(p, p.h, p.l, p.gun * 4) / 4))
            end
            formationTrack(p, place.h, place.l, 1)
            if mode ~= group.mode then formationState(p, group.mode) end
        elseif mode == 4 or mode == 0x10 or mode == 0x18 then
            if p.modeFrame == 0 or not p.targetH then
                local r = formation.idle[p.index]
                if p.modeFrame == 0 and mode ~= 4 then
                    p.bursts, p.burstClock = 3, 0
                    p.patternTurn = program.random(run, program.randomParity) % 2 == 0 and -0x40 or 0x40
                    p.patternAngle = band(formationAim(p, p.h, p.l, 0x80)
                        + 4 * program.random(run, program.effectRandom), 0xff)
                end
                p.targetH = s16(group.originH + r[1] + program.random(run, program.mid4.destination)[1])
                p.targetL = s16(group.originL + r[2] + program.random(run, program.mid4.destination)[1])
            end
            local distance = formationTrack(p, p.targetH, s16(p.targetL - run.cameraOffset), mode == 4 and 4 or 2)
            p.gun = program.turnToward(p.gun, floor(formationAim(p, p.h, p.l, p.gun * 4) / 4))
            if distance <= 0x200 or p.speed == 0 then p.targetH = nil end
            if mode ~= 4 and p.bursts > 0 then
                p.burstClock = p.burstClock - 1
                if p.burstClock < 0 then
                    local angle = formationAim(p, p.h, p.l, p.patternAngle)
                    angle = band(angle + program.random(run, program.effectRandom), 0xff)
                    local offset = formation.muzzle[band(p.gun, 0x3e) / 2 + 1]
                    bullets.emitSpread(run, 0x0f, -20, angle, p.h, p.l, offset[1], offset[2], {0,1,1,0x7f})
                    bullets.emitCenterAndWide(run, 0x0f, -19, angle, p.h, p.l, offset[1], offset[2], {0,1,1,0x7f})
                    p.bursts, p.burstClock = p.bursts - 1, 8
                    p.patternAngle = band(p.patternAngle + p.patternTurn, 0xff)
                end
            end
            if mode ~= group.mode then formationState(p, group.mode) end
        elseif mode == 0x20 then
            if p.modeFrame == 0 then
                p.angle = formationAim(p, p.h, p.l, p.angle)
                p.fireAngle = p.angle
                p.angle = band(p.angle + program.random(run, program.effectRandom), 0xff)
                p.speed, p.clock = 0, formation.driftDelay[p.index] + 1
                p.accelerateClock, p.fireClock, p.shots = 0, 4, 0x10
            end
            p.clock = math.max(0, p.clock - 1)
            if p.clock == 0 then
                if p.accelerateClock == 0 then p.speed = math.min(0x20, p.speed + 1) end
                p.accelerateClock = 1 - p.accelerateClock
                if p.shots > 0 then
                    p.fireClock = p.fireClock - 1
                    if p.fireClock < 0 then
                        local modifier = run.route.loop == 0 and -20 or -8
                        bullets.emitAcceleration(run, 0x12, modifier, p.fireAngle, p.h, p.l, {1,2,1,0x7f}, false)
                        p.fireAngle, p.fireClock, p.shots = p.fireAngle + formation.driftTurn[p.index], 2, p.shots - 1
                    end
                end
            end
        end
        local dh, dl = program.vector(p.speed, p.angle)
        p.h, p.l = s16(p.h + dh), s16(p.l + dl)
        p.x, p.y = world(p.h, p.l)
        p.image = p.image % 8 + 1
        if mode == p.mode then p.modeFrame = p.modeFrame + 1 end
        if mode == 0x20 then
            local visible = band(p.h + 0x800, 0xffff) < 0x8000
                and band(p.l + 0x1c00 + run.cameraOffset, 0xffff) < 0x7000
            if p.entered and not visible then return true end
            p.entered = p.entered or visible
        end
    end

    local FormationChild = Class(object, {
        init = function(p, o, index)
            p.host, p.run, p.kind, p.index = o, o.run, 0x71, index
            p.h, p.l, p.speed, p.angle, p.gun = o.h, o.l, 0, 0, 0
            p.group, p.layer, p.bound, p.colli = GROUP.ENEMY, LAYER.ENEMY, false, false
            p.front, p.back, p.right, p.left = 0x380, 0x380, 0x200, 0x200
            p.hitPool, p.hp, p.damage, p.step = 1, 0x2000, childDamage, stepFormation
            local phase = program.random(p.run, program.randomParity) % 4
            p.image = phase == 3 and 1 or phase + 1
            p.x, p.y = world(p.h, p.l)
            formationState(p, 0)
        end,
        render = function(p)
            local id = formation.art[band(p.gun, 0x3e) / 2 + 1][p.image]
            local image = p.run.art.sprites[id]
            Render(image[1], floor((p.l - 0x600) / 64) - 112 + image[2] / 2,
                floor((p.h - 0x800) / 64) - 224 + image[3] / 2)
        end,
    })

    local function spawnFormation(o)
        for index = 1, 8 do
            for slot = 1, 48 do
                if not o.pods[slot] then o.pods[slot] = New(FormationChild, o, index); break end
            end
        end
    end

    local function hasFormation(o)
        for _, p in pairs(o.pods) do
            if p.kind == 0x71 and p.mode ~= 0x20 then return true end
        end
        return false
    end

    local function spawnChild(o, kind, h, l, speed, direction, muzzle, turn, burstIndex)
        for slot = 1, 48 do
            if not o.pods[slot] then
                o.pods[slot] = New(Child, o, kind, h, l, speed, direction, muzzle, turn, burstIndex)
                return
            end
        end
    end

    local function stepChildren(o)
        for slot = 1, 48 do
            local p = o.pods[slot]
            if p then
                if o.phase > 0 and p.kind ~= 0x71 then
                    p.hp, p.colli = -1, false
                    p.fired = true
                end
                if (p.step or stepChild)(p) then
                    o.pods[slot] = nil
                    object.RawDel(p)
                end
            end
        end
    end

    -- 0x11238c 和 0x11277e 选择仍可用的炮口，登记 0x72 / 0x73 子机。
    local function childEmitter(o, id)
        addEmitter(o, id, function(boss, e)
            e.clock, e.index = 12, 1
            if id == 11 then return end
            local broken = 0
            for index = 4, 7 do if boss.parts[index].broken then broken = broken + 1 end end
            local row = program.boss1ChildWaves[broken + 1]
            if not row then e.remaining = 0; return end
            e.clock, e.interval, e.count, e.spread, e.speed = row[1] - 1, row[2], row[3] + 1, row[4], row[5]
            e.remaining = 2
            e.turn = program.random(boss.run, program.effectRandom) < 0x80 and 1 or -1
        end, function(boss, e)
            if e.remaining == 0 then return false end
            if boss.run.suppressShots then return end
            e.clock = e.clock - 1
            if e.clock >= 0 then return end
            e.clock = e.interval or 0
            local record = program.boss1ChildMuzzle[e.index]
            local part = boss.parts[record[1] / 0x2a]
            if not part.broken and (id == 11 or e.index <= 2 or boss.parts[e.index + 1].broken) then
                local h, l = s16(part.h - 0x500), s16(part.l + record[2])
                if id == 8 then
                    program.random(boss.run, program.randomParity)
                    for i = 0, e.count - 1 do
                        spawnChild(boss, 0x72, h, l, e.speed, 0x20 + i * e.spread, (e.index - 1) * 4, e.turn, i)
                    end
                    e.remaining = e.remaining - 1
                else
                    for i = 0, 2 do spawnChild(boss, 0x73, h, l + i * 0x280, 0x1c, 0x20, 0, 0, 0) end
                end
            end
            e.index = e.index % 4 + 1
            if id == 8 then
                e.turn = -e.turn
                return e.remaining ~= 0
            end
        end)
    end

    -- 0x11218e / 0x1121fa。两外炮各有发射计数器，坏掉的炮口不再射击。
    local function wingEmitter(boss)
        addEmitter(boss, 7, function(o, e)
            local ranks = {{12,28,-4}, {10,22,-4}, {8,20,0}, {4,16,4}}
            local rank = ranks[o.run.difficulty + 1]
            e.timers, e.intervals, e.steps = {rank[1],rank[2]}, {rank[2],rank[2]}, {0,0}
            e.speed = rank[3]
        end, function(o, e)
            if o.run.suppressShots then return end
            for i = 1, 2 do
                local p = o.parts[i + 3]
                if not p.broken then
                    e.timers[i] = e.timers[i] - 1
                    if e.timers[i] < 0 then
                        e.timers[i] = e.intervals[i]
                        local step = e.steps[i]
                        e.steps[i] = 1 - step
                        local muzzle = program.boss1Muzzle[(i - 1) * 2 + step + 1]
                        local angle = 0x80 + floor((i == 1 and -o.wingAngle or o.wingAngle) / (2 + step * 2))
                        for delta = -2, 2, 2 do
                            bullets.emitSpread(o.run, 2, e.speed, angle + delta, p.h, p.l, muzzle[1], muzzle[2])
                        end
                    end
                end
            end
        end)
    end

    -- 0x111dfe 发射槽跨越两次翼部开合，单独根据外炮击破数提高正面连射的路数。
    local function foreEmitter(o)
        addEmitter(o, 6, function(boss, e)
            local rank = boss.run.difficulty
            e.clock, e.interval, e.trail, e.waves = ({32,32,24,12})[rank + 1], 0, 0, 3
            e.gap, e.rate = rank >= 2 and 4 or (boss.foreGap or 0), 0x30
            e.speed = ({0,0,4,8})[rank + 1]
            boss.foreGap = math.max(4, (boss.foreGap or 0) - 2)
        end, function(boss, e)
            e.rate = e.rate - 1
            if e.rate < 0 then e.rate, e.interval = 0x30, math.max(4, e.interval - 1) end
            if e.remaining == nil or e.remaining == 0 then
                e.clock = e.clock - 1
                if e.clock >= 0 then return end
                e.clock, e.remaining = e.interval, e.waves
            end
            e.trail = e.trail - 1
            if e.trail >= 0 then return end
            local run = boss.run
            local broken = (boss.parts[4].broken and 1 or 0) + (boss.parts[5].broken and 1 or 0)
            local h, l = program.add(boss.h, boss.l, -0x380, 0)
            local direction = run.pilotH and program.angle(h, l, run.pilotH, run.pilotL) or 0x20
            local muzzle = program.boss1RearMuzzle[band(direction, 0x3e) / 2 + 1]
            local angle = direction * 4
            for offset = -1, 1, 2 do
                bullets.emitCenterAndWide(run, 9, e.speed, angle + offset, h, l, muzzle[1], muzzle[2])
            end
            if broken > 0 then
                local step = broken == 1 and 0x20 or 0x1c
                for i = 1, broken do
                    bullets.emitWidePair(run, 9, e.speed, angle - step * i, h, l, muzzle[1], muzzle[2])
                end
                for i = 1, broken do
                    bullets.emitWidePair(run, 9, e.speed, angle + step * i, h, l, muzzle[1], muzzle[2])
                end
            end
            e.remaining, e.trail = e.remaining - 1, e.gap
        end)
    end

    -- 0x10e1c6 / 0x10e1d8 先登记入场，再激活部件判定。
    events[0] = {
        init = function(boss)
            boss.enterFrames, boss.speed, boss.direction = 0x140, 0, 0x3e
            boss.rotor, boss.rotorTimer, boss.accelerator = 0, 1, 4
            boss.entryRotorTimer = 1
            boss.run.bossPresent = true
        end,
        step = function() return false end,
    }

    local function enter(o)
        if not o.enterFrames or o.ready or o.run.freeze then return end
        if o.enterFrames >= 0 then
            o.enterFrames = o.enterFrames - 1
            o.h = s16(o.h - o.run.scrollStep * 64)
            o.entryRotorTimer = o.entryRotorTimer - 1
            if o.entryRotorTimer < 0 then
                o.entryRotorTimer = 1
                o.rotor = (o.rotor + 0x10) % 0x80
            end
        end
        if o.enterFrames < 0 then
            o.rotorTimer = o.rotorTimer - 1
            if o.rotorTimer < 0 then
                o.rotorTimer = 1
                o.accelerator = o.accelerator - 1
                if o.accelerator < 0 then
                    o.accelerator = 4
                    o.speed = (o.speed + 1) % 256
                end
                o.rotor = o.rotor + 0x10
                if o.rotor == 0x280 then
                    o.ready, o.damageLocked = true, false
                    o.run.bossAttack, o.run.uraBoss = true, true
                    addEvent(o, 7)
                end
            end
        end
        local dh, dl = program.vector(o.speed, o.direction * 4)
        o.h, o.l = s16(o.h + dh), s16(o.l + dl)
    end

    -- 0x10e1ee / 0x10e212。换段的等待取决于登记事件时的四个破坏标志。
    events[1] = {
        init = function(boss, e)
            local count = 0
            for _, broken in ipairs(e.payload) do if broken then count = count + 1 end end
            e.delay = ({32,24,24,24,0})[count + 1]
        end,
        step = function(boss, e)
            e.delay = e.delay - 1
            if not e.shock and e.delay < 0 then
                e.shock, e.delay = true, 31
                explode(boss, 7, boss.h, boss.l)
                if boss.run.onBossShock then boss.run.onBossShock(boss) end
            elseif e.shock and e.delay == 0 then
                boss.damageLocked = false
                addEvent(boss, 3)
                return false
            end
            return true
        end,
    }

    -- 0x10e2c8 / 0x10e30c。击破后先逐批解体，再等关底击破字样退场。
    local defeatOffsets = {{0x0c00,-0xa00}, {0,0xa00}, {-0x1000,0}}
    events[2] = {
        init = function(o, e)
            e.state, e.bursts, e.burstClock = 0, 10, 0x20
        end,
        step = function(o, e)
            -- 原程序倒序判断阶段，切换后由下一帧进入新阶段。
            if e.state == 4 then
                e.delay = e.delay - 1
                if e.delay == 0 then o.retire = true end
                return e.delay ~= 0
            end
            if e.state == 3 then
                e.delay = e.delay - 1
                if e.delay == 0 then
                    o.h = s16(o.h + 0xc00)
                    o.showWreck = false
                    e.state, e.delay = 4, 0x80
                end
            elseif e.state == 2 then
                if not e.banner then e.state, e.delay = 3, 8 end
            elseif e.state == 1 then
                if e.delay ~= 0 then e.delay = e.delay - 1 end
                if e.delay == 0 then
                    e.burstClock = e.burstClock - 1
                    if e.burstClock < 0 then
                        local offset = defeatOffsets[(10 - e.bursts) % 3 + 1]
                        local h, l = program.add(o.h, o.l, offset[1], offset[2])
                        explode(o, 9, h, l)
                        e.burstClock, e.bursts = 0x10, e.bursts - 1
                        if e.bursts == 0 then
                            e.state, e.banner, e.bannerHeight = 2, 1, 0x1c00
                        end
                    end
                end
            else
                explode(o, 8, o.h, o.l)
                e.state, e.delay = 1, 0x10
            end
            -- 0xc1da2 在关底事件循环后更新字样状态，首次越过屏幕上缘后再保留一帧。
            if e.banner == 1 then
                e.bannerHeight = e.bannerHeight - 0x400
                if e.bannerHeight < 0 then e.banner = 2 end
            elseif e.banner == 2 then
                e.banner = nil
            end
            return true
        end,
    }

    -- 0x10eb32 先把机身移到正面，再切换到关底后段的下一事件。
    events[3] = {
        init = function(o, e)
            e.targetL = 0x1c00 - o.run.cameraOffset
            o.scrollRecovery = 0
            o.formation = {mode=4, originH=o.h, originL=s16(o.l + o.run.cameraOffset)}
            for _, p in pairs(o.pods) do
                if p.kind == 0x71 and p.mode ~= 0x20 then formationState(p, 4) end
            end
        end,
        step = function(o, e)
            o.scrollRecovery = math.min(0x200, o.scrollRecovery + 0x20)
            if moveToward(o, 3, 0x6400, e.targetL, 0x100) then
                if not hasFormation(o) then spawnFormation(o) end
                addEvent(o, 5)
                return false
            end
            return true
        end,
    }

    local function rotateFormation(h, l, depth, spin, roll, tilt)
        local r = formation.rotation[band(spin, 0xff) + 1]
        h, l = floor((h * r[2] - l * r[1]) / 64), floor((l * r[2] + h * r[1]) / 64)
        r = formation.rotation[band(roll, 0xff) + 1]
        l, depth = floor((l * r[2] - depth * r[1]) / 64), floor((l * r[1] + depth * r[2]) / 64)
        r = formation.rotation[band(tilt, 0xff) + 1]
        h, depth = floor((h * r[2] + depth * r[1]) / 64), floor((depth * r[2] - h * r[1]) / 64)
        return h, l, depth
    end

    -- 0x10ebea / 0x10ecc0 先转动八处队形锚点，再给 0x71 各自的发弹回调发信号。
    events[4] = {
        init = function(o, e)
            local run = o.run
            local side = program.random(run, program.randomParity) % 2
            e.phase, e.wait, e.spin = 0, 0x60, 0
            e.firstL, e.secondL = side == 0 and 0xa00 or 0x2e00, side == 0 and 0x2e00 or 0xa00
            e.sweepH = o.formationSweepH or 0x5000
            o.formation = {mode=8, originH=o.h, originL=s16(o.l + run.cameraOffset), positions={}, fire=0,
                aim=run.pilotH and program.aimByte(o.h, o.l, run.pilotH, run.pilotL, 0x80) or 0x80}
            for i = 1, 8 do o.formation.positions[i] = {h=o.h,l=o.l,depth=0} end
        end,
        step = function(o, e)
            local group, run = o.formation, o.run
            local tilt = e.phase < 2 and -group.aim or e.tilt
            for i, r in ipairs(group.positions) do
                local base = formation.rotation[(i - 1) * 0x20 + 1]
                local h, l, depth = rotateFormation(base[1] * 0x5f, base[2] * 0x5f, 0, e.spin, tilt, 0x18)
                r.h, r.l, r.depth = s16(o.h + h), s16(o.l + l), s16(depth)
            end
            e.spin = band(e.spin + 1, 0xff)
            if e.phase == 0 then
                if run.pilotH then group.aim = program.aimByte(o.h, o.l, run.pilotH, run.pilotL, group.aim) end
                if moveToward(o, 3, 0x5000, e.firstL - run.cameraOffset, 0x200) then
                    e.phase, group.mode = 1, 0x14
                end
            end
            if e.phase == 1 then
                if run.pilotH then group.aim = program.aimByte(o.h, o.l, run.pilotH, run.pilotL, group.aim) end
                e.wait = e.wait - 1
                if e.wait == 0 then
                    e.phase, e.wait, e.tilt, group.mode = 2, 0x40, -group.aim, 0x1c
                    local useSlow = not o.formationAlternate
                    o.formationAlternate = not o.formationAlternate
                    local reset = useSlow and (o.formationReload or 0x38)
                        or ({0x30,0x20,0x18,0x14})[run.difficulty + 1]
                    if useSlow then
                        if run.difficulty == 3 then reset = 0x10 end
                        o.formationReload = math.max(0x18, (o.formationReload or 0x38)
                            - (run.difficulty == 2 and 5 or run.difficulty == 0 and 0 or 1))
                    end
                    local slot = addEmitter(o, useSlow and 5 or 4, function(_, emitter)
                        emitter.delay, emitter.burst, emitter.active = 0x10, 1, 1
                    end, function(boss, emitter)
                        local formationGroup = boss.formation
                        formationGroup.fire = 0
                        if run.suppressShots then return end
                        if emitter.active == 0 then
                            local aim = run.pilotH and program.aimByte(boss.h, boss.l, run.pilotH, run.pilotL, 0x80) or 0x80
                            formationGroup.aim, emitter.parent.tilt = aim, -aim
                            emitter.delay = emitter.delay - 1
                            if emitter.delay >= 0 then return end
                            emitter.delay = band(reset + program.random(run, program.effectRandom), 0xff)
                            emitter.active = 1
                        end
                        emitter.burst = emitter.burst - 1
                        if emitter.burst < 0 then
                            emitter.burst, emitter.active, formationGroup.fire = 1, emitter.active - 1, useSlow and 2 or 1
                        end
                    end)
                    slot.parent = e
                end
            end
            if e.phase == 2 or e.phase == 3 then
                if e.phase == 2 or e.arrived then e.wait = e.wait - 1 end
                if e.wait == 0 then
                    if e.phase == 2 then
                        e.phase, e.wait = 3, 0x40
                        o.formationSweepH = math.max(0x3200, e.sweepH - 0x600)
                        return true
                    end
                    group.originH, group.originL = o.h, s16(o.l + run.cameraOffset)
                    group.mode, group.returning, group.fire = 8, true, 0
                    stopEmitter(o, 4)
                    stopEmitter(o, 5)
                    e.phase = 4
                    return true
                end
                if e.phase == 3 and not e.arrived then
                    e.arrived = moveToward(o, 2, e.sweepH, e.secondL, 0x200)
                end
            elseif e.phase == 4 and moveToward(o, 3, 0x6400, 0x1c00 - run.cameraOffset, 0x200) then
                group.mode = 0x0c
                addEvent(o, 5)
                return false
            end
            return true
        end,
    }

    -- 0x10ee76 的三轮扇形等待同一发射槽空出，然后才登记下一轮。
    events[5] = {
        init = function(o, e)
            e.waves, e.delay, e.bursts = 3, 0x80, o.fanBursts
            o.fanBursts = math.min(4, e.bursts + 1)
        end,
        step = function(o, e)
            if emitterActive(o, 0) then return true end
            if e.waves == 0 then
                local nextEvent
                repeat
                    nextEvent = program.random(o.run, program.randomParity) % 2 == 0 and 6 or 4
                until nextEvent ~= o.lastSecondAttack
                o.lastSecondAttack, o.formation.mode = nextEvent, 0x10
                addEvent(o, nextEvent)
                return false
            end
            e.delay = e.delay - 1
            if e.delay < 0 then
                fanEmitter(o, e.bursts)
                e.bursts = math.min(4, e.bursts + 1)
                e.bursts, e.waves, e.delay = math.min(4, e.bursts + 1), e.waves - 1, 0x40
            end
            return true
        end,
    }

    -- 0x10efa0 读取自机横坐标定位，连续攻击期间单独保留旋转炮槽。
    events[6] = {
        init = function(o, e)
            e.targetL, e.delay, e.state = o.run.pilotL or 0x1c00, 0x20, 0
        end,
        step = function(o, e)
            if e.state == 3 then
                if emitterActive(o, 3) then return true end
                stopEmitter(o, 2)
                addEvent(o, 3)
                return false
            end
            if e.state == 0 and not moveToward(o, 3, 0x5000, e.targetL, 0x100) then return true end
            e.delay = e.delay - 1
            if e.delay ~= 0 then return true end
            if e.state == 0 then
                o.formation.mode = 0x20
                e.state, e.delay = 1, 0x50
            elseif e.state == 1 then
                spiralEmitter(o)
                e.state, e.delay = 2, 0x50
            elseif e.state == 2 then
                aimedEmitter(o)
                e.state = 3
            end
            return true
        end,
    }

    events[7] = {
        init = function(o, e)
            e.delay, e.wingFrames, e.state = 0x40, 0x37, 0
            e.cycles = 2
            if o.parts[4].broken and o.parts[5].broken then e.cycles = 1 end
        end,
        step = function(o, e)
            if e.state == 0 then
                e.delay = e.delay - 1
                if e.delay ~= 0 then return true end
                wingEmitter(o)
                foreEmitter(o)
                childEmitter(o, 11)
                e.state = 1
            end
            local sign = e.state == 1 and 1 or -1
            o.wingH = o.wingH + sign * 0x12
            o.wingL = o.wingL + sign * 0x22
            o.wingAngle = o.wingAngle + sign
            e.wingFrames = e.wingFrames - 1
            if e.wingFrames == 0 then
                e.wingFrames = 0x37
                if e.state == 1 then
                    e.state = 2
                else
                    e.cycles = e.cycles - 1
                    if e.cycles == 0 then
                        stopEmitter(o, 7)
                        stopEmitter(o, 6)
                        stopEmitter(o, 11)
                        addEvent(o, 8)
                        return false
                    end
                    e.state = 1
                end
            end
            return true
        end,
    }

    -- 0x112826 的后炮先打一发中央弹，再从内向外成对发弹。
    local function rearEmitter(o)
        return addEmitter(o, 12, function(boss, e)
            e.clock, e.interval, e.trail, e.rays = 0x60, boss.rearInterval or 0x40, 0, 1
            e.speed, e.repeatCount, e.remaining = boss.rearSpeed or 0, 0, 1
            boss.rearInterval = math.max(0x20, e.interval - 4)
            boss.rearSpeed = math.min(8, e.speed + 3)
        end, function(boss, e)
            if e.remaining == 0 then
                e.clock = e.clock - 1
                if e.clock >= 0 then return end
                e.clock, e.interval = e.interval, math.max(0x10, e.interval - 4)
                e.remaining = e.repeatCount
                e.repeatCount = math.min(2, e.repeatCount + 1)
            end
            e.trail = e.trail - 1
            if e.trail >= 0 then return end
            e.trail = 4
            local run = boss.run
            local h, l = program.add(boss.h, boss.l, -0xb80, 0)
            local direction = run.pilotH and program.angle(h, l, run.pilotH, run.pilotL) or 0x20
            local muzzle = program.boss1RearMuzzle[band(direction, 0x3e) / 2 + 1]
            local angle = direction * 4
            bullets.emitAngle(run, 8, e.speed, angle, h, l, muzzle[1], muzzle[2])
            if run.route.loop == 1 then
                bullets.emitAngle(run, 8, e.speed, angle - 4, h, l, muzzle[1], muzzle[2])
                bullets.emitAngle(run, 8, e.speed, angle + 4, h, l, muzzle[1], muzzle[2])
            end
            for i = 0, e.rays do
                local spread = 0xe * 2 ^ i
                bullets.emitSpread(run, 8, e.speed, angle - spread, h, l, muzzle[1], muzzle[2])
                bullets.emitSpread(run, 8, e.speed, angle + spread, h, l, muzzle[1], muzzle[2])
            end
            e.remaining = band(e.remaining - 1, 0xff)
            if e.remaining == 0 then
                e.speed = e.speed + 1
                return not e.stopAfterWave
            end
        end)
    end

    -- 0x10e950 和 0x10ea94 驱动前半段的两个回环，后炮的停机由发射槽自行完成。
    events[8] = {
        init = function(o, e)
            e.delay, e.burstDelay, e.state = 0x20, 0xe0, 0
        end,
        step = function(o, e)
            if e.state == 0 then
                e.delay = e.delay - 1
                if e.delay == 0 then
                    e.rear, e.state = rearEmitter(o), 1
                    e.hatchClock = 15
                end
            end
            if e.state == 1 then
                e.hatchClock = e.hatchClock - 1
                if e.hatchClock == 0 then
                    childEmitter(o, 8)
                    e.state = 2
                end
            end
            if e.state == 2 and not emitterActive(o, 8) then
                e.burstDelay = e.burstDelay - 1
                if e.burstDelay <= 0x20 and e.rear then e.rear.stopAfterWave = true end
                if e.burstDelay <= 0 and not emitterActive(o, 12) then
                    addEvent(o, 9)
                    return false
                end
            end
            moveToward(o, 3, 0x5000, 0x1c00 - o.run.cameraOffset, 0x100)
            return true
        end,
    }

    events[9] = {
        init = function(o) stopEmitter(o, 7); stopEmitter(o, 13) end,
        step = function(o)
            if o.h > 0x5600 then addEvent(o, 7); return false end
            moveToward(o, 3, 0x5a00, 0x1c00 - o.run.cameraOffset, 0x100)
            return true
        end,
    }

    local function dispatch(o)
        for slot = 1, 5 do
            local e = o.events[slot]
            if e then
                if not e.callbacks then
                    o.untranslatedEvent = o.untranslatedEvent or e.id
                    o.events[slot] = nil
                elseif not e.started then
                    e.started = true
                    e.callbacks.init(o, e)
                elseif not e.callbacks.step(o, e) then
                    o.events[slot] = nil
                end
            end
        end
    end

    local function change(o)
        local p = o.parts
        local payload = {p[2].broken,p[3].broken,p[4].broken,p[5].broken}
        o.phase, o.damageLocked = 1, true
        o.events, o.emitters = {}, {}
        bullets.clear(o.run)
        if o.run.route.loop == 1 then o.run.capacity = 150 end
        addEvent(o, 1, payload)
        for i = 2, #p do
            if not p[i].broken then
                explode(o, i - 1, p[i].h, p[i].l)
                destroy(p[i])
            end
        end
        p[1].colli = false
    end

    local function defeat(o)
        o.phase, o.damageLocked = 2, true
        o.events, o.emitters = {}, {}
        bullets.clear(o.run)
        score.finishBoss(o.run)
        score.kill(o.parts[1],0x1f4)
        destroy(o.parts[1])
        o.showWreck = true
        o.run.uraBoss = false
        addEvent(o, 2)
    end

    local function applyDamage(o)
        local p = o.parts
        local phase = o.phase
        for _, part in ipairs(p) do
            if not o.damageLocked and not part.broken then
                part.hp = part.hp - part.damagePending
                if part.hp < 0 then
                    if not o.run.pilotH then
                        part.hp = 0x200
                    elseif part.id == 1 then
                        defeat(o)
                    else
                        -- 0x10f2d2 起的六个部件分别用炮体和机翼坐标计分。
                        score.kill(part,part.id <= 3 and 0x82 or 0xc8)
                        destroy(part)
                        explode(o, part.id - 1, part.h, part.l)
                        if o.run.onPartBreak then o.run.onPartBreak(o, part) end
                    end
                end
            end
            part.damagePending = 0
            part.colli = o.ready and not o.damageLocked and not part.broken
        end
        if o.phase == 0 and o.ready then
            local inner = (p[2].broken and 1 or 0) + (p[3].broken and 1 or 0)
            local fourOuter = p[4].broken and p[5].broken and p[6].broken and p[7].broken
            if inner == 0 and p[1].hp <= 0x15f00 then
                score.kill(score.source(o,p),0xc8,nil,nil,p[1])
            end
            if p[1].hp <= 0x15f00 or inner >= (fourOuter and 2 or 1) then change(o) end
        end
        if o.phase < 2 and o.phase == phase then
            local key = o.phase + 1
            o.timeout[key] = o.timeout[key] - 1
            if o.timeout[key] == 0 then
                if not o.run.pilotH then
                    o.timeout[key] = 0x78
                elseif o.phase == 0 then
                    change(o)
                else
                    defeat(o)
                end
            end
        end
        o.hp = p[1].hp
    end

    local Boss = Class(object, {
        init = function(o, run)
            o.run, o.phase, o.h, o.l = run, 0, 0x7e00, s16(0x2100 - run.cameraOffset)
            o.group, o.layer, o.bound, o.colli = GROUP.GHOST, LAYER.ENEMY, false, false
            o.events, o.emitters, o.parts, o.pods, o.damageLocked = {}, {}, {}, {}, true
            o.timeout = {0x1518,0x1518}
            -- 0x10cede 的部件初始化记录把 0x1e2 设为 1。
            o.fanBursts = 1
            o.wingH, o.wingL, o.wingAngle = -0x400, -0x780, 0
            for i, setup in ipairs(program.boss1Parts) do o.parts[i] = New(Part, o, i, setup) end
            o.hp, o.maxhp = o.parts[1].hp, o.parts[1].hp
            updateParts(o)
            addEvent(o, 0)
            run.capacity = run.route.loop == 0 and 110 or 150
        end,
        render = function(o)
            for i, data in ipairs(program.boss1Art) do
                local part = o.parts[i]
                if not part.broken or i == 1 and o.showWreck then
                    local image = o.run.art.sprites[data[1]]
                    Render(image[1], floor((part.l + data[3]) / 64) - 112 + image[2] / 2,
                        floor((part.h + data[2]) / 64) - 224 + image[3] / 2)
                end
            end
        end,
    })

    function M.spawn(run)
        run.boss = New(Boss, run)
        return run.boss
    end

    function M.step(o)
        if not o.run.freeze then
            o.l = s16(o.l - o.run.cameraStep)
            dispatch(o)
            enter(o)
            updateParts(o)
            dispatchEmitters(o)
            stepChildren(o)
            applyDamage(o)
            if o.retire then
                o.run.boss, o.run.bossPresent, o.run.bossAttack = nil, false, false
                o.run.bossRetired = true
                -- 0x10cf08 调用 0x0ae4d2，登记下一面的过关控制器。
                o.run.stageCleared, o.run.nextStageNumber = true, 2
                M.close(o)
            end
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
        for _, pod in pairs(o.pods) do
            if IsValid(pod) then object.RawDel(pod) end
        end
        for _, part in ipairs(o.parts) do
            if IsValid(part) then object.RawDel(part) end
        end
        if IsValid(o) then object.RawDel(o) end
    end
    return M
end
