-- 顺序模式使用独立入口与稳定key；练习索引、随机卡池和历史录像的数组保持原位。
local C={VERSION=1,entries={}}
local function add(key,title,level,difficulty,ending)
    C.entries[#C.entries+1]={key=key,title=title,level=level,difficulty=difficulty,ending=ending,
        group='Sequence_'..key,battle=key..'@Sequence_'..key}
end
add('th08_lunatic_a','永夜抄 · Lunatic · Final A',29,'lunatic','6A')
add('th08_lunatic_b','永夜抄 · Lunatic · Final B',29,'lunatic','6B')
add('th08_extra','永夜抄 · Extra',29,'extra')
add('th06_lunatic','红魔乡 · Lunatic',30,'lunatic')
add('th06_extra','红魔乡 · Extra',30,'extra')
-- 文花帖原作按场景分级，没有Lunatic/Phantasm，不能给场景虚构难度。
add('th095_scenes','文花帖 · Level 1–10',31,'scenes')
add('th095_extra','文花帖 · Extra',31,'extra')
add('th07_lunatic','妖妖梦 · Lunatic',32,'lunatic')
add('th07_extra','妖妖梦 · Extra',32,'extra')
add('th07_phantasm','妖妖梦 · Phantasm',32,'phantasm')
add('th10_lunatic','风神录 · Lunatic',33,'lunatic')
add('th10_extra','风神录 · Extra',33,'extra')
add('thsss_lunatic','夏夜祭 · Lunatic · 全阶段',35,'lunatic')
add('thsss_extra','夏夜祭 · Extra · 全阶段',35,'extra')
add('theis_lunatic','祈华梦 · Lunatic',36,'lunatic')
add('theis_extra','祈华梦 · Extra',36,'extra')
add('likedreamer_nightmare','Like Dreamer · Nightmare',37,'nightmare')
add('likedreamer_chaos','Like Dreamer · Chaos',37,'chaos')
C.byKey={}
for _,entry in ipairs(C.entries) do C.byKey[entry.key]=entry end
function C.get(key) return C.byKey[key] end
function C.machines(entry)
    local game=SequenceResources and SequenceResources.gameByLevel[entry.level]
    if game then return SequenceResources.machines(game) end
    if entry.level==36 or entry.level==37 then
        local machines={{id='reimu',name='灵梦',route='reimu_player'},
            {id='marisa',name='魔理沙',route='marisa_player'}}
        if entry.level==36 then
            machines[#machines+1]={id='mokou',name='妹红路线 · LuaSTG灵梦',route='reimu_player'}
        end
        return machines
    end
    return {{id='A',name='灵梦路线 · LuaSTG灵梦',route='reimu_player'},{id='B',name='魔理沙路线 · LuaSTG魔理沙',route='marisa_player'},
        {id='C',name='早苗路线 · LuaSTG灵梦',route='reimu_player'},{id='D',name='恋路线 · LuaSTG魔理沙',route='marisa_player'}}
end
function C.chapterForRun(entry,chapter,player,continues)
    -- 永夜抄通常流程续关后转Final A，不能继续沿预选Final B路线进辉夜。
    if entry.level==29 and chapter.name=='6B' and continues>0 then
        for _,candidate in ipairs(C.chapters('th08_lunatic_a',player)) do
            if candidate.name=='6A' then return candidate end
        end
    end
    return chapter
end
local function marisa(player)
    return player=='marisa_player' or player=='Marisa'
end
function C.chapterAllowed(entry,chapter,player)
    if entry.difficulty=='extra' then return chapter=='EX' end
    if entry.difficulty=='phantasm' then return chapter=='PH' end
    if chapter=='EX' or chapter=='PH' or chapter=='Last Word' then return false end
    if entry.level==29 then
        -- 原作灵梦/妖梦路线遇魔理沙，魔理沙/咲夜路线遇灵梦。
        if chapter=='4A' or chapter=='4B' then return chapter==(marisa(player) and '4A' or '4B') end
        if chapter=='6A' or chapter=='6B' then return chapter==entry.ending end
    end
    return true
end
local function selected(entry,row,player)
    local card=row.unit.sc_group[1].card
    local id=card.source_card_id or card.card_id
    if entry.level==30 and row.chapter=='4' and row.role=='boss' then
        local m=card.th06_source
        if SequenceResources and SequenceResources.enabled() then
            local machine=SequenceResources.machine(6,lstg.var.sequence_player)
            return m and m.shot==machine.character*2+machine.shot
        end
        -- 当前自机没有原作A/B机体选择，分别采用灵梦A、魔理沙A对应的原作卡链。
        return m and m.group==(marisa(player) and 16 or 9)
    elseif entry.level==32 then
        local m=_editor_class.TH34.th07_motion_source[id]
        if m and m.difficulty and m.difficulty~=3 then return false end
        if row.chapter=='4' and row.role=='boss' then
            if id==4441 or id==4447 or id==4448 then return true end
            local machine=SequenceResources and SequenceResources.enabled() and SequenceResources.machine(7,lstg.var.sequence_player)
            local key=machine and machine.character==2 and '4merlin' or marisa(player) and '4lyrica' or '4lunasa'
            return m and m.key==key
        end
    end
    return true
end
function C.chapters(key,player)
    local entry=assert(C.get(key),'未知顺序关卡key：'..tostring(key))
    local chapters,last={},nil
    for _,row in ipairs(OriginalStageFlow.units(entry.level)) do
        if C.chapterAllowed(entry,row.chapter,player) and selected(entry,row,player) then
            if not last or last.name~=row.chapter then
                last={name=row.chapter,level=entry.level,units={}};chapters[#chapters+1]=last
            end
            last.units[#last.units+1]=row
        end
    end
    assert(#chapters>0,'顺序关卡没有可运行阶段：'..key)
    -- 文花帖按场景表逐幕；风神录四面先无双风神再照国，原注册/练习数组不改写。
    if entry.level==33 then
        for _,chapter in ipairs(chapters) do
            if chapter.name=='4' then
                local a,b
                for i,row in ipairs(chapter.units) do
                    local id=row.unit.sc_group[1].card.card_id
                    if id==3607 then a=i elseif id==3608 then b=i end
                end
                if a and b and a>b then chapter.units[a],chapter.units[b]=chapter.units[b],chapter.units[a] end
            end
        end
    end
    return chapters
end
return C
