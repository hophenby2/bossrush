-- 0x1747e6。履带、两个炮塔和射击计数各按原机体回调推进。
return function(program, path, bullets, effects, items, remove)
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local floor = math.floor
    local s16, world = program.s16, program.world
    local M = {parts=2}
    local turretOffsets = {0x5c0, -0x640}
    local destruction = {
        {13,0,0x200,0,scrolls=true},
        {12,0,-0x200,-0x600,5,0xc0,scrolls=true},
        {12,0,-0x400,0x200,4,0x40,scrolls=true},
        {0x85,0,-0x200,0,3,0x80,scrolls=true},
    }

    local function target(o, pilot, i)
        return program.angle(o.h + 0x300, o.l + turretOffsets[i], pilot.h, pilot.l, o.angles[i])
    end

    function M.init(o)
        local run = o.run
        o.extraParts[1].flags = 0x8000
        o.flags, o.hp = 0xa000, 0x1280
        o.front, o.back, o.right, o.left = 0x800, 0xc00, 0xc00, 0xc00
        o.palette = run.difficulty == 0 and 13 or 19
        o.attackClock, o.aimClock = band(0x80 - run.heavyRank, 0xff), 1
        o.primaryCount, o.tier = 1 + (run.loop ~= 0 and 1 or 0), 2
        o.treadClock, o.treadFrame, o.aimSide = 1, 0, 1
        if not path.attach(o) then return false end
        if band(o.flags, 0x2000) == 0 then
            o.gate = (o.part[0x1e] or 0) == 0 and 'left' or 'right'
            o[o.gate] = -0xc00
            o.part[0x1e] = 0
        end
        local pilot = run.player
        o.angles = {band(o.direction, 0x3f), band(o.direction, 0x3f)}
        if pilot and pilot.active then
            for i = 1, 2 do o.angles[i] = target(o, pilot, i) end
        end
        return true
    end

    local function track(o)
        o.aimClock = o.aimClock - 1
        if o.aimClock >= 0 then return end
        o.aimClock = 1
        local run, i = o.run, o.aimSide
        local pilot = run.player
        if not pilot or not pilot.active or o.primaryCount ~= 1 + (run.loop ~= 0 and 1 or 0) then return end
        o.aimSide = 3 - i
        local diff = band(target(o, pilot, i) - o.angles[i], 0x3f)
        if diff ~= 0 then o.angles[i] = band(o.angles[i] + (diff < 0x20 and 1 or -1), 0x3f) end
    end

    local function attack(o)
        local run = o.run
        if run.freeze or run.enemyShotGrace > 0 then return end
        track(o)
        if o.h < 0x1000 then return end
        o.attackClock = o.attackClock - 1
        if o.attackClock >= 0 then return end
        o.attackClock = 4
        for i, angle in ipairs(o.angles) do
            local muzzle = program.muzzles[0x88][band(angle, 0x3e) / 2 + 1]
            local h = s16(o.h + muzzle[1] + 0x300)
            local l = s16(o.l + muzzle[2] + turretOffsets[i])
            local sign = i == 1 and 1 or -1
            local first = angle + (o.tier == 0 and 3 or o.tier == 1 and 5 or 0) * sign
            for j = 0, 2 do
                local dir = first - j * 5 * sign
                if j == 1 or run.loop == 0 then
                    bullets.emit(run, 4, 3, dir, h, l)
                else
                    bullets.emitPrecise(run, 4, 3, dir * 4 - 8, h, l)
                    bullets.emitPrecise(run, 4, 3, dir * 4 + 8, h, l)
                end
            end
        end
        o.primaryCount = o.primaryCount - 1
        if o.primaryCount < 0 then
            o.primaryCount = 1 + (run.loop ~= 0 and 1 or 0)
            o.attackClock = band(0x0a - floor(run.trackRank / 4), 0xff)
            o.tier = o.tier - 1
            if o.tier < 0 then
                o.tier, o.attackClock = 2, band(0x60 - run.largeRank, 0xff)
            end
        end
    end

    function M.step(o)
        if not path.step(o) then remove(o); return end
        local run = o.run
        if o.gate and not run.freeze and o.direction < 0x40 and band(o.flags, 0x2000) ~= 0 and o[o.gate] < 0xc00 then
            o[o.gate] = s16(o[o.gate] + (o.gate == 'right' and -o.dl or o.dl))
        end
        local visible = band(o.l + run.cameraOffset + 0x1400, 0xffff) < 0x6000
            and band(o.h + 0xc00, 0xffff) < 0x8800
        if visible then o.entered = true
        elseif o.entered then remove(o); return end
        local base = run.difficulty == 0 and 13 or 19
        if band(o.flags, 0x5c00) ~= 0 then
            o.flags = band(o.flags, 0xa3ff)
            o.palette = bxor(o.palette == 25 and base or o.palette, bxor(base, 31))
            if o.hp < 0 then
                for _, offset in ipairs(program.heavy.drops) do items.emit(o, 8, offset[1], offset[2]) end
                effects.emit(o, destruction)
                remove(o)
                return
            end
        else
            o.palette = o.hp < 0x4a0 and 25 or base
        end
        if not run.freeze then
            o.drawH = -0xc00
            if o.direction < 0x40 then
                o.treadClock = o.treadClock - 1
                if o.treadClock < 0 then
                    o.treadClock, o.drawH = 1, -0xc40
                    o.treadFrame = (o.treadFrame + (o.direction == 0x10 and 1 or -1)) % 4
                end
            end
        end
        attack(o)
        o.x, o.y = world(o.h, o.l)
    end

    local function draw(o, sprite, dh, dl)
        local img = o.run.art[sprite]
        local x, y = world(o.h + dh, o.l + dl)
        Render(img[1], floor(x) + img[2] / 2, floor(y) + img[3] / 2)
    end

    function M.render(o)
        if not o.run.art then return end
        local pose = program.heavy[o.palette]
        draw(o, pose[1], o.drawH or -0xc00, -0xc00)
        draw(o, pose[2][o.treadFrame + 1], -0xe00, -0xb00)
        draw(o, pose[3][band(o.angles[1], 0x3e) / 2 + 1], -0x100, 0x2c0)
        draw(o, pose[3][band(o.angles[2], 0x3e) / 2 + 1], -0x100, -0x940)
    end

    function M.damage(o, amount, flags)
        o.hp, o.flags = s16(o.hp - amount), bor(o.flags, flags)
    end

    return M
end
