-- 原作自机运行桥：SHT 决定发射周期、位置、速度、判定和伤害，ANM 决定像素。
-- 所有类只从 SequenceResources.spawnPlayer 进入；练习、随机模式及旧顺序录像不走这里。
local P=SequenceResources
local floor,min,max,abs,sqrt=math.floor,math.min,math.max,math.abs,math.sqrt
local New,object,task=New,object,task
local class={}
P.classes=class
local function live(o) return o and IsValid(o) end
local function animation(game,archive,id)
    local data=OriginalANM.load(game,archive)
    local key=data.ids[id]
    assert(key~=nil,'原作自机动画编号未映射：'..game..'/'..archive..':'..id)
    return OriginalANM.new(game,archive,key)
end
P.animation=animation
local function archive(m,game) return (game==10 and 'pl' or 'player')..('%02d'):format(m.character) end
local function vmStep(vm) if vm then OriginalANM.step(vm,1) end end
local function draw(vm,x,y,alpha) if vm then OriginalANM.draw(vm,x,y,0,1,1,(alpha or 255)/255) end end
-- 先汇总同帧命中，再做原作的封顶和整数符卡减伤；否则多路细弹会被逐颗取整放大。
local pending={}
function P.hitEnemy(o,amount,bomb,human,region,shot)
    if not live(o) or o.protect then return end
    local r=pending[o]
    if not r then r={shot=0,bomb=0,region=0,secondary=0,passShot=0,card=o.current_card};pending[o]=r end
    local key=bomb and 'bomb' or region and 'region' or 'shot';r[key]=r[key]+amount
    if P.secondaryHit then r[key]=r[key]-amount;r.secondary=r.secondary+amount end
    if bomb then r.passBomb=true;if P.secondaryHit then r.secondary_bomb=true end end
    if human then r.human=true end
    if P.game()==8 and not bomb and not region and amount>0 then
        r.passShot=r.passShot+amount
        local s=P.state();local m=P.machine(8,s.machine)
        local threshold=m.id:sub(1,4)=='solo' and m.shot==0 and 27 or 40
        local accumulator=o.original_time_accumulator or threshold
        while accumulator>=threshold do
            if human and s.human<=P.humanThreshold() then P.spawnItem('time',shot and shot.x or o.x,shot and shot.y or o.y) end
            accumulator=accumulator-threshold
        end
        o.original_time_accumulator=accumulator
    end
end
function P.feedEnemyPass(o)
    local r=pending[o];if not r then return end
    if P.game()==8 then o.original_time_accumulator=(o.original_time_accumulator or 0)+min(50,r.passShot);r.passShot=0 end
end
function P.endEnemyPass(o)
    local r=pending[o];if not r then return end
    r.last_bomb_hit=r.passBomb==true;r.passBomb=nil
end
function P.flushDamage()
    local game=P.game()
    for o,r in pairs(pending) do
        pending[o]=nil
        if live(o) and not o.protect and o.current_card==r.card then
            local n=r.shot+r.bomb+r.region
            if game==7 and n>0 then P.hitDamage(n,player,o) end
            if game==7 and P.state().machine=='reimua' and not o.IsBoss and not player.__slow_flag and not P.state().bomb then
                local chapter=tonumber(P.state().stage_name)
                if chapter==4 then n=n-floor(n/4)-floor(n/16)
                elseif chapter==5 or chapter==6 then n=floor(n/2) end
            end
            if game==8 then
                local s=P.state()
                o.original_time_accumulator=(o.original_time_accumulator or 0)+min(50,r.passShot)
                if s.human>=P.youkaiThreshold() then n=floor(n*106/100) end
                if not r.secondary_bomb then
                    local extra=r.secondary
                    if s.human>=P.youkaiThreshold() then extra=floor(extra*106/100) end
                    n=n+floor(extra/((s.machine=='team3' or s.machine=='solo7') and 6.5 or 1.7))
                end
            end
            if game==6 or game==7 or game==8 then n=min(70,n) end
            -- 风神录这里直接递增以10分为单位的分数存储，而非GuiScore.Add的显示分。
            if n>0 then P.addScore(game==10 and floor((floor(n/10)+10)/10)*10 or floor(n/5)*10) end
            if o.is_sc then
                local bomb=r.last_bomb_hit==true or r.last_bomb_hit==nil and r.bomb>0
                local divisor=bomb and (game==6 and 3 or game==7 and 2.5 or game==8 and 2.5 or 1) or (game==10 and 5 or 7)
                n=n>0 and max(1,floor(n/divisor)) or 0
            end
            if n>0 then Damage(o,n) end
        end
    end
