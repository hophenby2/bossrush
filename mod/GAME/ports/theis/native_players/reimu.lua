-- 原作自机，仅隔离资源名称以免与其他作品冲突。
---=====================================
--- reimu, yukari
--- author: 51, Xiliusha, S7P
---=====================================

local path = "res/player/reimu/"

local player_scale = 2

local sin, cos = lstg.sin, lstg.cos
local min, max = math.min, math.max
local abs = math.abs

local function setRenderState(obj, blend, color)
	obj._blend = blend
	obj._color = color
end

local function renderSprite(obj)
	SetImageState(obj.img, obj._blend, obj._color)
	DefaultRenderFunc(obj)
end

local function renderAnimation(obj)
	SetAnimationState(obj.img, obj._blend, obj._color)
	DefaultRenderFunc(obj)
end

local maxRange = 900 --最大判断范围（不包含）

local function findtarget_slow(self)
	local target, r
	local minr, minr2 = maxRange, maxRange
	local x, y = self.x, self.y
	local flag
	local function it(group)
		for _, o in ObjList(group) do
			if (o.class.base == boss or o.Isbacklight) and o.colli then  --如果有boss或者光背就直优先锁光背
				target = o
				break
			else
				r = Dist(x, y, o.x, o.y)
				if o._type then
					flag = true--大怪类型
				end
				if flag and o._type and r < minr2 and o.colli == true then
					minr2 = r
					target = o
				elseif not (flag) and r < minr and o.colli == true then
					minr = r
					target = o
				end
			end
		end
	end
	it(GROUP_NONTJT)
	it(GROUP_ENEMY)
	self.target_slow = target
end

--现在高速也去找大怪麻烦了（
local function findtarget_high(self)
	local target, target2, r
	local minr, minr2 = maxRange, maxRange
	local x, y = self.x, self.y
	local flag
	local function it(group)
		for _, o in ObjList(group) do
			if o.colli then
				r = Dist(x, y, o.x, o.y)
				if o._type and o.y >= player.y - 30  then  --不诱导比自己低的
					flag = true
				end
				if flag  and r < minr then
					minr = r
					target = o --找大怪
				elseif not flag and r < minr2 then
					minr2 = r
					target2 = o --找小怪
				end
			end
		end
	end
	it(GROUP_NONTJT)
	it(GROUP_ENEMY)
	self.target_high = target or target2  --先找大怪，没大怪再找小怪
end

local function CreateYukariLaser(x, y, a, w, t, c, offset)
	local width = w / 2
	local n = int(offset / 600)
	local length = t % 50
	local endl = int(offset - n * 600)
	RenderTexture('native_theis_yukari_shoot3', 'mul+add',
			{ x + (length + 600 * n) * cos(a) - width * sin(a), y + (length + 600 * n) * sin(a) + width * cos(a), 0.5, 0, 0, c },
			{ x + (600 * n + endl) * cos(a) - width * sin(a), y + (600 * n + endl) * sin(a) + width * cos(a), 0.5, endl - length, 0, c },
			{ x + (600 * n + endl) * cos(a) + width * sin(a), y + (600 * n + endl) * sin(a) - width * cos(a), 0.5, endl - length, 28, c },
			{ x + (length + 600 * n) * cos(a) + width * sin(a), y + (length + 600 * n) * sin(a) - width * cos(a), 0.5, 0, 28, c }
	)
	RenderTexture('native_theis_yukari_shoot3', 'mul+add',
			{ x + 600 * n * cos(a) - width * sin(a), y + 600 * n * sin(a) + width * cos(a), 0.5, 600 - length, 0, c },
			{ x + (length + 600 * n) * cos(a) - width * sin(a), y + (length + 600 * n) * sin(a) + width * cos(a), 0.5, 600, 0, c },
			{ x + (length + 600 * n) * cos(a) + width * sin(a), y + (length + 600 * n) * sin(a) - width * cos(a), 0.5, 600, 28, c },
			{ x + 600 * n * cos(a) + width * sin(a), y + 600 * n * sin(a) - width * cos(a), 0.5, 600 - length, 28, c }
	)
end

