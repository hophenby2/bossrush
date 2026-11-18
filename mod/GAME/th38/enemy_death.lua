-- Enemy_death.cs、原prefab动画及粒子。敌机离屏/寿命结束不触发击破演出。
local D=dofile('mod/GAME/th38/enemy_death_data.lua')
local E={data=D}
local sin,cos=math.sin,math.cos
local function clamp(x) return math.max(0,math.min(1,x)) end
local function matrix(p,q,s)
    local x,y,z,w=unpack(q)
    return {(1-2*(y*y+z*z))*s[1],2*(x*y+z*w)*s[1],2*(x*z-y*w)*s[1],
        2*(x*y-z*w)*s[2],(1-2*(x*x+z*z))*s[2],2*(y*z+x*w)*s[2],
        2*(x*z+y*w)*s[3],2*(y*z-x*w)*s[3],(1-2*(x*x+y*y))*s[3],p[1],p[2],p[3]}
end
local function point(m,x,y,z) return m[1]*x+m[4]*y+m[7]*z+m[10],m[2]*x+m[5]*y+m[8]*z+m[11],m[3]*x+m[6]*y+m[9]*z+m[12] end
local function combine(a,b)
    local c={}
    for i=0,2 do for j=1,3 do c[i*3+j]=a[j]*b[i*3+1]+a[j+3]*b[i*3+2]+a[j+6]*b[i*3+3] end end
    c[10],c[11],c[12]=point(a,b[10],b[11],b[12]);return c
end
local function texture(key)
    local id='asl_death_'..key
    if not CheckRes('tex',id) then
        local old=GetResourceStatus();SetResourceStatus('global')
        local file=D.sprites[key] and 'Resources/th38/enemy_death/'..key..'.png' or 'Resources/th38/background/unity/'..key
        LoadTexture(id,file);SetResourceStatus(old)
    end
    return id
end
local function sample(o,a,b)
    o.seed=o.seed*48271%2147483647;return a+(b-a)*o.seed/2147483647
end
local function curve(keys,t,index,default)
    local first=keys[1];if not first then return default end
    for i=2,#keys do
        local next=keys[i]
        if t<next[1] then local f=clamp((t-first[1])/(next[1]-first[1]));return first[index]+(next[index]-first[index])*f end
        first=next
    end
    return first[index]
end
local function sizeCurve(keys,t)
    local a=keys[1];if not a then return 1 end
    for i=2,#keys do
        local b=keys[i]
        if t<b[1] then
            local dt=b[1]-a[1];local f=clamp((t-a[1])/dt);local g=1-f
            return (1+2*f)*g*g*a[2]+f*g*g*dt*a[4]+(3-2*f)*f*f*b[2]-f*f*g*dt*b[3]
        end
        a=b
    end
    return a[2]
end
local function nodeMatrix(nodes,index,t,root)
    local n=nodes[index];local scale={unpack(n.scale)};local death=n.scripts.Enemy_death
    if death then local v=death.xishu*sin(math.rad(t*1.2857));scale={v,v,v} end
    local parent=n.parent==0 and root or nodeMatrix(nodes,n.parent,t,root)
    return combine(parent,matrix(n.parent==0 and {0,0,0} or n.pos,n.parent==0 and {0,0,0,1} or n.rot,scale))
