-- 二面关底的攻击任务。0x13ac5c 在移动任务之后按槽号推进。
return function(program,bullets,tasks)
    local data = program.boss2
    local band, floor = require('bit').band, math.floor
    local M = {}

    local function wait(t,key,reload)
        t[key] = t[key] - 1
        if t[key] >= 0 then return false end
        t[key] = reload
        return true
    end

    local function fire(o,origin,kind,speed,angle,offset)
        -- 0x1710be 分别加两个字，横向偏移的进位不会加到纵坐标。
        local h = program.s16(origin.h + floor(offset / 0x10000))
        local l = program.s16(origin.l + program.s16(offset))
        return bullets.emit(o,kind,speed,angle,h-o.h,l-o.l,true)
    end

    local function finish(o,t)
        o.attacks[t.slot] = nil
    end

    -- 0x1916aa：一轮大弹只登记原程序角度范围内的方向。
    local function finalRings(o,t)
        if not wait(t,'clock',2) then return end
        for ray=0,15 do
            local angle = band(t.angle+t.spin+ray*0x10,255)
            if angle >= 0x3c and angle < 0xc4 then
                local offset = program.mid2.muzzle1[floor(band(angle+2,0xfc)/4)+1]
                fire(o,o,25,-6,angle,offset)
            end
        end
        t.count,t.spin = t.count-1,t.spin-t.turn
        if t.count == 0 then finish(o,t) end
    end

    M[0] = {function(o,t)
        t.angle = program.angle8(o.h,o.l,o.run.player,0x80)+0xc
        t.count,t.clock,t.spin = t.count+2,0,0
        finalRings(o,t)
    end,finalRings}

    local function sendMine(o,t,angle)
        local queue = o.run.spawnQueue
        if #queue >= 40 then return end
        queue[#queue+1] = {o.run.major,o.run.minor,0x6b,0,0,0,0,0x192bf4,0x192bfc,0x192c58,
            boss=o,h=program.s16(o.h-0x800),l=o.l,speed=0x10,angle=band(angle,255),turn=t.turn}
    end

    -- 0x191852：每次将三个雷挂到 0x6b 敌机队列，随后更新发射方位。
    local function mines(o,t)
        if not wait(t,'clock',t.delay) then return end
        for ray=0,2 do sendMine(o,t,t.angle+ray*0x55) end
        t.series = t.series-1
        if t.series < 0 then
            t.series,t.turn,t.reverse = 0x14,-t.turn,not t.reverse
        end
        t.angle = band(t.angle+t.turn,255)
        if t.reverse then t.turn = math.max(-7,t.turn-1)
        else t.turn = math.min(7,t.turn+1) end
        if math.abs(t.turn) == 7 then t.delay = math.max(0xd,t.delay-1) end
    end

    M[2] = {function(o,t)
        t.clock,t.delay,t.angle,t.turn,t.series = 0,0x10,0,7,0x14
        mines(o,t)
    end,mines}

    -- 0x191958：原版用两个随机表选择炮口顺序、起始角和每组的转向。
    local function rings(o,t)
        if t.count == 0 then
            if not wait(t,'delay',8) then return end
            t.count,t.length,t.speed = t.length,t.length + 2,1
            t.angle = program.random(o.run,program.randomByte)
            t.turn = program.random(o.run,program.randomByte) >= 0x80 and -1 or 1
        end
        if not wait(t,'shotDelay',1) then return end
        local origin = o.extraParts[t.ports[t.port]]
        for ray = 0,11 do
            local angle = t.angle + ray * 0x15
            local offset = program.mid2.muzzle1[floor(band(angle+2,0xfc)/4)+1]
            fire(o,origin,25,t.speed,angle,offset)
        end
        t.angle,t.speed,t.count = band(t.angle + t.turn,255),t.speed + 2,t.count - 1
        if t.count == 0 then
            t.port = t.port + 1
            if t.port > #t.ports then finish(o,t) end
        end
    end

    M[3] = {function(o,t)
        t.count,t.length,t.delay,t.shotDelay,t.port = 0,5,0,0,1
        t.ports = data.ringPorts[program.random(o.run,data.ringOrder,63)+1]
        program.nextRandom(o.run)
        o.run.bulletCapacity = 150
        rings(o,t)
    end,rings}

    -- 0x191d4e：每次锁一个炮口，四发结束后恢复该炮口的跟踪。
    local function cannon(o,t)
        if t.count == 0 then
            if not wait(t,'delay',8) then return end
            t.count,t.port = 4,o.extraParts[t.indexOfPort]
            t.angle,t.port.locked = t.port.aim,true
        end
        if not wait(t,'shotDelay',4) then return end
        fire(o,t.port,6,3,t.angle,data.cannonMuzzle[floor(band(t.angle + 2,0xf8) / 8) + 1])
        t.count = t.count - 1
        if t.count == 0 then
            t.port.locked = false
            t.indexOfPort = 3 + (t.indexOfPort - 2) % 4
            if t.stopping then finish(o,t) end
        end
    end

    M[6] = {function(o,t)
        t.delay,t.shotDelay,t.count,t.indexOfPort = 0,0,0,3
        cannon(o,t)
    end,cannon}

    -- 0x191e5c：扇面每轮提速一级，中心角每次最多修正一格。
    local function rounds(o,t)
        if not wait(t,'shotDelay',4) then return end
        local origin = {h=program.s16(o.h - 0x1580),l=o.l}
        local target = program.angle8(origin.h,origin.l,o.run.player,t.angle)
        local turn = program.s8(target - t.angle)
        t.angle = band(t.angle + math.max(-1,math.min(1,turn)),255)
        for i = -2,2 do
            local angle = t.angle + i * 0x14
            local offset = program.dualCannon.muzzle[floor(band(angle + 2,0xfc) / 4) + 1]
            fire(o,origin,21,t.speed,angle,offset)
        end
        t.speed,t.count = t.speed + 1,t.count - 1
        if t.count == 0 then finish(o,t) end
    end

    M[7] = {function(o,t)
        t.shotDelay,t.speed = 0,2
        o.run.bulletCapacity = 150
        t.angle = program.angle8(program.s16(o.h - 0x1580),o.l,o.run.player,0x80)
        rounds(o,t)
    end,rounds}

    local wingPorts = {0x600,0x02800800,0x05000900,0x08000a00,0xfffffa00,0x027ff800,0x04fff700,0x07fff600}

    -- 0x191f4a：左右按原表顺序各扫四个位置，下一组收窄张角。
    local function wings(o,t)
        if t.count == 0 then
            if not wait(t,'delay',10) then return end
            t.count = 3
            t.angle = program.angle8(o.h,o.l,o.run.player,0x80)
        end
        if not wait(t,'shotDelay',4) then return end
        for i,offset in ipairs(wingPorts) do
            local k = i <= 4 and (1 - i) or (i - 5)
            fire(o,o,14,4,t.angle + k * t.spread,offset)
        end
        t.count = t.count - 1
        if t.count == 0 then
            t.spread,t.groups = t.spread - 4,t.groups - 1
            program.nextRandom(o.run)
            if t.groups == 0 then finish(o,t) end
        end
    end

    M[8] = {function(o,t)
        t.delay,t.shotDelay,t.count = 0,0,0
        wings(o,t)
    end,wings}

    local function sweep(o,t)
        local p,q,r,s = o.extraParts[3],o.extraParts[4],o.extraParts[5],o.extraParts[6]
        p.aim,q.aim,r.aim,s.aim = band(p.aim+1,255),band(q.aim-1,255),band(r.aim+1,255),band(s.aim-1,255)
        if wait(t,'outer',5) then
            for i,part in ipairs({r,s}) do
                local sign = i == 1 and -1 or 1
                for j=0,3 do
                    local angle = part.barrel+j*sign
                    fire(o,part,25,i-1-j,angle,program.mid2.muzzle1[floor(band(angle+2,0xfc)/4)+1])
                end
                for j=0,2 do
                    local angle = part.barrel+0x7f+j*sign*2
                    fire(o,part,25,i+2-j,angle,program.mid2.muzzle1[floor(band(angle+2,0xfc)/4)+1])
                end
            end
        end
        if wait(t,'inner',8) then
            local a,b = data.innerMuzzle[floor(band(p.barrel+2,0xfc)/4)+1],
                data.innerMuzzle[floor(band(q.barrel+2,0xfc)/4)+1]
            fire(o,p,10,-5,p.barrel,a)
            fire(o,p,10,-7,p.barrel+0x40,a)
            fire(o,q,10,-7,q.barrel,b)
            fire(o,q,10,-9,q.barrel-0x40,b)
        end
    end

    -- 0x192048 暂停跟踪，四个炮口按两组相反的方向扫过原版扇面。
    M[9] = {function(o,t)
        t.outer,t.inner = 0x40,0x40
        o.trackSuspended = true
        local angle = data.sweepAngles[program.random(o.run,program.mid2.patternRandom,127)+1]
        for i,part in ipairs({3,6,4,5}) do o.extraParts[part].aim = band(angle+(i-1)*0x40,255) end
        o.run.bulletCapacity = 190
        sweep(o,t)
    end,sweep}

    local function sendOrb(o,side,angle,offset)
        local queue = o.run.spawnQueue
        if #queue >= 40 then return end
        local h,l = program.addPacked(o.h,o.l,offset)
        queue[#queue+1] = {o.run.major,o.run.minor,0x6c,0,0,0,0,0x192de8,0x192df0,0x192e3c,
            boss=o,h=h,l=l,angle=band(angle,255),side=side}
    end

    -- 0x192320：两颗球从机腹交叉绕行。球的沿路发射和原点扫射由不同任务控制。
    local function orbs(o,t)
        if not t.waiting and wait(t,'volleyDelay',0x20) then
            o.orbsFire = true
            t.count = t.count - 1
            if t.count < 0 then
                t.length = math.min(8,t.length+2)
                t.waiting,t.count,o.orbsFire = true,t.length,false
                tasks.attach(o.attacks,16,{remaining=t.burstCount})
                t.burstCount = math.min(8,t.burstCount+3)
            end
        end
        if t.waiting and not tasks.contains(o.attacks,16) then t.waiting,t.volleyDelay = false,0x60 end
        if not wait(t,'orbDelay',1) then return end
        sendOrb(o,0,t.angle,0xe1fff480)
        sendOrb(o,1,t.angle+0x80,0xe2000b80)
        t.angle = t.angle + t.turn
        if t.angle == 0xb0 or t.angle == -0x30 then t.turn = -t.turn end
    end

    M[10] = {function(o,t)
        t.orbDelay,t.volleyDelay,t.count,t.length,t.angle,t.turn = 0,0x20,4,4,0,4
        t.burstCount = 4
        orbs(o,t)
    end,orbs}

    local fanAngles = {0,0xc,0x18,-0xc,-0x18}

    -- 0x19284a：四门炮按顺序各发五颗箭弹。
    local function trackedFans(o,t)
        if t.delay > 0 then t.delay=t.delay-1; return end
        if not wait(t,'clock',6) then return end
        for index=3,6 do
            local part = o.extraParts[index]
            for _,delta in ipairs(fanAngles) do fire(o,part,13,0,part.barrel+delta,0) end
        end
    end

    M[14] = {function(o,t)
        t.clock,t.delay = 0,0xe0
        trackedFans(o,t)
    end,trackedFans}

    -- 0x192986：炮口从一侧扫向中心，再沿相反方向退出。
    local function sweepCenter(o,t)
        if not wait(t,'clock',1) then return end
        local origin = {h=program.s16(o.h-0x1580),l=o.l}
        fire(o,origin,11,0xc,t.angle,t.offset)
        if not t.returning then
            t.angle = t.angle+t.turn
            if t.turn < 0 and t.angle <= 0x7c or t.turn > 0 and t.angle >= 0x84 then
                if t.turn > 0 then t.angle = 0x80 end
                t.returning,t.turn = true,-t.turn
            end
        end
        if t.returning then
            t.angle = t.angle+t.turn
            if t.turn < 0 and t.angle <= 0x40 or t.turn > 0 and t.angle >= 0xc0 then finish(o,t) end
        end
    end

    M[15] = {function(o,t)
        t.clock,t.turn = 0,t.angle <= 0x80 and 2 or -2
        o.run.bulletCapacity = 190
        sweepCenter(o,t)
    end,sweepCenter}

    -- 0x192a72：两层交错扇面从同一挂点发出，完成传入的轮数即摘除。
    local function mouthVolley(o,t)
        if not wait(t,'delay',0xc) then return end
        local aim = program.angle8(o.h,o.l,o.run.player,0x80)
        for layer=1,2 do
            local start = layer == 1 and 0x24 or 0x31
            for i=0,7+layer do
                local angle = aim - start + i*9
                local offset = program.dualCannon.muzzle[floor(band(angle+2,0xfc)/4)+1]+0xfe000000
                fire(o,o,2,4-layer*2,angle,offset)
            end
        end
        t.remaining = t.remaining - 1
        if t.remaining == 0 then finish(o,t) end
    end

    M[16] = {function(o,t)
        t.delay = 0
        mouthVolley(o,t)
    end,mouthVolley}

    return M
end
