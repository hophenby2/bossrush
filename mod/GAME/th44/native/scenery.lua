-- 0x174fb8 处理靠近自机后显形的地面物件，0x175134 处理随卷轴移动的隐形判定盒。
return function(program, path, effects, items, remove, hyper)
    local bit = require('bit')
    local band, bor = bit.band, bit.bor
    local s16, world = program.s16, program.world
    local abs, floor = math.abs, math.floor
    local M = {parts=1}

    function M.init(o)
        o.hiddenBox = o.callback == 0x175134
        if o.hiddenBox then
            o.flags, o.hp = 0xa200, 0
            o.front, o.back, o.right, o.left = 0x500, 0x500, 0x200, 0x200
            o.drop = 8
        else
            o.flags, o.hp = 0x8100, 0x0a
            o.front, o.back, o.right, o.left = 0x500, 0x700, 0x400, 0x400
            o.drop = 0
            o.imageFrame = 1
        end
        if not path.attach(o) then return false end
        if o.part[0x1e] and o.part[0x1e] ~= 0 and not o.hiddenBox then o.drop = 0x40 end
        if o.hiddenBox and o.run.difficulty == 1 and o.run.major < 4 then o.flags = 0x8000 end
        return true
    end

    function M.step(o)
        local run = o.run
        if run.clearActors then remove(o); return end
        o.h = s16(o.h - run.scrollStep * 64)
        local l = o.l + run.cameraOffset + 0xc00
        local visible = band(l, 0xffff) < (o.hiddenBox and 0x4000 or 0x5000)
            and band(o.h + 0x400, 0xffff) < 0x7400
        if visible then o.entered = true
        elseif o.entered then remove(o); return end
        if o.hiddenBox and run.difficulty == 1 and run.major >= 4 then o.flags = bor(o.flags, 0x2000) end
        local flags = band(o.flags,0x5c00)
        if flags ~= 0 then
            o.flags = band(o.flags, 0xa3ff)
            if o.hp < 0 then
                hyper.kill(o.run,flags,1)
                items.emit(o, o.drop)
                effects.emit(o, {{o.hiddenBox and 1 or 12,0,0,0,scrolls=true}})
                remove(o)
                return
            end
        end
        local pilot = run.player
        local near = pilot and pilot.active and abs(s16(pilot.l - o.l)) < 0x240
        o.show = false
        if not o.hiddenBox and (near or run.hyper) then
            o.flashParity = not o.flashParity
            o.show = o.flashParity
            if o.show then o.imageFrame = 3 - o.imageFrame end
        end
        o.x, o.y = world(o.h, o.l)
    end

    function M.render(o)
        if not o.show or not o.run.art then return end
        local image = o.run.art[program.ground[o.imageFrame]]
        local x, y = world(o.h - 0x600, o.l - 0x300)
        Render(image[1], floor(x) + image[2] / 2, floor(y) + image[3] / 2)
    end

    function M.damage(o, amount, flags)
        o.hp, o.flags = s16(o.hp - amount), bor(o.flags, flags)
    end

    return M
end
