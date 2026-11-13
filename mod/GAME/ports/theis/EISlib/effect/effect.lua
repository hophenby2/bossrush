---=====================================
---东方祈华梦游戏特效
---author:Xiliusha
---email:Xiliusha@outlook.com
---=====================================

---@type EISlib
local lib = EISlib

---@class EISlib.Effect
local M = {}

---@type EISlib.Effect
lib.Effect = M

M.path = EISlib.path .. "effect/"

local path = M.path
local sin, cos = lstg.sin, lstg.cos

----------------------------------------
---res

local function load_res()
	local S = lstg.ResourceSet.Create("EISlib.effecy", "global")

	S:AddTexture("_effect_par_texture", path .. "item_eff.png", false)
	S:AddSpriteSequence("effect_par", "_effect_par_texture", 0, 0, 128, 128, 4, 4)

	S:AddTexture("_item_hint_new_texture", path .. "hint_new.png", false)
	local ktb = {
		"_hint_attack_time",
		"_hint_real_time",
		"_hint_next_stage",
		"_hint_spellcard_lose",
		"_hint_spellcard_get",
		"_hint_high_socre",
	}
	S:AddSpriteSequence(ktb, "_item_hint_new_texture", 0, 0, 746, 92, 1, 6)
	S:AddSpriteSequence("_hint_extend_", "_item_hint_new_texture", 0, 552, 248, 92, 3, 1)
end
load_res()

lstg.DoFile(path .. "qhm_effect.lua")

----------------------------------------
---item effect

local get_item_hint = Class(object)
function get_item_hint:init(x, y, img, t1, t2)
	self.x = x
	self._y = y
	self.y = y - 64
	self.img = img
	self.t1 = t1
	self.t2 = t2
	self.group = GROUP_GHOST
	self.layer = LAYER_TOP
	self.hscale = 0
	self.vscale = 0
	self.bound = false
	self.colli = false
end
function get_item_hint:frame()
	if self.timer < self.t1 then
		if self.t1 < 2 then
			self.y = self._y
			self.hscale = 1
			self.vscale = 1
		else
			local rate = self.timer / (self.t1 - 1)
			self.y = self._y - 64 + 64 * sin(90 * rate)
			self.hscale = rate
			self.vscale = rate
		end
	elseif self.timer >= (self.t1 + self.t2) then
		self.status = "del"
	end
end
function get_item_hint:render()
	if self.timer <= self.t1 then
		SetImageState(self.img, "", Color(255, 255, 255, 255))
		DefaultRenderFunc(self)
	elseif self.timer > self.t1 and self.timer <= (self.t1 + self.t2) then
		SetImageState(self.img, "", Color(255 * (1 - (self.timer - self.t1) / self.t2), 255, 255, 255))
		DefaultRenderFunc(self)
	end
end

function M.GetLifeEffect()
	PlaySound("extend", 1)
	New(get_item_hint, 0, 120, "_hint_extend_1", 20, 80)
end

function M.GetBombEffect()
	PlaySound("extend", 1)
	New(get_item_hint, 0, 120, "_hint_extend_3", 20, 80)
end

function M.GetBonusEffect()
	PlaySound("extend", 1)
	New(get_item_hint, 0, 120, "_hint_extend_2", 20, 80)
end

function M.ComboAchieveEffect()
	lstg.tmpvar._system_dye_achieve_count = lstg.tmpvar._system_dye_achieve_count or 0
	if lstg.tmpvar._system_dye_achieve_count <= 0 then
		PlaySound("extend", 0.8)
		lstg.tmpvar._system_dye_achieve_mark = true
	end
	lstg.tmpvar._system_dye_achieve_count = lstg.tmpvar._system_dye_achieve_count + 1
end

local float_text = Class(object)
function float_text:init(fnt, text, x, y, v, angle, life_time, size1, size2, color1, color2)
	self.fnt = fnt
	self.text = text
	self.x = x
	self.y = y
	self.vx = v * cos(angle)
	self.vy = v * sin(angle)
	self.life_time = life_time
	self.size1 = size1
	self.size2 = size2
	self.color1 = color1
	self.color2 = color2
end
function float_text:frame()
	if self.timer == self.life_time - 1 then
		self.status = "del"
	end
end
function float_text:render()
	local t = (self.life_time - self.timer) / self.life_time
	local size = self.size1 * t + self.size2 * (1 - t)
	local c = self.color1 * t + self.color2 * (1 - t)
	SetFontState(self.fnt, "", c)
	RenderText(self.fnt, self.text, self.x, self.y, size, "left", "vcenter")
