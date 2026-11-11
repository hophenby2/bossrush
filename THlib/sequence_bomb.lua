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
local function effect(p,b,kind,x,y,argb,angle)
    local visual=OriginalStageVisual and OriginalStageVisual.presentation
    if not visual then return end
    local scripts={[36]=88,[37]=92,[40]=81,[42]=83,[43]=83,[44]=83,[45]=83,[48]=85,[53]=88}
    local o=visual.new_effect(8,'etama',assert(scripts[kind]),x,y,nil,kind,argb or 0xffffffff)
    if o then o.bomb_radial=true;o.initial_angle=angle end
    return o
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
    if game==7 and (s.border>0 or s.border_ready) then P.breakBorder(p,false);return true end
    if game==10 then if s.power<20 then return false end
    elseif s.bombs<1 then return false end
    local spec=P.bombProfile(p,key.slow==true,death)
    if game==10 then s.power=s.power-20;s.faith=max(50000,s.faith-3000)
    else s.bombs=max(0,s.bombs-(game==8 and death and min(2,s.bombs) or 1)) end
    s.bomb_count=s.bomb_count+1
    s.bomb={time=0,spec=spec,x=p.x,y=p.y,objects={}}
    if game==8 then s.bomb.focus=death and not key.slow or not death and key.slow==true end
    if game==8 and spec.character==5 then
        local v=p.original_options[1];s.bomb.option_x,s.bomb.option_y=v and v[1] or p.x,v and v[2] or p.y
    end
    local ids=vmSets[game] and vmSets[game][spec.key]
    if game==8 and spec.character==1 then ids=spec.death and {35,36,37,38,39} or {30,31,32,33,34} end
    p.original_bomb_vms=bombVMs(p,s.bomb,ids)
    if game==10 then
        local script=p.original_machine.character==0 and 400 or 407
        -- 原作StartPowerTransition在神德(93..96)及御射军神(109)使用缩小的441号演出。
        for _,boss in ipairs(boss_group or {}) do
            local card=live(boss) and boss.current_card
            local id=card and (card.source_card_id or card.card_id)
            if boss.is_sc and (id==3600 or id==3621) then script=441;break end
        end
        p.original_bomb_vms={P.animation(10,'bullet',script,true)}
    end
    p.protect=spec.protect;p.original_bomb_speed=1
    if game==6 and spec.key=='marisab' then p.original_bomb_speed=.3
    elseif game==7 and spec.key=='marisab_slow' or game==8 and spec.character==1 then p.original_bomb_speed=.2
    elseif game==7 and spec.key=='marisab' then p.original_bomb_speed=.4 end
    if game==7 and spec.key=='marisaa_slow' then p.original_bomb_speed=.4 end
    if game==8 and spec.character==3 or game==8 and spec.character==6 then p.original_bomb_speed=0
    elseif game==8 and spec.character==7 then p.original_bomb_speed=.8 end
    if game==7 and spec.cherryCost then
        local difficulty=lstg.var.sequence_key:find('lunatic',1,true) and 4 or 3
        s.bomb.cherryDrain=max(floor(spec.cherryCost/spec.duration/10)*10,floor(s.cherry*(spec.cherryRate or 0)/difficulty/spec.duration/10)*10)
    end
    item.ClearBossBonus();P.sync()
    for _,o in ObjList(GROUP.ITEM) do o.attract=8 end
    return true
end
local function enemyEach(fn)
    object.EnemyNontjtDo(function(o) if live(o) and o.colli and not o.protect and o.hp and o.hp>0 then fn(o) end end)
