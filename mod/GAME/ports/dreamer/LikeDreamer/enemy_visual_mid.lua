-- Exact multipart visuals for ordinary Stage 5-7 enemies.

LikeDreamer = LikeDreamer or {}

local Core = assert(LikeDreamer.Core)
local Visual = assert(LikeDreamer.EnemyVisualCommon)
local M = {}
LikeDreamer.EnemyVisualMid = M

local Renderer = {}
Renderer.__index = Renderer

function Renderer.new(handledTypes)
	return setmetatable({handledTypes = handledTypes}, Renderer)
end

M.Renderer = Renderer

local sin, cos, floor, max, min =
	math.sin, math.cos, math.floor, math.max, math.min
local pi, tau = math.pi, math.pi * 2

local handled = {}
for typeId = 0x44, 0x4e do handled[typeId] = true end
for typeId = 0x57, 0x60 do handled[typeId] = true end
for typeId = 0x70, 0x76 do handled[typeId] = true end

local function clamp(value, lo, hi)
	return max(lo, min(hi, value))
end

local function trunc(value)
	return value < 0 and math.ceil(value) or floor(value)
end

local function angle(value)
	return Core.angle16(value or 0)
end

local function radians(value)
	return Core.angleToRadians(value or 0)
end

local function timerOf(self)
	if self._ldDrawTimer ~= nil then return max(0, self._ldDrawTimer) end
	return max(0, (self.helperTimer or 1) - 1)
end

local function stateOf(self)
	return self._ldDrawState or self.state or 0
end

local function sourceFrameOf(self)
	if self._ldSourceFrame ~= nil then return max(0, self._ldSourceFrame) end
	local runtime = self.runtime or LikeDreamer.runtime
	return max(0, (runtime and runtime.frame or 0) - 1)
end

local function sourceAngleOf(self)
	return self.sourceAngle16 or self.angle16 or 0
end

local function draw(self, family, frame, offsetX, offsetY, angle16,
		scaleX, scaleY, reverseX)
	return Visual.draw(self, family, frame, offsetX or 0, offsetY or 0,
		angle16 or 0, scaleX, scaleY, reverseX)
end

local function setFrameState(family, frame, blend, alpha, red, green, blue)
	local name = Visual.name(family, frame)
	if not name or not Visual.exists(family, frame) then return false end
	local setter = rawget(_G, "SetImageState") or (lstg and lstg.SetImageState)
	local color = rawget(_G, "Color") or (lstg and lstg.Color)
	if not setter or not color then return false end
	setter(name, blend or "", color(
		floor(clamp(alpha or 255, 0, 255)),
		floor(clamp(red or 255, 0, 255)),
		floor(clamp(green or 255, 0, 255)),
		floor(clamp(blue or 255, 0, 255))))
	return true
end

local function resetFrameState(family, frame)
	setFrameState(family, frame, "", 255, 255, 255, 255)
end

local function drawTinted(self, family, frame, blend, alpha, red, green, blue,
		offsetX, offsetY, angle16, scaleX, scaleY, reverseX)
	local changed = setFrameState(family, frame, blend, alpha, red, green, blue)
	draw(self, family, frame, offsetX, offsetY, angle16,
		scaleX, scaleY, reverseX)
	if changed then resetFrameState(family, frame) end
end

