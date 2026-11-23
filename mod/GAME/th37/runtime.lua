-- 梦华祭二的原生对象后端。脚本在构建时展开；这里仅处理对象运动、插值与生命周期。
-- 坐标严格1:1：原场地(32..416,16..463)→(-192..192,-224..224)。
-- CrazyStorm内部比敌机多(+93,-13)，故弹坐标换算为(x-317,227-y)。
local R={patterns={},classes={},assets={},objects=setmetatable({},{__mode='k'})}
local D=dofile('mod/GAME/th37/catalogue.lua')
local Bindings=dofile('mod/GAME/ports/binding_index.lua')
local floor,abs,min,max=math.floor,math.abs,math.min,math.max
local floatBox=require('ffi').new('float[1]')
local function f32(x) floatBox[0]=x;return floatBox[0] end
local radians,degrees,pi=f32(.0174532924),f32(57.29578),f32(math.pi)
local function sourceCos(a) return f32(math.cos(f32(f32(a)*radians))) end
local function sourceSin(a) return f32(math.sin(f32(f32(a)*radians))) end
local function velocity(o,speed,direction)
    return f32(f32(f32(o.xscale or 1)*f32(speed))*sourceCos(direction)),f32(f32(f32(o.yscale or 1)*f32(speed))*sourceSin(direction))
end
local function trunc(x) return x<0 and math.ceil(x) or floor(x) end
local function valid(o) return o and IsValid(o) end
local function rnd(a) return a~=0 and ran:Float(-a,a) or 0 end
local nativeCopy=lstg.CopySourceTable
local nativeGeometry=lstg.SyncSourceBulletGeometry
local copySizes=setmetatable({},{__mode='k'})
local audio=dofile('mod/GAME/ports/mhj/source_audio.lua').new(37)
local function copy(s)
    local o,count
    if nativeCopy then o,count=nativeCopy(s,copySizes[s] or 128);copySizes[s]=count+8
    else o={};for k,v in pairs(s) do o[k]=type(v)=='number' and f32(v) or v end end
    o.changes={};o.limits={};return o
end
function R.player(context)
    local c=context and (context.controller or context);local t=c and c.weaponTarget
    if t then return t.X+93,t.Y+(-13) end
    return valid(player) and player.x+317 or 317,valid(player) and 227-player.y or 407 end
local function angle(x,y,tx,ty)
    -- Main.Twopointangle保留原作竖直线的0.1分母及单精度运算。
    local dx,dy=f32(f32(tx)-f32(x)),f32(f32(ty)-f32(y))
    local a=f32(math.atan(f32(dy/(dx==0 and f32(dx+f32(.1)) or dx))))
    if dx<0 then a=f32(a+pi) end
    return f32(a*degrees)
end
local function direction(v,o,x,y,point)
    if v==-99999 then local px,py=R.player(o);return angle(x,y,px,py)
    elseif v==-99998 then return angle(x,y,(o.x or x)-4,(o.y or y)+16)
    elseif v==-100000 and point then return angle(x,y,point[1],point[2]) end
    return v or 0
