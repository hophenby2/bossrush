--一些常见的弹幕形状发射器

--1、清蓝非的锥弹（同时发射）
---@param x  @发射子弹的x坐标
---@param y  @发射子弹的y坐标
---@param layer @子弹的层数
---@param v0 @第一层的速度
---@param dv @每层的速度差
---@param a0  @中心指向的角度
---@param dsp  @同层中相邻子弹的角度
---@param style @子弹弹形
---@param color @子弹颜色
function qingLan1(x, y, layer, v0, dv, a0, dsp, style, color)
	local a1, lastGroup, count
	lastGroup = {}
	count = 0
	for way = 1, layer do
		a1 = 0.5 * (way - 1) * dsp
		for _ = 1, way do
			count = count + 1
			lastGroup[count] = New(straight, style, color, true, x, y, v0, a0 + a1, 0)
			a1 = a1 - dsp
		end
		v0 = v0 + dv
	end
	return lastGroup, count --返回一个该函数生成的所有子弹的表以及其元素数
end

--2、清蓝非的锥弹（间隔发射）
---@param o  @发弹子弹的对象
---@param interval @每层发射间隔
---@param layer @子弹的层数
---@param v0 @第一层的速度
---@param dv @每层的速度差
---@param a0  @中心指向的角度
---@param dsp  @同层中相邻子弹的角度
---@param style @子弹弹形
---@param color @子弹颜色
function qingLan2(o, interval, layer, v0, dv, a0, dsp, style, color)
	local lastGroup, count
	lastGroup = {}
	task.New(self, function()
		local a1
		count = 0
		for way = 1, layer do
			a1 = 0.5 * (way - 1) * dsp
			for _ = 1, way do
				count = count + 1
				lastGroup[count] = New(straight, style, color, true, o.x, o.y, v0, a0 + a1, 0)
				a1 = a1 - dsp
			end
			task.Wait(interval)
			v0 = v0 + dv
		end
	end)
	return lastGroup, count --返回一个该函数生成的所有子弹的表以及其元素数
end


--多角开花弹
function flower(o, v, dv, a, ways, layer, style, color)
	local lastGroup, count = {}, 0
	local a1, da1, a2, da2, v0 = a, 360 / ways, 0, 180 / ways / (layer - 1), v
	for _ = 1, 2 do
		for _ = 1, ways do
			a2 = a1
			v0 = v + dv * (layer - 1)
			for _ = 1, layer do
				count = count + 1
				lastGroup[count] = New(straight, style, color, true, o.x, o.y, v0, a2, 0)
				a2 = a2 + da2
				v0 = v0 - dv
			end
			a1 = a1 + da1
		end
		da2 = -da2
	end
	return lastGroup, count --返回一个该函数生成的所有子弹的表以及其元素数
end


--单层多way弹幕
local function SingleWay(x, y, way, a, sp, v, func)
	a = a or 0
	v = v or 6
	sp = sp or 0
	a = a + 0.5 * sp
	local dsp = -sp / (way - 1)
	for _ = 1, way do
		func(x, y, v, a)
		a = a + dsp
	end
end
egg.SingleWay = SingleWay

--多层多way弹幕
local function MultiWay(x, y, way, layer, a, sp, v, dv, func, da)
	da = da or 0 --要是每层都要有偏差的话
	v = v or 6
	dv = dv or 2
	for _ = 1, layer do
		SingleWay(x, y, way, a, sp, v, func)
		v = v + dv
		a = a + da
	end
end
egg.MultiWay = MultiWay

--定点发射的一长串的差速弹幕
local function SingleBunch(x, y, layer, a, v, dv, da, t, func)
	a = a or 0
	v = v or 1
	dv = dv or 0
	da = da or 0
	for _ = 1, layer do
		func(x, y, v, a)
		v = v + dv
		a = a + da
		task.Wait(t)
	end
end
egg.SingleBunch = SingleBunch
