------- 东方栖霞园一面道中boss 琪露诺 定义

local path = EISlib.stage.path.."stage1/spellcard/"
local card_file_names = { --测试用表
    path.."mid_normal_1.lua",
    path.."mid_spell_1.lua",
    path.."mid_escape_1.lua",
}
--创建boss
local function createBoss(difficulty)
    local boss = EGGlib.BossCard.createFullCardBoss(
            "s1midboss",
            lstg.DoFile(EISlib.BossDefinition.path.."Cirno.lua"),
            difficulty, --难度
            card_file_names --符卡文件目录表
    )
    return boss
end
return createBoss