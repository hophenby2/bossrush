-- 0x19f95a 的攻击槽分别保存炮管、发射计时、速度及下一次攻击的参数。
return function(program, bullets, scheduler)
    local band = require('bit').band
    local s16 = program.s16
    local data = program.boss4
    local A = {}
    local fanOrder = {0,1,2,-1,-2}

    local function stop(o,t) o.attacks[t.slot] = nil end

    local function aim(o,p,dh,dl,default)
        local pilot = o.run.player
        if not pilot or not pilot.active then return default or 0x80 end
        return program.angle256(s16(p.h + dh),s16(p.l + dl),pilot.h,pilot.l,default or 0x80)
    end

    local function emit(o,p,kind,speed,a,dh,dl,loopMode)
        local run = o.run
        local h,l = s16(p.h + dh),s16(p.l + dl)
        if run.loop ~= 0 and loopMode == 'split' then
            bullets.emitPrecise(run,kind,speed,a - 8,h,l)
            bullets.emitPrecise(run,kind,speed,a + 8,h,l)
            return
        end
        if run.loop ~= 0 and loopMode == 'fast' then speed = speed + 4 end
        bullets.emitPrecise(run,kind,speed,a,h,l)
        if run.loop ~= 0 and (loopMode == nil or loopMode == 'double') then
            bullets.emitPrecise(run,kind,speed + 6,a,h,l)
        end
    end

    local function cannon(p, index)
        local key = (p.turn + index * 8) % 24 + 1
        local offset = data.cannonMuzzles[key]
        return data.cannonAngles[key],offset[1],offset[2]
    end

    local function clock(t,key,gap)
        t[key] = t[key] - 1
        if t[key] >= 0 then return false end
        t[key] = gap
        return true
    end

    local function wing(o,side,kind,speed,angle,dh,dl,mode)
        local p = o.boxes[side + 4]
        local h,l = program.addPacked(0,0,dh,dl)
        emit(o,p,kind,speed,angle,h,l,mode)
    end

    A[0] = {
        function(o,t) t.clock = 0 end,
        function(o,t)
            local p = o.boxes[7]
            p.turn = (p.turn + 1) % 24
            local a,h,l = cannon(p,0)
            emit(o,p,7,0,a,h,l)
        end,
    }

    local function initCannon(o,t)
        local v = t.mode or 0
        t.side = t.index
        t.clock,t.gap,t.count,t.speed,t.muzzle = 0,0,1,0,0
        if v == 2 or v == 5 then
            t.clock,t.gap,t.count,t.speed = 0x20,0x20,5,4
        elseif v == 6 then
            t.clock,t.count,t.speed,t.round = 0x40,9,7,1
        elseif v == 3 or v == 7 then
            t.clock,t.gap,t.count,t.speed = 0,4,0x50,-4
            t.windup,t.sweep,t.raise = 0x40,1,8
        end
    end

    local function aimedCannon(o,t,p,a,h,l)
        a = aim(o,p,h,l,a) + program.bossRandom(o.run)
        local pattern = band(program.bossWideRandom(o.run),3)
        local angles,mode = {a},'double'
        if pattern == 1 then
            local delta = band(program.bossWideRandom(o.run),7) + 3
            angles = {a - delta,a + delta}
        elseif pattern == 2 then
            local delta = band(program.bossWideRandom(o.run),15) + 6
            angles,mode = {a,a - delta,a + delta},'split'
        end
        for _, b in ipairs(angles) do
            for i = 0,3 do emit(o,p,11,t.speed - i * 2,b,h,l,mode) end
        end
    end

    local function updateCannon(o,t)
        local p = o.boxes[t.side + 6]
        local dir = t.side == 1 and 1 or -1
        local mode = t.mode or 0
        if mode == 3 or mode == 7 then
            if t.windup > 0 then
                if t.windup > 0x10 then p.turn = (p.turn - 1) % 24 end
                t.windup = t.windup - 1
                if t.windup ~= 0 then return end
            end
            t.sweep = band(t.sweep + 1,255)
        elseif mode == 2 or mode == 5 or mode == 6 then
            p.turn = (p.turn + dir) % 24
        end
        if not clock(t,'clock',t.gap) then return end
        if mode == 0 or mode == 1 or mode == 4 then
            p.turn = (p.turn + dir) % 24
            local wide = mode == 1
            for mouth = 0,2 do
                local a,h,l = cannon(p,mouth)
                for _, k in ipairs(fanOrder) do
                    local loopMode = wide and (k ~= 0 or mouth == 2) and 'fast' or nil
                    emit(o,p,4,t.speed,a + k * (wide and 10 or 3),h,l,loopMode)
                end
                if not wide then
                    for _, k in ipairs(fanOrder) do emit(o,p,4,t.speed - 1,a + 0x20 + k * 3,h,l) end
                end
            end
        elseif mode == 2 or mode == 5 then
            local a,h,l = cannon(p,t.muzzle)
            aimedCannon(o,t,p,a,h,l)
            t.muzzle = (t.muzzle + 1) % 3
        elseif mode == 6 then
            local a = (t.side == 1 and ({0x80,0x68,0x98}) or ({0x80,0x98,0x68}))[t.round]
            local _,h,l = cannon(p,t.muzzle)
            emit(o,p,5,t.speed,a,h,l)
            t.muzzle,t.speed = (t.muzzle + 1) % 3,t.speed + 1
            if t.count == 1 and t.round < 3 then
                t.round,t.count,t.clock,t.muzzle,t.speed = t.round + 1,10,4,0,6
            end
        else
            for mouth = 0,2 do
                local a,h,l = cannon(p,mouth)
                emit(o,p,4,t.speed,a - t.sweep,h,l)
                emit(o,p,9,t.speed - 4,a + t.sweep,h,l)
            end
            if clock(t,'raise',8) then t.speed = t.speed + 1 end
        end
        t.count = t.count - 1
        if t.count == 0 then stop(o,t) end
    end
    A[1],A[2] = {initCannon,updateCannon},{initCannon,updateCannon}

    A[3] = {
        function(o,t) t.clock = 0xc end,
        function(o,t)
            if not clock(t,'clock',0x20) then return end
            local p = o.boxes[9]
            local a = aim(o,p,0,0)
            local m = data.turretMuzzles[band(math.floor(a / 4) + 1,0x3e) / 2 + 1]
            emit(o,p,11,-4,a,m[1],m[2])
            for _, side in ipairs({1,-1}) do
                for i = 1,3 do emit(o,p,11,-4,a + i * 3 * side,m[1],m[2]) end
                for i = 1,6 do emit(o,p,11,-8,a + (18 + i * 8) * side,m[1],m[2]) end
            end
        end,
    }

    A[4] = {
        function(o,t) t.turnClock,t.clock,t.round,t.count = 4,0x10,0,5 end,
        function(o,t)
            if clock(t,'turnClock',4) then
                o.boxes[7].turn = (o.boxes[7].turn + 1) % 24
                o.boxes[8].turn = (o.boxes[8].turn - 1) % 24
            end
            if not clock(t,'clock',0x40) then return end
            for side = 7,8 do
                local p = o.boxes[side]
                local a = aim(o,p,0,0)
                for _, delta in ipairs({0,0x18,-0x18}) do
                    for i = 0,2 do
                        local _,h,l = cannon(p,i)
                        emit(o,p,5,0x10,a + delta,h,l)
                        emit(o,p,5,0x10,a + delta + 3,h,l)
                    end
                end
            end
            if t.round < 3 then
                t.round = t.round + 1
                if t.round == 3 then t.clock = 0x50 end
            else
                t.count = t.count - 1
                if t.count == 0 then stop(o,t) end
            end
        end,
    }

    local function queue(o,kind,h,l,fields)
        local init,update = unpack(program.actorCallbacks[kind])
        local row = {o.run.major,0,kind,0,0,init,update,h=h,l=l,owner=o}
        for k,v in pairs(fields) do row[k] = v end
        local q = o.run.spawnQueue
        q[#q + 1] = row
    end

    A[5] = {
        function(o,t) t.cursor = 1 end,
        function(o,t)
            if not clock(t,'clock',t.gap) then return end
            local p = o.boxes[4]
            for i = 1,2 do
                if band(t.mask,2 ^ (i - 1)) ~= 0 then
                    local row = data.seedMuzzles[i][t.cursor]
                    local h,l = program.addPacked(p.h,p.l,row[1],row[2])
                    local speed = 0x20 + program.bossRandom(o.run)
                    local dir = (i == 1 and 0x30 or 0x10) + program.bossRandom(o.run)
                    queue(o,0x41,h,l,{speed=speed,dir=dir})
                end
            end
            t.cursor,t.count = t.cursor % 4 + 1,t.count - 1
            if t.count == 0 then stop(o,t) end
        end,
    }

    A[6] = {
        function(o,t) t.clock,t.turnClock,t.angles = 3,6,{0,0} end,
        function(o,t)
            if not clock(t,'clock',3) then return end
            local extra = clock(t,'turnClock',6) and 4 or 0
            local count = o.run.loop == 0 and 3 or 4
            for i = 1,2 do
                local offset = i == 1 and 0x1c0 or -0x1c0
                for j = 0,count - 1 do
                    wing(o,i,0x16,-4,t.angles[i] + j * (count == 3 and 0x55 or 0x40),-0x6c0,offset,'single')
                end
                t.angles[i] = t.angles[i] + (i == 1 and -1 or 1) * (4 + extra)
            end
        end,
    }

    A[7] = {
        function(o,t) t.clock,t.count = 0x50,2 end,
        function(o,t)
            if o.wingsBroken then stop(o,t); return end
            if not clock(t,'clock',0x20) then return end
            local p = o.boxes[6]
            local a = aim(o,p,-0x6c0,-0x1c0)
            for _, k in ipairs(fanOrder) do wing(o,2,4,0,a + k * 6,-0x6c0,-0x1c0) end
            t.count = t.count - 1
            if t.count == 0 then t.count,t.clock = 2,0x40 end
        end,
    }

    A[8] = {
        function(o,t) t.wait,t.clocks,t.bursts = {4,4},{0,0},{0,0} end,
        function(o,t)
            for i = 1,2 do
                if t.bursts[i] == 0 and clock(t.wait,i,i == 1 and 0x0d or 0x10) then t.bursts[i] = 1 end
                if t.bursts[i] ~= 0 and clock(t.clocks,i,i == 1 and 0x40 or 0x10) then
                    local p = o.boxes[i + 4]
                    local a,h,l = 0x40,-0x6c0,0x200
                    if i == 2 then a,h,l = 0xc0,-0x6c1,-0x200 end
                    for _, k in ipairs({4,12,-4,-12}) do emit(o,p,5,0,a + k,h,l) end
                    t.bursts[i] = 0
                end
            end
        end,
    }

    A[9] = {
        function(o,t) t.clock,t.hold,o.orbArrivals,o.orbCommand = 8,0x50,0,0 end,
        function(o,t)
            if t.clock > 0 then
                t.clock = t.clock - 1
                if t.clock == 0 then
                    local i = band(program.bossWideRandom(o.run),7) % 4 + 1
                    local pattern = data.orbitShots[i]
                    local p = o.boxes[2]
                    t.count = #pattern - 1
                    for j = 2,#pattern do queue(o,0x42,p.h,p.l,{orbit=pattern[1],angle=pattern[j],velocity=0x48,mode=0xff}) end
                end
            end
            if t.count and o.orbArrivals == t.count then
                t.hold = t.hold - 1
                if t.hold == 0 then o.orbCommand = 1; stop(o,t) end
            end
        end,
    }

    A[10] = {
        function(o,t) t.clock,t.gap,t.shotClock,t.muzzle,t.left,t.rank = 0x40,8,4,1,0,0 end,
        function(o,t)
            local p = o.boxes[2]
            if t.muzzle == 5 then
                if not clock(t,'clock',2) then return end
                if not t.aim then t.aim = aim(o,p,0,0) end
                local extra = ({0x0a,0x0e,0x09})[math.min(3,1 + (o.turretRank or 0))]
                local angles = {{-extra,extra},{0,-extra,extra},{-extra,-extra*3,extra,extra*3}}
                for i = 3,4 do
                    local m = data.hullMuzzles[i]
                    for _, delta in ipairs(angles[1 + (o.turretRank or 0)]) do
                        emit(o,p,0x13,8,t.aim + delta,m[1],m[2],'single')
                    end
                end
                t.left = t.left - 1
                if t.left == 0 then
                    o.turretRank = math.min(2,(o.turretRank or 0) + 1)
                    stop(o,t)
                end
                return
            end
            local m = data.hullMuzzles[t.muzzle]
            if t.left == 0 then
                if not clock(t,'clock',8) then return end
                t.left,t.aim = 0xa,aim(o,p,m[1],m[2]) + program.bossRandom(o.run)
            end
            if not clock(t,'shotClock',4) then return end
            emit(o,p,0x13,0,t.aim,m[1],m[2],'single')
            t.left = t.left - 1
            if t.left == 0 then
                t.muzzle = t.muzzle + 1
                if t.muzzle == 5 then t.left,t.aim,t.clock = 0xa,nil,0x30 end
            end
        end,
    }

    A[11] = {
        function(o,t) t.clock = 8 end,
        function(o,t)
            if not clock(t,'clock',0) then return end
            local p = o.boxes[2]
            for _, row in ipairs(data.finalOrbits) do
                queue(o,0x42,p.h,p.l,{orbit=0xe,angle=row[1],velocity=0x48,mode=row[2],final=true})
            end
            stop(o,t)
        end,
    }

    A[12] = {
        function(o,t) t.clock = 0xc end,
        function(o,t)
            if not clock(t,'clock',0x20) then return end
            local p = o.boxes[9]
            local a = aim(o,p,0,0)
            for i = -8,8 do emit(o,p,12,4,a + i * 7,0,0) end
        end,
    }

    A[13] = {
        function(o,t) t.clock,t.cursor,t.left = 8,0,t.count end,
        function(o,t)
            if not clock(t,'clock',8) then return end
            local p = o.boxes[2]
            if t.cursor == 0 then
                emit(o,p,11,8,0x80,0x800,0,'single')
                for i = 1,5 do emit(o,p,11,8,0x80 + 6 * i,0x800,0,'single') end
                for i = 1,5 do emit(o,p,11,8,0x80 - 6 * i,0x800,0,'single') end
            else
                for i = 0,4 do emit(o,p,11,8,0x83 + i * 6,0x800,0,'single') end
                for i = 0,4 do emit(o,p,11,8,0x7d - i * 6,0x800,0,'single') end
            end
            t.cursor,t.left = 1 - t.cursor,t.left - 1
            if t.left == 0 then stop(o,t) end
        end,
    }

    A[14] = {
        function(o,t) t.clock,t.gap,t.left,t.wave,t.speed,t.muzzle,t.aim = 4,3,0,5,0,1,0x80 end,
        function(o,t)
            local p = o.boxes[2]
            if t.left == 0 then
                if not clock(t,'clock',4) then return end
                t.left,t.wave,t.speed = t.wave,t.wave + 1,0
                t.muzzle = band(program.bossWideRandom(o.run),3) + 1
                local m = data.finalMuzzles[t.muzzle]
                t.aim = aim(o,p,m[1],m[2],t.aim)
            end
            if not clock(t,'gap',3) then return end
            local m = data.finalMuzzles[t.muzzle]
            emit(o,p,0x13,t.speed,t.aim,m[1],m[2],'fast')
            t.left,t.speed = t.left - 1,t.speed + 2
            if t.left == 0 then
                t.count = t.count - 1
                if t.count == 0 then stop(o,t) end
            end
        end,
    }

    -- 这些首帧入口写完槽参数后直接落入各自的更新入口。
    for _, handlers in pairs(A) do
        local init,update = unpack(handlers)
        handlers[1] = function(o,t) init(o,t); update(o,t) end
    end
    return A
end
