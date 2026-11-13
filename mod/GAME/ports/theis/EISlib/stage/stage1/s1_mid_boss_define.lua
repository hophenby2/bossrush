--组件定义
do
	_editor_class["s1_mid_boss_e1"] = Class(enemy)
	_editor_class["s1_mid_boss_e1"].init = function(self, _x, _y, _u, co)
		self.x, self.y = _x, _y
		task.New(self, function()
			self.protect = true
			task.Wait(1)
			self.protect = false
		end)
		local u = _u
		local st = { 9, 11 }
		enemy.init(self, st[co], 500, false, true, false, true, co, 100, 10, true)
		task.New(self, function()
			do
				for _ = 1, 300 do
					self.hp = self.maxhp
					task._Wait(1)
				end
			end
		end)
		task.New(self, function()
			task.MoveTo(100 * u, 120, 180, MOVE_ACC_DEC)
			task._Wait(120)
			if (IsValid(_boss)) then
				_connect(_boss, self, 0.5, false)
			end
			if (difficulty == 4) then
				do
					local a0, _d_a0 = (90 + 90 * u), (12 * u)
					for _ = 1, _infinite do
						do
							local a, _d_a = (a0), (30)
							for _ = 1, 12 do
								egg.SimAngChV(stg.newBulletStraight(stg.arrow_big, 6, true, self.x, self.y, 2, a), nil, nil, 60 * u, 120, true)
								egg.SimAngChV(stg.newBulletStraight(stg.arrow_big, 4, true, self.x, self.y, 1.5, a), nil, nil, 300 * u, 180, true)
								a = a + _d_a
							end
						end
						task._Wait(30)
						a0 = a0 + _d_a0
					end
				end
			elseif (difficulty == 3) then
				do
					local a0, _d_a0 = (90 + 90 * u), (15 * u)
					for _ = 1, _infinite do
						do
							local a, _d_a = (a0), (36)
							for _ = 1, 10 do
								egg.SimAngChV(stg.newBulletStraight(stg.arrow_big, 8, true, self.x, self.y, 1.75, a), nil, nil, 60 * u, 120, true)
								egg.SimAngChV(stg.newBulletStraight(stg.arrow_big, 10, true, self.x, self.y, 1.25, a), nil, nil, 300 * u, 180, true)
								a = a + _d_a
							end
						end
						task._Wait(40)
						a0 = a0 + _d_a0
					end
				end
			elseif (difficulty == 2) then
				do
					local a0, _d_a0 = (90 + 90 * u), (15 * u)
					for _ = 1, _infinite do
						do
							local a, _d_a = (a0), (30)
							for _ = 1, 12 do
								egg.SimAngChV(stg.newBulletStraight(stg.arrow_big, 8, true, self.x, self.y, 1.25, a), nil, nil, 300 * u, 180, true)
								a = a + _d_a
							end
						end
						task._Wait(50)
						a0 = a0 + _d_a0
					end
				end
			elseif (difficulty == 1) then
				do
					local a0, _d_a0 = (90 + 90 * u), (15 * u)
					for _ = 1, _infinite do
						do
							local a, _d_a = (a0), (30)
							for _ = 1, 12 do
								egg.SimAngChV(stg.newBulletStraight(stg.arrow_big, 10, true, self.x, self.y, 1, a), nil, nil, 720 * u, 360, true)
								a = a + _d_a
							end
						end
						task._Wait(60)
						a0 = a0 + _d_a0
					end
				end
			end
		end)
	end
	_editor_class["s1_mid_boss_e1"].frame = function(self)
		self.class.base.frame(self)
		if self.timer >= 130 and not IsValid(_boss) or self.timer > 1300 then
			self.vy = self.vy + 0.05
		end
	end
	_editor_class["s1_mid_boss_b1"] = Class(bullet)
	_editor_class["s1_mid_boss_b1"].init = function(self, _x, _y, a0, mode)
		bullet.init(self, ball_big, COLOR_DEEP_PURPLE, true, true)
		self.x, self.y = _x, _y
		self.hscale, self.vscale = 0.5, 0.5
		lasttask = task.New(self, function()
			AddSimStrChV(self, 4, 1, a0, 40)
			task._Wait(40)
			local a, co
			if (mode == 1) then
				a = Angle(self, player)
				co = 4
			else
				a = a0
				co = 1
			end
			if (difficulty == 4) then
				do
					local dv1, _d_dv1 = (0), (1)
					local dv2, _d_dv2 = (0), (0.25)
					for _ = 1, 5 do
						egg.AddSimStrChV(stg.newBulletStraight(stg.arrow_small, co, true, self.x, self.y, 0, a), 5 - dv1, 1 + dv2, a, 70)
						dv1 = dv1 + _d_dv1
						dv2 = dv2 + _d_dv2
					end
				end
				_del(self, true)
			elseif (difficulty == 3) then
				do
					local dv1, _d_dv1 = (0), (1)
					local dv2, _d_dv2 = (0), (0.25)
					for _ = 1, 4 do
						egg.AddSimStrChV(stg.newBulletStraight(stg.arrow_small, co, true, self.x, self.y, 0, a), 4 - dv1, 1 + dv2, a, 70)
						dv1 = dv1 + _d_dv1
						dv2 = dv2 + _d_dv2
					end
				end
				_del(self, true)
			elseif (difficulty == 2) then
				do
					local dv1, _d_dv1 = (0), (1)
					local dv2, _d_dv2 = (0), (0.25)
					for _ = 1, 2 do
						egg.AddSimStrChV(stg.newBulletStraight(stg.arrow_small, co, true, self.x, self.y, 0, a), 3 - dv1, 1 + dv2, a, 70)
						dv1 = dv1 + _d_dv1
						dv2 = dv2 + _d_dv2
					end
				end
				_del(self, true)
			elseif (difficulty == 1) then
				egg.AddSimStrChV(stg.newBulletStraight(stg.arrow_small, co, true, self.x, self.y, 0, a), 2, 1, a, 70)
				_del(self, true)
			end
		end)
	end
