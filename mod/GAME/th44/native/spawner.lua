-- 0x171314 定时把路径游标及当前坐标写入 0x161f1e 的生成队列。
return function(program, remove)
    local band = require('bit').band
    local s16, word = program.s16, program.word
    local M = {parts=1}

    function M.init(o)
        local stage = o.run.stage
        local cursor = o.row[5] - stage.pathBase + 1
        local data = stage.paths
        o.h, o.l = s16(word(data, cursor)), s16(word(data, cursor + 2))
        cursor = cursor + 4
        local kind = band(word(data, cursor), 0xff)
        if kind == 2 then
            o.stationary = true
            cursor = cursor + 2
            kind = band(word(data, cursor), 0xff)
        end
        o.spawnKind = kind
        o.remaining = band(word(data, cursor + 2), 0xff)
        o.interval = band(word(data, cursor + 4), 0xff)
        o.spawnPath = stage.pathBase + cursor + 5
        o.flags, o.spawnClock = 0x8000, 0
        return true
    end

    function M.step(o)
        local run = o.run
        if not o.stationary then o.h = s16(o.h - run.groundScroll) end
        local visible = band(o.l + run.cameraOffset + 0x1c00, 0xffff) < 0x7000
            and o.h > -0x800 and o.h < 0x7800
        if visible then o.entered = true
        elseif o.entered then remove(o); return end
        if run.freeze then return end
        o.spawnClock = o.spawnClock - 1
        if o.spawnClock >= 0 then return end
        o.spawnClock = o.interval
        local callbacks = assert(program.actorCallbacks[o.spawnKind], '生成队列的敌机类型超出 ROM 表')
        if #run.spawnQueue < 40 then
            run.spawnQueue[#run.spawnQueue + 1] = {run.major,0,o.spawnKind,o.spawnFlags,
                o.spawnPath,callbacks[1],callbacks[2],h=o.h,l=o.l}
        end
        if o.remaining > 0 then
            o.remaining = o.remaining - 1
            if o.remaining == 0 then remove(o) end
        end
    end

    function M.render() end

    return M
end
