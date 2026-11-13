-- Original Stage 8-10 ordinary-enemy part assemblies.

LikeDreamer = LikeDreamer or {}

local Core = assert(LikeDreamer.Core)
local Common = assert(LikeDreamer.EnemyVisualCommon)
local M = {}
LikeDreamer.EnemyVisualLate = M

local Renderer = {}
Renderer.__index = Renderer

function Renderer.new(renderers, markerRoots)
	return setmetatable({
		renderers = renderers,
		markerRoots = markerRoots,
	}, Renderer)
end

M.Renderer = Renderer

local sin, cos, pi = math.sin, math.cos, math.pi
local floor, max = math.floor, math.max
local tau = pi * 2

local function drawTimer(self)
	return max(0, self._ldDrawTimer or ((self.helperTimer or 1) - 1))
end

local function sourceFrame(self)
	return self._ldSourceFrame or (self.runtime and self.runtime.frame) or 0
end

local function sourceAngle(self)
	return self.angle16 or self.sourceAngle16 or 0
end

local function setState(family, frame, blend, alpha, red, green, blue)
	local name = Common.name(family, frame)
	if not name then return nil end
	SetImageState(name, blend or "",
		Color(alpha or 255, red or 255, green or 255, blue or 255))
	return name
end

local function resetState(name)
	if name then SetImageState(name, "", Color(255, 255, 255, 255)) end
end

local function drawAdditive(self, family, frame, offsetX, offsetY, angle,
		scaleX, scaleY, alpha)
	local name = setState(family, frame, "mul+add", alpha or 64)
	Common.draw(self, family, frame, offsetX, offsetY, angle, scaleX, scaleY)
	resetState(name)
end

local function renderMarker(self, initialScale, decay)
	local timer = drawTimer(self)
	local scale = max(0, initialScale - timer * decay)
	if scale <= 0 then return end
	local cameraX = self.runtime and self.runtime.cameraX or nil
	local left = Core.playfieldOriginX(cameraX)
	local markerX, markerY = self.ldX, self.ldY
	if self.spawnType == 0xfe or self.spawnType == 0x100 then
		markerX = self._ldDestinationX or self.originX or markerX
		markerY = self._ldDestinationY or self.originY or markerY
	end
	local x = Core.clamp(markerX, left - 50, left + Core.WIDTH + 50)
	local y = Core.clamp(markerY, -50, Core.HEIGHT + 50)
	local worldX, worldY = Core.toWorld(x, y, cameraX)
	Common.drawAt("effect_m", 4, worldX, worldY, 0, scale, scale)
end

local function render95(self)
	local timer = drawTimer(self)
	local top = 5 - sin(timer * tau / 60) * 10
	local mirroredTop = 5 - sin((timer - 30) * tau / 60) * 10
	local center = 5 - sin(timer * tau / 30) * 2
	local lower = -12 - sin((timer - 12) * tau / 30) * 2
	local rear = -7 - sin((timer - 6) * tau / 30) * 2
	Common.draw(self, "enemy_s", 122, 0, lower)
	Common.draw(self, "enemy_s", 119, 0, top)
	Common.draw(self, "enemy_s", 119, 0, mirroredTop, 0, 1, 1, true)
	Common.draw(self, "enemy_s", 120, 0, center)
	Common.draw(self, "enemy_s", 121, 0, lower)
	Common.draw(self, "enemy_s", 123, 0, rear)
	drawAdditive(self, "enemy_s", 124, 0, 5, 0, 1, 1, 64)
end

local function render96(self)
	local timer = drawTimer(self)
	local first = -sin(timer * tau / 80)
	local second = -sin((timer - 9) * tau / 80)
	local phase = (self._ldDrawState or self.state or 0) == 0 and
		sin(math.min(timer, 20) * pi / 40) or 0
	local scaleX, scaleY = 1 + phase, 1 - phase
	Common.draw(self, "enemy_s", 127, 0, 0, 0, scaleX, scaleY)
	Common.draw(self, "enemy_s", 126, 0, first, 0, scaleX, scaleY)
	Common.draw(self, "enemy_s", 125, 0, second, 0, scaleX, scaleY)
	local shadow = setState("enemy_s", 128, "", 64, 0, 0, 0)
	Common.draw(self, "enemy_s", 128, 0, 5)
	resetState(shadow)
