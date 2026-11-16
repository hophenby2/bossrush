-- 0x1a559e 的攻击槽。每个表项保留原程序的挂载与逐帧入口。
return function(program, bullets)
    local band = require('bit').band
    local s16, packed = program.s16, program.addPacked
    local floor, min = math.floor, math.min
    local data = program.boss5
    local A = {}

    local function emit(o,kind,speed,angle,h,l,settings)
        return bullets.emitPrecise(o.run,kind,speed,angle,s16(o.h + h),s16(o.l + l),settings)
    end

    local function aim(o,h,l)
        local p = o.run.player
        if p and p.active then return program.angle256(s16(o.h + h),s16(o.l + l),p.h,p.l,0x80) end
    end

    local function muzzle(o,index)
        local anchor = data.turretAnchors[index]
        local offset = data.turretMuzzles[o.boxes[index + 1].angle + 1]
        return packed(anchor[1],anchor[2],offset[1],offset[2])
    end

    local function ring(o,kind,speed,angle,h,l,settings,offsets)
        local m = (offsets or data.ringMuzzles)[band(angle + 2,0xfc) / 4 + 1]
        h,l = packed(h,l,m[1],m[2])
        emit(o,kind,speed,angle,h,l,settings)
    end

    local function hold(o,enabled)
        for i=2,7 do o.boxes[i].held = enabled end
    end

    local function stop(o,t)
        o.attacks[t.slot] = nil
    end

    local function wait(t,period)
        t.clock = t.clock - 1
        if t.clock >= 0 then return false end
        t.clock = period
        return true
    end

    local function jitter(o,t)
        for i=1,6 do t.jitter[i] = program.bossRandom(o.run) end
    end

    local function resetOnMiss(init,update)
        return {init,function(o,t)
            if o.run.enemyShotGrace > 0 then init(o,t); return end
            update(o,t)
        end}
    end

    local arrowAngles = {{0,0x18,-0x18},{0xc,-0xc},{0},{0,0x18,-0x18},{0xc,-0xc},{0}}
    -- 0x1a5660 / 0x1a56d6。扩展扇在每组的最后一轮炮口射击之后登记。
    A[0] = resetOnMiss(function(o,t)
        t.clock,t.count,t.cycles,t.speed,t.jitter = 0x20,3,4 + o.arrowCycles,-7 + o.arrowRank,{}
        jitter(o,t)
    end,function(o,t)
        if not wait(t,5 - o.arrowGap) then return end
        hold(o,true)
        for i,offsets in ipairs(arrowAngles) do
            local h,l = muzzle(o,i)
            local a = o.boxes[i + 1].angle * 4 + t.jitter[i]
            for _, offset in ipairs(offsets) do emit(o,7,t.speed,a + offset,h,l) end
        end
        if t.count == 0 then
            for _,row in ipairs(data.loop2Fans) do
                for k=0,8 do ring(o,row[2],row[1] + o.fanRank,row[3] - 0x20 + k * 8,row[4],row[5]) end
            end
        end
        t.count = t.count - 1
        if t.count >= 0 then return end
        t.count,t.speed,t.clock = 3,min(0x10,t.speed + 1),0x40 - o.arrowRest
        jitter(o,t)
        hold(o,false)
        t.cycles = t.cycles - 1
        if t.cycles >= 0 then return end
        o.arrowCycles,o.arrowGap,o.arrowRest = min(6,o.arrowCycles + 2),min(3,o.arrowGap + 1),min(0x20,o.arrowRest + 8)
        o.arrowRank,o.fanRank = min(0x10,o.arrowRank + 1),min(4,o.fanRank + 1)
        stop(o,t)
    end)

    -- 0x17ff96 在二周目把同一路拆成角度相差 16 的两发。
    A[1] = resetOnMiss(function(o,t)
        t.clock,t.count,t.first,t.left,t.right = 0x20,0x8b + o.sweepLength,0x8b + o.sweepLength,0,0
        t.leftStep,t.rightStep = 5,-5
        if program.bossWideRandom(o.run) >= 0x80 then
            t.leftStep = -5 + program.dropSpeedRandom(o.run)
            t.rightStep = 5 + program.dropSpeedRandom(o.run)
        end
        hold(o,true)
    end,function(o,t)
        if not wait(t,3) then return end
        local odd = band(t.count,1) == 1
        local a = odd and aim(o,-0xf40,0)
        if not odd or a then
            if odd then
                a = a + floor(program.bossRandom(o.run) / 2)
                emit(o,0x13,-7 + o.sweepAimRank,a,-0xf40,0)
                if t.count == t.first then t.left,t.right = a + 0x40,-(a + 0xc0) end
            end
            for i=1,2 do
                local l = i == 1 and -0x400 or 0x400
                local angle = i == 1 and t.left or t.right
                for _,shift in ipairs({-8,8}) do emit(o,4,2 + o.sweepRank,angle + shift,-0xd40,l) end
                for _,shift in ipairs({-8,8}) do emit(o,5,-3 + o.sweepRank,angle + 0x20 + shift,-0xd40,l) end
                emit(o,6,-11 + o.sweepRank,angle + 0x80,-0xd40,l)
                if odd then emit(o,3,1,angle + (i == 1 and 0xa0 or 0x80),-0xd40,l) end
            end
            t.left,t.right = t.left + t.leftStep,t.right + t.rightStep
        end
        t.count = t.count - 1
        if t.count >= 0 then return end
        o.sweepLength,o.sweepAimRank,o.sweepRank = min(0x3c,o.sweepLength + 0x14),min(4,o.sweepAimRank + 1),min(0x1a,o.sweepRank + 1)
        hold(o,false)
        stop(o,t)
    end)

    local turretAngles = {{0x70,0xc0},{0x7c,0xb8},{0x98,0xb0},{0x90,0x40},{0x84,0x48},{0x68,0x50}}
    A[2] = resetOnMiss(function(o,t)
        t.clock,t.count,t.cycles,t.step,t.jitter = 0x20,11,0x11 + o.reverseRank,o.reverseTurrets and 1 or -1,{}
        jitter(o,t)
    end,function(o,t)
        if not wait(t,2) then return end
        hold(o,true)
        local targeted = band(t.count,1) == 1
        local a = targeted and aim(o,-0xf40,0)
        if a then
            local p = o.run.player
            if p.h >= o.h - 0xa00 then
                a = a + floor(program.bossRandom(o.run) / 2)
                for _, d in ipairs({16,20,24}) do emit(o,0x16,-8 + o.reverseSpeed + d,a,-0xf40,0) end
            else emit(o,0x16,-8 + o.reverseSpeed,a,-0xf40,0) end
        end
        for i,row in ipairs(turretAngles) do
            local box = o.boxes[i + 1]
            if not targeted or a then
                local h,l = muzzle(o,i)
                emit(o,0x13,3,row[1] + t.jitter[i],h,l)
                emit(o,0x13,15,row[2] + t.jitter[i],h,l)
            end
            box.angle = band(box.angle + t.step * (i % 2 == 0 and -1 or 1),63)
        end
        t.count = t.count - 1
        if t.count >= 0 then return end
        t.clock,t.count,t.cycles = 8,11 + floor(program.bossRandom(o.run) / 2),t.cycles - 1
        if t.cycles >= 0 then return end
        o.reverseTurrets = not o.reverseTurrets
        o.reverseRank,o.reverseSpeed = min(4,o.reverseRank + 1),min(4,o.reverseSpeed + 1)
        hold(o,false)
        stop(o,t)
    end)

    A[3] = resetOnMiss(function(o,t)
        t.clock,t.count,t.first,t.cycles,t.muzzle = 0x20,0x1d,0x1d,3 + o.gunRank,5
        t.speed,t.baseSpeed = -2 + o.gunSpeed,-2 + o.gunSpeed
    end,function(o,t)
        if not wait(t,0) then return end
        if t.count == t.first then t.spread = program.dropSpeedRandom(o.run) end
        local left,right = aim(o,0x940,-0xd00),aim(o,0x940,0xd00)
        if left then
            for i,a in ipairs({left,right}) do
                local row = data.hullMuzzles[(t.muzzle - 1) * 2 + i]
                a = a + floor(row[3] / 2 ^ t.spread)
                emit(o,11,t.speed,a,row[1],row[2])
                emit(o,11,t.speed + 6,a,row[1],row[2])
            end
            t.muzzle = (t.muzzle - 2) % 5 + 1
        end
        t.speed,t.count = t.speed + 1,t.count - 1
        if t.count >= 0 then return end
        if t.first < 0x1e then t.first = t.first + 0xf end
        t.clock,t.baseSpeed = 0x1d - o.gunGap,t.baseSpeed + 1
        t.count,t.speed,t.cycles = t.first,t.baseSpeed,t.cycles - 1
        if t.cycles >= 0 then return end
        o.gunRank,o.gunSpeed,o.gunGap = min(2,o.gunRank + 1),min(6,o.gunSpeed + 1),min(0x18,o.gunGap + 2)
        stop(o,t)
    end)

    A[4] = resetOnMiss(function(o,t)
        t.clock,t.count,t.limit,t.cycles,t.delay,t.speed,t.step,t.angle = 0x20,0x63,0x63,1,0xb,-8,1,0x40
    end,function(o,t)
        local low = o.health < 0x15000
        if not wait(t,t.delay - (low and 4 or 0)) then return end
        for i=0,1 do
            for j=0,3 do ring(o,0x19,t.speed,t.angle + i * 0x80 + j * 0x10,-0xf40,0) end
        end
        t.angle,t.count = t.angle + t.step * (low and 4 or 1),t.count - 1
        if t.count >= 0 then return end
        t.clock,t.step,t.speed,t.cycles = 0x40,-t.step,min(8,t.speed + 2),t.cycles - 1
        if t.cycles < 0 then
            t.cycles,t.limit,t.delay = 1,min(0xc7,t.limit + 0x14),math.max(5,t.delay - 2)
        end
        t.count = t.limit
    end)

    local function waveRanks(o)
        local ranks = o.loop2Ranks
        return ranks
    end

    A[5] = resetOnMiss(function(o,t)
        local r = waveRanks(o)
        t.clock,t.count,t.angle = 0x20,0x27 + r[1],program.randomEnemy(o.run) + 0x60
        t.step = program.bossWideRandom(o.run) < 0x80 and 6 or -6
    end,function(o,t)
        if not wait(t,6) then return end
        local r = waveRanks(o)
        if band(t.count,1) == 1 then
            local a = aim(o,-0xf40,0)
            if a then for i=0,6 do ring(o,0xb,r[2],a - 0x36 + i * 0x12,-0xf40,0) end end
        end
        if band(t.count,1) == 0 or o.run.player and o.run.player.active then
            for i=0,12 do ring(o,4,6 + r[3],t.angle - 0x3c + i * 0xa,-0xf40,0) end
            t.angle = band(t.angle + t.step,255)
            if t.angle < 0x50 or t.angle > 0xb0 then t.step = -t.step end
        end
        t.count = t.count - 1
        if t.count >= 0 then return end
        r[1],r[2],r[3] = min(0x28,r[1] + 0xa),min(4,r[2] + 1),min(0x1a,r[3] + 1)
        stop(o,t)
    end)

    A[6] = resetOnMiss(function(o,t)
        t.clock,t.count,t.muzzle = 0x20,0x3b + waveRanks(o)[4],6
    end,function(o,t)
        if not wait(t,3) then return end
        local r = waveRanks(o)
        local a = aim(o,0,0)
        if a then
            a = a + program.randomEnemy(o.run) - 0x20
            local h,l = unpack(data.loop2CenterMuzzles[t.muzzle])
            for _,row in ipairs({{0,-1,1},{4,0,-2,2},{4,-1,1},{4,0,-2,2}}) do
                for i=2,#row do emit(o,0x13,row[1],a + row[i],h,l) end
            end
            t.muzzle = (t.muzzle - 2) % 6 + 1
        end
        t.count = t.count - 1
        if t.count >= 0 then return end
        r[4],r[5] = min(0x14,r[4] + 0xa),min(6,r[5] + 1)
        stop(o,t)
    end)

    A[7] = resetOnMiss(function(o,t)
        t.clock,t.count,t.limit,t.cycles,t.muzzle = 0x60,0x1d,0x1d,2,5
        t.speed,t.add = 5 + waveRanks(o)[7],2
    end,function(o,t)
        if not wait(t,2) then return end
        local a = aim(o,0,0)
        if a then
            for _,row in ipairs(data.loop2CrossMuzzles[t.cycles + 1][t.muzzle]) do
                local h,l,speed,d = unpack(row)
                emit(o,3,t.speed + speed,a + d,h,l)
                local half = floor(d / 2)
                emit(o,4,t.speed + speed + t.add,a - half - floor(half / 4),h,l)
            end
            t.muzzle = (t.muzzle - 2) % 5 + 1
        end
        t.count = t.count - 1
        if t.count >= 0 then return end
        if t.limit < 0x3b then t.limit = t.limit + 0xf end
        t.count,t.speed,t.add,t.cycles = t.limit,t.speed + 2,t.add + 1,t.cycles - 1
        t.clock = band(2 - waveRanks(o)[6],255)
        if t.cycles >= 0 then return end
        local r = waveRanks(o)
        r[6],r[7] = min(0x10,r[6] + 8),math.min(0xc,r[7] + 2)
        stop(o,t)
    end)

    local function s8(n)
        return band(n + 0x80,255) - 0x80
    end

    A[8] = resetOnMiss(function(o,t)
        t.clock,t.count,t.angle = 0x60,0x4f + waveRanks(o)[8],s8(program.randomEnemy(o.run) - 0x20)
        t.step = program.bossWideRandom(o.run) < 0x80 and 3 or -3
    end,function(o,t)
        if not wait(t,5) then return end
        local p = o.run.player
        local a = aim(o,-0x2800,0)
        if a then
            if p.h >= s16(o.h - 0x2800) then
                a = a + floor(program.bossRandom(o.run) / 2)
                emit(o,0x13,8,a,-0x2800,0)
                emit(o,0x13,12,a - 2,-0x2800,0)
                emit(o,0x13,16,a + 2,-0x2800,0)
            end
            for i=0,6 do
                local angle = t.angle - 0x2d + i * 0xf
                local m = data.ringMuzzles[band(angle + 2,0xfc) / 4 + 1]
                local h,l = packed(-0x2800,0,m[1],m[2])
                emit(o,0x17,10 - i * 2,angle,h,l,{motionFrom=2,motionPeriod=2,motionDelta=0x20,motionDuration=0x42})
                emit(o,0x18,8 - i * 2,angle + 0x80,h,l,{motionFrom=0x2c,motionPeriod=3,motionDelta=-0x20,motionDuration=0x2e})
            end
            t.angle = s8(t.angle + t.step)
            if t.step > 0 and t.angle > 0x30 or t.step < 0 and t.angle < -0x30 then t.step = -t.step end
        end
        t.count = t.count - 1
        if t.count >= 0 then return end
        A[8][1](o,t)
        local r = waveRanks(o)
        r[8] = min(0x28,r[8] + 0x14)
        stop(o,t)
    end)

    A[9] = {
        function(o,t)
            t.clock,t.count,t.spread = 0x10,0x45 + waveRanks(o)[9],0x20
            t.step = program.bossWideRandom(o.run) < 0x80 and 1 or -1
        end,
        function(o,t)
            if not wait(t,3) then return end
            local r = waveRanks(o)
            local a = aim(o,0,0)
            if a then
                a = a + (band(t.count,1) == 1 and t.spread or -t.spread) - 0x23
                for i=0,15 do emit(o,7,9 + r[10],a + 5 * i,-0x600,0) end
                t.spread = s8(t.spread + t.step)
                if t.step > 0 and t.spread > 0x10 or t.step < 0 and t.spread < -0x10 then t.step = -t.step end
            end
            t.count = t.count - 1
            if t.count >= 0 then return end
            if r[9] < 0x1e then r[9] = r[9] + 0x14 end
            r[10] = min(2,r[10] + 1)
            stop(o,t)
        end,
    }

    -- 0x181a1a 在弹体自己的计时耗尽后再从当前弹位分配子弹。
    A[10] = {
        function(o,t)
            local r = waveRanks(o)
            t.clock,t.count,t.angle = 0x10,band(0x77 + r[11],255),program.bossWideRandom(o.run)
            t.step = r[14] == 0 and -2 or 2
        end,
        function(o,t)
            local r = waveRanks(o)
            local p = o.run.player
            o.run.boss5ChildrenAim = p and p.active and program.pilotDistance(o,p) < 0x2000
            if not wait(t,5) then return end
            local spawn = {childKind=0,childSpeed=0x16 + r[13]}
            for i=0,11 do ring(o,0x1c,6 + r[12],t.angle + i * 0x15,-0x600,0,spawn) end
            t.angle,t.count = band(t.angle + t.step,255),t.count - 1
            if t.count >= 0 then return end
            r[11],r[12],r[13],r[14] = min(0x96,r[11] + 0xa),min(2,r[12] + 1),min(3,r[13] + 1),1 - r[14]
            stop(o,t)
        end,
    }

    local waveKinds = {3,4,5,6,5,4,3,4,5}
    A[11] = {
        function(o,t) t.clock,t.count,t.pulse,t.angle = 0x10,0xb3,4,0x80 end,
        function(o,t)
            if o.run.enemyShotGrace > 0 then stop(o,t); return end
            if not wait(t,1) then return end
            if t.count ~= 0xb3 or aim(o,-0x600,0) then
                local a = t.angle + 0xb7 - t.count
                local b = t.angle - 0xb7 + t.count
                for i,kind in ipairs(waveKinds) do emit(o,kind,0x13 + 3 * (i - 1),a - (i - 1) * 0x16,-0x600,0) end
                for i,kind in ipairs(waveKinds) do emit(o,kind,0x13 + 3 * (i - 1),b + (i - 1) * 0x16,-0x600,0) end
            end
            t.pulse,t.count = t.pulse - 1,t.count - 1
            if t.pulse == 0 then t.pulse,t.clock = 4,4 end
            if t.count < 0 then stop(o,t) end
        end,
    }

    -- V101 在 0x1a71f2 先清除自己的槽。初始等待尚未耗尽，第一轮便退出。
    A[12] = {
        function(o,t)
            program.randomEnemy(o.run)
            program.bossWideRandom(o.run)
            program.randomEnemy(o.run)
        end,
        stop,
    }

    local function four(o,kind,speed,angle,offsets)
        for i=0,3 do ring(o,kind,speed,angle + i * 0x40,-0x200,0,nil,offsets) end
    end

    -- 0x1a736e。三组炮口各有独立的时钟和转角，后两组还受耐久阈值控制。
    A[13] = {
        function(o,t)
        t.clock,t.ringClock,t.reverseClock,t.slowClock = 1,0x40,0x30,8
        t.secondaryWait,t.curlWait,t.curlClock = 0x100,0x100,0x20
            t.base,t.curl,t.secondary = program.bossWideRandom(o.run),program.bossWideRandom(o.run),program.bossWideRandom(o.run)
            t.turn,t.speed,t.reverse = -6,5,false
        end,
        function(o,t)
            if wait(t,4) then
                four(o,0xb,0xa,t.base,data.loop2FinalMuzzles[1])
                t.base = band(t.base - 2,255)
            end
            local secondaryReady = t.secondaryWait == 0
            if not secondaryReady then
                t.secondaryWait = t.secondaryWait - 1
                secondaryReady = o.health < 0x1f800
            end
            if secondaryReady then
                t.ringClock = t.ringClock - 1
                if t.ringClock < 0 then
                    t.ringClock = 4
                    four(o,0xb,5,t.secondary,data.loop2FinalMuzzles[3])
                    t.secondary = band(t.secondary + 3,255)
                end
                if t.curlWait > 0 then
                    t.curlWait = t.curlWait - 1
                    if o.health >= 0x1c000 then return end
                end
                t.curlClock = t.curlClock - 1
                if t.curlClock < 0 then
                    t.curlClock = 3
                    local settings = {turnPeriod=1,turnAmount=t.speed,accelPeriod=1,accelAmount=1}
                    for i=0,9 do ring(o,0x1b,-6,t.curl + i * 0x19,-0x200,0,settings,data.loop2FinalMuzzles[2]) end
                    t.curl = band(t.curl + t.turn,255)
                end
            end
            t.slowClock = t.slowClock - 1
            if t.slowClock >= 0 then return end
            t.slowClock = 8
            local edge = t.reverse and 6 or -6
            if t.turn ~= edge then t.turn = t.turn + (t.reverse and 1 or -1); return end
            local speed = t.reverse and -5 or 5
            if t.speed ~= speed then t.speed = t.speed + (t.reverse and -1 or 1); return end
            t.reverseClock = t.reverseClock - 1
            if t.reverseClock < 0 then t.reverseClock,t.reverse = 0x30,not t.reverse end
        end,
    }

    return A
end
