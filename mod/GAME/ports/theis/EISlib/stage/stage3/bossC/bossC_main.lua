local SB_SEASON_NMSL = 1 -- 阿卡斯留下的SB遗产，谁这么写谁SB

local function create_diff_function(marisa_fs, yuyuko_fs, connect, cardnames)
	return function(self)
		if lstg.IsValid(self.marisa) and marisa_fs[difficulty] then
			marisa_fs[difficulty](self.marisa)
			if connect then
				_connect(self, self.marisa, 1, true)
			end
		end
		if lstg.IsValid(self.yuyuko) and yuyuko_fs[difficulty] then
			yuyuko_fs[difficulty](self.yuyuko)
			if connect then
				_connect(self, self.yuyuko, 1, true)
			end
		end
		if cardnames and cardnames[difficulty] then
			self.ui_cardnames = cardnames[difficulty]
		end
	end
end

local cardname = {
	card1 = {
		marisa = {
			EN = "星符「双喷流星云」",
			HL = "双极「闵可夫斯基的蝴蝶」",
		},
		yuyuko = {
			EN = "迷符「化蝶之梦」",
			HL = "晓梦「栩栩然胡蝶化我」",
		},
	},
	card2 = {
		marisa = {
			EN = "光符「新星爆发」",
			HL = "魔空「百万超新星」",
		},
		yuyuko = {
			EN = "樱符「七日的满开」",
			HL = "灵樱「西行妖花风暴」",
		},
	},
	card3 = {
		marisa = {
			EN = "魔符「钻石星尘」",
			HL = "魔终「宇宙热寂」",
		},
		yuyuko = {
			EN = "死符「彷徨的孤魂」",
			HL = "死寂「三千大千悉皆入灭」",
		},
	},
}

-- card
--region normal 1
local function normal1_init_Marisa_E(self)
	local im = SB_SEASON_NMSL
	local i = ran:Sign()
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 255, 255, 32, 32, 32, 255, 255 }, { 32, 32, 32, 255, 255, 255, 160 }, { 32, 255, 255, 255, 32, 32, 32 }, { 1, 3, 5, 7, 9, 11, 13 }
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 56)
		local ia = i
		do
			local rla, _d_rla = (0), (-360 / 4)
			for _ = 1, _infinite do
				local tim = 60
				PlaySound("option", 0.1, 0, false)
				do
					local sa, _d_sa = (ran:Float(0, 360)), (360 / 4 * ia)
					local la, _d_la = (rla * i), (360 / 4 * i)
					for _ = 1, 4 do
						last = New(_editor_class["stage_3_boss_marisa_NoSpell1_circle"], self.x, self.y, 1, ia, 90, sa, 4, circle_redarray[1], circle_greenarray[1], circle_bluearray[1], circle_bullet_clarray[1], la)
						_connect(self, last, 0, true)
						sa = sa + _d_sa
						la = la + _d_la
					end
				end
				task._Wait(60)
				do
					for _ = 1, 4 do
						task._Wait(60)
						task.MoveToPlayer(60, -32 * im, -96 * im, 100, 124, 16, 48, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
					end
				end
				task._Wait(30)
				task.MoveTo(64 * im, 112, 60, MOVE_DECEL)
				task._Wait(30)
				self._wisys:setAction("cast", 56)
				ia, im = -ia, -im
				rla = rla + _d_rla
			end
		end
	end)
end
local function normal1_init_Marisa_N(self)
	local im = SB_SEASON_NMSL
	local i = ran:Sign()
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 255, 255, 32, 32, 32, 255, 255 }, { 32, 32, 32, 255, 255, 255, 160 }, { 32, 255, 255, 255, 32, 32, 32 }, { 1, 3, 5, 7, 9, 11, 13 }
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 56)
		local ia = i
		do
			local rla, _d_rla = (0), (-360 / 4)
			for _ = 1, _infinite do
				local tim = 60
				PlaySound("option", 0.1, 0, false)
				do
					local sa, _d_sa = (ran:Float(0, 360)), (360 / 4 * ia)
					local la, _d_la = (rla * i), (360 / 4 * i)
					for _ = 1, 4 do
						last = New(_editor_class["stage_3_boss_marisa_NoSpell1_circle"], self.x, self.y, 2, ia, 90, sa, 4, circle_redarray[1], circle_greenarray[1], circle_bluearray[1], circle_bullet_clarray[1], la)
						_connect(self, last, 0, true)
						sa = sa + _d_sa
						la = la + _d_la
					end
				end
				task._Wait(60)
				do
					for _ = 1, 4 do
						task._Wait(60)
						task.MoveToPlayer(60, -32 * im, -96 * im, 100, 124, 16, 48, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
					end
				end
				task._Wait(30)
				task.MoveTo(64 * im, 112, 60, MOVE_DECEL)
				task._Wait(30)
				self._wisys:setAction("cast", 56)
				ia, im = -ia, -im
				rla = rla + _d_rla
			end
		end
	end)
end
local function normal1_init_Marisa_H(self)
	local im = SB_SEASON_NMSL
	local i = ran:Sign()
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 255, 255, 32, 32, 32, 255, 255 }, { 32, 32, 32, 255, 255, 255, 160 }, { 32, 255, 255, 255, 32, 32, 32 }, { 1, 3, 5, 7, 9, 11, 13 }
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 56)
		local ia = i
		do
			local rla, _d_rla = (0), (-360 / 4)
			for _ = 1, _infinite do
				local tim = 60
				PlaySound("option", 0.1, 0, false)
				do
					local sa, _d_sa = (ran:Float(0, 360)), (360 / 4 * ia)
					local la, _d_la = (rla * i), (360 / 4 * i)
					for _ = 1, 4 do
						last = New(_editor_class["stage_3_boss_marisa_NoSpell1_circle"], self.x, self.y, 3, ia, 90, sa, 4, circle_redarray[1], circle_greenarray[1], circle_bluearray[1], circle_bullet_clarray[1], la)
						_connect(self, last, 0, true)
						sa = sa + _d_sa
						la = la + _d_la
					end
				end
				task._Wait(60)
				do
					for _ = 1, 4 do
						task._Wait(60)
						task.MoveToPlayer(60, -32 * im, -96 * im, 100, 124, 16, 48, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
					end
				end
				task._Wait(30)
				task.MoveTo(64 * im, 112, 60, MOVE_DECEL)
				task._Wait(30)
				self._wisys:setAction("cast", 56)
				ia, im = -ia, -im
				rla = rla + _d_rla
			end
		end
	end)
end
local function normal1_init_Marisa_L(self)
	local im = SB_SEASON_NMSL
	local i = ran:Sign()
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 255, 255, 32, 32, 32, 255, 255 }, { 32, 32, 32, 255, 255, 255, 160 }, { 32, 255, 255, 255, 32, 32, 32 }, { 1, 3, 5, 7, 9, 11, 13 }
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 56)
		local ia = i
		do
			local rla, _d_rla = (0), (-360 / 4)
			for _ = 1, _infinite do
				local tim = 60
				PlaySound("option", 0.1, 0, false)
				do
					local sa, _d_sa = (ran:Float(0, 360)), (360 / 4 * ia)
					local la, _d_la = (rla * i), (360 / 4 * i)
					for _ = 1, 4 do
						last = New(_editor_class["stage_3_boss_marisa_NoSpell1_circle"], self.x, self.y, 4, ia, 90, sa, 4, circle_redarray[1], circle_greenarray[1], circle_bluearray[1], circle_bullet_clarray[1], la)
						_connect(self, last, 0, true)
						sa = sa + _d_sa
						la = la + _d_la
					end
				end
				task._Wait(60)
				do
					for _ = 1, 4 do
						task._Wait(60)
						task.MoveToPlayer(60, -32 * im, -96 * im, 100, 124, 16, 48, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
					end
				end
				task._Wait(30)
				task.MoveTo(64 * im, 112, 60, MOVE_DECEL)
				task._Wait(30)
				self._wisys:setAction("cast", 56)
				ia, im = -ia, -im
				rla = rla + _d_rla
			end
		end
	end)
