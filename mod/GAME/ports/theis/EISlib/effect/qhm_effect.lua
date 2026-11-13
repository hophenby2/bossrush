---=====================================
--- 东方祈华梦游戏特效
--- author: Xiliusha, S7UPID
--- email : Xiliusha@outlook.com
---=====================================

qhm_eff = qhm_eff or {}

----------------------------------------
---res

local function load_res()
	local S = lstg.ResourceSet.Find("EISlib.effecy")

	local path = EISlib.Effect.path
	S:AddSpriteFromFile('circle_eff', path .. 'circle_eff.png')
	S:AddTexture('item_eff', path .. 'item_eff.png')
	S:AddSprite('bamboo_leaf_white', 'item_eff', 0, 0, 128, 128)
	S:AddSprite('star_eff_white', 'item_eff', 0, 128, 128, 128)
	S:AddSprite('tree_leaf_white', 'item_eff', 0, 256, 128, 128)
	S:AddSprite('tree_leaf', 'item_eff', 128, 256, 128, 128)
	--9.11新增特效
	S:AddSpriteFromFile('circle_eff1', path .. 'circle_eff1.png')
	S:AddSpriteFromFile('circle_eff2', path .. 'circle_eff2.png')
	S:AddSpriteFromFile('starlight', path .. 'starlight.png')
	--魔理沙的星星 和 uuz的鬼火
	S:AddSprite('marisa_star', 'item_eff', 384, 256, 128, 128)
	S:AddSprite('yuyuko_ghost', 'item_eff', 384, 384, 128, 128)
	--灵梦的枫叶 和 紫的星环
	S:AddSprite('yukari_star', 'item_eff', 128, 128, 128, 128)
	S:AddSprite('reimu_leaf', 'item_eff', 0, 384, 128, 128)
	--四boss的泡泡
	S:AddSprite('s4_bubble_green', 'item_eff', 256, 0, 128, 128)
	S:AddSprite('s4_bubble_blue', 'item_eff', 384, 0, 128, 128)
	S:AddSprite('s4_bubble_orange', 'item_eff', 384, 128, 128, 128)
	S:AddSprite('s4_bubble_white', 'item_eff', 256, 128, 128, 128)
	--危险警告圈
	path = "res/effect/"
	S:AddSpriteFromFile('danger_eff', path .. 'danger_eff.png')
	--骚气
	S:AddSpriteFromFile('saoqi1', path .. 'saoqi1.png')
	S:AddSpriteFromFile('saoqi2', path .. 'saoqi2.png')
end
load_res()

----------------------------------------
---define

--通用特效
--蓄力内缩圈
local eff_11 = Class(object)
function eff_11:init(x, y, size, r, g, b, blend, Isbreak)
	blend = blend or "mul+add"
	self.group = GROUP_GHOST
	self.layer = LAYER_PLAYER_BULLET + 1
	self.img = 'circle_eff'
	self.x, self.y = x, y
	_object.set_color(self, blend, 255 * cos(x), r, g, b)
	task.New(self, function()
		local x, dx
		if Isbreak then
			x, dx = 0, 90 / 59
		else
			x, dx = -90, 90 / 59
		end
		for _ = 1, 60 do
			self.hscale, self.vscale = size * sin(x), size * sin(x)
			self._a = 255 * cos(x)
			x = x + dx
			task.Wait(1)
		end
		Del(self)
	end)
end
function eff_11:frame()
	task.Do(self)
end
function eff_11:render()
	_object.render(self)
end
qhm_eff.eff_11 = eff_11

