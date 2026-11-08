-- TH11发弹对象：29种弹型来自原版PE的0x4a3ec0表，2000槽来自0x408f20。
-- etEx编号按0x409700核对，不能沿用TH10的编号（TH11的4/8才是向量/极坐标加速）。
local H,class=...
local A,object,New,IsValid=OriginalANM,object,New,IsValid
local band,bor=require('bit').band,require('bit').bor
local profiles=dofile('mod/GAME/th36/bullet_profiles.lua')
local PI,TAU=3.1415927410125732,6.2831854820251465
local function copy(p)
    local out={};for k,v in pairs(p) do if type(v)=='table' then out[k]=copy(v) else out[k]=v end end;return out
end
function H.gun_new(a,i)
    a.guns[i]={type=0,color=0,angle=0,step=0,s1=2,s2=0,n=1,layers=1,aim=0,ox=0,oy=0,dist=0,
        flags=0x83,sound=7,transform_sound=24,ex={}}
end
local function gun(a,i) return assert(a.guns[i],'TH11枪槽越界：'..i) end
function H.gun_sprite(a,i,t,c) local p=gun(a,i);p.type,p.color=t,c end
function H.gun_offset(a,i,x,y) local p=gun(a,i);p.ox,p.oy=x,y end
function H.gun_angle(a,i,x,y) local p=gun(a,i);p.angle,p.step=x,y end
function H.gun_speed(a,i,x,y) local p=gun(a,i);p.s1,p.s2=x,y end
function H.gun_count(a,i,x,y) local p=gun(a,i);p.n,p.layers=x,y end
function H.gun_aim(a,i,m) gun(a,i).aim=m end
function H.gun_sound(a,i,x,y) local p=gun(a,i);p.sound,p.transform_sound=x,y end
function H.gun_copy(a,d,s) a.guns[d]=copy(gun(a,s)) end
function H.gun_transform(a,i,index,allow,kind,i0,i1,f0,f1)
    assert(index>=0 and index<18,'TH11弹变换槽越界')
    gun(a,i).ex[index]={allow=allow,kind=kind%4294967296,i0=i0,i1=i1,f0=f0,f1=f1}
end
function H.gun_speed_diff(a,i,e,n,h,l,e2,n2,h2,l2) H.gun_speed(a,i,l,l2) end
function H.gun_count_diff(a,i,e,n,h,l,e2,n2,h2,l2) H.gun_count(a,i,l,l2) end
function H.gun_polar(a,i,angle,r) H.gun_offset(a,i,math.cos(angle)*r,math.sin(angle)*r) end
function H.gun_distance(a,i,d) gun(a,i).dist=d end
function H.gun_absolute(a,i,x,y) local p=gun(a,i);p.absolute=x>=-990;p.absx,p.absy=x,y end
local function origin(a,p)
    local x,y=a.o.x,224-a.o.y
    if p.absolute then x,y=p.absx,p.absy end
    return x+p.ox,y+p.oy
end
local function aim(x,y) return math.atan2(224-player.y-y,player.x-x) end
local function velocity(b) b.mx,b.my=H.f32(math.cos(b.angle)*b.speed),H.f32(math.sin(b.angle)*b.speed) end
local function resolver(b)
    return function(raw)
        local p=assert(profiles[b.kind],'TH11弹型不存在：'..b.kind)
        if p.sprites[0]<0 then return raw end
        return assert(p.sprites[b.color*3+raw],'TH11色号越界')
    end
end
local function sprite(b,kind,color,birth)
    local p=assert(profiles[kind],'TH11弹型不存在：'..kind)
    b.kind,b.color=kind,color
    b.vm=A.new(11,'bullet',p.script,nil,resolver(b))
    A.interrupt(b.vm,birth or 2);A.step(b.vm)
    b.a,b.b,b.rect=p.radius,p.radius,true
    b.imgclass={native_game=11,native_type=kind,native_profile={w=p.radius*2,h=p.radius*2}}
end
local function fade(b)
    if b.fading then return end
    b.fading=true;b.colli=false
    A.interrupt(b.vm,1);A.step(b.vm)