end
local function normal1_init_Yuyuko_E(self)
	local im = -SB_SEASON_NMSL
	local i = ran:Sign()
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		local ia = i
		do
			for _ = 1, _infinite do
				lasttask = task.New(self, function()
					task._Wait(45)
					task.MoveToPlayer(60, -32 * im, -32 * im - 64 * im, 100, 124, 16, 48, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
				end)
				do
					local sa, _d_sa = (270 - 480 * ia), (480 * ia / 19)
					local r, _d_r = (90), (-90 / 19)
					for _ = 1, 20 do
						PlaySound("kira00", 0.1, 0, false)
						do
							local a, _d_a = (sa - 90 * ia - 30 * ia), (60 * ia)
							for _ = 1, 2 do
								last = New(_straight, ball_big, COLOR_ROYAL_BLUE, self.x + r * cos(sa) + 30 * cos(a), self.y + r * sin(sa) + 30 * sin(a), 2, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								a = a + _d_a
							end
						end
						task._Wait(6)
						sa = sa + _d_sa
						r = r + _d_r
					end
				end
				task._Wait(60)
				lasttask = task.New(self, function()
					task._Wait(45)
					task.MoveToPlayer(60, 32 - 64 * im, 32 - 64 * im, 100, 124, 16, 48, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
				end)
				do
					local sa, _d_sa = (270 + 480 * ia), (-480 * ia / 19)
					local r, _d_r = (60), (-60 / 19)
					for _ = 1, 20 do
						PlaySound("kira00", 0.1, 0, false)
						do
							local a, _d_a = (sa - 180 * ia), (360 / 2 * ia)
							for _ = 1, 2 do
								last = New(_straight, ball_big, COLOR_YELLOW, self.x + r * cos(sa) + 15 * cos(a), self.y + r * sin(sa) + 15 * sin(a), 2, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								a = a + _d_a
							end
						end
						task._Wait(6)
						sa = sa + _d_sa
						r = r + _d_r
					end
				end
				task._Wait(60)
				PlaySound("power02", 1, 0, true)
				lasttask = task.New(self, function()
					task.MoveTo(-64 * im, 112, 60, MOVE_DECEL)
				end)
				self._wisys:setAction("cast", 64)
				do
					local saa, _d_saa = (270 + 840 * ia), (-840 * ia / 34)
					local sab, _d_sab = (270 - 840 * ia), (840 * ia / 34)
					local ra, _d_ra = (60), (-60 / 34)
					local rb, _d_rb = (90), (-90 / 34)
					for _ = 1, 35 do
						PlaySound("kira00", 0.1, 0, false)
						do
							local aa, _d_aa = (saa + 90 * ia), (0)
							for _ = 1, 1 do
								last = New(_straight, ball_big, COLOR_YELLOW, self.x + ra * cos(saa) + 30 * cos(aa), self.y + ra * sin(saa) + 30 * sin(aa), 2, aa, false, 0, true, true, 0, false, 0, 0, 0, false)
								aa = aa + _d_aa
							end
						end
						do
							local ab, _d_ab = (sab), (0)
							for _ = 1, 1 do
								last = New(_straight, ball_big, COLOR_ROYAL_BLUE, self.x + rb * cos(sab) + 15 * cos(ab), self.y + rb * sin(sab) + 15 * sin(ab), 2, ab, false, 0, true, true, 0, false, 0, 0, 0, false)
								ab = ab + _d_ab
							end
						end
						task._Wait(6)
						saa = saa + _d_saa
						sab = sab + _d_sab
						ra = ra + _d_ra
						rb = rb + _d_rb
					end
				end
				task.MoveTo(64 * im, 112, 60, MOVE_DECEL)
				task._Wait(30)
				ia, im = -ia, -im
			end
		end
	end)
end
local function normal1_init_Yuyuko_N(self)
	local im = -SB_SEASON_NMSL
	local i = ran:Sign()
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		local ia = i
		do
			for _ = 1, _infinite do
				lasttask = task.New(self, function()
					task._Wait(45)
					task.MoveToPlayer(60, -32 * im, -32 * im - 64 * im, 100, 124, 16, 48, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
				end)
				do
					local sa, _d_sa = (270 - 480 * ia), (480 * ia / 23)
					local r, _d_r = (90), (-90 / 23)
					for _ = 1, 24 do
						PlaySound("kira00", 0.1, 0, false)
						do
							local a, _d_a = (sa - 90 * ia - 30 * ia), (60 * ia / 3)
							for _ = 1, 4 do
								last = New(_straight, ball_big, COLOR_ROYAL_BLUE, self.x + r * cos(sa) + 30 * cos(a), self.y + r * sin(sa) + 30 * sin(a), 2, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								a = a + _d_a
							end
						end
						task._Wait(5)
						sa = sa + _d_sa
						r = r + _d_r
					end
				end
				task._Wait(60)
				lasttask = task.New(self, function()
					task._Wait(45)
					task.MoveToPlayer(60, 32 - 64 * im, 32 - 64 * im, 100, 124, 16, 48, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
				end)
				do
					local sa, _d_sa = (270 + 480 * ia), (-480 * ia / 23)
					local r, _d_r = (60), (-60 / 23)
					for _ = 1, 24 do
						PlaySound("kira00", 0.1, 0, false)
						do
							local a, _d_a = (sa - 180 * ia), (360 / 4 * ia)
							for _ = 1, 4 do
								last = New(_straight, ball_big, COLOR_YELLOW, self.x + r * cos(sa) + 15 * cos(a), self.y + r * sin(sa) + 15 * sin(a), 2, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								a = a + _d_a
							end
						end
						task._Wait(5)
						sa = sa + _d_sa
						r = r + _d_r
					end
				end
				task._Wait(60)
				PlaySound("power02", 1, 0, true)
				lasttask = task.New(self, function()
					task.MoveTo(-64 * im, 112, 60, MOVE_DECEL)
				end)
				self._wisys:setAction("cast", 64)
				do
					local saa, _d_saa = (270 + 840 * ia), (-840 * ia / 41)
					local sab, _d_sab = (270 - 840 * ia), (840 * ia / 41)
					local ra, _d_ra = (60), (-60 / 41)
					local rb, _d_rb = (90), (-90 / 41)
					for _ = 1, 42 do
						PlaySound("kira00", 0.1, 0, false)
						do
							local aa, _d_aa = (saa + 90 * ia - 30 * ia), (60 * ia / 1)
							for _ = 1, 2 do
								last = New(_straight, ball_big, COLOR_YELLOW, self.x + ra * cos(saa) + 30 * cos(aa), self.y + ra * sin(saa) + 30 * sin(aa), 2, aa, false, 0, true, true, 0, false, 0, 0, 0, false)
								aa = aa + _d_aa
							end
						end
						do
							local ab, _d_ab = (sab - 180 * ia), (360 / 2 * ia)
							for _ = 1, 2 do
								last = New(_straight, ball_big, COLOR_ROYAL_BLUE, self.x + rb * cos(sab) + 15 * cos(ab), self.y + rb * sin(sab) + 15 * sin(ab), 2, ab, false, 0, true, true, 0, false, 0, 0, 0, false)
								ab = ab + _d_ab
							end
						end
						task._Wait(5)
						saa = saa + _d_saa
						sab = sab + _d_sab
						ra = ra + _d_ra
						rb = rb + _d_rb
					end
				end
				task.MoveTo(64 * im, 112, 60, MOVE_DECEL)
				task._Wait(30)
				ia, im = -ia, -im
			end
		end
	end)
end
local function normal1_init_Yuyuko_H(self)
	local im = -SB_SEASON_NMSL
	local i = ran:Sign()
	lasttask = task.New(self, function()
		task._Wait(30)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		local ia = i
		do
			for _ = 1, _infinite do
				lasttask = task.New(self, function()
					task._Wait(60)
					task.MoveToPlayer(60, -32 * im, -32 * im - 64 * im, 100, 124, 16, 48, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
				end)
				do
					local sa, _d_sa = (270 - 480 * ia), (480 * ia / 29)
					local r, _d_r = (90), (-90 / 29)
					for _ = 1, 30 do
						PlaySound("kira00", 0.1, 0, false)
						do
							local a, _d_a = (sa - 90 * ia - 30 * ia), (60 * ia / 3)
							for _ = 1, 4 do
								last = New(_straight, ball_big, COLOR_ROYAL_BLUE, self.x + r * cos(sa) + 30 * cos(a), self.y + r * sin(sa) + 30 * sin(a), 2, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								a = a + _d_a
							end
						end
						task._Wait(4)
						sa = sa + _d_sa
						r = r + _d_r
					end
				end
				task._Wait(60)
				lasttask = task.New(self, function()
					task._Wait(60)
					task.MoveToPlayer(60, 32 - 64 * im, 32 - 64 * im, 100, 124, 16, 48, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
				end)
				do
					local sa, _d_sa = (270 + 480 * ia), (-480 * ia / 29)
					local r, _d_r = (60), (-60 / 29)
					for _ = 1, 30 do
						PlaySound("kira00", 0.1, 0, false)
						do
							local a, _d_a = (sa - 180 * ia), (360 / 4 * ia)
							for _ = 1, 4 do
								last = New(_straight, ball_big, COLOR_YELLOW, self.x + r * cos(sa) + 15 * cos(a), self.y + r * sin(sa) + 15 * sin(a), 2, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								a = a + _d_a
							end
						end
						task._Wait(4)
						sa = sa + _d_sa
						r = r + _d_r
					end
				end
				task._Wait(60)
				PlaySound("power02", 1, 0, true)
				lasttask = task.New(self, function()
					task.MoveTo(-64 * im, 112, 60, MOVE_DECEL)
				end)
				self._wisys:setAction("cast", 64)
				do
					local saa, _d_saa = (270 + 840 * ia), (-840 * ia / 41)
					local sab, _d_sab = (270 - 840 * ia), (840 * ia / 41)
					local ra, _d_ra = (60), (-60 / 41)
					local rb, _d_rb = (90), (-90 / 41)
					for _ = 1, 42 do
						PlaySound("kira00", 0.1, 0, false)
						do
							local aa, _d_aa = (saa + 90 * ia - 30 * ia), (60 * ia / 2)
							for _ = 1, 3 do
								last = New(_straight, ball_big, COLOR_YELLOW, self.x + ra * cos(saa) + 30 * cos(aa), self.y + ra * sin(saa) + 30 * sin(aa), 2, aa, false, 0, true, true, 0, false, 0, 0, 0, false)
								aa = aa + _d_aa
							end
						end
						do
							local ab, _d_ab = (sab - 180 * ia), (360 / 3 * ia)
							for _ = 1, 3 do
								last = New(_straight, ball_big, COLOR_ROYAL_BLUE, self.x + rb * cos(sab) + 15 * cos(ab), self.y + rb * sin(sab) + 15 * sin(ab), 2, ab, false, 0, true, true, 0, false, 0, 0, 0, false)
								ab = ab + _d_ab
							end
						end
						task._Wait(5)
						saa = saa + _d_saa
						sab = sab + _d_sab
						ra = ra + _d_ra
						rb = rb + _d_rb
					end
				end
				task.MoveTo(64 * im, 112, 60, MOVE_DECEL)
				task._Wait(30)
				ia, im = -ia, -im
			end
		end
	end)
end
local function normal1_init_Yuyuko_L(self)
	local im = -SB_SEASON_NMSL
	local i = ran:Sign()
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		local ia = i
		do
			for _ = 1, _infinite do
				lasttask = task.New(self, function()
					task._Wait(60)
					task.MoveToPlayer(60, -32 * im, -32 * im - 64 * im, 100, 124, 16, 48, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
				end)
				do
					local sa, _d_sa = (270 - 480 * ia), (480 * ia / 39)
					local r, _d_r = (90), (-90 / 39)
					for _ = 1, 40 do
						PlaySound("kira00", 0.1, 0, false)
						do
							local a, _d_a = (sa - 90 * ia - 30 * ia), (60 * ia / 3)
							for _ = 1, 4 do
								last = New(_straight, ball_big, COLOR_ROYAL_BLUE, self.x + r * cos(sa) + 30 * cos(a), self.y + r * sin(sa) + 30 * sin(a), 2, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								a = a + _d_a
							end
						end
						task._Wait(3)
						sa = sa + _d_sa
						r = r + _d_r
					end
				end
				task._Wait(60)
				lasttask = task.New(self, function()
					task._Wait(60)
					task.MoveToPlayer(60, 32 - 64 * im, 32 - 64 * im, 100, 124, 16, 48, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
				end)
				do
					local sa, _d_sa = (270 + 480 * ia), (-480 * ia / 39)
					local r, _d_r = (60), (-60 / 39)
					for _ = 1, 40 do
						PlaySound("kira00", 0.1, 0, false)
						do
							local a, _d_a = (sa - 180 * ia), (360 / 4 * ia)
							for _ = 1, 4 do
								last = New(_straight, ball_big, COLOR_YELLOW, self.x + r * cos(sa) + 15 * cos(a), self.y + r * sin(sa) + 15 * sin(a), 2, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								a = a + _d_a
							end
						end
						task._Wait(3)
						sa = sa + _d_sa
						r = r + _d_r
					end
				end
				task._Wait(60)
				PlaySound("power02", 1, 0, true)
				lasttask = task.New(self, function()
					task.MoveTo(-64 * im, 112, 60, MOVE_DECEL)
				end)
				self._wisys:setAction("cast", 64)
				do
					local saa, _d_saa = (270 + 840 * ia), (-840 * ia / 69)
					local sab, _d_sab = (270 - 840 * ia), (840 * ia / 69)
					local ra, _d_ra = (60), (-60 / 69)
					local rb, _d_rb = (90), (-90 / 69)
					for _ = 1, 70 do
						PlaySound("kira00", 0.1, 0, false)
						do
							local aa, _d_aa = (saa + 90 * ia - 30 * ia), (60 * ia / 2)
							for _ = 1, 3 do
								last = New(_straight, ball_big, COLOR_YELLOW, self.x + ra * cos(saa) + 30 * cos(aa), self.y + ra * sin(saa) + 30 * sin(aa), 2, aa, false, 0, true, true, 0, false, 0, 0, 0, false)
								aa = aa + _d_aa
							end
						end
						do
							local ab, _d_ab = (sab - 180 * ia), (360 / 3 * ia)
							for _ = 1, 3 do
								last = New(_straight, ball_big, COLOR_ROYAL_BLUE, self.x + rb * cos(sab) + 15 * cos(ab), self.y + rb * sin(sab) + 15 * sin(ab), 2, ab, false, 0, true, true, 0, false, 0, 0, 0, false)
								ab = ab + _d_ab
							end
						end
						task._Wait(3)
						saa = saa + _d_saa
						sab = sab + _d_sab
						ra = ra + _d_ra
						rb = rb + _d_rb
					end
				end
				task.MoveTo(64 * im, 112, 60, MOVE_DECEL)
				task._Wait(30)
				ia, im = -ia, -im
			end
		end
	end)
end
local normal1_init = create_diff_function(
		{normal1_init_Marisa_E, normal1_init_Marisa_N, normal1_init_Marisa_H, normal1_init_Marisa_L},
		{normal1_init_Yuyuko_E, normal1_init_Yuyuko_N, normal1_init_Yuyuko_H, normal1_init_Yuyuko_L},
		true)
local normal1_del = create_diff_function(
		{false, false, false, false},
		{false, false, false, false},
		false)
--endregion

--region card 1
local function card1_init_Marisa_E(self)
	local im = 1
	local i = 1
	local sign = { x = self.x, y = self.y }
	lasttask = task.New(self, function()
		task.MoveTo(0, 0, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		local bullet_clarray = { 1, 13, 11, 9, 7, 5, 3, 15 }
		do
			s3C_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 56)
		local ia = i
		do
			for _ = 1, _infinite do
				PlaySound("boon01", 0.1, 0, false)
				local ia0 = ia
				local lsa = ran:Float(0, 360)
				do
					local bisa, _d_bisa = (Angle(self, player)), (360 / 2 * ia)
					local rsa, _d_rsa = (ia), (180 * ia / 1)
					for _ = 1, 2 do
						last = New(_editor_class["stage_3_boss_marisa_Spell1"], self.x, self.y, 1, ia, ia0, sign, bisa, rsa, lsa)
						ia0 = -ia0
						bisa = bisa + _d_bisa
						rsa = rsa + _d_rsa
					end
				end
				lasttask = task.New(self, function()
					local ia1 = ia
					local n = 1
					do
						local sv, _d_sv = (3), (-2 / 7)
						for _ = 1, 8 do
							PlaySound("kira00", 0.1, 0, false)
							do
								local sa, _d_sa = (Angle(self, player)), (360 / 16 * ia1)
								for _ = 1, 16 do
									last = New(_straight, star_small, bullet_clarray[n], self.x, self.y, 0, sa, false, 4 * ia1, true, true, 0, false, 0, 0, 0, false)
									_object.set_color(last, "", 255, 255, 255, 255)
									lasttask = task.New(last, _editor_tasks["stage_3_boss_marisa_Spell1_bullettask"](sv, sa))
									if (n < 8) then
										n = n + 1
									else
										n = 1
									end
									sa = sa + _d_sa
								end
							end
							ia1 = -ia1
							task._Wait(30)
							sv = sv + _d_sv
						end
					end
				end)
				task._Wait(810)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 56)
				end)
				task._Wait(30)
				ia = -ia
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				sign.x, sign.y = self.x, self.y
				task._Wait(1)
			end
		end
	end)
end
local function card1_init_Marisa_N(self)
	local im = 1
	local i = 1
	local sign = { x = self.x, y = self.y }
	lasttask = task.New(self, function()
		task.MoveTo(0, 0, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			s3C_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 56)
		local ia = i
		do
			for _ = 1, _infinite do
				PlaySound("boon01", 0.1, 0, false)
				local ia0 = ia
				local lsa = ran:Float(0, 360)
				do
					local bisa, _d_bisa = (Angle(self, player)), (360 / 2 * ia)
					local rsa, _d_rsa = (ia), (180 * ia / 1)
					for _ = 1, 2 do
						last = New(_editor_class["stage_3_boss_marisa_Spell1"], self.x, self.y, 2, ia, ia0, sign, bisa, rsa, lsa)
						ia0 = -ia0
						bisa = bisa + _d_bisa
						rsa = rsa + _d_rsa
					end
				end
				lasttask = task.New(self, function()
					local bullet_clarray = { 1, 13, 11, 9, 7, 5, 3, 15 }
					local n = 1
					local ia1 = ia
					do
						local sv, _d_sv = (3), (-2 / 7)
						local la, _d_la = (0), (360 * ia / 16)
						for _ = 1, 8 do
							PlaySound("kira00", 0.1, 0, false)
							do
								local sa, _d_sa = (Angle(self, player) - la), (360 / 16 * ia)
								for _ = 1, 16 do
									last = New(_straight, star_big, bullet_clarray[n], self.x, self.y, 0, sa, false, 4 * ia1, true, true, 0, false, 0, 0, 0, false)
									lasttask = task.New(last, _editor_tasks["stage_3_boss_marisa_Spell1_bullettask"](sv, sa))
									if (n < 8) then
										n = n + 1
									else
										n = 1
									end
									sa = sa + _d_sa
								end
							end
							ia1 = -ia1
							task._Wait(30)
							sv = sv + _d_sv
							la = la + _d_la
						end
					end
				end)
				task._Wait(810)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 56)
				end)
				task._Wait(30)
				ia = -ia
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				sign.x, sign.y = self.x, self.y
				task._Wait(1)
			end
		end
	end)
end
local function card1_init_Marisa_H(self)
	local im = 1
	local i = 1
	local sign = { x = self.x, y = self.y }
	lasttask = task.New(self, function()
		task.MoveTo(0, 0, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			s3C_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 56)
		local ia = i
		do
			for _ = 1, _infinite do
				PlaySound("boon01", 0.1, 0, false)
				local ia0 = ia
				local lsa = ran:Float(0, 360)
				do
					local bisa, _d_bisa = (Angle(self, player)), (360 / 2 * ia)
					local rsa, _d_rsa = (ia), (180 * ia / 1)
					for _ = 1, 2 do
						last = New(_editor_class["stage_3_boss_marisa_Spell1"], self.x, self.y, 3, ia, ia0, sign, bisa, rsa, lsa)
						ia0 = -ia0
						bisa = bisa + _d_bisa
						rsa = rsa + _d_rsa
					end
				end
				task._Wait(810)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 56)
				end)
				task._Wait(30)
				ia = -ia
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				sign.x, sign.y = self.x, self.y
				task._Wait(1)
			end
		end
	end)
end
local function card1_init_Marisa_L(self)
	local im = 1
	local i = 1
	local sign = { x = self.x, y = self.y }
	lasttask = task.New(self, function()
		task.MoveTo(0, 0, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			s3C_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 56)
		local ia = i
		do
			for _ = 1, _infinite do
				PlaySound("boon01", 0.1, 0, false)
				local ia0 = ia
				local lsa = ran:Float(0, 360)
				do
					local bisa, _d_bisa = (Angle(self, player)), (360 / 2 * ia)
					local rsa, _d_rsa = (ia), (180 * ia / 1)
					for _ = 1, 2 do
						last = New(_editor_class["stage_3_boss_marisa_Spell1"], self.x, self.y, 4, ia, ia0, sign, bisa, rsa, lsa)
						ia0 = -ia0
						bisa = bisa + _d_bisa
						rsa = rsa + _d_rsa
					end
				end
				task._Wait(810)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 56)
				end)
				task._Wait(30)
				ia = -ia
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				sign.x, sign.y = self.x, self.y
				task._Wait(1)
			end
		end
	end)
end
local function card1_init_Yuyuko_E(self)
	local im = -1
	local i = 1
	lasttask = task.New(self, function()
		task.MoveTo(0, 80, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(60)
			end
		end
		task._Wait(480)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		local ia = i
		do
			for _ = 1, _infinite do
				local sra = 0
				local ia0 = -ia
				do
					for _ = 1, 2 do
						lasttask = task.New(self, _editor_tasks["stage_3_boss_yuyuko_Spell1_task"](1, -ia, ia0, 270 + 45 * ia0))
						ia0 = -ia0
					end
				end
				local ia1 = ia
				do
					for _ = 1, 2 do
						lasttask = task.New(self, _editor_tasks["stage_3_boss_yuyuko_Spell1_task"](1, ia, ia1, 90 + 67.5 * ia1))
						ia1 = -ia1
					end
				end
				task._Wait(810)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 64)
				end)
				task._Wait(30)
				ia = -ia
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			local t, _d_t = (0), (1)
			for _ = 1, _infinite do
				if (player.y < self.y) then
				else
					if (t % 10 > 0) then
					else
						local sa = Angle(self, player)
						do
							local addv, _d_addv = (0), (1 / 3)
							for _ = 1, 4 do
								last = New(_straight, butterfly, COLOR_RED, self.x, self.y, 1.5, sa, false, 0, true, true, 0, false, 0, 0, 0, false)
								lasttask = task.New(last, _editor_tasks["stage_3_boss_yuyuko_Spell1_bullettask2"](1.5, addv, sa))
								addv = addv + _d_addv
							end
						end
					end
				end
				task._Wait(1)
				t = t + _d_t
			end
		end
	end)
end
local function card1_init_Yuyuko_N(self)
	local im = -1
	local i = 1
	lasttask = task.New(self, function()
		task.MoveTo(0, 80, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 64)
		task._Wait(480)
		lasttask = task.New(self, function()
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(60)
			end
			self._wisys:setAction("cast", 64)
		end)
		task._Wait(30)
		local ia = i
		do
			for _ = 1, _infinite do
				local sra = 0
				local ia0 = -ia
				do
					for _ = 1, 2 do
						lasttask = task.New(self, _editor_tasks["stage_3_boss_yuyuko_Spell1_task"](2, -ia, ia0, 270 + 45 * ia0))
						ia0 = -ia0
					end
				end
				local ia1 = ia
				do
					for _ = 1, 2 do
						lasttask = task.New(self, _editor_tasks["stage_3_boss_yuyuko_Spell1_task"](2, ia, ia1, 90 + 67.5 * ia1))
						ia1 = -ia1
					end
				end
				task._Wait(810)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 64)
				end)
				task._Wait(30)
				ia = -ia
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			local t, _d_t = (0), (1)
			for _ = 1, _infinite do
				if (player.y < self.y) then
				else
					if (t % 10 > 0) then
					else
						local sa = Angle(self, player)
						do
							local addv, _d_addv = (0), (1 / 3)
							for _ = 1, 4 do
								last = New(_straight, butterfly, COLOR_RED, self.x, self.y, 1.5, sa, false, 0, true, true, 0, false, 0, 0, 0, false)
								lasttask = task.New(last, _editor_tasks["stage_3_boss_yuyuko_Spell1_bullettask2"](1.5, addv, sa))
								addv = addv + _d_addv
							end
						end
					end
				end
				task._Wait(1)
				t = t + _d_t
			end
		end
	end)
end
local function card1_init_Yuyuko_H(self)
	local im = -1
	local i = 1
	lasttask = task.New(self, function()
		task.MoveTo(0, 80, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(60)
			end
			self._wisys:setAction("cast", 64)
		end
		task._Wait(480)
		self._wisys:setAction("cast", 64)
		lasttask = task.New(self, function()
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(60)
			end
			self._wisys:setAction("cast", 64)
		end)
		task._Wait(30)
		local ia = i
		do
			for _ = 1, _infinite do
				local sra = 0
				local ia0 = ia
				do
					local sv, _d_sv = (3), (-1.5 / 35)
					local sa, _d_sa = (Angle(self, player)), (2340 * ia / 35)
					for _ = 1, 36 do
						PlaySound("kira00", 0.1, 0, false)
						do
							local a, _d_a = (sa), (360 / 2 * ia)
							for _ = 1, 2 do
								do
									local ra, _d_ra = (-10), (20 / 4)
									for _ = 1, 5 do
										last = New(_straight, butterfly, COLOR_PURPLE, self.x, self.y, sv, a, false, 0, true, true, 0, false, 0, 0, 0, false)
										lasttask = task.New(last, _editor_tasks["stage_3_boss_yuyuko_Spell1_bullettask1"](ia, ia0, sv, a, sra, ra))
										ra = ra + _d_ra
									end
								end
								a = a + _d_a
							end
						end
						ia0, sra = -ia0, sra + 180 / 35
						task._Wait(5)
						sv = sv + _d_sv
						sa = sa + _d_sa
					end
				end
				task._Wait(630)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 64)
				end)
				task._Wait(30)
				ia = -ia
			end
		end
	end)
end
local function card1_init_Yuyuko_L(self)
	local im = -1
	local i = 1
	lasttask = task.New(self, function()
		task.MoveTo(0, 80, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(60)
			end
			self._wisys:setAction("cast", 64)
		end
		task._Wait(480)
		lasttask = task.New(self, function()
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(60)
			end
			self._wisys:setAction("cast", 64)
		end)
		task._Wait(30)
		local ia = i
		do
			for _ = 1, _infinite do
				local sra = 0
				local ia0 = ia
				do
					local sv, _d_sv = (3), (-1.5 / 59)
					local sa, _d_sa = (Angle(self, player)), (2340 * ia / 59)
					for _ = 1, 60 do
						PlaySound("kira00", 0.1, 0, false)
						do
							local a, _d_a = (sa), (360 / 2 * ia)
							for _ = 1, 2 do
								do
									local ra, _d_ra = (-9), (18 / 6)
									for _ = 1, 7 do
										last = New(_straight, butterfly, COLOR_PURPLE, self.x, self.y, sv, a, false, 0, true, true, 0, false, 0, 0, 0, false)
										lasttask = task.New(last, _editor_tasks["stage_3_boss_yuyuko_Spell1_bullettask1"](ia, ia0, sv, a, sra, ra))
										ra = ra + _d_ra
									end
								end
								a = a + _d_a
							end
						end
						ia0, sra = -ia0, sra + 180 / 59
						task._Wait(3)
						sv = sv + _d_sv
						sa = sa + _d_sa
					end
				end
				task._Wait(630)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 64)
				end)
				task._Wait(30)
				ia = -ia
			end
		end
	end)
