-- 0x121e18 的十二个槽独立推进。母机事件登记参数，炮位和弹槽分别保存自己的进度。
return function(program, bullets, data, children)
    local band = require('bit').band
    local floor, max, min = math.floor, math.max, math.min
    local add, s16 = program.add, program.s16
    local yield = coroutine.yield
    local M = {}

    local function sleep(frames)
        for _ = 1, frames do yield() end
    end

    local function awaitPilot(run)
        while not run.pilotH do yield() end
    end

    local function aim(run, h, l, fallback)
        return run.pilotH and program.aimByte(h, l, run.pilotH, run.pilotL, fallback) or fallback
    end

    local function jitter(run)
        local n = program.random(run, program.effectRandom)
        return n < 128 and n or n - 256
    end

    local function bitRandom(run, mask)
        return band(program.random(run, data.randomByte), mask)
    end

    local function muzzle(o, side, angle, outer)
        local offset = outer and data.outerMuzzle or data.aimMuzzle
        local dh, dl = unpack(offset[floor(band(angle,0x3e) / 2)%#offset+1])
        if outer then
            if side == 1 then return add(o.h, o.l, dh-0x1300, dl+0x780) end
            return add(o.h, o.l, dh-0x1301, -dl-0x780)
        end
        local h, l = add(o.h, o.l, side == 1 and 0x1000 or 0xfff, side == 1 and 0xa40 or -0xa40)
        return add(h, l, dh, dl)
    end

    local function shortFan(run, kind, speed, angle, h, l, width)
        if run.route.loop == 0 then bullets.emitAngle(run, kind, speed, angle, h, l)
        else
            bullets.emitAngle(run, kind, speed, angle-width, h, l)
            bullets.emitAngle(run, kind, speed, angle+width, h, l)
        end
    end

    -- 0x121e88 在俯冲过程中每次从两种分配入口挑一个，十六个炮口各按角表取偏移。
    M[0] = function(o, count)
        local a = program.random(o.run, data.randomByte)
        for _ = 1, count do
            awaitPilot(o.run)
            local homing = bitRandom(o.run, 1) == 0
            for i = 0, 15 do
                local angle = band(a + i * 0x10, 0xff)
                local h, l = add(o.h, o.l, 0x180, 0)
                h, l = add(h, l, unpack(data.ringMuzzle[floor(band(angle+2,0xff)/4)+1]))
                if homing then bullets.emitFasterInLoop(o.run, 0x23, 0, angle, h, l)
                else bullets.emitLongPair(o.run, 8, 0, angle, h, l) end
            end
            yield()
        end
    end

    M[1] = function(o, count)
        o.auxiliary[5] = 0
        for i = 1, count do
            awaitPilot(o.run)
            local h,l = add(o.h, o.l, -0x1a80, 0)
            bullets.emitAngle(o.run, 9, 3, 0x80, h, l)
            if o.run.route.loop == 1 then
                bullets.emitAngle(o.run, 9, 3, 0x7c, h, l)
                bullets.emitAngle(o.run, 9, 3, 0x84, h, l)
            end
            if i < count then sleep(5) end
        end
        o.auxiliary[5] = nil
    end

    M[2] = function(o)
        local run = o.run
        local a = floor(aim(run, o.h, o.l, 0x80) / 4)
        local modifier, spread, clock, aimClock = -4, 3, 6, 0
        while true do
            awaitPilot(run)
            aimClock = aimClock - 1
            if aimClock < 0 then
                aimClock = 1
                a = program.turnToward(a, floor(aim(run, o.h, o.l, a*4)/4))
            end
            local h,l = add(o.h, o.l, 0x180, 0)
            bullets.emitAngle(run, 3, modifier, a*4, h, l)
            bullets.emitAngle(run, 0xb, modifier, a*4+spread, h, l)
            bullets.emitAngle(run, 0xb, modifier, a*4-spread, h, l)
            clock = clock - 1
            if clock < 0 then clock, spread = 6, min(0x40, spread + 1) end
            modifier = min(0x20, modifier + 1)
            sleep(4)
        end
    end

    M[3] = function(o)
        local run = o.run
        local rate = ({16,4,3,2})[run.difficulty+1]
        local angle = jitter(run)
        local h,l = add(o.h, o.l, 0x180, 0)
        for _, da in ipairs({0,6,12,18,-6,-12,-18}) do
            bullets.emitLongPair(run, 0x24, 14, angle+da, h, l, nil,nil,{rate,rate})
        end
    end

    M[4] = function(o, bursts)
        local run = o.run
        local d = run.difficulty+1
        local interval, count, side, same = ({40,20,16,12})[d], d == 4 and 4 or 8, 1, 0
        for _ = 1, bursts do
            local previous = side
            side = bitRandom(run,1)+1
            if side == previous then
                same = same + 1
                if same > 1 then side, same = 3-side, 0 end
            else
                same = 0
            end
            sleep(interval)
            interval = max(0x10, interval - 4)
            local target = band((side == 1 and 0x12 or 0x2e) + floor(jitter(run)/2),0x3f)
            repeat
                o.turret[side] = program.turnToward(o.turret[side], target)
                if o.turret[side] ~= target then yield() end
            until o.turret[side] == target
            for i = 1, count do
                awaitPilot(run)
                local a = o.turret[side]
                local h,l = muzzle(o, side, a)
                bullets.emitFasterInLoop(run, 0x2b, 4, a*4, h, l)
                if i < count then sleep(4) end
            end
        end
    end

    M[5] = function(o)
        local run = o.run
        local h, l = add(o.h, o.l, 0xb40, 0)
        local a, spread, turn = aim(run, h, l, 0x80), 0x40, bitRandom(run,1) == 0 and -1 or 1
        local untilCenter = false
        local swing = max(1, o.eyeRate or 6)
        o.eyeRate = max(1, swing - 1)
        local clock, fire = swing, 2
        while true do
            h,l = add(o.h, o.l, 0xb40, 0)
            if spread > 0x14 then
                spread = spread - 1
                a = aim(run,h,l,a)
            else
                clock = clock - 1
                if clock < 0 then
                    clock = 0
                    if untilCenter then
                        a = a + turn
                        if a == 0xa8 or a == 0x58 then turn = -turn end
                    elseif a == 0x80 then untilCenter = true
                    else
                        local diff = band(a-0x80,0xff)
                        a = band(a + (diff < 0x80 and -1 or 1),0xff)
                    end
                end
            end
            o.eyeAngle = floor(a / 4)
            if run.pilotH then
                fire = fire - 1
                if fire < 0 then
                    fire = 0
                    for _, da in ipairs({-spread,-spread-8,spread,spread+8}) do
                        shortFan(run,0xb,2,a+da,h,l,2)
                    end
                end
            end
            yield()
        end
    end

    local function rotateBoth(o, left, right)
        repeat
            o.turret[1] = program.turnToward(o.turret[1], left)
            o.turret[2] = program.turnToward(o.turret[2], right)
            if o.turret[1] ~= left or o.turret[2] ~= right then yield() end
        until o.turret[1] == left and o.turret[2] == right
    end

    M[6] = function(o)
        rotateBoth(o, 0x18, 0x28)
        while true do
            awaitPilot(o.run)
            for side = 1, 2 do
                local a = o.turret[side]
                local h,l = muzzle(o, side, a)
                bullets.emitFasterInLoop(o.run, 0x2b, 4, a*4, h, l)
            end
            o.turret[1], o.turret[2] = max(0xc,o.turret[1]-1), min(0x34,o.turret[2]+1)
            sleep(7)
        end
    end

    M[7] = function(o)
        local run = o.run
        rotateBoth(o, band(0x10+jitter(run),0x3f), band(0x20+jitter(run),0x3f))
        local turns = {program.random(run,data.turn), program.random(run,data.turn)}
        local clock = 0
        while true do
            awaitPilot(run)
            for side = 1, 2 do
                local a = band(o.turret[side] + turns[side] * (side == 1 and -1 or 1),0x3f)
                o.turret[side] = a
                if clock == 0 then
                    local h,l = muzzle(o, side, a)
                    for ray = 0, 5 do
                        local modifier = (side == 1 and 8 or 4) - 2*ray
                        bullets.emitLongPair(run,3,modifier,4*(a+3*ray*turns[1]),h,l)
                    end
                end
            end
            clock = (clock+1)%5
            yield()
        end
    end

    M[8] = function(o, parameters)
        local run = o.run
        local d = run.difficulty+1
        local count, interval, last, repeatCount = d == 1 and 4 or parameters.count, parameters.interval, -1, 0
        for _ = 1, count do
            sleep(interval+1)
            awaitPilot(run)
            interval = max(0x18, interval - ({0,2,4,6})[d])
            local side, pattern = bitRandom(run,1), bitRandom(run,1)
            if last == pattern then
                repeatCount = repeatCount + 1
                if repeatCount >= pattern + 1 then pattern, repeatCount = 1-pattern, 0 end
            else
                repeatCount = 0
            end
            last = pattern
            local h,l = add(o.h,o.l,side == 0 and 0x6ff or 0x700, side == 0 and -0x15c0 or 0x15c0)
            children.shell(o,h,l,aim(run,h,l,0x80) + 2*jitter(run),pattern)
        end
    end

    -- 0x1228ec 两侧的倒计时独立，收到事件 4 的结束信号后仍发完已经装填的弹。
    M[9] = function(o, parameters)
        local run = o.run
        local guns = {}
        for i = 1, 2 do
            guns[i] = {clock=0,interval=parameters.interval,inner=0,remaining=0,
                count=6,speed=-8,index=0}
        end
        repeat
            awaitPilot(run)
            for i, gun in ipairs(guns) do
                if gun.remaining == 0 and not parameters.ending then
                    local a = data.sweepAngles[i]:byte(band(gun.index,0x3f)+1)
                    local old = o.outerGun[i]
                    o.outerGun[i] = i == 2 and a or (a == old and old or old+(a>old and 1 or -1))
                    gun.clock = gun.clock - 1
                    if gun.clock < 0 then
                        gun.clock = gun.interval
                        gun.interval = max(4,gun.interval-1)
                        gun.index = (i==1 and 0x1a or 0x26) + jitter(run)
                        gun.remaining, gun.count, gun.speed = gun.count, gun.count+1, -8
                    end
                end
                if gun.remaining > 0 then
                    gun.inner = gun.inner - 1
                    if gun.inner < 0 then
                        gun.inner, gun.remaining = 3, gun.remaining-1
                        local a = o.outerGun[i]
                        local h,l = muzzle(o,i,a,true)
                        if i == 2 then a=0x40-a end
                        bullets.emitShortPair(run,0xc,gun.speed,a,h,l)
                        gun.speed = gun.speed + 2
                    end
                end
            end
            if not parameters.ending or guns[1].remaining > 0 or guns[2].remaining > 0 then yield() end
        until parameters.ending and guns[1].remaining == 0 and guns[2].remaining == 0
    end

    M[10] = function(o)
        local run = o.run
        local a = band(0x20 + jitter(run),0x3f)
        rotateBoth(o,a,a)
        for i = 1,6 do
            awaitPilot(run)
            for side = 1,2 do
                local h,l = muzzle(o,side,a)
                if run.route.loop == 1 then bullets.emitCenterAndWide(run,0xb,8,a*4,h,l)
                else bullets.emitDirect(run,0xb,8,a,h,l) end
            end
            for side = 1,2 do
                local dl = side == 1 and 1 or -1
                local h,l = add(o.h,o.l, side == 1 and 0x700 or 0x6ff, dl * 0x18c0)
                bullets.emitDirect(run,0xb,8,a,h,l)
                h,l = add(o.h,o.l, side == 1 and 0x700 or 0x6ff, dl * 0x15c0)
                bullets.emitFasterInLoop(run,0xb,8,a*4,h,l)
                h,l = add(o.h,o.l, side == 1 and 0x4c0 or 0x4bf, dl * 0x1000)
                bullets.emitWidePair(run,0xb,8,a*4,h,l)
            end
            if i < 6 then sleep(2) end
        end
    end

    M[11] = function(o)
        local run = o.run
        local d = run.difficulty+1
        local interval, count, ramp = ({0x40,0x20,0x1c,0x18})[d], d==1 and 2 or 4, d==4 and 2 or 3
        local a = 0x80
        for _ = 1,0xa0 do
            local h,l = add(o.h,o.l,0x180,0)
            a = aim(run,h,l,a)
            yield()
        end
        local width, tier = ramp, 0
        sleep(interval+1)
        while true do
            awaitPilot(run)
            local h,l = add(o.h,o.l,0x180,0)
            local nextAngle = band(aim(run,h,l,a) + jitter(run),0xff)
            local turn = band(nextAngle-a,0xff) < 0x80 and 2 or -2
            a = nextAngle
            for i = 1,count do
                awaitPilot(run)
                h,l = add(o.h,o.l,0x180,0)
                for _, da in ipairs({0,20,-20}) do bullets.emitSpread(run,0x17,-3,a+da,h,l) end
                if tier >= 1 then
                    bullets.emitSpread(run,0x17,-3,a+40,h,l)
                    bullets.emitSpread(run,0x17,-3,a-40,h,l)
                end
                if tier >= 2 then
                    bullets.emitFasterInLoop(run,0x17,-3,a+60,h,l)
                    bullets.emitFasterInLoop(run,0x17,-3,a-60,h,l)
                end
                a = band(a+turn,0xff)
                if i < count then sleep(5) end
            end
            width = width - 1
            if width < 0 then width, tier = ramp,min(3,tier+1) end
            sleep(interval+1)
            interval = interval>0x13 and interval-3 or 0xc
        end
    end

    return M
end
