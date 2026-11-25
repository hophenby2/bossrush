-- 随机模式底部沿用宿主血条和位置指示器，独立后端只提供真实 Boss 数据。
local H={pointers={},current={}}
local min,max=math.min,math.max
function H.enabled()
    local scene=stage.current_stage
    local run=lstg.var.rogue_run
    return scene and (scene.stage_name=='RogueTen@RogueTen' or scene.stage_name=='RogueTwo@RogueTwo') and run and not run.finished
end
function H.reset() H.pointers,H.current,H.entry={},{},nil end
local function collect()
    local run=lstg.var.rogue_run
    local entry=run.encounter
    local rows,seen={},{}
    local function add(b,info)
        if not b or not IsValid(b) or seen[b] then return end
        local card=b.current_card
        if b._sequence_road_carrier or card and (card.phase_kind=='road' or card.port_source
            or entry and entry.kind=='road' and card.card_id==entry.cardId) then return end
        local hp=info and info.hp or b.hp
        local maximum=info and info.maxHp or b.maxhp
        if not hp or not maximum or maximum<=0 then return end
        seen[b]=true
        rows[#rows+1]={boss=b,hp=max(0,hp),maxhp=maximum,x=b.x,
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
            local info=source.BossHud.snapshot(rt)
            if info then add(info.boss,info) end
        end
    else
        for _,b in ipairs(boss_group) do add(b) end
    end
    return rows
end
local function synchronize(advance)
    if not H.enabled() then
        if next(H.pointers) or #H.current>0 then H.reset() end
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
        seen[b]=true
    end
    for b in pairs(H.pointers) do if not seen[b] then H.pointers[b]=nil end end
    H.current,H.entry=rows,lstg.var.rogue_run.encounter
end
function H.frame() synchronize(true) end
function H.prepareRender()
    if H.enabled() and (#H.current==0 or H.entry~=lstg.var.rogue_run.encounter) then
        -- 首卡/异步入场可先有Boss再有HUD逻辑帧；绘制前补齐数据，不推进闪烁动画。
        synchronize(false)
    end
end
function H.renderPointers()
    for _,row in ipairs(H.current) do
        local pointer=H.pointers[row.boss]
        if pointer then pointer:render() end
    end
    SetViewMode('ui')
end
return H
