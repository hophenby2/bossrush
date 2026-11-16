-- 0x166abe、0x167158。路径、朝向和发射计数由各自的敌机对象保存。
return function(program, path, bullets, remove, hyper)
    local bit = require('bit')
    local band, bor = bit.band, bit.bor
    local floor = math.floor
    local s16, world = program.s16, program.world
    local M = {parts=1}

    function M.init(o)
        local run = o.run
        o.flags = 0xa200
        if o.kind == 0x10 then
            o.hp, o.front, o.back, o.right, o.left = 0xc0, 0x600, 0x6c0, 0x540, 0x540
            o.attackClock = band(0x50 - program.rank(run,0x18,'largeRank'), 0xff)
            o.trackClock, o.trackInterval = 1, band(1 - floor(program.rank(run,0x20,'trackRank') / 16), 0xff)
            o.salvoLength = 2 + floor(run.difficulty / 2)
            o.salvoCount = o.salvoLength
        else
            o.hp, o.front, o.back, o.right, o.left = 0x38, 0x480, 0x600, 0x440, 0x440
            o.attackClock = band(0x60 - program.rank(run,0x16,'enemyRank') + floor(program.randomEnemy(run) / 2), 0xff)
            o.trackClock, o.trackInterval = band(1 - floor(program.rank(run,0x20,'trackRank') / 16), 0xff), 1
            if run.difficulty == 1 and run.major >= 0x159 then o.attackClock = band(0x2a - program.rank(run,0x1e,'lateRank'), 0xff) end
        end
        if not path.attach(o) then return end
        o.face = band(o.direction, 0x3f)
        o.entered, o.damaged = false, false
        return true
    end

    local function inView(o)
        if o.kind == 0x10 then
            return band(o.l + 0x1200 + o.run.cameraOffset, 0xffff) < 0x5c00
                and band(o.h + 0xa00, 0xffff) < 0x8400
        end
        local h, l = o.h, o.l + 0xe00 + o.run.cameraOffset
        -- 0x16715e 只在首次进入后因离开范围而回收敌机。
        return band(l, 0xffff) < 0x5400 and band(h + 0x600, 0xffff) < 0x7c00
    end

    local function canFire(o, pilot)
        local run = o.run
        if not program.inAimBounds(run, o.h, o.l) then return false end
        return program.pilotDistance(o, pilot) >= program.aimDistances[run.difficulty + 1]
    end

    local function shoot(o, pilot)
        local run = o.run
        if o.kind == 0x10 then
            -- 0x166cc0 在一组的首发要求炮口和瞄准角落在同一档。
            o.attackClock = band(0x18 - program.rank(run,0x20,'trackRank'), 0xff)
            if not pilot or not canFire(o, pilot) or run.difficulty == 1 and run.disableScoutShot then return end
            local target = program.angle(o.h + 0x200, o.l, pilot.h, pilot.l, o.face)
            local angle = band(o.face + 2, 0x3c)
            if o.salvoCount == o.salvoLength and band(target + 2, 0x3c) ~= angle then return end
            o.attackClock = 7
            o.salvoCount = o.salvoCount - 1
            if o.salvoCount < 0 then
                o.salvoCount = o.salvoLength
                o.attackClock = band(0x40 - program.rank(run,0x1c,'salvoRank'), 0xff)
            end
            local offset = program.muzzles[0x10][band(o.face + 1, 0x3e) / 2 + 1]
            local h, l = program.addPacked(o.h, o.l, offset[1] + 0x200, offset[2])
            bullets.emit(run, 0x0c, run.loop == 0 and 0 or 4, angle, h, l)
            return
        end
        o.attackClock = band(0xa4 - program.rank(run,0x0e,'fireRank'), 0xff)
        if run.loop == 0 and run.difficulty == 1 and run.major >= 0x159 then
            o.attackClock = band(0x2a - program.rank(run,0x1e,'lateRank'), 0xff)
        end
        if not pilot or not canFire(o, pilot) or run.difficulty == 1 and run.disableScoutShot then return end
        local angle = band(o.face + 2, 0x3c)
        local offset = program.muzzles[0x11][angle / 4 + 1]
        local h, l = program.addPacked(o.h, o.l, offset[1] + 0x200, offset[2])
        local modifier = (run.difficulty >= 3 and -4 or 0) + (run.loop == 0 and 0 or 4)
        bullets.emit(run, 0x0d, modifier, angle, h, l)
    end

    function M.step(o)
        local run = o.run
        if not path.step(o) then remove(o); return end
        if inView(o) then o.entered = true
        elseif o.entered then remove(o); return end
        local flags = band(o.flags,0x5c00)
        if flags ~= 0 then
            o.flags, o.flash = band(o.flags, 0xa3ff), true
            hyper.hit(o,flags)
            if o.hp < 0 then
                hyper.kill(run,flags,o.damaged and 10 or 8)
                if o.damaged then remove(o); return end
                o.hp, o.damaged = o.kind == 0x10 and 0xe0 or 0x70, true
                if o.kind == 0x10 then o.flags = band(o.flags, 0xfdff) end
            end
        else
            o.flash = false
        end
        if not o.damaged then
            local pilot = run.player
            if pilot and pilot.active == false then pilot = nil end
            if not run.freeze then
                o.trackClock = o.trackClock - 1
                local returning = o.trackClock < 0
                if returning then
                    o.trackClock = o.trackInterval
                    if pilot then
                        local target = program.angle(o.h + 0x200, o.l, pilot.h, pilot.l, o.face)
                        local diff = band(target - o.face, 0x3f)
                        if diff ~= 0 then o.face = band(o.face + (diff < 0x20 and 1 or -1), 0x3f) end
                    end
                end
                if (not returning or pilot) and band(o.flags, 0x2000) ~= 0 then
                    o.attackClock = band(o.attackClock - 1, 0xff)
                    if o.attackClock == 0 then shoot(o, pilot) end
                end
            end
        end
        o.x, o.y = world(o.h, o.l)
    end

    function M.render(o)
        if not o.run.art then return end
        local color = o.flash and 2 or 1
        local frame = band(o.direction, 0x3e)
        local shine = band(o.direction, 0x40) == 0 and band(o.run.frame, 4) ~= 0 and 1 or 0
        local images = program.aircraft[o.kind]
        local large = o.kind == 0x10
        local hull = o.run.art[images.body[color][frame + shine + 1]]
        local x, y = world(o.h - (large and 0x800 or 0x600), o.l - (large and 0x600 or 0x400))
        Render(hull[1], floor(x) + hull[2] / 2, floor(y) + hull[3] / 2)
        if not o.damaged then
            local turret = o.run.art[images.turret[color][band(o.face + 1, 0x3e) / 2 + 1]]
            local offset = large and 0x600 or 0x400
            x, y = world(o.h - offset, o.l - offset)
            Render(turret[1], floor(x) + turret[2] / 2, floor(y) + turret[3] / 2)
        end
    end

    function M.damage(o, amount, attackFlags)
        o.hp = s16(o.hp - amount)
        o.flags = bor(o.flags, attackFlags)
    end

    return M
end
