-- 原作自机，仅隔离资源名称以免与其他作品冲突。
local path = "res/player/marisa/"
local player_scale = 2

local function load_res()
	if not lstg.CheckRes(1, 'native_theis_marisa_player') then
		--星天开门特效
		--CreateRenderTarget('marisa_milkyway')
		--LoadFX('marisa_spell_effect', 'src/shader/texture_addtex2.fx')
		--LoadTexture('native_theis_marisa_change', path .. 'constellation/marisa_change.png')
		--LoadImageFromFile('native_theis_marisa_white', path .. 'constellation/marisa_white.png')

		--LoadImageFromFile('native_theis_marisa_aries', path .. 'constellation/marisa_aries.png')
		--LoadImageFromFile('native_theis_marisa_cancer', path .. 'constellation/marisa_cancer.png')
		--LoadImageFromFile('native_theis_marisa_gemini', path .. 'constellation/marisa_gemini.png')
		--LoadImageFromFile('native_theis_marisa_leo', path .. 'constellation/marisa_leo.png')
		--LoadImageFromFile('native_theis_marisa_taurus', path .. 'constellation/marisa_taurus.png')
		--LoadImageFromFile('native_theis_marisa_virgo', path .. 'constellation/marisa_virgo.png')
		--SetImageState('native_theis_marisa_aries', 'mul+add', Color(0xFFFFFFFF))
		--SetImageState('native_theis_marisa_cancer', 'mul+add', Color(0xFFFFFFFF))
		--SetImageState('native_theis_marisa_gemini', 'mul+add', Color(0xFFFFFFFF))
		--SetImageState('native_theis_marisa_leo', 'mul+add', Color(0xFFFFFFFF))
		--SetImageState('native_theis_marisa_taurus', 'mul+add', Color(0xFFFFFFFF))
		--SetImageState('native_theis_marisa_virgo', 'mul+add', Color(0xFFFFFFFF))

		--LoadImageFromFile('native_theis_marisa_star', path .. 'constellation/marisa_star.png')
		--LoadImageFromFile('native_theis_marisa_glitter', path .. 'constellation/marisa_glitter.png')
		--LoadImageFromFile('native_theis_marisa_starry_sky', path .. 'constellation/marisa_starry_sky.png')
		--LoadImageFromFile('native_theis_marisa_stars', path .. 'constellation/marisa_stars.png')
		--魔理沙新版雷
		LoadTexture('native_theis_marisa_bomb', path .. 'marisa_bomb.png')
		LoadAnimation("native_theis_marisa_bomb", "native_theis_marisa_bomb", 0, 0, 256, 256, 12, 1, 4)
		--行走图
		LoadTexture('native_theis_marisa_player', path .. 'marisa_player.png')
		LoadImageGroup('native_theis_marisa_player', 'native_theis_marisa_player', 0, 0, 116, 130, 8, 3, 0.5, 0.5)
		LoadTexture('native_theis_yuyuko_player', path .. 'yuyuko_player.png')
		LoadImageGroup('native_theis_yuyuko_player', 'native_theis_yuyuko_player', 0, 0, 120, 120, 8, 3, 0.5, 0.5)
		--魔理沙激光
		LoadTexture('native_theis_MarisaLaser_blue', path .. 'MarisaLaser_blue.png')
		LoadTexture('native_theis_MarisaLaser_red', path .. 'MarisaLaser_red.png')
		--魔理沙激光头
		LoadTexture('native_theis_marisaLaserHead', path .. 'marisaLaserHead.png')
		LoadAnimation("native_theis_marisaLaserHead_blue", "native_theis_marisaLaserHead", 0, 0, 200, 200, 15, 1, 4)
		LoadAnimation("native_theis_marisaLaserHead_red", "native_theis_marisaLaserHead", 0, 200, 200, 200, 15, 1, 4)
		--魔理沙主炮
		LoadTexture('native_theis_marisa_missle', path .. 'marisa_missle.png')
		LoadImage('native_theis_marisa_main', 'native_theis_marisa_missle', 0, 0, 240, 240)
		SetImageState('native_theis_marisa_main', '', Color(255, 255, 255, 255))
		-----------------------
		LoadTexture('native_theis_marisa_hit', path .. 'hit.png')
		for i = 1, 4 do
			LoadImage('native_theis_marisa_main_ef' .. i, 'native_theis_marisa_hit', 0, 64 * (i - 1), 64, 64)
			SetImageState('native_theis_marisa_main_ef' .. i, '', Color(150, 255, 255, 255))
		end
		-----------------------------------------
		--LoadImage('native_theis_marisa_support', 'native_theis_marisa_missle', 240, 0, 240, 240)
		LoadTexture("native_theis_marisa_support", path.."marisa_support.png")
		LoadImage('native_theis_marisa_support', 'native_theis_marisa_support', 0, 0, 64, 64)
		LoadImage('native_theis_marisa_support_light_blue', 'native_theis_marisa_support', 64, 0, 64, 64)
		LoadImage('native_theis_marisa_support_light_red', 'native_theis_marisa_support', 128, 0, 64, 64)
		-----------------------------------------

		LoadTexture('native_theis_yuyuko_main', path .. 'yuyuko_main.png')
		LoadImage('native_theis__yuyuko_main', 'native_theis_yuyuko_main', 0, 0, 512, 256)
		SetImageState('native_theis__yuyuko_main', '', Color(200, 255, 255, 255))
		LoadImage('native_theis__yuyuko_main_ef1', 'native_theis_yuyuko_main', 0, 256, 512, 256)
		SetImageState('native_theis__yuyuko_main_ef1', '', Color(150, 255, 255, 255))
		LoadImage('native_theis__yuyuko_main_ef2', 'native_theis_yuyuko_main', 0, 512, 512, 256)
		SetImageState('native_theis__yuyuko_main_ef2', '', Color(150, 255, 255, 255))
		LoadImage('native_theis__yuyuko_main_ef3', 'native_theis_yuyuko_main', 0, 768, 512, 256)
		SetImageState('native_theis__yuyuko_main_ef3', '', Color(150, 255, 255, 255))
		--SetImageCenter('native_theis_yuyuko_main',270,141)
		--SetImageState('native_theis_yuyuko_main','',Color(0x80FFFFFF))
		--SetImageState('yuyuko_main_ef','',Color(0x80FFFFFF))
		-----------------------------------------
		LoadTexture('native_theis_yuyuko_laser', path .. 'yuyuko_laser.png')
		LoadImage('native_theis_yuyuko_laser_light', 'native_theis_marisa_player', 224, 224, 32, 32)
		SetImageState('native_theis_yuyuko_laser_light', 'mul+add', Color(0xFFFF33FF))
		-----------------------------------------
		LoadTexture('native_theis_yuyuko_support', path .. 'yuyuko_support.png')
		LoadImageGroup('native_theis_yuyuko_support', 'native_theis_yuyuko_support', 0, 0, 76, 151, 20, 1)
		-----------------------------------------
		LoadImageFromFile('native_theis_marisa_bomb1', path .. 'marisa_bomb1.png')
		LoadImageFromFile('native_theis_marisa_bomb2', path .. 'marisa_bomb2.png')
		LoadImageFromFile('native_theis_marisa_bomb3', path .. 'marisa_bomb3.png')
		LoadImageFromFile('native_theis_yuyuko_bomb1', path .. 'yuyuko_bomb1.png')
		LoadImageFromFile('native_theis_yuyuko_bomb2', path .. 'yuyuko_bomb2.png')
		LoadImageFromFile('native_theis_yuyuko_sakura', path .. 'yuyuko_sakura.png')
	end

	--[[LoadAnimation('native_theis_marisa_hit_blue','native_theis_marisa_hit',0,0,64,64,1,4,4)
	SetAnimationState('native_theis_marisa_hit_blue','mul+add',Color(255,50,50,255))
	LoadAnimation('native_theis_marisa_hit_purple','native_theis_marisa_hit',0,0,64,64,1,4,4)
	SetAnimationState('native_theis_marisa_hit_purple','mul+add',Color(255,255,50,255))
	LoadAnimation('native_theis_marisa_hit_yellow','native_theis_marisa_hit',0,0,64,64,1,4,4)
	SetAnimationState('native_theis_marisa_hit_yellow','mul+add',Color(255,255,255,50))
	--]]
