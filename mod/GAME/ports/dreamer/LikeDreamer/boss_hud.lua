-- Original fixed-screen boss gauge, name, phase stock and countdown display.

LikeDreamer = LikeDreamer or {}

local M = {}
LikeDreamer.BossHud = M

local floor = math.floor
local max = math.max
local min = math.min
local sin = math.sin
local cos = math.cos
local pi = math.pi

local ROOT_TYPES = {
	[0x138] = true, [0x139] = true, [0x13a] = true, [0x13b] = true,
	[0x13c] = true, [0x13d] = true, [0x13e] = true, [0x13f] = true,
	[0x140] = true, [0x141] = true, [0x143] = true, [0x144] = true,
	[0x145] = true, [0x146] = true, [0x147] = true, [0x148] = true,
	[0x149] = true, [0x14a] = true, [0x14b] = true, [0x14c] = true,
}

local EARLY_NAME = {
	[0x138] = 0, [0x139] = 1, [0x13a] = 2, [0x13b] = 3,
}

local MIDDLE_TOTAL = {
	[0x13c] = 6, [0x13d] = 5, [0x13e] = 5,
}

local MIDDLE_NAME = {
	[0x13c] = 4, [0x13d] = 6, [0x143] = 5,
	[0x144] = 7, [0x145] = 8,
}

local MIDDLE_FINAL_STATE = {
	[0x13c] = 14, [0x13d] = 10, [0x13e] = 70,
	[0x143] = 5, [0x144] = 3, [0x145] = 3,
}

local STAGE8_TRANSITION_BREAKS = {
	[10] = 5, [20] = 4, [30] = 3, [40] = 2, [50] = 1,
}

local STAGE8_COMBAT_BREAKS = {
	[1] = 6, [2] = 6, [11] = 5, [21] = 4,
	[31] = 3, [41] = 2, [51] = 1, [52] = 1,
}

local STAGE9_TRANSITION = {
	[5] = true, [10] = true, [0x3c] = true, [0xa0] = true,
}

local BREAK_MODE_BY_REMAINING = {
	[2] = 3, [3] = 3, [4] = 3, [5] = 2,
	[6] = 3, [7] = 2, [8] = 3, [9] = 2,
	[10] = 3, [11] = 2, [12] = 3, [13] = 2,
	[14] = 3, [15] = 2, [16] = 3,
}

local SnapshotBuilder = {}
SnapshotBuilder.__index = SnapshotBuilder

function SnapshotBuilder.new()
	return setmetatable({}, SnapshotBuilder)
end

local BossHudRenderer = {}
BossHudRenderer.__index = BossHudRenderer

function BossHudRenderer.new(snapshotBuilder)
	return setmetatable({snapshotBuilder = snapshotBuilder}, BossHudRenderer)
end

local BossHudController = {}
BossHudController.__index = BossHudController

function BossHudController.new(rt, renderer)
	return setmetatable({runtime = rt, renderer = renderer}, BossHudController)
end

M.SnapshotBuilder = SnapshotBuilder
M.Renderer = BossHudRenderer
M.Controller = BossHudController

local function clamp(value, low, high)
	if value < low then return low end
	if value > high then return high end
	return value
end

local function isActiveBoss(value)
	if value == nil then return false end
	if lstg and type(lstg.IsValid) == "function" then
		local ok, valid = pcall(lstg.IsValid, value)
		if ok and not valid then return false end
	end
	local ok, typeId, active, status, removeRequested, deadRequested =
		pcall(function()
			return value.spawnType, value.active, value.status,
				value.removeRequested, value.deadRequested
		end)
	return ok and ROOT_TYPES[typeId] and active ~= false and
		status ~= "del" and status ~= "kill" and
		not removeRequested and not deadRequested
end

local function findBoss(rt)
	if type(rt) ~= "table" then return nil end
	if isActiveBoss(rt.boss) then return rt.boss end
	local result
	for _, enemy in pairs(rt.enemiesById or {}) do
		if isActiveBoss(enemy) and (not result or
			(enemy.entityId or 0) > (result.entityId or 0)) then
			result = enemy
		end
	end
	return result
end

