---=====================================
---东方祈华梦染色系统
---code by S7UPID
---=====================================

---@type EISlib.Enemy
local M = EISlib.Enemy

local path = M.path
local respath = "res/effect/"

local inrange = math.inrange
local clamp = math.clamp
local floor, ceil = math.floor, math.ceil
local min, max = math.min, math.max
local sin, cos = lstg.sin, lstg.cos
local Angle = lstg.Angle
local Dist = lstg.Dist
local ObjList = lstg.ObjList
local Color = lstg.Color
local SetImageState = lstg.SetImageState
local Render = lstg.Render

----------------------------------------
--- res

local imgs = {
	[M.RED] = {},
	[M.BLUE] = {},
	[M.GREEN] = {},
}

local timer_imgs = {
	[M.RED] = {},
	[M.BLUE] = {},
	[M.GREEN] = {},
}

local function load_res()
	local S = lstg.ResourceSet.Find("EISlib.enemy")

	S:AddTexture("_dye_effect_texture", respath .. "dye_effect.png", false)
	S:AddSpriteSequence("_dye_circle_effect_", "_dye_effect_texture", 0, 0, 128, 128, 8, 7)
	for idx = 1, 18 do
		imgs[M.RED][idx] = "_dye_circle_effect_" .. idx
		imgs[M.BLUE][idx] = "_dye_circle_effect_" .. (idx + 18)
		imgs[M.GREEN][idx] = "_dye_circle_effect_" .. (idx + 36)
	end
	for t = 0, 54 do
		local idx = clamp(floor(t / 3) + 1, 1, 18)
		timer_imgs[M.RED][t] = "_dye_circle_effect_" .. idx
		timer_imgs[M.BLUE][t] = "_dye_circle_effect_" .. (idx + 18)
		timer_imgs[M.GREEN][t] = "_dye_circle_effect_" .. (idx + 36)
	end
	S:AddSpriteSequence("_dye_drop_effect_", "_dye_effect_texture", 0, 960, 64, 64, 3, 1)


	S:AddTexture("_color_effect_texture", respath .. "color_effect.png", false)
	S:AddAnimation("enemy_color_red", "_color_effect_texture", 0, 0, 128, 128, 7, 1, 8)
	S:AddAnimation("enemy_color_blue", "_color_effect_texture", 0, 128, 128, 128, 7, 1, 8)
	S:AddAnimation("enemy_color_green", "_color_effect_texture", 0, 256, 128, 128, 7, 1, 8)
	S:AddSpriteSequence("black_circle", "_color_effect_texture", 0, 514, 16, 114, 32, 1)
	S:AddSpriteSequence("white_circle", "_color_effect_texture", 0, 630, 16, 114, 32, 1)

	S:AddTexture("_flowing_light_texture", respath .. "flow_light.png", false)
	S:AddTexture("_surrounding_light_texture", respath .. "surrounding_light.png", false)
	S:AddSprite("_surrounding_light", "_surrounding_light_texture", 0, 0, 512, 512)
end
load_res()

----------------------------------------
--- effect

--染到怪身上时的效果
local dye_eff = Class(object)
function dye_eff:init(x, y, target, _r, _g, _b)
	self.target = target
	self.img = "_dye_drop_effect_1"
	self.x, self.y = x, y
	self.angle = ran:Float(0, 360)
	_object.set_color(self, "", 255, _r or 255, _g or 255, _b or 255)
	self.size = 0.5
	task.New(self, function ()
		local ds, d_a = 0.5/30, -255/30
		for _ = 1, 30 do
			if IsValid(target) then
				self.x, self.y = target.x, target.y
			end
			self.size = self.size + ds
			self._a = self._a + d_a
			task.Wait(1)
		end
		Del(self)
	end)
end
function dye_eff:frame()
	task.Do(self)
end
function dye_eff:render()
	SetImgState(self, "", self._a, self._r, self._g, self._b)
	Render(self.img, self.x, self.y, self.angle, 1.5*self.size)
end

dye_fly_to_enemy = Class(object)
function dye_fly_to_enemy:init(x, y, o)
	--这里的o是一个小怪单位
	self.bound = false
	self.img = "img_void"
	self.x = x
	self.y = y
	self.angle = 0
	self.target = o
	self.flag = 0 --当flag为1时表明已经命中目标或者目标消失，准备变换素材，并启动消失计时器
	self._a = 150
	if self.target.sys_co == 1 then
		self._r = 255
		self._g = 0
		self._b = 0
	elseif self.target.sys_co == 2 then
		self._r = 0
		self._g = 0
		self._b = 255
	elseif self.target.sys_co == 3 then
		self._r = 0
		self._g = 255
		self._b = 0
	else
		self._r = 255
		self._g = 255
		self._b = 255
	end
	if IsValid(o) then
		self.angle = Angle(o.x, o.y, x, y) + ran:Float(-10, 10)--初角度
	end
    local _trail = New(egg.trail, self, 10, 1, "_dye_drop_effect_"..ran:Int(2, 3), 0.75, "", nil, nil, true)
	_trail.co = {self._r, self._g, self._b}
