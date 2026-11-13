
--子弹定义
--region
--道中非
_editor_class["s3_mid_B1_1"] = Class(bullet)
_editor_class["s3_mid_B1_1"].init = function(self, _x, _y, v, a0, dt)
	bullet.init(self, ball_mid, COLOR_GRAY, true, true)
	self.x, self.y = _x, _y
	_object.set_color(self, "", 255, 255, 255, 255)
	lasttask = task.New(self, function()
		AddSimStrChV(self, v, 0, a0, 30)
		task._Wait(dt)
		ChangeBulletImage(self, square, COLOR_DEEP_RED)
		PlaySound("kira00", 0.1, 0, false)
		self.navi = true
		if (difficulty == 4) then
			AddSimStrChV(self, 2.75, 0, Angle(self, player), 15)
			task._Wait(40)
			ChangeBulletImage(self, ball_mid, COLOR_DEEP_RED)
			task._Wait(30)
			PlaySound("kira00", 0.1, 0, false)
			ChangeBulletImage(self, square, COLOR_GRAY)
			task._Wait(5)
			AddSimStrChV(self, 4, 3, Angle(self, player), 10)
		elseif (difficulty == 3) then
			AddSimStrChV(self, 2.5, 0, Angle(self, player), 20)
			task._Wait(40)
			ChangeBulletImage(self, ball_mid, COLOR_DEEP_RED)
			task._Wait(30)
			PlaySound("kira00", 0.1, 0, false)
			ChangeBulletImage(self, square, COLOR_GRAY)
			task._Wait(5)
			AddSimStrChV(self, 3.5, 2.5, Angle(self, player), 10)
		elseif (difficulty == 2) then
			AddSimStrChV(self, 2, 0, Angle(self, player), 40)
			task._Wait(40)
			ChangeBulletImage(self, ball_mid, COLOR_DEEP_RED)
			task._Wait(30)
			PlaySound("kira00", 0.1, 0, false)
			ChangeBulletImage(self, square, COLOR_GRAY)
			task._Wait(5)
			AddSimStrChV(self, 3, 2, Angle(self, player), 10)
		else
			AddSimStrChV(self, 2, 0, Angle(self, player), 20)
			task._Wait(40)
			ChangeBulletImage(self, ball_mid, COLOR_DEEP_RED)
			task._Wait(30)
			PlaySound("kira00", 0.1, 0, false)
			ChangeBulletImage(self, square, COLOR_GRAY)
			task._Wait(5)
			AddSimStrChV(self, 2, 1.5, Angle(self, player), 10)
		end
	end)
end
_editor_class["s3_mid_B1_2"] = Class(bullet)
_editor_class["s3_mid_B1_2"].init = function(self, _x, _y, v, a0, dt)
	bullet.init(self, ball_mid, COLOR_GRAY, true, true)
	self.x, self.y = _x, _y
	_object.set_color(self, "", 255, 255, 255, 255)
	lasttask = task.New(self, function()
		AddSimStrChV(self, v, 0, a0, 30)
		task._Wait(dt)
		ChangeBulletImage(self, arrow_big, COLOR_RED)
		PlaySound("kira00", 0.1, 0, false)
		self.navi = true
		if (difficulty == 4) then
			AddSimStrChV(self, 3.5, 0, a0, 90)
			task._Wait(60)
			ChangeBulletImage(self, arrow_big, COLOR_RED)
			task._Wait(50)
			PlaySound("kira00", 0.1, 0, false)
			ChangeBulletImage(self, square, COLOR_DEEP_PURPLE)
			AddSimStrChV(self, 3, 1, a0, 40)
		elseif (difficulty == 3) then
			AddSimStrChV(self, 3, 0, a0, 90)
			task._Wait(60)
			ChangeBulletImage(self, arrow_big, COLOR_RED)
			task._Wait(50)
			PlaySound("kira00", 0.1, 0, false)
			ChangeBulletImage(self, square, COLOR_DEEP_PURPLE)
			AddSimStrChV(self, 2.5, 1, a0, 40)
		elseif (difficulty == 2) then
			AddSimStrChV(self, 2.5, 0, a0, 90)
			task._Wait(60)
			ChangeBulletImage(self, arrow_big, COLOR_RED)
			task._Wait(50)
			PlaySound("kira00", 0.1, 0, false)
			ChangeBulletImage(self, square, COLOR_DEEP_PURPLE)
			AddSimStrChV(self, 2, 1, a0, 40)
		else
			AddSimStrChV(self, 2, 0, a0, 90)
			task._Wait(60)
			ChangeBulletImage(self, arrow_big, COLOR_RED)
			task._Wait(50)
			PlaySound("kira00", 0.1, 0, false)
			ChangeBulletImage(self, square, COLOR_DEEP_PURPLE)
			AddSimStrChV(self, 1.5, 1, a0, 40)
		end
	end)
end
--道中符
_editor_class["yukari_midSC_aura:Easy"] = Class(_object)
_editor_class["yukari_midSC_aura:Easy"].init = function(self, _x, _y, s, t, da, t2, dt, n, c, mst, _t, a0)
	self.x, self.y = _x, _y
	self.img = "magic3"
	self.layer = LAYER_ENEMY - 1
	self.group = GROUP_INDES
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
	--[[ 需要把img改成类似慧音道中符的魔法阵 --]]--[=[
	--]=]
	_object.set_color(self, "mul+add", 0, 255, 255, 255)
	self.omiga = da
	do
		local a, _d_a = (a0), (360 / n)
		for _ = 1, n do
			last = New(_editor_class["yukari_midSC_laser"], self.x, self.y, self, a, t, dt, t2, c, mst)
			a = a + _d_a
		end
	end
	lasttask = task.New(self, function()
		do
			local i, _d_i = (1 / t), (1 / t)
			for _ = 1, t do
				_object.set_color(self, "mul+add", 255 * i, 255, 255, 255)
				self.hscale = s * i
				self.vscale = self.hscale
				task._Wait(1)
				i = i + _d_i
			end
		end
	end)
	lasttask = task.New(self, function()
		task._Wait(30 + _t)
		local frame = 240
		do
			for _ = 1, _infinite do
				if (IsValid(mst)) then
					do
						local a, _d_a = (ran:Float(0, 360)), (6)
						for _ = 1, 60 do
							last = New(_editor_class["yukari_midSC2"], self.x, self.y, a, c, mst)
							a = a + _d_a
						end
					end
				else
					_del(self, true)
				end
				task._Wait(frame)
			end
		end
	end)
