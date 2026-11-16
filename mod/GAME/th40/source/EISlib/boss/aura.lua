local ran = lstg.Rand()
local _infinite = math.huge
local saoqi1, saoqi2, saoqi3
boss_saoqi = Class(object)
function boss_saoqi:init(mst, dy)
	dy = dy or -10
	self.boss = mst
	self.bound = false
	self.x, self.y = mst.x, mst.y
	local r, g, b, blend = mst.saoqiR, mst.saoqiG, mst.saoqiB, mst.saoqiBlend
	task.New(self, function()
		for t = 1, _infinite do
			if IsValid(mst) then
				self.x, self.y = mst.x, mst.y + dy
				if mst.aura_alpha_d > 0 then
					if t%15 == 0 then
						New(saoqi1, self, r, g, b, blend, ran:Float(-6, 6))
					end
					if t%24 == 0 then
						New(saoqi2, self, blend, ran:Float(0, 360))
					end
					if t%8 == 0 then
						New(saoqi3, self, r, g, b, blend, ran:Float(0, 360))
					end
				end
			end
			task.Wait(1)
		end
	end)
end
function boss_saoqi:frame()
	local mst = self.boss
	if IsValid(mst) and not mst.hide then
		task.Do(self)
	end
end
function boss_saoqi:render()
	--Render("ball_huge1", self.x, self.y, 0, 1, 1)
end

local size = 1.25
saoqi1 = Class(object)
function saoqi1:init(mst, r, g, b, blend, angle)
	self.layer = LAYER_ENEMY - 10
	self.img = "saoqi2"
	self.hscale, self.vscale = size, 0
	self.rot = angle
	robject.set_color(self, blend, 255, r, g, b)
	--长宽比和透明度变化
	task.New(self, function()
		local d_a, dh, dv, x, y, dy = -255/40, size*2.25/40, size*4/40, ran:Float(-5, 5), 0, 0.5
		for _ = 1, 40 do
			y = y + dy
			if IsValid(mst) then
				self.x, self.y = mst.x + x, mst.y + y
			else
				break
			end
			self.hscale, self.vscale = self.hscale + dh, self.vscale + dv
			self._a = self._a + d_a
			task.Wait(1)
		end
		Del(self)
	end)
end
function saoqi1:frame()
	task.Do(self)
end
function saoqi1:render()
	SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
	Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

saoqi2 = Class(object)
function saoqi2:init(mst, blend, angle)
	self.layer = LAYER_ENEMY - 11
	self.img = "saoqi1"
	self.hscale, self.vscale = 3*size, 2*size
	self.rot = angle
	robject.set_color(self, blend, 75, 255, 255, 255)
	--长宽比和透明度变化
	task.New(self, function()
		local d_a, dh, dv = 0/60, -2/60*size, -1/60*size
		for _ = 1, 60 do
			if IsValid(mst) then
				self.x, self.y = mst.x, mst.y
			else
				break
			end
			self.hscale, self.vscale = self.hscale + dh, self.vscale + dv
			self._a = self._a + d_a
			task.Wait(1)
		end
		Del(self)
	end)
end
function saoqi2:frame()
	task.Do(self)
end
function saoqi2:render()
	SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
	Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

saoqi3 = Class(object)
function saoqi3:init(mst, r, g, b, blend, angle)
	self.layer = LAYER_ENEMY - 12
	self.img = "saoqi1"
	self.hscale, self.vscale = 0, 0
	self.rot = angle
	robject.set_color(self, blend, 0, r, g, b)
	--长宽比变化
	EGGlib.ObjectEvent.sizeChangeTask(self, 2.5*size, 30)
	--透明度变化
	task.New(self, function()
		local d_a = 0.7*255/15
		for _ = 1, 15 do
			if IsValid(mst) then
				self.x, self.y = mst.x, mst.y
			else
				break
			end
			self._a = self._a + d_a
			task.Wait(1)
		end
		d_a = -0.7*255/45
		for _ = 1, 45 do
			if IsValid(mst) then
				self.x, self.y = mst.x, mst.y
			else
				break
			end
			self._a = self._a + d_a
			task.Wait(1)
		end
		Del(self)
	end)
end
function saoqi3:frame()
	task.Do(self)
end
function saoqi3:render()
	SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
	Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end
