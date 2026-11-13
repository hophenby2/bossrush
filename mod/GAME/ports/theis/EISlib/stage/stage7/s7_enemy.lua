--祈华梦ex面道中部分
s7_road = {}
-------------------------------------

local path = "EISlib/stage/stage7/"
Include(path .. "s7_mid_boss_defined.lua")
Include(path .. "s7_boss_defined.lua")

--资源加载
do
	local path = "res/stage/stage7/s7title/"
	LoadImageFromFile("s7_t1", path .. "s7_t1.png")
	LoadImageFromFile("s7_t2", path .. "s7_t2.png")
	LoadImageFromFile("s7_t3", path .. "s7_t3.png")
end
----------------------------------标题
local s7_title
do
	local size, t0, t1, t2 = 0.8, 90, 60, 60
	local s7_t1 = Class(object)
	function s7_t1:init(x, y)
		self.x, self.y = x, y
		self.img = "s7_t1"
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
	function s7_t1:frame()
		task.Do(self)
	end
	function s7_t1:render()
		SetImgState(self, "", self._a, self._r, self._g, self._b)
		Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
	end
	local s7_t2 = Class(object)
	function s7_t2:init(x, y)
		self.x, self.y = x, y
		self.img = "s7_t2"
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
	function s7_t2:frame()
		task.Do(self)
	end
	function s7_t2:render()
		SetImgState(self, "", self._a, self._r, self._g, self._b)
		Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
	end
	local s7_t3 = Class(object)
	function s7_t3:init(x, y)
		self.x, self.y = x, y
		self.img = "s7_t3"
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
	function s7_t3:frame()
		task.Do(self)
	end
	function s7_t3:render()
		SetImgState(self, "", self._a, self._r, self._g, self._b)
		Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
	end
	function s7_title()
		local x, y = 0, 100
		New(s7_t3, x + 40 * size, y - 60 * size)
		New(s7_t2, x - 120 * size, y - 36 * size)
		New(s7_t1, x + 30 * size, y - 20)
	end
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
--设置染色圈范围线性变化
local function dyeRangeCh(self, r1, t)
	local dr = (r1 - self.dye_range)/t
	task.New(self, function()
		for _ = 1, t do
			self.dye_range = self.dye_range + dr
			task.Wait(1)
		end
	end)
end
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
--生成常用抛物线弹幕
local function vaccbullet(st, co, x, y, v0, a0, v1, a1, t)
	local obj = stg.newBulletStraight(st, co, true, x, y, 0, a0)
	egg.AddSimStrChV(obj, 0, v0, a0, 30)
	egg.AddSimStrChV(obj, 0, v1, a1, t, 40)
	obj.navi = true
	return obj
end
--清除弹幕和小怪
local function clearEnemyAndBullet()
	New(tasker, function()
		for _ = 1, 10 do
			for _, unit in ObjList(GROUP_NONTJT) do
				Del(unit)
			end
			for _, unit in ObjList(GROUP_ENEMY_BULLET) do
				_del(unit, true)
			end
			task.Wait(1)
		end
	end)
end
---------------------------------小怪定义
local e1, e1_1
do
	e1 = Class(enemy)
	function e1:init(x, y)
		enemy.init(self, 32, 30, false, true, false, true, 1, 100, 1)
		self.group = GROUP_NONTJT
		self.x, self.y = x, y
		boundWait(self, 90)
	end
	e1_1 = Class(enemy)
	function e1_1:init(x, y, IsnDye)
		if IsnDye then
			enemy.init(self, 28, 10, false, true, false, false, nil, 0, 1)
		else
			enemy.init(self, 28, 10, false, true, false, false, 3, 0, 1)
		end
		self.group = GROUP_NONTJT
		self.x, self.y = x, y
	end
	function e1_1:kill()
		enemy.kill(self)
		if not (self.sys_co == 1 or self.sys_co == 2) then
			local a = Angle(self, player)
			for i = 0, 1 do
				stg.newBulletStraight(stg.ball_mid, 1, true, self.x, self.y, 1+i, a)
			end
		end
	end
