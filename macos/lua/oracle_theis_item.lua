-- 原作 itemclass.lua 的飞出控制器原文，作为独立对照。
-- SHA256 3276925a024506d134c5570b7486fc25ed024097f3be32f571e95c18480547b2
local sin,cos,max,min=sin,cos,math.max,math.min
local function xpow2(v) return -(v*(v-2)) end
local item_fly_controller = {}
function item_fly_controller.init(self, x, y, angle, yspeed, fadein, flylen)
	self.timer = 0

	-- 飞出位置
	self.x = x
	self.y = y
	-- 原始飞出位置
	self.x0 = x
	self.y0 = y

	-- 尺寸
	self.size = 1 -- 相对大小
	self.hscale = 0
	self.vscale = 0

	self.angle = angle or 90 -- 飞出时的朝向
	self.yspeed = yspeed or -0.8 -- 下落速度

	self.fadein = fadein or 40 -- 飞出过程的时间
	self.flylen = flylen or 24 -- 飞出的距离
	self.cosv = cos(self.angle)
	self.sinv = sin(self.angle)

	self.target = nil
	self.lockt = 0
	self.attract = 0
end
function item_fly_controller.update(self)
	if self.timer <= self.fadein then
		local k = self.timer / self.fadein
		local t = xpow2(k)
		self.hscale = t * self.size
		self.vscale = t * self.size
		self.x = self.x0 + self.flylen * t * self.cosv
		self.y = self.y0 + self.flylen * t * self.sinv
	elseif self.timer > (self.fadein + 4) then
		local vx, vy = 0, 0
		local rate0 = 0
		if self.attract > 0.0001 and IsValid(self.target) then
			local a = Angle(self, self.target)
			vx = self.attract * cos(a)
			vy = self.attract * sin(a)
			self.lockt = min(self.lockt + 0.005, 1)
		else
			vx = 0
			vy = self.yspeed
			self.lockt = 0
			rate0 = 0.05
			if self.y < lstg.world.boundb then
				self.status = "del"
			end
		end
		local rate = rate0 + self.lockt
		self.vx = self.vx + (vx - self.vx) * rate
		self.vy = self.vy + (vy - self.vy) * rate
	end
end


return item_fly_controller
