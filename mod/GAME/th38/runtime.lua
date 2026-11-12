-- 雪莲华的原生对象后端。原作120Hz；每个LuaSTG帧推进两个原作tick。
-- Unity坐标中心(4.5,-4.8)，每单位48px；弹图按原100px/单位缩放。
-- 离线数值表来自Basic/Basic_zi/Bulletmove；游戏内不依赖Unity或外部txt。
local R={classes={},patterns={},objects=setmetatable({},{__mode='k'}),controllers=setmetatable({},{__mode='k'}),bulletCount=0,bulletLimit=1500}
R.data=dofile('mod/GAME/th38/catalogue.lua')
local abs,min,max,floor=math.abs,math.min,math.max,math.floor
local function valid(o) return o and IsValid(o) end
local function rnd(x) return x~=0 and ran:Float(-x,x) or 0 end
local function trunc(x) return x<0 and math.ceil(x) or floor(x) end
local function angle(x,y,tx,ty) return math.deg(math.atan2(ty-y,tx-x)) end
local function project(x,y) return (x-4.5)*48,(y+4.8)*48 end
R.project=project
function R.player() return valid(player) and player.x/48+4.5 or 4.5,valid(player) and player.y/48-4.8 or -8.5 end
local function aim(s,x) if x==-99999 then local px,py=R.player();return angle(s.x,s.y,px,py) end;return x end
local function copy(d,c)
    local s={};for k,v in pairs(d) do s[k]=v end
    s.c=c;s.limits={};s.changes={};s.vars={0,0,0,0};s.birth=0;s.count=0;s.age=0;s.alive=true;s.djX,s.djY=0,0
    return s
end
local function globalResource(fn)
    local old=lstg.GetResourceStatus and lstg.GetResourceStatus()
    if lstg.SetResourceStatus then lstg.SetResourceStatus('global') end
    fn()
    if old and lstg.SetResourceStatus then lstg.SetResourceStatus(old) end
end
local assets=false
function R.loadAssets()
    if assets then return end
    globalResource(function()
        LoadTexture('asl_bullet','Resources/th38/bullet.png')
        for n,r in pairs(R.data.sprites) do LoadImage('asl_b'..n,'asl_bullet',unpack(r)) end
        for key,r in pairs(R.data.customs) do
            LoadTexture('asl_'..r.file,'Resources/th38/'..r.file)
            LoadImage('asl_'..r.file,'asl_'..r.file,0,0,r.w,r.h)
        end
    end)
    assets=true
end
local radius={.05,-1,.04,.05,.05,.05,.045,.05,.05,.05,.05,.05,.05,.05,.05,.05,.05,.05,.05,.05,.05,.05,.05,.05,.15,.24,.05,.06,.06,.24}
local function image(s)
    local custom=s.custom and R.data.customs[s.custom]
    if s.customOn==1 and custom then return 'asl_'..custom.file end
    return 'asl_b'..(R.data.sprites[s.shape*16+s.color] and s.shape*16+s.color or 444)
end
local function release(s)
    if s.pooled then R.bulletCount=R.bulletCount-1;s.pooled=false end
end
local function clean(b)
    local s=b.asl;if s then
        release(s)
        s.alive=false;s.native=nil
    end
    R.objects[b]=nil;object.RawDel(b)
end
local function sync(b,s)
    b.x,b.y=project(s.x,s.y);b.vx,b.vy=0,0
    if s.kind=='curve' then b.x,b.y=project(s.x,s.y);b.vx,b.vy=0,0;return end
    if s.kind=='beam' then
        b.rot=s.direction+180;b.w0=max(0,s.width*4.8);b.l2=max(0,min(s.length,s.age*abs(s.speed)*.0025)*48)
        b.w=b.w0;b.alpha=min(1,max(0,s.alpha/100));b.colli=s.collision and s.life>0
        return
    end
    if s.kind=='enemy' then
        b.colli=s.collision and s.age>=s.immune;b.a,b.b=s.hit*48,s.hit*48
        b.protect=s.age<s.immune;SetAttr(b,'colli',b.colli)
        return
    end
    b.img=image(s);b.rot=s.rotation-90
    b.hscale,b.vscale=s.scaleX*.48,s.scaleY*.48
    local r=s.customOn==1 and s.customRadius*.01 or (radius[s.shape+1] or .05)
    b.a,b.b=max(0,r*48*abs(s.scaleX)),max(0,r*48*abs(s.scaleY));b.rect=false
    b.group=s.invincible==1 and GROUP.INDES or GROUP.ENEMY_BULLET
    b.colli=s.collision and r>0 and s.scaleX~=0 and s.scaleY~=0
