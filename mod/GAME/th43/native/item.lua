-- 0xf4b30 的四种物品分槽，0xf4c18 调度物品各自的运动和拾取。
return function(program, score)
    local bit = require('bit')
    local band, bor = bit.band, bit.bor
    local s16 = program.s16
    local floor, abs, min, max = math.floor, math.abs, math.min, math.max
    local data, life = program.item, program.lifeDrop
    local firstSlot, lastSlot = {[0]=1,[4]=9,[8]=11,[12]=13}, {[0]=8,[4]=10,[8]=12,[12]=13}
    local M = {}

    local function remove(o)
        o.run.itemSlots[o.slot] = nil
        object.RawDel(o)
    end

    local Drop = Class(object, {
        init = function(o, run, slot, kind, h, l)
            o.run, o.slot, o.kind, o.h, o.l = run, slot, kind, h, s16(l + run.cameraStep)
            o.front, o.back = 0x600, 0x600
            o.right, o.left = kind == 4 and 0x700 or 0x500, kind == 4 and 0x700 or 0x500
            o.clock, o.index, o.frames = 2, 1, kind == 12 and life.sprites or data[kind]
            o.drawH = kind == 12 and -0x400 or -0x600
            o.drawL = (kind == 4 or kind == 12) and -0x400 or -0x300
            o.group, o.layer, o.colli, o.bound = GROUP.GHOST, LAYER.ENEMY + 1, false, false
        end,
        render = function(o)
            local image = o.run.art.sprites[o.frames[o.index]]
            local x, y = program.world(o.h + o.drawH, o.l + o.drawL)
            Render(image[1], floor(x)+image[2]/2, floor(y)+image[3]/2)
        end,
    })

    function M.spawn(run, kind, h, l)
        for slot = firstSlot[kind], lastSlot[kind] do
            if not run.itemSlots[slot] then
                local o = New(Drop, run, slot, kind, h, l)
                run.itemSlots[slot] = o
                return o
            end
        end
    end

    function M.contact(run, player, h, l, front, back, right, left)
        for slot = 1, 13 do
            local o = run.itemSlots[slot]
            if o and o.speed and not o.taken and not o.collector
                and program.overlap(o, h, l, front, back, right, left) then
                o.collector = player
            end
        end
    end

    local function collect(o, pilot)
        local kind, points = o.kind, 100
        local frames, offset
        if kind == 0 or kind == 4 then
            local full = pilot.level == 5
            if not full then pilot.level = kind == 4 and 5 or pilot.level + 1 end
            frames, offset = data.powerTaken, -0xa00
            if full then frames, offset, points = data.powerFull, -0x500, 1000 end
        else
            local gained
            if kind == 8 then
                gained = pilot.bombs < 6
                if gained then pilot.bombs = pilot.bombs + 1 end
                frames = data.bombTaken
            else
                gained, frames = score.extraLife(pilot), life.taken
            end
            offset = -0xa00
            if not gained then frames, offset, points = life.full, -0x600, 10000 end
        end
        score.add(pilot, points)
        o.taken, o.frames, o.drawH, o.drawL = true, frames, -0x400, offset
        o.clock, o.index, o.collector = 2, 1, nil
        o.angle = band(o.l + o.run.cameraStep, 0xffff) < 0x1c00 and 0x10 or 0x30
        local random = s16(program.random(o.run, program.effectRandom) * 256) / 256
        o.speed = 7 + band(abs(random), 6)
    end

    -- 0xadb02 对横轴乘 1.5，炸弹以原表角度飞近 (0x4600,0x1c00) 再转入盘旋。
    local function bombAngle(o)
        return program.angle(o.h,o.l,0x4600,0x1c00,o.angle)
    end

    local function bounce(o)
        if o.life == 0 then return end
        if not o.run.freeze then o.life = o.life - 1 end
        local turn
        if band(o.l + 0x800, 0xffff) <= 0xb00 then
            o.l = 0x300
            if o.angle >= 0x20 then
                if band(o.h, 0xffff) >= (o.kind == 4 and 0x3500 or 0x2b00) then o.angle = 0x28 end
                turn = -o.angle
            end
        elseif band(o.l + 0x800, 0xffff) >= 0x3d00 then
            o.l = 0x3500
            if o.angle <= 0x20 then
                if band(o.h, 0xffff) >= 0x2b00 then o.angle = 0x18 end
                turn = -o.angle
            end
        end
        if turn then o.angle = band(turn + program.random(o.run, program.effectRandom), 0x3f) end
        if (band(o.h, 0xffff) >= 0x6d00 and (o.angle < 0x10 or o.angle > 0x30))
            or (band(o.h, 0xffff) <= 0x700 and o.angle > 0x10 and o.angle <= 0x30) then
            o.angle = band(-0x20 - o.angle + program.random(o.run, program.effectRandom), 0x3f)
        end
    end

    local function moveBomb(o)
        if not o.orbit then
            o.angle = bombAngle(o)
            local h = abs(s16(o.h - 0x4600))
            local l = abs(s16(o.l - 0x1c00))
            h = h - floor(h / 4)
            if max(h, l) + floor(min(h, l)/2) <= 0x200 then
                o.orbit, o.speed, o.delay, o.interval = true, 10, 7, 0x14
                o.angle = band(-band(o.angle - 8, 0x30), 0x3f)
            end
        elseif not o.run.freeze then
            o.life = o.life - 1
            if o.life < 0 then return end
            o.delay = o.delay - 1
            if o.delay == 0 then
                o.angle = band(o.angle + 0x10, 0x3f)
                o.interval = band(o.interval + 8, 0xff)
                o.delay = o.interval
            end
        end
    end

    local function step(o)
        local run = o.run
        o.l = s16(o.l - run.cameraStep)
        if not o.speed then
            o.speed, o.angle, o.life = 0, 0, 0x700
            if o.kind == 0 then
                o.speed, o.angle = 11, 0x18 + band(program.random(run, program.randomParity),0xf)
            elseif o.kind == 4 then
                o.speed, o.angle = 11, bor(program.random(run, program.enemyRandom), 8)
            elseif o.kind == 8 then
                o.speed, o.angle = 11, bombAngle(o)
            end
        end
        if o.collector then
            collect(o, o.collector)
            return
        end
        if not o.taken and not run.stageEnding then
            if o.kind == 8 then moveBomb(o)
            elseif o.kind ~= 12 then bounce(o) end
        end
        if not run.freeze then
            if o.kind == 12 and not o.taken then
                local _, drift = program.vector(4, run.frame)
                o.h, o.l = s16(o.h - 0x30), s16(o.l + drift)
            else
                local h, l = program.vector(o.speed, o.angle * 4)
                o.h, o.l = s16(o.h + h), s16(o.l + l)
            end
        end
        o.clock = o.clock - 1
        if o.taken then
            if o.clock == 0 then
                o.clock, o.index = 2, o.index + 1
                if o.index > #o.frames then remove(o) end
            end
        elseif band(o.h + 0x800, 0xffff) >= 0x8000
            or band(o.l + 0x1c00 + run.cameraOffset, 0xffff) >= 0x7000 then
            remove(o)
        elseif o.clock < 0 then
            o.clock, o.index = 2, o.index % 4 + 1
        end
    end

    function M.step(run)
        for slot = 1, 13 do
            local o = run.itemSlots[slot]
            if o then step(o) end
        end
    end

    function M.clear(run)
        for _, o in pairs(run.itemSlots) do remove(o) end
    end

    return M
end