local function load_res()
	LoadImageFromFile('native_theis_reimu_shoot1', path .. 'reimu_shoot1.png')
	SetImageCenter('native_theis_reimu_shoot1', 200, 50)
	SetImageState('native_theis_reimu_shoot1', '', Color(0xA0FFFFFF))
	LoadImageFromFile('native_theis_reimu_shoot1_ef', path .. 'reimu_shoot1.png')
	SetImageCenter('native_theis_reimu_shoot1_ef', 200, 50)
	LoadImageFromFile('native_theis_reimu_shoot2', path .. 'reimu_shoot2.png')
	LoadImageFromFile('native_theis_reimu_shoot2_ef', path .. 'reimu_shoot2.png')
	LoadImageFromFile('native_theis_reimu_shoot3', path .. 'reimu_shoot3.png')
	LoadImageFromFile('native_theis_reimu_shoot3_ef', path .. 'reimu_shoot3.png')
	LoadImageFromFile('native_theis_reimu_shoot4', path .. 'reimu_shoot4.png')
	SetImageCenter('native_theis_reimu_shoot4', 200, 50)
	SetImageState('native_theis_reimu_shoot4', '', Color(0xA0FFFFFF))
	LoadImageFromFile('native_theis_reimu_shoot4_ef', path .. 'reimu_shoot4.png')
	SetImageCenter('native_theis_reimu_shoot4_ef', 200, 50)
	LoadTexture('native_theis_reimu_main', path .. 'reimu_main.png')
	LoadImage('native_theis_reimu_main', 'native_theis_reimu_main', 96, 0, 96, 76, 30, 16)
	LoadAnimation('native_theis_reimu_main_ef', 'native_theis_reimu_main', 96, 0, 96, 76, 1, 5, 2)
	SetImageCenter('native_theis_reimu_main', 46, 38)
	SetImageState('native_theis_reimu_main', '', Color(0xC0FFFFFF))
	SetAnimationCenter('native_theis_reimu_main_ef', 46, 38)
	SetAnimationState('native_theis_reimu_main_ef', 'mul+add', Color(0xC0FFFFFF))
	LoadTexture('native_theis_reimu_trail', path .. 'reimu_trail.png')
	LoadImage('native_theis_reimu_trail', 'native_theis_reimu_trail', 0, 0, 46, 46, 10, 6)
	LoadAnimation('native_theis_reimu_trail_ef', 'native_theis_reimu_trail', 0, 0, 46, 46, 1, 5, 2)
	SetImageState('native_theis_reimu_trail', '', Color(0xC0FFFFFF))
	SetAnimationState('native_theis_reimu_trail_ef', 'mul+add', Color(0xC0FFFFFF))
	LoadTexture('native_theis_reimu_support', path .. 'reimu_support.png')
	LoadImageGroup('native_theis_reimu_support', 'native_theis_reimu_support', 0, 0, 72, 72, 3, 1)
	LoadImage('native_theis_reimu_support', 'native_theis_reimu_support', 0, 0, 40, 40)
	LoadTexture('native_theis_reimu_support_ef', path .. 'reimu_support_ef.png')
	LoadImageGroup('native_theis_reimu_support_ef', 'native_theis_reimu_support_ef', 0, 0, 29, 36, 7, 1)
	for i = 1, 7 do
		SetImageCenter('native_theis_reimu_support_ef' .. i, 4, 1)
	end
	LoadTexture('native_theis_yukari_main', path .. 'yukari_main.png')
	LoadImage('native_theis_yukari_main', 'native_theis_yukari_main', 0, 0, 96, 40, 30, 16)
	LoadAnimation('native_theis_yukari_main_ef', 'native_theis_yukari_main', 0, 0, 96, 40, 1, 5, 2)
	SetImageState('native_theis_yukari_main', '', Color(0xC0FFFFFF))
	SetAnimationState('native_theis_yukari_main_ef', '', Color(0xC0FFFFFF))
	LoadImageFromFile('native_theis_yukari_shoot1', path .. 'yukari_shoot1.png')
	SetImageCenter('native_theis_yukari_shoot1', 200, 50)
	SetImageState('native_theis_yukari_shoot1', '', Color(0xA0FFFFFF))
	LoadImageFromFile('native_theis_yukari_shoot1_ef', path .. 'yukari_shoot1.png')
	SetImageCenter('native_theis_yukari_shoot1_ef', 200, 50)
	LoadImageFromFile('native_theis_yukari_shoot2', path .. 'yukari_shoot2.png')
	LoadImageFromFile('native_theis_yukari_shoot2_ef', path .. 'yukari_shoot2.png')
	LoadTexture('native_theis_yukari_shoot3', path .. 'yukari_shoot3.png')
	LoadTexture('native_theis_yukari_support1', path .. 'yukari_support1.png')
	LoadImageGroup('native_theis_yukari_support1', 'native_theis_yukari_support1', 0, 0, 78, 78, 6, 1)
	LoadImageFromFile('native_theis_yukari_support2', path .. 'yukari_support2.png')
	SetImageState('native_theis_yukari_support2', 'mul+add', Color(180, 255, 255, 255))
	LoadTexture('native_theis_yukari_support3', path .. 'yukari_support3.png')
	LoadImageGroup('native_theis_yukari_support3', 'native_theis_yukari_support3', 0, 0, 64, 64, 2, 1)
	for i = 1, 2 do
		SetImageCenter('native_theis_yukari_support3' .. i, 32, 38)
	end
	LoadTexture('native_theis_reimu_hit', path .. 'hit.png')
	LoadAnimation('native_theis_reimu_hit_white', 'native_theis_reimu_hit', 0, 0, 64, 64, 1, 4, 4)
	LoadAnimation('native_theis_reimu_hit_red', 'native_theis_reimu_hit', 0, 0, 64, 64, 1, 4, 4)
	SetAnimationState('native_theis_reimu_hit_red', 'mul+add', Color(0xFFFFFFFF))
	LoadAnimation('native_theis_reimu_hit_purple', 'native_theis_reimu_hit', 0, 0, 64, 64, 1, 4, 4)
	SetAnimationState('native_theis_reimu_hit_purple', 'mul+add', Color(255, 160, 32, 240))
	LoadImageFromFile('native_theis_reimu_bomb1', path .. 'reimu_bomb1.png')
	LoadImageFromFile('native_theis_reimu_bomb2', path .. 'reimu_bomb2.png')
	LoadImageFromFile("native_theis_yukari_bomb1", path .. "yukari_bomb1.png")
	LoadImageFromFile("native_theis_yukari_bomb2", path .. "yukari_bomb2.png")
	LoadImageFromFile("native_theis_yukari_bomb4", path .. "yukari_bomb4.png")
	LoadImageFromFile("native_theis_yukari_bomb5", path .. "yukari_bomb5.png")
	LoadTexture('native_theis_reimu_player', path .. 'reimu_player.png')
	LoadImageGroup('native_theis_reimu_player', 'native_theis_reimu_player', 0, 0, 140, 120, 8, 3, 0.5, 0.5)
	LoadTexture('native_theis_yukari_player', path .. 'yukari_player.png')
	LoadImageGroup('native_theis_yukari_player', 'native_theis_yukari_player', 0, 0, 138, 138, 8, 3, 0.5, 0.5)
	for i = 1, 24 do
		--SetImageCenter('native_theis_yukari_player' .. i, 71, 86)
	end
end

----------------------------------------
--region bullet reimu

local reimu_bullet_ef = Class(object)
function reimu_bullet_ef:init(img, x, y, rot, s)
	self.x = x
	self.y = y
	self.img = img
	self.layer = LAYER_PLAYER_BULLET + 50
	self.hscale = s
	self.vscale = s
	lstg.SetV(self, 0.5, rot, true)
end
function reimu_bullet_ef:frame()
	if self.timer == 9 then
		self.hscale = self.hscale + 0.01
		self.vscale = self.hscale
		self.status = "del"
	end
end
function reimu_bullet_ef:render()
	lstg.SetAnimationState(self.img, "mul+add", Color(255 - 180 * self.timer / 9, 255, 255, 255))
	lstg.DefaultRenderFunc(self)
end

local reimu_bullet = Class(object)
function reimu_bullet:init(img, x, y, v, rot, dmg, s)
	self.group = GROUP_PLAYER_BULLET
	self.layer = LAYER_PLAYER_BULLET
	self.x = x
	self.y = y
	self.img = img
	self.rot = rot
	self.vx = v * cos(rot)
	self.vy = v * sin(rot)
	if IsValid(_boss) then
		self.dmg = 0.5*dmg
	else
		self.dmg = dmg
	end
	self.hscale = s * player_scale
	self.vscale = s * player_scale
	self.a = 24
	self.b = 12
	self.rect = true
