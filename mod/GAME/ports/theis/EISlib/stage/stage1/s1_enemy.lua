--祈华梦一面道中部分
s1_road = {}
-------------------------------------

local path = "EISlib/stage/stage1/"
Include(path .. "s1_boss.lua")

--资源加载
do
	local path = "res/stage/stage1/s1title/"
	LoadImageFromFile("s1_t1", path .. "s1_t1.png")
	LoadImageFromFile("s1_t2", path .. "s1_t2.png")
	LoadImageFromFile("s1_t3", path .. "s1_t3.png")
	LoadImageFromFile("s1_t4", path .. "s1_t4.png")
end
----------------------------------标题
local s1_title
do
	local size, t0, t1, t2 = 0.8, 90, 60, 60
	local s1_t1 = Class(object)
	function s1_t1:init(x, y)
		self.x, self.y = x, y
		self.img = "s1_t1"
		self.hscale, self.vscale = size, size
		_object.set_color(self, "", 0, 0, 0, 0)
		task.New(self, function()
			local d_a = 255 / t0
			for _ = 1, t0 do
				self._a = self._a + d_a
				self._r, self._g, self._b = self._r + d_a, self._g + d_a, self._b + d_a
				task.Wait(1)
			end
			task.Wait(t1)
			d_a = -255 / t2
			for _ = 1, t2 do
				self._a = self._a + d_a
				task.Wait(1)
			end
			Del(self)
		end)
	end
	function s1_t1:frame()
		task.Do(self)
	end
	function s1_t1:render()
		SetImgState(self, "", self._a, self._r, self._g, self._b)
		Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
	end
	local s1_t2 = Class(object)
	function s1_t2:init(x, y)
		self.x, self.y = x, y
		self.img = "s1_t2"
		self.hscale, self.vscale = size, size
		_object.set_color(self, "", 0, 255, 255, 255)
		task.New(self, function()
			local d_a = 255 / t0
			for _ = 1, t0 do
				self._a = self._a + d_a
				task.Wait(1)
			end
			task.Wait(t1)
			d_a = -255 / t2
			for _ = 1, t2 do
				self._a = self._a + d_a
				task.Wait(1)
			end
			Del(self)
		end)
	end
	function s1_t2:frame()
		task.Do(self)
	end
	function s1_t2:render()
		SetImgState(self, "", self._a, self._r, self._g, self._b)
		Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
	end
	local s1_t3 = Class(object)
	function s1_t3:init(x, y)
		self.x, self.y = x, y
		self.img = "s1_t3"
		self.hscale, self.vscale = size, size
		_object.set_color(self, "", 0, 255, 255, 255)
		task.New(self, function()
			local d_a = 255 / t0
			for _ = 1, t0 do
				self._a = self._a + d_a
				task.Wait(1)
			end
			task.Wait(t1)
			d_a = -255 / t2
			for _ = 1, t2 do
				self._a = self._a + d_a
				task.Wait(1)
			end
			Del(self)
		end)
	end
	function s1_t3:frame()
		task.Do(self)
	end
	function s1_t3:render()
		SetImgState(self, "", self._a, self._r, self._g, self._b)
		Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
	end
	local s1_t4 = Class(object)
	function s1_t4:init(x, y)
		self.x, self.y = x, y
		self.img = "s1_t4"
		self.hscale, self.vscale = size, size
		_object.set_color(self, "", 0, 255, 255, 255)
		task.New(self, function()
			local d_a = 255 / t0
			for _ = 1, t0 do
				self._a = self._a + d_a
				task.Wait(1)
			end
			task.Wait(t1)
			d_a = -255 / t2
			for _ = 1, t2 do
				self._a = self._a + d_a
				task.Wait(1)
			end
			Del(self)
		end)
	end
	function s1_t4:frame()
		task.Do(self)
	end
	function s1_t4:render()
		SetImgState(self, "", self._a, self._r, self._g, self._b)
		Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
	end
	function s1_title()
		local x, y = 0, 100
		New(s1_t1, x - 130 * size, y + 0)
		New(s1_t4, x + 80 * size, y - 5 * size)
		New(s1_t2, x + 160 * size, y - 36 * size)
		New(s1_t3, x + 60 * size, y + 20 * size)
	end
end

----------------------------------不能访问的函数的定义-------------------------------------

----------------------------------移动定义-------------------------------------

----------------------------------特殊的弹幕定义-------------------------------------
--生成常用加速弹
local function accbullet(st, co, x, y, v, a, t)
	local obj = stg.newBulletStraight(st, co, true, x, y, 0, a)
	egg.AddSimStrChV(obj, 0, v, a, t)
	return obj
end
---------------------------------攻击方式定义-------------------------------------
--1way攻击
local atk1, atk2, atk3, atk4, atk5, atk6, atk7
function atk1(self)
		--普通攻击
		task.New(self, function()
			local diff = difficulty
			if diff == 4 then
				task.Wait(90)
				for _ = 1, 2 do
					for _ = 1, 3 do
						PlaySound("tan00")
						egg.AddSimStrChV(stg.newBulletStraight(stg.grain_a, 10, true, self.x, self.y, 0, Angle(self, player)), 2, 4, Angle(self, player), 120)
						task.Wait(5)
					end
					task.Wait(20)
				end
			elseif diff == 3 then
				task.Wait(110)
				for _ = 1, 2 do
					PlaySound("tan00")
					stg.newBulletStraight(stg.grain_a, 10, true, self.x, self.y, 3, Angle(self, player))
					task.Wait(10)
				end
			elseif diff == 2 then
				task.Wait(130)
				PlaySound("tan00")
				stg.newBulletStraight(stg.grain_a, 10, true, self.x, self.y, 2, Angle(self, player))
			end
		end)
