-- 独立Wuhua对象：只收缩，不褪色、不跟随子弹，也不延后子弹判定。
local M={}
local D=dofile('mod/GAME/th38/mist_data.lua')
local scalar=require('ffi').new('float[1]')
local function f32(x) scalar[0]=x;return tonumber(scalar[0]) end
local free,images={},{}
local ready=false
local Renderer
function M.reset()
    free={}
    for i=1,D.limit do free[i]={life=D.first_life} end
end
M.reset()
function M.prepare()
    if ready then return end
    local pool=GetResourceStatus();SetResourceStatus('global')
    for i,p in ipairs(D.sprites) do
        local id='asl_birth_mist_'..i
        LoadTexture(id,p.file);LoadImage(id,id,0,0,p.width,p.height)
        SetImageCenter(id,p.x,p.y);images[i]=id
        if RogueEncounter then RogueEncounter.checkpoint() end
    end
    SetResourceStatus(pool);ready=true
end
function M.clear(c)
    for _,p in ipairs(c.birth_mists or {}) do free[#free+1]=p end
    c.birth_mists=nil
    local renderer=c.mist_renderer;c.mist_renderer=nil
    if renderer and IsValid(renderer) then object.RawDel(renderer) end
end
Renderer=Class(object,{
    init=function(o,c)
        o.owner=c;o.group=GROUP.GHOST;o.layer=LAYER.ENEMY_BULLET+.5;o.bound,o.colli=false,false
    end,
    render=function(o)
        for _,p in ipairs(o.owner.birth_mists or {}) do
            local cfg=D.sprites[p.color]
            SetImageState(images[p.color],p.blend,255,255,255,255)
            Render(images[p.color],p.x,p.y,0,p.size*cfg.scale,p.size*cfg.scale)
        end
    end,
    del=function(o) M.clear(o.owner) end,
},true)
function M.spawn(e,x,y)
    if e.a47~=0 or e.a6_11~=1 or #free==0 then return end
    M.prepare()
    local c=e.c;local profile=e.sourceZi and D.child or D.root
    local base=assert(profile.scales[e.a6_4],'雪莲华缺少原弹型的弹雾参数')
    local sx=e.a6_9==1 and e.a6_8 or e.a6_7
    local p=free[#free];free[#free]=nil
    p.x,p.y=(x-4.5)*48,(y+4.8)*48
    p.color=math.floor(e.a6_5/2)+1
    p.size=f32(f32(base*profile.initial)*sx);p.delta=f32(base*profile.shrink)
    p.left=p.life;p.blend=e.a9_4==1 and 'mul+screen' or ''
    c.birth_mists=c.birth_mists or {};c.birth_mists[#c.birth_mists+1]=p
    if not c.mist_renderer or not IsValid(c.mist_renderer) then c.mist_renderer=New(Renderer,c) end
end
function M.tick(c)
    local rows=c.birth_mists
    if not rows then return end
    local j=1
    for i=1,#rows do
        local p=rows[i];p.left=p.left-1;p.size=f32(p.size-p.delta)
        if p.left>0 then rows[j]=p;j=j+1
        else p.life=D.reused_life;free[#free+1]=p end
    end
    for i=#rows,j,-1 do rows[i]=nil end
end
return M
