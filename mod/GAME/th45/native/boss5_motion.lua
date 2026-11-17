-- 0x1bac08。各移动入口都在更新坐标后同步三处主船体判定。
return function(program,effects,tasks)
    local band=require('bit').band
    local abs,floor,min,max=math.abs,math.floor,math.min,math.max
    local s16=program.s16
    local H={}

    local function place(o)
        for i=1,3 do
            local part=o.extraParts[i]
            part.h,part.l=o.h,o.l
        end
        if not o.detached then return end
        local run,part=o.run,o.extraParts[4]
        local history=o.trail
        local old=history[o.trailIndex]
        if o.partWaveStopped then
            if not run.stopPathClock then o.partWave=max(0,o.partWave-1) end
        else o.partWave=min(0x40,o.partWave+1) end
        local dh=program.vector(o.partWave,o.partAngle)
        if not run.freeze then
            o.partAngle=(o.partAngle+3)%256
            if o.partReceding then o.partDrop=max(-0x3200,o.partDrop-0x40)
            else o.partDrop=min(0,o.partDrop+0x40) end
        end
        local l=s16(old[2]-run.cameraStep)
        part.h,part.l=s16(old[1]+o.partDrop+dh),l
        o.extraParts[11].h,o.extraParts[11].l=part.h,part.l
        for _,point in ipairs(history) do point[2]=s16(point[2]-run.cameraStep) end
        old[1],old[2]=o.h,o.l
        o.trailIndex=o.trailIndex%8+1
    end

    local function advance(o)
        local dh,dl=program.vector(o.speed,o.heading*4,o.run.slowVectors)
        o.h,o.l=s16(o.h+dh),s16(o.l+dl)
    end

    local function approach(o,t)
        local run=o.run
        if run.freeze then
            advance(o)
        elseif t.delay>0 then
            t.delay=t.delay-1
            if t.delay==0 then
                t.blastL=s16(0x1c00-run.cameraOffset)
                effects.emitSequence({run=run,h=0x6400,l=t.blastL},program.boss5.entryBlast)
            end
        else
            if t.reveal>0 then
                t.reveal=t.reveal-1
                if t.reveal==0 then
                    o.draws[0],o.draws[1]=true,true
                    tasks.attach(o.aux,0)
                    tasks.attach(o.aux,1)
                end
            end
            local target={active=true,h=0x3400,l=s16(0x1c00-run.cameraOffset)}
            local angle=program.angle(o.h,o.l,target,o.heading)
            o.heading=program.towards(o.heading,angle)
            advance(o)
            local dh,dl=abs(s16(o.h-target.h)),abs(s16(o.l-target.l))
            dh=dh-floor(dh/4)
            if max(dh,dl)+floor(min(dh,dl)/2)<=0x1800 then
                t.clock=t.clock-1
                if t.clock<0 then t.clock,o.speed=1,max(0,o.speed-1) end
                if o.speed<6 then tasks.attach(o.events,3) end
            end
        end
        place(o)
    end

    H[0]={function(o,t)
        o.h,o.l,o.speed,o.heading=0x7200,s16(0x1c00-o.run.cameraOffset),0x18,0x20
        t.delay,t.reveal,t.clock=0x40,0x10,1
        approach(o,t)
    end,approach}

    local function wander(targetSpeed,left,right,lower,upper)
        local function step(o,t)
            if o.speed~=targetSpeed then
                t.clock=t.clock-1
                if t.clock<0 then
                    t.clock=2
                    o.speed=o.speed+(o.speed<targetSpeed and 1 or -1)
                end
            end
            advance(o)
            if t.target then
                o.heading=program.towards(o.heading,t.target)
                if o.heading==t.target then t.target=nil end
            end
            local nextHeading=program.random(o.run,program.randomNarrow)
            local l,h=band(o.l+0x2800,0xffff),band(o.h,0xffff)
            if l<left then nextHeading=nextHeading+0x10
            elseif l>=right then nextHeading=nextHeading+0x30
            elseif h>=lower then
                if h<upper then place(o); return end
                nextHeading=nextHeading+0x20
            end
            t.target=band(nextHeading,0x3f)
            place(o)
        end
        return {function(o,t) t.clock=2; step(o,t) end,step}
    end

    H[1]=wander(4,0x4200,0x4600,0x5e00,0x6200)
    H[2]=wander(6,0x4000,0x4800,0x5000,0x5800)
    local function escape(o)
        advance(o)
        place(o)
        if band(o.h+0x7200,0xffff)<0x7200 then o.finished=true end
    end
    H[5]={function(o) o.speed,o.heading=0xa,0; escape(o) end,escape}
    H[6]={function(o) o.speed,o.heading=0,0; place(o) end,place}
    local function retreat(o) advance(o); place(o) end
    H[7]={function(o) o.speed,o.heading=0xe,0x20; retreat(o) end,retreat}
    H[8]=wander(2,0x4200,0x4600,0x5e00,0x6200)
    H[9]=wander(2,0x3e00,0x4a00,0x5a00,0x5e00)
    H[10]=wander(2,0x4200,0x4600,0x5200,0x5600)

    return H
end
