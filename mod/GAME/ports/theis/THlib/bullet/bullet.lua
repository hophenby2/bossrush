---=====================================
---touhou style bullet
---=====================================

local path = "THlib/bullet/"

----------------------------------------
---static color enum

COLOR_DEEP_RED = 1
COLOR_RED = 2
COLOR_DEEP_PURPLE = 3
COLOR_PURPLE = 4
COLOR_DEEP_BLUE = 5
COLOR_BLUE = 6
COLOR_ROYAL_BLUE = 7
COLOR_CYAN = 8
COLOR_DEEP_GREEN = 9
COLOR_GREEN = 10
COLOR_CHARTREUSE = 11
COLOR_YELLOW = 12
COLOR_GOLDEN_YELLOW = 13
COLOR_ORANGE = 14
COLOR_DEEP_GRAY = 15
COLOR_GRAY = 16

----------------------------------------
---基础bullet集合

BULLETSTYLE = {}--30

function BULLETSTYLE:Refresh()
	local BULLETSTYLE_INDEX = {
		"arrow_big", "arrow_mid", "arrow_small",
		"gun_bullet",
		"butterfly",
		"square",
		"ball_small", "ball_mid", "ball_mid_c", "ball_big", "ball_huge", "ball_light",
		"star_small", "star_big",
		"grain_a", "grain_b", "grain_c",
		"kite",
		"knife", "knife_b",
		"water_drop",
		"mildew",
		"ellipse",
		"heart",
		"money",
		"music", "silence",
		"water_drop_dark",
		"ball_huge_dark",
		"ball_light_dark",
	}
	for i, v in ipairs(BULLETSTYLE_INDEX) do
		if _G[v] == nil then
			--强制误差调整大法
			for _, c in ipairs(self) do
				self[i] = c
				break
			end
		elseif self[i] ~= _G[v] then
			self[i] = nil
			self[i] = _G[v]
		end
	end
end

----------------------------------------
---基础bullet类

Include(path .. "bullet_legecy.lua")--老的子弹定义
Include(path .. "bullet_library.lua")--弹型库

---改变弹型
---@param obj object
---@param imgclass lstg.Class
---@param index number @颜色
function ChangeBulletImage(obj, imgclass, index)
	if obj.class == obj.imgclass then
		obj.class = imgclass
		obj.imgclass = imgclass
	else
		obj.imgclass = imgclass
	end
	obj._index = min(max(1, index), 16)
	imgclass.init(obj, obj._index)
end

----------------------------------------
---simple bullet

straight = Class(bullet)

function straight:init(imgclass, index, stay, x, y, v, angle, omiga)
	self.x = x
	self.y = y
	SetV(self, v, angle, true)
	self.omiga = omiga or 0
	bullet.init(self, imgclass, index, stay, true)
end

straight_indes = Class(bullet)

function straight_indes:init(imgclass, index, stay, x, y, v, angle, omiga)
	self.x = x
	self.y = y
	SetV(self, v, angle, true)
	self.omiga = omiga or 0
	bullet.init(self, imgclass, index, stay, false)
	self.group = GROUP_INDES
end

straight_495 = Class(bullet)

function straight_495:init(imgclass, index, stay, x, y, v, angle, omiga)
	self.x = x
	self.y = y
	SetV(self, v, angle, true)
	self.omiga = omiga or 0
	bullet.init(self, imgclass, index, stay, true)
end

function straight_495:frame()
	if not self.reflected then
		local world = lstg.world
		local x, y = self.x, self.y
		if y > world.t then
			self.vy = -self.vy
			self.ay = -self.ay
			self.rot = -self.rot
			self.reflected = true
			return
		end
		if x > world.r then
			self.vx = -self.vx
			self.ay = -self.ay
			self.rot = 180 - self.rot
			self.reflected = true
			return
		end
		if x < world.l then
			self.vx = -self.vx
			self.ax = -self.ax
			self.rot = 180 - self.rot
			self.reflected = true
			return
		end
	end
end

----------------------------------------
---bullet killer

local ObjList = lstg.ObjList
local Dist = lstg.Dist

local function _range_kill_group(u, g, r)
	for _, o in ObjList(g) do
		if Dist(u, o) <= r then
			Kill(o)
		end
	end
end

local function _range_del_group(u, g, r)
	for _, o in ObjList(g) do
		if Dist(u, o) <= r then
			Del(o)
		end
	end
end

bullet_killer = Class(object)

function bullet_killer:init(x, y, kill_indes, del_mode)
	self.x = x
	self.y = y
	self.group = GROUP_GHOST
	self.bound = false
	self.hide = true
	self.kill_indes = kill_indes
	self.del_mode = del_mode
end

function bullet_killer:frame()
	local r = (1 + sin((self.timer / 60) * 90 - 90)) * 1200
	self.a, self.b = r, r
	if not self.del_mode then
		_range_kill_group(self, GROUP_ENEMY_BULLET, r)
		if self.kill_indes then
			_range_kill_group(self, GROUP_INDES, r)
		end
	else
		_range_del_group(self, GROUP_ENEMY_BULLET, r)
		if self.kill_indes then
			_range_del_group(self, GROUP_INDES, r)
		end
	end
	if self.timer == 60 then
		self.status = "del"
	end
end

function bullet_killer:_colli(other)
	if (other.group == GROUP_ENEMY_BULLET) or ((other.group == GROUP_INDES) and self.kill_indes) then
		Kill(other)
	end
end

bullet_deleter = Class(object)

function bullet_deleter:init(x, y, kill_indes)
	self.x = x
	self.y = y
	self.group = GROUP_GHOST
	self.hide = true
	self.kill_indes = kill_indes
end

function bullet_deleter:frame()
	if self.timer == 60 then
		Del(self)
	end
	for i, o in ObjList(GROUP_ENEMY_BULLET) do
		if Dist(self, o) < self.timer * 20 then
			Del(o)
		end
	end
	if self.kill_indes then
		for i, o in ObjList(GROUP_INDES) do
			if Dist(self, o) < self.timer * 20 then
				Del(o)
			end
		end
	end
end

bullet_deleter2 = Class(object)

function bullet_deleter:init(x, y, kill_indes)
	self.player = player
	self.x = self.player.x
	self.y = self.player.y
	self.group = GROUP_GHOST
	self.hide = true
	self.kill_indes = kill_indes
end

function bullet_deleter2:frame()
	self.x = self.player.x
	self.y = self.player.y
	if self.timer == 30 then
		Del(self)
	end
	for i, o in ObjList(GROUP_ENEMY_BULLET) do
		if Dist(self, o) < self.timer * 5 then
			Del(o)
		end
	end
	if self.kill_indes then
		for i, o in ObjList(GROUP_INDES) do
			if Dist(self, o) < self.timer * 5 then
				Del(o)
			end
		end
	end
end

bomb_bullet_killer = Class(object)

function bomb_bullet_killer:init(x, y, a, b, kill_indes)
	self.x = x
	self.y = y
	self.a = a
	self.b = b
	if self.a ~= self.b then
		self.rect = true
	end
	self.group = GROUP_PLAYER
	self.hide = true
	self.kill_indes = kill_indes
end

function bomb_bullet_killer:frame()
	if self.timer == 1 then
		Del(self)
	end
end

function bomb_bullet_killer:colli(other)
	if self.kill_indes then
		if other.group == GROUP_INDES then
			Kill(other)
		end
	end
	if other.group == GROUP_ENEMY_BULLET then
		Kill(other)
	end
end
