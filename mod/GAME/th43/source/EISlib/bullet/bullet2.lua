local floor, ceil = math.floor, math.ceil
local New = lstg.New
local SetV = lstg.SetV
local SetImgState = lstg.SetImgState
local SetImageState = lstg.SetImageState
local Color = lstg.Color
local DefaultRenderFunc = lstg.DefaultRenderFunc
local Render = lstg.Render
local RenderAnimation = lstg.RenderAnimation
local ran = lstg.Rand() --专门为这个库做一个随机数生成器，之后涉及effcut时决定消弹时是否会产生调用随机数的对象，防止炸rep
local blankfun = function() end

local bullet = {}

local classAA = {}
local classAB = {}
local classAC = {} --纯雾化效果
local classB = {}
local classCA = {}
local classCB = {}

---@class stg.bullet.object : lstg.GameObject

----------------------------------------
--- style collection

local bullet_style = {
	-- bullet name, sprite name, sprite color, colli a, colli b, colli rect，relative size
	{    "ball_small",       "ball_small", 16,  1.5,  1.5, false,  0.5},--点弹
	{      "ball_mid",         "ball_mid", 16,    2,    2, false,  1.0},--小玉
	--{  "ball_mid_b",       "ball_mid_b",  8,    4,    4, false,  1.5},--激光头、弹雾
	{    "ball_mid_c",       "ball_mid_c", 16,    2,    2, false,  0.9},--环弹
	{      "ball_big",         "ball_big", 16,    6,    6, false,  2.0},--中玉
	{     "ball_huge",   "ball_huge_dark", 16,   12,   12, false,  4.0},--大玉
	{    "ball_light",  "ball_light_dark", 16,   10,   10, false,  3.0},--光玉
	{   "arrow_small",      "arrow_small", 16,    2,    2, false, 1.25},--苦无
	{ "arrow_small_b",    "arrow_small_b", 16,    2,    2, false,    1},--苦无2
	{     "arrow_mid",        "arrow_mid", 16,    2,    2, false,  1.8},--箭弹
	{     "arrow_big",        "arrow_big", 16,    2,    2, false,  1.0},--鳞弹
	{       "grain_a",          "grain_a", 16,    2,    2, false, 0.85},--米弹
	{       "grain_b",          "grain_b", 16,    2,    2, false, 1.25},--凌弹
	{       "grain_c",          "grain_c", 16,    2,    2, false, 0.85},--黑心米弹
	{       "grain_d",          "grain_d", 16,    2,    2, false, 1.25},--水晶凌弹
	{    "star_small",       "star_small", 16,  1.5,  1.5, false, 0.65},--小星弹
	{      "star_big",         "star_big", 16,    4,    4, false, 1.65},--大星弹
	--{  "star_big_b",       "star_big_b",  8,    6,    6, false,  1.9},--钻头（10角星）
	{          "kite",             "kite", 16,    2,    2, false, 1.15},--菱弹
	{     "kite_dark",        "kite_dark", 16,    2,    2, false, 1.15},--灰菱弹
	{        "kite_b",           "kite_b", 16,    2,    2, false, 0.75},--菱形方砖
	{         "knife",            "knife", 16,  2.5,  2.5, false, 1.99},--刀弹
	{       "knife_b",          "knife_b",  8,  2.5,  2.5, false,  1.9},--qhm的老刀弹
	{        "square",           "square", 16,    2,    2, false,  1.0},--札弹
	{       "ellipse",          "ellipse", 16,    3,    3, false,  1.5},--椭弹
	{    "gun_bullet",       "gun_bullet", 16,    2,    2, false, 1.25},--子弹
	{   "laserbullet",      "laserbullet", 16,    2,    2, false, 1.25},--棍弹
	{         "money",            "money",  8,    2,    2, false,  0.9},--钱币
	{     "butterfly",        "butterfly", 16,    2,    2, false,  1.0},--蝶弹
	{         "heart",            "heart", 16,    6,    6, false, 1.65},--心弹
	{          "drop",             "drop", 16,    2,    2, false,  1.5},--水滴
	{        "mildew",           "mildew", 16,    2,    2, false,  0.5},--菌弹
	{       "silence",          "silence", 16,    2,    2, false, 1.65},--休止符
	{         "music",            "music",  8,    2,    2, false,  1.5},--音符
	{    "music_high",       "music_high",  8,    2,    2, false,  1.5},--高音符
	{    "water_drop",  "water_drop_dark", 16,    2,    2, false,  1.5},--滴弹
}

