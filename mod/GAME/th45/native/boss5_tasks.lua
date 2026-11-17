-- 0x1bb6d8 阶段事件和 0x1bc1e6 部件任务分开调度，绘制槽也随它们开关。
return function(program,bullets,effects,tasks)
    local events,aux={},{}
    local attach,contains,stop=tasks.attach,tasks.contains,tasks.stop
    local data=program.boss5

    local function entry(init,step)
        return {function(o,t) init(o,t); step(o,t) end,step}
    end

    local function clock(t,key,reload)
        t[key]=t[key]-1
        if t[key]>=0 then return false end
        t[key]=reload
        return true
    end

    local function nextEvent(o,t,index)
        attach(o.events,index)
        o.events[t.slot]=nil
    end

    local function wings(o)
        o.wingA,o.wingB=(o.wingA+1)%32,(o.wingB+1)%32
    end
    aux[0]={wings,wings}

    aux[1]=entry(function(o,t)
        t.clock=0
        o.draws[0],o.draws[1],o.hullFrame=true,true,0
        for i=2,4 do o.draws[i]=nil; stop(o.aux,i) end
    end,function(o,t)
        if clock(t,'clock',1) then o.hullFrame=(o.hullFrame+1)%16 end
    end)

    aux[2]=entry(function(o,t)
        t.clock,o.turnFrame=0,35
        o.draws[1],o.draws[2],o.draws[3]=nil,true,nil
        stop(o.aux,1)
        stop(o.aux,3)
    end,function(o,t)
        if not clock(t,'clock',4) then return end
        o.turnFrame=o.turnFrame-1
        if o.turnFrame==0 then
            attach(o.aux,1)
            o.aux[t.slot]=nil
        end
    end)

    aux[3]=entry(function(o,t)
        t.clock,o.hatchFrame=0,0
        o.draws[1],o.draws[3],o.closeHatch=nil,true,false
        stop(o.aux,1)
    end,function(o,t)
        if not clock(t,'clock',1) then return end
        o.hatchFrame=o.hatchFrame+1
        if o.closeHatch then
            if o.hatchFrame>=23 then
                attach(o.aux,1)
                o.closeHatch=false
                o.aux[t.slot]=nil
            end
        elseif o.hatchFrame>=15 then o.hatchFrame=8 end
    end)

    aux[4]=entry(function(o,t)
        t.clock,o.foldFrame=0,15
        for i=0,3 do o.draws[i]=nil end
        o.draws[4]=true
        for i=1,3 do stop(o.aux,i) end
    end,function(o,t)
        if not clock(t,'clock',3) then return end
        o.foldFrame=o.foldFrame-1
        if o.foldFrame==0 then
            attach(o.aux,1)
            o.aux[t.slot]=nil
        end
    end)

    aux[5]=entry(function(o,t)
        t.clock,o.detachedFrame,o.detachedScale=1,7,0x40
        o.draws[5]=true
    end,function(o,t)
        if not clock(t,'clock',1) then return end
        if o.detachedScale>0 then
            o.detachedScale=o.detachedScale-4
        else
            o.detachedFrame=o.detachedFrame-1
            if o.detachedFrame==0 then
                o.extraParts[4].flags,o.extraParts[11].flags=0xa401,0xa400
                attach(o.aux,6)
                o.aux[t.slot]=nil
            end
        end
    end)

    aux[6]=entry(function(o,t) o.detachedEngine=16 end,function(o,t)
        o.detachedEngine=(o.detachedEngine-2)%16
    end)

    aux[7]=entry(function(o,t)
        t.clock,t.smoke,o.retreatFrame=0,8,15
        o.draws[6],o.nextMotion=true,7
    end,function(o,t)
        if clock(t,'smoke',5) then
            effects.emit(o,0x10,0x1e,4*program.random(o.run,program.randomNarrow),0,false)
        end
        if not clock(t,'clock',5) then return end
        o.retreatFrame=o.retreatFrame-1
        if o.retreatFrame<0 then
            o.draws[6],o.speed,o.aux[t.slot]=nil,0,nil
        end
    end)

    aux[8]=entry(function(o,t)
        t.clock,o.turnFrame=0,15
        o.draws[1],o.draws[2],o.draws[3]=nil,true,nil
        stop(o.aux,1)
        stop(o.aux,3)
    end,function(o,t)
        if not clock(t,'clock',2) then return end
        o.turnFrame=o.turnFrame-1
        if o.turnFrame==0 then
            attach(o.aux,1)
            o.aux[t.slot]=nil
        end
    end)

    events[0]={function(o,t)
        o.nextMotion=0
        o.partAngle=program.random(o.run,program.randomByte)
        o.events[t.slot]=nil
    end,function() end}

    events[1]=entry(function(o,t)
        t.delay=0x40
        attach(o.aux,4)
        o.recoil,o.recoilAngle=0x10,program.random(o.run,program.randomNarrow)
        effects.emitSequence(o,data.leftBreak)
        effects.emitSequence(o,data.rightBreak)
    end,function(o,t)
        t.delay=t.delay-1
        if t.delay==0 then
            o.protected=false
            nextEvent(o,t,7)
        end
    end)

    local function sideDebris(o,offset,angle)
        angle=angle+2*program.random(o.run,program.randomNarrow)
        for _,row in ipairs({{4,10,0},{7,14,1},{4,20,2},{5,28,3},{5,36,6}}) do
            local jitter=math.floor(program.random(o.run,program.randomNarrow)/4)
            effects.emit(o,row[1],row[2],angle+jitter,offset,false,row[3])
        end
    end

    events[2]=entry(function(o,t)
        o.nextMotion=6
        attach(o.aux,4)
        effects.emitSequence(o,data.leftBreak)
        effects.emitSequence(o,data.rightBreak)
        o.recoil,o.recoilAngle=0x10,program.random(o.run,program.randomNarrow)
        t.phase,t.clear,t.delay=0,0x10,0
    end,function(o,t)
        if t.clear>0 then
            t.clear=t.clear-1
            bullets.clear(o.run,1)
        end
        if t.phase==4 then
            t.delay=t.delay-1
            if t.delay==0 then o.finished=true; o.events[t.slot]=nil end
        elseif t.phase==3 then
            t.delay=t.delay-1
            if t.delay==0 then t.phase,t.delay=4,0x80 end
        elseif t.phase==2 then
            if contains(o.aux,7) then return end
            local queue=o.run.spawnQueue
            queue[#queue+1]={[3]=0x9f,[4]=0,[10]=0x16a95c,h=program.s16(o.h-0xd00),l=o.l}
            t.phase,t.delay=3,9
        elseif t.phase==1 then
            if contains(o.aux,4) then return end
            -- 原事件先完成折翼，再把整艘船交给退场槽。帧间效果与船体各自回收。
            for i=0,6 do o.draws[i]=nil end
            tasks.clear(o.aux)
            attach(o.aux,7)
            sideDebris(o,0xf400,0xd0)
            sideDebris(o,0xc00,0x30)
            o.recoil,o.recoilAngle=0x14,0x80+2*program.random(o.run,program.randomNarrow)
            for _,row in ipairs(data.retreatSmoke) do
                effects.emit(o,row[2],math.floor(row[4]/256),row[4]%256+program.random(o.run,program.randomNarrow),
                    row[3],false,row[1])
            end
            effects.emitSequence(o,data.retreatLeft)
            effects.emitSequence(o,data.retreatRight)
            t.phase=2
        else t.phase=1 end
    end)

    events[3]=entry(function(o,t)
        o.nextMotion=2
        t.delay,t.unlock=o.opened and 0 or 0x70,0x20
        if o.opened then attach(o.attacks,0) end
    end,function(o,t)
        if not o.vulnerable then
            t.unlock=t.unlock-1
            if t.unlock==0 then
                o.vulnerable=true
                for i=1,3 do o.extraParts[i].flags=0xa001 end
            end
        end
        if not o.opened and t.delay>0 then
            t.delay=t.delay-1
            if t.delay==0 then o.opened=true; attach(o.attacks,0) end
            return
        end
        if not contains(o.attacks,0) then nextEvent(o,t,4) end
    end)

    events[4]=entry(function(o,t)
        o.nextMotion=1
        attach(o.attacks,1)
        t.delay,t.phase=0x48,0
    end,function(o,t)
        if t.delay>0 then
            t.delay=t.delay-1
            if t.delay>0 then return end
            attach(o.aux,2)
        end
        if t.phase==0 and not contains(o.attacks,1) then
            t.phase=1
            attach(o.attacks,2)
        end
        if t.phase==1 and not contains(o.attacks,2) then nextEvent(o,t,5) end
    end)

    events[5]=entry(function(o,t)
        o.nextMotion=8
        t.turn,t.deploy,t.fire=0x30,0x10,0x40
    end,function(o,t)
        if t.turn>0 then
            t.turn=t.turn-1
            if t.turn>0 then return end
            attach(o.aux,8)
        end
        if t.deploy>0 then
            t.deploy=t.deploy-1
            if t.deploy>0 then return end
            o.detached,o.partProtected,o.partReceding=true,true,true
            o.detachedHealth,o.partDrop=0x10400,0
            o.detachedPalette,o.detachedEnginePalette=21,10
            o.trail,o.trailIndex={},1
            for i=1,8 do o.trail[i]={o.h,o.l} end
            attach(o.aux,5)
        end
        if t.fire>0 then
            t.fire=t.fire-1
            if t.fire>0 then return end
            o.partProtected=false
            attach(o.attacks,3)
        end
        if not contains(o.attacks,3) then nextEvent(o,t,6) end
    end)

    events[6]=entry(function(o,t)
        o.nextMotion=9
        t.open,t.fire,t.close=0x40,0x10,nil
    end,function(o,t)
        if t.open>0 then
            t.open=t.open-1
            if t.open>0 then return end
            attach(o.aux,3)
        end
        if t.fire>0 then
            t.fire=t.fire-1
            if t.fire>0 then return end
            attach(o.attacks,4)
        end
        if not t.close then
            if contains(o.attacks,4) then return end
            o.closeHatch,t.close=true,0x40
        end
        t.close=t.close-1
        if t.close==0 then nextEvent(o,t,3) end
    end)

    events[7]=entry(function(o,t)
        o.nextMotion=10
        t.delay,t.next=0x20,0x20
    end,function(o,t)
        if t.delay>0 then
            t.delay=t.delay-1
            if t.delay>0 then return end
            o.protected=false
            attach(o.attacks,5)
            attach(o.aux,3)
        end
        t.next=t.next-1
        if t.next==0 then
            attach(o.attacks,6)
            o.events[t.slot]=nil
        end
    end)

    events[8]={function(o,t)
        tasks.clear(o.attacks)
        tasks.clear(o.events)
        o.nextMotion,o.protected=5,true
    end,function() end}

    return aux,events
end
