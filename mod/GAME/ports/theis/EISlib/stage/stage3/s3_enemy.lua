s3_road = {}

local path = "EISlib/stage/stage3/"
Include(path .. "s3_boss.lua")

--资源加载
do
	local path = "res/stage/stage3/s3title/"
	LoadImageFromFile("s3_t1", path .. "s3_t1.png")
	LoadImageFromFile("s3_t2", path .. "s3_t2.png")
	LoadImageFromFile("s3_t3", path .. "s3_t3.png")
	LoadImageFromFile("s3_t4", path .. "s3_t4.png")
end
----------------------------------标题
local s3_title
do
	local size, t0, t1, t2 = 0.8, 90, 60, 60
	local s3_t1 = Class(object)
	function s3_t1:init(x, y)
		self.x, self.y = x, y
		self.img = "s3_t1"
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
	function s3_t1:frame()
		task.Do(self)
	end
	function s3_t1:render()
		SetImgState(self, "", self._a, self._r, self._g, self._b)
		Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
	end
	local s3_t2 = Class(object)
	function s3_t2:init(x, y)
		self.x, self.y = x, y
		self.img = "s3_t2"
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
	function s3_t2:frame()
		task.Do(self)
	end
	function s3_t2:render()
		SetImgState(self, "", self._a, self._r, self._g, self._b)
		Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
	end
	local s3_t3 = Class(object)
	function s3_t3:init(x, y)
		self.x, self.y = x, y
		self.img = "s3_t3"
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
	function s3_t3:frame()
		task.Do(self)
	end
	function s3_t3:render()
		SetImgState(self, "", self._a, self._r, self._g, self._b)
		Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
	end
	local s3_t4 = Class(object)
	function s3_t4:init(x, y)
		self.x, self.y = x, y
		self.img = "s3_t4"
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
	function s3_t4:frame()
		task.Do(self)
	end
	function s3_t4:render()
		SetImgState(self, "", self._a, self._r, self._g, self._b)
		Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
	end
	function s3_title()
		local x, y = 0, 100
		New(s3_t1, x - 130 * size, y + 0)
		New(s3_t4, x + 80 * size, y - 5 * size)
		New(s3_t2, x + 160 * size, y - 36 * size)
		New(s3_t3, x + 60 * size, y + 20 * size)
	end
end
----------------------------------特殊函数定义
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
----------------------------------小怪定义
local _s3_enemy_1, s3_enemy_1_1, s3_enemy_1_2, s3_enemy_1_3, s3_enemy_1_4, s3_enemy_1_5
local _s3_enemy_1_child, s3_enemy_1_child_1, s3_enemy_1_child_2, s3_enemy_1_child_3, s3_enemy_1_child_4, s3_enemy_1_child_5
local _s3_enemy_2, s3_enemy_2_1, s3_enemy_2_2, s3_enemy_2_3
local _s3_enemy_2_child, s3_enemy_2_child_1, s3_enemy_2_child_2, s3_enemy_3
local e1, e1_1

local No_bound_simple_bullet = Class(bullet)
function No_bound_simple_bullet:init(x, y, st, co, v0, a0, acc0, a1, t, del_time, destroyable)
	self.destroyable = destroyable or true
	bullet.init(self, st, co, true, self.destroyable)
	self.x, self.y = x, y
	self.bound = false
	self.acc = acc0 or 0
	self.acc_a = a1 or 0
	task.New(self, function()
		task.Wait(t)
		self.bound = true
	end)
	SetV2(self, v0, a0, true, false)
	_set_a(self, self.acc, self.acc_a, false)
	if del_time then
		task.New(self, function()
			task.Wait(del_time)
			Del(self)
		end)
	end
end

--小怪死亡计数器
local enemy_kill_counter = Class(object)
function enemy_kill_counter:new(o)
	o = o or {}
	self.__index = self
	setmetatable(o, self)
	enemy_kill_counter:init()
	return o
end
function enemy_kill_counter:init()
	self.flag = 0
	self.add_enemy = false --增援开关
end
function enemy_kill_counter:Reset()
	self.flag = 0
	self.add_enemy = false --增援开关
end
--该方法用于，在一段时间内判断原本固定的怪是否已经消失，如果都消失了则开启增援开关，且在持续时间结束后重置
function enemy_kill_counter:NotIsValidEnemy()
	if self.flag == 0 then
		self.add_enemy = true --增援开关
	end
end

enemy_kill_counter = enemy_kill_counter:new() --创建一个新的计数器对象

--第一队小怪
local function move_1_1(self, rot)
	local u
	if rot == 1 then
		u = 1
	else
		u = -1
	end
	task.New(self, function()
		egg.AddSimStrChV(self, 2, 1.25, 90 - 90 * u, 200)
		egg.AddSimStrChV(self, 1.5, -1.5, 90, 300)
		task.Wait(240)
		egg.AddSimStrChV(self, 1.25, 0.1, 90 - 90 * u, 30)
		task.Wait(150)
		egg.AddSimStrChV(self, 0.1, 1, 90 - 90 * u, 150)
		task.Wait(240)
		Del(self)
	end)
end--第一种大怪的移动方式
local function move_1_2(self, rot)
	local u
	if rot == 1 then
		u = 1
	else
		u = -1
	end
	task.New(self, function()
		egg.AddSimStrChV(self, 1.75, 0.8, 90 - 90 * u, 135)
		egg.AddSimStrChV(self, 1.25, -1.25, 90, 450)
		task.Wait(240)
		egg.AddSimStrChV(self, 0.8, 0.1, 90 - 90 * u, 30)
		task.Wait(270)
		egg.AddSimStrChV(self, 0.1, 1, 90 - 90 * u, 300)
		task.Wait(600)
		self.bound = true
	end)
end
local function move_1_3(self, rot)
	local u
	if rot == 1 then
		u = 1
	else
		u = -1
	end
	task.New(self, function()
		egg.AddSimStrChV(self, 1.75, 0.1, -90, 150)
		egg.AddSimStrChV(self, 0, 2, 90 - 90 * u, 240)
		task.Wait(240)
		egg.AddSimStrChV(self, 0, -3, 90 - 90 * u, 300)
		egg.AddSimStrChV(self, 0, 0.9, -90, 300)
		task.Wait(300)
		egg.AddSimStrChV(self, 0, 2.9, 90, 240)
		task.Wait(200)
		self.bound = true
	end)
end
local function move_1_4(self, rot)
	local u
	if rot == 1 then
		u = 1
	else
		u = -1
	end
	task.New(self, function()
		egg.AddV1(self, 1.5, 90 - 90 * u)
		egg.AddSimStrChV(self, 2, 0, 90, 100)
		task.Wait(200)
		egg.AddSimStrChV(self, 0, -1.35, 90 - 90 * u, 90)
		egg.AddSimStrChV(self, 0, 3, -90, 300)
		self.bound = true
	end)
end
local function move_1_5(self, rot)
	local u
	if rot == 1 then
		u = 1
	else
		u = -1
	end
	task.New(self, function()
		egg.AddV1(self, 2, 90)
		task.Wait(125)
		egg.AddSimStrChV(self, 0, -2, 90, 100)
		egg.AddSimStrChV(self, 0, 1.5, 90 - 90 * u, 100)
		self.bound = true
	end)