local function earlySnapshot(boss)
	local mode = boss._bePhaseMode
	if mode == nil then
		mode = boss.state == 0 and 0 or (boss.targetable and 1 or -1)
	end
	return mode, max(1, boss.maxhp or boss.maxHp or 1),
		max(0, boss.countdown or 0), max(0, boss._beBreaks or 0),
		EARLY_NAME[boss.spawnType]
end

local function middleName(boss)
	if boss.spawnType ~= 0x13e then return MIDDLE_NAME[boss.spawnType] end
	local state = boss.state or 0
	if (state >= 0x15 and state <= 0x27) or state == 0x3b then return 7 end
	if (state >= 0x29 and state <= 0x3a) or state == 0x3c then return 8 end
	return 9
end

local function middleSnapshot(boss)
	local typeId = boss.spawnType
	local state = boss.state or 0
	local finalState = MIDDLE_FINAL_STATE[typeId]
	local mode
	if state == 0 then
		mode = 0
	elseif boss._bmCombat then
		mode = 1
	elseif state == finalState then
		mode = -1
	else
		mode = 2
	end

	local breaks
	if typeId == 0x13e then
		breaks = boss._bmBreaks or 5
	elseif MIDDLE_TOTAL[typeId] then
		local phase = max(0, boss.phaseIndex or 0)
		local consumed = state ~= 0 and not boss._bmCombat and 1 or 0
		breaks = MIDDLE_TOTAL[typeId] - phase - consumed
	else
		breaks = (state == finalState) and 0 or 1
	end
	return mode, max(1, boss.maxhp or boss.maxHp or 1),
		max(0, boss.countdown or 0), max(0, breaks), middleName(boss)
end

local function stage8Snapshot(boss)
	local state = boss.state or 0
	local timer = boss.helperTimer or 0
	if state == 0 then return 0, 6 end
	if state == 70 or state == 99 then return -1, 0 end
	if state == 60 then
		if timer < 300 then return -1, 0 end
		return 0, 1
	end
	if state == 61 then return 0, 1 end
	if state >= 62 and state <= 67 then return 1, 1 end
	if STAGE8_TRANSITION_BREAKS[state] then
		return 2, STAGE8_TRANSITION_BREAKS[state]
	end
	return 1, STAGE8_COMBAT_BREAKS[state] or 1
end

local function stage9Snapshot(boss)
	local state = boss.state or 0
	local phase = max(0, boss._blPhase or 0)
	if state == 0 then return 0, 4 end
	if state == 99 or state == 199 then return -1, 0 end
	if STAGE9_TRANSITION[state] then return 2, max(0, 4 - phase) end
	return 1, max(0, 5 - phase)
end

local function stage10Snapshot(boss)
	local state = boss.state or 0
	local timer = boss.helperTimer or 0
	local phase = max(0, boss._blPhase or 0)
	if state == 0 then return 0, 16 end
	if state == 200 then return -1, 0 end
	if state >= 10 and state <= 150 and state % 10 == 0 then
		local remaining = max(0, 16 - phase)
		return BREAK_MODE_BY_REMAINING[remaining + 1] or 3, remaining
	end
	local mode = 1
	if phase >= 2 and phase <= 12 and phase % 2 == 0 and timer < 220 then
		mode = 2
	elseif phase == 14 and timer < 280 then
		mode = 2
	elseif phase == 15 and timer < 310 then
		mode = 2
	end
	return mode, max(0, 17 - phase)
end

local function sceneSnapshot(boss)
	local state = boss.state or 0
	if state == 0 then return nil end
	if state == 1 then return 0, 3 end
	if state == 2 then return 1, 3 end
	if state == 3 then return 2, 2 end
	if state == 4 then return 1, 2 end
	if state == 5 then return 2, 1 end
	if state == 6 then return 1, 1 end
	return -1, 0
end

local function lateName(boss, rt)
	local typeId = boss.spawnType
	if typeId == 0x13f then return 10 end
	if typeId == 0x140 then
		if (boss.state or 0) > 10 then
			return (rt.difficulty or 1) > 3 and 18 or 17
		end
		return 10
	end
	if typeId == 0x141 or typeId == 0x14c then return 19 end
	if typeId >= 0x146 and typeId <= 0x14b then return 11 + typeId - 0x146 end
	return 5
end