local function drawMarker(self, stageGroup)
	if not self._ldDrawMarker then return end
	if self.spawnType == 0x4d then return end
	local timer = max(0, self._ldMarkerTimer or timerOf(self))
	local scale
	if stageGroup == 5 then
		scale = 3 - timer * 0.15
	elseif stageGroup == 6 then
		scale = (self.spawnType == 0x5b or self.spawnType == 0x5c)
			and (2 - timer * 0.1) or (3 - timer * 0.15)
	else
		scale = 2 - timer * 0.1
		if self.spawnType >= 0x71 and self.spawnType <= 0x73 then
			scale = 3 - timer * 0.15
		elseif self.spawnType == 0x76 or self.spawnType == 0x77 then
			scale = 4 - timer * 0.2
		end
	end
	local markerX, markerY = self.ldX, self.ldY
	local margin
	if stageGroup == 5 then
		margin = (self.spawnType == 0x46 or self.spawnType == 0x4a) and 50 or 20
	elseif stageGroup == 6 then
		if self.spawnType == 0x57 or self.spawnType == 0x58 then
			local source = self.spawnType == 0x57 and 0x58f0 or 0x2710
			local projection = -markerY * 0.8
			local dx, dy = Core.polar(source, projection)
			markerX, markerY = markerX + dx, markerY + dy
		end
		if self.spawnType ~= 0x5b and self.spawnType ~= 0x5c then margin = 50 end
	else
		if self.spawnType == 0x71 or self.spawnType == 0x72 then
			local projection = -markerY * 0.8
			local dx, dy = Core.polar(0x4000, projection)
			markerX, markerY = markerX + dx, markerY + dy
		elseif self.spawnType == 0x74 then
			markerX = markerX + sin(sourceFrameOf(self) * tau / 3300) * 80
		end
		margin = ((self.spawnType >= 0x71 and self.spawnType <= 0x73) or
			self.spawnType == 0x76) and 50 or 20
	end
	if margin then
		local runtime = self.runtime or LikeDreamer.runtime
		local left = Core.playfieldOriginX(runtime and runtime.cameraX)
		markerX = clamp(markerX, left - margin, left + Core.WIDTH + margin)
		markerY = clamp(markerY, -margin, Core.HEIGHT + margin)
	end
	draw(self, "effect_m", 4,
		markerX - self.ldX, markerY - self.ldY,
		0, max(0, scale), max(0, scale))
end

local function renderStage5(self)
	local typeId = self.spawnType
	local timer = timerOf(self)
	local state = stateOf(self)
	local sourceFrame = sourceFrameOf(self)

	if typeId == 0x44 then
		local spin = angle(timer * 0x29a)
		local outerScale = 1.1 + 0.1 * sin((timer - 11) * tau / 44)
		drawTinted(self, "enemy_s", 47, "", 0x80, 255, 255, 255,
			0, 0, spin, outerScale, outerScale)
		drawTinted(self, "enemy_s", 47, "", 0x80, 255, 255, 255,
			0, 0, angle(-spin), outerScale, outerScale)
		draw(self, "enemy_s", 46, 0, 0, sourceAngleOf(self),
			1, 1 + 0.1 * sin(timer * tau / 44))
		return true
	elseif typeId == 0x45 then
		local mountY = sin((timer - 15) * tau / 48)
		local outerAngle = trunc(sin(timer * tau / 13) * 5000)
		local innerAngle = trunc(sin((timer - 4) * tau / 13) * 5000)
		draw(self, "enemy_s", 51, 5, mountY, angle(innerAngle))
		draw(self, "enemy_s", 51, -5, mountY, angle(-innerAngle), 1, 1, true)
		draw(self, "enemy_s", 50, 5, mountY, angle(outerAngle))
		draw(self, "enemy_s", 50, -5, mountY, angle(-outerAngle), 1, 1, true)
		draw(self, "enemy_s", 49, 0, mountY)
		draw(self, "enemy_s", 48, 0, 2 + sin(timer * tau / 48))
		return true
	elseif typeId == 0x46 then
		local front = trunc(sin((timer - 3) * tau / 36) * 2400)
		local rear = trunc(sin(timer * tau / 36) * 2400)
		draw(self, "enemy_m", 80, 0, 0, angle(front))
		draw(self, "enemy_m", 80, 0, 0, angle(-front), 1, 1, true)
		draw(self, "enemy_m", 79, 0, 0, angle(rear))
		draw(self, "enemy_m", 79, 0, 0, angle(-rear), 1, 1, true)
		draw(self, "enemy_m", 78, 0, 0)
		return true
	elseif typeId == 0x47 or typeId == 0x48 then
		local scale = 1 + 0.05 * sin(timer * tau / 66)
		local wobble = trunc(sin((sourceFrame - (self.entityId or 0) * 13) *
			tau / 88) * 666)
		draw(self, "enemy_m", 81, 0, 0, angle(wobble), scale, scale)
		return true
	elseif typeId == 0x49 then
		local scale = state == 0 and sin(clamp(timer, 0, 30) * pi / 60) or 1
		draw(self, "enemy_m", 82, 0, 0, 0, scale, scale)
		return true
	elseif typeId == 0x4a then
		local bodyScale = 1 + 0.05 * sin(timer * tau / 99)
		local mountPhase = radians(angle(trunc((timer - 12) * 1489.4545454545455)))
		draw(self, "enemy_m", 83, 0, 0, 0, bodyScale, 1)
		draw(self, "enemy_s", 52, 0, -52 + sin(mountPhase) * 2)
		return true
	elseif typeId == 0x4b then
		local wave = sin(timer * tau / 8) * 2
		draw(self, "enemy_s", 54, 0, wave)
		draw(self, "enemy_s", 53, 0, -wave)
		return true
	elseif typeId == 0x4c then
		local drawAngle = angle(sourceFrame * -0x8ae +
			(self.entityId or 0) * -0x4a56)
		local runtime = self.runtime or LikeDreamer.runtime
		local targetScale = (runtime and runtime.difficulty or 1) < 2 and 0.8 or 1
		local scale = state == 0 and
			sin(clamp(timer, 0, 20) * pi / 40) * targetScale or targetScale
		draw(self, "enemy_m", 84, 0, 0, drawAngle, scale, scale)
		if scale > 0 then
			drawTinted(self, "enemy_m", 84, "mul+add", 0x30, 255, 255, 255,
				0, 0, drawAngle, scale, scale)
		end
		return true
	elseif typeId == 0x4d then
		-- Enemy_l[21] is deliberately behind the orbiting body assembly.
		draw(self, "enemy_l", 21, 0, state == 2 and -115 or 115)
		if state ~= 2 then
			local ringScale = 1 + 0.1 * sin(sourceFrame * tau / 94)
			local radius = 50 * ringScale
			for i = 0, 4 do
				local a = angle(timer * 0x1c8 + i * 0x3333)
				local r = radians(a)
				draw(self, "enemy_m", 85, cos(r) * radius, sin(r) * radius,
					a, ringScale, ringScale)
			end
			draw(self, "enemy_s", 55, 0, 0, angle(sourceFrame * -0x7b))
		end
		return true
	elseif typeId == 0x4e then
		-- enemy_late keeps the original aimed source angle in secondaryAngle16
		-- for this attached satellite.
		draw(self, "enemy_m", 86, 0, 0,
			self.secondaryAngle16 or sourceAngleOf(self))
		return true
	end
	return false
