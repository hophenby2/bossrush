-- 0x199e52 是 0x196512 挂载的引擎尾焰，0x199dee 是 0x12 弹到期的爆点。
return function(program, effects, remove)
    local band = require('bit').band
    local floor, s16, world = math.floor, program.s16, program.world
    local M = {parts=1}
    local mineBurst = {{3,0,0,0}}

    function M.init(o)
        o.flags, o.h, o.l = 0x8000,o.row.h,o.row.l
        o.animClock, o.frameIndex = 2,1
        return true
    end

    function M.step(o)
        if o.kind == 0x35 then
            effects.emit(o,mineBurst)
            remove(o)
            return
        end
        local inside = band(o.h + 0x800,0xffff) < 0x8000
            and band(o.l + 0x1c00 + o.run.cameraOffset,0xffff) < 0x7000
        if inside then o.entered = true
        elseif o.entered then remove(o); return end
        o.h = s16(o.h - o.run.scrollStep * 64)
        o.animClock = o.animClock - 1
        if o.animClock < 0 then
            o.animClock, o.frameIndex = 2,o.frameIndex + 1
            if o.frameIndex > 8 then remove(o); return end
        end
        o.x,o.y = world(o.h,o.l)
    end

    function M.render(o)
        if not o.run.art or not o.entered then return end
        local image = o.run.art[program.boss2.engineTrail[o.frameIndex]]
        local x,y = world(o.h - 0x600,o.l - 0x400)
        Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2)
    end

    return M
end
