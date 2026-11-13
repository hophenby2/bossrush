
--子弹定义
--region
_editor_class["stage_3_midboss_marisa_NoSpell1_circle"] = Class(_object)
_editor_class["stage_3_midboss_marisa_NoSpell1_circle"].init = function(self, _x, _y, dimode, i, sa, red, green, blue, bcl, la, sway)
	self.x, self.y = _x, _y
	self.img = "image:seasons_effectcircle1"
	self.layer = LAYER_ENEMY_BULLET - 1
	self.group = GROUP_INDES
	self.hide = false
	self.bound = false
	self.navi = false
	self.hp = 10
	self.maxhp = 10
	self.colli = false
	self._servants = {}
	self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
	local dsa, rr, bdr, tim, way1, lway = { 240, 360, 540, 720 }, { 90, 120, 150, 180 }, { 0, 0.25, 0.5, 0.75 }, { 15, 20, 24, 30 }, { 1, 2, 3, 4 }, { 3, 3, 4, 5 }
	self.rot, self.omiga = sa - dsa[dimode] * i, -8 * i
	self.hscale, self.vscale = 0, 0
	_object.set_color(self, "mul+add", 255, red, green, blue)
	self.rr, self.san = 0, sa - dsa[dimode] * i
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("rr", rr[dimode], 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("hscale", 0.4, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("vscale", 0.4, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 60 do
				_set_rel_pos(self, self.rr * cos(self.san), self.rr * sin(self.san), self.rot, false)
				task._Wait(1)
			end
		end
		lasttask = task.New(self, function()
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("rr", 0, 120, MOVE_ACCEL, nil, 0, MODE_SET)
			end)
		end)
		lasttask = task.New(self, function()
			local ia = i
			do
				for _ = 1, tim[dimode] do
					PlaySound("tan00", 0.1, 0, false)
					do
						local v, _d_v = (2), (bdr[dimode] / (way1[dimode] - 1))
						for _ = 1, way1[dimode] do
							last = New(_straight, star_small, bcl, self.x, self.y, v, self.san, false, 4 * ia, true, true, 0, false, 0, 0, 0, false)
							_object.set_color(last, "", 255, 255, 255, 255)
							last.layer = -201
							v = v + _d_v
						end
					end
					ia = -ia
					task._Wait(120 / tim[dimode])
				end
			end
		end)
		do
			for _ = 1, 120 do
				_set_rel_pos(self, self.rr * cos(self.san), self.rr * sin(self.san), self.rot, false)
				task._Wait(1)
			end
		end
		_set_rel_pos(self, 0, 0, self.rot, false)
		PlaySound("enep00", 0.1, 0, false)
		local lway1, sp, slv = 1, 0, 3
		do
			for _ = 1, lway[dimode] do
				do
					local bla, _d_bla = (Angle(self, player) + la - sp / 2 * i), (sp * i / (lway1 - 1))
					for _ = 1, lway1 do
						last = New(_straight, star_big, bcl, self.x, self.y, slv * 2, bla, false, 4 * i, true, true, 0, false, 0, 0, 0, false)
						lasttask = task.New(last, function()
							ex.SmoothSetValueTo("_speed", 1 / 2, 30, MOVE_DECEL, nil, 0, MODE_MUL)
						end)
						bla = bla + _d_bla
					end
				end
				lway1, sp, slv = lway1 + 1, sp + (360 / sway - 360 / (sway * lway[dimode])) / (lway[dimode] - 1), slv - 1.5 / (lway[dimode] - 1)
			end
		end
		_del(self, true)
	end)
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("san", sa, 180, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 180 do
				last = New(_editor_class["stage3_boss_marisa_circle_smear"], self.x, self.y, i, self.rot, self.hscale, red, green, blue)
				task._Wait(1)
			end
		end
		self.san = sa
	end)
end
_editor_class["stage_3_midboss_yuyuko_Spell1_bullet1"] = Class(bullet)
_editor_class["stage_3_midboss_yuyuko_Spell1_bullet1"].init = function(self, _x, _y, i, bcl, sv, sa, dsa, ldv, lda)
	bullet.init(self, butterfly, bcl, true, true)
	_object.set_color(self, "", 255, 255, 255, 255)
	self.x, self.y = _x, _y
	self.rot = sa
	self.la = sa
	lasttask = task.New(self, function()
		do
			local v, _d_v = (sv), (-sv / 119)
			local si, _d_si = (0), (90 / 119)
			for _ = 1, 120 do
				SetV2(self, v, sa + dsa * sin(si) * i, true, false)
				self.la = sa + dsa * sin(si) * i
				task._Wait(1)
				v = v + _d_v
				si = si + _d_si
			end
		end
		local la = self.la
		PlaySound("kira00", 0.1, 0, false)
		self.colli = false
		self.hscale, self.vscale = 2, 2
		self.rot = la + lda * i
		_object.set_color(self, "", 0, 255, 255, 255)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("hscale", -1, 15, MOVE_DECEL, nil, 0, MODE_ADD)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("vscale", -1, 15, MOVE_DECEL, nil, 0, MODE_ADD)
		end)
		do
			local si, _d_si = (0), (90 / 14)
			for _ = 1, 15 do
				_object.set_color(self, "", 255 * sin(si), 255, 255, 255)
				task._Wait(1)
				si = si + _d_si
			end
			_object.set_color(self, "", 255, 255, 255, 255)
			self.double_render = true
		end
		self.colli = true
		do
			local v, _d_v = (0), ((sv + ldv) / 59)
			for _ = 1, 60 do
				SetV2(self, v, la + lda * i, true, false)
				task._Wait(1)
				v = v + _d_v
			end
		end
	end)
