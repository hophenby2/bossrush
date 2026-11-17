-- 0x193e06 在事件任务之后推进本体，再把同坐标写到另外两个判定槽。
return function(program,attach,positionParts)
    local bit = require('bit')
    local band = bit.band
    local abs,floor = math.abs,math.floor
    local s16 = program.s16
    local motion = {}

    local function distance(h,l,targetH,targetL)
        local dh,dl = abs(s16(h-targetH)),abs(s16(l-targetL))
        dh = dh-floor(dh/4)
        return math.max(dh,dl)+floor(math.min(dh,dl)/2)
    end

    local function advance(o,t)
        if not o.run.stopPathClock then
            local dh,dl = program.vector(o.speed,o.direction*4,o.run.slowVectors)
            o.h,o.l = s16(o.h+dh),s16(o.l+dl)
        end
        positionParts(o)
    end

    local function brake(o,t)
        if not o.run.freeze then
            t.clock = t.clock-1
            if t.clock<0 then
                t.clock = 5
                if o.speed==0x10 then attach(o.aux,1) end
                o.speed = o.speed-1
                if o.speed<=2 then
                    o.protected = false
                    o.flags,o.extraParts[1].flags,o.extraParts[2].flags = 0xa001,0xa001,0xa001
                    attach(o.events,5)
                end
            end
        end
        advance(o,t)
    end
    motion[0] = {function(o,t)
        o.speed,o.direction,t.clock = 0x1a,0,5
        brake(o,t)
    end,brake}

    motion[1] = {function(o,t)
        o.speed,o.direction = 4,0x20
        advance(o,t)
    end,advance}

    local function follow(o,h,l)
        local target = {h=h,l=l,active=true}
        o.direction = program.towards(o.direction,program.angle(o.h,o.l,target,o.direction))
    end

    local function packedPoint(o,t)
        local offsets = t.index==7 and program.boss3.lastWander or program.boss2.wanderPacked
        t.h,t.l = program.addPacked(t.centerH,t.centerL,offsets[program.nextRandom(o.run,63)])
    end

    local function drift(o,t)
        if not o.run.freeze then
            local h,l = t.h,s16(t.l-o.run.cameraOffset)
            follow(o,h,l)
            if distance(o.h,o.l,h,l)<=0x100 then packedPoint(o,t) end
        end
        advance(o,t)
    end
    local function startDrift(o,t)
        t.centerH,t.centerL = o.h,o.l
        o.speed,o.direction = t.speed,t.direction
        packedPoint(o,t)
        drift(o,t)
    end
    motion[2],motion[7] = {startDrift,drift},{startDrift,drift}

    local function flyTo(o,t)
        if not o.run.freeze then
            follow(o,t.h,t.l)
            local d = distance(o.h,o.l,t.h,t.l)
            t.clock = t.clock-1
            if t.clock<0 then
                t.clock = t.period
                o.speed = o.speed+(d>=t.midpoint and t.delta or -t.delta)
            end
            if d<=0x200 or o.speed<0 then
                o.speed,o.nextMotion = 0,{index=2,speed=2,direction=o.direction}
            end
            o.speed = math.min(o.speed,0x10)
        end
        advance(o,t)
    end
    motion[3] = {function(o,t)
        t.clock,t.period,t.delta = unpack(program.boss3.flightRates[band(t.rate,15)+1])
        t.midpoint = floor(distance(o.h,o.l,t.h,t.l)/2)
        o.speed,o.direction = 0,program.angle(o.h,o.l,{h=t.h,l=t.l,active=true},o.direction)
        flyTo(o,t)
    end,flyTo}

    local function wanderPoint(o,t)
        local run = o.run
        t.pointH = s16(t.h+program.boss2.wanderH[program.nextRandom(run,63)])
        t.pointL = s16(t.l+program.boss2.wanderL[program.nextRandom(run,63)])
        t.clock = 0
    end

    local function wander(o,t)
        if not o.run.freeze then
            local h,l = t.pointH,t.pointL
            follow(o,h,l)
            t.clock = t.clock+1
            if t.clock==0x30 or distance(o.h,o.l,h,l)<=0x100 then wanderPoint(o,t) end
        end
        advance(o,t)
    end

    local function startWander(o,t)
        wanderPoint(o,t)
        o.speed,o.direction = t.speed,t.direction
        wander(o,t)
    end
    motion[5] = {startWander,wander}

    return motion,distance
end