local function lateSnapshot(boss, rt)
	local typeId = boss.spawnType
	local mode, breaks
	if typeId == 0x13f then
		mode, breaks = stage8Snapshot(boss)
	elseif typeId == 0x140 then
		mode, breaks = stage9Snapshot(boss)
	elseif typeId == 0x141 then
		mode, breaks = stage10Snapshot(boss)
	elseif typeId == 0x14c then
		mode, breaks = sceneSnapshot(boss)
		if mode == nil then return nil end
	else
		local state = boss.state or 0
		mode = state == 0 and 0 or (boss.targetable and 1 or -1)
		breaks = mode == -1 and 0 or 1
	end
	return mode, max(1, boss.maxhp or boss.maxHp or 1),
		max(0, boss.countdown or 0), breaks, lateName(boss, rt)
end

function SnapshotBuilder:snapshot(rt)
	rt = rt or LikeDreamer.runtime
	local boss = findBoss(rt)
	if not boss then return nil end
	local typeId = boss.spawnType
	local mode, maxHp, countdown, breaks, nameIndex
	if typeId >= 0x138 and typeId <= 0x13b then
		mode, maxHp, countdown, breaks, nameIndex = earlySnapshot(boss)
	elseif typeId == 0x13c or typeId == 0x13d or typeId == 0x13e or
			typeId == 0x143 or typeId == 0x144 or typeId == 0x145 then
		mode, maxHp, countdown, breaks, nameIndex = middleSnapshot(boss)
	else
		mode, maxHp, countdown, breaks, nameIndex = lateSnapshot(boss, rt)
	end
	if mode == nil then return nil end
	return {
		boss = boss,
		phaseMode = mode,
		maxHp = maxHp,
		countdown = countdown,
		breaksRemaining = breaks,
		nameIndex = nameIndex,
		timer = boss.helperTimer or rt.bossTimer or 0,
		hp = boss.hp or 0,
	}
end

local snapshotBuilder = SnapshotBuilder.new()
local renderer = BossHudRenderer.new(snapshotBuilder)

function M.snapshot(rt)
	return snapshotBuilder:snapshot(rt)
end

local function viewport()
	local box = LikeDreamer.Viewport.capture()
	local inset = AndroidPortrait and AndroidPortrait.enabled() and AndroidPortrait.TOP_INSET or 0
	return box.origin+600*box.scale, math.min(box.ceiling,box.top-inset), box.scale, box.scale
end

local function imageExists(name)
	return not lstg.CheckRes or lstg.CheckRes(2, name)
end

local function setImage(name, blend, alpha, red, green, blue)
	SetImageState(name, blend or "", Color(
		floor(clamp(alpha or 255, 0, 255)),
		floor(clamp(red or 255, 0, 255)),
		floor(clamp(green or 255, 0, 255)),
		floor(clamp(blue or 255, 0, 255))))
end

local function resetImage(name)
	SetImageState(name, "", Color(255, 255, 255, 255))
end

local function mapPoint(x, y, right, top, sx, sy)
	return right + (x - 940) * sx, top - y * sy
end

local function drawTopLeft(name, x, y, width, height, scaleX, scaleY,
		alpha, red, green, blue, blend, right, top, sx, sy)
	if not imageExists(name) or scaleX == 0 or scaleY == 0 then return end
	local cx, cy = mapPoint(x + width * scaleX * 0.5,
		y + height * scaleY * 0.5, right, top, sx, sy)
	setImage(name, blend, alpha, red, green, blue)
	lstg.Render(name, cx, cy, 0, scaleX * sx, scaleY * sy)
	resetImage(name)
end

local function drawCentered(name, x, y, scale, alpha, red, green, blue,
		blend, right, top, sx, sy)
	if not imageExists(name) then return end
	local cx, cy = mapPoint(x, y, right, top, sx, sy)
	setImage(name, blend, alpha, red, green, blue)
	lstg.Render(name, cx, cy, 0, scale * sx, scale * sy)
	resetImage(name)
end

local function renderCenteredXY(name, x, y, scaleX, scaleY, angle,
		right, top, sx, sy)
	local cx, cy = mapPoint(x, y, right, top, sx, sy)
	lstg.Render(name, cx, cy, angle or 0, scaleX * sx, scaleY * sy)
