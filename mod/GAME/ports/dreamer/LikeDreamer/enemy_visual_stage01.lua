-- Original Stage 1 enemy assemblies. Enemy_s/Enemy_m atlas entries are
-- individual body parts, not standalone enemy sprites.

LikeDreamer = LikeDreamer or {}

local Core = assert(LikeDreamer.Core)
local Common = assert(LikeDreamer.EnemyVisualCommon)
local M = {}
LikeDreamer.EnemyVisualStage01 = M

local Renderer = {}
Renderer.__index = Renderer

function Renderer.new(renderers)
	return setmetatable({renderers = renderers}, Renderer)
end

M.Renderer = Renderer

local sin, pi = math.sin, math.pi
local floor, ceil = math.floor, math.ceil
local min, max = math.min, math.max
local tau = pi * 2

local function trunc(value)
	return value < 0 and ceil(value) or floor(value)
end

local function timerForDraw(self)
	if self._beDrawTimer ~= nil then
		if self._beDrawState ~= nil and self._beDrawState ~= self.state then
			return 0
		end
		return max(0, self._beDrawTimer)
	end
	return max(0, (self.helperTimer or 0) - 1)
end

local function drawItem(self, offsetX, offsetY, angle16, scale)
	local name = "ld_item_12"
	if lstg.CheckRes and not lstg.CheckRes(2, name) then return end
		Render(name,
		self.x + (offsetX or 0) * Core.worldScale(),
		self.y - (offsetY or 0) * Core.worldScaleY(),
		Core.angleToDeg(angle16 or 0),
		(scale or 1), (scale or 1))
end

local function randomHundredth(seed, minimum, maximum)
	local lo = trunc(minimum * 100)
	local hi = trunc(maximum * 100)
	if lo == hi then return minimum end
	return (lo + Core.frameRand(seed) % (hi - lo + 1)) / 100
end

local function renderEntryMarker(self, margin, initialScale, scaleStep)
	local timer = timerForDraw(self)
	local scale = max(0, initialScale - timer * scaleStep)
	if scale <= 0 then return end
	local cameraX = self.runtime and self.runtime.cameraX or nil
	local originX = Core.playfieldOriginX(cameraX)
	local logicalX = Core.clamp(self.ldX, originX - margin,
		originX + Core.WIDTH + margin)
	local logicalY = Core.clamp(self.ldY, -margin, Core.HEIGHT + margin)
	local x, y = Core.toWorld(logicalX, logicalY, cameraX)
	Common.drawAt("effect_m", 4, x, y, 0, scale, scale)
end

local function renderMarkerRoot(self)
	if self.state == 0 then
		renderEntryMarker(self, 50, 3, 0.15)
		return
	end

	local timer = timerForDraw(self)
	local bodyScale = 1 + 0.1 * sin(timer * tau / 90)
	local baseAngle = timer * 0x6f1
	Common.draw(self, "enemy_m", 10, 0, 80, baseAngle)
	Common.draw(self, "enemy_m", 10, 0, 80, baseAngle + 0x5555)
	Common.draw(self, "enemy_m", 10, 0, 80, baseAngle - 0x5556)
	Common.draw(self, "enemy_m", 9, 0, 0, 0, bodyScale, 1)

	local itemScale = 1
	if timer % 60 < 11 then
		itemScale = itemScale + 0.1 * sin(timer * pi / 10)
	end
	for index = 0, 15 do
		local radialAngle = Core.randomAngle(self.entityId + 0x4d + index, 0)
		local radius = randomHundredth(self.entityId + 0x309 + index,
			15, 32) * bodyScale
		local dx, dy = Core.polar(radialAngle, radius)
		local drawAngle = Core.randomAngle(self.entityId + 0x1e61 + index, 0)
		drawItem(self, dx, -25 + dy, drawAngle, itemScale)
	end
	Common.draw(self, "enemy_m", 8, 0, 0, 0, bodyScale, 1)
end

local function renderMarkerSatellite(self)
	local timer = timerForDraw(self)
	local scale = 1.1 + 0.1 * sin(timer * pi / 32)
	Common.draw(self, "enemy_m", 11, 0, 0, 0, scale, scale)
end