if not config.preview_version then
	local bullet_style2 = {
		-- bullet name, sprite name, sprite color, colli a, colli b, colli rect，relative size
		{    "ball_big_b",       "ball_big_b",  16,  4,  4, false,  1.99},--中玉2
		{    "ball_big_c",       "ball_big_c",  16,  4,  4, false,  1.99},--中玉3
		{       "grain_e",          "grain_e", 16,  2,  2, false,  0.85},--米弹5
		{    "star_big_b",       "star_big_b",  8,  4,  4, false,  1.65},--大星弹
		{     "ball_wool",       "ball_wool",  16,  8,  8, false, 2.0}, --毛线球弹
		{          "bird",            "bird",  16,  2,  2, false, 0.9}, --鸟弹
		{       "feather",         "feather",  8,  2,  2, false, 1.5}, --羽毛弹
		{         "jewel",           "jewel",  8,  2,  2, false, 1.5}, --宝石
	}
	for _, v in ipairs(bullet_style2) do
		table.insert(bullet_style, v)
	end
end

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
	---苦无（原作风
	stg.arrow_small_b = _
	---箭弹
	stg.arrow_mid = _
	---鳞弹
	stg.arrow_big = _
	---米弹
	stg.grain_a = _
	---凌弹
	stg.grain_b = _
	---水晶凌弹
	stg.grain_d = _
	---黑心米弹
	stg.grain_c = _
	---小星弹
	stg.star_small = _
	---大星弹
	stg.star_big = _
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
	---中玉2
	stg.ball_big_b = _
	---中玉3
	stg.ball_big_c = _
	---米弹5
	stg.grain_e = _
	---四角星
	stg.star_big_b = _
	---毛线球
	stg.ball_wool = _
	---鸟
	stg.bird = _
	---羽毛
	stg.feather = _
	---宝石
	stg.jewel = _
end

local function IsBigBulletStyle(style)
	if style == stg.ball_huge or
			style == stg.ball_light or
			style == stg.ball_big or
			style == stg.star_big or
	        style == stg.ball_wool or
			style == stg.heart then
		return true
	else
		return false
	end
end

local function boundInit(self, no_bound)
	if no_bound then
		self.bound_time = 11
		self.bound_flag = true --标记为true时才会处理调整出屏删除
	elseif not self.bound_time then
		self.bound_time = 1
		self.bound_flag = false
	end
end

local function boundFrame(self)
	if self.bound_flag then
		if self.timer >= self.bound_time then
			self.bound = true
			self.bound_flag = false
		else
			self.bound = false
		end
	end
end

local BULLET_NAME = 1
local SPRITE_NAME = 2
local COLOR_INDEX = 3
local COLLI_A = 4
local COLLI_B = 5
local PREIMG_COLLI = 4, 4 --雾化的基础判定
local COLLI_RECT = 6
local BULLET_SIZE = 7

local bullet_image = {}

for k, v in pairs(bullet_style) do
	stg[v[BULLET_NAME]] = k
	bullet_image[k] = {}
	for i = 1, 16 do
		if v[COLOR_INDEX] == 16 then
			bullet_image[k][i] = "th43/" .. v[SPRITE_NAME] .. i
		elseif v[COLOR_INDEX] == 8 then
			bullet_image[k][i] = "th43/" .. v[SPRITE_NAME] .. floor((i + 1) / 2)
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

for t = 0, 12 do
	fade_in_scale[t] = 2 - 1 * (t / 12)
	fade_in_scale_inv[t] = 1 / fade_in_scale[t]
end

local fade_in_alpha = {}
local fade_in_alpha_255 = {}

