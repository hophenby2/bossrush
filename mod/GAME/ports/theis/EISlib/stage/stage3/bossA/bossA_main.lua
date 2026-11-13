local function create_diff_function(mokou_fs, keine_fs, connect, cardnames)
	return function(self)
		if lstg.IsValid(self.mokou) and mokou_fs[difficulty] then
			mokou_fs[difficulty](self.mokou)
			if connect then
				_connect(self, self.mokou, 1, true)
			end
		end
		if lstg.IsValid(self.keine) and keine_fs[difficulty] then
			keine_fs[difficulty](self.keine)
			if connect then
				_connect(self, self.keine, 1, true)
			end
		end
		if cardnames and cardnames[difficulty] then
			self.ui_cardnames = cardnames[difficulty]
		end
	end
end

--生成常用加速弹
local function accbullet(st, co, x, y, v, a, t)
	local obj = stg.newBulletStraight(st, co, true, x, y, 0, a)
	egg.AddSimStrChV(obj, 0, v, a, t)
	return obj
end
--激光预警特效
local lasereff = Class(object)
function lasereff:init(x, y, a, r, g, b, w)
	r, g, b = r or 177, g or 255, b or 97
	w = w or 1
	self.bound = false
	self.x, self.y = x + 300*cos(a), y + 300*sin(a)
	self.rot = a
	self.layer = LAYER_ENEMY_BULLET-1
	self.hscale, self.vscale = 75, 0
	self.img = "white"
	_object.set_color(self, "mul+add", 100, r, g, b)
	task.New(self, function()
		local ds, d_a = 1/50*w, -100/30
		for _ = 1, 20 do
			self.vscale = self.vscale + 2*ds
			task.Wait(1)
		end
		for _ = 1, 30 do
			self.vscale = self.vscale + ds
			self._a = self._a + d_a
			task.Wait(1)
		end
		Del(self)
	end)
end
function lasereff:frame()
	task.Do(self)
end
function lasereff:render()
	local rate, v = 1, 1
	for _ = 1, 3 do
		SetImgState(self, self._blend, self._a*rate, self._r*rate, self._g*rate, self._b*rate)
		Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale*v)
		rate = rate - 0.2
		v = v + 0.3
	end
end

--拖影特效
local trail2 = Class(object)
function trail2:init(master, maxnum, frame, img, size, blend, times, _a_rate, Isdsize)
	self.layer = master.layer
	self.bound = false
	self.master = master
	self.alpha = 80
	self.img = img
	self.size = size or 1
	self.trail = {} --拖影表
	self.max = maxnum or 10
	self.frame = frame or 3
	self.co = {255, 255, 255} --留一个可以外部操作的接口co
	self.blend = blend or "mul+alpha"
	self.times = times or 99999
	self._a_rate = _a_rate or 1
	self.Isdsize = Isdsize
end
function trail2:frame()
	if IsValid(self.master) then
		self.x, self.y = self.master.x, self.master.y
	end
	if self.frame == 1 or self.timer%self.frame == 1  then
		if IsValid(self.master) and self.timer < self.times then
			local master = self.master
			table.insert(self.trail, 1, {master.x, master.y, master.rot, master.hscale*self.size, master.vscale*self.size}) --更新主人当前图像状态
			if #self.trail > self.max then table.remove(self.trail) end
		else--即便主人不存在了，拖影也会保留一段时间渐渐消失
			if #self.trail == 0 then
				Del(self)
			else
				table.remove(self.trail)
			end
		end
	end
end
function trail2:render()
	local co = self.co
	local size = 1
	local dsize
	if self.Isdsize then
		dsize = 0.5/self.max
	else
		dsize = 0
	end
	if IsValid(self.master) then
		self.alpha = 255*self._a_rate
	end
	local alpha, d, n = 0.2*self.alpha, 0.8*self.alpha/self.max, #self.trail
	for i = n, 1, -1 do
		local obj = self.trail[i]
		SetImgState(self, self.blend, alpha, co[1], co[2], co[3])
		Render(self.img, obj[1], obj[2], obj[3], obj[4]*size, obj[5]*size)
		alpha = alpha + d
		--alpha = 255
		size = size + dsize
	end
	SetImgState(self, "", 255, 255, 255, 255) -- 记得恢复渲染状态
end

local function move_rd(t, y0, dy, self, xmin, xmax, xr)
	y0 = y0 or 144
	dy = dy or 25
	xmin, xmax = xmin or 10, xmax or 20
	xr = xr or -40
	if self then
		task.New(self, function()
			task.MoveToPlayer(t or 60, -xr, xr, y0 - dy, y0 + dy, xmin, xmax, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
		end)
	else
		task.MoveToPlayer(t or 60, -xr, xr, y0 - dy, y0 + dy, xmin, xmax, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
	end
end

local cardname = {
	card1 = {
		mokou = {
			EN = "咒符「摩根之爪」",
			HL = "焱攸不息「迦具土的一指」",
		},
		keine = {
			EN = "哀符「源氏物语」",
			HL = "一茶日记「竹林独步寻花」",
		},
	},
	card2 = {
		mokou = {
			EN = "炎符「火凤凰舍身冲撞」",
			HL = "不死「凯风快晴飞翔蹴」",
		},
		keine = {
			EN = "秘史「国士无双之卷」",
			HL = "国符「空想神器 案」",
		},
	},
	card3 = {
		mokou = {
			EN = "回符「加缪的诅咒」",
			HL = "无尽「荒诞的不死者」",
		},
		keine = {
			EN = "鉴符「三重时段」",
			HL = "诗符「创始者叙事」",
		},
	},
}

-- card
--region normal 1
local function normal1_init_Mokou_E(self)
	task.New(self, function()
		task.MoveTo(0, 159, 60, MOVE_DECEL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 56)
		local a
		while true do
			for u = -1, 1, 2 do
				a = Angle(self, player)
				for k = 1, 0, -1 do
					for j = 0, 0, -1 do
						for i = 1, 20 do
							stg.newBulletStraight(stg.arrow_big, 6 - 4*k, true, self.x, self.y, 1 + 1*k + 0.2*j, a + 18*i + 8*j*u)
						end
						task.Wait(5)
					end
				end
				task.Wait(230)
				task.MoveToPlayer(60, -40, 40, 159, 170, 16, 32, 5, 10, MOVE_DECEL, MOVE_RANDOM)
			end
		end
	end)
end
local function normal1_init_Mokou_N(self)
	task.New(self, function()
		task.MoveTo(0, 159, 60, MOVE_DECEL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 56)
		local a
		while true do
			for u = -1, 1, 2 do
				a = Angle(self, player)
				for k = 1, 0, -1 do
					for j = 2, 0, -1 do
						for i = 1, 20 do
							stg.newBulletStraight(stg.arrow_big, 6 - 4*k, true, self.x, self.y, 1 + 1*k + 0.2*j, a + 18*i + 8*j*u)
						end
						task.Wait(5)
					end
				end
				task.Wait(210)
				task.MoveToPlayer(60, -40, 40, 159, 170, 16, 32, 5, 10, MOVE_DECEL, MOVE_RANDOM)
			end
		end
	end)
end
local function normal1_init_Mokou_H(self)
	task.New(self, function()
		task.MoveTo(0, 159, 60, MOVE_DECEL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 56)
		local a
		while true do
			for u = -1, 1, 2 do
				a = Angle(self, player)
				for k = 1, 0, -1 do
					for j = 3, 0, -1 do
						for i = 1, 30 do
							stg.newBulletStraight(stg.arrow_big, 6 - 4*k, true, self.x, self.y, 1 + 1*k + 0.2*j, a + 12*i + 5*j*u)
						end
						task.Wait(5)
					end
				end
				task.Wait(200)
				task.MoveToPlayer(60, -40, 40, 159, 170, 16, 32, 5, 10, MOVE_DECEL, MOVE_RANDOM)
			end
		end
	end)
end
local function normal1_init_Mokou_L(self)
	task.New(self, function()
		task.MoveTo(0, 159, 60, MOVE_DECEL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 56)
		local a
		while true do
			for u = -1, 1, 2 do
				a = Angle(self, player)
				for k = 1, 0, -1 do
					for j = 4, 0, -1 do
						for i = 1, 36 do
							stg.newBulletStraight(stg.arrow_big, 6 - 4*k, true, self.x, self.y, 1 + 1*k + 0.2*j, a + 10*i + 4*j*u)
						end
						task.Wait(5)
					end
				end
				task.Wait(190)
				task.MoveToPlayer(60, -40, 40, 159, 170, 16, 32, 5, 10, MOVE_DECEL, MOVE_RANDOM)
			end
		end
	end)
end
local function normal1_init_Keine_E(self)
	local f1, f1_1, f2
	do
		--慧音使魔
		function f1_1(x, y, a, u, co)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic6"
			obj.hscale, obj.vscale = 0.75, 0.75
			obj.colli = false
			--移动与攻击
			task.New(obj, function()
				task.MoveTo(x, y, 60, MOVE_ACC_DEC)
				local da = 20*u
				for k = 1, 20 do
					if k > 4 then
						a = a + da
					end
					for i = 1, 2 do
						stg.newBulletStraight(stg.ball_mid, co, true, obj.x, obj.y, 1 + 0.25*i, a - 1*i*u)
					end
					PlaySound("tan00")
					task.Wait(10)
				end
				Del(obj)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 100, 60, MOVE_DECEL)
		do
			task.Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
			task.Wait(60)
		end
		self._wisys:setAction("cast", 56)
		local a
		while true do
			for u = -1, 1, 2 do
				for u0 = -1, 1, 2 do
					f1_1(self.x + 45*u0, self.y, -90 - 60*u0, u0, 2)
					f1_1(self.x - 75*u0, self.y + 45, 90 + 90*u0, -u0, 6)
				end
				PlaySound("kira00")
				task.Wait(240)
				task.MoveToPlayer(60, -40, 40, 100, 120, 16, 32, 5, 10, MOVE_DECEL, MOVE_RANDOM)
			end
		end
	end)
end
local function normal1_init_Keine_N(self)
	local f1, f1_1, f2
	do
		--慧音使魔
		function f1_1(x, y, a, u, co)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic6"
			obj.hscale, obj.vscale = 0.75, 0.75
			obj.colli = false
			--移动与攻击
			task.New(obj, function()
				task.MoveTo(x, y, 60, MOVE_ACC_DEC)
				local da = 12*u
				for k = 1, 33 do
					if k > 4 then
						a = a + da
					end
					for i = 1, 4 do
						stg.newBulletStraight(stg.ball_mid, co, true, obj.x, obj.y, 1 + 0.25*i, a - 1*i*u)
					end
					PlaySound("tan00")
					task.Wait(6)
				end
				Del(obj)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 100, 60, MOVE_DECEL)
		do
			task.Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
			task.Wait(60)
		end
		self._wisys:setAction("cast", 56)
		local a
		while true do
			for u = -1, 1, 2 do
				for u0 = -1, 1, 2 do
					f1_1(self.x + 45*u0, self.y, -90 - 60*u0, u0, 2)
					f1_1(self.x - 75*u0, self.y + 45, 90 + 90*u0, -u0, 6)
				end
				PlaySound("kira00")
				task.Wait(240)
				task.MoveToPlayer(60, -40, 40, 100, 120, 16, 32, 5, 10, MOVE_DECEL, MOVE_RANDOM)
			end
		end
	end)
end
local function normal1_init_Keine_H(self)
	local f1, f1_1, f2
	do
		--慧音使魔
		function f1_1(x, y, a, u, co)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic6"
			obj.hscale, obj.vscale = 0.75, 0.75
			obj.colli = false
			--移动与攻击
			task.New(obj, function()
				task.MoveTo(x, y, 60, MOVE_ACC_DEC)
				local da = 10*u
				for k = 1, 40 do
					if k > 4 then
						a = a + da
					end
					for i = 1, 6 do
						stg.newBulletStraight(stg.ball_mid, co, true, obj.x, obj.y, 1 + 0.25*i, a - 1*i*u)
					end
					PlaySound("tan00")
					task.Wait(5)
				end
				Del(obj)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 100, 60, MOVE_DECEL)
		do
			task.Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
			task.Wait(60)
		end
		self._wisys:setAction("cast", 56)
		local a
		while true do
			for u = -1, 1, 2 do
				for u0 = -1, 1, 2 do
					f1_1(self.x + 45*u0, self.y, -90 - 60*u0, u0, 2)
					f1_1(self.x - 75*u0, self.y + 45, 90 + 90*u0, -u0, 6)
				end
				PlaySound("kira00")
				task.Wait(240)
				task.MoveToPlayer(60, -40, 40, 100, 120, 16, 32, 5, 10, MOVE_DECEL, MOVE_RANDOM)
			end
		end
	end)
end
local function normal1_init_Keine_L(self)
	local f1, f1_1, f2
	do
		--慧音使魔
		function f1_1(x, y, a, u, co)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic6"
			obj.hscale, obj.vscale = 0.75, 0.75
			obj.colli = false
			--移动与攻击
			task.New(obj, function()
				task.MoveTo(x, y, 60, MOVE_ACC_DEC)
				local da = 10*u
				for k = 1, 40 do
					if k > 4 then
						a = a + da
					end
					for i = 1, 8 do
						stg.newBulletStraight(stg.ball_mid, co, true, obj.x, obj.y, 1 + 0.25*i, a - 1*i*u)
					end
					PlaySound("tan00")
					task.Wait(5)
				end
				Del(obj)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 100, 60, MOVE_DECEL)
		do
			task.Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
			task.Wait(60)
		end
		self._wisys:setAction("cast", 56)
		local a
		while true do
			for u = -1, 1, 2 do
				for u0 = -1, 1, 2 do
					f1_1(self.x + 45*u0, self.y, -90 - 60*u0, u0, 2)
					f1_1(self.x - 75*u0, self.y + 45, 90 + 90*u0, -u0, 6)
				end
				PlaySound("kira00")
				task.Wait(240)
				task.MoveToPlayer(60, -40, 40, 100, 120, 16, 32, 5, 10, MOVE_DECEL, MOVE_RANDOM)
			end
		end
	end)
end
local normal1_init = create_diff_function(
		{ normal1_init_Mokou_E, normal1_init_Mokou_N, normal1_init_Mokou_H, normal1_init_Mokou_L },
		{ normal1_init_Keine_E, normal1_init_Keine_N, normal1_init_Keine_H, normal1_init_Keine_L },
		true)
local normal1_del = create_diff_function(
		{ false, false, false, false },
		{ false, false, false, false },
		false)
--endregion

