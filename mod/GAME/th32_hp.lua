-- 红魔乡低速满火力的活跃TTK中位数；只换实际可伤害血量，不改变ECL的life单位。
local M=dofile('mod/GAME/original/th06_low_speed_hp.lua')
local function factor(raw,spell)
    if raw<=0 or raw>=999999 then return 1 end
    return math.max(1,raw*M.scale[spell and 'spell' or 'normal'])/raw
end
function M.raw(o)
    local value=o.hp/(o._th06_hp_scale or 1)
    -- 换算后的浮点误差不能提前触发原作life<threshold的回调。
    local nearest=math.floor(value+.5)
    if math.abs(value-nearest)<1e-8 then return nearest end
    return value
end
function M.unit(o,raw,spell)
    local scale=factor(raw,spell)*(GameHPScale and GameHPScale.factor(o) or 1)
    o._th06_hp_scale,o._th06_hp_spell=scale,spell
    o.hp,o.maxhp=raw*scale,raw*scale
    if GameHPScale then GameHPScale.mark(o) end
end
function M.main(o,entry,raw)
    local hp=entry and entry.hp or raw
    hp=hp*(GameHPScale and GameHPScale.factor(o) or 1)
    o._th06_hp_scale=raw>0 and hp/raw or 1
    o._th06_hp_spell=entry and entry.spell or false
    o.hp,o.maxhp=hp,hp
    if GameHPScale then GameHPScale.mark(o) end
end
function M.spell(state,spell)
    if not state or state.spell==spell then return end
    state.spell=spell
    for _,actor in pairs(state.actors or {}) do
        local o=actor.object
        if not actor.main and not actor.dead and IsValid(o) then
            -- 先还原剩余life，再按原始最大life选比例；切状态不能给残血单位回血。
            local raw=M.raw(o)
            local maximum=o.maxhp/(o._th06_hp_scale or 1)
            local scale=factor(maximum,spell)*(GameHPScale and GameHPScale.factor(o) or 1)
            o._th06_hp_scale,o._th06_hp_spell=scale,spell
            o.hp,o.maxhp=raw*scale,maximum*scale
            if GameHPScale then GameHPScale.mark(o) end
        end
    end
end
function M.cards(level,groups)
    for _,group in ipairs(groups) do
        local b=_editor_boss[group..'a'..level]
        for _,card in ipairs(b and b.cards or {}) do
            local entry=M.entries[card.card_id]
            if entry then card.hp,card._th06_balance=entry.hp,entry end
        end
    end
end
return M
