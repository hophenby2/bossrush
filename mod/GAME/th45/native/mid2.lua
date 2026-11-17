-- 0x1b1e90 的五处判定共享耐久。三台分机各有坐标、转向和炮位。
return function(program,bullets,effects,art)
    local bit = require('bit')
    local band = bit.band
    local abs,ceil,floor,max,min = math.abs,math.ceil,math.floor,math.max,math.min
    local s16 = program.s16
    local data = program.mid2
    local M,exhaust,drone = {parts=10},{parts=1},{parts=2}
    local hitParts = {1,2,3,6,7}
    local orbitAngles = {0,0x55,0xaa}
    local moveBounds = {{0x4200,0x4600,0x6a00,0x6e00},
                        {0x3c00,0x4c00,0x6000,0x6800},
                        {0x4000,0x4800,0x5400,0x5c00}}
    local preset = {0x80,0x2b,0xd5,0x55,0,0xaa}
    local order = {6,7,8}
    local function towards(current,target,steps)
        local delta = band(target-current+32,63)-32
        return band(current+max(-steps,min(steps,delta)),63)
    end

    local function distance(h,l,targetH,targetL)
        local dh,dl = abs(s16(h-targetH)),abs(s16(l-targetL))
        dh = dh-floor(dh/4)
        return max(dh,dl)+floor(min(dh,dl)/2)
    end

    local function position(o)
        local h,l = o.h,o.l
        for _,i in ipairs({6,7}) do o.extraParts[i].h,o.extraParts[i].l = h,l end
    end

    local function travel(o)
        if o.run.freeze then return end
        local dh,dl = program.vector(o.speed,o.direction*4,o.run.slowVectors)
        o.h,o.l = s16(o.h+dh),s16(o.l+dl)
    end

    local function flyOrigin(o,h,l,bounds)
        local first,last,low,high = unpack(bounds)
        local angle = program.random(o.run,program.randomNarrow)
        l = band(l+0x2800,0xffff)
        h = band(h,0xffff)
        if l < first then return band(angle+0x10,63) end
        if l >= last then return band(angle+0x30,63) end
        if h < low then return band(angle,63) end
        if h >= high then return band(angle+0x20,63) end
    end

    local function orbit(o)
        o.orbitClock = o.orbitClock-1
        if o.orbitClock<0 then o.orbitClock = 5 end
        local row = data.orbit[o.radius+1]
        for i,offset in ipairs(orbitAngles) do
            local part = o.extraParts[i]
            local at = band(o.orbitAngle+offset,255)*4+1
            local targetH = s16(o.h+s16(program.word(row,at)))
            local targetL = s16(o.l+s16(program.word(row,at+2)))
            part.l = s16(part.l-o.run.cameraStep)
            if o.separated then
                part.speed = part.speed+max(-1,min(1,6-part.speed))
                part.dh,part.dl = program.vector(part.speed,part.dir*4,o.run.slowVectors)
                part.h,part.l = s16(part.h+part.dh),s16(part.l+part.dl)
                if part.turn then
                    part.dir = program.towards(part.dir,part.turn)
                    if part.dir==part.turn then part.turn=nil end
                end
                local upperH = band(targetL+0x2c00,0xffff)
                part.turn = flyOrigin(o,part.h,part.l,{band(targetL+0x2600,0xffff),
                    band(targetL+0x2a00,0xffff),band(targetH-0x200,0xffff),upperH}) or part.turn
            else
                if o.orbitClock==2*(i-1) then
                    local dir = program.angle(part.h,part.l,{h=targetH,l=targetL,active=true},part.dir)
                    local targetSpeed = min(25,max(1,ceil(distance(part.h,part.l,targetH,targetL)/0x40)))
                    if not o.lockOrbit then
                        part.dir = towards(part.dir,dir,4)
                        part.speed = max(1,part.speed+(targetSpeed>part.speed and 1 or -1))
                        targetSpeed = part.speed
                    end
                    part.dh,part.dl = program.vector(targetSpeed,dir*4,o.run.slowVectors)
                end
                part.h,part.l = s16(part.h+part.dh),s16(part.l+part.dl)
            end
        end
        position(o)
    end

    local function exhaustFrom(o)
        local part = o.extraParts[o.exhaustPort]
        local run = o.run
        local queue = run.spawnQueue
        queue[#queue+1] = {run.major,run.minor,0x8b,0,0,0,0,0x1654ec,0x1654f4,0x165584,
            h=s16(part.h+0x400),l=part.l}
        o.exhaustPort = (o.exhaustPort+1)%3+1
    end

    function exhaust.init(o)
        o.h,o.l,o.flags = o.row.h,o.row.l,0x8000
        local angle = program.random(o.run,program.randomHalf,127)-0x20
        o.dh,o.dl = program.vector(4,angle)
        o.clock,o.dragClock,o.shape = 0,0x1e,0
        return true
    end

    function exhaust.step(o)
        if band(o.l,0xffff)>=0x3800 or band(o.h+0xc00,0xffff)>=0x8800 then return false end
        local half = o.run.halfPathSpeed and 2 or 1
        o.dragClock = o.dragClock-1
        if o.dragClock<0 then o.dragClock,o.dh = 0,floor(o.dh-2/half) end
        o.h,o.l = s16(o.h+floor(o.dh/half)),s16(o.l+floor(o.dl/half))
        if not o.run.stopPathClock then
            o.clock = o.clock-1
            if o.clock<0 then o.clock,o.shape = 1,o.shape+1 end
        end
        return o.shape<=#data.exhaust
    end

    function exhaust.render(o)
        local image = data.exhaust[o.shape]
        if o.run.art and image then art.draw(o.run.art.sprites[image[1]],o.h,o.l,image[2],image[3]) end
    end

    local function startApproach(o)
        local camera = o.run.cameraOffset
        o.h,o.l,o.speed,o.direction = -0x8000,s16(0x1c00-camera),0x10,0x20
        o.radius,o.orbitAngle,o.orbitClock = 0,program.random(o.run,program.randomByte),0x50
        o.lockOrbit,o.exhaustClock,o.exhaustPort,o.shapeClock,o.radiusClock = true,0,3,8,1
        o.approachBrake,o.approachHold = 8,0x40
        local rows = {{0x2800,0x5000,0x3c},{0x6400,0x5c00,0x30},{0x5000,-0x1600,0x10}}
        for i,row in ipairs(rows) do
            local part = o.extraParts[i]
            part.h,part.l,part.dir,part.speed = row[1],s16(row[2]-camera),row[3],6
            part.dh,part.dl = 0,0
        end
    end

    local function open(o)
        o.motion,o.attackDelay,o.attackOrder,o.alignClock = 1,0x10,0xffff,1
        o.attackCycle,o.hullStart = 1,true
        o.run.stageFlags[2] = true
        for _,i in ipairs(hitParts) do o.extraParts[i].flags = 0xa001 end
    end

    local function approach(o)
        local run = o.run
        if not run.stopPathClock then
            if o.shape<0x3c then
                o.shapeClock = o.shapeClock-1
                if o.shapeClock<0 then o.shape,o.shapeClock = o.shape+4,2 end
            end
            o.exhaustClock = o.exhaustClock-1
            if o.exhaustClock<0 then
                exhaustFrom(o)
                o.exhaustClock = 0
            end
            local target = {h=0x6400,l=s16(0x1c00-run.cameraOffset),active=true}
            o.direction = program.towards(o.direction,program.angle(o.h,o.l,target,o.direction))
            travel(o)
            if distance(o.h,o.l,target.h,target.l)<=0x800 then
                o.approachBrake = o.approachBrake-1
                if o.approachBrake<0 then o.approachBrake,o.speed = 8,max(0,o.speed-1) end
            end
            if o.radius<0x50 then
                o.radiusClock = o.radiusClock-1
                if o.radiusClock<0 then o.radius,o.radiusClock = o.radius+1,1 end
            end
            o.orbitAngle = band(o.orbitAngle+2,255)
            if o.speed<8 then
                o.approachHold = o.approachHold-1
                if o.approachHold==0 then open(o); o.speed=6 end
            end
        else
            travel(o)
        end
        orbit(o)
    end

    local function mount(o,kind,modifier,angle,offset,table)
        if table then offset = offset+table[floor(band(angle+2,0xfc)/4)+1] end
        local h,l = program.addPacked(0,0,offset)
        bullets.emit(o,kind,modifier,angle,h,l,true)
    end

    local function event0(o,t)
        local part = o.extraParts[1]
        local random = program.random(o.run,program.randomByte)
        if random>=0x80 then
            for i=0,8 do mount(part,11,t.modifier,0x50+i*12,0xf9c00000,data.muzzle0) end
        elseif o.run.player and o.run.player.active then
            local angle = program.angle8(part.h-0x640,part.l,o.run.player,0x80)-9
            for i=0,6 do mount(part,11,t.modifier,angle+i*3,0xf9c00000,data.muzzle0) end
        end
    end

    local function event1(o,t)
        if t.count==t.countReload and o.run.player and o.run.player.active then
            local part = o.extraParts[1]
            t.aimA = program.angle8(part.h+0xc40,part.l+0x400,o.run.player,0x80)
            t.aimB = program.angle8(part.h+0xc40,part.l-0x400,o.run.player,0x80)
        end
        if not t.aimA then return end
        for i=0,6 do mount(o.extraParts[1],1,t.modifier,t.aimA-0x1b+i*9,0x0c400400,data.muzzle0) end
        for i=0,6 do mount(o.extraParts[1],1,t.modifier,t.aimB-0x1b+i*9,0x0c40fc00,data.muzzle0) end
    end

    -- 0x1b4abe 两列炮口角独立偏移。在端点反向后仍使用同一张炮口表。
    local function event2(o,t)
        for _,row in ipairs(data.volley) do
            local angle = row[1]+t.sweep
            mount(o.extraParts[2],13,t.modifier,angle-1,row[2])
            mount(o.extraParts[2],13,t.modifier,angle+1,row[2])
        end
    end

    local function event3(o)
        local direction = o.cannonAim
        local offset = 0x07000000+data.gunOffset[floor(direction/2)+1]
        for i=-3,3 do mount(o.extraParts[2],2,-6,direction*4+i*2,offset,data.muzzle0) end
    end

    local function event4(o,t)
        local player = o.run.player
        if not player or not player.active then return end
        if t.count==t.countReload or not t.aimA then
            t.aimA = program.angle8(o.h-0x800,o.l,player,0x80)
        end
        mount(o.extraParts[3],25,t.modifier,t.aimA,0xf8000000)
        t.modifier = t.modifier+2
    end

    local function event5(o,t)
        local player = o.run.player
        if not player or not player.active then return end
        local a,b,c = unpack(o.extraParts)
        mount(a,26,t.modifier,program.angle8(a.h,a.l,player,0x80),0,data.muzzle1)
        for _,part in ipairs({b,c}) do
            local aim = program.angle8(part.h,part.l,player,0x80)
            local sign = part==b and 1 or -1
            mount(part,25,t.modifier+1,aim+sign*0x11,0,data.muzzle1)
            mount(part,25,t.modifier+2,aim-sign*0x1a,0,data.muzzle1)
            mount(part,25,t.modifier+4,aim+sign*0x23,0,data.muzzle1)
        end
        t.modifier = t.modifier+1
    end

    local fireTask = {event0,event1,event2,event3,event4,event5}
    local function word(row,i)
        return s16(row[i]*256+row[i+1])
    end

    local function beginEvent(o,id)
        local p = data['event'..id]
        o.events[id+1] = {clock=p[1],count=word(p,3),countReload=word(p,5),gap=p[7],rest=p[8],
            remaining=p[9],modifier=word(p,11),sweep=p[13],sweepStep=program.s8(p[14]),baseModifier=p[16],
            startFrame=o.run.frame}
    end

    local function advanceEvents(o)
        for i,fire in ipairs(fireTask) do
            local t = o.events[i]
            if t and t.startFrame~=o.run.frame then
                t.clock = t.clock-1
                if t.clock<0 then
                    t.clock = t.gap
                    fire(o,t)
                    t.count = t.count-1
                    if t.count<0 then
                        t.clock,t.count = t.rest,t.countReload
                        if i==2 then
                            t.countReload,t.modifier = min(11,t.countReload+3),t.modifier+4
                            t.count = t.countReload
                            t.remaining = t.remaining-1
                            if t.remaining<0 then o.events[1],o.events[2] = nil,nil end
                        elseif i==3 then
                            t.sweep = band(t.sweep+t.sweepStep,255)
                            if t.sweep>=0xb0 or t.sweep<=0x50 then t.sweepStep = -t.sweepStep end
                            t.remaining = t.remaining-1
                            if t.remaining<0 then o.events[3],o.events[4],o.hatchClosing = nil,nil,true end
                        elseif i==5 then
                            t.modifier = s16(data.event4[19]*256+data.event4[20])
                            t.remaining = t.remaining-1
                            if t.remaining<0 or o.drones==0 then o.events[5] = nil end
                        elseif i==6 then
                            t.countReload = t.countReload+t.sweepStep
                            t.baseModifier = min(13,program.s8(t.baseModifier)+3)
                            t.count,t.modifier = t.countReload,t.baseModifier
                        end
                    end
                end
            end
        end
    end

    local attackPorts = {{0,1},{2,3},{4},{0,1,2,3},{2,3,4},{4,0,1}}
    local function startPattern(o)
        local order = o.launchPattern
        o.launchPattern = nil
        for _,id in ipairs(attackPorts[order-5]) do
            if id==2 then
                o.hatchClock,o.hatchOpen = 0x20,true
            elseif id==4 then
                o.portClock,o.portOpen = 0x20,true
            elseif id~=3 then
                beginEvent(o,id)
            end
        end
    end

    local function launchDrones(o)
        local part,run = o.extraParts[3],o.run
        local queue = run.spawnQueue
        local angle = program.random(run,program.randomByte)
        o.drones = 2
        for _,side in ipairs({1,-1}) do
            queue[#queue+1] = {run.major,run.minor,0x86,0,0,0,0,0x1b5080,0x1b5088,0x1b5166,
                h=s16(part.h+0x800),l=s16(part.l+side*0x600),boss=o,side=side,angle=side*angle}
        end
    end

    function drone.init(o)
        o.h,o.l,o.boss = o.row.h,o.row.l,o.row.boss
        o.flags,o.front,o.back,o.right,o.left,o.hp = 0xa001,0x300,0x300,0x280,0x280,0x600
        o.base = {flags=0xa000,h=o.h,l=o.l,front=0x600,back=0x600,right=0x500,left=0x500,hp=o.hp}
        o.extraParts = {o.base}
        o.spin,o.direction,o.speed = o.row.angle,o.row.side>0 and 0x20 or 0xe0,0
        o.shotClock,o.repetitions,o.drag,o.pose = 0x20,4,0,7
        return drone.step(o)
    end

    function drone.step(o)
        local run,boss = o.run,o.boss
        local dh,dl = program.vector(o.speed,o.direction,run.slowVectors)
        if not run.freeze then o.h,o.l = s16(o.h+dh),s16(o.l+dl) end
        o.base.h,o.base.l = o.h,o.l
        local inside = band(o.h+0x600,0xffff)<0x7c00 and band(o.l+0xe00+run.cameraOffset,0xffff)<0x5400
        if inside then o.seen = true end
        if not run.stageFlags[2] or not inside and o.seen or o.hp<0 or o.base.hp<0 then
            if run.stageFlags[2] and o.hp>=0 and o.base.hp>=0 then
                boss.drones = max(0,boss.drones-1)
                return false
            end
            effects.emit(o,0x85,0,0,0)
            effects.emit(o,0x88,0,0,0)
            boss.drones = max(0,boss.drones-1)
            return false
        end
        if o.impact or o.base.impact then
            o.hp = min(o.hp,o.base.hp)
            o.base.hp,o.impact,o.base.impact = o.hp,nil,nil
        end
        o.drag = o.drag-1
        if o.drag<0 then o.drag,o.pose = 1,(o.pose-1)%8 end
        if run.stopPathClock or run.freeze or o.h<0x800 then return true end
        o.shotClock = o.shotClock-1
        if o.shotClock>=0 then return true end
        o.shotClock = 2
        local one = boss.drones==1
        local rays = one and 8 or 4
        for i=0,rays-1 do mount(o,12,-3,o.spin+i*256/rays,0,data.muzzle1) end
        o.spin = band(o.spin+o.row.side*3,255)
        o.repetitions = o.repetitions-1
        if o.repetitions<0 then o.repetitions,o.shotClock = 4,one and 4 or 0x1c end
        return true
    end

    function drone.render(o)
        if o.run.art then art.draw(o.run.art.sprites[data.drone[o.pose+1]],o.h,o.l,-0x500,-0x300) end
    end

    local function animatePorts(o)
        local part = o.extraParts[2]
        local player = o.run.player
        if player and player.active then
            local aim = program.angle(part.h+0x700,part.l,player,o.cannonAim)
            o.cannonAim = program.towards(o.cannonAim,aim)
        end
        if o.hatchOpen or o.hatchClosing then
            o.hatchClock = o.hatchClock-1
            if o.hatchClock<0 then
                o.hatchClock = 1
                o.hatch = o.hatch+(o.hatchOpen and 1 or -1)
                if o.hatch==7 then
                    o.hatchOpen = false
                    beginEvent(o,2)
                    beginEvent(o,3)
                elseif o.hatch==0 then
                    o.hatchClosing = false
                end
            end
        end
        if o.portOpen then
            o.portClock = o.portClock-1
            if o.portClock<0 then
                o.portClock,o.portAngle,o.portTail = 1,o.portAngle+1,min(7,o.portTail+1)
                if o.portAngle==8 then launchDrones(o) end
                if o.portTail==7 and not o.events[5] and o.portAngle<8 then beginEvent(o,4) end
                if o.portAngle==20 then o.portAngle,o.portOpen = 0,false end
            end
        elseif not o.events[5] and o.portTail>0 then
            o.portTail = o.portTail-1
        end
    end

    local function setupRetreat(o)
        o.run.stageFlags[2] = false
        o.motion,o.events,o.protected,o.speed,o.direction = 5,{},true,0xa,0
        o.launchPattern,o.hatchOpen,o.portOpen = nil,false,false
    end

    local function setupFormation(o)
        o.run.stageFlags[2] = false
        o.phase2,o.protected,o.protection,o.motion,o.speed = true,true,0x70,3,6
        o.separated,o.lockOrbit,o.events,o.hatchOpen,o.portOpen = false,true,{},false,false
        o.launchPattern,o.attackDelay,o.alignClock = nil,nil,nil
        o.hatchClosing,o.hatchClock = o.hatch>0,1
        bullets.clear(o.run,4)
        for i=1,3 do effects.emit(o.extraParts[i],0x85,0,0,0xfc000000) end
        beginEvent(o,5)
    end

    local function fight(o)
        if o.motion==5 then
            travel(o)
            if band(o.h+0x1e00,0xffff)>=0xb600 then o.finished=true end
            orbit(o)
            return
        end
        local run = o.run
        local active = not run.stopPathClock and not run.freeze
        local newAttack = false
        if active then
            if o.hullStart then o.hullStart,o.speed = false,4 end
            if o.protection>0 then
                o.protection = o.protection-1
                if o.protection==0 then o.protected,o.lockOrbit = false,false end
            end
            if o.attackDelay then
                o.attackDelay = o.attackDelay-1
                if o.attackDelay==0 then
                    o.attackDelay = nil
                    local nextAttack
                    repeat
                        nextAttack = order[program.random(run,data.patternRandom,127)+1]
                    until nextAttack~=o.attackOrder and nextAttack~=o.priorAttack
                    o.attackOrder = nextAttack
                end
            end
            if o.attackOrder==0xffff and o.alignClock~=nil then
                o.alignClock = o.alignClock-1
                if o.alignClock<0 then o.alignClock,o.orbitAngle = 1,band(o.orbitAngle+1,255) end
            elseif o.alignClock~=nil then
                local target = preset[o.attackOrder-5]
                if o.orbitAngle==target then
                    o.alignClock,o.separated,o.lockOrbit,newAttack = nil,true,false,true
                else
                    local delta = band(target-o.orbitAngle+128,255)-128
                    o.orbitAngle = band(o.orbitAngle+(delta>0 and 1 or -1),255)
                end
            elseif o.phase2 then
                o.orbitAngle = band(o.orbitAngle+min(3,1+floor((0x70-o.protection)/0x20)),255)
            end
            animatePorts(o)
            if newAttack then o.launchPattern = o.attackOrder
            elseif o.launchPattern then startPattern(o)
            elseif not o.attackDelay and o.alignClock==nil and not o.phase2 and not next(o.events)
                and not o.hatchClosing and not o.hatchOpen and not o.portOpen then
                if o.attackCycle==3 then setupRetreat(o)
                else
                    o.attackCycle,o.attackDelay,o.alignClock = o.attackCycle+1,0x10,1
                    o.priorAttack,o.attackOrder,o.separated = o.attackOrder,0xffff,false
                end
            end
        end
        travel(o)
        if o.turn then
            o.direction = program.towards(o.direction,o.turn)
            if o.direction==o.turn then o.turn=nil end
        end
        o.turn = flyOrigin(o,o.h,o.l,moveBounds[min(o.motion,3)]) or o.turn
        orbit(o)
        if active then advanceEvents(o) end
    end

    local function damage(o)
        local hit,total = false,0
        for _,i in ipairs(hitParts) do
            local part = o.extraParts[i]
            hit = hit or part.impact
            total = total+(part.damage or 0)
        end
        if hit then
            for _,i in ipairs(hitParts) do
                local part = o.extraParts[i]
                part.flags,part.impact,part.damage,part.hp = band(part.flags,0xa6ff),nil,0,0x7fff
            end
            if not o.protected then o.health = o.health-band(total,0xffff) end
            o.palette = o.palette==2 and 1 or 2
        else
            o.palette = o.health<0x6c00 and not o.run.dual and 3 or 1
        end
    end

    local dismount = {0x10,0x30,0x50}
    local function fall(o)
        if not o.run.stopPathClock then
            o.deathAge = o.deathAge+1
            o.fallClock = o.fallClock-1
            if o.fallClock<0 and o.speed<0x18 then o.fallClock,o.speed = 8,o.speed+1 end
            o.foldClock = o.foldClock-1
            if o.foldClock<0 and o.shape<0x7c then o.foldClock,o.shape = 2,o.shape+4 end
            o.wreckClock = o.wreckClock-1
            if o.wreckClock<0 and o.wreckFrame>0 then
                o.wreckFrame = o.wreckFrame-4
                o.wreckClock = o.wreckFrame<=0x3c and 4 or 2
            end
            for i,clock in ipairs(dismount) do
                if o.deathAge==clock then effects.emitSequence(o.extraParts[i],data.explosions[i]) end
                if o.deathAge==clock+11 then o.broken[i] = true end
            end
            local age = o.deathAge
            if age<=0x60 then
                if age%4==0 then
                    local row = data.explosions[5][floor(age/4-1)%#data.explosions[5]+1]
                    local varied = floor(program.s8(program.random(o.run,program.randomNarrow))/2)
                    local kind,h,l,_,velocity = unpack(row)
                    effects.emit(o,kind,band(floor(velocity/256)+varied,255),band(velocity,255),
                        h*65536+band(l,65535))
                end
            elseif age==0x60+0x30 then
                effects.emitSequence(o,data.explosions[4])
            elseif age==0x60+0x30+4 then
                o.bodyGone = true
            elseif age>=0x60+0x30+4+0x20+0x10+0x80 then
                o.finished = true
            end
            if age%4==0 then
                local pick = program.random(o.run,program.randomByte)
                local angle = program.random(o.run,program.randomNarrow)*4
                effects.emit(o,pick>=128 and 4 or 0x10,0x1e,angle,0xfc000000)
            end
        end
        travel(o)
        orbit(o)
    end

    local function breakHull(o)
        o.run.stageFlags[2] = false
        o.health,o.dying,o.events,o.deathAge = -1,true,{},0
        o.speed,o.direction,o.fallClock = 2,0x20,0x10
        o.shape,o.foldClock,o.wreckFrame,o.wreckClock = 0x3c,0x60,0xbc,0
        o.separated,o.broken,o.palette = false,{},1
        for _,i in ipairs(hitParts) do o.extraParts[i].flags = 0x8000 end
        bullets.clear(o.run,0x100)
    end

    function M.init(o)
        o.flags,o.h,o.l,o.health,o.palette = 0x8000,0,0,data.health,1
        o.shape,o.motion,o.extraParts,o.events = 0,0,{},{}
        o.birthFrame,o.bodyFlame = o.run.frame,0x3c
        o.protection,o.hatch,o.cannonAim,o.drones,o.portAngle,o.portTail = 0,0,0,0,0,0
        o.rotors = {7,7,7,7,7,7,7}
        for i,row in ipairs(data.parts) do
            local flags,front,back,right,left,hp = unpack(row)
            o.extraParts[i] = {run=o.run,flags=flags,front=front,back=back,right=right,left=left,hp=hp,h=0,l=0}
        end
        o.run.midBoss,o.run.stageFlags[0] = o,true
        return true
    end

    function M.step(o)
        if o.finished then
            o.run.midBoss,o.run.stageFlags[0],o.run.stageFlags[2] = nil,false,false
            return false
        end
        if not o.orbitClock then startApproach(o) end
        if o.motion==0 then
            approach(o)
        else
            if not o.dying then
                damage(o)
                if not o.phase2 and o.health<=data.threshold and o.motion~=5 then
                    setupFormation(o)
                elseif o.health<0 and o.phase2 then
                    breakHull(o)
                elseif o.run.major>=0x128 and o.motion~=5 then
                    setupRetreat(o)
                end
            end
            if o.dying then fall(o) else fight(o) end
        end
        if not o.run.stopPathClock and band(o.run.frame-o.birthFrame,1)==0 then
            for i=1,#o.rotors do o.rotors[i]=(o.rotors[i]-1)%8 end
            o.bodyFlame = (o.bodyFlame-4)%0x40
        end
        return true
    end

    local function draw(o,part,id,offset)
        local h,l = program.addPacked(part.h,part.l,offset)
        art.draw(o.run.art.sprites[id],h,l,0,0)
    end

    function M.render(o)
        if not o.run.art or not o.orbitClock then return end
        local images = data.images[o.palette]
        local a,b,c = unpack(o.extraParts)
        local frame = o.rotors
        if o.dying then
            if not o.bodyGone then draw(o,o,images[2][floor(o.wreckFrame/4)+1],0xf200f300) end
        elseif o.shape==0x3c then
            draw(o,o,images[1][floor(o.bodyFlame/4)+1],0xf200f300)
        end
        local broken = o.broken or {}
        if not broken[1] then
            draw(o,a,images[3][frame[1]+1],0xf400f600)
            draw(o,a,images[4][frame[4]+1],0xf200fd00)
            draw(o,a,images[5][frame[5]+1],0x0600f900)
        end
        if not broken[2] then
            draw(o,b,images[6][frame[2]+1],0xf400f600)
            local turret = data.turret[o.palette][o.hatch+1]
            draw(o,b,turret[1],turret[2])
            draw(o,b,images[7][floor(o.cannonAim/2)+1],0x0100fb00)
        end
        if not broken[3] then
            draw(o,c,images[8][frame[3]+1],0xf400f600)
            draw(o,c,images[9][o.portAngle+1],0x01c000c0)
            draw(o,c,images[9][o.portAngle+1],0x01c0f540)
            draw(o,c,images[10][o.portTail+1],0xf400fe00)
        end
    end

    return M,exhaust,drone
end