end
local function outside(b)
    local s=b.vm.data.sprites[b.vm.sprite]
    local w,h=s and s[4]*math.abs(b.vm.scale[1])/2 or 16,s and s[5]*math.abs(b.vm.scale[2])/2 or 16
    return b.x+w< -192 or b.x-w>192 or 224-b.y+h<0 or 224-b.y-h>448
end
local bullet_class
local function advance(b)
    local consumed=0
    while b.pc<18 do
        consumed=consumed+1;assert(consumed<200,'TH11零帧弹变换循环')
        local r=b.ex[b.pc]
        if not r or r.kind==0 or r.allow==0 and next(b.active) then return end
        b.pc=b.pc+1
        local k=r.kind
        if k==1 then b.active.decel={t=0}
        elseif k==4 then
            local angle=r.f1<=-990 and b.angle or r.f1>=990 and aim(b.x,224-b.y) or r.f1
            b.active.vector={t=0,limit=r.i0,x=math.cos(angle)*r.f0,y=math.sin(angle)*r.f0,acc=r.f0}
        elseif k==8 then b.active.polar={t=0,limit=r.i0,acc=r.f0,omega=r.f1}
        elseif k==16 or k==32 or k==64 then
            b.active.direction={t=0,limit=r.i0,n=r.i1,count=0,mode=k,
                angle=r.f0<=-990 and b.angle or r.f0>=990 and aim(b.x,224-b.y) or r.f0,
                speed=r.f1> -999 and r.f1 or b.speed}
        elseif k==256 then b.active.bounce={count=0,n=r.i0,speed=r.f0,mask=r.i1}
        elseif k==512 then b.protect=r.i0
        elseif k==1024 then b.cull=r.i0
        elseif k==2048 or k==16777216 then sprite(b,r.i0,r.i1);if k==16777216 then b.birth=0 end
        elseif k==4096 then b.active.wait={left=r.i0}
        elseif k==8192 then fade(b)
        elseif k==524288 then
            -- 0x409b9d把本条及下一条组合成一个新枪包，并继承后续变换程序。
            local next_record=assert(b.ex[b.pc],'TH11分裂枪缺少第二条记录')
            local packed=r.i0
            local p={type=band(math.floor(packed/65536),255),color=H.int(band(math.floor(packed/256),255)),
                n=r.i1,layers=band(next_record.i0,65535),aim=band(math.floor(packed/16777216),127),
                angle=next_record.f0,step=next_record.f1,s1=r.f0,s2=r.f1,ox=0,oy=0,dist=0,ex=copy(b.ex),start=b.pc+1}
            if p.color>=128 then p.color=p.color-256 end
            H.emit_pattern(b.session,p,b.x,224-b.y)
            b.pc=b.pc+1
            if band(packed,0x80000000)~=0 then fade(b) end
        elseif k==4194304 then b.pc=r.i0
        elseif k==33554432 then
            local x,y=r.f0,r.f1
            if band(r.i1,256)~=0 then x,y=x+b.x,y+224-b.y end
            b.active.position={t=0,limit=r.i0,mode=band(r.i1,255),x=b.x,y=224-b.y,tx=x,ty=y,speed=b.speed}
        elseif k==67108864 then
            if r.f0>=990 then b.angle=H.angle(aim(b.x,224-b.y)+r.f0-999)
            elseif r.f0>=-990 then b.angle=r.f0 end
            if r.f1>=-990 then b.speed=r.f1 end;velocity(b)
        elseif k==134217728 then
            b.active.extra_velocity={t=0,limit=r.i0,x=math.cos(r.f0)*r.f1,y=math.sin(r.f0)*r.f1}
        elseif k==268435456 then b.vm.secondary=r.i0~=0
        elseif k==2147483648 or k==2 or k==1048576 then
            -- 2的出生分支在生成阶段执行；0x100000只供前一条分裂枪读取。
        else error('TH11尚未映射的弹变换：'..k) end
    end
