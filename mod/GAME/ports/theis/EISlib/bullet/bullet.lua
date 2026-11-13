---=====================================
---东方祈华梦弹型库
---author:Xiliusha
---email:Xiliusha@outlook.com
---=====================================

---@type EISlib
local lib = EISlib

---@class EISlib.Bullet
local M = {}

---@type EISlib.Bullet
lib.Bullet = M

M.path = lib.path .. "bullet/"

local path = M.path

----------------------------------------
---默认消弹效果

BulletBreak = Class(object)

local BulletBreak_Image = {}
for i = 1, 16 do
	BulletBreak_Image[i] = "etbreak" .. i
end

function BulletBreak:init(x, y, index, size)
	size = size or 1.0
	self.x = x
	self.y = y
	self.group = GROUP_GHOST
	self.layer = LAYER_ENEMY_BULLET - 50
	self.img = BulletBreak_Image[index]
	local s = size * ran:Float(0.9, 1.1)
	self.hscale = s
	self.vscale = s
	self.rot = ran:Float(0, 360)
end

function BulletBreak:frame()
	if self.timer >= 23 then
		self.status = "del"
	end
end

----------------------------------------
---res unload and load

lstg.DoFile(path .. "bullet_define_normal.lua")
lstg.DoFile(path .. "laser.lua")
lstg.DoFile(path .. "bullet2.lua")
