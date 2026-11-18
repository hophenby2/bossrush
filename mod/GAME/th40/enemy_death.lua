-- BaseEnemyPlane_Touhou.GiveEndEffect：EndEnemy和十片真实三维旋转碎片。
local N=...
local E={}
local sin,cos=math.sin,math.cos
local colors={{255,0,0},{100,149,237},{0,128,0},{255,255,0}}
local function colorType(p)
    local name=p.enemy or ''
    local n=name:match('Enemy[ABC](%d+)')
    if n and tonumber(n)<8 then n=tonumber(n);return n>3 and n-4 or n end
    n=name:match('EnemyGhost(%d+)') or name:match('EnemyMaoYu0(%d+)')
    if n then return tonumber(n) end
    n=name:match('EnemyYYY(%d+)');return n and tonumber(n)-4 or p.enemy_color or 0
end
local Effect=Class(object,{
    init=function(o,p)
        o.x,o.y=p.x,p.y;o.colorType=colorType(p);o.source_enemy_death=true
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.ENEMY+1,false,false
        o.parts={};local seed=(p.age or 0)*97+7919
        local function integer(a,b) seed=seed*48271%2147483647;return a+math.floor(seed/2147483647*(b-a)) end
        for i=1,10 do
            local axis={integer(-100,100),integer(-100,100),integer(-100,100)}
            local length=math.sqrt(axis[1]^2+axis[2]^2+axis[3]^2);if length==0 then axis,length={1,0,0},1 end
            for j=1,3 do axis[j]=axis[j]/length end
            o.parts[i]={speed=integer(0,40)/10,direction=math.rad(integer(0,360)),angle=math.rad(integer(0,360)),
                spin=integer(10,30)/100,scale=integer(12,18)/10,axis=axis}
        end
        PlaySound('enep00',.3,o.x/192)
    end,
    frame=function(o) if o.timer>40 then object.RawDel(o) end end,
    render=function(o)
        local t=o.timer
        if t<17 then
            local indices=o.colorType<4 and {o.colorType} or {2,3}
            for _,i in ipairs(indices) do
                local image=N.images['EndEnemy'..i]
                if image then SetImageState(image,'mul+add',math.max(0,255-15*t),255,255,255);Render(image,o.x,o.y,0,.2+.1*t) end
            end
        end
        local image=N.images['Effect-0'];if not image then return end
        SetImageState(image,'mul+add',128,unpack(colors[o.colorType+1] or {255,255,255}))
        for _,p in ipairs(o.parts) do
            local size=p.scale*(t<=20 and 1 or math.max(0,1-(t-20)/20))
            local dist=p.speed*t-p.speed*t*(t-1)/80
            local x,y=o.x+dist*cos(p.direction),o.y-dist*sin(p.direction)
            local a=p.spin*t;local ca,sa=cos(a),sin(a);local axis=p.axis
            local zz,ss=cos(p.angle),sin(p.angle)
            local function vertex(px,py)
                px,py=(px*zz-py*ss)*size,(px*ss+py*zz)*size
                local dot=axis[1]*px+axis[2]*py
                local vx=px*ca-axis[3]*py*sa+axis[1]*dot*(1-ca)
                local vy=py*ca+axis[3]*px*sa+axis[2]*dot*(1-ca)
                local vz=(axis[1]*py-axis[2]*px)*sa+axis[3]*dot*(1-ca)
                local k=234/(234-vz);return x+vx*k,y-vy*k,.5
            end
            local x1,y1,z1=vertex(-16,-16);local x2,y2,z2=vertex(16,-16)
            local x3,y3,z3=vertex(16,16);local x4,y4,z4=vertex(-16,16)
            Render4V(image,x1,y1,z1,x2,y2,z2,x3,y3,z3,x4,y4,z4)
        end
    end,
},true)
function E.spawn(p) return New(Effect,p) end
return E