--飞入的道具
local eff_12 = Class(object)
function eff_12:init(img, x, y, x0, y0, size, R, G, B, blend)
	blend = blend or "mul+add"
	self.group = GROUP_GHOST
	self.layer = LAYER_PLAYER - 1
	self.img = img or "img_void"
	self.x, self.y = x, y
	self.hscale, self.vscale = 0, 0
	self.rot = ran:Float(0, 360)
	self.bound = false
	_object.set_color(self, blend, 255, R, G, B)
	task.New(self, function()
		task.MoveTo(x0, y0, 60, MOVE_DECEL)
	end)
	task.New(self, function()
		local x, dx = -90, 180 / 59
		for _ = 1, 60 do
			self.hscale, self.vscale = 2.5 * size * sin(0.5 * x), 2.5 * size * sin(1.5 * x)
			self._a = 255 * cos(x)
			x = x + dx
			task.Wait(1)
		end
		Del(self)
	end)
end
function eff_12:frame()
	task.Do(self)
end
function eff_12:render()
	_object.render(self)
end
qhm_eff.eff_12 = eff_12

--蓄力特效
local absorb_eff = Class(object)
function absorb_eff:init(x, y, img1, img2, R, G, B, blend)
	blend = blend or "mul+add"
	local imgs = { img1 or 'bamboo_leaf_white', img2 or 'tree_leaf_white' }
	self.bound = false
	self.x, self.y = 0, 0
	PlaySound("power02", 0.5)
	task.New(self, function()
		New(eff_11, x, y, 3.1, R, G, B, blend)
		local a, r
		for _ = 1, 30 do
			for _ = 1, 3 do
				a, r = ran:Float(0, 360), ran:Float(350, 600)
				New(eff_12, imgs[ran:Int(1, 2)], x + r * cos(a), y + r * sin(a), x, y, ran:Float(0.5, 1.25), R, G, B, blend)
			end
			task.Wait(1)
		end
		Del(self)
	end)
	task.New(self, function()
		local a, r
		for _ = 1, 20 do
			for _ = 1, 4 do
				a, r = ran:Float(0, 360), ran:Float(300, 600)
				New(eff_12, imgs[ran:Int(1, 2)], x + r * cos(a), y + r * sin(a), x, y, ran:Float(0.075, 0.125), R, G, B, blend)
			end
			task.Wait(2)
		end
	end)
end
function absorb_eff:frame()
	task.Do(self)
end
AbEff = absorb_eff --导出新版的蓄力特效

--蓄力后炸开的特效
local break_eff = Class(object)
function break_eff:init(x, y, img1, img2, R, G, B, blend)
	blend = blend or "mul+add"
	local imgs = { img1 or 'bamboo_leaf_white', img2 or 'tree_leaf_white' }
	self.bound = false
	self.x, self.y = 0, 0
	PlaySound("power02", 0.5)
	task.New(self, function()
		New(eff_11, x, y, 3.1, R, G, B, blend, true)
		local a, r
		for _ = 1, 30 do
			for _ = 1, 3 do
				a, r = ran:Float(0, 360), ran:Float(50, 600)
				New(eff_12, imgs[ran:Int(1, 2)], x, y, x + r * cos(a), y + r * sin(a), ran:Float(0.5, 1.25), R, G, B)
			end
			task.Wait(1)
		end
		Del(self)
	end)
	task.New(self, function()
		local a, r
		for _ = 1, 20 do
			for _ = 1, 4 do
				a, r = ran:Float(0, 360), ran:Float(150, 600)
				New(eff_12, imgs[ran:Int(1, 2)], x, y, x + r * cos(a), y + r * sin(a), ran:Float(0.075, 0.125), R, G, B)
			end
			task.Wait(2)
		end
	end)
end
function break_eff:frame()
	task.Do(self)
end
BkEff = break_eff

--单独的蓄力圈
AbCircle = Class(object)
function AbCircle:init(x, y, size, r, g, b)
	self.bound = false
	self.x, self.y = x, y
	self.img = 'circle_eff'
	self.group = GROUP_GHOST
	self.size = size or 1
	self._a = 0
	self._r, self._g, self._b = r or 0, g or 100, b or 255
	self.hscale = 0
end
function AbCircle:frame()
	self.hscale = self.size * cos(self.timer * 1.5)
	self._a = 255 * cos(self.timer * 1.5)
	if self.timer > 60 then
		Del(self)
	end
