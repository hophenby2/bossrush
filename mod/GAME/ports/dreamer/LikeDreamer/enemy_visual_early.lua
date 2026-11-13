-- Original Stage 2-4 enemy assemblies. Atlas entries in these ranges are
-- frequently individual body parts rather than complete enemy sprites.

LikeDreamer = LikeDreamer or {}

local Core = assert(LikeDreamer.Core)
local Common = assert(LikeDreamer.EnemyVisualCommon)
local M = {}
LikeDreamer.EnemyVisualEarly = M

local Renderer = {}
Renderer.__index = Renderer

function Renderer.new(renderers)
	return setmetatable({renderers = renderers}, Renderer)
end

M.Renderer = Renderer

local sin, cos, pi = math.sin, math.cos, math.pi
local floor, ceil = math.floor, math.ceil
local min, max = math.min, math.max
local tau = pi * 2

local function trunc(value)
	return value < 0 and ceil(value) or floor(value)
end

local function drawState(self)
	if self._ldDrawState ~= nil then return self._ldDrawState end
	return self.state or 0
end

local function drawTimer(self)
	if self._ldDrawTimer ~= nil then return max(0, self._ldDrawTimer) end
	return max(0, (self.helperTimer or 0) - 1)
end

local function sourceFrame(self)
	if self._ldSourceFrame ~= nil then return max(0, self._ldSourceFrame) end
	local frame = self.runtime and self.runtime.frame or 0
	return max(0, frame - 1)
end

local function heading(self)
	return self.angle16 or 0x4000
end

local function imageState(family, frame, blend, alpha, red, green, blue)
	local name = Common.name(family, frame)
	if not name or not Common.exists(family, frame) then return nil end
	local setter = rawget(_G, "SetImageState") or
		(rawget(_G, "lstg") and lstg.SetImageState)
	local color = rawget(_G, "Color") or
		(rawget(_G, "lstg") and lstg.Color)
	if setter and color then
		setter(name, blend or "", color(alpha or 255, red or 255,
			green or 255, blue or 255))
		return {setter, color, name}
	end
	return false
end

local function resetImageState(state)
	if type(state) ~= "table" then return end
	state[1](state[3], "", state[2](255, 255, 255, 255))
end

local function drawStyled(self, family, frame, offsetX, offsetY, angle16,
		scaleX, scaleY, reverseX, blend, alpha, red, green, blue)
	local state = imageState(family, frame, blend, alpha, red, green, blue)
	local drew = Common.draw(self, family, frame, offsetX, offsetY, angle16,
		scaleX, scaleY, reverseX)
	resetImageState(state)
	return drew
end

local function drawAtStyled(family, frame, x, y, angle16, scaleX, scaleY,
		reverseX, blend, alpha, red, green, blue)
	local state = imageState(family, frame, blend, alpha, red, green, blue)
	local drew = Common.drawAt(family, frame, x, y, angle16, scaleX, scaleY,
		reverseX)
	resetImageState(state)
	return drew
end

local function renderEntryMarker(self, margin, initialScale, scaleStep, angle16,
		unclampedX)
	local timer = drawTimer(self)
	local scale = max(0, initialScale - timer * scaleStep)
	if scale <= 0 then return end
	local cameraX = self.runtime and self.runtime.cameraX or nil
	local originX = Core.playfieldOriginX(cameraX)
	local markerX = self._ldMarkerX or self.ldX
	local markerY = self._ldMarkerY or self.ldY
	local logicalX = unclampedX and markerX or
		Core.clamp(markerX, originX - margin,
			originX + Core.WIDTH + margin)
	local logicalY = Core.clamp(markerY, -margin, Core.HEIGHT + margin)
	local x, y = Core.toWorld(logicalX, logicalY, cameraX)
	Common.drawAt("effect_m", 4, x, y, angle16 or 0, scale, scale)
end

-- Stage 2 ------------------------------------------------------------------

