local function create_diff_function(reimu_fs, yukari_fs, connect, cardnames)
	return function(self)
		if lstg.IsValid(self.reimu) and reimu_fs[difficulty] then
			reimu_fs[difficulty](self.reimu)
			if connect then
				_connect(self, self.reimu, 1, true)
			end
		end
		if lstg.IsValid(self.yukari) and yukari_fs[difficulty] then
			yukari_fs[difficulty](self.yukari)
			if connect then
				_connect(self, self.yukari, 1, true)
			end
		end
		if cardnames and cardnames[difficulty] then
			self.ui_cardnames = cardnames[difficulty]
		end
	end
end

local cardname = {
	card1 = {
		reimu = {
			EN = "咒符「摩根之爪」",
			HL = "焱攸不息「迦具土的一指」",
		},
		yukari = {
			EN = "哀符「源氏物语」",
			HL = "一茶日记「竹林独步寻花」",
		},
	},
	card2 = {
		reimu = {
			EN = "炎符「火凤凰舍身冲撞」",
			HL = "不死「凯风快晴飞翔蹴」",
		},
		yukari = {
			EN = "秘史「国士无双之卷」",
			HL = "国符「空想神器 案」",
		},
	},
	card3 = {
		reimu = {
			EN = "回符「加缪的诅咒」",
			HL = "无尽「荒诞的不死者」",
		},
		yukari = {
			EN = "鉴符「三重时段」",
			HL = "诗符「创始者叙事」",
		},
	},
}

-- card
--region normal 1
local function normal1_init_Reimu_E(self)
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 48)
		task._Wait(30)
		local i = 1
		local dt
		do
			for _ = 1, _infinite do
				dt = 50
				--[[ 2*20 --]]--[=[ --]=]
				do
					local n, _d_n = (1), (1)
					local a, _d_a = (90 + 90 * i), (-360 / 7 * i)
					for _ = 1, 7 do
						PlaySound("tan00", 0.1, 0, false)
						do
							local _sp, _d__sp = (-3.5), (7 / 2)
							for _ = 1, 3 do
								do
									local v, _d_v = (3), (1)
									local _n, _d__n = (1), (1)
									for _ = 1, 2 do
										if _n % 2 == 1 then
											v2 = -1
										else
											v2 = 2.5
										end
										last = New(_editor_class["s3_B1_no1_1"], self.x, self.y, v, a + _sp, dt, v2)
										v = v + _d_v
										_n = _n + _d__n
									end
								end
								_sp = _sp + _d__sp
							end
						end
						if (n % 3 == 0) then
							dt = dt - 20
							task._Wait(20)
						else
						end
						n = n + _d_n
						a = a + _d_a
					end
				end
				self._wisys:setAction("cast", 48)
				task._Wait(49)
				do
					local v, _d_v = (2), (0)
					for _ = 1, 2 do
						PlaySound("tan00", 0.1, 0, false)
						last = New(_editor_class["s3_灵梦一非追踪札"], self.x, self.y, Angle(self, player), v, 9 + 7 * i)
						task._Wait(20)
						v = v + _d_v
					end
				end
				task._Wait(51)
				task._Wait(198)
				task.MoveTo(-60 * i, 124, 60, MOVE_DECEL)
				self._wisys:setAction("cast", 48)
				i = -i
			end
		end
	end)
end
local function normal1_init_Reimu_N(self)
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 48)
		task._Wait(30)
		local i = 1
		local dt
		do
			for _ = 1, _infinite do
				dt = 50
				--[[ 3*15 --]]--[=[ --]=]
				do
					local n, _d_n = (1), (1)
					local a, _d_a = (90 + 90 * i), (-360 / 11 * i)
					for _ = 1, 11 do
						PlaySound("tan00", 0.1, 0, false)
						do
							local _sp, _d__sp = (-4), (8 / 3)
							for _ = 1, 4 do
								do
									local v, _d_v = (3), (1)
									local _n, _d__n = (1), (1)
									for _ = 1, 3 do
										if _n % 2 == 1 then
											v2 = -1
										else
											v2 = 3
										end
										last = New(_editor_class["s3_B1_no1_1"], self.x, self.y, v, a + _sp, dt, v2)
										v = v + _d_v
										_n = _n + _d__n
									end
								end
								_sp = _sp + _d__sp
							end
						end
						if (n % 3 == 0) then
							dt = dt - 15
							task._Wait(15)
						else
						end
						n = n + _d_n
						a = a + _d_a
					end
				end
				self._wisys:setAction("cast", 48)
				task._Wait(44)
				do
					local v, _d_v = (3), (-0.5)
					for _ = 1, 2 do
						do
							local a, _d_a = (Angle(self, player) - 20), (40)
							for _ = 1, 2 do
								last = New(_editor_class["s3_灵梦一非追踪札"], self.x, self.y, a, v, 9 + 7 * i)
								task._Wait(0)
								a = a + _d_a
							end
						end
						PlaySound("tan00", 0.1, 0, false)
						task._Wait(20)
						v = v + _d_v
					end
				end
				task._Wait(51)
				task._Wait(198)
				task.MoveTo(-60 * i, 124, 60, MOVE_DECEL)
				self._wisys:setAction("cast", 48)
				i = -i
			end
		end
	end)
end
local function normal1_init_Reimu_H(self)
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 48)
		task._Wait(30)
		local i = 1
		local v2, dt
		do
			for _ = 1, _infinite do
				dt = 50
				do
					local n, _d_n = (1), (1)
					local a, _d_a = (90 + 90 * i), (-360 / 13 * i)
					for _ = 1, 13 do
						PlaySound("tan00", 0.1, 0, false)
						do
							local _sp, _d__sp = (-4), (8 / 4)
							for _ = 1, 5 do
								do
									local v, _d_v = (3), (1)
									local _n, _d__n = (1), (1)
									for _ = 1, 4 do
										if _n % 2 == 1 then
											v2 = -1
										else
											v2 = 3
										end
										last = New(_editor_class["s3_B1_no1_1"], self.x, self.y, v, a + _sp, dt, v2)
										v = v + _d_v
										_n = _n + _d__n
									end
								end
								_sp = _sp + _d__sp
							end
						end
						if (n % 3 == 0) then
							dt = dt - 12
							task._Wait(12)
						end
						n = n + _d_n
						a = a + _d_a
					end
				end
				self._wisys:setAction("cast", 48)
				task._Wait(21)
				do
					local v, _d_v = (4), (-0.3)
					for _ = 1, 3 do
						do
							local a, _d_a = (Angle(self, player) - 45), (30)
							for _ = 1, 4 do
								last = New(_editor_class["s3_灵梦一非追踪札"], self.x, self.y, a, v, 9 + 7 * i)
								a = a + _d_a
							end
						end
						PlaySound("tan00", 0.1, 0, false)
						task._Wait(20)
						v = v + _d_v
					end
				end
				task._Wait(51)
				task._Wait(198)
				task.MoveTo(-60 * i, 124, 60, MOVE_DECEL)
				self._wisys:setAction("cast", 48)
				i = -i
			end
		end
	end)
end
local function normal1_init_Reimu_L(self)
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 48)
		task._Wait(30)
		local i = 1
		local v2, dt
		do
			for _ = 1, _infinite do
				dt = 50
				--[[ 5*10 --]]--[=[ --]=]
				do
					local n, _d_n = (1), (1)
					local a, _d_a = (90 + 90 * i), (-24 * i)
					for _ = 1, 15 do
						PlaySound("tan00", 0.1, 0, false)
						do
							local _sp, _d__sp = (-4.5), (9 / 5)
							for _ = 1, 6 do
								do
									local v, _d_v = (3), (1)
									local _n, _d__n = (1), (1)
									for _ = 1, 5 do
										if _n % 2 == 1 then
											v2 = -1.25
										else
											v2 = 3.5
										end
										last = New(_editor_class["s3_B1_no1_1"], self.x, self.y, v, a + _sp, dt, v2)
										v = v + _d_v
										_n = _n + _d__n
									end
								end
								_sp = _sp + _d__sp
							end
						end
						if (n % 3 == 0) then
							dt = dt - 10
							task._Wait(10)
						else
						end
						n = n + _d_n
						a = a + _d_a
					end
				end
				do
					local v, _d_v = (4), (-0.3)
					for _ = 1, 5 do
						do
							local a, _d_a = (Angle(self, player) - 60), (120 / 5)
							for _ = 1, 6 do
								last = New(_editor_class["s3_灵梦一非追踪札"], self.x, self.y, a, v, 9 + 7 * i)
								task._Wait(0)
								a = a + _d_a
							end
						end
						PlaySound("tan00", 0.5, 0, false)
						task._Wait(20)
						v = v + _d_v
					end
				end
				task._Wait(30)
				task._Wait(180)
				task.MoveTo(-60 * i, 124, 60, MOVE_DECEL)
				self._wisys:setAction("cast", 48)
				i = -i
				task._Wait(0)
			end
		end
	end)
end
local function normal1_init_Yukari_E(self)
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 88)
		task._Wait(30)
		local i = 1
		do
			local a0
			for _ = 1, _infinite do
				task._Wait(180)
				do
					local a, _d_a = (90 - 90 * i), (45 * i)
					for _ = 1, 12 do
						PlaySound("tan00", 0.1, 0, false)
						do
							local b, _d_b = (0), (180)
							for _ = 1, 2 do
								last = New(_editor_class["s3_灵梦一非札弹"], self.x, self.y, 6, a + b, arrow_small, 5 - 1 * i)
								task._Wait(0)
								b = b + _d_b
							end
						end
						task._Wait(10)
						a = a + _d_a
					end
				end
				task._Wait(24)
				do
					a0 = Angle(self, player)
					for k = 1, 6 do
						PlaySound("tan00", 0.1, 0, false)
						do
							local a, _d_a = a0 + 12*k*i, 45*i
							for _ = 1, 8 do
								_create_bullet_group(arrow_small, 4 + 1 * i, self.x, self.y, 1, 0, 1.5, 1.5, a, 0, false, 0, false, true, 0, false, self)
								task._Wait(0)
								a = a + _d_a
							end
						end
						task._Wait(10)
					end
				end
				task.MoveTo(60 * i, 124, 60, MOVE_DECEL)
				i = -i
				task._Wait(0)
			end
		end
	end)
end
local function normal1_init_Yukari_N(self)
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 88)
		task._Wait(30)
		local i = 1
		do
			local a0
			for _ = 1, _infinite do
				task._Wait(180)
				do
					local a, _d_a = (90 - 90 * i), (30 * i)
					for _ = 1, 15 do
						do
							local b, _d_b = (0), (120)
							for _ = 1, 3 do
								do
									local c, _d_c = (-1), (2)
									for _ = 1, 2 do
										last = New(_editor_class["s3_灵梦一非札弹"], self.x, self.y, 4, a + b + c, arrow_small, 5 - 1 * i)
										c = c + _d_c
									end
								end
								task._Wait(0)
								b = b + _d_b
							end
						end
						PlaySound("tan00", 0.1, 0, false)
						task._Wait(8)
						a = a + _d_a
					end
				end
				task._Wait(20)
				do
					a0 = Angle(self, player)
					for k = 1, 6 do
						do
							local a, _d_a = a0 + 10*k*i, 36*i
							for _ = 1, 10 do
								_create_bullet_group(arrow_small, 4 + 1 * i, self.x, self.y, 2, 0, 1.5, 2.5, a, 0, false, 0, false, true, 0, false, self)
								task._Wait(0)
								a = a + _d_a
							end
						end
						PlaySound("tan00", 0.1, 0, false)
						task._Wait(10)
					end
				end
				task.MoveTo(60 * i, 124, 60, MOVE_DECEL)
				i = -i
				task._Wait(0)
			end
		end
	end)
