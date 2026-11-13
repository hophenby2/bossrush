---=====================================
---小怪样式
---author:Xiliusha
---email:Xiliusha@outlook.com
---=====================================

---@type EISlib.Enemy
local M = EISlib.Enemy

local RED = 1
local BLUE = 2
local GREEN = 3
local YELLOW = 4

M.RED = RED
M.BLUE = BLUE
M.GREEN = GREEN
M.YELLOW = YELLOW
M.NONE = YELLOW

local inrange = math.inrange

----------------------------------------
--- const

---@class EISlib.Enemy.Style
M.Style = {
	-- 小型妖精
	FAIRY_SMALL_RED = 1,
	FAIRY_SMALL_BLUE = 2,
	FAIRY_SMALL_GREEN = 3,
	FAIRY_SMALL_YELLOW = 4,
	-- 中型妖精
	FAIRY_MIDDLE_RED = 5,
	FAIRY_MIDDLE_BLUE = 6,
	FAIRY_MIDDLE_GREEN = 7,
	FAIRY_MIDDLE_YELLOW = 8,
	-- 大型妖精
	FAIRY_LARGE_RED = 9,
	FAIRY_LARGE_BLUE = 10,
	FAIRY_LARGE_GREEN = 11,
	FAIRY_LARGE_YELLOW = 12,
	-- 毛玉
	BALL_RED = 13,
	BALL_BLUE = 14,
	BALL_GREEN = 15,
	BALL_YELLOW = 16,
	-- 鬼火(带魔法阵)
	MAGIC_FIRE_RED = 17,
	MAGIC_FIRE_BLUE = 18,
	MAGIC_FIRE_GREEN = 19,
	MAGIC_FIRE_YELLOW = 20,
	-- 鬼火
	FIRE_RED = 21,
	FIRE_BLUE = 22,
	FIRE_GREEN = 23,
	FIRE_YELLOW = 24,
	-- 仙境小型妖精
	FAIRY_SMALL_2_RED = 25,
	FAIRY_SMALL_2_BLUE = 26,
	FAIRY_SMALL_2_GREEN = 27,
	FAIRY_SMALL_2_YELLOW = 28,
	-- 仙境中型妖精
	FAIRY_MIDDLE_2_RED = 29,
	FAIRY_MIDDLE_2_BLUE = 30,
	FAIRY_MIDDLE_2_GREEN = 31,
	FAIRY_MIDDLE_2_YELLOW = 32,
	-- 阴阳玉(带魔法阵)
	TAICHI_RED = 33,
	TAICHI_PURPLE = 34,
	TAICHI_BLUE = 35,
	TAICHI_CYAN = 36,
	TAICHI_GREEN = 37,
	TAICHI_YELLOW = 38,
	TAICHI_ORANGE = 39,
	TAICHI_GRAY = 40,
	-- 外界小型妖精
	FAIRY_SMALL_3_RED = 41,
	FAIRY_SMALL_3_BLUE = 42,
	FAIRY_SMALL_3_GREEN = 43,
	FAIRY_SMALL_3_YELLOW = 44,
	-- 外界中型妖精
	FAIRY_MIDDLE_3_RED = 45,
	FAIRY_MIDDLE_3_BLUE = 46,
	FAIRY_MIDDLE_3_GREEN = 47,
	FAIRY_MIDDLE_3_YELLOW = 48,
	-- 小型妖精（带描边特效）
	FAIRY_SMALL_RED_STROKE = 61,
	FAIRY_SMALL_BLUE_STROKE = 62,
	FAIRY_SMALL_GREEN_STROKE = 63,
	FAIRY_SMALL_YELLOW_STROKE = 64,
	-- 中型妖精（带描边特效）
	FAIRY_MIDDLE_RED_STROKE = 65,
	FAIRY_MIDDLE_BLUE_STROKE = 66,
	FAIRY_MIDDLE_GREEN_STROKE = 67,
	FAIRY_MIDDLE_YELLOW_STROKE = 68,
	-- 大型妖精（带描边特效）
	FAIRY_LARGE_RED_STROKE = 69,
	FAIRY_LARGE_BLUE_STROKE = 70,
	FAIRY_LARGE_GREEN_STROKE = 71,
	FAIRY_LARGE_YELLOW_STROKE = 72,
	-- 仙境小型妖精（带描边特效）
	FAIRY_SMALL_2_RED_STROKE = 73,
	FAIRY_SMALL_2_BLUE_STROKE = 74,
	FAIRY_SMALL_2_GREEN_STROKE = 75,
	FAIRY_SMALL_2_YELLOW_STROKE = 76,
	-- 仙境中型妖精（带描边特效）
	FAIRY_MIDDLE_2_RED_STROKE = 77,
	FAIRY_MIDDLE_2_BLUE_STROKE = 78,
	FAIRY_MIDDLE_2_GREEN_STROKE = 79,
	FAIRY_MIDDLE_2_YELLOW_STROKE = 80,
	-- 外界小型妖精（带描边特效）
	FAIRY_SMALL_3_RED_STROKE = 81,
	FAIRY_SMALL_3_BLUE_STROKE = 82,
	FAIRY_SMALL_3_GREEN_STROKE = 83,
	FAIRY_SMALL_3_YELLOW_STROKE = 84,
	-- 外界中型妖精（带描边特效）
	FAIRY_MIDDLE_3_RED_STROKE = 85,
	FAIRY_MIDDLE_3_BLUE_STROKE = 86,
	FAIRY_MIDDLE_3_GREEN_STROKE = 87,
	FAIRY_MIDDLE_3_YELLOW_STROKE = 88,
}

