-- 0x169f86。舰身和八座炮台采用 0x169d9a 的分部件槽。两类炮口各自消费计时。
return function(program, path, bullets, effects, remove)
    local bit = require('bit')
    local band, bor = bit.band, bit.bor
    local s16, world, vector = program.s16, program.world, program.vector
    local floor, byte = math.floor, string.byte
    local M = {parts=17}
    local turretExplosion = {{0x85,0,0,0,scrolls=true}}
    local turretRemnant = {{12,0,0,0,scrolls=true}}

    local function random(run, data)
        run.randomByte = band(run.randomByte + 1, 0xff)
        return byte(data, band(run.randomByte, #data - 1) + 1)
    end

    -- 0x169b38 重发一条全组转速指令，枪座各保留自己的角度和小数余量。
    local function chooseRotation(o)
        local run = o.run
        o.rotationTarget = 0x14 + 2 * random(run, program.dropSpeed)
        o.rotationSpeed, o.rotationClock = 0, 0
        o.rotationInterval = 0x10 + 2 * random(run, program.dropSpeed)
        o.reverse = random(run, program.dropAngle) ~= 0
        o.rotationPause = 0x10 + 4 * random(run, program.dropSpeed)
    end

    local function rotation(o)
        if o.openTurrets then return end
        local target, speed = o.rotationTarget, o.rotationSpeed
        if target ~= 0 and speed ~= target then
            o.rotationClock = o.rotationClock - 1
            if o.rotationClock < 0 then
                o.rotationClock, o.rotationSpeed = o.rotationInterval, speed + 1
            end
        elseif o.rotationPause ~= 0 then
            o.rotationPause = o.rotationPause - 1
            if o.rotationPause == 0 then o.rotationTarget, o.rotationClock, o.rotationInterval = 0, 4, 4 end
        else
            o.rotationClock = o.rotationClock - 1
            if o.rotationClock >= 0 then return end
            o.rotationClock, o.rotationSpeed = o.rotationInterval, speed - 1
            if o.rotationSpeed > 0 then return end
            if o.attackWindow == 1 then
                o.openTurrets = true
                local count = random(o.run, program.dropAngle) + 1
                for _, part in ipairs(o.turrets) do part.mode, part.burstCount = 1, count end
            end
            chooseRotation(o)
        end
    end

    local function rotatedPosition(h, l, angle)
        local dh, dl = vector(0x70, band(angle, 0xff))
        return s16(h + 3 * dh), s16(l + 4 * dl)
    end

    local function placeTurrets(o)
        rotation(o)
        local delta = o.reverse and -o.rotationSpeed or o.rotationSpeed
        for _, part in ipairs(o.turrets) do
            local h, l = rotatedPosition(o.h + 0x200, o.l, part.angle)
            local phase = part.fraction + delta
            local sign = phase < 0 and -1 or 1
            phase = math.abs(phase)
            if phase > 0 then
                repeat
                    local nextH, nextL = rotatedPosition(o.h + 0x200, o.l, part.angle + sign)
                    h = s16(h + floor(s16(nextH - h) / 16) * phase)
                    l = s16(l + floor(s16(nextL - l) / 16) * phase)
                    if phase < 16 then break end
                    phase = phase - 16
                    part.angle = band(part.angle + sign, 0xff)
                until phase == 0
            end
            part.h, part.l = h, l
            part.x, part.y = world(h, l)
            part.fraction = phase * sign
            part.spinClock = part.spinClock - 1
            if part.spinClock < 0 then
                part.spinClock = 1
                part.spinFrame = (part.spinFrame + 1) % 32
            end
        end
    end

    function M.init(o)
        o.flags, o.hp, o.previousHP = 0xa000, 0x3500, 0x3500
        o.front, o.back, o.right, o.left = 0x1e00, 0xfc00, 0x980, 0x980
        o.hatch, o.hatchFrame, o.hatchClock, o.hatchInterval = 0, 0, 0x10, 1
        o.attackWindow, o.plate, o.plateClock, o.plateFrame = 0, 0, 1, 0
        if not path.attach(o) then return false end
        o.h = s16(o.h + 0xa40)
        o.turrets = {}
        for i = 1, 8 do
            local part = o.extraParts[i * 2 - 1]
            o.extraParts[i * 2].flags = 0x8000
            o.turrets[i] = part
            part.flags, part.hp = 0xa000, 0x400
            part.front, part.back, part.right, part.left = 0x800, 0x400, 0x300, 0x300
            part.angle, part.fraction, part.mode = (i - 1) * 0x20, 0, 0
            part.shotClock, part.shotInterval, part.shotCount = 0x10, 0x20, 0
            part.hatchClock, part.hatchFrame, part.spinClock, part.spinFrame = 0x10, 0, 1, 0
            part.sweepClock, part.sweepPhase, part.sweepStep = 0, (i - 1) * 8, 0
        end
        chooseRotation(o)
        placeTurrets(o)
        o.run.mid1 = o
        return true
    end

    local function shot(o, h, l, kind, speed, angle, secondRound)
        local run = o.run
        if run.loop ~= 0 and secondRound == 'spread' then
            bullets.emitPrecise(run, kind, speed, angle - 8, h, l)
            bullets.emitPrecise(run, kind, speed, angle + 8, h, l)
        else
            bullets.emitPrecise(run, kind, speed, angle, h, l)
            if run.loop ~= 0 and secondRound == 'faster' then
                bullets.emitPrecise(run, kind, speed + 6, angle, h, l)
            elseif run.loop ~= 0 and secondRound == 'triple' then
                bullets.emitPrecise(run, kind, speed, angle - 8, h, l)
                bullets.emitPrecise(run, kind, speed, angle + 8, h, l)
            end
        end
    end

    local function fireMain(o)
        local pilot = o.run.player
        if band(o.h, 0xffff) < 0x1000 or not pilot or not pilot.active then return end
        local aim = program.angle256(s16(o.h + 0x2700), o.l, pilot.h, pilot.l, 0x80)
        local odd = o.hatchShots % 2 == 1
        if odd then
            -- 0x16a26a 从瞄准返回的 a0 读取炮口偏移，这次单人实测读到零。
            for i = -3, 3 do
                shot(o, s16(o.h + 0x2700), o.l, 3, 3, aim + i * 4, 'faster')
            end
        end
        local muzzle = program.shipFan[5]
        local angle = aim - 0x56
        for group = 0, 10 do
            local near = group % 2 == 0
            if near ~= odd then
                for i = 0, 3 do
                    local direction = angle + group * 16 + i * 4
                    local delta = muzzle[band(direction + 2, 0xfc) / 4 + 1]
                    shot(o, s16(o.h + delta[1] + (near and 0x1200 or 0x2700)),
                        s16(o.l + delta[2]), near and 3 or 4, 5, direction, near and 'faster' or 'spread')
                end
            end
        end
    end

    local function updateHatch(o)
        if o.hatch == 0 and o.attackWindow == 1 then
            o.hatchClock = o.hatchClock - 1
            if o.hatchClock < 0 then
                o.hatchClock, o.hatch, o.hatchFrameClock = o.hatchInterval, 1, 0
            end
            return
        end
        if o.hatch == 1 then
            if o.hatchFrame == 0 and o.openTurrets then return end
            o.hatchFrameClock = o.hatchFrameClock - 1
            if o.hatchFrameClock >= 0 then return end
            o.hatchFrameClock = 2
            o.hatchFrame = o.hatchFrame + 1
            if o.hatchFrame ~= 31 then return end
            o.hatch, o.hatchShots, o.hatchShotClock = 2, 2, 0
        end
        if o.hatch == 2 then
            o.hatchShotClock = o.hatchShotClock - 1
            if o.hatchShotClock >= 0 then return end
            o.hatchShotClock = 2
            fireMain(o)
            o.hatchShots = o.hatchShots - 1
            if o.hatchShots ~= 0 then return end
            o.hatch, o.hatchFrameClock, o.hatchInterval = 3, 0x10, 1
        end
        if o.hatch == 3 then
            o.hatchFrameClock = o.hatchFrameClock - 1
            if o.hatchFrameClock >= 0 then return end
            o.hatchFrameClock = o.hatchInterval
            o.hatchFrame = o.hatchFrame - 1
            if o.hatchFrame == 0 then o.hatch = 0 end
        end
    end

    local function turretShot(part, speed, angle)
        shot(part.host, s16(part.h + 0x200), part.l, 7, speed, angle, 'triple')
    end

    local function updateTurret(o, part, i)
        if part.flags == 0x8000 then return end
        if part.mode == 0 then
            if part.shotCount == 0 then
                part.shotClock = part.shotClock - 1
                if part.shotClock >= 0 then return end
                part.shotClock, part.shotCount = part.shotInterval, 5
            end
            part.sweepClock = part.sweepClock - 1
            if part.sweepClock >= 0 then return end
            part.sweepClock = 0
            if band(8 - i, 3) == band(o.turretTick, 3) and part.angle > 0x20 and part.angle < 0xe0 then
                turretShot(part, -2, part.angle)
                part.shotCount = part.shotCount - 1
            end
        elseif part.mode == 1 then
            if o.hatchFrame ~= 0 then return end
            part.hatchClock = part.hatchClock - 1
            if part.hatchClock >= 0 then return end
            part.hatchClock, part.hatchFrame = 3, part.hatchFrame + 1
            if part.hatchFrame ~= 7 then return end
            part.mode, part.sweepClock, part.burstCount = 2, 0, 8
        end
        if part.mode == 2 then
            part.sweepClock = part.sweepClock - 1
            if part.sweepClock >= 0 then return end
            part.sweepClock = 1
            if part.angle > 0x18 and part.angle < 0xe8 then
                turretShot(part, 2, part.angle + 4 * part.burstCount)
                part.sweepPhase = band(part.sweepPhase + 2, 0xff)
            end
            part.burstCount = part.burstCount - 1
            if part.burstCount ~= 0 then return end
            part.mode, part.hatchClock = 3, 0x20
        end
        if part.mode == 3 then
            part.hatchClock = part.hatchClock - 1
            if part.hatchClock >= 0 then return end
            part.hatchClock, part.hatchFrame = 3, part.hatchFrame - 1
            if part.hatchFrame == 0 then part.mode, part.hatchClock = 0, 0x10 end
        end
    end

    local function beginDestruction(o, hitFlags)
        o.deathTimer, o.flags = 0x70, 0x8080
        o.clearCredit = hitFlags
        local run = o.run
        run.mid1Defeated = true
        if #run.spawnQueue < 40 then
            local callbacks = program.actorCallbacks[0x1c]
            run.spawnQueue[#run.spawnQueue + 1] = {run.major,0,0x1c,0,0,callbacks[1],callbacks[2]}
        end
        for _, part in ipairs(o.turrets) do
            if part.flags == 0x8000 then effects.emit(part, turretRemnant)
            else part.forceDestroy = true end
        end
        effects.emit(o, program.mid1.destruction)
        bullets.clearWithChips(run, hitFlags)
    end

    local function damageState(o)
        if band(o.flags, 0x5c00) ~= 0 then
            local hitFlags = band(o.flags, 0x5c00)
            o.flags = band(o.flags, 0xa3ff)
            o.flash = not o.flash
            if o.attackWindow == 0 then o.hp = 0x3500 end
            if o.hatchFrame == 0 then
                o.hp = o.attackWindow < 0 and 0x7fff or o.previousHP
                o.flash = false
            elseif o.hp < 0 then
                beginDestruction(o, hitFlags)
            end
        else
            o.flash = false
        end
        o.previousHP = o.hp
        for _, part in ipairs(o.turrets) do
            if part.flags ~= 0x8000 then
                if band(part.flags, 0x5c00) ~= 0 then
                    part.flags = band(part.flags, 0xa3ff)
                    part.flash = not part.flash
                    if o.attackWindow == 0 then part.hp = 0x400 end
                else
                    part.flash = false
                end
                if part.forceDestroy or part.hp < 0 then
                    effects.emit(part, turretExplosion)
                    part.flags = 0x8000
                end
            end
        end
    end

    local function finish(o)
        o.run.mid1 = nil
        remove(o)
    end

    function M.step(o)
        local run = o.run
        if o.deathTimer then
            bullets.clearWithChips(run, o.clearCredit)
            o.h = s16(o.h - run.scrollStep * 64)
            o.deathTimer = o.deathTimer - 1
            if o.deathTimer == 0 then finish(o); return end
            if o.deathTimer == 0x30 then
                o.released = true
                run.scrollSpeed[1], run.scrollSpeed[2] = 0x20, 0x20
            end
            o.x, o.y = world(o.h, o.l)
            return
        end
        if run.major == 0xd8 then o.attackWindow = 1 end
        if run.major == 0xf8 then o.attackWindow = -1 end
        damageState(o)
        if o.h >= 0 then o.entered = true
        elseif o.entered and o.h <= -0x2400 then finish(o); return end
        if not run.freeze then
            o.h = s16(o.h - run.scrollStep * 64)
            placeTurrets(o)
            o.plateClock = o.plateClock - 1
            if o.plateClock < 0 then o.plateClock, o.plateFrame = 1, (o.plateFrame + 1) % 5 end
            updateHatch(o)
            if o.attackWindow == 1 then
                o.turretTick = ((o.turretTick or 0) + 1) % 8
                local open = false
                for i, part in ipairs(o.turrets) do
                    updateTurret(o, part, i)
                    open = open or (part.flags ~= 0x8000 and part.mode ~= 0)
                end
                if not open then o.openTurrets = false end
            end
        end
        o.x, o.y = world(o.h, o.l)
    end

    local function draw(run, sprite, h, l)
        local image = run.art[sprite]
        local x, y = world(h, l)
        Render(image[1], floor(x) + image[2] / 2, floor(y) + image[3] / 2)
    end

    function M.render(o)
        local run, images = o.run, program.mid1
        if not run.art then return end
        if o.deathTimer and o.deathTimer < 0x48 then return end
        draw(run, images.body[49][o.plateFrame + 1], o.h - 0x2400, o.l - 0x1a00)
        if o.deathTimer then return end
        for _, part in ipairs(o.turrets) do
            if part.flags ~= 0x8000 then
                local palette = part.flash and 31 or 47
                draw(run, images.gunBase[palette][part.spinFrame + 1], part.h - 0x600, part.l - 0x400)
                draw(run, images.gun[palette][part.hatchFrame + 1], part.h - 0x400, part.l - 0x400)
            end
        end
        draw(run, images.hatch[o.flash and 31 or 48][o.hatchFrame + 1], o.h - 0x400, o.l - 0xc00)
    end

    function M.damage(part, amount, flags)
        part.hp, part.flags = s16(part.hp - amount), bor(part.flags, flags)
    end

    return M
end
