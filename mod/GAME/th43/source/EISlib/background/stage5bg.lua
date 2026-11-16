---======================================
---东方栖霞园五面背景
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
local stage_name = "s5"
local path = "res/background/stage5/"
local reader = ReadClass.new(stage_name, path)
local function loadRes()
	--digital
	reader:loadBgImgFromFile("digital", {"far", "line", "particle"})

	--digital pillar
	local list = {}
	for i = 0, 11 do
		list[i+1] = ""..i
	end
	reader:loadBgImgFromFile("digital/pillar", list)

	--digital picture
	local list = {}
	for i = 0, 3 do
		list[i+1] = ""..i
	end
	reader:loadBgImgFromFile("digital/picture", list)

	--purple
	local filenames = {"far", "pillar", "cloud", "moon", "star1", "star2", "star3",
					   "moon2", "star4", "star5", "star6",
					   "ball1", "ball2", "ball3", "cave", "particle"}
	reader:loadBgImgFromFile("purple", filenames)
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
		task.Wait(120)
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

local bg_vz = -0.075

--特殊组件定义（背景的壁画
local createPictureComp = C.createComponentClassFunc(
--initFunc
		function(self)
			self.img_list = {}
			for i = 0, 3 do
				self.img_list[i + 1] = reader:getImg("digital/picture", ""..i)
			end
			C.addBgObj(self,
					B.createBgObjDirectly(
							self.img_list[1], 25, 25,  --img, w, h,
							0, 15, 45, {90, 90}, --x, y, z, rot,
							"", 255, 255, 255, 255,
							90)
			)
		end,
--updateFunc
		function(self)
			local list = self.img_list
			--贴图切换
			local obj = self.bg_objs[1]
			local t = math.floor(self.timer/4)%4
			B.setBgObjImg(obj, list[t+1])
		end
)

