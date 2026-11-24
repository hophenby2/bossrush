-- 抽卡只认已核对的卡号与来源；注册标题不承担难度/道中分类职责。
local P={}
P.sources={{level=29,code='TH31',title='永夜抄'},{level=30,code='TH32',title='红魔乡'},
    {level=32,code='TH34',title='妖妖梦'},{level=33,code='TH35',title='风神录'}}
local catalog=dofile('mod/rogue_pool_sources.lua')
local ports=dofile('mod/rogue_ports.lua')
local stageOrder=dofile('mod/GAME/original/stage_order.lua')
local stageById={}
for _,level in ipairs({29,30,32,33}) do
    local chapters=stageOrder[level]
    stageById[level]={}
    for _,chapter in ipairs(chapters) do
        -- 永夜抄 4A/4B、6A/6B 同属第四、第六面；不将 EX / PH 混入数字面。
        local number=tonumber(chapter.name:match('^([1-6])[AB]?$'))
        if number then for _,id in ipairs(chapter.cards) do stageById[level][id]=number end end
    end
end
P.STAGE_COUNTS={4,5,6,7,7,9}
for _,source in ipairs(ports.sources) do P.sources[#P.sources+1]=source end
local tags={}
for code,source in pairs(catalog) do
    tags[code]={}
    for difficulty,types in pairs(source) do
        for kind,ids in pairs(types) do
            for _,id in ipairs(ids) do
                assert(not tags[code][id],'随机卡池来源重复：'..code..':'..id)
                tags[code][id]={difficulty=difficulty,kind=kind}
            end
        end
    end
end
local fields={stages={'TH31','TH32','TH34','TH35','TH37','TH38','TH39','TH40','TH41','TH42','TH43'},difficulties={'lunatic','extra','lastword'},encounters={'boss','road'},cards={'nonspell','spell','survival'},rules={'enhanced'}}
function P.defaults(variant)
    local single=not variant or variant=='single' or variant=='staged'
    local stages={TH31=true,TH32=single,TH34=true,TH35=true}
    for _,source in ipairs(ports.sources) do stages[source.code]=single end
    if variant=='staged' then stages.TH42=false end
    return {stages=stages,
        difficulties={lunatic=true,extra=false,lastword=false},encounters={boss=true,road=false},
        cards={nonspell=true,spell=true,survival=variant=='staged'},rules={enhanced=true}}
end
function P.copy(filters,variant)
    local defaults=P.defaults(variant)
    if type(filters)~='table' then filters={} end
    local out={}
    for group,keys in pairs(fields) do
        local values=type(filters[group])=='table' and filters[group] or defaults[group]
        out[group]={}
        for _,key in ipairs(keys) do
            local value=values[key]
            if value==nil and (group=='rules' or group=='cards' and (key=='nonspell' or key=='spell')) then value=defaults[group][key] end
            out[group][key]=value==true
        end
    end
    if variant=='staged' then
        out.stages.TH42=false
        out.difficulties={lunatic=true,extra=false,lastword=false}
        out.encounters={boss=true,road=false}
        out.cards={nonspell=true,spell=true,survival=true}
    end
    return out
end
function P.isSurvival(unit,kind)
    -- 道中用无敌宿主承载时间轴，实际小怪仍可击破，不能当成耐久符卡过滤。
    if kind=='road' then return false end
    local combat=false
    for _,part in ipairs(unit.sc_group or {}) do
        local c=part.card
        if c and c.is_combat~=false then
            combat=true
            if not (type(c.t1)=='number' and type(c.t3)=='number' and c.t3>0 and c.t1==c.t3) then return false end
        end
    end
    return combat
end
function P.build(filters)
    filters=P.copy(filters)
    local portTags=ports.tags()
    local pool,total,seen={},0,{}
    for _,source in ipairs(P.sources) do
        if filters.stages[source.code] then
            local bucket={code=source.code,level=source.level,cards={}}
            for index,unit in ipairs(_sc_pr_table[source.level] or {}) do
                local first=unit.sc_group and unit.sc_group[1]
                local id=first and first.card.card_id
                local sourceTags=tags[source.code] or portTags[source.code]
                local tag=id and sourceTags and sourceTags[id]
                -- Extra 和 Phantasm 共用准备页开关。
                local difficulty=tag and (tag.difficulty=='phantasm' and 'extra' or tag.difficulty)
                local survival=tag and tag.survival
                if tag and survival==nil then survival=P.isSurvival(unit,tag.kind) end
                local selected=tag and (tag.kind=='road' or (survival and filters.cards.survival)
                    or (not survival and (first.card.is_sc and filters.cards.spell or not first.card.is_sc and filters.cards.nonspell)))
                if tag and filters.difficulties[difficulty] and filters.encounters[tag.kind]
                    and not first.card.practice_hidden
                    and selected
                    and first.card.is_combat~=false and not seen[id] then
                    local label=unit.CardName or ''
                    seen[id]=true
                    bucket.cards[#bucket.cards+1]={key=source.code..':'..id,index=index,level=source.level,source=source.code,
                        cardId=id,title=label~='' and label or (first.card.is_sc and first.card.name or '非符'),
                        spell=first.card.is_sc==true,difficulty=difficulty,originalDifficulty=tag.difficulty,kind=tag.kind,survival=survival,
                        stage=tag.stage or stageById[source.level] and stageById[source.level][id]}
                end
            end
            -- 某作在所选难度/类型下没有候选时不参与来源抽签，不从别处补进卡。
            if #bucket.cards>0 then pool[#pool+1]=bucket;total=total+#bucket.cards end
        end
    end
    return pool,total
end
-- 每一面单独建池：作品筛选后不足时明确拒绝，不补入其他面、其他难度或重复卡。
function P.buildStages(filters)
    local pool=P.build(P.copy(filters,'staged'))
    local stages,counts={},{0,0,0,0,0,0}
    for number=1,6 do stages[number]={} end
    for _,bucket in ipairs(pool) do
        local buckets={}
        for _,entry in ipairs(bucket.cards) do
            local number=entry.stage
            if entry.source~='TH42' and entry.originalDifficulty=='lunatic' and entry.kind=='boss' and stages[number] then
                if not buckets[number] then
                    buckets[number]={code=bucket.code,level=bucket.level,cards={}}
                    stages[number][#stages[number]+1]=buckets[number]
                end
                local cards=buckets[number].cards
                cards[#cards+1]=entry;counts[number]=counts[number]+1
            end
        end
    end
    return stages,counts
end
function P.stageStatus(filters)
    local stages,counts=P.buildStages(filters)
    local state={valid=true,count=0,need=38,counts=counts}
    for number,need in ipairs(P.STAGE_COUNTS) do
        state.count=state.count+counts[number]
        if counts[number]<need and state.valid then
            state.valid=false
            state.message=string.format('第%d面仅%d张，至少需要%d张',number,counts[number],need)
        end
    end
    if state.count==0 then state.message='选择的卡池为空' end
    return state,stages
end
function P.status(filters,need)
    local options=P.copy(filters)
    local _,count=P.build(options)
    local state={count=count,need=need,valid=false}
    if count==0 then state.message='选择的卡池为空';return state end
    if count<need then
        state.message=string.format('候选仅 %d 张，至少需要 %d 张',count,need)
        return state
    end
    state.valid=true
    return state
end
return P
