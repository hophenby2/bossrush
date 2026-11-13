---======================================
---私人背景库
---by S7UPID
---2020.1.8
---======================================
eggbg = {}

--导入臭蛾子的数学库
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

--输入纹理中心坐标以及宽度高度以及初始朝向向量，返回纹理四个渲染顶点，相关参数：x, y, z, l, h, rot
eggbg.Get_Four_Points = Get_Four_Points
eggbg.Get_Opposite_Vector = Get_Opposite_Vector
eggbg.ballToVect3 = ballToVect3

--背景元素类(如飘来的云和樱花)
local bgobject

--整个背景对象模版
local BG = Class(background)
--背景类基本方法
do
	function BG:setDefault()
		self.layer = LAYER_BG
		self.eye_pos = { 0, 4, 0 } --眼睛的初始位置
		self.eye_rot = { 150, 90 } --1球坐标系的θ，取值0到180  2球坐标系的φ，取值0到360（当然也可以更高）
		--这里是转化到at视角的方向单位向量
		self.eye_rot3 = { sin(self.eye_rot[1]) * cos(self.eye_rot[2]), cos(self.eye_rot[1]), sin(self.eye_rot[1]) * sin(self.eye_rot[2]) } --眼睛朝向的单位法向量(这里是默认向下60度)(采用球坐标系, r = 1, 此处θ = 120,φ = -90)
		--背景的朝向（背景向前移动方向）
		self.bg_rot = { 90, -90 }
		--背景的朝向的单位方向向量
		self.bg_rot3 = { sin(self.bg_rot[1]) * cos(self.bg_rot[2]), cos(self.bg_rot[1]), sin(self.bg_rot[1]) * sin(self.bg_rot[2]) } --背景前进的方向的法向量(其反方向也是生成背景元素的方向)
		--背景前进的速度
		self.bg_speed = 0.04
		--对应于set3d的up的球坐标形式
		self.up_rot = { 90, 90 }
		self.up = ballToVect3(self.up_rot)
		--对应于set3d的fovy
		self.fovy = { 1.5 }
		--对应于set3d的z
		self.z = { 0.1, 100 }
		--对应于set3d的fog
		self.fog = { 100, 100, 0, 255, 255, 175 }
		Set3D('eye', self.eye_pos[1], self.eye_pos[2], self.eye_pos[3])
		Set3D('at', self.eye_pos[1] + self.eye_rot3[1], self.eye_pos[2] + self.eye_rot3[2], self.eye_pos[3] + self.eye_rot3[3]) --暂且让眼睛的视角向下约30度吧
		Set3D('up', self.up[1], self.up[2], self.up[3]) --三个参数都是控制整个背景旋转的，默认0,0,0.5就是正常的，一般不需要动
		Set3D('fovy', self.fovy[1]) --暂且认为是全局缩放，值越大看得越远
		Set3D('z', self.z[1], self.z[2]) --渲染范围
		Set3D('fog', self.fog[1], self.fog[2], Color(self.fog[3], self.fog[4], self.fog[5], self.fog[6])) --雾气
		self.imgs = {} --自身的元素表初始化
		self.static = {} --存储静止的对象
		self.active = {} --存储直线运动的对象
		self.objs = {} --渲染对象顺序的表
		self.static2dfont = {} --2d的静止贴图(先于3d渲染
		self.static2drear = {} --2d的静止贴图(后于3d渲染
	end
	--以字符串名为索引把纹理加入到该背景元素表中
	---@param img string @索引名
	---@param tex string @纹理名
	---@param w number @在背景中的宽
	---@param h number @在背景中的高
	function BG:addToImg(img, tex, w, h)
		self.imgs[img] = { tex, w, h }
	end
	--以索引名获取纹理名
	---@param img string @索引名
	function BG:getImgTex(img)
		return self.imgs[img][1]
	end
	--以索引名获取纹理在背景中的宽和高
	---@param img string @索引名
	function BG:getImgWH(img)
		return self.imgs[img][2], self.imgs[img][3]
	end
	--把创建好的静止的obj对象加入表中
	---@param obj table @背景元素对象
	function BG:addToStaticObj(obj, pos)
		if pos then
			table.insert(self.static, pos, obj)
		else
			table.insert(self.static, obj)
		end
	end
	--把创建好的动态的obj对象加入表中
	---@param obj table @背景元素对象
	function BG:addToActiveObj(obj)
		table.insert(self.active, obj)
	end
	--把普通obj加入到渲染顺序中
	---@param obj table @实例化的背景元素的对象
	---@param pos number @在渲染顺序表的位置， 不填则默认最后（渲染层最高）
	function BG:addToRender(obj, pos)
		if pos then
			table.insert(self.objs, pos, obj)
		else
			table.insert(self.objs, obj)
		end
	end
	--把创建好的静态的2dobj对象加入表中
	---@param obj table @背景元素对象
	function BG:addToStatic2dFontObj(obj)
		table.insert(self.static2dfont, obj)
	end
	---@param obj table @背景元素对象
	function BG:addToStatic2dRearObj(obj)
		table.insert(self.static2drear, obj)
	end
	--只创建对象，不加入任何对象表（适用于手动添加特殊对象）
	function BG:creatSimObj(img, x, y, z, rot, blend, _a)
		blend = blend or ""
		_a = _a or 255
		local tex = BG.getImgTex(self, img)
		local w, h = BG.getImgWH(self, img) --读取对应纹理在背景里的宽高
		local p = Get_Four_Points(x, y, z, w, h, ballToVect3(rot)) --获取点
		local obj = { { tex, blend, _a }, p, { x, y, z }, { rot[1], rot[2] } } --现在规定rot只能是球坐标
		return obj
	end
	--根据索引在背景里创建新静止对象
	---@param img string @索引名
	---@param rot table @只能是ball创建的对象({a, b})
	---@return table @返回静止的背景元素对象
	function BG:creatStaticObj(img, x, y, z, rot, blend, _a, pos)
		blend = blend or ""
		_a = _a or 255
		local tex = BG.getImgTex(self, img)
		local w, h = BG.getImgWH(self, img) --读取对应纹理在背景里的宽高
		local p = Get_Four_Points(x, y, z, w, h, ballToVect3(rot)) --获取点
		local obj = { { tex, blend, _a }, p, { x, y, z }, { rot[1], rot[2] } } --现在规定rot只能是球坐标
		BG.addToStaticObj(self, obj, pos)
		return obj
	end
	--根据索引在背景里创建新静止2d对象
	---@param img string @索引名
	---@param rot table @只能是ball创建的对象({a, b})
	---@return table @返回静止的背景元素对象
	function BG:creatStatic2dFontObj(img, x, y, rot, blend, _a, hscale, vscale)
		blend = blend or ""
		_a = _a or 255
		hscale, vscale = hscale or 1, vscale or 1 --读取对应纹理在背景里的宽高
		local obj = { { img, blend, _a }, { hscale, vscale }, { x, y }, rot }
		BG.addToStatic2dFontObj(self, obj)
		return obj
	end
	function BG:creatStatic2dRearObj(img, x, y, rot, blend, _a, hscale, vscale)
		blend = blend or ""
		_a = _a or 255
		hscale, vscale = hscale or 1, vscale or 1 --读取对应纹理在背景里的宽高
		local obj = { { img, blend, _a }, { hscale, vscale }, { x, y }, rot }
		BG.addToStatic2dRearObj(self, obj)
		return obj
	end
	--根据索引在背景里创建新普通对象
	---@param img string @索引名
	---@param rot table @只能是ball创建的对象({a, b})
	---@return table @返回静止的背景元素对象
	function BG:creatObj(img, x, y, z, rot, pos, blend, _a)
		blend = blend or ""
		_a = _a or 255
		local tex = BG.getImgTex(self, img)
		local w, h = BG.getImgWH(self, img) --读取对应纹理在背景里的宽高
		local p = Get_Four_Points(x, y, z, w, h, ballToVect3(rot)) --获取点
		local obj = { { tex, blend, _a }, p, { x, y, z }, { rot[1], rot[2] } }
		BG.addToRender(self, obj, pos)
		return obj
	end
	--根据索引在背景里创建新动态对象
	---@param img string @索引名
	---@param rot table @可以是直接的三维向量，也可以是ball创建的对象({a, b})
	---@param v number @运动合速度
	---@param a table @运动的角度三维向量
	---@return table @返回直线运动的背景元素对象
	function BG:creatActiveObj(img, x, y, z, rot, v, a, pos, blend, _a)
		blend = blend or ""
		_a = _a or 255
		local a0 --新定义局部变量，注意保护原数据
		if #a == 2 then
			a0 = ballToVect3(a)
		else
			a0 = a
		end
		local tex = BG.getImgTex(self, img)
		local w, h = BG.getImgWH(self, img) --读取对应纹理在背景里的宽高
		local p = Get_Four_Points(x, y, z, w, h, ballToVect3(rot)) --获取点
		local obj = { { tex, blend, _a }, p, { x, y, z }, { rot[1], rot[2] }, { v * a0[1], v * a0[2], v * a0[3] } }
		BG.addToActiveObj(self, obj)
		BG.addToRender(self, obj, pos)
		return obj
	end
	--获取背景元素对象的位置的点集
	---@param obj table @实例化的背景元素的对象
	---@param i number @第i个顶点，限1-4
	---@return table 四个顶点点集
	function BG:getObjPos(obj, i)
		return obj[2][i][1], obj[2][i][2], obj[2][i][3]
	end
	--设置背景元素对象的位置的点集
	---@param obj table @实例化的背景元素的对象
	---@param pos table @四元数类
	---@return table 四个顶点点集
	function BG:setObjPos(obj, i, pos)
		obj[2][i][1], obj[2][i][2], obj[2][i][3] = pos[1], pos[2], pos[3]
	end
	--获取背景元素对象的中心位置
	---@param obj table @实例化的背景元素的对象
	---@return number 中心x, y, z坐标
	function BG:getObjCen(obj)
		return obj[3][1], obj[3][2], obj[3][3]
	end
	--获取背景元素对象的朝向单位向量
	---@param obj table @实例化的背景元素的对象
	---@return table 单位向量
	function BG:getObjRot(obj)
		return obj[4][1], obj[4][2]
	end
	--设置背景元素对象的朝向单位向量(仅修改数值但不改变渲染效果
	---@param obj table @实例化的背景元素的对象
	---@param rot table @三维方向单位向量
	---@return table 单位向量
	function BG:setObjRot(obj, rot)
		obj[4][1], obj[4][2] = rot[1], rot[2]
	end
	--通过改变面的朝向来改变四个顶点的位置(与上面的相比，也会使渲染效果改变
	---@param obj table @本关定义的背景元素
	---@param rot table @渲染面的修改后的朝向向量参数
	---@return table @四个顶点坐标的集合
	function BG:realSetObjRot(obj, rot)
		local x1, y1, z1 = BG.getObjPos(self, obj)
		local x, y, z = BG.getObjCen(self, obj)
		local p = {}
		for i = 1, 4 do
			BG.setObjPos(self, obj, i, Point_by_Quaternion(x, y, z, x1, y1, z1, ballToVect3({ obj[4][1], obj[4][2] }), ballToVect3(rot)))
		end
		BG.setObjRot(self, obj, rot)
	end
	function BG:updateObjRot(obj, da, db)
		obj[4][1], obj[4][2] = obj[4][1] + da, obj[4][2] + db
		local x1, y1, z1
		local x, y, z = BG.getObjCen(self, obj)
		for i = 1, 4 do
			x1, y1, z1 = BG.getObjPos(self, obj, i)
			BG.setObjPos(self, obj, i, Point_by_Quaternion(x, y, z, x1, y1, z1, ballToVect3({ obj[4][1] - da, obj[4][2] - db }), ballToVect3({ obj[4][1], obj[4][2] })))
		end

	end
	--更新对象使之面与视线垂直(opsi = opposite)
	---@param obj table @本关定义的背景元素
	function BG:opsiToEye(obj)
		BG.realSetObjRot(self, obj, Get_Opposite_Vector(self.eye_rot3))
	end
	--更新需要与视线垂直的所有对象（该方法可重载
	function BG:updateAllOpsiToEye()
		for _, obj in pairs(self.objs) do
			BG.opsiToEye(self, obj)
		end
	end
	--获取视野中心
	function BG:getEyeCen()
		return self.eye_pos[1], self.eye_pos[2], self.eye_pos[3]
	end
	--设置视野中心
	function BG:setEyeCen(x, y, z)
		self.eye_pos[1], self.eye_pos[2], self.eye_pos[3] = x, y, z
	end
	--更新视野中心
	function BG:updateEyeCen(dx, dy, dz)
		self.eye_pos[1], self.eye_pos[2], self.eye_pos[3] = self.eye_pos[1] + dx, self.eye_pos[2] + dy, self.eye_pos[3] + dz
		Set3D('eye', self.eye_pos[1], self.eye_pos[2], self.eye_pos[3]) --更新一下视野中心
		BG.updateAt(self) --at也要同时更新
	end
	--更新3维视线方向向量
	function BG:updateEyeRot3()
		self.eye_rot3[1], self.eye_rot3[2], self.eye_rot3[3] = sin(self.eye_rot[1]) * cos(self.eye_rot[2]), cos(self.eye_rot[1]), sin(self.eye_rot[1]) * sin(self.eye_rot[2])
		BG.updateAt(self)
	end
	--设置视线值
	function BG:setEyeRot(a, b)
		self.eye_rot[1], self.eye_rot[2] = a, b
		BG.updateEyeRot3(self) --更新一下
	end
	--获取视线值
	function BG:getEyeRot()
		return self.eye_rot[1], self.eye_rot3[2]
	end
	function BG:getEyeRot3()
		return self.eye_rot3[1], self.eye_rot3[2], self.eye_rot3[3]
	end
	--更新at
	function BG:updateAt()
		local a0, b0, c0 = BG.getEyeCen(self)
		local a1, b1, c1 = BG.getEyeRot3(self)
		self.at = { a0 + a1, b0 + b1, c0 + c1 }
		Set3D('at', self.at[1], self.at[2], self.at[3])
	end
	--更新视线
	function BG:updateEyeRot(da, db)
		self.eye_rot[1], self.eye_rot3[2] = self.eye_rot[1] + da, self.eye_rot3[2] + db
		BG.updateEyeRot3(self)
		BG.updateAllOpsiToEye(self)--更新渲染序列中所有面使之与视线垂直
		--更新一下视角
		BG.updateAt(self)
	end
	--获取背景运动速度和方向法向量
	function BG:getV()
		return self.bg_speed, self.bg_rot3[1], self.bg_rot3[2], self.bg_rot3[3]
	end
	--设置背景运动速度
	---@param v number @速度大小
	---@param a table @球坐标
	function BG:setV(v, a)
		self.bg_rot[1], self.bg_rot[2] = a[1], a[2]
		local a = ballToVect3(a)
		self.bg_speed = v
		self.bg_rot3[1], self.bg_rot3[2], self.bg_rot3[3] = a[1], a[2]. a[3]
	end
	--更新背景运动速度
	function BG:updateV(dv, da, db)
		self.bg_speed = self.bg_speed + dv
		self.bg_rot[1], self.bg_rot[2] = self.bg_rot[1] + da, self.bg_rot[2] + db
		local a = ballToVect3(self.bg_rot)
		self.bg_rot3[1], self.bg_rot3[2], self.bg_rot3[3] = a[1], a[2]. a[3]
	end
	--更新某个obj某个顶点的位置(仅限于中心位置不变时单独调用，不然会错乱!!!!比如旋转）
	---@param obj table @对象
	---@param i number @顶点下标（范围1-4)
	---@param dxdydz number @增量
	function BG:updateObjPoint(obj, i, dx, dy, dz)
		obj[2][i][1] = obj[2][i][1] + dx
		obj[2][i][2] = obj[2][i][2] + dy
		obj[2][i][3] = obj[2][i][3] + dz
	end
	--更新某个obj的位置
	function BG:updateObjPos(obj, dx, dy, dz)
		obj[3][1] = obj[3][1] + dx
		obj[3][2] = obj[3][2] + dy
		obj[3][3] = obj[3][3] + dz
		for i = 1, 4 do
			BG.updateObjPoint(self, obj, i, dx, dy, dz)
		end
	end
	--获取某个obj的透明度
	function BG:getObjAlp(obj)
		return obj[1][3]
	end
	--获取某个obj的透明度
	function BG:setObjAlp(obj, _a)
		obj[1][3] = _a
	end
	--更新某个obj的透明度
	function BG:updateObjAlp(obj, d_a)
		obj[1][3] = obj[1][3] + d_a
	end
	--获取fog的范围
	function BG:getFogRange()
		return self.fog[1], self.fog[2]
	end
	--获取fog的a、r、g、b
	function BG:getFogColor()
		return self.fog[3], self.fog[4], self.fog[5], self.fog[6]
	end
	--设置雾的范围
	function BG:setFogRange(a, b)
		self.fog[1], self.fog[2] = a, b
		Set3D('fog', a, b, Color(self.fog[3], self.fog[4], self.fog[5], self.fog[6]))
	end
	--设置雾的a、r、g、b
	function BG:setFogColor(a, r, g, b)
		self.fog[3], self.fog[4], self.fog[5], self.fog[6] = a, r, g, b
		Set3D('fog', self.fog[1], self.fog[2], Color(a, r, g, b))
	end
	--设置雾
	function BG:setFog(r0, r1, a, r, g, b)
		self.fog[1], self.fog[2] = r0, r1
		self.fog[3], self.fog[4], self.fog[5], self.fog[6] = a, r, g, b
		Set3D('fog', r0, r1, Color(a, r, g, b))
	end
	--更新雾的范围
	function BG:updateFogRange(da, db)
		self.fog[1], self.fog[2] = self.fog[1] + da, self.fog[2] + db
		Set3D('fog', self.fog[1], self.fog[2], Color(self.fog[3], self.fog[4], self.fog[5], self.fog[6]))
	end
	--更新雾的a、r、g、b
	function BG:updateFogColor(da, dr, dg, db)
		self.fog[3], self.fog[4], self.fog[5], self.fog[6] = self.fog[3] + da, self.fog[4] + dr, self.fog[5] + dg, self.fog[6] + db
		Set3D('fog', self.fog[1], self.fog[2], Color(self.fog[3], self.fog[4], self.fog[5], self.fog[6]))
	end
	--获取up(起床（x
	function BG:getUp()
		return self.up[1], self.up[2], self.up[3]
	end
	function BG:getUpRot()
		return self.up_rot[1], self.up_rot[2]
	end
	--设置up
	function BG:setUp(a, b, c)
		self.up[1], self.up[2], self.up[3] = a, b, c
		Set3D('up', a, b, c)
	end
	function BG:setUpRot(a, b)
		self.up_rot[1], self.up_rot[2] = a, b
		local up = ballToVect3(self.up_rot)
		BG.setUp(self, up[1], up[2], up[3])
	end
	--更新up_rot
	function BG:updateUpRot(da, db)
		self.up_rot[1], self.up_rot[2] = self.up_rot[1] + da, self.up_rot[2] + db
		local up = ballToVect3(self.up_rot)
		BG.setUp(self, up[1], up[2], up[3])
	end
	--获取fovy
	function BG:getFovy()
		return self.fovy[1]
	end
	--设置fovy
	function BG:setFovy(a)
		self.fovy[1] = a
		Set3D('fovy', a)
	end
	--更新fovy
	function BG:update(da)
		self.fovy[1] = self.fovy[1] + da
		Set3D('fovy', self.fovy[1])
	end
	--渲染黑色遮障(可供全局调节，降低背景亮度
	function BG:renderBlackBoard()
		local alp = setting.background_mask * 0.01
		if alp < 1 then
			SetImageState("white", "", Color(255 * alp, 0, 0, 0))
			Render4V("white", -192, 224, 0.5,
					192, 224, 0.5,
					192, -224, 0.5,
					-192, -224, 0.5
			)
			SetImageState("white", "", Color(255, 255, 255, 255)) --设回来吧，省得哪里又出了问题
		end

	end
	--渲染灰色纯色背景(在关闭背景时启用
	function BG:renderGrayBoard()
		SetImageState("white", "", Color(255, 117, 138, 150))
		Render4V("white", -192, 224, 0.5,
				192, 224, 0.5,
				192, -224, 0.5,
				-192, -224, 0.5
		)
		SetImageState("white", "", Color(255, 255, 255, 255)) --设回来吧，省得哪里又出了问题
	end
end
--背景类事件
do
	--创建静止的拼接纹理（需要接收
	function BG:creatConSimObj(img, blend, _a, x, y, z, rot, num, a0, dist)
		local a = ballToVect3(a0)  --用局部变量接收，注意保护原数据！
		local tb = {} --创建存储创建对象的表
		local dx, dy, dz = -dist * a[1], -dist * a[2], -dist * a[3]
		for i = 0, num - 1 do
			table.insert(tb, BG.creatSimObj(self, img, x + dx * i, y + dy * i, z + dz * i, rot, blend, _a))
		end
		return tb --返回的是一个存储该方法所创建对象的表
	end
	--使视野中心先匀加速，再匀速，最后匀减速至0运动
	function BG:accDecEyePos(v, rot, t0, t1, t2)
		task.New(self, function()
			local rot = ballToVect3(rot)  --用局部变量接收，注意保护原数据！
			local v, dv = 0, v / t0
			for _ = 1, t0 do
				v = v + dv
				BG.updateEyeCen(self, v * rot[1], v * rot[2], v * rot[3])
				task.Wait(1)
			end
			for _ = 1, t1 do
				BG.updateEyeCen(self, v * rot[1], v * rot[2], v * rot[3])
				task.Wait(1)
			end
			dv = -v / t2
			for _ = 1, t2 do
				v = v + dv
				BG.updateEyeCen(self, v * rot[1], v * rot[2], v * rot[3])
				task.Wait(1)
			end
		end)
	end
	--使obj先匀加速，再匀速，最后匀减速至0运动
	function BG:accDecObjPos(obj, v, rot, t0, t1, t2, wt)
		wt = wt or 0
		task.New(self, function()
			task.Wait(wt)
			local rot = ballToVect3(rot)  --用局部变量接收，注意保护原数据！
			local v, dv = 0, v / t0
			for _ = 1, t0 do
				v = v + dv
				BG.updateObjPos(self, obj, v * rot[1], v * rot[2], v * rot[3])
				task.Wait(1)
			end
			for _ = 1, t1 do
				BG.updateObjPos(self, obj, v * rot[1], v * rot[2], v * rot[3])
				task.Wait(1)
			end
			dv = -v / t2
			for _ = 1, t2 do
				v = v + dv
				BG.updateObjPos(self, obj, v * rot[1], v * rot[2], v * rot[3])
				task.Wait(1)
			end
		end)
	end
	--用于拼接纹理的obj(connect)(要求v为正)
	function BG:accDecConObjPos(obj, v, rot0, t0, t1, t2, dist0, dist)
		local rot
		if rot0 == 2 then
			rot = ballToVect3(rot0)
		else
			rot = rot0
		end
		local value, dvalue1, valuemax
		local i = 1
		for _ = 1, #rot do
			if rot[i] ~= 0 then
				value = abs(dist0 * rot[i])
				valuemax = abs(dist * rot[i])
				dvalue1 = -abs(rot[i])
				break
			end
			i = i + 1
		end
		if i == 4 then
			return 0
		end  --即 0 0 0情况，该函数不执行直接返回0
		task.New(self, function()
			local v, dv = 0, v / t0
			for _ = 1, t0 do
				v = v + dv
				value = value + dvalue1 * v
				BG.updateObjPos(self, obj, v * rot[1], v * rot[2], v * rot[3])
				if value < 0 then
					value = value + valuemax
					BG.updateObjPos(self, obj, -dist * rot[1], -dist * rot[2], -dist * rot[3])
				end
				task.Wait(1)
			end
			for _ = 1, t1 do
				value = value + dvalue1 * v
				BG.updateObjPos(self, obj, v * rot[1], v * rot[2], v * rot[3])
				if value < 0 then
					value = value + valuemax
					BG.updateObjPos(self, obj, -dist * rot[1], -dist * rot[2], -dist * rot[3])
				end
				task.Wait(1)
			end
			dv = -v / t2
			for _ = 1, t2 do
				v = v + dv
				value = value + dvalue1 * v
				BG.updateObjPos(self, obj, v * rot[1], v * rot[2], v * rot[3])
				if value < 0 then
					value = value + valuemax
					BG.updateObjPos(self, obj, -dist * rot[1], -dist * rot[2], -dist * rot[3])
				end
				task.Wait(1)
			end
		end)
	end
	--创建一维运动的拼接纹理
	---@param img string @由addToImg()方法添加的特有img，不是纹理名!!
	---@param blend string @混合模式
	---@param _a number @透明度
	---@param xyz number @创建拼接纹理的起始坐标
	---@param  rot table @拼接面的朝向（可以球坐标系也可以三维方向向量）
	---@param num number @拼接纹理的循环数
	---@param v number @达到匀速时的速度
	---@param a0 number @整个拼接纹理的运动方向
	---@param t0t1t2 number @分别为加速时间，匀速时间，减速时间
	---@param dist number @拼接纹理间的距离
	function BG:creatAccDecConObj(img, blend, _a, x, y, z, rot, num, v, a0, t0, t1, t2, dist)
		local a = ballToVect3(a0)  --用局部变量接收，注意保护原数据！
		local tb = {} --创建存储创建对象的表
		local dx, dy, dz = -dist * a[1], -dist * a[2], -dist * a[3]
		for i = 0, num - 1 do
			table.insert(tb, BG.creatStaticObj(self, img, x + dx * i, y + dy * i, z + dz * i, rot, blend, _a))
			BG.accDecConObjPos(self, tb[i + 1], v, a, t0, t1, t2, dist * (i + 1), dist * num)
		end
		return tb --返回的是一个存储该方法所创建对象的表
	end
	--和以上方法作用完全一样，但是添加渲染顺序是相反的
	function BG:opCreatAccDecConObj(img, blend, _a, x, y, z, rot, num, v, a0, t0, t1, t2, dist)
		local a = ballToVect3(a0)  --用局部变量接收，注意保护原数据！
		local tb = {} --创建存储创建对象的表
		local dx, dy, dz = -dist * a[1], -dist * a[2], -dist * a[3]
		local pos = #self.static + 1
		for i = 0, num - 1 do
			table.insert(tb, BG.creatStaticObj(self, img, x + dx * i, y + dy * i, z + dz * i, rot, blend, _a, pos))
			BG.accDecConObjPos(self, tb[i + 1], v, a, t0, t1, t2, dist * (i + 1), dist * num)
		end
		return tb --返回的是一个存储该方法所创建对象的表
	end
	--均匀变化透明度
	function BG:chObjAlp(obj, d_a, t)
		task.New(self, function()
			d_a = d_a / t
			for _ = 1, t do
				BG.updateObjAlp(self, obj, d_a)
				task.Wait(1)
			end
		end)
	end
	--使某obj透明度在t时间内变为0
	function BG:chObjAlpToZero(obj, t)
		BG.chObjAlp(self, obj, -BG.getObjAlp(self, obj), t)
	end
	--使某obj透明度在t时间内变为_a
	function BG:chObjAlpTo(obj, _a, t)
		BG.chObjAlp(self, obj, _a - BG.getObjAlp(self, obj), t)
	end
	--在t时间内使视野仰角增加至
	function BG:changeEyeRot1To(eyerot2, t)
		task.New(self, function()
			local eyerot1 = eggbg.baseBG.getEyeRot(self)
			local d = (eyerot2 - eyerot1) / t
			for _ = 1, t do
				eggbg.baseBG.updateEyeRot(self, d, 0)
				task.Wait(1)
			end
		end)
	end
	--在t时间使雾的范围变化至
	function BG:changeFogRange0To(fog1, t)
		task.New(self, function()
			local fog0 = eggbg.baseBG.getFogRange(self)
			local d = (fog1 - fog0) / t
			for _ = 1, t do
				eggbg.baseBG.updateFogRange(self, d, 0)
				task.Wait(1)
			end
		end)
	end
	function BG:changeFogRange1To(fog1, t)
		task.New(self, function()
			local _, fog0 = eggbg.baseBG.getFogRange(self)
			local d = (fog1 - fog0) / t
			for _ = 1, t do
				eggbg.baseBG.updateFogRange(self, 0, d)
				task.Wait(1)
			end
		end)
	end
	--在t时间使雾的颜色变化至
	function BG:changeFogARBGTo(a, r, g, b, t)
		task.New(self, function()
			local a0, r0, g0, b0 = eggbg.baseBG.getFogColor(self)
			local da, dr, dg, db = (a - a0) / t, (r - r0) / t, (g - g0) / t, (b - b0) / t
			for _ = 1, t do
				eggbg.baseBG.updateFogColor(self, da, dr, dg, db)
				task.Wait(1)
			end
		end)
	end
end
--背景类帧方法
do
	--按次序渲染
	function BG:renderInOrder()
		SetViewMode '3d'
		local obj, img, p
		for i = 1, #self.static do
			obj = self.static[i]
			img = obj[1][1]
			p = obj[2]
			SetImageState(img, obj[1][2], Color(obj[1][3], 255, 255, 255))
			Render4V(img, p[1][1], p[1][2], p[1][3],
					p[2][1], p[2][2], p[2][3],
					p[3][1], p[3][2], p[3][3],
					p[4][1], p[4][2], p[4][3])
		end
		for i = 1, #self.objs do
			obj = self.objs[i]
			img = obj[1][1]
			p = obj[2]
			SetImageState(img, obj[1][2], Color(obj[1][3], 255, 255, 255))
			Render4V(img, p[1][1], p[1][2], p[1][3],
					p[2][1], p[2][2], p[2][3],
					p[3][1], p[3][2], p[3][3],
					p[4][1], p[4][2], p[4][3])
		end
		SetViewMode 'world'
	end
	function BG:render2dFontInOrder()
		local obj
		for i = 1, #self.static2dfont do
			obj = self.static2dfont[i]
			self.img = obj[1][1]
			SetImgState(self, obj[1][2], obj[1][3], 255, 255, 255)
			Render(self.img, obj[3][1], obj[3][2], obj[4], obj[2][1], obj[2][2])
		end
	end
	function BG:render2dRearInOrder()
		local obj
		for i = 1, #self.static2drear do
			obj = self.static2drear[i]
			self.img = obj[1][1]
			SetImgState(self, obj[1][2], obj[1][3], 255, 255, 255)
			Render(self.img, obj[3][1], obj[3][2], obj[4], obj[2][1], obj[2][2])
		end
	end
	--每帧都要更新所有背景元素
	function BG:updateFrame()
		--全遮障背景不显示
		if setting.background_mask >= 100 then
			self.hide = true
		else
			self.hide = false
		end
		--静止类型的obj不受背景速度影响，故不更新
		local v, vx, vy, vz = BG.getV(self)
		vx, vy, vz = v * vx, v * vy, v * vz
		--普通类型的obj需要根据背景速度更新一次位置
		for _, obj in pairs(self.objs) do
			BG.updateObjPos(self, obj, vx, vy, vz)
		end
		--运动类型的obj需要再以自己的速度更新一次位置
		for _, obj in pairs(self.active) do
			BG.updateObjPos(self, obj, obj[5][1], obj[5][2], obj[5][3])
		end
	end
	--打印相关参数（测试用
	function BG:printParam()
		SetViewMode 'ui'
		local name = { "eye_pos", "eye_rot", "up_rot", "fovy", "z", "fog" }
		local param = { self.eye_pos, self.eye_rot, self.up_rot, self.fovy, self.z, self.fog }
		local x, y = 420, 180
		for i = 1, #param do
			x = 420
			--RenderText("menu", name[i], x, y, 0.5)
			for j = 1, #param[i] do
				x = x + 30
				--RenderText("menu", string.format("%.2f", param[i][j]), x, y, 0.5)
			end
			y = y - 20
		end
		--RenderText("menu", "time = "..self.timer, x - 50, y, 0.5)
		-- "menu"这个字体没了，请用TTF字体"Serif24", "Sans24", "Mono24"等替代
		SetViewMode 'world'
	end
end
--背景类构造
do
	function BG:init()
		BG.setDefault(self)
	end
	function BG:frame()
		BG.updateFrame(self)
	end
	function BG:render()
		BG.render2dFontInOrder(self)
		BG.renderInOrder(self)
		BG.render2dRearInOrder(self)
	end
end
eggbg.baseBG = BG
