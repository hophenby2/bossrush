
--组件定义（现在没有用上）
--region
_editor_class["s3_mid2_b1"] = Class(bullet)
_editor_class["s3_mid2_b1"].init = function(self, _x, _y, dv, a, co)
	bullet.init(self, arrow_small, co, true, true)
	self.x, self.y = _x, _y
	if (difficulty == 4) then
		SetV2(self, 2 + dv, a, true, false)
		lasttask = task.New(self, function()
			task._Wait(60)
			AddSimStrChV(self, 0, 2 - dv, a, 180)
		end)
	elseif (difficulty == 3) then
		SetV2(self, 1.75 + dv, a, true, false)
		lasttask = task.New(self, function()
			task._Wait(60)
			AddSimStrChV(self, 0, 1.5 - dv, a, 180)
		end)
	end
end
_editor_class["s3_mid2_b2"] = Class(bullet)
_editor_class["s3_mid2_b2"].init = function(self, _x, _y, a, co)
	bullet.init(self, ball_mid, co, true, true)
	self.x, self.y = _x, _y
	if (difficulty == 4) then
		SetV2(self, 2, a, true, false)
		AddSimStrChV(self, 0, -2, a, 300)
		lasttask = task.New(self, function()
			task._Wait(60)
			AddSimStrChV(self, 0, 2, Angle(self, player), 240)
		end)
	elseif (difficulty == 3) then
		SetV2(self, 2, a, true, false)
		AddSimStrChV(self, 0, -2, a, 300)
		lasttask = task.New(self, function()
			task._Wait(60)
			AddSimStrChV(self, 0, 2, a, 240)
		end)
	end
end
_editor_class["s3_mid2_magic1"] = Class(_object)
_editor_class["s3_mid2_magic1"].init = function(self, _x, _y, x, y, co)
	self.x, self.y = _x, _y
	self.img = "magic1"
	self.layer = LAYER_ENEMY_BULLET
	self.group = GROUP_GHOST
	self.hide = false
	self.bound = true
	self.navi = false
	self.hp = 10
	self.maxhp = 10
	self.colli = true
	self._servants = {}
	self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
	self.hscale, self.vscale = 0, 0
	SimSizeCh(self, 0, 1, 60)
	self.omiga = 1
	lasttask = task.New(self, function()
		task.MoveTo(x, y, 60, MOVE_NORMAL)
	end)
	if (difficulty == 4) then
		lasttask = task.New(self, function()
			task._Wait(60)
			local _a, a0 = nil, -90
			do
				for _ = 1, _infinite do
					if a0 > 0 then
						a0 = a0 - 60
					end
					_a = Angle(self, player)
					do
						local dv, _d_dv = (0), (0.2)
						for _ = 1, 15 do
							PlaySound("kira00", 0.5, 0, false)
							a0 = a0 + 1
							do
								local u1, _d_u1 = (0.5), (0.5)
								for _ = 1, 2 do
									do
										local u0, _d_u0 = (1), (-2)
										for _ = 1, 2 do
											last = New(_editor_class["s3_mid2_b1"], self.x, self.y, dv, _a + a0 * u0 * u1, co)
											u0 = u0 + _d_u0
										end
									end
									u1 = u1 + _d_u1
								end
							end
							task._Wait(2)
							dv = dv + _d_dv
						end
					end
					task._Wait(45)
				end
			end
		end)
	elseif (difficulty == 3) then
		lasttask = task.New(self, function()
			task._Wait(60)
			local _a, a0 = nil, -60
			do
				for _ = 1, _infinite do
					if a0 > 0 then
						a0 = a0 - 48
					end
					_a = Angle(self, player)
					do
						local dv, _d_dv = (0), (0.15)
						for _ = 1, 12 do
							PlaySound("kira00", 0.5, 0, false)
							a0 = a0 + 1
							do
								local u1, _d_u1 = (0.5), (0.5)
								for _ = 1, 2 do
									do
										local u0, _d_u0 = (1), (-2)
										for _ = 1, 2 do
											last = New(_editor_class["s3_mid2_b1"], self.x, self.y, dv, _a + a0 * u0 * u1, co)
											u0 = u0 + _d_u0
										end
									end
									u1 = u1 + _d_u1
								end
							end
							task._Wait(2)
							dv = dv + _d_dv
						end
					end
					task._Wait(60)
				end
			end
		end)
	end
end
_editor_class["s3_mid2_b3"] = Class(bullet)
_editor_class["s3_mid2_b3"].init = function(self, _x, _y, r, a, t, v, co)
	bullet.init(self, arrow_small, co, true, true)
	self.x, self.y = _x, _y
	self.navi = true
	lasttask = task.New(self, function()
		task.MoveTo(self.x + r * cos(a), self.y + r * sin(a), 60, MOVE_DECEL)
		task._Wait(t - 60)
		self.navi = true
		_set_a(self, 0.05 * v, -90 + ran:Float(-5, 5), false)
		_forbid_v(self, v, 'original', 'original')
	end)
