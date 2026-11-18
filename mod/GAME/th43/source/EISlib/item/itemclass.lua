---=====================================
--- implement of item
--- author: Xiliusha
--- email : Xiliusha@outlook.com
---=====================================

local path = "res/item/"



local max = math.max
local min = math.min
local sin = lstg.sin
local cos = lstg.cos
local New = lstg.New
local Angle = lstg.Angle
local IsValid = lstg.IsValid
local Color = lstg.Color
local SetImageState = lstg.SetImageState
local SetAnimationState = lstg.SetAnimationState
local DefaultRenderFunc = lstg.DefaultRenderFunc
local Render = lstg.Render
local RenderAnimation = lstg.RenderAnimation

local inter = {
    clamp = function(x, lo, hi) return math.max(lo, math.min(x, hi)) end,
    square_convex = function(a, b, k) return a + (b-a)*k*(2-k) end,
    pow = function(a, b, k) return b + (a-b)*k end,
}

-- 普通道具的混合模式和颜色（透明度）
local SI_BLEND = ""
local SI_COLOR_V = Color(255, 255, 255, 255)
-- 消弹点的混合模式和颜色（透明度）
local SM_BLEND = "mul+add"
local SM_COLOR_V = Color(100, 255, 255, 255)
local function GameObjectList(interval)
	local _interval = interval or 64
	local _insert = table.insert
	local _remove = table.remove
	local _IsValid = lstg.IsValid
	---@class helper.GameObjectList
	local ins = {}
	function ins.init()
		local t = lstg.tmpvar[ins] or { _n = 1 }
		lstg.tmpvar[ins] = t
		return t
	end
	function ins.check()
		local t = ins.init()
		for i = #t, 1, -1 do
			if not _IsValid(t[i]) then
				_remove(t, i)
			end
		end
		return t
	end
	function ins.insert(v)
		local t = ins.init()
		-- 每隔一段时间检查一次存活的数量，防止太久没执行到check()导致遍历的对象数量过于庞大
		if t._n % _interval == 0 then
			for i = #t, 1, -1 do
				if not _IsValid(t[i]) then
					_remove(t, i)
				end
			end
		end
		_insert(t, v)
		t._n = t._n + 1
		return t
	end
	return ins
end
local _item_blood_table = GameObjectList()
local _item_power_table = GameObjectList()
local _item_point_table = GameObjectList()

----------------------------------------
--- res

local BLEND_C = "mul+add"
local COLOR_C = Color(96, 255, 255, 255)

local function load_res()
	local S = lstg.ResourceSet.create("EISlib.item", "global")
	S:addTexture("item_texture", path .. "item.png", false)
	S:addTexture("chip_texture", path .. "chip.png", false) --碎片贴图
	S:addTexture("break_texture", path .. "break.png", false) --碎片破裂贴图
	-- red blue green point
	S:addAnimation("item_red", "item_texture", 0, 768, 40, 40, 3, 1, 6)
	S:addSprite("item_red1", "item_texture", 0, 768, 40, 40)
	-- small point
	S:addSprite("item_power", "item_texture", 0, 888, 64, 64)
	S:addSprite("item_power_strengthen", "item_texture", 0, 952, 64, 64)
	S:addSprite("item_power_minor", "chip_texture", 0, 0, 128, 128)
	S:addSprite("item_minor", "item_texture", 128, 888, 64, 64)
	S:addSprite("item_minor_strengthen", "item_texture", 128, 952, 64, 64)
	S:addSprite("item_point", "item_texture", 64, 888, 64, 64)
	S:addSprite("item_point_ui", "item_texture", 64, 888, 64, 64)
	S:addSprite("item_point_strengthen", "item_texture", 64, 952, 64, 64)
	-- life bomb point
	S:addAnimation("item_life_bg", "item_texture", 0, 0, 150, 150, 6, 1, 6)
	S:addAnimation("item_bomb_bg", "item_texture", 0, 150, 150, 150, 6, 1, 6)
	S:setAnimationState("item_life_bg", BLEND_C, COLOR_C)
	S:setAnimationState("item_bomb_bg", BLEND_C, COLOR_C)
	S:addSprite("item_life", "item_texture", 150, 450, 150, 150)
	S:addSprite("item_bomb", "item_texture", 450, 450, 150, 150)
	S:addSprite("item_bomb_chip", "item_texture", 300, 450, 150, 150)
	-- break effect
	S:addAnimation("item_chip_break_eff", "break_texture", 0, 0, 128, 128, 4, 4, 4)
	-- chip
	local values = {1, 2, 3, 6} --命名时根据碎片的价值来作为后缀命名
	local sizes = {"small", "mid", "big", "huge"}
	local tex_name
	for i = 1, 4 do
		tex_name = "item_"..sizes[i].."_chip"
		S:addTexture(tex_name, path .. "chip"..values[i]..".png", false)
		S:addAnimation(tex_name, tex_name, 0, 0, 128, 128, 4, 1, 6)
	end
	-- chip_aura
	S:addTexture("chip_aura_texture", path .. "chip_aura.png", false) --碎片贴图
	S:addSprite("chip_aura", "chip_aura_texture", 0, 0, 128, 128)
	-- max point
	S:addSprite("item_maxpoint", "item_texture", 64, 888, 64, 64)

	S:addSprite("enemy_mid_chip", "chip_texture", 0, 128, 128, 128) --作为有碰撞判定的敌人
