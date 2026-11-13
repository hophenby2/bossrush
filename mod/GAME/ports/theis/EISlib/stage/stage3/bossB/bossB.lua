s3B_boss = {}

local path = "EISlib/stage/stage3/bossB/"
Include(path .. "Reimu_boss.lua")
Include(path .. "Yukari_boss.lua")
Include(path .. "bossB_mid.lua")
Include(path .. "bossB_main.lua")
Include(path .. "bossB_ls.lua")

--region 弹幕组件

_editor_class["s3_B1_no1_1"] = Class(bullet)
_editor_class["s3_B1_no1_1"].init = function(self, _x, _y, v, a, dt, v2)
	bullet.init(self, ball_mid, COLOR_GRAY, true, true)
	_object.set_color(self, "", 255, 255, 255, 255)
	self.x, self.y = _x, _y
	self.bound = false
	lasttask = task.New(self, function()
		AddSimStrChV(self, v, 0, a, 50)
		task._Wait(50)
		ChangeBulletImage(self, square, COLOR_GRAY)
		PlaySound("kira00", 0.1, 0, false)
		self.rot = a
		task._Wait(15 + dt)
		ChangeBulletImage(self, ball_mid, COLOR_RED)
		PlaySound("kira00", 0.1, 0, false)
		AddSimStrChV(self, -0.5 + v2, 0, a, 30)
		task._Wait(30)
		ChangeBulletImage(self, square, COLOR_DEEP_RED)
		PlaySound("kira00", 0.1, 0, false)
		AddSimStrChV(self, v2 - 1, v2, a + 180, 20)
		task._Wait(120)
		self.bound = true
	end)
end

--拖影特效
local trail2 = Class(object)
function trail2:init(master, maxnum, frame, img, size, blend, times, _a_rate, Isdsize)
	self.layer = master.layer
	self.bound = false
	self.master = master
	self.alpha = 80
	self.img = img
	self.size = size or 1
	self.trail = {} --拖影表
	self.max = maxnum or 10
	self.frame = frame or 3
	self.co = {255, 255, 255} --留一个可以外部操作的接口co
	self.blend = blend or "mul+alpha"
	self.times = times or 99999
	self._a_rate = _a_rate or 1
	self.Isdsize = Isdsize
end
function trail2:frame()
	if IsValid(self.master) then
		self.x, self.y = self.master.x, self.master.y
	end
	if self.frame == 1 or self.timer%self.frame == 1  then
		if IsValid(self.master) and self.timer < self.times then
			local master = self.master
			table.insert(self.trail, 1, {master.x, master.y, master.rot, master.hscale*self.size, master.vscale*self.size}) --更新主人当前图像状态
			if #self.trail > self.max then table.remove(self.trail) end
		else--即便主人不存在了，拖影也会保留一段时间渐渐消失
			if #self.trail == 0 then
				Del(self)
			else
				table.remove(self.trail)
			end
		end
	end
end
function trail2:render()
	local co = self.co
	local size = 1
	local dsize
	if self.Isdsize then
		dsize = 0.5/self.max
	else
		dsize = 0
	end
	if IsValid(self.master) then
		self.alpha = 255*self._a_rate
	end
	local alpha, d, n = 0.2*self.alpha, 0.8*self.alpha/self.max, #self.trail
	for i = n, 1, -1 do
		local obj = self.trail[i]
		SetImgState(self, self.blend, alpha, co[1], co[2], co[3])
		Render(self.img, obj[1], obj[2], obj[3], obj[4]*size, obj[5]*size)
		alpha = alpha + d
		--alpha = 255
		size = size + dsize
	end
	SetImgState(self, "", 255, 255, 255, 255) -- 记得恢复渲染状态
end

