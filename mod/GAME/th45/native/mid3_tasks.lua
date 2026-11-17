-- 0x1b56c0 先结算受击，再由 0x13ab3c 依次推进短任务、事件、移动和攻击。
return function(program,bullets,effects,tasks)
    local band = require('bit').band
    local abs,floor,min,max = math.abs,math.floor,math.min,math.max
    local s16,addPacked = program.s16,program.addPacked
    local data = program.mid3
    local attach,stop,contains = tasks.attach,tasks.stop,tasks.contains
    local aux,events,motion,attacks = {},{},{},{}
    local bounds = {{0x3c00,0x4c00,0x6e00,0x7200},{0x4000,0x4800,0x6000,0x6800},
                    {0x3a00,0x4e00,0x4c00,0x5400}}

    local function entry(init,step,first)
        if first then return {function(o,t) init(o,t); step(o,t) end,step} end
        return {init,step}
    end

    local function once(bank,step)
        return {function(o,t) step(o); o[bank][t.slot] = nil end}
    end

    local function tick(t,key,reload)
        t[key] = t[key]-1
        if t[key] >= 0 then return false end
        t[key] = reload
        return true
    end

    local function move(o)
        if o.run.stopPathClock then return end
        local dh,dl = program.vector(o.speed,o.direction*4,o.run.slowVectors)
        o.h,o.l = s16(o.h+dh),s16(o.l+dl)
    end

    local function pose(o,rows,n)
        local left,right = rows[n],rows[n+#rows/2]
        o.hit[1].front,o.hit[1].back = unpack(left)
        o.hit[3].right,o.hit[3].left = unpack(right)
    end

    aux[0] = entry(function(o,t) t.clock,o.door = 32,0 end,function(o,t)
        if not tick(t,'clock',1) then return end
        o.door = o.door+1
        pose(o,data.doorBox,o.door+1)
        if o.door==15 then
            o.aux[t.slot] = nil
            if not contains(o.events,8) then attach(o.attacks,1); attach(o.events,5) end
        end
    end)

    aux[1] = entry(function(o,t) t.clock,o.door = 0,15 end,function(o,t)
        if not tick(t,'clock',1) then return end
        o.door = o.door-1
        pose(o,data.doorBox,o.door+1)
        if o.door==0 then o.aux[t.slot] = nil end
    end,true)

    aux[2] = entry(function(_,t) t.clock = 0 end,function(o,t)
        local p = o.run.player
        if not o.lockAim and tick(t,'clock',1) and p and p.active then
            o.aim = program.towards(o.aim,program.angle(o.h,o.l,p,o.aim))
        end
    end,true)

    aux[3] = entry(function(o,t) t.clock,o.tread = 0,15 end,function(o,t)
        if tick(t,'clock',1) then o.tread = band(o.tread-1,15) end
    end,true)

    aux[5] = entry(function(o,t) t.clock,o.wreck = 32,0 end,function(o,t)
        if not tick(t,'clock',1) then return end
        o.wreck = o.wreck+1
        pose(o,data.wreckBox,o.wreck+1)
        if o.wreck==7 then
            o.aux[t.slot] = nil
            if not contains(o.events,8) then o.protected = false; attach(o.attacks,2) end
        end
    end,true)

    motion[0] = entry(function(o,t)
        o.h,o.l,o.speed,o.direction = -0x5c00,s16(0x5000-o.run.cameraOffset),0x1e,0x1a
        o.ramp,t.brake,t.frame,t.turnClock = 15,1,0,0
    end,function(o,t)
        local h,l = 0x5800,s16(0x1400-o.run.cameraOffset)
        if not o.run.freeze and tick(t,'turnClock',3) then
            o.direction = program.towards(o.direction,program.angle(o.h,o.l,{h=h,l=l,active=true},o.direction))
        end
        move(o)
        if o.run.freeze then return end
        local dh,dl = abs(s16(h-o.h)),abs(s16(l-o.l))
        dh = dh-floor(dh/4)
        local distance = max(dh,dl)+floor(min(dh,dl)/2)
        if distance<=0x1800 and tick(t,'brake',1) then o.speed = max(0,o.speed-1) end
        if distance<=0x3400 and tick(t,'frame',2) then
            o.ramp = o.ramp-1
            if o.ramp<0 then
                o.speed,o.drawRamp,o.drawBody,o.drawDoors,o.drawTurret = 6,false,true,true,true
                for _,p in ipairs(o.hit) do p.flags = 0xa001 end
                attach(o.aux,3)
                attach(o.aux,2)
                attach(o.events,3)
            end
        end
    end,true)

    for i,row in ipairs(bounds) do
        motion[i] = entry(function(o,t) t.turn = nil end,function(o,t)
            move(o)
            if t.turn then
                o.direction = program.towards(o.direction,t.turn)
                if o.direction==t.turn then t.turn = nil end
            end
            local a = program.random(o.run,program.randomNarrow)
            local l = band(o.l+0x2800,0xffff)
            local h = band(o.h,0xffff)
            if l<row[1] then t.turn = band(a+0x10,63)
            elseif l>=row[2] then t.turn = band(a+0x30,63)
            elseif h<row[3] then t.turn = band(a,63)
            elseif h>=row[4] then t.turn = band(a+0x20,63) end
        end,true)
    end

    motion[5] = entry(function(o) o.speed,o.direction = 10,0 end,function(o)
        move(o)
        if band(o.h+0x1e00,0xffff)>=0xac00 then o.finished = true end
    end,true)

    motion[6] = entry(function(o,t) o.speed,o.direction,t.clock = 2,0x20,0x10 end,function(o,t)
        if not o.run.freeze and o.speed<0x18 and tick(t,'clock',8) then o.speed = o.speed+1 end
        move(o)
    end,true)

    events[0] = once('events',function(o) o.nextMotion,o.drawRamp = 0,true end)
    events[2] = once('events',function(o) o.nextMotion=1; attach(o.aux,0) end)
    events[3] = entry(function(o) o.nextMotion=2; attach(o.attacks,0) end,function(o,t)
        if not contains(o.attacks,0) then
            attach(o.events,2)
            o.events[t.slot] = nil
        end
    end)

    events[5] = entry(function(_,t) t.wait = 0x30 end,function(o,t)
        if not t.closing then
            if contains(o.attacks,1) or contains(o.aux,1) then return end
            attach(o.aux,1)
            t.closing = true
        end
        t.wait = t.wait-1
        if t.wait==0 then attach(o.events,3); o.events[t.slot] = nil end
    end,true)

    events[6] = entry(function(o,t)
        t.clock,t.remaining,t.port,t.starboard = 4,9,1,17
        if program.random(o.run,program.randomByte)>=0x80 then t.port,t.starboard = t.starboard,t.port end
        -- 两侧替换贴图和爆散各用一对错开的计时器。
        t.switchPort,t.switchStarboard = t.port+0x20,t.starboard+0x20
    end,function(o,t)
        t.port,t.starboard = t.port-1,t.starboard-1
        t.switchPort,t.switchStarboard = t.switchPort-1,t.switchStarboard-1
        if t.port==0 or t.starboard==0 then
            local side = t.port==0 and 1 or 2
            effects.emitSequence(o,data.blasts[side])
            o.kick,o.kickAngle = 0x1a,side==1 and 0xc0 or 0x40
        end
        if t.switchPort==0 then o.broken[1] = true end
        if t.switchStarboard==0 then o.broken[2] = true end
        if not tick(t,'clock',4) then return end
        program.random(o.run,program.randomByte)
        local kind = ({9,5,9,5,4,5,8,11})[band(program.random(o.run,program.randomByte),7)+1]
        local angle = program.random(o.run,program.randomHalf,127)+0x60
        local dh = floor(s16(program.gunshipSmokeH[program.nextRandom(o.run,63)])/2)-0x1000
        local dl = s16(program.gunshipSmokeH[program.nextRandom(o.run,63)])
        dl = dl+floor(dl/2)
        effects.emit(o,kind,2,angle,dh*0x10000+band(dl,0xffff),false,0,-7)
        t.remaining = t.remaining-1
        if t.remaining<0 then attach(o.events,7); o.events[t.slot] = nil end
    end,true)

    events[7] = once('events',function(o) o.nextMotion=2; attach(o.aux,5) end)
    events[8] = once('events',function(o)
        tasks.clear(o.attacks)
        tasks.clear(o.events)
        o.run.stageFlags[0],o.run.stageFlags[1] = false,false
        o.nextMotion,o.protected = 5,true
    end)

    events[1] = entry(function(_,t)
        t.first,t.delay,t.flash,t.rest,t.clock,t.spark = 0x40,0x28,4,0xa0,1,1
    end,function(o,t)
        if t.first>0 then
            t.first = t.first-1
            if tick(t,'clock',1) then
                local kind,dh,dl,velocity = unpack(data.sparks[t.spark])
                local speed = floor(velocity/256)+floor(program.s8(program.random(o.run,program.randomNarrow))/2)
                effects.emit(o,kind,speed,band(velocity,255),dh*0x10000+band(dl,0xffff),false)
                t.spark = t.spark%#data.sparks+1
            end
        elseif t.delay>0 then
            t.delay = t.delay-1
            if t.delay==0 then effects.emitSequence(o,data.blasts[3]) end
        elseif t.flash>0 then
            t.flash = t.flash-1
            if t.flash==0 then o.hidden = true end
        else
            t.rest = t.rest-1
            if t.rest==0x40 then
                o.run.stageFlags[0] = false
                if o.run.major<0x170 then
                    for _,lane in ipairs(o.run.scroll) do lane.pendingH,lane.pendingL = 0x40,0 end
                end
            elseif t.rest==0 then o.finished = true end
        end
    end,true)

    local function fire(o,kind,modifier,angle,offset)
        bullets.emit(o,kind,modifier,angle,s16(floor(offset/0x10000)),s16(offset),true)
    end

    local function muzzle(angle)
        return program.mid2.muzzle0[floor(band(angle+2,0xfc)/4)+1]
    end

    -- 0x1b6e02 先确定六路或七路的排列，再从每个角度连发五档速度。
    attacks[0] = entry(function(_,t) t.clock,t.remaining = 0x50,4 end,function(o,t)
        if not tick(t,'clock',0x18) then return end
        local aim = o.aim
        local offset = data.muzzle[floor(aim/2)+1]
        local h,l = addPacked(o.h,o.l,offset)
        local narrow = program.random(o.run,program.randomByte)>=0x80
        local angle = aim*4-(narrow and 0x1e or 0x24)
        for ray=0,narrow and 5 or 6 do
            local direction = angle+ray*0xc
            local gun = muzzle(direction)
            local dh,dl = s16(h-o.h+floor(gun/0x10000)),s16(l-o.l+s16(gun))
            for speed=-2,6,2 do bullets.emit(o,6,speed,direction,dh,dl,true) end
        end
        t.remaining = t.remaining-1
        if t.remaining<0 then o.attacks[t.slot] = nil end
    end)

    local dronePorts = {{0xf18012c0,0x78},{0xf18012c0,0x99},{0xf180ed40,0x67},{0xf180ed40,0x8c}}

    -- 0x1b6f62 每轮登记四架子机，两次登记之间只在偶数轮加发机身圆弹。
    attacks[1] = entry(function(_,t) t.clock,t.remaining,t.rays,t.round,t.arc = 0x10,4,7,0,0x2a end,function(o,t)
        if not tick(t,'clock',0x40) then return end
        local run = o.run
        for _,row in ipairs(dronePorts) do
            local h,l = addPacked(o.h,o.l,row[1])
            local queue = run.spawnQueue
            queue[#queue+1] = {run.major,run.minor,0x95,0,0,0,0,0x1b78e8,0x1b78f0,0x1b79ba,h=h,l=l,angle=row[2]}
        end
        local p = run.player
        if t.round%2==0 and p and p.active then
            local angle = program.angle8(s16(o.h-0x1800),o.l,p,0x80)
                +floor(program.s8(program.random(run,program.randomNarrow))/2)-t.arc
            for ray=0,t.rays-1 do
                local direction = angle+ray*14
                local offset = muzzle(direction)+0xe8000000
                local modifier = (t.rays-1-ray)%2*4
                for speed=modifier,modifier+2,2 do
                    fire(o,10,speed,direction,offset)
                    offset = offset+0xa000800
                    fire(o,11,speed,direction,offset)
                    offset = floor(offset/0x10000)*0x10000+band(offset-0x1000,0xffff)
                    fire(o,11,speed,direction,offset)
                    offset = offset+0xa000800
                    fire(o,10,speed,direction,offset)
                    offset = offset-0x14000000
                end
            end
        end
        t.round,t.remaining = t.round+1,t.remaining-1
        if t.remaining<0 then o.attacks[t.slot] = nil end
    end)

    attacks[2] = entry(function(o,t)
        t.clock,t.remaining,t.count,t.layout,t.speed = 0x20,5,5,4,-4
        program.random(o.run,program.randomByte)
        program.random(o.run,program.randomByte)
        program.random(o.run,program.randomNarrow)
    end,function(o,t)
        if not tick(t,'clock',3) then return end
        local p = o.run.player
        if p and p.active then
            for _,row in ipairs(data.aimed[t.layout]) do
                local dh,dl,modifier,shift = unpack(row)
                local angle = program.angle8(s16(o.h+dh),s16(o.l+dl),p,0x80)
                bullets.emit(o,11,t.speed+modifier,angle+shift,dh,dl,true)
            end
        end
        t.remaining = t.remaining-1
        if t.remaining<0 then
            t.layout = (t.layout-2)%4+1
            t.count = min(11,t.count+3)
            t.remaining,t.clock,t.speed = t.count,0x24,min(4,t.speed+4)
        end
    end,true)

    return aux,events,motion,attacks
end