local function renderType0A(self)
	local scale = 1
	if self.state == 0 then
		local timer = min(0x78, timerForDraw(self))
		scale = sin(timer * pi / 240)
	end
	local wingAngle = self.targetAngle16 or 0
	Common.draw(self, "enemy_m", 15, 0, -15, wingAngle,
		scale, scale)
	Common.draw(self, "enemy_m", 15, 0, -15, -wingAngle,
		scale, scale, true)
	Common.draw(self, "enemy_m", self.visualFrame or 12, 0, 0, 0,
		scale, scale)
end

local function renderType0B(self)
	if self.state == 0 then
		renderEntryMarker(self, 20, 2, 0.1)
		return
	end
	local timer = timerForDraw(self)
	local bodyScale = 1 + sin(timer * 0.12319971190548208) * 0.1
	Common.draw(self, "enemy_s", 4, 0, 0, 0, bodyScale, 1)
	local wingAngle = timer * 2000
	Common.draw(self, "enemy_s", 5, 0, -45, wingAngle)
	Common.draw(self, "enemy_s", 5, 0, -45, wingAngle + 0x4000)
	Common.draw(self, "enemy_s", 5, 0, -45, wingAngle - 0x8000)
	Common.draw(self, "enemy_s", 5, 0, -45, wingAngle - 0x4000)
end

local function renderType0C(self)
	if self.state == 0 then
		renderEntryMarker(self, 20, 2, 0.1)
		return
	end
	local timer = timerForDraw(self)
	local yStep = 0.1698158191129618
	local wingOffsetY = sin((timer - 17) * yStep)
	local rearOffsetY = sin(timer * yStep)
	local wingAngle = trunc(sin(timer * 1.2566370614359172) * 2400)
	Common.draw(self, "enemy_s", 8, 0, wingOffsetY, wingAngle)
	Common.draw(self, "enemy_s", 8, 0, wingOffsetY, -wingAngle,
		1, 1, true)
	Common.draw(self, "enemy_s", 7, 0, wingOffsetY - 7, 0)
	Common.draw(self, "enemy_s", 6, 0, rearOffsetY - 14, 0)
end

local function renderType0D(self)
	if self.state == 0 then
		renderEntryMarker(self, 20, 2, 0.1)
		return
	end
	local timer = timerForDraw(self)
	local scale = 1 + sin(timer * 0.19039955476301776) * 0.1
	local localAge = timer % 33
	local flap = trunc(sin(localAge * 0.09519977738150888) * 6666)
	local heading = Core.angle16(self.angle16 or 0x4000)
	local facesRight = heading < 0xc000
	if facesRight then
		Common.draw(self, "enemy_s", 10, 6, -6, 0x4000 - flap,
			scale, scale)
		Common.draw(self, "enemy_s", 10, -6, -12, flap + 0x4bb8,
			scale, scale)
	else
		Common.draw(self, "enemy_s", 10, -6, -6, flap + 0x4000,
			scale, scale)
		Common.draw(self, "enemy_s", 10, 6, -12, 0x3448 - flap,
			scale, scale)
	end
	Common.draw(self, "enemy_s", 9, 0, 0, 0, scale, scale, facesRight)
end

local function renderType0E(self)
	if self.state == 0 then
		renderEntryMarker(self, 50, 3, 0.15)
		return
	end
	local timer = timerForDraw(self)
	local bodyWave = tau / 63
	local mountWave = tau / 36
	local frontY = 2 * sin(timer * bodyWave) - 24
	local middleY = 2 * sin((timer - 23) * bodyWave)
	local rearY = 2 * sin((timer - 46) * bodyWave)
	local bodyAngle = trunc(sin(timer * bodyWave) * 2400)
	local innerAngle = trunc(sin(timer * mountWave) * 2000)
	local outerAngle = trunc(sin((timer - 3) * mountWave) * 2000) + 10000
	local innerX, innerY = Core.polar(innerAngle, 85)
	local outerX, outerY = Core.polar(outerAngle, 70)

	Common.draw(self, "enemy_m", 21, outerX, middleY + outerY,
		outerAngle)
	Common.draw(self, "enemy_m", 21, -outerX, middleY + outerY,
		-outerAngle, 1, 1, true)
	Common.draw(self, "enemy_m", 20, innerX, middleY + innerY,
		innerAngle)
	Common.draw(self, "enemy_m", 20, -innerX, middleY + innerY,
		-innerAngle, 1, 1, true)
	Common.draw(self, "enemy_m", 19, 0, rearY, 0)
	Common.draw(self, "enemy_m", 18, 0, middleY, 0)
	Common.draw(self, "enemy_m", 17, 45, frontY - 60, bodyAngle - 1000)
	Common.draw(self, "enemy_m", 17, -45, frontY - 60, 1000 - bodyAngle,
		1, 1, true)
	Common.draw(self, "enemy_m", 16, 0, frontY, 0)
