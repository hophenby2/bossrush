-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."sence1/spellcard/mid_escape_1.lua" --当前存放目录
local function createCard(difficulty)
    local card = EGGlib.BossCard.createEscape(
            function(b)
                PlaySound("bonus2")
                --_drop_item(item_huge_chip, 1, b.x, b.y) --掉落大血灵碎片
                effect.shakeScreen(20, 10)
                task.Wait(20)
                --之后就是向上逃跑事件
            end)
    return card
end
return createCard
