-- 只判定已经开始退场的状态，不改变首次消弹的免疫、出生期或强制清场规则。
return function(o,known_valid)
    if not known_valid and not IsValid(o) then return true end
    local s=o.mhj
    if s and s.dis then return true end -- Lua中的0也是有效状态：永夜篇淡出从0开始。
    local status=o.status
    return status=='del' or status=='kill' or o._original_despawning==true
        or o._native_cancelled==true or o.fade_out==true
end
