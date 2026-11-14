--
s7_road = {}
-------------------------------------
local S = {}
EISlib.stage.stage7 = S
local path = EISlib.stage.path.."stage7/"
local createBoss = lstg.DoFile(path.."boss.lua")  --读取创建boss函数
EISlib.stage.stage7.road = lstg.DoFile(path.."road.lua") --读取创建road的函数
local R = EISlib.stage.stage7.road
local bosses = {}
for diff = 5, 5 do
	bosses[diff] = createBoss(diff)
end
local function bossMain()
	local boss = New(bosses[difficulty])
	while IsValid(boss) do
		task.Wait(1)
	end
	system.PowerRank.closeInfiniteHyperMode()
	system.PowerRank.resumeHyper()
	system.PowerRank.hyperNormalEnd(player)
	task.Wait(180)
	dialog.scene.stage7_p2(function()
		task.Wait(120)
	end)
	task.Wait(60)
end

--导入其他包
local switch1 = EGGlib.Math.spSwitch1
----------------------------------道中本体-------------------------
--nmnb
local function noMissNoBombAchievement()
	if system.isNoMiss() and system.isNoBomb() then
		achievement.unlock("nmnb_extra", false, false) -- AchievementReminder.unlock("nmnb_extra", "被遗忘的神话", "No Miss No Bomb通关Extra模式")
	end
end

local function road(part_num)
	-- 资源预加载
	LoadMusicRecord("s7")
	LoadMusicRecord("s7_boss")
	dialog.utility.cacheResource("StageEXmid")
	dialog.utility.cacheResource("StageEX")
	boss.utility.cacheResource("s7midboss")
	boss.utility.cacheResource("s7boss")
	-- 关卡
	lstg.tmpvar.current_road = R --绑定当前道中对象
	--test
	if part_num and part_num >= 1 and part_num <= 6 then --在范围内的输入
		--init
		R.INIT(part_num)
		if part_num == 1 then
			R.FIRST(true)
			R.SECOND(false)
			R.THIRD(false)
			R.FOURTH(false)
			R.FIFTH(false)
			bossMain()
			--noMissNoBombAchievement()
		elseif part_num == 2 then
			R.SECOND(true)
			R.THIRD(false)
			R.FOURTH(false)
			R.FIFTH(false)
			bossMain()
		elseif part_num == 3 then
			R.THIRD(true)
			R.FOURTH(false)
			R.FIFTH(false)
			bossMain()
		elseif part_num == 4 then
			R.FOURTH(true)
			R.FIFTH(false)
			bossMain()
		elseif part_num == 5 then
			R.FIFTH(true)
			bossMain()
		elseif part_num == 6 then
			bossMain()
		end
		task.Wait(180)
		system.makeSettlement(7, true, 1.2)
	else --其他输入就是默认全关
		--第一次启动extra游戏时
		achievement.unlock("extra_start", true, true)
		--init
		R.INIT()
		EISlib.stage.addExtraScoreAchievementListener() -- 分数成就检测器
		--main
		R.FIRST(false)
		R.SECOND(false)
		R.THIRD(false)
		R.FOURTH(false)
		R.FIFTH(false)
		bossMain()
		
		-- 通关相关
		if lstg.var.coun_num <= 0 then
			if player.name == "reimu" then
				achievement.unlock("reimu_ex", false, false) --	AchievementReminder.unlock("reimu_ex", "幻想乡的守护者", "使用灵梦通关Extra模式")
			elseif player.name == "marisa" then
				achievement.unlock("marisa_ex", false, false) -- AchievementReminder.unlock("marisa_ex", "研究魔法的专家", "使用魔理沙通关Extra模式")
			elseif player.name == "sakuya" then
				achievement.unlock("sakuya_ex", false, false) -- AchievementReminder.unlock("sakuya_ex", "受命运眷顾之人", "使用咲夜通关Extra模式")
			end
			if system.isNoMiss() then
				achievement.unlock("nm_extra", false, false) -- AchievementReminder.unlock("nm_extra", "天堂之魔", "No Miss通关Extra模式")
			end
		end
		noMissNoBombAchievement()
		system.record.setPlayerClearGroup("Extra") -- 通关
		
		task.Wait(180)
		
		-- 分数相关
		system.makeSettlement(7, true, 1.2)
		system.record.markHighScore(nil, nil, nil, true) -- 记录最高分
	end
end

s7_road.main = road
s7_road.boss = bossMain