end
_editor_class["yukari_midSC_aura:Normal"] = Class(_object)
_editor_class["yukari_midSC_aura:Normal"].init = function(self, _x, _y, s, t, da, t2, dt, n, c, mst, _t, a0)
	self.x, self.y = _x, _y
	self.img = "magic3"
	self.layer = LAYER_ENEMY - 1
	self.group = GROUP_INDES
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
	--[[ 需要把img改成类似慧音道中符的魔法阵 --]]--[=[
	--]=]
	_object.set_color(self, "mul+add", 0, 255, 255, 255)
	self.omiga = da
	do
		local a, _d_a = (a0), (360 / n)
		for _ = 1, n do
			last = New(_editor_class["yukari_midSC_laser"], self.x, self.y, self, a, t, dt, t2, c, mst)
			a = a + _d_a
		end
	end
	lasttask = task.New(self, function()
		do
			local i, _d_i = (1 / t), (1 / t)
			for _ = 1, t do
				_object.set_color(self, "mul+add", 255 * i, 255, 255, 255)
				self.hscale = s * i
				self.vscale = self.hscale
				task._Wait(1)
				i = i + _d_i
			end
		end
	end)
	lasttask = task.New(self, function()
		task._Wait(30 + _t)
		local frame = 150
		do
			for _ = 1, _infinite do
				if (IsValid(mst)) then
					do
						local a, _d_a = (ran:Float(0, 360)), (3)
						for _ = 1, 120 do
							last = New(_editor_class["yukari_midSC2"], self.x, self.y, a, c, mst)
							a = a + _d_a
						end
					end
				else
					_del(self, true)
				end
				task._Wait(frame)
			end
		end
	end)
end
_editor_class["yukari_midSC_aura:Hard"] = Class(_object)
_editor_class["yukari_midSC_aura:Hard"].init = function(self, _x, _y, s, t, da, t2, dt, n, c, mst)
	self.x, self.y = _x, _y
	self.img = "magic3"
	self.layer = LAYER_ENEMY - 1
	self.group = GROUP_INDES
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
	--[[ 需要把img改成类似慧音道中符的魔法阵 --]]--[=[
	--]=]
	_object.set_color(self, "mul+add", 0, 255, 255, 255)
	self.omiga = da
	do
		local a, _d_a = (-90), (360 / n)
		for _ = 1, n do
			last = New(_editor_class["yukari_midSC_laser"], self.x, self.y, self, a, t, dt, t2, c, mst)
			a = a + _d_a
		end
	end
	lasttask = task.New(self, function()
		do
			local i, _d_i = (1 / t), (1 / t)
			for _ = 1, t do
				_object.set_color(self, "mul+add", 255 * i, 255, 255, 255)
				self.hscale = s * i
				self.vscale = self.hscale
				task._Wait(1)
				i = i + _d_i
			end
		end
	end)
	lasttask = task.New(self, function()
		task._Wait(30)
		local frame = 60
		lasttask = task.New(self, function()
			task._Wait(300)
			frame = 45
			task._Wait(300)
			frame = 30
		end)
		do
			for _ = 1, _infinite do
				if (IsValid(mst)) then
					do
						local a, _d_a = (ran:Float(0, 360)), (6)
						for _ = 1, 60 do
							egg.AddSimStrChV(New(_editor_class["yukari_midSC2"], self.x, self.y, a, c, mst), 0, 1.5, a, 60, 60)
							a = a + _d_a
						end
					end
				else
					_del(self, true)
				end
				task._Wait(frame)
			end
		end
	end)
end
_editor_class["yukari_midSC_aura:Lunatic"] = Class(_object)
_editor_class["yukari_midSC_aura:Lunatic"].init = function(self, _x, _y, s, t, u, t2, dt, n, c, mst)
	self.x, self.y = _x, _y
	self.img = "magic3"
	self.layer = LAYER_ENEMY - 1
	self.group = GROUP_INDES
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
	--[[ 需要把img改成类似慧音道中符的魔法阵 --]]--[=[
	--]=]
	_object.set_color(self, "mul+add", 0, 255, 255, 255)
	self.omiga = 0
	egg.AddSimStrChO(self, 0, 0.45 * u, 120)
	do
		local a, _d_a = (-90), (360 / n)
		for _ = 1, n do
			last = New(_editor_class["yukari_midSC_laser"], self.x, self.y, self, a, t, dt, t2, c, mst)
			a = a + _d_a
		end
	end
	lasttask = task.New(self, function()
		do
			local i, _d_i = (1 / t), (1 / t)
			for _ = 1, t do
				_object.set_color(self, "mul+add", 255 * i, 255, 255, 255)
				self.hscale = s * i
				self.vscale = self.hscale
				task._Wait(1)
				i = i + _d_i
			end
		end
	end)
	lasttask = task.New(self, function()
		task._Wait(30)
		local frame = 90
		lasttask = task.New(self, function()
			task._Wait(300)
			frame = 75
			task._Wait(300)
			frame = 60
		end)
		do
			for _ = 1, _infinite do
				if (IsValid(mst)) then
					do
						local a, _d_a = (ran:Float(0, 360)), (2)
						for _ = 1, 180 do
							last = New(_editor_class["yukari_midSC2"], self.x, self.y, a, c, mst)
							a = a + _d_a
						end
					end
				else
					_del(self, true)
				end
				task._Wait(frame)
			end
		end
	end)