end
local Effect=Class(object,{
    init=function(o,p,name)
        o.x,o.y=p.x,p.y;o.nodes=D.deaths[name];o.source_enemy_death=true
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.ENEMY+1,false,false
        o.angle=sample({seed=7919+(p.timer or 0)},0,math.pi*2);o.seed=7919+(p.timer or 0)
        o.particles={};o.length=45
        local root=matrix({0,0,0},{0,0,sin(o.angle/2),cos(o.angle/2)},{1,1,1})
        for i,n in ipairs(o.nodes) do
            local b=n.scripts.Bulletmove_ziji_y
            if b and b.time_death>0 then o.length=math.max(o.length,b.time_death/2) end
            local ps=n.particles
            if ps then
                local list={};o.particles[i]=list
                for j=1,math.min(ps.maxCount,math.floor(ps.rate*ps.length)) do
                    local angle=sample(o,0,math.pi*2);local radius=ps.radius*math.sqrt(1-sample(o,0,ps.thickness))
                    local speed=sample(o,unpack(ps.speed))
                    list[j]={born=j/ps.rate+ps.delay,life=sample(o,unpack(ps.life)),px=radius*cos(angle),py=radius*sin(angle),
                        vx=speed*cos(angle),vy=speed*sin(angle),size=sample(o,unpack(ps.size)),angle=sample(o,unpack(ps.angle)),
                        spin=sample(o,unpack(ps.rotating)),mix=sample(o,0,1)}
                    list[j].birthM=nodeMatrix(o.nodes,i,list[j].born*120,root)
                end
            end
        end
        if not CheckRes('snd','asl_enemy_death') then
            local old=GetResourceStatus();SetResourceStatus('global');LoadSound('asl_enemy_death','Resources/th38/enemy_death/enemy_death.wav');SetResourceStatus(old)
        end
        PlaySound('asl_enemy_death',.55,o.x/192)
    end,
    frame=function(o) if o.timer>=o.length then object.RawDel(o) end end,
    render=function(o)
        local t=o.timer*2+1;local transforms={}
        local root=matrix({0,0,0},{0,0,sin(o.angle/2),cos(o.angle/2)},{1,1,1})
        for i,n in ipairs(o.nodes) do
            local scale={unpack(n.scale)};local death=n.scripts.Enemy_death
            if death then local v=death.xishu*sin(math.rad(t*1.2857));scale={v,v,v} end
            local m=combine(transforms[n.parent] or root,matrix(n.parent==0 and {0,0,0} or n.pos,n.parent==0 and {0,0,0,1} or n.rot,scale));transforms[i]=m
            local key=n.sprite
            if n.clip then
                local clip=D.clips[n.clip];local time=o.timer/60
                time=clip.loop==1 and time%math.max(.0001,clip.length) or math.min(time,clip.length)
                for _,track in ipairs(clip.tracks) do for _,f in ipairs(track) do if f[1]<=time then key=f[2] end end end
            end
            if key and (not death or t<70 or death.b==1) then
                local s=D.sprites[key];local tex=texture(key);local c=n.color
                local alpha=death and clamp(1-(t-50)*.05) or c[4]
                local color=Color(alpha*255,255,c[2]*255,255)
                local function v(x,y,u,w)
                    x,y=point(m,x,y,0);return {o.x+x*48,o.y+y*48,.5,u,w,color}
                end
                local l,r,b,top=-s.ox/s.ppu,(s.w-s.ox)/s.ppu,-(s.h-s.oy)/s.ppu,s.oy/s.ppu
                RenderTexture(tex,n.blend or '',v(l,top,0,0),v(r,top,s.w,0),v(r,b,s.w,s.h),v(l,b,0,s.h))
            end
            local ps=n.particles
            if ps then
                local tex=texture(ps.tex);local w,h=GetTextureSize(tex)
                for _,p in ipairs(o.particles[i]) do
                    local age=o.timer/60*ps.simulation-p.born
                    if age>=0 and age<p.life then
                        local ratio=age/p.life
                        local x,y=p.px+p.vx*age,p.py+p.vy*age-.5*9.81*ps.gravity*age*age
                        x,y=point(ps.localSpace==1 and m or p.birthM,x,y,0)
                        local scaling=ps.scalingMode==1 and math.abs(scale[1]) or ps.scalingMode==2 and 1 or math.sqrt(m[1]^2+m[2]^2+m[3]^2)
                        local radius=p.size*sizeCurve(ps.sizeCurve,ratio)*24*scaling
                        local angle=p.angle+p.spin*age;local ca,sa=radius*cos(angle),radius*sin(angle)
                        local high,low=ps.color,ps.colorMin or ps.color;local tint=ps.tint
                        local alpha=curve(ps.alpha,ratio,2,1)*(low[4]+(high[4]-low[4])*p.mix)*tint[4]
                        local rgb={}
                        for j=1,3 do rgb[j]=clamp((low[j]+(high[j]-low[j])*p.mix)*tint[j]*curve(ps.rgb,ratio,j+1,1))*255 end
                        local color=Color(clamp(alpha)*255,unpack(rgb));x,y=o.x+x*48,o.y+y*48
                        RenderTexture(tex,ps.blend,{x-ca-sa,y+ca-sa,.5,0,0,color},{x+ca-sa,y+ca+sa,.5,w,0,color},
                            {x+ca+sa,y-ca+sa,.5,w,h,color},{x-ca+sa,y-ca-sa,.5,0,h,color})
                    end
                end
            end
        end
    end,
},true)
function E.spawn(p,type)
    local name=D.enemies[type]
    if name and D.deaths[name] then return New(Effect,p,name) end
end
return E