end
local function normal1_init_Yukari_H(self)
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 88)
		task._Wait(30)
		local i = 1
		do
			local a0
			for _ = 1, _infinite do
				task._Wait(180)
				do
					local a, _d_a = (90 - 90 * i), (16 * i)
					for _ = 1, 24 do
						do
							local b, _d_b = (0), (90)
							for _ = 1, 4 do
								do
									local c, _d_c = (-2), (2)
									for _ = 1, 3 do
										last = New(_editor_class["s3_灵梦一非札弹"], self.x, self.y, 5, a + b + c, arrow_small, 5 - 1 * i)
										c = c + _d_c
									end
								end
								b = b + _d_b
							end
						end
						PlaySound("tan00", 0.1, 0, false)
						task._Wait(5)
						a = a + _d_a
					end
				end
				task._Wait(18)
				do
					a0 = Angle(self, player)
					for k = 1, 10 do
						do
							local a, _d_a = a0 + 7*k*i, 30*i
							for _ = 1, 12 do
								_create_bullet_group(arrow_small, 4 + 1 * i, self.x, self.y, 3, 0, 2, 2.5, a, 0, false, 0, false, true, 0, false, self)
								task._Wait(0)
								a = a + _d_a
							end
						end
						PlaySound("tan00", 0.1, 0, false)
						task._Wait(6)
					end
				end
				task.MoveTo(60 * i, 124, 60, MOVE_DECEL)
				i = -i
			end
		end
	end)
end
local function normal1_init_Yukari_L(self)
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 88)
		task._Wait(30)
		local i = 1
		do
			local a0
			for _ = 1, _infinite do
				task._Wait(180)
				do
					local a, _d_a = (90 - 90 * i), (24 * i)
					for _ = 1, 30 do
						do
							local b, _d_b = (0), (90)
							for _ = 1, 4 do
								do
									local c, _d_c = -3, 1.5
									for _ = -2, 2 do
										last = New(_editor_class["s3_灵梦一非札弹"], self.x, self.y, 6, a + b + c, arrow_small, 5 - 1 * i)
										c = c + _d_c
									end
								end
								task._Wait(0)
								b = b + _d_b
							end
						end
						PlaySound("tan00", 0.1, 0, false)
						task._Wait(4)
						a = a + _d_a
					end
				end
				do
					a0 = Angle(self, player)
					for k = 1, 10 do
						do
							local a, _d_a = a0 + 5*k*i, 24*i
							for _ = 1, 15 do
								_create_bullet_group(arrow_small, 4 + 1 * i, self.x, self.y, 4, 0, 2, 3, a, 0, false, 0, false, true, 0, false, self)
								a = a + _d_a
							end
						end
						PlaySound("tan00", 0.5, 0, false)
						task._Wait(6)
					end
				end
				task.MoveTo(60 * i, 124, 60, MOVE_DECEL)
				i = -i
			end
		end
	end)
end
local normal1_init = create_diff_function(
		{ normal1_init_Reimu_E, normal1_init_Reimu_N, normal1_init_Reimu_H, normal1_init_Reimu_L },
		{ normal1_init_Yukari_E, normal1_init_Yukari_N, normal1_init_Yukari_H, normal1_init_Yukari_L },
		true)
local normal1_del = create_diff_function(
		{ false, false, false, false },
		{ false, false, false, false },
		false)
--endregion

--region card 1
local function card1_init_Reimu_E(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 84, 60, MOVE_NORMAL)
	end)
	lasttask = task.New(self, function()
		do
			s3B_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
				task._Wait(60)
			end
		end
		local i = 1
		do
			for _ = 1, _infinite do
				local j = i
				do
					local a, _d_a, a0 = (Angle(self, player)), (10 * i)
					local aa, _d_aa = (60*i), (3.25 * i)
					for _ = 1, 30 do
						for j = 1, 4 do
							a0 = a + 90*j
							for i = 0, 0 do
								New(_editor_class["s3_灵梦一符札弹"], self.x + 64 * cos(a0), self.y + 64 * sin(a0), 1.8 + 0.15*i, a0 + aa, 9 + 7 * (-1 + 2*(i%2)))
							end
						end
						j = -j
						PlaySound("kira00")
						task.Wait(8)
						a = a + _d_a
						aa = aa + _d_aa
					end
				end
				task._Wait(180)
				task._Wait(240)
				i = -i
				task._Wait(0)
			end
		end
	end)
end
local function card1_init_Reimu_N(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 84, 60, MOVE_NORMAL)
	end)
	lasttask = task.New(self, function()
		do
			s3B_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
				task._Wait(60)
			end
		end
		local i = 1
		do
			for _ = 1, _infinite do
				local j = i
				do
					local a, _d_a, a0 = (Angle(self, player)), (10 * i)
					local aa, _d_aa = (60*i), (3.25 * i)
					for _ = 1, 40 do
						for j = 1, 5 do
							a0 = a + 72*j
							for i = 0, 1 do
								New(_editor_class["s3_灵梦一符札弹"], self.x + 64 * cos(a0), self.y + 64 * sin(a0), 1.8 + 0.15*i, a0 + aa, 9 + 7 * (-1 + 2*(i%2)))
							end
						end
						j = -j
						PlaySound("kira00")
						task.Wait(6)
						a = a + _d_a
						aa = aa + _d_aa
					end
				end
				task._Wait(180)
				task._Wait(240)
				i = -i
				task._Wait(0)
			end
		end
	end)
end
local function card1_init_Reimu_H(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 84, 60, MOVE_NORMAL)
	end)
	lasttask = task.New(self, function()
		do
			s3B_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
				task._Wait(60)
			end
		end
		local i = 1
		do
			for _ = 1, _infinite do
				local j = i
				do
					local a, _d_a, a0 = (Angle(self, player)), (10 * i)
					local aa, _d_aa = (60*i), (3.25 * i)
					for _ = 1, 48 do
						for j = 1, 5 do
							a0 = a + 72*j
							for i = 0, 2 do
								New(_editor_class["s3_灵梦一符札弹"], self.x + 64 * cos(a0), self.y + 64 * sin(a0), 1.8 + 0.15*i, a0 + aa, 9 + 7 * (-1 + 2*(i%2)))
							end
						end
						j = -j
						PlaySound("kira00")
						task.Wait(5)
						a = a + _d_a
						aa = aa + _d_aa
					end
				end
				task._Wait(180)
				task._Wait(240)
				i = -i
				task._Wait(0)
			end
		end
	end)
end
local function card1_init_Reimu_L(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 84, 60, MOVE_NORMAL)
	end)
	lasttask = task.New(self, function()
		do
			s3B_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
				task._Wait(60)
			end
		end
		local i = 1
		do
			for _ = 1, _infinite do
				local j = i
				do
					local a, _d_a, a0 = (Angle(self, player)), (10 * i)
					local aa, _d_aa = (60*i), (3.25 * i)
					for _ = 1, 60 do
						for j = 1, 6 do
							a0 = a + 60*j
							for i = 0, 3 do
								New(_editor_class["s3_灵梦一符札弹"], self.x + 64 * cos(a0), self.y + 64 * sin(a0), 1.8 + 0.15*i, a0 + aa, 9 + 7 * (-1 + 2*(i%2)))
							end
						end
						j = -j
						PlaySound("kira00")
						task.Wait(4)
						a = a + _d_a
						aa = aa + _d_aa
					end
				end
				task._Wait(180)
				task._Wait(240)
				i = -i
				task._Wait(0)
			end
		end
	end)
end
local function card1_init_Yukari_E(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 144, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
				task._Wait(60)
			end
		end
		local ii = 1
		do
			for _ = 1, _infinite do
				lasttask = task.New(self, function()
					task._Wait(320)
					do
						for _ = 1, 1 do
							a = Angle(self, player)
							do
								local da, _d_da = (0), (20)
								local t, _d_t = (0), (5)
								for _ = 1, 4 do
									do
										local u, _d_u = (-1), (2)
										for _ = 1, 2 do
											last = New(_editor_class["s3_紫一符镭射"], self.x, self.y, a, da, t, u)
											u = u + _d_u
										end
									end
									task._Wait(0)
									da = da + _d_da
									t = t + _d_t
								end
							end
							task._Wait(180)
						end
					end
				end)
				task._Wait(270)
				local jj = ii
				do
					local a, _d_a, a0 = (Angle(self, player)), (10 * ii)
					local aa, _d_aa = (60*ii), (3.25 * ii)
					for _ = 1, 30 do
						for j = 1, 4 do
							a0 = a + 90*j
							for i = 0, 0 do
								last = New(_editor_class["s3_紫一符青山"], self.x + 64 * cos(a0), self.y + 64 * sin(a0), 1.25 + 0.25*i, a0 + aa, 4 + 1*(-1 + 2*(i%2)))
							end
						end
						jj = -jj
						PlaySound("kira00")
						task.Wait(8)
						a = a + _d_a
						aa = aa + _d_aa
					end
				end
				task._Wait(150)
				ii = -ii
				task._Wait(0)
			end
		end
	end)
end
local function card1_init_Yukari_N(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 144, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
				task._Wait(60)
			end
		end
		local ii = 1
		do
			for _ = 1, _infinite do
				lasttask = task.New(self, function()
					task._Wait(200)
					do
						for _ = 1, 2 do
							a = Angle(self, player)
							do
								local da, _d_da = (0), (15)
								local t, _d_t = (0), (5)
								for _ = 1, 6 do
									do
										local u, _d_u = (-1), (2)
										for _ = 1, 2 do
											last = New(_editor_class["s3_紫一符镭射"], self.x, self.y, a, da, t, u)
											u = u + _d_u
										end
									end
									task._Wait(0)
									da = da + _d_da
									t = t + _d_t
								end
							end
							task._Wait(180)
						end
					end
				end)
				task._Wait(270)
				local jj = ii
				do
					local a, _d_a, a0 = (Angle(self, player)), (10 * ii)
					local aa, _d_aa = (60*ii), (3.25 * ii)
					for _ = 1, 40 do
						for j = 1, 5 do
							a0 = a + 72*j
							for i = 0, 1 do
								last = New(_editor_class["s3_紫一符青山"], self.x + 64 * cos(a0), self.y + 64 * sin(a0), 1.25 + 0.25*i, a0 + aa, 4 + 1*(-1 + 2*(i%2)))
							end
						end
						jj = -jj
						PlaySound("kira00")
						task.Wait(6)
						a = a + _d_a
						aa = aa + _d_aa
					end
				end
				task._Wait(150)
				ii = -ii
				task._Wait(0)
			end
		end
	end)
end
local function card1_init_Yukari_H(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 144, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
				task._Wait(60)
			end
		end
		local ii = 1
		do
			for _ = 1, _infinite do
				lasttask = task.New(self, function()
					task._Wait(60)
					do
						for _ = 1, 3 do
							a = Angle(self, player)
							do
								local da, _d_da = (0), (10)
								local t, _d_t = (0), (5)
								for _ = 1, 8 do
									do
										local u, _d_u = (-1), (2)
										for _ = 1, 2 do
											last = New(_editor_class["s3_紫一符镭射"], self.x, self.y, a, da, t, u)
											u = u + _d_u
										end
									end
									task._Wait(0)
									da = da + _d_da
									t = t + _d_t
								end
							end
							task._Wait(160)
						end
					end
				end)
				task._Wait(270)
				local jj = ii
				do
					local a, _d_a, a0 = (Angle(self, player)), (10 * ii)
					local aa, _d_aa = (60*ii), (3.25 * ii)
					for _ = 1, 48 do
						for j = 1, 5 do
							a0 = a + 72*j
							for i = 0, 2 do
								last = New(_editor_class["s3_紫一符青山"], self.x + 64 * cos(a0), self.y + 64 * sin(a0), 1.25 + 0.25*i, a0 + aa, 4 + 1*(-1 + 2*(i%2)))
							end
						end
						jj = -jj
						PlaySound("kira00")
						task.Wait(5)
						a = a + _d_a
						aa = aa + _d_aa
					end
				end
				task._Wait(150)
				ii = -ii
				task._Wait(0)
			end
		end
	end)
