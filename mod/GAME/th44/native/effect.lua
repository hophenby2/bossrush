-- 0x187354 分配爆炸槽，0x1871a2 按槽推进图像指令、延迟和碎片运动。
return function(program)
    local band = require('bit').band
    local s16, world = program.s16, program.world
    local floor = math.floor
    local M = {}

    local function nextImage(o)
        o.cursor = o.cursor + 1
        local row = o.frames[o.cursor]
        if not row then return false end
        o.clock, o.drawH, o.drawL, o.sprite = row[1], row[2], row[3], row[6]
        o.h, o.l = program.addPacked(o.h, o.l, row[4], row[5])
        return true
    end

    local Effect = Class(object, {
        init = function(o, run, slot, h, l, command)
            o.run, o.slot, o.h, o.l = run, slot, h, l
            o.kind = command[1]
            o.frames = assert(program.effects[o.kind], '缺少爆炸图像指令')
            o.delay, o.shiftH, o.shiftL = command[2], command[3], command[4]
            o.dh, o.dl = program.vector(command[5] or 0, command[6] or 0)
            o.flip, o.scrolls = command.flip, command.scrolls
            o.cursor = 0
            o.group, o.layer, o.bound, o.colli = GROUP.GHOST, LAYER.ENEMY + 1, false, false
        end,
        render = function(o)
            if not o.sprite or not o.run.art then return end
            local image = o.run.art[o.sprite]
            local x, y = world(o.h + o.drawH, o.l + o.drawL)
            Render(image[1], floor(x) + image[2] / 2, floor(y) + image[3] / 2, 0, 1, o.flip and -1 or 1)
        end,
    })

    function M.emit(o, commands)
        local run = o.run
        for _, command in ipairs(commands) do
            for slot = 1, 80 do
                if not run.effects[slot] then
                    run.effects[slot] = New(Effect, run, slot, o.h, o.l, command)
                    break
                end
            end
        end
    end

    local function remove(o)
        o.run.effects[o.slot] = nil
        object.RawDel(o)
    end

    local function update(o)
        if o.delay > 0 then o.delay = o.delay - 1; return end
        if o.cursor == 0 then
            nextImage(o)
            o.clock = o.clock + 1
            o.h, o.l = program.addPacked(o.h, o.l, o.shiftH, o.shiftL)
        end
        local run = o.run
        local scroll = o.scrolls and run.scrollStep * 64 or 0
        o.h, o.l = s16(o.h + o.dh - scroll), s16(o.l + o.dl - run.cameraStep)
        local outside = band(o.l + 0x1000, 0xffff) >= 0x5800 or band(o.h + 0x1000, 0xffff) >= 0x9000
        o.clock = o.clock - 1
        if outside or o.clock < 0 and not nextImage(o) then
            remove(o)
        else
            o.x, o.y = world(o.h, o.l)
        end
    end

    function M.step(run)
        for slot = 1, 80 do
            local o = run.effects[slot]
            if o then update(o) end
        end
    end

    function M.close(run)
        for _, o in pairs(run.effects) do remove(o) end
    end

    return M
end