end

function M.GetScoreEffect(x, y, score)
	New(float_text, "system_font_item", score,
			x + 16, y + 8, --x,y
			0.5, 30, --v,a
			60, --time
			1, 1, --scale begin,scale end
			Color(0x80FFFF00), Color(0x00FFFF00))--color begin,color end
	--if self.attract == 8 then
	--New(float_text, 'item', score, self.x, self.y + 6, 0.75, 90, 60, 1, 1, Color(0x80FFFF00), Color(0x00FFFF00))
	--else
	--New(float_text, 'item', score, self.x, self.y + 6, 0.75, 90, 60, 1, 1, Color(0x80FFFFFF), Color(0x00FFFFFF))
	--end
end

----------------------------------------
---enemy effect

function M.DamageEnemyEffect(self)
	if self.dmg_factor then
		-- boss类型
		if self.hp > 200 then
			PlaySound("damage00", 1)
		else
			PlaySound("damage01", 1)
		end
	else
		-- 小怪类型
		if self.hp > 60 then
			if self.hp > self.maxhp * 0.2 then
				PlaySound("damage00", 1)
			else
				PlaySound("damage01", 1)
			end
		else
			PlaySound("damage00", 1)
		end
	end
end

function M.EnenyDeathEffect(self)
	--New(enemy_death_ef, self.death_ef, self.x, self.y)
end

----------------------------------------
---boss effect

local boss_card_hint = Class(object)

function boss_card_hint:init(x, y, score, time)
	self.x = x
	self.y = y
	self.group = GROUP_GHOST
	self.layer = LAYER_TOP
	self.alpha = 0
	self.time = time
	self.score = score
	self.failed = (score <= 0)
end

function boss_card_hint:frame()
	if self.timer <= 20 then
		self.alpha = self.timer / 20
	elseif self.timer > 100 and self.timer <= 120 then
		self.alpha = 1 - ((self.timer - 100) / 20)
	elseif self.timer > 120 then
		self.status = "del"
	end
end

function boss_card_hint:render()
	local color = Color(self.alpha * 255, 255, 255, 255)
	local color2 = Color(self.alpha * 255, 160, 160, 160)
	local function time_dw(dy)
		if self.time then
			SetImageState("_hint_attack_time", "", color)
			Render("_hint_attack_time", self.x - 48, self.y + dy, 0, 1)
			SetFontState("ui_font_42black", "", color2)
			RenderText("ui_font_42black", string.format("%.2f", self.time), self.x + 72, self.y + dy, 1, "right", "vcenter")
		end
	end
	if self.failed then
		SetImageState("_hint_spellcard_lose", "", color)
		Render("_hint_spellcard_lose", self.x, self.y, 0, 1)
		time_dw(-32)
	else
		SetImageState("_hint_spellcard_get", "", color)
		Render("_hint_spellcard_get", self.x, self.y, 0, 1)
		SetFontState("ui_font_42green", "", color)
		RenderText("ui_font_42green", string.format("%d", self.score), self.x, self.y - 32, 1.20, "center", "vcenter")
		--RenderText("ui_font_42green", score_to_string(self.score), self.x, self.y-32, 1.20, "center", "vcenter")
		time_dw(-64)
	end
end

---score小于等于0时为Failed
function M.SpellCardFinishEffect(score, time)
	New(boss_card_hint, 0, 80, score, time)
end

boss_cast_ef = Class(object)

function boss_cast_ef:init(x, y)
	self.hide = true
	PlaySound("ch00", 0.5, 0)
	for i = 1, 50 do
		local angle = ran:Float(0, 360)
		local lifetime = ran:Int(50, 80)
		local l = ran:Float(300, 500)
		New(boss_cast_ef_unit, x + l * cos(angle), y + l * sin(angle), l / lifetime, angle + 180, lifetime, ran:Float(0.75, 1))
	end
	Del(self)
end

boss_cast_ef_unit = Class(object)

function boss_cast_ef_unit:init(x, y, v, angle, lifetime, size)
	self.x = x
	self.y = y
	self.rot = ran:Float(0, 360)
	SetV(self, v, angle)
	self.lifetime = lifetime
	self.omiga = 5
	self.layer = LAYER_ENEMY - 50
	self.group = GROUP_GHOST
	self.bound = false
	self.img = "effect_par2"
	self.hscale = size
	self.vscale = size
end

function boss_cast_ef_unit:frame()
	if self.timer == self.lifetime then
		Del(self)
	end
