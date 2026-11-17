-- 0x188a56 的关底控制器。开场、机臂和首轮炮组分别挂在自己的任务槽中。
return function(program,bullets,art,effects,mounts,coreActors)
    local tasks = dofile('mod/GAME/th44/native/boss_tasks.lua')
    local bit = require('bit')
    local band,bxor = bit.band,bit.bxor
    local abs,floor,min,max = math.abs,math.floor,math.min,math.max
    local s16 = program.s16
    local data = program.boss1
    local M = {parts=9}
    local direct,events,aux,attacks = {},{},{},{}

    local function enter(init,step)
        return {function(o,t) init(o,t); step(o,t) end,step}
    end

    local function request(o,index,profile,h,l,direction)
        o.requested = {index=index,profile=profile,h=h,l=l,direction=direction}
    end

    local distance = mounts.distance

    local function move(o)
        if o.run.freeze then return end
        local dh,dl = program.vector(o.speed,o.heading*4,o.run.slowVectors)
        o.h,o.l = s16(o.h+dh),s16(o.l+dl)
    end

    direct[0] = {function() end,function(o)
        if not o.run.stopPathClock then
            o.speed = min(o.speed,8)
            o.flags = 0xa001
            for index = 1,2 do o.extraParts[index].flags = 0xa001 end
            tasks.attach(o.events,3)
        end
        move(o)
    end}

    direct[1] = {function(o) o.speed = 0 end,move}

    local function wander(o,t)
        local offset = data.offset[program.nextRandom(o.run,63)]
        t.destH,t.destL = program.addPacked(t.h,t.l,offset)
    end

    direct[2] = {function(o,t)
        o.speed,o.heading = 2,t.direction
        wander(o,t)
    end,function(o,t)
        if not o.run.stopPathClock then
            local target = {h=t.destH,l=s16(t.destL-o.run.cameraOffset),active=true}
            o.heading = program.towards(o.heading,program.angle(o.h,o.l,target,o.heading))
            if distance(o,target.h,target.l) <= 0x100 then wander(o,t) end
        end
        move(o)
    end}

    local function approach(o,t)
        local l = s16(t.l-o.run.cameraOffset)
        t.half = floor(distance(o,t.h,l)/2)
        t.reload,t.change = unpack(data.movement[t.profile+1])
        t.clock = 0
        o.heading = program.angle(o.h,o.l,{h=t.h,l=l,active=true},o.heading)
    end

    local function stepApproach(o,t)
        if not o.run.stopPathClock then
            local l = s16(t.l-o.run.cameraOffset)
            local remaining = distance(o,t.h,l)
            if not t.braking then
                o.heading = program.towards(o.heading,program.angle(o.h,o.l,{h=t.h,l=l,active=true},o.heading))
            end
            t.clock = t.clock-1
            if t.clock < 0 then
                t.clock = t.reload
                t.braking = t.braking or remaining < t.half
                o.speed = max(0,o.speed+(t.braking and -t.change or t.change))
            end
            if remaining <= 0x200 then t.braking = true end
            if o.speed == 0 then
                request(o,2,nil,o.h,s16(o.l+o.run.cameraOffset),o.heading)
            end
        end
        move(o)
    end

    direct[3] = {approach,stepApproach}
    direct[8] = {function(o,t)
        approach(o,t)
        tasks.attach(o.aux,o.heading>0x20 and 2 or 3)
    end,stepApproach}

    aux[0] = {function(o)
        o.wingFrame[1],o.wingFrame[2] = (o.wingFrame[1]+4)%0x80,(o.wingFrame[2]+4)%0x80
    end}
    aux[0][2] = aux[0][1]

    aux[1] = enter(function(o,t)
        o.drawParts[1],o.drawParts[2],o.drawParts[3],o.drawParts[4] = true,nil,nil,nil
        o.shellFrame,t.clock = 0,0
    end,function(o,t)
        t.clock = t.clock-1
        if t.clock >= 0 then return end
        t.clock,o.shellFrame = 1,(o.shellFrame+4)%0x20
    end)

    for index = 2,4 do
        aux[index] = enter(function(o,t)
            for other = 1,4 do
                if other ~= index then
                    tasks.stop(o.aux,other)
                    o.drawParts[other] = nil
                end
            end
            o.drawParts[index] = true
            o.shellFrame,t.clock = 0,0
        end,function(o,t)
            t.clock = t.clock-1
            if t.clock >= 0 then return end
            t.clock,o.shellFrame = index==4 and 2 or 4,(o.shellFrame+4)%0x40
            if o.shellFrame ~= 0 then return end
            o.aux[t.slot] = nil
            if not o.drawParts[5] then tasks.attach(o.aux,1) end
        end)
    end

    aux[5] = enter(function(o,t)
        for index = 1,3 do
            tasks.stop(o.aux,index)
            o.drawParts[index] = nil
        end
        o.drawParts[5],o.turnFrame,t.clock,o.finishTurn = true,1,0,false
    end,function(o,t)
        t.clock = t.clock-1
        if t.clock >= 0 then return end
        t.clock,o.turnFrame = 1,o.turnFrame+1
        if o.finishTurn and o.turnFrame > #data.bodyTurn then
            o.drawParts[5],o.aux[t.slot] = nil,nil
            tasks.attach(o.aux,1)
        elseif not o.finishTurn and o.turnFrame == 32 then
            o.turnFrame = 17
        end
    end)

    aux[6] = enter(function(o,t)
        for index = 1,5 do tasks.stop(o.aux,index) end
        for index = 0,5 do o.drawParts[index] = nil end
        o.drawParts[6],o.crackFrame,t.clock = true,0,0
    end,function(o,t)
        t.clock = t.clock-1
        if t.clock >= 0 then return end
        t.clock,o.crackFrame = 3,(o.crackFrame+4)%0x40
        if o.crackFrame ~= 0 then return end
        if not o.dying then o.drawParts[6],o.drawParts[0] = nil,true end
        o.aux[t.slot] = nil
        tasks.attach(o.aux,1)
    end)

    aux[9] = enter(function(o,t)
        o.drawParts[8],o.breakFrame,o.speed,o.heading = true,1,4,0x20
        t.clock,t.reload,t.smoke,t.fragments = 0,2,8,{{7,0x200,-0x200},{6,0x6000800,0x5fff800},{5,0xa000e00,0x9fff200}}
        for _,group in ipairs(t.fragments) do group.clock = 0 end
    end,function(o,t)
        t.smoke = t.smoke-1
        if t.smoke < 0 then
            t.smoke = 5
            effects.emit(o,0x10,0x1e,program.random(o.run,program.randomNarrow)*4,0,false)
        end
        for index,group in ipairs(t.fragments) do
            if group[1] > 0 then
                group.clock = group.clock-1
                if group.clock < 0 then
                    group.clock,group[1] = 0,group[1]-1
                    for side = 1,2 do
                        local speed = 0x10+band(program.random(o.run,program.randomByte),15)
                        local angle = (program.random(o.run,program.randomNarrow)+(side==1 and index-1 or 1-index))*4
                        effects.emit(o,index==3 and 5 or 6,speed,angle,group[side+1],true)
                    end
                end
            end
        end
        t.clock = t.clock-1
        if t.clock >= 0 then return end
        t.clock,o.breakFrame = t.reload,o.breakFrame+1
        if o.breakFrame == 4 then
            t.clock,t.reload,o.breakFrame = 16,3,5
        elseif o.breakFrame > #data.bodyBreaking then
            o.drawParts[8],o.aux[t.slot] = nil,nil
        end
    end)

    local function updateWarning(o,t)
        if t.stage == 0 then
            t.scrollSpeed = min(0x200,t.scrollSpeed+8)
            for _,lane in ipairs(o.run.scroll) do lane.pendingH,lane.pendingL = t.scrollSpeed,lane.lSpeed end
            t.count = t.count-1
            if t.count ~= 0 then return end
            t.stage = 1
        end
        t.clock = t.clock-1
        if t.clock >= 0 then return end
        t.clock = 2
        o.warning = o.warning+4
        if o.warning < 0x40 then return end
        o.drawParts[11],o.drawParts[0],o.drawParts[1] = nil,true,true
        tasks.attach(o.aux,0)
        tasks.attach(o.aux,1)
        o.events[t.slot] = nil
        request(o,0)
    end

    events[0] = enter(function(o,t)
        t.stage,t.clock,t.count,t.scrollSpeed = 0,0,0x40,o.run.scroll[2].hSpeed
        o.drawParts[11] = true
        o.sideChoice = program.random(o.run,program.randomByte)%2
        o.speed = 2
        request(o,3,4,0x5400,0x1c00)
    end,updateWarning)

    -- 0x18b996 与 0x18ba48 在护甲击破后登记两侧爆炸和下一段事件。
    events[1] = enter(function(o,t)
        local speed = o.run.scroll[2].hSpeed
        t.stage,t.wait,t.speed,t.minimum,t.initial = 0,0x10,speed,floor(speed/2),speed
        tasks.attach(o.aux,6)
        for _,rows in ipairs(data.shieldBreak) do effects.emitSequence(o,rows) end
        o.recoil,o.recoilAngle = 0x10,program.random(o.run,program.randomNarrow)
    end,function(o,t)
        if t.stage == 0 then
            t.speed = max(t.minimum,t.speed-8)
            if t.speed > t.minimum then return end
            t.stage = 1
        end
        if t.stage == 1 then
            t.speed = t.speed+8
            if t.speed < t.initial then return end
            t.stage = 2
        end
        t.wait = t.wait-1
        if t.wait ~= 0 then return end
        o.protected = false
        o.events[t.slot] = nil
        tasks.attach(o.events,8)
    end)

    -- 0x18bb7a 先等护甲动画，再卸下机身、等最后一组爆炸及通关计时。
    events[2] = enter(function(o,t)
        request(o,1)
        tasks.stop(o.aux,7)
        tasks.stop(o.aux,8)
        o.core.frame = nil
        tasks.attach(o.aux,6)
        o.recoil,o.recoilAngle = 0x10,program.random(o.run,program.randomNarrow)
        t.stage,t.clearClock = 0,0x10
    end,function(o,t)
        if t.clearClock > 0 then
            t.clearClock = t.clearClock-1
            bullets.clear(o.run,1)
        end
        if t.stage == 5 then
            t.clock = t.clock-1
            if t.clock == 0 then
                o.events[t.slot],o.finished = nil,true
            end
            return
        end
        if t.stage == 4 then
            t.stage,t.clock = 5,0x80
        end
        if t.stage == 3 then
            if tasks.contains(o.aux,9) then return end
            o.drawParts[8] = nil
            t.stage = 4
        end
        if t.stage == 2 then
            for index = 0,7 do o.drawParts[index] = nil end
            tasks.clear(o.aux)
            tasks.attach(o.aux,9)
            for _,offset in ipairs({-0xc00,0xc00}) do
                local direction = (offset < 0 and 0xd0 or 0x30)+program.random(o.run,program.randomNarrow)*2
                for index,kind in ipairs({4,7}) do
                    local angle = direction+floor(program.s8(program.random(o.run,program.randomNarrow))/4)
                    effects.emit(o,kind,index==1 and 10 or 14,angle,band(offset,0xffff),false)
                end
            end
            for _,row in ipairs(data.hullBreak) do
                local delay,kind,_,offset,speed,angle = unpack(row)
                effects.emit(o,kind,speed,angle+program.random(o.run,program.randomNarrow),offset,true,delay,0x400)
            end
            o.recoil,o.recoilAngle,t.stage = 0x20,0x80,3
        end
        if t.stage == 1 and not tasks.contains(o.aux,6) then t.stage = 2 end
        if t.stage == 0 then t.stage = 1 end
    end)

    local function spawnArms(o)
        local c = data.armCallbacks
        local queue = o.run.spawnQueue
        for _,mount in ipairs(o.mounts) do
            mount.reversed = false
            if #queue < 40 then
                queue[#queue+1] = {o.run.major,o.run.minor,0x62,0,0,0,0,c[1],c[2],c[3],
                    h=o.h,l=o.l,boss=o,mount=mount}
            end
        end
    end

    local function fireArms(o,t)
        for _,mount in ipairs(o.mounts) do
            mount.volleys = t.armVolleys
            if mount.arm then mount.arm.mode = 8 end
        end
        t.armVolleys = min(6,t.armVolleys+1)
    end

    local function randomDestination(o,t)
        local dh = floor(data.displacement[program.nextRandom(o.run,127)]/2)
        local dl = min(0x1000,max(0x800,abs(data.displacement[program.nextRandom(o.run,127)])))
        t.side = 1-t.side
        request(o,8,t.profile,0x5400+dh,0x1c00+(t.side==1 and dl or -dl))
        t.profile = min(4,t.profile+1)
    end

    local function beginMainVolley(o,t)
        if t.remaining == 1 then o.cannonSpread = min(3,o.cannonSpread+1) end
        tasks.attach(o.attacks,2,{waves=o.cannonWaves,spread=o.cannonSpread})
        o.cannonWaves = min(9,o.cannonWaves+1)
        t.remaining = t.remaining-1
        t.stage = 3
        if t.remaining > 0 then return end
        t.stage = 5
        request(o,8,2,0x5400,0x1c00)
    end

    -- 0x18bf80 暂停、放出机臂、跟踪自机，然后两次边移动边发弹。
    events[3] = enter(function(o,t)
        t.stage,t.clock,t.side,t.profile,t.remaining,t.armVolleys = 0,0x20,1,1,2,3
        t.spin,t.heading,t.rotation = 0,0x80,1
        request(o,3,1,0x5400,0x1c00)
    end,function(o,t)
        if t.stage == 8 then
            if not mounts.ready(o.mounts) then return end
            t.clock = t.clock-1
            if t.clock >= 0 then return end
            o.events[t.slot] = nil
            tasks.attach(o.events,4+o.sideChoice)
            o.sideChoice = 1-o.sideChoice
            return
        end
        if t.stage >= 3 then
            local aim = program.angle8(o.h,o.l,o.run.player,t.heading)
            local delta = band(aim-t.heading,255)
            if delta ~= 0 then t.heading = band(t.heading+(delta<128 and 1 or -1),255) end
            t.spin = band(t.spin+t.rotation,255)
            if t.ramp then
                t.ramp = t.ramp-1
                if t.ramp < 0 then t.rotation,t.ramp = min(5,t.rotation+1),12 end
            end
        end
        for _,mount in ipairs(o.mounts) do mounts.place(o,mount,t.spin,t.heading,0xa0) end
        if t.stage == 0 then
            t.clock = t.clock-1
            if t.clock >= 0 then return end
            o.protected = false
            spawnArms(o)
            t.stage,t.clock = 1,0x10
        end
        if t.stage == 1 then
            t.clock = t.clock-1
            if t.clock >= 0 then return end
            t.stage = 2
        end
        if t.stage == 2 then
            if not mounts.ready(o.mounts) then return end
            fireArms(o,t)
            t.stage = 3
        end
        if t.stage == 3 then
            if tasks.contains(o.attacks,2) then return end
            if mounts.ready(o.mounts) then fireArms(o,t) end
            if o.phase ~= 2 then return end
            randomDestination(o,t)
            t.stage = 4
        end
        if t.stage == 4 then
            if o.phase == 2 then beginMainVolley(o,t) end
            return
        end
        if t.stage == 5 then
            if not mounts.ready(o.mounts) or tasks.contains(o.attacks,2) or o.phase ~= 2 or o.requested then return end
            t.stage,t.clock,t.ramp = 6,0x24,0
        end
        if t.stage == 6 then
            t.clock = t.clock-1
            if t.clock >= 0 then return end
            tasks.attach(o.aux,4)
            local sign = program.random(o.run,program.randomByte)%2 == 0 and 1 or -1
            tasks.attach(o.attacks,4,{drift=sign*10,extra=o.arcLayers})
            o.arcLayers = min(4,o.arcLayers+1)
            t.stage,t.clock = 7,0x20
        end
        if t.stage == 7 and t.rotation == 5 then
            t.clock = t.clock-1
            if t.clock >= 0 then return end
            local c,queue = data.carrierCallbacks,o.run.spawnQueue
            if #queue < 40 then
                queue[#queue+1] = {o.run.major,o.run.minor,0x64,0,0,0,0,c[1],c[2],c[3],
                    h=o.h,l=o.l,boss=o,aim=t.heading,spin=t.spin,rotation=t.rotation,ramp=o.carrierRamp}
            end
            o.carrierRamp = min(0x20,o.carrierRamp+2)
            for _,mount in ipairs(o.mounts) do
                if mount.arm then mount.arm.mode = 12 end
            end
            t.stage,t.clock = 8,0x40
        end
    end)

    events[4] = enter(function(o,t)
        request(o,3,1,0x5400,0x1c00)
        t.cannonClock,t.cannonGap,t.sweepClock,t.sweepGap,t.waves = 0x50,0x1a,0x10,0x20,3
        t.rays = 7
        t.drift = program.random(o.run,program.randomByte)%2 == 0 and -0x10 or 0x10
        tasks.attach(o.aux,5)
    end,function(o,t)
        if not tasks.contains(o.attacks,5) then
            t.sweepClock = t.sweepClock-1
            if t.sweepClock < 0 then
                tasks.attach(o.attacks,5,{drift=t.drift})
                t.drift,t.sweepClock,t.sweepGap = -t.drift,t.sweepGap,max(8,t.sweepGap-2)
            end
        end
        if t.waves > 0 and not tasks.contains(o.attacks,1) then
            t.cannonClock = t.cannonClock-1
            if t.cannonClock < 0 then
                tasks.attach(o.attacks,1,{rays=t.rays})
                t.cannonClock,t.rays,t.waves = t.cannonGap,max(2,t.rays-4),t.waves-1
            end
        end
        if t.waves == 0 and not tasks.contains(o.attacks,1) and not tasks.contains(o.attacks,5) then
            o.finishTurn,o.events[t.slot] = true,nil
            tasks.attach(o.events,3)
        end
    end)

    events[5] = enter(function(o,t)
        request(o,3,1,0x5400,0x1c00)
        t.clock,t.waves,t.drift = 0x10,4,14
    end,function(o,t)
        if tasks.contains(o.attacks,0) then return end
        if t.waves == 0 then
            o.events[t.slot] = nil
            tasks.attach(o.events,3)
            return
        end
        t.clock = t.clock-1
        if t.clock < 0 then
            tasks.attach(o.attacks,0,{drift=t.drift})
            t.clock,t.waves,t.drift = 0xc,t.waves-1,-t.drift
        end
    end)

    local function escortMode(o,mode)
        for _,mount in ipairs(o.escorts) do
            if mount.escort then mount.mode = mode end
        end
    end

    local function escortsReady(o,mode)
        for _,mount in ipairs(o.escorts) do
            if mount.escort and mount.mode ~= mode then return false end
        end
        return true
    end

    -- 0x189b72 给四台护航机登记各自的半径、倾角和旋转步进。
    local function initEscortMounts(o)
        local run = o.run
        local direction = program.random(run,program.randomByte)
        local yawStep = program.s8(program.random(run,data.rotationSteps))
        o.escorts = {}
        for index = 1,4 do
            local yaw = program.random(run,program.randomByte)
            local tiltStep = program.s8(program.random(run,data.rotationSteps))
            local spinStep = program.s8(program.random(run,data.rotationSteps))
            local angle = band(direction+program.random(run,program.randomNarrow)*2,255)
            local sin,cos = unpack(data.trig[angle+1])
            local radius = 50+(index-1)*15
            o.escorts[index] = {index=index,mode=4,x=sin*radius,y=cos*radius,z=0,yaw=yaw,spin=0,tilt=0,
                yawStep=yawStep,tiltStep=tiltStep,spinStep=spinStep}
            direction,yawStep = direction+0x40,-yawStep
        end
    end

    -- 0x18cb5c 先部署四台护航机，等各机到位再开始环绕炮击。
    events[8] = enter(function(o,t)
        t.stage,t.clock,t.side = 0,0x20,1
        if not o.escortsDeployed then initEscortMounts(o) end
        o.escortsVisible = true
        request(o,3,1,0x5400,0x1c00)
    end,function(o,t)
        if o.phase == 2 and not o.requested then
            local h = 0x5200+floor(data.displacement[program.nextRandom(o.run,127)]/4)
            local l = min(0xe00,abs(data.displacement[program.nextRandom(o.run,127)]))
            t.side = 1-t.side
            request(o,3,2,h,0x1c00+(t.side==1 and l or -l))
        end
        for _,mount in ipairs(o.escorts) do
            mounts.place(o,mount,mount.spin,mount.yaw,mount.tilt)
            if t.rotate then
                mount.yaw = band(mount.yaw+mount.yawStep,255)
                mount.tilt = band(mount.tilt+mount.tiltStep,255)
                mount.spin = band(mount.spin+mount.spinStep,255)
            end
        end
        if t.stage == 0 then
            t.clock = t.clock-1
            if not o.escortsDeployed and t.clock >= 0 then return end
            if o.escortsDeployed then escortMode(o,4)
            else
                local c,queue = data.escortCallbacks,o.run.spawnQueue
                for _,mount in ipairs(o.escorts) do
                    if #queue < 40 then
                        queue[#queue+1] = {o.run.major,o.run.minor,0x61,0,0,0,0,c[1],c[2],c[3],
                            h=o.h,l=o.l,boss=o,mount=mount}
                    end
                end
            end
            t.stage,t.clock = 1,1
            return
        end
        if t.stage == 1 then
            if not escortsReady(o,0) then return end
            t.rotate = true
            t.clock = t.clock-1
            if t.clock >= 0 then return end
            escortMode(o,o.coreExposed and 8 or 12)
            t.stage,t.clock = 2,o.coreExposed and 0x90 or 0x80
        end
        if t.stage == 2 then
            t.clock = t.clock-1
            if t.clock >= 0 then return end
            escortMode(o,0)
            t.stage,t.clock = 3,8
        end
        if t.stage == 3 then
            t.clock = t.clock-1
            if t.clock >= 0 then return end
            o.escortsDeployed,o.events[t.slot] = true,nil
            tasks.attach(o.events,7)
        end
    end)

    local coreEvent,coreDirect,coreAux,coreAttacks,drawCore = dofile('mod/GAME/th45/native/boss1_core_tasks.lua')(
        program,art,coreActors,mounts,tasks,enter,request,move,escortMode,escortsReady)
    events[7] = coreEvent
    for index,task in pairs(coreDirect) do direct[index] = task end
    for index,task in pairs(coreAux) do aux[index] = task end
    for index,task in pairs(coreAttacks) do attacks[index] = task end

    local function shot(o,angle)
        local offset = program.dualCannon.muzzle[floor(band(angle+2,0xfc)/4)+1]+0xfc000000
        local dh,dl = program.addPacked(0,0,offset)
        bullets.emit(o,2,1,angle,dh,dl,true)
    end

    local function sideSweep(o,t)
        t.waves,t.clock,t.angle = t.index==0 and 22 or 16,0,0x80
        t.h,t.l = 0xc00,t.drift<0 and 0x900 or -0x900
        if t.index==5 then
            local target = o.run.player
            if not target or not target.active then return end
            t.angle = program.angle8(s16(o.h+t.h),s16(o.l+t.l),target,t.angle)
        end
        t.angle = t.angle+program.random(o.run,program.randomNarrow)
    end

    local function doneWave(o,t)
        t.angle,t.waves = t.angle+t.drift,t.waves-1
        if t.waves == 0 then o.attacks[t.slot] = nil end
    end

    attacks[0] = enter(sideSweep,function(o,t)
        t.clock = t.clock-1
        if t.clock >= 0 then return end
        t.clock = 1
        for ray = 1,2 do bullets.emit(o,1,-2,t.angle+ray*3,t.h,t.l,true) end
        for modifier = -6,-5 do bullets.emit(o,15,modifier,t.angle,t.h,t.l,true) end
        doneWave(o,t)
    end)

    attacks[1] = enter(function(o,t)
        t.clock,t.groupClock,t.angle,t.shootAngle = 0,0,program.angle8(o.h,o.l,o.run.player,0x80),0
        t.shootAngle = t.angle+0x48
        t.rayCount,t.modifier,t.fireGap = 0,5,t.rays==2 and 1 or 3
    end,function(o,t)
        if t.rayCount == 0 then
            t.groupClock = t.groupClock-1
            if t.groupClock >= 0 then return end
            t.groupClock,t.rayCount = 0,t.rays
            local delta = band(t.angle-t.shootAngle+128,255)-128
            local step = t.rays*2+4
            t.shootAngle = t.shootAngle+max(-step,min(step,delta))
            if not t.merged and band(t.shootAngle-t.angle,255) == 0 then
                t.merged,t.groupClock = true,8
            end
        end
        t.clock = t.clock-1
        if t.clock >= 0 then return end
        t.clock = t.fireGap
        bullets.emit(o,13,t.modifier,t.shootAngle,-0x400,-0x200,true)
        bullets.emit(o,13,t.modifier,2*t.angle-t.shootAngle,-0x400,0x200,true)
        t.rayCount = t.rayCount-1
        if t.rayCount == 0 and t.merged then o.attacks[t.slot] = nil end
    end)

    attacks[5] = enter(sideSweep,function(o,t)
        if o.run.blockEnemyFire then return end
        t.clock = t.clock-1
        if t.clock >= 0 then return end
        t.clock = 1
        for ray,modifier in ipairs({2,2,-3,-3,2,2}) do
            local delta = ({2,4,4,6,6,8})[ray]
            bullets.emit(o,10,modifier,t.angle+delta,t.h,t.l,true)
        end
        doneWave(o,t)
    end)

    attacks[2] = enter(function(_,t)
        t.fireClock,t.gap,t.angle = 0,11,0x80
    end,function(o,t)
        t.fireClock = t.fireClock-1
        if t.fireClock >= 0 then return end
        if not t.started then
            t.angle = program.angle8(o.h,o.l,o.run.player,t.angle)
            t.started = true
        end
        t.fireClock = 4
        shot(o,t.angle)
        for _,side in ipairs({1,-1}) do
            for ray = 1,t.spread+2 do shot(o,t.angle+side*ray*t.gap) end
        end
        t.gap,t.waves = t.gap+1,t.waves-1
        if t.waves == 0 then o.attacks[t.slot] = nil end
    end)

    -- 0x18db96 用相邻的两个炮口角组成一组，附加弹逐颗提高三档速度。
    attacks[4] = enter(function(o,t)
        t.clock,t.waves = 0,0x10
        t.angle = program.angle8(o.h,o.l,o.run.player,0x80)+t.drift*8
    end,function(o,t)
        t.clock = t.clock-1
        if t.clock >= 0 then return end
        t.clock = 1
        local angle,delta = t.angle,t.drift/2
        for index = 0,t.extra+1 do
            local offset = program.mid1.ringOffsets[floor(band(angle+2,0xfc)/4)+1]+0xfc000000
            local dh,dl = program.addPacked(0,0,offset)
            bullets.emit(o,22,-9+index*3,angle,dh,dl,true)
            angle,delta = angle-delta,-delta
        end
        t.angle,t.waves = t.angle-t.drift,t.waves-1
        if t.waves == 0 then o.attacks[t.slot] = nil end
    end)

    function M.init(o)
        local run = o.run
        o.h,o.l,o.speed,o.heading = 0xa00,s16(0x4600-run.cameraOffset),0x10,0
        o.extraParts = {}
        for i,row in ipairs(data.parts) do
            local flags,front,back,right,left,hp = unpack(row)
            local part = i == 1 and o or {h=o.h,l=o.l}
            part.flags,part.front,part.back,part.right,part.left,part.hp = flags,front,back,right,left,hp
            if i > 1 then o.extraParts[i-1] = part end
        end
        o.core,o.corePalette = o.extraParts[3],17
        o.hullParts = {o,o.extraParts[1],o.extraParts[2]}
        o.mounts = {}
        for index = 1,2 do
            local angle = (index-1)*128
            o.mounts[index] = {index=index,h=o.h,l=o.l,angle=angle,x=0,y=data.trig[angle+1][2]*40,z=0,depth=0}
        end
        o.drawParts,o.wingFrame = {},{0,0}
        o.palette,o.wingPalette,o.warning,o.shellFrame = 19,11,0,0
        o.health,o.threshold,o.finalThreshold,o.clock = data.health[1],data.health[2],data.health[3],data.timeout
        o.cannonWaves,o.cannonSpread,o.arcLayers,o.carrierRamp,o.protected = 4,0,2,data.carrierRamp,true
        o.aux = {handlers=aux,limit=25,unique=true,label='Espgaluda 一面关底部件'}
        o.events = {handlers=events,limit=5,label='Espgaluda 一面关底事件'}
        o.attacks = {handlers=attacks,limit=20,label='Espgaluda 一面关底攻击'}
        initEscortMounts(o)
        tasks.attach(o.events,0)
        run.boss,run.bulletCapacity = o,150
        return true
    end

    local function breakArmor(o)
        if o.threshold > 0 then o.finalThreshold = min(data.health[1],o.finalThreshold+o.threshold) end
        o.threshold,o.protected,o.armDestroyed,o.clock = -1,true,true,data.timeout
        tasks.clear(o.events)
        tasks.clear(o.attacks)
        bullets.clear(o.run,0x10)
        tasks.attach(o.events,1)
    end

    local function destroy(o)
        o.health,o.flags,o.dying,o.protected,o.armDestroyed = -1,0x8000,true,true,true
        for index = 1,3 do o.extraParts[index].flags = 0x8000 end
        tasks.clear(o.events)
        tasks.clear(o.attacks)
        bullets.clear(o.run,0x10)
        tasks.attach(o.events,2)
    end

    local function damage(o)
        if o.dying then return end
        -- 0x18e3dc 先取仍挂载部件的最大伤害，再与机身命中相加。
        local total = 0
        for _,group in ipairs({o.mounts,o.escorts}) do
            for _,mount in ipairs(group) do
                local part = mount.arm or mount.escort
                if part then
                    if part.impact then total = max(total,band(0x7fff-part.hp,0xffff)) end
                    if part.second.impact then total = max(total,band(0x7fff-part.second.hp,0xffff)) end
                end
            end
        end
        local hit = total > 0
        local core = o.core
        if o.armDestroyed and core.impact then
            hit = true
            total = total+(core.damage or 0)
            core.impact,core.damage,core.hp = nil,0,0x7fff
            core.flags = band(core.flags,0xa6ff)
        end
        for _,p in ipairs(o.hullParts) do
            if p.impact then hit = true end
            total = total+(p.damage or 0)
            p.impact,p.damage,p.hp = nil,0,0x7fff
            p.flags = band(p.flags,0xa6ff)
        end
        o.palette,o.wingPalette,o.corePalette = 19,11,17
        if not hit then return end
        o.palette,o.wingPalette = bxor(o.palette,0xc),bxor(o.wingPalette,0x14)
        o.corePalette = 31
        if o.protected then return end
        total = band(total,0xffff)
        o.health = o.health-total
        if o.armDestroyed then
            o.finalThreshold = o.finalThreshold-total
            if o.finalThreshold < 0 then destroy(o) end
            return
        end
        o.threshold = o.threshold-total
        if o.threshold >= 0 then return end
        breakArmor(o)
    end

    function M.step(o)
        if o.finished then
            o.run.stageCleared = true
            return false
        end
        if not o.run.freeze and not o.run.stopPathClock then
            if not o.dying then o.clock = o.clock-1 end
            tasks.tick(o,o.aux)
            tasks.tick(o,o.events)
        end
        if o.requested then
            local t = o.requested
            o.requested,o.motion,o.phase = nil,t,t.index
            direct[o.phase][1](o,t)
        end
        if o.motion then direct[o.phase][2](o,o.motion) end
        for index = 1,2 do o.extraParts[index].h,o.extraParts[index].l = o.h,o.l end
        if not o.run.freeze and not o.run.stopPathClock then tasks.tick(o,o.attacks) end
        damage(o)
        if o.clock == 0 and not o.dying then
            if not o.run.player or not o.run.player.active then o.clock = 0x78
            elseif o.armDestroyed then destroy(o)
            else breakArmor(o) end
        end
        if (o.recoil or 0)>0 then
            local dh,dl = program.vector(o.recoil,o.recoilAngle)
            o.h,o.l = s16(o.h+dh),s16(o.l+dl)
            o.recoil = o.recoil-1
        end
        return true
    end

    function M.render(o)
        local assets = o.run.art
        if not assets then return end
        local sprites,draw = assets.sprites,o.drawParts
        local function image(id,offset,flip)
            local h,l = program.addPacked(o.h,o.l,offset)
            art.draw(sprites[id],h,l,0,0,flip)
        end
        if draw[11] then
            local frame = floor(o.warning/4)+1
            local id,offset,split = unpack(data.warningWings[frame])
            if split == 0 then image(id,0x07c00000+offset)
            else
                image(id,0x0a400e00+offset,true)
                image(id,0x0a3ff200+offset)
            end
            image(data.warningBody[frame],0x01400000+0xf400f600)
        end
        if draw[6] then
            local frame = floor(o.crackFrame/4)+1
            local offset = 0xe000f100+0x0afff100
            if not o.dying then
                image(data.wingCrack[frame],offset+0x1e00,true)
                image(data.wingCrack[frame],offset)
            end
            image(data.shell[o.palette][5][frame],0xf500f700)
        end
        if draw[8] then
            local frame = data.bodyBreaking[o.breakFrame]
            art.draw(sprites[frame[1]],s16(o.h+frame[2]),s16(o.l+frame[3]),0,0)
        end
        if draw[5] then image(data.bodyTurn[o.turnFrame],data.turnOffsets[o.turnFrame]) end
        local shellOffset = {0xf800fc00,0xf700fa00,0xf500f900,0xf680fa00}
        for index = 4,1,-1 do
            if draw[index] then
                image(data.shell[o.palette][index][floor(o.shellFrame/4)+1],shellOffset[index])
            end
        end
        if draw[0] then
            local wing = data.wing[o.wingPalette]
            local offset = 0xea00f100+0x0afff100
            image(wing[floor(o.wingFrame[2]/4)+1],offset+0x1e00,true)
            image(wing[floor(o.wingFrame[1]/4)+1],offset)
        end
        drawCore(o)
    end

    return M
end
