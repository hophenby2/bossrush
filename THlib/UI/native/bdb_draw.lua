---=====================================
--- UI绘制
--- Xiliusha
---=====================================

local bit = require("bit")

local _sprite_font_default_char = { "img_void", 0, 0 }

---@param map table<string, number> @{ img, left, right, blank }
---@return ui.SpriteFontDefine
function ui.SpriteFontDefine(map)
	---@class ui.SpriteFontDefine
	local def = {
		imgs = map,
		height = 80,
	}
	setmetatable(def.imgs, { __index = function()
		return _sprite_font_default_char
	end })
	return def
end

---@param def ui.SpriteFontDefine
---@param text string
---@param x number
---@param y number
---@param rot number
---@param hscale number
---@param vscale number
---@param align '"left"' | '"right"' | 'center'
function ui.drawSpriteText(def, text, x, y, rot, hscale, vscale, align)
	local ax, ay = lstg.cos(rot), lstg.sin(rot)
	local len = string.len(text)
	local I, C = def.imgs
	if align == "left" then
		for i = 1, len do
			C = I[string.sub(text, i, i)]
			x = x + C[2] * ax * hscale
			y = y + C[2] * ay * vscale
			if C[4] then
				lstg.Render(C[1], x, y, rot, hscale, vscale)
			end
			x = x + C[3] * ax * hscale
			y = y + C[3] * ay * vscale
		end
		return x, y
	elseif align == "right" then
		for i = len, 1, -1 do
			C = I[string.sub(text, i, i)]
			x = x - C[3] * ax * hscale
			y = y - C[3] * ay * vscale
			if C[4] then
				lstg.Render(C[1], x, y, rot, hscale, vscale)
			end
			x = x - C[2] * ax * hscale
			y = y - C[2] * ay * vscale
		end
		return x, y
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
			if C[4] then
				lstg.Render(C[1], x, y, rot, hscale, vscale)
			end
			x = x + C[3] * ax * hscale
			y = y + C[3] * ay * vscale
		end
		return x, y
	end
end

---@param def ui.SpriteFontDefine
---@param text string
---@param blend lstg.BlendMode
---@param color lstg.Color
function ui.setSpriteTextColor(def, text, blend, color)
	local ct = {}
	for i = 1, string.len(text) do
		ct[string.sub(text, i, i)] = true
	end
	for k, _ in pairs(ct) do
		if def.imgs[k] then
			if def.imgs[k][4] then
				lstg.SetImageState(def.imgs[k][1], blend, color)
			end
		end
	end
end

---@param b string
---@param t string
---@param tex string
---@param x number
---@param y number
---@param w number
---@param h number
---@return ui.ProgressBarDefine
function ui.ProgressBarDefine(b, t, tex, x, y ,w , h)
	---@class ui.ProgressBarDefine
	local ret = {
		img_bottom = b or "img_void",
		img_top = t or "img_void",
		tex = tex or "basic",
		x = x or 0,
		y = y or 0,
		w = w or 0,
		h = h or 0,
	}
	return ret
end

---@param def ui.ProgressBarDefine
---@param x number
---@param y number
---@param rot number
---@param hscale number
---@param vscale number
---@param blend lstg.BlendMode
---@param color lstg.Color
---@param align '"left"' | '"right"' | '"centercut"'
---@param k number
function ui.drawProgressBar(def, x, y, rot, hscale, vscale, blend, color, align, k)
	lstg.SetImageState(def.img_bottom, blend, color)
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
		lstg.RenderTexture(def.tex, blend,
				{ x1, y1, 0.5, def.x, def.y, color },
				{ x2, y2, 0.5, def.x + k * def.w, def.y, color },
				{ x3, y3, 0.5, def.x + k * def.w, def.y + def.h, color },
				{ x4, y4, 0.5, def.x, def.y + def.h, color })
	elseif align == "right" then
		local x2 = x + cw + ch
		local y2 = y + sw + sh
		local x3 = x + cw - ch
		local y3 = y + sw - sh
		local x1 = x2 - cl
		local y1 = y2 - sl
		local x4 = x3 - cl
		local y4 = y3 - sl
		lstg.RenderTexture(def.tex, blend,
				{ x1, y1, 0.5, def.x + def.w - k * def.w, def.y, color },
				{ x2, y2, 0.5, def.x + def.w, def.y, color },
				{ x3, y3, 0.5, def.x + def.w, def.y + def.h, color },
				{ x4, y4, 0.5, def.x + def.w - k * def.w, def.y + def.h, color })
	elseif align == "centercut" then
		local x11, x21, x31 = x - cw * k + ch, x + ch, x + cw * k + ch
		local x12, x22, x32 = x - cw * k - ch, x - ch, x + cw * k - ch
		local y11, y21, y31 = y - sw * k + sh, y + sh, y + sw * k + sh
		local y12, y22, y32 = y - sw * k - sh, y - sh, y + sw * k - sh
		lstg.RenderTexture(def.tex, blend,
				{ x11, y11, 0.5, def.x, def.y, color },
				{ x21, y21, 0.5, def.x + k * 0.5 * def.w, def.y, color },
				{ x22, y22, 0.5, def.x + k * 0.5 * def.w, def.y + def.h, color },
				{ x12, y12, 0.5, def.x, def.y + def.h, color })
		local u = def.x + def.w
		lstg.RenderTexture(def.tex, blend,
				{ x21, y21, 0.5, u - k * 0.5 * def.w, def.y, color },
				{ x31, y31, 0.5, u, def.y, color },
				{ x32, y32, 0.5, u, def.y + def.h, color },
				{ x22, y22, 0.5, u - k * 0.5 * def.w, def.y + def.h, color })
	end
	lstg.SetImageState(def.img_top, blend, color)
	lstg.Render(def.img_top, x, y, rot, hscale, vscale)