end
_editor_class["s3_mid2_b4"] = Class(bullet)
_editor_class["s3_mid2_b4"].init = function(self, _x, _y, r, a, t, v)
	bullet.init(self, ball_mid, COLOR_BLUE, true, true)
	self.x, self.y = _x, _y
	self.navi = true
	lasttask = task.New(self, function()
		task.MoveTo(self.x + r * cos(a), self.y + r * sin(a), 60, MOVE_DECEL)
		task._Wait(t - 60)
		_set_a(self, 0.05 * v, Angle(self, player), false)
		_forbid_v(self, v, 'original', 'original')
	end)
end
_editor_class["s3_mid2_magic2"] = Class(_object)
_editor_class["s3_mid2_magic2"].init = function(self, _x, _y, x, y)
	self.x, self.y = _x, _y
	self.img = "magic2"
	self.layer = LAYER_ENEMY_BULLET - 1
	self.group = GROUP_GHOST
	self.hide = false
	self.bound = true
	self.navi = false
	self.hp = 10
	self.maxhp = 10
	self.colli = true
	self._servants = {}
	self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
	self.hscale, self.vscale = 0, 0
	SimSizeCh(self, 0, 1, 60)
	self.omiga = 1
	local i = sign(x)
	local co
	if i == -1 then
		co = 3
	else
		co = 14
	end
	if (difficulty == 2) then
		lasttask = task.New(self, function()
			task.MoveTo(x, y, 60, MOVE_DECEL)
			task._Wait(30)
			do
				for _ = 1, _infinite do
					do
						local a, _d_a = (ran:Float(0, 360)), (GOLD * i)
						local r, _d_r = (128), (-128 / 19)
						local time, _d_time = (100), (-5)
						for _ = 1, 20 do
							PlaySound("tan00", 0.1, self.x / 256, false)
							last = New(_editor_class["s3_mid2_b3"], self.x, self.y, r, a, time, 1.7 + ran:Float(-0.3, 0.3), co)
							task._Wait(5)
							a = a + _d_a
							r = r + _d_r
							time = time + _d_time
						end
					end
					task._Wait(100)
				end
			end
		end)
	elseif (difficulty == 1) then
		lasttask = task.New(self, function()
			task.MoveTo(x, y, 60, MOVE_DECEL)
			task._Wait(30)
			do
				for _ = 1, _infinite do
					do
						local a, _d_a = (ran:Float(0, 360)), (GOLD * i)
						local r, _d_r = (128), (-128 / 19)
						local time, _d_time = (100), (-10)
						for _ = 1, 10 do
							PlaySound("tan00", 0.1, self.x / 256, false)
							last = New(_editor_class["s3_mid2_b3"], self.x, self.y, r, a, time, 1.2 + ran:Float(-0.15, 0.15), co)
							task._Wait(10)
							a = a + _d_a
							r = r + _d_r
							time = time + _d_time
						end
					end
					task._Wait(200)
				end
			end
		end)
	end
end
--endregion

