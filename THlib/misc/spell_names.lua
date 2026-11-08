-- 卡号只用于定位注册；双语名称在离线导出时按原作ECL入口匹配，切换不改变历史槽位。
local S={entries=dofile('mod/GAME/original/spell_names.lua'),bindings={}}
SpellNames=S
local function language(value)
    if value==nil then value=(cur_setting or setting or {}).spellNameLanguage end
    return value==1 and 'ja' or 'zh'
end
local function replace(text,old,new)
    if not text then return end
    local first,last=text:find(old,1,true)
    if first then return text:sub(1,first-1)..new..text:sub(last+1) end
    return new
end
function S.text(level,id,fallback)
    local entry=S.entries[level] and S.entries[level][id]
    return entry and entry[language()] or fallback
end
local function apply(binding,lang)
    local name=binding.entry[lang]
    binding.card.name=name
    if binding.phase then binding.card.phase_name=replace(binding.phase,binding.original,name) end
    local title=replace(binding.caption,binding.original,name)
    for _,unit in ipairs(binding.units) do unit.CardName=title end
    return title
end
function S.bind(card,level,id,caption)
    local entry=S.entries[level] and S.entries[level][id]
    if not entry or not card.is_sc then return caption end
    local binding={card=card,entry=entry,original=card.name,phase=card.phase_name,caption=caption,units={}}
    card.name_zh,card.name_ja=entry.zh,entry.ja
    S.bindings[#S.bindings+1]=binding
    return apply(binding,language()),binding
end
function S.refresh(value)
    local lang=language(value)
    if S.current==lang then return end
    S.current=lang
    for _,binding in ipairs(S.bindings) do apply(binding,lang) end
end
return S
