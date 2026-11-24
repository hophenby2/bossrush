-- 随机池读取正式注册的原作元数据，不从翻译后的卡名推断难度。
local M={sources={
    {level=35,code='TH37',title='幕华祭春雪'}, {level=36,code='TH38',title='雪莲华'},
    {level=37,code='TH39',title='幕华祭永夜'}, {level=38,code='TH40',title='夏夜祭'},
    {level=39,code='TH41',title='祈华梦'}, {level=40,code='TH42',title='Like Dreamer'},
    {level=41,code='TH43',title='栖霞园'},
}}
local difficulties={[4]='lunatic',[5]='extra',[6]='phantasm'}
-- 原作可选机体完整低速输出的活跃TTK中位数；保留原HP域，见生成表及报告。
local calibration=dofile('mod/rogue_ttk_hp.lua')
M.damageUnits,M.bossDamageUnits=calibration.damageUnits,calibration.bossDamageUnits
function M.tags()
    local out={}
    local function add(code,id,difficulty,role,survival,chapter)
        if not difficulty then return end
        out[code]=out[code] or {}
        assert(not out[code][id],'新作随机卡池来源重复：'..code..':'..id)
        out[code][id]={difficulty=difficulty,kind=role=='road' and 'road' or 'boss',survival=survival,stage=tonumber(chapter)}
    end
    for _,pair in ipairs({{'TH37',TH37},{'TH39',TH39}}) do
        local code,work=unpack(pair)
        if work then for _,chapter in ipairs(work.data.chapters) do
            local diff=difficulties[chapter.difficulty]
            for _,road in ipairs(chapter.roads) do add(code,road.id,diff,'road',false,chapter.stage) end
            for _,group in ipairs(chapter.bosses) do for _,meta in ipairs(group.cards) do
                add(code,meta.id,diff,group.role,nil,chapter.stage)
            end end
        end end
    end
    if TH38 then
        for id,entry in pairs(TH38.cards) do
            local source=entry.card.asl_source
            local key=source.key or ''
            add('TH38',id,key:match('^L/') and 'lunatic' or key:match('^EXA/') and 'extra',entry.card.phase_kind,nil,key:match('^L/stage(%d+)/'))
        end
    end
    local summer=_editor_class.TH40
    if summer then for _,meta in ipairs(summer.data.phases) do
        -- 本后端只导出了原作 L 与 EX；FSC 是对应难度的原生攻击，仍保留。
        add('TH40',meta.id,meta.chapter=='EX' and 'extra' or 'lunatic',meta.kind=='road' and 'road' or meta.role,meta.survival==true,meta.chapter)
    end end
    for _,unit in ipairs(_sc_pr_table[39] or {}) do
        local card=unit.sc_group[1].card
        local source=card.port_source
        if source and (source.stage==7 or source.class and source.class:match(':Lunatic$') or card.phase_kind=='road') then
            local c=source.card
            add('TH41',card.card_id,source.stage==7 and 'extra' or 'lunatic',card.phase_kind,
                c and c.t1==c.t3 or false,source.stage)
        end
    end
    for _,unit in ipairs(_sc_pr_table[40] or {}) do
        local card=unit.sc_group[1].card
        local source=card.port_source
        -- 原作 Nightmare=3；仅收单个攻击，排除重复的整场关底包装入口。
        if source and (source.phase or card.phase_kind=='road') then
            add('TH42',card.card_id,'lunatic',card.phase_kind,false)
        end
    end
    if TH43 then for _,row in ipairs(TH43.rows) do
        add('TH43',row.id,difficulties[row.difficulty],row.role,nil,row.chapter)
    end end
    return out
end
return M