end
local function card1_del_Marisa_ENHL(self)
	Spell_break_eff(self.x, self.y, 255, 255, 0,
			'marisa_star', 'yuyuko_ghost')
end
local function card1_del_Yuyuko_ENHL(self)
	Spell_break_eff(self.x, self.y, 255, 50, 255,
			'marisa_star', 'yuyuko_ghost')
end
local card1_init = create_diff_function(
		{card1_init_Marisa_E, card1_init_Marisa_N, card1_init_Marisa_H, card1_init_Marisa_L},
		{card1_init_Yuyuko_E, card1_init_Yuyuko_N, card1_init_Yuyuko_H, card1_init_Yuyuko_L},
		true,
		{
			{cardname.card1.marisa.EN, cardname.card1.yuyuko.EN},
			{cardname.card1.marisa.EN, cardname.card1.yuyuko.EN},
			{cardname.card1.marisa.HL, cardname.card1.yuyuko.HL},
			{cardname.card1.marisa.HL, cardname.card1.yuyuko.HL},
		})
local card1_del = create_diff_function(
		{card1_del_Marisa_ENHL, card1_del_Marisa_ENHL, card1_del_Marisa_ENHL, card1_del_Marisa_ENHL},
		{card1_del_Yuyuko_ENHL, card1_del_Yuyuko_ENHL, card1_del_Yuyuko_ENHL, card1_del_Yuyuko_ENHL},
		false)
--endregion

--region normal 2
local function normal2_init_Marisa_E(self)
	local im = -SB_SEASON_NMSL
	local i = ran:Sign()
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 255, 255, 32, 32, 32, 255, 255 }, { 32, 32, 32, 255, 255, 255, 160 }, { 32, 255, 255, 255, 32, 32, 32 }, { 1, 3, 5, 7, 9, 11, 13 }
	local xy = { x = self.x, y = self.y }
	lasttask = task.New(self, function()
		task.MoveTo(-64 * im, 112, 60, MOVE_DECEL)
		task._Wait(30)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 56)
		task._Wait(30)
		local ia = -i
		do
			local rla, _d_rla = (0), (-360 / 4)
			for _ = 1, _infinite do
				local tim = 60
				PlaySound("option", 0.1, 0, false)
				do
					local sa, _d_sa = (ran:Float(0, 360)), (360 / 4 * ia)
					local la, _d_la = (rla * i), (360 / 4 * i)
					for _ = 1, 4 do
						last = New(_editor_class["stage_3_boss_marisa_NoSpell2_circle"], self.x, self.y, 1, ia, 90, sa, 4, circle_redarray[3], circle_greenarray[3], circle_bluearray[3], circle_bullet_clarray[3], la, xy)
						_connect(self, last, 0, true)
						sa = sa + _d_sa
						la = la + _d_la
					end
				end
				task._Wait(60)
				do
					for _ = 1, 4 do
						task._Wait(60)
						task.MoveToPlayer(60, -64 * im, -64 * im - 64 * im, 100, 124, 16, 48, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
					end
				end
				task._Wait(30)
				task.MoveTo(64 * im, 112, 60, MOVE_DECEL)
				task._Wait(30)
				boss.cast(self, 60)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
						task._Wait(60)
					end
				end)
				ia, im = -ia, -im
				rla = rla + _d_rla
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				xy.x, xy.y = self.x, self.y
				task._Wait(1)
			end
		end
	end)
end
local function normal2_init_Marisa_N(self)
	local im = -SB_SEASON_NMSL
	local i = ran:Sign()
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 255, 255, 32, 32, 32, 255, 255 }, { 32, 32, 32, 255, 255, 255, 160 }, { 32, 255, 255, 255, 32, 32, 32 }, { 1, 3, 5, 7, 9, 11, 13 }
	local xy = { x = self.x, y = self.y }
	lasttask = task.New(self, function()
		task.MoveTo(-64 * im, 112, 60, MOVE_DECEL)
		task._Wait(30)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 56)
		task._Wait(30)
		local ia = -i
		do
			local rla, _d_rla = (0), (-360 / 4)
			for _ = 1, _infinite do
				local tim = 60
				PlaySound("option", 0.1, 0, false)
				do
					local sa, _d_sa = (ran:Float(0, 360)), (360 / 4 * ia)
					local la, _d_la = (rla * i), (360 / 4 * i)
					for _ = 1, 4 do
						last = New(_editor_class["stage_3_boss_marisa_NoSpell2_circle"], self.x, self.y, 2, ia, 90, sa, 4, circle_redarray[3], circle_greenarray[3], circle_bluearray[3], circle_bullet_clarray[3], la, xy)
						_connect(self, last, 0, true)
						sa = sa + _d_sa
						la = la + _d_la
					end
				end
				task._Wait(60)
				do
					for _ = 1, 4 do
						task._Wait(60)
						task.MoveToPlayer(60, -64 * im, -64 * im - 64 * im, 100, 124, 16, 48, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
					end
				end
				task._Wait(30)
				task.MoveTo(64 * im, 112, 60, MOVE_DECEL)
				task._Wait(30)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 56)
				end)
				ia, im = -ia, -im
				rla = rla + _d_rla
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				xy.x, xy.y = self.x, self.y
				task._Wait(1)
			end
		end
	end)
end
local function normal2_init_Marisa_H(self)
	local im = -SB_SEASON_NMSL
	local i = ran:Sign()
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 255, 255, 32, 32, 32, 255, 255 }, { 32, 32, 32, 255, 255, 255, 160 }, { 32, 255, 255, 255, 32, 32, 32 }, { 1, 3, 5, 7, 9, 11, 13 }
	local xy = { x = self.x, y = self.y }
	lasttask = task.New(self, function()
		task.MoveTo(-64 * im, 112, 60, MOVE_DECEL)
		task._Wait(30)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 56)
		task._Wait(30)
		local ia = -i
		do
			local rla, _d_rla = (0), (-360 / 4)
			for _ = 1, _infinite do
				local tim = 60
				PlaySound("option", 0.1, 0, false)
				do
					local sa, _d_sa = (ran:Float(0, 360)), (360 / 4 * ia)
					local la, _d_la = (rla * i), (360 / 4 * i)
					for _ = 1, 4 do
						last = New(_editor_class["stage_3_boss_marisa_NoSpell2_circle"], self.x, self.y, 3, ia, 90, sa, 4, circle_redarray[3], circle_greenarray[3], circle_bluearray[3], circle_bullet_clarray[3], la, xy)
						_connect(self, last, 0, true)
						sa = sa + _d_sa
						la = la + _d_la
					end
				end
				task._Wait(60)
				do
					for _ = 1, 4 do
						task._Wait(60)
						task.MoveToPlayer(60, -64 * im, -64 * im - 64 * im, 100, 124, 16, 48, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
					end
				end
				task._Wait(30)
				task.MoveTo(64 * im, 112, 60, MOVE_DECEL)
				task._Wait(30)
				boss.cast(self, 60)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 56)
				end)
				ia, im = -ia, -im
				rla = rla + _d_rla
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				xy.x, xy.y = self.x, self.y
				task._Wait(1)
			end
		end
	end)
