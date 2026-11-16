---======================================
---东方栖霞园一面背景
---by S7UPID
---======================================

local setting = database.setting

local M = EGGlib.BG
local B = M.baseBG
local C = M.comp
local background_open = setting.effect.background --背景开关选项
local ran = lstg.Rand() --给背景专门配发的随机种子生成器
local FallingObjectInterface = EGGlib.BG.FallingObjectInterface --背景飘落物接口
local square_stroke = M.square_stroke --绘制方形边界的img

--背景素材加载
local function loadRes()
	LoadImageFromFile("fog", "res/effect/fog.png")
	LoadImageFromFile(EISlib.BossDefinition.Cirno.snow_img, "res/boss/Cirno/snow.png")
	local res_name = "s1_"
	local path = "res/background/stage1/"
	local filenames = {"water_red_1", "water_red_2", "far_red_1", "far_red_2",
					   "water_blue_1", "water_blue_2", "far_blue_1", "far_blue_2",
					   "leaf", "board"}
	for i = 1, #filenames do
		LoadImageFromFile(res_name .. filenames[i], path ..filenames[i] ..".png")
	end
end

--画面飘落物
local createSnowComp = C.createComponentClassFunc(
--initFunc
		function(self)
			--生成范围
			self.center_x, self.center_y, self.center_z = 0, 30, 30
			self.x_range, self.y_range, self.z_range = 20, 5, 15
			--生成角度
			self.theta, self.phi = 30, -90 --θ,φ
			self.theta_range, self.phi_range = 5, 20
			self.img = EISlib.BossDefinition.Cirno.snow_img
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
				local obj = B.createBgObjDirectly(self.img, s, s, --img, w, h
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
					B.setBgObjAlp(obj, min(B.getBgObjAlp(obj), 200))
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
	local lake_red, lake_blue, lake_light_red, lake_light_blue, far_red, far_blue, reflection_red, reflection_blue, board, fog, snow --背景组件
	local lake_light_BgObjs_t, board_BgObj, reflection_blue_BgObj --特殊的Bgobj
	function BG:setDefault()
		--加载背景纹理
		local imgs = {{"water_red_1", 40, 10},
					  {"water_red_2", 40, 10},
					  {"water_blue_1", 40, 10},
					  {"water_blue_2", 40, 10},
					  {"far_red_1", 75, 50},
					  {"far_blue_1", 75, 50},
					  {"far_red_2", 75, 50},
					  {"far_blue_2", 75, 50},
					  {"leaf", 1, 1},
					  {"board", 70, 80}
		}
		do
			local img_name, res_name, hscale, vscale
			for i = 1, #imgs do
				img_name, res_name, hscale, vscale = imgs[i][1], "s1_"..imgs[i][1], imgs[i][2], imgs[i][3]
				B.addToImg(self, img_name, res_name, hscale, vscale)
			end
		end

		--水面
		do
			local img = "water_blue_1"
			local num, _, len = 10, nil, 5
			lake_blue = M.createAdvanceBgComponent("lake_blue", 0, num*len, -0.05, true) --zmin, zmax, v
			C.addBgObjs(lake_blue, B.createConBgObjsTable(self, img, 0, 0, 10, {180, 90}, "", 255, 255, 255, 255, num, {90, 90}, len))
			C.sortByZ(lake_blue) --倒序，不然会出现问题
		end

		--水面亮光
		do
			local img = "water_blue_2"
			local num, _, len = 10, nil, 5
			lake_light_blue = M.createAdvanceBgComponent2("lake_blue", 0, num*len, -0.05, false) --zmin, zmax, v
			lake_light_BgObjs_t = B.createConBgObjsTable(self, {"water_blue_2", "water_red_2"}, 0, 0, 10, {180, 90}, "mul+add", 255, 0, 0, 0, num, {90, 90}, len)
			C.addBgObjs(lake_light_blue, lake_light_BgObjs_t)
			C.sortByZ(lake_light_blue) --倒序，不然会出现问题
		end

		--远景
		do
			local img = "far_blue_1"
			far_blue = M.createStaticBgComponent("far_blue", false)
			C.addBgObj(far_blue, B.createBgObj(self, img, 0, 10, 45, {90, -90}, "", 255))
			C.setAlpha(far_blue, 0) --0透明度

			img = "far_red_1"
			far_red = M.createStaticBgComponent("far_red", false)
			C.addBgObj(far_red, B.createBgObj(self, img, 0, 10, 45, {90, -90}, "", 255))
			C.setAlpha(far_red, 0) --0透明度
		end

		--倒影
		do
			local img = "far_blue_2"
			reflection_blue = M.createStaticBgComponent("reflection_blue", false)
			reflection_blue_BgObj = B.createBgObj(self, img, 0, -23, 45, {90, -90}, "", 255, 0, 0, 0)
			C.addBgObj(reflection_blue, reflection_blue_BgObj)
			--C.setAlpha(reflection_blue, 0) --0透明度

			img = "far_red_2"
			reflection_red = M.createStaticBgComponent("reflection_red", false)
			C.addBgObj(reflection_red, B.createBgObj(self, img, 0, -23, 45, {90, -90}, "", 255))
			C.setAlpha(reflection_red, 0) --0透明度
		end

		--底版
		do
			local img = "board"
			board = M.createStaticBgComponent("board", false)--fog
			board_BgObj = B.createBgObj(self, img, 0, -37.5, 45, {90, -90}, "", 255, 20, 20, 30)
			C.addBgObj(board, board_BgObj)
		end

		--高速雾
		do
			local com_name = "fog"
			local num_l = 4
			local len = 20

			local com = M.createAdvanceBgComponent(com_name, 0, num_l*len, -0.5, true)
			local index = 1
			for i = 0, num_l - 1 do
				for u = -1, 1, 2 do
					C.addBgObj(com,
							B.createBgObjDirectly("fog", 20, 40,  --img, w, h
									20*u, -10, 0 + 0.00001*u + len*i, {30, 90}, --x, y, z, rot
									"", 255, 255, 255, 255, 30) --blend, a
					)
					index = index + 1
				end
			end
			C.sortByZ(com)
			fog = com
		end

		--⑨雪花
		do
			local com_name = "snow"
			snow = createSnowComp(com_name, false)
		end
	end

	--开幕
	function BG:Sence1()
		B.setBaseParam(self,
				--{0, 2, 6}, --eye_cen,
				{0, 4, 6},
				--{95, 90}, --eye_rot, --抬头
				{140, 90},
				0, --v,
				{90, -90}, --a,
				{90, 90}, --up_rot,
				1.5, --fovy,
				{0.1, 100}, --z
				--{1, 20, 255, 255, 174, 0} --fog --金色传说
				--{1, 10, 255, 220, 220, 255} --fog --蓝色的雾之湖
				{1, 5, 255, 20, 20, 30} --fog  比较黑的时候
		)
		B.addBgComponent(self, board)
		B.addBgComponent(self, far_blue)
		B.addBgComponent(self, lake_blue)
		B.addBgComponent(self, reflection_blue)
		B.addBgComponent(self, lake_light_blue)
		--B.addBgComponent(self, fog)
		do
			task.New(self, function()
				local R = lstg.tmpvar.current_road
				--判断是否进入场景1
				while R.class.getSence(R) ~= 1 do
					task.Wait(1)
				end
				task.Wait(400)
				local _, range = B.getFogRange(self)
				local _, r, g, b = B.getFogColor(self)
				local t = 400
				local d_range, d_r, d_g, d_b = (10 - range)/t, (220 - r)/t, (220 - g)/t, (255 - b)/t
				local d_color, dalpha = 255/t, 1/t
				for _ = 1, t do
					for _, v in ipairs(lake_light_BgObjs_t) do
						B.updateBgObjRGB(v, d_color, d_color, d_color)
					end
					B.updateFogRange(self, 0, d_range)
					B.updateFogColor(self, 0, d_r, d_g, d_b)
					B.updateBgObjRGB(board_BgObj, d_r, d_g, d_b)
					B.updateBgObjRGB(reflection_blue_BgObj, d_color, d_color, d_color)
					C.addAlpha(reflection_blue, dalpha)
					C.addAlpha(far_blue, dalpha)
					task.Wait(1)
				end
				BG.Sence2(self)
				--受影响的 lake_light_BgObjs_t,  255, 255, 255, 255
				--         board_BgObj 255, 220, 220, 255
				-- fog param 1, 10, 255, 220, 220, 255
			end)
		end
	end

	function BG:Sence2(practice, no_road)
		B.setBaseParam(self,
		--{0, 2, 6}, --eye_cen,
				{0, 4, 6},
		--{95, 90}, --eye_rot, --抬头
				{140, 90},
				0, --v,
				{90, -90}, --a,
				{90, 90}, --up_rot,
				1.5, --fovy,
				{0.1, 100}, --z
		  {1, 10, 255, 220, 220, 255} --fog --蓝色的雾之湖
		)
		if practice then
			B.addBgComponent(self, board)
			B.addBgComponent(self, far_blue)
			B.addBgComponent(self, lake_blue)
			B.addBgComponent(self, reflection_blue)
			B.addBgComponent(self, lake_light_blue)
			for _, v in ipairs(lake_light_BgObjs_t) do
				B.setBgObjRGB(v, 255, 255, 255)
			end
			B.setBgObjRGB(board_BgObj, 220, 220, 255)
			B.setBgObjRGB(reflection_blue_BgObj, 255, 255, 255) --有倒影了
			C.setAlpha(far_blue, 1)
		end

		do
			task.New(self, function()
				if not no_road then
					local R = lstg.tmpvar.current_road
					--判断是否进入场景2
					while R.class.getSence(R) ~= 2 do
						task.Wait(1)
					end
				end
				task.Wait(1040)
				B.addBgComponent(self, snow)
				--视角抬高
				local t = 200
				local rot = B.getEyeRot(self)
				local d_rot = (95 - rot)/t
				for _ = 1, t do
					B.updateEyeRot(self, d_rot, 0)
					task.Wait(1)
				end
				BG.Sence3And4(self)
				--受影响的： self.eye_rot[1] = 95
			end)
		end
	end

	function BG:Sence3And4(practice, no_road)
		B.setBaseParam(self,
		--{0, 2, 6}, --eye_cen,
				{0, 4, 6},
				{95, 90}, --eye_rot, --抬头
				0, --v,
				{90, -90}, --a,
				{90, 90}, --up_rot,
				1.5, --fovy,
				{0.1, 100}, --z
				{1, 10, 255, 220, 220, 255} --fog --蓝色的雾之湖
		)
		if practice then
			B.removeAllBgComponent(self)
			B.addBgComponent(self, board)
			B.addBgComponent(self, far_blue)
			B.addBgComponent(self, lake_blue)
			B.addBgComponent(self, reflection_blue)
			B.addBgComponent(self, lake_light_blue)
			for _, v in ipairs(lake_light_BgObjs_t) do
				B.setBgObjRGB(v, 255, 255, 255)
			end
			B.setBgObjRGB(board_BgObj, 220, 220, 255)
			B.setBgObjRGB(reflection_blue_BgObj, 255, 255, 255) --有倒影了
			C.setAlpha(far_blue, 1)
			C.setAlpha(reflection_red, 0) --两种红色远景也要有透明度了现在
			C.setAlpha(far_red, 0)
			B.addBgComponent(self, snow)
		end

		B.setBgObjRGB(board_BgObj, 103, 41, 38)
		--以下是新增的组件
		B.addBgComponent(self, far_red, "far_blue", 1)
		B.addBgComponent(self, reflection_red, "reflection_blue", 1)
		do
			task.New(self, function()
				if not no_road then
					local R = lstg.tmpvar.current_road
					--判断是否进入场景3
					if R then
						while R.class.getSence(R) < 3 do
							task.Wait(1)
						end
						--判断是否进入场景4
						while R.class.getSence(R) < 4 do
							task.Wait(1)
						end
					end
					task.Wait(300)
					local t = 420
					local alpha, dalpha = 0, 1/t
					local _, _r, _g, _b = B.getFogColor(self)
					local d_r, d_g, d_b = (255 - _r)/t, (174 - _g)/t, (0 - _b)/t
					for _ = 1, t do
						alpha = alpha + dalpha
						B.updateFogColor(self, 0, d_r, d_g, d_b)
						--C.addAlpha(far_blue, -dalpha)
						C.addAlpha(far_red, dalpha)
						C.setAlpha(lake_light_blue, 1 - alpha)
						C.setAlpha(snow, 1 - alpha)
						--C.addAlpha(reflection_blue, -dalpha)
						C.addAlpha(reflection_red, dalpha)
						task.Wait(1)
					end
					B.removeBgComponent(self, "snow")
					B.removeBgComponent(self, "far_blue") --移除
					B.removeBgComponent(self, "reflection_blue") --移除
					BG.Sence5(self)
				end
			end)
		end
	end

	--最后一段道中与最终场景
	function BG:Sence5(practice)
		B.setBaseParam(self,
				{0, 4, 6},
				{95, 90}, --eye_rot, --抬头
				0, --v,
				{90, -90}, --a,
				{90, 90}, --up_rot,
				1.5, --fovy,
				{0.1, 100}, --z
				{1, 10, 255, 255, 174, 0} --fog --红色的雾之湖
		)
		if practice then
			B.addBgComponent(self, board)
			B.addBgComponent(self, far_red)
			B.addBgComponent(self, lake_blue)
			B.addBgComponent(self, reflection_red)
			B.addBgComponent(self, lake_light_blue)
			C.setAlpha(lake_light_blue, 0)
			for _, v in ipairs(lake_light_BgObjs_t) do
				B.setBgObjRGB(v, 255, 255, 255)
			end
			B.setBgObjRGB(board_BgObj, 103, 41, 38)
			C.setAlpha(reflection_red, 1) --两种红色远景也要有透明度了现在
			C.setAlpha(far_red, 1)
		end

		--最终场景
		do
		end
	end
end
function BG:init(sence, no_road)
	loadRes()
	
	lstg.tmpvar.bg = self --给boss操作用的
	B.init(self) --默认背景类的构造方法
	BG.setDefault(self) --该背景的构造方法

	local t = {BG.Sence1, BG.Sence2, BG.Sence3And4, BG.Sence5}
	if not sence or sence == 0 then --主线模式
		BG.Sence1(self)
	elseif type(sence) == "boolean" then --boss模式
		t[4](self, true)
	else --道中分段练习模式
		sence = min(6, sence)
		if sence < 3 then
			t[sence](self, true, no_road)
		elseif sence == 3 or sence == 4 then
			t[3](self, true, no_road)
		elseif sence == 5 or sence == 6 then
			t[4](self, true)
		end
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

stage1_background = BG