--妹红的蓄力特效
local function eff1(x, y, t)
	New(AbEff, x, y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
	if t then task.Wait(t) end
end
--符卡练习出场特效
local function boss_scpr_show1(self, x, y)
	for _ = 1, 3 do
		eff1(x, y, 20)
	end
	task.Wait(20)
	self.x, self.y = x, y
	boss.show_aura(self, true)
end

--慧音的蓄力特效
local function eff2(x, y, t)
	New(AbEff, x, y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
	if t then task.Wait(t) end
end
--符卡练习出场特效
local function boss_scpr_show2(self, x, y)
	for _ = 1, 3 do
		eff2(x, y, 20)
	end
	task.Wait(20)
	self.x, self.y = x, y
	boss.show_aura(self, true)
end

--common action
local function Mokou1_common1(boss_class)
	EISlib.stage.createDialogClass(boss_class, false, function(self)
		if ext.sc_pr then
			boss_scpr_show1(self, 0, 144)
		else
			task.Wait(30)
			task.MoveTo(0, 144, 60, MOVE_ACC_DEC)
			boss.show_aura(self, true)
		end
	end)
end
local function Mokou1_common2(boss_class)
	EISlib.stage.createDialogClass(boss_class, false, function(self)
		self.colli = false
		if not self.noExtendBonus then
			PlaySound("enep01", 0.5, 0, false)
			misc.ShakeScreen(30, 3)
			_drop_item(item_bomb, 1, self.x, self.y)
		end
		task._Wait(120)
		task.MoveTo(self.x, 300, 60, MOVE_ACCEL)
		_del(self, true)
	end)
	EISlib.stage.createCardClass(boss_class, "",
			{60, 60, 60}, 600, {0, 0, 0}, "normal", false, true)
end

local function Keine1_common1(boss_class)
	EISlib.stage.createDialogClass(boss_class, false, function(self)
		if ext.sc_pr then
			boss_scpr_show2(self, 0, 144)
		else
			task.Wait(30)
			task.MoveTo(0, 144, 60, MOVE_ACC_DEC)
			boss.show_aura(self, true)
		end
	end)
end
local function Keine1_common2(boss_class)
	EISlib.stage.createDialogClass(boss_class, false, function(self)
		self._wisys:setAction("normal", 9999)
		self.colli = false
		if not self.noExtendBonus then
			PlaySound("enep01", 0.5, 0, false)
			misc.ShakeScreen(30, 3)
			_drop_item(item_extend, 1, self.x, self.y)
		end
		task._Wait(120)
		task.MoveTo(self.x, 300, 90, MOVE_ACCEL)
		_del(self, true)
	end)
	EISlib.stage.createCardClass(boss_class, "",
			{60, 60, 60}, 600, {0, 0, 0}, "normal", false, true)
end

--Mokou
local function Mokou1_normal1_init_Easy(self)
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
			task._Wait(60)
		end
		local co = { 5, 3, 1 }
		local a, u, a0, r, dr, dv, dv0, u1 = 0, 1, 0, 60, -120 / 59, 0, 0, 1
		local _a, _da, _a0 = 0, 8
		local j = 0
		task._Wait(30)
		self._wisys:setAction("cast", 64)
		do
			for _ = 1, _infinite do
				do
					for _ = 1, 2 do
						a = 90 - 90 * u1
						r = 60
						dv0 = 0
						do
							for _ = 1, 2 do
								do
									for _ = 1, 15 do
										PlaySound("tan00", 0.1, 0, false)
										do
											for _ = 1, 3 do
												a0 = 0
												dv = 0
												do
													local i, _d_i = (1), (1)
													for _ = 1, 1 do
														last = New(_straight, square, co[i], self.x + r * cos(a), self.y + r * sin(a), 1.5 + dv0 + dv, a + a0, false, 0, true, true, 0, false, 0, 0, 0, false)
														a0 = a0 + 1.5 * u * u1
														dv = dv + 0.2
														i = i + _d_i
													end
												end
												a = a + 120
											end
										end
										dv0 = dv0 + 0.04
										a = a + 8 * u * u1
										r = r + dr
										task._Wait(4)
									end
								end
								u = -u
							end
						end
						u1 = -u1
						if true then
							_a = 0
							_da = 45
							dv = 0
							do
								for _ = 1, 3 do
									PlaySound("tan00", 0.5, 0, false)
									_a = _a + 45
									do
										for _ = 1, 8 do
											last = New(_straight, water_drop, COLOR_RED, self.x + 30 * cos(_a), self.y + 30 * sin(_a), 1.2 + dv, _a, false, 0, true, true, 0, false, 0, 0, 0, false)
											_a = _a + _da
										end
									end
									dv = dv + 0.3
									task._Wait(20)
								end
							end
						else
							_da = 20
							_a0 = Angle(self, player) - 0.5 * _da
							dv = 0
							do
								for _ = 1, 6 do
									PlaySound("tan00", 0.5, 0, false)
									_a = _a0
									do
										for _ = 1, 2 do
											last = New(_straight, grain_b, COLOR_RED, self.x + 30 * cos(_a), self.y + 30 * sin(_a), 0.8 + dv, _a, false, 0, true, true, 0, false, 0, 0, 0, false)
											_a = _a + _da
										end
									end
									dv = dv + 0.2
									task._Wait(6)
								end
							end
						end
						task.MoveToPlayer(40, -96, 96, 120, 154, 16, 32, 8, 16, MOVE_NORMAL, MOVE_X_TOWARDS_PLAYER)
						j = j + 1
					end
				end
				task._Wait(60)
			end
		end
	end)
end
local function Mokou1_normal1_init_Normal(self)
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
			task._Wait(60)
		end
		local co = { 5, 3, 1 }
		local a, u, a0, r, dr, dv, dv0, u1 = 0, 1, 0, 60, -120 / 59, 0, 0, 1
		local _a, _da, _a0 = 0, 8
		local j = 0
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		do
			for _ = 1, _infinite do
				do
					for _ = 1, 2 do
						a = 90 - 90 * u1
						r = 60
						dv0 = 0
						do
							for _ = 1, 2 do
								do
									for _ = 1, 15 do
										PlaySound("tan00", 0.1, 0, false)
										do
											for _ = 1, 3 do
												a0 = 0
												dv = 0
												do
													local i, _d_i = (1), (1)
													for _ = 1, 3 do
														last = New(_straight, square, co[i], self.x + r * cos(a), self.y + r * sin(a), 1.5 + dv0 + dv, a + a0, false, 0, true, true, 0, false, 0, 0, 0, false)
														a0 = a0 + 1.5 * u * u1
														dv = dv + 0.2
														i = i + _d_i
													end
												end
												a = a + 120
											end
										end
										dv0 = dv0 + 0.04
										a = a + 8 * u * u1
										r = r + dr
										task._Wait(4)
									end
								end
								u = -u
							end
						end
						u1 = -u1
						if true then
							_a = 0
							_da = 36
							dv = 0
							do
								for _ = 1, 6 do
									PlaySound("tan00", 0.5, 0, false)
									_a = _a + 18
									do
										for _ = 1, 10 do
											last = New(_straight, water_drop, COLOR_RED, self.x + 30 * cos(_a), self.y + 30 * sin(_a), 1.2 + dv, _a, false, 0, true, true, 0, false, 0, 0, 0, false)
											_a = _a + _da
										end
									end
									dv = dv + 0.3
									task._Wait(10)
								end
							end
						else
							_da = 0
							_a0 = Angle(self, player) - _da
							dv = 0
							do
								for _ = 1, 12 do
									PlaySound("tan00", 0.5, 0, false)
									_a = _a0
									do
										for _ = 1, 1 do
											last = New(_straight, grain_b, COLOR_RED, self.x + 30 * cos(_a), self.y + 30 * sin(_a), 0.8 + dv, _a, false, 0, true, true, 0, false, 0, 0, 0, false)
											_a = _a + _da
										end
									end
									dv = dv + 0.2
									task._Wait(3)
								end
							end
						end
						task.MoveToPlayer(40, -96, 96, 120, 154, 16, 32, 8, 16, MOVE_NORMAL, MOVE_X_TOWARDS_PLAYER)
						j = j + 1
					end
				end
				task._Wait(60)
			end
		end
	end)
