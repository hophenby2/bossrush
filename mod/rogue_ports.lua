-- 随机池读取正式注册的原作元数据，不从翻译后的卡名推断难度。
local M={sources={
    {level=35,code='TH37',title='幕华祭春雪'}, {level=36,code='TH38',title='雪莲华'},
    {level=37,code='TH39',title='幕华祭永夜'}, {level=38,code='TH40',title='夏夜祭'},
    {level=39,code='TH41',title='祈华梦'}, {level=40,code='TH42',title='Like Dreamer'},
    {level=41,code='TH43',title='栖霞园'},
}}
local difficulties={[4]='lunatic',[5]='extra',[6]='phantasm'}
-- 原作灵梦基准主炮 / 宿主主炮（双发2点、每4帧，60 DPS）的伤害单位。
-- Spring NORMAL: 2×13/3×60；ASL: 2×8/5×120；Night NORMAL_A: 4×8×60；
-- Summer Reimu.Shoot: 2×14/3×60；THEIS fire_shot: 2×5/6×60。
-- Dreamer 已在 damageable 中乘52；栖霞园基准主炮同为60 DPS，不再换算。
M.damageUnits={[35]=26/3,[36]=32/5,[37]=32,[38]=28/3,[39]=5/3,[40]=1,[41]=1}
-- 永夜篇关闭灯笼时，BossStage 共用的逐帧受伤上限为22（night_settings 灵梦A首项）。
-- 普通敌机没有这个上限，仍使用四发主炮的32点单位。
M.bossDamageUnits={[37]=22}
function M.tags()
    local out={}
    local function add(code,id,difficulty,role,survival)
        if not difficulty then return end
        out[code]=out[code] or {}
        assert(not out[code][id],'新作随机卡池来源重复：'..code..':'..id)
        out[code][id]={difficulty=difficulty,kind=role=='road' and 'road' or 'boss',survival=survival}
    end
    for _,pair in ipairs({{'TH37',TH37},{'TH39',TH39}}) do
        local code,work=unpack(pair)
        if work then for _,chapter in ipairs(work.data.chapters) do
            local diff=difficulties[chapter.difficulty]
            for _,road in ipairs(chapter.roads) do add(code,road.id,diff,'road',false) end
            for _,group in ipairs(chapter.bosses) do for _,meta in ipairs(group.cards) do
                add(code,meta.id,diff,group.role)
            end end
        end end
    end
    if TH38 then
        for id,entry in pairs(TH38.cards) do
            local source=entry.card.asl_source
            local key=source.key or ''
            add('TH38',id,key:match('^L/') and 'lunatic' or key:match('^EXA/') and 'extra',entry.card.phase_kind)
        end
    end
    local summer=_editor_class.TH40
    if summer then for _,meta in ipairs(summer.data.phases) do
        -- 本后端只导出了原作 L 与 EX；FSC 是对应难度的原生攻击，仍保留。
        add('TH40',meta.id,meta.chapter=='EX' and 'extra' or 'lunatic',meta.kind=='road' and 'road' or meta.role,meta.survival==true)
    end end
    for _,unit in ipairs(_sc_pr_table[39] or {}) do
        local card=unit.sc_group[1].card
        local source=card.port_source
        if source and (source.stage==7 or source.class and source.class:match(':Lunatic$') or card.phase_kind=='road') then
            local c=source.card
            add('TH41',card.card_id,source.stage==7 and 'extra' or 'lunatic',card.phase_kind,
                c and c.t1==c.t3 or false)
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
        add('TH43',row.id,difficulties[row.difficulty],row.role)
    end end
    return out
end
return M