end

local function renderStage8Turret(self)
	if (self._ldDrawState or self.state or 0) == 0 then
		renderMarker(self, 2, 0.1)
		return
	end
	local angle = self.secondaryAngle16 or 0
	local mountX, mountY = Core.polar(angle, 30)
	Common.draw(self, "enemy_s", 130, mountX, mountY - 15, angle)
	Common.draw(self, "enemy_s", 130, -mountX, -mountY - 15,
		angle + 0x8000, 1, 1, true)
	Common.draw(self, "enemy_s", 129, 0, 10)
	Common.draw(self, "enemy_s", 130, mountX, mountY + 35, angle)
	Common.draw(self, "enemy_s", 130, -mountX, -mountY + 35,
		angle + 0x8000, 1, 1, true)
	Common.draw(self, "enemy_s", 131, 0, -30, self.targetAngle16 or 0)
	drawAdditive(self, "enemy_s", 129, 0, 18, 0, 1, 1, 64)
end

local compositeFrames = {
	[0x9b] = {150, 151, 152, 151}, [0x9c] = {150, 151, 152, 151},
	[0x9e] = {153, 154, 155, 154}, [0x9f] = {153, 154, 155, 154},
	[0xa1] = {156, 157, 158, 157}, [0xa2] = {156, 157, 158, 157},
}

local function renderStage8Composite(self)
	if (self._ldDrawState or self.state or 0) == 0 then
		renderMarker(self, 3, 0.15)
		return
	end
	local timer = drawTimer(self)
	local frame = Common.animationFrame(timer, 5, compositeFrames[self.spawnType])
	Common.draw(self, "enemy_m", frame)
	if self.spawnType == 0x9c or self.spawnType == 0x9f or
			self.spawnType == 0xa2 then
		drawAdditive(self, "enemy_m", frame, 0, 0, 0, 1, 1,
			floor(128 + sin(timer * tau / 64) * 127))
	end
end

local function renderStage8Child(self)
	local frame = sourceFrame(self)
	if self.spawnType == 0x9d then
		Common.draw(self, "player",
			Common.animationFrame(frame, 6, {90, 91, 92, 93, 94}),
			0, 0, sourceAngle(self))
	elseif self.spawnType == 0xa0 then
		Common.draw(self, "enemy_s",
			Common.animationFrame(frame, 6, {132, 133, 134, 133}),
			0, 0, sourceAngle(self))
	else
		Common.draw(self, "player",
			Common.animationFrame(frame, 6, {98, 99, 100, 101, 102}),
			0, 0, sourceAngle(self) - 0x8000)
	end
end

local function renderA4(self)
	if (self._ldDrawState or self.state or 0) == 0 then
		renderMarker(self, 4, 0.2)
		return
	end
	local timer = drawTimer(self)
	local bob0 = sin(timer * tau / 88) * 2
	local bob1 = sin((timer - 32) * tau / 88) * 2
	local wing = sin(timer * tau / 88) * 1536
	Common.draw(self, "enemy_m", 145, 0, bob0)
	Common.draw(self, "enemy_m", 146, 6, bob0 + 10, wing)
	Common.draw(self, "enemy_m", 146, -6, bob0 + 10, -wing, 1, 1, true)
	Common.draw(self, "enemy_m", 147, 0, bob0)
	Common.draw(self, "enemy_m", 148, 0, bob1)
	Common.draw(self, "enemy_m", 149, 0, bob1)
end