end
function P.clear(reason,x,y,radius,box)
    local s=P.state();if not s then return end
    local dropped=0
    local kind=reason~='death' and (reason=='border' and s.game==7 and 'cherry_small' or s.game==10 and 'faith_minor' or 'star')
    local function inside(px,py)
        if box then return abs(px-x)<=box[1]/2 and abs(py-y)<=box[2]/2 end
        return not radius or Dist(x,y,px,py)<=radius
    end
    object.BulletIndesDo(function(o)
        if not live(o) or o.group==GROUP.GHOST or o.group==GROUP.PLAYER_BULLET then return end
        local V=OriginalBulletVisual
        if o.IsLaser and not o.IsBentLaser and V and V.cancel_laser then
            if o._native_cancelled or V.laser_protected(o) then return end
            local length=(o.l1 or 0)+(o.l2 or 0)+(o.l3 or 0)
            local hit=not radius and not box
            if radius then
                local co,si=cos(o.rot),sin(o.rot)
                local r=max(0,min(length,(x-o.x)*co+(y-o.y)*si))
                hit=inside(o.x+co*r,o.y+si*r)
            elseif box then
                local low,high=0,length
                for _,axis in ipairs({{o.x-x,cos(o.rot),box[1]/2},{o.y-y,sin(o.rot),box[2]/2}}) do
                    local d,v,h=unpack(axis)
                    if abs(v)<1e-8 then if abs(d)>h then high=-1 end
                    else local a,b=(-h-d)/v,(h-d)/v;low=max(low,min(a,b));high=min(high,max(a,b)) end
                end
                hit=low<=high
            end
            if hit then
                if kind then V.laser_drops(o,function(px,py) P.spawnItem(kind,px,py,{auto=true});dropped=dropped+1 end) end
                V.cancel_laser(o,false)
            end
            return
        end
        if o.IsLaser or o.IsBentLaser or not o.imgclass or not o.colli or not inside(o.x,o.y) then return end
        local force=reason=='power'
        if V and V.can_cancel and not V.can_cancel(o,force) then return end
        if not force and s.game==8 and V and V.spawn_remaining and V.spawn_remaining(o)>0 and V.cancel_bullet then
            if not o._sequence_cancel_item then o._sequence_cancel_item={kind=kind};V.cancel_bullet(o,'Del') end
            return
        end
        if kind then P.spawnItem(kind,o.x,o.y,{auto=true}) end
        o._sequence_cancel_item=nil;o._original_global_cancel=force;dropped=dropped+1;object.Del(o)
    end)
    return dropped
end
local itemImages={power=1,power_big=1,full=1,point=2,point_small=2,faith=5,faith_minor=8,
    cherry=11,cherry_small=11,star=8,bomb=9,life=7,time=8,faith_small=8,point_full=2}
local function pickupVM(kind)
    local game=P.game()
    local codes=game==10 and {power=1,power_big=4,point=2,point_full=5,faith=3,faith_minor=8,faith_small=9,life=7}
        or {power=0,point=1,power_big=2,bomb=3,full=4,life=5,star=6,cherry=7,cherry_small=8,time=7,point_small=8}
    local code=codes[kind];if not code then return end
    if game==6 then return animation(6,'etama3',21+code)
    elseif game==7 then return animation(7,'etama',196+code)
    elseif game==8 then return OriginalANM.new(8,'etama',61+code)
    elseif game==10 then return animation(10,'bullet',374+code) end