local function renderType19(self)
	if drawState(self) == 0 then
		renderEntryMarker(self, 20, 2, 0.1)
		return
	end
	local timer = drawTimer(self)
	local sideAngle = trunc(sin(timer * tau / 11) * 6500) - 8000
	local sideX, sideY = Core.polar(sideAngle, 40)
	Common.draw(self, "enemy_s", 16, sideX + 15, sideY - 5,
		sideAngle)
	Common.draw(self, "enemy_s", 16, -sideX - 15, sideY - 5,
		-sideAngle, 1, 1, true)
	local scale = 1 + 0.1 * sin(timer * tau / 51)
	Common.draw(self, "enemy_s", 15, 0, 0, 0, scale, scale)
end

local function renderType1A(self)
	if drawState(self) == 0 then
		renderEntryMarker(self, 20, 2, 0.1)
		return
	end
	local timer = drawTimer(self)
	local scale = 1 + 0.1 * sin(timer * tau / 23)
	Common.draw(self, "enemy_s", 17, 0, 0,
		self.secondaryAngle16 or 0, scale, scale)
	Common.draw(self, "enemy_s", 18, 0, 0, 0)
end

local function renderType1B(self)
	if drawState(self) == 0 then
		renderEntryMarker(self, 50, 3, 0.15)
		return
	end
	local timer = drawTimer(self)
	local flap = trunc(sin(timer * tau / 27) * 3300)
	local flapX, flapY = Core.polar(flap, 20)
	Common.draw(self, "enemy_m", 35, 30 + flapX, 10 + flapY, flap)
	Common.draw(self, "enemy_m", 35, -30 - flapX, 10 + flapY,
		-flap, 1, 1, true)
	Common.draw(self, "enemy_m", 34, 0, 0, 0, 1,
		1 + 0.05 * sin(timer * tau / 72))
end

local function renderType1C(self)
	if drawState(self) == 0 then
		renderEntryMarker(self, 50, 3, 0.15)
		return
	end
	local timer = drawTimer(self)
	Common.draw(self, "enemy_m", 37, 0, 35, 0)
	Common.draw(self, "enemy_m", 36, 0, 0, 0,
		1 - 0.05 * sin(timer * tau / 61), 1)
	local rotorAngle = timer * 0x708
	Common.draw(self, "enemy_m", 38, 0, -50, rotorAngle)
	Common.draw(self, "enemy_m", 38, 0, -50, rotorAngle + 0x5555)
	Common.draw(self, "enemy_m", 38, 0, -50, rotorAngle - 0x5556)
end

local function renderType1D(self)
	local timer = drawTimer(self)
	local scaleX = 1 - 0.05 * sin(timer * tau / 60)
	if timer % 120 < 11 then
		scaleX = 1 + 0.05 * sin(timer * tau / 10)
	end
	drawStyled(self, "enemy_s", 19, 0, 0, 0, scaleX, 1, false,
		"", 64)
	Common.draw(self, "enemy_s", 19, 0, 0, 0, scaleX, 1)
end

local function renderType1E(self)
	local timer = drawTimer(self)
	local scaleX = 1 - 0.05 * sin(timer * tau / 25)
	local frame = 39 + (self.entityId or 0) % 4
	drawStyled(self, "enemy_m", frame, 0, -50, 0, scaleX, 1, false,
		"", 64)
	Common.draw(self, "enemy_m", frame, 0, -50, 0, scaleX, 1)
	Common.draw(self, "enemy_s", 20 + floor(timer / 3) % 3,
		0, -60, 0)
end

local function renderType1F(self)
	local timer, state = drawTimer(self), drawState(self)
	if state == 1 and timer == 0 and not self.targetable and
			(self.age or 0) > 1 then
		timer = self.age - 1
	end
	local scale = state == 2 and
		(1 + 0.15 * sin(timer * tau / 9)) or
		(1 - 0.05 * sin(timer * tau / 50))
	drawStyled(self, "enemy_m", 43, 0, 0, 0, scale, 1, false,
		"", 64)
	Common.draw(self, "enemy_m", 43, 0, 0, 0, scale, 1)
