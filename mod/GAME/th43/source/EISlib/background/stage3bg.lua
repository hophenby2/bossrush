---======================================
---东方栖霞园三面背景
---by S7UPID
---======================================

local setting = database.setting

local M = EGGlib.BG
local B = M.baseBG
local C = M.comp
local background_open = setting.effect.background --背景开关选项
local ran = lstg.Rand() --给背景专门配发的随机种子生成器

--背景素材加载
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
end

--闪黑
local flash = Class(object)
function flash:init()
	self.x, self.y = 0, 0
	self.img = "white"
	self.hscale, self.vscale = 100, 100
	robject.set_color(self, "", 0, 0, 0, 0)
	task.New(self, function()
		local d_a = 255/10
		for _ = 1, 10 do
			self._a = self._a + d_a
			task.Wait(1)
		end
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

--地面景物和远景
local createFarComp = C.createComponentClassFunc(
--initFunc
		function(self)
			local bg = B.create2DBgObj("white", 0, 0, 0, 50, 75, "", 0, 255, 255, 255) --img, x, y, rot, hscale, vscale, blend, a, r, g, b
			C.addBgObj(self,
					bg
			)
			self.change = function(background_inst)
				task.New(self, function()
					task.Wait(140)
					local t = 60
					local _a, d_a = 0, 255/t
					for _ = 1, t do
						_a = _a + d_a
						B.set2DBgObjColor(bg, _a, 255, 255, 255)
						task.Wait(1)
					end
					t = 60
					_a, d_a = 255, -255/t
					local r, g, b = 255, 255, 255
					local dr, dg, db = (113 - r)/t, (40 - g)/t, (13 - b)/t
					for _ = 1, t do
						r, g, b = r + dr, g + dg, b + db
						_a = _a + d_a
						B.set2DBgObjColor(bg, _a, r, g, b)
						task.Wait(1)
					end
					B.removeBgComponent(background_inst, "board")
				end)
			end
		end,
--updateFunc
		function(self)
			task.Do(self)
		end,
--is2D
		true
)

--特殊组件定义（背景的粒子花
local createFlowerComp = C.createComponentClassFunc(
        --initFunc
		function(self)
			self.rate = 0 --产生蓝花的几率，若不产生蓝花则产生红花
			self.updateRate = function(obj, drate)
				obj.rate = max(0, min(1.01, obj.rate + drate))
			end
		end,
        --updateFunc
		function(self)
			if self.timer % 4 == 0 then
				local obj
				if ran:Float(0, 1) >= self.rate then --产生红花
					obj = B.createBgObj(lstg.tmpvar.bg, "flower_fly1", --img
							ran:Float(-15, 15), 0, ran:Float(10, 30), {ran:Float(95, 135), -90}, --x, y, z, rot
							"", 0) --blend, a
				else --产生蓝花
					obj = B.createBgObj(lstg.tmpvar.bg, "flower_fly2", --img
							ran:Float(-15, 15), 0, ran:Float(10, 30), {ran:Float(95, 135), -90}, --x, y, z, rot
							"", 0) --blend, a
				end
				obj.vx = ran:Float(-0.001, 0.001)*0
				obj.vy = ran:Float(0.05, 0.1)*0.5
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

---背景定义
local BG = Class(B)
do
	local bg_vz = -0.075
	local magic, cave1, cave2, board,
	clouds_day, clouds_night, far_day, far_night, ground_day, ground_night,
	far_building_day, far_building_night, flowers --背景组件
	local all_day, all_night, all_day_and_night --管理白天和夜晚所有元素的表
	local magic_obj, magic_bg_obj --特殊obj
	function BG:setDefault()
		bg_vz = -0.075
		--加载背景纹理
		local far_size = 3.75
		local cloud_size = 1.5
		local imgs = { --注：同一行是相同的背景元素，左白天右夜晚
			{"magic", 50, 50},
			{"magic_bg", 100, 100},
			{"far1", 24*far_size, 28*far_size}, {"far2", 24*far_size, 28*far_size},
			{"moutain1", 22*far_size, 9*far_size}, {"moutain2", 22*far_size, 9*far_size},
			{"far_building1", 60*0.7, 18*0.6}, {"far_building2", 60*0.7, 18*0.6},
			{"ground1", 15, 10}, {"ground2", 15, 10},
			{"flower_fly1", 3.1*0.25, 5.6*0.25}, {"flower_fly2", 3.1*0.25, 5.6*0.25},
			{"cloud1", 6.3*cloud_size, 4.6*cloud_size}, {"cloud3", 6.3*cloud_size, 4.6*cloud_size},
			{"cloud2", 6.3*cloud_size, 2.6*cloud_size}, {"cloud4", 6.3*cloud_size, 2.6*cloud_size},
			{"star1", 1*cloud_size, 1*cloud_size},
		}
		do
			local img_name, res_name, hscale, vscale
			for i = 1, #imgs do
				img_name, res_name, hscale, vscale = imgs[i][1], "s3_"..(imgs[i][4] or imgs[i][1]), imgs[i][2], imgs[i][3]
				B.addToImg(self, img_name, res_name, hscale, vscale)
			end
		end

		--黑洞的白底
		do
			local com_name = "board"
			board =createFarComp(com_name, false)
		end

		--穿越过程中
		do
			magic = M.createStaticBgComponent("magic", false)
			magic_bg_obj = B.createBgObj(self, "magic_bg", --img
					0, 74.6, 50, {90, -90}, --x, y, z, rot
					"mul+add", 255) --blend, a
			C.addBgObj(magic, magic_bg_obj)
			magic_obj = B.createBgObj(self, "magic", --img
					0, 74.6, 50, {90, -90}, --x, y, z, rot
					"mul+add", 255) --blend, a
			C.addBgObj(magic, magic_obj)
			C.setAlpha(magic, 0)

			--隧道
			local radius, n_r, len, n_l = 15, 16, 60, 10
			cave1 = M.createAdvanceBgComponent("cave1", 0, len, -0.4, true)
			C.addBgObjs(cave1,
					B.createCurvedBgObjsTable(self, "s3_cave1", --bg, tex
							0, 6, 0,
							"mul+add", 255, 255, 255, 255,
							radius, n_r, len, n_l
					)
			)
			C.sortByZ(cave1)
			C.setAlpha(cave1, 0)

			n_r = 32 --分割数要多一点
			cave2 = M.createAdvanceBgComponent("cave2", 0, len, -0.4, true)
			C.addBgObjs(cave2,
					B.createCurvedBgObjsTable(self, "s3_cave2", --bg, tex
							0, 6, 0,
							"", 255, 255, 255, 255,
							radius, n_r, len, n_l
					)
			)
			C.sortByZ(cave2)
			C.setAlpha(cave2, 0)
		end

		--穿越之后的场景
		--地面
		do
			--白天
			local img = "ground1"
			local num_l, len, num_w, wide = 6, 10, 4, 15
			ground_day = M.createAdvanceBgComponent("ground_day", 0, num_l*len, bg_vz, true) --zmin, zmax, v
			C.addBgObjs(ground_day,
					B.createTileBgObjsTable(self, img,
							0, 0, 0, {180, 90}, --x, y, z, rot,
							"", 255, 255, 255, 255, --blend, _a, _r, _g, _b,
							num_l, {90, 90}, len, --num_l, a0, dist,
							num_w, 0, wide  --num_w, a1, w
					)
			)
			C.sortByZ(ground_day)

			--夜晚
			local img = "ground2"
			local num_l, len, num_w, wide = 6, 10, 4, 15
			ground_night = M.createAdvanceBgComponent("ground_night", 0, num_l*len, bg_vz, true) --zmin, zmax, v
			C.addBgObjs(ground_night,
					B.createTileBgObjsTable(self, img,
							0, 0, 0, {180, 90}, --x, y, z, rot,
							"", 255, 255, 255, 255, --blend, _a, _r, _g, _b,
							num_l, {90, 90}, len, --num_l, a0, dist,
							num_w, 0, wide  --num_w, a1, w
					)
			)
			C.sortByZ(ground_night)
			C.setAlpha(ground_night, 0) --0透明度
		end

		--两侧的云
		do
			--白天
			local imgs = {{"cloud1", 4}, {"cloud2", 4}}
			local num, len, wides, n = 7, 2, {12, 12}, #imgs
			local dwide = 3/(n - 1)
			n = (n - 1)/2
			clouds_day = M.createAdvanceBgComponent("clouds_day", 0, num*len, -0.1, true) --zmin, zmax, v
			local i = 1
			for j = -n, n do
				C.addBgObjs(clouds_day, B.createTwoSidesBgObjsTable(self, imgs[i][1],
						dwide*j, imgs[i][2], 1*(i - 1), {150, -90}, --x, y, z, rot
						"", 255, 255, 255, 255, --blend, a, r, g, b
						num, {90, 90}, len, wides[i]) --num, angle, dist, wide
				)
				i = i + 1
			end
			C.sortByZ(clouds_day)

			--夜晚
			local imgs = {{"cloud3", 4}, {"cloud4", 4}}
			local num, len, wides, n = 7, 2, {12, 12}, #imgs
			local dwide = 3/(n - 1)
			n = (n - 1)/2
			clouds_night = M.createAdvanceBgComponent("clouds_night", 0, num*len, -0.1, true) --zmin, zmax, v
			local i = 1
			for j = -n, n do
				C.addBgObjs(clouds_night, B.createTwoSidesBgObjsTable(self, imgs[i][1],
						dwide*j, imgs[i][2], 1*(i - 1), {150, -90}, --x, y, z, rot
						"", 255, 255, 255, 255, --blend, a, r, g, b
						num, {90, 90}, len, wides[i]) --num, angle, dist, wide
				)
				i = i + 1
			end
			C.sortByZ(clouds_night)
			C.setAlpha(clouds_night, 0) --0透明度
		end

		--远景
		do
			--白天
			local imgs = {{"far1", -11}, {"moutain1", 8}}
			far_day = M.createStaticBgComponent("far_day", false)
			for i = 1, #imgs do
				C.addBgObj(far_day, B.createBgObj(self, imgs[i][1], --img
						0, imgs[i][2], 50, {120, -90}, --x, y, z, rot
						"", 255) --blend, a
				)
			end

			--夜晚
			local imgs = {{"far2", -11}, {"moutain2", 8}}
			far_night = M.createStaticBgComponent("far_night", false)
			for i = 1, #imgs do
				C.addBgObj(far_night, B.createBgObj(self, imgs[i][1], --img
						0, imgs[i][2], 50, {120, -90}, --x, y, z, rot
						"", 255) --blend, a
				)
			end
			C.setAlpha(far_night, 0) --0透明度
		end

		--远景建筑物
		do
			--白天
			local img = "far_building1"
			far_building_day = M.createStaticBgComponent("far_building_day", false)
			C.addBgObj(far_building_day, B.createBgObj(self, img, --img
					0, 5.75, 45, {120, -90}, --x, y, z, rot
					"", 255) --blend, a
			)
			--C.setAlpha(far_building_day, 0)

			--夜晚
			local img = "far_building2"
			far_building_night = M.createStaticBgComponent("far_building_night", false)
			C.addBgObj(far_building_night, B.createBgObj(self, img, --img
					0, 5.75, 45, {120, -90}, --x, y, z, rot
					"", 255) --blend, a
			)
			C.setAlpha(far_building_night, 0) --0透明度
		end

		--花
		flowers = createFlowerComp("flowers", false)

		all_day = {clouds_day, far_day, ground_day, far_building_day}
		all_night = {clouds_night, far_night, ground_night, far_building_night}

		all_day_and_night = {clouds_day, far_day, ground_day, far_building_day,
							 clouds_night, far_night, ground_night, far_building_night
		}
	end

	local function addDayBgComponent(bg)
		for _, v in pairs(all_day) do
			B.addBgComponent(bg, v)
		end
	end

	local function addNightBgComponent(bg)
		for _, v in pairs(all_night) do
			B.addBgComponent(bg, v)
		end
	end

	local function addAllBgComponent(bg)
		addDayBgComponent(bg)
		addNightBgComponent(bg)
		B.addBgComponent(bg, flowers)
	end

	local function addAllBgComponentAndSetAlpha0(bg)
		--B.removeBgComponent("board")
		for _, v in pairs(all_day_and_night) do
			C.setAlpha(v, 0)
			B.addBgComponent(bg, v)
		end
		B.addBgComponent(bg, flowers)
		--B.addBgComponent(bg, board)
		bg_vz = 0 --速度设为0
		ground_day.setV(ground_day, bg_vz)
		ground_night.setV(ground_night, bg_vz)
	end

	--开幕
	function BG:Sence1(practice)
		stage2_background.Sence5(self, true, true) --bg, practice, isStage3
		B.addBgComponent(self, magic)
		B.addBgComponent(self, cave2)
		B.addBgComponent(self, cave1)
		--B.addBgComponent(self, board)
		do
			task.New(self, function()
				local function updateWait(t)
					for _ = 1, t do
						B.updateObjAngle(magic_obj, -1)
						B.updateObjAngle(magic_bg_obj, 1) --尊重科学事实，因为是北半球所以星轨逆时针转.jpg
						task.Wait(1)
					end
				end
				local R = lstg.tmpvar.current_road
				--判断是否进入场景1
				while R.class.getSence(R) ~= 1 do
					task.Wait(1)
				end
				self.timer = 0
				--往上飞
				B.accDecEyePos(self, 0.135, {180, 90}, 180, 180, 180)
				local far_night = stage2_background.getComponent("far").far3
				local x_f, y_f = B.get2DBgObjPos(far_night)
				task.New(self, function()
					task.Wait(120)
					local t = 90
					local dy, d_dy = 0, -1/t
					for _ = 1, t do
						dy = dy + d_dy
						y_f = y_f + dy
						B.set2DBgObjPos(far_night, x_f, y_f)
						task.Wait(1)
					end
					t = 90
					for _ = 1, t do
						y_f = y_f + dy
						B.set2DBgObjPos(far_night, x_f, y_f)
						task.Wait(1)
					end
					t = 180
					d_dy = -dy/t
					for _ = 1, t do
						dy = dy + d_dy
						y_f = y_f + dy
						B.set2DBgObjPos(far_night, x_f, y_f)
						task.Wait(1)
					end
				end)
				updateWait(180)
				local t = 120
				local rot = B.getEyeRot(self)
				local r0, r1 = B.getFogRange(self)
				local dr0, dr1 = (15 - r0)/t, (35 - r1)/t
				local d_rot, dalpha = (91 - rot)/t, -1/t
				for _ = 1, t do
					--C.addAlpha(stage2_background.ground_night, dalpha)
					--C.addAlpha(stage2_background.trees_night, dalpha)
					C.addAlpha(magic, -dalpha)
					B.updateFogRange(self, dr0, dr1)
					B.updateEyeRot(self, d_rot, 0)
					updateWait(1)
				end
				B.removeBgComponent(self, "ground")
				B.removeBgComponent(self, "tree")
				--Del(stage2_background.ground_night)
				--Del(stage2_background.trees_night)
				updateWait(360)
				--往前进
				B.accDecEyePos(self, 0.2, {90, 90}, 90, 120, 1)
				task.New(self, function()
					local s = B.get2DBgObjSize(far_night)
					local t = 210
					local ds = 0.5/t
					for _ = 1, t do
						s = s + ds
						 B.set2DBgObjSize(far_night, s, s)
						task.Wait(1)
					end
				end)
				updateWait(90)
				t = 120
				local r0, r1 = B.getFogRange(self)
				local _, _r, _g, _b = B.getFogColor(self)
				local dr0, dr1, d_r, d_g, d_b = (15 - r0)/t, (35 - r1)/t, (0 - _r)/t, (0 - _g)/t, (0 - _b)/t
				dalpha = 1/t
				local x, y, z
				for _ = 1, t do
					x, y, z = B.getEyeCen(self)
					B.updateFogRange(self, dr0, dr1)
					B.updateFogColor(self, 0, d_r, d_g, d_b)
					C.addAlpha(cave1, dalpha)
					C.addAlpha(cave2, dalpha)
					C.addAlpha(magic, -dalpha)
					updateWait(1)
				end
				New(flash)
				updateWait(10) --1111
				--把不会显示的都移除吧
				B.removeBgComponent(self, "balls")
				B.removeBgComponent(self, "magic")
				local _, dy, dz = B.getEyeCen(self)
				dy, dz = (6 - dy), (6 - dz)
				--同步一下所有东西的位置

				B.updateEyeCen(self, 0, dy, dz) --视野中心反回至0, 6, 6
				do
					x, y, z = B.getEyeCen(self)
					B.updateBgObjPos(magic_obj, 0, dy, dz)
					B.updateBgObjPos(magic_bg_obj, 0, dy, dz)
					--B.updateBgObjPos(stage2_background.far_night_obj, 0, dy, 0)
				end
				local _a = 255
				local d_a = -255/60
				for _ = 1, 60 do
					_a = _a + d_a
					--C.addAlpha(stage2_background.far_night, dalpha)
					B.set2DBgObjColor(far_night, _a, 255, 255, 255)
					updateWait(1)
				end --1171
				B.removeBgComponent(self, "far")
				--东方跟着转！
				task.New(self, function()
					local rot = B.getEyeRot(self)
					local t, dt, drot = 0, 360/600, (135 - rot)/600
					local vz, dvz = -0.4, -1.6/600
					for _ = 1, 600 do
						t = t + dt
						B.setUpRot(self, 90 + 2*sin(t), 90)
						B.updateEyeRot(self, drot, 0)
						vz = vz + dvz
						cave1.setV(cave1, vz)
						cave2.setV(cave2, vz)
						task.Wait(1)
					end
				end)
				t = 360
				updateWait(360)
				--board.change(self)
				B.accDecEyePos(self, 0.1, {180, 90}, 50, 100, 50) --起飞
				local d_fovy = -0.5/200
				for i = 1, 4 do
					for _ = 1, 50 do
						B.updateFovy(self, d_fovy)
						updateWait(1)
					end
					--effect.shakeScreen(50, 3 + 2*i)
				end
				B.accDecEyePos(self, -0.2, {180, 90}, 30, 70, 30) --降落
				addAllBgComponentAndSetAlpha0(self) --把三面的都加进来吧
				t = 60
				_, _r, _g, _b = B.getFogColor(self)
				d_r, d_g, d_b = (234 - _r)/t, (131 - _g)/t, (30 - _b)/t
				dalpha = 1/t
				--快速过场切换
				for _ = 1, t do
					for _, v in pairs(all_day) do
						C.addAlpha(v, dalpha)
					end
					C.addAlpha(cave1, -dalpha)
					C.addAlpha(cave2, -dalpha)
					B.updateFogColor(self, 0, d_r, d_g, d_b)
					updateWait(1)
				end
				B.removeBgComponent(self, "cave1")
				B.removeBgComponent(self, "cave2")
				task.Wait(10)
				B.accDecEyePos(self, 0.1, {180, 90}, 20, 10, 60) --xx没有反弹（雾
				task.Wait(50)
				t, rot = 120, B.getEyeRot(self)
				d_fovy = 0.5/t
				--local drot = (120 - rot)/t
				local dbg_vz = -0.075/t
				for i = 1, t do --抬起头来（标题差不多在这里插入吧
					bg_vz = bg_vz + dbg_vz --加速
					ground_day.setV(ground_day, bg_vz)
					ground_night.setV(ground_night, bg_vz)
					B.updateFovy(self, d_fovy)
					B.setEyeRot(self, rot + 0.5*(1 - cos(1.5*i))*(120 - rot), 90)
					--B.updateEyeRot(self, drot, 0)
					task.Wait(1)
				end
				BG.Sence2(self, false)
			end)
		end
	end

	--进入新世界(2-3:1800 - 3550 共1750f)
	function BG:Sence2(practice)
		if practice then
			self.timer = 1800
			addAllBgComponent(self)
			B.setBaseParam(self,
					{0, 6, 6}, --eye_cen,
					{120, 90}, --eye_rot, --抬头
					0, --v,
					{90, -90}, --a,
					{90, 90}, --up_rot,
					1.5, --fovy,
					{0.1, 100}, --z
					{15, 35, 255, 234, 131, 30} --fog --黄昏色
			)
		end
		do
			task.New(self, function()
				local R = lstg.tmpvar.current_road
				--判断是否进入场景2
				while R.class.getSence(R) ~= 2 do
					task.Wait(1)
				end
				task.Wait(1750)
				BG.Sence3(self, false)
			end)
		end
	end

	--3其实也没啥变化, 和2一样的(3-4:3550 - 5240 共1690f)
	function BG:Sence3(practice)
		if practice then
			self.timer = 3550
			addAllBgComponent(self)
			B.addBgComponent(self, flowers)
			B.setBaseParam(self,
					{0, 6, 6}, --eye_cen,
					{120, 90}, --eye_rot, --抬头
					0, --v,
					{90, -90}, --a,
					{90, 90}, --up_rot,
					1.5, --fovy,
					{0.1, 100}, --z
					{15, 35, 255, 234, 131, 30} --fog --黄昏色
			)
		end
		do
			task.New(self, function()
				local R = lstg.tmpvar.current_road
				--判断是否进入场景3
				while R.class.getSence(R) ~= 3 do
					task.Wait(1)
				end
				task.Wait(1690)
				BG.Sence4(self, false)
			end)
		end
	end

	--4开始变成夜晚(一共2500f
	function BG:Sence4(practice)
		if practice then
			self.timer = 5240
			addAllBgComponent(self)
			B.setBaseParam(self,
					{0, 6, 6}, --eye_cen,
					{120, 90}, --eye_rot, --抬头
					0, --v,
					{90, -90}, --a,
					{90, 90}, --up_rot,
					1.5, --fovy,
					{0.1, 100}, --z
					{15, 35, 255, 234, 131, 30} --fog --黄昏色 --到夜晚色 31 132 193
			)
		end
		do
			task.New(self, function()
				local R = lstg.tmpvar.current_road
				--判断是否进入场景4
				while R.class.getSence(R) ~= 4 do
					task.Wait(1)
				end
				--C.setFog(ground_day, 20, 40, 255, 234, 131, 30)
				--一共有2500f
				local t = 2500
				local dalpha, drate = 1/t, 1/t
				local _, _r, _g, _b = B.getFogColor(self)
				local d_r, d_g, d_b = (31 - _r)/t, (132 - _g)/t, (193 - _b)/t
				for _ = 1, t do
					B.updateFogColor(self, 0, d_r, d_g, d_b)
					for _, v in pairs(all_day) do
						C.addAlpha(v, -dalpha)
					end
					for _, v in pairs(all_night) do
						C.addAlpha(v, dalpha)
					end
					flowers.updateRate(flowers, drate) --蓝花开始逐渐替代红花
					task.Wait(1)
				end
				BG.Sence5(self, false)
			end)
			--受影响的
			-- fog param 1, 10, 255, 31, 132, 193
		end
	end

	--5就是纯夜晚了~
	function BG:Sence5(practice, isStage4)
		if isStage4 then
			BG.setDefault(self)
			practice = true --默认为true
		end
		if practice then
			if not isStage4 then
				self.timer = 7740
			else
				self.timer = 0
			end
			addNightBgComponent(self)
			B.addBgComponent(self, flowers)
			flowers.updateRate(flowers, 1)
			for _, v in pairs(all_night) do
				C.setAlpha(v, 1)
			end
			B.setBaseParam(self,
					{0, 6, 6}, --eye_cen,
					{120, 90}, --eye_rot, --抬头
					0, --v,
					{90, -90}, --a,
					{90, 90}, --up_rot,
					1.5, --fovy,
					{0.1, 100}, --z
					{15, 35, 255, 31, 132, 193} --fog --黄昏色 --到夜晚色 31 132 193
			)
		else
			do
				task.New(self, function()
					local R = lstg.tmpvar.current_road
					--判断是否进入场景5
					while R.class.getSence(R) ~= 5 do
						task.Wait(1)
					end
				end)
			end
		end
	end
end
function BG:init(sence)
	loadRes()
	
	lstg.tmpvar.bg = self --给boss操作用的
	B.init(self) --默认背景类的构造方法
	BG.setDefault(self) --该背景的构造方法
	
	local t = {BG.Sence1, BG.Sence2, BG.Sence3, BG.Sence4, BG.Sence5, BG.Sence5}
	if not sence or sence == 0 then --主线模式
		BG.Sence1(self)
	elseif type(sence) == "boolean" then --boss模式
		t[5](self, true)
	else --道中分段练习模式
		sence = min(6, sence)
		t[sence](self, true)
	end
end
function BG:frame()
	background_open = setting.effect.background
	if background_open then
		B.frame(self)
		if self.timer >= 1800 then
			B.setUpRot(self, 90, 90 + 3*sin(0.25*(self.timer - 1800)))
		end
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

stage3_background = BG