end
local function spawn_1_1(self, _num, x, y, _st, _hp, rot)
	local num, last
	num = _num or 6
	task.New(self, function()
		task.Wait(20)
		for i = 1, num do
			last = s3_enemy_1_child_1(x, y, _st, _hp, self, rot, 60 + 20*i)
			--_connect(self, last,0,true)
			task.Wait(20)
		end
	end)
end--配套使用的第一种大怪生成的小怪
local function spawn_1_2(self, _num, x, y, _st, _hp, rot)
	local num, last
	num = _num or 6
	task.New(self, function()
		task.Wait(20)
		for _ = 1, num do
			last = s3_enemy_1_child_2(x, y, _st, _hp, self, rot)
			--_connect(self, last,0,true)
			task.Wait(20)
		end
	end)
end
local function spawn_1_3(self, _num, x, y, _st, _hp, rot)
	local num, last
	num = _num or 6
	task.New(self, function()
		task.Wait(20)
		for i = 1, num do
			last = s3_enemy_1_child_3(x, y, _st, _hp, self, rot, 30 + 20*i)
			--_connect(self, last,0,true)
			task.Wait(20)
		end
	end)
end
local function spawn_1_4(self, _num, x, y, _st, _hp, rot)
	local num, last
	num = _num or 6
	task.New(self, function()
		task.Wait(20)
		for i = 1, num do
			last = s3_enemy_1_child_4(x, y, _st, _hp, self, rot, 30 + i*20)
			--_connect(self, last,0,true)
			task.Wait(20)
		end
	end)
end
local function spawn_1_5(self, _num, x, y, _st, _hp, rot)
	local num, last
	num = _num or 6
	task.New(self, function()
		task.Wait(20)
		for i = 1, num do
			last = s3_enemy_1_child_5(x, y, _st, _hp, self, rot, 30 + 20*i)
			--_connect(self, last,0,true)
			task.Wait(20)
		end
	end)
end
local function child_attack_1_1(self, t)
	t = t or 30
	if difficulty == 1 then
		task.New(self, function()
			task.Wait(t + 90)
			local a
			for _ = 1, 1 do
				for j = 0, 0 do
					a = Angle(0, 0, self.vx, self.vy)
					for u = -1, 1, 2 do
						accbullet(stg.grain_b, 10, self.x, self.y, 1 + 0.25*j, a + 90*u, t)
					end
					PlaySound("tan00")
					task.Wait(3)
				end
				task.Wait(90)
			end
		end)
	elseif difficulty == 2 then
		task.New(self, function()
			task.Wait(t + 60)
			local a
			for _ = 1, 1 do
				for j = 0, 1 do
					a = Angle(0, 0, self.vx, self.vy)
					for u = -1, 1, 2 do
						accbullet(stg.grain_b, 10, self.x, self.y, 1 + 0.25*j, a + 90*u, t)
					end
					PlaySound("tan00")
					task.Wait(3)
				end
				task.Wait(90)
			end
		end)
	elseif difficulty == 3 then
		task.New(self, function()
			task.Wait(t)
			local a
			for _ = 1, 2 do
				for j = 0, 2 do
					a = Angle(0, 0, self.vx, self.vy)
					for u = -1, 1, 2 do
						accbullet(stg.grain_b, 10, self.x, self.y, 1 + 0.25*j, a + 90*u, t)
					end
					PlaySound("tan00")
					task.Wait(3)
				end
				task.Wait(90)
			end
		end)
	elseif difficulty == 4 then
		task.New(self, function()
			task.Wait(t)
			local a
			for _ = 1, 2 do
				for j = 0, 3 do
					a = Angle(0, 0, self.vx, self.vy)
					for u = -1, 1, 2 do
						accbullet(stg.grain_b, 10, self.x, self.y, 1 + 0.25*j, a + 90*u, t)
					end
					PlaySound("tan00")
					task.Wait(3)
				end
				task.Wait(90)
			end
		end)
	end
end
local function child_attack_1_3(self, t)
	t = t or 30
	if difficulty == 1 then
		task.New(self, function()
			task.Wait(t + 60)
			local a
			for _ = 1, 1 do
				for j = 0, 0 do
					a = Angle(0, 0, self.vx, self.vy)
					for u = -1, 1, 2 do
						accbullet(stg.grain_b, 5, self.x, self.y, 1 + 0.25*j, a + 90*u, t)
					end
					PlaySound("tan00")
					task.Wait(3)
				end
				task.Wait(90)
			end
		end)
	elseif difficulty == 2 then
		task.New(self, function()
			task.Wait(t + 60)
			local a
			for _ = 1, 1 do
				for j = 0, 1 do
					a = Angle(0, 0, self.vx, self.vy)
					for u = -1, 1, 2 do
						accbullet(stg.grain_b, 5, self.x, self.y, 1 + 0.25*j, a + 90*u, t)
					end
					PlaySound("tan00")
					task.Wait(3)
				end
				task.Wait(90)
			end
		end)
	elseif difficulty == 3 then
		task.New(self, function()
			task.Wait(t)
			local a
			for _ = 1, 2 do
				for j = 0, 2 do
					a = Angle(0, 0, self.vx, self.vy)
					for u = -1, 1, 2 do
						accbullet(stg.grain_b, 5, self.x, self.y, 1 + 0.25*j, a + 90*u, t)
					end
					PlaySound("tan00")
					task.Wait(3)
				end
				task.Wait(90)
			end
		end)
	elseif difficulty == 4 then
		task.New(self, function()
			task.Wait(t)
			local a
			for _ = 1, 2 do
				for j = 0, 3 do
					a = Angle(0, 0, self.vx, self.vy)
					for u = -1, 1, 2 do
						accbullet(stg.grain_b, 5, self.x, self.y, 1 + 0.25*j, a + 90*u, t)
					end
					PlaySound("tan00")
					task.Wait(3)
				end
				task.Wait(90)
			end
		end)
	end
end

