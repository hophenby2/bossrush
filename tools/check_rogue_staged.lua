-- 复用原作注册和真实关卡协程桩；不读写玩家存档，不运行弹幕。
local f=assert(io.open('tools/check_roguelike.lua','rb'))
local setup=f:read('*a');f:close()
local stop=assert(setup:find('local bossFilters=R.defaultFilters',1,true))
local checks=[=[
local filters=R.defaultFilters('staged')
check(R.modes.staged.count==38 and stage.groups.RogueTwo,'模式2注册独立38战入口')
check(not filters.stages.TH42 and filters.difficulties.lunatic and not filters.difficulties.extra,'固定Lunatic且排除Like Dreamer')
local function keys(cards) local t={};for _,e in ipairs(cards) do t[#t+1]=e.key end;return table.concat(t,',') end
local function route(cards,only)
    check(#cards==38,'路线恰好38张')
    local pos,seen=0,{}
    for number,count in ipairs({4,5,6,7,7,9}) do for _=1,count do
        pos=pos+1;local e=cards[pos]
        check(e.stage==number,'每张卡属于当前面')
        check(e.originalDifficulty=='lunatic' and e.kind=='boss' and e.source~='TH42','只抽Lunatic符卡/非符')
        check(not seen[e.key],'同局不重复');seen[e.key]=true
        if only then check(e.source==only,'只抽所选作品') end
    end end
end
for seed=1,40 do
    local cards=R.drawStages(seed,filters);route(cards)
    check(keys(cards)==keys(R.drawStages(seed,filters)),'相同种子重建38战')
end
check(keys(R.drawStages(17,filters))~=keys(R.drawStages(1234,filters)),'种子改变路线')
local only=R.copyFilters(filters,'staged');only.stages={TH31=true}
route(R.drawStages(37,only), 'TH31')
only.difficulties={extra=true};only.encounters={road=true};only.cards={nonspell=false,spell=false,survival=false}
route(R.drawStages(37,only), 'TH31')
local excluded=R.copyFilters(filters,'staged');excluded.stages={TH42=true}
local state=R.poolStatus(excluded,nil,'staged')
check(not state.valid and not pcall(R.drawStages,37,excluded),'Like Dreamer无法绕过筛选进入')
local source=_sc_pr_table[29];local firstOnly={}
for _,u in ipairs(source) do if u.sc_group[1].card.card_id==470 then firstOnly[#firstOnly+1]=u end end
_sc_pr_table[29]=firstOnly
state=R.poolStatus(only,nil,'staged')
check(not state.valid and state.message:find('第1面',1,true),'某面不足时明确拒绝，不重复或跨面补抽')
_sc_pr_table[29]=source
local menuUI=dofile('THlib/UI/rogue_pool.lua')
ext.mouse={isPress=function() return false end}
local previous=R.savedFilters()
local o={};menuUI.fresh(o,'roguelike2')
check(o.pool_variant=='staged' and o.pool_status.valid,'准备页使用独立模式2校验')
for _,e in ipairs(menuUI.stagedOptions) do check(e.group=='stages' and e.key~='TH42','高级选项只包含允许作品') end
menuUI.toggle(o,1)
check(not R.savedFilters('staged').stages.TH31 and R.savedFilters().stages.TH31==previous.stages.TH31,'模式2筛选独立记忆')
menuUI.fresh(o,'roguelike2');check(not o.pool_options.stages.TH31,'再次进入恢复作品勾选')
lstg.var={ran_seed=818,player_name='reimu_player'};lstg.tmpvar={};spawned={}
check(R.start('staged',filters),'模式2可以开始')
local battle=stage.next_stage;stage.next_stage=nil;stage.current_stage=battle;battle.timer=0;battle.task=nil;battle:init()
ui={}
check(G.enabled() and not lstg.var.rogue_run.endless,'模式2启用同一HP处理并固定结束')
for _=1,3000 do
    if not RogueEncounter.preloadFrame() then
        task.Do(battle);battle:frame();battle.timer=battle.timer+1
    end
    for _,entry in ipairs(spawned) do if entry.obj._live then
        entry.obj.life=entry.obj.life-1;if entry.obj.life<=0 then entry.obj._live=false end
    end end
    if stage.next_stage then break end
end
local run=lstg.var.rogue_run
route(run.cards)
local actors=0
for _,e in ipairs(run.cards) do actors=actors+#_sc_pr_table[e.level][e.index].sc_group end
check(#spawned==actors and run.completed==38 and run.current==38 and run.total==38,
    string.format('真实运行协程完成38战：对象%d/%d 完成%d 当前%d 总数%d',#spawned,actors,run.completed,run.current,run.total))
check(stage.next_stage==stage.stages.RogueTwoResult and run.won and run.finished,'第38张后成功结算')
stage.current_stage=stage.next_stage;stage.next_stage=nil;stage.current_stage:init()
check(scoredata.rogue2.played==1 and scoredata.rogue2.cleared==1 and not scoredata.rogue10,'结算记录与原模式分离')
check(#R.draw(123,1,R.defaultFilters())==10,'指定抽取数量的接口保持十张')
print('模式2检查通过：'..total..'项')
]=]
assert(loadstring(setup:sub(1,stop-1)..checks))()