end

local function common_action_before(boss_class)
	local _tmp_sc = boss.dialog.New(true)
	function _tmp_sc:init()
		player.dialog = false
		self.dialog_displayer = New(dialog_displayer)
		self._dialog_maintask = task.New(self, function()
			self.killflag = 0
			self.hscale = 1.25
			self.vscale = 1.25
			last = New(_editor_class["s1_mid_boss_e1"], -100, 250, -1, 1)
			last = New(_editor_class["s1_mid_boss_e1"], 100, 250, 1, 2)
			task._Wait(120)
		end)
	end
	table.insert(boss_class.cards, _tmp_sc)
end

local function common_action_after(boss_class)
	local _tmp_sc
	-- 逃逸
	_tmp_sc = boss.dialog.New(true)
	function _tmp_sc:init()
		player.dialog = false
		self.dialog_displayer = New(dialog_displayer)
		self._dialog_maintask = task.New(self, function()
			if (self.killflag == 0) then
				_del(self, true)
			end
			task._Wait(60)
			task.MoveTo(self.y, 300, 120, MOVE_ACCEL)
			_del(self, true)
		end)
	end
	table.insert(boss_class.cards, _tmp_sc)
	-- 防止boss突然去世
	_tmp_sc = boss.card.New("", 2, 15, 60, 600, { 0, 0, 0 }, false)
	function _tmp_sc:init()
	end
	function _tmp_sc:del()
	end
	_tmp_sc.perform = false
	table.insert(boss_class.cards, _tmp_sc)
end

