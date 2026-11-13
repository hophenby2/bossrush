---======================================
---祈华梦二面背景
---by OLC v2.0
---======================================

local rnd = math.random
local ran = lstg.Rand()

local path = "res/background/stage2/"
local background_open = setting.background --背景开关选项
----------------------------------------
--背景道具定义
local Stage2_leaf=Class(object)
function Stage2_leaf:init()
	self.x= ran:Float(-224, -200)
	self.y= ran:Float(-100, 600)
	self.img ='Forest_leaf'
	self.size = ran:Float(0.6,0.9)
	self.hscale = self.size
	self.vscale = self.size
	self.group = GROUP_GHOST
	self.omiga = ran:Float(-3,-2)
	self.layer = LAYER_BG + self.size
	self.color = Color(100, 0, ran:Float(100, 170), ran:Float(45, 76))
	self._vx = ran:Float(1,1.7)
	self.bound = false
	self.vx = ran:Float(1,1.75)
	self.vy = -self.size*2.5
end

function Stage2_leaf:frame()
	task.Do(self)
	self.hscale=self.hscale-self.size/100
	self.vscale=self.vscale+self.size/100
	if self.y<-240 then Del(self) end
end

function Stage2_leaf:render()
	if IsValid(_boss) and _boss.cards[_boss.card_num] and _boss.cards[_boss.card_num].is_sc then
	else
		SetImageState(self.img,"",self.color)
		SetViewMode"world"
		object.render(self)
		SetImageState(self.img,"",Color(255,255,255,255))
	end
end

---背景定义
local bgch --道中背景变化
local BG = Class(object)
function BG:init(IsBoss)
	--res
    LoadImageFromFile('tree4',path..'s2_tree4.png')
    LoadImageFromFile('tree5',path..'s2_tree5.png')
    LoadImageFromFile('tree6',path..'s2_tree6.png')
    LoadImageFromFile('grass',path..'s2_grass.png')
    LoadImageFromFile('moon',path..'s2_moon.png')
    LoadImageFromFile('Forest_leaf',path..'s2_Forest_leaf.png')
    LoadImageFromFile('forest1',path..'s2_forest1.png')
	LoadImageFromFile('s2_firefly',path..'s2_firefly.png')
    LoadImage('img_grass1','forest1',0,0,512,256,0,0)
    LoadImage('img_grass2','forest1',0,256,512,256,0,0)


	background.init(self,false)

	Set3D('eye',1.5,0.4,-4.5)
	Set3D('at',1.5,-0.4,0)
	Set3D('up',0,1,0)
	Set3D('z',1,24)
	Set3D('fovy',0.7)
	Set3D('fog',8.3,20,Color(255,0,0,0))

--	New(_editor_class["FX_Start"],0,0,_)
	self.list={0,0,0,0,0,0,0,0}
	self.liststart=1
	self.listend=0
	self.imgs={'tree4','tree5','tree6','img_grass1','img_grass2'}
	self.speed=0.07
	self.interval=0.5
	self.acc=self.interval
	self.eye_y={0.4,-0.4,7}
	self.moon_alpha=0
	self.t=0
	lstg.tmpvar.show_moon=false

	self.road_x = 0 --指道路中间的x坐标
	self.road_w = 2 --指道路宽度的一半
	for i=1,400 do BG.frame(self) end
	self.moon_alpha=0

	if not IsBoss then  --如果不是boss战，则启用道中背景变化
		bgch(self)
	end