end

local function drawCenteredXY(name, x, y, scaleX, scaleY, angle,
		alpha, red, green, blue, blend, right, top, sx, sy)
	if not imageExists(name) or scaleX == 0 or scaleY == 0 or alpha <= 0 then
		return
	end
	setImage(name, blend, alpha, red, green, blue)
	renderCenteredXY(name, x, y, scaleX, scaleY, angle,
		right, top, sx, sy)
	resetImage(name)
end

local function sineEaseIn(frame, duration)
	if duration <= 0 then return 1 end
	return sin(clamp(frame / duration, 0, 1) * pi * 0.5)
end

local function sineEaseOut(frame, duration)
	if duration <= 0 then return 0 end
	return cos(clamp(frame / duration, 0, 1) * pi * 0.5)
end

local function presentationScale(timer)
	if timer < 76 then return sineEaseIn(timer - 60, 16) end
	if timer >= 224 then return sineEaseOut(timer - 224, 16) end
	return 1
end

local function drawStateAndTimer(boss)
	local state = boss._beDrawState
	if state == nil then state = boss.state or 0 end
	local timer = boss._beDrawTimer
	if timer == nil then timer = boss.helperTimer or 0 end
	return state, timer
end

local function renderTextPresentation(snapshot, iconIndex,
		right, top, sx, sy)
	local state, timer = drawStateAndTimer(snapshot.boss)
	local expectedState = snapshot.boss.spawnType == 0x13b and 11 or 8
	if state ~= expectedState or timer < 60 or timer >= 240 then return end
	local scale = presentationScale(timer)
	drawCenteredXY("ld_text_box_2", 640, 60, 1, scale, 0,
		255, 255, 255, 255, "", right, top, sx, sy)
	drawCenteredXY("ld_text_icon_" .. tostring(iconIndex + 1),
		390, 60, scale, scale, 0,
		255, 255, 255, 255, "", right, top, sx, sy)
end

local function approachPrefix(rt)
	local language = tonumber(rt and
		(rt.language or rt.languageIndex or rt.language_index))
	if language == nil then
		local locale = rawget(_G, "setting") and tostring(setting.lang or "") or ""
		locale = string.lower(locale)
		if locale == "zh_cn" or locale == "zh_hans" then
			language = 2
		elseif locale == "zh_tw" or locale == "zh_hk" or
			locale == "zh_hant" then
			language = 3
		else
			language = 0
		end
	end
	if language == 2 then return "ld_boss_approach_1_ch1_" end
	if language == 3 then return "ld_boss_approach_1_ch2_" end
	return "ld_boss_approach_1_"
end

local function fixedAngleToDegrees(angle)
	return -(angle % 0x10000) * 360 / 0x10000
end

