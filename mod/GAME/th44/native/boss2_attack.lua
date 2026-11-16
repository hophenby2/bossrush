-- 0x197b42 的攻击参数留在各自的任务槽，子弹自身另存运动参数。
return function(program, bullets, playerAngle, turn, deploy, jitter)
    local band = require('bit').band
    local s16, floor, abs = program.s16, math.floor, math.abs
    local data = program.boss2
    local M = {}

    local function done(o,t)
        o.attacks[t.slot] = nil
    end

    local function pair(init, update)
        return {function(o,t) init(o,t); update(o,t) end,update}
    end

    local function expire(o,t)
        t.count = t.count - 1
        if t.count == 0 then done(o,t) end
    end

    local function ready(t,key,interval)
        t[key] = t[key] - 1
        if t[key] >= 0 then return false end
        t[key] = interval
        return true
    end

    local function emit(o, part, kind, speed, angle, h, l, precise, settings)
        local fire = precise and bullets.emitPrecise or bullets.emit
        return fire(o.run,kind,speed,angle,s16(part.h + h),s16(part.l + l),settings)
    end

    local function doubled(o,part,kind,speed,angle,h,l,precise,settings)
        emit(o,part,kind,speed,angle,h,l,precise,settings)
        if o.run.loop ~= 0 then emit(o,part,kind,speed + 6,angle,h,l,precise,settings) end
    end

    local function mouth(table, facing)
        return table[band(facing + 1,0x3e) / 2 + 1]
    end

    local function aim256(o, part)
        local p = o.run.player
        if p and p.active then return program.angle256(part.h,part.l,p.h,p.l,0x80) end
    end

    local function turnSign(run)
        return program.bossSmallRandom(run) == 0 and -1 or 1
    end

    local function preciseOffset(o, p, kind, speed, a, offset, shape, double)
        local arrow = shape[band(a + 2,0xfc) / 4 + 1]
        local h,l = program.addPacked(offset[1],offset[2],arrow[1],arrow[2])
        if double then
            doubled(o,p,kind,speed,a,h,l,true)
        else
            emit(o,p,kind,speed,a,h,l,true)
        end
    end

    M[0] = {function(_,t) t.clock,t.side,t.count=8,1,2 end,function(o,t)
        if not ready(t,'clock',8) then return end
        local p = o.boxes[t.side == 1 and 6 or 5]
        local m = mouth(t.side == 1 and data.leftMuzzles or data.rightMuzzles,p.angle)
        local a = band(p.angle + 1,0x3e) * 4
        local jitter = t.variant == 1
        local gap,n,speed = jitter and 2 or 0x10,jitter and 2 or 3,jitter and 4 or -2
        doubled(o,p,1,speed,a,m[1],m[2],true)
        for _, sign in ipairs({1,-1}) do
            for j = 1,n do doubled(o,p,1,speed,a + sign * j * gap,m[1],m[2],true) end
        end
        t.side = -t.side
        expire(o,t)
    end}

    M[1] = pair(function(o,t)
        t.clock,t.swing,t.delta = 0,0,turnSign(o.run)
    end,function(o,t)
        if not ready(t,'clock',5) then return end
        t.swing = t.swing + t.delta
        if t.swing == 0 or abs(t.swing) == 1 then t.delta = -t.delta end
        local p = o.run.player
        if p and p.active then
            local angle = program.angle(o.h + 0x800,o.l,p.h,p.l,0x20)
            angle = (angle + t.swing) * 4 + program.bossRandom(o.run)
            local h,l = t.sign < 0 and 0x7ff or 0x800,t.sign < 0 and -0x100 or 0x100
            local extras = o.run.loop == 0 and {0,12,-12} or {0,12,-12,-20,-4,4,20}
            for _, delta in ipairs(extras) do
                local a = band(angle + delta,0xff)
                local muzzle = data.fanMuzzles[band(a,0x3f) + 1]
                local dh,dl = program.addPacked(h,l,muzzle[1],muzzle[2])
                emit(o,o,0x13,8,a,dh,dl,true)
            end
        end
        expire(o,t)
    end)

    local function chooseMineCount(o,t)
        t.burst = band(0x10 + program.bossRandom(o.run) * 2,0xff)
    end
    M[2] = {function(o,t) t.clock,t.cursor=0,1; chooseMineCount(o,t) end,function(o,t)
        if not ready(t,'clock',1) then return end
        local a = program.bossRandom(o.run) + ((t.sign or 0) < 0 and 0x30 or 0x10)
        local m = data.rearMuzzles[t.cursor]
        t.cursor = t.cursor % #data.rearMuzzles + 1
        for n = 0,3 do
            doubled(o,o.boxes[2],0x12,-0x14 + 2 * n,a,m[1],m[2],false,{clock=0x140 - 0x60 * n})
        end
        t.burst = t.burst - 1
        if t.burst < 0 then t.clock=0x18; chooseMineCount(o,t) end
    end}

    M[3] = {function(_,t) t.clock,t.count=0,4 end,function(o,t)
        if not ready(t,'clock',4) then return end
        doubled(o,o.boxes[8],7,0,0x20,-0x900,0x80,false)
        doubled(o,o.boxes[7],7,0,0x20,-0x901,-0x80,false)
        expire(o,t)
    end}

    local function sendDrone(o,t)
        local part = o.boxes[t.sign and t.sign < 0 and 6 or 5]
        deploy(o,0x32,part,0,0,0x30,band(part.angle + 0x20,0x3f))
        done(o,t)
    end
    M[4] = {sendDrone,sendDrone}
    local function sendDrones(o,t)
        local part = o.boxes[5]
        for i = 0,4 do deploy(o,0x32,part,0,0,0x18,band(part.angle + 0x20 + 2 * i,0x3f)) end
        done(o,t)
    end
    M[5] = {sendDrones,sendDrones}

    local function align(o,t)
        if t.ready then return true end
        local r,l = o.boxes[5],o.boxes[6]
        r.angle = turn(r.angle,t.target[1])
        l.angle = t.together and r.angle or turn(l.angle,t.target[2])
        t.ready = r.angle == t.target[1] and l.angle == t.target[2]
        return t.ready
    end

    local function initializeWing(o,t)
        t.delta = {turnSign(o.run),turnSign(o.run)}
        t.ready,t.arrowClock,t.largeClock = false,0x10,t.index == 9 and 0x18 or 0x20
        if t.index == 6 then
            local offset
            repeat offset = program.bossRandom(o.run) until offset ~= 0
            local a = band(0x20 + 2 * offset,0x3f)
            t.target,t.together = {a,a},true
        elseif t.index == 7 then
            t.target = {program.randomEnemy(o.run) % 64,program.randomEnemy(o.run) % 64}
        else
            local bias = t.index == 9 and 0x20 or 0
            t.target = {}
            for i = 1,2 do
                local p = o.boxes[i + 4]
                t.target[i] = band(playerAngle(o,p,p.angle) + bias,0x3f)
            end
            if t.index == 9 then t.arrowClock = 0x44 end
        end
    end

    local function wingFire(o,t)
        if not align(o,t) then return end
        local loop = o.run.loop ~= 0
        if t.index ~= 6 and ready(t,'largeClock',t.index == 7 and 0x18 or t.index == 8 and 0x10 or 2) then
            for i = 5,6 do
                local p = o.boxes[i]
                emit(o,p,11,t.index == 9 and 7 or 6,p.angle + 0x20,0,0,false)
                if t.index ~= 9 and loop then
                    emit(o,p,11,6,p.angle + 0x1f,0,0,false)
                    emit(o,p,11,6,p.angle + 0x21,0,0,false)
                end
            end
        end
        if not ready(t,'arrowClock',t.index == 7 and 2 or 0) then return end
        if o.run.enemyShotGrace > 0 then return end
        for i = 1,2 do
            local p = o.boxes[i + 4]
            p.angle = band(p.angle + t.delta[i],0x3f)
            if p.angle % 2 == 1 then
                local face = band(p.angle + 1,0x3e)
                local offset = mouth(data.rightMuzzles,p.angle)
                if t.index == 6 then
                    local gap = loop and 3 or 2
                    for j = 0,loop and 4 or 2 do
                        local a = band(face + (j - 1) * gap,0x3f)
                        local speed = -4 + j + ((a < 0x10 or a > 0x30) and 8 or 0)
                        emit(o,p,7,speed,a,offset[1],offset[2],false)
                    end
                elseif t.index == 8 then
                    local function ray(delta, baseSpeed)
                        local a = band(face * 4 + delta,0xff)
                        local speed = baseSpeed + ((a < 0x40 or a > 0xc0) and 8 or 0)
                        preciseOffset(o,p,7,speed,a,offset,data.arrowMuzzles,false)
                    end
                    ray(-2,-1); ray(0,-1); ray(2,-1)
                    if loop then ray(3,-3); ray(-3,-3) end
                elseif t.index == 7 then
                    for _, delta in ipairs({0,6,12,-6,-12}) do
                        local a = band(face + delta,0x3f)
                        local m = data.arrowMuzzles[a + 1]
                        local speed = -6 + ((a < 0x10 or a > 0x30) and 8 or 0)
                        local h,l = program.addPacked(offset[1],offset[2],m[1],m[2])
                        if loop then
                            emit(o,p,7,speed,a * 4 - 8,h,l,true)
                            emit(o,p,7,speed,a * 4 + 8,h,l,true)
                        else emit(o,p,7,speed,a,h,l,false) end
                    end
                else
                    for j = 0,loop and 1 or 0 do
                        local a = band(face + 4 * j,0x3f)
                        local high = a < 0x10 or a > 0x30
                        local m = data.arrowMuzzles[a + 1]
                        local h,l = program.addPacked(offset[1],offset[2],m[1],m[2])
                        local count = (high and 2 or 4) - (j == 1 and (high and 1 or 2) or 0)
                        for k = 0,count - 1 do emit(o,p,7,(high and 0x17 or 0) + 2 * k,a,h,l,false) end
                    end
                end
            end
        end
        expire(o,t)
    end

    for _, id in ipairs({6,7,8,9}) do M[id] = pair(initializeWing,wingFire) end

    M[10] = {function(_,t)
        t.clock,t.interval,t.side,t.spread,t.volley=0x10,4,1,0xc,6
    end,function(o,t)
        local tracked = o.boxes[t.side == 1 and 4 or 3]
        tracked.angle = turn(tracked.angle,playerAngle(o,tracked,tracked.angle))
        if not ready(t,'clock',t.interval) then return end
        local p = o.boxes[t.side == 1 and 3 or 4]
        local muzzle = mouth(data.smallMuzzles,p.angle)
        local a = p.angle * 4
        local loop = o.run.loop ~= 0
        preciseOffset(o,p,7,-1,a,muzzle,data.fanMuzzles,false)
        if loop then
            preciseOffset(o,p,7,-1,a - 2,muzzle,data.fanMuzzles,false)
            preciseOffset(o,p,7,-1,a + 2,muzzle,data.fanMuzzles,false)
        end
        local plus = a + (loop and 2 or 0) + t.spread
        local minus = a - t.spread
        preciseOffset(o,p,7,-1,plus,muzzle,data.fanMuzzles,false)
        preciseOffset(o,p,7,-1,minus,muzzle,data.fanMuzzles,false)
        if loop then
            preciseOffset(o,p,7,-5,plus - 4,muzzle,data.fanMuzzles,false)
            preciseOffset(o,p,7,-5,minus + 4,muzzle,data.fanMuzzles,false)
        end
        t.spread,t.volley = t.spread + 0xa,t.volley - 1
        if t.volley == 0 then
            t.spread,t.volley,t.side = 0xc,6,-t.side
            expire(o,t)
        end
    end}

    local function wingPea(o,p)
        local a = p.angle + 0x20
        emit(o,p,11,6,a,0,0,false)
        if o.run.loop ~= 0 then
            emit(o,p,11,6,a - 1,0,0,false)
            emit(o,p,11,6,a + 1,0,0,false)
        end
    end
    local function quickWing(o,t)
        for i = 5,6 do
            local p = o.boxes[i]
            p.angle = turn(p.angle,band(playerAngle(o,p,p.angle) + 0x20,0x3f))
        end
        if ready(t,'clock',t.spacing) then
            wingPea(o,o.boxes[5]); wingPea(o,o.boxes[6])
            done(o,t)
        end
    end
    M[11] = pair(function(_,t) t.clock=t.spacing or 0 end,quickWing)

    M[12] = {function(o,t)
        t.wait,t.clock,t.cycle,t.left = 0x40,0,0,0x30 + program.bossRandom(o.run)
        t.right = 0x10 + program.bossRandom(o.run)
    end,function(o,t)
        if t.wait >= 0 then t.wait = t.wait - 1 end
        if t.wait < 0 then
            t.right,t.left,t.cycle=t.right + 1,t.left - 1,(t.cycle + 1) % 64
            if t.cycle == 0 then expire(o,t); return end
        end
        if ready(t,'clock',2) then
            doubled(o,o,7,0x12,t.left,0x3ff,-0x100,false)
            doubled(o,o,7,0x12,t.right,0x400,0x100,false)
        end
    end}

    M[13] = pair(function(o,t) t.clock=o.run.loop == 0 and 4 or 2 end,function(o,t)
        if not ready(t,'clock',0) then return end
        local speed = o.run.loop == 0 and -2 or 0x12
        for _, i in ipairs({1,2,5,6}) do
            local m = data.finalMuzzles[i]
            doubled(o,o,7,speed,t.angles and t.angles[i < 5 and 1 or 2] or 0x20,m[1],m[2],false)
        end
        expire(o,t)
    end)

    M[14] = pair(function(o,t)
        t.clock,t.count,t.angle = 8,2,aim256(o,o) or 0x80
        t.speed = 0
    end,function(o,t)
        if not ready(t,'clock',0) then return end
        local wide = t.kind == 4 or t.secondKind == 4
        local kind = t.count == 2 and t.kind or t.secondKind
        local spacing = t.spacing
        local function ray(a, speed)
            local at = data.arrowMuzzles[band(a + 2,0xfc) / 4 + 1]
            emit(o,o,kind,speed + (o.run.loop == 0 and 0 or 4),a,0x800 + at[1],at[2],true)
        end
        ray(t.angle,t.speed)
        for _, sign in ipairs({1,-1}) do
            for j = 1,wide and 3 or 10 do
                local a = t.angle + sign * spacing * j
                ray(a,t.speed)
                if o.run.loop ~= 0 then ray(a - 2 * sign,t.speed - 4) end
            end
        end
        t.spacing,t.speed = t.spacing + 2,t.speed + 10
        expire(o,t)
    end)

    M[15] = {function(_,t) t.clock,t.toggle,t.count=0,false,0 end,function(o,t)
        if not ready(t,'clock',0) then return end
        local a = aim256(o,o)
        if not a then return end
        local speedUp = o.health <= 0x2f98 and 3 or 0
        local count = o.health <= 0x2f98 and o.run.frame % 2 == 0 and 2 or 1
        for _ = 1,count do
            local l,h = floor(jitter(o.run) / 8),floor(jitter(o.run) / 8)
            local randomAngle = program.bossRandom(o.run)
            local modifier = floor(program.bossRandom(o.run) / 2) - 6 + speedUp
            if abs(randomAngle) > 1 then modifier = modifier + abs(randomAngle) end
            local shotAngle = a + 5 * randomAngle
            t.toggle = not t.toggle
            if o.run.loop == 0 then
                emit(o,o,0x16,modifier,shotAngle,0x600 + h,l,true)
            else
                emit(o,o,0x16,modifier,shotAngle - 8,0x600 + h,l,true)
                emit(o,o,0x16,modifier,shotAngle + 8,0x600 + h,l,true)
                if t.toggle then emit(o,o,0x16,modifier,shotAngle,0x600 + h,l,true) end
            end
        end
    end}

    return M
end
