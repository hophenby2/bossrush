s3A_boss = {}

local path = "EISlib/stage/stage3/bossA/"
Include(path .. "Mokou_boss.lua")
Include(path .. "Keine_boss.lua")
Include(path .. "bossA_mid.lua")
Include(path .. "bossA_main.lua")
Include(path .. "bossA_ls.lua")

--region 弹幕组件

_editor_class["s3_慧音一非小玉"] = Class(bullet)
_editor_class["s3_慧音一非小玉"].init = function(self, _x, _y, a, v, c)
	bullet.init(self, ball_mid, c, false, true)
	self.x, self.y = _x, _y
	local s = 1
	self.hscale = s * self.hscale
	self.vscale = s * self.vscale
	self.a = s * self.a
	self.b = s * self.b
	SetV2(self, v, a, true, false)
	lasttask = task.New(self, function()
		do
			local vv, _d_vv = (v), (-v * 0.25 / 9)
			for _ = 1, 10 do
				SetV2(self, vv, a, true, false)
				task._Wait(1)
				vv = vv + _d_vv
			end
		end
	end)
end
_editor_class["s3_慧音一非使魔:Easy"] = Class(_object)
_editor_class["s3_慧音一非使魔:Easy"].init = function(self, _x, _y, i, x, y, v, sty)
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
	self.omiga = 3 * i
	self.vscale = 0
	self.hscale = 0
	self.bound = false
	lasttask = task.New(self, function()
		do
			local al, _d_al = (0), (255 / 10)
			local s, _d_s = (0), (0.8 / 10)
			for _ = 1, 10 do
				_object.set_color(self, "mul+add", al, 0, 100, 255)
				self.vscale = s
				self.hscale = s
				task._Wait(1)
				al = al + _d_al
				s = s + _d_s
			end
		end
		task.MoveTo(x, y, 40, MOVE_DECEL)
		do
			local a, _d_a = (90), (0)
			for _ = 1, 5 do
				do
					local b, _d_b = (0), (180)
					for _ = 1, 2 do
						if (sty == 1) then
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v, COLOR_CYAN)
						else
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v, COLOR_BLUE)
						end
						task._Wait(0)
						b = b + _d_b
					end
				end
				task._Wait(24)
				a = a + _d_a
			end
		end
		do
			local a, _d_a = (90), (31.52 * i)
			for _ = 1, _infinite do
				do
					local b, _d_b = (0), (180)
					for _ = 1, 2 do
						if (sty == 1) then
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v, COLOR_CYAN)
						else
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v, COLOR_BLUE)
						end
						task._Wait(0)
						b = b + _d_b
					end
				end
				task._Wait(24)
				a = a + _d_a
			end
		end
	end)
end
_editor_class["s3_慧音一非使魔:Normal"] = Class(_object)
_editor_class["s3_慧音一非使魔:Normal"].init = function(self, _x, _y, i, x, y, v, sty)
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
	self.omiga = 3 * i
	self.vscale = 0
	self.hscale = 0
	self.bound = false
	lasttask = task.New(self, function()
		do
			local al, _d_al = (0), (255 / 10)
			local s, _d_s = (0), (0.8 / 10)
			for _ = 1, 10 do
				_object.set_color(self, "mul+add", al, 0, 100, 255)
				self.vscale = s
				self.hscale = s
				task._Wait(1)
				al = al + _d_al
				s = s + _d_s
			end
		end
		task.MoveTo(x, y, 40, MOVE_DECEL)
		do
			local a, _d_a = (90), (0)
			for _ = 1, 6 do
				do
					local b, _d_b = (0), (180)
					for _ = 1, 2 do
						if (sty == 1) then
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v, COLOR_CYAN)
						else
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v, COLOR_BLUE)
						end
						task._Wait(0)
						b = b + _d_b
					end
				end
				task._Wait(20)
				a = a + _d_a
			end
		end
		do
			local a, _d_a = (90), (24.5 * i)
			for _ = 1, _infinite do
				do
					local b, _d_b = (0), (180)
					for _ = 1, 2 do
						if (sty == 1) then
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v, COLOR_CYAN)
						else
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v, COLOR_BLUE)
						end
						task._Wait(0)
						b = b + _d_b
					end
				end
				task._Wait(20)
				a = a + _d_a
			end
		end
	end)
end
_editor_class["s3_慧音一非使魔:Hard"] = Class(_object)
_editor_class["s3_慧音一非使魔:Hard"].init = function(self, _x, _y, i, x, y, v, sty)
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
	self.omiga = 3 * i
	self.vscale = 0
	self.hscale = 0
	self.bound = false
	lasttask = task.New(self, function()
		do
			local al, _d_al = (0), (255 / 10)
			local s, _d_s = (0), (0.8 / 10)
			for _ = 1, 10 do
				_object.set_color(self, "mul+add", al, 0, 100, 255)
				self.vscale = s
				self.hscale = s
				task._Wait(1)
				al = al + _d_al
				s = s + _d_s
			end
		end
		task.MoveTo(x, y, 40, MOVE_DECEL)
		do
			local a, _d_a = (0), (0)
			for _ = 1, 8 do
				do
					local b, _d_b = (0), (90)
					for _ = 1, 4 do
						if (sty == 1) then
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v, COLOR_CYAN)
						else
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v, COLOR_BLUE)
						end
						task._Wait(0)
						b = b + _d_b
					end
				end
				task._Wait(15)
				a = a + _d_a
			end
		end
		do
			local a, _d_a = (0), (17.125 * i)
			for _ = 1, _infinite do
				do
					local b, _d_b = (0), (90)
					for _ = 1, 4 do
						if (sty == 1) then
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v, COLOR_CYAN)
						else
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v, COLOR_BLUE)
						end
						task._Wait(0)
						b = b + _d_b
					end
				end
				task._Wait(15)
				a = a + _d_a
			end
		end
	end)
end
_editor_class["s3_慧音一非使魔:Lunatic"] = Class(_object)
_editor_class["s3_慧音一非使魔:Lunatic"].init = function(self, _x, _y, i, x, y, v, sty)
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
	self.omiga = 3 * i
	self.vscale = 0
	self.hscale = 0
	self.bound = false
	lasttask = task.New(self, function()
		do
			local al, _d_al = (0), (255 / 10)
			local s, _d_s = (0), (0.8 / 10)
			for _ = 1, 10 do
				_object.set_color(self, "mul+add", al, 0, 100, 255)
				self.vscale = s
				self.hscale = s
				task._Wait(1)
				al = al + _d_al
				s = s + _d_s
			end
		end
		task.MoveTo(x, y, 40, MOVE_DECEL)
		do
			local a, _d_a = (0), (0)
			for _ = 1, 10 do
				do
					local b, _d_b = (0), (90)
					for _ = 1, 4 do
						if (sty == 1) then
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v, COLOR_CYAN)
						else
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v, COLOR_BLUE)
						end
						task._Wait(0)
						b = b + _d_b
					end
				end
				task._Wait(11)
				a = a + _d_a
			end
		end
		do
			local a, _d_a = (0), (12.7 * i)
			for _ = 1, _infinite do
				do
					local b, _d_b = (0), (90)
					for _ = 1, 4 do
						if (sty == 1) then
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v, COLOR_CYAN)
						else
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v, COLOR_BLUE)
						end
						task._Wait(0)
						b = b + _d_b
					end
				end
				task._Wait(11)
				a = a + _d_a
			end
		end
	end)
end

_editor_class["s3_慧音一符花心_EN"] = Class(bullet)
_editor_class["s3_慧音一符花心_EN"].init = function(self, _x, _y, x, y, sty, i, nandu)
	bullet.init(self, ball_mid, COLOR_BLUE, false, false)
	self.x, self.y = _x, _y
	local a = Angle(self, player)
	self.bound = false
	if (sty == 1) then
		lasttask = task.New(self, function()
			do
				local a0, _d_a0 = (a), (45)
				for _ = 1, 8 do
					last = New(_editor_class["s3_慧音一符花_EN"], self.x, self.y, a0, 1, COLOR_GREEN, 12)
					_connect(self, last, 0, false)
					task._Wait(0)
					a0 = a0 + _d_a0
				end
			end
		end)
		lasttask = task.New(self, function()
			do
				local a0, _d_a0 = (a), (24)
				for _ = 1, 15 do
					last = New(_editor_class["s3_慧音一符花_EN"], self.x, self.y, a0, -1, COLOR_CYAN, 20)
					_connect(self, last, 0, false)
					task._Wait(0)
					a0 = a0 + _d_a0
				end
			end
		end)
	else
		lasttask = task.New(self, function()
			do
				local a0, _d_a0 = (a), (45)
				for _ = 1, 8 do
					last = New(_editor_class["s3_慧音一符花_EN"], self.x, self.y, a0, 1, COLOR_PURPLE, 12)
					_connect(self, last, 0, false)
					task._Wait(0)
					a0 = a0 + _d_a0
				end
			end
		end)
		lasttask = task.New(self, function()
			do
				local a0, _d_a0 = (a), (24)
				for _ = 1, 15 do
					last = New(_editor_class["s3_慧音一符花_EN"], self.x, self.y, a0, -1, COLOR_RED, 20)
					_connect(self, last, 0, false)
					task._Wait(0)
					a0 = a0 + _d_a0
				end
			end
		end)
	end
	self.flag = 2
	lasttask = task.New(self, function()
		task.MoveTo(x, y, 60, MOVE_DECEL)
		task._Wait(20)
		lasttask = task.New(self, function()
			do
				local t, _d_t = (60), (-3)
				for _ = 1, 20 do
					if (sty == 1) then
						last = New(_editor_class["s3_慧音一符札弹_EN"], self.x, self.y, 270 + ran:Float(-1, 1), COLOR_CYAN, t)
					else
						last = New(_editor_class["s3_慧音一符札弹_EN"], self.x, self.y, 270 + ran:Float(-1, 1), COLOR_ORANGE, t)
					end
					task._Wait(3)
					t = t + _d_t
				end
			end
		end)
		task.MoveTo(x + 140 * i, y, 60, MOVE_DECEL)
		task._Wait(30)
		_del(self, true)
	end)
end
_editor_class["s3_慧音一符花_EN"] = Class(bullet)
_editor_class["s3_慧音一符花_EN"].init = function(self, _x, _y, a0, i, c, r)
	bullet.init(self, kite, c, false, false)
	self.x, self.y = _x, _y
	lasttask = task.New(self, function()
		do
			local a, _d_a = (a0), (1 * i)
			for _ = 1, 180 do
				_set_rel_pos(self, r * cos(a), r * sin(a), self.rot, false)
				self.rot = a
				task._Wait(1)
				a = a + _d_a
			end
		end
		_set_a(self, r * 1 / 300, self.rot, false)
		_forbid_v(self, r / 12, 'original', 'original')
	end)
end
_editor_class["s3_慧音一符札弹_EN"] = Class(bullet)
_editor_class["s3_慧音一符札弹_EN"].init = function(self, _x, _y, a, c, t)
	bullet.init(self, square, c, true, false)
	self.x, self.y = _x, _y
	SetV2(self, 0, a, true, false)
	lasttask = task.New(self, function()
		task._Wait(t)
		_del(self, true)
	end)