end
R.classes.projectile=Class(bullet,{
    init=function(b,s)
        R.loadAssets();b.asl=s;s.native=b;R.objects[b]=true;b.bound=false
        b.group=GROUP.ENEMY_BULLET;b.layer=LAYER.ENEMY_BULLET;b.vx,b.vy=0,0;sync(b,s)
    end,
    frame=function(b) if not b.asl.alive or b.asl.c.closed then clean(b) end end,
    render=function(b)
        local s=b.asl
        SetImageState(b.img,s.blend==1 and 'mul+add' or '',max(0,min(255,s.alpha*2.55)),s.red*2.55,s.green*2.55,s.blue*2.55)
        Render(b.img,b.x,b.y,b.rot,b.hscale,b.vscale)
    end,
    del=function(b) clean(b) end,kill=function(b) clean(b) end,
})
R.classes.fairy=Class(enemy,{
    init=function(b,s)
        b.asl=s;s.native=b
        enemy.init(b,s.enemyStyle or 1,max(1,s.life),false,false,false)
        b.bound=false;b.group=GROUP.ENEMY;b.layer=LAYER.ENEMY
        b.vx,b.vy=0,0;b.maxhp,b.hp=s.life,s.life;b.dmg_factor=1;b.drop={0,0,0};R.objects[b]=true;sync(b,s)
    end,
    frame=function(b)
        if b.hp<=0 then Kill(b);return end
        enemy.frame(b)
        if not b.asl.alive or b.asl.c.closed then clean(b) end
    end,
    render=function(b) enemy.render(b) end,
    del=function(b) clean(b) end,kill=function(b) clean(b) end,
})
R.classes.curve=Class(bent_laser,{
    init=function(b,s)
        local x,y=project(s.x,s.y)
        bent_laser.init(b,({2,4,6,10,12,14,16,8})[floor(s.color/2)%8+1],x,y,max(4,floor(s.tailTicks/2)),max(0,s.width*7.68),4,0)
        b.asl=s;s.native=b;R.objects[b]=true;b.bound=false;b.vx,b.vy=0,0
    end,
    frame=function(b)
        local s=b.asl
        if not s.alive or s.c.closed then clean(b);return end
        b.x,b.y=project(s.x,s.y);b.vx,b.vy=0,0;b.w=max(0,s.width*7.68);b.alpha=max(0,min(1,s.alpha/100));b.colli=s.collision
        bent_laser.frame(b)
    end,
    del=function(b) clean(b) end,kill=function(b) clean(b) end,
})
R.classes.partner=Class(enemy,{
    init=function(b,s)
        b.asl=s;s.native=b;enemybase.init(b,100000,false)
        b.img='ball_mid8';b.bound=false;b.vx,b.vy=0,0;b.a,b.b=18,18;R.objects[b]=true
        b.x,b.y=project(s.x,s.y);SetAttr(b,'colli',true)
    end,
    frame=function(b)
        local s=b.asl
        if not s.alive or s.c.closed then clean(b);return end
        if valid(s.c.host) then s.c.host.hp=max(0,s.c.host.hp-(100000-b.hp)) end
        b.hp=100000;b.x,b.y=project(s.x,s.y);b.vx,b.vy=0,0
    end,
    render=function(b) Render(b.img,b.x,b.y,0,1.5) end,
    del=function(b) clean(b) end,kill=function(b) clean(b) end,
})
R.classes.beam=Class(laser,{
    init=function(b,s)
        local x,y=project(s.x,s.y)
        laser.init(b,({2,4,6,10,12,14,16,8})[floor(s.color/2)%8+1],x,y,s.direction,0,max(1,s.length*48),0,max(1,s.width*4.8),0,0)
        b.asl=s;s.native=b;R.objects[b]=true;b.bound=false;b.vx,b.vy=0,0;sync(b,s)
    end,
    frame=function(b)
        if not b.asl.alive or b.asl.c.closed then clean(b);return end
        sync(b,b.asl);laser.frame(b)
    end,
    del=function(b) clean(b) end,kill=function(b) clean(b) end,
})
local emitterFields={'a2_1','a2_3','a3_2','a3_3','a4_1','a4_5','a4_10','a4_3','a4_7','a4_9','a4_12','a4_13','a4_15','a4_16','a8_1','a8_3','a8_5','a8_7','a6_6','a6_4','a6_5','a6_7','a6_8','a6_10','a6_11','a6_12','a6_13','a9_4','a9_5','a7_1','a7_3','a7_5','a7_7','a9_7','a9_9','a9_11'}
local entityFields={[0]='x','y','speed','direction','accel','accelDirection','rotation','life','shape','color','scaleX','scaleY','exit','invincible','dispel','blend','invert','red','green','blue','alpha','hue','saturation','value'}
local integerFields={a4_3=true,a4_9=true,a4_12=true,a6_6=true,a6_4=true,a6_5=true,shape=true,color=true,life=true}
local function get(s,target,son)
    local key=son and entityFields[target] or emitterFields[target]
    local base=son and 24 or 37
    if target>=base and target<base+4 then return s.vars[target-base+1] or 0,'var'..(target-base+1) end
    if son and (s.kind=='beam' or s.kind=='curve') and target==10 then key='width' elseif son and (s.kind=='beam' or s.kind=='curve') and target==11 then key='length' end
    return key and s[key] or 0,key
