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
    local cards={}
    for number,count in ipairs(pool.STAGE_COUNTS) do
        for index=1,count do
            local spell=pool.spellAt(number,index)
            local available={}
            for _,bucket in ipairs(stages[number]) do
                local indices={}
                for i,entry in ipairs(bucket.cards) do
                    if entry.spell==spell then indices[#indices+1]=i end
                end
                if #indices>0 then available[#available+1]={bucket=bucket,indices=indices} end
            end
            local choice=available[gen:Int(1,#available)]
            cards[#cards+1]=table.remove(choice.bucket.cards,choice.indices[gen:Int(1,#choice.indices)])
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
local DELAY,FLIGHT,FADE=6,48,6
local DURATION=DELAY+FLIGHT+FADE
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
    local a=run.stage_banner
    return a and math.max(0,math.min(1,(DELAY+FLIGHT-a.age)/FADE))*255 or 255
end
function M.render(run)
    local a=run.stage_banner
    if not a then return end
    local previous=lstg.viewmode
    SetViewMode('ui')
    local w=lstg.world
    local portrait=AndroidPortrait and AndroidPortrait.enabled()
    local x,y=portrait and (w.scrl+w.scrr)/2 or w.scrl/2,portrait and w.scrt-28 or 270
    local centerX,centerY=screen.width/2,screen.height/2+72
    local t=math.max(0,math.min(1,(a.age-DELAY)/FLIGHT))
    local move=t*t*(3-2*t)
    local alpha=math.min(1,(DURATION-a.age)/FADE)*255
    local size=math.min(2.6,(w.scrr-w.scrl-24)/(#a.text*16))
    local rgb=a.stage==6 and {255,75,85} or {255,255,255}
    ui:RenderText('title',a.text,centerX+(x-centerX)*move,centerY+(y-centerY)*move,
        size+(1-size)*move,Color(alpha,unpack(rgb)),'centerpoint')
    if previous then SetViewMode(previous) end
end
return M