end

local function renderType20(self)
	local timer, state = drawTimer(self), drawState(self)
	if state == 1 and timer == 0 and (self.age or 0) > 1 then
		timer = self.age - 1
	end
	local scale = state == 2 and
		(1 + 0.1 * sin(timer * tau / 19)) or
		(1 - 0.05 * sin(timer * tau / 101))
	local bob = 2 * sin(timer * tau / 72)
	drawStyled(self, "enemy_l", 5, 0, -125, 0, scale, 0.6, false,
		"", 64)
	Common.draw(self, "enemy_l", 5, 0, -120, 0, scale, 1)
	Common.draw(self, "enemy_m", 45, 0, 50 + bob, 0)
end

local function renderType21(self)
	if drawState(self) == 0 then return end
	local timer = drawTimer(self)
	local scale = 1 - 0.05 * sin(timer * tau / 72)
	drawStyled(self, "enemy_m", 44, 0, -60, 0, scale, 1, false,
		"", 64)
	Common.draw(self, "enemy_m", 44, 0, -60, 0, scale, 1)
end

-- Stage 3 ------------------------------------------------------------------

local function renderType25(self)
	if drawState(self) == 0 then
		-- FUN_1400894a0 leaves this marker's wobbling x coordinate unclamped.
		renderEntryMarker(self, 20, 2, 0.1, 0, true)
		return
	end
	local timer = drawTimer(self)
	local orange = timer % 4 >= 2
	drawStyled(self, "effect_s", 0, 12, -32, 0, 0.4, 0.4, false,
		"", 192, 255, orange and 128 or 255, orange and 0 or 255)
	drawStyled(self, "effect_s", 0, -12, -32, 0, 0.4, 0.4, false,
		"", 192, 255, orange and 128 or 255, orange and 0 or 255)
	Common.draw(self, "enemy_s", 24, 0, 0, 0)
end

local function renderType26(self)
	if drawState(self) == 0 then
		renderEntryMarker(self, 50, 3, 0.15)
		return
	end
	local timer = drawTimer(self)
	local orange = timer % 4 >= 2
	drawStyled(self, "effect_s", 0, 50, -55, 0, 0.8, 0.8, false,
		"", 192, 255, orange and 128 or 255, orange and 0 or 255)
	drawStyled(self, "effect_s", 0, -50, -55, 0, 0.8, 0.8, false,
		"", 192, 255, orange and 128 or 255, orange and 0 or 255)
	Common.draw(self, "enemy_m", 50, 50, 10, 0)
	Common.draw(self, "enemy_m", 50, -50, 10, 0, 1, 1, true)
	Common.draw(self, "enemy_m", 49, 0, 0, 0)
end

local function renderType27Or29(self)
	if drawState(self) == 0 then
		renderEntryMarker(self, 50, 3, 0.15)
		return
	end
	local timer = drawTimer(self)
	local type27 = self.spawnType == 0x27
	local bob = 5 * sin(timer * tau / 48)
	if timer % 2 == 0 then
		local sideFrame = type27 and 52 or 54
		local sideY = bob - (type27 and 10 or 0)
		Common.draw(self, "enemy_m", sideFrame, 70, sideY, 0)
		Common.draw(self, "enemy_m", sideFrame, -70, sideY, 0,
			1, 1, true)
	end
	Common.draw(self, "enemy_m", type27 and 51 or 53, 0, 0, 0)
end

local function renderType28(self)
	local timer = drawTimer(self)
	Common.draw(self, "enemy_s", 27, 0, 0, 0, 1,
		1 + sin(timer * pi / 16) * 0.1)
end

