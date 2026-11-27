-- 随机模式沿用宿主血条、血圈和位置指示器，独立后端只提供真实 Boss 数据。
local H={pointers={},rings={},current={},retired={}}
local hpRing=dofile('THlib/enemy/portrait_hp.lua')
local min,max=math.min,math.max
function H.enabled()
    local scene=stage.current_stage
    local run=lstg.var.rogue_run
    return scene and (scene.stage_name=='RogueTen@RogueTen' or scene.stage_name=='RogueTwo@RogueTwo') and run and not run.finished
end
function H.reset() H.pointers,H.rings,H.current,H.entry={},{},{},nil end
local function collect()
    local run=lstg.var.rogue_run
    local entry=run.encounter
    local rows,seen={},{}
    local function add(b,info)
        if not b or not IsValid(b) or seen[b] then return end
        if b.asl_controller and b.asl_controller.linked then
            -- 双子星的流程宿主没有受击血槽；底条、血圈和位置箭头均取两个真实身体。
            seen[b]=true
            for _,s in ipairs(b.asl_controller.entities) do
                if s.kind=='boss' and s.alive then add(s.native) end
            end
            return
        end
        local card=b.current_card
        if b._sequence_road_carrier or card and (card.phase_kind=='road' or card.port_source
            or entry and entry.kind=='road' and card.card_id==entry.cardId) then return end
        local hp=info and info.hp or b.hp
        local maximum=info and info.maxHp or b.maxhp
        if not hp or not maximum or maximum<=0 then return end
        local combat=b.is_combat
        if entry and entry.level==39 then
            -- 祈华梦将战斗状态保存在卡片系统，Boss实例上没有is_combat。
            local current=b._bosssys:GetCurrentCard()
            combat=current and current.is_combat
        end
        seen[b]=true
        rows[#rows+1]={boss=b,hp=max(0,hp),maxhp=maximum,x=b.x,y=b.y,info=info,is_combat=combat,
            countdown=info and info.countdown/60 or b.ui and b.ui.countdown or b.countdown,
            name=b.name and b.name~='' and b.name or entry and entry.title or '',
            dmgt=b.dmgt or 0,dmgmaxt=max(.001,b.dmgmaxt or 1),
            __hpbar_timer=90,_sp_point_auto=b._sp_point_auto or {}}
    end
    if entry and entry.level==39 then
        local work=GameContent.ports[39]
        local env=work and work.source
        if env then
            for _,b in ipairs(env.boss.GetBossTable()) do add(b) end
        end
    elseif entry and entry.level==40 then
        local work=GameContent.ports[40]
        local source=work and work.source
        local rt=source and source.runtime
        if rt then
            for _,info in ipairs(source.BossHud.snapshots(rt)) do add(info.boss,info) end
        end
    else
        for _,b in ipairs(boss_group) do add(b) end
    end
    return rows
