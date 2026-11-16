-- 0x163034 在击破炮身后保留底座。0x16526e 按舱门开度改变横向判定。
return function(program, path, bullets, effects, remove, hyper)
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local floor = math.floor
    local s16, world = program.s16, program.world
    local bunkers,hatches = program.stage3Bunkers,program.stage3Hatches
    local B,H = {parts=1},{parts=1}

    local function damage(o, amount, flags)
        o.hp,o.flags = s16(o.hp - amount),bor(o.flags,flags)
    end
    B.damage,H.damage = damage,damage

    local function draw(o, id, dh, dl)
        local image = o.run.art[id]
        local x,y = world(s16(o.h + dh),s16(o.l + dl))
        Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2)
    end

    function B.init(o)
        local p = bunkers.profiles[o.kind - 0x36]
        o.profile = p
        o.flags,o.front,o.back,o.right,o.left,o.hp = 0xa000,unpack(p[5])
        o.face,o.palette,o.rotor = 0,19,0
        o.fireClock,o.rounds,o.burstClock = p[4][1],0,4
        if not path.attach(o) then return false end
        o.h,o.l = s16(o.h + p[3][1]),s16(o.l + p[3][2])
        return true
    end

    local function bunkerFire(o,pilot)
        local run = o.run
        local dh,dl = unpack(o.profile[2])
        local target = program.angle(s16(o.h + dh),s16(o.l + dl),pilot.h,pilot.l,o.face)
        o.face = program.turn64(o.face,target)
        if o.rounds == 0 then
            o.fireClock = o.fireClock - 1
            if o.fireClock >= 0 then return end
            o.fireClock = band(0x18 - program.rank(run,0x20,'groundRank'),0xff)
            o.rounds = band(4 - floor(program.rank(run,0x20,'groundRank') / 8),0xff)
        end
        o.burstClock = o.burstClock - 1
        if o.burstClock >= 0 then return end
        o.burstClock = 4
        if not program.inAimHeight(run,o.h) then return end
        local muzzle = bunkers.muzzles[band(o.face + 1,0x3e) / 2 + 1]
        local h,l = program.addPacked(dh,dl,muzzle[1],muzzle[2])
        h,l = s16(o.h + h),s16(o.l + l)
        local angle = band(o.face + 1,0x3e) * 4
        bullets.emitPrecise(run,0x16,10,angle,h,l)
        if run.loop == 0 then
            bullets.emitPrecise(run,0x16,10,angle + 2,h,l)
            bullets.emitPrecise(run,0x16,10,angle - 2,h,l)
        else
            bullets.emitPrecise(run,0x16,10,angle - 6,h,l)
            bullets.emitPrecise(run,0x16,10,angle + 10,h,l)
            bullets.emitPrecise(run,0x16,10,angle - 10,h,l)
            bullets.emitPrecise(run,0x16,10,angle + 6,h,l)
        end
        o.rounds = band(o.rounds - 1,0xff)
    end

    function B.step(o)
        local run = o.run
        if o.h >= -0x1800 then o.entered = true
        elseif o.entered then remove(o); return end
        o.h = s16(o.h - run.groundScroll)
        local flags = band(o.flags,0x5c00)
        if flags == 0 then
            o.palette = 19
        else
            o.palette,o.flags = bxor(o.palette,12),band(o.flags,0xa3ff)
            hyper.hit(o,flags)
            if o.hp < 0 then
                hyper.kill(o.run,flags,47)
                o.flags,o.broken,o.palette = 0x8000,true,19
                local dh,dl = unpack(o.profile[2])
                local h,l = program.addPacked(dh,dl,-0x800,-0x500)
                effects.emit(o,{{0x84,4,h,l,0x4,0x38,scrolls=true}})
            end
        end
        if not o.broken then
            local pilot = run.player
            if pilot and pilot.active then bunkerFire(o,pilot) end
            o.rotor = (o.rotor + 1) % 4
        end
        o.x,o.y = world(o.h,o.l)
    end

    function B.render(o)
        if not o.run.art then return end
        local base,h,l = unpack(o.profile[1])
        draw(o,base,h,l)
        if not o.broken then
            h,l = unpack(o.profile[2])
            local index = band(o.face + 1,0x3e) * 2 + o.rotor + 1
            draw(o,bunkers.guns[o.palette][index],h - 0xc00,l - 0xa00)
        end
    end

    function H.init(o)
        o.flags,o.hp = 0xa001,0xc00
        o.front,o.back,o.right,o.left = 0x880,0x880,0x800,0x800
        o.phase,o.spread,o.palette = 0,0,17
        o.openClock,o.shotClock,o.round,o.modifier = 0x40,0,0,0
        return path.attach(o)
    end

    local function hatchFire(o)
        local run = o.run
        local late = run.major >= 0x100
        local last = late and 8 or 4
        local fixed = hatches.fireAt[o.round + (late and 5 or 1)] == 1
        local pilot = run.player
        for index, at in ipairs(hatches.muzzles) do
            local h,l = s16(o.h + at[1]),s16(o.l + at[2])
            if fixed then
                local a = hatches.angles[index]
                local function fixedShot(speed, split)
                    if split and run.loop ~= 0 then
                        bullets.emitPrecise(run,11,speed,a - 8,h,l)
                        bullets.emitPrecise(run,11,speed,a + 8,h,l)
                    else bullets.emitPrecise(run,11,speed,a,h,l) end
                end
                if run.difficulty == 4 then
                    for speed = -4,12,4 do fixedShot(speed,speed % 8 == 0) end
                else fixedShot(6,true) end
            elseif pilot and pilot.active then
                local a = program.angle(h,l,pilot.h,pilot.l,0x20)
                bullets.emit(run,5,o.modifier + (run.loop == 0 and 4 or 8),a,h,l)
            end
        end
        o.modifier,o.round = o.modifier + (last == 4 and 3 or 2),o.round + 1
        if o.round == last then o.phase = 3 end
    end

    function H.step(o)
        if o.h >= -0x1000 then o.entered = true
        elseif o.entered then remove(o); return end
        if not path.step(o) then remove(o); return end
        local flags = band(o.flags,0x5c00)
        if flags == 0 then
            o.palette = 17
        else
            o.flags,o.palette = band(o.flags,0xa3ff),bxor(o.palette,14)
            hyper.hit(o,flags)
            if not o.unlocked then o.hp = 0xc00 end
            if o.hp < 0 then
                hyper.kill(o.run,flags,72)
                for _, cmd in ipairs(hatches.wreck) do
                    effects.emit(o,{{cmd[2],cmd[1],cmd[4],cmd[5],scrolls=true}})
                end
                remove(o)
                return
            end
        end
        if not o.run.freeze then
            if o.phase == 3 then
                o.spread = o.spread - 0x40
                if o.spread == 0 then o.phase = 0 end
            end
            if o.phase == 2 then
                o.unlocked = true
                o.shotClock = o.shotClock - 1
                if o.shotClock < 0 then o.shotClock=8; hatchFire(o) end
            end
            if o.phase == 1 then
                o.spread = o.spread + 0x40
                if o.spread == 0x380 then o.phase,o.round,o.modifier = 2,0,1 end
            end
            if o.phase == 0 then
                o.openClock = o.openClock - 1
                if o.openClock < 0 then o.phase,o.openClock=1,0x10 end
            end
            o.right,o.left = 0x800 + o.spread,0x800 + o.spread
        end
        o.x,o.y = world(o.h,o.l)
    end

    function H.render(o)
        if not o.run.art then return end
        local imgs = hatches.images[o.palette]
        draw(o,imgs[1],-0xe00,-0x700)
        draw(o,imgs[2],-0xf41-o.spread,-0x9c0-o.spread)
        draw(o,imgs[3],-0xf40-o.spread,-0x80+o.spread)
    end

    return B,H
end
