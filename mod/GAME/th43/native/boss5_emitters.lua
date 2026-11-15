-- 0x12b89a 的发射器各自保留计时器。炮口坐标从所属的机身或部件实时读取。
return function(program, bullets, api)
    local bit = require('bit')
    local band, arshift = bit.band, bit.arshift
    local max, min, floor = math.max, math.min, math.floor
    local data = program.boss5
    local wait = api.wait
    local E = {}

    local function signed(value)
        return value < 0x80 and value or value-0x100
    end

    local function randomByte(run)
        return signed(program.random(run,program.boss4.randomByte))
    end

    -- 0x12b972 读取四根转盘的当前炮口，而速度和换弹计数属于发射槽。
    E[0] = function(o)
        local run = o.run
        local difficulty = run.difficulty
        local interval = difficulty == 0 and 0x40 or 8
        local speed = difficulty == 0 and -2 or 0
        local length = difficulty == 3 and 4 or o.burstLength
        local clock, speedClock, remaining, kind = 8, interval, length, 1
        o.burstLength = max(4, o.burstLength - (difficulty == 2 and 4 or 2))
        while true do
            wait(1)
            if not run.suppressShots then
                clock = clock-1
                if clock < 0 then
                    clock, speedClock = 0, speedClock-1
                    if speedClock < 0 then speedClock, speed = interval, speed+1 end
                    for _, index in ipairs(o.rotary) do
                        local h,l = unpack(data.rotaryMuzzle[index+1])
                        local a = data.rotaryAngles:byte(index+1)
                        bullets.emitWidePair(run,kind,speed,a,o.h,o.l,h,l)
                    end
                    kind, remaining = 1, remaining-1
                    if remaining < 0 then
                        length = max(0,length-1)
                        kind, remaining = 0x3b, length
                    end
                end
            end
        end
    end

    -- 0x12bc10 的交叉扇束以十八个机身炮口为中心，另有一组角度累加器。
    E[1] = function(o)
        local run, difficulty = o.run, o.run.difficulty
        local initial = ({0x0a,6,6,5})[difficulty+1]
        local reload = 0
        local remaining = (difficulty == 0 and 4) or (difficulty == 3 and 3) or o.circleLength
        local length, warm, direction = remaining, 0x80, randomByte(run)
        local angles = {}
        for i = 1,18 do angles[i] = 0 end
        o.circleLength = max(3,o.circleLength-(difficulty==2 and 4 or 2))
        local clock = initial
        while true do
            wait(1)
            if run.pilotH then
                run.boss5Aim = program.aimByte(o.h,o.l,run.pilotH,run.pilotL,run.boss5Aim or 0x80)
            end
            if not run.suppressShots then
                clock = clock-1
                if clock < 0 then
                    clock = reload
                    local kind = warm == 0 and 3 or 2
                    if warm > 0 then
                        remaining = remaining-1
                        if remaining < 0 then
                            remaining, direction, kind = length, randomByte(run), 0x3d
                            length = max(3,length-1)
                        end
                    end
                    for i = 1,18 do
                        local h,l = unpack(data.bodyMuzzle[direction < 0 and 19-i or i])
                        local speed = direction < 0 and 8 or 12
                        if kind == 0x3d or kind == 3 or direction < 0 then
                            bullets.emitLongPair(run,kind,speed,angles[i],o.h,o.l,h,l,{(i-1)*direction})
                        else
                            bullets.emitAngle(run,kind,speed,angles[i],o.h,o.l,h,l)
                        end
                        if direction >= 0 and warm == 0 then
                            local d = signed(data.spreadTurns:byte(i))
                            angles[i] = band(angles[i]+d,0xff)
                            local a = angles[i]+d+arshift(randomByte(run),1)
                            bullets.emitAngle(run,7,-1,a,o.h,o.l,h,l)
                        end
                    end
                end
            end
            if warm > 0 then
                warm = warm-1
                if warm == 0 then direction = 0 end
            end
        end
    end

    E[3] = function(o)
        local run = o.run
        wait(1)
        while run.suppressShots do wait(1) end
        for i, m in ipairs(data.bodyMuzzle) do
            local angle, h, l = data.bodyAngles:byte(i), m[1], m[2]
            bullets.emitAngle(run,3,16,angle,o.h,o.l,h,l)
            local decrement = run.difficulty == 0 and 7 or 5
            local count = run.difficulty == 0 and 3 or 5
            for j = 1, count do bullets.emitAngle(run,2,16-j*decrement,angle,o.h,o.l,h,l) end
        end
    end

    local function rotarySweep(o, id)
        local run, difficulty = o.run, o.run.difficulty
        local clock = id == 4 and ({0x18,0x10,0xe,0xc})[difficulty+1] or 5
        local period = id == 4 and 0x10 or 0x20
        local count = id == 4 and (difficulty == 0 and 8 or 10) or 6
        local step = id == 4 and 1 or difficulty == 0 and 0x10 or difficulty == 3 and 2 or o.fanAngle
        local delta = id == 4 and step or -step
        if id == 5 then o.fanAngle = max(2,o.fanAngle-(difficulty==2 and 8 or 4)) end
        local a, b, volley, shotClock = 0, 0, 0, 0
        while true do
            wait(1)
            if not run.suppressShots then
                if volley == 0 then
                    clock = clock - 1
                    if clock < 0 then
                        clock, volley, a, b, step, delta = period, count, 0, 0, -step, -delta
                    end
                end
                if volley > 0 then
                    shotClock = shotClock - 1
                    if shotClock < 0 then
                        shotClock, volley = 2, volley-1
                        if id == 4 then
                            local p, q = o.parts[9], o.parts[11]
                            local motion = {0,2,1,0x7f}
                            bullets.emitWidePair(run,0x30,-20,0x80+a,p.h,p.l,nil,nil,motion)
                            bullets.emitMotion(run,0x30,-20,0x80+b,q.h,q.l,nil,nil,motion)
                        else
                            local p, q = o.parts[10], o.parts[12]
                            bullets.emitLongPair(run,9,-6,0x80+a,p.h,p.l)
                            bullets.emitLongPair(run,9,-8,0x80+b,q.h,q.l)
                        end
                        a,b = a+step,b+delta
                    end
                end
            end
        end
    end

    E[4] = function(o) rotarySweep(o,4) end
    E[5] = function(o) rotarySweep(o,5) end

    -- 0x12c27a 每轮先锁住一边的瞄准辅助槽，连发计数归零才恢复瞄准。
    E[6] = function(o)
        local run, difficulty = o.run, o.run.difficulty
        local period = ({0x30,0x18,0x14,0x10})[difficulty+1]
        local count = ({2,3,3,4})[difficulty+1]
        local clock, shotClock, remaining, side = 0x10, 0, 0, 1
        while true do
            wait(1)
            if not run.suppressShots then
                if remaining == 0 then
                    clock = clock-1
                    if clock < 0 then
                        clock, remaining, side = period, count, 3-side
                        o.sideAimHold = side
                    end
                end
                shotClock = shotClock-1
                if shotClock < 0 then
                    shotClock = 4
                    local part, angle = o.parts[side+6], o.sideAim[side]
                    local h,l = unpack(data.sideMuzzle[band(angle,0x3e)/2+1])
                    bullets.emitDirect(run,0xb,0,angle,part.h,part.l,h,l)
                    remaining = band(remaining-1,0xff)
                    if remaining == 0 then o.sideAimHold = nil end
                end
            end
        end
    end

    -- 0x12c41a 的三组弹中，母弹的制导作用由 0xfc5e8 处理。
    E[7] = function(o)
        local run, difficulty = o.run, o.run.difficulty
        local clock, period = 0x20, 0x38
        local count = difficulty == 0 and 1 or difficulty == 3 and 6 or o.fanLength
        local delay = difficulty == 0 and 0x20 or difficulty == 3 and 0xc or 0x10
        o.fanLength = min(6,o.fanLength+(difficulty==2 and 2 or 1))
        for speed = 16,0,-8 do
            for _ = 1, clock+1 do
                wait(1)
                while run.suppressShots do wait(1) end
            end
            for _ = 1, count do
                for _ = 1, delay+1 do
                    wait(1)
                    while run.suppressShots do wait(1) end
                end
                for i, p in ipairs(data.bodyMuzzle) do
                    local angle = data.bodyAngles:byte(i)
                    bullets.emitAngle(run,0x3c,speed,angle,o.h,o.l,p[1],p[2])
                    bullets.emitLongPair(run,2,5,angle-1,o.h,o.l,p[1],p[2])
                    bullets.emitLongPair(run,2,5,angle+1,o.h,o.l,p[1],p[2])
                end
                bullets.emitLongPair(run,2,5,0x80,o.h,o.l,-0xe40,0)
            end
            clock, count = period, count+1
        end
    end

    local function armStep(arm, speed, angle)
        local dh,dl = program.vector(speed,angle)
        arm.dh,arm.dl = program.s16(arm.dh+dh),program.s16(arm.dl+dl)
    end

    -- 0x12c54c 轮流移炮架到随机扰动的目标点，抵达后按自身炮口放出扩大扇。
    E[8] = function(o)
        local run = o.run
        local side, speed = 2, -14
        local count = run.difficulty == 0 and 2 or run.difficulty == 3 and 8 or o.armFanLength
        local delay = 4
        o.armFanLength = min(8, o.armFanLength + (run.difficulty == 2 and 2 or 1))
        for _ = 1,3 do
            wait(5)
            side = 3-side
            local arm = o.arms[side]
            local targetH = -0x1200 + floor(program.random(run,program.spawnJitter)/4)
            local targetL = (side == 1 and -0xe00 or 0xe00) + floor(program.random(run,program.spawnJitter)/2)
            local steps = 0x30+2*signed(program.random(run,program.effectRandom))
            for j = 0, steps-1 do
                local angle = program.angle(arm.dh,arm.dl,targetH,targetL,0)
                armStep(arm,floor(j/2),angle*4)
                wait(1)
            end
            local p = arm.head
            local angle = run.pilotH and program.angle(p.h,p.l,run.pilotH,run.pilotL,p.heading) or p.heading
            for volley = 1,count do
                for _ = 1,delay+1 do repeat wait(1) until not run.suppressShots end
                delay = 0
                local rays = 3+volley
                for i = 1,rays do
                    local a = angle + 2*i - rays - 1
                    local h,l = unpack(program.mid5.ringMuzzle[band(a,0x3f)+1])
                    bullets.emitDirect(run,0xc,speed+3*(volley-1),a,p.h,p.l,h,l)
                end
            end
            speed, count = speed+2,min(8,count+1)
        end
    end

    -- 0x12c7f0/0x12c906 控制两侧炮架各自绕出，再触发该侧的收回回调。
    local function armArc(o, side)
        local arm, head = o.arms[side], o.arms[side].head
        api.arms.launch(o,side)
        arm.dh, arm.dl = program.s16(head.h-o.h), program.s16(head.l-o.l)
        local direction, sign = side == 1 and 0xd0 or 0x30, side == 1 and 1 or -1
        for speed = 0,0x2f do
            wait(1)
            armStep(arm,speed,direction)
            direction = band(direction+sign,0xff)
        end
        direction = side == 1 and 0x58 or 0xa8
        for speed = 0x30,0x4e,2 do
            armStep(arm,speed,direction)
            if speed < 0x4e then wait(1) end
        end
        arm.launched=true
        direction = band(direction+0x80,0xff)
        repeat
            armStep(arm,8,direction)
            wait(1)
        until arm.dh >= -0x1c00
        api.aux(o,13+side)
    end

    E[9] = function(o) armArc(o,1) end
    E[10] = function(o) armArc(o,2) end

    -- 0x12ca1c 的炮口选择表沿当前旋转关节轮转。
    E[11] = function(o)
        local index, clock, run = 1, 0xc, o.run
        while true do
            for _ = 1, clock+1 do repeat wait(1) until not run.suppressShots end
            clock = 0
            local p, angle = o.parts[index+8], 0x20-o.rotaryPosition[index]
            for _, offset in ipairs({0,4,8,12,16,-4,-8,-12,-16}) do
                bullets.emitLongPair(run,3,-7,angle+offset,p.h,p.l)
            end
            index = index % 4+1
        end
    end

    local function armVolley(o, side)
        local run, arm = o.run, o.arms[side]
        local direction = arm.head.heading
        for wave = 0,5 do
            repeat wait(1) until not run.suppressShots
            for _, part in ipairs(arm.joints) do
                bullets.emitMotion(run,0x3e,-6+3*wave,direction*4+0x10,part.h,part.l,nil,nil,{0x70})
                bullets.emitMotion(run,0x3e,-6+3*wave,direction*4+0x30,part.h,part.l,nil,nil,{0x70})
            end
            wait(2)
        end
    end

    E[12] = function(o) armVolley(o,1) end
    E[13] = function(o) armVolley(o,2) end

    E[14] = function(o, parameters)
        local run = o.run
        local period, count, repeatPeriod = unpack(parameters)
        local angle = program.random(run,program.enemyRandom)
        while count > 0 do
            for _ = 1, period+1 do repeat wait(1) until not run.suppressShots end
            for i = 0,15 do bullets.emitLongPair(run,8,4,4*(angle+i*4),o.h,o.l) end
            angle, count = band(angle+2,0xff),count-1
            period = repeatPeriod
        end
    end

    -- 0x12ce48 以自机方向和 ROM 随机源初始化五向弹，在同一槽内改变发射角。
    E[15] = function(o, parameters)
        local run = o.run
        local count, step = unpack(parameters)
        count = count-band(program.random(run,program.randomParity),3)
        local angle = run.pilotH and program.aimByte(o.h,o.l,run.pilotH,run.pilotL,0x80) or 0x80
        angle = angle+2*signed(program.random(run,program.effectRandom))
        local gap = band(program.random(run,program.randomParity),1) == 0 and 0x10 or 0xe
        local speed, clock = 0,7
        for _ = 1,count do
            repeat wait(1) until not run.suppressShots
            repeat wait(1) until not run.suppressShots
            for _, k in ipairs({0,1,2,-1,-2}) do
                bullets.emitAngle(run,0x3f,speed,angle+k*gap,o.h,o.l)
            end
            speed, clock = band(speed+3,0xff),clock-1
            if clock < 0 then clock, angle = 0, angle+step end
        end
    end

    E[16] = function(o)
        local run = o.run
        local delay = 0
        while true do
            for _ = 1,delay+1 do repeat wait(1) until not run.suppressShots end
            delay = 2
            if run.pilotH then
                local angle = program.angle(o.h+0x400,o.l,run.pilotH,run.pilotL,0x20)
                angle = band(angle+signed(program.random(run,program.effectRandom)),0x3f)
                local speed = signed(program.random(run,program.effectRandom))
                local h,l = unpack(program.mid5.ringMuzzle[angle+1])
                bullets.emitLongPair(run,7,speed,angle*4,o.h,o.l,h,l)
            end
        end
    end

    E[17] = function(o)
        local run = o.run
        repeat wait(1) until not run.suppressShots
        local angle = program.random(run,program.enemyRandom)
        local speed = band(program.random(run,program.randomParity),3)-1
        bullets.emitDirect(run,0x40,speed,angle,o.h,o.l)
    end

    local function muzzle(programTable, angle)
        return unpack(programTable[band(angle+2,0xfc)/4+1])
    end

    E[18] = function(o, parameters)
        local run = o.run
        local heading, step = unpack(parameters)
        local turn, clock = floor(step/4), 2
        for _ = 1,5 do
            for _ = 1,clock+1 do repeat wait(1) until not run.suppressShots end
            clock=0
            local h,l = muzzle(program.mid5.coverMuzzle,heading)
            bullets.emitAngle(run,9,4,heading-0x20,o.h,o.l,h,l)
            bullets.emitAngle(run,9,4,heading+0x20,o.h,o.l,h,l)
            for i = 0,3 do
                local angle = heading+0x40*i
                h,l = muzzle(program.mid5.ringMuzzle,angle)
                bullets.emitMotion(run,0x42,0,angle,o.h,o.l,h,l,{turn})
            end
            heading = band(heading+step,0xff)
        end
    end

    E[19] = function(o)
        local run = o.run
        local round = math.min(3,o.finalRing or 1)
        local angle = program.random(run,program.enemyRandom)*4
        local count, clock = 4,8
        for _, entry in ipairs(data.finalRings[round]) do
            local rays, gap, speed, kind, offset = unpack(entry)
            for volley = 0,count do
                for _ = 1,clock+1 do repeat wait(1) until not run.suppressShots end
                clock=0
                local a = angle+(volley%2)*offset
                for i = 0,rays-1 do
                    local direction = a+i*gap
                    local h,l = muzzle(program.mid5.ringMuzzle,direction)
                    if kind == 1 then bullets.emitAngle(run,kind,speed,direction,o.h,o.l,h,l)
                    else bullets.emitLongPair(run,kind,speed,direction,o.h,o.l,h,l) end
                end
            end
            count = count+2
        end
        o.finalRing=round+1
    end

    E[20] = function(o)
        wait(1)
        for index=1,16 do
            if index > 1 then wait(9) end
            api.drones.spawn(o,index)
        end
    end

    E[23] = function(o)
        local run = o.run
        local delay, count, speed = 3,5,0
        local left,right=0x70,0x90
        for burst = 1,2 do
            for _ = 1,count do
                for _ = 1,delay+1 do wait(1) end
                delay = 3
                local h,l = muzzle(program.mid5.coverMuzzle,left)
                bullets.emitAngle(run,0x45,speed,left,o.h,o.l,h,l)
                bullets.emitAngle(run,0x45,speed+4,left-0x20,o.h,o.l,h,l)
                h,l = muzzle(program.mid5.coverMuzzle,right)
                bullets.emitAngle(run,0x45,speed,right,o.h,o.l,h,l)
                bullets.emitAngle(run,0x45,speed+4,right+0x20,o.h,o.l,h,l)
                speed,left,right = speed+1,left-2,right+2
            end
            if burst == 1 then
                wait(0x20)
                count,speed=7,-8
            end
        end
    end

    -- 0x12d670 每组换用另一种母弹和相反的转向。
    E[25] = function(o)
        local run = o.run
        local angles={program.random(run,program.randomParity),program.random(run,program.randomParity)}
        local sign = signed(program.random(run,program.randomParity)) < 0 and -1 or 1
        local period, block, nextGap = 0x10,0x11,0x18
        for group = 4,0,-1 do
            local n = group%2+1
            local kind, speed = n==1 and 0x46 or 0x47,n==1 and 0x12 or 0xa
            for _ = 0,block do
                wait(period+1)
                period = 3
                for i = 0,13 do
                    local a = angles[n] + i*0x12
                    local h,l = muzzle(program.mid5.coverMuzzle,a)
                    bullets.emitMotion(run,kind,speed,a,o.h,o.l,h,l,{0x2c,n==1 and -0x20*sign or 0x20*sign})
                end
                angles[1],angles[2] = angles[1]+7*sign,angles[2]-7*sign
            end
            period, nextGap, block = nextGap,max(4,nextGap-2),max(5,block-6)
        end
    end

    -- 0x12d79e 维护两路独立的换向和计时状态，子弹读取各自的派生节拍。
    E[26] = function(o)
        local run = o.run
        local angles={program.random(run,program.randomParity),program.random(run,program.randomParity)}
        local sign = signed(program.random(run,program.randomParity))<0 and -1 or 1
        local angleStep, angleDelta, angleLimit = {-4*sign,7*sign}, {2*sign,-2*sign}, {4*sign,-7*sign}
        local turn, turnDelta, turnLimit = {0x40*sign,-0x40*sign},{-2*sign,2*sign},{-0x40*sign,0x40*sign}
        local shotClock, changeClock, gate = {0,0x50},{3,3},{0xa0,0xf0}
        local cycle = {0x60+program.random(run,program.enemyRandom),0x60+program.random(run,program.enemyRandom)}
        local changing, turning = {}, {}
        run.boss5Beat = {2,3}
        while true do
            wait(1)
            for side = 1,2 do
                local beat = side+1
                run.boss5Beat[side] = run.boss5Beat[side]-1
                if run.boss5Beat[side] < 0 then
                    run.boss5Beat[side] = beat
                    if turning[side] then
                        turn[side]=turn[side]+turnDelta[side]
                        if turn[side] == turnLimit[side] then
                            turnLimit[side],turnDelta[side],turning[side]=-turnLimit[side],-turnDelta[side],false
                        end
                    end
                end
                if gate[side] > 0 then gate[side] = gate[side]-1 end
                shotClock[side] = shotClock[side]-1
                if shotClock[side] < 0 then
                    shotClock[side]=0xc
                    for i = 0,gate[side] == 0 and 1 or 0 do
                        local a=angles[side]+0x80*i
                        local h,l=muzzle(program.mid5.coverMuzzle,a)
                        bullets.emitMotion(run,side==1 and 0x48 or 0x49,side==1 and 10 or 5,a,o.h,o.l,h-0x200,l,{turn[side]})
                    end
                    angles[side]=angles[side]+angleStep[side]
                    if changing[side] then
                        changeClock[side]=changeClock[side]-1
                        if changeClock[side] < 0 then
                            changeClock[side]=3
                            angleStep[side]=angleStep[side]+angleDelta[side]
                            if angleStep[side] == angleLimit[side] then
                                changing[side]=false
                                angleLimit[side],angleDelta[side]=-angleLimit[side],-angleDelta[side]
                            end
                        end
                    end
                    cycle[side]=cycle[side]-1
                    if cycle[side]<0 then
                        local variation = program.random(run,program.enemyRandom)
                        cycle[side]=side==1 and 0x60 or 0x60+variation
                        changing[side],turning[side]=true,true
                    end
                end
            end
        end
    end

    E[0x18] = function(o)
        local run, side = o.run, 1
        local clock, shotClock = 0x10, 0
        while true do
            local ready = not run.suppressShots and run.pilotH and run.pilotH > 0x4800
            if ready then
                clock = clock-1
                if clock < 0 then
                    clock, side = 4, 3-side
                    o.sideAimHold = side
                    for _ = 1, 3 do
                        for i = 1, shotClock do
                            repeat wait(1) until not run.suppressShots
                        end
                        local p, angle = o.parts[side+6], o.sideAim[side]
                        local h,l = unpack(data.sideMuzzle[band(angle,0x3e)/2+1])
                        for _, delta in ipairs({0,2,-2}) do
                            bullets.emitDirect(run,0xb,side==1 and 4 or 0,angle+delta,p.h,p.l,h,l)
                        end
                        shotClock = 4
                    end
                    o.sideAimHold = nil
                end
            end
            wait(1)
        end
    end

    return E
end