_editor_class["s3_灵梦一非追踪札"] = Class(bullet)
_editor_class["s3_灵梦一非追踪札"].init = function(self, _x, _y, angle, v, c)
	bullet.init(self, square, c, false, false)
	self.x, self.y = _x, _y
	PlaySound("kira00", 0.1, 0, false)
	_object.set_color(self, "mul+add", 255, 255, 255, 255)
	self.navi = true
	self.rect = true
	self.vscale = 0
	self.hscale = 0
	self.a = 0
	self.b = 0
	New(trail2, self, 10, 1, self.img, 0.75, "mul+add", 9999, 0.25, true)
	SetV2(self, 0, angle, true, false)
	lasttask = task.New(self, function()
		do
			local s, _d_s = (0), (3 / 15)
			for _ = 1, 15 do
				self.hscale, self.vscale = s, s
				self.a, self.b = 4 * self.hscale, 2 * self.vscale
				task._Wait(1)
				s = s + _d_s
			end
		end
	end)
	lasttask = task.New(self, function()
		if (difficulty == 4) then
			do
				for _ = 1, 120 do
					_set_a(self, 0.15, Angle(self, player), false)
					task._Wait(1)
				end
			end
			task._Wait(60)
			self.bound = true
		elseif (difficulty == 3) then
			do
				for _ = 1, 120 do
					_set_a(self, 0.125, Angle(self, player), false)
					task._Wait(1)
				end
			end
			task._Wait(60)
			self.bound = true
		elseif (difficulty == 2) then
			do
				for _ = 1, 120 do
					_set_a(self, 0.1, Angle(self, player), false)
					task._Wait(1)
				end
			end
			task._Wait(60)
			self.bound = true
		else
			do
				for _ = 1, 120 do
					_set_a(self, 0.08, Angle(self, player), false)
					task._Wait(1)
				end
			end
			task._Wait(60)
			self.bound = true
		end
	end)
	lasttask = task.New(self, function()
		do
			local aerfa, _d_aerfa = (-90), (360 / 30)
			for _ = 1, 30 do
				SetV2(self, v + v * 0.8 * sin(aerfa), angle, true, false)
				task._Wait(1)
				aerfa = aerfa + _d_aerfa
			end
		end
	end)
end
_editor_class["s3_灵梦一非札弹"] = Class(bullet)
_editor_class["s3_灵梦一非札弹"].init = function(self, _x, _y, v, a, sty, c)
	bullet.init(self, sty, c, false, true)
    _object.set_color(self, "", 255, 255, 255, 255)
	self.x, self.y = _x, _y
	if (sty == square) then
		SetV2(self, v, a, true, false)
		lasttask = task.New(self, function()
			do
				local v1, _d_v1 = (v), (-0.8 * v / 60)
				for _ = 1, 60 do
					SetV2(self, v1, a, true, false)
					task._Wait(1)
					v1 = v1 + _d_v1
				end
			end
		end)
	else
	end
	if (sty == arrow_small) then
		SetV2(self, 0, a, true, false)
		lasttask = task.New(self, function()
			do
				local v1, _d_v1 = (0), (0.6 * v / 60)
				for _ = 1, 60 do
					SetV2(self, v1, a, true, false)
					task._Wait(1)
					v1 = v1 + _d_v1
				end
			end
		end)
	else
	end
end
_editor_class["s3_灵梦一符札弹EN"] = Class(bullet)
_editor_class["s3_灵梦一符札弹EN"].init = function(self, _x, _y, v, a)
	bullet.init(self, square, COLOR_PURPLE, true, true)
    _object.set_color(self, "", 255, 255, 255, 255)
	self.x, self.y = _x, _y
	SetV2(self, 0.05, a, true, false)
	lasttask = task.New(self, function()
		task._Wait(30)
		do
			local v1, _d_v1 = (0), (v / 60)
			for _ = 1, 60 do
				SetV2(self, v1, a, true, false)
				task._Wait(1)
				v1 = v1 + _d_v1
			end
		end
	end)
end

_editor_class["s3_灵梦一符札弹"] = Class(bullet)
_editor_class["s3_灵梦一符札弹"].init = function(self, _x, _y, v, a, c)
	bullet.init(self, square, c, false, true)
    _object.set_color(self, "", 255, 255, 255, 255)
    self.rot = a
	self.x, self.y = _x, _y
	egg.AddSimStrChV(self, 0, v, a, 60)
