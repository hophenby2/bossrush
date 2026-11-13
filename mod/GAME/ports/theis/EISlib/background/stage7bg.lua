---======================================
---祈华梦ex面背景
---by S7UPID
---======================================

local background_open = setting.background --背景开关选项
local ran = lstg.Rand()

--ex面背景素材加载
local function load_res()
	local path = "res/background/stage7/part1/"
	LoadImageFromFile("s7_cloud1", path .. "cloud1.png")
	LoadImageFromFile("s7_cloud2", path .. "cloud2.png")
	LoadImageGroupFromFile("s7_clouds1", path .. "clouds1.png", false, 1, 32)
	LoadImageGroupFromFile("s7_clouds2", path .. "clouds2.png", false, 1, 32) --两个云层底版素材微分成32份吧
	LoadImageGroupFromFile("s7_light1", path .. "light1.png", false, 11, 2)
	LoadImageGroupFromFile("s7_light2", path .. "light2.png", false, 11, 2)
	LoadImageFromFile("s7_starlight", path .. "starlight.png")
	LoadImageFromFile("s7_barrier", path .. "barrier.png")
	LoadImageFromFile("s7_board", path .. "board.png")
	LoadImageFromFile("s7_board2", path .. "board2.png")

	path = "res/background/stage7/part2/"
	LoadImageFromFile("s7_blue", path .. "blue.png")
	LoadImageFromFile("s7_red", path .. "red.png")
	LoadImageFromFile("s7_build1", path .. "build1.png")
	LoadImageFromFile("s7_build2", path .. "build2.png")
	LoadImageFromFile("s7_city", path .. "city.png")
	LoadImageFromFile("s7_road", path .. "road.png")
	--boss场景
	path = "res/background/stage7/part3/"
	LoadImageFromFile("s7_starlight2", path .. "starlight.png")
	LoadImageFromFile("s7_starsky", path .. "starsky.png")
	LoadImageFromFile("s7_moutain", path .. "moutain.png")
	--从五面搬点素材过来
	path = "res/background/stage5/"
	LoadImageFromFile("s5_Island_cloud", path .. "s5_Island_cloud.png")
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

---白色转场
local white = Class(object)
function white:init()
	_object.set_color(self, "", 0, 255, 255, 255)
	task.New(self, function()
		egg.SimAlpCh(self, 0, 255, 120)
		task.Wait(120)
		egg.SimAlpCh(self, 255, 0, 120)
		task.Wait(120)
		Del(self)
	end)
end
function white:frame()
	task.Do(self)
end
function white:render()
	local img = "white"
	SetImageState(img, self._blend, Color(self._a, self._r, self._g, self._b))
	Render(img, 0, 0, 0, 100, 100)
end
---背景定义

local BG = Class(eggbg.baseBG)
--变量
local buildsW, buildsH = 5.12, 12
--该背景私有的操作方法
local sence1Init, creatFars, starLightFrame, farsRender, creatLightsBack, creatClouds, cloudInit, cloudFrame, cloudRender,
creatCloudBoards, cloudBoardsInit, cloudBoardsFrame, cloudBoardsRender,
creatLights, lightsInit, lightsFrame, lightsRender, creatLightsTop, topRender,
barrierFrame, cloudAlpTo0,
sence2Init, buildsFrame, buildsRender, creatBuildsFace, creatBuilds, buildsInit,
creatRoadBoards, roadBoardsFrame, roadBoardsRender, roadBoardsInit,
st2Init, st2Frame, st2Render, cityAppear, changeCityV, lightsFarInit,
sence3Init, st3Init, creatClouds3, clouds3Frame, st3Frame