end
local e2, e2_1
do
	e2 = Class(enemy)--开花弹蝴蝶
	function e2:init(x, y)
		self.x, self.y = x, y
		enemy.init(self, 32, 30, false, true, false, true, 1, 100, 1)
		self.group = GROUP_NONTJT

	end
	e2_1 = Class(enemy)
	function e2_1:init(x, y, IsnDye)
		self.x, self.y = x, y
		self.omiga = 3
		if IsnDye then
			enemy.init(self, 15, 15, false, true, false, false, nil, 0, 1)
		else
			enemy.init(self, 15, 15, false, true, false, false, 3, 0, 1)
		end
		self.group = GROUP_NONTJT
	end
end
local e3, e3_1
do
	e3 = Class(enemy)
	function e3:init(x, y, co)
		co = co or 1
		enemy.init(self, 32, 30, false, true, false, true, co, 0, 1)
		self.group = GROUP_NONTJT
		self.bound = false
		self.x, self.y = x, y
	end
	e3_1 = Class(enemy)
	function e3_1:init(x, y)
		enemy.init(self, 24, 10, false, true, false, false, nil, 0, 1)
		self.group = GROUP_NONTJT
		self.x, self.y = x, y
	end
end
local e4, e4_1
do
	e4 = Class(enemy)
	function e4:init(x, y)
		enemy.init(self, 32, 30, false, true, false, true, 1, 80, 1)
		self.group = GROUP_NONTJT
		self.bound = false
		self.x, self.y = x, y
	end
	e4_1 = Class(enemy)
	function e4_1:init(x, y)
		enemy.init(self, 28, 10, false, true, false, false, nil, 0, 1)
		self.group = GROUP_NONTJT
		self.x, self.y = x, y
	end
end
local e5, e5_1
do
	--到处乱飞的大蝴蝶
	e5 = Class(enemy)
	function e5:init(x, y, u)
		self.x, self.y = x, y
		enemy.init(self,28, 15,false,false,true, true, 1, 25, 1)
		self.group = GROUP_NONTJT
		decDmg(self, 20, 60, 0.1, 1)
		for i = 1, 3 do
			New(e5_1, self, 120*i, u)
		end
		--移动
		task.New(self, function()
			egg.AddSimStrChV(self, 3, 1, -90, 150)
			task.Wait(150)
			egg.AddSimStrChV(self, 0, max(1, min(3, 0.05*abs(player.x - self.x))), 90 - 90*sign(player.x - self.x), 240) --往自机方向飞
			self.bound = true
		end)
		--攻击
	end
	--鬼火
	e5_1 = Class(enemy)
	function e5_1:init(mst, a, u)
		enemy.init(self, 20, 10,false,false,true, nil, 3, 0, 1)
		self.hscale, self.vscale = 0.75, 0.75
		self.a, self.b = self.a*self.hscale, self.b*self.vscale
		self.x, self.y = mst.x, mst.y
		self.layer = LAYER_ENEMY-1
		self.group = GROUP_NONTJT
		--跟随
		task.New(self, function()
			local r, dr, da = 0, 20/30, 2*u
			for _ = 1, 30 do
				if IsValid(mst) then
					r = r + dr
					a = a + da
					self.x, self.y = mst.x + r*cos(a), mst.y + r*sin(a)
				else
					Del(self)
				end
				task.Wait(1)
			end
			while IsValid(mst) do
				a = a + da
				self.x, self.y = mst.x + r*cos(a), mst.y + r*sin(a)
				task.Wait(1)
			end
			Del(self)
		end)
		--攻击
		task.New(self, function()
			while self.y > -50 do
				egg.AddSimStrChV(stg.newBulletStraight(stg.arrow_big, 6, true, self.x, self.y, 0, a), 3, 1.5, a, 60)
				task.Wait(8)
			end
		end)
	end