end
local function normal2_init_Marisa_L(self)
	local im = -SB_SEASON_NMSL
	local i = ran:Sign()
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 255, 255, 32, 32, 32, 255, 255 }, { 32, 32, 32, 255, 255, 255, 160 }, { 32, 255, 255, 255, 32, 32, 32 }, { 1, 3, 5, 7, 9, 11, 13 }
	local xy = { x = self.x, y = self.y }
	lasttask = task.New(self, function()
		task.MoveTo(-64 * im, 112, 60, MOVE_DECEL)
		task._Wait(30)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 56)
		task._Wait(30)
		local ia = -i
		do
			local rla, _d_rla = (0), (-360 / 4)
			for _ = 1, _infinite do
				local tim = 60
				PlaySound("option", 0.1, 0, false)
				do
					local sa, _d_sa = (ran:Float(0, 360)), (360 / 4 * ia)
					local la, _d_la = (rla * i), (360 / 4 * i)
					for _ = 1, 4 do
						last = New(_editor_class["stage_3_boss_marisa_NoSpell2_circle"], self.x, self.y, 4, ia, 90, sa, 4, circle_redarray[3], circle_greenarray[3], circle_bluearray[3], circle_bullet_clarray[3], la, xy)
						_connect(self, last, 0, true)
						sa = sa + _d_sa
						la = la + _d_la
					end
				end
				task._Wait(60)
				do
					for _ = 1, 4 do
						task._Wait(60)
						task.MoveToPlayer(60, -64 * im, -64 * im - 64 * im, 100, 124, 16, 48, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
					end
				end
				task._Wait(30)
				task.MoveTo(64 * im, 112, 60, MOVE_DECEL)
				task._Wait(30)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 56)
				end)
				ia, im = -ia, -im
				rla = rla + _d_rla
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				xy.x, xy.y = self.x, self.y
				task._Wait(1)
			end
		end
	end)
end
local function normal2_init_Yuyuko_E(self)
	local im = -SB_SEASON_NMSL
	local i = 1
	local bullet_clarray = { 1, 13, 11, 9, 7, 5, 3, 15 }
	lasttask = task.New(self, function()
		task.MoveTo(64 * im, 112, 60, MOVE_DECEL)
		task._Wait(30)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		local ia = i
		local way, sp = 1, 0
		do
			for _ = 1, _infinite do
				lasttask = task.New(self, function()
					do
						for _ = 1, 7 do
							task.MoveToPlayer(60, 64 * im, 64 * im + 64 * im, 100, 124, 32, 64, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
							task._Wait(20)
						end
					end
					task._Wait(20)
					task.MoveTo(-64 * im, 112, 60, MOVE_DECEL)
					task._Wait(20)
				end)
				do
					for _ = 1, 7 do
						do
							for _ = 1, 4 do
								PlaySound("tan00", 0.1, 0, false)
								do
									local rsa, _d_rsa = (-sp / 2), (sp / (way - 1))
									for _ = 1, way do
										last = New(_straight, arrow_big, COLOR_DEEP_GRAY, self.x, self.y, 4, Angle(self, player) + rsa * ia, false, 0, true, true, 0, false, 0, 0, 0, false)
										lasttask = task.New(last, _editor_tasks["stage_3_boss_yuyuko_NoSpell2_bullettask"](ia, 4, Angle(self, player) + rsa * ia, rsa))
										rsa = rsa + _d_rsa
									end
								end
								task._Wait(5)
							end
						end
						task._Wait(60)
						way, sp = way + 1, sp + 240 / 6
					end
				end
				task._Wait(100)
				ia, im, way, sp = -ia, -im, 1, 0
			end
		end
	end)
end
local function normal2_init_Yuyuko_N(self)
	local im = -SB_SEASON_NMSL
	local i = 1
	local bullet_clarray = { 2, 14, 12, 10, 8, 6, 4, 16 }
	lasttask = task.New(self, function()
		task.MoveTo(64 * im, 112, 60, MOVE_DECEL)
		task._Wait(30)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		local ia = i
		local way, sp, n = 1, 0, 1
		do
			for _ = 1, _infinite do
				lasttask = task.New(self, function()
					do
						for _ = 1, 8 do
							task.MoveToPlayer(60, 64 * im, 64 * im + 64 * im, 100, 124, 32, 64, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
							task._Wait(10)
						end
					end
					task._Wait(20)
					task.MoveTo(-64 * im, 112, 60, MOVE_DECEL)
					task._Wait(20)
				end)
				do
					for _ = 1, 8 do
						do
							for _ = 1, 6 do
								PlaySound("tan00", 0.1, 0, false)
								do
									local rsa, _d_rsa = (-sp / 2), (sp / (way - 1))
									for _ = 1, way do
										last = New(_straight, arrow_big, bullet_clarray[n], self.x, self.y, 4, Angle(self, player) + rsa * ia, false, 0, true, true, 0, false, 0, 0, 0, false)
										lasttask = task.New(last, _editor_tasks["stage_3_boss_yuyuko_NoSpell2_bullettask"](ia, 4, Angle(self, player) + rsa * ia, rsa))
										rsa = rsa + _d_rsa
									end
								end
								task._Wait(5)
							end
						end
						task._Wait(40)
						way, sp, n = way + 1, sp + 240 / 7, n + 1
					end
				end
				task._Wait(100)
				ia, im, way, sp, n = -ia, -im, 1, 0, 1
			end
		end
	end)
end
local function normal2_init_Yuyuko_H(self)
	local im = -SB_SEASON_NMSL
	local i = 1
	local bullet_clarray = { 2, 14, 12, 10, 8, 6, 4, 16 }
	lasttask = task.New(self, function()
		task.MoveTo(64 * im, 112, 60, MOVE_DECEL)
		task._Wait(30)
		lasttask = task.New(self, function()
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(60)
			end
			self._wisys:setAction("cast", 64)
		end)
		task._Wait(100)
		local ia = i
		local way, sp, n = 1, 0, 1
		do
			for _ = 1, _infinite do
				lasttask = task.New(self, function()
					do
						for _ = 1, 8 do
							task.MoveToPlayer(60, 64 * im, 64 * im + 64 * im, 100, 124, 32, 64, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
							task._Wait(10)
						end
					end
					task._Wait(20)
					task.MoveTo(-64 * im, 112, 60, MOVE_DECEL)
					task._Wait(20)
				end)
				do
					for _ = 1, 8 do
						do
							for _ = 1, 10 do
								PlaySound("tan00", 0.1, 0, false)
								do
									local rsa, _d_rsa = (-sp / 2), (sp / (way - 1))
									for _ = 1, way do
										last = New(_straight, arrow_big, bullet_clarray[n], self.x, self.y, 4, Angle(self, player) + rsa * ia, false, 0, true, true, 0, false, 0, 0, 0, false)
										lasttask = task.New(last, _editor_tasks["stage_3_boss_yuyuko_NoSpell2_bullettask"](ia, 4, Angle(self, player) + rsa * ia, rsa))
										rsa = rsa + _d_rsa
									end
								end
								task._Wait(5)
							end
						end
						way, sp, n = way + 1, sp + 240 / 7, n + 1
						task._Wait(20)
					end
				end
				task._Wait(100)
				ia, im, way, sp, n = -ia, -im, 1, 0, 1
			end
		end
	end)
end
local function normal2_init_Yuyuko_L(self)
	local im = -SB_SEASON_NMSL
	local i = 1
	local bullet_clarray = { 2, 14, 12, 10, 8, 6, 4, 16 }
	lasttask = task.New(self, function()
		task.MoveTo(64 * im, 112, 60, MOVE_DECEL)
		task._Wait(30)
		self._wisys:setAction("cast", 64)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
			task._Wait(60)
		end
		task._Wait(30)
		local ia = i
		local way, sp, n = 1, 0, 1
		do
			for _ = 1, _infinite do
				lasttask = task.New(self, function()
					do
						for _ = 1, 8 do
							task.MoveToPlayer(60, 64 * im, 64 * im + 64 * im, 100, 124, 32, 64, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
							task._Wait(10)
						end
					end
					task._Wait(20)
					task.MoveTo(-64 * im, 112, 60, MOVE_DECEL)
					task._Wait(20)
				end)
				do
					for _ = 1, 8 do
						do
							for _ = 1, 10 do
								PlaySound("tan00", 0.1, 0, false)
								do
									local rsa, _d_rsa = (-sp / 2), (sp / (way - 1))
									for _ = 1, way do
										last = New(_straight, arrow_big, bullet_clarray[n], self.x, self.y, 4, Angle(self, player) + rsa * ia, false, 0, true, true, 0, false, 0, 0, 0, false)
										lasttask = task.New(last, _editor_tasks["stage_3_boss_yuyuko_NoSpell2_bullettask"](ia, 4, Angle(self, player) + rsa * ia, rsa))
										rsa = rsa + _d_rsa
									end
								end
								task._Wait(5)
							end
						end
						task._Wait(20)
						way, sp, n = way + 2, sp + 240 / 7, n + 1
					end
				end
				task._Wait(100)
				ia, im, way, sp, n = -ia, -im, 1, 0, 1
			end
		end
	end)
end
local normal2_init = create_diff_function(
		{normal2_init_Marisa_E, normal2_init_Marisa_N, normal2_init_Marisa_H, normal2_init_Marisa_L},
		{normal2_init_Yuyuko_E, normal2_init_Yuyuko_N, normal2_init_Yuyuko_H, normal2_init_Yuyuko_L},
		true)
local normal2_del = create_diff_function(
		{false, false, false, false},
		{false, false, false, false},
		false)
--endregion

--region card 2
local function card2_init_Marisa_E(self)
	local im = 1
	local i = ran:Sign()
	lasttask = task.New(self, function()
		task.MoveTo(0, 64, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			s3C_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
				task._Wait(60)
			end
			self._wisys:setAction("cast", 56)
		end
		lasttask = task.New(self, function()
			local ia = i
			do
				local si, _d_si = (0), (360 / 1439)
				for _ = 1, _infinite do
					lasttask = task.New(self, function()
						local ia0, sv = ia, 1
						do
							local rsa, _d_rsa = (0), (360 / 1.5 / 2 * ia)
							for _ = 1, 4 do
								PlaySound("water", 0.1, 0, false)
								do
									local sa, _d_sa = (Angle(self, player) + rsa), (360 / 2 * ia)
									for _ = 1, 2 do
										last = New(_editor_class["stage_3_boss_marisa_Spell2_star1"], self.x, self.y, 2, ia, ia0, sv, sa)
										sa = sa + _d_sa
									end
								end
								task._Wait(30)
								ia0, sv = -ia0, sv + 4 / 3
								rsa = rsa + _d_rsa
							end
						end
					end)
					task._Wait(480)
					task.MoveToPlayer(60, -96, 96, 48, 80, 16, 96, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
					task._Wait(30)
					lasttask = task.New(self, function()
						do
							task._Wait(10)
							New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
							task._Wait(60)
						end
						self._wisys:setAction("cast", 56)
					end)
					task._Wait(30)
					ia = -ia
					si = si + _d_si
				end
			end
		end)
	end)
end
local function card2_init_Marisa_N(self)
	local im = 1
	local i = ran:Sign()
	lasttask = task.New(self, function()
		task.MoveTo(0, 64, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			s3C_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 56)
		lasttask = task.New(self, function()
			local ia = i
			do
				local si, _d_si = (0), (360 / 1439)
				for _ = 1, _infinite do
					lasttask = task.New(self, function()
						local ia0, sv = ia, 1
						do
							local rsa, _d_rsa = (0), (360 / 2.5 / 2 * ia)
							for _ = 1, 6 do
								PlaySound("water", 0.1, 0, false)
								do
									local sa, _d_sa = (Angle(self, player) + rsa), (360 / 2 * ia)
									for _ = 1, 2 do
										last = New(_editor_class["stage_3_boss_marisa_Spell2_star1"], self.x, self.y, 2, ia, ia0, sv, sa)
										sa = sa + _d_sa
									end
								end
								task._Wait(20)
								ia0, sv = -ia0, sv + 4 / 5
								rsa = rsa + _d_rsa
							end
						end
					end)
					task._Wait(480)
					task.MoveToPlayer(60, -96, 96, 48, 80, 16, 96, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
					task._Wait(30)
					lasttask = task.New(self, function()
						do
							task._Wait(10)
							New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
							task._Wait(60)
						end
						self._wisys:setAction("cast", 56)
					end)
					task._Wait(30)
					ia = -ia
					si = si + _d_si
				end
			end
		end)
	end)
end
local function card2_init_Marisa_H(self)
	local im = 1
	local i = ran:Sign()
	lasttask = task.New(self, function()
		task.MoveTo(0, 64, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			s3C_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 56)
		lasttask = task.New(self, function()
			local ia = i
			do
				for _ = 1, _infinite do
					last = New(_editor_class["stage_3_boss_marisa_Spell2_star1_HL"], self.x, self.y, 3, ia, ia, ia, 0, ran:Float(0, 360))
					task._Wait(1050)
					lasttask = task.New(self, function()
						do
							task._Wait(10)
							New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
							task._Wait(60)
						end
						self._wisys:setAction("cast", 56)
					end)
					task._Wait(30)
					ia = -ia
				end
			end
		end)
	end)
end
local function card2_init_Marisa_L(self)
	local im = 1
	local i = ran:Sign()
	lasttask = task.New(self, function()
		task.MoveTo(0, 64, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			s3C_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 56)
		lasttask = task.New(self, function()
			local ia = i
			do
				for _ = 1, _infinite do
					local ia0, im0, sa = ia, im, ran:Float(0, 360)
					do
						for _ = 1, 2 do
							last = New(_editor_class["stage_3_boss_marisa_Spell2_star1_HL"], self.x, self.y, 4, ia, ia0, im0, 0, sa)
							ia0, im0 = -ia0, -im0
							sa = 180 - sa
						end
					end
					task._Wait(1050)
					lasttask = task.New(self, function()
						do
							task._Wait(10)
							New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
							task._Wait(60)
						end
						self._wisys:setAction("cast", 56)
					end)
					task._Wait(30)
					ia = -ia
				end
			end
		end)
	end)
end
local function card2_init_Yuyuko_E(self)
	local im = -1
	local i = 1
	lasttask = task.New(self, function()
		task.MoveTo(0, 0, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(60)
			end
		end
		task._Wait(240)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		local ia = i
		do
			for _ = 1, _infinite do
				last = New(_editor_class["stage_3_boss_yuyuko_Spell2_starbutterfly"], self.x, self.y, 1, ia, Angle(self, player), player.x / 2, player.y / 2, 1)
				task._Wait(600)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 64)
				end)
				ia = -ia
			end
		end
	end)
end
local function card2_init_Yuyuko_N(self)
	local im = -1
	local i = 1
	lasttask = task.New(self, function()
		task.MoveTo(0, 0, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 64)
		task._Wait(240)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		local ia = i
		do
			for _ = 1, _infinite do
				last = New(_editor_class["stage_3_boss_yuyuko_Spell2_starbutterfly"], self.x, self.y, 2, ia, Angle(self, player), player.x / 2, player.y / 2, 1.5)
				task._Wait(600)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 64)
				end)
				ia = -ia
			end
		end
	end)
end
local function card2_init_Yuyuko_H(self)
	local im = -1
	local i = 1
	lasttask = task.New(self, function()
		task.MoveTo(0, 0, 60, MOVE_NORMAL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 64)
		task._Wait(720)
		lasttask = task.New(self, function()
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(60)
			end
			self._wisys:setAction("cast", 64)
		end)
		local ia = i
		do
			for _ = 1, _infinite do
				do
					local sr, _d_sr = (60), (120 / 5)
					local sa, _d_sa = (Angle(self, player) - 180 * ia - 75 * ia), (150 * ia / 2)
					for _ = 1, 3 do
						last = New(_editor_class["stage_3_boss_yuyuko_Spell2_starbutterfly"], self.x, self.y, 4, ia, sa, self.x + sr * cos(sa), self.y + sr * sin(sa), 0.75)
						sr = sr + _d_sr
						sa = sa + _d_sa
					end
				end
				task._Wait(1080)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 64)
				end)
				ia = -ia
			end
		end
	end)
end
local function card2_init_Yuyuko_L(self)
	local im = -1
	local i = 1
	lasttask = task.New(self, function()
		task.MoveTo(0, 0, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(60)
			end
			self._wisys:setAction("cast", 64)
		end
		task._Wait(720)
		lasttask = task.New(self, function()
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(60)
			end
			self._wisys:setAction("cast", 64)
		end)
		local ia = i
		do
			for _ = 1, _infinite do
				do
					local sr, _d_sr = (60), (180 / 5)
					local sa, _d_sa = (Angle(self, player) - 180 * ia - 120 * ia), (240 * ia / 4)
					for _ = 1, 5 do
						last = New(_editor_class["stage_3_boss_yuyuko_Spell2_starbutterfly"], self.x, self.y, 4, ia, sa, self.x + sr * cos(sa), self.y + sr * sin(sa), 1)
						sr = sr + _d_sr
						sa = sa + _d_sa
					end
				end
				task._Wait(1080)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 64)
				end)
				ia = -ia
			end
		end
	end)
end
local function card2_del_Marisa_ENHL(self)
	Spell_break_eff(self.x, self.y, 255, 255, 0,
			'marisa_star', 'yuyuko_ghost')
end
local function card2_del_Yuyuko_ENHL(self)
	Spell_break_eff(self.x, self.y, 255, 50, 255,
			'marisa_star', 'yuyuko_ghost')
end
local card2_init = create_diff_function(
		{card2_init_Marisa_E, card2_init_Marisa_N, card2_init_Marisa_H, card2_init_Marisa_L},
		{card2_init_Yuyuko_E, card2_init_Yuyuko_N, card2_init_Yuyuko_H, card2_init_Yuyuko_L},
		true,
		{
			{cardname.card2.marisa.EN, cardname.card2.yuyuko.EN},
			{cardname.card2.marisa.EN, cardname.card2.yuyuko.EN},
			{cardname.card2.marisa.HL, cardname.card2.yuyuko.HL},
			{cardname.card2.marisa.HL, cardname.card2.yuyuko.HL},
		})
local card2_del = create_diff_function(
		{card2_del_Marisa_ENHL, card2_del_Marisa_ENHL, card2_del_Marisa_ENHL, card2_del_Marisa_ENHL},
		{card2_del_Yuyuko_ENHL, card2_del_Yuyuko_ENHL, card2_del_Yuyuko_ENHL, card2_del_Yuyuko_ENHL},
		false)
--endregion

--region normal 3
local function normal3_init_Marisa_E(self)
	local i = SB_SEASON_NMSL
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 255, 255, 32, 32, 32, 255, 255 }, { 32, 32, 32, 255, 255, 255, 160 }, { 32, 255, 255, 255, 32, 32, 32 }, { 1, 3, 5, 7, 9, 11, 13 }
	local xy = { x = self.x, y = self.y }
	lasttask = task.New(self, function()
		task.MoveTo(-96 * i, 112, 60, MOVE_DECEL)
		task._Wait(30)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 56)
		task._Wait(30)
		local ia = i
		local sa = 90 + 90 * i
		self.ra = 0
		do
			for _ = 1, _infinite do
				local ia0 = ia
				PlaySound("option", 0.1, 0, false)
				do
					local sa, _d_sa = (ran:Float(0, 360)), (180 / 2 * ia)
					local sr, _d_sr = (70), (40)
					for _ = 1, 2 do
						do
							local a, _d_a = (sa), (360 / 2 * ia0)
							for _ = 1, 2 do
								last = New(_editor_class["stage_3_boss_marisa_NoSpell3_circle"], self.x, self.y, 1, ia0, sr, a, 4, circle_redarray[5], circle_greenarray[5], circle_bluearray[5], circle_bullet_clarray[5], 0, xy)
								_connect(self, last, 0, true)
								a = a + _d_a
							end
						end
						ia0 = -ia0
						sa = sa + _d_sa
						sr = sr + _d_sr
					end
				end
				task._Wait(120)
				lasttask = task.New(self, function()
					ex.SmoothSetValueTo("ra", 540, 480, MOVE_ACC_DEC, nil, 0, MODE_SET)
				end)
				do
					for _ = 1, 480 do
						self.x, self.y = 0 + 96 * cos(sa), 112 + 32 * sin(sa)
						sa = 90 + 90 * i + self.ra * i
						task._Wait(1)
					end
				end
				task._Wait(90)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 56)
				end)
				task._Wait(30)
				ia0 = -ia
				PlaySound("option", 0.1, 0, false)
				do
					local sa, _d_sa = (ran:Float(0, 360)), (180 / 2 * ia)
					local sr, _d_sr = (70), (40)
					for _ = 1, 2 do
						do
							local a, _d_a = (sa), (360 / 2 * ia0)
							for _ = 1, 2 do
								last = New(_editor_class["stage_3_boss_marisa_NoSpell3_circle"], self.x, self.y, 1, ia0, sr, a, 4, circle_redarray[5], circle_greenarray[5], circle_bluearray[5], circle_bullet_clarray[5], 0, xy)
								_connect(self, last, 0, true)
								a = a + _d_a
							end
						end
						ia0 = -ia0
						sa = sa + _d_sa
						sr = sr + _d_sr
					end
				end
				task._Wait(120)
				lasttask = task.New(self, function()
					ex.SmoothSetValueTo("ra", 0, 480, MOVE_ACC_DEC, nil, 0, MODE_SET)
				end)
				do
					for _ = 1, 480 do
						self.x, self.y = 0 + 96 * cos(sa), 112 + 32 * sin(sa)
						sa = 90 + 90 * i + self.ra * i
						task._Wait(1)
					end
				end
				task._Wait(90)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 56)
				end)
				task._Wait(30)
				ia = -ia
			end
		end
	end)
