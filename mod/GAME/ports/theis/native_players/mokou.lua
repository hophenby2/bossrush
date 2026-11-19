-- 原作自机，仅隔离资源名称以免与其他作品冲突。
local path = "res/player/mokou/"
local player_scale = 2

local function load_res()
	LoadTexture('native_theis_mokou_player', path .. 'mokou_player.png')
	LoadImageGroup('native_theis_mokou_player', 'native_theis_mokou_player', 0, 0, 90, 120, 8, 3, 0.5, 0.5)
	LoadTexture('native_theis_keine_player', path .. 'keine_player.png')
	LoadImageGroup('native_theis_keine_player', 'native_theis_keine_player', 0, 0, 96, 120, 8, 3, 0.5, 0.5)
	LoadTexture('native_theis_mokou_support', path .. 'mokou_support.png')
	LoadImageGroup('native_theis_mokou_support', 'native_theis_mokou_support', 0, 0, 57, 151, 20, 1)
	-----------------------------------------
	LoadTexture('native_theis_mokou_main', path .. 'mokou_main.png')
	--
	LoadImage('native_theis_keine_main2', 'native_theis_mokou_main', 0, 0, 162, 44)
	SetImageState('native_theis_keine_main2', '', Color(0xA0FFFFFF))
	LoadAnimation('native_theis_keine_main2_ef', 'native_theis_mokou_main', 0, 0, 162, 44, 1, 5, 3)
	--
	LoadImage('native_theis_mokou_main', 'native_theis_mokou_main', 162, 0, 162, 44)
	SetImageState('native_theis_mokou_main', '', Color(0xA0FFFFFF))
	LoadAnimation('native_theis_mokou_main_ef', 'native_theis_mokou_main', 162, 0, 162, 44, 1, 5, 3)
	SetImageCenter('native_theis_mokou_main', 112, 22)
	-----------------------------------------
	LoadTexture('native_theis_mokou_bomb', path .. 'mokou_bomb.png')
	LoadImage('native_theis_mokou_bomb_shoot', 'native_theis_mokou_bomb', 87, 0, 87, 25)
	SetImageCenter('native_theis_mokou_bomb_shoot', 70, 25 / 2)
	SetImageState('native_theis_mokou_bomb_shoot', '', Color(0xA0FFFFFF))
	LoadAnimation('native_theis_mokou_bomb_ready', 'native_theis_mokou_bomb', 87, 25, 87, 25, 1, 5, 4)
	SetAnimationState('native_theis_mokou_bomb_ready', '', Color(0xA0FFFFFF))
	-----------------------------------------
	LoadTexture('native_theis_mokou_spread', path .. 'mokou_spread.png')
	LoadAnimation('native_theis_mokou_spread', 'native_theis_mokou_spread', 128, 0, 128, 128, 9, 1, 2)
	SetAnimationState('native_theis_mokou_spread', 'mul+add', Color(0xA0FFFFFF))
	-----------------------------------------
	LoadImageFromFile('native_theis_keine_main', path .. 'keine_main.png')
	-----------------------------------------
	LoadTexture('native_theis_keine_sup', path .. 'keine_sup.png')
	LoadImage('native_theis_keine_sup', 'native_theis_keine_sup', 0, 0, 40, 40)
	SetImageState('native_theis_keine_sup', '', Color(192, 255, 255, 255))
	LoadImage('native_theis_keine_sup_ef', 'native_theis_keine_sup', 0, 120, 40, 40)
	-----------------------------------------
	LoadTexture('native_theis_keine_bullet_slow', path .. 'keine_bullet_slow.png')
	LoadImage('native_theis_keine_bullet_slow', 'native_theis_keine_bullet_slow', 0, 0, 300, 80)
	SetImageState('native_theis_keine_bullet_slow', '', Color(192, 255, 255, 255))
	LoadImage('native_theis_keine_bullet_slow_ef', 'native_theis_keine_bullet_slow', 0, 0, 300, 80)
	-----------------------------------------
	LoadImageFromFile('native_theis_keine_support', path .. 'keine_support.png')
	-----------------------------------------
	LoadImageFromFile('native_theis_mokou_bomb1', path .. "mokou_bomb1.png")
	LoadImageFromFile('native_theis_mokou_bomb2', path .. "mokou_bomb2.png")
	LoadImageFromFile('native_theis_mokou_bomb3', path .. "mokou_bomb3.png")
	LoadImageFromFile("native_theis_keine_bomb1", path .. "keine_bomb1.png")
	LoadImageFromFile("native_theis_keine_bomb2", path .. "keine_bomb2.png")
	LoadImageFromFile("native_theis_keine_bomb3", path .. "keine_bomb3.png")
	--慧音新雷
	LoadTexture('native_theis_keine_bomb_eff', path .. 'keine_bomb_eff.png')
	LoadAnimation("native_theis_keine_bomb_eff", "native_theis_keine_bomb_eff", 0, 0, 256, 256, 11, 1, 6)
	LoadImageFromFile('native_theis_keine_flow_light', "res/effect/flow_light.png") -- 特殊路径
end