end

local function renderType0F(self)
	if self.state == 0 then
		renderEntryMarker(self, 50, 3, 0.15)
		return
	end
	local timer = timerForDraw(self)
	local frontY = sin(timer * pi / 36)
	local middleY = sin((timer - 17) * pi / 36)
	local rearY = sin((timer - 34) * pi / 36)
	local mountAngle = trunc(sin(timer * pi / 50) * 2000)
	local mountX, mountY = Core.polar(mountAngle, 95)
	Common.draw(self, "enemy_m", 25, mountX + 10, middleY + mountY - 15,
		mountAngle)
	Common.draw(self, "enemy_m", 25, -mountX - 10, middleY + mountY - 15,
		-mountAngle, 1, 1, true)
	Common.draw(self, "enemy_m", 24, 0, rearY, 0)
	Common.draw(self, "enemy_m", 23, 0, middleY, 0)
	Common.draw(self, "enemy_m", 22, 0, frontY, 0)
end

local function renderType10(self)
	local frame = self.runtime and self.runtime.frame or 0
	local phase = pi / 34
	local wave0 = sin(frame * phase)
	local wave21 = sin((frame - 21) * phase)
	local wave42 = sin((frame - 42) * phase)
	local wave30 = sin((frame - 30) * phase)
	local armWobble = trunc(wave30 * 2400)
	Common.draw(self, "enemy_m", 29, 0, wave42 * 3 + 100, 0)
	Common.draw(self, "enemy_m", 28, 0, wave21 * 3 + 50, 0)
	Common.draw(self, "enemy_m", 27, 40, wave0 * 3 - 124,
		armWobble + 10000)
	Common.draw(self, "enemy_m", 27, -40, wave0 * 3 - 124,
		-10000 - armWobble, 1, 1, true)
	Common.draw(self, "enemy_m", 26, 0, wave0 * 3 - 94, 0)
	Common.draw(self, "enemy_m", 30, -105, wave30 * 4 - 40, 4000)
	Common.draw(self, "enemy_m", 31, 90, wave30 * 4 + 40, 0)
end

local function renderType11(self)
	local timer = timerForDraw(self)
	local heading = self.angle16 or 0x4000
	local opposite = Core.angle16(heading + 0x8000)
	local bodyX, bodyY = Core.polar(opposite, 30)
	local rotorX, rotorY = Core.polar(opposite, 125)
	local rotorAngle = timer * 2000
	Common.draw(self, "enemy_m", 32, bodyX, bodyY, heading)
	Common.draw(self, "enemy_m", 33, rotorX, rotorY, rotorAngle)
	Common.draw(self, "enemy_m", 33, rotorX, rotorY,
		rotorAngle + 0x5555)
	Common.draw(self, "enemy_m", 33, rotorX, rotorY,
		rotorAngle - 0x5556)
end

local renderers = {
	[0x06] = renderMarkerRoot,
	[0x07] = renderMarkerRoot,
	[0x08] = renderMarkerRoot,
	[0x09] = renderMarkerSatellite,
	[0x0a] = renderType0A,
	[0x0b] = renderType0B,
	[0x0c] = renderType0C,
	[0x0d] = renderType0D,
	[0x0e] = renderType0E,
	[0x0f] = renderType0F,
	[0x10] = renderType10,
	[0x11] = renderType11,
}

function Renderer:render(entity)
	local renderer = self.renderers[entity.spawnType]
	if not renderer then return false end
	renderer(entity)
	return true
end

local renderer = Renderer.new(renderers)

function M.render(self)
	return renderer:render(self)
end

return M