end
load_res()

----------------------------------------
--region base item class

local item_fly_controller = {}
item_fly_controller.yspeed = -0.8 -- 默认掉落速度
function item_fly_controller.init(self, x, y, angle, yspeed, fadein, flylen, fcoldt)
	self.timer = 0

	-- 横向位置限制
	self.minx = lstg.world.l
	self.maxx = lstg.world.r
	-- 飞出位置
	self.x = inter.clamp(x, self.minx, self.maxx)
	self.y = y
	-- 原始飞出位置
	self.x0 = self.x
	self.y0 = self.y

	-- 尺寸
	self.size = 1 -- 相对大小
	self.hscale = 0
	self.vscale = 0

	self.angle = angle or 90 -- 飞出时的朝向
	self.cosv = cos(self.angle)
	self.sinv = sin(self.angle)
	self.fadein = fadein or 40 -- 飞出过程的时间
	self.flylen = flylen or 24 -- 飞出的距离
	self.fcoldt = fcoldt or (self.fadein + 4) -- 结束飞出过程后的等待时间

	self.yspeed = yspeed or item_fly_controller.yspeed -- 下落速度

	self.lockt = 0
	self.freet = 0
	self.target = nil -- 追踪对象，一般是由自机的道具收集器设置
	self.attract = 0 -- 追踪速度，一般是由自机的道具收集器设置
end
function item_fly_controller.rotate(self)
	--自旋逻辑
	if self.timer > 0 and self.timer <= 45 then
		self.rot = self.rot + 8
	end
end
function item_fly_controller.update(self)
	local W = lstg.world
	--移动逻辑
	if self.timer <= self.fadein then
		local k = self.timer / self.fadein
		local t = inter.square_convex(0, 1, k) -- 使用二次函数插值能节省一些性能，大概
		-- 设置尺寸
		self.hscale = t * self.size
		self.vscale = self.hscale
		-- 设置位置
		self.x = inter.clamp(self.x0 + self.flylen * t * self.cosv, self.minx, self.maxx) --不能超出横向范围
		self.y = self.y0 + self.flylen * t * self.sinv
	elseif self.timer > self.fcoldt then
		local vx, vy = 0, 0
		local rate = 0
		if self.attract > 0.0001 and IsValid(self.target) then
			-- 设置预期速度
			local a = Angle(self, self.target)
			vx = self.attract * cos(a)
			vy = self.attract * sin(a)
			-- 更新插值参数
			self.freet = 0
			self.lockt = min(self.lockt + 0.005, 1)
			rate = 1 - self.lockt
		else
			-- 设置预期速度
			vx = 0
			vy = self.yspeed
			-- 更新插值参数
			self.freet = min(self.freet + 0.005, 1)
			self.lockt = 0
			rate = 1 - self.freet
			-- 只有自由下落状态才出界消除
			if self.y < W.boundb then
				self.status = "del"
			end
		end
		-- 更新位置
		self.vx = inter.pow(self.vx, vx, rate)
		self.vy = inter.pow(self.vy, vy, rate)
	end
end

local item_base_class = Class(object)
function item_base_class:init(x, y, angle, yspeed, fadein, flylen, fcoldt)
	self.native_pickup = true
	self.group = GROUP_ITEM
	self.layer = LAYER_ITEM
	self.bound = false
	item_fly_controller.init(self, x, y, angle, yspeed, fadein, flylen, fcoldt)
end
function item_base_class:frame()
	item_fly_controller.rotate(self)
	item_fly_controller.update(self)
end
function item_base_class:render()
	SetImageState(self.img, self._blend, self._color)
	Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end