end
_editor_class["s3_紫一符青山"] = Class(bullet)
_editor_class["s3_紫一符青山"].init = function(self, _x, _y, v, a, co)
	bullet.init(self, arrow_small, co, false, true)
    _object.set_color(self, "", 255, 255, 255, 255)
    self.rot = a
	self.x, self.y = _x, _y
	egg.AddSimStrChV(self, 0, v, a, 60)
end
_editor_class["s3_紫一符镭射"] = Class(laser)
_editor_class["s3_紫一符镭射"].init = function(self, _x, _y, angle, da, t, u)
	laser.init(self, COLOR_PURPLE, _x, _y, 0, 56, 255, 256, 8, 0, 0)
    _object.set_color(self, "mul+add", 255, 255, 255, 255)
	lasttask = task.New(self, function()
		laser.ChangeImage(self, 2)
		laser._TurnHalfOn(self, 30, false)
		lasttask = task.New(self, function()
			task._Wait(90)
			task._Wait(t)
			last = New(_editor_class["s3_紫三符射线"], self.x, self.y, 12, angle - da * u)
			last = New(_editor_class["s3_紫三符射线2"], self.x, self.y, 12, angle - da * u)
			task._Wait(60)
			PlaySound("lazer00", 1, 0, false)
			do
				local x, _d_x = (0), (1 / 19)
				for _ = 1, 20 do
					_object.set_color(self, "", 255 * (1 - x), 255, 255, 255)
					self.w = 8 + 8 * x
					task._Wait(1)
					x = x + _d_x
				end
			end
			_del(self, true)
		end)
		do
			local x, _d_x = (0), (90 / 89)
			for _ = 1, 90 do
				self.rot = angle + (180 * u - da * cos(x) * u) * cos(x)
				task._Wait(1)
				x = x + _d_x
			end
		end
		do
			local x, _d_x = (0), (90 / 59)
			for _ = 1, 60 do
				self.rot = angle - da * u * sin(x)
				task._Wait(1)
				x = x + _d_x
			end
		end
	end)
end

_editor_class["s3_B1_no2_1"] = Class(bullet)
_editor_class["s3_B1_no2_1"].init = function(self, _x, _y, v, a, dt, v2, da, u)
	bullet.init(self, ball_mid, COLOR_GRAY, true, true)
	_object.set_color(self, "", 255, 255, 255, 255)
	self.x, self.y = _x, _y
	self.bound = false
	lasttask = task.New(self, function()
		SetV(self, v, a)
		task.Wait(30)
		AddSimStrChV(self, 0, -v, a, 20)
		task.Wait(30)
		ChangeBulletImage(self, square, COLOR_GRAY)
		self.rot = a
		task._Wait(15 + dt)
		ChangeBulletImage(self, ball_mid, COLOR_RED)
		PlaySound("kira00", 0.1, 0, false)
		SetV(self, 0.75 * v2, a + 90 * u)
		task.Wait(27)
		AddSimStrChV(self, 0, -0.75 * v2, a + 90 * u, 27)
		task._Wait(20)
		ChangeBulletImage(self, ball_mid, COLOR_GRAY)
		task._Wait(20)
		ChangeBulletImage(self, square, COLOR_DEEP_RED)
		self.rot = a + da * u
		PlaySound("kira00", 0.1, 0, false)
		AddSimStrChV(self, 1, 0, a + da * u, 20)
		AddSimStrChV(self, 0, 1, a + da * u, 20, nil, nil, 40)
		task._Wait(40)
		self.navi = true
		task._Wait(20)
		if (difficulty == 4) then
			AddSimStrChV(self, 0, 2, a + da * u, 40)
		elseif (difficulty == 3) then
			AddSimStrChV(self, 0, 1.5, a + da * u, 40)
		elseif (difficulty == 2) then
			AddSimStrChV(self, 0, 1, a + da * u, 40)
		else
			AddSimStrChV(self, 0, 0.5, a + da * u, 40)
		end
		task._Wait(120)
		self.bound = true
	end)