end

----------------------------------------
--region 自机子弹

local marisa_main_ef = Class(object)
function marisa_main_ef:init(x, y, rot, v)
	self.x = x
	self.y = y
	self.rot = rot
	self.vx = v * cos(rot)
	self.vy = v * sin(rot)
	self.img = 'marisa_main_ef1'
	self.layer = LAYER_PLAYER_BULLET + 50
	local s = 1.0 * player_scale
	self.hscale = s
	self.vscale = self.hscale
end
function marisa_main_ef:frame()
	if self.timer == 4 then
		self.img = 'marisa_main_ef2'
	end
	if self.timer == 8 then
		self.img = 'marisa_main_ef3'
	end
	if self.timer == 12 then
		self.img = 'marisa_main_ef4'
	end
	if self.timer == 16 then
		Del(self)
	end
	--self.hscale=(1-self.timer/20)*0.4
end

local marisa_main = Class(object)
function marisa_main:init(img, x, y, v, angle, dmg)
	self.group = GROUP_PLAYER_BULLET
	self.layer = LAYER_PLAYER_BULLET
	self.img = img
	self.x = x
	self.y = y
	self.rot = angle
	self.vx = v * cos(angle)
	self.vy = v * sin(angle)
	self.dmg = dmg
	local s = 0.4 * player_scale
	self.hscale = s
	self.vscale = self.hscale
	self.a = 28
	self.b = 10
	self.rect = true
end
function marisa_main:kill()
	New(marisa_main_ef,
			self.x, self.y, self.rot, 1)
end

local yuyuko_main_ef = Class(object)
function yuyuko_main_ef:init(x, y, rot, v)
	self.x = x
	self.y = y
	self.rot = rot
	self.vx = v * cos(rot)
	self.vy = v * sin(rot)
	self.img = 'native_theis__yuyuko_main_ef1'
	self.layer = LAYER_PLAYER_BULLET + 50
	local s = 0.15 * player_scale
	self.hscale = s
	self.vscale = self.hscale
end
function yuyuko_main_ef:frame()
	if self.timer == 4 then
		self.img = 'native_theis__yuyuko_main_ef2'
	end
	if self.timer == 8 then
		self.img = 'native_theis__yuyuko_main_ef3'
	end
	if self.timer == 12 then
		Del(self)
	end
end

local yuyuko_main = Class(object)
function yuyuko_main:init(img, x, y, v, angle, dmg)
	self.group = GROUP_PLAYER_BULLET
	self.layer = LAYER_PLAYER_BULLET
	self.img = img
	self.x = x
	self.y = y
	self.rot = angle
	self.vx = v * cos(angle)
	self.vy = v * sin(angle)
	self.dmg = dmg
	local s = 0.125 * player_scale
	self.hscale = s
	self.vscale = self.hscale
	self.a = 14
	self.b = 14
	if self.a ~= self.b then
		self.rect = true
	end
end
function yuyuko_main:kill()
	New(yuyuko_main_ef,
			self.x, self.y, self.rot, 3)
end

--endregion
----------------------------------------
--region 雷

