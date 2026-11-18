-- 梦华祭二的原生对象后端。脚本在构建时展开；这里仅处理对象运动、插值与生命周期。
-- 坐标严格1:1：原场地(32..416,16..463)→(-192..192,-224..224)。
-- CrazyStorm内部比敌机多(+93,-13)，故弹坐标换算为(x-317,227-y)。
local R={patterns={},classes={},assets={},objects=setmetatable({},{__mode='k'})}
local D=dofile('mod/GAME/th37/catalogue.lua')
local floor,abs,min,max=math.floor,math.abs,math.min,math.max
local function trunc(x) return x<0 and math.ceil(x) or floor(x) end
local function valid(o) return o and IsValid(o) end
local function rnd(a) return a~=0 and ran:Float(-a,a) or 0 end
local function copy(s)
    local o={};for k,v in pairs(s) do o[k]=v end
    o.changes={};o.limits={};return o
end
function R.player() return valid(player) and player.x+317 or 317,valid(player) and 227-player.y or 407 end
local function angle(x,y,tx,ty) return math.deg(math.atan2(ty-y,tx-x)) end
local function direction(v,o,x,y,point)
    if v==-99999 then local px,py=R.player();return angle(x,y,px,py)
    elseif v==-99998 then return angle(x,y,(o.x or x)-4,(o.y or y)+16)
    elseif v==-100000 and point then return angle(x,y,point[1],point[2]) end
    return v or 0
end
local intFields={t=true,tiao=true,r=true,life=true,type=true,sonlife=true}
local boolFields={Mist=true,Dispel=true,Blend=true,Afterimage=true,Outdispel=true,Invincible=true}
local function set(o,key,v)
    if intFields[key] then v=trunc(v) end
    if boolFields[key] then v=v~=0 end
    o[key]=v
    if key=='speed' or key=='speedd' or key=='xscale' or key=='yscale' then o.motion_dirty=true end
    if key=='sonspeed' or key=='sonspeedd' then o.sonmotion_dirty=true end
    if key=='aspeed' or key=='aspeedd' then o.accel_dirty=true end
    if key=='sonaspeed' or key=='sonaspeedd' then o.sonaccel_dirty=true end
end
function R.once(o,id,count)
    local n=o.limits[id] or 0;if n>=tonumber(count) then return false end
    o.limits[id]=n+1;return true
