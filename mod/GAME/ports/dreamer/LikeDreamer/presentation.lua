-- Full-screen stage banners and the 300-frame boss-approach presentation.

LikeDreamer = LikeDreamer or {}

local Core = assert(LikeDreamer.Core, "LikeDreamer.Core is required")
local M = {}
LikeDreamer.Presentation = M

local floor = math.floor
local max = math.max
local min = math.min
local sin = math.sin
local cos = math.cos
local pi = math.pi

local SCREEN_HEIGHT = 720

local STAGE_END_FRAMES = {
	5700, 9700, 9500, 11700, 11800,
	12500, 12500, 21420, 17900, 12000,
}

-- stage, text id, icon (-1 selects the setup), start, end, mode, add setup
local BANNERS = {
	{1, 100, -1, 50, 230, 0, true},
	{2, 110, -1, 50, 230, 0, true},
	{3, 120, -1, 50, 230, 0, true},
	{4, 130, -1, 50, 230, 0, true},
	{5, 140, -1, 50, 230, 0, true},
	{6, 150, -1, 50, 230, 0, true},
	{7, 160, -1, 50, 230, 0, true},
	{8, 170, -1, 50, 230, 0, true},
	{9, 180, -1, 50, 230, 0, true},
	{1, 103, 4, 5400, 5560, 1, true},
	{1, 106, -1, 5540, 5700, 0, true},
	{2, 113, 5, 9400, 9560, 1, true},
	{2, 116, -1, 9540, 9700, 0, true},
	{3, 123, 6, 9200, 9360, 1, true},
	{3, 126, -1, 9340, 9500, 0, true},
	{4, 133, 7, 11400, 11560, 1, true},
	{4, 136, -1, 11540, 11700, 0, true},
	{5, 143, 8, 11500, 11660, 1, true},
	{5, 146, -1, 11640, 11800, 0, true},
	{6, 153, 9, 12200, 12360, 1, true},
	{6, 156, -1, 12340, 12500, 0, true},
	{7, 163, 10, 12200, 12360, 1, true},
	{7, 200, 15, 12200, 12360, 2, true},
	{7, 166, -1, 12340, 12500, 0, true},
	{8, 173, 11, 21120, 21280, 1, true},
	{8, 176, -1, 21260, 21420, 0, true},
	{9, 0xb7, 0x0c, 17600, 17760, 1, false},
	{9, 0xb8, 0x0c, 17740, 17900, 1, false},
	{10, 193, 13, 50, 210, 1, true},
	{10, 196, -1, 190, 350, 0, true},
}

local TEXT_PATHS = {
	ja_jp = "res/likedreamer/text/text01.csv",
	en_us = "res/likedreamer/text/text02.csv",
	zh_cn = "res/likedreamer/text/text03.csv",
	zh_tw = "res/likedreamer/text/text04.csv",
}

local TextRepository = {}
TextRepository.__index = TextRepository

function TextRepository.new(paths)
	return setmetatable({paths = paths, cache = {}}, TextRepository)
end

local ScreenLayout = {}

local PresentationTimeline = {}
PresentationTimeline.__index = PresentationTimeline

function PresentationTimeline.new(banners, stageEndFrames)
	return setmetatable({
		banners = banners,
		stageEndFrames = stageEndFrames,
	}, PresentationTimeline)
end

local PresentationRenderer = {}
PresentationRenderer.__index = PresentationRenderer

function PresentationRenderer.new(timeline, textRepository)
	return setmetatable({
		timeline = timeline,
		textRepository = textRepository,
	}, PresentationRenderer)
end

local PresentationController = {}
PresentationController.__index = PresentationController

function PresentationController.new(rt, timeline, renderer, textRepository)
	return setmetatable({
		runtime = rt,
		timeline = timeline,
		renderer = renderer,
		textRepository = textRepository,
	}, PresentationController)
end

M.TextRepository = TextRepository
M.ScreenLayout = ScreenLayout
M.Timeline = PresentationTimeline
M.Renderer = PresentationRenderer
M.Controller = PresentationController

local function clamp(value, lower, upper)
	return min(upper, max(lower, value))
end

local function localeName()
	local locale = rawget(_G, "setting") and setting.lang or "zh_cn"
	if TEXT_PATHS[locale] then return locale end
	return "en_us"
end