end
local function Mokou1_normal1_init_Hard(self)
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		local co = { 5, 3, 3, 5 }
		local a, u, a0, r, dr, dv, dv0, u1 = 0, 1, 0, 60, -120 / 59, 0, 0, 1
		local _a, _da, _a0 = 0, 8
		local j = 0
		do
			for _ = 1, _infinite do
				do
					for _ = 1, 2 do
						a = 90 - 90 * u1
						r = 60
						dv0 = 0
						do
							for _ = 1, 2 do
								do
									for _ = 1, 20 do
										PlaySound("tan00", 0.1, 0, false)
										do
											for _ = 1, 3 do
												a0 = 0
												dv = 0
												do
													local i, _d_i = (1), (1)
													for _ = 1, 4 do
														last = New(_straight, square, co[i], self.x + r * cos(a), self.y + r * sin(a), 1.75 + dv0 + dv, a + a0, false, 0, true, true, 0, false, 0, 0, 0, false)
														a0 = a0 + 2 * u * u1
														dv = dv + 0.25
														i = i + _d_i
													end
												end
												a = a + 120
											end
										end
										dv0 = dv0 + 0.03
										a = a + 8 * u * u1
										r = r + dr
										task._Wait(3)
									end
								end
								u = -u
							end
						end
						u1 = -u1
						if true then
							_a = 0
							_da = 30
							dv = 0
							do
								for _ = 1, 7 do
									PlaySound("tan00", 0.5, 0, false)
									_a = _a + 10
									do
										for _ = 1, 12 do
											last = New(_straight, water_drop, COLOR_RED, self.x + 30 * cos(_a), self.y + 30 * sin(_a), 1.7 + dv, _a, false, 0, true, true, 0, false, 0, 0, 0, false)
											_a = _a + _da
										end
									end
									dv = dv + 0.3
									task._Wait(5)
								end
							end
						else
							_da = 20
							_a0 = Angle(self, player) - _da
							dv = 0
							do
								for _ = 1, 24 do
									PlaySound("tan00", 0.5, 0, false)
									_a = _a0
									do
										for _ = 1, 3 do
											last = New(_straight, grain_b, COLOR_RED, self.x + 30 * cos(_a), self.y + 30 * sin(_a), 0.8 + dv, _a, false, 0, true, true, 0, false, 0, 0, 0, false)
											_a = _a + _da
										end
									end
									dv = dv + 0.2
									task._Wait(2)
								end
							end
						end
						task.MoveToPlayer(40, -96, 96, 120, 154, 16, 32, 8, 16, MOVE_NORMAL, MOVE_X_TOWARDS_PLAYER)
						j = j + 1
					end
				end
				task._Wait(60)
			end
		end
	end)