end
local function card1_init_Yukari_L(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 144, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
				task._Wait(60)
			end
		end
		local ii = -1
		local a
		do
			for _ = 1, _infinite do
				lasttask = task.New(self, function()
					task._Wait(60)
					do
						for _ = 1, 4 do
							a = Angle(self, player)
							do
								local da, _d_da = (0), (7.5)
								local t, _d_t = (0), (5)
								for _ = 1, 10 do
									do
										local u, _d_u = (-1), (2)
										for _ = 1, 2 do
											last = New(_editor_class["s3_紫一符镭射"], self.x, self.y, a, da, t, u)
											u = u + _d_u
										end
									end
									task._Wait(0)
									da = da + _d_da
									t = t + _d_t
								end
							end
							task._Wait(125)
						end
					end
				end)
				task._Wait(270)
				local jj = ii
				do
					local a, _d_a, a0 = (Angle(self, player)), (10 * ii)
					local aa, _d_aa = (60*ii), (3.25 * ii)
					for _ = 1, 60 do
						for j = 1, 6 do
							a0 = a + 60*j
							for i = 0, 3 do
								last = New(_editor_class["s3_紫一符青山"], self.x + 64 * cos(a0), self.y + 64 * sin(a0), 1.25 + 0.25*i, a0 + aa, 4 + 1*(-1 + 2*(i%2)))
							end
						end
						jj = -jj
						PlaySound("kira00")
						task.Wait(4)
						a = a + _d_a
						aa = aa + _d_aa
					end
				end
				task._Wait(150)
				ii = -ii
				task._Wait(0)
			end
		end
	end)
end
local function card1_del_Reimu_ENHL(self)
	Spell_break_eff(self.x, self.y, 255, 0, 0,
			'yukari_star', 'reimu_leaf')
end
local function card1_del_Yukari_ENHL(self)
	Spell_break_eff(self.x, self.y, 255, 0, 255,
			'yukari_star', 'reimu_leaf')
end
local card1_init = create_diff_function(
		{ card1_init_Reimu_E, card1_init_Reimu_N, card1_init_Reimu_H, card1_init_Reimu_L },
		{ card1_init_Yukari_E, card1_init_Yukari_N, card1_init_Yukari_H, card1_init_Yukari_L },
		true,
		{
			{"御札「退魔符乱舞」", "结界「人间至处的青山」"},
			{"御札「退魔符乱舞」", "结界「人间至处的青山」"},
			{"神灵「梦想封印 瞾」", "结界「人间极乐的青山」"},
			{"神灵「梦想封印 瞾」", "结界「人间极乐的青山」"},
		})
local card1_del = create_diff_function(
		{ card1_del_Reimu_ENHL, card1_del_Reimu_ENHL, card1_del_Reimu_ENHL, card1_del_Reimu_ENHL },
		{ card1_del_Yukari_ENHL, card1_del_Yukari_ENHL, card1_del_Yukari_ENHL, card1_del_Yukari_ENHL },
		false)
--endregion