end

function boss_cast_ef_unit:render()
	if self.timer > self.lifetime - 15 then
		SetImageState(self.img, 'mul+add', Color((self.lifetime - self.timer) * 12, 255, 255, 255))
	else
		SetImageState(self.img, 'mul+add', Color((self.timer / (self.lifetime - 15)) ^ 6 * 180, 255, 255, 255))
	end
	DefaultRenderFunc(self)
end

boss_death_ef = Class(object)

function boss_death_ef:init(x, y)
	PlaySound("enep01", 0.4, 0)
	self.hide = true
	misc.ShakeScreen(20, 4)
	for i = 1, 100 do
		local angle = ran:Float(0, 360)
		local lifetime = ran:Int(60, 120)
		local l = ran:Float(100, 400)
		New(boss_death_ef_unit, x, y, l / lifetime, angle, lifetime, ran:Float(1, 1.25))
	end
	Del(self)--哪个傻吊把这个漏了……
end

boss_death_ef_unit = Class(object)

function boss_death_ef_unit:init(x, y, v, angle, lifetime, size)
	self.x = x
	self.y = y
	SetV(self, v, angle)
	self.rot = ran:Float(0, 360)
	self.lifetime = lifetime
	self.omiga = 3
	self.layer = LAYER_ENEMY + 50
	self.group = GROUP_GHOST
	self.bound = false
	self.img = "tree_leaf_white"
	self.size = size
	self.hscale = size
	self.vscale = size
	self.rate = ran:Float(0, 360)
end

function boss_death_ef_unit:frame()
	if self.timer == self.lifetime then
		Del(self)
	end
	self.hscale = self.size * sin(self.rate)
	self.rate = self.rate + 2
end

function boss_death_ef_unit:render()
	if self.timer < 15 then
		SetImageState(self.img, 'mul+add', Color(self.timer * 12, 255, 255, 255))
	else
		SetImageState(self.img, 'mul+add', Color(((self.lifetime - self.timer) / (self.lifetime - 15)) * 180, 255, 255, 255))
	end
	DefaultRenderFunc(self)
end

----------------------------------------
---stage effect

mask_fader = Class(object)

mask_fader.needfull = false

function mask_fader:init(mode)
	self.layer = LAYER_TOP + 100
	self.group = GROUP_GHOST
	self.open = (mode == "open")
end

function mask_fader:frame()
	if self.timer > 30 then
		self.status = "del"
	end
end

function mask_fader:render()
	if self.open then
		SetImageState('white', '', Color(max(0, min(255, 255 - self.timer * 8.5)), 0, 0, 0))
	else
		SetImageState('white', '', Color(max(0, min(255, self.timer * 8.5)), 0, 0, 0))
	end
	if mask_fader.needfull then
		SetViewMode("screen")
		RenderRect("white", 0, setting.resx, 0, setting.resy)
		SetViewMode("world")
	else
		RenderRect("white", -32768, 32767, -32768, 32767)
	end
end

lstg.EventDispatcher.AddListener("mask_fader.needfullscreen", EVENT.STAGE_CHANGE_BEFORE, 0, function(arg)
	local last_is_menu = false
	local next_is_menu = false
	if stage.current_stage then
		last_is_menu = stage.current_stage.is_menu
	end
	if stage.next_stage then
		next_is_menu = stage.next_stage.is_menu
	end
	if (last_is_menu and (not next_is_menu)) or ((not last_is_menu) and next_is_menu) then
		-- 在主菜单和关卡之间切换
		mask_fader.needfull = true
	elseif (not last_is_menu) and (not next_is_menu) then
		-- 关卡之间切换
		mask_fader.needfull = false
	else
		-- 其他情况，比如主菜单之间
		mask_fader.needfull = true
	end
end)

----------------------------------------
--- settlement screen