end
local function Mokou1_normal1_init_Lunatic(self)
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		local co = { 5, 3, 1, 3, 5 }
		local a, u, a0, r, dr, dv, dv0, u1 = 0, 1, 0, 60, -120 / 59, 0, 0, 1
		local _a, _da, _a0 = 0, 8
		local j = 0
		do
			for _ = 1, _infinite do
				do
					for _ = 1, 2 do
						a = 90 - 90 * u1
						r = 60
						dv0 = 0
						do
							for _ = 1, 2 do
								do
									for _ = 1, 30 do
										PlaySound("tan00", 0.1, 0, false)
										do
											for _ = 1, 3 do
												a0 = 0
												dv = 0
												do
													local i, _d_i = (1), (1)
													for _ = 1, 5 do
														last = New(_straight, square, co[i], self.x + r * cos(a), self.y + r * sin(a), 2.25 + dv0 + dv, a + a0 + 90 * u * u1, false, 0, true, true, 0, false, 0, 0, 0, false)
														a0 = a0 + 1.5 * u * u1
														dv = dv + 0.15
														i = i + _d_i
													end
												end
												a = a + 120
											end
										end
										dv0 = dv0 + 0.03
										a = a + 8 * u * u1
										r = r + dr
										task._Wait(2)
									end
								end
								u = -u
							end
						end
						u1 = -u1
						if true then
							_a = 0
							_da = 22.5
							dv = 0
							do
								for _ = 1, 9 do
									PlaySound("tan00", 0.5, 0, false)
									_a = _a + 7.5
									do
										for _ = 1, 16 do
											last = New(_straight, water_drop, COLOR_RED, self.x + 30 * cos(_a), self.y + 30 * sin(_a), 1.7 + dv, _a, false, 0, true, true, 0, false, 0, 0, 0, false)
											_a = _a + _da
										end
									end
									dv = dv + 0.3
									task._Wait(4)
								end
							end
						else
							_da = 15
							_a0 = Angle(self, player) - _da
							dv = 0
							do
								for _ = 1, 36 do
									PlaySound("tan00", 0.5, 0, false)
									_a = _a0
									do
										for _ = 1, 3 do
											last = New(_straight, grain_b, COLOR_RED, self.x + 30 * cos(_a), self.y + 30 * sin(_a), 0.8 + dv, _a, false, 0, true, true, 0, false, 0, 0, 0, false)
											_a = _a + _da
										end
									end
									dv = dv + 0.2
									task._Wait(1)
								end
							end
						end
						task.MoveToPlayer(40, -96, 96, 120, 154, 16, 32, 8, 16, MOVE_NORMAL, MOVE_X_TOWARDS_PLAYER)
						j = j + 1
					end
				end
				task._Wait(60)
			end
		end
	end)
end
local function Mokou1_normal1_del(self)
	if self.timeout == 1 then
		self.noExtendBonus = true
	end
end

