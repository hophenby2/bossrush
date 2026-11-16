-- 0x172228。舰体、两个炮塔与敌弹分别持有自身的计时和回调。
return function(program, path, bullets, effects, remove, hyper)
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local min, floor = math.min, math.floor
    local s16, world = program.s16, program.world
    local M = {parts=2}
    local turretOffsets = {0x500, -0x500}
    -- 0x172628 至 0x172760 先写入偏移和延迟。各爆炸槽自行推进。
    local destruction = {
        {13,0,-0x800,0}, {0x84,0,-0xa00,0x600,7,0x54}, {0x84,0,-0xa00,-0x600,7,0xac,flip=true},
        {13,2,-0xe00,-0x200,7,0x98}, {13,4,-0xe00,0x100,7,0x68}, {0x85,4,-0xa00,0,0x0c,0x80},
    }

    local function placePart(o)
        local part = o.extraParts[1]
        part.h, part.l = o.h, o.l
        part.x, part.y = world(part.h, part.l)
        o.x, o.y = part.x, part.y
    end

    local function turretAngle(o, pilot, index)
        return program.angle(o.h + 0x680, o.l + turretOffsets[index], pilot.h, pilot.l, o.turretAngles[index])
    end

    function M.init(o)
        local run, part = o.run, o.extraParts[1]
        o.flags, part.flags = 0xa001, 0xa001
        o.hp = run.loop == 0 and 0xe00 or 0x1200
        o.front, o.back, o.right, o.left = 0xa00, 0xa00, 0xa00, 0xa00
        part.front, part.back, part.right, part.left = 0x600, 0, 0x1000, 0x1000
        o.mainClock, o.turretClock = band(0x50 - program.rank(run,0x1e,'tankRank'), 0xff), band(0x28 - program.rank(run,0x1e,'tankRank'), 0xff)
        o.mainQuota, o.turretQuota = 1, 4
        o.mainGap, o.turretGap = 0x10, 4
        o.trackClock, o.trackTurret = 2, 1
        o.palette = run.difficulty == 4 and 12 or 18
        if run.difficulty == 4 then
            o.mainQuota, o.turretQuota, o.mainGap = 5, 8, 0x0c
            o.protection, o.hp = 0x30, 0x7fff
        end
        part.hp = o.hp
        o.mainCount, o.turretCount = o.mainQuota, o.turretQuota
        if not path.attach(o) then return false end
        o.turretAngles = {band(o.direction, 0x3f), band(o.direction, 0x3f)}
        local pilot = run.player
        if pilot and pilot.active then
            for index = 1, 2 do o.turretAngles[index] = turretAngle(o, pilot, index) end
        end
        placePart(o)
        return true
    end

    local function fan(o, pilot)
        local run = o.run
        local ultra = run.difficulty == 4
        local narrow = ultra and o.mainCount >= 4 or not ultra and o.mainCount == 1
        local kind, modifier, rays, gap
        if narrow then
            kind, modifier, rays, gap = 4, ultra and o.mainCount == 4 and -1 or 0, 8, 8
        else
            kind, modifier, rays, gap = ultra and 4 or 5, ultra and -2 or -1, 7, 12
        end
        local aim = program.angle256(o.h - 0x200, o.l, pilot.h, pilot.l, 0x80)
        local direction = aim - (rays - 1) * gap / 2
        for _ = 1, rays do
            local delta = program.shipFan[kind][band(direction + 2, 0xfc) / 4 + 1]
            local h, l = s16(o.h + delta[1] - 0x200), s16(o.l + delta[2])
            bullets.emitPrecise(run, kind, modifier, direction, h, l)
            if run.loop ~= 0 then bullets.emitPrecise(run, kind, modifier + 6, direction, h, l) end
            direction = direction + gap
        end
    end

    local function track(o, pilot)
        o.trackClock = o.trackClock - 1
        if o.trackClock >= 0 then return end
        o.trackClock = 2
        if not pilot or o.turretCount ~= o.turretQuota then return end
        local index = o.trackTurret
        o.trackTurret = 3 - index
        local angle = o.turretAngles[index]
        local diff = band(turretAngle(o, pilot, index) - angle, 0x3f)
        if diff ~= 0 then o.turretAngles[index] = band(angle + (diff < 0x20 and 1 or -1), 0x3f) end
    end

    local function attack(o)
        local run = o.run
        if run.freeze or run.enemyShotGrace > 0 then return end
        local pilot = run.player
        if pilot and not pilot.active then pilot = nil end
        if not o.turretPhase and o.h >= 0x1000 then
            o.mainClock = o.mainClock - 1
            if o.mainClock < 0 then
                o.mainClock = o.mainGap
                if pilot then fan(o, pilot) end
                o.mainCount = o.mainCount - 1
                if o.mainCount < 0 then
                    o.mainCount, o.mainClock = o.mainQuota, band(0x50 - program.rank(run,0x1c,'salvoRank'), 0xff)
                    o.turretPhase = true
                end
            end
        end
        track(o, pilot)
        if not o.turretPhase or o.h < 0x1000 then return end
        o.turretClock = o.turretClock - 1
        if o.turretClock >= 0 then return end
        o.turretClock = o.turretGap
        for index, angle in ipairs(o.turretAngles) do
            local delta = program.muzzles[0x80][band(angle, 0x3e) / 2 + 1]
            local h = s16(o.h + 0x680 + delta[1])
            local l = s16(o.l + turretOffsets[index] + delta[2])
            local modifier = run.difficulty == 4 and 7 or 2
            if run.loop == 0 then
                bullets.emit(run, 0x13, modifier, angle, h, l)
            else
                bullets.emitPrecise(run, 0x13, modifier + 2, angle * 4, h, l)
                bullets.emitPrecise(run, 0x13, modifier, angle * 4 - 8, h, l)
                bullets.emitPrecise(run, 0x13, modifier, angle * 4 + 8, h, l)
            end
        end
        o.turretCount = o.turretCount - 1
        if o.turretCount < 0 then
            o.turretCount, o.turretClock = o.turretQuota, band(0x30 - program.rank(run,0x1c,'salvoRank'), 0xff)
            o.turretPhase = false
        end
    end

    function M.step(o)
        if not path.step(o) then remove(o); return end
        local run, part = o.run, o.extraParts[1]
        local visible = band(o.l + run.cameraOffset + 0x1800, 0xffff) < 0x6800
            and band(o.h + 0x1400, 0xffff) < 0x8c00
        if visible then o.entered = true
        elseif o.entered then remove(o); return end
        if o.protection then
            o.hp = 0x7fff
            o.protection = o.protection - (run.hyper and 2 or 1)
            if o.protection < 0 then o.protection, o.hp = nil, 0x1400 end
            part.hp = o.hp
        end
        local base = run.difficulty == 4 and 12 or 18
        local flags = band(bor(o.flags, part.flags), 0x5c00)
        if flags ~= 0 then
            o.flags, part.flags = band(o.flags, 0xa3ff), band(part.flags, 0xa3ff)
            hyper.hit(o,flags)
            o.palette = bxor(o.palette == 25 and base or o.palette, bxor(base, 31))
            o.hp = min(o.hp, part.hp)
            part.hp = o.hp
            if o.hp < 0 then
                hyper.kill(run,flags,83)
                effects.emit(o, destruction)
                remove(o)
                return
            end
        else
            o.palette = o.hp < 0x255 and 25 or base
        end
        placePart(o)
        attack(o)
    end

    local function draw(o, sprite, dh, dl)
        local image = o.run.art[sprite]
        local x, y = world(o.h + dh, o.l + dl)
        Render(image[1], floor(x) + image[2] / 2, floor(y) + image[3] / 2)
    end

    function M.render(o)
        if not o.run.art then return end
        local image = program.ship[o.palette]
        draw(o, image[1], -0x1400, -0x1100)
        draw(o, image[2][band(o.turretAngles[1], 0x3e) / 2 + 1], 0x80, 0)
        draw(o, image[2][band(o.turretAngles[2], 0x3e) / 2 + 1], 0x80, -0xa00)
    end

    function M.damage(part, amount, flags)
        part.hp, part.flags = s16(part.hp - amount), bor(part.flags, flags)
    end

    return M
end
