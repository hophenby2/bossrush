-- 红/妖/永的 Player::UpdateShots 与风神录 SHT 回调桥。
-- 速度和角度已在导出时翻转Y；回调里的加速度只能再翻转一次。
local P,A=SequenceResources,OriginalANM
local C=P.classes
local min,max,abs,floor,sqrt=math.min,math.max,math.abs,math.floor,math.sqrt
local function live(o) return o and IsValid(o) end
local function enemies(fn)
    object.EnemyNontjtDo(function(e) if live(e) and e.colli and e.hp and e.hp>0 then fn(e) end end)
end
local function nearest(o)
    local target,distance
    enemies(function(e) local d=Dist(o,e);if not distance or d<distance then target,distance=e,d end end)
    return target
end
local function origin(p,row)
    local v=p.original_options[row.option]
    return (v and v[1] or p.x)+row.x,(v and v[2] or p.y)-row.y
end
local function velocity(o,speed,angle)
    o.rot,o.speed=angle,speed;SetV(o,speed,angle)
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
        o.x,o.y=x,y+240;o.a,o.b=r.hx/2,240
    else
        local length=224-y
        if g==7 and r.kind==5 then x,y=p.x+r.x,p.y;length=224-y+64 end
        o.x,o.y=x,y+length/2;o.a,o.b=r.hx/2,length/2
        o.vm.scale[2]=length/14
    end
    o.vx,o.vy=0,0
end
local function overlaps(o,e,x,y,a,b)
    local box=e._original_damage_box
    return abs((x or o.x)-e.x)<=(a or o.a)+(box and box[1]/2 or e.a or 0)
        and abs((y or o.y)-e.y)<=(b or o.b)+(box and box[2]/2 or e.b or 0)
end
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
        if g~=6 then o.original_damage=max(1,floor(o.original_damage/3));o.vx,o.vy=o.vx*.88,o.vy*.88 end
    end
    if g==6 then o.original_damage=max(1,floor(damage/4));o.vx,o.vy=o.vx/8,o.vy/8;return damage end
    return o.original_damage