end
--[[_editor_class["yukari_midSC_laser"] = Class(laser)
_editor_class["yukari_midSC_laser"].init = function(self, _x, _y, m, rot, t, dt, period, c, mst)
	laser.init(self, c, _x, _y, 0, 64, 512, 64, 10, 0, 0)
	self.m = m
	self.mst = mst
	local da = rot - m.rot
	self.rot = rot
	local l1, l2, l3 = self.l1, self.l2, self.l3
	self.l1 = 0
	self.l3 = 0
	self.l2 = 0
	self.timer = dt
	_object.set_color(self, "mul+add", 255, 255, 255, 255)
	self.colli = false
	lasttask = task.New(self, function()
		laser._TurnOn(self, 1, false, false)
		do
			local i, _d_i = (1 / t), (1 / t)
			for _ = 1, t do
				self.l1 = l1 * i
				self.l3 = l3 * i
				self.l2 = l2 * i
				task._Wait(1)
				i = i + _d_i
			end
		end
	end)
	lasttask = task.New(self, function()
		local a
		do
			for _ = 1, _infinite do
				if not IsValid(m) or not IsValid(mst) then
					break
				end
				self.rot = da + m.rot
				a = (Angle(self, player) - self.rot + 360) % 360
				if (abs(Dist(self, player) * sin(a)) <= 4) then
					self.mst.mode = c
				else
				end
				if (self.mst.mode == c) then
					self._a = max(self._a - 5, 100)
				else
					self._a = min(self._a + 5, 255)
				end
				task._Wait(1)
			end
		end
		laser._TurnOff(self, 30, true)
		_del(self, true)
	end)
end]]
_editor_class["yukari_midSC_laser"] = Class(bullet)
_editor_class["yukari_midSC_laser"].init = function(self, x, y, m, rot, t, dt, period, c, mst)
	bullet.init(self, ball_light, c, true, true)
	self.x, self.y = x, y
	self.m = m
	self.mst = mst
	local da = rot - m.rot
	self.rot = rot
	self.colli = false
	self.group = GROUP_GHOST
	self.timer = dt
	self.hscale, self.vscale = 0, 0.3
	if c == 2 then
		_object.set_color(self, "mul+add", 255, 255, 50, 50)
	else
		_object.set_color(self, "mul+add", 255, 50, 50, 255)
	end

	self.colli = false
	task.New(self, function()
		do
			local dl = (30 / t)
			for _ = 1, t do
				self.hscale = self.hscale + dl
				task._Wait(1)
			end
		end
	end)
	lasttask = task.New(self, function()
		local a
		do
			for _ = 1, _infinite do
				if not IsValid(m) or not IsValid(mst) then
					break
				else
					self.rot = da + m.rot
					a = (Angle(self, player) - self.rot + 360) % 360
					if (abs(Dist(self, player) * sin(a)) <= 5) then
						self.mst.mode = c
					else
					end
					if (self.mst.mode == c) then
						self._a = max(self._a - 5, 20)
					else
						self._a = min(self._a + 5, 255)
					end
				end
				task._Wait(1)
			end
		end
		_del(self, true)
	end)
end
_editor_class["yukari_midSC2"] = Class(bullet)
_editor_class["yukari_midSC2"].init = function(self, _x, _y, a, c, mst)
	bullet.init(self, ball_mid, c, true, true)
	self.x, self.y = _x, _y
	self.rot = a
	if c == 2 then
		_object.set_color(self, "mul+add", 200, 255, 100, 100)
	else
		_object.set_color(self, "mul+add", 200, 100, 100, 255)
	end
	lasttask = task.New(self, function()
		if (difficulty == 4) then
			AddSimStrChV(self, 4, 1, a, 60)
			AddSimStrChV(self, 0, 0.5, a, 180, nil, nil, 180)
		elseif (difficulty == 3) then
			AddSimStrChV(self, 4, 0.5, a, 90)
			AddSimStrChV(self, 0, 0.5, a, 180, nil, nil, 180)
		elseif (difficulty == 2) then
			AddSimStrChV(self, 4, 0.5, a, 90)
			AddSimStrChV(self, 0, 0.5, a, 180, nil, nil, 180)
		else
			AddSimStrChV(self, 4, 0.5, a, 90)
			AddSimStrChV(self, 0, 0.25, a, 180, nil, nil, 180)
		end
		do
			for _ = 1, _infinite do
				if (IsValid(mst)) then
					if (mst.mode == c) then
						self._a = max(self._a - 10, 20)
					else
						self._a = min(self._a + 10, 200)
					end
					if self._a >= 200 then
						self.colli = true
					else
						self.colli = false
					end
				else
					_del(self, false)
				end
				task._Wait(1)
			end
		end
	end)
end
_editor_class["yukari_midSC"] = Class(bullet)
_editor_class["yukari_midSC"].init = function(self, _x, _y, s, c, a, v1, v2)
	bullet.init(self, s, c, true, true)
	self.x, self.y = _x, _y
	SetV2(self, v1, a, true, false)
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("_speed", v2, 10, MOVE_NORMAL, nil, 10, MODE_SET)
		end)
	end)
end

