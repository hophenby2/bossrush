-- 永夜篇的原生对象。逻辑使用原坐标，渲染和碰撞按 2/3 投影到项目场地。
local R={patterns={},classes={},assets={},objects=setmetatable({},{__mode='k'}),bulletCount=0,overflow=0,controllers=setmetatable({},{__mode='k'})}
local D=dofile('mod/GAME/th39/catalogue.lua')
local floor,abs,min,max=math.floor,math.abs,math.min,math.max
local SCALE=2/3
function R.project(x,y) return (x-336)*SCALE,(360-y)*SCALE end
local function projectBullet(x,y) return R.project(x-145,y) end
local function unproject(o) return o.x/SCALE+481,360-o.y/SCALE end
local function trunc(x) return x<0 and math.ceil(x) or floor(x) end
local function valid(o) return o and IsValid(o) end
local function rnd(a) return a~=0 and ran:Float(-a,a) or 0 end
local function copy(s)
    local o={};for k,v in pairs(s) do o[k]=v end
    o.changes={};o.limits={};return o
end
function R.player()
    if valid(player) then return unproject(player) end
    return 481,560
end
local function angle(x,y,tx,ty) return math.deg(math.atan2(ty-y,tx-x)) end
local function direction(v,o,x,y,point)
    if v==-99999 then local px,py=R.player();return angle(x,y,px,py)
    elseif v==-99998 then return angle(x,y,o.x or x,o.y or y)
    elseif v==-100000 and point then return angle(x,y,point[1],point[2]) end
    return v or 0