--region card 1
local function card1_init_Mokou_E(self)
	task.New(self, function()
		task.MoveTo(0, 124, 60, MOVE_DECEL)
	end)
	task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
			self._wisys:setAction("cast", 64)
		end
		local u = 1
		local x, y, a, da
		do
			while true do
				for u = -1, 1, 2 do
					a, da = Angle(self, player) + 180 + 30 * u, (-140/2 * u)
					for i = 0, 2 do
						New(_editor_class["s3_妹红一符龙头"], self.x, self.y, a + da*i, u, 0.075, 35 + 8*i)
						PlaySound("kira00")
						task.Wait(5)
					end
					task.Wait(85)
				end
				u = -u
				task.MoveTo(0, 500, 60, MOVE_DECEL)
				--撞人
				for u = -1, 1, 2 do
					x, y, a = 300*u, 150, -90 - 70*u
					for i = -2, 2 do
						New(_editor_class["s3_妹红一符激光预警"], x, y, a + 25*i)
					end
					task.Wait(60)
					self.x, self.y = x, y
					SetV(self, 0, 0)
					_set_a(self, 0.5, a, false)
					self._wisys:setAction("cast", 64)
					task.Wait(60)
					_set_a(self, 0, a, false)
				end
				do
					x, y, a = 0, 450, -90
					for i = -3, 3 do
						New(_editor_class["s3_妹红一符激光预警"], x, y, a + 15*i)
					end
					task.Wait(60)
					self.x, self.y = x, y
					_set_a(self, 0, 0, false)
					SetV(self, 0, 0)
					task.MoveTo(0, 124, 60, MOVE_ACC_DEC)
					self._wisys:setAction("cast", 64)
					--最后一波补充攻击
					for i = 0, 5 do
						for u = 0, 0 do
							New(_editor_class["s3_妹红一符龙头"], self.x, self.y, 90 - 60*i * u, u, 0.075, 60 + 5*i)
							PlaySound("kira00")
						end
						task.Wait(2)
					end
				end
				task.Wait(60)
			end
		end
	end)
end
local function card1_init_Mokou_N(self)
	task.New(self, function()
		task.MoveTo(0, 124, 60, MOVE_DECEL)
	end)
	task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
			self._wisys:setAction("cast", 64)
		end
		local u = 1
		local x, y, a, da
		do
			while true do
				for u = -1, 1, 2 do
					a, da = Angle(self, player) + 180 + 30 * u, (-140/4 * u)
					for i = 0, 4 do
						New(_editor_class["s3_妹红一符龙头"], self.x, self.y, a + da*i, u, 0.1, 35 + 8*i)
						PlaySound("kira00")
						task.Wait(5)
					end
					task.Wait(75)
				end
				u = -u
				task.MoveTo(0, 500, 60, MOVE_DECEL)
				--撞人
				for u = -1, 1, 2 do
					x, y, a = 300*u, 150, -90 - 70*u
					for i = -4, 4 do
						New(_editor_class["s3_妹红一符激光预警"], x, y, a + 15*i)
					end
					task.Wait(60)
					self.x, self.y = x, y
					SetV(self, 0, 0)
					_set_a(self, 0.5, a, false)
					self._wisys:setAction("cast", 64)
					task.Wait(60)
					_set_a(self, 0, a, false)
				end
				do
					x, y, a = 0, 450, -90
					for i = -6, 6 do
						New(_editor_class["s3_妹红一符激光预警"], x, y, a + 9*i)
					end
					task.Wait(60)
					self.x, self.y = x, y
					_set_a(self, 0, 0, false)
					SetV(self, 0, 0)
					task.MoveTo(0, 124, 60, MOVE_ACC_DEC)
					self._wisys:setAction("cast", 64)
					--最后一波补充攻击
					for i = 0, 5 do
						for u = 0, 0 do
							New(_editor_class["s3_妹红一符龙头"], self.x, self.y, 90 - 60*i * u, u, 0.1, 60 + 5*i)
							PlaySound("kira00")
						end
						task.Wait(2)
					end
				end
				task.Wait(60)
			end
		end
	end)
end
local function card1_init_Mokou_H(self)
	task.New(self, function()
		task.MoveTo(0, 124, 60, MOVE_DECEL)
	end)
	task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
			self._wisys:setAction("cast", 64)
		end
		local u = 1
		local x, y, a, da
		do
			while true do
				for u = -1, 1, 2 do
					a, da = Angle(self, player) + 180 + 30 * u, (-140/6 * u)
					for i = 0, 6 do
						New(_editor_class["s3_妹红一符龙头"], self.x, self.y, a + da*i, u, 0.125, 35 + 8*i)
						PlaySound("kira00")
						task.Wait(5)
					end
					task.Wait(65)
				end
				u = -u
				task.MoveTo(0, 500, 60, MOVE_DECEL)
				--撞人
				for u = -1, 1, 2 do
					x, y, a = 300*u, 150, -90 - 70*u
					for i = -6, 6 do
						New(_editor_class["s3_妹红一符激光预警"], x, y, a + 10*i)
					end
					task.Wait(60)
					self.x, self.y = x, y
					SetV(self, 0, 0)
					_set_a(self, 0.5, a, false)
					self._wisys:setAction("cast", 64)
					task.Wait(60)
					_set_a(self, 0, a, false)
				end
				do
					x, y, a = 0, 450, -90
					for i = -7, 7 do
						New(_editor_class["s3_妹红一符激光预警"], x, y, a + 6.5*i)
					end
					task.Wait(60)
					self.x, self.y = x, y
					_set_a(self, 0, 0, false)
					SetV(self, 0, 0)
					task.MoveTo(0, 124, 60, MOVE_ACC_DEC)
					self._wisys:setAction("cast", 64)
					--最后一波补充攻击
					for i = 0, 5 do
						for u = -1, 1, 2 do
							New(_editor_class["s3_妹红一符龙头"], self.x, self.y, 90 - 60*i * u, u, 0.125, 60 + 5*i)
							PlaySound("kira00")
						end
						task.Wait(2)
					end
				end
				task.Wait(60)
			end
		end
	end)
end
local function card1_init_Mokou_L(self)
	task.New(self, function()
		task.MoveTo(0, 124, 60, MOVE_DECEL)
	end)
	task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
			self._wisys:setAction("cast", 64)
		end
		local u = 1
		local x, y, a, da
		do
			while true do
				for u = -1, 1, 2 do
					a, da = Angle(self, player) + 180 + 30 * u, (-20 * u)
					for i = 0, 7 do
						New(_editor_class["s3_妹红一符龙头"], self.x, self.y, a + da*i, u, 0.15, 35 + 8*i)
						PlaySound("kira00")
						task.Wait(5)
					end
					task.Wait(60)
				end
				u = -u
				task.MoveTo(0, 500, 60, MOVE_DECEL)
				--撞人
				for u = -1, 1, 2 do
					x, y, a = 300*u, 150, -90 - 70*u
					for i = -7, 7 do
						New(_editor_class["s3_妹红一符激光预警"], x, y, a + 7.5*i)
					end
					task.Wait(60)
					self.x, self.y = x, y
					SetV(self, 0, 0)
					_set_a(self, 0.5, a, false)
					self._wisys:setAction("cast", 64)
					task.Wait(60)
					_set_a(self, 0, a, false)
				end
				do
					x, y, a = 0, 450, -90
					for i = -8, 8 do
						New(_editor_class["s3_妹红一符激光预警"], x, y, a + 5*i)
					end
					task.Wait(60)
					self.x, self.y = x, y
					_set_a(self, 0, 0, false)
					SetV(self, 0, 0)
					task.MoveTo(0, 124, 60, MOVE_ACC_DEC)
					self._wisys:setAction("cast", 64)
					--最后一波补充攻击
					for i = 0, 5 do
						for u = -1, 1, 2 do
							New(_editor_class["s3_妹红一符龙头"], self.x, self.y, 90 - 60*i * u, u, 0.15, 60 + 5*i)
							PlaySound("kira00")
						end
						task.Wait(2)
					end
				end
				task.Wait(60)
			end
		end
	end)
end
local function card1_del_Mokou_ENHL(self)
	_set_a(self, 0, 0, false)
	SetV2(self, 0, 0, false, false)
	if (self.y < -300) then
		self.x = 0
		self.y = 500
	else
	end
	Spell_break_eff(self.x, self.y, 255, 0, 0, 'bamboo_leaf_white', 'tree_leaf_white')
end
local function card1_init_Keine_E(self)
	local f1, f2
	do
		function f1(x, y)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic6"
			obj.hscale, obj.vscale = 0, 0
			obj.timer = 11
			obj.colli = false
			egg.SimSizeCh(obj, 0, 0.75, 20)
			task.New(obj, function()
				--移动到x, y处
				task.MoveTo(x, y, 90, MOVE_ACC_DEC)
				local a = Angle(obj, player)
				for i = 1, 8 do
					for j = 0, 1 do
						accbullet(stg.arrow_big, 10 - 2*j, obj.x, obj.y, 1.25 + 0.25*j, a + 45*i + 15*j, 120)
					end
				end
				PlaySound("kira00")
				Del(obj)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 70, 60, MOVE_NORMAL)
	end)
	--692
	task.New(self, function()
		do
			s3A_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 56)
		while true do
			for u = -1, 1, 2 do
				for i = 0, 3 do
					f1(192*u, -50 + 60*i)
					PlaySound("kira00")
					task.Wait(20)
				end
				move_rd(60, 70, 10, nil, 10, 20, -40, 40)
				task.Wait(70)
			end
			for i = 0, 3 do
				for u = -1, 1, 2 do
					f1((192 - 50*i)*u, 200)
				end
				PlaySound("kira00")
				task.Wait(20)
			end
			task.Wait(192)
		end
	end)
end
local function card1_init_Keine_N(self)
	--New(egg.updateFileObject, "EISlib/stage/stage3/bossA/bossA_main.lua")
	local f1, f2
	do
		function f1(x, y)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic6"
			obj.hscale, obj.vscale = 0, 0
			obj.timer = 11
			obj.colli = false
			egg.SimSizeCh(obj, 0, 0.75, 20)
			task.New(obj, function()
				--移动到x, y处
				task.MoveTo(x, y, 90, MOVE_ACC_DEC)
				local a = Angle(obj, player)
				for i = 1, 10 do
					for j = 0, 2 do
						accbullet(stg.arrow_big, 10 - 2*j, obj.x, obj.y, 1.25 + 0.25*j, a + 36*i + 12*j, 120)
					end
				end
				PlaySound("kira00")
				Del(obj)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 70, 60, MOVE_NORMAL)
	end)
	--692
	task.New(self, function()
		do
			s3A_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 56)
		while true do
			for u = -1, 1, 2 do
				for i = 0, 5 do
					f1(192*u, -50 + 39*i)
					PlaySound("kira00")
					task.Wait(13)
				end
				move_rd(60, 70, 10, nil, 10, 20, -40, 40)
				task.Wait(72)
			end
			for i = 0, 5 do
				for u = -1, 1, 2 do
					f1((192 - 32.5*i)*u, 200)
				end
				PlaySound("kira00")
				task.Wait(13)
			end
			task.Wait(196)
		end
	end)
end
local function card1_init_Keine_H(self)
	--New(egg.updateFileObject, "EISlib/stage/stage3/bossA/bossA_main.lua")
	local f1, f2
	do
		function f1(x, y)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic6"
			obj.hscale, obj.vscale = 0, 0
			obj.timer = 11
			obj.colli = false
			egg.SimSizeCh(obj, 0, 0.75, 20)
			task.New(obj, function()
				--移动到x, y处
				task.MoveTo(x, y, 90, MOVE_ACC_DEC)
				local a = Angle(obj, player)
				for i = 1, 12 do
					for j = 0, 2 do
						accbullet(stg.arrow_big, 10 - 2*j, obj.x, obj.y, 1.25 + 0.25*j, a + 30*i + 10*j, 120)
					end
				end
				PlaySound("kira00")
				Del(obj)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 70, 60, MOVE_NORMAL)
	end)
	--692
	task.New(self, function()
		do
			s3A_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 56)
		while true do
			for u = -1, 1, 2 do
				for i = 0, 7 do
					f1(192*u, -50 + 30*i)
					PlaySound("kira00")
					task.Wait(10)
				end
				move_rd(60, 70, 10, nil, 10, 20, -40, 40)
				task.Wait(70)
			end
			for i = 0, 7 do
				for u = -1, 1, 2 do
					f1((192 - 25*i)*u, 200)
				end
				PlaySound("kira00")
				task.Wait(10)
			end
			task.Wait(192)
		end
	end)
end
local function card1_init_Keine_L(self)
	--New(egg.updateFileObject, "EISlib/stage/stage3/bossA/bossA_main.lua")
	local f1, f2
	do
		function f1(x, y)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic6"
			obj.hscale, obj.vscale = 0, 0
			obj.timer = 11
			obj.colli = false
			egg.SimSizeCh(obj, 0, 0.75, 20)
			task.New(obj, function()
				--移动到x, y处
				task.MoveTo(x, y, 90, MOVE_ACC_DEC)
				local a = Angle(obj, player)
				for i = 1, 15 do
					for j = 0, 3 do
						accbullet(stg.arrow_big, 10 - 2*j, obj.x, obj.y, 1.25 + 0.25*j, a + 24*i + 8*j, 120)
					end
				end
				PlaySound("kira00")
				Del(obj)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 70, 60, MOVE_NORMAL)
	end)
	--692
	task.New(self, function()
		do
			s3A_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 56)
		while true do
			for u = -1, 1, 2 do
				for i = 0, 7 do
					f1(192*u, -50 + 30*i)
					PlaySound("kira00")
					task.Wait(10)
				end
				move_rd(60, 70, 10, nil, 10, 20, -40, 40)
				task.Wait(70)
			end
			for i = 0, 7 do
				for u = -1, 1, 2 do
					f1((192 - 25*i)*u, 200)
				end
				PlaySound("kira00")
				task.Wait(10)
			end
			task.Wait(192)
		end
	end)
end
local function card1_del_Keine_ENH(self)
	Spell_break_eff(self.x, self.y, 0, 100, 255,
			'bamboo_leaf_white', 'tree_leaf_white')
end
local function card1_del_Keine_L(self)
	Spell_break_eff(self.x, self.y, 0, 100, 255,
			'bamboo_leaf_white', 'tree_leaf_white')
	self._wisys:setAction("normal", 1)
end
local _card1_init = create_diff_function(
		{ card1_init_Mokou_E, card1_init_Mokou_N, card1_init_Mokou_H, card1_init_Mokou_L },
		{ card1_init_Keine_E, card1_init_Keine_N, card1_init_Keine_H, card1_init_Keine_L },
		true,
		{
			{cardname.card1.mokou.EN, cardname.card1.keine.EN},
			{cardname.card1.mokou.EN, cardname.card1.keine.EN},
			{cardname.card1.mokou.HL, cardname.card1.keine.HL},
			{cardname.card1.mokou.HL, cardname.card1.keine.HL},
		})
local _card1_del = create_diff_function(
		{ card1_del_Mokou_ENHL, card1_del_Mokou_ENHL, card1_del_Mokou_ENHL, card1_del_Mokou_ENHL },
		{ card1_del_Keine_ENH, card1_del_Keine_ENH, card1_del_Keine_ENH, card1_del_Keine_L },
		false)
-- 需要处理一下妹红的碰撞组……不然迟早一头撞死玩家
local function card1_init(self)
	self.mokou.group = GROUP_NONTJT
	_card1_init(self)
end
local function card1_del(self)
	_card1_del(self)
	self.mokou.group = GROUP_ENEMY
end
--endregion

