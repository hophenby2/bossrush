-- 0x195256 是关底前飞过的飞机，0x168082 是三段告警动画。
return function(program, path, remove)
    local s16, world = program.s16, program.world
    local floor = math.floor
    local M = {parts=1}

    function M.init(o)
        o.flags = 0x8000
        if o.callback == 0x168082 then
            o.h, o.l = 0x4000, 0x1c00
            o.warning, o.warningPhase, o.limit = true, 0, 6
            o.frameIndex, o.frameClock = 0, 0
            return true
        end
        if not path.attach(o) then return false end
        o.h, o.speedClock, o.frameIndex, o.frameClock = s16(o.h + 0x200), 0x120, 0, 0
        return true
    end

    local function warning(o)
        o.l = 0x1c00
        o.frameClock = o.frameClock - 1
        if o.frameClock >= 0 then return end
        o.frameIndex = o.frameIndex + 1
        local frame = program.warning[o.frameIndex]
        o.image, o.frameClock = frame[1], frame[2]
        if o.warningPhase == 0 and o.frameIndex == 30 then
            o.warningPhase = 1
        elseif o.warningPhase == 1 and o.frameIndex == 37 then
            o.frameIndex, o.limit = 32, o.limit - 1
            if o.limit < 0 then o.warningPhase = 2 end
        elseif o.warningPhase == 2 and o.frameIndex == #program.warning then
            remove(o)
        end
    end

    local function flyby(o)
        local run = o.run
        if run.freeze then return end
        o.h = s16(o.h - run.scrollStep * 64)
        path.move(o)
        o.speedClock = o.speedClock - 1
        if o.speedClock == 0 then
            o.speed, o.direction, o.acceleration = 5, 0x37, 8
        end
        if o.acceleration then
            o.acceleration = o.acceleration - 1
            if o.acceleration < 0 then o.acceleration, o.speed = 8, o.speed + 1 end
        end
        if o.l <= -0x2200 then remove(o); return end
        o.frameClock = o.frameClock - 1
        if o.frameClock < 0 then
            o.frameClock = 0
            o.frameIndex = (o.frameIndex + (o.speed >= 0x10 and 3 or 1)) % 16
        end
        o.x, o.y = world(o.h, o.l)
    end

    function M.step(o)
        if o.warning then warning(o) else flyby(o) end
    end

    local function draw(o, sprite, h, l)
        local img = o.run.art[sprite]
        local x, y = world(h, l)
        Render(img[1], floor(x) + img[2] / 2, floor(y) + img[3] / 2)
    end

    function M.render(o)
        if not o.run.art then return end
        if o.warning then
            if o.image then draw(o, o.image, o.h - 0x800, o.l - 0x1c00) end
        else
            draw(o, program.flyby[1], o.h, o.l)
            draw(o, program.flyby[o.frameIndex + 2], o.h - 0x240, o.l + 0x80)
        end
    end

    return M
end
