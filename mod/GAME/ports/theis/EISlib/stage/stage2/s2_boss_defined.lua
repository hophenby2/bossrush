--s2_boss = {}
--祈华梦二面boss定义
--规定boss名为 "stage"..(关卡数).."boss"..(难度名称)  (如 stage2boss:Lunatic）
--规定LSC的boss名为  "LSC"..(关卡数)..":"..(难度名称)
--因为编辑器原因，所以boss定义都必须是编辑器生成的对象，所以最终命名为 _editor_class["LSC1:Easy"] 这样

local function move_rd(t, y0, dy)
	y0 = y0 or 144
	dy = dy or 25
	task.MoveToPlayer(t or 60, -40, 40, y0 - dy, y0 + dy, 10, 20, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
end

--绘光的蓄力特效
local function eff(x, y, t)
	New(AbEff, x, y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
	if t then task.Wait(t) end
end
--符卡练习出场特效
local function boss_scpr_show(self, x, y)
	for _ = 1, 3 do
		eff(x, y, 20)
	end
	task.Wait(20)
	self.x, self.y = x, y
	boss.show_aura(self, true)
end

--用于衔接非与符，符与非之间的移动
local function boss_action(boss_class, x, y)
	local _sc = boss.dialog.New(true)
	function _sc:init()
		player.dialog = false
		self.dialog_displayer = New(dialog_displayer)
		self._dialog_maintask = task.New(self, function()
			if ext.sc_pr then
				boss_scpr_show(self, x, y)
			else
				--task.Wait(30)
				task.MoveTo(x, y, 90, MOVE_ACC_DEC)
			end
		end)
	end
	table.insert(boss_class.cards, _sc)
end

--boss相关的素材全部在以下脚本文件里
local path = "EISlib/stage/stage2/"
Include(path .. "Emitsu_boss.lua")

--通用的方法(不知道怎么归类
do
	_editor_class["stage2mid_boss_ls1"] = Class(laser)
	_editor_class["stage2mid_boss_ls1"].init = function(self, _x, _y, v0, a0)
		laser.init(self, COLOR_BLUE, _x, _y, 0, 64, 96, 64, 6, 6, 0)
		laser.ChangeImage(self, 3, orginal)
		self.rot = a0
		--local len1, len2, len3 = 64, 32, 64
		lasttask = task.New(self, function()
			laser.grow(self, 60, true, true)
			_set_a(self, 0.1, a0, false)
			_forbid_v(self, v0, 'original', 'original')
		end)
	end
	_editor_class["stage2mid_boss_obj1"] = Class(_object)
	_editor_class["stage2mid_boss_obj1"].init = function(self, _x, _y, a0, a1)
		self.x, self.y = _x, _y
		self.img = "magic1"
		self.layer = LAYER_ENEMY_BULLET
		self.group = GROUP_GHOST
		self.hide = false
		self.bound = true
		self.navi = false
		self.hp = 60
		self.maxhp = 60
		self.colli = true
		self._servants = {}
		self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
		self.hscale, self.vscale = 0, 0
		SimSizeCh(self, 0, 0.75, 60)
		self.omiga = 1
		self.a, self.b = 16, 16
		AddSimStrChV(self, 0, 2, a0, 120)
		lasttask = task.New(self, function()
			task.Wait(60)
			AddSimStrChV(self, 0, -1.5, a0, 60)
			task.Wait(240)
			AddSimStrChV(self, 0, 3, a1, 240)
		end)
		lasttask = task.New(self, function()
			if (difficulty == 4) then
				local dsp, a, last = 8
				task._Wait(180)
				do
					for _ = 1, 4 do
						PlaySound('kira00', 1)
						a = Angle(self, player) + 2 * dsp + ran:Float(-5, 5)
						do
							local n, _d_n = (1), (1)
							for _ = 1, 5 do
								last = New(straight, ball_mid, 1, true, self.x, self.y, 1, a)
								if n % 2 == 0 then
									AddSimStrChV(last, 0, 2.5, a, 60)
								else
									AddSimStrChV(last, 0, 2.75, a, 60)
								end
								a = a - dsp
								n = n + _d_n
							end
						end
						task._Wait(90)
					end
				end
			elseif (difficulty == 3) then
				local dsp, a, last = 12
				task._Wait(180)
				do
					for _ = 1, 2 do
						PlaySound('kira00', 1)
						a = Angle(self, player) + dsp + ran:Float(-5, 5)
						do
							local n, _d_n = (1), (1)
							for _ = 1, 3 do
								last = New(straight, ball_mid, 5, true, self.x, self.y, 1, a)
								if n % 2 == 0 then
									AddSimStrChV(last, 0, 2, a, 60)
								else
									AddSimStrChV(last, 0, 2.25, a, 60)
								end
								a = a - dsp
								n = n + _d_n
							end
						end
						task._Wait(120)
					end
				end
			end
		end)
	end
	_editor_class["stage2mid_boss_obj1"].take_damage = function(self, dmg)
		self.hp = self.hp - dmg
	end
	_editor_class["stage2mid_boss_ls2"] = Class(laser)
	_editor_class["stage2mid_boss_ls2"].init = function(self, _x, _y, mst1, mst2)
		laser.init(self, COLOR_BLUE, _x, _y, 0, 6, 0, 6, 6, 6, 0)
		self.bound = false
		self.killing = 0
		self.mst1, self.mst2 = mst1, mst2
		laser.ChangeImage(self, 1, orginal)
		lasttask = task.New(self, function()
			laser._TurnOn(self, 60, false, true)
		end)
	end
	_editor_class["stage2mid_boss_ls2"].frame = function(self)
		self.class.base.frame(self)
		if self.timer >= 120 and IsValid(player) and IsValid(self.mst1) and IsValid(self.mst2) and Dist(player, self.mst1) + Dist(player, self.mst2) <= 2 * sqrt(0.25 * self.l2 * self.l2 + 3600) then
			self.killing = self.killing + 1
		end
		if self.killing >= 20 then
			Del(self)
		end
		_object.set_color(self, "", 255, 255, 255 - 100 * self.killing / 30, 255 - 100 * self.killing / 30)
		if IsValid(self.mst1) and IsValid(self.mst2) then
			self.x, self.y = self.mst1.x, self.mst1.y
			self.rot = Angle(self.mst1, self.mst2)
			self.l2 = max(0, Dist(self.mst1, self.mst2) - 12)
		else
			Del(self)
		end


	end
	_editor_class["stage2mid_boss_ls2"].del = function(self)
		self.class.base.del(self)
		if (self.timer <= 400) then
			if (difficulty == 4) then
				PlaySound("kira00", 0.5, 0, false)
				local a0, d, _x, _y = Angle(self, player), 0
				do
					for _ = 1, int(self.l2 / 10) do
						_x, _y = self.x + d * cos(self.rot), self.y + d * sin(self.rot)
						a0 = Angle(_x, _y, player.x, player.y)
						_object.set_color(New(_straight, star_small, COLOR_RED, _x, _y, 0, a0, false, 1, true, true, 0, false, 0.05, a0, 0, false), "", 255, 255, 255, 255)
						d = d + 10
					end
				end
			elseif (difficulty == 3) then
				PlaySound("kira00", 0.5, 0, false)
				local a0, d, _x, _y = 90, 0
				do
					for _ = 1, int(self.l2 / 20) do
						_x, _y = self.x + d * cos(self.rot), self.y + d * sin(self.rot)
						a0 = Angle(_x, _y, player.x, player.y)
						_object.set_color(New(_straight, star_small, COLOR_RED, _x, _y, 0, a0, false, 1, true, true, 0, false, 0.04, a0, 3, false), "", 255, 255, 255, 255)
						d = d + 20
					end
				end
			end
		end
	end
	_editor_class["stage2mid_boss_ls3"] = Class(laser)
	_editor_class["stage2mid_boss_ls3"].init = function(self, _x, _y, mst1, mst2)
		laser.init(self, COLOR_BLUE, _x, _y, 0, 6, 0, 6, 6, 6, 0)
		self.bound = false
		self.killing = 0
		self.mst1, self.mst2 = mst1, mst2
		laser.ChangeImage(self, 1, orginal)
		laser._TurnOn(self, 120, false, true)
	end
	_editor_class["stage2mid_boss_ls3"].frame = function(self)
		self.class.base.frame(self)
		if self.timer >= 120 and IsValid(player) and IsValid(self.mst1) and IsValid(self.mst2) and Dist(player, self.mst1) + Dist(player, self.mst2) <= 2 * sqrt(0.25 * self.l2 * self.l2 + 3600) then
			self.killing = self.killing + 1
		end
		if self.killing >= 20 then
			Del(self)
		end
		_object.set_color(self, "", 255, 255, 255 - 100 * self.killing / 30, 255 - 100 * self.killing / 30)
		if IsValid(self.mst1) and IsValid(self.mst2) then
			self.x, self.y = self.mst1.x, self.mst1.y
			self.rot = Angle(self.mst1, self.mst2)
			self.l2 = max(0, Dist(self.mst1, self.mst2) - 12)
		else
			Del(self)
		end


	end
	_editor_class["stage2mid_boss_ls3"].del = function(self)
		self.class.base.del(self)
		if (self.timer <= 540) then
			PlaySound("kira00", 0.5, 0, false)
			local a0, d, _x, _y = Angle(self, player), 0
			do
				for _ = 1, int(self.l2 / 10) do
					_x, _y = self.x + d * cos(self.rot), self.y + d * sin(self.rot)
					a0 = Angle(_x, _y, player.x, player.y)
					do
						local da, _d_da = (-25 + a0), (50)
						for _ = 1, 2 do
							New(straight, star_small, COLOR_RED, _x, _y, 0, da, false, 1, true, true, 0, false, 0.1, da, 0, false)
							da = da + _d_da
						end
					end
					d = d + 10
				end
			end
		else
		end
	end
	_editor_class["stage2mid_boss_obj2"] = Class(_object)
	_editor_class["stage2mid_boss_obj2"].init = function(self, _x, _y, t0, u, IsShow)
		self.x, self.y = _x, _y
		self.img = "magic6"
		self.layer = LAYER_ENEMY_BULLET
		self.group = GROUP_GHOST
		self.hide = false
		self.bound = true
		self.navi = false
		self.hp = 90
		self.maxhp = 90
		self.colli = true
		self._servants = {}
		self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
		self.bound = false
		self.hscale, self.vscale = 0, 0
		local x0, y0, r0, a0 = 0, 0, Dist(self.x, self.y, 0, 0), Angle(0, 0, self.x, self.y)
		lasttask = task.New(self, function()
			if (IsShow) then
				local _x, _y = 0, 154
				do
					local x, _d_x = (0), (90 / 89)
					for _ = 1, 90 do
						self.hscale, self.vscale = 0.75 * sin(x), 0.75 * sin(x)
						self.x = _x + (x0 + r0 * cos(a0) - _x) * sin(x)
						self.y = _y + (y0 + r0 * sin(a0) - _y) * sin(x)
						task._Wait(1)
						x = x + _d_x
					end
				end
			else
			end
			self.hscale, self.vscale = 0.75, 0.75
			task._Wait(60)
			self._w = 0
			do
				local x, _d_x = (1), (-1 / (t0 - 1))
				for _ = 1, t0 do
					self.x = x0 + x * r0 * cos(a0)
					self.y = y0 + x * r0 * sin(a0)
					a0 = a0 + self._w
					task._Wait(1)
					x = x + _d_x
				end
			end
			_del(self, true)
		end)
		if (difficulty == 4) then
			lasttask = task.New(self, function()
				task._Wait(360)
				PlaySound("kira00", 0.5, 0, false)
				do
					for _ = 1, 1 do
						last = New(_straight, ball_mid, COLOR_BLUE, self.x, self.y, 1, 0, true, 0, true, true, 0, false, 0, 0, 0, false)
						task._Wait(180)
					end
				end
			end)
		else
		end
	end
	_editor_class["stage2mid_boss_obj3"] = Class(_object)
	_editor_class["stage2mid_boss_obj3"].init = function(self, _x, _y, t0, u)
		self.x, self.y = _x, _y
		self.img = "magic6"
		self.layer = LAYER_ENEMY_BULLET
		self.group = GROUP_GHOST
		self.hide = false
		self.bound = true
		self.navi = false
		self.hp = 90
		self.maxhp = 90
		self.colli = true
		self._servants = {}
		self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
		self.hscale, self.vscale = 0.75, 0.75
		self.bound = false
		self.a, self.b = 16, 16
		lasttask = task.New(self, function()
			task._Wait(60)
			self._w = 0.2
			local x0, y0, r0, a0 = 0, 0, Dist(self.x, self.y, 0, 0), Angle(0, 0, self.x, self.y)
			do
				local x, _d_x = (1), (-1 / (t0 - 1))
				for _ = 1, 2 * t0 do
					self.x = x0 + x * r0 * cos(a0)
					self.y = y0 + x * r0 * sin(a0)
					a0 = a0 + self._w
					task._Wait(1)
					x = x + _d_x
				end
			end
			_del(self, true)
		end)
		lasttask = task.New(self, function()
			task._Wait(150)
			PlaySound("kira00", 0.5, 0, false)
			do
				for _ = 1, 3 do
					last = New(_straight, ball_mid, COLOR_RED, self.x, self.y, 1, 0, true, 0, true, true, 0, false, 0, 0, 0, false)
					task._Wait(90)
				end
			end
		end)
	end
	--EN
	_editor_class["stage2mid_boss_obj4"] = Class(_object)
	_editor_class["stage2mid_boss_obj4"].init = function(self, _x, _y, a0, t0)
		self.x, self.y = _x, _y
		self.img = "magic6"
		self.layer = LAYER_ENEMY_BULLET
		self.group = GROUP_GHOST
		self.hide = false
		self.bound = true
		self.navi = false
		self.hp = 90
		self.maxhp = 90
		self.colli = true
		self._servants = {}
		self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
		self.hscale, self.vscale = 0, 0
		self.bound = false
		self.a, self.b = 16, 16
		lasttask = task.New(self, function()
			task._Wait(t0)
			lasttask = task.New(self, function()
				if (difficulty == 2) then
					task._Wait(30)
					last = New(_editor_class["stage2mid_boss_ls4"], self.x, self.y, a0 + 120, 130 - t0)
					_connect(self, last, 0, true)
					last = New(_editor_class["stage2mid_boss_ls4"], self.x, self.y, a0 - 120, 130 - t0)
					_connect(self, last, 0, true)
				else
					task._Wait(30)
					last = New(_editor_class["stage2mid_boss_ls4"], self.x, self.y, a0 + 180, 130 - t0)
					_connect(self, last, 0, true)
				end
			end)
			do
				local x, _d_x = (0), (1 / 9)
				for _ = 1, 10 do
					self.hscale, self.vscale = 0.75 * x, 0.75 * x
					task._Wait(1)
					x = x + _d_x
				end
			end
			if (difficulty == 2) then
				SetV2(self, 2, a0, true, false)
				task._Wait(30)
				do
					local v, _d_v = (2), (-2 / 29)
					for _ = 1, 30 do
						SetV2(self, v, a0, true, false)
						task._Wait(1)
						v = v + _d_v
					end
				end
				task._Wait(60 - t0)
				self.bound = true
				_set_a(self, 0.025, a0, false)
				_forbid_v(self, 2, 'original', 'original')
			elseif (difficulty == 1) then
				SetV2(self, 1.25, a0, true, false)
				task._Wait(40)
				do
					local v, _d_v = (1.25), (-1.25 / 39)
					for _ = 1, 40 do
						SetV2(self, v, a0, true, false)
						task._Wait(1)
						v = v + _d_v
					end
				end
				task._Wait(60 - t0)
				self.bound = true
				_set_a(self, 0.025, a0, false)
				_forbid_v(self, 1.25, 'original', 'original')
			end
		end)
	end
	_editor_class["stage2mid_boss_ls4"] = Class(laser)
	_editor_class["stage2mid_boss_ls4"].init = function(self, _x, _y, a0, t0)
		laser.init(self, COLOR_CYAN, _x, _y, 0, 96, 300, 96, 8, 0, 0)
		self.rot = a0
		self.w = 1
		laser.ChangeImage(self, 3, orginal)
		lasttask = task.New(self, function()
			laser._TurnHalfOn(self, 1, true)
			task._Wait(t0)
			self.w = 6
			laser._TurnOn(self, 10, true, true)
			task._Wait(30)
			laser._TurnOff(self, 10, true)
		end)
	end
	_editor_class["stage2mid_boss_ls4"].frame = function(self)
		self.class.base.frame(self)
		_set_rel_pos(self, 0, 0, self.rot, false)
	end
	_editor_class["stage2mid_boss_ls5"] = Class(laser)
	_editor_class["stage2mid_boss_ls5"].init = function(self, _x, _y, mst1, mst2)
		laser.init(self, COLOR_GREEN, _x, _y, 0, 6, 0, 6, 6, 6, 0)
		self.bound = false
		self.killing = 0
		self.mst1, self.mst2 = mst1, mst2
		laser.ChangeImage(self, 1, orginal)
		laser._TurnOn(self, 30, false, true)
	end
	_editor_class["stage2mid_boss_ls5"].frame = function(self)
		self.class.base.frame(self)
		if IsValid(self.mst1) and IsValid(self.mst2) and self.timer <= 120 then
			self.x, self.y = self.mst1.x, self.mst1.y
			self.rot = Angle(self.mst1, self.mst2)
			self.l2 = max(0, Dist(self.mst1, self.mst2) - 12)
		else
			Del(self)
		end
	end
	_editor_class["stage2mid_boss_ls5"].del = function(self)
		self.class.base.del(self)
		if (self.timer <= 400) then
			if (difficulty == 2) then
				PlaySound("kira00", 0.5, 0, false)
				local a0, d, times, _x, _y = self.rot + 75, 0, int(self.l2 / 8)
				local da = 30 / (times - 1)
				do
					for _ = 1, times do
						_x, _y = self.x + d * cos(self.rot), self.y + d * sin(self.rot)
						last = New(_straight, star_small, COLOR_GREEN, _x, _y, 0, a0, false, 1, true, true, 0, false, 0.04, a0, 2, false)
						_object.set_color(last, "", 255, 255, 255, 255)
						a0 = a0 + da
						d = d + 8
					end
				end
				a0, d, times, _x, _y = self.rot, 0, int(self.l2 / 8)
				da = -180 / (times - 1)
				do
					for _ = 1, times do
						_x, _y = self.x + d * cos(self.rot), self.y + d * sin(self.rot)
						last = New(_straight, star_small, COLOR_YELLOW, _x, _y, 0, a0, false, 1, true, true, 0, false, 0.02, a0 + 180, 1.5, false)
						a0 = a0 + da
						d = d + 8
					end
				end
			elseif (difficulty == 1) then
				PlaySound("kira00", 0.5, 0, false)
				local a0, d, times, _x, _y = self.rot + 85, 0, int(self.l2 / 10)
				local da = 10 / (times - 1)
				do
					for _ = 1, times do
						_x, _y = self.x + d * cos(self.rot), self.y + d * sin(self.rot)
						last = New(_straight, star_small, COLOR_GREEN, _x, _y, 0, a0, false, 1, true, true, 0, false, 0.04, a0, 2, false)
						_object.set_color(last, "", 255, 255, 255, 255)
						a0 = a0 + da
						d = d + 10
					end
				end
			end
		end
	end
	--关底
	_editor_class["s2_boss_ls1"] = Class(laser)
	_editor_class["s2_boss_ls1"].init = function(self, _x, _y, a0, t0, u)
		laser.init(self, COLOR_BLUE, _x, _y, 0, 12, 200, 12, 6, 6, 0)
		self.rot = a0
		self.u = u
		laser.ChangeImage(self, 3, orginal)
		if (difficulty == 4) then
			lasttask = task.New(self, function()
				laser.grow(self, 60, true, true)
				task._Wait(10 + t0)
				_del(self, true)
			end)
		elseif (difficulty == 3) then
			lasttask = task.New(self, function()
				laser.grow(self, 70, true, true)
				task._Wait(10 + t0)
				_del(self, true)
			end)
		elseif (difficulty == 2) then
			lasttask = task.New(self, function()
				laser.grow(self, 80, true, true)
				task._Wait(10 + t0)
				_del(self, true)
			end)
		elseif (difficulty == 1) then
			lasttask = task.New(self, function()
				laser.grow(self, 90, true, true)
				task._Wait(10 + t0)
				_del(self, true)
			end)
		end
	end
	_editor_class["s2_boss_ls1"].del = function(self)
		self.class.base.del(self)
		if (difficulty == 4) then
			New(tasker, function()
				PlaySound("kira00", 0.5, 0, false)
				local a0, d, times, _x, _y = self.rot - 120 * self.u, 0, self.l2 / 15
				do
					local v, _d_v = (4), (-0.275)
					for _ = 1, times do
						_x, _y = self.x + d * cos(self.rot), self.y + d * sin(self.rot)
						last = New(_straight, grain_b, COLOR_BLUE, _x, _y, v, a0, false, 0, true, true, 0, false, 0, 0, 0, false)
						d = d + 15
						a0 = a0 + 5 * self.u
						task._Wait(2)
						v = v + _d_v
					end
				end
			end)
		elseif (difficulty == 3) then
			New(tasker, function()
				PlaySound("kira00", 0.5, 0, false)
				local a0, d, times, _x, _y = self.rot - 120 * self.u, 0, self.l2 / 20
				do
					local v, _d_v = (3), (-0.275)
					for _ = 1, times do
						_x, _y = self.x + d * cos(self.rot), self.y + d * sin(self.rot)
						last = New(_straight, grain_b, COLOR_BLUE, _x, _y, v, a0, false, 0, true, true, 0, false, 0, 0, 0, false)
						d = d + 20
						a0 = a0 + 5 * self.u
						task._Wait(2)
						v = v + _d_v
					end
				end
			end)
		elseif (difficulty == 2) then
			New(tasker, function()
				PlaySound("kira00", 0.5, 0, false)
				local a0, d, times, _x, _y = self.rot - 30 * self.u, 0, self.l2 / 25
				do
					local v, _d_v = (2.5), (0)
					for _ = 1, times do
						_x, _y = self.x + d * cos(self.rot), self.y + d * sin(self.rot)
						last = New(_straight, grain_b, COLOR_BLUE, _x, _y, v, a0, false, 0, true, true, 0, false, 0, 0, 0, false)
						d = d + 20
						a0 = a0 + 9 * self.u
						task._Wait(2)
						v = v + _d_v
					end
				end
			end)
		elseif (difficulty == 1) then
			New(tasker, function()
				PlaySound("kira00", 0.5, 0, false)
				local a0, d, times, _x, _y = self.rot, 0, self.l2 / 30
				do
					local v, _d_v = (3), (0)
					for _ = 1, times do
						_x, _y = self.x + d * cos(self.rot), self.y + d * sin(self.rot)
						last = New(_straight, grain_b, COLOR_BLUE, _x, _y, v, a0, false, 0, true, true, 0, false, 0, 0, 0, false)
						d = d + 30
						task._Wait(2)
						v = v + _d_v
					end
				end
			end)
		end
	end
	_editor_class["s2_boss_ls2"] = Class(laser)
	_editor_class["s2_boss_ls2"].init = function(self, _x, _y, a0)
		laser.init(self, COLOR_BLUE, _x, _y, 0, 12, 200, 12, 6, 6, 0)
		self.rot = a0
		laser.ChangeImage(self, 3, orginal)
		if (difficulty == 4) then
			lasttask = task.New(self, function()
				laser.grow(self, 60, true, true)
				task._Wait(10)
				_set_a(self, 0.06, a0, false)
			end)
		elseif (difficulty == 3) then
			lasttask = task.New(self, function()
				laser.grow(self, 70, true, true)
				task._Wait(38)
				_set_a(self, 0.05, a0, false)
			end)
		elseif (difficulty == 2) then
			lasttask = task.New(self, function()
				laser.grow(self, 80, true, true)
				task._Wait(38)
				_set_a(self, 0.04, a0, false)
			end)
		elseif (difficulty == 1) then
			lasttask = task.New(self, function()
				laser.grow(self, 90, true, true)
				task._Wait(38)
				_set_a(self, 0.03, a0, false)
			end)
		end
	end
	_editor_class["s2_boss_ls3"] = Class(laser)
	_editor_class["s2_boss_ls3"].init = function(self, _x, _y, a0)
		laser.init(self, COLOR_RED, _x, _y, 0, 32, 500, 32, 4, 0, 0)
		laser.ChangeImage(self, 2)
		self.colli = false
		self.rot = a0
		laser._TurnHalfOn(self, 1, false)
		if (difficulty == 4) then
			lasttask = task.New(self, function()
				laser.grow(self, 30, true, true)
				task._Wait(30)
				last = New(_editor_class["s2_boss_ls7"], self.x, self.y, self.rot)
				do
					local x, _d_x = (0), (1 / 19)
					for _ = 1, 20 do
						_object.set_color(self, "", 120 * (1 - x), 255, 255, 255)
						self.w = 4 + 8 * x
						task._Wait(1)
						x = x + _d_x
					end
				end
				self.hide = true
				do
					local v, _d_v = (5), (-0.3)
					local r, _d_r = (40), (20)
					local sp, _d_sp = (20), (2)
					for _ = 1, 10 do
						do
							local u, _d_u = (-1), (2)
							for _ = 1, 2 do
								for i = -2, 2 do
									last = New(_straight, kite, COLOR_RED, self.x + r * cos(self.rot), self.y + r * sin(self.rot), 0, self.rot + sp * u + 180 + 30*i, false, 0, true, true, 0, false, 0, 0, 0, false)
									egg.AddSimStrChV(last, 0, v, self.rot + 10 * u + 180 + 30*i, 30)
								end
								last = New(_straight, kite, COLOR_RED, self.x + r * cos(self.rot), self.y + r * sin(self.rot), 0, self.rot + sp * u, false, 0, true, true, 0, false, 0, 0, 0, false)
								egg.AddSimStrChV(last, 0, v, self.rot + 10 * u, 30)
								u = u + _d_u
							end
						end
						task._Wait(2)
						v = v + _d_v
						r = r + _d_r
						sp = sp + _d_sp
					end
				end
				_del(self, false)
			end)
		elseif (difficulty == 3) then
			lasttask = task.New(self, function()
				laser.grow(self, 40, true, true)
				task._Wait(30)
				last = New(_editor_class["s2_boss_ls7"], self.x, self.y, self.rot, 0.2*60)
				do
					local x, _d_x = (0), (1 / 19)
					for _ = 1, 20 do
						_object.set_color(self, "", 120 * (1 - x), 255, 255, 255)
						self.w = 4 + 8 * x
						task._Wait(1)
						x = x + _d_x
					end
				end
				self.hide = true
				do
					local v, _d_v = (4), (-0.3)
					local r, _d_r = (40), (25)
					local sp, _d_sp = (12), (2)
					for _ = 1, 8 do
						do
							local u, _d_u = (-1), (2)
							for _ = 1, 2 do
								for i = -2, 2 do
									last = New(_straight, kite, COLOR_RED, self.x + r * cos(self.rot), self.y + r * sin(self.rot), 0, self.rot + sp * u + 180 + 30*i, false, 0, true, true, 0, false, 0, 0, 0, false)
									egg.AddSimStrChV(last, 0, v, self.rot + 5 * u + 180 + 30*i, 30)
								end
								last = New(_straight, kite, COLOR_RED, self.x + r * cos(self.rot), self.y + r * sin(self.rot), 0, self.rot + sp * u, false, 0, true, true, 0, false, 0, 0, 0, false)
								egg.AddSimStrChV(last, 0, v, self.rot + 5 * u, 30)
								u = u + _d_u
							end
						end
						task._Wait(3)
						v = v + _d_v
						r = r + _d_r
						sp = sp + _d_sp
					end
				end
				_del(self, false)
			end)
		elseif (difficulty == 2) then
			lasttask = task.New(self, function()
				laser.grow(self, 50, true, true)
				task._Wait(30)
				last = New(_editor_class["s2_boss_ls7"], self.x, self.y, self.rot, 0.125*60)
				do
					local x, _d_x = (0), (1 / 19)
					for _ = 1, 20 do
						_object.set_color(self, "", 120 * (1 - x), 255, 255, 255)
						self.w = 4 + 8 * x
						task._Wait(1)
						x = x + _d_x
					end
				end
				self.hide = true
				do
					local v, _d_v = (4), (-0.3)
					local r, _d_r = (40), (25)
					local sp, _d_sp = (20), (2)
					for _ = 1, 8 do
						for i = -2, 2 do
							last = New(_straight, kite, COLOR_RED, self.x + r * cos(self.rot), self.y + r * sin(self.rot), 0, self.rot + 180 + 30*i, false, 0, true, true, 0, false, 0, 0, 0, false)
							egg.AddSimStrChV(last, 0, v, self.rot + 180 + 30*i, 30)
						end
						last = New(_straight, kite, COLOR_RED, self.x + r * cos(self.rot), self.y + r * sin(self.rot), 0, self.rot, false, 0, true, true, 0, false, 0, 0, 0, false)
						egg.AddSimStrChV(last, 0, v, self.rot, 30)
						task._Wait(3)
						v = v + _d_v
						r = r + _d_r
						sp = sp + _d_sp
					end
				end
				_del(self, false)
			end)
		elseif (difficulty == 1) then
			lasttask = task.New(self, function()
				laser.grow(self, 60, true, true)
				task._Wait(30)
				last = New(_editor_class["s2_boss_ls7"], self.x, self.y, self.rot, 0.1*60)
				do
					local x, _d_x = (0), (1 / 19)
					for _ = 1, 20 do
						_object.set_color(self, "", 120 * (1 - x), 255, 255, 255)
						self.w = 4 + 8 * x
						task._Wait(1)
						x = x + _d_x
					end
				end
				self.hide = true
				local v, _d_v = (4), (-0.3)
				local r, _d_r = (40), (25)
				local sp, _d_sp = (20), (2)
				for _ = 1, 8 do
					for i = -2, 2 do
						last = New(_straight, kite, COLOR_RED, self.x + r * cos(self.rot), self.y + r * sin(self.rot), 0, self.rot + 180 + 30*i, false, 0, true, true, 0, false, 0, 0, 0, false)
						egg.AddSimStrChV(last, 0, v, self.rot + 180 + 30*i, 30)
					end
					v = v + _d_v
					r = r + _d_r
					sp = sp + _d_sp
				end
				task._Wait(30)
				_del(self, false)
			end)
		end
	end
	--[[ 二非 --]]--[=[
	--]=]
	_editor_class["s2_boss_ls4"] = Class(laser)
	_editor_class["s2_boss_ls4"].init = function(self, _x, _y, a0, u)
		laser.init(self, COLOR_BLUE, _x, _y, 0, 12, 200, 12, 6, 6, 0)
		self.rot = a0
		self.u = u
		laser.ChangeImage(self, 3, orginal)
		if (difficulty == 4) then
			lasttask = task.New(self, function()
				laser.grow(self, 40, true, true)
				_del(self, true)
			end)
		elseif (difficulty == 3) then
			lasttask = task.New(self, function()
				laser.grow(self, 50, true, true)
				_del(self, true)
			end)
		elseif (difficulty == 2) then
			lasttask = task.New(self, function()
				laser.grow(self, 60, true, true)
				_del(self, true)
			end)
		elseif (difficulty == 1) then
			lasttask = task.New(self, function()
				laser.grow(self, 70, true, true)
				_del(self, true)
			end)
		end
	end
	_editor_class["s2_boss_ls4"].del = function(self)
		self.class.base.del(self)
		if (difficulty == 4) then
			New(tasker, function()
				PlaySound("kira00", 0.5, 0, false)
				local a0, d, times, _x, _y = self.rot - 12 * self.u, 0, self.l2 / 20
				do
					local v, _d_v = (3.5), (-0.2)
					for _ = 1, times do
						_x, _y = self.x + d * cos(self.rot), self.y + d * sin(self.rot)
						last = New(_straight, grain_b, COLOR_BLUE, _x, _y, v, a0, false, 0, true, true, 0, false, 0, 0, 0, false)
						d = d + 20
						a0 = a0 + 2 * self.u
						task._Wait(2)
						v = v + _d_v
					end
				end
			end)
		elseif (difficulty == 3) then
			New(tasker, function()
				PlaySound("kira00", 0.5, 0, false)
				local a0, d, times, _x, _y = self.rot - 12 * self.u, 0, self.l2 / 24
				do
					local v, _d_v = (3), (-0.175)
					for _ = 1, times do
						_x, _y = self.x + d * cos(self.rot), self.y + d * sin(self.rot)
						last = New(_straight, grain_b, COLOR_BLUE, _x, _y, v, a0, false, 0, true, true, 0, false, 0, 0, 0, false)
						d = d + 24
						a0 = a0 + 2 * self.u
						task._Wait(2)
						v = v + _d_v
					end
				end
			end)
		elseif (difficulty == 2) then
			New(tasker, function()
				PlaySound("kira00", 0.5, 0, false)
				local a0, d, times, _x, _y = self.rot - 12 * self.u, 0, self.l2 / 30
				do
					local v, _d_v = (2.5), (-0.15)
					for _ = 1, times do
						_x, _y = self.x + d * cos(self.rot), self.y + d * sin(self.rot)
						last = New(_straight, grain_b, COLOR_BLUE, _x, _y, v, a0, false, 0, true, true, 0, false, 0, 0, 0, false)
						d = d + 30
						a0 = a0 + 2.5 * self.u
						task._Wait(2)
						v = v + _d_v
					end
				end
			end)
		elseif (difficulty == 1) then
			New(tasker, function()
				PlaySound("kira00", 0.5, 0, false)
				local a0, d, times, _x, _y = self.rot - 12 * self.u, 0, self.l2 / 40
				do
					local v, _d_v = (2), (-0.125)
					for _ = 1, times do
						_x, _y = self.x + d * cos(self.rot), self.y + d * sin(self.rot)
						last = New(_straight, grain_b, COLOR_BLUE, _x, _y, v, a0, false, 0, true, true, 0, false, 0, 0, 0, false)
						d = d + 40
						a0 = a0 + 3 * self.u
						task._Wait(2)
						v = v + _d_v
					end
				end
			end)
		end
	end
	_editor_class["s2_boss_ls5"] = Class(laser)
	_editor_class["s2_boss_ls5"].init = function(self, _x, _y, a0)
		laser.init(self, COLOR_BLUE, _x, _y, 0, 12, 200, 12, 6, 6, 0)
		self.rot = a0
		laser.ChangeImage(self, 3, orginal)
		if (difficulty == 4) then
			lasttask = task.New(self, function()
				laser.grow(self, 40, true, true)
				task._Wait(10)
				_set_a(self, 0.06, a0, false)
			end)
		elseif (difficulty == 3) then
			lasttask = task.New(self, function()
				laser.grow(self, 50, true, true)
				task._Wait(10)
				_set_a(self, 0.05, a0, false)
			end)
		elseif (difficulty == 2) then
			lasttask = task.New(self, function()
				laser.grow(self, 60, true, true)
				task._Wait(10)
				_set_a(self, 0.04, a0, false)
			end)
		elseif (difficulty == 1) then
			lasttask = task.New(self, function()
				laser.grow(self, 70, true, true)
				task._Wait(10)
				_set_a(self, 0.03, a0, false)
			end)
		end
	end
	_editor_class["s2_boss_ls6"] = Class(laser)
	_editor_class["s2_boss_ls6"].init = function(self, _x, _y, a0)
		laser.init(self, COLOR_RED, _x, _y, 0, 32, 500, 32, 4, 0, 0)
		laser.ChangeImage(self, 2)
		self.colli = false
		self.rot = a0
		laser._TurnHalfOn(self, 1, false)
		if (difficulty == 4) then
			lasttask = task.New(self, function()
				laser.grow(self, 30, true, true)
				task._Wait(30)
				last = New(_editor_class["s2_boss_ls7"], self.x, self.y, self.rot)
				do
					local x, _d_x = (0), (1 / 19)
					for _ = 1, 20 do
						_object.set_color(self, "", 120 * (1 - x), 255, 255, 255)
						self.w = 4 + 8 * x
						task._Wait(1)
						x = x + _d_x
					end
				end
				self.hide = true
				do
					local v, _d_v = (5), (-0.3)
					local r, _d_r = (40), (20)
					local sp, _d_sp = (18), (2)
					for _ = 1, 10 do
						do
							local u, _d_u = (-1), (2)
							for _ = 1, 2 do
								for i = 0, 1 do
									last = New(_straight, kite, COLOR_RED, self.x + r * cos(self.rot), self.y + r * sin(self.rot), 0, self.rot + sp * u, false, 0, true, true, 0, false, 0, 0, 0, false)
									egg.AddSimStrChV(last, 0, v, self.rot + 10 * u + 180*i, 30)
								end
								u = u + _d_u
							end
						end
						task._Wait(2)
						v = v + _d_v
						r = r + _d_r
						sp = sp + _d_sp
					end
				end
				_del(self, false)
			end)
		elseif (difficulty == 3) then
			lasttask = task.New(self, function()
				laser.grow(self, 40, true, true)
				task._Wait(30)
				last = New(_editor_class["s2_boss_ls7"], self.x, self.y, self.rot, 0.2*60)
				do
					local x, _d_x = (0), (1 / 19)
					for _ = 1, 20 do
						_object.set_color(self, "", 120 * (1 - x), 255, 255, 255)
						self.w = 4 + 8 * x
						task._Wait(1)
						x = x + _d_x
					end
				end
				self.hide = true
				do
					local v, _d_v = (4), (-0.3)
					local r, _d_r = (40), (25)
					local sp, _d_sp = (12), (2)
					for _ = 1, 8 do
						do
							local u, _d_u = (-1), (2)
							for _ = 1, 2 do
								for i = 0, 1 do
									last = New(_straight, kite, COLOR_RED, self.x + r * cos(self.rot), self.y + r * sin(self.rot), 0, self.rot + sp * u, false, 0, true, true, 0, false, 0, 0, 0, false)
									egg.AddSimStrChV(last, 0, v, self.rot + 5 * u + 180*i, 30)
								end
								u = u + _d_u
							end
						end
						task._Wait(3)
						v = v + _d_v
						r = r + _d_r
						sp = sp + _d_sp
					end
				end
				_del(self, false)
			end)
		elseif (difficulty == 2) then
			lasttask = task.New(self, function()
				laser.grow(self, 50, true, true)
				task._Wait(30)
				last = New(_editor_class["s2_boss_ls7"], self.x, self.y, self.rot, 0.125*60)
				do
					local x, _d_x = (0), (1 / 19)
					for _ = 1, 20 do
						_object.set_color(self, "", 120 * (1 - x), 255, 255, 255)
						self.w = 4 + 8 * x
						task._Wait(1)
						x = x + _d_x
					end
				end
				self.hide = true
				do
					local v, _d_v = (4), (-0.3)
					local r, _d_r = (40), (25)
					local sp, _d_sp = (20), (2)
					for _ = 1, 8 do
						for i = 0, 1 do
							last = New(_straight, kite, COLOR_RED, self.x + r * cos(self.rot), self.y + r * sin(self.rot), 0, self.rot, false, 0, true, true, 0, false, 0, 0, 0, false)
							egg.AddSimStrChV(last, 0, v, self.rot + 180*i, 30)
						end
						task._Wait(3)
						v = v + _d_v
						r = r + _d_r
						sp = sp + _d_sp
					end
				end
				_del(self, false)
			end)
		elseif (difficulty == 1) then
			lasttask = task.New(self, function()
				laser.grow(self, 60, true, true)
				task._Wait(30)
				last = New(_editor_class["s2_boss_ls7"], self.x, self.y, self.rot, 0.1*60)
				do
					local x, _d_x = (0), (1 / 19)
					for _ = 1, 20 do
						_object.set_color(self, "", 255 * (1 - x), 255, 255, 255)
						self.w = 4 + 8 * x
						task._Wait(1)
						x = x + _d_x
					end
				end
				local v, _d_v = (4), (-0.3)
				local r, _d_r = (40), (25)
				local sp, _d_sp = (20), (2)
				for _ = 1, 8 do
					last = New(_straight, kite, COLOR_RED, self.x + r * cos(self.rot), self.y + r * sin(self.rot), 0, self.rot, false, 0, true, true, 0, false, 0, 0, 0, false)
					egg.AddSimStrChV(last, 0, v, self.rot + 180, 30)
					task._Wait(3)
					v = v + _d_v
					r = r + _d_r
					sp = sp + _d_sp
				end
				self.hide = true
				task._Wait(30)
				_del(self, false)
			end)
		end
	end
	--[[ 射线 --]]--[=[
	--]=]
	_editor_class["s2_boss_ls7"] = Class(laser)
	_editor_class["s2_boss_ls7"].init = function(self, _x, _y, a, v)
		laser.init(self, COLOR_RED, _x, _y, 0, 0, 0, 0, 8, 4, 0)
		lasttask = task.New(self, function()
			self.rot = a
			self.undestoryable = true
			laser._TurnOn(self, 1, false, false)
			PlaySound("lazer01", 0.4, 0, false)
			--_set_a(self, 0.25, a, false)
			v = v or 0.25*60
			egg.AddSimStrChV(self, 0, v, a, 60)
			lasttask = task.New(self, function()
				task._Wait(10)
				self.node = 0
			end)
			do
				local l, _d_l = (40), (3)
				for _ = 1, 60 do
					self.l1 = 0.4 * l
					self.l2 = 0.4 * l
					self.l3 = 0.4 * l
					task._Wait(1)
					l = l + _d_l
				end
			end
			_del(self, true)
		end)
	end
	--sf
	_editor_class["sf_激光蓄力_粒子"] = Class(bullet)
	_editor_class["sf_激光蓄力_粒子"].init = function(self, _x, _y, mst, r, g, b)
		bullet.init(self, ball_big, COLOR_GRAY, false, false)
		self.x, self.y = _x, _y
		self.r = r
		self.g = g
		self.b = b
		self.omiga = 4
		self.group = GROUP_GHOST
		lasttask = task.New(self, function()
			do
				for _ = 1, _infinite do
					self.layer = LAYER_TOP - 1
					task._Wait(1)
				end
			end
		end)
		if (IsValid(mst)) then
			_connect(mst, self, 0, true)
		else
			_del(self, false)
		end
		self.timer = 11
		self.bound = false
		self.colli = false
		_object.set_color(self, "mul+add", 255, self.r, self.g, self.b)
		self.vscale = 0.1
		self.hscale = 0.1
		lasttask = task.New(self, function()
			local angle = ran:Float(0, 360)
			local v = ran:Float(1, 3)
			lasttask = task.New(self, function()
				task._Wait(40)
				do
					local al, _d_al = (255), (-12)
					for _ = 1, 20 do
						_object.set_color(self, "mul+add", al, self.r, self.g, self.b)
						task._Wait(1)
						al = al + _d_al
					end
				end
				_del(self, false)
			end)
			do
				local t, _d_t = (0), (90 / 59)
				for _ = 1, 60 do
					SetV2(self, v * cos(t), angle, true, false)
					task._Wait(1)
					t = t + _d_t
				end
			end
		end)
	end
	_editor_class["sf_激光蓄力"] = Class(_object)
	_editor_class["sf_激光蓄力"].init = function(self, _x, _y, r1, g1, b1, r2, g2, b2, r3, g3, b3)
		self.x, self.y = _x, _y
		self.img = "img_void"
		self.layer = LAYER_ENEMY_BULLET
		self.group = GROUP_GHOST
		self.hide = true
		self.bound = true
		self.navi = false
		self.hp = 10
		self.maxhp = 10
		self.colli = false
		self._servants = {}
		self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
		if (IsValid(_boss)) then
			_connect(_boss, self, 0, true)
		else
			_del(self, false)
		end
		lasttask = task.New(self, function()
			local judge = ran:Sign()
			PlaySound("ch00", 0.4, self.x / 256, false)
			task._Wait(20)
			last = New(_editor_class["sf_激光蓄力效果收缩"], self.x, self.y, self, r1, g1, b1)
			lasttask = task.New(self, function()
				do
					for _ = 1, 30 do
						do
							for _ = 1, 6 do
								last = New(_editor_class["sf_激光蓄力_粒子"], self.x, self.y, self, r3, g3, b3)
								task._Wait(0)
							end
						end
						task._Wait(1)
					end
				end
			end)
			do
				for _ = 1, 40 do
					do
						for _ = 1, 1 do
							last = New(_editor_class["sf_激光蓄力拉长"], self.x, self.y, self, r2, g2, b2, -1 * judge)
							last = New(_editor_class["sf_激光蓄力拉长"], self.x, self.y, self, r2, g2, b2, judge)
							last = New(_editor_class["sf_激光蓄力拉长"], self.x, self.y, self, r3, g3, b3, -1 * judge)
							last = New(_editor_class["sf_激光蓄力拉长"], self.x, self.y, self, r3, g3, b3, judge)
							task._Wait(0)
						end
					end
					task._Wait(1)
				end
			end
			task._Wait(200)
			_del(self, false)
		end)
	end
	_editor_class["sf_激光蓄力_无摆动"] = Class(_object)
	_editor_class["sf_激光蓄力_无摆动"].init = function(self, _x, _y, r1, g1, b1, r2, g2, b2, r3, g3, b3)
		self.x, self.y = _x, _y
		self.img = "img_void"
		self.layer = LAYER_ENEMY_BULLET
		self.group = GROUP_GHOST
		self.hide = true
		self.bound = true
		self.navi = false
		self.hp = 10
		self.maxhp = 10
		self.colli = false
		self._servants = {}
		self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
		if (IsValid(_boss)) then
			_connect(_boss, self, 0, true)
		else
			_del(self, false)
		end
		lasttask = task.New(self, function()
			PlaySound("ch00", 0.4, self.x / 256, false)
			task._Wait(20)
			last = New(_editor_class["sf_激光蓄力效果收缩"], self.x, self.y, self, r1, g1, b1)
			lasttask = task.New(self, function()
				do
					for _ = 1, 30 do
						do
							for _ = 1, 4 do
								last = New(_editor_class["sf_激光蓄力_粒子_无摆动"], self.x + ran:Float(-200, 200), self.y + ran:Float(-200, 200), self, r3, g3, b3)
								task._Wait(0)
							end
						end
						task._Wait(1)
					end
				end
			end)
			do
				for _ = 1, 40 do
					do
						for _ = 1, 1 do
							last = New(_editor_class["sf_激光蓄力拉长"], self.x, self.y, self, r2, g2, b2, 0)
							last = New(_editor_class["sf_激光蓄力拉长"], self.x, self.y, self, r3, g3, b3, 0)
							task._Wait(0)
						end
					end
					task._Wait(1)
				end
			end
			task._Wait(200)
			_del(self, false)
		end)
	end
	_editor_class["sf_激光蓄力_粒子_无摆动"] = Class(bullet)
	_editor_class["sf_激光蓄力_粒子_无摆动"].init = function(self, _x, _y, mst, r, g, b)
		bullet.init(self, ball_big, COLOR_GRAY, false, false)
		self.x, self.y = _x, _y
		self.omiga = 4
		self.r = r
		self.g = g
		self.b = b
		self.group = GROUP_GHOST
		lasttask = task.New(self, function()
			do
				for _ = 1, _infinite do
					self.layer = LAYER_BG + 1
					task._Wait(1)
				end
			end
		end)
		if (IsValid(mst)) then
			_connect(mst, self, 0, true)
		else
			_del(self, false)
		end
		self.timer = 11
		self.bound = false
		self.colli = false
		_object.set_color(self, "mul+add", 255, self.r, self.g, self.b)
		self.vscale = 0.1
		self.hscale = 0.1
		lasttask = task.New(self, function()
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (12)
					for _ = 1, 20 do
						_object.set_color(self, "mul+add", al, self.r, self.g, self.b)
						task._Wait(1)
						al = al + _d_al
					end
				end
			end)
			task.MoveTo(mst.x, mst.y, 60, MOVE_DECEL)
		end)
	end
	_editor_class["sf_激光蓄力效果收缩"] = Class(bullet)
	_editor_class["sf_激光蓄力效果收缩"].init = function(self, _x, _y, mst, r, g, b)
		bullet.init(self, ball_huge, COLOR_DEEP_GRAY, false, false)
		self.x, self.y = _x, _y
		self.group = GROUP_GHOST
		lasttask = task.New(self, function()
			do
				for _ = 1, _infinite do
					self.layer = LAYER_BG + 1
					task._Wait(1)
				end
			end
		end)
		if (IsValid(mst)) then
			_connect(mst, self, 0, true)
		else
			_del(self, false)
		end
		self.timer = 11
		self.bound = false
		self.colli = false
		lasttask = task.New(self, function()
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (1.5)
					local rr, _d_rr = (0), (r / 29)
					local gg, _d_gg = (0), (g / 29)
					local bb, _d_bb = (0), (b / 29)
					for _ = 1, 30 do
						_object.set_color(self, "mul+add", al, rr, gg, bb)
						task._Wait(1)
						al = al + _d_al
						rr = rr + _d_rr
						gg = gg + _d_gg
						bb = bb + _d_bb
					end
				end
			end)
			do
				local t, _d_t = (1), (-1 / 104)
				for _ = 1, 30 do
					self.hscale = 10 * t ^ 2
					self.vscale = 10 * t ^ 2
					task._Wait(1)
					t = t + _d_t
				end
			end
			do
				local t, _d_t = (1 - 29 / 104), (-1 / 104)
				for _ = 1, 75 do
					self.hscale = 10 * t ^ 2
					self.vscale = 10 * t ^ 2
					task._Wait(1)
					t = t + _d_t
				end
			end
			_del(self, false)
		end)
	end
	_editor_class["sf_激光蓄力拉长"] = Class(bullet)
	_editor_class["sf_激光蓄力拉长"].init = function(self, _x, _y, mst, r, g, b, judge)
		bullet.init(self, ball_big, COLOR_GRAY, false, false)
		self.x, self.y = _x, _y
		self.rot = ran:Float(0, 360)
		self.colli = false
		self.bound = false
		self.timer = 11
		self.group = GROUP_GHOST
		lasttask = task.New(self, function()
			do
				for _ = 1, _infinite do
					self.layer = LAYER_TOP - 1
					task._Wait(1)
				end
			end
		end)
		if (IsValid(mst)) then
			_connect(mst, self, 0, true)
		else
			_del(self, false)
		end
		self.vscale = ran:Float(0.1, 0.15)
		lasttask = task.New(self, function()
			lasttask = task.New(self, function()
				do
					local al, _d_al = (20), (2)
					local rr, _d_rr = (0), (r / 9)
					local gg, _d_gg = (0), (g / 9)
					local bb, _d_bb = (0), (b / 9)
					for _ = 1, 10 do
						_object.set_color(self, "mul+add", al, rr, gg, bb)
						task._Wait(1)
						al = al + _d_al
						rr = rr + _d_rr
						gg = gg + _d_gg
						bb = bb + _d_bb
					end
				end
				do
					local al, _d_al = (40), (2)
					for _ = 1, 40 do
						_object.set_color(self, "mul+add", al, r, g, b)
						task._Wait(1)
						al = al + _d_al
					end
				end
			end)
			do
				local t, _d_t = (1), (-1 / 54)
				for _ = 1, 55 do
					self.hscale = 25 * t ^ 2
					self.rot = self.rot + 0.5 * judge
					task._Wait(1)
					t = t + _d_t
				end
			end
			_del(self, false)
		end)
	end
	_editor_class["final_charge"] = Class(_object)
	_editor_class["final_charge"].init = function(self, _x, _y, r1, g1, b1, r2, g2, b2, r3, g3, b3)
		self.x, self.y = _x, _y
		self.img = "img_void"
		self.layer = LAYER_ENEMY_BULLET
		self.group = GROUP_NONTJT
		self.hide = true
		self.bound = true
		self.navi = false
		self.hp = 10
		self.maxhp = 10
		self.colli = false
		self._servants = {}
		self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
		lasttask = task.New(self, function()
			lasttask = task.New(self, function()
				do
					for _ = 1, 199 + 20 + 40 do
						PreserveObject(self)
						task._Wait(1)
					end
				end
			end)
			--[[ # --]]--[=[
            if (IsValid(_boss)) then
                _connect(_boss,self,0,true)
            else
                _del(self,false)
            end
        --]=]
			PlaySound("ch00", 0.4, self.x / 256, false)
			task._Wait(20)
			last = New(_editor_class["sf_终蓄力效果收缩"], self.x, self.y, self, r1, g1, b1)
			do
				for _ = 1, 40 do
					do
						for _ = 1, 4 do
							last = New(_editor_class["sf_终蓄力效果a"], self.x + ran:Float(-170, 170), self.y + ran:Float(-210, 210), self, r1, g1, b1)
							last = New(_editor_class["sf_终蓄力效果a"], self.x + ran:Float(-170, 170), self.y + ran:Float(-210, 210), self, r2, g2, b2)
							last = New(_editor_class["sf_终蓄力效果b"], self.x + ran:Float(-170, 170), self.y + ran:Float(-210, 210), self, r3, g3, b3)
							task._Wait(0)
						end
					end
					task._Wait(1)
				end
			end
			task._Wait(200)
			_del(self, false)
		end)
	end
	_editor_class["sf_终蓄力效果收缩"] = Class(bullet)
	_editor_class["sf_终蓄力效果收缩"].init = function(self, _x, _y, mst, r, g, b)
		bullet.init(self, ball_huge, COLOR_DEEP_GRAY, false, false)
		self.x, self.y = _x, _y
		self.group = GROUP_GHOST
		lasttask = task.New(self, _editor_tasks["sf_layer"](3, 0))
		lasttask = task.New(self, function()
			do
				for _ = 1, 199 + 20 + 40 do
					PreserveObject(self)
					task._Wait(1)
				end
			end
		end)
		if (IsValid(mst)) then
			_connect(mst, self, 0, true)
		else
			_del(self, false)
		end
		self.timer = 11
		self.bound = false
		self.colli = false
		lasttask = task.New(self, function()
			do
				local al, _d_al = (0), (3)
				local t, _d_t = (1), (-1 / 104)
				for _ = 1, 30 do
					_object.set_color(self, "mul+add", al, r, g, b)
					self.hscale = 10 * t ^ 2
					self.vscale = 10 * t ^ 2
					task._Wait(1)
					al = al + _d_al
					t = t + _d_t
				end
			end
			do
				local t, _d_t = (1 - 29 / 104), (-1 / 104)
				for _ = 1, 75 do
					_object.set_color(self, "mul+add", 125, r, g, b)
					self.hscale = 10 * t ^ 2
					self.vscale = 10 * t ^ 2
					task._Wait(1)
					t = t + _d_t
				end
			end
			_del(self, false)
		end)
	end
	_editor_class["sf_终蓄力效果a"] = Class(bullet)
	_editor_class["sf_终蓄力效果a"].init = function(self, _x, _y, mst, r, g, b)
		bullet.init(self, ball_light, COLOR_GRAY, false, false)
		self.x, self.y = _x, _y
		self.vscale = 0
		self.hscale = 0
		self.group = GROUP_GHOST
		lasttask = task.New(self, _editor_tasks["sf_layer"](3, 0))
		local AA = 0
		local BB = 0
		lasttask = task.New(self, function()
			do
				for _ = 1, 199 + 20 + 40 do
					PreserveObject(self)
					task._Wait(1)
				end
			end
		end)
		if (IsValid(mst)) then
			_connect(mst, self, 0, true)
		else
			_del(self, false)
		end
		self.navi = true
		self.timer = 11
		self.bound = false
		self.colli = false
		lasttask = task.New(self, function()
			local flagg = ran:Int(1, 2)
			AA = mst.x + ran:Float(-20, 20)
			BB = mst.y + ran:Float(-20, 20)
			lasttask = task.New(self, function()
				do
					local v, _d_v = (0), (0.07 / 9)
					local h, _d_h = (0), (0.3 / 9)
					local al, _d_al = (0), (255 / 9)
					for _ = 1, 10 do
						_object.set_color(self, "mul+add", al, r, g, b)
						self.vscale = v
						self.hscale = h
						task._Wait(1)
						v = v + _d_v
						h = h + _d_h
						al = al + _d_al
					end
				end
				task._Wait(30)
				do
					local al, _d_al = (255), (-12)
					for _ = 1, 20 do
						_object.set_color(self, "mul+add", al, r, g, b)
						task._Wait(1)
						al = al + _d_al
					end
				end
				_del(self, false)
			end)
			if (flagg % 2 == 1) then
				task.BezierMoveTo(60, MOVE_DECEL, self.x, self.y, 0.25 * Dist(self.x, self.y, AA, BB) * cos(Angle(self.x, self.y, AA, BB)) + (0.3 * Dist(self.x, self.y, AA, BB)) * cos(Angle(self.x, self.y, AA, BB) + 90) + self.x, 0.25 * Dist(self.x, self.y, AA, BB) * sin(Angle(self.x, self.y, AA, BB)) + (0.3 * Dist(self.x, self.y, AA, BB)) * sin(Angle(self.x, self.y, AA, BB) + 90) + self.y, 0.5 * Dist(self.x, self.y, AA, BB) * cos(Angle(self.x, self.y, AA, BB)) + (0.6 * Dist(self.x, self.y, AA, BB)) * cos(Angle(self.x, self.y, AA, BB) + 90) + self.x, 0.5 * Dist(self.x, self.y, AA, BB) * sin(Angle(self.x, self.y, AA, BB)) + (0.6 * Dist(self.x, self.y, AA, BB)) * sin(Angle(self.x, self.y, AA, BB) + 90) + self.y, 0.75 * Dist(self.x, self.y, AA, BB) * cos(Angle(self.x, self.y, AA, BB)) + (0.3 * Dist(self.x, self.y, AA, BB)) * cos(Angle(self.x, self.y, AA, BB) + 90) + self.x, 0.75 * Dist(self.x, self.y, AA, BB) * sin(Angle(self.x, self.y, AA, BB)) + (0.3 * Dist(self.x, self.y, AA, BB)) * sin(Angle(self.x, self.y, AA, BB) + 90) + self.y, AA, BB)
			else
				task.BezierMoveTo(60, MOVE_DECEL, self.x, self.y, 0.25 * Dist(self.x, self.y, AA, BB) * cos(Angle(self.x, self.y, AA, BB)) + (0.3 * Dist(self.x, self.y, AA, BB)) * cos(Angle(self.x, self.y, AA, BB) - 90) + self.x, 0.25 * Dist(self.x, self.y, AA, BB) * sin(Angle(self.x, self.y, AA, BB)) + (0.3 * Dist(self.x, self.y, AA, BB)) * sin(Angle(self.x, self.y, AA, BB) - 90) + self.y, 0.5 * Dist(self.x, self.y, AA, BB) * cos(Angle(self.x, self.y, AA, BB)) + (0.6 * Dist(self.x, self.y, AA, BB)) * cos(Angle(self.x, self.y, AA, BB) - 90) + self.x, 0.5 * Dist(self.x, self.y, AA, BB) * sin(Angle(self.x, self.y, AA, BB)) + (0.6 * Dist(self.x, self.y, AA, BB)) * sin(Angle(self.x, self.y, AA, BB) - 90) + self.y, 0.75 * Dist(self.x, self.y, AA, BB) * cos(Angle(self.x, self.y, AA, BB)) + (0.3 * Dist(self.x, self.y, AA, BB)) * cos(Angle(self.x, self.y, AA, BB) - 90) + self.x, 0.75 * Dist(self.x, self.y, AA, BB) * sin(Angle(self.x, self.y, AA, BB)) + (0.3 * Dist(self.x, self.y, AA, BB)) * sin(Angle(self.x, self.y, AA, BB) - 90) + self.y, AA, BB)
			end
		end)
	end
	_editor_class["sf_终蓄力效果b"] = Class(bullet)
	_editor_class["sf_终蓄力效果b"].init = function(self, _x, _y, mst, r, g, b)
		bullet.init(self, ball_light, COLOR_GRAY, false, false)
		self.x, self.y = _x, _y
		self.group = GROUP_GHOST
		self.vscale = 0
		self.hscale = 0
		local AA = 0
		local BB = 0
		lasttask = task.New(self, _editor_tasks["sf_layer"](3, 0))
		lasttask = task.New(self, function()
			do
				for _ = 1, 199 + 20 + 40 do
					PreserveObject(self)
					task._Wait(1)
				end
			end
		end)
		if (IsValid(mst)) then
			_connect(mst, self, 0, true)
		else
			_del(self, false)
		end
		self.navi = true
		self.timer = 11
		self.bound = false
		self.colli = false
		lasttask = task.New(self, function()
			local flagg = ran:Int(1, 2)
			AA = mst.x + ran:Float(-20, 20)
			BB = mst.y + ran:Float(-20, 20)
			lasttask = task.New(self, function()
				do
					local v, _d_v = (0), (0.07 / 9)
					local h, _d_h = (0), (0.3 / 9)
					local al, _d_al = (0), (255 / 9)
					for _ = 1, 10 do
						_object.set_color(self, "mul+add", al, r, g, b)
						self.vscale = v
						self.hscale = h
						task._Wait(1)
						v = v + _d_v
						h = h + _d_h
						al = al + _d_al
					end
				end
				task._Wait(30)
				do
					local al, _d_al = (255), (-12)
					for _ = 1, 20 do
						_object.set_color(self, "mul+add", al, r, g, b)
						task._Wait(1)
						al = al + _d_al
					end
				end
				_del(self, false)
			end)
			task.MoveTo(AA, BB, 60, MOVE_DECEL)
		end)
	end
	_editor_class["s2_立绘细光柱"] = Class(bullet)
	_editor_class["s2_立绘细光柱"].init = function(self, _x, _y, r, g, b, wave)
		bullet.init(self, ball_light_dark, COLOR_GRAY, false, false)
		self.x, self.y = _x, _y
		self.group = GROUP_GHOST
		self.colli = false
		self.bound = false
		self.timer = 11
		self.vscale = 0.06
		SetV2(self, 10, 180 + wave, true, false)
		lasttask = task.New(self, function()
			self.layer = LAYER_TOP - 2
			do
				local al, _d_al = (0), (255 / 4)
				for _ = 1, 5 do
					_object.set_color(self, "mul+add", al, r, g, b)
					task._Wait(1)
					al = al + _d_al
				end
			end
		end)
		lasttask = task.New(self, function()
			do
				local h, _d_h = (1), (0.5)
				for _ = 1, 30 do
					self.hscale = h
					task._Wait(1)
					h = h + _d_h
				end
			end
			task._Wait(200)
			_del(self, false)
		end)
	end
	_editor_class["s2_立绘细光柱"].kill = function(self)
	end
	_editor_class["s2_立绘细光柱"].del = function(self)
	end
	_editor_tasks["sf_layer"] = function(rank, layer)
		return function()
			local self = task.GetSelf()
			local list = { LAYER_BG + 1, LAYER_ENEMY, LAYER_ENEMY_BULLET, LAYER_TOP - 1 }
			self.layer = list[rank] + layer
		end
	end
end

local function s2_boss_common_action(boss_class)
	local _sc = boss.dialog.New(true)
	function _sc:init()
		player.dialog = true
		self.dialog_displayer = New(dialog_displayer)
		self._dialog_maintask = task.New(self, function()
			if not ext.sc_pr then
				if EISlib.stage.canDialog() then
					-- 第一段对话
					dialog.player.playScene("Stage2")
					dialog.player.waitSignal("boss fly in", dialog.enum.on)
					-- 进场
					task.MoveTo(0, 100, 120, MOVE_DECEL)
					-- 第二段对话
					dialog.player.setSignal("boss fly in complete", dialog.enum.on)
					-- 放音乐
					dialog.player.waitSignal("fade out BGM", dialog.enum.on)
					EISlib.stage.musicFadeOut("s2", 120)
					dialog.player.waitSignal("play BGM", dialog.enum.on)
					LoadMusicRecord("s2_boss")
					EISlib.stage.playMusic("s2_boss", 0, true)
					-- 开打
					dialog.player.waitUntilFinish()
					task.Wait(60)
					boss.show_aura(self, true)
				else
					-- 进场
					task.MoveTo(0, 100, 120, MOVE_DECEL)
					-- 放音乐
					EISlib.stage.musicFadeOut("s2", 120)
					LoadMusicRecord("s2_boss")
					EISlib.stage.playMusic("s2_boss", 0, true)
					-- 开打
					task.Wait(60)
					boss.show_aura(self, true)
				end
			else
				player.dialog = false
				boss_scpr_show(self, 0, 100)
			end
		end)
	end
	table.insert(boss_class.cards, _sc)
end

--Easy
do
	--道中boss
	local stage2mid_boss
	do
		stage2mid_boss = Class(boss)
		stage2mid_boss.cards = {}
		stage2mid_boss.name = "Emitsu"
		stage2mid_boss.init = function(self, cards)
			boss.init(self, 240, 384, "Emitsu", cards, New(s2_boss.scbg), "Easy")
			lstg.wis.Emitsu(self)
		end
		stage2mid_boss.bgm = "s2"
		stage2mid_boss._bg = stage2_background
		stage2mid_boss.difficulty = "Easy"

		boss_action(stage2mid_boss, 0, 100)
		_tmp_sc = boss.card.New("常规攻击", 2, 5, 30, 1000, { 0, 0, 0 }, false, "normal")
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					task._Wait(10)
					self._wisys:setAction("cast", 60)
					New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
					task._Wait(60)
					boss.show_aura(self, true)
				end
				PlaySound("lazer00", 0.5, 0, false)
				do
					local a0, _d_a0 = (0), (18)
					for _ = 1, 20 do
						last = New(_editor_class["stage2mid_boss_ls1"], self.x + 10 * cos(a0) + mirror_x, self.y + 10 * sin(a0) + mirror_y, 2.5, a0)
						task._Wait(2)
						a0 = a0 + _d_a0
					end
				end
				task._Wait(84)
				local u = -1
				do
					for _ = 1, _infinite do
						do
							for _ = 1, 2 do
								PlaySound("lazer00", 0.5, 0, false)
								do
									local a0, _d_a0 = (90 - 90 * u + ran:Float(-5, 5)), (18 * u)
									for _ = 1, 20 do
										last = New(_editor_class["stage2mid_boss_ls1"], self.x + 10 * cos(a0) + mirror_x, self.y + 10 * sin(a0) + mirror_y, 2.5, a0 + 45 * u)
										task._Wait(2)
										a0 = a0 + _d_a0
									end
								end
								task._Wait(40)
								u = -u
							end
						end
						task._Wait(40)
						task.MoveToPlayer(20, -96, 96, 90, 110, 16, 32, 8, 16, MOVE_NORMAL, MOVE_TOWARDS_PLAYER)
					end
				end
			end)
		end
		function _tmp_sc:del()
		end
		_tmp_sc.perform = false
		table.insert(stage2mid_boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2mid_boss:Easy", "常规攻击", _tmp_sc, #stage2mid_boss.cards, true })

		boss_action(stage2mid_boss, 0, 130)
		_tmp_sc = boss.card.New("镜符「荧光折镜」", 4, 7, 40, 1500, { 10, 20, 30 }, false)
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					s2_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
						task._Wait(60)
					end
				end
				local objs, count = {}, 1
				do
					local a0, _d_a0 = (0), (60)
					local t0, _d_t0 = (0), (10)
					for _ = 1, 6 do
						last = New(_editor_class["stage2mid_boss_obj4"], self.x + mirror_x, self.y + mirror_y, a0, t0)
						_connect(self, last, 0, true)
						objs[count] = last
						count = count + 1
						a0 = a0 + _d_a0
						t0 = t0 + _d_t0
					end
				end
				do
					local i, _d_i = (1), (1)
					for _ = 1, 6 do
						last = New(_editor_class["stage2mid_boss_ls5"], self.x + mirror_x, self.y + mirror_y, objs[i % 6 + 1], objs[(i + 1) % 6 + 1])
						i = i + _d_i
					end
				end
				count = 1
				do
					for _ = 1, _infinite do
						task._Wait(120)
						task.MoveToPlayer(60, -96, 96, 112, 144, 16, 32, 8, 16, MOVE_NORMAL, MOVE_X_TOWARDS_PLAYER)
						do
							local a0, _d_a0 = (ran:Float(0, 360)), (60)
							local t0, _d_t0 = (0), (10)
							for _ = 1, 6 do
								last = New(_editor_class["stage2mid_boss_obj4"], self.x + mirror_x, self.y + mirror_y, a0, t0)
								_connect(self, last, 0, true)
								objs[count] = last
								count = count + 1
								a0 = a0 + _d_a0
								t0 = t0 + _d_t0
							end
						end
						do
							local i, _d_i = (1), (1)
							for _ = 1, 6 do
								last = New(_editor_class["stage2mid_boss_ls5"], self.x + mirror_x, self.y + mirror_y, objs[i % 6 + 1], objs[(i + 1) % 6 + 1])
								i = i + _d_i
							end
						end
						count = 1
					end
				end
			end)
		end
		function _tmp_sc:del()
			if self.timeout == 1 then
				self.noExtendBonus = true
			else
				Spell_break_eff(self.x, self.y, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')
			end
		end
		_tmp_sc.perform = false
		table.insert(stage2mid_boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2mid_boss:Easy", "镜符「荧光折镜」", _tmp_sc, #stage2mid_boss.cards, true })

		_tmp_sc = boss.dialog.New(true)
		function _tmp_sc:init()
			player.dialog = true
			self.dialog_displayer = New(dialog_displayer)
			self._dialog_maintask = task.New(self, function()
				self.colli = false
				player.dialog = false
				if not self.noExtendBonus then
					misc.ShakeScreen(60, 3)
					PlaySound("enep01", 0.5, 0, false)
					_drop_item(item_bomb, 1, self.x, self.y)
				end
				task._Wait(120)
				task.MoveTo(150, 300, 90, MOVE_ACC_DEC)
				_del(self, true)
			end)
		end
		table.insert(stage2mid_boss.cards, _tmp_sc)
		_tmp_sc = boss.card.New("", 2, 15, 60, 600, { 0, 0, 0 }, false)
		function _tmp_sc:init()
			lasttask = task.New(self, function()
				task.MoveTo(0, 144, 180, MOVE_NORMAL)
			end)
		end
		function _tmp_sc:del()
		end
		_tmp_sc.perform = false
		table.insert(stage2mid_boss.cards, _tmp_sc)
	end
	_editor_class["stage2mid_boss:Easy"] = stage2mid_boss

	--关底子弹定义
	do
		_editor_class["s2_一符使魔预警:Easy"] = Class(laser)
		_editor_class["s2_一符使魔预警:Easy"].init = function(self, _x, _y, a, c, i)
			laser.init(self, c, _x, _y, 0, 0, 900, 0, 2, 0, 0)
			self.bound = false
			laser.ChangeImage(self, 4)
			_object.set_color(self, "mul+add", 0, 255, 255, 255)
			self.rot = a
			lasttask = task.New(self, function()
				do
					local aerfa, _d_aerfa = (-90), (360 / 20)
					for _ = 1, 20 do
						_object.set_color(self, "mul+add", 125 + 125 * sin(aerfa), 255, 255, 255)
						task._Wait(1)
						aerfa = aerfa + _d_aerfa
					end
				end
				do
					local v, _d_v = (0.02), (0.078)
					for _ = 1, 15 do
						last = New(_editor_class["s2_一符使魔预警虚影"], self.x, self.y, self.rot, self.rot + 90, v, c)
						last = New(_editor_class["s2_一符使魔预警虚影"], self.x, self.y, self.rot, self.rot - 90, v, c)
						task._Wait(1)
						v = v + _d_v
					end
				end
				task._Wait(45)
				last = New(_editor_class["s2_一符使魔:Easy"], self.x, self.y, 6, a, c, i)
				_del(self, true)
			end)
		end
		_editor_class["s2_一符使魔预警:Easy"].kill = function(self)
		end
		_editor_class["s2_一符使魔:Easy"] = Class(_object)
		_editor_class["s2_一符使魔:Easy"].init = function(self, _x, _y, v, a, c, i)
			self.x, self.y = _x, _y
			self.img = "image:mgmk1"
			self.layer = LAYER_ENEMY_BULLET
			self.group = GROUP_INDES
			self.hide = false
			self.bound = true
			self.navi = false
			self.hp = 75
			self.maxhp = 75
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.omiga = 4
			self.vscale = 0
			self.hscale = 0
			self.bound = false
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (255 / 10)
					local s, _d_s = (0), ((1 / 24) / 10)
					for _ = 1, 10 do
						_object.set_color(self, "mul+add", al, 0, 255, 0)
						self.vscale = s
						self.hscale = s
						task._Wait(1)
						al = al + _d_al
						s = s + _d_s
					end
				end
				SetV2(self, v, a, true, false)
				PlaySound("tan00", 0.1, self.x / 256, false)
				lasttask = task.New(self, function()
					do
						local aa, _d_aa = (a), (7.3 * i)
						for _ = 1, 180 do
							do
								local bb, _d_bb = (0), (120)
								for _ = 1, 3 do
									last = New(_editor_class["s2_一符飘感弹:Easy"], self.x, self.y, aa + bb, 2, c)
									task._Wait(0)
									bb = bb + _d_bb
								end
							end
							task._Wait(1)
							aa = aa + _d_aa
						end
					end
					_del(self, true)
				end)
			end)
		end
		_editor_class["s2_一符飘感弹:Easy"] = Class(bullet)
		_editor_class["s2_一符飘感弹:Easy"].init = function(self, _x, _y, a, v0, c)
			bullet.init(self, grain_b, c, false, true)
			self.x, self.y = _x, _y
			_object.set_color(self, "mul+add", 255, 255, 255, 255)
			self.bound = false
			SetV2(self, 0, a, true, false)
			lasttask = task.New(self, function()
				do
					local v, _d_v = (v0), ((0.01 - v0) / 30)
					for _ = 1, 30 do
						SetV2(self, v, a, true, false)
						task._Wait(1)
						v = v + _d_v
					end
				end
				_del(self, true)
			end)
		end
		_editor_class["s2_二符使魔:Easy"] = Class(_object)
		_editor_class["s2_二符使魔:Easy"].init = function(self, _x, _y, cx, cy)
			self.x, self.y = _x, _y
			self.img = "magic5"
			self.layer = LAYER_ENEMY_BULLET
			self.group = GROUP_INDES
			self.hide = false
			self.bound = true
			self.navi = false
			self.hp = 75
			self.maxhp = 75
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.omiga = 4
			self.vscale = 0
			self.hscale = 0
			self.bound = false
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (255 / 10)
					local s, _d_s = (0), (1 / 10)
					for _ = 1, 10 do
						_object.set_color(self, "mul+add", al, 255, 255, 255)
						self.vscale = s
						self.hscale = s
						task._Wait(1)
						al = al + _d_al
						s = s + _d_s
					end
				end
				lasttask = task.New(self, function()
					do
						for _ = 1, 15 do
							last = New(_editor_class["s2_二符使魔残影2"], self.x, self.y, self.rot)
							task._Wait(2)
						end
					end
				end)
				task.MoveTo(cx, cy, 30, MOVE_ACCEL)
				lasttask = task.New(self, function()
					misc.ShakeScreen(10, 3)
					task._Wait(30)
					if (cx > 0) then
						_set_a(self, 0.3, 0, false)
					else
						_set_a(self, 0.3, 180, false)
					end
					self.bound = true
					task._Wait(15)
					do
						local aerfa, _d_aerfa = (ran:Float(-25, 25)), (360 / 20)
						for _ = 1, 20 do
							last = New(_straight, water_drop, COLOR_CYAN, self.x, self.y, 1 + 2.5 * abs(sin(aerfa)), 270, false, 0, true, true, 0, false, 0, 0, 0, false)
							PlaySound("kira00", 0.1, self.x / 256, false)
							task._Wait(3)
							aerfa = aerfa + _d_aerfa
						end
					end
				end)
			end)
		end
		_editor_class["s2_二符发射使魔:Easy"] = Class(_object)
		_editor_class["s2_二符发射使魔:Easy"].init = function(self, _x, _y, x, y, j, a1, vv)
			self.x, self.y = _x, _y
			self.img = "magic6"
			self.layer = LAYER_ENEMY_BULLET
			self.group = GROUP_INDES
			self.hide = false
			self.bound = true
			self.navi = false
			self.hp = 75
			self.maxhp = 75
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.omiga = 4 * j
			self.vscale = 0
			self.hscale = 0
			self.bound = false
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (255 / 10)
					local s, _d_s = (0), (1 / 10)
					for _ = 1, 10 do
						_object.set_color(self, "mul+add", al, 255, 255, 255)
						self.vscale = s
						self.hscale = s
						task._Wait(1)
						al = al + _d_al
						s = s + _d_s
					end
				end
				task.MoveTo(x, y, 30, MOVE_ACCEL)
				do
					local a, _d_a = (a1), (60)
					for _ = 1, 6 do
						last = New(_editor_class["s2_二符发射火弹"], self.x, self.y, vv, a, j)
						task._Wait(0)
						a = a + _d_a
					end
				end
				task._Wait(60)
				_del(self, true)
			end)
		end
		_editor_class["s2_三符中玉圆中心:Easy"] = Class(_object)
		_editor_class["s2_三符中玉圆中心:Easy"].init = function(self, _x, _y, i, dr)
			self.x, self.y = _x, _y
			self.img = "img_void"
			self.layer = LAYER_ENEMY_BULLET - 1
			self.group = GROUP_INDES
			self.hide = true
			self.bound = true
			self.navi = false
			self.hp = 10
			self.maxhp = 10
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.bound = false
			lasttask = task.New(self, function()
				do
					local a, _d_a = (0), (40)
					for _ = 1, 9 do
						last = New(_editor_class["s2_三符中玉:Easy"], self.x, self.y, a, i, dr)
						_connect(self, last, 0, true)
						task._Wait(0)
						a = a + _d_a
					end
				end
				task._Wait(1200)
				_del(self, true)
			end)
		end
		_editor_class["s2_三符中玉:Easy"] = Class(bullet)
		_editor_class["s2_三符中玉:Easy"].init = function(self, _x, _y, a, i, dr)
			bullet.init(self, ball_big, COLOR_CYAN, false, false)
			self.x, self.y = _x, _y
			self.bound = false
			_object.set_color(self, "mul+add", 255, 255, 255, 255)
			lasttask = task.New(self, function()
				task._Wait(1500)
				self.bound = true
			end)
			lasttask = task.New(self, function()
				lasttask = task.New(self, function()
					do
						local a1, _d_a1 = (a), (0.18 * i)
						local r, _d_r = (0), (dr)
						for _ = 1, _infinite do
							_set_rel_pos(self, r * cos(a1), r * sin(a1), a1, true)
							task._Wait(1)
							a1 = a1 + _d_a1
							r = r + _d_r
						end
					end
				end)
			end)
		end
		_editor_class["s3_lsc激光:Easy"] = Class(bullet)
		_editor_class["s3_lsc激光:Easy"].init = function(self, _x, _y, a, t, r, g, b)
			bullet.init(self, ball_light, COLOR_GRAY, true, true)
			self.x, self.y = _x, _y
			self.rr = r
			self.gg = g
			self.bb = b
			self.t = t
			if (IsValid(_boss)) then
				_connect(_boss, self, 0, true)
			else
				_del(self, false)
			end
			_object.set_color(self, "mul+add", 255, 138, 43, 226)
			self.rot = a
			self.vscale = 0.05
			self.timer = 11
			self.bound = false
			self.colli = false
			self.group = GROUP_INDES
			lasttask = task.New(self, function()
				do
					local tt, _d_tt = (0), (self.t / 4.6 / 44)
					for _ = 1, 45 do
						self.rot = self.rot + tt
						task._Wait(1)
						tt = tt + _d_tt
					end
				end
				do
					for _ = 1, _infinite do
						while _boss.s3_lsc == 1 do
							task.Wait(1)
						end
						self.rot = self.rot + self.t / 4.6
						task._Wait(1)
					end
				end
			end)
			lasttask = task.New(self, function()
				do
					for _ = 1, _infinite do
						if (_boss.s3_lsc == 1) then
							task.Wait(30)
							New(_editor_class["LSC激光发射预警"], self.x, self.y, self.rot, 3)
							task.Wait(60)
							PlaySound("lazer00", 0.1, self.x / 256, false)
							PlaySound("lazer00", 0.1, self.x / 256, false)
							last = New(_editor_class["s3_lsc装饰"], self.x, self.y, self, self.rot)
							last = New(_editor_class["s3_lsc装饰"], self.x, self.y, self, self.rot)
							_boss.s3_lsc_active = 0
							task._Wait(1)
							_boss.s3_lsc = 0
							do
								local rr, _d_rr = (self.rr), ((138 - self.rr) / 59)
								local gg, _d_gg = (self.gg), ((43 - self.gg) / 59)
								local bb, _d_bb = (self.bb), ((226 - self.bb) / 59)
								for _ = 1, 60 do
									_object.set_color(self, "mul+add", 255, rr, g, bb)
									task._Wait(1)
									rr = rr + _d_rr
									gg = gg + _d_gg
									bb = bb + _d_bb
								end
							end
							task._Wait(150)
							do
								local rr, _d_rr = (138), ((self.rr - 138) / 59)
								local gg, _d_gg = (43), ((self.gg - 43) / 59)
								local bb, _d_bb = (226), ((self.bb - 226) / 59)
								for _ = 1, 60 do
									_object.set_color(self, "mul+add", 255, rr, g, bb)
									task._Wait(1)
									rr = rr + _d_rr
									gg = gg + _d_gg
									bb = bb + _d_bb
								end
							end
							_boss.s3_lsc_active = 1
						else
						end
						task._Wait(1)
					end
				end
			end)
			lasttask = task.New(self, function()
				do
					local h, _d_h = (0), (0.3)
					for _ = 1, 60 do
						self.hscale = h
						task._Wait(1)
						h = h + _d_h
					end
				end
				do
					local rr, _d_rr = (138), ((self.rr - 138) / 59)
					local gg, _d_gg = (43), ((self.gg - 43) / 59)
					local bb, _d_bb = (226), ((self.bb - 226) / 59)
					for _ = 1, 60 do
						_object.set_color(self, "mul+add", 255, rr, g, bb)
						task._Wait(1)
						rr = rr + _d_rr
						gg = gg + _d_gg
						bb = bb + _d_bb
					end
				end
				do
					for _ = 1, _infinite do
						if (abs(self.rot % 360 - Angle(self, player) % 360) < 0.5) then
							if (_boss.s3_lsc_active == 1) then
								_boss.s3_lsc = 1
							else
							end
						end
						task._Wait(1)
					end
				end
			end)
		end
		_editor_class["s3_lsc激光:Easy"].kill = function(self)
			--[[ # --]]--[=[
        PreserveObject(self)
    --]=]
			local cx, cy = cos(self.rot), sin(self.rot)
			for l = 0, 600, 12 do
				New(item_faith_minor, self.x + l * cx, self.y + l * cy)
			end


			--[[ # --]]--[=[
        self.group=GROUP_GHOST
        local d=self.vscale
        task.Clear(self)
        task.New(self,function()
            for i=1,30 do
                self.vscale=self.vscale-d/30
                task.Wait()
            end
            Del(self)
        end)
    --]=]
		end
		_editor_class["s3_lsc激光1:Easy"] = Class(bullet)
		_editor_class["s3_lsc激光1:Easy"].init = function(self, _x, _y, a, t, r, g, b)
			bullet.init(self, ball_light, COLOR_GRAY, true, true)
			self.x, self.y = _x, _y
			self.rr = r
			self.gg = g
			self.bb = b
			self.t = t
			if (IsValid(_boss)) then
				_connect(_boss, self, 0, true)
			else
				_del(self, false)
			end
			_object.set_color(self, "mul+add", 255, 138, 43, 226)
			self.rot = a
			self.vscale = 0.05
			self.timer = 11
			self.bound = false
			self.colli = false
			self.group = GROUP_INDES
			lasttask = task.New(self, function()
				do
					local tt, _d_tt = (0), (self.t / 5 / 44)
					for _ = 1, 45 do
						self.rot = self.rot + tt
						task._Wait(1)
						tt = tt + _d_tt
					end
				end
				do
					for _ = 1, _infinite do
						self.rot = self.rot + self.t / 5
						task._Wait(1)
					end
				end
			end)
			lasttask = task.New(self, function()
				do
					for _ = 1, _infinite do
						if (_boss.s3_lsc1 == 1) then
							PlaySound("lazer00", 0.1, self.x / 256, false)
							last = New(_editor_class["s3_lsc装饰"], self.x, self.y, self, self.rot)
							last = New(_editor_class["s3_lsc装饰"], self.x, self.y, self, self.rot)
							_boss.s3_lsc_active1 = 0
							task._Wait(1)
							_boss.s3_lsc1 = 0
							do
								local rr, _d_rr = (self.rr), ((138 - self.rr) / 59)
								local gg, _d_gg = (self.gg), ((43 - self.gg) / 59)
								local bb, _d_bb = (self.bb), ((226 - self.bb) / 59)
								for _ = 1, 60 do
									_object.set_color(self, "mul+add", 255, rr, g, bb)
									task._Wait(1)
									rr = rr + _d_rr
									gg = gg + _d_gg
									bb = bb + _d_bb
								end
							end
							task._Wait(150)
							do
								local rr, _d_rr = (138), ((self.rr - 138) / 59)
								local gg, _d_gg = (43), ((self.gg - 43) / 59)
								local bb, _d_bb = (226), ((self.bb - 226) / 59)
								for _ = 1, 60 do
									_object.set_color(self, "mul+add", 255, rr, g, bb)
									task._Wait(1)
									rr = rr + _d_rr
									gg = gg + _d_gg
									bb = bb + _d_bb
								end
							end
							_boss.s3_lsc_active1 = 1
						else
						end
						task._Wait(1)
					end
				end
			end)
			lasttask = task.New(self, function()
				do
					local h, _d_h = (0), (0.3)
					for _ = 1, 60 do
						self.hscale = h
						task._Wait(1)
						h = h + _d_h
					end
				end
				do
					local rr, _d_rr = (138), ((self.rr - 138) / 59)
					local gg, _d_gg = (43), ((self.gg - 43) / 59)
					local bb, _d_bb = (226), ((self.bb - 226) / 59)
					for _ = 1, 60 do
						_object.set_color(self, "mul+add", 255, rr, g, bb)
						task._Wait(1)
						rr = rr + _d_rr
						gg = gg + _d_gg
						bb = bb + _d_bb
					end
				end
				do
					for _ = 1, _infinite do
						if (abs(self.rot % 360 - Angle(self, player) % 360) < 0.5) then
							if (_boss.s3_lsc_active1 == 1) then
								_boss.s3_lsc1 = 1
							else
							end
						else
						end
						task._Wait(1)
					end
				end
			end)
		end
		_editor_class["s3_lsc激光1:Easy"].kill = function(self)
			local cx, cy = cos(self.rot), sin(self.rot)
			for l = 0, 600, 12 do
				New(item_faith_minor, self.x + l * cx, self.y + l * cy)
			end
		end
	end
	--关底boss定义
	local stage2boss
	do
		stage2boss = Class(boss)
		stage2boss.cards = {}
		stage2boss.name = "Emitsu"
		stage2boss.init = function(self, cards)
			boss.init(self, 240, 384, "Emitsu", cards, New(s2_boss.scbg), "Easy")
			lstg.wis.Emitsu(self)
		end
		stage2boss.bgm = "s2_boss"
		stage2boss._bg = stage2_background
		stage2boss.difficulty = "Easy"
		-- 入场
		s2_boss_common_action(stage2boss)
		-- 攻击
		_tmp_sc = boss.card.New("常规攻击1", 2, 5, 40, 1000, { 0, 0, 0 }, false, "normal")
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			--[[ E一非 --]]--[=[
    --]=]
			lasttask = task.New(self, function()
				do
					task._Wait(10)
					self._wisys:setAction("cast", 60)
					New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
					task._Wait(60)
				end
				local a0, t0, u, dsp = nil, 64, 1, 0
				do
					for _ = 1, _infinite do
						a0 = 90 + 90 * u
						do
							for _ = 1, 9 do
								last = New(_editor_class["s2_boss_ls1"], self.x + mirror_x + 10 * cos(a0), self.y + mirror_y + 10 * sin(a0), a0, t0, u)
								a0 = a0 - 18 * u
								task._Wait(3)
								last = New(_editor_class["s2_boss_ls2"], self.x + mirror_x + 10 * cos(a0), self.y + mirror_y + 10 * sin(a0), a0)
								a0 = a0 - 18 * u
								t0 = t0 - 6
								task._Wait(3)
							end
						end
						t0 = 64
						task._Wait(20)
						lasttask = task.New(self, function()
							task.MoveToPlayer(30, -96, 96, 110, 130, 16, 32, 8, 16, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
						end)
						do
							for _ = 1, 9 do
								last = New(_editor_class["s2_boss_ls1"], self.x + mirror_x + 10 * cos(a0), self.y + mirror_y + 10 * sin(a0), a0, t0, -u)
								a0 = a0 - 18 * u
								task._Wait(3)
								last = New(_editor_class["s2_boss_ls2"], self.x + mirror_x + 10 * cos(a0), self.y + mirror_y + 10 * sin(a0), a0)
								a0 = a0 - 18 * u
								t0 = t0 - 6
								task._Wait(3)
							end
						end
						t0 = 64
						u = -u
						task._Wait(150)
						a0 = Angle(self.x + mirror_x, self.y + mirror_y, player.x, player.y)
						last = New(_editor_class["s2_boss_ls3"], self.x + mirror_x, self.y + mirror_y, a0)
						task._Wait(90)
					end
				end
			end)
		end
		function _tmp_sc:del()
		end
		_editor_cards.s2_01_E = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage2boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2boss:Easy", "常规攻击1", _tmp_sc, #stage2boss.cards, true })

		boss_action(stage2boss, 0, 104)
		_tmp_sc = boss.card.New("风符「名为潘多拉的祭司II」", 3, 5, 60, 2000, { 10, 20, 30 }, false)
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					s2_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
						task._Wait(60)
					end
				end
				lasttask = task.New(self, function()
					local i = 1
					do
						local a, _d_a = (Angle(self, player) * i), (10.4)
						for _ = 1, _infinite do
							do
								local b, _d_b = (0), (90)
								for _ = 1, 4 do
									local c = ran:Float(-2, 2)
									last = New(_straight, arrow_big, 10, self.x + mirror_x + 64 * cos(a + b + c), self.y + mirror_y + 64 * sin(a + b + c), ran:Float(1, 2), a + b + c + 180, false, 0, true, true, 0, false, 0, 0, 0, false)
									task._Wait(0)
									b = b + _d_b
								end
							end
							task._Wait(8)
							a = a + _d_a
						end
					end
				end)
				do
					task._Wait(10)
					self._wisys:setAction("cast", 60)
					New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
					task._Wait(60)
				end
				local j = 1
				do
					for _ = 1, _infinite do
						do
							local a, _d_a = (Angle(self.x + mirror_x, self.y + mirror_y, player.x, player.y) - 70 * j), (140 / 4 * j)
							for _ = 1, 4 do
								last = New(_editor_class["s2_一符使魔预警:Easy"], self.x + mirror_x, self.y + mirror_y, a, COLOR_GREEN, j)
								task._Wait(15)
								a = a + _d_a
							end
						end
						j = -j
						task.MoveToPlayer(60, -64, 64, 112, 124, 16, 32, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
						task._Wait(30)
						task._Wait(60)
					end
				end
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')
		end
		_editor_cards.s2_11_E = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage2boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2boss:Easy", "风符「名为潘多拉的祭司II」", _tmp_sc, #stage2boss.cards, true })

		boss_action(stage2boss, 0, 120)
		_tmp_sc = boss.card.New("常规攻击2", 2, 5, 40, 1000, { 0, 0, 0 }, false, "normal")
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			--[[ E二非 --]]--[=[
    --]=]
			lasttask = task.New(self, function()
				do
					task._Wait(10)
					self._wisys:setAction("cast", 60)
					New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
					task._Wait(60)
				end
				local a0, t0, u, dsp, da = nil, 96, 1, 40, da
				do
					for _ = 1, _infinite do
						a0 = 90 + 90 * u + ran:Float(-5, 5)
						do
							for _ = 1, 9 do
								last = New(_editor_class["s2_boss_ls4"], self.x + 30 * cos(a0 + 120 * u) + mirror_x, self.y + 30 * sin(a0 + 120 * u) + mirror_y, a0, u)
								a0 = a0 + 21 * u
								task._Wait(4)
								last = New(_editor_class["s2_boss_ls5"], self.x + 30 * cos(a0 + 120 * u) + mirror_x, self.y + 30 * sin(a0 + 120 * u) + mirror_y, a0)
								a0 = a0 + 21 * u
								t0 = t0 - 12
								task._Wait(6)
							end
						end
						t0 = 96
						do
							for _ = 1, 9 do
								last = New(_editor_class["s2_boss_ls4"], self.x + 30 * cos(a0 + 120 * u) + mirror_x, self.y + 30 * sin(a0 + 120 * u) + mirror_y, a0, -u)
								a0 = a0 + 21 * u
								task._Wait(4)
								last = New(_editor_class["s2_boss_ls5"], self.x + 30 * cos(a0 + 120 * u) + mirror_x, self.y + 30 * sin(a0 + 120 * u) + mirror_y, a0)
								a0 = a0 + 21 * u
								t0 = t0 - 12
								task._Wait(6)
							end
						end
						t0 = 96
						task.MoveToPlayer(30, -96, 96, 110, 130, 16, 32, 8, 16, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
						task._Wait(60)
						a0 = Angle(self.x + mirror_x, self.y + mirror_y, player.x, player.y) + 5 * u
						da = -10 / 6 * u
						do
							for _ = 1, 7 do
								a0 = a0 + da
								last = New(_editor_class["s2_boss_ls6"], self.x + mirror_x, self.y + mirror_y, a0)
								task._Wait(9)
							end
						end
						u = -u
						task._Wait(120)
					end
				end
			end)
		end
		function _tmp_sc:del()
		end
		_editor_cards.s2_02_E = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage2boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2boss:Easy", "常规攻击2", _tmp_sc, #stage2boss.cards, true })

		boss_action(stage2boss, 0, 124)
		_tmp_sc = boss.card.New("水符「湖之圣杯VII」", 3, 5, 60, 1500, { 10, 20, 30 }, false)
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					s2_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
						task._Wait(60)
					end
				end
				local i = 1
				do
					for _ = 1, _infinite do
						PlaySound("tan00", 0.1, self.x / 256, false)
						local a = Angle(self, player)
						local j = i
						do
							local r, _d_r = (5), (25)
							local vv, _d_vv = (1), (2 / 8)
							for _ = 1, 4 do
								do
									local a1, _d_a1 = (a - 15 + 15 * j), (60)
									for _ = 1, 6 do
										last = New(_editor_class["s2_二符发射使魔:Easy"], self.x + mirror_x, self.y + mirror_y, self.x + r * cos(a1), self.y + r * sin(a1), j, a1, vv)
										_connect(self, last, 0, true)
										task._Wait(0)
										a1 = a1 + _d_a1
									end
								end
								PlaySound("tan00", 0.1, self.x / 256, false)
								j = -j
								task._Wait(10)
								r = r + _d_r
								vv = vv + _d_vv
							end
						end
						task._Wait(60)
						lasttask = task.New(self, function()
							do
								last = New(_editor_class["s2_二符使魔:Easy"], self.x + mirror_x, self.y + mirror_y, -5, 230)
								last = New(_editor_class["s2_二符使魔:Easy"], self.x + mirror_x, self.y + mirror_y, 5, 230)
							end
							task._Wait(90)
							do
								last = New(_editor_class["s2_二符使魔:Easy"], self.x + mirror_x, self.y + mirror_y, -5, 230)
								last = New(_editor_class["s2_二符使魔:Easy"], self.x + mirror_x, self.y + mirror_y, 5, 230)
							end
						end)
						task.MoveToPlayer(60, -96, 96, 112, 144, 16, 32, 8, 16, MOVE_NORMAL, MOVE_X_TOWARDS_PLAYER)
						task._Wait(180)
						i = -i
						task._Wait(0)
					end
				end
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')
		end
		_editor_cards.s2_12_E = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage2boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2boss:Easy", "水符「湖之圣杯VII」", _tmp_sc, #stage2boss.cards, true })

		boss_action(stage2boss, 0, 124)
		_tmp_sc = boss.card.New("正位「光之迷路」", 3, 5, 55, 2500, { 10, 20, 30 }, false)
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					s2_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
						task._Wait(60)
					end
				end
				lasttask = task.New(self, function()
					local i = 1
					do
						for _ = 1, _infinite do
							do
								task._Wait(10)
								self._wisys:setAction("cast", 60)
								New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
								task._Wait(60)
							end
							lasttask = task.New(self, function()
								do
									local dr, _d_dr = (1.5), (-0.15)
									for _ = 1, 4 do
										last = New(_editor_class["s2_三符中玉圆中心:Easy"], self.x + mirror_x, self.y + mirror_y, i, dr)
										PlaySound("tan00", 0.1, self.x / 256, false)
										i = -i
										task._Wait(24)
										dr = dr + _d_dr
									end
								end
							end)
							task._Wait(60)
							local a0 = Angle(self.x + mirror_x, self.y + mirror_y, player.x, player.y)
							do
								local a, _d_a = (a0), (60)
								for _ = 1, 6 do
									last = New(_editor_class["s2_三符激光预警"], self.x + mirror_x, self.y + mirror_y, a, COLOR_PURPLE, 0.08*60)
									task._Wait(0)
									a = a + _d_a
								end
							end
							task._Wait(120)
							do
								local a, _d_a = (a0 + 30), (60)
								for _ = 1, 6 do
									last = New(_editor_class["s2_三符激光预警"], self.x + mirror_x, self.y + mirror_y, a, COLOR_GREEN, 0.08*60)
									task._Wait(0)
									a = a + _d_a
								end
							end
							task._Wait(120)
							task._Wait(1)
						end
					end
				end)
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')
		end
		_editor_cards.s2_13_E = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage2boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2boss:Easy", "正位「光之迷路」", _tmp_sc, #stage2boss.cards, true })
	end
	_editor_class["stage2boss:Easy"] = stage2boss
end

--Normal
do
	--道中boss
	local stage2mid_boss
	do
		stage2mid_boss = Class(boss)
		stage2mid_boss.cards = {}
		stage2mid_boss.name = "Emitsu"
		stage2mid_boss.init = function(self, cards)
			boss.init(self, 240, 384, "Emitsu", cards, New(s2_boss.scbg), "Normal")
			lstg.wis.Emitsu(self)
		end
		stage2mid_boss.bgm = "s2"
		stage2mid_boss._bg = stage2_background
		stage2mid_boss.difficulty = "Normal"

		boss_action(stage2mid_boss, 0, 100)
		_tmp_sc = boss.card.New("常规攻击", 2, 5, 30, 1000, { 0, 0, 0 }, false, "normal")
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					task._Wait(10)
					self._wisys:setAction("cast", 60)
					New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
					task._Wait(60)
					boss.show_aura(self, true)
				end
				PlaySound("lazer00", 0.5, 0, false)
				do
					local a0, _d_a0 = (0), (18)
					for _ = 1, 20 do
						last = New(_editor_class["stage2mid_boss_ls1"], self.x + 10 * cos(a0) + mirror_x, self.y + 10 * sin(a0) + mirror_y, 2.5, a0)
						task._Wait(2)
						a0 = a0 + _d_a0
					end
				end
				task._Wait(84)
				local u = -1
				do
					for _ = 1, _infinite do
						do
							for _ = 1, 2 do
								PlaySound("lazer00", 0.5, 0, false)
								do
									local a0, _d_a0 = (90 - 90 * u + ran:Float(-5, 5)), (18 * u)
									for _ = 1, 20 do
										last = New(_editor_class["stage2mid_boss_ls1"], self.x + 10 * cos(a0) + mirror_x, self.y + 10 * sin(a0) + mirror_y, 2.5, a0 + 45 * u)
										task._Wait(2)
										a0 = a0 + _d_a0
									end
								end
								task._Wait(40)
								u = -u
							end
						end
						task._Wait(40)
						task.MoveToPlayer(20, -96, 96, 90, 110, 16, 32, 8, 16, MOVE_NORMAL, MOVE_TOWARDS_PLAYER)
					end
				end
			end)
		end
		function _tmp_sc:del()
		end
		_tmp_sc.perform = false
		table.insert(stage2mid_boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2mid_boss:Normal", "常规攻击", _tmp_sc, #stage2mid_boss.cards, true })

		boss_action(stage2mid_boss, 0, 100)
		_tmp_sc = boss.card.New("镜符「荧光折镜」", 4, 7, 40, 1500, { 10, 20, 30 }, false)
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					s2_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
						task._Wait(60)
					end
				end
				local objs, count = {}, 1
				do
					local a0, _d_a0 = (30), (60)
					local t0, _d_t0 = (0), (6)
					for _ = 1, 6 do
						last = New(_editor_class["stage2mid_boss_obj4"], self.x + mirror_x, self.y + mirror_y, a0, t0)
						_connect(self, last, 0, true)
						objs[count] = last
						count = count + 1
						a0 = a0 + _d_a0
						t0 = t0 + _d_t0
					end
				end
				do
					local i, _d_i = (1), (1)
					for _ = 1, 6 do
						last = New(_editor_class["stage2mid_boss_ls5"], self.x + mirror_x, self.y + mirror_y, objs[i % 6 + 1], objs[(i + 1) % 6 + 1])
						i = i + _d_i
					end
				end
				count = 1
				do
					for _ = 1, _infinite do
						task._Wait(120)
						task.MoveToPlayer(60, -96, 96, 80, 100, 16, 32, 8, 16, MOVE_NORMAL, MOVE_X_TOWARDS_PLAYER)
						do
							local a0, _d_a0 = (ran:Float(0, 360)), (60)
							local t0, _d_t0 = (0), (6)
							for _ = 1, 6 do
								last = New(_editor_class["stage2mid_boss_obj4"], self.x + mirror_x, self.y + mirror_y, a0, t0)
								_connect(self, last, 0, true)
								objs[count] = last
								count = count + 1
								a0 = a0 + _d_a0
								t0 = t0 + _d_t0
							end
						end
						do
							local i, _d_i = (1), (1)
							for _ = 1, 6 do
								last = New(_editor_class["stage2mid_boss_ls5"], self.x + mirror_x, self.y + mirror_y, objs[i % 6 + 1], objs[(i + 1) % 6 + 1])
								i = i + _d_i
							end
						end
						count = 1
					end
				end
			end)
		end
		function _tmp_sc:del()
			if self.timeout == 1 then
				self.noExtendBonus = true
			else
				Spell_break_eff(self.x, self.y, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')
			end
		end
		_tmp_sc.perform = false
		table.insert(stage2mid_boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2mid_boss:Normal", "镜符「荧光折镜」", _tmp_sc, #stage2mid_boss.cards, true })

		_tmp_sc = boss.dialog.New(true)
		function _tmp_sc:init()
			player.dialog = true
			self.dialog_displayer = New(dialog_displayer)
			self._dialog_maintask = task.New(self, function()
				self.colli = false
				player.dialog = false
				if not self.noExtendBonus then
					misc.ShakeScreen(60, 3)
					PlaySound("enep01", 0.5, 0, false)
					_drop_item(item_bomb, 1, self.x, self.y)
				end
				task._Wait(120)
				task.MoveTo(150, 300, 90, MOVE_ACC_DEC)
				_del(self, true)
			end)
		end
		table.insert(stage2mid_boss.cards, _tmp_sc)
		_tmp_sc = boss.card.New("", 2, 15, 60, 600, { 0, 0, 0 }, false)
		function _tmp_sc:init()
			lasttask = task.New(self, function()
				task.MoveTo(0, 144, 180, MOVE_NORMAL)
			end)
		end
		function _tmp_sc:del()
		end
		_tmp_sc.perform = false
		table.insert(stage2mid_boss.cards, _tmp_sc)
	end
	_editor_class["stage2mid_boss:Normal"] = stage2mid_boss

	--关底子弹定义
	do
		_editor_class["s2_一符使魔预警:Normal"] = Class(laser)
		_editor_class["s2_一符使魔预警:Normal"].init = function(self, _x, _y, a, c, i)
			laser.init(self, c, _x, _y, 0, 0, 900, 0, 2, 0, 0)
			self.bound = false
			laser.ChangeImage(self, 4)
			_object.set_color(self, "mul+add", 0, 255, 255, 255)
			self.rot = a
			lasttask = task.New(self, function()
				do
					local aerfa, _d_aerfa = (-90), (360 / 20)
					for _ = 1, 20 do
						_object.set_color(self, "mul+add", 125 + 125 * sin(aerfa), 255, 255, 255)
						task._Wait(1)
						aerfa = aerfa + _d_aerfa
					end
				end
				do
					local v, _d_v = (0.02), (0.078)
					for _ = 1, 15 do
						last = New(_editor_class["s2_一符使魔预警虚影"], self.x, self.y, self.rot, self.rot + 90, v, c)
						last = New(_editor_class["s2_一符使魔预警虚影"], self.x, self.y, self.rot, self.rot - 90, v, c)
						task._Wait(1)
						v = v + _d_v
					end
				end
				task._Wait(45)
				last = New(_editor_class["s2_一符使魔:Normal"], self.x, self.y, 6, a, c, i)
				_del(self, true)
			end)
		end
		_editor_class["s2_一符使魔预警:Normal"].kill = function(self)
		end
		_editor_class["s2_一符使魔:Normal"] = Class(_object)
		_editor_class["s2_一符使魔:Normal"].init = function(self, _x, _y, v, a, c, i)
			self.x, self.y = _x, _y
			self.img = "image:mgmk1"
			self.layer = LAYER_ENEMY_BULLET
			self.group = GROUP_INDES
			self.hide = false
			self.bound = true
			self.navi = false
			self.hp = 75
			self.maxhp = 75
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.omiga = 4
			self.vscale = 0
			self.hscale = 0
			self.bound = false
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (255 / 10)
					local s, _d_s = (0), ((1 / 24) / 10)
					for _ = 1, 10 do
						_object.set_color(self, "mul+add", al, 0, 255, 0)
						self.vscale = s
						self.hscale = s
						task._Wait(1)
						al = al + _d_al
						s = s + _d_s
					end
				end
				SetV2(self, v, a, true, false)
				PlaySound("tan00", 0.1, self.x / 256, false)
				lasttask = task.New(self, function()
					do
						local aa, _d_aa = (a), (7.3 * i)
						for _ = 1, 180 do
							do
								local bb, _d_bb = (0), (90)
								for _ = 1, 4 do
									last = New(_editor_class["s2_一符飘感弹:Normal"], self.x, self.y, aa + bb, 2.1, c)
									task._Wait(0)
									bb = bb + _d_bb
								end
							end
							task._Wait(1)
							aa = aa + _d_aa
						end
					end
					_del(self, true)
				end)
			end)
		end
		_editor_class["s2_一符飘感弹:Normal"] = Class(bullet)
		_editor_class["s2_一符飘感弹:Normal"].init = function(self, _x, _y, a, v0, c)
			bullet.init(self, grain_b, c, false, true)
			self.x, self.y = _x, _y
			_object.set_color(self, "mul+add", 255, 255, 255, 255)
			self.bound = false
			SetV2(self, 0, a, true, false)
			lasttask = task.New(self, function()
				do
					local v, _d_v = (v0), ((0.01 - v0) / 30)
					for _ = 1, 30 do
						SetV2(self, v, a, true, false)
						task._Wait(1)
						v = v + _d_v
					end
				end
				_del(self, true)
			end)
		end
		_editor_class["s2_二符使魔:Normal"] = Class(_object)
		_editor_class["s2_二符使魔:Normal"].init = function(self, _x, _y, cx, cy)
			self.x, self.y = _x, _y
			self.img = "magic5"
			self.layer = LAYER_ENEMY_BULLET
			self.group = GROUP_INDES
			self.hide = false
			self.bound = true
			self.navi = false
			self.hp = 75
			self.maxhp = 75
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.omiga = 4
			self.vscale = 0
			self.hscale = 0
			self.bound = false
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (255 / 10)
					local s, _d_s = (0), (1 / 10)
					for _ = 1, 10 do
						_object.set_color(self, "mul+add", al, 255, 255, 255)
						self.vscale = s
						self.hscale = s
						task._Wait(1)
						al = al + _d_al
						s = s + _d_s
					end
				end
				lasttask = task.New(self, function()
					do
						for _ = 1, 15 do
							last = New(_editor_class["s2_二符使魔残影2"], self.x, self.y, self.rot)
							task._Wait(2)
						end
					end
				end)
				task.MoveTo(cx, cy, 30, MOVE_ACCEL)
				lasttask = task.New(self, function()
					misc.ShakeScreen(10, 3)
					task._Wait(30)
					if (cx > 0) then
						_set_a(self, 0.3, 0, false)
					else
						_set_a(self, 0.3, 180, false)
					end
					self.bound = true
					task._Wait(15)
					do
						local aerfa, _d_aerfa = (ran:Float(-25, 25)), (360 / 30)
						for _ = 1, 30 do
							last = New(_straight, water_drop, COLOR_CYAN, self.x, self.y, 1 + 2.5 * abs(sin(aerfa)), 270, false, 0, true, true, 0, false, 0, 0, 0, false)
							PlaySound("kira00", 0.1, self.x / 256, false)
							task._Wait(2)
							aerfa = aerfa + _d_aerfa
						end
					end
				end)
			end)
		end
		_editor_class["s2_二符发射使魔:Normal"] = Class(_object)
		_editor_class["s2_二符发射使魔:Normal"].init = function(self, _x, _y, x, y, j, a1, vv)
			self.x, self.y = _x, _y
			self.img = "magic6"
			self.layer = LAYER_ENEMY_BULLET
			self.group = GROUP_INDES
			self.hide = false
			self.bound = true
			self.navi = false
			self.hp = 75
			self.maxhp = 75
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.omiga = 4 * j
			self.vscale = 0
			self.hscale = 0
			self.bound = false
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (255 / 10)
					local s, _d_s = (0), (1 / 10)
					for _ = 1, 10 do
						_object.set_color(self, "mul+add", al, 255, 255, 255)
						self.vscale = s
						self.hscale = s
						task._Wait(1)
						al = al + _d_al
						s = s + _d_s
					end
				end
				task.MoveTo(x, y, 30, MOVE_ACCEL)
				do
					local a, _d_a = (a1), (90)
					for _ = 1, 4 do
						last = New(_editor_class["s2_二符发射火弹"], self.x, self.y, vv, a, j)
						task._Wait(0)
						a = a + _d_a
					end
				end
				task._Wait(60)
				_del(self, true)
			end)
		end
		_editor_class["s2_二符发射火弹"] = Class(bullet)
		_editor_class["s2_二符发射火弹"].init = function(self, _x, _y, v, a, i)
			bullet.init(self, grain_b, COLOR_BLUE, true, false)
			self.x, self.y = _x, _y
			self.bound = false
			lasttask = task.New(self, function()
				task._Wait(180)
				self.bound = true
			end)
			lasttask = task.New(self, function()
				do
					local aerfa, _d_aerfa = (0), (90 / 120)
					local a1, _d_a1 = (a), (120 / 120 * i)
					for _ = 1, 120 do
						SetV2(self, v * sin(aerfa), a1, true, false)
						task._Wait(1)
						aerfa = aerfa + _d_aerfa
						a1 = a1 + _d_a1
					end
				end
			end)
			self.scale = 2
			self.render_ani_flag = true
			self.img = "ani:s2_water_drop"
			_object.set_color(self, "mul+add", 255, 255, 255, 255)
			self.group = GROUP_GHOST
			last = New(_editor_class["s2_二符火弹sub"], self.x, self.y, self, self.scale / 2)
			local last_save = last
			lasttask = task.New(self, function()
				do
					for _ = 1, _infinite do
						if (IsValid(last_save)) then
						else
							_del(self, true)
						end
						task._Wait(1)
					end
				end
			end)
		end
		_editor_class["s2_三符中玉圆中心:Normal"] = Class(_object)
		_editor_class["s2_三符中玉圆中心:Normal"].init = function(self, _x, _y, i, dr)
			self.x, self.y = _x, _y
			self.img = "img_void"
			self.layer = LAYER_ENEMY_BULLET - 1
			self.group = GROUP_INDES
			self.hide = true
			self.bound = true
			self.navi = false
			self.hp = 10
			self.maxhp = 10
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.bound = false
			lasttask = task.New(self, function()
				do
					local a, _d_a = (0), (30)
					for _ = 1, 12 do
						last = New(_editor_class["s2_三符中玉:Normal"], self.x, self.y, a, i, dr)
						_connect(self, last, 0, true)
						task._Wait(0)
						a = a + _d_a
					end
				end
				task._Wait(1200)
				_del(self, true)
			end)
		end
		_editor_class["s2_三符中玉:Normal"] = Class(bullet)
		_editor_class["s2_三符中玉:Normal"].init = function(self, _x, _y, a, i, dr)
			bullet.init(self, ball_light, COLOR_CYAN, false, false)
			self.x, self.y = _x, _y
			self.bound = false
			lasttask = task.New(self, function()
				task._Wait(1500)
				self.bound = true
			end)
			lasttask = task.New(self, function()
				lasttask = task.New(self, function()
					do
						local a1, _d_a1 = (a), (0.18 * i)
						local r, _d_r = (0), (dr)
						for _ = 1, _infinite do
							_set_rel_pos(self, r * cos(a1), r * sin(a1), a1, true)
							task._Wait(1)
							a1 = a1 + _d_a1
							r = r + _d_r
						end
					end
				end)
			end)
		end
		_editor_class["s3_lsc激光:Normal"] = Class(bullet)
		_editor_class["s3_lsc激光:Normal"].init = function(self, _x, _y, a, t, r, g, b)
			bullet.init(self, ball_light, COLOR_GRAY, true, true)
			self.x, self.y = _x, _y
			self.rr = r
			self.gg = g
			self.bb = b
			self.t = t
			if (IsValid(_boss)) then
				_connect(_boss, self, 0, true)
			else
				_del(self, false)
			end
			_object.set_color(self, "mul+add", 255, 138, 43, 226)
			self.rot = a
			self.vscale = 0.05
			self.timer = 11
			self.bound = false
			self.colli = false
			self.group = GROUP_INDES
			lasttask = task.New(self, function()
				do
					local tt, _d_tt = (0), (self.t / 4 / 44)
					for _ = 1, 45 do
						self.rot = self.rot + tt
						task._Wait(1)
						tt = tt + _d_tt
					end
				end
				do
					for _ = 1, _infinite do
						while _boss.s3_lsc == 1 do
							task.Wait(1)
						end
						self.rot = self.rot + self.t / 4
						task._Wait(1)
					end
				end
			end)
			lasttask = task.New(self, function()
				do
					for _ = 1, _infinite do
						if (_boss.s3_lsc == 1) then
							task.Wait(30)
							New(_editor_class["LSC激光发射预警"], self.x, self.y, self.rot, 3)
							task.Wait(60)
							PlaySound("lazer00", 0.1, self.x / 256, false)
							last = New(_editor_class["s3_lsc装饰"], self.x, self.y, self, self.rot)
							last = New(_editor_class["s3_lsc装饰"], self.x, self.y, self, self.rot)
							_boss.s3_lsc_active = 0
							task._Wait(1)
							_boss.s3_lsc = 0
							do
								local rr, _d_rr = (self.rr), ((138 - self.rr) / 59)
								local gg, _d_gg = (self.gg), ((43 - self.gg) / 59)
								local bb, _d_bb = (self.bb), ((226 - self.bb) / 59)
								for _ = 1, 60 do
									_object.set_color(self, "mul+add", 255, rr, g, bb)
									task._Wait(1)
									rr = rr + _d_rr
									gg = gg + _d_gg
									bb = bb + _d_bb
								end
							end
							task._Wait(150)
							do
								local rr, _d_rr = (138), ((self.rr - 138) / 59)
								local gg, _d_gg = (43), ((self.gg - 43) / 59)
								local bb, _d_bb = (226), ((self.bb - 226) / 59)
								for _ = 1, 60 do
									_object.set_color(self, "mul+add", 255, rr, g, bb)
									task._Wait(1)
									rr = rr + _d_rr
									gg = gg + _d_gg
									bb = bb + _d_bb
								end
							end
							_boss.s3_lsc_active = 1
						else
						end
						task._Wait(1)
					end
				end
			end)
			lasttask = task.New(self, function()
				do
					local h, _d_h = (0), (0.3)
					for _ = 1, 60 do
						self.hscale = h
						task._Wait(1)
						h = h + _d_h
					end
				end
				do
					local rr, _d_rr = (138), ((self.rr - 138) / 59)
					local gg, _d_gg = (43), ((self.gg - 43) / 59)
					local bb, _d_bb = (226), ((self.bb - 226) / 59)
					for _ = 1, 60 do
						_object.set_color(self, "mul+add", 255, rr, g, bb)
						task._Wait(1)
						rr = rr + _d_rr
						gg = gg + _d_gg
						bb = bb + _d_bb
					end
				end
				do
					for _ = 1, _infinite do
						if (abs(self.rot % 360 - Angle(self, player) % 360) < 0.5) then
							if (_boss.s3_lsc_active == 1) then
								_boss.s3_lsc = 1
							else
							end
						end
						task._Wait(1)
					end
				end
			end)
		end
		_editor_class["s3_lsc激光:Normal"].kill = function(self)
			--[[ # --]]--[=[
        PreserveObject(self)
    --]=]
			local cx, cy = cos(self.rot), sin(self.rot)
			for l = 0, 600, 12 do
				New(item_faith_minor, self.x + l * cx, self.y + l * cy)
			end


			--[[ # --]]--[=[
        self.group=GROUP_GHOST
        local d=self.vscale
        task.Clear(self)
        task.New(self,function()
            for i=1,30 do
                self.vscale=self.vscale-d/30
                task.Wait()
            end
            Del(self)
        end)
    --]=]
		end
		_editor_class["s3_lsc激光1:Normal"] = Class(bullet)
		_editor_class["s3_lsc激光1:Normal"].init = function(self, _x, _y, a, t, r, g, b)
			bullet.init(self, ball_light, COLOR_GRAY, true, true)
			self.x, self.y = _x, _y
			self.rr = r
			self.gg = g
			self.bb = b
			self.t = t
			if (IsValid(_boss)) then
				_connect(_boss, self, 0, true)
			else
				_del(self, false)
			end
			_object.set_color(self, "mul+add", 255, 138, 43, 226)
			self.rot = a
			self.vscale = 0.05
			self.timer = 11
			self.bound = false
			self.colli = false
			self.group = GROUP_INDES
			lasttask = task.New(self, function()
				do
					local tt, _d_tt = (0), (self.t / 5 / 44)
					for _ = 1, 45 do
						self.rot = self.rot + tt
						task._Wait(1)
						tt = tt + _d_tt
					end
				end
				do
					for _ = 1, _infinite do
						self.rot = self.rot + self.t / 5
						task._Wait(1)
					end
				end
			end)
			lasttask = task.New(self, function()
				do
					for _ = 1, _infinite do
						if (_boss.s3_lsc1 == 1) then
							PlaySound("lazer00", 0.1, self.x / 256, false)
							last = New(_editor_class["s3_lsc装饰"], self.x, self.y, self, self.rot)
							last = New(_editor_class["s3_lsc装饰"], self.x, self.y, self, self.rot)
							_boss.s3_lsc_active1 = 0
							task._Wait(1)
							_boss.s3_lsc1 = 0
							do
								local rr, _d_rr = (self.rr), ((138 - self.rr) / 59)
								local gg, _d_gg = (self.gg), ((43 - self.gg) / 59)
								local bb, _d_bb = (self.bb), ((226 - self.bb) / 59)
								for _ = 1, 60 do
									_object.set_color(self, "mul+add", 255, rr, g, bb)
									task._Wait(1)
									rr = rr + _d_rr
									gg = gg + _d_gg
									bb = bb + _d_bb
								end
							end
							task._Wait(150)
							do
								local rr, _d_rr = (138), ((self.rr - 138) / 59)
								local gg, _d_gg = (43), ((self.gg - 43) / 59)
								local bb, _d_bb = (226), ((self.bb - 226) / 59)
								for _ = 1, 60 do
									_object.set_color(self, "mul+add", 255, rr, g, bb)
									task._Wait(1)
									rr = rr + _d_rr
									gg = gg + _d_gg
									bb = bb + _d_bb
								end
							end
							_boss.s3_lsc_active1 = 1
						else
						end
						task._Wait(1)
					end
				end
			end)
			lasttask = task.New(self, function()
				do
					local h, _d_h = (0), (0.3)
					for _ = 1, 60 do
						self.hscale = h
						task._Wait(1)
						h = h + _d_h
					end
				end
				do
					local rr, _d_rr = (138), ((self.rr - 138) / 59)
					local gg, _d_gg = (43), ((self.gg - 43) / 59)
					local bb, _d_bb = (226), ((self.bb - 226) / 59)
					for _ = 1, 60 do
						_object.set_color(self, "mul+add", 255, rr, g, bb)
						task._Wait(1)
						rr = rr + _d_rr
						gg = gg + _d_gg
						bb = bb + _d_bb
					end
				end
				do
					for _ = 1, _infinite do
						if (abs(self.rot % 360 - Angle(self, player) % 360) < 0.5) then
							if (_boss.s3_lsc_active1 == 1) then
								_boss.s3_lsc1 = 1
							else
							end
						else
						end
						task._Wait(1)
					end
				end
			end)
		end
		_editor_class["s3_lsc激光1:Normal"].kill = function(self)
			local cx, cy = cos(self.rot), sin(self.rot)
			for l = 0, 600, 12 do
				New(item_faith_minor, self.x + l * cx, self.y + l * cy)
			end
		end
	end
	--关底boss定义
	local stage2boss
	do
		stage2boss = Class(boss)
		stage2boss.cards = {}
		stage2boss.name = "Emitsu"
		stage2boss.init = function(self, cards)
			boss.init(self, 240, 384, "Emitsu", cards, New(s2_boss.scbg), "Normal")
			lstg.wis.Emitsu(self)
		end
		stage2boss.bgm = "s2_boss"
		stage2boss._bg = stage2_background
		stage2boss.difficulty = "Normal"
		-- 入场
		s2_boss_common_action(stage2boss)
		-- 攻击
		_tmp_sc = boss.card.New("常规攻击1", 2, 5, 40, 1000, { 0, 0, 0 }, false, "normal")
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			--[[ N一非 --]]--[=[
    --]=]
			lasttask = task.New(self, function()
				do
					task._Wait(10)
					self._wisys:setAction("cast", 60)
					New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
					task._Wait(60)
				end
				local a0, t0, u, dsp = nil, 64, 1, 0
				do
					for _ = 1, _infinite do
						a0 = 90 + 90 * u
						do
							for _ = 1, 12 do
								last = New(_editor_class["s2_boss_ls1"], self.x + mirror_x + 10 * cos(a0), self.y + mirror_y + 10 * sin(a0), a0, t0, u)
								a0 = a0 - 15 * u
								task._Wait(2)
								last = New(_editor_class["s2_boss_ls2"], self.x + mirror_x + 10 * cos(a0), self.y + mirror_y + 10 * sin(a0), a0)
								a0 = a0 - 15 * u
								t0 = t0 - 4
								task._Wait(2)
							end
						end
						t0 = 64
						task._Wait(20)
						lasttask = task.New(self, function()
							task.MoveToPlayer(30, -96, 96, 110, 130, 16, 32, 8, 16, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
						end)
						do
							for _ = 1, 12 do
								last = New(_editor_class["s2_boss_ls1"], self.x + mirror_x + 10 * cos(a0), self.y + mirror_y + 10 * sin(a0), a0, t0, -u)
								a0 = a0 - 15 * u
								task._Wait(2)
								last = New(_editor_class["s2_boss_ls2"], self.x + mirror_x + 10 * cos(a0), self.y + mirror_y + 10 * sin(a0), a0)
								a0 = a0 - 15 * u
								t0 = t0 - 4
								task._Wait(2)
							end
						end
						t0 = 64
						u = -u
						task._Wait(145)
						do
							for _ = 1, 2 do
								a0 = Angle(self.x + mirror_x, self.y + mirror_y, player.x, player.y)
								last = New(_editor_class["s2_boss_ls3"], self.x + mirror_x, self.y + mirror_y, a0)
								task._Wait(60)
							end
						end
						task._Wait(90)
					end
				end
			end)
		end
		function _tmp_sc:del()
		end
		_editor_cards.s2_01_N = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage2boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2boss:Normal", "常规攻击1", _tmp_sc, #stage2boss.cards, true })

		boss_action(stage2boss, 0, 104)
		_tmp_sc = boss.card.New("风符「名为潘多拉的祭司II」", 3, 5, 60, 2000, { 10, 20, 30 }, false)
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					s2_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
						task._Wait(60)
					end
				end
				lasttask = task.New(self, function()
					local i = 1
					do
						local a, _d_a = (Angle(self, player) * i), (8.1)
						for _ = 1, _infinite do
							do
								local b, _d_b = (0), (90)
								for _ = 1, 4 do
									local c = ran:Float(-2, 2)
									last = New(_straight, ellipse, COLOR_GREEN, self.x + mirror_x + 64 * cos(a + b + c), self.y + mirror_y + 64 * sin(a + b + c), ran:Float(1, 2), a + b + c + 180, false, 0, true, true, 0, false, 0, 0, 0, false)
									task._Wait(0)
									b = b + _d_b
								end
							end
							task._Wait(6)
							a = a + _d_a
						end
					end
				end)
				do
					task._Wait(10)
					self._wisys:setAction("cast", 60)
					New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
					task._Wait(60)
				end
				local j = 1
				do
					for _ = 1, _infinite do
						do
							local a, _d_a = (Angle(self.x + mirror_x, self.y + mirror_y, player.x, player.y) - 60 * j), (120 / 4 * j)
							for _ = 1, 5 do
								last = New(_editor_class["s2_一符使魔预警:Normal"], self.x + mirror_x, self.y + mirror_y, a, COLOR_GREEN, j)
								task._Wait(10)
								a = a + _d_a
							end
						end
						j = -j
						task.MoveToPlayer(60, -64, 64, 112, 124, 16, 32, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
						task._Wait(30)
						task._Wait(60)
					end
				end
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')
		end
		_editor_cards.s2_11_N = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage2boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2boss:Normal", "风符「名为潘多拉的祭司II」", _tmp_sc, #stage2boss.cards, true })

		boss_action(stage2boss, 0, 120)
		_tmp_sc = boss.card.New("常规攻击2", 2, 5, 40, 1000, { 0, 0, 0 }, false, "normal")
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			--[[ N二非 --]]--[=[
    --]=]
			lasttask = task.New(self, function()
				do
					task._Wait(10)
					self._wisys:setAction("cast", 60)
					New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
					task._Wait(60)
				end
				local a0, t0, u, dsp, da = nil, 96, 1, 40, da
				do
					for _ = 1, _infinite do
						a0 = 90 + 90 * u + ran:Float(-5, 5)
						do
							for _ = 1, 12 do
								last = New(_editor_class["s2_boss_ls4"], self.x + 30 * cos(a0 + 120 * u) + mirror_x, self.y + 30 * sin(a0 + 120 * u) + mirror_y, a0, u)
								a0 = a0 + 16 * u
								task._Wait(4)
								last = New(_editor_class["s2_boss_ls5"], self.x + 30 * cos(a0 + 120 * u) + mirror_x, self.y + 30 * sin(a0 + 120 * u) + mirror_y, a0)
								a0 = a0 + 16 * u
								t0 = t0 - 8
								task._Wait(4)
							end
						end
						t0 = 96
						do
							for _ = 1, 12 do
								last = New(_editor_class["s2_boss_ls4"], self.x + 30 * cos(a0 + 120 * u) + mirror_x, self.y + 30 * sin(a0 + 120 * u) + mirror_y, a0, -u)
								a0 = a0 + 16 * u
								task._Wait(4)
								last = New(_editor_class["s2_boss_ls5"], self.x + 30 * cos(a0 + 120 * u) + mirror_x, self.y + 30 * sin(a0 + 120 * u) + mirror_y, a0)
								a0 = a0 + 16 * u
								t0 = t0 - 8
								task._Wait(4)
							end
						end
						t0 = 96
						task.MoveToPlayer(30, -96, 96, 110, 130, 16, 32, 8, 16, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
						task._Wait(60)
						a0 = Angle(self.x + mirror_x, self.y + mirror_y, player.x, player.y) + 5 * u
						da = -10 / 6 * u
						do
							for _ = 1, 7 do
								a0 = a0 + da
								last = New(_editor_class["s2_boss_ls6"], self.x + mirror_x, self.y + mirror_y, a0)
								task._Wait(9)
							end
						end
						do
							for _ = 1, 7 do
								a0 = a0 - 1.5 * da
								last = New(_editor_class["s2_boss_ls6"], self.x + mirror_x, self.y + mirror_y, a0)
								task._Wait(9)
							end
						end
						u = -u
						task._Wait(90)
					end
				end
			end)
		end
		function _tmp_sc:del()
		end
		_editor_cards.s2_02_N = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage2boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2boss:Normal", "常规攻击2", _tmp_sc, #stage2boss.cards, true })

		boss_action(stage2boss, 0, 124)
		_tmp_sc = boss.card.New("水符「湖之圣杯VII」", 3, 5, 60, 1500, { 10, 20, 30 }, false)
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					s2_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
						task._Wait(60)
					end
				end
				local i = 1
				do
					for _ = 1, _infinite do
						PlaySound("tan00", 0.1, self.x / 256, false)
						local a = Angle(self, player)
						local j = i
						do
							local r, _d_r = (5), (15)
							local vv, _d_vv = (1), (2 / 8)
							for _ = 1, 8 do
								do
									local a1, _d_a1 = (a - 15 + 15 * j), (60)
									for _ = 1, 6 do
										last = New(_editor_class["s2_二符发射使魔:Normal"], self.x + mirror_x, self.y + mirror_y, self.x + r * cos(a1), self.y + r * sin(a1), i, a1, vv)
										_connect(self, last, 0, true)
										task._Wait(0)
										a1 = a1 + _d_a1
									end
								end
								PlaySound("tan00", 0.1, self.x / 256, false)
								j = -j
								task._Wait(5)
								r = r + _d_r
								vv = vv + _d_vv
							end
						end
						task._Wait(60)
						lasttask = task.New(self, function()
							do
								last = New(_editor_class["s2_二符使魔:Normal"], self.x + mirror_x, self.y + mirror_y, -5, 230)
								last = New(_editor_class["s2_二符使魔:Normal"], self.x + mirror_x, self.y + mirror_y, 5, 230)
							end
							task._Wait(60)
							do
								last = New(_editor_class["s2_二符使魔:Normal"], self.x + mirror_x, self.y + mirror_y, -5, 230)
								last = New(_editor_class["s2_二符使魔:Normal"], self.x + mirror_x, self.y + mirror_y, 5, 230)
							end
							task._Wait(60)
							do
								last = New(_editor_class["s2_二符使魔:Normal"], self.x + mirror_x, self.y + mirror_y, -5, 230)
								last = New(_editor_class["s2_二符使魔:Normal"], self.x + mirror_x, self.y + mirror_y, 5, 230)
							end
						end)
						task.MoveToPlayer(60, -96, 96, 112, 144, 16, 32, 8, 16, MOVE_NORMAL, MOVE_X_TOWARDS_PLAYER)
						task._Wait(180)
						i = -i
						task._Wait(0)
					end
				end
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')
		end
		_editor_cards.s2_12_N = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage2boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2boss:Normal", "水符「湖之圣杯VII」", _tmp_sc, #stage2boss.cards, true })

		boss_action(stage2boss, 0, 124)
		_tmp_sc = boss.card.New("正位「光之迷路」", 3, 5, 55, 2500, { 10, 20, 30 }, false)
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					s2_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
						task._Wait(60)
					end
				end
				lasttask = task.New(self, function()
					local i = 1
					do
						for _ = 1, _infinite do
							do
								task._Wait(10)
								self._wisys:setAction("cast", 60)
								New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
								task._Wait(60)
							end
							lasttask = task.New(self, function()
								do
									local dr, _d_dr = (2), (-0.15)
									for _ = 1, 6 do
										last = New(_editor_class["s2_三符中玉圆中心:Normal"], self.x + mirror_x, self.y + mirror_y, i, dr)
										PlaySound("tan00", 0.1, self.x / 256, false)
										i = -i
										task._Wait(16)
										dr = dr + _d_dr
									end
								end
							end)
							task._Wait(60)
							local a0 = Angle(self.x + mirror_x, self.y + mirror_y, player.x, player.y)
							do
								local a, _d_a = (a0), (40)
								for _ = 1, 9 do
									last = New(_editor_class["s2_三符激光预警"], self.x + mirror_x, self.y + mirror_y, a, COLOR_PURPLE, 0.125*60)
									task._Wait(0)
									a = a + _d_a
								end
							end
							task._Wait(90)
							do
								local a, _d_a = (a0 + 20), (40)
								for _ = 1, 9 do
									last = New(_editor_class["s2_三符激光预警"], self.x + mirror_x, self.y + mirror_y, a, COLOR_GREEN, 0.125*60)
									task._Wait(0)
									a = a + _d_a
								end
							end
							task._Wait(90)
							task._Wait(1)
						end
					end
				end)
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')
		end
		_editor_cards.s2_13_N = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage2boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2boss:Normal", "正位「光之迷路」", _tmp_sc, #stage2boss.cards, true })
	end
	_editor_class["stage2boss:Normal"] = stage2boss
end

--Hard
do
	--道中boss
	local stage2mid_boss
	--道中子弹定义
	local f1_1, f1_2
	do
		f1_1 = Class(laser)
		function f1_1:init(x, y, mst1, mst2)
			laser.init(self, COLOR_BLUE, x, y, 0, 6, 0, 6, 6, 6, 0)
			self.bound = false
			self.mst1, self.mst2 = mst1, mst2
			laser.ChangeImage(self, 1, orginal)
			task.New(self, function()
				laser._TurnOn(self, 30, false, true)
				while IsValid(mst1) and IsValid(mst2) do
					task.Wait(1)
				end
				PlaySound("kira00", 0.5, 0, false)
				local n = int(self.l2 / 10)
				local sp = 240
				local dsp = sp/(n-1)
				local a0, d, dx, dy, _x, _y, obj = self.rot + 90 - sp*0.5*(n-1), 0, cos(self.rot), sin(self.rot)
				for _ = 1, n do
					_x, _y = self.x + d * dx, self.y + d * dy
					obj = stg.newBulletStraight(stg.star_small, 1, true, _x, _y, 0, a0)
					egg.AddSimStrChV(obj, 0, 1.5, a0, 60)
					obj.omiga = 3
					_object.set_color(obj, "", 255, 255, 255, 255)
					d = d + 10
					a0 = a0 + dsp
				end
				Del(self)
			end)
		end
		function f1_1:frame()
			self.class.base.frame(self)
			--_object.set_color(self, "", 255, 255, 255 - 100 * self.killing / 30, 255 - 100 * self.killing / 30)
			if IsValid(self.mst1) and IsValid(self.mst2) then
				self.x, self.y = self.mst1.x, self.mst1.y
				self.rot = Angle(self.mst1, self.mst2)
				self.l2 = max(0, Dist(self.mst1, self.mst2) - 12)
			end
		end
		f1_2 = Class(object)
		function f1_2:init(x, y, v, a)
			self.x, self.y = x, y
			self.img = "magic6"
			self.layer = LAYER_ENEMY_BULLET
			self.group = GROUP_GHOST
			self.bound = true
			self.colli = true
			self._blend, self._a, self._r, self._g, self._b = '', 0, 255, 255, 255
			self.bound = false
			self.hscale, self.vscale = 0, 0
			task.New(self, function()
				egg.SimAlpCh(self, 0, 255, 30)
				egg.SimSizeCh(self, 0, 0.6, 30)
				egg.AddAccDecChV(self, v, a, 60, 60, 60)
				task.Wait(120)
				PlaySound("kira00")
				local a = Angle(self, player)
				for i = -1, 1 do
					for j = 0, 2 do
						stg.newBulletStraight(stg.ball_mid, 5, true, self.x, self.y, 2 + 0.5*j, a + 30*i)
					end
				end
				egg.SimAlpCh(self, 255, 0, 30)
				task.Wait(30)
				Del(self)
			end)
		end
		function f1_2:frame()
			task.Do(self)
		end
		function f1_2:render()
			SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
			Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
		end
	end

	do
		stage2mid_boss = Class(boss)
		stage2mid_boss.cards = {}
		stage2mid_boss.name = "Emitsu"
		stage2mid_boss.init = function(self, cards)
			boss.init(self, 240, 384, "Emitsu", cards, New(s2_boss.scbg), "Hard")
			lstg.wis.Emitsu(self)
		end
		stage2mid_boss.bgm = "s2"
		stage2mid_boss._bg = stage2_background
		stage2mid_boss.difficulty = "Hard"

		boss_action(stage2mid_boss, 0, 100)
		_tmp_sc = boss.card.New("常规攻击", 2, 5, 30, 1000, { 0, 0, 0 }, false, "normal")
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					task._Wait(10)
					self._wisys:setAction("cast", 60)
					New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
					task._Wait(60)
					boss.show_aura(self, true)
				end
				PlaySound("lazer00", 0.5, 0, false)
				do
					local a0, _d_a0 = (0), (15)
					for _ = 1, 24 do
						last = New(_editor_class["stage2mid_boss_ls1"], self.x + 10 * cos(a0) + mirror_x, self.y + 10 * sin(a0) + mirror_y, 3, a0)
						task._Wait(1)
						a0 = a0 + _d_a0
					end
				end
				task._Wait(72)
				local u = -1
				do
					for _ = 1, _infinite do
						do
							for _ = 1, 2 do
								last = New(_editor_class["stage2mid_boss_obj1"], self.x + 20 * u, self.y + 20, 90 - 60 * u, 90 - 60 * u)
								_connect(self, last, 0, true)
								PlaySound("lazer00", 0.5, 0, false)
								do
									local a0, _d_a0 = (90 - 90 * u + ran:Float(-5, 5)), (15 * u)
									for _ = 1, 24 do
										last = New(_editor_class["stage2mid_boss_ls1"], self.x + 10 * cos(a0) + mirror_x, self.y + 10 * sin(a0) + mirror_y, 3, a0 + 45 * u)
										task._Wait(1)
										a0 = a0 + _d_a0
									end
								end
								task._Wait(32)
								u = -u
							end
						end
						task._Wait(30)
						task.MoveToPlayer(20, -96, 96, 90, 110, 16, 32, 8, 16, MOVE_NORMAL, MOVE_TOWARDS_PLAYER)
					end
				end
			end)
		end
		function _tmp_sc:del()
		end
		_tmp_sc.perform = false
		table.insert(stage2mid_boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2mid_boss:Hard", "常规攻击", _tmp_sc, #stage2mid_boss.cards, true })

		boss_action(stage2mid_boss, 0, 154)
		_tmp_sc = boss.card.New("镜幻「四棱之境」", 4, 7, 40, 1500, { 10, 20, 30 }, false)
		--[[function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					s2_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
						task._Wait(60)
					end
				end
				local t0, r0 = 300, 250
				local t1, r1 = int(2.5 * t0 / sqrt(3)), 2.5 * r0 / sqrt(3)
				local dt = t1 - t0
				local x0, y0 = 0, 0
				lasttask = task.New(self, function()
					local objs, count = {}, 1
					do
						local a0, _d_a0 = (45), (90)
						for _ = 1, 4 do
							last = New(_editor_class["stage2mid_boss_obj2"], x0 + r0 * cos(a0) + mirror_x, y0 + r0 * sin(a0) + mirror_y, t0, 1, true)
							_connect(self, last, 0, true)
							objs[count] = last
							count = count + 1
							a0 = a0 + _d_a0
						end
					end
					task._Wait(90)
					PlaySound("lazer00", 0.5, 0, false)
					do
						local i, _d_i = (1), (1)
						for _ = 1, 4 do
							last = New(_editor_class["stage2mid_boss_ls2"], x0, y0, objs[i % 4 + 1], objs[(i + 1) % 4 + 1])
							i = i + _d_i
						end
					end
				end)
				lasttask = task.New(self, function()
					local objs, count = {}, 1
					do
						local a0, _d_a0 = (45), (90)
						for _ = 1, 4 do
							last = New(_editor_class["stage2mid_boss_obj2"], x0 + r1 * cos(a0) + mirror_x, y0 + r1 * sin(a0) + mirror_y, t1, -1, true)
							_connect(self, last, 0, true)
							objs[count] = last
							count = count + 1
							a0 = a0 + _d_a0
						end
					end
					task._Wait(90)
					do
						local i, _d_i = (1), (1)
						for _ = 1, 4 do
							last = New(_editor_class["stage2mid_boss_ls2"], x0, y0, objs[i % 6 + 1], objs[(i + 1) % 6 + 1])
							i = i + _d_i
						end
					end
				end)
				task._Wait(90)
				lasttask = task.New(self, function()
					task._Wait(240)
					do
						for _ = 1, _infinite do
							do
								local a, _d_a = (0), (15)
								for _ = 1, 24 do
									last = New(_straight, ball_mid, COLOR_PURPLE, self.x + mirror_x, self.y + mirror_y, 2.5, a, true, 0, true, true, 0, false, 0, 0, 0, false)
									a = a + _d_a
								end
							end
							task._Wait(90)
						end
					end
				end)
				local objs, count, u = {}, 1, 1
				do
					for _ = 1, _infinite do
						task._Wait(dt)
						do
							local a0, _d_a0 = (45), (90)
							for _ = 1, 4 do
								last = New(_editor_class["stage2mid_boss_obj2"], x0 + r1 * cos(a0), y0 + r1 * sin(a0), t1, u, false)
								_connect(self, last, 0, true)
								objs[count] = last
								count = count + 1
								a0 = a0 + _d_a0
							end
						end
						do
							local i, _d_i = (1), (1)
							for _ = 1, 4 do
								last = New(_editor_class["stage2mid_boss_ls2"], x0, y0, objs[i % 4 + 1], objs[(i + 1) % 4 + 1])
								i = i + _d_i
							end
						end
						count = 1
						u = -u
					end
				end
			end)
		end]]
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			local f1
			do
				function f1(x, y, v, a)
					local objs = {}
					for i = 1, 4 do
						table.insert(objs, New(f1_2, x, y, v, a + 45 + 90*i))
						_connect(self, objs[i], 0, true)
					end
					for i = 1, 4 do
						New(f1_1, objs[i].x, objs[i].y, objs[i], objs[(i)%4+1])
					end
				end
			end

			task.New(self, function()
				s2_boss.pic_show()
				task._Wait(120)
				do
					task._Wait(10)
					New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
					task._Wait(60)
				end
				PlaySound("tan00")
				f1(self.x + mirror_x, self.y + mirror_y, 2, 0)
				task.Wait(60)
				New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
				task._Wait(60)
				local u = 1
				while true do
					for i = 0, 4 do
						PlaySound("tan00")
						f1(self.x + mirror_x, self.y + mirror_y, 1 + 0.25*i, 72*i*u)
						task.Wait(30)
					end
					task.Wait(60)
					move_rd(60)
					task.Wait(60)
					u = -u
				end
			end)
		end
		function _tmp_sc:del()
			if self.timeout == 1 then
				self.noExtendBonus = true
			else
				Spell_break_eff(self.x, self.y, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')
			end
		end
		_tmp_sc.perform = false
		table.insert(stage2mid_boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2mid_boss:Hard", "镜幻「四棱之境」", _tmp_sc, #stage2mid_boss.cards, true })

		_tmp_sc = boss.dialog.New(true)
		function _tmp_sc:init()
			player.dialog = true
			self.dialog_displayer = New(dialog_displayer)
			self._dialog_maintask = task.New(self, function()
				self.colli = false
				player.dialog = false
				if not self.noExtendBonus then
					misc.ShakeScreen(60, 3)
					PlaySound("enep01", 0.5, 0, false)
					_drop_item(item_bomb, 1, self.x, self.y)
				end
				task._Wait(120)
				task.MoveTo(150, 300, 90, MOVE_ACC_DEC)
				_del(self, true)
			end)
		end
		table.insert(stage2mid_boss.cards, _tmp_sc)
		_tmp_sc = boss.card.New("", 2, 15, 60, 600, { 0, 0, 0 }, false)
		function _tmp_sc:init()
			lasttask = task.New(self, function()
				task.MoveTo(0, 144, 180, MOVE_NORMAL)
			end)
		end
		function _tmp_sc:del()
		end
		_tmp_sc.perform = false
		table.insert(stage2mid_boss.cards, _tmp_sc)
	end
	_editor_class["stage2mid_boss:Hard"] = stage2mid_boss

	--关底子弹定义
	do
		_editor_class["s2_一符使魔预警:Hard"] = Class(laser)
		_editor_class["s2_一符使魔预警:Hard"].init = function(self, _x, _y, a, c)
			laser.init(self, c, _x, _y, 0, 0, 900, 0, 2, 0, 0)
			self.bound = false
			laser.ChangeImage(self, 4)
			_object.set_color(self, "mul+add", 0, 255, 255, 255)
			self.rot = a
			lasttask = task.New(self, function()
				do
					local aerfa, _d_aerfa = (-90), (360 / 20)
					for _ = 1, 20 do
						_object.set_color(self, "mul+add", 125 + 125 * sin(aerfa), 255, 255, 255)
						task._Wait(1)
						aerfa = aerfa + _d_aerfa
					end
				end
				do
					local v, _d_v = (0.02), (0.075)
					for _ = 1, 10 do
						last = New(_editor_class["s2_一符使魔预警虚影"], self.x, self.y, self.rot, self.rot + 90, v, c)
						last = New(_editor_class["s2_一符使魔预警虚影"], self.x, self.y, self.rot, self.rot - 90, v, c)
						task._Wait(1)
						v = v + _d_v
					end
				end
				task._Wait(60)
				last = New(_editor_class["s2_一符使魔:Hard"], self.x, self.y, 10, a, c, self.x, self.y)
				_del(self, true)
			end)
		end
		_editor_class["s2_一符使魔预警:Hard"].kill = function(self)
		end
		_editor_class["s2_一符使魔:Hard"] = Class(_object)
		_editor_class["s2_一符使魔:Hard"].init = function(self, _x, _y, v, a, c, cx, cy)
			self.x, self.y = _x, _y
			self.img = "magic7"
			self.layer = LAYER_ENEMY_BULLET
			self.group = GROUP_INDES
			self.hide = false
			self.bound = true
			self.navi = false
			self.hp = 75
			self.maxhp = 75
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.omiga = 4
			self.vscale = 0
			self.hscale = 0
			self.bound = false
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (255 / 10)
					local s, _d_s = (0), (0.8 / 10)
					for _ = 1, 10 do
						_object.set_color(self, "mul+add", al, 255, 0, 255)
						self.vscale = s
						self.hscale = s
						task._Wait(1)
						al = al + _d_al
						s = s + _d_s
					end
				end
				SetV2(self, v, a, true, false)
				PlaySound("tan00", 0.1, self.x / 256, false)
				lasttask = task.New(self, function()
					do
						for _ = 1, 20 do
							last = New(_editor_class["s2_一符飘感弹:Hard"], self.x, self.y, a, 3, c, cx, cy)
							task._Wait(7)
						end
					end
					_del(self, true)
				end)
			end)
		end
		_editor_class["s2_一符飘感弹:Hard"] = Class(bullet)
		_editor_class["s2_一符飘感弹:Hard"].init = function(self, _x, _y, a, v0, c, cx, cy)
			bullet.init(self, knife, c, false, true)
			self.x, self.y = _x, _y
			self.hscale, self.vscale = 0.75, 0.75
			SetV2(self, 0, a, true, false)
			lasttask = task.New(self, function()
				do
					local v, _d_v = (v0), ((0.01 - v0) / 60)
					for _ = 1, 60 do
						SetV2(self, v, a, true, false)
						task._Wait(1)
						v = v + _d_v
					end
				end
				task._Wait(15)
				do
					local v, _d_v = (0.01), ((3 - 0.01) / 60)
					for _ = 1, 60 do
						SetV2(self, v, a, true, false)
						task._Wait(1)
						v = v + _d_v
					end
				end
			end)
		end
		_editor_class["s2_一符中心使魔中心:Hard"] = Class(_object)
		_editor_class["s2_一符中心使魔中心:Hard"].init = function(self, _x, _y, i, sty)
			self.x, self.y = _x, _y
			self.img = "img_void"
			self.layer = LAYER_ENEMY_BULLET - 1
			self.group = GROUP_INDES
			self.hide = true
			self.bound = false
			self.navi = false
			self.hp = 10
			self.maxhp = 10
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.bound = false
			self.rot = 40 * i
			lasttask = task.New(self, function()
				do
					local a, _d_a = (-90 - 100 * i), (250 / 16 * i)
					local mode, _d_mode = (1), (1)
					local vv, _d_vv = (1), (3 / 16)
					local count, _d_count = (2), (1)
					for _ = 1, 12 do
						last = New(_editor_class["s2_一符中心使魔:Hard"], self.x, self.y, a, i, self.x, self.y, mode, vv, sty, count)
						_connect(self, last, 0, true)
						task._Wait(4)
						a = a + _d_a
						mode = mode + _d_mode
						vv = vv + _d_vv
						count = count + _d_count
					end
				end
				task._Wait(360)
				_del(self, true)
			end)
		end
		_editor_class["s2_一符中心使魔:Hard"] = Class(_object)
		_editor_class["s2_一符中心使魔:Hard"].init = function(self, _x, _y, a, i, x, y, mode, vv, sty, count)
			self.x, self.y = _x, _y
			self.img = "magic2"
			self.layer = LAYER_ENEMY_BULLET - 1
			self.group = GROUP_INDES
			self.hide = false
			self.bound = false
			self.navi = false
			self.hp = 10
			self.maxhp = 10
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.bound = false
			self.vscale = 0.8
			self.hscale = 0.8
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (255 / 30)
					for _ = 1, 30 do
						_object.set_color(self, "mul+add", al, 255, 255, 255)
						_set_rel_pos(self, 175 * cos(a), 75 * sin(a), self.rot, true)
						task._Wait(1)
						al = al + _d_al
					end
				end
				do
					local aa, _d_aa = (a), (45)
					for _ = 1, 6 do
						_create_bullet_group(water_drop, COLOR_GOLDEN_YELLOW, self.x, self.y, 1, 0, vv * 5 / 6, vv * 5 / 6, aa, 0, false, 0, true, false, 0, false, self)
						task._Wait(0)
						aa = aa + _d_aa
					end
				end
				PlaySound("kira00", 0.1, self.x / 256, false)
				if (mode % 3 == 0) then
					do
						local r, _d_r = (1), (5)
						local angle1, _d_angle1 = (a), (23.854 * i)
						local f, _d_f = (11), (-1)
						for _ = 1, 10 do
							do
								local angle2, _d_angle2 = (0), (72)
								for _ = 1, 5 do
									last = New(_editor_class["s2_一符中心使魔星星"], self.x + r * cos(angle1 + angle2), self.y + r * sin(angle1 + angle2), 1, angle1 + angle2 + 90, f, i, COLOR_ORANGE)
									task._Wait(0)
									angle2 = angle2 + _d_angle2
								end
							end
							task._Wait(4)
							r = r + _d_r
							angle1 = angle1 + _d_angle1
							f = f + _d_f
						end
					end
				else
					task._Wait(40)
				end
				task._Wait(90)
				last = New(_editor_class["s2_一符使魔预警:Hard"], self.x, self.y, Angle(-20 * i, 230, self.x, self.y), COLOR_YELLOW)
				task._Wait(30)
				_del(self, true)
			end)
		end
		_editor_class["s2_二符使魔:Hard"] = Class(_object)
		_editor_class["s2_二符使魔:Hard"].init = function(self, _x, _y, cx, cy)
			self.x, self.y = _x, _y
			self.img = "magic2"
			self.layer = LAYER_ENEMY_BULLET
			self.group = GROUP_INDES
			self.hide = false
			self.bound = true
			self.navi = false
			self.hp = 75
			self.maxhp = 75
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.omiga = 4
			self.vscale = 0
			self.hscale = 0
			self.bound = false
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (255 / 10)
					local s, _d_s = (0), (1 / 10)
					for _ = 1, 10 do
						_object.set_color(self, "mul+add", al, 255, 0, 255)
						self.vscale = s
						self.hscale = s
						task._Wait(1)
						al = al + _d_al
						s = s + _d_s
					end
				end
				lasttask = task.New(self, function()
					do
						for _ = 1, 15 do
							last = New(_editor_class["s2_二符使魔残影1"], self.x, self.y, self.rot)
							task._Wait(2)
						end
					end
				end)
				task.MoveTo(cx, cy, 30, MOVE_ACCEL)
				lasttask = task.New(self, function()
					misc.ShakeScreen(10, 3)
					task._Wait(30)
					if (cx > 0) then
						_set_a(self, 0.3, 180, false)
					else
						_set_a(self, 0.3, 0, false)
					end
					self.bound = true
					task._Wait(25)
					if (self.y > 0) then
						do
							for _ = 1, 4 do
								last = New(_editor_class["s2_二符使魔预警:Hard"], self.x, self.y, Angle(self, player), COLOR_RED)
								task._Wait(6)
							end
						end
					else
					end
				end)
			end)
		end
		_editor_class["s2_二符使魔预警:Hard"] = Class(laser)
		_editor_class["s2_二符使魔预警:Hard"].init = function(self, _x, _y, a, c)
			laser.init(self, c, _x, _y, 0, 0, 900, 0, 2, 0, 0)
			self.bound = false
			laser.ChangeImage(self, 4)
			_object.set_color(self, "mul+add", 0, 255, 255, 255)
			self.rot = a
			lasttask = task.New(self, function()
				do
					local v, _d_v = (0.02), (0.065)
					for _ = 1, 10 do
						last = New(_editor_class["s2_一符使魔预警虚影"], self.x, self.y, self.rot, self.rot + 90, v, c)
						last = New(_editor_class["s2_一符使魔预警虚影"], self.x, self.y, self.rot, self.rot - 90, v, c)
						task._Wait(1)
						v = v + _d_v
					end
				end
				task._Wait(60)
				last = New(_editor_class["s2_二符权杖激光:Hard"], self.x, self.y, a)
				_del(self, true)
			end)
		end
		_editor_class["s2_二符使魔预警:Hard"].kill = function(self)
		end
		_editor_class["s2_二符权杖激光:Hard"] = Class(laser)
		_editor_class["s2_二符权杖激光:Hard"].init = function(self, _x, _y, a)
			laser.init(self, COLOR_RED, _x, _y, 0, 0, 900, 0, 4, 8, 0)
			laser.ChangeImage(self, 4)
			self.bound = false
			_object.set_color(self, "mul+add", 255, 255, 50, 50)
			self.rot = a
			lasttask = task.New(self, function()
				self.w = 12
				laser._TurnOn(self, 4, true, true)
				lasttask = task.New(self, function()
					task._Wait(5)
					do
						local vv, _d_vv = (2), (4 / 5)
						local r, _d_r = (Dist(self.x, self.y, 0, 0) * 2), (0)
						for _ = 1, 5 do
							last = New(_editor_class["s2_二符权杖火弹"], self.x + r * cos(a), self.y + r * sin(a), vv, a + 180)
							task._Wait(0)
							vv = vv + _d_vv
							r = r + _d_r
						end
					end
				end)
				do
					local w, _d_w = (16), (-16 / 10)
					for _ = 1, 10 do
						self.w = w
						task._Wait(1)
						w = w + _d_w
					end
				end
				_del(self, true)
			end)
		end
		_editor_class["s2_二符发射使魔:Hard"] = Class(_object)
		_editor_class["s2_二符发射使魔:Hard"].init = function(self, _x, _y, x, y, j, a1, vv)
			self.x, self.y = _x, _y
			self.img = "magic2"
			self.layer = LAYER_ENEMY_BULLET
			self.group = GROUP_INDES
			self.hide = false
			self.bound = true
			self.navi = false
			self.hp = 75
			self.maxhp = 75
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.omiga = 4 * j
			self.vscale = 0
			self.hscale = 0
			self.bound = false
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (255 / 10)
					local s, _d_s = (0), (1 / 10)
					for _ = 1, 10 do
						_object.set_color(self, "mul+add", al, 255, 0, 255)
						self.vscale = s
						self.hscale = s
						task._Wait(1)
						al = al + _d_al
						s = s + _d_s
					end
				end
				task.MoveTo(x, y, 30, MOVE_ACCEL)
				do
					local a, _d_a = (a1), (30)
					for _ = 1, 12 do
						last = New(_editor_class["s2_二符发射火弹:Hard"], self.x, self.y, vv, a, j)
						task._Wait(0)
						a = a + _d_a
					end
				end
				task._Wait(60)
				_del(self, true)
			end)
		end
		_editor_class["s2_二符发射火弹:Hard"] = Class(bullet)
		_editor_class["s2_二符发射火弹:Hard"].init = function(self, _x, _y, v, a, i)
			bullet.init(self, grain_b, COLOR_RED, true, false)
			self.x, self.y = _x, _y
			self.bound = false
			lasttask = task.New(self, function()
				task._Wait(180)
				self.bound = true
			end)
			lasttask = task.New(self, function()
				do
					local aerfa, _d_aerfa = (0), (6)
					local a1, _d_a1 = (a), (12 * i)
					for _ = 1, 10 do
						SetV2(self, v * sin(aerfa), a1, true, false)
						task._Wait(5)
						aerfa = aerfa + _d_aerfa
						a1 = a1 + _d_a1
					end
				end
			end)
		end
		_editor_class["s2_三符中玉圆中心:Hard"] = Class(_object)
		_editor_class["s2_三符中玉圆中心:Hard"].init = function(self, _x, _y, i, dr)
			self.x, self.y = _x, _y
			self.img = "img_void"
			self.layer = LAYER_ENEMY_BULLET - 1
			self.group = GROUP_INDES
			self.hide = true
			self.bound = true
			self.navi = false
			self.hp = 10
			self.maxhp = 10
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.bound = false
			lasttask = task.New(self, function()
				do
					local a, _d_a = (0), (72)
					for _ = 1, 5 do
						last = New(_editor_class["s2_三符大玉:Hard"], self.x, self.y, a + 36, i, dr)
						_connect(self, last, 0, true)
						do
							local b, _d_b = (-18), (36 / 15)
							for _ = 1, 16 do
								last = New(_editor_class["s2_三符中玉:Hard"], self.x, self.y, a + b, i, dr)
								_connect(self, last, 0, true)
								task._Wait(0)
								b = b + _d_b
							end
						end
						task._Wait(0)
						a = a + _d_a
					end
				end
				task._Wait(1200)
				_del(self, true)
			end)
		end
		_editor_class["s2_三符中玉:Hard"] = Class(bullet)
		_editor_class["s2_三符中玉:Hard"].init = function(self, _x, _y, a, i, dr)
			bullet.init(self, square, COLOR_YELLOW, false, false)
			self.x, self.y = _x, _y
			_object.set_color(self, "mul+add", 255, 255, 255, 255)
			self.bound = false
			lasttask = task.New(self, function()
				task._Wait(1400)
				self.bound = true
			end)
			lasttask = task.New(self, function()
				lasttask = task.New(self, function()
					do
						local a1, _d_a1 = (a), (0.3 * i)
						local r, _d_r = (0), (dr)
						for _ = 1, _infinite do
							_set_rel_pos(self, r * cos(a1), r * sin(a1), a1, true)
							task._Wait(1)
							a1 = a1 + _d_a1
							r = r + _d_r
						end
					end
				end)
			end)
		end
		_editor_class["s2_三符大玉:Hard"] = Class(bullet)
		_editor_class["s2_三符大玉:Hard"].init = function(self, _x, _y, a, i, dr)
			bullet.init(self, ball_huge, COLOR_RED, false, false)
			self.x, self.y = _x, _y
			self.bound = false
			self.omiga = 2 * i
			lasttask = task.New(self, function()
				task._Wait(1400)
				self.bound = true
			end)
			lasttask = task.New(self, function()
				do
					local angle, _d_angle = (ran:Float(0, 360)), (45)
					for _ = 1, 8 do
						last = New(_editor_class["s2_三符小玉:Hard"], self.x, self.y, angle, -6 * i)
						_connect(self, last, 0, true)
						last = New(_editor_class["s2_三符小玉附属:Hard"], self.x, self.y, angle - 6 * i, -6 * i)
						_connect(self, last, 0, true)
						task._Wait(0)
						angle = angle + _d_angle
					end
				end
				lasttask = task.New(self, function()
					do
						local a1, _d_a1 = (a), (0.3 * i)
						local r, _d_r = (0), (dr)
						for _ = 1, _infinite do
							_set_rel_pos(self, r * cos(a1), r * sin(a1), self.rot, true)
							task._Wait(1)
							a1 = a1 + _d_a1
							r = r + _d_r
						end
					end
				end)
			end)
		end
		_editor_class["s2_三符小玉:Hard"] = Class(bullet)
		_editor_class["s2_三符小玉:Hard"].init = function(self, _x, _y, angle, rotate)
			bullet.init(self, ball_mid, COLOR_BLUE, false, false)
			self.x, self.y = _x, _y
			self.navi = true
			self.bound = false
			self.timer = 11
			local s = 1
			self.hscale = s * self.hscale
			self.vscale = s * self.vscale
			self.a = s * self.a
			self.b = s * self.b
			self.render_ani_flag = true
			self.img = "ani:s2_fire_drop"
			lasttask = task.New(self, function()
				task._Wait(1400)
				self.bound = true
			end)
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (255 / 60)
					for _ = 1, 60 do
						_object.set_color(self, "mul+add", al, 255, 255, 255)
						task._Wait(1)
						al = al + _d_al
					end
				end
			end)
			lasttask = task.New(self, function()
				do
					local aerfa, _d_aerfa = (90), (2)
					local a, _d_a = (angle), (rotate)
					for _ = 1, _infinite do
						local r = 45 + 10 * sin(aerfa)
						_set_rel_pos(self, r * cos(a), r * sin(a), self.rot, false)
						task._Wait(1)
						aerfa = aerfa + _d_aerfa
						a = a + _d_a
					end
				end
			end)
		end
		_editor_class["s2_三符小玉附属:Hard"] = Class(bullet)
		_editor_class["s2_三符小玉附属:Hard"].init = function(self, _x, _y, angle, rotate)
			bullet.init(self, ball_mid, COLOR_BLUE, false, false)
			self.x, self.y = _x, _y
			self.navi = true
			self.bound = false
			self.timer = 11
			self.hide = true
			lasttask = task.New(self, function()
				task._Wait(1400)
				self.bound = true
			end)
			lasttask = task.New(self, function()
				do
					local aerfa, _d_aerfa = (90), (2)
					local a, _d_a = (angle), (rotate)
					for _ = 1, _infinite do
						local r = 45 + 10 * sin(aerfa)
						_set_rel_pos(self, r * cos(a), r * sin(a), self.rot, false)
						task._Wait(1)
						aerfa = aerfa + _d_aerfa
						a = a + _d_a
					end
				end
			end)
		end
		_editor_class["s3_lsc激光:Hard"] = Class(bullet)
		_editor_class["s3_lsc激光:Hard"].init = function(self, _x, _y, a, t, r, g, b)
			bullet.init(self, ball_light, COLOR_GRAY, true, true)
			self.x, self.y = _x, _y
			self.rr = r
			self.gg = g
			self.bb = b
			self.t = t
			_object.set_color(self, "mul+add", 155, 138, 43, 226)
			self.rot = a
			self.vscale = 0.05
			self.timer = 11
			self.bound = false
			self.colli = false
			self.group = GROUP_INDES
			lasttask = task.New(self, function()
				do
					local tt, _d_tt = (0), (self.t / 4 / 44)
					for _ = 1, 45 do
						self.rot = self.rot + tt
						_set_rel_pos(self, 0 * cos(self.rot), 0 * sin(self.rot), self.rot, false)
						task._Wait(1)
						tt = tt + _d_tt
					end
				end
				do
					for _ = 1, _infinite do
						while _boss.s3_lsc == 1 do
							task.Wait(1)
						end
						self.rot = self.rot + self.t / 4
						_set_rel_pos(self, 0 * cos(self.rot), 0 * sin(self.rot), self.rot, false)
						task._Wait(1)
					end
				end
			end)
			lasttask = task.New(self, function()
				do
					for _ = 1, _infinite do
						if (_boss.s3_lsc == 1) then
							task.Wait(30)
							New(_editor_class["LSC激光发射预警"], self.x, self.y, self.rot, 3)
							task.Wait(60)
							PlaySound("lazer00", 0.1, self.x / 256, false)
							last = New(_editor_class["s3_lsc装饰"], self.x, self.y, self, self.rot)
							last = New(_editor_class["s3_lsc装饰"], self.x, self.y, self, self.rot)
							_boss.s3_lsc_active = 0
							task._Wait(1)
							_boss.s3_lsc = 0
							do
								local rr, _d_rr = (self.rr), ((138 - self.rr) / 59)
								local gg, _d_gg = (self.gg), ((43 - self.gg) / 59)
								local bb, _d_bb = (self.bb), ((226 - self.bb) / 59)
								for _ = 1, 60 do
									_object.set_color(self, "mul+add", 255, rr, g, bb)
									task._Wait(1)
									rr = rr + _d_rr
									gg = gg + _d_gg
									bb = bb + _d_bb
								end
							end
							task._Wait(150)
							do
								local rr, _d_rr = (138), ((self.rr - 138) / 59)
								local gg, _d_gg = (43), ((self.gg - 43) / 59)
								local bb, _d_bb = (226), ((self.bb - 226) / 59)
								for _ = 1, 60 do
									_object.set_color(self, "mul+add", 255, rr, g, bb)
									task._Wait(1)
									rr = rr + _d_rr
									gg = gg + _d_gg
									bb = bb + _d_bb
								end
							end
							_boss.s3_lsc_active = 1
						end
						task._Wait(1)
					end
				end
			end)
			lasttask = task.New(self, function()
				do
					local h, _d_h = (0), (0.3)
					for _ = 1, 60 do
						self.hscale = h
						task._Wait(1)
						h = h + _d_h
					end
				end
				do
					local rr, _d_rr = (138), ((self.rr - 138) / 59)
					local gg, _d_gg = (43), ((self.gg - 43) / 59)
					local bb, _d_bb = (226), ((self.bb - 226) / 59)
					for _ = 1, 60 do
						_object.set_color(self, "mul+add", 255, rr, g, bb)
						task._Wait(1)
						rr = rr + _d_rr
						gg = gg + _d_gg
						bb = bb + _d_bb
					end
				end
				do
					for _ = 1, _infinite do
						if (abs(self.rot % 360 - Angle(self, player) % 360) < 0.5) then
							if (_boss.s3_lsc_active == 1) then
								_boss.s3_lsc = 1
							else
							end
						end
						task._Wait(1)
					end
				end
			end)
		end
		_editor_class["s3_lsc激光:Hard"].kill = function(self)
			--[[ # --]]--[=[
        PreserveObject(self)
    --]=]
			local cx, cy = cos(self.rot), sin(self.rot)
			for l = 0, 600, 12 do
				New(item_faith_minor, self.x + l * cx, self.y + l * cy)
			end


			--[[ # --]]--[=[
        self.group=GROUP_GHOST
        local d=self.vscale
        task.Clear(self)
        task.New(self,function()
            for i=1,30 do
                self.vscale=self.vscale-d/30
                task.Wait()
            end
            Del(self)
        end)
    --]=]
		end
		_editor_class["s3_lsc激光1:Hard"] = Class(bullet)
		_editor_class["s3_lsc激光1:Hard"].init = function(self, _x, _y, a, t, r, g, b)
			bullet.init(self, ball_light, COLOR_GRAY, true, true)
			self.x, self.y = _x, _y
			self.rr = r
			self.gg = g
			self.bb = b
			self.t = t
			if (IsValid(_boss)) then
				_connect(_boss, self, 0, true)
			else
				_del(self, false)
			end
			_object.set_color(self, "mul+add", 155, 138, 43, 226)
			self.rot = a
			self.vscale = 0.05
			self.timer = 11
			self.bound = false
			self.colli = false
			self.group = GROUP_INDES
			lasttask = task.New(self, function()
				do
					local tt, _d_tt = (0), (self.t / 5 / 44)
					for _ = 1, 45 do
						self.rot = self.rot + tt
						_set_rel_pos(self, 0 * cos(self.rot), 0 * sin(self.rot), self.rot, false)
						task._Wait(1)
						tt = tt + _d_tt
					end
				end
				do
					for _ = 1, _infinite do
						while _boss.s3_lsc1 == 1 do
							task.Wait(1)
						end
						self.rot = self.rot + self.t / 5
						_set_rel_pos(self, 0 * cos(self.rot), 0 * sin(self.rot), self.rot, false)
						task._Wait(1)
					end
				end
			end)
			lasttask = task.New(self, function()
				do
					for _ = 1, _infinite do
						if (_boss.s3_lsc1 == 1) then
							task.Wait(30)
							New(_editor_class["LSC激光发射预警"], self.x, self.y, self.rot, 3)
							task.Wait(60)
							PlaySound("lazer00", 0.1, self.x / 256, false)
							last = New(_editor_class["s3_lsc装饰"], self.x, self.y, self, self.rot)
							last = New(_editor_class["s3_lsc装饰"], self.x, self.y, self, self.rot)
							_boss.s3_lsc_active1 = 0
							task._Wait(1)
							_boss.s3_lsc1 = 0
							do
								local rr, _d_rr = (self.rr), ((138 - self.rr) / 59)
								local gg, _d_gg = (self.gg), ((43 - self.gg) / 59)
								local bb, _d_bb = (self.bb), ((226 - self.bb) / 59)
								for _ = 1, 60 do
									_object.set_color(self, "mul+add", 255, rr, g, bb)
									task._Wait(1)
									rr = rr + _d_rr
									gg = gg + _d_gg
									bb = bb + _d_bb
								end
							end
							task._Wait(150)
							do
								local rr, _d_rr = (138), ((self.rr - 138) / 59)
								local gg, _d_gg = (43), ((self.gg - 43) / 59)
								local bb, _d_bb = (226), ((self.bb - 226) / 59)
								for _ = 1, 60 do
									_object.set_color(self, "mul+add", 255, rr, g, bb)
									task._Wait(1)
									rr = rr + _d_rr
									gg = gg + _d_gg
									bb = bb + _d_bb
								end
							end
							_boss.s3_lsc_active1 = 1
						end
						task._Wait(1)
					end
				end
			end)
			lasttask = task.New(self, function()
				do
					local h, _d_h = (0), (0.3)
					for _ = 1, 60 do
						self.hscale = h
						task._Wait(1)
						h = h + _d_h
					end
				end
				do
					local rr, _d_rr = (138), ((self.rr - 138) / 59)
					local gg, _d_gg = (43), ((self.gg - 43) / 59)
					local bb, _d_bb = (226), ((self.bb - 226) / 59)
					for _ = 1, 60 do
						_object.set_color(self, "mul+add", 255, rr, g, bb)
						task._Wait(1)
						rr = rr + _d_rr
						gg = gg + _d_gg
						bb = bb + _d_bb
					end
				end
				do
					for _ = 1, _infinite do
						if (abs(self.rot % 360 - Angle(self, player) % 360) < 0.5) then
							if (_boss.s3_lsc_active1 == 1) then
								_boss.s3_lsc1 = 1
							else
							end
						else
						end
						task._Wait(1)
					end
				end
			end)
		end
		_editor_class["s3_lsc激光1:Hard"].kill = function(self)
			--[[ # --]]--[=[
        PreserveObject(self)
    --]=]
			local cx, cy = cos(self.rot), sin(self.rot)
			for l = 0, 600, 12 do
				New(item_faith_minor, self.x + l * cx, self.y + l * cy)
			end


			--[[ # --]]--[=[
        self.group=GROUP_GHOST
        local d=self.vscale
        task.Clear(self)
        task.New(self,function()
            for i=1,30 do
                self.vscale=self.vscale-d/30
                task.Wait()
            end
            Del(self)
        end)
    --]=]
		end
		_editor_class["s2_LSC镜子椭圆:Hard"] = Class(_object)
		_editor_class["s2_LSC镜子椭圆:Hard"].init = function(self, _x, _y, i)
			self.x, self.y = _x, _y
			self.img = "img_void"
			self.layer = LAYER_ENEMY_BULLET
			self.group = GROUP_INDES
			self.hide = true
			self.bound = true
			self.navi = false
			self.hp = 10
			self.maxhp = 10
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.bound = false
			self.rot = 0
			lasttask = task.New(self, function()
				last = New(_editor_class["s2_LSC镜子:Hard"], self.x, self.y, 0, i)
				_connect(self, last, 0, true)
				do
					for _ = 1, _infinite do
						while (i == 1 and _boss.s3_lsc == 1) or (i ~= 1 and _boss.s3_lsc1 == 1) do
							task.Wait(1)
						end
						_set_rel_pos(self, 0, 0, self.rot, false)
						self.rot = self.rot + 0.45 * i
						task._Wait(1)
					end
				end
			end)
		end
		_editor_class["s2_LSC镜子:Hard"] = Class(_object)
		_editor_class["s2_LSC镜子:Hard"].init = function(self, _x, _y, a0, i)
			self.x, self.y = _x, _y
			self.img = "image:mgmk1"
			self.layer = LAYER_ENEMY_BULLET
			self.group = GROUP_INDES
			self.hide = false
			self.bound = true
			self.navi = false
			self.hp = 10
			self.maxhp = 10
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.bound = false
			self.omiga = 4 * i
			self.vscale = 0
			self.hscale = 0
			_object.set_color(self, "mul+add", 200, 250, 250, 250)
			lasttask = task.New(self, function()
				do
					local s, _d_s = (0), ((1 / 20) / 30)
					for _ = 1, 30 do
						self.vscale = s
						self.hscale = s
						task._Wait(1)
						s = s + _d_s
					end
				end
			end)
			if (i == 1) then
				lasttask = task.New(self, function()
					last = New(_editor_class["s2_LSC激光头"], self.x, self.y, self.rot, 255, 99, 71)
					_connect(self, last, 0, true)
					do
						local a, _d_a = (0), (360 / 12)
						for _ = 1, 12 do
							last = New(_editor_class["s3_lsc激光:Hard"], self.x, self.y, a, 1, 255, 99, 71)
							_connect(self, last, 0, true)
							task._Wait(0)
							a = a + _d_a
						end
					end
				end)
			else
				lasttask = task.New(self, function()
					last = New(_editor_class["s2_LSC激光头"], self.x, self.y, self.rot, 255, 99, 71)
					_connect(self, last, 0, true)
					do
						local a, _d_a = (0), (360 / 12)
						for _ = 1, 12 do
							last = New(_editor_class["s3_lsc激光1:Hard"], self.x, self.y, a, -1, 255, 99, 71)
							_connect(self, last, 0, true)
							task._Wait(0)
							a = a + _d_a
						end
					end
				end)
			end
			lasttask = task.New(self, function()
				do
					local a, _d_a = (a0), (0.9 * i)
					local r, _d_r = (0), (75 / 90)
					for _ = 1, 90 do
						_set_rel_pos(self, r * cos(a), r * sin(a) / 4, self.rot, true)
						task._Wait(1)
						a = a + _d_a
						r = r + _d_r
					end
				end
				do
					local a, _d_a = (a0 + 90 * 0.9 * i), (0.9 * i)
					for _ = 1, _infinite do
						while (i == 1 and _boss.s3_lsc == 1) or (i ~= 1 and _boss.s3_lsc1 == 1) do
							task.Wait(1)
						end
						_set_rel_pos(self, 75 * cos(a), 75 * sin(a) / 4, self.rot, true)
						task._Wait(1)
						a = a + _d_a
					end
				end
			end)
			lasttask = task.New(self, function()
				task._Wait(90)
				do
					local b, _d_b = (self.rot), (47.9 * i)
					for _ = 1, _infinite do
						do
							local a, _d_a = (0), (72)
							for _ = 1, 5 do
								_create_bullet_group(grain_b, 11 + i, self.x, self.y, 5, 0, 1.75 + 0.25 * i, 1.75 - 0.25 * i, a + b + 4, 8, false, 0, true, true, 0, false, self)
								_create_bullet_group(grain_b, 11 + i, self.x, self.y, 5, 0, 1.75 + 0.25 * i, 1.75 - 0.25 * i, a + b - 4, -8, false, 0, true, true, 0, false, self)
								task._Wait(0)
								a = a + _d_a
							end
						end
						task._Wait(36)
						b = b + _d_b
					end
				end
			end)
		end
	end
	--关底boss定义
	local stage2boss
	do
		stage2boss = Class(boss)
		stage2boss.cards = {}
		stage2boss.name = "Emitsu"
		stage2boss.init = function(self, cards)
			boss.init(self, 240, 384, "Emitsu", cards, New(s2_boss.scbg), "Hard")
			lstg.wis.Emitsu(self)
		end
		stage2boss.bgm = "s2_boss"
		stage2boss._bg = stage2_background
		stage2boss.difficulty = "Hard"
		-- 入场
		s2_boss_common_action(stage2boss)
		-- 攻击
		_tmp_sc = boss.card.New("常规攻击1", 2, 5, 40, 1000, { 0, 0, 0 }, false, "normal")
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			--[[ H一非 --]]--[=[
    --]=]
			lasttask = task.New(self, function()
				do
					task._Wait(10)
					self._wisys:setAction("cast", 60)
					New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
					task._Wait(60)
				end
				local a0, t0, u, dsp = nil, 64, 1, 25
				do
					for _ = 1, _infinite do
						a0 = 90 + 90 * u
						do
							for _ = 1, 15 do
								last = New(_editor_class["s2_boss_ls1"], self.x + mirror_x + 10 * cos(a0), self.y + mirror_y + 10 * sin(a0), a0, t0, u)
								a0 = a0 - 12 * u
								task._Wait(2)
								last = New(_editor_class["s2_boss_ls2"], self.x + mirror_x + 10 * cos(a0), self.y + mirror_y + 10 * sin(a0), a0)
								a0 = a0 - 12 * u
								t0 = t0 - 4
								task._Wait(2)
							end
						end
						t0 = 64
						lasttask = task.New(self, function()
							task.MoveToPlayer(30, -96, 96, 110, 130, 16, 32, 8, 16, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
						end)
						do
							for _ = 1, 16 do
								last = New(_editor_class["s2_boss_ls1"], self.x + mirror_x + 10 * cos(a0), self.y + mirror_y + 10 * sin(a0), a0, t0, -u)
								a0 = a0 - 12 * u
								task._Wait(2)
								last = New(_editor_class["s2_boss_ls2"], self.x + mirror_x + 10 * cos(a0), self.y + mirror_y + 10 * sin(a0), a0)
								a0 = a0 - 12 * u
								t0 = t0 - 4
								task._Wait(2)
							end
						end
						t0 = 64
						u = -u
						task._Wait(135)
						do
							for _ = 1, 3 do
								a0 = Angle(self.x + mirror_x, self.y + mirror_y, player.x, player.y) + 0.5 * dsp
								do
									for _ = 1, 2 do
										last = New(_editor_class["s2_boss_ls3"], self.x + mirror_x, self.y + mirror_y, a0)
										a0 = a0 - dsp
									end
								end
								task._Wait(30)
							end
						end
						task._Wait(90)
					end
				end
			end)
		end
		function _tmp_sc:del()
		end
		_editor_cards.s2_01_H = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage2boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2boss:Hard", "常规攻击1", _tmp_sc, #stage2boss.cards, true })

		boss_action(stage2boss, 0, 104)
		_tmp_sc = boss.card.New("星辰「酒泉悬剑」", 3, 5, 60, 2000, { 10, 20, 30 }, false)
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					s2_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
						task._Wait(60)
					end
				end
				local i = 1
				do
					for _ = 1, _infinite do
						last = New(_editor_class["s2_一符中心使魔中心:Hard"], self.x + mirror_x, self.y + mirror_y, i, 1)
						i = -i
						task.MoveToPlayer(60, -24, 24, 112, 124, 8, 16, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
						last = New(_editor_class["s2_一符中心使魔中心:Hard"], self.x + mirror_x, self.y + mirror_y, i, 2)
						task.MoveToPlayer(60, -24, 24, 112, 124, 8, 16, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
						task._Wait(90)
						task._Wait(60)
					end
				end
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')
		end
		_editor_cards.s2_11_H = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage2boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2boss:Hard", "星辰「酒泉悬剑」", _tmp_sc, #stage2boss.cards, true })

		boss_action(stage2boss, 0, 120)
		_tmp_sc = boss.card.New("常规攻击2", 2, 5, 40, 1000, { 0, 0, 0 }, false, "normal")
		function _tmp_sc:init()
			--[[ H二非 --]]--[=[
    --]=]
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					task._Wait(10)
					self._wisys:setAction("cast", 60)
					New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
					task._Wait(60)
				end
				local a0, t0, u, dsp, da = nil, 64, 1, 40, da
				do
					for _ = 1, _infinite do
						a0 = 90 + 90 * u + ran:Float(-5, 5)
						do
							for _ = 1, 2 do
								do
									for _ = 1, 16 do
										last = New(_editor_class["s2_boss_ls4"], self.x + 30 * cos(a0 + 120 * u) + mirror_x, self.y + 30 * sin(a0 + 120 * u) + mirror_y, a0, u)
										a0 = a0 + 11.75 * u
										task._Wait(2)
										last = New(_editor_class["s2_boss_ls5"], self.x + 30 * cos(a0 + 120 * u) + mirror_x, self.y + 30 * sin(a0 + 120 * u) + mirror_y, a0)
										a0 = a0 + 11.75 * u
										t0 = t0 - 4
										task._Wait(2)
									end
								end
								t0 = 64
								do
									for _ = 1, 16 do
										last = New(_editor_class["s2_boss_ls4"], self.x + 30 * cos(a0 + 120 * u) + mirror_x, self.y + 30 * sin(a0 + 120 * u) + mirror_y, a0, -u)
										a0 = a0 + 11.75 * u
										task._Wait(2)
										last = New(_editor_class["s2_boss_ls5"], self.x + 30 * cos(a0 + 120 * u) + mirror_x, self.y + 30 * sin(a0 + 120 * u) + mirror_y, a0)
										a0 = a0 + 11.75 * u
										t0 = t0 - 4
										task._Wait(2)
									end
								end
								t0 = 64
							end
						end
						task.MoveToPlayer(30, -96, 96, 110, 130, 16, 32, 8, 16, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
						task._Wait(45)
						a0 = Angle(self.x + mirror_x, self.y + mirror_y, player.x, player.y) + 5 * u
						da = -10 / 6 * u
						do
							for _ = 1, 7 do
								a0 = a0 + da + 0.5 * dsp
								do
									for _ = 1, 2 do
										last = New(_editor_class["s2_boss_ls6"], self.x + mirror_x, self.y + mirror_y, a0)
										a0 = a0 - dsp
									end
								end
								a0 = a0 + 1.5 * dsp
								task._Wait(9)
							end
						end
						do
							for _ = 1, 7 do
								a0 = a0 - 1.5 * da + 0.5 * dsp
								do
									for _ = 1, 2 do
										last = New(_editor_class["s2_boss_ls6"], self.x + mirror_x, self.y + mirror_y, a0)
										a0 = a0 - dsp
									end
								end
								a0 = a0 + 1.5 * dsp
								task._Wait(9)
							end
						end
						u = -u
						task._Wait(90)
					end
				end
			end)
		end
		function _tmp_sc:del()
		end
		_editor_cards.s2_02_H = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage2boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2boss:Hard", "常规攻击2", _tmp_sc, #stage2boss.cards, true })

		boss_action(stage2boss, 0, 124)
		_tmp_sc = boss.card.New("伤符「倒吊人绞刑XII」", 3, 5, 60, 1500, { 10, 20, 30 }, false)
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					s2_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
						task._Wait(60)
					end
				end
				local i = 1
				do
					for _ = 1, _infinite do
						PlaySound("tan00", 0.1, self.x / 256, false)
						local a = Angle(self, player)
						local j = i
						do
							local r, _d_r = (5), (20)
							local vv, _d_vv = (1), (2 / 6)
							for _ = 1, 6 do
								do
									local a1, _d_a1 = (a - 30 + 30 * j), (60)
									for _ = 1, 6 do
										last = New(_editor_class["s2_二符发射使魔:Hard"], self.x + mirror_x, self.y + mirror_y, self.x + r * cos(a1), self.y + r * sin(a1), i, a1, vv)
										_connect(self, last, 0, true)
										task._Wait(0)
										a1 = a1 + _d_a1
									end
								end
								PlaySound("tan00", 0.1, self.x / 256, false)
								j = -j
								task._Wait(9)
								r = r + _d_r
								vv = vv + _d_vv
							end
						end
						boss.cast(self, 0)
						task._Wait(1)
						boss.cast(self, _infinite)
						New(_editor_class["s2_二符扫地激光"], self.x + mirror_x, self.y + mirror_y, i)
						New(_editor_class["s2_二符扫地激光"], self.x + mirror_x, self.y + mirror_y, -i)
						task._Wait(30)
						do
							last = New(_editor_class["s2_二符使魔:Hard"], self.x + mirror_x, self.y + mirror_y, -195, 230)
							last = New(_editor_class["s2_二符使魔:Hard"], self.x + mirror_x, self.y + mirror_y, 195, 230)
							last = New(_editor_class["s2_二符使魔:Hard"], self.x + mirror_x, self.y + mirror_y, -195, -230)
							last = New(_editor_class["s2_二符使魔:Hard"], self.x + mirror_x, self.y + mirror_y, 195, -230)
						end
						task.MoveToPlayer(60, -96, 96, 112, 144, 16, 32, 8, 16, MOVE_NORMAL, MOVE_X_TOWARDS_PLAYER)
						task._Wait(210)
						i = -i
						task._Wait(0)
					end
				end
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')
		end
		_editor_cards.s2_12_H = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage2boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2boss:Hard", "伤符「倒吊人绞刑XII」", _tmp_sc, #stage2boss.cards, true })

		boss_action(stage2boss, 0, 124)
		_tmp_sc = boss.card.New("逆位「许德拉战车VII」", 3, 5, 55, 2500, { 10, 20, 30 }, false)
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					s2_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
						task._Wait(60)
					end
				end
				lasttask = task.New(self, function()
					local i = 1
					do
						for _ = 1, _infinite do
							last = New(_editor_class["s2_三符中玉圆中心:Hard"], self.x + mirror_x, self.y + mirror_y, i, 1)
							PlaySound("tan00", 0.1, self.x / 256, false)
							i = -i
							task._Wait(160)
						end
					end
				end)
				task._Wait(450)
				do
					task._Wait(10)
					self._wisys:setAction("cast", 60)
					New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
					task._Wait(60)
				end
				lasttask = task.New(self, function()
					do
						local b, _d_b = (90), (21.854 / 8 * 10)
						for _ = 1, _infinite do
							PlaySound("tan00", 0.1, self.x / 256, false)
							do
								local a, _d_a = (0), (180)
								for _ = 1, 2 do
									_create_bullet_group(water_drop, COLOR_RED, self.x + mirror_x + 20 * cos(a + b), self.y + mirror_y + 20 * sin(a + b), 3, 0, 2, 3, a + b, 125, false, 0, true, true, 0, false, self)
									task._Wait(0)
									a = a + _d_a
								end
							end
							task._Wait(10)
							b = b + _d_b
						end
					end
				end)
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')
		end
		_editor_cards.s2_13_H = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage2boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2boss:Hard", "逆位「许德拉战车VII」", _tmp_sc, #stage2boss.cards, true })
	end
	_editor_class["stage2boss:Hard"] = stage2boss
end

--Lunatic
do
	--道中boss
	local stage2mid_boss
	--道中子弹定义
	local f1_1, f1_2
	do
		f1_1 = Class(laser)
		function f1_1:init(x, y, mst1, mst2)
			laser.init(self, COLOR_BLUE, x, y, 0, 6, 0, 6, 6, 6, 0)
			self.bound = false
			self.mst1, self.mst2 = mst1, mst2
			laser.ChangeImage(self, 1, orginal)
			task.New(self, function()
				laser._TurnOn(self, 30, false, true)
				while IsValid(mst1) and IsValid(mst2) do
					task.Wait(1)
				end
				PlaySound("kira00", 0.5, 0, false)
				local n = int(self.l2 / 8)
				local sp = 360
				local dsp = sp/(n-1)
				local a0, d, dx, dy, _x, _y, obj = self.rot + 90 - sp*0.5*(n-1), 0, cos(self.rot), sin(self.rot)
				for _ = 1, n do
					_x, _y = self.x + d * dx, self.y + d * dy
					obj = stg.newBulletStraight(stg.star_small, 1, true, _x, _y, 0, a0)
					egg.AddSimStrChV(obj, 0, 2, a0, 60)
					obj.omiga = 3
					_object.set_color(obj, "", 255, 255, 255, 255)
					d = d + 8
					a0 = a0 + dsp
				end
				Del(self)
			end)
		end
		function f1_1:frame()
			self.class.base.frame(self)
			--_object.set_color(self, "", 255, 255, 255 - 100 * self.killing / 30, 255 - 100 * self.killing / 30)
			if IsValid(self.mst1) and IsValid(self.mst2) then
				self.x, self.y = self.mst1.x, self.mst1.y
				self.rot = Angle(self.mst1, self.mst2)
				self.l2 = max(0, Dist(self.mst1, self.mst2) - 12)
			end
		end
		f1_2 = Class(object)
		function f1_2:init(x, y, v, a)
			self.x, self.y = x, y
			self.img = "magic6"
			self.layer = LAYER_ENEMY_BULLET
			self.group = GROUP_GHOST
			self.bound = true
			self.colli = true
			self._blend, self._a, self._r, self._g, self._b = '', 0, 255, 255, 255
			self.bound = false
			self.hscale, self.vscale = 0, 0
			task.New(self, function()
				egg.SimAlpCh(self, 0, 255, 30)
				egg.SimSizeCh(self, 0, 0.6, 30)
				egg.AddAccDecChV(self, v, a, 60, 60, 60)
				task.Wait(120)
				PlaySound("kira00")
				local a = Angle(self, player)
				for i = -2, 2 do
					for j = 0, 3 do
						stg.newBulletStraight(stg.ball_mid, 5, true, self.x, self.y, 2 + 0.5*j, a + 30*i)
					end
				end
				egg.SimAlpCh(self, 255, 0, 30)
				task.Wait(30)
				Del(self)
			end)
		end
		function f1_2:frame()
			task.Do(self)
		end
		function f1_2:render()
			SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
			Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
		end
	end
	do
		stage2mid_boss = Class(boss)
		stage2mid_boss.cards = {}
		stage2mid_boss.name = "Emitsu"
		stage2mid_boss.init = function(self, cards)
			boss.init(self, 240, 384, "Emitsu", cards, New(s2_boss.scbg), "Lunatic")
			lstg.wis.Emitsu(self)
		end
		stage2mid_boss.bgm = "s2"
		stage2mid_boss._bg = stage2_background
		stage2mid_boss.difficulty = "Lunatic"
		boss_action(stage2mid_boss, 0, 100)
		_tmp_sc = boss.card.New("常规攻击", 2, 5, 30, 1000, { 0, 0, 0 }, false, "normal")
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					task._Wait(10)
					self._wisys:setAction("cast", 60)
					New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
					task._Wait(60)
					boss.show_aura(self, true)
				end
				PlaySound("lazer00", 0.5, 0, false)
				do
					local a0, _d_a0 = (0), (10)
					for _ = 1, 36 do
						last = New(_editor_class["stage2mid_boss_ls1"], self.x + 10 * cos(a0) + mirror_x, self.y + 10 * sin(a0) + mirror_y, 4, a0)
						task._Wait(1)
						a0 = a0 + _d_a0
					end
				end
				task._Wait(60)
				local u = -1
				do
					for _ = 1, _infinite do
						do
							for _ = 1, 2 do
								last = New(_editor_class["stage2mid_boss_obj1"], self.x + 20 * u, self.y + 20, 90 - 60 * u, 90 - 60 * u)
								_connect(self, last, 0, true)
								PlaySound("lazer00", 0.5, 0, false)
								do
									local a0, _d_a0 = (90 - 90 * u + ran:Float(-5, 5)), (10 * u)
									for _ = 1, 36 do
										last = New(_editor_class["stage2mid_boss_ls1"], self.x + 10 * cos(a0) + mirror_x, self.y + 10 * sin(a0) + mirror_y, 6, a0 + 45 * u)
										task._Wait(1)
										a0 = a0 + _d_a0
									end
								end
								task._Wait(20)
								u = -u
							end
						end
						task.MoveToPlayer(20, -96, 96, 90, 110, 16, 32, 8, 16, MOVE_NORMAL, MOVE_TOWARDS_PLAYER)
					end
				end
			end)
		end
		function _tmp_sc:del()
		end
		_tmp_sc.perform = false
		table.insert(stage2mid_boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2mid_boss:Lunatic", "常规攻击", _tmp_sc, #stage2mid_boss.cards, true })


		boss_action(stage2mid_boss, 0, 154)
		_tmp_sc = boss.card.New("镜幻「六棱之境」", 4, 7, 40, 1500, { 10, 20, 30 }, false)
		--[[function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					s2_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
						task._Wait(60)
					end
				end
				local t0, r0 = 300, 250
				local t1, r1 = int(2.5 * t0 / sqrt(3)), 2.5 * r0 / sqrt(3)
				local dt = t1 - t0
				local x0, y0 = 0, 0
				lasttask = task.New(self, function()
					local objs, count = {}, 1
					do
						local a0, _d_a0 = (0), (60)
						for _ = 1, 6 do
							last = New(_editor_class["stage2mid_boss_obj2"], x0 + r0 * cos(a0) + mirror_x, y0 + r0 * sin(a0) + mirror_y, t0, 1, true)
							_connect(self, last, 0, true)
							objs[count] = last
							count = count + 1
							a0 = a0 + _d_a0
						end
					end
					task._Wait(90)
					PlaySound("lazer00", 0.5, 0, false)
					do
						local i, _d_i = (1), (1)
						for _ = 1, 6 do
							last = New(_editor_class["stage2mid_boss_ls2"], x0, y0, objs[i % 6 + 1], objs[(i + 1) % 6 + 1])
							i = i + _d_i
						end
					end
				end)
				lasttask = task.New(self, function()
					local objs, count = {}, 1
					do
						local a0, _d_a0 = (15), (60)
						for _ = 1, 6 do
							last = New(_editor_class["stage2mid_boss_obj2"], x0 + r1 * cos(a0) + mirror_x, y0 + r1 * sin(a0) + mirror_y, t1, -1, true)
							_connect(self, last, 0, true)
							objs[count] = last
							count = count + 1
							a0 = a0 + _d_a0
						end
					end
					task._Wait(90)
					do
						local i, _d_i = (1), (1)
						for _ = 1, 6 do
							last = New(_editor_class["stage2mid_boss_ls2"], x0, y0, objs[i % 6 + 1], objs[(i + 1) % 6 + 1])
							i = i + _d_i
						end
					end
				end)
				task._Wait(90)
				local objs, count, u = {}, 1, 1
				do
					local a1, _d_a1 = (30), (15)
					for _ = 1, _infinite do
						task._Wait(dt)
						do
							local a0, _d_a0 = (a1), (60)
							for _ = 1, 6 do
								last = New(_editor_class["stage2mid_boss_obj2"], x0 + r1 * cos(a0), y0 + r1 * sin(a0), t1, u, false)
								_connect(self, last, 0, true)
								objs[count] = last
								count = count + 1
								a0 = a0 + _d_a0
							end
						end
						do
							local i, _d_i = (1), (1)
							for _ = 1, 6 do
								last = New(_editor_class["stage2mid_boss_ls2"], x0, y0, objs[i % 6 + 1], objs[(i + 1) % 6 + 1])
								i = i + _d_i
							end
						end
						count = 1
						u = -u
						a1 = a1 + _d_a1
					end
				end
			end)
		end]]
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			local f1
			do
				function f1(x, y, v, a)
					local objs = {}
					for i = 1, 6 do
						table.insert(objs, New(f1_2, x, y, v, a + 60*i))
						_connect(self, objs[i], 0, true)
					end
					for i = 1, 6 do
						New(f1_1, objs[i].x, objs[i].y, objs[i], objs[(i)%6+1])
					end
				end
			end

			task.New(self, function()
				s2_boss.pic_show()
				task._Wait(120)
				do
					task._Wait(10)
					New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
					task._Wait(60)
				end
				PlaySound("tan00")
				f1(self.x + mirror_x, self.y + mirror_y, 2, 0)
				task.Wait(60)
				New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
				task._Wait(60)
				local u = 1
				while true do
					for i = 0, 4 do
						PlaySound("tan00")
						f1(self.x + mirror_x, self.y + mirror_y, 1 + 0.25*i, 72*i*u)
						task.Wait(30)
					end
					task.Wait(60)
					move_rd(60)
					task.Wait(60)
					u = -u
				end
			end)
		end
		function _tmp_sc:del()
			if self.timeout == 1 then
				self.noExtendBonus = true
			else
				Spell_break_eff(self.x, self.y, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')
			end
		end
		_tmp_sc.perform = false
		table.insert(stage2mid_boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2mid_boss:Lunatic", "镜幻「六棱之境」", _tmp_sc, #stage2mid_boss.cards, true })


		_tmp_sc = boss.dialog.New(true)
		function _tmp_sc:init()
			player.dialog = true
			self.dialog_displayer = New(dialog_displayer)
			self._dialog_maintask = task.New(self, function()
				self.colli = false
				player.dialog = false
				if not self.noExtendBonus then
					misc.ShakeScreen(60, 3)
					PlaySound("enep01", 0.5, 0, false)
					_drop_item(item_bomb, 1, self.x, self.y)
				end
				task._Wait(120)
				task.MoveTo(150, 300, 90, MOVE_ACC_DEC)
				_del(self, true)
			end)
		end
		table.insert(stage2mid_boss.cards, _tmp_sc)
		_tmp_sc = boss.card.New("", 2, 15, 60, 600, { 0, 0, 0 }, false)
		function _tmp_sc:init()
			lasttask = task.New(self, function()
				task.MoveTo(0, 144, 180, MOVE_NORMAL)
			end)
		end
		function _tmp_sc:del()
		end
		_tmp_sc.perform = false
		table.insert(stage2mid_boss.cards, _tmp_sc)
		--[[_tmp_sc=boss.card.New("「Super Hexagon!」",2,5,30,1200,{0,0,0},false)
        function _tmp_sc:init()
            local mirror_x, mirror_y = -17, 24
            lasttask=task.New(self,function()
                do
                    s2_boss.pic_show()
                    task._Wait(120)
                    do
                        task._Wait(10)
                        New(AbEff, self.x + mirror_x, self. y + mirror_y,  'star_eff_white', 'tree_leaf_white', 103, 199, 241)
                        task._Wait(60)
                    end
                end
                local t0, r0 = 240, 224
                local t1, r1 = int(3*t0/sqrt(3)), 3*r0/sqrt(3)
                local dt = t1 - t0
                local x0, y0 = 0, 0
                local objs, count = {}, 1
                do local a0,_d_a0=(0),(60) for _=1,6 do
                    last=New(_editor_class["stage2mid_boss_obj3"],x0 + r0*cos(a0), y0 + r0*sin(a0),t0,1)
                    _connect(self,last,0,true)
                    objs[count] = last
                    count = count + 1
                    a0=a0+_d_a0 end end
                do local i,_d_i=(1),(1) for _=1,6 do
                    last=New(_editor_class["stage2mid_boss_ls3"],x0, y0,objs[i%6 + 1],objs[(i+1)%6 + 1])
                    i=i+_d_i end end
                count = 1
                do local a0,_d_a0=(15),(60) for _=1,6 do
                    last=New(_editor_class["stage2mid_boss_obj3"],x0 + r1*cos(a0), y0 + r1*sin(a0),t1,-1)
                    _connect(self,last,0,true)
                    objs[count] = last
                    count = count + 1
                    a0=a0+_d_a0 end end
                do local i,_d_i=(1),(1) for _=1,6 do
                    last=New(_editor_class["stage2mid_boss_ls3"],x0, y0,objs[i%6 + 1],objs[(i+1)%6 + 1])
                    i=i+_d_i end end
                count = 1
                local u = 1
                do local a1,_d_a1=(30),(15) for _=1,_infinite do
                    task._Wait(dt)
                    do local a0,_d_a0=(a1),(60) for _=1,6 do
                        last=New(_editor_class["stage2mid_boss_obj3"],x0 + r1*cos(a0), y0 + r1*sin(a0),t1,u)
                        _connect(self,last,0,true)
                        objs[count] = last
                        count = count + 1
                        a0=a0+_d_a0 end end
                    do local i,_d_i=(1),(1) for _=1,6 do
                        last=New(_editor_class["stage2mid_boss_ls3"],x0, y0,objs[i%6 + 1],objs[(i+1)%6 + 1])
                        i=i+_d_i end end
                    count = 1
                    u = -u
                    a1=a1+_d_a1 end end
            end)
        end
        function _tmp_sc:del()
            Spell_break_eff(self.x, self.y, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')
        end
        _tmp_sc.perform=false
        table.insert(stage2mid_boss.cards,_tmp_sc)
        table.insert(_sc_table,{"stage2mid_boss:Lunatic","「Super Hexagon!」",_tmp_sc,#stage2mid_boss.cards,false})]]
	end
	_editor_class["stage2mid_boss:Lunatic"] = stage2mid_boss

	--关底子弹定义
	do
		_editor_class["s2_一符降落星弹"] = Class(bullet)
		_editor_class["s2_一符降落星弹"].init = function(self, _x, _y, sty, v, a)
			bullet.init(self, sty, COLOR_YELLOW, false, true)
			self.x, self.y = _x, _y
			self.bound = false
			self.omiga = 3
			SetV2(self, v, a, false, false)
			_object.set_color(self, "mul+add", 255, 255, 255, 255)
			lasttask = task.New(self, function()
				task._Wait(360)
				self.bound = true
			end)
			lasttask = task.New(self, function()
				do
					local v1, _d_v1 = (v), ((1.5 - v) / 59)
					for _ = 1, 60 do
						SetV2(self, v1, a, false, false)
						task._Wait(1)
						v1 = v1 + _d_v1
					end
				end
				_object.set_color(self, "", 255, 255, 255, 255)
			end)
		end
		_editor_class["s2_一符使魔预警:Lunatic"] = Class(laser)
		_editor_class["s2_一符使魔预警:Lunatic"].init = function(self, _x, _y, a, c, mode)
			laser.init(self, c, _x, _y, 0, 0, 900, 0, 2, 0, 0)
			self.bound = false
			laser.ChangeImage(self, 4)
			_object.set_color(self, "mul+add", 0, 255, 255, 255)
			self.rot = a
			lasttask = task.New(self, function()
				do
					local aerfa, _d_aerfa = (-90), (360 / 20)
					for _ = 1, 20 do
						_object.set_color(self, "mul+add", 125 + 125 * sin(aerfa), 255, 255, 255)
						task._Wait(1)
						aerfa = aerfa + _d_aerfa
					end
				end
				do
					local v, _d_v = (0.02), (0.075)
					for _ = 1, 10 do
						last = New(_editor_class["s2_一符使魔预警虚影"], self.x, self.y, self.rot, self.rot + 90, v, c)
						last = New(_editor_class["s2_一符使魔预警虚影"], self.x, self.y, self.rot, self.rot - 90, v, c)
						task._Wait(1)
						v = v + _d_v
					end
				end
				task._Wait(60)
				last = New(_editor_class["s2_一符使魔:Lunatic"], self.x, self.y, 10, a, c, mode, self.x, self.y)
				_del(self, true)
			end)
		end
		_editor_class["s2_一符使魔预警:Lunatic"].kill = function(self)
		end
		_editor_class["s2_一符使魔预警虚影"] = Class(laser)
		_editor_class["s2_一符使魔预警虚影"].init = function(self, _x, _y, a, b, v, c)
			laser.init(self, c, _x, _y, 0, 0, 900, 0, 2, 0, 0)
			self.bound = false
			laser.ChangeImage(self, 4)
			_object.set_color(self, "mul+add", 0, 255, 255, 255)
			SetV2(self, v * 2 / 3, b, true, false)
			lasttask = task.New(self, function()
				do
					for _ = 1, _infinite do
						self.rot = a
						task._Wait(1)
					end
				end
			end)
			lasttask = task.New(self, function()
				laser._TurnHalfOn(self, 5, true)
				do
					local aerfa, _d_aerfa = (-90), (360 / 30)
					for _ = 1, 30 do
						_object.set_color(self, "mul+add", 125 + 125 * sin(aerfa), 255, 255, 255)
						task._Wait(1)
						aerfa = aerfa + _d_aerfa
					end
				end
				laser._TurnOff(self, 5, true)
				_del(self, false)
			end)
		end
		_editor_class["s2_一符使魔预警虚影"].kill = function(self)
		end
		_editor_class["s2_一符使魔:Lunatic"] = Class(_object)
		_editor_class["s2_一符使魔:Lunatic"].init = function(self, _x, _y, v, a, c, mode, cx, cy)
			self.x, self.y = _x, _y
			self.img = "magic7"
			self.layer = LAYER_ENEMY_BULLET
			self.group = GROUP_INDES
			self.hide = false
			self.bound = true
			self.navi = false
			self.hp = 75
			self.maxhp = 75
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.omiga = 4
			self.vscale = 0
			self.hscale = 0
			self.bound = false
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (255 / 10)
					local s, _d_s = (0), (0.8 / 10)
					for _ = 1, 10 do
						_object.set_color(self, "mul+add", al, 255, 0, 255)
						self.vscale = s
						self.hscale = s
						task._Wait(1)
						al = al + _d_al
						s = s + _d_s
					end
				end
				SetV2(self, v, a, true, false)
				PlaySound("tan00", 0.1, self.x / 256, false)
				lasttask = task.New(self, function()
					do
						for _ = 1, 24 do
							if (mode == 1) then
								local da = ran:Float(-6, 6)
								last = New(_editor_class["s2_一符飘感弹:Lunatic"], self.x, self.y, a + da, 2, c, mode, cx, cy)
							else
								last = New(_editor_class["s2_一符飘感弹:Lunatic"], self.x, self.y, a, 3, c, mode, cx, cy)
							end
							task._Wait(4)
						end
					end
					_del(self, true)
				end)
			end)
		end
		_editor_class["s2_一符飘感弹:Lunatic"] = Class(bullet)
		_editor_class["s2_一符飘感弹:Lunatic"].init = function(self, _x, _y, a, v0, c, mode, cx, cy)
			bullet.init(self, square, c, false, true)
			self.x, self.y = _x, _y
			self.bound = false
			SetV2(self, 0, a, true, false)
			lasttask = task.New(self, function()
				do
					local v, _d_v = (v0), ((0.01 - v0) / 60)
					for _ = 1, 60 do
						SetV2(self, v, a, true, false)
						task._Wait(1)
						v = v + _d_v
					end
				end
				task._Wait(15)
				if (mode == 1) then
					do
						local v, _d_v = (0.01), ((3 - 0.01) / 60)
						for _ = 1, 60 do
							SetV2(self, v, a + 180, true, false)
							task._Wait(1)
							v = v + _d_v
						end
					end
				else
					do
						local v, _d_v = (0.01), ((3 - 0.01) / 60)
						for _ = 1, 60 do
							SetV2(self, v, a, true, false)
							task._Wait(1)
							v = v + _d_v
						end
					end
				end
				self.bound = true
			end)
			lasttask = task.New(self, function()
				do
					for _ = 1, _infinite do
						if IsValid(_boss) and Dist(self.x, self.y, cx, cy) <= 30 then
							break
						end
						task._Wait(1)
					end
				end
				_del(self, true)
			end)
		end
		_editor_class["s2_一符中心使魔中心:Lunatic"] = Class(_object)
		_editor_class["s2_一符中心使魔中心:Lunatic"].init = function(self, _x, _y, i, sty)
			self.x, self.y = _x, _y
			self.img = "img_void"
			self.layer = LAYER_ENEMY_BULLET - 1
			self.group = GROUP_INDES
			self.hide = true
			self.bound = false
			self.navi = false
			self.hp = 10
			self.maxhp = 10
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.bound = false
			self.rot = 40 * i
			lasttask = task.New(self, function()
				do
					local a, _d_a = (-90 - 100 * i), (200 / 20 * i)
					local mode, _d_mode = (1), (1)
					local vv, _d_vv = (1), (3 / 20)
					local count, _d_count = (2), (1)
					for _ = 1, 20 do
						last = New(_editor_class["s2_一符中心使魔:Lunatic"], self.x, self.y, a, i, self.x, self.y, mode, vv, sty, count)
						_connect(self, last, 0, true)
						task._Wait(3)
						a = a + _d_a
						mode = mode + _d_mode
						vv = vv + _d_vv
						count = count + _d_count
					end
				end
				task._Wait(360)
				_del(self, true)
			end)
		end
		_editor_class["s2_一符中心使魔:Lunatic"] = Class(_object)
		_editor_class["s2_一符中心使魔:Lunatic"].init = function(self, _x, _y, a, i, x, y, mode, vv, sty, count)
			self.x, self.y = _x, _y
			self.img = "magic6"
			self.layer = LAYER_ENEMY_BULLET - 1
			self.group = GROUP_INDES
			self.hide = false
			self.bound = false
			self.navi = false
			self.hp = 10
			self.maxhp = 10
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.bound = false
			self.vscale = 0.8
			self.hscale = 0.8
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (255 / 30)
					for _ = 1, 30 do
						if (count % 2 == 0) then
							_object.set_color(self, "mul+add", al, 255, 255, 255)
						else
							_object.set_color(self, "mul+add", 0, 0, 0, 255)
						end
						_set_rel_pos(self, 175 * cos(a), 75 * sin(a), self.rot, true)
						task._Wait(1)
						al = al + _d_al
					end
				end
				do
					local aa, _d_aa = (a), (60)
					for _ = 1, 6 do
						_create_bullet_group(arrow_big, 8, self.x, self.y, 2, 0, vv * 7 / 8, vv, aa, 0, false, 0, true, false, 0, false, self)
						task._Wait(0)
						aa = aa + _d_aa
					end
				end
				PlaySound("kira00", 0.1, self.x / 256, false)
				if (mode % 3 == 0) then
					do
						local r, _d_r = (1), (5)
						local angle1, _d_angle1 = (a), (23.854 * i)
						local f, _d_f = (11), (-1)
						for _ = 1, 10 do
							do
								local angle2, _d_angle2 = (0), (72)
								for _ = 1, 5 do
									last = New(_editor_class["s2_一符中心使魔星星"], self.x + r * cos(angle1 + angle2), self.y + r * sin(angle1 + angle2), 1, angle1 + angle2 + 90, f, i, COLOR_CYAN)
									task._Wait(0)
									angle2 = angle2 + _d_angle2
								end
							end
							task._Wait(4)
							r = r + _d_r
							angle1 = angle1 + _d_angle1
							f = f + _d_f
						end
					end
				else
					task._Wait(40)
				end
				task._Wait(120)
				if (count % 2 == 0 and count <= 16) then
					if (sty == 1) then
						do
							local aa, _d_aa = (Angle(-20 * i, 230, self.x, self.y)), (120)
							for _ = 1, 3 do
								last = New(_editor_class["s2_一符使魔预警:Lunatic"], self.x, self.y, aa, COLOR_PURPLE, 1)
								aa = aa + _d_aa
							end
						end
					else
						do
							local aa, _d_aa = (Angle(-20 * i, 230, self.x, self.y)), (120)
							for _ = 1, 3 do
								last = New(_editor_class["s2_一符使魔预警:Lunatic"], self.x, self.y, aa, COLOR_GREEN, 0)
								aa = aa + _d_aa
							end
						end
					end
				else
				end
				_del(self, true)
			end)
		end
		_editor_class["s2_一符中心使魔星星"] = Class(bullet)
		_editor_class["s2_一符中心使魔星星"].init = function(self, _x, _y, v, angle, i, j, c)
			bullet.init(self, star_big, c, false, false)
			self.x, self.y = _x, _y
			lasttask = task.New(self, function()
				SetV2(self, 0, angle, true, false)
				task._Wait(i)
				_del(self, true)
			end)
		end
		_editor_class["s2_二符火弹sub"] = Class(bullet)
		_editor_class["s2_二符火弹sub"].init = function(self, _x, _y, mst, scale)
			bullet.init(self, ball_mid, COLOR_DEEP_RED, false, true)
			self.x, self.y = _x, _y
			self.scaled = scale
			self.a = self.a * self.scaled
			self.b = self.b * self.scaled
			self.mst = mst
			self.hide = true
			self.bound = false
			lasttask = task.New(self, function()
				task._Wait(180)
				self.bound = true
			end)
			lasttask = task.New(self, function()
				if (IsValid(self.mst)) then
					_connect(self.mst, self, 0, false)
					_connect(self, self.mst, 0, true)
					do
						for _ = 1, _infinite do
							_set_rel_pos(self, (15 - 4 * self.scaled) * cos(self.mst.rot), (15 - 4 * self.scaled) * sin(self.mst.rot), 0, false)
							task._Wait(1)
						end
					end
				else
					_del(self, false)
				end
			end)
		end
		_editor_class["s2_二符扫地激光"] = Class(laser)
		_editor_class["s2_二符扫地激光"].init = function(self, _x, _y, i)
			laser.init(self, COLOR_ORANGE, _x, _y, 0, 0, 900, 0, 8, 8, 0)
			self.bound = false
			laser.ChangeImage(self, 4)
			laser._TurnHalfOn(self, 1, false)
			_object.set_color(self, "mul+add", 255, 255, 255, 100)
			local a0 = 90 + 30*i
			self.rot = a0
			lasttask = task.New(self, function()
				task._Wait(10)
				PlaySound("power02", 0.1, self.x / 256, false)
				do
					local aerfa, _d_aerfa = (0), (90 / 60)*i
					for _ = 1, 60 do
						self.rot = a0 + 135*sin(aerfa)
						New(_editor_class["s2_二符扫地激光虚影"], self.x, self.y, self.rot)
						for i = 0, 2 do
							_object.set_color(stg.newBulletStraight(stg.water_drop, 14, true, self.x, self.y, 5 + 0.5*i, self.rot), "mul+add", 255, 255, 255, 255)
						end
						task._Wait(1)
						aerfa = aerfa + _d_aerfa
					end
				end
				laser._TurnOff(self, 5, true)
				_del(self, true)
			end)
		end
		_editor_class["s2_二符扫地激光"].kill = function(self)
		end
		_editor_class["s2_二符扫地激光虚影"] = Class(laser)
		_editor_class["s2_二符扫地激光虚影"].init = function(self, _x, _y, a)
			laser.init(self, COLOR_YELLOW, _x, _y, 0, 0, 900, 0, 8, 0, 0)
			self.bound = false
			laser.ChangeImage(self, 4)
			laser._TurnHalfOn(self, 1, false)
			_object.set_color(self, "mul+add", 150, 255, 255, 50)
			self.rot = a
			lasttask = task.New(self, function()
				do
					local al, _d_al = (150), (-150 / 20)
					for _ = 1, 20 do
						_object.set_color(self, "mul+add", al, 255, 255, 50)
						task._Wait(1)
						al = al + _d_al
					end
				end
				laser._TurnOff(self, 1, true)
				_del(self, true)
			end)
		end
		_editor_class["s2_二符扫地激光虚影"].kill = function(self)
		end
		_editor_class["s2_二符使魔:Lunatic"] = Class(_object)
		_editor_class["s2_二符使魔:Lunatic"].init = function(self, _x, _y, cx, cy)
			self.x, self.y = _x, _y
			self.img = "magic2"
			self.layer = LAYER_ENEMY_BULLET
			self.group = GROUP_INDES
			self.hide = false
			self.bound = true
			self.navi = false
			self.hp = 75
			self.maxhp = 75
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.omiga = 4
			self.vscale = 0
			self.hscale = 0
			self.bound = false
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (255 / 10)
					local s, _d_s = (0), (1 / 10)
					for _ = 1, 10 do
						_object.set_color(self, "mul+add", al, 255, 0, 255)
						self.vscale = s
						self.hscale = s
						task._Wait(1)
						al = al + _d_al
						s = s + _d_s
					end
				end
				lasttask = task.New(self, function()
					do
						for _ = 1, 15 do
							last = New(_editor_class["s2_二符使魔残影1"], self.x, self.y, self.rot)
							task._Wait(2)
						end
					end
				end)
				task.MoveTo(cx, cy, 30, MOVE_ACCEL)
				lasttask = task.New(self, function()
					misc.ShakeScreen(10, 3)
					task._Wait(30)
					if (cx > 0) then
						_set_a(self, 0.3, 180, false)
					else
						_set_a(self, 0.3, 0, false)
					end
					self.bound = true
					task._Wait(25)
					if (self.y > 0) then
						do
							for _ = 1, 5 do
								last = New(_editor_class["s2_二符使魔预警:Lunatic"], self.x, self.y, Angle(self, player), COLOR_RED)
								task._Wait(6)
							end
						end
					else
					end
				end)
			end)
		end
		_editor_class["s2_二符使魔预警:Lunatic"] = Class(laser)
		_editor_class["s2_二符使魔预警:Lunatic"].init = function(self, _x, _y, a, c)
			laser.init(self, c, _x, _y, 0, 0, 900, 0, 2, 0, 0)
			self.bound = false
			laser.ChangeImage(self, 4)
			_object.set_color(self, "mul+add", 0, 255, 255, 255)
			self.rot = a
			lasttask = task.New(self, function()
				do
					local v, _d_v = (0.02), (0.065)
					for _ = 1, 10 do
						last = New(_editor_class["s2_一符使魔预警虚影"], self.x, self.y, self.rot, self.rot + 90, v, c)
						last = New(_editor_class["s2_一符使魔预警虚影"], self.x, self.y, self.rot, self.rot - 90, v, c)
						task._Wait(1)
						v = v + _d_v
					end
				end
				task._Wait(60)
				last = New(_editor_class["s2_二符权杖激光:Lunatic"], self.x, self.y, a)
				_del(self, true)
			end)
		end
		_editor_class["s2_二符使魔预警:Lunatic"].kill = function(self)
		end
		_editor_class["s2_二符使魔残影1"] = Class(_object)
		_editor_class["s2_二符使魔残影1"].init = function(self, _x, _y, rot)
			self.x, self.y = _x, _y
			self.img = "magic1"
			self.layer = LAYER_ENEMY_BULLET
			self.group = GROUP_INDES
			self.hide = false
			self.bound = true
			self.navi = false
			self.hp = 75
			self.maxhp = 75
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.rot = rot
			lasttask = task.New(self, function()
				do
					local al, _d_al = (255), (-255 / 10)
					for _ = 1, 10 do
						_object.set_color(self, "mul+add", al, 255, 255, 255)
						task._Wait(1)
						al = al + _d_al
					end
				end
				_del(self, true)
			end)
		end
		_editor_class["s2_二符使魔残影2"] = Class(_object)
		_editor_class["s2_二符使魔残影2"].init = function(self, _x, _y, rot)
			self.x, self.y = _x, _y
			self.img = "magic5"
			self.layer = LAYER_ENEMY_BULLET
			self.group = GROUP_INDES
			self.hide = false
			self.bound = true
			self.navi = false
			self.hp = 75
			self.maxhp = 75
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.rot = rot
			lasttask = task.New(self, function()
				do
					local al, _d_al = (255), (-255 / 10)
					for _ = 1, 10 do
						_object.set_color(self, "mul+add", al, 255, 255, 255)
						task._Wait(1)
						al = al + _d_al
					end
				end
				_del(self, true)
			end)
		end
		_editor_class["s2_二符权杖激光:Lunatic"] = Class(laser)
		_editor_class["s2_二符权杖激光:Lunatic"].init = function(self, _x, _y, a)
			laser.init(self, COLOR_RED, _x, _y, 0, 0, 900, 0, 4, 8, 0)
			laser.ChangeImage(self, 4)
			self.bound = false
			_object.set_color(self, "mul+add", 255, 255, 50, 50)
			self.rot = a
			lasttask = task.New(self, function()
				self.w = 12
				laser._TurnOn(self, 4, true, true)
				lasttask = task.New(self, function()
					task._Wait(5)
					do
						local vv, _d_vv = (2), (6 / 8)
						local r, _d_r = (Dist(self.x, self.y, 0, 0) * 2), (0)
						for _ = 1, 8 do
							last = New(_editor_class["s2_二符权杖火弹"], self.x + r * cos(a), self.y + r * sin(a), vv, a + 180)
							task._Wait(0)
							vv = vv + _d_vv
							r = r + _d_r
						end
					end
				end)
				do
					local w, _d_w = (16), (-16 / 10)
					for _ = 1, 10 do
						self.w = w
						task._Wait(1)
						w = w + _d_w
					end
				end
				_del(self, true)
			end)
		end
		_editor_class["s2_二符权杖火弹"] = Class(bullet)
		_editor_class["s2_二符权杖火弹"].init = function(self, _x, _y, v, a)
			bullet.init(self, water_drop, COLOR_RED, true, false)
			self.x, self.y = _x, _y
			self.bound = false
			lasttask = task.New(self, function()
				task._Wait(60)
				self.bound = true
			end)
			self.navi = true
			SetV2(self, v, a, true, false)
			lasttask = task.New(self, function()
				task._Wait(30)
				_set_a(self, 0.05, 270, false)
			end)
		end
		_editor_class["s2_二符发射使魔:Lunatic"] = Class(_object)
		_editor_class["s2_二符发射使魔:Lunatic"].init = function(self, _x, _y, x, y, j, a1, vv)
			self.x, self.y = _x, _y
			self.img = "magic2"
			self.layer = LAYER_ENEMY_BULLET
			self.group = GROUP_INDES
			self.hide = false
			self.bound = true
			self.navi = false
			self.hp = 75
			self.maxhp = 75
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.omiga = 4 * j
			self.vscale = 0
			self.hscale = 0
			self.bound = false
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (255 / 10)
					local s, _d_s = (0), (1 / 10)
					for _ = 1, 10 do
						_object.set_color(self, "mul+add", al, 255, 0, 255)
						self.vscale = s
						self.hscale = s
						task._Wait(1)
						al = al + _d_al
						s = s + _d_s
					end
				end
				task.MoveTo(x, y, 30, MOVE_ACCEL)
				do
					local a, _d_a = (a1), (45)
					for _ = 1, 8 do
						do
							local b, _d_b = (-1.3), (1.3)
							for _ = 1, 3 do
								last = New(_editor_class["s2_二符发射火弹:Lunatic"], self.x, self.y, vv, a + b, j)
								task._Wait(0)
								b = b + _d_b
							end
						end
						task._Wait(0)
						a = a + _d_a
					end
				end
				task._Wait(60)
				_del(self, true)
			end)
		end
		_editor_class["s2_二符发射火弹:Lunatic"] = Class(bullet)
		_editor_class["s2_二符发射火弹:Lunatic"].init = function(self, _x, _y, v, a, i)
			bullet.init(self, arrow_small, COLOR_RED, true, false)
			self.x, self.y = _x, _y
			self.scale = 2
			self.render_ani_flag = true
			self.img = "ani:s2_fire_drop"
			_object.set_color(self, "mul+add", 255, 255, 255, 255)
			self.bound = false
			lasttask = task.New(self, function()
				task._Wait(180)
				self.bound = true
			end)
			lasttask = task.New(self, function()
				do
					local aerfa, _d_aerfa = (0), (7.5)
					local a1, _d_a1 = (a), (12 * i)
					for _ = 1, 20 do
						SetV2(self, v * sin(aerfa), a1, true, false)
						task._Wait(5)
						aerfa = aerfa + _d_aerfa
						a1 = a1 + _d_a1
					end
				end
			end)
			self.group = GROUP_GHOST
			last = New(_editor_class["s2_二符火弹sub"], self.x, self.y, self, self.scale / 2)
			local last_save = last
			lasttask = task.New(self, function()
				do
					for _ = 1, _infinite do
						if (IsValid(last_save)) then
						else
							_del(self, true)
						end
						task._Wait(1)
					end
				end
			end)
		end
		_editor_class["s2_三符中玉圆中心"] = Class(_object)
		_editor_class["s2_三符中玉圆中心"].init = function(self, _x, _y, i, dr)
			self.x, self.y = _x, _y
			self.img = "img_void"
			self.layer = LAYER_ENEMY_BULLET - 1
			self.group = GROUP_INDES
			self.hide = true
			self.bound = true
			self.navi = false
			self.hp = 10
			self.maxhp = 10
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.bound = false
			lasttask = task.New(self, function()
				do
					local a, _d_a = (0), (60)
					for _ = 1, 6 do
						last = New(_editor_class["s2_三符大玉"], self.x, self.y, a + 30, i, dr)
						_connect(self, last, 0, true)
						do
							local b, _d_b = (-15), (30 / 19)
							for _ = 1, 20 do
								last = New(_editor_class["s2_三符中玉"], self.x, self.y, a + b, i, dr)
								_connect(self, last, 0, true)
								task._Wait(0)
								b = b + _d_b
							end
						end
						task._Wait(0)
						a = a + _d_a
					end
				end
				task._Wait(1200)
				_del(self, true)
			end)
		end
		_editor_class["s2_三符中玉"] = Class(bullet)
		_editor_class["s2_三符中玉"].init = function(self, _x, _y, a, i, dr)
			bullet.init(self, ball_big, COLOR_BLUE, false, false)
			self.x, self.y = _x, _y
			_object.set_color(self, "mul+add", 255, 255, 255, 255)
			self.bound = false
			lasttask = task.New(self, function()
				task._Wait(1400)
				self.bound = true
			end)
			lasttask = task.New(self, function()
				lasttask = task.New(self, function()
					do
						local a1, _d_a1 = (a), (0.3 * i)
						local r, _d_r = (0), (dr)
						for _ = 1, _infinite do
							_set_rel_pos(self, r * cos(a1), r * sin(a1), self.rot, true)
							task._Wait(1)
							a1 = a1 + _d_a1
							r = r + _d_r
						end
					end
				end)
			end)
		end
		_editor_class["s2_三符大玉"] = Class(bullet)
		_editor_class["s2_三符大玉"].init = function(self, _x, _y, a, i, dr)
			bullet.init(self, ball_huge, COLOR_BLUE, false, false)
			self.x, self.y = _x, _y
			self.bound = false
			self.omiga = 2 * i
			lasttask = task.New(self, function()
				task._Wait(1400)
				self.bound = true
			end)
			lasttask = task.New(self, function()
				do
					local angle, _d_angle = (ran:Float(0, 360)), (60)
					for _ = 1, 6 do
						last = New(_editor_class["s2_三符小玉"], self.x, self.y, angle, -1.5 * i)
						_connect(self, last, 0, true)
						task._Wait(0)
						angle = angle + _d_angle
					end
				end
				lasttask = task.New(self, function()
					do
						local a1, _d_a1 = (a), (0.3 * i)
						local r, _d_r = (0), (dr)
						for _ = 1, _infinite do
							_set_rel_pos(self, r * cos(a1), r * sin(a1), self.rot, true)
							task._Wait(1)
							a1 = a1 + _d_a1
							r = r + _d_r
						end
					end
				end)
			end)
		end
		_editor_class["s2_三符小玉"] = Class(bullet)
		_editor_class["s2_三符小玉"].init = function(self, _x, _y, angle, rotate)
			bullet.init(self, ball_mid, COLOR_BLUE, false, false)
			self.x, self.y = _x, _y
			self.rot = angle
			self.omiga = rotate
			self.bound = false
			self.timer = 11
			lasttask = task.New(self, function()
				task._Wait(1400)
				self.bound = true
			end)
			self.colli = false
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (255 / 60)
					for _ = 1, 60 do
						_object.set_color(self, "", al, 255, 255, 255)
						task._Wait(1)
						al = al + _d_al
					end
				end
				self.colli = true
			end)
			lasttask = task.New(self, function()
				do
					local aerfa, _d_aerfa = (90), (2)
					for _ = 1, _infinite do
						local r = 50 + 20 * sin(aerfa)
						_set_rel_pos(self, r * cos(self.rot), r * sin(self.rot), self.rot, false)
						task._Wait(1)
						aerfa = aerfa + _d_aerfa
					end
				end
			end)
		end
		_editor_class["s2_三符激光预警"] = Class(laser)
		_editor_class["s2_三符激光预警"].init = function(self, _x, _y, a, c, v1)
			laser.init(self, c, _x, _y, 0, 0, 900, 0, 2, 0, 0)
			self.bound = false
			laser.ChangeImage(self, 4)
			_object.set_color(self, "mul+add", 0, 255, 255, 255)
			laser._TurnHalfOn(self, 1, false)
			self.rot = a
			lasttask = task.New(self, function()
				do
					local aerfa, _d_aerfa = (-90), (360 / 20)
					for _ = 1, 20 do
						_object.set_color(self, "mul+add", 125 + 125 * sin(aerfa), 255, 255, 255)
						task._Wait(1)
						aerfa = aerfa + _d_aerfa
					end
				end
				do
					local v, _d_v = (0.02), (0.075)
					for _ = 1, 10 do
						last = New(_editor_class["s2_三符激光预警虚影"], self.x, self.y, self.rot, self.rot + 90, v, c)
						last = New(_editor_class["s2_三符激光预警虚影"], self.x, self.y, self.rot, self.rot - 90, v, c)
						task._Wait(1)
						v = v + _d_v
					end
				end
				laser._TurnOff(self, 5, false)
				task._Wait(60)
				last = New(_editor_class["s2_三符射线"], self.x, self.y, 12, a, c, v1)
				_del(self, true)
			end)
		end
		_editor_class["s2_三符激光预警"].kill = function(self)
		end
		_editor_class["s2_三符激光预警虚影"] = Class(laser)
		_editor_class["s2_三符激光预警虚影"].init = function(self, _x, _y, a, b, v, c)
			laser.init(self, c, _x, _y, 0, 0, 900, 0, 2, 0, 0)
			self.bound = false
			laser.ChangeImage(self, 4)
			_object.set_color(self, "mul+add", 0, 255, 255, 255)
			SetV2(self, v * 2 / 3, b, true, false)
			lasttask = task.New(self, function()
				do
					for _ = 1, _infinite do
						self.rot = a
						task._Wait(1)
					end
				end
			end)
			lasttask = task.New(self, function()
				laser._TurnHalfOn(self, 5, true)
				do
					local aerfa, _d_aerfa = (-90), (360 / 30)
					for _ = 1, 30 do
						_object.set_color(self, "mul+add", 125 + 125 * sin(aerfa), 255, 255, 255)
						task._Wait(1)
						aerfa = aerfa + _d_aerfa
					end
				end
				laser._TurnOff(self, 5, true)
				_del(self, false)
			end)
		end
		_editor_class["s2_三符激光预警虚影"].kill = function(self)
		end
		_editor_class["s2_三符射线"] = Class(laser)
		_editor_class["s2_三符射线"].init = function(self, _x, _y, v, a, c, v1)
			laser.init(self, c, _x, _y, 0, 0, 0, 0, 8, 4, 0)
			self.bound = false
			lasttask = task.New(self, function()
				self.rot = a
				laser._TurnOn(self, 1, false, false)
				PlaySound("lazer00", 0.4, 0, false)
				v1 = v1 or 0.25*60
				egg.AddSimStrChV(self, 0, v1, a, 60)
				--_set_a(self, 0.25, a, false)
				lasttask = task.New(self, function()
					task._Wait(10)
					self.node = 0
				end)
				do
					local l, _d_l = (0), (v1/60 * 10)
					for _ = 1, 120 do
						self.l1 = l
						self.l2 = l
						self.l3 = l
						task.Wait(1)
						l = l + _d_l
					end
				end
				task._Wait(270)
				_del(self, true)
			end)
		end
		_editor_class["s3_lsc米弹"] = Class(bullet)
		_editor_class["s3_lsc米弹"].init = function(self, _x, _y, v, a)
			bullet.init(self, grain_a, COLOR_BLUE, true, true)
			self.x, self.y = _x, _y
			self.hscale = 0.85
			self.timer = 11
			SetV2(self, v, a, true, false)
		end
		_editor_class["s3_lsc米弹"].render = function(self)
			self.class.base.render(self)
		end
		_editor_class["s3_lsc激光"] = Class(bullet)
		_editor_class["s3_lsc激光"].init = function(self, _x, _y, a, t, r, g, b)
			bullet.init(self, ball_light, COLOR_GRAY, true, true)
			self.x, self.y = _x, _y
			self.rr = r
			self.gg = g
			self.bb = b
			self.t = t
			_object.set_color(self, "mul+add", 155, 138, 43, 226)
			self.rot = a
			self.vscale = 0.05
			self.timer = 11
			self.bound = false
			self.colli = false
			self.group = GROUP_INDES
			self.undestoryable = true
			lasttask = task.New(self, function()
				do
					local tt, _d_tt = (0), (self.t / 4 / 44)
					for _ = 1, 45 do
						self.rot = self.rot + tt
						_set_rel_pos(self, 0 * cos(self.rot), 0 * sin(self.rot), self.rot, false)
						task._Wait(1)
						tt = tt + _d_tt
					end
				end
				do
					for _ = 1, _infinite do
						while _boss.s3_lsc == 1 do
							task.Wait(1)
						end
						self.rot = self.rot + self.t / 4
						_set_rel_pos(self, 0 * cos(self.rot), 0 * sin(self.rot), self.rot, false)
						task._Wait(1)
					end
				end
			end)
			lasttask = task.New(self, function()
				do
					for _ = 1, _infinite do
						if (_boss.s3_lsc == 1) then
							task.Wait(30)
							New(_editor_class["LSC激光发射预警"], self.x, self.y, self.rot, 3)
							task.Wait(60)
							PlaySound("lazer00", 0.1, self.x / 256, false)
							last = New(_editor_class["s3_lsc装饰"], self.x, self.y, self, self.rot)
							last = New(_editor_class["s3_lsc装饰"], self.x, self.y, self, self.rot)
							_boss.s3_lsc_active = 0
							task._Wait(1)
							_boss.s3_lsc = 0
							do
								local rr, _d_rr = (self.rr), ((138 - self.rr) / 59)
								local gg, _d_gg = (self.gg), ((43 - self.gg) / 59)
								local bb, _d_bb = (self.bb), ((226 - self.bb) / 59)
								for _ = 1, 60 do
									_object.set_color(self, "mul+add", 255, rr, g, bb)
									task._Wait(1)
									rr = rr + _d_rr
									gg = gg + _d_gg
									bb = bb + _d_bb
								end
							end
							task._Wait(100)
							do
								local rr, _d_rr = (138), ((self.rr - 138) / 59)
								local gg, _d_gg = (43), ((self.gg - 43) / 59)
								local bb, _d_bb = (226), ((self.bb - 226) / 59)
								for _ = 1, 60 do
									_object.set_color(self, "mul+add", 255, rr, g, bb)
									task._Wait(1)
									rr = rr + _d_rr
									gg = gg + _d_gg
									bb = bb + _d_bb
								end
							end
							_boss.s3_lsc_active = 1
						else
						end
						task._Wait(1)
					end
				end
			end)
			lasttask = task.New(self, function()
				do
					local h, _d_h = (0), (0.3)
					for _ = 1, 60 do
						self.hscale = h
						task._Wait(1)
						h = h + _d_h
					end
				end
				do
					local rr, _d_rr = (138), ((self.rr - 138) / 59)
					local gg, _d_gg = (43), ((self.gg - 43) / 59)
					local bb, _d_bb = (226), ((self.bb - 226) / 59)
					for _ = 1, 60 do
						_object.set_color(self, "mul+add", 255, rr, g, bb)
						task._Wait(1)
						rr = rr + _d_rr
						gg = gg + _d_gg
						bb = bb + _d_bb
					end
				end
				do
					for _ = 1, _infinite do
						if (abs(self.rot % 360 - Angle(self, player) % 360) < 0.5) then
							if (_boss.s3_lsc_active == 1) then
								_boss.s3_lsc = 1
							end
						end
						task._Wait(1)
					end
				end
			end)
		end
		_editor_class["s3_lsc激光"].kill = function(self)
			local cx, cy = cos(self.rot), sin(self.rot)
			for l = 0, 600, 12 do
				New(item_faith_minor, self.x + l * cx, self.y + l * cy)
			end
		end
		_editor_class["s3_lsc激光1"] = Class(bullet)
		_editor_class["s3_lsc激光1"].init = function(self, _x, _y, a, t, r, g, b)
			bullet.init(self, ball_light, COLOR_GRAY, true, true)
			self.x, self.y = _x, _y
			self.rr = r
			self.gg = g
			self.bb = b
			self.t = t
			if (IsValid(_boss)) then
				_connect(_boss, self, 0, true)
			else
				_del(self, false)
			end
			_object.set_color(self, "mul+add", 155, 138, 43, 226)
			self.rot = a
			self.vscale = 0.05
			self.timer = 11
			self.bound = false
			self.colli = false
			self.group = GROUP_INDES
			lasttask = task.New(self, function()
				do
					local tt, _d_tt = (0), (self.t / 4 / 44)
					for _ = 1, 45 do
						self.rot = self.rot + tt
						_set_rel_pos(self, 0 * cos(self.rot), 0 * sin(self.rot), self.rot, false)
						task._Wait(1)
						tt = tt + _d_tt
					end
				end
				do
					for _ = 1, _infinite do
						while _boss.s3_lsc1 == 1 do
							task.Wait(1)
						end
						self.rot = self.rot + self.t / 4
						_set_rel_pos(self, 0, 0, self.rot, false)
						task._Wait(1)
					end
				end
			end)
			lasttask = task.New(self, function()
				do
					for _ = 1, _infinite do
						if (_boss.s3_lsc1 == 1) then
							task.Wait(30)
							New(_editor_class["LSC激光发射预警"], self.x, self.y, self.rot, 3)
							task.Wait(60)
							PlaySound("lazer00", 0.1, self.x / 256, false)
							last = New(_editor_class["s3_lsc装饰"], self.x, self.y, self, self.rot)
							last = New(_editor_class["s3_lsc装饰"], self.x, self.y, self, self.rot)
							_boss.s3_lsc_active1 = 0
							task._Wait(1)
							_boss.s3_lsc1 = 0
							do
								local rr, _d_rr = (self.rr), ((138 - self.rr) / 59)
								local gg, _d_gg = (self.gg), ((43 - self.gg) / 59)
								local bb, _d_bb = (self.bb), ((226 - self.bb) / 59)
								for _ = 1, 60 do
									_object.set_color(self, "mul+add", 255, rr, g, bb)
									task._Wait(1)
									rr = rr + _d_rr
									gg = gg + _d_gg
									bb = bb + _d_bb
								end
							end
							task._Wait(100)
							do
								local rr, _d_rr = (138), ((self.rr - 138) / 59)
								local gg, _d_gg = (43), ((self.gg - 43) / 59)
								local bb, _d_bb = (226), ((self.bb - 226) / 59)
								for _ = 1, 60 do
									_object.set_color(self, "mul+add", 255, rr, g, bb)
									task._Wait(1)
									rr = rr + _d_rr
									gg = gg + _d_gg
									bb = bb + _d_bb
								end
							end
							_boss.s3_lsc_active1 = 1
						end
						task._Wait(1)
					end
				end
			end)
			lasttask = task.New(self, function()
				do
					local h, _d_h = (0), (0.3)
					for _ = 1, 60 do
						self.hscale = h
						task._Wait(1)
						h = h + _d_h
					end
				end
				do
					local rr, _d_rr = (138), ((self.rr - 138) / 59)
					local gg, _d_gg = (43), ((self.gg - 43) / 59)
					local bb, _d_bb = (226), ((self.bb - 226) / 59)
					for _ = 1, 60 do
						_object.set_color(self, "mul+add", 255, rr, g, bb)
						task._Wait(1)
						rr = rr + _d_rr
						gg = gg + _d_gg
						bb = bb + _d_bb
					end
				end
				do
					for _ = 1, _infinite do
						if (abs(self.rot % 360 - Angle(self, player) % 360) < 0.5) then
							if (_boss.s3_lsc_active1 == 1) then
								_boss.s3_lsc1 = 1
							end
						end
						task._Wait(1)
					end
				end
			end)
		end
		_editor_class["s3_lsc激光1"].kill = function(self)
			--[[ # --]]--[=[
        PreserveObject(self)
    --]=]
			local cx, cy = cos(self.rot), sin(self.rot)
			for l = 0, 600, 12 do
				New(item_faith_minor, self.x + l * cx, self.y + l * cy)
			end


			--[[ # --]]--[=[
        self.group=GROUP_GHOST
        local d=self.vscale
        task.Clear(self)
        task.New(self,function()
            for i=1,30 do
                self.vscale=self.vscale-d/30
                task.Wait()
            end
            Del(self)
        end)
    --]=]
		end
		_editor_class["s2_LSC激光头"] = Class(laser)
		_editor_class["s2_LSC激光头"].init = function(self, _x, _y, a, r, g, b, type)
			laser.init(self, COLOR_GRAY, _x, _y, 0, 0, 0, 0, 6, 6, 0)
			lasttask = task.New(self, function()
				self.rr = r
				self.gg = g
				self.bb = b
				if (IsValid(_boss)) then
					lasttask = task.New(self, function()
						do
							for _ = 1, _infinite do
								if ( type == 0 and _boss.s3_lsc == 1) or ( type == 1 and _boss.s3_lsc1 == 1) then
									while ( type == 0 and _boss.s3_lsc == 1) or ( type == 1 and _boss.s3_lsc1 == 1) do
										task.Wait(1)
									end
									do
										local rr, _d_rr = (self.rr), ((138 - self.rr) / 59)
										local gg, _d_gg = (self.gg), ((43 - self.gg) / 59)
										local bb, _d_bb = (self.bb), ((226 - self.bb) / 59)
										for _ = 1, 60 do
											_object.set_color(self, "mul+add", 100, rr, g, bb)
											task._Wait(1)
											rr = rr + _d_rr
											gg = gg + _d_gg
											bb = bb + _d_bb
										end
									end
									task._Wait(100)
									do
										local rr, _d_rr = (138), ((self.rr - 138) / 59)
										local gg, _d_gg = (43), ((self.gg - 43) / 59)
										local bb, _d_bb = (226), ((self.bb - 226) / 59)
										for _ = 1, 60 do
											_object.set_color(self, "mul+add", 100, rr, g, bb)
											task._Wait(1)
											rr = rr + _d_rr
											gg = gg + _d_gg
											bb = bb + _d_bb
										end
									end
								end
								_set_rel_pos(self, 0, 0, self.rot, false)
								task._Wait(1)
							end
						end
					end)
				else
					_del(self, false)
				end
				SetV2(self, 0, a, true, false)
				laser._TurnHalfOn(self, 30, true)
				task._Wait(30)
				laser._TurnOn(self, 30, false, true)
			end)
		end
		_editor_class["s3_lsc装饰"] = Class(bullet)
		_editor_class["s3_lsc装饰"].init = function(self, _x, _y, mst, a)
			bullet.init(self, ellipse, COLOR_PURPLE, true, true)
			self.x, self.y = _x, _y
			_object.set_color(self, "mul+add", 255, 255, 255, 255)
			self.rot = a
			self.b = self.b - 1
			self.rect = true
			self.group = GROUP_INDES
			self.undestoryable = true
			local colli_a = self.a
			self.bound = false
			lasttask = task.New(self, function()
				if (IsValid(mst)) then
					_connect(mst, self, 0, true)
				else
					_del(self, false)
				end
				local l = 0
				do
					local v, _d_v = (0), (6 / 25)
					local h, _d_h = (0), (2.5 / 25)
					for _ = 1, 25 do
						self.hscale = h * 2
						self.a = h * 3 * colli_a + 7.001
						SetV2(self, v, self.rot, true, false)
						task._Wait(1)
						v = v + _d_v
						h = h + _d_h
					end
				end
				task._Wait(400)
				self.bound = true
			end)
		end
		_editor_class["s2_LSC镜子椭圆"] = Class(_object)
		_editor_class["s2_LSC镜子椭圆"].init = function(self, _x, _y, i)
			self.x, self.y = _x, _y
			self.img = "img_void"
			self.layer = LAYER_ENEMY_BULLET
			self.group = GROUP_INDES
			self.hide = true
			self.bound = true
			self.navi = false
			self.hp = 10
			self.maxhp = 10
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.bound = false
			self.rot = 0
			lasttask = task.New(self, function()
				last = New(_editor_class["s2_LSC镜子"], self.x, self.y, 0, i)
				_connect(self, last, 0, true)
				do
					for _ = 1, _infinite do
						while (i == 1 and _boss.s3_lsc == 1) or (i ~= 1 and _boss.s3_lsc1 == 1) do
							task.Wait(1)
						end
						_set_rel_pos(self, 0, 0, self.rot, false)
						self.rot = self.rot + 0.45 * i
						task._Wait(1)
					end
				end
			end)
		end
		_editor_class["s2_LSC镜子"] = Class(_object)
		_editor_class["s2_LSC镜子"].init = function(self, _x, _y, a0, i)
			self.x, self.y = _x, _y
			self.img = "image:mgmk1"
			self.layer = LAYER_ENEMY_BULLET
			self.group = GROUP_INDES
			self.hide = false
			self.undestoryable = true
			self.bound = true
			self.navi = false
			self.hp = 10
			self.maxhp = 10
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.bound = false
			self.omiga = 4 * i
			self.vscale = 0
			self.hscale = 0
			_object.set_color(self, "mul+add", 200, 250, 250, 250)
			lasttask = task.New(self, function()
				do
					local s, _d_s = (0), ((1 / 20) / 30)
					for _ = 1, 30 do
						self.vscale = s
						self.hscale = s
						task._Wait(1)
						s = s + _d_s
					end
				end
			end)
			if (i == 1) then
				lasttask = task.New(self, function()
					last = New(_editor_class["s2_LSC激光头"], self.x, self.y, self.rot, 255, 99, 71, 0)
					_connect(self, last, 0, true)
					do
						local a, _d_a = (0), (360 / 12)
						for _ = 1, 12 do
							last = New(_editor_class["s3_lsc激光"], self.x, self.y, a, 1, 255, 99, 71)
							_connect(self, last, 0, true)
							a = a + _d_a
						end
					end
				end)
			else
				lasttask = task.New(self, function()
					last = New(_editor_class["s2_LSC激光头"], self.x, self.y, self.rot, 255, 99, 71, 1)
					_connect(self, last, 0, true)
					do
						local a, _d_a = (0), (360 / 12)
						for _ = 1, 12 do
							last = New(_editor_class["s3_lsc激光1"], self.x, self.y, a, -1, 255, 99, 71)
							_connect(self, last, 0, true)
							a = a + _d_a
						end
					end
				end)
			end
			--移动
			lasttask = task.New(self, function()
				do
					local a, _d_a = (a0), (0.9 * i)
					local r, _d_r = (0), (100 / 90)
					for _ = 1, 90 do
						_set_rel_pos(self, r * cos(a), r * sin(a) / 4, self.rot, true)
						task.Wait(1)
						a = a + _d_a
						r = r + _d_r
					end
				end
				do
					local a, _d_a = (a0 + 90 * 0.9 * i), (0.9 * i)
					for _ = 1, _infinite do
						self.omiga = 0
						while (i == 1 and _boss.s3_lsc == 1) or (i ~= 1 and _boss.s3_lsc1 == 1) do
							task.Wait(1)
						end
						self.omiga = 4 * i
						_set_rel_pos(self, 100 * cos(a), 100 * sin(a) / 4, self.rot, true)
						task.Wait(1)
						a = a + _d_a
					end
				end
			end)
			--发弹幕
			lasttask = task.New(self, function()
				task._Wait(90)
				do
					local aa, _d_aa = (self.rot), (-1.37 * i)
					local aerfa, _d_aerfa = (0), (6)
					for _ = 1, _infinite do
						if (self.timer % 4 == 0) then
							do
								local b, _d_b = (0), (360 / 5)
								for _ = 1, 5 do
									last = New(_straight, arrow_big, 4 + 2 * i, self.x + 16 * cos(aa + b), self.y + 16 * sin(aa + b), 1.5 + 0.5 * sin(aerfa), aa + b, false, 0, false, true, 0, false, 0, 0, 0, false)
									b = b + _d_b
								end
							end
						end
						task._Wait(1)
						aa = aa + _d_aa
						aerfa = aerfa + _d_aerfa
					end
				end
			end)
		end
	end
	--关底boss定义
	local stage2boss
	do
		stage2boss = Class(boss)
		stage2boss.cards = {}
		stage2boss.name = "Emitsu"
		stage2boss.init = function(self, cards)
			boss.init(self, 240, 384, "Emitsu", cards, New(s2_boss.scbg), "Lunatic")
			lstg.wis.Emitsu(self)
		end
		stage2boss.bgm = "s2_boss"
		stage2boss._bg = stage2_background
		stage2boss.difficulty = "Lunatic"
		-- 入场
		s2_boss_common_action(stage2boss)
		-- 攻击
		_tmp_sc = boss.card.New("常规攻击1", 2, 5, 40, 1000, { 0, 0, 0 }, false, "normal")
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					task._Wait(10)
					self._wisys:setAction("cast", 60)
					New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
					task._Wait(60)
				end
				local a0, t0, u, dsp = nil, 36, 1, 30
				do
					for _ = 1, _infinite do
						a0 = 90 + 90 * u
						do
							for _ = 1, 18 do
								last = New(_editor_class["s2_boss_ls1"], self.x + mirror_x + 10 * cos(a0), self.y + mirror_y + 10 * sin(a0), a0, t0, u)
								a0 = a0 - 9 * u
								task._Wait(1)
								last = New(_editor_class["s2_boss_ls2"], self.x + mirror_x + 10 * cos(a0), self.y + mirror_y + 10 * sin(a0), a0)
								a0 = a0 - 9 * u
								t0 = t0 - 3
								task._Wait(1)
							end
						end
						t0 = 36
						lasttask = task.New(self, function()
							task.MoveToPlayer(30, -96, 96, 110, 130, 16, 32, 8, 16, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
						end)
						do
							for _ = 1, 18 do
								last = New(_editor_class["s2_boss_ls1"], self.x + mirror_x + 10 * cos(a0), self.y + mirror_y + 10 * sin(a0), a0, t0, -u)
								a0 = a0 - 9 * u
								task._Wait(1)
								last = New(_editor_class["s2_boss_ls2"], self.x + mirror_x + 10 * cos(a0), self.y + mirror_y + 10 * sin(a0), a0)
								a0 = a0 - 9 * u
								t0 = t0 - 3
								task._Wait(1)
							end
						end
						t0 = 36
						u = -u
						task._Wait(135)
						do
							for _ = 1, 3 do
								a0 = Angle(self.x + mirror_x, self.y + mirror_y, player.x, player.y) + dsp
								do
									for _ = 1, 3 do
										last = New(_editor_class["s2_boss_ls3"], self.x + mirror_x, self.y + mirror_y, a0)
										a0 = a0 - dsp
									end
								end
								task._Wait(30)
							end
						end
						task._Wait(90)
					end
				end
			end)
		end
		function _tmp_sc:del()
		end
		_editor_cards.s2_01_L = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage2boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2boss:Lunatic", "常规攻击1", _tmp_sc, #stage2boss.cards, true })

		boss_action(stage2boss, 0, 104)
		_tmp_sc = boss.card.New("预兆「天狼星愚者之旅」", 3, 5, 60, 2000, { 10, 20, 30 }, false)
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					s2_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
						task._Wait(60)
					end
				end
				local i = 1
				do
					for _ = 1, _infinite do
						last = New(_editor_class["s2_一符中心使魔中心:Lunatic"], self.x + mirror_x, self.y + mirror_y, i, 1)
						i = -i
						task.MoveToPlayer(60, -24, 24, 112, 124, 8, 16, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
						last = New(_editor_class["s2_一符中心使魔中心:Lunatic"], self.x + mirror_x, self.y + mirror_y, i, 2)
						task.MoveToPlayer(60, -24, 24, 112, 124, 8, 16, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
						task._Wait(90)
						task._Wait(60)
					end
				end
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')
		end
		_editor_cards.s2_11_L = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage2boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2boss:Lunatic", "预兆「天狼星愚者之旅」", _tmp_sc, #stage2boss.cards, true })

		boss_action(stage2boss, 0, 120)
		_tmp_sc = boss.card.New("常规攻击2", 2, 5, 40, 1000, { 0, 0, 0 }, false, "normal")
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					task._Wait(10)
					self._wisys:setAction("cast", 60)
					New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
					task._Wait(60)
				end
				local a0, t0, u, dsp, da = nil, 36, 1, 45, da
				do
					for _ = 1, _infinite do
						a0 = 90 + 90 * u + ran:Float(-5, 5)
						do
							for _ = 1, 2 do
								do
									for _ = 1, 18 do
										last = New(_editor_class["s2_boss_ls4"], self.x + 30 * cos(a0 + 120 * u) + mirror_x, self.y + 30 * sin(a0 + 120 * u) + mirror_y, a0, u)
										a0 = a0 + 10.5 * u
										task._Wait(1)
										last = New(_editor_class["s2_boss_ls5"], self.x + 30 * cos(a0 + 120 * u) + mirror_x, self.y + 30 * sin(a0 + 120 * u) + mirror_y, a0)
										a0 = a0 + 10.5 * u
										t0 = t0 - 2
										task._Wait(1)
									end
								end
								t0 = 36
								do
									for _ = 1, 18 do
										last = New(_editor_class["s2_boss_ls4"], self.x + 30 * cos(a0 + 120 * u) + mirror_x, self.y + 30 * sin(a0 + 120 * u) + mirror_y, a0, -u)
										a0 = a0 + 10.5 * u
										task._Wait(1)
										last = New(_editor_class["s2_boss_ls5"], self.x + 30 * cos(a0 + 120 * u) + mirror_x, self.y + 30 * sin(a0 + 120 * u) + mirror_y, a0)
										a0 = a0 + 10.5 * u
										t0 = t0 - 2
										task._Wait(1)
									end
								end
								t0 = 36
							end
						end
						task.MoveToPlayer(30, -12, 135, 110, 130, 16, 32, 8, 16, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
						task._Wait(45)
						a0 = Angle(self.x + mirror_x, self.y + mirror_y, player.x, player.y) + 7 * u
						da = -14 / 8 * u
						do
							for _ = 1, 9 do
								a0 = a0 + da + dsp
								do
									for _ = 1, 3 do
										last = New(_editor_class["s2_boss_ls6"], self.x + mirror_x, self.y + mirror_y, a0)
										a0 = a0 - dsp
									end
								end
								a0 = a0 + 2 * dsp
								task._Wait(6)
							end
						end
						do
							for _ = 1, 9 do
								a0 = a0 - 1.5 * da + dsp
								do
									for _ = 1, 3 do
										last = New(_editor_class["s2_boss_ls6"], self.x + mirror_x, self.y + mirror_y, a0)
										a0 = a0 - dsp
									end
								end
								a0 = a0 + 2 * dsp
								task._Wait(6)
							end
						end
						u = -u
						task._Wait(90)
					end
				end
			end)
		end
		function _tmp_sc:del()
		end
		_editor_cards.s2_02_L = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage2boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2boss:Lunatic", "常规攻击2", _tmp_sc, #stage2boss.cards, true })

		boss_action(stage2boss, 0, 124)
		_tmp_sc = boss.card.New("火符「阿芙洛狄忒权杖X」", 3, 5, 60, 1500, { 10, 20, 30 }, false)
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					s2_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
						task._Wait(60)
					end
				end
				local i = 1
				do
					for _ = 1, _infinite do
						PlaySound("tan00", 0.1, self.x / 256, false)
						local a = Angle(self, player)
						local j = i
						do
							local r, _d_r = (5), (20)
							local vv, _d_vv = (1.5), (0.5)
							for _ = 1, 6 do
								do
									local a1, _d_a1 = (a - 18 + 18 * j), (72)
									for _ = 1, 5 do
										last = New(_editor_class["s2_二符发射使魔:Lunatic"], self.x + mirror_x, self.y + mirror_y, self.x + r * cos(a1), self.y + r * sin(a1), j, a1, vv)
										_connect(self, last, 0, true)
										task._Wait(0)
										a1 = a1 + _d_a1
									end
								end
								PlaySound("tan00", 0.1, 0, false)
								j = -j
								task._Wait(9)
								r = r + _d_r
								vv = vv + _d_vv
							end
						end
						boss.cast(self, 0)
						task._Wait(1)
						boss.cast(self, _infinite)
						New(_editor_class["s2_二符扫地激光"], self.x + mirror_x, self.y + mirror_y, i)
						New(_editor_class["s2_二符扫地激光"], self.x + mirror_x, self.y + mirror_y, -i)
						task._Wait(60)
						do
							last = New(_editor_class["s2_二符使魔:Lunatic"], self.x + mirror_x, self.y + mirror_y, -195, 230)
							last = New(_editor_class["s2_二符使魔:Lunatic"], self.x + mirror_x, self.y + mirror_y, 195, 230)
							last = New(_editor_class["s2_二符使魔:Lunatic"], self.x + mirror_x, self.y + mirror_y, -195, -230)
							last = New(_editor_class["s2_二符使魔:Lunatic"], self.x + mirror_x, self.y + mirror_y, 195, -230)
						end
						task.MoveToPlayer(60, -96, 96, 112, 144, 16, 32, 8, 16, MOVE_NORMAL, MOVE_X_TOWARDS_PLAYER)
						task._Wait(180)
						i = -i
						task._Wait(0)
					end
				end
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')
		end
		_editor_cards.s2_12_L = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage2boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2boss:Lunatic", "火符「阿芙洛狄忒权杖X」", _tmp_sc, #stage2boss.cards, true })

		boss_action(stage2boss, 0, 124)
		_tmp_sc = boss.card.New("逆位「转动命运之轮」", 3, 5, 55, 2500, { 10, 20, 30 }, false)
		function _tmp_sc:init()
			local mirror_x, mirror_y = -17, 24
			lasttask = task.New(self, function()
				do
					s2_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
						task._Wait(60)
					end
				end
				lasttask = task.New(self, function()
					local i = 1
					do
						for _ = 1, _infinite do
							last = New(_editor_class["s2_三符中玉圆中心"], self.x + mirror_x, self.y + mirror_y, i, 1)
							PlaySound("tan00", 0.1, self.x / 256, false)
							i = -i
							task._Wait(140)
						end
					end
				end)
				task._Wait(450)
				do
					task._Wait(10)
					self._wisys:setAction("cast", 60)
					New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
					task._Wait(60)
				end
				do
					for _ = 1, _infinite do
						do
							local a, _d_a = (Angle(self.x + mirror_x, self.y + mirror_y, player.x, player.y)), (24)
							for _ = 1, 15 do
								last = New(_editor_class["s2_三符激光预警"], self.x + mirror_x, self.y + mirror_y, a, COLOR_PURPLE, 0.2*60)
								task._Wait(0)
								a = a + _d_a
							end
						end
						task._Wait(140)
					end
				end
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')
		end
		_editor_cards.s2_13_L = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage2boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage2boss:Lunatic", "逆位「转动命运之轮」", _tmp_sc, #stage2boss.cards, true })
	end
	_editor_class["stage2boss:Lunatic"] = stage2boss
end

-- lsc符卡前事件
local function create_lscEvent_class(self)
	local _show = boss.dialog.New(true)
	function _show:init()
		player.dialog=false
		self.dialog_displayer=New(dialog_displayer)
		self._dialog_maintask=task.New(self,function()
			lscNoBombCheck(self)
		end)
	end
	return _show
end

--LSC
do
	--弹幕定义
	do
		_editor_class["LSC激光发射预警"] = Class(laser)
		_editor_class["LSC激光发射预警"].init = function(self, _x, _y, a, c)
			laser.init(self, c, _x, _y, 0, 0, 900, 0, 2, 0, 0)
			self.bound = false
			laser.ChangeImage(self, 4)
			_object.set_color(self, "mul+add", 0, 255, 255, 255)
			self.rot = a
			task.New(self, function()
				local aerfa, _d_aerfa = (-90), (360 / 20)
				for _ = 1, 20 do
					_object.set_color(self, "mul+add", 125 + 125 * sin(aerfa), 255, 255, 255)
					task._Wait(1)
					aerfa = aerfa + _d_aerfa
				end
				do
					local v, _d_v = (0.02), (0.075)
					for _ = 1, 10 do
						last = New(_editor_class["s2_一符使魔预警虚影"], self.x, self.y, self.rot, self.rot + 90, v, c)
						last = New(_editor_class["s2_一符使魔预警虚影"], self.x, self.y, self.rot, self.rot - 90, v, c)
						task._Wait(1)
						v = v + _d_v
					end
				end
				task._Wait(60)
				Del(self)
			end)
		end
	end
	--Easy
	do
		local LSC2
		LSC2 = Class(boss)
		LSC2.cards = {}
		LSC2.name = "Emitsu"
		LSC2.init = function(self, cards)
			boss.init(self, 0, 124, "Emitsu", cards, New(s2_boss.scbg), "Easy")
			lstg.wis.Emitsu(self)
		end
		LSC2.bgm = "s2_boss"
		LSC2._bg = stage2_background
		LSC2.difficulty = "Easy"
		--table.insert(LSC2.cards, create_lscEvent_class(self))
		_tmp_sc = boss.dialog.New(true)
		function _tmp_sc:init()
			player.dialog = false
			self.dialog_displayer = New(dialog_displayer)
			self._dialog_maintask = task.New(self, function()
				--self.sc_bonus_max = 15000000
				--self.sc_bonus_base = 3000000
				lscNoBombCheck(self)
				boss.show_aura(self, true)
			end)
		end
		table.insert(LSC2.cards, _tmp_sc)
		_tmp_sc = boss.card.New("云外镜奥义「实数与虚数的境界」", 3, 4, 60, 2000, { 0, 0, 60 }, false, "lastspell")
		function _tmp_sc:init()
			New(lscSpecialEvent, self)
			local mirror_x, mirror_y = -17, 24
			lstg.tmpvar.lsc_flag = true
			lasttask = task.New(self, function()
				do
					for _ = 1, _infinite do
						if (lstg.tmpvar.lsc_flag == nil) then
							_kill(self, true)
						else
						end
						task._Wait(1)
					end
				end
			end)
			self.s3_lsc_active = 1
			self.s3_lsc = 0
			self.s3_lsc_active1 = 1
			self.s3_lsc1 = 0
			lasttask = task.New(self, function()
				do
					s2_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
						task._Wait(60)
					end
				end
				last = New(_editor_class["s2_LSC激光头"], self.x + mirror_x, self.y + mirror_y, self.rot, 255, 99, 71)
				lasttask = task.New(self, function()
					task._Wait(200)
					do
						for _ = 1, _infinite do
							do
								local v, _d_v = (1), (1)
								for _ = 1, 2 do
									do
										local a, _d_a = (ran:Float(0, 360)), (360 / 20)
										for _ = 1, 20 do
											last = New(_editor_class["s3_lsc米弹"], self.x + mirror_x, self.y + mirror_y, v, a)
											--[[ # --]]--[=[
                            last=New(_straight,grain_a,COLOR_BLUE,self.x+mirrorx,self.y+mirrory,v,a,false,0,true,true,0,false,0,0,0,false)
                        --]=]
											task._Wait(0)
											a = a + _d_a
										end
									end
									task._Wait(0)
									v = v + _d_v
								end
							end
							task._Wait(113)
						end
					end
				end)
				do
					local a, _d_a = (0), (360 / 12)
					for _ = 1, 12 do
						last = New(_editor_class["s3_lsc激光:Easy"], self.x + mirror_x, self.y + mirror_y, a, 1, 255, 99, 71)
						task._Wait(0)
						a = a + _d_a
					end
				end
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')
			lstg.tmpvar.lsc_flag = nil
		end
		_editor_cards.s2_lsc_E = _tmp_sc
		_tmp_sc.perform = false
		table.insert(LSC2.cards, _tmp_sc)
		table.insert(_sc_table, { "LSC2:Easy", "云外镜奥义「实数与虚数的境界」", _tmp_sc, #LSC2.cards, true })

		_editor_class["LSC2:Easy"] = LSC2
	end
	--Normal
	do
		local LSC2
		LSC2 = Class(boss)
		LSC2.cards = {}
		LSC2.name = "Emitsu"
		LSC2.init = function(self, cards)
			boss.init(self, 0, 124, "Emitsu", cards, New(s2_boss.scbg), "Normal")
			lstg.wis.Emitsu(self)
		end
		LSC2.bgm = "s2_boss"
		LSC2._bg = stage2_background
		LSC2.difficulty = "Normal"
		--table.insert(LSC2.cards, create_lscEvent_class(self))
		_tmp_sc = boss.dialog.New(true)
		function _tmp_sc:init()
			player.dialog = false
			self.dialog_displayer = New(dialog_displayer)
			self._dialog_maintask = task.New(self, function()
				--self.sc_bonus_max = 15000000
				--self.sc_bonus_base = 3000000
				lscNoBombCheck(self)
				boss.show_aura(self, true)
			end)
		end
		table.insert(LSC2.cards, _tmp_sc)
		_tmp_sc = boss.card.New("云外镜奥义「实数与虚数的境界」", 3, 4, 60, 2000, { 0, 0, 60 }, false, "lastspell")
		function _tmp_sc:init()
			New(lscSpecialEvent, self)
			local mirror_x, mirror_y = -17, 24
			lstg.tmpvar.lsc_flag = true
			lasttask = task.New(self, function()
				do
					for _ = 1, _infinite do
						if (lstg.tmpvar.lsc_flag == nil) then
							_kill(self, true)
						else
						end
						task._Wait(1)
					end
				end
			end)
			self.s3_lsc_active = 1
			self.s3_lsc = 0
			self.s3_lsc_active1 = 1
			self.s3_lsc1 = 0
			lasttask = task.New(self, function()
				do
					s2_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
						task._Wait(60)
					end
				end
				last = New(_editor_class["s2_LSC激光头"], self.x + mirror_x, self.y + mirror_y, self.rot, 255, 99, 71)
				lasttask = task.New(self, function()
					task._Wait(200)
					do
						for _ = 1, _infinite do
							do
								local v, _d_v = (1), (1)
								for _ = 1, 3 do
									do
										local a, _d_a = (ran:Float(0, 360)), (360 / 27)
										for _ = 1, 27 do
											last = New(_editor_class["s3_lsc米弹"], self.x + mirror_x, self.y + mirror_y, v, a)
											--[[ # --]]--[=[
                            last=New(_straight,grain_a,COLOR_BLUE,self.x+mirrorx,self.y+mirrory,v,a,false,0,true,true,0,false,0,0,0,false)
                        --]=]
											task._Wait(0)
											a = a + _d_a
										end
									end
									task._Wait(0)
									v = v + _d_v
								end
							end
							task._Wait(83)
						end
					end
				end)
				do
					local a, _d_a = (0), (360 / 12)
					for _ = 1, 12 do
						last = New(_editor_class["s3_lsc激光:Normal"], self.x + mirror_x, self.y + mirror_y, a, 1, 255, 99, 71)
						task._Wait(0)
						a = a + _d_a
					end
				end
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')
			lstg.tmpvar.lsc_flag = nil
		end
		_editor_cards.s2_lsc_N = _tmp_sc
		_tmp_sc.perform = false
		table.insert(LSC2.cards, _tmp_sc)
		table.insert(_sc_table, { "LSC2:Normal", "云外镜奥义「实数与虚数的境界」", _tmp_sc, #LSC2.cards, true })
		_editor_class["LSC2:Normal"] = LSC2
	end
	--Hard
	do
		local LSC2
		LSC2 = Class(boss)
		LSC2.cards = {}
		LSC2.name = "Emitsu"
		LSC2.init = function(self, cards)
			boss.init(self, 0, 84, "Emitsu", cards, New(s2_boss.scbg), "Hard")
			lstg.wis.Emitsu(self)
		end
		LSC2.bgm = "s2_boss"
		LSC2._bg = stage2_background
		LSC2.difficulty = "Hard"
		--table.insert(LSC2.cards, create_lscEvent_class(self))
		_tmp_sc = boss.dialog.New(true)
		function _tmp_sc:init()
			player.dialog = false
			self.dialog_displayer = New(dialog_displayer)
			self._dialog_maintask = task.New(self, function()
				--self.sc_bonus_max = 15000000
				--self.sc_bonus_base = 3000000
				lscNoBombCheck(self)
				boss.show_aura(self, true)
			end)
		end
		table.insert(LSC2.cards, _tmp_sc)
		_tmp_sc = boss.card.New("「神无月镜太郎的猎犬」", 3, 15, 50, 2000, { 0, 0, 60 }, false, "lastspell")
		function _tmp_sc:init()
			New(lscSpecialEvent, self)
			local mirror_x, mirror_y = -17, 24
			lstg.tmpvar.lsc_flag = true
			lasttask = task.New(self, function()
				do
					for _ = 1, _infinite do
						if (lstg.tmpvar.lsc_flag == nil) then
							_kill(self, true)
						else
						end
						task._Wait(1)
					end
				end
			end)
			self.s3_lsc_active = 1
			self.s3_lsc = 0
			self.s3_lsc_active1 = 1
			self.s3_lsc1 = 0
			lasttask = task.New(self, function()
				do
					s2_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
						task._Wait(60)
					end
				end
				last = New(_editor_class["s2_LSC镜子椭圆:Hard"], self.x + mirror_x, self.y + mirror_y, -1)
				_connect(self, last, 0, true)
				task._Wait(450)
				do
					task._Wait(10)
					self._wisys:setAction("cast", 60)
					New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
					task._Wait(60)
				end
				last = New(_editor_class["s2_LSC镜子椭圆:Hard"], self.x + mirror_x, self.y + mirror_y, 1)
				_connect(self, last, 0, true)
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')
			lstg.tmpvar.lsc_flag = nil
		end
		_editor_cards.s2_lsc_H = _tmp_sc
		_tmp_sc.perform = false
		table.insert(LSC2.cards, _tmp_sc)
		table.insert(_sc_table, { "LSC2:Hard", "「神无月镜太郎的猎犬」", _tmp_sc, #LSC2.cards, true })
		_editor_class["LSC2:Hard"] = LSC2
	end
	--Lunatic
	do
		local LSC2
		LSC2 = Class(boss)
		LSC2.cards = {}
		LSC2.name = "Emitsu"
		LSC2.init = function(self, cards)
			boss.init(self, 0, 84, "Emitsu", cards, New(s2_boss.scbg), "Lunatic")
			lstg.wis.Emitsu(self)
		end
		LSC2.bgm = "s2_boss"
		LSC2._bg = stage2_background
		LSC2.difficulty = "Lunatic"
		--table.insert(LSC2.cards, create_lscEvent_class(self))
		_tmp_sc = boss.dialog.New(true)
		function _tmp_sc:init()
			player.dialog = false
			self.dialog_displayer = New(dialog_displayer)
			self._dialog_maintask = task.New(self, function()
				lscNoBombCheck(self)
				boss.show_aura(self, true)
			end)
		end
		table.insert(LSC2.cards, _tmp_sc)
		_tmp_sc = boss.card.New("「通灵侦探的脚下埋着尸体」", 3, 15, 50, 2000, { 0, 0, 60 }, false, "lastspell")
		function _tmp_sc:init()
			New(lscSpecialEvent, self)
			local mirror_x, mirror_y = -17, 24
			lstg.tmpvar.lsc_flag = true
			lasttask = task.New(self, function()
				do
					for _ = 1, _infinite do
						if (lstg.tmpvar.lsc_flag == nil) then
							_kill(self, true)
						else
						end
						task._Wait(1)
					end
				end
			end)
			self.s3_lsc_active = 1
			self.s3_lsc = 0
			self.s3_lsc_active1 = 1
			self.s3_lsc1 = 0
			lasttask = task.New(self, function()
				do
					s2_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
						task._Wait(60)
					end
				end
				last = New(_editor_class["s2_LSC镜子椭圆"], self.x, self.y, -1)
				_connect(self, last, 0, true)
				task._Wait(450)
				do
					task._Wait(10)
					self._wisys:setAction("cast", 60)
					New(AbEff, self.x + mirror_x, self. y + mirror_y, 'star_eff_white', 'tree_leaf_white', 103, 199, 241)
					task._Wait(60)
				end
				last = New(_editor_class["s2_LSC镜子椭圆"], self.x, self.y, 1)
				_connect(self, last, 0, true)
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')
			lstg.tmpvar.lsc_flag = nil
		end
		_editor_cards.s2_lsc_L = _tmp_sc
		_tmp_sc.perform = false
		table.insert(LSC2.cards, _tmp_sc)
		table.insert(_sc_table, { "LSC2:Lunatic", "「通灵侦探的脚下埋着尸体」", _tmp_sc, #LSC2.cards, true })
		_editor_class["LSC2:Lunatic"] = LSC2
	end
end

--召唤boss，diff填1到4对应e到l，如果不填则自动匹配全局难度参数difficulty
function s2_boss.mid(diff)
	local boss
	diff = diff or difficulty
	if diff == 1 then
		boss = New(_editor_class["stage2mid_boss:Easy"], _editor_class["stage2mid_boss:Easy"].cards)
	elseif diff == 2 then
		boss = New(_editor_class["stage2mid_boss:Normal"], _editor_class["stage2mid_boss:Normal"].cards)
	elseif diff == 3 then
		boss = New(_editor_class["stage2mid_boss:Hard"], _editor_class["stage2mid_boss:Hard"].cards)
	elseif diff == 4 then
		boss = New(_editor_class["stage2mid_boss:Lunatic"], _editor_class["stage2mid_boss:Lunatic"].cards)
	end
	--道中boss等待
	while IsValid(boss) do
		task.Wait(1)
	end
end
function s2_boss.main(diff, nolscachi)
	local boss
	diff = diff or difficulty
	if diff == 1 then
		boss = New(_editor_class["stage2boss:Easy"], _editor_class["stage2boss:Easy"].cards)
	elseif diff == 2 then
		boss = New(_editor_class["stage2boss:Normal"], _editor_class["stage2boss:Normal"].cards)
	elseif diff == 3 then
		boss = New(_editor_class["stage2boss:Hard"], _editor_class["stage2boss:Hard"].cards)
	elseif diff == 4 then
		boss = New(_editor_class["stage2boss:Lunatic"], _editor_class["stage2boss:Lunatic"].cards)
	end
	--关底boss等待
	while IsValid(boss) do
		task.Wait(1)
	end
	if system.checkChainAchieve() then
		if not nolscachi then
			--成就 解锁二面LSC (id:32)
			achievement.unlock("32", true)
		end
		task.Wait(180)
		LSC_eff(0, 84, 103, 199, 241, 'star_eff_white', 'tree_leaf_white')
		task.Wait(120)
		s2_boss.LSC()
	end
	if EISlib.stage.canDialog() then
		task.Wait(120)
		dialog.player.playScene("Stage2_after", true)
	end
end
function s2_boss.LSC(diff)
	local boss
	diff = diff or difficulty
	if diff == 1 then
		boss = New(_editor_class["LSC2:Easy"], _editor_class["LSC2:Easy"].cards)
	elseif diff == 2 then
		boss = New(_editor_class["LSC2:Normal"], _editor_class["LSC2:Normal"].cards)
	elseif diff == 3 then
		boss = New(_editor_class["LSC2:Hard"], _editor_class["LSC2:Hard"].cards)
	elseif diff == 4 then
		boss = New(_editor_class["LSC2:Lunatic"], _editor_class["LSC2:Lunatic"].cards)
	end
	--关底boss等待
	while IsValid(boss) do
		task.Wait(1)
	end
end
