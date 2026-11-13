---=====================================
---touhou style bent lazer
---=====================================

local GetAttr = lstg.GetAttr
local SetAttr = lstg.SetAttr
local max, min = math.max, math.min
local int = math.floor

local laser_node_img = "preimg"--"laser_node"

----------------------------------------
---bent lazer res

local laser_bent_renderFunc = {}

local laser_bent_renderFuncDeath = {}

local laser_bent_colliEnvelope = {}

---添加曲线激光素材，曲线激光必须横着放，仅一条
---@param id number
---@param tex string
function Add_bentlaser_texture(id, tex)
	local w, h = GetTextureSize(tex)
	---@param self THlib.Object.BentLaser
	laser_bent_renderFunc[id] = function(self)
		self.data:Render(tex, self._blend, Color(self._a * self.alpha, self._r, self._g, self._b), 0, 0, w, h)
		if self.timer < self._l * 4 and self.node then
			local c = Color(self._a, self._r, self._g, self._b)
			SetImageState(self.img4, self._blend, c)
			Render(self.img4, self.prex, self.prey, -3 * self.timer, (8 + self.timer % 3) * 0.125 * self.node / 8)
			Render(self.img4, self.prex, self.prey, -3 * self.timer + 180, (8 + self.timer % 3) * 0.125 * self.node / 8)
		end
	end
	---@param self THlib.Object.BentLaser
	laser_bent_renderFuncDeath[id] = function(self)
		self.data:Render(tex, self._blend, Color(self._a * (1 - self.timer / 30), self._r, self._g, self._b), 0, 0, w, h)
	end
end

---添加曲线激光素材，曲线激光必须横着放，然后不同颜色的竖着排列，共16条（对应16种颜色）
---@param id number
---@param tex string
function Add_bentlaser_texture_16(id, tex, w, h)
	local dh = h / 16
	---@param self THlib.Object.BentLaser
	laser_bent_renderFunc[id] = function(self)
		self.data:Render(tex, self._blend, Color(self._a * self.alpha, self._r, self._g, self._b), 0, (self.index-1)*dh, w, dh)
		if self.timer < self._l * 4 and self.node then
			local c = Color(self._a, self._r, self._g, self._b)
			SetImageState(self.img4, self._blend, c)
			Render(self.img4, self.prex, self.prey, -3 * self.timer, (8 + self.timer % 3) * 0.125 * self.node / 8)
			Render(self.img4, self.prex, self.prey, -3 * self.timer + 180, (8 + self.timer % 3) * 0.125 * self.node / 8)
		end
	end
	---@param self THlib.Object.BentLaser
	laser_bent_renderFuncDeath[id] = function(self)
		self.data:Render(tex, self._blend, Color(self._a * (1 - self.timer / 30), self._r, self._g, self._b), 0, (self.index-1)*dh, w, dh)
	end
end

---添加雷光类型的曲线激光素材，曲线雷光必须横放
---@param id number
---@param tex string
---@param n number @动画帧数量
function Add_bentlaser_thunder_texture_single(id, tex, n)
	n=n or 4
	local w, h = GetTextureSize(tex)
	local dn=h/n
	---@param self THlib.Object.BentLaser
	laser_bent_renderFunc[id] = function(self)
		self.data:Render(tex, self._blend, Color(self._a * self.alpha, self._r, self._g, self._b), 0, dn * (int(0.5 * self.timer) % n), w, dn)
		if self.timer < self._l * 4 and self.node then
			local c = Color(self._a, self._r, self._g, self._b)
			SetImageState(self.img4, self._blend, c)
			Render(self.img4, self.prex, self.prey, -3 * self.timer, (8 + self.timer % 3) * 0.125 * self.node / 8)
			Render(self.img4, self.prex, self.prey, -3 * self.timer + 180, (8 + self.timer % 3) * 0.125 * self.node / 8)
		end
	end
	---@param self THlib.Object.BentLaser
	laser_bent_renderFuncDeath[id] = function(self)
		self.data:Render(tex, self._blend, Color(self._a * (1 - self.timer / 30), self._r, self._g, self._b), 0, dn * (int(0.5 * self.timer) % n), w, dn)
	end
end

---添加雷光类型的曲线激光素材，曲线雷光必须横放，动画帧数量必须为4
---@param id number
---@param tex string
function Add_bentlaser_thunder_texture(id, tex)
	Add_bentlaser_thunder_texture_single(
			id, tex, 4)
end