--随机移动
local function move_rd(t, y0, dy, self)
	y0 = y0 or 144
	dy = dy or 25
	if self then
		task.New(self, function()
			task.MoveToPlayer(t or 60, -40, 40, y0 - dy, y0 + dy, 10, 20, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
		end)
	else
		task.MoveToPlayer(t or 60, -40, 40, y0 - dy, y0 + dy, 10, 20, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
	end
end

--激光特效
local lasereff = Class(object)
function lasereff:init(x, y, a, r, g, b, w)
	r, g, b = r or 177, g or 255, b or 97
	w = w or 1
	self.bound = false
	self.x, self.y = x + 300*cos(a), y + 300*sin(a)
	self.rot = a
	self.layer = LAYER_ENEMY_BULLET-1
	self.hscale, self.vscale = 75, 0
	self.img = "white"
	_object.set_color(self, "mul+add", 100, r, g, b)
	task.New(self, function()
		local ds, d_a = 1/50*w, -100/30
		for _ = 1, 20 do
			self.vscale = self.vscale + 2*ds
			task.Wait(1)
		end
		for _ = 1, 30 do
			self.vscale = self.vscale + ds
			self._a = self._a + d_a
			task.Wait(1)
		end
		Del(self)
	end)
end
function lasereff:frame()
	task.Do(self)
end
function lasereff:render()
	local rate, v = 1, 1
	for _ = 1, 3 do
		SetImgState(self, self._blend, self._a*rate, self._r*rate, self._g*rate, self._b*rate)
		Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale*v)
		rate = rate - 0.2
		v = v + 0.3
	end
end
--endregion

--灵梦的蓄力特效
local function eff1(x, y, t)
	New(AbEff, x, y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
	if t then
		task.Wait(t)
	end
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
--紫的蓄力特效
local function eff2(x, y, t)
	New(AbEff, x, y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
	if t then
		task.Wait(t)
	end
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

--normal
local function normal1_init_E(self)
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
			task._Wait(60)
		end
		local dx, dy
		local u = 1
		do
			for _ = 1, _infinite do
				self._wisys:setAction("cast", 64)
				task._Wait(30)
				do
					local a, _d_a = (-100 * u + Angle(self, player)), (50 * u)
					local dt, _d_dt = (80), (-8)
					for _ = 1, 4 do
						PlaySound("tan00", 0.1, 0, false)
						do
							local _sp, _d__sp = (0), (15)
							for _ = 1, 3 do
								dx, dy = 30 * cos(a), 30 * sin(a)
								do
									local dv, _d_dv = (2), (1.8)
									local n, _d_n = (1), (1)
									for _ = 1, 3 do
										if (n <= 2) then
											last = New(_editor_class["s3_mid_B1_2"], self.x + dx, self.y + dy, dv, a + _sp, dt)
										else
											last = New(_editor_class["s3_mid_B1_1"], self.x + dx, self.y + dy, dv, a + _sp, dt)
										end
										dv = dv + _d_dv
										n = n + _d_n
									end
								end
								_sp = _sp + _d__sp
							end
						end
						task._Wait(20)
						a = a + _d_a
						dt = dt + _d_dt
					end
				end
				task.Wait(60)
				local a = Angle(self, player)
				PlaySound("kira00")
				for i = 0, 11 do
					for j = 0, 0 do
						stg.newBulletStraight(stg.ball_big, 2, true, self.x, self.y, 1.5 + 0.45*j, a + 30*(i) + 15*j)
					end
				end
				task.MoveToPlayer(30, -96, 96, 115, 135, 16, 32, 8, 16, MOVE_NORMAL, MOVE_X_TOWARDS_PLAYER)
				u = -u
				task._Wait(30)
			end
		end
	end)
end
local function normal1_init_N(self)
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
			task._Wait(60)
		end
		local dx, dy
		local u = 1
		do
			for _ = 1, _infinite do
				self._wisys:setAction("cast", 64)
				task._Wait(30)
				do
					local a, _d_a = (-100 * u + Angle(self, player)), (50 * u)
					local dt, _d_dt = (70), (-3)
					for _ = 1, 5 do
						PlaySound("tan00", 0.1, 0, false)
						do
							local _sp, _d__sp = (0), (12)
							for _ = 1, 4 do
								dx, dy = 30 * cos(a), 30 * sin(a)
								do
									local dv, _d_dv = (2), (1.8)
									local n, _d_n = (1), (1)
									for _ = 1, 5 do
										if (n <= 3) then
											last = New(_editor_class["s3_mid_B1_2"], self.x + dx, self.y + dy, dv, a + _sp, dt)
										else
											last = New(_editor_class["s3_mid_B1_1"], self.x + dx, self.y + dy, dv, a + _sp, dt)
										end
										dv = dv + _d_dv
										n = n + _d_n
									end
								end
								_sp = _sp + _d__sp
							end
						end
						task._Wait(15)
						a = a + _d_a
						dt = dt + _d_dt
					end
				end
				task.Wait(60)
				local a = Angle(self, player)
				PlaySound("kira00")
				for i = 0, 11 do
					for j = 0, 1 do
						stg.newBulletStraight(stg.ball_big, 2, true, self.x, self.y, 1.65 + 0.45*j, a + 30*(i) + 15*j)
					end
				end
				task.MoveToPlayer(30, -96, 96, 115, 135, 16, 32, 8, 16, MOVE_NORMAL, MOVE_X_TOWARDS_PLAYER)
				u = -u
				task._Wait(30)
			end
		end
	end)
end
local function normal1_init_H(self)
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
			task._Wait(60)
		end
		local dx, dy
		local u = 1
		do
			for _ = 1, _infinite do
				self._wisys:setAction("cast", 64)
				task._Wait(30)
				do
					local a, _d_a = (-100 * u + Angle(self, player)), (40 * u)
					local dt, _d_dt = (60), (0)
					for _ = 1, 6 do
						PlaySound("tan00", 0.1, 0, false)
						do
							local _sp, _d__sp = (0), (10)
							for _ = 1, 5 do
								dx, dy = 30 * cos(a), 30 * sin(a)
								do
									local dv, _d_dv = (2), (1.8)
									local n, _d_n = (1), (1)
									for _ = 1, 7 do
										if (n <= 5) then
											last = New(_editor_class["s3_mid_B1_2"], self.x + dx, self.y + dy, dv, a + _sp, dt)
										else
											last = New(_editor_class["s3_mid_B1_1"], self.x + dx, self.y + dy, dv, a + _sp, dt)
										end
										dv = dv + _d_dv
										n = n + _d_n
									end
								end
								_sp = _sp + _d__sp
							end
						end
						task._Wait(12)
						a = a + _d_a
						dt = dt + _d_dt
					end
				end
				task.Wait(60)
				local a = Angle(self, player)
				PlaySound("kira00")
				for i = 0, 23 do
					for j = 0, 3 do
						stg.newBulletStraight(stg.ball_big, 2, true, self.x, self.y, 1.65 + 0.45*j, a + 15*(i))
					end
				end
				task.MoveToPlayer(30, -96, 96, 115, 135, 16, 32, 8, 16, MOVE_NORMAL, MOVE_X_TOWARDS_PLAYER)
				u = -u
				task._Wait(30)
			end
		end
	end)