end
--3way攻击
function atk2(self)
	--普通攻击
	task.New(self, function()
		local diff = difficulty
		if diff == 4 then
			task.Wait(90)
			for _ = 1, 2 do
				for _ = 1, 3 do
					PlaySound("tan00")
					for i = -1, 1 do
						egg.AddSimStrChV(stg.newBulletStraight(stg.grain_a, 10, true, self.x, self.y, 0, Angle(self, player) + 45*i), 2, 4, Angle(self, player) + 45*i, 120)
					end
					task.Wait(5)
				end
				task.Wait(20)
			end
		elseif diff == 3 then
			task.Wait(110)
			for _ = 1, 2 do
				PlaySound("tan00")
				stg.newBulletStraight(stg.grain_a, 10, true, self.x, self.y, 3, Angle(self, player))
				task.Wait(10)
			end
		elseif diff == 2 then
			task.Wait(130)
			PlaySound("tan00")
			stg.newBulletStraight(stg.grain_a, 10, true, self.x, self.y, 2, Angle(self, player))
		end
	end)
end
--一排弹幕
function atk3(self)
	--普通攻击
	task.New(self, function()
		local diff = difficulty
		if diff == 4 then
			task.Wait(90)
			local a, sp = Angle(self, player)
			for i = 0, 1 do
				sp = a - 0.5 * 10 * (6 + i)
				for _ = 0, 6 + i do
					egg.AddSimStrChV(stg.newBulletStraight(stg.ball_mid_c, 1, true, self.x, self.y, 0, sp), 0, 2 + i, sp, 60)
					sp = sp + 10
				end
			end
		elseif diff == 3 then
			task.Wait(110)
			local a, sp = Angle(self, player)
			sp = a - 0.5 * 10 * 4
			for _ = 0, 4 do
				egg.AddSimStrChV(stg.newBulletStraight(stg.ball_mid_c, 1, true, self.x, self.y, 0, sp), 0, 2.5, sp, 60)
				sp = sp + 10
			end
		elseif diff == 2 then
			task.Wait(130)
			local a, sp = Angle(self, player)
			sp = a - 0.5 * 20 * 2
			for _ = 0, 2 do
				egg.AddSimStrChV(stg.newBulletStraight(stg.ball_mid_c, 1, true, self.x, self.y, 0, sp), 0, 2, sp, 60)
				sp = sp + 20
			end
		elseif diff == 1 then
			task.Wait(150)
			local a = Angle(self, player)
			egg.AddSimStrChV(stg.newBulletStraight(stg.ball_mid_c, 1, true, self.x, self.y, 0, a), 0, 2, a, 60)
		end
	end)
end
--渐强式全方位弹幕
function atk4(self)
	--普通攻击
	task.New(self, function()
		local diff = difficulty
		if diff == 4 then
			task.Wait(20)
			local a, da = Angle(self, player)
			for i = 0, 4 do
				a, da = Angle(self, player), 360/(12 + 6*i)
				for j = 1, 20 + 6*i do
					accbullet(stg.arrow_big, 6, self.x, self.y, 2, a + da*j, 60)
				end
				PlaySound("kira00")
				task.Wait(20)
			end
		elseif diff == 3 then
			task.Wait(40)
			local a, da = Angle(self, player)
			for i = 0, 3 do
				a, da = Angle(self, player), 360/(9 + 5*i)
				for j = 1, 15 + 5*i do
					accbullet(stg.arrow_big, 6, self.x, self.y, 1.75, a + da*j, 60)
				end
				PlaySound("kira00")
				task.Wait(25)
			end
		elseif diff == 2 then
			task.Wait(60)
			local a, da = Angle(self, player)
			for i = 0, 1 do
				a, da = Angle(self, player), 360/(8 + 4*i)
				for j = 1, 12 + 4*i do
					accbullet(stg.arrow_big, 6, self.x, self.y, 1.5, a + da*j, 60)
				end
				PlaySound("kira00")
				task.Wait(40)
			end
		elseif diff == 1 then
			task.Wait(90)
			local a, da = Angle(self, player)
			da = 360/6
			for j = 1, 6 do
				accbullet(stg.arrow_big, 6, self.x, self.y, 1.25, a + da*j, 60)
			end
			PlaySound("kira00")
		end
	end)
