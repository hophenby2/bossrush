---======================================
---祈华梦二面背景
---by ???
---======================================
local background_open = setting.background --背景开关选项
local ran = lstg.Rand()

local path = "res/background/stage3/"

----------------------------------------
---背景定义

local bgch, s4bgch

local BG = Class(object)

function BG:init(IsBoss, IsStage4)
	--res
	self.layer = LAYER_BG - 0.01
	LoadImageFromFile("XY_BG_Road_vh", path .. "s3_BG_vh.png")
	LoadImageFromFile("XY_BG_Road_01", path .. "s3_BG_01.png")
	LoadImageFromFile("XY_BG_Road_03", path .. "s3_BG_03.png")
	LoadImageFromFile("XY_BG_Road_02", path .. "s3_BG_02.png")
	LoadImageFromFile("XY_BG_Road_04", path .. "s3_BG_04.png")
	LoadImageFromFile("XY_BG_Road_Snow", path .. "s3_BG_Snow.png")
	SetImageState("XY_BG_Road_03", "mul+add", Color(0xFFFFFFFF))
	SetImageState("XY_BG_Road_02", "mul+add", Color(0xFFFFFFFF))
	SetImageState("XY_BG_Road_04", "mul+add", Color(0xFFFFFFFF))
	SetImageState("XY_BG_Road_Snow", "mul+add", Color(0xFFFFFFFF))
	--set camera
	Set3D('eye',0.00,12.5,-2.00)
	Set3D('at',0.00,10,3)
	Set3D('up',0.00,0.00,0.50)
	Set3D('fovy',1.5)
	Set3D('z',0.1,50.00)
	Set3D('fog',15,35,Color(255,20,30,60))
	--
	self.zos=0
	self.speed=0.09
	self._x=0
	self.sp=0.09
	self.xyc = 0
	self.moon_alpha = 0 --月亮的透明度

	if IsStage4 then
		--set camera
		Set3D('eye',0.00,12.5,-2.00)
		Set3D('at',0.00,10,3)
		Set3D('up',0.00,0.00,0.50)
		Set3D('fovy',1.5)
		Set3D('z',0.1,50.00)
		Set3D('fog',15,35,Color(255,20,30,60))
		--
		self.zos=0
		self.speed=0.09
		self._x=0
		self.sp=0.09
		self.xyc = 0
		self.moon_alpha = 0 --月亮的透明度
	elseif not IsBoss then  --如果不是boss战，则启用道中背景变化
		bgch(self)
	end
end

function BG:frame()
	background_open = setting.background
	if background_open then
		task.Do(self)
		Set3D('up', 0.005*sin(self.timer/2), 0, 0.5)
		self.zos=self.zos+self.speed
		self._x=self._x+self.sp

		if self.timer>0 then
			--	Set3D('eye',0+0.1*sin(self.timer/4),12.5,-2.00)
			--	Set3D('up',0+0.01*sin(self.timer/3),0,0.5)
			self.xyc=3*sin(self.timer/8)
		end

		SetViewMode'3d'

		if IsValid(_boss) and _boss.cards[_boss.card_num] and _boss.cards[_boss.card_num].is_sc then
		else
			if self.timer%15==0 and self.timer>5 and not(lstg.tmpvar.show_moon) then
				for i=1,ran:Int(2,7) do
					local size=ran:Float(0.2,2)
					local x=ran:Float(-230,350)
					local y=ran:Float(250,350)
					New(BG.snowxy03,x,y,size)
				end
			end
		end

		SetViewMode'world'
	end
end

function BG:render()
	if background_open then
		background.WarpEffectCapture()
		RenderClear(lstg.view3d.fog[3])
		local moon = 'XY_BG_Road_02'
		SetImageState(moon, "", Color(255*self.moon_alpha, 255, 255, 255))
		Render(moon,-70,150,0,0.7,0.7)

		SetViewMode'3d'

		local z=self.zos%10
		local x=self._x%10
		for i=-1,5 do
			for o=-3,3 do
				Render4V('XY_BG_Road_vh',-10+o*20,-1,-5-z+i*10,  10+o*20,-1,-5-z+i*10,  10+o*20,-1,5-z+i*10,  -10+o*20,-1,5-z+i*10)
			end
		end

		local x=self.zos%100
		local z=self._x%100
		local moutain = 'XY_BG_Road_01'
		local dx = 10
		local dy = 10
		local dz = 8
		SetImageState(moutain, "", Color(150, 255, 255, 255))
		Render4V(moutain, 35 + dx,20 + dy,15 + dz,
				-35 + dx,20 + dy,15 + dz,
				-35 + dx,-30 + dy,15 + dz,
				35 + dx,-30 + dy,15 + dz)
		local dx = 5
		local dy = 5
		local dz = 4
		SetImageState(moutain, "", Color(180, 255, 255, 255))
		Render4V(moutain, -28 + dx,20 + dy,15 + dz,
				28 + dx,20 + dy,15 + dz,
				28 + dx,-25 + dy,15 + dz,
				-28 + dx,-25 + dy,15 + dz)
		local dx = 2
		local dy = 0
		local dz = 0
		SetImageState(moutain, "", Color(255, 255, 255, 255))
		Render4V(moutain, -28 + dx,20 + dy,15 + dz,
				28 + dx,20 + dy,15 + dz,
				28 + dx,-25 + dy,15 + dz,
				-28 + dx,-25 + dy,15 + dz)


		local x=self.zos%40
		local z=(self._x)/3%40
		for i=0,0 do
			for o=-1,1 do
				Render4V('XY_BG_Road_03',-20-z+o*40,25,15,  20-z+o*40,25,15,  20-z+o*40,5,15,  -20-z+o*40,5,15)
			end
		end

		local x=self.zos%20
		local z=self._x%20
		for i=5,-1,-1 do
			for o=0,0 do
				Render4V('XY_BG_Road_04',-35+self.xyc,0,-10-z+i*20,    5+self.xyc,0,-10-z+i*20,
						5+self.xyc,5, 10-z+i*20,  -35+self.xyc,5, 10-z+i*20)

				Render4V('XY_BG_Road_04', -5-self.xyc,0,-20-z+i*20,   35-self.xyc,0,-20-z+i*20,
						35-self.xyc,5, 00-z+i*20,   -5-self.xyc,5, 00-z+i*20)
			end
		end
		SetViewMode'world'
		background.WarpEffectApply()
	end
