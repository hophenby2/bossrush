local floor = math.floor
local New = lstg.New
local SetV = lstg.SetV
local SetImgState = lstg.SetImgState
local DefaultRenderFunc = lstg.DefaultRenderFunc
local Render = lstg.Render

local blankfun = function() end

---@class stg
stg = stg or {}

local bullet = {}

local classAA = {}
local classAB = {}
local classB = {}
local classCA = {}
local classCB = {}

---@class stg.bullet.object : lstg.GameObject

----------------------------------------
--- style collection

local bullet_style = {
	-- bullet name, sprite name, sprite color, colli a, colli b, colli rect，relative size
	{  "ball_small",       "ball_small", 16,    2,    2, false,  0.5},--点弹
	{    "ball_mid",         "ball_mid", 16,    4,    4, false,  1.0},--小玉
	{  "ball_mid_b",       "ball_mid_b",  8,    4,    4, false,  1.5},--激光头、弹雾
	{  "ball_mid_c",       "ball_mid_c", 16,    4,    4, false,  0.9},--环弹
	{    "ball_big",         "ball_big", 16,    8,    8, false,  2.0},--中玉
	{   "ball_huge",   "ball_huge_dark", 16, 13.5, 13.5, false,  4.0},--大玉
	{  "ball_light",  "ball_light_dark", 16, 11.5, 11.5, false,  3.0},--光玉
	{ "arrow_small",      "arrow_small", 16,  2.5,  2.5, false, 1.25},--苦无
	{   "arrow_mid",        "arrow_mid", 16,  3.5,  3.5, false,  1.8},--箭弹
	{   "arrow_big",        "arrow_big", 16,  2.5,  2.5, false,  1.0},--鳞弹
	{     "grain_a",          "grain_a", 16,  2.5,  2.5, false, 0.85},--米弹
	{     "grain_b",          "grain_b", 16,  2.5,  2.5, false, 1.25},--凌弹
	{     "grain_c",          "grain_c", 16,  2.5,  2.5, false, 0.85},--黑心米弹
	{  "star_small",       "star_small", 16,    2,    2, false, 0.65},--小星弹
	{    "star_big",         "star_big", 16,    6,    6, false, 1.65},--大星弹
	{  "star_big_b",       "star_big_b",  8,    6,    6, false,  1.9},--钻头（10角星）
	{        "kite",             "kite", 16,  2.5,  2.5, false, 1.15},--菱弹
	{   "kite_dark",        "kite_dark", 16,  2.5,  2.5, false, 1.15},--灰菱弹
	{      "kite_b",           "kite_b", 16,  2.5,  2.5, false, 0.75},--菱形方砖
	{       "knife",            "knife", 16,    4,    4, false, 1.99},--刀弹
	{     "knife_b",          "knife_b",  8,  3.5,  3.5, false,  1.9},--弯刀弹
	{      "square",           "square", 16,    3,    3, false,  1.0},--札弹
	{     "ellipse",          "ellipse", 16,    4,    4, false,  1.5},--椭弹
	{  "gun_bullet",       "gun_bullet", 16,  2.5,  2.5, false, 1.25},--子弹
	{ "laserbullet",      "laserbullet", 16,    2,    2, false, 1.25},--棍弹
	{       "money",            "money",  8,    4,    4, false,  0.9},--钱币
	{   "butterfly",        "butterfly", 16,  2.5,  2.5, false,  1.0},--蝶弹
	{       "heart",            "heart", 16,    7,    7, false, 1.65},--心弹
	{        "drop",             "drop", 16,    2,    2, false,  1.5},--水滴
	{      "mildew",           "mildew", 16,    2,    2, false,  0.5},--菌弹
	{     "silence",          "silence", 16,    3,    3, false, 1.65},--休止符
	{       "music",            "music",  8,    3,    3, false,  1.5},--音符
	{  "music_high",       "music_high",  8,    3,    3, false,  1.5},--高音符
	{  "water_drop",  "water_drop_dark", 16,    4,    4, false,  1.5},--滴弹
	{ "water_drop2", "water_drop_dark2",  8,    4,    4, false,  1.5},--火弹
}

-- 实际上不执行，仅仅作为IDE的代码提示补全用
if false then
	local _ = 0
	---点弹
	stg.ball_small = _
	---小玉
	stg.ball_mid = _
	---激光头、弹雾
	stg.ball_mid_b = _
	---环弹
	stg.ball_mid_c = _
	---中玉
	stg.ball_big = _
	---大玉
	stg.ball_huge = _
	---光玉
	stg.ball_light = _
	---苦无
	stg.arrow_small = _
	---箭弹
	stg.arrow_mid = _
	---鳞弹
	stg.arrow_big = _
	---米弹
	stg.grain_a = _
	---凌弹
	stg.grain_b = _
	---黑心米弹
	stg.grain_c = _
	---小星弹
	stg.star_small = _
	---大星弹
	stg.star_big = _
	---钻头（十角星）
	stg.star_big_b = _
	---菱弹
	stg.kite = _
	---灰菱弹
	stg.kite_dark = _
	---菱形方砖
	stg.kite_b = _
	---刀弹
	stg.knife = _
	---弯刀弹
	stg.knife_b = _
	---札弹
	stg.square = _
	---椭弹
	stg.ellipse = _
	---子弹
	stg.gun_bullet = _
	---棍弹
	stg.laserbullet = _
	---钱币
	stg.money = _
	---蝶弹
	stg.butterfly = _
	---心弹
	stg.heart = _
	---水滴
	stg.drop = _
	---菌弹
	stg.mildew = _
	---休止符
	stg.silence = _
	---音符
	stg.music = _
	---高音符
	stg.music_high = _
	---滴弹
	stg.water_drop = _
	---火弹
	stg.water_drop2 = _