local function renderCarrierChild(self)
	local count = self.spawnType == 0xa5 and 8 or 5
	local angle = sourceAngle(self)
	local radians = Core.angleToRadians(angle)
	local reverse = (self.originX or 360) < 0
	for index = count - 1, 0, -1 do
		local distance = 20 + index * 30
		Common.draw(self, "enemy_m", 159,
			-cos(radians) * distance, -sin(radians) * distance,
			angle, 0.75 + index * 0.02, 1, reverse)
	end
	Common.draw(self, "enemy_m", self.spawnType == 0xa5 and 160 or 162,
		0, 0, angle, 1, 1, reverse)
	local tip = self.targetAngle16 or angle
	local tipX, tipY = Core.polar(tip, 28)
	Common.draw(self, "enemy_m", 161, tipX, tipY, tip, 1, 1, reverse)
end

local function renderAD(self)
	if (self._ldDrawState or self.state or 0) == 0 then
		renderMarker(self, 3, 0.15)
		return
	end
	Common.draw(self, "enemy_s", 142, 0, 0, sourceAngle(self))
end

local function renderStage10Marker(self)
	local initial = self.spawnType <= 0xfd and 2 or 3
	local decay = self.spawnType <= 0xfd and 0.1 or 0.15
	renderMarker(self, initial, decay)
end

local function renderFAorFB(self)
	local timer = drawTimer(self)
	local first = self.spawnType == 0xfa
	local body, wing = first and 152 or 154, first and 153 or 155
	local angle = first and (self.secondaryAngle16 or sourceAngle(self)) or
		sourceAngle(self)
	local heading = Core.angleToRadians(angle)
	local perpendicular = heading + pi * 0.5
	local centerX, centerY = cos(heading) * 5, sin(heading) * 5
	local dx, dy = cos(perpendicular) * 35, sin(perpendicular) * 35
	local spin = sin(timer * tau / 25) * 3333
	Common.draw(self, "enemy_s", wing, centerX + dx, centerY + dy,
		angle + spin - 0x4000)
	Common.draw(self, "enemy_s", wing, centerX - dx, centerY - dy,
		angle - spin - 0x4000, 1, 1, true)
	Common.draw(self, "enemy_s", body, 0, 0, angle)
end

local function renderFC(self)
	local timer = drawTimer(self)
	local frontY = sin(timer * pi / 25) - 45
	local middleY = sin((timer - 12) * pi / 25) - 5
	local frontSpin = -900 * sin((timer - 24) * pi / 25)
	local middleSpin = 900 * sin((timer - 12) * pi / 25)
	Common.draw(self, "enemy_s", 159, 12, middleY + 36, frontSpin)
	Common.draw(self, "enemy_s", 159, -12, middleY + 36, -frontSpin, 1, 1, true)
	Common.draw(self, "enemy_s", 158, 14, middleY, middleSpin)
	Common.draw(self, "enemy_s", 158, -14, middleY, -middleSpin, 1, 1, true)
	Common.draw(self, "enemy_s", 157, 0, middleY)
	Common.draw(self, "enemy_s", 156, 0, frontY)
end

local function renderFD(self)
	local timer = drawTimer(self)
	Common.draw(self, "enemy_m", 202)
	for index = 0, 3 do
		Common.draw(self, "enemy_m", 203, 0, -80,
			timer * 1000 + index * 0x4000)
	end
end

local function renderFEor100(self)
	local timer = drawTimer(self)
	local first = self.spawnType == 0xfe
	local body, wing = first and 204 or 206, first and 205 or 207
	local sway = sin(timer * tau / 48) * 5
	if timer % 2 == 0 then
		Common.draw(self, "enemy_m", wing, 70, sway - (first and 0 or 10))
		Common.draw(self, "enemy_m", wing, -70, sway - (first and 0 or 10),
			0, 1, 1, true)
	end
	Common.draw(self, "enemy_m", body)
end

local function renderFF(self)
	local timer = drawTimer(self)
	Common.draw(self, "enemy_s", 160 + floor(timer / 15) % 2,
		0, 0, 0, sin(timer * tau / 30), 1)