end
local function normal3_init_Marisa_N(self)
	local i = SB_SEASON_NMSL
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 255, 255, 32, 32, 32, 255, 255 }, { 32, 32, 32, 255, 255, 255, 160 }, { 32, 255, 255, 255, 32, 32, 32 }, { 1, 3, 5, 7, 9, 11, 13 }
	local xy = { x = self.x, y = self.y }
	lasttask = task.New(self, function()
		task.MoveTo(-96 * i, 112, 60, MOVE_DECEL)
		task._Wait(30)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 56)
		task._Wait(30)
		local ia = i
		local sa = 90 + 90 * i
		self.ra = 0
		do
			for _ = 1, _infinite do
				local ia0 = ia
				PlaySound("option", 0.1, 0, false)
				do
					local sa, _d_sa = (ran:Float(0, 360)), (180 / 2 * ia)
					local sr, _d_sr = (70), (40)
					for _ = 1, 2 do
						do
							local a, _d_a = (sa), (360 / 2 * ia0)
							for _ = 1, 2 do
								last = New(_editor_class["stage_3_boss_marisa_NoSpell3_circle"], self.x, self.y, 2, ia0, sr, a, 4, circle_redarray[5], circle_greenarray[5], circle_bluearray[5], circle_bullet_clarray[5], 0, xy)
								_connect(self, last, 0, true)
								a = a + _d_a
							end
						end
						ia0 = -ia0
						sa = sa + _d_sa
						sr = sr + _d_sr
					end
				end
				task._Wait(120)
				lasttask = task.New(self, function()
					ex.SmoothSetValueTo("ra", 540, 480, MOVE_ACC_DEC, nil, 0, MODE_SET)
				end)
				do
					for _ = 1, 480 do
						self.x, self.y = 0 + 96 * cos(sa), 112 + 32 * sin(sa)
						sa = 90 + 90 * i + self.ra * i
						task._Wait(1)
					end
				end
				task._Wait(90)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 56)
				end)
				task._Wait(30)
				ia0 = -ia
				PlaySound("option", 0.1, 0, false)
				do
					local sa, _d_sa = (ran:Float(0, 360)), (180 / 2 * ia)
					local sr, _d_sr = (70), (40)
					for _ = 1, 2 do
						do
							local a, _d_a = (sa), (360 / 2 * ia0)
							for _ = 1, 2 do
								last = New(_editor_class["stage_3_boss_marisa_NoSpell3_circle"], self.x, self.y, 2, ia0, sr, a, 4, circle_redarray[5], circle_greenarray[5], circle_bluearray[5], circle_bullet_clarray[5], 0, xy)
								_connect(self, last, 0, true)
								a = a + _d_a
							end
						end
						ia0 = -ia0
						sa = sa + _d_sa
						sr = sr + _d_sr
					end
				end
				task._Wait(120)
				lasttask = task.New(self, function()
					ex.SmoothSetValueTo("ra", 0, 480, MOVE_ACC_DEC, nil, 0, MODE_SET)
				end)
				do
					for _ = 1, 480 do
						self.x, self.y = 0 + 96 * cos(sa), 112 + 32 * sin(sa)
						sa = 90 + 90 * i + self.ra * i
						task._Wait(1)
					end
				end
				task._Wait(90)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 56)
				end)
				task._Wait(30)
				ia = -ia
			end
		end
	end)
end
local function normal3_init_Marisa_H(self)
	local i = SB_SEASON_NMSL
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 255, 255, 32, 32, 32, 255, 255 }, { 32, 32, 32, 255, 255, 255, 160 }, { 32, 255, 255, 255, 32, 32, 32 }, { 1, 3, 5, 7, 9, 11, 13 }
	local xy = { x = self.x, y = self.y }
	lasttask = task.New(self, function()
		task.MoveTo(-96 * i, 112, 60, MOVE_DECEL)
		task._Wait(30)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 56)
		task._Wait(30)
		local ia = i
		local sa = 90 + 90 * i
		self.ra = 0
		do
			for _ = 1, _infinite do
				local ia0 = ia
				PlaySound("option", 0.1, 0, false)
				do
					local sa, _d_sa = (ran:Float(0, 360)), (180 / 2 * ia)
					local sr, _d_sr = (70), (40)
					for _ = 1, 2 do
						do
							local a, _d_a = (sa), (360 / 2 * ia0)
							for _ = 1, 2 do
								last = New(_editor_class["stage_3_boss_marisa_NoSpell3_circle"], self.x, self.y, 3, ia0, sr, a, 4, circle_redarray[5], circle_greenarray[5], circle_bluearray[5], circle_bullet_clarray[5], 0, xy)
								_connect(self, last, 0, true)
								a = a + _d_a
							end
						end
						ia0 = -ia0
						sa = sa + _d_sa
						sr = sr + _d_sr
					end
				end
				task._Wait(120)
				lasttask = task.New(self, function()
					ex.SmoothSetValueTo("ra", 540, 480, MOVE_ACC_DEC, nil, 0, MODE_SET)
				end)
				do
					for _ = 1, 480 do
						self.x, self.y = 0 + 96 * cos(sa), 112 + 32 * sin(sa)
						sa = 90 + 90 * i + self.ra * i
						task._Wait(1)
					end
				end
				task._Wait(90)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 56)
				end)
				task._Wait(30)
				ia0 = -ia
				PlaySound("option", 0.1, 0, false)
				do
					local sa, _d_sa = (ran:Float(0, 360)), (180 / 2 * ia)
					local sr, _d_sr = (70), (40)
					for _ = 1, 2 do
						do
							local a, _d_a = (sa), (360 / 2 * ia0)
							for _ = 1, 2 do
								last = New(_editor_class["stage_3_boss_marisa_NoSpell3_circle"], self.x, self.y, 3, ia0, sr, a, 4, circle_redarray[5], circle_greenarray[5], circle_bluearray[5], circle_bullet_clarray[5], 0, xy)
								_connect(self, last, 0, true)
								a = a + _d_a
							end
						end
						ia0 = -ia0
						sa = sa + _d_sa
						sr = sr + _d_sr
					end
				end
				task._Wait(120)
				lasttask = task.New(self, function()
					ex.SmoothSetValueTo("ra", 0, 480, MOVE_ACC_DEC, nil, 0, MODE_SET)
				end)
				do
					for _ = 1, 480 do
						self.x, self.y = 0 + 96 * cos(sa), 112 + 32 * sin(sa)
						sa = 90 + 90 * i + self.ra * i
						task._Wait(1)
					end
				end
				task._Wait(90)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 56)
				end)
				task._Wait(30)
				ia = -ia
			end
		end
	end)
