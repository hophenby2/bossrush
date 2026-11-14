-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local AbsorbEffect2 = EGGlib.RenderEffect.AbsorbEffect2


local function createCard(difficulty)
    local card = EGGlib.BossCard.createEscape(
            function(b)
                task.Wait(60)
                b.cast("cast")
                b.absorbEffect(b, 40)
                effect.shakeScreen(100, 10)
                for _ = 1, 3 do
                    New(AbsorbEffect2, b.x, b.y, 255, 255, 0, "mul+add")
                    task.Wait(20)
                end
                task.Wait(20)
                --原地爆炸
                New(boss_death_ef, b.x, b.y)
                New(boss_death_circle, b.x, b.y)
                Del(b)
            end)
    return card
end
return createCard
