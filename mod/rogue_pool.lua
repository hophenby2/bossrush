-- 抽卡只认已核对的卡号与来源；注册标题不承担难度/道中分类职责。
local P={}
P.sources={{level=29,code='TH31',title='永夜抄'},{level=30,code='TH32',title='红魔乡'},
    {level=32,code='TH34',title='妖妖梦'},{level=33,code='TH35',title='风神录'},
    {level=34,code='TH36',title='地灵殿'}}
local catalog=dofile('mod/rogue_pool_sources.lua')
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
local fields={stages={'TH31','TH32','TH34','TH35','TH36'},difficulties={'lunatic','extra'},encounters={'boss','road'},cards={'nonspell','spell','survival'}}
function P.defaults(variant,poolVersion)
    -- 新局关闭TH36选择；仅版本4的历史录像保留当时的五作范围。
    local single=not variant or variant=='single'
    local historical=poolVersion and poolVersion<7
    return {stages={TH31=true,TH32=single,TH34=true,TH35=true,TH36=single and poolVersion==4},
        difficulties={lunatic=true,extra=true},encounters={boss=true,road=single and historical or false},
        cards={nonspell=true,spell=true,survival=historical or false}}
end
function P.copy(filters,variant,poolVersion)
    local defaults=P.defaults(variant,poolVersion)
    if type(filters)~='table' then filters={} end
    local out={}
    for group,keys in pairs(fields) do
        local values=type(filters[group])=='table' and filters[group] or defaults[group]
        out[group]={}
        for _,key in ipairs(keys) do
            local value=values[key]
            if value==nil and group=='cards' and (key=='nonspell' or key=='spell') then value=defaults[group][key] end
            out[group][key]=value==true
        end
    end
    -- 旧设置中的勾选也必须失效，不能只移除准备界面的按钮。
    out.stages.TH36=out.stages.TH36 and poolVersion==4
    if poolVersion and poolVersion<6 then out.cards.survival=true end
    if poolVersion and poolVersion<7 then out.cards.nonspell,out.cards.spell=true,true end
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
function P.build(filters,poolVersion)
    filters=P.copy(filters,nil,poolVersion)
    local pool,total,seen={},0,{}
    for _,source in ipairs(P.sources) do
        -- 新作只进入版本4；旧录像即使缺少筛选初态，也不能因默认值改变而重抽。
        if filters.stages[source.code] and not (source.code=='TH36' and poolVersion and poolVersion<4) then
            local bucket={code=source.code,level=source.level,cards={}}
            for index,unit in ipairs(_sc_pr_table[source.level] or {}) do
                local first=unit.sc_group and unit.sc_group[1]
                local id=first and first.card.card_id
                local tag=id and tags[source.code][id]
                -- extra键保留已有筛选初态；Phantasm只在新版池并入，版本2录像沿用原集合。
                local difficulty=tag and (tag.difficulty=='phantasm' and 'extra' or tag.difficulty)
                local survival=tag and P.isSurvival(unit,tag.kind)
                local selected=tag and (tag.kind=='road' or (survival and filters.cards.survival)
                    or (not survival and (first.card.is_sc and filters.cards.spell or not first.card.is_sc and filters.cards.nonspell)))
                if tag and filters.difficulties[difficulty] and filters.encounters[tag.kind]
                    and not (poolVersion==2 and tag.difficulty=='phantasm')
                    and selected
                    and first.card.is_combat~=false and not seen[id] then
                    local label=unit.CardName or ''
                    seen[id]=true
                    bucket.cards[#bucket.cards+1]={key=source.code..':'..id,index=index,level=source.level,source=source.code,
                        cardId=id,title=label~='' and label or (first.card.is_sc and first.card.name or '非符'),
                        spell=first.card.is_sc==true,difficulty=difficulty,originalDifficulty=tag.difficulty,kind=tag.kind,survival=survival}
                end
            end
            -- 某作在所选难度/类型下没有候选时不参与来源抽签，不从别处补进卡。
            if #bucket.cards>0 then pool[#pool+1]=bucket;total=total+#bucket.cards end
        end
    end
    return pool,total
end
function P.status(filters,need)
    local options=P.copy(filters)
    local _,count=P.build(options)
    local state={count=count,need=need,valid=false}
    for _,entry in ipairs({{'stages','关卡'},{'difficulties','难度'},{'encounters','Boss / 道中'}}) do
        local any=false
        for _,enabled in pairs(options[entry[1]]) do if enabled then any=true;break end end
        if not any then state.message=entry[2]..'至少选择一项';return state end
    end
    if count<need then
        state.message=string.format('候选仅 %d 张，至少需要 %d 张',count,need)
        return state
    end
    state.valid=true
    return state
end
return P
