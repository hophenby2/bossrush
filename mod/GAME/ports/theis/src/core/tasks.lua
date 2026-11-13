---=====================================
---luastg tasks
---author:Xiliusha
---author:青山散人
---email:Xiliusha@outlook.com
---=====================================

local abs = math.abs
local int = math.floor
local min, max = math.min, math.max
local unpack = table.unpack or unpack
local yield = coroutine.yield

----------------------------------------
---constant

---@alias task.MoveMode number | "MOVE_NORMAL" | "MOVE_ACCEL" | "MOVE_DECEL" | "MOVE_ACC_DEC"

MOVE_NORMAL = 0
MOVE_ACCEL = 1
MOVE_DECEL = 2
MOVE_ACC_DEC = 3

---@alias task.TraceMode number | "MOVE_TOWARDS_PLAYER" | "MOVE_X_TOWARDS_PLAYER" | "MOVE_Y_TOWARDS_PLAYER" | "MOVE_RANDOM"

MOVE_TOWARDS_PLAYER = 0
MOVE_X_TOWARDS_PLAYER = 1
MOVE_Y_TOWARDS_PLAYER = 2
MOVE_RANDOM = 3

---@alias task.SetMode number | "MODE_SET" | "MODE_ADD" | "MODE_MUL"

MODE_SET = 0
MODE_ADD = 1
MODE_MUL = 2

---@type table<number, fun(t:number):number>
local sample_func = {
	[MOVE_NORMAL] = function(t)
		return t
	end,
	[MOVE_ACCEL] = function(t)
		return t ^ 2
	end,
	[MOVE_DECEL] = function(t)
		return -(t ^ 2) + 2 * t
	end,
	[MOVE_ACC_DEC] = function(t)
		if t < 0.5 then
			return 2 * (t ^ 2)
		else
			return -2 * (t ^ 2) + 4 * t - 1
		end
	end,
}

----------------------------------------
---movement task

---@param x number
---@param y number
---@param t number @integer large than 0
---@param mode task.MoveMode
function task.MoveTo(x, y, t, mode)
	local unit = task.GetSelf()
	t = int(t)
	if t <= 0 then
		unit.x, unit.y = x, y
		return
	end
	local dx = x - unit.x
	local dy = y - unit.y
	local xs = unit.x
	local ys = unit.y
	local kfunc = sample_func[mode]
	local k = 0
	for s = 1 / t, 1 + 0.5 / t, 1 / t do
		k = kfunc(s)
		unit.x = xs + k * dx
		unit.y = ys + k * dy
		yield()
	end
end

---Instead of setting position directly.
---@param x number
---@param y number
---@param t number @integer large than 0
---@param mode task.MoveMode
function task.MoveToEx(x, y, t, mode)
	local unit = task.GetSelf()
	t = int(t)
	if t <= 0 then
		return
	end
	local dx = x
	local dy = y
	local kfunc = sample_func[mode]
	local lastk, k = 0, 0
	for s = 1 / t, 1 + 0.5 / t, 1 / t do
		k = kfunc(s)
		unit.x = unit.x + (k - lastk) * dx
		unit.y = unit.y + (k - lastk) * dy
		lastk = k
		yield()
	end
end

---@param ux number
---@param uy number
---@param l number
---@param r number
---@param b number
---@param t number
---@param dxmin number
---@param dxmax number
---@param dymin number
---@param dymax number
---@param mode task.TraceMode
---@return number, number
local function _cal_move_to_player_position_old(ux, uy, l, r, b, t, dxmin, dxmax, dymin, dymax, mode)
	local dirx, diry = ran:Sign(), ran:Sign()
	local p = player
	if mode < 2 then
		-- x random
		if ux > p.x then
			dirx = -1
		else
			dirx = 1
		end
	end
	if mode == 0 or mode == 2 then
		-- y random
		if uy > p.y then
			diry = -1
		else
			diry = 1
		end
	end
	local dx = ran:Float(dxmin, dxmax)
	local dy = ran:Float(dymin, dymax)
	if ux + dx * dirx < l then
		dirx = 1
	end
	if ux + dx * dirx > r then
		dirx = -1
	end
	if uy + dy * diry < b then
		diry = 1
	end
	if uy + dy * diry > t then
		diry = -1
	end
	return ux + dx * dirx, uy + dy * diry
end

