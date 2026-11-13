--祈华梦四面boss定义
--规定boss名为 "stage"..(关卡数).."boss"..(难度名称)  (如 stage1boss:Lunatic）
--规定LSC的boss名为  "LSC"..(关卡数)..":"..(难度名称)
--因为编辑器原因，所以boss定义都必须是编辑器生成的对象，所以最终命名为 _editor_class["LSC1:Easy"] 这样

local path = "EISlib/stage/stage4/"
--行走图
Include(path.."Hisoka_boss.lua")
--载入各难度定义脚本文件
Include(path.."s4_boss_easy.lua")
Include(path.."s4_boss_normal.lua")
Include(path.."s4_boss_hard.lua")
Include(path.."s4_boss_lunatic.lua")

--召唤boss，diff填1到4对应e到l，如果不填则自动匹配全局难度参数difficulty
function s4_boss.main(diff, nolscachi)
    local boss
    diff = diff or difficulty
    if diff == 1 then
        boss = New(_editor_class["stage4boss:Easy"], _editor_class["stage4boss:Easy"].cards)
    elseif diff == 2 then
        boss = New(_editor_class["stage4boss:Normal"], _editor_class["stage4boss:Normal"].cards)
    elseif diff == 3 then
        boss = New(_editor_class["stage4boss:Hard"], _editor_class["stage4boss:Hard"].cards)
    elseif diff == 4 then
        boss = New(_editor_class["stage4boss:Lunatic"], _editor_class["stage4boss:Lunatic"].cards)
    end
    --关底boss等待
    while IsValid(boss) do
        task.Wait(1)
    end
    if system.checkChainAchieve() then
        if not nolscachi then
            --成就 解锁四面LSC (id:36)
            achievement.unlock("36", true)
        end
        task.Wait(180)
        s4_boss.LSC()
    end
    if EISlib.stage.canDialog() then
        task.Wait(120)
        dialog.player.playScene("Stage4_after", true)
    end
end
function s4_boss.LSC(diff)
    local boss
    diff = diff or difficulty
    if diff == 1 then
        boss = New(_editor_class["LSC4:Easy"], _editor_class["LSC4:Easy"].cards)
    elseif diff == 2 then
        boss = New(_editor_class["LSC4:Normal"], _editor_class["LSC4:Normal"].cards)
    elseif diff == 3 then
        boss = New(_editor_class["LSC4:Hard"], _editor_class["LSC4:Hard"].cards)
    elseif diff == 4 then
        boss = New(_editor_class["LSC4:Lunatic"], _editor_class["LSC4:Lunatic"].cards)
    end
    --关底boss等待
    while IsValid(boss) do
        task.Wait(1)
    end
end
