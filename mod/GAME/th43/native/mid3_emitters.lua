-- 0x137cec 的八个发射器。炮位在战舰上追踪，自身的计数器决定锁角和每轮发弹。
return function(program, bullets)
    local band = require('bit').band
    local data = program.mid3
    local gunDelay = {0xa0, 0x70, 0x40, 0x10, 0x30}
    local M = {}

    local function fast(o, kind, modifier, angle, h, l, offset)
        local dh, dl = program.unpack(offset)
        h, l = program.add(h, l, dh, dl)
        bullets.emitFasterInLoop(o.run, kind, modifier, angle, h, l)
    end

    local function guns(o, index, f)
        f.locked = true
        if index <= 4 then
            local p = o.guns[index]
            if not p.broken then
                local offsets = data.muzzleBig[band(p.direction, 0x3e) / 2 + 1]
                for i, offset in ipairs(offsets) do
                    fast(o, 0x16, 2, p.direction * 4 + (i - 2) * 6, p.h, p.l, offset)
                end
            end
        else
            for i = 5, 14 do
                local p = o.guns[i]
                if not p.broken then
                    local offset = data.muzzleSmall[band(p.direction, 0x3e) / 2 + 1]
                    local h, l = program.add(p.h, p.l, program.unpack(offset))
                    bullets.emitLongPair(o.run, 0xc, -2, p.direction * 4, h, l)
                end
            end
        end
        f.waves = f.waves - 1
        f.clock = index == 5 and 4 or 5
        if f.waves < 0 then
            f.locked = false
            f.clock, f.waves = index == 5 and 0x50 or 0xa0, index == 5 and 1 or 3
        end
    end

    local function ringOffset(angle, base)
        return base + data.muzzleRing[band(angle + 2, 0xfc) / 4 + 1]
    end

    local function deckRing(o, modifier)
        if o.byIndex[25].broken then return end
        local angle = program.random(o.run, program.randomParity)
        for j = 0, 1 do
            for k = 0, 15 do
                local a = angle + k * 16
                local h, l = program.add(o.h, o.l, program.unpack(ringOffset(a, 0x04800d40)))
                bullets.emitLongPair(o.run, 7 + j, modifier + j * 6, a, h, l)
            end
            angle = angle + 8
        end
    end

    local function deck(o, index, f)
        local left, right = o.byIndex[25].broken, o.byIndex[26].broken
        if index == 6 and (left or not right) or index == 7 and right then
            o.emitters[index] = nil
            return
        end
        f.clock = f.clock - 1
        if f.clock >= 0 then return end
        if index == 6 then
            deckRing(o, 0)
        else
            local count, spacing = left and 12 or 8, left and 0x15 or 0x20
            for k = 0, count - 1 do
                local a = f.angle + k * spacing
                local h, l = program.add(o.h, o.l, program.unpack(ringOffset(a, 0x20000000)))
                bullets.emitCenterAndWide(o.run, 6, f.modifier, a, h, l)
            end
            f.angle = f.angle + f.turn
        end
        f.clock = index == 6 and 0x30 or 0x0c
        f.waves = f.waves - 1
        if f.waves >= 0 then return end
        if index == 7 then
            deckRing(o, 0)
            f.angle = program.random(o.run, program.randomParity)
            f.turn = -f.turn
        end
        f.clock, f.waves = index == 6 and 0x50 or 0x30, index == 6 and 2 or 0x13
        f.modifier, f.cycles = f.modifier + 1, f.cycles - 1
        if f.cycles < 0 then o.emitters[index] = nil end
    end

    local function core(o, f)
        local exposed = o.byIndex[25].broken and o.byIndex[26].broken
        local modifier = f.modifier
        for _, ray in ipairs(data.coreFire) do
            local a, offset = f.angle + ray[1], ray[2]
            fast(o, 8, modifier, a, o.h, o.l, offset)
            if exposed then
                local h, l = program.add(o.h, o.l, program.unpack(offset))
                for side = 1, 2 do
                    local branch = band(a + 0x40 * side, 0xff)
                    local extra = (branch >= 0xc8 or branch < 0x60) and 8 or 0
                    bullets.emitAngle(o.run, 3, modifier + 4 + extra, branch, h, l)
                end
                modifier = modifier + 1
            end
        end
        f.angle, f.clock, f.waves = f.angle + f.turn, 7, f.waves - 1
        if f.waves >= 0 then return end
        f.turn, f.clock, f.waves = -f.turn, f.repeatDelay, 0x4f
        f.modifier, f.cycles = f.modifier + 1, f.cycles - 1
        if f.cycles >= 0 then return end
        if exposed then
            M.start(o, 8)
        else
            o.emitters[8] = nil
            o.shutter, o.shutterClock = 'close', 1
        end
    end

    function M.start(o, index)
        local f = {created=o.tick}
        if index <= 5 then
            f.clock, f.waves = gunDelay[index], index == 5 and 1 or 3
        elseif index == 6 then
            f.clock, f.waves, f.modifier, f.cycles = 0x70, 2, 0, 1
        elseif index == 7 then
            f.clock, f.waves, f.modifier, f.cycles = 0x70, 0x13, -1, 4
            f.angle, f.turn = program.random(o.run, program.randomParity), 2
        else
            f.clock, f.waves, f.modifier, f.cycles = 0x10, 0x4f, 0, 1
            f.angle, f.turn = program.random(o.run, program.randomParity), 9
            f.repeatDelay = o.byIndex[25].broken and o.byIndex[26].broken and 0x10 or 0x30
        end
        o.emitters[index] = f
    end

    function M.step(o)
        for i = 1, 8 do
            local f = o.emitters[i]
            if f and f.created < o.tick then
                if i == 6 or i == 7 then
                    deck(o, i, f)
                else
                    f.clock = f.clock - 1
                    if f.clock < 0 then
                        if i == 8 then core(o, f) else guns(o, i, f) end
                    end
                end
            end
        end
    end

    return M
end
