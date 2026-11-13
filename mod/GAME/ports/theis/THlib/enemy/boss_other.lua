---=====================================
---th style boss
---特效、其他组件
---=====================================

----------------------------------------
---boss death

local boss_death_proc1 = boss.dialog.New(true)
function boss_death_proc1:init()
	self.colli = false -- 避免自机被体术
	player.dialog = false
	self.dialog_displayer = New(dialog_displayer)
	self._dialog_maintask = task.New(self, function()
		if self.class.spExplode then
			self.class.spExplode(self)
		else
			New(boss_death_ef, self.x, self.y)
			local angle = ran:Float(10, 20)
			self.vx = 0.2 * cos(angle)
			self.vy = 0.2 * sin(angle)
			task.Wait(60)
			self.vx = 0
			self.vy = 0
			New(boss_death_ef, self.x, self.y)
			New(boss_death_circle, self.x, self.y)
			Del(self)
		end
	end)
end

local boss_death_proc2 = boss.card.New("",
		2, 5, 10, 100, { 0, 0, 0 }, false, "normal")
function boss_death_proc2:init()
	lstg.Log(3, "Unknown boss stage. For unknown reasons, boss death effect was skipped.")
	Del(self)
end

---@param self boss.object
function boss.InsertDeathEffect(self)
	table.insert(self.cards, boss_death_proc1)
	table.insert(self.cards, boss_death_proc2) -- 防止boss被提前杀掉
end

----------------------------------------
---boss move

--boss移动

local bmove = {}
boss.move = bmove

function bmove:init()
	local c = boss.GetCurrentCard(self)
	task.New(self, function()
		task.MoveTo(c.x, c.y, c.t, c.m)
		Kill(self)
	end)
end
function bmove:frame()
end
function bmove:render()
end
function bmove:del()
end

function bmove.New(x, y, t, m)
	local c = {}
	c.frame = bmove.frame
	c.render = bmove.render
	c.init = bmove.init
	c.del = bmove.del
	c.name = ""
	c.t1 = 999999999
	c.t2 = 999999999
	c.t3 = 999999999
	c.hp = 999999999
	c.is_sc = false
	c.is_extra = false
	c.is_combat = false
	c.is_move = true
	c.x = x
	c.y = y
	c.t = t
	c.m = m
	return c
end

----------------------------------------
---boss 特效
---一些华丽的效果（

--开卡文字

local spell_card_ef = Class(object)
function spell_card_ef:init()
	self.layer = LAYER_BG + 1
	self.group = GROUP_GHOST
	self.alpha = 0
	task.New(self, function()
		for i = 1, 50 do
			task.Wait()
			self.alpha = self.alpha + 0.02
		end
		task.Wait(60)
		for i = 1, 50 do
			task.Wait()
			self.alpha = self.alpha - 0.02
		end
		Del(self)
	end)
end
function spell_card_ef:frame()
	task.Do(self)
	local nmsl
end
function spell_card_ef:render()
	SetImageState('spell_card_ef', '', Color(255 * self.alpha, 255, 255, 255))
	for j = 1, 10 do
		local h = (j - 5.5) * 32
		for i = -2, 2 do
			local l = i * 128 + ((self.timer * 2) % 128) * (2 * (j % 2) - 1)
			Render('spell_card_ef', l * cos(30), l * sin(30) + h, -60)
		end
	end
end

--蓄力

boss_cast_ef = Class(object)
function boss_cast_ef:init(x, y)
	self.hide = true
	PlaySound('ch00', 0.5, 0)
	for i = 1, 50 do
		local angle = ran:Float(0, 360)
		local lifetime = ran:Int(50, 80)
		local l = ran:Float(300, 500)
		New(boss_cast_ef_unit, x + l * cos(angle), y + l * sin(angle), l / lifetime, angle + 180, lifetime, ran:Float(2, 3))
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
	self.img = 'img_void'
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
		SetImageState('img_void', 'mul+add', Color((self.lifetime - self.timer) * 12, 255, 255, 255))
	else
		SetImageState('img_void', 'mul+add', Color((self.timer / (self.lifetime - 15)) ^ 6 * 180, 255, 255, 255))
	end
	DefaultRenderFunc(self)
end

--死亡爆炸

boss_death_ef = Class(object)
function boss_death_ef:init(x, y)
	PlaySound('enep01', 0.4, 0)
	self.hide = true
	misc.ShakeScreen(30, 15)
	for i = 1, 70 do
		local angle = ran:Float(0, 360)
		local lifetime = ran:Int(40, 120)
		local l = ran:Float(100, 500)
		New(boss_death_ef_unit, x, y, l / lifetime, angle, lifetime, ran:Float(2, 4))
	end
	Del(self)--哪个傻吊把这个漏了……
