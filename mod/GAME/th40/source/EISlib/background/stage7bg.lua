---======================================
---东方栖霞园ex面背景
---by S7UPID
---======================================

local setting = database.setting

local M = EGGlib.BG
local B = M.baseBG
local C = M.comp
local background_open = setting.effect.background --背景开关选项
local ran = lstg.Rand() --给背景专门配发的随机种子生成器
local ReadClass = M.ReadClass --背景素材读取类
local FallingObjectInterface = EGGlib.BG.FallingObjectInterface --背景飘落物接口
local square_stroke = M.square_stroke --绘制方形边界的img

--二面&ex面背景素材加载
local stage_name = "s2"
local path = "res/background/stage2/"
local s2_reader = ReadClass.new(stage_name, path)

local stage_name2 = "s7"
local path2 = "res/background/stage7/"
local s7_reader = ReadClass.new(stage_name2, path2)
local function loadRes()
	--part1
	s2_reader:loadBgImgFromFile("part1", {"far1", "far2", "ground", "leaf", "light", "tree"}, path) --stage_name, folder_name, file_name_list, background_respath
	--s2 part2
	s2_reader:loadBgImgFromFile("part2", {"far", "ball", "butterfly", "flower1", "flower2", "flower3", "ground", "tree", "light"}, path) --stage_name, folder_name, file_name_list, background_respath
	--s7 part2
	s7_reader:loadBgImgFromFile("part2", {"far", "ball", "butterfly", "flower1", "flower2", "flower3", "ground", "tree", "light"}, path2) --stage_name, folder_name, file_name_list, background_respath
	--s7 part3
	s7_reader:loadBgImgFromFile("part3", {"far1", "far2", "top", "aura", "ground", "moon", "fog"}, path2) --stage_name, folder_name, file_name_list, background_respath
	--触手
	do
		local file_name_list = {}
		for i = 1, 11 do
			file_name_list[i] = ""..i
		end
		s7_reader:loadBgImgFromFile("part3/tentacle", file_name_list)
	end

	--血瀑布
	do
		local file_name_list = {}
		for i = 1, 14 do
			file_name_list[i] = ""..i
		end
		s7_reader:loadBgImgFromFile("part3/waterfall", file_name_list)
	end
end

--闪白
local flash = Class(object)
function flash:init()
	self.layer = LAYER_BG + 60
	self.x, self.y = 0, 0
	self.img = "white"
	self.hscale, self.vscale = 100, 100
	robject.set_color(self, "", 0, 108, 0, 35)
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

local bg_vz = -0.075 --背景沿z坐标的速度