local function renderType2A(self)
	Common.draw(self, "enemy_s", 28, 0, 0, drawTimer(self) * 0x14d)
end

local function renderType2B(self)
	if drawState(self) == 0 then
		renderEntryMarker(self, 50, 4, 0.2)
	end
	local timer = drawTimer(self)
	local wave0 = 2 * sin(timer * tau / 38)
	local wave9 = 2 * sin((timer - 9) * tau / 38)
	local wave18 = 2 * sin((timer - 18) * tau / 38)
	local rotA = trunc(sin(timer * tau / 9) * 3800)
	local rotB = trunc(sin((timer - 4) * tau / 9) * 3800)
	Common.draw(self, "enemy_l", 10, 10, -40 + wave9, rotB)
	Common.draw(self, "enemy_l", 10, -10, -40 + wave9, -rotB,
		1, 1, true)
	Common.draw(self, "enemy_l", 9, 10, -45 + wave9, rotA)
	Common.draw(self, "enemy_l", 9, -10, -45 + wave9, -rotA,
		1, 1, true)
	Common.draw(self, "enemy_m", 57, 0, 50 + wave18, 0)
	Common.draw(self, "enemy_m", 56, 0, wave9, 0, 1, 1, true)
	Common.draw(self, "enemy_m", 55, 0, -70 + wave0, 0)
end

local function renderType2C(self)
	if drawState(self) == 0 then return end
	local a = heading(self)
	local dx, dy = Core.polar(a, 35)
	drawStyled(self, "enemy_s", 25, 8, 5, a, 1, 1, false, "", 64)
	Common.draw(self, "enemy_s", 25, 0, 0, a)
	Common.draw(self, "enemy_s", 26, dx, dy, a)
end

local function renderType2D(self)
	if drawState(self) == 0 then return end
	local a = heading(self)
	local dx, dy = Core.polar(a, 100)
	drawStyled(self, "enemy_m", 58, 16, 10, a, 1, 1, false, "", 64)
	Common.draw(self, "enemy_m", 58, 0, 0, a)
	Common.draw(self, "enemy_m", 59, dx, dy, a)
end

local function renderType2E(self)
	local wave = 3 * sin(sourceFrame(self) * tau / 68) - 24
	Common.draw(self, "enemy_l", 12, 180, 80 + wave, 0)
	Common.draw(self, "enemy_l", 12, -180, 80 + wave, 0, 1, 1, true)
	Common.draw(self, "enemy_l", 11, 0, 80, 0)
end

local function renderType2F(self)
	local parent = self.parent
	if parent then
		local offsetX = self.offsetX or 0
		local offsetY = self.offsetY or 0
		local anchorX = (parent.ldX or 0) + offsetX
		local anchorY = (parent.ldY or 0) + offsetY
		local angle = Core.aim16(anchorX, anchorY,
			self.ldX or anchorX, self.ldY or anchorY)
		local cameraX = self.runtime and self.runtime.cameraX or nil
		local wx, wy = Core.toWorld(anchorX, anchorY, cameraX)
		Common.drawAt("enemy_m", 61, wx, wy, angle - 0x4000)
		Common.drawAt("enemy_m", 61, (wx + self.x) * 0.5,
			(wy + self.y) * 0.5, angle - 0x4000)
	end
	Common.draw(self, "enemy_m", 60, 0, 0, 0)
end

-- Stage 4 ------------------------------------------------------------------

local function renderType35(self)
	if drawState(self) == 0 then
		renderEntryMarker(self, 20, 2, 0.1, heading(self))
		return
	end
	local timer = drawTimer(self)
	Common.draw(self, "enemy_s", 32, 0, 0, 0)
	local base = timer * 2000
	Common.draw(self, "enemy_s", 33, 0, -35, base)
	Common.draw(self, "enemy_s", 33, 0, -35, base + 0x5555)
	Common.draw(self, "enemy_s", 33, 0, -35, base - 0x5556)
