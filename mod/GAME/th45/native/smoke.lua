-- 0x165446 是随地景移动的烟尘生成器。烟尘登记在 0x179a82 的独立效果槽。
return function(program,path,effects)
    local band = require('bit').band
    local floor = math.floor
    local M = {parts=1}

    function M.init(o)
        o.flags,o.clock = 0x8100,0x10
        return path.attach(o,o.row)
    end

    function M.step(o)
        local run = o.run
        o.h = program.s16(o.h + run.groundScroll)
        local inside = band(o.h + 0xe00,0xffff) < 0x8c00
        if inside then o.seen = true elseif o.seen then return false end
        if run.stopPathClock then return true end
        o.clock = o.clock - 1
        if o.clock >= 0 then return true end
        local delay = program.random(run,program.randomNarrow)
        if delay >= 0x80 then delay = delay - 0x100 end
        o.clock = band(floor(delay / 2),255)
        local offset = program.debrisOffsets[program.nextRandom(run,63)][1]
        local angle = program.random(run,program.randomNarrow)
        effects.emit(o,14,0x0c,angle,offset,true)
        return true
    end

    return M
end