end

local function drawBlackShadow(self, family, frame, offsetX, offsetY,
		angle16, scaleX, scaleY, reverseX)
	drawTinted(self, family, frame, "", 0x40, 0, 0, 0,
		offsetX, offsetY, angle16, scaleX, scaleY, reverseX)
end

local function renderStage6(self)
	local typeId = self.spawnType
	local timer = timerOf(self)
	local state = stateOf(self)
	local sourceFrame = sourceFrameOf(self)

	if typeId == 0x57 or typeId == 0x58 then
		for i = 0, 2 do
			local a = angle(sourceFrame * 0x29a + i * 0x5555)
			local r = radians(a)
			draw(self, "enemy_m", 85, cos(r) * 36, 20 + sin(r) * 20)
		end
		draw(self, "enemy_m", 84)
		return true
	elseif typeId == 0x59 then
		local sourceAngle = angle(trunc(sin(timer * tau / 67) * 1024))
		local targetAngle = angle(trunc(sin(timer * tau / 23) * 2048))
		local r = radians(sourceAngle)
		-- The source keeps the pre-movement point in markerDrawX/Y. The Lua
		-- updater uses an analytic path, so recover that previous point here.
		local previousTimer = max(0, timer - 1)
		local amplitude = previousTimer < 118 and
			460 - sin(previousTimer * pi / 236) * 300 or 160
		local baseY = self._ldBaseY or self.originY or self.ldY
		if timer > 300 then baseY = baseY + (self._ldExitSpeed or 0) end
		local markerX = 360 + sin((previousTimer + 59) * tau / 236) *
			amplitude * (self._ldSide or 1)
		local markerY = baseY + sin(previousTimer * tau / 172) * -70
		local baseX = markerX - self.ldX
		local baseY = markerY - self.ldY
		draw(self, "enemy_m", 87, baseX + cos(r) * 30,
			baseY + sin(r) * 30, targetAngle)
		draw(self, "enemy_m", 87, baseX - cos(r) * 30,
			baseY - sin(r) * 30, angle(-targetAngle), 1, 1, true)
		draw(self, "enemy_m", 86, 0, 0, sourceAngle)
		return true
	elseif typeId == 0x5a then
		local heading = radians(sourceAngleOf(self))
		local anchorX = (self.originX or self.ldX) - self.ldX
		local anchorY = (self.originY or self.ldY) - self.ldY + 30
		local pulse = 1 + sin((timer - 20) * tau / 61) * 0.1
		drawBlackShadow(self, "enemy_s", 61, anchorX, anchorY, 0, pulse, pulse)
		draw(self, "enemy_s", 61, anchorX, anchorY, 0, pulse, pulse)
		draw(self, "enemy_s", 58, 0, 0, angle(timer * 0x1bc))
		draw(self, "enemy_s", 59)
		draw(self, "enemy_s", 60, cos(heading) * 8, sin(heading) * 8 + 7)
		return true
	elseif typeId == 0x5b or typeId == 0x5c then
		local wave0 = sin((timer % 50) * pi / 50) * -10
		local wave3 = sin(((timer + 3) % 50) * pi / 50) * -10
		local wing = trunc(sin(((timer + 5) % 50) * pi / 50) * -4000)
		local wingR = (timer + 5) % 100 < 51 and
			trunc(sin(((timer + 5) % 100) * pi / 50) * 13000) or 0
		local wingL = (timer + 55) % 100 < 51 and
			trunc(sin(((timer + 55) % 100) * pi / 50) * 13000) or 0
		local tail = 62 + floor(timer / 7) % 4
		drawBlackShadow(self, "enemy_s", tail, 0, 60)
		draw(self, "enemy_s", tail, 0, 60)
		draw(self, "enemy_s", 66, 8, wave3 + 16, angle(-wingR))
		draw(self, "enemy_s", 66, -8, wave3 + 16, angle(wingL), 1, 1, true)
		draw(self, "enemy_s", 67, 10, wave3, angle(-wing))
		draw(self, "enemy_s", 67, -10, wave3, angle(wing), 1, 1, true)
		draw(self, "enemy_s", 68, 0, wave3)
		draw(self, "enemy_s", 69, 0, wave0 - 14)
		return true
	elseif typeId == 0x5d then
		local wave0 = sin(timer * tau / 55) * 2
		local wave14 = sin((timer - 14) * tau / 55) * 2
		local wing = trunc(sin((timer - 28) * tau / 55) * 3000)
		local spin = trunc(sin((timer - 7) * tau / 55) * 600)
		drawBlackShadow(self, "enemy_m", 96)
		draw(self, "enemy_m", 91)
		draw(self, "enemy_m", 95, 13, wave0 + 12, angle(spin))
		draw(self, "enemy_m", 95, -13, wave0 + 12, angle(-spin), 1, 1, true)
		draw(self, "enemy_m", 92, 0, wave0 - 8)
		draw(self, "enemy_m", 93, 0, wave14 - 5)
		draw(self, "enemy_m", 94, 20, wave14 - 29, angle(wing))
		draw(self, "enemy_m", 94, -20, wave14 - 29, angle(-wing), 1, 1, true)
		return true
	elseif typeId == 0x5e then
		local spin = trunc(sin(timer * tau / 177) * 2000)
		local secondary = trunc(sin(timer * tau / 77) * 800)
		local anchorX = (self.originX or self.ldX) - self.ldX
		local anchorY = (self.originY or self.ldY) - self.ldY + 40
		drawBlackShadow(self, "enemy_m", 100, anchorX, anchorY)
		draw(self, "enemy_m", 97, 0, 0, angle(spin))
		draw(self, "enemy_m", 98, 0, 0, angle(spin), 1, 1,
			(self.originX or self.ldX) < 360)
		draw(self, "enemy_m", 99, 0, 0, angle(spin + secondary))
		return true
	elseif typeId == 0x5f then
		local scale = state == 2 and 1 + sin(timer * pi / 6) * 0.1 or 1
		drawBlackShadow(self, "enemy_l", 35, 0, -168, 0, scale, 1.5)
		draw(self, "enemy_l", 35, 0, 130, 0, scale, 1)
		return true
	elseif typeId == 0x60 then
		draw(self, "enemy_s", 70, 0, 0, angle(timer * 0x22b))
		return true
	end
	return false
