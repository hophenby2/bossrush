-- 0x1bcc00 的首轮由六处炮口组成。转向阶段的两个扇形任务各自持有弹速和时钟。
return function(program,bullets,tasks)
    local band=require('bit').band
    local floor,s16=math.floor,program.s16
    local H={}
    local data=program.boss5
    local muzzle=program.mid2.muzzle0

    local function port(table,angle)
        return table[floor(band(angle+2,0xfc)/4)+1]
    end

    local function direct(o,kind,modifier,angle,shift)
        bullets.emit(o,kind,modifier,angle,s16(floor(shift/0x10000)),s16(shift),true)
    end

    local function emit(o,kind,modifier,angle,offset,ports)
        direct(o,kind,modifier,angle,offset+port(ports or muzzle,angle))
    end

    H[0]={function(o,t)
        t.clock,t.gap,t.count,t.modifier=0x40,0x10-o.repeatCadence,0x19+o.repeatShots,-6+o.repeatSpeed
        t.angle,t.turn=0x80,band(program.random(o.run,program.randomByte),0x80)==0 and 8 or -8
    end,function(o,t)
        t.clock=t.clock-1
        if t.clock>=0 then return end
        t.clock=t.gap
        for i,row in ipairs(data.firstPorts) do
            local angle=row[1]+(i<=3 and -t.angle or t.angle)
            for delta=-0x10,0x10,0x10 do emit(o,13,t.modifier,angle+delta,row[2]) end
        end
        t.angle=t.angle+t.turn
        if t.angle>=0x90 or t.angle<=0x60 then t.turn=-t.turn end
        t.count=t.count-1
        if t.count>=0 then return end
        o.repeatShots=math.min(0x10,o.repeatShots+8)
        o.repeatSpeed=math.min(3,o.repeatSpeed+1)
        o.repeatCadence=math.min(4,o.repeatCadence+2)
        tasks.stop(o.attacks,0)
    end}

    local function arc(kind,delay,reload,volleys,base,speed,stepAngle,turn,shots,deltaSpeed)
        local function step(o,t)
            t.clock=t.clock-1
            if t.clock>=0 then return end
            t.clock=reload
            local offset=port(data.arcPorts,t.angle)
            for i=0,shots-1 do emit(o,kind,speed+deltaSpeed*i,t.angle+stepAngle*i,offset) end
            t.angle=(t.angle+turn)%256
            t.remaining=t.remaining-1
            if t.remaining==0 then o.attacks[t.slot]=nil end
        end
        return {function(o,t)
            t.clock,t.remaining,t.angle=delay,volleys,base+program.random(o.run,program.randomNarrow)
            step(o,t)
        end,step}
    end

    H[1]=arc(0x19,0x60,2,18,0xc0,-2,9,-9,6,3)
    H[2]=arc(0x1a,0x20,1,24,0x40,2,-14,7,8,4)

    local function detachedShot(o,kind,speed,angle)
        local p=o.extraParts[4]
        local offset=0x6000000+port(program.boss1Core.satelliteMuzzles,angle)
        local h,l=program.addPacked(p.h,p.l,offset)
        bullets.emit(o,kind,speed,angle,s16(h-o.h),s16(l-o.l),true)
    end

    -- 0x1bd038 的六个子状态共用同一部件，两组四向弹之间错开 0x20。
    local function detachedStep(o,t)
        if not o.detached then o.attacks[t.slot]=nil; return end
        t.clock=t.clock-1
        if t.clock>=0 then return end
        t.clock=2
        local phase,angle=t.phase,t.angle
        if phase==0 then
            detachedShot(o,0xe,14,angle)
            detachedShot(o,0xe,14,-angle)
            detachedShot(o,0xe,14,angle*3)
            detachedShot(o,0xe,14,-angle*3)
            t.angle=t.angle+1
            if t.angle==0x20 then t.phase=1 end
            return
        end
        for i=0,3 do detachedShot(o,0xe,14,angle+0x40*i) end
        if phase>=3 then
            for i=0,3 do detachedShot(o,0xe,t.inner,angle+0x20+0x40*i) end
            t.inner=math.min(14,t.inner+1)
        end
        if phase==2 or phase==4 then
            t.bridge=t.bridge-1
            if t.bridge<0 then t.phase,t.bridge=phase+1,20 end
            return
        end
        local delta=t.turn
        if t.volley%2==1 then
            if phase==3 then delta=delta*2
            elseif phase==5 then delta=delta+floor(delta/2) end
        end
        t.angle=t.angle+delta
        if t.volley==11 then
            for i=-2,2 do
                for j=0,2 do detachedShot(o,0xb,-12,t.burst+i*3+j*0x55) end
            end
            t.burst=t.burst+t.burstTurn
        end
        t.volley=t.volley-1
        if t.volley>=0 then return end
        t.volley,t.rounds=11,t.rounds-1
        if t.rounds>=0 then return end
        t.rounds,t.turn,t.burstTurn=18,-t.turn,-t.burstTurn
        t.burstTurn=t.burstTurn+(t.burstTurn<0 and -1 or 1)
        if phase==1 then t.phase=2 end
        if phase==3 then
            t.phase,t.bridge=4,10
            t.turn=t.turn+(t.turn<0 and -1 or 1)
        end
        t.cycles=t.cycles-1
        if t.cycles<0 then
            o.attacks[t.slot]=nil
            o.breakPart(o)
        end
    end

    H[3]={function(o,t)
        t.clock,t.phase,t.angle,t.turn,t.burstTurn=0x10,0,0,1,-15
        t.volley,t.rounds,t.cycles,t.bridge,t.inner=11,26,2,20,-8
        if program.random(o.run,program.randomByte)>=0x80 then t.turn,t.burstTurn=-1,15 end
        t.burst=program.random(o.run,program.randomByte)
        o.partWaveStopped=true
        detachedStep(o,t)
    end,detachedStep}

    local function hatchStep(o,t)
        t.clock=t.clock-1
        if t.clock>=0 then return end
        t.clock=3
        local used=2-t.volley
        if used==0 then
            local target=o.run.player
            if not target or not target.active then return end
            t.angle=program.angle8(o.h-0x600,o.l,target,t.angle)
        end
        local spread=data.hatchSpread[t.rounds+1]
        local angle=t.angle-spread[1]+used*t.turn
        for i=0,8 do
            emit(o,0xd,t.modifier+used*3,angle+i*spread[2],-0x6000000,program.stage3Heavy.muzzle)
        end
        t.volley=t.volley-1
        if t.volley>=0 then return end
        t.clock,t.volley,t.turn=2,2,-t.turn
        if t.rounds%2==1 then t.baseSpeed=t.baseSpeed+1 end
        t.modifier,t.rounds=t.baseSpeed,t.rounds-1
        if t.rounds<0 then o.attacks[t.slot]=nil end
    end

    H[4]={function(o,t)
        t.clock,t.volley,t.rounds,t.modifier,t.baseSpeed,t.angle=0x10,2,37,4,8,0
        t.turn=program.random(o.run,program.randomByte)>=0x80 and -1 or 1
        hatchStep(o,t)
    end,hatchStep}

    -- 0x1bdafc 按右前、右后、左前、左后的顺序试射。耐久下限会打开全部炮口。
    local rightPorts={{6,0x06c00580},{4,0x0c000a00},{0,0x11001000},{2,0x12801500}}
    local leftPorts={{5,0x06c0fa80},{3,0x0c00f600},{-1,0x1100f000},{1,0x1280eb00}}
    local function sweep(o,t,ports,angles,right)
        for i,row in ipairs(ports) do
            local angle=band(angles[i],0xff)
            if t.ports>row[1] then
                if right and i==2 then
                    if angle>=0xc0 then direct(o,0xf,t.modifier+(angle>=0xd0 and 0x10 or 0),angle,row[2]) end
                elseif angle>0x40 and angle<0xc0 then direct(o,0xf,t.modifier,angle,row[2]) end
            end
        end
    end

    H[5]={function(o,t)
        t.clock,t.ports,t.modifier,t.openClock=0x10,0,0,0xe
        t.a,t.b,t.da,t.db=0x80,0x80,3,-4
        if program.random(o.run,program.randomByte)>=0x80 then t.da=-t.da end
        repeat until program.random(o.run,program.randomByte)>=0x80
    end,function(o,t)
        t.clock=t.clock-1
        if t.clock>=0 then return end
        for n=0,0x80,0x80 do
            local a,b=t.a+n,t.b+n
            sweep(o,t,rightPorts,{a-32,64-a,b-32,64-b},n==0)
        end
        for n=0,0x80,0x80 do
            local a,b=t.a+n,t.b+n
            sweep(o,t,leftPorts,{-a-32,a,-b-32,b},false)
        end
        t.clock=o.run.halfPathSpeed and 3 or 8
        t.a,t.b=band(t.a+t.da,255),band(t.b+t.db,255)
        if t.ports>=7 then return end
        if o.counters[2]<=0x10e66 then t.ports,t.modifier=7,-8; return end
        t.openClock=t.openClock-1
        if t.openClock<0 then
            t.openClock,t.ports,t.modifier=0xe,t.ports+1,math.max(-8,t.modifier-1)
        end
    end}

    local function aimedFan(o,kind,modifier,angle,count,step)
        local first=angle-floor(count/2)*step
        for i=0,count-1 do
            emit(o,kind,modifier,first+i*step,-0x6000000,program.stage3Heavy.muzzle)
        end
    end

    local function aimedStep(o,t)
        t.clock=t.clock-1
        if t.clock>=0 then return end
        t.clock=3
        local target=o.run.player
        if not target or not target.active then return end
        local angle=program.angle8(o.h-0x600,o.l,target,t.angle)
        t.angle,t.clock=angle,0x80
        aimedFan(o,0x1f,t.modifier,angle,13,10)
        if t.modifier>=4 then aimedFan(o,0x1f,-2,angle,9,6) end
        if t.modifier>=9 then aimedFan(o,0x1f,-9,angle,7,3) end
        if t.modifier<9 then t.modifier=t.modifier+3 end
    end

    H[6]={function(o,t)
        t.clock,t.modifier,t.angle=0x20,-1,0
        aimedStep(o,t)
    end,aimedStep}

    return H
end