function item_base_class:colli(other)
	if other == player then
		if self.class.collect then
			self.class.collect(self, other)
		end
		PlaySound("item00")
		Del(self)
	elseif other == player._grazer then
		item.collectByTarget(self, player)
	end
end


--endregion
----------------------------------------
--region 残机和雷

-- 绘制方法

local function render_huge_item(self, img1, img2)
	self.rot = 4 * sin(self.ani * 4)
	RenderAnimation(img2, self.ani, self.x, self.y, 0, self.hscale, self.vscale)
	Render(img1, self.x, self.y, self.rot, self.hscale, self.vscale)
	RenderAnimation(img2, self.ani, self.x, self.y, 0, self.hscale, self.vscale)
end

-- 消失特效

local huge_item_collect_eff = Class(object)
function huge_item_collect_eff:init(x, y, img)
	self.x = x
	self.y = y
	self.size = 0.75
	self.hscale = self.size
	self.vscale = self.size
	self.img = "th43/" .. img
	self._BLEND = BLEND_C
	self._COLOR = COLOR_C
end
function huge_item_collect_eff:frame()
	if self.timer <= 60 then
		local k = self.timer / 60
		local scale = self.size + (2 - self.size) * sin(k * 90)
		self.hscale = scale
		self.vscale = scale
		self._COLOR = COLOR_C * (1 - k)
	else
		self.status = "del"
	end
end
function huge_item_collect_eff:render()
	SetAnimationState(self.img, self._BLEND, self._COLOR)
	DefaultRenderFunc(self)
	SetAnimationState(self.img, BLEND_C, COLOR_C) -- 丢，记得恢复
end

-- 残机

local PlayerLife = item.PlayerLife
function PlayerLife:init(x, y)
	item_base_class.init(self, x, y, 90, -1, 26, 32)
	self.size = 0.75
	self.a = 24
	self.b = 24
end
PlayerLife.frame = item_base_class.frame
function PlayerLife:render() render_huge_item(self, "item_life", "item_life_bg") end
function PlayerLife:del() New(huge_item_collect_eff, self.x, self.y, "item_life_bg") end
PlayerLife.colli = item_base_class.colli
function PlayerLife:collect() system.addLife(1) end
function PlayerLife.create(x, y) return lstg.New(PlayerLife, x, y) end

-- 机雷

local PlayerBomb = item.PlayerBomb
function PlayerBomb:init(x, y)
	item_base_class.init(self, x, y, 90, -1, 26, 32)
	self.size = 0.75
	self.a = 24
	self.b = 24
end
PlayerBomb.frame = item_base_class.frame
function PlayerBomb:render() render_huge_item(self, "item_bomb", "item_bomb_bg") end
function PlayerBomb:del() New(huge_item_collect_eff, self.x, self.y, "item_bomb_bg") end
PlayerBomb.colli = item_base_class.colli
function PlayerBomb:collect() system.addBomb(1) end
function PlayerBomb.create(x, y) return lstg.New(PlayerBomb, x, y) end

--endregion
----------------------------------------
--region 血灵碎片

local item_break = Class(object)
function item_break:init(x, y)
	self.layer = LAYER_ITEM + 49
	self.x, self.y = x, y
	self.rot = ran:Float(0, 360)
	self.img = "th43/item_chip_break_eff"
end
function item_break:frame()
	if self.timer >= 63 then
		self.status = 'del'
	end
end

local blood_fly_controller = {}
blood_fly_controller.yspeed = -0.8
function blood_fly_controller.init(self, x, y, vy, dvy) -- vy控制y轴速度，dvy控制y轴加速度
	self.timer = 0

	-- 横向位置限制
	self.minx = -180
	self.maxx = 180
	-- 飞出位置
	self.x = inter.clamp(x, self.minx, self.maxx)
	self.y = y
	-- 原始飞出位置
	self.x0 = self.x
	self.y0 = self.y

	-- 尺寸
	--self.size = 1 -- 相对大小
	--self.hscale = 0
	--self.vscale = 0

	self.yspeed = vy or blood_fly_controller.yspeed -- 最大下落速度（负的最大）
	self.dyspeed = dvy or (self.yspeed / 30) -- 下落加速度

	self.captured = false -- 曾追踪过
	self.lockt = 0
	self.freet = 0
	self.target = nil -- 追踪对象，一般是由自机的道具收集器设置
	self.attract = 0 -- 追踪速度，一般是由自机的道具收集器设置