--画面飘落物
local createLeafComp = C.createComponentClassFunc(
--initFunc
		function(self)
			--生成范围
			self.center_x, self.center_y, self.center_z = 0, 30, 30
			self.x_range, self.y_range, self.z_range = 20, 5, 15
			--生成角度
			self.theta, self.phi = 30, -90 --θ,φ
			self.theta_range, self.phi_range = 5, 20
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
			if self.timer % 6 == 0 then
				local s = 1
				local obj = B.createBgObjDirectly(s2_reader:getImg("part1", "leaf"), s, s, --img, w, h
						self.center_x + ran:Float(-0.5*self.x_range, 0.5*self.x_range), --x
						self.center_y + ran:Float(-0.5*self.y_range, 0.5*self.y_range), --y
						self.center_z + ran:Float(-0.5*self.z_range, 0.5*self.z_range), --z
						{ran:Float(80, 100), -90}, --rot
						"", 0 --blend, a
				)
				--为这个obj接入飘落物接口，实现飘落物的功能
				FallingObjectInterface.implement(obj,
						0.15,  --v
						{self.theta + ran:Float(-0.5*self.theta_range, 0.5*self.theta_range), --theta
						 self.phi + ran:Float(-0.5*self.phi_range, 0.5*self.phi_range)}, --phi
						ran:Float(2, 4)*ran:Sign(), --omiga
						ran:Int(240, 300), --live_time
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
					B.setBgObjAlp(obj, min(B.getBgObjAlp(obj), 150))
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


--特殊组件定义（背景的粒子球
local createBallComp = C.createComponentClassFunc(
--initFunc
		function(self)
			--产生的粒子的颜色
			self.ball_img = s2_reader:getImg("part2", "ball")
			--变成红色
			self.changeToRed = function()
				self.ball_img = s7_reader:getImg("part2", "ball")
				for _, ball in pairs(self.bg_objs) do
					ball[1][1] = self.ball_img
				end
			end
			self.remove = function(obj)
				B.removeBgComponent(lstg.tmpvar.bg, "balls")
			end
		end,
--updateFunc
		function(self)
			if self.timer % 4 == 0 then
				local obj = B.createBgObjDirectly(self.ball_img, 2, 2, --img
						ran:Float(-15, 15), 20, ran:Float(20, 35), {90, -90}, --x, y, z, rot
						"", 0) --blend, a
				obj.vx = ran:Float(-0.001, 0.001)*0
				obj.vy = ran:Float(0.1, 0.15)
				obj.vz = ran:Float(0, -0.2)*0.25
				obj.t = ran:Int(135, 180) --能存活的时间
				obj._index = C.getBgObjNumber(self) + 1
				C.addBgObj(self, obj)
			end
			local del_indexs, obj = {}
			for i = 1, #self.bg_objs do
				obj = self.bg_objs[i]
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
				table.remove(self.bg_objs, index)
				for j = index, C.getBgObjNumber(self) do
					obj = self.bg_objs[j]
					obj._index = obj._index - 1 --序号前移
				end
			end
		end
)

--地面景物和远景
local createFarComp = C.createComponentClassFunc(
--initFunc
		function(self)
			--夜
			self.far1 = B.create2DBgObj(s2_reader:getImg("part2", "far"), 0, 192, 0, 1, 1, "", 255, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			C.addBgObj(self, self.far1)

			--切换成红色背景
			self.changeToRed = function()
				B.set2DBgObjImg(self.far1, s7_reader:getImg("part2", "far"))
			end

			--切换到boss场景
			self.changeToBoss = function()
				--B.set2DBgObjImg(self.far1, s7_reader:getImg("part2", "far"))
				B.set2DBgObjImg(self.far1, s7_reader:getImg("part3", "far1"))
				B.set2DBgObjPos(self.far1, 0, 0)
				--远景上层
				C.addBgObj(self,
						B.create2DBgObj(s7_reader:getImg("part3", "far2"), 0, 0, 0, 1, 1, "", 255, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
				)
				local moon_y = 144
				--血月光晕
				self.moon_aura = B.create2DBgObj(s7_reader:getImg("part3", "aura"), 0, moon_y, 0, 0.75, 0.75, "", 255, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
				C.addBgObj(self, self.moon_aura)
				task.New(self, function()
					--转起来
					while true do
						B.set2DBgObjRot(self.moon_aura, B.get2DBgObjRot(self.moon_aura) + 1)
						task.Wait(1)
					end
				end)
				--血滴瀑布
				self.waterfall = B.create2DBgObj(s7_reader:getImg("part3/waterfall", "1"), 0, 100, 0, 1, 1, "", 255, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
				C.addBgObj(self, self.waterfall)
				task.New(self, function()
					local i = 0
					while true do
						B.set2DBgObjImg(self.waterfall, s7_reader:getImg("part3/waterfall", ""..(i%14 + 1)))
						task.Wait(4)
						i = i + 1
					end
				end)
				--血月
				self.moon = B.create2DBgObj(s7_reader:getImg("part3", "moon"), 0, moon_y, 0, 1, 1, "", 255, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
				C.addBgObj(self, self.moon)
				--雾
				C.addBgObj(self,
						B.create2DBgObj(s7_reader:getImg("part3", "fog"), 0, -65, 0, 1, 1, "", 255, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
				)
				C.addBgObj(self,
						B.create2DBgObj(s7_reader:getImg("part3", "fog"), 0, -65, 0, 1, 1, "", 255, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
				)
				--顶层
				C.addBgObj(self,
						B.create2DBgObj(s7_reader:getImg("part3", "top"), 0, 0, 0, 1, 1, "", 255, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
				)
			end
		end,
--updateFunc
		function(self)
			task.Do(self)
		end,
--is2D
		true
)

--触手
local createTentacleComp = C.createComponentClassFunc(
--initFunc
		function(self)
			self.img_list = {}
			for i = 1, 11 do
				self.img_list[i] = s7_reader:getImg("part3/tentacle", ""..i)
			end

			--触手
			local num, len = 6, 10
			C.advanceBgComponentClass.implement(self, "tentacle", 0, num*len, bg_vz, true)
			local wide, hei = 8.4, 16
			self.tentacle_list = {}
			local ani
			for i = 0, num - 1 do
				ani = ran:Int(1, 11)
				table.insert(self.tentacle_list, B.createBgObjDirectly(
						self.img_list[ani], wide, hei, --img, w, h
						10*tranU(i) + ran:Float(-2, 2), 0.13*hei - 5, 0.00001 + len*i, {90, -90}, --x, y, z, rot,
						"", 0))
				self.tentacle_list[i + 1].ani = ani
			end
			C.addBgObjs(self, self.tentacle_list)
			--排序
			C.sortByZ(self)
		end,
--updateFunc
		function(self)
			local list = self.img_list
			C.advanceBgComponentClass.update(self)
			local objList = self.tentacle_list
			local t = math.floor(self.timer/4)
			for _, obj in pairs(objList) do --更新img
				B.setBgObjImg(obj, list[(obj.ani + t)%11 + 1])
			end
		end
)

---背景定义

local BG = Class(B)
do
	local all_advance
	local lights = {} --特殊的Bgobj

	--背景容器
	local coms = {}
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

	BG.coms = coms
	BG.setComponent = setComponent
	BG.getComponent = getComponent

	function BG:setDefault()
		bg_vz = -0.075
		--地面
		do
			local com_name = "ground"
			local len, wide, num_l, num_w = 20, 20, 3, 4
			local com = setComponent(com_name, M.createAdvanceBgComponent2(com_name, 0, num_l*len, bg_vz, true)) --zmin, zmax, v
			C.addBgObjs(com,
					B.createTileBgObjsTableDirectly({s2_reader:getImg("part2", "ground"), s7_reader:getImg("part2", "ground")}, 20, 20,
							0, 0, 10, {180, 90}, --x, y, z, rot,
							"", 255, 255, 255, 255, --blend, _a, _r, _g, _b,
							num_l, {90, 90}, len, --num_l, a0, dist,
							num_w, 0, wide  --num_w, a1, w
					)
			)
			C.sortByZ(com)
		end

		--叶子
		do
			local com_name = "leaf"
			setComponent(com_name, createLeafComp(com_name, false))
		end

		--两侧的树
		do
			local com_name = "tree"
			local imgs = {{10, 12}, {15, 15}, {20, 18}, {24, 24}}
			local num, len, wides = 6, 7, {8, 11, 14, 17}
			local com = setComponent(com_name, M.createAdvanceBgComponent2(com_name, 0, num*len, bg_vz, true)) --zmin, zmax, v
			for i = 1, #imgs do
				C.addBgObjs(com, B.createTwoSidesBgObjsTableDirectly({s2_reader:getImg("part2", "tree"), s7_reader:getImg("part2", "tree")},
						imgs[i][1], imgs[i][2], 0, 0.5*imgs[i][2], 5*(i - 1),  --img, img_w, img_h, x, y, z
						{90, -90}, "", 255, 255, 255, 255, num, {90, 90}, len, wides[i]))
			end
			--光线
			local num, len = 3, 20
			local u = -1
			for i = 1, #imgs do
				table.insert(lights,
						B.createConBgObjsTableDirectly(
								{s2_reader:getImg("part2", "light"), s7_reader:getImg("part2", "light")}, 84*u, 53.2,
								15*u, 15, 0.1 + 10*(i - 1), {90, -90}, "", 255, 255, 255, 255, num, {90, 90}, len
						)
				)
				C.addBgObjs(com, lights[#lights])
				u = -u
			end
			--地上的花
			local flower1 = {s2_reader:getImg("part2", "flower1"), s7_reader:getImg("part2", "flower1")}
			local flower2 = {s2_reader:getImg("part2", "flower2"), s7_reader:getImg("part2", "flower2")}
			local flower3 = {s2_reader:getImg("part2", "flower3"), s7_reader:getImg("part2", "flower3")}
			local imgs = {
				{flower1, 2}, {flower2, -3}, {flower3, 4},
				{flower2, -6}, {flower1, 5}, {flower3, -4},
				{flower3, 5}, {flower1, -5}, {flower2, 3},
				{flower3, -2.5},
			}
			local num, len= #imgs, 3
			for j = 0, 1 do
				for i = 1, num do
					C.addBgObj(com, B.createBgObjDirectly(imgs[i][1], 3.54, 2.68, imgs[i][2], 1.34, 2 + len*(j*num + i - 1), {90, -90}, "", 0))
				end
			end
			C.sortByZ(com)
		end

		--远景
		do
			local com_name = "far"
			setComponent(com_name, createFarComp(com_name, false))
		end

		--粒子球
		do
			local com_name = "balls"
			setComponent(com_name, createBallComp("balls", false))
		end

		--最终场景的地面
		do
			local com_name = "ground2"
			--地面
			local len, wide, num_l, num_w = 10, 20, 5, 4
			local com = setComponent(com_name, M.createAdvanceBgComponent2(com_name, 0, num_l*len, bg_vz, true)) --zmin, zmax, v
			C.addBgObjs(com,
					B.createTileBgObjsTableDirectly(s7_reader:getImg("part3", "ground"), 20, 10,
							0, -5, 10, {180, 90}, --x, y, z, rot,
							"", 255, 255, 255, 255, --blend, _a, _r, _g, _b,
							num_l, {90, 90}, len, --num_l, a0, dist,
							num_w, 0, wide  --num_w, a1, w
					)
			)
			C.sortByZ(com)
		end

		--最终场景地面触手
		do
			local com_name = "tentacle"
			setComponent(com_name, createTentacleComp(com_name, true))
		end

		all_advance = { --所有会运动的背景
			getComponent("ground"),
			getComponent("tree")
		}
	end

	local function addFirstBgComponent(bg)
		B.addBgComponent(bg, getComponent("far"))
		B.addBgComponent(bg, getComponent("ground"))
		B.addBgComponent(bg, getComponent("balls"))
		B.addBgComponent(bg, getComponent("tree"))
		B.addBgComponent(bg, getComponent("leaf"))
	end

	local function addAfterMidBossBgComponent(bg)
		B.addBgComponent(bg, getComponent("far"))
		B.addBgComponent(bg, getComponent("ground"))
		B.addBgComponent(bg, getComponent("balls"))
		B.addBgComponent(bg, getComponent("tree"))
	end

	--开幕
	function BG:Sence1(practice)
		B.setBaseParam(self,
				{0, 8, 6}, --eye_cen,
				{95, 90}, --eye_rot, --抬头
				0, --v,
				{90, -90}, --a,
				{90, 90}, --up_rot,
				1.5, --fovy,
				{0.1, 100}, --z
				{0, 40, 255, 10, 32, 93} --fog --夜晚
		)
		addFirstBgComponent(self)
		do
			task.New(self, function()
				local R = lstg.tmpvar.current_road
				--判断是否进入场景1
				while R.class.getSence(R) ~= 1 do
					task.Wait(1)
				end
				BG.Sence2(self, false)
			end)
		end
	end

	--场景2
	function BG:Sence2(practice)
		if practice then
			B.setBaseParam(self,
					{0, 8, 6}, --eye_cen,
					{95, 90}, --eye_rot, --抬头
					0, --v,
					{90, -90}, --a,
					{90, 90}, --up_rot,
					1.5, --fovy,
					{0.1, 100}, --z
					{0, 40, 255, 10, 32, 93} --fog --夜晚
			)
			addFirstBgComponent(self)
		end
		do
			task.New(self, function()
				local R = lstg.tmpvar.current_road
				--判断是否进入场景2
				while R.class.getSence(R) ~= 2 do
					task.Wait(1)
				end
				BG.Sence3(self, false)
			end)
		end
	end

	--场景3
	function BG:Sence3(practice)
        if practice then
			B.setBaseParam(self,
					{0, 8, 6}, --eye_cen,
					{95, 90}, --eye_rot, --抬头
					0, --v,
					{90, -90}, --a,
					{90, 90}, --up_rot,
					1.5, --fovy,
					{0.1, 100}, --z
					{0, 40, 255, 10, 32, 93} --fog --夜晚
			)
			addFirstBgComponent(self)
        end
		do
			task.New(self, function()
				local R = lstg.tmpvar.current_road
				--判断是否进入场景3
				while R.class.getSence(R) ~= 3 do
					task.Wait(1)
				end
                BG.Sence4(self, false)
			end)
		end
	end


    --场景4（道中boss切换场景）（)
    function BG:Sence4(practice)
        if practice then
            B.setBaseParam(self,
                    {0, 8, 6}, --eye_cen,
                    {95, 90}, --eye_rot, --抬头
                    0, --v,
                    {90, -90}, --a,
                    {90, 90}, --up_rot,
                    1.5, --fovy,
                    {0.1, 100}, --z
                    {0, 40, 255, 10, 32, 93} --fog --夜晚
            )
			addFirstBgComponent(self)
        end
        do
            task.New(self, function()
                local R = lstg.tmpvar.current_road
                --判断是否进入场景4
                while R.class.getSence(R) ~= 4 do
                    task.Wait(1)
                end
				--因为切换场景是一瞬间的，且与boss演出配合，所以切换场景整合成了一个方法，并且由boss调用
				BG.Sence5(self, false)
            end)
        end
    end

	--场景5
	function BG:Sence5(practice)
		if practice then
			B.setBaseParam(self,
					{0, 8, 6}, --eye_cen,
					{95, 90}, --eye_rot, --抬头
					0, --v,
					{90, -90}, --a,
					{90, 90}, --up_rot,
					1.5, --fovy,
					{0.1, 100}, --z
					{0, 40, 255, 53, 13, 15} --fog --夜晚
			)
			addAfterMidBossBgComponent(self)
			BG.changeToRed(self)
		end
		do
			task.New(self, function()
				local R = lstg.tmpvar.current_road
				--因为切换场景是一瞬间的，且与boss演出配合，所以切换场景整合成了一个方法，并且由boss调用
				--判断是否进入场景5
				while R.class.getSence(R) ~= 5 do
					task.Wait(1)
				end
				task.Wait(2035)
				New(flash)
				task.Wait(60)
				BG.Sence6(self, false)
			end)
		end
	end

	--场景6（最终场景
	function BG:Sence6(practice)
		B.setBaseParam(self,
				{0, 8, 6}, --eye_cen,
				{91, 90}, --eye_rot, --抬头
				0, --v,
				{90, -90}, --a,
				{90, 90}, --up_rot,
				1.5, --fovy,
				{0.1, 100}, --z
				{0, 40, 255, 108, 0, 35} --fog --夜晚
		)
		B.removeAllBgComponent(self)
		B.addBgComponent(self, getComponent("far"))
		getComponent("far").changeToBoss()
		B.addBgComponent(self, getComponent("ground2"))
		B.addBgComponent(self, getComponent("tentacle"))
		do
			task.New(self, function()

			end)
		end
	end


	--场景变红
	function BG:changeToRed()
		getComponent("far").changeToRed()
		C.setAlpha(getComponent("ground"), 0)
		getComponent("balls").changeToRed()
		C.setAlpha(getComponent("tree"), 0)
		B.setFogColor(self, 255, 53, 13, 15)
		B.removeBgComponent(self, "leaf")
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

stage7_background = BG