end
_editor_class["s3_紫二非黑死蝶"] = Class(bullet)
_editor_class["s3_紫二非黑死蝶"].init = function(self, _x, _y, v, angle, color)
	bullet.init(self, butterfly, color, false, false)
	self.x, self.y = _x, _y
	self.navi = true
	lasttask = task.New(self, function()
		SetV2(self, v, angle, true, false)
		_set_a(self, 0.05, angle + 180, false)
		task._Wait(20)
		_set_a(self, 0.01, angle + 180 + ran:Float(-25, 25), false)
		_forbid_v(self, 4, 'original', 'original')
	end)
end

_editor_class["s3_灵梦二符包围使魔"] = Class(_object)
_editor_class["s3_灵梦二符包围使魔"].init = function(self, _x, _y, a0, i, rr, cx, cy, s)
	self.x, self.y = _x, _y
	self.img = "magic1"
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
	self.omiga = 4 * i
	self.bound = false
	self.hscale = s
	self.vscale = s
	_object.set_color(self, "mul+add", 0, 255, 0, 0)
	lasttask = task.New(self, function()
		do
			local al, _d_al = (0), (250 / 14)
			for _ = 1, 15 do
				_object.set_color(self, "mul+add", al, 255, 0, 0)
				task._Wait(1)
				al = al + _d_al
			end
		end
		task._Wait(120)
		if (difficulty == 4) then
			lasttask = task.New(self, _editor_tasks["lizi_正方形发弹"](square, COLOR_RED, Angle(cx, cy, self.x, self.y), 9))
		elseif (difficulty == 3) then
			lasttask = task.New(self, _editor_tasks["lizi_正方形发弹"](square, COLOR_RED, Angle(cx, cy, self.x, self.y), 9))
		elseif (difficulty == 2) then
			lasttask = task.New(self, _editor_tasks["lizi_正方形发弹"](square, COLOR_RED, Angle(cx, cy, self.x, self.y), 8))
		else
			lasttask = task.New(self, _editor_tasks["lizi_正方形发弹"](square, COLOR_RED, Angle(cx, cy, self.x, self.y), 6))
		end
		_del(self, true)
	end)
	lasttask = task.New(self, function()
		do
			local aerfa, _d_aerfa = (0), (90 / 59)
			local a, _d_a = (a0), (2.6 * i)
			for _ = 1, 60 do
				local r = rr * sin(aerfa)
				self.x = cx + r * cos(a)
				self.y = cy + r * sin(a)
				task._Wait(1)
				aerfa = aerfa + _d_aerfa
				a = a + _d_a
			end
		end
		do
			local a, _d_a = (a0 + 1.3 * 120 * i), (0.43 * i)
			for _ = 1, _infinite do
				self.x = cx + rr * cos(a)
				self.y = cy + rr * sin(a)
				if (self.timer % 6 == 0) then
					last = New(_straight, square, COLOR_GRAY, self.x, self.y, 5, a + 140, false, 0, false, true, 0, false, 0, 0, 0, false)
					last = New(_straight, square, COLOR_GRAY, self.x, self.y, 5, a - 140, false, 0, false, true, 0, false, 0, 0, 0, false)
				else
				end
				task._Wait(1)
				a = a + _d_a
			end
		end
	end)
end
_editor_tasks["lizi_正方形发弹"] = function(sty, c, a0, n)
	return function()
		local self = task.GetSelf()
		do
			local a, _d_a = (a0), (90)
			for _ = 1, 4 do
				local x0, y0 = self.x + 50 * sqrt(2) * cos(a - 45), self.y + 50 * sqrt(2) * sin(a - 45)
				do
					local l, _d_l = (0), (100 / (n - 1))
					for _ = 1, n do
						local x1, y1 = x0 + l * cos(a + 90), y0 + l * sin(a + 90)
						--stg.newBulletStraight(sty)
						last = New(_straight, sty, c, self.x, self.y, 0, Angle(self.x, self.y, x1, y1), false, 0, true, true, 0, false, Dist(self.x, self.y, x1, y1) / 3000, Angle(self.x, self.y, x1, y1), Dist(self.x, self.y, x1, y1) / 90, false)
                        _object.set_color(last, "", 255, 255, 255, 255)
						task._Wait(0)
						l = l + _d_l
					end
				end
				task._Wait(0)
				a = a + _d_a
			end
		end
	end