end
C.shot=Class(object,{
    init=function(o,p,row)
        local g=p.original_game
        o.original_player,o.row=p,row;o.x,o.y=origin(p,row)
        o.original_damage,o.dmg=row.damage,row.damage;o.a,o.b=row.hx/2,row.hy/2;o.rect=true
        o.group,o.colli,o.layer=GROUP.GHOST,false,LAYER.PLAYER_BULLET
        o.original_age,o.original_hit_age=0,0;o.bound=true
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
            local e=nearest(o);if e then angle=Angle(o,e)+angle-90;speed=speed*1.5 end
        end
        velocity(o,speed,angle)
        if o.original_laser then
            o.bound=false;o.killflag=true;o.history={};beam(o)
            if g==10 then o.secondary=P.animation(10,p.original_archive,16) end
        elseif g==10 then o.x,o.y=o.x-o.vx,o.y-o.vy end
    end,
    frame=function(o)
        local p,r=o.original_player,o.row
        if not live(p) or not P.enabled() then object.RawDel(o);return end
        local g=p.original_game;local age=o.original_age;o.original_age=age+1
        if o.original_laser then
            if not o.original_fade and (not p.__shoot_flag or p.death~=0 or p.original_rows~=o.original_rows
                or g==8 and (p.dialog or P.state().bomb)) then
                o.original_fade=20;A.interrupt(o.vm,1)
            end
            if o.original_fade then
                o.original_fade=o.original_fade-1
                if o.original_fade<=0 then object.RawDel(o);return end
            end
            local count=g==8 and r.callbacks[2]==5 and r.interval*2 or g==7 and r.kind==5 and r.interval or 0
            -- UpdateShotTrail在移动残影之前，为每隔一帧的历史位置建立16×448、伤害1的区域。
            if g==8 and r.callbacks[2]==5 and not o.original_fade then
                for i=1,#o.history,2 do
                    local v=o.history[i]
                    enemies(function(e) if overlaps(o,e,v[1],v[2],8,224) then P.hitEnemy(e,1,false) end end)
                end
            end
            local moving=not o.original_fade or not (g==8 and r.callbacks[2]==5)
            if count>0 and moving then
                table.insert(o.history,1,{o.x,o.y})
                if #o.history>count then table.remove(o.history) end
                if g==8 then for _,v in ipairs(o.history) do v[2]=v[2]+1 end end
            end
            if moving then beam(o) end
            if g==10 and age%4==0 or g==6 or (g==7 or g==8) and age%2==0 then
                enemies(function(e)
                    if (g~=10 or e.y-(e.b or 0)<=224) and overlaps(o,e) then
                        local damage=o.original_damage
                        if g<10 and P.state().bomb then damage=max(1,floor(damage/(g==8 and 5 or 3))) end
                        P.hitEnemy(e,damage,false,g==8 and r.kind<0)
                    end
                end)
            end
        else
            local update=r.callbacks[2]
            if not o.original_hit then
                if g==6 and r.kind==2 or (g==7 or g==8) and update==3 then
                    o.vy=o.vy+(g==6 and .3 or .27+ran:Float(0,.1))
                elseif g==6 and r.kind==1 or g~=6 and (update==1 or g==7 and update==2) then
                    local cap=g==7 and update==2 and 18 or 10
                    local e=age<40 and nearest(o)
                    if e then
                        local dx,dy=e.x-o.x,e.y-o.y;local d=max(1,sqrt(dx*dx+dy*dy)/(o.speed/4))
                        local vx,vy=o.vx+dx/d,o.vy+dy/d;local n=sqrt(vx*vx+vy*vy)
                        velocity(o,max(1,min(cap,n)),atan2(vy,vx))
                    elseif o.speed<cap then velocity(o,o.speed+(g==7 and update==2 and .6 or 1/3),o.rot) end
                end
                if o.vx~=0 or o.vy~=0 then o.rot=atan2(o.vy,o.vx) end
            else o.original_hit_age=o.original_hit_age+1 end
            local missile=(g==6 and r.kind==2) or (g==7 or g==8) and r.callbacks[4]==1 or g==10 and r.kind==2
            local canhit=not o.original_hit or missile and (g==6 or age%2==0)
            if canhit then
                local target,distance
                enemies(function(e) if overlaps(o,e) then local d=Dist(o,e);if not distance or d<distance then target,distance=e,d end end end)
                if target and (g~=10 or o.y+o.b<=224) then
                    if not o.original_hit or not target.is_sc or age%4==0 then
                        local damage=missile and missileHit(o) or o.original_damage
                        local b=P.state().bomb
                        if b and g<10 then damage=max(1,floor(damage/(g==8 and 5 or 3))) end
                        P.hitEnemy(target,damage,false,g==8 and r.kind<0)
                        if not missile then
                            o.original_hit=true;o.vx,o.vy=o.vx/8,o.vy/8
                            if g==10 then object.RawDel(o);return end
                            o.vm=P.animation(g,p.original_archive,r.animation+(g==7 and -1024+32 or g==8 and 11 or 32))
                        end
                    end
                end
            end
            if o.original_hit and o.original_hit_age>=45 then object.RawDel(o);return end
        end
        A.step(o.vm,1);if o.secondary then A.step(o.secondary,1) end
        if o.vm.finished then object.RawDel(o) end
    end,
    render=function(o)
        local g,r=o.original_player.original_game,o.row
        local opacity=o.original_fade and o.original_fade/20 or 1
        local rotation=P.shotRotation(o)
        A.draw(o.vm,o.x,o.y,0,1,1,opacity,nil,nil,rotation)
        local history=o.history
        if history then
            local stride=g==8 and 2 or 1
            for i=1,#history,stride do
                local v=history[i]
                local alpha=g==8 and .75-(i-1)/r.interval/2 or 1-i/r.interval
                if alpha>0 then A.draw(o.vm,v[1],v[2],0,1,1,opacity*alpha,nil,nil,rotation) end
            end
        end
        if o.secondary then local x,y=origin(o.original_player,r);A.draw(o.secondary,x,y) end
    end,
    kill=function(o) o.colli=false end,
})
