--
------- 东方栖霞园三面道中boss 定义

local path = EISlib.stage.path.."stage3/spellcard/"
local card_file_names = { --测试用表
    path.."mid_escape_1.lua",
}
--创建boss
local function createBoss(difficulty)
    local boss = EGGlib.BossCard.createFullCardBoss(
            "s3midboss",
            lstg.DoFile(EISlib.BossDefinition.path.."Artemina.lua"), --是2boss
            difficulty, --难度
            card_file_names --符卡文件目录表
    )
    return boss
end
return createBoss