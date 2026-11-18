-- 雪莲华的结界、决死、掉命演出以及原作 HUD 贴图。
local V={}
local root='Resources/th38/presentation/'
local target='th38_death_scene'
local fx='th38_death_invert'
local ready=false
local function resources()
    if ready then return end
    local pool=GetResourceStatus()
    SetResourceStatus('global')
    for _,name in ipairs({'jiejie1','jiejie2','jiejie3','jiejie_shifang0','jiejie_shifang1',
        'jiejie_shifang2','Grazedeath','pice2','lighted','dark'}) do
        LoadImageFromFile('th38_'..name,root..name..'.png')
    end
    local bar='th38_meter'
    LoadTexture(bar,root..'beilvtiao.png')
    LoadImage(bar..'_empty',bar,9,30,124,12)
    LoadImage(bar..'_fill',bar,9,54,124,12)
    LoadImage(bar..'_frame',bar,4,62,133,24)
    for _,name in ipairs({'tm2_death000','crash26_jiejiebaozha','freeze04_jiejieopen'}) do
        LoadSound('th38_'..name,root..name..'.wav')
    end
    CreateRenderTarget(target)
    LoadFX(fx,'shader/th38_death_invert.hlsl')
    SetResourceStatus(pool)
    ready=true
end
local function sprite(name,x,y,rot,size,alpha,blend,color)
    name='th38_'..name
    SetImageState(name,blend or '',alpha,color or 255,color or 255,color or 255)
    Render(name,x,y,rot,size)
end
local function sound(name,p)
    PlaySound('th38_'..name,.55,p.x/192)
end

-- 粒子参数来自 Center_lingmeng 的 death／结界发射器和掉命 prefab。
-- 换算为每秒 60 帧、每 Unity 单位 48 像素。随机数只影响画面。
local impact={texture='Grazedeath',rate=80,duration=29,lifetime=30,radius=48}
local fragments={texture='pice2',rate=400,duration=9,lifetime=30,radius=.48}
local particles=Class(object,{
    init=function(o,p,profile)
        o.x,o.y=p.x,p.y
        o.layer=LAYER.PLAYER-.01
        o.bound,o.colli=false,false
        o.profile,o.points=profile,{}
        local seed=371+p.ani
        local function random()
            seed=(seed*48271)%2147483647
            return seed/2147483647
        end
        local count=math.floor(profile.rate*profile.duration/60)
        for i=1,count do
            local angle=random()*360
            local shard=profile==fragments
            o.points[i]={
                start=i*60/profile.rate,
                cos=cos(angle),sin=sin(angle),
                speed=shard and 1.6+random()*2.4 or 4,
                radius=profile.radius*random(),
                size=.48*(shard and 1 or .3+.7*random()),
                angle=random()*360, tint=shard and 255 or 131+124*random(),
                spin=shard and random()*12-6 or 0,
            }
        end
    end,
    frame=function(o)
        if o.timer>=o.profile.duration+o.profile.lifetime then object.RawDel(o) end
    end,
    render=function(o)
        SetViewMode('world')
        local profile=o.profile
        for _,p in ipairs(o.points) do
            local elapsed=o.timer-p.start
            if elapsed>=0 and elapsed<profile.lifetime then
                local age=elapsed/profile.lifetime
                local distance=p.radius+p.speed*elapsed
                local shard=profile==fragments
                local opacity=shard and math.min(1,(1-age)/.547) or 1
                local scale=shard and p.size or p.size*(1-age*age*(3-2*age))
                sprite(profile.texture,o.x+distance*p.cos,o.y+distance*p.sin,p.angle+p.spin*elapsed,
                    scale,opacity*255,shard and '' or 'mul+add',p.tint)
            end
        end
    end,
},true)
local release=Class(object,{
    init=function(o,p)
        o.x,o.y=p.x,p.y
        o.layer=LAYER.PLAYER-.1
        o.bound,o.colli=false,false
    end,
    frame=function(o) if o.timer>=36 then object.RawDel(o) end end,
    render=function(o)
        SetViewMode('world')
        local t=o.timer
        sprite('jiejie_shifang'..math.min(2,math.floor(t/10)),o.x,o.y,t*3,.35+t*.023,
            math.max(0,212-t*5.9),'mul+add')
    end,
},true)
local wave=Class(object,{
    init=function(o,p)
        o.x,o.y=p.x,p.y
        o.bound,o.colli=false,false
    end,
    frame=function(o) if o.timer>=90 then object.RawDel(o) end end,
    render=function() end,
},true)
function V.hit(p,s)
    resources()
    local layers=NativePlayers.barriers(s)
    sound(layers>0 and 'crash26_jiejiebaozha' or 'tm2_death000',p)
    New(particles,p,impact)
    if layers>0 then New(particles,p,fragments) end
