--祈华梦五面boss定义
--规定boss名为 "stage"..(关卡数).."boss"..(难度名称)  (如 stage1boss:Lunatic）
--规定LSC的boss名为  "LSC"..(关卡数)..":"..(难度名称)
--因为编辑器原因，所以boss定义都必须是编辑器生成的对象，所以最终命名为 _editor_class["LSC1:Easy"] 这样

--local path = ""
local path = "EISlib/stage/stage5/"
--boss相关的素材全部在以下脚本文件里
Include(path.."Lily_boss.lua")
Include(path.."Jinguuji_boss.lua")
--载入各难度定义脚本文件
Include(path.."s5_boss_easy.lua")
Include(path.."s5_boss_normal.lua")
Include(path.."s5_boss_hard.lua")
Include(path.."s5_boss_lunatic.lua")



--召唤boss，diff填1到4对应e到l，如果不填则自动匹配全局难度参数difficulty
function s5_mid_boss.main(diff)
    local boss
    diff = diff or difficulty
    if diff == 1 then
        boss = New(_editor_class["stage5mid_boss:Easy"], _editor_class["stage5mid_boss:Easy"].cards)
    elseif diff == 2 then
        boss = New(_editor_class["stage5mid_boss:Normal"], _editor_class["stage5mid_boss:Normal"].cards)
    elseif diff == 3 then
        boss = New(_editor_class["stage5mid_boss:Hard"], _editor_class["stage5mid_boss:Hard"].cards)
    elseif diff == 4 then
        boss = New(_editor_class["stage5mid_boss:Lunatic"], _editor_class["stage5mid_boss:Lunatic"].cards)
    end
    return boss
end

function s5_boss.main(diff, nolscachi)
    local boss
    diff = diff or difficulty
    if diff == 1 then
        boss = New(_editor_class["stage5boss:Easy"], _editor_class["stage5boss:Easy"].cards)
    elseif diff == 2 then
        boss = New(_editor_class["stage5boss:Normal"], _editor_class["stage5boss:Normal"].cards)
    elseif diff == 3 then
        boss = New(_editor_class["stage5boss:Hard"], _editor_class["stage5boss:Hard"].cards)
    elseif diff == 4 then
        boss = New(_editor_class["stage5boss:Lunatic"], _editor_class["stage5boss:Lunatic"].cards)
    end
    --关底boss等待
    while IsValid(boss) do
        task.Wait(1)
    end
    if system.checkChainAchieve() then
        if not nolscachi then
            --成就 解锁五面LSC (id:37)
            achievement.unlock("37", true)
        end
        task.Wait(180)
        s5_boss.LSC()
    end
    if EISlib.stage.canDialog() then
        task.Wait(120)
        dialog.player.playScene("Stage5_after", true)
    end
end
--
function s5_boss.LSC(diff)
    local boss
    diff = diff or difficulty --测试用，记得改回来
    if diff == 1 then
        boss = New(_editor_class["LSC5:Easy"], _editor_class["LSC5:Easy"].cards)
    elseif diff == 2 then
        boss = New(_editor_class["LSC5:Normal"], _editor_class["LSC5:Normal"].cards)
    elseif diff == 3 then
        boss = New(_editor_class["LSC5:Hard"], _editor_class["LSC5:Hard"].cards)
    elseif diff == 4 then
        boss = New(_editor_class["LSC5:Lunatic"], _editor_class["LSC5:Lunatic"].cards)
    end
    --关底boss等待
    while IsValid(boss) do
        task.Wait(1)
    end
end