end
_editor_class["s3_妹红一符激光预警_EN"] = Class(laser)
_editor_class["s3_妹红一符激光预警_EN"].init = function(self, _x, _y, a)
	laser.init(self, COLOR_RED, _x, _y, 0, 0, 0, 0, 12, 8, 0)
	lasttask = task.New(self, function()
		self.bound = false
		laser.ChangeImage(self, 2)
		_object.set_color(self, "mul+add", 255, 255, 255, 255)
		laser._TurnHalfOn(self, 1, false)
		self.rot = a
		do
			local aerfa, _d_aerfa = (0), (90 / 29)
			for _ = 1, 30 do
				self.l2 = 1800 * sin(aerfa)
				task._Wait(1)
				aerfa = aerfa + _d_aerfa
			end
		end
		do
			local v, _d_v = (0.25), (0.5)
			for _ = 1, 5 do
				last = New(_editor_class["s3_妹红一符激光预警虚影_EN"], self.x, self.y, a, a + 90, v)
				last = New(_editor_class["s3_妹红一符激光预警虚影_EN"], self.x, self.y, a, a - 90, v)
				task._Wait(0)
				v = v + _d_v
			end
		end
		last = New(_editor_class["s3_妹红一符射线"], self.x, self.y, 16, a)
		task._Wait(40)
		laser._TurnOff(self, 20, true)
		task._Wait(50)
		_del(self, true)
	end)
end
_editor_class["s3_妹红一符激光预警_EN"].kill = function(self)
end
_editor_class["s3_妹红一符激光预警虚影_EN"] = Class(laser)
_editor_class["s3_妹红一符激光预警虚影_EN"].init = function(self, _x, _y, a, b, v)
	laser.init(self, COLOR_RED, _x, _y, 0, 0, 1800, 0, 8, 0, 0)
	self.bound = false
	laser.ChangeImage(self, 2)
	_object.set_color(self, "", 255, 255, 255, 255)
	SetV2(self, v, b, true, false)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				self.rot = a
				task._Wait(1)
			end
		end
	end)
	lasttask = task.New(self, function()
		laser._TurnHalfOn(self, 10, true)
		laser._TurnOff(self, 10, true)
		_del(self, false)
	end)
end
_editor_class["s3_妹红一符激光预警虚影_EN"].kill = function(self)
end
_editor_class["s3_妹红一符激光预警"] = Class(laser)
_editor_class["s3_妹红一符激光预警"].init = function(self, _x, _y, a)
	laser.init(self, COLOR_RED, _x, _y, 0, 0, 0, 0, 12, 8, 0)
	lasttask = task.New(self, function()
		self.bound = false
		laser.ChangeImage(self, 2)
		_object.set_color(self, "mul+add", 255, 255, 255, 255)
		laser._TurnHalfOn(self, 1, false)
		self.rot = a
		do
			local aerfa, _d_aerfa = (0), (90 / 29)
			for _ = 1, 30 do
				self.l2 = 900 * sin(aerfa)
				task._Wait(1)
				aerfa = aerfa + _d_aerfa
			end
		end
		--[[do
			local v, _d_v = (0.25), (0.5)
			for _ = 1, 5 do
				last = New(_editor_class["s3_妹红一符激光预警虚影"], self.x, self.y, a, a + 90, v)
				last = New(_editor_class["s3_妹红一符激光预警虚影"], self.x, self.y, a, a - 90, v)
				task._Wait(0)
				v = v + _d_v
			end
		end]]
		last = New(_editor_class["s3_妹红一符射线"], self.x, self.y, 12, a)
		task._Wait(60)
		laser._TurnOff(self, 20, true)
		task._Wait(50)
		_del(self, true)
	end)
end
_editor_class["s3_妹红一符激光预警"].kill = function(self)
end
_editor_class["s3_妹红一符激光预警虚影"] = Class(laser)
_editor_class["s3_妹红一符激光预警虚影"].init = function(self, _x, _y, a, b, v)
	laser.init(self, COLOR_RED, _x, _y, 0, 0, 900, 0, 8, 0, 0)
	self.bound = false
	laser.ChangeImage(self, 2)
	_object.set_color(self, "", 150, 255, 0, 0)
	SetV2(self, v, b, true, false)
	self.rot = a
	lasttask = task.New(self, function()
		laser._TurnHalfOn(self, 10, true)
		laser._TurnOff(self, 10, true)
		_del(self, false)
	end)
end
_editor_class["s3_妹红一符射线"] = Class(laser)
_editor_class["s3_妹红一符射线"].init = function(self, _x, _y, v, a)
	laser.init(self, COLOR_RED, _x, _y, 0, 0, 0, 0, 10, 8, 0)
	lasttask = task.New(self, function()
		PlaySound("lazer00", 0.1, 0, false)
		self.bound = false
		self.rot = a
		_object.set_color(self, "mul+add", 255, 255, 255, 255)
		laser._TurnOn(self, 1, false, false)
		task._Wait(61)
		lasttask = task.New(self, function()
			do
				for _ = 1, _infinite do
					do
						for _ = 1, 1 do
							last = New(_editor_class["s3_妹红一符爪光效"], self.x + (self.l1 + self.l2 + self.l3) * cos(a), self.y + (self.l1 + self.l2 + self.l3) * sin(a), ran:Float(0, 360), COLOR_RED, 255, 0, 0)
						end
					end
					task._Wait(1)
				end
			end
		end)
		local r = self.l1 + self.l2 + self.l3
		lasttask = task.New(self, function()
			local _a = self.rot
			local dx, dy = cos(_a), sin(_a)
			do
				for _ = 1, _infinite do
					do
						local r1, _d_r1 = (0), (10)
						for _ = 1, 5 do
							last = New(_editor_class["s3_妹红一符龙尾火弹"], self.x + ran:Float(-3, 3) + r * dx - r1 * dx, self.y + ran:Float(-3, 3) + r * dy - r1 * dy, _a + ran:Float(-10, 10))
							r1 = r1 + _d_r1
						end
					end
					task._Wait(1)
				end
			end
		end)
		PlaySound("slash", 0.1, 0, false)
		do
			local l, _d_l = (40), (v * 2)
			for _ = 1, 18 do
				self.l1 = 1.3 * l
				self.l2 = 0.4 * l
				self.l3 = 1.3 * l
				r = self.l1 + self.l2 + self.l3
				task._Wait(1)
				l = l + _d_l
			end
		end
		self.node = 0
		SetV2(self, v, a, true, false)
		task._Wait(60)
		_del(self, true)
	end)
end
_editor_class["s3_妹红一符爪光效"] = Class(bullet)
_editor_class["s3_妹红一符爪光效"].init = function(self, _x, _y, angle, c, r, g, b)
	bullet.init(self, ball_light_dark, c, false, false)
	self.x, self.y = _x, _y
	SetV2(self, ran:Float(1, 2), angle, true, false)
	self.timer = 11
	self.hscale = 1.5
	self.vscale = 1.5
	_object.set_color(self, "mul+add", 0, r, g, b)
	self.colli = false
	lasttask = task.New(self, function()
		do
			local al, _d_al = (0), (50 / 20)
			for _ = 1, 20 do
				_object.set_color(self, "mul+add", al, r, g, b)
				task._Wait(1)
				al = al + _d_al
			end
		end
		do
			local al, _d_al = (50), (-50 / 30)
			for _ = 1, 30 do
				_object.set_color(self, "mul+add", al, r, g, b)
				task._Wait(1)
				al = al + _d_al
			end
		end
		_del(self, false)
	end)
end
_editor_class["s3_慧音一符花心"] = Class(bullet)
_editor_class["s3_慧音一符花心"].init = function(self, _x, _y, x, y, sty, i, nandu)
	bullet.init(self, ball_mid, COLOR_BLUE, false, false)
	self.x, self.y = _x, _y
	local a = Angle(self, player)
	self.bound = false
	if (sty == 1) then
		lasttask = task.New(self, function()
			do
				local a0, _d_a0 = (a), (24)
				for _ = 1, 15 do
					last = New(_editor_class["s3_慧音一符花"], self.x, self.y, a0, 1, COLOR_GREEN, 12)
					_connect(self, last, 0, true)
					task._Wait(0)
					a0 = a0 + _d_a0
				end
			end
		end)
		lasttask = task.New(self, function()
			do
				local a0, _d_a0 = (a), (18)
				for _ = 1, 20 do
					last = New(_editor_class["s3_慧音一符花"], self.x, self.y, a0, -1, COLOR_CYAN, 20)
					_connect(self, last, 0, true)
					task._Wait(0)
					a0 = a0 + _d_a0
				end
			end
		end)
	else
		lasttask = task.New(self, function()
			do
				local a0, _d_a0 = (a), (24)
				for _ = 1, 15 do
					last = New(_editor_class["s3_慧音一符花"], self.x, self.y, a0, 1, COLOR_PURPLE, 12)
					_connect(self, last, 0, true)
					task._Wait(0)
					a0 = a0 + _d_a0
				end
			end
		end)
		lasttask = task.New(self, function()
			do
				local a0, _d_a0 = (a), (18)
				for _ = 1, 20 do
					last = New(_editor_class["s3_慧音一符花"], self.x, self.y, a0, -1, COLOR_YELLOW, 20)
					_connect(self, last, 0, true)
					task._Wait(0)
					a0 = a0 + _d_a0
				end
			end
		end)
	end
	self.flag = 2
	lasttask = task.New(self, function()
		task.MoveTo(x, y, 60, MOVE_DECEL)
		task._Wait(20)
		if (difficulty == 4) then
			do
				local t, _d_t = (60), (3)
				local len, _d_len = (0), (130 / 6 * i)
				for _ = 1, 7 do
					if (sty == 1) then
						last = New(_editor_class["s3_慧音一符札弹"], self.x, self.y, -90, COLOR_CYAN, t, nandu, len)
					else
						last = New(_editor_class["s3_慧音一符札弹"], self.x, self.y, -90, COLOR_ORANGE, t, nandu, len)
					end
					t = t + _d_t
					len = len + _d_len
				end
			end
		else
			do
				local t, _d_t = (60), (3)
				local len, _d_len = (0), (130 / 4 * i)
				for _ = 1, 5 do
					if (sty == 1) then
						last = New(_editor_class["s3_慧音一符札弹"], self.x, self.y, -90, COLOR_CYAN, t, nandu, len)
					else
						last = New(_editor_class["s3_慧音一符札弹"], self.x, self.y, -90, COLOR_ORANGE, t, nandu, len)
					end
					t = t + _d_t
					len = len + _d_len
				end
			end
		end
		task.MoveTo(x + 140 * i, y, 60, MOVE_DECEL)
		task._Wait(30)
		_set_a(self, 0.02, 270, false)
		_forbid_v(self, 1.5, 'original', 'original')
		task._Wait(360)
		_del(self, true)
	end)