end
--往下扔的奇怪弹幕
function atk5(self)
	task.New(self, function()
		local diff = difficulty
		if diff == 4 then
			for _ = 1, 40 do
				for _ = 1, 3 do
					accbullet(stg.ball_mid, 5, self.x, self.y, ran:Float(1.5, 2.5), ran:Float(-105, -95), 60)
				end
				task.Wait(5)
			end
		elseif diff == 3 then
			for _ = 1, 25 do
				for _ = 1, 2 do
					accbullet(stg.ball_mid, 5, self.x, self.y, ran:Float(1.5, 2.5), ran:Float(-105, -95), 60)
				end
				task.Wait(8)
			end
		elseif diff == 2 then
			for _ = 1, 20 do
				accbullet(stg.ball_mid, 5, self.x, self.y, ran:Float(1.5, 2.5), ran:Float(-105, -95), 60)
				task.Wait(10)
			end
		else
			for _ = 1, 5 do
				accbullet(stg.ball_mid, 5, self.x, self.y, ran:Float(1.5, 2.5), ran:Float(-105, -95), 60)
				task.Wait(20)
			end
		end
	end)
end
--2way攻击
function atk6(self)
	--普通攻击
	task.New(self, function()
		local diff = difficulty
		if diff == 4 then
			task.Wait(90)
			for _ = 1, 2 do
				for _ = 1, 3 do
					PlaySound("tan00")
					for i = -3, 3, 2 do
						egg.AddSimStrChV(stg.newBulletStraight(stg.grain_a, 10, true, self.x, self.y, 0, Angle(self, player) + 35*i), 2, 4, Angle(self, player) + 35*i, 120)
					end
					task.Wait(5)
				end
				task.Wait(20)
			end
		elseif diff == 3 then
			task.Wait(100)
			for _ = 1, 2 do
				PlaySound("tan00")
				for i = -1, 1, 2 do
					stg.newBulletStraight(stg.grain_a, 10, true, self.x, self.y, 3, Angle(self, player) + 40*i)
				end
				task.Wait(10)
			end
		elseif diff == 2 then
			task.Wait(110)
			PlaySound("tan00")
			for i = -1, 1, 2 do
				stg.newBulletStraight(stg.grain_a, 10, true, self.x, self.y, 2, Angle(self, player) + 45*i)
			end
		end
	end)
end
--超级渐强式全方位弹幕
function atk7(self)
	--普通攻击
	task.New(self, function()
		local diff = difficulty
		if diff == 4 then
			--task.Wait(20)
			local a, da = Angle(self, player)
			for i = 0, 6 do
				a, da = Angle(self, player), 360/(12 + 6*i)
				for j = 1, 20 + 6*i do
					accbullet(stg.arrow_big, 6, self.x, self.y, 2, a + da*j, 60)
					accbullet(stg.arrow_big, 4, self.x, self.y, 1.75, a + da*(j-0.5), 60)
				end
				PlaySound("kira00")
				task.Wait(10)
			end
		elseif diff == 3 then
			task.Wait(10)
			local a, da = Angle(self, player)
			for i = 0, 4 do
				a, da = Angle(self, player), 360/(9 + 5*i)
				for j = 1, 12 + 5*i do
					accbullet(stg.arrow_big, 6, self.x, self.y, 1.75, a + da*j, 60)
					accbullet(stg.arrow_big, 4, self.x, self.y, 1.5, a + da*(j-0.5), 60)
				end
				PlaySound("kira00")
				task.Wait(15)
			end
		elseif diff == 2 then
			task.Wait(30)
			local a, da = Angle(self, player)
			for i = 0, 1 do
				a, da = Angle(self, player), 360/(8 + 4*i)
				for j = 1, 8 + 4*i do
					accbullet(stg.arrow_big, 6, self.x, self.y, 1.5, a + da*j, 60)
					accbullet(stg.arrow_big, 4, self.x, self.y, 1.25, a + da*(j-0.5), 60)
				end
				PlaySound("kira00")
				task.Wait(40)
			end
		elseif diff == 1 then
			task.Wait(50)
			local a, da = Angle(self, player)
			da = 360/6
			for j = 1, 6 do
				accbullet(stg.arrow_big, 6, self.x, self.y, 1.25, a + da*j, 60)
				accbullet(stg.arrow_big, 4, self.x, self.y, 1, a + da*(j-0.5), 60)
			end
			PlaySound("kira00")
		end
	end)
end
----------------------------------状态改变定义-------------------------------------

----------------------------------死尸弹定义-------------------------------------

----------------------------------obj定义--------------------------------------------

----------------------------------小怪、衍生定义-------------------------------------
local e1
do
	e1 = Class(enemy)
	function e1:init(x, y, IsnDye)
		if IsnDye then
			enemy.init(self, 1, 10, false, true, false, false, nil, 0, 1)
		else
			enemy.init(self, 1, 10, false, true, false, false, 3, 0, 1)
		end
		self.group = GROUP_NONTJT
		self.x, self.y = x, y
	end
	function e1:kill()
		enemy.kill(self)
		if not (self.sys_co == 1 or self.sys_co == 2) then
			if (difficulty == 4) then
				New(tasker, function()
					local x, y, a = self.x, self.y
					a = Angle(x, y, player.x, player.y)
					for _ = 1, 2 do
						local sp, dsp = -30, 30
						for _ = 1, 3 do
							egg.AddSimStrChV(stg.newBulletStraight(stg.arrow_small, 10, true, x, y, 0, a + sp), 0, 3, a + sp, 180)
							sp = sp + dsp
						end
						task.Wait(10)
					end
				end)
			elseif difficulty == 3 then
				New(tasker, function()
					local x, y, a = self.x, self.y
					a = Angle(x, y, player.x, player.y)
					for _ = 1, 2 do
						egg.AddSimStrChV(stg.newBulletStraight(stg.arrow_small, 10, true, x, y, 0, a), 0, 2.5, a, 180)
						task.Wait(10)
					end
				end)
			elseif (difficulty == 2) then
				New(tasker, function()
					local x, y, a = self.x, self.y
					a = Angle(x, y, player.x, player.y)
					egg.AddSimStrChV(stg.newBulletStraight(stg.arrow_small, 10, true, x, y, 0, a), 0, 2, a, 180)
				end)
			end
		end
	end