---@class EISlib.Enemy.BaseStyle
M.BaseStyle = {
	---小型妖精
	FAIRY_SMALL = M.Style.FAIRY_SMALL_YELLOW,
	---中型妖精
	FAIRY_MIDDLE = M.Style.FAIRY_MIDDLE_YELLOW,
	---大型妖精
	FAIRY_LARGE = M.Style.FAIRY_LARGE_YELLOW,
	---毛玉
	BALL = M.Style.BALL_YELLOW,
	---鬼火(带魔法阵)
	MAGIC_FIRE = M.Style.MAGIC_FIRE_YELLOW,
	---鬼火
	FIRE = M.Style.FIRE_YELLOW,
	---仙境小型妖精
	FAIRY_SMALL_2 = M.Style.FAIRY_SMALL_2_YELLOW,
	---仙境中型妖精
	FAIRY_MIDDLE_2 = M.Style.FAIRY_MIDDLE_2_YELLOW,
	---阴阳玉(带魔法阵)
	TAICHI = M.Style.TAICHI_GRAY,
	---外界小型妖精
	FAIRY_SMALL_3 = M.Style.FAIRY_SMALL_3_YELLOW,
	---外界中型妖精
	FAIRY_MIDDLE_3 = M.Style.FAIRY_MIDDLE_3_YELLOW,
	---小型妖精（带描边特效）
	FAIRY_SMALL_STROKE = M.Style.FAIRY_SMALL_YELLOW_STROKE,
	---中型妖精（带描边特效）
	FAIRY_MIDDLE_STROKE = M.Style.FAIRY_MIDDLE_YELLOW_STROKE,
	---大型妖精（带描边特效）
	FAIRY_LARGE_STROKE = M.Style.FAIRY_LARGE_YELLOW_STROKE,
	---仙境小型妖精（带描边特效）
	FAIRY_SMALL_2_STROKE = M.Style.FAIRY_SMALL_2_YELLOW_STROKE,
	---仙境中型妖精（带描边特效）
	FAIRY_MIDDLE_2_STROKE = M.Style.FAIRY_MIDDLE_2_YELLOW_STROKE,
	---外界小型妖精（带描边特效）
	FAIRY_SMALL_3_STROKE = M.Style.FAIRY_SMALL_3_YELLOW_STROKE,
	---外界中型妖精（带描边特效）
	FAIRY_MIDDLE_3_STROKE = M.Style.FAIRY_MIDDLE_3_YELLOW_STROKE,
}