end
_editor_class["s3_慧音一符花"] = Class(bullet)
_editor_class["s3_慧音一符花"].init = function(self, _x, _y, a0, i, c, r)
	bullet.init(self, arrow_big, c, false, false)
	self.x, self.y = _x, _y
	lasttask = task.New(self, function()
		do
			--local a, _d_a = (a0), (1 * i)
			local dx, dy = r * cos(a0), r * sin(a0)
			for _ = 1, _infinite do
				_set_rel_pos(self, dx, dy, a0, false)
				--self.rot = a
				task._Wait(1)
				--a = a + _d_a
			end
		end
	end)
end
_editor_class["s3_慧音一符札弹"] = Class(bullet)
_editor_class["s3_慧音一符札弹"].init = function(self, _x, _y, a, c, t, nandu, len)
	bullet.init(self, square, c, true, false)
	self.x, self.y = _x, _y
	SetV2(self, 0, a, true, false)
	lasttask = task.New(self, function()
		task.MoveTo(self.x + len, self.y, 60, MOVE_DECEL)
		task._Wait(30)
		_set_a(self, 0.02, 270, false)
		_forbid_v(self, 1.5, 'original', 'original')
		task._Wait(360)
		_del(self, true)
	end)
end
_editor_class["s3_妹红一符龙头"] = Class(bullet)
_editor_class["s3_妹红一符龙头"].init = function(self, _x, _y, a0, i, nandu, t)
	bullet.init(self, arrow_big, COLOR_DEEP_RED, false, false)
	self.x, self.y = _x, _y
	self.hscale = 1
	self.vscale = 0.5
	self.bound = false
	self.navi = true
	_object.set_color(self, "mul+add", 255, 255, 255, 255)
	lasttask = task.New(self, function()
		do
			local s, _d_s = (0.5), (2 / 20)
			for _ = 1, 20 do
				self.hscale = s * 2
				self.vscale = s
				task._Wait(1)
				s = s + _d_s
			end
		end
		do
			for _ = 1, _infinite do
				New(_editor_class["s3_妹红一符爪光效"], self.x, self.y, ran:Float(0, 360), COLOR_ORANGE, 255, 0, 0)
				task._Wait(4)
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				New(_editor_class["s3_妹红一符龙尾火弹"], self.x + ran:Float(-3, 3), self.y + ran:Float(-3, 3), self.rot + ran:Float(-10, 10))
				task._Wait(2)
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			local v, _d_v = (4), (-3.8 / t)
			local a, _d_a = (a0), (-30 / 40 * i)
			for _ = 1, t do
				SetV2(self, v, a, true, false)
				task._Wait(1)
				v = v + _d_v
				a = a + _d_a
			end
		end
		task._Wait(20)
		lasttask = task.New(self, function()
			do
				local aa, _d_aa = (self.rot - 100 * i), (-nandu * 10 * i)
				for _ = 1, 60 do
					_set_a(self, nandu, aa, false)
					task._Wait(1)
					aa = aa + _d_aa
				end
			end
			task._Wait(120)
			self.bound = true
		end)
	end)
end
_editor_class["s3_妹红一符龙尾火弹"] = Class(bullet)
_editor_class["s3_妹红一符龙尾火弹"].init = function(self, _x, _y, angle)
	bullet.init(self, water_drop, COLOR_RED, true, false)
	self.x, self.y = _x, _y
	SetV2(self, 0, angle, true, false)
	self.hscale = 1.4
	self.vscale = 1.4
	self.timer = 11
	lasttask = task.New(self, function()
		task._Wait(10)
		do
			local s, _d_s = (1.4), (-1.4 / 20)
			for _ = 1, 20 do
				self.hscale = s
				self.vscale = s
				task._Wait(1)
				s = s + _d_s
			end
		end
		_del(self, false)
	end)
end

_editor_class["s3_妹红二非羽毛"] = Class(bullet)
_editor_class["s3_妹红二非羽毛"].init = function(self, _x, _y, a, v, c)
	bullet.init(self, arrow_big, c, false, true)
	self.x, self.y = _x, _y
	local s = 2.5
	self.hscale = s * self.hscale
	self.vscale = 1 * self.vscale
	self.a = s * self.a
	self.b = 1 * self.b
	SetV2(self, v * 1.5, a, true, false)
	lasttask = task.New(self, function()
		do
			local vv, _d_vv = (v * 1.5), (-v * 0.5 / 11)
			for _ = 1, 12 do
				SetV2(self, vv, a, true, false)
				task._Wait(1)
				vv = vv + _d_vv
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				last = New(_editor_class["s3_妹红二非羽毛火焰"], self.x, self.y, a + ran:Float(-15, 15), c)
				task._Wait(6)
			end
		end
	end)
end
_editor_class["s3_妹红二非羽毛火焰"] = Class(bullet)
_editor_class["s3_妹红二非羽毛火焰"].init = function(self, _x, _y, a, c)
	bullet.init(self, water_drop, c, false, true)
	self.x, self.y = _x, _y
	self.timer = 11
	local s0 = ran:Float(0.7, 0.9)
	self.hscale0 = s0 * self.hscale
	self.vscale0 = s0 * self.vscale
	self.a0 = s0 * self.a / 2
	self.b0 = s0 * self.b / 2
	SetV2(self, 0.0001, a, true, false)
	lasttask = task.New(self, function()
		task._Wait(5)
		do
			local s, _d_s = (s0), (-s0 / 14)
			for _ = 1, 15 do
				self.hscale = s * self.hscale0
				self.vscale = s * self.vscale0
				self.a = s * self.a0
				self.b = s * self.b0
				task._Wait(1)
				s = s + _d_s
			end
		end
		_del(self, false)
	end)
end

_editor_class["s3_慧音二符使魔:Hard"] = Class(_object)
_editor_class["s3_慧音二符使魔:Hard"].init = function(self, _x, _y, v, a, i)
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
	self.omiga = 3 * i
	self.vscale = 0
	self.hscale = 0
	self.bound = false
	lasttask = task.New(self, function()
		do
			local al, _d_al = (0), (255 / 10)
			local s, _d_s = (0), (0.8 / 10)
			for _ = 1, 10 do
				_object.set_color(self, "mul+add", al, 0, 100, 255)
				self.vscale = s
				self.hscale = s
				task._Wait(1)
				al = al + _d_al
				s = s + _d_s
			end
		end
		do
			local aa, _d_aa = (a), (-90 * i)
			local vv, _d_vv = (v), (3.2)
			for _ = 1, 4 do
				do
					local aerfa, _d_aerfa = (0), (90 / 59)
					for t = 1, 60 do
						SetV2(self, vv - vv * sin(aerfa), aa, false, false)
						if t % 2 == 0 then
							last = New(_editor_class["s3_慧音二符消失札弹"], self.x, self.y, aa + 90 * i)
							last.layer = LAYER_ENEMY_BULLET - 2
						end
						task._Wait(1)
						aerfa = aerfa + _d_aerfa
					end
				end
				task._Wait(1)
				aa = aa + _d_aa
				vv = vv + _d_vv
			end
		end
		_del(self, true)
	end)
end
_editor_class["s3_慧音二符飞出使魔:Hard"] = Class(_object)
_editor_class["s3_慧音二符飞出使魔:Hard"].init = function(self, _x, _y, v, a, i)
	self.x, self.y = _x, _y
	self.img = "magic4"
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
	self.omiga = 3 * i
	self.vscale = 0
	self.hscale = 0
	local x = self.x
	local y = self.y
	lasttask = task.New(self, function()
		do
			local al, _d_al = (0), (255 / 10)
			local s, _d_s = (0), (0.8 / 10)
			for _ = 1, 10 do
				_object.set_color(self, "mul+add", al, 255, 255, 255)
				self.vscale = s
				self.hscale = s
				task._Wait(1)
				al = al + _d_al
				s = s + _d_s
			end
		end
		do
			local a1, _d_a1 = (a), (0.9 * i)
			for _ = 1, _infinite do
				SetV2(self, v, a1, true, false)
				if (self.timer % 18 == 0 and Dist(self, player) > 40 and self.y > -120) then
					lasttask = task.New(self, function()
						do
							for _ = 1, 3 do
								last = New(_editor_class["s3_慧音二符飞出札弹"], self.x, self.y, Angle(self.x, self.y, x, y), 8 + 2 * i)
								task._Wait(1)
							end
						end
					end)
				else
				end
				task._Wait(1)
				a1 = a1 + _d_a1
			end
		end
	end)
end
_editor_class["s3_慧音二符使魔_EN"] = Class(_object)
_editor_class["s3_慧音二符使魔_EN"].init = function(self, _x, _y, v, a, i)
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
	self.omiga = 3 * i
	self.vscale = 0
	self.hscale = 0
	self.bound = false
	lasttask = task.New(self, function()
		do
			local al, _d_al = (0), (255 / 10)
			local s, _d_s = (0), (0.8 / 10)
			for _ = 1, 10 do
				_object.set_color(self, "mul+add", al, 0, 100, 255)
				self.vscale = s
				self.hscale = s
				task._Wait(1)
				al = al + _d_al
				s = s + _d_s
			end
		end
		do
			local aerfa, _d_aerfa = (0), (90 / 29)
			for _ = 1, 30 do
				SetV2(self, 4 - 4 * sin(aerfa), a, false, false)
				last = New(_editor_class["s3_慧音二符消失札弹"], self.x, self.y, a + 90 * i)
				task._Wait(2)
				aerfa = aerfa + _d_aerfa
			end
		end
		a = a - 90 * i
		do
			local aerfa, _d_aerfa = (0), (90 / 29)
			for _ = 1, 30 do
				SetV2(self, 4 - 4 * sin(aerfa), a, false, false)
				last = New(_editor_class["s3_慧音二符消失札弹"], self.x, self.y, a + 90 * i)
				task._Wait(2)
				aerfa = aerfa + _d_aerfa
			end
		end
		_del(self, true)
	end)
end
_editor_class["s3_慧音二符飞出使魔_EN"] = Class(_object)
_editor_class["s3_慧音二符飞出使魔_EN"].init = function(self, _x, _y, v, a, i, nandu)
	self.x, self.y = _x, _y
	self.img = "magic4"
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
	self.omiga = 3 * i
	self.vscale = 0
	self.hscale = 0
	local x = self.x
	local y = self.y
	SetV2(self, v, a, true, false)
	lasttask = task.New(self, function()
		do
			local al, _d_al = (0), (255 / 10)
			local s, _d_s = (0), (0.8 / 10)
			for _ = 1, 10 do
				_object.set_color(self, "mul+add", al, 255, 255, 255)
				self.vscale = s
				self.hscale = s
				task._Wait(1)
				al = al + _d_al
				s = s + _d_s
			end
		end
		do
			local vv, _d_vv = (1), (0.3)
			for _ = 1, _infinite do
				if (Dist(self, player) > 40) then
					last = New(_straight, square, 8 + 2 * i, self.x, self.y, vv, Angle(self.x, self.y, x, y), false, 0, true, true, 0, false, 0, 0, 0, false)
				else
				end
				task._Wait(nandu)
				vv = vv + _d_vv
			end
		end
	end)