end
_editor_class["s3_紫二符激光预警"] = Class(laser)
_editor_class["s3_紫二符激光预警"].init = function(self, _x, _y, a)
	laser.init(self, COLOR_BLUE, _x, _y, 0, 0, 0, 0, 2, 8, 0)
	laser.ChangeImage(self, 4)
	self.bound = false
	_object.set_color(self, "mul+add", 255, 0, 170, 255)
	self.w = 2
	lasttask = task.New(self, function()
		laser._TurnHalfOn(self, 1, false)
		self.w = 2
		local da = ran:Float(-0.5, 0.5)
		lasttask = task.New(self, function()
			task.MoveTo(400 * cos(a), 400 * sin(a), 30, MOVE_DECEL)
			PlaySound("ch00", 1.0, self.x / 256, false)
		end)
		do
			local aerfa, _d_aerfa = (0), (1)
			local aa, _d_aa = (a + 180), (da)
			for _ = 1, 90 do
				self.l2 = 1750 * sin(aerfa)
				self.rot = aa
				task._Wait(1)
				aerfa = aerfa + _d_aerfa
				aa = aa + _d_aa
			end
		end
		task._Wait(30)
		lasttask = task.New(self, function()
			PlaySound("lazer00", 0.5, 0, false)
			do
				local x, _d_x = (0), (180 / 29)
				for _ = 1, 30 do
					self.w = 4 * sin(x)
					task._Wait(1)
					x = x + _d_x
				end
			end
		end)
		local rot_x, rot_y = cos(self.rot), sin(self.rot)
		do
			local r, _d_r = (60), (-2)
			local v, _d_v = (8), (0.5)
			for _ = 1, 30 do
				last = New(_editor_class["s3_紫二符链弹"], self.x + r * rot_x, self.y + r * rot_y, v, self.rot)
				task._Wait(1)
				r = r + _d_r
				v = v + _d_v
			end
		end
		_del(self, true)
	end)
end
_editor_class["s3_紫二符激光预警"].kill = function(self)
end
_editor_class["s3_紫二符链弹"] = Class(bullet)
_editor_class["s3_紫二符链弹"].init = function(self, _x, _y, v, a)
	bullet.init(self, arrow_small, COLOR_PURPLE, true, true)
	self.x, self.y = _x, _y
	_object.set_color(self, "mul+add", 255, 255, 255, 255)
	self.bound = false
	SetV2(self, v, a, true, false)
	lasttask = task.New(self, function()
		task._Wait(90)
		self.bound = true
	end)
end
_editor_class["s3_紫二符激光"] = Class(laser)
_editor_class["s3_紫二符激光"].init = function(self, _x, _y, a)
	laser.init(self, COLOR_BLUE, _x, _y, 0, 0, 0, 0, 2, 0, 0)
	laser.ChangeImage(self, 4)
	self.bound = false
	_object.set_color(self, "mul+add", 255, 0, 170, 255)
	lasttask = task.New(self, function()
		do
			local aerfa, _d_aerfa = (0), (90 / 15)
			for _ = 1, 15 do
				self.l1 = 125 * sin(aerfa)
				self.l2 = 250 * sin(aerfa)
				self.l3 = 125 * sin(aerfa)
				task._Wait(1)
				aerfa = aerfa + _d_aerfa
			end
		end
	end)
	lasttask = task.New(self, function()
		PlaySound("kira00", 0.1, 0, false)
		SetV2(self, 0, a, true, false)
		laser._TurnOn(self, 1, true, false)
		lasttask = task.New(self, function()
			do
				local w, _d_w = (2), (5 / 30)
				for _ = 1, 30 do
					self.w = w
					task._Wait(1)
					w = w + _d_w
				end
			end
		end)
		task._Wait(5)
		do
			local v, _d_v = (0), (20 / 7)
			for _ = 1, 7 do
				SetV2(self, v, a, true, false)
				task._Wait(1)
				v = v + _d_v
			end
		end
		task._Wait(60)
		self.bound = true
	end)
