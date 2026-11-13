---======================================
---祈华梦六面背景
---by S7UPID
---======================================

local background_open = setting.background --背景开关选项
local ran = lstg.Rand()

local path = "res/background/stage6/"
--local path = ""
--res
--六面背景素材加载
local function load_res_s5()
	local path = "res/background/stage5/"
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
end
local function load_res()
	load_res_s5()
    LoadImageFromFile("s6_air1", path .. "s6_air1.png")
	LoadImageFromFile("s6_air2", path .. "s6_air2.png")
	LoadImageFromFile("s6_baseboard", path .. "s6_baseboard.png")
	LoadImageFromFile("s6_cloud", path .. "s6_cloud.png")
	LoadImageFromFile("s6_flashlight", path .. "s6_flashlight.png")
	LoadImageFromFile("s6_moutain1", path .. "s6_moutain1.png")
	LoadImageFromFile("s6_moutain2", path .. "s6_moutain2.png")
	LoadImageFromFile("s6_tree0", path .. "s6_tree0.png")
	LoadImageFromFile("s6_tree1", path .. "s6_tree1.png")
	LoadImageFromFile("s6_tree2", path .. "s6_tree2.png")
	LoadImageFromFile("s6_tree3", path .. "s6_tree3.png")
	LoadImageFromFile("s6_tree4", path .. "s6_tree4.png")
	LoadImageFromFile("s6_waterflash", path .. "s6_waterflash.png")
	LoadImageFromFile("s6_snow", path .. "s6_snow.png")
	--boss场景
	LoadImageFromFile("s6_river", path .. "s6_river.png")
	LoadImageFromFile("s6_stone1", path .. "s6_stone1.png")
	LoadImageFromFile("s6_stone2", path .. "s6_stone2.png")
	LoadImageFromFile("s6_small_stone1", path .. "s6_small_stone1.png")
	LoadImageFromFile("s6_small_stone2", path .. "s6_small_stone2.png")
	LoadImageFromFile("s6_small_stone3", path .. "s6_small_stone3.png")
	LoadImageFromFile("s6_waterwaveinline", path .. "s6_waterwaveinline.png")
	LoadImageFromFile("s6_waterwave", path .. "s6_waterwave.png")
	--瀑布远景（帧动画）
	for i = 1, 14 do
		LoadImageFromFile("s6_falls"..i, path.."s6_falls"..i..".png")
	end
	--大瀑布
	LoadImageFromFile("s6_fall_board", path .. "s6_fall_board.png")
	LoadImageFromFile("s6_fall_water", path .. "s6_fall_water.png")
	LoadImageFromFile("s6_fall_stone1", path .. "s6_fall_stone1.png")
	LoadImageFromFile("s6_fall_stone2", path .. "s6_fall_stone2.png")
	LoadImageFromFile("s6_fall_stone3", path .. "s6_fall_stone3.png")
	--boss幕3树叶
	LoadImageFromFile("s6_leaf", path .. "s6_leaf.png")