end
_editor_class["s3_妹红二符放火札_EN"] = Class(bullet)
_editor_class["s3_妹红二符放火札_EN"].init = function(self, _x, _y, x, y, mode)
	bullet.init(self, square, COLOR_DEEP_RED, false, false)
	self.x, self.y = _x, _y
	self.timer = 11
	self.navi = true
	self.a0 = self.a
	self.b0 = self.b
	self.hscale0 = self.hscale
	self.vscale0 = self.vscale
	self.rot = Angle(self.x, self.y, x, y)
	self.vscale = 0
	self.hscale = 0
	self.a = 0
	self.b = 0
	lasttask = task.New(self, function()
		do
			local s, _d_s = (0), (3 / 15)
			for _ = 1, 15 do
				self.hscale = s * self.hscale0
				self.vscale = s * self.vscale0
				self.a = s * self.a * 2.5
				self.b = s * self.b
				task._Wait(1)
				s = s + _d_s
			end
		end
		task.MoveTo(x, y, 60, MOVE_DECEL)
		do
			for _ = 1, 3 do
				_object.set_color(self, "mul+alpha", 255, 255, 100, 100)
				task._Wait(5)
				_object.set_color(self, "", 100, 255, 100, 100)
				task._Wait(5)
				task._Wait(1)
			end
		end
		if (mode == 1) then
			do
				local a, _d_a = (ran:Float(0, 360)), (15)
				for _ = 1, 24 do
					last = New(_editor_class["s3_妹红二符消失火弹_EN"], self.x + 24 * cos(a), self.y + 24 * sin(a), a)
					task._Wait(0)
					a = a + _d_a
				end
			end
		else
			do
				local a, _d_a = (ran:Float(0, 360)), (36)
				for _ = 1, 10 do
					last = New(_straight, water_drop, COLOR_DEEP_RED, self.x + 24 * cos(a), self.y + 24 * sin(a), 0, a, false, 0, true, true, 0, false, 0.025, a, ran:Float(1.5, 2), false)
					task._Wait(0)
					a = a + _d_a
				end
			end
		end
		PlaySound("enep00", 0.1, 0, false)
		_del(self, true)
	end)
end
_editor_class["s3_妹红二符消失火弹_EN"] = Class(bullet)
_editor_class["s3_妹红二符消失火弹_EN"].init = function(self, _x, _y, a)
	bullet.init(self, water_drop, COLOR_ORANGE, false, true)
	self.x, self.y = _x, _y
	SetV2(self, 0.8, a, true, false)
	lasttask = task.New(self, function()
		task._Wait(45)
		_del(self, true)
	end)
end
_editor_class["s3_慧音二符使魔:Lunatic"] = Class(_object)
_editor_class["s3_慧音二符使魔:Lunatic"].init = function(self, _x, _y, v, a, i)
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
	self.omiga = 3 * i
	self.vscale = 0
	self.hscale = 0
	self.bound = false
	lasttask = task.New(self, function()
		do
			local al, _d_al = (0), (255 / 10)
			local s, _d_s = (0), (0.8 / 10)
			for _ = 1, 10 do
				_object.set_color(self, "mul+add", al, 0, 100, 255)
				self.vscale = s
				self.hscale = s
				task._Wait(1)
				al = al + _d_al
				s = s + _d_s
			end
		end
		do
			local aa, _d_aa = (a), (-90 * i)
			local vv, _d_vv = (v), (3.2)
			for _ = 1, 7 do
				do
					local aerfa, _d_aerfa = (0), (90 / 59)
					for t = 1, 60 do
						SetV2(self, vv - vv * sin(aerfa), aa, false, false)
						if t % 2 == 0 then
							last = New(_editor_class["s3_慧音二符消失札弹"], self.x, self.y, aa + 90 * i)
							last.layer = LAYER_ENEMY_BULLET - 1
						end
						task._Wait(1)
						aerfa = aerfa + _d_aerfa
					end
				end
				task._Wait(1)
				aa = aa + _d_aa
				vv = vv + _d_vv
			end
		end
		_del(self, true)
	end)
end
_editor_class["s3_慧音二符消失札弹"] = Class(bullet)
_editor_class["s3_慧音二符消失札弹"].init = function(self, _x, _y, a)
	bullet.init(self, square, COLOR_GRAY, false, true)
	self.x, self.y = _x, _y
	self.rot = a
	lasttask = task.New(self, function()
		task._Wait(240)
		_del(self, true)
	end)
end
_editor_class["s3_妹红踢预警"] = Class(laser)
_editor_class["s3_妹红踢预警"].init = function(self, _x, _y, a, c)
	laser.init(self, c, _x, _y, 0, 0, 600, 0, 2, 0, 0)
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
			local v, _d_v = (0.02), (0.08)
			for _ = 1, 24 do
				last = New(_editor_class["s3_妹红踢预警虚影"], self.x, self.y, self.rot, self.rot + 90, v, c)
				last = New(_editor_class["s3_妹红踢预警虚影"], self.x, self.y, self.rot, self.rot - 90, v, c)
				task._Wait(1)
				v = v + _d_v
			end
		end
		laser._TurnOff(self, 5, false)
		_del(self, true)
	end)
end
_editor_class["s3_妹红踢预警"].kill = function(self)
end
_editor_class["s3_妹红踢预警虚影"] = Class(laser)
_editor_class["s3_妹红踢预警虚影"].init = function(self, _x, _y, a, b, v, c)
	laser.init(self, COLOR_RED, _x, _y, 0, 0, 900, 0, 2, 0, 0)
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
			local aerfa, _d_aerfa = (-90), (360 / 40)
			for _ = 1, 40 do
				_object.set_color(self, "mul+add", 125 + 125 * sin(aerfa), 255, 255, 255)
				task._Wait(1)
				aerfa = aerfa + _d_aerfa
			end
		end
		laser._TurnOff(self, 5, true)
		_del(self, false)
	end)
end
_editor_class["s3_妹红踢预警虚影"].kill = function(self)
end
_editor_class["s3_妹红踢爆炸效果"] = Class(bullet)
_editor_class["s3_妹红踢爆炸效果"].init = function(self, _x, _y, v, a)
	bullet.init(self, ball_big, COLOR_YELLOW, true, false)
	self.x, self.y = _x, _y
	_object.set_color(self, "mul+add", 50, 255, 100, 100)
	self.timer = 11
	SetV2(self, 0.5, a, true, false)
	lasttask = task.New(self, function()
		self.bound = false
		self.layer = -250
		self.colli = false
		lasttask = task.New(self, function()
			task._Wait(15)
			do
				local vv, _d_vv = (0.5), (v / 100)
				for _ = 1, 100 do
					SetV2(self, vv, a, true, false)
					task._Wait(1)
					vv = vv + _d_vv
				end
			end
		end)
		do
			local s, _d_s = (0.5), (7 / 80)
			local ss, _d_ss = (0.5), (7 / 80)
			for _ = 1, 80 do
				self.hscale = s
				self.vscale = ss
				self.a = 11 * s
				self.b = 11 * s
				task._Wait(1)
				s = s + _d_s
				ss = ss + _d_ss
			end
		end
		task._Wait(60)
		self.bound = true
	end)
end
_editor_class["s3_妹红踢魔炮"] = Class(bullet)
_editor_class["s3_妹红踢魔炮"].init = function(self, _x, _y, v, a, c)
	bullet.init(self, ball_light_dark, c, true, true)
	self.x, self.y = _x, _y
	_object.set_color(self, "mul+add", 250, 255, 255, 255)
	self.timer = 11
	SetV2(self, 0.5, a, true, false)
	lasttask = task.New(self, function()
		self.bound = false
		--[[ 1 --]]--[=[
            self.layer=-250
        --]=]
		lasttask = task.New(self, function()
			do
				local vv, _d_vv = (0.5), (v / 100)
				for _ = 1, 100 do
					SetV2(self, vv, a, true, false)
					task._Wait(1)
					vv = vv + _d_vv
				end
			end
		end)
		do
			local s, _d_s = (0.5), (7 / 80)
			local ss, _d_ss = (0.5), (7 / 80)
			for _ = 1, 80 do
				self.hscale = s
				self.vscale = s
				self.a = 11 * s
				self.b = 11 * s
				task._Wait(1)
				s = s + _d_s
				ss = ss + _d_ss
			end
		end
		task._Wait(60)
		self.bound = true
	end)
end
_editor_class["s3_妹红激光预警"] = Class(laser)
_editor_class["s3_妹红激光预警"].init = function(self, _x, _y, a, nandu)
	laser.init(self, COLOR_RED, _x, _y, 0, 0, 0, 0, 15, 20, 0)
	lasttask = task.New(self, function()
		laser.ChangeImage(self, 2)
		_object.set_color(self, "mul+add", 255, 255, 25, 25)
		laser._TurnHalfOn(self, 1, false)
		self.rot = a
		do
			local aerfa, _d_aerfa = (0), (90 / 4)
			for _ = 1, 5 do
				self.l2 = 750 * sin(aerfa)
				task._Wait(1)
				aerfa = aerfa + _d_aerfa
			end
		end
		do
			local v, _d_v = (0.25), (0.5)
			for _ = 1, 5 do
				last = New(_editor_class["s3_妹红激光预警虚影"], self.x, self.y, a, a + 90, v)
				last = New(_editor_class["s3_妹红激光预警虚影"], self.x, self.y, a, a - 90, v)
				task._Wait(0)
				v = v + _d_v
			end
		end
		task._Wait(15)
		laser._TurnOff(self, 20, true)
		task._Wait(20)
		laser._TurnOn(self, 10, false, true)
		misc.ShakeScreen(30, 3)
		PlaySound("enep00", 0.3, self.x / 256, false)
		do
			local v, _d_v = (3), (4 / nandu)
			for _ = 1, nandu do
				last = New(_straight, water_drop, COLOR_RED, self.x, self.y, v, 90, false, 0, true, false, 0, false, 0.04, 270, 0, false)
				last.navi = true
				task._Wait(0)
				v = v + _d_v
			end
		end
		laser._TurnOff(self, 50, true)
		_del(self, true)
	end)
end
_editor_class["s3_妹红激光预警"].kill = function(self)
end
_editor_class["s3_妹红激光预警虚影"] = Class(laser)
_editor_class["s3_妹红激光预警虚影"].init = function(self, _x, _y, a, b, v)
	laser.init(self, COLOR_ORANGE, _x, _y, 0, 0, 900, 0, 10, 0, 0)
	laser.ChangeImage(self, 2)
	_object.set_color(self, "mul+add", 150, 255, 255, 255)
	SetV2(self, v, b, true, false)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				self.rot = a
				task._Wait(1)
			end
		end
	end)
	lasttask = task.New(self, function()
		laser._TurnHalfOn(self, 10, true)
		laser._TurnOff(self, 10, true)
		_del(self, false)
	end)
