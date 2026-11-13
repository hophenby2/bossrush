---======================================
---祈华梦一面背景
---by S7P v1.0
---======================================
local background_open = setting.background --背景开关选项
local ran = lstg.Rand()

local rnd = math.random
local path = "res/background/stage1/"

----------------------------------------
---背景定义
local bgch --道中背景变化
local BG = Class(object)
function BG:init(IsBoss)
	--resource
	LoadTexture("bamboo_ground", path .. "s1_ground.png")
	LoadImage("bamboo_ground", "bamboo_ground", 0, 0, 256, 256, 0, 0)
	LoadTexture("bamboo", path .. "s1_bamboo.png")
	LoadImage("trunk", "bamboo", 464, 0, 58, 1024, 0, 0)
	SetImageCenter("trunk", 29, 1024)
	LoadImage("trunk_light", "bamboo", 378, 0, 58, 1024, 0, 0)
	SetImageCenter("trunk_light", 29, 1024)
	SetImageState("trunk_light", "mul+add", Color(0xFFFFFFFF))
	LoadImage("leave1", "bamboo", 0, 512, 256, 256, 0, 0)
	LoadImage("leave2", "bamboo", 0, 768, 320, 256, 0, 0)
	--parent class
	background.init(self, false)
	--set 3d camera and fog
	Set3D("eye", 0, 3.5, -5)
	Set3D("at", 0, 1.5, 0)
	Set3D("up", 0, 1, 0)
	Set3D("z", 1, 24)
	Set3D("fovy", 0.7)
	Set3D("fog", 7, 20, Color(0x0d1c11))
	--
	self.list = {}
	self.liststart = 1
	self.listend = 0
	self.imgs = {"trunk", "trunk_light", "leave1", "leave2", "shoots"}
	self.speed = 0.01
	self.interval = 0.5
	self.acc = self.interval
	self.z = 0
	for _ = 1, 400 do
		BG.frame(self)
	end
	if not IsBoss then  --如果不是boss战，则启用道中背景变化
		bgch(self)
	end
end
function BG:frame()
	background_open = setting.background
	if background_open then
		task.Do(self)
		if self.timer < 2 then
			self.speed_save = 0.07
		else
			self.speed_save = self.speed
		end

		if self.timer >= 4600 and self.timer <= 4800 then
			self.speed_mode = nil
			self.speed = max(self.speed - 0.0001, 0.005)
		elseif self.timer >= 4800 then
			self.speed_mode = "fast_path"
		end

		self.z = self.z + self.speed_save
		self.acc = self.acc + self.speed_save
		if self.acc >= self.interval then
			self.acc = self.acc - self.interval
			local bamboo_left_rnd = {rnd(), rnd(), rnd(), rnd()}
			self.listend = self.listend + 1
			self.list[self.listend] = {
				rnd(3, 4),
				0.9 + bamboo_left_rnd[1] * 3,
				0,
				bamboo_left_rnd[2] * 0.4 - 0.2,
				-0.7 - 0.3 * bamboo_left_rnd[3],
				24 + 0.1 * bamboo_left_rnd[4]
			}
			self.listend = self.listend + 1
			self.list[self.listend] = {
				1,
				0.9 + bamboo_left_rnd[1] * 3,
				0,
				bamboo_left_rnd[2] * 0.4 - 0.2,
				0.7 + 0.3 * bamboo_left_rnd[3],
				24 + 0.1 * bamboo_left_rnd[4]
			}
			self.listend = self.listend + 1
			self.list[self.listend] = {
				2,
				0.9 + bamboo_left_rnd[1] * 3,
				0,
				bamboo_left_rnd[2] * 0.4 - 0.2,
				0.7 + 0.3 * bamboo_left_rnd[3],
				24 + 0.1 * bamboo_left_rnd[4]
			}
			local bamboo_right_rnd = {rnd(), rnd(), rnd(), rnd()}
			self.listend = self.listend + 1
			self.list[self.listend] = {
				rnd(3, 4),
				-0.9 - bamboo_right_rnd[1] * 3,
				0,
				bamboo_right_rnd[2] * 0.4 - 0.2,
				0.7 + 0.3 * bamboo_right_rnd[3],
				24 + 0.1 * bamboo_right_rnd[4]
			}
			self.listend = self.listend + 1
			self.list[self.listend] = {
				1,
				-0.9 - bamboo_right_rnd[1] * 3,
				0,
				bamboo_right_rnd[2] * 0.4 - 0.2,
				0.7 + 0.3 * bamboo_right_rnd[3],
				24 + 0.1 * bamboo_right_rnd[4]
			}
			self.listend = self.listend + 1
			self.list[self.listend] = {
				2,
				-0.9 - bamboo_right_rnd[1] * 3,
				0,
				bamboo_right_rnd[2] * 0.4 - 0.2,
				0.7 + 0.3 * bamboo_right_rnd[3],
				24 + 0.1 * bamboo_right_rnd[4]
			}
			self.acc = self.acc - self.interval
			local dy = 0
			for _ = 1, 3 do
				self.listend = self.listend + 1
				self.list[self.listend] = {
					rnd(3, 4),
					1.5 + rnd() * 2,
					1.6 + rnd() + dy,
					rnd() * 0.6 - 0.3,
					-0.7 - 0.3 * rnd(),
					24 + 0.1 * rnd()
				}
				self.listend = self.listend + 1
				self.list[self.listend] = {
					rnd(3, 4),
					-1.5 - rnd() * 2,
					1.6 + rnd() + dy,
					rnd() * 0.6 - 0.3,
					0.7 + 0.3 * rnd(),
					24 + 0.1 * rnd()
				}
				dy = dy + 1.5
			end
		end
		for i = self.liststart, self.listend do
			self.list[i][6] = self.list[i][6] - self.speed_save
		end
		while true do
			if self.list[self.liststart][6] < -6 then
				self.list[self.liststart] = nil
				self.liststart = self.liststart + 1
			else
				break
			end
		end
		if self.speed_mode == "slow_path" then
			self.speed = max(self.speed - 0.0001, 0.02)
		elseif self.speed_mode == "fast_path" then
			self.speed = min(self.speed + 0.0001, 0.08)
		elseif self.speed_mode == "kaguya_path" then
			self.speed = max(self.speed - 0.0002, 0.045)
		elseif self.timer < 1600 and self.timer > 300 then
			self.speed = min(self.speed + 0.00005, 0.07)
		end
	end
