--
s2_road = {}
-------------------------------------
local S = {}
EISlib.stage.stage2 = S
local path = EISlib.stage.path.."stage2/"
local createBoss = lstg.DoFile(path.."boss.lua")  --读取创建boss函数
EISlib.stage.stage2.road = lstg.DoFile(path.."road.lua") --读取创建road的函数
local R = EISlib.stage.stage2.road
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
	dialog.scene.stage2_p2(function()
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
				AchievementReminder.unlock("nmnb_s2", "丛林之王Easy", "No Miss No Bomb通关Easy难度第2关")
			end,
			function()
				AchievementReminder.unlock("nmnb_s2", "丛林之王Easy", "No Miss No Bomb通关Easy难度第2关")
				AchievementReminder.unlock("nmnb_s2", "丛林之王Normal", "No Miss No Bomb通关Normal难度第2关")
			end,
			function()
				AchievementReminder.unlock("nmnb_s2", "丛林之王Easy", "No Miss No Bomb通关Easy难度第2关")
				AchievementReminder.unlock("nmnb_s2", "丛林之王Normal", "No Miss No Bomb通关Normal难度第2关")
				AchievementReminder.unlock("nmnb_s2", "丛林之王Hard", "No Miss No Bomb通关Hard难度第2关")
			end,
			function()
				AchievementReminder.unlock("nmnb_s2", "丛林之王Easy", "No Miss No Bomb通关Easy难度第2关")
				AchievementReminder.unlock("nmnb_s2", "丛林之王Normal", "No Miss No Bomb通关Normal难度第2关")
				AchievementReminder.unlock("nmnb_s2", "丛林之王Hard", "No Miss No Bomb通关Hard难度第2关")
				AchievementReminder.unlock("nmnb_s2", "丛林之王Lunatic", "No Miss No Bomb通关Lunatic难度第2关")
			end,
		})
		if achi_func then
			achi_func()
		end]]
		achievement.unlock("nmnb_s2", true, false) --AchievementReminder.unlock("nmnb_s2", "丛林之王", "No Miss No Bomb通关第2关")
	end
end
local function road(part_num)
	-- 资源预加载
	LoadMusicRecord("s2")
	LoadMusicRecord("s2_boss")
	dialog.utility.cacheResource("Stage2")
	boss.utility.cacheResource("s2midboss")
	boss.utility.cacheResource("s2boss")
	-- 关卡
	lstg.tmpvar.current_road = R --绑定当前道中对象
	if part_num and part_num >= 1 and part_num <= 5 then --在范围内的输入
		--init
		R.INIT(part_num)
		if part_num == 1 then
			R.FIRST(true)
			R.SECOND(false)
			R.THIRD(false)
			R.FOURTH(false)
			bossMain()
		elseif part_num == 2 then
			R.SECOND(true)
			R.THIRD(false)
			R.FOURTH(false)
			bossMain()
		elseif part_num == 3 then
			R.THIRD(true)
			R.FOURTH(false)
			bossMain()
		elseif part_num == 4 then
			R.FOURTH(true)
			bossMain()
		elseif part_num == 5 then
			bossMain()
		end
	else --其他输入就是默认全关
		--init
		R.INIT()
		EISlib.stage.addStoryScoreAchievementListener() -- 分数成就检测器
		--main
		R.FIRST(false)
		R.SECOND(false)
		R.THIRD(false)
		R.FOURTH(false)
		bossMain()
		noMissNoBombAchievement()
	end
	task.Wait(180)
	system.makeSettlement(2)
end
s2_road.main = road
--midboss在road里定义
s2_road.boss = bossMain
