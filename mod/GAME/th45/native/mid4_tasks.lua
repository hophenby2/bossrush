-- 0x13ab3c 先推进零件，再执行事件、移动和攻击。舱门抵达端点才挂该炮口的任务。
return function(program,effects,tasks)
    local band,bor = require('bit').band,require('bit').bor
    local floor,abs,min,max = math.floor,math.abs,math.min,math.max
    local s16 = program.s16
    local data = program.mid4
    local attach,contains = tasks.attach,tasks.contains
    local aux,events,motion = {},{},{}

    local function entry(init,step,first)
        if first then return {function(o,t) init(o,t); step(o,t) end,step} end
        return {init,step}
    end

    local function once(action)
        return {function(o,t) action(o); o.events[t.slot] = nil end}
    end

    local function clock(t,reload)
        t.clock = t.clock-1
        if t.clock>=0 then return false end
        t.clock = reload
        return true
    end

    local function move(o)
        if o.run.stopPathClock then return end
        local dh,dl = program.vector(o.speed,o.direction*4,o.run.slowVectors)
        o.h,o.l = s16(o.h+dh),s16(o.l+dl)
    end

    motion[0] = entry(function(o,t)
        o.h,o.l,o.speed,o.direction = -0x7000,-o.run.cameraOffset,0x18,0x20
        t.clock,t.hold = 1,0x20
    end,function(o,t)
        local run = o.run
        if run.freeze then move(o); return end
        local h,l = 0x4400,0x1c00-run.cameraOffset
        t.target = t.target or {active=true}
        t.target.h,t.target.l = h,l
        o.direction = program.towards(o.direction,program.angle(o.h,o.l,t.target,o.direction))
        move(o)
        local dh,dl = abs(s16(o.h-h)),abs(s16(o.l-l))
        dh = dh-floor(dh/4)
        if max(dh,dl)+floor(min(dh,dl)/2)>0x1800 then return end
        if clock(t,1) then o.speed=max(0,o.speed-1) end
        t.hold = t.hold-1
        if t.hold>=0 then return end
        o.speed,o.protected,run.stageFlags[2] = 6,false,true
        for _,part in ipairs(o.hit) do part.flags = bor(part.flags,0xa001) end
        attach(o.events,10)
    end,true)

    local function wander(speed,left,right,bottom,top)
        return entry(function(_,t) t.clock=2 end,function(o,t)
            if speed and o.speed~=speed and clock(t,2) then
                o.speed=o.speed+(o.speed<speed and 1 or -1)
            end
            move(o)
            if t.angle then
                o.direction=program.towards(o.direction,t.angle)
                if o.direction==t.angle then t.angle=nil end
            end
            local a = program.random(o.run,program.randomNarrow)
            local l,h = band(o.l+0x2800,0xffff),band(o.h,0xffff)
            if l<left then a=a+0x10
            elseif l>=right then a=a+0x30
            elseif h>=top then a=a+0x20
            elseif h>=bottom then return end
            t.angle=band(a,63)
        end,true)
    end

    motion[1] = wander(6,0x3c00,0x4c00,0x5a00,0x5e00)
    motion[2] = wander(2,0x4300,0x4500,0x5000,0x5800)
    motion[3] = wander(nil,0x3a00,0x4e00,0x4c00,0x5400)
    motion[5] = entry(function(o) o.speed,o.direction=0xa,0 end,function(o)
        move(o)
        if band(o.h+0x7200,0xffff)<0x7200 then o.finished=true end
    end,true)
    motion[6] = entry(function(o,t) o.speed,o.direction,t.clock=2,0x20,0x10 end,function(o,t)
        if not o.run.freeze and o.speed<0x18 and clock(t,8) then o.speed=o.speed+1 end
        move(o)
    end,true)

    local function opening(field,delay,last,attack,event)
        return entry(function(_,t) t.clock=delay end,function(o,t)
            if not clock(t,1) then return end
            o[field]=o[field]+1
            if o[field]~=last then return end
            o.aux[t.slot]=nil
            if not contains(o.events,9) then
                attach(o.attacks,attack)
                attach(o.events,event)
            end
        end,true)
    end

    local function closing(field,first)
        return entry(function(o,t)
            t.clock=0
            if first then o[field]=first end
        end,function(o,t)
            if o[field]>0 and clock(t,1) then o[field]=o[field]-1 end
            if o[field]==0 then o.aux[t.slot]=nil end
        end,true)
    end

    aux[0] = opening('wingHatch',0x40,15,1,8)
    aux[1] = closing('wingHatch')
    aux[4] = opening('coreHatch',0x20,7,2,7)
    aux[5] = closing('coreHatch',7)

    for side=1,2 do
        aux[side+1] = entry(function(o) o.pod[side]=0 end,function(o,t)
            o.pod[side]=o.pod[side]+1
            if o.pod[side]~=23 then return end
            o.pod[side],o.aux[t.slot]=0,nil
        end,true)
    end

    aux[6] = entry(function(_,t) t.clock=0 end,function(o,t)
        local p=o.run.player
        if o.lockAim or not clock(t,1) or not p or not p.active then return end
        for side,aim in ipairs(o.cannonAim) do
            local angle=program.angle(s16(o.h+0x400),s16(o.l+(side==1 and 0x900 or -0x900)),p,aim)
            o.cannonAim[side]=program.towards(aim,angle)
        end
    end,true)

    for index,field in pairs({[7]='tail',[9]='engine'}) do
        aux[index] = entry(function(o,t) t.clock,o[field]=0,7 end,function(o,t)
            if clock(t,1) then o[field]=(o[field]-1)%8 end
        end,true)
    end

    events[0] = once(function(o)
        o.nextMotion=0
        for index=0,6 do o.drawParts[index]=true end
        attach(o.aux,7)
        attach(o.aux,6)
        attach(o.aux,9)
    end)

    for index,rows in ipairs({data.rightWingBlast,data.leftWingBlast}) do
        events[index] = entry(function(o,t)
            t.clock=12
            effects.emitSequence(o,rows)
        end,function(o,t)
            t.clock=t.clock-1
            if t.clock~=0 then return end
            o.drawParts[index],o.events[t.slot]=nil,nil
        end,true)
    end

    events[3] = entry(function(_,t)
        t.age,t.clock,t.row,t.soundClock=0,1,1,3
    end,function(o,t)
        t.age=t.age+1
        if t.age<=0x40 and clock(t,1) then
            local kind,dh,dl,_,velocity=unpack(data.initialBlast[t.row])
            local speed=floor(velocity/256)+floor(program.s8(program.random(o.run,program.randomNarrow))/2)
            effects.emit(o,kind,speed,band(velocity,255),dh*0x10000+band(dl,0xffff))
            t.row=t.row%#data.initialBlast+1
            t.soundClock=t.soundClock-1
            if t.soundClock<0 then
                t.soundClock=3
                program.random(o.run,program.randomByte)
            end
        end
        if t.age==0x70 then effects.emitSequence(o,data.finalBlast) end
        if t.age==0x74 then o.drawParts={} end
        if t.age==0xc4 then o.finished=true end
    end,true)

    events[4] = once(function(o) o.nextMotion=1; attach(o.aux,0) end)

    events[5] = entry(function(o,t)
        o.nextMotion,t.clock=3,0x20
        attach(o.attacks,4)
        attach(o.attacks,3)
    end,function(o,t)
        if contains(o.attacks,4) or contains(o.attacks,3) then return end
        t.clock=t.clock-1
        if t.clock~=0 then return end
        o.events[t.slot]=nil
        attach(o.events,10)
    end,true)

    events[6] = entry(function(o,t)
        o.nextMotion,t.clock,o.coreHatch=2,0x20,0
        attach(o.aux,4)
    end,function(o,t)
        t.clock=t.clock-1
        if t.clock~=0 then return end
        o.protected,o.events[t.slot]=false,nil
    end,true)

    events[7] = entry(function(_,t) t.clock=0x30 end,function(o,t)
        if contains(o.attacks,2) or contains(o.aux,5) then return end
        t.clock=t.clock-1
        if t.clock~=0 then return end
        o.events[t.slot]=nil
        attach(o.events,10)
    end,true)

    events[8] = {function() end,function(o,t)
        if contains(o.attacks,1) or contains(o.aux,1) then return end
        attach(o.events,5)
        o.events[t.slot]=nil
    end}

    events[9] = once(function(o)
        tasks.clear(o.attacks)
        tasks.clear(o.events)
        o.protected,o.retreating,o.nextMotion=true,true,5
    end)

    events[10] = entry(function(o)
        o.nextMotion=2
        attach(o.attacks,0)
        attach(o.attacks,5)
    end,function(o,t)
        if contains(o.attacks,0) or contains(o.attacks,5) then return end
        attach(o.events,4)
        o.events[t.slot]=nil
    end,true)

    events[11] = entry(function(_,t) t.clock,t.left=4,9 end,function(o,t)
        if not clock(t,4) then return end
        local run=o.run
        program.random(run,program.randomByte)
        local kind=data.phaseEffectKinds[program.nextRandom(run,7)]
        local angle=0x60+program.random(run,program.randomHalf,0x7f)
        local dh=0xf000+floor(s16(data.phaseOffsets[program.nextRandom(run,0x3f)])/2)
        local dl=s16(data.phaseOffsets[program.nextRandom(run,0x3f)])
        dl=dl+floor(dl/2)
        effects.emit(o,kind,2,angle,dh*0x10000+band(dl,0xffff),false,0,-7)
        t.left=t.left-1
        if t.left>=0 then return end
        attach(o.events,6)
        o.events[t.slot]=nil
    end,true)

    return aux,events,motion
end