---曲线激光判定包络
---@param id number
---@vararg number
function Add_bentlaser_envelope(id, ... )
	local args = { ... }
	if (#args) > 0 then
		laser_bent_colliEnvelope[id] = args
	else
		laser_bent_colliEnvelope[id] = nil
	end
end

----------------------------------------
---bent lazer eff

local eff = Class(object)

function eff:init(index, data, sample, layer, blend, a, r, g, b)
	---@type lstg.BentLaser
	self.data = data
	self.sample = sample
	self.index = index
	self.group = GROUP_GHOST
	self.layer = layer
	self.colli = false
	self.bound = false
	self._blend, self._a, self._r, self._g, self._b = blend, a, r, g, b
end

function eff:frame()
	if self.timer >= 29 then--30,but real is 29
		Del(self)
	end
end

function eff:render()
	if laser_bent_renderFuncDeath[self.sample] then
		laser_bent_renderFuncDeath[self.sample](self)
	end
end

----------------------------------------
---bent lazer

---@class THlib.Class.BentLaser : lstg.Class
local M = Class(object)

---@class THlib.Object.BentLaser : lstg.GameObject
local _M = {}

local mt = {
	__index = function(t, k)
		if k == "bound" then
			return rawget(t, "_bound")
		elseif k == "colli" then
			return rawget(t, "_colli")
		else
			return GetAttr(t, k)
		end
	end,
	__newindex = function(t, k, v)
		if k == 'bound' then
			rawset(t, '_bound', v)
		elseif k == 'colli' then
			rawset(t, '_colli', v)
		else
			SetAttr(t, k, v)
		end
	end
}

---@param self THlib.Object.BentLaser
local function set_bentlaser_metatable(self)
	self.bound = false
	self._bound = true
	self.colli = false
	self._colli = true
end

---@param self THlib.Object.BentLaser
local function set_bentlaser_publicdata(self, index, x, y, l, w, sample, node)
	self.sample = sample --曲线激光类型
	self.index = index --颜色索引
	self.l = max(int(l), 2) --长度
	self.w = w --现有宽度
	self.w0 = w --原始宽度
	self._w = w --标记宽度变化，如果新的宽度与这个宽度不一样则进行宽度更新
	self.prex = x --初始位置，用于--消弹特效和绿点位置列表
	self.prey = y --初始位置，用于激光发射效果
	self._l = int(l / 4)
	self.listx = {} --消弹特效和绿点位置列表
	self.listy = {} --消弹特效和绿点位置列表
	self.node = node or 0 --激光发射效果大小
	self.img4 = laser_node_img .. index --激光发射效果贴图
	self.counter = 0 --增量计数器，为0时不计算以下2个增量
	self.dw = 0 --宽度增量
	self.da = 0 --透明度增量
	self.alpha = 1 --透明度，影响渲染和碰撞判定
	self.deactive = 0 --新的节点处于取消激活状态？
	---@type lstg.BentLaser
	self.data = BentLaserData()
	local env = laser_bent_colliEnvelope[sample]
	if env then
		self.data:SetEnvelope(unpack(env))
	end
end

---@param self THlib.Object.BentLaser
local function _colli_bentlaser_player(self, player)
	if self.colli then
		if self.data:CollisionCheck(player.x,player.y,player.rot,player.A,player.B,player.rect) then
			player.class.colli(player, self)
		end
		if self.timer % 4 == 0 then
			--可改为使用自机擦弹器碰撞判定
			local grazer = player.grazer
			if self.data:CollisionCheck(grazer.x,grazer.y,grazer.rot,grazer.a,grazer.b,grazer.rect) then
				grazer.class.colli(grazer, self)
				self._graze = false
				self._grazed = false
			end
		end
	end
end

---@param self THlib.Object.BentLaser
local function colli_bentlaser_player(self)
	if self.alpha > 0.999 then
		for _, player in pairs({_G.player}) do
			_colli_bentlaser_player(self, player)
		end
	end
end

---@param self THlib.Object.BentLaser
local function bound_bentlaser_world(self)
	local w = lstg.world
	if self.bound and
			(not self.data:BoundCheck()) and
			(not BoxCheck(self, w.boundl, w.boundr, w.boundb, w.boundt))--额外判断一次这个
	then
		Del(self)
	end
end

---@param self THlib.Object.BentLaser
local function record_position(self)
	local ani = self.ani
	local index = int(ani / 4) % self._l + 1
	if ani % 4 == 0 then
		self.listx[index] = self.x
		self.listy[index] = self.y
	end
end

---@param self THlib.Object.BentLaser
local function drop_effect(self)
	local LX, LY = self.listx, self.listy
	for i = 1, self._l do
		if LX[i] and LY[i] then
			New(item_faith_minor, LX[i], LY[i])
			if i % 2 == 0 then
				New(BulletBreak, LX[i], LY[i], self.index)
			end
		end
	end
end

---@param self THlib.Object.BentLaser
function M.setWidth(self, w)
	self.w = w
	self._w = w --需要标记一次
	self.data:SetAllWidth(w)
end

----------------------------------------
---bent lazer callback

---@param self THlib.Object.BentLaser
function M.init(self, index, x, y, l, w, sample, node)
	self.x = x
	self.y = y
	self.group = GROUP_INDES
	self.layer = LAYER_ENEMY_BULLET
	self.pause = 0
	self._blend, self._a, self._r, self._g, self._b = "mul+add", 255, 255, 255, 255
	set_bentlaser_publicdata(self, index, x, y, l, w, sample, node)
	set_bentlaser_metatable(self)
end

---@param self THlib.Object.BentLaser
function M.frame(self)
	task.Do(self)
	--update width and alpha
	if self.counter > 0 then
		self.counter = self.counter - 1
		self.w = self.w + self.dw
		self.alpha = self.alpha + self.da
	end
	--update all width
	if self.w ~= self._w then
		M.setWidth(self, self.w)
	end
	--node update
	if self.pause <= 0 then--对pause的处理
		record_position(self)
		self.data:Update(self, self.l, self.w, self.deactive)
	end
	--colli and bound check
	colli_bentlaser_player(self)
	bound_bentlaser_world(self)
end

---@param self THlib.Object.BentLaser
function M.render(self)
	if laser_bent_renderFunc[self.sample] then
		laser_bent_renderFunc[self.sample](self)
	end
end

---@param self THlib.Object.BentLaser
function M.del(self)
	New(eff,
			self.index, self.data, self.sample,
			self.layer,
			self._blend, self._a, self._r, self._g, self._b)
end

---@param self THlib.Object.BentLaser
function M.kill(self)
	drop_effect(self)
	M.del(self)
end

----------------------------------------
---bent lazer out

---@type THlib.Class.BentLaser
laser_bent = M