end


local snowxy03 = Class(object)
BG.snowxy03=snowxy03

function snowxy03:init(x, y, size)
	self.life = ran:Int(40, 130)
	self.x = x
	self.y = y
	self.img = "XY_BG_Road_Snow"
	self.size = size
	self.hscale = size
	self.vscale = size
	self.group = GROUP_GHOST
	self.omiga = ran:Float(-4, -2)
	self.layer = LAYER_BG + size
	self.color = color
	self._vx = ran:Float(1, 1.7)
	self.bound = false
	--self.vx=ran:Sign()*ran:Float(0.5,1)
	self.vx = ran:Float(-2, -1.65)
	self.vy = ran:Float(-0.8, -4)
	self.xya = 0
end

function snowxy03:frame()
	task.Do(self)
	self.hscale = (self.size / 3) * sin(self.timer * 2)
	self.vscale = (self.size / 3) * cos(self.timer * 2)

	if self.y < -240 or self.x < -210 then
		Del(self)
	end
end

function snowxy03:render()
	if IsValid(_boss) and _boss.ex and _boss.ex.status == 1 then
	else
		SetViewMode "world"
		if self.timer < self.life then
			SetImageState(
				"XY_BG_Road_Snow",
				"mul+add",
				Color(100 + 100 * self.size, 255, 100 + 100 * self.size, 100 + 100 * self.size)
			)
		else
			SetImageState(
				"XY_BG_Road_Snow",
				"mul+add",
				Color(
					max(0, (100 + 100 * self.size) - (100 + 100 * self.size) / 50 * (self.timer - self.life)),
					255,
					max(0, (100 + 100 * self.size) - (100 + 100 * self.size) / 50 * (self.timer - self.life)),
					max(0, (100 + 100 * self.size) - (100 + 100 * self.size) / 50 * (self.timer - self.life))
				)
			)
		end
		object.render(self)
	end
end

