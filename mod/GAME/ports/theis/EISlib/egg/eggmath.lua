local sqrt = math.sqrt
local sin, cos = lstg.sin, lstg.cos

---@class eggmath
local M = {}

---转化为三维向量
function M.Vec3(x, y, z)
	-- ToVector3
	return { x, y, z }
end

---叉乘
---@param n1 table @三维向量
---@param n2 table @三维向量
---@param ToUnit boolean @是否转为单位向量
---@return table @三维向量
function M.Vec3Cross(n1, n2, ToUnit)
	-- Multiplication_Cross3
	local x1, y1, z1, x2, y2, z2 = n1[1] or 0, n1[2] or 0, n1[3] or 0, n2[1] or 0, n2[2] or 0, n2[3] or 0
	local a, b, c = y1 * z2 - y2 * z1, x2 * z1 - x1 * z2, x1 * y2 - x2 * y1
	local _n = 1
	if ToUnit then
		_n = sqrt(a * a + b * b + c * c)
	end
	return { a / _n, b / _n, c / _n }
end

---点乘
---@param n1 table @三维向量
---@param n2 table @三维向量
---@param ToCos boolean @是否转为夹角的余弦值
---@return number 点积
function M.Vec3Dot(n1, n2, ToCos)
	-- Dot_Product3
	local x1, y1, z1, x2, y2, z2 = n1[1] or 0, n1[2] or 0, n1[3] or 0, n2[1] or 0, n2[2] or 0, n2[3] or 0
	local _n = 1
	if ToCos then
		_n = sqrt(x1 * x1 + y1 * y1 + z1 * z1) * sqrt(x2 * x2 + y2 * y2 + z2 * z2)
	end
	return (x1 * x2 + y1 * y2 + z1 * z2) / _n
end

---3维向量作为旋转轴与旋转角度转化为四元数
---@param v table @三维向量
---@param w number @旋转角
---@return table @四元数表
function M.Vec3ToQuat(v, w)
	-- _3ToQuaternion
	return { v[1], v[2], v[3], w }
end

---判断两个向量是否相同
---@param p1 table @向量
---@param p2 table @向量
---@return boolean
function M.VecEqual(p1, p2)
	-- Vector_Equal
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
function M.VecReverse(p)
	-- Get_Opposite_Vector
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
function M.Quat(x, y, z, w)
	-- ToQuaternion
	return { x, y, z, w }
end

---四元数乘法
---@param q table @四元数表
---@param p table @四元数表
---@return table @四元数表
function M.QuatMul(q, p)
	-- Quaternion_Multiplication
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
function M.QuatInv(q)
	--Quaternion_Inversion
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
function M.Vec3RotByQuat(x0, y0, z0, x1, y1, z1, n1, n2)
	-- Point_by_Quaternion
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
---@param a number 角度θ，取值0到180  2球坐标系的
---@param b number 角度φ，取值0到360
function M.Ball(a, b)
	-- createBall
	return { a, b }
end

---球坐标系转三维向量
---@param ball table 一个由球坐标创建的对象(其实就是{a, b}表)
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
function M.GetRectFace(x, y, z, l, h, rot)
	-- Get_Four_Points
	local p = {}
	p[1] = M.Vec3RotByQuat(x, y, z, x - 0.5 * l, y + 0.5 * h, z, { 0, 0, -1 }, rot)
	p[2] = M.Vec3RotByQuat(x, y, z, x + 0.5 * l, y + 0.5 * h, z, { 0, 0, -1 }, rot)
	p[3] = M.Vec3RotByQuat(x, y, z, x + 0.5 * l, y - 0.5 * h, z, { 0, 0, -1 }, rot)
	p[4] = M.Vec3RotByQuat(x, y, z, x - 0.5 * l, y - 0.5 * h, z, { 0, 0, -1 }, rot)
	return p
end

return M

--[[
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
--]]
