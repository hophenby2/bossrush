---=====================================
---东方祈华梦敌机渲染
---author:Xiliusha
---email:Xiliusha@outlook.com
---=====================================

local path = EISlib.Enemy.path
local respath = "res/enemy/"

local inrange = math.inrange

local Color = lstg.Color
local SetImageState = lstg.SetImageState
local SetAnimationState = lstg.SetAnimationState
local Render = lstg.Render
local RenderAnimation = lstg.RenderAnimation
local DefaultRenderFunc = lstg.DefaultRenderFunc

local COLOR_WHITE = Color(255, 255, 255, 255)

local PRELOAD = EISlib.Enemy.PRELOAD

----------------------------------------
---res

---@type EISlib.Enemy.WalkImageSystem
local wisys = lstg.DoFile(path .. "enemy_animation.lua")

local function load_res()
	local ST = "stage"
	if PRELOAD then
		ST = "global"
	end
	local S = lstg.ResourceSet.Create("EISlib.enemy.render", ST)

	S:AddTexture("_enemy_texture_1", respath .. "fairy_small_mid.png", false)
	S:AddTexture("_enemy_texture_2", respath .. "fairy_large.png", false)
	S:AddTexture("_enemy_texture_3", respath .. "fairy_small_mid_2.png", false)
	S:AddTexture("_enemy_texture_4", respath .. "fairy_small_ball.png", false)
	S:AddTexture("_enemy_texture_5", respath .. "fairy_gold_stroke.png", false)

	-- 小妖精
	for i = 1, 4 do
		S:AddSpriteSequence("fairy_small" .. i, "_enemy_texture_1", 0, (i - 1) * 80, 80, 80, 10, 1)
	end
	-- 中妖精
	for i = 1, 4 do
		S:AddSpriteSequence("fairy_mid" .. i, "_enemy_texture_1", 0, 320 + (i - 1) * 96, 96, 96, 9, 1)
	end
	-- 大妖精
	for i = 1, 4 do
		S:AddSpriteSequence("fairy_large" .. i, "_enemy_texture_2", 0, (i - 1) * 240, 120, 120, 8, 2)
	end
	-- 仙界小妖精
	for i = 1, 4 do
		S:AddSpriteSequence("fairy_small_2_" .. i, "_enemy_texture_3", 0, (i - 1) * 80, 80, 80, 10, 1)
	end
	-- 仙界中妖精
	for i = 1, 4 do
		S:AddSpriteSequence("fairy_mid_2_" .. i, "_enemy_texture_3", 0, 320 + (i - 1) * 96, 96, 96, 10, 1)
	end
	-- 外界小妖精
	for i = 1, 10 do
		for j = 1, 4 do
			S:AddSprite("fairy_small_3_" .. j .. i, "_enemy_texture_4", (i - 1) * 94, (j - 1) * 92, 94, 92)
		end
	end
	for i = 11, 12 do
		for j = 1, 4 do
			S:AddSprite("fairy_small_3_" .. j .. i, "_enemy_texture_4", (i - 11) * 94 + (j - 1) * 188, 368, 94, 92)
		end
	end
	-- 外界中妖精
	for i = 1, 8 do
		S:AddSprite("fairy_mid_3_1" .. i, "_enemy_texture_4", (i - 1) * 120, 784, 120, 120)
	end
	for i = 1, 2 do
		S:AddSprite("fairy_mid_3_1" .. (i + 8), "_enemy_texture_4", 784 + (i - 1) * 120, 424, 120, 120)
	end
	for i = 1, 8 do
		S:AddSprite("fairy_mid_3_2" .. i, "_enemy_texture_4", (i - 1) * 120, 904, 120, 120)
	end
	for i = 1, 2 do
		S:AddSprite("fairy_mid_3_2" .. (i + 8), "_enemy_texture_4", 784 + (i - 1) * 120, 544, 120, 120)
	end
	for i = 1, 6 do
		S:AddSprite("fairy_mid_3_3" .. i, "_enemy_texture_4", 304 + (i - 1) * 120, 664, 120, 120)
	end
	for i = 1, 4 do
		S:AddSprite("fairy_mid_3_3" .. (i + 6), "_enemy_texture_4", 304 + (i - 1) * 120, 544, 120, 120)
	end

	-- 通用魔法阵
	S:AddSpriteSequence("magic", "_enemy_texture_1", 0, 704, 128, 128, 8, 1)
	-- 阴阳玉
	S:AddSpriteSequence("fairy_aura", "_enemy_texture_3", 0, 704, 128, 128, 8, 1)
	S:AddSpriteSequence("fairy_aura_magic", "_enemy_texture_3", 0, 832, 128, 128, 8, 1)
	--毛玉
	S:AddSpriteSequence("fairy_ball", "_enemy_texture_4", 0, 460, 128, 128, 2, 2)
	--鬼火小怪
	S:AddTexture("_ghost_fire_1_texture", respath .. "ghost_fire_1.png", false)
	S:AddTexture("_ghost_fire_2_texture", respath .. "ghost_fire_2.png", false)
	S:AddTexture("_ghost_fire_3_texture", respath .. "ghost_fire_3.png", false)
	S:AddTexture("_ghost_fire_4_texture", respath .. "ghost_fire_4.png", false)
	S:AddAnimation("ghost_fire1", "_ghost_fire_1_texture", 0, 0, 152, 240, 5, 4, 4)
	S:SetAnimationCenter("ghost_fire1", 76, 148)
	S:AddAnimation("ghost_fire2", "_ghost_fire_2_texture", 0, 0, 152, 240, 5, 4, 4)
	S:SetAnimationCenter("ghost_fire2", 76, 148)
	S:AddAnimation("ghost_fire3", "_ghost_fire_3_texture", 0, 0, 152, 240, 5, 4, 4)
	S:SetAnimationCenter("ghost_fire3", 76, 148)
	S:AddAnimation("ghost_fire4", "_ghost_fire_4_texture", 0, 0, 152, 240, 5, 4, 4)
	S:SetAnimationCenter("ghost_fire4", 76, 148)

	--金色传说
	S:AddSpriteSequence("fairy_small_gold_stroke_", "_enemy_texture_5", 0, 0, 80, 80, 10, 1)
	S:AddSpriteSequence("fairy_mid_gold_stroke_", "_enemy_texture_5", 0, 80, 96, 96, 9, 1)
	S:AddSpriteSequence("fairy_large_gold_stroke_", "_enemy_texture_5", 0, 176, 120, 120, 8, 2)
	S:AddSpriteSequence("fairy_small_2_gold_stroke_", "_enemy_texture_5", 0, 416, 80, 80, 10, 1)
	S:AddSpriteSequence("fairy_mid_2_gold_stroke_", "_enemy_texture_5", 0, 496, 96, 96, 10, 1)
	S:AddSpriteSequence("fairy_small_3_gold_stroke_", "_enemy_texture_5", 0, 592, 94, 92, 10, 2)
	S:AddSpriteSequence("fairy_mid_3_gold_stroke_", "_enemy_texture_5", 0, 776, 120, 120, 8, 1)
	for i = 1, 2 do
		S:AddSprite("fairy_mid_3_gold_stroke_" .. (i + 8), "_enemy_texture_5", 720 + (i - 1) * 120, 296, 120, 120)
	end