end
function AbCircle:render()
	SetImageState(self.img, "mul+add", Color(self._a, self._r, self._g, self._b))
	Render(self.img, self.x, self.y, 0, self.hscale)
end

--蓄力的零散小部件
AbItem = Class(object)
function AbItem:init(x0, y0, x1, y1, size, img, r, g, b)
	self.bound = false
	self.img = img or 'bamboo_leaf_white'
	self.x, self.y = x0, y0
	self._dx, self._dy = (x1 - x0) / 60, (y1 - y0) / 60
	self.hscale, self.vscale, self.rot, self.bound = 0, 0, ran:Float(0, 360), false
	self._a = 255
	self.size = size or 1
	self._r, self._g, self._b = r or 0, g or 100, b or 255
	self.t = ran:Int(0, 360)
end
function AbItem:frame()
	self.x, self.y = self.x + self._dx, self.y + self._dy
	self.hscale, self.vscale = self.size * sin(self.t + self.timer * 1.5), self.size * sin(self.t + self.timer * 4.5)
	self._a = 255 * cos(self.timer * 1.5)
	if self.timer > 60 then
		Del(self)
	end
end
function AbItem:render()
	SetImageState(self.img, "mul+add", Color(self._a, self._r, self._g, self._b))
	Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

--region 符卡击破效果

--炸裂的蓄力圈
BkCircle = Class(object)
function BkCircle:init(x, y, size, r, g, b)
	self.bound = false
	self.x, self.y = x, y
	self.img = 'circle_eff'
	self.group = GROUP_GHOST
	self.size = size or 1
	self._a = 0
	self._r, self._g, self._b = r or 0, g or 100, b or 255
	self.hscale = 0
end
function BkCircle:frame()
	self.hscale = self.size * sin(self.timer * 2)
	self._a = 255 * cos(self.timer * 2)
	if self.timer > 45 then
		Del(self)
	end
end
function BkCircle:render()
	SetImageState(self.img, "mul+add", Color(self._a, self._r, self._g, self._b))
	Render(self.img, self.x, self.y, 0, self.hscale)
end

--炸裂的零散小部件
BkItem = Class(object)
function BkItem:init(x, y, r, a, size, R, G, B, img1, img2, blend)
	self.imgs = { img1 or self.img, img2 or self.img }
	self.img = self.imgs[ran:Int(1, 2)]
	self.x, self.y = x, y
	self.hscale, self.vscale, self.rot = 0, 0, ran:Float(0, 360)
	self._dx, self._dy = r * cos(a) / 60, r * sin(a) / 60
	self.hscale, self.vscale, self.rot, self.bound = 0, 0, ran:Float(0, 360), false
	self._a = 255
	self.size = size or 1
	self._blend, self._r, self._g, self._b = blend or "mul+add", R or 0, G or 100, B or 255
	self.t = ran:Int(0, 360)
end
function BkItem:frame()
	self.x, self.y = self.x + self._dx, self.y + self._dy
	self.hscale, self.vscale = self.size * sin(self.t + self.timer * 1.5), self.size * sin(self.t + self.timer * 4.5)
	self._a = 255 * cos(self.timer * 1.5)
	if self.timer > 60 then
		Del(self)
	end
end
function BkItem:render()
	SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
	Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

--boss符卡击破效果
function Spell_break_eff(x, y, r, g, b, img1, img2, rate, blend)
	rate = rate or 1
	blend = blend or "mul+add"
	PlaySound('enep02', 0.5)
	New(BkCircle, x, y, 3, 255 * rate, 255 * rate, 255 * rate)
	New(BkCircle, x, y, 3.1, r, g, b)
	for _ = 1, 30 do
		New(BkItem, x, y, ran:Float(50, 450), ran:Float(0, 360), ran:Float(1, 1.25), r, g, b, img1, img2, blend)
	end
	for _ = 1, 90 do
		New(BkItem, x, y, ran:Float(50, 450), ran:Float(0, 360), ran:Float(0.2, 0.3), r, g, b, img1, img2, blend)
	end
end

--endregion

