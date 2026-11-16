-- 0x173b18 随路径展开机体判定盒，0x178dfa 随炮门换图和改侧边判定。
return function(program, path, bullets, effects, items, remove, hyper)
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local s16, world = program.s16, program.world
    local floor = math.floor
    local ground, battleship = program.groundShip, program.stage2Battleship
    local G, B, S = {parts=2}, {parts=1}, {parts=1}
    local supply = program.stage2Supply

    local groundBlast = {
        {12,0,-0x800,0}, {12,0,0x800,0},
        {0x85,0,0,0x400}, {13,0,-0x600,-0x200,3,0xa0},
        {13,0,-0x600,0x200,3,0x60,flip=true}, {12,0,-0x600,-0x200},
        {0x85,0,-0xa00,0,7,0x80,flip=true},
    }
    local battleshipBlast = {
        {0x85,0,0,0,7,0}, {0x85,2,-0x400,0x800,7,0x40,flip=true},
        {0x85,4,-0xe00,0,8,0x80}, {0x85,6,-0x400,-0x800,7,0xc0,flip=true},
        {0x85,8,0x600,-0xa00,4,0xd0,flip=true}, {13,10,0x200,0x600,4,0x30,flip=true},
        {0x85,12,-0x1000,0xa00,4,0x50}, {13,14,-0x1000,-0x600,4,0xb0,flip=true},
        {13,16,-0xc00,0,0,0,flip=true},
    }
    local supplyBlast = {{13,4,-0x600,0x600}, {13,2,-0x600,-0x600,flip=true}, {0x85,0,-0x200,0}}

    local function damage(o, amount, flags)
        o.hp, o.flags = s16(o.hp - amount), bor(o.flags, flags)
    end
    G.damage, B.damage, S.damage = damage, damage, damage

    local function hit(o, threshold)
        if band(o.flags, 0x5c00) == 0 then
            o.palette = band(o.hp,0xffff) < threshold and 25 or o.basePalette
            return false
        end
        local hitFlags = band(o.flags,0x5c00)
        o.flags = band(o.flags, 0xa3ff)
        hyper.hit(o,hitFlags)
        o.palette = bxor(o.palette == 25 and o.basePalette or o.palette, o.flashMask)
        if o.hp < 0 then return hitFlags end
    end

    local function draw(o, id, dh, dl)
        local image = o.run.art[id]
        local x, y = world(o.h + dh, o.l + dl)
        Render(image[1], floor(x) + image[2] / 2, floor(y) + image[3] / 2)
    end

    function G.init(o)
        local run = o.run
        o.flags, o.hp = 0xa000, run.difficulty == 4 and 0x1400 or 0x2d00
        o.front, o.back, o.right, o.left = 0x1000, 0x1000, 0x800, 0x800
        o.basePalette, o.flashMask = unpack(ground.palettes[run.stageNumber])
        o.palette = o.basePalette
        o.phase, o.attackClock, o.burst = 0, band(0xc8 - program.rank(run,0x0c,'gunRank'), 0xff), 6
        o.hatchFrame, o.hatchShift, o.muzzle, o.otherWing = 0, 0, 3, false
        o.rotor, o.rotorClock, o.drawH, o.recoil = 1, 2, -0x1000, false
        -- 第二个槽保存螺旋桨动画用的量，原模板未启用任何碰撞。
        o.extraParts[1].flags = 0x8000
        if not path.attach(o) then return false end
        if band(o.flags, 0x2000) == 0 then
            o.openBox = o.part[0x1e] == 1 and 'back' or 'front'
            o[o.openBox], o.part[0x1e] = -0x1000, 0
        end
        return true
    end

    local function groundFire(o)
        local run = o.run
        if run.freeze or run.enemyShotGrace > 0 or o.h < 0x1000 then return end
        if o.phase == 1 then
            o.hatchFrame = o.hatchFrame + 1
            o.hatchShift = ground.hatch[o.hatchFrame + 1]
            if o.hatchFrame == 10 then o.phase, o.hatchFrame = 2, 8 end
            return
        elseif o.phase == 3 then
            o.hatchFrame = o.hatchFrame - 1
            o.hatchShift = ground.hatch[o.hatchFrame + 1]
            if o.hatchFrame == 0 then o.phase = 0 end
            return
        elseif o.phase == 2 then
            o.recoil = false
        end
        o.attackClock = o.attackClock - 1
        if o.attackClock >= 0 then return end
        if o.phase == 0 then
            o.phase, o.attackClock = 1, 8
            return
        end

        o.attackClock = band(5 - floor(program.rank(run,0x20,'tankRank') / 8), 0xff)
        local pilot = run.player
        if pilot and pilot.active then
            local dl = o.otherWing and -0x400 or 0x400
            local h, l = s16(o.h + ground.muzzles[o.muzzle]), s16(o.l + dl)
            local a = program.angle256(o.h + 0xe00, l, pilot.h, pilot.l, 0x80)
            a = a + program.bossRandom(run)
            if run.loop == 0 then
                bullets.emitPrecise(run, 0x13, 3, a, h, l)
            else
                bullets.emitPrecise(run, 0x13, 3, a - 8, h, l)
                bullets.emitPrecise(run, 0x13, 3, a + 8, h, l)
            end
            a = a + (program.bossSmallRandom(run) == 0 and -0x10 or 0x10)
            bullets.emitPrecise(run, 0x13, 3, a, h, l)
            if run.loop ~= 0 then
                bullets.emitPrecise(run, 0x13, 9, a, h, l)
            end
        end
        o.recoil = true
        o.muzzle = (o.muzzle - 2) % #ground.muzzles + 1
        o.burst = o.burst - 1
        if o.burst >= 0 then return end
        o.burst, o.otherWing = 6, not o.otherWing
        if not o.otherWing then o.phase, o.attackClock = 3, band(0x40 - program.rank(run,0x1a,'groundRank'), 0xff) end
    end

    function G.step(o)
        if not path.step(o) then remove(o); return end
        if o.openBox and band(o.flags, 0x2000) ~= 0 and not o.run.freeze then
            local half = o.openBox
            if o[half] < 0x1000 and o.direction < 0x40 then
                o[half] = s16(o[half] + (half == 'back' and o.dh or -o.dh))
                if band(o[half], 0xffff) < 0x800 then o.hp = 0x2d00 end
            end
        end
        if band(o.h + 0x1600, 0xffff) < 0x8e00 then o.entered = true
        elseif o.entered then remove(o); return end
        local credit = hit(o, 0xb40)
        if credit then
            hyper.kill(o.run,credit,162)
            for _, offset in ipairs(ground.stars) do items.emit(o, 8, offset[1], offset[2]) end
            effects.emit(o, groundBlast)
            remove(o)
            return
        end
        if not o.run.freeze then
            o.drawH = -0x1000
            if o.direction < 0x40 then
                o.rotorClock = o.rotorClock - 1
                if o.rotorClock < 0 then
                    o.rotorClock, o.drawH = 2, -0xfc0
                    o.rotor = (o.rotor - 1 + (o.direction == 0 and -1 or 1)) % 4 + 1
                end
            end
        end
        groundFire(o)
        o.x, o.y = world(o.h, o.l)
    end

    function G.render(o)
        if not o.run.art then return end
        local images = ground.images[o.palette]
        local rotor, parts = images[1], images[2]
        draw(o, rotor[o.rotor], -0x1200, -0x800)
        draw(o, parts[1], o.drawH, -0x800)
        draw(o, parts[2], o.recoil and -0x1040 or -0x1000, -0x700)
        draw(o, parts[3], 0x600, (o.recoil and 0x280 or 0x2c0) + o.hatchShift)
        draw(o, parts[4], 0x600, (o.recoil and -0x680 or -0x6c0) - o.hatchShift)
    end

    local function hatch(o, index)
        o.hatchFrame = index
        o.right, o.left = unpack(battleship.boxes[index])
    end

    function B.init(o)
        o.flags, o.hp, o.front, o.back = 0xa000, 0x600, 0x1400, 0x1400
        o.basePalette, o.flashMask, o.palette = 18, 13, 18
        o.phase, o.attackClock, o.hatchClock = 0, 0x98, 0
        o.burst, o.protectionClock = 6, 0x212
        hatch(o, 1)
        o.right, o.left = 0x600, 0x600
        return path.attach(o)
    end

    local function battleshipFire(o)
        local run = o.run
        if run.freeze then return end
        if o.phase == 1 or o.phase == 3 and o.attackClock == 0 then
            o.hatchClock = o.hatchClock - 1
            if o.hatchClock >= 0 then return end
            o.hatchClock = 1
            if o.phase == 1 then
                hatch(o, o.hatchFrame + 1)
                if o.hatchFrame == #battleship.boxes then o.phase = 2 end
            else
                hatch(o, o.hatchFrame - 1)
                if o.hatchFrame == 1 then o.phase, o.attackClock = 0, band(0x20 - program.rank(run,0x1e,'cannonRank'), 0xff) end
            end
            return
        elseif o.phase == 3 or o.phase == 0 and o.h < 0x1000 then
            if o.phase == 3 then o.attackClock = o.attackClock - 1 end
            return
        end
        o.attackClock = o.attackClock - 1
        if o.attackClock >= 0 then return end
        if o.phase == 0 then
            o.phase, o.attackClock = 1, band(0x18 - program.rank(run,0x20,'tankRank'), 0xff)
            return
        end
        o.attackClock = run.difficulty <= 1 and 6 or 2
        local pilot = run.player
        if o.h >= 0x1000 and pilot and pilot.active then
            local aim = program.angle256(o.h + 0xa00, o.l, pilot.h, pilot.l, 0x80)
            local odd = o.burst % 2 ~= 0
            for ray = 0, odd and 5 or 6 do
                local a = aim + ray * 0x10 - (odd and 0x28 or 0x30)
                local offset = battleship.muzzles[band(a + 2, 0xfc) / 4 + 1]
                local h, l = program.addPacked(0xa00, 0, offset[1], offset[2])
                h, l = s16(o.h + h), s16(o.l + l)
                bullets.emitPrecise(run, 11, 0, a, h, l)
                if run.loop ~= 0 then
                    bullets.emitPrecise(run, 11, 6, a, h, l)
                end
            end
        end
        o.burst = o.burst - 1
        if o.burst < 0 then
            o.burst, o.phase, o.attackClock = 6, 3, band(0x18 - program.rank(run,0x20,'tankRank'), 0xff)
        end
    end

    function B.step(o)
        local run = o.run
        if o.sinking then
            if o.clearClock > 0 then
                bullets.clearWithFade(run, o.credit)
                o.clearClock = o.clearClock - 1
            end
            o.sinking = o.sinking + 1
        end
        if not path.step(o) then remove(o); return end
        if band(o.h + 0x1800, 0xffff) < 0xa000 then o.entered = true
        elseif o.entered or o.sinking then remove(o); return end
        if not o.sinking then
            if o.protectionClock >= 0 then
                o.protectionClock = o.protectionClock - (run.hyper and 2 or 1)
                o.hp = o.protectionClock < 0 and 0x600 or 0x7fff
            end
            local credit = hit(o, 0x180)
            if credit then
                hyper.kill(o.run,credit,256)
                o.credit = credit
                o.sinking, o.clearClock, o.flags, o.palette = 1, 100, 0x8080, o.basePalette
                effects.emit(o, battleshipBlast)
            else
                battleshipFire(o)
            end
        end
        o.x, o.y = world(o.h, o.l)
    end

    function B.render(o)
        if not o.run.art then return end
        local image = o.sinking and o.sinking > 24 and battleship.wreck
            or battleship.images[o.palette][o.hatchFrame]
        draw(o, image, -0x1a00, -0x1000)
    end

    function S.init(o)
        o.flags, o.hp, o.dropThreshold = 0xa000, 0x7fff, 0x7eff
        o.front, o.back, o.right, o.left = 0xc00, 0xc00, 0xc00, 0xc00
        o.basePalette, o.flashMask = unpack(supply.palettes[o.run.stageNumber])
        o.palette, o.dropCount, o.highGate = o.basePalette, o.run.loop == 0 and 1 or 0, true
        return path.attach(o)
    end

    function S.step(o)
        if o.deathClock then
            o.deathClock = o.deathClock - 1
            if o.deathClock < 0 then remove(o) end
            return
        end
        if not path.step(o) then remove(o); return end
        if band(o.h + 0x1000, 0xffff) < 0x9000 then o.entered = true
        elseif o.entered then remove(o); return end
        if o.highGate then
            if band(o.h, 0xffff) < 0x3c00 then
                o.highGate = false
                if o.earlyBreak then o.hp, o.dropThreshold = 0x400, 0x300
                elseif band(o.hp, 0xffff) >= 0x1000 then o.hp, o.dropThreshold = 0x1000, 0xf00 end
            elseif o.hp < 0 then
                o.hp, o.dropThreshold, o.dropCount = 0x7fff, 0x7eff, o.dropCount + 1
                o.earlyBreak = true
            end
        end
        local flags = band(o.flags, 0x5c00)
        local credit = hit(o, 0x400)
        if credit then
            hyper.kill(o.run,credit,32)
            o.flags, o.palette, o.deathClock = 0x8080, o.basePalette, 4
            effects.emit(o, supplyBlast)
        elseif flags ~= 0 and o.hp < o.dropThreshold then
            for _ = 0, o.dropCount do
                local offset = supply.offsets[program.dropSpeedRandom(o.run) + 1]
                items.emit(o, 0x10, 0x8c0, offset)
            end
            o.dropThreshold = s16(o.dropThreshold - 0x100)
        end
        o.x, o.y = world(o.h, o.l)
    end

    function S.render(o)
        if o.run.art then draw(o, supply.images[o.palette], -0x1000, -0xb00) end
    end

    return G, B, S
end