_s3_enemy_1 = Class(enemy)--第一种大怪的通用属性（可继承，直接修改这里）
function _s3_enemy_1:init(x, y, st, hp, co, range)
	self.x, self.y = x, y
	co = co or 1
	--带描边的靓仔妖精
	enemy.init(self, 65, hp, false, false, false, true, co, range or 20, 1)
	self.group = GROUP_NONTJT
	if difficulty == 1 then
		task.New(self, function()
			local a, way
			local function f1(x, y, v, a, co)
				local obj = accbullet(stg.kite_b, co, x, y, v, a, 30)
				obj.vscale, obj.b = 0.75, 0.75*obj.b
			end
			task.Wait(30)
			for k = 1, 3 do
				a = Angle(0, 0, self.vx, self.vy)
				way = int(1+0.5*k)
				for i = -way, way do
					for j = -1, 1 do
						f1(self.x, self.y, 1.75 - 0.04*abs(j), a + 1*j + 30*i, 6 + 2*(k%2))
					end
				end
				PlaySound("tan00")
				task.Wait(120)
			end
		end)
	elseif difficulty == 2 then
		task.New(self, function()
			local a, way
			local function f1(x, y, v, a, co)
				local obj = accbullet(stg.kite_b, co, x, y, v, a, 30)
				obj.vscale, obj.b = 0.75, 0.75*obj.b
			end
			task.Wait(30)
			for k = 1, 5 do
				a = Angle(0, 0, self.vx, self.vy)
				way = int(2+0.5*k)
				for i = -way, way do
					for j = -1, 1 do
						f1(self.x, self.y, 1.75 - 0.04*abs(j), a + 1*j + 22.5*i, 6 + 2*(k%2))
					end
				end
				PlaySound("tan00")
				task.Wait(60)
			end
		end)
	elseif difficulty == 3 then
		task.New(self, function()
			local a, way
			local function f1(x, y, v, a, co)
				local obj = accbullet(stg.kite_b, co, x, y, v, a, 30)
				obj.vscale, obj.b = 0.75, 0.75*obj.b
			end
			task.Wait(30)
			for k = 1, 6 do
				a = Angle(0, 0, self.vx, self.vy)
				way = int(2+0.5*k)
				for i = -way, way do
					for j = -2, 2 do
						f1(self.x, self.y, 1.8 - 0.04*abs(j), a + 0.75*j + 22.5*i, 6 + 2*(k%2))
					end
				end
				PlaySound("tan00")
				task.Wait(45)
			end
		end)
	elseif difficulty == 4 then
		task.New(self, function()
			local a, way
			local function f1(x, y, v, a, co)
				local obj = accbullet(stg.kite_b, co, x, y, v, a, 30)
				obj.vscale, obj.b = 0.75, 0.75*obj.b
			end
			task.Wait(30)
			for k = 1, 10 do
				a = Angle(0, 0, self.vx, self.vy)
				way = int(3+0.5*k)
				for i = -way, way do
					for j = -2, 2 do
						f1(self.x, self.y, 2 - 0.05*abs(j), a + 1*j + 15*i, 6 + 2*(k%2))
					end
				end
				PlaySound("tan00")
				task.Wait(30)
			end
		end)
	end
end
--以下为第一种大怪不同的方式
function s3_enemy_1_1(x, y, st, hp, _num, _st, rot, co, _hp, range)
	New(tasker, function()
		task.Wait(30)
		local last = New(_s3_enemy_1, x, y, st, hp, co, range)
		move_1_1(last, rot)--添加一个move_1移动事件
		spawn_1_1(last, _num, x, y, _st, _hp, rot)--生成小怪
	end)
	New(tasker, function()
		task.Wait(130)
		local obj = New(e1, x, y, 1)
		obj.dye_range = 60
		move_1_1(obj, rot)
		task.Wait(60)
		obj = New(e1, x, y, 1)
		obj.dye_range = 60
		move_1_1(obj, rot)
	end)
end
function s3_enemy_1_2(x, y, st, hp, _num, _st, rot, co, _hp, range)
	New(tasker, function()
		task.Wait(30)
		local last = New(_s3_enemy_1, x, y, st, hp, co, range)
		move_1_2(last, rot)--添加一个move_2移动事件
		spawn_1_2(last, _num, x, y, _st, _hp, rot)--生成小怪
	end)
end
function s3_enemy_1_3(x, y, st, hp, _num, _st, rot, co, _hp, range)
	New(tasker, function()
		task.Wait(30)
		local last = New(_s3_enemy_1, x, y, st, hp, co, range)
		move_1_3(last, rot)--添加一个move_3移动事件
		spawn_1_3(last, _num, x, y, _st, _hp, rot)--生成小怪
	end)
end
function s3_enemy_1_4(x, y, st, hp, _num, _st, rot, co, _hp, range)
	New(tasker, function()
		task.Wait(30)
		local last = New(_s3_enemy_1, x, y, st, hp, co, range)
		move_1_4(last, rot)--添加一个move_3移动事件
		spawn_1_4(last, _num, x, y, _st, _hp, rot)--生成小怪
	end)
end
function s3_enemy_1_5(x, y, st, hp, _num, _st, rot, co, _hp, range)
	New(tasker, function()
		task.Wait(30)
		local last = New(_s3_enemy_1, x, y, st, hp, co, range)
		move_1_5(last, rot)--添加一个move_5移动事件
		spawn_1_5(last, _num, x, y, _st, _hp, rot)--生成小怪
	end)
end

local function b1(x, y, v, a)
	--第一种小怪的死尸弹
	local last = stg.newBulletStraight(stg.arrow_small, 10, true, x, y, 0.1, a)
	task.New(last, function()
		task.Wait(60)
		AddSimStrChV(last, 0, v, a, 60)
	end)
end
_s3_enemy_1_child = Class(enemy)--第一种大怪的衍生小怪的通用属性（可继承，直接修改这里）
function _s3_enemy_1_child:init(x, y, st, hp, mst, rot)
	local _hp = hp or 10
	self.x, self.y = x, y
	self.mst = mst
	enemy.init(self, st, _hp, false, false, false, false, 3, 0, 1)
	self.group = GROUP_NONTJT
	self.bound = false

	--移动(在子类灵活添加)
	--move_1(self, rot)
	--攻击

end
function _s3_enemy_1_child:kill()
	enemy.kill(self)
	if IsValid(self.mst) then
		Add_dye_range(self.mst, self.x, self.y, 20, 10, true, self.maxhp)
	end
	if not (self.sys_co == 1 or self.sys_co == 2) then
		local x, y = self.x, self.y
		New(tasker, function()
			if difficulty == 1 then
			elseif difficulty == 2 then
				local dv, a = 0, -90
				for _ = 1, 2 do
					PlaySound("tan00", 0.5)
					b1(x, y, 1 + dv, a)
					a = a + 30
					dv = dv + 0.5
					task.Wait(4)
				end
			elseif difficulty == 3 then
				local dv, a = 0, -90
				for _ = 1, 3 do
					PlaySound("tan00", 0.5)
					b1(x, y, 1.5 + dv, a)
					a = a + 30
					dv = dv + 0.5
					task.Wait(4)
				end
			elseif difficulty == 4 then
				local dv, a = 0, -120
				for _ = 1, 4 do
					PlaySound("tan00", 0.5)
					a = -120
					for _ = 1, 3 do
						b1(x, y, 2 + dv, a)
						a = a + 30
					end
					dv = dv + 0.5
					task.Wait(4)
				end
			end
		end)
	end
end

function s3_enemy_1_child_1(x, y, _st, _hp, self, rot, t)
	local last = New(_s3_enemy_1_child, x, y, _st, _hp, self, rot)
	move_1_1(last, rot)
	child_attack_1_1(self, t)
	return last
end
function s3_enemy_1_child_2(x, y, _st, _hp, self, rot)
	local last = New(_s3_enemy_1_child, x, y, _st, _hp, self, rot)
	move_1_2(last, rot)
	child_attack_1_1(self, rot)
	return last
end
function s3_enemy_1_child_3(x, y, _st, _hp, self, rot, t)
	local last = New(_s3_enemy_1_child, x, y, _st, _hp, self, rot)
	move_1_3(last, rot)
	child_attack_1_3(last, t)
	return last
end
function s3_enemy_1_child_4(x, y, _st, _hp, self, rot, t)
	local last = New(_s3_enemy_1_child, x, y, _st, _hp, self, rot)
	move_1_4(last, rot)
	child_attack_1_3(last, t)
	return last