end
--后半道中
--鬼形兽五后半无限狙
local e6, e6_1, e6_2
do
	e6 = Class(enemy)
	function e6:init(x, y, u)
		enemy.init(self, 48, 60, false, true, false, true, 2, 0, 1)
		self.group = GROUP_NONTJT
		self.x, self.y = x, y
		boundWait(self, 90)
		for i = 1, 3 do
			New(e6_1, self, 120*i, u)
		end
		for i = 1, 3 do
			New(e6_1, self, 120*i + 60, u, true)
		end
	end
	--鬼火
	e6_1 = Class(enemy)
	function e6_1:init(mst, a, u, IsnAttack)
		enemy.init(self, 20, 10,false,false,true, nil, 3, 0, 1)
		--self.hscale, self.vscale = 0.75, 0.75
		--self.a, self.b = self.a*self.hscale, self.b*self.vscale
		self.group = GROUP_NONTJT
		self.x, self.y = mst.x, mst.y
		self.layer = LAYER_ENEMY-1
		--跟随
		task.New(self, function()
			local r, dr, da = 0, 40/30, 2*u
			for _ = 1, 30 do
				if IsValid(mst) then
					r = r + dr
					a = a + da
					self.x, self.y = mst.x + r*cos(a), mst.y + r*sin(a)
				else
					Del(self)
				end
				task.Wait(1)
			end
			while IsValid(mst) do
				a = a + da
				self.x, self.y = mst.x + r*cos(a), mst.y + r*sin(a)
				task.Wait(1)
			end
			Del(self)
		end)
		--攻击
		if not IsnAttack then
			task.New(self, function()
				task.Wait(60)
				for _ = 1, 60 do
					for u = -1, 1, 2 do
						--accbullet(stg.grain_a, 2, self.x, self.y, 1.2 + 0.2*u, a, 1)
						vaccbullet(stg.grain_a, 2, self.x, self.y, 1.25, a, 0.5*u, a, 60)
						vaccbullet(stg.grain_a, 2, self.x, self.y, 0.75, a, 1, a + 90*u, 60)
						task.Wait(2)
						PlaySound("kira00")
					end
				end
			end)
		end
	end

	e6_2 = Class(enemy)
	function e6_2:init(x, y)
		enemy.init(self, 44, 10, false, true, false, false, nil, 0, 1)
		self.group = GROUP_NONTJT
		self.x, self.y = x, y
		task.New(self, function()
			task.Wait(120)
			local a
			for _ = 1, 10 do
				a = Angle(self, player)
				for i = -1, 1 do
					accbullet(stg.arrow_small, 10, self.x, self.y, 3, a + 60*i, 180)
				end
				task.Wait(10)
				PlaySound("tan00")
			end
		end)
	end
	function e6_2:kill()
		enemy.kill(self)
		if not (self.sys_co == 1 or self.sys_co == 2) then
			local a = Angle(self, player)
			for i = 0, 1 do
				stg.newBulletStraight(stg.arrow_small, 1, true, self.x, self.y, 2+0.5*i, a)
			end
		end
	end
end
--爆菊！！
local e7, e7_1
do
	e7 = Class(enemy)
	function e7:init(x, y, co)
		co = co or 2
		enemy.init(self, 32, 20, false, true, false, true, co, 0, 1)
		self.group = GROUP_NONTJT
		self.x, self.y = x, y
		boundWait(self, 90)
		task.New(self, function()
			local a
			while true do
				a = Angle(0, 0, self.vx, self.vy)
				for i = 0, 4 do
					for u = -1, 1, 2 do
						accbullet(stg.grain_b, 10, self.x, self.y, 1 + 0.1*i, a + 135*u, 60)
					end
					PlaySound("tan00")
					task.Wait(2)
				end
			end
		end)
		decDmg(self, 30, 30, 0.1, 1)
		dyeRangeCh(self, 60, 60)
	end
	--鬼火
	e7_1 = Class(enemy)
	function e7_1:init(mst, a, u)
		enemy.init(self,16, 10,false,false,true, nil, nil, 0, 1)
		self.group = GROUP_NONTJT
		self.x, self.y = mst.x, mst.y
		--跟随
		task.New(self, function()
			local r, dr, da = 0, 20/30, 2*u
			for _ = 1, 30 do
				if IsValid(mst) then
					r = r + dr
					a = a + da
					self.x, self.y = mst.x + r*cos(a), mst.y + r*sin(a)
				else
					Del(self)
				end
				task.Wait(1)
			end
			while IsValid(mst) do
				a = a + da
				self.x, self.y = mst.x + r*cos(a), mst.y + r*sin(a)
				task.Wait(1)
			end
			Del(self)
		end)
		--攻击
		task.New(self, function()
			--task.Wait(60)
			for _ = 1, 20 do
				accbullet(stg.arrow_big, 2, self.x, self.y, 1, a, 60)
				task.Wait(5)
			end
		end)
	end