end
--[[_editor_class["stage_3_midboss_yuyuko_Spell1_bullet1"].render = function(self)
	SetImageState(self.img, "", Color(self._a, 255, 255, 255))
	Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
	--_object.render(self)
	if self.double_render then --通过双倍渲染的方式来让蝶弹更清晰
		Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
	end
end]]
--endregion

--魔理沙的蓄力特效
local function eff1(x, y, t)
	New(AbEff, x, y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
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
	boss.show_aura(self, true)
end
--幽幽子的蓄力特效
local function eff2(x, y, t)
	New(AbEff, x, y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
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
	boss.show_aura(self, true)
end

--normal
local function normal1_init_E(self)
	local i = 1
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 255, 255, 255, 32, 32, 32, 255, 255 }, { 32, 160, 255, 255, 255, 32, 32, 255 }, { 32, 32, 32, 32, 255, 255, 255, 255 }, { 1, 13, 11, 9, 7, 5, 3, 15 }
	lasttask = task.New(self, function()
		task._Wait(30)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 56)
		task._Wait(30)
		local ia = i
		do
			for _ = 1, 6 do
				PlaySound("option", 0.1, 0, false)
				do
					local sa, _d_sa = (Angle(self, player)), (360 / 6 * ia)
					local n, _d_n = (1), (1)
					local la, _d_la = (0), (360 / 6 * i)
					for _ = 1, 6 do
						last = New(_editor_class["stage_3_midboss_marisa_NoSpell1_circle"], self.x, self.y, 1, ia, sa, circle_redarray[n], circle_greenarray[n], circle_bluearray[n], circle_bullet_clarray[n], la, 6)
						_connect(self, last, 0, true)
						sa = sa + _d_sa
						n = n + _d_n
						la = la + _d_la
					end
				end
				task._Wait(120)
				task.MoveToPlayer(60, -96, 96, 100, 124, 16, 64, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
				ia = -ia
			end
		end
	end)
end
local function normal1_init_N(self)
	local i = 1
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 255, 255, 255, 32, 32, 32, 255, 255 }, { 32, 160, 255, 255, 255, 32, 32, 255 }, { 32, 32, 32, 32, 255, 255, 255, 255 }, { 1, 13, 11, 9, 7, 5, 3, 15 }
	lasttask = task.New(self, function()
		task._Wait(30)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 56)
		task._Wait(30)
		local ia = i
		do
			local rla, _d_rla = (0), (-360 / 7)
			for _ = 1, 7 do
				PlaySound("option", 0.1, 0, false)
				do
					local sa, _d_sa = (Angle(self, player) + rla * ia), (360 / 7 * ia)
					local n, _d_n = (1), (1)
					local la, _d_la = (rla * i), (360 / 7 * i)
					for _ = 1, 7 do
						last = New(_editor_class["stage_3_midboss_marisa_NoSpell1_circle"], self.x, self.y, 2, ia, sa, circle_redarray[n], circle_greenarray[n], circle_bluearray[n], circle_bullet_clarray[n], la, 7)
						_connect(self, last, 0, true)
						sa = sa + _d_sa
						n = n + _d_n
						la = la + _d_la
					end
				end
				task._Wait(100)
				task.MoveToPlayer(60, -96, 96, 100, 124, 16, 64, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
				ia = -ia
				rla = rla + _d_rla
			end
		end
	end)