end
load_res()

EventDispatcher.AddListener("EISlib.enemy.render", EVENT.ON_GAME_STAGE_INIT, 0, function()
	if not PRELOAD then
		lstg.ResourceSet.Find("EISlib.enemy.render"):Load()
	end
end)

----------------------------------------
---style set

---@param obj enemy.object
---@param style number
local function set_style_fairy_small(obj, style)
	obj._wisys:setAction("normal", false, false, 1, 2, 3, 4, 5)
	obj._wisys:setAction("right", false, false, 6, 7)
	obj._wisys:setAction("rightloop", false, false, 8, 9, 10)
	obj._wisys:setAction("left", true, false, 6, 7)
	obj._wisys:setAction("leftloop", true, false, 8, 9, 10)
	obj._wisys:setImages("fairy_small" .. style, 6)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_mid(obj, style)
	obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._wisys:setAction("right", false, false, 5, 6)
	obj._wisys:setAction("rightloop", false, false, 7, 8, 9)
	obj._wisys:setAction("left", true, false, 5, 6)
	obj._wisys:setAction("leftloop", true, false, 7, 8, 9)
	obj._wisys:setImages("fairy_mid" .. style, 6)
	obj._wisys:setScale(1.25, 1.25)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_large(obj, style)
	obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._wisys:setAction("right", false, false, 5, 6)
	obj._wisys:setAction("rightloop", false, false, 7, 8, 9)
	obj._wisys:setAction("left", true, false, 5, 6)
	obj._wisys:setAction("leftloop", true, false, 7, 8, 9)
	obj._wisys:setImages("fairy_large" .. style, 6)
	obj._wisys:setScale(1.25, 1.25)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_small_2(obj, style)
	obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._wisys:setAction("right", false, false, 5, 6)
	obj._wisys:setAction("rightloop", false, false, 7, 8, 9, 10)
	obj._wisys:setAction("left", true, false, 5, 6)
	obj._wisys:setAction("leftloop", true, false, 7, 8, 9, 10)
	obj._wisys:setImages("fairy_small_2_" .. style, 6)
	obj._wisys:setScale(1.15, 1.15)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_mid_2(obj, style)
	obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._wisys:setAction("right", false, false, 5, 6)
	obj._wisys:setAction("rightloop", false, false, 7, 8, 9, 10)
	obj._wisys:setAction("left", true, false, 5, 6)
	obj._wisys:setAction("leftloop", true, false, 7, 8, 9, 10)
	obj._wisys:setImages("fairy_mid_2_" .. style, 6)
	obj._wisys:setScale(1.25, 1.25)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_small_3(obj, style)
	obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._wisys:setAction("right", false, false, 5, 6, 7, 8)
	obj._wisys:setAction("rightloop", false, false, 9, 10, 11, 12)
	obj._wisys:setAction("left", true, false, 5, 6, 7, 8)
	obj._wisys:setAction("leftloop", true, false, 9, 10, 11, 12)
	obj._wisys:setImages("fairy_small_3_" .. style, 6)
	obj._wisys:setScale(1.0, 1.0)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_mid_3(obj, style)
	style = math.clamp(style, 1, 3)
	obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._wisys:setAction("right", false, false, 5, 6)
	obj._wisys:setAction("rightloop", false, false, 7, 8, 9, 10)
	obj._wisys:setAction("left", true, false, 5, 6)
	obj._wisys:setAction("leftloop", true, false, 7, 8, 9, 10)
	obj._wisys:setImages("fairy_mid_3_" .. style, 6)
	obj._wisys:setScale(1.25, 1.25)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_small_stroke(obj, style)
	set_style_fairy_small(obj, style)
	obj._stroke_wisys:setAction("normal", false, false, 1, 2, 3, 4, 5)
	obj._stroke_wisys:setAction("right", false, false, 6, 7)
	obj._stroke_wisys:setAction("rightloop", false, false, 8, 9, 10)
	obj._stroke_wisys:setAction("left", true, false, 6, 7)
	obj._stroke_wisys:setAction("leftloop", true, false, 8, 9, 10)
	obj._stroke_wisys:setImages("fairy_small_gold_stroke_", 6)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_mid_stroke(obj, style)
	set_style_fairy_mid(obj, style)
	obj._stroke_wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._stroke_wisys:setAction("right", false, false, 5, 6)
	obj._stroke_wisys:setAction("rightloop", false, false, 7, 8, 9)
	obj._stroke_wisys:setAction("left", true, false, 5, 6)
	obj._stroke_wisys:setAction("leftloop", true, false, 7, 8, 9)
	obj._stroke_wisys:setImages("fairy_mid_gold_stroke_", 6)
	obj._stroke_wisys:setScale(1.25, 1.25)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_large_stroke(obj, style)
	set_style_fairy_large(obj, style)
	obj._stroke_wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._stroke_wisys:setAction("right", false, false, 5, 6)
	obj._stroke_wisys:setAction("rightloop", false, false, 7, 8, 9)
	obj._stroke_wisys:setAction("left", true, false, 5, 6)
	obj._stroke_wisys:setAction("leftloop", true, false, 7, 8, 9)
	obj._stroke_wisys:setImages("fairy_large_gold_stroke_", 6)
	obj._stroke_wisys:setScale(1.25, 1.25)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_small_2_stroke(obj, style)
	set_style_fairy_small_2(obj, style)
	obj._stroke_wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._stroke_wisys:setAction("right", false, false, 5, 6)
	obj._stroke_wisys:setAction("rightloop", false, false, 7, 8, 9, 10)
	obj._stroke_wisys:setAction("left", true, false, 5, 6)
	obj._stroke_wisys:setAction("leftloop", true, false, 7, 8, 9, 10)
	obj._stroke_wisys:setImages("fairy_small_2_gold_stroke_", 6)
	obj._stroke_wisys:setScale(1.15, 1.15)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_mid_2_stroke(obj, style)
	set_style_fairy_mid_2(obj, style)
	obj._stroke_wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._stroke_wisys:setAction("right", false, false, 5, 6)
	obj._stroke_wisys:setAction("rightloop", false, false, 7, 8, 9, 10)
	obj._stroke_wisys:setAction("left", true, false, 5, 6)
	obj._stroke_wisys:setAction("leftloop", true, false, 7, 8, 9, 10)
	obj._stroke_wisys:setImages("fairy_mid_2_gold_stroke_", 6)
	obj._stroke_wisys:setScale(1.25, 1.25)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_small_3_stroke(obj, style)
	set_style_fairy_small_3(obj, style)
	obj._stroke_wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._stroke_wisys:setAction("right", false, false, 5, 6, 7, 8)
	obj._stroke_wisys:setAction("rightloop", false, false, 9, 10, 11, 12)
	obj._stroke_wisys:setAction("left", true, false, 5, 6, 7, 8)
	obj._stroke_wisys:setAction("leftloop", true, false, 9, 10, 11, 12)
	obj._stroke_wisys:setImages("fairy_small_3_gold_stroke_", 6)
	obj._stroke_wisys:setScale(1.0, 1.0)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_mid_3_stroke(obj, style)
	set_style_fairy_mid_3(obj, style)
	obj._stroke_wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._stroke_wisys:setAction("right", false, false, 5, 6)
	obj._stroke_wisys:setAction("rightloop", false, false, 7, 8, 9, 10)
	obj._stroke_wisys:setAction("left", true, false, 5, 6)
	obj._stroke_wisys:setAction("leftloop", true, false, 7, 8, 9, 10)
	obj._stroke_wisys:setImages("fairy_mid_3_gold_stroke_", 6)
	obj._stroke_wisys:setScale(1.25, 1.25)