end
local function tick_transform(b)
    local a=b.active
    b.extra_x,b.extra_y=0,0
    if a.decel then
        local s=a.decel
        if s.t<=16 then local v=5-s.t*0.3125+b.speed;b.mx,b.my=math.cos(b.angle)*v,math.sin(b.angle)*v else a.decel=nil end
        s.t=s.t+1
    end
    if a.vector then
        local s=a.vector
        if s.t<s.limit then
            b.speed=H.f32(b.speed+s.acc);b.mx,b.my=H.f32(b.mx+s.x),H.f32(b.my+s.y)
            if math.abs(b.mx)>.0001 or math.abs(b.my)>.0001 then b.angle=math.atan2(b.my,b.mx) end
        else a.vector=nil end;s.t=s.t+1
    end
    if a.polar then
        local s=a.polar
        if s.t<s.limit then b.speed=H.f32(b.speed+s.acc);b.angle=H.angle(b.angle+s.omega);velocity(b) else a.polar=nil end;s.t=s.t+1
    end
    if a.direction then
        local s=a.direction;local speed
        if s.t>=s.limit then
            s.count=s.count+1;if s.count>=s.n then a.direction=nil end
            b.angle=H.angle(s.mode==16 and b.angle+s.angle or s.mode==32 and aim(b.x,224-b.y)+s.angle or s.angle)
            b.speed=s.speed;speed=b.speed;s.t=0
        else speed=b.speed*(1-s.t/s.limit) end
        b.mx,b.my=math.cos(b.angle)*speed,math.sin(b.angle)*speed;s.t=s.t+1
    end
    if a.bounce then
        local s=a.bounce;local x,y=b.x,224-b.y;local hit=false
        if x< -192 and band(s.mask,4)~=0 or x>=192 and band(s.mask,8)~=0 then b.x=x< -192 and -384-x or 384-x;b.angle=H.angle(-b.angle-PI);hit=true end
        if y<0 and band(s.mask,1)~=0 or y>=448 and band(s.mask,2)~=0 then b.y=224-(y<0 and -y or 896-y);b.angle=-b.angle;hit=true end
        if hit then s.count=s.count+1;if s.speed> -990 then b.speed=s.speed end;velocity(b) end
        if s.count>=s.n then a.bounce=nil end
    end
    if a.wait then a.wait.left=a.wait.left-1;if a.wait.left<0 then a.wait=nil end end
    if a.position then
        local s=a.position;s.t=s.t+1;local u=H.ease(s.mode,math.min(1,s.t/math.max(1,s.limit)))
        local x,y=s.x+(s.tx-s.x)*u,s.y+(s.ty-s.y)*u
        b.mx,b.my=x-b.x,y-(224-b.y)
        if s.t>=s.limit then a.position=nil;b.speed=s.speed;velocity(b) end
    end
    if a.extra_velocity then
        local s=a.extra_velocity
        if s.t<s.limit then b.extra_x,b.extra_y=s.x,s.y else a.extra_velocity=nil end
        s.t=s.t+1
    end
end
bullet_class=Class(object,{
    init=function(b,session,p,x,y,angle,speed,slot)
        b.session=session;b.x,b.y=x,224-y;b.angle,b.speed=angle,speed;b.slot=slot
        -- 出生变换可以当场分裂；先占槽，递归发弹才不会覆盖尚未返回的这颗。
        session.bullets[slot]=b;session.bullet_cursor=slot%2000+1
        b.ex=copy(p.ex);b.pc=p.start or 0;b.active={};b.cull=10;b.protect=0
        b.bound,b.colli,b.group,b.layer=false,false,GROUP.ENEMY_BULLET,LAYER.ENEMY_BULLET
        b.vx,b.vy=0,0;b._original_collision_game=11
        velocity(b)
        local first=p.ex[0];local birth=first and first.kind==2 and first.i0+7
        b.birth=birth and ({[7]=8,[8]=15,[9]=25})[birth] or 0
        sprite(b,p.type,p.color,birth)
        if b.birth>0 then b.x,b.y=b.x-b.mx*4,b.y+b.my*4 end
        advance(b)
    end,
    frame=function(b)
        b.vx,b.vy=0,0
        if b.session.done and not b.fading then fade(b) end
        if b.fading then
            b.x,b.y=b.x+b.mx/2,b.y-b.my/2;A.step(b.vm)
            if b.vm.finished then object.RawDel(b) end;return
        end
        local dx,dy=0,0
        if b.birth>0 then dx,dy=b.mx*.5,b.my*.5;b.birth=b.birth-1 end
        if b.birth==0 then advance(b);tick_transform(b);dx,dy=dx+b.mx,dy+b.my end
        b.colli=b.birth==0 and not b.fading
        b.x,b.y=H.f32(b.x+dx+(b.extra_x or 0)),H.f32(b.y-dy-(b.extra_y or 0))
        b.rot=-math.deg(b.angle)
        A.step(b.vm)
        if b.cull<=0 and outside(b) then b._original_silent_remove=true;object.RawDel(b);return end
        b.cull=b.cull-1;b.protect=math.max(0,b.protect-1)
    end,
    render=function(b) A.draw(b.vm,b.x,b.y,-math.deg(b.angle)-90) end,
    kill=function(b) object.Preserve(b);fade(b) end,
    del=function(b) if not b._original_silent_remove and not b.fading then object.Preserve(b);fade(b) end end,
},true)
class.bullet=bullet_class
local function free_slot(s)
    for scanned=0,1999 do local i=((s.bullet_cursor or 1)+scanned-1)%2000+1
        if not s.bullets[i] or not IsValid(s.bullets[i]) then return i end
    end