---@class EISlib.Enemy.ColorStyle
M.ColorStyle = {
	---小型妖精
	FAIRY_SMALL = {
		[RED] = M.Style.FAIRY_SMALL_RED,
		[BLUE] = M.Style.FAIRY_SMALL_BLUE,
		[GREEN] = M.Style.FAIRY_SMALL_GREEN,
		[YELLOW] = M.Style.FAIRY_SMALL_YELLOW,

		RED = M.Style.FAIRY_SMALL_RED,
		BLUE = M.Style.FAIRY_SMALL_BLUE,
		GREEN = M.Style.FAIRY_SMALL_GREEN,
		YELLOW = M.Style.FAIRY_SMALL_YELLOW,
	},
	---中型妖精
	FAIRY_MIDDLE = {
		[RED] = M.Style.FAIRY_MIDDLE_RED,
		[BLUE] = M.Style.FAIRY_MIDDLE_BLUE,
		[GREEN] = M.Style.FAIRY_MIDDLE_GREEN,
		[YELLOW] = M.Style.FAIRY_MIDDLE_YELLOW,

		RED = M.Style.FAIRY_MIDDLE_RED,
		BLUE = M.Style.FAIRY_MIDDLE_BLUE,
		GREEN = M.Style.FAIRY_MIDDLE_GREEN,
		YELLOW = M.Style.FAIRY_MIDDLE_YELLOW,
	},
	---大型妖精
	FAIRY_LARGE = {
		[RED] = M.Style.FAIRY_LARGE_RED,
		[BLUE] = M.Style.FAIRY_LARGE_BLUE,
		[GREEN] = M.Style.FAIRY_LARGE_GREEN,
		[YELLOW] = M.Style.FAIRY_LARGE_YELLOW,

		RED = M.Style.FAIRY_LARGE_RED,
		BLUE = M.Style.FAIRY_LARGE_BLUE,
		GREEN = M.Style.FAIRY_LARGE_GREEN,
		YELLOW = M.Style.FAIRY_LARGE_YELLOW,
	},
	---毛玉
	BALL = {
		[RED] = M.Style.BALL_RED,
		[BLUE] = M.Style.BALL_BLUE,
		[GREEN] = M.Style.BALL_GREEN,
		[YELLOW] = M.Style.BALL_YELLOW,

		RED = M.Style.BALL_RED,
		BLUE = M.Style.BALL_BLUE,
		GREEN = M.Style.BALL_GREEN,
		YELLOW = M.Style.BALL_YELLOW,
	},
	---鬼火(带魔法阵)
	MAGIC_FIRE = {
		[RED] = M.Style.MAGIC_FIRE_RED,
		[BLUE] = M.Style.MAGIC_FIRE_BLUE,
		[GREEN] = M.Style.MAGIC_FIRE_GREEN,
		[YELLOW] = M.Style.MAGIC_FIRE_YELLOW,

		RED = M.Style.MAGIC_FIRE_RED,
		BLUE = M.Style.MAGIC_FIRE_BLUE,
		GREEN = M.Style.MAGIC_FIRE_GREEN,
		YELLOW = M.Style.MAGIC_FIRE_YELLOW,
	},
	---鬼火
	FIRE = {
		[RED] = M.Style.FIRE_RED,
		[BLUE] = M.Style.FIRE_BLUE,
		[GREEN] = M.Style.FIRE_GREEN,
		[YELLOW] = M.Style.FIRE_YELLOW,

		RED = M.Style.FIRE_RED,
		BLUE = M.Style.FIRE_BLUE,
		GREEN = M.Style.FIRE_GREEN,
		YELLOW = M.Style.FIRE_YELLOW,
	},
	---仙境小型妖精
	FAIRY_SMALL_2 = {
		[RED] = M.Style.FAIRY_SMALL_2_RED,
		[BLUE] = M.Style.FAIRY_SMALL_2_BLUE,
		[GREEN] = M.Style.FAIRY_SMALL_2_GREEN,
		[YELLOW] = M.Style.FAIRY_SMALL_2_YELLOW,

		RED = M.Style.FAIRY_SMALL_2_RED,
		BLUE = M.Style.FAIRY_SMALL_2_BLUE,
		GREEN = M.Style.FAIRY_SMALL_2_GREEN,
		YELLOW = M.Style.FAIRY_SMALL_2_YELLOW,
	},
	---仙境中型妖精
	FAIRY_MIDDLE_2 = {
		[RED] = M.Style.FAIRY_MIDDLE_2_RED,
		[BLUE] = M.Style.FAIRY_MIDDLE_2_BLUE,
		[GREEN] = M.Style.FAIRY_MIDDLE_2_GREEN,
		[YELLOW] = M.Style.FAIRY_MIDDLE_2_YELLOW,

		RED = M.Style.FAIRY_MIDDLE_2_RED,
		BLUE = M.Style.FAIRY_MIDDLE_2_BLUE,
		GREEN = M.Style.FAIRY_MIDDLE_2_GREEN,
		YELLOW = M.Style.FAIRY_MIDDLE_2_YELLOW,
	},
	---阴阳玉(带魔法阵)
	TAICHI = {
		[RED] = M.Style.TAICHI_RED,
		[BLUE] = M.Style.TAICHI_BLUE,
		[GREEN] = M.Style.TAICHI_GREEN,
		[YELLOW] = M.Style.TAICHI_GRAY,

		RED = M.Style.TAICHI_RED,
		BLUE = M.Style.TAICHI_BLUE,
		GREEN = M.Style.TAICHI_GREEN,
		YELLOW = M.Style.TAICHI_GRAY,
	},
	---外界小型妖精
	FAIRY_SMALL_3 = {
		[RED] = M.Style.FAIRY_SMALL_3_RED,
		[BLUE] = M.Style.FAIRY_SMALL_3_BLUE,
		[GREEN] = M.Style.FAIRY_SMALL_3_GREEN,
		[YELLOW] = M.Style.FAIRY_SMALL_3_YELLOW,

		RED = M.Style.FAIRY_SMALL_3_RED,
		BLUE = M.Style.FAIRY_SMALL_3_BLUE,
		GREEN = M.Style.FAIRY_SMALL_3_GREEN,
		YELLOW = M.Style.FAIRY_SMALL_3_YELLOW,
	},
	---外界中型妖精
	FAIRY_MIDDLE_3 = {
		[RED] = M.Style.FAIRY_MIDDLE_3_RED,
		[BLUE] = M.Style.FAIRY_MIDDLE_3_BLUE,
		[GREEN] = M.Style.FAIRY_MIDDLE_3_GREEN,
		[YELLOW] = M.Style.FAIRY_MIDDLE_3_YELLOW,

		RED = M.Style.FAIRY_MIDDLE_3_RED,
		BLUE = M.Style.FAIRY_MIDDLE_3_BLUE,
		GREEN = M.Style.FAIRY_MIDDLE_3_GREEN,
		YELLOW = M.Style.FAIRY_MIDDLE_3_YELLOW,
	},
	---小型妖精（带描边特效）
	FAIRY_SMALL_STROKE = {
		[RED] = M.Style.FAIRY_SMALL_RED_STROKE,
		[BLUE] = M.Style.FAIRY_SMALL_BLUE_STROKE,
		[GREEN] = M.Style.FAIRY_SMALL_GREEN_STROKE,
		[YELLOW] = M.Style.FAIRY_SMALL_YELLOW_STROKE,

		RED = M.Style.FAIRY_SMALL_RED_STROKE,
		BLUE = M.Style.FAIRY_SMALL_BLUE_STROKE,
		GREEN = M.Style.FAIRY_SMALL_GREEN_STROKE,
		YELLOW = M.Style.FAIRY_SMALL_YELLOW_STROKE,
	},
	---中型妖精（带描边特效）
	FAIRY_MIDDLE_STROKE = {
		[RED] = M.Style.FAIRY_MIDDLE_RED_STROKE,
		[BLUE] = M.Style.FAIRY_MIDDLE_BLUE_STROKE,
		[GREEN] = M.Style.FAIRY_MIDDLE_GREEN_STROKE,
		[YELLOW] = M.Style.FAIRY_MIDDLE_YELLOW_STROKE,

		RED = M.Style.FAIRY_MIDDLE_RED_STROKE,
		BLUE = M.Style.FAIRY_MIDDLE_BLUE_STROKE,
		GREEN = M.Style.FAIRY_MIDDLE_GREEN_STROKE,
		YELLOW = M.Style.FAIRY_MIDDLE_YELLOW_STROKE,
	},
	---大型妖精（带描边特效）
	FAIRY_LARGE_STROKE = {
		[RED] = M.Style.FAIRY_LARGE_RED_STROKE,
		[BLUE] = M.Style.FAIRY_LARGE_BLUE_STROKE,
		[GREEN] = M.Style.FAIRY_LARGE_GREEN_STROKE,
		[YELLOW] = M.Style.FAIRY_LARGE_YELLOW_STROKE,

		RED = M.Style.FAIRY_LARGE_RED_STROKE,
		BLUE = M.Style.FAIRY_LARGE_BLUE_STROKE,
		GREEN = M.Style.FAIRY_LARGE_GREEN_STROKE,
		YELLOW = M.Style.FAIRY_LARGE_YELLOW_STROKE,
	},
	---仙境小型妖精（带描边特效）
	FAIRY_SMALL_2_STROKE = {
		[RED] = M.Style.FAIRY_SMALL_2_RED_STROKE,
		[BLUE] = M.Style.FAIRY_SMALL_2_BLUE_STROKE,
		[GREEN] = M.Style.FAIRY_SMALL_2_GREEN_STROKE,
		[YELLOW] = M.Style.FAIRY_SMALL_2_YELLOW_STROKE,

		RED = M.Style.FAIRY_SMALL_2_RED_STROKE,
		BLUE = M.Style.FAIRY_SMALL_2_BLUE_STROKE,
		GREEN = M.Style.FAIRY_SMALL_2_GREEN_STROKE,
		YELLOW = M.Style.FAIRY_SMALL_2_YELLOW_STROKE,
	},
	---仙境中型妖精（带描边特效）
	FAIRY_MIDDLE_2_STROKE = {
		[RED] = M.Style.FAIRY_MIDDLE_2_RED_STROKE,
		[BLUE] = M.Style.FAIRY_MIDDLE_2_BLUE_STROKE,
		[GREEN] = M.Style.FAIRY_MIDDLE_2_GREEN_STROKE,
		[YELLOW] = M.Style.FAIRY_MIDDLE_2_YELLOW_STROKE,

		RED = M.Style.FAIRY_MIDDLE_2_RED_STROKE,
		BLUE = M.Style.FAIRY_MIDDLE_2_BLUE_STROKE,
		GREEN = M.Style.FAIRY_MIDDLE_2_GREEN_STROKE,
		YELLOW = M.Style.FAIRY_MIDDLE_2_YELLOW_STROKE,
	},
	---外界小型妖精（带描边特效）
	FAIRY_SMALL_3_STROKE = {
		[RED] = M.Style.FAIRY_SMALL_3_RED_STROKE,
		[BLUE] = M.Style.FAIRY_SMALL_3_BLUE_STROKE,
		[GREEN] = M.Style.FAIRY_SMALL_3_GREEN_STROKE,
		[YELLOW] = M.Style.FAIRY_SMALL_3_YELLOW_STROKE,

		RED = M.Style.FAIRY_SMALL_3_RED_STROKE,
		BLUE = M.Style.FAIRY_SMALL_3_BLUE_STROKE,
		GREEN = M.Style.FAIRY_SMALL_3_GREEN_STROKE,
		YELLOW = M.Style.FAIRY_SMALL_3_YELLOW_STROKE,
	},
	---外界中型妖精（带描边特效）
	FAIRY_MIDDLE_3_STROKE = {
		[RED] = M.Style.FAIRY_MIDDLE_3_RED_STROKE,
		[BLUE] = M.Style.FAIRY_MIDDLE_3_BLUE_STROKE,
		[GREEN] = M.Style.FAIRY_MIDDLE_3_GREEN_STROKE,
		[YELLOW] = M.Style.FAIRY_MIDDLE_3_YELLOW_STROKE,

		RED = M.Style.FAIRY_MIDDLE_3_RED_STROKE,
		BLUE = M.Style.FAIRY_MIDDLE_3_BLUE_STROKE,
		GREEN = M.Style.FAIRY_MIDDLE_3_GREEN_STROKE,
		YELLOW = M.Style.FAIRY_MIDDLE_3_YELLOW_STROKE,
	},
}