--特殊组件定义（背景的粒子方块
local createParticleComp = C.createComponentClassFunc(
--initFunc
		function(self)
		end,
--updateFunc
		function(self)
			if self.timer % 4 == 0 then
				local obj
				obj = B.createBgObjDirectly(reader:getImg("digital", "particle"), ran:Float(1, 2), 0.5*ran:Float(1, 2), --img, w, h
						ran:Float(-10, 10), 0, ran:Float(15, 40), {ran:Float(95, 135), -90}, --x, y, z, rot
						"", 0) --blend, a
				obj.vx = ran:Float(-0.001, 0.001)*0
				obj.vy = ran:Float(0.05, 0.3)
				obj.vz = ran:Float(-0.05, -0.2)*0.15
				obj.omiga = ran:Float(2, 4)*ran:Sign() --花自旋转速
				obj.t = ran:Int(90, 120) --花能存活的时间
				obj._index = C.getBgObjNumber(self) + 1
				C.addBgObj(self, obj)
			end
			local del_indexs, obj = {}
			for i = 1, #self.bg_objs do
				obj = self.bg_objs[i]
				obj.t = obj.t - 1
				B.updateObjAngle(obj, obj.omiga) --花自旋
				B.updateBgObjPos(obj, obj.vx, obj.vy, obj.vz) --花位置更新
				if obj.t > 0 then --透明度变化
					B.updateBgObjAlp(obj, 10)
					if B.getBgObjAlp(obj) >= 180 then
						B.setBgObjAlp(obj, 180)
					end
				elseif obj.t > -30 then
					B.updateBgObjAlp(obj, -10)
					if B.getBgObjAlp(obj) >= 180 then
						B.setBgObjAlp(obj, 180)
					end
				else
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


--两侧的柱子
local createPillarComp = C.createComponentClassFunc(
--initFunc
		function(self)
			self.img_list = {}
			for i = 0, 11 do
				self.img_list[i + 1] = reader:getImg("digital/pillar", ""..i)
			end
			local num_l, num_w = 5, 2
			local width, hei = 19.2, 96
			local wide, len = 35, 15
			C.advanceBgComponentClass.implement(self, "pillar", 0, num_l*len, bg_vz, true)
			C.addBgObjs(self,
					B.createTileBgObjsTableDirectly(
							self.img_list[1], width, hei, --img, w, h,
							0, 0.128*hei, 0, {95, -90}, --x, y, z, rot,
							"mul+add", 255, 255, 255, 255, --blend, _a, _r, _g, _b,
							num_l, {90, 90}, len, --num_l, a0, dist,
							num_w, 0, wide  --num_w, a1, w
					)
			)
			C.sortByZ(self)
			C.setAlpha(self, 0.75)
		end,
--updateFunc
		function(self)
			local list = self.img_list
			C.advanceBgComponentClass.update(self)
			local objList = C.getBgObjList(self)
			local t = math.floor(self.timer/4)%12
			for _, obj in pairs(objList) do --更新img
				B.setBgObjImg(obj, list[t+1])
			end
		end
)

---背景定义
local BG = Class(B)
do
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
		B.addBgComponent(self, getComponent("cloud"))
		B.addBgComponent(self, getComponent("far"))
		B.addBgComponent(self, getComponent("cave"))
		B.addBgComponent(self, getComponent("pillar"))
		B.addBgComponent(self, getComponent("star"))

		C.setAlpha(getComponent("far"), 0)
		C.setAlpha(getComponent("cave"), 0)

	end
	local function addScence2Component(self)
		B.setBaseParam(self,
				{0, 4, 6}, --eye_cen,
				{105, 90}, --eye_rot,
				0, --v,
				{90, -90}, --a,
				{90, 90}, --up_rot,
				1.5, --fovy,
				{0.1, 100}, --z
				{0, 70, 255, 0, 0, 0} --fog 全黑
		)

		B.addBgComponent(self, getComponent("cloud"))
		B.addBgComponent(self, getComponent("far"))
		B.addBgComponent(self, getComponent("cave"))
		B.addBgComponent(self, getComponent("pillar"))
		B.addBgComponent(self, getComponent("star"))
	end
	local function addAllDigitalCom(self)
		B.addBgComponent(self, getComponent("cloud"))
		B.addBgComponent(self, getComponent("far"))
		B.addBgComponent(self, getComponent("cave"))
		B.addBgComponent(self, getComponent("line1"))
		B.addBgComponent(self, getComponent("line2"))
		B.addBgComponent(self, getComponent("line3"))
		B.addBgComponent(self, getComponent("digital_pillar"))
		B.addBgComponent(self, getComponent("star"))
		B.addBgComponent(self, getComponent("picture"))
		B.addBgComponent(self, getComponent("particle"))
	end

	function BG:setDefault()
		B.setBaseParam(self,
				{0, 14, 6}, --eye_cen,
				{105, 90}, --eye_rot,
				0, --v,
				{90, -90}, --a,
				{90, 90}, --up_rot,
				1.5, --fovy,
				{0.1, 100}, --z
				{0, 0.1, 255, 3, 4, 18} --fog 全黑
		)

		bg_vz = -0.075

		--region 创建背景容器

		--远景
		do
			local com_name = "far"
			local com = setComponent(com_name, M.create2DBgComponent(com_name))
			local far = B.create2DBgObj(
					reader:getImg("purple", "far"), 0, 0, 0, 1, 1.2, --img, x, y, rot, hscale, vscale,
					"mul+add", 150, 255, 255, 255 --blend, _a, _r, _g, _b
			)
			C.addBgObj(com, far)
			task.New(com, function()
				for i = 1, _infinite do
					B.set2DBgObjColor(far, 150 + 50*sin(i), 255, 255, 255)
					task.Wait(1)
				end
			end)
			--C.setAlpha(com, 0) --先默认为0
		end

		--远处的黑洞
		do
			local com_name = "cave"
			local com = setComponent(com_name, M.create2DBgComponent(com_name))
			local cave = B.create2DBgObj(
					reader:getImg("purple", "cave"), 0, -150, 0, 0.75, 0.75, --img, x, y, rot, hscale, vscale,
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
							reader:getImg("purple", "ball1"), -130, -80, 0, 0.75, 0.75, --img, x, y, rot, hscale, vscale,
							"", 200, 255, 255, 255 --blend, _a, _r, _g, _b
					)
			)

			--添加其他静态星星
			C.addBgObj(com,
					B.create2DBgObj(
							reader:getImg("purple", "ball2"), 120, -130, 0, 0.65, 0.65, --img, x, y, rot, hscale, vscale,
							"", 180, 255, 255, 255 --blend, _a, _r, _g, _b
					)
			)

			--添加其他静态星星
			C.addBgObj(com,
					B.create2DBgObj(
							reader:getImg("purple", "ball3"), 40, -40, 0, 0.65, 0.65, --img, x, y, rot, hscale, vscale,
							"", 180, 255, 255, 255 --blend, _a, _r, _g, _b
					)
			)
		end

		--boss画像
		do
			local com_name = "picture"
			local com = setComponent(com_name, createPictureComp(com_name, false))
			--C.setAlpha(com, 0) --先默认为0
		end

		--两侧柱子
		do
			local com_name = "pillar"
			local num_l, num_w = 5, 2
			local w, h = 19.2, 96
			local wide, len = 35, 15

			local com = setComponent(com_name, M.createAdvanceBgComponent(com_name, 0, num_l*len, bg_vz, true)) --注意函数名有个2，与正常的不一样
			C.addBgObjs(com,
					B.createTileBgObjsTableDirectly(reader:getImg("purple", "pillar"), w, h, --传入两个img, w, h
							0, 0.178*h, 0, {95, -90}, --x, y, z, rot,
							"", 255, 255, 255, 255, --blend, _a, _r, _g, _b,
							num_l, {90, 90}, len, --num_l, a0, dist,
							num_w, 0, wide  --num_w, a1, w
					)
			)
			C.sortByZ(com)
		end

		--两侧星星挂坠
		do
			local com_name = "star"
			local num_l, num_w = 2, 2
			local width, hei = 5, 30
			local wide, dist = 16, 30

			local img_names1 = {reader:getImg("purple", "star1"), reader:getImg("purple", "star2"), reader:getImg("purple", "star3"), reader:getImg("purple", "moon")}
			local img_names2 = {reader:getImg("purple", "star4"), reader:getImg("purple", "star5"), reader:getImg("purple", "star6"), reader:getImg("purple", "moon2")}
			local dwides = {0, 4, 0, -4}
			local dys = {0, -1, 0, 1}

			local com = setComponent(com_name, M.createAdvanceBgComponent(com_name, 0, num_l*dist, bg_vz, true)) --注意函数名有个2，与正常的不一样
			for i = 1, 4 do
				C.addBgObjs(com,
						B.createTileBgObjsTableDirectly(
								img_names1[i], width, hei, --img, w, h,
								dwides[i], hei - 4 + dys[i], i/4*dist, {90, -90}, --x, y, z, rot,
								"", 255, 255, 255, 255, --blend, _a, _r, _g, _b,
								num_l, {90, 90}, dist, --num_l, a0, dist,
								num_w, 0, wide  --num_w, a1, w
						)
				)
				C.addBgObjs(com,
						B.createTileBgObjsTableDirectly(
								img_names2[i], width, -hei, --img, w, h,
								dwides[i], -0.5*hei - dys[i], i/4*dist + 0.0001 + 2.5, {90, -90}, --x, y, z, rot,
								"", 255, 150, 150, 150, --blend, _a, _r, _g, _b,
								num_l, {90, 90}, dist, --num_l, a0, dist,
								num_w, 0, wide  --num_w, a1, w
						)
				)
			end
			C.sortByZ(com)
		end

		--后半的两侧柱子
		do
			local com_name = "digital_pillar"
			local com = setComponent(com_name, createPillarComp(com_name))
		end

		--星云
		do
			local com_name = "cloud"
			local num_l, num_w = 8, 1
			local dist = 5
			local wide, hei = 25, 25
			local com = setComponent(com_name, M.createAdvanceBgComponent(com_name, 0, num_l*dist, -0.005, true))
			C.addBgObjs(com,
					B.createTileBgObjsTableDirectly(
							reader:getImg("purple", "cloud"), wide, hei, --img, w, h,
							0, 8, 0, {-90, 95}, --x, y, z, rot,
							"", 255, 255, 255, 255, --blend, _a, _r, _g, _b,
							num_l, {90, 90}, dist, --num_l, a0, dist,
							num_w, 0, 0  --num_w, a1, w
					)
			)
			C.sortByZ(com)
			--让星云转起来
			task.New(com, function()
				local list = {}
				for _, obj in ipairs(C.getBgObjList(com)) do
					table.insert(list, obj)
				end
				while true do
					for i, obj in ipairs(list) do
						B.updateObjAngle(obj, 0.01*tranU(i))
					end
					task.Wait(1)
				end
			end)
			C.setAlpha(com, 0.8)
		end

		--中间扫描线
		do
			local com_name = "line1"
			local num_l, num_w = 2, 1
			local wide, len = 35, 26.25
			len = len - 2
			local com = setComponent(com_name, M.createAdvanceBgComponent(com_name, 0, num_l*len, bg_vz, true))
			C.addBgObjs(com,
					B.createTileBgObjsTableDirectly(reader:getImg("digital", "line"), wide, len + 2,
							0, 0, 10, {0, 90}, --x, y, z, rot,
							"mul+add", 255, 255, 255, 255, --blend, _a, _r, _g, _b,
							num_l, {90, 90}, len, --num_l, a0, dist,
							num_w, 0, wide  --num_w, a1, w
					)
			)
			C.sortByZ(com)
			C.setAlpha(com, 0.4)
		end

		--中间扫描线2
		do
			local com_name = "line2"
			local num_l, num_w = 2, 1
			local wide, len = 35, 26.25
			len = len - 2
			local com = setComponent(com_name, M.createAdvanceBgComponent(com_name, 0, num_l*len, bg_vz, true))
			C.addBgObjs(com,
					B.createTileBgObjsTableDirectly(reader:getImg("digital", "line"), wide, len + 2,
							-5, -5, 5, {0, 90}, --x, y, z, rot,
							"mul+add", 255, 255, 255, 255, --blend, _a, _r, _g, _b,
							num_l, {90, 90}, len, --num_l, a0, dist,
							num_w, 0, wide  --num_w, a1, w
					)
			)
			C.sortByZ(com)
			C.setAlpha(com, 0.25)
		end

		--两侧的扫描线
		do
			local com_name = "line3"
			local num_l, num_w = 4, 2
			local dist, hei = 30, 45
			local wide, len = 50, 15

			local com = setComponent(com_name, M.createAdvanceBgComponent(com_name, 0, num_l*len, bg_vz, true)) --注意函数名有个2，与正常的不一样
			C.addBgObjs(com,
					B.createTileBgObjsTableDirectly(
							reader:getImg("digital", "line"), dist, hei, --img
							0, 0.35*hei, 0, {90, 0}, --x, y, z, rot,
							"", 255, 255, 255, 255, --blend, _a, _r, _g, _b,
							num_l, {90, 90}, dist, --num_l, a0, dist,
							num_w, 0, wide  --num_w, a1, w
					)
			)
			C.sortByZ(com)
		end

		--粒子
		do
			local com_name = "particle"
			local com = setComponent(com_name, createParticleComp(com_name))
		end
		--endregion
	end


	--0 ~ 1980 total 1980
	function BG:Sence1(practice)
		addScence1Component(self)
		task.New(self, function()

			task.Wait(1980)
			BG.Sence2(self, false)
		end)
		--变化
		task.New(self, function()
			task.Wait(60)
			--变亮
			local t = 120
			local _, dr = B.getFogRange(self)
			dr = (25 - dr)/t
			for _ = 1, t do
				B.updateFogRange(self, 0, dr)
				task.Wait(1)
			end

			task.Wait(60)
			B.accDecEyePos(self, 10/600, {0, 0}, 120, 480, 120)
			task.Wait(600)

			t = 120
			local dr0, dr1 = B.getFogRange(self)
			dr0, dr1 = (0 - dr0)/t, (70 - dr1)/t
			local alpha, d_alpha = 0, 1/t
			for _ = 1, t do
				alpha = alpha + d_alpha
				C.setAlpha(getComponent("far"), alpha)
				C.setAlpha(getComponent("cave"), alpha)
				B.updateFogRange(self, dr0, dr1)
				task.Wait(1)
			end
		end)
	end

	--1980 ~ 3680   total = 1700
	function BG:Sence2(practice)
		if practice then
			self.timer = 1980
			addScence2Component(self)
		end
		do
			task.New(self, function()
				local R = lstg.tmpvar.current_road
				--判断是否进入场景2
				while R.class.getSence(R) ~= 2 do
					task.Wait(1)
				end
				task.Wait(1700)
				BG.Sence3(self, false)
			end)
		end
	end

	--3680 - 5300 = 1620
	function BG:Sence3(practice)
		if practice then
			self.timer = 3680
			addScence2Component(self)
		end
		do
			task.New(self, function()
				local R = lstg.tmpvar.current_road
				--判断是否进入场景3
				while R.class.getSence(R) ~= 3 do
					task.Wait(1)
				end
				for _ = 1, 1300 do
					if R.class.getSence(R) == 4 then --boss的符卡击破时间会直接影响进入p4的时间
						break
					end
					task.Wait(1)
				end
				BG.Sence4(self, false)
			end)
		end
	end

	--5500 ~  =
	function BG:Sence4(practice)
		if practice then
			self.timer = 5500
		end
		B.setBaseParam(self,
				{0, 4, 6}, --eye_cen,
				{105, 90}, --eye_rot, --抬头
				0, --v,
				{90, -90}, --a,
				{90, 90}, --up_rot,
				1.5, --fovy,
				{0.1, 100}, --z
				{0, 45, 255, 3, 4, 18} --fog 全黑
		)
		B.removeAllBgComponent(self)
		addAllDigitalCom(self)
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
			self.timer = 8310
			B.setBaseParam(self,
					{0, 4, 6}, --eye_cen,
					{105, 90}, --eye_rot, --抬头
					0, --v,
					{90, -90}, --a,
					{90, 90}, --up_rot,
					1.5, --fovy,
					{0.1, 100}, --z
					{0, 45, 255, 3, 4, 18} --fog 全黑
			)
			addAllDigitalCom(self)
			--设置背景移动速度
			bg_vz = -0.075
		end
		do
			task.New(self, function()
				local R = lstg.tmpvar.current_road
				--判断是否进入场景5
				while R.class.getSence(R) ~= 5 do
					task.Wait(1)
				end
				task.Wait(2380)
			end)
		end
	end

	--boss场景
	function BG:Sence6(practice)
		if practice then
			self.timer = 9999
			B.setBaseParam(self,
					{0, 4, 6}, --eye_cen,
					{105, 90}, --eye_rot, --抬头
					0, --v,
					{90, -90}, --a,
					{90, 90}, --up_rot,
					1.5, --fovy,
					{0.1, 100}, --z
					{0, 45, 255, 3, 4, 18} --fog 全黑
			)
			addAllDigitalCom(self)
			--设置背景移动速度
			bg_vz = -0.075
		end
		do
			task.New(self, function()
			end)
		end
	end
end
function BG:init(sence)
	loadRes()

	lstg.tmpvar.bg = self --给boss操作用的
	B.init(self) --默认背景类的构造方法
	BG.setDefault(self) --该背景的构造方法

	local t = {BG.Sence1, BG.Sence2, BG.Sence3, BG.Sence4, BG.Sence5, BG.Sence6}
	if not sence or sence == 0 then --主线模式
		BG.Sence1(self)
	elseif type(sence) == "boolean" then --boss模式
		t[6](self, true)
	else --道中分段练习模式
		sence = min(6, sence)
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

----------------------------------------]]
---导出定义

stage5_background = BG
