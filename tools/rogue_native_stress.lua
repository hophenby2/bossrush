-- 仅由隔离原生检查入口载入：走正式随机模式，保护自机并定时结束样本卡，不改弹幕参数。
local T={}
function T.install()
    local f=assert(io.open('User/stress-config.json','rb'));local config=DeSerialize(f:read('*a'));f:close()
    local report={platform=config.platform,configuration=config,runs={},samples={},errors={},complete=false}
    local output='User/stress-result.json'
    local function save()
        local out=assert(io.open(output,'wb'));out:write(Serialize(report));out:close()
    end
    local logPath='User/stress-progress.jsonl'
    local log=assert(io.open(logPath,'wb'));log:close()
    local function event(row)
        local out=assert(io.open(logPath,'ab'));out:write(Serialize(row),'\n');out:close()
    end
    local frame,render=FrameFunc,RenderFunc
    local runIndex,phase,entry,age,ticks=0,'menu',nil,0,0
    local spec,current,done,closing
    local originalTime=os.time
    local draw,drawStages
    local keys={}
    local function key(k) return keys[k]==true end
    GetKeyState,lstg.GetKeyState=key,key
    GetLastKey,lstg.GetLastKey=function() return KEY.NULL end,function() return KEY.NULL end
    FocusLoseFunc,FocusGainFunc=function() end,function() end
    ext.Debugging=function() end
    local function endCard()
        if entry.level==40 then
            local rt=GameContent.ports[40].source.runtime
            if rt and rt.boss and IsValid(rt.boss) then rt.boss.countdown=0 end
        elseif entry.level==39 and RogueEncounter.scope then
            for o in pairs(RogueEncounter.scope.objects) do
                if IsValid(o) and o.hp and o.hp<999999 and o.group~=GROUP.PLAYER then o.hp=0 end
            end
        else
            for _,b in ipairs(boss_group) do if IsValid(b) then b.hp=0 end end
        end
    end
    local function sample(scene,run)
        local row={run=runIndex,card=entry and entry.cardId,age=age,frame=ticks,completed=run.completed,
            preparing=run.preparing or false,groups={},objects=0,lua_kb=collectgarbage('count')}
        for group=0,15 do local n=0;for _ in ObjList(group) do n=n+1 end;row.groups[tostring(group)]=n;row.objects=row.objects+n end
        local b=_boss and IsValid(_boss) and _boss
        row.hp=b and b.hp;row.boss_timer=b and b.timer;row.player_timer=IsValid(player) and player.timer
        row.patterns={}
        for c in pairs(TH39 and TH39.runtime.controllers or {}) do
            local types={};for o,s in pairs(c.bullets) do if IsValid(o) then types[tostring(s.type)]=(types[tostring(s.type)] or 0)+1 end end
            row.patterns[#row.patterns+1]={id=c.pattern.id,time=c.time,types=types}
        end
        report.samples[#report.samples+1]=row
        event(row)
    end
    local function begin()
        runIndex=runIndex+1;spec=config.runs[runIndex]
        if not spec then report.complete=true;save();done=true;return end
        if config.bent_contract and not report.bent_contract then
            report.bent_contract=dofile('native-bent-contract.lua').run();save()
        end
        draw,drawStages=draw or RogueTen.draw,drawStages or RogueTen.drawStages
        local seed=spec.seed
        os.time=function(value) return value and originalTime(value) or seed end
        local filters=RogueTen.defaultFilters(spec.mode)
        for _,s in ipairs(RogueTen.sources) do filters.stages[s.code]=true end
        filters.cards.survival=true;filters.difficulties.extra=spec.extra==true
        filters.rules.enhanced=spec.enhanced~=false
        RogueTen.draw,RogueTen.drawStages=draw,drawStages
        if spec.cards then
            local byId={};for _,bucket in ipairs(RogueTen.buildPool(filters)) do for _,e in ipairs(bucket.cards) do byId[e.cardId]=e end end
            RogueTen.draw=function()
                local plan={};for _,id in ipairs(spec.cards) do plan[#plan+1]=assert(byId[id],'指定卡不在正式卡池：'..id) end;return plan
            end
        end
        current={mode=spec.mode,seed=spec.seed,cards={},completed=0};report.runs[#report.runs+1]=current
        lstg.var.player_name=spec.player or 'reimu_player';lstg.var.rep_player='Reimu'
        assert(RogueTen.start(spec.mode,filters));phase='battle';entry=nil;age=0;closing=false
        event({event='start',run=runIndex,mode=spec.mode,seed=spec.seed});save()
    end
    local function step()
        ticks=ticks+1
        if AndroidFocus then AndroidFocus=function() end end
        if AndroidInput then AndroidInput.keys={};AndroidInput.toggles={} end
        keys={}
        if IsValid(player) then
            player.protect=600
            if phase=='battle' and age%360<240 and not closing then keys[setting.keys.shoot]=true end
            if age%480<240 then keys[setting.keys.slow]=true end
        end
        local run=lstg.var.rogue_run
        if phase=='battle' and run then
            if entry and not closing then
                for _,group in ipairs({GROUP.ENEMY,GROUP.NONTJT}) do for _,o in ObjList(group) do
                    if o.maxhp and o.hp and o.hp>0 and o.maxhp<999999 then o.hp=o.maxhp end
                end end
            end
            if entry and not run.preparing and spec.bombs then
                for _,at in ipairs(spec.bombs) do if age==at then
                    local before=GameDrops.bombState(GameDrops.slot(player))
                    local fired=GameDrops.bombInput(player,{spell=true},{spell=false})
                    current.bombs=current.bombs or {}
                    current.bombs[#current.bombs+1]={card=entry.cardId,age=age,fired=fired,before=before,
                        after=GameDrops.bombState(GameDrops.slot(player))}
                end end
            end
            if run.endless_choice then run.endless_choice.answer=2 end
            if entry and age>=(spec.frames or 600) then closing=true;endCard() end
            if run.completed>=(spec.limit or (spec.mode=='staged' and 38 or 24)) then
                current.completed=run.completed;phase='return';stage.group.ReturnToTitle(false,0)
                event({event='round_complete',run=runIndex,completed=run.completed});save()
            end
        end
        local quit=frame()
        local scene=stage.current_stage;run=lstg.var.rogue_run
        if phase=='battle' and scene and not scene.is_menu and run and run.completed<(spec.limit or 24) then
            if not run.preparing and (run.current or 0)>0 and run.encounter~=entry then
                if entry then save() end
                entry,age,closing=run.encounter,0,false
                if entry then
                    current.cards[#current.cards+1]={id=entry.cardId,source=entry.source,index=run.current}
                    event({event='card',run=runIndex,id=entry.cardId,source=entry.source,index=run.current})
                end
            end
            if entry and not run.preparing then age=age+1 end
            if entry and age>0 and age%60==0 then sample(scene,run) end
            if run.finished and not closing and run.completed<(spec.limit or 24) then error('样本路线提前结束：'..tostring(run.completed)) end
        elseif scene and scene.stage_name=='menu' and scene.timer>=90 and (phase=='menu' or phase=='return') then begin() end
        return quit
    end
    local function fail(err)
        report.errors[#report.errors+1]={run=runIndex,card=entry and entry.cardId,age=age,trace=err}
        event({event='error',trace=err});save();done=true
    end
    FrameFunc=function()
        if done then return true end
        local ok,result=xpcall(function()
            for _=1,(spec and spec.speed or config.speed or 1) do if step() or done then return true end end
            return false
        end,debug.traceback)
        if not ok then fail(result);return true end
        return result
    end
    RenderFunc=function()
        if done then return end
        local ok,err=xpcall(function()
            render()
            if spec and spec.capture and entry and entry.cardId==39011 then
                current.captures=current.captures or {}
                for c in pairs(TH39.runtime.controllers) do
                    if c.pattern.id=='243' and c.time==185 and not current.captures[tostring(age)] then
                        if not plus.DirectoryExists('snapshot') then plus.CreateDirectory('snapshot') end
                        local path='snapshot/stress-emperor-'..runIndex..'-'..age..'.png'
                        Snapshot(path);current.captures[tostring(age)]=path;save()
                    end
                end
            end
        end,debug.traceback);if not ok then fail(err) end
    end
end
return T
