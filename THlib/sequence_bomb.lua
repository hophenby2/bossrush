-- 顺序模式的机体 Bomb 与灵击入口。库存、决死、时长和无敌时间独立于 GameDrops。
-- 时间参数从原作 BombData / PlayerBomb 导出；攻击使用原作的区域原语。
local P=SequenceResources
local profiles=dofile('mod/GAME/original/players/bombs.lua')
local min,max,floor,sqrt=math.min,math.max,math.floor,math.sqrt
local function live(o) return o and IsValid(o) end
local inNames={
    'UpdateFantasyOrbBomb','UpdateMasterSparkBomb','UpdateKillingDollBomb','UpdateSlashOfPresentWorldBomb',
    'UpdateQuadrupleBarrierBomb','UpdateArtfulSacrificeBomb','UpdateRedNightlessCastleBomb','UpdateGhastlyDreamBomb',
}
local inDeath={
    'UpdateFantasySealBlinkDeathbomb','UpdateFinalSparkDeathbomb','UpdateNightMistPhantomKillerDeathbomb','UpdateSlashOfFutureEternityDeathbomb',
    'UpdateEternalNightQuadrupleBarrierDeathbomb','UpdateReturnInanimatenessDeathbomb','UpdateScarletDevilDeathbomb','UpdateEternalSleepInDreamlandDeathbomb',
}
local bombNames={
    [6]={reimua='灵符「梦想封印」',reimub='梦符「封魔阵」',marisaa='魔符「星屑幻想」',marisab='恋符「极限火花」'},
    [7]={reimua='灵符「梦想妙珠」',reimua_slow='灵符「梦想封印·散」',reimub='梦符「封魔阵」',reimub_slow='梦符「二重结界」',
        marisaa='魔符「星屑幻想」',marisaa_slow='魔符「银河」',marisab='恋符「非定向光线」',marisab_slow='恋符「极限火花」',
        sakuyaa='幻符「杀人玩偶」',sakuyaa_slow='幻符「洞穴中的银龙」',sakuyab='时符「完美空间」',sakuyab_slow='时符「私人广场」'},
}
local vmSets={
    [6]={reimua={133,134,135,136},reimub={137,138,139,140},marisaa={5,6,7},marisab={8,9,10,11}},
    [7]={reimua={133,134,135,136},reimua_slow={133,134,135,136},reimub={137,138,139,140},
        reimub_slow={141,142,143},marisaa={5,6,7},marisaa_slow={5,6,7},marisab={12,13,14},marisab_slow={8,9,10,11},
        sakuyaa={5,6},sakuyaa_slow={7,8},sakuyab={9,10,11,12},sakuyab_slow={13,14}},
}
local function bombVMs(p,b,ids)
    local out={}
    for _,id in ipairs(ids or {}) do out[#out+1]=P.animation(p.original_game,p.original_archive,id) end
    return out
end
function P.bombProfile(p,slow,death)
    local game=p.original_game;local m=p.original_machine
    if game==10 then return {duration=180,protect=270,name='灵击',key='spirit'} end
    if game==8 then
        local youkai=m.id:sub(1,4)=='solo' and m.shot==1 or m.id:sub(1,4)=='team' and slow
        local idx=m.character+(youkai and 4 or 0)
        if death and m.id:sub(1,4)=='team' then idx=(idx+4)%8 end
        local key=(death and inDeath or inNames)[idx+1]
        local source=assert(profiles[8][key],key)
        return {duration=source.duration,protect=source.protect,name=key,key=key,character=idx,death=death}
    end
    local key=m.id..(game==7 and slow and '_slow' or '')
    local source=assert(profiles[game][key],key)
    return {duration=source.duration,protect=source.protect,name=bombNames[game][key],key=key,
        cherryCost=source.cherryCost,cherryRate=source.cherryRate}
end
function P.bombInput(p,key,previous,death)
    local s=P.state()
    if not s or s.game==95 or not key.spell or previous.spell and not death or s.bomb or p.lock or p.dialog then return false end
    local game=s.game
    if game==10 then if s.power<20 then return false end
    elseif s.bombs<1 then return false end
    local spec=P.bombProfile(p,key.slow==true,death)
    if game==10 then s.power=s.power-20;s.faith=max(50000,s.faith-3000)
    else s.bombs=max(0,s.bombs-(game==8 and death and min(2,s.bombs) or 1)) end
    s.bomb_count=s.bomb_count+1
    s.bomb={time=0,spec=spec,x=p.x,y=p.y,objects={}}
    local ids=vmSets[game] and vmSets[game][spec.key]
    if game==8 and spec.character==1 then ids=spec.death and {35,36,37,38,39} or {30,31,32,33,34} end
    p.original_bomb_vms=bombVMs(p,s.bomb,ids)
    if game==10 then p.original_bomb_vms={P.animation(10,'bullet',p.original_machine.character==0 and 400 or 407)} end
    p.protect=spec.protect;p.original_bomb_speed=spec.key:find('Spark') or spec.key=='marisab' and game==6 and .3 or 1
    if type(p.original_bomb_speed)~='number' then p.original_bomb_speed=.3 end
    if game==7 and spec.cherryCost then
        local difficulty=lstg.var.sequence_key:find('lunatic',1,true) and 4 or 3
        s.bomb.cherryDrain=max(floor(spec.cherryCost/spec.duration/10)*10,floor(s.cherry*(spec.cherryRate or 0)/difficulty/spec.duration/10)*10)
    end
    if game==7 and s.border>0 then s.border,s.cherry_plus=0,0 end
    item.ClearBossBonus();P.sync()
    for _,o in ObjList(GROUP.ITEM) do o.attract=8 end
    PlaySound('enep02',.6,p.x/200)
    return true
end
local function enemyEach(fn)
    object.EnemyNontjtDo(function(o) if live(o) and o.colli and not o.protect and o.hp and o.hp>0 then fn(o) end end)
end
local function region(p,x,y,w,h,damage,circle)
    local b=P.state().bomb
    b.regions[#b.regions+1]={x=x,y=y,w=w,h=h,circle=circle}
    local hits=0
    enemyEach(function(o)
        local hit=circle and Dist(x,y,o.x,o.y)<w+(o.a or 0) or not circle and math.abs(o.x-x)<w/2+(o.a or 0) and math.abs(o.y-y)<h/2+(o.b or 0)
        if hit then P.hitEnemy(o,damage,true);hits=hits+damage end
    end)
    if circle then P.clear('bomb',x,y,w)
    else
        object.BulletIndesDo(function(o)
            if live(o) and o.imgclass and o.colli and math.abs(o.x-x)<w/2 and math.abs(o.y-y)<h/2 then
                if OriginalBulletVisual and OriginalBulletVisual.can_cancel and not OriginalBulletVisual.can_cancel(o) then return end
                P.spawnItem(P.game()==10 and 'faith_minor' or 'star',o.x,o.y,{auto=true});object.Del(o)
            end
        end)
    end
    return hits
end
local function orb(b,p,x,y,a,v,damage,radius,mode)
    local o={x=x,y=y,angle=a,speed=v,damage=damage,radius=radius,age=0,mode=mode or 'straight'}
    b.objects[#b.objects+1]=o
    local game=p.original_game
    local ids=vmSets[game] and vmSets[game][b.spec.key]
    if ids then
        if b.spec.key:sub(1,6)=='reimua' then o.vms=bombVMs(p,b,ids)
        else o.vms=bombVMs(p,b,{ids[(#b.objects-1)%#ids+1]}) end
    elseif game==8 then
        local c=b.spec.character
        local id=c==0 and 19 or c==2 and 22 or c==7 and (#b.objects%2==0 and 19 or 18)
        if id then o.vms=bombVMs(p,b,{id}) end
    end
    return o
end
local function homing(o,p)
    local target,distance
    enemyEach(function(e) local d=Dist(o,e);if not distance or d<distance then target,distance=e,d end end)
    if target then
        local dx,dy=target.x-o.x,target.y-o.y
        local d=max(1,sqrt(dx*dx+dy*dy)/(o.speed/8))
        local vx,vy=cos(o.angle)*o.speed+dx/d,sin(o.angle)*o.speed+dy/d
        o.speed=max(1,min(10,sqrt(vx*vx+vy*vy)));o.angle=atan2(vy,vx)
    end
end
local function updateOrbs(b,p)
    for i=#b.objects,1,-1 do
        local o=b.objects[i];o.age=o.age+1
        if o.mode=='fantasy' and b.time<40 then
            o.angle=o.angle+(i%2==0 and 3 or -3)
            local oldx,oldy=o.x,o.y
            o.x=b.x+sin(o.angle)*o.motionStep;o.y=b.y-cos(o.angle)*o.motionStep
            o.motionStep=o.motionStep+3.2;o.mx,o.my=o.x-oldx,o.y-oldy
        elseif o.mode=='fantasy' then
            if b.time==40 then o.speed=sqrt(o.mx*o.mx+o.my*o.my);o.angle=atan2(o.my,o.mx) end
            homing(o,p)
        elseif o.mode=='homing' then homing(o,p)
        elseif o.mode=='return' then o.speed=o.speed-.4
        elseif o.mode=='doll' then
            if o.age==70 then
                local target
                enemyEach(function(e) if not target then target=e end end)
                if target then o.angle=Angle(o,target) end;o.speed=14
            end
            if o.age<30 or o.age>=70 then o.speed=o.speed+o.accel
            else o.angle=o.angle+o.omega;o.speed=0 end
        end
        if o.mode~='fantasy' or b.time>=40 then o.x=o.x+cos(o.angle)*o.speed;o.y=o.y+sin(o.angle)*o.speed end
        if o.age<=(o.life or b.spec.duration) then
            if o.mode=='fantasy' then
                if o.burst then
                    o.burst=o.burst+1
                    if o.burst<=12 and o.burst%4==0 then region(p,o.x,o.y,64+12.8*o.burst,0,500,true) end
                elseif o.age%2==0 then
                    o.hits=(o.hits or 0)+region(p,o.x,o.y,64,0,5,true)
                    if o.hits>=200 or b.time>=b.spec.duration-30 then
                        o.burst=0
                        for _,vm in ipairs(o.vms or {}) do OriginalANM.interrupt(vm,1) end
                    end
                end
            else region(p,o.x,o.y,o.radius,o.radius,o.damage,true) end
        else table.remove(b.objects,i) end
        for _,vm in ipairs(o.vms or {}) do OriginalANM.step(vm,1) end
    end
end
local function th06(p,b)
    local t,key=b.time,b.spec.key
    if key=='reimua' then
        if t>=60 and t<180 and t%16==0 and floor((t-60)/16)>0 then orb(b,p,p.x,p.y,ran:Float(0,360),4,8,24,'homing') end
        if t==0 then region(p,p.x,p.y,256,256,0) end
    elseif key=='reimub' then
        if t%2~=0 then region(p,b.x,0,62,448,16);region(p,0,b.y,384,62,16) end
    elseif key=='marisaa' then
        if t==0 then for i=0,7 do orb(b,p,p.x,p.y,i*45,2,8,64) end end
        if t%3==0 then for _,o in ipairs(b.objects) do o.damage=0 end else for _,o in ipairs(b.objects) do o.damage=8 end end
    elseif key=='marisab' and t%4~=0 then region(p,0,(224+p.y)/2,384,224-p.y,12) end
end
local function th07(p,b)
    local t,key=b.time,b.spec.key
    if key=='reimua' then
        if t>=8 and t<80 and t%6==0 then orb(b,p,p.x,p.y,(p.x<0 and 1 or -1)*floor((t-8)/6)*45+90,15,8,24,'return') end
    elseif key=='reimua_slow' then
        if t==0 then for i=0,7 do orb(b,p,p.x,p.y,i*45,4,8,24,'homing') end end
    elseif key=='reimub' then
        if t%2~=0 then region(p,b.x,0,62,448,32);region(p,0,b.y,384,62,32) end
    elseif key=='reimub_slow' then region(p,b.x,b.y,256,256,18)
    elseif key=='marisaa' or key=='marisaa_slow' then
        if t==0 then for i=0,7 do orb(b,p,p.x,p.y,i*45,key=='marisaa' and 2 or 4,8,64,key=='marisaa' and 'straight' or 'homing') end end
    elseif key=='marisab' then
        if t%10==0 then
            for i=0,5 do local a=i*60+t;region(p,p.x+cos(a)*t,p.y+sin(a)*t,128,128,8) end
        end
    elseif key=='marisab_slow' then region(p,0,(224+p.y)/2,384,224-p.y,12)
    elseif key=='sakuyaa' or key=='sakuyaa_slow' then
        if t%4==0 and t<120 then
            local a=t*12;orb(b,p,p.x+cos(a)*64,p.y+sin(a)*64,a,8,8,12,'homing')
        end
    elseif key=='sakuyab' then
        if t==0 or t==60 or t==120 then
            object.BulletIndesDo(function(o) if live(o) and o.imgclass then o.vx,o.vy=0,0 end end)
        end
        if t>=30 and t%4==0 then region(p,0,0,352,416,16) end
    elseif key=='sakuyab_slow' then region(p,b.x,b.y,160,160,16) end
end
local function th08(p,b)
    local t,c=b.time,b.spec.character
    if c==0 then
        if t==0 then for i=0,15 do local o=orb(b,p,p.x,p.y,180-i*22.5,0,5,64,'fantasy');o.motionStep=0 end end
    elseif c==1 then
        if t>=60 then region(p,p.x,(224+p.y)/2,128,224-p.y,12);region(p,0,(224+p.y)/2,384,224-p.y,b.spec.death and 7 or 6) end
    elseif c==2 then
        if t>=20 and t<116 and t%2==0 then
            for side=0,1 do
                local i=(t-20)/2+side*48;local a=180-i*360/96
                local o=orb(b,p,p.x+cos(a)*24,p.y+sin(a)*24,a,ran:Float(.5,1.5),b.spec.death and 30 or 20,32,'doll')
                o.accel=ran:Float(.03,.13);o.omega=ran:Sign()*9;o.life=120
            end
        end
    elseif c==3 then
        if t%20==0 then region(p,0,0,96,448,b.spec.death and 100 or 80) end
    elseif c==4 then
        if t%40==0 and t<160 then region(p,p.x,p.y,100+t/40,0,70,true) end
    elseif c==5 then
        if t>=60 and t<150 and t%30==0 then orb(b,p,p.x,p.y,90,5,70,1) end
    elseif c==6 then
        -- 不夜城的伤害来自 SHT 的第七/八档子机射击，不能再加一层全屏伤害。
        if t>=60 then P.clear('bomb',p.x,p.y,96) end
    elseif c==7 then
        if t%12==0 then for i=0,3 do orb(b,p,p.x,p.y,60+i*20,4,50,24,'homing') end end
    end
end
function P.stepBomb(p)
    local s=P.state();local b=s and s.bomb
    if not b then return end
    if b.cherryDrain then s.cherry=max(0,s.cherry-b.cherryDrain) end
    if b.time>=b.spec.duration then
        if b.spec.key=='sakuyab' or b.spec.key=='sakuyab_slow' then P.clear('bomb') end
        s.bomb=nil;p.original_bomb_speed=1;p.original_bomb_vms=nil;p.nextspell=0;return
    end
    b.regions={}
    p.nextspell=b.spec.duration-b.time
    if s.game==6 then th06(p,b) elseif s.game==7 then th07(p,b) elseif s.game==8 then th08(p,b)
    elseif s.game==10 then
        local radius=32+b.time*4
        local spell=false;enemyEach(function(o) if o.is_sc then spell=true end end)
        region(p,b.x,b.y,radius,0,spell and 38 or 5,true)
    end
    updateOrbs(b,p);b.time=b.time+1
    for _,vm in ipairs(p.original_bomb_vms or {}) do OriginalANM.step(vm,1) end
end
function P.renderBomb(p)
    local s=P.state();local b=s and s.bomb;if not b then return end
    for _,o in ipairs(b.objects) do for _,vm in ipairs(o.vms or {}) do OriginalANM.draw(vm,o.x,o.y) end end
    for _,vm in ipairs(p.original_bomb_vms or {}) do
        if #b.objects==0 then OriginalANM.draw(vm,b.x,b.y) end
    end
end
return P