end

---@param def ui.ProgressBarDefine
---@param x number
---@param y number
---@param rot number
---@param scale number
---@param alpha number
---@param align '"left"' | '"right"' | '"centercut"'
---@param k number
function ui.drawProgressBarS(def, x, y, rot, scale, alpha, align, k)
	if type(alpha) == "number" then
		alpha = lstg.Color(alpha * 255, 255, 255, 255)
	end
	ui.drawProgressBar(def,
			x, y, rot, scale, scale,
			"", alpha,
			align, k)
end

----------------------------------------
local function _makeSprite9Size(w, h, s)
	local cw = w - 2 * s
	local ch = h - 2 * s
	return {
		{ s, s },
		{ cw, s },
		{ s, s },
		{ s, ch },
		{ cw, ch },
		{ s, ch },
		{ s, s },
		{ cw, s },
		{ s, s },
	}
end

---@param prefix string
---@param size number[][] @{ w, h, s } / { { width, height } x 9 }
---@return ui.Sprite9Define
function ui.Sprite9Define(prefix, size)
	if type(size[1]) == "number" then
		size = _makeSprite9Size(size[1], size[2], size[3])
	end
	---@class ui.Sprite9Define
	local def = {
		sprite_1 = {
			sprite = "",
			width = 0,
			height = 0,
		},
		sprite_2 = {
			sprite = "",
			width = 0,
			height = 0,
		},
		sprite_3 = {
			sprite = "",
			width = 0,
			height = 0,
		},
		sprite_4 = {
			sprite = "",
			width = 0,
			height = 0,
		},
		sprite_5 = {
			sprite = "",
			width = 0,
			height = 0,
		},
		sprite_6 = {
			sprite = "",
			width = 0,
			height = 0,
		},
		sprite_7 = {
			sprite = "",
			width = 0,
			height = 0,
		},
		sprite_8 = {
			sprite = "",
			width = 0,
			height = 0,
		},
		sprite_9 = {
			sprite = "",
			width = 0,
			height = 0,
		},
	}
	for i = 1, 9 do
		local d = def["sprite_" .. i]
		d.sprite = prefix .. i
		d.width = size[i][1]
		d.height = size[i][2]
	end
	return def
end

local COLOR_ALPHA = lstg.Color(255, 255, 255, 255)

---@param def ui.Sprite9Define
---@param x number
---@param y number
---@param width number
---@param height number
---@param scale number
---@param color lstg.Color
---@param align '"lt"' | '"ct"' | '"rt"' | '"lc"' | '"cc"' | '"rc"' | '"lb"' | '"cb"' | '"rb"'
function ui.drawSprite9(def, x, y, width, height, scale, color, align)
	if type(color) == "number" then
		COLOR_ALPHA.a = color * 255.0
		color = COLOR_ALPHA
	end
	for i = 1, 9 do
		local d = def["sprite_" .. i]
		lstg.SetImageState(d.sprite, "", color)
	end
	local l, r, b, t = 0, 0, 0, 0
	local hm = string.sub(align, 1, 1)
	local vm = string.sub(align, 2, 2)
	if hm == "l" then
		l, r = x, x + width
	elseif hm == "c" then
		l, r = x - width / 2, x + width / 2
	elseif hm == "r" then
		l, r = x - width, x
	else
		error("unknown align mode.")
	end
	if vm == "t" then
		b, t = y - height, y
	elseif vm == "c" then
		b, t = y - height / 2, y + height / 2
	elseif vm == "b" then
		b, t = y, y + height
	else
		error("unknown align mode.")
	end
	-- 中间
	lstg.RenderRect(def.sprite_5.sprite, l, r, b, t)
	-- 左右下上
	lstg.RenderRect(def.sprite_4.sprite, l - def.sprite_4.width * scale, l, b, t)
	lstg.RenderRect(def.sprite_6.sprite, r, r + def.sprite_6.width * scale, b, t)
	lstg.RenderRect(def.sprite_2.sprite, l, r, t, t + def.sprite_2.height * scale)
	lstg.RenderRect(def.sprite_8.sprite, l, r, b - def.sprite_8.height * scale, b)
	-- 四个角
	lstg.RenderRect(def.sprite_1.sprite, l - def.sprite_1.width * scale, l, t, t + def.sprite_1.height * scale)
	lstg.RenderRect(def.sprite_3.sprite, r, r + def.sprite_3.width * scale, t, t + def.sprite_3.height * scale)
	lstg.RenderRect(def.sprite_7.sprite, l - def.sprite_7.width * scale, l, b - def.sprite_7.height * scale, b)
	lstg.RenderRect(def.sprite_9.sprite, r, r + def.sprite_9.width * scale, b - def.sprite_9.height * scale, b)
end

---@param k number
---@param x number
---@param y number
---@param scale number
---@param height number
---@param cheight number
---@param color lstg.Color
