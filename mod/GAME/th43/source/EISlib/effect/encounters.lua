---=====================================
---东方祈华梦游戏特效
---author:Xiliusha
---email:Xiliusha@outlook.com
---=====================================

--导入其他方法
local alphaAndSizeChangeTask = EGGlib.ObjectEvent.alphaAndSizeChangeTask
local alphaChange = EGGlib.ObjectEvent.alphaChange
local velch = EGGlib.ObjectEvent.velocityChange
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local accDecVelch = EGGlib.ObjectEvent.accDecVelocityChange
local sizeChange = EGGlib.ObjectEvent.sizeChange
local defaultRenderImg = EGGlib.RenderEffect.defaultRenderImg
local setSize = EGGlib.ObjectEvent.setSize
local spSizeAndColliChangeTask = EGGlib.ObjectEvent.spSizeAndColliChangeTask
local moveWith = EGGlib.ObjectEvent.moveWith

---@type EISlib
local lib = EISlib

---@class EISlib.Effect
local M = {}

---@type EISlib.Effect
lib.Effect = M

M.path = "res/effect/" --搬家了

local path = M.path
local sin, cos = lstg.sin, lstg.cos

---@class effect
local E = effect
local function load_res()
	local S = lstg.ResourceSet.create("EISlib.effect", "global")
	
	S:addTexture("_effect_par_texture", path .. "item_eff.png", false)
	S:addSpriteSequence("effect_par", "_effect_par_texture", 0, 0, 128, 128, 4, 4)

	--提示性文字如power up
	do
		local path = path.."hint/"
		--大部分提示性文字
		S:addTexture("_item_hint_new_texture", path .. "hint_new.png", false)
		local ktb = {
			"_hint_attack_time",
			"_hint_real_time",
			"_hint_next_stage",
			"_hint_spellcard_lose",
			"_hint_spellcard_get",
			"_hint_high_socre",
		}
		S:addSpriteSequence(ktb, "_item_hint_new_texture", 0, 0, 746, 92, 1, 6)
		S:addSpriteSequence("_hint_extend_", "_item_hint_new_texture", 0, 552, 248, 92, 3, 1)
		--加速加power
		S:addTexture("Speed_is_power", path .. "Speed_is_power.png", false)
		S:addSprite("speed_up", "Speed_is_power", 0, 99, 557, 99)
		S:addSprite("power_up", "Speed_is_power", 0, 0, 557, 99)
		--满p提示
		S:addSpriteFromFile("Full_Power_Mode", path.."Full_Power_Mode.png")--挂屏幕正上方的
		S:addSpriteFromFile("Full_Power_Mode2", path.."Full_Power_Mode2.png")--挂自机头上的
		--爆H提示
		S:addSpriteFromFile("Power_overwhelming", path.."Power_overwhelming.png")--挂屏幕正上方的
	end


	--以下为新开卡通用特效
	local spellshow_path = path.."spellshow/"
	S:addSpriteFromFile("attack_font", spellshow_path.."attack.png")
	S:addSpriteFromFile("attack_font_stroke", spellshow_path.."attack_stroke.png")
	S:addSpriteFromFile("diamond_shape", spellshow_path.."diamond.png")
	S:addSpriteFromFile("diamond_shape_stroke", spellshow_path.."diamond_stroke.png")
	S:addSpriteFromFile("lattice", spellshow_path.."lattice.png")
end
load_res()

