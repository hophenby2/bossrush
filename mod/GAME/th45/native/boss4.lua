-- 0x197d7e 推进任务后由 0x1993e4 结算。船首五个、后舱三个部件先共用第一段耐久。
return function(program,bullets,effects,art)
    local directory='mod/GAME/th45/native/'
    local tasks=dofile('mod/GAME/th44/native/boss_tasks.lua')
    local attacks,cannon=dofile(directory..'boss4_attacks.lua')(program,bullets,tasks)
    local aux,events=dofile(directory..'boss4_tasks.lua')(program,effects,tasks,cannon)
    local motion=dofile(directory..'boss4_motion.lua')(program,tasks)
    local draw=dofile(directory..'boss4_art.lua')(program,art,cannon)
    local bit=require('bit')
    local band,bxor=bit.band,bit.bxor
    local s16=program.s16
    local data=program.boss4
    local H={parts=12}
    local warning={0x42f33,0x1ba00,0x5b00}

    function H.init(o)
        o.extraParts={}
        for i,row in ipairs(data.parts) do
            local part=i==1 and o or {h=0,l=0}
            part.flags,part.front,part.back,part.right,part.left,part.hp=unpack(row)
            if i>1 then o.extraParts[i-1]=part end
        end
        o.rear=o.extraParts[5]
        o.h,o.l,o.prevH,o.prevL=-0x4e00,0x1c00,-0x4e00,0x1c00
        o.rear.h,o.rear.l=s16(o.h+0x1000),o.l
        o.deltaH,o.deltaL=0,0
        o.speed,o.direction,o.startDelay=0,0,1
        o.phase,o.health,o.counters,o.protected=0,data.health[1],{data.health[2],data.health[3],data.health[4]},true
        o.clocks={unpack(data.timeout)}
        o.frontVisible,o.broken=true,{}
        o.mainPalette,o.rearPalette,o.rotorPalette=9,14,17
        o.frontRaise,o.engineOffset,o.engineFrame,o.frontRotor,o.rearRotor=0,0,0,0,0
        o.hatchFrame,o.rearHatch,o.rearSpan,o.rearCoreOffset,o.sideSpeed,o.sideMode=0,0,0,0,0,0
        o.gunAim,o.gunDraw,o.glowFrame={0x80,0x80,0x80,0x80},{0x80,0x80,0x80,0x80},{0,0,0,0}
        o.aux={limit=25,unique=true,handlers=aux,label='四面关底部件'}
        o.events={limit=5,handlers=events,label='四面关底事件'}
        o.attacks={limit=20,handlers=attacks,label='四面关底攻击'}
        local run=o.run
        run.boss4,run.bulletCapacity=o,150
        tasks.attach(o.events,0)
        run.spawnQueue[#run.spawnQueue+1]={[3]=0x7b,[4]=0,[10]=0x19ec24,owner=o}
        return true
    end

    local function phaseChange(o)
        local phase=o.phase
        if phase<2 and o.counters[phase+1]>0 then
            o.counters[phase+2]=o.counters[phase+2]+o.counters[phase+1]
        end
        o.counters[phase+1]=-1
        o.phase,o.protected=phase+1,true
        tasks.clear(o.attacks)
        tasks.clear(o.events)
        if phase==0 then
            o.flags,o.mainPalette,o.lockAim=0x8000,9,false
            bullets.clear(o.run,0x10)
            aux.breakFront(o)
        elseif phase==1 then
            o.broken[6],o.broken[7]=true,true
            o.extraParts[6].flags,o.extraParts[7].flags=0x8000,0x8000
            bullets.clear(o.run,0x10)
        else
            o.rear.flags,o.dying=0x8000,true
            bullets.clear(o.run,0x10)
        end
        tasks.attach(o.events,phase+1)
    end

    local function damage(o)
        if o.finished or o.dying then return end
        local first,last=0,7
        if o.phase==1 then first=5
        elseif o.phase==2 then first,last=5,5 end
        local hit,total=false,0
        for index=first,last do
            local part=index==0 and o or o.extraParts[index]
            if part.impact then
                hit,total=true,total+(part.damage or 0)
                part.impact,part.damage,part.hp=nil,0,0x7fff
            end
        end
        if hit then
            if o.phase==0 then o.mainPalette=bxor(o.mainPalette==25 and 9 or o.mainPalette,0x16) end
            o.rearPalette=bxor(o.rearPalette==25 and 14 or o.rearPalette,0x11)
            o.rotorPalette=bxor(o.rotorPalette==25 and 17 or o.rotorPalette,0xe)
            if o.protected then return end
            total=band(total,0xffff)
            local index=o.phase+1
            o.health,o.counters[index]=o.health-total,o.counters[index]-total
            if o.phase<2 and o.counters[index]<0 then phaseChange(o)
            elseif o.phase==2 and o.health<0 then
                if o.run.player and o.run.player.active then phaseChange(o)
                else o.health,o.counters[index]=0x200,0x200 end
            end
        else
            local limit=warning[o.phase+1]
            if limit and o.health<=limit and not o.run.blockEnemyFire then
                o.mainPalette,o.rearPalette,o.rotorPalette=25,25,25
            else
                o.mainPalette,o.rearPalette,o.rotorPalette=9,14,17
            end
        end
    end

    function H.step(o)
        local run=o.run
        if o.finished then
            run.boss4,run.stageCleared=nil,true
            return false
        end
        if o.startDelay>0 then o.startDelay=o.startDelay-1; return true end
        if not run.freeze and not run.stopPathClock then
            tasks.tick(o,o.aux)
            tasks.tick(o,o.events)
        end
        local pending=o.nextMotion
        if pending then
            o.nextMotion=nil
            o.move=pending
            motion[pending.index][1](o,pending)
        elseif o.move then motion[o.move.index][2](o,o.move) end
        if not run.freeze then tasks.tick(o,o.attacks) end
        if o.frontVisible then
            for i,angle in ipairs(o.gunDraw) do
                local delta=program.s8(o.gunAim[i]-angle)
                o.gunDraw[i]=band(angle+math.min(2,math.max(-2,delta)),255)
            end
        end
        damage(o)
        if o.phase<3 and not run.freeze and not run.stopPathClock and o.clocks[o.phase+1] then
            local index=o.phase+1
            o.clocks[index]=o.clocks[index]-1
            if o.clocks[index]==0 then
                if run.player and run.player.active then phaseChange(o)
                else o.clocks[index]=0x78 end
            end
        end
        return true
    end

    H.render=draw
    return H
end