end
function blood_fly_controller.update(self)
	local W = lstg.world
	local cap = self.attract > 0.0001 and IsValid(self.target)
	if cap then
		self.captured = true
	end
	if not self.captured then
		-- 更新位置
		self.vx = 0
		self.vy = inter.clamp(self.vy + self.dyspeed, self.yspeed, 0)
		self.x = inter.clamp(self.x, self.minx, self.maxx) -- 不能超出横向范围
		if self.y < W.boundb then
			self.status = "del"
		end
	else
		local vx, vy = 0, 0
		local rate = 0
		if cap then
			-- 设置预期速度
			local a = Angle(self, self.target)
			vx = self.attract * cos(a)
			vy = self.attract * sin(a)
			-- 更新插值参数
			self.freet = 0
			self.lockt = min(self.lockt + 0.005, 1)
			rate = 1 - self.lockt
		else
			-- 设置预期速度
			vx = 0
			vy = inter.clamp(self.vy + self.dyspeed, self.yspeed, 0)
			-- 更新插值参数
			self.freet = min(self.freet + 0.005, 1)
			self.lockt = 0
			rate = 1 - self.freet
			-- 只有自由下落状态才出界消除
			if self.y < W.boundb then
				self.status = "del"
			end
		end
		-- 更新位置
		self.vx = inter.pow(self.vx, vx, rate)
		self.vy = inter.pow(self.vy, vy, rate)
		self.x = inter.clamp(self.x, self.minx, self.maxx) -- 不能超出横向范围
	end
end

local _Blood_img = {
	"item_small_chip",
	"item_mid_chip",
	"item_big_chip",
	"item_huge_chip",
}
local _Blood_values = { 1, 2, 3, 6 }
local _Blood_bonus = { 500, 1000, 1500, 3000 }

local Blood = item.Blood

Blood.Small = 1
Blood.Mid = 2
Blood.Big = 3
Blood.Huge = 4

Blood.SIN_list = {}
for i = 0, 360 do
	Blood.SIN_list[i] = sin(i)
end

function Blood:init(x, y, type)
	self.native_pickup = true
	self.group = GROUP_ITEM
	self.layer = LAYER_ITEM
	self.bound = false
	blood_fly_controller.init(self, x, y, Blood.getDropVelocity())

	self.type = type or 1
	self.img = "th43/" .. _Blood_img[self.type]
	self.a = 24
	self.b = 24
	self.no_collect_by_line = true -- 不能被上线收点的方式收集

	_item_blood_table.insert(self)
end
function Blood:frame()
	blood_fly_controller.update(self)
	--增加一条新的设定：在自机放b过程中碎片会被粉碎
	if player_class.isInBomb(player) then
		Kill(self)
	end
end
function Blood:render()
	local t = (5*self.timer)%360
	local SIN = Blood.SIN_list[t]
	SetImageState("chip_aura", "", Color(150 + 30*SIN, 255, 255, 255))
	Render("chip_aura", self.x, self.y, 0, 0.9 + 0.1*SIN, 0.9 + 0.1*SIN)
	DefaultRenderFunc(self)
end
Blood.colli = item_base_class.colli
function Blood:kill() lstg.New(item_break, self.x, self.y) end
function Blood:collect()
	system.collectChip(_Blood_values[self.type])
	local rate = player.chip_bonus_rate or 1
	system.addBonus(_Blood_bonus[self.type] * rate)
end
function Blood.create(x, y, type) return lstg.New(Blood, x, y, type) end

function Blood.setDropVelocity(vy) lstg.tmpvar._item_blood_vy = vy end
function Blood.getDropVelocity() return lstg.tmpvar._item_blood_vy or item_fly_controller.yspeed end
function Blood.getChipCount() return #_item_blood_table.check() end
function Blood.killAllChip()
	for _, chip in ipairs(_item_blood_table.check()) do
		Kill(chip)
	end
end

--endregion
----------------------------------------
--region 火力点

local Power = item.Power
function Power:init(x, y, a, attract, no_insert_to_power_table)
	item_base_class.init(self, x, y, a, Power.getDropVelocity(), 45, 45)
	self.size = 0.5
	self.img = "th43/item_power"
	self.a, self.b = 24, 24
	self._blend = SI_BLEND
	self._color = SI_COLOR_V
	self.max_rate = 99999 --倍率上限
	self.rate = 1.0 --默认倍率
	self.isAttract = false --是否被上线收点、全屏收取道具和Hyper所吸附
	if attract then --生成时是否直接飞向自机
		item.collectByTarget(self, player)
	end
	if not no_insert_to_power_table then
		_item_power_table.insert(self)
	end