local function load_res2()
	local S = lstg.ResourceSet.find("EISlib.effect")
	
	S:addSpriteFromFile('circle_eff', path .. 'circle_eff.png')
	S:addTexture('item_eff', path .. 'item_eff.png')
	S:addSprite('bamboo_leaf_white', 'item_eff', 0, 0, 128, 128)
	S:addSprite('star_eff_white', 'item_eff', 0, 128, 128, 128)
	S:addSprite('tree_leaf_white', 'item_eff', 0, 256, 128, 128)
	S:addSprite('tree_leaf', 'item_eff', 128, 256, 128, 128)
	--魔理沙的星星 和 uuz的鬼火
	S:addSprite('marisa_star', 'item_eff', 384, 256, 128, 128)
	S:addSprite('yuyuko_ghost', 'item_eff', 384, 384, 128, 128)
	--灵梦的枫叶 和 紫的星环
	S:addSprite('yukari_star', 'item_eff', 128, 128, 128, 128)
	S:addSprite('reimu_leaf', 'item_eff', 0, 384, 128, 128)
	--泡泡
	S:addSprite('s4_bubble_green', 'item_eff', 256, 0, 128, 128)
	S:addSprite('s4_bubble_blue', 'item_eff', 384, 0, 128, 128)
	S:addSprite('s4_bubble_orange', 'item_eff', 384, 128, 128, 128)
	S:addSprite('s4_bubble_white', 'item_eff', 256, 128, 128, 128)
	--星星粒子
	S:addSprite('star_particle', 'item_eff', 256, 265, 128, 128)
	--花瓣特效
	S:addSpriteFromFile("Cherry_eff", path.."Cherry_eff.png")
	path = "res/effect/"
	--骚气
	S:addSpriteFromFile('saoqi1', path .. 'saoqi1.png')
	S:addSpriteFromFile('saoqi2', path .. 'saoqi2.png')
	--正方形特效
	S:addTexture("tex.effect.diamond_disappear", path .. "effect_diamond_disappear.png", false)
	for i = 1, 8 do
		S:addSpriteSequence(
				string.format("effect.diamond_disappear.%d", i), "tex.effect.diamond_disappear",
				0, (i - 1) * 150, 150, 150, 4, 1)
	end
	
	LoadImageGroupFromFile("new_magic", path.."magic.png", true, 12, 1)
	LoadImageFromFile("enemy_aura", path.."enemy_aura.png")
	--雾
	S:addSpriteFromFile('fog', path .. 'fog.png')

	--新增表情包
	do
		local path = path.."expression/"
		local e = {"angry", "ellipsis", "love", "question", "shock", "stun", "tired"}
		for i = 1, #e do
			S:addSpriteFromFile("expression_"..e[i], path .. e[i]..".png")
			--以正下方为中心
			S:setSpriteCenter("expression_"..e[i], 23, 41)
		end
	end

	--新增气旋蓄力特效
	do
		local path = path.."absorb/"
		local e = {"halation", "ring"}
		for i = 1, #e do
			S:addSpriteFromFile("absorb_"..e[i], path .. e[i]..".png")
		end
		LoadTexture("absorb_cyclone", path.."cyclone.png")
		Add_bentlaser_texture("absorb_cyclone", "absorb_cyclone")
	end

	--
	LoadTexture("dec_bomb", path.."dec_bomb.png")
	LoadAnimation("-1bomb", "dec_bomb", 0, 0, 128, 128, 2, 1, 4)
	LoadAnimation("-2bomb", "dec_bomb", 0, 128, 128, 128, 2, 1, 4)
end
load_res2()

----------------------------------------
local spell_attack = Class(object)
function spell_attack:init(r, g, b)
	self.x, self.y = 300, 150
	self.layer = LAYER_ENEMY_BULLET + 6
	self.rot = 45
	self.bound = false
	self.hscale, self.vscale = 1.2, 1.2
	robject.set_color(self, "", 255, r, g, b)
	task.New(self, function()
		velch(self, 10, 0, -135, 10, 30)
		for i = 1, 3 do
			velch(self, 0.5, 0, -45 + 80*tranU(i), 1, 20)
		end
		alphaChangeTask(self, 255, 0, 15)
		velch(self, 10, 0, -135, 30, 60)
		Del(self)
	end)
end
function spell_attack:frame()
	task.Do(self)
end
function spell_attack:render()
	SetImageState("attack_font_stroke", "", Color(self._a, self._r, self._g, self._b))
	Render("attack_font_stroke", self.x, self.y, self.rot, 1, 1)
	SetImageState("attack_font", "", Color(self._a, 255, 255, 255))
	Render("attack_font", self.x, self.y, self.rot, 1, 1)
end
E.spell_attack = spell_attack

local diamond = Class(object)
function diamond:init(r, g, b)
	self.x, self.y = 0, 0
	self.layer = LAYER_ENEMY_BULLET + 2
	self.rot = 0
	self.bound = false
	robject.set_color(self, "", 0, r, g, b)
	self.hscale, self.vscale = 0, 0
	task.New(self, function()
		local t = 30
		local ds, d_a = 1.5/t, 255/t
		for _ = 1, t do
			self._a = self._a + d_a
			self.hscale, self.vscale = self.hscale + ds, self.vscale + ds
			task.Wait(1)
		end
		for _ = 1, t do
			self.hscale, self.vscale = self.hscale + ds, self.vscale + ds
			task.Wait(1)
		end
		ds = 0.5*ds
		d_a = -255/t
		for _ = 1, t do
			self._a = self._a + d_a
			self.hscale, self.vscale = self.hscale + ds, self.vscale + ds
			task.Wait(1)
		end
		Del(self)
	end)
end
function diamond:frame()
	task.Do(self)
end
function diamond:render()
	SetImageState("diamond_shape", "", Color(self._a, self._r, self._g, self._b))
	Render("diamond_shape", self.x, self.y, self.rot, self.hscale, self.vscale)
end
E.diamond = diamond

local diamondstroke = Class(object)
function diamondstroke:init(r, g, b)
	self.x, self.y = 0, 0
	self.layer = LAYER_ENEMY_BULLET + 3
	self.rot = 0
	self.bound = false
	robject.set_color(self, "", 255, r, g, b)
	self.hscale, self.vscale = 0, 0
	task.New(self, function()
		local t = 60
		local ds = 6/t
		for _ = 1, t do
			self.hscale, self.vscale = self.hscale + ds, self.vscale + ds
			task.Wait(1)
		end
		Del(self)
	end)