--Easy
do
	local stage1mid_boss = Class(boss)
	_editor_class["stage1mid_boss:Easy"] = stage1mid_boss
	stage1mid_boss.cards = {}
	stage1mid_boss.name = "Egg"
	stage1mid_boss.init = function(self, cards)
		boss.init(self, 0, 384, "Egg", cards, New(spellcard_background), "Easy")
		lstg.wis.Mid_Fairy(self)
	end
	stage1mid_boss.bgm = "s1_boss"
	stage1mid_boss._bg = stage1bg_background
	stage1mid_boss.difficulty = "Easy"

	common_action_before(stage1mid_boss)

	_tmp_sc = boss.card.New("", 2, 2, 21, 800, { 0, 30, 0 }, false)
	function _tmp_sc:init()
		lasttask = task.New(self, function()
			task._Wait(1260)
			self.killflag = 1
		end)
		lasttask = task.New(self, function()
			--self.a, self.b = 20, 20
			task.MoveTo(0, 144, 120, MOVE_DECEL)
			local a0, da, u = -30, -120 / 5, 1
			do
				task._Wait(1)
				boss.show_aura(self, true)
				task._Wait(30)
			end
			do
				local i, _d_i = (1), (1)
				for _ = 1, _infinite do
					do
						for _ = 1, 5 do
							last = New(_editor_class["s1_mid_boss_b1"], self.x, self.y, a0, 1)
							a0 = a0 + da * u
							task._Wait(16)
						end
					end
					lasttask = task.New(self, function()
						task.MoveToPlayer(60, -96, 96, 135, 155, 10, 20, 8, 16, MOVE_NORMAL, MOVE_TOWARDS_PLAYER)
					end)
					u = -u
					i = i + _d_i
				end
			end
		end)
	end
	function _tmp_sc:del()
		if (self.killflag == 0) then
			--item.DropItem(self.x, self.y, { 0, 0, 10 }, true)
			New(boss_death_ef, self.x, self.y)
			_boss = nil
			_del(self, true)
		end
	end
	_tmp_sc.perform = false
	table.insert(stage1mid_boss.cards, _tmp_sc)

	common_action_after(stage1mid_boss)
end

--Normal
do
	local stage1mid_boss = Class(boss)
	_editor_class["stage1mid_boss:Normal"] = stage1mid_boss
	stage1mid_boss.cards = {}
	stage1mid_boss.name = "Egg"
	stage1mid_boss.init = function(self, cards)
		boss.init(self, 0, 384, "Egg", cards, New(spellcard_background), "Normal")
		lstg.wis.Mid_Fairy(self)
	end
	stage1mid_boss.bgm = "s1_boss"
	stage1mid_boss._bg = stage1bg_background
	stage1mid_boss.difficulty = "Normal"

	common_action_before(stage1mid_boss)

	_tmp_sc = boss.card.New("", 2, 2, 21, 800, { 0, 30, 0 }, false)
	function _tmp_sc:init()
		lasttask = task.New(self, function()
			task._Wait(1260)
			self.killflag = 1
		end)
		lasttask = task.New(self, function()
			--self.a, self.b = 20, 20
			task.MoveTo(0, 144, 120, MOVE_DECEL)
			local a0, da, u = -30, -120 / 5, 1
			do
				task._Wait(1)
				boss.show_aura(self, true)
				task._Wait(30)
			end
			do
				local i, _d_i = (1), (1)
				for _ = 1, _infinite do
					do
						for _ = 1, 5 do
							last = New(_editor_class["s1_mid_boss_b1"], self.x, self.y, a0, i % 3)
							a0 = a0 + da * u
							task._Wait(15)
						end
					end
					lasttask = task.New(self, function()
						task.MoveToPlayer(60, -96, 96, 135, 155, 10, 20, 8, 16, MOVE_NORMAL, MOVE_TOWARDS_PLAYER)
					end)
					u = -u
					i = i + _d_i
				end
			end
		end)
	end
	function _tmp_sc:del()
		if (self.killflag == 0) then
			--item.DropItem(self.x, self.y, { 0, 0, 10 }, true)
			New(boss_death_ef, self.x, self.y)
			_boss = nil
			_del(self, true)
		end
	end
	_tmp_sc.perform = false
	table.insert(stage1mid_boss.cards, _tmp_sc)

	common_action_after(stage1mid_boss)
end

