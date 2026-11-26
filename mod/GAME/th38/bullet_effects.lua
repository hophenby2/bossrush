-- 原发行版 Xiaodan、Basic/Basic_zi 蓄力及爆发；表现列表不创建额外判定弹。
local D=dofile('mod/GAME/th38/bullet_effects_data.lua')
local Particles=dofile('mod/GAME/th38/particles.lua')
local Presentation=dofile('mod/GAME/th38/presentation.lua')
local mist=dofile('mod/GAME/th38/mist_data.lua')
local scales=mist.child.scales
local M={data=D}
local images,ready,free,count={},false,{},0
local pool
local palette={{1,.25,.25},{1,.25,1},{.25,.25,1},{.25,1,1},{.25,1,.25},{1,1,.25},{1,.5,0},{1,1,1}}
local floatBox=require('ffi').new('float[1]')
local function f32(x) floatBox[0]=x;return tonumber(floatBox[0]) end
local function clamp(x) return math.max(0,math.min(1,x)) end
function M.bindPool(p) pool=p end
function M.baseSize(shape,child) return (child and mist.child or mist.root).scales[shape] end
function M.prepare()
    if ready then return end
    local old=GetResourceStatus();SetResourceStatus('global')
    for key,cfg in pairs(D.sprites) do
        local id='asl_bullet_effect_'..key
        LoadTexture(id,cfg.file);LoadImage(id,id,0,0,unpack(cfg.size))
        SetImageCenter(id,unpack(cfg.center));images[key]=id
        if RogueEncounter then RogueEncounter.checkpoint() end
    end
    SetResourceStatus(old);ready=true
end
local function sprite(key,mat,x,y,angle,sx,sy,color)
    local cfg=D.sprites[key];local blend,tint,gain='',{1,1,1,1},1
    if mat.shader=='Legacy Shaders/Particles/Additive (Soft)' then blend='mul+screen'
    elseif mat.shader=='Legacy Shaders/Particles/Additive' then blend='mul+add';tint=mat.colors._TintColor;gain=2 end
    SetImageState(images[key],blend,clamp(color[4]*tint[4]*gain)*255,
        clamp(color[1]*tint[1]*gain)*255,clamp(color[2]*tint[2]*gain)*255,clamp(color[3]*tint[3]*gain)*255)
    Render(images[key],(x-4.5)*48,(y+4.8)*48,angle,sx*48/cfg.ppu,sy*48/cfg.ppu)
end
local function world(n,parent)
    local p=n.world
    local a=parent and parent.eulerAngles.z or 0
    local sx,sy=parent and parent.lossyScale.x or 1,parent and parent.lossyScale.y or 1
    local x,y=n.x*sx,n.y*sy
    p.position.x=(parent and parent.position.x or 0)+x*cos(a)-y*sin(a)
    p.position.y=(parent and parent.position.y or 0)+x*sin(a)+y*cos(a)
    p.eulerAngles.z=a+n.angle;p.lossyScale.x,p.lossyScale.y=sx*n.sx,sy*n.sy
    for _,child in ipairs(n.children) do world(child,p) end
