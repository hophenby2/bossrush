-- 0x17e1b4 分配地面掉落。各道具保留自己的原版回调和动画索引。
return function(program)
    local band = require('bit').band
    local s16, world = program.s16, program.world
    local byte, floor, min = string.byte, math.floor, math.min
    local M = {}

    local function random(run, values)
        run.randomByte = band(run.randomByte + 1, 0xff)
        return byte(values, band(run.randomByte, #values - 1) + 1)
    end

    local function chip(o)
        o.clock = o.clock - 1
        if o.clock < 0 then
            o.clock, o.frameIndex = 1, o.frameIndex % #o.images + 1
        end
        if not o.run.freeze then o.speed = band(o.speed + 1, 0xff) end
        o.dh, o.dl = program.vector(o.speed, o.angle * 4)
    end

    local function bee(o)
        o.clock = o.clock - 1
        if o.clock < 0 then o.frameIndex, o.clock = 2, 2
        else o.frameIndex = 1 end
        o.motionClock = o.motionClock - 1
        if o.motionClock == 0 then
            local motion = program.beeMotion[o.motionOffset / 6 + 1]
            o.motionOffset, o.motionClock, o.dh, o.dl = unpack(motion)
        end
        o.h = s16(o.h - 0x60)
    end

    local function star(o)
        if o.run.clearActors then return end
        o.clock = o.clock - 1
        if o.clock < 0 then
            o.frameIndex = o.frameIndex % #o.images + 1
            o.clock = o.kind == 0xc and 2 or 1
        end
        o.h = s16(o.h - o.run.scrollStep * 64)
    end

    local Item = Class(object, {
        init = function(o, host, slot, kind, layer, h, l)
            o.slot, o.run, o.kind = slot, host.run, kind
            o.h, o.l = h, l
            o.dh, o.dl = 0, 0
            o.group, o.layer, o.bound, o.colli = GROUP.GHOST, LAYER.ENEMY + layer / 4, false, false
            if kind == 0x1c then
                local run = o.run
                o.speed = 9 + floor(math.abs(program.bossSmallRandom(run)) / 2)
                local a = program.bossRandom(run) + 1
                o.angle = band(0x20 + program.dropSpeedRandom(run) - a,0x3f)
                o.front,o.back,o.right,o.left = 0x980,0x980,0x780,0x780
                o.images,o.drawH,o.drawL,o.clock,o.update = program.pilotHyper.chips,-0x800,-0x600,1,chip
                o.frameIndex = 1
            elseif kind == 0 or kind == 0x10 then
                local run = o.run
                if kind == 0x10 then
                    o.frameIndex = 1
                    o.speed = 4 + floor(math.abs(program.bossRandom(run)) / 2)
                    local a = program.bossSmallRandom(run)
                    o.angle = band(0x24 + program.dropSpeedRandom(run) - a, 0x3f)
                else
                    o.frameIndex = band(random(run, program.dropRandom), 0x0e) + 1
                    o.speed = 4 + floor(random(run, program.dropSpeed) / 2)
                    local a = random(run, program.dropAngle)
                    local b = random(run, program.dropSpeed)
                    o.angle = band(0x1f + b - (a < 0x80 and a or a - 0x100), 0x3f)
                end
                o.front, o.back, o.right, o.left = 0x580, 0x580, 0x480, 0x480
                o.images, o.drawH, o.drawL, o.clock, o.update = program.chips, -0x400, -0x200, 1, chip
            elseif kind == 8 then
                o.front, o.back, o.right, o.left = 0x680, 0x680, 0x500, 0x500
                o.images, o.drawH, o.drawL, o.clock, o.update = program.stars, -0x400, -0x300, 1, star
                o.frameIndex = 1
                o.clock = o.clock + band(program.randomEnemy(o.run), 0x1f)
            elseif kind == 0xc then
                o.front, o.back, o.right, o.left = 0xa80, 0xa80, 0x880, 0x880
                o.images, o.drawH, o.drawL, o.clock, o.update = program.largeStars, -0x800, -0x600, 2, star
                o.frameIndex = 1
                o.clock = o.clock + band(program.randomEnemy(o.run), 0x1f)
            else
                o.front, o.back, o.right, o.left = 0x980, 0x980, 0x780, 0x780
                o.motionOffset, o.motionClock = 0x96, 1
                o.images, o.drawH, o.drawL, o.clock, o.update = program.ground, -0x600, -0x300, 0, bee
                o.frameIndex = 1
            end
        end,
        render = function(o)
            if not o.run.art then return end
            local image = o.run.art[o.images[o.frameIndex]]
            local x, y = world(o.h + o.drawH, o.l + o.drawL)
            Render(image[1], floor(x) + image[2] / 2, floor(y) + image[3] / 2)
        end,
    })

    local function remove(o)
        o.run.items[o.slot] = nil
        object.RawDel(o)
    end

    function M.emit(host, kind, shiftH, shiftL)
        local run = host.run
        assert(kind == 0 or kind == 8 or kind == 0xc or kind == 0x10 or kind == 0x1c or kind == 0x40,
            '尚未翻译地面掉落类型')
        local h, l = program.addPacked(host.h, host.l, shiftH or 0, shiftL or 0)
        l = s16(l + run.cameraStep)
        if band(h + 0x800, 0xffff) >= 0xa000
            or band(l + 0xe00 + run.cameraOffset, 0xffff) >= 0x5400 then return end
        for slot = 1, 70 do
            if not run.items[slot] then
                local layer = host.part and host.part[0x1f] or 0
                run.items[slot] = New(Item, host, slot, kind, layer, h, l)
                return
            end
        end
    end

    function M.step(run,hyper)
        for slot = 1, 70 do
            local o = run.items[slot]
            if o then
                local pilot = run.player
                if o.taken and pilot then
                    if o.kind == 0 or o.kind == 0x10 then
                        pilot.score = pilot.score + 50
                        pilot.chips = min(999, pilot.chips + 1)
                    elseif o.kind == 8 then
                        pilot.score = pilot.score + 50
                        pilot.stars = min(999, pilot.stars + 1)
                    elseif o.kind == 0xc then
                        pilot.score = pilot.score + 1000
                        pilot.stars = min(999, pilot.stars + 2)
                    elseif o.kind == 0x1c then
                        -- 0x17ee40 的 Hyper 大道具增加八个小道具计数。
                        pilot.score = pilot.score + 1000
                        pilot.chips = min(999,pilot.chips + 8)
                    else
                        local multiplier = hyper.bee(pilot)
                        local score = program.beeScore[pilot.fullBeeStages + 1]
                        pilot.bees = pilot.bees + 1
                        -- 0x17e486 仅在本面无失误拾到第十个地蜂时累计一面。
                        local complete = pilot.bees == 10 and pilot.stageMisses == 0
                        if complete then pilot.fullBeeStages = pilot.fullBeeStages + 1 end
                        if score then pilot.score = pilot.score + (complete and 2 * score or score) * multiplier end
                    end
                    remove(o)
                else
                    o.l = s16(o.l - run.cameraStep)
                    o.update(o)
                    o.h, o.l = s16(o.h + o.dh), s16(o.l + o.dl)
                    local flying = o.kind == 0 or o.kind == 0x10 or o.kind == 0x1c
                    local outside = flying and o.h < (o.kind == 0x1c and -0x600 or 0) or not flying and
                        (band(o.h + 0x800, 0xffff) >= 0x8800
                        or band(o.l + 0x1c00 + run.cameraOffset, 0xffff) >= 0x7000)
                    if outside or (o.kind == 8 or o.kind == 0xc) and run.clearActors then
                        remove(o)
                    else
                        o.x, o.y = world(o.h, o.l)
                    end
                end
            end
        end
    end

    function M.contact(run, pilot)
        for slot = 1, 70 do
            local o = run.items[slot]
            if o and o.h ~= 0 and pilot.h + pilot.front >= o.h - o.back and pilot.h - pilot.back <= o.h + o.front
                and pilot.l + pilot.right >= o.l - o.left and pilot.l - pilot.left <= o.l + o.right then
                o.taken = true
            end
        end
    end

    function M.close(run)
        for _, o in pairs(run.items) do remove(o) end
    end

    return M
end
