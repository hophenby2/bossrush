-- E3 重组装甲，E12 在机身十二处发弹点和中央炮之间独立推进。
return function(program,art,effects,tasks,events,attacks,moveTo,startDrift,activeMove,emit)
    local band=require('bit').band
    local floor,abs=math.floor,math.abs
    local data=program.boss6

    local function armorPort(o,t)
        t.clock=t.clock-1
        if t.clock>=0 then return end
        t.clock=0x14
        local angle=0x80+program.s8(program.random(o.run,program.randomNarrow))
        local speed=program.s8(program.random(o.run,program.randomNarrow))
        emit(o,0,speed,angle,t.offset)
        t.count=t.count-1
        if t.count==0 then o.attacks[t.slot]=nil end
    end
    attacks[11]={function(o,t)
        t.count,t.clock=6,0
        armorPort(o,t)
    end,armorPort}

    local function aimSweep(o,t)
        t.clock=t.clock-1
        if t.clock>=0 then return end
        t.clock=9
        local p=o.run.player
        if p and p.active then
            local target=program.angle8(o.h,o.l,p,t.aim)
            local delta=band(target-t.aim+0x80,0xff)-0x80
            t.aim=band(t.aim+math.max(-3,math.min(3,delta)),255)
            local center=t.aim+t.swivel
            for _,delta in ipairs({0,t.spread,2*t.spread,-t.spread,-2*t.spread}) do
                local angle=center+delta
                local offset=data.finalArmorSweep[floor(band(angle+2,255)/4)+1]
                emit(o,0xd,2,angle,offset-0x4000000)
            end
            t.swivel=t.swivel+t.turn
            if abs(t.swivel)>t.limit then
                t.turn,t.limit=-t.turn,math.max(2,t.limit-8)
            end
            t.spread=t.spread+t.spreadStep
            if t.spread==2 or t.spread==16 then t.spreadStep=-t.spreadStep end
        end
        t.count=t.count-1
        if t.count==0 then o.attacks[t.slot]=nil end
    end
    attacks[12]={function(o,t)
        program.nextRandom(o.run)
        t.clock,t.aim=0,program.angle8(o.h,o.l,o.run.player,0x80)
        t.swivel,t.turn,t.limit,t.spread,t.spreadStep=0,4,0x20,2,1
        aimSweep(o,t)
    end,aimSweep}

    local function fan(o,t)
        t.clock=t.clock-1
        if t.clock>=0 then return end
        t.clock=t.period
        local jitter
        repeat jitter=program.s8(program.random(o.run,program.randomNarrow)) until jitter~=t.jitter
        t.jitter=jitter
        local angle=program.angle8(o.h,o.l,o.run.player,0x80)+jitter*4
        for _,side in ipairs({-1,1}) do
            for width=6,24,3 do emit(o,0xb,t.speed,angle+side*width,-0x4000000) end
        end
        t.count=t.count-1
        if t.count==0 then o.attacks[t.slot]=nil end
    end
    attacks[13]={function(o,t)
        t.clock,t.jitter=0,-9
        fan(o,t)
    end,fan}

    local function armorPattern(o,t)
        if t.phase==0 then
            if not activeMove(o) then return end
            startDrift(o,1)
            t.phase=1
        end
        t.clock=t.clock-1
        if t.clock<0 then
            t.clock=0x10
            local port=data.finalArmorOrder[t.port]+1
            tasks.attach(o.attacks,11,{offset=data.finalArmorPorts[port]})
            t.port=t.port%12+1
        end
        if t.phase==1 then
            t.wait=t.wait-1
            if t.wait<0 then
                t.phase,t.wait,o.armorCharge=2,0x40,1
                t.poseClock=1
                program.nextRandom(o.run)
            end
        end
        if t.phase==2 then
            t.wait=t.wait-1
            if t.wait<0 then
                if t.sweep then
                    tasks.attach(o.attacks,12,{count=0x40})
                else
                    tasks.attach(o.attacks,13,{count=t.fans,period=t.period,speed=t.speed})
                    t.fans,t.period,t.speed=math.min(8,t.fans+2),math.max(0x18,t.period-8),math.min(0,t.speed+2)
                end
                t.phase,t.sweep=3,not t.sweep
            end
        end
        if t.phase==3 and not tasks.contains(o.attacks,12) and not tasks.contains(o.attacks,13) then
            t.phase=4
        end
        if o.armorCharge then
            t.poseClock=t.poseClock-1
            if t.poseClock<0 then
                t.poseClock=1
                o.armorCharge=o.armorCharge+1
                if t.phase==4 then
                    if o.armorCharge>=29 then
                        o.armorCharge,t.phase,t.wait=nil,1,0x40
                    end
                elseif o.armorCharge>=20 then o.armorCharge=12 end
            end
        end
    end
    events[12]={function(o,t)
        t.phase,t.port,t.clock,t.wait=0,1,0,0x40
        t.sweep,t.fans,t.period,t.speed=true,4,0x28,-8
        moveTo(o,0x5800,0x1c00,1)
        armorPattern(o,t)
    end,armorPattern}

    local function reassemble(o,t)
        t.reassemblyClock=t.reassemblyClock-1
        if t.period>0 then
            t.debrisClock=t.debrisClock-1
            if t.debrisClock<0 then
                t.debrisClock=2
                local run=o.run
                local l=0x1c00+program.hovercraftRandom[program.nextRandom(run,127)]
                run.spawnQueue[#run.spawnQueue+1]={0,0,0x4c,0,0,0,0,0,0,0x1a7ac0,
                    h=0x7800,l=l,owner=o}
            end
            t.pulse=t.pulse-1
            if t.pulse<0 then t.pulse,t.period=t.period,t.period-2 end
        end
    end

    local function fourthForm(o,t)
        if t.phase==0 then
            t.clock=t.clock-1
            if t.clock>=0 then return end
            moveTo(o,0x5600,0x1c00,2)
            t.phase=1
        end
        if t.phase==1 and activeMove(o) then
            t.phase,t.reassemblyClock,t.period,t.pulse,t.debrisClock=2,270,24,24,0
            return
        end
        if t.phase==2 then
            reassemble(o,t)
            if t.reassemblyClock>0 then return end
            t.phase,t.clock=3,79
            o.armorFrame,o.armorAge=0,0
            return
        end
        if t.phase==3 then
            t.clock=t.clock-1
            o.armorFrame=floor((80-t.clock)/2)
            if t.clock>0 then return end
            o.protected,o.flags=false,0xa001
            for i=2,13 do o.extraParts[i].flags=0xa001 end
            tasks.attach(o.events,12)
            o.events[t.slot]=nil
        end
    end
    events[3]={function(o,t)
        o.flags,o.extraParts[1].flags,o.speed=0x8000,0x8000,0
        t.phase,t.clock=0,42
    end,fourthForm}

    local function detachedPort(o,t)
        t.clock=t.clock-1
        if t.clock>=0 then return end
        t.clock=t.reload
        local offset=t.left and t.leftPort or t.rightPort
        local heading=t.fixed and 0x80 or (t.left and 0x60 or 0xa0)
        local run=o.run
        local h,l=program.addPacked(o.h,o.l,offset)
        run.spawnQueue[#run.spawnQueue+1]={0,0,0x7f,0,0,0,0,0,0,0x1a7774,
            h=h,l=l,heading=heading,speed=t.speed,fixed=t.fixed,bullet=t.bullet,period=t.period}
        if t.fixed then
            t.period,t.reload=math.max(9,t.period-2),math.max(0x40,t.reload-4)
        end
        t.left=not t.left
    end
    attacks[14]={function(o,t)
        t.clock,t.reload,t.fixed,t.speed,t.bullet,t.period=0x80,0x80,true,0x23,0x24,0x10
        t.left,t.leftPort,t.rightPort=true,0xf8bfed80,0xf8c01280
        detachedPort(o,t)
    end,detachedPort}
    attacks[15]={function(o,t)
        t.clock,t.reload,t.fixed,t.speed,t.bullet=0,0x40,false,0x10,0x23
        t.left,t.leftPort,t.rightPort=true,0x0dbff300,0x0dc00d00
        detachedPort(o,t)
    end,detachedPort}

    local function detachedSweep(o,t)
        local offset=data.finalArmorFanPorts[t.port]
        if t.count==0 then
            t.clock=t.clock-1
            if t.clock>=0 then return end
            t.clock,t.count=0x20,5
            local h,l=program.addPacked(o.h,o.l,offset)
            t.aim=program.angle8(h,l,o.run.player,0x80)
        end
        t.interval=t.interval-1
        if t.interval>=0 then return end
        t.interval=4
        emit(o,0xe,0,t.aim,offset)
        t.count=t.count-1
        if t.count==0 then t.port=t.port%4+1 end
    end
    attacks[16]={function(o,t)
        t.port=band(program.random(o.run,program.randomByte),3)+1
        t.clock,t.count,t.interval=0x40,0,0
        detachedSweep(o,t)
    end,detachedSweep}

    -- E13 等 0x1a35f4 的换装完毕，再等 0x40 到期才重新接受伤害。
    local function fifthForm(o,t)
        if t.phase==0 then
            t.clock=t.clock-1
            o.breakPose=math.min(16,1+floor((43-t.clock)/3))
            if t.clock>0 then return end
            moveTo(o,0x5400,0x1c00,1)
            t.phase,t.clock=1,0x40
        end
        if t.phase~=1 then return end
        t.clock=t.clock-1
        if t.clock>=0 then return end
        for i=14,16 do tasks.attach(o.attacks,i) end
        moveTo(o,0x5400,0x1c00,1)
        o.events[t.slot],o.protected=nil,false
    end
    events[13]={function(o,t)
        o.armorCharge,o.breakPose=nil,1
        moveTo(o,0x5400,0x1c00,1)
        o.recoil,o.recoilAngle=0x18,program.random(o.run,program.randomNarrow)
        t.phase,t.clock=0,43
    end,fifthForm}

    local function advanceBlastRandom(effect)
        for _=1,5 do program.nextRandom(effect.run) end
    end

    local function detach(o,index,angle,rows)
        local p=o.extraParts[index]
        p.flags,p.broken=0x8000,true
        angle=angle+2*program.s8(program.random(o.run,program.randomNarrow))
        local origin={run=o.run,h=p.h,l=p.l}
        local sprays={{4,10,0},{7,14,1},{4,20,2},{5,28,3},{5,36,6}}
        for _,spray in ipairs(sprays) do
            local kind,speed,delay=unpack(spray)
            local jitter=program.s8(program.random(o.run,program.randomNarrow))
            effects.emit(origin,kind,speed,angle+floor(jitter/4),0,false,delay)
        end
        for _,row in ipairs(rows) do
            local delay,kind,offset,motion=unpack(row)
            local jitter=program.s8(program.random(o.run,program.randomNarrow))
            local blast=effects.emit(origin,kind,floor(motion/256),band(motion+jitter,255),offset,false,delay)
            -- 0x17a0ea 在爆破到期时给伴生粒子取五个随机参数。
            if blast then blast.onStart=advanceBlastRandom end
        end
    end

    local function breakArmor(o)
        o.armorFrame=42
        for _,index in ipairs({2,8}) do
            local p=o.extraParts[index]
            p.flags,p.broken=0x8000,true
        end
        detach(o,7,0x90,data.finalArmorBlasts[1])
        detach(o,13,0x70,data.finalArmorBlasts[2])
    end

    local function breakWings(o)
        o.armorFrame,o.run.finalPortsPurge=44,true
        detach(o,3,0xe0,data.finalArmorBlasts[3])
        detach(o,9,0x20,data.finalArmorBlasts[4])
        detach(o,6,0xa0,data.finalArmorBlasts[5])
        detach(o,12,0x60,data.finalArmorBlasts[6])
    end

    local function breakCore(o)
        o.armorFrame,o.armorCharge=0,nil
        detach(o,4,0xd0,data.finalArmorBlasts[3])
        detach(o,10,0x30,data.finalArmorBlasts[4])
        detach(o,5,0x90,data.finalArmorBlasts[5])
        detach(o,11,0x70,data.finalArmorBlasts[6])
    end

    local wide={[4]=true,[6]=true,[10]=true,[12]=true}
    local function render(o)
        local images,sprites=data.images,o.run.art.sprites
        local frame,suffix=o.armorFrame+1,o.tint or ''
        local function draw(part,image,offset,flip)
            local h,l=program.addPacked(part.h,part.l,offset)
            art.draw(sprites[image],h,l,0,0,flip)
        end
        local wing=images.finalArmorWings[frame]
        if o.armorFrame>0 then
            draw(o,wing[1],wing[2],false)
            draw(o,wing[1],wing[3],true)
        end
        if frame>=41 then
            local age=o.armorAge
            local jointFrame=math.min(30,1+floor(age/2))
            local joint=images['finalArmorJoint'..suffix][jointFrame]
            local wideJoint=images['finalArmorJointWide'..suffix][jointFrame]
            for i=2,13 do
                local p=o.extraParts[i]
                if not p.broken then
                    draw(p,wide[i] and wideJoint or joint,wide[i] and 0xfa00fc00 or 0xfc00fd00,false)
                end
            end
            if o.armorCharge then
                local charge=images['finalArmorCharge'..suffix][o.armorCharge]
                draw(o,charge[1],charge[2],false)
            elseif o.breakPose then
                draw(o,images['finalArmorBreak'..suffix][o.breakPose],0xf080f700,false)
            else
                draw(o,images['finalArmorBody'..suffix][floor(age/2)%8+1],0xf600f800,false)
            end
        else
            local center=images.finalArmorCenter[frame]
            draw(o,center[1],center[2],false)
        end
    end

    return {render=render,breakArmor=breakArmor,breakWings=breakWings,breakCore=breakCore}
end
