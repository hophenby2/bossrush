-- 0x1ac35e 轮流打开六片舱盖。0x1aa65a 按硬件部件槽依次放出十二架子机。
return function(program,bullets,effects,art)
    local band=require('bit').band
    local floor,abs=math.floor,math.abs
    local s16,s8=program.s16,program.s8
    local data=program.boss6
    local Ring,Node={parts=13},{parts=1}

    local function deploy(o,t)
        local frames=o.coverFrames
        local finished=true
        for index,frame in ipairs(frames) do
            if frame~=t.target then
                t.clocks[index]=t.clocks[index]-1
                if t.clocks[index]<0 then
                    t.clocks[index],frames[index]=1,frame+t.direction
                end
                if frames[index]~=t.target then finished=false end
            end
        end
        if finished then o.aux[t.slot]=nil end
    end

    local function coverHandler(open)
        return {function(o,t)
            t.target,t.direction=open and 15 or 0,open and 1 or -1
            t.clocks=open and {0,4,8,0,4,8} or {8,4,0,8,4,0}
            deploy(o,t)
        end,deploy}
    end

    function Ring.install(tasks,events,aux)
        aux[2],aux[3]=coverHandler(true),coverHandler(false)
        local function schedule(o,t)
            if t.phase==0 and not tasks.contains(o.aux,3) then
                t.clock=t.clock-1
                if t.clock<0 then t.phase=1; tasks.attach(o.aux,2) end
            end
            if t.phase==1 and not tasks.contains(o.aux,2) then
                local queue=o.run.spawnQueue
                queue[#queue+1]={[3]=0x47,[4]=0,[10]=0x1aa65a,h=s16(o.h-0x800),l=o.l,
                    turn=s8(program.random(o.run,data.signs)),mode=data.ringModes[t.mode],speed=t.speed}
                t.mode=t.mode%#data.ringModes+1
                t.phase,t.clock=2,0x10
            end
            if t.phase==2 then
                t.clock=t.clock-1
                if t.clock<0 then
                    tasks.attach(o.aux,3)
                    t.phase,t.clock=0,t.period
                    t.speed,t.period=math.min(7,t.speed+3),math.max(0,t.period-0x40)
                end
            end
        end
        events[5]={function(o,t)
            program.random(o.run,data.signs)
            t.phase,t.clock,t.mode,t.speed,t.period=0,0x10,1,2,0x80
            schedule(o,t)
        end,schedule}
    end

    local function rotate(o,r)
        local sx,cx=unpack(data.rotation[r.angle+1])
        local sy,cy=unpack(data.rotation[r.tilt+1])
        local sz,cz=unpack(data.rotation[0xa8+1])
        for _,p in ipairs(r.points) do
            p.clock=p.clock-1
            if p.clock<0 then p.radius,p.clock=p.radius+1,0x12 end
            local x,y=unpack(data.rotation[p.angle+1])
            x,y=x*p.radius,y*p.radius
            x,y=floor((cx*x-sx*y)/64),floor((sx*x+cx*y)/64)
            local z=floor(sy*y/64)
            y=floor(cy*y/64)
            x,z=floor((cz*x+sz*z)/64),floor((cz*z-sz*x)/64)
            p.h,p.l,p.depth=s16(o.h+x),s16(o.l+y),z
        end
    end

    function Ring.init(o)
        local row=o.row
        o.h,o.l,o.flags,o.speed=row.h,row.l,0x8000,row.speed
        local order=s8(program.random(o.run,data.signs))
        o.ring={points={},turn=row.turn,mode=row.mode,order=order,angle=0,tilt=0,
            wave=program.random(o.run,program.randomByte),spawnClock=0,unallocated=12}
        o.extraParts=o.ring.points
        for i=1,12 do o.extraParts[i]={flags=0x8000,active=true,angle=(i-1)*0x15,radius=0x48,clock=0} end
        rotate(o,o.ring)
        return true
    end

    local function releaseNode(o,r)
        r.spawnClock=r.spawnClock-1
        if r.spawnClock>=0 then return end
        r.spawnClock,r.unallocated=2,r.unallocated-1
        local index=r.order<0 and r.unallocated+1 or 12-r.unallocated
        local boss=o.run.boss6
        local h,l=program.addPacked(boss.h,boss.l,data.ringOffsets[index])
        local queue=o.run.spawnQueue
        queue[#queue+1]={[3]=0x49,[4]=0,[10]=0x1ab12a,h=h,l=l,point=r.points[index],ring=r}
    end

    local function snapshotAngles(r)
        for _,p in ipairs(r.points) do p.fireAngle=p.angle end
    end

    local function volleys(r)
        r.fire=false
        if r.unallocated>0 then return end
        if not r.fireClock then
            if r.mode==1 then
                r.fireClock,r.modifier=0x20,-2
                snapshotAngles(r)
            else r.fireClock,r.burst,r.interval,r.remaining=0x30,2,0,0 end
        end
        if r.mode==1 then
            r.fireClock=r.fireClock-1
            if r.fireClock==0 then r.fireClock,r.modifier,r.fire=4,math.min(8,r.modifier+1),true end
            return
        end
        if r.remaining==0 then
            r.fireClock=r.fireClock-1
            if r.fireClock~=0 then return end
            r.burst=math.min(7,r.burst+1)
            r.fireClock,r.remaining,r.modifier=0x10,r.burst,-4
            snapshotAngles(r)
        end
        r.interval=r.interval-1
        if r.interval<0 then
            r.interval,r.modifier,r.fire,r.remaining=1,r.modifier+2,true,r.remaining-1
        end
    end

    function Ring.step(o)
        local run,r=o.run,o.ring
        if run.stopPathClock then return true end
        local dh,dl=program.vector(o.speed,0,run.slowVectors)
        o.h,o.l=s16(o.h+dh),s16(o.l+dl)
        if o.h>=0x7000 then
            r.finished,r.fire=true,false
            return false
        end
        if o.h>=0x6e00 then
            for _,p in ipairs(r.points) do p.released=true end
        end
        if run.freeze then return true end
        if r.unallocated>0 and run.boss6 then releaseNode(o,r) end
        r.angle,r.wave=band(r.angle+r.turn,255),band(r.wave+1,255)
        local _,tilt=program.vector(2,r.wave,run.slowVectors)
        r.tilt=band(tilt,255)
        rotate(o,r)
        volleys(r)
        return true
    end

    function Node.init(o)
        local row=o.row
        o.h,o.l,o.point,o.ring=row.h,row.l,row.point,row.ring
        o.flags,o.front,o.back,o.right,o.left,o.hp=unpack(data.nodeBox)
        o.angle,o.speed,o.grow,o.phase,o.pose=0x20,8,15,0,0
        return true
    end

    local function seek(o,p)
        o.angle=program.angle8(o.h,o.l,p,o.angle)
        local h,l=abs(s16(o.h-p.h)),abs(s16(o.l-p.l))
        h=h-floor(h/4)
        local distance=math.max(h,l)+floor(math.min(h,l)/2)
        o.speed=distance<=0x600 and 2*math.max(1,math.ceil(distance/0x40)) or 0x24
        o.grow=math.max(0,o.grow-1)
        if o.grow==0 and o.speed<=0x10 then
            o.phase,o.flags=1,0xa601
            return true
        end
    end

    local function fire(o,kind,modifier,angle)
        if angle>=0x40 and angle<0xc0 then bullets.emit(o,kind,modifier,angle,0,0,true) end
    end

    local function peelOff(o)
        local r,p=o.ring,o.point
        o.phase,o.speed=2,0
        o.angle=band(p.angle+(r.turn<0 and 0x80 or 0),255)
        o.aim,o.fireClock,o.accelerationClock=o.angle,0x10,0
    end

    local function flyFree(o)
        o.fireClock=o.fireClock-1
        if o.fireClock<0 then
            o.fireClock=4
            local target=program.angle8(o.h,o.l,o.run.player,o.aim)
            local difference=s8(target-o.aim)
            o.aim=band(o.aim+math.max(-1,math.min(1,difference)),255)
            fire(o,0x1a,0x10,o.aim)
        end
        o.accelerationClock=o.accelerationClock-1
        if o.accelerationClock<0 then o.accelerationClock,o.speed=2,o.speed+1 end
        return band(o.l+0x800,0xffff)<0x4800 and band(o.h+0x800,0xffff)<0x8000
    end

    function Node.step(o)
        local r,p,run=o.ring,o.point,o.run
        if run.boss6Defeated or (o.impact and o.hp<0) then
            effects.emit(o,0x8b,o.speed,o.angle,0,false,0)
            return false
        end
        o.hitFlash,o.impact,o.damage=o.impact,nil,0
        local dh,dl=program.vector(o.speed,o.angle,run.slowVectors)
        o.h,o.l=s16(o.h+dh),s16(o.l+dl)
        if run.freeze then return true end
        local justAttached=o.phase==0 and seek(o,p)
        if o.phase==1 and not justAttached then
            o.h,o.l=p.h,p.l
            if p.released then peelOff(o) end
        end
        if o.phase==2 then
            if not flyFree(o) then return false end
            o.pose=o.pose>=32 and 32+(o.pose-31)%16 or o.pose+1
        else
            if r.finished then return false end
            if r.fire and not justAttached then
                fire(o,r.mode==0 and 0xa or 0xd,r.modifier,band(p.fireAngle-r.angle+0x40,255))
            end
            o.pose=(o.pose+1)%16
        end
        return true
    end

    function Node.render(o)
        if not o.run.art then return end
        local images=o.hitFlash and data.images.ringFlash or data.images.ring
        local image=o.run.art.sprites[images[o.pose+1]]
        if o.grow>0 then
            local zoom=data.nodeZoom[o.grow+1]
            local scale=1-band(floor(zoom/0x800),15)/16
            local x,y=program.world(o.h,o.l)
            Render(image[1],floor(x),floor(y),0,scale,scale)
            return
        end
        local h,l=program.addPacked(o.h,o.l,0xfa00fc00)
        art.draw(image,h,l,0,0)
    end

    return Ring,Node
end