local function renderStage04Intro(snapshot, rt, right, top, sx, sy)
	local boss = snapshot.boss
	local state, timer = drawStateAndTimer(boss)
	if state ~= 2 or timer < 220 or timer >= 380 then return end
	local age = timer - 220
	local function envelopeAlpha(start)
		if age < start then return 0 end
		if age < start + 20 then
			return floor(sin((age - start) * pi / 40) * 255)
		end
		if age < 120 then return 255 end
		return floor(sin((age - 80) * pi / 80) * 255)
	end
	local function envelopeScale(start)
		if age < start then return 3 end
		if age < start + 20 then
			return 3 - 2 * sin((age - start) * pi / 40)
		end
		return 1
	end
	local function backgroundAlpha(maximum)
		if age < 20 then return floor(sin(age * pi / 40) * maximum) end
		if age < 120 then return maximum end
		return floor(sin((age - 80) * pi / 80) * maximum)
	end

	local backdropAlpha = backgroundAlpha(128)
	drawCenteredXY("ld_white_back", 640, 360, 1, 1, 0,
		backdropAlpha, 0, 0, 0, "", right, top, sx, sy)

	local prefix = approachPrefix(rt)
	local gridAlpha = backgroundAlpha(40)
	local gridImage = prefix .. "1"
	if gridAlpha > 0 and imageExists(gridImage) then
		local gridAngleA = 5.862874571298915
		local gridAngleB = 4.904136578870390
		local sourceFrame = boss._beSourceFrame
		if sourceFrame == nil then sourceFrame = rt.frame or 0 end
		local phase = (sourceFrame % 210) * 2
		setImage(gridImage, "", gridAlpha, 255, 255, 255)
		for row = 0, 6 do
			local rowOffset = phase + row * 420
			for column = 0, 31 do
				local columnOffset = column * 60
				local x = columnOffset * cos(gridAngleB) +
					rowOffset * cos(gridAngleA) - 1000
				local y = columnOffset * sin(gridAngleB) +
					rowOffset * sin(gridAngleA) + 1440
				renderCenteredXY(gridImage, x, y, 1, 1,
					fixedAngleToDegrees(0xeee0), right, top, sx, sy)
			end
		end
		resetImage(gridImage)
	end

	local standAlpha = envelopeAlpha(20)
	local standScale = envelopeScale(20)
	drawCenteredXY("ld_stage04_stand_33", 660, 360,
		standScale, standScale, 0,
		standAlpha, 255, 255, 255, "", right, top, sx, sy)

	local titleAlpha = envelopeAlpha(44)
	if titleAlpha > 0 then
		local titleScale = envelopeScale(44)
		local titleAngle = fixedAngleToDegrees(0xf830)
		drawCenteredXY(prefix .. "2", 650, 450,
			titleScale, titleScale, titleAngle,
			titleAlpha, 255, 255, 255, "", right, top, sx, sy)
		drawCenteredXY(prefix .. "6", 720, 500,
			titleScale, titleScale, titleAngle,
			titleAlpha, 255, 255, 255, "", right, top, sx, sy)
	end
end

local function renderStagePresentation(snapshot, rt, right, top, sx, sy)
	local typeId = snapshot.boss.spawnType
	if typeId == 0x139 then
		renderTextPresentation(snapshot, 4, right, top, sx, sy)
	elseif typeId == 0x13a then
		renderTextPresentation(snapshot, 5, right, top, sx, sy)
	elseif typeId == 0x13b then
		renderStage04Intro(snapshot, rt, right, top, sx, sy)
		renderTextPresentation(snapshot, 6, right, top, sx, sy)
	end
end

local function playerAlpha()
	local playerObject = rawget(_G, "player")
	local y = playerObject and playerObject.ldY or 360
	if y < 150 then return 55 end
	if y < 200 then return floor(y - 150) * 4 + 55 end
	return 255
end

local function gaugeState(snapshot)
	local mode = snapshot.phaseMode
	local timer = snapshot.timer
	local baseAlpha = playerAlpha()
	local overlayAlpha = 0
	local red, green, blue = 64, 64, 64
	local fill = 0
	if mode == 0 or mode == 6 then
		baseAlpha = timer < 0 and 0 or
			(timer < 8 and floor(sin(timer * pi / 16) * 255) or 255)
		fill = timer >= 50 and 1 or max(0, timer) * 0.02
		if mode == 0 then red, green, blue = 0, 255, 255 end
	elseif mode == 1 then
		fill = snapshot.maxHp > 0 and
			clamp(snapshot.hp / snapshot.maxHp, 0, 1) or 0
		if fill <= 0.5 then
			red, green, blue = floor(255 - fill * 511), floor(fill * 511), 0
		else
			red, green, blue = 0, 255, floor((fill - 0.5) * 511)
		end
	elseif mode == 2 then
		fill = timer < 40 and 0 or (timer < 70 and (timer - 40) / 30 or 1)
		red, green, blue = 0, 255, 255
	elseif mode == 3 then
		fill = 0
	elseif mode == 4 then
		fill = timer < 40 and 0 or (timer < 70 and (timer - 40) / 30 or 1)
	elseif mode == 5 then
		fill = snapshot.maxHp > 0 and
			clamp(snapshot.countdown / snapshot.maxHp, 0, 1) or 0
	elseif mode == -1 then
		overlayAlpha = timer >= 0 and timer < 64 and
			floor(sin(timer * pi / 64) * 255) or 0
		if timer >= 32 then baseAlpha = 0 end
	end
	return clamp(fill, 0, 1), clamp(baseAlpha, 0, 255),
		clamp(overlayAlpha, 0, 255), red, green, blue