do
	---阶段1星空
	do
		function sence1Init(self)
			self.clouds = {} --云
			self.cloudboards = {}  --云层底版
			self.cloud_alpha = 1 --云层总透明度
			self.lights = {} --极光
			self.barrier = nil
			self.board1 = nil
			self.board2 = nil
			self.starlight = nil
		end
		--创建远景
		function creatFars(self, img, x, y, z, rot, blend, _a)
			local obj = eggbg.baseBG.creatSimObj(self, img, x, y, z, rot, blend, _a)
			table.insert(self.fars, obj)
			return obj
		end
		function starLightFrame(self)
			--旋转
			if self.starlight then
				local obj = self.starlight  --找到星盘，旋转
				local w, h = eggbg.baseBG.getImgWH(self, "board")
				w, h = 0.5 * w, 0.5 * h
				local r = sqrt(h * h + w * w)
				local x, y, z = obj[3][1], obj[3][2], obj[3][3]
				local p = obj[2]
				local rot = self.timer / 3
				local dx, dy
				for i = 1, 4 do
					dx, dy = r * cos(225 - 90 * i), r * sin(225 - 90 * i)
					p[i][1] = x + dx * cos(rot) - dy * sin(rot)
					p[i][2] = y + dx * sin(rot) + dy * cos(rot)
					p[i][3] = z
				end
			end
		end
		function farsRender(self)
			Set3D('fog', 100, 100, Color(0, 0, 0, 0))
			SetViewMode '3d'
			local obj, img, p
			for i = 1, #self.fars do
				obj = self.fars[i]
				img = obj[1][1]
				p = obj[2]
				SetImageState(img, obj[1][2], Color(obj[1][3], 255, 255, 255))
				Render4V(img, p[1][1], p[1][2], p[1][3],
						p[2][1], p[2][2], p[2][3],
						p[3][1], p[3][2], p[3][3],
						p[4][1], p[4][2], p[4][3])
			end
			local f1, f2 = eggbg.baseBG.getFogRange(self)
			local f3, f4, f5, f6 = eggbg.baseBG.getFogColor(self)
			Set3D('fog', f1, f2, Color(f3, f4, f5, f6))
			SetViewMode 'world'
		end
		--普通云（也包括后面的极光
		local r0, r1 = 0, 90 --云最近距离，最远距离
		function creatClouds(self, img, x, y, z, rot, blend, _a)
			table.insert(self.clouds, eggbg.baseBG.creatSimObj(self, img, x, y, z, rot, blend, _a))
		end
		--在云背后产生极光
		function creatLightsBack(self, type, imgnum, x, y, z, rot, blend, _a)
			if type == 1 then
				local obj = eggbg.baseBG.creatSimObj(self, "light1", x, y, z, rot, blend, _a)
				table.insert(self.clouds, obj)
				obj[1][1] = imgnum   --极光比较特殊，第1位用来存放的是其动态纹理所在帧
				obj[1][4] = 1   --这个是放极光类别的
				table.insert(self.lights, obj)
			else
				local obj = eggbg.baseBG.creatSimObj(self, "light2", x, y, z, rot, blend, _a)
				table.insert(self.clouds, obj)
				obj[1][1] = imgnum   --极光比较特殊，第1位用来存放的是其动态纹理所在帧
				obj[1][4] = 2   --这个是放极光类别的
				table.insert(self.lights, obj)
			end
		end
		--在r0与r1范围内等间隔生成num道云
		function cloudInit(self, num)
			local dist = (r1 - r0) / num
			local dx
			for i = num, 1, -1 do
				dx = ran:Float(-2, 2)
				--极光
				creatLightsBack(self, ran:Int(1, 2), ((2 * i) % 21 + 1), -12 + dx, 5, r0 + (i + 1.25) * dist, { 105, -90 }, "mul+add", 255)
				--左生成
				creatClouds(self, "cloud" .. (i % 4 + 1), -10 + dx, 0, r0 + (i + 1) * dist, { 135, -90 }, "", 255)
				dx = ran:Float(-2, 2)
				--极光
				creatLightsBack(self, ran:Int(1, 2), ((2 * i) % 21 + 1), 12 + dx, 5, r0 + (i + 0.75) * dist, { 105, -90 }, "mul+add", 255)
				--右生成
				creatClouds(self, "cloud" .. (-i % 4 + 1), 10 + dx, 0, r0 + (i + 0.5) * dist, { 135, -90 }, "", 255)
			end
		end
		function cloudFrame(self)
			local obj
			local back = {} --存放要前进的obj
			for i = 1, #self.clouds do
				obj = self.clouds[i]
				eggbg.baseBG.updateObjPos(self, obj, 0, 0, -0.15)
				eggbg.baseBG.updateObjAlp(self, obj, 10)
				if eggbg.baseBG.getObjAlp(self, obj) >= 200 then
					eggbg.baseBG.setObjAlp(self, obj, 200)
				end
				if obj[3][3] < r0 then
					table.insert(back, obj)
					--返回到z = 30
					eggbg.baseBG.updateObjPos(self, obj, 0, 0, (r1 - r0))
					eggbg.baseBG.setObjAlp(self, obj, 0)
				end
			end
			for i = 1, #back do
				table.remove(self.clouds)
				table.insert(self.clouds, 1, back[i])
			end
		end
		function cloudRender(self)
			SetViewMode '3d'
			local obj, img, p
			local f1, f2 = eggbg.baseBG.getFogRange(self)
			local f3, f4, f5, f6 = eggbg.baseBG.getFogColor(self)
			for i = 1, #self.clouds do
				obj = self.clouds[i]
				p = obj[2]
				if not obj[1][4] then
					--考虑是否是极光两种可能
					SetViewMode '3d'
					img = obj[1][1]
					SetImageState(img, obj[1][2], Color(obj[1][3] * self.cloud_alpha, 255, 255, 255))
					Render4V(img, p[1][1], p[1][2], p[1][3],
							p[2][1], p[2][2], p[2][3],
							p[3][1], p[3][2], p[3][3],
							p[4][1], p[4][2], p[4][3])
					SetViewMode 'world'
				else
					--极光去雾
					Set3D('fog', 100, 100, Color(0, 0, 0, 0))
					SetViewMode '3d'
					img = "s7_light" .. obj[1][4] .. int(obj[1][1])  --一定要取整！
					SetImageState(img, obj[1][2], Color(obj[1][3] * self.cloud_alpha, 255, 255, 255))
					Render4V(img, p[1][1], p[1][2], p[1][3],
							p[2][1], p[2][2], p[2][3],
							p[3][1], p[3][2], p[3][3],
							p[4][1], p[4][2], p[4][3])

					Set3D('fog', f1, f2, Color(f3, f4, f5, f6))
					SetViewMode 'world'
				end
			end
			SetViewMode 'world'
		end
		--底版云
		function creatCloudBoards(self, img, x, y, z, rot, blend, _a)
			table.insert(self.cloudboards, eggbg.baseBG.creatSimObj(self, img, x, y, z, rot, blend, _a))
		end
		function cloudBoardsInit(self)
			local dist = 2 --底层云每份的高度
			for i = 32, 1, -1 do
				creatCloudBoards(self, "clouds2" .. i, 0, 0, i * dist, { 0, 90 }, "", 255)
				creatCloudBoards(self, "clouds1" .. i, 0, 0, i * dist, { 0, 90 }, "", 255)
			end
		end
		function cloudBoardsFrame(self)
			local obj
			local back = {} --存放要前进的obj
			for i = 1, #self.cloudboards do
				obj = self.cloudboards[i]
				eggbg.baseBG.updateObjPos(self, obj, 0, 0, -0.1)
				eggbg.baseBG.updateObjAlp(self, obj, 10)
				if eggbg.baseBG.getObjAlp(self, obj) >= 255 then
					eggbg.baseBG.setObjAlp(self, obj, 255)
				end
				if obj[3][3] < 0 then
					table.insert(back, obj)
					--返回到z = 64
					eggbg.baseBG.updateObjPos(self, obj, 0, 0, 64)
					eggbg.baseBG.setObjAlp(self, obj, 0)
				end
			end
			for i = 1, #back do
				table.remove(self.cloudboards)
				table.insert(self.cloudboards, 1, back[i])
			end
		end
		function cloudBoardsRender(self)
			SetViewMode '3d'
			local obj, img, p
			for i = 1, #self.cloudboards do
				obj = self.cloudboards[i]
				img = obj[1][1]
				p = obj[2]
				SetImageState(img, obj[1][2], Color(obj[1][3] * self.cloud_alpha, 255, 255, 255))
				Render4V(img, p[1][1], p[1][2], p[1][3],
						p[2][1], p[2][2], p[2][3],
						p[3][1], p[3][2], p[3][3],
						p[4][1], p[4][2], p[4][3])
			end
			SetViewMode 'world'
		end
		--云透明度变化为0
		function cloudAlpTo0(self)
			eggbg.baseBG.chObjAlpTo(self, self.board2, 0, 180)
			eggbg.baseBG.chObjAlpTo(self, self.starlight, 0, 180)
			task.New(self, function()
				local d_a = -1 / 180
				for _ = 1, 180 do
					self.cloud_alpha = self.cloud_alpha + d_a
					task.Wait(1)
				end
			end)
		end
		--所有极光帧动画
		function lightsFrame(self)
			local obj
			for i = 1, #self.lights do
				obj = self.lights[i]
				obj[1][1] = obj[1][1] + 0.25 --差不多是4帧切换一次贴图
				if obj[1][1] >= 22 then
					obj[1][1] = obj[1][1] - 21
				end
			end
		end
		--创建远景极光
		function creatLightsTop(self, type, imgnum, x, y, z, rot, blend, _a)
			if type == 1 then
				local obj = eggbg.baseBG.creatSimObj(self, "light3", x, y, z, rot, blend, _a)
				table.insert(self.top, obj)
				obj[1][1] = imgnum   --极光比较特殊，第1位用来存放的是其动态纹理所在帧
				obj[1][4] = 1   --这个是放极光类别的
				table.insert(self.lights, obj)
			else
				local obj = eggbg.baseBG.creatSimObj(self, "light4", x, y, z, rot, blend, _a)
				table.insert(self.top, obj)
				obj[1][1] = imgnum   --极光比较特殊，第1位用来存放的是其动态纹理所在帧
				obj[1][4] = 2   --这个是放极光类别的
				table.insert(self.lights, obj)
			end
		end
		--最高层且无视雾渲染
		function topRender(self)
			Set3D('fog', 100, 100, Color(0, 0, 0, 0))
			SetViewMode '3d'
			local obj, img, p
			for i = 1, #self.top do
				obj = self.top[i]
				if obj[1][4] then
					img = "s7_light" .. obj[1][4] .. int(obj[1][1])  --一定要取整！
				else
					img = obj[1][1]
				end
				p = obj[2]
				SetImageState(img, obj[1][2], Color(obj[1][3], 255, 255, 255))
				Render4V(img, p[1][1], p[1][2], p[1][3],
						p[2][1], p[2][2], p[2][3],
						p[3][1], p[3][2], p[3][3],
						p[4][1], p[4][2], p[4][3])
			end
			local f1, f2 = eggbg.baseBG.getFogRange(self)
			local f3, f4, f5, f6 = eggbg.baseBG.getFogColor(self)
			Set3D('fog', f1, f2, Color(f3, f4, f5, f6))
			SetViewMode 'world'
		end
		--结界旋转
		function barrierFrame(self)
			if self.barrier then
				local obj = self.barrier
				local h, w = 0.5 * 100, 0.5 * 100
				local r = sqrt(h * h + w * w)
				local x, y, z = obj[3][1], obj[3][2], obj[3][3]
				local rot = -self.timer / 6
				local p, dx, dy = obj[2]
				for i = 1, 4 do
					dx, dy = r * cos(225 - 90 * i), r * sin(225 - 90 * i)
					p[i][1] = x + dx * cos(rot) - dy * sin(rot)
					p[i][2] = y + dx * sin(rot) + dy * cos(rot)
					p[i][3] = z
				end
			end
		end
		--创建远景极光初始化
		function lightsFarInit(self, x, y, z)
			for i = 1, 21 do
				creatLightsTop(self, 1, i, x + 1.5 * i, y + 24 - 0.6 * i, z + 30 - 1.5 * (i - 11), { 90, -90 }, "mul+add", 150)
				creatLightsTop(self, 1, i, x - 1.5 * i, y + 24 - 0.6 * i, z + 30 - 1.5 * (i - 11), { 90, -90 }, "mul+add", 150)
			end
		end
	end
	---阶段2城市
	do
		function sence2Init(self)
			self.city = nil
			self.builds = {}  --两侧的建筑物
			self.roadboards = {} --中间的道路
			self.city_alpha = 0
			self.city_v = 0
		end
		local r0, r1 = 0, 50
		function buildsFrame(self)
			local obj
			local back = {} --存放要前进的obj
			for i = 1, #self.builds do
				obj = self.builds[i]
				eggbg.baseBG.updateObjPos(self, obj, 0, 0, self.city_v)
				eggbg.baseBG.updateObjAlp(self, obj, 10)
				if eggbg.baseBG.getObjAlp(self, obj) >= 255 then
					eggbg.baseBG.setObjAlp(self, obj, 255)
				end
				if obj[3][3] < r0 then
					table.insert(back, obj)
					--返回到最远
					eggbg.baseBG.updateObjPos(self, obj, 0, 0, (r1 - r0))
					eggbg.baseBG.setObjAlp(self, obj, 0)
				end
			end
			for i = #back, 1, -1 do
				table.remove(self.builds)
				table.insert(self.builds, 1, back[i])
			end
		end
		function buildsRender(self)
			SetViewMode '3d'
			local obj, img, p
			for i = 1, #self.builds do
				obj = self.builds[i]
				p = obj[2]
				img = obj[1][1]
				SetImageState(img, obj[1][2], Color(obj[1][3] * self.city_alpha, 255, 255, 255))
				Render4V(img, p[1][1], p[1][2], p[1][3],
						p[2][1], p[2][2], p[2][3],
						p[3][1], p[3][2], p[3][3],
						p[4][1], p[4][2], p[4][3])
			end
			SetViewMode 'world'
		end
		--创建建筑物的一个面
		function creatBuildsFace(self, img, x, y, z, rot, blend, _a)
			local obj = eggbg.baseBG.creatSimObj(self, img, x, y, z, rot, blend, _a)
			table.insert(self.builds, obj)
			return obj
		end
		--创建一个完整的建筑物
		function creatBuilds(self, x, y, z, layer, pos)
			local a
			if pos == "left" then
				--要按顺序，先生成后面
				a = 90
				for j = 1, layer do
					creatBuildsFace(self, "build" .. ran:Int(1, 4), x + 0.5 * buildsW * cos(a), y + (j - 0.5) * buildsH, z + 0.5 * buildsW * sin(a), { 90, -a }, "", 255)
				end
				--生成中间两边
				for u = -1, 1, 2 do
					a = 90 + 90 * u
					for j = 1, layer do
						creatBuildsFace(self, "build" .. ran:Int(1, 4), x + 0.5 * buildsW * cos(a), y + (j - 0.5) * buildsH, z + 0.5 * buildsW * sin(a) + 0.0001 * u, { 90, a }, "", 255)
					end
				end
				--最后生成前面
				a = -90
				for j = 1, layer do
					creatBuildsFace(self, "build" .. ran:Int(1, 4), x + 0.5 * buildsW * cos(a), y + (j - 0.5) * buildsH, z + 0.5 * buildsW * sin(a), { 90, a }, "", 255)
					for u = -1, 1, 2 do
						creatBuildsFace(self, "red", x - 0.6 * buildsW * u, y + buildsH, z - 0.5 * buildsW - 0.02 + 0.05 * u, { 90, -90 }, "", 255)
					end
					creatBuildsFace(self, "blue", x + 0.5 * buildsW, y, z - 0.5 * buildsW - 0.01, { 90, -90 }, "", 255)
				end

			elseif pos == "right" then
				--要按顺序，先生成后面
				a = 90
				for j = 1, layer do
					creatBuildsFace(self, "build" .. ran:Int(1, 4), x + 0.5 * buildsW * cos(a), y + (j - 0.5) * buildsH, z + 0.5 * buildsW * sin(a), { 90, -a }, "", 255)
				end
				--生成中间两边
				for u = 1, -1, -2 do
					a = 90 + 90 * u
					for j = 1, layer do
						creatBuildsFace(self, "build" .. ran:Int(1, 4), x + 0.5 * buildsW * cos(a), y + (j - 0.5) * buildsH, z + 0.5 * buildsW * sin(a) + 0.0001 * u, { 90, a }, "", 255)
					end
				end
				--最后生成前面
				a = -90
				for j = 1, layer do
					creatBuildsFace(self, "build" .. ran:Int(1, 4), x + 0.5 * buildsW * cos(a), y + (j - 0.5) * buildsH, z + 0.5 * buildsW * sin(a), { 90, a }, "", 255)
					for u = -1, 1, 2 do
						creatBuildsFace(self, "red", x + 0.6 * buildsW * u, y + buildsH, z - 0.5 * buildsW - 0.02 + 0.05 * u, { 90, -90 }, "", 255)
					end
					creatBuildsFace(self, "blue", x - 0.5 * buildsW, y, z - 0.5 * buildsW - 0.01, { 90, -90 }, "", 255)
				end
			end
		end
		--建筑物生成初始化
		function buildsInit(self, num)
			--num = 1
			local z0, dist = 10 + 0.5 * buildsW, (r1 - r0) / num
			for i = num, 1, -1 do
				creatBuilds(self, 8, 0, z0 + r0 + (i) * dist, 1, "right")
				creatBuilds(self, -8, 0, 1 + z0 + r0 + (i) * dist, 1, "left")
			end
			--一定要记得按z坐标排序！！！！！！！
			local tb, max, max2, count = {}
			max2 = 9999
			for _ = 1, #self.builds do
				max = -9999
				--count = #self.builds
				for i = 1, #self.builds do
					if self.builds[i][3][3] > max and self.builds[i][3][3] < max2 then
						max = self.builds[i][3][3]
						count = i
					end
				end
				max2 = self.builds[count][3][3]
				table.insert(tb, self.builds[count])
			end
			self.builds = tb
		end
		--底版道路
		function creatRoadBoards(self, img, x, y, z, rot, blend, _a)
			local obj = eggbg.baseBG.creatSimObj(self, img, x, y, z, rot, blend, _a)
			table.insert(self.roadboards, obj)
			return obj
		end
		function roadBoardsInit(self)
			local dist = 5 --底层道路的宽度
			for i = 12, 1, -1 do
				eggbg.baseBG.chObjAlpTo(self, creatRoadBoards(self, "road", 0, 0, i * dist, { 180, 90 }, "", 0), 255, 90)
			end
		end
		function roadBoardsFrame(self)
			local obj
			local back = {} --存放要前进的obj
			for i = 1, #self.roadboards do
				obj = self.roadboards[i]
				eggbg.baseBG.updateObjPos(self, obj, 0, 0, self.city_v)
				eggbg.baseBG.updateObjAlp(self, obj, 10)
				if eggbg.baseBG.getObjAlp(self, obj) >= 255 then
					eggbg.baseBG.setObjAlp(self, obj, 255)
				end
				if obj[3][3] < 0 then
					table.insert(back, obj)
					eggbg.baseBG.updateObjPos(self, obj, 0, 0, 60)
					eggbg.baseBG.setObjAlp(self, obj, 0)
				end
			end
			for i = 1, #back do
				table.remove(self.roadboards)
				table.insert(self.roadboards, 1, back[i])
			end
		end
		function roadBoardsRender(self)
			SetViewMode '3d'
			local obj, img, p
			for i = 1, #self.roadboards do
				obj = self.roadboards[i]
				img = obj[1][1]
				p = obj[2]
				SetImageState(img, obj[1][2], Color(obj[1][3] * self.city_alpha, 255, 255, 255))
				Render4V(img, p[1][1], p[1][2], p[1][3],
						p[2][1], p[2][2], p[2][3],
						p[3][1], p[3][2], p[3][3],
						p[4][1], p[4][2], p[4][3])
			end
			SetViewMode 'world'
		end
		function st2Init(self)
			local x, y, z = 0, 4, 6
			self.city = creatFars(self, "city", x, y - 0, z + 40, { 90, -90 }, "", 0)
			roadBoardsInit(self)
			buildsInit(self, 6)
		end
		function st2Frame(self)
			roadBoardsFrame(self)
			buildsFrame(self)
		end
		function st2Render(self)
			roadBoardsRender(self)
			buildsRender(self)
		end
		--城市出现
		function cityAppear(self)
			task.New(self, function()
				local d_a = 1 / 90
				for _ = 1, 90 do
					self.city_alpha = self.city_alpha + d_a
					task.Wait(1)
				end
			end)
		end
		--在城市的前进速度改变
		function changeCityV(self, v, t)
			task.New(self, function()
				local d_v = v / t
				for _ = 1, t do
					self.city_v = self.city_v + d_v
					task.Wait(1)
				end
			end)
		end
	end
	---阶段3八岳
	do
		local dlen = 77 * 0.45 --山前山后云与云之间的水平距离
		--第三幕用到的变量初始化
		function sence3Init(self)
			self.board1 = nil
			self.starlight = nil
			self.clouds3 = {} --远处的云
			for _ = 1, #self.fars do
				--清空此前所有远景
				table.remove(self.fars)
			end
		end
		function st3Init(self)
			sence3Init(self)
			self.stage = 3
			local x, y, z = eggbg.baseBG.getEyeCen(self)
			--远处星空
			self.board1 = creatFars(self, "starsky", x, y - 5, z + 40, { 90, -90 }, "", 255)
			self.starlight = creatFars(self, "starlight2", x, y + 30, z + 30, { 90, -90 }, "mul+add", 255)
			--山后云
			for i = 1, 3 do
				for j = -1, 2 do
					creatClouds3(self, "moutain_cloud", dlen * (j - 0.33 * i), y - 10 + 3 * (i - 1), z + 20 + 5 * i, { 90, -90 }, "", 200, 0.05)
				end
			end
			creatFars(self, "moutain", x, y - 5, z + 20, { 90, -90 }, "", 255)
			--山前云
			for i = 1, 2 do
				for j = -1, 2 do
					creatClouds3(self, "moutain_cloud", dlen * (j - 0.45 * i), y - 10 * i, z + 20 - 7.5 * i, { 90, -90 }, "", 200, 0.05)
				end
			end
			--远处极光
			lightsFarInit(self, x, y - 10, z - 10)
		end
		function creatClouds3(self, img, x, y, z, rot, blend, _a, v)
			local obj = creatFars(self, img, x, y, z, rot, blend, _a)
			table.insert(obj, v)
			table.insert(self.clouds3, obj)
		end
		function clouds3Frame(self)
			local obj, v
			for i = 1, #self.clouds3 do
				obj = self.clouds3[i]
				v = obj[7]
				eggbg.baseBG.updateObjPos(self, obj, 0.05, 0, 0)
				eggbg.baseBG.updateObjAlp(self, obj, 10)
				if eggbg.baseBG.getObjAlp(self, obj) >= 200 then
					eggbg.baseBG.setObjAlp(self, obj, 200)
				end
				--范围 -50, 50
				if obj[3][1] > 2 * dlen then
					--返回到z = 30
					eggbg.baseBG.updateObjPos(self, obj, -4 * dlen, 0, 0)
					eggbg.baseBG.setObjAlp(self, obj, 0)
				end
			end
		end
		function st3Frame(self)
			clouds3Frame(self)
		end
	end

	function BG:setDefault()
		--加载背景纹理
		do
			--part1
			local size = 3
			eggbg.baseBG.addToImg(self, "cloud1", "s7_cloud1", 6.6 * size, 3.9 * size)
			eggbg.baseBG.addToImg(self, "cloud2", "s7_cloud2", 5.5 * size, 3.1 * size)
			eggbg.baseBG.addToImg(self, "cloud3", "s7_cloud1", -6.6 * size, 3.9 * size)
			eggbg.baseBG.addToImg(self, "cloud4", "s7_cloud2", -5.5 * size, 3.1 * size)
			for i = 1, 32 do
				eggbg.baseBG.addToImg(self, "clouds1" .. i, "s7_clouds1" .. i, 64, 2)
				eggbg.baseBG.addToImg(self, "clouds2" .. i, "s7_clouds2" .. i, 64, 2)
			end
			--极光
			size = 2
			eggbg.baseBG.addToImg(self, "light1", "s7_light11", 5.1 * size, 7.3 * size)
			eggbg.baseBG.addToImg(self, "light2", "s7_light21", -5.1 * size, 7.3 * size)
			size = 4
			eggbg.baseBG.addToImg(self, "light3", "s7_light11", 5.1 * size, -7.3 * size)
			eggbg.baseBG.addToImg(self, "light4", "s7_light21", -5.1 * size, -7.3 * size)
			--远处星盘
			eggbg.baseBG.addToImg(self, "starlight", "s7_starlight", 200, 200)
			eggbg.baseBG.addToImg(self, "board", "s7_board", 100, 100)
			eggbg.baseBG.addToImg(self, "board2", "s7_board2", 100, 100)
			--大结界
			eggbg.baseBG.addToImg(self, "barrier", "s7_barrier", 100, 100)

			--part2
			eggbg.baseBG.addToImg(self, "road", "s7_road", 24, 5)
			eggbg.baseBG.addToImg(self, "build1", "s7_build1", buildsW, buildsH)
			eggbg.baseBG.addToImg(self, "build2", "s7_build2", buildsW, buildsH)
			eggbg.baseBG.addToImg(self, "build3", "s7_build1", -buildsW, buildsH)
			eggbg.baseBG.addToImg(self, "build4", "s7_build2", -buildsW, buildsH)
			eggbg.baseBG.addToImg(self, "red", "s7_red", 4, 4)
			eggbg.baseBG.addToImg(self, "blue", "s7_blue", 4, 4)
			eggbg.baseBG.addToImg(self, "city", "s7_city", 100, 100)

			--boss
			eggbg.baseBG.addToImg(self, "starlight2", "s7_starlight2", 200, 200)
			eggbg.baseBG.addToImg(self, "starsky", "s7_starsky", 100, 100)
			eggbg.baseBG.addToImg(self, "moutain", "s7_moutain", 40, 40)
			--五面的云的素材
			eggbg.baseBG.addToImg(self, "moutain_cloud", "s5_Island_cloud", 77 * 0.45, 36 * 0.45)
		end

		self.eye_pos = { 0, 4, 6 } --眼睛的初始位置
		self.eye_rot = { 95, 90 } --1球坐标系的θ，取值0到180  2球坐标系的φ，取值0到360（当然也可以更高）
		--这里是转化到at视角的方向单位向量
		self.eye_rot3 = { sin(self.eye_rot[1]) * cos(self.eye_rot[2]), cos(self.eye_rot[1]), sin(self.eye_rot[1]) * sin(self.eye_rot[2]) } --眼睛朝向的单位法向量(这里是默认向下60度)(采用球坐标系, r = 1, 此处θ = 120,φ = -90)
		--背景的朝向（背景向前移动方向）
		self.bg_rot = { 90, -90 }
		--背景的朝向的单位方向向量
		self.bg_rot3 = { sin(self.bg_rot[1]) * cos(self.bg_rot[2]), -cos(self.bg_rot[1]), sin(self.bg_rot[1]) * sin(self.bg_rot[2]) } --背景前进的方向的法向量(其反方向也是生成背景元素的方向)
		--背景前进的速度
		self.bg_speed = 0
		--对应于set3d的up
		self.up_rot = { 90, 90 }
		self.up = eggbg.ballToVect3(self.up_rot)
		--对应于set3d的fovy
		self.fovy = { 1.5 }
		--对应于set3d的z
		self.z = { 0.1, 100 }
		--对应于set3d的fog
		--self.fog = {0, 50, 255, 51, 217, 255}
		self.fog = { 0, 50, 255, 76, 0, 56 }
		Set3D('eye', self.eye_pos[1], self.eye_pos[2], self.eye_pos[3])
		Set3D('at', self.eye_pos[1] + self.eye_rot3[1], self.eye_pos[2] + self.eye_rot3[2], self.eye_pos[3] + self.eye_rot3[3]) --暂且让眼睛的视角向下约30度吧
		Set3D('up', self.up[1], self.up[2], self.up[3]) --三个参数都是控制整个背景旋转的，默认0,0,0.5就是正常的，一般不需要动
		Set3D('fovy', self.fovy[1]) --暂且认为是全局缩放，值越大看得越远
		Set3D('z', self.z[1], self.z[2]) --渲染范围
		Set3D('fog', self.fog[1], self.fog[2], Color(self.fog[3], self.fog[4], self.fog[5], self.fog[6])) --雾气
		--
		self.top = {} --最高层渲染
		self.static = {}
		self.fars = {} --远景（不受雾影响且渲染层数最低
		sence1Init(self)
		sence2Init(self)
		sence3Init(self)
	end
	--把视野中心重新设置成默认的初始值
	function BG:refreshEyeCen()
		eggbg.baseBG.setEyeCen(self, 0, 4, 6)
		eggbg.baseBG.updateEyeCen(self, 0, 0, 0)
	end
	--幻想乡上空
	function BG:Sence1()
		self.stage = 1
		self.timer = 0
		local x, y, z = eggbg.baseBG.getEyeCen(self)
		--远处星空
		self.board1 = creatFars(self, "board", x, y - 5, z + 40, { 90, -90 }, "", 255)
		self.barrier = creatFars(self, "barrier", x, y - 5, z + 40, { 90, -90 }, "", 0)
		self.board2 = creatFars(self, "board2", x, y - 15, z + 40, { 90, -90 }, "", 255)
		self.starlight = creatFars(self, "starlight", x, y - 5, z + 40, { 90, -90 }, "mul+add", 255)
		--云层底版
		cloudBoardsInit(self)
		--云层
		cloudInit(self, 10)
		--远处极光（静止
		lightsFarInit(self, x, y, z)
		--背景变化
		do
			--低头看手机
			eggbg.baseBG.setEyeRot(self, 145, 90)
			task.New(self, function()
				task.Wait(48 * 60) --48s抬起头，卧槽，好几把漂亮
				eggbg.baseBG.changeEyeRot1To(self, 95, 180)
				task.Wait(24 * 60) --72s道中boss，结界出现
				task.Wait(180)
				eggbg.baseBG.chObjAlpTo(self, self.barrier, 255, 120)
				--转场
				--task.Wait(180)
				while self.stage == 1 do
					task.Wait(1)
				end
				--eggbg.baseBG.setEyeRot(self, 95, 90)  --临时设置视角

				eggbg.baseBG.accDecEyePos(self, 0.35, { 90, 90 }, 100, 0, 100)
				cloudAlpTo0(self) --云消失
				task.Wait(200)
				BG.Sence2(self)
			end)
		end
	end
	--城市
	function BG:Sence2()
		--清理场景1
		local function clearSence1(self)
			task.New(self, function()
				eggbg.baseBG.chObjAlpTo(self, self.barrier, 0, 120)
				eggbg.baseBG.chObjAlpTo(self, self.board1, 0, 120)
				task.Wait(120)
				sence1Init(self) --清除场景1的特有表
				self.stage = 2
			end)
		end

		eggbg.baseBG.setEyeCen(self, 0, 4, 41)
		eggbg.baseBG.setFog(self, 30, 50, 255, 0, 0, 0)

		--创建城市场景
		st2Init(self)
		--背景变化
		do
			task.New(self, function()
				eggbg.baseBG.chObjAlpTo(self, self.city, 255, 120)
				eggbg.baseBG.accDecEyePos(self, 0.35, { 90, -90 }, 100, 0, 100)
				cityAppear(self) --城市渐出
				task.Wait(200)
				changeCityV(self, -0.15, 180)
				while self.stage == 2 do
					task.Wait(1)
				end
				eggbg.baseBG.accDecEyePos(self, 0.35, { 90, 90 }, 100, 49, 1) --往前冲！
				task.Wait(30)
				New(white)
				task.Wait(120)
				BG.Sence3(self)
			end)
		end
	end
	--八岳
	function BG:Sence3()
		sence2Init(self) --清理场景2
		st3Init(self)
	end