for t = 0, 12 do
	fade_in_alpha[t] = (t / 12)
	fade_in_alpha_255[t] = 255 * (t / 12)
end

---@param self stg.bullet.object
---@param style number
---@param color number
---@param stay boolean
---@param indestructible boolean
function bullet.fade_in_init(self, x, y, style, color, indestructible, creatBullet, no_bound)
	local v = bullet_style[style]
	self.initX, self.initY = x, y
	self.x, self.y = x, y
	self.style = v
	self._style = style --存储自己种类的
	self.index = color
	self.bound = not no_bound
	if creatBullet then
		self.creatBullet = creatBullet
	end
	if indestructible then
		self.group = GROUP_INDES
	else
		self.group = GROUP_ENEMY_BULLET
	end
	self.layer = LAYER_ENEMY_BULLET_EF - v[BULLET_SIZE] * 0.001 + color * 0.00001
	if IsBigBulletStyle(style) then
		self.img = bullet_image[style][color] --大型子弹采用自己贴图作为雾化
		self.a = v[COLLI_A]
		self.b = v[COLLI_B]
		self.class = classAB
	else
		self.img = "th43/preimg"..color   --普通子弹采用雾化贴图
		self.a = PREIMG_COLLI
		self.b = PREIMG_COLLI
		self.class = classAA
	end
	self.rect = v[COLLI_RECT]
	boundInit(self, no_bound)
end

---@param self stg.bullet.object
function bullet.fade_in_frame(self)
	boundFrame(self)
	self.x, self.y = self.initX, self.initY
	if self.timer >= 11 then
		self.timer = -1
		if self.creatBullet then
			self.status = "del"
			self.creatBullet(self) --执行产生弹幕的函数
		else
			bullet.normal_init(self)
		end
	end
end

--普通子弹雾化渲染
---@param self stg.bullet.object
function bullet.fade_in_render_a(self)
	if self._blend and self._a then
		SetImgState(self, self._blend, fade_in_alpha[self.timer] * self._a, self._r, self._g, self._b)
	else
		SetImgState(self, "mul+add", fade_in_alpha_255[self.timer], 255, 255, 255)
	end
	local s1, s2 = fade_in_scale[self.timer], fade_in_scale_inv[self.timer]
	self.hscale = self.hscale * s1
	self.vscale = self.vscale * s1
	DefaultRenderFunc(self)
	self.hscale = self.hscale * s2
	self.vscale = self.vscale * s2
	SetImgState(self, "", 255, 255, 255, 255)
end

--大型子弹雾化渲染
---@param self stg.bullet.object
function bullet.fade_in_render_b(self)
	if self._blend and self._a then
		SetImgState(self, self._blend, fade_in_alpha[self.timer] * self._a, self._r, self._g, self._b)
	else
		SetImgState(self, "mul+add", fade_in_alpha_255[self.timer], 255, 255, 255)
	end
	local s1, s2 = fade_in_scale[self.timer], fade_in_scale_inv[self.timer]
	self.hscale = self.hscale * s1
	self.vscale = self.vscale * s1
	DefaultRenderFunc(self)
	self.hscale = self.hscale * s2
	self.vscale = self.vscale * s2
	--Render(self.img, self.x, self.y, self.rot, self.hscale * fade_in_scale[self.timer], self.vscale * fade_in_scale[self.timer])
	SetImgState(self, "", 255, 255, 255, 255)
end

---@param self stg.bullet.object
function bullet.fade_in_del(self)
	bullet.fade_out_init(self, true)
end

---@param self stg.bullet.object
function bullet.fade_in_kill(self)
	item.PointSmall.create(self.x, self.y)
	bullet.fade_out_init(self, true)
end

----------------------------------------
--- normal

---@param self stg.bullet.object
function bullet.normal_init(self, layer)
	local v = self.style
	layer = layer or 0
	self.layer = LAYER_ENEMY_BULLET - v[BULLET_SIZE] * 0.001 + self.index * 0.00001 + layer
	self.dlayer = layer
	self.img = bullet_image[self._style][self.index]
	self.a = v[COLLI_A]
	self.b = v[COLLI_B]
	self.rect = v[COLLI_RECT]
	self.class = classB
	boundInit(self)