--region normal 2
local function normal2_init_Mokou_E(self)
	--New(egg.updateFileObject, "EISlib/stage/stage3/bossA/bossA_main.lua")
	self._wisys:setAction("normal", 1)
	local f1, f2
	do
		function f1(x, y, v, a)
			local obj = stg.newBulletStraight(stg.square, 2, true, x, y, v, a)
			task.New(obj, function()
				obj.layer = LAYER_ENEMY_BULLET+1
			end)
		end
	end
	--300f一轮
	task.New(self, function()
		do
			task.MoveTo(0, 144, 60, MOVE_DECEL)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
		end
		local a, a0, r
		while true do
			for u = -1, 1, 2 do
				a = Angle(self, player)
				for i = -6, 6 do
					r, a0 = 30 + 5*abs(i), a + 15*i*u
					for j = 0, 4 do
						f1(self.x + r*cos(a0), self.y + r*sin(a0), 1 + 0.15*j, a0)
					end
					PlaySound("kira00")
					task.Wait(4)
				end
				task.Wait(40)
				task.MoveToPlayer(30, -40, 40, 140, 150, 16, 32, 5, 10, MOVE_DECEL, MOVE_RANDOM)
			end
			task.Wait(20)
			a = Angle(self, player)
			for i = -3, 3 do
				_object.set_color(stg.newBulletStraight(stg.ball_big, 1, true, self.x, self.y, 1.5, a + 18*i), "", 255, 255, 255, 255)
			end
			PlaySound("kira00")
			task.Wait(36)
		end
	end)
end
local function normal2_init_Mokou_N(self)
	--New(egg.updateFileObject, "EISlib/stage/stage3/bossA/bossA_main.lua")
	self._wisys:setAction("normal", 1)
	local f1, f2
	do
		function f1(x, y, v, a)
			local obj = stg.newBulletStraight(stg.square, 2, true, x, y, v, a)
			task.New(obj, function()
				obj.layer = LAYER_ENEMY_BULLET+1
			end)
		end
	end
	--300f一轮
	task.New(self, function()
		do
			task.MoveTo(0, 144, 60, MOVE_DECEL)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
		end
		local a, a0, r
		while true do
			for u = -1, 1, 2 do
				a = Angle(self, player)
				for i = -10, 10 do
					r, a0 = 30 + 5*abs(i), a + 15*i*u
					for j = 0, 8 do
						f1(self.x + r*cos(a0), self.y + r*sin(a0), 1 + 0.15*j, a0)
					end
					PlaySound("kira00")
					task.Wait(3)
				end
				task.Wait(29)
				task.MoveToPlayer(30, -40, 40, 140, 150, 16, 32, 5, 10, MOVE_DECEL, MOVE_RANDOM)
			end
			task.Wait(20)
			a = Angle(self, player)
			for i = -4, 4 do
				_object.set_color(stg.newBulletStraight(stg.ball_big, 1, true, self.x, self.y, 1.5, a + 12*i), "", 255, 255, 255, 255)
			end
			PlaySound("kira00")
			task.Wait(36)
		end
	end)
end
local function normal2_init_Mokou_H(self)
	--New(egg.updateFileObject, "EISlib/stage/stage3/bossA/bossA_main.lua")
	self._wisys:setAction("normal", 1)
	local f1, f2
	do
		function f1(x, y, v, a)
			local obj = stg.newBulletStraight(stg.square, 2, true, x, y, v, a)
			task.New(obj, function()
				obj.layer = LAYER_ENEMY_BULLET+1
			end)
		end
	end
	--300f一轮
	task.New(self, function()
		do
			task.MoveTo(0, 144, 60, MOVE_DECEL)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
		end
		local a, a0, r
		while true do
			for u = -1, 1, 2 do
				a = Angle(self, player)
				for i = -12, 12 do
					r, a0 = 30 + 5*abs(i), a + 15*i*u
					for j = 0, 11 do
						f1(self.x + r*cos(a0), self.y + r*sin(a0), 1 + 0.15*j, a0)
					end
					PlaySound("kira00")
					task.Wait(2)
				end
				task.Wait(42)
				task.MoveToPlayer(30, -40, 40, 140, 150, 16, 32, 5, 10, MOVE_DECEL, MOVE_RANDOM)
			end
			task.Wait(20)
			a = Angle(self, player)
			for i = -4, 4 do
				_object.set_color(stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 1.5, a + 12*i), "mul+add", 255, 255, 255, 255)
			end
			PlaySound("kira00")
			task.Wait(36)
		end
	end)
end
local function normal2_init_Mokou_L(self)
	--New(egg.updateFileObject, "EISlib/stage/stage3/bossA/bossA_main.lua")
	self._wisys:setAction("normal", 1)
	local f1, f2
	do
		function f1(x, y, v, a)
			local obj = stg.newBulletStraight(stg.square, 2, true, x, y, v, a)
			task.New(obj, function()
				obj.layer = LAYER_ENEMY_BULLET+1
			end)
		end
	end
	--300f一轮
	task.New(self, function()
		do
			task.MoveTo(0, 144, 60, MOVE_DECEL)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
		end
		local a, a0, r
		while true do
			for u = -1, 1, 2 do
				a = Angle(self, player)
				for i = -15, 15 do
					r, a0 = 30 + 5*abs(i), a + 12*i*u
					for j = 0, 18 do
						f1(self.x + r*cos(a0), self.y + r*sin(a0), 1 + 0.15*j, a0)
					end
					PlaySound("kira00")
					task.Wait(2)
				end
				task.Wait(30)
				task.MoveToPlayer(30, -40, 40, 140, 150, 16, 32, 5, 10, MOVE_DECEL, MOVE_RANDOM)
			end
			task.Wait(20)
			a = Angle(self, player)
			for i = -5, 5 do
				_object.set_color(stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 1.5, a + 10*i), "mul+add", 255, 255, 255, 255)
			end
			PlaySound("kira00")
			task.Wait(36)
		end
	end)
end
local function normal2_init_Keine_E(self)
	local f1, f1_1, f1_2
	do
		--慧音使魔
		function f1_1(a, u)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic6"
			obj.hscale, obj.vscale = 0.75, 0.75
			obj.colli = false
			--移动与攻击
			task.New(obj, function()
				task.MoveTo(obj.x + 60*cos(a), obj.y + 60*sin(a), 60, MOVE_ACC_DEC)
				for k = 1, 10 do
					a = Angle(obj, player)
					for i = 0, 0 do
						for j = 0, 0 do
							stg.newBulletStraight(stg.ball_mid, 6, true, obj.x, obj.y, 2 + 0.2*j, a - 36*k*u + 15*i)
						end
					end
					PlaySound("tan00")
					task.Wait(10)
				end
				Del(obj)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 100, 60, MOVE_DECEL)
		do
			task.Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
			task.Wait(60)
		end
		self._wisys:setAction("cast", 56)
		local a
		while true do
			for u = -1, 1, 2 do
				for i = 1, 6 do
					f1_1(60*i, u)
				end
				PlaySound("kira00")
				task.Wait(120)
				a = Angle(self, player)
				for i = -3, 3 do
					_object.set_color(stg.newBulletStraight(stg.ball_big, 8, true, self.x, self.y, 1.5, a + 18*i), "", 255, 255, 255, 255)
				end
				PlaySound("kira00")
				task.Wait(40)
				for i = 1, 6 do
					f1_1(60*i, u)
				end
				task.Wait(80)
				task.MoveToPlayer(60, -40, 40, 100, 120, 16, 32, 5, 10, MOVE_DECEL, MOVE_RANDOM)
			end
		end
	end)
end
local function normal2_init_Keine_N(self)
	local f1, f1_1, f1_2
	do
		--慧音使魔
		function f1_1(a, u)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic6"
			obj.hscale, obj.vscale = 0.75, 0.75
			obj.colli = false
			--移动与攻击
			task.New(obj, function()
				task.MoveTo(obj.x + 60*cos(a), obj.y + 60*sin(a), 60, MOVE_ACC_DEC)
				for k = 1, 20 do
					a = Angle(obj, player)
					for i = 0, 0 do
						for j = 0, 1 do
							stg.newBulletStraight(stg.ball_mid, 6, true, obj.x, obj.y, 2 + 0.2*j, a - 36*k*u + 15*i)
						end
					end
					PlaySound("tan00")
					task.Wait(5)
				end
				Del(obj)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 100, 60, MOVE_DECEL)
		do
			task.Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
			task.Wait(60)
		end
		self._wisys:setAction("cast", 56)
		local a
		while true do
			for u = -1, 1, 2 do
				for i = 1, 6 do
					f1_1(60*i, u)
				end
				PlaySound("kira00")
				task.Wait(120)
				a = Angle(self, player)
				for i = -4, 4 do
					_object.set_color(stg.newBulletStraight(stg.ball_big, 8, true, self.x, self.y, 1.5, a + 12*i), "", 255, 255, 255, 255)
				end
				PlaySound("kira00")
				task.Wait(40)
				for i = 1, 6 do
					f1_1(60*i, u)
				end
				task.Wait(80)
				task.MoveToPlayer(60, -40, 40, 100, 120, 16, 32, 5, 10, MOVE_DECEL, MOVE_RANDOM)
			end
		end
	end)
end
local function normal2_init_Keine_H(self)
	local f1, f1_1, f1_2
	do
		--慧音使魔
		function f1_1(a, u)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic6"
			obj.hscale, obj.vscale = 0.75, 0.75
			obj.colli = false
			--移动与攻击
			task.New(obj, function()
				task.MoveTo(obj.x + 60*cos(a), obj.y + 60*sin(a), 60, MOVE_ACC_DEC)
				for k = 1, 20 do
					a = Angle(obj, player)
					for i = -1, 1 do
						for j = 0, 2 do
							stg.newBulletStraight(stg.ball_mid, 6, true, obj.x, obj.y, 2 + 0.2*j, a - 36*k*u + 15*i)
						end
					end
					PlaySound("tan00")
					task.Wait(5)
				end
				Del(obj)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 100, 60, MOVE_DECEL)
		do
			task.Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
			task.Wait(60)
		end
		self._wisys:setAction("cast", 56)
		local a
		while true do
			for u = -1, 1, 2 do
				for i = 1, 6 do
					f1_1(60*i, u)
				end
				PlaySound("kira00")
				task.Wait(120)
				a = Angle(self, player)
				for i = -4, 4 do
					_object.set_color(stg.newBulletStraight(stg.ball_huge, 8, true, self.x, self.y, 1.5, a + 12*i), "mul+add", 255, 255, 255, 255)
				end
				PlaySound("kira00")
				task.Wait(40)
				for i = 1, 6 do
					f1_1(60*i, u)
				end
				task.Wait(80)
				task.MoveToPlayer(60, -40, 40, 100, 120, 16, 32, 5, 10, MOVE_DECEL, MOVE_RANDOM)
			end
		end
	end)
end
local function normal2_init_Keine_L(self)
	local f1, f1_1, f1_2
	do
		--慧音使魔
		function f1_1(a, u)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic6"
			obj.hscale, obj.vscale = 0.75, 0.75
			obj.colli = false
			--移动与攻击
			task.New(obj, function()
				task.MoveTo(obj.x + 60*cos(a), obj.y + 60*sin(a), 60, MOVE_ACC_DEC)
				for k = 1, 20 do
					a = Angle(obj, player)
					for i = -1, 1 do
						for j = 0, 3 do
							stg.newBulletStraight(stg.ball_mid, 6, true, obj.x, obj.y, 2 + 0.2*j, a - 36*k*u + 15*i)
						end
					end
					PlaySound("tan00")
					task.Wait(5)
				end
				Del(obj)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 100, 60, MOVE_DECEL)
		do
			task.Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
			task.Wait(60)
		end
		self._wisys:setAction("cast", 56)
		local a
		while true do
			for u = -1, 1, 2 do
				for i = 1, 6 do
					f1_1(60*i, u)
				end
				PlaySound("kira00")
				task.Wait(120)
				a = Angle(self, player)
				for i = -5, 5 do
					_object.set_color(stg.newBulletStraight(stg.ball_huge, 8, true, self.x, self.y, 1.5, a + 10*i), "mul+add", 255, 255, 255, 255)
				end
				PlaySound("kira00")
				task.Wait(40)
				for i = 1, 6 do
					f1_1(60*i, u)
				end
				task.Wait(80)
				task.MoveToPlayer(60, -40, 40, 100, 120, 16, 32, 5, 10, MOVE_DECEL, MOVE_RANDOM)
			end
		end
	end)
end
local function normal2_del_Keine_L(self)
	self._wisys:setAction("normal", 1)
end
local normal2_init = create_diff_function(
		{ normal2_init_Mokou_E, normal2_init_Mokou_N, normal2_init_Mokou_H, normal2_init_Mokou_L },
		{ normal2_init_Keine_E, normal2_init_Keine_N, normal2_init_Keine_H, normal2_init_Keine_L },
		true)
local normal2_del = create_diff_function(
		{ false, false, false, false },
		{ false, false, false, normal2_del_Keine_L },
		false)
--endregion

--region card 2
local function card2_init_Mokou_E(self)
	local f1, f1_1, f2
	do
		function f1(x, y, a)
			local obj = New(laser, COLOR_RED, x, y, 0, 0, 0, 0, 15, 20, 0)
			task.New(obj, function()
				laser.ChangeImage(obj, 2)
				_object.set_color(obj, "mul+add", 255, 255, 25, 25)
				laser._TurnHalfOn(obj, 1, false)
				obj.rot = a
				local aerfa, _d_aerfa = (0), (90 / 4)
				for _ = 1, 5 do
					obj.l2 = 750 * sin(aerfa)
					task.Wait(1)
					aerfa = aerfa + _d_aerfa
				end
				task.Wait(30)
				laser._TurnOn(obj, 10, false, true)
				misc.ShakeScreen(30, 3)
				PlaySound("enep00")
				for i = 0, 4 do
					f1_1(x, y, 1.5 + 1.5*i)
				end
				laser._TurnOff(obj, 50, true)
				Del(obj)
			end)
		end
		function f1_1(x, y, v, a)
			local obj = stg.newBulletStraight(stg.water_drop, 1, true, x, y, 0, 90)
			_object.set_color(obj, "mul+add", 255, 255, 255, 255)
			egg.AddSimStrChV(obj, v, 1, a, 90)
			task.New(obj, function()
				task.Wait(90)
				obj.navi = true
				egg.AddSimStrChV(obj, 0, 3.25, -90 + ran:Float(-7.5, 7.5), 60)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 50, 60, MOVE_DECEL)
	end)
	task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
		end
		do
			while true do
				local x = player.x
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task.Wait(60)
				x = player.x
				task.MoveTo(x, 180, 60, MOVE_DECEL)
				local a = -90
				for _ = 1, 3 do
					last = New(_editor_class["s3_妹红踢预警"], self.x, self.y, a, COLOR_RED)
					task._Wait(10)
				end
				task.Wait(60)
				self._wisys:setAction("cast", 64)
				--New(trail2, self, 20, 1, self.img, 1, "mul+add", 30, 0.75, false)
				task.MoveTo(x, -230, 30, MOVE_ACCEL)
				PlaySound("gun00")
				misc.ShakeScreen(300, 5)
				--火焰股间摩擦
				task.New(self, function()
					local a1, da1 = 90, 0
					for _ = 1, 18 do
						for _ = 1, 2 do
							New(_editor_class["s3_妹红踢魔炮"], self.x, self.y, ran:Float(15, 19), a1 + ran:Float(-2, 2), COLOR_RED)
							New(_editor_class["s3_妹红踢魔炮"], self.x, self.y, ran:Float(15, 19), a1 + ran:Float(-2, 2), COLOR_YELLOW)
						end
						task.Wait(5)
						a1 = a1 + da1
					end
				end)
				task.New(self, function()
					local a1, da1 = 90, 0
					for _ = 1, 16 do
						New(_editor_class["s3_妹红踢爆炸效果"], self.x, self.y, ran:Float(12, 16), a1 + ran:Float(-3, 3))
						for i = -1, 1 do
							f1_1(self.x, self.y, ran:Float(4, 10), 90 + ran:Float(-5, 5) + 20*i)
						end
						task.Wait(5)
						a1 = a1 + da1
					end
				end)
				--[[do
					local aerfa, _d_aerfa = (90), (90 / 15)
					for _ = 1, 10 do
						local r = 450 * sin(aerfa)
						local rr = 450
						f1(x + rr - r, self.y, 90)
						f1(x - rr + r, self.y, 90)
						--New(_editor_class["s3_妹红激光预警"], x + rr - r, self.y, 90, 9)
						--New(_editor_class["s3_妹红激光预警"], x + r - rr, self.y, 90, 9)
						task.Wait(4)
						aerfa = aerfa + _d_aerfa
					end
				end]]
				task.Wait(160)
				task.MoveTo(x, 50, 60, MOVE_DECEL)
				task.Wait(90)
			end
		end
	end)