end

boss_death_ef_unit = Class(object)
function boss_death_ef_unit:init(x, y, v, angle, lifetime, size)
	self.x = x
	self.y = y
	self.rot = ran:Float(0, 360)
	SetV(self, v, angle)
	self.lifetime = lifetime
	self.omiga = 3
	self.layer = LAYER_ENEMY + 50
	self.group = GROUP_GHOST
	self.bound = false
	self.img = 'img_void'
	self.hscale = size
	self.vscale = size
end
function boss_death_ef_unit:frame()
	if self.timer == self.lifetime then
		Del(self)
	end
end
function boss_death_ef_unit:render()
	if self.timer < 15 then
		SetImageState('img_void', 'mul+add', Color(self.timer * 12, 255, 255, 255))
	else
		SetImageState('img_void', 'mul+add', Color(((self.lifetime - self.timer) / (self.lifetime - 15)) * 180, 255, 255, 255))
	end
	DefaultRenderFunc(self)
end

--非或符结束时弹出的文字

kill_timer = Class(object)
function kill_timer:init(x, y, t)
	self.t = t
	self.x = x
	self.y = y
	self.yy = y
	self.alph = 0
end
function kill_timer:frame()
	if self.timer <= 30 then
		self.alph = self.timer / 30
		self.y = self.yy - 30 * cos(3 * self.timer)
	end
	if self.timer > 120 then
		self.alph = 1 - (self.timer - 120) / 30
	end
	if self.timer >= 150 then
		Del(self)
	end
end
function kill_timer:render()
	SetViewMode 'world'
	local alpha = self.alph
	--SetFontState('time', '', Color(alpha * 255, 0, 0, 0))
	--RenderText('time', string.format("%.2f", self.t / 60) .. 's', 41, self.y - 1, 0.5, 'centerpoint')
	--SetFontState('time', '', Color(alpha * 255, 200, 200, 200))
	--RenderText('time', string.format("%.2f", self.t / 60) .. 's', 40, self.y, 0.5, 'centerpoint')
	--SetImageState('kill_time', '', Color(alpha * 255, 255, 255, 255)) -- 建议改成TTF渲染
	--Render('kill_time', -40, self.y - 2, 0.6, 0.6)
end

hinter_bonus = Class(object)
function hinter_bonus:init(img, size, x, y, t1, t2, fade, bonus)
	self.img = img
	self.x = x
	self.y = y
	self.t1 = t1
	self.t2 = t2
	self.fade = fade
	self.group = GROUP_GHOST
	self.layer = LAYER_TOP
	self.size = size
	self.t = 0
	self.hscale = self.size
	self.bonus = bonus
end
function hinter_bonus:frame()
	if self.timer < self.t1 then
		self.t = self.timer / self.t1
	elseif self.timer < self.t1 + self.t2 then
		self.t = 1
	elseif self.timer < self.t1 * 2 + self.t2 then
		self.t = (self.t1 * 2 + self.t2 - self.timer) / self.t1
	else
		Del(self)
	end
end
function hinter_bonus:render()
	if self.fade then
		SetImageState(self.img, '', Color(self.t * 255, 255, 255, 255))
		self.vscale = self.size
		--SetFontState('score3', '', Color(self.t * 255, 255, 255, 255))
		--RenderScore('score3', self.bonus, self.x + 1, self.y - 41, 0.7, 'centerpoint')
		object.render(self)
	else
		SetImageState(self.img, '', Color(0xFFFFFFFF))
		self.vscale = self.t * self.size
		--SetFontState('score3', '', Color(255, 255, 255, 255))
		--RenderScore('score3', self.bonus, self.x + 1, self.y - 41, 0.7, 'centerpoint')
		object.render(self)
	end
end

--boss死亡反色圈

boss_death_circle = Class(object)
function boss_death_circle:init(x, y)
	self.layer = LAYER_TOP - 1
	self.group = GROUP_GHOST
	self.x = x
	self.y = y
	self.bound = false
	self.a, self.b = 0, 0
	self.rect = false
	self.colli = false
	self.cirR0 = 16
	self.cirR1 = 1000 - self.cirR0
	self.cirR2 = 800
	self.size = 0
	self.size1 = 0
	self.size2 = 0
	task.New(self, function()
		for t = 1, 90 do
			local tk = t / 90
			local sk = 1 + sin(-90 + 90 * tk)
			self.size = self.cirR0 + self.cirR1 * sk
			self.size1 = self.cirR2 * sk

			task.Wait(1)
		end
	end)
	task.New(self, function()
		task.Wait(30)
		self.colli = true
		for t = 1, 60 do
			local tk = t / 60
			local sk = 1 + sin(-90 + 90 * tk)
			self.size2 = self.cirR2 * sk
			self.a, self.b = self.size2, self.size2

			task.Wait(1)
		end
		Del(self)
	end)
