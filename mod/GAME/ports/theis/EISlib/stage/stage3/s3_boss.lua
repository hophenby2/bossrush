
s3_boss = {}

local path = "EISlib/stage/stage3/"
Include(path .. "bossA/bossA.lua")
Include(path .. "bossB/bossB.lua")
Include(path .. "bossC/bossC.lua")

function s3_boss.load_res_main()
	if (theisRoutePlayer() == "theis_reimu_player") then
		LoadMusicRecord("s3_boss3") -- 竹林组 bgm
	elseif (theisRoutePlayer() == "theis_marisa_player") then
		LoadMusicRecord("s3_boss1") -- 永夜组 bgm
	else
		LoadMusicRecord("s3_boss2") -- 胖子组 bgm
	end
	dialog.cacheResource("Stage3")
	dialog.cacheResource("Stage3_after")
end

function s3_boss.mid1(self)
	local boss
	if (theisRoutePlayer() == "theis_marisa_player") then
		boss = s3B_boss.mid1()
	elseif (theisRoutePlayer() == "theis_reimu_player") then
		boss = s3A_boss.mid1()
	else
		boss = s3C_boss.mid1()
	end
	return boss
end

function s3_boss.mid2(self)
	local boss
	if (theisRoutePlayer() == "theis_marisa_player") then
		boss = s3B_boss.mid2()
	elseif (theisRoutePlayer() == "theis_reimu_player") then
		boss = s3A_boss.mid2()
	else
		boss = s3C_boss.mid2()
	end
	return boss
end

function s3_boss.main(self, nolscachi)
	if (theisRoutePlayer() == "theis_marisa_player") then
		s3B_boss.main()
	elseif (theisRoutePlayer() == "theis_reimu_player") then
		s3A_boss.main()
	else
		s3C_boss.main()
	end
	if system.checkChainAchieve() then
		task.Wait(180)
		if (theisRoutePlayer() == "theis_marisa_player") then
			if not nolscachi then
				--成就 解锁灵梦LSC (id:33)
				achievement.unlock("33", true)
			end
			LSC_eff(0, 0, 150, 0, 0, 'yukari_star', 'reimu_leaf')
			task.Wait(120)
			s3B_boss.LSC()
		elseif (theisRoutePlayer() == "theis_reimu_player") then
			if not nolscachi then
				--成就 解锁妹红LSC (id:35)
				achievement.unlock("35", true)
			end
			s3A_boss.LSC()
		else
			if not nolscachi then
				--成就 解锁魔理沙LSC (id:34)
				achievement.unlock("34", true)
			end
			LSC_eff(0, 0, 150, 150, 0, 'marisa_star', 'yuyuko_ghost')
			task.Wait(120)
			s3C_boss.LSC()
		end
	end
	if EISlib.stage.canDialog() then
		task.Wait(120)
		dialog.player.playScene("Stage3_after", true)
	end
end