end
local function card2_init_Mokou_N(self)
	local f1, f1_1, f2
	do
		function f1(x, y, a)
			local obj = New(laser, COLOR_RED, x, y, 0, 0, 0, 0, 15, 20, 0)
			task.New(obj, function()
				laser.ChangeImage(obj, 2)
				_object.set_color(obj, "mul+add", 255, 255, 25, 25)
				laser._TurnHalfOn(obj, 1, false)
				obj.rot = a
				local aerfa, _d_aerfa = (0), (90 / 4)
				for _ = 1, 5 do
					obj.l2 = 750 * sin(aerfa)
					task.Wait(1)
					aerfa = aerfa + _d_aerfa
				end
				task.Wait(30)
				laser._TurnOn(obj, 10, false, true)
				misc.ShakeScreen(30, 3)
				PlaySound("enep00")
				for i = 0, 4 do
					f1_1(x, y, 1.5 + 1.5*i)
				end
				laser._TurnOff(obj, 50, true)
				Del(obj)
			end)
		end
		function f1_1(x, y, v, a)
			local obj = stg.newBulletStraight(stg.water_drop, 1, true, x, y, 0, 90)
			_object.set_color(obj, "mul+add", 255, 255, 255, 255)
			egg.AddSimStrChV(obj, v, 1, a, 90)
			task.New(obj, function()
				task.Wait(90)
				obj.navi = true
				egg.AddSimStrChV(obj, 0, 3.25, -90 + ran:Float(-7.5, 7.5), 60)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 50, 60, MOVE_DECEL)
	end)
	task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
		end
		do
			while true do
				local x = player.x
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task.Wait(60)
				x = player.x
				task.MoveTo(x, 180, 60, MOVE_DECEL)
				local a = -90
				for _ = 1, 3 do
					last = New(_editor_class["s3_妹红踢预警"], self.x, self.y, a, COLOR_RED)
					task._Wait(10)
				end
				task.Wait(60)
				self._wisys:setAction("cast", 64)
				--New(trail2, self, 20, 1, self.img, 1, "mul+add", 30, 0.75, false)
				task.MoveTo(x, -230, 30, MOVE_ACCEL)
				PlaySound("gun00")
				misc.ShakeScreen(300, 5)
				--火焰股间摩擦
				task.New(self, function()
					local a1, da1 = 90, 0
					for _ = 1, 18 do
						for _ = 1, 2 do
							New(_editor_class["s3_妹红踢魔炮"], self.x, self.y, ran:Float(15, 19), a1 + ran:Float(-2, 2), COLOR_RED)
							New(_editor_class["s3_妹红踢魔炮"], self.x, self.y, ran:Float(15, 19), a1 + ran:Float(-2, 2), COLOR_YELLOW)
						end
						task.Wait(5)
						a1 = a1 + da1
					end
				end)
				task.New(self, function()
					local a1, da1 = 90, 0
					for _ = 1, 16 do
						New(_editor_class["s3_妹红踢爆炸效果"], self.x, self.y, ran:Float(12, 16), a1 + ran:Float(-3, 3))
						for i = -3, 3 do
							f1_1(self.x, self.y, ran:Float(4, 10), 90 + ran:Float(-5, 5) + 10*i)
						end
						task.Wait(5)
						a1 = a1 + da1
					end
				end)
				--[[do
					local aerfa, _d_aerfa = (90), (90 / 15)
					for _ = 1, 10 do
						local r = 450 * sin(aerfa)
						local rr = 450
						f1(x + rr - r, self.y, 90)
						f1(x - rr + r, self.y, 90)
						--New(_editor_class["s3_妹红激光预警"], x + rr - r, self.y, 90, 9)
						--New(_editor_class["s3_妹红激光预警"], x + r - rr, self.y, 90, 9)
						task.Wait(4)
						aerfa = aerfa + _d_aerfa
					end
				end]]
				task.Wait(120 + 40)
				task.MoveTo(x, 50, 60, MOVE_DECEL)
				task.Wait(90)
			end
		end
	end)
end
local function card2_init_Mokou_H(self)
	local f1, f1_1, f2
	do
		function f1(x, y, a)
			local obj = New(laser, COLOR_RED, x, y, 0, 0, 0, 0, 15, 20, 0)
			task.New(obj, function()
				laser.ChangeImage(obj, 2)
				_object.set_color(obj, "mul+add", 255, 255, 25, 25)
				laser._TurnHalfOn(obj, 1, false)
				obj.rot = a
				local aerfa, _d_aerfa = (0), (90 / 4)
				for _ = 1, 5 do
					obj.l2 = 750 * sin(aerfa)
					task.Wait(1)
					aerfa = aerfa + _d_aerfa
				end
				task.Wait(30)
				laser._TurnOn(obj, 10, false, true)
				misc.ShakeScreen(30, 3)
				PlaySound("enep00")
				for i = 0, 6 do
					f1_1(x, y, 1.5 + 1*i)
				end
				laser._TurnOff(obj, 50, true)
				Del(obj)
			end)
		end
		function f1_1(x, y, v)
			local obj = stg.newBulletStraight(stg.water_drop, 1, true, x, y, 0, 90)
			_object.set_color(obj, "mul+add", 255, 255, 255, 255)
			egg.AddSimStrChV(obj, v, 1, 90, 90)
			task.New(obj, function()
				task.Wait(90)
				obj.navi = true
				egg.AddSimStrChV(obj, 0, 3.25, -90 + ran:Float(-7.5, 7.5), 60)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 50, 60, MOVE_DECEL)
	end)
	task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
		end
		do
			while true do
				local x = player.x
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task.Wait(60)
				x = player.x
				task.MoveTo(x, 180, 60, MOVE_DECEL)
				local a = -90
				for _ = 1, 3 do
					last = New(_editor_class["s3_妹红踢预警"], self.x, self.y, a, COLOR_RED)
					task._Wait(10)
				end
				task.Wait(60)
				self._wisys:setAction("cast", 64)
				--New(trail2, self, 20, 1, self.img, 1, "mul+add", 30, 0.75, false)
				task.MoveTo(x, -230, 30, MOVE_ACCEL)
				PlaySound("gun00")
				misc.ShakeScreen(300, 5)
				--火焰股间摩擦
				task.New(self, function()
					local a1, da1 = 90, 0
					for _ = 1, 18 do
						for _ = 1, 2 do
							New(_editor_class["s3_妹红踢魔炮"], self.x, self.y, ran:Float(15, 19), a1 + ran:Float(-2, 2), COLOR_RED)
							New(_editor_class["s3_妹红踢魔炮"], self.x, self.y, ran:Float(15, 19), a1 + ran:Float(-2, 2), COLOR_YELLOW)
						end
						task.Wait(5)
						a1 = a1 + da1
					end
				end)
				task.New(self, function()
					local a1, da1 = 90, 0
					for _ = 1, 16 do
						New(_editor_class["s3_妹红踢爆炸效果"], self.x, self.y, ran:Float(12, 16), a1 + ran:Float(-3, 3))
						task.Wait(5)
						a1 = a1 + da1
					end
				end)
				do
					local aerfa, _d_aerfa = (90), (90 / 15)
					for _ = 1, 15 do
						local r = 450 * sin(aerfa)
						local rr = 450
						f1(x + rr - r, self.y, 90)
						f1(x - rr + r, self.y, 90)
						--New(_editor_class["s3_妹红激光预警"], x + rr - r, self.y, 90, 9)
						--New(_editor_class["s3_妹红激光预警"], x + r - rr, self.y, 90, 9)
						task.Wait(2)
						aerfa = aerfa + _d_aerfa
					end
				end
				task.Wait(120)
				task.MoveTo(x, 50, 60, MOVE_DECEL)
				task.Wait(90)
			end
		end
	end)
end
local function card2_init_Mokou_L(self)
	local f1, f1_1, f2
	do
		function f1(x, y, a)
			local obj = New(laser, COLOR_RED, x, y, 0, 0, 0, 0, 15, 20, 0)
			task.New(obj, function()
				laser.ChangeImage(obj, 2)
				_object.set_color(obj, "mul+add", 255, 255, 25, 25)
				laser._TurnHalfOn(obj, 1, false)
				obj.rot = a
				local aerfa, _d_aerfa = (0), (90 / 4)
				for _ = 1, 5 do
					obj.l2 = 750 * sin(aerfa)
					task.Wait(1)
					aerfa = aerfa + _d_aerfa
				end
				task.Wait(30)
				laser._TurnOn(obj, 10, false, true)
				misc.ShakeScreen(30, 3)
				PlaySound("enep00")
				for i = 0, 9 do
					f1_1(x, y, 1.5 + 0.75*i)
				end
				laser._TurnOff(obj, 50, true)
				Del(obj)
			end)
		end
		function f1_1(x, y, v)
			local obj = stg.newBulletStraight(stg.water_drop, 1, true, x, y, 0, 90)
			_object.set_color(obj, "mul+add", 255, 255, 255, 255)
			egg.AddSimStrChV(obj, v, 1, 90, 90)
			task.New(obj, function()
				task.Wait(90)
				obj.navi = true
				egg.AddSimStrChV(obj, 0, 3.25, -90 + ran:Float(-7.5, 7.5), 60)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 50, 60, MOVE_DECEL)
	end)
	task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
		end
		do
			while true do
				local x = player.x
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task.Wait(60)
				x = player.x
				task.MoveTo(x, 180, 60, MOVE_DECEL)
				local a = -90
				for _ = 1, 3 do
					last = New(_editor_class["s3_妹红踢预警"], self.x, self.y, a, COLOR_RED)
					task._Wait(10)
				end
				task.Wait(60)
				self._wisys:setAction("cast", 64)
				--New(trail2, self, 20, 1, self.img, 1, "mul+add", 30, 0.75, false)
				task.MoveTo(x, -230, 30, MOVE_ACCEL)
				PlaySound("gun00")
				misc.ShakeScreen(300, 5)
				--火焰股间摩擦
				task.New(self, function()
					local a1, da1 = 90, 0
					for _ = 1, 18 do
						for _ = 1, 2 do
							New(_editor_class["s3_妹红踢魔炮"], self.x, self.y, ran:Float(15, 19), a1 + ran:Float(-2, 2), COLOR_RED)
							New(_editor_class["s3_妹红踢魔炮"], self.x, self.y, ran:Float(15, 19), a1 + ran:Float(-2, 2), COLOR_YELLOW)
						end
						task.Wait(5)
						a1 = a1 + da1
					end
				end)
				task.New(self, function()
					local a1, da1 = 90, 0
					for _ = 1, 16 do
						New(_editor_class["s3_妹红踢爆炸效果"], self.x, self.y, ran:Float(12, 16), a1 + ran:Float(-3, 3))
						task.Wait(5)
						a1 = a1 + da1
					end
				end)
				do
					local aerfa, _d_aerfa = (90), (90 / 20)
					for _ = 1, 20 do
						local r = 450 * sin(aerfa)
						local rr = 450
						f1(x + rr - r, self.y, 90)
						f1(x - rr + r, self.y, 90)
						--New(_editor_class["s3_妹红激光预警"], x + rr - r, self.y, 90, 9)
						--New(_editor_class["s3_妹红激光预警"], x + r - rr, self.y, 90, 9)
						task.Wait(2)
						aerfa = aerfa + _d_aerfa
					end
				end
				task.Wait(120)
				task.MoveTo(x, 50, 60, MOVE_DECEL)
				task.Wait(90)
			end
		end
	end)
end
local function card2_del_Mokou_ENHL(self)
	Spell_break_eff(self.x, self.y, 255, 0, 0,
			'bamboo_leaf_white', 'tree_leaf_white')
end
local function card2_init_Keine_E(self)
	--New(egg.updateFileObject, "EISlib/stage/stage3/bossA/bossA_main.lua")
	local f1, f1_1, f1_2, f2
	do
		function f1(x, y, a, u)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic6"
			obj.hscale, obj.vscale = 0, 0
			obj.timer = 11
			obj.colli = false
			egg.SimSizeCh(obj, 0, 0.75, 20)
			task.New(obj, function()
				--移动到x, y处
				task.MoveTo(x, y, 60, MOVE_ACC_DEC)
				local r, dr = 0, 30/30
				for _ = 1, 30 do
					r = r + dr
					obj.x, obj.y = x + r*cos(a), y + r*sin(a)
					task.Wait(1)
				end
				--旋转一圈并且攻击
				task.New(obj, function()
					for _ = 1, 6 do
						f1_1(obj.x, obj.y, a + 180)
						task.Wait(10)
					end
					for _ = 1, 8 do
						for i = -1, 1, 2 do
							stg.newBulletStraight(stg.arrow_big, 6, true, obj.x, obj.y, 1.5, a + 180 + 120*i)
						end
						PlaySound("tan00")
						task.Wait(15)
					end
				end)
				local da = 360/60*u
				for _ = 1, 180 do
					a = a + da
					obj.x, obj.y = x + r*cos(a), y + r*sin(a)
					task.Wait(1)
				end
				Del(obj)
			end)
		end
		function f1_1(x, y, a)
			local obj = stg.newBulletStraight(stg.ball_light, 5, true, x, y, 0, a, true)
			_object.set_color(obj, "mul+add", 255, 255, 255, 255)
			obj.hscale, obj.vscale = 0, 0.2
			obj.a, obj.b = 0, 0.2*obj.b
			obj.bound = false
			obj.hide = true
			obj.colli = false
			task.New(obj, function()
				--New(lasereff, x, y, a, 0, 0, 255)
				f1_2(x, y, a)
				task.Wait(60)
				PlaySound("lazer01")
				SetV(obj, 15, a)
				obj.hide = false
				obj.colli = true
				task.New(obj, function()
					local dh = 0.75
					for _ = 1, 20 do
						obj.hscale = obj.hscale + dh
						obj.a = obj.a + 12*dh
						task.Wait(1)
					end
					task.Wait(120)
					obj.bound = true
				end)
			end)
		end
		function f1_2(x, y, a)
			local obj = stg.newBulletStraight(stg.ball_light, 5, true, x, y, 0, a, true)
			_object.set_color(obj, "mul+add", 255, 150, 255, 255)
			obj.img = "white"
			obj.bound = false
			obj.x, obj.y = x + 300*cos(a), y + 300*sin(a)
			obj.rot = a
			obj.layer = LAYER_ENEMY_BULLET-1
			obj.hscale, obj.vscale = 75, 0
			task.New(obj, function()
				local dv = 0.1/10
				for _ = 1, 10 do
					obj.vscale = obj.vscale + dv
					task.Wait(1)
				end
				task.Wait(60)
				dv = -dv
				for _ = 1, 10 do
					obj.vscale = obj.vscale + dv
					task.Wait(1)
				end
				Del(obj)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 144, 60, MOVE_NORMAL)
	end)
	task.New(self, function()
		do
			s3A_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 9999)
		while true do
			task.Wait(240)
			for u = -1, 1, 2 do
				--上面两团使魔
				for i = 0, 2 do
					f1(self.x + 75*cos(90 + 60*u), self.y + 75*sin(90 + 60*u), -90 + 120*i, u)
				end
				--中间的使魔
				for i = -1, 1, 2 do
					f1(self.x + 75*cos(-90), self.y + 75*sin(-90), (u+i)*90, u*i)
				end
			end
			task.Wait(290)
		end
	end)
