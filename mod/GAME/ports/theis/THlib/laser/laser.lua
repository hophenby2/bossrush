
local path="THlib/laser/"
local sin, cos = lstg.sin, lstg.cos
local abs = math.abs
local min, max = math.min, math.max
local int = math.floor

local laser_data = {}
local laser_texture_num = 1
local lazer_raw_width = 6--7
local laser_head_size = 8
local laser_node_size = 8
local laser_head_img = "ball_mid_b"
local laser_node_img = "preimg"--"laser_node"
local laser_graze_size = 16

local res_set = lstg.ResourceSet.Create("THlib.laser", "global")

function LoadLaserTexture(filename, l1, l2, l3)
	local n = laser_texture_num
	local texture = "laser" .. n
	res_set:AddTexture(texture, filename, false)
	res_set:AddSpriteSequence(texture .. 1, texture, 0, 0, l1, 16, 1, 16)
	res_set:AddSpriteSequence(texture .. 2, texture, l1, 0, l2, 16, 1, 16)
	res_set:AddSpriteSequence(texture .. 3, texture, l1 + l2, 0, l3, 16, 1, 16)
	for i = 1, 3 do
		for j = 1, 16 do
			res_set:SetSpriteCenter(texture .. i .. j, 0, 8)
		end
	end
	laser_data[n] = { l1, l2, l3, lazer_raw_width }
	laser_texture_num = n + 1
end

function LoadLaserTextureFromFile(filename, w, h, l1, l2, l3, scale, w0)
	local n = laser_texture_num
	w0=w0 or lazer_raw_width
	local texture = "laser" .. n
	res_set:AddTexture(texture, filename, false)
	local dh = h / 16
	res_set:AddSpriteSequence(texture .. 1, texture, 0, 0, l1, dh, 1, 16)
	res_set:AddSpriteSequence(texture .. 2, texture, l1, 0, l2, dh, 1, 16)
	res_set:AddSpriteSequence(texture .. 3, texture, l1 + l2, 0, l3, dh, 1, 16)
	for i = 1, 3 do
		for j = 1, 16 do
			res_set:SetSpriteCenter(texture .. i .. j, 0, dh/2)
		end
	end
	laser_data[n] = { l1*scale, l2*scale, l3*scale, w0*scale }
	laser_texture_num = n + 1
end

laser = Class(object)

function laser:init(index, x, y, rot, l1, l2, l3, w, node, head)
	laser.ChangeImage(self,1, index)
	self.x = x
	self.y = y
	self.rot = rot
	self.prex = x
	self.prey = y
	self.l1 = l1
	self.l2 = l2
	self.l3 = l3
	self.w0 = w
	self.w = 0
	self.dw = 0
	self.alpha = 0
	self.da = 0
	self.node = node or 0
	self.head = head or 0
	self.group = GROUP_INDES
	self.layer = LAYER_ENEMY_BULLET
	self.a = 0
	self.b = 0
	self.counter = 0
	self._blend, self._a, self._r, self._g, self._b = "mul+add", 255, 255, 255, 255
end

local function colli_player(self, player)
	local x = player.x - self.x
	local y = player.y - self.y
	local rot = self.rot
	local dist = 2
	x, y = x * cos(rot) + y * sin(rot), y * cos(rot) - x * sin(rot)
	y = abs(y)
	if x > 0 then
		local flag = false
		if x < self.l1 then
			local ret = x / self.l1 * self.w / dist
			if y < ret then
				player.class.colli(player, self)
			end
			if y < (ret + laser_graze_size) then
				flag = true
			end
		elseif x < self.l1 + self.l2 then
			local ret = self.w / dist
			if y < ret then
				player.class.colli(player, self)
			end
			if y < (ret + laser_graze_size) then
				flag = true
			end
		elseif x < self.l1 + self.l2 + self.l3 then
			local ret = (self.l1 + self.l2 + self.l3 - x) / self.l3 * self.w / dist
			if y < ret then
				player.class.colli(player, self)
			end
			if y < (ret + laser_graze_size) then
				flag = true
			end
		end
		if self.timer % 4 == 0 and flag then
			player.grazer.class.colli(player.grazer, self)
			self._graze = false
			self._grazed = false
		end
	end
end

function laser:frame()
	task.Do(self)
	if self.counter > 0 then
		self.counter = self.counter - 1
		self.w = self.w + self.dw
		self.alpha = self.alpha + self.da
	end
	if self.alpha >= 0.9999 and self.colli then
		for _, player in pairs({_G.player}) do
			colli_player(self, player)
		end
	end
end

local function render_laser(self, b)
	local data = laser_data[self.imgid]
	local w = self.w / data[4]
	local c = Color(self._a * self.alpha, self._r, self._g, self._b)

	SetImageState(self.img1, b, c)
	SetImageState(self.img2, b, c)
	SetImageState(self.img3, b, c)

	Render(self.img1, self.x, self.y, self.rot, self.l1 / data[1], w)
	Render(self.img2, self.x + self.l1 * cos(self.rot), self.y + self.l1 * sin(self.rot), self.rot, self.l2 / data[2], w)
	Render(self.img3, self.x + (self.l1 + self.l2) * cos(self.rot), self.y + (self.l1 + self.l2) * sin(self.rot), self.rot, self.l3 / data[3], w)