--Keine
local function Keine1_card1_init_Easy(self)
	task.New(self, function()
		local f1, f1_1, f2, f2_1, f2_2
		do
			function f1(x, y, a, co)
				f2()
				local obj = stg.newBulletStraight(stg.arrow_big, 1, false, x, y, 8, a, true)
				obj.hide = true
				obj.colli = false
				task.New(obj, function()
					local dx, dy, dsp, ddsp = 50 * cos(a + 90), 50 * sin(a + 90), 0, 12
					while true do
						PlaySound("kira00")
						for u = -1, 1, 2 do
							for j = 1, 3 do
								for i = 0, 4 do
									f1_1(obj.x + dx * u, obj.y + dy * u, 2 + 0.4 * i, a + (dsp * j) * u, co)
								end
							end
							f1_1(obj.x + dx * u, obj.y + dy * u, 1.5, a, co)
						end
						task.Wait(6)
						if dsp > 60 or dsp < 0 then
							ddsp = -ddsp
						end
						dsp = dsp + ddsp
					end
				end)
			end
			function f1_1(x, y, v, a, co)
				local obj = stg.newBulletStraight(stg.square, co, false, x, y, 0, a, false)
				egg.AddSimStrChV(obj, 0, v, a, 120)
			end
			function f2()
				local a = Angle(self, player)
				for i = 1, 18 do
					for j = 0, 1 do
						f2_1(self.x, self.y, 1 + 0.25 * j, a + 20 * i + 10 * j)
					end
				end
				for i = 5, 14 do
					f2_1(self.x, self.y, 1.25, -90 - 10 + 20 * i)
					f2_2(self.x, self.y, 1.3, -90 + 20 * i)
				end
			end
			function f2_1(x, y, v, a)
				local obj = stg.newBulletStraight(stg.ball_mid, 5, true, x, y, 0, a)
				obj.hscale, obj.vscale = 1.75, 1.75
				obj.a, obj.b = 1.5 * obj.a, 1.5 * obj.b
				egg.AddSimStrChV(obj, 6, v, a, 30)
			end
			function f2_2(x, y, v, a)
				local obj = stg.newBulletStraight(stg.knife, 5, true, x, y, 0, a)
				egg.AddSimStrChV(obj, 6, v, a, 30)
			end
		end

		do
			s3A_boss.pic_show2()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
				task._Wait(60)
			end
			local u, a = 1
			while true do
				f1(self.x, self.y, -90, 6)
				task.Wait(60)
				task.MoveToPlayer(60, -40, 40, 120, 144, 10, 20, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
				f1(self.x, self.y, -90, 8)
				task._Wait(60)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
				task.Wait(60)
				f1(self.x, self.y, -90, 10)
				task.Wait(60)
				task.MoveToPlayer(60, -40, 40, 120, 144, 10, 20, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
				u = -u
			end
		end

	end)
end
local function Keine1_card1_init_Normal(self)
	task.New(self, function()
		local f1, f1_1, f2, f2_1, f2_2
		do
			function f1(x, y, a, co)
				f2()
				local obj = stg.newBulletStraight(stg.arrow_big, 1, false, x, y, 8, a, true)
				obj.hide = true
				obj.colli = false
				task.New(obj, function()
					local dx, dy, dsp, ddsp = 40 * cos(a + 90), 40 * sin(a + 90), 0, 12
					while true do
						PlaySound("kira00")
						for u = -1, 1, 2 do
							for j = 1, 3 do
								for i = 0, 4 do
									f1_1(obj.x + dx * u, obj.y + dy * u, 1 + 0.2 * i, a + (dsp * j) * u, co)
								end
							end
							f1_1(obj.x + dx * u, obj.y + dy * u, 1.5, a, co)
						end
						task.Wait(6)
						if dsp > 60 or dsp < 0 then
							ddsp = -ddsp
						end
						dsp = dsp + ddsp
					end
				end)
			end
			function f1_1(x, y, v, a, co)
				local obj = stg.newBulletStraight(stg.square, co, false, x, y, 0, a, false)
				egg.AddSimStrChV(obj, 0, v, a, 120)
			end
			function f2()
				local a = Angle(self, player)
				for i = 1, 18 do
					for j = 0, 4 do
						f2_1(self.x, self.y, 1 + 0.25 * j, a + 20 * i + 5 * j)
					end
				end
				for i = 5, 14 do
					f2_1(self.x, self.y, 1.25, -90 - 10 + 20 * i)
					f2_2(self.x, self.y, 1.3, -90 + 20 * i)
				end
			end
			function f2_1(x, y, v, a)
				local obj = stg.newBulletStraight(stg.ball_mid, 5, true, x, y, 0, a)
				obj.hscale, obj.vscale = 1.75, 1.75
				obj.a, obj.b = 1.5 * obj.a, 1.5 * obj.b
				egg.AddSimStrChV(obj, 6, v, a, 30)
			end
			function f2_2(x, y, v, a)
				local obj = stg.newBulletStraight(stg.knife, 5, true, x, y, 0, a)
				egg.AddSimStrChV(obj, 6, v, a, 30)
			end
		end

		do
			s3A_boss.pic_show2()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
				task._Wait(60)
			end
			local u, a = 1
			while true do
				f1(self.x, self.y, -90, 6)
				task.Wait(60)
				task.MoveToPlayer(60, -40, 40, 120, 144, 10, 20, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
				f1(self.x, self.y, -90, 8)
				task._Wait(60)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
				task.Wait(60)
				f1(self.x, self.y, -90, 10)
				task.Wait(60)
				task.MoveToPlayer(60, -40, 40, 120, 144, 10, 20, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
				u = -u
			end
		end

	end)
end
local function Keine1_card1_init_Hard(self)
	lasttask = task.New(self, function()
		local f1, f1_1, f2, f2_1, f2_2
		do
			function f1(x, y, a, co)
				f2()
				local obj = stg.newBulletStraight(stg.arrow_big, 1, false, x, y, 8, a, true)
				obj.hide = true
				obj.colli = false
				task.New(obj, function()
					local dx, dy, dsp, ddsp = 30 * cos(a + 90), 30 * sin(a + 90), 0, 9
					while true do
						PlaySound("kira00")
						for u = -1, 1, 2 do
							for j = 1, 3 do
								for i = 0, 5 do
									f1_1(obj.x + dx * u, obj.y + dy * u, 1 + 0.2 * i, a + (dsp * j) * u, co)
								end
							end
							f1_1(obj.x + dx * u, obj.y + dy * u, 1.5, a, co)
						end
						task.Wait(5)
						if dsp > 60 or dsp < 0 then
							ddsp = -ddsp
						end
						dsp = dsp + ddsp
					end
				end)
			end
			function f1_1(x, y, v, a, co)
				local obj = stg.newBulletStraight(stg.square, co, false, x, y, 0, a, false)
				egg.AddSimStrChV(obj, 0, v, a, 120)
			end
			function f2()
				local a = Angle(self, player)
				for i = 1, 18 do
					f2_1(self.x, self.y, 1.5, a + 20 * i)
				end
				for i = 5, 14 do
					f2_1(self.x, self.y, 1.25, -90 - 10 + 20 * i)
					f2_2(self.x, self.y, 1.3, -90 + 20 * i)
				end
			end
			function f2_1(x, y, v, a)
				local obj = stg.newBulletStraight(stg.ball_mid, 5, true, x, y, 0, a)
				obj.hscale, obj.vscale = 1.75, 1.75
				obj.a, obj.b = 1.5 * obj.a, 1.5 * obj.b
				egg.AddSimStrChV(obj, 6, v, a, 30)
			end
			function f2_2(x, y, v, a)
				local obj = stg.newBulletStraight(stg.knife, 5, true, x, y, 0, a)
				egg.AddSimStrChV(obj, 6, v, a, 30)
			end
		end

		do
			s3A_boss.pic_show2()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
				task._Wait(60)
			end
			local u, a = 1
			while true do
				a = -90 + 60 * u
				f1(self.x, self.y, a, 6)
				task.Wait(60)
				task.MoveToPlayer(60, -40, 40, 120, 144, 10, 20, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
				a = -90 - 60 * u
				f1(self.x, self.y, a, 8)
				task._Wait(60)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
				task.Wait(60)
				a = Angle(self, player)
				f1(self.x, self.y, a, 10)
				task.Wait(60)
				task.MoveToPlayer(60, -40, 40, 120, 144, 10, 20, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
				u = -u
			end
		end
	end)
end
local function Keine1_card1_init_Lunatic(self)
	task.New(self, function()
		local f1, f1_1, f2, f2_1, f2_2
		do
			function f1(x, y, a, co)
				f2()
				local obj = stg.newBulletStraight(stg.arrow_big, 1, false, x, y, 8, a, true)
				obj.hide = true
				obj.colli = false
				task.New(obj, function()
					local dx, dy, dsp, ddsp = 30 * cos(a + 90), 30 * sin(a + 90), 0, 8
					while true do
						PlaySound("kira00")
						for u = -1, 1, 2 do
							for j = 1, 3 do
								for i = 0, 7 do
									f1_1(obj.x + dx * u, obj.y + dy * u, 1 + 0.3 * i, a + (dsp * j) * u, co)
								end
							end
							f1_1(obj.x + dx * u, obj.y + dy * u, 1.5, a, co)
						end
						task.Wait(4)
						if dsp > 60 or dsp < 0 then
							ddsp = -ddsp
						end
						dsp = dsp + ddsp
					end
				end)
			end
			function f1_1(x, y, v, a, co)
				local obj = stg.newBulletStraight(stg.square, co, false, x, y, 0, a, false)
				egg.AddSimStrChV(obj, 0, v, a, 120)
			end
			function f2()
				local a = Angle(self, player)
				for i = 1, 24 do
					f2_1(self.x, self.y, 1.5, a + 15 * i)
				end
				for i = 5, 20 do
					f2_1(self.x, self.y, 1.25, -90 - 7.5 + 15 * i)
					f2_2(self.x, self.y, 1.3, -90 + 15 * i)
				end
			end
			function f2_1(x, y, v, a)
				local obj = stg.newBulletStraight(stg.ball_mid, 5, true, x, y, 0, a)
				obj.hscale, obj.vscale = 1.75, 1.75
				obj.a, obj.b = 1.5 * obj.a, 1.5 * obj.b
				egg.AddSimStrChV(obj, 6, v, a, 30)
			end
			function f2_2(x, y, v, a)
				local obj = stg.newBulletStraight(stg.knife, 5, true, x, y, 0, a)
				egg.AddSimStrChV(obj, 6, v, a, 30)
			end
		end

		do
			s3A_boss.pic_show2()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
				task._Wait(60)
			end
			local u, a = 1
			while true do
				a = -90 + 60 * u
				f1(self.x, self.y, a, 6)
				task.Wait(60)
				task.MoveToPlayer(60, -40, 40, 120, 144, 10, 20, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
				a = -90 - 60 * u
				f1(self.x, self.y, a, 8)
				task._Wait(60)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
				task.Wait(60)
				a = Angle(self, player)
				f1(self.x, self.y, a, 10)
				task.Wait(60)
				task.MoveToPlayer(60, -40, 40, 120, 144, 10, 20, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
				u = -u
			end
		end
	end)
end
local function Keine1_card1_del(self)
	if self.timeout == 1 then
		self.noExtendBonus = true
	else
		Spell_break_eff(self.x, self.y, 0, 100, 255,
				'bamboo_leaf_white', 'tree_leaf_white')
	end
end

--boss
local function create_mokou(group_name, class_name)
	return EISlib.stage.createBossClass(group_name, class_name, "Mokou", spellcard_background,
			{"s3", stage3_background}, -256, 300,
			function(self)
				lstg.wis.Mokou(self)
			end)
end
local function create_keine(group_name, class_name)
	return EISlib.stage.createBossClass(group_name, class_name, "Keine", s3A_boss.scbg,
			{"s3", stage3_background}, 256, 300,
			function(self)
				lstg.wis.Keine(self)
			end)
end
local function create_dialog(boss_class, t)
	return EISlib.stage.createDialogClass(
			boss_class, false, t)
end
local function create_card(boss_class, card_name, time_t, hp, drop_t, mode, pre_action, init, del)
	local sc = EISlib.stage.createCardClass(boss_class, card_name, time_t, hp, drop_t, mode, pre_action)
	if init then
		sc.init = init
	end
	if del then
		sc.del = del
	end
	return sc
end

--Mokou
local Mokou1E = create_mokou("Easy", "stage3Amid_boss1:Easy")
Mokou1_common1(Mokou1E)
create_card(Mokou1E, "通常攻击",
		{2, 5, 20}, 600, {0, 0, 0}, "normal", true, Mokou1_normal1_init_Easy, Mokou1_normal1_del)
Mokou1_common2(Mokou1E)

local Mokou1N = create_mokou("Normal", "stage3Amid_boss1:Normal")
Mokou1_common1(Mokou1N)
create_card(Mokou1N, "通常攻击",
		{2, 5, 20}, 600, {0, 0, 0}, "normal", true, Mokou1_normal1_init_Normal, Mokou1_normal1_del)
Mokou1_common2(Mokou1N)

local Mokou1H = create_mokou("Hard", "stage3Amid_boss1:Hard")
Mokou1_common1(Mokou1H)
create_card(Mokou1H, "通常攻击",
		{2, 5, 20}, 600, {0, 0, 0}, "normal", true, Mokou1_normal1_init_Hard, Mokou1_normal1_del)
Mokou1_common2(Mokou1H)

local Mokou1L = create_mokou("Lunatic", "stage3Amid_boss1:Lunatic")
Mokou1_common1(Mokou1L)
create_card(Mokou1L, "通常攻击",
		{2, 5, 20}, 600, {0, 0, 0}, "normal", true, Mokou1_normal1_init_Lunatic, Mokou1_normal1_del)
Mokou1_common2(Mokou1L)

--Keine
local Keine1E = create_keine("Easy", "stage3Amid_boss2:Easy")
Keine1_common1(Keine1E)
create_card(Keine1E, "神代史「永恒的诸神黄昏」",
		{2, 10, 25}, 1500, {10, 20, 30}, "spellcard", true, Keine1_card1_init_Easy, Keine1_card1_del)
Keine1_common2(Keine1E)

local Keine1N = create_keine("Normal", "stage3Amid_boss2:Normal")
Keine1_common1(Keine1N)
create_card(Keine1N, "神代史「永恒的诸神黄昏」",
		{2, 10, 25}, 1500, {10, 20, 30}, "spellcard", true, Keine1_card1_init_Normal, Keine1_card1_del)
Keine1_common2(Keine1N)

local Keine1H = create_keine("Hard", "stage3Amid_boss2:Hard")
Keine1_common1(Keine1H)
create_card(Keine1H, "人理史「战争余辉」",
		{2, 10, 25}, 1500, {10, 20, 30}, "spellcard", true, Keine1_card1_init_Hard, Keine1_card1_del)
Keine1_common2(Keine1H)

local Keine1L = create_keine("Lunatic", "stage3Amid_boss2:Lunatic")
Keine1_common1(Keine1L)
create_card(Keine1L, "人理史「战争余辉」",
		{2, 10, 25}, 1500, {10, 20, 30}, "spellcard", true, Keine1_card1_init_Lunatic, Keine1_card1_del)
Keine1_common2(Keine1L)

function s3A_boss.mid1(diff)
	local boss
	diff = diff or difficulty
	if diff == 1 then
		boss = New(Mokou1E, Mokou1E.cards)
	elseif diff == 2 then
		boss = New(Mokou1N, Mokou1N.cards)
	elseif diff == 3 then
		boss = New(Mokou1H, Mokou1H.cards)
	elseif diff == 4 then
		boss = New(Mokou1L, Mokou1L.cards)
	end
	return boss
end
function s3A_boss.mid2(diff)
	local boss
	diff = diff or difficulty
	if diff == 1 then
		boss = New(Keine1E, Keine1E.cards)
	elseif diff == 2 then
		boss = New(Keine1N, Keine1N.cards)
	elseif diff == 3 then
		boss = New(Keine1H, Keine1H.cards)
	elseif diff == 4 then
		boss = New(Keine1L, Keine1L.cards)
	end
	return boss
end
