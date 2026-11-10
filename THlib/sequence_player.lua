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
local function draw(vm,x,y,alpha) if vm then OriginalANM.draw(vm,x,y,0,1,1,alpha or 255) end end
local function eachEnemy(fn)
    object.EnemyNontjtDo(function(o)
        -- 风神录的出生减伤阻止扣血，仍需让命中的普通弹转入消散。
        if live(o) and o.colli and (not o.protect or P.game()==10) and o.hp and o.hp>0 then fn(o) end
    end)
end
-- 先汇总同帧命中，再做原作的封顶和整数符卡减伤；否则多路细弹会被逐颗取整放大。
local pending={}
function P.hitEnemy(o,amount,bomb)
    if not live(o) or o.protect then return end
    local r=pending[o]
    if not r then r={shot=0,bomb=0,card=o.current_card};pending[o]=r end
    local key=bomb and 'bomb' or 'shot';r[key]=r[key]+amount
end
function P.flushDamage()
    local game=P.game()
    for o,r in pairs(pending) do
        pending[o]=nil
        if live(o) and not o.protect and o.current_card==r.card then
            local n=r.shot+r.bomb
            if game==7 then P.hitDamage(n,player,o) end
            if game==6 or game==7 or game==8 then n=min(70,n) end
            -- 风神录这里直接递增以10分为单位的分数存储，而非GuiScore.Add的显示分。
            P.addScore(game==10 and floor((floor(n/10)+10)/10)*10 or floor(n/5)*10)
            if o.is_sc then
                local divisor=r.bomb>0 and (game==6 and 3 or game==7 and 2.5 or 1) or (game==10 and 5 or 7)
                n=n>0 and max(1,floor(n/divisor)) or 0
            end
            if n>0 then Damage(o,n) end
        end
    end