function bgch(self)
	self._lock = false
	self._eye = {0,0,0} --设置默认参数
	self._at = {0,0,0}
	self._up = {0,0,0}
	self._z = {0,0}
	self._fovy = {0}
	self._fog = {0,0,0,0,0,0}
	self._eye0 = {0.00,14.7,-10.8} --设置默认参数
	self._at0 = {0.00,12.9,-9.9}
	self._up0 = {0.00,0.00,0.50}
	self._z0 = {0.1,50.00}
	self._fovy0 = {1.5}
	self._fog0 = {-19.5,15.3,255,20,30,60}
	self.pos = {1,1}
	self.bg_table = {self._eye, self._at,  self._up, self._z, self._fovy, self._fog}
	self.bg_table0 = {self._eye0, self._at0,  self._up0, self._z0, self._fovy0, self._fog0}
	self._bg_table = {"eye", "at",  "up", "z", "fovy", "fog"}
	task.New(self,function()
		do for _=1,1 do
			local b = self.bg_table
			local up = player.x*0.006/384
			Set3D('eye',self._eye0[1] + 0.1*b[1][1], self._eye0[2] + 0.1*b[1][2] , self._eye0[3] + 0.1*b[1][3])
			Set3D('at',self._at0[1] + 0.1*b[2][1], self._at0[2] + 0.1*b[2][2], self._at0[3] + 0.1*b[2][3])
			Set3D('up', self._up0[1] + 0.1*b[3][1] + up, self._up0[2] + 0.1*b[3][2], self._up0[3] + 0.1*b[3][3])
			Set3D('z',self._z0[1] + 0.1*b[4][1], self._z0[2] + 0.1*b[4][2])
			Set3D('fovy',self._fovy0[1] + 0.1*b[5][1])
			Set3D('fog',self._fog0[1] + 0.1*b[6][1], self._fog0[2] + 0.1*b[6][2], Color(self._fog0[3] + b[6][3],self._fog0[4] + b[6][4],self._fog0[5] + b[6][5],self._fog0[6] + b[6][6]))
			task._Wait(1)
		end end
	end)
	--[[ 雾逐渐远去 --]]--[=[
    --]=]
	task.New(self,function()
		task._Wait(400)
		local f0 = {self._fog0[1], self._fog0[2], self._fog0[3], self._fog0[4], self._fog0[5], self._fog0[6]}
		self._fog0[2] = 45
		do local x,_d_x=(0),(1/819) for _=1,820 do
			Set3D('fog',f0[1] + (self._fog0[1] - f0[1])*x,
					f0[2] + (self._fog0[2] - f0[2])*x,
					Color(f0[3] + (self._fog0[3] - f0[3])*x,
							f0[4] + (self._fog0[4] - f0[4])*x,
							f0[5] + (self._fog0[5] - f0[5])*x,
							f0[6] + (self._fog0[6] - f0[6])*x))
			task._Wait(1)
			x=x+_d_x end end
	end)
	--[[ 背景逐渐变亮 --]]--[=[
    --]=]
	task.New(self,function()
		task._Wait(1500)
		local f0 = {self._fog0[1], self._fog0[2], self._fog0[3], self._fog0[4], self._fog0[5], self._fog0[6]}
		self._fog0[1] = 15
		do local x,_d_x=(0),(1/1199) for _=1,1200 do
			Set3D('fog',f0[1] + (self._fog0[1] - f0[1])*x,
					f0[2] + (self._fog0[2] - f0[2])*x,
					Color(f0[3] + (self._fog0[3] - f0[3])*x,
							f0[4] + (self._fog0[4] - f0[4])*x,
							f0[5] + (self._fog0[5] - f0[5])*x,
							f0[6] + (self._fog0[6] - f0[6])*x))
			task._Wait(1)
			x=x+_d_x end end
	end)
	--[[ 视角抬高，可以看到远处的山 --]]--[=[
    --]=]
	task.New(self,function()
		task._Wait(3000)
		local e0 = {self._eye0[1], self._eye0[2], self._eye0[3]}
		self._eye0[3] = -2.4
		local a0 = {self._at0[1], self._at0[2], self._at0[3]}
		self._at0[3] = 4.8
		do local x,_d_x=(0),(1/899) for _=1,900 do
			Set3D('eye', e0[1] + (self._eye0[1] - e0[1])*x,
					e0[2] + (self._eye0[2] - e0[2])*x,
					e0[3] + (self._eye0[3] - e0[3])*x)
			Set3D('at', a0[1] + (self._at0[1] - a0[1])*x,
					a0[2] + (self._at0[2] - a0[2])*x,
					a0[3] + (self._at0[3] - a0[3])*x)
			task._Wait(1)
			x=x+_d_x end end
	end)
	--[[ 视野拉近，此后摄像头往左走，视野拉远，月亮出现 --]]--[=[
    --]=]
	task.New(self,function()
		task._Wait(6500)
		local e0 = {self._eye0[1], self._eye0[2], self._eye0[3]}
		self._eye0[2] = 8.9
		self._eye0[3] = -2.1
		local a0 = {self._at0[1], self._at0[2], self._at0[3]}
		self._at0[2] = 5
		self._at0[3] = 9.8
		do local x,_d_x=(0),(1/1199) for _=1,1200 do
			Set3D('eye', e0[1] + (self._eye0[1] - e0[1])*x,
					e0[2] + (self._eye0[2] - e0[2])*x,
					e0[3] + (self._eye0[3] - e0[3])*x)
			Set3D('at', a0[1] + (self._at0[1] - a0[1])*x,
					a0[2] + (self._at0[2] - a0[2])*x,
					a0[3] + (self._at0[3] - a0[3])*x)
			task._Wait(1)
			x=x+_d_x end end
		task._Wait(300)
		local e0 = {self._eye0[1], self._eye0[2], self._eye0[3]}
		self._eye0[1] = -4
		self._eye0[2] = 9.4
		local a0 = {self._at0[1], self._at0[2], self._at0[3]}
		self._at0[1] = -4
		self._at0[2] = 8
		do local x,_d_x=(0),(1/499) for _=1,500 do
			Set3D('eye', e0[1] + (self._eye0[1] - e0[1])*x,
					e0[2] + (self._eye0[2] - e0[2])*x,
					e0[3] + (self._eye0[3] - e0[3])*x)
			Set3D('at', a0[1] + (self._at0[1] - a0[1])*x,
					a0[2] + (self._at0[2] - a0[2])*x,
					a0[3] + (self._at0[3] - a0[3])*x)
			task._Wait(1)
			x=x+_d_x end end
		task._Wait(420)
		do local x,_d_x=(0),(1/899) for _=1,900 do
			self.moon_alpha = x
			task._Wait(1)
			x=x+_d_x end end
	end)
end


----------------------------------------
---导出定义

stage3_background = BG