end
class.pickup=Class(object,{
    init=function(o,kind,x,y,flags)
        local limit=P.game()==10 and 192 or 184
        o._is_pickup=true;o.original_kind=kind;o.x=max(-limit,min(limit,x));o.y=y
        o.original_full=flags and flags.auto==true
        o.group=GROUP.ITEM;o.layer=LAYER.ITEM or -300;o.bound=false
        o.a,o.b=8,8;o.vx,o.vy=0,0;o.motion_x,o.motion_y=0,2.2;o.attract=flags and flags.auto and 8 or 0
        if flags and flags.velocity then o.motion_x,o.motion_y=flags.velocity[1],flags.velocity[2] end
        if P.game()==8 and kind=='time' then
            o.original_time_motion=true;o.original_time_apex=flags and flags.apex
            o.motion_x,o.motion_y=ran:Float(-.6,.6),2+ran:Float(0,.2);o.attract=0
        end
        o.img='item'..assert(itemImages[kind]);o.imgup='item_up'..itemImages[kind]
        o.original_vm=pickupVM(kind)
        if P.game()==7 and live(player) then
            local pool=player.original_items or {};player.original_items=pool
            local index=player.original_item_next or 0
            for _=1,1100 do if not live(pool[index]) then break end;index=(index+1)%1100 end
            o.original_pool_index=index;pool[index]=o;player.original_item_next=(index+1)%1100
        end
        o.target=player;o.original_age=0
        if kind=='power_big' or kind=='full' then o.hscale,o.vscale=1.4,1.4 end
        if flags and flags.death and P.game()~=10 then
            o.original_death={x=o.x,y=o.y,tx=ran:Float(-144,144),ty=224-ran:Float(-64,128)}
        end
    end,
    frame=function(o)
        if not P.enabled() then object.RawDel(o);return end
        local p=player;local s=P.state();o.original_age=o.original_age+1
        vmStep(o.original_vm)
        if not live(p) then return end
        local d=p.original_data
        if not d then object.RawDel(o);return end
        local radius=s.game==6 and 20 or s.game==7 and 12+d.collect/2 or s.game==10 and d.collect/2 or d.collect
        o.a,o.b,o.rect=radius-p.A,radius-p.B,true
        local itemSpeed=s.game==8 and P.data(8,p.__slow_flag and p.original_machine.secondary or p.original_machine.primary).item_speed or 1
        local death=o.original_death
        if death and o.original_age<=60 then
            local t=o.original_age/60;o.x=death.x+(death.tx-death.x)*t;o.y=death.y+(death.ty-death.y)*t;o.vy=0
            return
        end
        if o.original_time_motion then
            o.motion_y=o.motion_y-.05;o.x,o.y=o.x+o.motion_x*itemSpeed,o.y+o.motion_y*itemSpeed
            if p.death~=0 then o.original_time_motion=nil;o.motion_x,o.motion_y=0,.7;o.attract=0
            elseif o.motion_y<0 or not o.original_time_apex and p.original_shot_time<0 then o.original_time_motion=nil;o.attract=8 end
            return
        end
        local can=p.death==0 and not p.dialog
        local extra=not lstg.var.sequence_key:find('lunatic',1,true)
        local collect=can and (s.border>0 or p.y>224-(d.poc or 128) and (s.game==10 or s.power>=128 or s.game==7 and extra or s.game==8 and (p.__slow_flag or s.machine=='team1' or s.machine=='solo1')))
        if collect then o.attract=8;if s.game==10 or s.game==7 and s.border>0 then o.original_full=true end end
        local pull=p.__slow_flag and d.focus_collect or d.collect or 24
        local near=s.game==10 and can and abs(p.x-o.x)<pull and abs(p.y-o.y)<pull
        local dx,dy
        if o.attract>=8 or near then
            o.attract=8;o.attract_speed=o.attract_speed or ((d.attract or 8)*(s.game==10 and not o.original_full and 1/3 or 1))
            local a=Angle(o,p);o.motion_x,o.motion_y=o.attract_speed*cos(a),o.attract_speed*sin(a)
            if s.game==10 then o.attract_speed=min(12,o.attract_speed+.2) end
            if not can and s.game==10 then o.attract=0;o.motion_x,o.motion_y=0,0 end
            dx,dy=o.motion_x,o.motion_y
        else
            dx,dy=o.motion_x,o.motion_y
            o.motion_y=max(s.game==10 and -2 or -3,o.motion_y-.03*itemSpeed)
            if o.motion_y<=0 then o.motion_x=0 end
        end
        local scale=s.game==8 and o.attract<8 and itemSpeed or 1
        o.x,o.y=o.x+dx*scale,o.y+dy*scale
        if o.y < (s.game==10 and -248 or -240) then object.RawDel(o) end
    end,
    render=function(o)
        if o.original_vm then draw(o.original_vm,o.x,min(216,o.y));return end
        if o.y>224 then Render(o.imgup,o.x,216,0,o.hscale,o.vscale)
        else SetImageState(o.img,'',255,255,255,255);DefaultRenderFunc(o) end
    end,
    colli=function(o,p)
        if p~=player or p.death~=0 or o.original_collected or o.original_time_motion then return end
        o.original_collected=true;P.collect(o.original_kind,o.y,o.original_full,o.original_pool_index)
        PlaySound('item00',.3,o.x/200);object.RawDel(o)
    end,
})
function P.spawnItem(kind,x,y,flags)
    if not P.enabled() then return end
    local game=P.game();local s=P.state()
    if game==95 then return end
    if s.power>=(game==10 and 100 or 128) and (kind=='power' or kind=='power_big') then
        if game==7 then kind='cherry' elseif game==8 then kind='point_small' elseif game==10 then kind='faith_small' end
    end
    return New(class.pickup,kind,x,y,flags)
