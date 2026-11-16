---======================================
---东方栖霞园二面背景
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

--二面背景素材加载
local stage_name = "s2"
local path = "res/background/stage2/"
local s2_reader = ReadClass.new(stage_name, path)
local function loadRes()
	--part1
	s2_reader:loadBgImgFromFile("part1", {"far1", "far2", "ground", "leaf", "light", "tree"}, path) --stage_name, folder_name, file_name_list, background_respath
	--part2
	s2_reader:loadBgImgFromFile("part2", {"far", "ball", "butterfly", "flower1", "flower2", "flower3", "ground", "tree", "light"}, path) --stage_name, folder_name, file_name_list, background_respath
end


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
			self.remove = function(obj)
				B.removeBgComponent(lstg.tmpvar.bg, "balls")
			end
		end,
--updateFunc
		function(self)
			if self.timer % 8 == 0 then
				local obj = B.createBgObjDirectly(s2_reader:getImg("part2", "ball"), 2, 2, --img
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
			--昼
			self.far1 = B.create2DBgObj(s2_reader:getImg("part1", "far1"), 0, 0, 0, 1, 1, "", 255, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			self.far2 = B.create2DBgObj(s2_reader:getImg("part1", "far2"), 0, 0, 0, 1, 1, "", 255, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			C.addBgObj(self, self.far1)
			C.addBgObj(self, self.far2)
			--夜
			self.far3 = B.create2DBgObj(s2_reader:getImg("part2", "far"), 0, 192, 0, 1, 1, "", 0, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			C.addBgObj(self, self.far3)

			--切换
			self.changeToNight = function(isBoss)
				if not isBoss then
					task.New(self, function()
						local t = 60
						local _a, d_a = 255, -255/t
						for _ = 1, t do
							_a = _a + d_a
							B.set2DBgObjColor(self.far1, _a, 255, 255, 255)
							B.set2DBgObjColor(self.far2, _a, 255, 255, 255)
							B.set2DBgObjColor(self.far3, (255 - _a), 255, 255, 255)
							task.Wait(1)
						end
						--把far1和far2移除
						table.remove(C.getBgObjList(self), 1)
						table.remove(C.getBgObjList(self), 1)
					end)
				else
					B.set2DBgObjColor(self.far1, 0, 255, 255, 255)
					B.set2DBgObjColor(self.far2, 0, 255, 255, 255)
					B.set2DBgObjColor(self.far3, 255, 255, 255, 255)
					--把far1和far2移除
					--table.remove(C.getBgObjList(self), 1)
					--table.remove(C.getBgObjList(self), 1)
				end
			end

			--直接切到晚上
			self.setNight = function()
				B.set2DBgObjColor(self.far3, 255, 255, 255, 255)
				--把far1和far2移除
				table.remove(C.getBgObjList(self), 1)
				table.remove(C.getBgObjList(self), 1)
			end
		end,
--updateFunc
		function(self)
			task.Do(self)
		end,
--is2D
		true
)

---背景定义

local BG = Class(B)
do
	local bg_vz = -0.075 --背景沿z坐标的速度
	local balls --背景组件
	local all_advance
	local lights = {} --特殊的Bgobj
	local createFlowers --创建地上花的函数

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
					B.createTileBgObjsTableDirectly({s2_reader:getImg("part1", "ground"), s2_reader:getImg("part2", "ground")}, 20, 20,
							0, 0, 10, {180, 90}, --x, y, z, rot,
							"", 255, 255, 255, 255, --blend, _a, _r, _g, _b,
							num_l, {90, 90}, len, --num_l, a0, dist,
							num_w, 0, wide  --num_w, a1, w
					)
			)
			C.sortByZ(com)
		end

		--两侧的树
		do
			local com_name = "tree"
			local imgs = {{10, 12}, {15, 15}, {20, 18}, {24, 24}}
			local num, len, wides = 6, 7, {8, 11, 14, 17}
			local com = setComponent(com_name, M.createAdvanceBgComponent2(com_name, 0, num*len, bg_vz, true)) --zmin, zmax, v
			for i = 1, #imgs do
				C.addBgObjs(com, B.createTwoSidesBgObjsTableDirectly({s2_reader:getImg("part1", "tree"), s2_reader:getImg("part2", "tree")},
						imgs[i][1], imgs[i][2], 0, 0.5*imgs[i][2], 5*(i - 1),  --img, img_w, img_h, x, y, z
						{90, -90}, "", 255, 255, 255, 255, num, {90, 90}, len, wides[i]))
			end
			--光线
			local num, len = 3, 20
			local u = -1
			for i = 1, #imgs do
				table.insert(lights,
						B.createConBgObjsTableDirectly(
								{s2_reader:getImg("part1", "light"), s2_reader:getImg("part2", "light")}, 84*u, 53.2,
								15*u, 15, 0.1 + 10*(i - 1), {90, -90}, "", 255, 255, 255, 255, num, {90, 90}, len
						)
				)
				C.addBgObjs(com, lights[#lights])
				u = -u
			end
			C.sortByZ(com)
		end

		--远景
		do
			local com_name = "far"
			setComponent(com_name, createFarComp(com_name, false))
		end

		--叶子
		do
			local com_name = "leaf"
			setComponent(com_name, createLeafComp(com_name, false))
		end

		--地上的花
		function createFlowers(bg)
			local com = getComponent("tree")
			local flower1 = {s2_reader:getImg("part2", "flower1"), s2_reader:getImg("part2", "flower1")}
			local flower2 = {s2_reader:getImg("part2", "flower2"), s2_reader:getImg("part2", "flower2")}
			local flower3 = {s2_reader:getImg("part2", "flower3"), s2_reader:getImg("part2", "flower3")}
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

		all_advance = { --所有会运动的背景
			getComponent("ground"),
			getComponent("tree")
		}
		balls = createBallComp("balls", false) --粒子球
	end

	local function addDayBgComponent(bg)
		B.addBgComponent(bg, getComponent("far"))
		B.addBgComponent(bg, getComponent("ground"))
		B.addBgComponent(bg, getComponent("tree"))
		B.addBgComponent(bg, getComponent("leaf"))
	end

	local function addNightBgComponent(bg)
		B.addBgComponent(bg, getComponent("far"))
		local far = getComponent("far")
		far.setNight() --直接变到晚上
		B.addBgComponent(bg, getComponent("ground"))
		local ground = getComponent("ground")
		C.setAlpha(ground, 0)
		B.addBgComponent(bg, getComponent("tree"))
		local tree = getComponent("tree")
		C.setAlpha(tree, 0)
	end

	local function addAllBgComponent(bg)
		addDayBgComponent(bg)
		--addNightBgComponent(bg)
	end

	--开幕(0-1560)
	function BG:Sence1(practice)
		B.setBaseParam(self,
				{0, 8, 6}, --eye_cen,
				{95, 90}, --eye_rot, --抬头
				0, --v,
				{90, -90}, --a,
				{90, 90}, --up_rot,
				1.5, --fovy,
				{0.1, 100}, --z
		        {0, 40, 255, 238, 152, 58} --fog --金色传说
		)
		if practice then
			addDayBgComponent(self)
		else
			addAllBgComponent(self) --添加所有背景组件
		end
		do
			task.New(self, function()
				local R = lstg.tmpvar.current_road
				--判断是否进入场景1
				while R.class.getSence(R) ~= 1 do
					task.Wait(1)
				end
				task.Wait(1560)
				BG.Sence2(self, false)
			end)
		end
	end

	--场景2（与一相同）（1560-2900)
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
					{0, 40, 255, 238, 152, 58} --fog --金色传说
			)
			addDayBgComponent(self)
		end
		do
			task.New(self, function()
				local R = lstg.tmpvar.current_road
				--判断是否进入场景2
				while R.class.getSence(R) ~= 2 do
					task.Wait(1)
				end
				task.Wait(1590 - 250)
				BG.Sence3(self, false)
			end)
		end
	end

	--场景3（开始天黑了）（2900-)
	function BG:Sence3(practice)
        if practice then
			B.removeAllBgComponent(self)
			B.setBaseParam(self,
					{0, 8, 6}, --eye_cen,
					{95, 90}, --eye_rot, --抬头
					0, --v,
					{90, -90}, --a,
					{90, 90}, --up_rot,
					1.5, --fovy,
					{0.1, 100}, --z
					{0, 40, 255, 238, 152, 58} --fog --金色传说
			)
            addAllBgComponent(self)
        end
		do
			task.New(self, function()
				local R = lstg.tmpvar.current_road
				if IsValid(R) then --是道中
					--判断是否进入场景3
					while R.class.getSence(R) ~= 3 do
						task.Wait(1)
					end
					task.Wait(1000)
					local ground = getComponent("ground")
					local tree = getComponent("tree")
					local far = getComponent("far")
					far.changeToNight()

					local t = 60
					local alpha, dalpha = 1, -1/t
					local _, _r, _g, _b = B.getFogColor(self)
					local d_r, d_g, d_b = (10 - _r)/t, (32 - _g)/t, (93 - _b)/t
					for _ = 1, t do
						alpha = alpha + dalpha
						--雾变化
						B.updateFogColor(self, 0, d_r, d_g, d_b)

						C.setAlpha(ground, alpha)
						C.setAlpha(tree, alpha)
						task.Wait(1)
					end
					C.setAlpha(ground, 0)
					C.setAlpha(tree, 0)
					createFlowers(self)
					task.Wait(3420 - 1000 + 60)
					local dbg_vz = (-0.025 -bg_vz)/240
					local leaf = getComponent("leaf")
					alpha, dalpha = 1, -1/240
					for _ = 1, 240 do --背景停下来
						alpha = alpha + dalpha
						C.setAlpha(leaf, alpha)
						bg_vz = bg_vz + dbg_vz
						for _, v in pairs(all_advance) do
							v.setV(v, bg_vz)
						end
						task.Wait(1)
					end
					C.setAlpha(leaf, 0)
					B.removeBgComponent(self, "leaf")
					task.Wait(120)
					BG.Sence4(self, false)
				else --仅符卡练习进入二道中boss练习才触发
					local ground = getComponent("ground")
					local tree = getComponent("tree")
					local far = getComponent("far")
					far.changeToNight(true)
					B.setFogColor(self, 0, 10, 32, 93)
					C.setAlpha(ground, 0)
					C.setAlpha(tree, 0)
					createFlowers(self)
					for _, v in pairs(all_advance) do
						v.setV(v, -0.05)
					end
				end
			end)
		end
	end


    --场景4（高潮）（7050-)
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
            addNightBgComponent(self)
			bg_vz = -0.025
			for _, v in pairs(all_advance) do
				v.setV(v, bg_vz)
			end
        end
		--添加粒子球
		B.addBgComponent(self, balls, "tree", 0)
        do
            task.New(self, function()
                local R = lstg.tmpvar.current_road
                --判断是否进入场景4
                while R.class.getSence(R) ~= 4 do
                    task.Wait(1)
                end
                local t = 200
                local rot = B.getEyeRot(self)
				local r0, r1 = B.getFogRange(self)
				local dr0, dr1 = (30 - r0)/t, (50 - r1)/t
                local d_rot, dbg_vz = (95 - rot)/t, -0.375/t
                B.accDecEyePos(self, 0.08, {180, 90}, 90, 90, 90)
                --B.accDecObjPos(self, far_night_obj, 0.035, {180, 90}, 90, 90, 90)
                for _ = 1, t do
					bg_vz = bg_vz + dbg_vz
					for _, v in pairs(all_advance) do
						v.setV(v, bg_vz)
					end
					B.updateFogRange(self, dr0, dr1)
                    B.updateEyeRot(self, d_rot, 0)
                    task.Wait(1)
                end
				--再慢下来
				task.Wait(1400)
				dbg_vz = 0.25/t
				for _ = 1, t do
					bg_vz = bg_vz + dbg_vz
					for _, v in pairs(all_advance) do
						v.setV(v, bg_vz)
					end
					task.Wait(1)
				end
            end)
        end
    end

	--场景5（boss)(正常是不会跳到这个场景的，只是boss练习时用）
	function BG:Sence5(practice, isStage3)
		if isStage3 then
			loadRes()
			BG.setDefault(self)
			stage2_background.tree = getComponent("tree")
			stage2_background.ground = getComponent("ground")
			stage2_background.far = getComponent("far")
		end
		if practice then
			B.setBaseParam(self,
					{0, 22.4, 6}, --eye_cen,
					{100, 90}, --eye_rot, --抬头
					0, --v,
					{90, -90}, --a,
					{90, 90}, --up_rot,
					1.5, --fovy,
					{0.1, 100}, --z
					{30, 50, 255, 10, 32, 93} --fog --夜晚
			)
			addNightBgComponent(self)
			B.addBgComponent(self, balls, "tree", 0)
			createFlowers(self)
			bg_vz = -0.15
			for _, v in pairs(all_advance) do
				v.setV(v, bg_vz)
			end
			createFlowers(self)
		end
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

stage2_background = BG