-- 依赖的字体文件 "res/font/PMZDBT.ttf"
-- 依赖的图片资源 "white"; "_ui_16_9_stageclear"; "_ui_16_9_allclear"
local settlement_obj = Class(object)
function settlement_obj:init(data)
	data = data or {
		clear_bonus = 399999999,
		chain_count = 999,
		chain_bonus = 499999999,
		blue_count = 1000,
		blue_bonus = 599999999,
		kill_rate = 1.0,
		diff_rate = 2.0,
		total_bonus = 699999999,

		life_count = 8,
		life_bonus = 799999999,
		bomb_count = 2,
		bomb_bonus = 899999999,

		all_clear = true,
	}
	local F = string.format
	local N = string.format_number
	local function rank_name()
		---@type stage.group.gamestage
		local s = stage.current_stage
		local n = "Normal"
		if s.group and s.group.name then
			n = s.group.name
		end
		local map = {
			["Easy"] = "Easy Rank",
			["Normal"] = "Normal Rank",
			["Hard"] = "Hard Rank",
			["Lunatic"] = "Lunatic Rank",
			["Ultra"] = "Ultra Rank",
			["Extra"] = "Extra Rank",
			["Practice Easy"] = "Easy Rank",
			["Practice Normal"] = "Normal Rank",
			["Practice Hard"] = "Hard Rank",
			["Practice Lunatic"] = "Lunatic Rank",
			["Practice Ultra"] = "Ultra Rank",
			["Practice Extra"] = "Extra Rank",
			["Boss Easy"] = "Easy Rank",
			["Boss Normal"] = "Normal Rank",
			["Boss Hard"] = "Hard Rank",
			["Boss Lunatic"] = "Lunatic Rank",
			["Boss Ultra"] = "Ultra Rank",
			["Boss Extra"] = "Extra Rank",
		}
		return map[n] or "Rank"
	end
	if not data.all_clear then
		self.text_lcr = {
			{  "Clear Bonus",                                             "", N(data.clear_bonus)},
			{ "Chain Dyeing",         F("%d", data.chain_count), N(data.chain_bonus)},
			{    "Blue Item",          F("%d", data.blue_count),  N(data.blue_bonus)},
			{"Shooting Down", F("%.0f%%", data.kill_rate * 100),                  ""},
			{    rank_name(),        F("x%.1f", data.diff_rate),                  ""},
			total = {"Total",                                             "", N(data.total_bonus)},
			skip = "Press [shoot] to continue",
		}
	else
		self.text_lcr = {
			{  "Clear Bonus",                                             "", N(data.clear_bonus)},
			{ "Chain Dyeing",         F("%d", data.chain_count), N(data.chain_bonus)},
			{    "Blue Item",          F("%d", data.blue_count),  N(data.blue_bonus)},
			{         "Life",         F("x%d", data.life_count),  N(data.life_bonus)},
			{         "Bomb",         F("x%d", data.bomb_count),  N(data.bomb_bonus)},
			{"Shooting Down", F("%.0f%%", data.kill_rate * 100),                  ""},
			{    rank_name(),        F("x%.1f", data.diff_rate),                  ""},
			total = {"Total",                                             "", N(data.total_bonus)},
			skip = "Press [shoot] to continue",
		}
	end
	self.all = data.all_clear
	self.alpha = 0
	self.yoffset = 0
	task.New(self, function()
		PlaySound("extend", 1.0) -- 播放音效是必须的
		for i = 1, 30 do
			local k = i / 30
			local ks = lstg.sin(k * 90)
			self.alpha = k
			self.yoffset = -4 + 4 * ks
			task.Wait(1)
		end
		-- 应该不会有人盯着看一分钟吧……
		for _ = 1, 3600 do
			if KeyTrigger("shoot") then
				break
			end
			task.Wait(1)
		end
		for i = 1, 30 do
			local k = i / 30
			local k2 = 1 - k
			local ks2 = lstg.sin(k2 * 90)
			self.alpha = k2
			self.yoffset = 4 - 4 * ks2
			task.Wait(1)
		end
		self.status = "del"
	end)
end
function settlement_obj:frame()
	local emmy
	task.Do(self)
