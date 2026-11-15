-- 0x195020 从炮翼发射，逐步减速。静止时按三张炮口表发射三环。
return function(program, bullets, effects, remove)
    local bit = require('bit')
    local band, bor = bit.band, bit.bor
    local s16, world = program.s16, program.world
    local floor = math.floor
    local M = {parts=1}
    local ringTables = {5,4,3}

    function M.init(o)
        local row = o.row
        o.h, o.l = row.h, row.l
        o.speed, o.direction = row.speed, row.angle
        o.modifier = row.modifier
        o.hp, o.flags = 0x7fff, 0x8001
        o.front, o.back, o.right, o.left = 0x400, 0x400, 0x400, 0x400
        o.spinClock, o.spin = 1, 0
        o.slowClock, o.slowGap = 0, row.count
        return true
    end

    local function explosion(o)
        effects.emit(o,{{1,0,0,0,o.speed,o.direction * 4}})
    end

    function M.step(o)
        if o.run.boss1 and o.run.boss1.dying then explosion(o); remove(o); return end
        if band(o.flags,0x5c00) ~= 0 then
            o.flags, o.hp = band(o.flags,0xa3ff), 0x7fff
        end
        if not o.run.freeze then
            local h, l = program.vector(o.speed,o.direction * 4)
            o.h, o.l = s16(o.h + h), s16(o.l + l)
        end
        o.slowClock = o.slowClock - 1
        if o.slowClock < 0 then
            o.slowClock, o.speed = o.slowGap, o.speed - 1
        end
        if o.speed == 0 then
            explosion(o)
            local angle = band(program.bossWideRandom(o.run),0x3f)
            for ring, tableId in ipairs(ringTables) do
                for i = 1, 16 do
                    local offset = program.shipFan[tableId][band(angle,0x3f) + 1]
                    local h, l = program.addPacked(o.h,o.l,offset[1],offset[2])
                    bullets.emit(o.run,ring + 2,o.modifier - (ring - 1) * 5,angle,h,l)
                    angle = angle + 4
                end
                angle = angle + 2
            end
            remove(o)
            return
        end
        o.spinClock = o.spinClock - 1
        if o.spinClock < 0 then o.spinClock, o.spin = 1, (o.spin + 1) % 16 end
        o.x, o.y = world(o.h,o.l)
    end

    function M.render(o)
        if not o.run.art then return end
        local image = o.run.art[program.boss1.charge[o.spin + 1]]
        local x, y = world(o.h - 0x600,o.l - 0x300)
        Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2)
    end

    function M.damage(o, amount, flags)
        o.hp, o.flags = s16(o.hp - amount), bor(o.flags,flags)
    end

    return M
end