end
local function normal1_init_L(self)
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
			task._Wait(60)
		end
		local dx, dy
		local u = 1
		do
			for _ = 1, _infinite do
				self._wisys:setAction("cast", 64)
				task.Wait(30)
				do
					local a, _d_a = (-110 * u + Angle(self, player)), (220/6 * u)
					local dt, _d_dt = (60), (2)
					for _ = 1, 7 do
						PlaySound("tan00", 0.1, 0, false)
						for j = -5, 5, 2 do
							dx, dy = 30 * cos(a), 30 * sin(a)
							for i = 0, 8 do
								if (i <= 5) then
									New(_editor_class["s3_mid_B1_2"], self.x + dx, self.y + dy, 1.5 + 1.5*i, a + 4.5*j, dt)
								else
									New(_editor_class["s3_mid_B1_1"], self.x + dx, self.y + dy, 1.5 + 1.5*i, a + 4.5*j, dt)
								end
							end
						end
						task._Wait(10)
						a = a + _d_a
						dt = dt + _d_dt
					end
				end
				task.Wait(60)
				local a = Angle(self, player)
				PlaySound("kira00")
				for i = 0, 29 do
					for j = 0, 4 do
						stg.newBulletStraight(stg.ball_big, 2, true, self.x, self.y, 1.25 + 0.45*j, a + 12*(i))
					end
				end
				task.MoveToPlayer(30, -96, 96, 115, 135, 16, 32, 8, 16, MOVE_NORMAL, MOVE_X_TOWARDS_PLAYER)
				u = -u
				task.Wait(30)
			end
		end
	end)
end
local function normal1_del(self)
	if self.timeout == 1 then
		self.noExtendBonus = true
	end
end

--card
local function card1_init_E(self)
	--New(egg.updateFileObject, "EISlib/stage/stage3/bossB/bossB_mid.lua")
	self.release = false
	local f1, f1_1, f2
	do
		--生成一条锁链
		function f1(x, y, a, co)
			New(lasereff, x, y, a, 255, 0, 0, 1)
			task.New(self, function()
				for t = 30, 1, -1 do
					f1_1(x, y, 6, a, 5*t, co)
					PlaySound("kira00")
					task.Wait(5)
				end
			end)
		end
		--锁链连弹
		function f1_1(x, y, v, a, t, co)
			local obj = stg.newBulletStraight(stg.arrow_small, co, true, x, y, 0, a)
			egg.AddAccDecChV(obj, v, a, 1, t, 10)
			obj.bound = false
			task.New(obj, function()
				while not self.release do
					task.Wait(1)
				end
				obj.bound = true
				obj.navi = true
				egg.AddSimStrChV(obj, 0, 1.5, a, 120)
			end)
		end
	end

	task.New(self, function ()
		s3B_boss.pic_show2()
		task._Wait(120)
		do
			task.Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
			self._wisys:setAction("cast", 88)
			task.Wait(60)
		end

		local u0, a = 1
		while true do
			self.release = false
			for i = 0, 3 do
				for u = -1, 1, 2 do
					f1(-224*u, (200 + 175*i)*u, -30 + 90*(u-1), 4 + u0)
				end
				task.Wait(10)
			end
			move_rd(30, nil, nil, self)
			task.Wait(60)
			for i = 0, 3 do
				for u = -1, 1, 2 do
					f1(-224*u, -(200 + 175*i)*u, 30 + 90*(u-1), 4 + u0)
				end
				task.Wait(10)
			end
			move_rd(30, nil, nil, self)
			task.Wait(60)
			--自机狙
			task.New(self, function()
				for _ = 1, 3 do
					move_rd(20, nil, nil, self)
					a = Angle(self, player)
					for k = 0, 3 do
						for j = 0, 0 do
							for u = -1, 1, 2 do
								for i = 1, 4 do
									stg.newBulletStraight(stg.arrow_small, 4 - u0, true, self.x, self.y, 1 + (0.1 + 0.1*j)*k + 1*j, a + (40*i + 1*k)*u)
								end
							end
							stg.newBulletStraight(stg.arrow_small, 4 - u0, true, self.x, self.y, 1 + (0.1 + 0.1*j)*k + 1*j, a)
						end
						PlaySound("tan00")
						task.Wait(5)
					end
				end
				task.Wait(60)
				a = Angle(self, player)
				for i = 1, 10 do
					for j = 0, 0 do
						stg.newBulletStraight(stg.ball_big, 2, true, self.x, self.y, 1 + 0.3*j, a + 36*i + 11.25*j)
					end
				end
				PlaySound("kira00")
			end)
			for i = 0, 3 do
				for u = -1, 1, 2 do
					f1((175*i)*u, 245, -90, 4 + u0)
				end
				task.Wait(10)
			end
			for _ = 1, 2 do
				move_rd(30)
				task.Wait(60)
			end
			self.release = true
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
			task.Wait(60)
			u0 = -u0
		end
	end)
