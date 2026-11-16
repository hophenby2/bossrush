-- 0x1774c0 将两块判定盒归到同一个耐久量，舱门与双翼交替取得发弹控制权。
return function(program, path, bullets, effects, remove, hyper)
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local s16, world = program.s16, program.world
    local floor = math.floor
    local data = program.mid2
    local M = {parts=3}
    local blasts = {
        {13,0,0x400,0,flip=true}, {0x84,1,0x400,0x200,4,0x4c},
        {0x84,2,0x400,-0x200,4,0xb4,flip=true}, {13,2,-0x600,-0x200,6,0xa8},
        {0x85,4,-0x400,0x100,8,0x58}, {0x85,6,-0xc00,-0x200,10,0x88,flip=true},
        {13,4,-0xc00,0x400,10,0x78,flip=true}, {13,8,0,-0xe00,4,0xa0,flip=true},
        {13,8,0,0xe00,4,0x60,flip=true}, {0x85,10,-0x1600,-0xa00,10,0x90,flip=true},
        {0x85,10,-0x1600,0xa00,10,0x70,flip=true}, {0x85,8,-0x1c00,0x200,5,0x88,flip=true},
    }
    local wings = {0x780,-0x780}
    local gunDrawOffsets = {0x480,-0xa80}

    local function shot(o, kind, speed, angle, h, l)
        bullets.emitPrecise(o.run, kind, speed, angle, s16(o.h + h), s16(o.l + l))
    end

    local function setWingBox(o)
        local part = o.extraParts[1]
        part.front, part.back, part.right, part.left = unpack(data.boxes[o.hatchFrame + 1])
    end

    function M.damage(o, amount, flags)
        o.hp, o.flags = s16(o.hp - amount), bor(o.flags, flags)
    end

    function M.init(o)
        o.flags, o.hp, o.health = 0xa001, 0x7fff, 0xb000
        o.front, o.back, o.right, o.left = 0xe00, 0x600, 0xe00, 0xe00
        o.palette, o.rotorPalette, o.hatchPalette = 21, 22, 23
        o.hatchFrame, o.hatchClock, o.rotorFrame, o.rotorCursor = 0, 0, 8, 8
        o.mainPhase, o.mainClock, o.mainCount = 0, 0x60, 9
        o.wingPhase, o.wingClock, o.wingCount, o.wingMax = 0, 0x40, 0x11, 0x11
        o.spreadIndex, o.spreadClock, o.spreadSpeed, o.wingSplit = 4, 0x20, 0x10, 8
        o.trackWing, o.wingAims = 1, {0x80,0x80}
        local part = o.extraParts[1]
        part.flags, part.hp = 0xa001, 0x7fff
        setWingBox(o)
        o.extraParts[2].flags = 0x8000
        if not path.attach(o) then return false end
        local run = o.run
        local pilot = run.player
        for i, dl in ipairs(wings) do
            local angle = pilot and pilot.active and program.angle256(o.h + 0xac0, o.l + dl, pilot.h, pilot.l, 0)
                or o.direction * 4
            o.wingAims[i] = angle
        end
        part.flags, part.h, part.l = o.flags, o.h, o.l
        run.mid2 = o
        run.bulletCapacity = math.max(run.bulletCapacity, run.loop == 0 and 110 or 160)
        return true
    end

    local function updateMain(o)
        local phase, run = o.mainPhase, o.run
        if o.wingPhase ~= 0 or o.h < 0x1000 then return end
        if phase == 1 or phase == 3 then
            o.hatchClock = o.hatchClock - 1
            if o.hatchClock >= 0 then return end
            o.hatchClock = 1
            o.hatchFrame = o.hatchFrame + (phase == 1 and 1 or -1)
            if o.hatchFrame == 23 then o.mainPhase = 2
            elseif o.hatchFrame == 0 then o.mainPhase, o.wingPhase = 0, 1 end
            return
        end
        o.mainClock = o.mainClock - 1
        if o.mainClock >= 0 then return end
        if phase == 0 then
            o.mainPhase, o.mainClock = 1, 0x10
            return
        end
        o.mainClock = band(0x10 - floor(program.rank(run,0x20,'tankRank') / 4),0xff)
        local pilot = run.player
        if not pilot or not pilot.active then return end
        local aim = program.angle256(o.h - 0x800, o.l, pilot.h, pilot.l, 0)
        for i, offset in ipairs(data.mainOffsets) do
            local a = aim + 8 * program.bossRandom(run)
            local muzzle = data.mainMuzzles[band(a + 2,0xfc) / 4 + 1]
            local h, l = program.addPacked(offset[1], offset[2], muzzle[1], muzzle[2])
            if run.loop ~= 0 and i % 2 == 1 then
                shot(o, 0x13, -2, a - 8, h, l)
                shot(o, 0x13, -2, a + 8, h, l)
            else shot(o, 0x13, -2, a, h, l) end
        end
        o.mainCount = o.mainCount - 1
        if o.mainCount < 0 then
            o.mainCount, o.mainClock, o.mainPhase = 9, band(0x50 - program.rank(run,0x18,'largeRank'),0xff), 3
        end
    end

    local function track(o)
        local pilot = o.run.player
        if not pilot or not pilot.active then return end
        local i = o.trackWing
        local aim = o.wingAims[i]
        local target = program.angle256(o.h + 0xac0, o.l + wings[i], pilot.h, pilot.l, aim)
        local delta = band(target - aim + 0x80,0xff) - 0x80
        local limit = o.wingCount == o.wingMax and 1 or 4
        o.wingAims[i] = band(aim + math.max(-limit, math.min(limit, delta)),0xff)
        o.trackWing = 3 - i
        o.flags = bxor(o.flags,0x40)
    end

    local function updateWings(o)
        local phase, run = o.wingPhase, o.run
        if phase == 0 or o.h < 0x1000 then return end
        if phase == 1 then
            o.wingClock = o.wingClock - 1
            if o.wingClock >= 0 then return end
            o.wingClock = 2
            for i, dl in ipairs(wings) do
                local a = o.wingAims[i]
                local offset = data.wingMuzzles[band(a + 4,0xf8) / 8 + 1]
                local h, l = 0xac0 + offset[1], dl + offset[2]
                shot(o, 7, 0x18, a, h, l)
                if run.loop ~= 0 then
                    shot(o, 7, 0x18, a - 8, h, l)
                    shot(o, 7, 0x18, a + 8, h, l)
                end
                local split = 2 * o.wingCount + o.wingSplit
                shot(o, 7, run.loop == 0 and 0x18 or 0x1c, a + (i == 1 and -split or split), h, l)
            end
            o.wingCount = o.wingCount - 1
            if o.wingCount < 0 then
                o.wingMax = o.wingMax + 6
                o.wingCount, o.wingClock, o.wingPhase = o.wingMax, 0x30, 2
                o.wingSplit = math.max(5, o.wingSplit - 2)
            end
            return
        end
        o.spreadClock = o.spreadClock - 1
        if o.spreadClock >= 0 then return end
        o.spreadClock = 0x18
        local i, pilot = o.spreadIndex, run.player
        local aim
        if i % 2 == 0 then aim = program.bossWideRandom(run)
        elseif pilot and pilot.active then aim = program.angle256(o.h - 0x6c0, o.l, pilot.h, pilot.l, 0)
        else return end
        local spacing, count = unpack(data.spread[i])
        local shift = data.spreadOffsets[i]
        local speed = floor((o.spreadSpeed - (i - 1) * 4) / 2)
        for ray = 0, count do
            local a = aim + ray * spacing
            local offset = program.stage2Battleship.muzzles[band(a + 2,0xfc) / 4 + 1]
            local h, l = program.addPacked(shift[1], shift[2], offset[1], offset[2])
            shot(o, 3, speed, a, h, l)
            if run.loop ~= 0 then shot(o, 3, speed + 6, a, h, l) end
            if (count - ray) % 2 ~= 0 then shot(o, 4, speed - 6, a, h, l) end
        end
        o.spreadIndex = i - 1
        if o.spreadIndex == 0 then
            o.spreadIndex, o.spreadClock, o.wingPhase, o.spreadSpeed = 4, 0x20, 0, o.spreadSpeed + 8
        end
    end

    local function release(o)
        o.run.mid2 = nil
        remove(o)
    end

    function M.step(o)
        local run = o.run
        if o.deathClock then
            bullets.clearWithChips(run, o.credit)
            o.deathClock = o.deathClock - 1
            if o.deathClock == 0 then release(o) end
            return
        end
        if not path.step(o) then release(o); return end
        local part = o.extraParts[1]
        part.flags = bor(band(o.flags,0xe7ff), band(part.flags,0xdffe))
        part.h, part.l = o.h, o.l
        local visible = band(o.h + 0xe00,0xffff) < 0x8600
            and band(o.l + 0x1a00 + run.cameraOffset,0xffff) < 0x6c00
        if visible then o.entered = true
        elseif o.entered then release(o); return end
        if not o.part[0x1e] or o.part[0x1e] == 0 then o.health = 0xb000 end
        local hitFlags = band(bor(o.flags, part.flags),0x5c00)
        if hitFlags ~= 0 then
            o.flags, part.flags = band(o.flags,0xa3ff), band(part.flags,0xa3ff)
            hyper.hit(o,hitFlags)
            o.palette = bxor(o.palette == 25 and 21 or o.palette,10)
            o.rotorPalette, o.hatchPalette = bxor(o.rotorPalette,9), bxor(o.hatchPalette,8)
            o.health = o.health - (0x7fff - math.min(o.hp, part.hp))
            o.hp, part.hp = 0x7fff, 0x7fff
            if o.health < 0 then
                o.flags, part.flags, o.deathClock, o.credit = 0x8080, 0x8080, 0x70, hitFlags
                hyper.kill(run,hitFlags,457)
                effects.emit(o, blasts)
                bullets.clearWithChips(run, hitFlags)
                o.deathClock = o.deathClock - 1
                return
            end
        else
            o.palette, o.rotorPalette, o.hatchPalette = o.hp < 0x2c00 and 25 or 21, 22, 23
        end
        o.rotorFrame, o.rotorCursor = o.rotorCursor, (o.rotorCursor - 2) % 8 + 1
        if not run.freeze and run.enemyShotGrace == 0 then
            updateMain(o)
            setWingBox(o)
            track(o)
            updateWings(o)
        end
        o.x, o.y = world(o.h, o.l)
        part.x, part.y = o.x, o.y
    end

    local function draw(o, id, dh, dl)
        local image = o.run.art[id]
        local x, y = world(o.h + dh, o.l + dl)
        Render(image[1], floor(x) + image[2] / 2, floor(y) + image[3] / 2)
    end

    function M.render(o)
        if not o.run.art or o.deathClock then return end
        draw(o, data.body[o.palette][1], -0x1200, -0xf00)
        draw(o, data.hatch[o.hatchPalette][o.hatchFrame + 1], -0x1c00, -0xe00)
        for i, dl in ipairs(gunDrawOffsets) do
            local frame = band(o.wingAims[i] + 4,0xf8) / 8 + 1
            draw(o, data.turret[o.palette][frame], 0x6c0, dl)
        end
        draw(o, data.rotor[o.rotorPalette][o.rotorFrame], -0x700, -0x1200)
    end

    return M
end
