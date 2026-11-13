s2_road = {}

local path = "EISlib/stage/stage2/"
Include(path .. "s2_boss_defined.lua")

--资源加载
do
	local path = "res/stage/stage2/s2title/"
	LoadImageFromFile("s2_t1", path .. "s2_t1.png")
	LoadImageFromFile("s2_t2", path .. "s2_t2.png")
	LoadImageFromFile("s2_t3", path .. "s2_t3.png")
	LoadImageFromFile("s2_t4", path .. "s2_t4.png")
end
----------------------------------标题
local s2_title
do
	local size, t0, t1, t2 = 0.8, 90, 60, 60
	local s2_t1 = Class(object)
	function s2_t1:init(x, y)
		self.x, self.y = x, y
		self.img = "s2_t1"
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
	function s2_t1:frame()
		task.Do(self)
	end
	function s2_t1:render()
		SetImgState(self, "", self._a, self._r, self._g, self._b)
		Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
	end
	local s2_t2 = Class(object)
	function s2_t2:init(x, y)
		self.x, self.y = x, y
		self.img = "s2_t2"
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
	function s2_t2:frame()
		task.Do(self)
	end
	function s2_t2:render()
		SetImgState(self, "", self._a, self._r, self._g, self._b)
		Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
	end
	local s2_t3 = Class(object)
	function s2_t3:init(x, y)
		self.x, self.y = x, y
		self.img = "s2_t3"
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
	function s2_t3:frame()
		task.Do(self)
	end
	function s2_t3:render()
		SetImgState(self, "", self._a, self._r, self._g, self._b)
		Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
	end
	local s2_t4 = Class(object)
	function s2_t4:init(x, y)
		self.x, self.y = x, y
		self.img = "s2_t4"
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
	function s2_t4:frame()
		task.Do(self)
	end
	function s2_t4:render()
		SetImgState(self, "", self._a, self._r, self._g, self._b)
		Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
	end
	function s2_title()
		local x, y = 0, 100
		New(s2_t1, x - 130 * size, y + 0)
		New(s2_t4, x + 80 * size, y - 5 * size)
		New(s2_t2, x + 160 * size, y - 36 * size)
		New(s2_t3, x + 60 * size, y + 20 * size)
	end