end

local function renderType36(self)
	if drawState(self) == 0 then
		renderEntryMarker(self, 20, 2, 0.1, heading(self))
		return
	end
	local timer = drawTimer(self)
	local bodyFrame = 34
	if drawState(self) == 1 and timer > 79 then bodyFrame = 37
	elseif drawState(self) == 1 and timer > 69 then
		bodyFrame = 35 + floor((timer - 70) / 5)
	end
	local a = heading(self)
	local radians = Core.angleToRadians(a)
	local bodyPulse = 1 + 0.1 * sin(timer * tau / 47)
	local sideSpin = trunc(6000 * sin(timer * tau / 72))
	local positive = a + 0x4000
	local negative = a - 0x4000
	local positiveX, positiveY = Core.polar(positive, 10)
	local negativeX, negativeY = Core.polar(negative, 10)
	Common.draw(self, "enemy_s", 39, positiveX, positiveY,
		a + sideSpin + 0x4000)
	Common.draw(self, "enemy_s", 39, negativeX, negativeY,
		a - sideSpin + 0x4000, 1, 1, true)
	Common.draw(self, "enemy_s", 38, -cos(radians) * 15,
		-sin(radians) * 15, a, 1, bodyPulse)
	Common.draw(self, "enemy_s", bodyFrame, cos(radians) * 20,
		sin(radians) * 20, a, 1, bodyPulse)
end

local function renderType37(self)
	local timer, state = drawTimer(self), drawState(self)
	local scale = state == 0 and Core.clamp(timer / 120, 0, 1) or 1
	local pulse = sin((timer % 30) * pi / 60)
	local scaleX = scale * (0.9 + pulse * 0.3)
	local scaleY = scale * (1.2 - pulse * 0.3)
	-- The update helper reuses secondaryAngle16 for aiming after queueing this
	-- alternating body angle, so prefer the queue-time snapshot.
	local visualHeading = self._ldVisualAngle16 or
		self.secondaryAngle16 or heading(self)
	local dx, dy = Core.polar(visualHeading, -40 * scale)
	local alpha = state == 0 and Core.clamp(trunc(timer * 2.125), 0, 255) or 255
	drawStyled(self, "enemy_s", 41, dx, dy, visualHeading,
		scaleX, scaleY, false, "", alpha)
	drawStyled(self, "enemy_s", 40, 0, 0, visualHeading,
		scale, scaleY, false, "", alpha)
end

local function renderType38(self)
	if drawState(self) == 0 then
		renderEntryMarker(self, 50, 3, 0.15)
		return
	end
	local timer = drawTimer(self)
	local rearWave = 2 * sin(timer * tau / 63) - 8
	local bodyWave = 2 * sin((timer - 23) * tau / 63)
	local rot65 = trunc(sin(timer * tau / 50) * 1500)
	local rot66 = trunc(sin((timer - 25) * tau / 50) * 1500)
	Common.draw(self, "enemy_m", 66, 30, bodyWave, rot66)
	Common.draw(self, "enemy_m", 66, -30, bodyWave, -rot66,
		1, 1, true)
	Common.draw(self, "enemy_m", 65, 25, bodyWave + 80, rot65)
	Common.draw(self, "enemy_m", 65, -25, bodyWave + 80, -rot65,
		1, 1, true)
	Common.draw(self, "enemy_m", 64, 0, bodyWave, 0)
	Common.draw(self, "enemy_m", 63, 0, rearWave, 0)
end

local function carrierPulse(timer)
	return 1 + sin(timer * 474.8985507246377 * pi / 32768) * 0.1
end