end

_editor_class["s3_B1_no3_1"] = Class(bullet)
_editor_class["s3_B1_no3_1"].init = function(self, _x, _y, v, a, dt, v2, da, u)
	bullet.init(self, ball_mid, COLOR_GRAY, true, true)
	self.x, self.y = _x, _y
	self.bound = false
	lasttask = task.New(self, function()
		self.layer = LAYER_ENEMY_BULLET - 2
		SetV(self, v, a)
		task.Wait(10)
		AddSimStrChV(self, 0, -v, a, 20)
		task.Wait(20)
		ChangeBulletImage(self, square, COLOR_GRAY)
		self.rot = a
		self.layer = LAYER_ENEMY_BULLET - 2
		task._Wait(15 + dt)
		ChangeBulletImage(self, ball_mid, COLOR_RED)
		self.layer = LAYER_ENEMY_BULLET - 2
		PlaySound("kira00", 0.1, 0, false)
		AddSimStrChV(self, 4, 0, a, 30)
		task._Wait(20)
		ChangeBulletImage(self, ball_mid, COLOR_GRAY)
		self.layer = LAYER_ENEMY_BULLET - 2
		task._Wait(20)
		ChangeBulletImage(self, square, COLOR_DEEP_RED)
		self.navi = true
		self.layer = LAYER_ENEMY_BULLET - 2
		PlaySound("kira00", 0.1, 0, false)
		AddSimStrChV(self, v2, 0, a, 20)
		AddSimStrChV(self, 0, v2, a + da, 10)
		AddSimStrChV(self, 0, -v2, a + da, 10, nil, nil, 10)
		task._Wait(20)
		self.navi = false
		ChangeBulletImage(self, square, COLOR_GRAY)
		self.rot = a + da
		task._Wait(20)
		self.navi = true
		AddSimStrChV(self, 0, v2, a + da, 60)
		ChangeBulletImage(self, square, COLOR_DEEP_RED)
		self.layer = LAYER_ENEMY_BULLET - 2
		task._Wait(120)
		self.bound = true
	end)
end
_editor_class["s3_紫三非波粒"] = Class(bullet)
_editor_class["s3_紫三非波粒"].init = function(self, _x, _y, v, a, c)
	bullet.init(self, arrow_small, c, true, true)
	self.x, self.y = _x, _y
	SetV2(self, v, a, true, false)
	lasttask = task.New(self, function()
		do
			local v1, _d_v1 = (v), (-v / 90)
			for _ = 1, 60 do
				SetV2(self, v1, a, true, false)
				task._Wait(1)
				v1 = v1 + _d_v1
			end
		end
	end)
end
_editor_class["s3_灵梦三非花心"] = Class(bullet)
_editor_class["s3_灵梦三非花心"].init = function(self, _x, _y, a, rot, v)
	bullet.init(self, ball_mid, COLOR_RED, true, true)
	self.x, self.y = _x, _y
	self.bound = false
	lasttask = task.New(self, function()
		do
			local angle, _d_angle = (0), (72)
			for _ = 1, 5 do
				last = New(_editor_class["s3_灵梦三非花"], self.x, self.y, angle, rot)
				_connect(self, last, 0, true)
				task._Wait(0)
				angle = angle + _d_angle
			end
		end
		do
			local v, _d_v = (v), (-v / 60)
			for _ = 1, 60 do
				SetV2(self, v, a + 180, true, false)
				task._Wait(1)
				v = v + _d_v
			end
		end
		_set_a(self, 0.03, a, false)
		_forbid_v(self, v, 'original', 'original')
		self.omiga = rot
		task._Wait(720)
		_del(self, true)
	end)
