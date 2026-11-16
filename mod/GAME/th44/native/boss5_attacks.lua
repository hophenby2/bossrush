-- 一周目关底攻击表 0x1a7556。炮口和弹体分别使用原版定点方向。
return function(program,bullets)
    local band = require('bit').band
    local s16,packed = program.s16,program.addPacked
    local min,floor = math.min,math.floor
    local data = program.boss5
    local A = {}

    local function emit(o,kind,speed,angle,h,l)
        bullets.emitPrecise(o.run,kind,speed,angle,s16(o.h + h),s16(o.l + l))
    end

    local function aim(o,h,l)
        local pilot = o.run.player
        if not pilot or not pilot.active then return end
        return program.angle256(s16(o.h + h),s16(o.l + l),pilot.h,pilot.l,0x80)
    end

    local function muzzle(o,index)
        local offset = data.turretAnchors[index]
        local tip = data.turretMuzzles[o.boxes[index + 1].angle + 1]
        return packed(offset[1],offset[2],tip[1],tip[2])
    end

    local function jitter(o,t)
        for i = 1,6 do t.jitter[i] = program.bossRandom(o.run) end
    end

    local function hold(o,value)
        for i = 2,7 do o.boxes[i].held = value end
    end

    local function stop(o,t) o.attacks[t.slot] = nil end

    local function wait(t,reset)
        t.clock = t.clock - 1
        if t.clock >= 0 then return false end
        t.clock = reset
        return true
    end

    local function rings(o,kind,speed,angle,h,l)
        local m = data.ringMuzzles[band(angle + 2,0xfc) / 4 + 1]
        h,l = packed(h,l,m[1],m[2])
        emit(o,kind,speed,angle,h,l)
    end

    A[0] = {
        function(o,t)
            t.clock,t.count,t.cycles,t.speed,t.jitter = 0x20,2,6 + o.arrowCycles,-5 + o.arrowRank,{}
            jitter(o,t)
        end,
        function(o,t)
            if not wait(t,4 - o.arrowGap) then return end
            hold(o,true)
            for i = 1,6 do
                local angle = o.boxes[i + 1].angle * 4 + t.jitter[i]
                local h,l = muzzle(o,i)
                emit(o,7,t.speed,angle,h,l)
                if i == 1 or i == 4 then
                    emit(o,7,t.speed,angle + 0x18,h,l)
                    emit(o,7,t.speed,angle - 0x18,h,l)
                end
            end
            if t.count == 0 then
                for _, row in ipairs(data.extraFans) do
                    for k = 0,6 do rings(o,row[2],row[1] + o.fanRank,row[3] - 0x18 + 8 * k,row[4],row[5]) end
                end
            end
            t.count = t.count - 1
            if t.count >= 0 then return end
            t.count,t.speed,t.clock = 2,min(t.speed + 1,0x10),0x40 - o.arrowRest
            jitter(o,t)
            hold(o,false)
            t.cycles = t.cycles - 1
            if t.cycles >= 0 then return end
            if o.arrowCycles < 6 then o.arrowCycles = o.arrowCycles + 2 end
            if o.arrowGap < 2 then o.arrowGap = o.arrowGap + 1 end
            if o.arrowRest < 0x20 then o.arrowRest = o.arrowRest + 8 end
            if o.arrowRank < 0x10 then o.arrowRank = o.arrowRank + 1 end
            if o.fanRank < 8 then o.fanRank = o.fanRank + 2 end
            stop(o,t)
        end,
    }

    A[1] = {
        function(o,t)
            t.clock,t.count,t.gap,t.leftStep,t.rightStep = 0x70,0x8b,0x8b,6,-6
            if program.bossWideRandom(o.run) >= 0x80 then
                t.leftStep = -t.leftStep + program.dropSpeedRandom(o.run)
                t.rightStep = -t.rightStep + program.dropSpeedRandom(o.run)
            end
            t.count,t.gap = t.count + o.sweepLength,t.gap + o.sweepLength
            hold(o,true)
        end,
        function(o,t)
            if not wait(t,3) then return end
            local aimed = band(t.count,15) == 0
            local target = aimed and aim(o,-0xf40,0)
            if not aimed or target then
                local direction = band(o.l + 0x1040,255)
                if aimed then
                    local a = target + floor(program.bossRandom(o.run) / 2)
                    for i, offsets in ipairs({{-3,3},{0,-6,6},{-3,3}}) do
                        for _, d in ipairs(offsets) do emit(o,11,-6 + o.sweepAimRank + 2 * (i - 1),a + d,-0xf40,0) end
                    end
                    direction = band(a + 3,255)
                end
                if t.count == t.gap then t.left,t.right = direction + 0x40,-(direction + 0xc0) end
                for side = 1,2 do
                    local a = side == 1 and t.left or t.right
                    local l = side == 1 and -0x400 or 0x400
                    emit(o,4,-1 + o.sweepRank,a,-0xd40,l)
                    emit(o,5,-2 + o.sweepRank,a + 0x20,-0xd40,l)
                    emit(o,6,-7 + o.sweepRank,a + 0x80,-0xd40,l)
                    if band(t.count,1) ~= 0 then emit(o,3,9,a + (side == 1 and 0xa0 or 0x80),-0xd40,l) end
                end
                t.left,t.right = t.left + t.leftStep,t.right + t.rightStep
            end
            t.count = t.count - 1
            if t.count >= 0 then return end
            o.sweepLength,o.sweepAimRank,o.sweepRank = min(0x3c,o.sweepLength + 0x14),
                min(8,o.sweepAimRank + 1),min(0x1a,o.sweepRank + 1)
            hold(o,false)
            stop(o,t)
        end,
    }

    local turretAngles = {{0x70,0xc0},{0x7c,0xb8},{0x98,0xb0},{0x90,0x40},{0x84,0x48},{0x68,0x50}}
    A[2] = {
        function(o,t)
            t.clock,t.count,t.cycles = 0x20,9,0xf + o.reverseRank
            t.step,t.jitter = o.reverseTurrets and 1 or -1,{}
            jitter(o,t)
        end,
        function(o,t)
            if not wait(t,4) then return end
            hold(o,true)
            local aimed = band(t.count,2) ~= 0
            local angle = aimed and aim(o,-0xf40,0)
            if angle then
                local p = o.run.player
                if p.h >= o.h - 0xa00 then
                    angle = angle + floor(program.bossRandom(o.run) / 2)
                    for _, shift in ipairs({16,20,24}) do emit(o,5,-9 + o.reverseSpeed + shift,angle,-0xf40,0) end
                else emit(o,5,-9 + o.reverseSpeed,angle,-0xf40,0) end
            end
            for i, row in ipairs(turretAngles) do
                local p = o.boxes[i + 1]
                if not aimed or angle then
                    local h,l = muzzle(o,i)
                    emit(o,0x13,3,row[1] + t.jitter[i],h,l)
                    emit(o,0x13,0x10,row[2] + t.jitter[i],h,l)
                end
                p.angle = band(p.angle + t.step * (i % 2 == 0 and -1 or 1),63)
            end
            t.count = t.count - 1
            if t.count >= 0 then return end
            t.count,t.clock = 9 + floor(program.bossRandom(o.run) / 2),8
            jitter(o,t)
            t.cycles = t.cycles - 1
            if t.cycles >= 0 then return end
            o.reverseTurrets = not o.reverseTurrets
            o.reverseRank,o.reverseSpeed = min(4,o.reverseRank + 1),min(4,o.reverseSpeed + 1)
            hold(o,false)
            stop(o,t)
        end,
    }

    A[3] = {
        function(o,t)
            t.clock,t.count,t.limit,t.cycles = 0x20,0x1d,0x1d,3 + o.gunRank
            t.muzzle,t.speed,t.baseSpeed = 5,-1 + o.gunSpeed,-1 + o.gunSpeed
        end,
        function(o,t)
            if not wait(t,0) then return end
            if t.count == t.limit then t.spread = program.dropSpeedRandom(o.run) end
            for i = 1,2 do
                local m = data.hullMuzzles[(t.muzzle - 1) * 2 + i]
                local a = aim(o,0x940,i == 1 and -0xd00 or 0xd00)
                if a then emit(o,11,t.speed,a + floor(m[3] / 2 ^ t.spread),m[1],m[2]) end
            end
            t.muzzle,t.speed,t.count = (t.muzzle - 2) % 5 + 1,t.speed + 1,t.count - 1
            if t.count >= 0 then return end
            if t.limit < 0x1e then t.limit = t.limit + 0xf end
            t.clock,t.baseSpeed = band(0x20 - o.gunGap,255),t.baseSpeed + 1
            t.count,t.speed,t.cycles = t.limit,t.baseSpeed,t.cycles - 1
            if t.cycles >= 0 then return end
            if o.gunRank < 2 then o.gunRank = o.gunRank + 1 end
            if o.gunSpeed < 6 then o.gunSpeed = o.gunSpeed + 1 end
            if o.gunGap < 0x10 then o.gunGap = o.gunGap + 4 end
            stop(o,t)
        end,
    }

    A[4] = {
        function(o,t) t.clock,t.count,t.length,t.gap,t.speed,t.step,t.angle = 0x20,0x45,0x45,0xb,-6,1,0x40 end,
        function(o,t)
            local low = o.health < 0x15000
            if not wait(t,t.gap - (low and 2 or 0)) then return end
            for i = 0,3 do
                for j = 0,1 do rings(o,0x19,t.speed,t.angle + i * 0x40 + j * 0x10,-0xf40,0) end
            end
            t.angle,t.count = band(t.angle + t.step * (low and 2 or 1),255),t.count - 1
            if t.count >= 0 then return end
            t.clock,t.step,t.speed,t.gap = 0x40,-t.step,min(6,t.speed + 2),math.max(7,t.gap - 2)
            if t.length < 0xc7 then t.length = t.length + 0x14 end
            t.count = t.length
        end,
    }

    return A
end