--[[local marisa_bomb_a = Class(object)
function marisa_bomb_a:init(vh, ww, x, master)
	self.layer = LAYER_BG + 1
	self.group = GROUP_SPELL
	self.img = 'native_theis_marisa_bomb1'
	SetImageState(self.img, 'mul+add', Color(128, 0, 0, 255))
	self.hscale = 0
	self.vscale = 0
	self.omiga = -x
	self.master = master
	task.New(self, function()
		local xx, RGB = 0, 0
		for _ = 1, 40 do
			self.vscale = vh * sin(xx) * 0.8 * player_scale
			self.hscale = vh * sin(xx) * 0.8 * player_scale
			SetImageState(self.img, 'mul+add', Color(200, RGB, RGB, 255))
			xx = xx + 90 / 39
			RGB = RGB + 155 / 39
			task.Wait(1)
		end
		for _ = 1, _infinite do
			if self.over then
				New(bullet_cleaner, self.x, self.y, 900, 30, 1, true, true, 0) --扩散消弹圈
				local endx, RGB, alp = 90, 255, 200
				for _ = 1, 30 do
					self.vscale = vh * sin(endx) * player_scale / 3
					self.hscale = vh * sin(endx) * player_scale / 3
					SetImageState(self.img, 'mul+add', Color(alp, RGB, RGB, 255))
					endx = endx - 90 / 30
					RGB = RGB - 255 / 30
					alp = alp - 200 / 30
					task.Wait(1)
				end
				Del(self)
			end
			task.Wait(1)
		end
	end)
end
function marisa_bomb_a:frame()
	task.Do(self)
	if self.timer > 40 then
		SetImgState(self, 'mul+add', 200, 155 + 100 * sin(self.timer * 3), 155 + 100 * sin(self.timer * 3), 255)
	end
	if self.timer < 600 then
		self.hscale = 1 - self.timer / 600 * 2 / 3
		self.vscale = self.hscale
		self.a = self.hscale * 110
		self.b = self.a
	else
		self.over = true
	end
	self.x = self.master.x
	self.y = self.master.y

end
function marisa_bomb_a:colli(o)
	if o.group == GROUP_ENEMY_BULLET then
		Kill(o)
	end
end

local marisa_bomb_b = Class(object)
function marisa_bomb_b:init(vh, x, a1, master)
	self.layer = LAYER_ENEMY_BULLET_EF + 1
	self.group = GROUP_PLAYER_BULLET
	self.img = 'native_theis_marisa_bomb2'
	SetImageState(self.img, 'mul+add', Color(255, 0, 0, 255))
	self.vscale = 0
	self.hscale = 0
	self.rot = a1
	self.omiga = -1.5 * x
	self.master = master
	task.New(self, function()
		local x, RGB = 0, 0
		for i = 1, 30 do
			self.vscale = vh * sin(x) * player_scale
			self.hscale = vh * sin(x) * player_scale
			SetImageState(self.img, 'mul+add', Color(255, RGB, RGB, 255))
			task.Wait(1)
			x = x + 90 / 29
			RGB = RGB + 255 / 29
		end
		local RGB = 255
		for i = 1, 25 do
			SetImageState(self.img, 'mul+add', Color(RGB, RGB, RGB, 255))
			task.Wait(1)
			RGB = RGB - 255 / 24
		end
		Del(self)
	end)
end
function marisa_bomb_b:frame()
	task.Do(self)
	self.x = self.master.x
	self.y = self.master.y
end]]
local marisa_bomb1, marisa_bomb2
local marisa_bomb_main = Class(object)
function marisa_bomb_main:init()
	self.group = GROUP_GHOST
	task.New(self, function()
		local a
		for _ = 1, 30 do
			a = ran:Float(0, 360)
			for i = 1, 5 do
				New(marisa_bomb2, player.x, player.y, a + 72*i, ran:Float(0.2, 0.4))
			end
			New(marisa_bomb2, player.x, player.y, a, ran:Float(0.8, 1))
			task.Wait(1)
		end
		for i = 1, 8 do
			New(marisa_bomb1, player.x, player.y, 3, 45*i, 1.5)
			New(marisa_bomb1, player.x, player.y, 2, 45*i + 22.5, 1)
		end
		for _ = 1, 30 do
			a = ran:Float(0, 360)
			for i = 1, 5 do
				New(marisa_bomb2, player.x, player.y, a + 72*i, ran:Float(0.2, 0.4))
			end
			New(marisa_bomb2, player.x, player.y, a, ran:Float(0.8, 1))
			task.Wait(2)
		end
	end)
end
function marisa_bomb_main:frame()
	task.Do(self)
end

marisa_bomb1 = Class(object)
function marisa_bomb1:init(x, y, v, a, s)
	self.x, self.y = x, y
	self.layer = LAYER_ENEMY - 1
	self.group = GROUP_SPELL --符卡类
	self.hscale, self.vscale = 0, 0
	self.a, self.b = 45*s, 45*s
	self.img = "native_theis_marisa_bomb"
	_object.set_color(self, "mul+add", 255, 255, 255, 255)
	self.omiga = 6
	self.rot = a
	self.dmg = 0
	self.bound = false
	egg.AddSimStrChV(self, 0, v, a, 60)
	task.New(self, function()
		local d, ds = 5/120, s/60
		for _ = 1, 60 do
			self.dmg = self.dmg + d
			self.hscale, self.vscale = self.hscale + ds, self.vscale + ds
			self.a, self.b = 45*self.hscale, 45*self.vscale
			task.Wait(1)
		end
		for _ = 1, 60 do
			self.dmg = self.dmg + d
			task.Wait(1)
		end
		d = 10/30
		for _ = 1, 30 do
			self.dmg = self.dmg + d
			task.Wait(1)
		end
		task.Wait(90)
		self.bound = true
	end)
end
function marisa_bomb1:frame()
	task.Do(self)
end
function marisa_bomb1:render()
	SetAnimationState(self.img, "mul+add", Color(255, 255, 255, 255))
	RenderAnimation(self.img, self.timer, self.x, self.y, self.rot, self.hscale, self.vscale)
