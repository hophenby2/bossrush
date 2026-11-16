------- 东方栖霞园一面boss 蕾米莉亚 定义

local path = EISlib.stage.path.."stage1/spellcard/"
local card_file_names = { --测试用表
    path.."normal_1.lua", path.."spell_1.lua",
    path.."normal_2.lua", path.."spell_2.lua",
    path.."spell_3.lua",
}
--创建boss
local bossRes = lstg.DoFile(EISlib.BossDefinition.path.."Remilia.lua")
local function createBoss(difficulty)
    local boss = EGGlib.BossCard.createFullCardBoss(
            "s1boss",
            bossRes,
            difficulty, --难度
            card_file_names --符卡文件目录表
    )
    return boss
end
return createBoss