--region 配合开卡立绘的彩色环

--开卡时闪出的道具
local spell_open_1 = Class(object)
function spell_open_1:init(x, y, R, G, B, a0, img1, img2)
	self.x, self.y = x, y
	self.imgs = { img1 or self.img, img2 or self.img }
	self.img = self.imgs[ran:Int(1, 2)]
	SetV(self, ran:Float(2.5, 5), a0)
	self.rot, self.omiga = ran:Float(0, 360), ran:Float(0.8, 1.2)
	self.size = ran:Float(1, 2)
	self.t = ran:Int(60, 120)
	self.layer = LAYER_TOP + 2
	self._r, self._g, self._b = R, G, B
	self._a = 0
	self.t2 = 1
end
function spell_open_1:frame()
	if self.timer > self.t then
		Del(self)
	end
	local t1 = self.timer / self.t
	self.hscale, self.vscale = self.size * t1 * self.t2, self.size * t1 * self.t2
	self.t2 = max(-1, self.t2 - 0.05)
	self._a = 100 * sin(180 * t1)
end
function spell_open_1:render()
	SetImageState(self.img, "mul+add", Color(self._a, self._r, self._g, self._b))
	Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

--彩色星空素材
local spell_open_2 = Class(object)
function spell_open_2:init(x, y, R, G, B)
	self.x, self.y = x, y
	self.img = "starlight"
	self.hscale, self.vscale = 0, 0
	self.rot = 0
	self.omiga = 10
	self._r, self._g, self._b = R, G, B
	self._a = 0
	self.layer = LAYER_TOP + 2
end
function spell_open_2:frame()
	if self.timer > 60 then
		Del(self)
	end
	local t1 = 1.5 * self.timer
	self.hscale, self.vscale = 6 * sin(t1), 6 * sin(t1)
	self._a = 255 * sin(2 * t1)
end
function spell_open_2:render()
	SetImageState(self.img, "mul+add", Color(self._a, self._r, self._g, self._b))
	Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

--波环素材
local spell_open_3 = Class(object)
function spell_open_3:init(x, y, R, G, B)
	self.x, self.y = x, y
	self.img = "circle_eff1"
	self.hscale, self.vscale = 0, 0
	self.rot = 0
	self.omiga = 10
	self._r, self._g, self._b = R, G, B
	self._a = 0
	self.layer = LAYER_TOP + 2
end
function spell_open_3:frame()
	if self.timer > 60 then
		Del(self)
	end
	local t1 = 1.5 * self.timer
	self.hscale, self.vscale = 6 * sin(t1), 6 * sin(t1)
	self._a = 255 * sin(2 * t1)
end
function spell_open_3:render()
	SetImageState(self.img, "mul+add", Color(self._a, self._r, self._g, self._b))
	Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

--圆环素材
local spell_open_4 = Class(object)
function spell_open_4:init(x, y, R, G, B)
	self.x, self.y = x, y
	self.img = "circle_eff2"
	self.hscale, self.vscale = 0, 0
	self.rot = 0
	self.omiga = 10
	self._r, self._g, self._b = R, G, B
	self._a = 0
	self.layer = LAYER_TOP + 2
end
function spell_open_4:frame()
	if self.timer > 45 then
		Del(self)
	end
	local t1 = 2 * self.timer
	self.hscale, self.vscale = 15 * sin(t1), 15 * sin(t1)
	self._a = 255 * sin(2 * t1)
end
function spell_open_4:render()
	SetImageState(self.img, "mul+add", Color(self._a, self._r, self._g, self._b))
	Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

--配合开卡立绘的彩色环
spell_open_circle_eff = Class(object)
function spell_open_circle_eff:init(x, y, R, G, B, img1, img2)
	self.x, self.y = x, y
	task.New(self, function()
		local a = 0
		for _ = 1, 10 do
			for _ = 1, 6 do
				New(spell_open_1, self.x, self.y, R, G, B, a + ran:Float(-18, 18), img1, img2)
			end
			a = a + 36
		end
		for _ = 1, 2 do
			New(spell_open_2, self.x, self.y, R, G, B)
			New(spell_open_3, self.x, self.y, R, G, B)
			New(spell_open_4, self.x, self.y, R, G, B)
			task.Wait(10)
		end
		Del(self)
	end)
