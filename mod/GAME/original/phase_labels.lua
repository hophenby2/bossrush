-- 老作品与新作共用阶段命名入口。面数、路线和道中归属读注册元数据，不从标题猜。
-- 道中只改名称与阶段类型；非符的name仍为空，右上角标题单独保存。
local P={}
local games={[29]='永夜抄',[30]='红魔乡',[31]='文花帖',[32]='妖妖梦',[33]='风神录'}
local portGames={[35]='幕华祭春雪',[36]='雪莲华',[37]='幕华祭永夜',[38]='夏夜祭',
    [39]='祈华梦',[40]='Like Dreamer',[41]='栖霞园'}
local portCounts={}
local function portLabel(card,level)
    local game=portGames[level]
    if not game then return end
    local source=assert(card.phase_source,'新作阶段缺少命名来源：'..level)
    if source.label then return source.label end
    local chapter=tostring(source.chapter)
    local kind=source.kind or card.phase_kind
    local name
    if kind=='road' then
        local count,index=source.road_count or 1,source.road_index or 1
        local part=count>2 and ('#'..index) or count==2 and (index==1 and '前半' or '后半') or ''
        name=game..chapter..'道中'..part
        card.phase_part=part~='' and part or nil
        -- 沿用老作品：有标题的道中也不作为符卡结算。
        card.name,card.is_sc=name,false
    elseif card.is_sc then
        name=source.spell_name or card.name
        card.name=name
    else
        local face=chapter:match('^%d') and chapter..'面' or chapter
        name=game..face..(kind=='mid' and '道中' or '关底')
        if not source.aggregate then
            -- 只在非符处递增；道中/关底、难度与互斥路线分别计数。
            local key=level..':'..chapter..':'..kind..':'..tostring(source.route or '')
            local index=(portCounts[key] or 0)+1
            portCounts[key]=index
            card.phase_key,card.phase_index=key,index
            name=name..index..'非'
        end
    end
    source.label=name
    card.phase_name=name
    return name
end
local roads={
    [29]={[3409]='1',[3410]='1',[3429]='2',[3428]='3',[3437]='3',
        [3412]='4A',[3416]='4A',[3414]='4B',[3418]='4B',[3432]='5',[3435]='5',
        [3430]='6A',[3431]='6B',[3438]='EX',[3439]='EX'},
    [32]={[3400]='1',[3401]='2',[3402]='3',[3403]='4',[3404]='5',[3405]='6',[3406]='EX',[3407]='PH'},
    [33]={[3680]='1',[3681]='2',[3682]='3',[3683]='4',[3684]='5',[3671]='6',[3685]='EX'},
}
-- 只给真正分段的道中加前后半；整段道中不因最后一波的位置改名。
local road_parts={
    [29]={[3409]='前半',[3410]='后半',[3428]='前半',[3437]='后半',
        [3412]='前半',[3416]='后半',[3414]='前半',[3418]='后半',
        [3432]='前半',[3435]='后半',[3438]='前半',[3439]='后半'},
    [32]={[3403]='前半',[3405]='前半'},
}
-- 永夜抄同一角色组内混有中Boss和主Boss，不能按角色组给整组命名。
-- 二面Sub25主Boss宿主从Sub27（463）开始；旧运动key里的mid不能当阶段类型。
local mid8={[470]=true,[461]=true,[3436]=true,[433]=true,[435]=true,
    [443]=true,[445]=true,[3433]=true,[3434]=true,[422]=true,[406]=true}
local mid6={[2]=true,[4]=true,[6]=true,[8]=true,[10]=true,[12]=true,[13]=true}
local stage8={['1']='1',['2']='2',['3']='3',['4a']='4A',['4b']='4B',['5']='5',
    ['6']='6A',['7']='6B',['8']='EX'}
local stage_sources8
local function source(card,level,id,band)
    local road=roads[level] and roads[level][id]
    if road then return road,'road',nil,road_parts[level] and road_parts[level][id] end
    if level==30 then
        local m=card.th06_source
        if not m then return end
        local stage=m.stage==7 and 'EX' or tostring(m.stage)
        if m.road then return stage,'road',nil,m.part=='before' and '前半' or m.part=='after' and '后半' or nil end
        if not card.is_sc then return stage,mid6[m.group] and 'mid' or 'boss',tostring(m.group) end
    elseif not card.is_sc then
        if level==29 then
            stage_sources8=stage_sources8 or dofile('mod/GAME/th31_stage_sources.lua')
            local file=stage_sources8[id]
            local stage=file and stage8[file:match('^ecldata(%d+[ab]?)$')]
            if stage then return stage,mid8[id] and 'mid' or 'boss',band end
        elseif level==31 then
            local m=card.original_ecl
            local file=m and tonumber(m.file:match('^ecl(%d+)_'))
            if not file then return end
            local stage=file<=6 and math.ceil(file/2) or file<=9 and 4 or math.floor((file-10)/2)+5
            return file>=22 and 'EX' or tostring(stage),'boss',band
        elseif level==32 then
            local class=_editor_class.TH34
            local m=class and class.th07_motion_source and class.th07_motion_source[id]
            if not m then return end
            local stage=tonumber(m.file:match('^ecldata(%d+)'))
            return stage==7 and 'EX' or stage==8 and 'PH' or tostring(stage),
                m.key:find('mid',1,true) and 'mid' or 'boss',m.key
        elseif level==33 then
            local class=_editor_class.TH35
            local m=class and class.t10_boss_entry and class.t10_boss_entry[id]
            if not m then return end
            local stage=tonumber(m.key:match('^s(%d+)'))
            return stage==7 and 'EX' or tostring(stage),m.key:find('mid',1,true) and 'mid' or 'boss',m.key
        end
    end
end
function P.apply(card,level,id,boss,band)
    if portGames[level] then return portLabel(card,level) end
    local game=games[level]
    if not game then return end
    if card.phase_name then return card.phase_name end
    local stage,kind,host,part=source(card,level,id,band)
    if not stage then return end
    local name=game..stage
    if kind=='road' then
        name=name..'道中'..(part or '')
        card.phase_part=part
        card.name,card.is_sc=name,false
    else
        -- 每个宿主的中Boss/主Boss分别从一非计数；机体分支和三姐妹独立计数。
        local key=stage..':'..kind..':'..host
        local index=1
        for _,previous in ipairs(boss.cards) do
            if previous.phase_key==key then index=math.max(index,previous.phase_index+1) end
        end
        card.phase_key,card.phase_index=key,index
        name=name..(kind=='mid' and '道中Boss' or '关底')..index..'非'
    end
    card.phase_name,card.phase_kind=name,kind
    return name
end
return P
