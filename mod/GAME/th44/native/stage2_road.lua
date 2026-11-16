-- 第二面中 Boss 之后的货舱、单侧舱门炮与巡航机回调。
return function(program, path, bullets, effects, items, remove, hyper)
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local s16, world = program.s16, program.world
    local floor = math.floor
    local freight, turret, cruiser = program.stage2Freight, program.stage2SideTurret, program.stage2Cruiser
    local F, T, C = {parts=1}, {parts=1}, {parts=1}

    -- 0x17839a、0x1785d8、0x1787ba 的部件模板与击破分发。
    local cargo = {
        [0x91] = {draw={-0x1200,-0x800}, box={0x1200,0x1200,0x600,0x600}, delay=12,
            margin=0x1200, bounds=0x9400, score=13, kind=8,
            drops={{0xc00,0x100},{0x800,-0x100},{0x400,0x100},{0,-0x100},
                   {-0x400,0x100},{-0x800,-0x100},{-0xc00,0x100}},
            blasts={{5,6,0xa00,0x80},{5,3,-0x400,-0x80,flip=true},{5,0,-0x1200,0x80}}},
        [0x92] = {draw={-0x1400,-0x600}, box={0x1400,0x1400,0x600,0x600}, delay=0x12,
            margin=0x1400, bounds=0x9800, score=14, kind=0xc,
            blasts={{13,3,0,0,flip=true},{5,0,-0xe00,0x80}}},
        [0x93] = {draw={-0x1400,-0x800}, box={0x1400,0x1000,0x800,0x800}, delay=0x12,
            margin=0x1400, bounds=0x9800, score=15, kind=0xc, drops={{-0x540,-0x5c0}},
            blasts={{0x85,2,0xc00,-0x180},{13,1,-0x600,-0x100,flip=true},{0x85,0,-0x1200,0}}},
    }
    local turretBlast = {{12,0,-0x300,0}}
    local cruiserBlast = {{12,0,-0x200,0},{13,0,-0x400,0,flip=true},{8,0,-0xa00,0}}
    local cruiserStars = {{0x400,0},{0x400,0},{0,0},{-0x400,-0x400},{-0x400,0x400}}

    local function damage(o, amount, flags)
        o.hp, o.flags = s16(o.hp - amount), bor(o.flags, flags)
    end
    F.damage, T.damage, C.damage = damage, damage, damage

    local function palette(o, base, mask)
        o.basePalette, o.flashMask, o.palette = base, mask, base
    end

    local function hit(o, threshold, points)
        local flags = band(o.flags, 0x5c00)
        if flags == 0 then
            o.palette = band(o.hp,0xffff) < threshold and 25 or o.basePalette
            return false
        end
        o.flags = band(o.flags,0xa3ff)
        hyper.hit(o,flags)
        o.palette = bxor(o.palette == 25 and o.basePalette or o.palette,o.flashMask)
        if o.hp >= 0 then return false end
        hyper.kill(o.run,flags,points)
        return true
    end

    local function visible(o, within)
        if within then o.entered = true
        elseif o.entered then remove(o); return false end
        return true
    end

    local function draw(o, id, dh, dl, flip)
        local image = o.run.art[id]
        local x, y = world(o.h + dh, o.l + dl)
        Render(image[1], floor(x) + image[2] / 2, floor(y) + image[3] / 2, 0, flip and -1 or 1, 1)
    end

    function F.init(o)
        o.flags, o.hp, o.cargo = 0xa000, 0xe00, cargo[o.kind]
        o.front, o.back, o.right, o.left = unpack(o.cargo.box)
        palette(o, unpack(freight[o.kind].palettes[o.run.stageNumber]))
        if not path.attach(o) then return false end
        o.flip = o.kind == 0x92 and (o.part[0x1e] or 0) ~= 0
        if o.flip then o.part[0x1e] = 0 end
        return true
    end

    function F.step(o)
        if not path.step(o) then remove(o); return end
        local data = o.cargo
        if not visible(o, band(o.h + data.margin,0xffff) < data.bounds) then return end
        if o.deathClock then
            o.deathClock = o.deathClock - 1
            if o.deathClock < 0 then
                if o.kind == 0x92 then
                    items.emit(o, 0xc, -0x100, o.flip and 0x200 or -0x200)
                else
                    for _, drop in ipairs(data.drops) do items.emit(o, data.kind, drop[1], drop[2]) end
                end
                remove(o)
                return
            end
        elseif hit(o,0x380,data.score) then
            o.flags, o.palette, o.deathClock = 0x8080, o.basePalette, data.delay
            effects.emit(o, data.blasts)
        end
        o.x, o.y = world(o.h,o.l)
    end

    function F.render(o)
        if o.run.art then draw(o, freight[o.kind].images[o.palette], o.cargo.draw[1], o.cargo.draw[2], o.flip) end
    end

    function T.init(o)
        local run = o.run
        o.flags, o.hp = 0xa000, 0x600
        o.front, o.back, o.right, o.left = 0x800,0xa00,0x600,0x600
        local base = run.stageNumber == 2 and 19 or 18
        palette(o, base, 31 - base)
        o.phase, o.attackClock, o.hatchClock = 0, band(0x60 - program.rank(run,0x16,'rapidRank'),0xff), 0
        o.hatchFrame, o.burst = 1, 4
        if not path.attach(o) then return false end
        o.flip = (o.part[0x1e] or 0) ~= 0
        o.openBox = o.flip and 'right' or 'left'
        if o.flip then o.part[0x1e] = 0 end
        o[o.openBox] = turret.boxes[1]
        return true
    end

    local function fireTurret(o)
        local run, phase = o.run, o.phase
        if run.freeze or run.enemyShotGrace > 0 or o.h < 0x2c00 then return end
        if phase == 1 or phase == 3 and o.attackClock == 0 then
            o.hatchClock = o.hatchClock - 1
            if o.hatchClock >= 0 then return end
            o.hatchClock = 1
            o.hatchFrame = o.hatchFrame + (phase == 1 and 1 or -1)
            o[o.openBox] = turret.boxes[o.hatchFrame]
            if o.hatchFrame == 16 then o.phase = 2
            elseif o.hatchFrame == 1 then o.phase, o.attackClock = 0, band(0x40 - program.rank(run,0x1a,'groundRank'),0xff) end
            return
        end
        o.attackClock = o.attackClock - 1
        if o.attackClock >= 0 then return end
        if phase == 0 then o.phase, o.attackClock = 1, 0x10; return end
        o.attackClock = run.difficulty <= 1 and 6 or 2
        local pilot = run.player
        if program.pilotDistance(o,pilot) < program.aimDistances[run.difficulty + 1] then return end
        if pilot and pilot.active then
            local muzzle = s16((o.state[0x28] or 0) * 0x100 + (o.state[0x29] or 0))
            local h, l = s16(o.h + 0x300), s16(o.l + muzzle)
            local aim = program.angle256(h,l,pilot.h,pilot.l,0x80)
            if run.loop ~= 0 then
                bullets.emitPrecise(run,12,1,aim - 8,h,l)
                bullets.emitPrecise(run,12,1,aim + 8,h,l)
            else bullets.emitPrecise(run,12,1,aim,h,l) end
        end
        o.burst = o.burst - 1
        if o.burst < 0 then o.burst, o.phase, o.attackClock = 4, 3, 0x10 end
    end

    function T.step(o)
        if not path.step(o) then remove(o); return end
        if not visible(o, band(o.h + 0xa00,0xffff) < 0x8400) then return end
        if hit(o,0x180,34) then
            items.emit(o,8)
            effects.emit(o,turretBlast)
            remove(o)
            return
        end
        fireTurret(o)
        o.x, o.y = world(o.h,o.l)
    end

    function T.render(o)
        if o.run.art then draw(o, turret.images[o.palette][o.hatchFrame], -0x800, -0x800, o.flip) end
    end

    function C.init(o)
        o.flags, o.hp = 0xa000, 0xb00
        o.front, o.back, o.right, o.left = 0xc00,0xa00,0x800,0x800
        palette(o, unpack(cruiser.palettes[o.run.stageNumber]))
        o.attackClock, o.burst = band(0x80 - program.rank(o.run,0x12,'gunRank'),0xff), 8
        o.bodyFrame, o.rotorClock = 1, 0
        if not path.attach(o) then return false end
        o.flip = (o.part[0x1e] or 0) ~= 0
        o.turretL = o.flip and 0x280 or -0x280
        local pilot = o.run.player
        o.angle = pilot and pilot.active and program.angle(o.h + 0x440,o.l + o.turretL,pilot.h,pilot.l,o.direction)
            or o.direction
        if band(o.flags,0x2000) == 0 then
            o.openBox = o.flip and 'right' or 'left'
            o[o.openBox] = -0x800
        end
        o.part[0x1e] = 0
        return true
    end

    local function cruiserShot(o, offset, angle)
        local run = o.run
        local h, l = s16(o.h + 0x440 + offset[1]), s16(o.l + o.turretL + offset[2])
        bullets.emit(run,12,2,angle,h,l)
        if run.loop ~= 0 then bullets.emit(run,12,8,angle,h,l) end
    end

    function C.step(o)
        local run = o.run
        if not path.step(o) then remove(o); return end
        if not run.freeze and o.openBox and band(o.flags,0x2000) ~= 0 and o.direction < 0x40 then
            local half = o.openBox
            if o[half] < 0x800 then o[half] = s16(o[half] + (o.flip and -o.dl or o.dl)) end
        end
        if not visible(o, band(o.h + 0xc00,0xffff) < 0x8800
            and band(o.l + run.cameraOffset + 0x1000,0xffff) < 0x5800) then return end
        if hit(o,0x2c0,88) then
            for _, at in ipairs(cruiserStars) do items.emit(o,8,at[1],at[2]) end
            effects.emit(o,cruiserBlast)
            remove(o)
            return
        end
        if not run.freeze and o.direction < 0x40 then
            o.rotorClock = o.rotorClock - 1
            if o.rotorClock < 0 then
                local neighbor = run.partSlots[o.partPool][o.firstPart + 1]
                o.rotorClock = band(neighbor and neighbor.right or 0,0xff)
                o.bodyFrame = (o.bodyFrame - 1 + (o.direction == 0x10 and 1 or -1)) % 4 + 1
            end
        end
        if not run.freeze and run.enemyShotGrace == 0 then
            local pilot = run.player
            if pilot and pilot.active then
                local to = program.angle(o.h + 0x440,o.l + o.turretL,pilot.h,pilot.l,o.angle)
                local diff = band(to - o.angle,0x3f)
                if diff ~= 0 then o.angle = band(o.angle + (diff < 0x20 and 1 or -1),0x3f) end
            end
            if o.h >= 0x1000 then
                o.attackClock = o.attackClock - 1
                if o.attackClock < 0 then
                    local muzzle = cruiser.muzzles[band(o.angle,0x3e) / 2 + 1]
                    if o.burst % 2 == 0 then cruiserShot(o,muzzle,o.angle)
                    else
                        cruiserShot(o,muzzle,o.angle - 2)
                        cruiserShot(o,muzzle,o.angle + 2)
                    end
                    o.attackClock, o.burst = band(3 - floor(program.rank(run,0x20,'tankRank') / 8),0xff), o.burst - 1
                    if o.burst < 0 then o.attackClock, o.burst = band(0x70 - program.rank(run,0x1a,'groundRank'),0xff), 8 end
                end
            end
        end
        o.x, o.y = world(o.h,o.l)
    end

    function C.render(o)
        if not o.run.art then return end
        local art = cruiser.images[o.palette]
        draw(o, art[1][o.bodyFrame], -0xc00, -0x800, o.flip)
        draw(o, art[2][band(o.angle,0x3e) / 2 + 1], -0x1c0, o.turretL - 0x400)
    end

    return F, T, C
end