end

local BULLET_NAME = 1
local SPRITE_NAME = 2
local COLOR_INDEX = 3
local COLLI_A = 4
local COLLI_B = 5
local COLLI_RECT = 6
local BULLET_SIZE = 7

local bullet_image = {}
stg.all_bullet = {}

for k, v in pairs(bullet_style) do
	stg[v[BULLET_NAME]] = k
	stg.all_bullet[k] = k
	bullet_image[k] = {}
	for i = 1, 16 do
		if v[COLOR_INDEX] == 16 then
			bullet_image[k][i] = v[SPRITE_NAME] .. i
		elseif v[COLOR_INDEX] == 8 then
			bullet_image[k][i] = v[SPRITE_NAME] .. floor((i + 1) / 2)
		end
	end
	v.img = v[SPRITE_NAME]
	v.a = v[COLLI_A]
	v.b = v[COLLI_B]
	v.rect = v[COLLI_RECT]
	v.size = v[BULLET_SIZE]
end

----------------------------------------
--- fade in

local fade_in_scale = {}
local fade_in_scale_inv = {}

for t = 0, 8 do
	fade_in_scale[t] = 2 - 1 * (t / 8)
	fade_in_scale_inv[t] = 1 / fade_in_scale[t]
end

local fade_in_alpha = {}
local fade_in_alpha_255 = {}

for t = 0, 8 do
	fade_in_alpha[t] = (t / 8)
	fade_in_alpha_255[t] = 255 * (t / 8)
end

---@param self stg.bullet.object
---@param style number
---@param color number
---@param stay boolean
---@param indestructible boolean
function bullet.fade_in_init(self, style, color, stay, indestructible)
	local v = bullet_style[style]
	self.style = v
	self.index = color
	self.stay = stay
	if indestructible then
		self.group = GROUP_INDES
	else
		self.group = GROUP_ENEMY_BULLET
	end
	self.layer = LAYER_ENEMY_BULLET_EF - v[BULLET_SIZE] * 0.001 + color * 0.00001
	self.img = bullet_image[style][color]
	self.a = v[COLLI_A]
	self.b = v[COLLI_B]
	self.rect = v[COLLI_RECT]
	if stay then
		self.class = classAA
	else
		self.class = classAB
	end
end

---@param self stg.bullet.object
function bullet.fade_in_frame_a(self)
	self.x = self.x - self.vx
	self.y = self.y - self.vy
	self.vx = self.vx - self.ax
	self.vy = self.vy - self.ay
	self.rot = self.rot - self.omiga
	if self.timer >= 7 then
		self.timer = -1
		bullet.normal_init(self)
	end
end

---@param self stg.bullet.object
function bullet.fade_in_frame_b(self)
	task.Do(self)
	if self.timer >= 7 then
		bullet.normal_init(self)
	end
end

---@param self stg.bullet.object
function bullet.fade_in_render(self)
	if self._blend and self._a then
		SetImgState(self, self._blend, fade_in_alpha[self.timer] * self._a, self._r, self._g, self._b)
	else
		SetImgState(self, "", fade_in_alpha_255[self.timer], 255, 255, 255)
	end
	local s1, s2 = fade_in_scale[self.timer], fade_in_scale_inv[self.timer]
	self.hscale = self.hscale * s1
	self.vscale = self.vscale * s1
	DefaultRenderFunc(self)
	self.hscale = self.hscale * s2
	self.vscale = self.vscale * s2
	SetImgState(self, "", 255, 255, 255, 255)
end

---@param self stg.bullet.object
function bullet.fade_in_del(self)
	bullet.fade_out_init(self, true)
end

---@param self stg.bullet.object
function bullet.fade_in_kill(self)
	New(item_faith_minor, self.x, self.y)
	bullet.fade_out_init(self, true)
end

----------------------------------------
--- normal

---@param self stg.bullet.object
function bullet.normal_init(self)
	self.layer = LAYER_ENEMY_BULLET - self.style[BULLET_SIZE] * 0.001 + self.index * 0.00001
	self.class = classB
end

---@param self stg.bullet.object
function bullet.normal_frame(self)
	task.Do(self)
end

