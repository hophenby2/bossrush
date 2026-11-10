-- 红/妖/永的 Player::UpdateShots 与风神录 SHT 回调桥。
-- 速度和角度已在导出时翻转Y；回调里的加速度只能再翻转一次。
local P,A=SequenceResources,OriginalANM
local C=P.classes
local min,max,abs,floor,sqrt=math.min,math.max,math.abs,math.floor,math.sqrt
local function live(o) return o and IsValid(o) end
local collisionTarget,collisionBox
local regions={}
local function enemies(fn)
    if collisionTarget then fn(collisionTarget);return end
    object.EnemyNontjtDo(function(e)
        if live(e) and e.colli and e.hp and e.hp>0 and e._original_accepts_damage~=false
            and not (P.game()==8 and P.state().bomb and e._original_no_damage_during_bomb) then fn(e) end
    end)
end
function P.updateShotTargets(p)
    local target,boss,aim,option
    if p.original_game==10 and live(p.original_homing_target) and p.original_homing_target.hp>0 then return end
    enemies(function(e)
        if p.original_game==10 then if not target and abs(e.x)<=224 then target=e end;return end
        if p.original_game~=6 and e.IsBoss then
            if not boss or abs(e.x-p.x)<abs(boss.x-p.x) then boss=e end
        elseif not target or e.y<target.y then target=e end
        if p.original_game==7 then
            local a=Angle(p,e)
            if a>=60 and a<=120 and (not aim or e.IsBoss and not aim.IsBoss or e.IsBoss==aim.IsBoss and abs(e.x-p.x)<abs(aim.x-p.x)) then aim=e end
        elseif p.original_game==8 and abs(e.x-p.x)<64 and not e.original_attached_enemy then
            if not option or e.y>option.y then option=e end
        end
    end)
    p.original_homing_target=boss or target;p.original_aim_target=aim;p.original_option_target=option
end
local function origin(p,row)
    local v=p.original_options[row.option] or p.original_option_positions and p.original_option_positions[row.option]
    return (v and v[1] or p.x)+row.x,(v and v[2] or p.y)-row.y
end
local function velocity(o,speed,angle)
    o.rot,o.speed=angle,speed
    o.original_vx,o.original_vy=speed*cos(angle),speed*sin(angle)
    o.vx,o.vy=0,0
end
function P.shotRotation(o)
    if o.vm.follow then return o.rot-((o.original_player.original_game==6 or o.original_player.original_game==7) and 90 or 0) end
end
local function beam(o)
    local p,r,g=o.original_player,o.row,o.original_player.original_game
    local x,y=origin(p,r)
    if g==8 and r.callbacks[2]==5 then
        -- 爱丽丝的448×32横向精灵由ANM旋转90度；源程序只改变中心，不能再次旋转。
        o.x,o.y=x,y+208;o.a,o.b=r.hx/2,224
    elseif g==10 then
        -- SHT的-240已经把中心移到子机上方，重复加240会让半束激光飞出屏幕。
        o.x,o.y=x,y;o.a,o.b=r.hx/2,r.hy/2
    else
        local length=224-y
        if g==7 and r.kind==5 then x,y=p.x+r.x,p.y;length=224-y+64 end
        o.x,o.y=x,y+length/2;o.a,o.b=r.hx/2,length/2
        o.vm.scale[2]=length/14
    end
    if g<10 then o.x,o.y=o.x+r.speed*cos(r.angle),o.y+r.speed*sin(r.angle) end
    o.original_vx,o.original_vy=0,0
end
local function overlaps(o,e,x,y,a,b)
    local box=collisionBox or e._original_damage_box
    return abs((x or o.x)-e.x)<=(a or o.a)+(box and box[1]/2 or e.a or 0)
        and abs((y or o.y)-e.y)<=(b or o.b)+(box and box[2]/2 or e.b or 0)
end
local function regionHit(r,e)
    if r.circle then return Dist(r.x,r.y,e.x,e.y)<=r.w end
    local box=collisionBox or e._original_damage_box
    return abs(r.x-e.x)<=r.w/2+(box and box[1]/2 or e.a or 0)
        and abs(r.y-e.y)<=r.h/2+(box and box[2]/2 or e.b or 0)
