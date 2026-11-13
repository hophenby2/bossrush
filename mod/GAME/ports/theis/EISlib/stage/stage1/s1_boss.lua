--s1_boss = {}
--祈华梦一面boss定义
--规定boss名为 "stage"..(关卡数).."boss"..(难度名称)  (如 stage1boss:Lunatic）
--规定LSC的boss名为  "LSC"..(关卡数)..":"..(难度名称)
--因为编辑器原因，所以boss定义都必须是编辑器生成的对象，所以最终命名为 _editor_class["LSC1:Easy"] 这样

local path = "EISlib/stage/stage1/"

Include(path .. "Kaguya_boss.lua")
Include(path .. "Mid_fairy_boss.lua")

Include(path .. "s1_mid_boss_define.lua")
Include(path .. "s1_boss_define.lua")
Include(path .. "s1_boss_ls_define.lua")