end
function settlement_obj:render()
	local gs = lstg.globalimagescale
	lstg.globalimagescale = 1
	SetViewMode("world")

	local _03 = 0.333333333333333
	local x, y = 0, 64 + self.yoffset
	local scale = 1
	local colorW = lstg.Color(self.alpha * 255, 255, 255, 255)
	local colorB = lstg.Color(self.alpha * 255, 0, 0, 0)
	local all = self.all

	-- 背景
	lstg.SetImageState("white", "", lstg.Color(self.alpha * 80, 0, 0, 0))
	lstg.RenderRect("white", lstg.world.l, lstg.world.r, lstg.world.b, lstg.world.t)

	-- 上面的标题
	if not all then
		lstg.SetImageState("_ui_16_9_stageclear", "", colorW)
		lstg.Render("_ui_16_9_stageclear", x, y + scale * 80, 0, scale * _03)
	else
		lstg.SetImageState("_ui_16_9_allclear", "", colorW)
		lstg.Render("_ui_16_9_allclear", x, y + scale * 80, 0, scale * _03)
	end

	local line_height = 24
	local text_lcr = self.text_lcr

	-- 单个项目部分
	for i, s in ipairs(text_lcr) do
		RenderStrokeTTF("PMZDBT", s[1],
				x - scale * 180, x - scale * 180, y - (i - 1) * scale * line_height, y - (i - 1) * scale * line_height,
				scale * 1, colorW,
				scale * 1, colorB,
				"left", "vcenter")
		RenderStrokeTTF("PMZDBT", s[2],
				x + scale * 32, x + scale * 32, y - (i - 1) * scale * line_height, y - (i - 1) * scale * line_height,
				scale * 1, colorW,
				scale * 1, colorB,
				"right", "vcenter")
		RenderStrokeTTF("PMZDBT", s[3],
				x + scale * 180, x + scale * 180, y - (i - 1) * scale * line_height, y - (i - 1) * scale * line_height,
				scale * 1, colorW,
				scale * 1, colorB,
				"right", "vcenter")
	end

	-- 总计奖励部分
	RenderStrokeTTF("PMZDBT", text_lcr.total[1],
			x - scale * 180, x - scale * 180, y - (#text_lcr + 1) * scale * line_height, y - (#text_lcr + 1) * scale * line_height,
			scale * 1, colorW,
			scale * 1, colorB,
			"left", "vcenter")
	RenderStrokeTTF("PMZDBT", text_lcr.total[2],
			x - scale * 32, x - scale * 32, y - (#text_lcr + 1) * scale * line_height, y - (#text_lcr + 1) * scale * line_height,
			scale * 1, colorW,
			scale * 1, colorB,
			"left", "vcenter")
	RenderStrokeTTF("PMZDBT", text_lcr.total[3],
			x + scale * 180, x + scale * 180, y - (#text_lcr + 1) * scale * line_height, y - (#text_lcr + 1) * scale * line_height,
			scale * 1, colorW,
			scale * 1, colorB,
			"right", "vcenter")

	-- 操作提示
	RenderStrokeTTF("PMZDBT", text_lcr.skip,
			x, x, y - (#text_lcr + 3) * scale * line_height, y - (#text_lcr + 3) * scale * line_height,
			scale * 1, colorW,
			scale * 1, colorB,
			"center", "vcenter")

	lstg.globalimagescale = gs
	SetViewMode("world")
end

function M.StageSettlement(data)
	local obj = New(settlement_obj, data)
	while IsValid(obj) do
		task.Wait(1)
	end
end

----------------------------------------
--- BGM

local music_name_obj = Class(object)
function music_name_obj:init(name)
	self.bound = false
	self.x = lstg.world.l + 4
	self.y = lstg.world.b + 6
	self.alpha = 0
	self._dy = -0
	if not lstg.tmpvar._music_info_cache then
		local info = i18n.loadjson("music.json")
		if info then
			-- 预处理，把score转换为deathmusic
			for i, v in ipairs(info.index) do
				if v == "score" then
					info.index[i] = "deathmusic"
				end
			end
			if info["score"] then
				info["deathmusic"] = info["score"]
				info["score"] = nil
			end
			lstg.tmpvar._music_info_cache = info
		else
			lstg.tmpvar._music_info_cache = {}
		end
	end
	local info = lstg.tmpvar._music_info_cache
	if info[name] then
		self.text = "♪ " ..info[name].name
	else
		self.text = "♪ " .. i18n("menu.musicroom.unknown")
	end
	task.New(self, function()
		for i = 1, 60 do
			self.alpha = i / 60
			self._dy = -16 + 16 * sin((i / 60) * 90)
			task.Wait(1)
		end
		task.Wait(120)
		for i = 59, 0, -1 do
			self.alpha = i / 60
			self._dy = -16 + 16 * sin((i / 60) * 90)
			task.Wait(1)
		end
		self.status = "del"
	end)
end
function music_name_obj:frame()
	task.Do(self)
end
function music_name_obj:render()
	SetViewMode("worldui")
	RenderStrokeTTF("Sans24", self.text,
			self.x, self.x, self.y + self._dy, self.y + self._dy,
			2, Color(self.alpha * 255, 255, 255, 255),
			0.5, Color(self.alpha * 255, 0, 0, 0),
			"left", "bottom")
	SetViewMode("world")
end

---@param bgmname string
function M.PopMusicName(bgmname)
	local emmy = 0
	New(music_name_obj, bgmname)
end
