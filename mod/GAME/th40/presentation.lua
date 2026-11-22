-- 夏夜祭原作曲名、蓄力与放能；画面随机数独立，表现事件不改写发弹器。
local N=...
local P={data=dofile('mod/GAME/th40/presentation_data.lua')}
local D=P.data
local serial=0
local sin,cos=math.sin,math.cos
function N.sound(name,position)
    local id=assert(N.sounds[name],'夏夜祭原音效未载入：'..tostring(name))
    PlaySound(id,.2,position and math.max(-.4,math.min(.4,position/192*.4)) or 0)
end
local function selected(meta)
    local source=meta.source
    if source and meta.variants then source=source:gsub('(%d)[ABCD]$',function(n) return n..N.route({}) end) end
    return source
end
function P.open(o,meta)
    local fn=D.opening[selected(meta)]
    if fn then fn(o,0,N) end
end
function P.tick(o,t,meta)
    local fn=D.step[selected(meta)]
    if fn then fn(o,t,N) end
end
local function particle(o,opening)
    local function integer(a,b)
        o.seed=o.seed*48271%2147483647
        return a+math.floor(o.seed/2147483647*(b-a))
    end
    local angle=integer(0,360)*math.pi/180
    local radius=opening and integer(150,200) or 0
    local life=opening and integer(50,80) or 30+integer(0,50)
    local axis={integer(-100,100),integer(-100,100),integer(-100,100)}
    local length=math.sqrt(axis[1]^2+axis[2]^2+axis[3]^2)
    if length>0 then for i=1,3 do axis[i]=axis[i]/length end end
    local speed=opening and 2*radius/life or integer(50,130)/10
    return {x=o.x+radius*cos(angle),y=o.y-radius*sin(angle),z=0,angle=angle+(opening and math.pi or 0),
        depthAngle=opening and 0 or integer(0,60)*math.pi/180,age=0,life=opening and life-15 or life,
        alphaLife=opening and life-15 or life,speed=speed,accel=opening and -speed*speed/(2*radius) or 0,
        alpha=0,rotation=integer(0,360)*math.pi/180,spin=integer(10,18)/100,axis=axis,scale=opening and integer(30,40)/10 or integer(20,30)/10}
end
local function drawParticle(p,alpha)
    local id=N.images['Effect-1'];if not id then return end
    local region=N.regions['Effect-1'];local w,h=region[5],region[6]
    local ca,sa=cos(p.spin*p.age),sin(p.spin*p.age);local axis=p.axis
    local co,si=cos(p.rotation),sin(p.rotation)
    local function vertex(x,y)
        x,y=(x*co-y*si)*p.scale,(x*si+y*co)*p.scale
        local dot=axis[1]*x+axis[2]*y
        local xx=x*ca-axis[3]*y*sa+axis[1]*dot*(1-ca)
        local yy=y*ca+axis[3]*x*sa+axis[2]*dot*(1-ca)
        local zz=(axis[1]*y-axis[2]*x)*sa+axis[3]*dot*(1-ca)+p.z
        local k=234/(234-zz)
        return (p.x+xx)*k,(p.y-yy)*k,.5
    end
    local a,b,c=vertex(-w/2,-h/2);local d,e,f=vertex(w/2,-h/2)
    local g,j,k=vertex(w/2,h/2);local l,m,n=vertex(-w/2,h/2)
    Render4V(id,a,b,c,d,e,f,g,j,k,l,m,n)
end
local Energy=Class(object,{
    init=function(o,x,y,gather,rgb)
        serial=serial+1;o.x,o.y,o.gather,o.rgb=x,y,gather,rgb
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.ENEMY_BULLET+1,false,false
        o.parts={};o.seed=serial*7919+97
    end,
    frame=function(o)
        local t=o.timer+1
        if o.gather and t<=25 and t%2==0 then
            for _=1,2 do o.parts[#o.parts+1]=particle(o,true) end
        elseif not o.gather and t==1 then
            for _=1,50 do o.parts[#o.parts+1]=particle(o,false) end
        end
        for i=#o.parts,1,-1 do
            local p=o.parts[i];p.age=p.age+1
            local horizontal=p.speed*cos(p.depthAngle)
            p.x,p.y=p.x+horizontal*cos(p.angle),p.y-horizontal*sin(p.angle)
            p.z=math.min(80,p.z+p.speed*sin(p.depthAngle));p.speed=math.max(0,p.speed+p.accel)
            -- Particle3D1 使用整数除法逐帧累加透明度，峰值不一定等于 128。
            local delta=math.floor(128*3/p.life)
            if p.age>0 and p.age<math.floor(p.life/3) then p.alpha=p.alpha+delta
            elseif math.floor(p.life*2/3)<p.age and p.age<p.life then p.alpha=p.alpha-delta end
            if p.age>p.life then table.remove(o.parts,i) end
        end
        if t>(o.gather and 50 or 100) and #o.parts==0 then object.RawDel(o) end
    end,
    render=function(o)
        local t=o.timer;local rgb=o.rgb
        local ring=N.images['Effect-2']
        if ring and t<=(o.gather and 50 or 100) then
            local scale=o.gather and 14-.25*t or 1+.8*t
            local alpha=o.gather and math.min(128,6*t) or math.max(0,180-2*t)
            SetImageState(ring,'mul+add',alpha,unpack(rgb));Render(ring,o.x,o.y,0,scale)
        end
        table.sort(o.parts,function(a,b) return a.z<b.z end)
        for _,p in ipairs(o.parts) do
            SetImageState(N.images['Effect-1'],'mul+add',math.max(0,p.alpha),unpack(rgb))
            drawParticle(p)
        end
    end,
})
function P.energy(x,y,gather,rgb) return New(Energy,x,y,gather,rgb) end
local MusicTitle=Class(object,{
    init=function(o,cfg)
        o.cfg=cfg;o.px,o.py=384,548
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.TOP-10,false,false
        local id='summer_music_title_'..cfg.name
        if not CheckRes('img',id) then
            local pool=GetResourceStatus();SetResourceStatus('global')
            LoadTexture(id,cfg.file);LoadImage(id,id,0,0,unpack(cfg.size));SetImageCenter(id,cfg.size[1],0)
            SetResourceStatus(pool)
        end
        o.img=id
    end,
    frame=function(o)
        local distance=math.abs(432-o.py)
        local speed=distance>50 and 7 or distance>35 and 5 or distance>15 and 3 or distance>1 and 1 or 0
        o.py=o.py+(o.py<432 and speed or -speed)
        if o.timer>=240 then object.RawDel(o) end
    end,
    render=function(o)
        SetImageState(o.img,'',math.max(0,255-math.max(0,o.timer-204)*8),255,255,255)
        Render(o.img,o.px-192,224-o.py,0,.5)
    end,
})
function P.stage(chapter,time)
    if time==2 then New(MusicTitle,assert(D.titles[chapter])) end
end
return P
