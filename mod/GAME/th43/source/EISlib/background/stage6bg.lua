---======================================
---东方栖霞园六面背景
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
local square_stroke = M.square_stroke --绘制方形边界的img
local FallingObjectInterface = M.FallingObjectInterface --背景飘落物接口
local defaultRenderImg = EGGlib.RenderEffect.defaultRenderImg
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange

--背景素材加载
local stage_name = "s6"
local path = "res/background/stage6/"
local reader = ReadClass.new(stage_name, path)
local s5_reader = ReadClass.new("s5", "res/background/stage5/")
local function loadRes()
	--general
	reader:loadBgImgFromFile("general", {"window", "window_shadow"}, path) --stage_name, folder_name, file_name_list, background_respath
	--part1, part2
	reader:loadBgImgFromFile("red", {"far", "line", "pillar"}, path) --stage_name, folder_name, file_name_list, background_respath
	reader:loadBgImgFromFile("purple", {"far", "line", "pillar"}, path) --stage_name, folder_name, file_name_list, background_respath
	--broken
	local file_name_list = {}
	for i = 1, 98 do
		file_name_list[i] = i
	end
	reader:loadBgImgFromFile("broken", file_name_list, path) --stage_name, folder_name, file_name_list, background_respath
	--破窗之后的场景
	reader:loadBgImgFromFile("part2", {"cloud1", "cloud2", "cloud3", "ground", "moon", "sky", "star", "palace0", "palace1", "leaf", "snow"}, path) --stage_name, folder_name, file_name_list, background_respath
	--极光
	reader:loadBgImgFromFile("light", {"blue1", "blue2", "white1", "white2"}, path) --stage_name, folder_name, file_name_list, background_respath
	--stage5 前半场景
	local filenames = {"far", "pillar", "cloud", "moon", "star1", "star2", "star3",
					   "moon2", "star4", "star5", "star6",
					   "ball1", "ball2", "ball3", "cave", "particle"}
	s5_reader:loadBgImgFromFile("purple", filenames)
end

