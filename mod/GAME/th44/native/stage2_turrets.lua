-- 0x1752b8 的浮炮与 0x175e82 的地炮。炮毁后原槽保留底座和第二次受击。
return function(program, path, bullets, effects, items, remove, hyper)
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local s16, world = program.s16, program.world
    local floor = math.floor
    local data = program.stage2Turrets
    local M = {parts=1}
    local topBlast = {{11,0,0,0}}
    local groundBlast = {{0x84,0,-0x200,-0x200}}
    local baseBlast = {{12,0,-0x400,-0x200}}

    function M.init(o)
        local run = o.run
        o.floating = o.callback == 0x1752b8
        o.flags, o.hp = 0xa200, o.floating and 0x140 or 0x300
        o.front, o.back = 0x800, o.floating and 0x800 or 0x900
        o.right, o.left = o.floating and 0x500 or 0x600, o.floating and 0x500 or 0x600
        o.damagePalette = o.floating and 0x50 or 0xc0
        local color = data.palettes[o.kind][run.stageNumber]
        o.palette, o.basePalette, o.flashMask = color[1], color[1], color[2]
        o.attackClock = band(0x44 - program.rank(run,0x1a,'groundRank'),0xff)
        o.burst, o.burstMax, o.trackClock = o.floating and 2 or 0, o.floating and 2 or 0, 1
        o.spin, o.spinCursor = 1, 6
        if not path.attach(o) then return false end
        o.face = band(o.direction,0x3f)
        local pilot = run.player
        if pilot and pilot.active then o.face = program.angle(o.h,o.l,pilot.h,pilot.l,o.face) end
        if o.floating then
            o.bobAngle = program.bossWideRandom(run)
            o.attackClock = band(o.attackClock + floor(program.randomEnemy(run) / 2),0xff)
            o.bob = 0
        end
        return true
    end

    local function fire(o)
        local run = o.run
        local pilot = run.player
        if run.freeze or run.enemyShotGrace > 0 then return end
        o.trackClock = o.trackClock - 1
        if o.trackClock < 0 then
            o.trackClock = 1
            if pilot and pilot.active and (not o.floating or o.burst == o.burstMax) then
                local aim = program.angle(o.h,o.l,pilot.h,pilot.l,o.face)
                local diff = band(aim - o.face,0x3f)
                if diff ~= 0 then o.face = band(o.face + (diff < 0x20 and 1 or -1),0x3f) end
            end
        end
        if o.h < 0x1000 then return end
        o.attackClock = o.attackClock - 1
        if o.attackClock >= 0 then return end
        o.attackClock = o.floating and 8 - floor(program.rank(run,0x20,'tankRank') / 4) or 4
        if program.pilotDistance(o,pilot) < program.aimDistances[run.difficulty + 1] then return end
        if not o.floating and run.difficulty == 3 and run.major < 0x2e then return end
        local shape = o.floating and data.muzzles or program.muzzles[0x85]
        local offset = shape[band(o.face,0x3e) / 2 + 1]
        local h,l = s16(o.h + offset[1]), s16(o.l + offset[2])
        local angle = o.floating and o.face or band(o.face + 2,0x3c)
        local kind = o.floating and 12 or 13
        if o.floating and run.loop ~= 0 and o.burst == 2 then
            bullets.emitPrecise(run,kind,2,angle * 4,h,l)
            bullets.emitPrecise(run,kind,0,angle * 4 - 8,h,l)
            bullets.emitPrecise(run,kind,0,angle * 4 + 8,h,l)
        else bullets.emit(run,kind,0,angle,h,l) end
        o.burst = o.burst - 1
        if o.burst < 0 then
            o.attackClock = band(o.floating and 0x54 - program.rank(run,0x18,'largeRank') or 0x44 - program.rank(run,0x1a,'groundRank'),0xff)
            o.burst = o.burstMax
        end
    end

    function M.step(o)
        if not path.step(o) then remove(o); return end
        local run = o.run
        local visible = band(o.l + run.cameraOffset + 0x1c00,0xffff) < 0x7000
            and band(o.h + 0x800,0xffff) < 0x8000
        if visible then o.entered = true
        elseif o.entered then remove(o); return end
        local flags = band(o.flags,0x5c00)
        if flags == 0 then
            o.palette = o.hp < o.damagePalette and 25 or o.basePalette
        else
            o.flags = band(o.flags,0xa3ff)
            hyper.hit(o,flags)
            o.palette = bxor(o.palette == 25 and o.basePalette or o.palette,o.flashMask)
            if o.hp < 0 then
                hyper.kill(run,flags,o.floating and not o.debris and 11 or 8)
                if o.debris then
                    if not o.floating then items.emit(o,8) end
                    effects.emit(o,baseBlast)
                    remove(o)
                    return
                end
                effects.emit(o,o.floating and topBlast or groundBlast)
                o.debris, o.flags, o.hp = true, band(bor(o.flags,0x80),0xfdff), o.floating and 0x140 or 0x300
            end
        end
        if o.floating then
            o.spin = o.spinCursor
            o.spinCursor = o.spinCursor == 1 and 6 or o.spinCursor - 1
            o.bob = data.bob[o.bobAngle + 1]
            o.bobAngle = band(o.bobAngle + 3,0xff)
        end
        if not o.debris then fire(o) end
        o.x, o.y = world(o.h,o.l)
    end

    local function draw(o,id,dh,dl)
        local image = o.run.art[id]
        local x,y = world(o.h + dh,o.l + dl)
        Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2)
    end

    function M.render(o)
        if not o.run.art then return end
        local images = data.images[o.kind]
        local angle = band(o.face,0x3e) / 2 + 1
        if o.floating then draw(o,data.rotors[o.spin],o.bob - 0x400,-0x500) end
        local image = o.debris and images.debris[o.palette] or images[o.palette][angle]
        draw(o,image,(o.bob or 0) - 0x800,o.floating and -0x400 or -0x500)
    end

    function M.damage(o, amount, flags)
        o.hp, o.flags = s16(o.hp - amount), bor(o.flags,flags)
    end

    return M
end
