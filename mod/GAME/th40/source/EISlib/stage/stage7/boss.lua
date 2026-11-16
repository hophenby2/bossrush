------- 东方栖霞园三面boss  定义

local path = EISlib.stage.path.."stage7/spellcard/"
local card_file_names = { --符卡综合表
    path.."normal_1.lua", path.."spell_1.lua",
    path.."normal_2.lua", path.."spell_2.lua",
    path.."normal_3.lua", path.."spell_3.lua",
    path.."normal_4.lua", path.."spell_4.lua",
    path.."normal_5.lua", path.."spell_5.lua",
    path.."normal_6.lua", path.."spell_6.lua",
    path.."normal_7.lua", path.."spell_7.lua",
    path.."normal_8.lua", path.."spell_8.lua",
    path.."spell_9.lua",  path.."spell_10.lua"
}
--[[local card_file_names = { --单卡测试表
    path.."spell_4.lua"
}]]
--创建boss
local function createBoss(difficulty)
    local boss = EGGlib.BossCard.createFullCardBoss(
            "s7boss",
            lstg.DoFile(EISlib.BossDefinition.path.."Gluttony.lua"),
            difficulty, --难度
            card_file_names --符卡文件目录表
    )
    return boss
end
return createBoss