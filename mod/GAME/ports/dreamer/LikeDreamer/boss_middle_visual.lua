-- Exact multi-part visuals for the Stage 5-7 set pieces and bosses.

LikeDreamer = LikeDreamer or {}

local Core = assert(LikeDreamer.Core)
local Common = assert(LikeDreamer.EnemyVisualCommon)
local M = {}
LikeDreamer.BossMiddleVisual = M

local sin, pi = math.sin, math.pi
local floor, ceil = math.floor, math.ceil
local min, max = math.min, math.max
local tau = pi * 2

local function trunc(value)
	return value < 0 and ceil(value) or floor(value)
end

local function clampByte(value)
	return floor(Core.clamp(value, 0, 255))
end

local function drawTimer(self)
	return max(0, (self.helperTimer or 0) - 1)
end

local function frame(self)
	return self.runtime and self.runtime.frame or 0
end

local function sourceFrame(self)
	return max(0, frame(self) - 1)
end

local function cmod(value, modulus)
	if value >= 0 then return value % modulus end
	return -((-value) % modulus)
end

local function draw(self, family, imageFrame, offsetX, offsetY, angle,
		scaleX, scaleY, reverse)
	return Common.draw(self, family, imageFrame, offsetX, offsetY, angle,
		scaleX, scaleY, reverse)
end

local function drawStyled(self, family, imageFrame, offsetX, offsetY, angle,
		scaleX, scaleY, reverse, blend, alpha, red, green, blue)
	if not Common.exists(family, imageFrame) then return false end
	local name = Common.name(family, imageFrame)
	SetImageState(name, blend or "", Color(
		clampByte(alpha == nil and 255 or alpha),
		clampByte(red == nil and 255 or red),
		clampByte(green == nil and 255 or green),
		clampByte(blue == nil and 255 or blue)))
	local rendered = draw(self, family, imageFrame, offsetX, offsetY, angle,
		scaleX, scaleY, reverse)
	SetImageState(name, "", Color(255, 255, 255, 255))
	return rendered
end

