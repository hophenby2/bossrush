---=====================================
--- 东方祈华梦游戏系统--游戏道具
--- author: Xiliusha, S7UPID
--- email : Xiliusha@outlook.com
---=====================================

---@type EISlib
local lib = EISlib

---@class EISlib.Item
lib.Item = {}

local sqrt = math.sqrt
local sin, cos = lstg.sin, lstg.cos

local path = EISlib.path .. "item/"

----------------------------------------
--- class declare

item.Blood       = Class(object) -- 血灵碎片
item.PlayerLife  = Class(object)
item.PlayerBomb  = Class(object)
item.Power       = Class(object)
item.Point       = Class(object)
item.PointSmall  = Class(object) -- 消弹点

lstg.DoFile(path .. "itemclass.lua")

----------------------------------------
--- item function

function item.DropItem(x, y, drop)
	local items = {}
	if not NativePlayers.enabled(nil, 41) then return items end
	local n = drop[1] + drop[2]
	if n < 1 then
		return items
	end
	local r = sqrt(n - 1) * 5
	for _ = 1, drop[1] do
		local r2 = sqrt(ran:Float(1, 4)) * r
		local a = ran:Float(0, 360)
		table.insert(items, item.Power.create(x + r2 * cos(a), y + r2 * sin(a), 90, false))
	end
	for _ = 1, drop[2] do
		local r2 = sqrt(ran:Float(1, 4)) * r
		local a = ran:Float(0, 360)
		table.insert(items, item.Point.create(x + r2 * cos(a), y + r2 * sin(a)))
	end
	return items
end

function item.collectByTarget(o, target)
	o.attract = max(o.attract or 0, 20)
	o.target = target
	o.collected = true
end

function item.collectAllItem(rate, isIgnorePointRate)
	rate = rate or 1
	for _, o in ObjList(GROUP_ITEM) do
		if not o.no_collect_by_line then
			if o.rate and o.max_rate then
				o.rate = min(o.max_rate, max(o.rate, rate)) --低倍率不覆盖高倍率
			end
			o.isAttract = true --标记为被吸附，不计算高度倍率
			item.collectByTarget(o, player)
		end
	end
	item.collectAllPowerAndPoint(rate, isIgnorePointRate)
end

function item.collectAllPowerAndPoint(rate, isIgnorePointRate)
	rate = rate or 1
	--对蓝点操作
	for _, o in ipairs(item.Point.forEachUnit()) do
		if not o.islocked then --被锁定了无论怎么样都改不动
			if rate == 2 then
				item.Point.changeToDoubleRate(o)
			else
				o.rate = min(o.max_rate, max(o.rate, rate)) --低倍率不覆盖高倍率
			end
			o.isAttract = true --标记为被吸附，不计算高度倍率
			if o.isIgnorePointRate then
				o.isIgnorePointRate = isIgnorePointRate
			end
		end
		item.collectByTarget(o, player)
	end
	--对p点操作
	for _, o in ipairs(item.Power.forEachUnit()) do
		if not o.islocked then --被锁定了无论怎么样都改不动
			if rate == 2 then
				item.Power.changeToDoubleRate(o)
			else
				o.rate = min(o.max_rate, max(o.rate, rate)) --低倍率不覆盖高倍率
			end
		end
		item.collectByTarget(o, player)
	end
end
