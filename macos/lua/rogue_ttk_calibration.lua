-- 显式测试入口：满火力低速、无Bomb、全命中输出采样。只写隔离测试目录。
local T={}
function T.install()
    ext.Debugging=function() end
    AndroidFocus=function() end
    GetLastKey,lstg.GetLastKey=function()return KEY.NULL end,function()return KEY.NULL end
    GetMouseState,lstg.GetMouseState=function()return false end,function()return false end
    PlaySound,lstg.PlaySound=function() end,function() end
    -- 标定场景没有资源任务；不让展示帧读条冻结逻辑时钟。
    ui.ResourceLoading.state=nil
    ui.ResourceLoading.beforeFrame=function() return false end
    ui.ResourceLoading.afterFrame=function() end
    ext.boss_ui.frame=function() end
    ext.boss_ui.render=function() end
    local collision=CollisionCheck
    CollisionCheck=function(a,b,...)
        if b==GROUP.PLAYER_BULLET and (a==GROUP.NONTJT or a==GROUP.ENEMY) then return end
        return collision(a,b,...)
    end
    local input=GetInput
    GetInput=function()
        if stage.current_stage and stage.current_stage.stage_name=='TTKCalibration' then
            local shoot,slow=true,true
            local p=player
            if p and IsValid(p) and p.unity_source then
                for _,unit in ipairs(p.unity_source.units) do for _,node in ipairs(unit.nodes) do
                    for _,component in ipairs(node.components) do
                        if component.__type=='Jitifashezidan_xuli' and component.time_xuli>=163 then slow=false end
                    end
                end end
            elseif p and IsValid(p) and p.native_level==35 and p.machine.id=='youmu' then
                local e=p.mhj_source.equipment
                shoot=not (e.time2>=90 and not e.releaseReady)
            end
            LoadSaveInputState({shoot=shoot,slow=slow})
        else return input() end
    end
    local render=RenderFunc
    RenderFunc=function()
        if stage.current_stage and stage.current_stage.stage_name=='TTKCalibration' then return end
        return render()
    end
    local plan,results={},{}
    local selected=tonumber(os.getenv('BOSSRUSH_TTK_LEVEL') or '')
    for level=35,41 do if not selected or level==selected then
        for _,machine in ipairs(NativePlayers.machines(level)) do
            plan[#plan+1]={level=level,machine=machine.id}
        end
    end end
    if not selected or selected==37 then
        for _,machine in ipairs(NativePlayers.machines(37)) do
            plan[#plan+1]={level=37,machine=machine.id,enemy=true}
        end
    end
    local machine=os.getenv('BOSSRUSH_TTK_MACHINE')
    local enemy=os.getenv('BOSSRUSH_TTK_ENEMY')
    if machine or enemy then
        local out={}
        for _,case in ipairs(plan) do
            if (not machine or case.machine==machine) and (not enemy or (case.enemy==true)==(enemy=='1')) then out[#out+1]=case end
        end
        plan=out
    end
    assert(#plan>0)
    local index,started,age,damage=1,false,0,0
    local windows,events={},{}
    local target
    local WARMUP,WINDOW=tonumber(os.getenv('BOSSRUSH_TTK_WARMUP') or '600'),3600
    local targetBase=Class(object)
    function targetBase:take_damage(value)
        if value>0 then damage=damage+value;events.hits=(events.hits or 0)+1 end
    end
    local Target=Class(targetBase)
    function Target:init()
        self.x,self.y=0,0
        self.a,self.b=10000,10000
        self.group,self.bound,self.colli=GROUP.NONTJT,false,true
        self.hp,self.maxhp=1e12,1e12
        self.IsBoss,self.is_combat=not plan[index].enemy,not plan[index].enemy
        self.theis_port_object=true
        self.native_actor_collision={damage={10000,10000}}
        self._bosssys={getCurrentCard=function()return {type='card',mode='spell'}end}
        self.dmg_factor=1
        self.active,self.targetable=true,true
    end
    function Target:colli(shot)
        if shot.class.hit then shot.class.hit(shot,self)
        elseif shot.dmg then
            targetBase.take_damage(self,shot.dmg)
            if not shot.killflag then object.Kill(shot) end
        end
    end
    local scene=stage.New('TTKCalibration')
    scene.render=function() end
    scene.frame=function() end
    function scene:init()
        local case=assert(plan[index])
        lstg.var.__hp_scale_version,lstg.var.rogue_run=nil,nil
        lstg.var.is_practice,lstg.var.cheat=true,true
        NativePlayers.configure(case.level,case.machine)
        item._init_item(self)
        target=New(Target);boss_group={target};_boss=target
        NativePlayers.spawn()
        player.protect=999999
        player.dialog,player.death,player.lock=false,0,false
        player.x,player.y=0,-176
        NativePlayers.state().power=400
        if case.level==36 then
            local s=player.unity_source.Sincos
            s.suipian_beilv_hong,s.suipian_beilv_zi,s.hyper_time=3,3,0
            for name,class in pairs(player.unity_source.model) do
                if name:match('^Damage') and class.FixedUpdate and not class._ttk_wrapped then
                    local original=class.FixedUpdate;class._ttk_wrapped=true
                    class.FixedUpdate=function(o,...)
                        local before=damage
                        local s=player.unity_source.Sincos
                        local ring=name=='Damage5' and s.boss[0]
                        local old=ring and ring.transform.position
                        if ring then
                            -- 环形判定必须位于内外圈之间，扩大靶半径不能代表全命中。
                            local point=o.transform.position+o.transform.position*0
                            point.x=point.x+ring.sdbj+(o.damage_r_nei+o.damage_r_wai)/2
                            ring.transform.position=point
                        end
                        local result=original(o,...)
                        if ring then ring.transform.position=old end
                        events[name]=(events[name] or 0)+damage-before
                        return result
                    end
                end
            end
        elseif case.level==41 then
            local power=TH43.runtime.env.system.PowerRank
            power.setRankWithEvent(3);power.setChip(0);power.setValue(0)
            power.addValue=function() end
        elseif case.level==40 then
            local rt=GameContent.ports[40].source.runtime
            rt.frame,rt.stage,rt.stageNumber=1,1,1
            rt.damageEnemy=function(other,amount,shot)
                targetBase.take_damage(other,amount)
                events['type_'..tostring(shot and (shot.shotType or shot.specialType))]=(events['type_'..tostring(shot and (shot.shotType or shot.specialType))] or 0)+amount
            end
            rt.findTarget=function()return target end
            target.ldX,target.ldY,target.radius=360,200,10000
        end
        if case.level==35 or case.level==37 then
            -- 全命中模型只替代空间测试；仍执行原生命中回调、爆炸寿命和永夜逐帧上限。
            local seen={}
            local function patch(value)
                if (type(value)~='table' and type(value)~='function') or seen[value] then return end
                seen[value]=true
                if type(value)=='table' then for _,v in pairs(value) do patch(v) end
                else
                    for n=1,100 do
                        local name,v=debug.getupvalue(value,n);if not name then break end
                        if name=='inside' then debug.setupvalue(value,n,function(o)return IsValid(o) and o.colli end)
                        elseif name=='rayHit' then debug.setupvalue(value,n,function(o,_,_,amount)
                            if not IsValid(o) or not o.colli then return false end
                            if type(amount)=='number' then Damage(o,amount) end
                            return true
                        end)
                        elseif name~='_G' and name~='P' and name~='R' then patch(v) end
                    end
                end
            end
            patch(NativePlayers.adapters[case.level])
            local R=case.level==35 and TH37.runtime or TH39.runtime
            if not R.ttk_all_hit then
                R.ttk_all_hit=true
                local hit=R.playerWeaponHit
                R.playerWeaponHit=function(b,s)
                    local profile=case.level==37 and R.weaponProfile(s)
                        or (s.type<=228 and R.data.bulletTypes[s.type] or s.pattern.types[s.type-228])
                    if not profile then return hit(b,s) end
                    local x=s.fx+math.floor(profile[3]/2)-profile[5]+(s.controller.positionx or 0)
                    local y=s.fy+math.floor(profile[4]/2)-profile[6]+(s.controller.positiony or 0)
                    local oldX,oldY=target.x,target.y
                    if case.level==35 then target.x,target.y=x-317,227-y
                    else target.x,target.y=(x-481)*2/3,(360-y)*2/3 end
                    local result=hit(b,s)
                    target.x,target.y=oldX,oldY
                    return result
                end
            end
        end
        age,damage,windows,events=0,0,{},{}
        lstg.SystemLog('TTK_BEGIN '..case.level..' '..case.machine)
    end
    local function step(frame)
        local current=stage.current_stage
        if not started and current and current.is_menu and current.timer>=90 and GameDebug.title and not GameDebug.title.locked then
            started=true;stage.Set('none','TTKCalibration')
        end
        local p=player
        if current==scene and p and IsValid(p) then
            AndroidInput.keys[setting.keys.shoot]=true
            AndroidInput.keys[setting.keys.slow]=true
            p.protect=999999;p.dialog=false
            if p.native_level==40 then
                local rt=GameContent.ports[40].source.runtime;rt.frame=(rt.frame or 0)+1
            end
        end
        local quit=frame()
        if current==scene and stage.current_stage==scene then
            age=age+1
            -- 碰撞只替代飞行与瞄准，不替代原作发射/命中后的寿命和多段伤害时钟。
            for _,shot in ObjList(GROUP.PLAYER_BULLET) do
                if IsValid(shot) then Target.colli(target,shot) end
            end
            if plan[index].level==38 then
                for _,shot in ObjList(GROUP.GHOST) do
                    if shot.source==player and shot.offsetX and shot.damage and shot.damage>0 then
                        targetBase.take_damage(target,shot.damage);shot.damage=0
                    end
                end
            end
            if age==WARMUP then
                assert(scene.timer>=WARMUP,'采样不能把加载/展示回调当作逻辑帧')
                assert(player.slow==1 or player.focused or plan[index].level==36,'必须是原作低速输出')
                damage=0;events={}
            end
            if age>WARMUP and (age-WARMUP)%WINDOW==0 then
                windows[#windows+1]=damage/(WINDOW/60)
                if player.mhj_source then
                    local c=player.mhj_source.character
                    lstg.SystemLog('TTK_DEBUG '..Serialize({age=age,damage=damage,power=NativePlayers.state().power,
                        shoot=player._playersys.keyState.shoot,state=c.state,position={player.x,player.y},
                        dis=c.Dis,ban=c.BanShoot,banEShoot=c.BanBEShoot,equipment=player.mhj_source.equipment.time}))
                end
                damage=0
                if #windows==2 then
                    results[#results+1]={level=plan[index].level,machine=plan[index].machine,enemy=plan[index].enemy,warmup=WARMUP,windows=windows,events=events}
                    lstg.SystemLog('TTK_RESULT '..Serialize(results[#results]))
                    index=index+1
                    if index>#plan then
                        local f=assert(io.open('User/ttk-calibration.json','wb'))
                        f:write(Serialize({warmup=WARMUP,window=WINDOW,cases=results}));f:close()
                        return true
                    end
                    stage.Set('none','TTKCalibration')
                end
            end
        end
        return quit
    end
    local frame=FrameFunc
    function FrameFunc()
        AndroidFocus=function() end
        for i=1,30 do if step(frame) then return true end end
    end
end
return T