end
function reimu_bullet:kill()
	lstg.New(reimu_bullet_ef, self.img .. "_ef",
			self.x, self.y, self.rot, self.hscale)
end
function reimu_bullet:del()
	lstg.New(reimu_bullet_ef, self.img .. "_ef",
			self.x, self.y, self.rot, self.hscale)
end

local yukari_bullet = Class(object)
function yukari_bullet:init(img, x, y, v, rot, dmg, s)
	self.group = GROUP_PLAYER_BULLET
	self.layer = LAYER_PLAYER_BULLET
	self.x = x
	self.y = y
	self.img = img
	self.rot = rot
	self.vx = v * cos(rot)
	self.vy = v * sin(rot)
	self.dmg = dmg
	self.hscale = s * player_scale
	self.vscale = s * player_scale
	self.a = 24
	self.b = 12
	self.rect = true
end
function yukari_bullet:kill()
	lstg.New(reimu_bullet_ef, self.img .. "_ef",
			self.x, self.y, self.rot, self.hscale)
end
function yukari_bullet:del()
	lstg.New(reimu_bullet_ef, self.img .. "_ef",
			self.x, self.y, self.rot, self.hscale)
end

local reimu_trail = Class(object)
function reimu_trail:init(img, x, y, v, angle, target, dmg)
	self.group = GROUP_PLAYER_BULLET
	self.layer = LAYER_PLAYER_BULLET
	self.img = img
	self.x = x
	self.y = y
	self.rot = angle
	self.v = v
	self.target_high = target
	self.dmg = dmg
	self.a = 16
	self.b = 10
	self.rect = true
	self.hscale = 0.75 * player_scale
	self.vscale = self.hscale
end
function reimu_trail:frame()
	--self.target_high = nil
	--findtarget_high(self)
	if lstg.IsValid(self.target_high) and self.target_high.colli then
		local a = math.mod(lstg.Angle(self, self.target_high) - self.rot + 720, 360)
		if a > 180 then
			a = a - 360
		end
		local da = 720 / (lstg.Dist(self, self.target_high) + 1)
		if da >= abs(a) then
			self.rot = lstg.Angle(self, self.target_high)
		else
			self.rot = self.rot + sign(a) * da
		end
	end
	self.vx = self.v * cos(self.rot)
	self.vy = self.v * sin(self.rot)
end
function reimu_trail:kill()
	lstg.New(reimu_bullet_ef, self.img .. "_ef",
			self.x, self.y, self.rot, self.hscale)
end
function reimu_trail:del()
	lstg.New(reimu_bullet_ef, self.img .. "_ef",
			self.x, self.y, self.rot, self.hscale)
end

--endregion
----------------------------------------
--region bullet yukari

--[[
local yukari_bullet_dmg = Class(object) -- 给紫妈的激光模拟伤害
function yukari_bullet_dmg:init(x, y, a, b, dmg)
	self.x, self.y = x, y
	self.a, self.b = a, b
	self.dmg = dmg
	self.group = GROUP_PLAYER_BULLET
	self.hide = true
	self.bound = false
end
function yukari_bullet_dmg:frame()
	if self.timer >= 1 then
		self.status = "del"
	end
end

local yukari_laser_dmg = Class(object)
function yukari_laser_dmg:init(x, y, rot, dmg, b)
	self.x = x
	self.y = y
	self.group = GROUP_PLAYER_BULLET
	self.dmg = dmg
	self.hide = true
	self.a = 30
	self.b = b
	self.rot = rot
	self.rect = true
	self.bound = false
	self.killflag = 1
end
function yukari_laser_dmg:frame()
	if self.timer == 1 then
		Del(self)
	end
end
--]]

--endregion
----------------------------------------

----------------------------------------
--region bomb reimu

local reimu_bomb_a1 = Class(object)
function reimu_bomb_a1:init(_x, _y, R, G, B, master)
	self.x, self.y = _x, _y
	self.img = "native_theis_reimu_bomb1"
	self.layer = LAYER_PLAYER_BULLET + 1
	self.bound = false
	self.master = master
	self.R, self.G, self.B = R, G, B
	task.New(self, function()
		do
			local vh, _d_vh = (0.5), (0.3 / 29)
			--local alp, _d_alp = (100), (-100 / 59)
			for _ = 1, 30 do
				self.vscale = vh
				self.hscale = vh
				task.Wait(1)
				vh = vh + _d_vh
				--alp = alp + _d_alp
			end
		end
		Del(self)
	end)
end
function reimu_bomb_a1:frame()
	if IsValid(self.master) then
		self.x = self.master.x
		self.y = self.master.y
	else
		Del(self)
	end
	task.Do(self)
end
function reimu_bomb_a1:render()
	SetImageState(self.img, "mul+add", Color(100 - self.timer * 100 / 59, self.R, self.G, self.B))
	DefaultRenderFunc(self)
end

local reimu_bomb_a2 = Class(object)
function reimu_bomb_a2:init(_x, _y, master)
	self.x, self.y = _x, _y
	self.img = "native_theis_reimu_bomb1"
	self.layer = LAYER_PLAYER_BULLET + 1
	self.bound = false
	self.master = master
	task.New(self, function()
		do
			local vh, _d_vh = (0.2), (-0.2 / 45)
			--local alp, _d_alp = (255), (-255 / 45)
			for _ = 1, 45 do
				self.vscale = vh
				self.hscale = vh
				task.Wait(1)
				vh = vh + _d_vh
				--alp = alp + _d_alp
			end
		end
		Del(self)
	end)
end
function reimu_bomb_a2:frame()
	if IsValid(self.master) then
		self.x = self.master.x
		self.y = self.master.y
	else
		Del(self)
	end
	task.Do(self)
end
function reimu_bomb_a2:render()
	SetImageState(self.img, "mul+add", Color(255 - self.timer * 255 / 45, 255, 255, 255))
	DefaultRenderFunc(self)
end

local reimu_bomb_b = Class(object)
function reimu_bomb_b:init(_x, _y, R, G, B, master)
	self.x, self.y = _x, _y
	self.img = "native_theis_reimu_bomb2"
	self.layer = LAYER_PLAYER_BULLET - 1
	self.bound = false
	self.rot = ran:Float(0, 360)
	self.omiga = -50
	self.R, self.G, self.B = R, G, B
	self.master = master
	task.New(self, function()
		do
			local vh, _d_vh = (0.4), (0.1 / 45)
			--local alp, _d_alp = (200), (-200 / 45)
			for _ = 1, 45 do
				self.vscale = vh
				self.hscale = vh
				task.Wait(1)
				vh = vh + _d_vh
				--alp = alp + _d_alp
			end
		end
		Del(self)
	end)