end
_editor_class["s3_灵梦三非花"] = Class(bullet)
_editor_class["s3_灵梦三非花"].init = function(self, _x, _y, angle, rot)
	bullet.init(self, heart, COLOR_PURPLE, false, true)
	self.x, self.y = _x, _y
	self.rot = angle
	self.omiga = rot
	self.bound = false
	_object.set_color(self, "", 0, 255, 255, 255)
	self.colli = false
	lasttask = task.New(self, function()
		do
			local r, _d_r = (140), (-125 / 60)
			local al, _d_al = (0), (255 / 60)
			for _ = 1, 60 do
				_set_rel_pos(self, r * cos(self.rot), r * sin(self.rot), self.rot, false)
				_object.set_color(self, "", al, 255, 255, 255)
				task._Wait(1)
				r = r + _d_r
				al = al + _d_al
			end
		end
		self.colli = true
		task._Wait(2)
		lasttask = task.New(self, function()
			task._Wait(720)
			_del(self, true)
		end)
		do
			local aerfa, _d_aerfa = (90), (2)
			for _ = 1, _infinite do
				_set_rel_pos(self, 15 * cos(self.rot), 15 * sin(self.rot), self.rot, false)
				task._Wait(1)
				aerfa = aerfa + _d_aerfa
			end
		end
	end)
end

_editor_class["s3_紫三符激光预警"] = Class(laser)
_editor_class["s3_紫三符激光预警"].init = function(self, _x, _y, a)
	laser.init(self, COLOR_BLUE, _x, _y, 0, 0, 0, 0, 12, 8, 0)
	lasttask = task.New(self, function()
		self.bound = false
		laser.ChangeImage(self, 3)
		_object.set_color(self, "mul+add", 255, 255, 255, 255)
		laser._TurnHalfOn(self, 1, false)
		self.rot = a
		do
			local aerfa, _d_aerfa = (0), (90 / 29)
			for _ = 1, 30 do
				self.l2 = 600 * sin(aerfa)
				task._Wait(1)
				aerfa = aerfa + _d_aerfa
			end
		end
		last = New(_editor_class["s3_紫三符射线"], self.x, self.y, 12, a)
		last = New(_editor_class["s3_紫三符射线2"], self.x, self.y, 12, a)
		task._Wait(60)
		PlaySound("lazer00", 0.5, 0, false)
		do
			local x, _d_x = (0), (1 / 19)
			for _ = 1, 20 do
				_object.set_color(self, "", 255 * (1 - x), 255, 255, 255)
				self.w = 12 + 8 * x
				task._Wait(1)
				x = x + _d_x
			end
		end
		_del(self, true)
	end)