end
_editor_class["s3_妹红激光预警虚影"].kill = function(self)
end
_editor_class["s3_慧音二符飞出使魔:Lunatic"] = Class(_object)
_editor_class["s3_慧音二符飞出使魔:Lunatic"].init = function(self, _x, _y, v, a, i)
	self.x, self.y = _x, _y
	self.img = "magic4"
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
	self.omiga = 3 * i
	self.vscale = 0
	self.hscale = 0
	local x = self.x
	local y = self.y
	lasttask = task.New(self, function()
		do
			local al, _d_al = (0), (255 / 10)
			local s, _d_s = (0), (0.8 / 10)
			for _ = 1, 10 do
				_object.set_color(self, "mul+add", al, 255, 255, 255)
				self.vscale = s
				self.hscale = s
				task._Wait(1)
				al = al + _d_al
				s = s + _d_s
			end
		end
		do
			local a1, _d_a1 = (a), (0.9 * i)
			for _ = 1, _infinite do
				SetV2(self, v, a1, true, false)
				if (self.timer % 16 == 0 and Dist(self, player) > 40 and self.y > -120) then
					lasttask = task.New(self, function()
						do
							for _ = 1, 5 do
								last = New(_editor_class["s3_慧音二符飞出札弹"], self.x, self.y, Angle(self.x, self.y, x, y), 8 + 2 * i)
								task._Wait(1)
							end
						end
					end)
				else
				end
				task._Wait(1)
				a1 = a1 + _d_a1
			end
		end
	end)
end
_editor_class["s3_慧音二符飞出札弹"] = Class(bullet)
_editor_class["s3_慧音二符飞出札弹"].init = function(self, _x, _y, a, c)
	bullet.init(self, square, c, true, true)
	self.x, self.y = _x, _y
	SetV2(self, 0, a, true, false)
	lasttask = task.New(self, function()
		self.layer = LAYER_ENEMY_BULLET + 1
		task._Wait(15)
		do
			local v, _d_v = (0), (1.5 / 59)
			for _ = 1, 60 do
				SetV2(self, v, a, true, false)
				task._Wait(1)
				v = v + _d_v
			end
		end
	end)
end

_editor_class["s3_慧音三非使魔:Easy"] = Class(_object)
_editor_class["s3_慧音三非使魔:Easy"].init = function(self, _x, _y, i, r, aerfa, v)
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
	if (cos(aerfa) > 0) then
		i = -1
	else
		i = 1
	end
	local j = 1
	if (sin(aerfa) > 0) then
		j = 1
	else
		j = -1
	end
	self.omiga = 3 * i
	self.vscale = 0
	self.hscale = 0
	self.bound = false
	lasttask = task.New(self, function()
		do
			local rr, _d_rr = (0), (r / 9)
			for _ = 1, 10 do
				_set_rel_pos(self, rr * cos(aerfa), rr * sin(aerfa), self.rot, false)
				task._Wait(1)
				rr = rr + _d_rr
			end
		end
		do
			for _ = 1, _infinite do
				_set_rel_pos(self, r * cos(aerfa), r * sin(aerfa), self.rot, false)
				task._Wait(1)
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			local al, _d_al = (0), (255 / 10)
			local s, _d_s = (0), (0.8 / 10)
			for _ = 1, 10 do
				_object.set_color(self, "mul+add", al, 255, 0, 0)
				self.vscale = s
				self.hscale = s
				task._Wait(1)
				al = al + _d_al
				s = s + _d_s
			end
		end
		do
			local a, _d_a = (0), (0)
			for _ = 1, 6 do
				do
					local b, _d_b = (90 * j), (180)
					for _ = 1, 2 do
						if (r > 50) then
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v, COLOR_RED)
						else
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v * 0.6, COLOR_PURPLE)
						end
						task._Wait(0)
						b = b + _d_b
					end
				end
				task._Wait(20)
				a = a + _d_a
			end
		end
		do
			local a, _d_a = (0), (15.7 * i * 1.4)
			for _ = 1, _infinite do
				do
					local b, _d_b = (90 * j), (180)
					for _ = 1, 2 do
						if (r > 50) then
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v, COLOR_RED)
						else
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v * 0.6, COLOR_PURPLE)
						end
						task._Wait(0)
						b = b + _d_b
					end
				end
				task._Wait(20)
				a = a + _d_a
			end
		end
	end)
end
_editor_class["s3_慧音三非使魔:Normal"] = Class(_object)
_editor_class["s3_慧音三非使魔:Normal"].init = function(self, _x, _y, i, r, aerfa, v)
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
	if (cos(aerfa) > 0) then
		i = -1
	else
		i = 1
	end
	local j = 1
	if (sin(aerfa) > 0) then
		j = 1
	else
		j = -1
	end
	self.omiga = 3 * i
	self.vscale = 0
	self.hscale = 0
	self.bound = false
	lasttask = task.New(self, function()
		do
			local rr, _d_rr = (0), (r / 9)
			for _ = 1, 10 do
				_set_rel_pos(self, rr * cos(aerfa), rr * sin(aerfa), self.rot, false)
				task._Wait(1)
				rr = rr + _d_rr
			end
		end
		do
			for _ = 1, _infinite do
				_set_rel_pos(self, r * cos(aerfa), r * sin(aerfa), self.rot, false)
				task._Wait(1)
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			local al, _d_al = (0), (255 / 10)
			local s, _d_s = (0), (0.8 / 10)
			for _ = 1, 10 do
				_object.set_color(self, "mul+add", al, 255, 0, 0)
				self.vscale = s
				self.hscale = s
				task._Wait(1)
				al = al + _d_al
				s = s + _d_s
			end
		end
		do
			local a, _d_a = (0), (0)
			for _ = 1, 8 do
				do
					local b, _d_b = (90 * j), (180)
					for _ = 1, 2 do
						if (r > 50) then
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v, COLOR_RED)
						else
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v * 0.6, COLOR_PURPLE)
						end
						task._Wait(0)
						b = b + _d_b
					end
				end
				task._Wait(15)
				a = a + _d_a
			end
		end
		do
			local a, _d_a = (0), (14.7 * i * 1.4)
			for _ = 1, _infinite do
				do
					local b, _d_b = (90 * j), (180)
					for _ = 1, 2 do
						if (r > 50) then
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v, COLOR_RED)
						else
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v * 0.6, COLOR_PURPLE)
						end
						task._Wait(0)
						b = b + _d_b
					end
				end
				task._Wait(15)
				a = a + _d_a
			end
		end
	end)
end
_editor_class["s3_慧音三非使魔:Hard"] = Class(_object)
_editor_class["s3_慧音三非使魔:Hard"].init = function(self, _x, _y, i, r, aerfa, v)
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
	if (cos(aerfa) > 0) then
		i = -1
	else
		i = 1
	end
	local j = 1
	if (sin(aerfa) > 0) then
		j = 1
	else
		j = -1
	end
	self.omiga = 3 * i
	self.vscale = 0
	self.hscale = 0
	self.bound = false
	lasttask = task.New(self, function()
		do
			local rr, _d_rr = (0), (r / 9)
			for _ = 1, 10 do
				_set_rel_pos(self, rr * cos(aerfa), rr * sin(aerfa), self.rot, false)
				task._Wait(1)
				rr = rr + _d_rr
			end
		end
		do
			for _ = 1, _infinite do
				_set_rel_pos(self, r * cos(aerfa), r * sin(aerfa), self.rot, false)
				task._Wait(1)
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			local al, _d_al = (0), (255 / 10)
			local s, _d_s = (0), (0.8 / 10)
			for _ = 1, 10 do
				_object.set_color(self, "mul+add", al, 255, 0, 0)
				self.vscale = s
				self.hscale = s
				task._Wait(1)
				al = al + _d_al
				s = s + _d_s
			end
		end
		do
			local a, _d_a = (0), (0)
			for _ = 1, 8 do
				do
					local b, _d_b = (90 * j), (120)
					for _ = 1, 3 do
						if (r > 50) then
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v, COLOR_RED)
						else
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v * 0.6, COLOR_PURPLE)
						end
						task._Wait(0)
						b = b + _d_b
					end
				end
				task._Wait(15)
				a = a + _d_a
			end
		end
		do
			local a, _d_a = (0), (11.7 * i * 1.4)
			for _ = 1, _infinite do
				do
					local b, _d_b = (90 * j), (120)
					for _ = 1, 3 do
						if (r > 50) then
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v, COLOR_RED)
						else
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v * 0.6, COLOR_PURPLE)
						end
						task._Wait(0)
						b = b + _d_b
					end
				end
				task._Wait(15)
				a = a + _d_a
			end
		end
	end)
end
_editor_class["s3_慧音三非使魔:Lunatic"] = Class(_object)
_editor_class["s3_慧音三非使魔:Lunatic"].init = function(self, _x, _y, i, r, aerfa, v)
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
	if (cos(aerfa) > 0) then
		i = -1
	else
		i = 1
	end
	local j = 1
	if (sin(aerfa) > 0) then
		j = 1
	else
		j = -1
	end
	self.omiga = 3 * i
	self.vscale = 0
	self.hscale = 0
	self.bound = false
	lasttask = task.New(self, function()
		do
			local rr, _d_rr = (0), (r / 9)
			for _ = 1, 10 do
				_set_rel_pos(self, rr * cos(aerfa), rr * sin(aerfa), self.rot, false)
				task._Wait(1)
				rr = rr + _d_rr
			end
		end
		do
			for _ = 1, _infinite do
				_set_rel_pos(self, r * cos(aerfa), r * sin(aerfa), self.rot, false)
				task._Wait(1)
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			local al, _d_al = (0), (255 / 10)
			local s, _d_s = (0), (0.8 / 10)
			for _ = 1, 10 do
				_object.set_color(self, "mul+add", al, 255, 0, 0)
				self.vscale = s
				self.hscale = s
				task._Wait(1)
				al = al + _d_al
				s = s + _d_s
			end
		end
		do
			local a, _d_a = (0), (0)
			for _ = 1, 8 do
				do
					local b, _d_b = (90 * j), (120)
					for _ = 1, 3 do
						if (r > 50) then
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v * 1.2, COLOR_RED)
						else
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v * 0.6, COLOR_PURPLE)
						end
						task._Wait(0)
						b = b + _d_b
					end
				end
				task._Wait(14)
				a = a + _d_a
			end
		end
		do
			local a, _d_a = (0), (8.7 * i * 1.4)
			for _ = 1, _infinite do
				do
					local b, _d_b = (90 * j), (120)
					for _ = 1, 3 do
						if (r > 50) then
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v * 1.2, COLOR_RED)
						else
							last = New(_editor_class["s3_慧音一非小玉"], self.x, self.y, a + b, v * 0.6, COLOR_PURPLE)
						end
						task._Wait(0)
						b = b + _d_b
					end
				end
				task._Wait(14)
				a = a + _d_a
			end
		end
	end)
end
_editor_class["s3_妹红三非札弹"] = Class(bullet)
_editor_class["s3_妹红三非札弹"].init = function(self, _x, _y, a, mv)
	bullet.init(self, square, COLOR_ORANGE, false, true)
	self.x, self.y = _x, _y
	SetV2(self, 0.02, a, true, false)
	lasttask = task.New(self, function()
		task._Wait(10)
		_set_a(self, 0.1, a, false)
		_forbid_v(self, mv, 'original', 'original')
	end)
end

