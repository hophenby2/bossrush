-- 0x175bf4。炮台在每轮首发前跟踪自机，余下三组沿同一朝向从两侧出膛。
return function(program, path, bullets, effects, items, remove, hyper)
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local floor = math.floor
    local s16, world = program.s16, program.world
    local M, Fifth = {parts=1}, {parts=1}
    local destruction = {{12,0,-0x200,0,scrolls=true}}

    function M.init(o)
        local run = o.run
        o.flags, o.hp = 0xa000, run.difficulty == 0 and run.major >= 0x156 and 0x280 or 0x480
        o.front, o.back, o.right, o.left = 0x600, 0x600, 0x500, 0x500
        o.attackClock, o.trackClock, o.burstCount = band(0x50 - program.rank(run,0x18,'largeRank'), 0xff), 1, 3
        o.palette = run.difficulty == 0 and 14 or 17
        if not path.attach(o) then return false end
        local pilot = run.player
        o.face = band(o.direction, 0x3f)
        if pilot and pilot.active then o.face = program.angle(o.h, o.l, pilot.h, pilot.l, o.face) end
        return true
    end

    local function attack(o)
        local run, pilot = o.run, o.run.player
        if run.freeze or run.enemyShotGrace > 0 then return end
        local distant = program.pilotDistance(o, pilot) >= program.aimDistances[run.difficulty + 1]
        o.trackClock = o.trackClock - 1
        if o.trackClock < 0 then
            o.trackClock = 1
            if distant and o.burstCount == 3 and pilot and pilot.active then
                local aim = program.angle(o.h, o.l, pilot.h, pilot.l, o.face)
                local difference = band(aim - o.face, 0x3f)
                if difference ~= 0 then o.face = band(o.face + (difference < 0x20 and 1 or -1), 0x3f) end
            end
        end
        if o.h < 0x1000 then return end
        o.attackClock = o.attackClock - 1
        if o.attackClock >= 0 then return end
        o.attackClock = 4
        if not distant then return end
        local offsets = program.muzzles[0x89][band(o.face, 0x3e) / 2 + 1]
        for index = 1, 3, 2 do
            bullets.emit(run, 6, 0, o.face, s16(o.h + offsets[index]), s16(o.l + offsets[index + 1]))
        end
        o.burstCount = o.burstCount - 1
        if o.burstCount < 0 then
            o.burstCount, o.attackClock = 3, band(0x48 - program.rank(run,0x1a,'carrierRank'), 0xff)
        end
    end

    local function visible(o)
        local run = o.run
        return band(o.l + run.cameraOffset + 0x1c00, 0xffff) < 0x7000
            and band(o.h + 0x800, 0xffff) < 0x8000
    end

    function M.step(o)
        if not path.step(o) then remove(o); return end
        local run = o.run
        if visible(o) then o.entered = true
        elseif o.entered then remove(o); return end
        local base = run.difficulty == 0 and 14 or 17
        local flags = band(o.flags,0x5c00)
        if flags == 0 then
            o.palette = o.hp < 0x120 and 25 or base
        else
            o.flags = band(o.flags, 0xa3ff)
            hyper.hit(o,flags)
            o.palette = bxor(o.palette == 25 and base or o.palette, bxor(base, 31))
            if o.hp < 0 then
                hyper.kill(o.run,flags,34)
                effects.emit(o, destruction)
                items.emit(o, 8)
                remove(o)
                return
            end
        end
        attack(o)
        o.x, o.y = world(o.h, o.l)
    end

    function M.render(o)
        if not o.run.art then return end
        local pose = program.groundgun[o.palette]
        local image = o.run.art[pose[band(o.face, 0x3e) / 2 + 1]]
        local x, y = world(o.h - 0x800, o.l - 0x700)
        Render(image[1], floor(x) + image[2] / 2, floor(y) + image[3] / 2)
    end

    function M.damage(o, amount, flags)
        o.hp, o.flags = s16(o.hp - amount), bor(o.flags, flags)
    end

    -- 0x174d88 将单炮口装在 0x1715e2 的小炮塔上。首发前和每轮之间可跟踪。
    function Fifth.init(o)
        local run = o.run
        local base,mask = unpack(program.fifthGun.palettes[(run.paletteMode or run.difficulty) + 1])
        o.flags,o.hp,o.palette,o.base,o.mask = 0xa000,0x500,base,base,mask
        o.front,o.back,o.right,o.left = 0x500,0x500,0x700,0x700
        o.attackClock,o.trackClock,o.burstCount = band(0x50 - program.rank(run,0x18,'largeRank'),255),1,4
        if not path.attach(o) then return false end
        local pilot = run.player
        o.face = band(o.direction,0x3f)
        if pilot and pilot.active then o.face = program.angle(o.h,o.l,pilot.h,pilot.l,o.face) end
        return true
    end

    local function fifthAttack(o)
        local run,pilot = o.run,o.run.player
        if run.freeze or run.enemyShotGrace > 0 then return end
        o.trackClock = o.trackClock - 1
        if o.trackClock < 0 then
            o.trackClock = 1
            if o.burstCount == 4 and pilot and pilot.active then
                o.face = program.turn64(o.face,program.angle(o.h,o.l,pilot.h,pilot.l,o.face))
            end
        end
        if o.h < 0x1000 then return end
        o.attackClock = o.attackClock - 1
        if o.attackClock >= 0 then return end
        o.attackClock = 4
        if program.pilotDistance(o,pilot) < program.aimDistances[run.difficulty + 1] then return end
        local muzzle = program.boss4.turretMuzzles[band(o.face,0x3e) / 2 + 1]
        bullets.emit(run,6,2,o.face,s16(o.h + muzzle[1] + 8),s16(o.l + muzzle[2]))
        o.burstCount = o.burstCount - 1
        if o.burstCount < 0 then
            o.burstCount,o.attackClock = 4,band(0x44 - program.rank(run,0x1e,'carrierRank'),255)
        end
    end

    function Fifth.step(o)
        local run = o.run
        if not path.step(o,run.groundScroll) then remove(o); return end
        if visible(o) then o.entered = true
        elseif o.entered then remove(o); return end
        local flags = band(o.flags,0x5c00)
        if flags == 0 then
            o.palette = o.hp < 0x140 and 25 or o.base
        else
            o.flags,o.palette = band(o.flags,0xa3ff),bxor(o.palette == 25 and o.base or o.palette,o.mask)
            hyper.hit(o,flags)
            if o.hp < 0 then
                hyper.kill(run,flags,20)
                local elevation = o.part[0x1e] or 0
                effects.emit(o,{{12,0,0,0,scrolls=true}})
                items.emit(o,8)
                if elevation ~= 0 then items.emit(o,8) end
                remove(o)
                return
            end
        end
        fifthAttack(o)
        o.x,o.y = world(o.h,o.l)
    end

    function Fifth.render(o)
        if not o.run.art then return end
        local poses = program.fifthGun.images[o.palette]
        local image = o.run.art[poses[band(o.face,0x3e) / 2 + 1]]
        local x,y = world(o.h - 0x800,o.l - 0x800)
        Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2)
    end

    Fifth.damage = M.damage
    return M,Fifth
end
