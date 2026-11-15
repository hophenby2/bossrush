-- 0x193ab6 的攻击槽。每个槽持有自己的计时、瞄准和炮口状态。
return function(program, bullets, turn)
    local bit = require('bit')
    local band = bit.band
    local min, max, floor = math.min, math.max, math.floor
    local data = program.boss1
    local attacks = {}
    local guns = {{0x9c0,0x400},{0x9bf,-0x3c0},{0xf40,0x600},{0xf3f,-0x640}}
    local fore = {{-0xa80,-0x240},{-0xa80,0x240},{-0x480,-0x380},{-0x480,0x380}}
    local low = {{-0x14c0,0x400},{-0x1740,0x400},{-0x14c0,-0x400},{-0x1740,-0x400}}

    local function finish(o, task)
        o.attacks[task.slot] = nil
    end

    local function timed(task, key, gap)
        task[key] = task[key] - 1
        if task[key] >= 0 then return false end
        task[key] = gap
        return true
    end

    local function aim(o, h, l, fallback, precise)
        local p = o.run.player
        if not p or not p.active then return fallback end
        local angle = precise and program.angle256 or program.angle
        return angle(h, l, p.h, p.l, fallback)
    end

    local function muzzle(o, offset)
        return program.addPacked(o.h, o.l, offset[1], offset[2])
    end

    local function wingMuzzle(o, side)
        local wing = o.wings[side]
        return program.addPacked(wing.h, wing.l, side == 1 and -0x940 or -0x941, side == 1 and 0x140 or -0x140)
    end

    local function tailMuzzle(o)
        return muzzle(o.tail, data.tailMuzzles[o.tail.pitch + 8])
    end

    local function precise(o, kind, speed, angle, h, l, second)
        if o.run.loop == 0 or second == nil then
            bullets.emitPrecise(o.run, kind, speed, angle, h, l)
            return
        end
        if second == 3 then bullets.emitPrecise(o.run, kind, speed, angle, h, l) end
        bullets.emitPrecise(o.run, kind, speed, angle - 8, h, l)
        bullets.emitPrecise(o.run, kind, speed, angle + 8, h, l)
    end

    -- 0x193b52。固定一轮的瞄准，内侧两枪在每组后加大偏转。
    attacks[0] = {
        function(o, task)
            task.clock, task.speed, task.spread, task.count = 0x10, 0, 8, 7
            task.angle = aim(o,o.h,o.l,0x80,true) + program.bossRandom(o.run)
        end,
        function(o, task)
            if not timed(task,'clock',1) then return end
            local deltas = {2,-2,task.spread,-task.spread}
            for i, offset in ipairs(fore) do
                local h, l = muzzle(o, offset)
                precise(o,3,task.speed,task.angle + deltas[i],h,l,2)
            end
            task.speed, task.spread, task.count = task.speed + 4, task.spread + 7, task.count - 1
            if task.count == 0 then finish(o,task) end
        end,
    }

    -- 0x193cde。四门炮先各自转向，确认全部到位后的下一帧才开始扫射。
    attacks[1] = {
        function(o, task)
            task.modifier = task.modifier - 4
            task.target, task.reverse = {}, {}
            for i = 1, 4 do task.target[i] = band(0x20 + program.bossRandom(o.run),0x3f) end
        end,
        function(o, task)
            if not task.aimed then
                local done = true
                for i, target in ipairs(task.target) do
                    o.guns[i] = turn(o.guns[i], target)
                    done = done and o.guns[i] == target
                end
                task.aimed = done
                return
            end
            if o.run.enemyShotGrace > 0 then return end
            for i, angle in ipairs(o.guns) do
                local change = task.reverse[i] and -1 or 1
                o.guns[i] = angle + change
                if o.guns[i] == 0x10 or o.guns[i] == 0x30 then task.reverse[i] = not task.reverse[i] end
            end
            if not timed(task,'clock',task.gap) then return end
            for i, offset in ipairs(guns) do
                local h, l = muzzle(o, offset)
                local a = o.guns[i] * 4
                if o.run.loop == 0 then
                    bullets.emit(o.run,12,task.modifier,o.guns[i],h,l)
                else
                    precise(o,12,task.modifier + 2,a,h,l)
                    precise(o,12,task.modifier,a - 8,h,l)
                    precise(o,12,task.modifier,a + 8,h,l)
                end
            end
            task.count = task.count - 1
            if task.count == 0 then finish(o,task) end
        end,
    }

    local function tailShot(o, task)
        if not timed(task,'clock',0) then return end
        local h, l = tailMuzzle(o)
        local a = band(o.tail.pitch + 0x20 + program.bossSmallRandom(o.run) - 1, 0x3f)
        -- 0x17ff4a 接收的是 256 档。原代码在这里直接传入 0～63。
        precise(o,7,task.modifier + 0x14,a,h,l)
        task.modifier, task.count = task.modifier + task.step, task.count - 1
        if task.count == 0 then finish(o,task) end
    end

    attacks[2] = {
        function(_, task)
            task.mode, task.track, task.clock, task.modifier, task.step, task.count = 0, 1, 4, -4, 2, 0x10
        end,
        function(o, task)
            if task.mode == 0 then
                task.mode = 1
                task.target = min(0x27, max(0x19, aim(o,o.tail.h,o.tail.l,0x20,false)))
            end
            if task.mode == 1 and timed(task,'track',1) then
                o.tail.pitch = turn(o.tail.pitch + 0x20,task.target) - 0x20
                if o.tail.pitch == task.target - 0x20 then task.mode = 2 end
            end
            if task.mode == 2 then tailShot(o,task) end
        end,
    }

    local function wingSpread(side)
        local function step(o, task)
            if o.wings[side].broken then finish(o,task); return end
            if not timed(task,'clock',task.gap) then return end
            if task.mode ~= 0 then
                local n, spread = o.run.loop == 0 and 1 or 3, o.run.loop == 0 and 0x14 or 0xa
                local speed = task.modifier + (o.run.loop == 0 and 0 or 4)
                for i = -n, n do precise(o,7,speed,task.angle + i * spread,task.h,task.l) end
            end
            task.modifier, task.count = task.modifier + 4, task.count - 1
            if task.count == 0 then finish(o,task) end
        end
        return {
            function(o, task)
                task.clock, task.gap = 0, task.gap or 4
                program.bossSmallRandom(o.run)
                task.h, task.l = wingMuzzle(o,side)
                task.angle = aim(o,task.h,task.l,0x80,true)
                step(o,task)
            end,
            step,
        }
    end
    attacks[3], attacks[4] = wingSpread(1), wingSpread(2)

    local function wingSpin(side)
        return {
            function(o, task)
                local loop = o.run.loop ~= 0
                task.clock, task.gap, task.tighten = side == 1 and 0x38 or 0x20, loop and 3 or 6, 4
                task.angle = (side == 1 and 0x40 or 0xc0) + program.bossRandom(o.run) * 4
                task.modifier = loop and -5 or -6
            end,
            function(o, task)
                if o.wings[side].broken then finish(o,task); return end
                if not timed(task,'clock',task.gap) then return end
                if timed(task,'tighten',4) then task.gap = max(3,task.gap - 1) end
                task.clock = task.gap
                local h, l = wingMuzzle(o,side)
                precise(o,19,task.modifier,task.angle,h,l,2)
                precise(o,19,task.modifier,task.angle + 0x80,h,l,2)
                if o.run.loop ~= 0 then
                    precise(o,19,task.modifier,task.angle + 0x40,h,l)
                    precise(o,19,task.modifier,task.angle + 0xc0,h,l)
                end
                task.angle = task.angle + (side == 1 and 0xb or -0xb)
            end,
        }
    end
    attacks[5], attacks[6] = wingSpin(1), wingSpin(2)

    attacks[7] = {
        function(_, task) task.clock, task.modifier, task.step, task.count = 8, -8, 1, 6 end,
        tailShot,
    }

    local function queueWingShot(o, side, count, modifier, angle, speed)
        local queue = o.run.spawnQueue
        if #queue >= 40 then return end
        local cb = program.actorCallbacks[0x1e]
        local h, l = wingMuzzle(o,side)
        queue[#queue + 1] = {o.run.major,0,0x1e,0,0,cb[1],cb[2],
            h=h,l=l, count=count, modifier=modifier, angle=angle, speed=speed}
    end

    -- 0x194602 生成自己的炮弹发射机。炮翼掉落也不会中断已经下达的生成项。
    attacks[8] = {
        function(o, task)
            task.clock, task.side, task.modifier, task.count, task.repeats = 0x18,
                band(program.bossWideRandom(o.run),1) + 1,-1,0xa,2
        end,
        function(o, task)
            if not timed(task,'clock',0) then return end
            if not o.wings[task.side].broken then
                queueWingShot(o,task.side,task.count,task.modifier,0x20,0x20)
                if o.run.loop ~= 0 then
                    queueWingShot(o,task.side,task.count,task.modifier,task.side == 1 and 0x28 or 0x18,0x1a)
                end
            end
            task.side, task.modifier, task.repeats = 3 - task.side, task.modifier + 1, task.repeats - 1
            if task.repeats == 0 then finish(o,task) end
        end,
    }

    local function noseFan(aimed)
        return {
            function(_, task) task.clock, task.count, task.gap = 4, 8, 9 end,
            function(o, task)
                if not timed(task,'clock',task.gap) then return end
                local angles = {0x90,0x70,0xa0,0x60}
                for _, i in ipairs({4,2,3,1}) do
                    local h, l = muzzle(o,fore[i])
                    local a = aimed and aim(o,o.h,o.l,0x20,true) or angles[i]
                    precise(o,9,aimed and 2 or 8,a,h,l,3)
                end
                task.count = task.count - 1
                if task.count == 0 then finish(o,task) end
            end,
        }
    end
    attacks[9], attacks[10] = noseFan(false), noseFan(true)

    local function lowerFan(wide)
        return {
            function(_, task)
                task.clock, task.count = wide and 0x10 or 8, wide and 2 or 4
            end,
            function(o, task)
                if not timed(task,'clock',wide and 0x10 or 8) then return end
                if wide then
                    for i = 1, 3, 2 do
                        local h, l = muzzle(o,low[i])
                        for _, a in ipairs({0x80,0x8c,0x98,0x74,0x68}) do precise(o,19,0,a,h,l,2) end
                    end
                else
                    for _, offset in ipairs(low) do
                        local h, l = muzzle(o,offset)
                        precise(o,19,8,0x80,h,l)
                    end
                end
                task.count = task.count - 1
                if task.count == 0 then finish(o,task) end
            end,
        }
    end
    attacks[11], attacks[12] = lowerFan(false), lowerFan(true)

    attacks[13] = {
        function(o, task)
            task.angle = aim(o,o.tail.h,o.tail.l,band((o.tail.pitch + 0x20) * 4,0xff),true)
        end,
        function(o, task)
            if o.run.enemyShotGrace > 0 then finish(o,task); return end
            local h, l = tailMuzzle(o)
            local a = program.bossWideRandom(o.run)
            for _ = 1, 16 do
                for q = 0, 4, 4 do
                    local angle = a + q
                    local offset = program.shipFan[5][band(angle + 2,0xfc) / 4 + 1]
                    local h, l = program.addPacked(h,l,offset[1],offset[2])
                    precise(o,11,-7,angle,h,l,3)
                end
                a = a + 0x10
            end
            for _ = 1, task.delta do
                for _, k in ipairs({0,3,-3}) do
                    if k == 3 then task.modifier = task.modifier + 2 end
                    local shift = floor(program.bossJitter(o.run) / 8)
                    precise(o,7,task.modifier - 0x14 - (k == 0 and 0 or k > 0 and 1 or 2),
                        task.angle + k,h,program.s16(l + shift))
                end
            end
            finish(o,task)
        end,
    }

    attacks[14] = {
        function(_, task) task.wait, task.reload, task.count, task.clock = 0x90, 0x50, 0, 0xc end,
        function(o, task)
            if task.count == 0 then
                if not timed(task,'wait',task.reload) then return end
                task.reload = max(0x10,task.reload - 4)
                task.wait, task.count = task.reload, 1
            end
            if not timed(task,'clock',0) then return end
            for side, wing in ipairs(o.wings) do
                local p = o.run.player
                if not wing.broken and p and p.active then
                    local h, l = wingMuzzle(o,side)
                    local angle = aim(o,h,l,0x80,true)
                    local n, gap = o.run.loop == 0 and 1 or 3, o.run.loop == 0 and 2 or 4
                    for i = -n,n do
                        precise(o,o.run.loop == 0 and 4 or 3,o.run.loop == 0 and -2 or 0,angle + i * gap,h,l)
                    end
                end
            end
            task.count = task.count - 1
        end,
    }

    return attacks
end