end
function BG:render()
	if background_open then
		background.WarpEffectCapture()
		SetViewMode "3d"
		RenderClear(lstg.view3d.fog[3])

		for j = 0, 6 do
			local dz = j * 4 - math.mod(self.z, 4)
			for i = -2, 1 do
				Render4V("bamboo_ground", i * 4,     0, dz,
						4 + i * 4, 0,dz,
						4 + i * 4, 0,-4 + dz,
						i * 4,     0, -4 + dz)
			end
		end

		for i = self.listend, self.liststart, -1 do
			local p = self.list[i]
			Render(self.imgs[p[1]], p[2], p[3], p[4] * 57, p[5], abs(p[5]), p[6])
			--Render(self.imgs[1],0,0,0,1,1,0)
		end
		SetViewMode "world"
		background.WarpEffectApply()
	end
end
function bgch(self)
	Set3D('eye',0,3.5,-5)
	Set3D('at',0,1.5,0)
	Set3D('up',0,1,0)
	Set3D('z',1,24)
	Set3D('fovy',0.7)
	Set3D('fog',-40,0,Color(255,4,9,5))
	task.New(self,function()
		task.Wait(300)
		local x,_d_x=(0),(90/899)
		for _=1,900 do
			Set3D('fog',-40,0 + (20 - 0)*sin(x),Color(255,4 + (13-4)*sin(x),9 + (28-9)*sin(x),5 + (17-5)*sin(x)))
			task.Wait(1)
			x=x+_d_x
		end
		x,_d_x=(0),(90/599)
		for _=1,600 do
			Set3D('fog',-40 + (7 + 40)*sin(x),20,Color(255,13,28,17))
			task.Wait(1)
			x=x+_d_x
		end
		task.Wait(1100)
		self.speed_mode = 'slow_path'
		task.Wait(200)
		x,_d_x=(0),(90/359)
		for _=1,360 do
			Set3D('eye',0,3.5 + (1.75 - 3.5)*sin(x),-5)
			Set3D('at',0,1.5 + (0.5 - 1.5)*sin(x),0)
			task.Wait(1)
			x=x+_d_x
		end
	end)
	task.New(self,function()
		task.Wait(4800)
		do local x,_d_x=(0),(90/239) for _=1,240 do
			Set3D('eye',0,1.75 + (2.5-1.75)*sin(x),-5)
			Set3D('at',0,0.5 + (1.5 - 0.5)*sin(x),0)
			task.Wait(1)
			x=x+_d_x end
		end
	end)
	task.New(self,function()
		task.Wait(6400)
		local x,_d_x=(0),(1/1199)
		for _=1,1200 do
			Set3D('fog',7,20,Color(255,13 + (48-13)*x,28 + (105-28)*x,17 + (63 - 17)*x))
			task._Wait(1)
			x=x+_d_x
		end
		task.Wait(120)
		x,_d_x=(0),(90/419)
		for _=1,420 do
			Set3D('eye',0,2.5 + (3.5-2.5)*sin(x),-5)
			Set3D('at',0,1.5 + (2.5 - 1.5)*sin(x),0)
			task._Wait(1)
			x=x+_d_x
		end
		--下面的变亮暂时不启用
		--[[local x,_d_x=(0),(90/299) for _=1,300 do
			Set3D('fog',7 + (0-7)*sin(x),20 + (13.8-20)*sin(x),Color(255,48 + (113 - 48)*sin(x),105 + (255-105)*sin(x),63 + (151-63)*sin(x)))
			task._Wait(1)
			x=x+_d_x
		end]]
	end)
end
----------------------------------------
---导出定义

stage1_background = BG