end
function BG:frame()
	background_open = setting.background
	if background_open then
		task.Do(self)
		--Set3D('eye',1.5+0.2*sin(self.timer),self.eye_y[1],-4.5)
		--Set3D('at',1.5,self.eye_y[2],0)
		self.acc=self.acc+self.speed
		if self.acc>=self.interval then
			self.acc=self.acc-self.interval
			self.listend=self.listend+1
			self.list[self.listend]={rnd(1,3), 0.9+rnd()*3,0,rnd()*0.2-0.2,0.7+0.3*rnd(),24+0.1*rnd(),ran:Float(-0.5,1.5) + self.road_w + self.road_x,-2+6,3}
			self.listend=self.listend+1
			self.list[self.listend]={rnd(1,3),-0.9-rnd()*3,0,rnd()*0.2-0.2,0.7+0.3*rnd(),24+0.1*rnd(),ran:Float(-1.5,0.5) - self.road_w + self.road_x,-2+6,3}
			self.acc=self.acc-self.interval
			self.listend=self.listend+1
			self.list[self.listend]={rnd(4,5), 1.5+rnd()*2,-1.8+rnd(),rnd()*0.6-0.3,-0.7-0.3*rnd(),24+0.1*rnd(),ran:Float(-0.5,1.5)+ 0.5 + self.road_w  + self.road_x,-2+1,2}
			self.listend=self.listend+1
			self.list[self.listend]={rnd(4,5),-1.5-rnd()*2,-1.8+rnd(),rnd()*0.6-0.3, 0.7+0.3*rnd(),24+0.1*rnd(),ran:Float(-1.5,0.5)+ 0.5 - self.road_w  + self.road_x,-2+1,2}
		end
		for i=self.liststart,self.listend do
			self.list[i][6]=self.list[i][6]-self.speed
		end
		while true do
			if self.list[self.liststart][6]<-6 then
				self.list[self.liststart]=nil
				self.liststart=self.liststart+1
			else break
			end
		end
		--[[
        if IsValid(_boss) and _boss.cards[_boss.card_num] and _boss.cards[_boss.card_num].is_sc then
        else
            if self.timer%15==0 and self.timer>5 and not(lstg.tmpvar.show_moon) then
                for i=1,ran:Int(2,7) do
                    local size=ran:Float(0.5,1.5)
                    local x=ran:Float(-240,240)
                    local y=ran:Float(230,250)
                    local color=Color(125+55*(size-1),ran:Int(155,195),ran:Int(130,165),0)
                    New(Stage2_leaf,x,y,size,color)
                end
            end
        end
        --]]
		if lstg.tmpvar.s2_show_moon then
			self.t=min(self.t+0.5,90)
		else
			self.t=max(self.t-0.5,0)
		end
		self.moon_alpha=255*sin(self.t)*sin(self.t)
		self.eye_y[1]=0.4+(6.6-0.4)*sin(self.t)*sin(self.t)
		self.eye_y[2]=-0.4+(6.1+0.4)*sin(self.t)*sin(self.t)

		if self.timer%15 == 1 and self.timer <= 3120 then
			if firefly then
				New(firefly)
			end
		end
		if self.timer%12 == 0 and self.timer >= 3380 then
			New(Stage2_leaf)
		end
	end
end
function BG:render()
	if background_open then
		--background.WarpEffectCapture()--不加扭曲特效，会遮住月亮
		SetViewMode "3d"
		RenderClear(lstg.view3d.fog[3])

		SetImageState("moon", "", Color(self.moon_alpha, 255, 255, 255))
		Render("moon", 0, self.eye_y[3], 0, 0.5, 0.5, 14)
		SetImageState("moon", "", Color(255, 255, 255, 255))
		for j = 0, 6 do
			local dz = j * 4 - math.mod(self.timer * self.speed, 4)
			for i = -3, 1 do
				Render4V("grass", i * 4, -2, dz, 4 + i * 4, -2, dz, 4 + i * 4, -2, -4 + dz, i * 4, -2, -4 + dz)
			end
		end
		local dz = 0 * 4 - math.mod(self.timer * self.speed, 4)
		for i = self.listend, self.liststart, -1 do
			local p = self.list[i]
			local img=self.imgs[p[1]]
			--透明度变化，减少树叶打脸效果
			if p[6]>-1.5 then
				SetImageState(img,"",Color(255,255,255,255))
			elseif p[6]>-2.5 and p[6]<=-1.5 then
				local rate=p[6]-(-2.5)
				SetImageState(img,"",Color(255*rate,255,255,255))
			else
				SetImageState(img,"",Color(0,255,255,255))
			end
			Render4V(img,
					p[7]       , p[8], p[6],
					p[7] + p[9], p[8], p[6],
					p[7] + p[9],   -2, p[6],
					p[7]       ,   -2, p[6]
			)
		end
		SetViewMode "world"
		--background.WarpEffectApply()
	end
