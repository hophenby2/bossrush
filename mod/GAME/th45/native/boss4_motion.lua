-- 0x198652 按纵向位移推进后舱，再处理横移。附属判定使用横移前的坐标。
return function(program,tasks)
    local band=require('bit').band
    local abs,floor,min,max=math.abs,math.floor,math.min,math.max
    local s16=program.s16
    local data=program.boss4
    local H={}

    local function clock(t,reload)
        t.clock=t.clock-1
        if t.clock>=0 then return false end
        t.clock=reload
        return true
    end

    local function vertical(o)
        if o.run.stopPathClock then return end
        local dh=program.vector(o.speed,o.direction*4,o.run.slowVectors)
        o.h=s16(o.h+dh)
    end

    local function moveSide(o)
        local t=o.sideMotion
        local mode=o.sideMode
        if not t or t.index~=mode then
            t={index=mode,phase=1,clock=mode==2 and 0x10 or 0,period=mode==2 and 0x10 or 0x20}
            o.sideMotion=t
            if mode==1 then o.sideSpeed=0 end
        end
        if mode==0 then return end
        if mode==1 and t.phase==1 then
            o.sideTarget=0x1c00+floor(data.randomOffset[program.nextRandom(o.run,0x7f)]/8)
            t.phase=2
        end
        if mode==2 and t.phase==1 or mode==1 and t.phase==2 then
            local speed=mode==2 and 4 or 2
            local accelerate=o.sideSpeed~=speed and clock(t,t.period)
            if accelerate then o.sideSpeed=min(o.sideSpeed+1,speed) end
            if mode==2 and (not t.direction or accelerate) then t.direction=o.l<o.sideTarget and 0x30 or 0x10 end
            if mode==1 then
                t.direction=t.aim or (o.l<o.sideTarget and 0x30 or 0x10)
                t.aim=t.direction
            end
            local _,dl=program.vector(o.sideSpeed,t.direction*4,o.run.slowVectors)
            o.l=s16(o.l-dl)
            if abs(s16(o.l-o.sideTarget))<=0x100 then
                t.phase=t.phase+1
            end
        end
        if mode==2 and t.phase==2 or mode==1 and t.phase==3 then
            if clock(t,t.period) then o.sideSpeed=max(0,o.sideSpeed-1) end
            local _,dl=program.vector(o.sideSpeed,t.direction*4,o.run.slowVectors)
            o.l=s16(o.l-dl)
            if o.sideSpeed==0 then
                if mode==2 then o.sideMode=0
                else
                    t.phase,t.aim=1,nil
                    t.clock=band(0x10+program.random(o.run,program.randomNarrow),255)
                end
            end
        end
    end

    local function place(o)
        o.deltaH,o.deltaL=s16(o.h-o.prevH),s16(o.l-o.prevL)
        o.prevH,o.prevL=o.h,o.l
        for i=1,4 do o.extraParts[i].h,o.extraParts[i].l=o.h,o.l end
        o.rear.l=s16(o.rear.l+o.deltaL)
        for i=6,7 do o.extraParts[i].h,o.extraParts[i].l=o.rear.h,o.rear.l end
        moveSide(o)
        if o.h>=o.back then o.back=0x3400 else o.back=s16(0x3400+o.h-o.back) end
    end

    local function entry(init,step)
        return {function(o,t) init(o,t); step(o,t) end,step}
    end

    H[0]=entry(function(o,t)
        o.speed,o.direction=0,0
        t.phase,t.delay,t.clock=0,0x150,0xc
    end,function(o,t)
        o.rear.h=s16(o.rear.h+o.deltaH)
        if t.phase==0 then
            if not o.run.stopPathClock then o.h=s16(o.h+o.run.groundScroll) end
            if not o.run.freeze then
                t.delay=t.delay-1
                if t.delay==0 then t.phase,o.speed,o.direction=1,8,0x20 end
            end
        end
        if not o.run.freeze then
            if t.phase==3 and clock(t,0xc) then
                o.speed=o.speed-1
                if o.speed==1 then tasks.attach(o.events,4) end
            end
            if t.phase==2 and clock(t,0xc) then
                o.speed=o.speed+1
                if o.speed==7 then
                    t.phase,o.protected=3,false
                    for index=0,7 do
                        local p=index==0 and o or o.extraParts[index]
                        p.flags=0xa000
                    end
                    tasks.attach(o.aux,16)
                    tasks.attach(o.aux,17)
                end
            end
            if t.phase==1 and clock(t,0xc) then
                o.speed=o.speed-1
                if o.speed==0 then t.phase,o.direction=2,0 end
            end
        end
        vertical(o)
        place(o)
    end)

    H[1]=entry(function(o)
        o.speed,o.direction=4,0x20
    end,function(o)
        vertical(o)
        place(o)
    end)

    local function aimVertical(o,t)
        o.direction=t.travel<0 and 0x20 or 0
        t.limit=t.center+t.travel
    end

    H[8]=entry(function(o,t)
        t.phase,t.clock=0,0
        aimVertical(o,t)
    end,function(o,t)
        if not o.run.freeze then
            if t.phase==0 then
                if o.speed>=1 then t.phase=2
                elseif clock(t,0x1c) then o.speed,t.phase=o.speed+1,1 end
            end
            if t.phase==1 then
                local h=o.measureRear and o.rear.h or o.h
                if o.direction==0 and h>=t.limit or o.direction==0x20 and h<=t.limit then t.phase=2 end
            end
            if t.phase==2 and clock(t,0x1c) then
                o.speed=o.speed-1
                if o.speed<=0 then
                    o.speed,t.phase,t.travel=0,0,-t.travel
                    aimVertical(o,t)
                    t.clock=t.clock+band(program.random(o.run,program.randomByte),31)
                end
            end
        end
        vertical(o)
        place(o)
    end)

    local function pass(direction,target,speed,beginPeriod,endPeriod,center)
        return entry(function(o,t)
            t.phase,t.clock,o.direction=0,0,direction
        end,function(o,t)
            if not o.run.freeze then
                if t.phase==0 then
                    if direction==0 and o.h>=target then
                        o.nextMotion={index=8,center=center,travel=0x100}
                    elseif clock(t,beginPeriod) then
                        o.speed=o.speed+1
                        if o.speed>=speed then t.phase=1 end
                    end
                end
                if t.phase==1 and (direction==0 and o.h>=target or direction==0x20 and o.h<=target) then
                    t.phase,t.clock=2,0
                end
                if t.phase==2 and clock(t,endPeriod) then
                    o.speed=o.speed-1
                    if o.speed==0 then o.nextMotion={index=8,center=center,travel=0x100} end
                end
            end
            vertical(o)
            place(o)
        end)
    end

    H[9]=pass(0x20,0x1800,0xa,0x10,6,0x1800)
    H[10]=pass(0,0x6600,0xd,0xc,4,0x6600)

    H[11]=entry(function(_,t) t.phase,t.clock=0,0 end,function(o,t)
        if not o.run.freeze then
            if t.phase==0 then
                if o.direction==0x20 then t.phase=1
                elseif clock(t,8) then
                    o.speed=o.speed-1
                    if o.speed<=0 then o.speed,o.direction,t.phase=0,0x20,1 end
                end
            end
            if t.phase==1 and clock(t,8) then
                if o.speed~=4 then o.speed=o.speed+(o.speed<4 and 1 or -1) end
            end
        end
        vertical(o)
        place(o)
    end)

    H[12]=entry(function(o,t)
        o.measureRear,o.sideMode,t.phase,t.clock=true,1,0,0
    end,function(o,t)
        if not o.run.freeze then
            if t.phase==0 and clock(t,4) then
                o.speed=o.speed-1
                if o.speed<=0 then
                    t.phase,o.speed,o.direction=1,0,band(o.rear.h,0xffff)>=0x6000 and 0x20 or 0
                end
            end
            if t.phase==1 then
                if clock(t,4) then o.speed=min(8,o.speed+1) end
                if o.direction==0 and band(o.rear.h,0xffff)>=0x6000 or
                    o.direction==0x20 and band(o.rear.h,0xffff)<=0x6000 then t.phase=2 end
            end
            if t.phase==2 and clock(t,4) then
                o.speed=o.speed-1
                if o.speed<=0 then
                    o.speed,o.nextMotion=0,{index=8,center=0x6000,travel=0x200}
                end
            end
        end
        vertical(o)
        place(o)
    end)

    H[13]=entry(function(_,t) t.phase,t.clock=0,0 end,function(o,t)
        if not o.run.freeze then
            if t.phase==0 then
                if o.direction==0x20 then t.phase=1
                elseif clock(t,4) then
                    o.speed=o.speed-1
                    if o.speed<=0 then o.speed,o.direction,t.phase=0,0x20,1 end
                end
            end
            if t.phase==1 then
                if o.rear.h<0x4c00 then t.phase=2
                elseif clock(t,4) and o.speed~=6 then o.speed=o.speed+(o.speed<6 and 1 or -1) end
            end
            if t.phase==2 and clock(t,4) then
                o.speed=o.speed-1
                if o.speed<=0 then
                    o.speed,o.nextMotion=0,{index=8,center=0x4c00,travel=0x200}
                end
            end
        end
        vertical(o)
        place(o)
    end)

    return H
end