end
function H.emit_pattern(s,p,x,y)
    local a2p=aim(x,y)
    for layer=0,p.layers-1 do for i=0,p.n-1 do
        local slot=free_slot(s);if not slot then return end
        local speed=p.layers>1 and p.s1-(p.s1-p.s2)*layer/p.layers or p.s1
        local angle=p.angle;local mode=p.aim
        if mode==0 or mode==1 then
            local spread=p.n%2~=0 and math.floor((i+1)/2)*p.step or math.floor(i/2)*p.step+p.step/2
            angle=angle+(i%2==0 and spread or -spread)+(mode==0 and a2p or 0)
        elseif mode>=2 and mode<=5 then angle=angle+i*TAU/p.n+layer*p.step+(mode>=4 and PI/p.n or 0)+((mode==2 or mode==4) and a2p or 0)
        elseif mode==6 then angle=H.random(s,p.step,p.angle)
        elseif mode==7 then angle=angle+i*TAU/p.n+layer*p.step;speed=H.random(s,p.s2,p.s1)
        elseif mode==8 then angle=H.random(s,p.step,p.angle);speed=H.random(s,p.s2,p.s1)
        else error('TH11未知发弹模式：'..mode) end
        angle=H.angle(angle)
        local bx,by=H.f32(x+math.cos(angle)*(p.dist or 0)),H.f32(y+math.sin(angle)*(p.dist or 0))
        -- 原版0x409386在极坐标偏移之后逐颗检查etProtectRange；忠实保留原作保护条件。
        if not p.protect or p.protect<=0 or (player.x-bx)^2+(224-player.y-by)^2>=p.protect*p.protect then
            local b=New(bullet_class,s,p,bx,by,angle,H.f32(speed),slot)
            s.bullets[slot]=b;s.bullet_cursor=slot%2000+1
            if H.on_bullet then H.on_bullet(s,p,b) end
        end
    end end
end
function H.fire(a,i)
    local p=gun(a,i);local x,y=origin(a,p)
    p.protect=a.protect
    H.emit_pattern(a.session,p,x,y)
    if H.on_fire then H.on_fire(a,i,p,x,y) end
end
function H.cancel(a,radius,drop)
    for _,b in pairs(a.session.bullets) do
        if IsValid(b) and not b.fading and b.protect<=0 and (b.x-a.o.x)^2+(b.y-a.o.y)^2<radius^2 then fade(b) end
    end
    for _,l in pairs(a.session.lasers) do if IsValid(l) then object.Del(l) end end