end
function P.fullPowerTransition(kind)
    local game=P.game();local spell=false
    for _,b in ipairs(boss_group or {}) do if live(b) and b.is_sc and b.is_combat then spell=true;break end end
    if game==6 or kind=='full' or not spell then P.clear('power') end
    if game==7 or game==8 then
        for _,o in ObjList(GROUP.ITEM) do
            if o._is_pickup and not o.original_collected and (o.original_kind=='power' or o.original_kind=='power_big') then
                o.original_kind=game==7 and 'cherry' or 'point_small';o.original_vm=pickupVM(o.original_kind)
                if o.motion_y<.5 then o.motion_x,o.motion_y=0,.5 end
            end
        end
    end
end
function P.deathDrops(p)
    local s=P.state();local pos=p.original_drop_origin or p
    if s.game==10 then
        s.power=max(0,s.power-64)
        -- Player.cpp:2091以自机上方224像素为扇形轴，7枚各隔0.1121997386弧度，初速3。
        local base=atan2(224,-pos.x)+22.5
        for i=0,6 do
            local a=base-i*.11219973862171173*180/math.pi
            P.spawnItem((i==1 or i==3 or i==5) and 'power_big' or 'power',pos.x,pos.y,
                {death=true,velocity={3*cos(a),3*sin(a)}})
        end
        p.original_drop_origin=nil
    else
        for i=1,(s.lives<0 and 5 or 6) do P.spawnItem(s.lives<0 and 'full' or i==1 and 'power_big' or 'power',pos.x,pos.y,{death=true}) end
    end
    P.sync()
end
function P.dropCode(code,x,y)
    local game=P.game()
    if game==10 and (code==10 or code==11) and P.state().power>=100 then return P.spawnItem('point_full',x,y) end
    local kinds=game==10 and {[1]='power',[2]='point',[3]='faith',[4]='power_big',[5]='point_full',[7]='life',[8]='faith_minor',[9]='faith_small',[10]='power',[11]='power_big'}
        or {[0]='power',[1]='point',[2]='power_big',[3]='bomb',[4]='full',[5]='life',[6]='star',[7]=game==7 and 'cherry' or 'time',[8]=game==7 and 'cherry_small' or 'point_small'}
    if kinds[code] then return P.spawnItem(kinds[code],x,y) end
end
function P.dropPFP(x,y,drop)
    if drop.original_code then return P.dropCode(drop.original_code,x,y) end
    local n=(drop[1] or 0)+(drop[2] or 0)+(drop[3] or 0)
    local radius=sqrt(max(0,n-1))*5
    for index=1,3 do
        for _=1,(drop[index] or 0) do
            local a=ran:Float(0,360);local r=sqrt(ran:Float(1,4))*radius
            P.spawnItem(index==3 and 'point' or index==1 and 'power_big' or 'power',x+r*cos(a),y+r*sin(a))
        end
    end
end
function P.itemAlias(cls,...)
    if not P.enabled() then return end
    local x,y=...;local kind
    for key,value in pairs(item.obj) do if value==cls then kind=key;break end end
    local map={faith=P.game()==10 and 'faith' or 'power',point='point',sakura='cherry',faith_minor='star',
        signal='faith_minor',addcharge='bomb',addmisscount='life',graze='star'}
    if map[kind] then return P.spawnItem(map[kind],x,y) end