local function splitCsvLine(line)
	local fields, current = {}, {}
	local quoted = false
	for index = 1, #line do
		local ch = line:sub(index, index)
		if ch == '"' then
			quoted = not quoted
		elseif ch == "," and not quoted then
			fields[#fields + 1] = table.concat(current)
			current = {}
		elseif ch ~= "\r" then
			current[#current + 1] = ch
		end
	end
	fields[#fields + 1] = table.concat(current)
	return fields
end

function TextRepository:load()
	local locale = localeName()
	if self.cache[locale] then return self.cache[locale], locale end
	local records = {}
	local loader = lstg.LoadTextFile or rawget(_G, "LoadTextFile")
	local source = loader and loader(self.paths[locale])
	if source then
		source = source:gsub("^\239\187\191", "")
		for line in source:gmatch("[^\n]+") do
			local fields = splitCsvLine(line)
			local id = tonumber(fields[1])
			if id and #fields == 4 then
				records[id] = {
					fields[2] or "",
					fields[3] == "NULL" and "" or (fields[3] or ""),
				}
			end
		end
	end
	self.cache[locale] = records
	return records, locale
end

local function utf8Characters(value)
	local result = {}
	local index = 1
	while index <= #value do
		local first = value:byte(index)
		local length = first < 0x80 and 1 or
			(first < 0xe0 and 2 or (first < 0xf0 and 3 or 4))
		result[#result + 1] = value:sub(index, index + length - 1)
		index = index + length
	end
	return result
end

function ScreenLayout.capture()
	local box = LikeDreamer.Viewport.capture()
	box.yScale = box.scale
	return box
end

local function imageExists(name)
	return not lstg.CheckRes or lstg.CheckRes(2, name)
end

local function setImage(name, alpha, red, green, blue, blend)
	SetImageState(name, blend or "", Color(
		floor(clamp(alpha or 255, 0, 255)),
		floor(clamp(red or 255, 0, 255)),
		floor(clamp(green or 255, 0, 255)),
		floor(clamp(blue or 255, 0, 255))))
end

local function resetImage(name)
	SetImageState(name, "", Color(255, 255, 255, 255))
end

function PresentationRenderer:renderMapped(screenLayout, name, x, y, angle,
		scaleX, scaleY)
	lstg.Render(name, screenLayout:mapX(x), screenLayout:mapY(y), angle or 0,
		screenLayout.scale * (scaleX or 1),
		screenLayout.yScale * (scaleY or scaleX or 1))
end

function PresentationTimeline:approachAge(rt, frame)
	local stage = floor(tonumber(rt.stageNumber or rt.stage) or 0)
	local start
	if stage == 10 then
		start = 50
	elseif stage >= 1 and stage <= 9 then
		start = self.stageEndFrames[stage] - 300
	else
		return -1
	end
	local age = frame - start
	return age >= 0 and age <= 300 and age or -1
end

function PresentationTimeline:sourceFrame(rt)
	local frame = floor(tonumber(rt and rt.frame) or 0)
	return frame > 0 and frame - 1 or frame
end

local function localizedApproachPrefix()
	local locale = localeName()
	if locale == "zh_cn" then return "ld_boss_approach_1_ch1_" end
	if locale == "zh_tw" then return "ld_boss_approach_1_ch2_" end
	return "ld_boss_approach_1_"
end

function PresentationRenderer:renderApproach(rt)
	local frame = self.timeline:sourceFrame(rt)
	local age = self.timeline:approachAge(rt, frame)
	local strip = localizedApproachPrefix() .. "1"
	if age < 0 or not imageExists(strip) or
			not imageExists("ld_boss_approach_2") then return end

	local screenLayout = ScreenLayout.capture()
	local scale, alpha, flashAlpha = 1, 255, 128
	if age < 60 then
		local entrance = sin(age * pi / 120)
		scale = 5 - entrance * 4
		alpha = entrance * 255
		flashAlpha = entrance * 128
	elseif age >= 270 then
		local exit = sin((300 - age) * pi / 60)
		scale = 5 - exit * 4
		alpha = exit * 255
	end
	alpha = alpha + 48 * sin(age * pi / 10) - 48
	if age >= 240 then
		flashAlpha = sin((300 - age) * pi / 120) * 128
	end

	local rectangle = rawget(_G, "RenderRect") or lstg.RenderRect
	if rectangle and imageExists("white") and flashAlpha > 0 then
		setImage("white", flashAlpha, 0, 0, 0)
		rectangle("white", screenLayout.left, screenLayout.right,
			screenLayout.bottom, screenLayout.top)
		resetImage("white")
	end

	local gridPhase = frame % 210 * 2
	local gridAlpha = clamp(20 + 20 * sin(frame % 210 * pi / 210), 0, 255)
	setImage(strip, gridAlpha)
	for row = 0, 6 do
		local rowOffset = gridPhase + row * 420
		for column = 0, 31 do
			local columnOffset = column * 60
			local x = columnOffset * cos(4.904136578870390) +
				rowOffset * cos(5.862874571298915) - 1000
			local y = columnOffset * sin(4.904136578870390) +
				rowOffset * sin(5.862874571298915) + 1440
			self:renderMapped(screenLayout, strip, x, y,
				Core.angleToDeg(0xeee0), 1, 1)
		end
	end
	resetImage(strip)

	setImage("ld_boss_approach_2", alpha)
	self:renderMapped(screenLayout, "ld_boss_approach_2", 640, 300, 0, 1, scale)
	resetImage("ld_boss_approach_2")
	setImage(strip, alpha)
	local travel = age % 105 * 4
	for index = 0, 3 do
		local x = index * 420 + travel
		self:renderMapped(screenLayout, strip, x, 300 - scale * 90, 0, scale, scale)
		self:renderMapped(screenLayout, strip, 1280 - x, 300 + scale * 90,
			0, scale, scale)
	end
	resetImage(strip)
end

function PresentationTimeline:activeBanners(rt, sourceFrame)
	local result = {}
	local stage = floor(tonumber(rt.stageNumber or rt.stage) or 0)
	for _, banner in ipairs(self.banners) do
		if banner[1] == stage and sourceFrame >= banner[4] and
				sourceFrame < banner[5] then
			result[#result + 1] = banner
		end
	end
	return result
end

function PresentationTimeline:bannerEnvelope(banner, frame)
	local localFrame = frame - banner[4]
	local duration = banner[5] - banner[4]
	if localFrame < 16 then return sin(localFrame / 16 * pi * 0.5) end
	if localFrame >= duration - 16 then
		return cos((localFrame - (duration - 16)) / 16 * pi * 0.5)
	end
	return 1
end

function PresentationTimeline:bannerTextId(rt, banner)
	local base = banner[2]
	if banner[1] == 1 and banner[4] == 50 and
			tonumber(rt.specialStageFlag or 0) ~= 0 then
		base = 0x127
	end
	if banner[7] then
		base = base + clamp(floor(tonumber(rt.setupGroup) or 0), 0, 2)
	end
	return base
end

function PresentationRenderer:renderBannerPanels(rt)
	local frame = self.timeline:sourceFrame(rt)
	local banners = self.timeline:activeBanners(rt, frame)
	if #banners == 0 then return end
	local screenLayout = ScreenLayout.capture()
	for _, banner in ipairs(banners) do
		local envelope = self.timeline:bannerEnvelope(banner, frame)
		local mode = banner[6]
		local y = mode == 0 and 660 or (mode == 2 and 160 or 60)
		local panel = "ld_text_box_" .. tostring(mode == 0 and 1 or 2)
		local iconIndex = banner[3] < 0 and
			clamp(floor(tonumber(rt.setupGroup) or 0), 0, 2) or banner[3]
		local icon = "ld_text_icon_" .. tostring(iconIndex + 1)
		if imageExists(panel) then
			setImage(panel, 255)
			self:renderMapped(screenLayout, panel, 640, y, 0, 1, envelope)
			resetImage(panel)
		end
		if imageExists(icon) then
			setImage(icon, 255)
			self:renderMapped(screenLayout, icon, 390, y, 0, envelope, envelope)
			resetImage(icon)
		end
	end
end

function PresentationRenderer:renderBannerText(rt)
	local frame = self.timeline:sourceFrame(rt)
	local banners = self.timeline:activeBanners(rt, frame)
	if #banners == 0 or type(lstg.RenderTTF) ~= "function" then return end
	local records, locale = self.textRepository:load()
	local screenLayout = ScreenLayout.capture()
	local english = locale == "en_us"
	local revealRate = english and 1 or 2
	local characterStep = english and 9 or 18
	for _, banner in ipairs(banners) do
		local textStart = banner[4] + 16
		local textEnd = banner[5] - 16
		if frame >= textStart and frame < textEnd then
			local record = records[self.timeline:bannerTextId(rt, banner)]
			if record then
				local line1 = utf8Characters(record[1])
				local line2 = utf8Characters(record[2])
				local textAge = frame - textStart
				local remaining = min(#line1 + #line2,
					floor(textAge / revealRate) + 1)
				local ordinal = 0
				local mode = banner[6]
				local baseY = mode == 0 and 635 or (mode == 2 and 135 or 35)
				local color = mode == 0 and Color(255, 64, 64, 128) or
					Color(255, 255, 255, 255)
				local function drawLine(characters, lineIndex)
					for column, glyph in ipairs(characters) do
						if remaining <= 0 then return end
						local wave = sin((textAge - ordinal * 3) *
							0.08849556770675474) * 2
						local x = screenLayout:mapX(435 + (column - 1) * characterStep)
						local y = screenLayout:mapY(baseY + lineIndex * 30 + wave)
						lstg.RenderTTF("pretty", glyph, x, x, y, y,
							4, color, screenLayout.yScale)
						remaining = remaining - 1
						ordinal = ordinal + 1
					end
				end
				drawLine(line1, 0)
				if remaining > 0 then drawLine(line2, 1) end
			end
		end
	end
end

local function play(name, volume)
	if (not lstg.CheckRes or lstg.CheckRes(5, name)) and
			type(lstg.PlaySound) == "function" then
		lstg.PlaySound(name, volume or 0.45, 0)
	end
end

local textRepository = TextRepository.new(TEXT_PATHS)
local timeline = PresentationTimeline.new(BANNERS, STAGE_END_FRAMES)
local presentationRenderer = PresentationRenderer.new(timeline, textRepository)

function PresentationController:updateEvents()
	local rt = self.runtime
	local current = self.timeline:sourceFrame(rt)
	local previous = self.lastFrame or current - 1
	if current < previous then previous = current - 1 end
	for frame = previous + 1, current do
		local age = self.timeline:approachAge(rt, frame)
		if age == 0 then
			local reward = LikeDreamer.Reward
			if reward and reward.spawnPlayerPortrait then
				reward.spawnPlayerPortrait(rt, 5, 300)
			end
		end
		if age >= 0 and age < 270 and age % 20 == 0 then
			play("ld_se_Alert", 0.45)
		end
		for _, banner in ipairs(self.timeline:activeBanners(rt, frame)) do
			local textAge = frame - (banner[4] + 16)
			local textEnd = banner[5] - 16
			if frame < textEnd and textAge >= 0 and textAge % 2 == 0 then
				local records, locale = self.textRepository:load()
				local record = records[self.timeline:bannerTextId(rt, banner)]
				if record then
					local total = #utf8Characters(record[1]) +
						#utf8Characters(record[2])
					local revealRate = locale == "en_us" and 1 or 2
					if textAge <= total * revealRate then
						play(banner[6] == 0 and "ld_se_Text" or
							"ld_se_Text2", 0.35)
					end
				end
			end
		end
	end
	self.lastFrame = current
end

function PresentationController:frame(proxy)
	if not self.runtime or self.runtime.finished or
			LikeDreamer.runtime ~= self.runtime then
		Del(proxy)
	end
end

function PresentationController:update(proxy)
	if proxy.lastFrame ~= nil then self.lastFrame = proxy.lastFrame end
	self:frame(proxy)
	if proxy.status ~= "del" then
		self:updateEvents()
		proxy.lastFrame = self.lastFrame
	end
end

function PresentationController:renderApproach()
	LikeDreamer.Viewport.draw(self.renderer.renderApproach, self.renderer, self.runtime)
end

function PresentationController:renderBannerPanels()
	LikeDreamer.Viewport.draw(self.renderer.renderBannerPanels, self.renderer, self.runtime)
end

function PresentationController:renderBannerText()
	LikeDreamer.Viewport.draw(self.renderer.renderBannerText, self.renderer, self.runtime)
end

local function controllerFor(rt)
	local controller = rt._presentationController
	if controller and controller.runtime == rt then return controller end
	controller = PresentationController.new(rt, timeline,
		presentationRenderer, textRepository)
	rt._presentationController = controller
	return controller
end

local approachClass = Class(object)
local bannerPanelClass = Class(object)
local bannerTextClass = Class(object)
M.ApproachClass = approachClass
M.BannerPanelClass = bannerPanelClass
M.BannerTextClass = bannerTextClass

local function initProxy(self, rt, layer)
	self.runtime = rt
	self.controller = controllerFor(rt)
	self.group = GROUP_GHOST
	self.layer = (rawget(_G, "LAYER_TOP") or 0) + layer
	self.bound = false
	self.colli = false
end

local function frameProxy(self)
	self.controller:frame(self)
end

function approachClass:init(rt)
	initProxy(self, rt, 95)
	self.lastFrame = (rt.frame or 0) - 1
	self.controller.lastFrame = self.lastFrame
end

function approachClass:frame()
	self.controller:update(self)
end

function approachClass:render()
	self.controller:renderApproach()
end

function bannerPanelClass:init(rt) initProxy(self, rt, 101) end
bannerPanelClass.frame = frameProxy
function bannerPanelClass:render()
	self.controller:renderBannerPanels()
end

function bannerTextClass:init(rt) initProxy(self, rt, 120) end
bannerTextClass.frame = frameProxy
function bannerTextClass:render()
	self.controller:renderBannerText()
end

function M.create(rt)
	rt = rt or LikeDreamer.runtime
	if not rt then return end
	if rt._presentationObjects then return rt._presentationObjects end
	controllerFor(rt)
	rt._presentationObjects = {
		New(approachClass, rt),
		New(bannerPanelClass, rt),
		New(bannerTextClass, rt),
	}
	return rt._presentationObjects
end

return M
