local PRELOAD = EISlib.ui.PRELOAD

----------------------------------------
--region res

local path = "res/ui/"
local _bg_tex_1 = "_tex_ui_stage_bg_16_9_1"
local _ui_tex_1 = "_tex_ui_item_16_9_1"
local _ui_tex_2 = "_tex_ui_item_16_9_2"
local _group_index = {
	["Easy"] = 1,
	["Normal"] = 2,
	["Hard"] = 3,
	["Lunatic"] = 4,
	["Ultra"] = 5,
	["Extra"] = 6,
	["Practice Easy"] = 1,
	["Practice Normal"] = 2,
	["Practice Hard"] = 3,
	["Practice Lunatic"] = 4,
	["Practice Ultra"] = 5,
	["Practice Extra"] = 6,
	["Boss Easy"] = 1,
	["Boss Normal"] = 2,
	["Boss Hard"] = 3,
	["Boss Lunatic"] = 4,
	["Boss Ultra"] = 5,
	["Boss Extra"] = 6,
}

local res_tag = "stage"
if PRELOAD then
	res_tag = "global"
end
local res = lstg.ResourceSet.Create("EISlib.ui", res_tag)

local function load_ui_res()
	---- 第一部分
	res:AddTexture(_bg_tex_1, path .. "ui_stage_bg_16_9_1.png", false)
	-- 背景
	res:AddSprite("_ui_16_9_bg1", _bg_tex_1, 0, 0, 2048, 1440)
	res:AddSprite("_ui_16_9_bg2", _bg_tex_1, 0, 1536, 1440, 512)
	res:SetSpriteCenter("_ui_16_9_bg1", 2048, 0)
	res:SetSpriteCenter("_ui_16_9_bg2", 0, 0)
	-- 版面框架
	res:AddSprite("_ui_16_9_frame1", _bg_tex_1, 1456, 1552, 48, 48)
	res:AddSprite("_ui_16_9_frame2", _bg_tex_1, 1504, 1552, 64, 48)
	res:AddSprite("_ui_16_9_frame3", _bg_tex_1, 1568, 1552, 48, 48)
	res:AddSprite("_ui_16_9_frame4", _bg_tex_1, 1456, 1600, 48, 64)
	res:AddSprite("_ui_16_9_frame5", _bg_tex_1, 1504 + 8, 1600 + 8, 48, 48)
	res:AddSprite("_ui_16_9_frame6", _bg_tex_1, 1568, 1600, 48, 64)
	res:AddSprite("_ui_16_9_frame7", _bg_tex_1, 1456, 1664, 48, 48)
	res:AddSprite("_ui_16_9_frame8", _bg_tex_1, 1504, 1664, 64, 48)
	res:AddSprite("_ui_16_9_frame9", _bg_tex_1, 1568, 1664, 48, 48)
	res:SetSpriteCenter("_ui_16_9_frame1", 48, 48)
	res:SetSpriteCenter("_ui_16_9_frame2", 32, 48)
	res:SetSpriteCenter("_ui_16_9_frame3", 0, 48)
	res:SetSpriteCenter("_ui_16_9_frame4", 48, 32)
	res:SetSpriteCenter("_ui_16_9_frame6", 0, 32)
	res:SetSpriteCenter("_ui_16_9_frame7", 48, 0)
	res:SetSpriteCenter("_ui_16_9_frame8", 32, 0)
	res:SetSpriteCenter("_ui_16_9_frame9", 0, 0)
	---- 第二部分
	res:AddTexture(_ui_tex_1, path .. "ui_item_16_9_1.png", false)
	-- 小字体
	for i, c in ipairs({"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ",", ".", "%", "/", "+", "-", "x"}) do
		res:AddSprite("_ui_16_9_small_font_C" .. c, _ui_tex_1, (i - 1) * 48, 1328, 48, 80)
	end
	-- 特殊符号
	res:AddSprite("_ui_16_9_small_font_infinite", _ui_tex_1, 816, 1328, 96, 80)
	-- 超大LOGO
	res:AddSprite("_ui_16_9_logo", _ui_tex_1, 0, 0, 620, 1300)
	-- 关卡组
	for idx = 1, 6 do
		res:AddSprite("_ui_16_9_rank" .. idx, _ui_tex_1, 622, (idx - 1) * 140, 400, 140)
	end
	-- 信息栏
	for idx = 1, 5 do
		res:AddSprite("_ui_16_9_infobar" .. idx, _ui_tex_1, 1024, (idx - 1) * 88, 564, 88)
	end
	-- 底端血条
	res:AddSprite("_ui_16_9_hpbarbg", _ui_tex_1, 0, 1302, 1150, 12)
	-- 雷和残
	res:AddSprite("_ui_16_9_life0", _ui_tex_1, 1590, 0, 72, 72)
	res:AddSprite("_ui_16_9_life1", _ui_tex_1, 1590 + 72, 0, 72, 72)
	res:AddSprite("_ui_16_9_bomb0", _ui_tex_1, 1590, 72, 72, 72)
	res:AddSprite("_ui_16_9_bomb1", _ui_tex_1, 1590 + 72, 72, 72, 72)
	-- 雷条和残条
	res:AddSprite("_ui_16_9_lifebar", _ui_tex_1, 1024, 528, 564, 22)
	res:AddSprite("_ui_16_9_bombbar", _ui_tex_1, 1024, 572, 564, 22)
	-- 道具板
	res:AddSprite("_ui_16_9_item_frame", _ui_tex_1, 1156, 1750, 710, 170)
	-- 染色板
	res:AddSprite("_ui_16_9_dye_frame", _ui_tex_1, 1156, 1384, 710, 366)
	res:AddSprite("_ui_16_9_dye_current_mark", _ui_tex_1, 1531, 618, 507, 507)
	res:AddSprite("_ui_16_9_dye_other_mark", _ui_tex_1, 1548, 1127, 160, 160)
	-- 关卡结算2
	res:AddSprite("_ui_16_9_allclear", _ui_tex_1, 0, 1752, 948, 296)
	---- 第三部分
	res:AddTexture(_ui_tex_2, path .. "ui_item_16_9_2.png", false)
	-- 大的你妈的离谱的字体
	for i, c in ipairs({"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ",", ".", "%", "/"}) do
		res:AddSprite("_ui_16_9_big_font_gray_C" .. c, _ui_tex_2, (i - 1) * 144, 0, 144, 240)
	end
	for i, c in ipairs({"+", "-", "x"}) do
		res:AddSprite("_ui_16_9_big_font_gray_C" .. c, _ui_tex_2, (i - 1) * 144, 720, 144, 240)
	end
	for i, c in ipairs({"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ",", ".", "%", "/"}) do
		res:AddSprite("_ui_16_9_big_font_color_C" .. c, _ui_tex_2, (i - 1) * 144, 240, 144, 240)
	end
	for i, c in ipairs({"+", "-", "x"}) do
		res:AddSprite("_ui_16_9_big_font_color_C" .. c, _ui_tex_2, 432 + (i - 1) * 144, 720, 144, 240)
	end
	for i, c in ipairs({"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ",", ".", "%", "/"}) do
		res:AddSprite("_ui_16_9_big_font_blue_C" .. c, _ui_tex_2, (i - 1) * 144, 480, 144, 240)
	end
	for i, c in ipairs({"+", "-", "x"}) do
		res:AddSprite("_ui_16_9_big_font_blue_C" .. c, _ui_tex_2, 864 + (i - 1) * 144, 720, 144, 240)
	end
	-- 特殊符号
	res:AddSprite("_ui_16_9_big_font_color_infinite", _ui_tex_2, 1584, 720, 288, 240)
	-- lastspell锁残禁雷
	for i = 1, 3 do
		res:AddSprite("_ui_16_9_forbid" .. (i + 0), _ui_tex_2, 1316 + (i - 1) * 200,  960, 200, 200)
		res:AddSprite("_ui_16_9_forbid" .. (i + 3), _ui_tex_2, 1316 + (i - 1) * 200, 1160, 200, 200)
	end
	-- boss 名字
	for i = 1, 16 do
		res:AddSprite("_ui_16_9_bossname" .. i, _ui_tex_2, (i - 1) * 64,  1520, 64, 346)
		res:SetSpriteCenter("_ui_16_9_bossname" .. i, 64, 0)
	end
	-- 关卡结算1
	res:AddSprite("_ui_16_9_stageclear", _ui_tex_2, 1024, 1520, 948, 428)
end
load_ui_res()

--endregion
----------------------------------------
--region font define

local small_font = {
	imgs = {
		["0"] = {"_ui_16_9_small_font_C0", 15, 15},
		["1"] = {"_ui_16_9_small_font_C1", 15, 15},
		["2"] = {"_ui_16_9_small_font_C2", 15, 15},
		["3"] = {"_ui_16_9_small_font_C3", 15, 15},
		["4"] = {"_ui_16_9_small_font_C4", 15, 15},
		["5"] = {"_ui_16_9_small_font_C5", 15, 15},
		["6"] = {"_ui_16_9_small_font_C6", 15, 15},
		["7"] = {"_ui_16_9_small_font_C7", 15, 15},
		["8"] = {"_ui_16_9_small_font_C8", 15, 15},
		["9"] = {"_ui_16_9_small_font_C9", 15, 15},
		[","] = {"_ui_16_9_small_font_C,",  2,  2},
		["."] = {"_ui_16_9_small_font_C.", 12,  0},
		["%"] = {"_ui_16_9_small_font_C%", 15, 15},
		["/"] = {"_ui_16_9_small_font_C/", 14, 14},
		["+"] = {"_ui_16_9_small_font_C+", 15, 15},
		["-"] = {"_ui_16_9_small_font_C-", 15, 15},
		["x"] = {"_ui_16_9_small_font_Cx", 15, 15},
	},
	width = 48,
	height = 80,
	advance = 32,
}
setmetatable(small_font.imgs, { __index = function() return "img_void" end})

local big_font_gray = {
	imgs = {
		["0"] = {"_ui_16_9_big_font_gray_C0", 46, 46},
		["1"] = {"_ui_16_9_big_font_gray_C1", 46, 46},
		["2"] = {"_ui_16_9_big_font_gray_C2", 46, 46},
		["3"] = {"_ui_16_9_big_font_gray_C3", 46, 46},
		["4"] = {"_ui_16_9_big_font_gray_C4", 46, 46},
		["5"] = {"_ui_16_9_big_font_gray_C5", 46, 46},
		["6"] = {"_ui_16_9_big_font_gray_C6", 46, 46},
		["7"] = {"_ui_16_9_big_font_gray_C7", 46, 46},
		["8"] = {"_ui_16_9_big_font_gray_C8", 46, 46},
		["9"] = {"_ui_16_9_big_font_gray_C9", 46, 46},
		[","] = {"_ui_16_9_big_font_gray_C,", 46, 46},
		["."] = {"_ui_16_9_big_font_gray_C.", 46, 46},
		["%"] = {"_ui_16_9_big_font_gray_C%", 46, 46},
		["/"] = {"_ui_16_9_big_font_gray_C/", 46, 46},
		["+"] = {"_ui_16_9_big_font_gray_C+", 46, 46},
		["-"] = {"_ui_16_9_big_font_gray_C-", 46, 46},
		["x"] = {"_ui_16_9_big_font_gray_Cx", 46, 46},
	},
	width = 144,
	height = 240,
	advance = 128,
}
setmetatable(big_font_gray.imgs, { __index = function() return "img_void" end})

local big_font_color = {
	imgs = {
		["0"] = {"_ui_16_9_big_font_color_C0", 46, 46},
		["1"] = {"_ui_16_9_big_font_color_C1", 46, 46},
		["2"] = {"_ui_16_9_big_font_color_C2", 46, 46},
		["3"] = {"_ui_16_9_big_font_color_C3", 46, 46},
		["4"] = {"_ui_16_9_big_font_color_C4", 46, 46},
		["5"] = {"_ui_16_9_big_font_color_C5", 46, 46},
		["6"] = {"_ui_16_9_big_font_color_C6", 46, 46},
		["7"] = {"_ui_16_9_big_font_color_C7", 46, 46},
		["8"] = {"_ui_16_9_big_font_color_C8", 46, 46},
		["9"] = {"_ui_16_9_big_font_color_C9", 46, 46},
		[","] = {"_ui_16_9_big_font_color_C,", 46, 46},
		["."] = {"_ui_16_9_big_font_color_C.", 46, 46},
		["%"] = {"_ui_16_9_big_font_color_C%", 46, 46},
		["/"] = {"_ui_16_9_big_font_color_C/", 46, 46},
		["+"] = {"_ui_16_9_big_font_color_C+", 46, 46},
		["-"] = {"_ui_16_9_big_font_color_C-", 46, 46},
		["x"] = {"_ui_16_9_big_font_color_Cx", 46, 46},
	},
	width = 144,
	height = 240,
	advance = 128,
}
setmetatable(big_font_color.imgs, { __index = function() return "img_void" end})

--endregion
----------------------------------------
--region progress bar define

local life_bar = {
	img_bottom = "_ui_16_9_lifebar",
	img_top = "img_void",
	tex = _ui_tex_1,
	x = 1030,
	y = 556,
	w = 552,
	h = 9,
}

local bomb_bar = {
	img_bottom = "_ui_16_9_bombbar",
	img_top = "img_void",
	tex = _ui_tex_1,
	x = 1030,
	y = 600,
	w = 552,
	h = 9,
}

local hp_bar = {
	img_bottom = "img_void",
	img_top = "img_void",
	tex = _ui_tex_1,
	x = 2,
	y = 1316,
	w = 1146,
	h = 8,
}

--endregion
----------------------------------------
--region function

local function SimpleRenderText(def, text, x, y, rot, hscale, vscale, align)
	local ax, ay = lstg.cos(rot), lstg.sin(rot)
	local len = string.len(text)
	local I, C = def.imgs
	if align == "left" then
		for i = 1, len do
			C = I[string.sub(text, i, i)]
			x = x + C[2] * ax * hscale
			y = y + C[2] * ay * vscale
			lstg.Render(C[1], x, y, rot, hscale, vscale)
			x = x + C[3] * ax * hscale
			y = y + C[3] * ay * vscale
		end
	elseif align == "right" then
		for i = len, 1, -1 do
			C = I[string.sub(text, i, i)]
			x = x - C[3] * ax * hscale
			y = y - C[3] * ay * vscale
			lstg.Render(C[1], x, y, rot, hscale, vscale)
			x = x - C[2] * ax * hscale
			y = y - C[2] * ay * vscale
		end
	elseif align == "center" then
		local wx, wy = 0, 0
		for i = 1, len do
			C = I[string.sub(text, i, i)]
			wx = wx + C[2] * ax * hscale + C[3] * ax * hscale
			wy = wy + C[2] * ay * hscale + C[3] * ay * hscale
		end
		x = x - (wx / 2)
		y = y - wy
		for i = 1, len do
			C = I[string.sub(text, i, i)]
			x = x + C[2] * ax * hscale
			y = y + C[2] * ay * vscale
			lstg.Render(C[1], x, y, rot, hscale, vscale)
			x = x + C[3] * ax * hscale
			y = y + C[3] * ay * vscale
		end
	end
end

local function SimpleSetTextState(def, blend, color)
	for _, v in pairs(def.imgs) do
		lstg.SetImageState(v[1], blend, color)
	end
end

local function SimpleRenderProgressBar(def, x, y, rot, hscale, vscale, align, k)
	local color = lstg.Color(1 * 255, 255, 255, 255)
	lstg.SetImageState(def.img_bottom, "", color)
	lstg.Render(def.img_bottom, x, y, rot, hscale, vscale)
	local cv00, sv00 = lstg.cos(rot), lstg.sin(rot)
	local cv90, sv90 = lstg.cos(rot + 90), lstg.sin(rot + 90)
	local cw = cv00 * (def.w / 2) * hscale
	local sw = sv00 * (def.w / 2) * hscale
	local ch = cv90 * (def.h / 2) * vscale
	local sh = sv90 * (def.h / 2) * vscale
	local cl = cv00 * k * def.w * hscale
	local sl = sv00 * k * def.w * hscale
	if align == "left" then
		local x1 = x - cw + ch
		local y1 = y - sw + sh
		local x4 = x - cw - ch
		local y4 = y - sw - sh
		local x2 = x1 + cl
		local y2 = y1 + sl
		local x3 = x4 + cl
		local y3 = y4 + sl
		lstg.RenderTexture(def.tex, "",
				{ x1, y1, 0.5,             def.x,         def.y, color },
				{ x2, y2, 0.5, def.x + k * def.w,         def.y, color },
				{ x3, y3, 0.5, def.x + k * def.w, def.y + def.h, color },
				{ x4, y4, 0.5,             def.x, def.y + def.h, color })
	elseif align == "right" then
		local x2 = x + cw + ch
		local y2 = y + sw + sh
		local x3 = x + cw - ch
		local y3 = y + sw - sh
		local x1 = x2 - cl
		local y1 = y2 - sl
		local x4 = x3 - cl
		local y4 = y3 - sl
		lstg.RenderTexture(def.tex, "",
				{ x1, y1, 0.5, def.x + def.w - k * def.w,         def.y, color },
				{ x2, y2, 0.5,             def.x + def.w,         def.y, color },
				{ x3, y3, 0.5,             def.x + def.w, def.y + def.h, color },
				{ x4, y4, 0.5, def.x + def.w - k * def.w, def.y + def.h, color })
	elseif align == "centercut" then
		local x11, x21, x31 = x - cw * k + ch, x + ch, x + cw * k + ch
		local x12, x22, x32 = x - cw * k - ch, x - ch, x + cw * k - ch
		local y11, y21, y31 = y - sw * k + sh, y + sh, y + sw * k + sh
		local y12, y22, y32 = y - sw * k - sh, y - sh, y + sw * k - sh
		lstg.RenderTexture(def.tex, "",
				{ x11, y11, 0.5,                   def.x,         def.y, color },
				{ x21, y21, 0.5, def.x + k * 0.5 * def.w,         def.y, color },
				{ x22, y22, 0.5, def.x + k * 0.5 * def.w, def.y + def.h, color },
				{ x12, y12, 0.5,                   def.x, def.y + def.h, color })
		local u = def.x + def.w
		lstg.RenderTexture(def.tex, "",
				{ x21, y21, 0.5, u - k * 0.5 * def.w,         def.y, color },
				{ x31, y31, 0.5,                   u,         def.y, color },
				{ x32, y32, 0.5,                   u, def.y + def.h, color },
				{ x22, y22, 0.5, u - k * 0.5 * def.w, def.y + def.h, color })
	end
	lstg.SetImageState(def.img_top, "", color)
	lstg.Render(def.img_top, x, y, rot, hscale, vscale)
end

local function DrawWorldFrame(x, y, width, height)
	local W, H = 64, 64 -- 中央的图的大小
	local S = 0.25 -- 像素缩放
	local ph, pv = 1 / W, 1 / H
	local w2, h2 = width / 2, height / 2
	-- 正中央
	lstg.Render("_ui_16_9_frame5", x, y, 0, width / 48, height / 48)
	-- 四个边角
	lstg.Render("_ui_16_9_frame1", x - w2, y + h2, 0, S, S)
	lstg.Render("_ui_16_9_frame3", x + w2, y + h2, 0, S, S)
	lstg.Render("_ui_16_9_frame7", x - w2, y - h2, 0, S, S)
	lstg.Render("_ui_16_9_frame9", x + w2, y - h2, 0, S, S)
	-- 左右两边
	lstg.Render("_ui_16_9_frame4", x - w2, y, 0, S, height * pv)
	lstg.Render("_ui_16_9_frame6", x + w2, y, 0, S, height * pv)
	-- 上下两边
	lstg.Render("_ui_16_9_frame2", x, y + h2, 0, width * ph, S)
	lstg.Render("_ui_16_9_frame8", x, y - h2, 0, width * ph, S)
end

local function DrawItemFrame(x, y, scale, data)
	lstg.Render("_ui_16_9_item_frame", x, y, 0, scale)

	local LXL = x - 10 * scale
	local LXS = x - 14 * scale
	local RXL = x + 300 * scale
	local RXS = x + 296 * scale

	SimpleRenderText(small_font, string.format("%d", data.red),
			LXL, y + 40 * scale,
			0, scale * 0.8, scale * 0.8, "right")
	SimpleRenderText(small_font, string.format("%d", data.total_red),
			LXS, y + 0 * scale,
			0, scale * 0.6, scale * 0.6, "right")

	SimpleRenderText(small_font, string.format("%d", data.blue),
			LXL, y - 40 * scale,
			0, scale * 0.8, scale * 0.8, "right")
	SimpleRenderText(small_font, string.format("%d", data.total_blue),
			LXS, y - 80 * scale,
			0, scale * 0.6, scale * 0.6, "right")

	SimpleRenderText(small_font, string.format("%d", data.green),
			RXL, y + 40 * scale,
			0, scale * 0.8, scale * 0.8, "right")
	SimpleRenderText(small_font, string.format("%d", data.total_green),
			RXS, y + 0 * scale,
			0, scale * 0.6, scale * 0.6, "right")

	SimpleRenderText(small_font, string.format("%d", data.night),
			RXL, y - 40 * scale,
			0, scale * 0.8, scale * 0.8, "right")
	SimpleRenderText(small_font, string.format("%d", data.total_night),
			RXS, y - 80 * scale,
			0, scale * 0.6, scale * 0.6, "right")
end

local function DrawDyeFrame(timer, x, y, scale, total, cur, target, achieve)
	lstg.Render("_ui_16_9_dye_other_mark", x - 180 * scale, y - 86 * scale, -timer, scale)
	lstg.Render("_ui_16_9_dye_other_mark", x - 168 * scale, y + 48 * scale, -timer + 60, scale * 0.9)
	lstg.Render("_ui_16_9_dye_frame", x, y, 0, scale)

	local s = scale * 0.9 * lstg.sin(achieve * 90)
	lstg.Render("_ui_16_9_dye_current_mark", x + 100 * scale, y, -timer - 60, -s, s)

	if target < 5201314 then
		SimpleRenderText(small_font, tostring(target),
				x - 180 * scale, y - 86 * scale,
				0, scale, scale, "center")
	else
		lstg.Render("_ui_16_9_small_font_infinite", x - 180 * scale, y - 86 * scale, 0, scale)
	end
	SimpleRenderText(small_font, tostring(total),
			x - 168 * scale, y + 46 * scale,
			0, scale * 0.9, scale * 0.9, "center")
	local fnt
	if cur >= target then
		fnt = big_font_color
	else
		fnt = big_font_gray
	end
	SimpleRenderText(fnt, tostring(cur),
			x + 110 * scale, y - 8 * scale,
			0, scale * 0.9, scale * 0.9, "center")
end

--endregion
----------------------------------------
--region ui displayer

local timer = 0

local high_score = 0
local cur_score = 0
local bonus_rate = 0

local life_left = 0
local bomb_left = 0
local life_chip_bar = 0
local bomb_chip_bar = 0

local total_dye = 0
local cur_dye = 0
local target_dye = 0
local dye_achieve = 0

local last_spell = 0

local system_item = {
	red = 0,
	blue = 0,
	green = 0,
	night = 0,
	total_red = 0,
	total_blue = 0,
	total_green = 0,
	total_night = 0,
}

local ui_obj = Class(object)
function ui_obj:init()
	if not PRELOAD then
		res:Load()
	end
	self.layer = LAYER_BG - 1000
	self.bound = false
	self.colli = false
end
function ui_obj:frame()
	high_score = math.max(lstg.tmpvar.hiscore or 0, lstg.var.score)
	cur_score = system.getScore()
	bonus_rate = system.getBonus()

	life_left = system.getLife()
	bomb_left = system.getBomb()
	life_chip_bar = system.getLifeChip() / 100
	bomb_chip_bar = system.getBombChip() / 100

	total_dye = system.getTotalChain()
	cur_dye = system.getChain()
	target_dye = system.getTargetChain()
	if system.checkChainAchieve() then
		dye_achieve = math.min(1, dye_achieve + 0.05)
	else
		dye_achieve = math.max(0, dye_achieve - 0.05)
	end

	if lstg.IsValid(lstg.tmpvar._last_spell_host_instance) then
		last_spell = math.min(last_spell + 1, 24)
	else
		last_spell = math.max(0, last_spell - 1)
	end

	if lstg.var.dyeitem then -- 虽然不知道为什么会报错……但是加上总归好一点
		system_item.total_red = lstg.var.dyeitem.red
		system_item.total_blue = lstg.var.dyeitem.blue
		system_item.total_green = lstg.var.dyeitem.green
		system_item.total_night = lstg.var.dyeitem.night
	else
		system_item.total_red = 0
		system_item.total_blue = 0
		system_item.total_green = 0
		system_item.total_night = 0
	end
	if lstg.tmpvar._system_items then
		system_item.red = lstg.tmpvar._system_items.red
		system_item.blue = lstg.tmpvar._system_items.blue
		system_item.green = lstg.tmpvar._system_items.green
		system_item.night = lstg.tmpvar._system_items.night
	else
		system_item.red = 0
		system_item.blue = 0
		system_item.green = 0
		system_item.night = 0
	end

	timer = timer + 1
end
function ui_obj:background()

	-- 背景
	lstg.Render("_ui_16_9_bg1", menu.screen.width - 512 * 0.25, menu.screen.height, 0, 0.25)
	lstg.Render("_ui_16_9_bg2", menu.screen.width, menu.screen.height, -90, 0.25)

	-- 版面框架和LOGO
	if menu.screen.mode == 169 then
		DrawWorldFrame(menu.screen.width * 0.5, menu.screen.height * 0.5 - 6, 288, 336)
		lstg.Render("_ui_16_9_logo", 80, menu.screen.height / 2, 0, 0.25)
	elseif menu.screen.mode == 43 then
		DrawWorldFrame(24 + (288 / 2), menu.screen.height * 0.5 - 6, 288, 336)
	end

end
function ui_obj:render()
	local dx = 0
	if menu.screen.mode == 169 then
		dx = menu.screen.width
	elseif menu.screen.mode == 43 then
		dx = menu.screen.width + 4
	end
	--region 右侧信息板
	-- 关卡组
	local image_index = difficultyIndex()
	lstg.Render("_ui_16_9_rank" .. image_index, dx - 88, menu.screen.height - 36, 0, 0.25)
	-- 信息栏
	local ybase = menu.screen.height - 64
	local yoffset = 24
	for i, s in ipairs({"_ui_16_9_infobar1", "_ui_16_9_infobar2", "_ui_16_9_infobar5", "_ui_16_9_infobar3", "_ui_16_9_infobar4"}) do
		lstg.Render(s, dx - 96, ybase - (i - 1) * yoffset, 0, 0.25)
	end
	SimpleRenderText(small_font, string.format_number(high_score),
			dx - 10, ybase - 0 * yoffset, 0, 0.25, 0.25, "right")
	SimpleRenderText(small_font, string.format_number(cur_score),
			dx - 10, ybase - 1 * yoffset, 0, 0.25, 0.25, "right")
	SimpleRenderText(small_font, string.format_number(bonus_rate),
			dx - 10, ybase - 2 * yoffset, 0, 0.25, 0.25, "right")
	for i = 1, 8 do
		lstg.Render("_ui_16_9_life0",
				dx - 122 + (i - 1) * 15, ybase - 3 * yoffset + 2, 0, 0.25)
	end
	for i = 1, math.min(life_left, 8) do
		lstg.Render("_ui_16_9_life1",
				dx - 122 + (i - 1) * 15, ybase - 3 * yoffset + 2, 0, 0.25)
	end
	SimpleRenderProgressBar(life_bar,
			dx - 86, ybase - 3 * yoffset - 10, 0, 0.28, 0.28, "left", life_chip_bar)
	for i = 1, 5 do
		lstg.Render("_ui_16_9_bomb0",
				dx - 122 + (i - 1) * 15, ybase - 4 * yoffset + 2, 0, 0.25)
	end
	for i = 1, math.min(bomb_left, 5) do
		lstg.Render("_ui_16_9_bomb1",
				dx - 122 + (i - 1) * 15, ybase - 4 * yoffset + 2, 0, 0.25)
	end
	SimpleRenderProgressBar(bomb_bar,
			dx - 86, ybase - 4 * yoffset - 10, 0, 0.28, 0.28, "left", bomb_chip_bar)
	-- lastspell
	local ani_idx = math.floor(last_spell / 4)
	if ani_idx > 0 then
		for t = 1, 4 do
			lstg.Render("_ui_16_9_forbid" .. ani_idx,
					dx - 140 + (t - 1) * 36, 214, 0, 0.25 * 1.2)
		end
	end
	-- 道具板
	DrawItemFrame(dx - 88, 144, 0.25, system_item)
	-- 染色板
	DrawDyeFrame(timer, dx - 86, 64, 0.25, total_dye, cur_dye, target_dye, dye_achieve)
	--endregion

	SetViewMode("world")
end

--endregion
----------------------------------------

function ui_obj:damageBar(rate,offset)
    lstg.Render("_ui_16_9_hpbarbg",320,6+offset*.75,0,.5)
    SimpleRenderProgressBar(hp_bar,320,6+offset*.75,0,.25,.25,"centercut",rate)
end
return ui_obj