end
Power.frame = item_base_class.frame
Power.render = item_base_class.render
Power.colli = item_base_class.colli
function Power:collect() system.collectPower(self.rate) end
function Power.create(x, y, a, attract) return lstg.New(Power, x, y, a, attract) end
function Power:changeToDoubleRate()
	if self.rate < 2.0 and self.max_rate >= 2 then
		self.rate = 2.0
		local a, b = self.a, self.b
		self.img = "th43/item_power_strengthen"
		self.a, self.b = a, b
	end
end

--设置红点下落速度
function Power.setDropVelocity(vy) lstg.tmpvar._item_power_vy = vy end
function Power.getDropVelocity() return lstg.tmpvar._item_power_vy or item_fly_controller.yspeed end
function Power.forEachUnit() return _item_power_table.check() end

--endregion
----------------------------------------
--region 蓝点

local Point = item.Point
function Point:init(x, y)
	-- lstg.tmpvar._item_point_vy 如不为nil，则使用这个值
	item_base_class.init(self, x, y, 90, Point.getDropVelocity(), 45, 45)
	self.size = 0.5
	self.img = "th43/item_point"
	self.a, self.b = 24, 24
	self._blend = SI_BLEND
	self._color = SI_COLOR_V
	self.max_rate = 99999 --倍率上限
	self.rate = 1.0 --默认倍率
	self.isAttract = false --是否被上线收点、全屏收取道具和Hyper所吸附
	self.isIgnorePointRate = true --默认不会受到全局最大得点倍率收益的影响
	_item_point_table.insert(self)
end
Point.frame = item_base_class.frame
Point.render = item_base_class.render
Point.colli = item_base_class.colli
function Point:collect()
	if not self.isAttract then
		self.rate = 0.5 + 0.5*(player.y + 224)/(player.collect_line + 224) --随高度降低倍率，最低为0.5
	end
	local score = system.collectBlue(self.rate, self.isIgnorePointRate)
	effect.GetScoreEffect(self, score)
end
function Point.create(x, y) return lstg.New(Point, x, y) end
function Point:changeToDoubleRate()
	if self.rate < 2.0  and self.max_rate >= 2 then
		self.isAttract = true --标记为被吸附，不计算高度倍率
		self.isIgnorePointRate = false
		self.rate = 2.0
		local a, b = self.a, self.b
		self.img = "th43/item_point_strengthen"
		self.a, self.b = a, b
	end
end

--- 设置蓝点下落速度
function Point.setDropVelocity(vy) lstg.tmpvar._item_point_vy = vy end
function Point.getDropVelocity() return lstg.tmpvar._item_point_vy or item_fly_controller.yspeed end
--- 获取当前存活的蓝点的表
function Point.forEachUnit() return _item_point_table.check() end

--endregion
----------------------------------------
--region 消弹点

-- minor （普通消弹点）
local minor = Class(object)
function minor:init(x, y)
	item_base_class.init(self, x, y, 90, Power.getDropVelocity(), 45, 45)
	self.layer = LAYER_ITEM - 1 -- 渲染图层集中在这里，方便合批渲染提升性能
	self.img = "th43/item_minor"
	self.hscale, self.vscale = 0.4, 0.4
	self.a, self.b = 24, 24
	self._blend = SM_BLEND
	self._color = SM_COLOR_V
	self.size = 0.5
end
minor.frame = item_fly_controller.update -- 小的飞出的时候不需要旋转动画
function minor:collect() system.collectSmall() end

-- TODO: 需要设置同屏最大消弹点上限，不然真的会爆炸！
local PointSmall = item.PointSmall
function PointSmall:init(x, y, a)
	Power.init(self, x, y, a or 90, true, true)
	self.layer = LAYER_ITEM - 1 -- 渲染图层集中在这里，方便合批渲染提升性能
	self.img = "th43/item_power_minor"
	self.a, self.b = 24, 24
	self.size = 1.5
	self.bound = false
	self._blend = SM_BLEND
	self._color = SM_COLOR_V
end
PointSmall.frame = item_fly_controller.update -- 小的飞出的时候不需要旋转动画
PointSmall.render = item_base_class.render
PointSmall.colli = item_base_class.colli
function PointSmall:collect() system.collectSmallPower() end
function PointSmall.create(x, y, a) return lstg.New(PointSmall, x, y, a) end

-- small （消弹点）
function item.changeMinorType(type)
	type = type or 0
	if type == 0 then
		item_faith_minor = minor
	else
		item_faith_minor = item.PointSmall
	end
end
item.changeMinorType(1) --消弹掉出的默认为小p点

--endregion
----------------------------------------
