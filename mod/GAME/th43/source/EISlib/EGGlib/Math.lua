local sqrt = math.sqrt
local sin, cos = lstg.sin, lstg.cos

local M = {}
EGGlib.Math = M

--region static variable 一些常用到的静态变量
--从1到360中 整数部分的正弦数值（角度制）
M.SIN = {}
for i = 1, 360 do
	M.SIN[i] = sin(i)
end
--从1到360中 整数部分的余弦数值（角度制）
M.COS = {}
for i = 1, 360 do
	M.COS[i] = cos(i)
end
--endregion

--region function 常用于作数学运算或者转化的方法
--输入一个角度，输出其向下取整后的正弦值
function M.phaseToSin(phase)
	phase = math.floor(phase % 360) --取值0~359
	if phase == 0 then
		return M.SIN[360]
	else
		return M.SIN[phase]
	end
end

--输入一个角度，输出其向下取整后的余弦值
function M.phaseToCos(phase)
	phase = math.floor(phase % 360) --取值0~359
	if phase == 0 then
		return M.COS[360]
	else
		return M.COS[phase]
	end
end


--获取一个点在某条直线方向上与直线的距离 以及 点到直线的距离
--注，可通过返回值正负情况判断点在线中心的上下左右，第一个返回值为正表明在右，否则在左，第二个返回值为正表明在上，否则在下
function M.getLineProjection(point_x, point_y, line_center_x, line_center_y, line_rot)
	local a, d = Angle(line_center_x, line_center_y, point_x, point_y), Dist(point_x, point_y, line_center_x, line_center_y)
	a = a - line_rot
	return d*cos(a), d*sin(a)
end

--伪switch，与c的不同，仅仅是为了自己的需求用的(其实就是讨厌写if elseif ..)
function M.spSwitch(value, cases, start)
	start = start or 0
	for k, v in ipairs(cases) do
		if value == (k-1 + start) then  --从srart的值开始
			return v
		end
	end
end

--从1开始计数的switch，在本作基本是用来适配难度的
function M.spSwitch1(value, cases)
	return M.spSwitch(value, cases, 1)
end

--极常用的一个方法，适配各rank下的默认弹速
function M.defaultSwitchVelocityByRank(rank)
	return M.spSwitch(rank, {
		0.9, 0.95, 1, 1.05, 1.15
	})
end
defaultSwitchVelocityByRank = M.defaultSwitchVelocityByRank

--个人很常用的一个函数（命名完全以习惯来，不要在意）
--作用是传入一个整数，若为奇数则返回1，偶数则返回-1
function M.tranU(i)
	return -1 + 2*(i%2)
end
tranU = M.tranU

--小于0的值返回0，大于等于0的值返回1
function M.tranI(u)
	if u < 0 then
		return 0
	else
		return 1
	end
end
tranI = M.tranI

--把两个表的元素合并在一个表里（注意会修改t1表）
function M.linkTwoTable(t1, t2)
	for _, v in ipairs(t2) do
		table.insert(t1, v)
	end
end

--直角坐标系旋转公式(Transformed Rotational)
---@param x number 原x坐标（或向量）
---@param y number 原y坐标（或向量）
---@param drot number 旋转角数
function M.TranRot(x, y, drot)
	local x1 = x*cos(drot) - y*sin(drot)
	local y1 = x*sin(drot) + y*cos(drot)
	return x1, y1
end

--优化版的高效率低精度直角坐标系旋转公式(Transformed Rotational)
function M.highEfficiencyTranRot(x, y, drot)
	local x1 = x*M.phaseToCos(drot) - y*M.phaseToSin(drot)
	local y1 = x*M.phaseToSin(drot) + y*M.phaseToCos(drot)
	return x1, y1
end

---转化为三维向量
---@class vector3
---@return vector3
function M.Vec3(x, y, z) -- ToVector3
	return { x, y, z }
end

