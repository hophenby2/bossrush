-- Like Dreamer's fixed left/right gameplay sidebars.
-- Original draw coordinates span 1280x720 and are y-down.  THEIS reserves
-- world.scrl pixels on the left and screen.width-world.scrr on the right, so
-- the 0..340 and 940..1280 side regions receive independent transforms.

LikeDreamer = LikeDreamer or {}

local Core = assert(LikeDreamer.Core, "LikeDreamer.Core is required")
local M = {}
LikeDreamer.SideHud = M

local floor = math.floor
local max = math.max
local min = math.min
local sin = math.sin
local pi = math.pi

local PANEL_WIDTH = 340
local RIGHT_REGION_WIDTH = 340
local PANEL_HEIGHT = 720
local RIGHT_ORIGIN = 940
local LIFE_CAP = 9
local EXTEND_THRESHOLDS = {
	{4000000, 16000000, 80000000, 400000000, 2000000000},
	{6000000, 24000000, 120000000, 600000000, 3000000000},
	{8000000, 32000000, 160000000, 800000000, 4000000000},
	{10000000, 40000000, 200000000, 1000000000, 5000000000},
	{10000000, 40000000, 200000000, 1000000000, 5000000000},
}

local READY_COLORS = {
	{255, 120, 120}, {255, 200, 110}, {255, 255, 120},
	{120, 255, 120}, {120, 255, 255}, {120, 120, 255},
	{220, 120, 255},
}

local SideHudLayout = {}
SideHudLayout.__index = SideHudLayout

local SideHudRenderer = {}
SideHudRenderer.__index = SideHudRenderer

function SideHudRenderer.new()
	return setmetatable({}, SideHudRenderer)
end

local SideHudController = {}
SideHudController.__index = SideHudController

function SideHudController.new(rt, renderer)
	return setmetatable({
		runtime = assert(rt, "LikeDreamer SideHud requires a runtime"),
		renderer = renderer,
		measuredFps = 60,
		fpsFrames = 0,
		fpsStart = os.clock(),
	}, SideHudController)
end

function SideHudController:attachSideProxy(proxy)
	self.sideProxy = proxy
	proxy.measuredFps = self.measuredFps
	proxy.fpsFrames = self.fpsFrames
	proxy.fpsStart = self.fpsStart
end

function SideHudController:pullSideProxy()
	local proxy = self.sideProxy
	if not proxy then return end
	self.measuredFps = proxy.measuredFps or self.measuredFps
	self.fpsFrames = proxy.fpsFrames or self.fpsFrames
	self.fpsStart = proxy.fpsStart or self.fpsStart
end

function SideHudController:pushSideProxy()
	local proxy = self.sideProxy
	if not proxy then return end
	proxy.measuredFps = self.measuredFps
	proxy.fpsFrames = self.fpsFrames
	proxy.fpsStart = self.fpsStart
	proxy.leftPanel = self.leftPanel
	proxy.rightPanel = self.rightPanel
end

M.Layout = SideHudLayout
M.Renderer = SideHudRenderer
M.Controller = SideHudController

local function clamp(value, lower, upper)
	return min(upper, max(lower, value))
end

local function hasImage(name)
	return not lstg.CheckRes or lstg.CheckRes(2, name)
end

local function setImageColor(name, alpha, red, green, blue, blend)
	if SetImageState then
		SetImageState(name, blend or "", Color(alpha or 255,
			red or 255, green or 255, blue or 255))
	end
end

local function resetImageColor(name)
	if SetImageState then
		SetImageState(name, "", Color(255, 255, 255, 255))
	end
end

function SideHudLayout.capture()
    return ui.NativeHUD.dreamerPanels()
end

local function point(panel, originalX, originalY)
	return panel.left + (originalX - panel.origin) * panel.sx,
		panel.top - originalY * panel.sy
end

local Render=lstg.Render
local function drawCentered(panel, image, originalX, originalY,
		scaleX, scaleY, angle, alpha, red, green, blue, blend)
	if panel.sx <= 0 or not hasImage(image) then return end
	local x, y = point(panel, originalX, originalY)
	setImageColor(image, alpha, red, green, blue, blend)
	Render(image, x, y, angle or 0,
		panel.sx * (scaleX or 1), panel.sy * (scaleY or scaleX or 1))
	resetImageColor(image)
end