local function loopingFrame(timer, start, divisor, frames)
	return frames[floor(max(0, timer - start) / divisor) % #frames + 1]
end

local function onLayer(requested, exact)
	return requested == nil or requested == exact
end

-- Stage 5 -----------------------------------------------------------------

local function renderStage05Root(self)
	local timer = drawTimer(self)
	local scale, brightness, alpha = 1, 255, 255
	if self.state == 0 then
		if timer < 100 then
			scale = sin(timer * pi / 200)
			brightness = clampByte(scale * 255)
			if timer < 10 then alpha = clampByte(sin(timer * pi / 20) * 255) end
		end
	end
	local ornamentAngle = trunc(sin(sourceFrame(self) * tau / 99) * 1000)
	drawStyled(self, "enemy_l", 23, scale * 128, -scale * 95,
		ornamentAngle, scale, scale, false, "", alpha,
		brightness, brightness, brightness)
	drawStyled(self, "enemy_l", 22, 0, 0, 0, scale, scale, false, "",
		alpha, brightness, brightness, brightness)
end

local function renderStage05LargeNode(self)
	local timer = drawTimer(self)
	local scale = self.state == 0 and sin(min(timer, 100) * pi / 200) or 1
	local imageFrame, angle = 24, 0
	local left = (self._bmOffsetX or self.originX or 0) < 0
	if self.spawnType == 0x51 then
		imageFrame = left and 26 or 25
		angle = trunc(sin((sourceFrame(self) - 66) * tau / 99) *
			(left and -700 or 700))
	elseif self.spawnType == 0x52 then
		imageFrame = left and 28 or 27
		angle = trunc(sin((sourceFrame(self) - 33) * tau / 99) *
			(left and -900 or 900)) + (left and -10000 or 10000)
	end
	local brightness, alpha = 255, 255
	if self.state == 0 then
		brightness = timer < 100 and clampByte(sin(timer * pi / 200) * 255) or 255
		alpha = timer < 10 and clampByte(sin(timer * pi / 20) * 255) or 255
	end
	drawStyled(self, "enemy_l", imageFrame, 0, 0, angle, scale, scale,
		false, "", alpha, brightness, brightness, brightness)
	if self.state == 0 and timer < 100 then
		drawStyled(self, "enemy_l", imageFrame, 0, 0, angle, scale, scale,
			false, "mul+add", 255 - brightness)
	end
end

local function renderStage05Type53(self)
	local timer = drawTimer(self)
	local active = self._bmShared or self.state == 1
	local sequence = Core.clamp(self._bmIndex or 1, 1, 4)
	local start = sequence * 20
	local imageFrame = 50 + floor(timer / 7) % 3
	if active and timer >= start + 40 then
		imageFrame = 55 + floor((timer - start - 40) / 5) % 3
	elseif active and timer >= start + 30 then
		imageFrame = 53 + floor((timer - start - 30) / 5) % 2
	end
	local scaleX, scaleY, overlay = 1, 1, 0
	if not active then
		local intro = min(timer, 30)
		local fold = sin((intro + 30) * pi / 60)
		scaleX, scaleY = 1 - fold, 1 + fold
		overlay = clampByte(255 - sin(intro * pi / 60) * 255)
	end
	draw(self, "boss", imageFrame, 0, 0, 0, scaleX, scaleY)
	if overlay > 0 then
		drawStyled(self, "boss", imageFrame, 0, 0, 0, scaleX, scaleY,
			false, "mul+add", overlay)
	end
end

local function renderStage05Type54(self)
	local timer = drawTimer(self)
	local active = self._bmShared or self.targetable or timer >= 172
	local idle, windup = {50, 51, 52}, {53, 54}
	local attack, finish = {55, 56, 57}, {54, 53}
	local imageFrame = loopingFrame(timer, 0, 7, idle)
	local scale = 1
	if not active and timer < 60 then
		scale = 0.4 + sin(timer * pi / 120) * 0.6
	elseif active then
		local tick = cmod(timer - 0xac, 700)
		if tick >= 0x78 and tick < 0x82 then
			imageFrame = loopingFrame(tick, 0x78, 5, windup)
		elseif tick >= 0x82 and tick < 0x2b3 then
			imageFrame = loopingFrame(tick, 0x82, 5, attack)
		elseif tick >= 0x2b3 then
			imageFrame = loopingFrame(tick, 0x2b3, 5, finish)
		end
	end
	draw(self, "boss", imageFrame, 0, 0, 0, scale, scale)
end

local function renderStage05Type55(self)
	local timer = drawTimer(self)
	local scale = timer < 50 and sin(timer * pi / 100) or 1
	draw(self, "enemy_s", 57, 0, 0, timer * 0x29a, scale, scale)
end

local function renderStage05Type56(self)
	local timer = drawTimer(self)
	local active = self._bmShared or self.targetable or timer >= 30
	local idle, windup = {50, 51, 52}, {53, 54}
	local finish, attack = {54, 53}, {55, 56, 57}
	local imageFrame = loopingFrame(timer, 0, 7, idle)
	local scaleX, scaleY, overlay = 1, 1, 0
	if not active then
		local intro = min(timer, 30)
		local fold = sin((intro + 30) * pi / 60)
		scaleX, scaleY = 1 - fold, 1 + fold
		overlay = clampByte(255 - sin(intro * pi / 60) * 255)
	else
		local tick = timer % 0x4b0
		if tick >= 0x1e and tick < 0x28 then
			imageFrame = loopingFrame(tick, 0x1e, 5, windup)
		elseif (tick >= 0x28 and tick < 0x168) or
				(tick >= 0x1ae and tick < 0x4a7) then
			imageFrame = loopingFrame(tick, 0x28, 5, attack)
		elseif tick >= 0x168 and tick < 0x172 then
			imageFrame = loopingFrame(tick, 0x168, 5, finish)
		elseif tick >= 0x1a4 and tick < 0x1ae then
			imageFrame = loopingFrame(tick, 0x1a4, 5, windup)
		elseif tick >= 0x4a7 then
			imageFrame = loopingFrame(tick, 0x4a7, 5, finish)
		end
	end
	draw(self, "boss", imageFrame, 0, 0, 0, scaleX, scaleY)
	if overlay > 0 then
		drawStyled(self, "boss", imageFrame, 0, 0, 0, scaleX, scaleY,
			false, "mul+add", overlay)
	end
end

local function renderStage05Boss(self, exactLayer)
	local state, timer = self.state or 0, drawTimer(self)
	local segmentStart
	if state == 0 or state == 1 or (state == 2 and timer <= 99) then
		segmentStart = 0
	elseif state == 2 or state == 3 or (state == 4 and timer <= 99) then
		segmentStart = 1
	elseif state == 4 or state == 5 or (state == 6 and timer <= 99) then
		segmentStart = 2
	elseif state == 6 or state == 7 or (state == 8 and timer <= 129) then
		segmentStart = 3
	end

	if segmentStart then
		local pulse = 1 + sin(sourceFrame(self) * tau / 5) * 0.1
		if onLayer(exactLayer, 0x17) then
			drawStyled(self, "effect_l", 15, 0, 110, 0,
				pulse, pulse, false, "mul+add", 0xe1)
		end
		for segment = segmentStart, 3 do
			local segmentY = (segmentStart - segment) * 444 - 110
			if onLayer(exactLayer, 0x18 + segment * 3) then
				draw(self, "enemy_l", 29, 0, segmentY, 0)
			end
			if segment == 3 and onLayer(exactLayer, 0x22) then
				draw(self, "boss", 40 + floor(timer / 7) % 4,
					0, segmentY + 70, 0)
			end
			if onLayer(exactLayer, 0x1a + segment * 3) then
				draw(self, "enemy_l", 30 + segment, 0, segmentY, 0)
			end
			if segment == 3 and onLayer(exactLayer, 0x24) then
				draw(self, "enemy_l", 34, 0, segmentY - 385, 0)
			end
		end
		return
	end

	local imageFrame, scale
	if state == 8 then
		if timer < 210 then
			imageFrame = 40 + floor(timer / 7) % 4
		elseif timer < 220 then
			imageFrame = 43 + floor((timer - 210) / 5) % 2
		else
			imageFrame = 45 + floor((timer - 220) / 5) % 4
		end
	elseif state == 9 or (state >= 11 and state <= 13) then
		imageFrame = 45 + floor(timer / 5) % 4
	elseif state == 10 or (state == 14 and timer < 240) then
		imageFrame = 48 + floor(timer / 5) % 2
		if state == 10 then
			scale = 1 - 0.3 * sin(timer * tau / 360)
		end
	end
	if imageFrame and onLayer(exactLayer, 0x1e) then
		draw(self, "boss", imageFrame, 0, 0, 0, scale, scale)
	end
end

-- Stage 6 -----------------------------------------------------------------

local function renderStage06Midboss(self)
	local state, timer = self.state or 0, drawTimer(self)
	local imageFrame = 65
	if state == 0 then
		imageFrame = timer < 0x6e and 60 + floor(timer / 5) % 3
			or 63 + floor((timer - 0x6e) / 5) % 3
	elseif state >= 1 and state <= 4 then
		imageFrame = 65 + floor(timer / 7) % 3
	elseif state == 5 then
		imageFrame = 68 + floor(timer / 5) % 2
	end
	if state == 2 or state == 4 then
		drawStyled(self, "boss", imageFrame,
			self._bmDrawOffsetX or 0, self._bmDrawOffsetY or 0,
			0, 1, 1, false,
			"", 0xc0)
	else
		draw(self, "boss", imageFrame, 0, 0, 0)
	end
end

local function renderStage06MidbossNode(self)
	local timer, scale = drawTimer(self), 1
	if self.state == 0 then
		scale = sin(min(timer, 40) * pi / 80)
	elseif self.state == 2 then
		scale = sin(Core.clamp(timer + 30, 30, 60) * pi / 60)
	end
	draw(self, "enemy_s", 71, 0, 0,
		(self.angle16 or 0) + frame(self) * 0x29a, scale, scale)
end

local function renderStage06Boss(self, exactLayer)
	local state, timer = self.state or 0, drawTimer(self)
	if state < 4 or (state == 4 and timer < 130) then
		local spin = sourceFrame(self) * 0xb6
		if onLayer(exactLayer, 0x1e) then
			draw(self, "enemy_l", 36, 75, 0, spin)
			draw(self, "enemy_l", 36, -75, 0, -spin, 1, 1, true)
			draw(self, "enemy_l", 37, 0, 0, self.secondaryAngle16 or 0)
			draw(self, "enemy_l", 39, 0, 0, self.targetAngle16 or 0)
		end
		if onLayer(exactLayer, 0x20) then
			draw(self, "enemy_l", 38, 0, 0, self.targetAngle16 or 0)
			local mountFrame = state < 3 and (state ~= 2 or timer < 101) and 102 or 103
			local dx, dy = Core.polar(self.targetAngle16 or 0, 75)
			draw(self, "enemy_m", mountFrame, dx, dy, self.targetAngle16 or 0)
		end
		return
	end
	local imageFrame
	if state == 10 then
		imageFrame = 78 + floor(timer / 5) % 2
	elseif state % 2 == 1 then
		imageFrame = timer < 10 and 73 + floor(timer / 5) % 2
			or 75 + floor((timer - 10) / 5) % 3
	else
		imageFrame = 70 + floor(timer / 5) % 3
	end
	if onLayer(exactLayer, 0x1e) then
		draw(self, "boss", imageFrame, 0, 0, 0)
	end
end

local function renderStage06BossNode(self)
	local id, timer = self.spawnType, drawTimer(self)
	if id == 0x64 then
		draw(self, "enemy_l", 40, 0, 0, self.angle16 or 0)
	elseif id == 0x65 then
		draw(self, "enemy_m", 101, 0, 0, self.angle16 or 0)
	elseif id >= 0x66 and id <= 0x6a then
		draw(self, "enemy_m", 104 + id - 0x66, 0, 0, self.angle16 or 0)
	elseif id >= 0x6e and id <= 0x6f then
		local scale = self.state == 0 and sin(min(timer, 40) * pi / 80) or 1
		local angle = id == 0x6f and (self.secondaryAngle16 or 0)
			or (self.angle16 or 0)
		draw(self, "enemy_s", 72 + floor(frame(self) / 4) % 6,
			0, 0, angle, scale, scale)
	end
	-- 0x6b..0x6d are invisible controller/emitter nodes in the original.
end

-- Stage 7 midbosses -------------------------------------------------------

local function renderStage07Gate(self, exactLayer)
	local timer = drawTimer(self)
	if (self.state or 0) == 0 then
		if exactLayer ~= nil and exactLayer ~= 0x32 then return end
		local scale = max(0, 4 - timer * 0.2)
		if scale > 0 then
			local cameraX = self.runtime and self.runtime.cameraX or nil
			local originX = Core.playfieldOriginX(cameraX)
			local markerX = Core.clamp(self.ldX, originX - 50,
				originX + Core.WIDTH + 50)
			local markerY = Core.clamp(self.ldY, -50, Core.HEIGHT + 50)
			local x, y = Core.toWorld(markerX, markerY, cameraX)
			Common.drawAt("effect_m", 4, x, y, 0, scale, scale)
		end
		return
	end

	local bob = sin(timer * pi / 4) * 2
	local panelAngle = trunc(sin(sourceFrame(self) * tau / 164) * 2000)
	if onLayer(exactLayer, 0x17) then
		-- The original queues this silhouette below the main assembly.
		drawStyled(self, "enemy_l", 41, 0, 150 + bob, 0, 1, 1, false,
			"", 255, 0, 0x20, 0x40)
	end
	if onLayer(exactLayer, 0x1c) then
		draw(self, "enemy_s", 96 + floor(timer / 5) % 2,
			65, 280, 0)
		draw(self, "enemy_s", 96 + floor(timer / 5) % 2,
			-65, 280, 0, 1, 1, true)
		draw(self, "enemy_l", 41, 0, 90 + bob, 0)
		draw(self, "enemy_m", 124, 0, bob, 0)
	end
	if onLayer(exactLayer, 0x1d) then
		draw(self, "enemy_m", 125, -65, -100 + bob, panelAngle)
	end
end

local function renderStage07GateChild(self)
	draw(self, "enemy_m", 123, 0, 0,
		self.sourceAngle16 or self.angle16 or 0)
end

local firstMidbossBody = {
	0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x57, 0x56,
	0x57, 0x56, 0x55, 0x54, 0x53, 0x52, 0x50, 0x51,
}
local secondMidbossBody = {
	0x60, 0x5f, 0x5e, 0x5d, 0x5c, 0x5a, 0x5b, 0x5a,
	0x5b, 0x5c, 0x5d, 0x5e, 0x5f, 0x61, 0x60, 0x61,
}

local function renderStage07Midboss(self, exactLayer)
	local first = self.spawnType == 0x144
	local state, timer = self.state or 0, drawTimer(self)
	local source = sourceFrame(self)
	local bodies = first and firstMidbossBody or secondMidbossBody
	local bodyFrame = bodies[floor(source / 5) % 16 + 1]
	local armFrame = 0x62 + floor(source / 3) % 2
	if onLayer(exactLayer, 0x17) then
		drawStyled(self, "enemy_l", 48, 0, 164, 0, 1, 1, false,
			"", 0x40, 0, 0, 0x20)
	end
	if onLayer(exactLayer, 0x19) then
		for _, x in ipairs({160, 90, -160, -90}) do
			draw(self, "enemy_s", armFrame, x, 300, 0)
		end
		draw(self, "enemy_l", 45, 0, 140, 0)
		if Core.frameRand(frame(self)) % 5 ~= 0 then
			draw(self, "enemy_l", first and 46 or 47, 0, 140, 0)
		end
		draw(self, "enemy_l", first and 42 or 43, 0, 140, 0)
		draw(self, "boss", bodyFrame, 0, 120, 0)
	end
	local pulse = 1 + sin(source * tau / 82) * 0.05
	if onLayer(exactLayer, 0x1a) then
		draw(self, "enemy_m", first and 126 or 130, 0, 0, 0, pulse, pulse)
	end

	local animation = first and 127 or 131
	if state == 2 then
		animation = first and 129 or 133
	elseif state == 3 then
		animation = (first and 127 or 131) + min(2, floor(timer / 3))
	elseif state == 1 then
		local cycle = timer % 0x578
		if first then
			local tick = cycle < 600 and cycle % 0xa4 or (cycle - 0x30c) % 0x52
			if tick < 10 then animation = 128 + floor(tick / 5)
			elseif (cycle < 600 and tick < 60) or (cycle >= 600 and tick < 40) then
				animation = 129
			elseif (cycle < 600 and tick < 70) or (cycle >= 600 and tick < 50) then
				animation = 128
			end
		else
			local window = ({40, 60, 80, 100, 100})[
				Core.clamp(self.runtime and self.runtime.difficulty or 1, 0, 4) + 1]
			local tick = cycle % 0xb8
			if tick < 10 then animation = 132 + floor(tick / 5)
			elseif tick < window then animation = 133
			elseif tick < window + 10 then animation = 132 end
		end
	end
	if onLayer(exactLayer, 0x1a) then
		draw(self, "enemy_m", animation, 0, 0, 0)
	end
	if onLayer(exactLayer, 0x1d) then
		draw(self, "enemy_l", 44, 0, 140, 0)
	end
end

local function midbossRoot(self)
	return self._bmRoot or self.parent
end

local function renderStage07MidbossNode(self)
	local id, timer = self.spawnType, drawTimer(self)
	if id == 0x79 then return end
	if id == 0x7a or id == 0x7b then
		local imageFrame = id == 0x7a and (self.state == 0 and 134 or 136)
			or (self.state == 0 and 135 or 137)
		draw(self, "enemy_m", imageFrame, 0, 10, 0, 1, 1,
			(self._bmOffsetX or 0) < 0)
		return
	end
	if id == 0x7c or id == 0x7d then
		local root = midbossRoot(self)
		local baseX = root and root.ldX + (self._bmOffsetX or 0) or self.ldX
		local baseY = root and root.ldY + (self._bmOffsetY or 0) or self.ldY
		local baseOffsetX, baseOffsetY = baseX - self.ldX, baseY - self.ldY
		local wx, wy = Core.polar(self.angle16 or 0, 120)
		drawStyled(self, "enemy_s", 81, baseOffsetX + wx,
			baseOffsetY + wy, self.angle16 or 0, 0.9, 0.9, false,
			"", 255, id == 0x7c and 255 or 0,
			id == 0x7c and 0 or 255, 255)
		draw(self, "enemy_s", 100, baseOffsetX, baseOffsetY,
			self.angle16 or 0)
		return
	end
	local scale = self.state == 0 and
		(0.2 + 0.8 * sin(min(timer, 40) * pi / 80)) or 1
	local animation = floor(sourceFrame(self) / 3) % 4
	local bodyFrames = id == 0x7e and {101, 102, 103, 102}
		or {105, 106, 107, 106}
	local bodyAngle = id == 0x7e and 0 or (self.angle16 or 0) - 0x4000
	draw(self, "enemy_s", bodyFrames[animation + 1], 0, 0, bodyAngle,
		scale, scale)
	local dx, dy = Core.polar(self.angle16 or 0, -24 * scale)
	if id == 0x7e then
		draw(self, "enemy_s", 104, dx, dy, timer * 0xc80, scale, scale)
		draw(self, "enemy_s", 104, dx, dy, timer * 0xc80 - 0x8000,
			scale, scale)
	else
		draw(self, "enemy_s", 108, dx, dy,
			(self.angle16 or 0) + timer * 0x180 - 0x4000, scale, scale)
		draw(self, "enemy_s", 108, dx, dy,
			(self.angle16 or 0) - timer * 0x180 + 0x4000, scale, scale)
	end
end

-- Stage 7 double boss -----------------------------------------------------

local function renderStage07BossRoot(self, exactLayer)
	local state, timer = self.state or 0, drawTimer(self)
	if state >= 10 and not (state == 10 and timer < 100) then return end
	if onLayer(exactLayer, 0x19) then
		draw(self, "enemy_l", 45, 0, 20, 0)
		if Core.frameRand(sourceFrame(self)) % 5 ~= 0 then
			draw(self, "enemy_l", 51, 0, 0, 0)
		end
		draw(self, "enemy_l", 49, 0, 0, 0)
	end
	if onLayer(exactLayer, 0x1e) then
		draw(self, "enemy_l", 50, 0, 0, 0)
	end
end

local function renderStage07IntroTrail(self)
	local angle = self.angle16 or 0
	local dx, dy = Core.polar(angle, 20)
	local anchorX = -dx
	local anchorY = -24 - dy
	draw(self, "enemy_s", 79, anchorX, anchorY, 0)
	draw(self, "enemy_s", 80, 0, 0, angle)

	local trailAlpha = 0x40
	if self._bmTrailExiting then
		local exitTimer = self._bmTrailFadeTimer or 0
		trailAlpha = exitTimer < 60 and clampByte(
			sin((exitTimer + 60) * pi / 120) * 0x40) or 0
	end
	if trailAlpha > 0 then
		local cycle = frame(self) % 656
		local phase = cycle < 328 and cycle or cycle - 328
		local delta = trunc(phase * 127 / 328)
		local red = cycle < 328 and 255 - delta or 128 + delta
		local green = cycle < 328 and 128 + delta or 255 - delta
		local trailX, trailY = Core.polar(angle, 720)
		drawStyled(self, "stageback2", 3, trailX, trailY, angle,
			2, 1, false, "mul+add", trailAlpha, red, green, 255)
	end
	local spin = drawTimer(self) * 0xf3c
	draw(self, "enemy_s", 78, anchorX, anchorY, spin)
	draw(self, "enemy_s", 78, anchorX, anchorY, spin + 0x8000)
end

local function drawRingHalf(self, ringFrame, centerY, source, front,
		scale, radiusX, radiusY)
	for index = 0, 12 do
		local angle = Core.angle16(source * 0x14d + index * 0x13b1)
		local isFront = angle < 0x8000
		if isFront == front then
			local dx, dy = Core.ellipse(angle, radiusX or 75, radiusY or 24, 0)
			draw(self, "enemy_s", ringFrame, dx, centerY + dy, 0,
				scale or 1, scale or 1)
		end
	end
end

local function renderDetachedHead(self, exactLayer)
	local source = sourceFrame(self)
	local ringFrame = self.spawnType == 0x82 and 114 or 113
	if onLayer(exactLayer, 0x18) then
		drawRingHalf(self, ringFrame, 138, source, false)
	end
	if onLayer(exactLayer, 0x19) then
		drawRingHalf(self, ringFrame, 138, source, true)
		draw(self, "boss", (self.spawnType == 0x81 and 88 or 98) +
			floor(drawTimer(self) / 5) % 2, 0, 0, 0)
	end
end

local leftHeadFrames = {
	80, 81, 82, 83, 84, 85, 87, 86,
	87, 86, 85, 84, 83, 82, 80, 81,
}
local rightHeadFrames = {
	96, 95, 94, 93, 92, 90, 91, 90,
	91, 92, 93, 94, 95, 97, 96, 97,
}

local function renderPairedHead(self, exactLayer)
	if self._bmHidden then return end
	local root = self._bmRoot or self.parent
	local right = self.spawnType == 0x84
	local state = root and root.state or self.state or 0
	local timer = root and max(0, (root.helperTimer or 0) - 1) or drawTimer(self)
	local source = sourceFrame(self)
	local exitTimer = right and 240 or 220
	local drawAssembly = (state >= 10 and state < 70) or
		(state == 70 and timer < exitTimer)
	if state == 70 and timer >= exitTimer then return end

	local swing = trunc(sin(source * tau / 164) * (right and -1200 or 1200))
	local scaleThis = (not right and (state == 0x14 or state == 0x1e or state == 0x3b))
		or (right and (state == 0x28 or state == 0x32 or state == 0x3c))
	local assemblyScale = scaleThis and
		(1 - sin(timer * 182.0444444444445 * pi / 32768) * 0.3) or 1
	local ringOffsetY, baseOffsetY = 90, -120
	if state == 10 then
		if timer < 170 then ringOffsetY = 720
		elseif timer < 210 then
			ringOffsetY = 90 + sin((timer - 130) * 409.6 * pi / 32768) * 630
		end
		if timer < 200 then baseOffsetY = -720
		elseif timer < 240 then
			baseOffsetY = sin((timer - 160) * 409.6 * pi / 32768) * -600 - 120
		end
	end
	local baseY = baseOffsetY * assemblyScale
	local ringCenterY = ringOffsetY * assemblyScale
	local ringFrame = right and 114 or 113
	if drawAssembly then
		if onLayer(exactLayer, 0x18) then
			drawRingHalf(self, ringFrame, ringCenterY + 48 * assemblyScale,
				source, false, assemblyScale, 75 * assemblyScale, 24 * assemblyScale)
		end
		if onLayer(exactLayer, 0x19) then
			draw(self, "enemy_m", right and 144 or 143, 0,
				baseY + 100 * assemblyScale, 0, assemblyScale, assemblyScale)
			draw(self, "enemy_m", right and 142 or 141, 0, ringCenterY,
				0, assemblyScale, assemblyScale)
			local glowAngle = 0x4000 + swing
			local gx, gy = Core.polar(glowAngle, 114 * assemblyScale)
			drawStyled(self, "enemy_s", 81, gx, baseY + gy, glowAngle,
				2.2 * assemblyScale, 1.6 * assemblyScale, false,
				"mul+add", 0x60, right and 0 or 255,
				right and 255 or 0, 255)
			drawRingHalf(self, ringFrame, ringCenterY + 48 * assemblyScale,
				source, true, assemblyScale, 75 * assemblyScale, 24 * assemblyScale)
		end
	end

	local frames = right and rightHeadFrames or leftHeadFrames
	local bodyFrame = frames[floor(source / 5) % 16 + 1]
	if state == 10 and timer < 210 then
		bodyFrame = (right and 98 or 88) + floor(timer / 5) % 2
	end
	if onLayer(exactLayer, 0x19) then
		draw(self, "boss", bodyFrame, 0, 0, 0, assemblyScale, assemblyScale)
	end
	if drawAssembly and onLayer(exactLayer, 0x1a) then
		draw(self, "enemy_s", right and 116 or 115, 0, baseY, swing,
			assemblyScale, assemblyScale)
	end
end

local function renderFirstFormEmitter(self)
	local root = self._bmRoot or self.parent
	local timer = root and max(0, (root.helperTimer or 0) - 1) or drawTimer(self)
	local right = self.spawnType == 0x86
	local base = right and 130 or 126
	local overlay = 1
	if root and root.state == 1 then
		local cycle = timer % 2600
		local firstStart = right and 480 or 60
		if cycle >= firstStart and cycle < 600 then overlay = 3 end
		local secondStart = right and 2100 or 1950
		if cycle >= secondStart and cycle < 2450 then
			local tick = (cycle - secondStart) % 300
			if tick < 5 then overlay = 2
			elseif tick < 60 then overlay = 3
			elseif tick < 65 then overlay = 2
			elseif tick < 70 then overlay = 1 end
		end
	end
	local pulse = 1 + sin(frame(self) * tau / 82) * 0.05
	draw(self, "enemy_m", base, 0, 0, 0, pulse, 1)
	draw(self, "enemy_m", base + overlay, 0, 0, 0, pulse, 1)
end

local function renderFirstFormFixedPart(self)
	local id = self.spawnType
	local offsetX = self._bmOffsetX or self.originX or 0
	if id == 0x87 then
		draw(self, "enemy_m", (self.state or 0) == 0 and 138 or 140,
			0, 0, 0, 1, 1, offsetX >= 0)
		return
	end
	if id == 0x88 then
		local imageFrame = offsetX >= -100 and offsetX < 100 and 109 or 111
		draw(self, "enemy_s", imageFrame, 0, 0, 0, 1, 1,
			offsetX >= 100)
		return
	end

	local sourceAngle = self.sourceAngle16 or self.angle16 or 0
	local baseX, baseY = Core.polar(sourceAngle, -20)
	local glowX, glowY = Core.polar(sourceAngle, 100)
	local magenta = id == 0x89
	drawStyled(self, "enemy_s", 81, glowX, glowY, sourceAngle,
		2, 0.9, false, "mul+add", 0x40,
		magenta and 255 or 0, magenta and 0 or 255, 255)
	draw(self, "enemy_s", 100, baseX, baseY, sourceAngle)
end

local function renderStage07BossMinion(self)
	local timer = drawTimer(self)
	local id = self.spawnType
	local base = (id == 0x8c or id == 0x8e) and 105 or 101
	local scale = 1
	if (self.state or 0) == 0 then
		scale = 0.2 + sin(Core.clamp(timer, 0, 40) * pi / 80) * 0.8
	end
	local animation = {0, 1, 2, 1}
	local heading = self.secondaryAngle16 or self.angle16 or 0
	draw(self, "enemy_s", base + animation[floor(frame(self) / 3) % 4 + 1],
		0, 0, heading - 0x4000, scale, scale)

	local armX, armY = Core.polar(heading, -24 * scale)
	local firstArm = timer * 0xc80
	local secondArm = firstArm + 0x8000
	if id == 0x8c and (self.state or 0) == 1 and timer > 29 then
		local firstBase, secondBase = 0x8ae, -0x8ae
		if timer < 60 then
			local transition = trunc(sin((timer - 30) * pi / 60) * 14162)
			firstBase = 0x4000 - transition
			secondBase = -0x4000 + transition
		end
		local wobble = trunc(sin(timer * tau / 9) * 999)
		firstArm = heading + firstBase - 0x8000 + wobble
		secondArm = heading + secondBase - 0x8000 - wobble
	end
	draw(self, "enemy_s", base + 3, armX, armY,
		firstArm, scale, scale)
	draw(self, "enemy_s", base + 3, armX, armY,
		secondArm, scale, scale)
end

local function renderStage07OrbitNode(self)
	local timer = drawTimer(self)
	local parentType = self.parentSpawnType or
		(self.parent and self.parent.spawnType)
	local right = parentType == 0x84
	local imageFrame = right and 118 or 117
	local drawAngle, reverse
	if self.spawnType <= 0x92 then
		drawAngle = timer * -0x457
		reverse = false
	else
		drawAngle = timer * (right and 0x457 or -0x457)
		reverse = right
	end
	local scale = timer < 10 and sin(timer * pi / 20) or 1
	draw(self, "enemy_s", imageFrame, 0, 0, drawAngle,
		scale, scale, reverse)
end

local renderers = {
	[0x4f] = renderStage05Root,
	[0x50] = renderStage05LargeNode,
	[0x51] = renderStage05LargeNode,
	[0x52] = renderStage05LargeNode,
	[0x53] = renderStage05Type53,
	[0x54] = renderStage05Type54,
	[0x55] = renderStage05Type55,
	[0x56] = renderStage05Type56,
	[0x13c] = renderStage05Boss,
	[0x143] = renderStage06Midboss,
	[0x61] = renderStage06MidbossNode,
	[0x62] = renderStage06MidbossNode,
	[0x63] = renderStage06MidbossNode,
	[0x13d] = renderStage06Boss,
	[0x64] = renderStage06BossNode,
	[0x65] = renderStage06BossNode,
	[0x66] = renderStage06BossNode,
	[0x67] = renderStage06BossNode,
	[0x68] = renderStage06BossNode,
	[0x69] = renderStage06BossNode,
	[0x6a] = renderStage06BossNode,
	[0x6b] = renderStage06BossNode,
	[0x6c] = renderStage06BossNode,
	[0x6d] = renderStage06BossNode,
	[0x6e] = renderStage06BossNode,
	[0x6f] = renderStage06BossNode,
	[0x77] = renderStage07Gate,
	[0x78] = renderStage07GateChild,
	[0x144] = renderStage07Midboss,
	[0x145] = renderStage07Midboss,
	[0x79] = renderStage07MidbossNode,
	[0x7a] = renderStage07MidbossNode,
	[0x7b] = renderStage07MidbossNode,
	[0x7c] = renderStage07MidbossNode,
	[0x7d] = renderStage07MidbossNode,
	[0x7e] = renderStage07MidbossNode,
	[0x7f] = renderStage07MidbossNode,
	[0x13e] = renderStage07BossRoot,
	[0x80] = renderStage07IntroTrail,
	[0x81] = renderDetachedHead,
	[0x82] = renderDetachedHead,
	[0x83] = renderPairedHead,
	[0x84] = renderPairedHead,
	[0x85] = renderFirstFormEmitter,
	[0x86] = renderFirstFormEmitter,
	[0x87] = renderFirstFormFixedPart,
	[0x88] = renderFirstFormFixedPart,
	[0x89] = renderFirstFormFixedPart,
	[0x8a] = renderFirstFormFixedPart,
	[0x8b] = renderStage07BossMinion,
	[0x8c] = renderStage07BossMinion,
	[0x8d] = renderStage07BossMinion,
	[0x8e] = renderStage07BossMinion,
	[0x8f] = renderStage07OrbitNode,
	[0x90] = renderStage07OrbitNode,
	[0x91] = renderStage07OrbitNode,
	[0x92] = renderStage07OrbitNode,
	[0x93] = renderStage07OrbitNode,
	[0x94] = renderStage07OrbitNode,
}

local primaryLayers = {
	[0x4f] = 0x20,
	[0x50] = 0x1e, [0x51] = 0x1e, [0x52] = 0x1e,
	[0x53] = 0x23, [0x54] = 0x23, [0x55] = 0x23, [0x56] = 0x23,
	[0x13c] = 0x1e,
	[0x143] = 0x1e,
	[0x61] = 0x1e, [0x62] = 0x1e, [0x63] = 0x1e,
	[0x13d] = 0x1e,
	[0x64] = 0x21, [0x65] = 0x1f,
	[0x66] = 0x23, [0x67] = 0x23, [0x68] = 0x23,
	[0x69] = 0x23, [0x6a] = 0x23,
	[0x6b] = 0x23, [0x6c] = 0x23, [0x6d] = 0x23,
	[0x6e] = 0x23, [0x6f] = 0x23,
	[0x77] = 0x1c, [0x78] = 0x1e,
	[0x144] = 0x19, [0x145] = 0x19,
	[0x79] = 0x23,
	[0x7a] = 0x1b, [0x7b] = 0x1b,
	[0x7c] = 0x1c, [0x7d] = 0x1c,
	[0x7e] = 0x23, [0x7f] = 0x23,
	[0x13e] = 0x19,
	[0x80] = 0x0f,
	[0x81] = 0x19, [0x82] = 0x19,
	[0x83] = 0x19, [0x84] = 0x19,
	[0x85] = 0x1d, [0x86] = 0x1d,
	[0x87] = 0x1b, [0x88] = 0x1b,
	[0x89] = 0x1c, [0x8a] = 0x1c,
	[0x8b] = 0x23, [0x8c] = 0x23,
	[0x8d] = 0x23, [0x8e] = 0x23,
	[0x8f] = 0x23, [0x90] = 0x23,
	[0x91] = 0x23, [0x92] = 0x23,
}

local extraLayers = {
	[0x13c] = {0x17, 0x18, 0x1a, 0x1b, 0x1d, 0x20, 0x21, 0x22, 0x23, 0x24},
	[0x13d] = {0x20},
	[0x77] = {0x17, 0x1d, 0x32},
	[0x144] = {0x17, 0x1a, 0x1d},
	[0x145] = {0x17, 0x1a, 0x1d},
	[0x13e] = {0x1e},
	[0x81] = {0x18}, [0x82] = {0x18},
	[0x83] = {0x18, 0x1a}, [0x84] = {0x18, 0x1a},
}

local VisualCatalog = {}
VisualCatalog.__index = VisualCatalog

function VisualCatalog.new(entityRenderers, entityPrimaryLayers,
		entityExtraLayers)
	return setmetatable({
		renderers = entityRenderers,
		primaryLayers = entityPrimaryLayers,
		extraLayers = entityExtraLayers,
	}, VisualCatalog)
end

function VisualCatalog:primaryLayer(entity)
	if entity.spawnType == 0x93 or entity.spawnType == 0x94 then
		local parentType = entity.parentSpawnType or
			(entity.parent and entity.parent.spawnType)
		return parentType == 0x84 and 0x23 or 0x22
	end
	return self.primaryLayers[entity.spawnType]
end

function VisualCatalog:extraLayersFor(entity)
	return self.extraLayers[entity.spawnType]
end

function VisualCatalog:render(entity, exactLayer)
	local renderer = self.renderers[entity.spawnType]
	if not renderer then return false end
	if entity._bmHidden and entity.spawnType ~= 0x13e then return true end
	renderer(entity, exactLayer)
	return true
end

local catalog = VisualCatalog.new(renderers, primaryLayers, extraLayers)

function M.primaryLayer(self)
	return catalog:primaryLayer(self)
end

function M.extraLayers(self)
	return catalog:extraLayersFor(self)
end

function M.render(self, exactLayer)
	return catalog:render(self, exactLayer)
end

return M
