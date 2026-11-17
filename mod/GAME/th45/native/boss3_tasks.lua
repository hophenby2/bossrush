-- 0x193aca、0x19454a 和 0x1965a2 分别登记短任务、阶段事件与攻击。
return function(program,bullets,effects,tasks,distance)
    local bit = require('bit')
    local band = bit.band
    local s8,s16 = program.s8,program.s16
    local floor = math.floor
    local data = program.boss3
    local aux,events,attacks = {},{},{}

    local function emit(o,kind,speed,angle,offset,precise)
        bullets.emit(o,kind,speed,angle,s16(floor(offset/0x10000)),s16(offset),precise)
    end

    local function nextMotion(o,index,h,l,rate)
        o.move = nil
        if index==3 then o.nextMotion={index=index,h=h,l=l,rate=rate}
        else o.nextMotion={index=index,h=h,l=l,speed=rate,direction=o.direction} end
    end

    local function spin(o,t)
        o.engineFrame = (o.engineFrame+o.engineSpin)%8
        t.clock = t.clock-1
        if t.clock<0 then
            t.clock = 0
            o.mainFrame = (o.mainFrame+o.spin)%16
        end
    end
    aux[0] = {function(o,t) t.clock=0; spin(o,t) end,spin}

    local function deployChain(o,t)
        if not t.deployed then
            t.offset = t.offset-0xc0
            o.chainTargetH,o.chainTargetL = s16(o.anchorH+t.offset),o.anchorL
            t.clock = t.clock-1
            if t.clock==0 then t.deployed=true; tasks.attach(o.aux,4) end
        end
        if t.deployed then
            t.linger = t.linger-1
            if t.linger==0 then
                o.chainProfile,o.chainSpeed,o.chainSpeedClock,o.chainSpeedPeriod = 1,0,7,7
                o.aux[t.slot] = nil
            end
        end
    end
    aux[1] = {function(o,t)
        local run = o.run
        local queue = run.spawnQueue
        queue[#queue+1] = {0,0,0x6e,0,0,0,0,0,0,0x195426,boss=o}
        o.chainH,o.chainL = o.anchorH,o.anchorL
        o.chainSpeed,o.chainProfile,o.chainSpeedClock,o.chainSpeedPeriod = 0,2,0,0
        t.clock,t.offset,t.linger = 0x44,0,0x60
        deployChain(o,t)
    end,deployChain}

    local function openWing(o,t)
        t.clock = t.clock-1
        if t.clock>=0 then return end
        t.clock = 1
        o.front,o.back,o.right,o.left = o.front+0x40,o.back-0x40,o.right+0x50,o.left+0x50
        local p = o.extraParts[1]
        p.front,p.right,p.left = p.front+0x40,p.right-0x20,p.left-0x20
        o.doorFrame = o.doorFrame+1
        if o.doorFrame==15 then
            o.draws[2],o.draws[3],o.draws[4] = nil,true,true
            o.aux[t.slot] = nil
        end
    end
    aux[2] = {function(o,t)
        o.draws[1],o.draws[2] = nil,true
        t.clock = 0
        openWing(o,t)
    end,openWing}

    local function orbit(o,t)
        local dh,dl = program.vector(t.radius,t.angle)
        o.chainTargetH,o.chainTargetL = s16(o.anchorH-0x3300+dh),s16(o.anchorL+dl*2)
        t.angle,t.clock = band(t.angle+t.turn,255),t.clock-1
        if t.clock<0 then t.clock=0x60-band(program.random(o.run,program.randomByte),31) end
        t.radius = math.min(0x70,t.radius+2)
    end
    aux[4] = {function(o,t)
        t.radius,t.angle,t.clock = 0,0x40,0x60-band(program.random(o.run,program.randomByte),31)
        t.turn = s8(program.random(o.run,program.boss2.finalTurn))
        orbit(o,t)
    end,orbit}

    local function approachChain(o,t)
        if o.chainSpeed<=1 or distance(o.chainH,o.chainL,o.chainTargetH,s16(o.chainTargetL-o.run.cameraOffset))<=0x400 then
            o.aux[t.slot] = nil
            tasks.attach(o.aux,7)
        end
    end
    aux[6] = {function(o,t)
        o.chainTargetH,o.chainTargetL = t.h,t.l
        tasks.stop(o.aux,4)
        tasks.stop(o.aux,7)
        o.chainProfile,o.chainSpeedClock,o.chainSpeedPeriod = 2,0,0
        approachChain(o,t)
    end,approachChain}

    local function driftChain(o,t)
        local dh,dl = program.vector(3,t.angle)
        t.h,t.l,t.angle = s16(t.h+dh),s16(t.l+dl),band(t.angle+1,255)
        o.chainTargetH,o.chainTargetL = t.h,t.l
    end
    aux[7] = {function(o,t)
        t.h,t.l,t.angle = o.chainTargetH,o.chainTargetL,0
        driftChain(o,t)
    end,driftChain}

    events[0] = {function(o,t)
        tasks.attach(o.aux,0)
        nextMotion(o,0)
        o.events[t.slot] = nil
    end}

    local function firstChange(o,t)
        if t.countdown>0 then
            t.countdown = t.countdown-1
            return
        end
        if not t.opening then
            t.opening,t.wait = true,0x40
            tasks.attach(o.aux,2)
        end
        if tasks.contains(o.aux,2) then return end
        t.wait = t.wait-1
        if t.wait==0 then
            o.protected = false
            tasks.attach(o.events,8)
            o.events[t.slot] = nil
        end
    end
    events[1] = {function(o,t)
        t.countdown = 0x80
        nextMotion(o,5,0x5000,0x1c00,3)
        firstChange(o,t)
    end,firstChange}

    local function secondChange(o,t)
        t.clock = t.clock-1
        if t.clock==0 then
            o.protected = false
            tasks.attach(o.events,11)
            o.events[t.slot] = nil
        end
    end
    events[2] = {function(o,t) t.clock=0x40 end,secondChange}

    local function defeat(o,t)
        if t.phase==0 then
            effects.emitSequence(o,data.defeatBlast)
            t.phase,t.delay = 1,0x10
            return
        end
        if t.phase==1 then
            if t.delay>0 then
                t.delay = t.delay-1
                if t.delay>0 then return end
            end
            t.clock = t.clock-1
            if t.clock>=0 then return end
            t.clock = 1
            local port = data.defeatPorts[t.port]
            local row = data.defeatSmoke[t.smokeIndex]
            local speed = floor(row[5]/256)+floor(s8(program.random(o.run,program.randomNarrow))/2)
            local angle = band(row[5]+s8(program.random(o.run,program.randomNarrow)),255)
            local offset = port+row[2]*0x10000+band(row[3],0xffff)
            effects.emit(o,row[1],speed,angle,offset,false,row[6])
            t.port,t.smokeIndex,t.count = t.port%3+1,t.smokeIndex%#data.defeatSmoke+1,t.count-1
            if t.count==0 then
                o.draws = {}
                t.phase,t.delay = 2,12
            end
            return
        end
        t.delay = t.delay-1
        if t.delay>0 then return end
        if t.phase==2 then
            t.phase,t.delay = 3,8
        elseif t.phase==3 then
            effects.emitSequence({run=o.run,h=s16(o.h+0x4800),l=o.l},data.finalBlast)
            t.phase,t.delay = 4,0x80
        else
            o.finished = true
            o.events[t.slot] = nil
        end
    end
    events[3] = {function(o,t)
        t.phase,t.clock,t.count,t.port,t.smokeIndex = 0,0x20,0x3c,1,1
        nextMotion(o,1)
    end,defeat}

    local function chainFans(o,t)
        if t.phase==0 then
            t.delay = t.delay-1
            if t.delay==0 then t.phase=1 end
        end
        if t.phase==1 and not tasks.contains(o.aux,6) and (o.chainVolley or 0)==0 then
            t.clock = t.clock-1
            if t.clock<0 then
                local run = o.run
                local player = run.player
                local jitter = program.hovercraftRandom[program.nextRandom(run,127)]
                local l = math.max(0xc00,math.min(0x2c00,(player and player.l or 0x1c00)+floor(jitter/8)))
                tasks.attach(o.aux,6,{h=s16(o.h-0x3000),l=l})
                o.chainLinksFire,o.chainVolley = true,2
                t.count = t.count-1
                if t.count==4 then t.reload=0xc end
                t.clock = t.reload
                if t.count==0 then t.phase=2 end
            end
        end
        if t.phase==2 and (o.chainVolley or 0)==0 then
            o.chainLinksFire = false
            tasks.stop(o.aux,6)
            tasks.stop(o.aux,7)
            tasks.attach(o.aux,4)
            tasks.attach(o.events,6)
            o.events[t.slot] = nil
        end
    end
    events[5] = {function(o,t)
        t.phase,t.delay,t.clock,t.reload,t.count = 0,0x20,0x60,0x28,6
        nextMotion(o,3,0x7600,0x1c00,0)
        chainFans(o,t)
    end,chainFans}

    local function sweep(o,t)
        t.clock = t.clock-1
        if t.clock>=0 then return end
        t.clock = t.reload
        local angles = t.mirrored and {t.angle,-t.angle} or {t.angle-0x20,t.angle+0x20}
        for _,a in ipairs(angles) do
            a = band(a,255)
            if a>=0x20 and a<=0xe0 then
                local offset = program.stage3Heavy.muzzle[floor(band(a+2,0xfc)/4)+1]+0xea000000
                emit(o,15,t.speed,a,offset,true)
            end
        end
        t.angle,t.count = band(t.angle+t.turn,255),t.count-1
        if t.count==0 then
            t.count,t.turn,t.speed,t.pass = t.countReload,-t.turn,t.speed+4,t.pass-1
            if t.pass==0 then o.attacks[t.slot]=nil end
        end
    end
    attacks[4] = {function(o,t)
        t.clock,t.reload,t.count,t.countReload = 0,0,20,20
        t.turn = t.side<0 and 7 or -7
        t.speed,t.angle,t.mirrored = t.pass>1 and -1 or 5,t.turn<0 and 0xb8 or 0x48,t.mode<0
        sweep(o,t)
    end,sweep}

    local function ports(o,stream)
        if stream.count==0 then return end
        stream.clock = stream.clock-1
        if stream.clock>=0 then return end
        stream.clock = stream.period
        local aim = program.angle8(s16(o.h+stream.aimOffset),o.l,o.run.player,stream.aim)
        local delta = s8(aim-stream.aim)
        stream.aim = band(stream.aim+(delta<0 and -1 or delta>0 and 1 or 0),255)
        local dh,dl = program.vector(0x80,stream.angle)
        dh,dl = s16(floor(dh*stream.scaleH)),s16(dl*stream.scaleL)
        local offset = dh*0x10000+band(dl,0xffff)
        emit(o,stream.kind,stream.speed,stream.aim,offset+stream.offset,true)
        emit(o,stream.kind,stream.speed,stream.aim,-offset,true)
        stream.angle,stream.speed,stream.count = band(stream.angle+stream.turn,255),stream.speed+1,stream.count-1
    end

    local function counterspin(o,t)
        ports(o,t.first)
        ports(o,t.second)
        if t.first.count+t.second.count==0 then o.attacks[t.slot]=nil end
    end
    attacks[3] = {function(o,t)
        local run = o.run
        t.first = {kind=0x19,count=0xe,clock=1,period=1,speed=1,angle=program.random(run,program.randomHalf,127)-0x20,
            scaleH=0.5,scaleL=1,offset=-0x18000000,aimOffset=-0x1000}
        t.first.turn = program.random(run,program.randomByte)>=0x80 and 3 or -3
        t.first.aim = program.angle8(s16(o.h-0x1000),o.l,run.player,0x80)
        t.second = {kind=0x1a,count=0x1e,clock=0,period=0,speed=-1,angle=program.random(run,program.randomHalf,127)-0x20,
            scaleH=2,scaleL=4,offset=-0x8000000,aimOffset=-0x1800}
        t.second.turn = program.random(run,program.randomByte)>=0x80 and 5 or -5
        t.second.aim = program.angle8(s16(o.h-0x1800),o.l,run.player,0x80)
        counterspin(o,t)
    end,counterspin}

    local function sweeps(o,t)
        if t.delay>0 then t.delay=t.delay-1; if t.delay>0 then return end end
        if t.state==1 and not tasks.contains(o.attacks,3) then
            t.clock = t.clock-1
            if t.clock<0 then
                tasks.attach(o.attacks,4,{side=t.side,mode=t.mode,pass=t.pass})
                t.side,t.mode,t.pass = -t.side,-t.mode,t.pass+1
                t.state,t.count,t.gap = 2,t.nextCount,0x20
                t.nextCount = t.nextCount+1
            end
        end
        if t.state==2 and not tasks.contains(o.attacks,3) and not tasks.contains(o.attacks,4) then
            t.gap = t.gap-1
            if t.gap<0 then
                tasks.attach(o.attacks,3)
                t.gap,t.count,t.reload = 0x20,t.count-1,t.reload-1
                if t.count==0 then
                    t.state,t.clock,t.bursts = 1,t.reload,t.bursts-1
                    if t.bursts==0 then t.state=3 end
                end
            end
        end
        if t.state==3 and not tasks.contains(o.attacks,3) then
            tasks.attach(o.events,4)
            o.events[t.slot] = nil
        end
    end
    events[6] = {function(o,t)
        local run = o.run
        t.delay,t.clock,t.reload,t.state,t.pass,t.nextCount,t.bursts = 0x40,0,0x10,1,3,1,2
        t.side,t.mode = s8(program.random(run,program.randomByte)),s8(program.random(run,program.randomByte))
        nextMotion(o,5,0x6800,0x1c00,2)
        tasks.attach(o.aux,6,{h=s16(o.h-0x1400),l=o.l})
        sweeps(o,t)
    end,sweeps}

    local wheelPatterns = {
        {7,0x10,8,{0,0x40,0x80,0xc0}},
        {2,0x20,10,{-1,1,0x7f,0x81}},
        {4,0x10,0x20,{0,2,4,6,8,-2,-4,-6,-8}},
        {1,0xc,1,{0,0x20,0x40,0x60,0x80,0xa0,0xc0,0xe0}},
    }
    local function configureWheel(t)
        local pattern = wheelPatterns[t.pattern+1]
        t.clock,t.count,t.turn,t.speed = pattern[1],pattern[2],t.turn<0 and -pattern[3] or pattern[3],-4
    end

    local function wheel(o,t)
        t.clock = t.clock-1
        if t.clock>=0 then return end
        t.clock = 2
        for _,offset in ipairs(wheelPatterns[t.pattern+1][4]) do
            local a = band(t.angle+offset,255)
            emit(o,13,t.speed,a,program.stage3Heavy.muzzle[floor(band(a+2,0xfc)/4)+1]-0x18000000,true)
        end
        if t.pattern==3 then t.speed=t.speed+2 end
        t.angle,t.count = band(t.angle+t.turn,255),t.count-1
        if t.count<0 then
            local old = t.pattern
            repeat t.pattern=band(program.random(o.run,program.randomByte),3) until t.pattern~=old
            t.turn,t.cycles = -t.turn,t.cycles+1
            configureWheel(t)
            t.clock = 0x10
            if t.cycles==4 then o.attacks[t.slot]=nil end
        end
    end
    attacks[10] = {function(o,t)
        t.pattern,t.cycles,t.angle = 0,0,program.random(o.run,program.randomByte)
        t.turn = program.random(o.run,program.randomByte)>=0x80 and -8 or 8
        configureWheel(t)
        wheel(o,t)
    end,wheel}

    local function mirroredPorts(o,t)
        t.clock = t.clock-1
        if t.clock>=0 then return end
        t.clock = 0xc
        local dh,dl = program.vector(0x80,t.angle)
        local offset = s16(dh*2)*0x10000+band(dl*4,0xffff)
        local aim = program.angle(s16(o.h-0x1800),o.l,o.run.player,0x20)*4
        emit(o,0x15,-6,aim,offset-0x8000000)
        emit(o,0x15,-6,aim,-offset)
        t.angle = band(t.angle+6,255)
    end
    attacks[1] = {function(o,t) t.clock,t.angle=0,0; mirroredPorts(o,t) end,mirroredPorts}

    local function charge(o,t)
        if t.state==0 then
            t.timer = t.timer-1
            if t.timer~=0 then return end
            tasks.stop(o.aux,4)
            tasks.attach(o.attacks,10)
            t.state,t.cadence = 1,0x40
        end
        if o.move and o.move.index==2 and not o.nextMotion then
            local h,l = program.addPacked(0,0,data.chargeTargets[t.destination])
            nextMotion(o,3,h,l,0)
            t.destination = t.destination%4+1
        end
        if t.state==1 then
            if tasks.contains(o.attacks,1) then return end
            t.cadence = t.cadence-1
            if t.cadence>=0 then return end
            tasks.attach(o.attacks,1)
            t.state=2
        end
        if t.state==2 and not tasks.contains(o.attacks,10) then
            tasks.stop(o.attacks,1)
            o.chainVolley = 0
            tasks.attach(o.events,7)
            o.events[t.slot] = nil
        end
    end
    events[4] = {function(o,t)
        t.state,t.timer,t.destination = 0,0x80,1
        nextMotion(o,3,0x4e00,0x1c00,0)
    end,charge}

    local function chainSpiral(o,t)
        if t.state==0 then
            tasks.attach(o.aux,6,{h=0,l=0x1c00})
            o.chainVolley,t.state = 3,1
        end
        if t.state==1 and tasks.contains(o.aux,7) then t.timer,t.state = 0xc0,2 end
        if t.state==2 then
            t.timer = t.timer-1
            if t.timer==0 then o.chainVolley,t.state=4,3 end
        end
        if t.state==3 and o.chainVolley==0 then
            tasks.stop(o.aux,6)
            tasks.stop(o.aux,7)
            tasks.attach(o.aux,4)
            tasks.attach(o.events,5)
            o.events[t.slot] = nil
        end
    end
    events[7] = {function(o,t)
        t.state=0
        nextMotion(o,5,0x6000,0x1c00,2)
        chainSpiral(o,t)
    end,chainSpiral}

    local function crossing(o,t)
        t.clock = t.clock-1
        if t.clock>=0 then return end
        t.clock = 8
        local a = 0x80+t.angle
        emit(o,11,0,a,0xf5fffc00,true)
        emit(o,11,0,-a,0xf5ff0400,true)
        t.angle = t.angle+t.turn
        if t.angle<=0 or t.angle>=0x40 then
            t.angle,t.turn = math.max(0,math.min(0x40,t.angle)),-t.turn
        end
    end
    attacks[6] = {function(o,t) t.clock,t.angle,t.turn=0,0,8; crossing(o,t) end,crossing}

    local function flyers(o,t)
        t.clock = t.clock-1
        if t.clock>=0 then return end
        t.clock = 0x12
        local offset = data.flyerOrigins[t.port]
        if t.side<0 then offset=band(offset,0xffff0000)+band(-offset,0xffff) end
        local h,l = program.addPacked(o.h,o.l,offset)
        local queue = o.run.spawnQueue
        queue[#queue+1] = {0,0,0x6f,0,0,0,0,0,0,0x195f92,h=h,l=l,side=t.side,shots=t.shots,boss=o}
        if t.side<0 then t.port=t.port%3+1 end
        t.side,t.shots,t.count = -t.side,math.min(0xc,t.shots+1),t.count-1
        if t.count==0 then o.attacks[t.slot]=nil end
    end
    attacks[5] = {function(o,t) t.clock,t.port,t.side,t.shots=0,1,1,3; flyers(o,t) end,flyers}

    local function sideFlyers(o,t)
        if t.delay>0 then
            t.delay = t.delay-1
            if t.delay>0 then return end
            tasks.attach(o.attacks,6)
            t.wait,t.state = 0x40,1
        end
        if t.state==1 then
            t.wait = t.wait-1
            if t.wait>0 then return end
            tasks.attach(o.attacks,5,{count=0x10})
            t.state=2
        elseif t.state==2 and not tasks.contains(o.attacks,5) then
            tasks.stop(o.attacks,6)
            t.state,t.wait = 3,0x30
        elseif t.state==3 then
            t.wait = t.wait-1
            if t.wait==0 then
                tasks.attach(o.events,10)
                o.events[t.slot] = nil
            end
        end
    end
    events[8] = {function(o,t)
        t.delay,t.state = 0x30,0
        nextMotion(o,3,0x5c00,0x1c00,3)
        sideFlyers(o,t)
    end,sideFlyers}

    local function doubleOrbit(o,t)
        if t.burst==0 then
            t.clock = t.clock-1
            if t.clock<0 then t.clock,t.burst=6,8 end
        end
        if t.burst>0 then
            t.burst = t.burst-1
            t.flip = not t.flip
            local port = (t.port+0x20+(t.flip and 0x80 or 0))%256
            local a = t.angle+(t.flip and t.spread or -t.spread)
            emit(o,15,6,a,data.finalMuzzles[port+1],true)
            emit(o,15,5,a,data.finalMuzzles[(port+0x40)%256+1],true)
        end
        if t.spread>0xb then t.spread=t.spread-1
        else
            t.turnClock = t.turnClock-1
            if t.turnClock<0 then
                t.turnClock = t.aimed>0 and 1 or 2
                t.angle = band(t.angle+t.turn,255)
                if t.angle==0x9a or t.angle==0x66 then t.turn=-t.turn end
            end
            t.port = t.port+t.portTurn
            if math.abs(t.port)==t.portLimit then
                local delta
                repeat delta=band(program.random(o.run,program.randomByte),1)+1
                until math.abs(t.portTurn)~=1 or delta~=1
                t.portTurn,t.portLimit = t.port<0 and delta or -delta,math.min(t.portLimit+2,0x1c)
            end
        end
        if t.aimed>0 then
            t.aimClock = t.aimClock-1
            if t.aimClock<0 then
                t.aimClock = 0x26
                local a = program.angle8(o.h,o.l,o.run.player,0x80)
                local fan = t.aimed%2==1 and {0,3,6,-3,-6} or {8,24,-8,-24}
                for _,d in ipairs(fan) do emit(o,2,t.speed,a+d,0,true) end
                for _,d in ipairs({0,16,32,-16,-32}) do emit(o,2,t.speed+6,a+d,0,true) end
                t.speed,t.aimed = t.speed+6,t.aimed-1
            end
            return
        end
        if t.groups==0 then
            t.tail = t.tail-1
            if t.tail==0 then o.attacks[t.slot]=nil end
            return
        end
        if t.groupCount==0 then
            t.groupClock = t.groupClock-1
            if t.groupClock>=0 then return end
            t.groupCount,t.groupClock,t.groupGap = 4,0xa,0
        end
        t.groupGap = t.groupGap-1
        if t.groupGap<0 then
            t.groupGap = 0xa
            for _,a in ipairs({0x80,0x8c,0x74}) do emit(o,2,-3,a,data.finalMuzzles[t.port%256+1],true) end
            t.groupCount = t.groupCount-1
            if t.groupCount==0 then t.groups=t.groups-1 end
        end
    end
    attacks[8] = {function(o,t)
        t.clock,t.burst,t.flip,t.angle,t.spread,t.port,t.portTurn,t.portLimit = 0,0,false,0x80,0x60,0,2,2
        t.turnClock,t.turn = 0,s8(program.random(o.run,program.boss2.finalTurn))
        t.aimed,t.aimClock,t.speed,t.groups,t.groupCount,t.groupClock,t.tail = 4,0x20,-12,11,0,4,0x30
        doubleOrbit(o,t)
    end,doubleOrbit}

    local function orbitalAssault(o,t)
        if not t.secondApproach and o.move and o.move.index==2 and not o.nextMotion then
            tasks.attach(o.attacks,8)
            t.secondApproach = true
            nextMotion(o,3,0x5800,0x1c00,1)
        end
        if t.secondApproach and not tasks.contains(o.attacks,8) then
            t.wait = t.wait-1
            if t.wait==0 then
                tasks.attach(o.events,8)
                o.events[t.slot] = nil
            end
        end
    end
    events[10] = {function(o,t)
        t.wait = 0x20
        nextMotion(o,3,0x3000,0x1c00,4)
    end,orbitalAssault}

    local function aimedRing(o,t)
        t.clock = t.clock-1
        if t.clock>=0 then return end
        t.clock = o.run.awakened and 4 or 9
        local player = o.run.player
        if player and player.active then
            for ray=0,31 do
                local offset = data.finalMuzzles[(t.port+ray*8)%256+1]
                local h,l = s16(o.h+floor(offset/0x10000)),s16(o.l+offset)
                local a = band(program.angle8(h,l,player,0x80)+ray*t.spread,255)
                if a>=0x40 and a<=0xc0 then emit(o,t.kind,t.speed,a,offset,true) end
            end
        end
        t.port,t.count = (t.port+t.turn)%256,t.count-1
        if t.count<0 then
            t.spread = -t.spread
            t.count = t.spread<0 and t.reverse or t.forward
            t.cycles = t.cycles-1
            if t.cycles<0 then t.cycles,t.turn=t.cycleReload,-t.turn end
        end
    end
    attacks[11] = {function(o,t)
        local p = data.finalAttack
        t.clock,t.count,t.forward,t.reverse = floor(p[1]/256),p[2],p[3],p[14]
        t.cycles,t.cycleReload,t.kind,t.speed = floor(p[5]/256),band(p[5],255),p[7],s16(p[6])
        t.spread,t.port,t.turn = floor(p[10]/256),p[12]/4,p[13]/4
        if program.random(o.run,program.randomByte)>=0x80 then t.turn=-t.turn end
    end,aimedRing}

    local function finalAssault(o,t)
        if t.arm>0 then
            t.arm = t.arm-1
            if t.arm==0 then tasks.attach(o.attacks,11) end
        end
        if not t.wandering and o.move and o.move.index==2 and not o.nextMotion then
            t.wandering = true
            nextMotion(o,7,0,0,1)
        end
    end
    events[11] = {function(o,t)
        t.arm=0x30
        o.spin=2
        nextMotion(o,3,0x5400,0x1c00,2)
        finalAssault(o,t)
    end,finalAssault}

    return aux,events,attacks
end