end

local function render101(self)
	local timer = drawTimer(self)
	local scaleY = 1
	if timer % 50 < 11 then scaleY = scaleY - sin((timer % 50) * pi / 10) end
	Common.draw(self, "enemy_s", 162, 0, 0, 0, 1, scaleY)
end

local function render102(self)
	local timer = drawTimer(self)
	local frontY = 2 * sin(timer * tau / 70) - 62
	local middleY = 2 * sin((timer - 12) * tau / 70) - 10
	local rearY = 2 * sin((timer - 24) * tau / 70) + 50
	local coreY = 2 * sin((timer - 36) * tau / 70)
	local mountAngle = sin(timer * tau / 70) * 4400
	local mountX, mountY = Core.polar(mountAngle, 80)
	mountX = mountX + 10
	Common.draw(self, "enemy_m", 209, mountX, middleY + mountY, mountAngle)
	Common.draw(self, "enemy_m", 209, -mountX, middleY + mountY,
		-mountAngle, 1, 1, true)
	Common.draw(self, "enemy_s", 164, 0, rearY)
	Common.draw(self, "enemy_m", 208, 0, middleY)
	Common.draw(self, "enemy_s", 163, 0, frontY)
	Common.draw(self, "enemy_m", 210, 0, coreY)
end

local function render103or104(self)
	local timer = drawTimer(self)
	for index = 0, 3 do
		Common.draw(self, "enemy_m", 213, 0, 50,
			timer * 600 + index * 0x4000)
	end
	Common.draw(self, "enemy_m", 212)
	local frame = max(0, sourceFrame(self) - 1)
	local function drawOrbit(rear)
		for index = 0, 12 do
			local angle = Core.angle16(frame * 0xde + index * 0x13b1)
			if (angle > 0x8000) == rear then
				local dx, dy = Core.polar(angle, 1)
				Common.draw(self, "enemy_s", 165, dx * 72, -8 + dy * 40)
			end
		end
	end
	drawOrbit(true)
	Common.draw(self, "enemy_m", 211)
	drawOrbit(false)
end

local renderers = {
	[0x95] = render95, [0x96] = render96,
	[0x97] = renderStage8Turret, [0x98] = renderStage8Turret,
	[0x99] = renderStage8Turret, [0x9a] = function(self)
		Common.draw(self, "enemy_l", 52, 0, 50)
	end,
	[0x9b] = renderStage8Composite, [0x9c] = renderStage8Composite,
	[0x9d] = renderStage8Child, [0x9e] = renderStage8Composite,
	[0x9f] = renderStage8Composite, [0xa0] = renderStage8Child,
	[0xa1] = renderStage8Composite, [0xa2] = renderStage8Composite,
	[0xa3] = renderStage8Child, [0xa4] = renderA4,
	[0xa5] = renderCarrierChild, [0xa6] = renderCarrierChild,
	[0xad] = renderAD,
	[0xfa] = renderFAorFB, [0xfb] = renderFAorFB, [0xfc] = renderFC,
	[0xfd] = renderFD, [0xfe] = renderFEor100, [0xff] = renderFF,
	[0x100] = renderFEor100, [0x101] = render101, [0x102] = render102,
	[0x103] = render103or104, [0x104] = render103or104,
}

local stage10Roots = {
	[0xfa] = true, [0xfb] = true, [0xfc] = true, [0xfd] = true,
	[0xfe] = true, [0x100] = true, [0x102] = true,
	[0x103] = true, [0x104] = true,
}

function Renderer:render(entity)
	local renderer = self.renderers[entity.spawnType]
	if not renderer then return false end
	if self.markerRoots[entity.spawnType] and
			(entity._ldDrawState or entity.state or 0) == 0 then
		renderStage10Marker(entity)
		return true
	end
	renderer(entity)
	return true
end

local renderer = Renderer.new(renderers, stage10Roots)

function M.render(self)
	return renderer:render(self)
end

return M
