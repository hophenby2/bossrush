-- 共用 PGM 对象生命周期。作品提供关卡数据和自机类。
return function(source, bullets, Player, level)
    local M = {level=level}
    local abs, max = math.abs, math.max
    local halfWidth,halfHeight=source.halfWidth or 112,source.halfHeight or 224
    local routes = {}
    for _, row in ipairs(source.routes or {}) do
        local route={hp=row[2],first=row[3],second=row[4],change=row[5],changeEnd=row[6],
            defeat=row[7],defeatEnd=row[8],next=row[9],right=row[10],rightEnd=row[11],
            later=row[12],laterEnd=row[13],threshold=row[14],strict=row[15]==1}
        routes[row[1]]=route
        if row[16] then
            route.phases={}
            for i=16,#row,3 do
                route.phases[#route.phases+1]={hp=row[i],first=row[i+1],last=row[i+2]}
            end
        end
    end

    local function nextPhase(state)
        local phase=state.route.phases and state.route.phases[(state.phase or 0)+1]
        if phase and state.hp<phase.hp then return phase end
    end

    local function hit(o, damage)
        local boss = o.host or o
        if o.hp<0 or boss.hp<0 then return end
        local state = boss.bossState
        if state and state.independent and state.independent[o.partId] then
            local parts=state.independent
            parts[o.partId]=parts[o.partId]-damage
            o.hp=parts[o.partId]
            if o.hp<0 and not state.changed then
                local outer=0
                for id=4,7 do if parts[id]<0 then outer=outer+1 end end
                local inner=(parts[2]<0 and 1 or 0)+(parts[3]<0 and 1 or 0)
                if inner==(outer==4 and 2 or 1) then state.request='phase' end
            end
            return
        end
        if state and state.parts and o.partId~=0 then
            local hp = state.parts[o.partId]
            if hp then
                state.parts[o.partId]=hp-damage
                o.hp=state.parts[o.partId]
                if o.hp<0 and not state.request then
                    state.request,state.broken='change',o.partId
                end
                return
            end
        end
        boss.hp=boss.hp-damage
        if state then
            state.hp=boss.hp
            local route=state.route
            if nextPhase(state) then
                state.request='phase'
            elseif route.change and route.change>0 and route.first>0 and not state.parts then
                local threshold = not state.changed and route.hp-route.first
                    or state.later==nil and route.threshold
                if threshold and threshold>0 and (state.hp<threshold or state.hp==threshold
                    and route.second==0 and not route.strict) then
                    state.request=state.changed and 'later' or 'change'
                end
            end
            if boss.hp<0 and not state.request then state.request='defeat' end
        end
    end

    local Part = Class(object, {
        init = function(o, host, id)
            o.run,o.host,o.partId=host.run,host,id
            o.group,o.layer,o.rect=GROUP.ENEMY,LAYER.ENEMY,true
            o.bound,o.colli=false,false
            o.damage=hit
        end,
        colli = function(o, shot)
            if not shot.dmg or not shot.colli or not o.colli then return end
            hit(o,shot.dmg)
            object.RawDel(shot)
        end,
    })

    local function pose(o, frame)
        local entry = o.entry
        source.pose(o,entry.frames[frame])
        local parts = o.parts
        if not parts then
            o.colli=abs(o.x)<halfWidth+o.a and abs(o.y)<halfHeight+o.b
            if source.stageFiles then o.colli=o.colli and #o.pose>5 and o.run.segment~='defeat' end
            return
        end
        for _, part in pairs(parts) do part.colli=false end
        if o.run.segment=='defeat' then return end
        local state=o.bossState
        for id,x,y,a,b in source.eachBox(entry.boxes[frame]) do
            local part=parts[id]
            if not part then part=New(Part,o,id); parts[id]=part end
            part.x,part.y,part.a,part.b=x,y,a,b
            part.hp=state and (state.independent and state.independent[id] or state.parts and state.parts[id]) or o.hp
            part.colli=part.hp>=0 and not (state and state.changed and state.parts and state.parts[id])
                and abs(x)<halfWidth+a and abs(y)<halfHeight+b
        end
    end

    local Enemy = Class(object, {
        init = function(o, run, entry)
            o.run, o.entry, o.age = run, entry, 1
            o.hp, o.maxhp = entry.hp, entry.hp
            o.a, o.b, o.rect = entry.a, entry.b, true
            o.group, o.layer = GROUP.ENEMY, LAYER.ENEMY
            o.bound, o.colli = false, true
            o.damage=hit
            local route=entry.phase==2 and (run.stageRoutes or routes)[entry.kind]
            if route then
                local state=run.bossState
                if not state or state.route~=route then
                    state={route=route,hp=route.hp}
                    if entry.kind==0x0e80 then state.parts={[1]=route.first,[3]=route.second} end
                    local hp=source.partHP and source.partHP[entry.kind]
                    if hp then
                        state.independent={}
                        for id,value in pairs(hp) do state.independent[id]=value end
                    end
                    run.bossState=state
                    if route.last then run.last,run.loop=route.last,route.loop end
                end
                o.bossState=state
                o.hp,o.maxhp=state.hp,route.hp
                if entry.boxes then o.parts,o.colli={},false end
            elseif entry.phase==1 and source.midBoxes then
                o.parts,o.colli={},false
            end
            pose(o,1)
            if entry.phase>0 then run.boss=o end
        end,
        colli = function(o, shot)
            if o.hp<=0 or not shot.dmg or not shot.colli or not o.colli then return end
            hit(o,shot.dmg)
            object.RawDel(shot)
        end,
        render = function(o)
            source.drawPose(o)
        end,
    })
    M.enemy, M.bullet, M.player = Enemy, bullets.Bullet, Player

    local function discard(o)
        for _, part in pairs(o.parts or {}) do object.RawDel(part) end
        o.hide = true
        object.RawDel(o)
    end

    local function remove(run, o, killed)
        local entry = o.entry
        run.actors[entry.id] = nil
        if entry.phase>0 and run.boss==o then run.boss=nil end
        if killed then
            lstg.var.score=lstg.var.score+entry.hp
            PlaySound('enep00',.3,o.x/112,true)
        end
        discard(o)
    end

    local function clearActors(run, clearShots)
        for _, o in pairs(run.actors) do discard(o) end
        run.actors,run.boss = {},nil
        if clearShots~=false then bullets.clear(run) end
    end

    local function applyRequest(run)
        local state=run.bossState
        if not state or not state.request or run.segment=='defeat' then return end
        local request,route=state.request,state.route
        state.request=nil
        if request=='phase' then
            local phase=state.route.phases[(state.phase or 0)+1]
            state.phase=(state.phase or 0)+1
            state.changed=true
            run.frame,run.last,run.loop,run.segment=phase.first,phase.last,phase.first,'change'
            clearActors(run,false)
            -- 清算一次跨越多档的伤害，让每段先进入原版记录的首帧。
            if nextPhase(state) then state.request='phase'
            elseif state.hp<0 then state.request='defeat' end
        elseif request=='change' or request=='later' then
            state.changed=true
            if state.parts then state.parts[1],state.parts[3]=0,0 end
            -- 原作的累计伤害会带入后一段。若单次伤害跨过两条线，先保留阶段切换。
            if state.hp<0 then state.hp,state.request=0,'defeat' end
            local entry, last = route.change, route.changeEnd
            if request=='later' then
                state.later=true
                entry,last=route.later,route.laterEnd
            elseif state.broken==3 and route.right and route.right>0 then
                entry,last=route.right,route.rightEnd
            end
            run.frame,run.last,run.loop,run.segment=entry,last,entry,'change'
            clearActors(run,not state.parts)
        elseif route.defeat>0 then
            run.frame,run.last,run.loop,run.segment=route.defeat,route.defeatEnd,nil,'defeat'
            clearActors(run)
        else
            run.done=true
            clearActors(run)
        end
    end

    local function step(run)
        applyRequest(run)
        if run.done then return end
        local frame = run.frame
        source.updateBackground(run,frame)
        if source.road then run.roadFrame=frame end
        for _, o in pairs(run.actors) do
            local entry = o.entry
            local nextPose = entry.frames[o.age+1]
            if o.hp<=0 and not o.bossState then
                remove(run,o,true)
                if entry.phase==1 then run.midCleared=true end
                if entry.phase==2 then
                    clearActors(run)
                    if not source.second or frame>=source.second then run.done=true; return end
                    run.frame=source.second
                    return
                end
            elseif nextPose then
                o.age=o.age+1
                pose(o,o.age)
            else
                remove(run,o,false)
            end
        end
        for _, entry in ipairs(run.data.enemies[frame] or {}) do
            if entry.phase~=1 or not run.midCleared then
                local o = New(Enemy,run,entry)
                run.actors[entry.id]=o
                if entry.phase==2 and not o.bossState then
                    if not source.second or frame<source.second then run.bossEntry=frame end
                    if run.bossHP then o.hp,run.bossHP=run.bossHP,nil end
                end
            end
        end
        for _, shot in ipairs(run.data.shots[frame] or {}) do bullets.emit(run,shot) end
        if frame==run.last and run.segment=='defeat' then
            local route=run.bossState.route
            clearActors(run)
            if route.resume then
                run.segment,run.bossState,run.midCleared=nil,nil,false
                run.frame,run.last,run.loop=route.resume,route.resumeLast,route.resumeLoop
            elseif route.next==0 then
                run.done=true
            else
                run.stageNumber,run.segment,run.bossState=run.stageNumber+1,nil,nil
                if source.stageFiles then
                    bullets.clear(run,true)
                    source.loadStage(run,run.stageNumber)
                else
                    run.frame,run.last,run.loop=route.next,source['last'..run.stageNumber],source['loop'..run.stageNumber]
                end
                run.midCleared=false
            end
        elseif frame==run.last and source.cvTiles then
            local boss=run.boss
            local entry=IsValid(boss) and boss.entry
            if entry and run.loop>=entry.time and run.loop<entry.time+#entry.frames then
                boss.age=run.loop-entry.time+1
                pose(boss,boss.age)
                if run.loop==entry.time then run.frame=run.loop+1; return end
            else
                clearActors(run,false)
            end
            run.frame=run.loop
        elseif frame==run.last or frame==source.finish then
            local hp=IsValid(run.boss) and run.boss.hp
            clearActors(run)
            run.frame=frame==run.last and (run.loop or assert(run.bossEntry)) or source.second
            if not run.bossState then run.bossHP=hp end
        else
            run.frame=frame+1
        end
    end

    local HUD = Class(object, {
        init = function(o, run)
            o.run, o.group, o.layer, o.bound = run, GROUP.GHOST, LAYER.TOP, false
        end,
        render = function(o)
            local b = o.run.boss
            if IsValid(b) and o.run.segment~='defeat' then
                local barY=halfHeight-20
                local barX=halfWidth-6
                SetImageState('white','',216,29,42,50)
                RenderRect('white',-barX-2,barX+2,barY-2,barY+4)
                SetImageState('white','',255,109,233,124)
                RenderRect('white',-barX,-barX+2*barX*max(0,b.hp/b.maxhp),barY,barY+2)
                SetImageState('white','',255,255,255,255)
            end
        end,
    })

    function M.open(scene)
        source.loadImages()
        local w = lstg.world
        scene.pgmWorld = {w.l,w.r,w.b,w.t,w.boundl,w.boundr,w.boundb,w.boundt,
            w.scrl,w.scrr,w.scrb,w.scrt,w.pl,w.pr,w.pb,w.pt,w.world}
        local center = (w.scrl+w.scrr)/2
        local half = (w.scrt-w.scrb)*halfWidth/(2*halfHeight)
        OriginalSetWorld(-halfWidth,halfWidth,-halfHeight,halfHeight,-160,160,-270,270,
            center-half,center+half,w.scrb,w.scrt,-halfWidth,halfWidth,-halfHeight,halfHeight,w.world)
        SetBound(-160,160,-270,270)
        local run={actors={},tiles={},camera=0,scroll=0,frame=0,serial=0,clock=0,
            stageNumber=1,last=source.last,loop=source.loop}
        if source.stageFiles then source.loadStage(run,1)
        else run.data=source.load() end
        if source.road then source.road.open(run) end
        scene.pgmRun=run
        lstg.tmpvar.pgmRun=run
        run.background = New(source.Background,run)
        run.hud = New(HUD,run)
    end

    function M.run(scene, sequence)
        local run = scene.pgmRun
        local clockStep,clockUnit=source.clockStep or 10000000,source.clockUnit or 10137600
        while not run.done do
            -- PGM 原时钟为 10MHz / (640 × 264)，项目渲染仍按 60Hz。
            run.clock=run.clock+clockStep
            if run.clock>=clockUnit then
                run.clock=run.clock-clockUnit
                run.serial=run.serial+1
                step(run)
                if sequence then
                    if sequence.chapter~=run.stageNumber then
                        sequence.chapter,sequence.chapter_name=run.stageNumber,tostring(run.stageNumber)
                        sequence.completed=run.stageNumber-1
                    end
                    sequence.road_time=run.frame
                end
            end
            task.Wait()
        end
        clearActors(run)
        for _=1,90 do
            run.serial=run.serial+1
            task.Wait()
        end
        if sequence then sequence.completed=run.stageNumber end
    end

    function M.close(scene)
        if not scene.pgmWorld then return end
        local run = scene.pgmRun
        -- RawDel 延至帧尾回收，先停止绘制，避免卸掉图集后还访问旧背景。
        for _, o in ipairs({run.background, run.hud}) do
            if IsValid(o) then
                o.hide = true
                object.RawDel(o)
            end
        end
        if source.road then source.road.close(run) end
        if source.stageFiles then
            clearActors(run,false)
            bullets.clear(run,true)
            source.unloadStage(run)
        end
        OriginalSetWorld(unpack(scene.pgmWorld))
        SetBound(lstg.world.boundl,lstg.world.boundr,lstg.world.boundb,lstg.world.boundt)
        lstg.tmpvar.pgmRun=nil
        scene.pgmRun,scene.pgmWorld=nil,nil
    end

    if NativePlayers then
        NativePlayers.adapters[level]={
            spawn=function()
                local run = assert(lstg.tmpvar.pgmRun)
                local player = New(Player,run)
                if source.road then source.road.attach(run,player) end
                return player
            end,
        }
    end
    return M
end
