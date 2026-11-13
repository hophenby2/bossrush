-- Shared drawing primitives for the original enemy part assemblies.

LikeDreamer = LikeDreamer or {}

local Core = assert(LikeDreamer.Core)
local M = {}
LikeDreamer.EnemyVisualCommon = M

local prefixes = {
	enemy_s = "ld_enemy_s_",
	enemy_m = "ld_enemy_m_",
	enemy_l = "ld_enemy_l_",
	enemy_xl = "ld_enemy_xl_",
	boss = "ld_boss_",
	player = "ld_player_",
	effect_s = "ld_effect_s_",
	effect_m = "ld_effect_m_",
	effect_l = "ld_effect_l_",
	stageback2 = "ld_stageback2_",
}

local SpriteAtlas = {}
SpriteAtlas.__index = SpriteAtlas

function SpriteAtlas.new(familyPrefixes)
	return setmetatable({prefixes = familyPrefixes}, SpriteAtlas)
end

function SpriteAtlas:name(family, frame)
	local prefix = self.prefixes[family]
	if not prefix or frame == nil or frame < 0 then return nil end
	return prefix .. tostring(frame + 1)
end

function SpriteAtlas:exists(family, frame)
	local name = self:name(family, frame)
	return name and (not lstg.CheckRes or lstg.CheckRes(2, name)) or false
end

function SpriteAtlas:drawAt(family, frame, x, y, angle16,
		scaleX, scaleY, reverseX)
	local name = self:name(family, frame)
	if not name or (lstg.CheckRes and not lstg.CheckRes(2, name)) then return false end
	local sx = scaleX or 1
	local sy = scaleY or sx
	if reverseX then sx = -sx end
	Render(name, x, y, Core.angleToDeg(angle16 or 0), sx, sy)
	return true
end

function SpriteAtlas:draw(entity, family, frame, offsetX, offsetY, angle16,
		scaleX, scaleY, reverseX)
	return self:drawAt(family, frame,
		entity.x + (offsetX or 0) * Core.worldScale(),
		entity.y - (offsetY or 0) * Core.worldScaleY(),
		angle16, scaleX, scaleY, reverseX)
end

function SpriteAtlas:animationFrame(timer, divisor, frames)
	return frames[math.floor(math.max(0, timer or 0) / divisor) % #frames + 1]
end

local atlas = SpriteAtlas.new(prefixes)
M.SpriteAtlas = SpriteAtlas

function M.name(family, frame)
	return atlas:name(family, frame)
end

function M.exists(family, frame)
	return atlas:exists(family, frame)
end

function M.drawAt(family, frame, x, y, angle16, scaleX, scaleY, reverseX)
	return atlas:drawAt(family, frame, x, y, angle16,
		scaleX, scaleY, reverseX)
end

function M.draw(self, family, frame, offsetX, offsetY, angle16,
		scaleX, scaleY, reverseX)
	return atlas:draw(self, family, frame, offsetX, offsetY, angle16,
		scaleX, scaleY, reverseX)
end

function M.animationFrame(timer, divisor, frames)
	return atlas:animationFrame(timer, divisor, frames)
end

return M
