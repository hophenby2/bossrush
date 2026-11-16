------- 东方栖霞园五面boss  定义

local path = EISlib.stage.path.."stage5/spellcard/"
local card_file_names = { --符卡综合表
    path.."normal_1.lua", path.."spell_1.lua",
    path.."normal_2.lua", path.."spell_2.lua",
    path.."normal_3.lua", path.."spell_3.lua",
    path.."normal_4.lua", path.."spell_4.lua"
}
--[[local card_file_names = { --单卡测试表
    path.."spell_4.lua"
}]]
--创建boss
local function createBoss(difficulty)
    local boss = EGGlib.BossCard.createFullCardBoss(
            "s5boss",
            lstg.DoFile(EISlib.BossDefinition.path.."Lycaropia.lua"),
            difficulty, --难度
            card_file_names --符卡文件目录表
    )
    return boss
end
return createBoss