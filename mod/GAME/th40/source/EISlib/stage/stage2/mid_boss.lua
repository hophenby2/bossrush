--
------- 东方栖霞园二面道中boss 定义

local path = EISlib.stage.path.."stage2/spellcard/"
local card_file_names = { --测试用表
    path.."mid_normal_1.lua",
    path.."mid_spell_1.lua",
    path.."mid_escape_1.lua",
}
--创建boss
local function createBoss(difficulty)
    local boss_res_ = lstg.DoFile(EISlib.BossDefinition.path.."Artemina.lua")
    boss_res_.bgm = "s2"
    local boss = EGGlib.BossCard.createFullCardBoss(
        "s2midboss",
        boss_res_,
        difficulty, --难度
        card_file_names --符卡文件目录表
    )
    return boss
end
return createBoss
