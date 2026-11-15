-- 0x15fb32 与 0x1608f0。每面有两路指令，只有主路推进生成计数。
return function(program)
    local ceil, floor, min, max = math.ceil, math.floor, math.min, math.max
    local capacities = {70,110,160,190,210}
    local M = {}
    local commands = {}

    commands[4] = function(run, layer, row)
        local tile = run.mapRow[layer] + program.s16(row[4])
        run.mapRow[layer] = tile
        run.mapLoop[layer] = {start=tile, period=row[5], remaining=row[5] + 1, count=row[6]}
    end

    commands[8] = function(run, layer, row)
        run.scrollSpeed[layer] = row[4]
    end

    commands[12] = function(run, layer)
        run.holdMajor = true
        run.releaseMajor[layer] = run.major + 4
    end

    commands[24] = function(run, _, row)
        run.bulletCapacity = math.max(run.bulletCapacity, assert(capacities[row[4] + 1]))
    end

    -- 0x16096c、0x1609ee、0x160a0e 由调色板、场景对象和关卡事件消费。
    local function dispatch(run, layer, row)
        local handler = commands[row[3]]
        if handler then handler(run, layer, row) end
        if run.onScrollCommand then run.onScrollCommand(run, layer, row) end
    end

    local function events(run)
        for layer = 1, 2 do
            local list = run.stage.scroll[layer]
            local cursor = run.scrollIndex[layer]
            while list[cursor] and list[cursor][1] == run.major do
                dispatch(run, layer, list[cursor])
                cursor = cursor + 1
            end
            run.scrollIndex[layer] = cursor
        end
    end

    function M.init(run)
        run.scrollIndex, run.scrollSpeed = {1,1}, {0x20,0x20}
        run.mapRow, run.tileProgress, run.mapLoop, run.releaseMajor = {16,16}, {0,0}, {}, {}
        run.visibleRows = {}
        for row = 1, 15 do run.visibleRows[row] = run.stage.tiles[row] end
        run.visibleTop = 0
        run.majorProgress, run.actorProgress, run.scrollStep = 0, 0, 0
        run.cameraOffset, run.cameraStep = 0, 0
        run.cameraFine, run.cameraClipped, run.cameraRelative = 0, false, true
    end

    local function advanceTile(run, layer)
        local loop = run.mapLoop[layer]
        if loop then
            loop.remaining = loop.remaining - 1
            if loop.remaining == 0 then
                if loop.count ~= 0xffff then loop.count = loop.count - 1 end
                if loop.count == 0 then
                    run.mapLoop[layer], run.holdMajor = nil, false
                    run.major = run.releaseMajor[layer] or run.major
                else
                    run.mapRow[layer], loop.remaining = loop.start, loop.period
                end
            end
        end
        if layer == 1 then
            run.visibleTop = (run.visibleTop + 1) % 64
            table.remove(run.visibleRows, 1)
            local tiles = assert(run.stage.tiles[run.mapRow[layer]], '场景图块越过原版卷轴表')
            run.visibleRows[15] = tiles
        end
        run.mapRow[layer] = run.mapRow[layer] + 1
    end

    -- 关卡滚动持续写下一条硬件行，场景对象可覆盖当前已经写过的行。
    function M.replaceRows(run, start, rows)
        for offset, tiles in ipairs(rows) do
            local index = (start + offset - 1 - run.visibleTop) % 64 + 1
            if index <= #run.visibleRows then run.visibleRows[index] = tiles end
        end
    end

    -- 0x15fcfa。边缘前使用移动量，触及画面边缘后改按自机相对中轴的距离移动。
    function M.camera(run)
        run.cameraStep = 0
        local pilot = run.player
        if run.freeze or not pilot or not pilot.active then return end
        local l, motion = pilot.l, pilot.cameraMotion or 0
        local left, right = l <= 0x300, l >= 0x3500
        if run.cameraClipped and (left and motion < 0 or right and motion > 0) then
            run.cameraRelative = false
        end
        local delta = 0
        if not run.cameraRelative then
            local center = l - 0x1c00
            local truncate = center < 0 and ceil or floor
            delta = truncate(center / 200) * 64 - run.cameraOffset
        elseif not (left and motion < 0 or right and motion > 0) then
            local quarter = floor(motion / 4)
            delta = quarter + floor(quarter / 2)
        end
        local requested = run.cameraFine + delta
        local fine = max(-0x800, min(0x800, requested))
        local rounded = floor(fine / 64) * 64
        run.cameraClipped, run.cameraFine = requested ~= fine, fine
        run.cameraOffset, run.cameraStep = rounded, rounded - run.cameraOffset
    end

    function M.step(run)
        if run.freeze then run.scrollStep = 0; return end
        events(run)
        local speed = run.scrollSpeed[1]
        local progress = run.majorProgress + speed
        if progress >= 0x200 then
            progress = progress - 0x200
            if not run.holdMajor then run.major = run.major + 1 end
        end
        run.majorProgress = progress
        local fixed = run.actorProgress + speed
        run.scrollStep, run.actorProgress = floor(fixed / 64), fixed % 64
        for layer = 1, 2 do
            local tile = run.tileProgress[layer] + run.scrollSpeed[layer]
            if tile >= 0x800 then
                tile = tile - 0x800
                advanceTile(run, layer)
            end
            run.tileProgress[layer] = tile
        end
    end

    return M
end