end

---@param self stg.bullet.object
---@param style number
---@param color number
---@param stay boolean
---@param indestructible boolean
---@param func function
function bullet.no_fade_normal_init(self, x, y, style, color, indestructible, layer)
	self.x, self.y = x, y
	local v = bullet_style[style]
	self.style = v
	self._style = style --存储自己种类的
	self.index = color
	if indestructible then
		self.group = GROUP_INDES
	else
		self.group = GROUP_ENEMY_BULLET
	end
	layer = layer or 0
	self.layer = LAYER_ENEMY_BULLET - self.style[BULLET_SIZE] * 0.001 + self.index * 0.00001 + layer
	self.dlayer = layer
	self.img = bullet_image[style][color]
	self.a = v[COLLI_A]
	self.b = v[COLLI_B]
	self.rect = v[COLLI_RECT]
	self.ex_frame = blankfun --帧逻辑
	boundInit(self)
end

---@param self stg.bullet.object
function bullet.normal_frame(self)
	boundFrame(self)
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
	item.PointSmall.create(self.x, self.y)
	bullet.fade_out_init(self, false)
end

----------------------------------------
--- fade out

local fade_out_alpha = {}
local fade_out_alpha_255 = {}

for t = 1, 16 do
	fade_out_alpha[t] = 1 - 1 * (t / 16)
	fade_out_alpha_255[t] = 255 * (1 - 1 * (t / 16))
end

---@param self stg.bullet.object
---@param type boolean
function bullet.fade_out_init(self)
	task.clear(self)
	self.status = "normal"
	self.timer = 1
	self.bound = false
	-- 消弹可在碰撞回调内触发。关闭判定后，下一帧再退出碰撞分组。
	self.colli = false
	self.fade_out = true
	if not self._blend then
		robject.set_color(self, "mul+add", 255, 255, 255, 255)
	else
		robject.set_color(self, "mul+add", self._a, self._r, self._g, self._b)
	end
	if self.x < -224 or self.x > 224 or self.y > 245 or self.y < -245 then
		self.status = "del"
	end
	--大型弹幕采用自己的贴图消失
	local style = self._style
	if IsBigBulletStyle(style) then
		self.dhscale = (-0.5 * self.hscale) / 16
		self.dvscale = (-0.5 * self.vscale) / 16
		self.class = classCB
	else
		self.img = "th43/etbreak"..self.index
		self.rot = ran:Float(0, 360)
		self.class = classCA
	end
end

--采用特殊消弹素材的方式消除
---@param self stg.bullet.object
function bullet.fade_out_frame_a(self)
	if self.group ~= GROUP_GHOST then self.group = GROUP_GHOST end
	if self.timer >= 23 then
		self.status = "del"
	end
end

---@param self stg.bullet.object
function bullet.fade_out_render_a(self)
	--SetImgState(self, "", 255, 255, 255, 255)
	RenderAnimation(self.img, self.timer, self.x, self.y, self.rot, self.hscale, self.vscale)
	--DefaultRenderFunc(self)
end

--采用自身img慢慢消失的方式消除
---@param self stg.bullet.object
function bullet.fade_out_frame_b(self)
	if self.group ~= GROUP_GHOST then self.group = GROUP_GHOST end
	self.hscale = self.hscale + self.dhscale
	self.vscale = self.vscale + self.dvscale
	if self.timer >= 16 then
		self.timer = 15
		self.status = "del"
	end
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
	bullet.fade_in_frame,
	bullet.fade_in_render_a,
	blankfun,
	bullet.fade_in_kill,
	is_class = true,
}
classAB = {
	blankfun,
	bullet.fade_in_del,
	bullet.fade_in_frame,
	bullet.fade_in_render_b,
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
	bullet.fade_out_frame_a,
	bullet.fade_out_render_a,
	blankfun,
	blankfun,
	is_class = true,
}
classCB = {
	blankfun,
	blankfun,
	bullet.fade_out_frame_b,
	bullet.fade_out_render_b,
	blankfun,
	blankfun,
	is_class = true,
}