end
function reimu_bomb_b:frame()
	if IsValid(self.master) then
		self.x = self.master.x
		self.y = self.master.y
	else
		Del(self)
	end
	task.Do(self)
end
function reimu_bomb_b:render()
	SetImageState(self.img, "mul+add", Color(200 - self.timer * 200 / 45, self.R, self.G, self.B))
	DefaultRenderFunc(self)
end

local reimu_bomb_c = Class(object) -- 飞散的粒子
function reimu_bomb_c:init(_x, _y, v1, a1, vh1, R, G, B)
	self.x, self.y = _x, _y
	self.img = "native_theis_reimu_bomb2"
	self.layer = LAYER_PLAYER_BULLET + 1
	self.bound = false
	self.vscale = vh1
	self.hscale = vh1
	self.omiga = -50
	SetV2(self, v1, a1, false, false)
	self.R, self.G, self.B = R, G, B
	task.New(self, function()
		do
			local v0, _d_v0 = (v1), (-v1 / 90)
			for _ = 1, 90 do
				SetV2(self, v0, a1, false, false)
				task.Wait(1)
				v0 = v0 + _d_v0
			end
		end
		do
			local vh, _d_vh = (vh1), (-vh1 / 20)
			for _ = 1, 20 do
				self.vscale = vh
				self.hscale = vh
				task.Wait(1)
				vh = vh + _d_vh
			end
		end
		Del(self)
	end)
end
function reimu_bomb_c:frame()
	local t = 0
	task.Do(self)
end
function reimu_bomb_c:render()
	SetImageState(self.img, "mul+add", Color(255, min(255, self.R + 50), min(255, self.G + 50), min(255, self.B + 50)))
	DefaultRenderFunc(self)
end

local reimu_bomb_d = Class(object)
function reimu_bomb_d:init(_x, _y, R, G, B)
	self.group = GROUP_SPELL
	self.killflag = 1
	self.dmg = 1.25
	self.x = _x
	self.y = _y
	self.img = "native_theis_reimu_bomb1"
	self.layer = LAYER_PLAYER_BULLET + 1
	self.bound = false
	self.R, self.G, self.B = R, G, B
	task.New(self, function()
		for t = 1, 45 do
			self.hscale = 12 * sin(t * 2)
			self.vscale = self.hscale
			self.a = self.hscale * 30
			self.b = self.a
			task.Wait(1)
		end
		Del(self)
	end)
end
function reimu_bomb_d:frame()
	local t = 0
	task.Do(self)
end
function reimu_bomb_d:render()
	SetImageState(self.img, "mul+add", Color(255 - 255 * self.timer / 45, self.R, self.G, self.B))
	DefaultRenderFunc(self)
end
function reimu_bomb_d:colli(o)
	if o.group == GROUP_ENEMY_BULLET then
		Kill(o)
	elseif o.group == GROUP_NONTJT or o.group == GROUP_ENEMY then
		enemybase.damage(o, self.dmg)
	end
end

-- 下面这个依赖上面的类
local reimu_bomb_a = Class(object)
function reimu_bomb_a:init(_x, _y, R, G, B, rot, v, master)
	self.master = master
	self.x = _x
	self.y = _y
	self.img = "native_theis_reimu_bomb1"
	self.layer = LAYER_PLAYER_BULLET + 1
	self.group = GROUP_SPELL
	self.killflag = 1
	self.bound = false
	self.rot = rot
	self.v = v
	self.a = 40
	self.b = 40
	self.bound = false
	self.dmg = 1
	self.sys_co = 2
	self.R, self.G, self.B = R, G, B
	task.New(self, function()
		task.Wait(60)
		do
			local a0, _d_a0 = (ran:Float(0, 360)), (360 / 72)
			for _ = 1, _infinite do
				New(reimu_bomb_c, self.x, self.y, ran:Float(1, 15), ran:Float(0, 360), ran:Float(0.02, 0.07), R, G, B)
				task.Wait(2)
			end
		end
	end)
	task.New(self, function()
		do
			local x, _d_x = (0), (50)
			for _ = 1, _infinite do
				self.vscale = 0.5 + 0.02 * sin(x)
				self.hscale = 0.5 + 0.1 * sin(x)
				task.Wait(1)
				x = x + _d_x
			end
		end
	end)
	task.New(self, function()
		do
			for _ = 1, _infinite do
				New(reimu_bomb_a1, self.x, self.y, R, G, B, self)
				New(reimu_bomb_a2, self.x, self.y, self)
				task.Wait(20)
			end
		end
	end)
	task.New(self, function()
		do
			for _ = 1, _infinite do
				New(reimu_bomb_b, self.x, self.y, R, G, B, self)
				task.Wait(20)
			end
		end
	end)
end
function reimu_bomb_a:frame()
	task.Do(self)
	local t = self.timer
	if self.timer <= 45 then
		local r = 120 * sin(t * 2)
		self.x = r * cos(self.rot + t * 5.3) + self.master.x
		self.y = r * sin(self.rot + t * 5.3) + self.master.y
	elseif self.timer < 100 then
		self.x = 120 * cos(self.rot + t * 5.3) + self.master.x
		self.y = 120 * sin(self.rot + t * 5.3) + self.master.y
	elseif self.timer == 100 then
		self.vx = self.dx
		self.vy = self.dy
	elseif self.timer < 145 then
		self.vx = self.vx * 0.945
		self.vy = self.vy * 0.945
	elseif self.timer < 180 then
		self.vx = self.vx * 0.85
		self.vy = self.vx * 0.85
	elseif self.timer == 180 then
		Kill(self)
	end
	--[[if self.x>=192 then self.x=192 end
	if self.x<=-192 then self.x=-192 end
	if self.y>=224 then self.y=224 end
	if self.y<=-224 then self.y=-224 end]]
end
function reimu_bomb_a:render()
	SetImageState(self.img, "mul+add", Color(255, self.R, self.G, self.B))
	DefaultRenderFunc(self)
end
function reimu_bomb_a:kill()
	misc.ShakeScreen(30, 3)
	local a = ran:Float(0, 360)
	for i = 1, 72 do
		New(reimu_bomb_c, self.x, self.y, ran:Float(1, 15), a, ran:Float(0.02, 0.07), self.R, self.G, self.B)
		a = a + ran:Float(0, 360)
	end
	New(reimu_bomb_d, self.x, self.y, self.R, self.G, self.B)
	misc.ShakeScreen(60, 3)
