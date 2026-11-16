-- 0x19b580。每个攻击槽保留自己的首发、重复间隔、轮次、角度和速度增量。
return function(program, bullets, scheduler)
    local bit = require('bit')
    local band = bit.band
    local s16 = program.s16
    local floor, min = math.floor, math.min
    local data = program.boss3
    local A = {}
    local function hi(n) return floor(n / 256) end
    local function lo(n) return band(n,255) end
    local function signed(n) return band(n + 128,255) - 128 end

    local function spawn(o, kind, h, l, fields)
        local run = o.run
        if #run.spawnQueue >= 40 then return end
        local row = program.actorCallbacks[kind]
        fields[1],fields[2],fields[3],fields[4] = run.major,0,kind,0
        fields[5],fields[6],fields[7] = 0,row[1],row[2]
        fields.h,fields.l = s16(h),s16(l)
        run.spawnQueue[#run.spawnQueue + 1] = fields
    end

    local function emit(o, kind, speed, angle, dh, dl, mode)
        local run = o.run
        local h,l = s16(o.h + dh),s16(o.l + dl)
        if run.loop ~= 0 and (mode == 'fan' or mode == 'sides') then
            if mode == 'fan' then bullets.emitPrecise(run,kind,speed,angle,h,l) end
            bullets.emitPrecise(run,kind,speed,angle - 8,h,l)
            bullets.emitPrecise(run,kind,speed,angle + 8,h,l)
        else
            bullets.emitPrecise(run,kind,speed + (run.loop ~= 0 and mode == 'fast' and 4 or 0),angle,h,l)
            if run.loop ~= 0 and mode == 'double' then bullets.emitPrecise(run,kind,speed + 6,angle,h,l) end
        end
    end

    local function aim(o, dh, dl)
        local pilot = o.run.player
        if not pilot or not pilot.active then return end
        return program.angle256(s16(o.h + dh),s16(o.l + dl),pilot.h,pilot.l,0x80)
    end

    local function muzzle(o, i)
        local a = o.turretAngles[i]
        local at = data.turretMuzzles[floor(a / 2) + 1]
        return program.addPacked(at[1],at[2],0x1100,i == 1 and 0x80 or -0x80)
    end

    local function finish(o,t)
        o.attacks[t.slot] = nil
    end

    local function attachClose(o)
        scheduler.attach(o.components,5)
    end

    A[0] = {function() end,function(o,t)
        if t.spawned then
            o.draws[2],o.draws[3] = false,false
            finish(o,t)
            return
        end
        local seed = program.bossRandom(o.run)
        for i = 1,2 do
            local side = i == 1 and -1 or 1
            spawn(o,0x99,o.h + 0x4c0,o.l + side * 0xa00,{
                owner=o,side=i,velocity=0x180 - side * 4,seed=seed,
            })
        end
        t.spawned = true
    end}

    A[1] = {function(o,t)
        local p = data.ring
        t.clock,t.rest,t.rounds = hi(p[1]),lo(p[1]),hi(p[2])
        t.extraGap = o.run.loop == 0 and 8 or 4
        t.angle = program.bossWideRandom(o.run)
        t.turn = program.bossWideRandom(o.run) < 0x80 and 3 or -3
        t.group = 6
    end,function(o,t)
        t.clock = t.clock - 1
        if t.clock >= 0 then return end
        t.clock = t.extraGap
        for i = 0,3 do
            local a = lo(t.angle + i * 0x40)
            local speed = s16(data.ring[4]) + ((a < 0x20 or a > 0xe0) and 8 or 0)
            emit(o,data.ring[5],speed,a,-0x1e00,0,'fast')
        end
        t.angle,t.group,t.rounds = lo(t.angle + t.turn),t.group - 1,t.rounds - 1
        if t.group == 0 then t.group,t.clock = 6,0x12 end
        if t.rounds < 0 then t.turn,t.rounds,t.clock = -t.turn,lo(data.ring[2]),t.rest end
    end}

    A[2] = {function(o,t)
        t.clock,t.gap = hi(data.spiral[1]),o.run.loop == 0 and lo(data.spiral[1]) or 3
        program.bossSmallRandom(o.run)
        local a = program.bossWideRandom(o.run)
        t.angle = {a,lo(-a)}
    end,function(o,t)
        t.clock = t.clock - 1
        if t.clock >= 0 then return end
        local weak,looped = o.health < 0x8c00,o.run.loop ~= 0
        if weak then t.gap = 3 end
        t.clock = t.gap
        local count = looped and (weak and 6 or 5) or (weak and 4 or 3)
        local spacing = looped and (weak and 0x2a or 0x33) or (weak and 0x40 or 0x55)
        for i,wing in ipairs(o.wings) do
            local h,l = muzzle(o,i)
            t.angle[i] = lo(t.angle[i] + (i == 1 and 5 or -5))
            for j = 0,count - 1 do
                local a = lo(t.angle[i] + j * spacing)
                local speed = (weak and -4 or -2) + ((a < 0x40 or a > 0xc0) and (looped and 16 or 8) or 0)
                emit(wing,4,speed,a,h,l,looped and 'fast')
            end
        end
    end}

    A[3] = {function(o,t)
        local p,tune = data.wingLaunch,o.tuning
        t.left,t.right = lo(hi(p[1]) + tune.wingDelay * 2),lo(hi(p[3]) + tune.wingDelay * 2)
        t.pauseLeft,t.pauseRight = lo(lo(p[1]) - tune.podGap),lo(p[3])
        t.leftCount,t.rightCount,t.frame = hi(p[2]),hi(p[4]),8
    end,function(o,t)
        local p = data.wingLaunch
        for i = 1,2 do
            local key = i == 1 and 'left' or 'right'
            local count = i == 1 and 'leftCount' or 'rightCount'
            t[key] = t[key] - 1
            if t[key] < 0 then
                t[key] = 0xc
                spawn(o,0x9a,o.h - 0x2380,o.l + (i == 1 and -0x800 or 0x800),{
                    owner=o,velocity=13 + o.tuning.podSpeed,frame=t.frame / 4,
                })
                t.frame,t[count] = (t.frame + 8) % 12,t[count] - 1
                if t[count] < 0 then
                    t[count] = lo(p[i * 2])
                    t[key] = i == 1 and t.pauseLeft or t.pauseRight
                end
            end
        end
    end}

    A[4] = {function(o,t)
        local tune,p = o.tuning,data.wing
        t.clock,t.rounds,t.gap = lo(0x80 + 8 * tune.wingDelay),lo(0x27 + tune.wingRounds),lo(hi(p[1]) - tune.wingGap)
        t.aimed,t.speeds = s16(p[2]) + tune.wingSpeed,{s16(p[4]) + tune.wingSpeed,s16(p[6]) + tune.wingSpeed,
            s16(p[8]) + tune.wingSpeed}
        t.baseA,t.baseB,t.stepA,t.stepB = 0xc0,0x80,4,4
    end,function(o,t)
        t.clock = t.clock - 1
        if t.clock >= 0 then return end
        t.clock = t.gap
        for _, l in ipairs({-0x300,0x300}) do
            local angle = aim(o,0x400,l)
            if angle then emit(o,data.wing[3],t.aimed,angle,0x400,l,'fast') end
        end
        for _, side in ipairs({1,-1}) do
            local l = side * -0x300
            for j = 0,3 do
                local first = j % 2 == 0
                emit(o,first and data.wing[5] or data.wing[7],
                    t.speeds[first and 1 or 2] - (j >= 2 and 8 or 0),
                    side * (t.baseA + 4 * j),-0x200,l,'sides')
            end
        end
        for side = 1,2 do
            for i = 0,2 do
                local a = side == 1 and t.baseB or -t.baseB + 0x20
                emit(o,data.wing[9],t.speeds[3],a - i * 0x10,-0x800,side == 1 and -0x300 or 0x300,'fan')
            end
        end
        t.baseA,t.baseB = t.baseA - t.stepA,t.baseB - t.stepB
        if t.baseA < 0x40 or t.baseA > 0xc0 then
            t.baseA,t.stepA = math.max(0x40,min(0xc0,t.baseA)),-t.stepA
        end
        if t.baseB < 0x40 or t.baseB > 0xc0 then
            t.baseB,t.stepB = math.max(0x40,min(0xc0,t.baseB)),-t.stepB
        end
        t.rounds = t.rounds - 1
        if t.rounds >= 0 then return end
        local tune = o.tuning
        if tune.wingRounds < 0x60 then tune.wingRounds = tune.wingRounds + 0x10 end
        if tune.wingGap < 4 then tune.wingGap = lo(tune.wingGap - 2) end
        tune.wingSpeed,tune.podGap = min(5,tune.wingSpeed + 1),min(10,tune.podGap + 2)
        scheduler.stop(o.attacks,3)
        finish(o,t)
    end}

    A[5] = {function(o,t)
        local p = data.sweep
        t.clock,t.burst,t.reload = 0x10,hi(p[1]),lo(p[1])
        t.gap,t.nextGap,t.spread,t.turn = hi(p[2]),lo(p[2]),hi(p[3]),signed(lo(p[3]))
        t.rounds,t.rest = hi(p[4]),hi(p[5])
        t.speed,t.outerSpeed = s16(p[6]) + o.tuning.sweepSpeed,s16(p[8]) + o.tuning.sweepSpeed
    end,function(o,t)
        t.clock = t.clock - 1
        if t.clock >= 0 then return end
        t.clock = t.gap
        if not t.angle then t.angle = -math.abs(signed(program.bossWideRandom(o.run))) end
        local p = data.sweep
        local angles = {t.spread,0,-t.spread,0x80 - t.spread,0x80,0x80 + t.spread}
        for i = 1,6 do
            local at = data.sweepMuzzles[i]
            local center = i == 2 or i == 5
            local variant = center and 'fan' or i % 3 == 0 and 'sides'
            emit(o,center and p[9] or p[7],center and t.outerSpeed or t.speed,t.angle + angles[i],at[1],at[2],variant)
        end
        t.angle,t.burst = t.angle + t.turn,t.burst - 1
        if t.burst >= 0 then return end
        t.burst,t.gap,t.clock,t.turn,t.angle = t.reload,t.nextGap,t.rest,-t.turn,nil
        t.speed,t.outerSpeed = t.speed + s16(p[10]),t.outerSpeed + s16(p[10])
        t.rounds = t.rounds - 1
        if t.rounds < 0 then
            o.tuning.sweepSpeed = min(12,o.tuning.sweepSpeed + p[11])
            attachClose(o)
            finish(o,t)
        end
    end}

    A[6] = {function(o,t)
        local p,tune = data.outer,o.tuning
        t.clocks,t.gap = {lo(0x60 - tune.wingDelay),lo(hi(p[1]) - tune.wingDelay)},lo(p[1])
        t.speed,t.alternate = s16(p[2]) + tune.outerSpeed,s16(p[4]) + tune.outerSpeed
        t.count,t.spread = p[6] + tune.outerCount,p[7] + tune.outerSpread
    end,function(o,t)
        local p = data.outer
        for i,wing in ipairs(o.wings) do
            t.clocks[i] = t.clocks[i] - 1
            if t.clocks[i] < 0 then
                t.clocks[i] = t.gap
                local h,l = muzzle(o,i)
                local sign = i == 1 and 1 or -1
                local base = o.turretAngles[i] * 4 - sign * t.spread
                for n = 0,t.count do
                    local a = base + n * sign * 4
                    if (t.count - n) % 2 == 0 then
                        emit(wing,p[3],t.speed,a,h,l,'double')
                        emit(wing,p[3],t.speed + 3,a,h,l,'double')
                    else emit(wing,p[5],t.alternate,a,h,l,'double') end
                end
            end
        end
    end}

    A[7] = {function(o,t)
        local p,tune = data.core,o.tuning
        t.clock,t.count,t.reload = lo(0x30 - tune.wingDelay),p[1],p[2]
        t.gap,t.rest,t.rounds,t.speed = hi(p[3]),lo(p[3]),hi(p[4]) + tune.coreCycles,s16(p[5]) + tune.coreSpeed
    end,function(o,t)
        t.clock = t.clock - 1
        if t.clock >= 0 then return end
        t.clock = t.gap
        local a = aim(o,-0x1e00,0)
        if a then emit(o,11,(t.reload - t.count) * 2 + t.speed,a,-0x1e00,0) end
        t.count = t.count - 1
        if t.count >= 0 then return end
        t.reload = min(12,t.reload + data.core[6])
        t.count,t.clock,t.rounds = t.reload,t.rest,t.rounds - 1
        if t.rounds < 0 then
            local tune = o.tuning
            tune.coreSpeed,tune.outerSpeed,tune.outerCount = min(6,tune.coreSpeed + 3),min(15,tune.outerSpeed + 3),min(6,tune.outerCount + 2)
            tune.outerSpread = tune.outerSpread + 4
            scheduler.stop(o.attacks,6)
            finish(o,t)
        end
    end}

    A[8] = {function(o,t)
        local p,tune = data.largeSweep,o.tuning
        t.clock,t.count,t.reload = hi(p[1]),min(14,hi(p[2]) + tune.largeCount),min(14,lo(p[2]) + tune.largeCount)
        t.gap,t.nextGap,t.growth,t.turn = hi(p[3]),lo(p[3]),hi(p[4]),signed(lo(p[4]))
        t.cycles,t.rest = hi(p[5]) + tune.largeCycles,hi(p[6])
        t.speed,t.outerSpeed = s16(p[7]) + tune.largeSpeed,s16(p[9]) + tune.largeSpeed
    end,function(o,t)
        t.clock = t.clock - 1
        if t.clock >= 0 then return end
        t.clock = t.gap
        if not t.angle then t.angle = aim(o,-0xac0,0) end
        if t.angle then
            local run = o.run
            local spread = run.loop == 0 and 8 or 10
            local at = t.turn < 0 and 1 or 7
            local angles = {0x14,0,-0x14}
            local p = data.largeSweep
            for i = 1,3 do
                local off = data.sweepMuzzles[at + i - 1]
                local a = t.angle + angles[i]
                if i == 2 then emit(o,p[10],t.outerSpeed,a,off[1],off[2],'fan')
                else
                    emit(o,p[8],t.speed,a,off[1],off[2])
                    local speed = run.loop == 0 and 2 or 1
                    if i == 3 or run.loop ~= 0 then emit(o,5,speed,a + spread,off[1],off[2]) end
                    if i == 1 or run.loop ~= 0 then emit(o,5,speed,a - spread,off[1],off[2]) end
                end
            end
            t.angle = t.angle + t.turn
        end
        t.count = t.count - 1
        if t.count >= 0 then return end
        local p = data.largeSweep
        t.reload = min(14,t.reload + t.growth)
        t.count,t.gap,t.clock,t.turn,t.angle = t.reload,t.nextGap,t.rest,-t.turn,nil
        t.speed,t.outerSpeed = t.speed + s16(p[11]),t.outerSpeed + s16(p[11])
        t.cycles = t.cycles - 1
        if t.cycles < 0 then
            local tune = o.tuning
            tune.largeCount,tune.largeCycles,tune.largeSpeed = min(14,tune.largeCount + t.growth),min(4,tune.largeCycles + 1),
                min(12,tune.largeSpeed + p[12])
            attachClose(o)
            finish(o,t)
        end
    end}

    for index = 4,8 do
        local init,update = unpack(A[index])
        A[index][1] = function(o,t) init(o,t); update(o,t) end
    end
    return A
end
