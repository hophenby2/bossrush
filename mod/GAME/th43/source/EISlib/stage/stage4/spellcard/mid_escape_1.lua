-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------

local function createCard(difficulty)
    local card = EGGlib.BossCard.createEscape(
            function(b)
                task.Wait(60)
                task.MoveTo(b, 0, 384, 90, MOVE_ACC_DEC)
                Del(b)
            end)
    return card
end
return createCard