end
function P.queueHitRegion(x,y,w,h,damage,bomb,circle)
    local r={x=x,y=y,w=w,h=h,damage=damage,bomb=bomb,circle=circle};regions[#regions+1]=r
    local hits=0;enemies(function(e) if regionHit(r,e) then hits=hits+damage end end)
    return hits
end
function P.resetShotHits() regions={};collisionTarget,collisionBox=nil,nil;P.secondaryHit=nil end
local function missileHit(o)
    local g,r=o.original_player.original_game,o.row
    local damage=o.original_damage
    if not o.original_hit then
        o.original_hit=true
        local size
        if g==6 then size=({[65]=32,[66]=42,[67]=48,[68]=48})[r.animation]
        elseif g==8 then size=({[2]=48,[4]=64,[6]=80,[8]=96,[10]=128})[r.animation]
        elseif g==7 then size=({[1089]=32,[1090]=42,[1091]=48,[1092]=56,[1093]=48,[1094]=64,[1095]=80,[1096]=96})[r.animation] end
        if size then
            o.a,o.b=size/2,size/2
            if g~=6 then velocity(o,g==7 and r.animation<1093 and 4 or 6,ran:Float(45,135)) end
        end
        local id=r.animation+(g==7 and -1024+32 or g==8 and 11 or 32)
        if g~=10 then o.vm=P.animation(g,o.original_player.original_archive,id) else A.interrupt(o.vm,1) end
    else
        if g~=6 then o.original_damage=max(1,floor(o.original_damage/3));o.original_vx,o.original_vy=o.original_vx*.88,o.original_vy*.88 end
    end
    if g==6 then o.original_damage=max(1,floor(damage/4));o.original_vx,o.original_vy=o.original_vx/8,o.original_vy/8;return damage end
    return o.original_damage
end
local function hitLaser(o,p,r,g)
    if o.original_hidden_until_update or g==10 and o.original_fade then return end
    local hitAge=o.original_age
    enemies(function(e)
        if (g~=10 or e.y-(e.b or 0)<=224) and overlaps(o,e) then
            if g==10 then
                o.original_collided_last=true
                if not o.original_collision_held then A.interrupt(o.vm,2);o.original_collision_held=true end
            end
            if g==10 and hitAge%4~=0 or (g==7 or g==8) and hitAge%2~=0 then return end
            local damage=o.original_damage
            if g<10 and P.state().bomb then damage=max(1,floor(damage/(g==8 and 5 or 3))) end
            P.hitEnemy(e,damage,false,g==8 and r.kind<0,false,o)
        end
    end)
end
local function hitShot(o,p,r,g)
    local hitAge=o.original_age
    local missile=(g==6 and r.kind==2) or (g==7 or g==8) and r.callbacks[4]==1
    local canhit=not o.original_hit or missile and (g==6 or hitAge%2==0)
    if canhit then
        enemies(function(target)
        if overlaps(o,target) and (not o.original_hit or missile or g==8 and r.shot==6) and (g~=10 or o.y+o.b<=224) then
            if not o.original_hit or g~=8 or not target.is_sc or hitAge%4==0 then
                local damage=missile and missileHit(o) or o.original_damage
                local b=P.state().bomb
                if b and g<10 then damage=max(1,floor(damage/(g==8 and 5 or 3))) end
                P.hitEnemy(target,damage,false,g==8 and r.kind<0,false,o)
                if not missile and not (g==8 and r.shot==6) then
                    o.original_hit=true;o.original_vx,o.original_vy=o.original_vx/8,o.original_vy/8
                    local rotation=o.vm.rotation[3]
                    o.vm=P.animation(g,p.original_archive,g==10 and assert(r.hit)+5 or r.animation+(g==7 and -1024+32 or g==8 and 11 or 32))
                    if g==8 or g==10 then o.vm.rotation[3]=rotation end
                    if g==10 and r.kind==2 then P.spawnShotBurst(p,o.x,o.y,floor(r.damage/3)) end
                end
            end
        end
        end)
    end
end
C.shot=Class(object,{
    init=function(o,p,row)
        local g=p.original_game
        o.original_player,o.row=p,row;o.x,o.y=origin(p,row)
        o.original_damage,o.dmg=row.damage,row.damage;o.a,o.b=row.hx/2,row.hy/2;o.rect=true
        o.group,o.colli,o.layer=GROUP.GHOST,false,LAYER.PLAYER_BULLET
        o.original_age,o.original_hit_age=0,0;o.bound=false
        local id=row.animation+(g==7 and -1024 or g==8 and 10 or g==10 and 5 or 0)
        o.vm=P.animation(g,p.original_archive,id)
        o.original_kind=g==8 and row.shot or row.kind
        o.original_laser=o.original_kind==4 or o.original_kind==5 or (g==6 or g==10) and o.original_kind==3
        local angle,speed=row.angle,row.speed
        local spawn=row.callbacks[1]
        if g==8 and spawn==6 then angle=(p.original_base_angle or 90)+angle-90
        elseif g==8 and spawn==8 then angle=(p.original_option_angle or 90)+angle
        elseif g==7 and spawn==5 then angle=(p.original_option_angle or 90)+angle-90
        elseif g==8 and spawn==7 then angle=90+ran:Float(-3.75,3.75)
        elseif g==7 and spawn==4 or g==8 and (spawn==1 or spawn==5) then
            local e=g==7 and p.original_aim_target or spawn==1 and p.original_option_target or p.original_aim_target
            if live(e) then angle=Angle(o,e)+angle-90;speed=speed*1.5 end
        end
        velocity(o,speed,angle)
        if g==10 and spawn==1 then o.original_target=p.original_homing_target end
        if g==8 then o.original_tint=P.state().human>=P.youkaiThreshold() and row.kind>0 end
        if o.original_laser then
            o.bound=false;o.killflag=true;o.history={}
            if g==10 then beam(o) end
            -- 原作用-999哨兵标记尚未写入的历史；首帧不能制造一整束残影。
            if g==7 and row.kind==5 or g==8 and row.callbacks[2]==5 then o.original_history_empty=true end
            if g==10 then o.secondary=P.animation(10,p.original_archive,16) end
        elseif g==10 then o.x,o.y=o.x-o.original_vx,o.y-o.original_vy end
    end,
    frame=function(o)
        local p,r=o.original_player,o.row
        if not live(p) or not P.state() then object.RawDel(o);return end
        local g=p.original_game;local age=o.original_age;local born=o.original_new
        o.original_new=nil
        o.original_age=born and age or age+1
        -- Sub引擎先调用frame再积分速度；这里自行积分，才能先移动再做原作命中检测。
        -- 红/妖/永先更新旧弹再生成新弹，出生帧不推进运动或ANM；风神录的顺序相反。
        if o.original_laser then
            if not born then
            o.original_hidden_until_update=nil
            if g==10 then
                if o.original_collided_last==false and o.original_collision_held and not o.original_fade then A.interrupt(o.vm,3);o.original_collision_held=nil end
                o.original_collided_last=false
            end
            local slot=o.original_slot
            if g==6 then
                if slot and (slot.time==70 or slot.time==1) then A.interrupt(o.vm,1) end
            elseif g==7 then
                if not slot then object.RawDel(o);return end
                if (slot.owner~=o or slot.time<=70) and o.vm.stopped then A.interrupt(o.vm,1) end
                if (p.dialog or P.state().bomb) and slot.time>20 then slot.time=20 end
                if slot.time<=0 or p.death~=0 then object.RawDel(o);return end
            elseif g==8 and r.callbacks[2]==5 then
                local shooting=p.original_shot_clock==nil and p.original_shot_time or p.original_shot_clock
                if not o.original_trail_stopped and (not slot or slot.owner~=o or shooting<0 or p.death~=0 or p.dialog or P.state().bomb) then
                    A.interrupt(o.vm,1);if slot then slot.owner=nil end
                    o.original_trail_stop_pending=true
                end
                local option=p.original_option_state and p.original_option_state[1]
                if not option then object.RawDel(o);return end
            elseif g==8 then
                if not slot then object.RawDel(o);return end
                if slot.owner~=o and o.vm.stopped then A.interrupt(o.vm,1) end
                if (p.dialog or P.state().bomb) and slot.time>20 then slot.time=20 end
                if slot.time<=0 then slot.owner=nil;object.RawDel(o);return end
                if slot.time<=70 and o.vm.stopped then A.interrupt(o.vm,1) end
                if slot.time<100 then slot.time=slot.time-1 end
            elseif g==10 and not o.original_fade and (p.original_shot_time<0 or p.death~=0 or r.option>math.min(4,floor(P.state().power/20)) or p.dialog) then
                o.original_fade=true;A.interrupt(o.vm,1);if o.secondary then A.interrupt(o.secondary,1) end
                if slot and slot.owner==o then slot.owner=nil end
            end
            local count=g==8 and r.callbacks[2]==5 and r.interval*2 or g==7 and r.kind==5 and r.interval or 0
            -- UpdateShotTrail在移动残影之前，为每隔一帧的历史位置建立16×448、伤害1的区域。
            local moving=not o.original_trail_stopped
            if moving and (g==7 and r.kind==5 or g==8 and r.callbacks[2]==5) then
                for i=1,math.min(#o.history,count),g==8 and 2 or 1 do
                    local v=o.history[i]
                    if o.original_pool_slot then P.queueHitRegion(v[1],v[2],g==8 and 16 or o.a*2,g==8 and 448 or o.b*2,1,P.state().bomb~=nil)
                    else enemies(function(e) if overlaps(o,e,v[1],v[2],g==8 and 8 or o.a,g==8 and 224 or o.b) then P.hitEnemy(e,1,P.state().bomb~=nil,false,true) end end) end
                end
            end
            if count>0 and moving then
                if not o.original_history_empty then table.insert(o.history,1,{o.x,o.y}) end
                o.original_history_empty=nil
                if #o.history>count then table.remove(o.history) end
                if g==8 then for i=2,#o.history do o.history[i][2]=o.history[i][2]+1 end end
            end
            if moving then beam(o)
            elseif g==8 then o.x,o.y=o.x+r.speed*cos(r.angle),o.y+r.speed*sin(r.angle) end
            if g==8 and moving then o.vm.color=P.state().human>=P.youkaiThreshold() and {255,208,176} or {255,255,255} end
            if o.original_trail_stop_pending then o.original_trail_stopped=true;o.original_trail_stop_pending=nil end
            end

        else
            local update=r.callbacks[2]
            if not born and not o.original_hit then
                if g==10 and update==1 then
                    -- 428B10：风神录追踪札锁定出生时的目标，120帧后直飞；并非红/妖/永的向量加速。
                    local e=o.original_target
                    if not live(e) or not e.colli or e.hp<=0 then e=nil;o.original_target=nil end
                    local speed,angle=o.speed,o.rot
                    if not e then speed=min(16,speed+.10000000149011612)
                    elseif age>=120 then speed=speed+.20000000298023224
                    else
                        local delta=(Angle(o,e)-angle+180)%360-180
                        if abs(delta)>=45 then speed=max(4,speed-.30000001192092896)
                        elseif abs(delta)<=15 then speed=min(16,speed+.10000000149011612) end
                        angle=angle+delta*.20000000298023224
                    end
                    velocity(o,speed,angle)
                elseif g==6 and r.kind==2 or (g==7 or g==8) and update==3 then
                    o.original_vy=o.original_vy+(g==6 and .3 or .27+ran:Float(0,.1))
                elseif g==6 and r.kind==1 or (g==7 or g==8) and (update==1 or g==7 and update==2) then
                    local cap=g==7 and update==2 and 18 or 10
                    local e=age<40 and p.original_homing_target
                    if e and not live(e) then e=nil end
                    if e then
                        local dx,dy=e.x-o.x,e.y-o.y;local d=max(1,sqrt(dx*dx+dy*dy)/(o.speed/4))
                        local vx,vy=o.original_vx+dx/d,o.original_vy+dy/d;local n=sqrt(vx*vx+vy*vy)
                        velocity(o,max(1,min(cap,n)),atan2(vy,vx))
                    elseif o.speed<cap then velocity(o,o.speed+(g==7 and update==2 and .6 or 1/3),o.rot) end
                end
                if o.original_vx~=0 or o.original_vy~=0 then o.rot=atan2(o.original_vy,o.original_vx) end
            elseif not born then o.original_hit_age=o.original_hit_age+1 end
            if not born then o.x,o.y=o.x+o.original_vx,o.y+o.original_vy end

        end
        if not born and not o.original_laser and (g~=10 or age>=10) then
            local sprite=o.vm.data.sprites[o.vm.sprite]
            if sprite then
                local w,h=sprite[4]/2,sprite[5]/2
                if g==10 then w,h=w*abs(o.vm.scale[1]),h*abs(o.vm.scale[2]) end
                if o.x+w < -192 or o.x-w>192 or o.y+h < -224 or o.y-h>224 then object.RawDel(o);return end
            end
        end
        if not born then A.step(o.vm,1);if o.secondary then A.step(o.secondary,1) end end
        if o.vm.finished then object.RawDel(o);return end
        if not o.original_pool_slot then
            if o.original_laser then hitLaser(o,p,r,g) else hitShot(o,p,r,g) end
        end
    end,
    render=function(o)
        local state=P.state()
        if not state or state.game~=o.original_player.original_game then return end
        if o.original_hidden_until_update then return end
        local g,r=o.original_player.original_game,o.row
        local opacity=1
        local rotation=P.shotRotation(o)
        if o.original_tint then o.vm.color={255,64,64} end
        A.draw(o.vm,o.x,o.y,0,1,1,opacity,nil,nil,rotation)
        local history=o.history
        if history then
            local stride=g==8 and 2 or 1
            for i=1,#history,stride do
                local v=history[i]
                -- 永夜抄第0段保留原alpha，之后才使用3/4及逐段递减；妖妖梦第0段也是满alpha。
                local alpha=g==8 and (i==1 and 1 or .75-.75*(i-1)/r.interval/2) or 1-(i-1)/r.interval
                if g==8 and state.human>=P.youkaiThreshold() then o.vm.color={255,64,64} end
                if alpha>0 then A.draw(o.vm,v[1],v[2],0,1,1,opacity*alpha,nil,nil,rotation) end
            end
        end
        if o.secondary then local x,y=origin(o.original_player,r);A.draw(o.secondary,x,y) end
    end,
    kill=function(o) o.colli=false end,
})
C.shotBurst=Class(object,{
    init=function(o,p,x,y,damage)
        o.original_player=p;o.x,o.y=x,y;o.radius=32;o.remaining=13;o.damage=damage
        o.group=GROUP.GHOST;o.layer=LAYER.PLAYER_BULLET;o.colli=false;o.bound=false
    end,
    frame=function(o)
        if not P.enabled() then object.RawDel(o);return end
        o.radius=o.radius+1.3999999761581421;o.remaining=o.remaining-1
        -- Player.cpp:1848的原作分支在4的倍数帧跳过区域伤害。
        if o.remaining%4~=0 then
            P.queueHitRegion(o.x,o.y,o.radius,0,o.damage,false,true)
        end
        if o.remaining<=0 then object.RawDel(o) end
    end,
    render=function() end,
})
function P.spawnShotBurst(p,x,y,damage)
    local list=p.original_shot_bursts or {};p.original_shot_bursts=list;local n=0
    for o in pairs(list) do if live(o) then n=n+1 else list[o]=nil end end
    if n<32 then
        local o=New(C.shotBurst,p,x,y,damage);list[o]=true
        P.queueHitRegion(x,y,32,0,damage,false,true)
        return o
    end
end
function P.resolveShotHits()
    if not P.enabled() or not live(player) or not player.original_game then return end
    local p=player;local g=p.original_game
    enemies(function(e)
        collisionTarget=e
        local function pass(box,secondary)
            collisionBox=box;P.secondaryHit=secondary
            for i=1,({[6]=80,[7]=96,[8]=128,[10]=128})[g] do
                local o=p.original_shot_pool and p.original_shot_pool[i]
                if live(o) and not o.vm.finished then
                    if o.original_laser then hitLaser(o,p,o.row,g) else hitShot(o,p,o.row,g) end
                end
            end
            -- 原作先逐弹处理，再结算区域；时符积累也必须在主/副框各自结束时补入。
            P.feedEnemyPass(e)
            for _,r in ipairs(regions) do if regionHit(r,e) then P.hitEnemy(e,r.damage,r.bomb,false,true) end end
            P.endEnemyPass(e)
        end
        pass(nil,false)
        local box=g==8 and e._original_secondary_box
        if box and box[1]>0 then pass(box,true) end
        collisionTarget,collisionBox=nil,nil;P.secondaryHit=nil
    end)
    regions={}
end
