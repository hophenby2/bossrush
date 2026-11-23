-- 关卡背景与符卡背景由原作 CrazyStorm 发射器分别驱动。
local B={}
local D=dofile('mod/GAME/th39/scenes/index.lua')
local presentation=dofile('mod/GAME/th39/scenes/presentation.lua')
for key,height in pairs(presentation.textureHeights) do D.textureHeights[key]=height end
local R
local snapshot,ready
local spellScene
local function spellOnly() return RogueEncounter and RogueEncounter.spellOnly(37) end
local function spellState(chapter)
    return {chapter=chapter,script=D.stages[chapter.script],effects={},serial=0,fade=0,
        resources={tex={},img={}},spellOnly=true}
end
local applyCard,applyEnd
local shake={{-1,0},{0,1},{0,-1},{1,0},{-1,1},{1,-1},{-1,-1},{1,1},{0,0}}
local function track(scene,id,x,y,order,number)
    scene.serial=scene.serial+1
    local c=R.backgroundEffect(id,x,y,scene.serial,D.textureHeights,scene.resources,scene.seekPlayer)
    c.ownerScene=scene
    c.order,c.number=order,number
    c.onQuake=function(duration,strength)
        if not scene.quake then scene.quake={time=0,duration=duration,strength=strength*2/3} end
    end
    return c