end
function marisa_bomb1:colli(o)
	if o.group == GROUP_ENEMY_BULLET then
		Kill(o)
	elseif o.Isbacklight then
		enemybase.damage(o, 0.25*self.dmg) --对光背伤害削减
	elseif o.group == GROUP_NONTJT or o.group == GROUP_ENEMY then
		enemybase.damage(o, self.dmg)
	end
end

--装饰的星星
marisa_bomb2 = Class(object)
function marisa_bomb2:init(x, y, a, size)
	self.x, self.y = x, y
	self.hscale, self.vscale = 1, 1
	self.group = GROUP_GHOST
	self.layer = LAYER_ENEMY - 1
	self.size = 0
	self.rot = ran:Float(0, 360)
	self.omiga = ran:Float(3, 6)*ran:Sign()
	self.img = "star_big7"
	_object.set_color(self, "", 200, 255, 255, 255)
	task.New(self, function()
		SetV(self, ran:Float(1, 8), a)
		local ds = size/20
		for _ = 1, 20 do
			self.size = self.size + ds
			task.Wait(1)
		end
		task.Wait(ran:Int(90, 120))
		for i = 1, 30 do
			self.vscale = cos(3*i)
			task.Wait(1)
		end
		Del(self)
	end)
end
function marisa_bomb2:frame()
	task.Do(self)
end
function marisa_bomb2:render()
	SetImageState(self.img, "mul+add", Color(self._a, self._r, self._g, self._b))
	Render(self.img, self.x, self.y, self.rot, self.size*self.hscale, self.size*self.vscale)
	SetImageState(self.img, "", Color(255, 255, 255, 255))
end


local yuyuko_sakura = Class(object)
function yuyuko_sakura:init(x, y, rot, v)
	self.layer = LAYER_ENEMY_BULLET_EF + 50
	self.img = 'native_theis_yuyuko_sakura'
	self.x = x
	self.y = y
	self.rot = rot
	local s = ran:Float(0.75, 1.25)
	self.hscale = s
	self.vscale = s
	self.vx = v * cos(rot)
	self.vy = v * sin(rot)
	self.ay = -0.001
	self.navi = true
end
function yuyuko_sakura:frame()
	if self.timer == 60 then
		Del(self)
	end
end
function yuyuko_sakura:render()
	local t = self.timer
	if self.timer <= 60 then
		SetImageState(self.img, 'mul+add', Color(255 - 255 * t / 60, 255, 100, 160))
		self.vx = self.vx * 0.975
		self.vy = self.vy * 0.975
		self.vscale = sin(t * 12)
	end
	if self.timer == 30 then
		self.ay = -0.025
	end
	object.render(self)
end

local yuyuko_bomb_a = Class(object)
function yuyuko_bomb_a:init(_x, _y, vh, x, a1, master)
	self.img = "native_theis_yuyuko_bomb2"
	self.layer = LAYER_BG + 1
	self.group = GROUP_PLAYER_BULLET
	self.colli = false
	SetImageState(self.img, "mul+add", Color(60, 255, 0, 255))
	self.vscale = 0
	self.hscale = 0
	self.omiga = -1.5 * a1
	self.master = master
	task.New(self, function()
		do
			local x, _d_x = (0), (90 / 39)
			local RGB, _d_RGB = (0), (155 / 39)
			for _ = 1, 40 do
				self.vscale = vh * sin(x) * 0.8 * player_scale
				self.hscale = vh * sin(x) * 0.8 * player_scale
				SetImageState(self.img, "mul+add", Color(60, 180, RGB, 180))
				task._Wait(1)
				x = x + _d_x
				RGB = RGB + _d_RGB
			end
		end
		local flag = true --判断是自然结束的还是被撞掉的
		local dh, dv = -self.hscale/700, -self.vscale/700
		for _ = 1, 600 do
			if not self.master.shield then
				flag = false
				break
			else
				self.hscale, self.vscale = self.hscale + dh, self.vscale + dv
			end
			task.Wait(1)
		end
		PlaySound("kira00")
		if flag then
			PlaySound("bonus2")
			_drop_item(item_bombchip, 1, self.x, self.y + 50)
		end
		master.shield = false --关闭护盾
		do
			local x0, y0 = self.x, self.y
			--New(marisa_dye,1)
			for sa = 0, 315, 45 do
				New(yuyuko_sakura, self.x, self.y, sa + ran:Float(-15, 15), ran:Float(1, 3))
				New(yuyuko_sakura, self.x, self.y, sa + ran:Float(-15, 15), ran:Float(3, 4))
				New(yuyuko_sakura, self.x, self.y, sa + ran:Float(-15, 15), ran:Float(4, 5))
			end
			do
				local vh = self.hscale
				local x, _d_x = (90), (-90 / 30)
				local RGB, _d_RGB = (180), (-180 / 30)
				local alp, _d_alp = (155), (-50 / 30)
				for _ = 1, 30 do
					self.vscale = vh * sin(x) * 0.8 * player_scale
					self.hscale = vh * sin(x) * 0.8 * player_scale
					SetImageState(self.img, "mul+add", Color(alp, 180, RGB, 180))
					self.x = x0
					self.y = y0
					task._Wait(1)
					x = x + _d_x
					RGB = RGB + _d_RGB
					alp = alp + _d_alp
				end
			end
			Del(self)
		end
	end)
	task.New(self, function()
		task._Wait(40)
		do
			local x, _d_x = (0), (3)
			for _ = 1, 200 do
				SetImageState(self.img, "mul+add", Color(100, 255, 155 + 100 * sin(x), 255))
				task._Wait(1)
				x = x + _d_x
			end
		end
	end)
end
function yuyuko_bomb_a:frame()
	self.x = self.master.x
	self.y = self.master.y
	task.Do(self)
end