end

----------------------------------------
---style manager

---@class EISlib.Enemy.StyleManager : etc.class
local stylemgr = etc.class(false, false)

---@type number[]
local death_color_index = {
	--小妖精
	1, 3, 5, 7,
	--中妖精
	1, 3, 5, 7,
	--大妖精
	1, 3, 5, 7,
	--毛玉
	1, 3, 5, 7,
	--魔法阵鬼火
	1, 3, 5, 7,
	--鬼火
	1, 3, 5, 7,
	--仙界小妖精
	1, 3, 5, 6,
	--仙界中妖精
	1, 3, 5, 6,
	--阴阳玉
	1, 2, 3, 4, 5, 6, 6, 8,
	--外界小妖精
	1, 2, 5, 7,
	--外界中妖精
	1, 2, 5, 5,
	-- 49 ~ 60
	0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	--小妖精（金色描边）
	1, 3, 5, 7,
	--中妖精（金色描边）
	1, 3, 5, 7,
	--大妖精（金色描边）
	1, 3, 5, 7,
	--仙界小妖精（金色描边）
	1, 3, 5, 6,
	--仙界中妖精（金色描边）
	1, 3, 5, 6,
	--外界小妖精（金色描边）
	1, 2, 5, 7,
	--外界中妖精（金色描边）
	1, 2, 5, 5,
}