end
function s3_enemy_1_child_5(x, y, _st, _hp, self, rot, t)
	local last = New(_s3_enemy_1_child, x, y, _st, _hp, self, rot)
	move_1_5(last, rot)
	child_attack_1_3(last, t)
	return last
end

--第二种连弹小怪
local function spawn_2_1(self, _st)
	local last
	New(tasker, function()
		local a = 45
		for _ = 1, 4 do
			last = s3_enemy_2_child_1(_st, 20, a)
			_connect(self, last, 0, false)
			a = a + 90
		end
	end)
end
local function spawn_2_2(self, _st, u)
	local last
	New(tasker, function()
		local a = 90 * u
		for _ = 1, 3 do
			last = s3_enemy_2_child_2(_st, 20, a, u)
			_connect(self, last, 0, false)
			a = a + 120
		end
	end)
end
local function spawn_2_3(self, _st1, _st2)
	local last
	New(tasker, function()
		local a = 90
		for _ = 1, 3 do
			last = s3_enemy_2_child_2(_st1, 20, a, 1)
			_connect(self, last, 0, false)
			last = s3_enemy_2_child_2(_st2, 50, a + 60, -1)
			_connect(self, last, 0, false)
			a = a + 120
		end
	end)
end
local function move_2_1(self, nowait, x, y)
	if nowait == true then
		local tmax, dt = 900, 1
		local road = AddSimStrChV(self, 4.5, 0, -90, 50, true, tmax - dt)
		dt = dt + 60
		local add = AddSimStrChV(self, 0, 1, -90, 600, true, tmax - dt)
		road = AddSimStrChV_Draw(dt, tmax, road, add)
		for i = 1, tmax - 1 do
			road[i][1], road[i][2] = road[i][1] + x, road[i][2] + y
		end
		return road
	else
		task.New(self, function()
			SimStrChV(self, 4.5, 0, -90, 50)
			task.Wait(60)
			SimStrChV(self, 0, 1, -90, 600)
			self.bound = true
		end)
	end
end
local function attack_2_1(self)
	if difficulty == 1 then
		task.New(self, function()
			task.Wait(90)
			local a = Angle(self, player)
			for k = 0, 1 do
				for i = -1, 1, 2 do
					accbullet(stg.arrow_big, 2, self.x, self.y, 1 + 0.2*k, a + 35*i, 30)
				end
				PlaySound("tan00", 0.5)
				task.Wait(3)
			end
		end)
	elseif difficulty == 2 then
		task.New(self, function()
			task.Wait(80)
			local a = Angle(self, player)
			for k = 0, 2 do
				for i = -1, 1 do
					accbullet(stg.arrow_big, 2, self.x, self.y, 1 + 0.2*k, a + 30*i, 30)
				end
				PlaySound("tan00", 0.5)
				task.Wait(3)
			end
		end)
	elseif difficulty == 3 then
		task.New(self, function()
			task.Wait(70)
			local a = Angle(self, player)
			for k = 0, 3 do
				for i = -2, 2 do
					accbullet(stg.arrow_big, 2, self.x, self.y, 1 + 0.2*k, a + 25*i, 30)
				end
				PlaySound("tan00", 0.5)
				task.Wait(3)
			end
		end)
	elseif difficulty == 4 then
		task.New(self, function()
			task.Wait(60)
			local a = Angle(self, player)
			for k = 0, 4 do
				for i = -4, 4 do
					accbullet(stg.arrow_big, 2, self.x, self.y, 1 + 0.25*k, a + 15*i, 30)
				end
				PlaySound("tan00", 0.5)
				task.Wait(3)
			end
		end)
	end
end
local function attack_2_2(self)
	if difficulty == 1 then
		task.New(self, function()
			local a, sp
			task.Wait(80)
			a = Angle(self, player)
			for i = 3, 1, -1 do
				PlaySound("tan00", 0.5)
				sp = -0.5 * (i - 1) * 36
				for _ = 1, i do
					accbullet(stg.arrow_big, 10, self.x, self.y, 1 + 0.2*(3-i), a + sp, 30)
					sp = sp + 36
				end
				task.Wait(3)
			end
			PlaySound("kira00", 0.5)
			a = Angle(self, player)
			for i = 1, 8 do
				for j = 0, 0 do
					for k = 0, 0 do
						stg.newBulletStraight(stg.grain_b, 2, true, self.x, self.y, 1.4 + 0.4*j - 0.1*abs(k), a + 45*i + 18*j + 0.75*k)
					end
				end
			end
		end)
	elseif difficulty == 2 then
		task.New(self, function()
			local a, sp
			task.Wait(80)
			a = Angle(self, player)
			for i = 4, 1, -1 do
				PlaySound("tan00", 0.5)
				sp = -0.5 * (i - 1) * 24
				for _ = 1, i do
					accbullet(stg.arrow_big, 10, self.x, self.y, 1 + 0.2*(4-i), a + sp, 30)
					sp = sp + 24
				end
				task.Wait(3)
			end
			PlaySound("kira00", 0.5)
			a = Angle(self, player)
			for i = 1, 10 do
				for j = 0, 1 do
					for k = 0, 0 do
						stg.newBulletStraight(stg.grain_b, 2, true, self.x, self.y, 1.4 + 0.4*j - 0.1*abs(k), a + 36*i + 18*j + 0.75*k)
					end
				end
			end
		end)
	elseif difficulty == 3 then
		task.New(self, function()
			local a, sp
			task.Wait(80)
			a = Angle(self, player)
			for i = 5, 1, -1 do
				PlaySound("tan00", 0.5)
				sp = -0.5 * (i - 1) * 18
				for _ = 1, i do
					accbullet(stg.arrow_big, 10, self.x, self.y, 1 + 0.2*(5-i), a + sp, 30)
					sp = sp + 18
				end
				task.Wait(3)
			end
			PlaySound("kira00", 0.5)
			a = Angle(self, player)
			for i = 1, 16 do
				for j = 0, 1 do
					for k = -1, 1 do
						stg.newBulletStraight(stg.grain_b, 2, true, self.x, self.y, 1.5 + 0.5*j - 0.1*abs(k), a + 22.5*i + 11.25*j + 0.75*k)
					end
				end
			end
		end)
	elseif difficulty == 4 then
		task.New(self, function()
			local a, sp
			task.Wait(80)
			a = Angle(self, player)
			for i = 6, 1, -1 do
				PlaySound("tan00", 0.5)
				sp = -0.5 * (i - 1) * 12
				for _ = 1, i do
					accbullet(stg.arrow_big, 10, self.x, self.y, 1 + 0.25*(6-i), a + sp, 30)
					sp = sp + 12
				end
				task.Wait(3)
			end
			PlaySound("kira00", 0.5)
			a = Angle(self, player)
			for i = 1, 24 do
				for j = 0, 2 do
					for k = -1, 1 do
						stg.newBulletStraight(stg.grain_b, 2, true, self.x, self.y, 1.5 + 0.5*j - 0.1*abs(k), a + 15*i + 5*j + k)
					end
				end
			end
		end)
	end