end
local function card2_init_Keine_N(self)
	--New(egg.updateFileObject, "EISlib/stage/stage3/bossA/bossA_main.lua")
	local f1, f1_1, f1_2, f2
	do
		function f1(x, y, a, u)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic6"
			obj.hscale, obj.vscale = 0, 0
			obj.timer = 11
			obj.colli = false
			egg.SimSizeCh(obj, 0, 0.75, 20)
			task.New(obj, function()
				--移动到x, y处
				task.MoveTo(x, y, 60, MOVE_ACC_DEC)
				local r, dr = 0, 30/30
				for _ = 1, 30 do
					r = r + dr
					obj.x, obj.y = x + r*cos(a), y + r*sin(a)
					task.Wait(1)
				end
				--旋转一圈并且攻击
				task.New(obj, function()
					for _ = 1, 12 do
						f1_1(obj.x, obj.y, a + 180)
						task.Wait(5)
					end
					for _ = 1, 10 do
						for i = -1, 1 do
							stg.newBulletStraight(stg.arrow_big, 6, true, obj.x, obj.y, 1.5, a + 180 + 120*i)
						end
						PlaySound("tan00")
						task.Wait(12)
					end
				end)
				local da = 360/60*u
				for _ = 1, 180 do
					a = a + da
					obj.x, obj.y = x + r*cos(a), y + r*sin(a)
					task.Wait(1)
				end
				Del(obj)
			end)
		end
		function f1_1(x, y, a)
			local obj = stg.newBulletStraight(stg.ball_light, 5, true, x, y, 0, a, true)
			_object.set_color(obj, "mul+add", 255, 255, 255, 255)
			obj.hscale, obj.vscale = 0, 0.2
			obj.a, obj.b = 0, 0.2*obj.b
			obj.bound = false
			obj.hide = true
			obj.colli = false
			task.New(obj, function()
				--New(lasereff, x, y, a, 0, 0, 255)
				f1_2(x, y, a)
				task.Wait(60)
				PlaySound("lazer01")
				SetV(obj, 15, a)
				obj.hide = false
				obj.colli = true
				task.New(obj, function()
					local dh = 0.75
					for _ = 1, 20 do
						obj.hscale = obj.hscale + dh
						obj.a = obj.a + 12*dh
						task.Wait(1)
					end
					task.Wait(120)
					obj.bound = true
				end)
			end)
		end
		function f1_2(x, y, a)
			local obj = stg.newBulletStraight(stg.ball_light, 5, true, x, y, 0, a, true)
			_object.set_color(obj, "mul+add", 255, 150, 255, 255)
			obj.img = "white"
			obj.bound = false
			obj.x, obj.y = x + 300*cos(a), y + 300*sin(a)
			obj.rot = a
			obj.layer = LAYER_ENEMY_BULLET-1
			obj.hscale, obj.vscale = 75, 0
			task.New(obj, function()
				local dv = 0.1/10
				for _ = 1, 10 do
					obj.vscale = obj.vscale + dv
					task.Wait(1)
				end
				task.Wait(60)
				dv = -dv
				for _ = 1, 10 do
					obj.vscale = obj.vscale + dv
					task.Wait(1)
				end
				Del(obj)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 144, 60, MOVE_NORMAL)
	end)
	task.New(self, function()
		do
			s3A_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 9999)
		while true do
			task.Wait(240)
			for u = -1, 1, 2 do
				--上面两团使魔
				for i = 0, 2 do
					f1(self.x + 75*cos(90 + 60*u), self.y + 75*sin(90 + 60*u), -90 + 120*i, u)
				end
				--中间的使魔
				for i = -1, 1, 2 do
					f1(self.x + 75*cos(-90), self.y + 75*sin(-90), (u+i)*90, u*i)
				end
			end
			task.Wait(290)
		end
	end)
end
local function card2_init_Keine_H(self)
	--New(egg.updateFileObject, "EISlib/stage/stage3/bossA/bossA_main.lua")
	local f1, f1_1, f1_2, f2
	do
		function f1(x, y, a, u)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic6"
			obj.hscale, obj.vscale = 0, 0
			obj.timer = 11
			obj.colli = false
			egg.SimSizeCh(obj, 0, 0.75, 20)
			task.New(obj, function()
				--移动到x, y处
				task.MoveTo(x, y, 60, MOVE_ACC_DEC)
				local r, dr = 0, 30/30
				for _ = 1, 30 do
					r = r + dr
					obj.x, obj.y = x + r*cos(a), y + r*sin(a)
					task.Wait(1)
				end
				--旋转一圈并且攻击
				task.New(obj, function()
					for _ = 1, 15 do
						f1_1(obj.x, obj.y, a + 180)
						task.Wait(4)
					end
					for _ = 1, 15 do
						for i = -1, 1 do
							stg.newBulletStraight(stg.arrow_big, 6, true, obj.x, obj.y, 1.5, a + 180 + 120*i)
						end
						PlaySound("tan00")
						task.Wait(8)
					end
				end)
				local da = 360/60*u
				for _ = 1, 180 do
					a = a + da
					obj.x, obj.y = x + r*cos(a), y + r*sin(a)
					task.Wait(1)
				end
				Del(obj)
			end)
		end
		function f1_1(x, y, a)
			local obj = stg.newBulletStraight(stg.ball_light, 5, true, x, y, 0, a, true)
			_object.set_color(obj, "mul+add", 255, 255, 255, 255)
			obj.hscale, obj.vscale = 0, 0.2
			obj.a, obj.b = 0, 0.2*obj.b
			obj.bound = false
			obj.hide = true
			obj.colli = false
			task.New(obj, function()
				--New(lasereff, x, y, a, 0, 0, 255)
				f1_2(x, y, a)
				task.Wait(60)
				PlaySound("lazer01")
				SetV(obj, 15, a)
				obj.hide = false
				obj.colli = true
				task.New(obj, function()
					local dh = 0.75
					for _ = 1, 20 do
						obj.hscale = obj.hscale + dh
						obj.a = obj.a + 12*dh
						task.Wait(1)
					end
					task.Wait(120)
					obj.bound = true
				end)
			end)
		end
		function f1_2(x, y, a)
			local obj = stg.newBulletStraight(stg.ball_light, 5, true, x, y, 0, a, true)
			_object.set_color(obj, "mul+add", 255, 150, 255, 255)
			obj.img = "white"
			obj.bound = false
			obj.x, obj.y = x + 300*cos(a), y + 300*sin(a)
			obj.rot = a
			obj.layer = LAYER_ENEMY_BULLET-1
			obj.hscale, obj.vscale = 75, 0
			task.New(obj, function()
				local dv = 0.1/10
				for _ = 1, 10 do
					obj.vscale = obj.vscale + dv
					task.Wait(1)
				end
				task.Wait(60)
				dv = -dv
				for _ = 1, 10 do
					obj.vscale = obj.vscale + dv
					task.Wait(1)
				end
				Del(obj)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 144, 60, MOVE_NORMAL)
	end)
	task.New(self, function()
		do
			s3A_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 9999)
		while true do
			task.Wait(240)
			for u = -1, 1, 2 do
				--上面两团使魔
				for i = 0, 2 do
					f1(self.x + 75*cos(90 + 60*u), self.y + 75*sin(90 + 60*u), -90 + 120*i, u)
				end
				--中间的使魔
				for i = -1, 1, 2 do
					f1(self.x + 75*cos(-90), self.y + 75*sin(-90), (u+i)*90, u*i)
				end
			end
			task.Wait(290)
		end
	end)
end
local function card2_init_Keine_L(self)
	--New(egg.updateFileObject, "EISlib/stage/stage3/bossA/bossA_main.lua")
	local f1, f1_1, f1_2, f2
	do
		function f1(x, y, a, u)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic6"
			obj.hscale, obj.vscale = 0, 0
			obj.timer = 11
			obj.colli = false
			egg.SimSizeCh(obj, 0, 0.75, 20)
			task.New(obj, function()
				--移动到x, y处
				task.MoveTo(x, y, 60, MOVE_ACC_DEC)
				local r, dr = 0, 30/30
				for _ = 1, 30 do
					r = r + dr
					obj.x, obj.y = x + r*cos(a), y + r*sin(a)
					task.Wait(1)
				end
				--旋转一圈并且攻击
				task.New(obj, function()
					for _ = 1, 20 do
						f1_1(obj.x, obj.y, a + 180)
						task.Wait(3)
					end
					for _ = 1, 15 do
						for i = -2, 2 do
							stg.newBulletStraight(stg.arrow_big, 6, true, obj.x, obj.y, 1.5, a + 180 + 60*i)
						end
						PlaySound("tan00")
						task.Wait(8)
					end
				end)
				local da = 360/60*u
				for _ = 1, 180 do
					a = a + da
					obj.x, obj.y = x + r*cos(a), y + r*sin(a)
					task.Wait(1)
				end
				Del(obj)
			end)
		end
		function f1_1(x, y, a)
			local obj = stg.newBulletStraight(stg.ball_light, 5, true, x, y, 0, a, true)
			_object.set_color(obj, "mul+add", 255, 255, 255, 255)
			obj.hscale, obj.vscale = 0, 0.2
			obj.a, obj.b = 0, 0.2*obj.b
			obj.bound = false
			obj.hide = true
			obj.colli = false
			task.New(obj, function()
				--New(lasereff, x, y, a, 0, 0, 255)
				f1_2(x, y, a)
				task.Wait(60)
				PlaySound("lazer01")
				SetV(obj, 15, a)
				obj.hide = false
				obj.colli = true
				task.New(obj, function()
					local dh = 0.75
					for _ = 1, 20 do
						obj.hscale = obj.hscale + dh
						obj.a = obj.a + 12*dh
						task.Wait(1)
					end
					task.Wait(120)
					obj.bound = true
				end)
			end)
		end
		function f1_2(x, y, a)
			local obj = stg.newBulletStraight(stg.ball_light, 5, true, x, y, 0, a, true)
			_object.set_color(obj, "mul+add", 255, 150, 255, 255)
			obj.img = "white"
			obj.bound = false
			obj.x, obj.y = x + 300*cos(a), y + 300*sin(a)
			obj.rot = a
			obj.layer = LAYER_ENEMY_BULLET-1
			obj.hscale, obj.vscale = 75, 0
			task.New(obj, function()
				local dv = 0.1/10
				for _ = 1, 10 do
					obj.vscale = obj.vscale + dv
					task.Wait(1)
				end
				task.Wait(60)
				dv = -dv
				for _ = 1, 10 do
					obj.vscale = obj.vscale + dv
					task.Wait(1)
				end
				Del(obj)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 144, 60, MOVE_NORMAL)
	end)
	task.New(self, function()
		do
			s3A_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 9999)
		while true do
			task.Wait(240)
			for u = -1, 1, 2 do
				--上面两团使魔
				for i = 0, 2 do
					f1(self.x + 75*cos(90 + 60*u), self.y + 75*sin(90 + 60*u), -90 + 120*i, u)
				end
				--中间的使魔
				for i = -1, 1, 2 do
					f1(self.x + 75*cos(-90), self.y + 75*sin(-90), (u+i)*90, u*i)
				end
			end
			task.Wait(290)
		end
	end)
end
local function card2_del_Keine_ENHL(self)
	Spell_break_eff(self.x, self.y, 0, 100, 255, 'bamboo_leaf_white', 'tree_leaf_white')
	self._wisys:setAction("normal", 1)
end
local card2_init = create_diff_function(
		{ card2_init_Mokou_E, card2_init_Mokou_N, card2_init_Mokou_H, card2_init_Mokou_L },
		{ card2_init_Keine_E, card2_init_Keine_N, card2_init_Keine_H, card2_init_Keine_L },
		true,
		{
			{cardname.card2.mokou.EN, cardname.card2.keine.EN},
			{cardname.card2.mokou.EN, cardname.card2.keine.EN},
			{cardname.card2.mokou.HL, cardname.card2.keine.HL},
			{cardname.card2.mokou.HL, cardname.card2.keine.HL},
		})
local card2_del = create_diff_function(
		{ card2_del_Mokou_ENHL, card2_del_Mokou_ENHL, card2_del_Mokou_ENHL, card2_del_Mokou_ENHL },
		{ card2_del_Keine_ENHL, card2_del_Keine_ENHL, card2_del_Keine_ENHL, card2_del_Keine_ENHL },
		false)
--endregion