---@param obj enemy.object
---@return EISlib.Enemy.StyleManager
function stylemgr:constructor(obj)
	self.obj = obj
	self.init = false
	self.alpha = 1
	obj._style = -1
	obj._wisys = wisys.new():constructor(obj)
	obj._stroke_wisys = wisys.new():constructor(obj)
	return self
end

function stylemgr:update()
	if self.init then
		local obj = self.obj
		if inrange(obj._style, 1, 12)
				or inrange(obj._style, 25, 32)
				or inrange(obj._style, 41, 48)
				or inrange(obj._style, 61, 88) then
			obj._wisys:update()
			obj._wisys:setAlpha(self.alpha)
		end
		if inrange(obj._style, 61, 88) then
			obj._stroke_wisys:update()
			obj._stroke_wisys:setAlpha(self.alpha)
		end
	end
end

function stylemgr:draw()
	if self.init then
		local obj = self.obj
		--受攻击变色处理
		local dmgt, maxdmgt = obj.dmgt, obj.dmgmaxt
		local cani = 0
		if dmgt and maxdmgt then
			cani = dmgt / maxdmgt
		end
		local color = COLOR_WHITE
		local blend = obj._blend or ""
		if obj._blend then
			color = Color(self.alpha * obj._a, obj._r - obj._r * 0.75 * cani, obj._g - obj._g * 0.75 * cani, obj._b)
		elseif obj._a then
			color = Color(self.alpha * obj._a, 255 - 255 * 0.75 * cani, 255 - 255 * 0.75 * cani, 255)
		else
			color = Color(self.alpha * 255, 255 - 255 * 0.75 * cani, 255 - 255 * 0.75 * cani, 255)
		end
		--渲染
		local _style = obj._style
		if inrange(_style, 1, 12)
				or inrange(_style, 25, 32)
				or inrange(_style, 41, 48)
				or inrange(obj._style, 61, 88) then
			--描边特效
			if inrange(_style, 61, 88) then
				obj._stroke_wisys:draw()
			end
			--普通妖精
			obj._wisys:draw(dmgt, maxdmgt)
		elseif inrange(_style, 13, 16) then
			--毛玉
			--渲染法阵
			local scale = 0.8
			local index = { 1, 6, 4, 8 }
			local img = "magic" .. index[_style - 12]
			if obj._blend then
				SetImageState(img, obj._blend, Color(self.alpha * obj._a, obj._r, obj._g, obj._b))
				Render(img, obj.x, obj.y, obj.ani * 2, scale * obj.hscale, scale * obj.vscale)
				SetImageState(img, "", COLOR_WHITE)
			else
				SetImageState(img, "", COLOR_WHITE)
				Render(img, obj.x, obj.y, obj.ani * 2, scale * obj.hscale, scale * obj.vscale)
			end
			--渲染自己
			img = "fairy_ball" .. (_style - 12)
			SetImageState(img, blend, color)
			Render(img, obj.x, obj.y, -obj.ani * 4, 0.54 * obj.hscale, 0.54 * obj.vscale)
		elseif inrange(_style, 17, 24) then
			--鬼火
			local ani = ""
			if _style <= 20 then
				ani = "ghost_fire" .. (_style - 16)
				--渲染法阵
				local scale = 0.8
				local index = { 1, 6, 4, 8 }
				local img = "magic" .. index[_style - 16]
				if obj._blend then
					SetImageState(img, obj._blend, Color(self.alpha * obj._a, obj._r, obj._g, obj._b))
					Render(img, obj.x, obj.y, obj.ani * 2, scale * obj.hscale, scale * obj.vscale)
					SetImageState(img, "", COLOR_WHITE)
				else
					SetImageState(img, "", COLOR_WHITE)
					Render(img, obj.x, obj.y, obj.ani * 2, scale * obj.hscale, scale * obj.vscale)
				end
			else
				ani = "ghost_fire" .. (_style - 20)
			end
			local scale = 0.9
			local function draw_fire()
				if RenderAnimation then
					RenderAnimation(ani, obj.ani, obj.x, obj.y, obj.rot, scale * obj.hscale, scale * obj.vscale)
				else
					local lastimg = obj.img
					obj.img = ani
					obj.hscale = obj.hscale * scale
					obj.hscale = obj.vscale * scale
					DefaultRenderFunc(obj)
					obj.img = lastimg
					obj.hscale = obj.hscale / scale
					obj.vscale = obj.vscale / scale
				end
			end
			SetAnimationState(ani, blend, color)
			draw_fire()
		elseif inrange(_style, 33, 40) then
			--阴阳玉
			local magic_img = "fairy_aura_magic" .. (_style - 32)
			local img = "fairy_aura" .. (_style - 32)
			local scale1, scale2, scale = 0.85, 0.7, 0.65
			if obj._blend then
				SetImageState(magic_img, obj._blend, Color(self.alpha * obj._a, obj._r, obj._g, obj._b))
				Render(magic_img, obj.x, obj.y, obj.ani * 2, scale1 * obj.hscale, scale1 * obj.vscale)
				Render(magic_img, obj.x, obj.y, -obj.ani * 2, scale2 * obj.hscale, scale2 * obj.vscale)
				SetImageState(magic_img, "", COLOR_WHITE)
			else
				Render(magic_img, obj.x, obj.y, obj.ani * 2, scale1 * obj.hscale, scale1 * obj.vscale)
				Render(magic_img, obj.x, obj.y, -obj.ani * 2, scale2 * obj.hscale, scale2 * obj.vscale)
			end
			SetImageState(img, blend, color)
			Render(img, obj.x, obj.y, obj.ani * 2, scale * obj.hscale, scale * obj.vscale)
		end
	end
