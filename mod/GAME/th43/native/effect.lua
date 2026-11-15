-- 0xfef24 的爆炸槽。每个对象持有延迟、速度以及从 ROM 读取的动画指令游标。
return function(program, score)
    local band = require('bit').band
    local floor, max = math.floor, math.max
    local s16 = program.s16
    local M = {}

    local function nextFrame(o)
        o.cursor = o.cursor + 1
        local row = o.frames[o.cursor]
        if not row then return false end
        o.clock, o.drawH, o.drawL = row[1], row[2], row[3]
        o.h, o.l = program.add(o.h, o.l, row[4], row[5])
        o.sprite = row[o.spriteIndex]
        return true
    end

    local Effect = Class(object, {
        init = function(o, run, slot, h, l, command, scrolls, random)
            o.run, o.slot, o.h, o.l = run, slot, h, l
            o.delay, o.frames, o.spriteIndex = command[1], assert(program.effects[command[2]], '缺少爆炸动画'),
                band(command[3], 0x40) == 0 and 6 or 7
            o.startH, o.startL, o.speed = command[4], command[5], command[6]
            o.angle, o.cursor = band(command[7] + random, 0xff), 0
            o.scrolls = scrolls
            o.group, o.layer, o.colli, o.bound = GROUP.GHOST, LAYER.ENEMY + 1, false, false
        end,
        render = function(o)
            if not o.sprite then return end
            local image = o.run.art.sprites[o.sprite]
            Render(image[1], floor((o.l + o.drawL) / 64) - 112 + image[2] / 2,
                floor((o.h + o.drawH) / 64) - 224 + image[3] / 2)
        end,
    })

    local function smokeFrame(o)
        local frame = program.attachedSmoke[o.source[o.phase+4]]
        o.frames = frame.art[o.run.stageNumber][o.flip]
        o.image,o.nextImage,o.drawH,o.drawL = #o.frames,#o.frames,frame.h,frame.l
        local stagger = o.run.smokeStagger or 0
        o.clock = frame.clock-stagger
        o.run.smokeStagger = (stagger-4)%16
    end

    -- 0x101192 与 0x101306 共用十个附着槽，旧槽在载具退场时失效。
    local Smoke = Class(object, {
        init = function(o, host, row)
            o.host,o.run,o.source,o.phase = host,host.run,row,1
            o.flip = row[4] == 0x20 and 2 or row[4] == 0x40 and 3 or 1
            o.group,o.layer,o.colli,o.bound = GROUP.GHOST,LAYER.ENEMY+1,false,false
            smokeFrame(o)
        end,
        render = function(o)
            if not o.h or o.run.frame%2==0 then return end
            local image = o.run.art.sprites[o.frames[o.image]]
            Render(image[1],floor((o.l+o.drawL)/64)-112+image[2]/2,
                floor((o.h+o.drawH)/64)-224+image[3]/2)
        end,
    })

    function M.attachSmoke(host, script)
        local run = host.run
        local cursor = host.smokeCursor or 1
        local row = script[cursor]
        if not row or host.hp>row[1] then return end
        run.smoke = run.smoke or {}
        for slot=1,10 do
            if not run.smoke[slot] then
                run.smoke[slot] = New(Smoke,host,row)
                cursor = cursor+1
                host.smokeCursor = cursor
                row = script[cursor]
                if not row or host.hp>row[1] then return end
            end
        end
    end

    function M.spawn(run, h, l, commands, scrolls, fixedAngle)
        for _, command in ipairs(commands) do
            local random = fixedAngle and 0 or program.random(run, program.effectRandom)
            for slot = 1, 80 do
                if not run.effects[slot] then
                    run.effects[slot] = New(Effect, run, slot, h, l, command, scrolls, random)
                    break
                end
            end
        end
    end

    function M.step(run)
        if run.smoke then
            for slot=1,10 do
                local o = run.smoke[slot]
                if o then
                    local host,row = o.host,o.source
                    if run.enemies[host.slot] ~= host then
                        run.smoke[slot] = nil
                        object.RawDel(o)
                    elseif run.frame%2==1 then
                        if row[o.phase+5] then
                            o.clock = o.clock-1
                            if o.clock==0 then o.phase=o.phase+1; smokeFrame(o) end
                        end
                        local frame = o.nextImage
                        o.image,o.nextImage = frame,(frame-2)%#o.frames+1
                        o.h,o.l = program.add(host.h,host.l,row[2],row[3])
                    end
                end
            end
        end
        for slot = 1, 80 do
            local o = run.effects[slot]
            if o then
                if o.delay > 0 then
                    if not o.delaySeen then
                        o.delaySeen, o.chipLatched = true, (run.chipTime or 0) > 0
                    end
                    o.delay = o.delay - 1
                else
                    local started = o.cursor ~= 0
                    if not started then
                        nextFrame(o)
                        o.clock = o.clock + 1
                        o.h, o.l = program.add(o.h, o.l, o.startH, o.startL)
                        if score then score.fromEffect(o) end
                    end
                    if o.onFrame then o.onFrame(o) end
                    local dh, dl = 0, 0
                    if o.speed > 0 then
                        dh, dl = program.vector(o.speed, o.angle)
                        o.speed = max(8, o.speed - 1)
                    end
                    o.h = s16(o.h + dh - (o.scrolls and run.scrollStep * 64 or 0))
                    o.l = s16(o.l + dl - run.cameraStep)
                    o.clock = o.clock - 1
                    if band(o.h + 0x1000, 0xffff) >= 0x9000 or band(o.l + 0x1000, 0xffff) >= 0x5800
                        or (o.clock < 0 and not nextFrame(o)) then
                        run.effects[slot] = nil
                        object.RawDel(o)
                    end
                end
            end
        end
    end

    function M.clear(run)
        if run.smoke then
            for slot,o in pairs(run.smoke) do
                run.smoke[slot] = nil
                object.RawDel(o)
            end
        end
        for slot, o in pairs(run.effects) do
            run.effects[slot] = nil
            object.RawDel(o)
        end
    end

    return M
end
