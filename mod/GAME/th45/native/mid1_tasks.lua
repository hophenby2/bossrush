-- V100 的 0x1b010c、0x1b03ac、0x1b1796 分别管理部件、事件和攻击。
return function(program,bullets,effects,tasks)
    local band = require('bit').band
    local min,floor = math.min,math.floor
    local data = program.mid1
    local aux,events,attacks = {},{},{}
    local attach,stop,contains = tasks.attach,tasks.stop,tasks.contains
    local s16 = program.s16

    local function tick(t,reset)
        t.clock = t.clock - 1
        if t.clock >= 0 then return false end
        t.clock = reset
        return true
    end

    local function enter(init,step)
        return {function(o,t) init(o,t); step(o,t) end,step}
    end

    local function immediate(step)
        return {step,step}
    end

    local function clear(bank,t) bank[t.slot] = nil end

    -- 两个舱口都在计时归零才挂发弹回调，关舱结束后事件槽才交接。
    aux[0] = enter(function(_,t) t.clock = 0x20 end,function(o,t)
        if not tick(t,1) then return end
        o.hatch[1],o.hullFrame = min(0x1c,o.hatch[1]+4),o.hullFrame+4
        if o.hullFrame ~= 0x5c then return end
        clear(o.aux,t)
        attach(o.aux,10)
        if not o.protected and not contains(o.events,9) then
            attach(o.attacks,1)
            attach(o.events,8)
        end
    end)

    aux[1] = enter(function(_,t) t.clock = 0 end,function(o,t)
        if not tick(t,1) then return end
        o.hatch[1],o.hullFrame = math.max(0,o.hatch[1]-4),o.hullFrame-4
        if o.hullFrame ~= 0x1c then return end
        clear(o.aux,t)
        attach(o.aux,9)
    end)

    aux[2] = enter(function(o,t) t.clock,o.hatch[2] = 0x20,0 end,function(o,t)
        if not tick(t,1) then return end
        o.hatch[2] = o.hatch[2]+4
        if o.hatch[2] ~= 0x1c then return end
        clear(o.aux,t)
        if not o.protected and not contains(o.events,9) then
            attach(o.attacks,2)
            attach(o.events,7)
        end
    end)

    aux[3] = enter(function(o,t) t.clock,o.hatch[2] = 0,0x1c end,function(o,t)
        if not tick(t,1) then return end
        o.hatch[2] = o.hatch[2]-4
        if o.hatch[2] == 0 then clear(o.aux,t) end
    end)

    aux[4] = enter(function(_,t) t.clock = 0 end,function(o,t)
        if o.firePause or not tick(t,1) then return end
        for side = 1,2 do
            local current = o.cannonAim[side]
            local target = program.angle(o.h+0x400,o.l+(side == 1 and 0x500 or -0x500),o.run.player,current)
            o.cannonAim[side] = program.towards(current,target)
        end
    end)

    local function animation(field,first,last,step,initialClock)
        return enter(function(o,t) t.clock,o[field] = initialClock,first end,function(o,t)
            if tick(t,1) then o[field] = last + (o[field]+step-last) % (first-last+4) end
        end)
    end

    aux[5] = animation('tailFrame',0x1c,0,-4,0)
    aux[6] = animation('warningAnimation',0xc,0,-4,1)
    aux[8] = animation('engineFrame',0x1c,0,-4,0)
    local function hullAnimation(low)
        return enter(function(_,t) t.clock = 0 end,function(o,t)
            if tick(t,1) then o.hullFrame = low + (o.hullFrame+4-low) % 0x20 end
        end)
    end
    aux[9],aux[10] = hullAnimation(0),hullAnimation(0x60)

    events[0] = immediate(function(o,t)
        o.targetPhase,o.drawParts[11] = 0,true
        attach(o.aux,6)
        clear(o.events,t)
    end)

    for side = 1,2 do
        events[side] = enter(function(o,t)
            t.clock = 12
            local shift = o.deathWingCount == 2 and (side == 1 and 0x800 or -0x800) or 0
            effects.emitSequence({run=o.run,h=o.h,l=s16(o.l+shift)},data.explosions[side])
        end,function(o,t)
            t.clock = t.clock-1
            if t.clock ~= 0 then return end
            o.drawParts[side+3],o.drawParts[side+5],o.drawParts[side+7] = nil,nil,true
            clear(o.events,t)
        end)
    end

    -- 0x1b05d8 的碎片段先在残骸上发小爆炸，再挂延时的大爆炸。
    events[3] = enter(function(_,t)
        t.fragments,t.clock,t.fragmentIndex,t.soundClock = 64,0,1,3
        t.finalClock,t.hideClock,t.pauseClock,t.exitClock = 48,4,32,128
    end,function(o,t)
        if t.fragments > 0 then
            t.fragments = t.fragments-1
            if tick(t,1) then
                local kind,dh,dl,ground,velocity = unpack(data.fragments[t.fragmentIndex])
                local jitter = program.random(o.run,program.randomNarrow)
                if jitter >= 128 then jitter = jitter-256 end
                effects.emit(o,kind,floor(velocity/256)+floor(jitter/2),band(velocity,255),
                    dh*0x10000+band(dl,0xffff),ground ~= 0)
                t.fragmentIndex = t.fragmentIndex % #data.fragments + 1
                t.soundClock = t.soundClock-1
                if t.soundClock < 0 then
                    t.soundClock = 3
                    program.nextRandom(o.run)
                end
            end
            return
        end
        if t.finalClock > 0 then
            t.finalClock = t.finalClock-1
            if t.finalClock ~= 0 then return end
            effects.emitSequence(o,data.explosions[3])
        end
        if t.hideClock > 0 then
            t.hideClock = t.hideClock-1
            if t.hideClock ~= 0 then return end
            o.drawParts = {}
        end
        if t.pauseClock > 0 then
            t.pauseClock = t.pauseClock-1
            if t.pauseClock ~= 0 then return end
        end
        t.exitClock = t.exitClock-1
        if t.exitClock == 0 then o.finished = true end
    end)

    events[4] = immediate(function(o,t)
        if o.wingCount == 2 then attach(o.events,6)
        else
            o.targetPhase = 1
            stop(o.aux,9)
            attach(o.aux,0)
        end
        clear(o.events,t)
    end)

    events[5] = enter(function(o)
        o.targetPhase = 2
        attach(o.attacks,0)
    end,function(o,t)
        if contains(o.attacks,0) then return end
        attach(o.events,4)
        clear(o.events,t)
    end)

    events[6] = immediate(function(o,t)
        o.targetPhase = 3
        attach(o.aux,2)
        clear(o.events,t)
    end)

    events[7] = enter(function(_,t) t.clock = 0x30 end,function(o,t)
        if contains(o.attacks,2) or contains(o.aux,3) then return end
        t.clock = t.clock-1
        if t.clock ~= 0 then return end
        attach(o.events,5)
        clear(o.events,t)
    end)

    events[8] = immediate(function(o,t)
        if o.wingCount == 2 then stop(o.attacks,1)
        elseif contains(o.attacks,1) or contains(o.aux,1) then return end
        attach(o.events,6)
        clear(o.events,t)
    end)

    events[9] = immediate(function(o)
        tasks.clear(o.attacks)
        tasks.clear(o.events)
        o.targetPhase,o.protected,o.run.stageFlags[0] = 5,true,false
    end)

    local function muzzle(offsets,angle,base)
        local offset = offsets[floor(band(angle+2,0xfc)/4)+1]+base
        return s16(floor(offset/0x10000)),s16(offset)
    end

    -- 0x1b181a 左右炮口各有一张随朝向变化的发射位置表。
    attacks[0] = {function(o,t)
        t.clock,t.count,t.cycles = 0x50,o.cannonLength,3+o.cannonLoops
    end,function(o,t)
        if not tick(t,0x10-o.cannonRate) then return end
        local four = t.cycles % 2 == 1
        local count,kind,spread = four and 4 or 5,four and 1 or 0,four and 21 or 28
        for side = 1,2 do
            local aim = o.cannonAim[side]
            local center = data.cannonCenters[floor(aim/2)+1]
            local h,l = program.addPacked(o.h,o.l,center)
            local base = side == 1 and 0x04000500 or 0x03fffb00
            for ray = 0,count-1 do
                local angle = aim*4-spread+ray*14
                local dh,dl = muzzle(program.gunshipMainShotOffsets,angle,base)
                bullets.emit(o,kind,-2,angle,h-o.h+dh,l-o.l+dl,true)
            end
        end
        t.count = t.count-1
        if t.count >= 0 then return end
        o.firePause,t.clock,t.count,t.cycles = nil,0x20,o.cannonLength,t.cycles-1
        if t.cycles >= 0 then return end
        o.cannonLength = min(2,o.cannonLength+1)
        o.cannonLoops = min(4,o.cannonLoops+2)
        o.cannonRate = min(12,o.cannonRate+2)
        clear(o.attacks,t)
    end}

    local function closeFirstHatch(o)
        stop(o.aux,10)
        attach(o.aux,1)
    end

    attacks[1] = {function(_,t)
        t.clock,t.count,t.length,t.cycles = 1,6,6,3
        t.modifier,t.baseModifier,t.aim,t.drift = -4,-4,{0x60,0xa0},10
    end,function(o,t)
        if not tick(t,o.wingCount == 0 and 2 or 3) then return end
        local odd = t.cycles % 2 == 1
        local side = (odd and not o.wingLost[1] or o.wingLost[2]) and 1 or 2
        local count = o.wingCount == 0 and 3 or 5
        local base = side == 1 and 0xf0001080 or 0xefffef80
        for ray = 0,count-1 do
            local angle = t.aim[side]+(ray-floor(count/2))*30
            local dh,dl = muzzle(data.ringOffsets,angle,base)
            bullets.emit(o,6,t.modifier,angle,dh,dl,true)
        end
        t.aim[side] = t.aim[side]+(side == 1 and t.drift or -t.drift)
        t.count = t.count-1
        if t.count >= 0 then return end
        t.clock,t.length = 0x10,min(14,t.length+2)
        t.count = t.length
        if odd then
            t.baseModifier = t.baseModifier+1
            t.modifier = t.baseModifier
        end
        if not odd or o.wingCount > 0 then t.drift = -t.drift end
        t.cycles = t.cycles-1
        if t.cycles >= 0 then return end
        clear(o.attacks,t)
        closeFirstHatch(o)
    end}

    attacks[2] = enter(function(o,t)
        t.clock,t.count,t.length,t.cycles = 1,2,2,3
        t.modifier = -4+o.ringSpeed
        t.drift = program.random(o.run,program.randomByte) < 128 and 2 or -2
    end,function(o,t)
        if not tick(t,3) then return end
        if t.count == t.length then t.aim = program.random(o.run,program.randomByte) end
        local delta,count = unpack(data.rings[o.wingCount+1])
        for ray = 0,count-1 do
            local angle = t.aim+ray*delta
            local dh,dl = muzzle(data.ringOffsets,angle,0x0a800000)
            bullets.emit(o,26,t.modifier,angle,dh,dl,true)
        end
        t.modifier,t.aim,t.count = t.modifier+3,t.aim+t.drift,t.count-1
        if t.count >= 0 then return end
        if t.cycles % 2 == 1 then t.drift = t.drift+(t.drift < 0 and -1 or 1) end
        t.drift,t.clock,t.length = -t.drift,0x1c,min(6,t.length+1)
        t.count,t.modifier,t.cycles = t.length,-4,t.cycles-1
        if t.cycles >= 0 then return end
        o.ringSpeed = min(6,o.ringSpeed+3)
        clear(o.attacks,t)
        attach(o.aux,3)
    end)

    local function onWingLost(o)
        if contains(o.attacks,1) then
            stop(o.attacks,1)
            closeFirstHatch(o)
        end
        if not (o.wingLost[1] and o.wingLost[2]) then return end
        for _,index in ipairs({0,1,9,10}) do stop(o.aux,index) end
    end

    return {aux=aux,events=events,attacks=attacks,onWingLost=onWingLost}
end