end
function spell_open_circle_eff:frame()
	task.Do(self)
end

--endregion

--region LSC演出特效

--暂时通用的LSC演出特效
local LSC_eff_1 = Class(object)
function LSC_eff_1:init(x, y, R, G, B, img1, img2, a0, da)
	self.x, self.y = x, y
	self.layer = LAYER_TOP + 2
	self.group = GROUP_GHOST
	self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
	self.imgs = { img1, img2 }
	self.img = self.imgs[ran:Int(1, 2)]
	self.rot = ran:Float(0, 360)
	self.hscale = 1.5
	self.vscale = 1.5
	self.bound = false
	local _x, _y, a, r = self.x + ran:Float(-40, 40), self.y + ran:Float(-40, 40), a0, ran:Float(350, 400)
	self.x, self.y = _x + r * cos(a0), _y + r * sin(a0)
	task.New(self, function()
		local _rot = ran:Float(0, 360)
		do
			local x, _d_x = (0), (90 / 89)
			for _ = 1, 90 do
				a = a + da
				_rot = _rot + 3
				self.x = _x + r * cos(a) * cos(x)
				self.y = _y + r * sin(a) * cos(x)
				_object.set_color(self, "mul+add", 100 + 205 * cos(x), R, G, B)
				self.hscale = (1 + 0.5 * cos(x)) * sin(_rot)
				self.vscale = 1 + 0.5 * cos(x)
				task.Wait(1)
				x = x + _d_x
			end
		end
		do
			local x, _d_x = (0), (90 / 9)
			for _ = 1, 10 do
				_object.set_color(self, "mul+add", 100 * cos(x), R, G, B)
				self.hscale = (1 + 0.5 * cos(x)) * sin(_rot)
				self.vscale = 1 + 0.5 * cos(x)
				task._Wait(1)
				x = x + _d_x
			end
		end
		Del(self)
	end)
end
function LSC_eff_1:frame()
	task.Do(self)
end
function LSC_eff_1:render()
	SetImgState(self, self._blend, self._a, self._r, self._g, self._b)
	Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

local LSC_eff_2 = Class(object)
function LSC_eff_2:init(x, y, R, G, B)
	self.x, self.y = x, y
	self.img = "circle_eff"
	self.layer = LAYER_TOP + 2
	self.group = GROUP_GHOST
	self._blend = "mul+add"
	self._a = 100
	self._r = R
	self._g = G
	self._b = B
	task.New(self, function()
		do
			local x, _d_x = (0), (180 / 89)
			for _ = 1, 90 do
				self._a = 255 * sin(x)
				self.hscale = 0.5 + 4 * cos(0.5 * x)
				self.vscale = 0.5 + 4 * cos(0.5 * x)
				task._Wait(1)
				x = x + _d_x
			end
		end
	end)
end
function LSC_eff_2:frame()
	task.Do(self)
end
function LSC_eff_2:render()
	SetImgState(self, self._blend, self._a, self._r, self._g, self._b)
	Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

--在boss开lsc时调用这个函数就行了
function LSC_eff(x, y, R, G, B, img1, img2)
	New(tasker, function()
		for _ = 1, 5 do
			PlaySound("ch00")
			New(LSC_eff_2, x, y, R, G, B)
			task.Wait(20)
		end
	end)
	New(tasker, function()
		for _ = 1, 20 do
			local a, da = 30, 75
			local da0, dda0 = 0.55, 0
			for _ = 1, 2 do
				for u = -1, 1, 2 do
					New(LSC_eff_1, x, y, R, G, B, img1, img2, 90 + u * a, da0 * u)
				end
				a = a + da
				da0 = da0 + dda0
			end
			task.Wait(3)
		end
	end)
end

--endregion