local yuyuko_bomb_b = Class(object)
function yuyuko_bomb_b:init(_x, _y, vh, x, a1, master)
	self.img = "native_theis_yuyuko_bomb1"
	self.layer = LAYER_ENEMY_BULLET_EF + 1
	self.group = GROUP_PLAYER_BULLET
	self.colli = false
	self.vscale = 0
	self.hscale = 0
	self.rot = a1
	self.omiga = -1.5 * x
	self.master = master
	task.New(self, function()
		do
			local x, _d_x = (0), (90 / 29)
			local RGB, _d_RGB = (0), (255 / 29)
			for _ = 1, 30 do
				self.vscale = vh * sin(x) * player_scale
				self.hscale = vh * sin(x) * player_scale
				SetImageState(self.img, "mul+add", Color(255, 255, RGB, 255))
				task.Wait(1)
				x = x + _d_x
				RGB = RGB + _d_RGB
			end
		end
		do
			local x, _d_x = (0), (90 / 24)
			local RGB, _d_RGB = (255), (-255 / 24)
			for _ = 1, 25 do
				SetImageState(self.img, "mul+add", Color(255, 255, RGB, 255))
				task.Wait(1)
				x = x + _d_x
				RGB = RGB + _d_RGB
			end
		end
		Del(self)
	end)
end
function yuyuko_bomb_b:frame()
	task.Do(self)
	self.x = self.master.x
	self.y = self.master.y
end

--endregion
----------------------------------------
--region 射击

--魔理沙激光
local marisa_laser_init, marisa_laser_frame, marisa_laser_render
do

	--[[local laser_hit_eff = Class(object)
	do
		function laser_hit_eff:init(x, y, rot, v)
			self.x = x
			self.y = y
			self.rot = rot
			self.vx = v * cos(rot)
			self.vy = v * sin(rot)
			self.img = 'marisa_main_ef1'
			self.layer = LAYER_PLAYER + 1
			local s = 0.75 * player_scale
			self.hscale = s
			self.vscale = self.hscale
		end
		function laser_hit_eff:frame()
			if self.timer == 4 then
				self.img = 'marisa_main_ef2'
			end
			if self.timer == 8 then
				self.img = 'marisa_main_ef3'
			end
			if self.timer == 12 then
				self.img = 'marisa_main_ef4'
			end
			if self.timer == 16 then
				Del(self)
			end
		end
		function laser_hit_eff:render()
			Render(self.img, self.x, self.y, self.rot, self.hscale)
		end
	end]]

	function marisa_laser_init(self)
		self.maxoffset = { 0, 0, 0, 0 } --激光可达最远距离
		self.offset = { 0, 0, 0, 0 } --记录激光当前距离
		self.targets = { nil, nil, nil, nil } --捕获激光命中的目标
		self.anglelist = { 80, 85, 95, 100 }
		self.sup_pos = { { -45, -10 }, { -25, 15 }, { 25, 15 }, { 45, -10 } }
	end
	function marisa_laser_frame(self)
		if self.fire_marisa > 0.5 then
			local a, x, y, d, target
			if self.timer % 12 == 0 then
				PlaySound('lazer02', 0.025)
			end
			for i = 1, 4 do
				self.targets[i] = nil
				target = nil
				self.maxoffset[i] = min(600, self.maxoffset[i] + 60 * (1 - self.maxoffset[i] / 600)) --更新offset
				self.offset[i] = self.maxoffset[i]
				a = self.anglelist[i]
				x, y = self.x + self.sup_pos[i][1] * self.shift, self.y + self.sup_pos[i][2] * self.shift
				for _, o in ObjList(GROUP_ENEMY) do
					if o.colli and egg.IsInLaser(x, y, a, 16, o) then
						d = Dist(o.x, o.y, x, y) - (o.a + o.b) / 2
						if d < self.offset[i] then
							target = o
							self.offset[i] = d
						end
					end
				end
				for _, o in ObjList(GROUP_NONTJT) do
					if o.colli and egg.IsInLaser(x, y, a, 16, o) then
						d = Dist(o.x, o.y, x, y) - (o.a + o.b) / 2
						if d < self.offset[i] then
							target = o
							self.offset[i] = d
						end
					end
				end
				if target then
					--要是有命中敌人就会这样
					self.targets[i] = target
					self.maxoffset[i] = self.offset[i] --更新最远距离
					self.offset[i] = max(0, self.offset[i]) --将激光缩到该目标身上
					--[[命中后产生粒子效果
					if self.timer % 8 == 0 then
						New(laser_hit_eff, x + (d - 20) * cos(a), y + (d - 20) * sin(a), a, 1)
					end]]
					if target.Isbacklight or target.class.base == boss then
						enemybase.damage(target, 0.16 * self.laser_rate) --对光背和BOSS只造成33%伤害
					else
						enemybase.damage(target, 0.5 * self.laser_rate) --对目标造成伤害
					end
				end
			end
		else
			for i = 1, 4 do
				target = nil
				self.maxoffset[i] = 0 --重置offset
				self.offset[i] = self.maxoffset[i]
			end
		end
	end
	function marisa_laser_render(self)
		local a, x, y, t
		--渲染子机
		t = self.timer * 4
		if self.shift > 0 then
			for i = 1, 4 do
				x, y = self.x + self.sup_pos[i][1] * self.shift, self.y + self.sup_pos[i][2] * self.shift
				SetImageState('native_theis_marisa_support', '', Color(self.shift * 255, 255, 255, 255))
				Render('native_theis_marisa_support', x, y, -t, self.shift * 0.5 * player_scale)
			end
		end
		--渲染激光
		if self.fire_marisa > 0 then
			for i = 1, 4 do
				a = self.anglelist[i]
				x, y = self.x + self.sup_pos[i][1] * self.shift, self.y + self.sup_pos[i][2] * self.shift
				if self.targets[i] and IsValid(self.targets[i]) then
					--若有打中目标则变红
					egg.CreateLaser("native_theis_MarisaLaser_red", x, y, a, self.timer, self.offset[i], 256, 16 * self.fire_marisa, "mul+add", Color(255 * self.shift, 255, 255, 255))
					SetAnimationState("native_theis_marisaLaserHead_red", "mul+add", Color(255*0.7, 255, 255, 255))
					RenderAnimation("native_theis_marisaLaserHead_red", self.timer, x + self.offset[i] * cos(a), y + self.offset[i] * sin(a), a, 1, 1 * self.fire_marisa)
					SetImageState('native_theis_marisa_support_light_red', 'mul+add', Color(self.shift * 155, 255, 255, 255))
					Render('native_theis_marisa_support_light_red', x, y, t, self.shift * 0.6 * player_scale)
				else
					egg.CreateLaser("native_theis_MarisaLaser_blue", x, y, a, self.timer, self.offset[i], 256, 16 * self.fire_marisa, "mul+add", Color(255 * self.shift, 255, 255, 255))
					SetAnimationState("native_theis_marisaLaserHead_blue", "mul+add", Color(255*0.7, 255, 255, 255))
					RenderAnimation("native_theis_marisaLaserHead_blue", self.timer, x + self.offset[i] * cos(a), y + self.offset[i] * sin(a), a, 1, 1 * self.fire_marisa)
					SetImageState('native_theis_marisa_support_light_blue', 'mul+add', Color(self.shift * 155, 255, 255, 255))
					Render('native_theis_marisa_support_light_blue', x, y, t, self.shift * 0.6 * player_scale)
				end
			end
		end
	end