_editor_class["s3_慧音三符预警_EN"] = Class(laser)
_editor_class["s3_慧音三符预警_EN"].init = function(self, _x, _y, a, c)
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
			local v, _d_v = (0.02), (0.07)
			for _ = 1, 8 do
				last = New(_editor_class["s3_慧音三符预警虚影"], self.x, self.y, self.rot, self.rot + 90, v, c)
				last = New(_editor_class["s3_慧音三符预警虚影"], self.x, self.y, self.rot, self.rot - 90, v, c)
				task._Wait(1)
				v = v + _d_v
			end
		end
		laser._TurnOff(self, 5, false)
		task._Wait(60)
		PlaySound("tan00", 0.1, self.x / 256, false)
		do
			local v, _d_v = (14), (-13.75 / 28)
			local count, _d_count = (1), (1)
			for _ = 1, 29 do
				if (count % 2 == 0) then
				else
					last = New(_editor_class["s3_慧音三符弹幕"], self.x, self.y, square, COLOR_YELLOW, v, a)
				end
				task._Wait(3)
				v = v + _d_v
				count = count + _d_count
			end
		end
		task._Wait(60)
		_del(self, true)
	end)
end
_editor_class["s3_慧音三符预警_EN"].kill = function(self)
end
_editor_class["s3_妹红三符下雨云_EN"] = Class(_object)
_editor_class["s3_妹红三符下雨云_EN"].init = function(self, _x, _y, x, y, t, nandu, maxv)
	self.x, self.y = _x, _y
	self.img = "image:cloud2"
	self.layer = LAYER_ENEMY_BULLET + 1
	self.group = GROUP_INDES
	self.hide = false
	self.bound = false
	self.navi = false
	self.hp = 10
	self.maxhp = 10
	self.colli = false
	self._servants = {}
	self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
	lasttask = task.New(self, function()
		task.MoveTo(x, y, 60, MOVE_ACC_DEC)
		do
			for _ = 1, 3 do
				_object.set_color(self, "mul+alpha", 255, 255, 255, 255)
				task._Wait(5)
				_object.set_color(self, "", 100, 255, 255, 255)
				task._Wait(5)
				task._Wait(1)
			end
		end
	end)
	lasttask = task.New(self, function()
		self.bound = false
		self.colli = false
		self.rot = ran:Float(-15, 15)
		lasttask = task.New(self, function()
			do
				local s, _d_s = (0), (0.9 / 90)
				for _ = 1, 90 do
					self.hscale = s
					self.vscale = s
					task._Wait(1)
					s = s + _d_s
				end
			end
			self.colli = true
		end)
		do
			local B, _d_B = (255), (-255 / 90)
			local G, _d_G = (255), (-255 / 90)
			local al, _d_al = (155), (100 / 90)
			for _ = 1, 90 do
				_object.set_color(self, "", al, 255, G, B)
				task._Wait(1)
				B = B + _d_B
				G = G + _d_G
				al = al + _d_al
			end
		end
		task._Wait(10)
		task._Wait(t)
		do
			local a, _d_a = (220 + ran:Float(-5, 5)), (100 / (nandu - 1))
			for _ = 1, nandu do
				last = New(_straight, water_drop, COLOR_RED, self.x, self.y, 0, a, false, 0, true, true, 0, false, 0.05, a, maxv, false)
				task._Wait(0)
				a = a + _d_a
			end
		end
		lasttask = task.New(self, function()
			task.MoveTo(self.x, self.y + 200, 90, MOVE_ACC_DEC)
		end)
		do
			local a, _d_a = (155), (-1.55)
			local s, _d_s = (0.9), (-0.2 / 100)
			for _ = 1, 101 do
				_object.set_color(self, "", a, 255, 255, 255)
				self.hscale = s
				self.vscale = s
				task._Wait(1)
				a = a + _d_a
				s = s + _d_s
			end
		end
		self.bound = true
	end)
	lasttask = task.New(self, function()
		do
			local beta, _d_beta = (0), (360 / 100)
			for _ = 1, _infinite do
				self.rot = -20 * sin(beta)
				task._Wait(1)
				beta = beta + _d_beta
			end
		end
	end)
end
_editor_class["s3_妹红三符下雨云_EN"].del = function(self)
end
_editor_class["s3_慧音三符花心_EN"] = Class(bullet)
_editor_class["s3_慧音三符花心_EN"].init = function(self, _x, _y, i, j)
	bullet.init(self, ball_huge, COLOR_DEEP_RED, false, false)
	self.x, self.y = _x, _y
	local a = Angle(self, player)
	self.bound = false
	lasttask = task.New(self, function()
		do
			local a0, _d_a0 = (a), (30)
			for _ = 1, 12 do
				last = New(_editor_class["s3_慧音三符花"], self.x, self.y, a0, j, COLOR_ORANGE, 36, kite)
				_connect(self, last, 0, true)
				task._Wait(0)
				a0 = a0 + _d_a0
			end
		end
	end)
	lasttask = task.New(self, function()
		_set_a(self, 0.04, -45 - 45 * i, false)
		_forbid_v(self, 2, 'original', 'original')
		task._Wait(360)
		_del(self, true)
	end)
end
_editor_class["s3_妹红三符水雾"] = Class(_object)
_editor_class["s3_妹红三符水雾"].init = function(self, _x, _y, b)
	self.x, self.y = _x, _y
	self.img = "image:cloud1a"
	self.layer = LAYER_TOP
	self.group = GROUP_GHOST
	self.hide = false
	self.bound = false
	self.navi = false
	self.hp = 10
	self.maxhp = 10
	self.colli = false
	self._servants = {}
	self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
	self.bound = false
	self.vscale = 0.1
	self.hscale = 0.1
	_object.set_color(self, "mul+add", 50, 25, 25, 255)
	lasttask = task.New(self, function()
		self.colli = false
		lasttask = task.New(self, function()
			do
				local s, _d_s = (0), (4 / 15)
				for _ = 1, 15 do
					self.hscale = s
					self.vscale = s
					task._Wait(1)
					s = s + _d_s
				end
			end
		end)
		lasttask = task.New(self, function()
			do
				local al, _d_al = (20), (20 / 30)
				for _ = 1, 30 do
					_object.set_color(self, "", al, 0, 0, b)
					task._Wait(1)
					al = al + _d_al
				end
			end
			task._Wait(10)
			do
				local al, _d_al = (40), (-40 / 30)
				for _ = 1, 30 do
					_object.set_color(self, "", al, 0, 0, b)
					task._Wait(1)
					al = al + _d_al
				end
			end
			_del(self, true)
		end)
	end)
end
_editor_class["s3_妹红三符水雾"].del = function(self)
end
_editor_class["s3_妹红三符下雨云"] = Class(_object)
_editor_class["s3_妹红三符下雨云"].init = function(self, _x, _y, x, y, t, nandu)
	self.x, self.y = _x, _y
	self.img = "image:cloud2"
	self.layer = LAYER_ENEMY_BULLET + 1
	self.group = GROUP_INDES
	self.hide = false
	self.bound = false
	self.navi = false
	self.hp = 10
	self.maxhp = 10
	self.colli = false
	self._servants = {}
	self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
	lasttask = task.New(self, function()
		task.MoveTo(x, y, 60, MOVE_ACC_DEC)
		do
			for _ = 1, 3 do
				_object.set_color(self, "mul+alpha", 255, 100, 180, 255)
				task._Wait(5)
				_object.set_color(self, "", 100, 100, 180, 255)
				task._Wait(5)
				task._Wait(1)
			end
		end
	end)
	lasttask = task.New(self, function()
		self.bound = false
		self.colli = false
		self.rot = ran:Float(-15, 15)
		lasttask = task.New(self, function()
			do
				local s, _d_s = (0), (0.9 / 90)
				for _ = 1, 90 do
					self.hscale = s
					self.vscale = s
					task._Wait(1)
					s = s + _d_s
				end
			end
			self.colli = true
		end)
		do
			local R, _d_R = (255), (-155 / 90)
			local G, _d_G = (255), (-75 / 90)
			local al, _d_al = (155), (100 / 90)
			for _ = 1, 90 do
				_object.set_color(self, "", al, R, G, 255)
				task._Wait(1)
				R = R + _d_R
				G = G + _d_G
				al = al + _d_al
			end
		end
		task._Wait(10)
		task._Wait(t)
		local cx = self.x + ran:Float(-2, 2)
		local cy = self.y - 50
		do
			local aerfa, _d_aerfa = (50), (80 / (nandu - 1))
			for _ = 1, nandu do
				local x0 = cx + 100 * cos(aerfa)
				local y0 = cy + 70 * sin(aerfa)
				last = New(_editor_class["s3_妹红三符滴弹"], x0, y0, Dist(x0, y0, cx, cy) / 17, aerfa + 180)
				task._Wait(0)
				aerfa = aerfa + _d_aerfa
			end
		end
		lasttask = task.New(self, function()
			task.MoveTo(self.x, self.y + 200, 90, MOVE_ACC_DEC)
		end)
		do
			local a, _d_a = (155), (-1.55)
			local s, _d_s = (0.9), (-0.2 / 100)
			for _ = 1, 101 do
				_object.set_color(self, "", a, 255, 255, 255)
				self.hscale = s
				self.vscale = s
				task._Wait(1)
				a = a + _d_a
				s = s + _d_s
			end
		end
		self.bound = true
	end)
	lasttask = task.New(self, function()
		do
			local beta, _d_beta = (0), (360 / 100)
			for _ = 1, _infinite do
				self.rot = -20 * sin(beta)
				task._Wait(1)
				beta = beta + _d_beta
			end
		end
	end)
end
_editor_class["s3_妹红三符下雨云"].del = function(self)
end
_editor_class["s3_妹红三符滴弹"] = Class(bullet)
_editor_class["s3_妹红三符滴弹"].init = function(self, _x, _y, v, a)
	bullet.init(self, kite, COLOR_BLUE, false, true)
	self.x, self.y = _x, _y
	SetV2(self, v, a, true, false)
	lasttask = task.New(self, function()
		task._Wait(20)
		local dv = ran:Float(0.6, 0.7)
		do
			local vv, _d_vv = (v), (-v * dv / 15)
			for _ = 1, 16 do
				SetV2(self, vv, a, true, false)
				task._Wait(1)
				vv = vv + _d_vv
			end
		end
	end)
end
_editor_class["s3_慧音三符预警"] = Class(laser)
_editor_class["s3_慧音三符预警"].init = function(self, _x, _y, a, c)
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
			local v, _d_v = (0.02), (0.07)
			for _ = 1, 8 do
				last = New(_editor_class["s3_慧音三符预警虚影"], self.x, self.y, self.rot, self.rot + 90, v, c)
				last = New(_editor_class["s3_慧音三符预警虚影"], self.x, self.y, self.rot, self.rot - 90, v, c)
				task._Wait(1)
				v = v + _d_v
			end
		end
		laser._TurnOff(self, 5, false)
		task._Wait(60)
		PlaySound("tan00", 0.1, self.x / 256, false)
		do
			local v, _d_v = (14), (-13.75 / 28)
			local count, _d_count = (1), (1)
			for _ = 1, 29 do
				if (count % 2 == 0) then
					last = New(_editor_class["s3_慧音三符弹幕"], self.x, self.y, ball_mid, COLOR_GRAY, v, a)
				else
					last = New(_editor_class["s3_慧音三符弹幕"], self.x, self.y, square, COLOR_GREEN, v, a)
				end
				task._Wait(3)
				v = v + _d_v
				count = count + _d_count
			end
		end
		task._Wait(60)
		_del(self, true)
	end)