end
local e2
do
	e2 = Class(enemy)
	function e2:init(x, y, co)
		enemy.init(self, 5, 30, false, true, false, true, co or 1, 100, 1)
		self.group = GROUP_NONTJT
		self.bound = false
		self.x, self.y = x, y
		--出屏
		task.New(self, function()
			task.Wait(90)
			self.bound = true
		end)
	end
end
local e3, e3_1
do
	local function f1(x, y, a, v, da)
		local obj = stg.newBulletStraight(stg.ball_small, 5, true, x, y, 0, a)
		egg.AddSimStrChV(obj, ran:Float(2, 3), 0.5, a, 90)
		task.New(obj, function()
			task.Wait(90)
			a = Angle(obj, player) + da
			local last = stg.newBulletStraight(stg.grain_a, 10, true, obj.x, obj.y, 0, a)
			egg.AddSimStrChV(last, v + 3, v, a, 30)
			Del(obj)
		end)
	end
	e3 = Class(enemy)
	function e3:init(x, y, co)
		enemy.init(self, 5, 30, false, true, false, true, co or 2, 70, 1)
		self.group = GROUP_NONTJT
		self.x, self.y = x, y
		--self.layer = LAYER_ENEMY+1
		--生成使魔
		do
			for u = -1, 1, 2 do
				for i = 1, 2 do
					_connect(self, New(e3_1, self, 30 * i * u, 0, -90 + 15 * i * u), 1, false)
				end
			end
		end
		--[[发弹幕
		task.New(self, function()
			local diff = difficulty
			if diff == 4 then
				task.Wait(45)
				for _ = 1, 3 do
					for _ = 1, 20 do
						for i = -1, 1 do
							f1(self.x, self.y, ran:Float(60, 120), 3, 30 * i)
							task.Wait(1)
						end
					end
					task.Wait(60)
				end
			elseif diff == 3 then
				task.Wait(60)
				for _ = 1, 3 do
					for _ = 1, 30 do
						f1(self.x, self.y, ran:Float(60, 120), 2.5, 0)
						task.Wait(2)
					end
					task.Wait(75)
				end
			elseif diff == 2 then
				task.Wait(75)
				for _ = 1, 2 do
					for _ = 1, 20 do
						f1(self.x, self.y, ran:Float(60, 120), 2, 0)
						task.Wait(3)
					end
				end
			else
				task.Wait(90)
				for _ = 1, 10 do
					f1(self.x, self.y, ran:Float(60, 120), 1.5, 0)
					task.Wait(5)
				end
			end
		end)]]
		--拉尿
		atk5(self)
	end
	--自带的鬼火使魔
	e3_1 = Class(enemy)
	function e3_1:init(mst, dx, dy, a)
		enemy.init(self, 20, 30, false, true, false, false, 3, 0, 1)
		self.group = GROUP_NONTJT
		self.layer = LAYER_ENEMY-1
		self.x, self.y = mst.x + dx, mst.y + dy
		self.bound = false
		task.New(self, function()
			while IsValid(mst) do
				self.x, self.y = mst.x + dx, mst.y + dy
				task.Wait(1)
			end
			SetV(self, self.dx, self.dy)
			self.bound = true
		end)
		--攻击
		task.New(self, function()
			local diff = difficulty
			if diff == 4 then
				task.Wait(70)
				for _ = 1, 5 do
					for _ = 1, 5 do
						for i = -1, 1, 2 do
							stg.newBulletStraight(stg.arrow_big, 8, true, self.x, self.y, 3, a + 135*i)
						end
						stg.newBulletStraight(stg.arrow_big, 8, true, self.x, self.y, 3, a)
						task.Wait(4)
					end
					task.Wait(60)
				end
			elseif diff == 3 then
				task.Wait(90)
				for _ = 1, 3 do
					for _ = 1, 4 do
						stg.newBulletStraight(stg.arrow_big, 8, true, self.x, self.y, 2, a + 180)
						stg.newBulletStraight(stg.arrow_big, 8, true, self.x, self.y, 2, a)
						task.Wait(5)
					end
					task.Wait(75)
				end
			elseif diff == 2 then
				task.Wait(110)
				for _ = 1, 2 do
					for _ = 1, 2 do
						stg.newBulletStraight(stg.arrow_big, 8, true, self.x, self.y, 1.5, -90)
						task.Wait(10)
					end
					task.Wait(90)
				end
			else
				task.Wait(130)
				for _ = 1, 2 do
					stg.newBulletStraight(stg.arrow_big, 8, true, self.x, self.y, 1.2, -90)
					task.Wait(120)
				end
			end
		end)
	end