end
local function card1_init_N(self)
	--New(egg.updateFileObject, "EISlib/stage/stage3/bossB/bossB_mid.lua")
	self.release = false
	local f1, f1_1, f2
	do
		--生成一条锁链
		function f1(x, y, a, co)
			New(lasereff, x, y, a, 255, 0, 0, 1)
			task.New(self, function()
				for t = 30, 1, -1 do
					f1_1(x, y, 6, a, 5*t, co)
					PlaySound("kira00")
					task.Wait(5)
				end
			end)
		end
		--锁链连弹
		function f1_1(x, y, v, a, t, co)
			local obj = stg.newBulletStraight(stg.arrow_small, co, true, x, y, 0, a)
			egg.AddAccDecChV(obj, v, a, 1, t, 10)
			obj.bound = false
			task.New(obj, function()
				while not self.release do
					task.Wait(1)
				end
				obj.bound = true
				obj.navi = true
				egg.AddSimStrChV(obj, 0, 1.5, a, 120)
			end)
		end
	end

	task.New(self, function ()
		s3B_boss.pic_show2()
		task._Wait(120)
		do
			task.Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
			self._wisys:setAction("cast", 88)
			task.Wait(60)
		end

		local u0, a = 1
		while true do
			self.release = false
			for i = 0, 3 do
				for u = -1, 1, 2 do
					f1(-224*u, (180 + 100*i)*u, -30 + 90*(u-1), 4 + u0)
				end
				task.Wait(10)
			end
			move_rd(30, nil, nil, self)
			task.Wait(60)
			for i = 0, 3 do
				for u = -1, 1, 2 do
					f1(-224*u, -(180 + 100*i)*u, 30 + 90*(u-1), 4 + u0)
				end
				task.Wait(10)
			end
			move_rd(30, nil, nil, self)
			task.Wait(60)
			--自机狙
			task.New(self, function()
				for _ = 1, 3 do
					move_rd(20, nil, nil, self)
					a = Angle(self, player)
					for k = 0, 6 do
						for j = 0, 0 do
							for u = -1, 1, 2 do
								for i = 1, 7 do
									stg.newBulletStraight(stg.arrow_small, 4 - u0, true, self.x, self.y, 1 + (0.1 + 0.1*j)*k + 1*j, a + (20*i + 1*k)*u)
								end
							end
							stg.newBulletStraight(stg.arrow_small, 4 - u0, true, self.x, self.y, 1 + (0.1 + 0.1*j)*k + 1*j, a)
						end
						PlaySound("tan00")
						task.Wait(3)
					end
				end
				task.Wait(60)
				a = Angle(self, player)
				for i = 1, 16 do
					for j = 0, 1 do
						stg.newBulletStraight(stg.ball_big, 2, true, self.x, self.y, 1 + 0.3*j, a + 22.5*i + 11.25*j)
					end
				end
				PlaySound("kira00")
			end)
			for i = 0, 3 do
				for u = -1, 1, 2 do
					f1((100*i)*u, 245, -90, 4 + u0)
				end
				task.Wait(10)
			end
			for _ = 1, 2 do
				move_rd(30)
				task.Wait(60)
			end
			self.release = true
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
			task.Wait(60)
			u0 = -u0
		end
	end)
end
local function card1_init_H(self)
	--New(egg.updateFileObject, "EISlib/stage/stage3/bossB/bossB_mid.lua")
	self.release = false
	local f1, f1_1, f2
	do
		--生成一条锁链
		function f1(x, y, a, co)
			New(lasereff, x, y, a, 255, 0, 0, 1)
			task.New(self, function()
				for t = 30, 1, -1 do
					f1_1(x, y, 6, a, 5*t, co)
					PlaySound("kira00")
					task.Wait(5)
				end
			end)
		end
		--锁链连弹
		function f1_1(x, y, v, a, t, co)
			local obj = stg.newBulletStraight(stg.arrow_small, co, true, x, y, 0, a)
			egg.AddAccDecChV(obj, v, a, 1, t, 10)
			obj.bound = false
			task.New(obj, function()
				while not self.release do
					task.Wait(1)
				end
				obj.bound = true
				obj.navi = true
				egg.AddSimStrChV(obj, 0, 1.5 + ran:Float(-0.1, 0.1), a + ran:Float(-5, 5), 120)
			end)
		end
	end

	task.New(self, function ()
		s3B_boss.pic_show2()
		task._Wait(120)
		do
			task.Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
			self._wisys:setAction("cast", 88)
			task.Wait(60)
		end

		local u0, a = 1
		while true do
			self.release = false
			for i = 0, 3 do
				for u = -1, 1, 2 do
					f1(-224*u, (170 + 80*i)*u, -30 + 90*(u-1), 4 + u0)
				end
				task.Wait(10)
			end
			move_rd(30, nil, nil, self)
			task.Wait(60)
			for i = 0, 3 do
				for u = -1, 1, 2 do
					f1(-224*u, -(170 + 80*i)*u, 30 + 90*(u-1), 4 + u0)
				end
				task.Wait(10)
			end
			move_rd(30, nil, nil, self)
			task.Wait(60)
			--自机狙
			task.New(self, function()
				for _ = 1, 3 do
					move_rd(20, nil, nil, self)
					a = Angle(self, player)
					for k = 0, 9 do
						for j = 0, 0 do
							for u = -1, 1, 2 do
								for i = 1, 9 do
									stg.newBulletStraight(stg.arrow_small, 4 - u0, true, self.x, self.y, 1 + (0.1 + 0.1*j)*k + 1*j, a + (15*i + 1*k)*u)
								end
							end
							stg.newBulletStraight(stg.arrow_small, 4 - u0, true, self.x, self.y, 1 + (0.1 + 0.1*j)*k + 1*j, a)
						end
						PlaySound("tan00")
						task.Wait(2)
					end
				end
				task.Wait(60)
				a = Angle(self, player)
				for i = 1, 20 do
					for j = 0, 2 do
						stg.newBulletStraight(stg.ball_big, 2, true, self.x, self.y, 1 + 0.3*j, a + 18*i + 6*j)
					end
				end
				PlaySound("kira00")
			end)
			for i = 0, 3 do
				for u = -1, 1, 2 do
					f1((80*i)*u, 245, -90, 4 + u0)
				end
				task.Wait(10)
			end
			for _ = 1, 2 do
				move_rd(30)
				task.Wait(60)
			end
			self.release = true
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
			task.Wait(60)
			u0 = -u0
		end
	end)
