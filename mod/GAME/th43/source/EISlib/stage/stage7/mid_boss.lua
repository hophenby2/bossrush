--
------- 东方栖霞园ex面道中boss 定义

local path = EISlib.stage.path.."stage7/spellcard/"
local card_file_names = { --测试用表
    path.."mid_spell_1.lua",
    path.."mid_spell_2.lua",
    path.."mid_spell_3.lua"
}
--test
--[[local card_file_names = { --测试用表
    path.."mid_spell_2.lua"
}]]
--创建boss
local function createBoss(difficulty)
    local boss_res_ = lstg.DoFile(EISlib.BossDefinition.path.."Artemina.lua")
    boss_res_.bgm = "s7"
    local boss = EGGlib.BossCard.createFullCardBoss(
        "s7midboss",
        boss_res_, --是2boss
        difficulty, --难度
        card_file_names --符卡文件目录表
    )
    return boss
end
return createBoss