end

---@param style number
function stylemgr:setStyle(style)
	local obj = self.obj
	if obj._style == style then
		return
	end
	obj._style = style
	obj._death_color = death_color_index[style] or 1
	-- 行走图、碰撞判定大小
	if inrange(style, 1, 4) then
		--小妖精
		set_style_fairy_small(obj, style)
		obj.a, obj.b = 16, 16
	elseif inrange(style, 5, 8) then
		--中妖精
		set_style_fairy_mid(obj, style - 4)
		obj.a, obj.b = 24, 24
	elseif inrange(style, 9, 12) then
		--大妖精
		set_style_fairy_large(obj, style - 8)
		obj.a, obj.b = 32, 32
	elseif inrange(style, 13, 16) then
		--毛玉
		obj.a, obj.b = 16, 16
	elseif inrange(style, 17, 24) then
		--鬼火
		obj.a, obj.b = 16, 16
	elseif inrange(style, 25, 28) then
		--4面小妖精
		set_style_fairy_small_2(obj, style - 24)
		obj.a, obj.b = 16, 16
	elseif inrange(style, 29, 32) then
		--4面中妖精
		set_style_fairy_mid_2(obj, style - 28)
		obj.a, obj.b = 24, 24
	elseif inrange(style, 33, 40) then
		--阴阳玉
		obj.a, obj.b = 16, 16
	elseif inrange(style, 41, 44) then
		--ex面小妖精
		set_style_fairy_small_3(obj, style - 40)
		obj.a, obj.b = 16, 16
	elseif inrange(style, 45, 48) then
		--ex面中妖精
		set_style_fairy_mid_3(obj, style - 44)
		obj.a, obj.b = 24, 24
	elseif inrange(style, 61, 64) then
		--小妖精（描边特效）
		set_style_fairy_small_stroke(obj, style - 60)
		obj.a, obj.b = 16, 16
	elseif inrange(style, 65, 68) then
		--中妖精（描边特效）
		set_style_fairy_mid_stroke(obj, style - 64)
		obj.a, obj.b = 24, 24
	elseif inrange(style, 69, 72) then
		--大妖精（描边特效）
		set_style_fairy_large_stroke(obj, style - 68)
		obj.a, obj.b = 32, 32
	elseif inrange(style, 73, 76) then
		--4面小妖精（描边特效）
		set_style_fairy_small_2_stroke(obj, style - 72)
		obj.a, obj.b = 16, 16
	elseif inrange(style, 77, 80) then
		--4面中妖精（描边特效）
		set_style_fairy_mid_2_stroke(obj, style - 76)
		obj.a, obj.b = 24, 24
	elseif inrange(style, 81, 84) then
		--ex面小妖精（描边特效）
		set_style_fairy_small_3_stroke(obj, style - 80)
		obj.a, obj.b = 16, 16
	elseif inrange(style, 85, 88) then
		--ex面中妖精（描边特效）
		set_style_fairy_mid_3_stroke(obj, style - 84)
		obj.a, obj.b = 24, 24
	else
		error("Unknown enemy style.", 2)
	end
	self.init = true
end

---@return number
function stylemgr:getStyle()
	local obj = self.obj
	return obj._style or 1
end

---@param a number @default to 1
function stylemgr:setAlpha(a)
	a = a or 0
	self.alpha = a
end

----------------------------------------
---out

return stylemgr