end
--幽幽子激光
local yuyuko_laser_init, yuyuko_laser_frame, yuyuko_laser_render
do
	local function RenderyuyukoLaser(x, y, offset, w, c)
		local l1 = offset
		local l2 = 256 - offset
		RenderTexture('native_theis_yuyuko_laser', 'mul+add',
				{ x - w, y, 0.5, l2, 0, c },
				{ x - w, y + l1, 0.5, 256, 0, c },
				{ x + w, y + l1, 0.5, 256, 48, c },
				{ x + w, y, 0.5, l2, 48, c }
		)
		RenderTexture('native_theis_yuyuko_laser', 'mul+add',
				{ x - w, y + l1, 0.5, 0, 0, c },
				{ x - w, y + l1 + 256, 0.5, 256, 0, c },
				{ x + w, y + l1 + 256, 0.5, 256, 48, c },
				{ x + w, y + l1, 0.5, 0, 48, c }
		)
		RenderTexture('native_theis_yuyuko_laser', 'mul+add',
				{ x - w, y + l1 + 256, 0.5, 0, 0, c },
				{ x - w, y + l1 + 512, 0.5, 256, 0, c },
				{ x + w, y + l1 + 512, 0.5, 256, 48, c },
				{ x + w, y + l1 + 256, 0.5, 0, 48, c }
		)
	end

	function yuyuko_laser_init(self)
		self.supy = 32
	end
	function yuyuko_laser_frame(self)
		if self.shift == 0 and self.fire_yuyuko > 0.5 then
			local x, y = self.x, self.y + self.supy * (1 - self.shift)
			for _, o in ObjList(GROUP_ENEMY) do
				if o.colli and egg.IsInLaser(x, y, 90, 16, o) then
					enemybase.damage(o, self.laser_rate * 1) -- 对目标造成伤害
				end
			end
			for _, o in ObjList(GROUP_NONTJT) do
				if o.colli and egg.IsInLaser(x, y, 90, 16, o) then
					enemybase.damage(o, self.laser_rate * 1) -- 对目标造成伤害
				end
			end
		end
	end
	function yuyuko_laser_render(self)
		local offset = (self.timer * 6 - self.y) % 256
		if self.fire_yuyuko > 0 then
			RenderyuyukoLaser(self.x, self.y + self.supy * (1 - self.shift), offset, 16 * self.fire_yuyuko, Color(200, 255, 255, 255))
		end
		if self.shift < 1 then
			local t, rate = (int(self.timer / 2) + 1) % 20 + 1, (1 - self.shift)
			SetImageState('native_theis_yuyuko_support' .. t, '', Color(255 * rate, 255, 255, 255))
			Render('native_theis_yuyuko_support' .. t, self.x, self.y + self.supy * rate, 0, 0.5 * player_scale)
			--渲染主炮的两个子机
			for i = 1, 2 do
				Render('native_theis_yuyuko_support' .. t, self.x + self.yuyuko_sp[i][1] * rate, self.y + self.yuyuko_sp[i][2] * rate, 0, 0.5 * player_scale)
			end
		end
	end
