-- 0x0cfb5a 与 0x0cfc24。敌机对象持有路径游标、持续时间、速度和判定标志。
return function(program)
    local bit = require('bit')
    local band, bor = bit.band, bit.bor
    local s16, word = program.s16, program.word
    local byte = string.byte
    local commands = {}
    commands[0] = function(o, cursor, value)
        return cursor - value * 2
    end
    commands[1] = function(o, cursor, value)
        o.part[0x1f] = value
        return cursor
    end
    commands[2] = function(o, cursor, value)
        o.flags = value == 1 and band(o.flags, 0xdfff) or bor(o.flags, 0x2000)
        return cursor
    end
    commands[3] = function(o, cursor, value)
        o.flags = value == 1 and band(o.flags, 0xdffe) or bor(o.flags, 0x2001)
        return cursor
    end
    commands[4] = function(o, cursor, value)
        o.state[0x22] = value
        return cursor
    end
    local function setWord(data, offset, value)
        data[offset], data[offset + 1] = bit.rshift(value, 8), band(value, 0xff)
    end
    local function pathWord(o, cursor, offset, target)
        local first, second = word(o.path, cursor), word(o.path, cursor + 2)
        local value = bit.lshift(band(first, 0xff0), 4) + bit.rshift(band(second, 0xff0), 4)
        setWord(target, offset, value)
        return cursor + 4
    end
    commands[5] = function(o, cursor, value)
        return pathWord(o, cursor, value, o.state)
    end
    commands[6] = function(o, cursor, value)
        return pathWord(o, cursor, value, o.part)
    end
    commands[7] = function(o, cursor, value)
        o.state[0x24] = value
        return cursor
    end
    commands[8] = function(o, cursor, value)
        o.part[0x1e] = value
        return cursor
    end
    commands[9] = function(o, cursor)
        o.l = s16(o.l - o.run.cameraOffset)
        return cursor
    end

    local function parameters(o, cursor)
        -- 0x8a 直接退回对象循环。0x8b 不取参数。
        for _ = 1, #o.path do
            local op = assert(byte(o.path, cursor), '敌机路径越过 ROM 数据')
            if op < 0x80 then return cursor, op end
            if op >= 0xc0 then
                o.speed = byte(o.path, cursor + 1)
                cursor = cursor + 2
            else
                local index = band(op, 15)
                if index == 10 then return nil end
                if index == 11 then
                    cursor = cursor + 1
                else
                    local command = assert(commands[index], '未知敌机路径指令')
                    cursor = command(o, cursor + 2, byte(o.path, cursor + 1))
                end
            end
        end
        error('敌机路径缺少可执行的移动指令')
    end

    local P = {}
    function P.start(o, cursor)
        o.cursor, o.direction = parameters(o, cursor)
        if not o.cursor then return false end
        o.elapsed, o.newVelocity = 0, true
        return true
    end

    function P.init(o, row)
        local stage = o.run.stage
        o.path = row.path or stage.paths
        local cursor = row.path and 1 or row[6] - stage.pathBase + 1
        if row.h then
            o.h, o.l = program.add(row.h, s16(row.l + o.run.cameraOffset), row[7], row[8])
        else
            o.h, o.l = program.add(word(o.path, cursor), word(o.path, cursor + 2), row[7], row[8])
            cursor = cursor + 4
        end
        if not P.start(o, cursor) then return false end
        o.l = s16(o.l - 0x800)
        if band(row[4], 1) ~= 0 then o.l = s16(o.l - o.run.cameraOffset) end
        return true
    end

    function P.move(o)
        local h, l = program.vector(o.speed, o.direction * 4)
        o.h, o.l = s16(o.h + h), s16(o.l + l)
    end

    function P.step(o, groundScroll)
        if o.run.freeze then return true end
        if band(o.spawnFlags, 1) ~= 0 then o.h = s16(o.h - (groundScroll or o.run.scrollStep * 64)) end
        local cursor = o.cursor
        local direction, duration = byte(o.path, cursor, cursor + 1)
        if direction >= 0x80 or (duration ~= 0 and duration == o.elapsed) then
            if direction < 0x80 then cursor = cursor + 2 end
            cursor, direction = parameters(o, cursor)
            if not cursor then return false end
            duration = byte(o.path, cursor + 1)
            o.cursor, o.elapsed, o.newVelocity = cursor, 0, true
        end
        if duration ~= 0 then o.elapsed = o.elapsed + 1 end
        o.direction = direction
        if direction < 0x40 then
            if o.newVelocity then
                o.dh, o.dl = program.vector(o.speed, direction * 4)
                o.newVelocity = false
            end
            o.h, o.l = s16(o.h + o.dh), s16(o.l + o.dl)
        end
        return true
    end
    return P
end