end
-- 直线激光用THlib的判定和绘制对象，枪位置/角度/寿命由原作字段直接驱动。
local laser_class=Class(laser,{
    init=function(o,session,params)
        o.params=params;o.session=session;o.age=0
        laser.init(o,params.color+1,params.x,224-params.y,-math.deg(params.angle),0,params.initial,0,params.width,0,0,0)
        o.bound=false;o._native_laser_managed=11
        o.colli=false;o.alpha=1;o.length=params.initial;o.traveled=0
        o.angle,o.speed=params.angle,params.speed;o.ex=copy(params.ex or {});o.pc=0;o.active={};o.cull=10;o.protect=0;o.birth=0
        velocity(o);sprite(o,params.type,params.color);o.group=GROUP.LASER
        o.state=params.stationary and 3 or 1;o.state_time=0
        advance(o)
    end,
    frame=function(o)
        local p=o.params;o.age=o.age+1
        advance(o);tick_transform(o);p.angle=o.angle;o.rot=-math.deg(o.angle)
        if o.fading then object.RawDel(o);return end
        local active,width=true,p.width
        if p.stationary then
            o.length=math.min(p.maximum,o.length+8)
            local t=o.state_time
            if o.state==3 then if t>=p.warn then o.state,t=4,0 end
            elseif o.state==4 then if t>=p.grow then o.state,t=2,0 else width=p.width*t/p.grow end end
            if o.state==2 and t>=p.life then o.state,t=5,0 end
            if o.state==5 then if t>=p.fade then object.RawDel(o);return end;width=p.width*(1-t/p.fade) end
            active=o.state==4 or o.state==2
            if o.state==3 then width=2 end
            o.state_time=t+1
        elseif o.length<p.maximum then o.length=math.min(p.maximum,o.length+o.speed)
        else
            o.traveled=o.traveled+o.speed;o.x,o.y=o.x+o.mx,o.y-o.my
            if p.terminal>0 and o.traveled+o.length>p.terminal then
                o.length=math.max(0,p.terminal-o.traveled);p.maximum=o.length
                if o.length<=0 then object.RawDel(o);return end
            end
        end
        o.vx,o.vy=0,0
        local x,y=o.x,o.y;local co,si=math.cos(o.angle),math.sin(o.angle)
        local hx,hy=x+co*o.length,y-si*o.length
        if not p.stationary and o.age>30 and (x<-224 or x>224 or y<-256 or y>256) and (hx<-224 or hx>224 or hy<-256 or hy>256) then object.RawDel(o);return end
        o.x,o.y=x+co*o.length*.1,y-si*o.length*.1
        o.l1,o.l2,o.l3=0,o.length*.8,0;o.w=width*.5
        o.colli=active and o.length>16 and (not p.stationary or width>3)
        laser.frame(o)
        o.x,o.y=x,y;o.w=width;A.step(o.vm)
    end,
    render=function(o)
        local spr=o.vm.data.sprites[o.vm.sprite]
        if not spr or o.length<=0 then return end
        A.draw(o.vm,o.x+math.cos(o.angle)*o.length/2,o.y-math.sin(o.angle)*o.length/2,
            -math.deg(o.angle)-90,o.w/spr[4],o.length/spr[5],o.alpha,o.hypno_blocked and {255,64,64} or nil,nil,-math.deg(o.angle)-90)
    end,
    del=function(o) end,
    kill=function(o) end,
})
class.laser=laser_class
function H.laser(a,op,...)
    local x={...};local p=gun(a,0);local sx,sy=origin(a,p)
    local meta
    if op==412 or op==431 then
        meta={type=x[1],color=x[2],angle=x[3],speed=x[4],initial=x[5],maximum=x[6],terminal=x[7],width=x[8],x=sx,y=sy}
    elseif op==413 then
        meta={type=x[2],color=x[3],angle=x[4],speed=0,initial=x[5],maximum=x[6],warn=x[7],grow=x[8],life=x[9],fade=x[10],width=x[11],x=sx,y=sy,id=x[1],stationary=true}
    else meta={type=x[1],color=x[2],angle=x[3],speed=x[4],initial=x[5],maximum=x[6],terminal=x[7],width=x[8],x=sx,y=sy} end
    if op==431 or op==433 then meta.ex=p.ex end
    local slot
    for i=1,256 do if not a.session.lasers[i] or not IsValid(a.session.lasers[i]) then slot=i;break end end
    if not slot then return end
    local o=New(laser_class,a.session,meta);a.session.lasers[slot]=o
    if H.on_laser then H.on_laser(a,op,x,o) end
    return o
end
function H.laser_clear_id(a,id)
    for _,l in ipairs(a.session.lasers) do if IsValid(l) and l.params.id==id then object.Del(l) end end
end
H.projectile_profiles=profiles
H.projectile_advance=advance
H.projectile_tick=tick_transform
H.projectile_fade=fade
H.projectile_sprite=sprite