end
----------------------------------特殊obj定义
--背景里的萤火虫(素材在背景res里
local path = "res/background/stage2/"
LoadImageFromFile('s2_firefly', path .. 's2_firefly.png')
local firefly, firefly2, spawn_firefly, spawn_ghost_firefly
do
	firefly = Class(object)
	function firefly:init()
		self.x = ran:Float(-150, 150)
		self.y = ran:Float(-150, 150) + 30
		self.group = GROUP_GHOST
		self.layer = LAYER_BG
		self.hide = false
		self.img = 's2_firefly'
		self.size = ran:Float(0.4, 0.6)
		self.alpha = 0
		SetImageState(self.img, "", Color(0, 80, 117, 0))
		SetV(self, ran:Float(0.1, 0.3), ran:Float(-30, 210))
	end
	function firefly:frame()
		if self.timer <= 120 then
			self.alpha = self.timer * 120 / 120
		elseif self.timer > 120 and self.timer <= 240 then
			self.alpha = 120 * (1 - (self.timer - 120) / 120)
		elseif self.timer > 240 then
			Del(self)
		end
	end
	function firefly:render()
		SetImageState(self.img, "", Color(self.alpha, 80, 117, 0))
		Render(self.img, self.x, self.y, self.rot, self.size)
	end
	--小怪出场的萤火虫
	function spawn_firefly(x, y, num)
		local r, a
		for _ = 1, num do
			r, a = ran:Float(0, 10), ran:Float(0, 360)
			New(firefly2, x + r * cos(a), y + r * sin(a))
		end
	end
	--鬼火出场的萤火虫
	function spawn_ghost_firefly(x, y)
		local r, a
		for _ = 1, 50 do
			r, a = ran:Float(15, 30), ran:Float(0, 360)
			New(firefly2, x + r * cos(a), y + r * sin(a), nil, nil, nil, nil, { 74, 233, 255 })
		end
	end
	--鬼火出场的萤火虫
	firefly2 = Class(object)
	function firefly2:init(x, y, t0, t1, v, size, co)
		self.x = x
		self.y = y
		self.group = GROUP_GHOST
		self.layer = LAYER_BG
		self.hide = false
		self.img = 's2_firefly'
		if size then
			self.size = ran:Float(size[1] or 0.4, size[2] or 0.6)
		else
			self.size = ran:Float(0.4, 0.6)
		end
		self.alpha = 0
		if co and co[1] and co[2] and co[3] then
			self.co = { co[1], co[2], co[3] }
		else
			self.co = { 240, 255, 0 }
		end
		SetImageState(self.img, "mul+add", Color(0, self.co[1], self.co[2], self.co[3]))
		self._w = ran:Sign() * ran:Float(0.4, 1.2)
		self.angle = ran:Float(0, 360)
		if v then
			self.v = ran:Float(v[1] or 0.5, v[2] or 0.6)
		else
			self.v = ran:Float(0.5, 0.6)
		end
		self.t0 = t0 or 120 --萤火虫从出现到移动到点的时间
		self.t1 = t1 or 45 --萤火虫移动到点到消失的时间
		self.t2 = self.t0 + self.t1 --萤火虫存在的总时间
		for _ = 1, self.t0 do
			SetV(self, self.v, self.angle)
			self.x = self.x + self.vx
			self.y = self.y + self.vy
			self.angle = self.angle + self._w
		end
		self.angle = self.angle + 180
		self._w = -self._w
	end
	function firefly2:frame()
		SetV(self, self.v, self.angle)
		self.angle = self.angle + self._w

		if self.timer <= self.t0 then
			self.alpha = self.timer * 200 / self.t0
		elseif self.timer > self.t0 and self.timer <= self.t2 then
			local rate = (1 - (self.timer - self.t0) / self.t1)
			self.alpha, self.size = 200 * rate, self.size - self.size / self.t1
		elseif self.timer > self.t2 then
			Del(self)
		end
	end
	function firefly2:render()
		SetImageState(self.img, "mul+add", Color(self.alpha, self.co[1], self.co[2], self.co[3]))
		Render(self.img, self.x, self.y, self.rot, self.size)
	end
end
-----------------------------------特殊函数定义
--设置线性减伤
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
--生成常用加速弹
local function accbullet(st, co, x, y, v, a, t)
	local obj = stg.newBulletStraight(st, co, true, x, y, 0, a)
	egg.AddSimStrChV(obj, 0, v, a, t)
	return obj
end
--设置出屏等待
local function boundWait(self, t)
	self.bound = false
	t = t or 90
	--出屏
	task.New(self, function()
		task.Wait(t)
		self.bound = true
	end)
end
-----------------------------------特殊子弹攻击定义
local atk1, atk2
--一圈妖精的大蝴蝶的弹幕
function atk1(self)
	task.New(self, function()
		--攻击
		if difficulty == 1 then
			task.Wait(100)
			local a = Angle(self, player)
			PlaySound("kira00")
			for u = 1, -1, -2 do
				for j = 1, 2 do
					for i = 1, (2-j) do
						stg.newBulletStraight(stg.ball_mid, 1, true, self.x, self.y, 0.8 + 0.1*i, a + (24 + 36*j)*u)
					end
				end
			end
			--一排
			local lastGroup, count, a0
			lastGroup = {}
			a = Angle(self, player)
			for j = 0, 0 do
				a0 = a + 120*j
				lastGroup, count = qingLan1(self.x, self.y, 3, 0, -0.1, a0, 9, kite_b, 1)
				for i = 1, count do
					lastGroup[i].vscale = 0.75
					egg.AddSimStrChV(lastGroup[i], 2, 1, a0, 30)
				end
			end
		elseif difficulty == 2 then
			task.Wait(90)
			local a = Angle(self, player)
			PlaySound("kira00")
			for u = 1, -1, -2 do
				for j = 1, 4 do
					for i = 1, (4-j) do
						stg.newBulletStraight(stg.ball_mid, 1, true, self.x, self.y, 0.8 + 0.1*i, a + (15 + 18*j)*u)
					end
				end
			end
			--一排
			local lastGroup, count, a0
			lastGroup = {}
			a = Angle(self, player)
			for j = -1, 1 do
				a0 = a + 120*j
				lastGroup, count = qingLan1(self.x, self.y, 3, 0, -0.1, a0, 9, kite_b, 1)
				for i = 1, count do
					lastGroup[i].vscale = 0.75
					egg.AddSimStrChV(lastGroup[i], 2.5, 1.5, a0, 30)
				end
			end
		elseif difficulty == 3 then
			task.Wait(80)
			local a = Angle(self, player)
			PlaySound("kira00")
			for u = 1, -1, -2 do
				for j = 1, 6 do
					for i = 1, (6-j) do
						stg.newBulletStraight(stg.ball_mid, 1, true, self.x, self.y, 0.8 + 0.1*i, a + (12 + 15*j)*u)
					end
				end
			end
			--一排
			local lastGroup, count, a0
			lastGroup = {}
			a = Angle(self, player)
			for j = -2, 2 do
				a0 = a + 72*j
				lastGroup, count = qingLan1(self.x, self.y, 4, 0, -0.1, a0, 9, kite_b, 1)
				for i = 1, count do
					lastGroup[i].vscale = 0.75
					egg.AddSimStrChV(lastGroup[i], 2.75, 1.75, a0, 30)
				end
			end
		elseif difficulty == 4 then
			task.Wait(80)
			local a = Angle(self, player)
			PlaySound("kira00")
			for u = 1, -1, -2 do
				for j = 1, 8 do
					for i = 1, (8-j) do
						stg.newBulletStraight(stg.ball_mid, 1, true, self.x, self.y, 0.8 + 0.1*i, a + (8 + 12*j)*u)
					end
				end
			end
			--一排
			local lastGroup, count, a0
			lastGroup = {}
			a = Angle(self, player)
			for j = -2, 2 do
				a0 = a + 72*j
				lastGroup, count = qingLan1(self.x, self.y, 5, 0, -0.1, a0, 9, kite_b, 1)
				for i = 1, count do
					lastGroup[i].vscale = 0.75
					egg.AddSimStrChV(lastGroup[i], 3, 2, a0, 30)
				end
			end
		end
	end)
end
--最大蝴蝶的弹幕
function atk2(self, u, t)
	task.New(self, function()
		t = t or 30
		u = u or 1
		if difficulty == 1 then
			task.New(self, function()
				task.Wait(t)
				local a0, a = 0
				for k = 1, 10 do
					for i = 1, 4 do
						a = a0 + (2*i + 28*k)*u
						for j = 1, 6 do
							for m = 0, 0 do
								accbullet(stg.arrow_big, 4, self.x, self.y, 1 + 0.75*m + 0*i, a + 60*j, 60)
							end
						end
						PlaySound('tan00')
						task.Wait(6)
					end
					task.Wait(12)
				end
			end)
		elseif difficulty == 2 then
			task.New(self, function()
				task.Wait(t)
				local a0, a = 0
				for k = 1, 15 do
					for i = 1, 4 do
						a = a0 + (2*i + 28*k)*u
						for j = 1, 8 do
							for m = 0, 0 do
								accbullet(stg.arrow_big, 4, self.x, self.y, 1 + 0.75*m + 0.05*i, a + 45*j, 60)
							end
						end
						PlaySound('tan00')
						task.Wait(4)
					end
					task.Wait(8)
				end
			end)
		elseif difficulty == 3 then
			task.New(self, function()
				task.Wait(t)
				local a0, a = 0
				for k = 1, 15 do
					for i = 1, 4 do
						a = a0 + (2*i + 28*k)*u
						for j = 1, 8 do
							for m = 0, 1 do
								accbullet(stg.arrow_big, 4, self.x, self.y, 1 + 0.75*m + 0.075*i, a + 45*j, 60)
							end
						end
						PlaySound('tan00')
						task.Wait(4)
					end
					task.Wait(8)
				end
			end)
		elseif difficulty == 4 then
			task.New(self, function()
				task.Wait(t)
				local a0, a = 0
				for k = 1, 20 do
					for i = 1, 4 do
						a = a0 + (2*i + 28*k)*u
						for j = 1, 8 do
							for m = 0, 1 do
								accbullet(stg.arrow_big, 4, self.x, self.y, 1.25 + 1*m + 0.1*i, a + 45*j, 60)
								--obj = stg.newBulletStraight(stg.arrow_big, 4, true, self.x, self.y, 0, a + 45*j)
								--egg.AddSimStrChV(obj, 0, 5 + 0.125*i, a + 45*j, 60)
							end
						end
						PlaySound('tan00')
						task.Wait(3)
					end
					task.Wait(8)
				end
			end)
		end
	end)
end
----------------------------------小怪定义
local e1, e2, e3, e4, e5, e6
e1 = Class(enemy)--发射大范围扩散弹的妖精
function e1:init(x, y, st, hp, IsnDye)
	--dt是等待时间之差，esAngle是小怪离场后的方向
	self.x, self.y = x, y
	if IsnDye then
		enemy.init(self, st, hp, false, true, false, false, nil, 0, 1)
	else
		enemy.init(self, st, hp, false, true, false, false, 3, 0, 1)
	end
	self.group = GROUP_NONTJT
	self.colli = false
	task.New(self, function()
		--出现
		SimAlpCh(self, 0, 255, 30) --透明度变化的函数
		task.Wait(30)
		self.colli = true
		--发射弹幕

		--离开

	end)
end
function e1:atk1(way, a, t)
	if difficulty == 1 then
		task.New(self, function()
			task.Wait(t + 60)
			local lastGroup, count, a0, dsp
			dsp = 55
			lastGroup = {}
			a0 = a + 0.5 * (way - 1) * dsp
			PlaySound("kira00", 0.5, self.x / 256, false)
			for _ = 1, way do
				lastGroup, count = qingLan1(self.x, self.y, 2, 0, -0.05, a0, 9, kite_b, 5)
				for i = 1, count do
					lastGroup[i].vscale = 0.75
					egg.AddSimStrChV(lastGroup[i], 2, 1, a0, 30)
				end
				a0 = a0 - dsp
			end
		end)
	elseif difficulty == 2 then
		task.New(self, function()
			task.Wait(t + 50)
			local lastGroup, count, a0, dsp
			dsp = 55
			lastGroup = {}
			a0 = a + 0.5 * (way - 1) * dsp
			PlaySound("kira00", 0.5, self.x / 256, false)
			for _ = 1, way do
				lastGroup, count = qingLan1(self.x, self.y, 3, 0, -0.05, a0, 9, kite_b, 5)
				for i = 1, count do
					lastGroup[i].vscale = 0.75
					egg.AddSimStrChV(lastGroup[i], 2.5, 1.5, a0, 30)
				end
				a0 = a0 - dsp
			end
		end)
	elseif difficulty == 3 then
		task.New(self, function()
			task.Wait(t + 40)
			local lastGroup, count, a0, dsp
			dsp = 55
			lastGroup = {}
			a0 = a + 0.5 * (way - 1) * dsp
			PlaySound("kira00", 0.5, self.x / 256, false)
			for _ = 1, way do
				lastGroup, count = qingLan1(self.x, self.y, 4, 0, -0.05, a0, 9, kite_b, 5)
				for i = 1, count do
					lastGroup[i].vscale = 0.75
					egg.AddSimStrChV(lastGroup[i], 2.75, 1.75, a0, 30)
				end
				a0 = a0 - dsp
			end
		end)
	elseif difficulty == 4 then
		task.New(self, function()
			task.Wait(t + 30)
			local lastGroup, count, a0, dsp
			dsp = 55
			lastGroup = {}
			a0 = a + 0.5 * (way - 1) * dsp
			PlaySound("kira00", 0.5, self.x / 256, false)
			for _ = 1, way do
				lastGroup, count = qingLan1(self.x, self.y, 5, 0, -0.05, a0, 9, kite_b, 5)
				for i = 1, count do
					lastGroup[i].vscale = 0.75
					egg.AddSimStrChV(lastGroup[i], 3, 2, a0, 30)
					--egg.AddSimStrChV(lastGroup[i], 0, 1, a0, 180, 90)
				end
				a0 = a0 - dsp
			end
		end)
	end
end
function e1:move1(dt, esAngle)
	task.New(self, function()
		task.Wait(dt)
		egg.SimStrChV(self, 0, 1.5, esAngle, 240)
	end)
end
function e1:move2(v, t)
	task.New(self, function()
		task.Wait(30)
		egg.SimStrChV(self, 0, v, -90, t)
	end)
end
function e1:kill()
	enemy.kill(self)
	if not (self.sys_co == 1 or self.sys_co == 2) then
		if Dist(self, player) >= 30 then
			if difficulty == 1 then
			elseif difficulty == 2 then
				local lastGroup, count, a0
				lastGroup = {}
				a0 = Angle(self, player)
				PlaySound("kira00", 0.5, self.x / 256, false)
				lastGroup, count = qingLan1(self.x, self.y, 3, 3.5, -0.08, a0, 1, arrow_small, 1)
				for i = 1, count do
					lastGroup[i].vscale = 0.75
					egg.AddSimStrChV(lastGroup[i], 0, -2.5, a0, 30)
				end
			elseif difficulty == 3 then
				local lastGroup, count, a0
				lastGroup = {}
				a0 = Angle(self, player)
				PlaySound("kira00", 0.5, self.x / 256, false)
				lastGroup, count = qingLan1(self.x, self.y, 4, 4, -0.1, a0, 1, arrow_small, 1)
				for i = 1, count do
					lastGroup[i].vscale = 0.75
					egg.AddSimStrChV(lastGroup[i], 0, -2.5, a0, 30)
				end
			elseif difficulty == 4 then
				local lastGroup, count, a0
				lastGroup = {}
				a0 = Angle(self, player)
				PlaySound("kira00", 0.5, self.x / 256, false)
				lastGroup, count = qingLan1(self.x, self.y, 5, 5, -0.2, a0, 1.5, arrow_small, 1)
				for i = 1, count do
					lastGroup[i].vscale = 0.75
					egg.AddSimStrChV(lastGroup[i], 0, -2.5, a0, 30)
				end
			end
		end
	end
end

e2 = Class(enemy)--开花弹蝴蝶
function e2:init(x, y, st, hp, co, range)
	--dt是等待时间之差，esAngle是小怪离场后的方向
	self.x, self.y = x, y
	self.colli = false
	self.dmgrate = 0.1
	enemy.init(self, st, hp, false, true, false, true, co or 1, range or 80, 1)
	self.group = GROUP_NONTJT
	--出现演出
	task.New(self, function()
		egg.SimAlpCh(self, 0, 255, 30) --透明度变化的函数
		task.Wait(30)
		self.colli = true
	end)
	--发射弹幕
	atk1(self)
	--减伤
	decDmg(self, 30, 30, 0.1, 1)
end
function e2:move1(dt, esAngle)
	task.New(self, function()
		task.Wait(270 + dt)
		egg.SimStrChV(self, 0, 0.5, esAngle, 60)
	end)
end
function e2:move2(u)
	task.New(self, function()
		task.Wait(30)
		egg.SimStrChV(self, 0, 0.8, 90 - 105 * u, 60)
	end)
end
function e2:move3()
	task.New(self, function()
		task.Wait(420)
		for _ = 1, 200 do
			self.vy = self.vy - 0.005
			task.Wait(1)
		end
	end)
end

e3 = Class(enemy)
function e3:init(x, y, IsnDye)
	self.x, self.y = x, y
	self.omiga = 3
	if IsnDye then
		enemy.init(self, 15, 15, false, true, false, false, nil, 0, 1)
	else
		enemy.init(self, 15, 15, false, true, false, false, 3, 0, 1)
	end
	self.group = GROUP_NONTJT
	--移动指令
	--攻击
end
--毛玉的移动方式
--u为1时移动方向向左，建议a0只取-30~30范围，u为-1时则是完全对称移动,draw表示是否描绘路径，如果是，则返回每帧移动路径表
function e3:move1(a0, u, draw)
	local a, da, v, x, dx, t0, t1
	t0, t1 = 135, 90
	a, da, x, dx = 90 + u * (a0 - 90), 120 * u / t0, 0, 90 * u / t0
	if draw == true then
		local road, i, _x, _y = {}, 0, self.x, self.y
		for _ = 1, t0 do
			i = i + 1
			road[i] = {}
			a = a + da
			x = x + dx
			v = 0.5 + 5 * abs(cos(x))
			SetV(self, v, a)
			_x = _x + self.vx
			_y = _y + self.vy
			road[i][1], road[i][2] = _x, _y
		end
		da, dx = 190 * u / t1, 90 * u / t1
		for _ = 1, t1 do
			i = i + 1
			road[i] = {}
			a = a + da
			x = x + dx
			v = 0.5 + 2.5 * abs(cos(x))
			SetV(self, v, a)
			_x = _x + self.vx
			_y = _y + self.vy
			road[i][1], road[i][2] = _x, _y
		end
		return road --返回每帧的路径表
	else
		task.New(self, function()
			for _ = 1, t0 do
				a = a + da
				x = x + dx
				v = 0.5 + 5 * abs(cos(x))
				SetV(self, v, a)
				--self.x = self.x + self.vx
				--self.y = self.y + self.vy
				--stg.newBulletStraight(stg.grain_a, 1, true, self.x, self.y, 0, 0, 0)
				task.Wait(1)
			end
			da, dx = 190 * u / t1, 90 * u / t1
			for _ = 1, t1 do
				a = a + da
				x = x + dx
				v = 0.5 + 2.5 * abs(cos(x))
				SetV(self, v, a)
				--self.x = self.x + self.vx
				--self.y = self.y + self.vy
				--stg.newBulletStraight(stg.grain_a, 1, true, self.x, self.y, 0, 0, 0)
				task.Wait(1)
			end
		end)
	end
end
function e3:move2(u)
	local vx0, vx1, t0, vy, t1 = 6, -6, 240, -2, 60
	task.New(self, function()
		egg.AddSimStrChV(self, vx0, vx1, 90 - 90 * u, t0)
		task.Wait(0.5 * (t0 - t1))
		egg.AddSimStrChV(self, 0, vy, 90, 0.5 * t1)
		task.Wait(0.5 * t1)
		egg.AddSimStrChV(self, 0, -vy, 90, 0.5 * t1)
	end)
end
function e3:move3(u)
	task.New(self, function()
		self.vx = 2 * u
		task.Wait(70)
		for _ = 1, 90 do
			self.vy = self.vy - 0.02
			task.Wait(1)
		end
	end)
end
function e3:atk1()
	if difficulty == 1 then
		task.New(self, function()
			local a
			task.Wait(90 + ran:Int(0, 20))
			for _ = 1, 1 do
				a = Angle(self, player)
				for i = 0, 0 do
					for j = 0, 0 do
						for u = 0, 1 do
							accbullet(stg.ball_mid_c, 10, self.x, self.y, 1.5+ 0.5*i, a + 180*u + 2*j, 60)
						end
					end
				end
				PlaySound('tan00')
				task.Wait(90)
			end
		end)
	elseif difficulty == 2 then
		task.New(self, function()
			local a
			task.Wait(90 + ran:Int(0, 20))
			for _ = 1, 1 do
				a = Angle(self, player)
				for i = 0, 0 do
					for j = -1, 1 do
						for u = 0, 2 do
							accbullet(stg.ball_mid_c, 10, self.x, self.y, 1.75 + 0.5*i, a + 120*u + 2*j, 60)
						end
					end
				end
				PlaySound('tan00')
				task.Wait(90)
			end
		end)
	elseif difficulty == 3 then
		task.New(self, function()
			local a
			task.Wait(80 + ran:Int(0, 20))
			for _ = 1, 2 do
				a = Angle(self, player)
				for i = 0, 0 do
					for j = -2, 2 do
						for u = 0, 2 do
							accbullet(stg.ball_mid_c, 10, self.x, self.y, 2 + 0.5*i, a + 120*u + 2*j, 60)
						end
					end
				end
				PlaySound('tan00')
				task.Wait(90)
			end
		end)
	elseif difficulty == 4 then
		task.New(self, function()
			local a
			task.Wait(70 + ran:Int(0, 20))
			for _ = 1, 2 do
				a = Angle(self, player)
				for i = 0, 1 do
					for j = -2, 2 do
						for u = 0, 3 do
							--stg.newBulletStraight(stg.ball_mid_c, 10, true, self.x, self.y, 1 + 0.5*i, a + 90*u + 4*j)
							accbullet(stg.ball_mid_c, 10, self.x, self.y, 2 + 0.5*i, a + 90*u + 4*j, 60)
						end
					end
				end
				PlaySound('tan00')
				task.Wait(90)
			end
		end)
	end
end
function e3:atk2()
	if difficulty == 1 then
		task.New(self, function()
			local a
			task.Wait(90 + ran:Int(0, 20))
			for _ = 1, 1 do
				a = Angle(self, player)
				for i = 0, 0 do
					for j = 0, 0 do
						for u = 0, 1 do
							accbullet(stg.ball_mid_c, 10, self.x, self.y, 1.5+ 0.5*i, a + 180*u + 2*j, 60)
						end
					end
				end
				PlaySound('tan00')
				task.Wait(90)
			end
		end)
	elseif difficulty == 2 then
		task.New(self, function()
			local a
			task.Wait(90 + ran:Int(0, 20))
			for _ = 1, 1 do
				a = Angle(self, player)
				for i = 0, 0 do
					for j = -1, 1 do
						for u = 0, 2 do
							accbullet(stg.ball_mid_c, 10, self.x, self.y, 1.75 + 0.5*i, a + 120*u + 2*j, 60)
						end
					end
				end
				PlaySound('tan00')
				task.Wait(90)
			end
		end)
	elseif difficulty == 3 then
		task.New(self, function()
			local a
			task.Wait(80 + ran:Int(0, 20))
			for _ = 1, 2 do
				a = Angle(self, player)
				for i = 0, 0 do
					for j = -2, 2 do
						for u = 0, 2 do
							accbullet(stg.ball_mid_c, 10, self.x, self.y, 2 + 0.5*i, a + 120*u + 2*j, 60)
						end
					end
				end
				PlaySound('tan00')
				task.Wait(90)
			end
		end)
	elseif difficulty == 4 then
		task.New(self, function()
			local a
			task.Wait(70 + ran:Int(0, 20))
			for _ = 1, 2 do
				a = Angle(self, player)
				for i = 0, 1 do
					for j = -2, 2 do
						for u = 0, 3 do
							--stg.newBulletStraight(stg.ball_mid_c, 10, true, self.x, self.y, 1 + 0.5*i, a + 90*u + 4*j)
							accbullet(stg.ball_mid_c, 10, self.x, self.y, 2 + 0.5*i, a + 90*u + 4*j, 60)
						end
					end
				end
				PlaySound('tan00')
				task.Wait(90)
			end
		end)
	end
end
function e3:kill()
	enemy.kill(self)
	if not (self.sys_co == 1 or self.sys_co == 2) then
		if Dist(self, player) >= 50 then
			local last
			if difficulty == 1 then

			elseif difficulty == 2 then
				local _x, _y = self.x, self.y
				local dv, a0, a = 0, Angle(self, player) + 45
				New(tasker, function()
					for _ = 1, 2 do
						a = a0
						for _ = 1, 2 do
							last = stg.newBulletStraight(stg.arrow_small, 10, true, _x, _y, dv, a)
							AddSimStrChV(last, 0, 2, a, 60, nil, nil, 45)
							a = a - 90
						end
						dv = dv + 0.25
						task.Wait(4)
					end
				end)
			elseif difficulty == 3 then
				local _x, _y = self.x, self.y
				local dv, a0, a = 0, Angle(self, player) + 45
				New(tasker, function()
					for _ = 1, 2 do
						a = a0
						for _ = 1, 3 do
							last = stg.newBulletStraight(stg.arrow_small, 10, true, _x, _y, dv, a)
							AddSimStrChV(last, 0, 2, a, 60, nil, nil, 45)
							a = a - 45
						end
						dv = dv + 0.25
						task.Wait(4)
					end
				end)
			elseif difficulty == 4 then
				local _x, _y = self.x, self.y
				local dv, a0, a = 0, Angle(self, player) + 45
				New(tasker, function()
					for _ = 1, 4 do
						a = a0
						for _ = 1, 3 do
							last = stg.newBulletStraight(stg.arrow_small, 10, true, _x, _y, dv, a)
							AddSimStrChV(last, 0, 2, a, 60, nil, nil, 45)
							a = a - 45
						end
						dv = dv + 0.25
						task.Wait(4)
					end
				end)
			end
		end
	end
end

--发射大量弹幕的大蝴蝶
e4 = Class(enemy)
function e4:init(x, y, hp, co, range, u)
	self.x, self.y = x, y
	--self.t = 60
	range = range or 100
	hp = hp or 200
	--[[local st
	if co == 1 then
		st = 9
	elseif co == 2 then
		st = 10
	else
		st = 12
	end]]
	co = co or 1
	enemy.init(self, 9, hp, false, true, false, true, co, range, 1)
	self.group = GROUP_NONTJT
	--移动手动添加
	--攻击
end
function e4:move1()
	self.t = 60
	task.New(self, function()
		egg.SimStrChV(self, 4, 0, -90, 60)
		task.Wait(300)
		egg.SimStrChV(self, 0, 4, 90, 120)
	end)
end
function e4:move2(u)
	self.t = 120
	task.New(self, function()
		egg.SimStrChV(self, 2, 0.25, 90 + 80 * u, 120)
		task.Wait(420)
		egg.SimStrChV(self, 0, 3, 90 + 110 * u, 120)
	end)
end

e5 = Class(enemy)
function e5:init(x, y, u, t, IsnDye)
	local ang, vv = 90 + ran:Float(9, 15) * u, ran:Float(1, 1.1)
	local r = vv * t
	self.x, self.y = x - r * cos(ang), y - r * sin(ang)
	vv = 2 * vv
	self.hide = true
	self.hscale, self.vscale = 0, 0
	self.t = t
	if IsnDye then
		enemy.init(self, 4, 20, false, false, false, false, nil, 0, 1)
	else
		enemy.init(self, 4, 20, false, false, false, false, 3, 0, 1)
	end
	self.group = GROUP_NONTJT
	--出屏
	boundWait(self, 180)
	self.colli = false
	task.New(self, function()
		self.hide = false
		SimAlpRGBCh(self, t)
		egg.SimSizeCh(self, 0.5, 1, t)
		--移动到本应移动到的位置
		local dv, dx, dy = vv / t, cos(ang), sin(ang)
		for _ = 1, t do
			self.x = self.x + vv*dx
			self.y = self.y + vv*dy
			task.Wait(1)
			vv = vv - dv
		end
		task.Wait(t)
		self.colli = true
	end)
end
function e5:move1(u)
	task.New(self, function()
		task.Wait(self.t)
		egg.SimStrChV(self, 0, 0.6, 90 + 95 * u, 360)
		task.Wait(360)
		egg.SimStrChV(self, 0.6, 1.2, 90 + 95 * u, 120)
	end)
end
function e5:move2(a)
	egg.SimStrChV(self, 0, 2.25, a, 120)
end
function e5:atk1()
	local a
	if difficulty == 1 then
		task.New(self, function()
			task.Wait(self.t)
			for _ = 1, 1 do
				a = Angle(self, player)
				for i = 0, 0 do
					for j = 0, 0 do
						accbullet(stg.ball_mid, 5, self.x, self.y, 1.25 + 0.45*j, a + 45*i, 60)
					end
				end
				task.Wait(120)
			end
		end)
	elseif difficulty == 2 then
		task.New(self, function()
			task.Wait(self.t)
			for _ = 1, 2 do
				a = Angle(self, player)
				for i = -1, 1 do
					for j = 0, 0 do
						accbullet(stg.ball_mid, 5, self.x, self.y, 1.25 + 0.45*j, a + 45*i, 60)
					end
				end
				task.Wait(120)
			end
		end)
	elseif difficulty == 3 then
		task.New(self, function()
			task.Wait(self.t)
			for _ = 1, 2 do
				a = Angle(self, player)
				for i = -2, 2 do
					for j = 0, 1 do
						accbullet(stg.ball_mid, 5, self.x, self.y, 1.25 + 0.45*j, a + 45*i, 60)
					end
				end
				task.Wait(120)
			end
		end)
	elseif difficulty == 4 then
		task.New(self, function()
			task.Wait(self.t)
			for _ = 1, 2 do
				a = Angle(self, player)
				for i = -3, 3 do
					for j = 0, 2 do
						accbullet(stg.ball_mid, 5, self.x, self.y, 1.25 + 0.45*j, a + 30*i, 60)
					end
				end
				task.Wait(120)
			end
		end)
	end
end
function e5:atk2()
	local a
	if difficulty == 1 then
		--看什么看？没有子弹啦
	elseif difficulty == 2 then
		task.New(self, function()
			task.Wait(self.t)
			for _ = 1, 2 do
				a = Angle(self, player)
				for i = -1, 1 do
					for j = 0, 0 do
						accbullet(stg.ball_mid, 6, self.x, self.y, 1.25 + 0.5*j, a + 90*i, 90)
					end
				end
				task.Wait(ran:Int(80, 90))
			end
		end)
	elseif difficulty == 3 then
		task.New(self, function()
			task.Wait(self.t)
			for _ = 1, 2 do
				a = Angle(self, player)
				for i = -2, 2 do
					for j = 0, 0 do
						accbullet(stg.ball_mid, 6, self.x, self.y, 1.5 + 0.5*j, a + 60*i, 90)
					end
				end
				task.Wait(ran:Int(80, 90))
			end
		end)
	elseif difficulty == 4 then
		task.New(self, function()
			task.Wait(self.t)
			for _ = 1, 2 do
				a = Angle(self, player)
				for i = -2, 2 do
					for j = 0, 1 do
						accbullet(stg.ball_mid, 6, self.x, self.y, 1.5 + 0.5*j, a + 60*i, 90)
					end
				end
				task.Wait(ran:Int(80, 90))
			end
		end)
	end
end
function e5:kill()
	enemy.kill(self)
	if not (self.sys_co == 1 or self.sys_co == 2) then
		if Dist(self, player) >= 30 then
			local v, a, da, last
			if difficulty == 1 then

			elseif difficulty == 2 then
				v = 2
				a = -90
				last = stg.newBulletStraight(stg.arrow_small, 1, true, self.x, self.y, -0.25, a)
				egg.AddSimStrChV(last, 0, v, a, 60, 55)
			elseif difficulty == 3 then
				a = -90 + 2.5
				da = -2.5
				for _ = 1, 3 do
					v = 2
					for _ = 1, 1 do
						last = stg.newBulletStraight(stg.arrow_small, 1, true, self.x, self.y, -0.25, a)
						egg.AddSimStrChV(last, 0, v, a, 60, 45)
						v = v + 0.3
					end
					a = a + da
				end
			elseif difficulty == 4 then
				a = -90 + 6 + ran:Float(-2, 2)
				for i = -2, 2 do
					for j = 0, 2 do
						accbullet(stg.arrow_small, 5, self.x, self.y, 0.8 + 0.4*j, a - 15*i, 90)
					end
				end
			end
		end
	end
end

e6 = Class(enemy)
function e6:init(mst, a, co)
	--self.colli = false
	enemy.init(self, 20, 30, false, false, true, false, co, 0, 1)
	self.group = GROUP_NONTJT
	self.x, self.y = mst.x + mst.range*cos(a + mst.angle), mst.y + mst.range*sin(a + mst.angle)

	task.New(self, function()
		while IsValid(mst) do
			self.x, self.y = mst.x + mst.range*cos(a + mst.angle), mst.y + mst.range*sin(a + mst.angle)
			task.Wait(1)
		end
		local v, a = Dist(0, 0, self.dx, self.dy), Angle(0, 0, self.dx, self.dy)
		egg.AddSimStrChV(self, v, v + 1, a, 120)

		--egg.AddSimStrChV(self, 1, 0.75, a, 120)
		--egg.AddSimStrChV(self, 0, 0.5, a + 90 * u, 30)
	end)
	--攻击
	task.New(self, function()
		local diff = difficulty
		if diff == 4 then
			local a0
			task.Wait(10)
			for _ = 1, 15 do
				if IsValid(mst) then
					a0 = a + mst.angle + 180
				else
					a0 = Angle(0, 0, self.dx, self.dy) + 180
				end
				for i = 0, 1 do
					accbullet(stg.arrow_big, 6 + 2*i, self.x, self.y, 1.25 + 0.25*i, a0, 90)
				end
				task.Wait(12)
				PlaySound("kira00")
			end
		elseif diff == 3 then
			local a0
			task.Wait(20)
			for _ = 1, 12 do
				if IsValid(mst) then
					a0 = a + mst.angle + 180
				else
					a0 = Angle(0, 0, self.dx, self.dy) + 180
				end
				for i = 0, 0 do
					accbullet(stg.arrow_big, 6 + 2*i, self.x, self.y, 1.25 + 0.25*i, a0, 90)
				end
				task.Wait(15)
				PlaySound("kira00")
			end
		elseif diff == 2 then
			local a0
			task.Wait(30)
			for _ = 1, 9 do
				if IsValid(mst) then
					a0 = a + mst.angle + 180
				else
					a0 = Angle(0, 0, self.dx, self.dy) + 180
				end
				for i = 0, 0 do
					accbullet(stg.arrow_big, 6 + 2*i, self.x, self.y, 1 + 0.25*i, a0, 90)
				end
				task.Wait(20)
				PlaySound("kira00")
			end
		else
			local a0
			task.Wait(50)
			for _ = 1, 3 do
				if IsValid(mst) then
					a0 = a + mst.angle + 180
				else
					a0 = Angle(0, 0, self.dx, self.dy) + 180
				end
				for i = 0, 0 do
					accbullet(stg.arrow_big, 6 + 2*i, self.x, self.y, 1 + 0.25*i, a0, 90)
				end
				task.Wait(60)
				PlaySound("kira00")
			end
		end
	end)
end
function e6:kill()
	e3.kill(self)
end

--鬼火召唤术
local function spawnGhostFire(x, y, mst, a, co)
	local obj = stg.newBulletStraight(stg.ball_light, 10, true, x, y, 0, 0)
	_object.set_color(obj, "mul+add", 0, 255, 255, 255)
	obj.colli = false
	--egg.AddSimStrChV(obj, 2, 0.8 + dv, a, 30)
	task.New(obj, function()
		egg.SimSizeCh(obj, 2, 0, 60)
		egg.SimAlpCh(obj, 0, 200, 30)
		task.Wait(30)
		New(e6, mst, a, co)
		egg.SimAlpCh(obj, 200, 0, 30)
		task.Wait(30)
		Del(obj)
	end)
end

--------出怪组合函数
local F1, F2, F3, F4, F5, F6, F7
--第七种出怪组合（鬼火团）
local function s2_ghostfires(x, y, a, u, co)
	local obj = stg.newBulletStraight(stg.arrow_small, 1, true, x, y, 0, a)
	obj.hide = true
	obj.colli = false
	obj.range, obj.angle = -50, 0
	boundWait(obj, 600)
	egg.AddSimStrChV(obj, 1, 0.75, a, 120, 30) --要先等30f(演出
	--egg.AddSimStrChV(obj, 0, 0.5, a + 90 * u, 30)
	local da, dr = 0, 0
	--生成鬼火然后控制鬼火转动
	task.New(obj, function()
		local a
		for i = 1, 8 do
			a = 45*i
			spawnGhostFire(x + obj.range*cos(a), y + obj.range*sin(a), obj, a, co)
		end
		--加速转
		local dda, ddr = 0.75/60*u, 0.45/60
		for _ = 1, 60 do
			da = da + dda
			dr = dr + ddr
			task.Wait(1)
		end
	end)
	--相位和半径更新
	task.New(obj, function()
		while true do
			obj.angle = obj.angle + da
			obj.range = obj.range + dr
			task.Wait(1)
		end
	end)
end
--第一种出怪组合
function F1(x, y, esAngle, u, co)
	--esAngle是小怪离场后的方向
	u = u or 1
	local a, last = -90 + 30 * u
	co = co or 1
	New(tasker, function()
		spawn_firefly(x, y + 40, 10)
		task.Wait(100)
		e2.move1(New(e2, x, y, 5, 40, co), -150, esAngle)
	end)
	New(tasker, function()
		for i = 1, 10 do
			New(tasker, function()
				local _x, _y, _a = x + 50 * cos(a), y + 50 * sin(a), a
				spawn_firefly(_x, _y, 5)
				task.Wait(100)
				last = New(e1, _x, _y, 1, 30)
				e1.atk1(last, 1, _a + 60 * u, -30)
				e1.move1(last, -30 * i, _a + 150 * u)
			end)
			task.Wait(10)
			a = a + 30 * u
		end
	end)
end
--第二种出怪组合
---@param x0  @毛玉生成的横坐标
---@param y0  @毛玉生成的纵坐标
---@param x1  @大蝴蝶生成的横坐标
---@param y1  @大蝴蝶生成的纵坐标
---@param a0  @毛玉初始朝向
---@param u  @与对称性相关的参数，取1或-1
---@param co  @大蝴蝶的颜色
function F2(x0, y0, x1, y1, a0, u)
	local st = { 5, 6 }
	local co = 2
	local f1, f2, f3
	do
		function f1()
			local obj = New(e3, x0, y0)
			e3.move1(obj, a0, u)
			e3.atk1(obj)
		end
		function f2(x, a)
			New(tasker, function()
				spawn_firefly(x * u, -x, 10, 240, 60, { 0.8, 1.2 }, { 0.6, 1.8 })
				task.Wait(90)
				local obj = New(e5, x * u, -x, 1, 20)
				e5.move2(obj, a)
				e5.atk2(obj)
			end)
		end
		--大蝴蝶
		function f3(x, y)
			New(tasker, function()
				spawn_firefly(x, y, 20, 240, 60, { 0.8, 1.2 }, { 0.6, 1.8 })
				task.Wait(90)
				e2.move1(New(e2, x, y, st[co], 50, co), 0, 90)
			end)
		end
	end

	do
		New(tasker, function()
			f3(x1, y1)
			task.Wait(60)
			for _ = 1, 5 do
				f1()
				task.Wait(15)
			end
		end)
		New(tasker, function()
			task.Wait(60)
			local x, a = 60
			if u == 1 then
				a = 135
			else
				a = 45
			end
			f3(-135 * u, 135)
			for _ = 1, 9 do
				f2(x, a)
				task.Wait(10)
				x = x - 15
			end
		end)
	end
end
--第三种出怪组合
---@param x1  number @小妖精生成的横坐标
---@param y1  number @小妖精生成的纵坐标
---@param x2  number @大蝴蝶生成的横坐标
---@param y2  number @大蝴蝶生成的纵坐标
---@param co  number @大蝴蝶的颜色
---@param u  number @与对称性相关的参数，取1或-1
function F3(x1, y1, x2, y2, u)
	New(tasker, function()
		local dt, last = 90
		local co = 2
		--大怪的生成
		e4.move2(New(e4, x1, y1, 70, co, 100, u), u)
		--小怪的生成
		task.Wait(30)
		local a, da = 90 + 60 * u, -120 / 5 * u
		for _ = 1, 6 do
			for u1 = 1, -1, -2 do
				New(tasker, function()
					local _x, _y, _dt = x2 + 80*u1 * cos(a), y2 + 60*u1 * sin(a), dt
					spawn_firefly(_x, _y, 5)
					task.Wait(70)
					last = New(e5, _x, _y, u*u1, _dt)
					e5.move1(last, u*u1)
					e5.atk1(last)
				end)
			end
			task.Wait(10)
			dt = dt - 5
			a = a + da
		end
	end)
end

--第四种出怪组合
function F4(x1, y1, x2, y2, u)
	local st, last = { 5, 6 }
	local co = 1
	New(tasker, function()
		spawn_firefly(x1, y1, 20, 240, 60, { 0.8, 1.2 }, { 0.6, 1.8 })
		task.Wait(90)
		e2.move1(New(e2, x1, y1, st[co], 40, co), 0, 90)
		for _ = 1, 6 do
			last = New(e3, x2, y2, true)
			e3.move2(last, u)
			e3.atk2(last)
			task.Wait(15)
		end
	end)
end

--第五种出怪组合(飞行阵)
local function s2_wave4_enemy1()
	local st = { 5, 6 }
	New(tasker, function()
		local u, y0 = -1, 30
		for i = 1, 6 do
			e2.move2(New(e2, -224 * u, y0, st[i % 2 + 1], 30, 2, 100), u)
			task.Wait(80)
			u = -u
			y0 = y0 + 20
		end
	end)
	local v, t, x0, y0, dx, dy, dt, last = 0.6, 60, 100, 30, -200 / 3, nil, 18
	dy = -v * dt
	local n
	for i = 1, 5 do
		if i == 5 then  --移除最后一层右上角的两只
			n = 2
			for _ = 1, n do
				task.Wait(dt)
				x0 = x0 + dx
				y0 = y0 + dy
			end
		else
			n = 4
		end
		for _ = 1, n do
			New(tasker, function()
				local _x, _y = x0, y0
				spawn_firefly(_x, _y, 5)
				task.Wait(100)
				last = New(e5, _x - 10, _y, 1, 20)
				e1.move2(last, v, t)
				e5.atk2(last)
				last = New(e5, _x + 10, _y, 1, 20)
				e1.move2(last, v, t)
				e5.atk2(last)
			end)
			task.Wait(dt)
			x0 = x0 + dx
			y0 = y0 + dy
		end
		dx = -dx
		x0 = x0 + 0.5 * dx
		y0 = y0 + 100
	end
end



local function road(self)
	local bg
	do
		system.setTargetChain(250)
		dialog.cacheResource("Stage2")
		dialog.cacheResource("Stage2_after")
		LoadMusicRecord("s2")
		LoadMusicRecord("s2_boss")
		bg = New(stage2_background)
	end
	task.Wait(40)
	EISlib.stage.playMusic("s2", 0, true)
	task.Wait(120)
	--开幕
	do
		F1(60, 100, 90, 1, 1)
		task.Wait(130) --420
		F1(-60, 100, 90, -1, 1)
		task.Wait(130)
		F1(60, 0, 90, 1, 1)
		task.Wait(110)
		F1(-60, 0, 90, -1, 1)
		task.Wait(110) --640
		F1(40, 50, 90, 1)
		F1(-40, 50, 90, -1)
		task.Wait(220) --880
		F2(-224, -100, 100, 100, -10, 1)
		task.Wait(300)--1300
		F2(224, -100, -100, 100, -10, -1)
		task.Wait(240)
		F2(-224, -100, 100, 100, -10, 1)
		task.Wait(320)--1720
	end
	s2_title()
	task.Wait(180)--1920
	--p2
	do
		--创建小妖精
		local x0, dt, obj = -70, 90
		for _ = 1, 5 do
			for u = 1, -1, -2 do
				New(tasker, function()
					local _x, _y, _dt = x0, 120 + 24*u, dt
					spawn_firefly(_x, _y, 5)
					task.Wait(70)
					local obj = New(e5, _x, _y, -u, _dt)
					e5.move1(obj, -u)
					e5.atk1(obj)
				end)
			end
			task.Wait(10)
			dt = dt - 5
			x0 = x0 + 35
		end
		task.Wait(110)
		--s2_ghostfires(0, 0, 90, -1, 3)
		task.Wait(70)--2100
		obj = New(e4, 0, 240, 100, 2, 120)
		atk2(obj, 1)
		e4.move1(obj)
		--
		task.Wait(150)
		s2_ghostfires(100, 0, 135, 1, 3)
		task.Wait(70)--2400
		F3(-224, 100, -20, 144, -1)
		--
		task.Wait(150)
		s2_ghostfires(-100, 0, 45, -1, 3)
		task.Wait(70)--2700
		F3(224, 100, 20, 144, 1)
		--
		task.Wait(150)
		s2_ghostfires(100, 0, 135, 1, 3)
		task.Wait(70)--2400
		F3(-224, 100, 0, 144, -1)
		--
		task.Wait(150)
		s2_ghostfires(0, 0, 90, -1, 3)
		task.Wait(70)--2100
		obj = New(e4, 0, 240, 100, 2, 120, 1)
		atk2(obj)
		e4.move1(obj)
		task.Wait(200)--3120
	end
	do
		for _, unit in ObjList(GROUP_NONTJT) do
			Del(unit)
		end
		for _, unit in ObjList(GROUP_ENEMY_BULLET) do
			Del(unit)
		end
	end
	s2_boss.mid()
	--task.Wait(120)
	do
		F1(75, 120, -75)
		task.Wait(60)
		F4(100, 80, -224, 144, 1)
		task.Wait(120)
		F1(35, 70, 90, -1)
		task.Wait(90)
		F1(-35, 70, 90, 1)
		task.Wait(80)

		F1(-75, 120, -105)
		task.Wait(60)
		F4(-100, 80, 224, 144, -1)
		task.Wait(120)
		F1(-35, 70, 90, 1)
		task.Wait(90)
		F1(35, 70, 90, -1)
		task.Wait(120)
	end
	--s2_wave5_enemy1()
	do
		New(tasker, function()
			task.Wait(150)
			local last, obj
			s2_ghostfires(0, 0, 90, -1, 3)
			task.Wait(40)
			obj = New(e4, 0, 240, 70, 2, 120, 1)
			atk2(obj, 1)
			e4.move1(obj)
			task.Wait(150)
			local p = { { -100, 120 }, { -30, 100 }, { 30, 100 }, { 100, 120 } }
			--local st = { 5, 6 }
			for i = 1, 4 do
				New(tasker, function()
					local _i = i
					spawn_firefly(p[_i][1], p[_i][2], 10)
					task.Wait(100)
					e2.move3(New(e2, p[_i][1], p[_i][2], 5, 20, 1))
				end)
				task.Wait(30)
			end
			for _ = 1, 9 do
				for u = -1, 1, 2 do
					last = New(e3, -224, 120 + 24*u)
					e3.move3(last, 1)
					e3.atk2(last)
				end
				task.Wait(12)
			end
			task.Wait(60)
			for _ = 1, 9 do
				for u = -1, 1, 2 do
					last = New(e3, 224, 120 + 24*u)
					e3.move3(last, -1)
					e3.atk2(last)
				end
				task.Wait(12)
			end
			task.Wait(90)
			obj = New(e4, -224, 120, 50, 2, 100, 1)
			atk2(obj, 1, 90)
			e4.move2(obj, -1)
			obj = New(e4, 224, 120, 50, 2, 100, -1)
			atk2(obj, -1, 90)
			e4.move2(obj, 1)
			task.Wait(70)
			s2_ghostfires(0, 20, 60, 1, 3)
			s2_ghostfires(0, 20, 120, -1, 3)
		end)
	end
	task.Wait(1320)
	s2_wave4_enemy1()
	task.Wait(540)
	bg.light = true
	do
		for _, unit in ObjList(GROUP_NONTJT) do
			Del(unit)
		end
		do
			for _ = 1, 90 do
				for _, unit in ObjList(GROUP_ENEMY_BULLET) do
					Del(unit)
				end
				task.Wait(1)
			end
		end
		task.Wait(90)
	end
	s2_boss.main()
	task.Wait(120)
	system.makeSettlement(2)
	task.Wait(120)
end
s2_road.main = road