end
local intFields={t=true,tiao=true,r=true,life=true,type=true,sonlife=true}
local boolFields={Mist=true,Dispel=true,Blend=true,Afterimage=true,Outdispel=true,Invincible=true}
local function set(o,key,v)
    if intFields[key] then v=trunc(v) end
    if key=='type' and v~=o.type then o.typeChanged=o.age end
    if boolFields[key] then v=v~=0 end
    o[key]=v
    if key=='speed' or key=='speedd' then o.motion_dirty=true end
    if key=='xscale' or key=='yscale' then o.motion_dirty,o.sonmotion_dirty,o.accel_dirty,o.sonaccel_dirty=true,true,true,true end
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
    if type(value)=='boolean' then value=value and 1 or 0 end
    -- Barrage.type为零基，Batch.type为一基；这里的精灵表统一使用一基。
    if key=='type' and op==0 and type(value)=='number' then value=value+1 end
    if value=='自机' or value=='中心' then
        local c=o.controller
        local x,y
        if value=='中心' then x,y=c.center.ox,c.center.oy else x,y=R.player() end
        local ox,oy=0,0
        if c and not o.is_projectile and not o.bound_source then ox,oy=c.offsetx,c.offsety end
        local bx,by=o.fx or o.x or o.ox,o.fy or o.y or o.oy
        if o.bound_source then bx,by=o.bound_source.fx,o.bound_source.fy end
        if key=='fx' then value=x-ox elseif key=='fy' then value=y-oy
        else value=angle(bx+ox,by+oy,x,y) end
    elseif value=='自身' then value=initial end
    value=value+rnd(random)
    o.changes[#o.changes+1]={key=key,value=value,initial=initial,op=op,mode=mode,duration=max(1,duration),left=max(1,duration)}
end
local function centerMove(o,x,y,slow,duration)
    if not o.is_center or not valid(o.host) or o.controller.road then return end
    local x0,y0=o.ox,o.oy
    duration=duration or (slow and max(10,floor(math.sqrt((x-x0)^2+(y-y0)^2)/1.5)) or 60)
    o.changes[#o.changes+1]={mode='move',x=x,y=y,x0=x0,y0=y0,slow=slow,left=duration,duration=duration}
end
function R.move(o,slow,x1,x2,y1,y2)
    centerMove(o,x1+(x2-x1)*ran:Float(0,1),y1+(y2-y1)*ran:Float(0,1),slow)
end
function R.follow(o,axis)
    if not o.is_center then return end
    local x,y=R.player()
    if axis:find('X',1,true) then y=o.oy elseif axis:find('Y',1,true) then x=o.ox end
    centerMove(o,x,y,axis:find('慢',1,true)~=nil,90)
end
function R.hide(o,value) if valid(o.host) then o.host.mhj3_hidden=value end end
function R.state(o,status) o.controller.status=status;o.controller.statusFrame=0 end
local function control(o,mode,options)
    if not o.controller or not valid(player) then return end
    local old=o.controller.control
    if not old then options.previous=player.lock else options.previous=old.previous end
    options.player,options.mode,options.age=player,mode,0
    o.controller.control=options
    player.lock=true
end
function R.petrify(o,kind,count)
    control(o,'petrify',{presses=count or kind})
end
function R.lockdown(o,duration)
    control(o,'lockdown',{duration=duration})
end
function R.control(o,startup,x,y,duration,tail)
    if not valid(player) then return end
    x,y=projectBullet(x,y)
    control(o,'move',{startup=startup,duration=duration,tail=tail,x=x,y=y,fromX=player.x,fromY=player.y})
end
local function releaseControl(c)
    local control=c.control
    if not control then return end
    if valid(control.player) then control.player.lock=control.previous end
    c.control=nil
end
local function stepControl(c)
    local s=c.control
    if not s then return end
    if not valid(s.player) then c.control=nil;return end
    s.age=s.age+1
    s.player.__shoot_flag=false
    if s.mode=='petrify' then
        if KeyIsPressed('up') or KeyIsPressed('down') or KeyIsPressed('left') or KeyIsPressed('right') then
            s.presses=s.presses-1
        end
        if s.presses<=0 then releaseControl(c) end
    elseif s.mode=='lockdown' then
        if s.age>=s.duration then releaseControl(c) end
    else
        local t=min(1,max(0,(s.age-s.startup)/max(1,s.duration)))
        local k=(1-math.cos(math.pi*(1-(1-t)^1.5)))/2
        s.player.x,s.player.y=s.fromX+(s.x-s.fromX)*k,s.fromY+(s.y-s.fromY)*k
        if s.age>=s.startup+s.duration+s.tail then releaseControl(c) end
    end
end
function R.select(o,layer,kind,...)
    local choices={...}
    local selected=choices[min(#choices,1+floor(ran:Float(0,#choices)))]
    local layerKind=({'batch','laser','cover','rebound','force'})[kind+1]
    for _,e in ipairs(o.controller.emitters) do
        if e.parentid==layer and e.kind==layerKind then
            for _,id in ipairs(choices) do if e.id==id-1 then e.unselected=id~=selected end end
        end
    end
end
function R.sound(name)
    if name:find('kira',1,true) then PlaySound('kira00',.2) end
end
local function interpolate(o)
    local i=1
    while i<=#o.changes do
        local c=o.changes[i]
        if c.mode=='move' then
            if c.slow then
                local k=(1-math.cos(math.pi*(1-(c.left/c.duration)^1.5)))/2
                o.ox,o.oy=c.x0+(c.x-c.x0)*k,c.y0+(c.y-c.y0)*k
            else
                o.ox,o.oy=(o.ox*19+c.x)/20,(o.oy*19+c.y)/20
            end
        else
            local old=o[c.key] or 0;if type(old)=='boolean' then old=old and 1 or 0 end
            local v
            if c.mode=='正弦' or c.mode=='无缝正弦' then
                local delta=c.op==0 and c.value-c.initial or c.op==1 and c.value or -c.value
                local phase=(c.duration-c.left+(c.mode=='无缝正弦' and 1 or 0))/c.duration
                v=c.initial+delta*sin(360*phase)
            elseif c.mode=='固定' then v=c.op==0 and c.value or old+(c.op==1 and c.value or -c.value)
            elseif c.op==0 then v=(old*(c.left-1)+c.value)/c.left
            else v=old+(c.op==1 and c.value or -c.value)/c.duration end
            set(o,c.key,v)
        end
        c.left=c.left-1
        if c.left<=((c.mode=='正弦' or c.mode=='无缝正弦') and -1 or 0) then table.remove(o.changes,i) else i=i+1 end
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
    return o.mx*scale,o.my*scale
end
-- Lua模块缓存跨练习重试保留；动态切出的精灵也必须放全局池，避免关卡池清除后留下假缓存。
local function globalResource(fn)
    local pool=GetResourceStatus()
    SetResourceStatus('global');fn();SetResourceStatus(pool)
end
local function loadTexture(key)
    local name='mhj3_tex_'..key
    if not R.assets[name] then
        globalResource(function() LoadTexture(name,'Resources/th39/'..key..'.png') end)
        R.assets[name]=true
    end
    return name
end
function R.sprite(name,key,x,y,w,h,cx,cy)
    if not R.assets[name] then
        local tex=loadTexture(key)
        globalResource(function()
            LoadImage(name,tex,x,y,w,h)
            SetImageCenter(name,cx,cy)
        end)
        R.assets[name]=true
    end
    return name
end
local function profile(p,index)
    index=max(1,trunc(index))
    return index<=#D.bulletTypes and D.bulletTypes[index] or p.types[min(index-#D.bulletTypes,#p.types)]
end
local function texture(s)
    local p=profile(s.pattern,s.type)
    if not p or p[3]<=0 or p[4]<=0 or p[16]=='' then return 'img_void' end
    local n=floor(max(0,s.age-(s.typeChanged or 0))/(1+(p[10] or 0)))%max(1,p[9] or 1)
    local key=p[16] or 'barrages'
    local height=D.textureHeights[key] or p[4]
    local columns=max(1,floor(height/p[4]))
    local name='mhj3_b_'..key..'_'..p[1]..'_'..p[2]..'_'..p[3]..'_'..p[4]..'_'..p[5]..'_'..p[6]..'_'..n
    return R.sprite(name,key,p[1]+floor(n/columns)*p[3],p[2]+n%columns*p[4],p[3],p[4],p[5],p[6])
end
function R.loadPattern(id)
    if not R.patterns[id] then R.patterns[id]=dofile('mod/GAME/th39/patterns/'..id..'.lua') end
    return R.patterns[id]
end
local function projected(b)
    local s=b.mhj
    b.x,b.y=projectBullet(s.fx,s.fy);b.vx,b.vy=0,0
    local p=profile(s.pattern,s.type)
    local r=p and p[7] or 0
    b.a,b.b=r*abs(s.wscale)*SCALE,r*abs(s.hscale)*SCALE
    b.rect=false;b.rot=-((s.Withspeedd and math.deg(math.atan2(s.my or 0,s.mx or 0)) or s.head or 0)+90)
    b.hscale,b.vscale=s.wscale*SCALE,s.hscale*SCALE
    local born=s.Mist and min(1,s.age/15) or 1
    b._a=max(0,min(255,(s.alpha or 100)*2.55*born));b._r,b._g,b._b=s.colorR or 255,s.colorG or 255,s.colorB or 255
    b._blend=s.Blend and 'mul+add' or ''
    b.layer=LAYER.ENEMY_BULLET+(s.controller.pattern.order==1 and .1 or 0)
    b.group=(s.Invincible or p and p.invincible) and GROUP.INDES or GROUP.ENEMY_BULLET
    b.colli=s.age>(s.Mist and 15 or 0) and s.type>1 and r>0 and (s.alpha or 100)>99 and s.wscale~=0 and s.hscale~=0
end
local function clean(b)
    local s=b.mhj
    if s and s.controller and s.controller.host==b then R.clear(s.controller) end
    if s and s.controller and s.controller.bullets then
        s.controller.bullets[b]=nil
        if s.bucket then s.bucket[b]=nil end
        if s.counted then R.bulletCount=R.bulletCount-1;s.counted=false end
    end
    if s and s.familiar and s.controller then
        if s.controller.familiars[s.familiar]==b then s.controller.familiars[s.familiar]=nil end
        if s.killed then s.controller.deadFamiliars[s.familiar]=(s.controller.deadFamiliars[s.familiar] or 0)+1 end
    end
    R.objects[b]=nil;object.RawDel(b)
end
R.classes.projectile=Class(bullet,{
    init=function(b,s)
        -- 不经过通用雾化类；CrazyStorm自己有15帧出生与事件时钟。
        s.is_projectile=true;b.mhj=s;b.bound=false;b.group=GROUP.ENEMY_BULLET;b.layer=LAYER.ENEMY_BULLET;b.vx,b.vy=0,0
        b._a,b._r,b._g,b._b=255,255,255,255;b._blend='';s.age=0;s.changes={};s.limits=s.limits or {};s.object=nil
        R.objects[b]=true;s.controller.bullets[b]=s;projected(b)
    end,
    frame=function(b)
        local s=b.mhj;s.age=s.age+1
        if s.age>(s.life or 1)+(s.Mist and 15 or 0) then clean(b);return end
        local t=s.age-(s.Mist and 15 or 0)
        s.status,s.statusFrame=s.controller.status,s.controller.statusFrame
        if t>0 then
            -- 原Barrage.Update先积分，再更新事件；速度变化从下一运动帧生效。
            local dx,dy=motion(s,true,s.controller.slow or 1);s.fx,s.fy=s.fx+dx,s.fy+dy
            if s.Sonevents then s.Sonevents(s,t,R) end
            if s.covers then
                for field,events in pairs(s.covers) do
                    if field.active then events(s,t,R) else s.covers[field]=nil end
                end
            end
            s.maskEntered=0
            interpolate(s)
            if t>s.life then clean(b);return end
        end
        projected(b)
        if s.Outdispel and (s.fx<118 or s.fx>844 or s.fy< -51 or s.fy>771) then clean(b) end
    end,
    render=function(b)
        if b._a<=0 then return end
        local img=texture(b.mhj);b.img=img
        SetImageState(img,b._blend,b._a,b._r,b._g,b._b)
        Render(img,b.x,b.y,b.rot,b.hscale,b.vscale)
    end,
    del=function(b) clean(b) end,kill=function(b) clean(b) end,
})
local function laserWidth(s)
    local p=profile(s.pattern,s.type)
    return max(0,s.wscale)*(p and p[3]>0 and p[3] or 18)*SCALE
end
local function laserColor(s)
    local p=profile(s.pattern,s.type)
    return ({2,4,6,10,12,14,16,8})[((p and p[8] or 0)%8)+1]
end
local function laserInit(b,s)
    s.is_projectile=true;b.mhj=s;b.bound=false;b.vx,b.vy=0,0
    s.age=0;s.changes={};R.objects[b]=true;s.controller.bullets[b]=s
end
local function laserStep(b)
    local s=b.mhj;s.age=s.age+1
    if s.age>s.life then clean(b);return end
    s.status,s.statusFrame=s.controller.status,s.controller.statusFrame
    if s.Sonevents then s.Sonevents(s,s.age,R) end
    interpolate(s)
    local dx,dy=motion(s,true,s.controller.slow or 1);s.fx,s.fy=s.fx+dx,s.fy+dy
    b.x,b.y=projectBullet(s.fx,s.fy);b.vx,b.vy=0,0
    b.w=laserWidth(s);b.alpha=max(0,min(1,(s.alpha or 100)/100));b.colli=s.wscale>=.5 and b.alpha>=1
    if s.Outdispel and (s.fx<118-s.longs or s.fx>844+s.longs or s.fy< -51-s.longs or s.fy>771+s.longs) then clean(b);return end
    return s
end
R.classes.beam=Class(laser,{
    init=function(b,s)
        local x,y=projectBullet(s.fx,s.fy)
        laser.init(b,laserColor(s),x,y,-s.sonspeedd,0,max(1,s.longs*SCALE),0,laserWidth(s),0,0)
        laserInit(b,s)
    end,
    frame=function(b)
        local s=laserStep(b);if not s then return end
        if s.Ray=='Ray' or s.Ray==true then
            b.rot=-s.sonspeedd;b.l2=792*SCALE
        else
            b.rot=180-math.deg(math.atan2(s.my or 0,s.mx or 0))
            s.reached=min(max(0,s.longs),(s.reached or 0)+math.sqrt((s.mx or 0)^2+(s.my or 0)^2))
            b.l2=s.reached*SCALE
        end
        laser.frame(b)
    end,
    del=clean,kill=clean,
})
R.classes.curve=Class(bent_laser,{
    init=function(b,s)
        local x,y=projectBullet(s.fx,s.fy)
        bent_laser.init(b,laserColor(s),x,y,max(4,(s.segment or 64)),laserWidth(s),4,0)
        laserInit(b,s)
    end,
    frame=function(b) if laserStep(b) then bent_laser.frame(b) end end,
    del=clean,kill=clean,
})
local function fairySprite(b,config,age)
    local n=floor(age/((config[19] or 6)+1))%max(1,config[7])
    local key=config[1];local name='mhj3_enemy_'..key..'_'..config[2]..'_'..config[3]..'_'..n
    R.sprite(name,key,config[2]+n*config[4],config[3],config[4],config[5],config[12],config[13])
    SetImageState(name,'',min(255,age*13),255,255,255)
    Render(name,b.x,b.y,0,config[16]*SCALE)
end
-- 147–150 是使魔槽位；它们沿用弹体轨迹，使用可受击的原生敌机对象。
R.classes.familiar=Class(enemy,{
    init=function(b,s,slot,config)
        enemybase.init(b,config[2]);b.mhj=s;s.familiar=slot;s.familiarConfig=config
        s.is_projectile=true;b.bound=false;b.vx,b.vy=0,0;b.layer=LAYER.ENEMY
        s.age=0;R.objects[b]=true;s.controller.bullets[b]=s;s.controller.familiars[slot]=b
        b.x,b.y=projectBullet(s.fx,s.fy);b.colli=false
        local p=D.enemyTypes[config[1]]
        b.a,b.b=p[14]/2*SCALE,p[15]/2*SCALE
    end,
    frame=function(b)
        local s=b.mhj
        if b.hp<=0 then object.Kill(b);return end
        s.age=s.age+1
        local t=s.age-(s.Mist and 15 or 0)
        if t>s.life then clean(b);return end
        if t>0 then
            local dx,dy=motion(s,true,s.controller.slow or 1)
            s.fx,s.fy=s.fx+dx,s.fy+dy
            if s.Sonevents then s.Sonevents(s,t,R) end
            interpolate(s)
        end
        b.x,b.y=projectBullet(s.fx,s.fy);b.vx,b.vy=0,0
        b.colli=t>0 and (s.alpha or 100)>99
        SetAttr(b,'colli',b.colli)
    end,
    render=function(b) fairySprite(b,D.enemyTypes[b.mhj.familiarConfig[1]],b.mhj.age) end,
    del=clean,kill=function(b) b.mhj.killed=true;clean(b) end,
})
local function emit(o,bound)
    if o.unselected then return end
    local c=o.controller;local p=c.pattern;local rr=o.rand or {}
    local n=trunc((o.tiao or 1)+trunc(rnd(rr.tiao or 0)));if n<=0 then return end
    local ox,oy=c.offsetx,c.offsety
    local fx,fy=o.fx or o.x,o.fy or o.y
    if bound then fx,fy=bound.fx-ox,bound.fy-oy end
    local r=(o.r or 0)+trunc(rnd(rr.r or 0));local spread=(o.range or 0)+trunc(rnd(rr.range or 0))
    local baseRandom=rnd(rr.fdirection or 0)
    local radial=direction(o.rdirection,o,fx+ox,fy+oy,o.rdirections)+rnd(rr.rdirection or 0)
    local speed=(o.sonspeed or 0)+rnd(rr.sonspeed or 0);local accel=(o.sonaspeed or 0)+rnd(rr.sonaspeed or 0)
    local accelRandom=rnd(rr.sonaspeedd or 0)
    local ws,hs=rnd(rr.wscale or 0),rnd(rr.hscale or 0)
    local jx,jy=trunc(rnd(rr.fx or 0)),trunc(rnd(rr.fy or 0))
    local slot=o.type-147
    local config=c.configs[slot]
    local bucket=o.bucket
    for i=0,n-1 do
        local fan=(i-(n-1)/2)*spread/n
        if R.bulletCount>=10000 then R.overflow=R.overflow+1;return end
        local s=copy(o)
        s.changes,s.limits={},{}
        s.controller,s.pattern,s.bucket=c,p,bucket
        s.parentid,s.layerid=o.id,o.parentid
        s.counted=true
        R.bulletCount=R.bulletCount+1
        s.fx,s.fy=fx+r*cos(radial+fan)+jx+ox,fy+r*sin(radial+fan)+jy+oy
        -- 发射器的积分缓存不能传给弹体；否则静止发射器会把子弹的3.5速度覆盖成0。
        s.mx,s.my,s.ax,s.ay=nil,nil,nil,nil
        s.sonmotion_dirty,s.sonaccel_dirty=true,true
        s.sonspeed,s.sonaspeed=speed,accel
        local origin={x=o.x+ox,y=o.y+oy}
        s.sonaspeedd=direction(o.sonaspeedd,origin,s.fx,s.fy,o.sonaspeedds)+accelRandom
        s.sonspeedd=direction(o.fdirection,origin,s.fx,s.fy,o.fdirections)+baseRandom+fan+(o.Bindwithspeedd and bound and bound.sonspeedd or 0)
        s.wscale=(s.wscale or 1)+ws;s.hscale=o.syncScale and s.wscale or (s.hscale or 1)+hs
        c.serial=c.serial+1;s.serial=c.serial
        s.life=o.sonlife;s.age=0;s.head=(o.head or 0)+trunc(rnd(rr.head or 0))
        local b
        if o.kind=='laser' then b=New(s.Ray=='Curve' and R.classes.curve or R.classes.beam,s)
        elseif config then b=New(R.classes.familiar,s,slot,config)
        else b=New(R.classes.projectile,s) end
        if bucket then bucket[b]=s end
    end
end
function R.fire(o)
    if o.bound_source then emit(o,o.bound_source)
    elseif o.bindid and o.bindid>=0 and o.bindid~=o.id then
        local targets=o.controller.targets(o)
        for _,pair in ipairs(targets) do emit(o,pair[2]) end
    else emit(o) end
end
function R.recover(o)
    local spec=o.spec
    if not spec then return end
    for _,key in ipairs({'fx','fy','r','rdirection','tiao','t','fdirection','range','speed','speedd','aspeed','aspeedd','life','type','wscale','hscale','alpha','head','sonspeed','sonspeedd','sonaspeed','sonaspeedd','xscale','yscale'}) do
        if spec[key]~=nil and (key~='fx' and key~='fy' or spec[key]>-99998) then set(o,key,spec[key]) end
    end
end
local function emitter(spec,c)
    local o=copy(spec);o.spec=spec.spec or spec;o.controller=c;o.host=c.host;o.pattern=c.pattern;o.children=setmetatable({},{__mode='k'})
    -- Batch.Copy是浅拷贝，原EventRead的次数限制跨Totalframe循环保留。
    -- 只重置运动/插值状态；不能每轮重新启用括号(1)的开场事件。
    local key=spec.kind..':'..spec.parentid..':'..spec.id
    c.eventLimits[key]=c.eventLimits[key] or {};o.limits=c.eventLimits[key]
    local rr=o.rand
    if o.kind=='batch' then
        c.parents[o.parentid]=c.parents[o.parentid] or {}
        local layer=c.parents[o.parentid]
        layer[o.id]=layer[o.id] or {}
        o.bucket=layer[o.id]
    end
    for _,key in ipairs({'speed','speedd','aspeed','aspeedd'}) do o[key]=(o[key] or 0)+rnd(rr[key] or 0) end
    if o.fx==-99998 then o.fx=o.x elseif o.fx==-99999 then o.fx=R.player() end
    if o.fy==-99998 then o.fy=o.y elseif o.fy==-99999 then local _,y=R.player();o.fy=y end
    o.speedd=direction(o.speedd,o,o.fx or o.x,o.fy or o.y,o.speedds)
    o.aspeedd=direction(o.aspeedd,o,o.fx or o.x,o.fy or o.y,o.aspeedds)
    return o
end
local function area(o,s,c,center)
    if s.layerid~=o.parentid then return false end
    if o.type==1 and s.parentid~=o.controlid-1 then return false end
    local x,y=o.x+c.offsetx,o.y+c.offsety
    if center then x,y=center.fx,center.fy end
    local dx,dy=s.fx-x,s.fy-y
    if o.degree and o.degree~=0 then
        local ca,sa=cos(o.degree),sin(o.degree)
        dx,dy=dx*ca+dy*sa,-dx*sa+dy*ca
    end
    if o.Circle then return dx*dx/max(1,o.halfw^2)+dy*dy/max(1,o.halfh^2)<=1 end
    return abs(dx)<=o.halfw and abs(dy)<=o.halfh
end
local function field(o,c,t)
    if o.unselected then return end
    if o.kind=='cover' then
        if not o.Sonevents then return end
        local layer=c.parents[o.parentid]
        local sources=o.bindid and o.bindid>=0 and layer and layer[o.bindid]
        local targets=o.type==1 and layer and layer[o.controlid-1] or c.bullets
        if o.type==1 and (not layer or not layer[o.controlid-1]) then return end
        local function contains(s)
            if not sources then return (not o.bindid or o.bindid<0) and area(o,s,c) end
            for b,center in pairs(sources) do
                if s~=center and valid(b) and (not center.Mist or center.age>=15) and area(o,s,c,center) then return true end
            end
            return false
        end
        for b,s in pairs(targets) do
            if valid(b) and s.Cover and (not s.Mist or s.age>15) and s.layerid==o.parentid then
                if s.kind~='laser' and contains(s) then
                    s.covers=s.covers or {}
                    local enter=s.covers[o]==nil
                    s.covers[o]=o.Sonevents
                    if enter then s.maskEntered=1 end
                elseif s.covers then s.covers[o]=nil end
            end
        end
    elseif o.kind=='rebound' then
        local ox,oy=o.x+c.offsetx,o.y+c.offsety;local ca,sa=cos(o.angle),sin(o.angle)
        for b,s in pairs(c.bullets) do if valid(b) and s.Rebound and (not s.Mist or s.age>15) then
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
    for _,e in ipairs(c.emitters or {}) do e.active=false end
    c.emitters={};c.center=copy{fx=c.pattern.center[1],fy=c.pattern.center[2],speed=c.pattern.center[3],speedd=c.pattern.center[4],aspeed=c.pattern.center[5],aspeedd=c.pattern.center[6],is_center=true,host=c.host}
    for _,spec in ipairs(c.pattern.emitters) do c.emitters[#c.emitters+1]=emitter(spec,c) end
end
function R.controller(host,id,road,configs)
    local p=R.loadPattern(id)
    local c={host=host,pattern=p,road=road,time=0,offsetx=0,offsety=0,bullets=setmetatable({},{__mode='k'}),jumps={},eventLimits={},serial=0,status=0,statusFrame=0,configs=configs or {},familiars={},deadFamiliars={},parents={}}
    reset(c);R.controllers[c]=true;return c
end
function R.tick(c)
    c.time=c.time+1;c.statusFrame=c.statusFrame+1
    if c.time>c.pattern.total then c.time=1;reset(c) end
    local t=c.time;local center=c.center
    if c.pattern.globalEvents then c.pattern.globalEvents(c,t,R) end
    t=c.time
    if valid(c.host) then center.ox,center.oy=unproject(c.host) else center.ox,center.oy=center.fx,center.fy end
    center.controller=c;center.status,center.statusFrame=c.status,c.statusFrame
    if c.pattern.centerAvailable then
        local dx,dy=motion(center,false)
        center.ox,center.oy=center.ox+dx,center.oy+dy
    end
    c.pattern.centerEvents(center,t,R);interpolate(center)
    stepControl(c)
    if c.pattern.centerAvailable then
        if valid(c.host) and not c.road then c.host.x,c.host.y=projectBullet(center.ox,center.oy) end
        c.offsetx,c.offsety=center.ox-center.fx,center.oy-center.fy
    else c.offsetx,c.offsety=0,0 end
    local function targets(o)
        local out={}
        local layer=c.parents[o.parentid]
        local bucket=layer and layer[o.bindid]
        if not bucket then return out end
        for b,s in pairs(bucket) do
            if valid(b) and (not s.Mist or s.age>15) then
                out[#out+1]={b,s}
            end
        end
        table.sort(out,function(a,b) return a[2].serial<b[2].serial end)
        return out
    end
    c.targets=targets
    local function step(o,ot,bound)
        o.active=ot>=1 and ot<=o.life
        if not o.active then return end
        o.time=ot;o.status,o.statusFrame=c.status,c.statusFrame
        local mx,my=motion(o,false);o.x,o.y=o.x+mx,o.y+my
        if o.fx then o.fx=o.fx+mx end;if o.fy then o.fy=o.fy+my end
        o.bound_source=bound
        if o.kind~='rebound' and o.Parentevents then o.Parentevents(o,ot,R) end
        interpolate(o)
        if o.kind=='batch' or o.kind=='laser' then
            if o.t>0 and ot%o.t+trunc(rnd(o.rand.t or 0))==0 then
                if bound then emit(o,bound)
                elseif o.bindid and o.bindid>=0 and o.bindid~=o.id then
                    for _,pair in ipairs(targets(o)) do emit(o,pair[2]) end
                else emit(o) end
            end
        else field(o,c,ot) end
    end
    for _,o in ipairs(c.emitters) do
        if o.Deepbind and o.bindid and o.bindid>=0 and o.bindid~=o.id then
            for _,pair in ipairs(targets(o)) do
                local child=o.children[pair[1]]
                if not child then
                    child=emitter(o,c);child.bindid=-1;child.Deepbind=false;child.limits={};child.localTime=0
                    o.children[pair[1]]=child
                else
                    child.localTime=child.localTime+1
                    child.x,child.y=pair[2].fx-c.offsetx,pair[2].fy-c.offsety
                    child.fx,child.fy=child.x,child.y
                    step(child,child.localTime-(child.begin or 1)+1,pair[2])
                end
            end
        else step(o,t-(o.begin or 1)+1) end
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
    local elapsed=t-start+1
    c.slow=1
    if duration==0 or elapsed<=duration then
        c.slow=mode==1 and .01 or max(.01,.5+.5*max(0,(elapsed/max(1,duration)-.8)/.2)^3)
    end
end
function R.clear(c)
    if not c then return end
    releaseControl(c);R.controllers[c]=nil
    for b in pairs(c.bullets) do
        if valid(b) then clean(b) end
    end
end
function R.clearAll()
    for c in pairs(R.controllers) do R.clear(c) end
    for b in pairs(R.objects) do if valid(b) then clean(b) end end
    R.bulletCount=0
end
-- 道中敌机的时钟、复制模板和目标标签来自 StageManager。
local function range(value)
    local base,spread=value:match('^(.-)%+(.+)$')
    return tonumber(base or value) or base or value,tonumber(spread) or 0
end
local function randomValue(value)
    local base,spread=range(value)
    return spread==0 and base or base+ran:Float(0,1)*spread
end
local function playerAim(x,y)
    local px,py=R.player()
    return angle(x,y,px-145,py)
end
local function enemyEvent(o,s,e,t)
    if t<e.at or t>=e.at+e.duration then return end
    local host=e.key=='hp' and o or s
    if e.origin==nil then
        e.origin=host[e.key]
        if e.value=='自机' then e.target=playerAim(s.x,s.y)
        elseif e.relative then e.target=e.origin+e.value
        else e.target=e.value end
        if e.spread~=0 then e.target=e.target+ran:Float(0,1)*e.spread end
    end
    if e.mode==1 then host[e.key]=host[e.key]+(e.target-e.origin)/e.duration
    elseif e.mode==2 then host[e.key]=e.target
    else host[e.key]=e.origin+(e.target-e.origin)*sin(360*t/e.duration) end
end
R.classes.fairy=Class(enemy,{
    init=function(o,state,spec)
        enemybase.init(o,spec.hp)
        local s=copy(spec);o.mhj=s;s.age=0
        s.events={};for i,e in ipairs(spec.events) do s.events[i]=copy(e) end
        o.bound=false;o.vx,o.vy=0,0;o.group=GROUP.ENEMY;o.layer=LAYER.ENEMY;o.colli=false
        o.x,o.y=R.project(s.x,s.y);o.maxhp=spec.hp
        local p=D.enemyTypes[s.type]
        o.a,o.b=p[14]/2*SCALE,p[15]/2*SCALE
        s.controller=s.pattern and R.controller(o,s.pattern,true,state.familiars) or nil
        state.enemies[spec.id]=o;R.objects[o]=true
    end,
    frame=function(o)
        local s=o.mhj
        local c=s.controller
        if s.deadCondition and c then
            local dead=0
            for _,n in pairs(c.deadFamiliars) do dead=dead+n end
            if dead>=s.deadCondition then o.hp=0 end
        end
        if o.hp<=0 then object.Kill(o);return end
        if s.age>=s.life then object.Del(o);return end
        for _,e in ipairs(s.events) do enemyEvent(o,s,e,s.age) end
        s.x,s.y=s.x+s.speed*cos(s.speedf),s.y+s.speed*sin(s.speedf);s.age=s.age+1
        local collidable=s.age>max(s.noharm or 0,s.hide or 0,30) and not s.underneath
        o.colli=collidable;SetAttr(o,'colli',collidable);o.layer=s.underneath and LAYER.ENEMY-2 or LAYER.ENEMY
        if c and s.age>=s.delay then R.tick(c) end
        o.x,o.y=R.project(s.x,s.y);o.vx,o.vy=0,0
    end,
    render=function(o)
        local s=o.mhj
        if s.age>(s.hide or 0) then fairySprite(o,D.enemyTypes[s.type],s.age) end
    end,
    kill=function(o)
        local s=o.mhj;R.clear(s.controller)
        if NativePlayers and NativePlayers.enabled(nil,37) then
            NativePlayers.drop(37,o.x,o.y,s.items)
        elseif s.items and item and item.DropItem then item.DropItem(o.x,o.y,{tonumber(s.items[2]),tonumber(s.items[4]),0}) end
        clean(o)
    end,
    del=function(o) R.clear(o.mhj.controller);clean(o) end,
})
function R.stageState(stage)
    return {stage=stage,enemies={},templates={},labels={},familiars={},id=0}
end
local function target(s,label)
    local id=label and s.labels[label] or s.current
    local o=s.enemies[id]
    if valid(o) then return o end
end
local function spawn(s,spec,label)
    s.id=s.id+1;spec.id=s.id;s.current=spec.id;s.templates[spec.id]=spec
    if label then s.labels[label]=spec.id end
    if not s.preroll then New(R.classes.fairy,s,spec) end
end
local function setMotion(spec)
    spec.speed=randomValue(spec.speedSource)
    local base,spread=range(spec.directionSource)
    if base=='自机' then base=playerAim(spec.x,spec.y) end
    spec.speedf=base+(spread==0 and 0 or ran:Float(0,1)*spread)
end
function R.stage_SetEnemy(s,kind,x,y,speed,dir,life,hp,pattern,delay,label)
    local spec={type=trunc(randomValue(kind)),x=randomValue(x),y=randomValue(y),life=tonumber(life),
        hp=tonumber(hp),pattern=pattern~='-1' and tostring(s.stage)..pattern or nil,
        delay=trunc(randomValue(delay or '0')),speedSource=speed,directionSource=dir,events={}}
    setMotion(spec);spawn(s,spec,label)
end
function R.stage_CopyEnemy(s,x,y,delay,relative,count,label)
    local id=label and s.labels[label] or s.current
    local base=s.templates[id]
    if not base or not s.preroll and not target(s,label) then return end
    local spec=copy(base)
    spec.x,spec.y=x=='nul' and base.x or randomValue(x),y=='nul' and base.y or randomValue(y)
    spec.delay=trunc(randomValue(delay or '0'));spec.events={}
    setMotion(spec)
    for i,e in ipairs(base.events) do
        if count~='all' and i>(tonumber(count) or 0) then break end
        local event=copy(e)
        event.relative=relative=='true' and event.value~='自机'
        spec.events[#spec.events+1]=event
    end
    spawn(s,spec)
end
function R.stage_AddEvent(s,at,key,value,duration,mode)
    local spec=s.templates[s.current]
    if not spec then return end
    local base,spread=range(value)
    local e={at=tonumber(at),key=key,value=base,spread=spread,duration=max(1,tonumber(duration)),mode=tonumber(mode)}
    spec.events[#spec.events+1]=e
    local o=target(s)
    if o then o.mhj.events[#o.mhj.events+1]=copy(e) end
end
local function stageField(s,k,v)
    local spec=s.templates[s.current]
    if spec then spec[k]=v end
    local o=target(s)
    if o then o.mhj[k]=v end
end
function R.stage_SetNoHarmTime(s,n) stageField(s,'noharm',tonumber(n)) end
function R.stage_SetHideTime(s,n) stageField(s,'hide',tonumber(n)) end
function R.stage_SetEnemyItems(s,...) stageField(s,'items',{...}) end
function R.stage_SetEnemyUnderneath(s) stageField(s,'underneath',true) end
function R.stage_SetEnemyDeadCondition(s,n) stageField(s,'deadCondition',tonumber(n)) end
function R.stage_SetEnemyBarrageDispel(s,n) stageField(s,'highlightDispel',n=='1') end
function R.stage_BindFamiliar(s,slot,kind,hp)
    s.familiars[max(1,min(4,tonumber(slot)))]={tonumber(kind),tonumber(hp)}
end
function R.stage_PauseByEnemy(s,label) s.waitEnemy=target(s,label) end
function R.stage_Pause(s,time) s.pause=tonumber(time) end
function R.stage_Goto(s,t) s.gotoTick=t end
R.data=D
return R