--妹红&慧音开枪情况(fire变量为0时代表不开枪
local fire_init, fire_shot, fire_frame
do
	function fire_init(self)
		self.mokou_max_next_shoot = int(6 / self.attack_speed) --主炮攻击间隔(会受攻速影响）
		self.mokou_next_shoot = self.mokou_max_next_shoot --主炮攻击计时器
		self.mokou_max_next_bomb = int(9 / self.attack_speed) --起爆符攻击间隔(会受攻速影响）
		self.mokou_next_bomb = self.mokou_max_next_bomb --起爆符攻击计时器
		self.keine_max_next_shoot = int(6 / self.attack_speed)
		self.keine_next_shoot = self.keine_max_next_shoot
	end
	function fire_shot(self)
		if self.lock_player_shoot <= 0 then
			if self.slow == 0 then
				if self.mokou_next_shoot == 0 then
					--主炮攻击
					PlaySound('plst00', 0.05, self.x / 1024)
					New(mokou_main, 'native_theis_mokou_main', self.x + 8, self.y, 10, 90, 1)
					New(mokou_main, 'native_theis_mokou_main', self.x - 8, self.y, 10, 90, 1)
					self.mokou_next_shoot = self.mokou_next_shoot + self.mokou_max_next_shoot
				end
				if self.mokou_next_bomb == 0 then
					--起爆符札攻击
					New(mokou_bomb_shooter, self)
					self.mokou_next_bomb = self.mokou_next_bomb + self.mokou_max_next_bomb
				end
			else
				if self.keine_next_shoot == 0 then
					--主炮攻击
					PlaySound('plst00', 0.05, self.x / 1024)
					New(keine_bullet_shooter, self)
					self.keine_next_shoot = self.keine_next_shoot + self.keine_max_next_shoot
				end
			end
		end
	end
	function fire_frame(self)
		if self.slow == 0 then --放雷无法射击
			--切换之后主炮也要等攻击间隔f才能攻击
			self.mokou_next_shoot = max(0, self.mokou_next_shoot - 1)
			self.keine_next_shoot = self.keine_max_next_shoot
		elseif self.slow == 1 then
			self.mokou_next_shoot = self.mokou_max_next_shoot
			self.keine_next_shoot = max(0, self.keine_next_shoot - 1)
		end
		self.mokou_next_bomb = max(0, self.mokou_next_bomb - 1) --没错！妹红的起爆符札攻击不会因为高低切而被重置计时，你甚至可以不断高低切打炮
		self.mokou_max_next_shoot = int(6 / self.attack_speed) --更新主炮攻击间隔(会受攻速影响）
		self.mokou_max_next_bomb = int(9 / self.attack_speed) --更新起爆符攻击间隔(会受攻速影响）
		self.keine_max_next_shoot = int(6 / self.attack_speed) --更新低速
	end
end

theis_mokou_player = Class(player_class)
function theis_mokou_player:init(slot)
	load_res()
	-----------------------------------------
	player_class.init(self)
	self.vscale = 0.5 * player_scale
	self.hscale = 0.5 * player_scale
	self.name = "Mokou/Keine"
	self.hspeed = 5
	self.lspeed = 2
	self.imgs = {}
	self.A = 1
	self.B = 1
	for i = 1, 24 do
		self.imgs[i] = 'native_theis_mokou_player' .. i
	end
	--self.keinedelay = 0  --由低速切成高速时，慧音使魔存在情况
	--self.sphx={-36,-16,16,36}
	--self.sphy={0,36,36,0}
	--self.splx={-21,-7,7,21}
	--self.sply={32,32,32,32}
	--self.spx={-25,-18,18,25}
	--self.spy={20,30,30,20}
	self.shift = 1 --用于切换状态过程中的比率参数（妹红为1，慧音为0，转化时会均匀变化）
	self.high_sp = { { -36, 0 }, { -16, 36 }, { 16, 36 }, { 36, 0 } }
	self.slow_sp = { { -36, -20 }, { -25, 30 }, { 25, 30 }, { 36, -20 } }

	fire_init(self)
	self.check = 32
end
-------------------------------------------------------
function theis_mokou_player:shoot()
	fire_shot(self)
end
-------------------------------------------------------
local keine_bomb_main --声明慧音雷主对象
function theis_mokou_player:spell()
	if self.slow == 0 then
		PlaySound("cat00")
		New(player_board_ch, 0, 255, 255, 180)
		New(mokou_bomb_a, self.x, -600, self)
		self.hspeed = 1.5
		self.nextspell = 180
		self.lock_player_shoot = self.nextspell  --射击锁定
		self.lock_player_shift = self.nextspell  --切换锁定
		self.protect = math.max(self.nextspell + 120, self.protect) --无敌时间延长2s
	else
		PlaySound("cat00")
		New(player_board_ch, 255, 255, 0, 300)
		New(keine_bomb_main)
		self.nextspell = 420
		self.lock_player_shift = self.nextspell - 120  --切换锁定提前2s解除
		self.protect = math.max(self.nextspell, self.protect)
	end
end
-------------------------------------------------------
function theis_mokou_player:render()
	local t = (int(self.timer / 3) + 1) % 20 + 1
	--妹红子机渲染
	if self.shift > 0 then
		local rate = self.shift
		SetImageState('native_theis_mokou_support' .. t, '', Color(255 * rate, 255, 255, 255))
		for i = 1, 4 do
			Render('native_theis_mokou_support' .. t, self.x + self.high_sp[i][1] * rate, self.y + self.high_sp[i][2] * rate, 0, 0.5 * player_scale)
		end
	end
	--慧音子机渲染
	if self.shift < 1 then
		local rate = (1 - self.shift)
		SetImageState('native_theis_keine_support', '', Color(255 * rate, 255, 255, 255))
		for i = 1, 4 do
			Render('native_theis_keine_support', self.x + self.slow_sp[i][1] * rate, self.y + self.slow_sp[i][2] * rate, 0, 0.8 * player_scale)
		end
	end
	player_class.render(self)
end
-------------------------------------------------------
function theis_mokou_player:frame()
	player_class.frame(self)
	--高低切形态
	if self.slow == 0 then
		for i = 1, 24 do
			self.imgs[i] = 'native_theis_mokou_player' .. i
		end
		self.shift = min(self.shift + 1 / 6, 1)
	else
		for i = 1, 24 do
			self.imgs[i] = 'native_theis_keine_player' .. i
		end
		self.shift = max(self.shift - 1 / 6, 0)
	end
	fire_frame(self)
end
-------------------------------------------------------
mokou_main = Class(object)

function mokou_main:init(img, x, y, v, angle, dmg, _groups)
	self.group = GROUP_PLAYER_BULLET
	self.layer = LAYER_PLAYER_BULLET
	self.img = img
	self.x = x
	self.y = y
	self.rot = angle
	self.vx = v * cos(angle)
	self.vy = v * sin(angle)
	self.dmg = dmg
	local s = 0.75 * player_scale
	self.hscale = s
	self.vscale = self.hscale
	self.a = 24 * s / player_scale
	self.b = 10 * s / player_scale
	self.rect = true
	self._groups = _groups
end
function mokou_main:kill()
	New(mokou_main_ef, self.x, self.y, self.img)
	if self._groups and self.dmg > 0 then
		if (self._groups.total_dmg > self._groups.max_dmg - self.dmg) and (self._groups.total_dmg < self._groups.max_dmg) then
			for _, o in ipairs(self._groups.child) do
				o.dmg = self._groups.max_dmg - self._groups.total_dmg
			end
		elseif (self._groups.total_dmg >= self._groups.max_dmg) then
			for _, o in ipairs(self._groups.child) do
				o.dmg = 0
			end
		end
		self._groups.total_dmg = self._groups.total_dmg + self.dmg --累计伤害
	end
end

mokou_main_ef = Class(object)

function mokou_main_ef:init(x, y, img)
	self.x = x
	self.y = y
	self.rot = 90
	self.img = img .. '_ef'
	self.layer = LAYER_PLAYER_BULLET + 50
	self.group = GROUP_GHOST
	self.vy = 1
	local s = 0.75 * player_scale
	self.hscale = s
	self.vscale = self.hscale
end
function mokou_main_ef:frame()
	if self.timer == 14 then
		Del(self)
	end
end
function mokou_main_ef:render()
	SetAnimationState(self.img, 'mul+add', Color(255 - 120 * self.timer / 15, 255, 255 - 120 * self.timer / 15, 255 - 120 * self.timer / 15))
	object.render(self)
end
-------------------------------------------------------
mokou_bomb_shooter = Class(object)
function mokou_bomb_shooter:init(master)
	self.count = 0
	self.child = {}
	local angle = { 90, 90, 90, 90 }
	local sp = -3
	for _ = 1, 4 do
		for i = 1, 4 do
			table.insert(self.child, New(mokou_bomb_shoot, master.x + master.high_sp[i][1], master.y + master.high_sp[i][2], angle[i] + sp, master, self))
		end
		sp = sp + 2
	end
end
function mokou_bomb_shooter:frame()
	--当这一轮弹幕全部不存在时，删除自己
	local flag = true
	for i = 1, #self.child do
		if IsValid(self.child[i]) then
			flag = false
		end
	end
	if flag then
		Del(self)
	end
end

mokou_bomb_shoot = Class(object)
function mokou_bomb_shoot:init(x, y, rot, master, _groups)
	self.group = GROUP_GHOST
	self.layer = LAYER_PLAYER_BULLET + 1
	self.img = 'native_theis_mokou_bomb_shoot'
	self.x = x
	self.y = y
	self.rot = rot
	self.vx = 16 * cos(rot)
	self.vy = 16 * sin(rot)
	self.master = master
	local s = 1.25
	self.hscale = s
	self.vscale = s
	self.a = self.a * s
	self.b = self.b * s
	self.flag = 1

	self._groups = _groups --自己的组（包含同一排弹幕
	self.dmg = 2.05
end
local function isBossClass(u)
	-- 查找特殊标记
	if u._private_type_boss then
		return true
	end
	-- 匹配类
	local cls = u.class
	while cls do
		if cls == boss then
			return true
		else
			cls = cls.base -- 找你妈的祖宗
		end
	end
	return false
end
local function dmageBoss(o, self, rate)
	rate = rate or 1
	local a, r = Angle(o, self), min(0.85 * (o.a + o.b) / 2, Dist(self, o))
	New(mokou_spread, o.x + r * cos(a), o.y + r * sin(a), 0.15) --继续削
	--同一组的弹幕击中boss超过6个，剩下的将没有伤害
	if self._groups.count and self._groups.count <= 6 then
		enemybase.damage(o, self.dmg * rate)
		self._groups.count = self._groups.count + 1
	else
		enemybase.damage(o, 0)
	end
end
function mokou_bomb_shoot:frame()
	local target = nil
	for _, o in ObjList(GROUP_NONTJT) do
		if o.colli and self.flag == 1 then
			if isBossClass(o) and Dist(self, o) <= 16 + o.a then
				--如果是boss的话就直接爆炸并且造成额外伤害
				dmageBoss(o, self)
				Del(self)
			elseif (o._type and Dist(self, o) <= 24 + o.a) then
				--大怪吸附的判定范围比小怪要大得多，这样大多时候可以优先吸附大怪
				target = o
				break
			elseif o.Isbacklight and Dist(self, o) <= (o.a + o.b) / 2 then
				dmageBoss(o, self, 1)
				Del(self)
			end
		end
	end
	for i, o in ObjList(GROUP_ENEMY) do
		if isBossClass(o) and o.colli and Dist(self, o) <= 60 then
			--如果是boss的话就直接爆炸并且造成额外伤害
			dmageBoss(o, self)
			Del(self)
		end
		if o.colli and self.flag == 1 then
			if (o._type and Dist(self, o) <= 60) then
				--大怪吸附的判定范围比小怪要大得多，这样大多时候可以优先吸附大怪
				target = o
				break
			elseif (not o._type and Dist(self, o) <= 16) then
				--要是先有小怪比大怪符合条件，也不会立即跳出循环，并继续遍历
				target = o
			end
		end
	end
	if IsValid(target) and not isBossClass(target) and not target.Isbacklight then
		--遍历一遍下来，如果有target就执行吸附
		New(mokou_bomb_ready, self.x, self.y, Angle(self, target), target, self.master)
		self.flag = 0
		Del(self)
	end
end

mokou_bomb_ready = Class(object)
function mokou_bomb_ready:init(x, y, rot, target, master)
	self.bound = false
	self.layer = LAYER_PLAYER_BULLET + 2
	self.img = 'native_theis_mokou_bomb_ready'
	self.x = x
	self.y = y
	self.rot = rot + ran:Float(-5, 5)
	self.target = target
	self.master = master
	local s = 1.2
	self.hscale = s
	self.vscale = s
	self.a = self.a * s
	self.b = self.b * s
	local r = ran:Float(0.75, 1.25)
	self._dx = r * target.a * cos(rot + 180)
	self._dy = r * target.b * sin(rot + 180)
	--给吸附目标计数
	if not target.bomb_count then
		target.bomb_count = 1
	else
		target.bomb_count = target.bomb_count + 1
	end
	--贴满了直接显示红色
	if target.bomb_count >= 12 * (target.hp / target.maxhp) then
		_object.set_color(self, "", 255, 255, 100, 100)
	else
		_object.set_color(self, "", 255, 255, 255, 255)
	end
end

function mokou_bomb_ready:frame()
	if IsValid(self.target) then
		self.x = self.target.x + self._dx
		self.y = self.target.y + self._dy
	else
		Kill(self)
	end
	if self.master.slow == 1 or self.timer >= 600 then
		Kill(self)
	end

	--暂定贴满12个符札就能秒杀
	local target = self.target
	if target.bomb_count and target.bomb_count >= 12 * (target.hp / target.maxhp) then
		self._g, self._b = max(0, self._g - 10), max(0, self._b - 10)
	end
end
function mokou_bomb_ready:render()
	SetAnimationState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
	RenderAnimation(self.img, self.timer, self.x, self.y, self.rot, self.hscale, self.vscale)
end
function mokou_bomb_ready:kill()
	--[[if IsValid(self.target) then
		New(mokou_spread,self.target.x,self.target.y,0.25)
	else
		New(mokou_spread,self.x,self.y,0.25)
	end]]
	if IsValid(self.target) then
		self.target.hp = self.target.hp - self.target.maxhp / 12
	end
	New(mokou_spread, self.x, self.y, 0.25)
end

mokou_spread = Class(object)
function mokou_spread:init(x, y, dmg)
	self.group = GROUP_GHOST
	self.layer = LAYER_PLAYER_BULLET + 50
	self.img = 'native_theis_mokou_spread'
	self.x = x
	self.y = y
	self.rot = ran:Float(0, 360)
	self.killflag = 1
	self.dmg = dmg
	self.a, self.b = 16, 16
	PlaySound('explode', 0.5)
end
function mokou_spread:frame()
	if self.timer == 17 then
		Del(self)
	end
end
--[[function mokou_spread:colli(o)
	if o.group == GROUP_ENEMY or o.group == GROUP_NONTJT  then
		enemybase.damage(o, self.dmg)
	end
end]]

-------------------------------------------------------
keine_bullet_shooter = Class(object)
function keine_bullet_shooter:init(master)
	self.total_dmg = 0  --合计伤害值
	--关于最大伤害值判断
	self.max_dmg = 9999
	do
		local flag = false
		for _, o in ObjList(GROUP_ENEMY) do
			if o.class.base == boss or o.Isbacklight then
				self.max_dmg = 9 --设置最大伤害值(120/60*6)
				flag = true
				break
			end
		end
		for _, o in ObjList(GROUP_NONTJT) do
			if o.class.base == boss or o.Isbacklight or flag then
				self.max_dmg = 9 --设置最大伤害值
				break
			end
		end
	end
	self.child = {}
	local angle = { 101, 90, 90, 79 }
	--正面主炮+中间两子机攻击
	for u = -1, 1, 2 do
		table.insert(self.child, New(mokou_main, 'native_theis_keine_main2', master.x + 8 * u, master.y, 12, 90, 3, self))
	end
	for i = 2, 3 do
		table.insert(self.child, New(mokou_main, 'native_theis_mokou_main', master.x + master.slow_sp[i][1], master.y + master.slow_sp[i][2], 12, angle[i], 4, self))
	end
	--侧边两子机攻击
	for i = 1, 4, 3 do
		for j = -3, 3, 2 do
			table.insert(self.child, New(keine_bullet, master.x + master.slow_sp[i][1], master.y + master.slow_sp[i][2], 10, angle[i] + 3 * j, 3, self))
		end
	end
end
function keine_bullet_shooter:frame()
	mokou_bomb_shooter.frame(self)
end
keine_bullet = Class(object)
function keine_bullet:init(x, y, v, angle, dmg, _groups)
	self.group = GROUP_PLAYER_BULLET
	self.layer = LAYER_PLAYER_BULLET
	self.img = 'native_theis_keine_main'
	self.x = x
	self.y = y
	self.rot = angle
	self.vx = v * cos(angle)
	self.vy = v * sin(angle)
	self.dmg = dmg --这里得另起炉灶了
	local s = 0.6 * player_scale
	self.hscale = s
	self.vscale = s
	self.a = 24 * s / player_scale
	self.b = 14 * s / player_scale
	if self.a ~= self.b then
		self.rect = true
	end
	self._groups = _groups
end
function keine_bullet:kill()
	New(keine_bullet_ef, self.x, self.y + 45)
	if self._groups and self.dmg > 0 then
		if (self._groups.total_dmg > self._groups.max_dmg - self.dmg) and (self._groups.total_dmg < self._groups.max_dmg) then
			for _, o in ipairs(self._groups.child) do
				o.dmg = self._groups.max_dmg - self._groups.total_dmg
			end
		elseif (self._groups.total_dmg >= self._groups.max_dmg) then
			for _, o in ipairs(self._groups.child) do
				o.dmg = 0
			end
		end
		self._groups.total_dmg = self._groups.total_dmg + self.dmg --累计伤害
	end
end
-------------
keine_bullet_ef = Class(object)
function keine_bullet_ef:init(x, y)
	self.x = x
	self.y = y
	self.rot = ran:Float(0, 360)
	self.img = 'native_theis_keine_sup_ef'
	self.layer = LAYER_PLAYER_BULLET + 50
	self.group = GROUP_GHOST
	local s = 1 * player_scale
	self.hscale = s
	self.vscale = self.hscale
end
function keine_bullet_ef:frame()
	if self.timer == 15 then
		Del(self)
	end
	self.hscale = self.hscale + 0.1
	self.vscale = self.vscale + 0.1
end
function keine_bullet_ef:render()
	SetImageState(self.img, 'mul+add', Color(200 - 200 * self.timer / 15, 255, 255, 255))
	object.render(self)
end
-------------------------------------------------------
keine_bomb_c = Class(object)
function keine_bomb_c:init(_x, _y, vh, x, a1)
	self.x, self.y = _x, _y
	self.img = "native_theis_keine_bomb3"
	self.layer = LAYER_ENEMY_BULLET_EF - 1
	self.bound = false
	SetImageState(self.img, "mul+add", Color(30, 0, 100, 200))
	self.vscale = 0
	self.hscale = 0
	self.rot = a1
	self.omiga = 1.5 * x
	task.New(self, function()
		do
			local x, _d_x = (0), (90 / 29)
			for _ = 1, 30 do
				self.vscale = vh * sin(x) * player_scale
				self.hscale = vh * sin(x) * player_scale
				task.Wait(1)
				x = x + _d_x
			end
		end
		do
			local vh1, _d_vh1 = (vh), (0.5 / 49)
			for _ = 1, 15 do
				self.vscale = vh1 * player_scale
				self.hscale = vh1 * player_scale
				task.Wait(1)
				vh1 = vh1 + _d_vh1
			end
		end
		Del(self)
	end)
end
keine_bomb_b = Class(object)
function keine_bomb_b:init(_x, _y, v1, a1, vh1)
	self.x, self.y = _x, _y
	self.img = "native_theis_keine_bomb2"
	self.layer = LAYER_PLAYER_BULLET + 1
	self.bound = false
	self.vscale = vh1 * player_scale
	self.hscale = vh1 * player_scale
	self.omiga = -25
	SetV2(self, v1, a1, false, false)
	SetImageState(self.img, "mul+add", Color(0, 255, 255, 255))
	task.New(self, function()
		_set_a(self, 0.1, 90, false)
		do
			local alp, _d_alp = (0), (255 / 20)
			for _ = 1, 20 do
				task.Wait(1)
				alp = alp + _d_alp
			end
		end
		do
			local vh, _d_vh = (vh1), (-vh1 / 20)
			for _ = 1, 20 do
				self.vscale = vh * player_scale
				self.hscale = vh * player_scale
				task.Wait(1)
				vh = vh + _d_vh
			end
		end
		Del(self)
	end)
end
function keine_bomb_b:render()
	if self.timer <= 20 then
		SetImageState(self.img, "mul+add", Color(255 - self.timer * 255 / 20, 255, 255, 255))
	end
	object.render(self)
end
keine_bomb_a = Class(object)
function keine_bomb_a:init(_x, _y, vh, x, a1)
	self.x, self.y = _x, _y
	self.img = "native_theis_keine_bomb1"
	self.layer = LAYER_ENEMY_BULLET_EF + 1
	self.bound = false
	SetImageState(self.img, "mul+add", Color(255, 0, 0, 255))
	self.vscale = 0
	self.hscale = 0
	self.rot = a1
	self.omiga = -1.5 * x
	task.New(self, function()
		do
			local x, _d_x = (0), (90 / 29)
			local RGB, _d_RGB = (0), (255 / 29)
			for _ = 1, 30 do
				self.vscale = vh * sin(x) * player_scale
				self.hscale = vh * sin(x) * player_scale
				SetImageState(self.img, "mul+add", Color(255, RGB, RGB, RGB))
				task.Wait(1)
				x = x + _d_x
				RGB = RGB + _d_RGB
			end
		end
		task.Wait(30)
		do
			local x, _d_x = (0), (90 / 49)
			local RGB, _d_RGB = (255), (-255 / 49)
			local vh1, _d_vh1 = (vh), (0.5 / 49)
			for _ = 1, 50 do
				self.vscale = vh1 * player_scale
				self.hscale = vh1 * player_scale
				SetImageState(self.img, "mul+add", Color(255, RGB, RGB, RGB))
				task.Wait(1)
				x = x + _d_x
				RGB = RGB + _d_RGB
				vh1 = vh1 + _d_vh1
			end
		end
		Del(self)
	end)
end
function keine_bomb_a:frame()
	task.Do(self)
end
function keine_bomb_b:frame()
	task.Do(self)
end
function keine_bomb_c:frame()
	task.Do(self)
end
keine_bomb_dmg = Class(object)
function keine_bomb_dmg:init()
	self.x = 0
	self.y = 0
	self.a = 900
	self.b = 900
	self.bound = false
	self.group = GROUP_SPELL
	self.killflag = 1
	self.dmg = 1.83
end
function keine_bomb_dmg:frame()
	if self.timer == 298 then
		Del(self)
	end
end
function keine_bomb_dmg:colli(o)
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

local keine_bomb1 = Class(object)
function keine_bomb1:init(x, y, u, s)
	self.x, self.y = x, y
	self.layer = LAYER_ENEMY - 1
	self.group = GROUP_SPELL --符卡类
	self.hscale, self.vscale = 0, 0
	self.a, self.b = 45*s, 45*s
	self.img = "native_theis_keine_bomb_eff"
	_object.set_color(self, "mul+add", 255, 50, 50, 50)
	self.omiga = 6*u
	self.rot = ran:Float(0, 360)
	self.dmg = 0.125
	self.bound = false
	task.New(self, function()
		local d, ds = 205/60, s/60
		for _ = 1, 60 do
			--self.dmg = self.dmg + d
			self._r, self._g, self._b = self._r + d, self._g + d, self._b + d
			self.hscale, self.vscale = self.hscale + ds, self.vscale + ds
			self.a, self.b = 45*self.hscale, 45*self.vscale
			task.Wait(1)
		end
		Del(self)
		task.Wait(180)
		self.bound = true
	end)
end
function keine_bomb1:frame()
	task.Do(self)
end
function keine_bomb1:render()
	SetAnimationState(self.img, "mul+add", Color(255, self._r, self._g, self._b))
	RenderAnimation(self.img, self.timer, self.x, self.y, self.rot, self.hscale, self.vscale)
end
function keine_bomb1:colli(o)
	if o.group == GROUP_ENEMY_BULLET then
		Kill(o)
	elseif o.group == GROUP_NONTJT or o.group == GROUP_ENEMY then
		enemybase.damage(o, self.dmg)
	end
end

keine_bomb_main = Class(object)
function keine_bomb_main:init()
	self.group = GROUP_GHOST
	_object.set_color(self, "", 0, 255, 255, 255)
	task.New(self, function()
		egg.SimAlpCh(self, 0, 255, 60)
		local u = 1
		for _ = 1, 5 do
			for i = 12, 1, -1 do
				New(keine_bomb1, 0, 0, u, 1 + 1*i)
				u = -u
				task.Wait(5)
			end
		end
		egg.SimAlpCh(self, 255, 0, 60)
		task.Wait(60)
		Del(self)
	end)
end
function keine_bomb_main:frame()
	task.Do(self)
end
function keine_bomb_main:render()
	--顶层减法+极坐标
	EISlib.Render.RenderTexturePolarRing("native_theis_keine_flow_light", "mul+add", Color(self._a, 255, 255, 255),
			0, 0,
			0, 400,
			0, 60, 2,
			(self.timer * 0.02) % 1)
end


-------------------------------------------------------
mokou_bomb_a = Class(object)
function mokou_bomb_a:init(_x, _y, master)
	self.x = _x
	self.y = _y
	self.img = 'native_theis_mokou_bomb1'
	self.layer = LAYER_ENEMY - 60
	self.group = GROUP_SPELL
	self.bound = false
	self.dmg = 24
	self.killflag = 1
	self.a = 0
	self.b = 0
	self.hscale = player_scale
	self.vscale = self.hscale
	self.rect = true
	SetImageState(self.img, "", Color(255, 255, 255, 255))
	task.New(self, function()
		do
			for _ = 1, 35 do
				New(mokou_bomb_c1, master.x + ran:Float(-20, 20), master.y + 10, ran:Float(0.8, 1))
				task.Wait(4)
			end
		end
	end)
	task.New(self, function()
		task.Wait(75)
		do
			for _ = 1, 15 do
				New(mokou_bomb_d, ran:Float(-192, 192), -270, ran:Float(0.8, 1))
				task.Wait(5)
			end
		end
	end)
	task.New(self, function()
		task.Wait(45)
		self.x = master.x
		self.ay = 0.2
		self.a = 300
		self.b = 200
		misc.ShakeScreen(120, 3)
		task.New(self, function()
			task.Wait(30)
			--清理干净一点
			for _ = 1, 105 do
				for _, o in ObjList(GROUP_ENEMY_BULLET) do
					if o.colli then
						Kill(o)
					end
				end
				task.Wait(1)
			end
		end)
		do
			for _ = 1, 30 do
				New(mokou_bomb_c, ran:Float(-200, 200), self.y + ran:Float(-50, 0), ran:Float(0.3, 1.2), ran:Float(0, -180))
				task.Wait(4)
			end
		end
	end)
	task.New(self, function()
		task.Wait(45)
		do
			for _ = 1, 30 do
				New(mokou_bomb_b, self.x, self.y)
				task.Wait(4)
			end
		end
	end)
	task.New(self, function()
		task.Wait(180)
		master.hspeed = 5
		Del(self)
		self.bound = true
	end)
end
function mokou_bomb_a:colli(o)
	if o.group == GROUP_ENEMY_BULLET then
		Kill(o)
	elseif o.group == GROUP_NONTJT or o.group == GROUP_ENEMY then
		enemybase.damage(o, self.dmg)
	end
end
mokou_bomb_b = Class(object)
function mokou_bomb_b:init(_x, _y)
	self.x = _x
	self.y = _y
	self.img = 'native_theis_mokou_bomb2'
	self.layer = LAYER_ENEMY - 61
	self.group = GROUP_PLAYER_BULLET
	self.bound = false
	local a = ran:Float(-70, -110)
	local v = ran:Float(0.1, 0.2)
	self.ax = v * cos(a)
	self.ay = v * sin(a)
	task.New(self, function()
		do
			local alp, _d_alp = (255), (-255 / 100)
			local RGB, _d_RGB = (255), (-200 / 100)
			local vh, _d_vh = (1), (-1 / 100)
			for _ = 1, 100 do
				self.hscale = vh * player_scale
				self.vscale = player_scale--add
				task.Wait(1)
				alp = alp + _d_alp
				RGB = RGB + _d_RGB
				vh = vh + _d_vh
			end
		end
		Del(self)
	end)
end
function mokou_bomb_b:render()
	if self.timer <= 100 then
		SetImageState(self.img, "", Color(255 - self.timer * 255 / 100, 255, 200 - self.timer * 200 / 100, 200 - self.timer * 200 / 100))
	end
	object.render(self)
end
mokou_bomb_c = Class(object)
function mokou_bomb_c:init(_x, _y, vh1, a1)
	self.x = _x
	self.y = _y
	self.img = 'native_theis_mokou_bomb3'
	self.layer = LAYER_ENEMY - 60.1
	self.group = GROUP_PLAYER_BULLET
	self.vscale = vh1 * player_scale
	self.hscale = vh1 * player_scale
	self.bound = false
	local v = ran:Float(0.05, 0.1)
	self.ax = v * cos(a1)
	self.ay = v * sin(a1)
	SetImageState(self.img, "mul+add", Color(255, 255, 255, 255))
	task.New(self, function()
		do
			local RGB, _d_RGB = (255), (-200 / 90)
			local vh, _d_vh = (vh1), (-vh1 / 90)
			for _ = 1, 90 do
				self.vscale = vh * player_scale
				self.hscale = vh * player_scale
				task.Wait(1)
				RGB = RGB + _d_RGB
				vh = vh + _d_vh
			end
		end
		Del(self)
	end)
end
function mokou_bomb_c:render()
	if self.timer <= 90 then
		SetImageState(self.img, "", Color(255, 255, 255 - self.timer * 200 / 90, 255 - self.timer * 200 / 90))
	end
	object.render(self)
end
mokou_bomb_d = Class(object)
function mokou_bomb_d:init(_x, _y, a1)
	self.x = _x
	self.y = _y
	self.img = 'native_theis_mokou_bomb3'
	self.layer = LAYER_PLAYER + 1
	self.group = GROUP_PLAYER_BULLET
	self.omiga = ran:Float(-0.5, 0.5)
	self.ay = ran:Float(0, 0.2)
	self.vscale = 0.3 * player_scale
	self.hscale = 1 * player_scale
	self.bound = false
	SetImageState(self.img, "mul+add", Color(255, 255, 200, 200))
	task.New(self, function()
		do
			local vh1, _d_vh1 = (0.3), (0.5 / 60)
			local RGB, _d_RGB = (200), (-200 / 60)
			local vh2, _d_vh2 = (1), (0.5 / 60)
			for _ = 1, 60 do
				self.vscale = vh1 * player_scale
				self.hscale = vh2 * player_scale
				task.Wait(1)
				vh1 = vh1 + _d_vh1
				RGB = RGB + _d_RGB
				vh2 = vh2 + _d_vh2
			end
		end
		do
			local alp, _d_alp = (255), (-255 / 30)
			for _ = 1, 30 do
				task.Wait(1)
				alp = alp + _d_alp
			end
		end
		Del(self)
	end)
end
function mokou_bomb_d:render()
	if self.timer <= 60 then
		SetImageState(self.img, "mul+add", Color(255, 255, 200 - self.timer * 200 / 60, 255 - self.timer * 200 / 60))
	elseif self.timer <= 90 then
		SetImageState(self.img, "mul+add", Color(255 - 255 * (self.timer - 60) / 30, 255, 55, 55))
	end
	object.render(self)
end
mokou_bomb_c1 = Class(object)
function mokou_bomb_c1:init(_x, _y, a1)
	self.x = _x
	self.y = _y
	self.img = 'native_theis_mokou_bomb3'
	self.layer = LAYER_PLAYER + 1
	self.group = GROUP_PLAYER_BULLET
	self.omiga = ran:Float(-0.5, 0.5)
	self.ay = 0.1
	self.vscale = 0.3 * player_scale
	self.hscale = 0.1 * player_scale
	self.bound = false
	SetImageState(self.img, "mul+add", Color(255, 255, 255, 255))
	task.New(self, function()
		do
			local vh1, _d_vh1 = (0.3), (-0.1 / 30)
			local RGB, _d_RGB = (255), (-200 / 30)
			local vh2, _d_vh2 = (0.1), (0.1 / 30)
			for _ = 1, 30 do
				SetImageState(self.img, "mul+add", Color(255, 255, RGB, RGB))
				self.vscale = vh1 * player_scale
				self.hscale = vh2 * player_scale
				task.Wait(1)
				vh1 = vh1 + _d_vh1
				RGB = RGB + _d_RGB
				vh2 = vh2 + _d_vh2
			end
		end
		do
			local alp, _d_alp = (255), (-255 / 30)
			for _ = 1, 30 do
				SetImageState(self.img, "mul+add", Color(alp, 255, 55, 55))
				task.Wait(1)
				alp = alp + _d_alp
			end
		end
		Del(self)
	end)
end
function mokou_bomb_c1:render()
	if self.timer <= 30 then
		SetImageState(self.img, "mul+add", Color(255, 255, 255 - self.timer * 200 / 30, 255 - self.timer * 200 / 30))
	elseif self.timer <= 60 then
		SetImageState(self.img, "mul+add", Color(255 - 255 * (self.timer - 30) / 30, 255, 55, 55))
	end
	object.render(self)
end
function mokou_bomb_a:frame()
	task.Do(self)
end
function mokou_bomb_b:frame()
	task.Do(self)
end
function mokou_bomb_c:frame()
	task.Do(self)
end
function mokou_bomb_d:frame()
	task.Do(self)
end
function mokou_bomb_c1:frame()
	task.Do(self)
end
mokou_bomb_dmg = Class(object)
function mokou_bomb_dmg:init()
	self.x = 0
	self.y = 0
	self.a = 900
	self.b = 900
	self.rect = true
	self.bound = false
	self.group = GROUP_SPELL
	self.killflag = 1
	self.dmg = 1
end
function mokou_bomb_dmg:frame()
	if self.timer == 280 then
		Del(self)
	end
end

-------------------------------------------------------