local function renderType39Or3A(self)
	if drawState(self) == 0 then
		renderEntryMarker(self, 50, 3, 0.15, heading(self))
		return
	end
	local timer = drawTimer(self)
	local pulse = carrierPulse(timer)
	local a = heading(self)
	local spin = trunc(sin(timer * 590.4144144144144 * pi / 32768) * 2400)
	local positive = a + spin
	local negative = a - spin
	local px, py = Core.polar(positive, 40)
	local nx, ny = Core.polar(negative, 40)
	Common.draw(self, "enemy_m", 69, px, py, positive + 0x4000,
		1, pulse)
	Common.draw(self, "enemy_m", 69, nx, ny, negative + 0x4000,
		1, pulse, true)
	Common.draw(self, "enemy_m", 68, 0, 0, a, 1, pulse)
end

local function renderType3B(self)
	local timer = drawTimer(self)
	Common.draw(self, "enemy_m", 70, 0, 0, heading(self),
		1, carrierPulse(timer))
end

local function renderType3C(self)
	local timer = drawTimer(self)
	local a = heading(self)
	local dx, dy = Core.polar(a, 45)
	Common.draw(self, "enemy_m", 71, dx, dy, a,
		1, carrierPulse(timer))
end

local function renderType3D(self)
	if drawState(self) == 0 then
		renderEntryMarker(self, 50, 4, 0.2)
		return
	end
	local timer = drawTimer(self)
	local fromLeft = (self.originX or self.ldX or 360) < 360
	local sideX = fromLeft and -205 or 205
	local sideScale = sin(timer * tau / 19)
	Common.draw(self, "enemy_m", 73, sideX, 12, 0xc000,
		sideScale, 1, true)
	Common.draw(self, "enemy_m", 73, sideX, 12, 0xc000,
		-sideScale, 1, true)
	Common.draw(self, "enemy_l", 17, 0, 0, 0, 1, 1, fromLeft)
end

local function renderType3E(self)
	Common.draw(self, "enemy_m", 72, 0, 0, heading(self))
end

local function renderType3F(self)
	local frame = sourceFrame(self)
	local phase = frame * tau / 136
	local chainSin, chainCos = sin(phase), cos(phase)
	local spinUnit = trunc(chainSin * 444)
	for index = 0, 10 do
		local distance = index * 25
		local scale = 1 - index * 0.05
		Common.draw(self, "enemy_s", 42,
			chainCos * distance, -100 + chainSin * distance,
			spinUnit * (index + 1) - 0x4000, scale, scale)
	end
	local pulse = 1 + sin(frame * tau / 120) * 0.05
	local sideAngle = trunc(sin(frame * tau / 66) * 777)
	Common.draw(self, "enemy_m", 74, pulse * 60, 230, sideAngle)
	Common.draw(self, "enemy_m", 74, -pulse * 60, 230,
		-sideAngle, 1, 1, true)
	Common.draw(self, "enemy_l", 18, 0, 70, 0, pulse, pulse)
end

local renderers = {
	[0x19] = renderType19,
	[0x1a] = renderType1A,
	[0x1b] = renderType1B,
	[0x1c] = renderType1C,
	[0x1d] = renderType1D,
	[0x1e] = renderType1E,
	[0x1f] = renderType1F,
	[0x20] = renderType20,
	[0x21] = renderType21,
	[0x25] = renderType25,
	[0x26] = renderType26,
	[0x27] = renderType27Or29,
	[0x28] = renderType28,
	[0x29] = renderType27Or29,
	[0x2a] = renderType2A,
	[0x2b] = renderType2B,
	[0x2c] = renderType2C,
	[0x2d] = renderType2D,
	[0x2e] = renderType2E,
	[0x2f] = renderType2F,
	[0x35] = renderType35,
	[0x36] = renderType36,
	[0x37] = renderType37,
	[0x38] = renderType38,
	[0x39] = renderType39Or3A,
	[0x3a] = renderType39Or3A,
	[0x3b] = renderType3B,
	[0x3c] = renderType3C,
	[0x3d] = renderType3D,
	[0x3e] = renderType3E,
	[0x3f] = renderType3F,
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
