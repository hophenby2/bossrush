-- 0x14fc28 读取编队头。子机复用同一个路径游标，各自保存出生坐标和路径计时。
return function(program)
    local band = require('bit').band
    local s16,word = program.s16,program.word
    local byte = string.byte
    local M = {parts=1}

    function M.init(o)
        local run,row = o.run,o.row
        local stage = run.stage
        local data = stage.paths
        local cursor = row[6]-stage.pathBase+1
        o.h,o.l = program.addPacked(word(data,cursor),word(data,cursor+2),row[7])
        o.flags = 0x8000
        cursor = cursor+4
        if byte(data,cursor) == 0x89 and byte(data,cursor+1) ~= 0 then
            o.l = s16(o.l-run.cameraOffset)
            cursor = cursor+2
        end
        if byte(data,cursor+1) == 2 then
            o.stationary = true
            cursor = cursor+2
        end
        o.childKind = byte(data,cursor+1)
        o.remaining = byte(data,cursor+3)
        o.interval = byte(data,cursor+5)
        o.childPath = stage.pathBase+cursor+5
        o.spawnClock,o.childIndex = 0,0
        return true
    end

    function M.step(o)
        local run = o.run
        if not o.stationary then o.h = s16(o.h+run.groundScroll) end
        local visible = band(o.l+0x1c00+run.cameraOffset,0xffff) < 0x7000
            and o.h > -0x800 and o.h < 0x7800
        if visible then o.entered = true
        elseif o.entered then return false end
        if run.freeze or run.stopPathClock then return true end
        o.spawnClock = o.spawnClock-1
        if o.spawnClock >= 0 then return true end
        o.spawnClock = o.interval
        local queue = run.spawnQueue
        local kind = o.childKind
        local callbacks = assert(program.formationKinds[kind],'编队的子机类型超出 ROM 表')
        if #queue < 40 then
            queue[#queue+1] = {run.major,run.minor,kind,o.spawnFlags,0,o.childPath,0,
                callbacks[1],callbacks[2],callbacks[3],h=o.h,l=o.l,index=o.childIndex}
        end
        o.childIndex = o.childIndex+1
        if o.remaining > 0 then
            o.remaining = o.remaining-1
            if o.remaining == 0 then return false end
        end
        return true
    end

    return M
end