end
function reimu_bomb_a:colli(o)
	if o.group == GROUP_ENEMY_BULLET then
		Kill(o)
	end
	if o.group == GROUP_NONTJT or o.group == GROUP_ENEMY then
		if o.class.base.take_damage then
			o.class.base.take_damage(o, self.dmg) --对目标造成伤害
		else
			o.hp = o.hp - self.dmg
		end
	end
end

--endregion
----------------------------------------
--region bomb yukari

local yukari_dmg = Class(object) -- 全屏刺杀
function yukari_dmg:init(x, y, a, b, t, dmg, sys_co)
	self.group = GROUP_PLAYER_BULLET
	self.killflag = 1
	self.x = x
	self.y = y
	self.a = a
	self.b = b
	self.t = t
	self.dmg = 1.2*dmg
	self.sys_co = sys_co or nil
end
function yukari_dmg:frame()
	if self.timer == self.t then
		Del(self)
	end
end

local yukari_bomb_common = Class(object) -- 渲染基类
function yukari_bomb_common:frame()
	local _ = 0
	task.Do(self)
end
function yukari_bomb_common:render()
	local _ = 0
	renderSprite(self)
end

local yukari_bomb_aA = Class(yukari_bomb_common) -- 链条 +50 最模糊的
function yukari_bomb_aA:init(_x, _y, a1, vh)
	self.x, self.y = _x, _y
	self.img = "native_theis_yukari_bomb2"
	self.layer = LAYER_ENEMY + 50
	self.group = GROUP_PLAYER_BULLET
	self.bound = false
	self.sf = 1
	self.vscale = vh * player_scale
	self.hscale = vh * player_scale
	self.killflag = 1
	--[[self.dmg=0.1
	self.a=1897*self.hscale
	self.b=73*self.vscale
	self.rect=true]]
	setRenderState(self, "", Color(255, 255, 255, 255))
	task.New(self, function()
		do
			local v0, _d_v0 = (20), (-20 / 89)
			for _ = 1, 90 do
				SetV2(self, v0, a1, true, false)
				task.Wait(1)
				v0 = v0 + _d_v0
			end
		end
		while true do
			if self.sf == 0 then
				break
			else
				task.Wait(1)
			end
		end
		do
			local v0, _d_v0 = (0), (20 / 89)
			for _ = 1, 90 do
				SetV2(self, v0, a1, true, false)
				task.Wait(1)
				v0 = v0 + _d_v0
			end
		end
	end)
	task.New(self, function()
		while true do
			if self.sf == 0 then
				break
			else
				task.Wait(1)
			end
		end
		for i = 255, 0, -255 / 40 do
			setRenderState(self, "", Color(i, 255, 255, 255))
			task.Wait(1)
		end
		Del(self)
	end)
end

local yukari_bomb_a = Class(yukari_bomb_common) -- 链条 -50 最低图层
function yukari_bomb_a:init(_x, _y, a1, vh)
	self.x, self.y = _x, _y
	self.img = "native_theis_yukari_bomb1"
	self.layer = LAYER_ENEMY - 50
	self.group = GROUP_PLAYER_BULLET
	self.bound = false
	self.sf = 1
	self.vscale = vh * player_scale
	self.hscale = vh * player_scale
	self.killflag = 1
	--[[self.dmg=0.1
	self.a=1897*self.hscale
	self.b=73*self.vscale
	self.rect=true]]
	setRenderState(self, "", Color(255, 255, 255, 255))
	task.New(self, function()
		do
			local v0, _d_v0 = (20), (-20 / 89)
			for _ = 1, 90 do
				SetV2(self, v0, a1, true, false)
				task.Wait(1)
				v0 = v0 + _d_v0
			end
		end
		while true do
			if self.sf == 0 then
				break
			else
				task.Wait(1)
			end
		end
		do
			local v0, _d_v0 = (0), (20 / 89)
			for _ = 1, 90 do
				SetV2(self, v0, a1, true, false)
				task.Wait(1)
				v0 = v0 + _d_v0
			end
		end
	end)
	task.New(self, function()
		while true do
			if self.sf == 0 then
				break
			else
				task.Wait(1)
			end
		end
		for i = 255, 0, -255 / 40 do
			setRenderState(self, "", Color(i, 255, 255, 255))
			task.Wait(1)
		end
		Del(self)
	end)
end

local yukari_bomb_b = Class(yukari_bomb_common) -- 链条 +1 中间图层，有点模糊
function yukari_bomb_b:init(_x, _y, a1, vh)
	self.x, self.y = _x, _y
	self.img = "native_theis_yukari_bomb5"
	self.layer = LAYER_ENEMY + 1
	self.group = GROUP_PLAYER_BULLET
	self.bound = false
	self.sf = 1
	self.vscale = vh * player_scale
	self.hscale = vh * player_scale
	self.killflag = 1
	--[[self.dmg=0.1
	self.a=1897*self.hscale
	self.b=73*self.vscale
	self.rect=true]]
	setRenderState(self, "", Color(255, 255, 255, 255))
	task.New(self, function()
		do
			local v0, _d_v0 = (20), (-20 / 89)
			for _ = 1, 90 do
				SetV2(self, v0, a1, true, false)
				task.Wait(1)
				v0 = v0 + _d_v0
			end
			while true do
				if self.sf == 0 then
					break
				else
					task.Wait(1)
				end
			end
			do
				local v0, _d_v0 = (0), (20 / 89)
				for _ = 1, 90 do
					SetV2(self, v0, a1, true, false)
					task.Wait(1)
					v0 = v0 + _d_v0
				end
			end
		end
		do
			while true do
				if self.sf == 0 then
					break
				else
					task.Wait(1)
				end
			end
			for i = 255, 0, -255 / 40 do
				setRenderState(self, "", Color(i, 255, 255, 255))
				task.Wait(1)
			end
			Del(self)
		end
	end)
end