end
function boss_death_circle.frame(self)
	task.Do(self)
	local t = self.timer
end
function boss_death_circle.render(self)
	if self.size > 0 then
		rendercircle(self.x, self.y, self.size, 32)
	end
	if self.size2 > 0 then
		rendercircle(self.x, self.y, self.size2, 32)
	end
	local R = 32
	if self.size1 > 0 then
		rendercircle(self.x + R, self.y, self.size1, 32)
		rendercircle(self.x - R, self.y, self.size1, 32)
		rendercircle(self.x, self.y + R, self.size1, 32)
		rendercircle(self.x, self.y - R, self.size1, 32)
	end
end

--boss骚气
local saoqi1, saoqi2, saoqi3
boss_saoqi = Class(object)
function boss_saoqi:init(mst)
	self.boss = mst
	self.bound = false
	self.x, self.y = mst.x, mst.y
	local r, g, b, blend = mst.saoqiR, mst.saoqiG, mst.saoqiB, mst.saoqiBlend
	task.New(self, function()
		for t = 1, _infinite do
			if IsValid(mst) then
				self.x, self.y = mst.x, mst.y
				if mst.aura_alpha_d > 0 then
					if t%10 == 0 then
						New(saoqi1, self, r, g, b, blend, ran:Float(-6, 6))
					end
					if t%16 == 0 then
						New(saoqi2, self, blend, ran:Float(0, 360))
					end
					if t%5 == 0 then
						New(saoqi3, self, r, g, b, blend, ran:Float(0, 360))
					end
				end
			end
			task.Wait(1)
		end
	end)
end
function boss_saoqi:frame()
	task.Do(self)
end
function boss_saoqi:render()
	--Render("ball_huge1", self.x, self.y, 0, 1, 1)
end

local size = 1
saoqi1 = Class(object)
function saoqi1:init(mst, r, g, b, blend, angle)
	self.layer = LAYER_ENEMY - 10
	self.img = "saoqi2"
	self.hscale, self.vscale = size, 0
	self.rot = angle
	_object.set_color(self, blend, 255, r, g, b)
	--长宽比和透明度变化
	task.New(self, function()
		local d_a, dh, dv, x, y, dy = -255/40, size*2.25/40, size*4/40, ran:Float(-5, 5), 0, 0.5
		for _ = 1, 40 do
			y = y + dy
			if IsValid(mst) then
				self.x, self.y = mst.x + x, mst.y + y
			else
				break
			end
			self.hscale, self.vscale = self.hscale + dh, self.vscale + dv
			self._a = self._a + d_a
			task.Wait(1)
		end
		Del(self)
	end)
end
function saoqi1:frame()
	task.Do(self)
end
function saoqi1:render()
	SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
	Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

saoqi2 = Class(object)
function saoqi2:init(mst, blend, angle)
	self.layer = LAYER_ENEMY - 11
	self.img = "saoqi1"
	self.hscale, self.vscale = 3*size, 2*size
	self.rot = angle
	_object.set_color(self, blend, 75, 255, 255, 255)
	--长宽比和透明度变化
	task.New(self, function()
		local d_a, dh, dv = 0/60, -2/60*size, -1/60*size
		for _ = 1, 60 do
			if IsValid(mst) then
				self.x, self.y = mst.x, mst.y
			else
				break
			end
			self.hscale, self.vscale = self.hscale + dh, self.vscale + dv
			self._a = self._a + d_a
			task.Wait(1)
		end
		Del(self)
	end)
end
function saoqi2:frame()
	task.Do(self)
end
function saoqi2:render()
	SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
	Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

saoqi3 = Class(object)
function saoqi3:init(mst, r, g, b, blend, angle)
	self.layer = LAYER_ENEMY - 12
	self.img = "saoqi1"
	self.hscale, self.vscale = 0, 0
	self.rot = angle
	_object.set_color(self, blend, 0, r, g, b)
	--长宽比变化
	egg.SimSizeCh(self, 0, 2.5*size, 30)
	--透明度变化
	task.New(self, function()
		local d_a = 0.7*255/15
		for _ = 1, 15 do
			if IsValid(mst) then
				self.x, self.y = mst.x, mst.y
			else
				break
			end
			self._a = self._a + d_a
			task.Wait(1)
		end
		d_a = -0.7*255/45
		for _ = 1, 45 do
			if IsValid(mst) then
				self.x, self.y = mst.x, mst.y
			else
				break
			end
			self._a = self._a + d_a
			task.Wait(1)
		end
		Del(self)
	end)
end
function saoqi3:frame()
	task.Do(self)
end
function saoqi3:render()
	SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
	Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end
