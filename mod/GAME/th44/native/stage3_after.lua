-- 0x1656c0 的两种发射模式与 0x1734f8 飞船的独立主炮、尾炮计时。
return function(program, path, bullets, effects, remove, hyper)
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local s16, world = program.s16, program.world
    local floor, min = math.floor, math.min
    local data = program.stage3After
    local T,F,P = {parts=1},{parts=2},{parts=1}

    local function aim(o, dh, precise, current)
        local pilot = o.run.player
        if not pilot or not pilot.active then return end
        local angle = precise and program.angle256 or program.angle
        return angle(s16(o.h + dh),o.l,pilot.h,pilot.l,current)
    end

    local function draw(o, sprite, dh, dl)
        local image = o.run.art[sprite]
        local x,y = world(s16(o.h + dh),s16(o.l + dl))
        Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2)
    end

    local function damage(o, amount, flags)
        o.hp,o.flags = s16(o.hp - amount),bor(o.flags,flags)
    end
    T.damage,F.damage = damage,damage

    function T.init(o)
        local alternate = o.run.difficulty == 4
        o.flags,o.hp = alternate and 0xa200 or 0xa201,0xc0
        o.front,o.back,o.right,o.left = 0x280,0x680,0x500,0x500
        o.basePalette,o.flashMask = alternate and 15 or 16,alternate and 16 or 15
        o.palette = o.basePalette
        o.swing,o.shift,o.pose,o.poseClock = 0,0,0,1
        o.rounds,o.shotClock = 2,0
        if not path.attach(o) then return false end
        o.face = aim(o,0,false,o.direction) or o.direction
        return true
    end

    local function fireTurret(o)
        local run = o.run
        if o.h <= 0x1400 then return end
        if o.rounds == 2 then
            local face = aim(o,0x3c0,false,o.face)
            if face then o.face = program.turn64(o.face,face) end
        end
        o.shotClock = o.shotClock - 1
        if o.shotClock >= 0 then return end
        o.shotClock = 8
        if run.difficulty == 4 then
            local a = aim(o,0x3c0,true,0x80)
            if not a then return end
            local at = data.gunMuzzles[band(a,0xf8) / 8 + 1]
            local h,l = s16(o.h + at[1]),s16(o.l + at[2])
            a = band(a + 4,0xf8)
            bullets.emitPrecise(run,7,-4,a,h,l)
            if run.loop ~= 0 then bullets.emitPrecise(run,7,2,a,h,l) end
        else
            local a = band(o.face + 1,0x3e)
            local at = data.gunMuzzles[a / 2 + 1]
            local h,l = s16(o.h + at[1]),s16(o.l + at[2])
            local base = band(o.face + 2,0x3c)
            bullets.emit(run,12,4,base,h,l)
            if run.loop == 0 then bullets.emit(run,13,-2,a,h,l)
            else
                bullets.emitPrecise(run,13,-2,a * 4 - 8,h,l)
                bullets.emitPrecise(run,13,-2,a * 4 + 8,h,l)
            end
        end
        o.rounds = o.rounds - 1
        if o.rounds < 0 then
            o.rounds = 2
            o.shotClock = band(10 - floor(program.rank(run,0x20,'groundRank') / (run.difficulty == 4 and 2 or 4)),0xff)
        end
    end

    function T.step(o)
        local run = o.run
        o.h = s16(o.h - o.shift)
        if not path.step(o,run.groundScroll) then remove(o); return end
        local inside = band(o.h + 0x800,0xffff) < 0x8000
            and band(o.l + run.cameraOffset + 0x1c00,0xffff) < 0x7000
        if inside then o.entered = true
        elseif o.entered then remove(o); return end
        if run.difficulty ~= 4 then
            o.shift = program.vector(0x28,o.swing)
            o.swing = band(o.swing + 2,0xff)
            o.h = s16(o.h + o.shift)
        end
        local flags = band(o.flags,0x5c00)
        if flags == 0 then o.palette = o.basePalette
        else
            o.palette,o.flags = bxor(o.basePalette,o.flashMask),band(o.flags,0xa3ff)
            hyper.hit(o,flags)
            if o.hp < 0 then
                hyper.kill(o.run,flags,31)
                effects.emit(o,{{2,0,0,0,o.speed,o.direction * 4}})
                remove(o)
                return
            end
        end
        fireTurret(o)
        o.poseClock = o.poseClock - 1
        if o.poseClock < 0 then o.poseClock,o.pose = 1,1 - o.pose end
        o.x,o.y = world(o.h,o.l)
    end

    function T.render(o)
        if not o.run.art then return end
        local images = data.cannon[o.palette][o.pose + 1]
        draw(o,images[band(o.face + 1,0x3e) / 2 + 1],-0xa00,-0x600)
    end

    function F.init(o)
        local run = o.run
        local hp = run.difficulty == 4 and (run.major > 0x2e0 and 0xe80 or 0x1000) or 0x1700
        o.flags,o.hp = 0xa001,hp
        o.front,o.back,o.right,o.left = 0xc00,0xa00,0x900,0x900
        local part = o.extraParts[1]
        part.flags,part.hp = 0xa001,0x1700
        part.front,part.back,part.right,part.left = 0,0xb00,0xc80,0xc80
        o.basePalette,o.flashMask = unpack(data.airshipPalettes[run.stageNumber])
        o.palette = o.basePalette
        o.frontClock,o.backClock,o.salvoIndex,o.salvoCount = 0x30,0x10,#data.airshipSalvo,3
        if not path.attach(o) then return false end
        part.h,part.l = o.h,o.l
        return true
    end

    local function fan(o, angle)
        local run = o.run
        local kind = run.difficulty == 4 and 12 or 11
        for a = angle - 20,angle + 20,10 do
            local offset = program.mid3.wingMuzzles[band(a + 2,0xfc) / 4 + 1]
            local h,l = s16(o.h - 0x200 + offset[1]),s16(o.l + offset[2])
            bullets.emitPrecise(run,kind,-3,a,h,l)
            if run.loop ~= 0 then bullets.emitPrecise(run,kind,3,a,h,l) end
        end
    end

    local function airshipCannons(o)
        local run = o.run
        if run.freeze or run.enemyShotGrace > 0 or o.h < 0x1000 then return end
        local pilot = run.player
        local away = not pilot or not pilot.active or math.abs(s16(o.l - pilot.l)) >= 0xc00
        if away or run.difficulty == 4 then
            o.frontClock = o.frontClock - 1
            if o.frontClock < 0 then
                o.frontClock = run.loop == 0 and run.difficulty < 4 and 0x18 or 0x10
                local a = aim(o,-0x200,true,0x80)
                if a then
                    fan(o,a)
                    if run.difficulty == 4 then
                        o.salvoCount = o.salvoCount - 1
                        if o.salvoCount < 0 then o.salvoCount,o.frontClock = 3,0x40 end
                    end
                end
            end
        end
        if not o.tailActive then
            if away and run.difficulty ~= 4 then o.backClock = 0x10
            else
                o.backClock = o.backClock - 1
                if o.backClock < 0 then o.tailActive,o.backClock = true,0x10 end
            end
            return
        end
        local height = data.airshipSalvo[o.salvoIndex][1]
        if height ~= -1 then
            o.tailHeight,o.salvoIndex = height,o.salvoIndex - 1
            if o.salvoIndex == 0 then
                o.salvoIndex,o.tailActive,o.backClock = #data.airshipSalvo,false,0x10
            end
            return
        end
        o.backClock = o.backClock - 1
        if o.backClock >= 0 then return end
        o.salvoIndex = o.salvoIndex - 1
        for side = 1,2 do
            local sign = side == 1 and -1 or 1
            local base = side == 1 and 0x7e or 0x7f
            local shift = side == 1 and 0x540 or -0x540
            for i = 0,5 do
                local a = base + program.dropSpeedRandom(run)
                local speed = -6 + i * (run.difficulty == 4 and 3 or 4)
                local at = data.airshipMuzzles[band(a + 2,0xfc) / 4 + 1]
                local h,l = program.addPacked(o.tailHeight,shift,at[1],at[2])
                h,l = s16(o.h + h),s16(o.l + l)
                bullets.emitPrecise(run,4,speed,a,h,l)
                if i >= 1 then
                    if run.loop == 0 then bullets.emitPrecise(run,4,speed,a + sign * 0x10,h,l)
                    else
                        bullets.emitPrecise(run,4,speed,a + sign * 0x10 - 8,h,l)
                        bullets.emitPrecise(run,4,speed,a + sign * 0x10 + 8,h,l)
                    end
                end
                if i >= 2 then
                    at = data.airshipMuzzles[band(a + sign * 0x10 + 2,0xfc) / 4 + 1]
                    h,l = program.addPacked(o.tailHeight,shift,at[1],at[2])
                    bullets.emitPrecise(run,4,speed,a + sign * 0x20,s16(o.h + h),s16(o.l + l))
                end
            end
        end
    end

    function F.step(o)
        local run = o.run
        if not path.step(o,run.groundScroll) then remove(o); return end
        local inside = band(o.l + run.cameraOffset + 0x1600,0xffff) < 0x6400
            and band(o.h + 0x1200,0xffff) < 0x8a00
        if inside then o.entered = true
        elseif o.entered then remove(o); return end
        local part = o.extraParts[1]
        part.h,part.l = o.h,o.l
        local flags = band(bor(o.flags,part.flags),0x5c00)
        if flags == 0 then o.palette = o.hp < 0x5c0 and 25 or o.basePalette
        else
            o.flags,part.flags = band(o.flags,0xa3ff),band(part.flags,0xa3ff)
            hyper.hit(o,flags)
            o.palette = bxor(o.palette == 25 and o.basePalette or o.palette,o.flashMask)
            o.hp = min(o.hp,part.hp)
            part.hp = o.hp
            if o.hp < 0 then
                hyper.kill(o.run,flags,320)
                effects.emit(o,{{5,0,-0xa00,-0x600,4,0xa0,flip=true},
                    {5,0,-0xa00,0x500,4,0x60},{13,0,-0x600,0}})
                remove(o)
                return
            end
        end
        airshipCannons(o)
        o.x,o.y = world(o.h,o.l)
    end

    function F.render(o)
        if not o.run.art then return end
        draw(o,data.airshipTail,-0x2a00,0x900)
        draw(o,data.airship[o.palette],-0xe00 + (o.tailHeight or 0),-0xc00)
    end

    -- 0x165ab2 只写入由后续敌机消费的脉冲位。
    function P.init(o)
        o.h,o.l,o.flags = 0x3800,0x1c00,0x8000
        o.clock,o.round = 4,3
        return true
    end

    function P.step(o)
        o.run.stage3Pulse = false
        o.clock = o.clock - 1
        if o.clock >= 0 then return end
        o.clock,o.run.stage3Pulse = 4,true
        o.round = o.round - 1
        if o.round < 0 then o.round,o.clock = 3,0x10 end
    end

    function P.render() end

    return T,F,P
end