end
--大蝴蝶召唤的鬼火的攻击和移动
local function child_move_2_1(self, a)
	egg.SimAlpCh(self, 0, 255, 30)
	task.New(self, function()
		local r, ax, ay, x0, y0 = 0, cos(a), sin(a), self._master.x, self._master.y
		for _ = 1, 40 do
			r = r + 0.75
			if IsValid(self._master) then
				x0, y0 = self._master.x, self._master.y
			end
			self.x = x0 + r * ax
			self.y = y0 + r * ay
			task.Wait(1)
		end
		task.Wait(60)
		self.bound = true
		AddV2(self, self.dx, self.dy)
		for _ = 1, 300 do
			SetA(self, 0.008, Angle(self, player), 0, 0, 0, false)
			task.Wait(1)
		end
		SetA(self, 0, 0, 0, 0, 0, false)
	end)
end
local function child_move_2_2(self, a, u)
	egg.SimAlpCh(self, 0, 255, 30)
	task.New(self, function()
		local r, ax, ay, angle, x0, y0 = 0, cos(a), sin(a)
		for _ = 1, 40 do
			r = r + 0.75
			if IsValid(self._master) then
				x0, y0 = self._master.x, self._master.y
			end
			self.x = x0 + r * ax
			self.y = y0 + r * ay
			task.Wait(1)
		end
		task.Wait(60)
		self.bound = true
		ax, ay = self.dx / 60, self.dy / 60
		for _ = 1, 300 do
			angle = Angle(0, 0, self.dx, self.dy)
			AddA1(self, 0.0005, angle + 150 * u)
			AddV2(self, ax, ay)
			task.Wait(1)
		end
		SetA(self, 0, 0, 0, 0, 0, false)
	end)
end
local function child_attack_2_1(self)
	if difficulty == 1 then
		task.New(self, function()
			task.Wait(40)
			local a
			for _ = 1, 2 do
				a = Angle(self, player)
				for i = 1, 1 do
					for j = 0, 0 do
						accbullet(stg.grain_a, 4, self.x, self.y, 1.2 + 0.2*j, a + 2*i, 60)
					end
				end
				PlaySound("tan00")
				task.Wait(75)
			end
		end)
	elseif difficulty == 2 then
		task.New(self, function()
			task.Wait(30)
			local a
			for _ = 1, 3 do
				a = Angle(self, player)
				for i = 1, 1 do
					for j = 0, 1 do
						accbullet(stg.grain_a, 4, self.x, self.y, 1.4 + 0.2*j, a + 2*i, 60)
					end
				end
				PlaySound("tan00")
				task.Wait(60)
			end
		end)
	elseif difficulty == 3 then
		task.New(self, function()
			task.Wait(20)
			local a
			for _ = 1, 4 do
				a = Angle(self, player)
				for i = -1, 1, 2 do
					for j = 0, 1 do
						accbullet(stg.grain_a, 4, self.x, self.y, 1.4 + 0.4*j, a + 2*i, 60)
					end
				end
				PlaySound("tan00")
				task.Wait(45)
			end
		end)
	elseif difficulty == 4 then
		task.New(self, function()
			task.Wait(10)
			local a
			for _ = 1, 6 do
				a = Angle(self, player)
				for i = -1, 1 do
					for j = 0, 1 do
						accbullet(stg.grain_a, 4, self.x, self.y, 1.5 + 0.5*j, a + 30*i, 60)
						--stg.newBulletStraight(stg.grain_a, 4, true, self.x, self.y, 1.5 + 0.5*j, a + 30*i)
					end
				end
				PlaySound("tan00")
				task.Wait(30)
			end
		end)
	end
end
local function child_attack_2_2(self, u)
	u = u or 1
	if difficulty == 1 then
		task.New(self, function()
			task.Wait(50)
			local a, da = Angle(0, 0, self.dx, self.dy) + 180, 30*u
			for _ = 1, 6 do
				for j = 0, 0 do
					accbullet(stg.grain_a, 5, self.x, self.y, 1.2 + 0.35*j, a, 60)
				end
				task.Wait(24)
				a = a + da
			end
		end)
	elseif difficulty == 2 then
		task.New(self, function()
			task.Wait(30)
			local a, da = Angle(0, 0, self.dx, self.dy) + 180, 24*u
			for _ = 1, 12 do
				for j = 0, 0 do
					accbullet(stg.grain_a, 5, self.x, self.y, 1.4 + 0.35*j, a, 60)
				end
				task.Wait(12)
				a = a + da
			end
		end)
	elseif difficulty == 3 then
		task.New(self, function()
			task.Wait(20)
			local a, da = Angle(0, 0, self.dx, self.dy) + 180, 18*u
			for _ = 1, 20 do
				for j = 0, 1 do
					accbullet(stg.grain_a, 5, self.x, self.y, 1.4 + 0.35*j, a, 60)
				end
				task.Wait(9)
				a = a + da
			end
		end)
	elseif difficulty == 4 then
		task.New(self, function()
			task.Wait(10)
			local a, da = Angle(0, 0, self.dx, self.dy) + 180, 12*u
			for _ = 1, 30 do
				for j = 0, 2 do
					accbullet(stg.grain_a, 5, self.x, self.y, 1.5 + 0.35*j, a, 60)
				end
				task.Wait(6)
				a = a + da
			end
		end)
	end
end

_s3_enemy_2 = Class(enemy)
function _s3_enemy_2:init(x, y, st, co, hp)
	self.x, self.y = x, y
	co = co or 1
	enemy.init(self, st, 30, false, false, false, true, co, 100, 1)
	self.group = GROUP_NONTJT
	--self.a, self.b = 16, 16
	self.dmgrate = 0.1
	task.New(self, function()
		task.Wait(60)
		local dr = 0.9 / 30
		for _ = 1, 30 do
			self.dmgrate = self.dmgrate + dr
			task.Wait(1)
		end
	end)
end

function s3_enemy_2_1(x, y, st, co, hp, _st)
	New(tasker, function()
		task.Wait(30)
		local last = New(_s3_enemy_2, x, y, st, co, hp)
		--移动
		move_2_1(last)
		--攻击
		attack_2_1(last)
		task.Wait(90)
		--生成小怪
		if IsValid(last) then
			spawn_2_1(last, _st)
		end
	end)
end
function s3_enemy_2_2(x, y, st, co, hp, _st, u)
	New(tasker, function()
		task.Wait(30)
		local last = New(_s3_enemy_2, x, y, st, co, hp)
		--移动
		move_2_1(last)
		--攻击
		attack_2_2(last)
		task.Wait(90)
		--生成小怪
		if IsValid(last) then
			spawn_2_2(last, _st, u)
		end
	end)
end
function s3_enemy_2_3(x, y, st, co, hp, _st1, _st2)
	New(tasker, function()
		task.Wait(30)
		local last = New(_s3_enemy_2, x, y, st, co, hp)
		--移动
		move_2_1(last)
		--攻击
		attack_2_2(last)
		task.Wait(90)
		--生成小怪
		if IsValid(last) then
			spawn_2_3(last, _st1, _st2)
		end
	end)
end

local function b2(x, y, v, a)
	local last = stg.newBulletStraight(stg.arrow_small, 2, true, x, y, 0.2, a)
	task.New(last, function()
		task.Wait(60)
		egg.AddSimStrChV(last, 0, v, a, 60)
	end)
end
_s3_enemy_2_child = Class(enemy)
function _s3_enemy_2_child:init(st, hp, a)
	enemy.init(self, st, 20, false, false, false, false, nil, 0, 1)
	self.a, self.b = 8, 8
	--移动
	self.hscale, self.vscale = 1, 1
	self.group = GROUP_NONTJT
	self.layer = LAYER_ENEMY-1
	self.colli = false
	--攻击

