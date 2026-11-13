---======================================
---祈华梦四面背景
---by S7UPID
---======================================

local background_open = setting.background --背景开关选项
local ran = lstg.Rand()

local path = "res/background/stage4/"

--res
--4, 5公共素材
LoadImageFromFile("baseboard", path .. "s4_baseboard.png")
LoadImageFromFile("s4_Island", path .. "s4_Island.png")
LoadImageFromFile("s4_cloud3", path .. "s4_cloud3.png")
LoadImageFromFile("s4_cloud4", path .. "s4_cloud4.png")
LoadImageFromFile("s4_sun", path .. "s4_sun.png")
SetImageState("s4_sun", "mul+add", Color(255, 255, 255, 255))

--4, 5, 6公共素材
LoadImageFromFile("s4_cloud1", path .. "s4_cloud1.png")
LoadImageFromFile("s4_cloud2", path .. "s4_cloud2.png")
LoadImageFromFile("s4_polar1", path .. "s4_polar1.png")
SetImageState("s4_polar1", "", Color(50, 255, 255, 255))
LoadImageFromFile("s4_polar2", path .. "s4_polar2.png")
SetImageState("s4_polar2", "", Color(50, 255, 255, 255))
LoadImageFromFile("s4_high_cloud", path .. "s4_high_cloud.png")
SetImageState("s4_high_cloud", "mul+add", Color(50, 255, 255, 255))
LoadImageFromFile("s4_sakura", path .. "s4_sakura.png")

--4, 5, 6, 4boss公共素材
LoadImageFromFile("s4_fog", path .. "s4_fog.png")
LoadImageFromFile("s4_circle_cloud", path .. "s4_circle_cloud.png")

local function load_res()
	LoadImageFromFile("s4_cloud5", path .. "s4_cloud5.png")
	LoadImageFromFile("s4_moutain1", path .. "s4_moutain1.png")
	LoadImageFromFile("s4_moutain2", path .. "s4_moutain2.png")
	LoadImageFromFile("s4_fly_up1", path .. "s4_fly_up1.png")
	LoadImageFromFile("s4_fly_up2", path .. "s4_fly_up2.png")
end
load_res()

----------------------------------------

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


---背景定义
local s4_bg_setter1, s4_bg_setter2, bossbg

local BG = Class(object)

--通过改变面的朝向来改变四个顶点的位置
---@param obj table @本关定义的背景元素
---@param rot table @渲染面的原朝向向量参数
---@return table @四个顶点坐标的集合
function BG:Change_Four_Points(obj, rot)
	local p = {}
	local x, y, z
	local _x, _y, _z
	if obj.p then
	   for i = 1, 4 do
		   x, y, z = obj.x, obj.y, obj.z
		   _x, _y, _z = obj.p[i][1], obj.p[i][2], obj.p[i][3]
		   p[i] = Point_by_Quaternion(x, y, z, _x, _y, _z, obj.rot, rot)
	   end
	else
	   for i = 1, 4 do
		   x, y, z = obj[1], obj[2], obj[3]
		   _x, _y, _z = obj[6][i][1], obj[6][i][2], obj[6][i][3]
		   p[i] = Point_by_Quaternion(x, y, z, _x, _y, _z, obj[5], rot)
	   end
	end
	obj[5] = rot
	return p
end

--给樱花用的
function BG:Change_Four_Points2(obj, rot)
	local p = {}
	local x, y, z = obj[1][1], obj[1][2], obj[1][3]
	local _x, _y, _z
	for i = 1, 4 do
		_x, _y, _z = obj[6][i][1], obj[6][i][2], obj[6][i][3]
		p[i] = Point_by_Quaternion(x, y, z, _x, _y, _z, obj[2], rot)
	end
	return p
end

function BG:Change_obj_rot() --仅限此背景类的类方法，更新一下需要一直与视线垂直的面的朝向
	local rot, obj = Get_Opposite_Vector(self.eye_rot)
	for i = 1, #self.objs do
		obj = self.objs[i]
		obj[6] = BG.Change_Four_Points(self, obj, rot)
	end

	self.Island.p = BG.Change_Four_Points(self, self.Island, rot)
	self.Island.rot = rot
	self.cloud1.p = BG.Change_Four_Points(self, self.cloud1, rot)
	self.cloud1.rot = rot
	self.cloud2.p = BG.Change_Four_Points(self, self.cloud2, rot)
	self.cloud2.rot = rot
	self.fog.p = BG.Change_Four_Points(self, self.fog, rot)
	self.fog.rot = rot
end

--将背景立即变化为boss场景
function BG:bossSence()
	self.eye_position[1] = 0
	self.eye_position[2] = 4
	self.eye_rot_ab[2] = 90
	self.eye_rot_ab[1] = 95
	self.bg_speed = 0.2
	--[[for _ = 1, 60 do
		BG.frame(self)
	end]]
	self.eye_position[3] = 6
	self.bg_speed = 0
end

