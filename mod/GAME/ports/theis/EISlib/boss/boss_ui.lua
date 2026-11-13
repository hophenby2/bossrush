---=====================================
---祈华梦版boss UI
---code by Xiliusha
---=====================================

local path = EISlib.Boss.path

----------------------------------------
---fun

local function lerp_pow(src, dest, rate)
	src = dest + (src - dest) * rate
	return src
end

local function clamp(src, min, max)
	local ret = math.max(math.min(src, max), min)
	return ret
end

local function split_time(time)
	time = clamp(time, 0.0, 999.99)
	local str = string.format("%.2f", time)
	return string.sub(str, 1, string.len(str) - 3), string.sub(str, -3, -1)
end

local function clear_table(t)
	while (#t) > 0 do
		table.remove(t)
	end
end

----------------------------------------
---life bar

---@class EISlib.Boss.Lifebar
local lifebar = {}

function lifebar:init()
	self.tex = EISlib.Boss.Index.tex1
	self.img = "boss_ui_graybar"
	self.bar = {
		green = {
			{ x = 3, y = 43, w = 672, h = 22, },
			{ x = 3, y = 81, w = 672, h = 22, },
			{ x = 3, y = 119, w = 672, h = 22, },
			{ x = 3, y = 157, w = 672, h = 22, },
			{ x = 3, y = 195, w = 672, h = 22, },
			{ x = 3, y = 233, w = 672, h = 22, },
			{ x = 3, y = 271, w = 672, h = 22, },
		},
		yellow = {
			{ x = 3, y = 309, w = 672, h = 22, },
			{ x = 3, y = 347, w = 672, h = 22, },
			{ x = 3, y = 385, w = 672, h = 22, },
			{ x = 3, y = 423, w = 672, h = 22, },
			{ x = 3, y = 461, w = 672, h = 22, },
			{ x = 3, y = 499, w = 672, h = 22, },
			{ x = 3, y = 537, w = 672, h = 22, },
		},
		red = {
			{ x = 685, y = 43, w = 672, h = 22, },
			{ x = 685, y = 81, w = 672, h = 22, },
			{ x = 685, y = 119, w = 672, h = 22, },
			{ x = 685, y = 157, w = 672, h = 22, },
			{ x = 685, y = 195, w = 672, h = 22, },
			{ x = 685, y = 233, w = 672, h = 22, },
			{ x = 685, y = 271, w = 672, h = 22, },
		},
		gray = {
			{ x = 685, y = 309, w = 672, h = 22, },
			{ x = 685, y = 347, w = 672, h = 22, },
			{ x = 685, y = 385, w = 672, h = 22, },
			{ x = 685, y = 423, w = 672, h = 22, },
			{ x = 685, y = 461, w = 672, h = 22, },
			{ x = 685, y = 499, w = 672, h = 22, },
			{ x = 685, y = 537, w = 672, h = 22, },
		},
	}
	self.timer = 0
	self.type = "green"
end

function lifebar:update()
	self.timer = self.timer + 1
	local lua
end

function lifebar:set(t)
	self.type = t
	local lua
end

function lifebar:draw(x, y, imgscale, coodscale, alpha, rate)
	local c = Color(alpha * 255, 255, 255, 255)
	SetImageState(self.img, "", c)
	Render(self.img, x, y, 0, imgscale)
	local index = ((math.floor(self.timer / 4) - 1) % 7) + 1
	local info = self.bar[self.type][index]
	local u1, u2 = info.x, info.x + info.w * rate
	local v1, v2 = info.y, info.y + info.h
	local w2, h2 = info.w / 2, info.h / 2
	local x1, x2 = x - w2 * coodscale, x - w2 * coodscale + info.w * coodscale * rate
	local y1, y2 = y + h2 * coodscale, y - h2 * coodscale
	RenderTexture(self.tex, "",
			{ x1, y1, 0.5, u1, v1, c },
			{ x2, y1, 0.5, u2, v1, c },
			{ x2, y2, 0.5, u2, v2, c },
			{ x1, y2, 0.5, u1, v2, c })
end

----------------------------------------
---item

local boss_name = Class(object)

function boss_name:init(slot, name)
	self.layer = LAYER_TOP
	self.bound = false
	self.colli = false

	self.img = EISlib.Boss.Index.GetImageByName(name)
	self.name = name
	self.slot = slot

	self.rate = 0.025
	self.rate_d = 0.025

	self.x = lstg.world.l - 64 + 64 * self.rate
	self.y = lstg.world.t - (slot - 1) * 172
end

function boss_name:frame()
	self.x = lstg.world.l - 64 + 64 * self.rate
	self.rate = math.min(self.rate + self.rate_d, 1)
	if self.rate < 0 then
		Del(self)
	end
end

function boss_name:render()
	SetViewMode("ui")
	SetImageState(self.img, "", Color(255 * self.rate, 255, 255, 255))
	local px, py = WorldToUI(self.x, self.y)
	Render(self.img, px, py, 0, 1)
	SetViewMode("world")
end

function boss_name:kill()
	self.status = "normal"
	self.rate_d = -0.025
	self.timer = 0
end

----------------------------------------
---boss ui manager

---@class EISlib.Boss.UI
local manager = {}

function manager:init()
	---@type table<string, lstg.GameObject>[]
	self.obj = {}

	---@type EISlib.Boss.Lifebar
	self.lifebar = EISlib.New(lifebar)
	self.lifebar_alpha = 0
	self.lifebar_rate = 0

	self.time_left = 0

	self.stage_left = 0
	self.score_alpha = 0
	self.sc_score = 0
	self.history_get = 0
	self.history_all = 0

	---@type number[]
	self.pointers = {}
	---@type string[]
	self.names = {}
	---@type string[]
	self.sc_names = {}

	self.freet = 60
end

function manager:update()
	self:sort_object()
	local obj = self.obj[1] or {}
	local boss = obj.boss
	local ui = obj.ui
	--pre check
	local precheck = IsValid(boss) and IsValid(ui)
	local attackcheck = false
	if precheck then
		local card = boss._bosssys:GetCurrentCard()
		if card and card.is_combat then
			attackcheck = true
		end
	end
	--boss pointer
	if precheck then
		self.stage_left = ui.sc_left or 0
		clear_table(self.pointers)
		clear_table(self.names)
		clear_table(self.sc_names)
		for i, v in ipairs(self.obj) do
			if v.boss.ui_pointers and (#v.boss.ui_pointers > 0) then
				for _, x in ipairs(v.boss.ui_pointers) do
					table.insert(self.pointers, x)
				end
			else
				table.insert(self.pointers, v.ui.pointer_x or v.boss.x)
			end
			if v.boss.ui_names and (#v.boss.ui_names > 0) then
				for _, name in ipairs(v.boss.ui_names) do
					table.insert(self.names, name)
				end
			else
				if string.len(v.ui.name) > 0 then
					table.insert(self.names, v.ui.name)
				end
			end
			if v.boss.ui_cardnames and (#v.boss.ui_cardnames > 0) then
				for _, name in ipairs(v.boss.ui_cardnames) do
					table.insert(self.sc_names, name)
				end
			else
				if string.len(v.ui.sc_name) > 0 then
					table.insert(self.sc_names, v.ui.sc_name)
				end
			end
		end
	else
		self.stage_left = 0
		clear_table(self.pointers)
		clear_table(self.names)
		clear_table(self.sc_names)
	end
	--boss info
	if precheck and attackcheck then
		local card = boss._bosssys:GetCurrentCard()
		self.lifebar_alpha = math.min(1, self.lifebar_alpha + 0.025)
		if boss.time_sc then
			self.lifebar:set("gray")
			self.lifebar_rate = lerp_pow(self.lifebar_rate, (card.t3 - boss.timer) / card.t3, 0.6)
		elseif card.is_sc then
			self.lifebar:set("red")
			self.lifebar_rate = lerp_pow(self.lifebar_rate, ui.hpbarlen or 0, 0.6)
		else
			self.lifebar:set("green")
			self.lifebar_rate = lerp_pow(self.lifebar_rate, ui.hpbarlen or 0, 0.6)
		end
		self.time_left = ui.countdown or 0
	else
		self.lifebar:set("green")
		self.lifebar_rate = lerp_pow(self.lifebar_rate, 0, 0.6)
		self.lifebar_alpha = math.max(0, self.lifebar_alpha - 0.025)
		self.time_left = 0
	end
	--sc info
	if precheck and boss.sc_bonus and ui.sc_hist then
		self.sc_score = boss.sc_bonus or 0
		self.history_get = ui.sc_hist[1] or 0
		self.history_all = ui.sc_hist[2] or 0
		self.score_alpha = math.min(1, self.score_alpha + 0.025)
	else
		self.sc_score = 0
		self.history_get = 0
		self.history_all = 0
		self.score_alpha = math.max(0, self.score_alpha - 0.025)
	end
	--other
	self.lifebar:update()
	if #self.obj <= 0 then
		self.freet = self.freet - 1
	else
		self.freet = 60
	end
end

function manager:draw()
	local color = Color(self.lifebar_alpha * 255, 255, 255, 255)
	local w = lstg.world

	SetViewMode("ui")
	--lifebar
	local x, y = WorldToUI(24, 236)
	--SetImageState("boss_ui_flower", "", color)
	--Render("boss_ui_flower", x, y, 0, 1)
	self.lifebar:draw(x, y, 1.0, 0.5, self.lifebar_alpha, self.lifebar_rate)
	--time
	SetFontState("ui_font_80green", "", color)
	local time1, time2 = split_time(self.time_left)
	local tx, ty = WorldToUI(-148, 236)
	RenderText("ui_font_80green", time1, tx - 32, ty + 2, 0.54, "right", "vcenter")
	RenderText("ui_font_80green", time2, tx, ty, 0.4, "right", "vcenter")
	--pointer
	for _, v in ipairs(self.pointers) do
		local px, py = WorldToUI(clamp(v, w.l + 20, w.r - 20), w.b)
		Render("boss_ui_pointer", px, py, 0, 1.0)
	end
	--name
	for i, v in ipairs(self.names) do
		local img = EISlib.Boss.Index.GetImageByName(v)
		local px, py = WorldToUI(w.l, w.t - (i - 1) * 172)
		SetImageState(img, "", color)
		Render(img, px, py, 0, 1)
	end

	local color2 = Color(self.score_alpha * 255, 255, 255, 255)

	SetViewMode("worldui")
	--scleft
	local cx, cy = w.l, w.t - 8
	SetImageState("boss_ui_stagebar", "", color)
	Render("boss_ui_stagebar", cx, cy, 0, 1)
	SetImageState("boss_ui_attatype2", "", color)
	for i = 0, (self.stage_left - 1) do
		Render("boss_ui_attatype2", cx + 16 + i * 12, cy + 2, 0, 1)
	end
	--sc info
	SetFontState("ui_font_42green", "", color2)
	local dx, dy = 10, -12
	if self.sc_score > 0 then
		RenderText("ui_font_42green", string.format("%08d", self.sc_score), cx + dx, cy + dy, 0.5, "left", "vcenter")
	else
		RenderText("ui_font_42green", "********", cx + dx, cy + dy, 0.5, "left", "vcenter")
	end
	RenderText("ui_font_42green", string.format("%03d/%03d", self.history_get, self.history_all), cx + dx + 64, cy + dy, 0.5, "left", "vcenter")
	--sc name
	local nx, ny = w.r - 8, w.t - 8
	local color3 = Color(self.score_alpha * 128, 18, 92, 255)
	for i, v in ipairs(self.sc_names) do
		SetImageState("boss_ui_scnamebar", "", color2)
		Render("boss_ui_scnamebar", nx + dx, ny - (i - 1) * 32, 0, 1.0)
		RenderStrokeTTF("Sans24", v,
				nx + dx - 4, nx + dx - 4,
				ny - (i - 1) * 32, ny - (i - 1) * 32,
				2.0, color2,
				1, color3,
				"right", "vcenter")
	end

	SetViewMode("world")
end

function manager:add_object(ui, boss)
	self:remove_object(ui, boss)
	table.insert(self.obj, {
		ui = ui,
		boss = boss,
	})
end

function manager:remove_object(ui, boss)
	for i = #self.obj, 1, -1 do
		local v = self.obj[i]
		if v.ui == ui or v.boss == boss then
			table.remove(self.obj, i)
		end
	end
end

function manager:sort_object()
	for i = #self.obj, 1, -1 do
		local v = self.obj[i]
		if (not IsValid(v.ui)) or (not IsValid(v.boss)) then
			table.remove(self.obj, i)
		end
	end
end

function manager:can_free()
	local t = self.freet
	return (t <= 0)
end

----------------------------------------
---boss ui manager host

local _host = Class(object)

function _host:init()
	self.layer = LAYER_TOP
	self.bound = false
	self.colli = false

	---@type EISlib.Boss.UI
	self.mgr = EISlib.New(manager)
end

function _host:frame()
	self.mgr:update()
	if self.mgr:can_free() then
		self.status = "del"
	end
end

function _host:render()
	self.timer = self.ani
	self.mgr:draw()
end

local _host_instance

local function check_host(ui, boss)
	if not IsValid(_host_instance) then
		_host_instance = New(_host)
	end
	_host_instance.mgr:add_object(ui, boss)
end

----------------------------------------
---boss ui

function boss_ui:init(b)
	self.layer = LAYER_TOP
	self.group = GROUP_GHOST
	self.boss = b

	self.drawhp = true
	self.drawname = true
	self.drawtime = true
	self.drawspell = true
	self.needposition = true
	self.drawpointer = true

	--self.boss.sc_bonus
	self.name = ""--boss name
	self.sc_name = ""--spell card
	self.sc_hist = nil--{get,total}--sc history
	self.hpbarlen = 0--hp rate
	self.countdown = 0--time left

	check_host(self, b)
end

function boss_ui:frame()
	task.Do(self)
	if self.countdown then
		if self.countdown > 5 and self.countdown <= 10 and self.countdown % 1 == 0 then
			PlaySound("timeout")
		end
		if self.countdown > 1 and self.countdown <= 5 and self.countdown % 1 == 0 then
			PlaySound("timeout2")
		end
		if self.countdown > 0 and self.countdown <= 1 and self.countdown % 1 == 0 then
			PlaySound('timeout3')
		end
	end
end

function boss_ui:render()
end