end
function _s3_enemy_2_child:kill()
	enemy.kill(self)
	if IsValid(self.mst) and self.timer <= 120 then
		Kill_Bullet(self.x, self.y, 60, true)
	end
	if not (self.sys_co == 1 or self.sys_co == 2) then
		if difficulty == 1 then
			local a = Angle(self, player) + 45
			for _ = 1, 4 do
				b2(self.x, self.y, 1, a)
				a = a + 90
			end
		elseif difficulty == 2 then
			local a = Angle(self, player) + 30
			for _ = 1, 6 do
				b2(self.x, self.y, 1.3, a)
				a = a + 60
			end
		elseif difficulty == 3 then
			local a = Angle(self, player) + 22.5
			for _ = 1, 8 do
				b2(self.x, self.y, 1.6, a)
				a = a + 45
			end
		elseif difficulty == 4 then
			local a = Angle(self, player) + 15
			for _ = 1, 12 do
				b2(self.x, self.y, 2, a)
				a = a + 30
			end
		end
	end
end

function s3_enemy_2_child_1(st, hp, a)
	local last = New(_s3_enemy_2_child, st, hp, a)
	--攻击
	child_attack_2_1(last)
	--移动
	child_move_2_1(last, a)
	return last
end
function s3_enemy_2_child_2(st, hp, a, u)
	local last = New(_s3_enemy_2_child, st, hp, a)
	--攻击
	child_attack_2_2(last, u)
	--移动
	child_move_2_2(last, a, u)
	return last
end

--死尸弹小怪
s3_enemy_3 = Class(enemy)
function s3_enemy_3:init(x, y, st, co, hp)
	self.x, self.y = x, y
	enemy.init(self, 3, hp, false, false, false, nil, co, 100, 1)
	self.group = GROUP_NONTJT
	--移动
	task.New(self, function()
		egg.SimStrChV(self, 4.5, 0.25, -90, 50)
		task.Wait(120)
		self.bound = true
		for _ = 1, 120 do
			SetA(self, 0.02, Angle(self, player), 0, 0, 0, false)
			task.Wait(1)
		end
	end)
end
function s3_enemy_3:kill()
	enemy.kill(self)
	if self.y >= 0 or Dist(self, player) >= 50 then
		if difficulty == 1 then
		elseif difficulty == 2 then
			PlaySound("kira00", 0.5, self.x / 256, false)
			local a = Angle(self, player)
			for i = -1, 1 do
				accbullet(stg.arrow_small, 1, self.x, self.y, 1.75, a + 1*i, 60)
			end
		elseif difficulty == 3 then
			PlaySound("kira00", 0.5, self.x / 256, false)
			local a = Angle(self, player)
			for i = -1, 1 do
				--accbullet(stg.arrow_small, 1, self.x, self.y, 2, a + 4*i, 60)
				for u = -1, 1, 2 do
					accbullet(stg.arrow_small, 3, self.x, self.y, 2, a + 2*i + 30*u, 60)
				end
			end
		elseif difficulty == 4 then
			PlaySound("kira00", 0.5, self.x / 256, false)
			local a = Angle(self, player)
			for i = -1, 1 do
				accbullet(stg.arrow_small, 1, self.x, self.y, 2, a + 4*i, 60)
				for u = -1, 1, 2 do
					accbullet(stg.arrow_small, 3, self.x, self.y, 2.5, a + 4*i + 30*u, 60)
				end
			end
		end
	end
end
function s3_enemy_3:dyeKill()
	enemy.kill(self)
	if self.y >= 0 or Dist(self, player) >= 50 then
		if difficulty == 1 then
		elseif difficulty == 2 then
			PlaySound("kira00", 0.5, self.x / 256, false)
			local a = Angle(self, player)
			for i = -1, 1 do
				accbullet(stg.arrow_small, 1, self.x, self.y, 1.5, a + 1*i, 60)
			end
		elseif difficulty == 3 then
			PlaySound("kira00", 0.5, self.x / 256, false)
			local a = Angle(self, player)
			for i = -1, 1 do
				accbullet(stg.arrow_small, 1, self.x, self.y, 1.75, a + 2*i, 60)
			end
		elseif difficulty == 4 then
			PlaySound("kira00", 0.5, self.x / 256, false)
			local a = Angle(self, player)
			for i = -1, 1 do
				accbullet(stg.arrow_small, 1, self.x, self.y, 2, a + 4*i, 60)
			end
		end
	end
	_del(self)
end
------------------------------------新定义的
--工具怪
e1 = Class(enemy)
function e1:init(x, y, u, co, IsGhost)
	co = co or 1
	enemy.init(self, 5, 20, false, false, false, true, co, 75, 1)
	self.x, self.y = x, y
	self.group = GROUP_NONTJT
	if IsGhost then
		for i = 0, 2 do
			New(e1_1, self, 120 * i + 90 + 90 * u, -u)
		end
	end
	task.New(self, function()
		local diff = difficulty
		if diff == 4 then
			task.Wait(30)
			local a, da = 0, 20 * u
			for _ = 1, 9 do
				for i = 1, 4 do
					for j = 0, 3 do
						stg.newBulletStraight(stg.arrow_big, 4, true, self.x, self.y, 1.5 + 0.25*j, a + 110 * i)
					end
				end
				task.Wait(10)
				a = a + da
			end
		elseif diff == 3 then
			task.Wait(50)
			local a, da = 0, 30 * u
			for _ = 1, 6 do
				for i = 1, 4 do
					stg.newBulletStraight(stg.arrow_big, 4, true, self.x, self.y, 2, a + 110 * i)
				end
				task.Wait(15)
				a = a + da
			end
		elseif diff == 2 then
			task.Wait(70)
			local a, da = 0, 30 * u
			for _ = 1, 4 do
				for i = 1, 3 do
					stg.newBulletStraight(stg.arrow_big, 4, true, self.x, self.y, 1.5, a + 120 * i)
				end
				task.Wait(20)
				a = a + da
			end
		else
			task.Wait(90)
			local a, da = 0, 30 * u
			for _ = 1, 2 do
				for i = 1, 2 do
					stg.newBulletStraight(stg.arrow_big, 4, true, self.x, self.y, 1, a + 180 * i)
				end
				task.Wait(30)
				a = a + da
			end
		end
	end)
end

--自带的鬼火使魔
e1_1 = Class(enemy)
function e1_1:init(mst, a, u)
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
end

local function f1(x, y, u, co, IsGhost)
	local obj = New(e1, x, y, u, co, IsGhost)
	obj.dmgrate = 0.1
	task.New(obj, function()
		egg.AddSimStrChV(obj, 1, 3, -90, 60)
		local dr = 0.9 / 60
		for _ = 1, 60 do
			obj.dmgrate = obj.dmgrate + dr
			task.Wait(1)
		end
	end)
end