end
function bgch(self)
	self.light = false
	self._eye = {0,0,0} --设置默认参数
	self._at = {0,0,0}
	self._up = {0,0,0}
	self._z = {0,0}
	self._fovy = {0}
	self._fog = {0,0,0,0,0,0}
	self._eye0 = {1.5, -1,-4.5} --设置默认参数
	self._at0 = {1.5,-1,0}
	self._up0 = {0,1,0}
	self._z0 = {1,24}
	self._fovy0 = {0.7}
	self._fog0 = {-33.6, 5.3,255,0,10,0}
	--4, 20

	self.pos = {1,1}
	self.bg_table = {self._eye, self._at,  self._up, self._z, self._fovy, self._fog}
	self.bg_table0 = {self._eye0, self._at0,  self._up0, self._z0, self._fovy0, self._fog0}
	self._bg_table = {"eye", "at",  "up", "z", "fovy", "fog"}
	task.New(self,function()
		local b, up
		do for _=1,1 do
			b = self.bg_table
			up = player.x*0.006/384
			Set3D('eye',self._eye0[1] + 0.1*b[1][1], self._eye0[2] + 0.1*b[1][2] , self._eye0[3] + 0.1*b[1][3])
			Set3D('at',self._at0[1] + 0.1*b[2][1], self._at0[2] + 0.1*b[2][2], self._at0[3] + 0.1*b[2][3])
			Set3D('up', self._up0[1] + 0.1*b[3][1] + up, self._up0[2] + 0.1*b[3][2], self._up0[3] + 0.1*b[3][3])
			Set3D('z',self._z0[1] + 0.1*b[4][1], self._z0[2] + 0.1*b[4][2])
			Set3D('fovy',self._fovy0[1] + 0.1*b[5][1])
			Set3D('fog',self._fog0[1] + 0.1*b[6][1], self._fog0[2] + 0.1*b[6][2], Color(self._fog0[3] + b[6][3],self._fog0[4] + b[6][4],self._fog0[5] + b[6][5],self._fog0[6] + b[6][6]))
			task.Wait(1)
		end end
		do for _=1,_infinite do
			b = self.bg_table
			up = player.x*0.006/384
			Set3D('eye',self._eye0[1] + 0.1*b[1][1], self._eye0[2] + 0.1*b[1][2] , self._eye0[3] + 0.1*b[1][3])
			Set3D('at',self._at0[1] + 0.1*b[2][1], self._at0[2] + 0.1*b[2][2], self._at0[3] + 0.1*b[2][3])
			Set3D('up', self._up0[1] + 0.1*b[3][1] + up, self._up0[2] + 0.1*b[3][2], self._up0[3] + 0.1*b[3][3])
			Set3D('z',self._z0[1] + 0.1*b[4][1], self._z0[2] + 0.1*b[4][2])
			Set3D('fovy',self._fovy0[1] + 0.1*b[5][1])
			Set3D('fog',self._fog0[1] + 0.1*b[6][1], self._fog0[2] + 0.1*b[6][2], Color(self._fog0[3] + b[6][3],self._fog0[4] + b[6][4],self._fog0[5] + b[6][5],self._fog0[6] + b[6][6]))
			task.Wait(1)
		end end
	end)
	task.New(self,function()
		local eye1, at1, eye2, at2
		local fog1 = self._fog0[1]
		local fog2 = self._fog0[2]
		local fog3 = self._fog0[3]
		do local x,_d_x=(0),(1/449) for _=1,450 do
			self._fog0[1] = fog1 + (-8.4 - fog1)*x
			self._fog0[2] = fog2 + (7.8 - fog2)*x
			task.Wait(1)
			x=x+_d_x end end
		task.Wait(1250)
		local fog1 = self._fog0[1]
		local fog2 = self._fog0[2]
		do
			task.New(self,function()
				do local x,_d_x=(0),(1/119) for _=1,120 do
					self.road_x = -1.6*x
					task.Wait(1)
					x=x+_d_x end end
				task.Wait(280)
				do local x,_d_x=(0),(1/239) for _=1,240 do
					self.road_x = -1.6 + 3.2*x
					task.Wait(1)
					x=x+_d_x end end
				task.Wait(30)
				do local x,_d_x=(0),(1/119) for _=1,120 do
					self.road_x = 1.6 - 1.6*x
					task.Wait(1)
					x=x+_d_x end end
			end)
		end
		do local x,_d_x=(0),(1/149) for _=1,150 do
			self.road_w = 2 - 0.5*x
			self._fog0[1] = fog1 + (-8 - fog1)*x
			self._fog0[2] = fog2 + (8 - fog2)*x
			self._fog0[3] = fog3 + (200 - fog3)*x
			task._Wait(1)
			x=x+_d_x end end
		task._Wait(250)
		--[[ 2100 视角左转 --]]--[=[
        --]=]
		eye1 = self._eye0[1]
		at1 = self._at0[1]
		do local x,_d_x=(0),(90/179) for _=1,180 do
			self._eye0[1] = eye1 + (0 - eye1)*sin(x)
			self._at0[1] = at1 + (0 - at1)*sin(x)
			task._Wait(1)
			x=x+_d_x end end
		task._Wait(220)
		--[[ 2500视角右转 --]]--[=[
        --]=]
		eye1 = self._eye0[1]
		at1 = self._at0[1]
		do local x,_d_x=(0),(90/249) for _=1,250 do
			self._eye0[1] = eye1 + (3 - eye1)*sin(x)
			self._at0[1] = at1 + (3 - at1)*sin(x)
			task._Wait(1)
			x=x+_d_x end end
		task._Wait(0)
		--[[ 2900视角中移 --]]--[=[
        --]=]
		eye1 = self._eye0[1]
		at1 = self._at0[1]
		do local x,_d_x=(0),(90/179) for _=1,180 do
			self._eye0[1] = eye1 + (1.5 - eye1)*sin(x)
			self._at0[1] = at1 + (1.5 - at1)*sin(x)
			task._Wait(1)
			x=x+_d_x end end
		task._Wait(270)
		--[[ 3200视角上移 --]]--[=[
        --]=]
		lstg.tmpvar.s2_show_moon = true
		eye2= self._eye0[2]
		at2 = self._at0[2]
		fog1 = self._fog0[1]
		fog2 = self._fog0[2]
		do local x,_d_x=(0),(90/179) for _=1,180 do
			self._eye0[2] = eye2 + (0.6 - eye2)*sin(x)
			self._at0[2] = at2 + (0.6 - at2)*sin(x)
			self._fog0[5] = 10*(1-sin(x))
			self._fog0[1] = fog1 + (-4 - fog1)*sin(x)
			self._fog0[2] = fog2 + (12 - fog2)*sin(x)
			self.road_w = 1.5 + 0.6*sin(x)
			task._Wait(1)
			x=x+_d_x end end
		--[[ 3380视角再慢慢上移 --]]--[=[
        --]=]
		eye2= self._eye0[2]
		at2 = self._at0[2]
		do local x,_d_x=(0),(1/1199) for _=1,1200 do
			self._eye0[2] = eye2 + (3.2 - eye2)*x
			self._at0[2] = at2 + (2 - at2)*x
			task._Wait(1)
			x=x+_d_x end end
		task._Wait(1220)
		eye2= self._eye0[2]
		at2 = self._at0[2]
		do local x,_d_x=(0),(1/2199) for _=1,2200 do
			self._eye0[2] = eye2 + (4 - eye2)*x
			self._at0[2] = at2 + (3.5 - at2)*x
			task._Wait(1)
			x=x+_d_x end end
		while not self.light do
			task._Wait(1)
		end
		fog1 = self._fog0[1]
		fog2 = self._fog0[2]
		do local x,_d_x=(0),(1/299) for _=1,300 do
			self._fog0[1] = fog1 + (12 - fog1)*x
			self._fog0[2] = fog2 + (20 - fog2)*x
			task._Wait(1)
			x=x+_d_x end end
	end)
end


----------------------------------------
---导出定义

stage2_background = BG