end
local th10Drops=dofile('mod/GAME/original/players/th10_drops.lua')
function P.dropOriginalEnemy(o)
    if not P.enabled() or P.game()~=10 then return false end
    local source=o._original_source
    local profile=source and th10Drops[source.key]
    if not profile then return false end
    if o._sequence_loot_done then return true end
    o._sequence_loot_done=true
    -- enmCreate的逐只出生参数先写主掉落，只有dropMain才覆盖它。
    local main=not profile.main_override and o.drop_tbl and o.drop_tbl.original_code or profile.main
    if main>0 then P.dropCode(main,o.x,o.y) end
    P.addScore(profile.score or 0)
    local a=ran:Float(-180,180)
    for code=1,11 do for _=1,(profile.extra[code] or 0) do
        local scale=ran:Float(.5,1)
        P.dropCode(code,o.x+cos(a)*profile.area[1]*scale,o.y+sin(a)*profile.area[2]*scale)
        a=a+90+ran:Float(-45,45)
    end end
    P.state().faith_timer=min(130,P.state().faith_timer+10)
    return true
end
function P.shotHit(enemy,shot)
    if not shot.original_player then return false end
    P.hitEnemy(enemy,shot.original_damage,false)
    if not shot.killflag then object.Kill(shot) end
    return true
