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
    ["ecldata8sp:8"]={spawns={{90,1350,64,128},{90,1350,320,128},{90,750,152,220},{90,750,232,220},{90,1350,32,188},{90,1350,352,188},{90,750,162,150},{90,750,222,150}},events={{0,77,24,24},{0,160,30}},attached=true},
    ["ecldata8sp:17"]={spawns={{90,1350,64,128},{90,1350,320,128},{90,750,152,220},{90,750,232,220},{90,1350,32,188},{90,1350,352,188},{90,750,162,150},{90,750,222,150}},events={{0,77,24,24},{0,160,30}},attached=true},
    ["ecldata8sp:50"]={spawns={{90,13500,96,128},{90,13500,288,128}},events={{0,77,24,24},{0,160,30},{1,81,3}},attached=true},
    ["ecldata8sp:55"]={spawns={{91,13500,false,0}},events={{0,77,24,24},{0,160,30},{1,81,3}},attached=true},
    ["ecldata8sp:58"]={spawns={{91,13500,0,0}},events={{0,77,24,24},{0,160,30},{0,82,0},{1,81,3}},attached=true},
    ["ecldata8sp:63"]={spawns={{92,13500,-96,-16},{92,13500,96,-16},{92,13500,-64,32},{92,13500,64,32}},events={{0,77,24,24},{0,160,30},{1,81,3}},attached=true},
    ["ecldata8sp:68"]={spawns={{91,13500,false,false},{91,13500,0,0}},events={{0,77,24,24},{0,160,30},{1,81,3},{61,82,0}},attached=true},
    ["ecldata8sp:73"]={spawns={{91,13500,0,0}},events={{0,77,24,24},{0,160,30},{1,81,3},{1,82,0}},attached=true},
    ["ecldata8sp:81"]={spawns={{91,13500,0,0}},events={{0,77,24,24},{0,80,16},{0,82,0},{120,80,8}},attached=true},
    ["ecldata8sp:93"]={spawns={{91,13500,88,-32},{91,13500,-88,-32}},events={{0,77,24,24},{0,160,30},{0,82,0}},attached=true},
    ["ecldata8sp:98"]={spawns={{90,13500,0,448},{90,13500,384,0}},events={{0,77,24,24},{0,80,16}},attached=true},
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
    ["ecldata8sp:95"]={spawns={{91,13500,0,0}},events={{0,77,24,24},{0,160,30},{0,82,0},{0,80,16},{120,80,8}},attached=true},
}

