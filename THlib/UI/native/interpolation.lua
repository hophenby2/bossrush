---=====================================
--- 数学插值库
--- author:Xiliusha
--- email :Xiliusha@outlook.com
---=====================================

---@class interpolation
local M = {}

local sort = table.sort
local unpack = unpack
local sin = math.sin
local pi = math.pi

----------------------------------------
--- 辅助函数

---@param v1 number
---@param v2 number
---@return number
function M.min(v1, v2)
	if v1 < v2 then
		return v1
	else
		return v2
	end
end
local min = M.min

---@param v1 number
---@param v2 number
---@return number
function M.max(v1, v2)
	if v1 > v2 then
		return v1
	else
		return v2
	end
end
local max = M.max

--- 限制值范围
---@param v number
---@param v1 number
---@param v2 number
---@return number
function M.clamp(v, v1, v2)
	if v < min(v1, v2) then
		v = v1
	elseif v > max(v1, v2) then
		v = v2
	end
	return v
end
local clamp = M.clamp

--- 归一化一个值
---@param v number
---@param v1 number
---@param v2 number
---@return number
function M.normalize(v, v1, v2)
	v1, v2 = min(v1, v2), max(v1, v2)
	if v1 == v2 then
		return v
	end
	return (v - v1) / (v2 - v1)
end

----------------------------------------
--- 线性

--- 线性插值
---@param v1 number
---@param v2 number
---@param k number
---@return number
function M.linear(v1, v2, k)
	return v1 * (1.0 - k) + v2 * (k)
end

----------------------------------------
--- 二次函数

--- 二次函数插值，x^2凸插值
---@param v1 number
---@param v2 number
---@param k number
---@return number
function M.square_convex(v1, v2, k)
	return M.linear(v1, v2, k * (2.0 - k))
end

--- 二次函数插值，x^2凹插值
---@param v1 number
---@param v2 number
---@param k number
---@return number
function M.square_concave(v1, v2, k)
	return M.linear(v1, v2, k * k)
end

--- 二次函数插值，x^2平滑插值
---@param v1 number
---@param v2 number
---@param k number
---@return number
function M.square_smooth(v1, v2, k)
	if k < 0.5 then
		return M.linear(v1, v2, 2.0 * k * k)
	else
		return M.linear(v1, v2, 2.0 * k * (2 - k) - 1)
	end
end

--- 二次函数插值，x^2跳跃插值
---@param v1 number
---@param v2 number
---@param k number
---@return number
function M.square_leap(v1, v2, k)
	if k < 0.5 then
		return M.linear(v1, v2, 2.0 * k * (1 - k))
	else
		return M.linear(v1, v2, 2.0 * k * (k - 1) + 1)
	end
end

----------------------------------------
--- 三角函数

--- 三角函数插值，sin凸插值
---@param v1 number
---@param v2 number
---@param k number
---@return number
function M.sin_convex(v1, v2, k)
	return M.linear(v1, v2, sin(k * 0.5 * pi))
end

--- 三角函数插值，sin凹插值
---@param v1 number
---@param v2 number
---@param k number
---@return number
function M.sin_concave(v1, v2, k)
	return M.linear(v1, v2, 1 + sin((k - 1) * 0.5 * pi))
end

--- 三角函数插值，sin平滑插值
---@param v1 number
---@param v2 number
---@param k number
---@return number
function M.sin_smooth(v1, v2, k)
	return M.linear(v1, v2, 0.5 * (1 + sin((k - 0.5) * pi)))
end

--- 三角函数插值，sin跳跃插值
---@param v1 number
---@param v2 number
---@param k number
---@return number
function M.sin_leap(v1, v2, k)
	if k < 0.5 then
		return 0.5 * M.sin_convex(v1, v2, k * 2.0)
	else
		return 0.5 + 0.5 * M.sin_concave(v1, v2, k * 2.0 - 1.0)
	end
end

----------------------------------------
--- 其他插值

--- 局部线性插值
---@param v number
---@param v1 number
---@param v2 number
---@return number
function M.partial(v, v1, v2)
	if v2 < v1 then
		v1, v2 = v2, v1
	end
	v = clamp(v, v1, v2)
	return (v - v1) / (v2 - v1)
end

--- 局部梯形插值
---@param v number
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
---@return number
function M.trapezium(v, v1, v2, v3, v4)
	local t = { v1, v2, v3, v4 }
	sort(t)
	v1, v2, v3, v4 = unpack(t, 1, 4)
	if v > v2 and v < v3 then
		return 1
	elseif v < v1 or v > v4 then
		return 0
	elseif v >= v1 and v <= v2 then
		if v1 ~= v2 then
			return (v - v1) / (v2 - v1)
		else
			return 0
		end
	elseif v >= v3 and v <= v4 then
		if v3 ~= v4 then
			return 1 - ((v - v3) / (v4 - v3))
		else
			return 0
		end
	end
end

----------------------------------------
--- 迭代插值

--- 迭代逼近，线性跟随
---@param v1 number
---@param v2 number
---@param dv number
---@return number
function M.follow(v1, v2, dv)
	if v1 > v2 then
		if (v1 - v2) < dv then
			return v2
		end
		return v1 - dv
	else
		if (v2 - v1) < dv then
			return v2
		end
		return v1 + dv
	end
end

--- 迭代逼近，k越小逼近速度越快
---@param v1 number
---@param v2 number
---@param k number
---@return number
function M.pow(v1, v2, k)
	return v2 + (v1 - v2) * k
end

--- 迭代变化
---@param v number
---@param v1 number
---@param v2 number
---@param k number
---@param b boolean
---@return number
function M.balance(v, v1, v2, k, b)
	if b then
		return math.clamp(v + k, v1, v2)
	else
		return math.clamp(v - k, v1, v2)
	end
end

----------------------------------------
--- 特殊方法

--- 若一个整数超出某个范围，则进行类似取余的操作
---@param v number
---@param v1 number
---@param v2 number
---@return number
function M.integer_loop(v, v1, v2)
	if v2 <= v1 then
		return v1
	end
	return (v - v1) % (v2 - v1 + 1) + v1
end

return M
