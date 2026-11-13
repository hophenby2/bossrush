---======================================
---祈华梦五面背景
---by S7UPID
---======================================

local background_open = setting.background --背景开关选项（
local ran = lstg.Rand()

local path = "res/background/stage5/"

--res
--五面背景素材加载
-- 5面, 6面, 6boss共用素材
LoadImageFromFile("s5_light", path .. "s5_light.png")
local function load_res()
	-- 5, 6面共用素材
	LoadImageFromFile("s5_baseboard", path .. "s5_baseboard.png")
	LoadImageFromFile("s5_Island_cloud", path .. "s5_Island_cloud.png")
	LoadImageFromFile("s5_sun", path .. "s5_sun.png")
	LoadImageFromFile("s5_tree1", path .. "s5_tree1.png")
	LoadImageFromFile("s5_tree2", path .. "s5_tree2.png")
	LoadImageFromFile("s5_tree3", path .. "s5_tree3.png")
	LoadImageFromFile("s5_torii", path .. "s5_torii.png")
	LoadImageFromFile("s5_line", path .. "s5_line.png")
	LoadImageFromFile("s5_roads", path .. "s5_roads.png")
	LoadImageFromFile("s5_Island3", path .. "s5_Island3.png")
	-- 5面用
	LoadImageFromFile("s5_cloud_board", path .. "s5_cloud_board.png")
	LoadImageFromFile("s5_add(on_dec)", path .. "s5_add(on_dec).png")
	LoadImageFromFile("s5_air1", path .. "s5_air1.png")
	LoadImageFromFile("s5_air2", path .. "s5_air2.png")
	LoadImageFromFile("s5_cloud1", path .. "s5_cloud1.png")
	LoadImageFromFile("s5_cloud2", path .. "s5_cloud2.png")
	LoadImageFromFile("s5_cloud3", path .. "s5_cloud3.png")
	LoadImageFromFile("s5_dec", path .. "s5_dec.png")
	LoadImageFromFile("s5_moutain", path .. "s5_moutain.png")
	LoadImageFromFile("s5_Island1", path .. "s5_Island1.png")
	LoadImageFromFile("s5_Island2", path .. "s5_Island2.png")
	LoadImageFromFile("s5_tree4", path .. "s5_tree4.png")
end

----------------------------------------背景操作函数

-- 导入臭蛾子的数学库
local eggmath = require("EISlib.egg.eggmath")
local ToVector3 = eggmath.Vec3
local Multiplication_Cross3 = eggmath.Vec3Cross
local Dot_Product3 = eggmath.Vec3Dot
local _3ToQuaternion = eggmath.Vec3ToQuat
local Vector_Equal = eggmath.VecEqual
local Get_Opposite_Vector = eggmath.VecReverse
local ToQuaternion = eggmath.Quat
local Quaternion_Multiplication = eggmath.QuatMul
local Quaternion_Inversion = eggmath.QuatInv
local Point_by_Quaternion = eggmath.Vec3RotByQuat
local createBall = eggmath.Ball
local ballToVect3 = eggmath.BallToVec3
local Get_Four_Points = eggmath.GetRectFace

---背景小道具
local cloud2d, fog2d
---背景定义