local yukari_bomb_aEND = Class(yukari_bomb_common) -- 隙间1 （不使用）
function yukari_bomb_aEND:init(_x, _y, a1, vh)
	self.x, self.y = _x, _y
	self.img = "native_theis_yukari_bomb1"
	self.layer = LAYER_ENEMY + 3
	self.group = GROUP_PLAYER_BULLET
	self.bound = false
	self.vscale = vh * player_scale
	self.hscale = vh * player_scale
	self.killflag = 1
	--[[self.dmg=0.175
	self.a=266*self.hscale
	self.b=719*self.vscale]]
	SetV2(self, 50, a1, true, false)
	setRenderState(self, "", Color(255, 255, 255, 255))
	task.New(self, function()
		task.Wait(360)
		Del(self)
	end)
	task.New(self, function()
		while true do
			if self.sf == 0 then
				break
			else
				task.Wait(1)
			end
		end
		for i = 255, 0, -255 / 40 do
			setRenderState(self, "", Color(i, 255, 255, 255))
			task.Wait(1)
		end
		Del(self)
	end)
end

local yukari_bomb_cEND = Class(yukari_bomb_common) -- 隙间2
function yukari_bomb_cEND:init(_x, _y, a1, vh)
	self.x, self.y = _x, _y
	self.img = "native_theis_yukari_bomb4"
	self.layer = LAYER_ENEMY - 51
	self.group = GROUP_PLAYER_BULLET
	self.bound = false
	self.vscale = vh * player_scale
	self.hscale = vh / 2 * player_scale
	self.killflag = 1
	--[[self.dmg=0.175
	self.a=266*self.hscale
	self.b=719*self.vscale]]
	setRenderState(self, "", Color(255, 200, 200, 200))
	SetV2(self, ran:Float(60, 90), a1, false, false)
	task.New(self, function()
		task.Wait(120)
		Del(self)
	end)
end

--endregion
----------------------------------------

----------------------------------------
--region player