--闪白
local flash = Class(object)
function flash:init()
	self.layer = LAYER_PLAYER - 2
	self.x, self.y = 0, 0
	self.img = "white"
	self.hscale, self.vscale = 100, 100
	robject.set_color(self, "", 0, 255, 255, 255)
	task.New(self, function()
		local t = 10
		local d_a = 255/t
		for _ = 1, t do
			self._a = self._a + d_a
			task.Wait(1)
		end
		task.Wait(45)
		t = 60
		d_a = -255/t
		for _ = 1, t do
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

--云雾转场
local fog = Class(object)
function fog:init()
	self.x, self.y = 0, 224
	self.img = reader:getImg("part2", "cloud1")
	self.hscale, self.vscale = 1, 1
	self.group = GROUP_GHOST
	self.layer = LAYER_TOP
	self.rot = ran:Float(0, 360)
	self.omiga = ran:Float(0.25, 0.5)*ran:Sign()
	robject.set_color(self, "", 0, 255, 255, 255)
	velchTask(self, 0, ran:Float(24, 32), ran:Float(-60, -120), 60)
	self.bound = false
	task.New(self, function()
		alphaAndSizeChange(self, 75, 4, 10)
		alphaAndSizeChange(self, -75, 16, 40)
		_del(self, false)
	end)
end
function fog:frame()
	task.Do(self)
end
function fog:render()
	defaultRenderImg(self)
end

--碎玻璃
local broken = Class(object)
function broken:init()
	self.img = "s6_broken_1"
	self.layer = LAYER_PLAYER - 1
	self.hscale, self.vscale = 6, 6
	robject.set_color(self, "", 0, 255, 255, 255)
	task.New(self, function()
		local t = 30
		local d_a = (255 - self._a)/t
		for _ = 1, t do
			self._a = self._a + d_a
			task.Wait(1)
		end
		t = 60
		while self.timer < 78 do
			task.Wait(1)
		end
		d_a = (0 - self._a)/t
		for _ = 1, t do
			self._a = self._a + d_a
			task.Wait(1)
		end
		Del(self)
	end)
end
function broken:frame()
	task.Do(self)
	local index = self.timer
	if index > 0 and index <= 98 then
		self.img = "s6_broken_"..index
	elseif index > 98 then
		Del(self)
	end
end
function broken:render()
	EGGlib.RenderEffect.defaultRenderImg(self)
end

--地面景物和远景
local createGroundComp = C.createComponentClassFunc(
--initFunc
		function(self)
			C.addBgObj(self,
					B.create2DBgObj(reader:getImg("part2", "sky"), 0, 0, 0, 1, 1, "", 255, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			)

			--闪闪星星
			self.star_list = {}
			self.star_dy = 224
			self.star_d_dy = 0

			local s = 1.4
			--会闪
			self.star_list[1] = B.create2DBgObj(reader:getImg("part2", "star"), 0, self.star_dy, 0, s, s, "mul+add", 0, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			self.star_list[3] = B.create2DBgObj(reader:getImg("part2", "star"), 0, self.star_dy + 498*s, 0, s, s, "mul+add", 0, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			--不会闪
			self.star_list[2] = B.create2DBgObj(reader:getImg("part2", "star"), 0, self.star_dy, 0, s, s, "mul+add", 255, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			self.star_list[4] = B.create2DBgObj(reader:getImg("part2", "star"), 0, self.star_dy + 498*s, 0, s, s, "mul+add", 255, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b

			self.updateStarY = function()
				self.star_dy = self.star_dy + self.star_d_dy
				if self.star_dy <= 224 - 1.5*498*s then
					self.star_dy = self.star_dy + 498*s
				end
				--会闪
				B.set2DBgObjPos(self.star_list[1], 0, self.star_dy)
				B.set2DBgObjPos(self.star_list[3], 0, self.star_dy + 498*s)
				--不会闪
				B.set2DBgObjPos(self.star_list[2], 0, self.star_dy)
				B.set2DBgObjPos(self.star_list[4], 0, self.star_dy + 498*s)
			end
			C.addBgObjs(self, self.star_list)

			--地面
			local obj = B.create2DBgObj(reader:getImg("part2", "ground"), 0, 200, 0, 1.5, 1.5, "", 0, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			self.ground = obj
			C.addBgObj(self, obj)
		end,
--updateFunc
		function(self)
			--更新位置
			self.updateStarY()
			--繁星闪烁
			local x = 3*self.timer
			local alpha = min(1, max(0, (self.timer - 1200)/600)) --一开始不显示
			for i = 1, 3, 2 do
				B.set2DBgObjColor(self.star_list[i], alpha*255*0.5*(1 + sin(x + 180*i)), 255, 255, 255)
			end
			for i = 2, 4, 2 do
				B.set2DBgObjColor(self.star_list[i], alpha*255, 255, 255, 255)
			end
		end,
		--is2D
		true
)


--极光
local createLightComp = C.createComponentClassFunc(
--initFunc
		function(self)
			local s = 1
			local _a = 100
			local x, y = 0, 150
			--极光（蓝）
			self.blue1 = B.create2DBgObj(reader:getImg("light", "blue1"), x, y - 50*s, 0, s, s, "mul+add", _a, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			C.addBgObj(self, self.blue1)
			self.blue2 = B.create2DBgObj(reader:getImg("light", "blue2"), x, y, 0, -s, s, "mul+add", _a, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			C.addBgObj(self, self.blue2)
			--极光（白）
			self.white1 = B.create2DBgObj(reader:getImg("light", "white1"), x, y - 50*s, 0, s, s, "mul+add", _a, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			C.addBgObj(self, self.white1)
			self.white2 = B.create2DBgObj(reader:getImg("light", "white2"), x, y, 0, -s, s, "mul+add", _a, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			C.addBgObj(self, self.white2)
		end,
--updateFunc
		function(self)
			local alpha = (1 + sin(self.timer))*0.5
			B.set2DBgObjColor(self.white1, alpha*100, 255, 255, 255)
			B.set2DBgObjColor(self.white2, alpha*100, 255, 255, 255)
		end,
--is2D
		true
)

--大月亮
local createMoonComp = C.createComponentClassFunc(
--initFunc
		function(self)
			--self._dy = 300
			self._dy = 150
			--普通月亮
			self.normal_moon = B.create2DBgObj(reader:getImg("part2", "moon"), 0, self._dy, 0, 0.3, 0.3, "", 0, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			C.addBgObj(self, self.normal_moon)
			--更新宫殿位置参数
			self.updateY = function()
				B.set2DBgObjPos(self.normal_moon, 0, self._dy)
			end
		end,
--updateFunc
		function(self)
			self.updateY()
			task.Do(self)
			--月亮出现
			local alpha = min(1, max(0, (self.timer - 1200)/600)) --一开始不显示
			B.set2DBgObjColor(self.normal_moon, alpha*255, 255, 255, 255)
		end,
--is2D
		true
)

--清泉宫
local createPalaceComp = C.createComponentClassFunc(
--initFunc
		function(self)
			local s = 0.5
			self._dy = 0
			--宫殿（暗）
			self.palace0 = B.create2DBgObj(reader:getImg("part2", "palace0"), 0, -450 + self._dy, 0, s, s, "", 255, 150, 150, 150) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			self.shadow0 = B.create2DBgObj(reader:getImg("part2", "palace0"), 0, -450 + self._dy - 350*s, 0, s, -s, "", 50, 150, 150, 150) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			C.addBgObj(self, self.shadow0)
			C.addBgObj(self, self.palace0)
			--宫殿（亮）
			self.palace1 = B.create2DBgObj(reader:getImg("part2", "palace1"), 0, -450 + self._dy, 0, s, s, "", 0, 150, 150, 150) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			self.shadow1 = B.create2DBgObj(reader:getImg("part2", "palace1"), 0, -450 + self._dy - 350*s, 0, s, -s, "", 0, 150, 150, 150) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			C.addBgObj(self, self.shadow1)
			C.addBgObj(self, self.palace1)
			--更新宫殿位置参数
			self.updateY = function()
				B.set2DBgObjPos(self.palace0, 0, -450 + self._dy)
				B.set2DBgObjPos(self.palace1, 0, -450 + self._dy)
				B.set2DBgObjPos(self.shadow0, 0, -450 + self._dy - 350*s)
				B.set2DBgObjPos(self.shadow1, 0, -450 + self._dy - 350*s)
			end
			--宫殿开灯
			self.turnOn = function()
				task.New(self, function()
					local t = 10
					local _a, d_a = 0, 255/t
					--该交电费了.jpg
					for _ = 1, 4 do
						for _ = 1, t do
							_a = _a + d_a
							B.set2DBgObjColor(self.palace0, 255 - _a, 255, 150, 150, 150)
							B.set2DBgObjColor(self.palace1, _a, 255, 150, 150, 150)
							B.set2DBgObjColor(self.shadow0, (255 - _a)*50/255, 255, 150, 150, 150)
							B.set2DBgObjColor(self.shadow1, _a*50/255, 255, 150, 150, 150)
							task.Wait(1)
						end
						d_a = -d_a
					end

					PlaySound("lamp")
					local rgb, d = 150, (255 - 150)/t
					for _ = 1, t do
						rgb = rgb + d
						_a = _a + d_a
						B.set2DBgObjColor(self.palace0, 255 - _a, 255, 150, 150, 150)
						B.set2DBgObjColor(self.palace1, _a, 255, rgb, rgb, rgb)
						B.set2DBgObjColor(self.shadow0, (255 - _a)*150/255, 255, 150, 150, 150)
						B.set2DBgObjColor(self.shadow1, _a*150/255, 255, rgb, rgb, rgb)
						task.Wait(1)
					end
				end)
			end
		end,
--updateFunc
		function(self)
			self.updateY()
			task.Do(self)
		end,
--is2D
		true
)

--画面上快速飞过的叶子
local createLeafComp = C.createComponentClassFunc(
--initFunc
		function(self)
			--生成范围
			self.center_x, self.center_y, self.center_z = 0, -2.5, 60
			self.x_range, self.y_range, self.z_range = 30, 10, 0
			--生成角度
			self.theta, self.phi = 90, -90 --θ,φ
			self.theta_range, self.phi_range = 0, 0
			--test
			--[[C.addBgObj(self, B.createBgObjDirectly(square_stroke, self.x_range, self.y_range, --img, w, h
					self.center_x, self.center_y, self.center_z, {90, -90}, --x, y, z, rot
					"", 255) --blend, a
			)]]
		end,
--updateFunc
		function(self)
			if self.timer % 2 == 0 then
				local s = ran:Float(1.25, 1.75)
				local obj = B.createBgObjDirectly(reader:getImg("part2", "snow"), s, s, --img, w, h
						self.center_x + ran:Float(-0.5*self.x_range, 0.5*self.x_range), --x
						self.center_y + ran:Float(-0.5*self.y_range, 0.5*self.y_range), --y
						self.center_z + ran:Float(-0.5*self.z_range, 0.5*self.z_range), --z
						{ran:Float(95, 135), -90}, --rot
						"", 0 --blend, a
				)
				--为这个obj接入飘落物接口，实现飘落物的功能
				FallingObjectInterface.implement(obj,
						1,  --v
						{self.theta + ran:Float(-0.5*self.theta_range, 0.5*self.theta_range), --theta
						 self.phi + ran:Float(-0.5*self.phi_range, 0.5*self.phi_range)}, --phi
						ran:Float(2, 4)*ran:Sign(), --omiga
						ran:Int(40, 60), --live_time
						C.getBgObjNumber(self) + 1 --index
				)
				C.addBgObj(self, obj)
			end
			--update和delete逻辑
			local del_indexs, obj = {}
			for i = 1, #self.bg_objs do
				obj = self.bg_objs[i]
				if obj.update then
					obj:update() --由上面的接口赋予，执行的是飘落物的运动逻辑
				end
				if obj.status == "del" then
					table.insert(del_indexs, obj._index)
				end
			end
			local index
			for i = 1, #del_indexs do
				index = del_indexs[i] - i + 1
				table.remove(self.bg_objs, index)
				for j = index, C.getBgObjNumber(self) do
					obj = self.bg_objs[j]
					obj._index = obj._index - 1 --序号前移
				end
			end
		end
)

--画面飘落物
local createParticleComp = C.createComponentClassFunc(
--initFunc
		function(self)
			--生成范围
			self.center_x, self.center_y, self.center_z = 0, -10, 30
			self.x_range, self.y_range, self.z_range = 20, 15, 30
			--生成角度
			self.theta, self.phi = 45, -90 --θ,φ
			self.theta_range, self.phi_range = 0, 180
			--[[test
			if self.z_range == 0 then
				C.addBgObj(self, B.createBgObjDirectly(square_stroke, self.x_range, self.y_range, --img, w, h
						self.center_x, self.center_y, self.center_z, {90, -90}, --x, y, z, rot
						"", 255) --blend, a
				)
			elseif self.y_range == 0 then
				C.addBgObj(self, B.createBgObjDirectly(square_stroke, self.x_range, self.z_range, --img, w, h
						self.center_x, self.center_y, self.center_z, {180, -90}, --x, y, z, rot
						"", 255) --blend, a
				)
			elseif self.x_range == 0 then
				C.addBgObj(self, B.createBgObjDirectly(square_stroke, self.y_range, self.z_range, --img, w, h
						self.center_x, self.center_y, self.center_z, {90, 0}, --x, y, z, rot
						"", 255) --blend, a
				)
			else
				for u = -1, 1, 2 do
					--x o y
					C.addBgObj(self, B.createBgObjDirectly(square_stroke, self.x_range, self.y_range, --img, w, h
							self.center_x, self.center_y, self.center_z + 0.5*self.z_range*u, {90, -90}, --x, y, z, rot
							"", 255) --blend, a
					)
					--x o z
					C.addBgObj(self, B.createBgObjDirectly(square_stroke, self.x_range, self.z_range, --img, w, h
							self.center_x, self.center_y + 0.5*self.y_range*u, self.center_z, {180, -90}, --x, y, z, rot
							"", 255) --blend, a
					)
				end
			end]]
		end,
--updateFunc
		function(self)
			if self.timer % 4 == 0 then
				local s = ran:Float(0.75, 1.25)
				local obj = B.createBgObjDirectly(reader:getImg("part2", "snow"), s, s, --img, w, h
						self.center_x + ran:Float(-0.5*self.x_range, 0.5*self.x_range), --x
						self.center_y + ran:Float(-0.5*self.y_range, 0.5*self.y_range), --y
						self.center_z + ran:Float(-0.5*self.z_range, 0.5*self.z_range), --z
						{ran:Float(80, 100), -90}, --rot
						"", 0 --blend, a
				)
				--为这个obj接入飘落物接口，实现飘落物的功能
				FallingObjectInterface.implement(obj,
						0.05,  --v
						{self.theta + ran:Float(-0.5*self.theta_range, 0.5*self.theta_range), --theta
						 self.phi + ran:Float(-0.5*self.phi_range, 0.5*self.phi_range)}, --phi
						ran:Float(2, 4)*ran:Sign(), --omiga
						ran:Int(120, 150), --live_time
						C.getBgObjNumber(self) + 1 --index
				)
				C.addBgObj(self, obj)
			end
			--update和delete逻辑
			local del_indexs, obj = {}
			for i = 1, #self.bg_objs do
				obj = self.bg_objs[i]
				if obj.update then
					obj:update() --由上面的接口赋予，执行的是飘落物的运动逻辑
				end
				if obj.status == "del" then
					table.insert(del_indexs, obj._index)
				end
			end
			local index
			for i = 1, #del_indexs do
				index = del_indexs[i] - i + 1
				table.remove(self.bg_objs, index)
				for j = index, C.getBgObjNumber(self) do
					obj = self.bg_objs[j]
					obj._index = obj._index - 1 --序号前移
				end
			end
		end
)

---背景定义
local BG = Class(B)
do
	local bg_vz = 0
	--背景容器
	local coms = {
		["red"] = nil,
		["purple"] = nil
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

	end
	local function addAllComponent(self)

	end
	local function addFirstScenceComponent(self)
		bg_vz = 0
		B.addBgComponent(self, getComponent("far"))
		B.addBgComponent(self, getComponent("cave"))
		B.addBgComponent(self, getComponent("window"))
		B.addBgComponent(self, getComponent("pillar"))
		B.addBgComponent(self, getComponent("star"))

		C.setAlpha(getComponent("far"), 0)
		C.setAlpha(getComponent("window"), 0)
		local com = getComponent("pillar")
		com.setV(com, bg_vz)
		local com = getComponent("star")
		com.setV(com, bg_vz)
	end
	function BG:setDefault()
		B.setBaseParam(self,
				{0, 60, 6}, --eye_cen, --飞到z = 25是预设好的位置
				{95, 90}, --eye_rot,
				0, --v,
				{90, -90}, --a,
				{90, 90}, --up_rot,
				1.5, --fovy,
				{0.1, 100}, --z
				{0, 25, 255, 0, 0, 0} --fog 全黑
		)
		--region 创建背景容器

		--远景
		do
			local com_name = "far"
			local img_name = s5_reader:getImg("purple", "far") --folder_name, file_name
			local com = setComponent(com_name, M.create2DBgComponent(com_name))
			--local _, h = B.getImgWH(self, img_name)
			C.addBgObj(com, B.create2DBgObj(img_name, 0, 0, 0, 1, 1.2, "", 255, 255, 255, 255))
			C.setAlpha(com, 0.25) --先默认为0
		end

		--远处的黑洞
		do
			local com_name = "cave"
			local com = setComponent(com_name, M.create2DBgComponent(com_name))
			local cave = B.create2DBgObj(
					s5_reader:getImg("purple", "cave"), 0, -150, 0, 0.75, 0.75, --img, x, y, rot, hscale, vscale,
					"", 100, 255, 255, 255 --blend, _a, _r, _g, _b
			)
			C.addBgObj(com, cave)
			--让黑洞动起来
			task.New(com, function()
				while true do
					B.set2DBgObjRot(cave, B.get2DBgObjRot(cave) + 3)
					task.Wait(1)
				end
			end)

			--添加其他静态星星
			C.addBgObj(com,
					B.create2DBgObj(
							s5_reader:getImg("purple", "ball1"), -130, -80, 0, 0.75, 0.75, --img, x, y, rot, hscale, vscale,
							"", 200, 255, 255, 255 --blend, _a, _r, _g, _b
					)
			)

			--添加其他静态星星
			C.addBgObj(com,
					B.create2DBgObj(
							s5_reader:getImg("purple", "ball2"), 120, -130, 0, 0.65, 0.65, --img, x, y, rot, hscale, vscale,
							"", 180, 255, 255, 255 --blend, _a, _r, _g, _b
					)
			)

			--添加其他静态星星
			C.addBgObj(com,
					B.create2DBgObj(
							s5_reader:getImg("purple", "ball3"), 40, -40, 0, 0.65, 0.65, --img, x, y, rot, hscale, vscale,
							"", 180, 255, 255, 255 --blend, _a, _r, _g, _b
					)
			)
			C.setAlpha(com, 0.25)
		end

		--两侧星星挂坠
		do
			local com_name = "star"
			local num_l, num_w = 2, 2
			local width, hei = 5, 30
			local wide, dist = 16, 30

			local img_names1 = {s5_reader:getImg("purple", "star1"), s5_reader:getImg("purple", "star2"), s5_reader:getImg("purple", "star3"), s5_reader:getImg("purple", "moon")}
			local img_names2 = {s5_reader:getImg("purple", "star4"), s5_reader:getImg("purple", "star5"), s5_reader:getImg("purple", "star6"), s5_reader:getImg("purple", "moon2")}
			local dwides = {0, 4, 0, -4}
			local dys = {0, -1, 0, 1}

			local com = setComponent(com_name, M.createAdvanceBgComponent(com_name, 0, num_l*dist, bg_vz, true))
			for i = 1, 4 do
				C.addBgObjs(com,
						B.createTileBgObjsTableDirectly(
								img_names1[i], width, hei, --img, w, h,
								dwides[i], hei - 4 + dys[i], (i-1)/4*dist, {90, -90}, --x, y, z, rot,
								"", 255, 255, 255, 255, --blend, _a, _r, _g, _b,
								num_l, {90, 90}, dist, --num_l, a0, dist,
								num_w, 0, wide  --num_w, a1, w
						)
				)
				C.addBgObjs(com,
						B.createTileBgObjsTableDirectly(
								img_names2[i], width, -hei, --img, w, h,
								dwides[i], -0.5*hei - dys[i], (i-1)/4*dist + 0.001, {90, -90}, --x, y, z, rot,
								"", 255, 150, 150, 150, --blend, _a, _r, _g, _b,
								num_l, {90, 90}, dist, --num_l, a0, dist,
								num_w, 0, wide  --num_w, a1, w
						)
				)
			end
			C.sortByZ(com)
		end

		--boss画像
		do
			local com_name = "window"
			--local img_name = reader:getImg("general", "window") --folder_name, file_name
			local com = setComponent(com_name, M.createStaticBgComponent(com_name, false))
			--local _, h = B.getImgWH(self, img_name)
			C.addBgObj(com,
					B.createBgObjDirectly(reader:getImg("general", "window_shadow"), 25, 25, --img
							0, 0, 30, {180, 90}, --x, y, z, rot
							"mul+add", 255) --blend, a
			)
			C.addBgObj(com,
					B.createBgObjDirectly(reader:getImg("general", "window"), 25, 25,  --img
							0, 15, 45, {90, 90}, --x, y, z, rot
							"mul+add", 255, 255, 255, 255, 90) --blend, a
			)
		end

		--两侧柱子
		do
			local com_name = "pillar"
			local num_l, num_w = 5, 2
			local img_name = reader:getImg("red", "pillar")
			--local _, hei = B.getImgWH(self, img_name)
			local w, h = 19.2, 96
			local wide, len = 35, 15 --左右两侧间隔、前后两柱间隔
			local com = setComponent(com_name, M.createAdvanceBgComponent(com_name, 0, num_l*len, bg_vz, true)) --注意函数名有个2，与正常的不一样
			C.addBgObjs(com,
					B.createTileBgObjsTableDirectly(img_name, w, h, --img, w, h
							0, 0.178*h, 0, {95, -90}, --x, y, z, rot,
							"", 255, 255, 255, 255, --blend, _a, _r, _g, _b,
							num_l, {90, 90}, len, --num_l, a0, dist,
							num_w, 0, wide  --num_w, a1, w
					)
			)
			C.sortByZ(com)
		end

		--转场，地上的景物和星河
		do
			local com_name = "ground"
			setComponent(com_name, createGroundComp(com_name, false))
		end

		--大月亮
		do
			local com_name = "moon"
			setComponent(com_name, createMoonComp(com_name, false))
		end


		--高速云
		do
			local com_name = "cloud"
			local num_l = 6
			local len = 10
			local imgs = {
				reader:getImg("part2", "cloud1"), reader:getImg("part2", "cloud2"), reader:getImg("part2", "cloud3")
			}
			local index_list = {2, 1, 1, 2, 3, 2, 2, 2, 1, 3, 1, 2}

			local com = setComponent(com_name, M.createAdvanceBgComponent(com_name, 0, num_l*len, -1, true))
			local index = 1
			for i = 0, num_l - 1 do
				for u = -1, 1, 2 do
					C.addBgObj(com,
							B.createBgObjDirectly(imgs[index_list[index]], 25, 25,  --img, w, h
									10*u, -5, 0 + 0.00001*u + len*i, {45, 90}, --x, y, z, rot
									"mul+add", 255, 255, 255, 255, 90) --blend, a
					)
					index = index + 1
				end
			end
			C.sortByZ(com)
		end

		--极光
		do
			local com_name = "light"
			setComponent(com_name, createLightComp(com_name, false))
		end

		--画面高速飞过的叶子
		do
			local com_name = "leaf"
			setComponent(com_name, createLeafComp(com_name, false))
		end

		--画面飘落物
		do
			local com_name = "particle"
			setComponent(com_name, createParticleComp(com_name, false))
		end

		--宫殿
		do
			local com_name = "palace"
			setComponent(com_name, createPalaceComp(com_name, false))
		end
		--endregion
	end


	--0~920
	function BG:Sence1(practice)
		addFirstScenceComponent(self)
		do
			task.New(self, function()
				local t = 240
				local far = getComponent("far")
				local cave = getComponent("cave")
				local alpha, dalpha = 0, 1/t
				B.accDecEyePos(self, 0.225, {0, 90}, 1, 120, 239)
				for _ = 1, t do
					alpha = alpha + dalpha
					C.setAlpha(far, alpha)
					C.setAlpha(cave, alpha)
					task.Wait(1)
				end

				--变亮
				t = 60
				local _, dr2 = B.getFogRange(self)
				dr2 = (60 - dr2)/t
				for _ = 1, t do
					B.updateFogRange(self, 0, dr2)
					task.Wait(1)
				end
				--task.Wait(200)

				--柱子开始移动
				t = 360
				local pillar = getComponent("pillar")
				local star = getComponent("star")
				local dv = -0.9/t
				for _ = 1, t do
					bg_vz = bg_vz + dv
					pillar.setV(pillar, bg_vz)
					star.setV(star, bg_vz)
					task.Wait(1)
				end
				BG.Sence2(self, false)
			end)
		end
	end

	--920 ~ 1700
	function BG:Sence2(practice)
		if practice then
			self.timer = 920
			B.setBaseParam(self,
					{0, 6, 6}, --eye_cen,
					{95, 90}, --eye_rot, --抬头
					0, --v,
					{90, -90}, --a,
					{90, 90}, --up_rot,
					1.5, --fovy,
					{0.1, 100}, --z
					{0, 60, 255, 0, 0, 0} --fog 全黑
			)
			addFirstScenceComponent(self)
			--该亮的得亮
			local far = getComponent("far")
			local cave = getComponent("cave")
			C.setAlpha(far, 1)
			C.setAlpha(cave, 1)
			--设置背景移动速度
			bg_vz = -0.9
			local pillar = getComponent("pillar")
			local star = getComponent("star")
			pillar.setV(pillar, bg_vz)
			star.setV(star, bg_vz)
		end
		do
			task.New(self, function()
				local R = lstg.tmpvar.current_road
				--判断是否进入场景2
				while R.class.getSence(R) ~= 2 do
					task.Wait(1)
				end
				task.Wait(640) --1560
				local t = 150
				local pillar = getComponent("pillar")
				local window = getComponent("window")
				local _, _, vz = B.getEyeCen(self)
				vz = (42.5 - vz)/t
				pillar.setV(pillar, bg_vz + vz) --使背景柱子运动速度同步
				local alpha, dalpha = 0, 1/t
				--向上移动
				task.New(self, function()
					task.Wait(0.25*t)
					B.accDecEyePos(self, 0.11, {180, 0}, 0.25*t, 0.25*t, 0.25*t)
					task.Wait(0.75*t - 10 - 60)
					pillar.setZRange(pillar, -999) --柱子不再循环至最远处
					task.Wait(60)
					New(flash)
					self.broken = true --背景玻璃已碎的标记
					task.Wait(10)
					effect.shakeScreen(60, 10)
					New(broken)
					PlaySound("broken1")
					B.removeAllBgComponent(self)
				end)
				for _ = 1, t do
					alpha = alpha + dalpha
					C.setAlpha(window, alpha)
					B.updateEyeCen(self, 0, 0, vz)
					task.Wait(1)
				end
				BG.Sence3(self, false)
			end)
		end
	end

	--1700~3160 total 1460
	function BG:Sence3(practice)
		if practice then
			self.timer = 1700
		end
		B.setBaseParam(self,
				{0, 4, 6}, --eye_cen,
				{135, 90}, --eye_rot, --抬头
				0, --v,
				{90, -90}, --a,
				{90, 90}, --up_rot,
				1.5, --fovy,
				{0.1, 100}, --z
				{0, 60, 255, 0, 0, 0} --fog 全黑
		)
		B.addBgComponent(self, getComponent("ground"))
		do
			local com = getComponent("ground")
			com.timer = 0
		end
		B.addBgComponent(self, getComponent("moon"))
		do
			local com = getComponent("moon")
			com.timer = 0
		end
		B.addBgComponent(self, getComponent("light"))
		do
			local com = getComponent("light")
			C.setAlpha(com, 0)
		end
		B.addBgComponent(self, getComponent("cloud"))
		B.addBgComponent(self, getComponent("leaf"))
		do
			task.New(self, function()
				local R = lstg.tmpvar.current_road
				--判断是否进入场景3
				while R.class.getSence(R) ~= 3 do
					task.Wait(1)
				end
				--地面与天空的运动
				task.New(self, function()
					--渐变出现
					local com = getComponent("ground")
					local ground = com.ground
					--local light = getComponent("light")
					local t = 120
					local _a, d_a = 0, 255/t
					local _, y = B.get2DBgObjPos(ground)
					local dy = (0 - y)/t
					local s = B.get2DBgObjSize(ground)
					local ds = (0.9 - s)/t
					for _ = 1, t do
						_a = _a + d_a
						B.set2DBgObjColor(ground, _a, 255, 255, 255)
						y = y + dy
						B.set2DBgObjPos(ground, 0, y)
						s = s + ds
						B.set2DBgObjSize(ground, s, s)
						task.Wait(1)
					end
					--减速
					t = 30
					local d_ds = -ds/t
					local d_dy = -dy/t
					for _ = 1, t do
						ds = ds + d_ds
						s = s + ds
						B.set2DBgObjSize(ground, s, s)
						dy = dy + d_dy
						y = y + dy
						B.set2DBgObjPos(ground, 0, y)
						task.Wait(1)
					end
					t = 610
					dy = (-600 - y)/(600 + 305)
					local d_dy = dy/t
					dy = 0
					ds = (1.5 - s)/(600 + 305)
					local d_ds = ds/t
					ds = 0
					for _ = 1, t do
						ds = ds + d_ds
						s = s + ds
						B.set2DBgObjSize(ground, s, s)
						dy = dy + d_dy
						y = y + dy
						B.set2DBgObjPos(ground, 0, y)
						task.Wait(1)
					end
					--开始缓慢前进
					t = 600

					local d_star_y = (0 - com.star_dy)/t
					for _ = 1, t do
						s = s + ds
						B.set2DBgObjSize(ground, s, s)
						y = y + dy
						B.set2DBgObjPos(ground, 0, y)
						com.star_dy = com.star_dy + d_star_y --更新星空高度
						task.Wait(1)
					end
					t = 60
					_a, d_a = 255, -255/t
					local alpha, dalpha = 0, 1/t
					for _ = 1, t do
						_a = _a + d_a
						alpha = alpha + dalpha
						B.set2DBgObjColor(ground, _a, 255, 255, 255)
						--C.setAlpha(light, alpha)
						task.Wait(1)
					end
				end)
				--极光出现
				task.New(self, function()
					task.Wait(120)
					local t = 180
					local com = getComponent("light")
					local alpha, dalpha = 0, 0.5/t
					for _ = 1, t do
						alpha = alpha + dalpha
						C.setAlpha(com, alpha)
						task.Wait(1)
					end
					task.Wait(720)
					--然后又消失了
					t = 300
					dalpha = -0.5/t
					for _ = 1, t do
						alpha = alpha + dalpha
						C.setAlpha(com, alpha)
						task.Wait(1)
					end
				end)
				BG.Sence4(self, false)
			end)
		end
	end

	--3160
	function BG:Sence4(practice)
		if practice then
			self.timer = 3160
			B.setBaseParam(self,
					{0, 4, 6}, --eye_cen,
					{135, 90}, --eye_rot, --抬头
					0, --v,
					{90, -90}, --a,
					{90, 90}, --up_rot,
					1.5, --fovy,
					{0.1, 100}, --z
					{0, 60, 255, 0, 0, 0} --fog 全黑
			)
			--设置地面参数为上一幕的参数
			B.addBgComponent(self, getComponent("ground"))
			do
				local com = getComponent("ground")
				local ground = com.ground
				com.star_dy = 0
				B.set2DBgObjSize(ground, 1.5, 1.5)
				B.set2DBgObjPos(ground, 0, -600)
				B.set2DBgObjColor(ground, 0, 255, 255, 255)
				com.timer = 1460 --计时器也要同步，不然会影响星星透明度
			end
			B.addBgComponent(self, getComponent("moon"))
			do
				local com = getComponent("moon")
				com.timer = 1460
			end
			B.addBgComponent(self, getComponent("light"))
			do
				C.setAlpha(getComponent("light"), 0)
			end
			B.addBgComponent(self, getComponent("cloud"))
			B.addBgComponent(self, getComponent("leaf"))
		end

		do
			task.New(self, function()
				local R = lstg.tmpvar.current_road
				--判断是否进入场景4
				while R.class.getSence(R) ~= 4 do
					task.Wait(1)
				end
				B.addBgComponent(self, getComponent("palace"))
				--下降
				task.New(self, function()
					local com = getComponent("ground")
					local palace = getComponent("palace")
					--加速下降
					local t = 1040
					local d_star_y = 2*(240 - com.star_dy)/t
					local d_d_star_y = d_star_y/t
					d_star_y = 0
					local d_palace_y = 2*(400 - palace._dy)/t
					local d_d_palace_y = d_palace_y/t
					d_palace_y = 0
					for _ = 1, t do
						--更新星空高度
						d_star_y = d_star_y + d_d_star_y
						com.star_dy = com.star_dy + d_star_y
						--更新宫殿高度
						d_palace_y = d_palace_y + d_d_palace_y
						palace._dy = palace._dy + d_palace_y
						task.Wait(1)
					end

					--减速
					t = 60
					d_d_star_y = -d_star_y/t
					d_d_palace_y = -d_palace_y/t
					for _ = 1, t do
						--更新星空高度
						d_star_y = d_star_y + d_d_star_y
						com.star_dy = com.star_dy + d_star_y
						--更新宫殿高度
						d_palace_y = d_palace_y + d_d_palace_y
						palace._dy = palace._dy + d_palace_y
						--New(fog)
						task.Wait(1)
					end
					--B.removeBgComponent(self, "cloud")
					--B.removeBgComponent(self, "leaf")
					--B.setEyeRot(self, 95, 90)
					--palace._dy = 400
					--下雪
					B.addBgComponent(self, getComponent("particle"))
					task.Wait(480)
					--开灯
					palace.turnOn()
					--极光出现
					local light = getComponent("light")
					t = 60
					local alpha, dalpha = 0, 1/t
					for _ = 1, t do
						alpha = alpha + dalpha
						C.setAlpha(light, alpha)
						task.Wait(1)
					end
				end)
				--云上升至消失（用3d摄像机y坐标变化实现）
				task.New(self, function()
					B.accDecEyePos(self, 0.05, {0, 90}, 600, 180, 1)
					task.Wait(600)
					local t = 480
					local a = B.getEyeRot(self)
					local da = (95 - a)/t
					for _ = 1, t do
						B.updateEyeRot(self, da, 0)
						task.Wait(1)
					end
					B.removeBgComponent(self, "cloud")
					B.removeBgComponent(self, "leaf")
				end)
				--月亮下降并变大
				task.New(self, function()
					local com = getComponent("moon")
					local normal_moon = com.normal_moon
					--加速下降
					local t = 1000
					local y = B.get2DBgObjPos(normal_moon)
					local dy = 2*(175 - y)/t
					local d_dy = dy/t
					dy = 0
					local s = B.get2DBgObjSize(normal_moon)
					local ds = (0.75 - s)/t
					for _ = 1, t do
						dy = dy + d_dy
						y = y + dy
						B.set2DBgObjPos(normal_moon, 0, y)
						s = s + ds
						B.set2DBgObjSize(normal_moon, s, s)
						task.Wait(1)
					end

					--减速
					t = 120
					d_dy = -dy/t
					for _ = 1, t do
						dy = dy + d_dy
						y = y + dy
						B.set2DBgObjPos(normal_moon, 0, y)
						task.Wait(1)
					end
				end)
			end)
		end
	end

	--boss场景
	function BG:Sence5(practice)
		if practice then
			self.timer = 8310
			B.setBaseParam(self,
					{0, -20, 6}, --eye_cen,
					{95, 90}, --eye_rot, --抬头
					0, --v,
					{90, -90}, --a,
					{90, 90}, --up_rot,
					1.5, --fovy,
					{0.1, 100}, --z
					{0, 60, 255, 0, 0, 0} --fog 全黑
			)
			--设置地面参数为上一幕的参数
			B.addBgComponent(self, getComponent("ground"))
			do
				local com = getComponent("ground")
				local ground = com.ground
				com.star_dy = 336
				B.set2DBgObjSize(ground, 1.5, 1.5)
				B.set2DBgObjPos(ground, 0, -600)
				B.set2DBgObjColor(ground, 0, 255, 255, 255)
				com.timer = 1460 --计时器也要同步，不然会影响星星透明度
			end
			B.addBgComponent(self, getComponent("moon"))
			do
				local com = getComponent("moon")
				com.timer = 1460
			end
			B.addBgComponent(self, getComponent("light"))
			B.addBgComponent(self, getComponent("palace"))
			--下雪
			B.addBgComponent(self, getComponent("particle"))

			local moon = getComponent("moon")
			local normal_moon = moon.normal_moon
			local palace = getComponent("palace")
			--开灯
			palace.turnOn()
			--设置高度
			palace._dy = 400
			B.set2DBgObjPos(normal_moon, 0, 175)
			B.set2DBgObjSize(normal_moon, 0.75, 0.75)

		end
		do
			task.New(self, function()
			end)
		end
	end

	--spboss场景（四符击破之后往上飞）
	function BG:Sence6(practice)
		--添加云和雪
		B.addBgComponent(self, getComponent("cloud"))
		B.addBgComponent(self, getComponent("leaf"))

		if practice then
			self.timer = 9999
			B.setBaseParam(self,
					{0, 4.25, 6}, --eye_cen,
					{135, 90}, --eye_rot, --抬头
					0, --v,
					{90, -90}, --a,
					{90, 90}, --up_rot,
					1.5, --fovy,
					{0.1, 100}, --z
					{0, 60, 255, 0, 0, 0} --fog 全黑
			)
			local ground = getComponent("ground")
			ground.star_dy = 0
			ground.star_d_dy = -200/170/60
			local moon = getComponent("moon")
			moon._dy = 300
			B.removeBgComponent(self, "palace")
			B.removeBgComponent(self, "particle")
			task.New(self, function()
				local normal_moon = moon.normal_moon
				B.set2DBgObjPos(normal_moon, 0, 100)
				C.setAlpha(moon, 1)
				local t = 60*60
				local dy = -130/t
				moon._dy = moon._dy - 100
				for _ = 1, _infinite do
					--B.set2DBgObjPos(normal_moon, 0, y)
					moon._dy = moon._dy + dy
					task.Wait(1)
				end
			end)
		else
			--下降
			task.New(self, function()
				local com = getComponent("ground")
				local palace = getComponent("palace")
				--加速上升
				local t = 90
				local d_star_y = 2*(0 - com.star_dy)/t
				local d_d_star_y = d_star_y/t
				d_star_y = 0
				local d_palace_y = 2*(0 - palace._dy)/t
				local d_d_palace_y = d_palace_y/t
				d_palace_y = 0
				for i = 1, t do
					--更新星空高度
					d_star_y = d_star_y + d_d_star_y
					com.star_dy = com.star_dy + d_star_y
					--更新宫殿高度
					d_palace_y = d_palace_y + d_d_palace_y
					palace._dy = palace._dy + d_palace_y
					if i > 60 then
						New(fog)
					end
					task.Wait(1)
				end

				--减速
				t = 30
				d_d_star_y = -d_star_y/t
				d_d_palace_y = -d_palace_y/t
				for _ = 1, t do
					--更新星空高度
					d_star_y = d_star_y + d_d_star_y
					com.star_dy = com.star_dy + d_star_y
					--更新宫殿高度
					d_palace_y = d_palace_y + d_d_palace_y
					palace._dy = palace._dy + d_palace_y
					--New(fog)
					New(fog)
					task.Wait(1)
				end
				com.star_d_dy = -200/170/60
				B.removeBgComponent(self, "palace")
			end)
			--云上升至消失（用3d摄像机y坐标变化实现）
			task.New(self, function()
				local t = 48
				local a = B.getEyeRot(self)
				local da = (135 - a)/t
				for _ = 1, t do
					B.updateEyeRot(self, da, 0)
					task.Wait(1)
				end
				B.accDecEyePos(self, -0.5, {0, 90}, 60, 18, 1)
			end)
			--月亮下降并变大
			task.New(self, function()
				task.Wait(120)
				local com = getComponent("moon")
				com._dy = 300
				local normal_moon = com.normal_moon
				--加速下降
				local t = 60
				local y = B.get2DBgObjPos(normal_moon)
				local dy = 2*(100 - y)/t
				local d_dy = dy/t
				dy = 0
				--local s = B.get2DBgObjSize(normal_moon)
				--local ds = (0.5 - s)/t
				local alpha, dalpha = 1, -1/t
				for _ = 1, t do
					dy = dy + d_dy
					y = y + dy
					B.set2DBgObjPos(normal_moon, 0, y)
					--s = s + ds
					--B.set2DBgObjSize(normal_moon, s, s)
					alpha = alpha + dalpha
					C.setAlpha(com, alpha)
					task.Wait(1)
				end
				--移除飘雪
				B.removeBgComponent(self, "particle")
				--减速
				t = 30
				d_dy = -dy/t
				for _ = 1, t do
					dy = dy + d_dy
					y = y + dy
					B.set2DBgObjPos(normal_moon, 0, y)
					task.Wait(1)
				end
				t = 126*60
				dy = -230/t
				for _ = 1, _infinite do
					y = y + dy
					--B.set2DBgObjPos(normal_moon, 0, y)
					com._dy = com._dy + dy
					task.Wait(1)
				end
			end)
		end
	end

	--真实的月亮再度出现
	function BG:moonAppear()
		local moon = getComponent("moon")
		local normal_moon = moon.normal_moon
		B.set2DBgObjSize(normal_moon, 2, 2)
		C.setAlpha(moon, 1)
	end
end
function BG:init(sence)
	loadRes()

	lstg.tmpvar.bg = self --给boss操作用的
	B.init(self) --默认背景类的构造方法
	BG.setDefault(self) --该背景的构造方法

	local t = {BG.Sence1, BG.Sence2, BG.Sence3, BG.Sence4, BG.Sence5}
	if not sence or sence == 0 then --主线模式
		BG.Sence1(self)
	elseif type(sence) == "boolean" then --boss模式
		t[5](self, true)
	else --道中分段练习模式
		sence = min(5, sence)
		t[sence](self, true)
	end
end
function BG:frame()
	background_open = setting.effect.background
	if background_open then
		B.frame(self)
		--B.setUpRot(self, 90, 90 + 3*sin(0.25*(self.timer - 1800))) --添加摇晃的效果
	end
end
function BG:render()
	if background_open then
		B.render(self)
		--B.printParam(self) --打印背景相关参数，测试用
		--B.renderBlackBoard(self) --本来就够黑了，不渲染
	end
end
--快速起飞（用于sc5之后
function BG:flyToSky(practice)
	BG.Sence6(self, practice)
end

----------------------------------------]]
---导出定义

stage6_background = BG