end

local function renderStage7(self)
	local typeId = self.spawnType
	local timer = timerOf(self)

	if typeId == 0x70 then
		local anchorX = (self.originX or self.ldX) - self.ldX
		local anchorY = (self.originY or self.ldY) - self.ldY
		local spin = angle(timer * 0xf3c)
		draw(self, "enemy_s", 78, anchorX, anchorY, spin)
		draw(self, "enemy_s", 78, anchorX, anchorY, angle(spin + 0x8000))
		draw(self, "enemy_s", 79, anchorX, anchorY)
		draw(self, "enemy_s", 80, 0, 0, self.secondaryAngle16)
		local r = radians(self.secondaryAngle16)
		drawTinted(self, "enemy_s", 81, "", 0x40, 255, 255, 255,
			cos(r) * 55, sin(r) * 55, self.secondaryAngle16)
		return true
	elseif typeId == 0x71 or typeId == 0x72 then
		local sway = trunc(sin(timer * tau / 240) * 1800)
		draw(self, "enemy_m", 114, 0, -18, angle(sway))
		draw(self, "enemy_m", 114, 0, -18, angle(-sway), 1, 1, true)
		draw(self, "enemy_m", 113, 0, -18, angle(sway / 2))
		draw(self, "enemy_m", 113, 0, -18, angle(-sway / 2), 1, 1, true)
		draw(self, "enemy_m", 110 + floor(timer / 5) % 2)
		return true
	elseif typeId == 0x73 then
		draw(self, "enemy_m", 116, 0, 25, self.secondaryAngle16)
		draw(self, "enemy_m", 115)
		local xs = {85, -85, -83, 83}
		local ys = {50, 50, -35, -35}
		for i = 1, 4 do
			local sign = i % 2 == 1 and 1 or -1
			draw(self, "enemy_m", 117, xs[i], ys[i],
				angle(sign * timer * 0xe10), 1, 1, i % 2 == 0)
		end
		return true
	elseif typeId == 0x74 then
		local frame = 82 + floor(timer / 5) % 2
		local cycle = (timer + 0x2670) % 0x140
		if (cycle >= 30 and cycle < 35) or (cycle >= 125 and cycle < 130) then
			frame = 87
		elseif cycle >= 35 and cycle < 125 then
			frame = 88 + floor((cycle - 35) / 5) % 2
		elseif (cycle >= 190 and cycle < 195) or
				(cycle >= 285 and cycle < 290) then
			frame = 84
		elseif cycle >= 195 and cycle < 285 then
			frame = 85 + floor((cycle - 195) / 5) % 2
		end
		draw(self, "enemy_s", frame)
		return true
	elseif typeId == 0x75 then
		local wave = sin(timer * tau / 5) * 1.5
		drawTinted(self, "enemy_s", 90, "", 0x40, 255, 255, 255,
			0, 25 + wave)
		draw(self, "enemy_s", 92 + floor(timer / 5) % 2, 0, 28)
		draw(self, "enemy_s", 90, 0, 18 + wave)
		draw(self, "enemy_s", 91, 0, wave)
		return true
	elseif typeId == 0x76 then
		local bob = sin((timer - 2) * pi / 4) * 2
		local base = self.secondaryAngle16 or 0
		local r = radians(base)
		local centerX = cos(r) * -60
		local centerY = bob + sin(r) * -60
		local leftR = radians(angle(base - 0x32c8))
		local rightR = radians(angle(base + 0x32c8))
		local leftX, leftY = centerX + cos(leftR) * 87,
			centerY + sin(leftR) * 87
		local rightX, rightY = centerX + cos(rightR) * 87,
			centerY + sin(rightR) * 87
		drawTinted(self, "enemy_m", 118, "", 0x40, 255, 255, 255,
			0, 5 + bob)
		draw(self, "enemy_s", 94 + floor(timer / 5) % 2, 75, 90)
		draw(self, "enemy_s", 94 + floor(timer / 5) % 2, -75, 90,
			0, 1, 1, true)
		draw(self, "enemy_m", 118, 0, 5 + bob)
		draw(self, "enemy_m", 119, 75, 10 + bob)
		draw(self, "enemy_m", 119, -75, 10 + bob, 0, 1, 1, true)
		local partAngle = angle(base - 0x4000)
		draw(self, "enemy_m", 120, 0, bob, partAngle)
		draw(self, "enemy_m", 121, centerX, centerY, partAngle)
		draw(self, "enemy_m", 122, leftX, leftY, partAngle)
		draw(self, "enemy_m", 122, rightX, rightY, partAngle, 1, 1, true)
		return true
	end
	return false
end

function Renderer:render(entity)
	if not entity or not self.handledTypes[entity.spawnType] then return false end

	local stageGroup = entity.spawnType <= 0x4e and 5 or
		(entity.spawnType <= 0x60 and 6 or 7)
	drawMarker(entity, stageGroup)
	if entity._ldDrawBody == false then return true end

	if stageGroup == 5 then return renderStage5(entity) end
	if stageGroup == 6 then return renderStage6(entity) end
	return renderStage7(entity)
end

local renderer = Renderer.new(handled)

function M.render(self)
	return renderer:render(self)
end

M.handled = handled

return M