end
--[[local function card1_init_H(self)
	lasttask = task.New(self, function()
		do
			s3B_boss.pic_show2()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
				task._Wait(60)
			end
			self._wisys:setAction("cast", 88)
		end
		task._Wait(30)
		last = New(_editor_class["yukari_midSC_aura:Hard"], -90, 100, 1, 90, 0.1, 300, 225, 8, 6, self)
		last.rot = last.rot + 22.5
		last = New(_editor_class["yukari_midSC_aura:Hard"], 90, 100, 1, 90, -0.1, 300, 75, 8, 2, self)
	end)
	lasttask = task.New(self, function()
		task._Wait(360)
		do
			for _ = 1, _infinite do
				task.MoveToPlayer(30, -64, 64, 96, 144, 16, 32, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
				task._Wait(150)
			end
		end
	end)
end]]
local function card1_init_L(self)
	--New(egg.updateFileObject, "EISlib/stage/stage3/bossB/bossB_mid.lua")
	self.release = false
	local f1, f1_1, f2
	do
		--生成一条锁链
		function f1(x, y, a, co)
			New(lasereff, x, y, a, 255, 0, 0, 1)
			task.New(self, function()
				for t = 30, 1, -1 do
					f1_1(x, y, 6, a, 5*t, co)
					PlaySound("kira00")
					task.Wait(5)
				end
			end)
		end
		--锁链连弹
		function f1_1(x, y, v, a, t, co)
			local obj = stg.newBulletStraight(stg.arrow_small, co, true, x, y, 0, a)
			egg.AddAccDecChV(obj, v, a, 1, t, 10)
			obj.bound = false
			task.New(obj, function()
				while not self.release do
					task.Wait(1)
				end
				obj.bound = true
				obj.navi = true
				egg.AddSimStrChV(obj, 0, 1.5 + ran:Float(-0.1, 0.1), a + ran:Float(-5, 5), 120)
			end)
		end
	end

	task.New(self, function ()
		s3B_boss.pic_show2()
		task._Wait(120)
		do
			task.Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
			self._wisys:setAction("cast", 88)
			task.Wait(60)
		end

		local u0, a = 1
		while true do
			self.release = false
			for i = 0, 3 do
				for u = -1, 1, 2 do
					f1(-224*u, (160 + 70*i)*u, -30 + 90*(u-1), 4 + u0)
				end
				task.Wait(10)
			end
			move_rd(30, nil, nil, self)
			task.Wait(60)
			for i = 0, 3 do
				for u = -1, 1, 2 do
					f1(-224*u, -(160 + 70*i)*u, 30 + 90*(u-1), 4 + u0)
				end
				task.Wait(10)
			end
			move_rd(30, nil, nil, self)
			task.Wait(60)
			--自机狙
			task.New(self, function()
				for _ = 1, 3 do
					move_rd(20, nil, nil, self)
					a = Angle(self, player)
					for k = 0, 9 do
						for j = 0, 1 do
							for u = -1, 1, 2 do
								for i = 1, 9 do
									stg.newBulletStraight(stg.arrow_small, 4 - u0, true, self.x, self.y, 1 + (0.1 + 0.1*j)*k + 1*j, a + (15*i + 1*k)*u)
								end
							end
							stg.newBulletStraight(stg.arrow_small, 4 - u0, true, self.x, self.y, 1 + (0.1 + 0.1*j)*k + 1*j, a)
						end
						PlaySound("tan00")
						task.Wait(2)
					end
				end
				task.Wait(60)
				a = Angle(self, player)
				for i = 1, 24 do
					for j = 0, 3 do
						stg.newBulletStraight(stg.ball_big, 2, true, self.x, self.y, 1 + 0.3*j, a + 15*i + 5*j)
					end
				end
				PlaySound("kira00")
			end)
			for i = 0, 3 do
				for u = -1, 1, 2 do
					f1((65*i)*u, 245, -90, 4 + u0)
				end
				task.Wait(10)
			end
			for _ = 1, 2 do
				move_rd(30)
				task.Wait(60)
			end
			self.release = true
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
			task.Wait(60)
			u0 = -u0
		end
	end)
	--[[lasttask = task.New(self, function()
		do
			s3B_boss.pic_show2()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
				task._Wait(60)
			end
			self._wisys:setAction("cast", 88)
		end
		task._Wait(30)
		last = New(_editor_class["yukari_midSC_aura:Lunatic"], -120, 50, 1, 90, 1, 300, 225, 10, 6, self)
		last = New(_editor_class["yukari_midSC_aura:Lunatic"], 120, 50, 1, 90, -1, 300, 75, 10, 2, self)
	end)
	lasttask = task.New(self, function()
		task._Wait(360)
		do
			for _ = 1, _infinite do
				task.MoveToPlayer(30, -64, 64, 96, 144, 16, 32, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
				task._Wait(150)
			end
		end
	end)]]
end
local function card1_del_HL(self)
	if self.timeout == 1 then
		self.noExtendBonus = true
	else
		Spell_break_eff(self.x, self.y, 255, 0, 255,
				'yukari_star', 'reimu_leaf')
	end
end

local function create_boss1(group_name, class_name)
	return EISlib.stage.createBossClass(group_name, class_name, "Reimu", spellcard_background,
			{ "s3", stage3_background }, -256, 300,
			function(self)
				lstg.wis.Reimu(self)
			end)
end
local function create_boss2(group_name, class_name)
	return EISlib.stage.createBossClass(group_name, class_name, "Yukari", s3B_boss.scbg,
			{ "s3", stage3_background }, 256, 300,
			function(self)
				lstg.wis.Yukari(self)
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

--common action
local function boss_common1(boss_class)
	create_dialog(boss_class, function(self)
		if ext.sc_pr then
			boss_scpr_show1(self, 0, 120)
		else
			task.Wait(30)
			task.MoveTo(0, 120, 60, MOVE_ACC_DEC)
			boss.show_aura(self, true)
		end
	end)
end
local function boss_common2(boss_class)
	create_dialog(boss_class, function(self)
		self.colli = false
		player.dialog = false
		if not self.noExtendBonus then
			PlaySound("enep01", 0.5, 0, false)
			misc.ShakeScreen(30, 3)
			_drop_item(item_bomb, 1, self.x, self.y)
		end
		task._Wait(120)
		task.MoveTo(256, 300, 60, MOVE_ACCEL)
		_del(self, true)
	end)
	-- 加一个非符防止boss被鲨
	EISlib.stage.createCardClass(boss_class, "",
			{ 60, 60, 60 }, 600, { 0, 0, 0 }, "normal", false, true)
end
local function boss_common3(boss_class)
	create_dialog(boss_class, function(self)
		if ext.sc_pr then
			boss_scpr_show2(self, 0, 128)
		else
			task.Wait(30)
			task.MoveTo(0, 128, 60, MOVE_ACC_DEC)
			boss.show_aura(self, true)
		end
	end)
end
local function boss_common4(boss_class)
	create_dialog(boss_class, function(self)
		self._wisys:setAction("normal", 9999)
		player.dialog = false
		self.colli = false
		if not self.noExtendBonus then
			PlaySound("enep01", 0.5, 0, false)
			misc.ShakeScreen(30, 3)
			_drop_item(item_extend, 1, self.x, self.y)
		end
		task._Wait(120)
		task.MoveTo(-256, 300, 90, MOVE_ACCEL)
		_del(self, true)
	end)
	-- 加一个非符防止boss被鲨
	EISlib.stage.createCardClass(boss_class, "",
			{ 60, 60, 60 }, 600, { 0, 0, 0 }, "normal", false, true)
end

--boss
local boss1_E = create_boss1("Easy", "stage3Bmid_boss1:Easy")
local boss1_N = create_boss1("Normal", "stage3Bmid_boss1:Normal")
local boss1_H = create_boss1("Hard", "stage3Bmid_boss1:Hard")
local boss1_L = create_boss1("Lunatic", "stage3Bmid_boss1:Lunatic")
local boss2_E = create_boss2("Easy", "stage3Bmid_boss2:Easy")
local boss2_N = create_boss2("Normal", "stage3Bmid_boss2:Normal")
local boss2_H = create_boss2("Hard", "stage3Bmid_boss2:Hard")
local boss2_L = create_boss2("Lunatic", "stage3Bmid_boss2:Lunatic")

--before
boss_common1(boss1_E)
boss_common1(boss1_N)
boss_common1(boss1_H)
boss_common1(boss1_L)
boss_common3(boss2_E)
boss_common3(boss2_N)
boss_common3(boss2_H)
boss_common3(boss2_L)

--attack
create_card(boss1_E, "通常攻击",
		{ 2, 5, 20 }, 600, { 0, 0, 0 }, "normal", true, normal1_init_E, normal1_del)
create_card(boss1_N, "通常攻击",
		{ 2, 5, 20 }, 600, { 0, 0, 0 }, "normal", true, normal1_init_N, normal1_del)
create_card(boss1_H, "通常攻击",
		{ 2, 5, 20 }, 600, { 0, 0, 0 }, "normal", true, normal1_init_H, normal1_del)
create_card(boss1_L, "通常攻击",
		{ 2, 5, 20 }, 600, { 0, 0, 0 }, "normal", true, normal1_init_L, normal1_del)

create_card(boss2_E, "诱符「络新妇之巢」",
		{ 3, 12, 25 }, 1500, {10, 20, 30}, "spellcard", true, card1_init_E, card1_del_HL)
create_card(boss2_N, "诱符「络新妇之巢」",
		{ 3, 12, 25 }, 1500, {10, 20, 30}, "spellcard", true, card1_init_N, card1_del_HL)
create_card(boss2_H, "诱符「络新妇之巢」",
		{ 3, 12, 25 }, 1500, {10, 20, 30}, "spellcard", true, card1_init_H, card1_del_HL)
create_card(boss2_L, "诱符「络新妇之巢」",
		{ 3, 12, 25 }, 1500, {10, 20, 30}, "spellcard", true, card1_init_L, card1_del_HL)

--after
boss_common2(boss1_E)
boss_common2(boss1_N)
boss_common2(boss1_H)
boss_common2(boss1_L)
boss_common4(boss2_E)
boss_common4(boss2_N)
boss_common4(boss2_H)
boss_common4(boss2_L)

function s3B_boss.mid1(diff)
	local boss
	diff = diff or difficulty
	if diff == 1 then
		boss = New(boss1_E, boss1_E.cards)
	elseif diff == 2 then
		boss = New(boss1_N, boss1_N.cards)
	elseif diff == 3 then
		boss = New(boss1_H, boss1_H.cards)
	elseif diff == 4 then
		boss = New(boss1_L, boss1_L.cards)
	end
	return boss
end
function s3B_boss.mid2(diff)
	local boss
	diff = diff or difficulty
	if diff == 1 then
		boss = New(boss2_E, boss2_E.cards)
	elseif diff == 2 then
		boss = New(boss2_N, boss2_N.cards)
	elseif diff == 3 then
		boss = New(boss2_H, boss2_H.cards)
	elseif diff == 4 then
		boss = New(boss2_L, boss2_L.cards)
	end
	return boss
end