end
function BG:init(IsBoss)
	load_res()
	lstg.tmpvar.bg = self --给boss操作用的
	eggbg.baseBG.init(self)
	BG.setDefault(self)
	if IsBoss then
		BG.Sence3(self)
	else
		BG.Sence1(self)
	end
end
function BG:frame()
	background_open = setting.background
	if background_open then
		task.Do(self)
		starLightFrame(self)
		eggbg.baseBG.frame(self)
		cloudBoardsFrame(self)
		cloudFrame(self)
		lightsFrame(self)
		barrierFrame(self)
		st2Frame(self)
		st3Frame(self)
	end
end
function BG:render()
	if background_open then
		background.WarpEffectCapture()
		farsRender(self) --渲染最远处（雾覆盖不到
		--eggbg.baseBG.printParam(self) --打印背景相关参数，测试用
		eggbg.baseBG.render(self)
		cloudBoardsRender(self) --渲染底层云
		cloudRender(self) --渲染普通云朵
		topRender(self) --最高层渲染（无视雾）
		--lightsRender(self) --渲染极光
		st2Render(self)
		background.WarpEffectApply()
		--eggbg.baseBG.renderBlackBoard(self) --本来就够黑了，不渲染
	end
end

----------------------------------------]]
---导出定义

stage7_background = BG
