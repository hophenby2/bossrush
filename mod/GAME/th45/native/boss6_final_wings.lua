-- E14：剩余四翼持续各自发弹，中央的成对自机狙与高速墙交替占用发弹窗口。
return function(program,tasks,events,attacks,moveTo,emit)
    local band=require('bit').band
    local floor=math.floor
    local s16=program.s16
    local data=program.boss6
    local left,right=0x0dbff300,0x0dc00d00

    local function aim(o,offset)
        return program.angle8(s16(o.h+floor(offset/0x10000)),s16(o.l+s16(offset)),o.run.player,0x80)
    end

    local function fireFrom(o,kind,speed,angle,mount,spread)
        -- 发射点先做整长字相加，发射器再分别叠加 0x1710be 的两个字。
        local h,l=program.addPacked(o.h,o.l,mount)
        local dh=s16(h-o.h)+floor(spread/0x10000)
        local dl=s16(l-o.l)+s16(spread)
        emit(o,kind,speed,angle,dh*0x10000+band(dl,0xffff))
    end

    local function radial(o,t,kind,speed,angle)
        local direction=floor(band(angle+2,255)/4)+1
        fireFrom(o,kind,speed,angle,t.offset,data.finalWingSweep[direction])
    end

    local function spindle(o,t)
        t.clock=t.clock-1
        if t.clock>=0 then return end
        t.clock=0x1c
        local first,last=0x30,0xd0
        if o.finalSweep then first,last=0x50,0xb0 end
        for half=0,1 do
            for i=0,5 do
                local angle=band(t.angle+0x80*half+3*i,255)
                if angle>=first and angle<last then radial(o,t,0xf,-6,angle) end
            end
        end
        t.angle=t.angle+t.turn
    end
    local function startSpindle(o,t)
        local run=o.run
        local turn=9+floor(program.s8(program.random(run,program.randomNarrow))/2)
        if band(program.random(run,program.randomByte),1)==0 then turn=-turn end
        program.nextRandom(run)
        program.nextRandom(run)
        program.nextRandom(run)
        t.clock,t.angle,t.turn=0,aim(o,t.offset),turn
        spindle(o,t)
    end
    attacks[17]={startSpindle,spindle}
    attacks[18]=attacks[17]

    local function pair(o,t)
        if t.remaining==0 then
            t.clock=t.clock-1
            if t.clock>=0 then return end
            t.remaining=t.count
            t.count,t.clock,t.reload=t.count+3,t.reload,math.max(0x30,t.reload-4)
            t.left,t.right=aim(o,left),aim(o,right)
        end
        t.interval=t.interval-1
        if t.interval>=0 then return end
        t.interval=4
        for _,port in ipairs({{left,t.left},{right,t.right}}) do
            local offset=program.mid1.ringOffsets[floor(band(port[2]+2,255)/4)+1]
            fireFrom(o,0xe,4,port[2],port[1],offset)
        end
        t.remaining=t.remaining-1
        if t.remaining==0 then
            t.rounds=t.rounds-1
            if t.rounds==0 then o.attacks[t.slot]=nil end
        end
    end
    attacks[19]={function(o,t)
        t.clock,t.reload,t.count,t.remaining,t.interval,t.rounds=0,0x40,4,0,0,3
        pair(o,t)
    end,pair}

    local function wingStar(o,t)
        t.clock=t.clock-1
        if t.clock>=0 then return end
        t.clock=11
        local axis=t.turn>0 and 0x55 or -0x55
        for _,delta in ipairs({0,axis-4,axis+4,2*axis+4,2*axis-2,2*axis+10}) do
            local angle=band(t.angle+delta,255)
            if not o.finalSweep or angle<0x50 or angle>=0xb0 then radial(o,t,0x19,-5,angle) end
        end
        t.angle=t.angle+t.turn
    end
    local function startWingStar(o,t)
        t.clock,t.angle=0,program.random(o.run,program.randomByte)
        local turn=1+program.random(o.run,data.finalWingTurns,63)
        t.turn=t.turn+(t.turn<0 and -turn or turn)
        wingStar(o,t)
    end
    attacks[20]={startWingStar,wingStar}
    attacks[21]=attacks[20]

    local function wall(o,t)
        t.clock=t.clock-1
        if t.clock>=0 then return end
        t.clock=2
        local interval=floor((t.width-8)/2)+2
        for _,side in ipairs({1,-1}) do
            for i=0,3 do emit(o,0xe,0x24+2*i,t.angle+side*(t.width+interval*i),0) end
        end
        t.width=math.max(8,t.width-1)
        if t.width~=8 then return end
        t.count=t.count-1
        if t.count==0 then o.attacks[t.slot],o.finalSweep=nil,false end
    end
    attacks[22]={function(o,t)
        program.nextRandom(o.run)
        t.angle,t.clock,t.width,t.count=aim(o,0),0,0x40,0x10
        o.finalSweep=true
        wall(o,t)
    end,wall}

    local function animateCharge(o,t)
        if t.startCharge then
            t.startCharge=false
            o.armorCharge,t.chargeClock,t.chargeExit=1,0,false
            program.nextRandom(o.run)
        end
        if not o.armorCharge then return end
        t.chargeClock=t.chargeClock-1
        if t.chargeClock>=0 then return end
        t.chargeClock=1
        o.armorCharge=o.armorCharge+1
        if t.chargeExit then
            if o.armorCharge>=29 then o.armorCharge=nil end
        elseif o.armorCharge>=20 then o.armorCharge=12 end
    end

    local function wings(o,t)
        animateCharge(o,t)
        if t.phase==0 then
            t.clock=t.clock-1
            if t.clock>0 then return end
            t.phase,t.clock=1,0x60
            o.protected=false
            tasks.attach(o.attacks,20,{offset=0x057ff040,turn=-1})
            tasks.attach(o.attacks,21,{offset=0x05800fc0,turn=1})
        end
        if t.phase==1 and not o.armorCharge then
            t.clock=t.clock-1
            if t.clock<0 then
                tasks.attach(o.attacks,19)
                t.phase,t.clock=2,0x40
            end
        end
        if t.phase==2 and not tasks.contains(o.attacks,19) then
            t.clock=t.clock-1
            if t.clock==0 then
                t.startCharge=true
                t.phase,t.clock=3,0x20
            end
        end
        if t.phase==3 then
            t.clock=t.clock-1
            if t.clock==0 then
                tasks.attach(o.attacks,22)
                t.phase,t.clock=4,0x40
            end
        end
        if t.phase==4 and not tasks.contains(o.attacks,22) then
            t.clock=t.clock-1
            if t.clock==0 then
                t.chargeExit,t.phase,t.clock=true,1,0x20
            end
        end
        t.leftClock,t.rightClock=t.leftClock-1,t.rightClock-1
        if t.leftClock<0 then
            if not tasks.contains(o.attacks,17) then tasks.attach(o.attacks,17,{offset=left}) end
            t.leftClock=0x10
        end
        if t.rightClock<0 then
            if not tasks.contains(o.attacks,18) then tasks.attach(o.attacks,18,{offset=right}) end
            t.rightClock=0x10
        end
    end

    events[14]={function(o,t)
        o.run.bulletCapacity=190
        o.armorCharge,o.finalSweep=nil,false
        o.recoil,o.recoilAngle=0x10,program.random(o.run,program.randomNarrow)
        moveTo(o,0x5000,0x1c00,1)
        t.phase,t.clock,t.leftClock,t.rightClock=0,107,0x10,0x60
    end,wings}
end