end
local function normal1_init_H(self)
	local i = 1
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 255, 255, 255, 32, 32, 32, 255, 255 }, { 32, 160, 255, 255, 255, 32, 32, 255 }, { 32, 32, 32, 32, 255, 255, 255, 255 }, { 1, 13, 11, 9, 7, 5, 3, 15 }
	lasttask = task.New(self, function()
		task._Wait(30)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 56)
		task._Wait(30)
		local ia = i
		do
			local rla, _d_rla = (0), (-360 / 7)
			for _ = 1, 7 do
				PlaySound("option", 0.1, 0, false)
				do
					local sa, _d_sa = (Angle(self, player) + rla * ia), (360 / 7 * ia)
					local n, _d_n = (1), (1)
					local la, _d_la = (rla * i), (360 / 7 * i)
					for _ = 1, 7 do
						last = New(_editor_class["stage_3_midboss_marisa_NoSpell1_circle"], self.x, self.y, 3, ia, sa, circle_redarray[n], circle_greenarray[n], circle_bluearray[n], circle_bullet_clarray[n], la, 7)
						_connect(self, last, 0, true)
						sa = sa + _d_sa
						n = n + _d_n
						la = la + _d_la
					end
				end
				task._Wait(100)
				task.MoveToPlayer(60, -96, 96, 100, 124, 16, 64, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
				ia = -ia
				rla = rla + _d_rla
			end
		end
	end)
end
local function normal1_init_L(self)
	local i = 1
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 255, 255, 255, 32, 32, 32, 255, 255 }, { 32, 160, 255, 255, 255, 32, 32, 255 }, { 32, 32, 32, 32, 255, 255, 255, 255 }, { 1, 13, 11, 9, 7, 5, 3, 15 }
	lasttask = task.New(self, function()
		task._Wait(30)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 56)
		task._Wait(30)
		local ia = i
		do
			local rla, _d_rla = (0), (-360 / 7)
			for _ = 1, 7 do
				PlaySound("option", 0.1, 0, false)
				do
					local sa, _d_sa = (Angle(self, player) + rla * ia), (360 / 7 * ia)
					local n, _d_n = (1), (1)
					local la, _d_la = (rla * i), (360 / 7 * i)
					for _ = 1, 7 do
						last = New(_editor_class["stage_3_midboss_marisa_NoSpell1_circle"], self.x, self.y, 4, ia, sa, circle_redarray[n], circle_greenarray[n], circle_bluearray[n], circle_bullet_clarray[n], la, 7)
						_connect(self, last, 0, true)
						sa = sa + _d_sa
						n = n + _d_n
						la = la + _d_la
					end
				end
				task._Wait(100)
				task.MoveToPlayer(60, -96, 96, 100, 124, 16, 64, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
				ia = -ia
				rla = rla + _d_rla
			end
		end
	end)