for _, v in ipairs({ classAA, classAB, classB, classCA, classCB, }) do
	lstg.RegisterClass(v)
end

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
lstg.RegisterClass(_bullet)

---@param self stg.bullet.object
---@param style number @0 to use last style
---@param color number
function stg.setBulletStyle(self, style, color)
	if not self.fade_out then --变成消弹效果后此方法无效，否则会报错！
		local v = bullet_style[style] or self.style
		self.style = v
		self.index = color
		self._style = style
		self.img = bullet_image[style][color]
		self.a = v[COLLI_A]
		self.b = v[COLLI_B]
		self.rect = v[COLLI_RECT]
	end
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
function stg.newBullet(x, y, style, color, indestructible)
	return New(_bullet, x, y, style, color, indestructible)
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
function stg.newBulletStraight(x, y, v, a, style, color, indestructible)
	local u = New(_bullet, x, y, style, color, indestructible)
	SetV(u, v, a, true)
	return u
end

---class(style, color, stay, indestructible)
stg.bullet = _bullet

--新雾化效果（现在是被单独分离出来的对象了)
function stg.newFadeEffect(x, y, style, color, indestructible, func, no_bound)
	func = func or function() end
	local obj = New(_bullet, x, y, style, color, indestructible, func, no_bound)
	return obj
end

--新增的完全不处理雾化阶段的子弹
local _no_fade_bullet = {
	bullet.no_fade_normal_init,
	bullet.normal_del,
	bullet.normal_frame,
	bullet.normal_render,
	blankfun,
	bullet.normal_kill,
	is_class = true,
}
lstg.RegisterClass(_no_fade_bullet)

---@param style number
---@param color number
---@param indestructible boolean
---@return stg.bullet.object
function stg.newSimpleBullet(x, y, style, color, indestructible, layer)
	return New(_no_fade_bullet, x, y, style, color, indestructible, layer)
end