end
----------------------------------道中本体-------------------------
local function road(self)
	--测试用对象，整合完毕后请务必删除！！！！
	--New(egg.updateFileObject, "EISlib/background/stage7bg.lua")
	--New(egg.updateFileObject, "EISlib/stage/stage7/s7_enemy.lua")
	--New(egg.updateFileObject, "EISlib/stage/stage7/s7_boss_defined.lua")
	local bg
	do
		bg = New(stage7_background)
		system.setTargetChain(5201314) -- 999
		dialog.cacheResource("StageEX_mid")
		dialog.cacheResource("StageEX_mid_after")
		dialog.cacheResource("StageEX")
		dialog.cacheResource("StageEX_after")
		LoadMusicRecord("s7")
		LoadMusicRecord("s7_boss")
	end
	EISlib.stage.playMusic("s7", 0, true)
	task.Wait(60)
	--
	do
		local f1, f1_1, f1_2, f2, f2_1, f2_2, f3, f3_1, f3_2, f3_3, f3_4, f4, f4_1, f4_2, f5
		do
			--一群妖精和蝴蝶
			function f1(x, y, u, n)
				for _ = 1, n do
					f1_1(x, y, u)
					task.Wait(10)
				end
				f1_2(x + 90*u, y)
			end
			--普通小妖精
			function f1_1(x, y, u)
				local obj = New(e1_1, x, y)
				--移动
				task.New(obj, function()
					SetV(obj, 3, 90)
					egg.AddAccDecChV(obj, 6, -90, 1, 60, 120) --包括向下减速和向上加速
					task.Wait(60)
					egg.AddAccDecChV(obj, 2, 90 - 90*u, 90, 0, 90) --横向运动
				end)
				--攻击
				task.New(obj, function()
					task.Wait(60)
					local a
					for _ = 1, 5 do
						a = Angle(obj, player)
						PlaySound("tan00")
						for i = -2, 2 do
							for j = 0, 1 do
								egg.AddSimStrChV(stg.newBulletStraight(stg.grain_a, 6, true, obj.x, obj.y, 0, a + 30*i), 0, 1.5+0.5*j, a + 30*i, 60)
							end
						end
						task.Wait(30)
					end
				end)
			end
			--普通大蝴蝶
			function f1_2(x, y)
				local obj = New(e1, x, y)
				--常规移动
				task.New(obj, function()
					SetV(obj, 3, 90)
					egg.AddAccDecChV(obj, 6, -90, 1, 60, 120) --包括向下减速和向上加速
				end)
				--攻击
				task.New(obj, function()
					task.Wait(30)
					PlaySound("kira00")
					for i = 1, 36 do
						accbullet(stg.ball_mid_c, 3, obj.x, obj.y, 2, 10*i, 60)
					end
					task.Wait(30)
					PlaySound("kira00")
					for i = 1, 36 do
						for j = 0, 2 do
							accbullet(stg.ball_mid_c, 3, obj.x, obj.y, 2 + 0.25*j, 10*i + 3*j, 60)
						end
					end
				end)
			end
			--stage2
			function f2(y, u, IsnDye)
				for _ = 1, 6 do
					f2_1(-224*u, y + 30, u, IsnDye)
					f2_1(-224*u, y, u, IsnDye)
					task.Wait(10)
				end
				f2_2(224*u, y, -u)
			end
			--交叉移动的毛玉
			function f2_1(x, y, u, IsnDye)
				local obj = New(e2_1, x, y, IsnDye)
				--移动
				task.New(obj, function()
					egg.AddSimStrChV(obj, 1.25, 0.5, -90, 60)
					egg.AddAccDecChV(obj, 2, 90 - 90 * u, 30, 100, 60)
					task.Wait(240)
					egg.AddSimStrChV(obj, 0, 2, 90 + 90 * u, 30)
				end)
				--攻击
				task.New(obj, function()
					task.Wait(30)
					local a
					for k = 1, 30 do
						a = Angle(obj.vx, obj.vy, 0, 0)
						for i = -1, 1 do
							accbullet(stg.arrow_small, 5, obj.x, obj.y, 2, a + (3*k)*i, 60)
						end
						PlaySound("tan00")
						task.Wait(10)
					end
				end)
			end
			function f2_2(x, y, u)
				local obj = New(e2, x, y)
				task.New(obj, function()
					SetV(obj, 3, -90 + 75*u)
					egg.AddAccDecChV(obj, -2, -90 + 75*u, 90, 60)
				end)
				--发射弹幕
				task.New(obj, function()
					task.Wait(20)
					local lastGroup, count, a0
					lastGroup = {}
					for _ = 1, 5 do
						a0 = Angle(obj, player)
						PlaySound("kira00")
						lastGroup, count = qingLan1(obj.x, obj.y, 5, 0, -0.2, a0, 6, kite_b, 5)
						for i = 1, count do
							lastGroup[i].vscale = 0.75
							egg.AddSimStrChV(lastGroup[i], 0, 2, a0, 30)
						end
						task.Wait(15)
					end
				end)
			end
			--stage3
			function f3(x, y, u)
				New(tasker, function()
					f3_1(x, y, u)
					task.Wait(120)
					f3_4(x, y)
				end)
			end
			--三面那种大蝴蝶
			function f3_1(x, y, u)
				local obj = New(e3, x, y)
				task.New(obj, function()
					egg.AddSimStrChV(obj, 3, 0, -90, 60)
					task.Wait(60)
					f3_3(obj.x, obj.y, u)
					dyeRangeCh(obj, 60, 30)
					task.Wait(60)
					egg.AddSimStrChV(obj, 0, 2, -90, 60)
				end)
			end
			--旋转鬼火
			function f3_2(x, y, a, u, mst)
				local obj = New(e3_1, x, y)
				egg.SimAlpCh(obj, 0, 255, 20, true)
				task.New(obj, function()
					local r, dx, dy = 0, cos(a), sin(a)
					for _ = 1, 45 do
						r = r + 1
						if IsValid(mst) then
							obj.x, obj.y = mst.x + r*dx, mst.y + r*dy
						else
							break
						end
						task.Wait(1)
					end
					local da, dr, ddr = 0.75*u, 0, -0.00625
					while true do
						a = a + da
						dr = max(dr + ddr,  -1)
						r = r + dr
						if IsValid(mst) then
							obj.x, obj.y = mst.x + r*cos(a), mst.y + r*sin(a)
						else
							break
						end
						task.Wait(1)
					end
					local a = Angle(0, 0, obj.dx, obj.dy)
					egg.AddSimStrChV(obj, 1, 3, a, 60)
				end)
				task.New(obj, function()
					task.Wait(30)
					for _ = 1, 40 do
						accbullet(stg.arrow_big, 6, obj.x, obj.y, 2, a + 180, 60)
						task.Wait(5)
					end
				end)
				return obj
			end
			--旋转鬼火中心
			function f3_3(x, y, u)
				local obj = stg.newBulletStraight(stg.arrow_small, 1, true, x, y, 0, 0)
				obj.group = GROUP_GHOST
				obj.hide = true
				boundWait(obj, 300)
				for i = 1, 6 do
					f3_2(obj.x, obj.y, 60*i, u, obj)
				end
				egg.AddSimStrChV(obj, 0, 1.5, -90, 60, 60)
			end
			--天上掉下来的送分妖精
			function f3_4(x, y)
				local obj = New(e3, x, y, 2)
				egg.AddSimStrChV(obj, 0, 3, -90, 90)
				dyeRangeCh(obj, 60, 60)
				--攻击
				task.New(obj, function()
					task.Wait(20)
					PlaySound("kira00")
					for i = -5, 5 do
						for j = 0, 1 do
							vaccbullet(stg.arrow_small, 5, obj.x, obj.y, 2 + 0.5*j, 90 + 5*i, 3.5, -90, 60)
						end
					end
				end)
			end
			--stage4
			function f4(x, y)
				for u = -1, 1, 2 do
					for i = 1, 4 do
						f4_2(-224*u, y, -90 + (45 + 5*i)*u, u)
					end
					f4_1(x*u, 245, u)
				end
			end
			--大型妖精
			function f4_1(x, y, u)
				local obj = New(e4, x, y)
				task.New(obj, function()
					egg.AddSimStrChV(obj, 2.5, 0, -90, 60)
					task.Wait(60)
					egg.AddAccDecChV(obj, 1, -90, 90, 90, 90)
					task.Wait(180)
					egg.AddSimStrChV(obj, 0, 1.5, 90 - 45*u, 60)
				end)
				--攻击
				task.New(obj, function()
					task.Wait(60)
					local a
					for _ = 1, 9 do
						a = Angle(obj, player)
						for i = 1, 24 do
							for j = -1, 1 do
								accbullet(stg.grain_b, 5, obj.x, obj.y, 1-0.05*abs(j), a + 1*j + 15*i, 60)
							end
						end
						task.Wait(30)
					end
				end)
			end
			--四面小妖精的星弹
			local function sp_bullet(x, y, a, dv)
				local obj = stg.newBulletStraight(stg.star_small, 5, true, x, y, 0, a)
				obj.omiga = 3
				egg.AddSimStrChV(obj, 3 + dv, 0.25, a, 60)
				egg.AddSimStrChV(obj, 0, 1 + dv, a, 120, 90)
			end
			--小型妖精
			function f4_2(x, y, a, u)
				local obj = New(e4_1, x, y)
				task.New(obj, function()
					SetV(obj, 2, a)
					task.Wait(55)
					egg.AddSimStrChV(obj, 0, -2, a, 90)
					task.Wait(90)
					egg.AddSimStrChV(obj, 0, 1, a + 45*u, 120)
				end)
				task.New(obj, function()
					task.Wait(30)
					local a = Angle(obj, player)
					for i = -5, 5 do
						for j = 0, 2 do
							sp_bullet(obj.x, obj.y, a + 7.5*i, 0.2*j)
						end
					end
				end)
			end
			--stage6
			function f5(x, y, u)
				New(e5, x, y, u)
			end
		end

		do
			local u = 1
			for i = 0, 3 do
				f1(-150 * u, 245, u, 4 + 2*i)
				task.Wait(90)
				u = -u
			end
			--毛玉+大蝴蝶
			local y, dy = 170, -60
			for u = -1, 1, 2 do
				f2(y, u, true)
				task.Wait(90)
				y = y + dy
			end
			f2(y, -1, true)
			task.Wait(90)
			y = y + dy
			f2(y, 1) --最后一波自带染色
			task.Wait(180)
			--p3
			f3(-90, 245, 1)
			task.Wait(180)
			f3(90, 245, -1)
			task.Wait(180)
			local u = -1
			for i = 0, 3 do
				f3(150 - 100*i, 245, u)
				task.Wait(60)
				u = -u
			end
			task.Wait(180)
			for u = -1, 1, 2 do
				f3(90 - 30*u, 245, u)
			end
			task.Wait(180)
			for u = -1, 1, 2 do
				f3(-90 - 30*u, 245, u)
			end
			task.Wait(240)
			for u = -1, 1 do
				f3(0 - 60*u, 245, u)
			end
			task.Wait(300)
			--p4
			f4(75, 172)
			task.Wait(120)
			f4(60, 172)
			task.Wait(120)
			f4(75, 172)
			task.Wait(120)
			f4(90, 172)
			task.Wait(120)
			f4(50, 172)
			task.Wait(120)
			f4(30, 172)
			task.Wait(240)
			--p5
			for _ = 0, 1 do
				for u = -1, 1, 2 do
					for i = 0, 4 do
						f5((120 - 48*i)*u, 245, -u)
						task.Wait(20)
					end
				end
			end

			while self.timer < 4280 do
				task.Wait(1)
			end
			clearEnemyAndBullet()
			task.Wait(11)
			s7_mid_boss.main()
			bg.stage = 2  --切换场景的信号
		end
	end
	bg.stage = 2  --切换场景的信号
	task.Wait(60)
	s7_title()
	task.Wait(240)
	--鬼形兽无限狙阵
	do
		local f1, f2, f2_1
		do
			--大蝴蝶
			function f1(x, y, u, range)
				range = range or 90
				local obj = New(e6, x, y, u)
				decDmg(obj, 45, 60, 0.1, 1)
				task.New(obj, function()
					egg.AddAccDecChV(obj, 3, -90, 1, 30, 60)
					task.Wait(30)
					dyeRangeCh(obj, range, 60)
					task.Wait(60)
					egg.AddSimStrChV(obj, 0, 1, -90, 240)
				end)
			end
			--小妖精生成器
			function f2()
				New(tasker, function()
					for _ = 1, 30 do
						for u = -1, 1, 2 do
							for i = 0, 1 do
								f2_1((120 - 30*i)*u, 245, -u)
							end
						end
						task.Wait(30)
					end
				end)
			end
			--小妖精
			function f2_1(x, y, u)
				local obj = New(e6_2, x, y)
				task.New(obj, function()
					egg.AddAccDecChV(obj, 1, -90, 1, 180, 60)
					task.Wait(120)
					egg.AddSimStrChV(obj, 0, 1.25, -90 + 105*u, 180)
				end)
			end
		end

		do
			for u = -1, 1, 2 do
				f1(-75*u, 250, -u)
			end
			task.Wait(180)
			for u = -1, 1, 2 do
				f1(-150*u, 250, -u)
			end
			task.Wait(180)
			for u = -1, 1, 2 do
				f1(-90*u, 250, -u)
			end
			task.Wait(60)
			f2()
			task.Wait(120)
			for i = 1, 8 do
				for u = -1, 1, 2 do
					f1(-(30 + 12*i)*u, 250, -u, 100)
					task.Wait(70)
				end
			end
			task.Wait(180)
		end
	end

	--最后一段！
	do
		local f1, f1_1, f1_2
		do
			--生成碰撞妖精
			function f1(y, co)
				local vy = -ran:Float(1.5, 2.5)
				local rate = ran:Float(0.4, 0.5)
				do
					local u = -1
					f1_1(f1_2(-224*u, y, u), -4*rate*u, vy, u)
					f1_1(New(e7, -224*u, y, co), -4*rate*u, vy, u)
					u = 1
					f1_1(f1_2(-224*u, y, u), 4*(1-rate)*u, vy, u)
					f1_1(New(e7, -224*u, y, co), 4*(1-rate)*u, vy, u)
				end
			end
			--只是一个移动事件
			function f1_1(obj, vx, vy, u)
				task.New(obj, function()
					egg.AddSimStrChV(obj, 1, vx, -90 + 90*u, 60)
					egg.AddSimStrChV(obj, 0, vy, 90, 360)
				end)
			end
			--生成鬼火
			function f1_2(x, y, u)
				local obj = stg.newBulletStraight(stg.ball_mid, 10, true, x, y, 0, 0)
				obj.hide = true
				obj.timer = 11
				obj.colli = true
				obj.group = GROUP_GHOST
				boundWait(obj, 300)
				for i = 1, 3 do
					New(e7_1, obj, 120*i, u)
				end
				return obj
			end
		end

		do
			f1(160)
			task.Wait(120)
			for i = 0, 2 do
				f1(160 - 30*i)
				task.Wait(60)
			end
			task.Wait(150)
			for i = 0, 4 do
				f1(160 - 20*i)
				task.Wait(60)
			end
			task.Wait(150)
			for i = 0, 8 do
				f1(200 - 15*i)
				task.Wait(45)
			end
		end
	end
	task.Wait(240)
	clearEnemyAndBullet() --全屏消
    bg.stage = 3  --切换场景的信号
    task.Wait(300)
	s7_boss.main()
	task.Wait(120)
	--region 成就
	--成就 不续关通关Extra关卡 (id:15)
	if (lstg.var.coun_num or 0) <= 0 then
		achievement.unlock("15")
		system.record.markPlayerClearGroup()
		if system.record.isAllPlayerClearGroup() then
			achievement.unlock("25")
		end
	end
	--成就 NM
	if system.isNoMiss() then
		achievement.unlock("51")
	end
	--成就 NB
	if system.isNoBomb() then
		achievement.unlock("52")
	end
	--成就 ex面染色数分别达到850, 900(id:64 65
	if system.getTotalChain() >= 999 then
		achievement.unlock("65")
		achievement.unlock("64")
	elseif system.getTotalChain() >= 850 then
		achievement.unlock("64")
	end
	--endregion
	system.makeSettlement(7, true)
	--region 高分
	-- 标记新的高分，一会回主菜单要保存
	system.record.markHighScore()
	--endregion
	task.Wait(120)
end
s7_road.main = road