end

local function drawBossHud(snapshot, rt)
	local right, top, sx, sy = viewport()
	local fill, baseAlpha, overlayAlpha, red, green, blue = gaugeState(snapshot)
	renderStagePresentation(snapshot, rt, right, top, sx, sy)
	for _, value in ipairs({{1, 378}, {2, 402}}) do
		local image = "ld_boss_hud_gauge_" .. value[1]
		drawTopLeft(image, value[2], 30, 500, 30, 1, 1,
			baseAlpha, 255, 255, 255, "", right, top, sx, sy)
		if overlayAlpha > 0 then
			drawTopLeft(image, value[2], 30, 500, 30, 1, 1,
				overlayAlpha, 255, 255, 255, "mul+add", right, top, sx, sy)
		end
	end
	drawTopLeft("ld_boss_hud_gauge_3", 390, 30, 500, 30, fill, 1,
		baseAlpha, 255, 255, 255, "", right, top, sx, sy)
	drawTopLeft("ld_boss_hud_gauge_4", 390, 30, 500, 30, fill, 1,
		baseAlpha, red, green, blue, "mul+add", right, top, sx, sy)

	local name = "ld_boss_hud_name_" .. tostring(snapshot.nameIndex + 1)
	drawTopLeft(name, 372, 0, 400, 30, 1, 1, baseAlpha,
		255, 255, 255, "", right, top, sx, sy)

	for i = 0, max(0, snapshot.breaksRemaining) - 1 do
		local alpha, scale = baseAlpha, 1
		if snapshot.phaseMode == 0 then
			local start = i * 6
			if snapshot.timer < start then
				alpha = 0
			elseif snapshot.timer < start + 20 then
				local entrance = sin((snapshot.timer - start) * pi / 40)
				alpha = floor(entrance * 255)
				scale = 3 - entrance * 2
			end
		end
		if alpha > 0 then
			drawCentered("ld_boss_hud_gauge_8", 400 + i * 20, 74,
				scale, alpha, 255, 255, 255, "", right, top, sx, sy)
		end
	end

	if snapshot.phaseMode == 1 or snapshot.phaseMode == 5 then
		local countdown = max(0, snapshot.countdown)
		local display = min(countdown, 5999)
		local frames = display % 60
		local seconds = floor(display / 60)
		local tint = min(countdown, 255)
		local digits = {
			{floor(seconds / 10), 854, 16, 1},
			{seconds % 10, 870, 16, 1},
			{floor(frames / 10), 885, 20, 0.6},
			{frames % 10, 895, 20, 0.6},
		}
		for _, digit in ipairs(digits) do
			drawCentered("ld_num_s_" .. tostring(digit[1] + 1),
				digit[2], digit[3], digit[4], baseAlpha,
				255, tint, tint, "", right, top, sx, sy)
		end
	end
end

function BossHudRenderer:render(rt)
	rt = rt or LikeDreamer.runtime
	if rt and (rt.gameOverPresentation or rt.gameOver) then return false end
	local snapshot = self.snapshotBuilder:snapshot(rt)
	if not snapshot then return false end
	LikeDreamer.Viewport.draw(drawBossHud, snapshot, rt)
	return true
end

function M.render(rt)
	return renderer:render(rt)
end

function BossHudController:frame(proxy)
	if not self.runtime or self.runtime.finished or
			LikeDreamer.runtime ~= self.runtime then
		Del(proxy)
	end
end

function BossHudController:render()
	return self.renderer:render(self.runtime)
end

local hudClass = Class(object)
M.Class = hudClass

function hudClass:init(rt)
	self.runtime = rt
	self.controller = BossHudController.new(rt, renderer)
	self.group = GROUP_GHOST
	self.layer = (rawget(_G, "LAYER_TOP") or 1000) + 96
	self.bound = false
	self.colli = false
end

function hudClass:frame()
	self.controller:frame(self)
end

function hudClass:render()
	self.controller:render()
end

function M.create(rt)
	rt = rt or LikeDreamer.runtime
	if type(rt) ~= "table" then return nil end
	local current = rt._bossHudObject
	if current and current.status ~= "del" then return current end
	current = New(hudClass, rt)
	rt._bossHudObject = current
	return current
end

return M