---@param u1 object
---@param u2 object
---@param l number
---@param r number
---@param b number
---@param t number
---@param dxmin number
---@param dxmax number
---@param dymin number
---@param dymax number
---@param mode task.TraceMode
---@return number, number
local function _cal_random_move_toward_unit(u1, u2, l, r, b, t, dxmin, dxmax, dymin, dymax, mode)
	-- 规范输入
	if l > r then
		l, r = r, l
	end
	if b > t then
		b, t = t, b
	end
	dxmin = max(0, dxmin)
	dxmax = max(0, dxmax)
	dymin = max(0, dymin)
	dymax = max(0, dymax)
	if dxmin > dxmax then
		dxmin, dxmax = dxmax, dxmin
	end
	if dymin > dymax then
		dymin, dymax = dymax, dymin
	end
	u1.x = max(l, min(u1.x, r))
	u1.y = max(b, min(u1.y, t))
	-- 生成初始移动方向
	local dirx, diry = ran:Sign(), ran:Sign()
	-- 初始约束移动方向
	if mode < 2 then
		-- x random
		if u1.x > u2.x then
			dirx = -1
		else
			dirx = 1
		end
	end
	if mode == 0 or mode == 2 then
		-- y random
		if u1.y > u2.y then
			diry = -1
		else
			diry = 1
		end
	end
	-- 生成移动距离
	local dx = ran:Float(dxmin, dxmax)
	local dy = ran:Float(dymin, dymax)
	-- 约束移动方向和移动距离
	local x1, x2 = u1.x + dx * (-1), u1.x + dx * (1)
	local y1, y2 = u1.y + dy * (-1), u1.y + dy * (1)
	if x1 < l and x2 < r then
		dirx = 1
	elseif x2 > r and x1 > l then
		dirx = -1
	elseif x1 < l and x2 > r then
		-- 两边都越界，限制移动距离
		if abs(x1 - l) < abs(r - x2) then
			dirx = -1
			dx = abs(u1.x - l)
		else
			dirx = 1
			dx = abs(r - u1.x)
		end
	end
	if y1 < b and y2 < t then
		diry = 1
	elseif y2 > t and y1 > b then
		diry = -1
	elseif y1 < b and y2 > t then
		-- 两边都越界，限制移动距离
		if abs(y1 - b) < abs(t - y2) then
			diry = -1
			dy = abs(u1.y - b)
		else
			diry = 1
			dy = abs(t - u1.y)
		end
	end
	-- 生成坐标
	return u1.x + dx * dirx, u1.y + dy * diry
end

---@param t number @integer large than 0
---@param left number
---@param right number
---@param bottom number
---@param top number
---@param dxmin number
---@param dxmax number
---@param dymin number
---@param dymax number
---@param mmode task.MoveMode
---@param dmode task.TraceMode
function task.MoveToPlayer(t, left, right, bottom, top, dxmin, dxmax, dymin, dymax, mmode, dmode)
	local unit = task.GetSelf()
	local tx, ty = _cal_random_move_toward_unit(unit, player, left, right, bottom, top, dxmin, dxmax, dymin, dymax, dmode)
	task.MoveTo(tx, ty, t, mmode)
end

---Instead of setting position directly.
---@param t number @integer large than 0
---@param left number
---@param right number
---@param bottom number
---@param top number
---@param dxmin number
---@param dxmax number
---@param dymin number
---@param dymax number
---@param mmode task.MoveMode
---@param dmode task.TraceMode
function task.MoveToPlayerEx(t, left, right, bottom, top, dxmin, dxmax, dymin, dymax, mmode, dmode)
	local unit = task.GetSelf()
	local tx, ty = _cal_random_move_toward_unit(unit, player, left, right, bottom, top, dxmin, dxmax, dymin, dymax, dmode)
	task.MoveToEx(tx - unit.x, ty - unit.y, t, mmode)
end

