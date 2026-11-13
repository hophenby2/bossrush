-- 关卡练习与符卡练习共用来源范围；显示序号与实际关卡level分开。
local P={stages={
    {code='TH31',level=29,title='永夜抄原作'},
    {code='TH32',level=30,title='红魔乡原作'},
    {code='TH33',level=31,title='文花帖原作'},
    {code='TH34',level=32,title='妖妖梦原作'},
    {code='TH35',level=33,title='风神录原作'},
    {code='TH38',level=35,title='夏夜祭原作'},
    {code='TH39',level=36,title='祈华梦原作'},
    {code='TH40',level=37,title='Like Dreamer'},
}}
function P.allowed(level)
    for _,entry in ipairs(P.stages) do if entry.level==level then return true end end
    return false
end
function P.canStart(name,spell)
    if spell then
        local group=lstg.var.sc_group
        return name=='Spell Practice@Spell Practice' and type(group)=='table' and P.allowed(group[1])
    end
    for _,entry in ipairs(P.stages) do if name==entry.code..'@BossRush' then return true end end
    return false
end
function P.cards(level)
    if OriginalStageFlow then return OriginalStageFlow.units(level) end
    local out={}
    for index,unit in ipairs(_sc_pr_table[level] or {}) do out[#out+1]={index=index,unit=unit} end
    return out
end
return P