end
local function change(scene,event)
    local op,number=event[1],event[2]
    if op=='RaiseEffect' then
        local c=track(scene,number,event[3],event[4],event[5])
        c.once=true;c.presentation=true;scene.effects[#scene.effects+1]=c
        return
    elseif op=='PlaySound' or op=='FadeinEnvSound' then
        if not scene.seeking then
            if op=='FadeinEnvSound' then R.fadeEnvironment(event[3],true) end
            R.sound(number,op=='PlaySound' and event[3] or nil)
        end
        return
    elseif op=='FadeoutEnvSound' then
        if not scene.seeking then R.fadeEnvironment(number) end
        return
    end
    if op=='SetBackgroundEffect' or op=='ReplaceBackgroundEffect' then
        if op=='ReplaceBackgroundEffect' then
            local kept={};for _,c in ipairs(scene.effects) do if c.presentation then kept[#kept+1]=c end end
            scene.effects=kept
        end
        if setting and setting.displayBG then scene.effects[#scene.effects+1]=track(scene,event[6],event[3],event[4],event[5],number) end
        return
    end
    if op=='FadeinBackground' then scene.fade=1;return end
    for _,c in ipairs(scene.effects) do
        if c.number==number then
            if op=='StopBackgroundEffect' then c.closing=true
            elseif op=='BreakBackgroundEffect' then c.closing=true;c.breakAge=0
            elseif op=='AdjustBackgroundEffect' then
                c.tint={from=c.color or {255,255,255,1},to={event[3],event[4],event[5],event[6]},duration=event[9],time=0}
            end
            break
        end
    end
end
local function tickEffects(list,presentationOnly)
    for i=#list,1,-1 do
        local c=list[i]
        if not presentationOnly or c.presentation then
        local tint=c.tint
        if tint then
            tint.time=tint.time+1
            local f=math.min(1,tint.time/math.max(1,tint.duration))
            local color={}
            for j=1,4 do color[j]=tint.from[j]+(tint.to[j]-tint.from[j])*f end
            c.color=color
            if f==1 then c.tint=nil end
        end
        if c.breakAge then c.breakAge=c.breakAge+1
        else
            if c.once and c.time>=c.pattern.total then c.closing=true end
            R.tickBackground(c)
        end
        if c.breakAge and c.breakAge>=15 or c.closing and #c.particles==0 then
            table.remove(list,i)
        end
        end
    end
end
local function update(o)
    tickEffects(o.effects,o.spell and not o.spell.keep)
    if o.spell then tickEffects(o.spell.effects) end
    if o.portrait then tickEffects(o.portrait) end
    if o.fade>0 then o.fade=math.max(0,o.fade-.01) end
    local quake=o.quake
    o.shakeX,o.shakeY=0,0
    if quake then
        local movement=shake[quake.time%9+1]
        o.shakeX,o.shakeY=movement[1]*quake.strength,-movement[2]*quake.strength
        quake.time=quake.time+1
        if quake.time>=quake.duration then o.quake=nil end
    end
end
local function apply(o,t)
    local events=o.script.timeline[tostring(t)]
    for _,event in ipairs(events or {}) do change(o,event) end
    local extra=presentation.stages[o.chapter.script]
    for _,event in ipairs(extra and extra[tostring(t)] or {}) do change(o,event) end
end
local function draw(o,order)
    SetViewMode('world')
    for _,c in ipairs(o.effects) do
        if c.order==order and (c.presentation or setting and setting.displayBG and (not o.spell or o.spell.keep)) then R.drawBackground(c,1-(c.breakAge or 0)/15,o.shakeX,o.shakeY) end
    end
end
local Pass=Class(object,{
    init=function(o,scene,order,layer)
        o.scene,o.order,o.layer=scene,order,layer
        o.group,o.colli,o.bound=GROUP.GHOST,false,false
    end,
    frame=function(o) if not IsValid(o.scene) then Del(o) end end,
    render=function(o)
        if not IsValid(o.scene) or not o.scene.state then return end
        if o.order=='portrait' then
            for _,c in ipairs(o.scene.state.portrait or {}) do R.drawBackground(c,1,0,0) end
        else draw(o.scene.state,o.order) end
    end,
})
local function preview(o,point)
    o.seekPlayer=point
    for _,list in ipairs({o.effects,o.spell and o.spell.effects or {},o.portrait or {}}) do
        for _,c in ipairs(list) do c.previewPlayer=point end
    end
end
local Scene=Class(background,{
    init=function(o,chapter,start)
        o.spellOnly=spellOnly() or false
        if o.spellOnly then spellScene=o
        else background.DelBG();lstg.tmpvar.bg=o end
        o.chapter=chapter
        o.pending={}
        o.group,o.layer,o.colli,o.bound=GROUP.GHOST,LAYER.BG-.1,false,false
        local px,py=R.player()
        local prepared=ready and ready.chapter==chapter and ready.start==start and ready.spellOnly==o.spellOnly and ready
        ready=nil
        if o.spellOnly then o.state=prepared and prepared.state or spellState(chapter)
        elseif prepared and prepared.px==px and prepared.py==py then o.state=prepared.state
        else
            -- 玩家可能在45帧入场期间移动。不能使用瞄准旧位置的快照，也不能在 New 回调内挂起。
            local point={px,py}
            local function finish()
                if not IsValid(o) then return end
                local state=B.seek(chapter,start,point,prepared and prepared.state.resources)
                for _,event in ipairs(o.pending) do
                    preview(state,event[3])
                    if event[1]=='frame' then update(state)
                    elseif event[1]=='card' then applyCard(state,unpack(event[2]))
                    elseif event[1]=='end' then applyEnd(state,unpack(event[2]))
                    else apply(state,event[2]);state.stageTick=event[2] end
                    preview(state,nil)
                end
                state.seekPlayer=nil;o.pending={};o.state=state
            end
            if not (RogueEncounter and RogueEncounter.deferBackground and RogueEncounter.deferBackground(finish)) then finish() end
        end
        New(Pass,o,1,LAYER.PLAYER_BULLET+.01)
        New(Pass,o,2,LAYER.ENEMY_BULLET-.01)
        New(Pass,o,0,LAYER.ENEMY_BULLET+.1)
        New(Pass,o,'portrait',LAYER.TOP-10)
    end,
    frame=function(o)
        if o.state then update(o.state)
        else local x,y=R.player();o.pending[#o.pending+1]={'frame',nil,{x,y}} end
    end,
    render=function(o)
        o=o.state
        if not o then return end
        if not setting or not setting.displayBG then draw(o,4);draw(o,3);return end
        SetViewMode('world')
        local w=lstg.world
        if not o.spellOnly then
            SetImageState('white','',255,0,0,0)
            RenderRect('white',w.l,w.r,w.b,w.t)
            SetImageState('white','',255,255,255,255)
        end
        draw(o,4)
        draw(o,3)
        if o.spell then
            for _,c in ipairs(o.spell.effects) do R.drawBackground(c,1,o.shakeX,o.shakeY) end
        end
        if o.fade>0 then
            SetImageState('white','',o.fade*255,0,0,0)
            RenderRect('white',w.l,w.r,w.b,w.t)
            SetImageState('white','',255,255,255,255)
        end
    end,
    del=function(o)
        if spellScene==o then spellScene=nil end
        if RogueEncounter and RogueEncounter.stopping then return end
        o=o.state
        if not o then return end
        for name,pool in pairs(o.resources.img) do lstg.RemoveResource(pool,2,name) end
        for name,pool in pairs(o.resources.tex) do lstg.RemoveResource(pool,1,name) end
    end,
},true)
local function current()
    local o=spellOnly() and spellScene or lstg.tmpvar.bg
    if IsValid(o) and o.class==Scene then return o end
end
function B.seek(chapter,start,point,resources)
    local o={chapter=chapter,script=D.stages[chapter.script],effects={},serial=0,fade=0,seekPlayer=point,resources=resources or {tex={},img={}},seeking=true}
    local t=0
    while t<start do
        apply(o,t);update(o)
        local jump=o.script.jumps[tostring(t)]
        t=jump and jump>t and jump or t+1
        if RogueEncounter then RogueEncounter.checkpoint() end
    end
    o.seekPlayer=nil
    o.seeking=false
    for _,c in ipairs(o.effects) do c.previewPlayer=nil end
    return o
end
function B.prepare(runtime,chapter,start,group,meta)
    R=runtime
    if not setting or not setting.displayBG then return end
    local px,py=R.player()
    local only=spellOnly() or false
    local state
    if only then
        -- 随机模式只准备本卡的立绘与符卡特效，不从第0帧预演道中背景。
        state=spellState(chapter)
    else
        if not snapshot or snapshot.chapter~=chapter or snapshot.start~=start or snapshot.px~=px or snapshot.py~=py then
            snapshot={chapter=chapter,start=start,px=px,py=py,state=B.seek(chapter,start,{px,py})}
        end
        state=RogueEncounter.copyPrepared(snapshot.state)
    end
    for _,c in ipairs(state.effects) do
        c.onQuake=function(duration,strength)
            if not state.quake then state.quake={time=0,duration=duration,strength=strength*2/3} end
        end
        R.prepareBackground(c)
    end
    if group then
        local config=state.script.groups[group.index]
        local card=config.cards[tostring(meta.number)]
        local ids={}
        if card.portrait then ids[#ids+1]=card.portrait end
        for _,effect in ipairs(meta.kind~=0 and D.spells[tostring(chapter.stage)][tostring(card.variant or config.variant)] or {}) do ids[#ids+1]=effect[1] end
        for _,id in ipairs(ids) do R.prepareBackground(R.backgroundEffect(id,0,0,7919,D.textureHeights,state.resources)) end
    end
    ready={chapter=chapter,start=start,px=px,py=py,state=state,spellOnly=only}
end
function B.clearPrepared() snapshot,ready=nil,nil end
function B.show(runtime,chapter,start)
    R=runtime
    local o=current()
    if not o or o.chapter~=chapter then o=New(Scene,chapter,start or 0) end
    return o
end
function B.tick(t)
    local o=current()
    if o and o.spellOnly then return end
    if o and not o.state then
        if o.pendingStageTick~=t then
            local x,y=R.player();o.pending[#o.pending+1]={'tick',t,{x,y}};o.pendingStageTick=t
        end
        return
    end
    o=o and o.state
    if o and o.stageTick~=t then
        apply(o,t)
        o.stageTick=t
    end
end
applyCard=function(o,group,meta)
    local chapter=o.chapter
    local config=o.script.groups[group.index]
    local card=config.cards[tostring(meta.number)]
    local variant=card.variant or config.variant
    if card.portrait and not (meta.flags and table.concat(meta.flags,','):find('INFINITE')) then
        o.portrait={track(o,card.portrait,481,360)}
        o.portrait[1].once=true
    end
    if meta.kind~=0 and setting and setting.displayBG then
        local effects=D.spells[tostring(chapter.stage)][tostring(variant)]
        if effects then
            o.spell={keep=card.keep,effects={}}
            for _,effect in ipairs(effects) do
                -- CreateBossBackgroundEffect 有额外的屏幕左缘与 CrazyStorm 中心偏移。
                o.spell.effects[#o.spell.effects+1]=track(o,effect[1],effect[2]+48+145,effect[3])
            end
        end
    end
end
applyEnd=function(o,group,meta)
    local card=o.script.groups[group.index].cards[tostring(meta.number)]
    o.spell=nil;o.portrait=nil
    if card.replace and not o.spellOnly then change(o,card.replace) end
end
function B.card(chapter,group,meta)
    local o=B.show(R,chapter,group.time)
    if not o then return end
    if o.state then applyCard(o.state,group,meta)
    else local x,y=R.player();o.pending[#o.pending+1]={'card',{group,meta},{x,y}} end
end
function B.endCard(group,meta)
    local o=current()
    if not o then return end
    if o.state then applyEnd(o.state,group,meta)
    else local x,y=R.player();o.pending[#o.pending+1]={'end',{group,meta},{x,y}} end
end
return B