end
local function rowsFor(p)
    local s=P.state();local m=p.original_machine
    local data=P.data(s.game,p.__slow_flag and m.secondary or m.primary)
    if s.game==8 and s.bomb and s.bomb.spec.character==6 and s.bomb.time>=60 then
        return assert(P.data(8,'ply02as').levels[s.bomb.spec.death and 8 or 7],'缺少蕾米莉亚原作Bomb射击表').shots
    end
    if s.game==10 then return data.levels[min(4,floor(s.power/20))+1+(p.__slow_flag and 5 or 0)].shots end
    local row=data.levels[#data.levels]
    if s.game==6 then
        for i=#data.levels,1,-1 do if s.power>=data.levels[i].power then row=data.levels[i];break end end
    else
        for _,candidate in ipairs(data.levels) do if s.power<candidate.power then row=candidate;break end end
    end
    return row.shots
end
P.rowsFor=rowsFor
local function options(p)
    return P.updateOptions(p)
end
function P.collide(p,other)
    if p.death~=0 or p.dialog then return end
    if p.protect>0 then return end
    local s=P.state()
    if s.border>0 then
        P.breakBorder(p,false);return true
    end
    p.original_deathbomb=p.original_game==10 and 8 or p.original_data.deathbomb or 6
    if s.game==8 then
        s.gauge,s.human=0,0
        local quota=({['1']=3000,['2']=7200,['3']=8800,['4A']=9999,['4B']=8500,['5']=9999})[s.stage_name or '1'] or 0
        local window=s.bombs>0 and min(15,s.bombs*6+(s.time>=quota and 7 or 0)) or 2
        local spell=false
        for _,b in ipairs(boss_group or {}) do if live(b) and b.is_sc and b.is_combat then spell=true;break end end
        if s.bombs>0 and spell then window=min(30,window*2);p.original_death_freeze=true end
        if s.bombs>0 and (s.machine=='team0' or s.machine=='solo0' or s.machine=='solo4') then window=floor(window*9/5) end
        p.original_deathbomb=window
    end
    p.death=90
    item.ClearBossBonus()
    if other.imgclass then object.Del(other) end
    return true
end
local function move(p,key)
    local speed=p.__slow_flag and p.lspeed or p.hspeed
    local dx=(key.right and 1 or 0)-(key.left and 1 or 0)
    local dy=(key.up and 1 or 0)-(key.down and 1 or 0)
    if dx~=0 and dy~=0 then
        local data=P.data(p.original_game,p.__slow_flag and p.original_machine.secondary or p.original_machine.primary)
        speed=(p.__slow_flag and data.diagonal_slow or data.diagonal) or speed*2^-.5
    end
    dx,dy=dx*speed,dy*speed
    if TouchInputMovement then local tx,ty=TouchInputMovement(p,p.key or KeyState,speed);if tx then dx,dy=tx,ty end end
    local rate=(p.th08_move_time_scale or 1)*(p.original_bomb_speed or 1)
    dx,dy=dx*rate,dy*rate
    if p.original_game==10 then
        local function fixed(v) return (v<0 and math.ceil(v*100) or floor(v*100))/100 end
        dx,dy=fixed(dx),fixed(dy)
    end
    p.x=max(-184,min(184,p.x+dx));p.y=max(-208,min(p.original_game==10 and 192 or 208,p.y+dy))
    p.__move_dx,p.__move_dy=dx,dy
end
function P.breakBorder(p,natural)
    local s=P.state()
    if natural then
        s.cherry_max=min(9999990,s.cherry_max+10000);P.cherry(10000,false);P.addScore(s.cherry*10)
    else item.ClearBossBonus();s.border_cancel={x=p.x,y=p.y,age=0} end
    s.border,s.cherry_plus,s.border_ready=0,0,nil;p.protect=max(p.protect or 0,40)
    P.sync()
end
function P.stepCherry(p)
    local s=P.state()
    if s.border_cancel then
        local c=s.border_cancel;P.clear('border',c.x,c.y,32+c.age*16)
        c.age=c.age+1;if c.age>=50 then s.border_cancel=nil end
    end
    if s.border>0 then
        s.border=s.border-1;s.cherry_plus=floor(s.border*50000/540)
        if s.border==0 then P.breakBorder(p,true) end
    elseif s.cherry_plus>=50000 then
        s.border_ready=true
        if p.death==0 and (p.protect or 0)<=0 and not p.dialog and not s.bomb then
            s.border,s.border_ready=540,nil
        end
    end
end
local function resourceStep(p)
    local s=P.state()
    if s.game==7 then P.stepCherry(p)
    elseif s.game==10 then
        s.stage_frames=(s.stage_frames or 0)+1
        local bossActive=false
        for _,b in ipairs(boss_group or {}) do if live(b) and b.is_combat then bossActive=true;break end end
        if not bossActive and not p.dialog and s.stage_frames>=90 then
            if s.faith_timer>0 then s.faith_timer=s.faith_timer-1
            elseif s.faith>50000 then s.faith=max(50000,s.faith-s.faith_decay);s.faith_decay=max(180,s.faith_decay) end
        end
    end
    if s.game==8 then P.gaugeStep(p) end
    P.sync()
end
class.player=Class(player_class,{
    init=function(p)
        player_class.init(p)
        local s=assert(P.state());local m=assert(P.machine(s.game,s.machine));local d=P.data(s.game,m.primary)
        p.original_game,p.original_machine,p.original_data=s.game,m,d
        p.original_archive=archive(m,s.game);p.original_focus=0;p.original_options={};p.original_lasers={}
        p.original_shot_time=-1;p.original_direction=0
        p.name=({'Reimu','Marisa','Sakuya','Youmu'})[m.character+1]
        p.hspeed,p.lspeed=d.speed,P.data(s.game,m.secondary).slow
        p.A,p.B=(d.hitbox or 4)/2,(d.hitbox or 4)/2;p.a,p.b=p.A,p.B;p.rect=true
        p.collect_line=224-(d.poc or 128)
        p.original_vm=animation(s.game,p.original_archive,0)
        if s.game==10 then p.x,p.y=0,-256;p.original_entry=0 end
        p._wisys={frame=function() end,render=function() end}
        if live(p.grazer) then
            -- 原作红魔乡为弹框外扩48；妖/永为SHT擦弹半框再外扩20，均为AABB。
            p.grazer.a=s.game==6 and p.A+48 or (d.graze or 0)/2+20
            p.grazer.b=p.grazer.a;p.grazer.rect=true
        end
        options(p)
    end,
    frame=function(p)
        if not P.enabled() then return end
        if p.original_skip_frame then p.original_skip_frame=nil;return end
        P.flushDamage();task.Do(p)
        p._playersys:updateKeyState()
        local key=p._playersys.keyState
        local s=P.state()
        p.__slow_flag=s.game==8 and s.bomb and s.bomb.focus or key.slow
        if s.game==8 and s.bomb then p.__slow_flag=s.bomb.focus end
        p.__shoot_flag=key.shoot;p.slow=p.__slow_flag and 1 or 0
        if scoredata and not ext.replay.IsReplay() then
            scoredata.OriginalSequencePlayFrames=scoredata.OriginalSequencePlayFrames or {}
            local frames=scoredata.OriginalSequencePlayFrames
            frames[s.game]=(frames[s.game] or 0)+1
        end
        if p.original_drop_delay then
            p.original_drop_delay=p.original_drop_delay-1
            if p.original_drop_delay==0 then p.original_drop_delay=nil;P.deathDrops(p) end
        end
        if p.protect>0 then p.protect=p.protect-1 end
        if p.original_deathbomb then
            if P.bombInput(p,key,p._playersys.keyStatePre,true) then
                p.original_deathbomb=nil;p.original_death_freeze=nil;p.death=0
                if s.game==8 then
                    p.__slow_flag=s.bomb.focus;p.slow=p.__slow_flag and 1 or 0
                    move(p,key);P.updateShotTargets(p);options(p)
                end
            else
                if s.game==8 then
                    if s.time>=15 then s.time=s.time-15;s.total_time=(s.total_time or 0)-15 else s.time=0 end
                end
                p.original_deathbomb=p.original_deathbomb-1
                if p.original_deathbomb<=0 then
                    p.original_deathbomb=nil;p.original_death_freeze=nil;P.miss(p);p.original_respawn=s.game==10 and 30 or 60
                    New(player_death_ef,p.x,p.y);PlaySound('pldead00',.5);P.clear('death',p.x,p.y,64)
                end
            end
        elseif p.original_respawn then
            p.original_respawn=p.original_respawn-1
            if s.game==10 then P.clear('death',p.x,p.y,64+(30-p.original_respawn)*17.066667556762695) end
            if p.original_respawn==0 then
                p.original_respawn=nil
                if s.lives>=0 then
                    p.death=0;p.x,p.y=0,-176;p.protect=s.game==10 and 280 or 180
                    if s.game==10 then p.original_entry=0;p.y=-256 end
                end
            end
        elseif p.original_entry then
            p.original_entry=p.original_entry+1;p.y=-256+math.floor(p.original_entry*8000/60)/100
            options(p)
            if p.original_entry>=60 then p.original_entry=nil end
        elseif not p.lock and not p.dialog then
            P.bombInput(p,key,p._playersys.keyStatePre,false)
            if s.game==8 and s.bomb then p.__slow_flag=s.bomb.focus;p.slow=p.__slow_flag and 1 or 0 end
            move(p,key);P.updateShotTargets(p);options(p)
        end
        P.updateShooting(p,key.shoot,p.death==0 and not p.original_entry and not p.lock and not p.dialog)
        P.stepBomb(p);resourceStep(p)
        if live(p.grazer) then p.grazer.colli=p.death==0 and s.game~=10 end
        p.lh=max(0,min(1,p.lh+(p.slow==1 and .15 or -.15)))
        local direction=key.left and 1 or key.right and 3 or 0
        if direction==0 then
            local old=p.original_direction%5
            -- 停止姿态脚本自身接回站立循环，不能在八帧后强行重播idle。
            if old==1 or old==3 then direction=old+1 elseif old==2 or old==4 then direction=old end
        end
        if s.game==8 and (p.original_machine.id:sub(1,4)=='team' and p.__slow_flag or p.original_machine.id:sub(1,4)=='solo' and p.original_machine.shot==1) then direction=direction+5 end
        if direction~=p.original_direction then p.original_direction=direction;p.original_vm=animation(s.game,p.original_archive,direction) end
        vmStep(p.original_vm)
        P.updateFocusVisual(p)
        if ApplyPendingTouchMovement then ApplyPendingTouchMovement(p) end
    end,
    render=function(p)
        P.renderFocusVisual(p)
        if p.original_respawn or p.death~=0 and not p.original_deathbomb then return end
        P.renderOptions(p)
        draw(p.original_vm,p.x,p.y,p.protect>0 and p.timer%4<2 and 100 or 255)
        P.renderBomb(p)
    end,
    colli=function(p,other) return P.collide(p,other) end,
    del=function(p)
        if live(p.grazer) then object.RawDel(p.grazer) end
        for o in pairs(p.original_shots or {}) do if live(o) then object.RawDel(o) end end
    end,
})
function P.spawnPlayer()
    pending={}
    if P.resetShotHits then P.resetShotHits() end
    if P.game()==95 then return New(aya_player) end
    return New(class.player)
end
function P.deathbombFrame()
    if not P.enabled() or not live(player) or not player.original_death_freeze or not player.original_deathbomb then return false end
    player.class.frame(player)
    if not player.original_death_freeze then player.original_skip_frame=true;return false end
    return true
end
Include('THlib\\sequence_options.lua')
Include('THlib\\sequence_shots.lua')
Include('THlib\\sequence_fire.lua')
Include('THlib\\sequence_bomb.lua')
Include('THlib\\sequence_continue.lua')
return P