--region normal 3
local function normal3_init_Mokou_E(self)
	--New(egg.updateFileObject, "EISlib/stage/stage3/bossA/bossA_main.lua")
	task.New(self, function()
		task.MoveTo(0, 104, 60, MOVE_DECEL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		--通常3，260f一轮攻击
		local a, dx, dy
		while true do
			for u = 1, -1, -2 do
				for _ = 1, 3 do
					a = Angle(self, player)
					for i = 1, 10 do
						for j = 0, 0 do
							stg.newBulletStraight(stg.ball_big, 2, true, self.x, self.y, 1 + 0.35*j, a + 36*i + 10*j)
						end
					end
					PlaySound("kira00")
					task.Wait(75)
				end
				task.Wait(50)
				for k = 1, 25 do
					for i = 1, 5 do
						a = 15.5*k*u -90 +  72*i
						dx, dy = 45*cos(a), 45*sin(a)
						for j = 0, 0 do
							accbullet(stg.square, 1 + 2*j, self.x + dx, self.y + dy, 1.5 + 1*j, a + 180, 60)
						end
					end
					PlaySound("tan00")
					task.Wait(6)
				end
			end
		end
	end)
end
local function normal3_init_Mokou_N(self)
	--New(egg.updateFileObject, "EISlib/stage/stage3/bossA/bossA_main.lua")
	task.New(self, function()
		task.MoveTo(0, 104, 60, MOVE_DECEL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		--通常3，260f一轮攻击
		local a, dx, dy
		while true do
			for u = 1, -1, -2 do
				for _ = 1, 3 do
					a = Angle(self, player)
					for i = 1, 18 do
						for j = 0, 0 do
							stg.newBulletStraight(stg.ball_big, 2, true, self.x, self.y, 1.25 + 0.35*j, a + 20*i + 10*j)
						end
					end
					PlaySound("kira00")
					task.Wait(75)
				end
				task.Wait(50)
				for k = 1, 25 do
					for i = 1, 5 do
						a = 15.5*k*u -90 +  72*i
						dx, dy = 45*cos(a), 45*sin(a)
						for j = 0, 1 do
							accbullet(stg.square, 1 + 2*j, self.x + dx, self.y + dy, 1.5 + 1*j, a + 180, 60)
						end
					end
					PlaySound("tan00")
					task.Wait(6)
				end
			end
		end
	end)
end
local function normal3_init_Mokou_H(self)
	--New(egg.updateFileObject, "EISlib/stage/stage3/bossA/bossA_main.lua")
	task.New(self, function()
		task.MoveTo(0, 104, 60, MOVE_DECEL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		--通常3，260f一轮攻击
		local a, dx, dy
		while true do
			for u = 1, -1, -2 do
				for _ = 1, 3 do
					a = Angle(self, player)
					for i = 1, 18 do
						for j = 0, 1 do
							stg.newBulletStraight(stg.ball_big, 2, true, self.x, self.y, 1.25 + 0.35*j, a + 20*i + 10*j)
						end
					end
					PlaySound("kira00")
					task.Wait(75)
				end
				task.Wait(50)
				for k = 1, 25 do
					for i = 1, 5 do
						a = 15.5*k*u -90 +  72*i
						dx, dy = 45*cos(a), 45*sin(a)
						for u0 = -1, 1, 2 do
							for j = 0, 1 do
								accbullet(stg.square, 1 + 2*j, self.x + dx, self.y + dy, 1.5 + 1*j, a + 180 + 30*u0, 60)
							end
						end
					end
					PlaySound("tan00")
					task.Wait(6)
				end
			end
		end
	end)
end
local function normal3_init_Mokou_L(self)
	--New(egg.updateFileObject, "EISlib/stage/stage3/bossA/bossA_main.lua")
	task.New(self, function()
		task.MoveTo(0, 104, 60, MOVE_DECEL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		--通常3，260f一轮攻击
		local a, dx, dy
		while true do
			--围绕自己生成一圈炎弹
			for u = 1, -1, -2 do
				for _ = 1, 3 do
					a = Angle(self, player)
					for i = 1, 24 do
						for j = 0, 1 do
							stg.newBulletStraight(stg.ball_big, 2, true, self.x, self.y, 1.25 + 0.35*j, a + 15*i + 7.5*j)
						end
					end
					PlaySound("kira00")
					task.Wait(75)
				end
				task.Wait(50)
				for k = 1, 30 do
					for i = 1, 5 do
						a = 14*k*u -90 +  72*i
						dx, dy = 45*cos(a), 45*sin(a)
						for u0 = -1, 1, 2 do
							for j = 0, 1 do
								accbullet(stg.square, 1 + 2*j, self.x + dx, self.y + dy, 1.5 + 1*j, a + 180 + 30*u0, 60)
							end
						end
					end
					PlaySound("tan00")
					task.Wait(5)
				end
			end
		end
	end)
end
local function normal3_init_Keine_E(self)
	local f1, f1_1, f2
	do
		--慧音使魔
		function f1_1(x, y, a, u)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, x, y, 0, 0)
			obj.img = "magic1"
			obj.hscale, obj.vscale = 0.75, 0.75
			obj.colli = false
			--攻击
			task.New(obj, function()
				for _ = 1, 25 do
					for i = 0, 0 do
						accbullet(stg.grain_b, 6 + 2*i, obj.x, obj.y, 1.5 + 1*i, a + 180, 60)
					end
					PlaySound("tan00")
					task.Wait(6)
				end
				Del(obj)
			end)
			--移动
			task.New(obj, function()
				local r, dr, da = 0, 2, 2*u
				for _ = 1, 30 do
					r = r + dr
					a = a + da
					obj.x, obj.y = x + r*cos(a), y + r*sin(a)
					task.Wait(1)
				end
				for _ = 1, 150 do
					a = a + da
					obj.x, obj.y = x + r*cos(a), y + r*sin(a)
					task.Wait(1)
				end
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 144, 60, MOVE_DECEL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 9999)
		--通常3，380f一轮攻击
		local a
		while true do
			--扔出一圈使魔
			for u = -1, 1, 2 do
				PlaySound("kira00")
				for i = 1, 8 do
					f1_1(self.x, self.y, 90 + (-60 - 15*i)*u, u)
					task.Wait(10)
				end
				task.Wait(110)
				for _ = 1, 3 do
					a = Angle(self, player)
					for i = 1, 10 do
						for j = 0, 0 do
							stg.newBulletStraight(stg.ball_big, 6, true, self.x, self.y, 1 + 0.35*j, a + 36*i + 16*j)
						end
					end
					task.Wait(75)
					PlaySound("kira00")
				end
			end
		end
	end)
end
local function normal3_init_Keine_N(self)
	local f1, f1_1, f2
	do
		--慧音使魔
		function f1_1(x, y, a, u)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, x, y, 0, 0)
			obj.img = "magic1"
			obj.hscale, obj.vscale = 0.75, 0.75
			obj.colli = false
			--攻击
			task.New(obj, function()
				for _ = 1, 25 do
					for i = 0, 1 do
						accbullet(stg.grain_b, 6 + 2*i, obj.x, obj.y, 1.5 + 1*i, a + 180, 60)
					end
					PlaySound("tan00")
					task.Wait(6)
				end
				Del(obj)
			end)
			--移动
			task.New(obj, function()
				local r, dr, da = 0, 2, 2*u
				for _ = 1, 30 do
					r = r + dr
					a = a + da
					obj.x, obj.y = x + r*cos(a), y + r*sin(a)
					task.Wait(1)
				end
				for _ = 1, 150 do
					a = a + da
					obj.x, obj.y = x + r*cos(a), y + r*sin(a)
					task.Wait(1)
				end
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 144, 60, MOVE_DECEL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 9999)
		--通常3，380f一轮攻击
		local a
		while true do
			--扔出一圈使魔
			for u = -1, 1, 2 do
				PlaySound("kira00")
				for i = 1, 8 do
					f1_1(self.x, self.y, 90 + (-60 - 15*i)*u, u)
					task.Wait(10)
				end
				task.Wait(110)
				for _ = 1, 3 do
					a = Angle(self, player)
					for i = 1, 18 do
						for j = 0, 0 do
							stg.newBulletStraight(stg.ball_big, 6, true, self.x, self.y, 1.25 + 0.35*j, a + 20*i + 10*j)
						end
					end
					task.Wait(75)
					PlaySound("kira00")
				end
			end
		end
	end)
end
local function normal3_init_Keine_H(self)
	local f1, f1_1, f2
	do
		--慧音使魔
		function f1_1(x, y, a, u)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, x, y, 0, 0)
			obj.img = "magic1"
			obj.hscale, obj.vscale = 0.75, 0.75
			obj.colli = false
			--攻击
			task.New(obj, function()
				for _ = 1, 20 do
					for u = -1, 1, 2 do
						for i = 0, 1 do
							accbullet(stg.grain_b, 6 + 2*i, obj.x, obj.y, 1.35 + 1.15*i, a + 180 + 30*u, 60)
						end
					end
					PlaySound("tan00")
					task.Wait(5)
				end
				Del(obj)
			end)
			--移动
			task.New(obj, function()
				local r, dr, da = 0, 2, 2*u
				for _ = 1, 30 do
					r = r + dr
					a = a + da
					obj.x, obj.y = x + r*cos(a), y + r*sin(a)
					task.Wait(1)
				end
				for _ = 1, 150 do
					a = a + da
					obj.x, obj.y = x + r*cos(a), y + r*sin(a)
					task.Wait(1)
				end
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 144, 60, MOVE_DECEL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 9999)
		--通常3，380f一轮攻击
		local a
		while true do
			--扔出一圈使魔
			for u = -1, 1, 2 do
				PlaySound("kira00")
				for i = 1, 8 do
					f1_1(self.x, self.y, 90 + (-60 - 15*i)*u, u)
					task.Wait(10)
				end
				task.Wait(120)
				for _ = 1, 3 do
					a = Angle(self, player)
					for i = 1, 18 do
						for j = 0, 1 do
							stg.newBulletStraight(stg.ball_big, 6, true, self.x, self.y, 1.25 + 0.35*j, a + 20*i + 10*j)
						end
					end
					task.Wait(75)
					PlaySound("kira00")
				end
			end
		end
	end)
end
local function normal3_init_Keine_L(self)
	local f1, f1_1, f2
	do
		--慧音使魔
		function f1_1(x, y, a, u)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, x, y, 0, 0)
			obj.img = "magic1"
			obj.hscale, obj.vscale = 0.75, 0.75
			obj.colli = false
			--攻击
			task.New(obj, function()
				for _ = 1, 30 do
					for u = -1, 1, 2 do
						for i = 0, 1 do
							accbullet(stg.grain_b, 6 + 2*i, obj.x, obj.y, 1.5 + 1*i, a + 180 + 30*u, 60)
						end
					end
					PlaySound("tan00")
					task.Wait(5)
				end
				Del(obj)
			end)
			--移动
			task.New(obj, function()
				local r, dr, da = 0, 2, 2*u
				for _ = 1, 30 do
					r = r + dr
					a = a + da
					obj.x, obj.y = x + r*cos(a), y + r*sin(a)
					task.Wait(1)
				end
				for _ = 1, 150 do
					a = a + da
					obj.x, obj.y = x + r*cos(a), y + r*sin(a)
					task.Wait(1)
				end
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(0, 144, 60, MOVE_DECEL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 9999)
		--通常3，380f一轮攻击
		local a
		while true do
			--扔出一圈使魔
			for u = -1, 1, 2 do
				PlaySound("kira00")
				for i = 1, 8 do
					f1_1(self.x, self.y, 90 + (-60 - 15*i)*u, u)
					task.Wait(10)
				end
				task.Wait(120)
				for _ = 1, 3 do
					a = Angle(self, player)
					for i = 1, 24 do
						for j = 0, 1 do
							stg.newBulletStraight(stg.ball_big, 6, true, self.x, self.y, 1.25 + 0.35*j, a + 15*i + 7.5*j)
						end
					end
					task.Wait(75)
					PlaySound("kira00")
				end
			end
		end
	end)
end
local function normal3_del_Mokou_ENHL(self)
	self.vscale = 1
	self.hscale = 1
end
local function normal3_del_Keine_ENHL(self)
	local nmsl
	self._wisys:setAction("normal", 1)
end
local normal3_init = create_diff_function(
		{ normal3_init_Mokou_E, normal3_init_Mokou_N, normal3_init_Mokou_H, normal3_init_Mokou_L },
		{ normal3_init_Keine_E, normal3_init_Keine_N, normal3_init_Keine_H, normal3_init_Keine_L },
		true)
local normal3_del = create_diff_function(
		{ normal3_del_Mokou_ENHL, normal3_del_Mokou_ENHL, normal3_del_Mokou_ENHL, normal3_del_Mokou_ENHL },
		{ normal3_del_Keine_ENHL, normal3_del_Keine_ENHL, normal3_del_Keine_ENHL, normal3_del_Keine_ENHL },
		false)
--endregion

--region card 3
local function card3_init_Mokou_E(self)
	local f1, f1_1, f2
	do
		function f1(x, y, a)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic1"
			obj.hscale, obj.vscale = 0, 0
			obj.timer = 11
			obj.colli = false
			egg.SimSizeCh(obj, 0, 0.75, 20)
			task.New(obj, function()
				task.MoveTo(x, y, 60, MOVE_ACC_DEC)
				SetV(obj, 6, a)
				for i = 1, 18 do
					f1_1(obj.x, obj.y, 2.25)
					PlaySound("kira00")
					task.Wait(3)
				end
				Del(obj)
			end)
		end
		function f1_1(x, y, v)
			local obj = stg.newBulletStraight(stg.ball_mid_c, 1, true, x, y, 0, 0)
			task.New(obj, function()
				task.Wait(90)
				PlaySound("kira00")
				local a = Angle(obj, player)
				for i = 0, 0 do
					accbullet(stg.knife, 9, x, y, v, a + 90*i, 120)
				end
				Del(obj)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(-40, 159, 45, MOVE_DECEL)
	end)
	task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 64)
		while true do
			--f1(-180, 180, -90)
			f1(160, 200, 180)
			task.Wait(150)
			--f1(180, -180, 90)
			f1(-160, 200, 0)
			task.Wait(150)
		end
	end)
end
local function card3_init_Mokou_N(self)
	local f1, f1_1, f2
	do
		function f1(x, y, a)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic1"
			obj.hscale, obj.vscale = 0, 0
			obj.timer = 11
			obj.colli = false
			egg.SimSizeCh(obj, 0, 0.75, 20)
			task.New(obj, function()
				task.MoveTo(x, y, 60, MOVE_ACC_DEC)
				SetV(obj, 6, a)
				for i = 1, 18 do
					f1_1(obj.x, obj.y, 2.25)
					PlaySound("kira00")
					task.Wait(3)
				end
				Del(obj)
			end)
		end
		function f1_1(x, y, v)
			local obj = stg.newBulletStraight(stg.ball_mid_c, 1, true, x, y, 0, 0)
			task.New(obj, function()
				task.Wait(90)
				PlaySound("kira00")
				local a = Angle(obj, player)
				for i = -1, 1 do
					accbullet(stg.knife, 9, x, y, v, a + 90*i, 120)
				end
				Del(obj)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(-40, 159, 45, MOVE_DECEL)
	end)
	task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 64)
		while true do
			f1(-180, 180, -90)
			f1(160, 200, 180)
			task.Wait(150)
			f1(180, -180, 90)
			f1(-160, 200, 0)
			task.Wait(150)
		end
	end)
end
local function card3_init_Mokou_H(self)
	local f1, f1_1, f2
	do
		function f1(x, y, a)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic1"
			obj.hscale, obj.vscale = 0, 0
			obj.timer = 11
			obj.colli = false
			egg.SimSizeCh(obj, 0, 0.75, 20)
			task.New(obj, function()
				task.MoveTo(x, y, 60, MOVE_ACC_DEC)
				SetV(obj, 6, a)
				for i = 1, 18 do
					f1_1(obj.x, obj.y, 2.25)
					PlaySound("kira00")
					task.Wait(3)
				end
				Del(obj)
			end)
		end
		function f1_1(x, y, v)
			local obj = stg.newBulletStraight(stg.ball_mid_c, 1, true, x, y, 0, 0)
			task.New(obj, function()
				task.Wait(90)
				PlaySound("kira00")
				local a = Angle(obj, player)
				for i = -1, 1 do
					accbullet(stg.knife, 9, x, y, v, a + 90*i, 120)
				end
				Del(obj)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(-40, 159, 45, MOVE_DECEL)
	end)
	task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 64)
		while true do
			f1(-180, 180, -90)
			f1(180, -180, 90)
			task.Wait(150)
			f1(160, 200, 180)
			f1(-160, -200, 0)
			task.Wait(150)
		end
	end)