end
function diamondstroke:frame()
	task.Do(self)
end
function diamondstroke:render()
	SetImageState("diamond_shape_stroke", "", Color(self._a, self._r, self._g, self._b))
	Render("diamond_shape_stroke", self.x, self.y, self.rot, self.hscale, self.vscale)
end
E.diamondstroke = diamondstroke

local lattice = Class(object)
function lattice:init(r, g, b)
	self.x, self.y = -350, -350
	self.layer = LAYER_ENEMY_BULLET + 1
	self.rot = 45
	self.bound = false
	robject.set_color(self, "", 255, r, g, b)
	self.hscale, self.vscale = 2.5, 2.5
	task.New(self, function()
		velch(self, 12, 0, 45, 1, 40)
		for i = 1, 3 do
			velch(self, 1, 0, -45 + 90*tranU(i), 1, 20)
		end
		velch(self, 10, 0, 55, 30, 60)
		Del(self)
	end)
end
function lattice:frame()
	task.Do(self)
end
function lattice:render()
	SetImageState("lattice", "", Color(self._a, self._r, self._g, self._b))
	Render("lattice", self.x, self.y, self.rot, self.hscale, self.vscale)
end
E.lattice = lattice

local pic_show = Class(object)
function pic_show:init(pic_show_img, size)
	self.img = pic_show_img
	self.layer = LAYER_ENEMY_BULLET + 5
	self.x, self.y = -192, 180
	self.hscale, self.vscale = size, size
	self.rot = -5
	robject.set_color(self, "", 0, 255, 255, 255)
	alphaChangeTask(self, 0, 255, 30)
	task.New(self, function()
		--立绘移动
		velchTask(self, 10, 0, -90, 45)
		accDecVelch(self, 6, 0, 15, 15, 15)
		SetV(self, 0.25, 0)
		sizeChange(self, -0.05*size, 60)
		alphaChangeTask(self, 255, 0, 45)
		velch(self, 0, 2, 75, 45)
		Del(self)
	end)
end
function pic_show:frame()
	task.Do(self)
end
function pic_show:render()
	EGGlib.RenderEffect.defaultRenderImg(self)
end

local magic = Class(object)
function magic:init(img)
	self.img = img
	self.x, self.y = 0, 0
	self.layer = LAYER_ENEMY_BULLET + 4
	self.rot = 0
	self.bound = false
	self.omiga = -1
	robject.set_color(self, "", 255, 255, 255, 255)
	self.hscale, self.vscale = 0, 0
	task.New(self, function()
		sizeChange(self, 2.25, 30)
		task.Wait(90)
		sizeChange(self, -2.25, 30)
		Del(self)
	end)
end
function magic:frame()
	task.Do(self)
end
function magic:render()
	EGGlib.RenderEffect.defaultRenderImg(self)
end
E.magic = magic

E.generalSpellShow = function(pic_show_img, pic_size, magic_img, r, g, b)
	New(lattice, r, g, b)
	New(diamond, r, g, b)
	New(diamondstroke, r, g, b)
	New(magic, magic_img)
	New(pic_show, pic_show_img, pic_size)
	New(spell_attack, r, g, b)
	tasker(function()
		task.Wait(30)
		for _ = 1, 6 do
			for _ = 1, 2 do
				New(diamondstroke, r, g, b)
				task.Wait(3)
			end
			task.Wait(10)
		end
	end)
end
--endregion

--region 表情包
M.expression = Class(object)
function M.expression:init(x, y, type)
	robject.set_color(self, "", 255, 255, 255, 255)
	self.x, self.y = x, y
	self.img = "expression_"..type
end
function M.expression:frame()
	task.Do(self)
end
function M.expression:render()
	defaultRenderImg(self)
end
--默认演出方法
function M.expression:defaultShow(t0, t1, t2)
	setSize(self, 1, 0)
	task.New(self, function()
		t0 = t0 or 30
		local p, dp = 120
		local v = 1/sin(p)
		local dv = v/t0
		dp, p = p/t0, 0
		v = 0
		for _ = 1, t0 do
			v = v + dv
			p = p + dp
			self.vscale = v*sin(p)
			self.rot = ran:Int(-2, 2)
			task.Wait(1)
		end
		self.rot = 0
		t1 = t1 or 30
		task.Wait(t1)
		t2 = t2 or 30
		dv = -v/t2
		dp = -p/t2
		for _ = 1, t2 do
			v = v + dv
			p = p + dp
			self.vscale = v*sin(p)
			self.rot = ran:Int(-2, 2)
			task.Wait(1)
		end
		Del(self)
	end)
end
--endregion

