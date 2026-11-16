--
s6_road = {}
-------------------------------------
local S = {}
EISlib.stage.stage6 = S
local path = EISlib.stage.path.."stage6/"
local createBoss = lstg.DoFile(path.."boss.lua")  --读取创建boss函数
EISlib.stage.stage6.road = lstg.DoFile(path.."road.lua") --读取创建road的函数
local R = EISlib.stage.stage6.road
local bosses = {}
for diff = 1, 4 do
	bosses[diff] = createBoss(diff)
end
local function bossMain()
	local boss = New(bosses[difficulty])
	while IsValid(boss) do
		task.Wait(1)
	end
	system.PowerRank.resumeHyper()
	system.PowerRank.hyperNormalEnd(player)
	task.Wait(120)
end

local createSpBoss = lstg.DoFile(path.."spboss.lua")  --读取创建boss函数
local spBosses = {}
for diff = 1, 4 do
	spBosses[diff] = createSpBoss(diff)
end
local function spBossMain()
	local boss = New(spBosses[difficulty])
	while IsValid(boss) do
		task.Wait(1)
	end
	system.PowerRank.closeInfiniteHyperMode()
	system.PowerRank.hyperNormalEnd(player)
	task.Wait(120)
end

--导入其他包
local switch1 = EGGlib.Math.spSwitch1

----------------------------------道中本体-------------------------
--单关nmnb
local function singleNoMissNoBombAchievement()
	if system.isNoMiss() and system.isNoBomb() then
		--[[local achi_func = switch1(difficulty, {
			function()
				AchievementReminder.unlock("nmnb_s6", "山之国，河之国Easy", "No Miss No Bomb通关Easy难度第6关")
			end,
			function()
				AchievementReminder.unlock("nmnb_s6", "山之国，河之国Easy", "No Miss No Bomb通关Easy难度第6关")
				AchievementReminder.unlock("nmnb_s6", "山之国，河之国Normal", "No Miss No Bomb通关Normal难度第6关")
			end,
			function()
				AchievementReminder.unlock("nmnb_s6", "山之国，河之国Easy", "No Miss No Bomb通关Easy难度第6关")
				AchievementReminder.unlock("nmnb_s6", "山之国，河之国Normal", "No Miss No Bomb通关Normal难度第6关")
				AchievementReminder.unlock("nmnb_s6", "山之国，河之国Hard", "No Miss No Bomb通关Hard难度第6关")
			end,
			function()
				AchievementReminder.unlock("nmnb_s6", "山之国，河之国Easy", "No Miss No Bomb通关Easy难度第6关")
				AchievementReminder.unlock("nmnb_s6", "山之国，河之国Normal", "No Miss No Bomb通关Normal难度第6关")
				AchievementReminder.unlock("nmnb_s6", "山之国，河之国Hard", "No Miss No Bomb通关Hard难度第6关")
				AchievementReminder.unlock("nmnb_s6", "山之国，河之国Lunatic", "No Miss No Bomb通关Lunatic难度第6关")
			end,
		})
		if achi_func then
			achi_func()
		end]]
		achievement.unlock("nmnb_s6", true, false) --AchievementReminder.unlock("nmnb_s6", "山之国，河之国", "No Miss No Bomb通关第6关")
	end
end

--全关nmnb
local function totalNoMissNoBombAchievement()
	if system.isNoMiss() and system.isNoBomb() then
		--[[local achi_func = switch1(difficulty, {
			function()
				AchievementReminder.unlock("nmnb_all", "栖霞的神话Easy", "No Miss No Bomb通关Easy难度正篇模式")
			end,
			function()
				AchievementReminder.unlock("nmnb_all", "栖霞的神话Easy", "No Miss No Bomb通关Easy难度正篇模式")
				AchievementReminder.unlock("nmnb_all", "栖霞的神话Normal", "No Miss No Bomb通关Normal难度正篇模式")
			end,
			function()
				AchievementReminder.unlock("nmnb_all", "栖霞的神话Easy", "No Miss No Bomb通关Easy难度正篇模式")
				AchievementReminder.unlock("nmnb_all", "栖霞的神话Normal", "No Miss No Bomb通关Normal难度正篇模式")
				AchievementReminder.unlock("nmnb_all", "栖霞的神话Hard", "No Miss No Bomb通关Hard难度正篇模式")
			end,
			function()
				AchievementReminder.unlock("nmnb_all", "栖霞的神话Easy", "No Miss No Bomb通关Easy难度正篇模式")
				AchievementReminder.unlock("nmnb_all", "栖霞的神话Normal", "No Miss No Bomb通关Normal难度正篇模式")
				AchievementReminder.unlock("nmnb_all", "栖霞的神话Hard", "No Miss No Bomb通关Hard难度正篇模式")
				AchievementReminder.unlock("nmnb_all", "神话幻想", "No Miss No Bomb通关Lunatic难度正篇模式") -- nmnb_lunatic
			end,
		})
		if achi_func then
			achi_func()
		end]]
		if difficulty == 4 then
			achievement.unlock("nmnb_lunatic", false, false) -- AchievementReminder.unlock("nmnb_lunatic", "神话幻想", "No Miss No Bomb通关Lunatic难度正篇模式")
		end
		achievement.unlock("nmnb_all", false, false)
	end