end
local e4, e4_1
do
	local function f1(x, y, v, a)
		local obj = stg.newBulletStraight(stg.arrow_big, 2, true, x, y, 0, a)
		egg.AddSimStrChV(obj, 0, v, a, 30)
	end
	e4 = Class(enemy)
	function e4:init(x, y, u)
		enemy.init(self, 5, 30, false, true, false, true, 2, 70, 1)
		self.group = GROUP_NONTJT
		--self.layer = LAYER_ENEMY+1
		self.x, self.y = x, y
		--生成使魔
		do
			task.New(self, function()
				for i = 0, 2 do
					New(e4_1, self, 120 * i + 90 + 90 * u, -u)
				end
			end)
		end
		--发弹幕
		task.New(self, function()
			local diff = difficulty
			if diff == 4 then
				task.Wait(45)
				local a
				for _ = 1, 3 do
					a = Angle(self, player)
					for i = 0, 35 do
						f1(self.x, self.y, 2.5, a + 10 * i)
					end
					task.Wait(60)
				end
			elseif diff == 3 then
				task.Wait(60)
				local a
				for _ = 1, 2 do
					a = Angle(self, player)
					for i = 0, 23 do
						f1(self.x, self.y, 2, a + 15 * i)
					end
					task.Wait(90)
				end
			elseif diff == 2 then
				task.Wait(75)
				local a
				a = Angle(self, player)
				for i = 0, 15 do
					f1(self.x, self.y, 1.75, a + 22.5 * i)
				end
			else
				task.Wait(90)
				local a
				a = Angle(self, player)
				for i = 0, 9 do
					f1(self.x, self.y, 1.5, a + 36 * i)
				end
			end
		end)
	end
	--自带的鬼火使魔
	e4_1 = Class(enemy)
	function e4_1:init(mst, a, u)
		enemy.init(self, 20, 30, false, true, false, false, 3, 0, 1)
		self.group = GROUP_NONTJT
		self.layer = LAYER_ENEMY-1
		_object.set_color(self, "", 0, 255, 255, 255)
		egg.SimAlpCh(self, 0, 255, 20)
		self.x, self.y = mst.x, mst.y
		self.bound = false
		task.New(self, function()
			local r, da = -30, 1.5 * u
			while IsValid(mst) and r < 70 do
				a = a + da
				r = r + 0.5
				self.x, self.y = mst.x + r * cos(a), mst.y + r * sin(a)
				task.Wait(1)
			end
			--SetV(self, r*(cos(a + da) - cos(a)), self.dy)
			egg.AddV2(self, self.dx, self.dy)
			local a = Angle(0, 0, self.dx, self.dy)
			egg.AddSimStrChV(self, 0, 2, a, 90)
			self.bound = true
		end)
		--攻击
		task.New(self, function()
			local diff = difficulty
			if diff == 4 then
				--task.Wait(60)
				for _ = 1, 52 do
					for i = 0, 3 do
						accbullet(stg.arrow_big, 12, self.x, self.y, 2.25 + 0.25*i, a + 1.5*i*u, 30)
					end
					task.Wait(5)
				end
			elseif diff == 3 then
				task.Wait(20)
				for _ = 1, 26 do
					for i = 0, 2 do
						accbullet(stg.arrow_big, 12, self.x, self.y, 2.25 + 0.25*i, a + 1.5*i*u, 30)
					end
					task.Wait(10)
				end
			elseif diff == 2 then
				task.Wait(30)
				for _ = 1, 12 do
					for i = 0, 1 do
						accbullet(stg.arrow_big, 12, self.x, self.y, 2 + 0.25*i, a + 1.5*i*u, 30)
					end
					task.Wait(15)
				end
			else
				task.Wait(70)
				for _ = 1, 12 do
					accbullet(stg.arrow_big, 12, self.x, self.y, 1.75, a, 30)
					task.Wait(20)
				end
			end
		end)
	end
end
----------------------------------道中本体-------------------------
local function decDmg(self, t1, t2, d0, d1)
	--设置线性减伤时间
	d0 = d0 or self.dmgrate
	d1 = d1 or 1
	self.dmgrate = d0
	t1 = t1 or 180
	t2 = t2 or 60
	task.New(self, function()
		task.Wait(t1)
		local d = (d1 - d0) / t2
		for _ = 1, t2 do
			self.dmgrate = self.dmgrate + d
			task.Wait(1)
		end
		self.dmgrate = d1 --强制设置一下，以防浮点数的极小误差
	end)
end
local function IsClear(t)
	--判断t时间内是否还存在敌人，若不存在则跳过剩余时间
	local flag
	for _ = 1, t do
		flag = true
		for _, _ in ObjList(GROUP_NONTJT) do
			flag = false
			break
		end
		for _, _ in ObjList(GROUP_ENEMY) do
			flag = false
			break
		end
		if flag then
			break
		end
		task.Wait(1)
	end
