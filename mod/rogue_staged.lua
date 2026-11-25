-- 模式2的分面抽卡、通关选择与无尽路线；可变状态放在run中，随本局和录像推进。
local pool=...
local M={}
function M.position(current)
    local index=math.max(1,math.floor(current or 1))
    for number,count in ipairs(pool.STAGE_COUNTS) do
        if index<=count then return number,index,count end
        index=index-count
    end
end
function M.label(run)
    if run.overtime then
        return (run.overtime=='extend' and '∞+#' or '∞#')..math.max(1,run.overtime_index or 1)
    end
    local number,index=M.position(run.current or run.completed)
    return number..'#'..index
end
function M.draw(seed,filters)
    local status,stages=pool.stageStatus(filters)
    assert(status.valid,status.message)
    local gen=Rand();gen:Seed(seed)
    local cards,all,remaining={},{},{}
    for _,buckets in ipairs(stages) do for _,bucket in ipairs(buckets) do
        for _,entry in ipairs(bucket.cards) do all[#all+1]=entry;remaining[entry.key]=true end
    end end
    local function choose(candidates)
        local available={}
        for _,entry in ipairs(candidates) do
            if remaining[entry.key] then available[#available+1]=entry end
        end
        if #available==0 then
            -- 只重置本次所需的候选，单一作品/类型也能完成固定38战。
            for _,entry in ipairs(candidates) do remaining[entry.key]=true;available[#available+1]=entry end
        end
        local previous=cards[#cards]
        if #available>1 and previous then
            for i=#available,1,-1 do if available[i].key==previous.key then table.remove(available,i) end end
        end
        local works,order={},{}
        for _,entry in ipairs(available) do
            if not works[entry.source] then works[entry.source]={};order[#order+1]=entry.source end
            local list=works[entry.source];list[#list+1]=entry
        end
        local list=works[order[gen:Int(1,#order)]]
        local entry=list[gen:Int(1,#list)]
        remaining[entry.key]=nil
        return entry
    end
    for number,count in ipairs(pool.STAGE_COUNTS) do
        for index=1,count do
            local spell=pool.spellAt(number,index)
            local same,other,localAny={},{},{}
            for _,entry in ipairs(all) do
                if entry.stage==number then
                    localAny[#localAny+1]=entry
                    if entry.spell==spell then same[#same+1]=entry end
                elseif entry.spell==spell then other[#other+1]=entry end
            end
            local candidates=#same>0 and same or #other>0 and other or #localAny>0 and localAny or all
            cards[#cards+1]=choose(candidates)
        end
    end
    return cards
end
local choicePalette={green={80,235,130,bullet=10},red={255,90,100,bullet=2},blue={110,190,255,bullet=6}}
function M.beginChoice(run)
    GameDrops.clearPending()
    local choices={{{color='green',text='是',scale=1}},{{color='red',text='否',scale=1}}}
    if run.extend_unlocked then choices[3]={{color='blue',text='extend?',scale=.9}} end
    run.endless_choice={age=0,duration=GameQuiz.TIME,linear=true,colorMask=true,
        palette=choicePalette,choices=choices}
end
function M.choiceFrame(run)
    local q=run.endless_choice
    if not q or q.answer then return end
    local p=player
    if not p or not IsValid(p) then return end
    p.protect=math.max(p.protect or 0,120)
    if p.lock or p.dialog or p.hide or p.realrealreal_lock or (p.death or 0)~=0 then return end
    local previous=q.previous or {x=p.x,y=p.y}
    local oldAge=q.age;q.age=q.age+1
    GameQuiz.selection('rogue-clear',q,'您已通关，是否进入无尽模式',q.choices)
    q.answer=GameQuiz.contact(previous,p,oldAge,q.age,#q.choices,q.duration,q.linear)
    q.previous={x=p.x,y=p.y}
end
function M.clearChoice(run)
    GameQuiz.clearSelection('rogue-clear')
    if run then run.endless_choice=nil end
end
function M.beginEndless(run,extended)
    M.clearChoice(run)
    run.overtime=extended and 'extend' or 'six'
    run.overtime_index,run.overtime_cycle,run.overtime_card_index=0,0,0
end
function M.nextEndless(run)
    local deck=run.overtime_cards
    if not deck or run.overtime_card_index>=#deck then
        local previous=deck and deck[#deck] or run.cards[#run.cards]
        local buckets,total=pool.buildEndless(run.filters,run.overtime=='extend')
        assert(total>0,'无尽模式符卡池为空')
        run.overtime_cycle=run.overtime_cycle+1
        local gen=Rand();gen:Seed((run.seed+run.overtime_cycle*130363)%2147483647)
        deck={}
        while #buckets>0 do
            local index=gen:Int(1,#buckets)
            local bucket=buckets[index]
            deck[#deck+1]=table.remove(bucket.cards,gen:Int(1,#bucket.cards))
            if #bucket.cards==0 then table.remove(buckets,index) end
        end
        if #deck>1 and previous and deck[1].cardId==previous.cardId then deck[1],deck[2]=deck[2],deck[1] end
        run.overtime_cards,run.overtime_card_index=deck,0
    end
    run.overtime_card_index=run.overtime_card_index+1
    run.overtime_index=run.overtime_index+1
    return deck[run.overtime_card_index]
end
local titles=dofile('mod/rogue_titles.lua')
local DURATION=titles.STAGE_DURATION
function M.announce(run)
    if run.mode~='staged' or run.overtime then return end
    local number,index,count=M.position(run.current)
    local text=index==1 and ('Stage '..number) or index==count and 'Final Spell !'
    if not text then return end
    local event={text=text,stage=number,age=0}
    run.banner_queue=run.banner_queue or {}
    if run.stage_banner then run.banner_queue[#run.banner_queue+1]=event else run.stage_banner=event end
end
function M.frame(run)
    local a=run.stage_banner
    if not a then return end
    a.age=a.age+1
    if a.age>=DURATION then run.stage_banner=table.remove(run.banner_queue,1) end
end
function M.alpha(run)
    return 255
end
function M.render(run)
    local a=run.stage_banner
    if not a then return end
    titles.stage(a)
end
return M