end
function V.release(p)
    resources()
    sound('freeze04_jiejieopen',p)
    New(release,p)
end
function V.miss(p)
    resources()
    lstg.tmpvar.th38_death_effect=New(wave,p)
end
function V.update(p,s)
    local shields=p.th38_shields
    if not shields then shields={layers=0,gain={},loss={}};p.th38_shields=shields end
    local layers=NativePlayers.barriers(s)
    for i=shields.layers+1,layers do shields.gain[i],shields.loss[i]=p.timer,nil end
    for i=layers+1,shields.layers do shields.loss[i]=p.timer end
    shields.layers=layers
end
function V.player(p)
    local shields=p.th38_shields
    if p.death>=50 or p.dialog or p.hide or not shields then return end
    resources()
    for i=1,3 do
        local gain,loss=shields.gain[i],shields.loss[i]
        if i<=shields.layers and gain then
            local age=math.min(1,(p.timer-gain)/20)
            sprite('jiejie'..i,p.x,p.y,0,.48*(7-6*age),255*age)
        elseif loss then
            local age=p.timer-loss
            if age<23 then sprite('jiejie'..i,p.x,p.y,0,.48,255*math.min(1,(45-age*2)*.033)) end
        end
    end
end
function V.beginWorld()
    local o=lstg.tmpvar.th38_death_effect
    if not o or not IsValid(o) or o.timer<10 or o.timer>=90 then return end
    PushRenderTarget(target)
    RenderClear(Color(255,0,0,0))
    return o
end
function V.endWorld(o)
    PopRenderTarget(target)
    SetViewMode('world')
    local w=lstg.world
    local t=(o.timer*2-20)
    -- 原作用 12.8 Unity 单位宽的整屏空间计算半径，游戏区只占其中一部分。
    local screenWidth=12.8*48
    PostEffect(fx,target,6,'',{{(o.x-w.l)/(w.r-w.l),(w.t-o.y)/(w.t-w.b),t*t*.00009,(w.r-w.l)/screenWidth},
        {(w.t-w.b)/screenWidth,.0732,.0549,.1}},{})
end
function V.hud(x1,x2,top,alpha,s,m)
    resources()
    local function row(label,value,y)
        ui:RenderText('title',label,x1,y,.64,Color(alpha,182,220,245),'left','vcenter')
        ui:RenderText('title',tostring(value),x2,y,.64,Color(alpha,244,238,253),'right','vcenter')
    end
    row('机体',m.name,top)
    row('分数',('%010d'):format(lstg.var.score),top-24)
    row('生命',s.life,top-48)
    local middle=(x1+x2)/2
    local width=math.min(x2-x1,185)
    for i=1,8 do
        sprite(i<s.life and 'lighted' or 'dark',middle+width*(i-4.5)/8,top-68,0,.64,alpha)
    end
    row('残机碎片',s.fragments..' / '..NativePlayers.lifeThreshold(s),top-92)
    row('结界',NativePlayers.barriers(s)..' / 3',top-116)
    local full=math.min(1,(s.barrier+1)/300000)
    local x,y=middle-width/2,top-141
    local function segment(name,fraction)
        if fraction<=0 then return end
        name='th38_meter_'..name
        SetImageState(name,'',alpha,255,255,255)
        RenderRect(name,x,x+width*fraction,y-5,y+5)
    end
    segment('empty',1)
    segment('fill',full)
    local frame='th38_meter_frame'
    SetImageState(frame,'',alpha,255,255,255)
    RenderRect(frame,x-4,x+width+4,y-10,y+10)
end
return V
