--
s1_road = {}
-------------------------------------
local S = {}
EISlib.stage.stage1 = S
local path = EISlib.stage.path.."stage1/"
local createBoss = lstg.DoFile(path.."boss.lua")  --读取创建boss函数
EISlib.stage.stage1.road = lstg.DoFile(path.."road.lua") --读取创建road的函数
local R = EISlib.stage.stage1.road
local bosses = {}
for diff = 1, 4 do
	bosses[diff] = createBoss(diff)
end
local function bossMain()
	local boss = New(bosses[difficulty])
	while IsValid(boss) do
		task.Wait(1)
	end
	system.PowerRank.pauseHyper() --从这里停止计时
	dialog.scene.stage1_p2(function()
		task.wait(120)
	end)
end

--导入其他包
local switch1 = EGGlib.Math.spSwitch1

----------------------------------道中本体-------------------------
local function noMissNoBombAchievement()
	if system.isNoMiss() and system.isNoBomb() then
		--[[local achi_func = switch1(difficulty, {
			function()
				AchievementReminder.unlock("nmnb_s1", "冰封王座Easy", "No Miss No Bomb通关Easy难度第1关")
			end,
			function()
				AchievementReminder.unlock("nmnb_s1", "冰封王座Easy", "No Miss No Bomb通关Easy难度第1关")
				AchievementReminder.unlock("nmnb_s1", "冰封王座Normal", "No Miss No Bomb通关Normal难度第1关")
			end,
			function()
				AchievementReminder.unlock("nmnb_s1", "冰封王座Easy", "No Miss No Bomb通关Easy难度第1关")
				AchievementReminder.unlock("nmnb_s1", "冰封王座Normal", "No Miss No Bomb通关Normal难度第1关")
				AchievementReminder.unlock("nmnb_s1", "冰封王座Hard", "No Miss No Bomb通关Hard难度第1关")
			end,
			function()
				AchievementReminder.unlock("nmnb_s1", "冰封王座Easy", "No Miss No Bomb通关Easy难度第1关")
				AchievementReminder.unlock("nmnb_s1", "冰封王座Normal", "No Miss No Bomb通关Normal难度第1关")
				AchievementReminder.unlock("nmnb_s1", "冰封王座Hard", "No Miss No Bomb通关Hard难度第1关")
				AchievementReminder.unlock("nmnb_s1", "冰封王座Lunatic", "No Miss No Bomb通关Lunatic难度第1关")
			end,
		})
		if achi_func then
			achi_func()
		end]]
		achievement.unlock("nmnb_s1", true, false) --AchievementReminder.unlock("nmnb_s1", "冰封王座", "No Miss No Bomb通关第1关")
	end
end
local function road(part_num)
	-- 资源预加载
	LoadMusicRecord("s1")
	LoadMusicRecord("s1_boss")
	dialog.utility.cacheResource("Stage1")
	boss.utility.cacheResource("s1midboss")
	boss.utility.cacheResource("s1boss")
	-- 关卡
	lstg.tmpvar.current_road = R --绑定当前道中对象
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
			noMissNoBombAchievement()
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
	else --其他输入就是默认全关
		--第一次启动主线游戏时
		achievement.unlock("start_game", true, true)
		--init
		R.INIT()
		EISlib.stage.addStoryScoreAchievementListener() -- 分数成就检测器
		--main
		R.FIRST(false)
		R.SECOND(false)
		R.THIRD(false)
		R.FOURTH(false)
		R.FIFTH(false)
		bossMain()
		noMissNoBombAchievement()
	end
	task.Wait(180)
	system.makeSettlement(1)
end
s1_road.main = road
--道中boss在road里定义
s1_road.boss = bossMain
