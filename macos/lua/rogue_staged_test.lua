-- 隔离存档检查模式2的实际内容元数据、准备界面、资源入场及选项恢复。
local T={}
function T.install()
    local create=New
    local selector
    function New(cls,...)
        local o=create(cls,...)
        if cls==player_system_select then selector=o end
        return o
    end
    ext.Debugging=function() end
    AndroidFocus=function() end
    local original=FrameFunc
    local phase,age=0,0
    local counts,workCounts,plan,selected={},{},{},{}
    local function choose(title)
        for i,label in ipairs(title.text) do if label=='roguelike模式2' then title.func[i]();return end end
        error('主菜单没有模式2入口')
    end
    local function audit(cards)
        assert(#cards==38,'没有抽满38张')
        local pos,seen=0,{}
        for number,count in ipairs({4,5,6,7,7,9}) do for _=1,count do
            pos=pos+1;local e=cards[pos]
            assert(e.stage==number and e.originalDifficulty=='lunatic' and e.kind=='boss','面数/难度/类型越界')
            assert(e.source~='TH42' and not seen[e.cardId],'混入Like Dreamer或重复卡');seen[e.cardId]=true
        end end
    end
    local function nextPhase(n) phase=n;age=0 end
    function FrameFunc()
        for _=1,4 do
            AndroidInput.keys={};AndroidInput.toggles={}
            if IsValid(player) then player.protect=60000 end
            local quit=original();age=age+1
            local scene=stage.current_stage
            local title=GameDebug.title
            local atTitle=scene and scene.stage_name=='menu' and scene.timer>=90 and title and not title.locked
            if phase==0 and atTitle then
                local filters=RogueTen.defaultFilters('staged')
                local stages;stages,counts=RogueTen.buildStagePool(filters)
                for number,buckets in ipairs(stages) do for _,bucket in ipairs(buckets) do
                    workCounts[bucket.code]=workCounts[bucket.code] or {0,0,0,0,0,0}
                    workCounts[bucket.code][number]=#bucket.cards
                end end
                for code,enabled in pairs(filters.stages) do if enabled then
                    assert(workCounts[code],'作品没有分面卡池：'..code)
                    for number=1,6 do assert(workCounts[code][number]>0,'作品缺少面数：'..code..'/'..number) end
                end end
                for seed=1,12 do audit(RogueTen.drawStages(seed,filters)) end
                choose(title);nextPhase(1)
            elseif phase==1 and selector and IsValid(selector) and not selector.locked and selector.alpha>=1 then
                assert(selector.simple_mode and selector.pool_variant=='staged','模式2未进入独立准备页')
                local uiPool=dofile('THlib/UI/rogue_pool.lua')
                uiPool.expand(selector)
                local only=RogueTen.copyFilters(selector.pool_options,'staged');only.stages={TH43=true}
                local solo=RogueTen.poolStatus(only,nil,'staged').valid
                for i,e in ipairs(uiPool.stagedOptions) do
                    assert(e.group=='stages' and e.key~='TH42','高级选项混入固定规则或Like Dreamer')
                    local wanted=solo and e.key=='TH43' or not solo and tonumber(e.key:sub(3))>=37
                    if selector.pool_options.stages[e.key]~=wanted then uiPool.toggle(selector,i) end
                    selected[e.key]=wanted
                end
                assert(uiPool.ready(selector),'新作范围不足以开始模式2')
                nextPhase(2)
            elseif phase==2 and age>=12 then
                plus.CreateDirectory('snapshot');Snapshot('snapshot/rogue2-options.png')
                selector:yes();nextPhase(3)
            elseif phase==3 and scene and scene.stage_name=='RogueTwo@RogueTwo' then
                local run=assert(lstg.var.rogue_run)
                assert(not run.endless and run.total==38 and GameHPScale.enabled(),'有限战数或HP处理未接入')
                audit(run.cards)
                if run.current>0 and not run.preparing and scene.timer>=600 then
                    assert(RogueBossHUD.enabled(),'模式2未启用原生Boss血条/指示器')
                    assert(RogueEncounter.background and IsValid(RogueEncounter.background.root),'没有首个关卡背景')
                    for _,e in ipairs(run.cards) do assert(selected[e.source],'作品范围失效');plan[#plan+1]={id=e.cardId,stage=e.stage,source=e.source} end
                    Snapshot('snapshot/rogue2-battle.png')
                    nextPhase(6)
                end
            elseif phase==6 and age>=24 then
                -- Snapshot 的 GPU 回读完成前保持当前场景及其资源存活。
                stage.group.ReturnToTitle(false,0);nextPhase(4)
            elseif phase==4 and atTitle then choose(title);nextPhase(5)
            elseif phase==5 and selector and not selector.locked and selector.alpha>=1 then
                for code,wanted in pairs(selected) do assert(selector.pool_options.stages[code]==wanted,'作品范围没有记忆') end
                local report={mode='rogue-staged',passed=true,counts=counts,works=workCounts,cards=plan}
                local f=assert(io.open('User/mac-test.json','wb'));f:write(Serialize(report));f:close()
                lstg.SystemLog('ROGUE_STAGED: 分面卡池、实际菜单、新作资源与作品记忆通过')
                return true
            end
            assert(age<18000,'模式2检查超时，阶段 '..phase)
            if quit then return true end
        end
        return false
    end
end
return T