---叉乘
---@param n1 vector3 @三维向量
---@param n2 vector3 @三维向量
---@param ToUnit boolean @是否转为单位向量
---@return vector3 @三维向量
function M.Vec3Cross(n1, n2, ToUnit) -- Multiplication_Cross3
	local x1, y1, z1, x2, y2, z2 = n1[1] or 0, n1[2] or 0, n1[3] or 0, n2[1] or 0, n2[2] or 0, n2[3] or 0
	local a, b, c = y1 * z2 - y2 * z1, x2 * z1 - x1 * z2, x1 * y2 - x2 * y1
	local _n = 1
	if ToUnit then
		_n = sqrt(a * a + b * b + c * c)
	end
	return { a / _n, b / _n, c / _n }
end

---点乘
---@param n1 vector3 @三维向量
---@param n2 vector3 @三维向量
---@param ToCos boolean @是否转为夹角的余弦值
---@return number 点积
function M.Vec3Dot(n1, n2, ToCos) -- Dot_Product3
	local x1, y1, z1, x2, y2, z2 = n1[1] or 0, n1[2] or 0, n1[3] or 0, n2[1] or 0, n2[2] or 0, n2[3] or 0
	local _n = 1
	if ToCos then
		_n = sqrt(x1 * x1 + y1 * y1 + z1 * z1) * sqrt(x2 * x2 + y2 * y2 + z2 * z2)
	end
	return (x1 * x2 + y1 * y2 + z1 * z2) / _n
end

---3维向量作为旋转轴与旋转角度转化为四元数
---@param v vector3 @三维向量
---@param w number @旋转角
---@return table @四元数表
function M.Vec3ToQuat(v, w) -- _3ToQuaternion
	return { v[1], v[2], v[3], w }
end

---判断两个向量是否相同
---@param p1 table @向量
---@param p2 table @向量
---@return boolean
function M.VecEqual(p1, p2) -- Vector_Equal
	local n1, n2 = #p1, #p2
	local flag = 0
	if n1 == n2 then
		for i = 1, n1 do
			if not (p1[i] == p2[i]) then
				flag = 1
				break
			end
		end
	else
		flag = 1
	end
	if flag == 0 then
		return true
	else
		return false
	end
end

---取方向相反的向量(但是不改变原数值)
---@param p table @向量
function M.VecReverse(p) -- Get_Opposite_Vector
	local _p = {}
	for i = 1, #p do
		_p[i] = -p[i]
	end
	return _p
end

---直接创建四元数
---@param x number @三维向量x
---@param y number @三维向量y
---@param z number @三维向量z
---@param w number @旋转角
---@return table @四元数表
function M.Quat(x, y, z, w) -- ToQuaternion
	return { x, y, z, w }
end

---四元数乘法
---@param q table @四元数表
---@param p table @四元数表
---@return table @四元数表
function M.QuatMul(q, p) -- Quaternion_Multiplication
	local x1, y1, z1, w1 = q[1], q[2], q[3], q[4]
	local x2, y2, z2, w2 = p[1], p[2], p[3], p[4]
	return { w1 * x2 + x1 * w2 + y1 * z2 - z1 * y2,
	         w1 * y2 - x1 * z2 + y1 * w2 + z1 * x2,
	         w1 * z2 + x1 * y2 - y1 * x2 + z1 * w2,
	         w1 * w2 - x1 * x2 - y1 * y2 - z1 * z2
	}
end

---四元数求逆
---@param q table @四元数表
---@return table @四元数表
function M.QuatInv(q) --Quaternion_Inversion
	return { -q[1], -q[2], -q[3], q[4] }
end

