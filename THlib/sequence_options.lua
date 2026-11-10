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
    p.original_option_positions=p.original_option_positions or {};p.original_option_positions[i]={x,y}
end
local function focusPosition(p,slow,power)
    -- 红/妖的展开与收拢各有8帧计时器；收拢并非把展开曲线倒放。
    local phase,t=p.original_option_phase or 0,p.original_option_time or 0
    if power<8 then phase,t=0,0 elseif phase==0 then phase=1 end
    if phase==1 then t=0;if slow then phase=2 end
    elseif phase==3 then t=0;if not slow then phase=4 end end
    local sakuya=p.original_game==7 and p.original_machine.id=='sakuyab'
    if sakuya then
        if phase==2 and not slow then phase,t=4,8-t
        elseif phase==4 and slow then phase,t=2,8-t end
    end
    local x,y,f=0,0,0
    for _=1,2 do
        if phase==0 then break
        elseif phase==1 then x=24;break
        elseif phase==3 then x,y,f=8,32,1;break
        elseif phase==2 then
            t=t+1;f=t/8;x,y=24-16*f*f,32*f
            if t>=8 then phase=3 end
            if not slow and not sakuya then phase=4;t=8-t else break end
        elseif phase==4 then
            t=t+1;local a=t/8;f=1-a;x,y=8+16*a*a,32*f
            if t>=8 then phase=1 end
            if slow and not sakuya then phase=2;t=8-t else break end
        end
    end
    p.original_option_phase,p.original_option_time,p.original_focus=phase,t,f*8
    return x,y,f