end
local function normal3_init_Marisa_L(self)
	local i = SB_SEASON_NMSL
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 255, 255, 32, 32, 32, 255, 255 }, { 32, 32, 32, 255, 255, 255, 160 }, { 32, 255, 255, 255, 32, 32, 32 }, { 1, 3, 5, 7, 9, 11, 13 }
	local xy = { x = self.x, y = self.y }
	lasttask = task.New(self, function()
		task.MoveTo(-96 * i, 112, 60, MOVE_DECEL)
		task._Wait(30)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 56)
		task._Wait(30)
		local ia = i
		local sa = 90 + 90 * i
		self.ra = 0
		do
			for _ = 1, _infinite do
				local ia0 = ia
				PlaySound("option", 0.1, 0, false)
				do
					local sa, _d_sa = (ran:Float(0, 360)), (180 / 2 * ia)
					local sr, _d_sr = (70), (40)
					for _ = 1, 2 do
						do
							local a, _d_a = (sa), (360 / 2 * ia0)
							for _ = 1, 2 do
								last = New(_editor_class["stage_3_boss_marisa_NoSpell3_circle"], self.x, self.y, 4, ia0, sr, a, 4, circle_redarray[5], circle_greenarray[5], circle_bluearray[5], circle_bullet_clarray[5], 0, xy)
								_connect(self, last, 0, true)
								a = a + _d_a
							end
						end
						ia0 = -ia0
						sa = sa + _d_sa
						sr = sr + _d_sr
					end
				end
				task._Wait(120)
				lasttask = task.New(self, function()
					ex.SmoothSetValueTo("ra", 540, 480, MOVE_ACC_DEC, nil, 0, MODE_SET)
				end)
				do
					for _ = 1, 480 do
						self.x, self.y = 0 + 96 * cos(sa), 112 + 32 * sin(sa)
						sa = 90 + 90 * i + self.ra * i
						task._Wait(1)
					end
				end
				task._Wait(90)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 56)
				end)
				task._Wait(30)
				ia0 = -ia
				PlaySound("option", 0.1, 0, false)
				do
					local sa, _d_sa = (ran:Float(0, 360)), (180 / 2 * ia)
					local sr, _d_sr = (70), (40)
					for _ = 1, 2 do
						do
							local a, _d_a = (sa), (360 / 2 * ia0)
							for _ = 1, 2 do
								last = New(_editor_class["stage_3_boss_marisa_NoSpell3_circle"], self.x, self.y, 4, ia0, sr, a, 4, circle_redarray[5], circle_greenarray[5], circle_bluearray[5], circle_bullet_clarray[5], 0, xy)
								_connect(self, last, 0, true)
								a = a + _d_a
							end
						end
						ia0 = -ia0
						sa = sa + _d_sa
						sr = sr + _d_sr
					end
				end
				task._Wait(120)
				lasttask = task.New(self, function()
					ex.SmoothSetValueTo("ra", 0, 480, MOVE_ACC_DEC, nil, 0, MODE_SET)
				end)
				do
					for _ = 1, 480 do
						self.x, self.y = 0 + 96 * cos(sa), 112 + 32 * sin(sa)
						sa = 90 + 90 * i + self.ra * i
						task._Wait(1)
					end
				end
				task._Wait(90)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 56)
				end)
				task._Wait(30)
				ia = -ia
			end
		end
	end)
end
local function normal3_init_Yuyuko_E(self)
	local i = SB_SEASON_NMSL
	lasttask = task.New(self, function()
		task.MoveTo(96 * i, 112, 60, MOVE_DECEL)
		task._Wait(30)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		local ia = i
		local sa = 90 - 90 * i
		self.ra = 0
		do
			for _ = 1, _infinite do
				do
					local sa, _d_sa = (90 - 90 * i), (-360 * i / 2)
					for _ = 1, 2 do
						last = New(_editor_class["stage_3_boss_yuyuko_NoSpell3_all"], self.x, self.y, 1, -i, sa)
						_connect(self, last, 0, true)
						sa = sa + _d_sa
					end
				end
				task._Wait(120)
				lasttask = task.New(self, function()
					ex.SmoothSetValueTo("ra", 540, 480, MOVE_ACC_DEC, nil, 0, MODE_SET)
				end)
				self._wisys:setAction("cast2", 480)
				do
					for _ = 1, 480 do
						self.x, self.y = 0 + 96 * cos(sa), 112 + 32 * sin(sa)
						sa = 90 - 90 * i + self.ra * i
						task._Wait(1)
					end
				end
				task._Wait(90)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 64)
				end)
				task._Wait(30)
				do
					local sa, _d_sa = (90 - 90 * i), (360 * i / 2)
					for _ = 1, 2 do
						last = New(_editor_class["stage_3_boss_yuyuko_NoSpell3_all"], self.x, self.y, 1, i, sa)
						_connect(self, last, 0, true)
						sa = sa + _d_sa
					end
				end
				task._Wait(120)
				lasttask = task.New(self, function()
					ex.SmoothSetValueTo("ra", 0, 480, MOVE_ACC_DEC, nil, 0, MODE_SET)
				end)
				self._wisys:setAction("cast2", 480)
				do
					for _ = 1, 480 do
						self.x, self.y = 0 + 96 * cos(sa), 112 + 32 * sin(sa)
						sa = 90 - 90 * i + self.ra * i
						task._Wait(1)
					end
				end
				task._Wait(90)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 64)
				end)
				task._Wait(30)
				ia = -ia
			end
		end
	end)
end
local function normal3_init_Yuyuko_N(self)
	local i = SB_SEASON_NMSL
	lasttask = task.New(self, function()
		task.MoveTo(96 * i, 112, 60, MOVE_DECEL)
		task._Wait(30)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		local ia = i
		local sa = 90 - 90 * i
		self.ra = 0
		do
			for _ = 1, _infinite do
				do
					local sa, _d_sa = (90 - 90 * i), (-360 * i / 2)
					for _ = 1, 2 do
						last = New(_editor_class["stage_3_boss_yuyuko_NoSpell3_all"], self.x, self.y, 2, -i, sa)
						_connect(self, last, 0, true)
						sa = sa + _d_sa
					end
				end
				task._Wait(120)
				lasttask = task.New(self, function()
					ex.SmoothSetValueTo("ra", 540, 480, MOVE_ACC_DEC, nil, 0, MODE_SET)
				end)
				self._wisys:setAction("cast2", 480)
				do
					for _ = 1, 480 do
						self.x, self.y = 0 + 96 * cos(sa), 112 + 32 * sin(sa)
						sa = 90 - 90 * i + self.ra * i
						task._Wait(1)
					end
				end
				task._Wait(90)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 64)
				end)
				task._Wait(30)
				do
					local sa, _d_sa = (90 - 90 * i), (360 * i / 2)
					for _ = 1, 2 do
						last = New(_editor_class["stage_3_boss_yuyuko_NoSpell3_all"], self.x, self.y, 2, i, sa)
						_connect(self, last, 0, true)
						sa = sa + _d_sa
					end
				end
				task._Wait(120)
				lasttask = task.New(self, function()
					ex.SmoothSetValueTo("ra", 0, 480, MOVE_ACC_DEC, nil, 0, MODE_SET)
				end)
				self._wisys:setAction("cast2", 480)
				do
					for _ = 1, 480 do
						self.x, self.y = 0 + 96 * cos(sa), 112 + 32 * sin(sa)
						sa = 90 - 90 * i + self.ra * i
						task._Wait(1)
					end
				end
				task._Wait(90)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 64)
				end)
				task._Wait(30)
				ia = -ia
			end
		end
	end)
end
local function normal3_init_Yuyuko_H(self)
	local i = SB_SEASON_NMSL
	lasttask = task.New(self, function()
		task.MoveTo(96 * i, 112, 60, MOVE_DECEL)
		task._Wait(30)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		local ia = i
		local sa = 90 - 90 * i
		self.ra = 0
		do
			for _ = 1, _infinite do
				do
					local sa, _d_sa = (90 - 90 * i), (-360 * i / 2)
					for _ = 1, 2 do
						last = New(_editor_class["stage_3_boss_yuyuko_NoSpell3_all"], self.x, self.y, 3, -i, sa)
						_connect(self, last, 0, true)
						sa = sa + _d_sa
					end
				end
				task._Wait(120)
				lasttask = task.New(self, function()
					ex.SmoothSetValueTo("ra", 540, 480, MOVE_ACC_DEC, nil, 0, MODE_SET)
				end)
				self._wisys:setAction("cast2", 480)
				do
					for _ = 1, 480 do
						self.x, self.y = 0 + 96 * cos(sa), 112 + 32 * sin(sa)
						sa = 90 - 90 * i + self.ra * i
						task._Wait(1)
					end
				end
				task._Wait(90)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 64)
				end)
				task._Wait(30)
				do
					local sa, _d_sa = (90 - 90 * i), (360 * i / 2)
					for _ = 1, 2 do
						last = New(_editor_class["stage_3_boss_yuyuko_NoSpell3_all"], self.x, self.y, 3, i, sa)
						_connect(self, last, 0, true)
						sa = sa + _d_sa
					end
				end
				task._Wait(120)
				lasttask = task.New(self, function()
					ex.SmoothSetValueTo("ra", 0, 480, MOVE_ACC_DEC, nil, 0, MODE_SET)
				end)
				self._wisys:setAction("cast2", 480)
				do
					for _ = 1, 480 do
						self.x, self.y = 0 + 96 * cos(sa), 112 + 32 * sin(sa)
						sa = 90 - 90 * i + self.ra * i
						task._Wait(1)
					end
				end
				task._Wait(90)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 64)
				end)
				task._Wait(30)
				ia = -ia
			end
		end
	end)
end
local function normal3_init_Yuyuko_L(self)
	local i = SB_SEASON_NMSL
	lasttask = task.New(self, function()
		task.MoveTo(96 * i, 112, 60, MOVE_DECEL)
		task._Wait(30)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		local ia = i
		local sa = 90 - 90 * i
		self.ra = 0
		do
			for _ = 1, _infinite do
				do
					local sa, _d_sa = (90 - 90 * i), (-360 * i / 2)
					for _ = 1, 2 do
						last = New(_editor_class["stage_3_boss_yuyuko_NoSpell3_all"], self.x, self.y, 4, -i, sa)
						_connect(self, last, 0, true)
						sa = sa + _d_sa
					end
				end
				task._Wait(120)
				lasttask = task.New(self, function()
					ex.SmoothSetValueTo("ra", 540, 480, MOVE_ACC_DEC, nil, 0, MODE_SET)
				end)
				self._wisys:setAction("cast2", 480)
				do
					for _ = 1, 480 do
						self.x, self.y = 0 + 96 * cos(sa), 112 + 32 * sin(sa)
						sa = 90 - 90 * i + self.ra * i
						task._Wait(1)
					end
				end
				task._Wait(90)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 64)
				end)
				task._Wait(30)
				do
					local sa, _d_sa = (90 - 90 * i), (360 * i / 2)
					for _ = 1, 2 do
						last = New(_editor_class["stage_3_boss_yuyuko_NoSpell3_all"], self.x, self.y, 4, i, sa)
						_connect(self, last, 0, true)
						sa = sa + _d_sa
					end
				end
				task._Wait(120)
				lasttask = task.New(self, function()
					ex.SmoothSetValueTo("ra", 0, 480, MOVE_ACC_DEC, nil, 0, MODE_SET)
				end)
				self._wisys:setAction("cast2", 480)
				do
					for _ = 1, 480 do
						self.x, self.y = 0 + 96 * cos(sa), 112 + 32 * sin(sa)
						sa = 90 - 90 * i + self.ra * i
						task._Wait(1)
					end
				end
				task._Wait(90)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 64)
				end)
				task._Wait(30)
				ia = -ia
			end
		end
	end)
end
local function normal3_del_Yuyuko_ENHL(self)
	self._wisys:setAction("normal",
			9999)
end
local normal3_init = create_diff_function(
		{normal3_init_Marisa_E, normal3_init_Marisa_N, normal3_init_Marisa_H, normal3_init_Marisa_L},
		{normal3_init_Yuyuko_E, normal3_init_Yuyuko_N, normal3_init_Yuyuko_H, normal3_init_Yuyuko_L},
		true)
local normal3_del = create_diff_function(
		{false, false, false, false},
		{normal3_del_Yuyuko_ENHL, normal3_del_Yuyuko_ENHL, normal3_del_Yuyuko_ENHL, normal3_del_Yuyuko_ENHL},
		false)
--endregion

--region card 3
local function card3_init_Marisa_E(self)
	local im = 1
	local i = 1
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 32, 255 }, { 255, 160 }, { 255, 255 }, { 7, 3 }
	lasttask = task.New(self, function()
		task.MoveTo(0, 0, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			s3C_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
				task._Wait(20)
			end
		end
		task._Wait(30)
		self._wisys:setAction("cast", 56)
		local ia = i
		local im0 = im
		PlaySound("boon01", 0.1, 0, false)
		do
			local sa, _d_sa = (ran:Float(0, 360)), (360 / 4 * i)
			for _ = 1, 4 do
				last = New(_editor_class["stage_3_boss_marisa_Spell3_obj1"], self.x, self.y, 1, i, i, im, sa, 4, 32, 255, 255, 7)
				_connect(self, last, 0, true)
				ia, im0 = -ia, -im0
				sa = sa + _d_sa
			end
		end
		task._Wait(510)
		do
			for _ = 1, _infinite do
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 56)
				end)
				task._Wait(720)
			end
		end
	end)
end
local function card3_init_Marisa_N(self)
	local im = 1
	local i = 1
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 32, 255 }, { 255, 160 }, { 255, 255 }, { 7, 3 }
	lasttask = task.New(self, function()
		task.MoveTo(0, 0, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			s3C_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
				task._Wait(20)
			end
		end
		self._wisys:setAction("cast", 56)
		task._Wait(30)
		local ia = i
		local im0 = im
		PlaySound("boon01", 0.1, 0, false)
		do
			local sa, _d_sa = (ran:Float(0, 360)), (360 / 6 * i)
			for _ = 1, 6 do
				last = New(_editor_class["stage_3_boss_marisa_Spell3_obj1"], self.x, self.y, 2, i, ia, im0, sa, 6, circle_redarray[1.5 + 0.5 * ia], circle_greenarray[1.5 + 0.5 * ia], circle_bluearray[1.5 + 0.5 * ia], circle_bullet_clarray[1.5 + 0.5 * ia])
				_connect(self, last, 0, true)
				ia, im0 = -ia, -im0
				sa = sa + _d_sa
			end
		end
		task._Wait(510)
		do
			for _ = 1, _infinite do
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 56)
				end)
				task._Wait(720)
			end
		end
	end)