-- 形态只推进自机的7帧过渡，不暂停敌机ECL或重置发弹计时。
return function()
    local M={profiles=profiles}
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
    -- 原作死亡时立即摘除附着链；Lua数组长度不能代表仍存活的使魔数。
    function M.actor_count(list)
        local n=0
        for i=1,#list do
            local o=list[i]
            if IsValid(o) and not o.th08_dead then n=n+1;list[n]=o end
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
    function M.unit_collision(o)
        o.th08_youkai=M.youkai(o)
        if o.th08_attached and OriginalStageVisual then OriginalStageVisual.familiar(o,o.th08_youkai) end
        -- enemybase把Lua的colli赋值记作持久_colli开关；形态只改本帧引擎判定，不能关死它。
        if o.th08_youkai then SetAttr(o,'colli',false) end
    end
    -- 道中使用手动调度的enemy类，形态判定须包住它自己的伤害分发入口。
    function M.unit(define)
        local init,frame,render=define.init,define.frame,define.render or DefaultRenderFunc
        local kill,del=define.kill or enemy.kill,define.del or enemy.del
        local unitbase=Class(enemy,{
            take_damage=function(o,amount)
                if M.youkai(o) then return end
                local hp=o.hp
                enemy.take_damage(o,amount)
                if o.th08_attached and IsValid(o.th08_parent) then
                    local dealt=hp-o.hp
                    local scale=o._original_hp_scale or 1
                    if dealt/scale>=2 then
                        Damage(o.th08_parent,math.floor(dealt/scale/2)*(o.th08_parent._original_hp_scale or 1))
                    end
                end
            end,
        })
        define.init=function(o,sub,x,y,mirror,parent,...)
            init(o,sub,x,y,mirror,parent,...)
            o.th08_parent,o.th08_attached=parent,parent~=nil
            if OriginalStageVisual and define.source_file then
                OriginalStageVisual.bind_source(o,8,define.source_file..':'..sub)
            end
            if parent then o._original_familiar_collision=false end
            if OriginalBalance then OriginalBalance.unit(o,8,parent and parent.current_card and parent.current_card.is_sc) end
            if parent then o.group=GROUP.NONTJT end
            M.unit_collision(o)
        end
        define.frame=function(o)
            if OriginalStageVisual then OriginalStageVisual.source_frame(o,o.timer) end
            frame(o)
            if IsValid(o) and OriginalStageVisual then OriginalStageVisual.tick(o) end
        end
        define.render=function(o) M.render(o,function(unit)
            if not OriginalStageVisual or not OriginalStageVisual.draw(unit) then render(unit) end
        end) end
        define.kill=function(o)
            if OriginalStageVisual then OriginalStageVisual.release_familiar(o) end
            if kill then kill(o) end
        end
        define.del=function(o)
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
        local human=not o.th08_youkai
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
        -- Enemy::ApplyDamageToParent：使魔实受伤害的一半传给父机；没有额外击破伤害。
        local parent=o.th08_parent
        local scale=o._original_hp_scale or 1
        if o.th08_attached and parent and IsValid(parent) and amount/scale>=2 then
            local parentScale=parent._original_hp_scale or 1
            Damage(parent,math.floor(amount/scale/2)*parentScale)
        end
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
        if type(args[1])=='table' and args[1].th08_combat_card then return args[1] end
        if task.stack and #task.stack>0 then
            local o=task.GetSelf()
            if o.th08_combat_card then return o end
            if o.th08_parent then return o.th08_parent end
        end
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
        step(o)
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
            init(o,...)
            if not IsValid(o) then return end
            local profile=cfg
            -- 大凤凰在第120帧变成隐藏枪架；另两种凤凰始终使用普通使魔交互。
            if key=='ecldata8sp:93' and args[1]==95 then profile=profiles['ecldata8sp:95'] end
            o.th08_source,o.th08_profile=key,profile
            o.th08_parent,o.th08_attached=parent,profile.attached
            if OriginalStageVisual and not o._original_explicit then
                -- 变量选择的ANM由对象构造函数按生成参数设置；固定事件不能清掉它。
                OriginalStageVisual.bind_source(o,8,key,o._original_actor~=nil)
            end
            if profile.attached then o._original_familiar_collision=false end
            local n=1
            if parent then
                parent.th08_actor_counts=parent.th08_actor_counts or {}
                n=(parent.th08_actor_counts[key] or 0)+1;parent.th08_actor_counts[key]=n
                parent.th08_actors=parent.th08_actors or {};table.insert(parent.th08_actors,o)
            end
            o.hp=life(profile,o,args,parent,n);o.maxhp=o.hp
            if OriginalBalance then OriginalBalance.unit(o,8,parent and parent.current_card and parent.current_card.is_sc) end
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
            if frame then frame(o) end
            if IsValid(o) then
                if OriginalStageVisual then OriginalStageVisual.tick(o) end
                o.th08_guard=math.max(0,o.th08_guard-1)
                o.th08_clock=o.th08_clock+1
            end
        end
        define.kill=function(o)
            if OriginalStageVisual then OriginalStageVisual.release_familiar(o) end
            o.th08_dead=true;task.Clear(o)
            if kill then kill(o) end
        end
        define.del=function(o)
            if OriginalStageVisual then OriginalStageVisual.release_familiar(o) end
            o.th08_dead=true;task.Clear(o)
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
            M.owner=o;o.th08_combat_card=id;o.th08_combat_time=0
            o.DMG_factor=1
            local balance=card._original_balance
            o._original_hp_scale=balance and OriginalBalance.scale[8][balance.spell and 'spell' or 'normal'] or nil
            o.th08_actors,o.th08_actor_counts={},{}
            if card.t1<card.t3 then o.no_hp_render,o.NotPlayTimeOutSound=false,false end
            if lw then o.colli=true end
            init(o)
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
            -- 每帧推进，包括before入场期；不能等到下一次发弹/有使魔才开始数7帧。
            M.form_tick=M.form_tick+1
            M.form()
            if o.th08_combat_card==id then
                M.owner=o
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
            del(o)
            for _,a in ipairs(o.th08_actors or {}) do if alive(a) then object.RawDel(a) end end
            o.th08_actors,o.th08_combat_card=nil,nil
            o.DMG_factor=1
            if M.owner==o then M.owner=nil end
        end
    end
    return M
end