end
--load_res() -- 资源加载写在init里面

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
do
	local function default(self)
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
		self.z = {0.1, 100}
		--对应于set3d的fog
		self.fog = {0, 30, 255, 225*0.9, 255*0.9, 255*0.9}
		Set3D('eye' , self.eye_pos[1], self.eye_pos[2], self.eye_pos[3])
		Set3D('at'  , self.eye_pos[1] + self.eye_rot3[1], self.eye_pos[2] + self.eye_rot3[2], self.eye_pos[3] + self.eye_rot3[3]) --暂且让眼睛的视角向下约30度吧
		Set3D('up'  , self.up[1],  self.up[2], self.up[3]) --三个参数都是控制整个背景旋转的，默认0,0,0.5就是正常的，一般不需要动
		Set3D('fovy',self.fovy[1]) --暂且认为是全局缩放，值越大看得越远
		Set3D('z'   ,self.z[1],self.z[2]) --渲染范围
		Set3D('fog' ,self.fog[1],self.fog[2],Color(self.fog[3],self.fog[4],self.fog[5],self.fog[6])) --雾气
		self.sakura = {}--飘到脸上的樱花
		self.static = {}
		self.trees = {} --树对象
		self.top = {} --最高层渲染
		self.trees = {}  --树
		self.roads = {} --道路
		self.treev = -0.05
		self.static2dfont = {}
		self.static2drear = {}
	end
	function BG:setDefault()
		--加载背景纹理
		do
			eggbg.baseBG.addToImg(self, "sakura", "s4_sakura", 1.2, 1.2)
			eggbg.baseBG.addToImg(self, "snow", "s6_snow", 1.2, 1.2)
			eggbg.baseBG.addToImg(self, "sakura2", "s4_sakura", 2.4, 2.4)
			eggbg.baseBG.addToImg(self, "s5_light", "s5_light", 90, 70)
			eggbg.baseBG.addToImg(self, "c_cloud", "s4_circle_cloud", 120, 120)
			eggbg.baseBG.addToImg(self, "s5_Island3", "s5_Island3", 77, 48)
			eggbg.baseBG.addToImg(self, "s5_Island_cloud", "s5_Island_cloud", 77, 36)
			eggbg.baseBG.addToImg(self, "s5_sun", "s5_sun", 120, 120)
			eggbg.baseBG.addToImg(self, "s5_roads", "s5_roads", 21.6, 5)
			eggbg.baseBG.addToImg(self, "s5_line", "s5_line", 40, 40)
			eggbg.baseBG.addToImg(self, "s5_torii", "s5_torii", 13, 13/1.19)
			eggbg.baseBG.addToImg(self, "s5_big_tree", "s5_tree3", 30, 40)
			eggbg.baseBG.addToImg(self, "s5_huge_tree", "s5_tree2", 60, 70)
			eggbg.baseBG.addToImg(self, "s5_huge_tree2", "s5_tree1", 60, 70)
			eggbg.baseBG.addToImg(self, "s4_cloud1", "s4_cloud1", 30, 25)
			eggbg.baseBG.addToImg(self, "s4_cloud2", "s4_cloud2", 30, 25)
			eggbg.baseBG.addToImg(self, "tree1", "s6_tree0", 20, 20)
			eggbg.baseBG.addToImg(self, "tree2", "s6_tree0", 20, 20)
			eggbg.baseBG.addToImg(self, "tree3", "s6_tree0", 10, 10)
			eggbg.baseBG.addToImg(self, "tree4", "s6_tree0", 8, 8)
			eggbg.baseBG.addToImg(self, "tree5", "s6_tree0", 15, 15)
			eggbg.baseBG.addToImg(self, "tree6", "s6_tree0", 15, 15)
			eggbg.baseBG.addToImg(self, "huge_light", "s5_light", 40, 20)
			eggbg.baseBG.addToImg(self, "air1", "s6_air1", 0.5, 4.5)
			eggbg.baseBG.addToImg(self, "air2", "s6_air2", 0.5, 4.5)
			--boss
			eggbg.baseBG.addToImg(self, "s6_river", "s6_river", 12, 10)
			eggbg.baseBG.addToImg(self, "s6_waterwave", "s6_waterwave", 12, 10)
			eggbg.baseBG.addToImg(self, "s6_waterwaveinline", "s6_waterwaveinline", 12, 60)
			eggbg.baseBG.addToImg(self, "stone1", "s6_stone1", 20, 15)
			eggbg.baseBG.addToImg(self, "stone2", "s6_stone2", 20, 12)
			eggbg.baseBG.addToImg(self, "falls", "s6_falls1", 65, 31.5)
			eggbg.baseBG.addToImg(self, "small_stone1", "s6_small_stone1", 3, 1)
			eggbg.baseBG.addToImg(self, "small_stone2", "s6_small_stone2", 3, 1)
			eggbg.baseBG.addToImg(self, "small_stone3", "s6_small_stone3", 3, 1)
			--瀑布
			eggbg.baseBG.addToImg(self, "s6_fall_board", "s6_fall_board", 40, 30)
			eggbg.baseBG.addToImg(self, "s6_fall_water", "s6_fall_water", 30, 30)
			eggbg.baseBG.addToImg(self, "s6_fall_water2", "s6_fall_water", -30, 30)
			--瀑布上的石头
			eggbg.baseBG.addToImg(self, "s6_fall_stone1", "s6_fall_stone1", 4, 5.5)
			eggbg.baseBG.addToImg(self, "s6_fall_stone2", "s6_fall_stone2", 4, 4)
			eggbg.baseBG.addToImg(self, "s6_fall_stone3", "s6_fall_stone3", 4, 4)
			--最终场景
			eggbg.baseBG.addToImg(self, "s6_baseboard", "s6_baseboard", 76, 89)
			eggbg.baseBG.addToImg(self, "s6_moutain1", "s6_moutain1", 76*0.25, 37*0.25)
			eggbg.baseBG.addToImg(self, "s6_moutain2", "s6_moutain2", 76*0.5, 40*0.5)
			eggbg.baseBG.addToImg(self, "s6_cloud", "s6_cloud", -85*0.5, 45*0.5)
			eggbg.baseBG.addToImg(self, "s4_high_cloud", "s4_high_cloud", 76*0.45, 76/2.2*0.45)
			eggbg.baseBG.addToImg(self, "s4_polar1", "s4_polar1", 76*0.45, 76/2.2*0.45)
			eggbg.baseBG.addToImg(self, "s4_polar2", "s4_polar2", 76*0.45, 76/2.2*0.45)
			eggbg.baseBG.addToImg(self, "leaf", "s6_leaf", 1.2, 1.2)
		end

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
		self.z = {0.1, 100}
		--对应于set3d的fog
		self.fog = {0, 30, 255, 225*0.9, 255*0.9, 255*0.9}
		Set3D('eye' , self.eye_pos[1], self.eye_pos[2], self.eye_pos[3])
		Set3D('at'  , self.eye_pos[1] + self.eye_rot3[1], self.eye_pos[2] + self.eye_rot3[2], self.eye_pos[3] + self.eye_rot3[3]) --暂且让眼睛的视角向下约30度吧
		Set3D('up'  , self.up[1],  self.up[2], self.up[3]) --三个参数都是控制整个背景旋转的，默认0,0,0.5就是正常的，一般不需要动
		Set3D('fovy',self.fovy[1]) --暂且认为是全局缩放，值越大看得越远
		Set3D('z'   ,self.z[1],self.z[2]) --渲染范围
		Set3D('fog' ,self.fog[1],self.fog[2],Color(self.fog[3],self.fog[4],self.fog[5],self.fog[6])) --雾气
		self.sakura = {}--飘到脸上的樱花
		self.trees = {} --树对象
		self.top = {} --最高层渲染
		self.trees = {}  --树
		self.roads = {} --道路
		self.rivers = nil --河
		self.real_fall = {} --大瀑布
		self.fallv = -0.2
		self.treev = -0.05
		self.boss_sence = 1 --boss场景参数(道中和第一幕均为默认的1
	end
	--把视野中心重新设置成默认的初始值
	function BG:refreshEyeCen()
		eggbg.baseBG.setEyeCen(self, 0, 4, 6)
		eggbg.baseBG.updateEyeCen(self, 0, 0, 0)
	end
	--一阶段参拜道
	function BG:Sence1()
		self.timer = 0
		--SystemLog("sence4"..self.timer)
		BG.refreshEyeCen(self)
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
			--self.c_cloud = eggbg.baseBG.creatStaticObj(self, "c_cloud", x, y, z + 50, {90, -90}, "mul+add", 20)
		end
		--岛的远景部分
		do
			eggbg.baseBG.creatStaticObj(self, "s5_Island3", x, y + 5, z + 45, {110, -90}, "", 255)
		end
		local v, t = 0.025, 1 --速度
		self.treev = -v --统一树和鸟居的运动
		--道路部分
		do
			self.roads = eggbg.baseBG.creatAccDecConObj(self, "s5_roads", "", 255, x, y, z, {180, 90}, 8, 0, {90, -90}, t, 999999, 60, 5)
		end
		--两边拿树的纹理来铺地板2333
		do
			local road = eggbg.baseBG.opCreatAccDecConObj(self, "s5_big_tree", "", 200, x - 20, y, z + 5, {180, 90}, 8, 0, {90, -90}, 1, 99999, 60, 5)
			for i = 1, #road do
				table.insert(self.roads, road[i])
			end
			local road = eggbg.baseBG.opCreatAccDecConObj(self, "s5_big_tree", "", 200, x + 20, y, z + 5, {0, 90}, 8, 0, {90, -90}, 1, 99999, 60, 5)
			for i = 1, #road do
				table.insert(self.roads, road[i])
			end
		end
		eggbg.baseBG.creatStaticObj(self, "s5_line", x, y, z + 50, {180, 90}, "", 255)
		--岛上空的拼接云
		do
			eggbg.baseBG.creatAccDecConObj(self, "s5_Island_cloud", "", 255, x, y + 40, z + 50, {90, -90}, 2, 0.5, {90, 0}, 1, 99999, 60, 77)
		end
		--[[鸟居
		do
			for i = 1, 2 do
				BG.creatTreesObj(self, "s5_torii", x, y + 5, z + 15*(i-1), {90, -90}, "", 255)
			end
			--eggbg.baseBG.opCreatAccDecConObj(self, "s5_torii", "", 255, x, y + 6, z, {90, -90}, 4, v, {90, -90}, 1, 1500, 60, 12.5)
		end]]
		--树
		do
			for i = 1, 5 do
				BG.creatTreesObj(self, "tree4", x - 4, y + 3, z + 6*(i-1), {85, -90}, "", 255, true)
				BG.creatTreesObj(self, "tree5", x - 8, y + 6.5, z + 6*(i-1)+2, {85, -90}, "", 255, true)
				BG.creatTreesObj(self, "tree1", x - 10, y + 9, z + 6*(i-1)+4, {85, -90}, "", 255, true)
				BG.creatTreesObj(self, "tree3", x + 4.5, y + 4, z + 6*(i-1), {85, -90}, "", 255, true)
				BG.creatTreesObj(self, "tree6", x + 6, y + 6.5, z + 6*(i-1)+2, {85, -90}, "", 255, true)
				BG.creatTreesObj(self, "tree2", x + 8, y + 9, z + 6*(i-1)+4, {85, -90}, "", 255, true)
			end
		end
		eggbg.baseBG.creatAccDecConObj(self, "s5_light", "mul+add", 150, x, y, z - 15, {110, -90}, 3, 0.5, {20, -90}, 0, 0, 0, 30)
		--背景变化
		do
			eggbg.baseBG.setEyeCen(self, 0, 4, 6)
			eggbg.baseBG.updateEyeCen(self, 0, 0, 0)
			eggbg.baseBG.setEyeRot(self, 95, 90)
			--eggbg.baseBG.changeFogRange0To(self, 40, 240)
			task.New(self, function()
				task.Wait(3000)
				BG.change1(self)
				task.Wait(2500) --5500
				BG.change2(self)
				task.Wait(2930) --8500
				BG.change3(self)
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
			eggbg.baseBG.updateObjAlp(self, obj, 10)
			if eggbg.baseBG.getObjAlp(self, obj) >= 255 then
				eggbg.baseBG.setObjAlp(self, obj, 255)
			end
			if obj[3][3] < 0 then
				table.insert(back, obj)
				eggbg.baseBG.updateObjPos(self, obj, 0, 0, 30)
				eggbg.baseBG.setObjAlp(self, obj, 0)
			end
		end
		for i = 1, #back do
			table.remove(self.trees)
			table.insert(self.trees, 1, back[i])
		end
		--道路只要同步就行了
		for i = 1, #self.roads do
			obj = self.roads[i]
			eggbg.baseBG.updateObjPos(self, obj, 0, 0, self.treev)
			if obj[3][3] < 0 then
				eggbg.baseBG.updateObjPos(self, obj, 0, 0, 40)
				--eggbg.baseBG.setObjAlp(self, obj, 0)
			end
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
	--瀑布渲染
	function BG:fall_frame()
		if self.fall then
			self.fall[1][1] = "s6_falls"..(self.timer%14+1)
		end
	end
	function BG:fall_render()
		SetViewMode'3d'
		local obj, img, p
		obj = self.fall
		if obj then
			img = obj[1][1]
			p = obj[2]
			SetImageState(img, obj[1][2], Color(obj[1][3], 255, 255, 255))
			Set3D('fog' ,100, 100, Color(0, 0, 0, 0))
			SetViewMode'3d'
			Render4V(img,    p[1][1], p[1][2], p[1][3],
					p[2][1], p[2][2], p[2][3],
					p[3][1], p[3][2], p[3][3],
					p[4][1], p[4][2], p[4][3])
			Set3D('fog' ,self.fog[1],self.fog[2],Color(self.fog[3],self.fog[4],self.fog[5],self.fog[6]))
		end
		SetViewMode'world'
	end
	--大瀑布
	function BG:real_fall_frame()
		local obj
		for i = 1, #self.real_fall do
			obj = self.real_fall[i]
			eggbg.baseBG.updateObjPos(self, obj, 0, self.fallv, 0)
			if i > 20 then --水流更快
				eggbg.baseBG.updateObjPos(self, obj, 0, -0.4, 0)
			end
			if obj[3][2] < -30 then
				eggbg.baseBG.updateObjPos(self, obj, 0, 120, 0)
			end
		end
	end
	function BG:real_fall_render()
		Set3D('fog' ,100, 100, Color(0, 0, 0, 0))
		SetViewMode'3d'
		local obj, img, p
		for i = 1, #self.real_fall do
			obj = self.real_fall[i]
			img = obj[1][1]
			p = obj[2]
			SetImageState(img, obj[1][2], Color(obj[1][3], 255, 255, 255))
			Render4V(img,    p[1][1], p[1][2], p[1][3],
					p[2][1], p[2][2], p[2][3],
					p[3][1], p[3][2], p[3][3],
					p[4][1], p[4][2], p[4][3])
		end
		Set3D('fog' ,self.fog[1],self.fog[2],Color(self.fog[3],self.fog[4],self.fog[5],self.fog[6]))
		SetViewMode'world'
	end
	--河流渲染
	function BG:river_frame()
		local obj
		if self.rivers then
			--道路只要同步就行了
			for i = 1, #self.rivers-4 do
				obj = self.rivers[i]
				eggbg.baseBG.updateObjPos(self, obj, 0, 0, self.treev)
				if obj[3][3] < 0 then
					eggbg.baseBG.updateObjPos(self, obj, 0, 0, 40)
				end
			end
			for i =  #self.rivers-3, #self.rivers do
				obj = self.rivers[i]
				eggbg.baseBG.updateObjPos(self, obj, 0, 0, 1.2*self.treev)
				if obj[3][3] < 0 then
					eggbg.baseBG.updateObjPos(self, obj, 0, 0, 40)
				end
			end
		end
	end
	function BG:river_render()
		SetViewMode'3d'
		if self.rivers then
			local obj, img, p
			for i = 1, #self.rivers do
				obj = self.rivers[i]
				img = obj[1][1]
				p = obj[2]
				SetImageState(img, obj[1][2], Color(obj[1][3], 255, 255, 255))
				Render4V(img,    p[1][1], p[1][2], p[1][3],
						p[2][1], p[2][2], p[2][3],
						p[3][1], p[3][2], p[3][3],
						p[4][1], p[4][2], p[4][3])
			end
		end
		SetViewMode'world'
	end
	--根据索引在背景里创建新特殊树对象
	---@param img string @索引名
	---@param rot table @可以是直接的三维向量，也可以是ball创建的对象({a, b})
	---@return table @返回静止的背景元素对象
	function BG:creatTreesObj(img, x, y, z, rot, blend, _a, Istree)
		blend = blend or ""
		_a = _a or 255
		local tex = eggbg.baseBG.getImgTex(self, img)
		local w, h = eggbg.baseBG.getImgWH(self, img) --读取对应纹理在背景里的宽高
		local p = Get_Four_Points(x, y, z, w, h, eggbg.ballToVect3(rot)) --获取点
		local obj = {{tex, blend, _a}, p, {x, y, z}, rot, Istree} --第五位参数用来判断是不是树，为之后更换纹理作准备
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
	--樱花花瓣的渲染相关
	function BG:sakura_frame()
		local img
		if self.timer < 3000 then
			img = "snow"
		else
			img = "sakura"
		end
			--创建花瓣
		if self.boss_sence == 1 then
			if self.timer % 3 == 0 then
				if self.timer < 5500 then
					table.insert(self.sakura, BG.creatSakuraObj(self, img, ran:Float(-10, 10), 50, 50, {ran:Float(-100, -80), ran:Float(0, 360)}, 0.1, {ran:Float(30, 42), ran:Float(-80, -100)}, "", 0))
				else
					table.insert(self.sakura, BG.creatSakuraObj(self, img, ran:Float(-10, 10), 60, 50, {ran:Float(-100, -80), ran:Float(0, 360)}, 0.1, {ran:Float(25, 42), ran:Float(-80, -100)}, "", 0))
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
					if eggbg.baseBG.getObjAlp(self, obj) >= 180 then
						eggbg.baseBG.setObjAlp(self, obj, 180)
					end
				end
				if obj[3][3] < 0 then
					table.remove(self.sakura, i)
					n = n - 1
				else
					i = i + 1
				end  --删除超界的花瓣
			end
		elseif self.boss_sence == 2 then
			if self.timer % 2 == 0 then
				table.insert(self.sakura, BG.creatSakuraObj(self, "sakura", ran:Float(-8, 8), 80, 35, {ran:Float(-100, -80), ran:Float(0, 360)}, 0.15, {ran:Float(0, 20), ran:Float(-80, -100)}, "", 0))
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
					if eggbg.baseBG.getObjAlp(self, obj) >= 180 then
						eggbg.baseBG.setObjAlp(self, obj, 180)
					end
				end
				if obj[3][2] < 0 then
					table.remove(self.sakura, i)
					n = n - 1
				else
					i = i + 1
				end  --删除超界的花瓣
			end
		elseif self.boss_sence == 3 then
			if self.timer % 3 == 0 then
				--table.insert(self.sakura, BG.creatSakuraObj(self, "leaf", ran:Float(-10, 10), 110, 40, {ran:Float(-100, -80), ran:Float(0, 360)}, 0.1, {ran:Float(10, 30), ran:Float(-80, -100)}, "", 0))
				table.insert(self.sakura, BG.creatSakuraObj(self, "sakura", ran:Float(-10, 10), 110, 40, {ran:Float(-100, -80), ran:Float(0, 360)}, 0.1, {ran:Float(10, 30), ran:Float(-80, -100)}, "", 0))
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
				if obj[3][2] < 0 then
					table.remove(self.sakura, i)
					n = n - 1
				else
					i = i + 1
				end  --删除超界的花瓣
			end
		end

	end
	function BG:sakura_render()
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
	--最高层渲染（彩虹
	function BG:top_render()
		Set3D('fog' ,100, 100, Color(0, 0, 0, 0))
		SetViewMode'3d'
		local obj, img, p
		for i = 1, #self.top do
			obj = self.top[i]
			img = obj[1][1]
			p = obj[2]
			SetImageState(img, obj[1][2], Color(obj[1][3], 255, 255, 255))
			Render4V(img,    p[1][1], p[1][2], p[1][3],
					p[2][1], p[2][2], p[2][3],
					p[3][1], p[3][2], p[3][3],
					p[4][1], p[4][2], p[4][3])
		end
		Set3D('fog' ,self.fog[1],self.fog[2],Color(self.fog[3],self.fog[4],self.fog[5],self.fog[6]))
		SetViewMode'world'
	end
	--中间变化(
	function BG:change1()
		--从50秒处开始执行
		task.New(self, function()
			do
				task.New(self, function()
					eggbg.baseBG.changeFogRange0To(self, 8, 240)
					eggbg.baseBG.changeFogRange1To(self, 20, 240)
					local dv = -self.treev/240
					for _ = 1, 240 do
						self.treev = self.treev + dv
						task.Wait(1)
					end
				end)
				task.Wait(120)
			end
			--52秒处，画面开始变白（用叠加极光过渡，之后开花
			--创建一道彩虹
			do
				task.New(self, function()
					local x, y, z = eggbg.baseBG.getEyeCen(self)
					x, y, z = x, y + 15, z + 2
					local obj
					for i = 1, 9 do
						obj = eggbg.baseBG.creatAccDecConObj(self, "huge_light", "mul+add", 255, x, y + i, z, {90, -90}, 1, 0.15, {0, -90}, 1, 80, 60, 300)
						table.remove(self.static)
						table.insert(self.top, obj[1])
						task.Wait(20)
					end
					eggbg.baseBG.changeFogRange1To(self, 20, 60)
					task.Wait(120)
					for _ = 1, 9 do
						table.remove(self.top)
						task.Wait(5)
					end
					eggbg.baseBG.changeFogRange0To(self, 0, 60)
				end)
			end
			--按顺序从前往后的树变化
			task.New(self, function()
				task.Wait(180)
				local t = 0
				for i = 1, #self.trees do
					local obj = self.trees[i]
					if obj[5] then
						t = t + 4
						local wt = t
						task.New(self, function()
							task.Wait(wt)
							for j = 1, 4 do
								obj[1][1] = "s6_tree"..j
								task.Wait(4)
							end
						end)
					end
				end
			end)
			--雾的颜色变化
			eggbg.baseBG.changeFogARBGTo(self, 255, 255, 200, 255, 180)
			--背景开始加速
			do
				task.Wait(120)
				eggbg.baseBG.accDecEyePos(self, 0.5/30, {0, -90}, 60, 60, 60)
				task.Wait(120)
				local dv = -0.1/300
				for _ = 1, 300 do
					self.treev = self.treev + dv
					task.Wait(1)
				end
			end
		end)

	end
	--减速，然后高潮时向上飞行
	function BG:change2()
		task.New(self, function()
			--先减速
			local dv = 0.05/360
			eggbg.baseBG.accDecEyePos(self, 1.5/30, {180, -90}, 135, 135, 135) --先飞个个单位试试？
			eggbg.baseBG.changeFogRange1To(self, 30, 405)
			for _ = 1, 360 do
				self.treev = self.treev + dv
				task.Wait(1)
			end
			task.Wait(120 + 1340)
			--再加速
			local dv = -0.1/360
			for _ = 1, 360 do
				self.treev = self.treev + dv
				task.Wait(1)
			end
		end)
	end
	--最后的旋转冲刺阶段！
	function BG:change3()
		task.New(self, function()
			task.New(self, function()
				do
					--以下是镜头旋转
					eggbg.baseBG.changeEyeRot1To(self, 125, 180)
					task.Wait(180)
					for _ = 1, 240 do
						eggbg.baseBG.updateUpRot(self, 0, 1.5)
						task.Wait(1)
					end
				end
			end)
			task.Wait(180)
			eggbg.baseBG.accDecEyePos(self, 2.5/30, {0, -90}, 80, 80, 80)
			--task.Wait(120)
			--雾逐渐靠近
			eggbg.baseBG.changeFogRange0To(self, -18, 240)
			eggbg.baseBG.changeFogRange1To(self, 4, 240)
			--开始往前冲
			local dv = -0.3/240
			for _ = 1, 240 do
				self.treev = self.treev + dv
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
			task.Wait(30)
			BG.senceBoss2(self)
		end)
	end
	--生成最终场景
	function BG:senceBoss2(Isboss)
		default(self)
		self.boss_sence = 1
		if Isboss then
			self.timer = 3000 --下花瓣
		end
		--接上一个场景的雾
		eggbg.baseBG.setFog(self, -18, 4, 255, 255, 220, 255)
		eggbg.baseBG.changeFogARBGTo(self, 255, 220, 255, 255, 120)
		eggbg.baseBG.changeFogRange0To(self, 15, 120)
		eggbg.baseBG.changeFogRange1To(self, 25, 120)
		local x, y, z = eggbg.baseBG.getEyeCen(self)
		x, y, z = x, y - 7, z
		--中间水的部分(替代道中 路的部分
		do
			self.rivers = eggbg.baseBG.creatAccDecConObj(self, "s6_river", "", 255, x, y, z, {180, 90}, 4, 0, {90, -90}, 1, 999999, 60, 10)
			--叠两层差速的
			for _ = 1, 2 do
				local water_lights = eggbg.baseBG.creatAccDecConObj(self, "s6_waterwave", "mul+add", 100, x, y, z, {180, 90}, 4, 0, {90, -90}, 1, 999999, 60, 10)
				for i = 1, #water_lights do
					table.insert(self.rivers, water_lights[i])
					for _ = 1, 2 do
						table.remove(self.static)
					end
				end
			end
		end
		--两侧石头和树以及中间的小石子部分（替代树
		do
			local tree = {}
			for i = 1, 5 do
				BG.creatStoneObj(self, "stone2", x - 14, y + 0, z + 6*(i-1), {115, -90}, "", 255, true)
				tree = BG.creatTreesObj(self, "tree1", x - 10, y + 7.5, z + 6*(i-1)+1.5, {115, -90}, "", 255, true)
				tree[1][1] = "s5_tree2"
				BG.creatStoneObj(self, "stone1", x - 14, y + 2, z + 6*(i-1)+3, {115, -90}, "", 255, true)
				BG.creatStoneObj(self, "stone2", x + 14, y + 0, z + 6*(i-1), {115, -90}, "", 255, true)
				tree = BG.creatTreesObj(self, "tree2", x + 10, y + 7.5, z + 6*(i-1)+1.5, {115, -90}, "", 255, true)
				tree[1][1] = "s5_tree2"
				BG.creatStoneObj(self, "stone1", x + 14, y + 2, z + 6*(i-1)+3, {115, -90}, "", 255, true)
				BG.creatStoneObj(self, "small_stone1", x + 2.5, y + 0, z + 6*(i-1), {115, -90}, "", 255, true)
				BG.creatStoneObj(self, "small_stone2", x + 0, y + 0, z + 6*(i-1)+2, {115, -90}, "", 255, true)
				BG.creatStoneObj(self, "small_stone3", x - 2.5, y + 0, z + 6*(i-1)+4, {115, -90}, "", 255, true)
			end
		end
		--远景瀑布部分
		do
			self.fall = eggbg.baseBG.creatSimObj(self, "falls", x, y + 10, z + 34, {90, -90}, "", 255)
			eggbg.baseBG.creatStaticObj(self, "s6_waterwaveinline", x, y, z + 18, {180, 90}, "mul+add", 255)
		end
		--动作
		do
			task.New(self, function()
				--task.Wait(60)
				--eggbg.baseBG.updateEyeCen(self, 0, 2, 0)
				eggbg.baseBG.updateEyeRot(self, 20, 0)
			end)
		end
		--BG.senceBoss3(self)
	end
	function BG:senceBoss3()
		self.boss_sence = 2
		--[[接上一个场景的雾
		eggbg.baseBG.setFog(self, -18, 4, 255, 255, 220, 255)
		eggbg.baseBG.changeFogARBGTo(self, 255, 220, 255, 255, 120)
		eggbg.baseBG.changeFogRange0To(self, 15, 120)
		eggbg.baseBG.changeFogRange1To(self, 25, 120)]]
		local x, y, z = eggbg.baseBG.getEyeCen(self)
		x, y, z = x, y - 7, z
		--远景瀑布部分(清晰
		do
			--self.fall = eggbg.baseBG.creatSimObj(self, "s6_fall_board", x, y + 10, z + 34, {110, -90}, "", 255)
			z = z + 24
			local tb = eggbg.baseBG.creatConSimObj(self, "s6_fall_board", "", 255, x, y, z, {90, -90}, 4, {180, -90}, 30)
			for i = 1, #tb do
				table.insert(self.real_fall, tb[i])
			end
			--添加石
			tb = eggbg.baseBG.creatConSimObj(self, "s6_fall_stone1", "", 150, x + 5, y + 10, z, {90, -90}, 4, {180, -90}, 30)
			for i = 1, #tb do
				table.insert(self.real_fall, tb[i])
			end
			tb = eggbg.baseBG.creatConSimObj(self, "s6_fall_stone2", "", 150, x, y, z, {90, -90}, 4, {180, -90}, 30)
			for i = 1, #tb do
				table.insert(self.real_fall, tb[i])
			end
			tb = eggbg.baseBG.creatConSimObj(self, "s6_fall_stone2", "", 150, x - 3, y - 12, z, {90, -90}, 4, {180, -90}, 30)
			for i = 1, #tb do
				table.insert(self.real_fall, tb[i])
			end
			--添加水流
			tb = eggbg.baseBG.creatConSimObj(self, "s6_fall_water", "mul+add", 150, x, y, z, {90, -90}, 4, {180, -90}, 30)
			for i = 1, #tb do
				table.insert(self.real_fall, tb[i])
			end
			tb = eggbg.baseBG.creatConSimObj(self, "s6_fall_water2", "mul+add", 150, x, y, z + 5, {90, -90}, 4, {180, -90}, 30)
			for i = 1, #tb do
				table.insert(self.real_fall, tb[i])
			end
		end
		task.New(self, function()
			eggbg.baseBG.accDecEyePos(self, 0.45, {160, 90}, 45, 75, 45)
			eggbg.baseBG.changeEyeRot1To(self, 100, 300)
			task.New(self, function()
				for x = 1, 90 do
					self.fall[1][3] = 255*cos(x)
					task.Wait(1)
				end
			end)
			x, y, z = x, 30, 25
			local obj
			for i = 1, 9 do
				obj = eggbg.baseBG.creatAccDecConObj(self, "huge_light", "mul+add", 255, x, y + 2*i, z, {90, -90}, 1, 0.15, {0, -90}, 2, 80, 150, 300)
				table.remove(self.static)
				table.insert(self.top, obj[1])
				task.Wait(10)
			end
			--上面一层固定极光
			table.insert(self.top, eggbg.baseBG.creatSimObj(self, "huge_light", x, y + 32, z + 10, {90, -90}, "mul+add", 150))
			for i = 1, #self.real_fall do
				eggbg.baseBG.accDecObjPos(self, self.real_fall[i], 0.25, {90, 90}, 40, 0, 40)
			end
			for _ = 1, 120 do
				self.fallv = self.fallv - 0.001
				task.Wait(1)
			end
			for _ = 1, 9 do
				table.remove(self.top, 1)
			end
			--清除上一个场景的东西以减少无意义运算
			do
				for i = 1, #self.rivers do
					table.remove(self.rivers[i])
				end
				for i = 1, #self.trees do
					table.remove(self.trees[i])
				end
			end
			--再把瀑布往z正方向挪10个单位
			task.Wait(300)
			--BG.senceBoss4(self)
		end)

	end
	function BG:senceBoss4()
		self.boss_sence = 3
		eggbg.baseBG.setEyeCen(self, 0, 54.74, 24.47)
		local x, y, z = eggbg.baseBG.getEyeCen(self)
		eggbg.baseBG.setFog(self, 100, 100, 0, 0, 0, 0) --不需要雾
		y = y + 30
		z = z - 8
		--创建远景
		do
			eggbg.baseBG.chObjAlpTo(self, eggbg.baseBG.creatStaticObj(self, "s6_baseboard", x, y - 10, z + 42, {90, -90}, "", 0), 255, 240)
			eggbg.baseBG.creatStaticObj(self, "s6_cloud", x, y - 0, z + 23.5, {90, -90}, "", 150)
			eggbg.baseBG.creatStaticObj(self, "s6_moutain2", x, y - 4, z + 20, {90, -90}, "", 255)
			eggbg.baseBG.creatStaticObj(self, "s6_cloud", x, y - 15, z + 20, {90, -90}, "", 255)
			eggbg.baseBG.creatStaticObj(self, "s6_moutain1", x, y - 7, z + 10, {90, -90}, "", 255)
			eggbg.baseBG.chObjAlpTo(self, eggbg.baseBG.creatStaticObj(self, "s6_cloud", x, y - 10, z + 8, {90, -90}, "", 255), 255, 90)
			eggbg.baseBG.chObjAlpTo(self, eggbg.baseBG.creatStaticObj(self, "s6_cloud", x, y - 20, z + 8, {90, -90}, "", 0), 255, 90)
			eggbg.baseBG.chObjAlpTo(self, eggbg.baseBG.creatStaticObj(self, "s6_cloud", x, y - 30, z + 8, {90, -90}, "", 0), 255, 90)
			eggbg.baseBG.creatStaticObj(self, "s4_polar1", x, y + 5, z + 22, {90, -90}, "mul+add", 100)
			eggbg.baseBG.creatStaticObj(self, "s4_high_cloud", x, y + 5, z + 15, {90, -90}, "mul+add", 120)
			eggbg.baseBG.creatStaticObj(self, "s4_polar2", x, y - 5, z + 15, {90, -90}, "mul+add", 100)
		end
		--清除上一场景
		do
			task.New(self, function()
				for i = 1, #self.real_fall do
					eggbg.baseBG.chObjAlpTo(self, self.real_fall[i], 0, 120)
				end
				for i = 1, #self.top do
					eggbg.baseBG.chObjAlpTo(self, self.top[i], 0, 120)
				end
				task.Wait(90)
				for _ = 1, #self.real_fall do
					table.remove(self.real_fall)
				end
				for _ = 1, #self.top do
					table.remove(self.top)
				end
			end)

		end
		--动作
		do
			eggbg.baseBG.changeEyeRot1To(self, 95, 180) --视角
			eggbg.baseBG.accDecEyePos(self, 0.067, {90, -90}, 60, 60, 60) --向后退8
			eggbg.baseBG.accDecEyePos(self, 0.25, {180, -90}, 60, 60, 60) --向上升30
		end
	end
	--上面的3 4由boss调用切换场景
	--生成石头对象（放在树里，处理方法同树
	function BG:creatStoneObj(img, x, y, z, rot, blend, _a, Istree)
		blend = blend or ""
		_a = _a or 255
		x = x + ran:Float(-0.5, 0.5) --让x在一个范围内波动，使得河道不那么平整
		local tex = eggbg.baseBG.getImgTex(self, img)
		local w, h = eggbg.baseBG.getImgWH(self, img) --读取对应纹理在背景里的宽高
		local p = Get_Four_Points(x, y, z, w, h, eggbg.ballToVect3(rot)) --获取点
		local obj = {{tex, blend, _a}, p, {x, y, z}, rot, Istree} --第五位参数用来判断是不是树，为之后更换纹理作准备
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
end
function BG:init(IsBoss)
	load_res() -- 资源加载写在这里
	lstg.tmpvar.bg = self --给boss操作用的
	eggbg.baseBG.init(self)
	BG.setDefault(self)
	if IsBoss then
		BG.senceBoss2(self, true)
	else
		BG.Sence1(self)
	end
end
function BG:frame()
	background_open = setting.background
	if background_open then
		task.Do(self)
		BG.real_fall_frame(self)
		BG.river_frame(self)
		BG.fall_frame(self)
		eggbg.baseBG.frame(self)
		BG.tree_frame(self)
		BG.sakura_frame(self, self.timer)
	end
end
function BG:render()
	if background_open then
		background.WarpEffectCapture()
		BG.real_fall_render(self)
		BG.river_render(self)
		BG.fall_render(self)
		eggbg.baseBG.render(self)
		BG.tree_render(self)
		BG.sakura_render(self, self.timer)
		BG.top_render(self)
		background.WarpEffectApply()
		eggbg.baseBG.renderBlackBoard(self)
	else
		eggbg.baseBG.renderGrayBoard()
	end
	--eggbg.baseBG.printParam(self) --打印背景相关参数，测试用

end

----------------------------------------]]
---导出定义

stage6_background = BG

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
		_object.set_color(self, "", 0, 255, 200, 255)
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