end
--魔理沙&幽幽子开枪情况(fire变量为0时代表不开枪
local fire_init, fire_shot, fire_frame
do
	function fire_init(self)
		self.fire_yuyuko = 0 --控制激光攻击动画的
		self.fire_marisa = 0
		self.marisa_max_next_shoot = int(6 / self.attack_speed) --主炮攻击间隔(会受攻速影响）
		self.marisa_next_shoot = self.marisa_max_next_shoot --主炮攻击计时器
		self.yuyuko_max_next_shoot = int(6 / self.attack_speed)
		self.yuyuko_next_shoot = self.yuyuko_max_next_shoot
	end
	function fire_shot(self)
		if self.lock_player_shoot <= 0 then
			if self.slow == 0 then
				self.fire_marisa = min(self.fire_marisa + 0.2, 1)
				if self.marisa_next_shoot == 0 then
					--主炮攻击
					PlaySound('plst00')
					New(marisa_main, 'native_theis_marisa_main', self.x, self.y, 16, 90, 8 * self.fire_buff)
					self.marisa_next_shoot = self.marisa_next_shoot + self.marisa_max_next_shoot
				end
			else
				self.fire_yuyuko = min(self.fire_yuyuko + 0.2, 1)
				if self.yuyuko_next_shoot == 0 and self.lock_player_shoot <= 0 then
					--主炮攻击
					PlaySound('plst00', 0.15, self.x / 1024)
					--一侧两个
					local u = 1
					for i = 1, 2 do
						New(yuyuko_main, 'native_theis__yuyuko_main', self.x + self.yuyuko_sp[i][1] + 10 * u, self.y + self.yuyuko_sp[i][2], 12, 90, 2 * self.fire_buff)
						u = -u
					end
					self.yuyuko_next_shoot = self.yuyuko_next_shoot + self.yuyuko_max_next_shoot
				elseif self.yuyuko_next_shoot == int(0.5 * self.yuyuko_max_next_shoot) then
					--PlaySound('plst00',0.15,self.x/1024)
					--一侧两个
					local u = 1
					for i = 1, 2 do
						New(yuyuko_main, 'native_theis__yuyuko_main', self.x + self.yuyuko_sp[i][1] + 10 * u, self.y + self.yuyuko_sp[i][2], 12, 90 + 5 * (-1 + 2 * (i % 2)), 2 * self.fire_buff)
						u = -u
					end
				end
			end
		end
	end
	function fire_frame(self)
		self.fire_yuyuko = max(self.fire_yuyuko - 0.1, 0)
		self.fire_marisa = max(self.fire_marisa - 0.1, 0)
		if self.slow == 0 then
			--切换之后主炮也要等4f才能攻击
			self.marisa_next_shoot = max(0, self.marisa_next_shoot - 1)
			self.yuyuko_next_shoot = self.yuyuko_max_next_shoot
		else
			self.marisa_next_shoot = self.marisa_max_next_shoot
			self.yuyuko_next_shoot = max(0, self.yuyuko_next_shoot - 1)
		end
		self.marisa_max_next_shoot = int(6 / self.attack_speed) --主炮攻击间隔(会受攻速影响）
		self.yuyuko_max_next_shoot = int(6 / self.attack_speed)
	end
end

--endregion
----------------------------------------
--region 星天开门

local marisa_constellation_coord = {
	{ 187, 636, 262, 570, 334, 360, 666, 467, 775, 558, 810, 643 }, --aries
	{ 437, 128, 491, 445, 443, 592, 300, 784, 698, 869 }, --cancer
	{ 294, 240, 462, 175, 204, 335, 516, 249, 392, 389, 559, 410, 792, 423, 314, 506, 363, 652,
	  616, 635, 317, 824, 414, 827, 607, 790, 720, 757, 795, 806, 322, 356 }, --gemini
	{ 173, 770, 324, 608, 363, 723, 742, 701, 703, 542, 611, 473, 599, 344, 759, 227, 831, 278 }, --leo
	{ 184, 215, 371, 124, 473, 329, 399, 500, 489, 447, 448, 656, 513, 528, 737, 449, 818, 473,
	  508, 605, 572, 720, 735, 875 }, --taurus
	{ 471, 302, 847, 196, 756, 361, 555, 393, 656, 440, 621, 619, 473, 583, 612, 724, 282, 804,
	  365, 746, 153, 660, 282, 804 }, --virgo
}
local marisa_constellation_name = {
	'native_theis_marisa_aries',
	'native_theis_marisa_cancer',
	'native_theis_marisa_gemini',
	'native_theis_marisa_leo',
	'native_theis_marisa_taurus',
	'native_theis_marisa_virgo',
}
local marisa_constellation_color = {
	Color(0xFFFFFFFF),
	Color(0xFFFF0000),
	Color(0xFF00FF00),
	Color(0xFF0000FF),
	Color(0xFF00FFFF),
	Color(0xFFFF00FF),
	Color(0xFFFFFF00),
}

local marisa_AstralStasis = Class(object)
function marisa_AstralStasis:init()
	self.x = 0
	self.y = 0
	self.threshold = 0
	self.group = GROUP_GHOST
	self.layer = LAYER_BG + 1
	self.constellation = {}
	self.stars = {}
	--local star_num=0
	local color_list = marisa_constellation_color
	for i = 1, 12 do
		local serial = ran:Int(1, 6)
		local scale = ran:Float(0.5, 1) * player_scale
		local color = color_list[ran:Int(1, 7)]
		--r,a,serial,rot,scale,omega,color,stars
		self.constellation[i] = {
			32 + i * 30,
			i * GOLD + ran:Float(-10, 10), serial,
			ran:Float(0, 360),
			scale,
			ran:Sign() * ran:Float(0.5, 0.8),
			color,
			{},
		}
		for j = 1, #marisa_constellation_coord[serial] / 2 do
			--star_num=star_num+1
			--x,y,phase
			self.constellation[i][8][j] = {
				(marisa_constellation_coord[serial][j * 2 - 1] - 500) / 6 * scale,
				(500 - marisa_constellation_coord[serial][j * 2]) / 6 * scale,
				ran:Float(0, 360),
			}
		end
	end
end
function marisa_AstralStasis:frame()
	for i = 1, 12 do
		self.constellation[i][2] = self.constellation[i][2] + 0.5
		self.constellation[i][4] = self.constellation[i][4] + self.constellation[i][6]
	end
	--[[
		for i=1,#self.stars do

		end
	--]]
	if self.timer <= 60 then
		self.threshold = self.threshold + 0.016666
	elseif self.timer >= 215 then
		Del(self)
	end
end
function marisa_AstralStasis:render()
	if self.timer < 210 then
		PushRenderTarget('marisa_milkyway')

		Render('native_theis_marisa_stars', 0, 0, self.timer * 0.5, player_scale)

		for i = 1, 12 do
			local x, y = self.constellation[i][1] * cos(self.constellation[i][2]), self.constellation[i][1] * sin(self.constellation[i][2])
			Render(
					marisa_constellation_name[self.constellation[i][3]],
					x, y,
					self.constellation[i][4],
					self.constellation[i][5] / 6 * player_scale
			)
			local _stars = self.constellation[i][8]

			SetImageState('native_theis_marisa_star', 'mul+add', self.constellation[i][7])
			local _drot = self.constellation[i][4]
			for j = 1, #_stars do
				Render('native_theis_marisa_star',
						x + _stars[j][1] * cos(_drot) - _stars[j][2] * sin(_drot),
						y + _stars[j][1] * sin(_drot) + _stars[j][2] * cos(_drot),
						0, (1 + 0.6 * sin(self.timer + _stars[j][3])) / 30 * player_scale)
			end
		end

		--Render('native_theis_marisa_aries',0,0,self.timer)

		PopRenderTarget()

		local x, y = WorldToScreen(self.x, self.y)
		PostEffect('marisa_milkyway', 'marisa_spell_effect', 'mul+add',
		--PostEffect(InternalPostEffectBuffer, 'marisa_spell_effect', '',
				{
					threshold = self.threshold,
					tex = 'native_theis_marisa_change',
					--tex2='native_theis_marisa_stars',
				}
		)
	end

	if self.timer > 180 and self.timer < 210 then
		SetImageState('native_theis_marisa_white', '', Color((self.timer - 180) / 30 * 255, 255, 255, 255))
		Render('native_theis_marisa_white', 0, 0, 0, player_scale)
	elseif self.timer >= 210 then
		SetImageState('native_theis_marisa_white', '', Color((300 - self.timer) / 6 * 255, 255, 255, 255))
		Render('native_theis_marisa_white', 0, 0, 0, player_scale)
	end
end

--endregion
----------------------------------------

theis_marisa_player = Class(player_class)
function theis_marisa_player:init()
	load_res(self)
	-----------------------------------------
	player_class.init(self)
	self.vscale = 0.4 * player_scale
	self.hscale = 0.4 * player_scale
	self.name = "Marisa/Yuyuko"
	self.imgs = {}
	self.A = 1
	self.B = 1
	for i = 1, 24 do
		self.imgs[i] = 'native_theis_marisa_player' .. i
	end --装载纹理
	self.hspeed = 5
	self.lspeed = 2 --高低速都要比其他组机体快
	self.shield = false --是否在护盾状态
	self.shift = 1 --用于切换状态过程中的比率参数（魔理沙为1，uuz为0，转化时会均匀变化）
	self.shield_high = nil   --魔理沙的护盾对象
	self.slist = nil
	fire_init(self)
	marisa_laser_init(self)
	yuyuko_laser_init(self)

	self.check = 32 --决死时间

	self.yuyuko_sp = { { -20, 0 }, { 20, 0 } } --uuz新的两个子机位置（其实是用来发射主炮的）
end
function theis_marisa_player:shoot()
	fire_shot(self)
end
function theis_marisa_player:spell()
	self.collect_line = self.collect_line - 300
	PlaySound("cat00", 1.0)
	if self.slow == 0 then
		self.protect = math.max(300, self.protect)
		self.nextspell = 300
		--可以射击和取消锁定时间往前移2s
		self.lock_player_shoot = self.nextspell - 120
		self.lock_player_shift = self.nextspell - 120
		misc.ShakeScreen(60, 5)
		New(player_board_ch, 255, 255, 0, 300)
		New(marisa_bomb_main)
	else
		self.shield = true
		self.marisa_next_spell = true
		self.nextspell = 180
		New(bullet_cleaner, self.x, self.y, 600, 60, 60, true, false, 0) --扩散消弹圈
		New(player_board_ch, 0, 255, 0, 300)
		New(tasker, function()
			New(yuyuko_bomb_a, self.x, self.y, 0.5, 500, 1, self)
			New(yuyuko_bomb_a, self.x, self.y, 0.45, 500, -1, self)
			do
				local vh1, _d_vh1 = (1.5), (-1 / 4)
				local a0, _d_a0 = (0), (360 / 4)
				for _ = 1, 5 do
					New(yuyuko_bomb_b, self.x, self.y, vh1, 1, a0, self)
					task.Wait(2)
					vh1 = vh1 + _d_vh1
					a0 = a0 + _d_a0
				end
			end
		end)
		self.protect = math.max(120, self.protect)
	end
end
function theis_marisa_player:frame()
	player_class.frame(self)
	--更新贴图与子机位置状态
	do
		if self.slow == 0 then
			for i = 1, 24 do
				self.imgs[i] = 'native_theis_marisa_player' .. i
			end
		else
			for i = 1, 24 do
				self.imgs[i] = 'native_theis_yuyuko_player' .. i
			end
		end
		if self.slow == 0 then
			self.shift = min(self.shift + 1 / 6, 1)
		else
			self.shift = max(self.shift - 1 / 6, 0)
		end
	end
	fire_frame(self)
	marisa_laser_frame(self)
	yuyuko_laser_frame(self)
end
function theis_marisa_player:render()
	player_class.render(self)
	yuyuko_laser_render(self)
	marisa_laser_render(self)
end
function theis_marisa_player:colli(other)
	player_class.colli(self, other) -- 直接使用 player_class 的方法
	-- 检测 death，如果等于 90 + check 说明发生了 miss，这时候如果自己有罩子就马上复活
	if self.death == (90 + self.check) and self.shield then
		self.death = 0 -- 复活
		self.shield = false -- 关掉罩子
		self.nextspell = 60
		self.protect = math.max(120, self.protect)
		New(bullet_cleaner, self.x, self.y, 600, 60, 60, false, false, 0) --扩散消弹圈
		--New(bullet_killer, self.x, self.y)
	end
end

--强制移除uuz的罩子并且返还一半消耗的方法
function removeYuyukoShield()
	if player.shield then
		player.shield = false -- 开启LSC时强制移除魔理沙的无敌罩子
		_drop_item(item_bombchip, 2, player.x, player.y + 50)
		PlaySound("bonus2")
	end
end