end
local function retireHeader(h)
    if h.retired then return end
    h.retired=true
    if IsValid(h.name) and h.name.header_layout then
        -- 使用组件自身的del/frame退场，不能在切卡时直接RawDel截断动画。
        object.Del(h.name)
        H.retired[#H.retired+1]=h
    else
        if IsValid(h.name) then object.RawDel(h.name) end
        if IsValid(h.carrier) then object.RawDel(h.carrier) end
    end
end
local function clearHeaders()
    for _,h in ipairs(H.headers or {}) do retireHeader(h) end
    H.headers,H.headerTitle,H.headerTick={},nil,nil
end
function H.updateHeaders(run,advance)
    for i=#H.retired,1,-1 do
        local h=H.retired[i]
        if not IsValid(h.name) then
            if IsValid(h.carrier) then object.RawDel(h.carrier) end
            table.remove(H.retired,i)
        end
    end
    local title=run and not run.finished and not run.preparing and run.card_title
    if not title then clearHeaders();return end
    if H.headerTitle~=title then
        clearHeaders();H.headerTitle=title
        for i,name in ipairs(title.names) do
            local carrier=New(object)
            carrier.group,carrier.bound,carrier.colli,carrier.hide=GROUP.GHOST,false,false,true
            carrier.is_sc,carrier.ui_slot,carrier.current_card=true,i,{phase_name=name}
            local display={drawtime=true,countdown=0}
            local label=New(boss.sc_name,carrier,name,false)
            label.rogue_header,label.hide=true,true
            label.xoffset,label.xoffset2,label.talpha,label.talpha3=0,0,1,1
            local counter=boss.timeCounter(display,{boss=carrier})
            -- 运行时原有计时器继续负责音效；这里只接原生组件的显示。
            carrier.NotPlayTimeOutSound=true
            H.headers[i]={carrier=carrier,name=label,counter=counter,display=display}
        end
    end
    local rows=H.enabled() and H.current or (lstg.var.rogue_run and collect() or {})
    local tick=stage.current_stage.timer
    for i,h in ipairs(H.headers) do
        if not h.retired then
            local row=rows[i] or rows[1]
            if row and not IsValid(row.boss) then row=nil end
            local b=h.carrier
            b.is_combat=not not (row and (row.is_combat or row.info and (row.info.phaseMode==1 or row.info.phaseMode==5)))
            b.__is_waiting=not b.is_combat or row and row.boss.__is_waiting
            b.x,b.y=row and row.x or 0,row and row.y or 0
            b.timer=math.max(30,row and row.boss.timer or 30)
            if row then b.is_exploding=row.boss.is_exploding end
            h.display.countdown=row and row.countdown or 0
            if advance and H.headerTick~=tick then h.counter:frame() end
            if b.is_combat then h.engaged=true elseif h.engaged then retireHeader(h) end
        end
    end
    if advance then H.headerTick=tick end
end
function H.renderHeaders(run,rows,settled,headerLayout)
    H.updateHeaders(run,false)
    for _,h in ipairs(H.retired) do
        if IsValid(h.name) then boss.sc_name.render(h.name) end
    end
    for i,h in ipairs(H.headers or {}) do
        if not h.retired then
            local p=headerLayout(i)
            h.counter.header_layout={right=p.right,y=p.timerY or p.y}
            h.counter:render()
            if rows[i] then
                h.name.header_layout=rows[i];h.name.header_layout.background=true
                if settled then boss.sc_name.render(h.name) end
            end
        end
    end
end
local function synchronize(advance)
    if not H.enabled() then
        if next(H.pointers) or next(H.rings) or #H.current>0 then H.reset() end
        return
    end
    local rows,seen=collect(),{}
    local w=lstg.world
    for _,row in ipairs(rows) do
        local b=row.boss
        local pointer=H.pointers[b]
        if not pointer then
            pointer=boss.pointer({drawpointer=true,rogue_bottom=true},{boss=b})
            H.pointers[b]=pointer
        end
        pointer.ui.pointer_x=min(w.r-24,max(w.l+24,row.x))
        pointer.y=w.b
        if advance then pointer:frame() end
        -- 随机模式由宿主统一画真实Boss的血圈；原作UI的hide/drawhp/no_hp_render
        -- 只用于让位原作专用HUD，不能连同随机模式血圈一起关闭。
        local ring=H.rings[b]
        if not ring then ring={boss={},drawhp=true};H.rings[b]=ring end
        ring.actorBoss=b
        local state,info=ring.boss,row.info
        state.x,state.y,state.hp,state.maxhp=row.x,row.y,row.hp,row.maxhp
        state.is_combat=info and info.phaseMode==1 or not info and row.is_combat
        state.__is_waiting=b.__is_waiting
        state.time_sc=b.time_sc or info and info.phaseMode==5
        state.__hpbar_timer=b.__hpbar_timer or info and info.timer or b.timer or 0
        state.sp_point,state._sp_point_auto=b.sp_point,b._sp_point_auto
        if advance then hpRing.frameActors(ring) end
        seen[b]=true
    end
    for b in pairs(H.pointers) do if not seen[b] then H.pointers[b]=nil end end
    for b in pairs(H.rings) do if not seen[b] then H.rings[b]=nil end end
    H.current,H.entry=rows,lstg.var.rogue_run.encounter
end
function H.frame() synchronize(true) end
function H.prepareRender()
    if H.enabled() and (#H.current==0 or H.entry~=lstg.var.rogue_run.encounter) then
        -- 首卡/异步入场可先有Boss再有HUD逻辑帧；绘制前补齐数据，不推进闪烁动画。
        synchronize(false)
    end
end
function H.renderRings()
    local previous=lstg.viewmode
    SetViewMode('world')
    for _,row in ipairs(H.current) do
        local ring=H.rings[row.boss]
        if ring then hpRing.drawActors(ring) end
    end
    if previous then SetViewMode(previous) end
end
function H.renderPointers()
    for _,row in ipairs(H.current) do
        local pointer=H.pointers[row.boss]
        if pointer then pointer:render() end
    end
    SetViewMode('ui')
end
return H
