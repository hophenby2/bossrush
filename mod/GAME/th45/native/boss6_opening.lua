-- 0x1a7e60 的前段随卷轴减速。舰身、四个翼侧部件和伴飞机分槽登记。
return function(program,bullets,art,effects,ring)
    local tasks=dofile('mod/GAME/th44/native/boss_tasks.lua')
    local bit=require('bit')
    local band=bit.band
    local s16,floor=program.s16,math.floor
    local data=program.boss6
    local wreck=dofile('mod/GAME/th45/native/boss6_wreck.lua')(program,effects,art,tasks)
    local damage=dofile('mod/GAME/th45/native/boss6_damage.lua')(program,bullets,effects,tasks,wreck)
    local H,Escort={parts=13},{parts=1}
    local events,aux,attacks={},{},{}
    local attach,contains=tasks.attach,tasks.contains
    local mountOffsets={0x16bff040,0x16c00fc0,0x243ff540,0x24400ac0}
    local coverOffsets={{0xdfbffa40+0xf600fa00,0xdfc005c0+0xf600fa00},
        {0xe5fff4c0+0xf600f900,0xe6000b40+0xf600f900},{0xf63ff540+0xf600f900,0xf6400ac0+0xf600f900}}
    ring.install(tasks,events,aux)
    events[3]=wreck.event

    local function scrollTo(o,stop)
        -- V100 第 85503 帧到 0x4800。原生卷轴的换速发生在下一帧，补齐这段末速差。
        local h=s16(o.h+o.run.groundScroll)
        o.h=o.h>=stop and math.max(stop,h) or h
    end

    function H.init(o)
        o.h,o.l=s16(0xa400),s16(0x1c00-o.run.cameraOffset)
        o.extraParts={}
        for i,row in ipairs(data.parts) do
            local p=i==1 and o or {h=0,l=0}
            p.flags,p.front,p.back,p.right,p.left,p.hp=unpack(row)
            if i>1 then o.extraParts[i-1]=p end
        end
        o.health,o.counters=data.health[1],{data.health[2],data.health[3]}
        o.armor,o.clocks={unpack(data.armor)},{unpack(data.clocks)}
        o.phase,o.protected,o.brokenCount,o.attackPause=0,true,0,0
        o.draws,o.centerFrame,o.nozzleFrame={},0,0
        o.coverFrames={0,0,0,0,0,0}
        o.aheadBursts,o.arcLayers,o.arcSpeed=unpack(data.attack)
        o.aux={limit=25,unique=true,handlers=aux,label='六面关底部件'}
        o.events={limit=5,unique=true,handlers=events,label='六面关底事件'}
        o.attacks={limit=20,handlers=attacks,label='六面关底攻击'}
        o.run.boss6=o
        attach(o.events,0)
        local queue=o.run.spawnQueue
        queue[#queue+1]={[3]=0x48,[4]=0,[10]=0x1adc4e,h=s16(o.h+0x1800),l=o.l}
        return true
    end

    events[0]={function(o,t)
        o.draws[0],o.draws[4]=true,true
        o.move={phase=0,clock=0xf0}
        o.run.stageFlags[0]=true
        attach(o.aux,0)
        o.events[t.slot]=nil
    end}

    local function rotor(o) o.centerFrame=(o.centerFrame+1)%16 end
    aux[0]={rotor,rotor}

    local function open(o,t)
        t.clock=t.clock-1
        if t.clock>=0 then return end
        t.clock=1
        o.openFrame=o.openFrame+1
        if o.openFrame<#data.images.unfold then return end
        o.draws[4]=nil
        for i=1,3 do o.draws[i]=true end
        o.aux[t.slot]=nil
    end
    aux[1]={function(o,t) t.clock=0; open(o,t) end,open}

    local function nozzle(o,t)
        t.clock=t.clock-1
        if t.clock<0 then t.clock,o.nozzleFrame=1,(o.nozzleFrame+1)%8 end
    end
    aux[4]={function(o,t) t.clock=0; nozzle(o,t) end,nozzle}

    local function approach(o,t)
        if t.phase<2 then
            t.clock=t.clock-1
            if t.clock<0 then
                if t.phase==0 then t.phase,t.clock=1,0x9f
                else
                    t.phase=2
                    o.openFrame=0
                    attach(o.aux,1)
                end
            end
        elseif t.phase==2 and not contains(o.aux,1) then
            t.phase=3
            o.flags=0xa000
            o.protected=false
            for i=1,4 do o.extraParts[i].flags=0xa000 end
            o.run.stageFlags[2]=true
            attach(o.aux,4)
            attach(o.events,4)
        end
        scrollTo(o,0x4800)
        for i,offset in ipairs(mountOffsets) do
            local p=o.extraParts[i]
            p.h,p.l=program.addPacked(o.h,o.l,offset)
        end
    end

    local function attackCycle(o,t)
        if o.attackPause>0 then
            o.attackPause=o.attackPause-1
            t.wait=false
            if o.attackPause>0 then return end
        end
        if t.wait then
            for i=1,o.attacks.limit do if o.attacks[i] then return end end
            t.wait=false
            return
        end
        t.clock=t.clock-1
        if t.clock>=0 then return end
        attach(o.attacks,t.attack,{side=1})
        attach(o.attacks,t.attack,{side=2})
        t.attack=(t.attack+1)%3
        if t.attack==0 then
            o.arcSpeed=math.min(8,o.arcSpeed+2)
            o.arcLayers=math.min(2,o.arcLayers+1)
        end
        t.clock,t.wait=t.attack==0 and 0x20 or 0,true
    end
    events[4]={function(o,t) t.attack,t.clock=0,0; attackCycle(o,t) end,attackCycle}

    local function nextPhase(o,t)
        t.clock=t.clock-1
        if t.clock>=0 then return end
        if not t.signaled then
            t.signaled,t.clock=true,0x1f
            o.run.boss6EscortCue=1
        else
            o.protected=false
            attach(o.events,5)
            o.events[t.slot]=nil
        end
    end
    events[1]={function(o,t) t.clock=0x40; nextPhase(o,t) end,nextPhase}

    local function emit(o,kind,speed,dir,offset)
        bullets.emit(o,kind,speed,dir,s16(floor(offset/0x10000)),s16(offset),true)
    end

    local function fallback(o,t,index)
        if not o.extraParts[t.side].broken then return false end
        attach(o.attacks,index,{side=t.side})
        o.attacks[t.slot]=nil
        return true
    end

    local function accent(o,t,index)
        for i=1,o.attacks.limit do
            local task=o.attacks[i]
            if task and task.index==index then return end
        end
        t.accent=attach(o.attacks,index)
    end

    local function endWing(o,t)
        if t.accent then t.accent.stop=true end
        o.attacks[t.slot]=nil
    end

    local function wingAttacking(o)
        for i=1,o.attacks.limit do
            local t=o.attacks[i]
            if t and t.side then return true end
        end
        return false
    end

    local function spreadSpeed(angle,speed)
        angle=band(angle,255)
        return speed+((angle<0x40 or angle>=0xc0) and 12 or 0)
    end

    local function wingClock(o,t,reload,accentIndex)
        if t.delay>0 then
            t.delay=t.delay-1
            if t.delay>0 then return false end
            if accentIndex then accent(o,t,accentIndex) end
        end
        t.clock=t.clock-1
        if t.clock>=0 then return false end
        t.clock=reload
        return true
    end

    -- 0x1ac612 的双翼炮各有五个偏移。在预警结束后两翼独立旋转。
    attacks[0]={function(o,t)
        if fallback(o,t,5) then return end
        t.delay,t.clock,t.volleys=0x40,band(program.random(o.run,program.randomByte),7),0x20
        t.turn=program.random(o.run,program.randomByte)<0x80 and 5 or -5
        t.extra=o.extraParts[3-t.side].broken
        if t.extra then accent(o,t,4) end
        t.angles={}
        for i=1,5 do t.angles[i]=(i-1)*(t.turn>0 and 0x10 or -0x10) end
    end,function(o,t)
        if not wingClock(o,t,7,4) then return end
        for i,offset in ipairs(data.firstPorts[t.side]) do
            local dir=t.angles[i]
            t.angles[i]=(dir+t.turn)%256
            for opposite=0,0x80,0x80 do
                local angle=(dir+opposite)%256
                emit(o,13,spreadSpeed(angle,-3),angle,offset)
            end
            if t.extra then emit(o,13,spreadSpeed(dir+0x70,1),dir+0x70,offset) end
        end
        t.volleys=t.volleys-1
        if t.volleys==0 then endWing(o,t) end
    end}

    local function portalAim(o,offset,current)
        local h,l=program.addPacked(o.h,o.l,offset)
        return program.angle8(h,l,o.run.player,current)
    end

    local function follow(a,b)
        local d=program.s8(b-a)
        return (a+math.max(-1,math.min(1,d)))%256
    end

    local function aimedStep(o,t)
        local left,right=0x1140fb00,0x11400500
        if t.remaining==0 then
            t.clock=t.clock-1
            if t.clock>=0 then return end
            t.clock=0x18
            t.burst=math.min(0x10,t.burst+2)
            o.aheadBursts=t.burst
            t.remaining,t.speed=t.burst,o.brokenCount>=2 and -2 or -5
            t.extra=math.max(0,math.min(2,o.brokenCount-1))
            t.left,t.right=portalAim(o,left,0x80),portalAim(o,right,0x80)
        end
        t.interval=t.interval-1
        if t.interval>=0 then return end
        t.interval=4
        t.left=follow(t.left,portalAim(o,left,t.left))
        t.right=follow(t.right,portalAim(o,right,t.right))
        emit(o,15,t.speed,t.left,0x113ffb00)
        for i=1,t.extra do emit(o,15,t.speed,t.left+i*15,0x113ffb00) end
        emit(o,15,t.speed,t.right,right)
        for i=1,t.extra do emit(o,15,t.speed,t.right-i*15,right) end
        t.speed,t.remaining=t.speed+2,t.remaining-1
        if t.remaining==0 and (t.stop or not wingAttacking(o)) then o.attacks[t.slot]=nil end
    end
    attacks[4]={function(o,t)
        t.clock,t.interval,t.remaining,t.burst=0x20,0,0,o.aheadBursts
        aimedStep(o,t)
    end,aimedStep}

    -- 0x1ac93e 两侧炮组的转角相反，每次循环再增加层间速度差。
    attacks[1]={function(o,t)
        if fallback(o,t,6) then return end
        t.delay,t.clock,t.volleys,t.layers=0x20,0,0x14,o.arcLayers
        if o.extraParts[3-t.side].broken then accent(o,t,7) end
        t.turn=t.side==1 and 8 or -8
        t.angles={}
        for i=1,5 do t.angles[i]=(i*(t.turn>0 and -0x40 or 0x40))%256 end
    end,function(o,t)
        if not wingClock(o,t,2) then return end
        for i,offset in ipairs(data.firstPorts[t.side]) do
            local angle=t.angles[i]
            t.angles[i]=(angle+t.turn)%256
            local speed=o.arcSpeed+((angle<0x40 or angle>=0xc0) and 12 or 0)
            for layer=0,t.layers do emit(o,0x16,speed+3*layer,angle,offset) end
        end
        t.volleys=t.volleys-1
        if t.volleys==0 then endWing(o,t) end
    end}

    -- 0x1acbc8 逐组换炮口，奇偶波次交错窄扇和三路圆弹。
    local function crossInit(o,t,rear)
        if not rear and fallback(o,t,8) then return end
        if rear and o.extraParts[t.side+2].broken then o.attacks[t.slot]=nil; return end
        local last=rear and o.brokenCount>=3
        t.delay,t.clock,t.interval=0x40,0,0
        t.groups,t.shots,t.port=rear and (last and 12 or 8) or 9,last and 6 or 4,rear and 4 or 5
        t.reload,t.remaining,t.modifier=last and 1 or 2,0,last and -4 or 0
        t.ports=rear and data.rearPorts[t.side] or data.firstPorts[t.side]
        t.turn=program.random(o.run,program.randomByte)<0x80 and 2 or -2
    end

    local function crossFire(o,t,rear)
        if t.delay>0 then
            t.delay=t.delay-1
            if t.delay>0 then return end
        end
        local offset=t.ports[t.port]
        if t.remaining==0 then
            t.clock=t.clock-1
            if t.clock>=0 then return end
            t.clock,t.remaining=6,t.shots
            t.angle,t.shift=portalAim(o,offset,0x80),0
        end
        t.interval=t.interval-1
        if t.interval>=0 then return end
        t.interval=t.reload
        local angle=t.angle+t.shift
        for d=0x18,-0x18,-0x30 do
            emit(o,2,rear and spreadSpeed(angle+d,t.modifier) or 0,angle+d,offset)
        end
        if t.remaining%2==0 then
            for i=0,2 do
                local dir=angle+(i==2 and -0x30 or i*0x30)
                emit(o,0xa,rear and spreadSpeed(dir,t.modifier) or 0,dir,offset)
            end
        end
        t.shift,t.remaining=t.shift+t.turn,t.remaining-1
        if t.remaining~=0 then return end
        t.shots,t.port,t.turn=t.shots+1,(t.port-2)%(rear and 4 or 5)+1,-t.turn
        t.groups=t.groups-1
        if t.groups==0 then o.attacks[t.slot]=nil end
    end
    attacks[2]={function(o,t) crossInit(o,t,false) end,function(o,t) crossFire(o,t,false) end}
    attacks[8]={function(o,t) crossInit(o,t,true) end,function(o,t) crossFire(o,t,true) end}

    -- 前炮损坏时，0x1ad13c、0x1ad440 和 0x1ad8dc 分别接替三个攻击槽。
    attacks[5]={function(o,t)
        if o.extraParts[t.side+2].broken then o.attacks[t.slot]=nil; return end
        t.delay,t.clock,t.volleys=0x40,0,0x20
        t.turn=program.random(o.run,program.randomByte)<0x80 and 5 or -5
        local otherRearBroken=o.extraParts[5-t.side].broken
        t.angle,t.extra=0,otherRearBroken or o.brokenCount>=3
        if otherRearBroken then accent(o,t,4) end
    end,function(o,t)
        if not wingClock(o,t,7,4) then return end
        for i=1,4 do
            local angle=t.angle+(i-1)*(t.turn>0 and 0x20 or -0x20)
            for d=0,t.extra and 0xc0 or 0x80,t.extra and 0x40 or 0x80 do
                emit(o,13,spreadSpeed(angle+d,t.extra and 2 or 0),angle+d,data.rearPorts[t.side][i])
            end
        end
        t.angle,t.volleys=t.angle+t.turn,t.volleys-1
        if t.volleys==0 then endWing(o,t) end
    end}

    attacks[6]={function(o,t)
        if o.extraParts[t.side+2].broken then o.attacks[t.slot]=nil; return end
        t.delay,t.clock,t.volleys=0x40,0,0x14
        t.turn=t.side==1 and 8 or -8
        t.angle,t.extra=t.turn>0 and -0x40 or 0x40,o.brokenCount>=3
    end,function(o,t)
        if not wingClock(o,t,4,o.brokenCount>=2 and 7 or nil) then return end
        for i=1,4 do
            local angle=t.angle+(i-1)*(t.turn>0 and -0x40 or 0x40)
            local speed=spreadSpeed(angle,8)
            local layers=t.extra and 4 or math.min(2,floor((0x14-t.volleys)/5))
            for n=0,layers do emit(o,0x16,speed+n*(t.extra and 4 or 2),angle,data.rearPorts[t.side][i]) end
        end
        t.angle,t.volleys=t.angle+t.turn,t.volleys-1
        if t.volleys==0 then endWing(o,t) end
    end}

    local function accentFire(o,t)
        t.angle=t.angle+t.turn
        if t.angle>=0x40 or t.angle<=-0x40 then t.turn=-t.turn end
        if t.remaining==0 then
            t.clock=t.clock-1
            if t.clock>=0 then return end
            t.clock,t.remaining,t.speed=4,4,0
            program.nextRandom(o.run)
        end
        t.interval=t.interval-1
        if t.interval>=0 then return end
        t.interval=t.extra and 0 or 1
        emit(o,6,t.speed,0x80+t.angle,0x113ffb00)
        emit(o,6,t.speed,0x80-t.angle,0x11400500)
        t.remaining=t.remaining-1
        if t.remaining==0 and (t.stop or not wingAttacking(o)) then o.attacks[t.slot]=nil end
    end
    attacks[7]={function(o,t)
        t.extra=o.brokenCount>=3
        t.clock,t.remaining,t.interval,t.speed,t.angle=0x20,4,t.extra and 0 or 1,t.extra and 4 or 0,0
        t.turn=program.s8(program.random(o.run,data.signs))
        accentFire(o,t)
    end,accentFire}

    function H.step(o)
        local run=o.run
        if not run.freeze and not run.stopPathClock then
            tasks.tick(o,o.aux)
            tasks.tick(o,o.events)
            if o.move then approach(o,o.move) end
            tasks.tick(o,o.attacks)
        end
        damage(o)
        return not o.retired
    end

    local function draw(o,image,offset,flip)
        local h,l=program.addPacked(o.h,o.l,offset)
        art.draw(o.run.art.sprites[image],h,l,0,0,flip)
    end

    local function pair(o,row,image)
        image=image or row[1]
        draw(o,image,row[2],false)
        draw(o,image,row[3],true)
    end

    local function tinted(name,palette,index,normal)
        local suffix=palette==31 and 'Hit' or palette==25 and 'Warning'
        return suffix and data.images[name..suffix][index] or normal
    end

    local function wing(o,name,group,first)
        local row=data.images[name][1]
        for side=0,1 do
            local part=o.extraParts[first+side]
            if not part.broken then
                draw(o,tinted(name,part.palette,1,row[1]),row[side+2],side==1)
                for _,piece in ipairs(group) do draw(o,piece[1],piece[side+2],side==1) end
            end
        end
    end

    function H.render(o)
        local images=data.images
        if not o.run.art then return end
        if o.draws[0] then
            pair(o,images.panel[1])
            if not o.coversHidden then
                local covers={images.cover0,images.cover1,images.cover2}
                for index,offset in ipairs(coverOffsets) do
                    draw(o,covers[index][o.coverFrames[index]+1],offset[1],false)
                    draw(o,covers[index][o.coverFrames[index+3]+1],offset[2],true)
                end
            end
        end
        if o.draws[1] then wing(o,'upper',images.outer,3) end
        if o.draws[2] then wing(o,'lower',images.inner,1) end
        if o.draws[3] or o.draws[4] then
            local image=tinted('wing',o.draws[3] and o.palette,1,images.wing[1][1])
            pair(o,images.wing[1],image)
        end
        if o.draws[4] then pair(o,images.unfold[o.openFrame and o.openFrame+1 or 1]) end
        if o.draws[3] then
            local image=tinted('nozzle',o.palette,o.nozzleFrame+1,images.nozzle[o.nozzleFrame+1])
            draw(o,image,0xfc00fe00+0x10bffb80,false)
            draw(o,image,0xfc00fe00+0x10c00480,true)
        end
        if o.draws[3] or o.draws[4] then
            draw(o,tinted('center',o.palette,1,images.center[1]),0x21bfff40+0xf400f900,false)
            draw(o,images.rotor[o.centerFrame+1],0xf800fb00,false)
        end
    end

    function Escort.init(o)
        o.h,o.l,o.flags=o.row.h,o.row.l,0x8000
        o.anim,o.animClock,o.posePhase=0,0,0
        o.flight,o.speed,o.angle=0,0,0
        return true
    end

    local function chooseTarget(o)
        o.targetH,o.targetL=program.addPacked(o.departureH,o.departureL,data.escortTargets[program.nextRandom(o.run,63)])
    end

    -- 0x1adc4e 分开推进动画和飞行。启动 128 帧后才向下一处位置转头。
    local function escortFlight(o)
        local run=o.run
        if not run.stopPathClock then
            local dh,dl=program.vector(o.speed,o.angle*4,run.slowVectors)
            o.h,o.l=s16(o.h+dh),s16(o.l+dl)
        end
        if o.flight==0 then
            scrollTo(o,0x6000)
            if run.freeze or not run.boss6EscortDepart then return end
            o.flight,o.flightClock,o.speed,o.angle=1,0x80,2,0x20
            o.departureH,o.departureL=o.h,o.l
            chooseTarget(o)
        end
        if run.freeze then return end
        if o.flight==1 then
            o.flightClock=o.flightClock-1
            if o.flightClock>=0 then return end
            o.flight,o.posePhase,o.animClock=2,3,0
        end
        local h,l=o.targetH,s16(o.targetL-run.cameraOffset)
        o.angle=program.towards(o.angle,program.angle(o.h,o.l,{h=h,l=l,active=true},o.angle))
        local dh,dl=math.abs(s16(h-o.h)),math.abs(s16(l-o.l))
        dh=dh-floor(dh/4)
        if math.max(dh,dl)+floor(math.min(dh,dl)/2)<=0x100 then chooseTarget(o) end
    end

    function Escort.step(o)
        local run=o.run
        escortFlight(o)
        if not run.freeze then
            o.animClock=o.animClock-1
            if o.animClock<0 then
                local phase=o.posePhase
                o.animClock=phase==2 and 2 or 1
                o.anim=o.anim+1
                if phase==0 then o.anim=o.anim%8
                elseif phase==1 and o.anim>=0x30 then o.anim=0x20
                elseif phase==2 then o.anim=math.min(0x37,o.anim)
                elseif phase==3 and o.anim>=0x57 then
                    o.anim=0x57
                    if o.handoff then return false end
                    local queue=run.spawnQueue
                    queue[#queue+1]={[3]=0x7c,[4]=0x80,[10]=0x19f6be,h=o.h,l=o.l}
                    o.handoff=true
                end
            end
        end
        local cue=run.boss6EscortCue
        if cue and o.posePhase<cue then
            o.posePhase,o.animClock=cue,0
            if cue==1 then o.anim=0 end
        end
        return true
    end

    function Escort.render(o)
        if not o.run.art then return end
        local images,index=data.images,o.anim+1
        if o.posePhase==0 then draw(o,images.escort[index],0xf800fd00,false); return end
        if o.posePhase==3 then
            local cape=images.escortCape[index]
            if cape[1]~=0 then
                draw(o,cape[1],cape[2],false)
                local h,l=program.addPacked(o.h,o.l,cape[2])
                art.draw(o.run.art.sprites[cape[1]],h,s16(l+0xe00),0,0,true)
            end
        end
        local body=images.escortBody[index]
        draw(o,body[1],body[2],false)
        local aura=images.escortAura[index]
        if o.posePhase~=3 and aura[1]~=0 then draw(o,aura[1],aura[2],false) end
    end

    return H,Escort,wreck.debris
end