end
local function assign(s,key,value)
    if not key then return end
    if key:sub(1,3)=='var' then s.vars[tonumber(key:sub(4))]=value;return end
    if key:sub(1,6)=='global' then s.c.vars[tonumber(key:sub(7))]=value;return end
    if integerFields[key] then value=trunc(value) end
    if key=='a4_3' or key=='a4_12' then value=max(1,value) end
    if key=='shape' then value=max(0,min(25,value)) end
    if key=='color' then value=max(0,min(15,value)) end
    s[key]=value
end
local function variable(s,v,son)
    local index=({[89999]=1,[89998]=2,[-89999]=3,[-89998]=4})[v]
    return index and ((son and s.vars or s.c.vars)[index] or 0) or v
end
local function compare(a,op,b) return op==0 and a>=b or op==1 and abs(a-b)<=.07 or op==2 and a<b end
local function condition(s,kind,op,value,repeats,period,t,son,slot)
    value=variable(s,value,son)
    if kind==0 then return true end
    if kind==1 or kind==2 then
        local clock=kind==1 and t or s.c.time
        return clock>=0 and clock<repeats*period and compare(clock,op,value+floor(clock/period)*period)
    elseif kind==3 or kind==4 then
        if (s.limits[slot] or 0)>=repeats then return false end
        local px,py=R.player();local target=value==-99999 and (kind==3 and px or py) or value*.01+(kind==3 and .5 or -9.5)
        return compare(kind==3 and s.x or s.y,op,target)
    elseif kind==5 then
        local a=son and s.direction or s.a4_10
        local b=aim(s,value)%360;local old=s['angle'..slot] or b;s['angle'..slot]=b
        if op~=1 then return compare(a%360,op,b) end
        local d=(b-old+180)%360-180;local da=(a-old+180)%360-180
        return abs(da)<.3 or (d>0 and da>0 and da<=d) or (d<0 and da<0 and da>=d)
    elseif kind>=6 and kind<=9 then return compare((son and s.vars or s.c.vars)[kind-5] or 0,op,value)
    elseif kind==10 then return valid(player) and (player.death or 0)>0
    elseif kind==11 then return valid(player) and (player.nextspell or 0)>0 end
    return false