end
local function road(self)
	do
		New(stage1_background)
		system.setTargetChain(230)
		dialog.cacheResource("Stage1")
		dialog.cacheResource("Stage1_after")
		LoadMusicRecord("s1")
		LoadMusicRecord("s1_boss")
	end
	EISlib.stage.playMusic("s1", 0, true)
	task.Wait(60)
	--
	do
		local f1, f1_1, f1_2, f2, f3_1, f3_2, f3_3
		do
			--一群妖精和蝴蝶
			function f1(x, y, a, u, n)
				for _ = 1, n do
					f1_1(x, y, a, u)
					task.Wait(10)
				end
				f1_2(x, y, a - 35 * u, u)
			end
			--普通小妖精
			function f1_1(x, y, a, u)
				local obj = New(e1, x, y + 20)
				--移动
				obj.dmgrate = 0.2
				task.New(obj, function()
					egg.AddSimStrChV(obj, 1, 2.5, a, 60)
					task.Wait(30)
					obj.dmgrate = 1
					task.Wait(80)
					egg.AddSimStrChV(obj, 0, 4, a + 90 * u, 60)
				end)
				--3way的弹幕
				atk2(obj)
			end
			--普通大蝴蝶
			function f1_2(x, y, a, u)
				local obj = New(e2, x + 200 * u, y)
				--常规移动
				obj.dmgrate = 0.2
				task.New(obj, function()
					egg.AddSimStrChV(obj, 3, 1, a, 70)
					task.Wait(30)
					obj.dmgrate = 1
					task.Wait(90)
					egg.AddSimStrChV(obj, 0, 2, 90, 60)
				end)
				--放一圈圈弹幕
				atk4(obj)
			end
			--自机狙大蝴蝶
			function f2(x, y, u)
				local obj = New(e3, x, y)
				obj.dmgrate = 0.1
				task.New(obj, function()
					egg.AddSimStrChV(obj, 3, 1.5, 90 - 90 * u, 90)
					task.Wait(90)
					egg.AddSimStrChV(obj, 0, 2.5, -90, 90)
				end)
				decDmg(obj, 20, 36, 0.1, 1)
			end
			--交叉移动的妖精
			function f3_1(x, y, u)
				local obj = New(e1, x, y, true)
				--移动
				task.New(obj, function()
					egg.AddSimStrChV(obj, 1.25, 0.5, -90, 60)
					egg.AddAccDecChV(obj, 1.25, 90 + 90 * u, 30, 150, 60)
					task.Wait(240)
					egg.AddSimStrChV(obj, 0, 2, 90 - 90 * u, 30)
				end)
				atk6(obj)
			end
			--跟着妖精移动的大蝴蝶
			function f3_2(x, y, u)
				local obj = New(e3, x, y)
				obj.dye_range = 90
				task.New(obj, function()
					egg.AddSimStrChV(obj, 2, 0.5, -90, 60)
					egg.AddAccDecChV(obj, 1, 90 + 90 * u, 10, 150, 60)
					task.Wait(180)
					egg.AddSimStrChV(obj, 0, 2, 90 - 90 * u, 120)
				end)
				atk5(obj)
			end
			--中间来填充染色的工具蝶
			function f3_3(x, y)
				local obj = New(e2, x, y, 2)
				egg.AddSimStrChV(obj, 3, 0.5, -90, 90)
				egg.AddSimStrChV(obj, 0, 3, 90, 120, 120)
				atk7(obj)
			end
		end

		do
			local u = 1
			for i = 0, 3 do
				f1(-100 * u, 245, -90 + 30 * u, u, 4 + i)
				IsClear(120)
				u = -u
			end
			--大蝴蝶
			for u = -1, 1, 2 do
				f2(-260 * u, 100, u)
				IsClear(180)
			end
			task.Wait(60)
			--一群交叉妖精
			f3_2(-260, 180, -1)
			f3_2(260, 180, 1)
			for _ = 1, 5 do
				for u = -1, 1, 2 do
					f3_1(224 * u, 200, u)
					f3_1(224 * u, 160, u)
				end
				task.Wait(15)
			end
			task.Wait(90)
			f3_3(0, 224)
			IsClear(1400 - self.timer)
			task.Wait(60)
			local n = 4
			while self.timer < 1400 do
				IsClear(1400 - self.timer)
				f1(-192 * u, 245, -90 + 30 * u, u, n)
				n = n + 1
				u = -u
			end
			while self.timer < 1600 do
				task.Wait(1)
			end
			s1_title() --第1600帧
		end
	end

	--p2(1600 - 3000)
	do
		local f1, f1_1, f1_2, f2, f2_1, f2_2, f3, f3_1, f3_2
		do
			function f1(y, u)
				f1_1(-270 * u, y, u)
				task.Wait(60)
				for _ = 1, 4 do
					f1_2(224 * u, y + 50, -u)
					task.Wait(15)
				end
			end
			function f1_1(x, y, u)
				local obj = New(e3, x, y)
				obj.dmgrate = 0.1
				task.New(obj, function()
					egg.AddSimStrChV(obj, 2, 1, 90 - 90 * u, 60)
					egg.AddAccDecChV(obj, 2, 90, 60, 60, 30)
					task.Wait(120)
					egg.AddAccDecChV(obj, 1, -90, 60, 60, 30)
				end)
				--减伤
				task.New(obj, function()
					task.Wait(120)
					for _ = 1, 72 do
						obj.dmgrate = obj.dmgrate + 0.0125
						task.Wait(1)
					end
				end)
			end
			function f1_2(x, y, u)
				local obj = New(e1, x, y)
				task.New(obj, function()
					egg.AddSimStrChV(obj, 3, 1, 90 - 90 * u, 90)
					egg.AddAccDecChV(obj, 1.5, 90, 30, 60, 30)
					task.Wait(120)
					egg.AddAccDecChV(obj, 1, -90, 60, 60, 30)
				end)
			end
			function f2(y, u)
				f2_1(-60 * u, 240, 2)
				for _ = 1, 3 do
					f2_2(-224 * u, y, u)
					task.Wait(15)
				end
				f2_1(30 * u, 240)
				for _ = 1, 3 do
					f2_2(-224 * u, y, u)
					task.Wait(15)
				end
				f2_1(120 * u, 240, 2)
				for _ = 1, 3 do
					f2_2(-224 * u, y, u)
					task.Wait(15)
				end
			end
			function f2_1(x, y, co)
				local obj = New(e2, x, y, co)
				decDmg(obj, 40, 30, 0.1, 1)
				obj.dye_range = 80
				task.New(obj, function()
					egg.AddSimStrChV(obj, 3, 0, -90, 90)
					task.Wait(180)
					egg.AddSimStrChV(obj, 0, 3, 90, 90)
				end)
				atk4(obj)
			end
			function f2_2(x, y, u)
				local obj = New(e1, x, y)
				task.New(obj, function()
					egg.AddAccDecChV(obj, 1.5, -90, 1, 1, 90)
					egg.AddSimStrChV(obj, 1, 3.5, 90 - 90 * u, 90)
				end)
				atk2(obj)
			end
			--和2相同，不过小妖精是无色的
			function f3(y, u)
				f3_1(-60 * u, 240)
				for _ = 1, 4 do
					f3_2(-224 * u, y, u)
					task.Wait(15)
				end
				f3_1(60 * u, 240)
				for _ = 1, 4 do
					f3_2(-224 * u, y, u)
					task.Wait(15)
				end
				f3_1(0 * u, 240)
				task.Wait(60)
				f3_1(-120 * u, 240)
			end
			function f3_1(x, y)
				local obj = New(e2, x, y)
				decDmg(obj, 40, 30, 0.1, 1)
				obj.dye_range = 90
				task.New(obj, function()
					egg.AddSimStrChV(obj, 3, 0, -90, 90)
					task.Wait(180)
					egg.AddSimStrChV(obj, 0, 3, 90, 90)
				end)
			end
			function f3_2(x, y, u)
				local obj = New(e1, x, y, true)
				task.New(obj, function()
					egg.AddAccDecChV(obj, 1.5, -90, 1, 1, 90)
					--egg.AddSimStrChV(obj, 1, 3.5, 90 - 90*u, 90)
					egg.AddAccDecChV(obj, 3, 90 - 90 * u, 90, 60, 60)
					task.Wait(180)
					--往回走了
					egg.AddSimStrChV(obj, 0, 3, 90 + 90 * u, 90)
				end)
			end
		end

		do
			task.Wait(180) --测试先暂时注释以节省时间
			f1(-50, -1)
			IsClear(180)
			f1(-70, 1)
			IsClear(180)
			task.Wait(60)
			f2(192, 1)
			task.Wait(60)
			IsClear(60)
			f2(192, -1)
			task.Wait(120)
			if self.timer < 2800 then
				f2(192, 1)
			end
			while self.timer < 3000 do
				task.Wait(1)
			end
		end
	end
	--道中boss以及增援
	do
		local f1, f1_1, f1_2, boss
		do
			--一群妖精和蝴蝶
			function f1(x, y, a, u, n)
				for _ = 1, n do
					f1_1(x, y, a, u)
					task.Wait(10)
				end
				f1_2(x, y, a - 35 * u, u)
			end
			--普通小妖精
			function f1_1(x, y, a, u)
				local obj = New(e1, x, y + 20)
				--移动
				obj.dmgrate = 0.2
				task.New(obj, function()
					egg.AddSimStrChV(obj, 1, 2.5, a, 60)
					task.Wait(30)
					obj.dmgrate = 1
					task.Wait(80)
					egg.AddSimStrChV(obj, 0, 4, a + 90 * u, 60)
				end)
				atk2(obj)
			end
			--普通大蝴蝶
			function f1_2(x, y, a, u)
				local obj = New(e2, x + 200 * u, y)
				--常规移动
				obj.dmgrate = 0.2
				task.New(obj, function()
					egg.AddSimStrChV(obj, 3, 1, a, 70)
					task.Wait(30)
					obj.dmgrate = 1
					task.Wait(90)
					egg.AddSimStrChV(obj, 0, 2, 90, 60)
				end)
				atk4(obj)
			end
		end

		do
			boss = s1_mid_boss.main()
			local u = 1
			while self.timer < 4600 do
				if not IsValid(boss) then
					f1(-100 * u, 245, -90 + 30 * u, u, 6)
					IsClear(120)
					u = -u
				end
				task.Wait(1)
			end
		end
	end

	--道中boss后主体小怪
	do
		local f1, f2, f2_1
		do
			function f1(x, y, u)
				local obj = New(e4, x, y, u)
				decDmg(obj, 15, 30, 0.1, 1)
				task.New(obj, function()
					egg.AddAccDecChV(obj, 2, -90, 1, 120, 60) --竖着
					task.Wait(120)
					egg.AddAccDecChV(obj, 2, 90 - 90 * u, 60, 0, 60) --横向
					task.Wait(60)
					egg.AddSimStrChV(obj, 0, 2, 90, 60) --溜了溜了
				end)
			end
			function f2(u)
				f1(60 * u, 270, -u)
				for _ = 1, 4 do
					f2_1(-224 * u, 150, u)
					task.Wait(10)
				end
				for _ = 1, 4 do
					f2_1(-224 * u, 150, u)
					task.Wait(10)
				end
				f1(120 * u, 360, u)
			end
			function f2_1(x, y, u)
				local obj = New(e1, x, y)
				task.New(obj, function()
					egg.AddSimStrChV(obj, 0, 0.75, -90, 60)
					SetV(obj, 3.2, 90 + 90 * u)
					egg.AddAccDecChV(obj, 6, 90 - 90 * u, 1, 90, 180)
				end)
				atk2(obj)
			end
		end
		do
			f1(-120, 250, 1)
			task.Wait(60)
			IsClear(60)
			f1(120, 250, -1)
			task.Wait(60)
			IsClear(60)
			f1(-80, 250, 1)
			task.Wait(60)
			IsClear(60)
			f1(80, 250, -1)
			task.Wait(90)
			IsClear(60)
			f1(-100, 250, 1)
			f1(100, 250, -1)
			task.Wait(120)
			IsClear(60)
			f2(1)
			task.Wait(90)
			IsClear(90)
			f2(-1)
			task.Wait(90)
			IsClear(5990 - self.timer)
			local u = 1
			while self.timer < 5990 do
				f1(-120 * u, 250, u)
				task.Wait(60)
				IsClear(60)
				u = -u
			end
		end
	end
	while self.timer < 6090 do
		task.Wait(1)
	end
	--最后一个阶段
	do
		local f1, f1_1, f1_2, f2, f2_1, f2_2
		do
			function f1(y, u)
				for _ = 1, 4 do
					f1_2(224 * u, y + 70, -u)
					task.Wait(15)
				end
				f1_1(-270 * u, y, u)
			end
			function f1_1(x, y, u)
				local obj = New(e3, x, y)
				obj.dmgrate = 0.1
				task.New(obj, function()
					egg.AddSimStrChV(obj, 2, 1, 90 - 90 * u, 60)
					egg.AddSimStrChV(obj, 0, 1.25, -90, 60)
				end)
				--减伤
				task.New(obj, function()
					task.Wait(60)
					for _ = 1, 72 do
						obj.dmgrate = obj.dmgrate + 0.0125
						task.Wait(1)
					end
				end)
			end
			function f1_2(x, y, u)
				local obj = New(e1, x, y)
				task.New(obj, function()
					egg.AddSimStrChV(obj, 3, 1, 90 - 90 * u, 90)
					egg.AddSimStrChV(obj, 0, 1.25, -90, 60)
				end)
				atk2(obj)
			end
			function f2(y, u)
				f2_1(-60 * u, 240)
				for _ = 1, 4 do
					f2_2(-224 * u, y, u)
					task.Wait(15)
				end
				f2_1(60 * u, 240, 2)
				for _ = 1, 4 do
					f2_2(-224 * u, y, u)
					task.Wait(15)
				end
				f2_1(0 * u, 240)
				task.Wait(60)
				f2_1(-120 * u, 240, 2)
			end
			function f2_1(x, y, co)
				local obj = New(e2, x, y, co)
				decDmg(obj, 40, 30, 0.1, 1)
				obj.dye_range = 100
				task.New(obj, function()
					egg.AddSimStrChV(obj, 3, 0, -90, 90)
					task.Wait(210)
					egg.AddSimStrChV(obj, 0, 3, 90, 90)
				end)
				task.New(obj, function()
					task.Wait(30)
					atk4(obj)
				end)
			end
			function f2_2(x, y, u)
				local obj = New(e1, x, y, true)
				task.New(obj, function()
					egg.AddAccDecChV(obj, 1.5, -90, 1, 1, 90)
					--egg.AddSimStrChV(obj, 1, 3.5, 90 - 90*u, 90)
					egg.AddAccDecChV(obj, 3, 90 - 90 * u, 90, 60, 60)
					task.Wait(180)
					--往回走了
					egg.AddSimStrChV(obj, 0, 3, 90 + 90 * u, 90)
				end)
				atk6(obj)
			end
		end

		do
			f1(192, 1)
			task.Wait(60)
			f1(192, -1)
			task.Wait(60)
			f1(192, 1)
			task.Wait(60)
			f1(192, -1)
			task.Wait(60)
			f1(192, 1)
			task.Wait(60)
			f1(192, -1)
			task.Wait(180)
			f2(150, 1)
			task.Wait(240)
			f2(150, -1)
		end
	end
	while self.timer < 7820 do
		task.Wait(1)
	end
	do
		for _, unit in ObjList(GROUP_NONTJT) do
			_del(unit, true)
		end
		for _, unit in ObjList(GROUP_ENEMY_BULLET) do
			_del(unit, true)
		end
	end
	s1_boss.main() --一boss
	task.Wait(120)
	system.makeSettlement(1)
	task.Wait(120)
end
s1_road.main = road
