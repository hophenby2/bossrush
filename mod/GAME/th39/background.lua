-- 关卡背景与符卡背景由原作 CrazyStorm 发射器分别驱动。
local B={}
local D=dofile('mod/GAME/th39/scenes/index.lua')
local R
local shake={{-1,0},{0,1},{0,-1},{1,0},{-1,1},{1,-1},{-1,-1},{1,1},{0,0}}
local function track(scene,id,x,y,order,number)
    scene.serial=scene.serial+1
    local c=R.backgroundEffect(id,x,y,scene.serial,D.textureHeights,scene.resources)
    c.order,c.number=order,number
    c.onQuake=function(duration,strength)
        if not scene.quake then scene.quake={time=0,duration=duration,strength=strength*2/3} end
    end
    return c
end
local function change(scene,event)
    local op,number=event[1],event[2]
    if op=='SetBackgroundEffect' or op=='ReplaceBackgroundEffect' then
        if op=='ReplaceBackgroundEffect' then scene.effects={} end
        scene.effects[#scene.effects+1]=track(scene,event[6],event[3],event[4],event[5],number)
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
local function tickEffects(list)
    for i=#list,1,-1 do
        local c=list[i]
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
        else R.tickBackground(c) end
        if c.breakAge and c.breakAge>=15 or c.closing and #c.particles==0 then
            table.remove(list,i)
        end
    end
end
local function update(o)
    if not o.spell or o.spell.keep then tickEffects(o.effects) end
    if o.spell then tickEffects(o.spell.effects) end
    if o.fade>0 then o.fade=math.max(0,o.fade-.01) end
    local quake=o.quake
    o.dx,o.dy=0,0
    if quake then
        local movement=shake[quake.time%9+1]
        o.dx,o.dy=movement[1]*quake.strength,-movement[2]*quake.strength
        quake.time=quake.time+1
        if quake.time>=quake.duration then o.quake=nil end
    end
end
local function apply(o,t)
    local events=o.script.timeline[tostring(t)]
    for _,event in ipairs(events or {}) do change(o,event) end
end
local function draw(o,order)
    if not setting or not setting.displayBG then return end
    if o.spell and not o.spell.keep then return end
    SetViewMode('world')
    for _,c in ipairs(o.effects) do
        if c.order==order then R.drawBackground(c,1-(c.breakAge or 0)/15,o.dx,o.dy) end
    end
end
local Pass=Class(object,{
    init=function(o,scene,order,layer)
        o.scene,o.order,o.layer=scene,order,layer
        o.group,o.colli,o.bound=GROUP.GHOST,false,false
    end,
    frame=function(o) if not IsValid(o.scene) then Del(o) end end,
    render=function(o) if IsValid(o.scene) then draw(o.scene,o.order) end end,
})
local Scene=Class(background,{
    init=function(o,chapter,start)
        background.DelBG()
        lstg.tmpvar.bg=o
        o.chapter,o.script=chapter,D.stages[chapter.script]
        o.group,o.layer,o.colli,o.bound=GROUP.GHOST,LAYER.BG-.1,false,false
        o.effects,o.serial,o.fade={},0,0
        o.resources={tex={},img={}}
        local t=0
        while t<start do
            apply(o,t)
            update(o)
            local jump=o.script.jumps[tostring(t)]
            t=jump and jump>t and jump or t+1
        end
        New(Pass,o,1,LAYER.PLAYER_BULLET+.01)
        New(Pass,o,2,LAYER.ENEMY_BULLET-.01)
        New(Pass,o,0,LAYER.ENEMY_BULLET+.1)
    end,
    frame=update,
    render=function(o)
        if not setting or not setting.displayBG then return end
        SetViewMode('world')
        local w=lstg.world
        SetImageState('white','',255,0,0,0)
        RenderRect('white',w.l,w.r,w.b,w.t)
        SetImageState('white','',255,255,255,255)
        draw(o,4)
        draw(o,3)
        if o.spell then
            for _,c in ipairs(o.spell.effects) do R.drawBackground(c,1,o.dx,o.dy) end
        end
        if o.fade>0 then
            SetImageState('white','',o.fade*255,0,0,0)
            RenderRect('white',w.l,w.r,w.b,w.t)
            SetImageState('white','',255,255,255,255)
        end
    end,
    del=function(o)
        for name,pool in pairs(o.resources.img) do lstg.RemoveResource(pool,2,name) end
        for name,pool in pairs(o.resources.tex) do lstg.RemoveResource(pool,1,name) end
    end,
},true)
local function current()
    local o=lstg.tmpvar.bg
    if IsValid(o) and o.class==Scene then return o end
end
function B.show(runtime,chapter,start)
    R=runtime
    if not setting or not setting.displayBG then return end
    local o=current()
    if not o or o.chapter~=chapter then o=New(Scene,chapter,start or 0) end
    return o
end
function B.tick(t)
    local o=current()
    if o and o.stageTick~=t then
        apply(o,t)
        o.stageTick=t
    end
end
function B.card(chapter,group,meta)
    local o=B.show(R,chapter,group.time)
    if not o then return end
    local config=o.script.groups[group.index]
    local card=config.cards[tostring(meta.number)]
    local variant=card.variant or config.variant
    if meta.kind~=0 then
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
function B.endCard(group,meta)
    local o=current()
    if not o then return end
    local card=o.script.groups[group.index].cards[tostring(meta.number)]
    o.spell=nil
    if card.replace then change(o,card.replace) end
end
return B