--通过修改frame的方法自定义一些写死的简单运动的子弹（注意，这个是专门为了性能处理的，甚至连task事件都不执行）
--有弹雾的(仿照羊妈上面写的，有点复杂
function stg.createBulletClass(simple_frame)
	local class0 = {
		blankfun,
		bullet.normal_del,
		simple_frame,
		bullet.normal_render,
		blankfun,
		bullet.normal_kill,
		is_class = true,
	}
	
	local function normal_init(self, dlayer)
		local v = self.style
		self.layer = LAYER_ENEMY_BULLET - v[BULLET_SIZE] * 0.001 + self.index * 0.00001 + (dlayer or 0)
		self.img = bullet_image[self._style][self.index]
		self.a = v[COLLI_A]
		self.b = v[COLLI_B]
		self.rect = v[COLLI_RECT]
		self.class = class0
		boundInit(self)
	end
	local function frame(self)
		boundFrame(self)
		self.x, self.y = self.initX, self.initY
		if self.timer >= 11 then
			self.timer = -1
			if self.IsEffect then
				self.status = "del"
			else
				normal_init(self, self.dlayer)
			end
		end
	end
	local class1 = {
		blankfun,
		bullet.fade_in_del,
		frame,
		bullet.fade_in_render_a,
		blankfun,
		bullet.fade_in_kill,
		is_class = true,
	}
	local class2 = {
		blankfun,
		bullet.fade_in_del,
		frame,
		bullet.fade_in_render_b,
		blankfun,
		bullet.fade_in_kill,
		is_class = true,
	}
	
	local function init(self, x, y, style, color, indestructible, IsEffect, dlayer)
		local v = bullet_style[style]
		self.initX, self.initY = x, y
		self.x, self.y = x, y
		self.style = v
		self._style = style --存储自己种类的
		self.index = color
		self.IsEffect = IsEffect --是否只作为特效（如果是的话雾化结束后自删
		if indestructible then
			self.group = GROUP_INDES
		else
			self.group = GROUP_ENEMY_BULLET
		end
		self.layer = LAYER_ENEMY_BULLET_EF - v[BULLET_SIZE] * 0.001 + color * 0.00001
		self.dlayer = dlayer
		if IsBigBulletStyle(style) then
			self.img = bullet_image[style][color] --大型子弹采用自己贴图作为雾化
			self.class = class2
		else
			self.img = "th43/preimg"..color   --普通子弹采用雾化贴图
			self.class = class1
		end
		self.a = v[COLLI_A]
		self.b = v[COLLI_B]
		self.rect = v[COLLI_RECT]
		boundInit(self)
	end
	local class = {
		init,
		bullet.normal_del,
		simple_frame,
		bullet.normal_render,
		blankfun,
		bullet.normal_kill,
		is_class = true,
	}
	
	for _, v in ipairs({ class0, class1, class2, class }) do
		lstg.RegisterClass(v)
	end
	
	return class
end
--没弹雾的
function stg.createSimpleBulletClass(simple_frame)
	local class = {
		bullet.no_fade_normal_init,
		bullet.normal_del,
		simple_frame,
		bullet.normal_render,
		blankfun,
		bullet.normal_kill,
		is_class = true,
	}
	lstg.RegisterClass(class)
	return class
end

--简单的直线匀速子弹
do
	local function init(obj, v, a)
		SetV(obj, v, a, true)
		boundInit(obj)
	end
	local function frame(obj)
		boundFrame(obj)
		--obj.ex_frame(obj)
	end
	local straight_class = stg.createBulletClass(frame)
	local simple_straight_class = stg.createSimpleBulletClass(frame)  --帧逻辑模块
	-----函数定义
	function stg.newStraight(x, y, v, a, style, color, indestructible, layer, isEffect)
		local obj = New(straight_class, x, y, style, color, indestructible, isEffect, layer)
		init(obj, v, a)
        return obj
	end
	function stg.newSimpleStraight(x, y, v, a, style, color, indestructible, layer)
		local obj = New(simple_straight_class, x, y, style, color, indestructible, layer)
		init(obj, v, a)
        return obj
	end
end


--简单的加速子弹
do
	local function init(obj, v, a, accelerate, accAng, accstartTime, acclastTime)
		SetV(obj, v, a, true)
		obj.accelerate, obj.accAng = accelerate, accAng
		accstartTime = accstartTime or 0
		acclastTime = acclastTime or 65535
		obj.accT1 = accstartTime
		obj.accT2 = accstartTime + acclastTime
		obj.ex_frame = blankfun --帧逻辑模块
		boundInit(obj)
	end
	local function frame(obj)
		boundFrame(obj)
		local timer = obj.timer
		if timer == obj.accT1 then  --startTime
			EGGlib.ObjectEvent.addA1(obj, obj.accelerate, obj.accAng)
		elseif timer == obj.accT2 then  --endTime
			obj.ax, obj.ay = 0, 0
		end
		obj.ex_frame(obj)  --帧逻辑模块
	end
	local straight_accelerate_class = stg.createBulletClass(frame)
	local simple_straight_accelerate_class = stg.createSimpleBulletClass(frame)
	-----函数定义
	function stg.newAcceleration(x, y, v, a, accelerate, accAng, accstartTime, acclastTime, style, color, indestructible, layer, isEffect)
		local obj = New(straight_accelerate_class, x, y, style, color, indestructible, isEffect, layer)
		init(obj, v, a, accelerate, accAng, accstartTime, acclastTime)
        return obj
	end
	function stg.newSimpleAcceleration(x, y, v, a, accelerate, accAng, accstartTime, acclastTime, style, color, indestructible, layer)
		local obj = New(simple_straight_accelerate_class, x, y, style, color, indestructible, layer)
		init(obj, v, a, accelerate, accAng, accstartTime, acclastTime)
        return obj
	end
    --另一种变速方式
    function stg.newStrChV(x, y, v0, v1, a0, t0, t1, style, color, indestructible, layer, isEffect)
        t1 = t1 or 0
        local accelerate = (v1-v0)/t0
        return stg.newAcceleration(x, y, v0, a0, accelerate, a0, t1, t0, style, color, indestructible, layer, isEffect)
    end
    function stg.newSimpleStrChV(x, y, v0, v1, a0, t0, t1, style, color, indestructible, layer)
        t1 = t1 or 0
        local accelerate = (v1-v0)/t0
        return stg.newSimpleAcceleration(x, y, v0, a0, accelerate, a0, t1, t0, style, color, indestructible, layer)
    end
	--对一些飞行的子弹重新设置状态
	function stg.resetAcceleration(obj, v, a, accelerate, accAng, accstartTime, acclastTime)
		init(obj, v, a, accelerate, accAng, accstartTime, acclastTime)
		obj.timer = 0 --计时器清零，重新开始
	end
	--另一种方式
	function stg.resetStrChV(obj, v0, v1, a0, t0, t1)
		t1 = t1 or 0
		local accelerate = (v1-v0)/t0
		stg.resetAcceleration(obj, v0, a0, accelerate, a0, t1, t0)
	end
end

--简单的变速变向子弹
do
	local function init(obj, v, dv, a, da, turnstartTime, turnlastTime)
		SetV(obj, v, a, true)
		obj.T1 = turnstartTime or 0
		obj.T2 = turnlastTime or 65535
		obj.velo = v
		obj.dvelo = dv
		obj.velo1 = v
		obj.da = da
		obj.da1 = 0
		obj.ex_frame = blankfun --帧逻辑模块
		boundInit(obj)
	end
	local function frame(obj)
		boundFrame(obj)
		local timer = obj.timer
		if timer >= obj.T1 and timer < obj.T2 then  --startTime
			obj.velo = obj.velo + obj.dvelo
			obj.rot = obj.rot + obj.da
			SetV(obj, obj.velo, obj.rot, true)
		elseif timer == obj.T2 then
			PlaySound("kira00")
			SetV(obj, obj.velo1, obj.rot + obj.da1, true)
		end
		obj.ex_frame(obj) --帧逻辑模块
	end
	local class = stg.createBulletClass(frame)
	local simple_class = stg.createSimpleBulletClass(frame)
	--函数定义
	function stg.newTurnBullet(x, y, v, dv, a, da, turnstartTime, turnlastTime, style, color, indestructible, layer, isEffect)
		local obj = New(class, x, y, style, color, indestructible, isEffect, layer)
		init(obj, v, dv, a, da, turnstartTime, turnlastTime)
		return obj
	end
	function stg.newSimpleTurnBullet(x, y, v, dv, a, da, turnstartTime, turnlastTime, style, color, indestructible, layer, isEffect)
		local obj = New(simple_class, x, y, style, color, indestructible, isEffect, layer)
		init(obj, v, dv, a, da, turnstartTime, turnlastTime)
		return obj
	end
	--另一种形式
	function stg.newTurnChV(x, y, v0, v1, a0, a1, t0, t1, style, color, indestructible, layer, isEffect)
		t0 = t0 or 0
		local dv = (v1-v0)/(t1-t0)
		local da = (a1-a0)/(t1-t0)
		return stg.newTurnBullet(x, y, v0, dv, a0, da, t0, t1, style, color, indestructible, layer, isEffect)
	end
	function stg.newSimpleTurnChV(x, y, v0, v1, a0, a1, t0, t1, style, color, indestructible, layer, isEffect)
		t0 = t0 or 0
		local dv = (v1-v0)/(t1-t0)
		local da = (a1-a0)/(t1-t0)
		return stg.newSimpleTurnBullet(x, y, v0, dv, a0, da, t0, t1, style, color, indestructible, layer, isEffect)
	end
end


--用子弹铺满屏幕（测试用功能
function stg.printAllBullet()
	local x, y = -180, 200
	for k, v in pairs(bullet_style) do
		--stg.newBullet(x, y, k, 5)
		stg.newStraight(x, y, 0.2, -90, k, 1)
		if x == 180 then
			x = x - 360
			y = y - 30
		else
			x = x + 30
		end
	end
	task.Wait(180)
	--EGGlib.ObjectEvent.clearEnemyAndBullet()
end

function stg.setBoundTime(obj, t)
	obj.bound_time = t
	obj.bound_flag = true
end