end
function dye_fly_to_enemy:frame()
	if IsValid(self.target) then
		self.angle = Angle(self, self.target)
		local d = Dist(self, self.target)
		if d <= 10 then
			self.vx, self.vy = 0, 0
			self.flag = 1
		else
			local v = max(3, d/10)
			self.vx, self.vy = self.target.vx + v*cos(self.angle), self.target.vy + v*sin(self.angle)
		end
	else
		self.flag = 1 --要是目标中途消失了，那自己就在原地慢慢消失
	end
	if self.flag == 1 then
		New(dye_eff, self.x, self.y, self.target, self._r, self._g, self._b)
		Del(self)
	end
end

local dye_straighly_fly_to_enemy = Class(dye_fly_to_enemy)

function dye_straighly_fly_to_enemy:init(x, y, o)
	dye_fly_to_enemy.init(self, x, y, o)
	self.v = self.v or 0
	self.angle = self.angle + 180 --初始生成角度由反向改为正向
	self._p = 0
end

function dye_straighly_fly_to_enemy:frame()
	if IsValid(self.target) then
		if self.flag == 0 then
			self.v = min(10, self.v + 2)
			--更新诱导
			self._p = min(1, self._p + 1 / 30)
			local _aa = (Angle(self.x, self.y, self.target.x, self.target.y) - self.angle) % 360
			if _aa > 180 then
				_aa = _aa - 360
			end
			if self.boom_flag == 1 then
				self.angle = self.angle
			else
				self.angle = self.angle + _aa * self._p
			end
			if Dist(self.x, self.y, self.target.x, self.target.y) <= 20 then
				Del(self)
			end
			self.x = self.x + self.v * cos(self.angle)
			self.y = self.y + self.v * sin(self.angle)
			--New(dye_particle, self.x, self.y, self.angle + ran:Float(-5, 5) + 180, self._r, self._g, self._b)
		else
			self.x = self.target.x
			self.y = self.target.y --命中目标后就跟随目标了
		end

	else
		Del(self) --要是目标中途消失了，那自己也就消失
	end
end

----------------------------------------
---dye system
---sys_co:颜色;1为黑色（奖励残机），2为白色（奖励分数)
---_type:怪物种类；nil|false为小怪，true为大怪
---没颜色的小怪会被染上颜色，有颜色的小怪会先被染色然后被消灭，并且记数，结算连破分数。

local function Simple_Dye(other, co)
	if (not other._type) and other.colli and (not other._bosssys) then
		--大怪和暂时无判定的怪不被染色
		other.sys_co = co
		other.IsDye = true
	end
end

local function Dye(mst, other, co)
	--大怪和boss不被染色
	local flag = true
	local bosses = boss.GetBossTable()
	for _, o in ipairs(bosses) do --如果是boss的话就直接为false了
		if other == o then
			flag = false
		end
	end
	if flag and other.bonus and (not other._type) and (not other._bosssys) then --  and other.colli
		if other.IsDye then
			--注意是否二重染色！防止同一帧多染
			if not other.double_dye then
				other.sys_co = co -- 染色总是要最先执行
				mst.count = mst.count + other.bonus -- 二重染色计数
				do --计数器增加的操作
					local _co = other.sys_co
					if _co and _co >= 1 and _co <=3 then
						mst.bonus[_co] = mst.bonus[_co] + other._drop_num
					end
					--mst.bonus[4] = mst.bonus[4] + other._nights --也要加上夜点的统计数
				end
				if other.class.dyeKill then
					other.class.dyeKill(other)
				else
					Kill(other)
				end
				other.double_dye = true
			end
		else
			other.IsDye = true
			other.sys_co = co --染色总是要最先执行
			if other.sys_co == 1 then
				other.c_img = "enemy_color_red"
			elseif other.sys_co == 2 then
				other.c_img = "enemy_color_blue"
			elseif other.sys_co == 2 then
				other.c_img = "enemy_color_green"
			end
			New(dye_fly_to_enemy,
					mst.x,
					mst.y,
					other)
			--[[task.New(other, function()
				for i = 60, 1, -1 do
					other.hp = min(other.hp, i / 60 * other.maxhp) --被染色的小怪会被削弱
					task.Wait(1)
				end
			end)]]
		end
	end
end

local function dye_enemys(parent, range, color)
	for _, o in ObjList(GROUP_ENEMY) do
		if Dist(parent.x, parent.y, o.x, o.y) < range then
			Dye(parent, o, color)
		end
	end
	for _, o in ObjList(GROUP_NONTJT) do
		if Dist(parent.x, parent.y, o.x, o.y) < range then
			Dye(parent, o, color)
		end
	end
