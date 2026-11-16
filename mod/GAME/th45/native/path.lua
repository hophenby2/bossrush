-- 0x14f162 在路径的坐标上加生成记录的 32 位偏移，随后执行路径头。
return function(program)
    local band = require('bit').band
    local word,s16 = program.word,program.s16
    local path = dofile('mod/GAME/th43/native/path.lua')(program,{commands={
        [11]=function(o,cursor,value)
            o.part[0x22] = value
            return cursor
        end,
        [12]=function(_,cursor) return cursor - 1 end,
    }})

    function path.attach(o, row)
        local stage = o.run.stage
        local cursor = row.path and 1 or row[6] - stage.pathBase + 1
        o.path = row.path or stage.paths
        local h,l
        if row.h then
            h,l = row.h,row.l
            if band(o.spawnFlags,1) ~= 0 then l = l + o.run.cameraOffset end
        else
            h,l = word(o.path,cursor),word(o.path,cursor + 2)
            cursor = cursor + 4
        end
        o.h,o.l = program.addPacked(h,l,row[7])
        if not path.start(o,cursor) then return false end
        o.l = s16(o.l - 0x800)
        return true
    end

    return path
end