end
local function card3_init_Marisa_H(self)
	local im = 1
	local i = 1
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 32, 255, 32, 255 }, { 255, 160, 255, 160 }, { 32, 32, 255, 192 }, { 9, 13, 7, 3 }
	lasttask = task.New(self, function()
		task.MoveTo(0, 0, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			s3C_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
				task._Wait(20)
			end
		end
		self._wisys:setAction("cast", 56)
		task._Wait(30)
		local ia = i
		local im0 = im
		local sa = ran:Float(0, 360)
		PlaySound("boon01", 0.1, 0, false)
		lasttask = task.New(self, function()
			do
				for _ = 1, 2 do
					do
						local a, _d_a = (sa), (360 / 4 * ia)
						local n, _d_n = (1), (1)
						for _ = 1, 4 do
							last = New(_editor_class["stage_3_boss_marisa_Spell3_obj1"], self.x, self.y, 3, ia, ia, im0, a, 6, circle_redarray[n], circle_greenarray[n], circle_bluearray[n], circle_bullet_clarray[n])
							_connect(self, last, 0, true)
							a = a + _d_a
							n = n + _d_n
						end
					end
					task._Wait(60)
					ia, im0 = -ia, -im0
				end
			end
		end)
		task._Wait(510)
		do
			for _ = 1, _infinite do
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 56)
				end)
				task._Wait(720)
			end
		end
	end)
end
local function card3_init_Marisa_L(self)
	local im = 1
	local i = 1
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 255, 255, 255, 255, 32, 32, 32, 255 }, { 255, 32, 160, 255, 255, 255, 32, 32 }, { 255, 32, 32, 32, 32, 255, 255, 255 }, { 15, 1, 13, 11, 9, 7, 5, 3 }
	lasttask = task.New(self, function()
		task.MoveTo(0, 0, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			s3C_boss.pic_show3()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
				task._Wait(20)
			end
		end
		self._wisys:setAction("cast", 56)
		task._Wait(30)
		local ia = i
		local im0 = im
		local sa = 270
		local sn = 1
		PlaySound("boon01", 0.1, 0, false)
		do
			for _ = 1, 2 do
				do
					local a, _d_a = (sa), (360 / 4 * ia)
					local n, _d_n = (sn), (1)
					for _ = 1, 4 do
						last = New(_editor_class["stage_3_boss_marisa_Spell3_obj1"], self.x, self.y, 4, ia, ia, im0, a, 8, circle_redarray[n], circle_greenarray[n], circle_bluearray[n], circle_bullet_clarray[n])
						_connect(self, last, 0, true)
						a = a + _d_a
						n = n + _d_n
					end
				end
				ia, im0, sn = -ia, -im0, sn + 4
			end
		end
		task._Wait(510)
		do
			for _ = 1, _infinite do
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 56)
				end)
				task._Wait(720)
			end
		end
	end)
end
local function card3_init_Yuyuko_E(self)
	local im = -1
	local i = 1
	lstg.tmpvar.xy = { x = self.x, y = self.y - 80 }
	lasttask = task.New(self, function()
		task.MoveTo(0, 80, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(20)
			end
		end
		task._Wait(540)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		local ia = i
		do
			for _ = 1, _infinite do
				local bsa = Angle(self, player)
				lasttask = task.New(self, function()
					do
						local bossv, _d_bossv = (0), (2 / 89)
						for _ = 1, 90 do
							SetV2(self, bossv, bsa, false, false)
							task._Wait(1)
							bossv = bossv + _d_bossv
						end
					end
					SetV2(self, 0, 0, false, false)
				end)
				do
					local sv, _d_sv = (1), (2 / 17)
					for _ = 1, 18 do
						do
							local ba, _d_ba = (bsa), (360 / 12 * ia)
							for _ = 1, 12 do
								last = New(_straight, butterfly, COLOR_RED, self.x, self.y, sv, ba, false, 0, true, true, 0, false, 0, 0, 0, false)
								ba = ba + _d_ba
							end
						end
						task._Wait(5)
						sv = sv + _d_sv
					end
				end
				task._Wait(30)
				local bsa = Angle(self, player)
				lasttask = task.New(self, function()
					do
						local bossv, _d_bossv = (0), (1 / 89)
						for _ = 1, 90 do
							SetV2(self, bossv, bsa, false, false)
							task._Wait(1)
							bossv = bossv + _d_bossv
						end
					end
					SetV2(self, 0, 0, false, false)
				end)
				do
					local sv, _d_sv = (1), (1.5 / 14)
					for _ = 1, 15 do
						do
							local ba, _d_ba = (bsa), (360 / 8 * ia)
							for _ = 1, 8 do
								last = New(_straight, butterfly, COLOR_BLUE, self.x, self.y, sv, ba, false, 0, true, true, 0, false, 0, 0, 0, false)
								ba = ba + _d_ba
							end
						end
						task._Wait(6)
						sv = sv + _d_sv
					end
				end
				task._Wait(30)
				local bsa = Angle(self, player)
				lasttask = task.New(self, function()
					do
						local bossv, _d_bossv = (0), (0.5 / 89)
						for _ = 1, 90 do
							SetV2(self, bossv, bsa, false, false)
							task._Wait(1)
							bossv = bossv + _d_bossv
						end
					end
					SetV2(self, 0, 0, false, false)
				end)
				do
					local sv, _d_sv = (1), (1 / 5)
					for _ = 1, 6 do
						do
							local ba, _d_ba = (bsa), (360 / 6 * ia)
							for _ = 1, 6 do
								last = New(_straight, butterfly, COLOR_PURPLE, self.x, self.y, sv, ba, false, 0, true, true, 0, false, 0, 0, 0, false)
								ba = ba + _d_ba
							end
						end
						task._Wait(15)
						sv = sv + _d_sv
					end
				end
				task._Wait(60)
				lasttask = task.New(self, function()
					task.MoveTo(0, 80, 120, MOVE_ACC_DEC)
				end)
				do
					local sv, _d_sv = (1), (2 / 14)
					local bsa, _d_bsa = (90 - 90 * ia), (1440 * ia / 14)
					for _ = 1, 15 do
						do
							local ba, _d_ba = (bsa), (180 * ia / 1)
							for _ = 1, 2 do
								do
									local addv, _d_addv = (0), (sv / 6)
									for _ = 1, 3 do
										last = New(_straight, butterfly, COLOR_DEEP_GRAY, self.x, self.y, sv, ba, false, 0, true, true, 0, false, 0, 0, 0, false)
										lasttask = task.New(last, _editor_tasks["stage_3_boss_yuyuko_Spell1_bullettask2"](sv, addv, ba))
										addv = addv + _d_addv
									end
								end
								ba = ba + _d_ba
							end
						end
						task._Wait(8)
						sv = sv + _d_sv
						bsa = bsa + _d_bsa
					end
				end
				task._Wait(180)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 64)
				end)
				task._Wait(30)
				ia = -ia
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				lstg.tmpvar.xy.x, lstg.tmpvar.xy.y = self.x, self.y - 80
				task._Wait(1)
			end
		end
	end)
end
local function card3_init_Yuyuko_N(self)
	local im = -1
	local i = 1
	lstg.tmpvar.xy = { x = self.x, y = self.y - 80 }
	lasttask = task.New(self, function()
		task.MoveTo(0, 80, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(20)
			end
		end
		self._wisys:setAction("cast", 64)
		task._Wait(540)
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
			task._Wait(60)
		end
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		local ia = i
		do
			for _ = 1, _infinite do
				local bsa = Angle(self, player)
				lasttask = task.New(self, function()
					do
						local bossv, _d_bossv = (0), (2 / 89)
						for _ = 1, 90 do
							SetV2(self, bossv, bsa, false, false)
							task._Wait(1)
							bossv = bossv + _d_bossv
						end
					end
					SetV2(self, 0, 0, false, false)
				end)
				do
					local sv, _d_sv = (1), (2 / 29)
					for _ = 1, 30 do
						do
							local ba, _d_ba = (bsa), (360 / 16 * ia)
							for _ = 1, 16 do
								last = New(_straight, butterfly, COLOR_RED, self.x, self.y, sv, ba, false, 0, true, true, 0, false, 0, 0, 0, false)
								ba = ba + _d_ba
							end
						end
						task._Wait(3)
						sv = sv + _d_sv
					end
				end
				task._Wait(30)
				local bsa = Angle(self, player)
				lasttask = task.New(self, function()
					do
						local bossv, _d_bossv = (0), (1 / 89)
						for _ = 1, 90 do
							SetV2(self, bossv, bsa, false, false)
							task._Wait(1)
							bossv = bossv + _d_bossv
						end
					end
					SetV2(self, 0, 0, false, false)
				end)
				do
					local sv, _d_sv = (1), (1.5 / 17)
					for _ = 1, 18 do
						do
							local ba, _d_ba = (bsa), (360 / 12 * ia)
							for _ = 1, 12 do
								last = New(_straight, butterfly, COLOR_BLUE, self.x, self.y, sv, ba, false, 0, true, true, 0, false, 0, 0, 0, false)
								ba = ba + _d_ba
							end
						end
						task._Wait(5)
						sv = sv + _d_sv
					end
				end
				task._Wait(30)
				local bsa = Angle(self, player)
				lasttask = task.New(self, function()
					do
						local bossv, _d_bossv = (0), (0.5 / 89)
						for _ = 1, 90 do
							SetV2(self, bossv, bsa, false, false)
							task._Wait(1)
							bossv = bossv + _d_bossv
						end
					end
					SetV2(self, 0, 0, false, false)
				end)
				do
					local sv, _d_sv = (1), (1 / 9)
					for _ = 1, 10 do
						do
							local ba, _d_ba = (bsa), (360 / 8 * ia)
							for _ = 1, 8 do
								last = New(_straight, butterfly, COLOR_PURPLE, self.x, self.y, sv, ba, false, 0, true, true, 0, false, 0, 0, 0, false)
								ba = ba + _d_ba
							end
						end
						task._Wait(9)
						sv = sv + _d_sv
					end
				end
				task._Wait(60)
				lasttask = task.New(self, function()
					task.MoveTo(0, 80, 120, MOVE_ACC_DEC)
				end)
				do
					local sv, _d_sv = (1), (2 / 24)
					local bsa, _d_bsa = (90 - 90 * ia), (1560 * ia / 23)
					for _ = 1, 24 do
						do
							local ba, _d_ba = (bsa), (180 * ia / 1)
							for _ = 1, 2 do
								do
									local addv, _d_addv = (0), (sv / 6)
									for _ = 1, 3 do
										last = New(_straight, butterfly, COLOR_DEEP_GRAY, self.x, self.y, sv, ba, false, 0, true, true, 0, false, 0, 0, 0, false)
										lasttask = task.New(last, _editor_tasks["stage_3_boss_yuyuko_Spell1_bullettask2"](sv, addv, ba))
										addv = addv + _d_addv
									end
								end
								ba = ba + _d_ba
							end
						end
						task._Wait(5)
						sv = sv + _d_sv
						bsa = bsa + _d_bsa
					end
				end
				task._Wait(180)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 64)
				end)
				task._Wait(30)
				ia = -ia
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				lstg.tmpvar.xy.x, lstg.tmpvar.xy.y = self.x, self.y - 80
				task._Wait(1)
			end
		end
	end)
end
local function card3_init_Yuyuko_H(self)
	local im = -1
	local i = 1
	lstg.tmpvar.xy = { x = self.x, y = self.y - 80 }
	lasttask = task.New(self, function()
		task.MoveTo(0, 80, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(20)
			end
		end
		self._wisys:setAction("cast", 64)
		task._Wait(510)
		lasttask = task.New(self, function()
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(60)
			end
			self._wisys:setAction("cast", 64)
		end)
		task._Wait(60)
		local ia = i
		do
			for _ = 1, _infinite do
				last = New(_editor_class["stage_3_boss_yuyuko_Spell3_spread"], self.x, self.y, 255, 32, 255)
				task._Wait(780)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 64)
				end)
				task._Wait(60)
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				lstg.tmpvar.xy.x, lstg.tmpvar.xy.y = self.x, self.y - 80
				task._Wait(1)
			end
		end
	end)
end
local function card3_init_Yuyuko_L(self)
	local im = -1
	local i = 1
	lstg.tmpvar.xy = { x = self.x, y = self.y - 80 }
	lasttask = task.New(self, function()
		task.MoveTo(0, 80, 60, MOVE_DECEL)
	end)
	lasttask = task.New(self, function()
		do
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(20)
			end
			self._wisys:setAction("cast", 64)
		end
		task._Wait(510)
		lasttask = task.New(self, function()
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
				task._Wait(60)
			end
			self._wisys:setAction("cast", 64)
		end)
		task._Wait(60)
		local ia = i
		do
			for _ = 1, _infinite do
				last = New(_editor_class["stage_3_boss_yuyuko_Spell3_spread"], self.x, self.y, 255, 255, 255)
				task._Wait(780)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
						task._Wait(60)
					end
					self._wisys:setAction("cast", 64)
				end)
				task._Wait(60)
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				lstg.tmpvar.xy.x, lstg.tmpvar.xy.y = self.x, self.y - 80
				task._Wait(1)
			end
		end
	end)
end
local function card3_del_Marisa_ENHL(self)
	Spell_break_eff(self.x, self.y, 255, 255, 0,
			'marisa_star', 'yuyuko_ghost')
end
local function card3_del_Yuyuko_ENHL(self)
	Spell_break_eff(self.x, self.y, 255, 50, 255,
			'marisa_star', 'yuyuko_ghost')
end
local card3_init = create_diff_function(
		{card3_init_Marisa_E, card3_init_Marisa_N, card3_init_Marisa_H, card3_init_Marisa_L},
		{card3_init_Yuyuko_E, card3_init_Yuyuko_N, card3_init_Yuyuko_H, card3_init_Yuyuko_L},
		true,
		{
			{cardname.card3.marisa.EN, cardname.card3.yuyuko.EN},
			{cardname.card3.marisa.EN, cardname.card3.yuyuko.EN},
			{cardname.card3.marisa.HL, cardname.card3.yuyuko.HL},
			{cardname.card3.marisa.HL, cardname.card3.yuyuko.HL},
		})