end
function P.updateOptions(p)
    local s=P.state();local g=s.game;local slow=p.__slow_flag
    p.original_option_state=p.original_option_state or {}
    p.original_options={}
    if g==6 or g==7 then
        local x,y,f=focusPosition(p,slow,s.power);local t=f*8
        if g==7 and p.original_machine.id=='sakuyab' then
            local angle=p.original_option_angle or 90;local positionAngle=angle
            if p.__shoot_flag and not slow then
                local dx=p.__move_dx or 0
                if dx~=0 then angle=max(54,min(126,angle-dx/4*3.6))
                elseif abs(angle-90)>1.8 then angle=angle+(angle<90 and 3.6 or -3.6) else angle=90 end
            end
            p.original_option_angle=angle
            for i=1,2 do
                local side=i==1 and -1 or 1
                local ax,ay=cos(positionAngle-90)*24*side,sin(positionAngle-90)*24*side
                local fx,fy=cos(positionAngle+side*-180/14)*24,sin(positionAngle+side*-180/14)*24
                local o=option(p,i,p.x,p.y,127+i)
                put(p,i,o,p.x+ax+(fx-ax)*t/8,p.y+ay+(fy-ay)*t/8)
            end
        else
            for i=1,2 do local o=option(p,i,p.x,p.y,127+i);put(p,i,o,p.x+(i==1 and -x or x),p.y+y) end
        end
    elseif g==10 then
        local n=min(4,math.floor(s.power/20));local base=n*(n-1)/2+(slow and 10 or 0)
        if p.original_option_count~=n then p.original_option_state={};p.original_option_count=n end
        local history=p.original_trail or {};p.original_trail=history
        if not history[1] then for i=1,33 do history[i]={p.x,p.y} end end
        if not slow and ((p.__move_dx or 0)~=0 or (p.__move_dy or 0)~=0) then
            for i=33,n*8+2,-1 do local h=history[n*8+1];history[i]={h[1],h[2]} end
            for i=n*8+1,2,-1 do local h=history[i-1];history[i]={h[1],h[2]} end
        end
        history[1]={p.x,p.y}
        local m=p.original_machine
        local function trunc(v) return v<0 and math.ceil(v) or math.floor(v) end
        if m.character==1 and m.shot==2 then
            p.original_option_return=slow and 0 or min(30,(p.original_option_return or 30)+1)
        end
        for i=1,n do
            local v=p.original_data.options[base+i];local tx,ty=p.x+v[1],p.y-v[2]
            local o=option(p,i,tx,ty,17+m.shot)
            if m.character==1 and m.shot==0 then
                local h=history[i*8+1]
                if not slow then o.offset_x,o.offset_y=h[1]-p.x,h[2]-p.y
                else
                    tx,ty=p.x+(o.offset_x or v[1]),p.y+(o.offset_y or -v[2])
                    history[i*8+1]={tx,ty}
                    local previous=history[(i-1)*8+1]
                    for j=1,7 do
                        history[(i-1)*8+j+1]={trunc((previous[1]+(tx-previous[1])*j/8)*100)/100,
                            224-trunc(((224-previous[2])+(previous[2]-ty)*j/8)*100)/100}
                    end
                end
                if not slow then tx,ty=h[1],h[2] end
            elseif m.character==1 and m.shot==2 then
                if slow then tx,ty=o.frozen_x or o.x,o.frozen_y or o.y
                else o.frozen_x,o.frozen_y=o.x,o.y end
                if o.slow~=slow then A.interrupt(o.vm,slow and 3 or 6) end
            end
            if o.age>0 then
                local dx,dy=trunc((tx-o.x)*30)/100,trunc((ty-o.y)*30)/100
                if dx~=0 or dy~=0 then tx,ty=o.x+dx,o.y+dy end
            end
            if o.age>0 and m.character==1 and m.shot==2 and p.original_option_return<30 then tx,ty=o.x,o.y end
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
        if signature~=p.original_option_signature then
            if team and not slow then
                for _,o in pairs(p.original_option_state or {}) do
                    if not o.exit then o.exit=0;A.interrupt(o.vm,5) end
                end
                if route==3 then p.original_option_state[3]=nil;p.original_position_history=nil end
            else p.original_option_state={} end
            p.original_option_signature=signature
        end
        for i,o in pairs(p.original_option_state or {}) do
            if o.exit then
                if o.exit>16 then p.original_option_state[i]=nil
                else
                    if route==1 then o.x,o.y=p.x,p.y+32 end
                    put(p,i,o,o.x,o.y);o.exit=o.exit+1
                end
            end
        end
        local history=p.original_position_history or {};p.original_position_history=history
        table.insert(history,1,{p.x,p.y});if #history>16 then table.remove(history) end
        if mode==0 then
            local o=option(p,1,p.x,min(192,p.y+96),18)
            local target=p.original_option_target
            local tx,ty=p.x,min(192,p.y+96)
            if o.behavior==3 and target then tx,ty=target.x,min(192,target.y-32) end
            if o.age>0 then
                o.vx=o.vx+((tx-o.x)/16-o.vx)*.2;o.vy=o.vy+((ty-o.y)/16-o.vy)*.2
                o.x,o.y=o.x+o.vx,o.y+o.vy
                if abs(o.vx)<.05 then o.vx=0 end
                if o.behavior==3 then
                    if not target or p.original_shot_time<0 and not p.__shoot_flag then A.interrupt(o.vm,1);o.behavior=0;p.original_option_target=nil end
                elseif p.original_shot_time>=0 and target and o.age>=10 then A.interrupt(o.vm,3);o.behavior=3
                else
                    local behavior=o.vx<0 and 1 or o.vx>0 and 2 or 0
                    if behavior~=(o.behavior or 0) then A.interrupt(o.vm,behavior==0 and 1 or 2) end
                    o.behavior=behavior;o.vm.scale[1]=(behavior==2 and -1 or 1)*abs(o.vm.scale[1])
                end
            end
            put(p,1,o,o.x,o.y)
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
                if mode==9 then o.vm.color=slow and {255,128,128} or {128,255,255} end
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
            if not team then o.vm.color=slow and {255,128,128} or {255,255,255} end
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
function P.updateFocusVisual(p)
    local g=p.original_game
    if g==6 then return end
    local wanted=p.death==0 and (g==7 and (p.original_option_phase==2 or p.original_option_phase==3) or g~=7 and p.__slow_flag)
    local list=p.original_focus_vms or {};p.original_focus_vms=list
    if wanted and not p.original_focus_vm then
        -- TH07效果24用局部raw194；TH08效果22按脚本序号54；TH10模式标记用bullet脚本352。
        local vm=g==8 and A.new(8,'etama',54) or P.animation(g,g==7 and 'etama' or 'bullet',g==7 and 194 or 352)
        local entry={vm=vm,x=p.x,y=p.y};list[#list+1]=entry;p.original_focus_vm=entry
    elseif not wanted and p.original_focus_vm then
        A.interrupt(p.original_focus_vm.vm,1);p.original_focus_vm=nil
    end
    for i=#list,1,-1 do
        local v=list[i]
        if g~=10 or v==p.original_focus_vm then v.x,v.y=p.x,p.y end
        A.step(v.vm,1)
        if v.vm.finished then table.remove(list,i) end
    end
end
function P.renderFocusVisual(p)
    for _,v in ipairs(p.original_focus_vms or {}) do A.draw(v.vm,v.x,v.y) end
end