----------------------------------------
--- 样式转换

---@param style number
---@param syscolor number
---@return number @real style index
---@overload fun(style:number):number
local function formatStyle(style, syscolor)
	syscolor = syscolor or YELLOW
	local index = M.ColorStyle.FAIRY_SMALL
	if inrange(style, 1, 4) then
		index = M.ColorStyle.FAIRY_SMALL
	elseif inrange(style, 5, 8) then
		index = M.ColorStyle.FAIRY_MIDDLE
	elseif inrange(style, 9, 12) then
		index = M.ColorStyle.FAIRY_LARGE
	elseif inrange(style, 13, 16) then
		index = M.ColorStyle.BALL
	elseif inrange(style, 17, 20) then
		index = M.ColorStyle.MAGIC_FIRE
	elseif inrange(style, 21, 24) then
		index = M.ColorStyle.FIRE
	elseif inrange(style, 25, 28) then
		index = M.ColorStyle.FAIRY_SMALL_2
	elseif inrange(style, 29, 32) then
		index = M.ColorStyle.FAIRY_MIDDLE_2
	elseif inrange(style, 33, 40) then
		index = M.ColorStyle.TAICHI
	elseif inrange(style, 41, 44) then
		index = M.ColorStyle.FAIRY_SMALL_3
	elseif inrange(style, 45, 48) then
		index = M.ColorStyle.FAIRY_MIDDLE_3
	elseif inrange(style, 61, 64) then
		index = M.ColorStyle.FAIRY_SMALL_STROKE
	elseif inrange(style, 65, 68) then
		index = M.ColorStyle.FAIRY_MIDDLE_STROKE
	elseif inrange(style, 69, 72) then
		index = M.ColorStyle.FAIRY_LARGE_STROKE
	elseif inrange(style, 73, 76) then
		index = M.ColorStyle.FAIRY_SMALL_2_STROKE
	elseif inrange(style, 77, 80) then
		index = M.ColorStyle.FAIRY_MIDDLE_2_STROKE
	elseif inrange(style, 81, 84) then
		index = M.ColorStyle.FAIRY_SMALL_3_STROKE
	elseif inrange(style, 85, 88) then
		index = M.ColorStyle.FAIRY_MIDDLE_3_STROKE
	end
	return index[syscolor] or style
end

local _styleIndex = {}
local _colorIndex = {}

for _, v in pairs(M.Style) do
	_styleIndex[v] = {}
	_styleIndex[v][RED] = formatStyle(v, RED)
	_styleIndex[v][BLUE] = formatStyle(v, BLUE)
	_styleIndex[v][GREEN] = formatStyle(v, GREEN)
	_styleIndex[v][YELLOW] = formatStyle(v, YELLOW)
	local c = 1
	for _, s in pairs(M.ColorStyle) do
		for i, t in ipairs(s) do
			if t == v then
				c = i
				break
			end
		end
	end
	_colorIndex[v] = c
end

---根据已知小怪类型切换到同外观另一个颜色的小怪类型，不存在默认返回输入参数style
---@param style number
---@param syscolor number @1红色，2蓝色，3绿色，4黄（无）色
---@return number @real style index
function M.ChangeStyleColor(style, syscolor)
	local ret = _styleIndex[style][syscolor]
	return ret or style
end

---获取指定小怪类型对应的颜色，不存在默认返回4黄（无）色
---@param style number
---@return number @1红色，2蓝色，3绿色，4黄（无）色
function M.GetStyleColor(style)
	local ret = _colorIndex[style]
	return ret or YELLOW
end
