-- 0x19f6be 接替伴飞机。保留 0x14f118 分配的十八个部件槽和原版形态耐久。
return function(program,bullets,art,effects,rewards)
    local tasks=dofile('mod/GAME/th44/native/boss_tasks.lua')
    local band=require('bit').band
    local s16,floor,abs=program.s16,math.floor,math.abs
    local data=program.boss6
    local H={parts=18}
    local attacks,events={},{}
    local pose,resumeBody
    local mount={0,0x217feb80,0x13bfe9c0,0x0dbff300,0x057ff040,0xf8bfed80,0xe5ffe7c0,
        0x21801480,0x13c01640,0x0dc00d00,0x05800fc0,0xf8c01280,0xe6001840}
    local bodyOffsets={finalBody=0xf600fa00,finalTurn=0xff800040+0xf600fa00,
        finalSide=0xff000040+0xf600fa00,finalOpen=0xff400000+0xf600f800,
        finalTwist=0x00c00040+0xf200f900,finalSecond=0xf600f900,
        finalCharge=0xf600f900,finalBurst=0xf600f900,finalFold=0x03c00000+0xf400f900,
        finalWheel=0xffbfffc0+0xf600f800}
    local warningHealth={0x47d33,0x30199,0xda66}

    function H.init(o)
        o.h,o.l=o.row.h,o.row.l
        o.extraParts={}
        for i,row in ipairs(data.finalParts) do
            local part=i==1 and o or {h=0,l=0}
            part.flags,part.front,part.back,part.right,part.left,part.hp=unpack(row)
            if i>1 then o.extraParts[i-1]=part end
        end
        o.health,o.secondHealth=unpack(data.finalHealth,1,2)
        o.counters={unpack(data.finalHealth,3)}
        o.clocks={0x1c20,0x1c20,0x1c20,0x1c20,0x1c20,0x1c20,0x2a30}
        o.phase,o.protected=0,true
        o.heading,o.speed=0,0x10
        o.wingFrame,o.bodyFrame,o.poseClock=0,0,0
        o.image='finalBody'
        o.attacks={handlers=attacks,limit=20,label='六面最终攻击'}
        o.events={handlers=events,limit=5,label='六面最终事件'}
        tasks.attach(o.events,0)
        return true
    end

    local function place(o)
        for i,offset in ipairs(mount) do
            local part=o.extraParts[i]
            part.h,part.l=program.addPacked(o.h,o.l,offset)
        end
    end

    local function distance(o,h,l)
        local dh,dl=abs(s16(o.h-h)),abs(s16(o.l-l))
        dh=dh-floor(dh/4)
        return math.max(dh,dl)+floor(math.min(dh,dl)/2)
    end

    local function driftTarget(o,m)
        m.h,m.l=program.addPacked(m.anchorH,m.anchorL,data.escortTargets[program.nextRandom(o.run,63)])
    end

    local function moveTo(o,h,l,index,mode)
        o.move={kind=mode or 3,h=h,l=l,index=index,init=true,target={active=true}}
    end

    local function startDrift(o,speed)
        local m={kind=2,init=true,speed=speed,anchorH=o.h,anchorL=o.l,target={active=true}}
        o.move=m
    end

    local function startMove(o,m)
        m.init=false
        if m.kind==0 then
            o.speed,o.heading=0,0x20
            o.visible=true
            tasks.attach(o.events,6)
        elseif m.kind==1 then
            o.speed=3
        elseif m.kind==2 then
            o.speed=m.speed or 2
            driftTarget(o,m)
        else
            local target=m.target
            target.h,target.l=m.h,s16(m.l-o.run.cameraOffset)
            o.heading=program.angle(o.h,o.l,target,o.heading)
            local pace=(m.kind==7 and data.finalRoamSpeed or data.finalSpeed)[m.index+1]
            m.clock,m.reload,m.delta=pace[1],pace[2],pace[4]
            m.half=floor(distance(o,target.h,target.l)/2)
            if m.kind==7 and o.phase==0 then
                pose(o,o.heading>0x20 and 'finalSide' or 'finalTurn',4,resumeBody)
            end
        end
    end

    local function steer(o,m)
        local target=m.target
        if m.kind==1 then
            target.l=s16(0x1c00-o.run.cameraOffset)
            o.heading=program.angle(o.h,o.l,target,o.heading)
            if distance(o,target.h,target.l)<=0x80 then o.speed=0 end
            return
        end
        target.h,target.l=m.h,s16(m.l-o.run.cameraOffset)
        if not m.braking then
            o.heading=program.towards(o.heading,program.angle(o.h,o.l,target,o.heading))
        end
        local d=distance(o,target.h,target.l)
        if m.kind==2 then
            if d<=0x100 then driftTarget(o,m) end
            return
        end
        m.clock=m.clock-1
        if m.clock<0 then
            m.clock=m.reload
            if not m.braking and d>=m.half then o.speed=o.speed+m.delta
            else m.braking=true; o.speed=math.max(0,o.speed-m.delta) end
        end
        if o.speed==0 then startDrift(o)
        elseif d<=0x200 then m.braking=true end
    end

    local function motion(o)
        local m=o.move
        if not m or o.run.stopPathClock then return end
        if m.init then startMove(o,m) end
        if not o.run.freeze and m.kind~=0 then steer(o,m) end
        local dh,dl=program.vector(o.speed,o.heading*4,o.run.slowVectors)
        o.h,o.l=s16(o.h+dh),s16(o.l+dl)
        place(o)
        -- 0x18e3b4 在移动任务写完部件坐标后，另给本体叠加后坐。
        if (o.recoil or 0)>0 then
            local h,l=program.vector(o.recoil,o.recoilAngle,o.run.slowVectors)
            o.h,o.l,o.recoil=s16(o.h+h),s16(o.l+l),o.recoil-1
        end
    end

    pose=function(o,image,reload,finished)
        o.image,o.bodyFrame,o.poseClock=image,0,0
        o.poseReload,o.poseFinished=reload,finished
    end

    local function animation(o)
        if not o.visible then return end
        o.poseClock=o.poseClock-1
        if o.poseClock>=0 then return end
        o.poseClock=o.poseReload or 1
        o.wingFrame=(o.wingFrame+1)%16
        if o.image=='finalBurst' then
            o.bodyFrame=o.bodyFrame+1
            if o.releaseBurst and o.bodyFrame>=27 then resumeBody(o)
            elseif not o.releaseBurst and o.bodyFrame>=20 then o.bodyFrame=12 end
        elseif o.image=='finalWheel' then
            o.bodyFrame=o.bodyFrame+1
            if o.releaseWheel and o.bodyFrame>=28 then resumeBody(o)
            elseif not o.releaseWheel and o.bodyFrame>=19 then o.bodyFrame=11 end
        elseif o.poseFinished and o.bodyFrame==14 then
            local finished=o.poseFinished
            o.poseFinished=nil
            finished(o)
        else o.bodyFrame=(o.bodyFrame+1)%16 end
    end

    resumeBody=function(o)
        pose(o,o.secondArt and 'finalSecond' or 'finalBody',1)
    end

    local function emit(o,kind,modifier,angle,offset,extra)
        bullets.emit(o,kind,modifier,angle,s16(floor(offset/0x10000)),s16(offset),true,extra)
    end

    -- 0x1a53a4 每四发转一步，越过自机方位时改成三路自机狙。
    local function fireSweep(o,t)
        if t.shots==0 then
            t.clock=t.clock-1
            if t.clock>=0 then return end
            t.clock,t.shots=t.aimed and 4 or 0,t.aimed and 1 or 4
            if not t.aimed then t.speed=4 end
        end
        emit(o,t.aimed and 0x15 or 0xe,t.speed,t.angle,t.offset)
        if t.aimed then
            emit(o,0x15,t.speed,t.angle+4,t.offset)
            emit(o,0x15,t.speed,t.angle-4,t.offset)
        end
        t.speed,t.shots=t.speed+2,t.shots-1
        if t.shots>0 then return end
        local h,l=s16(o.h+floor(t.offset/0x10000)),s16(o.l+s16(t.offset))
        if not t.aimed then
            t.angle=band(t.angle+t.turn,255)
            local angle=program.angle8(h,l,o.run.player,0x80)
            if t.turn>0 and angle<t.angle or t.turn<0 and angle>=t.angle then
                t.aimed,t.clock,t.speed=true,0,0
            end
        end
        if t.aimed then
            t.angle=program.angle8(h,l,o.run.player,0x80)
            t.life=t.life-1
            if t.life==0 then o.attacks[t.slot]=nil end
        end
    end

    attacks[1]={function(o,t)
        t.angle,t.turn,t.offset=0xe0,-8,0x087ff880
        if t.side==1 then t.angle,t.turn,t.offset=0x20,8,0x08800780 end
        t.clock,t.shots=0,0
        fireSweep(o,t)
    end,fireSweep}

    -- 0x1a52f0 的发弹母体从 0x80 档向量表取生成偏移，发射方向取反。
    local function fireOrbit(o,t)
        t.clock=t.clock-1
        if t.clock>=0 then return end
        t.clock=2
        local h,l=program.vector(0x80,t.angle,o.run.slowVectors)
        emit(o,0x20,-20,t.angle+0x80,2*h*0x10000+band(2*l,0xffff),{t.angle,t.childTurn})
        t.angle,t.remaining=band(t.angle+t.turn,255),t.remaining-1
        if t.remaining==0 then o.attacks[t.slot]=nil end
    end
    attacks[0]={function(o,t)
        t.angle=band(program.angle8(o.h,o.l,o.run.player,0x80)+(t.side==0 and 0xa0 or 0x60),255)
        t.turn,t.childTurn=t.side==0 and 8 or -8,t.side==0 and 4 or -4
        t.clock,t.remaining=0,15
        fireOrbit(o,t)
    end,fireOrbit}

    events[0]={function(o,t)
        o.run.stageFlags[0]=true
        o.move={kind=0,init=true}
        o.events[t.slot]=nil
    end}

    local function randomSide(run)
        return band(program.random(run,program.randomByte),1)
    end

    local function activeMove(o)
        return o.move and o.move.kind==2 and not o.move.init
    end

    local function roam(o,t)
        if not activeMove(o) then return end
        t.walkClock=t.walkClock-1
        if t.walkClock>=0 then return end
        t.walkClock=0x30
        local run=o.run
        local h=0x5800+floor(program.hovercraftRandom[program.nextRandom(run,127)]/4)
        local l=math.max(0xc00,math.min(0x1a00,abs(program.hovercraftRandom[program.nextRandom(run,127)])))
        t.walkSide=1-t.walkSide
        moveTo(o,h,0x1c00+(t.walkSide==0 and -l or l),1,7)
    end

    -- E6 先放完四组扫射，再展开侧翼并沿环布置十五颗发弹母体。
    local function opening(o,t)
        if t.phase==0 then
            t.wait=t.wait-1
            if t.wait>=0 then return end
            t.phase=1
            if o.protected then
                o.flags,o.extraParts[1].flags=0xa001,0xa001
                o.protected=false
                o.run.stageFlags[2]=true
            end
        end
        if t.phase==1 then
            t.clock=t.clock-1
            if t.clock<0 then
                t.clock=0x4e
                tasks.attach(o.attacks,1,{side=t.side,life=t.life})
                t.side,t.life,t.groups=1-t.side,t.life+4,t.groups-1
                if t.groups==0 then t.phase,t.wait=2,0x30 end
            end
        end
        if t.phase==2 and not tasks.contains(o.attacks,1) then
            t.wait=t.wait-1
            if t.wait<0 then
                tasks.attach(o.attacks,0,{side=t.orbitSide})
                pose(o,'finalOpen',2,resumeBody)
                t.phase=3
                startDrift(o)
            end
        end
        if t.phase==3 and not o.poseFinished and not tasks.contains(o.attacks,0) then
            tasks.attach(o.events,6)
            o.events[t.slot]=nil
        end
        if t.phase==1 or t.phase==2 then roam(o,t) end
    end

    events[6]={function(o,t)
        t.phase,t.wait,t.clock,t.groups,t.life=0,o.protected and 0x100 or 0x60,0x20,4,8
        t.orbitSide,t.side=randomSide(o.run),randomSide(o.run)
        t.walkClock,t.walkSide=0,1
        moveTo(o,0x5800,0x1c00,1)
        opening(o,t)
    end,opening}

    local function transform(o,t)
        if t.phase==0 and not o.poseFinished then
            t.phase=1
            moveTo(o,0x5800,0x1c00,2)
            return
        end
        if t.phase==1 and activeMove(o) then
            t.phase,t.clock=2,15
            o.secondArt=o.phase==1
            resumeBody(o)
            return
        end
        if t.phase==2 then
            t.clock=t.clock-1
            if t.clock<=0 then
                o.protected=false
                tasks.attach(o.events,o.phase==1 and 9 or 10)
                o.events[t.slot]=nil
            end
        end
    end
    events[1]={function(o,t)
        t.phase=0
        o.speed=0
        pose(o,'finalTwist',2,resumeBody)
    end,transform}
    events[2]={function(o,t)
        t.phase=0
        o.speed=0
        pose(o,'finalFold',2,resumeBody)
    end,transform}

    local function radial(o,kind,modifier,angle)
        local offset=program.mid1.ringOffsets[floor(band(angle+2,255)/4)+1]
        emit(o,kind,modifier,angle,offset)
    end

    -- 0x1a5676 的中央狙击三路同角换速，外侧两圈各错开半个炮口。
    local function fireCharge(o,t)
        t.clock=t.clock-1
        if t.clock>=0 then return end
        local player=o.run.player
        if player and player.active then
            local aim=program.angle8(o.h,o.l,player,0x80)
            for layer=0,t.layers do
                local speed=2-layer*3
                radial(o,0xb,speed,aim)
                radial(o,0xb,speed,aim+4)
                radial(o,0xb,speed,aim-4)
            end
            for i=0,16 do radial(o,0x18,-9,0x50+i*6) end
            for i=0,15 do radial(o,0x18,-11,0x53+i*6) end
        end
        o.attacks[t.slot]=nil
    end
    attacks[4]={function(o,t) t.clock=0x18; fireCharge(o,t) end,fireCharge}

    local function fireRing(o,t)
        t.clock=t.clock-1
        if t.clock>=0 then return end
        t.clock,t.period=t.period,math.max(8,t.period-3)
        local queue=o.run.spawnQueue
        queue[#queue+1]={[3]=0x7d,[4]=0,[10]=0x1a74aa,h=o.h,l=o.l,owner=o,speed=t.speed,turn=t.turn}
        t.turn,t.speed,t.count=-t.turn,math.min(12,t.speed+1),t.count-1
        if t.count==0 then o.attacks[t.slot]=nil end
    end
    attacks[3]={function(o,t)
        t.clock,t.period,t.count,t.turn,t.speed=0,0x40,12,1,4
        fireRing(o,t)
    end,fireRing}

    local function secondSweep(o,t)
        if t.phase==0 then
            t.clock=t.clock-1
            if t.clock>=0 then return end
            t.phase=1
        end
        if t.phase==1 and activeMove(o) then
            local run=o.run
            local h=0x5800+floor(program.hovercraftRandom[program.nextRandom(run,127)]/2)
            local l=abs(program.hovercraftRandom[program.nextRandom(run,127)])
            l=math.min(t.range,math.max(t.range/2,l))
            t.side=1-t.side
            moveTo(o,h,0x1c00+(t.side==0 and -l or l),t.speed,7)
            t.phase=3
            pose(o,'finalCharge',2,resumeBody)
            tasks.attach(o.attacks,4,{layers=t.layers})
        end
        if t.phase==3 and not o.poseFinished then
            t.groups,t.range,t.speed,t.layers=t.groups-1,t.range-0x400,math.min(5,t.speed+1),t.layers+1
            t.phase=t.groups==0 and 4 or 1
        end
        if t.phase==4 and activeMove(o) then
            tasks.attach(o.events,8)
            o.events[t.slot]=nil
        end
    end
    events[9]={function(o,t)
        randomSide(o.run)
        t.phase,t.clock,t.side,t.speed,t.range,t.groups,t.layers=0,0x20,1,3,0x1600,4,1
        moveTo(o,0x5800,0x1c00,1)
        secondSweep(o,t)
    end,secondSweep}

    local function secondRings(o,t)
        if t.phase==0 then
            t.clock=t.clock-1
            if t.clock>=0 then return end
            t.phase,t.clock=1,0x30
            o.releaseBurst=false
            pose(o,'finalBurst',1)
        end
        if t.phase==1 then
            t.clock=t.clock-1
            if t.clock>=0 then return end
            t.phase,t.clock=2,0x60
            tasks.attach(o.attacks,3)
        end
        if t.phase==2 and not tasks.contains(o.attacks,3) then
            t.clock=t.clock-1
            if t.clock==0 then t.phase,o.releaseBurst=3,true end
        end
        if t.phase==3 and o.image~='finalBurst' then
            tasks.attach(o.events,9)
            o.events[t.slot]=nil
        end
    end
    events[8]={function(o,t)
        t.phase,t.clock=0,0x60
        moveTo(o,0x5800,0x1c00,1)
        secondRings(o,t)
    end,secondRings}

    -- 0x1a598e 会先在炮口外侧转过半圈，再从同一处沿自机方向发直线弹。
    local function fireSpiral(o,t)
        t.clock=t.clock-1
        if t.clock>=0 then return end
        local h,l=program.vector(0x30,t.port+t.aim,o.run.slowVectors)
        local offset=(0x400+2*h)*0x10000+band(2*l,0xffff)
        if t.tail then
            t.clock=1
            emit(o,5,t.speed,t.aim,offset)
            t.speed,t.remaining=math.min(0x30,t.speed+1),t.remaining-1
            if t.remaining==0 then o.attacks[t.slot]=nil end
            return
        end
        t.clock=2
        emit(o,0x19,t.speed,t.angle,offset)
        if t.remaining%2==1 then emit(o,0x19,t.speed+4,t.angle+t.turn,offset) end
        t.angle,t.remaining=t.angle+t.turn,t.remaining-1
        if t.remaining==0 then
            t.tail,t.clock,t.speed,t.remaining=true,0,-4,0x10
        end
    end
    attacks[7]={function(o,t)
        t.angle,t.clock,t.speed,t.remaining=t.aim+0x80,0,1,floor(0x80/abs(t.turn))
        fireSpiral(o,t)
    end,fireSpiral}

    local function thirdSpiral(o,t)
        if t.phase==0 then
            if not activeMove(o) then return end
            t.phase=1
        end
        if t.groups>0 then
            t.clock=t.clock-1
            if t.clock<0 then
                t.clock,t.reload=t.reload,math.max(0x10,t.reload-1)
                t.side=1-t.side
                local right=t.side==0
                tasks.attach(o.attacks,7,{port=right and 0xc0 or 0x40,turn=right and 6 or -6,
                    aim=program.angle8(o.h,o.l,o.run.player,0x80)})
                if right then t.groups=t.groups-1 end
                if t.phase==1 then t.phase,t.moveClock=2,0xa0 end
            end
        elseif not tasks.contains(o.attacks,7) then
            o.secondArt=true
            resumeBody(o)
            tasks.attach(o.events,11)
            o.events[t.slot]=nil
            return
        end
        if t.phase==2 then
            t.moveClock=t.moveClock-1
            if t.moveClock<0 then t.phase=3 end
        end
        if t.phase==3 and activeMove(o) then
            local target=data.finalSpiralTargets[t.target]
            local h,l=s16(floor(target/0x10000)),s16(target)
            moveTo(o,h,0x1c00+(t.side==0 and l or -l),2)
            t.target=3-t.target
        end
    end
    events[10]={function(o,t)
        t.side=randomSide(o.run)
        program.nextRandom(o.run)
        t.phase,t.clock,t.reload,t.groups,t.target=0,4,0x18,12,1
        o.speed=8
        moveTo(o,0x5400,0x1c00,1)
        thirdSpiral(o,t)
    end,thirdSpiral}

    local function edgeVolley(o,t)
        t.clock=t.clock-1
        if t.clock>=0 then return end
        t.clock=t.period
        emit(o,0x21,t.speed,t.angle,0)
        t.angle,t.count=t.angle+t.turn,t.count-1
        if t.count==0 then o.attacks[t.slot]=nil end
    end
    attacks[8]={edgeVolley,edgeVolley}

    -- E11 的四项 ROM 指针在两套队列间交替。触边单位在出舱动画结束后仍会走边。
    local function edgePattern(o,t)
        local run=o.run
        if t.phase==0 then
            if not activeMove(o) then return end
            t.phase=1
            run.finalEdgeLevel=(run.finalEdgeLevel or 0)+1
            pose(o,'finalCharge',2,resumeBody)
        end
        if t.phase==1 and not tasks.contains(o.attacks,8) then
            local angle,turn,modifier,count,timing=unpack(t.rows[t.cursor])
            tasks.attach(o.attacks,8,{angle=angle,turn=turn,speed=modifier,count=count,
                clock=floor(timing/0x100),period=band(timing,255)})
            t.cursor=t.cursor+1
            if t.cursor>#t.rows then t.phase,t.clock=2,0x20 end
        end
        if t.phase==2 and not o.poseFinished and not tasks.contains(o.attacks,8) then
            t.clock=t.clock-1
            if t.clock==0 then
                t.phase,t.clock=3,0x100
                o.releaseBurst=false
                pose(o,'finalBurst',1)
            end
        end
        if t.phase==3 then
            t.clock=t.clock-1
            if t.clock==0 then t.phase,o.releaseBurst=4,true end
        end
        if t.phase==4 and o.image~='finalBurst' then
            run.finalEdgeClosing=true
            o.secondArt=false
            resumeBody(o)
            tasks.attach(o.events,o.edgeCycle%2==0 and 7 or 10)
            o.edgeCycle=o.edgeCycle+1
            o.events[t.slot]=nil
        end
    end
    events[11]={function(o,t)
        o.edgeCycle=o.edgeCycle or 0
        o.run.finalEdgeClosing=false
        t.phase,t.cursor,t.rows=0,1,data.finalEdgeParts[o.edgeCycle%4+1]
        o.speed=8
        moveTo(o,0x5400,0x1c00,1)
        edgePattern(o,t)
    end,edgePattern}

    local function wheelPair(o,t)
        t.clock=t.clock-1
        if t.clock>=0 then return end
        t.clock=7
        for i=0,1 do
            local angle=t.angle+0x80*i
            local offset=program.mid1.ringOffsets[floor(band(angle+2,255)/4)+1]
            emit(o,0xd,t.speed,angle,offset+0x4000000)
        end
        t.angle,t.speed=t.angle+t.turn,t.speed+t.speedStep
        if t.speedStep<0 then
            if t.speed<=-4 then t.speedStep=1 end
        elseif t.speed>t.maxSpeed then
            t.speedStep,t.angle,t.maxSpeed=-1,t.angle+2*t.turn,math.min(16,t.maxSpeed+2)
        end
    end
    attacks[2]={function(o,t)
        t.clock,t.speed,t.speedStep,t.maxSpeed=0,-4,1,8
        wheelPair(o,t)
    end,wheelPair}

    local function wheelPattern(o,t)
        if t.phase==0 then
            if not activeMove(o) then return end
            t.phase,t.clock=1,0x40
            o.releaseWheel=false
            pose(o,'finalWheel',2)
        end
        if t.phase==1 then
            t.clock=t.clock-1
            if t.clock<0 then
                for i=0,8 do tasks.attach(o.attacks,2,{angle=i*8,turn=i%2==0 and 4 or -4}) end
                t.phase,t.clock=2,0x280
            end
        end
        if t.phase==2 then
            t.clock=t.clock-1
            if t.clock<0 then
                tasks.stop(o.attacks,2)
                t.phase,o.releaseWheel=3,true
            end
        end
        if t.phase==3 and o.image~='finalWheel' then
            o.secondArt=true
            resumeBody(o)
            tasks.attach(o.events,11)
            o.events[t.slot]=nil
        end
    end
    events[7]={function(o,t)
        t.phase=0
        moveTo(o,0x5400,0x1c00,1)
        wheelPattern(o,t)
    end,wheelPattern}

    local armor=dofile('mod/GAME/th45/native/boss6_final_armor.lua')(
        program,art,effects,tasks,events,attacks,moveTo,startDrift,activeMove,emit)
    dofile('mod/GAME/th45/native/boss6_final_wings.lua')(program,tasks,events,attacks,moveTo,emit)
    local renderCore=dofile('mod/GAME/th45/native/boss6_final_core.lua')(
        program,art,effects,tasks,events,attacks,moveTo,emit)
    local rewardParts={[3]=0xc,[4]=0x10,[5]=0x12,[6]=0x14,[7]=0x18}
    local armorThresholds={0x7ef9d,0x5ac62,0x39a8e,0xe380}

    local function nextPhase(o,hit,hitMode)
        local index=o.phase+1
        local drops=rewardParts[index]
        if hit and drops then rewards.drop(o,o.h,o.l,drops,0,true,hitMode) end
        if (index==2 or index>=4 and index<7) and o.counters[index]>0 then
            o.counters[index+1]=o.counters[index+1]+o.counters[index]
        end
        if index==3 then
            o.health=-1
            o.run.finalEdgePurge=true
        end
        o.counters[index],o.phase,o.protected=-1,index,true
        o.tint=''
        tasks.clear(o.attacks)
        tasks.clear(o.events)
        bullets.clear(o.run,0x10)
        if index==4 then armor.breakArmor(o) end
        if index==5 then armor.breakWings(o) end
        if index==6 then
            armor.breakCore(o)
            o.healsOnContact=true
        end
        if index==7 then
            o.secondHealth,o.flags,o.defeated,o.deathDelay=-1,0x8000,true,true
            o.run.finalShardsPurge=true
            o.coreAura=false
        end
        local event=({[4]=13,[5]=14,[6]=4,[7]=5})[index] or index
        tasks.attach(o.events,event)
    end

    local function damage(o)
        if o.defeated then return end
        local amount,hit,hitMode=0,false,0
        local secondary=o.phase>=3
        local function collect(part)
            if part.impact then
                hit=true
                amount=amount+(part.damage or 0)
                hitMode=math.max(hitMode,part.rewardMode or 0)
                part.impact,part.damage,part.hp,part.rewardMode=nil,0,0x7fff,nil
            end
        end
        collect(o)
        if secondary then
            for i=2,13 do
                local part=o.extraParts[i]
                if not part.broken then collect(part) end
            end
        else
            collect(o.extraParts[1])
        end
        if hit then
            o.tint=o.tint=='Hit' and '' or 'Hit'
            local bodyImpact=o.bodyImpact
            o.bodyImpact=nil
            if not o.protected then
                local index=o.phase+1
                if bodyImpact then
                    -- 0x1a46dc 核心接触自机时恢复自身耐久，并忽略同帧的射击伤害。
                    o.counters[index]=o.counters[index]+0x800
                    o.secondHealth=o.secondHealth+0x800
                    if o.counters[index]>=0x98f40 then o.counters[index],o.secondHealth=0x98f40,0x98f40 end
                else
                    amount=band(amount,0xffff)
                    o.counters[index]=o.counters[index]-amount
                    if secondary then o.secondHealth=o.secondHealth-amount else o.health=o.health-amount end
                end
            end
        else
            local health=secondary and o.secondHealth or o.health
            local threshold=secondary and armorThresholds[o.phase-2] or warningHealth[o.phase+1]
            o.tint=health<=threshold and not o.run.blockEnemyFire and 'Warning' or ''
        end
        local index=o.phase+1
        local run=o.run
        if o.counters[index]<0 then
            if o.phase==6 and not (run.player and run.player.active) then
                o.secondHealth,o.counters[index]=0x200,0x200
            else nextPhase(o,hit,hitMode) end
            return
        end
        if run.freeze or run.stopPathClock then return end
        o.clocks[index]=o.clocks[index]-1
        if o.clocks[index]~=0 then return end
        if run.player and run.player.active then nextPhase(o)
        else o.clocks[index]=0x78 end
    end

    function H.step(o)
        local run=o.run
        if o.deathDelay then o.deathDelay=nil; return true end
        if not run.freeze and not run.stopPathClock then
            if o.armorAge then o.armorAge=o.armorAge+1 end
            if o.coreVisible then
                o.coreAge=o.coreAge+1
                if o.coreOpening and o.coreOpening<23 and o.coreAge%3==0 then
                    o.coreOpening=o.coreOpening+1
                end
            end
            animation(o)
            tasks.tick(o,o.events)
            if o.coreVisible then
                local width=o.coreAura and 0x900 or 0x500
                o.right,o.left=width,width
            end
        end
        motion(o)
        if not run.freeze and not run.stopPathClock then tasks.tick(o,o.attacks) end
        damage(o)
        return not run.stageCleared
    end

    local function draw(o,image,offset,flip)
        local h,l=program.addPacked(o.h,o.l,offset)
        art.draw(o.run.art.sprites[image],h,l,0,0,flip)
    end

    function H.render(o)
        if not o.run.art or not o.visible then return end
        if o.coreVisible then renderCore(o); return end
        if o.armorFrame then armor.render(o); return end
        local suffix=o.tint or ''
        if o.image=='finalTwist' then
            local wing=data.images['finalTwistWing'..suffix][o.bodyFrame+1]
            draw(o,wing,0x05fff900+0xf200f900,false)
            draw(o,wing,0x06000700+0xf200f900,true)
        elseif o.secondArt then
            local wings=data.images['finalSecondWing'..suffix]
            draw(o,wings[o.wingFrame+1],0x04000600+0xfa00fa00,false)
            draw(o,wings[o.wingFrame+1],0x03fffa00+0xfa00fa00,true)
        else
            local wings=data.images['finalWing'..suffix]
            draw(o,wings[o.wingFrame+1],0x08fff900+0xf600f900,false)
            draw(o,wings[o.wingFrame+1],0x09000700+0xf600f900,true)
        end
        local body=data.images[o.image..suffix]
        draw(o,body[o.bodyFrame+1],bodyOffsets[o.image],false)
    end

    return H
end