--用给最后一波爆菊大怪的危险警告
local danger_eff = Class(object)
function danger_eff:init(x, y)
	self.x, self.y = x, y
	self.group = GROUP_GHOST
	self.img = "danger_eff"
	self.hscale, self.vscale = 3, 3
	self.rot = 0
	_object.set_color(self, "", 0, 255, 255, 255)
	egg.SimAlpCh(self, 0, 255, 30)
	egg.SimSizeCh(self, 3, 1, 45)
	task.New(self, function()
		for x = 0, 90, 2 do
			self.rot = 180*cos(x)
			task.Wait(1)
		end
		task.Wait(30)
		egg.SimAlpCh(self, 255, 0, 45)
		egg.SimSizeCh(self, 1, 0, 45)
		task.Wait(45)
		Del(self)
	end)
end
function danger_eff:frame()
	task.Do(self)
end
function danger_eff:render()
	SetImgState(self, "", self._a, 255, 255, 255)
	Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
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
--道中本体
local function road(self)
	do
		system.setTargetChain(450)
		LoadMusicRecord("s3")
		s3_boss.load_res_main()
		New(stage3_background)
	end
	task.Wait(10)
	task.New(self, function()
		task._Wait(30)
		EISlib.stage.playMusic("s3", 0, true)
	end)
	s3_enemy_1_1(223, 0, 5, 80, 9, 1, 10, 2)
	task._Wait(360)
	s3_title()
	task.Wait(200)
	local co, st, _st, dx, dy, u, x
	co = { 2, 1, 2, 1 }
	st = { 9, 10, 9, 10 }
	_st = { 18, 20, 18, 20 }

	--填充的绿色小怪
	task.New(self, function()
		local x, dx = 150, -300 / 8
		task.Wait(310)
		task.New(self, function()
			task.Wait(30)
			for i = 0, 2 do
				f1(120 - 120 * i, 240, 1, 1, true)
				task.Wait(30)
			end
		end)
		for _ = 1, 9 do
			New(s3_enemy_3, x, 240, 1, 3, 8)
			x = x + dx
			task.Wait(15)
		end
	end)
	dx, dy = -90, 280
	for i = 1, 4 do
		s3_enemy_2_1(dx, dy, st[i], co[i], 30, _st[i])
		task.Wait(60)
		dx, dy = dx + 60, dy - 30
	end
	task.Wait(160) --第1100帧率

	task.New(self, function()
		local x, dx = -150, 300 / 8
		task.Wait(310)
		task.New(self, function()
			task.Wait(30)
			for i = 0, 2 do
				f1(-120 + 120 * i, 240, -1, 1, true)
				task.Wait(30)
			end
		end)
		for _ = 1, 9 do
			New(s3_enemy_3, x, 240, 1, 3, 8)
			x = x + dx
			task.Wait(15)
		end
	end)
	dx, dy = 90, 280
	for i = 1, 4 do
		s3_enemy_2_1(dx, dy, st[i], co[i], 30, _st[i])
		task.Wait(60)
		dx, dy = dx - 60, dy - 30
	end
	--第1340帧

	task.Wait(280) --1500
	s3_enemy_1_2(-243, 0, 5, 100, 9, 2, 1, 2, 15, 100)
	task.Wait(120)
	f1(-50, 240, 1, 2, true)
	task.Wait(130) --1750
	s3_enemy_1_2(243, 30, 6, 100, 9, 2, nil, 2, 15, 120)
	--task.Wait(200) --1950
	task.New(self, function()
		task.Wait(120)
		local x, dx = 120, -240 / 7
		for _ = 1, 8 do
			New(s3_enemy_3, x, 240, 1, 3, 8)
			x = x + dx
			task.Wait(10)
		end
	end)

	task.Wait(350) --2100
	task.New(self, function()
		task.Wait(30)
		local x, dx = -150, 300 / 8
		task.New(self, function()
			task.Wait(30)
			for i = 0, 2 do
				f1(-120 + 110 * i, 240, -1, 2, true)
				task.Wait(30)
			end
		end)
		for _ = 1, 9 do
			New(s3_enemy_3, x, 240, 1, 3, 8)
			x = x + dx
			task.Wait(15)
		end
	end)

	task.Wait(180) --2280
	task.New(self, function()
		task.Wait(30)
		local x, dx = 150, -300 / 8
		task.New(self, function()
			task.Wait(30)
			for i = 0, 2 do
				f1(120 - 110 * i, 240, 1, 2, true)
				task.Wait(30)
			end
		end)
		for _ = 1, 9 do
			New(s3_enemy_3, x, 240, 1, 3, 8)
			x = x + dx
			task.Wait(15)
		end
	end)

	task.Wait(180) --2460
	task.New(self, function()
		task.Wait(30)
		local x, dx = 150, -300 / 8
		task.New(self, function()
			task.Wait(30)
			for i = 0, 2 do
				f1(120 - 110 * i, 240, 1, 2, true)
				task.Wait(30)
			end
		end)
		for _ = 1, 9 do
			New(s3_enemy_3, x, 240, 1, 3, 8)
			x = x + dx
			task.Wait(15)
		end
	end)

	task.Wait(180) --2640
	task.New(self, function()
		task.Wait(150)
		local x, dx = 20, 120 / 7
		for _ = 1, 8 do
			for u = -1, 1, 2 do
				New(s3_enemy_3, x * u, 240, 1, 3, 8)
			end
			x = x + dx
			task.Wait(20)
		end
	end)
	dx, dy = 30, 280
	u = 1
	for _ = 1, 3 do
		s3_enemy_2_1(dx * u, dy, 9, 1, 30, 18)
		s3_enemy_2_1(-dx * u, dy, 10, 2, 30, 20)
		task.Wait(75)
		dx, dy, u = dx + 60, dy - 30, -u
	end
	--2865

	task._Wait(335)
	for _, unit in ObjList(GROUP_NONTJT) do
		Del(unit)
	end
	for _, unit in ObjList(GROUP_ENEMY_BULLET) do
		_del(unit, true)
	end

	local boss = s3_boss.mid1(self) -- 中boss1

	task.New(self, function()
		task.Wait(300)
		--偷懒的增援
		local x, dx, u = -150, 300 / 7, 1
		for _ = 1, 6 do
			x, dx = 150*u, -300/4*u
			for _ = 1, 5 do
				if not IsValid(boss) then
					New(s3_enemy_3, x, 240, 1, 3, 16)
				end
				x = x + dx
				task.Wait(20)
			end
			u = -u
		end
		--再补两只大怪
		for u = -1, 1, 2 do
			for i = 0, 1 do
				if not IsValid(boss) then
					New(tasker, function()
						local x, y = -(60 - 120*i), 245
						s3_enemy_2_1(x, y, 9, 2, 30, 18)
						task.Wait(120)
						f1(x, y, u, 2)
					end)
				end
				task.Wait(60)
			end
			task.Wait(60)
		end
	end)
	task.Wait(1300) --4500


	task.New(self, function()
		local x, dx = 150, -300 / 8
		task.Wait(310)
		task.New(self, function()
			task.Wait(30)
			for i = 0, 2 do
				f1(120 - 110 * i, 240, 1)
				task.Wait(30)
			end
		end)
		for _ = 1, 9 do
			New(s3_enemy_3, x, 240, 1, 3, 8)
			x = x + dx
			task.Wait(15)
		end
	end)

	dx, dy = -90, 290
	u = 1
	for i = 1, 4 do
		s3_enemy_2_2(dx, dy, st[i], co[i], 30, _st[i], u)
		task.Wait(60)
		dx, dy, u = dx + 60, dy - 30, -u
	end
	task.Wait(160) --第1100帧率
	task.New(self, function()
		local x, dx = -150, 300 / 8
		task.Wait(310)
		task.New(self, function()
			task.Wait(30)
			for i = 0, 2 do
				f1(-120 + 110 * i, 240, -1)
				task.Wait(30)
			end
		end)
		for _ = 1, 9 do
			New(s3_enemy_3, x, 240, 1, 3, 8)
			x = x + dx
			task.Wait(15)
		end
	end)

	dx, dy = 90, 290
	for i = 1, 4 do
		s3_enemy_2_2(dx, dy, st[i], co[i], 30, _st[i], u)
		task.Wait(60)
		dx, dy, u = dx - 60, dy - 30, -u
	end
	--680
	task.Wait(150)
	--830
	s3_enemy_1_3(-175, 240, 5, 240, 15, 3, 1, 2, 10, 0)
	task.Wait(240)
	dx, dy = 0, 260
	for i = 1, 2 do
		s3_enemy_2_2(dx, dy, st[i], 1, 30, _st[i], u)
		task.Wait(50)
		dx, u = dx - 60, -u
	end
	task.Wait(50)
	--1220
	s3_enemy_1_3(175, 240, 6, 240, 15, 4, 2, 2, 10, 0)
	task.Wait(240)
	dx, dy = 0, 260
	for i = 1, 2 do
		s3_enemy_2_2(dx, dy, st[i], 1, 30, _st[i], u)
		task.Wait(50)
		dx, u = dx + 60, -u
	end
	task.Wait(50)
	--1610
	task.Wait(270)
	--2000(6000)
	do
		for _, unit in ObjList(GROUP_NONTJT) do
			--noDropKill(unit)
			_del(unit, true)
		end
		for _, unit in ObjList(GROUP_ENEMY_BULLET) do
			_del(unit, true)
		end
		lasttask = task.New(self, function()
			task._Wait(60)
			for _, unit in ObjList(GROUP_ENEMY_BULLET) do
				_del(unit, true)
			end
		end)
	end

	boss = s3_boss.mid2(self) -- 中boss2

	task.Wait(420)
	task.New(self, function()
		--偷懒的增援
		task.Wait(240 + 480)
		local x, dx, u = -150, 300 / 7, 1
		for _ = 1, 6 do
			x, dx = (150 - 300 / 4) * u, -300 / 7 * u
			for _ = 1, 5 do
				if not IsValid(boss) then
					New(s3_enemy_3, x, 240, 1, 3, 16)
				end
				x = x + dx
				task.Wait(15)
			end
			u = -u
		end
	end)
	task.Wait(1300)

	enemy_kill_counter:Reset() --8100

	s3_enemy_1_4(-224, 80, 5, 150, 15, 2, 1, 2, 15, 100)
	task.Wait(120)

	dx, dy = -90, 250
	for i = 2, 1, -1 do
		s3_enemy_2_1(dx, dy, st[i], co[i], 30, _st[i])
		task.Wait(60)
		dx = dx + 180
	end

	x, dx, u = -100, 300 / 7, 1
	for _ = 1, 4 do
		for _ = 1, 2 do
			New(s3_enemy_3, x * u, 240, 1, 3, 1)
			u = -u
		end
		x = x + dx
		task.Wait(20)
	end

	s3_enemy_2_3(0, 230, 9, 1, 30, 17, 18)

	--这一部份全是增援
	task.New(self, function()
		local x, dx = 150, -300 / 7
		for _ = 1, 6 do
			if enemy_kill_counter.add_enemy == true then
				New(s3_enemy_3, x, 240, 1, 3, 16)
			else
				enemy_kill_counter:NotIsValidEnemy() --判断这中间是否还存在敌人
			end
			x = x + dx
			task.Wait(30)
		end
		x, dx = -150 + 300 / 7, 300 / 7
		for _ = 1, 5 do
			if enemy_kill_counter.add_enemy == true then
				New(s3_enemy_3, x, 240, 1, 3, 16)
			else
				enemy_kill_counter:NotIsValidEnemy() --判断这中间是否还存在敌人
			end
			x = x + dx
			task.Wait(30)
		end
	end)
	task.Wait(120)
	f1(0, 240, 1, 2) --再补一个工具人
	task.Wait(260)
	enemy_kill_counter:Reset()

	s3_enemy_1_4(224, 80, 5, 150, 15, 1, 2, 1, 15, 100)
	task.Wait(120)

	dx, dy = 90, 250
	for i = 1, 2 do
		s3_enemy_2_1(dx, dy, st[i], co[i], 30, _st[i])
		task.Wait(60)
		dx = dx - 180
	end

	x, dx, u = -100, 300 / 7, 1
	for _ = 1, 4 do
		for _ = 1, 2 do
			New(s3_enemy_3, x * u, 240, 1, 3, 1)
			u = -u
		end
		x = x + dx
		task.Wait(20)
	end

	s3_enemy_2_3(0, 230, 9, 2, 30, 17, 18)

	--相反的一部份全是增援
	task.New(self, function()
		local x, dx = -150, 300 / 7
		for _ = 1, 6 do
			if enemy_kill_counter.add_enemy == true then
				New(s3_enemy_3, x, 240, 1, 3, 16)
			else
				enemy_kill_counter:NotIsValidEnemy() --判断这中间是否还存在敌人
			end
			x = x + dx
			task.Wait(30)
		end
		x, dx = 150 - 300 / 7, -300 / 7
		for _ = 1, 5 do
			if enemy_kill_counter.add_enemy == true then
				New(s3_enemy_3, x, 240, 1, 3, 16)
			else
				enemy_kill_counter:NotIsValidEnemy() --判断这中间是否还存在敌人
			end
			x = x + dx
			task.Wait(30)
		end
	end)

	task.Wait(120)
	f1(0, 240, 1, 2) --再补一个工具人
	task.Wait(260)
	enemy_kill_counter:Reset()

	s3_enemy_1_5(-150, -240, 5, 100, 15, 1, 1, 1, 15, 100)
	s3_enemy_1_5(150, -240, 6, 100, 15, 2, 2, 2, 15, 100)
	--[[for i = 0, 7 do
		for u = -1, 1, 2 do
			New(danger_eff, 120*u, -200 + 50*i)
		end
		task.Wait(5)
	end]]
	task.Wait(200)
	s3_enemy_2_3(-80, 270, 10, 2, 30, 17, 18)
	s3_enemy_2_3(80, 270, 10, 2, 30, 17, 18)
	task.Wait(60)
	s3_enemy_2_3(0, 230, 10, 1, 30, 18, 17)
	task.Wait(120)
	f1(0, 240, 1, 2) --再补一个工具人
	task.Wait(280)
	do
		for _, unit in ObjList(GROUP_NONTJT) do
			--noDropKill(unit)
			_del(unit, true)
		end
		for _, unit in ObjList(GROUP_ENEMY_BULLET) do
			_del(unit, true)
		end
		task._Wait(60)
		for _, unit in ObjList(GROUP_ENEMY_BULLET) do
			_del(unit, true)
		end
	end
	s3_boss.main(self)
	task.Wait(120)
	system.makeSettlement(3)
	task.Wait(120)
end

s3_road.main = road
