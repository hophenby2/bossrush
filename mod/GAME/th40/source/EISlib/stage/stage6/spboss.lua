------- 东方栖霞园六面boss  定义

local sc_6_ = "spell_6.lua"
if config.final_war_machine then
    sc_6_ = "spell_6_last.lua"
end

local path = EISlib.stage.path.."stage6/spellcard/"
local card_file_names = { --符卡综合表
    path.."spell_5.lua", path.."normal_4.lua",
    path..sc_6_
}

--[[local card_file_names = { --符卡综合表
    path.."spell_6.lua"
}]]

--创建boss
local function createBoss(difficulty)
    local boss = EGGlib.BossCard.createFullCardBoss(
            "s6spboss",
            lstg.DoFile(EISlib.BossDefinition.path.."Sonia.lua"),
            difficulty, --难度
            card_file_names, --符卡文件目录表
            true --no_prac
    )
    return boss
end
return createBoss