-- 私有诊断：只在测试槽启用，用真实 Boss 击破入口验证选项、暂停保存与恢复。
local C={}
function C.install(mode)
    local D=assert(GameDrops);local originalFrame,originalRender,originalDamage=D.frame,D.render,D.damage
    local booted,lastDamage,lastMarker,probeSpawned
    local paused=mode:match('resume')~=nil
    local probeClass=Class(enemy,{
        init=function(o) enemybase.init(o,100000000,true);o.a=32;o.b=32;o.hide=true end,
        frame=function(o)
            if IsValid(player) then o.x=player.x;o.y=math.min(lstg.world.t-10,player.y+64) end
            enemybase.frame(o)
        end,
        render=function() end,
    },true)
    local function installPlan()
        local draw=assert(RogueTen).draw
        RogueTen.draw=function(seed,width)
            local plan=draw(seed,width);local entry
            for _,bucket in ipairs(RogueTen.buildPool()) do for _,card in ipairs(bucket.cards) do if card.cardId==3660 then entry=card end end end
            assert(entry,'测试卡不存在');local out={entry}
            for _,card in ipairs(plan) do if card.cardId~=entry.cardId and #out<10 then out[#out+1]=card end end
            return out
        end
    end
    D.draw=function() return {5,4} end
    D.damage=function(amount,owner)
        local value=originalDamage(amount,owner)
        if D.enabled() and D.power(owner)~=1 then
            assert(math.abs(value-amount*D.power(owner))<0.00001,'实际命中火力倍率错误')
            lastDamage={base=amount,value=value,factor=D.power(owner)}
        end
        return value
    end
    local function report()
        local s=lstg.var.upgrades
        if not s or not stage.current_stage or stage.current_stage.is_menu then return end
        local row=s.active;local phase=row and 'falling' or (s.count>0 and 'picked' or 'battle')
        local marker=phase..':'..(row and row.age or math.floor(stage.current_stage.timer/30))..':'..tostring(lastDamage~=nil)
        if marker==lastMarker then return end;lastMarker=marker
        local red,blue=D.values(1)
        local data={phase=phase,age=row and row.age,frame=stage.current_stage.timer,red=red,blue=blue,upgrades=s,
            damage=lastDamage,hero=IsValid(player) and {x=player.x,y=player.y,timer=player.timer} or nil,recovering=SaveResume.recovering}
        local f=assert(io.open(SaveProfiles.userRoot()..'/drops-check.json','w'));f:write(Serialize(data));f:close()
        if phase=='picked' or (row and row.age==12) then lstg.SystemLog('BOSSRUSH_DROPS_CHECK: '..Serialize(data)) end
    end
    D.frame=function(scene)
        if not booted and scene and scene.stage_name=='menu' and scene.timer>=120 then
            booted=true;installPlan()
            if mode:match('resume') then SaveResume.request()
            else lstg.var.player_name='reimu_player';lstg.var.rep_player='Reimu';RogueTen.start('single') end
        end
        if scene and not scene.is_menu and scene.timer>=100 and not lstg.var.__drops_check_triggered then
            for _,group in ipairs({GROUP.ENEMY,GROUP.NONTJT}) do for _,b in ObjList(group) do
                if b.IsBoss and b.is_combat and not b.cannot_kill then b.hp=0;object.Kill(b) end
            end end
            if lstg.var.upgrades and (#lstg.var.upgrades.queue>0 or lstg.var.upgrades.active) then lstg.var.__drops_check_triggered=true end
        end
        if scene and not scene.is_menu and IsValid(player) then player.protect=math.max(player.protect or 0,120) end
        local frozen=originalFrame(scene);local row=lstg.var.upgrades and lstg.var.upgrades.active
        local state=lstg.var.upgrades
        if state and state.count>0 and not row and #state.queue==0 and not probeSpawned and scene and not scene.is_menu then
            probeSpawned=true;New(probeClass)
        end
        if row and row.age>=12 and not paused and not SaveResume.recovering then paused=true;ext.pop_pause_menu=true end
        if not SaveResume.recovering then report() end
        return frozen
    end
    D.render=function() originalRender();if not SaveResume.recovering then report() end end
end
return C
