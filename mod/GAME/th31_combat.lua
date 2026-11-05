-- 从原作 ecldata*.ecl 提取的生命值、受击框与交互开关。
-- op77=判定框，79/80/81=重设/关闭/开启交互位，82=近身停火距离，160=出生免伤。
-- Spawn90..92 的 life 是第4操作数；93/94 带z坐标，life 是第5操作数。
local profiles = {
    ["ecldata7:17"]={spawns={{91,300,0,0}},events={{0,77,24,24},{1,81,3}},attached=true},
    ["ecldata_al:2"]={spawns={{92,9000,0,0}},events={{0,80,16},{0,77,24,24},{0,160,30},{0,82,0}},attached=true},
    ["ecldata3sp:58"]={spawns={{90,1200,96,128},{90,1200,288,128},{90,500,192,224}},events={{0,77,24,24},{0,160,30},{0,80,8192}},attached=true,life=function(o,a) return a[5]==3 and 500 or 1200 end},
    ["ecldata5sp:42"]={spawns={{91,200,0,0}},events={{0,77,24,24},{0,160,30}},attached=true},
    ["ecldata7sp:80"]={spawns={{91,4000,0,0},{91,2100,0,0},{91,1000,0,0}},events={{0,77,24,24},{0,80,16},{0,80,3},{0,82,0},{120,81,3}},attached=true,life=function(o,a) return ({4000,2100,1000,1000,1000,2100,4000})[a[3]+1] end},
    ["ecldata5sp:48"]={spawns={{91,2000,false,false}},events={{0,77,24,24},{0,160,30},{0,82,0},{0,80,16},{1,81,3}},attached=true},
    ["ecldata4asp:44"]={spawns={{92,500,0,0},{92,300,0,0}},events={{0,77,24,24},{0,160,30},{0,80,16},{0,80,3}},attached=true,life=function(o,a) return a[4]/20%2==0 and 500 or 300 end},
    ["ecldata4bsp:63"]={spawns={{94,500,0,0}},events={{0,77,24,24},{0,160,30},{0,80,16},{0,80,3}},attached=false},
    ["ecldata3:37"]={spawns={{92,1000,16,32},{92,1000,-16,32},{92,1900,32,0},{92,1900,-32,0},{92,1500,16,-32},{92,1500,-16,-32}},events={{0,77,24,24},{0,160,30}},attached=true},
    ["ecldata3:45"]={spawns={},events={{0,77,24,24}},attached=true,life=function(o,a) return 40+50*math.floor((a[4]-1.7)/0.6+0.0001) end},
    ["ecldata3:48"]={spawns={{90,1200,96,128},{90,1200,288,128},{90,550,192,224},{90,400,192,224}},events={{0,77,24,24},{0,160,30},{0,80,8192}},attached=true,life=function(o,a) return a[1]~=0 and 1200 or a[4]<0 and 550 or 400 end},
    ["ecldata3:40"]={spawns={{92,1000,16,32},{92,1000,-16,32},{92,1900,32,0},{92,1900,-32,0},{92,1500,16,-32},{92,1500,-16,-32},{92,900,32,64},{92,900,-32,64},{92,1600,64,0},{92,1600,-64,0},{92,1600,32,-64},{92,1600,-32,-64}},events={{0,77,24,24},{0,160,30}},attached=true},
    ["ecldata3:64"]={spawns={{91,40,0,0}},events={{0,77,24,24},{0,160,30},{0,80,8192}},attached=true,life=function(o,a) return a[6] end},
    ["ecldata3:69"]={spawns={{90,1200,96,128},{90,1200,288,128},{90,500,192,224},{90,300,192,224}},events={{0,77,24,24},{0,160,30},{0,80,8192}},attached=true,life=function(o,a) return a[5]<3 and 1200 or a[4]>0 and 500 or 300 end},
    ["ecldata8:57"]={spawns={{94,1000,0,0}},events={{0,80,8}},attached=false},
    ["ecldata8:54"]={spawns={{90,1350,64,128},{90,1350,320,128},{90,750,152,220},{90,750,232,220},{90,1350,32,188},{90,1350,352,188},{90,750,162,150},{90,750,222,150}},events={{0,77,24,24},{0,160,30}},attached=true},
    ["ecldata8:63"]={spawns={{90,1350,64,128},{90,1350,320,128},{90,750,152,220},{90,750,232,220},{90,1350,32,188},{90,1350,352,188},{90,750,162,150},{90,750,222,150}},events={{0,77,24,24},{0,160,30}},attached=true},
    ["ecldata8:96"]={spawns={{90,13500,96,128},{90,13500,288,128}},events={{0,77,24,24},{0,160,30},{1,81,3}},attached=true},
    ["ecldata8:101"]={spawns={{91,13500,false,0}},events={{0,77,24,24},{0,160,30},{1,81,3}},attached=true},
    ["ecldata8:104"]={spawns={{91,13500,0,0}},events={{0,77,24,24},{0,160,30},{0,82,0},{1,81,3}},attached=true},
    ["ecldata8:109"]={spawns={{92,13500,-96,-16},{92,13500,96,-16},{92,13500,-64,32},{92,13500,64,32}},events={{0,77,24,24},{0,160,30},{1,81,3}},attached=true},
    ["ecldata8:114"]={spawns={{91,13500,false,false},{91,13500,0,0}},events={{0,77,24,24},{0,160,30},{1,81,3},{61,82,0}},attached=true},
    ["ecldata8:119"]={spawns={{91,13500,0,0}},events={{0,77,24,24},{0,160,30},{1,81,3},{1,82,0}},attached=true},
    ["ecldata8:127"]={spawns={{91,13500,0,0}},events={{0,77,24,24},{0,80,16},{0,82,0},{120,80,8}},attached=true},
    ["ecldata8:139"]={variants={[94]="ecldata8:140",[95]="ecldata8:141"},spawns={{91,13500,88,-32},{91,13500,-88,-32}},events={{0,77,24,24},{0,160,30},{0,82,0}},attached=true},
    ["ecldata8:144"]={spawns={{90,13500,0,448},{90,13500,384,0}},events={{0,77,24,24},{0,80,16}},attached=true},
    ["ecldata7:72"]={spawns={{91,4000,0,0},{91,2100,0,0},{91,1000,0,0}},events={{0,77,24,24},{0,80,16},{0,80,3},{0,82,0},{120,81,3}},attached=true,life=function(o,a) return ({4000,2100,1000,1000,1000,2100,4000})[a[1]+1] end},
    ["ecldata7:68"]={spawns={{91,1500,0,0}},events={{0,77,24,24},{0,160,30},{0,82,0}},attached=true},
    ["ecldata7:23"]={spawns={{91,100,0,0}},events={{0,77,24,24},{0,80,16},{240,81,16}},attached=true},
    ["ecldata7:51"]={spawns={{91,3600,0,0}},events={{0,77,24,24},{0,160,30}},attached=true},
    ["ecldata7:56"]={spawns={{92,3500,0,0}},events={{0,77,24,24},{0,160,30}},attached=true},
    ["ecldata7:64"]={spawns={{92,500,0,0}},events={{0,77,24,24},{0,160,30}},attached=true},
    ["ecldata7:33"]={spawns={{92,3500,0,0}},events={{0,77,24,24},{0,160,30}},attached=true},
    ["ecldata7:37"]={spawns={{91,1500,0,0}},events={{0,80,16},{0,77,24,24},{0,160,30},{210,81,16}},attached=true},
    ["ecldata6:77"]={spawns={{91,250,0,0}},events={{0,77,24,24},{0,80,16},{0,80,3},{120,81,3}},attached=true},
    ["ecldata6:65"]={spawns={{91,4000,0,0}},events={{0,77,24,24},{0,160,30},{0,82,0}},attached=true},
    ["ecldata6:60"]={spawns={{91,400,0,0}},events={{0,77,24,24},{0,160,30},{0,82,0}},attached=true},
    ["ecldata6:25"]={spawns={{91,100,0,0}},events={{0,77,24,24},{0,80,16},{470,81,16}},attached=true},
    ["ecldata6:19"]={spawns={{91,300,0,0}},events={{0,77,24,24},{1,81,3}},attached=true},
    ["ecldata6:39"]={spawns={{91,1500,0,0}},events={{0,77,24,24},{0,160,30}},attached=true},
    ["ecldata6:43"]={spawns={{91,1500,0,0}},events={{0,80,16},{0,77,24,24},{0,160,30},{210,81,16}},attached=true},
    ["ecldata4a:18"]={spawns={{91,600,0,0},{91,300,0,0}},events={{0,77,24,24},{0,160,30},{0,80,16},{1,81,2}},attached=true,life=function(o,a,parent) return parent and parent.th08_combat_card==26 and 300 or 600 end},
    ["ecldata4a:20"]={spawns={{91,300,0,0}},events={{0,77,24,24},{0,160,30},{0,80,16},{1,81,2}},attached=true},
    ["ecldata4a:32"]={spawns={{91,30,0,0}},events={{0,77,24,24},{0,160,30},{1,81,2}},attached=true},
    ["ecldata4a:38"]={spawns={{91,30,0,0}},events={{0,77,24,24},{0,160,30},{0,80,16},{1,81,2}},attached=true},
    ["ecldata4a:42"]={spawns={{92,5000,0,0},{92,3000,0,0}},events={{0,77,24,24},{0,160,30},{0,80,16},{1,81,2}},attached=true,life=function(o,a) return a[4] end},
    ["ecldata4a:47"]={spawns={{91,5000,0,0}},events={{0,77,24,24},{0,160,30},{0,80,16},{0,82,0},{1,81,2}},attached=true},
    ["ecldata4b:21"]={spawns={{92,700,0,0},{92,900,0,0}},events={{0,77,24,24},{0,160,200},{0,80,16},{0,82,0},{1,81,2}},attached=true,life=function(o,a) return a[3] end},
    ["ecldata4b:40"]={spawns={{92,600,0,0},{92,1000,0,0}},events={{0,77,24,24},{0,160,200},{0,80,16},{1,81,2}},attached=true,life=function(o,a) return a[3] end},
    ["ecldata4b:24"]={spawns={{92,4000,0,0},{92,6000,0,0},{92,7000,0,0}},events={{0,77,24,24},{0,160,200},{0,80,16},{0,82,0},{1,81,2}},attached=true,life=function(o,a) return a[6] end},
    ["ecldata4b:46"]={spawns={{92,600,0,0},{92,1000,0,0}},events={{0,77,24,24},{0,160,200},{0,80,16},{0,82,0},{1,81,2}},attached=true,life=function(o,a) return (a[7]==13) and 1000 or 600 end},
    ["ecldata4b:30"]={spawns={{92,6000,0,0},{92,4000,0,0},{92,7000,0,0}},events={{0,77,24,24},{0,160,200},{0,80,16},{0,82,0},{1,81,2}},attached=true,life=function(o,a) return a[7] end},
    ["ecldata4b:52"]={spawns={{92,6000,0,0},{92,10000,0,0}},events={{0,77,24,24},{0,160,200},{0,80,16},{0,82,0},{1,81,2}},attached=true,life=function(o,a) return (a[6]==4 or a[6]==10) and 10000 or 6000 end},
    ["ecldata4b:33"]={spawns={{92,1000,0,0},{92,3000,0,0},{92,700,0,0}},events={{0,77,24,24},{0,160,200},{0,80,16},{0,82,0},{1,81,2}},attached=true,life=function(o,a,parent,n) if parent and parent.th08_combat_card==450 then return 700 end; return n%2==1 and 1000 or 3000 end},
    ["ecldata4b:65"]={spawns={{91,5000,0,0}},events={{0,77,24,24},{0,160,30},{0,80,18}},attached=true},
    ["ecldata4b:70"]={spawns={{94,500,0,0}},events={{0,77,24,24},{0,160,30},{0,80,16},{0,80,3}},attached=false},
    ["ecldata5:55"]={spawns={{92,3000,56,56},{92,3000,-56,56},{92,8000,56,-56},{92,8000,-56,-56}},events={{0,77,24,24},{0,160,30}},attached=true},
    ["ecldata5:68"]={spawns={{90,200,false,false}},events={{0,77,24,24},{0,160,30},{0,82,0}},attached=true},
    ["ecldata5:59"]={spawns={{92,3000,24,32},{92,3000,8,32},{92,3000,-8,32},{92,3000,-24,32},{92,8000,40,32},{92,8000,-40,32}},events={{0,77,24,24},{0,160,30},{0,82,0}},attached=true},
    ["ecldata5:64"]={spawns={{90,1200,16,368},{90,1200,16,432},{90,1200,80,432},{90,1200,368,368},{90,1200,368,432},{90,1200,304,432},{90,1200,16,80},{90,1200,16,16},{90,1200,80,16},{90,1200,368,80},{90,1200,368,16},{90,1200,304,16}},events={{0,77,24,24},{0,160,30},{0,80,8192}},attached=true},
    ["ecldata5:77"]={spawns={{91,200,0,0}},events={{0,77,24,24},{0,160,30}},attached=true},
    ["ecldata5:81"]={spawns={{90,300,false,false}},events={{0,77,24,24},{0,160,30},{0,82,0}},attached=true},
    ["ecldata2:20"]={spawns={{91,400,0,0}},events={{0,77,24,24},{0,160,30},{0,80,1},{60,81,2},{60,81,1}},attached=true},
    ["ecldata2:28"]={spawns={{91,600,0,0}},events={{0,77,24,24},{0,160,30},{0,80,1},{60,81,2},{60,81,1}},attached=true},
    ["ecldata2:43"]={spawns={{90,50,false,false}},events={{0,77,24,24},{0,160,30},{0,80,1},{60,81,2},{60,81,1}},attached=true},
    ["ecldata2:30"]={spawns={{91,100,0,0}},events={{0,77,24,24},{0,160,30},{1,80,1},{21,81,1}},attached=true},
    ["ecldata2:47"]={spawns={{91,20,0,0}},events={{0,77,24,24},{0,160,30},{0,80,16},{0,80,1},{60,81,1},{160,81,16}},attached=true},
    ["ecldata2:49"]={spawns={{91,20,0,0}},events={{0,77,24,24},{0,160,30},{0,80,16},{0,80,1},{60,81,1},{160,81,16}},attached=true},
    ["ecldata2:59"]={spawns={{91,100,0,0}},events={{0,77,24,24},{0,160,30},{0,80,1},{20,81,1}},attached=true},
    ["ecldata1:19"]={spawns={{92,100,0,0}},events={{0,77,24,24},{0,79,16}},attached=true},
    ["ecldata1:24"]={spawns={{91,40,0,0}},events={{0,77,24,24},{0,80,3},{0,82,0},{100,81,3}},attached=true},
    ["ecldata1:32"]={spawns={{90,120,false,false}},events={{0,77,24,24},{0,79,16},{0,160,50}},attached=true},
    ["ecldata1:36"]={spawns={{91,200,0,0},{91,160,0,0}},events={{0,77,24,24},{0,79,16},{0,160,10}},attached=true,life=function(o,a) return a[4]==120 and 160 or 200 end},
    ["ecldata1:43"]={spawns={},events={{0,77,24,24},{0,79,16},{0,160,10}},attached=true,life=function(o,a) return math.abs(math.cos(a[3]))>0.5 and 10 or 60 end},
    ["ecldata1:46"]={spawns={{91,20,0,0}},events={{0,77,24,24},{0,79,16},{0,160,60}},attached=true},
    ["ecldata8:141"]={spawns={{91,13500,0,0}},events={{0,77,24,24},{0,160,30},{0,82,0},{0,80,16},{120,80,8}},attached=true},
}