--Hard
do
	local stage1mid_boss = Class(boss)
	_editor_class["stage1mid_boss:Hard"] = stage1mid_boss
	stage1mid_boss.cards = {}
	stage1mid_boss.name = "Egg"
	stage1mid_boss.init = function(self, cards)
		boss.init(self, 0, 384, "Egg", cards, New(spellcard_background), "Hard")
		lstg.wis.Mid_Fairy(self)
	end
	stage1mid_boss.bgm = "s1_boss"
	stage1mid_boss._bg = stage1bg_background
	stage1mid_boss.difficulty = "Hard"

	common_action_before(stage1mid_boss)

	_tmp_sc = boss.card.New("", 2, 2, 21, 800, { 0, 30, 0 }, false)
	function _tmp_sc:init()
		lasttask = task.New(self, function()
			task._Wait(1260)
			self.killflag = 1
		end)
		lasttask = task.New(self, function()
			--self.a, self.b = 20, 20
			task.MoveTo(0, 144, 120, MOVE_DECEL)
			local a0, da, u = -30, -120 / 7, 1
			do
				task._Wait(1)
				boss.show_aura(self, true)
				task._Wait(30)
			end
			do
				local i, _d_i = (1), (1)
				for _ = 1, _infinite do
					do
						for _ = 1, 7 do
							last = New(_editor_class["s1_mid_boss_b1"], self.x, self.y, a0, i % 2)
							a0 = a0 + da * u
							task._Wait(12)
						end
					end
					lasttask = task.New(self, function()
						task.MoveToPlayer(60, -96, 96, 135, 155, 10, 20, 8, 16, MOVE_NORMAL, MOVE_TOWARDS_PLAYER)
					end)
					u = -u
					i = i + _d_i
				end
			end
		end)
	end
	function _tmp_sc:del()
		if (self.killflag == 0) then
			--item.DropItem(self.x, self.y, { 0, 0, 10 }, true)
			New(boss_death_ef, self.x, self.y)
			_boss = nil
			_del(self, true)
		end
	end
	_tmp_sc.perform = false
	table.insert(stage1mid_boss.cards, _tmp_sc)

	common_action_after(stage1mid_boss)
end

--Lunatic
do
	local stage1mid_boss = Class(boss)
	_editor_class["stage1mid_boss:Lunatic"] = stage1mid_boss
	stage1mid_boss.cards = {}
	stage1mid_boss.name = "Egg"
	stage1mid_boss.init = function(self, cards)
		boss.init(self, 0, 384, "Egg", cards, New(spellcard_background), "Lunatic")
		lstg.wis.Mid_Fairy(self)
	end
	stage1mid_boss.bgm = "s1_boss"
	stage1mid_boss._bg = stage1bg_background
	stage1mid_boss.difficulty = "Lunatic"

	common_action_before(stage1mid_boss)

	_tmp_sc = boss.card.New("", 2, 2, 21, 800, { 0, 30, 0 }, false)
	function _tmp_sc:init()
		lasttask = task.New(self, function()
			task._Wait(1260)
			self.killflag = 1
		end)
		lasttask = task.New(self, function()
			--self.a, self.b = 20, 20
			task.MoveTo(0, 144, 120, MOVE_DECEL)
			local a0, da, u = -30, -120 / 9, 1
			do
				task._Wait(1)
				boss.show_aura(self, true)
				task._Wait(30)
			end
			do
				local i, _d_i = (1), (1)
				for _ = 1, _infinite do
					do
						for _ = 1, 9 do
							last = New(_editor_class["s1_mid_boss_b1"], self.x, self.y, a0, i % 2)
							a0 = a0 + da * u
							task._Wait(8)
						end
					end
					lasttask = task.New(self, function()
						task.MoveToPlayer(60, -96, 96, 135, 155, 10, 20, 8, 16, MOVE_NORMAL, MOVE_TOWARDS_PLAYER)
					end)
					u = -u
					i = i + _d_i
				end
			end
		end)
	end
	function _tmp_sc:del()
		if (self.killflag == 0) then
			New(boss_death_ef, self.x, self.y)
			_boss = nil
			_del(self, true)
		end
	end
	_tmp_sc.perform = false
	table.insert(stage1mid_boss.cards, _tmp_sc)

	common_action_after(stage1mid_boss)
end

function s1_mid_boss.main(diff)
	local boss
	diff = diff or difficulty
	if diff == 1 then
		boss = New(_editor_class["stage1mid_boss:Easy"], _editor_class["stage1mid_boss:Easy"].cards)
	elseif diff == 2 then
		boss = New(_editor_class["stage1mid_boss:Normal"], _editor_class["stage1mid_boss:Normal"].cards)
	elseif diff == 3 then
		boss = New(_editor_class["stage1mid_boss:Hard"], _editor_class["stage1mid_boss:Hard"].cards)
	elseif diff == 4 then
		boss = New(_editor_class["stage1mid_boss:Lunatic"], _editor_class["stage1mid_boss:Lunatic"].cards)
	end
	return boss
end