local function fire_init(self)
	self.reimu_max_next_shoot = int(6/self.attack_speed) --主炮攻击间隔(会受攻速影响）
	self.reimu_next_shoot = self.reimu_max_next_shoot --主炮攻击计时器
	self.reimu_max_next_trail = int(6/self.attack_speed) --主炮攻击间隔(会受攻速影响）
	self.reimu_next_trail = self.reimu_max_next_trail --主炮攻击计时器
	self.yukari_max_next_shoot = int(6/self.attack_speed)
	self.yukari_next_shoot = self.yukari_max_next_shoot
end
local function fire_shot(self)
	if self.lock_player_shoot <= 0 then
		if self.slow == 0 then
			if self.reimu_next_shoot == 0 then --灵梦主炮攻击
				New(reimu_bullet, "native_theis_reimu_main", self.x + 8, self.y, 10, 90, 5, 0.6)
				New(reimu_bullet, "native_theis_reimu_main", self.x - 8, self.y, 10, 90, 5, 0.6)
				self.reimu_next_shoot = self.reimu_next_shoot + self.reimu_max_next_shoot
			end
			if self.reimu_next_trail == 0 then --灵梦诱导攻击
				for i = 1, 4 do
					New(reimu_trail, "native_theis_reimu_trail", self.supportx + self.sp[i][1], self.supporty + self.sp[i][2], 10, self.anglelist[i], self.target_high, 1.5)
				end
				self.reimu_next_trail = self.reimu_next_trail + self.reimu_max_next_trail
			end
		else
			if self.yukari_next_shoot == 0 then --紫主炮攻击
				for i = -5, 5, 2 do
					New(yukari_bullet, "native_theis_yukari_main", self.x + 4*i, self.y + 12 - 3*abs(i), 12, 90, 1.2, 0.6)
				end
				self.yukari_next_shoot = self.yukari_next_shoot + self.yukari_max_next_shoot
			end
			--紫诱导攻击
			local aa = { 0, 0, 0, 0 }
			local ar = 10 * sin(self.timer * 2)
			if IsValid(self.target_slow) then
				local a = Angle(self, self.target_slow)
				aa = { a + 60 + ar, a + 120 - ar, a - 60 - ar, a - 120 + ar }
			else
				local a = 90
				aa = { a + 60 + ar, a + 120 - ar, a - 60 - ar, a - 120 + ar }
			end
			if self.laser_flag == 0 then
				local target = self.target_slow
				if IsValid(target) then
					if target._type then
						--大怪
						if Dist(player, target) < target.dye_range then
							enemybase.damage(target, self.laser_rate*1) -- 贴脸造成原伤害
						else
							enemybase.damage(target, self.laser_rate*min(1, target.maxhp/60)) -- 在染色圈外有伤害上限
						end
					else
						--其他情况造成原伤害
						enemybase.damage(target, self.laser_rate*1)
					end
				end
			end
		end
	end
end
local function fire_frame(self)
	if self.slow == 0 then --切换之后主炮也要等4f才能攻击
		self.reimu_next_shoot = max(0, self.reimu_next_shoot - 1)
		self.reimu_next_trail = max(0, self.reimu_next_trail - 1)
		self.yukari_next_shoot = self.yukari_max_next_shoot
	else
		self.reimu_next_shoot = self.reimu_max_next_shoot
		self.reimu_next_trail = self.reimu_max_next_trail
		self.yukari_next_shoot = max(0, self.yukari_next_shoot - 1)
	end
	self.reimu_max_next_shoot = int(6/self.attack_speed) --主炮攻击间隔(会受攻速影响）
	self.reimu_max_next_trail = int(6/self.attack_speed) --主炮攻击间隔(会受攻速影响）
	self.yukari_max_next_shoot = int(6/self.attack_speed)
end

theis_reimu_player = Class(player_class)
function theis_reimu_player:init(slot)
	player_class.init(self)
	load_res()
	self.vscale = 0.4 * player_scale
	self.hscale = 0.4 * player_scale
	self.name = "Reimu/Yukari"
	self.hspeed = 4.5
	self.lspeed = 2
	self.imgs = {}
	self.A = 1
	self.B = 1
	for i = 1, 24 do
		self.imgs[i] = 'native_theis_reimu_player' .. i
	end
	self.anglelist = { 100, 96, 84, 80 }
	self.sx = {}
	self.sy = {}
	self.shift = 1  --用于切换状态过程中的比率参数（灵梦为1，紫为0，转化时会均匀变化）
	self.sp = {{-36, -15}, {-15, -32}, {15, -32}, {36, -15}}
	self.spx = {}
	self.spy = {}
	for i = 1, 4 do
		self.sx[i] = self.x
		self.sy[i] = self.y
		self.spx[i] = self.x
		self.spy[i] = self.y
	end
	self.rx = 0
	self.ry = 0
	self.laser_wide = 0
	self.laser_flag = 10
	self.target_high = nil
	self.target_slow = nil
	self.support_ef = {}
	self._wisys = PlayerWalkImageSystem(self)
	fire_init(self)
	self.check = 42
end
function theis_reimu_player:shoot()
	fire_shot(self)
	if self.timer % 4 == 0 then
		PlaySound("plst00", 0.05, self.x / 768)
	end
end

local function reimu_spell_high(self)
	--New(player_spell_name,'player_spell_name1')
	--New(player_lihui,'dialog_reimu4',0.3)
	New(player_board_ch, 0, 255, 255, 270)
	New(tasker, function()
		misc.ShakeScreen(100, 3)
		local v = 2
		local a = ran:Float(0, 360)
		for i = 1, 2 do
			New(reimu_bomb_a, self.x, self.y, 255, 0, 0, a, v, self)
			a = a + 60
			v = v + 1
			New(reimu_bomb_a, self.x, self.y, 0, 255, 0, a, v, self)
			a = a + 60
			v = v + 1
			New(reimu_bomb_a, self.x, self.y, 0, 0, 255, a, v, self)
			a = a + 60
			v = v + 1
		end
	end)
	self.nextspell = 270
	self.lock_player_shift = self.nextspell - 120 --锁定时间往前提2s
	self.protect = math.max(270, self.protect)
	New(tasker, function()
		task.Wait(240)
		self.bomb_pos = false
	end)
end
local function yukari_spell_slow(self)
	New(player_board_ch, 0, 255, 0, 400)
	--self.slowlock = true
	player.nextshoot = 360
	New(tasker, function()
		for i = 1, 15 do
			New(bullet_killer, self.x, self.y)
			task.Wait(20)
		end
	end)
	New(tasker, function()
		local bombitem = {}
		misc.ShakeScreen(180, 2)
		local xx = 300
		for i = 1, 6 do
			table.insert(bombitem, New(yukari_bomb_b, xx, -900, 110, 0.5))
			task.Wait(5)
			table.insert(bombitem, New(yukari_bomb_b, -xx, 900, -70, 0.5))
			task.Wait(5)
			xx = xx - 1000 / 19
		end
		xx = 270
		for i = 1, 4 do
			table.insert(bombitem, New(yukari_bomb_a, -xx, -900, 70, 0.7))
			task.Wait(5)
			table.insert(bombitem, New(yukari_bomb_a, xx, 900, -110, 0.7))
			task.Wait(5)
			xx = xx - 100
		end
		xx = 90
		for i = 1, 3 do
			table.insert(bombitem, New(yukari_bomb_aA, -1200, -xx, 10, 1))
			task.Wait(5)
			table.insert(bombitem, New(yukari_bomb_aA, 1200, xx, -170, 1))
			task.Wait(5)
			xx = xx - 120
		end
		task.Wait(60)
		misc.ShakeScreen(180, 3)
		for i = 1, 100 do
			New(yukari_bomb_cEND, ran:Float(-250, 250), -1500, ran:Float(100, 80), ran:Float(1.5, 3))
			task.Wait(1)
		end
		--[[
		for i, o in ObjList(GROUP_PLAYER_BULLET) do
			o.sf = 0
		end
		--]]
		for _, v in ipairs(bombitem) do
			if IsValid(v) then
				v.sf = 0
			end
		end
		for i = 1, 20 do
			New(yukari_bomb_cEND, ran:Float(-250, 250), -1500, ran:Float(100, 80), ran:Float(1.5, 3))
			task.Wait(1)
		end
	end)
	New(tasker, function()
		New(yukari_dmg, 0, 0, 600, 600, 200, 0.2, 1)
		task.Wait(200)
		New(yukari_dmg, 0, 0, 600, 600, 150, 5, 1)
	end)
	self.nextspell = 400
	self.lock_player_shoot = self.nextspell --禁射击时间与bomb消失同步
	self.lock_player_shift = self.nextspell - 120 --锁定时间往前提2s
	self.protect = math.max(400, self.protect)
	New(tasker, function()
		task.Wait(360)
		self.bomb_pos = false
		--self.slowlock = false
	end)
end

function theis_reimu_player:spell()
	self.bomb_pos = true
	self.collect_line = self.collect_line - 512
	New(tasker, function()
		task.Wait(90)
		self.collect_line = self.collect_line + 512
	end)
	PlaySound("cat00", 1.0)
	if self.slow == 0 then
		reimu_spell_high(self)
	else
		yukari_spell_slow(self)
	end
end

local function SupportEffectFrame(self)
	local spe = self.support_ef
	local dx, dy = self.dx, self.dy
	for i = 1, 4 do
		spe[i] = spe[i] or { 0, 0, 0 }
		if dx > 0.5 then
			for n = 1, 3 do
				spe[i][n] = max(-60, spe[i][n] - 2.5)
			end
		elseif dx < -0.5 then
			for n = 1, 3 do
				spe[i][n] = min(60, spe[i][n] + 2.5)
			end
		else
			for n = 1, 3 do
				spe[i][n] = spe[i][n] - sign(spe[i][n]) * max(min(1.5, abs(spe[i][n] * 0.1)), abs(spe[i][n] * 0.1))
			end
		end
		if dy > 0.5 then
			for n = 1, 3 do
				spe[i][n] = spe[i][n] - sign(spe[i][n]) * max(min(1.5, abs(spe[i][n] * 0.1)), abs(spe[i][n] * 0.1))
			end
		elseif dy < -0.5 then
			spe[i][1] = max(-60, spe[i][1] - 3.5)
			spe[i][3] = min(60, spe[i][3] + 3.5)
		end
	end
end

function theis_reimu_player:frame()
	player_class.frame(self)
	--[[
	if self.slow == 1 then
		self._wisys = self._wisys2
	else
		self._wisys = self._wisys1
	end
	--]]
	--SupportEffectFrame(self)
	findtarget_high(self)
	if self.slow == 0 then
		for i = 1, 24 do
			self.imgs[i] = 'native_theis_reimu_player' .. i
		end
		findtarget_slow(self)--切高速时才会执行紫的寻找敌人函数（这样低速时紫就能锁定一个敌人）
	else
		for i = 1, 24 do
			self.imgs[i] = 'native_theis_yukari_player' .. i
		end
		if not IsValid(self.target_slow) or not self.target_slow.colli then
			--低速状态下只有丢失目标或者目标没有判定才会继续索敌
			findtarget_slow(self)
		end
	end
	--更新状态参数
	if self.slow==0 then
		self.shift=min(self.shift+1/6,1)
	else
		self.shift=max(self.shift-1/6,0)
	end

	if self.slow == 1 and IsValid(self.target_slow) and self.fire > 0 then
		self.laser_flag = max(self.laser_flag - 1, 0)
		if self.laser_flag == 0 then
			self.laser_wide = min(self.laser_wide + 0.1, 1)
		end
	else
		self.laser_flag = 10
		if self.slow == 0 then
			self.laser_wide = 0
		else
			self.laser_wide = max(self.laser_wide - 0.1, 0)
		end
	end
	if self.slow == 1 and not self.dialog and self.death <= 0 and self.lock_player_shoot <= 0 then  --miss时、对话时、放b时不诱导敌人
		local ar = 10 * sin(self.timer * 2)
		for i = 1, 4 do
			if IsValid(self.target_slow) then
				local a = Angle(self, self.target_slow)
				local r = 60
				local x0 = { r * cos(a + 60 + ar), r * cos(a + 120 - ar), r * cos(a - 60 - ar), r * cos(a - 120 + ar) }
				local y0 = { r * sin(a + 60 + ar), r * sin(a + 120 - ar), r * sin(a - 60 - ar), r * sin(a - 120 + ar) }
				for i = 1, 4 do
					x0[i] = r * cos(self.timer * 3 + i * 90)
					y0[i] = r * sin(self.timer * 3 + i * 90)
				end
				self.sx[i] = self.target_slow.x + (self.sx[i] - self.target_slow.x) * 0.8
				self.sy[i] = self.target_slow.y + (self.sy[i] - self.target_slow.y) * 0.8
				self.spx[i] = self.sx[i]
				self.spy[i] = self.sy[i]
			else
				local a = 90
				local r = 60
				local x0 = { r * cos(a + 60 + ar), r * cos(a + 120 - ar), r * cos(a - 60 - ar), r * cos(a - 120 + ar) }
				local y0 = { r * sin(a + 60 + ar), r * sin(a + 120 - ar), r * sin(a - 60 - ar), r * sin(a - 120 + ar) }
				for i = 1, 4 do
					x0[i] = r * cos(self.timer * 3 + i * 90)
					y0[i] = r * sin(self.timer * 3 + i * 90)
				end
				self.sx[i] = self.x + (self.sx[i] - self.x) * 0.8
				self.sy[i] = self.y + (self.sy[i] - self.y) * 0.8
				self.spx[i] = self.sx[i]
				self.spy[i] = self.sy[i]
			end
		end
	else
		for i = 1, 4 do
			self.sx[i] = self.x
			self.sy[i] = self.y
			self.spx[i] = self.x
			self.spy[i] = self.y
		end
	end
	fire_frame(self) --自机攻击计时器
end

local function SupportEffectRender(self, i, t)
	local spe = self.support_ef[i]

	local spx, spy, sp = self.supportx, self.supporty, self.sp[i]
	local scale = 0.5 * player_scale
	local r = 14 / 2
	local a1, a2
	for n = 1, 3 do
		a1 = 30 * n
		a2 = a1 - 150
		SetImageState('native_theis_reimu_support_ef' .. (t + n) % 7 + 1, "", Color(255*self.shift, 255, 255, 255))
		Render('native_theis_reimu_support_ef' .. (t + n) % 7 + 1,
				spx + sp[1]*self.shift + r * cos(a2),
				spy + sp[2]*self.shift + r * sin(a2),
				spe[n] - 90 + a1, scale)
	end
end

local function draw_reimu_sp(self)
	local t = int(self.timer / 4) % 7 + 1
	for i = 1, 4 do
		--SupportEffectRender(self, i, t)
		SetImageState('native_theis_reimu_support', "", Color(120*self.shift, 255, 255, 255))
		Render('native_theis_reimu_support', self.supportx + self.sp[i][1]*self.shift, self.supporty + self.sp[i][2]*self.shift, -self.timer * 3, 0.75 * player_scale)
		SetImageState('native_theis_reimu_support', "", Color(255*self.shift, 255, 255, 255))
		Render('native_theis_reimu_support', self.supportx + self.sp[i][1]*self.shift, self.supporty + self.sp[i][2]*self.shift, self.timer * 3, 0.5 * player_scale)
	end
end
local function draw_yukari_sp(self)
	local aa = { self.timer * 3, self.timer * 3 + 90, self.timer * 3 + 180, self.timer * 3 - 90 }

	local sp1 = int(self.timer / 4) % 6 + 1
	local sp3 = int(self.timer / 8) % 2 + 1
	for i = 1, 4 do
		Render('native_theis_yukari_support1' .. sp1, self.spx[i] + 60 * cos(self.timer * 3 + i * 90), self.spy[i] + 60 * sin(self.timer * 3 + i * 90), aa[i] + 180, 0.5 * player_scale)
		if not self.dialog and self.death <= 0 and IsValid(self.target_slow) and self.laser_wide > 0 and self.lock_player_shoot <= 0 then  --对话时不显示lock敌人
			CreateYukariLaser(self.spx[i], self.spy[i], aa[i] - 90, self.laser_wide * 28, self.timer * 3, Color(180, 255, 255, 255),
					Dist(self.spx[i] + 60 * cos(self.timer * 3 + i * 90), self.spy[i] + 60 * sin(self.timer * 3 + i * 90), self.target_slow.x, self.target_slow.y))
			Render('native_theis_yukari_support3' .. sp3, self.spx[i] + 60 * cos(self.timer * 3 + i * 90), self.spy[i] + 60 * sin(self.timer * 3 + i * 90), self.timer * 3 - 90, (self.laser_wide * 0.1 + 0.5 * cos(self.timer * 180)) * player_scale)
		end
	end
	if self.dialog  then --对话时不显示lock敌人
		Render('native_theis_yukari_support2', self.x, self.y, self.timer * 3, (self.laser_wide * 0.1 + 0.75 * cos(self.timer * 180)) * player_scale * (1 + 0.25 * sin(self.timer * 2)))
	elseif IsValid(self.target_slow) and self.laser_wide > 0 then
		Render('native_theis_yukari_support2', self.target_slow.x, self.target_slow.y, self.timer * 3, (self.laser_wide * 0.1 + 0.75 * cos(self.timer * 180)) * player_scale * (1 + 0.25 * sin(self.timer * 2)))
	end
end

function theis_reimu_player:render()
	if self.slow == 1 then
		draw_yukari_sp(self)
	end
	if self.shift > 0 then
		draw_reimu_sp(self)
	end

	player_class.render(self)
end

--endregion
----------------------------------------