end
local function card3_init_Mokou_L(self)
	local f1, f1_1, f2
	do
		function f1(x, y, a)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic1"
			obj.hscale, obj.vscale = 0, 0
			obj.timer = 11
			obj.colli = false
			egg.SimSizeCh(obj, 0, 0.75, 20)
			task.New(obj, function()
				task.MoveTo(x, y, 60, MOVE_ACC_DEC)
				SetV(obj, 6, a)
				for i = 1, 28 do
					f1_1(obj.x, obj.y, 2.5)
					PlaySound("kira00")
					task.Wait(2)
				end
				Del(obj)
			end)
		end
		function f1_1(x, y, v)
			local obj = stg.newBulletStraight(stg.ball_mid_c, 1, true, x, y, 0, 0)
			task.New(obj, function()
				task.Wait(90)
				PlaySound("kira00")
				local a = Angle(obj, player)
				for i = -2, 2 do
					accbullet(stg.knife, 9, x, y, v, a + 60*i, 120)
				end
				Del(obj)
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(-40, 159, 45, MOVE_DECEL)
	end)
	task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 64)
		while true do
			f1(-180, 180, -90)
			f1(180, -180, 90)
			task.Wait(150)
			f1(160, 200, 180)
			f1(-160, -200, 0)
			task.Wait(150)
		end
	end)
end
local function card3_init_Mokou_L2(self)
	lasttask = task.New(self, function()
		task.MoveTo(-90, 124, 45, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
		end
		lasttask = task.New(self, function()
			task._Wait(15)
			do
				for _ = 1, _infinite do
					do
						for _ = 1, 3 do
							last = New(_editor_class["s3_妹红三符水雾"], ran:Float(-200, 200), ran:Float(-200, 200), 5)
						end
					end
					task._Wait(10)
				end
			end
		end)
		local i = 1
		local kk = -1
		do
			for _ = 1, _infinite do
				task._Wait(18)
				self._wisys:setAction("cast", 64)
				lasttask = task.New(self, function()
					local t = 144
					do
						local y0, _d_y0 = (200), (-75)
						for _ = 1, 3 do
							do
								local y, _d_y = (y0), (-150 / 4)
								local aerfa, _d_aerfa = (90 - 42 * i), (84 / 4 * i)
								for _ = 1, 5 do
									last = New(_editor_class["s3_妹红三符下雨云"], -240 * i, y, 200 * cos(aerfa) + ran:Float(-15, 15), y0 - 140 + 140 * sin(aerfa) + ran:Float(-15, 15), t, 8)
									t = t - 8
									task._Wait(5)
									y = y + _d_y
									aerfa = aerfa + _d_aerfa
								end
							end
							i = -i
							task._Wait(0)
							y0 = y0 + _d_y0
						end
					end
				end)
				task._Wait(320)
				task.MoveTo(0, 144, 75, MOVE_DECEL)
				lasttask = task.New(self, function()
					local c = Angle(self, player)
					PlaySound("enep00", 0.1, 0, false)
					do
						local t, _d_t = (60), (-1)
						local d, _d_d = (1), (20 / 45)
						for _ = 1, 45 do
							do
								local a, _d_a = (0), (90)
								for _ = 1, 4 do
									last = New(_editor_class["s3_慧音三符纸牌藏刀"], self.x + 16 * cos(a + c), self.y + 16 * sin(a + c), a + c, 1, t)
									task._Wait(0)
									a = a + _d_a
								end
							end
							c = c + d
							task._Wait(2)
							t = t + _d_t
							d = d + _d_d
						end
					end
				end)
				task._Wait(90)
				kk = -kk
				task.MoveTo(90 * kk, 124, 45, MOVE_DECEL)
				task._Wait(0)
			end
		end
	end)
end
local function card3_init_Keine_E(self)
	local f1, f1_1, f1_2
	do
		function f1(x, y, a)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic6"
			obj.hscale, obj.vscale = 0, 0
			obj.timer = 11
			obj.colli = false
			egg.SimSizeCh(obj, 0, 0.75, 20)
			for u = -1, 1, 2 do
				f1_2(x, y, 0.4, a)
				--f1_2(x, y, 0.8, a)
			end
			task.New(obj, function()
				task.MoveTo(x, y, 60, MOVE_ACC_DEC)
				SetV(obj, 4, a)
				local t = 240
				for i = 1, 60 do
					for u = -1, 1, 2 do
						f1_1(obj.x, obj.y, 0.4, a + 90*u, t, 5)
						PlaySound("kira00")
						task.Wait(8)
						t = t - 8
					end
					i = i + 1
				end
				Del(obj)
			end)
		end
		function f1_1(x, y, v, a, t, co)
			local obj = stg.newBulletStraight(stg.square, co, true, x, y, 0, a)
			task.New(obj, function()
				task.Wait(t)
				PlaySound("kira00")
				egg.AddSimStrChV(obj, 0, v, a, 60)
			end)
		end
		function f1_2(x, y, v, a)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, x, y, 0, a)
			obj.img = "white"
			obj.colli = false
			_object.set_color(obj, "", 100, 255, 255, 255)
			obj.hscale, obj.vscale = 120, 0
			task.New(obj, function()
				task.Wait(300)
				egg.AddSimStrChV(obj, 0, v, a + 90, 60)
				local dv = 0.25/60
				for _ = 1, 60 do
					obj.vscale = obj.vscale + dv
					task.Wait(1)
				end
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(40, 159, 45, MOVE_DECEL)
	end)
	task.New(self, function()
		do
			s3A_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
				task._Wait(60)
			end
		end
		while true do
			f1(-190, 220, -90)
			f1(190, 220, 180)
			f1(190, -220, 90)
			--f1(-190, -220, 0)
			task.Wait(300)
		end
	end)
end
local function card3_init_Keine_N(self)
	local f1, f1_1, f1_2
	do
		function f1(x, y, a)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic6"
			obj.hscale, obj.vscale = 0, 0
			obj.timer = 11
			obj.colli = false
			egg.SimSizeCh(obj, 0, 0.75, 20)
			for u = -1, 1, 2 do
				--f1_2(x, y, 0.4, a)
				f1_2(x, y, 0.8, a)
			end
			task.New(obj, function()
				task.MoveTo(x, y, 60, MOVE_ACC_DEC)
				SetV(obj, 4, a)
				local t = 240
				for i = 1, 60 do
					for u = -1, 1, 2 do
						f1_1(obj.x, obj.y, 0.8, a + 90*u, t, 7)
						PlaySound("kira00")
						task.Wait(6)
						t = t - 6
					end
					i = i + 1
				end
				Del(obj)
			end)
		end
		function f1_1(x, y, v, a, t, co)
			local obj = stg.newBulletStraight(stg.square, co, true, x, y, 0, a)
			task.New(obj, function()
				task.Wait(t)
				PlaySound("kira00")
				egg.AddSimStrChV(obj, 0, v, a, 60)
			end)
		end
		function f1_2(x, y, v, a)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, x, y, 0, a)
			obj.img = "white"
			obj.colli = false
			_object.set_color(obj, "", 100, 255, 255, 255)
			obj.hscale, obj.vscale = 120, 0
			task.New(obj, function()
				task.Wait(300)
				egg.AddSimStrChV(obj, 0, v, a + 90, 60)
				local dv = 0.25/60
				for _ = 1, 60 do
					obj.vscale = obj.vscale + dv
					task.Wait(1)
				end
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(40, 159, 45, MOVE_DECEL)
	end)
	task.New(self, function()
		do
			s3A_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
				task._Wait(60)
			end
		end
		while true do
			f1(-190, 220, -90)
			f1(190, 220, 180)
			f1(190, -220, 90)
			--f1(-190, -220, 0)
			task.Wait(300)
		end
	end)
end
local function card3_init_Keine_H(self)
	local f1, f1_1, f1_2
	do
		function f1(x, y, a)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic6"
			obj.hscale, obj.vscale = 0, 0
			obj.timer = 11
			obj.colli = false
			egg.SimSizeCh(obj, 0, 0.75, 20)
			for u = -1, 1, 2 do
				f1_2(x, y, 0.4, a)
				f1_2(x, y, 0.8, a)
			end
			task.New(obj, function()
				task.MoveTo(x, y, 60, MOVE_ACC_DEC)
				SetV(obj, 4, a)
				local t = 240
				for i = 1, 60 do
					for u = -1, 1, 2 do
						f1_1(obj.x, obj.y, 0.4 + 0.4*(i%2), a + 90*u, t, 5 + 2*(i%2))
						PlaySound("kira00")
						task.Wait(3)
						t = t - 3
					end
					i = i + 1
				end
				Del(obj)
			end)
		end
		function f1_1(x, y, v, a, t, co)
			local obj = stg.newBulletStraight(stg.square, co, true, x, y, 0, a)
			task.New(obj, function()
				task.Wait(t)
				PlaySound("kira00")
				egg.AddSimStrChV(obj, 0, v, a, 60)
			end)
		end
		function f1_2(x, y, v, a)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, x, y, 0, a + 90)
			obj.img = "white"
			obj.colli = false
			_object.set_color(obj, "", 100, 255, 255, 255)
			obj.hscale, obj.vscale = 120, 0
			task.New(obj, function()
				task.Wait(300)
				egg.AddSimStrChV(obj, 0, v, a, 60)
				local dv = 0.25/60
				for _ = 1, 60 do
					obj.vscale = obj.vscale + dv
					task.Wait(1)
				end
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(40, 159, 45, MOVE_DECEL)
	end)
	task.New(self, function()
		do
			s3A_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
				task._Wait(60)
			end
		end
		while true do
			f1(-190, 220, -90)
			f1(190, 220, 180)
			f1(190, -220, 90)
			f1(-190, -220, 0)
			task.Wait(300)
		end
	end)
end
local function card3_init_Keine_H2(self)
	lasttask = task.New(self, function()
		task.MoveTo(90, 124, 45, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			s3A_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
				task._Wait(60)
			end
		end
		local jj = -1
		local i = 1
		local ii = 1
		do
			for _ = 1, _infinite do
				self._wisys:setAction("cast", 320)
				lasttask = task.New(self, function()
					lasttask = task.New(self, function()
						do
							local x, _d_x = (-240 * jj + (jj - 1) * 480 / 20), (480 / 4 * jj)
							for _ = 1, 5 do
								last = New(_editor_class["s3_慧音三符预警"], x, 240, 270, COLOR_GREEN)
								task._Wait(3)
								x = x + _d_x
							end
						end
					end)
					do
						local y, _d_y = (240), (-480 / 4)
						for _ = 1, 5 do
							last = New(_editor_class["s3_慧音三符预警"], -240 * jj, y, 90 - 90 * jj, COLOR_GREEN)
							task._Wait(3)
							y = y + _d_y
						end
					end
				end)
				task._Wait(15)
				task._Wait(200)
				task._Wait(120)
				jj = -jj
				task.MoveTo(0, 124, 75, MOVE_DECEL)
				lasttask = task.New(self, function()
					local b = Angle(self, player)
					PlaySound("enep00", 0.1, 0, false)
					do
						local t, _d_t = (45), (-30 / 45)
						local d, _d_d = (1), (20 / 45)
						for _ = 1, 45 do
							do
								local a, _d_a = (0), (120)
								for _ = 1, 3 do
									last = New(_editor_class["s3_慧音三符纸牌藏刀"], self.x + 16 * cos(a + b), self.y + 16 * sin(a + b), a + b, -1, t)
									task._Wait(0)
									a = a + _d_a
								end
							end
							b = b - d
							task._Wait(2)
							t = t + _d_t
							d = d + _d_d
						end
					end
				end)
				task._Wait(90)
				i = -i
				task.MoveTo(90 * i, 124, 45, MOVE_DECEL)
				task._Wait(0)
			end
		end
	end)
end
local function card3_init_Keine_L(self)
	local f1, f1_1, f1_2
	do
		function f1(x, y, a)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, self.x, self.y, 0, 0)
			obj.img = "magic6"
			obj.hscale, obj.vscale = 0, 0
			obj.timer = 11
			obj.colli = false
			egg.SimSizeCh(obj, 0, 0.75, 20)
			for u = -1, 1, 2 do
				f1_2(x, y, 0.4, a)
				f1_2(x, y, 0.8, a)
			end
			task.New(obj, function()
				task.MoveTo(x, y, 60, MOVE_ACC_DEC)
				SetV(obj, 4, a)
				local t = 240
				for i = 1, 60 do
					for u = -1, 1, 2 do
						f1_1(obj.x, obj.y, 0.4 + 0.4*(i%2), a + 90*u, t, 5 + 2*(i%2))
						PlaySound("kira00")
						task.Wait(2)
						t = t - 2
					end
					i = i + 1
				end
				Del(obj)
			end)
		end
		function f1_1(x, y, v, a, t, co)
			local obj = stg.newBulletStraight(stg.square, co, true, x, y, 0, a)
			task.New(obj, function()
				task.Wait(t)
				PlaySound("kira00")
				egg.AddSimStrChV(obj, 0, v, a, 60)
			end)
		end
		function f1_2(x, y, v, a)
			local obj = stg.newBulletStraight(stg.ball_huge, 1, true, x, y, 0, a + 90)
			obj.img = "white"
			obj.colli = false
			_object.set_color(obj, "", 100, 255, 255, 255)
			obj.hscale, obj.vscale = 120, 0
			task.New(obj, function()
				task.Wait(300)
				egg.AddSimStrChV(obj, 0, v, a, 60)
				local dv = 0.25/60
				for _ = 1, 60 do
					obj.vscale = obj.vscale + dv
					task.Wait(1)
				end
			end)
		end
	end
	task.New(self, function()
		task.MoveTo(40, 159, 45, MOVE_DECEL)
	end)
	task.New(self, function()
		do
			s3A_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
				task._Wait(60)
			end
		end
		while true do
			f1(-190, 220, -90)
			f1(190, 220, 180)
			f1(190, -220, 90)
			f1(-190, -220, 0)
			task.Wait(300)
		end
	end)