end
-- Batch.r 与 Batch.type 是 float，Barrage.type 才是 int；不能共用一组截断规则。
local intFields={t=true,tiao=true,range=true,life=true,sonlife=true}
local function integer(o,key) return intFields[key] or key=='type' and o.is_projectile end
local boolFields={Mist=true,Dispel=true,Blend=true,Afterimage=true,Outdispel=true,Invincible=true}
local function set(o,key,v)
    if integer(o,key) then v=trunc(v) end
    if type(v)=='number' and not integer(o,key) then v=f32(v) end
    if boolFields[key] then v=v~=0 end
    o[key]=v
    if key=='speed' or key=='speedd' or key=='xscale' or key=='yscale' then o.motion_dirty=true end
    if key=='sonspeed' or key=='sonspeedd' then
        -- BExecution立即写回速度分量，下一帧力场在这个速度上继续叠加。
        o.sonmotion_dirty=true
        if o.is_projectile then
            o.mx,o.my=velocity(o,o.sonspeed or 0,o.sonspeedd or 0)
            o.sonmotion_dirty=false
        end
    end
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
    if o.is_projectile and o.kind~='laser' and key=='type' and op==0 and type(value)=='number' then value=value+1 end
    if value=='自机' then
        local x,y=R.player(o)
        if key=='fx' then value=x elseif key=='fy' then value=y
        else
            local ox,oy=0,0
            if not o.is_projectile and (o.kind=='batch' or o.kind=='laser') then ox,oy=o.controller.offsetx,o.controller.offsety end
            value=angle(f32((o.fx or o.x)+ox),f32((o.fy or o.y)+oy),x,y)
        end
    elseif value=='自身' then
        if not o.is_projectile and (o.kind=='batch' or o.kind=='laser') then
            local ox,oy=o.controller.offsetx,o.controller.offsety
            if key=='fx' then value=f32(o.x-4+ox)
            elseif key=='fy' then value=f32(o.y+16+oy)
            elseif key=='fdirection' or key=='sonaspeedd' then value=angle(f32(o.fx+ox),f32(o.fy+oy),f32(o.x-4+ox),f32(o.y+16+oy))
            else value=initial end
        else value=initial end
    end
    value=f32(value+rnd(random))
    o.changes[#o.changes+1]={key=key,value=value,initial=initial,op=op,mode=mode,duration=max(1,duration),left=max(1,duration)}
end
function R.move(o,x1,x2,y1,y2)
    o.changes[#o.changes+1]={mode='move',x=ran:Float(x1,x2),y=ran:Float(y1,y2),left=60}
end
function R.follow(o) o.changes[#o.changes+1]={mode='follow',left=60} end
function R.sound(name,x) audio.play(name,x) end
function R.stopSound(name) audio.stop(name) end
local function interpolate(o)
    local i=1
    while i<=#o.changes do
        local c=o.changes[i]
        if c.mode=='move' or c.mode=='follow' then
            local x,y=c.x,c.y
            if c.mode=='follow' then x=R.player();y=o.fy end
            if o.is_center and valid(o.host) then
                local hx,hy=f32(o.host.x+224),f32(240-o.host.y)
                if c.mode=='follow' then
                    local px=R.player();o.host.x=(hx*19+px-93)/20-224
                    o.ox=(o.ox*19+px-93)/20
                else
                    -- CExecution用当前位置加差值；不能改写成加权平均后再舍入。
                    o.host.x=f32(hx+f32(f32(f32(x-93)-hx)/20))-224
                    o.host.y=240-f32(hy+f32(f32(y-hy)/20))
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
                local phase=f32(f32(f32(360)/f32(c.duration))*f32(c.duration-c.left))
                v=f32(c.initial+f32(delta*sourceSin(phase)))
            elseif c.mode=='固定' then v=c.op==0 and c.value or old+(c.op==1 and c.value or -c.value)
            elseif c.op==0 then v=f32(f32(f32(old*f32(c.left-1))+f32(c.value))/f32(c.left))
            else
                local delta=f32(f32(c.value)/f32(c.duration))
                -- Execution/BExecution先将整数属性的增量截断，再加减原值。
                if integer(o,c.key) then delta=trunc(delta) end
                v=old+(c.op==1 and delta or -delta)
            end
            if c.mode=='固定' and c.op~=0 and integer(o,c.key) then
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
        if son then o.mx,o.my=velocity(o,o[s] or 0,o[d] or 0)
        else o.mx=f32((o[s] or 0)*sourceCos(o[d] or 0));o.my=f32((o[s] or 0)*sourceSin(o[d] or 0)) end
        o[dirty]=false
    end
    if o[accel] or o.ax==nil then
        if son then o.ax,o.ay=velocity(o,o[a] or 0,o[ad] or 0)
        else o.ax=f32((o[a] or 0)*sourceCos(o[ad] or 0));o.ay=f32((o[a] or 0)*sourceSin(o[ad] or 0)) end
        o[accel]=false
    end
    if son then
        o.mx=f32(o.mx+f32(o.ax*f32(scale)));o.my=f32(o.my+f32(o.ay*f32(scale)))
    else o.mx=f32(o.mx+f32(o.ax*scale));o.my=f32(o.my+f32(o.ay*scale)) end
    if son and (o.sonspeed or 0)~=0 then
        -- Barrage.Update用去掉横纵倍率后的速度更新逻辑方向，事件随后可修改head。
        local heading
        if o.my~=0 then
            local vx,vy=o.mx/(o.xscale or 1),o.my/(o.yscale or 1)
            local a=f32(f32(pi/2)-f32(math.atan(f32(f32(vx)/f32(vy)))))
            if o.my<0 then a=f32(a+pi) end
            heading=f32(a*degrees)
        else heading=o.mx>=0 and 0 or 180 end
        if heading==heading then
            if o.sonspeed>0 then o.sonspeedd=heading end
            if o.Withspeedd then o.head=heading end
        end
    end
    if son then return f32(o.mx*f32(scale)),f32(o.my*f32(scale)) end
    return o.mx*scale,o.my*scale
end
-- Lua模块缓存跨练习重试保留；动态切出的精灵也必须放全局池，避免关卡池清除后留下假缓存。
local function globalResource(fn)
    local pool=GetResourceStatus()
    SetResourceStatus('global');fn();SetResourceStatus(pool)
end
local commonTextures={}
local function texture(p,index)
    index=max(1,trunc(index));local profile
    local cache=commonTextures
    if index>228 then p.textureCache=p.textureCache or {};cache=p.textureCache end
    local cached=cache[index]
    if cached then return cached[1],cached[2] end
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
    cache[index]={name,profile}
    return name,profile
end
function R.loadPattern(id)
    if not R.patterns[id] then
        local p=dofile('mod/GAME/th37/patterns/'..id..'.lua');R.patterns[id]=p
        -- 源文件中的标量是 C# float；仅载入时转换，不在每发弹的浅拷贝中重复转换。
        for _,o in ipairs(p.emitters) do
            for k,v in pairs(o) do if type(v)=='number' then o[k]=f32(v) end end
            for k,v in pairs(o.rand) do o.rand[k]=f32(v) end
        end
        for i,v in ipairs(p.center) do p.center[i]=f32(v) end
        if #p.types>0 then globalResource(function() LoadTexture('mhj2_b'..id,'Resources/th37/b'..id..'.png') end) end
    end
    return R.patterns[id]
end
local function projected(b)
    local s=b.mhj
    local x,y=s.fx+(s.controller.positionx or 0)-317,227-s.fy-(s.controller.positiony or 0)
    local img,p=texture(s.pattern,s.type)
    local a,c=max(0,(p[7]+1)*(s.wscale or 1)),max(0,(p[7]+1)*(s.hscale or 1))
    local rot=-((s.head or 0)+90)
    local layer=(s.controller.effectLayer or s.controller.drawLayer or LAYER.ENEMY_BULLET)+(s.layerid or 0)*2+(s.Blend and 1 or 0)
    local group=s.controller.effectLayer and GROUP.GHOST or (s.Invincible and GROUP.INDES or GROUP.ENEMY_BULLET)
    local collidable=not s.controller.effectLayer and not s.dis and s.age>(s.Mist and 15 or 0) and s.type>0 and (s.alpha or 100)>95 and s.wscale>0 and s.hscale>0
    if lstg.AndroidProjectBullet then
        lstg.AndroidProjectBullet(b,img,x,y,rot,s.wscale,s.hscale,a,c,layer,group,collidable)
    else
        if s.renderImage~=img then b.img=img;s.renderImage=img end
        if nativeGeometry then nativeGeometry(b,x,y,a,c,rot,s.wscale,s.hscale)
        else
            b.x,b.y=x,y;b.vx,b.vy=0,0
            b.a,b.b=a,c;b.rect=false;b.rot=rot;b.hscale,b.vscale=s.wscale,s.hscale
        end
        if b.layer~=layer then b.layer=layer end
        if b.group~=group then b.group=group end
        b.colli=collidable
    end
    b._a=max(0,min(255,(s.alpha or 100)*2.55*(s.controller.friendlyAlpha or 1)));b._r,b._g,b._b=s.colorR or 255,s.colorG or 255,s.colorB or 255
    b._blend=s.Blend and 'mul+add' or ''
end
local function clean(b)
    local s=b.mhj
    if s and s.controller and s.controller.bullets then s.controller.bullets[b]=nil end
    if s then Bindings.remove(s.bindingBucket,b) end
    if s then
        Bindings.remove(s.coverBucket,b);Bindings.remove(s.reboundBucket,b);Bindings.remove(s.forceBucket,b)
    end
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
local preparedPatterns,commonPrepared={},false
function R.preparePattern(id)
    if preparedPatterns[id] then return end
    local p=R.loadPattern(id)
    effectAssets()
    if not commonPrepared then
        for i=1,228 do
            texture(p,i)
            if RogueEncounter then RogueEncounter.checkpoint() end
        end
        for _,name in ipairs({'tan','kira','lazer00','ch02','cat','enep00'}) do audio.prepare(name) end
        commonPrepared=true
    end
    for i=1,#p.types do
        texture(p,228+i)
        if RogueEncounter then RogueEncounter.checkpoint() end
    end
    preparedPatterns[id]=true
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
local function bindingBucket(c,layer,id,create)
    c.parents=c.parents or {}
    local groups=c.parents[layer]
    if not groups and create then groups={};c.parents[layer]=groups end
    if not groups then return end
    if not groups[id] and create then groups[id]=Bindings.new() end
    return groups[id]
end
local function bindingTargets(o)
    return Bindings.snapshot(bindingBucket(o.controller,o.parentid,o.bindid))
end
local function targetable(pair,mistAge)
    local b,s=pair[1],pair[2]
    return b and valid(b) and (not s.Mist or s.age>mistAge)
end
R.classes.projectile=Class(bullet,{
    init=function(b,s)
        -- 不经过通用雾化类；CrazyStorm自己有15帧出生与事件时钟。
        effectAssets()
        s.is_projectile=true;s.kind='projectile';b.mhj=s;b.bound=false;b.group=GROUP.ENEMY_BULLET;b.layer=LAYER.ENEMY_BULLET;b.vx,b.vy=0,0
        s.fx,s.fy=f32(s.fx),f32(s.fy)
        b._a,b._r,b._g,b._b=255,255,255,255;b._blend='';s.age=0;s.changes={};s.limits=s.limits or {};s.object=nil
        s.shadows={};s.previousX,s.previousY=s.fx,s.fy
        s.sourceSpeedd=0
        if s.Withspeedd then s.head=s.sonspeedd end
        R.objects[b]=true;s.controller.bullets[b]=s
        s.controller.serial=(s.controller.serial or 0)+1;s.serial=s.controller.serial
        s.bindingBucket=bindingBucket(s.controller,s.layerid,s.parentid,true)
        Bindings.add(s.bindingBucket,b,s)
        for _,key in ipairs({'Cover','Rebound','Force'}) do
            if s[key] then
                local field=key:lower()..'Bucket'
                s[field]=bindingBucket(s.controller,s.layerid,key,true)
                Bindings.add(s[field],b,s)
            end
        end
        projected(b)
    end,
    frame=function(b)
        local s=b.mhj;s.age=s.age+1
        if s.age==1 then s.sourceSpeedd=s.sonspeedd end
        s.previousX,s.previousY=s.fx,s.fy
        local t=s.age-(s.Mist and 15 or 0)
        if t>0 then
            if t==1 and not s.controller.effectLayer and not s.banSound and s.life>2 and s.alpha>60 then
                R.sound('tan',s.fx-93)
                if s.controller.usekira then R.sound('kira',s.fx-93) end
            end
            -- 原Barrage.Update先积分，再更新事件；速度变化从下一运动帧生效。
            if not s.dis then
                local dx,dy=motion(s,true,s.controller.slow or 1);s.fx,s.fy=f32(s.fx+dx),f32(s.fy+dy)
                s.sourceSpeedd=s.sonspeedd
            end
            updateShadows(s)
            if s.Sonevents then s.Sonevents(s,t,R) end
            -- Time.cs 将 Cover 子事件标记为全局时钟；区域停更后副本仍保留，只有有效区域检测到离开才卸载。
            local order=s.coverOrder
            if order then
                local j=1
                for i=1,#order do
                    local region=order[i];local events=s.covers[region]
                    if events then events(s,s.controller.time,R);order[j]=region;j=j+1
                    else s.covers[region]=nil end
                end
                for i=#order,j,-1 do order[i]=nil end
            end
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
        if s.controller.friendly and R.playerWeaponHit then R.playerWeaponHit(b,s) end
        if projectileOutside(s) then clean(b) end
    end,
    render=function(b)
        local s=b.mhj
        if s.type<=0 then return end
        local image,profile=texture(s.pattern,s.type)
        if s.Mist and s.age<=15 then
            local born=s.age/15
            local small=profile[3]<=(s.type<=228 and 32 or 48)
            if small and profile[8]>=0 then
                local scale=profile[3]/30+1.5*(1-born)
                drawSprite(b,'mhj2_mist_'..profile[8],b.x,b.y,b.rot,scale,scale,b._a*born)
            else
                local extra=small and 0 or 1-born
                drawSprite(b,image,b.x,b.y,b.rot,b.hscale+extra,b.vscale+extra,b._a*born)
            end
            return
        end
        if not s.dis or s.type>228 or profile[3]>=48 then
            if RenderSourceObjectImage then RenderSourceObjectImage(image,b,b._blend,b._a,b._r,b._g,b._b)
            else drawSprite(b,image,b.x,b.y,b.rot,b.hscale,b.vscale,b._a) end
        end
        if s.Afterimage then
            for _,shadow in ipairs(s.shadows) do
                drawSprite(b,image,shadow.x+(s.controller.positionx or 0)-317,227-shadow.y-(s.controller.positiony or 0),-(shadow.head+90),b.hscale,b.vscale,shadow.alpha*255)
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
        -- 对象池回收与弱表的垃圾回收不同步，失效引用不能再读取任何对象字段。
        if valid(b) then
            local s=b.mhj
            if s and s.kind=='projectile' and b.colli then
                count=count+1;collisionObjects[count]=b
                if valid(p) and p.colli~=false then
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
        else
            R.objects[b]=nil
        end
    end
    R.collisionCount=count
end
function R.finishCollisions()
    for i=1,R.collisionCount or 0 do
        local b=collisionObjects[i]
        if valid(b) then
            local s=b.mhj
            if s and not s.dis then b.colli=true end
        elseif b then
            R.objects[b]=nil
        end
        collisionObjects[i]=nil
    end
    R.collisionCount=0
end
-- LUpdate 的长度是运行状态，不是发射器的目标长度；短命激光也要完成退场收束。
R.advanceBeam=dofile('mod/GAME/ports/mhj/straight_laser.lua')(R,interpolate,{
    firstType=0,
    outside=function(s)
        local pad=s.Outdispel and 0 or 200
        return s.fx< -16-pad-s.longs or s.fx>467+pad+s.longs or s.fy< -33-pad-s.longs or s.fy>515+pad+s.longs
    end,
})
local function beamGrazeGrid(s)
    local g=s.laserGraze
    if s.rlongs-g.count*5>0 then
        g.count=math.ceil(s.rlongs/5)
    else
        g.x,g.y,g.direction,g.ready=s.fx,s.fy,s.sonspeedd,g.count
    end
end
local function grazeBeam(b,s)
    local p=player
    if s.life<=2 or s.Invincible and s.age<20 or not valid(p.grazer) then return end
    local g=s.laserGraze
    if not g.ready or g.ready==0 then return end
    local px,py=R.player(s);local ca,sa=sourceCos(g.direction),sourceSin(g.direction)
    local dx,dy=px-g.x,py-g.y
    local along,across=dx*ca+dy*sa,dy*ca-dx*sa
    local state=NativePlayers and NativePlayers.state()
    local radius2=state and state.sakuraStatus==1 and 2000 or 980
    if across*across>radius2 then return end
    local reach=math.sqrt(radius2-across*across)
    local first=max(1,math.ceil((along-reach)/5));local last=min(g.ready,floor((along+reach)/5))
    for i=first,last do if not g.grazed[i] then
        g.grazed[i]=true
        local x,y=g.x+i*5*ca,g.y+i*5*sa
        p.grazer.class.colli(p.grazer,b,true,x-317,227-y)
    end end
end
R.classes.beam=Class(object,{
    init=function(b,s)
        s.is_projectile=true;s.kind='laser';b.mhj=s;b.bound=false;b.vx,b.vy=0,0;s.age=0;s.rlongs=0;s.rwscale=s.wscale;s.changes={};s.limits=s.limits or {};s.object=nil;R.objects[b]=true;s.controller.bullets[b]=s
        b.group,b.layer,b.colli=GROUP.LASER,s.controller.effectLayer or LAYER.ENEMY_BULLET,false
        b.IsLaser,b._inf_graze=true,true
        s.laserGraze={count=0,grazed={}}
        b.x,b.y=s.fx+(s.controller.positionx or 0)-317,227-s.fy-(s.controller.positiony or 0)
    end,
    frame=function(b)
        local s=b.mhj;s.age=s.age+1
        beamGrazeGrid(s)
        if s.age==1 and not s.controller.effectLayer then R.sound('lazer00',s.fx-93) end
        if R.advanceBeam(s) then clean(b);return end
        b.x,b.y,b.rot=s.fx+(s.controller.positionx or 0)-317,227-s.fy-(s.controller.positiony or 0),-(s.head or s.sonspeedd)
        if not s.controller.effectLayer and not s.dis and s.age<=s.life and s.wscale>=.5 and s.alpha>95 and valid(player) and player.colli~=false then
            local px,py=R.player(s);local cx=s.fx+s.rlongs*sourceCos(s.sonspeedd)/2;local cy=s.fy+s.rlongs*sourceSin(s.sonspeedd)/2
            local dx,dy=px-cx,py-cy;local ca,sa=sourceCos(s.head),sourceSin(s.head)
            local along,across=dx*ca+dy*sa,dy*ca-dx*sa
            local character=player.mhj_source and player.mhj_source.character
            local vulnerable=not cheat and player.protect<=0 and not player.hit and player.death<=0
                and not (character and (character.BWudi or character.SWudi))
            if vulnerable and s.rlongs>0 and along^2/(s.rlongs*3/8)^2+across^2/(s.wscale*1.5)^2<=1 then
                player.class.colli(player,b)
                if not s.Invincible then s.dis=true;s.age=s.life+1 end
            else
                grazeBeam(b,s)
            end
        elseif not s.controller.effectLayer and not s.dis and s.age<=s.life and s.alpha>95 and valid(player) and player.colli~=false then
            grazeBeam(b,s)
        end
    end,
    render=function(b)
        local s=b.mhj;local p=D.bulletTypes[33+s.type]
        if not p then return end
        local ray=s.Ray==true;local x,y,w,h=p[1],p[2],p[3],p[4]
        if s.age<=s.life and (s.rlongs<s.longs and not s.alreadyLong or ray) then
            effectAssets()
            local mist='mhj2_mist_'..p[8]
            SetImageState(mist,'',204,255,255,255)
            Render(mist,b.x,b.y,-s.age*5*(180/math.pi)^2)
        end
        if ray then x,y,w,h=s.type*18,711,18,18 end
        local id='mhj2_laser_'..s.type..'_'..tostring(ray)
        if not R.assets[id] then
            globalResource(function() LoadImage(id,'mhj2_barrages',x,y,w,h);SetImageCenter(id,w/2,0) end)
            R.assets[id]=true
        end
        SetImageState(id,s.Blend and 'mul+add' or '',(s.alpha or 100)*2.55,255,255,255)
        Render(id,b.x,b.y,90-(s.head or s.sonspeedd),s.wscale,s.rlongs/(ray and 9 or h))
    end,
    del=function(b) b.mhj.dis=true;b.mhj.age=b.mhj.life+1;object.Preserve(b) end,
    kill=function(b) b.class.del(b) end,
})
local function emit(o,bound)
    local c=o.controller;local p=c.pattern;local rr=o.rand or {}
    local n=trunc((o.tiao or 1)+trunc(rnd(rr.tiao or 0)));if n<=0 then return end
    local ox,oy=c.offsetx,c.offsety
    local fx,fy=o.fx or o.x-4,o.fy or o.y+16
    if bound then fx,fy=bound.fx-ox,bound.fy-oy end
    local r=(o.r or 0)+trunc(rnd(rr.r or 0));local spread=(o.range or 0)+trunc(rnd(rr.range or 0))
    local baseRandom=rnd(rr.fdirection or 0)
    local radial=direction(o.rdirection,o,fx+ox,fy+oy,o.rdirections)+rnd(rr.rdirection or 0)
    local speed=(o.sonspeed or 0)+rnd(rr.sonspeed or 0);local accel=(o.sonaspeed or 0)+rnd(rr.sonaspeed or 0)
    local accelRandom=rnd(rr.sonaspeedd or 0)
    local jx,jy=trunc(rnd(rr.fx or 0)),trunc(rnd(rr.fy or 0))
    for i=0,n-1 do
        local fan=f32(f32(f32(i-f32((n-1)/2))*spread)/n)
        local s=copy(o);s.limits=o.limits;s.controller=c;s.pattern=p;s.emitter=o;s.parentid=o.id;s.layerid=o.parentid
        s.type=trunc(o.type)
        local radialAngle=f32(radial+fan)
        if bound then
            s.fx=f32(bound.fx+f32(r*sourceCos(radialAngle)))
            s.fy=f32(bound.fy+f32(r*sourceSin(radialAngle)))
        else
            s.fx=f32(f32(f32(fx+f32(r*sourceCos(radialAngle)))+jx)+ox)
            s.fy=f32(f32(f32(fy+f32(r*sourceSin(radialAngle)))+jy)+oy)
        end
        -- 发射器的积分缓存不能传给弹体；否则静止发射器会把子弹的3.5速度覆盖成0。
        s.mx,s.my,s.ax,s.ay=nil,nil,nil,nil
        s.sonmotion_dirty,s.sonaccel_dirty=true,true
        local origin={x=o.x+ox,y=o.y+oy,controller=c}
        s.sonspeed,s.sonaspeed=speed,accel
        local fd=o.sourceFdirection and o.sourceFdirection< -99997 and o.sourceFdirection or o.fdirection
        local ad=o.sourceAdirection and o.sourceAdirection< -99997 and o.sourceAdirection or o.sonaspeedd
        s.sonaspeedd=direction(ad,origin,s.fx,s.fy,o.sonaspeedds)+accelRandom
        s.sonspeedd=direction(fd,origin,s.fx,s.fy,o.fdirections)+baseRandom+fan+(o.Bindwithspeedd and bound and (bound.sourceSpeedd or bound.sonspeedd) or 0)
        s.life=o.sonlife;s.age=0;s.head=(o.head or 0)+trunc(rnd(rr.head or 0))
        s.banSound=c.banSound or o.life<20 and o.shot
        New(o.kind=='laser' and R.classes.beam or R.classes.projectile,s)
        o.shot=true
    end
end
local function fire(o,bound)
    if bound then emit(o,bound);return end
    if not o.bindid or o.bindid<0 or o.kind=='batch' and o.bindid==o.id then emit(o);return end
    -- Batch.Shoot的额外发射与周期发射都必须找到已出生的绑定宿主。
    for _,pair in ipairs(bindingTargets(o)) do
        if targetable(pair,15) then emit(o,pair[2]) end
    end
end
function R.fire(o) fire(o,o.bound_source) end
local function emitter(spec,c)
    local o=copy(spec);o.controller=c;o.host=c.host;o.pattern=c.pattern;o.children=setmetatable({},{__mode='k'})
    -- Time.Start 保留原始自机/自身方向标记；父事件改动副本不能破坏该标记。
    o.sourceFdirection=spec.sourceFdirection or spec.fdirection
    o.sourceAdirection=spec.sourceAdirection or spec.sonaspeedd
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
local function area(o,s,c,center)
    if s.layerid~=o.parentid then return false end
    if o.type==1 and s.parentid~=o.controlid-1 then return false end
    -- Cover.Update的未绑定区域在原始绝对坐标中，不随弹幕中心移动。
    local x,y=o.x-4,o.y+16
    if center then x,y=center.fx,center.fy end
    local dx,dy=s.fx-x,s.fy-y
    if o.Circle then return dx*dx+dy*dy<=max(o.halfw,o.halfh)^2 end
    return abs(dx)<=o.halfw and abs(dy)<=o.halfh
end
local function field(o,c,t)
    if o.kind=='cover' then
        o.regions=o.regions or {}
        for _,region in pairs(o.regions) do region.active=false end
        local centers={}
        if o.bound_source then
            centers[1]={fx=o.bound_source.fx-4,fy=o.bound_source.fy+16,key=o.bound_source}
        elseif o.bindid and o.bindid>=0 then
            for _,pair in ipairs(bindingTargets(o)) do
                if targetable(pair,14) then centers[#centers+1]=pair[2] end
            end
        else centers[1]=false end
        for _,center in ipairs(centers) do
            local key=center and (center.key or center) or o
            local region=o.regions[key] or {owner=o};o.regions[key]=region;region.active=true
            local bucket=bindingBucket(c,o.parentid,o.type==1 and o.controlid-1 or 'Cover')
            for _,pair in ipairs(Bindings.snapshot(bucket)) do
                local b,s=pair[1],pair[2]
                if s and s.Cover and (not s.Mist or s.age>15) and valid(b) then
                    s.covers=s.covers or {}
                    if s~=center and area(o,s,c,center) then
                        if not s.covers[region] then s.coverOrder=s.coverOrder or {};s.coverOrder[#s.coverOrder+1]=region end
                        s.covers[region]=o.Sonevents
                    else s.covers[region]=nil end
                end
            end
        end
        for key,region in pairs(o.regions) do if not region.active then o.regions[key]=nil end end
    elseif o.kind=='rebound' then
        -- Rebound 是从端点出发的线段，检查下一帧相对位移；不是以坐标为中心的历史过线测试。
        local x,y=f32(o.x-4),f32(o.y+16)
        local ex,ey=f32(x+f32(o.longs*sourceCos(o.angle))),f32(y+f32(o.longs*sourceSin(o.angle)))
        local rx,ry=f32(ex-x),f32(ey-y)
        for _,pair in ipairs(Bindings.snapshot(bindingBucket(c,o.parentid,'Rebound'))) do
          local b,s=pair[1],pair[2]
          if s and not s.dis and (not s.Mist or s.age>15) and ((s.reboundCount or 0)<o.time or o.time==0) and valid(b) then
            local mx,my=s.mx or 0,s.my or 0;local ax,ay=s.ax or 0,s.ay or 0
            local nx=f32(s.fx+f32(f32(mx+ax)-(o.mx or 0)))
            local ny=f32(s.fy+f32(f32(my+ay)-(o.my or 0)))
            local dx,dy=f32(s.fx-nx),f32(s.fy-ny)
            local den=f32(f32(rx*dy)-f32(ry*dx))
            if den~=0 then
                local qx,qy=f32(nx-x),f32(ny-y)
                local u=f32(f32(f32(qx*dy)-f32(qy*dx))/den)
                local v=f32(f32(f32(qx*ry)-f32(qy*rx))/den)
                if u>=0 and u<=1 and v>=0 and v<=1 then
                    -- 按 Rebound.cs 原式逐项舍入；改用参数方程会改变近水平交点的原作轨迹。
                    local denominator=f32(f32(ry*dx)-f32(dy*rx))
                    local ix=f32(f32(f32(f32(f32(rx*dx)*f32(ny-y))+f32(f32(ry*dx)*x))-f32(f32(dy*rx)*nx))/denominator)
                    local iy=f32(f32(f32(f32(f32(ry*dy)*f32(nx-x))+f32(f32(rx*dy)*y))-f32(f32(dx*ry)*ny))/f32(-denominator))
                    s.sonspeedd=f32(2*o.angle-s.sonspeedd)
                    local distance=math.sqrt(f32(f32(f32(ix-nx)^2)+f32(f32(iy-ny)^2)))
                    local radiansValue=f32(f32(s.sonspeedd)*radians)
                    s.fx=f32(ix+f32((s.xscale or 1)*f32(distance*math.cos(radiansValue))))
                    s.fy=f32(iy+f32((s.yscale or 1)*f32(distance*math.sin(radiansValue))))
                    s.mx,s.my=velocity(s,s.sonspeed,s.sonspeedd);s.sonmotion_dirty=false
                    s.reboundCount=(s.reboundCount or 0)+1
                    if o.Parentevents then
                        o.Parentevents(s,t,R)
                        -- 原作反弹事件在碰撞处立即写入，不延迟到弹体积分后。
                        interpolate(s)
                    end
                end
            end
        end end
    elseif o.kind=='force' then
        local x,y=o.x-4,o.y+16
        local function forceAngle(fx,fy)
            local a=o.addaspeedd or 0
            if o.Suction or o.Repulsion then a=angle(fx,fy,x,y)+(o.Repulsion and 180 or 0) end
            return a
        end
        -- Force.Update也会在雾化期间积累速度；Barrage到第16帧才开始位移。
        for _,pair in ipairs(Bindings.snapshot(bindingBucket(c,o.parentid,'Force'))) do
          local b,s=pair[1],pair[2]
          if s and area(o,s,c) and valid(b) then
            local a=forceAngle(s.fx,s.fy)
            if s.mx==nil or s.sonmotion_dirty then
                s.mx,s.my=velocity(s,s.sonspeed,s.sonspeedd);s.sonmotion_dirty=false
            end
            local ax,ay=velocity(s,o.addaspeed or 0,a)
            s.mx,s.my=f32(s.mx+ax),f32(s.my+ay)
        end end
    end
end
local function reset(c)
    for _,o in ipairs(c.emitters or {}) do
        o.active=false;for _,child in pairs(o.children) do child.active=false end
    end
    local initial=c.pattern.center
    c.emitters={};c.center=copy{fx=initial[1],fy=initial[2],ox=initial[1],oy=initial[2],speed=initial[3],speedd=initial[4],aspeed=initial[5],aspeedd=initial[6],is_center=true,host=c.host}
    for _,spec in ipairs(c.pattern.emitters) do c.emitters[#c.emitters+1]=emitter(spec,c) end
    -- Layer.Update先作用于已有弹体，再生成新弹；新生魂不能提前吃到出生帧的力场。
    local order={force=1,rebound=2,cover=3,laser=4,batch=5}
    table.sort(c.emitters,function(a,b)
        if a.parentid~=b.parentid then return a.parentid<b.parentid end
        if order[a.kind]~=order[b.kind] then return order[a.kind]<order[b.kind] end
        return a.id<b.id
    end)
end
function R.controller(host,id,road)
    local p=R.loadPattern(id)
    local c={host=host,pattern=p,road=road,time=0,offsetx=0,offsety=0,bullets=setmetatable({},{__mode='k'}),jumps={},eventLimits={}}
    reset(c);return c
end
function R.setEffectOffset(c,x,y)
    c.positionx,c.positiony=x,y
    for b,s in pairs(c.bullets) do if valid(b) then
        b.x,b.y=s.fx+x-317,227-s.fy-y
    end end
end
function R.tick(c)
    if c.closed then return end
    c.time=c.time+1
    if c.time>c.pattern.total then c.time=1;reset(c) end
    local t=c.time;local center=c.center
    if c.pattern.globalEvents then c.pattern.globalEvents(c,t,R) end
    t=c.time
    if valid(c.host) then center.ox,center.oy=f32(c.host.x+317),f32(227-c.host.y) end
    if c.pattern.centerAvailable then
        c.offsetx=center.ox-center.fx;c.offsety=center.oy-center.fy
    else c.offsetx,c.offsety=0,0 end
    local function step(o,ot,bound)
        o.active=ot>=1 and ot<=o.life
        if ot<1 or ot>o.life then return end
        -- Rebound.time 是允许的反弹次数，不能被发射器时钟覆盖。
        if o.kind~='rebound' then o.time=ot end
        local mx,my=motion(o,false);o.x,o.y=f32(o.x+mx),f32(o.y+my)
        if o.fx then o.fx=f32(o.fx+mx) end;if o.fy then o.fy=f32(o.fy+my) end
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
        if o.Deepbind and o.bindid and o.bindid>=0 and (o.kind~='batch' or o.bindid~=o.id) then
            for _,child in pairs(o.children) do child.active=false end
            for _,pair in ipairs(bindingTargets(o)) do if targetable(pair,15) then
                local child=o.children[pair[1]]
                if not child then child=emitter(o,c);child.bindid=-1;child.Deepbind=false;child.limits={};o.children[pair[1]]=child end
                step(child,pair[2].age-(child.begin or 1)+2,pair[2])
            end end
        else step(o,t-(o.begin or 1)+1) end
    end
    -- CrazyStorm.Update在各层发射之后推进中心；中心基准x/y始终不变。
    if c.pattern.centerAvailable then
        local dx,dy=motion(center,false)
        -- 保留原Center.Update的ox连续累加speedx、speedy这一行为。
        center.ox=center.ox+dx+dy
        if valid(c.host) then c.host.x,c.host.y=f32(c.host.x+224+dx)-224,240-f32(240-c.host.y+dy) end
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
    for b in pairs(c.bullets) do
        if valid(b) then clean(b)
        else R.objects[b]=nil;c.bullets[b]=nil end
    end
    c.parents={}
end
function R.breakPattern(c,items)
    if not c then return end
    R.stopEmitter(c)
    for b,s in pairs(c.bullets) do if valid(b) then
        if items and not s.dis and s.life>2 and s.alpha>=70 and NativePlayers and NativePlayers.enabled(nil,35) then
            NativePlayers.pickup(b.x,b.y,'sakuraGreen',8)
        end
        Del(b)
    end end
end
function R.bossEntrance(b,t)
    if t>120 then return end
    local x,y=b.x+224,240-b.y
    for o in pairs(R.objects) do if valid(o) then
        local s=o.mhj
        if s and s.is_projectile and not s.controller.effectLayer and not s.dis and not s.Invincible
            and (not s.Mist or s.age>15) and (s.fx-x)^2+(s.fy-y)^2<(t*6)^2 then Del(o)
        elseif s and s.state and o.hp>0 and o.x>=-192 and o.x<=192 and o.y>=-223 and o.y<=224
            and (o.x-b.x)^2+(o.y-b.y)^2<(t*6)^2 then
            s.mana=true;o.hp=0
        end
    end end
end
function R.clearAll()
    audio.clear()
    for b in pairs(R.objects) do
        if valid(b) then clean(b) else R.objects[b]=nil end
    end
    -- 切关后碰撞恢复阶段不能再持有上一局的对象。
    for i=#collisionObjects,1,-1 do collisionObjects[i]=nil end
    R.collisionCount=0
end
function R.stopEmitter(c)
    if c then c.closed=true;c.emitters={} end
end
local DeathEffect=Class(object,{
    init=function(o,p,id)
        o.x,o.y=p.x,p.y;o.source_enemy_death=id~=nil;o.group,o.bound,o.colli=GROUP.GHOST,false,false
        o.effect=R.controller(o,id or 'e14');o.effect.effectLayer=id and LAYER.ENEMY-1 or LAYER.PLAYER+1;R.objects[o]=true
    end,
    frame=function(o)
        if not o.effect.closed and o.effect.time<o.effect.pattern.total then
            if o.follow and valid(o.follow) then
                o.effect.positionx,o.effect.positiony=o.follow.x-o.x,o.y-o.follow.y
            end
            R.tick(o.effect)
        else R.stopEmitter(o.effect);R.objects[o]=nil;object.RawDel(o) end
    end,
    render=function() end,
},true)
function R.playerDeathEffect(p) New(DeathEffect,p) end
function R.effect(x,y,id,layer)
    local o=New(DeathEffect,{x=x,y=y},'e'..id)
    o.effect.effectLayer=layer or LAYER.ENEMY_BULLET+1
    return o
end
function R.deathClear(x,y,r)
    for b in pairs(R.objects) do
        if valid(b) then
            local s=b.mhj
            if s and s.is_projectile and not s.Invincible and not s.controller.effectLayer
                and Dist(x,y,b.x,b.y)<r and not s.dis then Del(b) end
        else
            R.objects[b]=nil
        end
    end
end
function R.deathDamage(x,y,r,damage)
    for b in pairs(R.objects) do
        if valid(b) then
            local s=b.mhj
            if s and not s.is_projectile and not b.protect and b.colli and Dist(x,y,b.x,b.y)<r then
                b.hp=b.hp-damage
            end
        else
            R.objects[b]=nil
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
        local p=D.enemyTypes[spec.type]
        local collision=NativeActorCollision or dofile('THlib/native_actor_collision.lua')
        collision.bind(o,p[9]/2,p[10]/2,'box',p[9]/7,p[10]/7,'box',true)
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
        local s=o.mhj;local p=D.enemyTypes[s.type]
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
        local config=D.enemyTypes[s.type]
        New(DeathEffect,o,'e'..(config[12]+7))
        if s.items and not s.mana then R.sound('enep00',o.x+224) end
        if not s.mana then
            if NativePlayers and NativePlayers.enabled(nil,35) then NativePlayers.drop(35,o.x,o.y,s.items,false,false,max(config[3],config[4]))
            elseif s.items and item and item.DropItem then item.DropItem(o.x,o.y,{s.items[2] or 0,s.items[4] or 0,0}) end
        end
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
function R.stage_RaiseEffect(s,id,x,y,order)
    if not s.preroll then R.effect(tonumber(x)-224,240-tonumber(y),id,({[1]=LAYER.ENEMY-1,[2]=LAYER.ENEMY_BULLET-1,[3]=LAYER.BG+1})[tonumber(order)]) end
end
local stageTitle=dofile('mod/GAME/th37/title.lua')
function R.stage_ShowTitle(s) if not s.preroll then stageTitle(s.stage) end end
function R.stage_SetEnemyBarrageUnderActor(s)
    local o=target(s,tostring(s.current))
    if o and o.mhj.controller then o.mhj.controller.drawLayer=LAYER.ENEMY-1 end
end
R.data=D
return R
