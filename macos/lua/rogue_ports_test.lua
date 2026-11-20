-- 真实 RogueTen 入口：难度交集、跨作换卡、有效 HP、射击、清理和返回标题后重开。
local T={}
function T.install()
    ext.Debugging=function() end
    AndroidFocus=function() end
    local speed=tonumber(os.getenv('BOSSRUSH_MAC_TEST_SPEED') or '8')
    local results,counts,plan,retry={},{},{},{}
    local phase,round,age,entry,measured,hits,shots,scope=0,1,0,nil,false,0,0,nil
    local combatAge=0
    local restarted=false
    local pictures={}
    local bombProbe,bombPreserved
    local function near(a,b) return math.abs(a-b)<1e-6*math.max(1,math.abs(b)) end
    local function build()
        local filters=RogueTen.defaultFilters()
        filters.difficulties.extra=true
        filters.encounters.road=true;filters.cards.survival=true
        local pool=RogueTen.buildPool(filters)
        local ids={}
        for _,bucket in ipairs(pool) do
            counts[bucket.code]={}
            for _,e in ipairs(bucket.cards) do
                assert(not ids[e.cardId],'卡号重复');ids[e.cardId]=true
                local c=counts[bucket.code];c[e.originalDifficulty]=(c[e.originalDifficulty] or 0)+1
                if e.level>=35 then
                    assert(e.originalDifficulty=='lunatic' or e.originalDifficulty=='extra' or e.originalDifficulty=='phantasm','混入其他难度')
                    local card=_sc_pr_table[e.level][e.index].sc_group[1].card
                    if e.level==40 then assert(card.port_source.phase or e.kind=='road','Like Dreamer 整场 Boss 重复入池') end
                end
            end
        end
        local legacy=RogueTen.buildPool(nil,9)
        for _,bucket in ipairs(legacy) do assert(bucket.level<35,'旧录像被加入新作') end
        local function choose(code,predicate,optional)
            for _,bucket in ipairs(pool) do if bucket.code==code then
                for _,e in ipairs(bucket.cards) do if predicate(e) then return e end end
            end end
            assert(optional,'没有候选：'..code)
        end
        for _,source in ipairs(dofile('mod/rogue_ports.lua').sources) do
            local code=source.code
            local first=choose(code,function(e) return e.originalDifficulty=='lunatic' and e.kind=='boss' and not e.survival end)
            plan[#plan+1]=first;retry[#retry+1]=first
            for _,diff in ipairs({'extra','phantasm'}) do
                local e=choose(code,function(v) return v.originalDifficulty==diff and v.kind=='boss' and v.spell and not v.survival end,code=='TH42' or diff=='phantasm' and code~='TH37' and code~='TH39')
                if e then plan[#plan+1]=e end
            end
            local spell=choose(code,function(e) return e.originalDifficulty=='lunatic' and e.kind=='boss' and e.spell and not e.survival end,true)
            if spell and spell.cardId~=first.cardId then plan[#plan+1]=spell end
            local road=choose(code,function(e) return e.originalDifficulty=='lunatic' and e.kind=='road' end)
            plan[#plan+1]=road
            plan[#plan+1]=choose('TH31',function(e) return e.kind=='boss' and not e.survival end)
        end
        -- Like Dreamer 后期资源与第十面原始状态跳转，与前期在同一场内来回加载。
        for _,stageNumber in ipairs({7,10}) do
            plan[#plan+1]=choose('TH42',function(e)
                local s=_sc_pr_table[e.level][e.index].sc_group[1].card.port_source
                return s.stage==stageNumber and s.phase==(stageNumber==10 and 16 or 1)
            end)
        end
        local only=os.getenv('BOSSRUSH_MAC_TEST_SOURCE')
        if only and only~='' then
            local function selected(list)
                local out={};for _,e in ipairs(list) do if e.source==only then out[#out+1]=e end end
                return out
            end
            plan,retry=selected(plan),selected(retry)
            assert(#plan>0,'没有指定作品：'..only)
            if #retry==1 then for _,e in ipairs(plan) do
                if e~=retry[1] then retry[#retry+1]=e;break end
            end end
        end
        RogueTen.draw=function(seed,width,f,v,whole)
            local list=round==1 and plan or retry
            local out={};for i,e in ipairs(list) do out[i]=e end
            return out
        end
        return filters
    end
    -- 保留音效资源查询，超实时流程不向音频设备连续塞入数千个音源。
    local sound=PlaySound
    PlaySound=function(name,...)
        assert(CheckRes('snd',name),'缺少音效：'..name)
        if speed==1 then return sound(name,...) end
    end
    lstg.PlaySound=PlaySound
    local function damageMethod(o)
        local c=o.class
        while c do if c.take_damage then return c.take_damage end;c=c.base end
    end
    local function measure(o)
        if not o._hp_growth_source or not o.hp or o.hp<=10 or o.hp>=999999 or o.protect then return end
        if o.current_card and (o.current_card.port_source or o.current_card.t1==o.current_card.t3) then return end
        local fn=damageMethod(o);if not fn then return end
        local hp=o.hp
        o._hp_growth_source=false;fn(o,1);local base=hp-o.hp;o.hp=hp
        o._hp_growth_source=true;fn(o,1);local scaled=hp-o.hp;o.hp=hp
        if base>0 then
            local units=o._hp_growth_source_rate or 1
            assert(near(scaled,base*units/GameHPScale.factor(o)),'真实受伤没有按伤害单位/阶段倍率折算：'..entry.key)
            measured={raw_hp=hp,factor=GameHPScale.factor(o),source_units=units,base_damage=base,scaled_damage=scaled}
        end
    end
    local function target(o)
        if entry.kind=='road' then return true end
        if entry.level==40 then
            local rt=GameContent.ports[40].source.runtime
            local source=_sc_pr_table[entry.level][entry.index].sc_group[1].card.port_source
            local root=rt and rt.boss
            if not root or root.portPhase~=source.phase or not (root._bmCombat or root._bePhaseMode==1) then return false end
            -- 七面等共享血槽由外露部件受击；本体不可受击时验证实际部件。
            local part=o
            while part do if part==root then return true end;part=part.parent end
            return false
        elseif entry.level==39 then return o._private_type_boss end
        return o.current_card and o.current_card.card_id==entry.cardId
    end
    local function step(frame)
        local scene=stage.current_stage
        AndroidInput.keys[setting.keys.shoot]=phase==1 and scene and not scene.is_menu
        if IsValid(player) then player.protect=600 end
        local quit=frame()
        scene=stage.current_stage
        if phase==0 and scene and scene.is_menu and scene.timer>=90 and GameDebug.title and not GameDebug.title.locked then
            local filters=build()
            lstg.var.player_name='reimu_player';lstg.var.rep_player='Reimu'
            assert(RogueTen.start('single',filters));phase=1
        elseif phase==1 and scene and scene.stage_name==RogueTen.BATTLE then
            local run=lstg.var.rogue_run
            if run.completed>=#(round==1 and plan or retry) then
                results[#results+1]={round=round,key=entry.key,hp=measured,shots=shots,hits=hits,frames=age}
                stage.group.ReturnToTitle(false,0);entry=nil;phase=2
                return quit
            end
            local now=run.encounter
            if now~=entry then
                if entry then
                    if scope then for o in pairs(scope.objects) do assert(not IsValid(o),'换作后原作对象残留：'..entry.key) end end
                    assert(entry.level<35 or entry.kind=='road' or measured,'没有验证真实 Boss/部件受伤：'..entry.key)
                    assert(shots>0,'宿主自机没有实际发射子弹：'..entry.key)
                    if bombProbe then
                        assert(IsValid(bombProbe),'换卡时错误删除了宿主 Bomb')
                        bombPreserved=true;object.RawDel(bombProbe);bombProbe=nil
                    end
                    results[#results+1]={round=round,key=entry.key,kind=entry.kind,hp=measured,shots=shots,hits=hits,frames=age}
                    lstg.SystemLog('ROGUE_PORTS: 完成 '..entry.key..' '..age..' 帧')
                end
                entry,age,measured,hits,shots,scope=now,0,false,0,0,RogueEncounter.scope
                combatAge=0
            end
            if entry then
                age=age+1
                if round==2 and run.current==2 and age==180 and not restarted then
                    restarted=true;stage.Restart();entry=nil;return quit
                end
                for _,o in ObjList(GROUP.PLAYER_BULLET) do shots=shots+1;break end
                if scope then
                    for o in pairs(scope.objects) do if IsValid(o) and (o.group==GROUP.ENEMY or o.group==GROUP.NONTJT) then
                        if not measured and target(o) then measure(o) end
                        if o.hp and o.rogueTestHP and o.hp<o.rogueTestHP then hits=hits+1 end
                        o.rogueTestHP=o.hp
                    end end
                end
                local ready=entry.level<35 or entry.kind=='road' or measured
                if ready then combatAge=combatAge+1 end
                if os.getenv('BOSSRUSH_MAC_TEST_SOURCE')=='TH42' and round==1 and entry.cardId==71121 and combatAge==899 then
                    bombProbe=New(Circle_Attack,player.x,player.y,1,{255,255,255},1800,0,true,player)
                end
                if scope and combatAge==450 and not pictures[entry.source] then
                    plus.CreateDirectory('snapshot')
                    Snapshot('snapshot/rogue-'..entry.source..'.png');pictures[entry.source]=true
                end
                if combatAge>=900 and ready then
                    if entry.kind=='road' then
                        for o in pairs(scope.objects) do if IsValid(o) and o.current_card and o.current_card.card_id==entry.cardId then o.hp=0 end end
                    elseif entry.level==40 then
                        local rt=GameContent.ports[40].source.runtime
                        if rt and rt.boss and IsValid(rt.boss) then rt.boss.countdown=0 end
                    elseif entry.level==39 then
                        for o in pairs(scope.objects) do if IsValid(o) and o.hp and o.hp<999999 and o.group~=GROUP.PLAYER then o.hp=0 end end
                    else
                        for _,b in ipairs(boss_group) do if IsValid(b) then b.hp=0 end end
                    end
                end
                if entry.level==40 and age%1800==0 then
                    local rt=GameContent.ports[40].source.runtime
                    local b=rt and rt.boss
                    lstg.SystemLog('ROGUE_PORTS: 目标 '..entry.key..' age='..age..' phase='..tostring(b and b.portPhase)..' state='..tostring(b and b.state))
                end
                assert(age<12000,'随机卡未结束或没有真实受伤路径：'..entry.key..' measured='..tostring(measured))
            end

        elseif phase==2 and scene and scene.is_menu and scene.timer>=90 and GameDebug.title and not GameDebug.title.locked then
            assert(not RogueEncounter.scope and not NativeTime.owner,'退出后残留作品作用域/缓时')
            if round==1 then
                round=2
                assert(RogueTen.start('single',RogueTen.savedFilters()));phase=1
            else
                local f=assert(io.open('User/mac-test.json','wb'))
                f:write(Serialize({passed=true,restarted=restarted,player_bomb_preserved=bombPreserved,counts=counts,cases=results}));f:close()
                lstg.SystemLog('BOSSRUSH_MAC_TEST: rogue-ports 通过');return true
            end
        end
        return quit
    end
    local frame=FrameFunc
    function FrameFunc()
        for i=1,speed do if step(frame) then return true end end
    end
end
return T