---利用四元数求面朝向改变后其上一个点向量的坐标
---@param x0 number @顶点所在面的面心坐标(转轴也会过这个点)
---@param y0 number
---@param z0 number
---@param x1 number @顶点的实际坐标
---@param y1 number
---@param z1 number
---@param n1 table @面的原朝向向量参数
---@param n2 table @面的变化朝向向量参数
---@return table @该点旋转后的最终坐标
function M.Vec3RotByQuat(x0, y0, z0, x1, y1, z1, n1, n2) -- Point_by_Quaternion
	local p
	if not (n1[1] == n2[1] and n1[2] == n2[2] and n1[3] == n2[3]) then
		local v = M.Vec3Cross(n1, n2, true) --取n1,n2叉乘的值
		local cosa = M.Vec3Dot(n1, n2, true)
		local s, w = sqrt(0.5 - 0.5 * cosa), sqrt(0.5 + 0.5 * cosa) --这里运用公式，s和c就是sin(a/2)和cos(a/2)
		v = { v[1] * s, v[2] * s, v[3] * s }
		local q = M.Vec3ToQuat(v, w) --现在q就是一个可以表示绕轴旋转w度的四元数了
		
		p = { x1 - x0, y1 - y0, z1 - z0, 0 } --把需要旋转的点转化为四元数形式
		p = M.QuatMul(q, p)
		p = M.QuatMul(p, M.QuatInv(q))
		p = { p[1] + x0, p[2] + y0, p[3] + z0 }
	else
		p = { x1, y1, z1 }
	end
	return p
end

---创建一个球坐标
---@class ball
---@param a number 角度θ，取值0到180  2球坐标系的
---@param b number 角度φ，取值0到360
function M.Ball(a, b) -- createBall
	return { a, b }
end

---球坐标系转三维向量
---@param ball ball 一个由球坐标创建的对象(其实就是{a, b}表)
function M.BallToVec3(ball)
	return M.Vec3(
			sin(ball[1]) * cos(ball[2]),
			-cos(ball[1]), sin(ball[1]) * sin(ball[2]))
end

---获取渲染的四个顶点坐标
---@param x number @面的中心坐标
---@param y number
---@param z number
---@param l number @渲染面范围的宽
---@param h number @渲染面范围的高
---@param rot table @渲染面的原朝向向量参数
---@return table @四个顶点坐标的集合
function M.GetRectFace(x, y, z, l, h, rot) -- Get_Four_Points
	local p = {}
	p[1] = M.Vec3RotByQuat(x, y, z, x - 0.5 * l, y + 0.5 * h, z, { 0, 0, -1 }, rot)
	p[2] = M.Vec3RotByQuat(x, y, z, x + 0.5 * l, y + 0.5 * h, z, { 0, 0, -1 }, rot)
	p[3] = M.Vec3RotByQuat(x, y, z, x + 0.5 * l, y - 0.5 * h, z, { 0, 0, -1 }, rot)
	p[4] = M.Vec3RotByQuat(x, y, z, x - 0.5 * l, y - 0.5 * h, z, { 0, 0, -1 }, rot)
	return p
end

--三维空间某个点以某个向量为轴旋转
function M.getPointByRotateWithVector(x, y, z, da, x0, y0, z0, UnitVector3)
	local n1, n2, n3 = UnitVector3[1], UnitVector3[2], UnitVector3[3]
	local c, s = cos(da), sin(da)
	local K, M = 1 - c, n1*x0 + n2*y0 + n3*z0
	return x*(n1*n1*K + c) + y*(n1*n2*K - n3*s) + z*(n1*n3*K + n2*s) + (x0 - n1*M)*K + (n3*y0 - n2*z0)*s,
	       x*(n1*n2*K + n3*s) + y*(n2*n2*K + c) + z*(n2*n3*K - n1*s) + (y0 - n2*M)*K + (n1*z0 - n3*x0)*s,
	       x*(n1*n3*K - n2*s) + y*(n2*n3*K + n1*s) + z*(n3*n3*K + c) + (z0 - n3*M)*K + (n2*x0 - n1*y0)*s
end

--完全继承某个luastg class
function M.extendClass(Parent_class)
	local class = Class(object)
	for key, func in pairs(Parent_class) do
		class[key] = func
	end
	return class
end
--endregion


return M