end
_editor_class["s3_紫三符激光预警"].kill = function(self)
end
_editor_class["s3_紫三符激光预警虚影"] = Class(laser)
_editor_class["s3_紫三符激光预警虚影"].init = function(self, _x, _y, a, b, v)
	laser.init(self, COLOR_PURPLE, _x, _y, 0, 0, 900, 0, 8, 0, 0)
	self.bound = false
	laser.ChangeImage(self, 2)
	_object.set_color(self, "mul+add", 255, 255, 25, 255)
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
_editor_class["s3_紫三符激光预警虚影"].kill = function(self)
end
_editor_class["s3_紫三符射线"] = Class(laser)
_editor_class["s3_紫三符射线"].init = function(self, _x, _y, v, a)
	laser.init(self, COLOR_PURPLE, _x, _y, 0, 0, 0, 0, 10, 6, 0)
	_object.set_color(self, "mul+add", 255, 255, 255, 255)
	lasttask = task.New(self, function()
		self.layer = LAYER_ENEMY_BULLET-1
		self.bound = false
		self.rot = a
		laser._TurnOn(self, 1, false, false)
		task._Wait(61)
		PlaySound("lazer00", 0.5, 0, false)
		do
			local l, _d_l = (40), (v * 2)
			for _ = 1, 18 do
				self.l1 = 1.1 * l
				self.l2 = 0.4 * l
				self.l3 = 1.1 * l
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
_editor_class["s3_紫三符射线2"] = Class(laser)
_editor_class["s3_紫三符射线2"].init = function(self, _x, _y, v, a)
	laser.init(self, COLOR_PURPLE, _x, _y, 0, 0, 0, 0, 8, 0, 0)
	_object.set_color(self, "mul+rev", 255, 255, 255, 255)
	lasttask = task.New(self, function()
		self.layer = LAYER_ENEMY_BULLET-1
		self.bound = false
		self.rot = a
		laser._TurnOn(self, 1, false, false)
		task._Wait(61)
		PlaySound("lazer00", 0.5, 0, false)
		do
			local l, _d_l = (40), (v * 2)
			for _ = 1, 18 do
				self.l1 = 0.9 * l
				self.l2 = 0.4 * l
				self.l3 = 0.9 * l
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
_editor_class["s3_灵梦三符大弹幕激光"] = Class(laser)
_editor_class["s3_灵梦三符大弹幕激光"].init = function(self, _x, _y, angle1, r, i, n, p, c, xx, yy, da)
	laser.init(self, COLOR_RED, _x, _y, 0, 0, r * (2) ^ (0.5), 0, 1, 8, 0)
	laser.ChangeImage(self, 4)
	_object.set_color(self, "", 255, 200, 200, 200)
	self.bound = false
	lasttask = task.New(self, function()
		self.colli = false
		laser._TurnHalfOn(self, 5, false)
		laser._TurnOn(self, 30, false, true)
	end)
	lasttask = task.New(self, function()
		local r1, angle, cx, cy = 0, angle1, xx, yy
		local x1, y1
		do
			local aerfa, _d_aerfa = (0), (90 / 90)
			for _ = 1, 90 do
				r1 = r * sin(aerfa)
				angle = angle1 + 1.2 * 60 * sin(aerfa) * i
				self.rot = angle + 135
				self.l2 = r1 * (2) ^ (0.5)
				self.x = cx + r1 * cos(angle)
				self.y = cy + r1 * sin(angle)
				task._Wait(1)
				aerfa = aerfa + _d_aerfa
			end
		end
		task._Wait(5)
		PlaySound("tan00", 0.1, self.x / 256, false)
		do
			local l, _d_l = (0), (self.l2 / (n - 1))
			for _ = 1, n do
				x1, y1 = self.x + l * cos(self.rot), self.y + l * sin(self.rot)
				if Dist(x1, y1, player.x, player.y) > 32 then
					New(_editor_class["s3_灵梦三符弹幕札弹"], x1, y1, max(1, Dist(cx, cy, x1, y1) / 60), Angle(cx, cy, x1, y1), p, c, da)
				end
				task._Wait(0)
				l = l + _d_l
			end
		end
		_del(self, true)
	end)
end
_editor_class["s3_灵梦三符大弹幕激光"].kill = function(self)
end
_editor_class["s3_灵梦三符弹幕札弹"] = Class(bullet)
_editor_class["s3_灵梦三符弹幕札弹"].init = function(self, _x, _y, v, a, p, c, da)
	bullet.init(self, square, c, true, false)
	self.x, self.y = _x, _y
	_object.set_color(self, "mul+add", 255, 255, 255, 255)
	self.bound = false
	if (difficulty > 2) then
		SetV2(self, 0, a + da * p, true, false)
		lasttask = task.New(self, function()
			task._Wait(15)
			_object.set_color(self, "", 255, 255, 255, 255)
			do
				local v1, _d_v1 = (0), (0.75 * v / 239)
				for _ = 1, 240 do
					SetV2(self, v1, a + da * p, true, false)
					task._Wait(1)
					v1 = v1 + _d_v1
				end
			end
			task._Wait(40)
			self.bound = true
		end)
	else
		SetV2(self, 0, a, true, false)
		lasttask = task.New(self, function()
			task._Wait(15)
			_object.set_color(self, "", 255, 255, 255, 255)
			do
				local v1, _d_v1 = (0), (0.75 * v / 239)
				for _ = 1, 240 do
					SetV2(self, v1, a, true, false)
					task._Wait(1)
					v1 = v1 + _d_v1
				end
			end
			task._Wait(40)
			self.bound = true
		end)
	end
end

--endregion