end
local function change(s,e,value,son)
    local target,op,mode,duration=e[9],e[10],e[12],e[13]
    if not son and target==0 then s.extra=true;return end
    local old,key=get(s,target,son);if not key then return end
    value=variable(s,value,son)
    if value==-99999 then
        local px,py=R.player()
        value=value+rnd(e[16])
    if key=='rotation' and op==1 then value=value+90 end
    if key=='x' or key=='a2_1' then value=(px-.5)*100
        elseif key=='y' or key=='a2_3' then value=(py+9.5)*100 else value=aim(s,value) end
    end
    value=value+rnd(e[16])
    if key=='rotation' and op==1 then value=value+90 end
    if key=='x' or key=='a2_1' then value=value*.01+(op==1 and .5 or 0)
    elseif key=='y' or key=='a2_3' then value=value*.01+(op==1 and -9.5 or 0) end
    if mode==3 and ran:Float(0,100)>duration then return end
    if son and target>=12 and target<=16 or not son and target>=24 and target<=29 then duration=1 end
    if duration<=1 or mode==3 then assign(s,key,op==1 and value or old+(op==0 and value or -value));return end
    local delta=op==1 and value-old or value
    if op==1 and (key=='direction' or key=='rotation' or key=='a3_3' or key=='a4_5' or key=='a4_10' or key=='a8_5' or key=='a8_7') then delta=(delta+180)%360-180 end
    s.changes[#s.changes+1]={key=key,value=delta,sign=op==2 and -1 or 1,mode=mode,total=duration,age=0}
end
local function events(s,rows,t,son)
    for i,e in ipairs(rows) do
        local yes=condition(s,e[1],e[2],e[3],e[14],e[15],t,son,i)
        if e[4]==1 then
            local other=condition(s,e[6],e[7],e[8],e[14],e[15],t,son,-i)
            yes=e[5]==1 and (yes or other) or (yes and other)
        end
        if yes then
            if e[1]==3 or e[1]==4 then s.limits[i]=(s.limits[i] or 0)+1 end
            change(s,e,e[11],son)
        end
    end
    for i=#s.changes,1,-1 do
        local c=s.changes[i];local a,b=c.age/c.total,(c.age+1)/c.total
        local f=c.mode==1 and (sin(b*90)-sin(a*90)) or c.mode==2 and (cos(a*90)-cos(b*90)) or 1/c.total
        local old
        if c.key:sub(1,3)=='var' then old=s.vars[tonumber(c.key:sub(4))]
        elseif c.key:sub(1,6)=='global' then old=s.c.vars[tonumber(c.key:sub(7))] else old=s[c.key] end
        assign(s,c.key,(old or 0)+c.sign*c.value*f);c.age=c.age+1
        if c.age>=c.total then table.remove(s.changes,i) end
    end
end
R.events=events
local attach,emit
local function template(d,c)
    local s=copy(d,c);s.isEmitter=true;s.vars=c.vars
    s.a2_1=s.a2_1==-99999 and -99999 or s.a2_1*.01+.5
    s.a2_3=s.a2_3==-99999 and -99999 or s.a2_3*.01-9.5
    s.x,s.y=s.a2_1,s.a2_3;s.boundHosts=setmetatable({},{__mode='k'})
    return s
end
local function spawn(e,x,y,direction,speed)
    local c=e.c
    -- Loading0/Sincos原作普通弹对象池固定1500；耗尽时Ins_danmaku直接丢弃该发。
    if e.a47==0 and R.bulletCount>=R.bulletLimit then c.dropped=(c.dropped or 0)+1;return end
    local shape=e.a6_4;local sx=e.a6_9==1 and e.a6_8 or e.a6_7
    local s={c=c,birth=c.time+1,age=0,alive=true,x=x,y=y,speed=speed,direction=direction,rotation=direction+e.a8_7,
        accel=e.a8_3+rnd(e.a8_4),accelDirection=e.a8_5+rnd(e.a8_6),djX=0,djY=0,
        life=e.a6_6,shape=shape,color=e.a6_5,scaleX=sx,scaleY=e.a6_8,customOn=e.a6_1,custom=e.custom,customRadius=e.a6_3,
        red=e.a7_1+rnd(e.a7_2),green=e.a7_3+rnd(e.a7_4),blue=e.a7_5+rnd(e.a7_6),alpha=e.a7_7+rnd(e.a7_8),
        exit=e.a6_10,delayExit=e.a6_14,outTime=0,mist=e.a6_11,invincible=e.a6_12,dispel=e.a6_13,blend=e.a9_4,
        collision=e.a5_2==0,events=e.sonEvents,limits={},changes={},vars={0,0,0,0},kind=e.a47==1 and 'enemy' or e.a47==3 and (e.a54_1>=2 and 'curve' or 'beam') or 'bullet',
        enemyStyle=1+(e.a48_1*2+e.a48_2)%9,tailTicks=max(4,e.a54_2 or 4),hit=e.a48_5*.01,immune=e.a48_6,followSpeed=e.a8_9==1,length=e.a54_2 and e.a54_2*.01 or 1,width=e.a54_3 or 1}
    if e.a47==4 then return end -- Unity蓄力/爆炸/震屏只演出，不制造有判定的替代弹。
    local cls=s.kind=='enemy' and R.classes.fairy or s.kind=='curve' and R.classes.curve or s.kind=='beam' and R.classes.beam or R.classes.projectile
    if s.kind=='enemy' then s.vars=c.vars end
    if s.kind=='bullet' then s.pooled=true;R.bulletCount=R.bulletCount+1 end
    local b=New(cls,s);c.entities[#c.entities+1]=s
    if e.a9_1==1 and e.emitHost then s.parent=e.emitHost;s.lastParentX,s.lastParentY,s.parentRotation=e.emitHost.x,e.emitHost.y,e.emitHost.rotation end
    attach(e,s)
    return b
end
attach=function(e,p)
    for _,link in ipairs(e.links or {}) do
        local target=e.c.byName[link.name]
        if target then
            if link.kind==1 or link.kind==4 then target.boundHosts[p]=link.kind
            elseif link.kind==2 or link.kind==5 then
                local child=template(target,e.c);child.host=p;child.relative=link.kind==5;child.birth=e.c.time+1
                child.skip=false;child.deep=false;child.bound=false;e.c.emitters[#e.c.emitters+1]=child
            end
        end
    end
end
local function fan(e,x,y,host,relative)
    if e.a5_3==1 then local px,py=R.player();if (x-px)^2+(y-py)^2<1.44 then return end end
    local count=max(1,trunc(e.a4_3));local spread=(e.a4_7+rnd(e.a4_8))/count
    local radiusNow=(e.a4_1+rnd(e.a4_2))*.01
    local dummy={x=x,y=y};local head=aim(dummy,e.a4_10)+rnd(e.a4_11)
    local radial=aim(dummy,e.a4_5)+rnd(e.a4_6)
    local v=e.a8_1+rnd(e.a8_2)
    for k=0,max(1,trunc(e.a4_12))-1 do
        for j=0,count-1 do
            local offset=(j-(count-1)/2)*spread
            local ra=(e.a5_4==1 and head or radial)+offset
            local xx,yy=x+radiusNow*cos(ra),y+radiusNow*sin(ra)
            local d=head+offset
            if e.a4_10==-99999 and radiusNow~=0 then d=angle(xx,yy,R.player())+offset+rnd(e.a4_11) end
            if relative and host then d=d+host.rotation end
            local velocity=v-k*e.a4_13
            if e.a4_15~=1 or e.a4_16~=1 then
                local localDir=e.a5_5==1 and d-head or d
                local vx,vy=velocity*cos(localDir)*e.a4_16,velocity*sin(localDir)*e.a4_15
                velocity=(vx*vx+vy*vy)^.5;d=math.deg(math.atan2(vy,vx))+(e.a5_5==1 and head or 0)
            end
            e.emitHost=host;spawn(e,xx,yy,d,velocity)
        end
    end
end
emit=function(e)
    local c=e.c;local t=c.time-e.birth-e.a2_7
    if e.host and not e.host.alive then e.alive=false;return end
    if t>=e.a2_8 then if e.host then e.alive=false end;return end
    if t<0 then return end
    if e.host then e.x,e.y=e.host.x,e.host.y
    else
        if e.a3_1==1 then
            e.djX=e.djX+e.a3_4*.01*cos(e.a3_5);e.djY=e.djY+e.a3_4*.01*sin(e.a3_5)
            e.a2_1=e.a2_1+e.a3_2*.01*cos(e.a3_3)+e.djX;e.a2_3=e.a2_3+e.a3_2*.01*sin(e.a3_3)+e.djY
        end
        local px,py=R.player()
        e.x=(e.a2_1==-99999 and px or e.a2_1)+rnd(e.a2_2*.01)
        e.y=(e.a2_3==-99999 and py or e.a2_3)+rnd(e.a2_4*.01)
    end
    events(e,e.events,t,false)
    if not e.extra and (e.count>=e.a4_4 or t%max(1,e.a4_9)~=0 or t==0 and e.a5_1==0) then return end
    e.extra=false
    if e.a47==2 then return end
    if e.bound then
        for host,kind in pairs(e.boundHosts) do if host.alive then fan(e,host.x,host.y,host,kind==4);e.count=e.count+1 else e.boundHosts[host]=nil end end
    else fan(e,e.x,e.y,e.host,e.relative);e.count=e.count+1 end
end
local function bossMotion(s)
    local e=s.settings
    if e.a51_5~=1 and e.a51_6~=1 then return end
    s.moveClock=s.moveClock+1
    local period=max(1,e.a4_9)
    if s.moveClock<period then return end
    if not s.destination then
        local tx,ty,d
        for _=1,256 do
            tx=e.a2_1+rnd(e.a51_7*.005);ty=e.a2_3+rnd(e.a51_8*.005)
            d=((tx-s.x)^2+(ty-s.y)^2)^.5
            if d<=e.a51_9*.01 and d>=e.a51_10*.01 then break end
        end
        s.destination={distance=d,angle=angle(s.x,s.y,tx,ty)}
    end
    local t=s.moveClock-period;local a=s.destination
    s.speed=-a.distance*8.23e-6*t*(t-90)*100;s.direction=a.angle
    if t>=90 then s.moveClock=0;s.destination=nil;s.speed=0 end
end
local function move(s)
    local c=s.c;s.age=c.time-s.birth
    if s.age<0 then return end
    if s.native and not valid(s.native) then release(s);s.alive=false;return end
    if s.kind=='enemy' and s.native then s.life=s.native.hp end
    if s.kind=='boss' and s.main and valid(c.host) then s.life=c.host.hp end
    if s.kind=='boss' then bossMotion(s) end
    events(s,s.events,s.age,true)
    if s.kind=='enemy' and valid(s.native) then s.native.hp=s.life end
    if s.kind=='boss' and s.main and valid(c.host) then c.host.hp=s.life end
    if s.accel~=0 then local d=aim(s,s.accelDirection);s.djX=s.djX+s.accel*.01*cos(d);s.djY=s.djY+s.accel*.01*sin(d) end
    local dx,dy=s.speed*.01*cos(s.direction)+s.djX,s.speed*.01*sin(s.direction)+s.djY
    s.x,s.y=s.x+dx,s.y+dy
    if s.parent then
        local host=s.parent
        if not host.alive then s.alive=false;return end
        local a=(host.rotation or 0)-(s.parentRotation or host.rotation or 0)
        local rx,ry=s.x-s.lastParentX,s.y-s.lastParentY
        s.x,s.y=host.x+rx*cos(a)-ry*sin(a),host.y+rx*sin(a)+ry*cos(a)
        s.lastParentX,s.lastParentY,s.parentRotation=host.x,host.y,host.rotation
    end
    if s.followSpeed then s.rotation=math.deg(math.atan2(dy,dx)) end
    if s.kind=='boss' then
        local host=s.main and c.host or s.native
        if valid(host) then host.x,host.y=project(s.x,s.y);host.vx,host.vy=0,0 end
    else
        if s.kind~='enemy' then s.life=s.life-1 end
        local out=s.x<0 or s.x>9.2 or s.y< -10 or s.y>.5
        s.outTime=out and s.outTime+1 or 0
        if s.life<0 or s.age>0 and (s.exit==1 and out and (s.kind~='curve' or s.outTime>s.tailTicks) or s.delayExit==1 and s.outTime>50) then s.alive=false end
        if valid(s.native) then if s.alive then sync(s.native,s) else clean(s.native) end end
    end
end
local function load(key)
    if not R.patterns[key] then R.patterns[key]=dofile('mod/GAME/th38/patterns/'..key:gsub('/','_')..'.lua') end
    return R.patterns[key]
end
function R.controller(host,key,first)
    local c={host=host,time=first or 0,emitters={},entities={},byName={},vars={0,0,0,0},closed=false,key=key};R.controllers[c]=true
    local pat=load(key)
    for _,d in ipairs(pat.items) do local e=template(d,c);c.emitters[#c.emitters+1]=e;c.byName[d.name]=e end
    for _,e in ipairs(c.emitters) do for _,link in ipairs(e.links) do
        local target=c.byName[link.name]
        if target then if link.kind==1 or link.kind==4 then target.bound=true elseif link.kind==2 or link.kind==5 then target.deep=true end end
    end end
    local bosses={}
    for _,e in ipairs(c.emitters) do if e.a47==2 then bosses[#bosses+1]=e end end
    for bossIndex,e in ipairs(bosses) do
        local s={c=c,x=e.a2_1,y=e.a2_3,speed=0,direction=0,rotation=90,accel=0,accelDirection=0,djX=0,djY=0,
            alive=true,kind='boss',birth=0,events=e.sonEvents,vars=c.vars,limits={},changes={},life=e.a6_6,settings=e,moveClock=0}
        s.main=bossIndex==1
        if not s.main then New(R.classes.partner,s) end
        c.entities[#c.entities+1]=s;attach(e,s);e.skip=true
    end
    return c
end
function R.step(c)
    if not c or c.closed then return end
    do
        -- 新对象下一tick开始积分；所有对象仍是引擎内的子弹/敌机/激光实体。
        local n=#c.entities
        for i=1,n do local s=c.entities[i];if s.alive then move(s) end end
        local ecount=#c.emitters
        for i=1,ecount do local e=c.emitters[i];if e.alive and not e.skip and not e.deep then emit(e) end end
        local j=1
        for i=1,#c.entities do local s=c.entities[i];if s.alive then c.entities[j]=s;j=j+1 elseif valid(s.native) then clean(s.native) end end
        for i=#c.entities,j,-1 do c.entities[i]=nil end
        j=1
        for i=1,#c.emitters do local e=c.emitters[i];if e.alive then c.emitters[j]=e;j=j+1 end end
        for i=#c.emitters,j,-1 do c.emitters[i]=nil end
        c.time=c.time+1
    end
end
function R.tick(c) R.step(c);R.step(c) end
-- 转阶段替换发射器；保留同一卡的倒计时和血量。清弹标记来自Boss_zhuanjieduan。
function R.transition(c,key,reset,clear)
    local positions={}
    for _,s in ipairs(c.entities) do if s.kind=='boss' then positions[#positions+1]={s.x,s.y} end end
    local old=c.entities;local keep={}
    for _,s in ipairs(old) do
        if clear or s.kind=='boss' then
            if valid(s.native) then clean(s.native) end;s.alive=false
        elseif s.alive then keep[#keep+1]=s end
    end
    local nextState=R.controller(c.host,key,reset and 0 or c.time)
    c.time,c.key,c.emitters,c.byName=nextState.time,key,nextState.emitters,nextState.byName
    for _,e in ipairs(c.emitters) do e.c=c;e.vars=c.vars end
    local index=0
    for _,s in ipairs(nextState.entities) do
        s.c=c
        if s.kind=='boss' then
            index=index+1;s.vars=c.vars
            if positions[index] then s.x,s.y=unpack(positions[index]) end
        end
        keep[#keep+1]=s
    end
    c.entities=keep;R.controllers[nextState]=nil
end
function R.clear(c)
    if not c then return end
    c.closed=true
    for _,s in ipairs(c.entities) do if valid(s.native) then clean(s.native) else release(s) end;s.alive=false end
    c.emitters,c.entities,c.byName={},{},{};R.controllers[c]=nil
end
function R.clearAll() for c in pairs(R.controllers) do R.clear(c) end;R.bulletCount=0 end
return R