---@param self stg.bullet.object
function bullet.normal_render(self)
	if self._blend and self._a then
		SetImgState(self, self._blend, self._a, self._r, self._g, self._b)
		DefaultRenderFunc(self)
		SetImgState(self, "", 255, 255, 255, 255)
	else
		DefaultRenderFunc(self)
	end
end

---@param self stg.bullet.object
function bullet.normal_del(self)
	bullet.fade_out_init(self, false)
end

---@param self stg.bullet.object
function bullet.normal_kill(self)
	New(item_faith_minor, self.x, self.y)
	bullet.fade_out_init(self, false)
end

----------------------------------------
--- fade out

local fade_out_alpha = {}
local fade_out_alpha_255 = {}

for t = 0, 8 do
	fade_out_alpha[t] = 1 - 1 * (t / 9)
	fade_out_alpha_255[t] = 255 * (1 - 1 * (t / 9))
end

---@param self stg.bullet.object
---@param type boolean
function bullet.fade_out_init(self, type)
	self.status = "normal"
	self.timer = 0
	self.bound = false
	-- Deletion may run during native collision iteration. Keep the group stable.
	self.colli = false
	if type then
		self.dhscale = (-0.5 * self.hscale) / 7
		self.dvscale = (-0.5 * self.vscale) / 7
	else
		self.dhscale = (-0.5 * self.hscale) / 7
		self.dvscale = (-0.5 * self.vscale) / 7
	end
	if self._blend and self._a then
		self.class = classCB
	else
		self.class = classCA
	end
end

---@param self stg.bullet.object
function bullet.fade_out_frame(self)
	self.hscale = self.hscale + self.dhscale
	self.vscale = self.vscale + self.dvscale
	if self.timer >= 7 then
		self.status = "del"
	end
end

---@param self stg.bullet.object
function bullet.fade_out_render_a(self)
	SetImgState(self, "", fade_out_alpha_255[self.timer], 255, 255, 255)
	DefaultRenderFunc(self)
	SetImgState(self, "", 255, 255, 255, 255)
end

---@param self stg.bullet.object
function bullet.fade_out_render_b(self)
	SetImgState(self, self._blend, fade_out_alpha[self.timer] * self._a, self._r, self._g, self._b)
	DefaultRenderFunc(self)
	SetImgState(self, "", 255, 255, 255, 255)
end

----------------------------------------
--- bullet class

--region class
classAA = {
	blankfun,
	bullet.fade_in_del,
	bullet.fade_in_frame_a,
	bullet.fade_in_render,
	blankfun,
	bullet.fade_in_kill,
	is_class = true,
}
classAB = {
	blankfun,
	bullet.fade_in_del,
	bullet.fade_in_frame_b,
	bullet.fade_in_render,
	blankfun,
	bullet.fade_in_kill,
	is_class = true,
}
classB = {
	blankfun,
	bullet.normal_del,
	bullet.normal_frame,
	bullet.normal_render,
	blankfun,
	bullet.normal_kill,
	is_class = true,
}
classCA = {
	blankfun,
	blankfun,
	bullet.fade_out_frame,
	bullet.fade_out_render_a,
	blankfun,
	blankfun,
	is_class = true,
}
classCB = {
	blankfun,
	blankfun,
	bullet.fade_out_frame,
	bullet.fade_out_render_b,
	blankfun,
	blankfun,
	is_class = true,
}
--endregion

local _bullet = {
	bullet.fade_in_init,
	blankfun,
	blankfun,
	blankfun,
	blankfun,
	blankfun,
	is_class = true,
}

-- Register raw callback classes before a native object changes its class.
for _, class in ipairs({classAA,classAB,classB,classCA,classCB,_bullet}) do
	lstg.RegisterClass(class)
end

---@param self stg.bullet.object
---@param style number @0 to use last style
---@param color number
function stg.setBulletStyle(self, style, color)
	local v = bullet_style[style] or self.style
	self.style = v
	self.index = color
	self.img = bullet_image[style][color]
	self.a = v[COLLI_A]
	self.b = v[COLLI_B]
	self.rect = v[COLLI_RECT]
end

---@param self stg.bullet.object
---@param blend lstg.BlendMode
---@param a number
---@param r number
---@param g number
---@param b number
function stg.setBulletColor(self, blend, a, r, g, b)
	self._blend = blend
	self._a, self._r, self._g, self._b = a, r, g, b
end

---@param style number
---@param color number
---@param stay boolean
---@param indestructible boolean
---@return stg.bullet.object
function stg.newBullet(style, color, stay, indestructible)
	return New(_bullet, style, color, stay, indestructible)
end

---@param style number
---@param color number
---@param stay boolean
---@param x number
---@param y number
---@param v number
---@param a number
---@param indestructible boolean
---@return stg.bullet.object
function stg.newBulletStraight(style, color, stay, x, y, v, a, indestructible)
	local u = New(_bullet, style, color, stay, indestructible)
	u.x, u.y = x, y
	SetV(u, v, a, true)
	return u
end

---class(style, color, stay, indestructible)
stg.bullet = _bullet
