-- 第四面后段的地面炮塔与背景机械使用独立的原版路径。
return function(program, path, bullets, effects, items, remove, hyper)
    local bit = require('bit')
    local band,bor,bxor = bit.band,bit.bor,bit.bxor
    local s16,world = program.s16,program.world
    local floor = math.floor
    local data = program.stage4Late
    local Tower,Scenery = {parts=2},{parts=1}

    local function draw(o,id,dh,dl)
        local image = o.run.art[id]
        local x,y = world(s16(o.h + dh),s16(o.l + dl))
        Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2)
    end

    function Tower.damage(o,amount,flags)
        o.flags,o.hp = bor(o.flags,flags),s16(o.hp - amount)
    end

    function Tower.init(o)
        local run = o.run
        o.flags,o.palette = 0x8000,10
        if not path.attach(o) then return false end
        o.l = s16(0x1c00 - run.cameraOffset)
        local gun = o.extraParts[1]
        o.gun = gun
        gun.flags,gun.hp,gun.palette = 0xa000,0x1e00,12
        gun.h,gun.l = o.h,o.l
        gun.front,gun.back,gun.right,gun.left = 0xc00,0x800,0x600,0x800
        o.shift = floor(program.bossJitter(run) / 2)
        o.drift = program.bossWideRandom(run) < 0x80 and 0x80 or -0x80
        o.clock = band(0x20 - (program.bossRandom(run) + 7) * 2,255)
        o.phase,o.pose,o.hatchClock,o.burst = 0,0,0,7
        o.sideClock,o.sideBurst,o.wreckClock = 0x10,6,0x15
        return true
    end

    local function sideFire(o)
        o.sideClock = o.sideClock - 1
        if o.sideClock >= 0 then return end
        local run,pilot = o.run,o.run.player
        o.sideClock = run.loop == 0 and 0x12 or 0x16
        if not pilot or not pilot.active then return end
        local l = s16(o.l + o.shift - 0x100)
        for wave = 0,1 do
            for i = 0,3 do
                local angle = (run.loop == 0 and 0x75 or 0x70) + wave * (run.loop == 0 and 0x12 or 0x1c) + i * 2
                if run.loop == 0 then bullets.emitPrecise(run,0x13,-3,angle,o.h,l)
                else
                    bullets.emitPrecise(run,0x13,-3,angle - 8,o.h,l)
                    bullets.emitPrecise(run,0x13,-3,angle + 8,o.h,l)
                end
            end
        end
        o.sideBurst = o.sideBurst - 1
        if o.sideBurst < 0 then o.sideBurst,o.sideClock = 6,0x10 end
    end

    local function fire(o)
        local run,pilot = o.run,o.run.player
        if o.burst == 7 then
            o.bearings = nil
            if not pilot or not pilot.active then return end
            local h,l = s16(o.h + 0x800),s16(o.l + o.shift - 0x100)
            o.bearings = data.bearings[band(pilot.h,0xffff) < band(h,0xffff) and 1 or 2]
            o.aim = program.angle256(h,l,pilot.h,pilot.l,0)
        end
        if not o.bearings then return end
        local angle = o.aim
        for i, delta in ipairs(o.bearings) do
            local h = s16(o.h + (i < 3 and 0x800 or 0x600))
            local l = s16(o.l + o.shift + ((i == 1 or i == 4) and -0x480 or 0x280))
            angle = angle + delta
            bullets.emitPrecise(run,0x16,run.loop == 0 and 8 or 12,angle,h,l)
        end
    end

    local function updateAttack(o)
        local run = o.run
        if o.phase == 0 then
            sideFire(o)
            o.clock = o.clock - 1
            if o.clock < 0 then o.phase,o.clock = 1,0x10 end
        elseif o.phase == 2 then
            o.clock = o.clock - 1
            if o.clock >= 0 then return end
            o.clock = 2
            fire(o)
            o.burst = o.burst - 1
            if o.burst < 0 then o.phase,o.clock,o.burst = 3,1,7 end
        else
            if o.phase == 3 and o.clock > 0 then o.clock = o.clock - 1; return end
            o.hatchClock = o.hatchClock - 1
            if o.hatchClock >= 0 then return end
            o.hatchClock = 1
            if o.phase == 1 then
                o.pose = o.pose + 1
                if o.pose == 7 then o.phase = 2 end
            else
                o.pose = o.pose - 1
                if o.pose == 0 then
                    o.phase,o.clock = 0,band(0x80 - program.rank(run,0x1e,'cannonRank'),255)
                    o.sideClock,o.sideBurst = 0x10,6
                end
            end
        end
    end

    local function wreckPart(o,dl)
        local run = o.run
        effects.emit(o,{{12,8,-0x200,dl,scrolls=true}})
        if run.loop == 0 then
            if o.phase ~= 0 then
                items.emit(o,8,0,dl + 0x200)
                items.emit(o,8,0,dl - 0x200)
            end
        else
            bullets.emitPrecise(run,0x13,-8,0x80,o.h,s16(o.l + dl + 0x200))
            bullets.emitPrecise(run,0x13,-8,0x80,o.h,s16(o.l + dl - 0x200))
        end
    end

    local function updateWreck(o)
        o.wreckBurst = o.wreckBurst - 1
        if o.wreckBurst < 0 then
            o.wreckBurst = 2
            if s16(o.l + o.wreckLeft) >= -0x800 then
                wreckPart(o,o.wreckLeft)
                o.wreckLeft = o.wreckLeft - 0x800
            end
            if band(o.l + o.wreckRight,0xffff) <= 0x4000 then
                wreckPart(o,o.wreckRight)
                o.wreckRight = o.wreckRight + 0x800
            end
        end
        o.wreckClock = o.wreckClock - 1
        if o.wreckClock == 0 then remove(o) end
    end

    function Tower.step(o)
        local gun,run = o.gun,o.run
        if o.dying then
            o.h = s16(o.h - run.groundScroll)
            gun.h,gun.l = o.h,s16(o.l + o.shift)
            updateWreck(o)
            return
        end
        if not path.step(o,run.groundScroll) then remove(o); return end
        if band(o.h + 0xe00,0xffff) < 0x8c00 then o.entered = true
        elseif o.entered then remove(o); return end
        o.x,o.y = world(o.h,o.l)
        gun.h,gun.l = o.h,s16(o.l + o.shift)
        local flags = band(gun.flags,0x5c00)
        if flags == 0 then
            o.palette,gun.palette = gun.hp < 0x780 and 25 or 10,gun.hp < 0x780 and 25 or 12
        else
            gun.flags = band(gun.flags,0xa3ff)
            hyper.hit(o,flags)
            o.palette = bxor(o.palette == 25 and 10 or o.palette,21)
            gun.palette = bxor(gun.palette == 25 and 12 or gun.palette,19)
            if gun.hp < 0 then
                hyper.kill(run,flags,88)
                o.flags,gun.flags,o.palette,gun.palette = 0x8080,0x8000,10,12
                o.dying,o.wreckBurst = true,0
                o.wreckLeft,o.wreckRight = o.shift - 0x800,o.shift + 0x800
                if run.loop == 0 and o.phase ~= 0 then items.emit(o,0xc,0,o.shift) end
                effects.emit(o,{{13,12,-0x600,o.shift,scrolls=true}})
                updateWreck(o)
                return
            end
        end
        if not run.freeze then
            local firing = o.h >= 0x1000 and o.phase == 2
            if o.h >= 0x1000 then updateAttack(o) end
            if not firing then
                o.shift = o.shift + o.drift
                if o.shift < -0x1400 or o.shift > 0x1400 then o.drift = -o.drift end
            end
        end
        gun.l = s16(o.l + o.shift)
        gun.x,gun.y = world(gun.h,gun.l)
    end

    function Tower.render(o)
        if not o.run.art then return end
        draw(o,data.towerTop[o.palette][1],-0x800,-0x2400)
        draw(o.gun,data.towerGun[o.gun.palette][o.pose + 1],-0xe00,-0x900)
    end

    function Scenery.init(o)
        o.flags,o.pose = 0x8000,16
        return path.attach(o)
    end

    function Scenery.step(o)
        if not path.step(o,o.run.groundScroll) then remove(o); return end
        if band(o.h + 0x3800,0xffff) < 0xe000 then o.entered = true
        elseif o.entered then remove(o); return end
        o.frame,o.pose = o.pose,(o.pose - 2) % 16 + 1
        o.x,o.y = world(o.h,o.l)
    end

    function Scenery.render(o)
        if o.run.art then draw(o,data.scenery[18][o.frame],-0x3a00,-0x2200) end
    end

    return Tower,Scenery
end