end
function R.change(o,key,value,random,op,mode,duration)
    local initial=o[key] or 0;if type(initial)=='boolean' then initial=initial and 1 or 0 end
    -- Barrage.type为零基，Batch.type为一基；这里的精灵表统一使用一基。
    if o.is_projectile and key=='type' and op==0 and type(value)=='number' then value=value+1 end
    if value=='自机' then
        local x,y=R.player()
        if key=='fx' then value=x elseif key=='fy' then value=y
        else value=angle(o.fx or o.x,o.fy or o.y,x,y) end
    elseif value=='自身' then value=initial end
    value=value+rnd(random)
    o.changes[#o.changes+1]={key=key,value=value,initial=initial,op=op,mode=mode,duration=max(1,duration),left=max(1,duration)}
end
function R.move(o,x1,x2,y1,y2)
    o.changes[#o.changes+1]={mode='move',x=ran:Float(x1,x2),y=ran:Float(y1,y2),left=60}
end
function R.follow(o) o.changes[#o.changes+1]={mode='follow',left=60} end
function R.sound(name)
    -- 差异1：原XACT声库暂用本项目枪音代理，避免把未注册的XACT cue交给LuaSTG。
    if name:find('kira',1,true) then PlaySound('kira00',.2) end
end
local function interpolate(o)
    local i=1
    while i<=#o.changes do
        local c=o.changes[i]
        if c.mode=='move' or c.mode=='follow' then
            local x,y=c.x,c.y
            if c.mode=='follow' then x=R.player();y=o.fy end
            if o.is_center and valid(o.host) then
                local hx,hy=o.host.x+224,240-o.host.y
                if c.mode=='follow' then
                    local px=R.player();o.host.x=(hx*19+px-93)/20-224
                    o.ox=(o.ox*19+px-93)/20
                else
                    o.host.x,o.host.y=(hx*19+x-93)/20-224,240-(hy*19+y)/20
                    o.ox,o.oy=(o.ox*19+x-93)/20,(o.oy*19+y)/20
                end
            elseif o.is_center then
                o.ox=(o.ox*19+x-93)/20;o.oy=(o.oy*19+y)/20
            else o.fx=(o.fx*19+x)/20;o.fy=(o.fy*19+y)/20 end
        else
            local old=o[c.key] or 0;if type(old)=='boolean' then old=old and 1 or 0 end
            local v
            if c.mode=='正弦' then
                local delta=c.op==0 and c.value-c.initial or c.op==1 and c.value or -c.value
                v=c.initial+delta*sin(360*(c.duration-c.left)/c.duration)
            elseif c.mode=='固定' then v=c.op==0 and c.value or old+(c.op==1 and c.value or -c.value)
            elseif c.op==0 then v=(old*(c.left-1)+c.value)/c.left
            else
                local delta=c.value/c.duration
                -- Execution/BExecution先将整数属性的增量截断，再加减原值。
                if intFields[c.key] then delta=trunc(delta) end
                v=old+(c.op==1 and delta or -delta)
            end
            if c.mode=='固定' and c.op~=0 and intFields[c.key] then
                v=old+(c.op==1 and trunc(c.value) or -trunc(c.value))
            end
            set(o,c.key,v)
        end
        c.left=c.left-1
        if c.left<=(c.mode=='正弦' and -1 or 0) then table.remove(o.changes,i) else i=i+1 end
    end
end
local function motion(o,son,scale)
    scale=scale or 1
    local s=son and 'sonspeed' or 'speed';local d=son and 'sonspeedd' or 'speedd'
    local a=son and 'sonaspeed' or 'aspeed';local ad=son and 'sonaspeedd' or 'aspeedd'
    local dirty=son and 'sonmotion_dirty' or 'motion_dirty';local accel=son and 'sonaccel_dirty' or 'accel_dirty'
    if o[dirty] or o.mx==nil then
        o.mx=(o.xscale or 1)*(o[s] or 0)*cos(o[d] or 0);o.my=(o.yscale or 1)*(o[s] or 0)*sin(o[d] or 0);o[dirty]=false
    end
    if o[accel] or o.ax==nil then
        o.ax=(o.xscale or 1)*(o[a] or 0)*cos(o[ad] or 0);o.ay=(o.yscale or 1)*(o[a] or 0)*sin(o[ad] or 0);o[accel]=false
    end
    o.mx=o.mx+o.ax*scale;o.my=o.my+o.ay*scale
    if son and (o.sonspeed or 0)~=0 then
        -- Barrage.Update用去掉横纵倍率后的速度更新逻辑方向，事件随后可修改head。
        local heading
        if o.my~=0 then
            local vx,vy=o.mx/(o.xscale or 1),o.my/(o.yscale or 1)
            heading=90-math.deg(math.atan(vx/vy))+(o.my<0 and 180 or 0)
        else heading=o.mx>=0 and 0 or 180 end
        if heading==heading then
            if o.sonspeed>0 then o.sonspeedd=heading end
            if o.Withspeedd then o.head=heading end
        end
    end
    return o.mx*scale,o.my*scale
end
-- Lua模块缓存跨练习重试保留；动态切出的精灵也必须放全局池，避免关卡池清除后留下假缓存。
local function globalResource(fn)
    local pool=GetResourceStatus()
    SetResourceStatus('global');fn();SetResourceStatus(pool)
end
local function texture(p,index)
    index=max(1,trunc(index));local profile
    if index<=228 then profile=D.bulletTypes[index]
    else profile=p.types[index-228] end
    if not profile then return 'img_void',{0,0,1,1,0,0,0,0} end
    local name='mhj2_'..(index<=228 and 'common' or p.id)..'_'..index
    if not R.assets[name] then
        local tex=index<=228 and 'mhj2_barrages' or 'mhj2_b'..p.id
        globalResource(function()
            LoadImage(name,tex,profile[1],profile[2],max(1,profile[3]),max(1,profile[4]))
            SetImageCenter(name,profile[5],profile[6])
        end);R.assets[name]=true
    end
    return name,profile
end
function R.loadPattern(id)
    if not R.patterns[id] then
        local p=dofile('mod/GAME/th37/patterns/'..id..'.lua');R.patterns[id]=p
        if #p.types>0 then globalResource(function() LoadTexture('mhj2_b'..id,'Resources/th37/b'..id..'.png') end) end
    end
    return R.patterns[id]
end
local function projected(b)
    local s=b.mhj
    b.x,b.y=s.fx-317,227-s.fy;b.vx,b.vy=0,0
    local img,p=texture(s.pattern,s.type);b.img=img
    b.a,b.b=max(0,(p[7]+1)*(s.wscale or 1)),max(0,(p[7]+1)*(s.hscale or 1))
    b.rect=false;b.rot=-((s.head or 0)+90)
    b.hscale,b.vscale=s.wscale,s.hscale
    b._a=max(0,min(255,(s.alpha or 100)*2.55));b._r,b._g,b._b=s.colorR or 255,s.colorG or 255,s.colorB or 255
    b._blend=s.Blend and 'mul+add' or ''
    -- 原作按Layer顺序绘制，每层先普通弹、后高光弹。
    b.layer=(s.controller.effectLayer or LAYER.ENEMY_BULLET)+(s.layerid or 0)*2+(s.Blend and 1 or 0)
    b.group=s.controller.effectLayer and GROUP.GHOST or (s.Invincible and GROUP.INDES or GROUP.ENEMY_BULLET)
    b.colli=not s.controller.effectLayer and not s.dis and s.age>(s.Mist and 15 or 0) and s.type>0 and (s.alpha or 100)>95 and s.wscale>0 and s.hscale>0
end
local function clean(b)
    local s=b.mhj
    if s and s.controller and s.controller.bullets then s.controller.bullets[b]=nil end
    if s then s.object=nil end
    R.objects[b]=nil;object.RawDel(b)
end
local function effectAssets()
    if R.assets.effects then return end
    globalResource(function()
        LoadTexture('mhj2_mist','Resources/th37/mist.png')
        LoadTexture('mhj2_dis','Resources/th37/dis.png')
        for color=0,7 do
            LoadImage('mhj2_mist_'..color,'mhj2_mist',color*32,0,32,30)
            SetImageCenter('mhj2_mist_'..color,16,15)
            LoadImage('mhj2_dis_'..color,'mhj2_dis',color*32,0,32,32)
            SetImageCenter('mhj2_dis_'..color,16,16)
        end
    end)
    R.assets.effects=true
end
local function drawSprite(b,img,x,y,rot,sx,sy,alpha)
    SetImageState(img,b._blend,max(0,min(255,alpha)),b._r,b._g,b._b)
    Render(img,x,y,rot,sx,sy)
end
local function cancelProjectile(b)
    local s=b.mhj
    if not s.dis then
        s.dis=true;s.Blend=true;s.age=(s.Mist and 15 or 0)+s.life+1
        s.cancelAngle=ran:Float(0,360);s.cancelScale=1.1
    end
    b.colli=false
    object.Preserve(b)
end
local function updateShadows(s)
    for i=#s.shadows,1,-1 do
        local shadow=s.shadows[i]
        shadow.alpha=shadow.alpha-.02
        if shadow.alpha<=0 then table.remove(s.shadows,i) end
    end
    if s.Afterimage and s.age<=(s.Mist and 15 or 0)+s.life then
        s.shadows[#s.shadows+1]={x=s.fx,y=s.fy,head=s.head,alpha=.4*s.alpha/100-.02}
    end
end
local function projectileOutside(s)
    if #s.shadows>0 then return false end
    if s.Outdispel then return s.fx< -16 or s.fx>545 or s.fy< -33 or s.fy>515 end
    return s.fx< -316 or s.fx>767 or s.fy< -333 or s.fy>815
end
R.classes.projectile=Class(bullet,{
    init=function(b,s)
        -- 不经过通用雾化类；CrazyStorm自己有15帧出生与事件时钟。
        effectAssets()
        s.is_projectile=true;s.kind='projectile';b.mhj=s;b.bound=false;b.group=GROUP.ENEMY_BULLET;b.layer=LAYER.ENEMY_BULLET;b.vx,b.vy=0,0
        b._a,b._r,b._g,b._b=255,255,255,255;b._blend='';s.age=0;s.changes={};s.limits=s.limits or {};s.object=nil
        s.shadows={};s.previousX,s.previousY=s.fx,s.fy
        if s.Withspeedd then s.head=s.sonspeedd end
        R.objects[b]=true;s.controller.bullets[b]=s;projected(b)
    end,
    frame=function(b)
        local s=b.mhj;s.age=s.age+1
        s.previousX,s.previousY=s.fx,s.fy
        local t=s.age-(s.Mist and 15 or 0)
        if t>0 then
            -- 原Barrage.Update先积分，再更新事件；速度变化从下一运动帧生效。
            if not s.dis then
                local dx,dy=motion(s,true,s.controller.slow or 1);s.fx,s.fy=s.fx+dx,s.fy+dy
            end
            updateShadows(s)
            if s.Sonevents then s.Sonevents(s,t,R) end
            interpolate(s)
            if t>s.life then
                if not s.Dispel or s.type<=0 then clean(b);return end
                s.fadeout=(s.fadeout or 0)+5;s.alpha=100-s.fadeout
                local _,profile=texture(s.pattern,s.type)
                local delta=s.type<=228 and profile[3]<=32 and -.06 or .06
                s.wscale=max(0,s.wscale+delta);s.hscale=max(0,s.hscale+delta)
                if s.fadeout>=100 then clean(b);return end
            end
            if s.dis then s.cancelScale=max(0,(s.cancelScale or 1.1)-.05) end
        end
        projected(b)
        if projectileOutside(s) then clean(b) end
    end,
    render=function(b)
        local s=b.mhj
        if s.type<=0 then return end
        local _,profile=texture(s.pattern,s.type)
        if s.Mist and s.age<=15 then
            local born=s.age/15
            local small=profile[3]<=(s.type<=228 and 32 or 48)
            if small and profile[8]>=0 then
                local scale=profile[3]/30+1.5*(1-born)
                drawSprite(b,'mhj2_mist_'..profile[8],b.x,b.y,b.rot,scale,scale,b._a*born)
            else
                local extra=small and 0 or 1-born
                drawSprite(b,b.img,b.x,b.y,b.rot,b.hscale+extra,b.vscale+extra,b._a*born)
            end
            return
        end
        if not s.dis or s.type>228 or profile[3]>=48 then
            drawSprite(b,b.img,b.x,b.y,b.rot,b.hscale,b.vscale,b._a)
        end
        if s.Afterimage then
            for _,shadow in ipairs(s.shadows) do
                drawSprite(b,b.img,shadow.x-317,227-shadow.y,-(shadow.head+90),b.hscale,b.vscale,shadow.alpha*255)
            end
        end
        if s.dis and s.type<=228 and profile[3]<48 and profile[8]>=0 then
            drawSprite(b,'mhj2_dis_'..profile[8],b.x,b.y,s.cancelAngle,s.cancelScale,s.cancelScale,b._a)
        end
    end,
    del=cancelProjectile,kill=cancelProjectile,
})
-- Barrage.Judge先取相对运动线段到自机的最近点，再按head旋转后测椭圆。
function R.sweptHit(s,px,py)
    if s.wscale<=0 or s.hscale<=0 or s.type<=0 then return false end
    local bx,by=s.previousX or s.fx,s.previousY or s.fy
    local dx,dy=s.fx-bx,s.fy-by
    local distance=dx*dx+dy*dy
    local along=distance>0 and ((px-bx)*dx+(py-by)*dy)/distance or 1
    -- 原Judge在线段外回退到本帧端点。
    if along<0 or along>1 then along=1 end
    local x,y=px-(bx+along*dx),py-(by+along*dy)
    local ca,sa=cos(s.head or 0),sin(s.head or 0)
    local rx,ry=x*ca+y*sa,y*ca-x*sa
    local _,profile=texture(s.pattern,s.type)
    local radius=profile[7]+1
    return rx*rx/(radius*s.hscale)^2+ry*ry/(radius*s.wscale)^2<=1
end
local collisionObjects={}
function R.beginCollisions()
    local count=0
    local p=valid(player) and player
    local px,py=R.player()
    for b in pairs(R.objects) do
        local s=b.mhj
        if valid(b) and s and s.kind=='projectile' and b.colli then
            count=count+1;collisionObjects[count]=b
            if p and p.colli~=false then
                if R.sweptHit(s,px,py) then
                    p.class.colli(p,b)
                elseif valid(p.grazer) and not b._graze and s.life>2 and (not s.Invincible or s.age>=20) then
                    local dx,dy=(s.previousX or s.fx)-px,(s.previousY or s.fy)-py
                    if dx*dx+dy*dy<=4900 then p.grazer.class.colli(p.grazer,b) end
                end
            end
            -- 自机碰撞由上述原作算法处理；随后恢复，使Bomb仍使用原生分组。
            if valid(b) then b.colli=false end
        end
    end
    R.collisionCount=count
end
function R.finishCollisions()
    for i=1,R.collisionCount or 0 do
        local b=collisionObjects[i]
        if valid(b) and not b.mhj.dis then b.colli=true end
        collisionObjects[i]=nil
    end
    R.collisionCount=0
end
R.classes.beam=Class(laser,{
    init=function(b,s)
        laser.init(b,({2,4,6,10,12,14,16,8})[(s.type-1)%8+1],s.fx-317,227-s.fy,-s.sonspeedd,0,max(1,s.longs),0,max(1,s.wscale*16),0,0)
        s.is_projectile=true;b.mhj=s;b.bound=false;b.vx,b.vy=0,0;s.age=0;s.changes={};s.limits=s.limits or {};s.object=nil;R.objects[b]=true;s.controller.bullets[b]=s
        laser._TurnOn(b,15,false,false)
    end,
    frame=function(b)
        local s=b.mhj;s.age=s.age+1
        if s.age>s.life then clean(b);return end
        if s.Sonevents then s.Sonevents(s,s.age,R) end;interpolate(s)
        local dx,dy=motion(s,true,s.controller.slow or 1);s.fx,s.fy=s.fx+dx,s.fy+dy
        b.x,b.y,b.rot=s.fx-317,227-s.fy,-s.sonspeedd
        b.w0,b.l2=max(0,s.wscale*16),max(0,s.longs);b._a=max(0,min(255,(s.alpha or 100)*2.55));b.colli=(s.alpha or 100)>95;laser.frame(b)
    end,
    render=function(b)
        local s=b.mhj;local p=D.bulletTypes[33+s.type]
        if not p then return end
        local ray=s.Ray==true;local x,y,w,h=p[1],p[2],p[3],p[4]
        if ray then x,y,w,h=s.type*18,711,18,18 end
        local id='mhj2_laser_'..s.type..'_'..tostring(ray)
        if not R.assets[id] then
            globalResource(function() LoadImage(id,'mhj2_barrages',x,y,w,h);SetImageCenter(id,w/2,0) end)
            R.assets[id]=true
        end
        SetImageState(id,s.Blend and 'mul+add' or '',(s.alpha or 100)*2.55,255,255,255)
        Render(id,b.x,b.y,90-s.sonspeedd,s.wscale,(b.l2 or 0)/(ray and 9 or h))
    end,
    del=function(b) clean(b) end,kill=function(b) clean(b) end,
})
local function emit(o,bound)
    local c=o.controller;local p=c.pattern;local rr=o.rand or {}
    local n=trunc((o.tiao or 1)+trunc(rnd(rr.tiao or 0)));if n<=0 then return end
    local ox,oy=c.offsetx,c.offsety
    local fx,fy=o.fx or o.x-4,o.fy or o.y+16
    if bound then fx,fy=bound.fx-ox,bound.fy-oy end
    local r=(o.r or 0)+trunc(rnd(rr.r or 0));local spread=(o.range or 0)+trunc(rnd(rr.range or 0))
    local base=direction(o.fdirection,o,fx+ox,fy+oy,o.fdirections)+rnd(rr.fdirection or 0)
    local radial=direction(o.rdirection,o,fx+ox,fy+oy,o.rdirections)+rnd(rr.rdirection or 0)
    local speed=(o.sonspeed or 0)+rnd(rr.sonspeed or 0);local accel=(o.sonaspeed or 0)+rnd(rr.sonaspeed or 0)
    local ad=direction(o.sonaspeedd,o,fx+ox,fy+oy,o.sonaspeedds)+rnd(rr.sonaspeedd or 0)
    local jx,jy=trunc(rnd(rr.fx or 0)),trunc(rnd(rr.fy or 0))
    for i=0,n-1 do
        local fan=(i-(n-1)/2)*spread/n
        local s=copy(o);s.limits=o.limits;s.controller=c;s.pattern=p;s.emitter=o;s.parentid=o.id;s.layerid=o.parentid
        s.fx,s.fy=fx+r*cos(radial+fan)+jx+ox,fy+r*sin(radial+fan)+jy+oy
        -- 发射器的积分缓存不能传给弹体；否则静止发射器会把子弹的3.5速度覆盖成0。
        s.mx,s.my,s.ax,s.ay=nil,nil,nil,nil
        s.sonmotion_dirty,s.sonaccel_dirty=true,true
        s.sonspeed,s.sonaspeed,s.sonaspeedd=speed,accel,ad
        s.sonspeedd=base+fan+(o.Bindwithspeedd and bound and bound.sonspeedd or 0)
        s.life=o.sonlife;s.age=0;s.head=(o.head or 0)+trunc(rnd(rr.head or 0))
        New(o.kind=='laser' and R.classes.beam or R.classes.projectile,s)
    end
end
local function fire(o,bound)
    if bound then emit(o,bound);return end
    if not o.bindid or o.bindid<0 or o.bindid==o.id then emit(o);return end
    -- Batch.Shoot的额外发射与周期发射都必须找到已出生的绑定宿主。
    local targets={}
    for b,s in pairs(o.controller.bullets) do
        if valid(b) and s.parentid==o.bindid and s.layerid==o.parentid and (not s.Mist or s.age>15) then
            targets[#targets+1]=s
        end
    end
    for _,s in ipairs(targets) do emit(o,s) end
end
function R.fire(o) fire(o,o.bound_source) end
local function emitter(spec,c)
    local o=copy(spec);o.controller=c;o.host=c.host;o.pattern=c.pattern;o.children=setmetatable({},{__mode='k'})
    -- Batch.Copy是浅拷贝，原EventRead的次数限制跨Totalframe循环保留。
    -- 只重置运动/插值状态；不能每轮重新启用括号(1)的开场事件。
    local key=spec.kind..':'..spec.parentid..':'..spec.id
    c.eventLimits[key]=c.eventLimits[key] or {};o.limits=c.eventLimits[key]
    local rr=o.rand
    for _,key in ipairs({'speed','speedd','aspeed','aspeedd'}) do o[key]=(o[key] or 0)+rnd(rr[key] or 0) end
    if o.fx==-99998 then o.fx=o.x-4 elseif o.fx==-99999 then o.fx=R.player() end
    if o.fy==-99998 then o.fy=o.y+16 elseif o.fy==-99999 then local _,y=R.player();o.fy=y end
    o.speedd=direction(o.speedd,o,o.fx or o.x,o.fy or o.y,o.speedds)
    o.aspeedd=direction(o.aspeedd,o,o.fx or o.x,o.fy or o.y,o.aspeedds)
    return o
end
local function area(o,s,c)
    if s.layerid~=o.parentid then return false end
    if o.type==1 and s.parentid~=o.controlid then return false end
    local dx,dy=s.fx-(o.x+c.offsetx),s.fy-(o.y+c.offsety)
    if o.Circle then return dx*dx/max(1,o.halfw^2)+dy*dy/max(1,o.halfh^2)<=1 end
    return abs(dx)<=o.halfw and abs(dy)<=o.halfh
end
local function field(o,c,t)
    if o.kind=='cover' then
        for b,s in pairs(c.bullets) do if valid(b) and s.Cover and area(o,s,c) then
            s.cover_times=s.cover_times or {};local n=(s.cover_times[o] or 0)+1;s.cover_times[o]=n
            if o.Sonevents then o.Sonevents(s,n,R) end
        end end
    elseif o.kind=='rebound' then
        local ox,oy=o.x+c.offsetx,o.y+c.offsety;local ca,sa=cos(o.angle),sin(o.angle)
        for b,s in pairs(c.bullets) do if valid(b) and s.Rebound then
            local dx,dy=s.fx-ox,s.fy-oy;local side=-dx*sa+dy*ca
            local last=s.rebound_side or {};s.rebound_side=last;local previous=last[o];last[o]=side
            if previous and previous*side<0 and abs(dx*ca+dy*sa)<=o.longs/2 then
                s.sonspeedd=2*o.angle-s.sonspeedd;s.sonmotion_dirty=true
                if o.Parentevents then o.Parentevents(s,t,R) end
            end
        end end
    elseif o.kind=='force' then
        for b,s in pairs(c.bullets) do if valid(b) and s.Force and area(o,s,c) then
            local a=o.addaspeedd or 0
            if o.Suction or o.Repulsion then a=angle(s.fx,s.fy,o.x+c.offsetx,o.y+c.offsety)+(o.Repulsion and 180 or 0) end
            s.mx=(s.mx or 0)+(o.addaspeed or 0)*cos(a);s.my=(s.my or 0)+(o.addaspeed or 0)*sin(a)
        end end
    end
end
local function reset(c)
    local initial=c.pattern.center
    c.emitters={};c.center=copy{fx=initial[1],fy=initial[2],ox=initial[1],oy=initial[2],speed=initial[3],speedd=initial[4],aspeed=initial[5],aspeedd=initial[6],is_center=true,host=c.host}
    for _,spec in ipairs(c.pattern.emitters) do c.emitters[#c.emitters+1]=emitter(spec,c) end
end
function R.controller(host,id,road)
    local p=R.loadPattern(id)
    local c={host=host,pattern=p,road=road,time=0,offsetx=0,offsety=0,bullets=setmetatable({},{__mode='k'}),jumps={},eventLimits={}}
    reset(c);return c
end
function R.tick(c)
    if c.closed then return end
    c.time=c.time+1
    if c.time>c.pattern.total then c.time=1;reset(c) end
    local t=c.time;local center=c.center
    if c.pattern.globalEvents then c.pattern.globalEvents(c,t,R) end
    t=c.time
    if valid(c.host) then center.ox,center.oy=c.host.x+317,227-c.host.y end
    if c.pattern.centerAvailable then
        c.offsetx=center.ox-center.fx;c.offsety=center.oy-center.fy
    else c.offsetx,c.offsety=0,0 end
    local function step(o,ot,bound)
        if ot<1 or ot>o.life then return end
        o.time=ot
        local mx,my=motion(o,false);o.x,o.y=o.x+mx,o.y+my
        if o.fx then o.fx=o.fx+mx end;if o.fy then o.fy=o.fy+my end
        o.bound_source=bound
        if o.kind~='rebound' and o.Parentevents then o.Parentevents(o,ot,R) end
        interpolate(o)
        if o.kind=='batch' or o.kind=='laser' then
            if o.t>0 and ot%o.t+trunc(rnd(o.rand.t or 0))==0 then
                fire(o,bound)
            end
        else field(o,c,ot) end
    end
    for _,o in ipairs(c.emitters) do
        if o.Deepbind and o.bindid and o.bindid>=0 and o.bindid~=o.id then
            local targets={}
            for b,s in pairs(c.bullets) do if valid(b) and s.parentid==o.bindid and s.layerid==o.parentid and (not s.Mist or s.age>15) then targets[#targets+1]={b,s} end end
            for _,pair in ipairs(targets) do
                local child=o.children[pair[1]]
                if not child then child=emitter(o,c);child.bindid=-1;child.Deepbind=false;child.limits={};o.children[pair[1]]=child end
                step(child,pair[2].age-(child.begin or 1)+2,pair[2])
            end
        else step(o,t-(o.begin or 1)+1) end
    end
    -- CrazyStorm.Update在各层发射之后推进中心；中心基准x/y始终不变。
    if c.pattern.centerAvailable then
        local dx,dy=motion(center,false)
        -- 保留原Center.Update的ox连续累加speedx、speedy这一行为。
        center.ox=center.ox+dx+dy
        if valid(c.host) then c.host.x,c.host.y=c.host.x+dx,c.host.y-dy end
        c.pattern.centerEvents(center,t,R);interpolate(center)
    end
end
function R.jump(c,index,count,target)
    c.jumps[index]=(c.jumps[index] or 0)+1
    if count==0 or c.jumps[index]<=count then c.time=target end
end
function R.quake(c,duration,level)
    if misc and misc.ShakeScreen then misc.ShakeScreen(duration,level/8) end
end
function R.slow(c,duration,mode,t,start)
    local elapsed=t-start+1;c.slow=elapsed<=duration and (mode==1 and 0 or (elapsed/max(1,duration))^2) or 1
end
function R.clear(c)
    if not c then return end
    c.closed=true
    for b in pairs(c.bullets) do if valid(b) then clean(b) end end
end
function R.clearAll()
    for b in pairs(R.objects) do if valid(b) then clean(b) end end
end
function R.stopEmitter(c)
    if c then c.closed=true;c.emitters={} end
end
local DeathEffect=Class(object,{
    init=function(o,p)
        o.x,o.y=p.x,p.y;o.group,o.bound,o.colli=GROUP.GHOST,false,false
        o.effect=R.controller(o,'e14');o.effect.effectLayer=LAYER.PLAYER+1;R.objects[o]=true
    end,
    frame=function(o)
        if o.effect.time<o.effect.pattern.total then R.tick(o.effect)
        else R.stopEmitter(o.effect);R.objects[o]=nil;object.RawDel(o) end
    end,
    render=function() end,
},true)
function R.playerDeathEffect(p) New(DeathEffect,p) end
function R.deathClear(x,y,r)
    for b in pairs(R.objects) do
        local s=b.mhj
        if valid(b) and s and s.is_projectile and not s.Invincible and not s.controller.effectLayer
            and Dist(x,y,b.x,b.y)<r and not s.dis then Del(b) end
    end
end
function R.deathDamage(x,y,r,damage)
    for b in pairs(R.objects) do
        local s=b.mhj
        if valid(b) and s and not s.is_projectile and not b.protect and b.colli and Dist(x,y,b.x,b.y)<r then
            b.hp=b.hp-damage
        end
    end
end
-- 道中敌机使用enemybase的实际受弹入口；运动在原坐标内积分一次，原生vx/vy保持0。
R.classes.fairy=Class(enemy,{
    init=function(o,state,spec)
        enemybase.init(o,spec.hp);o.mhj=copy(spec);o.mhj.state=state;o.mhj.age=0;o.mhj.events={}
        o.bound=false;o.vx,o.vy=0,0;o.group=GROUP.ENEMY;o.layer=LAYER.ENEMY;o.colli=true
        o.x,o.y=spec.x-224,240-spec.y;o.a,o.b=8,8;o.maxhp=spec.hp
        o.img='img_void'
        -- LuaSTG refreshes the collision dimensions when img changes.
        if NativePlayers and NativePlayers.enabled(nil,35) then o.a,o.b=8,8 end
        o.mhj.controller=spec.pattern and R.controller(o,spec.pattern,true) or nil
        state.enemies[#state.enemies+1]=o;R.objects[o]=true
    end,
    frame=function(o)
        if (o.hp or 0)<=0 then object.Kill(o);return end
        local s=o.mhj;s.age=s.age+1
        if s.age>s.life then clean(o);return end
        for _,e in ipairs(s.events) do
            if s.age>=e.at and s.age<e.at+e.duration then
                if e.origin==nil then e.origin=s[e.key] or 0 end
                local k=e.mode==2 and 1 or e.mode==3 and sin(360*(s.age-e.at)/e.duration) or (s.age-e.at+1)/e.duration
                s[e.key]=e.origin+(e.value-e.origin)*k
            end
        end
        s.x,s.y=s.x+s.speed*cos(s.speedf),s.y+s.speed*sin(s.speedf)
        o.x,o.y=s.x-224,240-s.y;o.vx,o.vy=0,0
        SetAttr(o,'colli',s.age>(s.noharm or 0));o.colli=s.age>(s.noharm or 0)
        if s.controller and s.age>=(s.delay or 0) then R.tick(s.controller) end
    end,
    render=function(o)
        local s=o.mhj;local p=D.enemyTypes[s.type+1]
        if not p or p[3]==0 or p[4]==0 then return end
        local n=trunc(o.ani/7)%max(1,p[5]);local name='mhj2_enemy_'..s.type..'_'..n
        if not R.assets[name] then
            globalResource(function()
                LoadImage(name,'mhj2_enemys',p[1]+n*p[3],p[2],p[3],p[4]);SetImageCenter(name,p[7],p[8])
            end);R.assets[name]=true
        end
        SetImageState(name,'',min(255,s.age*17),255,255,255);Render(name,o.x,o.y,0,p[11],p[11])
    end,
    kill=function(o)
        local s=o.mhj;R.stopEmitter(s.controller)
        if NativePlayers and NativePlayers.enabled(nil,35) then
            NativePlayers.drop(35,o.x,o.y,s.items)
        elseif s.items and item and item.DropItem then item.DropItem(o.x,o.y,{s.items[2] or 0,s.items[4] or 0,0}) end
        clean(o)
    end,
    del=function(o) R.stopEmitter(o.mhj.controller);clean(o) end,
})
function R.stageState(stage) return {stage=stage,enemies={},templates={},saved={},id=0,clock=0} end
local function randomValue(v)
    local a,b=v:match('^(.-)%+(.+)$');return a and tonumber(a)+ran:Float(0,tonumber(b)) or tonumber(v)
end
local function target(state,id)
    if id=='all' then return end
    id=state.saved[id] or tonumber(id) or state.current
    for i=#state.enemies,1,-1 do local o=state.enemies[i];if valid(o) and o.mhj.id==id then return o end end
end
function R.stage_SetEnemy(s,kind,x,y,speed,dir,life,hp,pattern,id)
    s.id=s.id+1;id=tonumber(id) or s.id
    local spec={type=trunc(randomValue(kind)),x=randomValue(x),y=randomValue(y),speed=randomValue(speed),speedf=randomValue(dir),life=tonumber(life),hp=tonumber(hp),pattern=pattern~='-1' and tostring(s.stage)..pattern or nil,id=id,events={}}
    s.current=id;s.templates[id]=spec;if not s.preroll then New(R.classes.fairy,s,spec) end
end
function R.stage_CopyEnemy(s,x,y,delay,relative,count,id)
    local base=s.templates[s.saved[id] or tonumber(id) or s.current]
    if not base then return end
    local spec=copy(base);s.id=s.id+1;spec.id=s.id;spec.events={}
    for i,e in ipairs(base.events or {}) do if count=='all' or i<=tonumber(count) then spec.events[i]=copy(e);spec.events[i].origin=nil end end
    local function coordinate(v,old)
        if v=='nul' then return old end
        local a,b=v:match('^(.-)%+%+(.+)$');if a then return tonumber(a)+ran:Float(-tonumber(b),tonumber(b)) end
        return randomValue(v)
    end
    spec.x,spec.y=coordinate(x,base.x),coordinate(y,base.y);spec.delay=trunc(randomValue(delay));s.current=spec.id;s.templates[spec.id]=spec
    if not s.preroll then local o=New(R.classes.fairy,s,spec);o.mhj.events=spec.events end
end
function R.stage_AddEvent(s,at,key,value,duration,mode)
    local o=target(s,tostring(s.current))
    local e={at=tonumber(at),key=key,value=randomValue(value),duration=max(1,tonumber(duration)),mode=tonumber(mode)}
    if o then o.mhj.events[#o.mhj.events+1]=e end
    local spec=s.templates[s.current];if spec then spec.events=spec.events or {};spec.events[#spec.events+1]=copy(e) end
end
function R.stage_SetNoHarmTime(s,n)
    local o=target(s,tostring(s.current));if o then o.mhj.noharm=tonumber(n) end
    if s.templates[s.current] then s.templates[s.current].noharm=tonumber(n) end
end
function R.stage_SetEnemyItems(s,...)
    local o=target(s,tostring(s.current));if o then o.mhj.items={...} end
    if s.templates[s.current] then s.templates[s.current].items={...} end
end
function R.stage_Saveid(s,name) s.saved[name]=s.current end
function R.stage_Loadid(s,name) s.current=s.saved[name] or s.current end
function R.stage_ChangeEnemy(s,id,key,value,duration,mode)
    local o=target(s,id)
    local function change(e) e.mhj.events[#e.mhj.events+1]={at=e.mhj.age,key=key,value=tonumber(value),duration=max(1,tonumber(duration)),mode=tonumber(mode)} end
    if o then change(o) elseif id=='all' then for _,e in ipairs(s.enemies) do if valid(e) then change(e) end end end
end
-- 差异2：STD、MSG、XACT与原作资源经济由项目背景、自机、掉落接管。
for _,name in ipairs({'PlayMusic','FadeoutMusic','LoadBackGround','ShowTitle','SetEnemyBarrageUnderActor','RaiseEffect','Caution','SetEnemyParent','SetBossItems','SetBossPassedCards','LastBoss','ExtraBoss'}) do R['stage_'..name]=function() end end
R.data=D
return R
