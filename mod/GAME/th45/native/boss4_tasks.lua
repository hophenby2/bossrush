-- 0x199f56 和 0x19a3aa 分别挂载部件与阶段事件。退回任务槽后再登记下一段。
return function(program,effects,tasks,cannon)
    local band=require('bit').band
    local floor,min,max=math.floor,math.min,math.max
    local s16=program.s16
    local data=program.boss4
    local aux,events={},{}
    local attach,contains,stop=tasks.attach,tasks.contains,tasks.stop

    local function clock(t,key,reload)
        t[key]=t[key]-1
        if t[key]>=0 then return false end
        t[key]=reload
        return true
    end

    local function entry(init,step)
        return {function(o,t) init(o,t); step(o,t) end,step}
    end

    local function transition(o,t,index)
        attach(o.events,index)
        o.events[t.slot]=nil
    end

    local function motion(o,index,h,travel)
        o.nextMotion={index=index,center=h,travel=travel}
    end

    local function followRear(o)
        o.rear.h=s16(o.rear.h+o.deltaH)
    end

    local function burst(o,rows,h,l)
        local origin={run=o.run,h=h,l=l}
        for _,row in ipairs(rows) do
            effects.emit(origin,row[1],row[3],row[4]+program.random(o.run,program.randomNarrow),row[2],false,row[5])
        end
    end

    local brokenOffsets={0xd800f100,0xd8001000,0xf7fff200,0xf8000f00}
    local brokenEffects={data.lowerLeftBreak,data.lowerRightBreak,data.upperLeftBreak,data.upperRightBreak}
    local function breakFront(o)
        for index,offset in ipairs(brokenOffsets) do
            o.broken[index]=true
            o.extraParts[index].flags=0x8000
            local h,l=program.addPacked(o.h,o.l,offset)
            burst(o,brokenEffects[index],h,l)
            attach(o.aux,11+index,{offset=offset})
        end
    end

    aux[0]=entry(function(_,t) t.clock=0 end,function(o,t)
        o.rearRotor=(o.rearRotor+1)%16
        if clock(t,'clock',1) then o.frontRotor=(o.frontRotor+1)%16 end
    end)

    aux[1]={function(o) o.engineOffset=0xc0 end,function() end}

    aux[2]=entry(function(_,t) t.clock=0x10 end,function(o,t)
        if clock(t,'clock',1) then o.rearHatch=min(7,o.rearHatch+1) end
        o.rearCoreOffset=min(0xc00,o.rearCoreOffset+0x20)
        if o.rearHatch==7 and o.rearCoreOffset==0xc00 then o.aux[t.slot]=nil end
    end)

    aux[3]=entry(function(_,t) t.clock=0 end,function(o,t)
        if clock(t,'clock',1) then o.rearHatch=max(0,o.rearHatch-1) end
        o.rearCoreOffset=max(0,o.rearCoreOffset-0x40)
        if o.rearHatch==0 and o.rearCoreOffset==0 then o.aux[t.slot]=nil end
    end)

    local function shiftFront(o,t)
        if not clock(t,'clock',2) then return end
        local direction=t.index==4 and 1 or -1
        o.hatchFrame=o.hatchFrame+direction
        for i=1,4 do
            local part,side=o.extraParts[i],i%2==1 and 'left' or 'right'
            part[side]=part[side]+direction*0x80
        end
        if o.hatchFrame==7 or o.hatchFrame==0 then o.aux[t.slot]=nil end
    end
    aux[4]=entry(function(_,t) t.clock=0 end,shiftFront)
    aux[5]=aux[4]
    local function shiftEngine(o,t)
        if not clock(t,'clock',1) then return end
        o.engineFrame=o.engineFrame+(t.index==6 and 1 or -1)
        if o.engineFrame==0 or o.engineFrame==15 then o.aux[t.slot]=nil end
    end
    aux[6]=entry(function(_,t) t.clock=0 end,shiftEngine)
    aux[7]=aux[6]
    local function liftFront(o,t)
        o.frontRaise=o.frontRaise+(t.index==8 and 0x40 or -0x40)
        if o.frontRaise==0 or o.frontRaise==0x400 then o.aux[t.slot]=nil end
    end
    aux[8]={liftFront,liftFront}
    aux[9]=aux[8]

    local function rearSpan(o,t)
        local delta=t.index==10 and 0x20 or -0x20
        local left,right=o.extraParts[6],o.extraParts[7]
        left.left,right.right=left.left+delta,right.right+delta
        o.rearSpan=o.rearSpan+delta
        if o.rearSpan==0 or o.rearSpan==0x400 then o.aux[t.slot]=nil end
    end
    aux[10]={rearSpan,rearSpan}
    aux[11]={rearSpan,rearSpan}

    for index=12,15 do
        aux[index]=entry(function(_,t) t.clock,t.count=0,6 end,function(o,t)
            if not clock(t,'clock',4) then return end
            local h,l=program.addPacked(o.h,o.l,t.offset)
            h=s16(h+floor(data.randomOffset[program.nextRandom(o.run,0x7f)]/2))
            l=s16(l+floor(data.randomOffset[program.nextRandom(o.run,0x7f)]/2))
            local speed=6+band(program.random(o.run,program.randomByte),15)
            local angle=0x80+4*program.random(o.run,program.randomNarrow)
            effects.emit({run=o.run,h=h,l=l},0x8b,speed,angle,0)
            t.count=t.count-1
            if t.count==0 then o.aux[t.slot]=nil end
        end)
    end

    aux[16]=entry(function(o,t)
        o.glow=true
        for i=1,4 do o.glowFrame[i]=band(program.random(o.run,program.randomByte),7) end
        t.clocks={0,1,1,0}
    end,function(o,t)
        for index=1,4 do
            t.clocks[index]=t.clocks[index]-1
            if t.clocks[index]<0 then
                o.glowFrame[index]=(o.glowFrame[index]+1)%8
                t.clocks[index]=(index==2 or index==3) and 1 or 0
            end
        end
    end)

    local function aim(o)
        if o.lockAim then return end
        for index,offset in ipairs(cannon) do
            local h,l=s16(o.h+floor(offset/0x10000)),s16(o.l+offset)
            o.gunAim[index]=program.angle8(h,l,o.run.player,0x80)
        end
    end
    aux[17]={aim,aim}

    events[0]=entry(function(o)
        attach(o.aux,0)
        attach(o.aux,1)
        o.crossingVariant=band(program.random(o.run,program.randomByte),1)
    end,function(o,t)
        motion(o,0)
        o.events[t.slot]=nil
    end)

    events[1]=entry(function(o,t)
        t.phase,t.delay,t.smokeClock,t.smoke,t.sound=0,0x80,0x10,1,0
        o.sideMode,o.sideMotion,o.sideTarget=2,nil,0x1c00
        motion(o,11)
    end,function(o,t)
        followRear(o)
        if t.phase==0 then
            if clock(t,'sound',8) then program.random(o.run,program.randomByte) end
            if clock(t,'smokeClock',4) then
                local row=data.separationSmoke[t.smoke]
                t.smoke=t.smoke%#data.separationSmoke+1
                local dh=data.randomOffset[program.nextRandom(o.run,0x7f)]
                local dl=floor(data.randomOffset[program.nextRandom(o.run,0x7f)]/2)
                local angle=row[4]+program.random(o.run,program.randomNarrow)
                effects.emit(o,row[1],row[3],angle,(dh-0x1900)*0x10000+band(dl,0xffff))
            end
            t.delay=t.delay-1
            if t.delay==0 then t.phase,t.delay=1,0x28 end
        end
        if t.phase==1 then
            t.delay=t.delay-1
            if t.delay==0 then
                burst(o,data.separationBurst,s16(o.h-0x1e00),o.l)
                t.phase,t.delay=2,0x10
            end
        end
        if t.phase==2 then
            t.delay=t.delay-1
            if t.delay==0 then
                o.frontVisible=false
                t.phase=3
                motion(o,12)
            end
        end
        if t.phase==3 and o.move and o.move.index==8 then
            o.protected=false
            o.extraParts[6].hp,o.extraParts[7].hp=0x5000,0x5000
            transition(o,t,9)
        end
    end)

    events[2]=entry(function(o)
        o.protected=false
        burst(o,data.rearBreakBlast,o.rear.h,o.rear.l)
    end,function(o,t)
        transition(o,t,12)
    end)

    -- 0x19a71c 循环三个爆点，舰身隐去后再推进最后一批爆炸。
    events[3]=entry(function(o,t)
        t.phase,t.delay,t.clock,t.sound,t.port,t.count=0,0,0x20,5,1,10
        motion(o,1)
    end,function(o,t)
        followRear(o)
        if t.phase==0 then
            burst(o,data.rearBreakBlast,o.rear.h,o.rear.l)
            t.phase,t.delay=1,0x10
        elseif t.phase==1 then
            if t.delay>0 then
                t.delay=t.delay-1
                if t.delay>0 then return end
            end
            if clock(t,'sound',5) then program.random(o.run,program.randomByte) end
            if not clock(t,'clock',0x10) then return end
            local h,l=program.addPacked(o.rear.h,o.rear.l,data.defeatOffsets[t.port])
            burst(o,data.separationBurst,h,l)
            t.port,t.count=t.port%#data.defeatOffsets+1,t.count-1
            if t.count==0 then
                o.rearVisible=false
                t.phase,t.delay=2,9
            end
        else
            t.delay=t.delay-1
            if t.delay>0 then return end
            if t.phase==2 then
                t.phase,t.delay=3,8
            elseif t.phase==3 then
                local h=s16(o.rear.h+0x3000)
                effects.emitSequence({run=o.run,h=h,l=o.rear.l},program.boss3.finalBlast)
                t.phase,t.delay=4,0x80
            else
                o.finished=true
                o.events[t.slot]=nil
            end
        end
    end)

    events[4]=entry(function(o,t)
        motion(o,8,0x7a00,0x200)
        o.sideMode=1
        t.phase,t.delay,t.wait,t.groups,t.bursts=0,0x40,0x40,2,3
    end,function(o,t)
        followRear(o)
        if t.phase==0 then
            t.delay=t.delay-1
            if t.delay==0 then
                t.phase,o.lockAim=1,true
                attach(o.attacks,2)
                attach(o.attacks,5)
            end
        end
        if t.phase==1 and not contains(o.attacks,1) and clock(t,'wait',0x40) then
            attach(o.attacks,1,{bursts=t.bursts})
            t.groups,t.bursts=t.groups-1,t.bursts+3
            if t.groups==0 then t.phase=2 end
        end
        if t.phase==2 and not contains(o.attacks,1) then
            stop(o.attacks,2)
            stop(o.attacks,5)
            o.lockAim=false
            attach(o.attacks,3)
            t.phase,t.delay=3,0x20
        end
        if t.phase==3 and not contains(o.attacks,3) then
            if t.reverse==nil then
                t.reverse=band(program.random(o.run,program.randomByte),1)==0
                o.sideMode,o.sideTarget=2,t.reverse and 0x2a00 or 0xe00
            end
            t.delay=t.delay-1
            if t.delay==0 then
                t.phase=4
                attach(o.attacks,4,{reverse=t.reverse})
            end
        end
        if t.phase==4 and not contains(o.attacks,4) then
            attach(o.aux,4)
            t.phase=5
        end
        if t.phase==5 and not contains(o.aux,4) then transition(o,t,5) end
    end)

    events[5]=entry(function(o,t)
        t.phase,t.delay=0,0xa8
        attach(o.attacks,7)
        attach(o.attacks,8)
        attach(o.attacks,9)
        o.lockAim=true
    end,function(o,t)
        if t.phase==0 then
            followRear(o)
            if o.sideMode==0 then t.phase=1; motion(o,9) end
        end
        if t.phase==1 then
            followRear(o)
            t.delay=t.delay-1
            if t.delay==0 then t.phase=2 end
        end
        if t.phase==2 then
            if not t.open and o.h<=0x2000 then t.open=true; attach(o.aux,6) end
            if o.move and o.move.index==8 then
                followRear(o)
                for index=7,9 do stop(o.attacks,index) end
                attach(o.aux,5)
                attach(o.aux,8)
                o.lockAim=false
                transition(o,t,8)
            end
        end
    end)

    -- 0x19ad60 先让船首追上后舱。回程发弹停止后才放行沿翼侧散布的子机。
    events[7]=entry(function(o,t)
        t.phase=0
        motion(o,10)
        for _,index in ipairs({14,15,12}) do attach(o.attacks,index) end
    end,function(o,t)
        if t.followRear or band(o.rear.h-o.h,0xffff)<0x1000 then
            followRear(o)
            t.followRear=true
        end
        if t.phase==0 and not o.nextMotion and o.move and o.move.index==8 then
            for _,index in ipairs({12,14,15}) do stop(o.attacks,index) end
            t.phase,t.delay=1,0x34
        end
        if t.phase==1 then
            t.delay=t.delay-1
            if t.delay==0 then
                local aim=program.angle(o.h,o.l,o.run.player,0x20)
                o.returnDroneDirection=aim<0x20 and 0x10 or 0x30
                attach(o.aux,9)
                t.phase,t.delay=2,0x60
            end
        end
        if t.phase==2 then
            t.delay=t.delay-1
            if t.delay==0 then transition(o,t,4) end
        end
    end)

    events[8]=entry(function(o)
        attach(o.attacks,6)
        attach(o.attacks,16+o.crossingVariant)
        o.crossingVariant=1-o.crossingVariant
        o.sideMode,o.sideTarget=2,o.l>=0x1c00 and 0xe00 or 0x2a00
    end,function(o,t)
        followRear(o)
        if o.sideMode==0 then
            for _,index in ipairs({6,16,17,11}) do stop(o.attacks,index) end
            attach(o.aux,7)
            transition(o,t,7)
        end
    end)

    events[9]=entry(function(o,t)
        motion(o,8,0x6400,0x200)
        o.sideMode=1
        t.phase,t.delay=10,0x80
        attach(o.aux,10)
    end,function(o,t)
        followRear(o)
        if t.phase==10 and not contains(o.aux,10) then
            t.phase=0
            attach(o.attacks,19)
        end
        if t.phase==0 then
            t.delay=t.delay-1
            if t.delay==0 then
                t.phase,t.delay=1,0x40
                attach(o.attacks,20)
            end
        end
        if t.phase==1 then
            t.delay=t.delay-1
            if t.delay==0 then
                attach(o.aux,2)
                t.phase,t.delay=2,0x10
            end
        end
        if t.phase==2 and not contains(o.aux,2) then
            t.delay=t.delay-1
            if t.delay==0 then
                stop(o.attacks,20)
                attach(o.attacks,21)
                t.phase=3
            end
        end
        if t.phase==3 and not contains(o.attacks,21) then
            attach(o.aux,3)
            stop(o.attacks,19)
            t.phase=4
        end
        if t.phase==4 and not contains(o.aux,3) then
            attach(o.aux,11)
            transition(o,t,10)
        end
    end)

    events[10]=entry(function(o,t)
        o.sideMode=1
        motion(o,13)
        t.phase,t.delay=0,0x60
    end,function(o,t)
        followRear(o)
        if t.phase==0 then
            t.delay=t.delay-1
            if t.delay==0 then
                attach(o.attacks,22)
                t.phase=1
            end
        end
        if t.phase==1 and not contains(o.attacks,22) then
            motion(o,8,0x6400,0x200)
            transition(o,t,11)
        end
    end)

    events[11]=entry(function(o,t)
        o.sideMode,t.phase=1,0
        attach(o.aux,10)
    end,function(o,t)
        followRear(o)
        if t.phase==0 and not contains(o.aux,10) then
            attach(o.aux,2)
            t.phase=1
        end
        if t.phase==1 and not contains(o.aux,2) then
            attach(o.attacks,18)
            t.phase=2
        end
        if t.phase==2 and not contains(o.attacks,18) and not contains(o.attacks,24) then
            attach(o.aux,3)
            attach(o.aux,11)
            t.phase,t.delay=3,0xc0
        end
        if t.phase==3 then
            t.delay=t.delay-1
            if t.delay==0 then transition(o,t,9) end
        end
    end)

    events[12]=entry(function(_,t)
        t.phase,t.delay=0,0x40
    end,function(o,t)
        followRear(o)
        if t.phase==0 then
            t.delay=t.delay-1
            if t.delay==0 then
                o.protected=false
                local rear=o.rear
                local queue=o.run.spawnQueue
                queue[#queue+1]={[3]=0x79,[4]=0,[10]=0x19ea9e,owner=o,h=rear.h,l=rear.l}
                motion(o,13)
                attach(o.attacks,23)
                t.phase=1
            end
        elseif t.phase==1 and o.move and o.move.index==8 then
            motion(o,8,0x5000,0x200)
            t.phase=2
        end
    end)

    aux.breakFront=breakFront
    return aux,events
end