end

--难度id
local story_group_name = {
	"Easy",
	"Normal",
	"Hard",
	"Lunatic",
	"Ultra",
}

local function road(part_num)
	-- 资源预加载
	LoadMusicRecord("s6")
	LoadMusicRecord("s6_boss")
	dialog.utility.cacheResource("Stage6")
	dialog.utility.cacheResource("Stage6spell")
	boss.utility.cacheResource("s6boss")
	boss.utility.cacheResource("s6spboss")
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
			bossMain()
			singleNoMissNoBombAchievement() --单关nmnb
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
		elseif part_num == 6 then
			spBossMain()
		end
		task.Wait(180)
		system.makeSettlement(6, true)
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
		
		-- 通关相关
		local diff = system.getDifficulty()
		if lstg.var.coun_num <= 0 then
			local achi_func = switch1(difficulty, {
				function()
					--AchievementReminder.unlock("easy", "国家级过家家", "无续关通关Easy难度")
					achievement.unlock2("easy")
				end,
				function()
					--AchievementReminder.unlock("easy", "国家级过家家", "无续关通关Easy难度")
					--AchievementReminder.unlock("normal", "绯红帝国", "无续关通关Normal难度")
					achievement.unlock2("easy", false, false, true) -- 这个不用显示
					achievement.unlock2("normal")
				end,
				function()
					--AchievementReminder.unlock("easy", "国家级过家家", "无续关通关Easy难度")
					--AchievementReminder.unlock("normal", "绯红帝国", "无续关通关Normal难度")
					--AchievementReminder.unlock("hard", "吸血鬼战争", "无续关通关Hard难度")
					achievement.unlock2("easy", false, false, true) -- 这个不用显示
					achievement.unlock2("normal", false, false, true) -- 这个不用显示
					achievement.unlock2("hard")
				end,
				function()
					--AchievementReminder.unlock("easy", "国家级过家家", "无续关通关Easy难度")
					--AchievementReminder.unlock("normal", "绯红帝国", "无续关通关Normal难度")
					--AchievementReminder.unlock("hard", "吸血鬼战争", "无续关通关Hard难度")
					--AchievementReminder.unlock("lunatic", "王国宪政", "无续关通关Lunatic难度")
					achievement.unlock2("easy", false, false, true) -- 这个不用显示
					achievement.unlock2("normal", false, false, true) -- 这个不用显示
					achievement.unlock2("hard", false, false, true) -- 这个不用显示
					achievement.unlock2("lunatic")
				end,
			})
			if achi_func then
				achi_func()
			end
			--no miss通关
			if system.isNoMiss() then
				local achi_func = switch1(difficulty, {
					function()
						--AchievementReminder.unlock("nm_easy", "手撕恶魔", "No Miss通关Easy难度")
						achievement.unlock2("nm_easy")
					end,
					function()
						--AchievementReminder.unlock("nm_easy", "手撕恶魔", "No Miss通关Easy难度")
						--AchievementReminder.unlock("nm_normal", "恶魔猎手", "No Miss通关Normal难度")
						achievement.unlock2("nm_easy", false, false, true) -- 这个不用显示
						achievement.unlock2("nm_normal")
					end,
					function()
						--AchievementReminder.unlock("nm_easy", "手撕恶魔", "No Miss通关Easy难度")
						--AchievementReminder.unlock("nm_normal", "恶魔猎手", "No Miss通关Normal难度")
						--AchievementReminder.unlock("nm_hard", "恶魔畏惧之人", "No Miss通关Hard难度")
						achievement.unlock2("nm_easy", false, false, true) -- 这个不用显示
						achievement.unlock2("nm_normal", false, false, true) -- 这个不用显示
						achievement.unlock2("nm_hard")
					end,
					function()
						--AchievementReminder.unlock("nm_easy", "手撕恶魔", "No Miss通关Easy难度")
						--AchievementReminder.unlock("nm_normal", "恶魔猎手", "No Miss通关Normal难度")
						--AchievementReminder.unlock("nm_hard", "恶魔畏惧之人", "No Miss通关Hard难度")
						--AchievementReminder.unlock("nm_lunatic", "天使降临", "No Miss通关Lunatic难度")
						achievement.unlock2("nm_easy", false, false, true) -- 这个不用显示
						achievement.unlock2("nm_normal", false, false, true) -- 这个不用显示
						achievement.unlock2("nm_hard", false, false, true) -- 这个不用显示
						achievement.unlock2("nm_lunatic")
					end,
				})
				if achi_func then
					achi_func()
				end
			end
		end
		singleNoMissNoBombAchievement() --单关nmnb
		totalNoMissNoBombAchievement() --全关nmnb
		system.record.setPlayerClearGroup(story_group_name[diff]) -- 通关
		system.record.unlockGroup(story_group_name[diff + 1]) -- 向上解锁
		system.record.unlockExtra() -- 都能解锁
		
		task.Wait(180)
		
		-- 分数相关
		system.makeSettlement(6, true)
		system.record.markHighScore(nil, nil, nil, true) -- 记录最高分
	end
end
s6_road.main = road
s6_road.boss = bossMain
s6_road.spBoss = spBossMain