end
_editor_class["s3_慧音三符预警"].kill = function(self)
end
_editor_class["s3_慧音三符预警虚影"] = Class(laser)
_editor_class["s3_慧音三符预警虚影"].init = function(self, _x, _y, a, b, v, c)
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
_editor_class["s3_慧音三符预警虚影"].kill = function(self)
end
_editor_class["s3_慧音三符弹幕"] = Class(bullet)
_editor_class["s3_慧音三符弹幕"].init = function(self, _x, _y, sty, c, v, a)
	bullet.init(self, sty, c, false, false)
	self.x, self.y = _x, _y
	self.bound = false
	self.timer = 11
	SetV2(self, v, a, true, false)
	if (sty == square) then
		local s = 1.8
		self.hscale = s * self.hscale
		self.vscale = 1 * self.vscale
		self.a = s * self.a * 2.5
		self.b = 1 * self.b
	else
	end
	lasttask = task.New(self, function()
		task._Wait(30)
		self.bound = true
		do
			local v1, _d_v1 = (v), (-v / 59)
			for _ = 1, 60 do
				SetV2(self, v1, a, true, false)
				task._Wait(1)
				v1 = v1 + _d_v1
			end
		end
		task._Wait(240)
		_del(self, true)
	end)
end
_editor_class["s3_慧音三符浪花"] = Class(bullet)
_editor_class["s3_慧音三符浪花"].init = function(self, _x, _y, v, a)
	bullet.init(self, water_drop, COLOR_CYAN, false, false)
	self.x, self.y = _x, _y
	self.bound = false
	self.navi = true
	SetV2(self, v, a, true, false)
	_set_a(self, 0.03, 270, false)
	lasttask = task.New(self, function()
		task._Wait(150)
		self.bound = true
	end)
end
_editor_class["s3_慧音三符花心"] = Class(bullet)
_editor_class["s3_慧音三符花心"].init = function(self, _x, _y, i, j)
	bullet.init(self, ball_mid, COLOR_BLUE, false, false)
	self.x, self.y = _x, _y
	local a = Angle(self, player)
	self.bound = false
	lasttask = task.New(self, function()
		do
			local a0, _d_a0 = (a), (30)
			for _ = 1, 12 do
				last = New(_editor_class["s3_慧音三符花"], self.x, self.y, a0, j, COLOR_GREEN, 12, kite)
				_connect(self, last, 0, true)
				task._Wait(0)
				a0 = a0 + _d_a0
			end
		end
		last = New(_editor_class["s3_慧音三符花"], self.x, self.y, a, j, COLOR_CYAN, 24, knife)
		_connect(self, last, 0, true)
	end)
	lasttask = task.New(self, function()
		_set_a(self, 0.04, 90 - 90 * i, false)
		_forbid_v(self, 2, 'original', 'original')
		task._Wait(360)
		_del(self, true)
	end)
end
_editor_class["s3_慧音三符花"] = Class(bullet)
_editor_class["s3_慧音三符花"].init = function(self, _x, _y, a0, i, c, r, sty)
	bullet.init(self, sty, c, false, false)
	self.x, self.y = _x, _y
	self.bound = false
	if (sty == knife) then
		local s = 2.5
		self.hscale = s * self.hscale
		self.vscale = 1 * self.vscale
		self.a = s * self.a * 4.2
		self.b = 1 * self.b
		_object.set_color(self, "", 0, 255, 255, 255)
		lasttask = task.New(self, function()
			do
				local al, _d_al = (0), (255 / 60)
				for _ = 1, 60 do
					_object.set_color(self, "", al, 255, 255, 255)
					task._Wait(1)
					al = al + _d_al
				end
			end
		end)
	end
	lasttask = task.New(self, function()
		do
			--local a, _d_a = (a0), (1 * i)
			local dx, dy = r * cos(a0), r * sin(a0)
			for _ = 1, _infinite do
				_set_rel_pos(self, dx, dy, a0, false)
				--self.rot = a
				task._Wait(1)
				--a = a + _d_a
			end
		end
	end)
	lasttask = task.New(self, function()
		task._Wait(360)
		_del(self, true)
	end)
end
_editor_class["s3_慧音三符纸牌藏刀"] = Class(bullet)
_editor_class["s3_慧音三符纸牌藏刀"].init = function(self, _x, _y, a0, i, t)
	bullet.init(self, square, COLOR_CYAN, false, false)
	self.x, self.y = _x, _y
	self.bound = false
	self.navi = true
	SetV2(self, 1, a0, true, false)
	lasttask = task.New(self, function()
		do
			local aa, _d_aa = (self.rot - 100 * i), (-3 * i)
			for _ = 1, t do
				_set_a(self, 0.2, aa, false)
				task._Wait(1)
				aa = aa + _d_aa
			end
		end
		last = New(_straight, arrow_small, COLOR_CYAN, self.x, self.y, t * 1 / 15, self.rot - 30 * i, false, 0, true, true, 0, false, 0, 0, 0, false)
		_del(self, true)
	end)