local function drawTopLeft(panel, image, originalX, originalY, width, height,
		scaleX, scaleY, alpha, red, green, blue, blend)
	scaleX = scaleX or 1
	scaleY = scaleY or scaleX
	local centerX = originalX + width * scaleX * 0.5
	local centerY = originalY + height * scaleY * 0.5
	drawCentered(panel, image, centerX, centerY, scaleX, scaleY, 0,
		alpha, red, green, blue, blend)
end

local function stateImage(frame)
	return "ld_state_" .. tostring(frame + 1)
end

local function numberImage(frame)
	return "ld_num_s_" .. tostring(frame + 1)
end

local function drawState(panel, frame, x, y, red, green, blue, alpha, scale)
	drawCentered(panel, stateImage(frame), x, y, scale or 1, scale or 1, 0,
		alpha or 255, red or 255, green or 255, blue or 255)
end

local function drawNumber(panel, anchorX, centerY, value, maxDigits,
		centered, separators, scale, configDigits)
	value = max(0, floor(tonumber(value) or 0))
	maxDigits = clamp(maxDigits or 12, 1, 12)
	scale = scale or 1
	local maximum = 1
	for _ = 1, maxDigits do maximum = maximum * 10 end
	maximum = maximum - 1
	local overflow = value > maximum
	local remaining = min(value, maximum)
	local digits = {}
	repeat
		digits[#digits + 1] = remaining % 10
		remaining = floor(remaining / 10)
	until remaining == 0 or #digits == maxDigits

	local step = (configDigits and 25 or 16) * scale
	local x = anchorX
	if centered then x = x + (#digits - 1) * step * 0.5 end
	local function drawDigit(frame, px, digitScale)
		local image = configDigits and
			("ld_config_number_" .. tostring(frame + 1)) or numberImage(frame)
		drawCentered(panel, image, px, centerY, digitScale, digitScale)
	end
	if overflow and separators and not configDigits then
		drawDigit(11, x + step, scale)
	end
	for index, digit in ipairs(digits) do
		drawDigit(digit, x, scale)
		x = x - step
		if separators and not configDigits and index % 3 == 0 and index < #digits then
			x = x - 5 * scale
			drawDigit(10, x + step, scale)
		end
	end
end

local function scoreValue()
	local systemTable = rawget(_G, "system")
	if systemTable and type(systemTable.getScore) == "function" then
		return max(0, tonumber(systemTable.getScore()) or 0)
	end
	return max(0, tonumber(lstg.var and lstg.var.score) or 0)
end

local function bestScoreValue(rt)
	local tmp = lstg.tmpvar or {}
	local var = lstg.var or {}
	return max(scoreValue(), tonumber(rt.bestScore or rt.hiScore or tmp.hiscore or
		var.hiscore or var.highscore) or 0)
end

local function currentPlayer(rt)
	local playerObject = rt.player or rawget(_G, "player")
	if playerObject and (not lstg.IsValid or lstg.IsValid(playerObject)) then
		return playerObject
	end
end

local function currentLives(rt)
	if rt.gameOverPresentation or rt.gameOver then return 0 end
	if rt.lifeStock ~= nil then return clamp(floor(rt.lifeStock), 0, LIFE_CAP) end
	local lives = tonumber(lstg.var and lstg.var.lifeleft)
	if lives == nil then return 0 end
	-- THEIS stores spare lives; the original HUD counts the active stock too.
	return clamp(floor(lives) + 1, 0, LIFE_CAP)
end

local function mentalStock(rt, playerObject)
	local value = lstg.var and lstg.var.bomb
	if value == nil and playerObject then value = playerObject.tokenStock end
	if value == nil then value = rt.mentalStock or rt.tokenStock end
	return clamp(floor(tonumber(value) or 0), 0, 3)
end

local function nextExtend(rt, score, difficulty)
	local index = tonumber(rt.extendIndex)
	if index then index = floor(index) + 1 end
	local thresholds = EXTEND_THRESHOLDS[difficulty + 1]
	if not index then
		index = 1
		while index <= #thresholds and score >= thresholds[index] do
			index = index + 1
		end
	end
	if index >= 1 and index <= #thresholds then return thresholds[index] end
end

local function gaugeColor(clock)
	clock = max(0, floor(clock or 0))
	local index = floor(clock / 20) % #READY_COLORS + 1
	local nextIndex = index % #READY_COLORS + 1
	local mix = clock % 20 / 20
	local result = {}
	for channel = 1, 3 do
		result[channel] = floor(READY_COLORS[index][channel] +
			(READY_COLORS[nextIndex][channel] - READY_COLORS[index][channel]) * mix)
	end
	return result[1], result[2], result[3]
end

local function frameRateMode(rt)
	local mode = tonumber(rt.frameRateMode)
	local config = rt.systemConfig
	if mode == nil and type(config) == "table" then
		mode = tonumber(config.frameRateMode)
		if mode == nil then
			-- The source field is systemConfig[1].  A conventional Lua copy is
			-- one-based ([2]); retain support for a zero-based table as well.
			mode = tonumber(config[rawget(config, 0) ~= nil and 1 or 2])
		end
	end
	return clamp(floor(mode or 0), 0, 2)
end

local function renderRightPanel(self, panel)
	local rt = self.runtime
	local playerObject = currentPlayer(rt)
	local var = lstg.var or {}
	local group = clamp(floor(tonumber(rt.setupGroup or
		(playerObject and playerObject.setupGroup)) or 0), 0, 2)
	local gameOver = rt.gameOverPresentation or rt.gameOver or
		(tonumber(var.lifeleft) or 0) < 0

	drawTopLeft(panel, "ld_player_frame_1", RIGHT_ORIGIN, 0, 340, 720)
	local overlay = group * 10 + (gameOver and 9 or 1)
	drawTopLeft(self.leftPanel, "ld_player_frame_" .. tostring(overlay + 1),
		0, 0, 340, 720)

	local fpsMode = frameRateMode(rt)
	local targetFps = ({60, 30, 20})[fpsMode + 1]
	local measuredFps = self.measuredFps or targetFps
	if fpsMode > 0 then measuredFps = floor(measuredFps / (fpsMode + 1)) end
	drawNumber(panel, 1270, 12, targetFps, 3, false, false, 0.8)
	drawTopLeft(panel, numberImage(12), 1235, 0, 20, 30, 0.8, 0.8)
	drawNumber(panel, 1230, 12, measuredFps, 3, false, false, 0.8)

	local difficulty = clamp(floor(tonumber(rt.difficulty) or 1), 0, 4)
	local stageNumber = floor(tonumber(rt.stageNumber or rt.stage) or 1)
	local routeMode = tonumber(rt.routeMode) or 0
	if routeMode == -1 then
		drawState(panel, 15, 1115, 340)
	elseif stageNumber == 10 then
		drawState(panel, 16, 1115, 340)
	else
		drawState(panel, 10 + difficulty, 1115, 340)
	end
	if routeMode == 1 and stageNumber ~= 10 then
		drawState(panel, 17, 1115, 370)
	elseif routeMode == 2 then
		drawState(panel, 28, 1115, 370)
	end

	local likeStyle = tonumber(rt.likeStyle or var.like_dreamer_like_style) or 0
	local score = scoreValue()
	drawState(panel, likeStyle == 0 and 0 or 29, 1040, 410)
	drawState(panel, likeStyle == 0 and 1 or 30, 1040, 450)
	drawNumber(panel, 1240, 410, bestScoreValue(rt), 12, false, true)
	drawNumber(panel, 1240, 450, score, 12, false, true)

	drawState(panel, 2, 1040, 500)
	drawNumber(panel, 1240, 500, rt.scoreItemBaseValue or
		var.like_dreamer_score_item_base or 100, 9, false, true)

	drawState(panel, 3, 1040, 530)
	drawCentered(panel, "ld_enemy_gauge_1", 1135, 534, 1, 1, 0,
		255, 64, 64, 128)
	local specialGauge = tonumber(playerObject and playerObject.specialGauge or
		rt.specialGauge or rt.special_gauge or var.like_dreamer_special_gauge) or 0
	local gaugeScale = specialGauge / 50000
	local gaugeRed, gaugeGreen, gaugeBlue = 255, 64, 64
	if specialGauge < 0 or specialGauge > 49999 then
		gaugeScale = specialGauge < 0 and -specialGauge / 600 or 1
		gaugeRed, gaugeGreen, gaugeBlue = gaugeColor(playerObject and
			playerObject.drawAnimationClock or rt.frame)
	end
	gaugeScale = clamp(gaugeScale, 0, 1)
	drawTopLeft(panel, "ld_enemy_gauge_fill", 1015, 529, 240, 10,
		gaugeScale, 1, 255, gaugeRed, gaugeGreen, gaugeBlue)
	local flash = clamp(floor(tonumber(rt.hudSpecialGaugeFlashTimer) or 0), 0, 60)
	if flash > 0 then
		drawTopLeft(panel, "ld_enemy_gauge_fill", 1015, 543, 240, 10,
			flash / 60, 0.5, 255, 255, 128, 64)
	end

	drawState(panel, 4, 1040, 580)
	local lives = currentLives(rt)
	for index = 0, LIFE_CAP - 1 do
		local x = 1037 + index * 27
		drawState(panel, 8, x, 580, 0, 0, 0, 64)
		if index < lives then drawState(panel, 8, x, 580) end
	end

	drawState(panel, 5, 1050, 610)
	local extend = nextExtend(rt, score, difficulty)
	if extend then drawNumber(panel, 1240, 611, extend, 12, false, true, 0.7) end

	drawState(panel, 6, 1040, 650)
	local stock = mentalStock(rt, playerObject)
	for index = 0, 2 do
		local x = 1100 + index * 35
		drawState(panel, 9, x, 650, 0, 0, 0, 64)
		if index < stock then drawState(panel, 9, x, 650) end
	end

	drawState(panel, 7, 1030, 695)
	local slots = rt.optionSlots or (playerObject and playerObject.optionSlots) or
		var.like_dreamer_option_slots or {0, 0, 0, 0}
	for index = 1, 4 do
		drawState(panel, 22 + clamp(floor(tonumber(slots[index]) or 0), 0, 3),
			1110 + index * 20, 695)
	end
	local specialMode = clamp(floor(tonumber(rt.specialMode or
		(playerObject and playerObject.specialMode) or
		var.like_dreamer_special_mode) or 0), 0, 1)
	drawState(panel, specialMode == 0 and 26 or 27, 1300, 695)
end

local function nearestEnemyInfo(rt, playerObject)
	if not playerObject then return false, 0, 10 end
	local nearest
	local hasTarget = false
	local horizontalOrigin = (playerObject.ldX or 360) / 6
	for _, enemy in pairs(rt.enemiesById or {}) do
		if enemy.active and enemy.targetable then
			local radius = max(0, enemy.radius or 0)
			local x, y = enemy.ldX or 0, enemy.ldY or 0
			if x >= horizontalOrigin - (radius + 100) and
				x <= horizontalOrigin + radius + 700 and
				y >= -(radius + 100) and y <= radius + 820 then
				hasTarget = true
				local dx = x - (playerObject.ldX or 360)
				local dy = y - (playerObject.ldY or 600)
				local distance = math.sqrt(dx * dx + dy * dy) - radius
				if nearest == nil or distance < nearest then nearest = distance end
			end
		end
	end
	local value, tier = 0, 10
	if nearest and nearest >= 0 and nearest < 2000 then
		value = floor(nearest)
		if value > 150 then
			tier = 1
			if value < 450 then tier = max(1, floor((450 - value) / 30)) end
		end
	end
	return hasTarget, value, tier
end

local function keyDown(name)
	if type(KeyIsDown) ~= "function" then return false end
	local ok, result = pcall(KeyIsDown, name)
	return ok and result or false
end

local function renderLeftDataWindow(self, panel)
	local rt = self.runtime
	local var = lstg.var or {}
	local configured = rt.dataWindowEnabled
	if configured == nil then configured = var.like_dreamer_data_window_enabled end
	-- The original persisted setting defaults to enabled.
	local enabled = configured == nil or tonumber(configured) ~= 0
	if not enabled or tonumber(rt.routeMode) == -1 then return end
	local playerObject = currentPlayer(rt)
	drawTopLeft(panel, "ld_data_window", 0, 330, 340, 380)
	local stageNumber = floor(tonumber(rt.stageNumber or rt.stage) or 1)
	local resultFrame = stageNumber == 10 and 9 or 1
	-- DrawRotaGraph3F uses (0, 30) as the 240x60 frame pivot here.
	drawCentered(panel, "ld_result_" .. tostring(resultFrame + 1), 138, 365,
		0.9, 0.9)
	if stageNumber ~= 10 then
		drawNumber(panel, 120, 365, stageNumber, 1, false, false, 0.9)
	end
	local gameOver = rt.gameOverPresentation or rt.gameOver or
		(tonumber(var.lifeleft) or 0) < 0
	if not gameOver then
		drawNumber(panel, 280, 365, rt.frame or 0, 5, false, false)
	end

	local hasTarget, distance, distanceTier = nearestEnemyInfo(rt, playerObject)
	if hasTarget then
		drawNumber(panel, 54, 447, distance, 4, true, false)
		if distanceTier >= 0 and distanceTier < 15 then
			local scale = distanceTier * 0.035 + 0.35
			drawCentered(panel, "ld_item_" .. tostring(distanceTier + 1),
				120, 450, scale, scale)
		end
	end
	drawNumber(panel, 280, 435, rt.bulletCount or 0, 4, false, false)
	drawNumber(panel, 265, 465, rt.enemyProjectileSpawnsLastSecond or
		rt.projectileSpawnsLastSecond or 0, 4, false, false, 0.7)
	drawNumber(panel, 135, 535, playerObject and playerObject.graze or
		rt.graze or var.graze or 0, 6, false, false)
	local beingShot = playerObject and playerObject.beingShotCount or 0
	local hiddenStage = tonumber(rt.routeMode) == 1 and
		tonumber(rt.specialStageFlag or 0) == 0 and stageNumber ~= 10
	if hiddenStage then
		local limits = {
			{6, 5, 5, 3}, {6, 5, 5, 3}, {6, 5, 5, 3},
			{8, 7, 7, 4}, {10, 8, 8, 5},
		}
		local difficulty = clamp(floor(tonumber(rt.difficulty) or 1), 0, 4)
		local hiddenSlots = rt.optionSlots or
			(playerObject and playerObject.optionSlots) or {}
		local style = clamp(floor(tonumber(hiddenSlots[4]) or 0), 0, 3)
		local unlocked = beingShot <= limits[difficulty + 1][style + 1]
		local brightness = stageNumber == 9 and 255 or 64
		if stageNumber ~= 9 and unlocked then
			brightness = floor(224 + 32 * sin((playerObject and
				playerObject.drawAnimationClock or rt.frame or 0) * pi / 60))
		end
		drawCentered(panel, "ld_data_window_2_10", 280, 535, 1, 1, 0,
			255, brightness, brightness, brightness)
	end
	drawNumber(panel, hiddenStage and 215 or 245, 540, beingShot,
		2, true, false, 1, true)

	if playerObject then
		local group = clamp(floor(tonumber(playerObject.setupGroup or rt.setupGroup) or 0), 0, 2)
		local sequence = {0, 1, 2, 1}
		local clock = max(0, floor(playerObject.drawAnimationClock or 0))
		local neutral = group * 30 + sequence[floor(clock / 7) % 4 + 1]
		drawCentered(panel, "ld_player_" .. tostring(neutral + 1), 55, 640)
		if (playerObject.invulnerableFrames or 0) > 0 and clock % 2 == 0 then
			drawCentered(panel, "ld_player_" .. tostring(neutral + 16), 55, 640)
		end
		if (playerObject.invulnerableFrames or 0) > 0 then
			drawNumber(panel, 55, 640, playerObject.invulnerableFrames, 4,
				true, false)
		end
	end

	local function dataFrame(frame, x, y, angle16)
		drawCentered(panel, "ld_data_window_2_" .. tostring(frame + 1),
			x, y, 1, 1, Core.angleToDeg(angle16 or 0))
	end
	dataFrame(0, 160, 647)
	local directions = {
		{"up", 160, 610, 0xc000}, {"down", 160, 670, 0x4000},
		{"right", 190, 640, 0}, {"left", 130, 640, 0x8000},
	}
	for _, entry in ipairs(directions) do
		dataFrame(keyDown(entry[1]) and 2 or 1, entry[2], entry[3], entry[4])
	end
	local buttons = {
		{"shoot", 220, 615}, {"spell", 270, 615},
		{"special", 290, 665}, {"slow", 240, 665},
	}
	for index, entry in ipairs(buttons) do
		dataFrame(4 + index, entry[2], entry[3] - 20)
		dataFrame(keyDown(entry[1]) and 4 or 3, entry[2], entry[3])
	end
end

function SideHudController:frame(proxy)
	self:pullSideProxy()
	local active = LikeDreamer.runtime
	if self.runtime.finished or active ~= self.runtime then
		proxy.status = "del"
		return
	end
	if self.runtime.gameOverPresentation and
			(tonumber(lstg.var and lstg.var.lifeleft) or 0) > 0 then
		self.runtime.gameOverPresentation = false
		self.runtime.extendIndex = 0
		lstg.var.like_dreamer_extend_index = 0
	end
	if type(lstg.GetFPS) == "function" then
		self.measuredFps = max(0,
			floor((tonumber(lstg.GetFPS()) or 0) + 0.5))
		self:pushSideProxy()
		return
	end
	self.fpsFrames = self.fpsFrames + 1
	local now = os.clock()
	local elapsed = now - self.fpsStart
	if elapsed >= 1 then
		self.measuredFps = max(0, floor(self.fpsFrames / elapsed + 0.5))
		self.fpsFrames = 0
		self.fpsStart = now
	end
	self:pushSideProxy()
end

function SideHudController:dataFrame(proxy)
	if self.runtime.finished or LikeDreamer.runtime ~= self.runtime then
		proxy.status = "del"
	end
end

function SideHudController:renderSide()
	return self.renderer:renderSide(self)
end

function SideHudController:renderData()
	return self.renderer:renderData(self)
end

function SideHudRenderer:renderSide(controller)
	local rt = controller.runtime
	if rt.hideHud or rt.hudHidden then return end
	controller:pullSideProxy()
	local previousMode = lstg.viewmode or "world"
	SetViewMode("ui")
	controller.leftPanel, controller.rightPanel = SideHudLayout.capture()
	if type(RenderRect) == "function" and hasImage("white") then
		setImageColor("white", 255, 0, 0, 0)
		RenderRect("white", controller.leftPanel.left, controller.leftPanel.right,
			controller.leftPanel.top - PANEL_HEIGHT * controller.leftPanel.sy,
			controller.leftPanel.top)
		RenderRect("white", controller.rightPanel.left, controller.rightPanel.right,
			controller.rightPanel.top - PANEL_HEIGHT * controller.rightPanel.sy,
			controller.rightPanel.top)
		resetImageColor("white")
	end
	renderRightPanel(controller, controller.rightPanel)
	controller:pushSideProxy()
	SetViewMode(previousMode)
end

function SideHudRenderer:renderData(controller)
	local rt = controller.runtime
	if rt.hideHud or rt.hudHidden then return end
	local previousMode = lstg.viewmode or "world"
	SetViewMode("ui")
	local leftPanel = SideHudLayout.capture()
	renderLeftDataWindow(controller, leftPanel)
	SetViewMode(previousMode)
end

local sideHudRenderer = SideHudRenderer.new()

local sideHudClass = Class(object)
M.Class = sideHudClass
local sideDataHudClass = Class(object)
M.DataClass = sideDataHudClass

function sideHudClass:init(rt)
	self.runtime = assert(rt, "LikeDreamer SideHud requires a runtime")
	self.controller = SideHudController.new(rt, sideHudRenderer)
	self.controller:attachSideProxy(self)
	self.group = GROUP_GHOST
	-- Source draw order: right panel (0x6e), approach (0x6f), boss HUD,
	-- portraits (0x6f), time window/banner (0x70), data window (0x73).
	self.layer = (rawget(_G, "LAYER_TOP") or 0) + 94
	self.bound = false
	self.colli = false
	rt._sideHud = self
	rt._sideHudController = self.controller
end

function sideHudClass:frame()
	self.controller:frame(self)
end

function sideHudClass:render()
	if not (AndroidPortrait and AndroidPortrait.enabled()) then self.controller:renderSide() end
end

function sideHudClass:del()
	if self.runtime and self.runtime._sideHud == self then
		self.runtime._sideHud = nil
		self.runtime._sideHudController = nil
	end
end

sideHudClass.kill = sideHudClass.del

function sideDataHudClass:init(rt)
	self.runtime = rt
	self.controller = rt._sideHudController or
		SideHudController.new(rt, sideHudRenderer)
	self.group = GROUP_GHOST
	self.layer = (rawget(_G, "LAYER_TOP") or 0) + 103
	self.bound = false
	self.colli = false
	rt._sideDataHud = self
end

function sideDataHudClass:frame()
	self.controller:dataFrame(self)
end

function sideDataHudClass:render()
	if not (AndroidPortrait and AndroidPortrait.enabled()) then self.controller:renderData() end
end

function sideDataHudClass:del()
	if self.runtime and self.runtime._sideDataHud == self then
		self.runtime._sideDataHud = nil
	end
end

sideDataHudClass.kill = sideDataHudClass.del

function M.create(rt)
	rt = rt or LikeDreamer.runtime
	assert(rt, "LikeDreamer SideHud.create requires a runtime")
	local current = rt._sideHud
	if current and (not lstg.IsValid or lstg.IsValid(current)) then return current end
	LikeDreamer.Resources.loadPlayer()
	current = New(sideHudClass, rt)
	local dataHud = rt._sideDataHud
	if not dataHud or (lstg.IsValid and not lstg.IsValid(dataHud)) then
		New(sideDataHudClass, rt)
	end
	return current
end

return M