end
function P.clear(reason,x,y,radius)
    local s=P.state();if not s then return end
    local dropped=0
    object.BulletIndesDo(function(o)
        if live(o) and o.group~=GROUP.GHOST and o.group~=GROUP.PLAYER_BULLET
            and not o.IsLaser and not o.IsBentLaser and (not radius or Dist(x,y,o.x,o.y)<=radius) then
            if OriginalBulletVisual and OriginalBulletVisual.can_cancel and not OriginalBulletVisual.can_cancel(o) then return end
            if o.imgclass and o.colli then
                if reason~='death' then
                    P.spawnItem(s.game==10 and 'faith_minor' or s.game==8 and 'time' or 'star',o.x,o.y,{auto=true})
                end
                dropped=dropped+1;object.Del(o)
            end
        end
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
        o._is_pickup=true;o.original_kind=kind;o.x=max(-184,min(184,x));o.y=y
        o.group=GROUP.ITEM;o.layer=LAYER.ITEM or -300;o.bound=false
        o.a,o.b=8,8;o.vy=2.2;o.attract=flags and flags.auto and 8 or 0
        o.img='item'..assert(itemImages[kind]);o.imgup='item_up'..itemImages[kind]
        o.original_vm=pickupVM(kind)
        o.target=player;o.original_age=0
        if kind=='power_big' or kind=='full' then o.hscale,o.vscale=1.4,1.4 end
        if flags and flags.death then
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
        local death=o.original_death
        if death and o.original_age<=60 then
            local t=o.original_age/60;o.x=death.x+(death.tx-death.x)*t;o.y=death.y+(death.ty-death.y)*t;o.vy=0
            return
        end
        local can=p.death==0 and not p.dialog
        local collect=can and (s.border>0 or p.y>224-(d.poc or 128) and (s.game~=6 and s.game~=8 or s.power>=128 or s.game==8 and p.__slow_flag))
        if collect then o.attract=8 end
        local near=can and abs(p.x-o.x)<(d.collect or 24) and abs(p.y-o.y)<(d.collect or 24)
        if o.attract>=8 or near then
            o.attract=8;SetV(o,d.attract or 8,Angle(o,p))
        else o.vx=0;o.vy=max(-3,o.vy-.03) end
        if o.y < -240 then object.RawDel(o) end
    end,
    render=function(o)
        if o.original_vm then draw(o.original_vm,o.x,min(216,o.y));return end
        if o.y>224 then Render(o.imgup,o.x,216,0,o.hscale,o.vscale)
        else SetImageState(o.img,'',255,255,255,255);DefaultRenderFunc(o) end
    end,
    colli=function(o,p)
        if p~=player or p.death~=0 or o.original_collected then return end
        o.original_collected=true;P.collect(o.original_kind,o.y,o.attract>=8)
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
local function shotVM(p,row)
    local id=row.animation
    if p.original_game==7 then id=id-1024 elseif p.original_game==8 then id=id+10 elseif p.original_game==10 then id=id+5 end
    return animation(p.original_game,p.original_archive,id)
end
local function optionPosition(p,index)
    local pos=p.original_options[index];return pos and pos[1] or p.x,pos and pos[2] or p.y
end
local function closest(o)
    local target,distance
    eachEnemy(function(e) local d=Dist(o,e);if not distance or d<distance then target,distance=e,d end end)
    return target
end
class.shot=Class(object,{
    init=function(o,p,row)
        o.original_player=p;o.row=row;o.x,o.y=p.x,p.y
        if row.option>0 then o.x,o.y=optionPosition(p,row.option) end
        o.x,o.y=o.x+row.x,o.y-row.y
        o.rot=row.angle;o.dmg=row.damage;o.original_damage=row.damage
        o.a,o.b=row.hx/2,row.hy/2;o.rect=true
        o.group=GROUP.GHOST;o.colli=false;o.layer=LAYER.PLAYER_BULLET;o.vm=shotVM(p,row)
        o.original_kind=p.original_game==8 and row.shot or row.kind
        o.original_age=0;o.bound=true
        if o.original_kind==4 or o.original_kind==5 or p.original_game==6 and row.kind==3 or p.original_game==10 and row.kind==3 then
            o.original_laser=true;o.killflag=true;o.bound=false
        else SetV(o,row.speed,row.angle) end
    end,
    frame=function(o)
        o.original_age=o.original_age+1
        local p=o.original_player;if not live(p) or not P.enabled() then object.RawDel(o);return end
        local row=o.row;local game=p.original_game
        if o.original_laser then
            if not p.__shoot_flag or p.death~=0 or p.original_rows~=o.original_rows then object.RawDel(o);return end
            o.x,o.y=optionPosition(p,row.option);o.x,o.y=o.x+row.x,o.y-row.y
            o.group=GROUP.GHOST
            local gap=game==10 and 4 or 2
            if o.original_age%gap==0 then
                local target,nearest
                eachEnemy(function(e)
                    local dx,dy=e.x-o.x,e.y-o.y
                    local across=abs(dx*sin(o.rot)-dy*cos(o.rot));local along=dx*cos(o.rot)+dy*sin(o.rot)
                    if along>=0 and across<row.hx/2+(e.a or 0) and (not nearest or along<nearest) then target,nearest=e,along end
                end)
                if target then P.hitEnemy(target,row.damage,false) end
            end
        elseif (game==6 and row.kind==1) or (game~=6 and (row.callbacks[2]==1 or row.callbacks[2]==2)) then
            local e=closest(o)
            if e then
                local delta=(Angle(o,e)-o.rot+180)%360-180
                o.rot=o.rot+max(-4,min(4,delta));SetV(o,row.speed,o.rot)
            end
        end
        if not o.original_laser and not o.original_hit then
            local target,nearest
            eachEnemy(function(e)
                local box=e._original_damage_box
                local ea,eb=box and box[1]/2 or e.a or 0,box and box[2]/2 or e.b or 0
                -- TH10普通弹的整个受弹框必须进入屏幕，激光才使用目标框裁剪。
                if (game~=10 or o.y+o.b<=224) and abs(o.x-e.x)<=o.a+ea and abs(o.y-e.y)<=o.b+eb then
                    local distance=Dist(o,e);if not nearest or distance<nearest then target,nearest=e,distance end
                end
            end)
            if target then
                P.hitEnemy(target,o.original_damage,false)
                if game==6 and o.original_kind==2 or (game==7 or game==8) and o.original_kind==3 or game==10 and o.original_kind==2 then
                    o.original_hit=target;o.vx,o.vy=0,0;o.original_hit_age=0
                else object.RawDel(o);return end
            end
        elseif o.original_hit then
            o.original_hit_age=o.original_hit_age+1
            local gap=game==10 and 4 or 2
            if o.original_hit_age%gap==0 and live(o.original_hit) then
                o.original_damage=max(1,floor(o.original_damage/(game==6 and 4 or 3)))
                P.hitEnemy(o.original_hit,o.original_damage,false)
            end
            if o.original_hit_age>=(game==6 and 45 or game==7 and 45 or game==8 and 20 or 13) then object.RawDel(o);return end
        end
        vmStep(o.vm)
    end,
    render=function(o)
        -- 原作Player的DrawActiveShots会在ANM的随弹旋转标志开启时覆盖Z角。
        -- 红/妖以竖直贴图为基准，永/风以横向贴图为基准；不能一律传0。
        local rotation=P.shotRotation(o)
        OriginalANM.draw(o.vm,o.x,o.y,0,1,1,255,nil,nil,rotation)
    end,
    kill=function(o) o.colli=false end,
})
function P.shotRotation(o)
    if not o.vm.follow then return nil end
    return o.rot-((o.original_player.original_game==6 or o.original_player.original_game==7) and 90 or 0)
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
function P.shoot(p)
    local rows=rowsFor(p);p.original_rows=rows
    for _,row in ipairs(rows) do
        local laser=(p.original_game==8 and (row.shot==4 or row.shot==5)) or (p.original_game==7 and (row.kind==4 or row.kind==5))
            or p.original_game==6 and row.kind==3 or p.original_game==10 and row.kind==3
        if laser then
            if not live(p.original_lasers[row]) then
                local o=New(class.shot,p,row);o.original_rows=rows;p.original_lasers[row]=o
            end
        elseif not (p.original_game==8 and P.state().bomb and (row.callbacks[1]==2 or row.callbacks[1]==3))
            and p.original_shot_time%row.interval==row.frame then New(class.shot,p,row) end
    end
    if p.original_shot_time%5==0 then PlaySound('plst00',.15,p.x/1024) end
end
local function options(p)
    local s=P.state();local t=p.original_focus
    t=max(0,min(8,t+(p.__slow_flag and 1 or -1)));p.original_focus=t
    local x=24-16*(t/8)^2;local y=32*t/8
    p.original_options={{p.x-x,p.y+y},{p.x+x,p.y+y}}
    if s.game==10 then
        local data=p.original_data;local n=min(4,floor(s.power/20))
        local base=(n*(n-1)/2)+(p.__slow_flag and 15 or 0)
        p.original_options={}
        for i=1,n do local o=data.options[base+i];p.original_options[i]={p.x+o[1],p.y-o[2]} end
    end
end
function P.collide(p,other)
    if p.death~=0 or p.dialog then return end
    if p.protect>0 then return end
    local s=P.state()
    if s.border>0 then
        s.border,s.cherry_plus=0,0;p.protect=40;P.clear('border');P.sync();return true
    end
    p.original_deathbomb=p.original_game==10 and 8 or p.original_data.deathbomb or 6
    p.death=90
    item.ClearBossBonus()
    if other.imgclass then object.Del(other) end
    return true
end
local function move(p,key)
    local speed=key.slow and p.lspeed or p.hspeed
    local dx=(key.right and 1 or 0)-(key.left and 1 or 0)
    local dy=(key.up and 1 or 0)-(key.down and 1 or 0)
    if dx~=0 and dy~=0 then speed=speed*2^-.5 end
    dx,dy=dx*speed,dy*speed
    if TouchInputMovement then local tx,ty=TouchInputMovement(p,p.key or KeyState,speed);if tx then dx,dy=tx,ty end end
    local rate=(p.th08_move_time_scale or 1)*(p.original_bomb_speed or 1)
    p.x=max(-184,min(184,p.x+dx*rate));p.y=max(-208,min(208,p.y+dy*rate))
    p.__move_dx,p.__move_dy=dx,dy
end
local function resourceStep(p)
    local s=P.state()
    if s.game==7 then
        if s.border>0 then
            s.border=s.border-1;s.cherry_plus=floor(s.border*50000/540)
            if s.border==0 then s.cherry_max=s.cherry_max+10000;P.cherry(10000,false);P.addScore(s.cherry*10);p.protect=max(p.protect,40) end
        elseif s.cherry_plus>=50000 and p.death==0 then s.border=540 end
    elseif s.game==10 then
        if s.faith_timer>0 then s.faith_timer=s.faith_timer-1
        elseif s.faith>50000 then s.faith=max(50000,s.faith-s.faith_decay);s.faith_decay=max(180,s.faith_decay) end
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
        p.original_shot_time=0;p.original_direction=0
        p.name=({'Reimu','Marisa','Sakuya','Youmu'})[m.character+1]
        p.hspeed,p.lspeed=d.speed,P.data(s.game,m.secondary).slow
        p.A,p.B=(d.hitbox or 4)/2,(d.hitbox or 4)/2;p.a,p.b=p.A,p.B;p.rect=true
        p.collect_line=224-(d.poc or 128)
        p.original_vm=animation(s.game,p.original_archive,0)
        p._wisys={frame=function() end,render=function() end}
        options(p)
    end,
    frame=function(p)
        if not P.enabled() then return end
        P.flushDamage();task.Do(p)
        p._playersys:updateKeyState()
        local key=p._playersys.keyState
        p.__slow_flag=key.slow;p.__shoot_flag=key.shoot;p.slow=key.slow and 1 or 0
        local s=P.state()
        if p.protect>0 then p.protect=p.protect-1 end
        if p.original_deathbomb then
            if P.bombInput(p,key,p._playersys.keyStatePre,true) then p.original_deathbomb=nil;p.death=0
            else
                p.original_deathbomb=p.original_deathbomb-1
                if p.original_deathbomb<=0 then
                    p.original_deathbomb=nil;P.miss(p);p.original_respawn=60
                    New(player_death_ef,p.x,p.y);PlaySound('pldead00',.5);P.clear('death',p.x,p.y,64)
                end
            end
        elseif p.original_respawn then
            p.original_respawn=p.original_respawn-1
            if p.original_respawn==0 then p.original_respawn=nil;p.death=0;p.x,p.y=0,-176;p.protect=180 end
        elseif not p.lock and not p.dialog then
            P.bombInput(p,key,p._playersys.keyStatePre,false)
            move(p,key);options(p)
            if key.shoot then P.shoot(p);p.original_shot_time=(p.original_shot_time+1)%(s.game==8 and 20 or s.game==10 and 15 or 30)
            else p.original_shot_time=0;p.original_rows=nil end
        end
        P.stepBomb(p);resourceStep(p)
        if live(p.grazer) then p.grazer.colli=p.death==0 end
        p.lh=max(0,min(1,p.lh+(p.slow==1 and .15 or -.15)))
        local direction=key.left and 1 or key.right and 3 or 0
        if s.game==8 and (p.original_machine.id:sub(1,4)=='team' and key.slow or p.original_machine.id:sub(1,4)=='solo' and p.original_machine.shot==1) then direction=direction+5 end
        if direction~=p.original_direction then p.original_direction=direction;p.original_vm=animation(s.game,p.original_archive,direction) end
        vmStep(p.original_vm)
        if ApplyPendingTouchMovement then ApplyPendingTouchMovement(p) end
    end,
    render=function(p)
        if p.original_respawn then return end
        draw(p.original_vm,p.x,p.y,p.protect>0 and p.timer%4<2 and 100 or 255)
        if p.slow==1 then Render('player_aura',p.x,p.y) end
        P.renderBomb(p)
    end,
    colli=function(p,other) return P.collide(p,other) end,
    del=function(p)
        if live(p.grazer) then object.RawDel(p.grazer) end
        for _,o in pairs(p.original_lasers or {}) do if live(o) then object.RawDel(o) end end
    end,
})
function P.spawnPlayer()
    pending={}
    if P.game()==95 then return New(aya_player) end
    return New(class.player)
end
Include('THlib\\sequence_bomb.lua')
return P