local BG = Class(eggbg.baseBG)
--该背景私有的操作方法
local fogChange, p1, sence2test
do
	function BG:setDefault()
		--通用花瓣纹理
		eggbg.baseBG.addToImg(self, "sakura", "s4_sakura", 1.2, 1.2)
		eggbg.baseBG.addToImg(self, "sakura2", "s4_sakura", 2.4, 2.4)
		self.eye_pos = {0, 4, 6} --眼睛的初始位置
		self.eye_rot = {95, 90} --1球坐标系的θ，取值0到180  2球坐标系的φ，取值0到360（当然也可以更高）
		--这里是转化到at视角的方向单位向量
		self.eye_rot3 = {sin(self.eye_rot[1])*cos(self.eye_rot[2]), cos(self.eye_rot[1]), sin(self.eye_rot[1])*sin(self.eye_rot[2])} --眼睛朝向的单位法向量(这里是默认向下60度)(采用球坐标系, r = 1, 此处θ = 120,φ = -90)
		--背景的朝向（背景向前移动方向）
		self.bg_rot = {90, -90}
		--背景的朝向的单位方向向量
		self.bg_rot3 = {sin(self.bg_rot[1])*cos(self.bg_rot[2]), -cos(self.bg_rot[1]), sin(self.bg_rot[1])*sin(self.bg_rot[2])} --背景前进的方向的法向量(其反方向也是生成背景元素的方向)
		--背景前进的速度
		self.bg_speed = 0
		--对应于set3d的up
		self.up_rot = {90, 90}
		self.up = eggbg.ballToVect3(self.up_rot)
		--对应于set3d的fovy
		self.fovy = {1.5}
		--对应于set3d的z
		self.z = {0.001, 60}
		--对应于set3d的fog
		self.fog = {100, 100, 0, 255, 255, 175}
		Set3D('eye' , self.eye_pos[1], self.eye_pos[2], self.eye_pos[3])
		Set3D('at'  , self.eye_pos[1] + self.eye_rot3[1], self.eye_pos[2] + self.eye_rot3[2], self.eye_pos[3] + self.eye_rot3[3]) --暂且让眼睛的视角向下约30度吧
		Set3D('up'  , self.up[1],  self.up[2], self.up[3]) --三个参数都是控制整个背景旋转的，默认0,0,0.5就是正常的，一般不需要动
		Set3D('fovy',self.fovy[1]) --暂且认为是全局缩放，值越大看得越远
		Set3D('z'   ,self.z[1],self.z[2]) --渲染范围
		Set3D('fog' ,self.fog[1],self.fog[2],Color(self.fog[3],self.fog[4],self.fog[5],self.fog[6])) --雾气
		self.sakura = {}--飘到脸上的樱花
		self.trees = {} --最后一阶段背景的树对象
	end
	--把视野中心重新设置成默认的初始值
	function BG:refreshEyeCen()
		eggbg.baseBG.setEyeCen(self, 0, 4, 6)
		eggbg.baseBG.updateEyeCen(self, 0, 0, 0)
	end
	function BG:Sence1()
		--把纹理添加到表中
		eggbg.baseBG.addToImg(self, "c_cloud", "s4_circle_cloud", 120, 120)
		eggbg.baseBG.addToImg(self, "Island", "s4_Island", 45*1.35, 30*1.35)
		eggbg.baseBG.addToImg(self, "cloud1", "s4_cloud1", 75, 50)
		eggbg.baseBG.addToImg(self, "cloud2", "s4_cloud2", 75, 50)
		eggbg.baseBG.addToImg(self, "cloud3", "s4_cloud3", 10, 10)
		eggbg.baseBG.addToImg(self, "cloud4", "s4_cloud4", 10, 10)
		eggbg.baseBG.addToImg(self, "fog", "s4_fog", 60, 60)
		eggbg.baseBG.addToImg(self, "sun", "s4_sun", 150, 150)
		eggbg.baseBG.addToImg(self, "high_cloud", "s4_high_cloud", 70, 70)
		eggbg.baseBG.addToImg(self, "board", "s5_cloud_board", 120, 60)
		--生成背景元素对象
		self.boards = {} --云层纹理
		do
			table.insert(self.boards, eggbg.baseBG.creatStaticObj(self, "board", 0, -40, 30, {0, 1, 0}, "", 255))
			table.insert(self.boards, eggbg.baseBG.creatStaticObj(self, "board", 0, -40, 30, {0, 1, 0}, "mul+add", 255))
			table.insert(self.boards, eggbg.baseBG.creatStaticObj(self, "board", 0, 0, 20, {0, 1, 0}, "", 255))
			table.insert(self.boards, eggbg.baseBG.creatStaticObj(self, "board", 0, 0, 20, {0, 1, 0}, "mul+add", 255))
		end
		--太阳
		self.sun = eggbg.baseBG.creatStaticObj(self, "sun", 0, 0, 50, {90, -90}, "mul+add", 255)
		--背后的环状云
		self.c_cloud = eggbg.baseBG.creatStaticObj(self, "c_cloud", 0, 0, 50, {90, -90}, "mul+add", 20)
		--主岛
		self.Island = eggbg.baseBG.creatStaticObj(self, "Island", 0, -5, 50, {90, -90}, "", 215)
		self.cloud = {} --围绕岛周围的云彩层
		do
			local z = 50
			table.insert(self.cloud, eggbg.baseBG.creatStaticObj(self, "cloud1", -2, -25, 50, {90, -90}, "", 255))
			table.insert(self.cloud, eggbg.baseBG.creatStaticObj(self, "cloud2", 6, -25, 50, {90, -90}, "", 255))
			for _ = 1, 3 do
				table.insert(self.cloud, eggbg.baseBG.creatStaticObj(self, "cloud1", 0, -15, z, {90, -90}, "", 200))
				z = z - 7.5
				table.insert(self.cloud, eggbg.baseBG.creatStaticObj(self, "cloud2", 0, -15, z, {90, -90}, "", 200))
				z = z - 7.5
			end
		end
		--生成雾
		self.fogs = {}
		do
			local z, u = 0, 1
			for _ = 1, 10 do
				table.insert(self.fogs, eggbg.baseBG.creatStaticObj(self, "fog", 25*u, -40, z, {150, -90}, "", 0))
				z = z + 5
				u = -u
			end
		end
		--生成2d元素对象
		self.baseboard = eggbg.baseBG.creatStatic2dFontObj(self, "baseboard", 0, 0, 0, "", 255, 1, 1)
		eggbg.baseBG.creatStatic2dRearObj(self, "s4_polar1", 0, -180, 0, "", 50, 1, 1)
		eggbg.baseBG.creatStatic2dRearObj(self, "s4_polar2", 0, -40, 0, "", 50, 1, 1)

		--背景变化
		task.New(self, function()
			eggbg.baseBG.accDecEyePos(self, 0.025, {135, -90}, 240, 240, 120)
			eggbg.baseBG.changeEyeRot1To(self, 120, 540)
			task.Wait(480)
			task.New(self, function()
				eggbg.baseBG.accDecEyePos(self, 0.05, {160, -90}, 120, 180, 60)
				task.Wait(360)
				eggbg.baseBG.accDecEyePos(self, 0.2, {45, 90}, 60, 240, 60)
				task.Wait(70)
				task.New(self, function()
					local max = #self.cloud
					for i = 1, 6 do
						eggbg.baseBG.chObjAlpToZero(self, self.cloud[max - i + 1], 60)
						task.Wait(20)
					end
					--然后一起移除了(因为是从后往前的所以直接移除就行
					for _ = 1, 6 do
						table.remove(self.cloud)
					end
					task.Wait(140)
					--偷偷加两朵云把岛上方的东西遮盖住，以方便作转场动画
					table.insert(self.cloud, eggbg.baseBG.creatStaticObj(self, "cloud1", 15, 0, 50, {90, -90}, "", 255))
					table.insert(self.cloud, eggbg.baseBG.creatStaticObj(self, "cloud2", -15, 0, 50, {90, -90}, "", 255))
				end)
				task.Wait(60)
				eggbg.baseBG.chObjAlpToZero(self, self.boards[3], 60)
				eggbg.baseBG.chObjAlpToZero(self, self.boards[4], 60)
				task.Wait(20)
				eggbg.baseBG.accDecEyePos(self, 0.1, {0, 90}, 120, 60, 60) --再往下飞一点吧
				task.Wait(60)
				local dy = -10/120
				--偷偷地把太阳移下来2333
				for _ = 1, 120 do
					eggbg.baseBG.updateObjPos(self, self.sun, 0, dy, 0)
					task.Wait(1)
				end
				task.Wait(60)
			end)
			do
				--以下是镜头旋转
				local t = 360
				local uprota, uprotb = eggbg.baseBG.getUpRot(self)
				for x = 1, t do
					eggbg.baseBG.setUpRot(self, uprota, uprotb + (1-(cos(90/t*x)))*90)
					task.Wait(1)
				end
				uprota, uprotb = eggbg.baseBG.getUpRot(self)
				t = 240
				for x = 1, t do
					eggbg.baseBG.setUpRot(self, uprota, uprotb + (sin(90/t*x))*90)
					task.Wait(1)
				end
				uprota, uprotb = eggbg.baseBG.getUpRot(self)
				for x = 1, t do
					eggbg.baseBG.setUpRot(self, uprota, uprotb + (1-(cos(90/t*x)))*90)
					task.Wait(1)
				end
				uprota, uprotb = eggbg.baseBG.getUpRot(self)
				--起雾转场
				task.New(self, function()
					task.Wait(90)
					local v, t = -3, 20
					for _ = 1, 20 do
						for i = 1, 5 do
							New(cloud2d, -192 + i*90, 600, v, 2)
						end
						task.Wait(t)
						v = v - 0.6
						t = t - 1
					end
					--创建雾的转场效果
					do
						local x, dx, y, dy = -224, 448/5, -224, 448/5
						for _ = 1, 6 do
							x = -224
							for _ = 1, 6 do
								New(fog2d, x, y)
								x = x + dx
							end
							y = y + dy
						end
					end
					task.Wait(30)
					BG.Sence2(self)
				end)
				for x = 1, t do
					eggbg.baseBG.setUpRot(self, uprota, uprotb + (sin(90/t*x))*90)
					task.Wait(1)
				end
				task.Wait(90)
				eggbg.baseBG.changeEyeRot1To(self, 95, 180)
			end
		end)
	end
	--更新云层贴图
	function BG:updateFogs(t)
		if t < 1500 then
			local d_a, dz = 0, 0
			if t > 720 and t < 1080 then
				dz = -0.5*(t - 720)/360
				if t < 960 then
					d_a = 0.3
				else
					d_a = 8
				end
			elseif t >= 1080 and t < 1500 then
				dz = -0.5
				d_a = 8
			end
			for i = 1, #self.fogs do
				local _, _, z = eggbg.baseBG.getObjCen(self, self.fogs[i])
				if z < 0 then
					eggbg.baseBG.updateObjPos(self, self.fogs[i], 0, 0, 50)
					eggbg.baseBG.setObjAlp(self, self.fogs[i], 0)
				else
					eggbg.baseBG.updateObjAlp(self, self.fogs[i], d_a)
					eggbg.baseBG.updateObjPos(self, self.fogs[i], 0, 0, dz)
					if eggbg.baseBG.getObjAlp(self, self.fogs[i]) >= 80 then
						eggbg.baseBG.setObjAlp(self, self.fogs[i], 80)
					end
				end
			end
		end
	end
	function BG:circle_cloud()
		--环状云的旋转
		local s = self.c_cloud
		local w, h = eggbg.baseBG.getImgWH(self, "c_cloud")
		w, h = 0.5*w, 0.5*h
		local r = sqrt(h*h + w*w)
		local x, y = eggbg.baseBG.getObjCen(self, s)
		local rot = self.timer/6
		local dx, dy
		for i = 1, 4 do
			dx, dy = r*cos(225 - 90*i), r*sin(225 - 90*i)
			--BG.updateObjPoint(self, s, i, dx*cos(rot) - dy*sin(rot), dx*sin(rot) + dy*cos(rot), 0)
			s[2][i][1] = x + dx*cos(rot) - dy*sin(rot)
			s[2][i][2] = y + dx*sin(rot) + dy*cos(rot)
		end
	end
	--前几秒由暗变亮的效果
	function BG:renderStart(t)
		local obj, img, p, t1, t2
		if t < 90 then
			t = 0.3*t/90
			t1 = 0
			t2 = 2.5*t
		elseif t < 120 then
			t = 0.3*(1 - (t - 90)/30)
			t1 = 0
			t2 = 2.5*t
		elseif t < 300 then
			t = (t - 120)/180
			t1 = t
			t2 = t
		end
		--对baseboard特殊处理
		do
			obj = self.baseboard
			self.img = obj[1][1]
			SetImgState(self, obj[1][2], obj[1][3]*t1, 255*t1, 255*t1, 255*t1)
			Render(self.img, obj[3][1], obj[3][2], obj[4], obj[2][1], obj[2][2])
		end
		SetViewMode'3d'
		for i = 1, #self.static do
			if i ~= 5 then --目前五号位是太阳
				obj = self.static[i]
				img = obj[1][1]
				p = obj[2]
				SetImageState(img, obj[1][2], Color(obj[1][3], 255*t, 255*t, 255*t))
				Render4V(img,    p[1][1], p[1][2], p[1][3],
						p[2][1], p[2][2], p[2][3],
						p[3][1], p[3][2], p[3][3],
						p[4][1], p[4][2], p[4][3])
			else
				--对sun特殊处理
				do
					obj = self.sun
					img = obj[1][1]
					p = obj[2]
					SetImageState(img, obj[1][2], Color(obj[1][3], 255*t2, 255*t2, 255*t2))
					Render4V(img,    p[1][1], p[1][2], p[1][3],
							p[2][1], p[2][2], p[2][3],
							p[3][1], p[3][2], p[3][3],
							p[4][1], p[4][2], p[4][3])
				end
			end
		end
		for i = 1, #self.objs do
			obj = self.objs[i]
			img = obj[1][1]
			p = obj[2]
			SetImageState(img, obj[1][2], Color(obj[1][3], 255*t, 255*t, 255*t))
			Render4V(img,    p[1][1], p[1][2], p[1][3],
					p[2][1], p[2][2], p[2][3],
					p[3][1], p[3][2], p[3][3],
					p[4][1], p[4][2], p[4][3])
		end
		SetViewMode'world'
		for i = 1, #self.static2drear do
			obj = self.static2drear[i]
			self.img = obj[1][1]
			SetImgState(self, obj[1][2], obj[1][3], 255*t, 255*t, 255*t)
			Render(self.img, obj[3][1], obj[3][2], obj[4], obj[2][1], obj[2][2])
		end
	end
	--前几秒雾远去的效果
	function fogChange(self)
		eggbg.baseBG.setFog(self, 0, 75, 255, 0, 0, 0)
		task.New(self, function()
			task.Wait(90)
			for i = 1, 30 do
				eggbg.baseBG.setFogRange(self, 75*i/30, 75)
				task.Wait(1)
			end
			for i = 1, 120 do
				eggbg.baseBG.setFogRange(self, 75*(1 - i/120), 75)
				task.Wait(1)
			end
			for i = 1, 180 do
				eggbg.baseBG.setFogRange(self, 75*i/180, 75)
				task.Wait(1)
			end
		end)
	end
	--岩壁场景初始化
	function BG:Sence2()
		--SystemLog("sence2"..self.timer)
		BG.refreshEyeCen(self)
		--清空当前对象表
		do
			self.boards = {} --云层纹理
			self.static = {} --存储静止的对象
			self.active = {} --存储直线运动的对象
			self.objs = {} --渲染对象顺序的表
			self.cloud = {} --围绕岛周围的云彩层
			self.fogs = {} --生成雾
			self.static2dfont = {} --2d的静止贴图
			self.static2drear = {} --2d的静止贴图(后于3d渲染
			self.sakura = {}
		end
		--加载新纹理
		do
			eggbg.baseBG.addToImg(self, "moutain", "s5_moutain", 68, 90)
			eggbg.baseBG.addToImg(self, "s5_cloud1", "s5_cloud1", 15, 15)
			eggbg.baseBG.addToImg(self, "s5_cloud2", "s5_cloud2", 30, 30)
			eggbg.baseBG.addToImg(self, "s5_cloud3", "s5_cloud3", 20, 20)
			eggbg.baseBG.addToImg(self, "s5_light", "s5_light", 60, 50)
			eggbg.baseBG.addToImg(self, "s5_huge_light", "s5_light", 60, 200)
		end
		--背景正常加速，匀速，减速时间
		local t0, t1, t2, v1 = 240, 1400, 240, 0.6
		--创建岩壁对象，确保其在与视野中心的位置相对
		self.moutain = {}
		do
			local x, y, z = eggbg.baseBG.getEyeCen(self)
			self.moutain = eggbg.baseBG.creatAccDecConObj(self, "moutain", "", 255, x, y, z + 10, {90, -90}, 2, v1, {0, 90}, t0, t1, t2, 90)
			for i = 1, #self.moutain do
				eggbg.baseBG.accDecObjPos(self, self.moutain[i], 0.15, {90, 90}, 1, 120, 60)
			end
		end
		--创建3d的雾气
		do
			local x, y, z = eggbg.baseBG.getEyeCen(self)
			x, y, z = x - 15, y - 40, z + 20
			for _ = 1, 3 do
				for _, v in pairs(eggbg.baseBG.creatAccDecConObj(self, "s5_cloud1", "", 120, x, y, z, {90, -90}, 5, v1, {0, 90}, t0, t1, t2, 20)) do
					table.insert(self.fogs, v)
				end
				x = x + 5
				for _, v in pairs(eggbg.baseBG.creatAccDecConObj(self, "s5_cloud2", "", 120, x, y + 6, z + 5, {90, -90}, 5, v1 + 0.2, {0, 90}, t0, t1, t2, 20)) do
					table.insert(self.fogs, v)
				end
				x = x + 5
				for _, v in pairs(eggbg.baseBG.creatAccDecConObj(self, "s5_cloud3", "", 120, x, y + 12, z + 10, {90, -90}, 5, v1 + 0.4, {0, 90}, t0, t1, t2, 20)) do
					table.insert(self.fogs, v)
				end
				x = x + 5
			end
		end
		--创建彩虹
		do
			local x, y, z = eggbg.baseBG.getEyeCen(self)
			x, y, z = x, y - 40, z + 15
			self.rainbow = eggbg.baseBG.creatAccDecConObj(self, "s5_light", "mul+add", 90, x, y, z, {90, -90}, 3, v1 + 0.5, {0, 90}, t0, t1, t2, 60)
		end
		--创建两层处理颜色混合的纹理
		eggbg.baseBG.creatStatic2dRearObj(self, "s5_dec", 0, 0, 0, "mul+rev", 100, 1, 1.23)
		eggbg.baseBG.creatStatic2dRearObj(self, "s5_add(on_dec)", 0, 0, 0, "mul+add", 100, 1, 1.23)
		--场景结束切换效果
		do
			task.New(self, function()
				task.Wait(t0 + t1 + t2 - 240)
				eggbg.baseBG.changeEyeRot1To(self, 120, 240)
				for i = 1, #self.moutain do
					eggbg.baseBG.accDecObjPos(self, self.moutain[i], 0.1, {90, -90}, 1, 120, 60)
				end
				task.Wait(120)
				local x, y, z = eggbg.baseBG.getEyeCen(self)
				x, y, z = x, y + 110, z + 15
				eggbg.baseBG.creatAccDecConObj(self, "s5_huge_light", "mul+add", 255, x, y, z, {90, -90}, 1, v1 + 0.5, {0, 90}, 1, 1, 150, 150)
				for _ = 1, 60 do
					for i = 1, #self.fogs do
						eggbg.baseBG.updateObjAlp(self, self.fogs[i], 2)
						if eggbg.baseBG.getObjAlp(self, self.fogs[i]) > 255 then
							eggbg.baseBG.setObjAlp(self, self.fogs[i], 255)
						end
					end
					for i = 1, #self.rainbow do
						eggbg.baseBG.updateObjAlp(self, self.rainbow[i], 2)
						if eggbg.baseBG.getObjAlp(self, self.rainbow[i]) > 255 then
							eggbg.baseBG.setObjAlp(self, self.rainbow[i], 255)
						end
					end
					task.Wait(1)
				end
				--创建雾的转场效果
				do
					local x, dx, y, dy = -224, 448/5, -224, 448/5
					for _ = 1, 6 do
						x = -224
						for _ = 1, 6 do
							New(fog2d, x, y)
							x = x + dx
						end
						y = y + dy
					end
				end
				task.Wait(60)
				BG.Sence3(self)
			end)
		end
	end
	--二阶段岩壁场景测试
	function sence2test(self)
		eggbg.baseBG.setEyeRot(self, 120, 90)
		task.New(self, function()
			task.New(self, function()
				task.Wait(90)
				local v, t = -3, 20
				for _ = 1, 20 do
					for i = 1, 5 do
						New(cloud2d, -192 + i*90, 600, v, 2)
					end
					task.Wait(t)
					v = v - 0.6
					t = t - 1
				end
				--创建雾的转场效果
				do
					local x, dx, y, dy = -224, 448/5, -224, 448/5
					for _ = 1, 6 do
						x = -224
						for _ = 1, 6 do
							New(fog2d, x, y)
							x = x + dx
						end
						y = y + dy
					end
				end
				task.Wait(30)
				BG.Sence2(self)
			end)
			task.Wait(330)
			eggbg.baseBG.changeEyeRot1To(self, 95, 180)
		end)
	end
	--三阶段岛上空场景初始
	function BG:Sence3()
		--SystemLog("sence3"..self.timer)
		self.timer = 3530
		BG.refreshEyeCen(self)
		--清空当前对象表
		do
			self.boards = {} --云层纹理
			self.static = {} --存储静止的对象
			self.active = {} --存储直线运动的对象
			self.objs = {} --渲染对象顺序的表
			self.cloud = {} --围绕岛周围的云彩层
			self.fogs = nil --清除上一场景的雾
			self.moutain = nil --清除上一场景的岩壁
			self.static2dfont = {} --2d的静止贴图
			self.static2drear = {} --2d的静止贴图(后于3d渲染
			self.rainbow = nil --清除上一场景的彩虹
			self.sakura = {}
		end
		--加载新纹理
		do
			eggbg.baseBG.addToImg(self, "s5_light", "s5_light", 90, 70)
			eggbg.baseBG.addToImg(self, "c_cloud", "s4_circle_cloud", 120, 120)
			--
			eggbg.baseBG.addToImg(self, "s5_Island1", "s5_Island1", 77, 67)
			eggbg.baseBG.addToImg(self, "s5_Island2", "s5_Island2", 77, 67)
			eggbg.baseBG.addToImg(self, "s5_Island_cloud", "s5_Island_cloud", 77, 36)
			eggbg.baseBG.addToImg(self, "s5_sun", "s5_sun", 120, 120)
		end
		--创建2d板
		do
			eggbg.baseBG.creatStatic2dFontObj(self, "s5_baseboard", 0, 0, 0, "", 255, 1, 1.2)
		end
		local x, y, z = eggbg.baseBG.getEyeCen(self)
		x, y, z = x, y - 60, z + 5
		--太阳
		do
			eggbg.baseBG.creatStaticObj(self, "s5_sun", x, y, z + 30, {90, -90}, "mul+add", 200)
		end
		--岛的下半部分
		do
			eggbg.baseBG.creatStaticObj(self, "s5_Island2", x, y - 5, z, {110, -90}, "", 255)
		end
		--背后的环状云(是的它又回来了
		do
			self.c_cloud = eggbg.baseBG.creatStaticObj(self, "c_cloud", x, y, z, {90, -90}, "mul+add", 40)
		end
		--岛的上半部分
		do
			eggbg.baseBG.creatStaticObj(self, "s5_Island1", x, y - 5, z, {110, -90}, "", 255)
		end
		--岛上空的拼接云
		do
			eggbg.baseBG.creatAccDecConObj(self, "s5_Island_cloud", "", 255, x, y + 20, z, {90, -90}, 2, 0.5, {90, 0}, 1, 1500, 60, 77)
			eggbg.baseBG.creatAccDecConObj(self, "s5_Island_cloud", "", 255, x, y, z - 5 , {90, -90}, 2, 0.25, {90, 0}, 1, 1500, 60, 77)
			eggbg.baseBG.creatAccDecConObj(self, "s5_Island_cloud", "", 255, x, y - 5, z - 15 , {90, -90}, 2, 0.25, {90, 0}, 1, 1500, 60, 77)
			eggbg.baseBG.creatAccDecConObj(self, "s5_Island_cloud", "", 255, x, y - 15, z - 10 , {90, -90}, 2, 0.2, {90, 0}, 1, 1500, 60, 77)
		end
		eggbg.baseBG.creatAccDecConObj(self, "s5_light", "mul+add", 150, x, y, z - 15, {110, -90}, 3, 0.5, {20, -90}, 0, 0, 0, 30)
		--视角、摄像机位置的动态变化
		do
			eggbg.baseBG.setEyeRot(self, 120, 90)
			task.New(self, function()
				eggbg.baseBG.changeEyeRot1To(self, 95, 1200)
				eggbg.baseBG.accDecEyePos(self, 0.1,  {40, -90}, 1, 1, 1100)
				task.Wait(1000)
				eggbg.baseBG.accDecEyePos(self, 0.05,  {70, 90}, 200, 200, 200)
				eggbg.baseBG.accDecEyePos(self, 0.1,  {0, -90}, 120, 150, 120)
				task.Wait(500)
				eggbg.baseBG.accDecEyePos(self, 0.5,  {160, 90}, 120, 9, 1)
				task.Wait(70)
				--创建雾的转场效果
				do
					local x, dx, y, dy = -224, 448/5, 224, -448/5
					for _ = 1, 6 do
						x = -224
						for _ = 1, 6 do
							New(fog2d, x, y)
							x = x + dx
						end
						y = y + dy
					end
				end
				task.Wait(60)
				BG.Sence4(self)
			end)
		end
	end
	--四阶段参拜道
	function BG:Sence4()
		self.timer = 5160
		--SystemLog("sence4"..self.timer)
		BG.refreshEyeCen(self)
		--视角归正
		do

		end
		--清空当前对象表
		do
			self.boards = {} --云层纹理
			self.static = {} --存储静止的对象
			self.active = {} --存储直线运动的对象
			self.objs = {} --渲染对象顺序的表
			self.cloud = {} --围绕岛周围的云彩层
			self.fogs = nil --清除上一场景的雾
			self.moutain = nil --清除上一场景的岩壁
			self.static2dfont = {} --2d的静止贴图
			self.static2drear = {} --2d的静止贴图(后于3d渲染
			self.rainbow = nil --清除上一场景的彩虹
			self.sakura = {}
		end
		--加载新纹理
		do
			eggbg.baseBG.addToImg(self, "s5_light", "s5_light", 90, 70)
			eggbg.baseBG.addToImg(self, "c_cloud", "s4_circle_cloud", 120, 120)
			eggbg.baseBG.addToImg(self, "s5_Island3", "s5_Island3", 77, 48)
			eggbg.baseBG.addToImg(self, "s5_Island_cloud", "s5_Island_cloud", 77, 36)
			eggbg.baseBG.addToImg(self, "s5_sun", "s5_sun", 120, 120)
			eggbg.baseBG.addToImg(self, "s5_roads", "s5_roads", 21.6, 5)
			eggbg.baseBG.addToImg(self, "s5_line", "s5_line", 40, 40)
			eggbg.baseBG.addToImg(self, "s5_torii", "s5_torii", 13, 13/1.19)
			eggbg.baseBG.addToImg(self, "s5_tree1", "s5_tree1", 20, 20)
			eggbg.baseBG.addToImg(self, "s5_tree2", "s5_tree2", 20, 20)
			eggbg.baseBG.addToImg(self, "s5_tree3", "s5_tree1", 10, 10)
			eggbg.baseBG.addToImg(self, "s5_tree4", "s5_tree2", 8, 8)
			eggbg.baseBG.addToImg(self, "s5_tree5", "s5_tree1", 15, 15)
			eggbg.baseBG.addToImg(self, "s5_tree6", "s5_tree2", 15, 15)
			eggbg.baseBG.addToImg(self, "s5_big_tree", "s5_tree3", 30, 40)
			eggbg.baseBG.addToImg(self, "s5_huge_tree", "s5_tree2", 60, 70)
			eggbg.baseBG.addToImg(self, "s5_huge_tree2", "s5_tree1", 60, 70)
			eggbg.baseBG.addToImg(self, "s4_cloud1", "s4_cloud1", 30, 25)
			eggbg.baseBG.addToImg(self, "s4_cloud2", "s4_cloud2", 30, 25)
		end
		--创建2d板
		do
			eggbg.baseBG.creatStatic2dFontObj(self, "s5_baseboard", 0, 0, 0, "", 255, 1, 1.2)
		end
		local x, y, z = eggbg.baseBG.getEyeCen(self)
		x, y, z = x, y - 5, z
		--太阳
		do
			eggbg.baseBG.creatStaticObj(self, "s5_sun", x, y, z + 30, {90, -90}, "mul+add", 200)
		end
		--背后的环状云(是的它又回来了
		do
			self.c_cloud = eggbg.baseBG.creatStaticObj(self, "c_cloud", x, y, z + 50, {90, -90}, "mul+add", 20)
		end
		--岛的远景部分
		do
			eggbg.baseBG.creatStaticObj(self, "s5_Island3", x, y + 5, z + 45, {110, -90}, "", 255)
		end
		local v, t = 0.1, 240 --速度
		self.treev = -v --统一树和鸟居的运动
		--道路部分
		do
			eggbg.baseBG.creatAccDecConObj(self, "s5_roads", "", 255, x, y, z, {180, 90}, 13, v, {90, -90}, t, 999999, 60, 5)
		end
		--两边拿树的纹理来铺地板2333
		do
			eggbg.baseBG.opCreatAccDecConObj(self, "s5_big_tree", "", 200, x - 20, y, z + 5, {180, 90}, 7, v, {90, -90}, 1, 99999, 60, 8)
			eggbg.baseBG.opCreatAccDecConObj(self, "s5_big_tree", "", 200, x + 20, y, z + 5, {0, 90}, 7, v, {90, -90}, 1, 99999, 60, 8)
		end
		eggbg.baseBG.creatStaticObj(self, "s5_line", x, y, z + 50, {180, 90}, "", 255)
		--岛上空的拼接云
		do
			eggbg.baseBG.creatAccDecConObj(self, "s5_Island_cloud", "", 255, x, y + 40, z + 50, {90, -90}, 2, 0.5, {90, 0}, 1, 99999, 60, 77)
		end
		--鸟居
		do
			for i = 1, 4 do
				BG.creatTreesObj(self, "s5_torii", x, y + 5, z + 15*(i-1), {90, -90}, "", 255)
			end
			--eggbg.baseBG.opCreatAccDecConObj(self, "s5_torii", "", 255, x, y + 6, z, {90, -90}, 4, v, {90, -90}, 1, 1500, 60, 12.5)
		end
		--树
		do
			for i = 1, 6 do
				BG.creatTreesObj(self, "s5_tree4", x - 6, y + 3, z + 10*(i-1), {85, -90}, "", 255)
				BG.creatTreesObj(self, "s5_tree5", x - 12, y + 6.5, z + 10*(i-1)+3, {85, -90}, "", 255)
				BG.creatTreesObj(self, "s5_tree1", x - 15, y + 9, z + 10*(i-1)+6, {85, -90}, "", 255)
				BG.creatTreesObj(self, "s5_tree3", x + 6, y + 4, z + 10*(i-1), {85, -90}, "", 255)
				BG.creatTreesObj(self, "s5_tree6", x + 9, y + 6.5, z + 10*(i-1)+3, {85, -90}, "", 255)
				BG.creatTreesObj(self, "s5_tree2", x + 12, y + 9, z + 10*(i-1)+6, {85, -90}, "", 255)
			end
		end
		eggbg.baseBG.creatAccDecConObj(self, "s5_light", "mul+add", 150, x, y, z - 15, {110, -90}, 3, 0.5, {20, -90}, 0, 0, 0, 30)
		--背景变化
		do
			eggbg.baseBG.setEyeCen(self, 0, 30, 40)
			eggbg.baseBG.updateEyeCen(self, 0, 0, 0)
			eggbg.baseBG.setEyeRot(self, 95, 90)
			--eggbg.baseBG.setFog(self, 0, 50, 255, 100, 100, 100) --设置体积雾气
			--eggbg.baseBG.changeFogRange0To(self, 40, 240)
			task.New(self, function()
				--eggbg.baseBG.accDecEyePos(self, 0.28, {67, -90}, 1, 120, 30)
				eggbg.baseBG.accDecEyePos(self, 0.28, {67, -90}, 1, 75, 120)
				task.Wait(3620) --8780
				eggbg.baseBG.accDecEyePos(self, 0.01, {0, -90}, 600, 600, 600)
			end)
		end
	end
	--樱花树与鸟居渲染
	function BG:tree_frame()
		local obj
		local back = {} --存放要前进的obj
		for i = 1, #self.trees do
			obj = self.trees[i]
			eggbg.baseBG.updateObjPos(self, obj, 0, 0, self.treev)
			if eggbg.baseBG.getObjAlp(self, obj) >= 255 then
				eggbg.baseBG.setObjAlp(self, obj, 255)
			else
				eggbg.baseBG.updateObjAlp(self, obj, 1.5)
			end
			if obj[3][3] < 0 then
				table.insert(back, obj)
				eggbg.baseBG.updateObjPos(self, obj, 0, 0, 60)
				eggbg.baseBG.setObjAlp(self, obj, 0)
			end
		end
		for i = 1, #back do
			table.remove(self.trees)
			table.insert(self.trees, 1, back[i])
		end
	end
	function BG:tree_render()
		SetViewMode'3d'
		local obj, img, p
		for i = 1, #self.trees do
			obj = self.trees[i]
			img = obj[1][1]
			p = obj[2]
			SetImageState(img, obj[1][2], Color(obj[1][3], 255, 255, 255))
			Render4V(img,    p[1][1], p[1][2], p[1][3],
					p[2][1], p[2][2], p[2][3],
					p[3][1], p[3][2], p[3][3],
					p[4][1], p[4][2], p[4][3])
		end
		SetViewMode'world'
	end
	--根据索引在背景里创建新特殊树对象
	---@param img string @索引名
	---@param rot table @可以是直接的三维向量，也可以是ball创建的对象({a, b})
	---@return table @返回静止的背景元素对象
	function BG:creatTreesObj(img, x, y, z, rot, blend, _a)
		blend = blend or ""
		_a = _a or 255
		local tex = eggbg.baseBG.getImgTex(self, img)
		local w, h = eggbg.baseBG.getImgWH(self, img) --读取对应纹理在背景里的宽高
		local p = Get_Four_Points(x, y, z, w, h, eggbg.ballToVect3(rot)) --获取点
		local obj = {{tex, blend, _a}, p, {x, y, z}, rot}
		--插入时拥有按z轴大小自动排序的功能
		local pos = 1
		for _ = 1, #self.trees do
			if obj[3][3] > self.trees[pos][3][3] then
				break
			else
				pos = pos + 1
			end
		end
		table.insert(self.trees, pos, obj)
		return obj
	end
	--花瓣对象
	function BG:creatSakuraObj(img, x, y, z, rot, v, a, blend, _a)
		blend = blend or ""
		_a = _a or 255
		local a0 --新定义局部变量，注意保护原数据
		if #a == 2 then
			a0 = eggbg.ballToVect3(a)
		else
			a0 = a
		end
		local tex = eggbg.baseBG.getImgTex(self, img)
		local w, h = eggbg.baseBG.getImgWH(self, img) --读取对应纹理在背景里的宽高
		local p = Get_Four_Points(x, y, z, w, h, eggbg.ballToVect3(rot)) --获取点
		local obj = {{tex, blend, _a}, p, {x, y, z}, rot, {v*a0[1], v*a0[2], v*a0[3]}}
		table.insert(self.sakura, obj)
		return obj
	end
	--樱花花瓣的渲染
	function BG:sakura_frame(t)
		if t < 1650 then
			--创建花瓣
			if t < 1000 and t > 180 then
				if self.timer % 2 == 0 then
					table.insert(self.sakura, BG.creatSakuraObj(self, "sakura2", ran:Float(-50, 50), 40, 50, {ran:Float(-100, -80), ran:Float(0, 360)}, 0.15, {ran:Float(5, 20), ran:Float(-80, -100)}, "", 0))
				end
			elseif t > 1000 then
			if self.timer % 2 == 0 then
					table.insert(self.sakura, BG.creatSakuraObj(self, "sakura2", ran:Float(-10, 10), ran:Float(-25, -5), 100, {ran:Float(-100, -80), ran:Float(0, 360)}, 0.3, {ran:Float(60, 75), ran:Float(-80, -100)}, "", 0))
				end
			end
			local obj
			local i, n = 1, #self.sakura
			while(i <= n) do
				obj = self.sakura[i]
				eggbg.baseBG.updateObjPos(self, obj, obj[5][1], obj[5][2], obj[5][3]) --更新位置
				eggbg.baseBG.updateObjRot(self, obj, 0, 1)
				--更新透明度
				do
					eggbg.baseBG.updateObjAlp(self, obj, 1.5)
					if eggbg.baseBG.getObjAlp(self, obj) >= 255 then
						eggbg.baseBG.setObjAlp(self, obj, 255)
					end
				end
				if obj[3][3] < 0 then
					table.remove(self.sakura, i)
					n = n - 1
				else
					i = i + 1
				end  --删除超界的花瓣
			end
		elseif t < 3530 then
				--创建花瓣
				if self.timer % 4 == 0 then
					table.insert(self.sakura, BG.creatSakuraObj(self, "sakura", 20, ran:Float(20, 40), 20, {ran:Float(-100, -80), ran:Float(0, 360)}, 0.15, {ran:Float(30, 50), ran:Float(180, 190)}, "", 0))
				end
				local obj
				local i, n = 1, #self.sakura
				while(i <= n) do
					obj = self.sakura[i]
					eggbg.baseBG.updateObjPos(self, obj, obj[5][1], obj[5][2], obj[5][3]) --更新位置
					eggbg.baseBG.updateObjRot(self, obj, 0, 1)
					--更新透明度
					do
						eggbg.baseBG.updateObjAlp(self, obj, 1.5)
						if eggbg.baseBG.getObjAlp(self, obj) >= 255 then
							eggbg.baseBG.setObjAlp(self, obj, 255)
						end
					end
					if obj[3][2] < -20 then
						table.remove(self.sakura, i)
						n = n - 1
					else
						i = i + 1
					end  --删除超界的花瓣
				end
		elseif t < 5160 then
			--创建花瓣
			if self.timer % 3 == 0 then
				table.insert(self.sakura, BG.creatSakuraObj(self, "sakura", ran:Float(-20, 20), 20, 24, {ran:Float(-100, -80), ran:Float(0, 360)}, 0.1, {ran:Float(10, 25), ran:Float(-85, -95)}, "", 0))
			end
			local obj
			local i, n = 1, #self.sakura
			while(i <= n) do
				obj = self.sakura[i]
				eggbg.baseBG.updateObjPos(self, obj, obj[5][1], obj[5][2], obj[5][3]) --更新位置
				eggbg.baseBG.updateObjRot(self, obj, 0, 1)
				--更新透明度
				do
					eggbg.baseBG.updateObjAlp(self, obj, 1.5)
					if eggbg.baseBG.getObjAlp(self, obj) >= 255 then
						eggbg.baseBG.setObjAlp(self, obj, 255)
					end
				end
				if obj[3][2] < -80 then
					table.remove(self.sakura, i)
					n = n - 1
				else
					i = i + 1
				end  --删除超界的花瓣
			end
		else
			--创建花瓣
			if self.timer % 3 == 0 then
				table.insert(self.sakura, BG.creatSakuraObj(self, "sakura", ran:Float(-40, 40), 40, 50, {ran:Float(-100, -80), ran:Float(0, 360)}, 0.1, {ran:Float(20, 50), ran:Float(-75, -105)}, "", 0))
			end
			local obj
			local i, n = 1, #self.sakura
			while(i <= n) do
				obj = self.sakura[i]
				eggbg.baseBG.updateObjPos(self, obj, obj[5][1], obj[5][2], obj[5][3]) --更新位置
				eggbg.baseBG.updateObjRot(self, obj, 0, 1)
				--更新透明度
				do
					eggbg.baseBG.updateObjAlp(self, obj, 1.5)
					if eggbg.baseBG.getObjAlp(self, obj) >= 255 then
						eggbg.baseBG.setObjAlp(self, obj, 255)
					end
				end
				if obj[3][3] < 0 then
					table.remove(self.sakura, i)
					n = n - 1
				else
					i = i + 1
				end  --删除超界的花瓣
			end
		end

	end
	--樱花花瓣的渲染
	function BG:sakura_render(t)
		SetViewMode'3d'
		--创建花瓣
		local obj, img, p
		for i = 1, #self.sakura do
			obj = self.sakura[i]
			img = obj[1][1]
			p = obj[2]
			SetImageState(img, obj[1][2], Color(obj[1][3], 255, 255, 255))
			Render4V(img,    p[1][1], p[1][2], p[1][3],
					p[2][1], p[2][2], p[2][3],
					p[3][1], p[3][2], p[3][3],
					p[4][1], p[4][2], p[4][3])
		end
		SetViewMode'world'
	end
end
function BG:init(Isboss)
	load_res() -- 加载资源在这里
	eggbg.baseBG.init(self)
	BG.setDefault(self)
	if Isboss then
		BG.Sence4(self)
	else
		BG.Sence1(self)
	end
	fogChange(self)
	--sence2test(self) --p2单独测试
	--BG.Sence3(self)
	--BG.Sence4(self)
end
function BG:frame()
	background_open = setting.background
	if background_open then
		task.Do(self)
		eggbg.baseBG.frame(self)
		BG.circle_cloud(self)
		BG.updateFogs(self, self.timer)
		BG.tree_frame(self)
		BG.sakura_frame(self, self.timer)
	end
end
function BG:render()
	if background_open then
		background.WarpEffectCapture()
		--eggbg.baseBG.printParam(self) --打印背景相关参数，测试用
		if self.timer < 300 then
			BG.renderStart(self, self.timer)
		else
			eggbg.baseBG.render(self)
		end
		--eggbg.baseBG.render(self)
		BG.tree_render(self)
		BG.sakura_render(self, self.timer)
		eggbg.baseBG.renderBlackBoard(self)
		background.WarpEffectApply()
	else
		eggbg.baseBG.renderGrayBoard()
	end
end

----------------------------------------]]
---导出定义

stage5_background = BG

--背景小道具定义
do
	--岩壁转场的云
	cloud2d = Class(_object)
	function cloud2d:init(x, y, vy, size)
		self.x, self.y = x, y
		self.rot = ran:Float(0, 360)
		self.omiga = ran:Float(0, 0.15)
		self.hscale, self.vscale = size, size
		self.bound = false
		self.img = "s4_cloud"..ran:Int(1, 2)
		_object.set_color(self, "", 0, 255, 255, 255)
		self.vy = vy
		task.New(self, function()
			self.layer = LAYER_BG+1
			local d_a = 100/20
			for _ = 1, 20 do
				self._a = self._a + d_a
				task.Wait(1)
			end
			task.Wait(400)
			Del(self)
		end)
	end
	function cloud2d:frame()
		task.Do(self)
	end
	function cloud2d:render()
		_object.render(self)
	end

	--岩壁转场雾
	fog2d = Class(_object)
	function fog2d:init(x, y)
		self.x, self.y = x, y
		self.rot = ran:Float(0, 360)
		self.omiga = ran:Float(0, 0.15)
		self.hscale, self.vscale = 1, 1
		self.bound = false
		self.img = "s4_fog"
		_object.set_color(self, "", 0, 253, 249, 224)
		task.New(self, function()
			self.layer = LAYER_BG
			local d_a = 255/60
			for _ = 1, 60 do
				self._a = self._a + d_a
				task.Wait(1)
			end
			d_a = -255/60
			for _ = 1, 60 do
				self._a = self._a + d_a
				task.Wait(1)
			end
			Del(self)
		end)
	end
	function fog2d:frame()
		task.Do(self)
	end
	function fog2d:render()
		_object.render(self)
	end

	--岩壁

end
