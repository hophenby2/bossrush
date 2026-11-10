-- 原作子机：妖妖梦咲夜B保留转向，永夜抄按队伍/单人各自的回调更新。
local P,A=SequenceResources,OriginalANM
local min,max,abs=math.min,math.max,math.abs
local function option(p,index,x,y,id)
    local list=p.original_option_state or {};p.original_option_state=list
    local o=list[index]
    if not o or o.id~=id then o={id=id,x=x,y=y,tx=x,ty=y,vx=0,vy=0,age=0,angle=index%2==0 and 180 or 0,vm=P.animation(p.original_game,p.original_archive,id)};list[index]=o end
    return o
end
local function put(p,i,o,x,y)
    o.x,o.y=x,y;o.age=o.age+1;p.original_options[i]={x,y};A.step(o.vm,1)
end
function P.updateOptions(p)
    local s=P.state();local g=s.game;local slow=p.__slow_flag
    local t=max(0,min(8,p.original_focus+(slow and 1 or -1)));p.original_focus=t
    p.original_options={}
    if g==6 or g==7 then
        local x,y=24-16*(t/8)^2,32*t/8
        if g==7 and p.original_machine.id=='sakuyab' then
            local angle=p.original_option_angle or 90
            if p.__shoot_flag and not slow then
                local dx=p.__move_dx or 0
                if dx~=0 then angle=max(54,min(126,angle-dx/4*3.6))
                elseif abs(angle-90)>1.8 then angle=angle+(angle<90 and 3.6 or -3.6) else angle=90 end
            end
            p.original_option_angle=angle
            for i=1,2 do
                local side=i==1 and -1 or 1
                local ax,ay=cos(angle-90)*24*side,sin(angle-90)*24*side
                local fx,fy=cos(angle+side*-180/14)*24,sin(angle+side*-180/14)*24
                local o=option(p,i,p.x,p.y,127+i)
                put(p,i,o,p.x+ax+(fx-ax)*t/8,p.y+ay+(fy-ay)*t/8)
            end
        else
            for i=1,2 do local o=option(p,i,p.x,p.y,127+i);put(p,i,o,p.x+(i==1 and -x or x),p.y+y) end
        end
    elseif g==10 then
        local n=min(4,math.floor(s.power/20));local base=n*(n-1)/2+(slow and 15 or 0)
        local history=p.original_trail or {};p.original_trail=history
        if not history[1] then for i=1,33 do history[i]={p.x,p.y} end end
        if not slow and ((p.__move_dx or 0)~=0 or (p.__move_dy or 0)~=0) then
            for i=33,2,-1 do local h=history[i-1];history[i]={h[1],h[2]} end
        end
        history[1]={p.x,p.y}
        local m=p.original_machine
        local function trunc(v) return v<0 and math.ceil(v) or math.floor(v) end
        for i=1,n do
            local v=p.original_data.options[base+i];local tx,ty=p.x+v[1],p.y-v[2]
            local o=option(p,i,tx,ty,17+m.shot)
            if m.character==1 and m.shot==0 then
                local h=history[i*8+1]
                if not slow then o.offset_x,o.offset_y=h[1]-p.x,h[2]-p.y
                else
                    tx,ty=p.x+(o.offset_x or v[1]),p.y+(o.offset_y or -v[2])
                    history[i*8+1]={tx,ty}
                end
                if not slow then tx,ty=h[1],h[2] end
            elseif m.character==1 and m.shot==2 then
                if slow then tx,ty=o.frozen_x or o.x,o.frozen_y or o.y
                else o.frozen_x,o.frozen_y=o.x,o.y end
                if o.slow~=slow then A.interrupt(o.vm,slow and 3 or 6) end
            end
            if o.age>0 then tx,ty=o.x+trunc((tx-o.x)*30)/100,o.y+trunc((ty-o.y)*30)/100 end
            put(p,i,o,tx,ty);o.slow=slow
            if s.power>=100 then
                if not o.secondary then o.secondary=P.animation(10,p.original_archive,20+m.shot) end
                A.step(o.secondary,1)
            else o.secondary=nil end
        end
    elseif g==8 then
        local m=p.original_machine;local team=m.id:sub(1,4)=='team'
        local route=team and m.character or tonumber(m.id:sub(5))
        local mode=team and (slow and route or route==3 and 10 or -1) or ({-1,-1,-1,10,0,1,9,3})[route+1]
        -- 队伍妖梦的人类形态用第三个跟随子机，其余队伍高速时没有妖怪子机。
        if team and route==3 and not slow then mode=10 end
        local signature=tostring(mode)..':'..tostring(team and slow or false)
        if signature~=p.original_option_signature then p.original_option_state={};p.original_option_signature=signature end
        local history=p.original_position_history or {};p.original_position_history=history
        table.insert(history,1,{p.x,p.y});if #history>16 then table.remove(history) end
        if mode==0 then
            local o=option(p,1,p.x,min(192,p.y+96),18)
            local target
            if p.__shoot_flag and o.age>=10 then
                object.EnemyNontjtDo(function(e) if IsValid(e) and e.colli and e.hp and e.hp>0 and (not target or Dist(o.x,o.y,e.x,e.y)<Dist(o.x,o.y,target.x,target.y)) then target=e end end)
            end
            local tx,ty=p.x,min(192,p.y+96)
            if target then tx,ty=target.x,min(192,target.y-32) end
            o.vx=o.vx+((tx-o.x)/16-o.vx)*.2;o.vy=o.vy+((ty-o.y)/16-o.vy)*.2
            put(p,1,o,o.x+o.vx,o.y+o.vy)
        elseif mode==1 then
            local o=option(p,1,p.x,p.y+32,29)
            if not s.bomb then o.x,o.y=p.x,p.y+32 end
            put(p,1,o,o.x,o.y)
        elseif mode==2 or mode==9 then
            local offsets={{-30,16},{-10,32},{10,32},{30,16}}
            for i,v in ipairs(offsets) do
                local o=option(p,i,p.x+v[1],p.y+v[2],24)
                if o.age>12 then o.angle=o.angle-({1.5,-2,2,-1.5})[i] end
                if mode==9 and not slow then o.tx=o.tx+(p.x+v[1]-o.tx)*.2;o.ty=o.ty+(p.y+v[2]-o.ty)*.2 end
                put(p,i,o,o.tx+cos(o.angle)*8,o.ty+sin(o.angle)*8)
            end
        elseif mode==3 then
            for i=1,2 do
                local o=option(p,i,p.x,p.y,21);o.angle=o.angle+(i==1 and -3 or 3)
                o.tx=o.tx+(p.x+(i==1 and -32 or 32)-o.tx)*.09;o.ty=o.ty+(p.y-o.ty)*.09
                put(p,i,o,o.tx+cos(o.angle)*6,o.ty+sin(o.angle)*6)
            end
        elseif mode==10 then
            local past=history[16] or history[#history];local o=option(p,3,past[1],past[2],21)
            o.angle=o.angle-3;o.tx=o.tx+(past[1]-o.tx)*.05;o.ty=o.ty+(past[2]-o.ty)*.05
            if not (not team and slow) then
                local dx,dy=p.__move_dx or 0,p.__move_dy or 0
                if dx~=0 or dy~=0 then
                    local target=atan2(-dy,-dx);local facing=p.original_option_angle or 90
                    local delta=(target-facing+180)%360-180
                    p.original_option_angle=abs(delta)>90 and target or facing+delta*.07
                end
            end
            put(p,3,o,o.tx+cos(o.angle)*8,o.ty+sin(o.angle)*8)
        end
    end
end
function P.renderOptions(p)
    local s=P.state();if not s then return end
    if p.original_game<8 and s.power<8 then return end
    for i,v in pairs(p.original_options) do
        local o=p.original_option_state and p.original_option_state[i]
        if o then A.draw(o.vm,v[1],v[2]);if o.secondary then A.draw(o.secondary,v[1],v[2]) end end
    end
end
