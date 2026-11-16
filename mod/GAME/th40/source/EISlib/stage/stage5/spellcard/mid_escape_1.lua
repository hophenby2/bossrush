-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local function loadRes()

end
loadRes()

local function createCard(difficulty)
    local card = EGGlib.BossCard.createEscape(
            function(b)
                item.PlayerLife.create(0, 144)
                task.Wait(30)
                --之后就是向上逃跑事件
                task.MoveTo(b, -224, 100, 90, MOVE_ACC_DEC)
                Del(b)
            end)
    return card
end
return createCard