function BG:init(IsBoss)
	self.eye_position = {0, 4, 0} --眼睛的初始位置
	self.last_eye_position = {0, 4, 0} --用于判断中心是否有变化
	self.eye_rot_ab = {150, 90} --1球坐标系的θ，取值0到180  2球坐标系的φ，取值0到360（当然也可以更高）
	self.last_eye_rot_ab = {self.eye_rot_ab[1], self.eye_rot_ab[2]}
	self.eye_rot = {sin(self.eye_rot_ab[1])*cos(self.eye_rot_ab[2]), cos(self.eye_rot_ab[1]), sin(self.eye_rot_ab[1])*sin(self.eye_rot_ab[2])} --眼睛朝向的单位法向量(这里是默认向下60度)(采用球坐标系, r = 1, 此处θ = 120,φ = -90)
	--set camera
	--背景被创建时我初始摄像机参数
	--这里以云层高度为0
	Set3D('eye' , self.eye_position[1], self.eye_position[2], self.eye_position[3])
	Set3D('at'  , self.eye_position[1] + self.eye_rot[1], self.eye_position[2] + self.eye_rot[2], self.eye_position[3] + self.eye_rot[3]) --暂且让眼睛的视角向下约30度吧
	Set3D('up'  , 0,  0, 0.5) --三个参数都是控制整个背景旋转的，默认0,0,0.5就是正常的，一般不需要动
	Set3D('fovy',1.5) --暂且认为是全局缩放，值越大看得越远
	Set3D('z'   ,0.1,100.00) --渲染范围
	Set3D('fog' ,100,100,Color(0,255,255,175)) --雾气
	--
	self.layer = LAYER_BG
	self.bg_speed = 0.04 --背景前进的速度
	self.bg_rot_ab = {90, -90} --同样也是球坐标系
	self.last_bg_rot_ab = {self.bg_rot_ab[1], self.bg_rot_ab[2]}
	self.bg_rot = {sin(self.bg_rot_ab[1])*cos(self.bg_rot_ab[2]), cos(self.bg_rot_ab[1]), sin(self.bg_rot_ab[1])*sin(self.bg_rot_ab[2])} --背景前进的方向的法向量(其反方向也是生成背景元素的方向)
	self.bg_dist_max = 0.8 --每个背景元素间的距离
	self.bg_dist = self.bg_dist_max --每个背景元素间的距离的计数器
	self.range = 20 --出屏范围
	self.hide_range = 50 --透明度开始变化范围

	self.imgs = {{"s4_cloud3", 11.2, 8}, {"s4_cloud4", 11.2, 8}, {"s4_cloud5", 11.2, 8},
				 {"s4_moutain1", 10, 6}, {"s4_moutain2", 10, 6},
				 {"s4_high_cloud", 20, 4}} --向前进的元素，如云，山 (表中第一个参数是纹理名，第二个是宽，第三个是高）
	self.pos = 1
	self.objs = {}--用于存储渲染元素先后顺序的表(表前头的先渲染)

	self.Island = {x = 0, y = 0, z = 30, img = "s4_Island", height = 30, width = 45, rot = Get_Opposite_Vector(self.eye_rot), p = {}, alpha = 255, blend = ""} --岛
	self.Island.p = Get_Four_Points(self.Island.x, self.Island.y, self.Island.z, self.Island.width, self.Island.height, self.Island.rot, 1)
	self.cloud1 = {x = 6, y = 0, z = 20, img = "s4_cloud1", height = 35, width = 75, rot = Get_Opposite_Vector(self.eye_rot), p = {}, alpha = 240, blend = ""} --岛的云1
	self.cloud1.p = Get_Four_Points(self.cloud1.x, self.cloud1.y, self.cloud1.z, self.cloud1.width, self.cloud1.height, self.cloud1.rot, 1)
	self.cloud2 = {x = -10, y = 0, z = 20, img = "s4_cloud2", height = 35, width = 75, rot = Get_Opposite_Vector(self.eye_rot), p = {}, alpha = 240, blend = ""} --岛的云2
	self.cloud2.p = Get_Four_Points(self.cloud2.x, self.cloud2.y, self.cloud2.z, self.cloud2.width, self.cloud2.height, self.cloud2.rot, 1)
	self.fog = {x = 0, y = 0, z = 30, img = "s4_fog", height = 40, width = 60, rot = Get_Opposite_Vector(self.eye_rot), p = {}, alpha = 240, blend = ""} --岛中间的雾
	self.fog.p = Get_Four_Points(self.fog.x, self.fog.y, self.fog.z, self.fog.width, self.fog.height, self.fog.rot, 1)

	self.sun = {x = 0, y = 5, z = 40, img = "s4_sun", height = 75, width = 75, rot = {0, 0, -1}, p = {}, alpha = 255, blend = "mul+add"} --太阳
	self.sun.p = Get_Four_Points(self.sun.x, self.sun.y, self.sun.z, self.sun.width, self.sun.height, {0, 0, -1})

	self.c_cloud = {x = 0, y = 0, z = 50, img = "s4_circle_cloud", height = 120, width = 120, rot = {0, 0, -1}, p = {}, alpha = 20, blend = "mul+add"}
	self.c_cloud.p = Get_Four_Points(self.c_cloud.x, self.c_cloud.y, self.c_cloud.z, self.c_cloud.width, self.c_cloud.height, {0, 0, -1})
	self.big_objs = {self.sun, self.c_cloud, self.Island, self.cloud1, self.cloud2, self.fog}--大的背景物，如太阳，岛，按渲染先后顺序排列

	self.sakura = {}--飘到脸上的樱花
	self.IsBoss = IsBoss
	if IsBoss then
		BG.bossSence(self)
	end
end

function BG:frame()
	background_open = setting.background
	if background_open then
		task.Do(self)
		if setting.background_mask >= 100 then self.hide = true else self.hide = false end
		local obj
		local dt = 0
		if not self.IsBoss then dt =  6150 end --这里是留给之后的单独boss战练习的接口，需要时改成条件表达式
		local A, B = self.eye_rot[1], self.eye_rot[3]  --在xOz面上的直线Ax + Bz = 0
		local _A, _B = self.bg_rot[1], self.bg_rot[3]
		local m = sqrt(A*A + B*B)
		local _m = sqrt(_A*_A + _B*_B)
		A, B, _A, _B = A/m, B/m, _A/_m, _B/_m  --把xOz面上的方向向量单位化
		local x0, z0, d, _d
		local n = #self.objs
		for i = 1, n do
			if self.objs[i] then --因为中间过程中可能会删除元素导致表长变短，所以需要判断元素是否还存在，不存在的话说明该元素及后面已不存在，直接跳出即可
				obj = self.objs[i]
			else
				break
			end
			x0, z0 = obj[1] - self.eye_position[1], obj[3] - self.eye_position[3]  --该元素相对于眼睛的位置
			d = (A*x0 + B*z0)/m --在xOz面上，点到过摄像机点且与视线垂直的直线的距离
			if d<= self.hide_range and d>= -self.hide_range then --距离大于，小于5时的渐变处理
				obj[7] = min(obj[8], obj[7] + 1) --元素透明度逐渐增加
			elseif d<6 and d>-6 then
				obj[7] = max(0  , obj[7] - 1)
			end
			_d = (_A*x0 + _B*z0)/_m
			if _d > self.range or _d < -self.range then
				table.remove(self.objs, i) --背景元素出界了就直接删除
			end
			obj[1] = obj[1] + self.bg_speed*_A
			obj[3] = obj[3] + self.bg_speed*_B
			for j = 1, 4 do
				obj[6][j][1] = obj[6][j][1] + self.bg_speed*_A
				obj[6][j][3] = obj[6][j][3] + self.bg_speed*_B
			end
		end

		self.bg_dist = self.bg_dist + self.bg_speed --往背景运动的方向增加

		if self.bg_dist >= self.bg_dist_max and self.timer <= (dt + 200) and not self.IsBoss then --如果最后成生的元素与生成的距离超过了3，就再更远处生成一个
			local dx = 3 + ran:Float(-1, 1) --生成时偏离中心多少
			local xyz = {-self.range*_A - dx*_B*self.pos, -3, -self.range*_B + dx*_A*self.pos}
			local img
			local p
			local rot = Get_Opposite_Vector(self.eye_rot) --让每个面生成时的朝向都与视线朝向完全相反
			for i = 1, 2 do
				if n%20 == 0 or n%20 == 10 then  --选择渲染云还是山
					--if n%_n == 0  then  --选择渲染云还是山(这里是伪随机生成算法)
					dx = 3 + ran:Float(-1, 2) + 6*(i - 1)
					xyz = {-self.range*_A - dx*_B*self.pos, -2.75, -self.range*_B + dx*_A*self.pos}
					img = self.imgs[ran:Int(4, 5)]
					p = Get_Four_Points(xyz[1], xyz[2], xyz[3], img[2], img[3], rot)
					obj = {xyz[1], xyz[2], xyz[3], img[1], rot, p, 0, 255}
					table.insert(self.objs, 1, obj)
				else
					dx = 4 + ran:Float(-1, 1) + 8*(i - 1)
					xyz = {-(self.range)*_A - dx*_B*self.pos, -3, -(self.range)*_B + dx*_A*self.pos}
					img = self.imgs[ran:Int(1, 3)]
					p = Get_Four_Points(xyz[1], xyz[2], xyz[3], img[2], img[3], rot)
					obj = {xyz[1], xyz[2], xyz[3], img[1], rot, p, 0, 100}
					table.insert(self.objs, 1, obj)

					dx = 3 + ran:Float(-1, 1) + 6*(i - 1)
					xyz = {-self.range*_A - dx*_B*self.pos, -3, -self.range*_B + dx*_A*self.pos}
					img = self.imgs[ran:Int(1, 3)]
					p = Get_Four_Points(xyz[1], xyz[2], xyz[3], img[2], img[3], rot)
					obj = {xyz[1], xyz[2], xyz[3], img[1], rot, p, 0, 50}
					table.insert(self.objs, 1, obj)
				end
			end

			self.bg_dist = self.bg_dist - self.bg_dist_max --当然，要减回来的
			self.pos = -self.pos --使下一个元素生成在另一侧
		end

		--以下当视线或者摄像机中心发生变化时触发
		if not Vector_Equal(self.last_eye_position, self.eye_position) then --判断摄像机的位置是否有变化
			if not Vector_Equal(self.last_eye_rot_ab, self.eye_rot_ab) then --依旧需要补充判断一下视线是否改变
				self.eye_rot = {sin(self.eye_rot_ab[1])*cos(self.eye_rot_ab[2]), cos(self.eye_rot_ab[1]), sin(self.eye_rot_ab[1])*sin(self.eye_rot_ab[2])} --更新视角向量
				BG.Change_obj_rot(self) --更新一下需要一直与视线垂直的面的朝向
				self.last_eye_rot_ab[1] = self.eye_rot_ab[1]
				self.last_eye_rot_ab[2] = self.eye_rot_ab[2]
			end
			Set3D('at'  , self.eye_position[1] + self.eye_rot[1], self.eye_position[2] + self.eye_rot[2], self.eye_position[3] + self.eye_rot[3]) --更新一下视角
			Set3D('eye' , self.eye_position[1], self.eye_position[2], self.eye_position[3]) --更新一下视野中心
			self.last_eye_position[1] = self.eye_position[1]
			self.last_eye_position[2] = self.eye_position[2]
			self.last_eye_position[3] = self.eye_position[3]
		elseif not Vector_Equal(self.last_eye_rot_ab, self.eye_rot_ab) then --判断视线是否改变
			self.eye_rot = {sin(self.eye_rot_ab[1])*cos(self.eye_rot_ab[2]), cos(self.eye_rot_ab[1]), sin(self.eye_rot_ab[1])*sin(self.eye_rot_ab[2])} --更新视角向量
			Set3D('at'  , self.eye_position[1] + self.eye_rot[1], self.eye_position[2] + self.eye_rot[2], self.eye_position[3] + self.eye_rot[3]) --更新一下视角
			BG.Change_obj_rot(self) --更新一下需要一直与视线垂直的面的朝向
			self.last_eye_rot_ab[1] = self.eye_rot_ab[1]
			self.last_eye_rot_ab[2] = self.eye_rot_ab[2]
		end

		--当背景方向参数被改时触发
		if not Vector_Equal(self.last_bg_rot_ab, self.bg_rot_ab) then
			self.bg_rot = {sin(self.bg_rot_ab[1])*cos(self.bg_rot_ab[2]), cos(self.bg_rot_ab[1]), sin(self.bg_rot_ab[1])*sin(self.bg_rot_ab[2])} --背景前进的方向的法向量(其反方向也是生成背景元素的方向)
			self.last_bg_rot_ab[1] = self.bg_rot_ab[1]
			self.last_bg_rot_ab[2] = self.bg_rot_ab[2]
		end

		--环状云的旋转
		local s = self.c_cloud
		local h, w = 0.5*s.height, 0.5*s.width
		local r = sqrt(h*h + w*w)
		local x, y, z = s.x, s.y, s.z
		local rot = self.timer/6
		local dx, dy
		for i = 1, 4 do
			dx, dy = r*cos(225 - 90*i), r*sin(225 - 90*i)
			s.p[i][1] = x + dx*cos(rot) - dy*sin(rot)
			s.p[i][2] = y + dx*sin(rot) + dy*cos(rot)
			s.p[i][3] = z
		end

		if IsValid(_boss) and (_boss.cards[_boss.card_num] and _boss.cards[_boss.card_num].is_sc) and (IsValid(_boss.sc_bg) and _boss.sc_bg.open) then --boss在符卡时间时岛会作为符卡背景的一部分完全显示出来，因此把云撤去
			self.fog.alpha = max(100, self.fog.alpha - 5)
			self.cloud1.alpha = max(100, self.cloud1.alpha - 5)
			self.cloud2.alpha = max(100, self.cloud2.alpha - 5)
		else
			self.fog.alpha = min(220, self.fog.alpha + 20)
			self.cloud1.alpha = min(220, self.cloud1.alpha + 20)
			self.cloud2.alpha = min(220, self.cloud2.alpha + 20)
		end

		--道末背景靠近
		if self.timer >= (dt + 120) and not self.IsBoss then
			if self.eye_position[3] < 6 then
				self.eye_position[3] = self.eye_position[3] + 0.01
				self.bg_speed = 0.01
			else
				self.bg_speed = 0.02
			end
		end
		--道末云下降
		if self.timer > (dt + 600) and self.timer < (dt + 1100) then
			self.fog.alpha = self.fog.alpha - 0.05
			self.cloud1.y = self.cloud1.y - 0.008
			self.cloud2.y = self.cloud2.y - 0.01
			for i = 1, 4 do
				self.cloud1.p[i][2] = self.cloud1.p[i][2] - 0.008
				self.cloud2.p[i][2] = self.cloud2.p[i][2] - 0.01
			end
		end


		local _C
		_A, _B, _C = self.bg_rot[1], self.bg_rot[2], self.bg_rot[3]
		_m = sqrt(_A*_A + _B*_B + _C*_C)
		_A, _B, _C = _A/_m, _B/_m, _C/_m
		--樱花
		local a1, a2, b1, b2, db1, db2
		local angle, rot
		local v, dv
		local p
		local x, y, z, center
		if self.timer%5 == 0 then
			x, y, z = ran:Float(-15, 15), 10 + ran:Float(-2.5, 2.5), 30
			center = {x, y, z}
			a1, a2 = 125 + ran:Float(-12.5, 12.5), -90 + ran:Float(-45, 45)
			angle = {sin(a1)*cos(a2), cos(a1), sin(a1)*sin(a2)}
			v = ran:Float(0.1, 0.15)
			dv = {v*angle[1], v*angle[2], v*angle[3]}
			b1, b2, db1, db2 = ran:Float(0, 180), ran:Float(0, 360), ran:Float(3, 6)*ran:Sign(), ran:Float(3, 6)*ran:Sign()
			rot = {sin(b1)*cos(b2), cos(b1), sin(b1)*sin(b2), b1, b2, db1, db2}
			p = Get_Four_Points(x, y, z, 1.2, 1.2, rot)
			obj = {center, rot, dv, v, angle, p, 1}
			table.insert(self.sakura, 1, obj)
		end

		local i = 1
		n = #self.sakura
		while(i <= n) do
			if not self.sakura[i] then break end
			obj = self.sakura[i]
			rot = obj[2]
			v = obj[4]
			angle = obj[5]
			center = obj[1]
			dv = obj[3]
			dv[2] = dv[2] - 0.00002
			center[1] = center[1] + dv[1]
			center[2] = center[2] + dv[2]
			center[3] = center[3] + dv[3]
			for j = 1, 4 do
				obj[6][j][1] = obj[6][j][1] + dv[1]
				obj[6][j][2] = obj[6][j][2] + dv[2]
				obj[6][j][3] = obj[6][j][3] + dv[3]
			end

			--计算樱花旋转
			rot[4], rot[5] = rot[4] + rot[6], rot[5] + rot[7]
			rot[1], rot[2], rot[3] = sin(rot[4])*cos(rot[5]), cos(rot[4]), sin(rot[4])*sin(rot[5])
			obj[6] = BG.Change_Four_Points2(self, obj, rot)
			if center[1] <= -30 or center[1] >= 30 or center[2] <= -15 or center[3] <= -5 then
				if obj[7] <= 0 then
					table.remove(self.sakura, i)
					i = i - 1
				else
					obj[7] = max(0, obj[7] - 5)
				end
			else
				obj[7] = min(200, obj[7] + 5)
			end
			i = i + 1
		end
	end
end

--本关单独的渲染黑色遮障(暂时降低背景亮度，之后需要对四背景作修改
function BG:renderBlackBoard()
	local alp = 0.1
	if alp < 1 then
		SetImageState("white", "", Color(255*alp, 0, 0, 0))
		Render4V("white", -192, 224, 0.5,
				192, 224, 0.5,
				192, -224, 0.5,
				-192, -224, 0.5
		)
		SetImageState("white", "", Color(255, 255, 255, 255)) --设回来吧，省得哪里又出了问题
	end

end
function BG:render()
	if background_open then
		background.WarpEffectCapture()
		Render("baseboard", 0, 0, 0, 1)
		SetViewMode'3d'
		local s, p
		for i = 1, #self.big_objs do  --先按顺序渲染大的背景物
			s = self.big_objs[i]
			p = s.p
			SetImageState(s.img, s.blend, Color(s.alpha, 255, 255, 255))
			Render4V(s.img,    p[1][1], p[1][2], p[1][3],
					p[2][1], p[2][2], p[2][3],
					p[3][1], p[3][2], p[3][3],
					p[4][1], p[4][2], p[4][3])
		end

		local obj
		for i = 1, #self.objs do
			obj = self.objs[i]
			SetImageState(obj[4], "", Color(obj[7], 255, 255, 255))
			p = obj[6]
			Render4V(obj[4], p[1][1], p[1][2], p[1][3],
					p[2][1], p[2][2], p[2][3],
					p[3][1], p[3][2], p[3][3],
					p[4][1], p[4][2], p[4][3])
		end

		for i = 1, #self.sakura do
			obj = self.sakura[i]
			SetImageState("s4_sakura", "", Color(obj[7], 255, 255, 255))
			p = obj[6]
			Render4V("s4_sakura", p[1][1], p[1][2], p[1][3],
					p[2][1], p[2][2], p[2][3],
					p[3][1], p[3][2], p[3][3],
					p[4][1], p[4][2], p[4][3])
		end

		SetViewMode'world'

		Render("s4_polar1", 0, -180, 0, 1)
		Render("s4_polar2", 0, -40, 0, 1)
		Render("s4_high_cloud", -100, 100, 0, 1)
		Render("s4_high_cloud",  100, 100, 0, 1)
		background.WarpEffectApply()
		BG.renderBlackBoard(self)
		eggbg.baseBG.renderBlackBoard(self)
	else
		eggbg.baseBG.renderGrayBoard()
	end
end

local cloud2d, up2d

--前两幕背景设置器
s4_bg_setter1 = Class(object)
function s4_bg_setter1:init()
	local bg  --声明局部对象背景
	if setting.background then
		bg = New(stage3_background, false, true)  --创建背景
	else
		bg = New(stage4_background, false)  --创建背景
	end

	self._lock = false
	self._eye = {0,0,0} --设置默认参数
	self._at = {0,0,0}
	self._up = {0,0,0}
	self._z = {0,0}
	self._fovy = {0}
	self._fog = {0,0,0,0,0,0}
	self._eye0 = {0,4.6,-4.9} --设置默认参数
	self._at0 = {0,2.9,-0.5}
	self._up0 = {0.00,0.00,0.50}
	self._z0 = {0.1,50.00}
	self._fovy0 = {1.5}
	self._fog0 = {15,45,255,20,30,60}
	self.pos = {1,1}
	self.bg_table = {self._eye, self._at,  self._up, self._z, self._fovy, self._fog}
	self.bg_table0 = {self._eye0, self._at0,  self._up0, self._z0, self._fovy0, self._fog0}
	self._bg_table = {"eye", "at",  "up", "z", "fovy", "fog"}
	--初始设置
	local b = self.bg_table
	local up = player.x*0.006/384
	Set3D('eye',self._eye0[1] + 0.1*b[1][1], self._eye0[2] + 0.1*b[1][2] , self._eye0[3] + 0.1*b[1][3])
	Set3D('at',self._at0[1] + 0.1*b[2][1], self._at0[2] + 0.1*b[2][2], self._at0[3] + 0.1*b[2][3])
	Set3D('up', self._up0[1] + 0.1*b[3][1] + up, self._up0[2] + 0.1*b[3][2], self._up0[3] + 0.1*b[3][3])
	Set3D('z',self._z0[1] + 0.1*b[4][1], self._z0[2] + 0.1*b[4][2])
	Set3D('fovy',self._fovy0[1] + 0.1*b[5][1])
	Set3D('fog',self._fog0[1] + 0.1*b[6][1], self._fog0[2] + 0.1*b[6][2], Color(self._fog0[3] + b[6][3],self._fog0[4] + b[6][4],self._fog0[5] + b[6][5],self._fog0[6] + b[6][6]))
	task.New(self,function()
		local f0 = {self._fog0[1], self._fog0[2], self._fog0[3], self._fog0[4], self._fog0[5], self._fog0[6]}
		self._fog0[1] = -65.9
		self._fog0[2] = 228.1
		self._fog0[4] = 255
		self._fog0[5] = 255
		self._fog0[6] = 180
		do local x,_d_x=(0),(1/359) for _=1,360 do
			Set3D('fog',f0[1] + (self._fog0[1] - f0[1])*x,
					f0[2] + (self._fog0[2] - f0[2])*x,
					Color(f0[3] + (self._fog0[3] - f0[3])*x,
							f0[4] + (self._fog0[4] - f0[4])*x,
							f0[5] + (self._fog0[5] - f0[5])*x,
							f0[6] + (self._fog0[6] - f0[6])*x))
			task._Wait(1)
			x=x+_d_x end end
		local f0 = {self._fog0[1], self._fog0[2], self._fog0[3], self._fog0[4], self._fog0[5], self._fog0[6]}
		self._fog0[2] = 100
		local e0 = {self._eye0[1], self._eye0[2], self._eye0[3]}
		self._eye0[2] = 10.5
		self._eye0[3] = -12.3
		local a0 = {self._at0[1], self._at0[2], self._at0[3]}
		self._at0[2] = 9.2
		self._at0[3] = -7.9
		do local x,_d_x=(0),(1/539) for _=1,540 do
			Set3D('fog',f0[1] + (self._fog0[1] - f0[1])*x,
					f0[2] + (self._fog0[2] - f0[2])*x,
					Color(f0[3] + (self._fog0[3] - f0[3])*x,
							f0[4] + (self._fog0[4] - f0[4])*x,
							f0[5] + (self._fog0[5] - f0[5])*x,
							f0[6] + (self._fog0[6] - f0[6])*x))
			Set3D('eye', e0[1] + (self._eye0[1] - e0[1])*x,
					e0[2] + (self._eye0[2] - e0[2])*x,
					e0[3] + (self._eye0[3] - e0[3])*x)
			Set3D('at', a0[1] + (self._at0[1] - a0[1])*x,
					a0[2] + (self._at0[2] - a0[2])*x,
					a0[3] + (self._at0[3] - a0[3])*x)
			task._Wait(1)
			x=x+_d_x end end
		local f0 = {self._fog0[1], self._fog0[2], self._fog0[3], self._fog0[4], self._fog0[5], self._fog0[6]}
		self._fog0[2] = 0
		self._fog0[4] = 200
		self._fog0[5] = 200
		self._fog0[6] = 200
		do local x,_d_x=(0),(1/359) for _=1,360 do
			Set3D('fog',f0[1] + (self._fog0[1] - f0[1])*x,
					f0[2] + (self._fog0[2] - f0[2])*x,
					Color(f0[3] + (self._fog0[3] - f0[3])*x,
							f0[4] + (self._fog0[4] - f0[4])*x,
							f0[5] + (self._fog0[5] - f0[5])*x,
							f0[6] + (self._fog0[6] - f0[6])*x))
			task._Wait(1)
			x=x+_d_x end end
		task._Wait(590)
		New(s4_bg_setter2)
	end)
	task.New(self,function()
		task._Wait(900)
		task.New(self,function()
			task._Wait(700)
			last=New(up2d,self.x,self.y,_)
			task._Wait(240)
			if IsValid(bg) then Del(bg) end
			local frame = 10
			do local rate,_d_rate=(0.5),(0.5/9) local dv,_d_dv=(8),(-0.5) local t,_d_t=(460),(-40) for _=1,10 do
				do local size,_d_size=(2),(-0.3) local v,_d_v=(dv + ran:Float(-0.25, 0.25)),(-0.25) for _=1,4 do
					do local u,_d_u=(-1),(2) for _=1,2 do
						last=New(cloud2d,ran:Float(40, 192)*u, ran:Float(550, 600),size,rate,v,t)
						u=u+_d_u end end
					size=size+_d_size v=v+_d_v end end
				task.Wait(frame)
				rate=rate+_d_rate dv=dv+_d_dv t=t+_d_t end end
			_del(self,true)
		end)
		local frame = 120
		do local rate,_d_rate=(1),(-1/19) local dv,_d_dv=(4),(0.5) for _=1,20 do
			do local size,_d_size=(2),(-0.3) local v,_d_v=(dv + ran:Float(-0.25, 0.25)),(-0.5) for _=1,4 do
				do local u,_d_u=(-1),(2) for _=1,2 do
					last=New(cloud2d,ran:Float(40, 192)*u, ran:Float(550, 600),size,rate,v,600)
					u=u+_d_u end end
				size=size+_d_size v=v+_d_v end end
			task.Wait(frame)
			frame = max(10, frame - 12)
			rate=rate+_d_rate dv=dv+_d_dv end end
	end)
end
function s4_bg_setter1:frame()
	if background_open then
		task.Do(self)
	end
end

s4_bg_setter2 = Class(object)
function s4_bg_setter2:init()
	--[[ 创建时背景已经过了1850帧 --]]--[=[
    --]=]
	local bg  --声明局部对象背景
	bg = New(stage4_background, false)  --创建背景
	Set3D('eye' , bg.eye_position[1], bg.eye_position[2], bg.eye_position[3])
	Set3D('at'  , bg.eye_position[1] + bg.eye_rot[1], bg.eye_position[2] + bg.eye_rot[2], bg.eye_position[3] + bg.eye_rot[3]) --暂且让眼睛的视角向下约30度吧
	Set3D('up'  , 0,  0, 0.5) --三个参数都是控制整个背景旋转的，默认0,0,0.5就是正常的，一般不需要动
	Set3D('fovy',1.5) --暂且认为是全局缩放，值越大看得越远
	Set3D('z'   ,0.1,100.00) --渲染范围
	Set3D('fog' ,100,100,Color(0,255,255,175)) --雾气
	self.pos = {1,1}
	self._lock = false
	self.bg_table = {bg.eye_position, bg.eye_rot_ab, bg.bg_rot_ab}
	self.values = {{0.05, "摄像机位置"},
				   {0.25, "视角/朝向"},
		--{0.001, "背景的运动速度"},
				   {0.25, "背景的运动方向"}
	} --与上面是对应的增量参数和参数中文意义
	bg.bg_speed = 0.15
	lasttask=task.New(self,function()
		bg.eye_position[2] = -2
		bg.eye_rot_ab[1] = 135
		task._Wait(135)
		bg.bg_speed = 0
		task._Wait(105)
		do local x,_d_x=(0),(90/179) for _=1,180 do
			bg.eye_position[2] = -2 + (5 + 2)*sin(x)
			task._Wait(1)
			x=x+_d_x end end
		local x, dx, dx2 = 0, 0.9/90, 0.1/20
		local rate
		do local t,_d_t=(1),(1) for _=1,440 do
			if (t <= 110 or t >= 330) then
				if(t <= 90 or t >= 350) then
					x = x + dx
				else
					x = x + dx2
				end
				rate = 0.5*(1-cos(180*x))--丝滑变化曲线(慢快慢),x定义域为0到1时, 取值范围 0-1
				bg.eye_rot_ab[1] = 135 - 10*rate
			else
				if(t >= 130 and t <= 310) then
					x = x - dx
				else
					x = x - dx2
				end
				rate = 0.5*(1-cos(180*x))--丝滑变化曲线(慢快慢),x定义域为0到1时, 取值范围 0-1
				bg.eye_rot_ab[1] = 125
			end

			if x > 0 then
				bg.eye_rot_ab[2] = 90 + 10*rate
			else
				bg.eye_rot_ab[2] = 90 - 10*rate
			end
			if x > 0 then
				bg.eye_rot_ab[2] = 90 + 10*x*x
			else
				bg.eye_rot_ab[2] = 90 - 10*x*x
			end
			task._Wait(1)
			t=t+_d_t end end
		do local x,_d_x=(0),(90/89) for _=1,90 do
			bg.eye_rot_ab[1] = 135 + 10*sin(x)
			task._Wait(1)
			x=x+_d_x end end
		do local x,_d_x=(0),(1/119) for _=1,120 do
			bg.eye_position[2] = 5 - 1*x
			bg.bg_speed = 0.02*x
			task._Wait(1)
			x=x+_d_x end end
		--[[ 以上执行完刚好到达2920帧 --]]--[=[
        --]=]
		task._Wait(100)
		do local x,_d_x=(0),(180/599) for _=1,600 do
			bg.bg_speed = 0.02 + 0.02*sin(x)
			task._Wait(1)
			x=x+_d_x end end
		task._Wait(100)
		--[[ 3720 --]]--[=[
        --]=]
		do local x,_d_x=(0),(1/359) for _=1,360 do
			rate = 0.5*(1-cos(180*x))
			--bg.bg_rot_ab[2] = -90 - 45*rate
			bg.eye_position[1] = 4*rate
			bg.eye_rot_ab[2] = 90 - 10*rate
			task._Wait(1)
			x=x+_d_x end end
		task._Wait(170)
		--[[ 4250 --]]--[=[
        --]=]
		do local x,_d_x=(1),(-1/359) for _=1,360 do
			rate = 0.5*(1-cos(180*x))
			--bg.bg_rot_ab[2] = -90 - 45*rate
			bg.eye_position[1] = 4*rate
			bg.eye_rot_ab[2] = 90 - 10*rate
			task._Wait(1)
			x=x+_d_x end end
		do local x,_d_x=(0),(1/359) for _=1,360 do
			rate = 0.5*(1-cos(180*x))
			bg.eye_position[1] = -4*rate
			bg.eye_rot_ab[2] = 90 + 10*rate
			task._Wait(1)
			x=x+_d_x end end
		do local x,_d_x=(1),(-1/359) for _=1,360 do
			rate = 0.5*(1-cos(180*x))
			bg.eye_position[1] = -4*rate
			bg.eye_rot_ab[2] = 90 + 10*rate
			task._Wait(1)
			x=x+_d_x end end
		task._Wait(250)
		--[[ 5550 --]]--[=[
        --]=]
		do local x,_d_x=(0),(1/389) for _=1,390 do
			rate = 0.5*(1-cos(180*x))
			--bg.bg_rot_ab[2] = -90 - 45*rate
			bg.eye_position[1] = -6*rate
			bg.eye_rot_ab[1] = 145 - 15*rate
			bg.eye_rot_ab[2] = 90 + 30*rate
			task._Wait(1)
			x=x+_d_x end end
		task._Wait(360)
		--[[ 6300 --]]--[=[
        --]=]
		do local x,_d_x=(0),(1/779) for _=1,780 do
			rate = 0.5*(1-cos(180*x))
			bg.eye_position[1] = -6 + 12*rate
			bg.eye_rot_ab[2] = 120 - 60*rate
			task._Wait(1)
			x=x+_d_x end end
		task._Wait(60)
		do local x,_d_x=(0),(1/389) for _=1,390 do
			rate = 0.5*(1-cos(180*x))
			bg.eye_position[1] = 6 - 6*rate
			bg.eye_rot_ab[2] = 60 + 30*rate
			task._Wait(1)
			x=x+_d_x end end
		do local x,_d_x=(0),(1/1799) for _=1,1800 do
			rate = 0.5*(1-cos(180*x))
			bg.eye_rot_ab[1] = 130 - 35*rate
			task._Wait(1)
			x=x+_d_x end end
	end)
end
function s4_bg_setter2:frame()
	if background_open then
		task.Do(self)
	end
end

stage4_background_road = s4_bg_setter1

function bossbg(self)
	Set3D('eye' , self.eye_position[1], self.eye_position[2], self.eye_position[3])
	Set3D('at'  , self.eye_position[1] + self.eye_rot[1], self.eye_position[2] + self.eye_rot[2], self.eye_position[3] + self.eye_rot[3]) --暂且让眼睛的视角向下约30度吧
	Set3D('up'  , 0,  0, 0.5) --三个参数都是控制整个背景旋转的，默认0,0,0.5就是正常的，一般不需要动
	Set3D('fovy',1.5) --暂且认为是全局缩放，值越大看得越远
	Set3D('z'   ,0.1,100.00) --渲染范围
	Set3D('fog' ,100,100,Color(0,255,255,175)) --雾气
	self.IsBoss = true
	self.bg_speed = 0.15
	task.New(self,function()
		self.eye_position[2] = -2
		self.eye_rot_ab[1] = 135
		self.bg_speed = 0
		self.eye_position[2] = 5
		local x, dx, dx2 = 0, 0.9/45, 0.1/10
		local rate
		do local t,_d_t=(1),(1) for _=1,220 do
			if (t <= 55 or t >= 165) then
				if(t <= 45 or t >= 175) then
					x = x + dx
				else
					x = x + dx2
				end
				rate = 0.5*(1-cos(180*x))--丝滑变化曲线(慢快慢),x定义域为0到1时, 取值范围 0-1
				self.eye_rot_ab[1] = 135 - 10*rate
			else
				if(t >= 65 and t <= 155) then
					x = x - dx
				else
					x = x - dx2
				end
				rate = 0.5*(1-cos(180*x))--丝滑变化曲线(慢快慢),x定义域为0到1时, 取值范围 0-1
				self.eye_rot_ab[1] = 125
			end

			if x > 0 then
				self.eye_rot_ab[2] = 90 + 10*rate
			else
				self.eye_rot_ab[2] = 90 - 10*rate
			end
			if x > 0 then
				self.eye_rot_ab[2] = 90 + 10*x*x
			else
				self.eye_rot_ab[2] = 90 - 10*x*x
			end
			t=t+_d_t end end
		self.eye_rot_ab[1] = 145
		self.eye_position[2] = 4
		self.bg_speed = 0.02

		self.eye_position[1] = 0
		self.eye_rot_ab[2] = 90
		--[[ 5550 --]]--[=[
        --]=]
		self.eye_position[1] = -6
		self.eye_rot_ab[1] = 130
		self.eye_rot_ab[2] = 120
		--[[ 6300 --]]--[=[
        --]=]
		self.eye_position[1] = 0
		self.eye_rot_ab[2] = 90
		self.eye_rot_ab[1] = 95
		--[[  --]]--[=[
        --]=]
		self.bg_speed = 0.2
		task.Wait(60)
		self.bg_speed = 0
	end)
end


--背景显示物
do
	cloud2d=Class(_object)
	cloud2d.init=function(self,_x,_y,size, rate, v, t)
		self.x,self.y=_x,_y
		self.img="s4_cloud1"
		self.layer=LAYER_BG+2
		self.group=GROUP_GHOST
		self.hide=false
		self.bound=true
		self.navi=false
		self.hp=10
		self.maxhp=10
		self.colli=true
		self._servants={}
		self._blend,self._a,self._r,self._g,self._b='',255,255,255,255
		self.rot = ran:Float(0, 360)
		self.omiga = ran:Float(0, 0.15)
		self.bound = false
		local _r, _g, _b = 100 + 155*rate, 100 + 155*rate, 155 + 100*rate
		_object.set_color(self,"",255,_r,_g,_b)
		self.hscale, self.vscale = size, size
		SetV2(self,v,-90,false,false)
		lasttask=task.New(self,function()
			task._Wait(t)
			if (self.x <= 0) then
				AddSimStrChV(self, 0, 3, 180, 20)
			else
				AddSimStrChV(self, 0, 3, 0, 20)
			end
			AddSimStrChV(self, 0, v, 90, 45)
			task._Wait(90)
			do local x,_d_x=(1),(-1/89) for _=1,90 do
				_object.set_color(self,"",255*x,_r,_g,_b)
				task._Wait(1)
				x=x+_d_x end end
			_del(self,false)
		end)
	end
	up2d=Class(_object)
	up2d.init=function(self,_x,_y,_)
		self.x,self.y=_x,_y
		self.img="img_void"
		self.layer=LAYER_BG+1
		self.group=GROUP_GHOST
		self.hide=false
		self.bound=false
		self.navi=false
		self.hp=10
		self.maxhp=10
		self.colli=true
		self._servants={}
		self._blend,self._a,self._r,self._g,self._b='',255,255,255,255
		self.w, self.h = GetTextureSize("s4_fly_up1")
		self.w, self.h = 0.5*self.w, 0.5*self.h  --由于祈华梦素材默认缩小0.5，所以在与实际坐标对应时需要除以二
		--self.count_x = int(384/self.w) + 1   --横向平铺数
		--self.count_x = 1   --特异性的横向平铺数
		self.count_y = int(448/self.h) + 2  --纵向平铺数
		self.y1 = -224 + 0.5*self.h
		self.y2 = -224 + 0.5*self.h
		self.alp1 = 0
		self.alp2 = 0  --两层深蓝色云透明度

		self.alp3 = 0
		self.alp4 = 0  --两层淡黄色云透明度
	end
	up2d.frame=function(self)
		self.class.base.frame(self)
		self.y1 = self.y1 - 12
		self.y2 = self.y2 - 6
		if self.y1 <= -224 - 0.5*self.h then self.y1 = self.y1 + self.h end
		if self.y2 <= -224 - 0.5*self.h then self.y2 = self.y2 + self.h end

		if self.timer <= 240 then
			self.alp1 = min(255, self.alp1 + 4)
			self.alp2 = min(150, self.alp2 + 4)
		elseif self.timer > 240 and self.timer<= 420 then
			self.alp1 = max(0, self.alp1 - 2)
			self.alp2 = max(0, self.alp2 - 2)
			self.alp3 = min(255, self.alp3 + 2)
			self.alp4 = min(150, self.alp4 + 2)
		elseif self.timer > 420 and self.timer <480 then
			self.alp3 = max(0, self.alp3 - 4)
			self.alp4 = max(0, self.alp4 - 4)
		elseif self.timer > 480 then
			Del(self)
		end
	end
	up2d.render=function(self)
		self.class.base.render(self)
		SetImageState("s4_fly_up1", "", Color(self.alp1, 255, 255, 255))
		SetImageState("s4_fly_up2", "", Color(self.alp3, 255, 255, 255))   --渲染里层云层
		local dy = 0
		for _ = 1, self.count_y do
			Render("s4_fly_up1", 0, self.y1 + dy, 0, 1)
			Render("s4_fly_up2", 0, self.y1 + dy, 0, 1)
			dy = dy + self.h
		end

		dy = 0
		SetImageState("s4_fly_up1", "", Color(self.alp2, 255, 255, 255))
		SetImageState("s4_fly_up2", "", Color(self.alp4, 255, 255, 255))  --渲染外层云层
		for _ = 1, self.count_y do
			Render("s4_fly_up1", 0, self.y2 + dy, 0, 1)
			Render("s4_fly_up2", 0, self.y2 + dy, 0, 1)
			dy = dy + self.h
		end
	end
end


----------------------------------------]]
---导出定义

stage4_background = BG