---@param unit object
---@param func fun(t:number):number
---@param t number
---@param mode task.MoveMode
---@vararg number
local function _move_by_positions(unit, func, t, mode, ... )
	-- 输入准备
	t = int(t)
	local args = { ... }
	local argc = int((#args) / 2)
	local x = {unit.x}
	local y = {unit.y}
	for i = 1, argc do
		x[i + 1] = args[i * 2 - 1]
		y[i + 1] = args[i * 2]
	end
	-- 处理瞬时移动
	if t <= 0 then
		unit.x = x[(#x)]
		unit.y = y[(#y)]
		return
	end
	-- 取样阶段
	local xbc, ybc = func(unpack(x)), func(unpack(y))
	local kfunc, k = sample_func[mode], 0
	for s = 1 / t, 1 + 0.5 / t, 1 / t do
		k = kfunc(s)
		unit.x = xbc(k)
		unit.y = ybc(k)
		yield()
	end
	-- 直接设置定点减少末尾误差
	unit.x = x[(#x)]
	unit.y = y[(#y)]
end

---@param unit object
---@param func fun(t:number):number
---@param t number
---@param mode task.MoveMode
---@vararg number
local function _move_by_positions_add(unit, func, t, mode, ... )
	-- 输入准备
	t = int(t)
	local args = { ... }
	local argc = int((#args) / 2)
	local x = {0}
	local y = {0}
	for i = 1, argc do
		x[i + 1] = args[i * 2 - 1]
		y[i + 1] = args[i * 2]
	end
	-- 处理瞬时增量移动
	if t <= 0 then
		unit.x = unit.x + x[(#x)]
		unit.y = unit.y + y[(#y)]
		return
	end
	-- 记录增量
	local tx, ty = 0, 0
	-- 增量取样阶段
	local xbc, ybc = func(unpack(x)), func(unpack(y))
	local nx, ny = 0, 0
	local lastx, lasty, dx, dy = 0, 0, 0, 0
	local kfunc, k = sample_func[mode], 0
	for s = 1 / t, 1 + 0.5 / t, 1 / t do
		k = kfunc(s)
		nx, ny = xbc(k), ybc(k)
		dx = nx - lastx
		dy = ny - lasty
		unit.x = unit.x + dx
		unit.y = unit.y + dy
		tx = tx + dx
		ty = ty + dy
		lastx, lasty = nx, ny
		yield()
	end
	-- 减少末尾误差，使得总的增量尽量接近目标增量
	unit.x = unit.x + (x[(#x)] - tx)
	unit.y = unit.y + (y[(#y)] - ty)
end

--- > Warn : default x1, y1 = unit.x, unit.y
---@param t number @integer large than 0
---@param mode task.MoveMode
---@vararg number @x2, y2, x3, y3, ...
function task.BezierMoveTo(t, mode, ...)
	local unit = task.GetSelf()
	_move_by_positions(unit, math.bezier_curve, t, mode, ... )
end

---Instead of setting position directly.
--- > Warn : default x1, y1 = 0, 0
---@param t number @integer large than 0
---@param mode task.MoveMode
---@vararg number @x2, y2, x3, y3, ...
function task.BezierMoveToEx(t, mode, ...)
	local unit = task.GetSelf()
	_move_by_positions_add(unit, math.bezier_curve, t, mode, ... )
end

--- > Warn : default x1, y1 = unit.x, unit.y
---@param t number @integer large than 0
---@param mode task.MoveMode
---@vararg number @x2, y2, x3, y3, ...
function task.CRMoveTo(t, mode, ...)
	local unit = task.GetSelf()
	_move_by_positions(unit, math.spline_catmullrom, t, mode, ... )
end

---Instead of setting position directly.
--- > Warn : default x1, y1 = 0, 0
---@param t number @integer large than 0
---@param mode task.MoveMode
---@vararg number @x2, y2, x3, y3, ...
function task.CRMoveToEx(t, mode, ...)
	local unit = task.GetSelf()
	_move_by_positions_add(unit, math.spline_catmullrom, t, mode, ... )
end

--- > Warn : default x1, y1 = unit.x, unit.y
---@param t number @integer large than 0
---@param mode task.MoveMode
---@vararg number @x2, y2, x3, y3, ...
function task.Basis2MoveTo(t, mode, ...)
	local unit = task.GetSelf()
	_move_by_positions(unit, math.spline_basis2_auto, t, mode, ... )
end

---Instead of setting position directly.
--- > Warn : default x1, y1 = 0, 0
---@param t number @integer large than 0
---@param mode task.MoveMode
---@vararg number @x2, y2, x3, y3, ...
function task.Basis2MoveToEX(t, mode, ...)
	local unit = task.GetSelf()
	_move_by_positions_add(unit, math.spline_basis2_auto, t, mode, ... )
end

----------------------------------------
---value set task

---task set value
---@param t number @integer large than 0
---@param mode task.MoveMode
---@param vmode task.SetMode
---@param v number @target value(MODE_SET), or add value(MODE_ADD), or factor(MODE_MUL)
---@param getter fun():number @value getter, closure provide by user
---@param setter fun(value:number) @value setter, a closure provide by user
function task.SetValueTo(t, mode, vmode, v, getter, setter)
	-- value
	t = int(t)
	-- cal
	local vs = getter()
	local dv = 0
	if vmode == MODE_SET then
		dv = v - vs
	elseif vmode == MODE_ADD then
		dv = v
	elseif vmode == MODE_MUL then
		dv = v * vs - vs
	end
	if t <= 0 then
		setter(vs + dv)
		return
	end
	-- set
	local kfunc = sample_func[mode]
	for s = 1 / t, 1 + 0.5 / t, 1 / t do
		s = kfunc(s)
		setter(vs + s * dv)
		yield()
	end
	setter(vs + dv)
end

---Instead of setting value directly.
---@param t number @integer large than 0
---@param mode task.MoveMode
---@param vmode task.SetMode
---@param v number @target value(MODE_SET), or add value(MODE_ADD), or factor(MODE_MUL)
---@param getter fun():number @value getter, closure provide by user
---@param setter fun(value:number) @value setter, a closure provide by user
function task.SetValueToEx(t, mode, vmode, v, getter, setter)
	-- value
	t = int(t)
	-- cal
	local vs = getter()
	local dv = 0
	if vmode == MODE_SET then
		dv = v - vs
	elseif vmode == MODE_ADD then
		dv = v
	elseif vmode == MODE_MUL then
		dv = v * vs - vs
	end
	if t <= 0 then
		setter(getter() + dv)
		return
	end
	-- set
	local kfunc = sample_func[mode]
	local lasts = 0
	for s = 1 / t, 1 + 0.5 / t, 1 / t do
		s = kfunc(s)
		setter(getter() + (s - lasts) * dv)
		lasts = s
		yield()
	end
	setter(getter() + (1 - lasts) * dv)
end
