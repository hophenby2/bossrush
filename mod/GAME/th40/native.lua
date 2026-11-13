-- 夏夜祭原生对象：参数和事件条件由离线编译器展开为Lua函数。
-- 差异1：原Direct3D曲线网格由LuaSTG原生laser/bent_laser代理，沿用采样数、长度与宽度参数。
-- 差异2：3D蓄力/放能特效以无判定原图粒子代理；不增加原作没有的攻击。
local N={patterns={},images={},loaded=false}
local paths=dofile('mod/GAME/th40/patterns.lua')
local Class,New,IsValid=Class,New,IsValid
local object,bullet,enemy,laser,bent_laser=object,bullet,enemy,laser,bent_laser
local sin,cos,atan2,sqrt,pi=math.sin,math.cos,math.atan2,math.sqrt,math.pi
local min,max,floor,abs=math.min,math.max,math.floor,math.abs
local R=pi/180
local function clamp(x,a,b) return max(a,min(b,x)) end
local function copy(t) local o={};for k,v in pairs(t or {}) do o[k]=v end;return o end
local function valid(o) return o and not o.th38_removed and (o.th38_host and IsValid(o.owner) or not o.th38_host and IsValid(o)) end
local function erase(o) if o and not o.th38_removed then o.th38_removed=true;object.RawDel(o) end end
-- System.Random的56槽减法发生器，对齐原MyRandom；不使用math.random的全局流。
function N.random(seed)
    local s={};local k=161803398-abs(seed%2147483647);s[55]=k;local n=1
    for i=1,54 do local j=21*i%55;s[j]=n;n=k-n;if n<0 then n=n+2147483647 end;k=s[j] end
    for _=1,4 do for i=1,55 do s[i]=s[i]-s[1+(i+30)%55];if s[i]<0 then s[i]=s[i]+2147483647 end end end
    return {state=s,i=0,j=21}
end
local function random(run)
    local s=run.random;s.i=s.i%55+1;s.j=s.j%55+1
    local n=s.state[s.i]-s.state[s.j];if n==2147483647 then n=n-1 end;if n<0 then n=n+2147483647 end;s.state[s.i]=n
    return n/2147483647
end
function N.pm(run) return 2*random(run)-1 end
local function integer(run,a,b) return a+floor(random(run)*(b-a)) end
local function normalize(a) local n=a%360;return n==0 and a>0 and 360 or n end
function N.player_x() return (player and player.x or 0)+320 end
function N.player_y() return 240-(player and player.y or -160) end
function N.aim(o) return math.deg(pi+atan2(o.cy-N.player_y(),o.cx-N.player_x())) end
function N.self_angle(o) return math.deg(atan2(16,-4)) end
local function defaults(o)
    o.age=o.age or 0;o.speed=o.speed or 0;o.direction=o.direction or 0;o.accel=o.accel or 0;o.accel_angle=o.accel_angle or 0
    o.scale_x=o.scale_x or 1;o.scale_y=o.scale_y or 1;o.width=o.width or 1;o.height=o.height or 1
    o.alpha=o.alpha or 255;o.angle=o.angle or 0;o.red=o.red or 255;o.green=o.green or 255;o.blue=o.blue or 255
    if o.follow==nil then o.follow=true end
    o.loops={};o.once={};o.tweens={};o.cx=o.cx or 320;o.cy=o.cy or 240;o.vx,o.vy=0,0;o.bound=false
