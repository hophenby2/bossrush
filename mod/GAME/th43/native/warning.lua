-- 0xe86dc 挂载五面共用的场景演出。0xe8f36 不登记受击部件或敌弹。
return function(program)
    local floor, max = math.floor, math.max
    local data = program.warning
    local M = {}

    local function setParts(o, phase)
        for _, part in ipairs(o.parts) do part.phase = phase end
    end

    local function stepParts(o)
        local ready, target = true, o.phase == 4 and 5 or 3
        for _, part in ipairs(o.parts) do
            if part.phase == 1 then
                part.clock = part.clock - 1
                if part.clock < 0 then part.phase = 2 end
            end
            if part.phase == 2 then
                part.fade = max(0, part.fade - 7)
                part.frame = part.frame + 1
                if part.frame == 8 then part.phase, part.fade, part.clock = 3, 0, part.art.clock end
            elseif part.phase == 4 then
                if part.clock > 0 then
                    part.clock = part.clock - 1
                else
                    part.frame = part.frame + 1
                    if part.frame == 17 then part.phase = 5 end
                end
            end
            if part.phase ~= target then ready = false end
        end
        o.partsReady = ready
    end

    local function draw(o, frame, zoom)
        local image = o.run.art.sprites[frame[1]]
        if image then
            local x, y = program.world(frame[2], frame[3])
            Render(image[1], x + image[2] / 2, y + image[3] / 2, 0, zoom or 1, 1)
        end
    end

    local Warning = Class(object, {
        init = function(o, run)
            o.run, o.art, o.phase = run, data[run.stageNumber], 0
            o.group, o.layer, o.colli, o.bound = GROUP.GHOST, LAYER.ENEMY, false, false
            o.frameIndex, o.clock, o.delay, o.cycles,
                o.soundClock, o.soundDelay, o.sounds = unpack(data.settings)
            o.parts = {}
            for i, part in ipairs(o.art.parts) do
                o.parts[i] = {phase=0,frame=0,fade=0xff,clock=part.clock,art=part}
            end
        end,
        render = function(o)
            local run = o.run
            if run.pilotH and math.abs(0x49c0 - run.pilotH) < 0x1400 and run.frame % 2 == 0 then return end
            if o.frameIndex >= 0 then draw(o, o.art.core[o.frameIndex + 1]) end
            for _, part in ipairs(o.parts) do
                if part.phase > 1 and part.phase < 5 then
                    local frame = part.art[part.frame + 1]
                    if frame[3] > -0x1800 then
                        local skipped = data.zoom[floor((0xff - part.fade) / 16) + 1] or 0
                        draw(o, frame, 1 - skipped / 32)
                    end
                end
            end
        end,
    })

    function M.spawn(run)
        run.warning = New(Warning, run)
    end

    function M.step(o)
        if o.sounds > 0 then
            o.soundClock = o.soundClock - 1
            if o.soundClock < 0 then
                o.soundClock, o.sounds = o.soundDelay, o.sounds - 1
            end
        end
        if o.phase == 0 then
            setParts(o, 1)
            o.phase = 1
        end
        if o.phase == 1 and o.partsReady then o.phase = 2 end
        if o.phase == 2 or o.phase == 3 then
            o.clock = o.clock - 1
            if o.clock < 0 then
                o.clock = o.delay
                if o.phase == 2 then
                    o.frameIndex = o.frameIndex + 1
                    if o.frameIndex == 8 then o.delay = 1 end
                    if o.frameIndex == 23 then
                        o.frameIndex, o.cycles = 8, o.cycles - 1
                        if o.cycles == 0 then
                            o.phase = 3
                            setParts(o, 4)
                            o.clock = o.clock - 1
                        end
                    end
                else
                    o.frameIndex = o.frameIndex - 1
                    if o.frameIndex < 0 then o.phase = 4 end
                end
            end
        end
        if o.phase == 4 and o.partsReady and o.sounds == 0 then
            M.close(o)
            return
        end
        stepParts(o)
    end

    function M.close(o)
        o.run.warning = nil
        object.RawDel(o)
    end

    return M
end