local card3_del = create_diff_function(
		{card3_del_Marisa_ENHL, card3_del_Marisa_ENHL, card3_del_Marisa_ENHL, card3_del_Marisa_ENHL},
		{card3_del_Yuyuko_ENHL, card3_del_Yuyuko_ENHL, card3_del_Yuyuko_ENHL, card3_del_Yuyuko_ENHL},
		false)
--endregion

-- effect
--region effect 1
-- 戏精开扇特效
local function effect1_Marisa_ENHL(self)
	task.MoveTo(0, 0, 60, MOVE_DECEL)
	task._Wait(60)
	stg.setBossMagicCircle(self, true)
	stg.setBossWarp(self, true)
	self._wisys:setAction("cast", 56)
	task._Wait(60)
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 255, 0)
			task._Wait(60)
		end
	end)
	task._Wait(60)
end
local function effect1_Yuyuko_ENHL(self)
	lstg.tmpvar.xy = { x = self.x, y = self.y - 80 }
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				lstg.tmpvar.xy.x, lstg.tmpvar.xy.y = self.x, self.y - 80
				task._Wait(1)
			end
		end
	end)
	task.MoveTo(0, 80, 60, MOVE_DECEL)
	task._Wait(60)
	stg.setBossMagicCircle(self, true)
	stg.setBossWarp(self, true)
	do
		local i = SB_SEASON_NMSL
		lasttask = task.New(self, function()
			local laserway = 1
			do
				local dsa, _d_dsa = (0), (60 / 4)
				for _ = 1, 5 do
					local ia = i
					do
						for _ = 1, laserway do
							last = New(_editor_class["stage_3_boss_yuyuko_Spell3_dialog_lasereffect"], 0, 0, ia, 90, 24, 24, dsa, lstg.tmpvar.xy)
							ia = -ia
						end
					end
					if (laserway < 2) then
						laserway = laserway + 1
					else
						laserway = 2
					end
					dsa = dsa + _d_dsa
				end
			end
			local bway = 1
			do
				local dsa0, _d_dsa0 = (0), (60 / 14)
				for _ = 1, 15 do
					local ib = i
					do
						for _ = 1, bway do
							do
								local r, _d_r = (72), (12 * 6 / 4)
								for _ = 1, 5 do
									last = New(_editor_class["stage_3_boss_yuyuko_Spell3_dialog_bulleteffect"], 0 + r * cos(90), 0 + r * sin(90), ib, 90, r, dsa0, lstg.tmpvar.xy)
									r = r + _d_r
								end
							end
							ib = -ib
						end
					end
					if (bway < 2) then
						bway = bway + 1
					else
						bway = 2
					end
					dsa0 = dsa0 + _d_dsa0
				end
			end
		end)
	end
	lasttask = task.New(self, function()
		self._wisys:setAction("cast", 64)
		task._Wait(60)
		self._wisys:setAction("cast2", 56)
	end)
	task._Wait(60)
	lasttask = task.New(self, function()
		do
			task._Wait(10)
			New(AbEff, self.x, self.y, 'marisa_star', 'yuyuko_ghost', 255, 50, 255)
			task._Wait(60)
		end
	end)
	task._Wait(60)
end
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
		master.marisa = stg.newSimpleBoss(-240, 384, 1145141919, function(self)
			self._private_type_boss = true
			self.master_boss = master
			lstg.wis.Marisa(self)
			self.group = GROUP_ENEMY
			self.a = 32
			self.b = 32
			common_callback(self, 1)
		end)
		master.yuyuko = stg.newSimpleBoss(240, 384, 1145141919, function(self)
			self._private_type_boss = true
			self.master_boss = master
			lstg.wis.Yuyuko(self)
			self.group = GROUP_ENEMY
			self.a = 32
			self.b = 32
			common_callback(self, 2)
		end)
		master.slave_boss = {master.marisa, master.yuyuko}
	end
	-- boss class
	local cls = EISlib.stage.createBossClass(group_name, class_name, name, s3C_boss.scbg,
			{ "s3_boss2", stage3_background }, 0, 21474836487, function() end)
	-- 对 init 进行改造，确保假 boss 先创建，然后再 boss.init，不然的话它这个沙雕玩意一开始就执行符卡，这时候假 boss 还没创建
	local old_init = cls.init
	function cls:init(...)
		create_fake_boss(self)
		old_init(self, ...)
		self.colli = false
		self.ui_names = { "Marisa", "Yuyuko" } -- boss ui
		self.ui_pointers = { 0, 0 } -- boss ui
	end
	-- 死亡动画
	function cls:spExplode()
		Del(self)
		deadtask(self.marisa)
		deadtask(self.yuyuko)
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
end

-- common action
local function common_action1(boss_class)
	local taskf = function(self)
		if not ext.sc_pr then
			-- 进场
			task.New(self.yuyuko, function()
				task.MoveTo(90, 124, 90, MOVE_DECEL)
			end)
			task.Wait(90)
			task.New(self.marisa, function()
				task.MoveTo(-90, 124, 90, MOVE_DECEL)
			end)
			task.Wait(90)
			if EISlib.stage.canDialog() then
				-- 对话
				dialog.cacheResource("Stage3")
				dialog.player.playScene("Stage3")
				dialog.player.waitSignal("fade out BGM", dialog.enum.on)
				EISlib.stage.musicFadeOut("s3", 120)
				dialog.player.waitSignal("play BGM", dialog.enum.on)
				LoadMusicRecord("s3_boss2")
				EISlib.stage.playMusic("s3_boss2", 0, true)
				dialog.player.waitUntilFinish()
			else
				EISlib.stage.musicFadeOut("s3", 120)
				LoadMusicRecord("s3_boss2")
				EISlib.stage.playMusic("s3_boss2", 0, true)
			end
			-- 开始攻击！
			stg.setBossMagicCircle(self.marisa, true)
			stg.setBossMagicCircle(self.yuyuko, true)
			stg.setBossWarp(self.marisa, true)
			stg.setBossWarp(self.yuyuko, true)
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
			task.New(self.marisa, function(unit)
				boss_scpr_show1(unit, -90, 124)
				stg.setBossMagicCircle(unit, true)
				stg.setBossWarp(unit, true)
			end)
			task.New(self.yuyuko, function(unit)
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
local function common_action3(boss_class)
	-- 戏精开扇特效
	local taskf = function(self)
		if not ext.sc_pr then
			task.New(self.marisa, function(unit)
				effect1_Marisa_ENHL(unit)
			end)
			task.New(self.yuyuko, function(unit)
				effect1_Yuyuko_ENHL(unit)
			end)
			task.Wait(240)
		else
			task.New(self.marisa, function(unit)
				boss_scpr_show1(unit, 0, 0)
				stg.setBossMagicCircle(unit, true)
				stg.setBossWarp(unit, true)
				effect1_Marisa_ENHL(unit)
			end)
			task.New(self.yuyuko, function(unit)
				boss_scpr_show2(unit, 0, 80)
				stg.setBossMagicCircle(unit, true)
				stg.setBossWarp(unit, true)
				effect1_Yuyuko_ENHL(unit)
			end)
			task.Wait(360)
		end
	end
	for _, v in pairs(boss_class) do
		create_dialog(v, false, taskf)
	end
end

--region marisa pass

local bossE = create_double("Easy", "s3bossCdouble1:Easy", "Marisa")
local bossN = create_double("Normal", "s3bossCdouble1:Normal", "Marisa")
local bossH = create_double("Hard", "s3bossCdouble1:Hard", "Marisa")
local bossL = create_double("Lunatic", "s3bossCdouble1:Lunatic", "Marisa")

common_action1({ bossE, bossN, bossH, bossL })
common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, "通常攻击1",
		{ 2, 5, 50 }, 1800, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)
create_card(bossN, "通常攻击1",
		{ 2, 5, 50 }, 1800, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)
create_card(bossH, "通常攻击1",
		{ 2, 5, 50 }, 1800, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)
create_card(bossL, "通常攻击1",
		{ 2, 5, 50 }, 1800, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, cardname.card1.marisa.EN,
		{ 3, 10, 60 }, 2000, {10, 20, 30}, "spellcard", true, card1_init, card1_del)
create_card(bossN, cardname.card1.marisa.EN,
		{ 3, 10, 60 }, 2000, {10, 20, 30}, "spellcard", true, card1_init, card1_del)
create_card(bossH, cardname.card1.marisa.HL,
		{ 3, 10, 60 }, 2000, {10, 20, 30}, "spellcard", true, card1_init, card1_del)
create_card(bossL, cardname.card1.marisa.HL,
		{ 3, 10, 60 }, 2000, {10, 20, 30}, "spellcard", true, card1_init, card1_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, "通常攻击2",
		{ 2, 5, 55 }, 2000, { 0, 0, 0 }, "normal", true, normal2_init, normal2_del)
create_card(bossN, "通常攻击2",
		{ 2, 5, 55 }, 2000, { 0, 0, 0 }, "normal", true, normal2_init, normal2_del)
create_card(bossH, "通常攻击2",
		{ 2, 5, 55 }, 2000, { 0, 0, 0 }, "normal", true, normal2_init, normal2_del)
create_card(bossL, "通常攻击2",
		{ 2, 5, 55 }, 2000, { 0, 0, 0 }, "normal", true, normal2_init, normal2_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, cardname.card2.marisa.EN,
		{ 3, 10, 80 }, 3000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)
create_card(bossN, cardname.card2.marisa.EN,
		{ 3, 10, 80 }, 3000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)
create_card(bossH, cardname.card2.marisa.HL,
		{ 3, 10, 80 }, 3000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)
create_card(bossL, cardname.card2.marisa.HL,
		{ 3, 10, 80 }, 3000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, "通常攻击3",
		{ 2, 5, 55 }, 2200, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)
create_card(bossN, "通常攻击3",
		{ 2, 5, 55 }, 2200, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)
create_card(bossH, "通常攻击3",
		{ 2, 5, 55 }, 2200, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)
create_card(bossL, "通常攻击3",
		{ 2, 5, 55 }, 2200, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, cardname.card3.marisa.EN,
		{ 5, 12, 60 }, 2400, {10, 20, 30}, "spellcard", true, card3_init, card3_del)
create_card(bossN, cardname.card3.marisa.EN,
		{ 5, 12, 60 }, 2400, {10, 20, 30}, "spellcard", true, card3_init, card3_del)
create_card(bossH, cardname.card3.marisa.HL,
		{ 5, 12, 60 }, 2400, {10, 20, 30}, "spellcard", true, card3_init, card3_del)
create_card(bossL, cardname.card3.marisa.HL,
		{ 5, 12, 60 }, 2400, {10, 20, 30}, "spellcard", true, card3_init, card3_del)

function s3C_boss.main(diff)
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

--region yuyuko pass

bossE = create_double("Easy", "s3bossCdouble2:Easy", "Yuyuko")
bossN = create_double("Normal", "s3bossCdouble2:Normal", "Yuyuko")
bossH = create_double("Hard", "s3bossCdouble2:Hard", "Yuyuko")
bossL = create_double("Lunatic", "s3bossCdouble2:Lunatic", "Yuyuko")

common_action1({ bossE, bossN, bossH, bossL })
common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, "通常攻击1",
		{ 2, 5, 50 }, 1800, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)
create_card(bossN, "通常攻击1",
		{ 2, 5, 50 }, 1800, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)
create_card(bossH, "通常攻击1",
		{ 2, 5, 50 }, 1800, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)
create_card(bossL, "通常攻击1",
		{ 2, 5, 50 }, 1800, { 0, 0, 0 }, "normal", true, normal1_init, normal1_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, cardname.card1.yuyuko.EN,
		{ 3, 10, 60 }, 2000, {10, 20, 30}, "spellcard", true, card1_init, card1_del)
create_card(bossN, cardname.card1.yuyuko.EN,
		{ 3, 10, 60 }, 2000, {10, 20, 30}, "spellcard", true, card1_init, card1_del)
create_card(bossH, cardname.card1.yuyuko.HL,
		{ 3, 10, 60 }, 2000, {10, 20, 30}, "spellcard", true, card1_init, card1_del)
create_card(bossL, cardname.card1.yuyuko.HL,
		{ 3, 10, 60 }, 2000, {10, 20, 30}, "spellcard", true, card1_init, card1_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, "通常攻击2",
		{ 2, 5, 55 }, 2200, { 0, 0, 0 }, "normal", true, normal2_init, normal2_del)
create_card(bossN, "通常攻击2",
		{ 2, 5, 55 }, 2000, { 0, 0, 0 }, "normal", true, normal2_init, normal2_del)
create_card(bossH, "通常攻击2",
		{ 2, 5, 55 }, 2000, { 0, 0, 0 }, "normal", true, normal2_init, normal2_del)
create_card(bossL, "通常攻击2",
		{ 2, 5, 55 }, 2000, { 0, 0, 0 }, "normal", true, normal2_init, normal2_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, cardname.card2.yuyuko.EN,
		{ 3, 10, 80 }, 3000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)
create_card(bossN, cardname.card2.yuyuko.EN,
		{ 3, 10, 80 }, 3000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)
create_card(bossH, cardname.card2.yuyuko.HL,
		{ 3, 10, 80 }, 3000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)
create_card(bossL, cardname.card2.yuyuko.HL,
		{ 3, 10, 80 }, 3000, {10, 20, 30}, "spellcard", true, card2_init, card2_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, "通常攻击3",
		{ 2, 5, 55 }, 2200, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)
create_card(bossN, "通常攻击3",
		{ 2, 5, 55 }, 2200, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)
create_card(bossH, "通常攻击3",
		{ 2, 5, 55 }, 2200, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)
create_card(bossL, "通常攻击3",
		{ 2, 5, 55 }, 2200, { 0, 0, 0 }, "normal", true, normal3_init, normal3_del)

common_action2({ bossE, bossN, bossH, bossL })

create_card(bossE, cardname.card3.yuyuko.EN,
		{ 5, 12, 60 }, 2400, {10, 20, 30}, "spellcard", true, card3_init, card3_del)
create_card(bossN, cardname.card3.yuyuko.EN,
		{ 5, 12, 60 }, 2400, {10, 20, 30}, "spellcard", true, card3_init, card3_del)
create_card(bossH, cardname.card3.yuyuko.HL,
		{ 5, 12, 60 }, 2400, {10, 20, 30}, "spellcard", true, card3_init, card3_del)
create_card(bossL, cardname.card3.yuyuko.HL,
		{ 5, 12, 60 }, 2400, {10, 20, 30}, "spellcard", true, card3_init, card3_del)

--endregion
