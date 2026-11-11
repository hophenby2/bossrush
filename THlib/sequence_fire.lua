-- 发射周期和持久弹槽位分别照各作 Player.cpp，不能用“按住就生成一束”代替回调。
local P,A=SequenceResources,OriginalANM
local function live(o) return o and IsValid(o) end
local function slot(p,index)
    p.original_fire_slots=p.original_fire_slots or {}
    local s=p.original_fire_slots[index]
    if not s then s={time=0};p.original_fire_slots[index]=s end
    if not live(s.owner) then s.owner=nil end
    return s
end
local function emit(p,row)
    local shots=p.original_shots or {};p.original_shots=shots
    local pool=p.original_shot_pool or {};p.original_shot_pool=pool
    local index
    for i=1,({[6]=80,[7]=96,[8]=128,[10]=128})[p.original_game] do if not live(pool[i]) then index=i;break end end
    if not index then return end
    for o in pairs(shots) do if not live(o) then shots[o]=nil end end
    local o=New(P.classes.shot,p,row);shots[o]=true
    pool[index]=o;o.original_pool_slot=index
    if row.sound and row.sound>=0 then
        P.playOriginalSound(row.sound,p.x)
    end
    if p.original_game<10 then
        o.original_new=true
        if p.original_game==7 and row.kind==5 or p.original_game==8 and row.callbacks[2]==5 then
            o.x=-999;o.original_hidden_until_update=true
        end
    end
    return o
end
function P.shoot(p)
    local g=p.original_game;local rows=P.rowsFor(p);p.original_rows=rows
    local bomb=P.state().bomb
    if (g==6 or g==7) and bomb and p.original_machine.id=='marisab' then return end
    -- 永夜抄咏唱组、魔理沙/爱丽丝单人在雷中禁射；其余回调还有自己的禁射条件。
    if g==8 and bomb and (p.original_machine.id=='team1' or p.original_machine.id=='solo1' or p.original_machine.id=='solo5' or bomb.spec.special) then return end
    for _,row in ipairs(rows) do
        local cb=row.callbacks[1]
        local persistent=g==6 and row.kind==3 or g==7 and (cb==2 or cb==3) or g==8 and cb==4
        if persistent then
            local s=slot(p,row.frame)
            if g==6 then
                if s.time<=0 then
                    local o=emit(p,row)
                    if o then s.time=row.interval;s.owner=o;o.original_slot=s end
                end
            elseif not (g==8 and bomb) then
                if s.owner or g==7 and s.occupied then
                    if s.row~=row then if s.owner then A.interrupt(s.owner.vm,1) end;s.owner=nil;s.occupied=nil end
                elseif g==8 or cb==2 and p.original_option_phase==1 or cb==3 and p.original_option_phase==3 then
                    local o=emit(p,row)
                    if o then s.time=g==7 and cb==2 and row.interval or 999;s.owner=o;s.occupied=true;s.row=row;o.original_slot=s end
                end
            end
        elseif p.original_shot_time%row.interval==row.frame then
            if g==10 and row.kind==3 then
                -- 风神录按子机号占槽；换火力档不会凭空复制正在发射的激光。
                local s=slot(p,row.option)
                if not s.owner then local o=emit(p,row);if o then s.owner=o;o.original_slot=s end end
            elseif not (g==8 and bomb and (cb==2 or cb==3 or cb==8)) then emit(p,row) end
        end
    end
end
function P.stepShotSlots(p)
    local g=p.original_game
    for index,s in pairs(p.original_fire_slots or {}) do
        if not live(s.owner) then s.owner=nil end
        if g==6 then s.time=math.max(0,s.time-1)
        elseif g==7 and s.occupied then
            if p.death~=0 or index==2 and p.original_option_phase~=3 then
                if s.owner then object.RawDel(s.owner) end;s.owner=nil;s.occupied=nil
            elseif index<2 and p.original_option_phase~=1 then
                if s.owner then A.interrupt(s.owner.vm,1) end;s.owner=nil;s.occupied=nil
            else
                if s.time>0 and s.time<999 then s.time=s.time-1 end
                if p.original_shot_time<0 and s.time>50 then s.time=50 end
                if s.time==0 then s.owner=nil;s.occupied=nil end
            end
        end
    end
end
function P.updateShooting(p,shoot,active)
    local g=p.original_game;local t=p.original_shot_time
    if not active then p.original_shot_time=-1;p.original_shot_clock=-1;P.stepShotSlots(p);return end
    if shoot and t<0 then t=0 end
    p.original_shot_time=t
    p.original_shot_clock=t
    P.stepShotSlots(p)
    if t<0 then return end
    P.shoot(p)
    -- TH10在第15帧先发射再回绕，回绕帧自身不再递增。
    if g==10 and t>=15 then p.original_shot_time=shoot and t-15 or -1
    else p.original_shot_time=t+1;if p.original_shot_time>=(g==8 and 20 or 30) then p.original_shot_time=-1 end end
end