end
-- 改的
_editor_class["tool"] = Class(_object)
_editor_class["tool"].init = function(self, _x, _y, _)
	self.x, self.y = _x, _y
	self.img = "img_void"
	self.layer = LAYER_BG
	self.group = GROUP_GHOST
	self.hide = true
	self.bound = false
	self.navi = false
	self.hp = 10
	self.maxhp = 10
	self.colli = true
	self._servants = {}
	self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				if (IsValid(lstg.tmpvar._boss2)) then
					lstg.tmpvar._boss2.x = self.x
					lstg.tmpvar._boss2.y = self.y
				else
					_del(self, true)
				end
				task._Wait(1)
			end
		end
	end)
	lasttask = task.New(self, function()
		task.MoveTo(0, 50, 45, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
		end
		--self._wisys:setAction("cast", 64)
		task._Wait(30)
		do
			task.MoveTo(player.x, 150, 60, MOVE_DECEL)
			last = New(_editor_class["s3_sc3_A1_1"], self.x, self.y, -90)
			task._Wait(60)
			local _a
			do
				local x, _d_x = (0), (90 / 29)
				local t, _d_t = (1), (1)
				for _ = 1, 30 do
					do
						local u, _d_u = (-1), (2)
						for _ = 1, 2 do
							last = New(_straight, water_drop, COLOR_BLUE, self.x - 30 * u, self.y, 6, 90 + ran:Float(0, 15) * u, false, 0, true, true, 0, false, 0, 0, 0, false)
							u = u + _d_u
						end
					end
					if (t % 4 == 0) then
						do
							local dv, _d_dv = (0), (0.5)
							for _ = 1, 6 do
								do
									local u, _d_u = (-1), (2)
									for _ = 1, 2 do
										last = New(_straight, knife, COLOR_BLUE, self.x - 30 * u, 150 - 13.3 * t, 0.5, 90 + 90 * u, false, 0, true, true, 0, false, 0, 0, 0, false)
										AddSimStrChV(last, 0, 1 + dv, 90 + 90 * u, 120, nil, nil, 120)
										u = u + _d_u
									end
								end
								dv = dv + _d_dv
							end
						end
					else
					end
					if (t % 6 == 0) then
						if player.x <= self.x then
							_a = 0
						else
							_a = 180
						end
						PlaySound("kira00", 0.1, 0, false)
						do
							local u, _d_u = (-1), (2)
							for _ = 1, 2 do
								last = New(_editor_class["s3_sc3_A1_2"], self.x, self.y, 3, _a + 45 * u)
								u = u + _d_u
							end
						end
					else
					end
					last = New(_editor_class["s3_huanying"], self.x, self.y, lstg.tmpvar._boss2)
					self.y = 150 - 400 * sin(x)
					task._Wait(1)
					x = x + _d_x
					t = t + _d_t
				end
			end
			self.y = 250
			task._Wait(120)
			task.MoveTo(self.x, 50, 60, MOVE_DECEL)
		end
		task._Wait(90)
		do
			for _ = 1, _infinite do
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
					task._Wait(60)
				end
				do
					task.MoveTo(player.x, 150, 60, MOVE_DECEL)
					last = New(_editor_class["s3_sc3_A1_1"], self.x, self.y, -90)
					task._Wait(60)
					local _a
					do
						local x, _d_x = (0), (90 / 29)
						local t, _d_t = (1), (1)
						for _ = 1, 30 do
							do
								local u, _d_u = (-1), (2)
								for _ = 1, 2 do
									last = New(_straight, water_drop, COLOR_BLUE, self.x - 30 * u, self.y, 6, 90 + ran:Float(0, 15) * u, false, 0, true, true, 0, false, 0, 0, 0, false)
									u = u + _d_u
								end
							end
							if (t % 4 == 0) then
								do
									local dv, _d_dv = (0), (0.5)
									for _ = 1, 6 do
										do
											local u, _d_u = (-1), (2)
											for _ = 1, 2 do
												last = New(_straight, knife, COLOR_BLUE, self.x - 30 * u, 150 - 13.3 * t, 0.5, 90 + 90 * u, false, 0, true, true, 0, false, 0, 0, 0, false)
												AddSimStrChV(last, 0, 1 + dv, 90 + 90 * u, 120, nil, nil, 120)
												u = u + _d_u
											end
										end
										dv = dv + _d_dv
									end
								end
							else
							end
							if (t % 6 == 0) then
								if player.x <= self.x then
									_a = 0
								else
									_a = 180
								end
								PlaySound("kira00", 0.1, 0, false)
								do
									local u, _d_u = (-1), (2)
									for _ = 1, 2 do
										last = New(_editor_class["s3_sc3_A1_2"], self.x, self.y, 3, _a + 45 * u)
										u = u + _d_u
									end
								end
							else
							end
							for _, unit in ObjList(GROUP_INDES) do
								if (unit.flag == 1 and Dist(self, unit) <= 50) then
									_del(unit, true)
								else
								end
							end
							for _, unit in ObjList(GROUP_ENEMY_BULLET) do
								if (unit.flag == 1 and Dist(self, unit) <= 50) then
									_del(unit, true)
								else
								end
							end
							last = New(_editor_class["s3_huanying"], self.x, self.y, lstg.tmpvar._boss2.img)
							self.y = 150 - 400 * sin(x)
							task._Wait(1)
							x = x + _d_x
							t = t + _d_t
						end
					end
					task._Wait(120)
					self.y = 250
					task.MoveTo(self.x, 50, 60, MOVE_DECEL)
				end
				task._Wait(240)
				task._Wait(0)
			end
		end
	end)
end
_editor_class["s3_huanying"] = Class(_object)
_editor_class["s3_huanying"].init = function(self, _x, _y, mst)
	self.x, self.y = _x, _y
	self.img = "img_void"
	self.layer = LAYER_ENEMY - 1
	self.group = GROUP_GHOST
	self.hide = false
	self.bound = false
	self.navi = false
	self.hp = 10
	self.maxhp = 10
	self.colli = true
	self._servants = {}
	self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
	self.img = mst.img
	lasttask = task.New(self, function()
		do
			local x, _d_x = (0), (90 / 19)
			for _ = 1, 20 do
				_object.set_color(self, "", 200 * cos(x), 255, 255, 255)
				task._Wait(1)
				x = x + _d_x
			end
		end
		_del(self, false)
	end)
end
_editor_class["s3_sc3_A2_1"] = Class(bullet)
_editor_class["s3_sc3_A2_1"].init = function(self, _x, _y, u)
	bullet.init(self, ball_mid, COLOR_BLUE, false, false)
	self.x, self.y = _x, _y
	local a = Angle(self, player)
	self.bound = false
	do
		local a0, _d_a0 = (a), (24)
		for _ = 1, 15 do
			last = New(_editor_class["s3_sc3_A2_2"], self.x, self.y, a0, 1, COLOR_GREEN, 12)
			_connect(self, last, 0, true)
			a0 = a0 + _d_a0
		end
	end
	do
		local a0, _d_a0 = (a), (18)
		for _ = 1, 20 do
			last = New(_editor_class["s3_sc3_A2_2"], self.x, self.y, a0, -1, COLOR_CYAN, 20)
			_connect(self, last, 0, true)
			a0 = a0 + _d_a0
		end
	end
	lasttask = task.New(self, function()
		task.MoveTo(0, 200, 60, MOVE_DECEL)
		task._Wait(20)
		do
			local t, _d_t = (60), (3)
			local len, _d_len = (0), (165 / 19 * u)
			for _ = 1, 20 do
				last = New(_editor_class["s3_sc3_A2_3"], self.x, self.y + 15, -90, len)
				last = New(_editor_class["s3_sc3_A2_3"], self.x, self.y - 15, -90, len)
				t = t + _d_t
				len = len + _d_len
			end
		end
		last = New(_editor_class["s3_sc3_A2_1_eff"], 0, 200, _)
		task.MoveTo(185 * u, 200, 60, MOVE_DECEL)
		local a = -90
		local frame = 6
		if (difficulty == 4) then
			lasttask = task.New(self, function()
				frame = 5
				task._Wait(180)
				frame = 4
				task._Wait(120)
				frame = 3
				_set_g(self, 0.01)
				_forbid_v(self, 0.5, 'original', 'original')
				task._Wait(300)
				_forbid_v(self, 10, 'original', 'original')
			end)
		else
			lasttask = task.New(self, function()
				frame = 6
				task._Wait(180)
				frame = 5
				task._Wait(120)
				_set_g(self, 0.01)
				_forbid_v(self, 0.5, 'original', 'original')
				task._Wait(300)
				_forbid_v(self, 10, 'original', 'original')
			end)
		end
		local t = 0
		local x
		do
			for _ = 1, _infinite do
				x = ran:Float(0, 185) * u
				if (not (t >= 360 and IsValid(lstg.tmpvar._boss2) and abs(lstg.tmpvar._boss2.x - x) <= 40)) then
					a = -90 + 0.1 * (Angle(self, player) + 90) + ran:Float(-10, 10)
					last = New(_straight, drop, COLOR_BLUE, x, self.y, 0, a, false, 0, true, true, 0, false, 0, 0, 0, false)
					last.flag = 1
					last.navi = true
					AddSimStrChV(last, 2, 0.5, a, 30)
					AddSimStrChV(last, 0, 4, -90, 240, nil, nil, 75)
				else
				end
				task._Wait(frame)
				t = t + frame
			end
		end
	end)
end
_editor_class["s3_sc3_A2_2"] = Class(bullet)
_editor_class["s3_sc3_A2_2"].init = function(self, _x, _y, a0, i, c, r)
	bullet.init(self, arrow_big, c, false, false)
	self.x, self.y = _x, _y
	lasttask = task.New(self, function()
		do
			--local a, _d_a = (a0), (1 * i)
			local dx, dy = r * cos(a0), r * sin(a0)
			for _ = 1, _infinite do
				_set_rel_pos(self, dx, dy, a0, false)
				--self.rot = a
				task.Wait(1)
				--a = a + _d_a
			end
		end
	end)
end
_editor_class["s3_sc3_A2_3"] = Class(bullet)
_editor_class["s3_sc3_A2_3"].init = function(self, _x, _y, a, len)
	bullet.init(self, square, COLOR_CYAN, true, false)
	self.x, self.y = _x, _y
	self.flag = 1
	SetV2(self, 0, a, true, false)
	lasttask = task.New(self, function()
		self.layer = LAYER_ENEMY_BULLET - 1
		task.MoveTo(self.x + len, self.y, 60, MOVE_DECEL)
		task._Wait(300)
		_set_g(self, 0.01)
		_forbid_v(self, 0.5, 'original', 'original')
		task._Wait(300)
		_forbid_v(self, 10, 'original', 'original')
	end)
end
_editor_class["s3_sc3_A2_1_eff"] = Class(bullet)
_editor_class["s3_sc3_A2_1_eff"].init = function(self, _x, _y, _)
	bullet.init(self, laserbullet, COLOR_BLUE, true, true)
	self.x, self.y = _x, _y
	self.colli = false
	self.hscale, self.vscale = 0, 1
	self.group = GROUP_GHOST
	_object.set_color(self, "", 100, 0, 0, 255)
	lasttask = task.New(self, function()
		self.layer = LAYER_ENEMY_BULLET + 1
		do
			local x, _d_x = (0), (90 / 39)
			for _ = 1, 40 do
				_object.set_color(self, "", 100 * cos(x), 0, 0, 255)
				self.hscale, self.vscale = 0 + 30 * sin(x), 1 + 50 * sin(x)
				task._Wait(1)
				x = x + _d_x
			end
		end
		_del(self, false)
	end)
end
_editor_class["s3_sc3_A1_1"] = Class(laser)
_editor_class["s3_sc3_A1_1"].init = function(self, _x, _y, a)
	laser.init(self, COLOR_RED, _x, _y, 0, 0, 0, 0, 15, 20, 0)
	lasttask = task.New(self, function()
		laser.ChangeImage(self, 2)
		_object.set_color(self, "mul+add", 255, 255, 255, 255)
		laser._TurnHalfOn(self, 1, false)
		self.rot = a
		do
			local aerfa, _d_aerfa = (0), (90 / 4)
			for _ = 1, 5 do
				self.l2 = 750 * sin(aerfa)
				task._Wait(1)
				aerfa = aerfa + _d_aerfa
			end
		end
		do
			local v, _d_v = (0.25), (0.5)
			for _ = 1, 5 do
				last = New(_editor_class["s3_妹红激光预警虚影"], self.x, self.y, a, a + 90, v)
				last = New(_editor_class["s3_妹红激光预警虚影"], self.x, self.y, a, a - 90, v)
				task._Wait(0)
				v = v + _d_v
			end
		end
		task._Wait(15)
		do
			local v, _d_v = (0.25), (0.5)
			for _ = 1, 5 do
				last = New(_editor_class["s3_妹红激光预警虚影"], self.x, self.y, a, a + 90, v)
				last = New(_editor_class["s3_妹红激光预警虚影"], self.x, self.y, a, a - 90, v)
				task._Wait(0)
				v = v + _d_v
			end
		end
		task._Wait(15)
		laser._TurnOff(self, 20, true)
		task._Wait(20)
		laser._TurnOn(self, 10, false, true)
		laser._TurnOff(self, 50, true)
		_del(self, true)
	end)
end
_editor_class["s3_sc3_A1_1"].kill = function(self)
end
_editor_class["s3_sc3_A1_2"] = Class(bullet)
_editor_class["s3_sc3_A1_2"].init = function(self, _x, _y, v, a)
	bullet.init(self, ball_light, 1, true, false)
	self.x, self.y = _x, _y
	self.hscale, self.vscale = 0.3, 0.15
	SetV2(self, v, a, true, false)
	self.bound = false
	--[[ 新增加拖影 --]]--[=[
    --]=]
	self._trail = nil
	self._trail_off = 0 --手动调控开关拖影（有渐变动画），0为开，1为关
	self._trail_num = 1
	self.max_trail_num = 20
	self._trail = {}
	self._trail[1] = {}
	self._trail[1]["img"] = self.img
	self._trail[1]["x"] = self.x
	self._trail[1]["y"] = self.y
	self._trail[1]["rot"] = self.rot
	lasttask = task.New(self, function()
		task._Wait(300)
		self.bound = true
	end)
	lasttask = task.New(self, function()
		local a0 = a
		local dp = 0.00225
		local p_max = 0.1
		self.navi = true
		local p = 0
		task._Wait(30)
		do
			local x, _d_x = (0), (1 / 89)
			local t, _d_t = (1), (1)
			for _ = 1, 90 do
				if t <= 50 then
					local _aa = (Angle(self, player) - a0) % 360
					if _aa > 180 then
						_aa = _aa - 360
					end
					a0 = a0 + _aa * p
				end
				p = min(p + dp, p_max)
				SetV2(self, v + 9 * x, a0, true, false)
				task._Wait(1)
				x = x + _d_x
				t = t + _d_t
			end
		end
	end)
	lasttask = task.New(self, function()
		local _a = self.a * 0.25
		local _b = self.b * 0.25
		do
			local x, _d_x = (0), (1 / 19)
			for _ = 1, 20 do
				self.hscale = 0.3 + (0.8 - 0.3) * x
				self.vscale = 0.15 + (0.5 - 0.15) * x
				self.a = self.hscale * _a
				self.b = self.vscale * _b
				task._Wait(1)
				x = x + _d_x
			end
		end
	end)
end
_editor_class["s3_sc3_A1_2"].frame = function(self)
	self.class.base.frame(self)

	self._trail[self.max_trail_num - self._trail_num] = {}
	self._trail[self.max_trail_num - self._trail_num]["img"] = self.img
	self._trail[self.max_trail_num - self._trail_num]["x"] = self.x
	self._trail[self.max_trail_num - self._trail_num]["y"] = self.y
	self._trail[self.max_trail_num - self._trail_num]["rot"] = self.rot --记录每帧自己贴图的状态

	for i = 1, self.max_trail_num do
		if i > self._trail_num then
			self._trail[self.max_trail_num - i + 1] = { img = self.img, x = self.x, y = self.y, rot = self.rot }
		else
			self._trail[self.max_trail_num - i + 1] = self._trail[self.max_trail_num - i]
		end
	end
	if self._trail_off == 1 then
		--拖影消失动画
		self._trail_num = max(self._trail_num - 1, 0)
	elseif self._trail_off == 0 then
		self._trail_num = min(self._trail_num + 1, self.max_trail_num - 1)
	end
end
_editor_class["s3_sc3_A1_2"].render = function(self)
	self.class.base.render(self)

	local d = self.max_trail_num - self._trail_num + 2
	local al = 1
	for i = d, self.max_trail_num do
		local t = self._trail[i]
		al = al - 1 / (self.max_trail_num - d + 1)
		SetImageState(t["img"], "mul+add", Color(150 * al, 255, 255, 255))
		Render(t["img"], t["x"], t["y"], t["rot"], self.hscale, self.vscale)
	end
end

--endregion