end
local function clone(cfg)
    local n={cfg=cfg,x=cfg.position[1],y=cfg.position[2],sx=cfg.scale[1],sy=cfg.scale[2],
        angle=math.deg(2*math.atan2(unpack(cfg.rotation))),alpha=cfg.color and cfg.color[4] or 1,
        scripts={},children={},world={position={x=0,y=0,z=0},lossyScale={x=1,y=1,z=1},eulerAngles={z=0}}}
    for _,s in ipairs(cfg.scripts) do n.scripts[#n.scripts+1]={cfg=s,time=0} end
    for _,c in ipairs(cfg.children) do n.children[#n.children+1]=clone(c) end
    if cfg.particles then n.particles=Particles.new(cfg.particles,n.world,D.textures) end
    return n
end
local function start(n)
    if n.particles and n.cfg.particles.playOnAwake then n.particles:Play() end
    local audio=n.cfg.audio
    if audio and audio.playOnAwake then Presentation.sound(audio.clip,(n.world.position.x-4.5)*48,audio.volume) end
    for _,child in ipairs(n.children) do start(child) end
end
local function dispose(n)
    if n.particles then n.particles:Dispose() end
    for _,child in ipairs(n.children) do dispose(child) end
end
local function step(n)
    if n.dead then return end
    for _,s in ipairs(n.scripts) do if not s.done then
        local c,t=s.cfg,s.time
        if c.kind=='Tongyong_death' and t==c.time then n.dead=true;dispose(n)
        elseif c.kind=='Tongyong_suofang' then
            if t==c.time_yanshi then s.dx,s.dy=n.sx-c.mubiao_x,n.sy-c.mubiao_y end
            if t>=c.time_yanshi then
                local k=c.zhijie_or_sin~=0 and 1/c.time_chixu or math.pi/(2*c.time_chixu)*math.sin(math.pi*(t-c.time_yanshi)/c.time_chixu)
                n.sx,n.sy=f32(n.sx-s.dx*k),f32(n.sy-s.dy*k)
            end
            if t==c.time_yanshi+c.time_chixu then
                if c.zhijie_or_sin==0 then n.sx,n.sy=c.mubiao_x,c.mubiao_y end
                s.done=true
            end
        elseif c.kind=='Tongyong_jianxianjianyin' then
            if t>=c.time_yanshi then
                local delta=(c.a_kuadu~=0 and c.a_kuadu or 1)/c.time_long*(c.jianxian_or_jianyin~=0 and 1 or -1)
                n.alpha=f32(n.alpha+delta)
            end
            if t>=c.time_yanshi+c.time_long then
                if c.a_kuadu==0 then n.alpha=c.jianxian_or_jianyin~=0 and 1 or 0 end
                s.done=true
            end
        end
        s.time=t+1
    end end
    for _,child in ipairs(n.children) do step(child) end
end
local function particleStep(n)
    if n.dead then return end
    if n.particles then n.particles:FixedUpdate() end
    for _,child in ipairs(n.children) do particleStep(child) end
end
local function alive(n)
    if n.dead then return false end
    if n.cfg.sprite then return true end
    if n.particles and (n.particles.isPlaying or #n.particles.particles>0) then return true end
    for _,child in ipairs(n.children) do if alive(child) then return true end end
    return false
end
local function anchor(p)
    local a=p.anchor
    if not a then return end
    local n=p.root
    n.x,n.y=a.x,a.y
    n.angle=a.rotation and a.rotation-p.initialAngle or 0
    n.sx,n.sy=(a.scaleX or 1)/p.initialX,(a.scaleY or 1)/p.initialY
    if not a.alive then pool.unpin(a);p.anchor=nil end
end
local function draw(n)
    if n.dead then return end
    local w=n.world;local cfg=n.cfg
    if cfg.sprite then
        local color={cfg.color[1],cfg.color[2],cfg.color[3],n.alpha}
        sprite(cfg.sprite,cfg.material,w.position.x,w.position.y,w.eulerAngles.z,w.lossyScale.x,w.lossyScale.y,color)
    end
    if n.particles then n.particles:Render() end
    for _,child in ipairs(n.children) do draw(child) end
end
function M.render(c,kind)
    if kind=='attack' then
        for _,p in ipairs(c.attack_effects or {}) do anchor(p);world(p.root);draw(p.root) end
    else
        local cfg=D.prefabs.xiaodantexiao
        for _,p in ipairs(c.end_effects or {}) do
            local key=cfg.sprite
            for _,frame in ipairs(cfg.animation) do if frame[1]<=p.age/120 then key=frame[2] else break end end
            local rgb=palette[p.color]
            sprite(key,cfg.material,p.x,p.y,0,p.size,p.size,{rgb[1],rgb[2],rgb[3],1})
        end
    end
end
local Renderer=Class(object,{
    init=function(o,c,kind)
        o.owner,o.kind=c,kind;o.bound,o.colli=false,false;o.group=GROUP.GHOST
        o.layer=LAYER.ENEMY_BULLET+(kind=='attack' and -8 or -1)
    end,
    render=function(o) M.render(o.owner,o.kind) end,
})
local function ensure(c,kind)
    M.prepare()
    local key=kind..'_effects_renderer'
    if not c[key] or not IsValid(c[key]) then c[key]=New(Renderer,c,kind) end
end
function M.emission(e,x,y,host)
    if e.a54_1~=0 and e.a54_1~=1 then return end
    ensure(e.c,'attack')
    local name=(e.a54_1==0 and 'xuli_' or 'baozha_')..math.floor(e.a6_5/2)
    local p={root=clone(assert(D.prefabs[name])),birth=e.c.time+1}
    p.root.x,p.root.y=x,y
    if e.a9_1==1 then
        p.anchor=host or e;p.initialAngle=p.anchor.rotation or 0
        p.initialX,p.initialY=p.anchor.scaleX or 1,p.anchor.scaleY or 1
        pool.pin(p.anchor)
    end
    world(p.root);start(p.root)
    local list=e.c.attack_effects or {};e.c.attack_effects=list;list[#list+1]=p
end
function M.endBullet(s)
    if s.kind~='bullet' or s.dispel~=1 or s.endEffect or count>=D.endLimit then return end
    ensure(s.c,'end')
    local p=table.remove(free) or {};count=count+1;s.endEffect=true
    p.x,p.y,p.age,p.birth=s.x,s.y,0,s.c.time+1
    p.size=(s.dispelSize or assert(scales[s.shape]))*s.scaleY
    p.color=math.floor(s.color/2)+1
    local list=s.c.end_effects or {};s.c.end_effects=list;list[#list+1]=p
end
function M.tick(c)
    local list=c.end_effects or {};local n=0
    for _,p in ipairs(list) do
        p.age=math.max(0,c.time-p.birth)
        if p.age<D.endLife then n=n+1;list[n]=p else count=count-1;free[#free+1]=p end
    end
    for i=#list,n+1,-1 do list[i]=nil end
    list=c.attack_effects or {};n=0
    for _,p in ipairs(list) do
        anchor(p)
        if c.time>=p.birth then step(p.root);world(p.root);particleStep(p.root) end
        if alive(p.root) then n=n+1;list[n]=p
        else dispose(p.root);if p.anchor then pool.unpin(p.anchor) end end
    end
    for i=#list,n+1,-1 do list[i]=nil end
end
function M.clear(c)
    for _,p in ipairs(c.end_effects or {}) do count=count-1;free[#free+1]=p end
    for _,p in ipairs(c.attack_effects or {}) do dispose(p.root);if p.anchor then pool.unpin(p.anchor) end end
    c.end_effects,c.attack_effects=nil,nil
    for _,kind in ipairs({'attack','end'}) do
        local key=kind..'_effects_renderer';local o=c[key];c[key]=nil
        if o and IsValid(o) then object.RawDel(o) end
    end
end
return M