end

local function render_node(self, b)
	local l = (self.l1 + self.l2 + self.l3)--*0.95
	--头尾的渲染受原始大小影响
	if self.node > 0 then
		local c = Color(self._a * self.w / self.w0, self._r, self._g, self._b)
		SetImageState(self.img4, b, c)
		Render(self.img4, self.x, self.y, self.ani * 8, self.node / laser_node_size)
	end
	if self.head > 0 then
		local c = Color(self._a * self.w / self.w0, self._r, self._g, self._b)
		SetImageState(self.img5, b, c)
		Render(self.img5, self.x + l * cos(self.rot), self.y + l * sin(self.rot), self.ani * 8, self.head / laser_head_size)
	end
end

function laser:render()
	if self.w > 0 then
		local b = self._blend
		render_laser(self, b)
		render_node(self, b)
	end
end

local function drop_item(self)
	local w = lstg.world
	local cx, cy = cos(self.rot), sin(self.rot)
	local _x, _y = self.x, self.y
	local x, y = 0, 0
	local length = min((32768 - GetnObj()) / 2 * 12, self.l1 + self.l2 + self.l3)
	for l = 0, length, 12 do
		x, y = _x + l * cx, _y + l * cy
		if (x <= w.r and x >= w.l) and (y <= w.t and y >= w.b) then
			New(item_faith_minor, x, y)
			if self.index and l % 2 == 0 then
				New(BulletBreak, x, y, self.index)
			end
		end
	end
end

function laser:kill()
	PreserveObject(self)
	if self.class ~= laser_death_ef then
		drop_item(self)
		self.class = laser_death_ef
		laser_death_ef.init(self)
	end
end

function laser:del()
	PreserveObject(self)
	if self.class ~= laser_death_ef then
		self.class = laser_death_ef
		laser_death_ef.init(self)
	end
end

function laser:ChangeImage(id, index)
	self.imgid = max(min(id, laser_texture_num - 1), 1)
	if index then
		self.index = max(min(index, 16), 1)
	end
	local _index = self.index
	local _id = self.imgid
	self.img1 = "laser" .. _id .. '1' .. _index
	self.img2 = "laser" .. _id .. '2' .. _index
	self.img3 = "laser" .. _id .. '3' .. _index
	self.img4 = laser_node_img .. _index--int((_index + 1) / 2)
	self.img5 = laser_head_img .. int((_index + 1) / 2)
end

function laser:grow(time, mute, wait)
	if mute then
		PlaySound("lazer00", 0.25, self.x / 768)
	end
	if time == 0 then
		return
	end
	local l1, l2, l3 = self.l1, self.l2, self.l3
	local add = (l1 + l2 + l3) / time
	self.l1, self.l2, self.l3 = 0, 0, 0
	self.alpha = 1
	self.w = self.w0
	task.New(self, function()
		for i = 1, time do
			if not IsValid(self) then
				break
			elseif self.l2 == l2 then
				self.l1 = self.l1 + add
			elseif self.l2 > l2 then
				self.l1 = self.l1 + add + self.l2 - l2
				self.l2 = l2
			elseif self.l3 == l3 then
				self.l2 = self.l2 + add
			elseif self.l3 > l3 then
				self.l2 = self.l2 + add + self.l3 - l3
				self.l3 = l3
			else
				self.l3 = self.l3 + add
			end
			task.Wait(1)
		end
		if IsValid(self) then
			self.l1 = l1
		end
	end)
	if task.GetSelf() == self and wait then
		task.Wait(time)
	end
end

function laser:TurnOn(t, mute)
	t = t or 30
	t = max(1, int(t))
	if not mute then
		PlaySound("lazer00", 0.25, self.x / 768)
	end
	self.counter = t
	self.da = (1 - self.alpha) / t
	self.dw = (self.w0 - self.w) / t
end

function laser:TurnHalfOn(t)
	t = t or 30
	t = max(1, int(t))
	self.counter = t
	self.da = (0.5 - self.alpha) / t
	self.dw = (0.5 * self.w0 - self.w) / t
end

function laser:TurnOff(t)
	t = t or 30
	t = max(1, int(t))
	self.counter = t
	self.da = -self.alpha / t
	self.dw = -self.w / t
end

laser_death_ef = Class(laser)

function laser_death_ef:init()
	self.group = GROUP_GHOST
	local alpha = self.alpha
	local d = self.w
	task.Clear(self)
	task.New(self, function()
		for i = 1, 30 do
			self.alpha = self.alpha - alpha / 30
			self.w = self.w - d / 30
			task.Wait(1)
		end
		self.status = "del"
	end)
end

function laser_death_ef:frame()
	task.Do(self)
end

function laser_death_ef:del()
end

function laser_death_ef:kill()
end

Include(path.."bentlaser.lua")
