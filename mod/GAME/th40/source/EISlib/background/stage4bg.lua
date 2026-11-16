---======================================
---东方栖霞园四面背景
---by S7UPID
---======================================

local setting = database.setting

local M = EGGlib.BG
local B = M.baseBG
local C = M.comp
local background_open = setting.effect.background --背景开关选项
local ran = lstg.Rand() --给背景专门配发的随机种子生成器
local no_func = function() end
local ReadClass = M.ReadClass --背景素材读取类

--背景素材加载
local stage_name = "s4"
local path = "res/background/stage4/"
local reader = ReadClass.new(stage_name, path)
local s6_reader = ReadClass.new("s5", "res/background/stage6/")
local function loadRes()
	--三面
	local res_name = "s3_"
	local path = "res/background/stage3/"
	local filenames = {
		{"magic", "magic_bg"},
		{"cloud1", "cloud2", "ground1", "flower_fly1", "far1", "moutain1", "far_building1"},
		{"cloud3", "cloud4", "ground2", "flower_fly2", "far2", "moutain2", "far_building2", "star1"},
	}
	for i = 1, #filenames do
		for j = 1, #filenames[i] do
			LoadImageFromFile(res_name .. filenames[i][j], path .."part"..(i - 1).."/"..filenames[i][j] ..".png")
		end
	end
	--隧道贴图
	LoadTexture(res_name.."cave1", path .."part0/cave1.png")
	LoadTexture(res_name.."cave2", path .."part0/cave2.png")

	--四面
	local file
	local path = "res/background/stage4/"
	--general

	reader:loadBgImgFromFile("general", {"far_yellow", "moon"}) --folder_name, file_name_list
	reader:loadBgAniFromFile("general", {{"particle", 8, 2, 4}}) --folder_name, file_name_list
	--part1, part2
	local filenames = {"ground", "light", "wall", "roof", "far", "sky"}
	for i = 1, 2 do
		file = "part"..i
		reader:loadBgImgFromFile(file, filenames)
	end

	local file_name_list = {}
	for i = 1, 14 do
		file_name_list[i] = ""..i
	end
	--光柱
	reader:loadBgImgFromFile("golden_light", file_name_list)
	reader:loadBgImgFromFile("blue_light", file_name_list)
	--极光
	reader:loadBgImgFromFile("light", {"golden1", "golden2", "white1", "white2"}, path) --stage_name, folder_name, file_name_list, background_respath
	s6_reader:loadBgImgFromFile("light", {"blue1", "blue2", "white1", "white2"}, path) --stage_name, folder_name, file_name_list, background_respath
    --云雾
    reader:loadBgImgFromFile("fog", {"fog1", "fog2", "fog3"}, path) --stage_name, folder_name, file_name_list, background_respath
end

--闪黑
local flash = Class(object)
function flash:init()
	self.layer = LAYER_BG+50
	self.x, self.y = 0, 0
	self.img = "white"
	self.hscale, self.vscale = 100, 100
	robject.set_color(self, "", 0, 0, 0, 0)
	task.New(self, function()
		local d_a = 255/60
		for _ = 1, 60 do
			self._a = self._a + d_a
			task.Wait(1)
		end
		task.Wait(60)
		d_a = -255/40
		for _ = 1, 40 do
			self._a = self._a + d_a
			task.Wait(1)
		end
		Del(self)
	end)
end
function flash:frame()
	task.Do(self)
end
function flash:render()
	EGGlib.RenderEffect.defaultRenderImg(self)
end