end
function N.tween(o,target,key,value,change,curve,time,origin)
    o.tweens[#o.tweens+1]={target=target,key=key,value=value,change=change,curve=curve,time=max(1,time),left=max(1,time),origin=origin or target[key] or 0}
end
local function updateTweens(o)
    local count,write=#o.tweens,0
    for i=1,count do
        local e=o.tweens[i];local old=e.target[e.key];if old==nil then old=0 end;local value
        if type(old)=='boolean' then value=e.value>0
        elseif e.curve==0 then value=e.change==0 and (old*(e.left-1)+e.value)/e.left or old+(e.change==1 and 1 or -1)*e.value/e.time
        elseif e.curve==1 then value=e.change==0 and e.value or old+(e.change==1 and 1 or -1)*e.value
        else value=e.origin+(e.change==0 and (e.value-e.origin) or (e.change==1 and e.value or -e.value))*sin(2*pi/e.time*(e.time-e.left)) end
        if type(old)=='boolean' then value=e.value>0 end
        if e.key=='red' or e.key=='green' or e.key=='blue' then value=clamp(floor(value),0,255)
        elseif e.key=='alpha' then value=clamp(value,0,255)
        elseif e.key=='width' or e.key=='height' then value=clamp(value,.0001,e.target[e.key=='width' and 'max_width' or 'max_height'] or 100)
        elseif e.key=='cycle' or e.key=='ways' or e.key=='life' or e.key=='type' then value=value<0 and math.ceil(value) or floor(value) end
        e.target[e.key]=value;if e.key=='out' and value==false then e.target.outside=200 end;e.left=e.left-1
        if e.left~=(e.curve==2 and -1 or 0) then write=write+1;o.tweens[write]=e end
    end
    for i=write+1,count do o.tweens[i]=nil end
end
local function sync(o)
    o.x,o.y=o.cx-320,240-o.cy;o.rot=-(o.follow and o.direction+o.angle-90 or o.angle-90)
    o.hscale,o.vscale=o.width,o.height;o.vx,o.vy=0,0
    if o.emitter and o.mode=='cover' then o.follow=o.round end
end
local function motion(o)
    if o.dest then
        local dx,dy=o.dest[1]-o.cx,o.dest[2]-o.cy;local d=sqrt(dx*dx+dy*dy)
        if d>abs(o.speed) then o.direction=math.deg(pi+atan2(-dy,-dx));o.drag=-o.speed*o.speed/(2*d);if o.speed<0 then o.speed=0 end
        else o.drag=0;o.speed=0 end
    end
    o.cx=o.cx+o.speed*cos(o.direction*R)*o.scale_x;o.cy=o.cy+o.speed*sin(o.direction*R)*o.scale_y
    local parent=o.parent
    if valid(parent) then
        local last=o.parent_last or {parent.cx,parent.cy,parent.angle,parent.direction}
        local dx,dy=o.cx-last[1],o.cy-last[2];local angle=((parent.angle or 0)-last[3])+((parent.follow and parent.direction or 0)-(parent.follow and last[4] or 0))
        o.cx=parent.cx+dx*cos(angle*R)-dy*sin(angle*R);o.cy=parent.cy+dx*sin(angle*R)+dy*cos(angle*R);o.direction=o.direction+angle
        o.parent_last={parent.cx,parent.cy,parent.angle or 0,parent.direction or 0}
    end
    local ax,ay=o.frame_ax or o.accel*cos(o.accel_angle*R),o.frame_ay or o.accel*sin(o.accel_angle*R)
    if ax~=0 or ay~=0 then
        local v,d=o.speed,o.direction*R
        o.speed=clamp(sqrt(max(0,v*v+ax*ax+ay*ay+2*v*ax*cos(d)+2*v*ay*sin(d))),-100,100)
        o.direction=math.deg(atan2(v*sin(d)+ay,v*cos(d)+ax))
    end
    o.speed=clamp(o.speed+(o.drag or 0),-100,100);o.direction=normalize(o.direction);o.angle=normalize(o.angle+(o.spin or 0))
    sync(o)
end
local function cull(o)
    if o.life and o.life~=0 and o.age>o.life then erase(o);return true end
    if o.mode=='ray' then return false end
    if (o.reflect or 0)>0 then
        if o.cx<128 then o.reflect=o.reflect-1;o.direction=180-o.direction;o.cx=256-o.cx
        elseif o.cx>=512 then o.reflect=o.reflect-1;o.direction=180-o.direction;o.cx=1024-o.cx end
        if o.cy<36 and o.reflect>0 then o.reflect=o.reflect-1;o.direction=-o.direction;o.cy=52-o.cy end
        sync(o);return false
    end
    if o.age<100 then return false end
    local m=(o.mode=='laser' or o.mode=='bend') and 10 or max(20,floor((o.out==false and 200 or o.outside or 3)*o.height*2))
    local outside=o.cx<=128-m or o.cx>=512+m or o.cy<=16-m or o.cy>=464+m
    if outside and o.history and #o.history>0 then
        local p=o.history[#o.history];outside=p[1]<=-192-m or p[1]>=192+m or p[2]<=-224-m or p[2]>=224+m
    end
    if outside then erase(o);return true end
    return false
end
local function image(o)
    local name=o.texture
    if o.mode=='enemy' then
        name=o.enemy or 'EnemyA0'
        if name:find('MaoYu',1,true) then name=name
        elseif name:find('YYY',1,true) then name=name..'_1'
        elseif name:find('Ghost',1,true) then name=name..'_'..(floor(o.age/4)%8)
        else name=name..'_'..(floor(o.age/6)%4) end
    elseif o.mode=='bullet' then name=name or N.bullet_names[o.type or 0];if not name then return 'img_void' end end
    return N.images[name] or 'ball_mid1'
end
local function draw(o)
    if not o.emitter then
        local img=image(o);SetImageState(img,o.blend and 'mul+add' or '',clamp(o.alpha,0,255),clamp(o.red,0,255),clamp(o.green,0,255),clamp(o.blue,0,255))
        Render(img,o.x,o.y,o.rot,o.width,o.height)
    end
end
local Point=Class(bullet,{init=function(o,run,data) o.run=run;for k,v in pairs(data) do o[k]=v end;defaults(o);o.group=GROUP.ENEMY_BULLET;o.layer=LAYER.ENEMY_BULLET;o.colli=true;o.a,o.b=2,2;sync(o) end,
    frame=function() end,render=draw,kill=function(o) erase(o) end,del=function(o) erase(o) end})
local Ghost=Class(object,{init=function(o,run,data) o.run=run;for k,v in pairs(data) do o[k]=v end;defaults(o);o.group=GROUP.GHOST;o.layer=LAYER.ENEMY_BULLET-5;o.colli=false;sync(o) end,frame=function() end,render=draw,kill=function(o) erase(o) end,del=function(o) erase(o) end})
local Enemy=Class(enemy,{init=function(o,run,data)
    enemy.init(o,1,data.hp or 1,false,false,false)
    o.run=run;for k,v in pairs(data) do o[k]=v end;defaults(o);o.group=GROUP.ENEMY;o.colli=true
    local name=o.enemy or '';local radius=name:find('MaoYu',1,true) and 6 or name:find('YYY',1,true) and 8 or ({EnemyA8=true,EnemyB1=true,EnemyC2=true,EnemyC3=true})[name] and 10 or 3
    if data.region and data.region~=0 then radius=data.region end
    o.a,o.b=radius*o.width,radius*o.height;sync(o)
end,frame=function() end,render=draw,kill=function(o)
    if N.enemyDeath then N.enemyDeath(o) end
    if NativePlayers and NativePlayers.enabled(nil,38) then
        for _,kind in ipairs({'red','blue','green'}) do
            local amount=o[kind..'_drop'] or 0
            if amount>0 then NativePlayers.pickup(o.x,o.y,kind,amount) end
        end
    elseif item and item.DropItem then item.DropItem(o.x,o.y,{o.red_drop or 0,o.blue_drop or 0,o.green_drop or 0}) end
    erase(o)
end,del=function(o) erase(o) end})
local laserColors={1,3,5,7,9,13,14,15}
local Line=Class(laser,{init=function(o,run,data)
    laser.init(o,laserColors[(data.type or 0)+1] or 1,0,0,0,0,32,0,16,0,0);o.run=run;for k,v in pairs(data) do o[k]=v end;defaults(o);o.bound=false;o.colli=true;sync(o)
    o.history={};if o.mode~='ray' then for i=1,max(1,o.length or 30) do o.history[i]={o.x,o.y} end end
end,frame=function() end})
local Curve=Class(bent_laser,{init=function(o,run,data)
    bent_laser.init(o,laserColors[(data.type or 0)+1] or 1,0,0,max(2,data.length or 30),16,4,0);o.run=run;for k,v in pairs(data) do o[k]=v end;defaults(o);o.bound=false;o.colli=true;o.sample=4;sync(o)
    o.history={};for i=1,max(1,o.length or 30) do o.history[i]={o.x,o.y} end
end,frame=function() end})
Line.render=function(o)
    local img=N.images['Laser0_'..(laserColors[(o.type or 0)+1] or 1)]
    if img then
        SetImageState(img,o.blend and 'mul+add' or '',o.alpha,o.red,o.green,o.blue)
        local d=o.rot*R;Render(img,o.x+o.l2*cos(d)/2,o.y+o.l2*sin(d)/2,o.rot,o.l2/256,o.height)
    end
end
Curve.render=function(o)
    local a=o.alpha;o.alpha=a/255;o.index=laserColors[(o.type or 0)+1] or 1
    o._r,o._g,o._b=o.red,o.green,o.blue
    -- 原曲线纹理为16*ScaleLength宽，碰撞半径为1*ScaleLength；渲染后恢复碰撞宽度。
    o.data:SetAllWidth(16*o.height);bent_laser.render(o);o.data:SetAllWidth(o.w);o.alpha=a
end
N.classes={point=Point,emitter=Ghost,enemy=Enemy,ghost=Ghost,line=Line,curve=Curve}
local function bulletRegion(o)
    if o.mode=='laser' or o.mode=='bend' or o.mode=='ray' then o.region=o.mode=='ray' and 3 or 1;o.colli=o.age>=(o.mode=='ray' and 60 or 9);return end
    local name=N.bullet_names[o.type or 0] or '';local kind=tonumber(name:match('bullet(%d+)'))
    o.outside=3;o.region=({[0]=1,[1]=1,[2]=2,[3]=2,[4]=1,[5]=1,[6]=1,[7]=1,[8]=1,[9]=1,[10]=2,[11]=2,[12]=1,[13]=3,[15]=1,[20]=6,[21]=6,[22]=3,[23]=3,[24]=3,[26]=16,[40]=6,[46]=1,[50]=12,[61]=2})[kind] or 3
    if kind==26 then o.spin=10;o.outside=32 elseif kind==40 then o.outside=32 elseif kind==50 then o.outside=64 end
    if o.mode=='bullet' and not N.bullet_names[o.type or 0] and not o.texture then o.region=-100 end
    if o.region_override and o.region_override~=0 then o.region=o.region_override end
    o.a,o.b=abs(o.region*o.width),abs(o.region*o.height);o.colli=o.region>=0 and o.age>=9
    if o.invincible then o.group=GROUP.INDES end
end
local function spawn(run,data,emitter)
    local d=copy(data);d.p=copy(data.p);d.emitter=emitter
    if emitter and d.life==nil then d.life=0 end
    local cls=emitter and Ghost or d.mode=='enemy' and Enemy or (d.mode=='effect' and Ghost or d.mode=='bend' and Curve or (d.mode=='laser' or d.mode=='ray') and Line or Point)
    local o=New(cls,run,d);o.p.events=data.p and data.p.events;o.origin=data;o.controller=data.controller
    if emitter and d.mode=='cover' then o.cover_events=o.p.events;o.p=o;o.angle=90;o.coverloops={};o.coveronce={} end
    run.objects[#run.objects+1]=o
    if emitter then run.enemies[#run.enemies+1]=o elseif d.mode=='enemy' then run.enemies[#run.enemies+1]=o elseif d.mode=='effect' then run.effects[#run.effects+1]=o else run.bullets[#run.bullets+1]=o;bulletRegion(o) end
    return o
end
local update
function N.enemyDeath(o)
    if (o.enemy or ''):find('Ghost',1,true) then
        local color=(tonumber(o.enemy:match('(%d+)$')) or 0)*3+2
        for i=0,7 do for j=0,4 do
            local b=spawn(o.run,{mode='bullet',cx=o.cx,cy=o.cy,speed=1.5+j*.4,direction=N.aim(o)+i*45,texture='bullet2_'..color,region_override=2,type=0,life=0,width=1,height=1,p={}},false)
            b.region_override=2;bulletRegion(b)
        end end
    end
    if (o.clear_radius or 0)>0 then
        for _,b in ipairs(o.run.bullets) do if (b.cx-o.cx)^2+(b.cy-o.cy)^2<o.clear_radius^2 then erase(b) end end
    end
end
local function bind(o,parent)
    o.parent=parent;o.parent_last=nil;update(o)
end
local function r(o,key) return (o.random and o.random[key] or 0)*N.pm(o.run) end
function N.emit(o)
    local run=o.run;local fx,fy=o.fx,o.fy
    fx=fx==-99999 and N.player_x() or fx==-99998 and o.cx or fx or o.cx
    fy=fy==-99999 and N.player_y() or fy==-99998 and o.cy or fy or o.cy
    if o.mode=='laser' or o.mode=='ray' or o.mode=='bend' then fx,fy=o.cx,o.cy end
    fx,fy=fx+r(o,'x'),fy+r(o,'y')
    local direction=(o.emit_angle==-99999 and N.aim(o) or o.emit_angle)+r(o,'emit_angle')+r(o,'p.direction')
    local radius_angle=(o.radius_angle==-99999 and N.aim(o) or o.radius_angle)+r(o,'radius_angle')
    local radius=o.radius+r(o,'radius');local ways
    local randomWays=r(o,'ways');ways=o.ways+(randomWays<0 and math.ceil(randomWays) or floor(randomWays))
    local speed=o.p.speed+r(o,'p.speed');local acceleration=o.p.accel+r(o,'p.accel')
    local acc_angle=o.p.accel_angle+(o.random and o.random['p.accel_angle'] or 0)
    local spread=o.spread+r(o,'spread');if o.radius_follows then radius_angle=radius_angle+direction end
    local step=ways>0 and spread/ways or 0;direction=direction-(ways-1)*step/2;radius_angle=radius_angle-(ways-1)*step/2
    if o.effect==2 or o.effect==3 then
        -- 原3D能量特效以原图无判定粒子代理，保留触发时刻。
        local e=spawn(run,{mode='effect',texture=o.effect==2 and '光点' or 'FY_Particle4_0',cx=fx,cy=fy,life=60,width=1,height=1,alpha=180,blend=true},false)
        e.events=function(v,t) v.width=1+t/30;v.height=v.width;v.alpha=max(0,180-t*3) end
        return
    end
    for i=1,ways do
        local x,y=fx+radius*cos(radius_angle*R),fy+radius*sin(radius_angle*R)
        for j=0,(o.count or 1)-1 do
            local data=copy(o.p);data.p={};data.cx,data.cy=x,y;data.mode=o.mode;data.id,data.layer=o.id,o.layer;data.speed=speed-j*(o.delta_v or 0);data.direction=direction;data.accel,data.accel_angle=acceleration,acc_angle;data.controller=o.controller
            if o.mode=='enemy' then data.life=0 end
            data.angle=(data.angle or 0)+((o.mode=='bullet' or o.mode=='effect') and r(o,'p.angle') or 0)
            local b=spawn(run,data,false);b.events=o.p.events;b.region_override=o.p.region
            if o.motion then bind(b,o) end
            if o.mode=='bullet' or o.mode=='enemy' then
                for _,child in ipairs(o.controller.data.emitters) do
                    if child.bind==o.id then
                        local e=spawn(run,child,true);e.controller=o.controller;e.cx,e.cy=x,y;e.life=o.p.life;e.direction=direction;e.out=o.p.out
                        b.invincible=true;b.group=GROUP.INDES
                        if e.with_direction and o.mode=='bullet' then e.emit_angle=e.emit_angle+direction end
                        bind(e,b)
                        if e.with_direction and o.mode=='enemy' then e.emit_angle=e.emit_angle+direction end
                        if not e.deep then e.age=o.age;e.life=min(o.p.life+o.age,e.start+e.duration) end
                    end
                end
            end
        end
        radius_angle=radius_angle+step;direction=direction+step
    end
    local sound=o.specify_sound and o.sound or o.mode=='bullet' and 'se_tan00a.wav' or (o.mode=='laser' or o.mode=='ray') and 'se_lazer00.wav'
    if sound and N.sounds[sound] then PlaySound(N.sounds[sound],.2,clamp((o.cx-320)/192,-1,1)) end
end
update=function(o)
    if not valid(o) then return end
    if o.control then
        if o.born>=o.run.time then return end
        o.time=o.time+1;if o.time>=o.data.total then o.time=o.time-o.data.total end
        for _,e in ipairs(o.data.emitters) do
            if e.bind==-1 and e.start==o.time and not (o.on_road and o.run.road_blocked) then
                local child=spawn(o.run,e,true);child.controller=o
                if o.boss_bound and valid(o.run.owner) then child.cx=child.cx+o.run.host.cx-o.anchor[1];child.cy=child.cy+o.run.host.cy-o.anchor[2];child.fx,child.fy=-99998,-99998;bind(child,o.run.host) end
                child.age=o.time
            end
        end
        return
    end
    if o.emitter then
        if o.parent and o.parent.mode=='enemy' and o.parent.hp<=0 then erase(o);return end
        if o.age==o.start then o.speed=o.speed+r(o,'speed');o.direction=o.direction+r(o,'direction');o.accel=o.accel+r(o,'accel');o.accel_angle=o.accel_angle+r(o,'accel_angle') end
        o.life=min(o.life or 1e9,o.start+o.duration)
    end
    o.frame_ax,o.frame_ay=o.accel*cos(o.accel_angle*R),o.accel*sin(o.accel_angle*R)
    if o.events then
        if o.emitter and o.age<1 then o.age=1 end
        o.events(o,o.emitter and (o.age-o.start+1) or o.age,N)
    end
    updateTweens(o);o.age=o.age+1;motion(o)
    if o.emitter then
        if o.mode~='cover' and o.age>=o.start and o.age<=o.start+o.duration then
            local cycle=max(1,o.cycle+math.modf(r(o,'cycle')))
            if (o.deep and o.age or o.age-o.start+1)%cycle==0 then N.emit(o) end
        end
    elseif o.mode=='enemy' then
        if o.hp<=0 then object.Kill(o);return end
        if o.enemy:find('MaoYu',1,true) then o.angle=o.angle+15
        elseif o.enemy:find('YYY',1,true) then o.angle=o.angle+5
        else o.angle=90;o.follow=false end
        if o.enemy:find('Ghost',1,true) then
            local dx=integer(o.run,0,6)*sin(integer(o.run,0,360)*R)
            local dy=integer(o.run,0,6)*cos(integer(o.run,0,360)*R)
            local e=spawn(o.run,{mode='effect',texture=image(o):gsub('^th38%.',''),cx=o.cx+dx,cy=o.cy+dy,speed=1.5,direction=270,width=.5,height=.5,life=13,p={}},false)
            e.events=function(v) v.width=max(.0001,v.width-.04);v.height=v.width end
        end
        sync(o)
    elseif o.mode=='laser' or o.mode=='ray' then
        local p,dx,dy,length
        if o.mode=='ray' then
            if o.age>=60 then o.height=min(o.max_height or 1,o.height+.1) end
            if o.life and o.age>=o.life-8 then o.alpha=max(0,o.alpha-255/8);o.height=max(.0001,o.height-o.height/max(1,o.life-o.age+1)) end
            o.colli=o.age>=60;length=256*o.width;dx,dy=cos(-o.direction*R),sin(-o.direction*R);p={o.x,o.y}
        else
            table.insert(o.history,1,{o.x,o.y});if #o.history>max(1,o.length or 30) then table.remove(o.history) end
            p=o.history[#o.history];dx,dy=o.x-p[1],o.y-p[2];length=sqrt(dx*dx+dy*dy)
            o.colli=o.age>=9
        end
        o.x,o.y=p[1],p[2];o.rot=math.deg(atan2(dy,dx));o.l1,o.l2,o.l3=0,length,0;o.w=2*(o.mode=='ray' and 3 or 1)*o.height
        -- 原作透明度不控制激光生效；LuaSTG的alpha门限仅用于其自身预警系统。
        local alpha=o.alpha;o.alpha=1;laser.frame(o);o.alpha=alpha
    elseif o.mode=='bend' then
        table.insert(o.history,1,{o.x,o.y});if #o.history>max(1,o.length or 30) then table.remove(o.history) end
        local alpha=o.alpha;o.w=2*o.height;o.colli=o.age>=9;o.alpha=1;bent_laser.frame(o);o.alpha=alpha
    else bulletRegion(o) end
    cull(o)
end
function N.controller(o,path,bound,anchor)
    local data=N.patterns[path]
    if not data then data=dofile('mod/GAME/th40/p_'..assert(paths[path],'未编译的夏夜祭弹幕：'..path)..'.lua');N.patterns[path]=data end
    local c=New(Ghost,o.run,{cx=320,cy=240,control=true,emitter=true})
    c.data=data;c.time=0;c.boss_bound=bound;c.born=o.run.time
    c.anchor=type(anchor)=='table' and {anchor[1]+128,anchor[2]+16} or anchor=='current' and {o.cx,o.cy} or {320,146}
    c.owner=o;o.run.controllers[#o.run.controllers+1]=c;o.run.objects[#o.run.objects+1]=c;o.run.enemies[#o.run.enemies+1]=c
    return c
end
function N.road_controller(o,path,time) local c=N.controller(o,path,false);c.time=time;c.on_road=true;return c end
function N.bob(o,t,period)
    if abs(o.speed)<.01 then
        if t%period==0 then o.dest={o.dest[1],o.dest[2]+10};o.speed=.5
        elseif t%period==period/2 then o.dest={o.dest[1],o.dest[2]-10};o.speed=.5 end
    end
end
function N.wander(o,t,period,distance,speed,x,y,w,h)
    if t%period~=0 then return end
    for _=1,300 do
        local a=integer(o.run,0,360)*R;local px,py=o.cx+distance*sin(a),o.cy+distance*cos(a)
        if px>x+128 and px<x+w+128 and py>y+16 and py<y+h+16 then o.dest={px,py};o.speed=speed;return end
    end
end
function N.route(o)
    local name=lstg.var.th38_route or lstg.var.player_name or 'reimu_player'
    return name=='B' and 'B' or name=='C' and 'C' or name=='D' and 'D' or tostring(name):lower():find('marisa',1,true) and 'B' or 'A'
end
function N.clear(o)
    for _,obj in ipairs(o.run.objects) do erase(obj) end
    o.run.objects={};o.run.bullets={};o.run.enemies={};o.run.effects={};o.run.controllers={}
end
function N.clear_bullets(run)
    for _,b in ipairs(run.bullets) do erase(b) end;run.bullets={}
end
function N.step(run,hostUpdate)
    run.time=run.time+1
    local function each(list) for i=#list,1,-1 do if valid(list[i]) then update(list[i]) else table.remove(list,i) end end end
    each(run.enemies);each(run.bullets)
    if hostUpdate then hostUpdate() end
    each(run.effects)
    -- 原BaseCover_CS.HitCheckAll在弹更新后执行；遮罩只影响Cover=true的原弹。
    for _,o in ipairs(run.enemies) do
        if valid(o) and o.mode=='cover' and o.age>=o.start and o.age<=o.start+o.duration then
            for _,b in ipairs(run.bullets) do
                if valid(b) and b.cover~=false and (o.type==0 or b.id==o.control_id) then
                    local dx,dy=b.cx-o.cx,b.cy-o.cy;local hit
                    if o.round then
                        if o.width==o.height then hit=sqrt(dx*dx+dy*dy)-(b.region or 0)<o.width
                        else local a=(o.direction+o.angle)*R;local x,y=dx*cos(a)+dy*sin(a),dy*cos(a)-dx*sin(a);hit=x*x/(o.height*o.height)+y*y/(o.width*o.width)<1 end
                    else hit=abs(dx)<o.width and abs(dy)<o.height end
                    if hit and o.cover_events then
                        -- 子事件组属于遮罩实例，其loop/noloop不与弹本身的组共用。
                        local loops,once=b.loops,b.once;b.loops,b.once=o.coverloops,o.coveronce
                        o.cover_events(b,b.age,N);b.loops,b.once=loops,once
                    end
                end
            end
        end
    end
    if run.time%60==0 then local live={};for _,o in ipairs(run.objects) do if valid(o) then live[#live+1]=o end end;run.objects=live end
end
function N.new(owner,meta)
    local run={owner=owner,time=0,objects={},controllers={},enemies={},bullets={},effects={},random=lstg.tmpvar.th38_random or N.random(lstg.var.th38_seed or 0)}
    local host={run=run,th38_host=true,owner=owner,cx=(owner.x or 0)+320,cy=240-(owner.y or 100),speed=4,direction=0,accel=0,accel_angle=0,scale_x=1,scale_y=1,angle=90,follow=false,age=0,flag=1,hp=meta.hp,maxhp=meta.maxhp or meta.hp,dest={320,136},loopy={},once={},tweens={}}
    if meta.dest then host.dest={meta.dest[1]+128,meta.dest[2]+16} end
    host.loops={};run.host=host;owner.th38_run=run
    return run
end
function N.tick(owner,meta)
    local run=owner.th38_run;if not run then return end
    N.step(run,function()
        local o=run.host;o.age=o.age+1;o.hp=owner.hp or o.hp
        motion(o)
        if meta.step then meta.step(o,o.age,N) end
        if meta.kind~='road' then owner.x,owner.y=o.cx-320,240-o.cy end
    end)
end
function N.stop(owner) if owner.th38_run then N.clear(owner.th38_run.host);owner.th38_run=nil end end
function N.load()
    if N.loaded then return end;N.loaded=true;N.sounds={};N.bullet_names=dofile('mod/GAME/th40/bullet_names.lua')
    local textures={}
    for _,a in ipairs(dofile('mod/GAME/th40/atlas.lua')) do
        if not textures[a[2]] then local tex='th38.tex.'..a[2];LoadTexture(tex,a[2]);textures[a[2]]=tex end
        local id='th38.'..a[1];LoadImage(id,textures[a[2]],a[3],a[4],a[5],a[6],2,2);N.images[a[1]]=id
    end
end
N.update=update;N.spawn=spawn;N.sync=sync;N.motion=motion
return N
