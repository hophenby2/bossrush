-- 同一卡片的额外Boss身体；独立抽取的另一名Boss不属于本体的结算范围。
local function visible(o)
    return IsValid(o) and o.status~='del' and o.status~='kill' and not o.hide and not o.mhj3_hidden
end
return function(b)
    local result,seen,ownHealth={},{},{}
    local function add(o,independent)
        if o~=b and not seen[o] and visible(o) then
            seen[o]=true;result[#result+1]=o;ownHealth[o]=independent
        end
    end
    if b.mhj3_card then for _,a in ipairs(b.mhj3_card.actors) do add(a.object) end end
    if b.asl_controller then for _,s in ipairs(b.asl_controller.entities) do
        if s.kind=='boss' and (b.asl_controller.linked or not s.main) and s.alive then
            add(s.native,b.asl_controller.linked)
        end
    end end
    if b.th07_instruments then for _,o in pairs(b.th07_instruments.roles or {}) do add(o) end end
    if b.th06 and b.th06.actors then for _,a in ipairs(b.th06.actors) do
        if a.clone and not a.dead then add(a.object,true) end
    end end
    return result,ownHealth
end