--region normal 2
local function normal2_init_Reimu_E(self)
	lasttask = task.New(self, function()
		task.MoveTo(60, 104, 60, MOVE_DECEL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
			task._Wait(60)
		end
		task._Wait(30)
		local dx, dy
		local u, _u = 1
		do
			for _ = 1, _infinite do
				self._wisys:setAction("cast", 48)
				task._Wait(30)
				do
					local a, _d_a = (100 - 18 * u), (-30 * u)
					local dt, _d_dt = (15), (-2)
					for _ = 1, 12 do
						PlaySound("tan00", 0.1, 0, false)
						dx, dy = 40 * cos(a), 40 * sin(a)
						do
							local _sp, _d__sp = (-2), (4)
							local da, _d_da = (90), (80)
							for _ = 1, 1 do
								do
									local v, _d_v = (1), (0.3)
									local v2, _d_v2 = (5), (-0.5)
									for _ = 1, 7 do
										last = New(_editor_class["s3_B1_no2_1"], self.x + dx, self.y + dy, v, a + _sp * u - 120 * u, dt, v2, da, u)
										v = v + _d_v
										v2 = v2 + _d_v2
									end
								end
								_sp = _sp + _d__sp
								da = da + _d_da
							end
						end
						task._Wait(5)
						a = a + _d_a
						dt = dt + _d_dt
					end
				end
				task._Wait(120)
				_u = u
				lasttask = task.New(self, function()
					task.MoveTo(60 * u, 104, 70, MOVE_NORMAL)
				end)
				u = -u
				do
					local a
					for k = 0, 2 do
						a = Angle(self, player)
						for i = 1, 10 do
							for j = 0, 0 do
								stg.newBulletStraight(stg.ball_big, 2, true, self.x, self.y, 1.5 - 0.5*j + 0.45*k, a + 36*i + 12*j)
							end
						end
						PlaySound("tan00")
						task.Wait(20)
					end
				end
				task.Wait(10)
				PlaySound("tan00", 0.1, 0, false)
				do
					local a, _d_a = (Angle(self, player)), (40)
					for _ = 1, 9 do
						dx, dy = 30 * cos(a), 30 * sin(a)
						do
							local dv, _d_dv = (0), (1)
							for _ = 1, 1 do
								last = New(_straight, square, COLOR_GRAY, self.x + dx, self.y + dy, 3 + dv, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								AddSimStrChV(last, 0, -dv - 3.5, a, 30)
								AddSimStrChV(last, 0, 5 + dv, a, 240, nil, nil, 60)
								dv = dv + _d_dv
							end
						end
						a = a + _d_a
					end
				end
				task.Wait(120)
			end
		end
	end)
end
local function normal2_init_Reimu_N(self)
	lasttask = task.New(self, function()
		task.MoveTo(60, 104, 60, MOVE_DECEL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
			task._Wait(60)
		end
		task._Wait(30)
		local dx, dy
		local u, _u = 1
		do
			for _ = 1, _infinite do
				self._wisys:setAction("cast", 48)
				task._Wait(30)
				do
					local a, _d_a = (100 - 18 * u), (-30 * u)
					local dt, _d_dt = (15), (-2)
					for _ = 1, 12 do
						PlaySound("tan00", 0.1, 0, false)
						dx, dy = 40 * cos(a), 40 * sin(a)
						do
							local _sp, _d__sp = (-2), (4)
							local da, _d_da = (90), (80)
							for _ = 1, 2 do
								do
									local v, _d_v = (1), (0.3)
									local v2, _d_v2 = (6), (-0.5)
									for _ = 1, 9 do
										last = New(_editor_class["s3_B1_no2_1"], self.x + dx, self.y + dy, v, a + _sp * u - 120 * u, dt, v2, da, u)
										v = v + _d_v
										v2 = v2 + _d_v2
									end
								end
								_sp = _sp + _d__sp
								da = da + _d_da
							end
						end
						task._Wait(5)
						a = a + _d_a
						dt = dt + _d_dt
					end
				end
				task._Wait(120)
				_u = u
				lasttask = task.New(self, function()
					task.MoveTo(60 * u, 104, 70, MOVE_NORMAL)
				end)
				u = -u
				do
					--[[local way, _d_way = (2), (0.5)
					for _ = 1, 3 do
						PlaySound("tan00", 0.1, 0, false)
						do
							local a, _d_a = (Angle(self, player) + 4 * _u), (-1 * _u)
							local v, _d_v = (3.8 + 0.2 * way), (-0.2)
							for _ = 1, way do
								last = New(_straight, square, COLOR_GRAY, self.x, self.y, v, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								a = a + _d_a
								v = v + _d_v
							end
						end
						_u = -_u
						task._Wait(20)
						way = way + _d_way
					end]]
					local a
					for k = 0, 6 do
						a = Angle(self, player)
						for i = 1, 15 do
							for j = 0, 0 do
								stg.newBulletStraight(stg.ball_big, 2, true, self.x, self.y, 1.5 - 0.5*j + 0.45*k, a + 24*i + 12*j)
							end
						end
						PlaySound("tan00")
						task.Wait(10)
					end
				end
				task._Wait(10)
				PlaySound("tan00", 0.1, 0, false)
				do
					local a, _d_a = (Angle(self, player)), (22.5)
					for _ = 1, 16 do
						dx, dy = 30 * cos(a), 30 * sin(a)
						do
							local dv, _d_dv = (0), (1)
							for _ = 1, 1 do
								last = New(_straight, square, COLOR_GRAY, self.x + dx, self.y + dy, 3 + dv, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								AddSimStrChV(last, 0, -dv - 3.5, a, 30)
								AddSimStrChV(last, 0, 5 + dv, a, 240, nil, nil, 60)
								dv = dv + _d_dv
							end
						end
						a = a + _d_a
					end
				end
				task._Wait(120)
			end
		end
	end)
end
local function normal2_init_Reimu_H(self)
	lasttask = task.New(self, function()
		task.MoveTo(60, 104, 60, MOVE_DECEL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
			task._Wait(60)
		end
		task._Wait(30)
		local dx, dy
		local u, _u = 1
		do
			for _ = 1, _infinite do
				self._wisys:setAction("cast", 48)
				task._Wait(30)
				do
					local a, _d_a = (100 - 18 * u), (-24 * u)
					local dt, _d_dt = (15), (-2)
					for _ = 1, 15 do
						PlaySound("tan00", 0.1, 0, false)
						dx, dy = 40 * cos(a), 40 * sin(a)
						do
							local _sp, _d__sp = (-2), (4)
							local da, _d_da = (90), (80)
							for _ = 1, 2 do
								do
									local v, _d_v = (1), (0.3)
									local v2, _d_v2 = (7), (-0.5)
									for _ = 1, 11 do
										last = New(_editor_class["s3_B1_no2_1"], self.x + dx, self.y + dy, v, a + _sp * u - 120 * u, dt, v2, da, u)
										v = v + _d_v
										v2 = v2 + _d_v2
									end
								end
								_sp = _sp + _d__sp
								da = da + _d_da
							end
						end
						task._Wait(4)
						a = a + _d_a
						dt = dt + _d_dt
					end
				end
				task._Wait(120)
				_u = u
				lasttask = task.New(self, function()
					task.MoveTo(60 * u, 104, 70, MOVE_NORMAL)
				end)
				u = -u
				do
					--[[local way, _d_way = (2), (0.5)
					for _ = 1, 5 do
						PlaySound("tan00", 0.1, 0, false)
						do
							local a, _d_a = (Angle(self, player) + 4 * _u), (-1 * _u)
							local v, _d_v = (3.8 + 0.2 * way), (-0.2)
							for _ = 1, way do
								last = New(_straight, square, COLOR_GRAY, self.x, self.y, v, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								a = a + _d_a
								v = v + _d_v
							end
						end
						_u = -_u
						task._Wait(12)
						way = way + _d_way
					end]]
					local a
					for k = 0, 6 do
						a = Angle(self, player)
						for i = 1, 15 do
							for j = 0, 1 do
								stg.newBulletStraight(stg.ball_big, 2, true, self.x, self.y, 1.5 - 0.5*j + 0.45*k, a + 24*i + 12*j)
							end
						end
						PlaySound("tan00")
						task.Wait(10)
					end
				end
				task._Wait(10)
				PlaySound("tan00", 0.1, 0, false)
				do
					local a, _d_a = (Angle(self, player)), (18)
					for _ = 1, 20 do
						dx, dy = 30 * cos(a), 30 * sin(a)
						do
							local dv, _d_dv = (0), (1)
							for _ = 1, 2 do
								last = New(_straight, square, COLOR_GRAY, self.x + dx, self.y + dy, 3 + dv, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								AddSimStrChV(last, 0, -dv - 3.5, a, 30)
								AddSimStrChV(last, 0, 5 + dv, a, 240, nil, nil, 60)
								dv = dv + _d_dv
							end
						end
						a = a + _d_a
					end
				end
				task._Wait(120)
			end
		end
	end)
end
local function normal2_init_Reimu_L(self)
	lasttask = task.New(self, function()
		task.MoveTo(60, 104, 60, MOVE_DECEL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
			task._Wait(60)
		end
		task._Wait(30)
		local dx, dy
		local u, _u = 1
		do
			for _ = 1, _infinite do
				self._wisys:setAction("cast", 48)
				task._Wait(30)
				do
					local a, _d_a = (100 - 18 * u), (-24 * u)
					local dt, _d_dt = (15), (-2)
					for _ = 1, 15 do
						PlaySound("tan00", 0.1, 0, false)
						dx, dy = 40 * cos(a), 40 * sin(a)
						do
							local _sp, _d__sp = (-2), (4)
							local da, _d_da = (90), (80)
							for _ = 1, 3 do
								do
									local v, _d_v = (1), (0.3)
									local v2, _d_v2 = (8), (-0.5)
									for _ = 1, 13 do
										last = New(_editor_class["s3_B1_no2_1"], self.x + dx, self.y + dy, v, a + _sp * u - 120 * u, dt, v2, da, u)
										v = v + _d_v
										v2 = v2 + _d_v2
									end
								end
								_sp = _sp + _d__sp
								da = da + _d_da
							end
						end
						task._Wait(4)
						a = a + _d_a
						dt = dt + _d_dt
					end
				end
				task._Wait(120)
				_u = u
				lasttask = task.New(self, function()
					task.MoveTo(60 * u, 104, 70, MOVE_NORMAL)
				end)
				u = -u
				do
					--[[local way, _d_way = (3), (0.5)
					for _ = 1, 7 do
						PlaySound("tan00", 0.1, 0, false)
						do
							local a, _d_a = (Angle(self, player) + 4 * _u), (-1 * _u)
							local v, _d_v = (4 + 0.2 * way), (-0.2)
							for _ = 1, way do
								last = New(_straight, square, COLOR_GRAY, self.x, self.y, v, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								a = a + _d_a
								v = v + _d_v
							end
						end
						_u = -_u
						task._Wait(10)
						way = way + _d_way
					end]]
					local a
					for k = 0, 13 do
						a = Angle(self, player)
						for i = 1, 20 do
							for j = 0, 1 do
								stg.newBulletStraight(stg.ball_big, 2, true, self.x, self.y, 1.5 - 0.5*j + 0.3*k, a + 36*i + 18*j)
							end
						end
						PlaySound("tan00")
						task.Wait(5)
					end
				end
				PlaySound("tan00", 0.1, 0, false)
				do
					local a, _d_a = (Angle(self, player)), (15)
					for _ = 1, 24 do
						dx, dy = 30 * cos(a), 30 * sin(a)
						do
							local dv, _d_dv = (0), (1)
							for _ = 1, 3 do
								last = New(_straight, square, COLOR_GRAY, self.x + dx, self.y + dy, 3 + dv, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								AddSimStrChV(last, 0, -dv - 3.5, a, 30)
								AddSimStrChV(last, 0, 5 + dv, a, 240, nil, nil, 60)
								dv = dv + _d_dv
							end
						end
						a = a + _d_a
					end
				end
				task._Wait(120)
			end
		end
	end)
end
local function normal2_init_Yukari_E(self)
	lasttask = task.New(self, function()
		task.MoveTo(-60, 104, 60, MOVE_NORMAL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
			task._Wait(60)
		end
		task._Wait(30)
		local dx, dy
		local u = -1
		local a, _a
		do
			for _ = 1, _infinite do
				self._wisys:setAction("cast", 88)
				task._Wait(30)
				--[[ 60 --]]--[=[ --]=]
				a = -90 - 10 * u
				lasttask = task.New(self, function()
					task._Wait(30)
					do
						for _ = 1, 60 do
							a = a - 0.5 * u
							task._Wait(1)
						end
					end
					do
						for _ = 1, 60 do
							a = a + 0.5 * u
							task._Wait(1)
						end
					end
				end)
				lasttask = task.New(self, function()
					task._Wait(180)
					u = -u
					task.MoveTo(60 * u, 104, 70, MOVE_NORMAL)
				end)
				do
					local x, _d_x = (150), (4.8)
					for _ = 1, 44 do
						do
							local dx, _d_dx = (0), (20)
							for _ = 1, 2 do
								do
									local u, _d_u = (1), (-2)
									for _ = 1, 2 do
										_a = a + (100 + 80 * sin(x + dx)) * u
										last = New(_straight, ball_mid, COLOR_DEEP_PURPLE, self.x + 40 * cos(_a), self.y + 40 * sin(_a), 3.5, _a, false, 0, true, true, 0, false, 0, 0, 0, false)
										_object.set_color(last, "mul+add", 255, 255, 255, 255)
										u = u + _d_u
									end
								end
								dx = dx + _d_dx
							end
						end
						do
							local dx, _d_dx = (0), (20)
							for _ = 1, 2 do
								do
									local u, _d_u = (1), (-2)
									for _ = 1, 2 do
										_a = a + (180 + 150 * sin(0.5 * x + dx + 90)) * u
										last = New(_straight, ball_mid, COLOR_DEEP_PURPLE, self.x + 40 * cos(_a), self.y + 40 * sin(_a), 3.5, _a, false, 0, true, true, 0, false, 0, 0, 0, false)
										_object.set_color(last, "mul+add", 255, 255, 255, 255)
										u = u + _d_u
									end
								end
								dx = dx + _d_dx
							end
						end
						task._Wait(5)
						x = x + _d_x
					end
				end
				task._Wait(30)
				PlaySound("tan00", 0.1, 0, false)
				do
					local a, _d_a = (Angle(self, player)), (40)
					for _ = 1, 9 do
						dx, dy = 30 * cos(a), 30 * sin(a)
						do
							local dv, _d_dv = (0), (1)
							for _ = 1, 1 do
								last = New(_straight, butterfly, COLOR_DEEP_PURPLE, self.x + dx, self.y + dy, 3 + dv, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								AddSimStrChV(last, 0, -dv - 3.5, a, 30)
								AddSimStrChV(last, 0, 5 + dv, a, 240, nil, nil, 60)
								dv = dv + _d_dv
							end
						end
						a = a + _d_a
					end
				end
				task._Wait(120)
			end
		end
	end)
end
local function normal2_init_Yukari_N(self)
	lasttask = task.New(self, function()
		task.MoveTo(-60, 104, 60, MOVE_NORMAL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
			task._Wait(60)
		end
		task._Wait(30)
		local dx, dy
		local u = -1
		local a, _a
		do
			for _ = 1, _infinite do
				self._wisys:setAction("cast", 88)
				task._Wait(30)
				--[[ 60 --]]--[=[ --]=]
				a = -90 - 10 * u
				lasttask = task.New(self, function()
					task._Wait(30)
					do
						for _ = 1, 60 do
							a = a - 0.5 * u
							task._Wait(1)
						end
					end
					do
						for _ = 1, 60 do
							a = a + 0.5 * u
							task._Wait(1)
						end
					end
				end)
				lasttask = task.New(self, function()
					task._Wait(180)
					u = -u
					task.MoveTo(60 * u, 104, 70, MOVE_NORMAL)
				end)
				do
					local x, _d_x = (150), (4.8)
					for _ = 1, 55 do
						do
							local dx, _d_dx = (0), (20)
							for _ = 1, 2 do
								do
									local u, _d_u = (1), (-2)
									for _ = 1, 2 do
										_a = a + (100 + 85 * sin(x + dx)) * u
										last = New(_straight, ball_mid, COLOR_DEEP_PURPLE, self.x + 40 * cos(_a), self.y + 40 * sin(_a), 4, _a, false, 0, true, true, 0, false, 0, 0, 0, false)
										_object.set_color(last, "mul+add", 255, 255, 255, 255)
										u = u + _d_u
									end
								end
								dx = dx + _d_dx
							end
						end
						do
							local dx, _d_dx = (0), (20)
							for _ = 1, 2 do
								do
									local u, _d_u = (1), (-2)
									for _ = 1, 2 do
										_a = a + (180 + 155 * sin(0.5 * x + dx + 90)) * u
										last = New(_straight, ball_mid, COLOR_DEEP_PURPLE, self.x + 40 * cos(_a), self.y + 40 * sin(_a), 4, _a, false, 0, true, true, 0, false, 0, 0, 0, false)
										_object.set_color(last, "mul+add", 255, 255, 255, 255)
										u = u + _d_u
									end
								end
								dx = dx + _d_dx
							end
						end
						task._Wait(4)
						x = x + _d_x
					end
				end
				task._Wait(30)
				PlaySound("tan00", 0.1, 0, false)
				do
					local a, _d_a = (Angle(self, player)), (22.5)
					for _ = 1, 16 do
						dx, dy = 30 * cos(a), 30 * sin(a)
						do
							local dv, _d_dv = (0), (1)
							for _ = 1, 1 do
								last = New(_straight, butterfly, COLOR_DEEP_PURPLE, self.x + dx, self.y + dy, 3 + dv, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								AddSimStrChV(last, 0, -dv - 3.5, a, 30)
								AddSimStrChV(last, 0, 5 + dv, a, 240, nil, nil, 60)
								dv = dv + _d_dv
							end
						end
						a = a + _d_a
					end
				end
				task._Wait(120)
			end
		end
	end)
end
local function normal2_init_Yukari_H(self)
	lasttask = task.New(self, function()
		task.MoveTo(-60, 104, 60, MOVE_NORMAL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
			task._Wait(60)
		end
		task._Wait(30)
		local dx, dy
		local u = -1
		local a, _a
		do
			for _ = 1, _infinite do
				self._wisys:setAction("cast", 88)
				task._Wait(30)
				--[[ 60 --]]--[=[ --]=]
				a = -90 - 10 * u
				lasttask = task.New(self, function()
					task._Wait(30)
					do
						for _ = 1, 60 do
							a = a - 0.5 * u
							task._Wait(1)
						end
					end
					do
						for _ = 1, 60 do
							a = a + 0.5 * u
							task._Wait(1)
						end
					end
				end)
				lasttask = task.New(self, function()
					task._Wait(180)
					u = -u
					task.MoveTo(60 * u, 104, 70, MOVE_NORMAL)
				end)
				do
					local x, _d_x = (150), (4.8)
					for _ = 1, 76 do
						do
							local dx, _d_dx = (0), (20)
							for _ = 1, 3 do
								do
									local u, _d_u = (1), (-2)
									for _ = 1, 2 do
										_a = a + (100 + 90 * sin(x + dx)) * u
										last = New(_straight, ball_mid, COLOR_DEEP_PURPLE, self.x + 40 * cos(_a), self.y + 40 * sin(_a), 5, _a, false, 0, true, true, 0, false, 0, 0, 0, false)
										_object.set_color(last, "mul+add", 255, 255, 255, 255)
										u = u + _d_u
									end
								end
								dx = dx + _d_dx
							end
						end
						do
							local dx, _d_dx = (0), (20)
							for _ = 1, 3 do
								do
									local u, _d_u = (1), (-2)
									for _ = 1, 2 do
										_a = a + (180 + 157.5 * sin(0.5 * x + dx + 90)) * u
										last = New(_straight, ball_mid, COLOR_DEEP_PURPLE, self.x + 40 * cos(_a), self.y + 40 * sin(_a), 5, _a, false, 0, true, true, 0, false, 0, 0, 0, false)
										_object.set_color(last, "mul+add", 255, 255, 255, 255)
										u = u + _d_u
									end
								end
								dx = dx + _d_dx
							end
						end
						task._Wait(3)
						x = x + _d_x
					end
				end
				task._Wait(22)
				PlaySound("tan00", 0.1, 0, false)
				do
					local a, _d_a = (Angle(self, player)), (18)
					for _ = 1, 20 do
						dx, dy = 30 * cos(a), 30 * sin(a)
						do
							local dv, _d_dv = (0), (1)
							for _ = 1, 2 do
								last = New(_straight, butterfly, COLOR_DEEP_PURPLE, self.x + dx, self.y + dy, 3 + dv, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								AddSimStrChV(last, 0, -dv - 3.5, a, 30)
								AddSimStrChV(last, 0, 5 + dv, a, 240, nil, nil, 60)
								dv = dv + _d_dv
							end
						end
						a = a + _d_a
					end
				end
				task._Wait(120)
			end
		end
	end)
end
local function normal2_init_Yukari_L(self)
	lasttask = task.New(self, function()
		task.MoveTo(-60, 104, 60, MOVE_NORMAL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
			task._Wait(60)
		end
		task._Wait(30)
		local dx, dy
		local u = -1
		local a, _a
		do
			for _ = 1, _infinite do
				self._wisys:setAction("cast", 88)
				task._Wait(30)
				--[[ 60 --]]--[=[ --]=]
				a = -90 - 10 * u
				lasttask = task.New(self, function()
					task._Wait(30)
					do
						for _ = 1, 60 do
							a = a - 0.5 * u
							task._Wait(1)
						end
					end
					do
						for _ = 1, 60 do
							a = a + 0.5 * u
							task._Wait(1)
						end
					end
				end)
				lasttask = task.New(self, function()
					task._Wait(180)
					u = -u
					task.MoveTo(60 * u, 104, 70, MOVE_NORMAL)
				end)
				do
					local x, _d_x = (150), (3.2)
					for _ = 1, 115 do
						do
							local dx, _d_dx = (0), (20)
							for _ = 1, 3 do
								do
									local u, _d_u = (1), (-2)
									for _ = 1, 2 do
										_a = a + (100 + 92 * sin(x + dx)) * u
										last = New(_straight, ball_mid, COLOR_DEEP_PURPLE, self.x + 40 * cos(_a), self.y + 40 * sin(_a), 6, _a, false, 0, true, true, 0, false, 0, 0, 0, false)
										_object.set_color(last, "mul+add", 255, 255, 255, 255)
										u = u + _d_u
									end
								end
								dx = dx + _d_dx
							end
						end
						do
							local dx, _d_dx = (0), (20)
							for _ = 1, 3 do
								do
									local u, _d_u = (1), (-2)
									for _ = 1, 2 do
										_a = a + (180 + 160 * sin(0.5 * x + dx + 90)) * u
										last = New(_straight, ball_mid, COLOR_DEEP_PURPLE, self.x + 40 * cos(_a), self.y + 40 * sin(_a), 6, _a, false, 0, true, true, 0, false, 0, 0, 0, false)
										_object.set_color(last, "mul+add", 255, 255, 255, 255)
										u = u + _d_u
									end
								end
								dx = dx + _d_dx
							end
						end
						task._Wait(2)
						x = x + _d_x
					end
				end
				task._Wait(20)
				PlaySound("tan00", 0.1, 0, false)
				do
					local a, _d_a = (Angle(self, player)), (15)
					for _ = 1, 24 do
						dx, dy = 30 * cos(a), 30 * sin(a)
						do
							local dv, _d_dv = (0), (1)
							for _ = 1, 3 do
								last = New(_straight, butterfly, COLOR_DEEP_PURPLE, self.x + dx, self.y + dy, 3 + dv, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								AddSimStrChV(last, 0, -dv - 3.5, a, 30)
								AddSimStrChV(last, 0, 5 + dv, a, 240, nil, nil, 60)
								dv = dv + _d_dv
							end
						end
						a = a + _d_a
					end
				end
				task._Wait(120)
			end
		end
	end)
end
local normal2_init = create_diff_function(
		{ normal2_init_Reimu_E, normal2_init_Reimu_N, normal2_init_Reimu_H, normal2_init_Reimu_L },
		{ normal2_init_Yukari_E, normal2_init_Yukari_N, normal2_init_Yukari_H, normal2_init_Yukari_L },
		true)
local normal2_del = create_diff_function(
		{ false, false, false, false },
		{ false, false, false, false },
		false)
--endregion

--region card 2
local function card2_init_Reimu_E(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 104, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			s3B_boss.pic_show3()
			task._Wait(120)
		end
		local i = 1
		local j = -1
		do
			for _ = 1, _infinite do
				task._Wait(30)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
						task._Wait(60)
					end
				end)
				task._Wait(60)
				local px, py = max(-60, min(60, player.x)), max(-145, min(145, player.y))
				local ii = i
				do
					local r, _d_r = (140), (80)
					local s, _d_s = (0.8), (0.4)
					for _ = 1, 2 do
						do
							local a, _d_a = (Angle(self, player)), (60)
							for _ = 1, 6 do
								last = New(_editor_class["s3_灵梦二符包围使魔"], self.x, self.y, a, ii, r, px, py, s)
								task._Wait(0)
								a = a + _d_a
							end
						end
						ii = -ii
						task._Wait(15)
						r = r + _d_r
						s = s + _d_s
					end
				end
				task._Wait(180)
				task.MoveTo(0 * j, 104, 60, MOVE_DECEL)
				i = -i
				j = -j
				task._Wait(0)
			end
		end
	end)
end
local function card2_init_Reimu_N(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 104, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			s3B_boss.pic_show3()
			task._Wait(120)
		end
		local i = 1
		local j = -1
		do
			for _ = 1, _infinite do
				task._Wait(30)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
						task._Wait(60)
					end
				end)
				task._Wait(60)
				local px, py = max(-60, min(60, player.x)), max(-145, min(145, player.y))
				local ii = i
				do
					local r, _d_r = (140), (80)
					local s, _d_s = (0.8), (0.4)
					for _ = 1, 2 do
						do
							local a, _d_a = (Angle(self, player)), (60)
							for _ = 1, 6 do
								last = New(_editor_class["s3_灵梦二符包围使魔"], self.x, self.y, a, ii, r, px, py, s)
								task._Wait(0)
								a = a + _d_a
							end
						end
						ii = -ii
						task._Wait(15)
						r = r + _d_r
						s = s + _d_s
					end
				end
				task._Wait(180)
				task.MoveTo(0 * j, 104, 60, MOVE_DECEL)
				i = -i
				j = -j
				task._Wait(0)
			end
		end
	end)
end
local function card2_init_Reimu_H(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 104, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			s3B_boss.pic_show3()
			task._Wait(120)
		end
		local i = 1
		local j = -1
		do
			for _ = 1, _infinite do
				task._Wait(30)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
						task._Wait(60)
					end
				end)
				task._Wait(60)
				local px, py = max(-60, min(60, player.x)), max(-145, min(145, player.y))
				local ii = i
				do
					local r, _d_r = (140), (80)
					local s, _d_s = (0.8), (0.4)
					for _ = 1, 2 do
						do
							local a, _d_a = (Angle(self, player)), (60)
							for _ = 1, 6 do
								last = New(_editor_class["s3_灵梦二符包围使魔"], self.x, self.y, a, ii, r, px, py, s)
								task._Wait(0)
								a = a + _d_a
							end
						end
						ii = -ii
						task._Wait(15)
						r = r + _d_r
						s = s + _d_s
					end
				end
				task._Wait(180)
				task.MoveTo(0 * j, 104, 60, MOVE_DECEL)
				i = -i
				j = -j
				task._Wait(0)
			end
		end
	end)
end
local function card2_init_Reimu_L(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 104, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			s3B_boss.pic_show3()
			task._Wait(120)
		end
		local i = 1
		local j = -1
		do
			for _ = 1, _infinite do
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
						task._Wait(60)
					end
				end)
				task._Wait(60)
				local px, py = max(-60, min(60, player.x)), max(-145, min(145, player.y))
				local ii = i
				do
					local r, _d_r = (120), (60)
					local s, _d_s = (0.6), (0.3)
					for _ = 1, 3 do
						do
							local a, _d_a = (Angle(self, player)), (60)
							for _ = 1, 6 do
								last = New(_editor_class["s3_灵梦二符包围使魔"], self.x, self.y, a, ii, r, px, py, s)
								task._Wait(0)
								a = a + _d_a
							end
						end
						ii = -ii
						task._Wait(10)
						r = r + _d_r
						s = s + _d_s
					end
				end
				task._Wait(180)
				task.MoveTo(0 * j, 104, 60, MOVE_DECEL)
				i = -i
				j = -j
				task._Wait(0)
			end
		end
	end)
end
local function card2_init_Yukari_E(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 144, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
		end
		local i = 1
		local j = 1
		do
			for _ = 1, _infinite do
				task._Wait(30)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
						task._Wait(60)
					end
				end)
				task._Wait(80)
				do
					local a1, _d_a1 = (ran:Float(0, 360)), (120 * i)
					for _ = 1, 2 do
						last = New(_editor_class["s3_紫二符激光预警"], self.x, self.y, a1)
						--task._Wait(30)
						a1 = a1 + _d_a1
					end
				end
				i = -i
				do
					local a1, _d_a1 = (ran:Float(0, 360)), (120 * i)
					for _ = 1, 2 do
						last = New(_editor_class["s3_紫二符激光预警"], self.x, self.y, a1)
						--task._Wait(30)
						a1 = a1 + _d_a1
					end
				end
				i = -i
				do
					local a1, _d_a1 = (ran:Float(0, 360)), (77 * i * 3)
					for _ = 1, 10 do
						last = New(_editor_class["s3_紫二符激光预警"], self.x, self.y, a1)
						--task._Wait(12)
						a1 = a1 + _d_a1
					end
				end
				task.Wait(120)
				i = -i
				task.MoveTo(0 * j, 144, 60, MOVE_DECEL)
				j = -j
				task._Wait(70)
			end
		end
	end)
end
local function card2_init_Yukari_N(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 144, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
		end
		local i = 1
		local j = 1
		do
			for _ = 1, _infinite do
				task._Wait(30)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
						task._Wait(60)
					end
				end)
				task._Wait(80)
				do
					local a1, _d_a1 = (ran:Float(0, 360)), (120 * i * 1.5)
					for _ = 1, 4 do
						last = New(_editor_class["s3_紫二符激光预警"], self.x, self.y, a1)
						--task._Wait(15)
						a1 = a1 + _d_a1
					end
				end
				i = -i
				do
					local a1, _d_a1 = (ran:Float(0, 360)), (120 * i * 1.5)
					for _ = 1, 4 do
						last = New(_editor_class["s3_紫二符激光预警"], self.x, self.y, a1)
						--task._Wait(15)
						a1 = a1 + _d_a1
					end
				end
				i = -i
				do
					local a1, _d_a1 = (ran:Float(0, 360)), (77 * i * 1.5)
					for _ = 1, 20 do
						last = New(_editor_class["s3_紫二符激光预警"], self.x, self.y, a1)
						--task._Wait(6)
						a1 = a1 + _d_a1
					end
				end
				task.Wait(120)
				i = -i
				task.MoveTo(0 * j, 144, 60, MOVE_DECEL)
				j = -j
				task._Wait(70)
			end
		end
	end)
end
local function card2_init_Yukari_H(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 144, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
		end
		local i = 1
		local j = 1
		do
			for _ = 1, _infinite do
				task._Wait(30)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
						task._Wait(60)
					end
				end)
				task._Wait(80)
				do
					local a1, _d_a1 = (ran:Float(0, 360)), (120 * i)
					for _ = 1, 6 do
						last = New(_editor_class["s3_紫二符激光预警"], self.x, self.y, a1)
						--task._Wait(10)
						a1 = a1 + _d_a1
					end
				end
				i = -i
				do
					local a1, _d_a1 = (ran:Float(0, 360)), (120 * i)
					for _ = 1, 6 do
						last = New(_editor_class["s3_紫二符激光预警"], self.x, self.y, a1)
						--task._Wait(10)
						a1 = a1 + _d_a1
					end
				end
				i = -i
				do
					local a1, _d_a1 = (ran:Float(0, 360)), (77 * i * 1.25)
					for _ = 1, 24 do
						last = New(_editor_class["s3_紫二符激光预警"], self.x, self.y, a1)
						--task._Wait(5)
						a1 = a1 + _d_a1
					end
				end
				task.Wait(120)
				i = -i
				task.MoveTo(0 * j, 144, 60, MOVE_DECEL)
				j = -j
				task._Wait(70)
			end
		end
	end)
end
local function card2_init_Yukari_L(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 144, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
		end
		local i = 1
		local j = 1
		do
			for _ = 1, _infinite do
				task._Wait(30)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
						task._Wait(60)
					end
				end)
				task._Wait(80)
				PlaySound("kira00")
				do
					local a1, _d_a1 = (ran:Float(0, 360)), (120 * i)
					for _ = 1, 6 do
						last = New(_editor_class["s3_紫二符激光预警"], self.x, self.y, a1)
						--task._Wait(10)
						a1 = a1 + _d_a1
					end
				end
				i = -i
				do
					local a1, _d_a1 = (ran:Float(0, 360)), (120 * i)
					for _ = 1, 6 do
						last = New(_editor_class["s3_紫二符激光预警"], self.x, self.y, a1)
						--task._Wait(10)
						a1 = a1 + _d_a1
					end
				end
				i = -i
				do
					local a1, _d_a1 = (ran:Float(0, 360)), (77 * i)
					for _ = 1, 40 do
						last = New(_editor_class["s3_紫二符激光预警"], self.x, self.y, a1)
						--task._Wait(3)
						a1 = a1 + _d_a1
					end
				end
				task.Wait(120)
				i = -i
				task.MoveTo(0 * j, 144, 60, MOVE_DECEL)
				j = -j
				task._Wait(40)
			end
		end
	end)
end
local function card2_del_Reimu_ENHL(self)
	Spell_break_eff(self.x, self.y, 255, 0, 0,
			'yukari_star', 'reimu_leaf')
end
local function card2_del_Yukari_ENHL(self)
	Spell_break_eff(self.x, self.y, 255, 0, 255,
			'yukari_star', 'reimu_leaf')
end
local card2_init = create_diff_function(
		{ card2_init_Reimu_E, card2_init_Reimu_N, card2_init_Reimu_H, card2_init_Reimu_L },
		{ card2_init_Yukari_E, card2_init_Yukari_N, card2_init_Yukari_H, card2_init_Yukari_L },
		true,
		{
			{"道法「顶针穿一」", "境符「包络式妖瞳」"},
			{"道法「顶针穿一」", "境符「包络式妖瞳」"},
			{"梵法「天眼拘禁式」", "空饵「德布罗意浮游炮」"},
			{"梵法「天眼拘禁式」", "空饵「德布罗意浮游炮」"},
		})
local card2_del = create_diff_function(
		{ card2_del_Reimu_ENHL, card2_del_Reimu_ENHL, card2_del_Reimu_ENHL, card2_del_Reimu_ENHL },
		{ card2_del_Yukari_ENHL, card2_del_Yukari_ENHL, card2_del_Yukari_ENHL, card2_del_Yukari_ENHL },
		false)
--endregion

--region normal 3
local function normal3_init_Reimu_E(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 144, 60, MOVE_DECEL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 48)
		task._Wait(30)
		local u, dx, dy = 1
		do
			for _ = 1, _infinite do
				do
					local a, _d_a = (90 - 90 * u), (-36 * u)
					local dt, _d_dt = (72), (-12)
					for _ = 1, 6 do
						PlaySound("tan00", 0.1, 0, false)
						dx, dy = 30 * cos(a), 30 * sin(a)
						do
							local _sp, _d__sp = (0), (7.5 * u)
							for _ = 1, 3 do
								do
									local v, _d_v = (0.5), (0.75)
									local v2, _d_v2 = (2.5), (-0.25)
									for _ = 1, 2 do
										last = New(_editor_class["s3_B1_no3_1"], self.x + dx, self.y + dy, v, a + _sp, dt, v2, _sp, u)
										v = v + _d_v
										v2 = v2 + _d_v2
									end
								end
								_sp = _sp + _d__sp
							end
						end
						task._Wait(12)
						a = a + _d_a
						dt = dt + _d_dt
					end
				end
				task.MoveToPlayer(30, -96, 96, 144, 169, 16, 32, 8, 16, MOVE_NORMAL, MOVE_X_TOWARDS_PLAYER)
				u = -u
				task._Wait(40)
			end
		end
	end)
end
local function normal3_init_Reimu_N(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 144, 60, MOVE_DECEL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 48)
		task._Wait(30)
		local u, dx, dy = 1
		do
			for _ = 1, _infinite do
				do
					local a, _d_a = (90 - 90 * u), (-36 * u)
					local dt, _d_dt = (72), (-12)
					for _ = 1, 6 do
						PlaySound("tan00", 0.1, 0, false)
						dx, dy = 30 * cos(a), 30 * sin(a)
						do
							local _sp, _d__sp = (0), (7.5 * u)
							for _ = 1, 5 do
								do
									local v, _d_v = (0.5), (0.75)
									local v2, _d_v2 = (2.5), (-0.25)
									for _ = 1, 3 do
										last = New(_editor_class["s3_B1_no3_1"], self.x + dx, self.y + dy, v, a + _sp, dt, v2, _sp, u)
										v = v + _d_v
										v2 = v2 + _d_v2
									end
								end
								_sp = _sp + _d__sp
							end
						end
						task._Wait(12)
						a = a + _d_a
						dt = dt + _d_dt
					end
				end
				task.MoveToPlayer(30, -96, 96, 144, 169, 16, 32, 8, 16, MOVE_NORMAL, MOVE_X_TOWARDS_PLAYER)
				u = -u
				task._Wait(20)
			end
		end
	end)
end
local function normal3_init_Reimu_H(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 144, 60, MOVE_DECEL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 48)
		task._Wait(30)
		local u, dx, dy = 1
		do
			for _ = 1, _infinite do
				do
					local a, _d_a = (90 - 90 * u), (-36 * u)
					local dt, _d_dt = (60), (-10)
					for _ = 1, 6 do
						PlaySound("tan00", 0.1, 0, false)
						dx, dy = 30 * cos(a), 30 * sin(a)
						do
							local _sp, _d__sp = (0), (7.5 * u)
							for _ = 1, 7 do
								do
									local v, _d_v = (0.5), (0.75)
									local v2, _d_v2 = (2.5), (-0.25)
									for _ = 1, 4 do
										last = New(_editor_class["s3_B1_no3_1"], self.x + dx, self.y + dy, v, a + _sp, dt, v2, _sp, u)
										v = v + _d_v
										v2 = v2 + _d_v2
									end
								end
								_sp = _sp + _d__sp
							end
						end
						task._Wait(10)
						a = a + _d_a
						dt = dt + _d_dt
					end
				end
				task.MoveToPlayer(30, -96, 96, 144, 169, 16, 32, 8, 16, MOVE_NORMAL, MOVE_X_TOWARDS_PLAYER)
				u = -u
				task._Wait(10)
			end
		end
	end)
end
local function normal3_init_Reimu_L(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 144, 60, MOVE_DECEL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 48)
		task._Wait(30)
		local u, dx, dy = 1
		do
			for _ = 1, _infinite do
				do
					local a, _d_a = (90 - 45 * u), (-270/5 * u)
					local dt, _d_dt = (48), (-8)
					for _ = 1, 6 do
						PlaySound("tan00", 0.1, 0, false)
						dx, dy = 30 * cos(a), 30 * sin(a)
						do
							local _sp, _d__sp = (0), (7.5 * u)
							for _ = 1, 9 do
								do
									local v, _d_v = (0.5), (0.75)
									local v2, _d_v2 = (2.5), (-0.25)
									for _ = 1, 5 do
										last = New(_editor_class["s3_B1_no3_1"], self.x + dx, self.y + dy, v, a + _sp, dt, v2, _sp, u)
										v = v + _d_v
										v2 = v2 + _d_v2
									end
								end
								_sp = _sp + _d__sp
							end
						end
						task.Wait(8)
						a = a + _d_a
						dt = dt + _d_dt
					end
				end
				task.MoveToPlayer(30, -96, 96, 144, 169, 16, 32, 8, 16, MOVE_NORMAL, MOVE_X_TOWARDS_PLAYER)
				u = -u
				task._Wait(0)
			end
		end
	end)
end
local function normal3_init_Yukari_E(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 104, 60, MOVE_NORMAL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		do
			local dx, dy
			for _ = 1, _infinite do
				do
					local a, _d_a = (Angle(self, player)), (22.5)
					for _ = 1, 16 do
						dx, dy = 30 * cos(a), 30 * sin(a)
						do
							local dv, _d_dv = (0), (1)
							for _ = 1, 1 do
								last = New(_straight, arrow_small, 3, self.x + dx, self.y + dy, 3 + dv, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								AddSimStrChV(last, 0, -dv - 2.5, a, 30)
								AddSimStrChV(last, 0, 5 + dv, a, 240, nil, nil, 60)
								dv = dv + _d_dv
							end
						end
						a = a + _d_a
					end
				end
				task.MoveToPlayer(30, -96, 96, 104, 144, 16, 32, 8, 16, MOVE_NORMAL, MOVE_X_TOWARDS_PLAYER)
				task._Wait(80)
			end
		end
	end)
end
local function normal3_init_Yukari_N(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 104, 60, MOVE_NORMAL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		do
			local dx, dy
			for _ = 1, _infinite do
				do
					local a, _d_a = (Angle(self, player)), (15)
					for _ = 1, 24 do
						dx, dy = 30 * cos(a), 30 * sin(a)
						do
							local dv, _d_dv = (0), (0.5)
							for _ = 1, 2 do
								last = New(_straight, arrow_small, 3, self.x + dx, self.y + dy, 3 + dv, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								AddSimStrChV(last, 0, -dv - 2.5, a, 30)
								AddSimStrChV(last, 0, 1 + dv, a, 240, nil, nil, 60)
								dv = dv + _d_dv
							end
						end
						a = a + _d_a
					end
				end
				task.MoveToPlayer(30, -96, 96, 104, 144, 16, 32, 8, 16, MOVE_NORMAL, MOVE_X_TOWARDS_PLAYER)
				task._Wait(60)
			end
		end
	end)
end
local function normal3_init_Yukari_H(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 104, 60, MOVE_NORMAL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		do
			for _ = 1, _infinite do
				do
					local a, _d_a = (Angle(self, player)), (12)
					local dx, dy
					for _ = 1, 30 do
						dx, dy = 30 * cos(a), 30 * sin(a)
						do
							local dv, _d_dv = (0), (0.5)
							for _ = 1, 3 do
								last = New(_straight, arrow_small, 3, self.x + dx, self.y + dy, 3 + dv, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								AddSimStrChV(last, 0, -dv - 2.5, a, 30)
								AddSimStrChV(last, 0, 1 + dv, a, 240, nil, nil, 60)
								dv = dv + _d_dv
							end
						end
						a = a + _d_a
					end
				end
				task.MoveToPlayer(30, -96, 96, 104, 144, 16, 32, 8, 16, MOVE_NORMAL, MOVE_X_TOWARDS_PLAYER)
				task._Wait(40)
			end
		end
	end)
end
local function normal3_init_Yukari_L(self)
	lasttask = task.New(self, function()
		task.MoveTo(0, 104, 60, MOVE_NORMAL)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		do
			for _ = 1, _infinite do
				do
					local a, _d_a = (Angle(self, player)), (8)
					local dx, dy
					for _ = 1, 45 do
						dx, dy = 30 * cos(a), 30 * sin(a)
						do
							local dv, _d_dv = (0), (0.5)
							for _ = 1, 4 do
								last = New(_straight, arrow_small, 3, self.x + dx, self.y + dy, 3 + dv, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								egg.AddSimStrChV(last, 0, -dv - 2.5, a, 30)
								egg.AddSimStrChV(last, 0, 1 + dv, a, 120, 60)
								dv = dv + _d_dv
							end
						end
						a = a + _d_a
					end
				end
				task.MoveToPlayer(30, -96, 96, 104, 144, 16, 32, 8, 16, MOVE_NORMAL, MOVE_X_TOWARDS_PLAYER)
				task._Wait(60)
			end
		end
	end)
end
local function normal3_del_Reimu_ENHL(self)
	self.vx = 0
	self.vy = 0
end
local function normal3_del_Yukari_ENHL(self)
	self.vscale = 1
	self.hscale = 1
end
local normal3_init = create_diff_function(
		{ normal3_init_Reimu_E, normal3_init_Reimu_N, normal3_init_Reimu_H, normal3_init_Reimu_L },
		{ normal3_init_Yukari_E, normal3_init_Yukari_N, normal3_init_Yukari_H, normal3_init_Yukari_L },
		true)
local normal3_del = create_diff_function(
		{ normal3_del_Reimu_ENHL, normal3_del_Reimu_ENHL, normal3_del_Reimu_ENHL, normal3_del_Reimu_ENHL },
		{ normal3_del_Yukari_ENHL, normal3_del_Yukari_ENHL, normal3_del_Yukari_ENHL, normal3_del_Yukari_ENHL },
		false)
--endregion

--region card 3
local function card3_init_Reimu_E(self)
	lasttask = task.New(self, function()
		task.MoveTo(90, 124, 45, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			s3B_boss.pic_show3()
			task._Wait(120)
		end
		task._Wait(90)
		local i = 1
		do
			for _ = 1, _infinite do
				local j = i
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
					task._Wait(60)
				end
				task._Wait(20)
				self._wisys:setAction("cast", 48)
				task._Wait(30)
				lasttask = task.New(self, function()
					do
						local a, _d_a = (Angle(self, player)), (7 * i)
						local r, _d_r = (40), (65)
						local n, _d_n = (1), (2)
						local da, _d_da = (165), (-145 / 11)
						for _ = 1, 5 do
							do
								local b, _d_b = (0), (90)
								for _ = 1, 4 do
									last = New(_editor_class["s3_灵梦三符大弹幕激光"], self.x, self.y, a + b, r, j, n, j, 9 + 7 * j, self.x, self.y, da)
									_connect(self, last, 0, true)
									task._Wait(0)
									b = b + _d_b
								end
							end
							PlaySound("boon00", 0.1, self.x / 256, false)
							j = -j
							task._Wait(6)
							a = a + _d_a
							r = r + _d_r
							n = n + _d_n
							da = da + _d_da
						end
					end
				end)
				task._Wait(210)
				task.MoveTo(-90 * i, 124, 60, MOVE_DECEL)
				task._Wait(210)
				i = -i
				task._Wait(0)
			end
		end
	end)
end
local function card3_init_Reimu_N(self)
	lasttask = task.New(self, function()
		task.MoveTo(90, 124, 45, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			s3B_boss.pic_show3()
			task._Wait(120)
		end
		task._Wait(90)
		local i = 1
		do
			for _ = 1, _infinite do
				local j = i
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
					task._Wait(60)
				end
				task._Wait(20)
				self._wisys:setAction("cast", 48)
				task._Wait(30)
				lasttask = task.New(self, function()
					do
						local a, _d_a = (Angle(self, player)), (7 * i)
						local r, _d_r = (40), (55)
						local n, _d_n = (4), (2)
						local da, _d_da = (165), (-145 / 11)
						for _ = 1, 7 do
							do
								local b, _d_b = (0), (90)
								for _ = 1, 4 do
									last = New(_editor_class["s3_灵梦三符大弹幕激光"], self.x, self.y, a + b, r, j, n, j, 9 + 7 * j, self.x, self.y, da)
									_connect(self, last, 0, true)
									task._Wait(0)
									b = b + _d_b
								end
							end
							PlaySound("boon00", 0.1, self.x / 256, false)
							j = -j
							task._Wait(6)
							a = a + _d_a
							r = r + _d_r
							n = n + _d_n
							da = da + _d_da
						end
					end
				end)
				task._Wait(180)
				task.MoveTo(-90 * i, 124, 60, MOVE_DECEL)
				task._Wait(180)
				i = -i
				task._Wait(0)
			end
		end
	end)
end
local function card3_init_Reimu_H(self)
	lasttask = task.New(self, function()
		task.MoveTo(90, 124, 45, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			s3B_boss.pic_show3()
			task._Wait(120)
		end
		task._Wait(90)
		local i = 1
		do
			for _ = 1, _infinite do
				local j = i
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
					task._Wait(60)
				end
				task._Wait(20)
				self._wisys:setAction("cast", 48)
				task._Wait(30)
				lasttask = task.New(self, function()
					do
						local a, _d_a = (Angle(self, player)), (7 * i)
						local r, _d_r = (40), (48)
						local n, _d_n = (6), (2)
						local da, _d_da = (165), (-145 / 11)
						for _ = 1, 9 do
							do
								local b, _d_b = (0), (90)
								for _ = 1, 4 do
									last = New(_editor_class["s3_灵梦三符大弹幕激光"], self.x, self.y, a + b, r, j, n, j, 9 + 7 * j, self.x, self.y, da)
									_connect(self, last, 0, true)
									task._Wait(0)
									b = b + _d_b
								end
							end
							PlaySound("boon00", 0.1, self.x / 256, false)
							j = -j
							task._Wait(6)
							a = a + _d_a
							r = r + _d_r
							n = n + _d_n
							da = da + _d_da
						end
					end
				end)
				task._Wait(120)
				task.MoveTo(-90 * i, 124, 60, MOVE_DECEL)
				task._Wait(180)
				i = -i
				task._Wait(0)
			end
		end
	end)
end
local function card3_init_Reimu_L(self)
	lasttask = task.New(self, function()
		task.MoveTo(90, 124, 45, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			s3B_boss.pic_show3()
			task._Wait(120)
		end
		task._Wait(90)
		local i = 1
		do
			for _ = 1, _infinite do
				local j = i
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
					task._Wait(60)
				end
				task._Wait(20)
				self._wisys:setAction("cast", 48)
				task._Wait(30)
				lasttask = task.New(self, function()
					do
						local a, _d_a = (Angle(self, player)), (7 * i)
						local r, _d_r = (40), (42)
						local n, _d_n = (8), (2)
						local da, _d_da = (165), (-145 / 11)
						for _ = 1, 11 do
							do
								local b, _d_b = (0), (90)
								for _ = 1, 4 do
									last = New(_editor_class["s3_灵梦三符大弹幕激光"], self.x, self.y, a + b, r, j, n, j, 9 + 7 * j, self.x, self.y, da)
									_connect(self, last, 0, true)
									task._Wait(0)
									b = b + _d_b
								end
							end
							PlaySound("boon00", 0.1, self.x / 256, false)
							j = -j
							task._Wait(6)
							a = a + _d_a
							r = r + _d_r
							n = n + _d_n
							da = da + _d_da
						end
					end
				end)
				task._Wait(60)
				task.MoveTo(-90 * i, 124, 60, MOVE_DECEL)
				task._Wait(180)
				i = -i
				task._Wait(0)
			end
		end
	end)
end
local function card3_init_Yukari_E(self)
	lasttask = task.New(self, function()
		task.MoveTo(-90, 124, 45, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
		end
		local i = 1
		do
			for _ = 1, _infinite do
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
						task._Wait(60)
					end
				end)
				task._Wait(60)
				task.MoveTo(-90*i, 124, 60, MOVE_DECEL)
				do
					local aerfa, _d_aerfa = (ran:Float(-5, 5)), (-180 / 12)
					for _ = 1, 12 do
						last = New(_editor_class["s3_紫三符激光预警"], 150 * cos(aerfa), 260 + 10 * sin(aerfa), aerfa)
						task._Wait(0)
						aerfa = aerfa + _d_aerfa
					end
				end
				task.MoveToPlayer(60, -120, 120, 112, 124, 16, 32, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
				lasttask = task.New(self, function()
					do
						local a, _d_a = (90 - 15 * i * 6), (13.3 * i * 6)
						for _ = 1, 10 do
							do
								local b, _d_b = (0), (180)
								for _ = 1, 2 do
									last = New(_editor_class["s3_紫三符激光预警"], self.x + 48 * cos(a), self.y + 48 * sin(a), a + 60 * i + b)
									task._Wait(0)
									b = b + _d_b
								end
							end
							task._Wait(6)
							a = a + _d_a
						end
					end
				end)
				task.BezierMoveTo(60, MOVE_ACC_DEC, -100 * i, 0)
				task._Wait(150)
				lasttask = task.New(self, function()
					do
						local a, _d_a = (155 - 15 * i * 6), (13.3 * i * 6)
						for _ = 1, 10 do
							do
								local b, _d_b = (0), (180)
								for _ = 1, 2 do
									last = New(_editor_class["s3_紫三符激光预警"], self.x + 48 * cos(a), self.y + 48 * sin(a), a + 60 * i + b)
									task._Wait(0)
									b = b + _d_b
								end
							end
							task._Wait(6)
							a = a + _d_a
						end
					end
				end)
				task.BezierMoveTo(60, MOVE_ACC_DEC, 100 * i, 84)
				task._Wait(150)
				i = -i
				task._Wait(1)
			end
		end
	end)
end
local function card3_init_Yukari_N(self)
	lasttask = task.New(self, function()
		task.MoveTo(-90, 124, 45, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
		end
		local i = 1
		do
			for _ = 1, _infinite do
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
						task._Wait(60)
					end
				end)
				task._Wait(60)
				task.MoveTo(-90*i, 124, 60, MOVE_DECEL)
				do
					local aerfa, _d_aerfa = (ran:Float(-5, 5)), (-180 / 25)
					for _ = 1, 25 do
						last = New(_editor_class["s3_紫三符激光预警"], 150 * cos(aerfa), 260 + 10 * sin(aerfa), aerfa)
						task._Wait(0)
						aerfa = aerfa + _d_aerfa
					end
				end
				task.MoveToPlayer(60, -120, 120, 112, 124, 16, 32, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
				lasttask = task.New(self, function()
					do
						local a, _d_a = (90 - 15 * i * 4), (13.3 * i * 4)
						for _ = 1, 15 do
							do
								local b, _d_b = (0), (180)
								for _ = 1, 2 do
									last = New(_editor_class["s3_紫三符激光预警"], self.x + 48 * cos(a), self.y + 48 * sin(a), a + 60 * i + b)
									task._Wait(0)
									b = b + _d_b
								end
							end
							task._Wait(4)
							a = a + _d_a
						end
					end
				end)
				task.BezierMoveTo(60, MOVE_ACC_DEC, -100 * i, 0)
				task._Wait(120)
				lasttask = task.New(self, function()
					do
						local a, _d_a = (155 - 15 * i * 4), (13.3 * i * 4)
						for _ = 1, 15 do
							do
								local b, _d_b = (0), (180)
								for _ = 1, 2 do
									last = New(_editor_class["s3_紫三符激光预警"], self.x + 48 * cos(a), self.y + 48 * sin(a), a + 60 * i + b)
									task._Wait(0)
									b = b + _d_b
								end
							end
							task._Wait(4)
							a = a + _d_a
						end
					end
				end)
				task.BezierMoveTo(60, MOVE_ACC_DEC, 100 * i, 84)
				task._Wait(120)
				i = -i
				task._Wait(1)
			end
		end
	end)
end
local function card3_init_Yukari_H(self)
	lasttask = task.New(self, function()
		task.MoveTo(-90, 124, 45, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
		end
		local i = 1
		do
			for _ = 1, _infinite do
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
						task._Wait(60)
					end
				end)
				task._Wait(60)
				task.MoveTo(-90*i, 124, 60, MOVE_DECEL)
				boss.cast(self, 0)
				do
					local aerfa, _d_aerfa = (ran:Float(-5, 5)), (-180 / 25)
					for _ = 1, 25 do
						last = New(_editor_class["s3_紫三符激光预警"], 150 * cos(aerfa), 260 + 10 * sin(aerfa), aerfa)
						task._Wait(0)
						aerfa = aerfa + _d_aerfa
					end
				end
				task.MoveToPlayer(60, -120, 120, 112, 124, 16, 32, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
				boss.cast(self, 0)
				lasttask = task.New(self, function()
					do
						local a, _d_a = (90 - 15 * i * 3), (13.3 * i * 3)
						for _ = 1, 20 do
							do
								local b, _d_b = (0), (180)
								for _ = 1, 2 do
									last = New(_editor_class["s3_紫三符激光预警"], self.x + 48 * cos(a), self.y + 48 * sin(a), a + 60 * i + b)
									task._Wait(0)
									b = b + _d_b
								end
							end
							task._Wait(3)
							a = a + _d_a
						end
					end
				end)
				task.BezierMoveTo(60, MOVE_ACC_DEC, -100 * i, 0)
				task._Wait(90)
				lasttask = task.New(self, function()
					do
						local a, _d_a = (155 - 15 * i * 3), (13.3 * i * 3)
						for _ = 1, 20 do
							do
								local b, _d_b = (0), (180)
								for _ = 1, 2 do
									last = New(_editor_class["s3_紫三符激光预警"], self.x + 48 * cos(a), self.y + 48 * sin(a), a + 60 * i + b)
									task._Wait(0)
									b = b + _d_b
								end
							end
							task._Wait(3)
							a = a + _d_a
						end
					end
				end)
				task.BezierMoveTo(60, MOVE_ACC_DEC, 100 * i, 84)
				task._Wait(90)
				i = -i
				task._Wait(1)
			end
		end
	end)
end
local function card3_init_Yukari_L(self)
	lasttask = task.New(self, function()
		task.MoveTo(-90, 124, 45, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
		end
		local i = 1
		do
			for _ = 1, _infinite do
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
						task._Wait(60)
					end
				end)
				task._Wait(60)
				task.MoveTo(-90*i, 124, 60, MOVE_DECEL)
				boss.cast(self, 0)
				do
					local aerfa, _d_aerfa = (ran:Float(-5, 5)), (-180 / 35)
					for _ = 1, 35 do
						last = New(_editor_class["s3_紫三符激光预警"], 150 * cos(aerfa), 260 + 10 * sin(aerfa), aerfa)
						aerfa = aerfa + _d_aerfa
					end
				end
				task.MoveToPlayer(60, -120, 120, 112, 124, 16, 32, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
				boss.cast(self, 0)
				lasttask = task.New(self, function()
					do
						local a, _d_a = (90 - 15 * i * 2), (13.3 * i * 2)
						for _ = 1, 30 do
							do
								local b, _d_b = (0), (180)
								for _ = 1, 2 do
									last = New(_editor_class["s3_紫三符激光预警"], self.x + 48 * cos(a), self.y + 48 * sin(a), a + 60 * i + b)
									task._Wait(0)
									b = b + _d_b
								end
							end
							task._Wait(2)
							a = a + _d_a
						end
					end
				end)
				task.BezierMoveTo(60, MOVE_ACC_DEC, -100 * i, 0)
				task._Wait(60)
				lasttask = task.New(self, function()
					do
						local a, _d_a = (155 - 15 * i * 2), (13.3 * i * 2)
						for _ = 1, 30 do
							do
								local b, _d_b = (0), (180)
								for _ = 1, 2 do
									last = New(_editor_class["s3_紫三符激光预警"], self.x + 48 * cos(a), self.y + 48 * sin(a), a + 60 * i + b)
									task._Wait(0)
									b = b + _d_b
								end
							end
							task._Wait(2)
							a = a + _d_a
						end
					end
				end)
				task.BezierMoveTo(60, MOVE_ACC_DEC, 100 * i, 84)
				task._Wait(60)
				i = -i
				task._Wait(1)
			end
		end
	end)
end
local function card3_del_Reimu_ENHL(self)
	Spell_break_eff(self.x, self.y, 255, 0, 0,
			'yukari_star', 'reimu_leaf')
end
local function card3_del_Yukari_ENHL(self)
	Spell_break_eff(self.x, self.y, 255, 0, 255,
			'yukari_star', 'reimu_leaf')
end
local card3_init = create_diff_function(
		{ card3_init_Reimu_E, card3_init_Reimu_N, card3_init_Reimu_H, card3_init_Reimu_L },
		{ card3_init_Yukari_E, card3_init_Yukari_N, card3_init_Yukari_H, card3_init_Yukari_L },
		true,
		{
			{"「神域 镇护结界」", "「Purple Breaker」"},
			{"「神域 镇护结界」", "「Purple Breaker」"},
			{"「神域 霸压结界」", "「八云缚锁 夜魔光」"},
			{"「神域 霸压结界」", "「八云缚锁 夜魔光」"},
		})
local card3_del = create_diff_function(
		{ card3_del_Reimu_ENHL, card3_del_Reimu_ENHL, card3_del_Reimu_ENHL, card3_del_Reimu_ENHL },
		{ card3_del_Yukari_ENHL, card3_del_Yukari_ENHL, card3_del_Yukari_ENHL, card3_del_Yukari_ENHL },
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
		master.reimu = stg.newSimpleBoss(-240, 384, 1145141919, function(self)
			self._private_type_boss = true
			self.master_boss = master
			lstg.wis.Reimu(self)
			self.group = GROUP_ENEMY
			self.a = 32
			self.b = 32
			common_callback(self, 1)
		end)
		master.yukari = stg.newSimpleBoss(240, 384, 1145141919, function(self)
			self._private_type_boss = true
			self.master_boss = master
			lstg.wis.Yukari(self)
			self.group = GROUP_ENEMY
			self.a = 32
			self.b = 32
			common_callback(self, 2)
		end)
		master.slave_boss = {master.reimu, master.yukari}
	end
	-- boss class
	local cls = EISlib.stage.createBossClass(group_name, class_name, name, s3B_boss.scbg,
			{ "s3_boss1", stage3_background }, 0, 21474836487, function() end)
	-- 对 init 进行改造，确保假 boss 先创建，然后再 boss.init，不然的话它这个沙雕玩意一开始就执行符卡，这时候假 boss 还没创建
	local old_init = cls.init
	function cls:init(...)
		create_fake_boss(self)
		old_init(self, ...)
		self.colli = false
		self.ui_names = { "Reimu", "Yukari" } -- boss ui
		self.ui_pointers = { 0, 0 } -- boss ui
	end
	-- 死亡动画
	function cls:spExplode()
		Del(self)
		deadtask(self.reimu)
		deadtask(self.yukari)
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

--灵梦的蓄力特效
local function eff1(x, y, t)
	New(AbEff, x, y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
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
--紫的蓄力特效
local function eff2(x, y, t)
	New(AbEff, x, y, 'yukari_star', 'reimu_leaf', 255, 0, 255)
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
			task.New(self.yukari, function()
				task.MoveTo(-60, 124, 90, MOVE_DECEL)
			end)
			task.Wait(90)
			task.New(self.reimu, function()
				task.MoveTo(60, 124, 90, MOVE_DECEL)
			end)
			task.Wait(90)
			if EISlib.stage.canDialog() then
				-- 对话
				dialog.cacheResource("Stage3")
				dialog.player.playScene("Stage3")
				dialog.player.waitSignal("fade out BGM", dialog.enum.on)
				EISlib.stage.musicFadeOut("s3", 120)
				dialog.player.waitSignal("play BGM", dialog.enum.on)
				LoadMusicRecord("s3_boss1")
				EISlib.stage.playMusic("s3_boss1", 0, true)
				dialog.player.waitUntilFinish()
			else
				EISlib.stage.musicFadeOut("s3", 120)
				LoadMusicRecord("s3_boss1")
				EISlib.stage.playMusic("s3_boss1", 0, true)
			end
			-- 开始攻击！
			stg.setBossMagicCircle(self.reimu, true)
			stg.setBossMagicCircle(self.yukari, true)
			stg.setBossWarp(self.reimu, true)
			stg.setBossWarp(self.yukari, true)
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
			task.New(self.reimu, function(unit)
				boss_scpr_show1(unit, 60, 124)
				stg.setBossMagicCircle(unit, true)
				stg.setBossWarp(unit, true)
			end)
			task.New(self.yukari, function(unit)
				boss_scpr_show2(unit, -60, 124)
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

--region reimu pass

local bossE = create_double("Easy", "s3bossBdouble1:Easy", "Reimu")
local bossN = create_double("Normal", "s3bossBdouble1:Normal", "Reimu")
local bossH = create_double("Hard", "s3bossBdouble1:Hard", "Reimu")
local bossL = create_double("Lunatic", "s3bossBdouble1:Lunatic", "Reimu")

common_action1({ bossE, bossN, bossH, bossL })
common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, "通常攻击1",
		{ 2, 5, 50 }, 1500, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)
create_card(bossN, "通常攻击1",
		{ 2, 5, 50 }, 1500, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)
create_card(bossH, "通常攻击1",
		{ 2, 5, 50 }, 1500, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)
create_card(bossL, "通常攻击1",
		{ 2, 5, 50 }, 1500, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, "御札「退魔符乱舞」",
		{ 2, 10, 60 }, 3750, {10, 20, 30}, "spellcard", true, card1_init, card1_del)
create_card(bossN, "御札「退魔符乱舞」",
		{ 2, 10, 60 }, 3750, {10, 20, 30}, "spellcard", true, card1_init, card1_del)
create_card(bossH, "神灵「梦想封印 瞾」",
		{ 2, 10, 60 }, 3750, {10, 20, 30}, "spellcard", true, card1_init, card1_del)
create_card(bossL, "神灵「梦想封印 瞾」",
		{ 2, 10, 60 }, 3750, {10, 20, 30}, "spellcard", true, card1_init, card1_del)

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

create_card(bossE, "道法「顶针穿一」",
		{ 3, 10, 60 }, 3000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)
create_card(bossN, "道法「顶针穿一」",
		{ 3, 10, 60 }, 3000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)
create_card(bossH, "梵法「天眼拘禁式」",
		{ 3, 10, 60 }, 3000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)
create_card(bossL, "梵法「天眼拘禁式」",
		{ 3, 10, 60 }, 3000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, "通常攻击3",
		{ 2, 5, 55 }, 3500, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)
create_card(bossN, "通常攻击3",
		{ 2, 5, 55 }, 3500, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)
create_card(bossH, "通常攻击3",
		{ 2, 5, 55 }, 3500, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)
create_card(bossL, "通常攻击3",
		{ 2, 5, 55 }, 3500, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, "「神域 镇护结界」",
		{ 3, 9, 50 }, 2500, {10, 20, 30}, "spellcard", true, card3_init, card3_del)
create_card(bossN, "「神域 镇护结界」",
		{ 3, 9, 50 }, 2500, {10, 20, 30}, "spellcard", true, card3_init, card3_del)
create_card(bossH, "「神域 霸压结界」",
		{ 3, 9, 50 }, 2500, {10, 20, 30}, "spellcard", true, card3_init, card3_del)
create_card(bossL, "「神域 霸压结界」",
		{ 3, 9, 50 }, 2500, {10, 20, 30}, "spellcard", true, card3_init, card3_del)

function s3B_boss.main(diff)
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

--region yukari pass

bossE = create_double("Easy", "s3bossBdouble2:Easy", "Yukari")
bossN = create_double("Normal", "s3bossBdouble2:Normal", "Yukari")
bossH = create_double("Hard", "s3bossBdouble2:Hard", "Yukari")
bossL = create_double("Lunatic", "s3bossBdouble2:Lunatic", "Yukari")

common_action1({ bossE, bossN, bossH, bossL })
common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, "通常攻击1",
		{ 2, 5, 50 }, 1500, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)
create_card(bossN, "通常攻击1",
		{ 2, 5, 50 }, 1500, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)
create_card(bossH, "通常攻击1",
		{ 2, 5, 50 }, 1500, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)
create_card(bossL, "通常攻击1",
		{ 2, 5, 50 }, 1500, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, "结界「人间至处的青山」",
		{ 2, 10, 60 }, 3750, {10, 20, 30}, "spellcard", true, card1_init, card1_del)
create_card(bossN, "结界「人间至处的青山」",
		{ 2, 10, 60 }, 3750, {10, 20, 30}, "spellcard", true, card1_init, card1_del)
create_card(bossH, "结界「人间极乐的青山」",
		{ 2, 10, 60 }, 3750, {10, 20, 30}, "spellcard", true, card1_init, card1_del)
create_card(bossL, "结界「人间极乐的青山」",
		{ 2, 10, 60 }, 3750, {10, 20, 30}, "spellcard", true, card1_init, card1_del)

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

create_card(bossE, "境符「包络式妖瞳」",
		{ 3, 10, 60 }, 3000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)
create_card(bossN, "境符「包络式妖瞳」",
		{ 3, 10, 60 }, 3000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)
create_card(bossH, "空饵「德布罗意浮游炮」",
		{ 3, 10, 60 }, 3000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)
create_card(bossL, "空饵「德布罗意浮游炮」",
		{ 3, 10, 60 }, 3000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, "通常攻击3",
		{ 2, 5, 55 }, 3000, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)
create_card(bossN, "通常攻击3",
		{ 2, 5, 55 }, 3000, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)
create_card(bossH, "通常攻击3",
		{ 2, 5, 55 }, 3000, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)
create_card(bossL, "通常攻击3",
		{ 2, 5, 55 }, 3000, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, "「Purple Breaker」",
		{ 3, 9, 50 }, 2500, {10, 20, 30}, "spellcard", true, card3_init, card3_del)
create_card(bossN, "「Purple Breaker」",
		{ 3, 9, 50 }, 2500, {10, 20, 30}, "spellcard", true, card3_init, card3_del)
create_card(bossH, "「八云缚锁 夜魔光」",
		{ 3, 9, 50 }, 2500, {10, 20, 30}, "spellcard", true, card3_init, card3_del)
create_card(bossL, "「八云缚锁 夜魔光」",
		{ 3, 9, 50 }, 2500, {10, 20, 30}, "spellcard", true, card3_init, card3_del)

--endregion
