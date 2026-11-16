-- 0x17302e。两侧固定管和转动炮塔采用独立的发射计时。
return function(program, path, bullets, effects, remove, hyper)
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local min, floor = math.min, math.floor
    local s16, world = program.s16, program.world
    local M = {parts=2}
    local fixedOffsets = {-0x540, 0x500}
    local destruction = {{13,0,-0xa00,0}, {8,0,-0xa00,0,6,0x80,flip=true}}

    local function placePart(o)
        local part = o.extraParts[1]
        part.h, part.l = o.h, o.l
        part.x, part.y = world(part.h, part.l)
        o.x, o.y = part.x, part.y
    end

    function M.init(o)
        local run, part = o.run, o.extraParts[1]
        if run.difficulty == 0 and run.mid1 and not run.mid1.released then return false end
        if run.difficulty == 4 and run.mid1Defeated then return false end
        o.flags, part.flags = 0xa001, 0xa000
        o.hp, part.hp = 0x200, 0x200
        o.front, o.back, o.right, o.left = 0x600, 0x800, 0x600, 0x600
        part.front, part.back, part.right, part.left = 0x800, 0xc00, 0x800, 0x800
        o.mainClock = band(0x40 - program.rank(run,0x1c,'salvoRank'), 0xff)
        o.turretClock = band(0x54 - program.rank(run,0x1c,'salvoRank') - (run.loop ~= 0 and 0x10 or 0), 0xff)
        o.mainCount, o.turretCount, o.trackClock = 3, 3, 1
        o.palette = (run.difficulty == 1 or run.difficulty == 2) and 18 or 12
        if not path.attach(o) then return false end
        local pilot = run.player
        o.face = band(o.direction, 0x3f)
        if pilot and pilot.active then o.face = program.angle(o.h + 0x240, o.l, pilot.h, pilot.l, o.face) end
        o.fixedAngles = {o.face * 4, o.face * 4}
        placePart(o)
        return true
    end

    local function fireFixed(o, pilot)
        local run = o.run
        o.mainClock = 4
        local first = o.mainCount == 3
        local h = s16(o.h - 0x840)
        if first and not pilot then return end
        for i, offset in ipairs(fixedOffsets) do
            local l = s16(o.l + offset)
            if first then o.fixedAngles[i] = program.angle256(h, l, pilot.h, pilot.l, o.fixedAngles[i]) end
            local angle = o.fixedAngles[i]
            if first and run.difficulty >= 3 then
                local sign = i == 1 and 1 or -1
                local extra = run.loop ~= 0 and 4 or 0
                bullets.emitPrecise(run, 0x0d, -1 + extra, angle + 2 * sign, h, l)
                bullets.emitPrecise(run, 0x0d, -3 + extra, angle + 7 * sign, h, l)
            elseif run.loop == 0 then
                bullets.emitPrecise(run, 0x0c, 5, angle, h, l)
            else
                bullets.emitPrecise(run, 0x0c, 5, angle - 8, h, l)
                bullets.emitPrecise(run, 0x0c, 5, angle + 8, h, l)
            end
        end
        o.mainCount = o.mainCount - 1
        if o.mainCount < 0 then
            o.mainCount, o.mainClock = 3, band(0x6c - program.rank(run,0x16,'rapidRank'), 0xff)
        end
    end

    local function fireTurret(o)
        local run = o.run
        o.turretClock = 5
        local delta = program.muzzles[0x85][band(o.face, 0x3e) / 2 + 1]
        local h, l = s16(o.h + 0x240 + delta[1]), s16(o.l + delta[2])
        if run.loop == 0 then
            bullets.emit(run, 7, 4, o.face, h, l)
        else
            bullets.emitPrecise(run, 7, 6, o.face * 4, h, l)
            bullets.emitPrecise(run, 7, 4, o.face * 4 - 8, h, l)
            bullets.emitPrecise(run, 7, 4, o.face * 4 + 8, h, l)
        end
        o.turretCount = o.turretCount - 1
        if o.turretCount < 0 then
            o.turretCount, o.turretClock = 3, band(0x64 - program.rank(run,0x18,'largeRank'), 0xff)
        end
    end

    local function attack(o)
        local run = o.run
        if run.freeze or run.enemyShotGrace > 0 then return end
        local pilot = run.player
        if pilot and not pilot.active then pilot = nil end
        if o.h >= 0x1000 then
            o.mainClock = o.mainClock - 1
            if o.mainClock < 0 then fireFixed(o, pilot) end
        end
        o.trackClock = o.trackClock - 1
        if o.trackClock < 0 then
            o.trackClock = 1
            if pilot and o.turretCount == 3 then
                local aim = program.angle(o.h + 0x240, o.l, pilot.h, pilot.l, o.face)
                local diff = band(aim - o.face, 0x3f)
                if diff ~= 0 then o.face = band(o.face + (diff < 0x20 and 1 or -1), 0x3f) end
            end
        end
        if o.h >= 0x1000 then
            o.turretClock = o.turretClock - 1
            if o.turretClock < 0 then fireTurret(o) end
        end
    end

    function M.step(o)
        if not path.step(o) then remove(o); return end
        local part, run = o.extraParts[1], o.run
        local visible = band(o.l + run.cameraOffset + 0x1c00, 0xffff) < 0x7000
            and band(o.h + 0x800, 0xffff) < 0x8000
        if visible then o.entered = true
        elseif o.entered then remove(o); return end
        local base = (run.difficulty == 1 or run.difficulty == 2) and 18 or 12
        local flags = band(bor(o.flags, part.flags), 0x5c00)
        if flags == 0 then
            o.palette = o.hp < 0x80 and 25 or base
        else
            o.flags, part.flags = band(o.flags, 0xa3ff), band(part.flags, 0xa3ff)
            hyper.hit(o,flags)
            o.palette = bxor(o.palette == 25 and base or o.palette, bxor(base, 31))
            o.hp = min(o.hp, part.hp)
            part.hp = o.hp
            if o.hp < 0 then
                hyper.kill(run,flags,42)
                effects.emit(o, destruction)
                remove(o)
                return
            end
        end
        placePart(o)
        attack(o)
    end

    local function draw(o, sprite, dh, dl)
        local img = o.run.art[sprite]
        local x, y = world(o.h + dh, o.l + dl)
        Render(img[1], floor(x) + img[2] / 2, floor(y) + img[3] / 2)
    end

    function M.render(o)
        if not o.run.art then return end
        local pose = program.artillery[o.palette]
        draw(o, pose[1], -0xc00, -0xb00)
        draw(o, pose[2][band(o.face, 0x3e) / 2 + 1], -0x3c0, -0x400)
    end

    function M.damage(part, amount, flags)
        part.hp, part.flags = s16(part.hp - amount), bor(part.flags, flags)
    end

    return M
end