end
local function region(p,x,y,w,h,damage,circle)
    local b=P.state().bomb
    b.regions[#b.regions+1]={x=x,y=y,w=w,h=h,circle=circle}
    local hits=P.queueHitRegion(x,y,w,h,damage,true,circle)
    if circle then P.clear('bomb',x,y,w) else P.clear('bomb',x,y,nil,{w,h}) end
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
        elseif o.mode=='spiral' then
            local oldx,oldy=o.x,o.y
            o.radial=o.radial+o.speed;o.angle=o.angle+o.omega
            o.x,o.y=o.cx+cos(o.angle)*o.radial,o.cy+sin(o.angle)*o.radial
            o.draw_angle=atan2(o.y-oldy,o.x-oldx)
            if o.radial>=500 then o.life=0 end
        elseif o.mode=='accelerating_star' then
            o.history=o.history or {};table.insert(o.history,1,{o.x,o.y});if #o.history>8 then table.remove(o.history) end
            o.x,o.y=o.x+o.mx,o.y+o.my;o.mx,o.my=o.mx+o.ax,o.my+o.ay
            if o.y>480 then o.life=0 end
        elseif o.mode=='doll' then
            if o.age==70 then
                local target
                enemyEach(function(e) if not target then target=e end end)
                if target then o.angle=Angle(o,target) end;o.speed=14
            end
            if o.age<30 or o.age>=70 then o.speed=o.speed+o.accel
            else o.angle=o.angle+o.omega;o.speed=0 end
        end
        if o.mode~='accelerating_star' and o.mode~='spiral' and (o.mode~='fantasy' or b.time>=40) then o.x=o.x+cos(o.angle)*o.speed;o.y=o.y+sin(o.angle)*o.speed end
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
            else
                local damage=o.hitcap and max(0,min(o.damage,o.hitcap-(o.total_hits or 0))) or o.damage
                local hits=region(p,o.x,o.y,o.damage_box or o.radius,o.damage_box or o.radius,damage,not o.damage_box);o.total_hits=(o.total_hits or 0)+hits
                if o.cancel_radius then P.clear('bomb',o.x,o.y,o.cancel_radius) end
            end
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
        if t==0 then for i=0,7 do local o=orb(b,p,p.x,p.y,-i*45,2,8,64);o.damage_box=128 end end
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
    elseif key=='marisaa' then
        if t==0 then for i=0,7 do local o=orb(b,p,p.x,p.y,-i*45,2,8,64);o.damage_box=128;o.cancel_radius=96 end end
    elseif key=='marisaa_slow' then
        if t%6==0 and t/6<24 then
            local o=orb(b,p,p.x,p.y,90,0,12,64,'accelerating_star')
            local a=90+ran:Float(-11.25,11.25);o.mx,o.my=-5*cos(a),-5*sin(a)
            a=90+ran:Float(-11.25,11.25);o.ax,o.ay=.24*cos(a),.24*sin(a)
            o.damage_box,o.cancel_radius,o.hitcap=128,96,80
        end
    elseif key=='marisab' then
        if t%10==0 then
            for i=0,5 do local a=i*60+t;region(p,p.x+cos(a)*t,p.y+sin(a)*t,128,128,8) end
        end
    elseif key=='marisab_slow' then if t%4~=0 then region(p,0,(224+p.y)/2,384,224-p.y,12) end
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
        if t%4~=0 then region(p,p.x,(224+p.y)/2,128,224-p.y,12);region(p,0,(224+p.y)/2,384,224-p.y,b.spec.death and 7 or 6) end
    elseif c==2 then
        if t>=20 and t<116 and t%2==0 then
            for side=0,1 do
                local i=(t-20)/2+side*48;local a=180-i*360/96
                local o=orb(b,p,p.x+cos(a)*24,p.y+sin(a)*24,a,ran:Float(.5,1.5),b.spec.death and 30 or 20,32,'doll')
                o.accel=ran:Float(.03,.13);o.omega=ran:Sign()*9;o.life=120
            end
        end
    elseif c==3 then
        if t<40 then p.y=b.y+(-192-b.y)*(1-(1-t/40)^2)
        elseif t==40 then effect(p,b,40,p.x,p.y,b.spec.death and 0xffff8080 or 0xff8080ff)
        elseif t>=70 then
            if t==70 then p.y=192 end
            if t<130 and t%5==0 then region(p,p.x,0,96,448,b.spec.death and 100 or 80) end
            if t==70 or t==80 or t==90 then
                effect(p,b,48,p.x,0,b.spec.death and 0xffff8080 or 0xff8080ff)
            end
        end
    elseif c==4 then
        for i=0,3 do
            local age=t-i*10
            if age==0 then
                b.barriers=b.barriers or {};b.barriers[i+1]={x=p.x,y=p.y}
                local e=effect(p,b,b.spec.death and 37 or 36,p.x,p.y,nil,math.pi/4+i*math.pi/8)
                if e then e.vm=OriginalANM.new(8,'etama',(b.spec.death and 92 or 88)+i) end
            end
            local pos=b.barriers and b.barriers[i+1]
            if pos and age>=0 and age<40 and age%5==0 then region(p,pos.x,pos.y,100+age,0,70,true) end
        end
    elseif c==5 then
        local x,y
        if t<60 then local f=(t/60)^2;x,y=b.option_x*(1-f),b.option_y*(1-f)
        else x,y=0,0 end
        local o=p.original_option_state and p.original_option_state[1]
        if o then o.x,o.y=x,y;o.vm.rotation[3]=t<60 and -t*math.pi/10 or 0;o.vm.alpha[1]=t>=(b.spec.death and 128 or 150) and 0 or 255;p.original_options[1]={x,y} end
        if t<60 then region(p,x,y,32,0,40,true) end
        if t>=60 and t<=76 and t%4==0 then effect(p,b,40,0,0,({0xffffffff,0xffffd0d0,0xffffb0b0,0xffff8080,0xffff4040})[(t-60)/4+1]) end
        local burst=b.spec.death and 120 or 90
        if t==burst then for _,kind in ipairs({42,43,44}) do effect(p,b,kind,0,0) end end
        if t>=burst and t<burst+110 then
            P.clear('bomb',0,0,1+(t-burst)*5)
            if (t-burst)%5==0 then region(p,0,0,1+(t-burst)*5,0,70,true) end
        end
        if t>=burst+10 and t<=burst+40 and t%10==0 then effect(p,b,45,0,0) end
    elseif c==6 then
        -- 不夜城的伤害来自 SHT 的第七/八档子机射击，不能再加一层全屏伤害。
        if t>=60 then
            p.original_bomb_speed=b.spec.death and 3 or 2;P.clear('bomb',p.x,p.y,96)
            if t%10==0 then effect(p,b,53,p.x,p.y) end
        end
    elseif c==7 then
        if t==0 then
            for layer=0,3 do for i=0,15 do
                local o=orb(b,p,p.x,p.y,180-i*22.5,layer<2 and 2 or 1.5,50,24,'spiral')
                o.vms=bombVMs(p,b,{layer%2==0 and 18 or 19});o.radial=0;o.cx,o.cy=p.x,p.y
                o.omega=(layer%2==0 and -1 or 1)*(layer<2 and .75 or .9);o.hitcap=800
            end end
        end
        if b.spec.death and t>=60 and t<200 and t%20==0 then
            local a=ran:Float(-180,180)
            for i=0,15 do local o=orb(b,p,p.x,p.y,a-i*22.5,8,100,64,'spiral')
                o.vms=bombVMs(p,b,{20});o.radial=0;o.cx,o.cy=p.x,p.y;o.omega=0;o.hitcap=1200
            end
        end
    end
end
function P.stepBomb(p)
    local s=P.state();local b=s and s.bomb
    if not b then return end
    if s.game==8 then P.addGauge((b.spec.character>=4 and 1 or -1)*floor(26000/b.spec.duration),true) end
    if b.cherryDrain then s.cherry=max(0,s.cherry-b.cherryDrain) end
    if b.time>=b.spec.duration then
        if b.spec.key=='sakuyab' or b.spec.key=='sakuyab_slow' then P.clear('bomb') end
        s.bomb=nil;p.original_bomb_speed=1;p.original_bomb_vms=nil;p.nextspell=0;return
    end
    b.regions={}
    P.bombSound(p,b)
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
    local g,key=s.game,b.spec.key
    local vms=p.original_bomb_vms or {}
    if g==6 and key=='marisab' or g==7 and key=='marisab_slow' or g==8 and b.spec.character==1 then
        -- 源DrawMasterSpark在执行ANM后，按精灵的实际长度把光束中心推到出膛点前方。
        for i,vm in ipairs(vms) do
            local sprite=OriginalANM.sprite_resource(vm)
            if sprite then
                local angle=g==8 and (90+24-(i-1)*12) or (108-(i-1)*12)
                local length=g==8 and sprite[4]*vm.scale[1] or sprite[5]*vm.scale[2]
                local rotation=g==6 and angle-90 or g==7 and angle-90 or angle
                OriginalANM.draw(vm,p.x+cos(angle)*length/2,p.y+sin(angle)*length/2,0,1,1,1,nil,nil,rotation)
            end
        end
        return
    elseif g==7 and key=='marisab' then
        for i,vm in ipairs(vms) do
            local sprite=OriginalANM.sprite_resource(vm)
            local turn=b.time*(b.time-1)*3/b.spec.duration/2*(b.x<0 and -1 or 1)
            local angle=90-(i-1)*120+turn
            if sprite then local length=sprite[5]*vm.scale[2]
                OriginalANM.draw(vm,p.x+cos(angle)*length/2,p.y+sin(angle)*length/2,0,1,1,1,nil,nil,angle-90)
            end
        end
        return
    elseif (g==6 or g==7) and key=='reimub' then
        for i,vm in ipairs(vms) do OriginalANM.draw(vm,i%2==1 and b.x or 0,i%2==1 and 0 or b.y) end
        return
    end
    for _,o in ipairs(b.objects) do for _,vm in ipairs(o.vms or {}) do
        local function scaled(x,y,scale)
            local old=vm.scale;vm.scale={scale,scale};OriginalANM.draw(vm,x,y);vm.scale=old
        end
        if (g==6 or g==7) and key=='marisaa' then
            local vx,vy=cos(o.angle)*o.speed,sin(o.angle)*o.speed
            scaled(o.x,o.y,3.2);scaled(o.x-vx*6-32,o.y-vy*6+32,2.2);scaled(o.x-vx*10,o.y-vy*10,1)
        elseif g==7 and key=='marisaa_slow' then
            scaled(o.x,o.y,3.2)
            if o.history and o.history[4] then scaled(o.history[4][1],o.history[4][2],2.2) end
            if o.history and o.history[8] then scaled(o.history[8][1],o.history[8][2],1.3) end
        else
            local rotation=s.game==8 and (o.draw_angle or o.angle) or g==7 and key:sub(1,6)=='sakuya' and o.angle-90 or key:sub(1,6)=='reimua' and 0 or nil
            OriginalANM.draw(vm,o.x,o.y,0,1,1,1,nil,nil,rotation)
        end
    end end
    for _,vm in ipairs(p.original_bomb_vms or {}) do
        if #b.objects==0 then OriginalANM.draw(vm,b.x,b.y) end
    end
end
return P