end
local function normal1_del(self)
	if self.timeout == 1 then
		self.noExtendBonus = true
	end
end

--card
local function card1_init_E(self)
	local i = 1
	lasttask = task.New(self, function()
		do
			s3C_boss.pic_show2()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(60)
			end
		end
		local ia = i
		do
			for _ = 1, _infinite do
				do
					self._wisys:setAction("cast", 64)
					task._Wait(64)
				end
				local ia0 = ia
				local sa = 90
				PlaySound("tan00", 0.1, 0, false)
				do
					for _ = 1, 2 do
						do
							local bsa, _d_bsa = (sa), (360 / 12 * ia0)
							for _ = 1, 12 do
								do
									local ldv, _d_ldv = (0), (-1.5 / 4)
									for _ = 1, 2 do
										last = New(_editor_class["stage_3_midboss_yuyuko_Spell1_bullet1"], self.x, self.y, ia0, 5, 3, bsa, 180, ldv, 0)
										ldv = ldv + _d_ldv
									end
								end
								bsa = bsa + _d_bsa
							end
						end
						ia0 = -ia0
					end
				end
				task._Wait(15)
				PlaySound("power02", 1, 0, true)
				task._Wait(105)
				local ia1 = ia
				do
					local dsa, _d_dsa = (60), (240 / 5)
					for _ = 1, 6 do
						PlaySound("tan00", 0.1, 0, false)
						local bcl = 2 + ia1
						do
							local bsa, _d_bsa = (ran:Float(0, 360)), (360 / 12 * ia1)
							for _ = 1, 12 do
								do
									local ldv, _d_ldv = (0), (-2 / 3)
									for _ = 1, 2 do
										last = New(_editor_class["stage_3_midboss_yuyuko_Spell1_bullet1"], self.x, self.y, ia1, bcl, 3, bsa, dsa, ldv, 0)
										ldv = ldv + _d_ldv
									end
								end
								bsa = bsa + _d_bsa
							end
						end
						lasttask = task.New(self, function()
							task.MoveToPlayer(30, -96, 96, 80, 112, 10, 24, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
						end)
						task._Wait(15)
						PlaySound("power02", 1, 0, true)
						task._Wait(25)
						ia1 = -ia1
						dsa = dsa + _d_dsa
					end
				end
				task._Wait(30)
				task.MoveTo(0, 112, 60, MOVE_DECEL)
				task._Wait(30)
				ia = -ia
			end
		end
	end)
end
local function card1_init_N(self)
	local i = 1
	lasttask = task.New(self, function()
		do
			s3C_boss.pic_show2()
			task._Wait(120)
			boss.cast(self, 60)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(60)
			end
		end
		local ia = i
		do
			for _ = 1, _infinite do
				do
					self._wisys:setAction("cast", 64)
					task._Wait(64)
				end
				local ia0 = ia
				local sa = 90
				PlaySound("tan00", 0.1, 0, false)
				do
					for _ = 1, 2 do
						do
							local bsa, _d_bsa = (sa), (360 / 12 * ia0)
							for _ = 1, 12 do
								do
									local ldv, _d_ldv = (0), (-1.5 / 6)
									local lda, _d_lda = (-30), (60 / 6)
									for _ = 1, 7 do
										last = New(_editor_class["stage_3_midboss_yuyuko_Spell1_bullet1"], self.x, self.y, ia0, 5, 3, bsa, 180, ldv, lda)
										ldv = ldv + _d_ldv
										lda = lda + _d_lda
									end
								end
								bsa = bsa + _d_bsa
							end
						end
						ia0 = -ia0
					end
				end
				task._Wait(15)
				PlaySound("power02", 1, 0, true)
				task._Wait(105)
				local ia1 = ia
				do
					local dsa, _d_dsa = (60), (240 / 5)
					for _ = 1, 6 do
						PlaySound("tan00", 0.1, 0, false)
						local bcl = 2 + ia1
						do
							local bsa, _d_bsa = (ran:Float(0, 360)), (360 / 12 * ia1)
							for _ = 1, 12 do
								do
									local ldv, _d_ldv = (0), (-2 / 4)
									local lda, _d_lda = (-60), (60 / 4)
									for _ = 1, 5 do
										last = New(_editor_class["stage_3_midboss_yuyuko_Spell1_bullet1"], self.x, self.y, ia1, bcl, 3, bsa, dsa, ldv, lda)
										ldv = ldv + _d_ldv
										lda = lda + _d_lda
									end
								end
								bsa = bsa + _d_bsa
							end
						end
						lasttask = task.New(self, function()
							task.MoveToPlayer(30, -96, 96, 80, 112, 10, 24, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
						end)
						task._Wait(15)
						PlaySound("power02", 1, 0, true)
						task._Wait(25)
						ia1 = -ia1
						dsa = dsa + _d_dsa
					end
				end
				task._Wait(30)
				task.MoveTo(0, 112, 60, MOVE_DECEL)
				task._Wait(30)
				ia = -ia
			end
		end
	end)
end
local function card1_init_H(self)
	local i = 1
	lasttask = task.New(self, function()
		do
			s3C_boss.pic_show2()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(60)
			end
		end
		local ia = i
		do
			for _ = 1, _infinite do
				do
					self._wisys:setAction("cast", 64)
					task._Wait(64)
				end
				local ia0 = ia
				local sa = 90
				PlaySound("tan00", 0.1, 0, false)
				do
					for _ = 1, 2 do
						do
							local bsa, _d_bsa = (sa), (360 / 12 * ia0)
							for _ = 1, 12 do
								do
									local ldv, _d_ldv = (0), (-1.5 / 6)
									local lda, _d_lda = (-60), (120 / 6)
									for _ = 1, 7 do
										last = New(_editor_class["stage_3_midboss_yuyuko_Spell1_bullet1"], self.x, self.y, ia0, 5, 3, bsa, 180, ldv, lda)
										ldv = ldv + _d_ldv
										lda = lda + _d_lda
									end
								end
								bsa = bsa + _d_bsa
							end
						end
						ia0 = -ia0
					end
				end
				do
					for _ = 1, 2 do
						do
							local bsa, _d_bsa = (sa), (360 / 8 * ia0)
							for _ = 1, 8 do
								do
									local ldv, _d_ldv = (0), (-0.5 / 4)
									local lda, _d_lda = (-45), (90 / 4)
									for _ = 1, 5 do
										last = New(_editor_class["stage_3_midboss_yuyuko_Spell1_bullet1"], self.x, self.y, ia0, 7, 2, bsa, 180, ldv, lda)
										ldv = ldv + _d_ldv
										lda = lda + _d_lda
									end
								end
								bsa = bsa + _d_bsa
							end
						end
						ia0 = -ia0
					end
				end
				task._Wait(15)
				PlaySound("power02", 1, 0, true)
				task._Wait(105)
				local ia1 = ia
				do
					local dsa, _d_dsa = (60), (240 / 7)
					for _ = 1, 8 do
						PlaySound("tan00", 0.1, 0, false)
						local bcl = 2 + ia1
						do
							local bsa, _d_bsa = (ran:Float(0, 360)), (360 / 12 * ia1)
							for _ = 1, 12 do
								do
									local ldv, _d_ldv = (0), (-2 / 4)
									local lda, _d_lda = (-90), (90 / 4)
									for _ = 1, 5 do
										last = New(_editor_class["stage_3_midboss_yuyuko_Spell1_bullet1"], self.x, self.y, ia1, bcl, 3, bsa, dsa, ldv, lda)
										ldv = ldv + _d_ldv
										lda = lda + _d_lda
									end
								end
								bsa = bsa + _d_bsa
							end
						end
						lasttask = task.New(self, function()
							task.MoveToPlayer(30, -96, 96, 80, 112, 10, 24, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
						end)
						task._Wait(15)
						PlaySound("power02", 1, 0, true)
						task._Wait(15)
						ia1 = -ia1
						dsa = dsa + _d_dsa
					end
				end
				task._Wait(30)
				task.MoveTo(0, 112, 60, MOVE_DECEL)
				task._Wait(30)
				ia = -ia
			end
		end
	end)
end
local function card1_init_L(self)
	local i = 1
	lasttask = task.New(self, function()
		do
			s3C_boss.pic_show2()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(60)
			end
		end
		local ia = i
		do
			for _ = 1, _infinite do
				do
					self._wisys:setAction("cast", 64)
					task._Wait(64)
				end
				local ia0 = ia
				local sa = 90
				PlaySound("tan00", 0.1, 0, false)
				do
					for _ = 1, 2 do
						do
							local bsa, _d_bsa = (sa), (360 / 15 * ia0)
							for _ = 1, 15 do
								do
									local ldv, _d_ldv = (0), (-2 / 6)
									local lda, _d_lda = (-60), (120 / 6)
									for _ = 1, 7 do
										last = New(_editor_class["stage_3_midboss_yuyuko_Spell1_bullet1"], self.x, self.y, ia0, 5, 3, bsa, 180, ldv, lda)
										ldv = ldv + _d_ldv
										lda = lda + _d_lda
									end
								end
								bsa = bsa + _d_bsa
							end
						end
						ia0 = -ia0
					end
				end
				do
					for _ = 1, 2 do
						do
							local bsa, _d_bsa = (sa), (360 / 12 * ia0)
							for _ = 1, 12 do
								do
									local ldv, _d_ldv = (0), (-1 / 4)
									local lda, _d_lda = (-45), (90 / 4)
									for _ = 1, 5 do
										last = New(_editor_class["stage_3_midboss_yuyuko_Spell1_bullet1"], self.x, self.y, ia0, 7, 2, bsa, 180, ldv, lda)
										ldv = ldv + _d_ldv
										lda = lda + _d_lda
									end
								end
								bsa = bsa + _d_bsa
							end
						end
						ia0 = -ia0
					end
				end
				do
					for _ = 1, 2 do
						do
							local bsa, _d_bsa = (sa), (360 / 8 * ia0)
							for _ = 1, 8 do
								do
									local ldv, _d_ldv = (0), (-0.5 / 3)
									local lda, _d_lda = (-30), (60 / 3)
									for _ = 1, 4 do
										last = New(_editor_class["stage_3_midboss_yuyuko_Spell1_bullet1"], self.x, self.y, ia0, 9, 1.5, bsa, 180, ldv, lda)
										ldv = ldv + _d_ldv
										lda = lda + _d_lda
									end
								end
								bsa = bsa + _d_bsa
							end
						end
						ia0 = -ia0
					end
				end
				task._Wait(15)
				PlaySound("power02", 1, 0, true)
				task._Wait(105)
				local ia1 = ia
				do
					local dsa, _d_dsa = (60), (240 / 7)
					for _ = 1, 8 do
						PlaySound("tan00", 0.1, 0, false)
						local bcl = 2 + ia1
						do
							local bsa, _d_bsa = (ran:Float(0, 360)), (360 / 12 * ia1)
							for _ = 1, 12 do
								do
									local ldv, _d_ldv = (0), (-2 / 6)
									local lda, _d_lda = (-90), (90 / 6)
									for _ = 1, 7 do
										last = New(_editor_class["stage_3_midboss_yuyuko_Spell1_bullet1"], self.x, self.y, ia1, bcl, 3, bsa, dsa, ldv, lda)
										ldv = ldv + _d_ldv
										lda = lda + _d_lda
									end
								end
								bsa = bsa + _d_bsa
							end
						end
						lasttask = task.New(self, function()
							task.MoveToPlayer(30, -96, 96, 80, 112, 10, 24, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
						end)
						task._Wait(15)
						PlaySound("power02", 1, 0, true)
						task._Wait(15)
						ia1 = -ia1
						dsa = dsa + _d_dsa
					end
				end
				task._Wait(30)
				task.MoveTo(0, 112, 60, MOVE_DECEL)
				task._Wait(30)
				ia = -ia
			end
		end
	end)
end
local function card1_del_ENHL(self)
	if self.timeout == 1 then
		self.noExtendBonus = true
	else
		Spell_break_eff(self.x, self.y, 255, 50, 255,
				'marisa_star', 'yuyuko_ghost')
	end
end

local function create_boss1(group_name, class_name)
	return EISlib.stage.createBossClass(group_name, class_name, "Marisa", spellcard_background,
			{ "s3", stage3_background }, -256, 300,
			function(self)
				lstg.wis.Marisa(self)
			end)
end
local function create_boss2(group_name, class_name)
	return EISlib.stage.createBossClass(group_name, class_name, "Yuyuko", s3C_boss.scbg,
			{ "s3", stage3_background }, 256, 300,
			function(self)
				lstg.wis.Yuyuko(self)
			end)
end
local function create_dialog(boss_class, t)
	return EISlib.stage.createDialogClass(
			boss_class, false, t)
end
local function create_card(boss_class, card_name, time_t, hp, drop_t, mode, pre_action, init, del)
	local sc = EISlib.stage.createCardClass(boss_class, card_name, time_t, hp, drop_t, mode, pre_action)
	if init then
		sc.init = init
	end
	if del then
		sc.del = del
	end
	return sc
end

--common action
local function boss_common1(boss_class)
	create_dialog(boss_class, function(self)
		if ext.sc_pr then
			boss_scpr_show1(self, 0, 112)
		else
			task.Wait(30)
			task.MoveTo(0, 112, 60, MOVE_ACC_DEC)
			boss.show_aura(self, true)
		end
	end)
end
local function boss_common2(boss_class)
	create_dialog(boss_class, function(self)
		self.colli = false
		player.dialog = false
		if not self.noExtendBonus then
			PlaySound("enep01", 0.5, 0, false)
			misc.ShakeScreen(30, 3)
			_drop_item(item_bomb, 1, self.x, self.y)
		end
		task._Wait(120)
		task.MoveTo(256, 300, 60, MOVE_ACCEL)
		_del(self, true)
	end)
	-- 加一个非符防止boss被鲨
	EISlib.stage.createCardClass(boss_class, "",
			{ 60, 60, 60 }, 600, { 0, 0, 0 }, "normal", false, true)
end
local function boss_common3(boss_class)
	create_dialog(boss_class, function(self)
		if ext.sc_pr then
			boss_scpr_show2(self, 0, 112)
		else
			task.Wait(30)
			task.MoveTo(0, 112, 60, MOVE_ACC_DEC)
			boss.show_aura(self, true)
		end
	end)
end
local function boss_common4(boss_class)
	create_dialog(boss_class, function(self)
		self._wisys:setAction("normal", 9999)
		player.dialog = false
		self.colli = false
		if not self.noExtendBonus then
			PlaySound("enep01", 0.5, 0, false)
			misc.ShakeScreen(30, 3)
			_drop_item(item_extend, 1, self.x, self.y)
		end
		task._Wait(120)
		task.MoveTo(-256, 300, 90, MOVE_ACCEL)
		_del(self, true)
	end)
	-- 加一个非符防止boss被鲨
	EISlib.stage.createCardClass(boss_class, "",
			{ 60, 60, 60 }, 600, { 0, 0, 0 }, "normal", false, true)
end

--boss
local boss1_E = create_boss1("Easy", "stage3Cmid_boss1:Easy")
local boss1_N = create_boss1("Normal", "stage3Cmid_boss1:Normal")
local boss1_H = create_boss1("Hard", "stage3Cmid_boss1:Hard")
local boss1_L = create_boss1("Lunatic", "stage3Cmid_boss1:Lunatic")
local boss2_E = create_boss2("Easy", "stage3Cmid_boss2:Easy")
local boss2_N = create_boss2("Normal", "stage3Cmid_boss2:Normal")
local boss2_H = create_boss2("Hard", "stage3Cmid_boss2:Hard")
local boss2_L = create_boss2("Lunatic", "stage3Cmid_boss2:Lunatic")

--before
boss_common1(boss1_E)
boss_common1(boss1_N)
boss_common1(boss1_H)
boss_common1(boss1_L)
boss_common3(boss2_E)
boss_common3(boss2_N)
boss_common3(boss2_H)
boss_common3(boss2_L)

--attack
create_card(boss1_E, "通常攻击",
		{ 2, 5, 20 }, 600, { 0, 0, 0 }, "normal", true, normal1_init_E, normal1_del)
create_card(boss1_N, "通常攻击",
		{ 2, 5, 20 }, 600, { 0, 0, 0 }, "normal", true, normal1_init_N, normal1_del)
create_card(boss1_H, "通常攻击",
		{ 2, 5, 20 }, 600, { 0, 0, 0 }, "normal", true, normal1_init_H, normal1_del)
create_card(boss1_L, "通常攻击",
		{ 2, 5, 20 }, 600, { 0, 0, 0 }, "normal", true, normal1_init_L, normal1_del)

create_card(boss2_E, "哀蝶「世俗之盛，信仰之衰」",
		{ 2, 10, 25 }, 1600, {10, 20, 30}, "spellcard", true, card1_init_E, card1_del_ENHL)
create_card(boss2_N, "哀蝶「世俗之盛，信仰之衰」",
		{ 2, 10, 25 }, 1600, {10, 20, 30}, "spellcard", true, card1_init_N, card1_del_ENHL)
create_card(boss2_H, "哀蝶「世俗之盛，信仰之衰」",
		{ 2, 10, 25 }, 1600, {10, 20, 30}, "spellcard", true, card1_init_H, card1_del_ENHL)
create_card(boss2_L, "哀蝶「世俗之盛，信仰之衰」",
		{ 2, 10, 25 }, 1600, {10, 20, 30}, "spellcard", true, card1_init_L, card1_del_ENHL)

--after
boss_common2(boss1_E)
boss_common2(boss1_N)
boss_common2(boss1_H)
boss_common2(boss1_L)
boss_common4(boss2_E)
boss_common4(boss2_N)
boss_common4(boss2_H)
boss_common4(boss2_L)

function s3C_boss.mid1(diff)
	local boss
	diff = diff or difficulty
	if diff == 1 then
		boss = New(boss1_E, boss1_E.cards)
	elseif diff == 2 then
		boss = New(boss1_N, boss1_N.cards)
	elseif diff == 3 then
		boss = New(boss1_H, boss1_H.cards)
	elseif diff == 4 then
		boss = New(boss1_L, boss1_L.cards)
	end
	return boss
end
function s3C_boss.mid2(diff)
	local boss
	diff = diff or difficulty
	if diff == 1 then
		boss = New(boss2_E, boss2_E.cards)
	elseif diff == 2 then
		boss = New(boss2_N, boss2_N.cards)
	elseif diff == 3 then
		boss = New(boss2_H, boss2_H.cards)
	elseif diff == 4 then
		boss = New(boss2_L, boss2_L.cards)
	end
	return boss
end