--远景
local createFarComp = C.createComponentClassFunc(
--initFunc
		function(self)
			self.x, self.y = 0, 65
			local s = 0.5
			self.board = B.create2DBgObj(reader:getImg("part1", "sky"), 0, 0, 0, 1, 1, "", 255, 50, 50, 50)
			C.addBgObj(self, self.board)
			--蓝色夜空，默认不可见，关底使用
			self.sky = B.create2DBgObj(reader:getImg("part2", "sky"), 0, 0, 0, 1, 1, "", 0, 255, 255, 255)
			C.addBgObj(self, self.sky)
			--月亮（默认不可见）
			self.moon = B.create2DBgObj(reader:getImg("general", "moon"), 0, 175, 0, 0.25, 0.25, "", 0, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			C.addBgObj(self, self.moon)
			--蓝极光
			do
				self.isBlue = false
				self.timer = 0
				self.img_list = {}
				for i = 1, 14 do
					self.img_list[i] = reader:getImg("blue_light", ""..i)
				end
				self.blue_light_list = {}
				local x_list = {-150, 10, 150}
				local y_list = {100, 80, 70}
				local vscale_list = {1, 0.75, 0.75}
				local index_list, obj = {1, 5, 9}
				for i = 1, 3 do
					obj = B.create2DBgObj(self.img_list[index_list[i]], x_list[i], y_list[i], 0, 1, vscale_list[i], "mul+add", 0, 255, 255, 255)
					obj.img_index = index_list[i]
					C.addBgObj(self, obj)
					table.insert(self.blue_light_list, obj)
				end
			end
			--浅蓝色极光
			do
				local s = 1
				local x, y = 0, 100
				--极光（蓝）
				self.blue1 = B.create2DBgObj(s6_reader:getImg("light", "blue1"), x, y - 50*s, 0, s, s, "mul+add", 0, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
				C.addBgObj(self, self.blue1)
				self.blue2 = B.create2DBgObj(s6_reader:getImg("light", "blue2"), x, y, 0, -s, s, "mul+add", 0, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
				C.addBgObj(self, self.blue2)
				--极光（蓝白）
				self.cyan1 = B.create2DBgObj(s6_reader:getImg("light", "white1"), x, y - 50*s, 0, s, s, "mul+add", 0, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
				C.addBgObj(self, self.cyan1)
				self.cyan2 = B.create2DBgObj(s6_reader:getImg("light", "white2"), x, y, 0, -s, s, "mul+add", 0, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
				C.addBgObj(self, self.cyan2)
			end
			--远处的镇（暗）
			self.far0 = B.create2DBgObj(reader:getImg("part1", "far"), self.x, self.y, 0, s, s, "", 255, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			C.addBgObj(self, self.far0)
			--远处的镇（亮）
			self.far1 = B.create2DBgObj(reader:getImg("part2", "far"), self.x, self.y, 0, s, s, "", 0, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			C.addBgObj(self, self.far1)
			--用于过渡的黄光
			self.yellow_light_list = {}
			local obj
			local x_list = {-192, 192, -192, 192}
			local vx_list = {0.05, 0.05, -0.05, -0.05}
			for i = 1, 4 do
				obj = B.create2DBgObj(reader:getImg("general", "far_yellow"), x_list[i], 140, 0, 3, 1.5, "", 0, 255, 255, 255)
				obj.vx = vx_list[i]
				C.addBgObj(self, obj)
				table.insert(self.yellow_light_list, obj)
			end

			--开灯
			self.turnOn = function(isWait)
				if isWait then
					task.New(self, function()
						local t = 60
						local _a, d_a = 0, 255/t
						local rgb = 50
						local d_rgb = (255 - 50)/t
						--该交电费了.jpg
						for _ = 1, t do
							_a = _a + d_a
							rgb = rgb + d_rgb
							B.set2DBgObjColor(self.far0, 255 - _a, 255, 255, 255)
							B.set2DBgObjColor(self.far1, _a, 255, 255, 255)
							--[[for _, obj in pairs(self.yellow_light_list) do
								B.set2DBgObjColor(obj, _a*150/255, 255, 255, 255)
							end]]
							B.set2DBgObjColor(self.board, 255, rgb, rgb, rgb)
							task.Wait(1)
						end
					end)
				else
					B.set2DBgObjColor(self.far0, 0, 255, 255, 255)
					B.set2DBgObjColor(self.far1, 255, 255, 255, 255)
					B.set2DBgObjColor(self.board, 255, 255, 255, 255)
					--[[for _, obj in pairs(self.yellow_light_list) do
						B.set2DBgObjColor(obj, 150, 255, 255, 255)
					end]]
				end
			end
			--取消黄光
			self.disableYellowLight = function()
				for _, obj in pairs(self.yellow_light_list) do
					B.set2DBgObjColor(obj, 0, 255, 255, 255)
				end
			end
			--月亮出现
			self.showMoon = function()
				B.set2DBgObjColor(self.moon, 255, 255, 255, 255)
			end
			--夜空由黄变蓝
			self.changeSky = function()
				B.set2DBgObjColor(self.board, 0, 255, 255, 255)
				B.set2DBgObjColor(self.sky, 255, 255, 255, 255)
			end
			--出现蓝光柱
			self.showBlueLight = function()
				for _, obj in pairs(self.blue_light_list) do
					B.set2DBgObjColor(obj, 255, 255, 255, 255)
				end
			end
			--出现浅蓝极光
			self.showBlueAurora = function()
				B.set2DBgObjColor(self.blue1, 100, 255, 255, 255)
				B.set2DBgObjColor(self.blue2, 100, 255, 255, 255)
				self.isBlue = true
			end
		end,
--updateFunc
		function(self)
			do
				local bg = lstg.tmpvar.bg
				if IsValid(bg) then
					local s = min(1, 0.5 + 0.5*bg.timer/12160)
					B.set2DBgObjSize(self.far0, s, s)
					B.set2DBgObjSize(self.far1, s, s)
				end
			end
			B.set2DBgObjPos(self.far0, self.x, self.y)
			B.set2DBgObjPos(self.far1, self.x, self.y)
			task.Do(self)
			--道中金光拼接纹理
			for _, obj in pairs(self.yellow_light_list) do
				obj[2][2] = obj[2][2] + obj.vx
				if obj[2][2] >= 192 then
					obj[2][2] = obj[2][2] - 384
				elseif obj[2][2] <= -192 then
					obj[2][2] = obj[2][2] + 384
				end
			end
			--蓝光柱贴图切换
			--self.timer = self.timer + 1
			local objList = self.blue_light_list
			local obj
			if self.timer%6 == 0 then --差不多是3帧切换一次贴图
				for i = 1, #objList do
					obj = objList[i]
					obj.img_index = obj.img_index + 1
					if obj.img_index > 14 then
						obj.img_index = obj.img_index - 14
					end
					obj[2][1] = self.img_list[obj.img_index]
				end
			end
			--浅蓝极光
			if self.isBlue then
				local alpha = (1 + sin(3*self.timer))*0.5
				B.set2DBgObjColor(self.cyan1, alpha*100, 255, 255, 255)
				B.set2DBgObjColor(self.cyan2, alpha*100, 255, 255, 255)
			end
		end,
--is2D
		true
)


--极光
local createAuroraComp = C.createComponentClassFunc(
--initFunc
		function(self)
			local s = 1
			local _a = 100
			local x, y = 0, 100
			--极光（黄）
			self.golden1 = B.create2DBgObj(reader:getImg("light", "golden1"), x, y - 50*s, 0, s, s, "mul+add", _a, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			C.addBgObj(self, self.golden1)
			self.golden2 = B.create2DBgObj(reader:getImg("light", "golden2"), x, y, 0, -s, s, "mul+add", _a, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			C.addBgObj(self, self.golden2)
			--极光（黄白）
			self.white1 = B.create2DBgObj(reader:getImg("light", "white1"), x, y - 50*s, 0, s, s, "mul+add", _a, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			C.addBgObj(self, self.white1)
			self.white2 = B.create2DBgObj(reader:getImg("light", "white2"), x, y, 0, -s, s, "mul+add", _a, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			C.addBgObj(self, self.white2)



			C.setAlpha(self, 0)

			self.turnOn = function(isWait)
				if isWait then
					task.New(self, function()
						local t = 60
						local alpha, dalpha = 0, 1/t
						for _ = 1, t do
							alpha = alpha + dalpha
							C.setAlpha(self, alpha)
							task.Wait(1)
						end
					end)
				else
					C.setAlpha(self, 1)
				end
			end

		end,
--updateFunc
		function(self)
			task.Do(self)
			local alpha = (1 + sin(1*self.timer))*0.5
			B.set2DBgObjColor(self.white1, alpha*100, 255, 255, 255)
			B.set2DBgObjColor(self.white2, alpha*100, 255, 255, 255)
		end,
--is2D
		true
)

--特殊组件定义（黄极光
local createLightComp = C.createComponentClassFunc(
--initFunc
		function(self)
			self.timer = 0
			self.img_list = {}
			for i = 1, 14 do
				self.img_list[i] = reader:getImg("golden_light", ""..i)
			end
			self.isFog = true
		end,
--updateFunc
		function(self)
			C.advanceBgComponentUpdate(self) --包含动态背景的所有内容
			self.timer = self.timer + 1
			if self.timer%3 == 0 then --差不多是3帧切换一次贴图
				for _, obj in pairs(C.getBgObjList(self)) do
					obj.img_index = obj.img_index + 1
					if obj.img_index > 14 then
						obj.img_index = obj.img_index - 14
					end
					obj[1][1] = self.img_list[obj.img_index]
				end
			end
		end
)


--特殊组件定义（背景的粒子球
local createParticleComp = C.createComponentClassFunc(
--initFunc
        function(self)
        end,
--updateFunc
        function(self)
            local objList = C.getBgObjList(self)
            local obj

            if self.timer % 6 == 0 then
                obj = B.createBgObjDirectly("s4_general_particle", 1, 1, --img
                        ran:Float(-4, -2)*ran:Sign(), ran:Float(0, 3), ran:Float(10, 25), {ran:Float(95, 135), -90}, --x, y, z, rot
                        "", 0) --blend, a
                obj.vx = ran:Float(-0.02, 0.02)
                obj.img_index = ran:Int(1, 8)
                obj.vy = ran:Float(0.04, 0.05)
                obj.vz = ran:Float(-0.04, -0.05)
                obj.t = ran:Int(180, 240) --花能存活的时间
                obj._index = C.getBgObjNumber(self) + 1
                C.addBgObj(self, obj)
                for i = 1, #objList do
                    obj = objList[i]
                    obj.img_index = obj.img_index + 1
                    if obj.img_index >= 9 then
                        obj.img_index = obj.img_index - 8
                    end
                    obj[1][1] = "s4_general_particle"..obj.img_index --替换img
                end
            end
            local del_indexs = {}
            for i = 1, #objList do
                obj = objList[i]
                obj.t = obj.t - 1
                B.updateBgObjPos(obj, obj.vx, obj.vy, obj.vz) --位置更新
                if obj.t > 0 then --透明度变化
                    B.updateBgObjAlp(obj, 10)
                    if B.getBgObjAlp(obj) >= 255 then
                        B.setBgObjAlp(obj, 255)
                    end
                elseif obj.t > -30 then
                    B.updateBgObjAlp(obj, -10)
                    if B.getBgObjAlp(obj) >= 255 then
                        B.setBgObjAlp(obj, 255)
                    end
                else
                    table.insert(del_indexs, obj._index)
                end
            end
            local index
            for i = 1, #del_indexs do
                index = del_indexs[i] - i + 1
                table.remove(objList, index)
                for j = index, C.getBgObjNumber(self) do
                    obj = objList[j]
                    obj._index = obj._index - 1 --序号前移
                end
            end
        end
)

--最后场景的路灯
local createRoadLightComp = C.createComponentClassFunc(
--initFunc
		function(self)
			self.x0 = 180
			self.y0 = -300
			self.s0 = 0.5
			self.dt = 180
			self.n = 3
			self.T = self.n*self.dt
			self.dx = (340 - self.x0)/self.T
			self.dy = (-224 + 300)/self.T
			self.ds = 1.5/self.T
			local obj, t
			for i = 0, self.n - 1 do
				t = i*self.dt
				for u = -1, 1, 2 do
					obj = B.create2DBgObj(reader:getImg("part2", "light"), self.x0*u + self.dx*t*u, self.y0 + self.dy*t, 0, (self.s0 + self.ds*t)*u, self.s0 + self.ds*t, "", 255, 255, 255, 255)
					obj.u = u
					obj.x0 = self.x0*u
					obj.ax = 2*self.dx*u/self.T
					obj.vx = obj.ax*t
					obj.ay = 2*self.dy/self.T
					obj.vy = obj.ay*t
					obj.timer = t
					C.addBgObj(self, obj)
				end
			end
		end,
--updateFunc
		function(self)
			local move_list = {}
			for i, obj in pairs(self.bg_objs) do
				obj.timer = obj.timer + 1
				--处理位置和大小
				obj.vx = obj.vx + obj.ax
				obj.vy = obj.vy + obj.ay
				obj[2][2] = obj[2][2] + obj.vx
				obj[2][3] = obj[2][3] + self.dy
				obj[2][5] = obj[2][5] + self.ds*obj.u
				obj[2][6] = obj[2][6] + self.ds
				--处理color
				obj[1][2] = min(255, obj[1][2] + 3)
				obj[1][3] = min(255, obj[1][3] + 3)
				obj[1][4] = min(255, obj[1][4] + 3)
				obj[1][5] = min(255, obj[1][5] + 3)
				if obj.timer >= self.T then
					obj.timer = obj.timer - self.T
					B.set2DBgObjColor(obj, 0, 0, 0, 0)
					B.set2DBgObjPos(obj, obj.x0, self.y0)
					B.set2DBgObjSize(obj, self.s0*obj.u, self.s0)
					obj.vx, obj.vy = 0, 0
					table.insert(move_list, table.remove(self.bg_objs, i))
				end
			end
			for _, obj in pairs(move_list) do
				table.insert(self.bg_objs, 1, obj)
			end
		end,
		--is2D
		true
)

---背景定义
local BG = Class(B)
do
	local bg_vz = -0.075
	--背景容器
	local coms = {
		["dark"] = nil,
		["light"] = nil,
	}
	local function setComponent(key, component)
		coms[key] = component
		return component
	end
	local function getComponent(key)
		if coms[key] then
			return coms[key]
		end
		return nil
	end
	local function addScence1Component(self)
		B.addBgComponent(self, getComponent("far"))
		B.addBgComponent(self, getComponent("ground"))
		B.addBgComponent(self, getComponent("wall"))
		B.addBgComponent(self, getComponent("roof"))
		B.addBgComponent(self, getComponent("light"))
		B.addBgComponent(self, getComponent("golden_light"))
		--B.addBgComponent(self, getComponent("aurora"))
		C.setAlpha(getComponent("golden_light"), 0)
        B.addBgComponent(self, getComponent("fog"))
		B.addBgComponent(self, getComponent("mask"))
	end
	local function addAllComponent(self)
		B.addBgComponent(self, getComponent("far"))
		B.addBgComponent(self, getComponent("ground"))
		B.addBgComponent(self, getComponent("wall"))
		B.addBgComponent(self, getComponent("roof"))
		B.addBgComponent(self, getComponent("light"))
		B.addBgComponent(self, getComponent("golden_light"))
		--B.addBgComponent(self, getComponent("aurora"))
		getComponent("aurora").turnOn()
		--B.addBgComponent(self, getComponent("particle"))
		--远景贴图点亮
		local far_com = getComponent("far")
		--C.setAlpha(far_com, 1)
		far_com.turnOn()
		--把背景元素点亮
		local coms = {getComponent("ground"), getComponent("wall"), getComponent("light")}
		for _, v in pairs(coms) do
			C.setAlpha(v, 0.01)
		end
        B.addBgComponent(self, getComponent("fog"))
		local fog = getComponent("fog")
		C.setAlpha(fog, 0.5)
		B.addBgComponent(self, getComponent("mask"))
	end
	function BG:setDefault()
		bg_vz = -0.075

		--region 创建背景容器

		--远景
		do
			local com_name = "far"
			setComponent(com_name, createFarComp(com_name, false))
		end

		--远景前的极光
		do
			local com_name = "aurora"
			setComponent(com_name, createAuroraComp(com_name, false))
		end


		--两侧
		do
			local com_name = "wall"
			local num_l, num_w = 6, 2
			local len, hei = 10, 8.75
			local wide = 20
			local com = setComponent(com_name, M.createAdvanceBgComponent2(com_name, 0, num_l*len, bg_vz, true)) --注意函数名有个2，与正常的不一样
			C.addBgObjs(com,
					B.createTileBgObjsTableDirectly({reader:getImg("part1", "wall"), reader:getImg("part2", "wall")}, len, hei, --传入两个img
							0, 0.5*hei, 0, {90, 180}, --x, y, z, rot,
							"", 255, 255, 255, 255, --blend, _a, _r, _g, _b,
							num_l, {90, 90}, len, --num_l, a0, dist,
							num_w, 0, wide  --num_w, a1, w
					)
			)
			C.sortByZ(com)

			local com_name = "roof"
			local num_l2 = 6
			local len2, hei2 = 10, 7.5
			local com = setComponent(com_name, M.createAdvanceBgComponent2(com_name, 0, num_l2*len2, bg_vz, true)) --注意函数名有个2，与正常的不一样
			local rot, rot3, dx, dy, objs
			for i = 0, 1 do
				rot = {60, 180*(1-i)}
				--rot3 = EGGlib.Math.BallToVec3(rot)
				objs = B.createTileBgObjsTableDirectly({reader:getImg("part1", "roof"), reader:getImg("part2", "roof")}, len2, hei2, --传入两个img
						0.5*tranU(i)*wide, hei - 0.5, 0.00001, rot, --x, y, z, rot,
						"", 255, 255, 255, 255, --blend, _a, _r, _g, _b,
						num_l2, {90, 90}, len2, --num_l, a0, dist,
						1, 0, 0  --num_w, a1, w
				)
				for _, o in pairs(objs) do
					B.setObjAngle(o, 30*tranU(i))
					rot3 = B.getRotParallelToObj(o)
					dx, dy = -0.5*hei2*rot3[1], -0.5*hei2*rot3[2] --在中心坐标加上此值，即可换算为脚坐标
					B.updateBgObjPos(o, dx, dy, 0)
				end
				C.addBgObjs(com, objs)
			end
			C.sortByZ(com)
		end

		--中间道路
		do
			local com_name = "ground"
			local num_l, num_w = 6, 1
			local wide, len = 20, 10
			local com = setComponent(com_name, M.createAdvanceBgComponent2(com_name, 0, num_l*len, bg_vz, true)) --注意函数名有个2，与正常的不一样
			C.addBgObjs(com,
					B.createTileBgObjsTableDirectly({reader:getImg("part1", "ground"), reader:getImg("part2", "ground")}, wide, len, --传入两个img
							0, 0, 10, {0, 90}, --x, y, z, rot,
							"", 255, 255, 255, 255, --blend, _a, _r, _g, _b,
							num_l, {90, 90}, len, --num_l, a0, dist,
							num_w, 0, wide  --num_w, a1, w
					)
			)
			C.sortByZ(com)
		end

		--两侧路灯
		do
			local com_name = "light"
			local num_l, num_w = 6, 2
			local wide, len = 15, 10
			local w_l, hei = 3, 9
			local com = setComponent(com_name, M.createAdvanceBgComponent2(com_name, 0, num_l*len, bg_vz, true)) --注意函数名有个2，与正常的不一样
			C.addBgObjs(com,
					B.createTileBgObjsTableDirectly({reader:getImg("part1", "light"), reader:getImg("part2", "light")}, w_l, hei, --传入两个img
							0, 0.453*hei, 0, {90, -90}, --x, y, z, rot,
							"", 255, 255, 255, 255, --blend, _a, _r, _g, _b,
							num_l, {90, 90}, len, --num_l, a0, dist,
							num_w, 0, wide,  --num_w, a1, w
							true --isSymmetry
					)
			)
			C.sortByZ(com)
		end

		--中间的蓝极光
		do
			local com_name = "golden_light"
			local num_l = 6
			local dist = 10
			local com = setComponent(com_name, createLightComp(com_name, true))
			C.advanceBgComponentClass.implement(com, com_name, 0, num_l*dist, bg_vz, false, false) --只能在这里面初始化一下了，不然会报错的
			local function creatLights(com, index, x, y, z, rot, angle)
				local obj = B.createBgObj2Directly(reader:getImg("golden_light", "1"), 30, 40.5, x, y, z, rot, "mul+add", 200, 255, 255, 255, angle)
				obj.img_index = index
				C.addBgObj(com, obj)
			end
			local function init(com, x, y, z)
				local x_random = {-5.5, 5, -4, 4.5, -4.75, 4.25, -5.5, 5.25, -5.5, -5.75}
				local y_random = {-1.4, -1.0, -2.0, -2.2, -1.5, -2.4, -2.8, -0.8, -1.7, -0.3}
				local img_random = {4, 2, 8, 7, 5, 1, 11, 3, 6, 9}
				for i = 1, num_l do
					creatLights(com, img_random[i], x + x_random[i], y + y_random[i], z + dist*(i-1), { 90 - 15*0, 0*180*(i%2) }, 180 - 0*15*tranU(i))
				end
			end
			init(com, 0, 0, 0)
			C.sortByZ(com)
		end

        --背景粒子
        do
            local com_name = "particle"
            setComponent(com_name, createParticleComp(com_name, false))
        end


		--暗色遮罩
		do
			local com_name = "mask"
			local com = M.create2DBgComponent(com_name)
			setComponent(com_name, com)
			C.addBgObj(com, B.create2DBgObj("absorb_halation", 0, 144, 0, 4, 4, "mul+rev", 255, 192, 160, 64))
		end

		--关底路灯
		do
			local com_name = "road_light"
			setComponent(com_name, createRoadLightComp(com_name, false))
		end

        --高速雾
        do
            local com_name = "fog"
            local num_l = 6
            local len = 10
            local imgs = {
                reader:getImg("fog", "fog1"), reader:getImg("fog", "fog2"), reader:getImg("fog", "fog3")
            }
            local index_list = {2, 1, 1, 2, 3, 2, 2, 2, 1, 3, 1, 2}

            local com = setComponent(com_name, M.createAdvanceBgComponent(com_name, 0, num_l*len, bg_vz, true))
            local index = 1
            for i = 0, num_l - 1 do
                for u = -1, 1, 2 do
                    C.addBgObj(com,
                            B.createBgObjDirectly(imgs[index_list[index]], 50, 40*u,  --img, w, h
                                    17.5*u, 10, 0 + 0.00001*u + len*i, {90, 90}, --x, y, z, rot
                                    "mul+add", 0) --blend, a
                    )
                    index = index + 1
                end
            end
            C.setAlpha(com, 1)
            C.sortByZ(com)
        end
		--endregion
	end


	--1四开接的就是3末
	function BG:Sence1(practice)
		stage3_background.Sence5(self, true, true) --bg, practice, isStage4
		do
			task.New(self, function()
				task.Wait(60)
				local t0, t1, t2 = 119, 1, 1
				B.accDecEyePos(self, 0.25, {90, 90}, t0, t1, t2) --往前
				task.Wait(t0 + t1 + t2 - 60)
				New(flash) --添加黑色渐变效果
				task.Wait(60)
				B.removeAllBgComponent(self) --全黑后移除所有（三面的）组件
				BG.setDefault(self)
				B.setBaseParam(self,
						{0, 8, 6}, --eye_cen,
						{95, 90}, --eye_rot, --抬头
						0, --v,
						{90, -90}, --a,
						{90, 90}, --up_rot,
						1.5, --fovy,
						{0.1, 100}, --z
						{0, 10, 255, 0, 0, 0} --fog 全黑
				)
				addScence1Component(self)
				--addAllComponent(self)
				--task.Wait(120)
				--列出会动的物体
				local advance = {getComponent("ground"), getComponent("wall"), getComponent("light"), getComponent("roof"), getComponent("golden_light")}
				local coms = {getComponent("ground"), getComponent("wall"), getComponent("light"), getComponent("roof")}
				--减速
				local function changeVelocityZ(vz, t)
					local dbg_vz = (vz - bg_vz)/t
					for _ = 1, t do
						bg_vz = bg_vz + dbg_vz
						for _, v in pairs(advance) do
							if v.setV then
								v.setV(v, bg_vz)
							else
								v.v = bg_vz
							end
						end
						task.Wait(1)
					end
				end
				changeVelocityZ(-0.0125, 120)
				--逐渐变亮
				local t = 210
				local dr0, dr1 = B.getFogRange(self)
				dr0 = (10 - dr0)/t
				dr1 = (25 - dr1)/t
				for _ = 1, t do
					B.updateFogRange(self, 0, dr1)
					task.Wait(1)
				end
				--灯闪烁
				local function lightChange(t, alp0, alp1)
					local alp, dalp = alp0, (alp1 - alp0)/t
					for _ = 1, t do
						alp = alp + dalp
						for _, v in pairs(coms) do
							C.setAlpha(v, alp)
						end
						task.Wait(1)
						B.setFogRange(self, 10 + 5*alp, 25)
					end
				end
				--task.Wait(180)
				for _ = 1, 4 do
					lightChange(5, 1, 0)
					lightChange(5, 0, 1)
				end
				lightChange(30, 1, 0)
				local t = 60
				local _, d_r0, d_g0, d_b0 = B.getFogColor(self)
				d_r0, d_g0, d_b0 = (0-d_r0)/t, (0-d_g0)/t, (0-d_b0)/t
				local far_com = getComponent("far")
				local golden_com = getComponent("golden_light")
				local aurora_com = getComponent("aurora")
				local fog_com = getComponent("fog")
				far_com.turnOn(true)
				aurora_com.turnOn(true)
				local alpha, dalpha = 0, 1/t
				local dr0, dr1 = B.getFogRange(self)
				dr0 = (10 - dr0)/t
				dr1 = (45 - dr1)/t
				local f_a, df_a = 1, -0.5/t
				for _ = 1, t do
					alpha = alpha + dalpha
					B.updateFogRange(self, dr0, dr1)
					B.updateFogColor(self, 0, d_r0, d_g0, d_b0)
					C.setAlpha(golden_com, 0.35*alpha)
					f_a = f_a + df_a
					C.setAlpha(fog_com, f_a)
					task.Wait(1)
				end
				changeVelocityZ(-0.0425, 180)
                task.Wait(970)
                local t = 150
				alpha, dalpha = 0, 1/t
                for _ = 1, t do
					alpha = alpha + dalpha
					--C.setAlpha(golden_com, (1 - alpha))
                    task.Wait(1)
                end
				BG.Sence2(self, false)
			end)
		end
	end

	--1700 - 4800   total = 3100
	function BG:Sence2(practice)
		if practice then
			self.timer = 1700
			B.setBaseParam(self,
					{0, 8, 6}, --eye_cen,
					{95, 90}, --eye_rot, --抬头
					0, --v,
					{90, -90}, --a,
					{90, 90}, --up_rot,
					1.5, --fovy,
					{0.1, 100}, --z
					{10, 45, 255, 0, 0, 0} --fog 金
			)
			addAllComponent(self)
			--设置背景移动速度
			bg_vz = -0.0425
		end
		do
			task.New(self, function()
				local R = lstg.tmpvar.current_road
				--判断是否进入场景2
				while R.class.getSence(R) ~= 2 do
					task.Wait(1)
				end
				task.Wait(3100)
				BG.Sence3(self, false)
			end)
		end
	end

	--4800 - 6080 = 1280
	function BG:Sence3(practice)
		if practice then
			B.removeAllBgComponent(self)
			self.timer = 4800
			B.setBaseParam(self,
					{0, 8, 6}, --eye_cen,
					{95, 90}, --eye_rot, --抬头
					0, --v,
					{90, -90}, --a,
					{90, 90}, --up_rot,
					1.5, --fovy,
					{0.1, 100}, --z
					{10, 45, 255, 0, 0, 0} --fog 金
			)
			addAllComponent(self)
			local far_com = getComponent("far")
			far_com.y = 65
			--设置背景移动速度
			bg_vz = -0.0425
		end
		do
			task.New(self, function()
				local R = lstg.tmpvar.current_road
				if IsValid(R) then --R存在说明是有道中的，否则只是单纯为莉莉的道中boss练习提供服务
					--判断是否进入场景3
					while R.class.getSence(R) ~= 3 do
						task.Wait(1)
					end
					task.Wait(1280)
					BG.Sence4(self, false)
				end
			end)
		end
	end

	--6080 - 8040 = 1960
	function BG:Sence4(practice)
		if practice then
			self.timer = 6080
			B.setBaseParam(self,
					{0, 8, 6}, --eye_cen,
					{95, 90}, --eye_rot, --抬头
					0, --v,
					{90, -90}, --a,
					{90, 90}, --up_rot,
					1.5, --fovy,
					{0.1, 100}, --z
					{10, 45, 255, 0, 0, 0} --fog 金
			)
			addAllComponent(self)
			--设置背景移动速度
			bg_vz = -0.0425
		end
		do
			task.New(self, function()
				local R = lstg.tmpvar.current_road
				--判断是否进入场景4
				while R.class.getSence(R) ~= 4 do
					task.Wait(1)
				end
				task.Wait(1960)
				BG.Sence5(self, false)
			end)
		end
	end

	--8040 - 10420 = 2380
	function BG:Sence5(practice)
		if practice then
			self.timer = 8370
			B.setBaseParam(self,
					{0, 8, 6}, --eye_cen,
					{95, 90}, --eye_rot, --抬头
					0, --v,
					{90, -90}, --a,
					{90, 90}, --up_rot,
					1.5, --fovy,
					{0.1, 100}, --z
					{10, 45, 255, 0, 0, 0} --fog 金
			)
			addAllComponent(self)
			--设置背景移动速度
			bg_vz = -0.0425
		end
		do
			task.New(self, function()
				local R = lstg.tmpvar.current_road
				--判断是否进入场景5
				while R.class.getSence(R) ~= 5 do
					task.Wait(1)
				end
				task.Wait(2380)
				BG.Sence6(self, false)
			end)
		end
	end

	function BG:Sence6(practice)
		if practice then
			self.timer = 10750
			B.setBaseParam(self,
					{0, 8, 6}, --eye_cen,
					{95, 90}, --eye_rot, --抬头
					0, --v,
					{90, -90}, --a,
					{90, 90}, --up_rot,
					1.5, --fovy,
					{0.1, 100}, --z
					{10, 45, 255, 0, 0, 0} --fog 金
			)
			addAllComponent(self)
			--设置背景移动速度
			bg_vz = -0.0425
		end
		do
			task.New(self, function()
				local R = lstg.tmpvar.current_road
				--判断是否进入场景6
				while R.class.getSence(R) ~= 6 do
					task.Wait(1)
				end
				task.Wait(1600)
				local advance = {getComponent("ground"), getComponent("wall"), getComponent("light"), getComponent("roof"), getComponent("golden_light")}
				local t0, t1, t2 = 119, 1, 1
				--设置速度
				local function changeVelocityZ(vz, t)
					local dbg_vz = (vz - bg_vz)/t
					for _ = 1, t do
						bg_vz = bg_vz + dbg_vz
						for _, v in pairs(advance) do
							if v.setV then
								v.setV(v, bg_vz)
							else
								v.v = bg_vz
							end
						end
						task.Wait(1)
					end
				end
				changeVelocityZ(-0.25, t0 + t1 + t2 - 60)
				--B.accDecEyePos(self, 0.25, {90, 90}, t0, t1, t2) --往前
				--task.Wait(t0 + t1 + t2 - 60)
				New(flash) --添加黑色渐变效果
				task.Wait(60)
				--self.timer = 12160
				B.removeAllBgComponent(self) --全黑后移除所有组件
				BG.setDefault(self)
				B.setBaseParam(self,
						{0, 4, 6}, --eye_cen,
						{95, 90}, --eye_rot, --抬头
						0, --v,
						{90, -90}, --a,
						{90, 90}, --up_rot,
						1.5, --fovy,
						{0.1, 100}, --z
						{10, 30, 255, 0, 0, 0} --fog 全黑
				)
				local far = getComponent("far")
				B.addBgComponent(self, far)
				far.showBlueLight()
				far.turnOn()
				far.disableYellowLight()
				far.showMoon()
				far.changeSky()
				far.showBlueAurora()
				C.setAlpha(far, 1)
				B.addBgComponent(self, getComponent("road_light"))
				far.y = -142
				local t = 240
				local dy = 2*(-98 - far.y)/t
				local d_dy = -dy/t
				for _ = 1, t do
					dy = dy + d_dy
					far.y = far.y + dy
					task.Wait(1)
				end
			end)
		end
	end

	--boss场景
	function BG:Sence7(practice)
		self.timer = 12160
		if practice then
			B.setBaseParam(self,
					{0, 4, 6}, --eye_cen,
					{95, 90}, --eye_rot, --抬头
					0, --v,
					{90, -90}, --a,
					{90, 90}, --up_rot,
					1.5, --fovy,
					{0.1, 100}, --z
					{10, 30, 255, 0, 0, 0} --fog 全黑
			)
			local far = getComponent("far")
			B.addBgComponent(self, far)
			far.turnOn()
			far.disableYellowLight()
			far.showMoon()
			far.changeSky()
			far.showBlueLight()
			far.showBlueAurora()
			C.setAlpha(far, 1)
			B.addBgComponent(self, getComponent("road_light"))
			far.y = -98
		end
		do
		end
	end
end
function BG:init(sence)
	loadRes()

	lstg.tmpvar.bg = self --给boss操作用的
	B.init(self) --默认背景类的构造方法
	BG.setDefault(self) --该背景的构造方法

	local t = {BG.Sence1, BG.Sence2, BG.Sence3, BG.Sence4, BG.Sence5, BG.Sence6, BG.Sence7}
	if not sence or sence == 0 then --主线模式
		BG.Sence1(self)
	elseif type(sence) == "boolean" then --boss模式
		t[7](self, true)
	else --道中分段练习模式
		sence = min(7, sence)
		t[sence](self, true)
	end
end
function BG:frame()
	background_open = setting.effect.background
	if background_open then
		B.frame(self)
		--B.setUpRot(self, 90, 90 + 0.5*sin(0.25*(self.timer - 1800))) --添加摇晃的效果
	end
end
function BG:render()
	if background_open then
		B.render(self)
		--B.printParam(self) --打印背景相关参数，测试用
		--B.renderBlackBoard(self) --本来就够黑了，不渲染
	end
end

----------------------------------------]]
---导出定义

stage4_background = BG