-- 形态只推进自机的7帧过渡，不暂停敌机ECL或重置发弹计时。
return function()
    local M={profiles=profiles}
    profiles["ecldata8:140"]=profiles["ecldata8:139"]
    local stage_sources=dofile('mod/GAME/th31_stage_sources.lua')
    local phase_events=dofile('mod/GAME/th31_phase_events.lua')
    local function bit(v,b) return math.floor(v/b)%2==1 end
    -- EnemyManagerUpdate.cpp:228..262 用当前主ANM的精灵宽高判出屏。
    -- 受击框、对象缩放、附属动画都不参与 GameManager::IsWithinPlayfield。
    function M.actor_outside(o,x,y)
        -- SpawnEnemy2的出生RunEcl不经过管理器的出屏回收阶段。
        if o.th08_ecl_birth then return false end
        local actor=o._original_actor
        local vm=actor and actor.vm
        local sprite=vm and vm.data.sprites[vm.sprite]
        if not sprite then return false end
        local hw,hh=sprite[4]/2,sprite[5]/2
        x,y=x or o.x,y or o.y
        return x+hw < -192 or x-hw > 192 or y+hh < -224 or y-hh > 224
    end
    -- 道中同样使用主ANM精灵范围；NO_SPRITE不能首次置hasBeenInBounds。
    function M.actor_inside(o,x,y,entering)
        local actor=o._original_actor
        local vm=actor and actor.vm
        if not vm or not vm.data.sprites[vm.sprite] then return false end
        if entering and o._original_hidden then return false end
        return not M.actor_outside(o,x,y)
    end
    function M.unit_begin(o)
        if not M.parent_alive(o) then M.discard(o);return false end
        local age=o.th08_unit_age or 1
        if OriginalStageVisual then OriginalStageVisual.source_frame(o,age) end
        o.th08_unit_age=age+1
        return true
    end
    -- 敌机型斩击使用轴对齐接触框，原作CheckPlayerCollision先把全宽高除以1.5。
    function M.contact_box(o,x,y,width,height)
        local function contact(p)
            if p and IsValid(p) and math.abs(p.x-x)<=width/3+(p.A or p.a or 0)
                and math.abs(p.y-y)<=height/3+(p.B or p.b or 0) then
                p.class.colli(p,o)
            end
        end
        if GameNet then GameNet.forEachPlayer(contact) else contact(player) end
    end
    -- 原作死亡时立即摘除附着链；Lua数组长度不能代表仍存活的使魔数。
    function M.actor_count(list)
        local n=0
        for i=1,#list do
            local o=list[i]
            if IsValid(o) and not o.th08_dead and o.status~='del' and o.status~='kill' then n=n+1;list[n]=o end
        end
        for i=#list,n+1,-1 do list[i]=nil end
        return n
    end
    local form_stage,form_player,form_stamp,form_focus,form_frames,form_youkai
    form_frames,form_youkai=0,false
    M.form_tick=0
    function M.form()
        local current=stage and stage.current_stage
        local stamp=current and current.timer
        if type(stamp)~='number' then stamp=M.form_tick end
        if current~=form_stage or player~=form_player or (form_stamp and stamp<form_stamp) then
            form_stage,form_player,form_stamp=current,player,nil
            form_focus,form_frames,form_youkai=nil,0,false
        end
        if stamp~=form_stamp then
            form_stamp=stamp
            local focus=player~=nil and player.slow==1
            if focus~=form_focus then form_focus,form_frames=focus,0
            else form_frames=form_frames+1 end
            if form_frames>=7 then form_youkai=focus end
        end
        return form_youkai
    end
    -- 只有90..92生成的附着使魔更新 youkaiAligned；独立敌机与Boss不跟随自机切换。
    function M.youkai(o)
        if o and not o.th08_attached then return false end
        return M.form()
    end
    -- 原作DispatchShotInstruction以发射对象的位置判断近身停火，和枪口偏移无关。
    function M.can_shoot(o)
        local limit=o and o.th08_shot_distance2
        if not limit or limit<=0 then return true end
        return (o.x-player.x)^2+(o.y-player.y)^2>=limit
    end
    function M.shot_allowed(o,flags)
        if not M.can_shoot(o) then return false end
        local youkai=M.youkai(o)
        return not (bit(flags,0x8000) and not youkai or bit(flags,0x10000) and youkai)
    end
    -- 原作妖怪形态仍画使魔，但染蓝且半透明（EnemyManagerUpdate.cpp:625..631）。
    function M.render(o,render)
        if not M.youkai(o) then return render(o) end
        local r,g,b,a=o._r,o._g,o._b,o._a
        local color=o._original_enemy_color
        -- EnemyManager覆写主VM的color2；不能把原精灵色再乘一次蓝色，更不能染附属VM。
        o._original_enemy_color={32,32,192}
        o._r,o._g,o._b,o._a=32,32,192,(a or 255)/2
        render(o)
        o._r,o._g,o._b,o._a=r,g,b,a
        o._original_enemy_color=color
    end
    -- 手写ECL分支也必须改判定字段；CALL后的开关不一定在宿主的静态ANM事件表中。
    function M.unit_flags(o,enabled,flags)
        if bit(flags,1) then o._original_accepts_damage=enabled end
        if bit(flags,2) then o._original_familiar_collision=enabled end
        if bit(flags,4) then o._original_damageable=enabled end
        if bit(flags,8) then o._original_hidden=not enabled end
        if bit(flags,16) then o.allow_off=not enabled end
        if bit(flags,32) then o._original_no_death=not enabled end
    end
    function M.unit_collision(o)
        o.th08_youkai=M.youkai(o)
        local human=not o.th08_youkai and not o._original_hidden and o.seen==true and o.alive~=false
        local collision=human and o._original_familiar_collision~=false
        o.group=collision and GROUP.ENEMY or GROUP.NONTJT
        SetAttr(o,'colli',human and (o._original_accepts_damage~=false or collision))
        if o.th08_attached and OriginalStageVisual then OriginalStageVisual.familiar(o,o.th08_youkai) end
    end
    -- 91的附着关系与92的逐帧坐标继承不同；不能用u.parent同时表示两件事。
    function M.link_marker(parent) return {th08_link_parent=parent} end
    function M.parent_alive(o)
        if not o.th08_attached then return true end
        local parent=o.th08_parent
        return parent and IsValid(parent) and parent.status~='del' and parent.status~='kill'
            and not parent.th08_dead and parent.alive~=false
    end
    function M.detach_children(o)
        local children=o.th08_children
        o.th08_children=nil
        for _,child in ipairs(children or {}) do M.discard(child) end
    end
    -- RawDel绕过del回调；所有原生删除出口先收回附着链，独立93/94不进入该链。
    function M.discard(o)
        if not o or not IsValid(o) then return end
        M.detach_children(o)
        if not o.th08_dead then
            o.th08_dead,o.alive=true,false
            SetAttr(o,'colli',false)
            task.Clear(o)
            if OriginalStageVisual then OriginalStageVisual.release_familiar(o) end
        end
        object.RawDel(o)
    end
    local function card_owner(parent)
        if parent and parent.th08_card_owner then return parent.th08_card_owner end
        if parent and parent.th08_combat_card then return parent end
        return M.owner
    end
    local function spell_context(owner)
        local card=owner and owner.current_card
        return not not (card and card.is_sc and (card.th08_motion_source or card.th08_lastword_source or card._original_balance))
    end
    local function attach(o,parent,linked)
        o.th08_parent,o.th08_attached=parent,linked and parent~=nil
        local owner=card_owner(parent)
        o.th08_card_owner=owner
        if owner then
            owner.th08_actors=owner.th08_actors or {}
            owner.th08_actors[#owner.th08_actors+1]=o
        end
        if o.th08_attached then
            parent.th08_children=parent.th08_children or {}
            parent.th08_children[#parent.th08_children+1]=o
        end
        return owner
    end
    -- ApplyDamageToParent不经父机的ACCEPTS_DAMAGE/DAMAGEABLE，且不重复计分、掉落。
    function M.transfer_damage(o,amount)
        if not o.th08_attached or not M.parent_alive(o) or (player and (player.nextspell or 0)>0) then return end
        local parent=o.th08_parent
        local damage=math.floor(amount/(o._original_hp_scale or 1)/2)
        local clock=parent._original_interaction_clock or 0
        local balance=parent.current_card and parent.current_card._original_balance
        local t=math.max(0,(parent.th08_source_clock or 1)-1)
        local inherited_guard=balance and (balance.guard or 0)>0 and t>=balance.immune and t<balance.immune+balance.guard
        local reduced=inherited_guard or parent.th08_guard_active or parent.protect
            or (parent.reduction or parent.invuln or 0)>0
            or (parent._original_reduction_until or 0)>clock
        if reduced then
            if parent._bosssys or parent.is_boss then damage=math.floor(damage/9) else return end
        end
        if damage<=0 then return end
        local before=parent.hp
        parent.hp=math.max(0,parent.hp-damage*(parent._original_hp_scale or 1))
        if parent.spell_damage then parent.spell_damage=parent.spell_damage+before-parent.hp end
    end
    -- 道中使用手动调度的enemy类，形态判定须包住它自己的伤害分发入口。
    function M.unit(define)
        local init,frame,render=define.init,define.frame,define.render or DefaultRenderFunc
        local kill,del=define.kill or enemy.kill,define.del or enemy.del
        local unitbase=Class(enemy,{
            take_damage=function(o,amount)
                if o.th08_dead or o.alive==false or M.youkai(o) or o._original_hidden or o._original_accepts_damage==false
                    or o._original_damageable==false then return end
                local effective=not o.protect and amount*(o.dmg_factor or 1)*(o.DMG_factor or 1)*(o.astral_dmg_factor or 1) or 0
                enemy.take_damage(o,amount)
                M.transfer_damage(o,effective)
            end,
        })
        define.init=function(o,sub,x,y,mirror,parent,...)
            local linked=parent
            for i=1,select('#',...) do
                local arg=select(i,...)
                if type(arg)=='table' and arg.th08_link_parent~=nil then linked=arg.th08_link_parent or nil end
            end
            o.th08_parent,o.th08_attached=linked,false
            o.th08_card_owner=card_owner(linked)
            o._original_accepts_damage,o._original_damageable,o._original_no_death=true,true,false
            o._original_familiar_collision=true
            local previous=M.current_enemy;M.current_enemy=o
            init(o,sub,x,y,mirror,parent,...)
            M.current_enemy=previous
            if not IsValid(o) then return end
            if o.status=='del' or o.status=='kill' then M.discard(o);return end
            o.th08_unit_age=1 -- 构造器已完成出生ECL；手动敌机循环从t1继续。
            if OriginalStageVisual and define.source_file then
                OriginalStageVisual.bind_source(o,8,define.source_file..':'..sub)
            end
            local owner=attach(o,linked,linked~=nil)
            if linked then o._original_familiar_collision=false end
            if OriginalBalance then OriginalBalance.unit(o,8,spell_context(owner)) end
            M.unit_collision(o)
        end
        define.frame=function(o)
            if not M.parent_alive(o) then M.discard(o);return end
            if OriginalStageVisual then OriginalStageVisual.source_frame(o,o.timer) end
            local previous=M.current_enemy;M.current_enemy=o
            frame(o)
            M.current_enemy=previous
            if IsValid(o) and OriginalStageVisual then OriginalStageVisual.tick(o) end
        end
        define.render=function(o) M.render(o,function(unit)
            if not OriginalStageVisual or not OriginalStageVisual.draw(unit) then render(unit) end
        end) end
        define.kill=function(o)
            if o._original_no_death then object.Preserve(o);return end
            M.detach_children(o)
            if OriginalStageVisual then OriginalStageVisual.release_familiar(o) end
            if kill then kill(o) end
        end
        define.del=function(o)
            M.detach_children(o)
            if OriginalStageVisual then OriginalStageVisual.release_familiar(o) end
            if del then del(o) end
        end
        return Class(unitbase,define)
    end
    local function event(o,e)
        local op,v=e[2],e[3]
        if op==77 then
            o.a,o.b,o.rect=v/2,e[4]/2,true
            o._original_damage_box={v,e[4]}
        elseif op==82 then o.th08_shot_distance2=v*v
        elseif op==160 then o.th08_guard=v
        elseif op==79 then o.th08_flags=v
        elseif op==80 or op==81 then
            for _,b in ipairs({1,2,4,8,16,32}) do
                if bit(v,b) and bit(o.th08_flags,b)~=(op==80) then
                    o.th08_flags=o.th08_flags+(op==80 and b or -b)
                end
            end
        end
    end
    local function refresh(o)
        local f=o.th08_flags
        o.th08_youkai=M.youkai(o)
        local human=not o.th08_youkai and o.th08_seen==true
        o.th08_accept=human and not bit(f,1) and not bit(f,8)
        o.th08_damageable=not bit(f,4)
        o.th08_no_death=bit(f,32)
        o.group=not bit(f,2) and human and not bit(f,8) and GROUP.ENEMY or GROUP.NONTJT
        o.colli=o.th08_accept or (o.group==GROUP.ENEMY)
        o.th08_guard_active=(o.th08_guard or 0)>0
        if o.th08_attached and OriginalStageVisual then OriginalStageVisual.familiar(o,o.th08_youkai) end
    end
    local function alive(o) return IsValid(o) and not o.th08_dead end
    local function damage(o,amount)
        if o.th08_dead or not o.th08_accept or not o.th08_damageable or o.th08_guard_active then return end
        amount=amount*(o.dmg_factor or 1)*(o.DMG_factor or 1)*(o.astral_dmg_factor or 1)
        if amount<=0 then return end
        o.hp=o.hp-amount
        M.transfer_damage(o,amount)
        if o.hp<=0 and not o.th08_no_death then
            o.th08_dead=true
            task.Clear(o)
            object.Kill(o)
        end
    end
    local base=Class(object,{
        take_damage=damage, take_damage2=damage,
        colli=function(o,other)
            if not other.dmg then return end
            local amount=other.dmg
            if GameDrops and GameDrops.damage then amount=GameDrops.damage(amount,other) end
            damage(o,amount)
            if not other.killflag then object.Kill(other) end
        end,
    },true)
    M.base=base
    local function parent_for(args)
        if M.current_enemy then return M.current_enemy end
        if task.stack and #task.stack>0 then
            local o=task.GetSelf()
            if o.th08_combat_card or o.th08_profile or o.th08_unit_age then return o end
        end
        local o=args[1]
        if type(o)=='table' and (o.th08_combat_card or o.th08_profile or o.th08_unit_age) then return o end
        return M.owner
    end
    local function life(cfg,o,args,parent,n)
        if cfg.life then return assert(cfg.life(o,args,parent,n),'缺少使魔生命值') end
        local unique
        for _,p in ipairs(cfg.spawns) do
            if unique and unique~=p[2] then unique=false;break end
            unique=p[2]
        end
        if unique then return unique end
        -- 绝对/相对生成点的同名子程序可以有不同生命值，按原生出生点匹配。
        local found
        for _,p in ipairs(cfg.spawns) do
            if p[3] and p[4] then
                local x,y=p[3]-192,224-p[4]
                if p[1]==91 or p[1]==92 then
                    if parent then x,y=parent.x+p[3],parent.y-p[4] end
                end
                if math.abs(o.x-x)<0.01 and math.abs(o.y-y)<0.01 then
                    assert(not found or found==p[2],'使魔生命值存在未解析的出生变体')
                    found=p[2]
                end
            end
        end
        return assert(found,'无法匹配原作使魔生命值')
    end
    -- 只接收已逐支核对的原生Lua更新函数；不读取ECL、不推进正常管理器阶段。
    function M.birth_step(o,step,fields)
        local x,y=o.x,o.y
        fields=fields or {}
        local saved={}
        for i=1,#fields do saved[i]=o[fields[i]] end
        o.th08_ecl_birth=true
        local linked,previous=o.th08_attached,M.current_enemy
        o.th08_attached=false;M.current_enemy=o
        step(o)
        o.th08_attached=linked;M.current_enemy=previous
        if not IsValid(o) or o.status=='del' or o.status=='kill' then return false end
        o.th08_ecl_birth=nil
        o.x,o.y=x,y
        for i=1,#fields do o[fields[i]]=saved[i] end
        return true
    end
    function M.actor(key,define)
        local cfg=assert(profiles[key],key)
        local init,frame,kill,del=define.init,define.frame,define.kill,define.del
        local birth=define.ecl_birth
        define.ecl_birth=nil
        local render=define.render or DefaultRenderFunc
        define.render=function(o) M.render(o,function(unit)
            if not OriginalStageVisual or not OriginalStageVisual.draw(unit) then render(unit) end
        end) end
        define.init=function(o,...)
            local args={...};local parent=parent_for(args)
            o.th08_source,o.th08_profile=key,cfg
            o.th08_card_owner=card_owner(parent)
            local previous=M.current_enemy;M.current_enemy=o
            init(o,...)
            M.current_enemy=previous
            if not IsValid(o) then return end
            if o.status=='del' or o.status=='kill' then M.discard(o);return end
            local profile=cfg
            -- 同一个Lua类的不同ECL变体必须连同显示源一起切换，不能只换交互表。
            local source_key=cfg.variants and cfg.variants[args[1]] or key
            if source_key~=key then profile=assert(profiles[source_key]) end
            o.th08_source,o.th08_profile=source_key,profile
            local owner=attach(o,parent,profile.attached)
            if OriginalStageVisual and not o._original_explicit then
                -- 变量选择的ANM由对象构造函数按生成参数设置；固定事件不能清掉它。
                OriginalStageVisual.bind_source(o,8,source_key,o._original_actor~=nil)
            end
            if profile.attached then o._original_familiar_collision=false end
            local n=1
            if parent then
                parent.th08_actor_counts=parent.th08_actor_counts or {}
                n=(parent.th08_actor_counts[key] or 0)+1;parent.th08_actor_counts[key]=n
            end
            o.hp=life(profile,o,args,parent,n);o.maxhp=o.hp
            if OriginalBalance then OriginalBalance.unit(o,8,spell_context(owner)) end
            o.th08_flags,o.th08_guard,o.th08_clock,o.th08_event=0,0,1,1
            o.th08_shot_distance2=1024
            o.dmg_factor,o.DMG_factor,o.astral_dmg_factor=1,1,1
            while profile.events[o.th08_event] and profile.events[o.th08_event][1]==0 do
                event(o,profile.events[o.th08_event]);o.th08_event=o.th08_event+1
            end
            -- 90..92 在新敌机跑完 t=0 后才清 COLLISION；保留 ACCEPTS_DAMAGE。
            if profile.attached and not bit(o.th08_flags,2) then o.th08_flags=o.th08_flags+2 end
            refresh(o)
            if birth then
                -- 只对逐支核对过的使魔启用：出生先跑主/子ECL及UpdateMovement，
                -- 保留角、半径、速度和插值timer，但坐标尚未IntegrateVelocity。
                M.birth_step(o,frame,type(birth)=='table' and birth or nil)
            end
        end
        define.frame=function(o)
            if o.th08_dead then return end
            if not M.parent_alive(o) then M.discard(o);return end
            -- 铃仙 ExIns 冻结附着链时，原作跳过 ECL 与受击。
            if o.c456_paused or o.c458_paused then
                o.colli,o.th08_accept=false,false
                o.th08_guard=math.max(0,o.th08_guard-1)
                if frame then frame(o) end
                return
            end
            local profile=o.th08_profile
            if OriginalStageVisual then OriginalStageVisual.source_frame(o,o.th08_clock) end
            while profile.events[o.th08_event] and profile.events[o.th08_event][1]<=o.th08_clock do
                event(o,profile.events[o.th08_event]);o.th08_event=o.th08_event+1
            end
            refresh(o)
            local previous=M.current_enemy;M.current_enemy=o
            if frame then frame(o) end
            M.current_enemy=previous
            if IsValid(o) and (o.status=='del' or o.status=='kill') then M.discard(o);return end
            if IsValid(o) then
                if M.actor_inside(o,o.x,o.y,true) then o.th08_seen=true end
                refresh(o) -- 本次运动后入场的对象，本帧即可参与判定。
                if OriginalStageVisual then OriginalStageVisual.tick(o,o.th08_animation_vx) end
                o.th08_guard=math.max(0,o.th08_guard-1)
                o.th08_clock=o.th08_clock+1
            end
        end
        define.kill=function(o)
            if OriginalStageVisual then OriginalStageVisual.release_familiar(o) end
            o.th08_dead=true;task.Clear(o)
            M.detach_children(o)
            if kill then kill(o) end
        end
        define.del=function(o)
            if OriginalStageVisual then OriginalStageVisual.release_familiar(o) end
            o.th08_dead=true;task.Clear(o)
            M.detach_children(o)
            if del then del(o) end
        end
        return Class(base,define)
    end
    -- {原始life, 可受伤时点, 随后九倍防御帧数}；普通LW未进入既有灵梦血量覆盖表。
    -- life来源：1sp/Sub42、2sp/52、3sp/63、5sp/52、6sp/80、7sp/83、8sp/116
    -- 及 _al/8、_rm/8、_sk/9、_ym/10、_yy/11；各分支在 SET_LIFE 后 CALL 对应LW。
    M.lastwords={
        [205]={3300,110,120}, [206]={3300,110,240}, [207]={4800,110,120},
        [208]={3500,110,240}, [209]={4000,110,420}, [210]={4000,110,180},
        [211]={4000,110,240}, [212]={4400,110,240}, [213]={4000,110,60},
        [216]={3300,110,120}, [217]={3300,110,120}, [218]={6000,110,120},
        [219]={4000,110,120}, [220]={5000,110,120},
    }
    -- 17张LW的生成助手都在t=43、CALL根程序前执行ins_77(48,32)。
    -- 不能沿用角色行走图的默认椭圆，也不能只读根程序t=0的指令。
    M.lastword_sources={
        [205]={file='ecldata1sp',sub=36,origin=42},
        [206]={file='ecldata2sp',sub=46,origin=52},
        [207]={file='ecldata3sp',sub=56,origin=63},
        [208]={file='ecldata5sp',sub=40,origin=52},
        [209]={file='ecldata6sp',sub=76,origin=80},
        [210]={file='ecldata7sp',sub=79,origin=83},
        [211]={file='ecldata8sp',sub=110,origin=116},
        [212]={file='ecldata5sp',sub=43,origin=52},
        [213]={file='ecldata8sp',sub=113,origin=116},
        [214]={file='ecldata4asp',sub=43,origin=50},
        [215]={file='ecldata4bsp',sub=60,origin=70},
        [216]={file='ecldata_sk',sub=1,origin=9},
        [217]={file='ecldata_ym',sub=1,origin=10},
        [218]={file='ecldata_al',sub=1,origin=8},
        [219]={file='ecldata_rm',sub=1,origin=8},
        [220]={file='ecldata_yy',sub=1,origin=11},
        [221]={file='ecldata_yk',sub=4,origin=18},
    }
    -- 原作这些阶段关闭ACCEPTS_DAMAGE，不能因审计表里有继承life就变成可击破卡。
    -- ecldata7 Sub77/80/82/84/87在t=0关闭；ecldata8 Sub149先关闭DAMAGEABLE，
    -- t=90再关闭ACCEPTS_DAMAGE与体术。数值仅表示本体接触判定保留到哪一帧。
    M.survival_contact_until={[174]=0,[178]=0,[182]=0,[186]=0,[190]=0,[204]=90}
    function M.bind(card,id)
        local init,frame,del=card.init,card.frame,card.del
        local lw=M.lastwords[id]
        card.th08_lastword_source=M.lastword_sources[id]
        card.init=function(o)
            local stage_key=stage_sources[card.th08_registered_id]
            if stage_key then OriginalStageVisual.presentation.enter_stage(8,stage_key) end
            M.owner=o;o.th08_combat_card=id;o.th08_combat_time=0
            o.DMG_factor=1
            local balance=card._original_balance
            o._original_hp_scale=balance and OriginalBalance.scale[8][balance.spell and 'spell' or 'normal'] or nil
            o.th08_actors,o.th08_actor_counts,o.th08_children={},{},{}
            if card.t1<card.t3 then o.no_hp_render,o.NotPlayTimeOutSound=false,false end
            if lw then o.colli=true end
            -- 每个阶段独立推进ECL显示与判定事件，不能只绑定角色默认行走图。
            o._original_secondary_box=nil
            o._original_no_damage_during_bomb=false
            o._original_reduction_until=nil
            o._original_accepts_damage,o._original_damageable=true,true
            o._original_familiar_collision=true
            o._original_hidden=false
            init(o)
            -- 时间轴t1的无判定效果实体此前被筛掉；战斗子机仍走原有实体实现。
            local ambient=({[1000]='ecldata1:14',[1001]='ecldata4a:15',
                [1003]='ecldata2:16'})[id]
            if ambient then OriginalStageVisual.presentation.start(o,8,ambient,-162,240,1) end
            if id==467 or id==468 then
                _editor_class.TH31.th08_nightblind.install(o,57)
            elseif id==469 then
                local carry=o.th08_blind_carry or {255,48}
                _editor_class.TH31.th08_nightblind.hold(o,carry[1],carry[2])
            end
            local source=card.th08_motion_source or card.th08_lastword_source
            if source then
                local key=source.file..':'..source.sub
                local events=phase_events[key]
                -- Sub36 t192生成的NO_DEATH烟尘跨过后续阶段；单独练习缺少前段时从稳态循环开始。
                if source.file=='ecldata6' and ({[56]=true,[40]=true,[63]=true,[44]=true,[68]=true,[73]=true,[78]=true})[source.sub] then
                    OriginalStageVisual.presentation.ambient_start(8,'ecldata6','ecldata6:15',-192,224,{pc=8,time=20})
                end
                OriginalStageVisual.bind_source(o,8,key,true,events and events.visual)
                if events then
                    o._original_interaction_events=events.interaction
                    o._original_interaction_index=1
                    o._original_reduction_until=nil
                    OriginalCollision.events(o,0)
                end
                o.th08_source_clock=0
            else o.th08_source_clock=nil end
            local contact_until=M.survival_contact_until[id]
            if contact_until then o.colli=contact_until>0 end
            if card.th08_lastword_source then
                o._original_collision_game=8
                o._original_damage_box={48,32}
                o._original_contact_box=nil
                o.a,o.b,o.rect=24,16,true
            end
        end
        card.frame=function(o)
            -- 原ScreenEffect calc优先级3在EnemyManager 11之前，随机消费同样先于敌机。
            OriginalStageVisual.presentation.advance_shake()
            -- 每帧推进，包括before入场期；不能等到下一次发弹/有使魔才开始数7帧。
            M.form_tick=M.form_tick+1
            M.form()
            if o.th08_combat_card==id then
                M.owner=o
                if o.th08_source_clock then
                    OriginalStageVisual.source_frame(o,o.th08_source_clock)
                    o.th08_source_clock=o.th08_source_clock+1
                    local visible=not o._original_hidden
                    o.group=o._original_familiar_collision and GROUP.ENEMY or GROUP.NONTJT
                    o._colli=visible and (o._original_accepts_damage or o._original_familiar_collision)
                    SetAttr(o,'colli',o._colli)
                    o.DMG_factor=o._original_damageable and 1 or 0
                end
                local contact_until=M.survival_contact_until[id]
                if contact_until then
                    o.colli=o.th08_combat_time<contact_until
                    o.th08_combat_time=o.th08_combat_time+1
                end
                if lw and not card._original_balance then
                    local t=o.th08_combat_time
                    o.DMG_factor=(t>=lw[2] and t<lw[2]+lw[3]) and 1/9 or 1
                    o.th08_combat_time=t+1
                end
            end
            frame(o)
        end
        card.del=function(o)
            OriginalStageVisual.presentation.clear(o)
            _editor_class.TH31.th08_nightblind.release(o)
            del(o)
            for _,a in ipairs(o.th08_actors or {}) do if alive(a) then M.discard(a) end end
            o.th08_actors,o.th08_combat_card,o.th08_source_clock=nil,nil,nil
            o._original_secondary_box,o._original_no_damage_during_bomb=nil,nil
            o.DMG_factor=1
            if M.owner==o then M.owner=nil end
        end
    end
    return M
end