end

local function clear_bullets(parent, range)
	local count = 0
	local x, y = parent.x, parent.y
	for _, o in ObjList(GROUP_ENEMY_BULLET) do
		local d = Dist(x, y, o.x, o.y)
		if d < range and o.colli then --本身没有判定的弹幕是不会被消掉的
			count = count + 1
			New(wabisabi_item, o.x, o.y, parent.color) --每个弹幕被消除也能获得点
			_del(o, false)
		end
	end
	New(tasker, function()
		for _, o in ObjList(GROUP_ENEMY_BULLET) do
			local d = Dist(x, y, o.x, o.y)
			if d < range and o.colli then --本身没有判定的弹幕是不会被消掉的
				New(wabisabi_item, o.x, o.y, parent.color) --每个弹幕被消除也能获得点
				_del(o, false)
			end
		end
	end)
	return count
end

local Dye_circle = Class(object)

function Dye_circle:init(x, y, co, range, drop)
	if not inrange(co, 1, 3) then
		self.hide = true
		self.status = "del"
		return
	end
	-- basic
	self.x = x
	self.y = y
	self.bound = false
	self.layer = LAYER_ENEMY - 1
	-- system
	self.color = co
	self.size = range / 30
	self.count = 0
	self.bonus = {0, 0, 0, 0} --二重染色总道具计数器，1 2 3数组下标对应颜色奖励，4为夜点，5为最大得点
	if drop then
		for i = 1, 3 do
			if drop[i] then
				self.bonus[i] = self.bonus[i] + drop[i]
			end
		end
	end
	self.bonus[4] = clear_bullets(self, range) -- 消除弹幕并计入夜点
	dye_enemys(self, range, co) -- 对敌人进行染色并计入夜点
	--连破计分(3连起评)
	local score =
			floor(system.getBonus() * self.count), -- getBonus 拿到的是最大得点
			max(-150, min(x, 150)),
			max(-200, min(y, 180)),
			500 * self.count   --目前为最大得点增加的唯一方式，即触发二重染色奖励后每只被消灭的妖精提供500点最大得点
	if self.count >= 3 then
		local ex_points = 6*self.count --根据染色敌方数再额外爆出的消弹点
		self.bonus[4] = self.bonus[4] + ex_points
		if player.nextspell > 0 then
			self.count = 0
		end
		bonus_display(x, y, self.bonus[1], self.bonus[2], self.bonus[3], self.bonus[4], self.count, score, range, co)
		PlaySound("bonus2", 1.0)
		--根据染色敌方数再额外爆出的消弹点
		local x, y, r, a
		for _ = 1, ex_points do
			r, a = ran:Float(0, range), ran:Float(0, 360)
			x, y = self.x + r*cos(a), self.y + r*sin(a)
			New(wabisabi_item, x, y, co)
		end
	else
		bonus_display(x, y, self.bonus[1], self.bonus[2], self.bonus[3], self.bonus[4], 0, 0, range, co)
	end
end

function Dye_circle:frame()
	if self.timer > 53 then
		self.status = "del"
	end
end

function Dye_circle:render()
	local img = timer_imgs[self.color][self.timer]
	if self.timer <= 30 then
		SetImageState(img, "mul+add", Color(60, 255, 255, 255))
	elseif self.timer <= 53 then
		SetImageState(img, "mul+add", Color(60 * (53 - self.timer) / 23, 255, 255, 255))
	end
	Render(img, self.x, self.y, 0, self.size)
end

----------------------------------------
--- out

--- 创建一个染色圈，对圈内的敌人进行染色，并消除子弹转化为夜点
---@param x number
---@param y number
---@param range number
---@param color number
---@param drop table 用于计算额外掉落用的drop表
function M.CreateDyeCircle(x, y, range, color, drop)
	New(Dye_circle,
			x, y, color, range, drop) --产生染色圈，默认范围为半径为50的圆。
end

---该死亡方式不掉落道具，也不结算染色、连击奖励
function noDropKill(unit)
	unit.nodrop = true
	Kill(unit)
end

---当击破一个怪时，可以变改另一个怪的染色范围、削弱hp
function Add_dye_range(o, x, y, _num, _t0, effect, _dmg)
	local num, t0, dnum, dmg
	num, t0, dmg = _num or 0, _t0 or 1, _dmg or 0
	dnum = num / t0
	if effect == true then
		--可以选择是否有飞入特效
		New(dye_straighly_fly_to_enemy, x, y, o)
	end
	if dmg > 0 then
		enemybase.damage(o, dmg)
	end
	task.New(o, function()
		if o.dye_range then
			for _ = 1, t0 do
				o.dye_range = o.dye_range + dnum
				task.Wait(1)
			end
		end
	end)
end
