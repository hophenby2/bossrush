-- 二面道中 0x74。牵引车按原方向表转弯，后部沿牵引车的历史坐标独立移动。
return function(program, bullets, effects, scroll, enemies, score)
    local band = require('bit').band
    local s16, world = program.s16, program.world
    local floor, min, max = math.floor, math.min, math.max
    local data = program.mid2
    local M = {}

    local function damage(part, value)
        part.damagePending = part.damagePending + value
    end

    local Part = Class(object, {
        init = function(part, host, index, h, l)
            part.group, part.layer = GROUP.ENEMY, LAYER.ENEMY
            part.colli, part.bound = false, false
            part.host, part.h, part.l, part.hp = host, h, l, data.hp[index]
            part.front, part.back, part.right, part.left = unpack(data.boxes[index])
            part.hitPool, part.damage, part.damagePending = 2, damage, 0
            part.direction = 8
        end,
    })

    local Pod = Class(object, {
        init = function(o, run, h, l, direction)
            o.run, o.h, o.l, o.direction = run, h, l, direction
            o.group, o.layer, o.bound, o.colli = GROUP.ENEMY, LAYER.ENEMY, false, true
            o.hp, o.hitPool, o.damagePending, o.damage = 0x300, 1, 0, damage
            o.front, o.back, o.right, o.left = 0x300, 0x300, 0x280, 0x280
            o.speed, o.clock, o.waves, o.phase = 0x20, 4, 4, 0
        end,
        render = function(o)
            local image = o.run.art.sprites[data.pods[floor(o.phase / 4) % 8 + 1]]
            Render(image[1], floor((o.l - 0x300) / 64) - 112 + image[2] / 2,
                floor((o.h - 0x600 + o.waveH) / 64) - 224 + image[3] / 2)
        end,
    })

    local function stepPods(o)
        local run = o.run
        for index = 1, 12 do
            local p = o.pods[index]
            if p then
                p.hp, p.damagePending = p.hp - p.damagePending, 0
                if not o.parts[1].broken and p.hp >= 0 then
                    p.l = s16(p.l - run.cameraStep)
                    if p.speed > 0 then
                        local dh, dl = program.vector(p.speed, p.direction * 4)
                        p.h, p.l = s16(p.h + dh), s16(p.l + dl)
                        p.speed = p.speed - 1
                    end
                    p.h = s16(p.h - 0x40)
                    p.phase = p.phase + 2
                    local _, dl = program.vector(0x40, p.phase)
                    p.waveH = dl
                    p.front, p.back = 0x300 + dl, 0x300 - dl
                    p.clock = p.clock - 1
                    if p.clock < 0 then
                        p.clock = 0
                        p.waves = p.waves - 1
                        if p.waves == 0 and p.h > 0x1000 and run.pilotH then
                            local angle = program.angle(p.h, p.l, run.pilotH, run.pilotL) * 4
                            for modifier = -3, 3, 2 do bullets.emitAngle(run, 0xc, modifier, angle, p.h, p.l) end
                        end
                    end
                end
                if p.hp < 0 or p.waves == 0 or o.parts[1].broken
                    or p.h < -0x800 or p.l < -0x1c00 or p.l >= 0x5400 then
                    effects.spawn(run, p.h, p.l, {{0,0x8b,0,0,0,0,0}}, true)
                    object.RawDel(p)
                    o.pods[index] = nil
                end
            end
        end
    end

    -- 0x13258e 把小炮舱作为新敌机挂载。炮舱离开后部后自己移动和发弹。
    local function spawnPods(o)
        local f, rear = o.podFire, o.parts[2]
        if not f or rear.broken then return end
        f.clock = f.clock - 1
        if f.clock >= 0 then return end
        local run = o.run
        local direction = band(program.random(run, program.effectRandom) * 2, 0x3f)
        for i = 1, 12 do
            if not o.pods[i] then
                o.pods[i] = New(Pod, run, s16(rear.h + 0xc00), rear.l, direction)
                o.pods[i].waveH = 0
                break
            end
        end
        f.remaining, f.clock = f.remaining - 1, 10
        if f.remaining == 0 then o.podFire = nil end
    end

    local function render(part, sprite, h, l)
        local image = part.host.run.art.sprites[sprite]
        Render(image[1], floor((part.l + l) / 64) - 112 + image[2] / 2,
            floor((part.h + h) / 64) - 224 + image[3] / 2)
    end

    local function turnIndex(angle)
        return (angle < 32 and min(8, angle) or max(-8, angle - 64)) + 9
    end

    local function setTurn(o, direction)
        local core = o.parts[1]
        local angle = band(core.direction + direction, 0x3f)
        core.direction = angle < 32 and min(8, angle) or max(0x38, angle)
    end

    local Mid = Class(object, {
        init = function(o, run, row)
            o.run, o.group, o.layer = run, GROUP.GHOST, LAYER.ENEMY
            o.colli, o.bound = false, false
            local p, cursor = run.stage.paths, row[6] - run.stage.pathBase + 1
            local h = program.word(p, cursor) + 0x400
            local l = s16(program.word(p, cursor + 2) - 0x800 - run.cameraOffset * 2)
            o.parts = {New(Part, o, 1, h, l), New(Part, o, 2, h - 0x1000, l)}
            o.history = {}
            o.pods = {}
            for i = 1, 8 do o.history[i] = {0,0,0} end
            o.speed, o.turn, o.timeLeft = 12, 1, 0x960
            o.coreH, o.coreL, o.rearH, o.rearL = h, l, h - 0x1000, l
            o.turnClock, o.speedClock, o.state, o.attackClock = 4, 4, 'enter', 0
            o.gunDirection = {0,0}
            run.capacity = run.route.loop == 0 and 110 or 150
        end,
        render = function(o)
            for i = 2, 1, -1 do
                local part = o.parts[i]
                if not part.hidden then
                    local index = turnIndex(part.direction)
                    render(part, data.body[4][index], -0xe00, -0xf00)
                    render(part, data.body[i][index], i == 1 and -0x1000 or -0x1200, -0x1100)
                    if not part.broken then
                        local gun = data.gun[i][band(o.gunDirection[i], 0x3e) / 2 + 1]
                        if i == 1 then render(part, gun, -0x180, -0xc00)
                        else render(part, gun, 0, -0x400 - (index - 9) * 0x40) end
                    end
                end
            end
        end,
    })

    local function move(o)
        local run, core, rear = o.run, o.parts[1], o.parts[2]
        local dh, dl = program.vector(o.speed, core.direction * 4)
        local h, l = s16(o.coreH + dh), s16(o.coreL + dl - run.cameraStep)
        local history = o.history
        for i = 8, 2, -1 do
            local old = history[i - 1]
            history[i][1], history[i][2], history[i][3] = old[1], s16(old[2] - run.cameraStep), old[3]
        end
        history[1][1], history[1][2], history[1][3] = h, l, core.direction
        local tail = history[8]
        dh, dl = program.vector(0x70, (tail[3] + 0x20) * 4)
        local targetH, targetL = s16(tail[1] + dh), s16(tail[2] + dl)
        local distance = program.distance(rear.h, rear.l, targetH, targetL)
        local speed = distance > 0x1000 and 0x40 or max(0, math.ceil((distance - 0xa40) / 0x40))
        o.coreH, o.coreL = s16(h - 0x40), l
        if speed > 0 then
            local direction = program.angle(rear.h, rear.l, targetH, targetL, rear.direction)
            rear.direction = program.turnToward(rear.direction, direction)
        end
        dh, dl = program.vector(speed, rear.direction * 4)
        o.rearH, o.rearL = s16(o.rearH + dh - 0x40), s16(o.rearL + dl - run.cameraStep)
        if not core.broken then core.h, core.l = o.coreH, o.coreL end
        if not rear.broken then rear.h, rear.l = o.rearH, o.rearL end
    end

    local function aim(o)
        local run = o.run
        if not run.pilotH then return end
        for i, part in ipairs(o.parts) do
            if not part.broken then
                local h = s16(part.h + (i == 1 and 0xa80 or 0x400))
                local l = s16(part.l - (i == 2 and (turnIndex(part.direction) - 9) * 0x40 or 0))
                local angle = program.angle(h, l, run.pilotH, run.pilotL, o.gunDirection[i])
                o.gunDirection[i] = program.turnToward(o.gunDirection[i], angle)
            end
        end
    end

    local function beginFan(o)
        o.fan = {clock=0x20, interval=0, waves=3, rays=o.parts[2].broken and 5 or 3,
            step=o.parts[2].broken and 10 or 8}
    end

    -- 0x132676 以实时炮口朝向为中心，连续三轮增加路数并缩短间隔。
    local function fireFan(o)
        local f, part = o.fan, o.parts[1]
        if not f or part.broken or o.state == 'retreat' then return end
        f.clock = f.clock - 1
        if f.clock >= 0 then return end
        f.interval = band(f.interval - 9, 0xff)
        f.clock = f.interval
        local angle = o.gunDirection[1]
        local muzzle = data.muzzle[band(angle, 0x3e) / 2 + 1]
        local modifier = o.run.route.loop == 1 and 3 or -1
        for i = 1, f.rays do
            bullets.emitAngle(o.run, 2, modifier, angle * 4 + (i - (f.rays + 1) / 2) * f.step,
                part.h, part.l, muzzle[1] + 0xa80, muzzle[2])
        end
        f.waves, f.rays = f.waves - 1, f.rays + 2
        if f.waves == 0 then
            if o.parts[2].broken then f.waves, f.rays, f.clock, f.interval = 3, 3, 0x28, 0x29
            else o.fan = nil end
        end
    end

    -- 0x132604 单独驱动后炮，每帧从转动后的炮座取瞄准方向。
    local function fireRear(o)
        local f, part = o.rearFire, o.parts[2]
        if not f or part.broken or o.state ~= 'attack' then return end
        f.clock = f.clock - 1
        if f.clock >= 0 then return end
        f.clock, f.waves = 0x10, f.waves - 1
        local angle = o.gunDirection[2]
        local muzzle = data.rearMuzzle[band(angle, 0x3e) / 2 + 1]
        local h, l = s16(part.h + 0x400), s16(part.l - (turnIndex(part.direction) - 9) * 0x40)
        for _, delta in ipairs({0,4,8,-4,-8}) do
            bullets.emitShortPair(o.run, 1, -6, angle + delta, h, l, muzzle[1], muzzle[2])
        end
        if f.waves == 0 then o.rearFire = nil end
    end

    -- 0x13296c 在后部损毁时登记两侧旋转炮。角度各自沿相反方向推进。
    local function fireSides(o)
        local f, core = o.sideFire, o.parts[1]
        if not f or core.broken or o.state ~= 'attack' then return end
        f.clock = f.clock - 1
        if f.clock >= 0 then return end
        f.clock = 3
        local index, run = turnIndex(core.direction), o.run
        local first, second = data.sideMuzzle[1][index], data.sideMuzzle[2][index]
        for i = 0, 2 do bullets.emitWidePair(run, 0xb, 0, f.angleA + i * 0x55, core.h, core.l, first[1], first[2]) end
        for i = 0, 3 do bullets.emitAngle(run, 0xb, 0, f.angleB + i * 0x40, core.h, core.l, second[1], second[2]) end
        f.angleA, f.angleB = f.angleA + 8, f.angleB - 7
    end

    local function breakPart(o, index)
        local part = o.parts[index]
        if part.broken then return end
        part.hp, part.broken, part.colli, part.breakClock = -1, true, false, 0x40
        effects.spawn(o.run, part.h, part.l, data.explosions, true)
        if index == 1 then
            bullets.clear(o.run)
        elseif not o.parts[1].broken then
            local run = o.run
            local angle = program.random(run, program.randomParity)
            o.sideFire = {clock=0, angleA=angle, angleB=angle + 0x40}
        end
    end

    local function applyDamage(o)
        local core, rear = unpack(o.parts)
        for _, part in ipairs(o.parts) do
            if part.damagePending > 0 and not part.broken and o.state == 'attack' then
                if not core.broken then core.hp = core.hp - part.damagePending end
                if not rear.broken then rear.hp = rear.hp - part.damagePending end
                -- 0x131ec0 和 0x131f78 都扣两条耐久，随后只判断各自负责的机身。
                if part == core and core.hp < 0 then
                    score.kill(part,0xa3c,nil,nil,core)
                    breakPart(o, 1)
                    breakPart(o, 2)
                elseif part == rear and rear.hp < 0 then
                    score.kill(part,0x582,nil,nil,rear)
                    breakPart(o, 2)
                end
            end
            part.damagePending = 0
            if part.breakClock and part.breakClock >= 0 then
                part.breakClock = part.breakClock - 1
                part.h, part.l = s16(part.h - 0x40), s16(part.l - o.run.cameraStep)
                if part.breakClock < 0 then part.hidden = true end
            end
            part.x, part.y = world(part.h, part.l)
        end
    end

    function M.spawn(run, row)
        run.mid2 = New(Mid, run, row)
        return run.mid2
    end

    local function exitSpawn(run, kind, path, l, flags)
        local definition = program.spawnTypes[kind]
        enemies.spawn(run, {run.major, run.minor, kind, flags, 0, 0, 0, 0,
            definition[1], definition[2], h=0x7400, l=l, path=path})
    end

    -- 0x131d8e 解锁卷轴后仍继续登记两种增援，直到推进到下一段。
    local function exitFormation(o)
        local run = o.run
        o.airClock, o.groundClock = o.airClock - 1, o.groundClock - 1
        if o.airClock < 0 then
            o.airClock = 0
            for _ = 1, 2 do
                exitSpawn(run, 0x10, data.exitPaths[1], 0x2400 + program.random(run, program.spawnJitter) * 2, 0)
            end
        end
        if o.groundClock < 0 then
            o.groundClock = 0x16
            local kind = program.random(run, program.randomParity) % 2 == 0 and 0x25 or 0x24
            local value = program.random(run, program.effectRandom)
            local l = 0x2400 + program.s16(value * 0x600)
            exitSpawn(run, kind, data.exitPaths[2], l, 1)
        end
    end

    function M.step(o)
        local run, core, rear = o.run, o.parts[1], o.parts[2]
        if run.freeze then return end
        if o.state == 'enter' and core.h >= 0x3c00 then
            o.state, core.colli, rear.colli = 'attack', true, true
            o.podFire = {clock=10, remaining=12}
        end
        if o.state == 'attack' and not core.broken then
            o.timeLeft = o.timeLeft - 1
            if o.timeLeft == 0 then
                if not run.pilotH then o.timeLeft = 0x78
                else o.state, core.colli, rear.colli, o.fan = 'retreat', false, false, nil end
            end
            o.turnClock, o.speedClock = o.turnClock - 1, o.speedClock - 1
            if o.turnClock < 0 and o.speed ~= 0 then
                o.turnClock = 4
                setTurn(o, o.turn)
            end
            if o.speedClock < 0 then
                o.speedClock = o.braking and 3 or 4
                o.speed = max(0, min(12, o.speed + (o.braking and -1 or 1)))
                if o.speed == 0 then o.braking = false; o.attackClock = core.h < 0x5000 and 0 or 0x30 end
            end
            if not o.braking and (o.turn > 0 and core.l > 0x2c00 or o.turn < 0 and core.l < 0xc00) then
                o.turn, o.braking = -o.turn, true
                o.rearFire = {clock=0, waves=4}
            end
            o.attackClock = o.attackClock - 1
            if o.attackClock < 0 and not o.fan then o.attackClock = 0x40; beginFan(o) end
        end
        move(o)
        aim(o)
        fireFan(o)
        fireRear(o)
        fireSides(o)
        spawnPods(o)
        stepPods(o)
        applyDamage(o)
        if not o.released and ((core.hidden and rear.hidden) or (o.state == 'retreat' and core.h <= 0x1800)) then
            scroll.release(run, 0x130)
            o.released, o.airClock, o.groundClock = true, 8, 0x16
        end
        if o.released then exitFormation(o) end
        if o.released and (run.major >= 0x131 or core.h <= -0x1000) then M.close(o) end
    end

    function M.close(o)
        o.run.mid2 = nil
        for _, p in pairs(o.pods) do object.RawDel(p) end
        for _, part in ipairs(o.parts) do object.RawDel(part) end
        object.RawDel(o)
    end

    return M
end