end
local function card3_init_Keine_L2(self)
	lasttask = task.New(self, function()
		task.MoveTo(90, 124, 45, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			s3A_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
				task._Wait(60)
			end
		end
		local jj = -1
		local j = 1
		local i = 1
		local ii = 1
		do
			for _ = 1, _infinite do
				self._wisys:setAction("cast", 320)
				lasttask = task.New(self, function()
					lasttask = task.New(self, function()
						do
							local x, _d_x = (-240 * jj + (jj - 1) * 480 / 20), (480 / 5 * jj)
							for _ = 1, 6 do
								last = New(_editor_class["s3_慧音三符预警"], x, 240, 270, COLOR_GREEN)
								task._Wait(3)
								x = x + _d_x
							end
						end
					end)
					do
						local y, _d_y = (240), (-480 / 5)
						for _ = 1, 6 do
							last = New(_editor_class["s3_慧音三符预警"], -240 * jj, y, 90 - 90 * jj, COLOR_GREEN)
							task._Wait(3)
							y = y + _d_y
						end
					end
				end)
				task._Wait(18)
				task._Wait(200)
				task._Wait(120)
				jj = -jj
				task.MoveTo(0, 124, 75, MOVE_DECEL)
				lasttask = task.New(self, function()
					local b = Angle(self, player)
					PlaySound("enep00", 0.1, 0, false)
					do
						local t, _d_t = (60), (-1)
						local d, _d_d = (1), (20 / 45)
						for _ = 1, 45 do
							do
								local a, _d_a = (0), (72)
								for _ = 1, 5 do
									last = New(_editor_class["s3_慧音三符纸牌藏刀"], self.x + 16 * cos(a + b), self.y + 16 * sin(a + b), a + b, -1, t)
									task._Wait(0)
									a = a + _d_a
								end
							end
							b = b - d
							task._Wait(2)
							t = t + _d_t
							d = d + _d_d
						end
					end
				end)
				task._Wait(90)
				i = -i
				task.MoveTo(90 * i, 124, 45, MOVE_DECEL)
				task._Wait(0)
			end
		end
	end)
end
local function card3_del_Mokou_ENHL(self)
	Spell_break_eff(self.x, self.y, 255, 0, 0,
			'bamboo_leaf_white', 'tree_leaf_white')
end
local function card3_del_Keine_ENH(self)
	Spell_break_eff(self.x, self.y, 0, 100, 255,
			'bamboo_leaf_white', 'tree_leaf_white')
end
local function card3_del_Keine_L(self)
	Spell_break_eff(self.x, self.y, 0, 100, 255, 'bamboo_leaf_white', 'tree_leaf_white')
	self._wisys:setAction("normal", 1)
end
local card3_init = create_diff_function(
		{ card3_init_Mokou_E, card3_init_Mokou_N, card3_init_Mokou_H, card3_init_Mokou_L },
		{ card3_init_Keine_E, card3_init_Keine_N, card3_init_Keine_H, card3_init_Keine_L },
		true,
		{
			{cardname.card3.mokou.EN, cardname.card3.keine.EN},
			{cardname.card3.mokou.EN, cardname.card3.keine.EN},
			{cardname.card3.mokou.HL, cardname.card3.keine.HL},
			{cardname.card3.mokou.HL, cardname.card3.keine.HL},
		})
local card3_del = create_diff_function(
		{ card3_del_Mokou_ENHL, card3_del_Mokou_ENHL, card3_del_Mokou_ENHL, card3_del_Mokou_ENHL },
		{ card3_del_Keine_ENH, card3_del_Keine_ENH, card3_del_Keine_ENH, card3_del_Keine_L },
		false)
--endregion

-- boss
local function create_double(group_name, class_name, name)
	-- 假 boss 死亡动画
	local function deadtask(self)
		if (not self.dead_flag) then
			self.dead_flag = true
			self.colli = false -- 避免自机被体术
			task.New(self, function()
				New(boss_death_ef, self.x, self.y)
				local angle = ran:Float(10, 20)
				self.vx = 0.2 * cos(angle)
				self.vy = 0.2 * sin(angle)
				task.Wait(60)
				New(boss_death_ef, self.x, self.y)
				New(boss_death_circle, self.x, self.y)
				self.status = "del"
			end)
		end
	end
	-- 假 boss 的事件
	local function common_callback(self, slot)
		callback.attach(self, "after_update", "update_position_pointer", function(self)
			if lstg.IsValid(self.master_boss) then
				self.hp = self.master_boss.hp -- 同步血量，方便做低血音效
				self.master_boss.ui_pointers[slot] = self.x
			end
		end)
		callback.attach(self, "on_trigger", "set_current_enemy", function(self, other)
			system.setCurDamageEnemy(self.master_boss)
		end)
		callback.attach(self, "on_kill", "prevent_kill", function(self)
			task.Clear(self)
			self.status = "normal"
		end)
		callback.attach(self, "on_delete", "prevent_delete", function(self)
			task.Clear(self)
			self.status = "normal"
		end)
	end
	-- 创建假 boss 并存到真 boss 身上
	local function create_fake_boss(master)
		master.mokou = stg.newSimpleBoss(-240, 384, 1145141919, function(mokou)
			mokou._private_type_boss = true
			mokou.master_boss = master
			lstg.wis.Mokou(mokou)
			mokou.group = GROUP_ENEMY
			mokou.a = 32
			mokou.b = 32
			common_callback(mokou, 1)
		end)
		master.keine = stg.newSimpleBoss(240, 384, 1145141919, function(keine)
			keine._private_type_boss = true
			keine.master_boss = master
			lstg.wis.Keine(keine)
			keine.group = GROUP_ENEMY
			keine.a = 32
			keine.b = 32
			common_callback(keine, 2)
		end)
		master.slave_boss = {master.mokou, master.keine}
	end
	-- boss class
	local cls = EISlib.stage.createBossClass(group_name, class_name, name, s3A_boss.scbg,
			{ "s3_boss3", stage3_background }, 0, 21474836487, function() end)
	-- 对 init 进行改造，确保假 boss 先创建，然后再 boss.init，不然的话它这个沙雕玩意一开始就执行符卡，这时候假 boss 还没创建
	local old_init = cls.init
	function cls:init(...)
		create_fake_boss(self)
		old_init(self, ...)
		self.colli = false
		self.ui_names = { "Mokou", "Keine" } -- boss ui
		self.ui_pointers = { 0, 0 } -- boss ui
	end
	-- 死亡动画
	function cls:spExplode()
		Del(self)
		deadtask(self.mokou)
		deadtask(self.keine)
	end
	return cls
end
local function create_dialog(boss_class, player_dialog, f)
	EISlib.stage.createDialogClass(
			boss_class, player_dialog, f)
end
local function create_card(boss_class, card_name, tt, hp, dropt, mode, preaction, init, del)
	local sc = EISlib.stage.createCardClass(boss_class, card_name, tt, hp, dropt, mode, preaction)
	if init then
		sc.init = init
	end
	if del then
		sc.del = del
	end
end

--妹红的蓄力特效
local function eff1(x, y, t)
	New(AbEff, x, y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
	if t then
		task.Wait(t)
	end
end
--符卡练习出场特效
local function boss_scpr_show1(self, x, y)
	for _ = 1, 3 do
		eff1(x, y, 20)
	end
	task.Wait(20)
	self.x, self.y = x, y
end
--慧音的蓄力特效
local function eff2(x, y, t)
	New(AbEff, x, y, 'bamboo_leaf_white', 'tree_leaf_white', 0, 100, 255)
	if t then
		task.Wait(t)
	end
end
--符卡练习出场特效
local function boss_scpr_show2(self, x, y)
	for _ = 1, 3 do
		eff2(x, y, 20)
	end
	task.Wait(20)
	self.x, self.y = x, y
end

-- common action
local function common_action1(boss_class)
	local taskf = function(self)
		if not ext.sc_pr then
			-- 进场
			task.New(self.keine, function()
				task.MoveTo(90, 124, 90, MOVE_DECEL)
			end)
			task.Wait(90)
			task.New(self.mokou, function()
				task.MoveTo(-90, 124, 90, MOVE_DECEL)
			end)
			task.Wait(90)
			-- 对话
			if EISlib.stage.canDialog() then
				dialog.cacheResource("Stage3")
				dialog.player.playScene("Stage3")
				dialog.player.waitSignal("fade out BGM", dialog.enum.on)
				EISlib.stage.musicFadeOut("s3", 120)
				dialog.player.waitSignal("play BGM", dialog.enum.on)
				LoadMusicRecord("s3_boss3")
				EISlib.stage.playMusic("s3_boss3", 0, true)
				dialog.player.waitUntilFinish()
			else
				EISlib.stage.musicFadeOut("s3", 120)
				LoadMusicRecord("s3_boss3")
				EISlib.stage.playMusic("s3_boss3", 0, true)
			end
			-- 开始攻击！
			stg.setBossMagicCircle(self.mokou, true)
			stg.setBossMagicCircle(self.keine, true)
			stg.setBossWarp(self.mokou, true)
			stg.setBossWarp(self.keine, true)
		end
	end
	for _, v in pairs(boss_class) do
		create_dialog(v, true, taskf)
	end
end
local function common_action2(boss_class)
	local taskf = function(self)
		if not ext.sc_pr then
			task.Wait(90)
		else
			task.New(self.mokou, function(unit)
				boss_scpr_show1(unit, -90, 124)
				stg.setBossMagicCircle(unit, true)
				stg.setBossWarp(unit, true)
			end)
			task.New(self.keine, function(unit)
				boss_scpr_show2(unit, 90, 124)
				stg.setBossMagicCircle(unit, true)
				stg.setBossWarp(unit, true)
			end)
			task.Wait(120)
		end
	end
	for _, v in pairs(boss_class) do
		create_dialog(v, false, taskf)
	end
end

--region mokou pass

local bossE = create_double("Easy", "s3bossAdouble1:Easy", "Mokou")
local bossN = create_double("Normal", "s3bossAdouble1:Normal", "Mokou")
local bossH = create_double("Hard", "s3bossAdouble1:Hard", "Mokou")
local bossL = create_double("Lunatic", "s3bossAdouble1:Lunatic", "Mokou")

common_action1({ bossE, bossN, bossH, bossL })
common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, "通常攻击1",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)
create_card(bossN, "通常攻击1",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)
create_card(bossH, "通常攻击1",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)
create_card(bossL, "通常攻击1",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, cardname.card1.mokou.EN,
		{ 3, 5, 60 }, 2400, {10, 20, 30}, "spellcard", true, card1_init, card1_del)
create_card(bossN, cardname.card1.mokou.EN,
		{ 3, 5, 60 }, 2400, {10, 20, 30}, "spellcard", true, card1_init, card1_del)
create_card(bossH, cardname.card1.mokou.HL,
		{ 3, 5, 60 }, 2400, {10, 20, 30}, "spellcard", true, card1_init, card1_del)
create_card(bossL, cardname.card1.mokou.HL,
		{ 3, 5, 60 }, 2400, {10, 20, 30}, "spellcard", true, card1_init, card1_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, "通常攻击2",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal2_init, normal2_del)
create_card(bossN, "通常攻击2",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal2_init, normal2_del)
create_card(bossH, "通常攻击2",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal2_init, normal2_del)
create_card(bossL, "通常攻击2",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal2_init, normal2_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, cardname.card2.mokou.EN,
		{ 3, 5, 60 }, 2000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)
create_card(bossN, cardname.card2.mokou.EN,
		{ 3, 5, 60 }, 2000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)
create_card(bossH, cardname.card2.mokou.HL,
		{ 3, 5, 60 }, 2000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)
create_card(bossL, cardname.card2.mokou.HL,
		{ 3, 5, 60 }, 2000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, "通常攻击3",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)
create_card(bossN, "通常攻击3",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)
create_card(bossH, "通常攻击3",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)
create_card(bossL, "通常攻击3",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, cardname.card3.mokou.EN,
		{ 2, 15, 60 }, 2000, {10, 20, 30}, "spellcard", true, card3_init, card3_del)
create_card(bossN, cardname.card3.mokou.EN,
		{ 2, 15, 60 }, 2000, {10, 20, 30}, "spellcard", true, card3_init, card3_del)
create_card(bossH, cardname.card3.mokou.HL,
		{ 2, 15, 60 }, 2000, {10, 20, 30}, "spellcard", true, card3_init, card3_del)
create_card(bossL, cardname.card3.mokou.HL,
		{ 2, 15, 60 }, 2000, {10, 20, 30}, "spellcard", true, card3_init, card3_del)

function s3A_boss.main(diff)
	local boss
	diff = diff or difficulty
	if diff == 1 then
		boss = New(bossE, bossE.cards)
	elseif diff == 2 then
		boss = New(bossN, bossN.cards)
	elseif diff == 3 then
		boss = New(bossH, bossH.cards)
	elseif diff == 4 then
		boss = New(bossL, bossL.cards)
	end
	--关底boss等待
	while IsValid(boss) do
		task.Wait(1)
	end
end

--endregion

--region keine pass

bossE = create_double("Easy", "s3bossAdouble2:Easy", "Keine")
bossN = create_double("Normal", "s3bossAdouble2:Normal", "Keine")
bossH = create_double("Hard", "s3bossAdouble2:Hard", "Keine")
bossL = create_double("Lunatic", "s3bossAdouble2:Lunatic", "Keine")

common_action1({ bossE, bossN, bossH, bossL })
common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, "通常攻击1",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)
create_card(bossN, "通常攻击1",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)
create_card(bossH, "通常攻击1",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)
create_card(bossL, "通常攻击1",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, cardname.card1.keine.EN,
		{ 3, 5, 60 }, 2400, {10, 20, 30}, "spellcard", true, card1_init, card1_del)
create_card(bossN, cardname.card1.keine.EN,
		{ 3, 5, 60 }, 2400, {10, 20, 30}, "spellcard", true, card1_init, card1_del)
create_card(bossH, cardname.card1.keine.HL,
		{ 3, 5, 60 }, 2400, {10, 20, 30}, "spellcard", true, card1_init, card1_del)
create_card(bossL, cardname.card1.keine.HL,
		{ 3, 5, 60 }, 2400, {10, 20, 30}, "spellcard", true, card1_init, card1_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, "通常攻击2",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal2_init, normal2_del)
create_card(bossN, "通常攻击2",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal2_init, normal2_del)
create_card(bossH, "通常攻击2",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal2_init, normal2_del)
create_card(bossL, "通常攻击2",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal2_init, normal2_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, cardname.card2.keine.EN,
		{ 3, 5, 60 }, 2000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)
create_card(bossN, cardname.card2.keine.EN,
		{ 3, 5, 60 }, 2000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)
create_card(bossH, cardname.card2.keine.HL,
		{ 3, 5, 60 }, 2000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)
create_card(bossL, cardname.card2.keine.HL,
		{ 3, 5, 60 }, 2000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, "通常攻击3",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)
create_card(bossN, "通常攻击3",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)
create_card(bossH, "通常攻击3",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)
create_card(bossL, "通常攻击3",
		{ 2, 5, 55 }, 1500, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, cardname.card3.keine.EN,
		{ 2, 15, 60 }, 2000, {10, 20, 30}, "spellcard", true, card3_init, card3_del)
create_card(bossN, cardname.card3.keine.EN,
		{ 2, 15, 60 }, 2000, {10, 20, 30}, "spellcard", true, card3_init, card3_del)
create_card(bossH, cardname.card3.keine.HL,
		{ 2, 15, 60 }, 2000, {10, 20, 30}, "spellcard", true, card3_init, card3_del)
create_card(bossL, cardname.card3.keine.HL,
		{ 2, 15, 60 }, 2000, {10, 20, 30}, "spellcard", true, card3_init, card3_del)

--endregion
