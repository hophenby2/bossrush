-- 正式登记数据与模式2抽卡；不访问玩家存档、不运行无关弹幕。
local f=assert(io.open('tools/check_roguelike.lua','rb'))
local setup=f:read('*a');f:close()
local stop=assert(setup:find('local bossFilters=R.defaultFilters',1,true))
local checks=[=[
local filters=R.defaultFilters('staged')
check(filters.cards.survival==false,'挑战模式默认不勾选时符')
local timeFilters=R.copyFilters(filters,'staged');timeFilters.cards.survival=true
check(R.copyFilters(timeFilters,'staged').cards.survival,'挑战模式保留时符勾选')
for _,bucket in ipairs(R.buildPool(filters)) do for _,card in ipairs(bucket.cards) do check(not card.survival,'默认池排除时符')end end
local timeCount=0
for _,bucket in ipairs(R.buildPool(timeFilters))do for _,card in ipairs(bucket.cards)do if card.survival then timeCount=timeCount+1 end end end
check(timeCount>0,'勾选时符后有真实耐久卡')
scoredata.rogue2_filters=timeFilters;scoredata.rogue2_survival_configured=nil
check(not R.savedFilters('staged').cards.survival,'过去强制保存的true不能当成主动勾选')
scoredata.rogue2_survival_configured=true
check(R.savedFilters('staged').cards.survival,'主动勾选后恢复上次时符选项')
local menuOptions=dofile('THlib/UI/rogue_pool.lua');local timeIndex
for i,o in ipairs(menuOptions.stagedOptions)do if o.group=='cards' and o.key=='survival' then timeIndex=i end end
check(timeIndex~=nil,'挑战高级选项有时符复选框')
local view={pool_variant='staged',pool_options=R.copyFilters(filters,'staged')}
menuOptions.toggle(view,timeIndex);check(view.pool_options.cards.survival,'菜单勾选时符')
menuOptions.toggle(view,timeIndex);check(not view.pool_options.cards.survival,'菜单取消时符')
for _,bucket in ipairs(dofile('mod/rogue_pool.lua').buildEndless(filters,true))do
    for _,card in ipairs(bucket.cards)do check(not card.survival,'无尽延伸也遵守时符开关')end
end
local function ids(cards)
    local out={};for _,card in ipairs(cards) do out[#out+1]=card.key end
    return table.concat(out,',')
end
local function route(cards)
    check(#cards==38,'保留38张路线')
    local pos=0
    for number,count in ipairs({4,5,6,7,7,9}) do for index=1,count do
        pos=pos+1;local card=cards[pos]
        check(card.stage==number,'完整卡池优先同面')
        check(card.spell==(index%2==0 or index==count),'非符起交替、末尾符卡')
    end end
end
for seed=1,20 do
    route(R.drawStages(seed,filters))
    check(ids(R.drawStages(seed,filters))==ids(R.drawStages(seed,filters)),'同种子可复现')
end
local selected=R.copyFilters(filters,'staged');selected.stages={TH31=true}
local original=_sc_pr_table[29]
local single
for _,unit in ipairs(original) do if unit.sc_group[1].card.card_id==470 then single=unit end end
assert(single)
_sc_pr_table[29]={single}
check(R.poolStatus(selected,nil,'staged').valid,'仅一张卡仍可开始')
for seed=1,20 do
    local cards=R.drawStages(seed,selected)
    check(#cards==38,'同面/类型不足循环、缺面补齐38张')
    for _,card in ipairs(cards) do check(card.cardId==470 and card.source=='TH31','补抽不越过作品范围') end
end
single.sc_group[1].card.random_empty=true
check(not R.poolStatus(selected,nil,'staged').valid,'空攻击不进入随机池')
single.sc_group[1].card.random_empty=nil
_sc_pr_table[29]={}
local state=R.poolStatus(selected,nil,'staged')
check(not state.valid and state.message=='选择的卡池为空','只有总池为空拒绝')
check(not pcall(R.drawStages,1,selected),'空池不生成无效路线')
_sc_pr_table[29]=original
print('模式2小卡池检查通过：'..total..'项')
]=]
assert(loadstring(setup:sub(1,stop-1)..checks))()
