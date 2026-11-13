--弹幕定义
--region
_editor_class["stage_3_boss_marisa_lastspellcard_dialogeffect"] = Class(_object)
_editor_class["stage_3_boss_marisa_lastspellcard_dialogeffect"].init = function(self, _x, _y, i, i0, red, green, blue, rr, sa, dsa)
	self.x, self.y = _x, _y
	self.img = "image:seasons_effectcircle1"
	self.layer = -201
	self.group = GROUP_INDES
	self.hide = false
	self.bound = false
	self.navi = false
	self.hp = 10
	self.maxhp = 10
	self.colli = false
	self._servants = {}
	self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
	self.rot, self.omiga = sa - dsa * i0, 8 * i
	self.hscale, self.vscale = 0, 0
	_object.set_color(self, "mul+add", 160, red, green, blue)
	local x, y = self.x, self.y
	self.r, self.an = 0, sa - dsa * i0
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("hscale", 0.3, 15, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("vscale", 0.3, 15, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		task._Wait(15)
		lasttask = task.New(self, function()
			do
				for _ = 1, 90 do
					last = New(_editor_class["stage3_boss_marisa_lsc_circle_smear"], self.x, self.y, i0, self.rot, self.hscale, 160, red, green, blue, 15)
					task._Wait(1)
				end
			end
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("an", sa, 90, MOVE_ACC_DEC, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("r", rr, 45, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("r", 0, 45, MOVE_ACCEL, nil, 45, MODE_SET)
		end)
		do
			for _ = 1, 90 do
				self.x, self.y = x + self.r * cos(self.an), y + self.r * sin(self.an)
				task._Wait(1)
			end
		end
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("hscale", 0, 15, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("vscale", 0, 15, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		task._Wait(15)
		_del(self, false)
	end)
end
_editor_class["stage_3_boss_marisa_lastspellcard_all_E"] = Class(_object)
_editor_class["stage_3_boss_marisa_lastspellcard_all_E"].init = function(self, _x, _y, dimode, i, sign, sa)
	self.x, self.y = _x, _y
	self.img = "image:seasons_effectcircle1"
	self.layer = -600
	self.group = GROUP_INDES
	self.undestoryable = true
	self.hide = false
	self.bound = false
	self.navi = false
	self.hp = 10
	self.maxhp = 10
	self.colli = false
	self._servants = {}
	self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
	local dsa = 360
	self.rot = sa
	self.hscale, self.vscale = 0, 0
	local x, y = self.x, self.y
	self.alp, self.scale = 255, 0
	self.ran, self.dran = sa, 0
	self.sign = 1
	lasttask = task.New(self, function()
		do
			for _ = 1, 8 do
				last = New(_editor_class["stage_3_boss_marisa_lastspellcard_all_effect"], self.x, self.y, i, sa, 255, 255, 255, 2, 1)
				task._Wait(5)
			end
		end
		task._Wait(5)
		_object.set_color(self, "mul+add", 255, 255, 255, 255)
		self.omiga = 0
		self.img = "qhm_nuclear01"
		last = New(_editor_class["stage_3_boss_marisa_lastspellcard_all_nucleareffect"], self.x, self.y, dimode, i, self)
		task._Wait(30)
		PlaySound("enep00", 0.1, 0, false)
		self.colli = true
		lasttask = task.New(self, function()
			do
				local da, _d_da = (0), (360 / 12 * i)
				for _ = 1, 12 do
					last = New(_editor_class["stage_3_boss_marisa_lastspellcard_all_laserwarning"], self.x, self.y, dimode, 1, i, i, self, 255, 255, 255, 15, 480, sa - 180 * i, da, 1)
					da = da + _d_da
				end
			end
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("scale", 1, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 60 do
				self.hscale, self.vscale = self.scale * i, self.scale
				self.a, self.b = 80 * self.scale, 80 * self.scale
				task._Wait(1)
			end
		end
		task._Wait(120)
		lasttask = task.New(self, function()
			local sa = 90
			if (player.y <= 0) then
				sa = 90 - 45 * i
			elseif (player.y > 0) then
				sa = 270 + 45 * i
			end
			do
				local sv, _d_sv = (0), (0.5 / 119)
				for _ = 1, 120 do
					SetV2(self, sv, sa, false, false)
					task._Wait(1)
					sv = sv + _d_sv
				end
			end
		end)
		lasttask = task.New(self, function()
			task._Wait(2505 - 120)
			SetV2(self, 0, self.ran, false, false)
			task.MoveTo(x, y, 120, MOVE_ACC_DEC)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("dran", dsa, 2505, MOVE_ACCEL, nil, 0, MODE_SET)
		end)
		local ic = i
		do
			for _ = 1, 2505 do
				self.rot = self.ran
				self.ran = sa - self.dran * i
				--[[ 增强的弹幕 --]]
				if (self.x < -112) then
					PlaySound("enep00", 0.1, 0, false)
					self.x = -112
					self.vx = -self.vx
					last = New(_editor_class["stage_3_boss_marisa_lastspellcard_all_effect"], self.x, self.y, i, Angle(self, player), 255, 255, 255, 2, 2)
					do
						local sa, _d_sa = (Angle(self, player)), (360 / 24 * i)
						for _ = 1, 24 do
							last = New(_straight, star_small, COLOR_GRAY, self.x + 80 * self.scale * cos(sa), self.y + 80 * self.scale * sin(sa), 4, sa, false, 4 * i, true, true, 0, false, 0, 0, 0, false)
							lasttask = task.New(last, function()
								ex.SmoothSetValueTo("_speed", 1, 30, MOVE_DECEL, nil, 0, MODE_SET)
							end)
							sa = sa + _d_sa
						end
					end
					ic = -ic
				elseif (self.x > 112) then
					PlaySound("enep00", 0.1, 0, false)
					self.x = 112
					self.vx = -self.vx
					last = New(_editor_class["stage_3_boss_marisa_lastspellcard_all_effect"], self.x, self.y, i, Angle(self, player), 255, 255, 255, 2, 2)
					do
						local sa, _d_sa = (Angle(self, player)), (360 / 24 * i)
						for _ = 1, 24 do
							last = New(_straight, star_small, COLOR_GRAY, self.x + 80 * self.scale * cos(sa), self.y + 80 * self.scale * sin(sa), 4, sa, false, 4 * i, true, true, 0, false, 0, 0, 0, false)
							lasttask = task.New(last, function()
								ex.SmoothSetValueTo("_speed", 1, 30, MOVE_DECEL, nil, 0, MODE_SET)
							end)
							sa = sa + _d_sa
						end
					end
					ic = -ic
				elseif (self.y < -144) then
					PlaySound("enep00", 0.1, 0, false)
					self.y = -144
					self.vy = -self.vy
					last = New(_editor_class["stage_3_boss_marisa_lastspellcard_all_effect"], self.x, self.y, i, Angle(self, player), 255, 255, 255, 2, 2)
					do
						local sa, _d_sa = (Angle(self, player)), (360 / 24 * i)
						for _ = 1, 24 do
							last = New(_straight, star_small, COLOR_GRAY, self.x + 80 * self.scale * cos(sa), self.y + 80 * self.scale * sin(sa), 4, sa, false, 4 * i, true, true, 0, false, 0, 0, 0, false)
							lasttask = task.New(last, function()
								ex.SmoothSetValueTo("_speed", 1, 30, MOVE_DECEL, nil, 0, MODE_SET)
							end)
							sa = sa + _d_sa
						end
					end
					ic = -ic
				elseif (self.y > 144) then
					PlaySound("enep00", 0.1, 0, false)
					self.y = 144
					self.vy = -self.vy
					last = New(_editor_class["stage_3_boss_marisa_lastspellcard_all_effect"], self.x, self.y, i, Angle(self, player), 255, 255, 255, 2, 2)
					do
						local sa, _d_sa = (Angle(self, player)), (360 / 24 * i)
						for _ = 1, 24 do
							last = New(_straight, star_small, COLOR_GRAY, self.x + 80 * self.scale * cos(sa), self.y + 80 * self.scale * sin(sa), 4, sa, false, 4 * i, true, true, 0, false, 0, 0, 0, false)
							lasttask = task.New(last, function()
								ex.SmoothSetValueTo("_speed", 1, 30, MOVE_DECEL, nil, 0, MODE_SET)
							end)
							sa = sa + _d_sa
						end
					end
					ic = -ic
				end
				task._Wait(1)
			end
		end
		sign.sign, self.colli, self.sign = 0, false, 0
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("alp", 0, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("scale", 4, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 60 do
				self.hscale, self.vscale = self.scale * i, self.scale
				_object.set_color(self, "mul+add", self.alp, 255, 255, 255)
				task._Wait(1)
			end
		end
		_del(self, false)
	end)
end
_editor_class["stage_3_boss_marisa_lastspellcard_all_NHL"] = Class(_object)
_editor_class["stage_3_boss_marisa_lastspellcard_all_NHL"].init = function(self, _x, _y, dimode, i, i0, sign, sa)
	self.x, self.y = _x, _y
	self.img = "image:seasons_effectcircle1"
	self.layer = -600
	self.undestoryable = true
	self.group = GROUP_INDES
	self.hide = false
	self.bound = false
	self.navi = false
	self.hp = 10
	self.maxhp = 10
	self.colli = false
	self._servants = {}
	self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
	local redarray, greenarray, bluearray, bullet_clarray, dsa, dra = { 255, 255, 255, 32, 32, 32, 255, 255 }, { 32, 160, 255, 255, 255, 32, 32, 255 }, { 32, 32, 32, 32, 255, 255, 255, 255 }, { 1, 13, 11, 9, 7, 5, 3, 15 }, 180, { 0, 1, 1, 1 }
	self.rot, self.omiga = sa - dsa * i, 8 * i
	self.hscale, self.vscale = 0, 0
	_object.set_color(self, "mul+add", 96, 255, 255, 255)
	local x, y = self.x, self.y
	self.rr, self.red, self.green, self.blue = 0, redarray[8], greenarray[8], bluearray[8]
	self.an, self.ran, self.dran = sa - dsa * i, sa, 0
	self.alp, self.scale = 255, 0
	self.sign = 1
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("hscale", 0.5, 15, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("vscale", 0.5, 15, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		task._Wait(15)
		lasttask = task.New(self, function()
			local n = 1
			do
				for _ = 1, 14 do
					lasttask = task.New(self, function()
						ex.SmoothSetValueTo("red", redarray[n], 5, MOVE_NORMAL, nil, 0, MODE_SET)
					end)
					lasttask = task.New(self, function()
						ex.SmoothSetValueTo("green", greenarray[n], 5, MOVE_NORMAL, nil, 0, MODE_SET)
					end)
					lasttask = task.New(self, function()
						ex.SmoothSetValueTo("blue", bluearray[n], 5, MOVE_NORMAL, nil, 0, MODE_SET)
					end)
					task._Wait(5)
					if (n < 7) then
						n = n + 1
					else
						n = 1
					end
				end
			end
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("red", redarray[8], 20, MOVE_NORMAL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("green", greenarray[8], 20, MOVE_NORMAL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("blue", bluearray[8], 20, MOVE_NORMAL, nil, 0, MODE_SET)
			end)
			task._Wait(20)
		end)
		lasttask = task.New(self, function()
			do
				for _ = 1, 120 do
					last = New(_editor_class["stage3_boss_marisa_lsc_circle_smear"], self.x, self.y, i0, self.rot, self.hscale, 96, self.red, self.green, self.blue, 30)
					task._Wait(1)
				end
			end
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("rr", 256, 90, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 90 do
				self.x, self.y = x + self.rr * cos(sa - dsa * i), y + self.rr * sin(sa - dsa * i)
				_object.set_color(self, "mul+add", 128, self.red, self.green, self.blue)
				task._Wait(1)
			end
		end
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("hscale", 0, 45, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("vscale", 0, 45, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		local n = 1
		do
			for _ = 1, 8 do
				last = New(_editor_class["stage_3_boss_marisa_lastspellcard_all_effect"], self.x, self.y, i, sa, redarray[n], greenarray[n], bluearray[n], 2, 1)
				if (n < 8) then
					n = n + 1
				else
				end
				task._Wait(5)
			end
		end
		task._Wait(5)
		_object.set_color(self, "mul+add", 255, 255, 255, 255)
		self.omiga = 0
		self.img = "qhm_nuclear01"
		last = New(_editor_class["stage_3_boss_marisa_lastspellcard_all_nucleareffect"], self.x, self.y, dimode, i, self)
		task._Wait(30)
		PlaySound("enep00", 0.1, 0, false)
		self.colli = true
		lasttask = task.New(self, function()
			local n = 8
			if (dimode < 3) then
				do
					local da, _d_da = (0), (360 / 16 * i)
					for _ = 1, 16 do
						last = New(_editor_class["stage_3_boss_marisa_lastspellcard_all_laserwarning"], self.x, self.y, dimode, 2, -i, -i0, self, redarray[n], greenarray[n], bluearray[n], bullet_clarray[n], 480, sa - 180 * i, da, -1)
						if (n < 8) then
							n = n + 1
						else
							n = 1
						end
						da = da + _d_da
					end
				end
			else
			end
			do
				local da, _d_da = (0), (360 / 16 * i)
				for _ = 1, 16 do
					last = New(_editor_class["stage_3_boss_marisa_lastspellcard_all_laserwarning"], self.x, self.y, dimode, 1, i, i0, self, redarray[n], greenarray[n], bluearray[n], bullet_clarray[n], 480, sa - 180 * i, da, 1)
					if (n < 8) then
						n = n + 1
					else
						n = 1
					end
					da = da + _d_da
				end
			end
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("scale", 1, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 60 do
				self.hscale, self.vscale = self.scale * i, self.scale
				self.a, self.b = 80 * self.scale, 80 * self.scale
				task._Wait(1)
			end
		end
		task._Wait(120)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("rr", 0, 2400, MOVE_ACCEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("dran", dsa / dra[dimode], 2400, MOVE_ACCEL, nil, 0, MODE_SET)
		end)
		--[[ 增强的弹幕 --]]
		if (dimode < 3) then
			lasttask = task.New(self, function()
				New(boss_cast_ef, self.x, self.y)
				task._Wait(30)
				local way = 16
				local n = 1
				local ic = i
				do
					for _ = 1, 24 do
						PlaySound("kira00", 0.1, 0, false)
						do
							local sa, _d_sa = (Angle(self, player)), (360 / way * ic)
							for _ = 1, way do
								PlaySound("kira00", 0.1, 0, false)
								last = New(_straight, star_small, COLOR_DEEP_GRAY, self.x + 80 * self.scale * cos(sa), self.y + 80 * self.scale * sin(sa), 0, sa, false, 4 * ic, true, true, 0, false, 0.01, sa, 1, false)
								sa = sa + _d_sa
							end
						end
						if (n < 8) then
							n = n + 1
						else
							n, way = 1, way + 8
						end
						ic = -ic
						task._Wait(90)
					end
				end
			end)
		else
			lasttask = task.New(self, function()
				task._Wait(810)
				New(boss_cast_ef, self.x, self.y)
				task._Wait(30)
				if (dimode == 3) then
					local way = 12
					local n = 1
					local ic = i
					do
						for _ = 1, 16 do
							PlaySound("kira00", 0.1, 0, false)
							do
								local sa, _d_sa = (Angle(self, player)), (360 / way * ic)
								for _ = 1, way do
									PlaySound("kira00", 0.1, 0, false)
									last = New(_straight, star_small, bullet_clarray[n], self.x + 80 * self.scale * cos(sa), self.y + 80 * self.scale * sin(sa), 0, sa, false, 4 * ic, true, true, 0, false, 0.01, sa, 1, false)
									sa = sa + _d_sa
								end
							end
							if (n < 8) then
								n = n + 1
							else
								n, way = 1, way + 2
							end
							ic = -ic
							task._Wait(90)
						end
					end
				elseif (dimode == 4) then
					local way = 12
					local n = 1
					do
						for _ = 1, 16 do
							PlaySound("kira00", 0.1, 0, false)
							last = New(_editor_class["stage_3_boss_marisa_lastspellcard_all_ring_L"], self.x, self.y, i, self, redarray[n], greenarray[n], bluearray[n], bullet_clarray[n], Angle(self, player), way)
							if (n < 8) then
								n = n + 1
							else
								n, way = 1, way + 4
							end
							task._Wait(90)
						end
					end
				end
				task._Wait(120)
			end)
		end
		do
			for _ = 1, 2400 do
				self.x, self.y = x + self.rr * cos(self.an), y + self.rr * sin(self.an)
				self.rot = self.ran
				self.an, self.ran = sa - dsa * i + self.dran * i, sa - self.dran * i
				task._Wait(1)
			end
		end
		sign.sign, self.colli, self.sign = 0, false, 0
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("alp", 0, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("scale", 4, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 60 do
				self.hscale, self.vscale = self.scale * i, self.scale
				_object.set_color(self, "mul+add", self.alp, 255, 255, 255)
				task._Wait(1)
			end
		end
		_del(self, false)
	end)
end
_editor_class["stage_3_boss_marisa_lastspellcard_all_effect"] = Class(_object)
_editor_class["stage_3_boss_marisa_lastspellcard_all_effect"].init = function(self, _x, _y, i, sa, red, green, blue, sca, mode)
	self.x, self.y = _x, _y
	self.img = "image:seasons_forge_circle1"
	self.layer = -201
	self.group = GROUP_GHOST
	self.hide = false
	self.bound = false
	self.navi = false
	self.hp = 10
	self.maxhp = 10
	self.colli = false
	self._servants = {}
	self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
	self.rot = sa
	if (mode == 1) then
		self.hscale, self.vscale = sca, sca
		_object.set_color(self, "mul+add", 0, red, green, blue)
		self.alp = 0
		lasttask = task.New(self, function()
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("hscale", 0, 60, MOVE_ACCEL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("vscale", 0, 60, MOVE_ACCEL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("alp", 255, 60, MOVE_ACCEL, nil, 0, MODE_SET)
			end)
			do
				for _ = 1, 60 do
					_object.set_color(self, "mul+add", self.alp, red, green, blue)
					task._Wait(1)
				end
			end
			_del(self, false)
		end)
	elseif (mode == 2) then
		self.hscale, self.vscale = 0.75, 0.75
		_object.set_color(self, "mul+add", 255, red, green, blue)
		self.alp = 255
		lasttask = task.New(self, function()
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("hscale", sca, 60, MOVE_DECEL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("vscale", sca, 60, MOVE_DECEL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("alp", 0, 60, MOVE_DECEL, nil, 0, MODE_SET)
			end)
			do
				for _ = 1, 60 do
					_object.set_color(self, "mul+add", self.alp, red, green, blue)
					task._Wait(1)
				end
			end
			_del(self, false)
		end)
	end
end
_editor_class["stage_3_boss_marisa_lastspellcard_all_nucleareffect"] = Class(_object)
_editor_class["stage_3_boss_marisa_lastspellcard_all_nucleareffect"].init = function(self, _x, _y, dimode, i, xy)
	self.x, self.y = _x, _y
	self.layer = -600
	self.group = GROUP_GHOST
	self.hide = false
	self.bound = false
	self.navi = false
	self.hp = 10
	self.maxhp = 10
	self.colli = false
	self._servants = {}
	self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
	local redarray, greenarray, bluearray, bullet_clarray = { 255, 255, 255, 32, 32, 32, 255, 255 }, { 32, 160, 255, 255, 255, 32, 32, 255 }, { 32, 32, 32, 32, 255, 255, 255, 255 }, { 1, 13, 11, 9, 7, 5, 3, 15 }
	self.img = "qhm_nuclear02"
	self.undestoryable = true
	self.rot = xy.rot
	self.hscale, self.vscale = 0, 0
	_object.set_color(self, "mul+add", 255, 255, 255, 255)
	self.red, self.green, self.blue = redarray[8], greenarray[8], bluearray[8]
	lasttask = task.New(self, function()
		do
			for _ = 1, 90 do
				if (IsValid(xy)) then
					self.hscale, self.vscale = xy.scale, xy.scale
				else
					_del(self, true)
				end
				task._Wait(1)
			end
		end
		task._Wait(120)
		lasttask = task.New(self, function()
			if (dimode < 3) then
			else
				local n = 1
				do
					for _ = 1, 40 do
						lasttask = task.New(self, function()
							ex.SmoothSetValueTo("red", redarray[n], 60, MOVE_ACC_DEC, nil, 0, MODE_SET)
						end)
						lasttask = task.New(self, function()
							ex.SmoothSetValueTo("green", greenarray[n], 60, MOVE_ACC_DEC, nil, 0, MODE_SET)
						end)
						lasttask = task.New(self, function()
							ex.SmoothSetValueTo("blue", bluearray[n], 60, MOVE_ACC_DEC, nil, 0, MODE_SET)
						end)
						task._Wait(60)
						if (n < 8) then
							n = n + 1
						else
							n = 1
						end
					end
				end
			end
		end)
		do
			for _ = 1, _infinite do
				if (IsValid(xy)) then
					if (xy.sign > 0) then
						if (dimode < 3) then
							_object.set_color(self, "mul+add", 255, 255, 255, 255)
						else
							_object.set_color(self, "mul+add", 255, self.red, self.green, self.blue)
						end
					else
						if true then
							break
						end
					end
				else
					_del(self, true)
				end
				task._Wait(1)
			end
		end
		do
			for _ = 1, 60 do
				if (IsValid(xy)) then
					_object.set_color(self, "mul+add", xy.alp, 255, 255, 255)
					self.hscale, self.vscale = xy.scale, xy.scale
				else
					_del(self, true)
				end
				task._Wait(1)
			end
		end
		_del(self, false)
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				if (IsValid(xy)) then
					if (xy.sign > 0) then
						self.rot = xy.rot
						self.x, self.y = xy.x, xy.y
					else
					end
				else
					_del(self, true)
				end
				task._Wait(1)
			end
		end
	end)
end
_editor_class["stage_3_boss_marisa_lastspellcard_all_ring_L"] = Class(_object)
_editor_class["stage_3_boss_marisa_lastspellcard_all_ring_L"].init = function(self, _x, _y, i, xy, red, green, blue, cl, sa, way)
	self.x, self.y = _x, _y
	self.img = "image:seasons_forge_ring1"
	self.layer = -102
	self.group = GROUP_INDES
	self.hide = false
	self.bound = false
	self.navi = false
	self.hp = 10
	self.maxhp = 10
	self.colli = false
	self._servants = {}
	self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
	self.rot = xy.an
	self.hscale, self.vscale = 0, 0
	_object.set_color(self, "mul+add", 255, red, green, blue)
	self.scale, self.alp = 0.75, 255
	self.sign, self.ran = 1, xy.an + sa
	do
		local bsa, _d_bsa = (0), (360 / way * i)
		for _ = 1, way do
			last = New(_editor_class["stage_3_boss_marisa_lastspellcard_all_ring_L_bullet"], self.x, self.y, i, self, cl, bsa)
			bsa = bsa + _d_bsa
		end
	end
	lasttask = task.New(self, function()
		task._Wait(30)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("scale", 12, 1440, MOVE_NORMAL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 1440 do
				if (IsValid(xy)) then
					if (xy.sign > 0) then
						self.hscale, self.vscale = self.scale, self.scale
					else
						if true then
							break
						end
					end
				else
					_del(self, true)
				end
				task._Wait(1)
			end
		end
		self.sign = 0
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("alp", 0, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 30 do
				_object.set_color(self, "mul+add", self.alp, red, green, blue)
				task._Wait(1)
			end
		end
		_del(self, false)
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				if (IsValid(xy)) then
					if (xy.sign > 0) then
						self.x, self.y = xy.x, xy.y
						self.rot = xy.an
						self.ran = sa
					else
						if true then
							break
						end
					end
				else
					_del(self, true)
				end
				task._Wait(1)
			end
		end
	end)
end
_editor_class["stage_3_boss_marisa_lastspellcard_all_ring_L_bullet"] = Class(bullet)
_editor_class["stage_3_boss_marisa_lastspellcard_all_ring_L_bullet"].init = function(self, _x, _y, i, xy, cl, bsa)
	bullet.init(self, ball_light, cl, true, true)
	self.x, self.y = _x, _y
	self.rot, self.timer, self.colli, self.bound = xy.ran + bsa, 11, false, false
	self.hscale, self.vscale = 0, 0
	_object.set_color(self, "mul+add", 0, 255, 255, 255)
	self.scale, self.alp = 0, 0
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("scale", 0.5, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("alp", 255, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 30 do
				self.hscale, self.vscale = self.scale, self.scale
				self.a, self.b = 12.5 * self.scale, 12.5 * self.scale
				_object.set_color(self, "mul+add", self.alp, 255, 255, 255)
				task._Wait(1)
			end
		end
		self.colli = true
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				if (IsValid(xy)) then
					if (xy.sign > 0) then
						self.layer = -101
						self.rot = xy.ran + bsa
						self.x, self.y = xy.x + 96 * xy.scale * cos(xy.ran + bsa), xy.y + 96 * xy.scale * sin(xy.ran + bsa)
					else
						_del(self, true)
					end
				else
					_del(self, true)
				end
				task._Wait(1)
			end
		end
	end)
end
_editor_class["stage_3_boss_marisa_lastspellcard_all_laserwarning"] = Class(laser)
_editor_class["stage_3_boss_marisa_lastspellcard_all_laserwarning"].init = function(self, _x, _y, dimode, mode, i, i0, xy, red, green, blue, cl, l, dsa, da, im)
	laser.init(self, cl, _x, _y, 0, 0, 720, 0, 4, 4, 4)
	local bulletstyle, rnum, dnum = { BULLETSTYLE[13], BULLETSTYLE[13], BULLETSTYLE[14], BULLETSTYLE[14] }, { 6, 6, 4, 4 }, { 3, 3, 1, 2 }
	self.rot, self.l2, self.bound = dsa - xy.dran * i * mode + da, 0, false
	_object.set_color(self, "mul+add", 64, red, green, blue)
	laser._TurnHalfOn(self, 0, false)
	self.sign, self.alp = 1, 64
	do
		local r, _d_r = (92), ((l - 92) / (l / 20 + dnum[dimode] - 1))
		local num, _d_num = (0), (1)
		for _ = 1, l / 20 + dnum[dimode] do
			if (num % rnum[dimode] < dnum[dimode]) then
				if (mode == 1) then
					last = New(_editor_class["stage_3_boss_marisa_lastspellcard_all_laserwarning_bullet"], self.x, self.y, dimode, i, i0, sign, xy, self, r, red, green, blue, cl, bulletstyle[dimode])
				else
				end
			elseif (dimode == 2 and mode == 2) then
				last = New(_editor_class["stage_3_boss_marisa_lastspellcard_all_laserwarning_bullet"], self.x, self.y, dimode, i, i0, sign, xy, self, r, red, green, blue, cl, bulletstyle[dimode])
			end
			r = r + _d_r
			num = num + _d_num
		end
	end
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("l2", l, 120, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		task._Wait(120)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("alp", 160, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 60 do
				_object.set_color(self, "mul+add", self.alp, red, green, blue)
				task._Wait(1)
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				if (IsValid(xy)) then
					if (xy.sign > 0) then
						self.rot = dsa - xy.dran * i * mode + da
						self.x, self.y = xy.x, xy.y
					else
						if true then
							break
						end
					end
				else
					_del(self, true)
				end
				task._Wait(1)
			end
		end
		self.sign = 0
		laser._TurnOff(self, 30, true)
		_del(self, false)
	end)
end
_editor_class["stage_3_boss_marisa_lastspellcard_all_laserwarning_bullet"] = Class(bullet)
_editor_class["stage_3_boss_marisa_lastspellcard_all_laserwarning_bullet"].init = function(self, _x, _y, dimode, i, i0, sign, xy, xy0, rr, red, green, blue, cl, bulletstyle)
	bullet.init(self, bulletstyle, cl, false, false)
	self.x, self.y = _x, _y
	local way, da = { 1, 1, 2, 2 }, { 90, 90, 135, 135 }
	self.rot, self.timer, self.colli, self.bound, self.omiga = xy0.rot, 10, false, false, 2 * i
	self.hscale, self.vscale = 0, 0
	_object.set_color(self, "", 128, 255, 255, 255)
	self.rr, self.alp = 0, 128
	self.an = xy0.rot
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("hscale", 1, 120, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("vscale", 1, 120, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("rr", rr, 120, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		task._Wait(120)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("alp", 255, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 60 do
				_object.set_color(self, "", self.alp, 255, 255, 255)
				task._Wait(1)
			end
		end
		self.colli = true
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				if (IsValid(xy0)) then
					if (xy0.sign > 0) then
						self.x, self.y = xy0.x + self.rr * cos(xy0.rot), xy0.y + self.rr * sin(xy0.rot)
						self.an = xy0.rot
					else
						if true then
							break
						end
					end
				else
				end
				task._Wait(1)
			end
		end
		do
			local sa, _d_sa = (self.an - da[dimode] * i0), (180 * i0 / way[dimode])
			for _ = 1, way[dimode] do
				if (dimode < 3) then
					if (Dist(self, player) < 64) then
					else
						last = New(_straight, star_small, cl, self.x, self.y, 0, sa, false, 4 * i0, true, true, 0, false, 0.005, sa, 1, false)
						_object.set_color(last, "mul+add", 255, red, green, blue)
						last = New(_straight, star_small, COLOR_GRAY, self.x, self.y, 0, sa, false, 4 * i0, true, true, 0, false, 0.005, sa, 1, false)
						last.hscale, last.vscale = 0.75, 0.75
						_object.set_color(last, "mul+rev", 255, 255, 255, 255)
					end
				else
					last = New(_straight, star_small, cl, self.x, self.y, 0, sa, false, 4 * i0, true, true, 0, false, 0.005, sa, 1, false)
					_object.set_color(last, "mul+add", 255, red, green, blue)
					last = New(_straight, star_small, COLOR_GRAY, self.x, self.y, 0, sa, false, 4 * i0, true, true, 0, false, 0.005, sa, 1, false)
					last.hscale, last.vscale = 0.75, 0.75
					_object.set_color(last, "mul+rev", 255, 255, 255, 255)
				end
				sa = sa + _d_sa
			end
		end
		_del(self, true)
	end)
end
_editor_class["stage3_boss_marisa_lsc_circle_smear"] = Class(_object)
_editor_class["stage3_boss_marisa_lsc_circle_smear"].init = function(self, _x, _y, i, sa, sca, alp, red, green, blue, tim)
	self.x, self.y = _x, _y
	self.img = "image:seasons_effectcircle1"
	self.layer = LAYER_ENEMY_BULLET - 1
	self.group = GROUP_GHOST
	self.hide = false
	self.bound = false
	self.navi = false
	self.hp = 10
	self.maxhp = 10
	self.colli = false
	self._servants = {}
	self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
	self.rot = sa
	self.hscale, self.vscale = sca, sca
	_object.set_color(self, "mul+add", alp, red, green, blue)
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("hscale", 0, tim, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("vscale", 0, tim, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		task._Wait(tim)
		_del(self, false)
	end)
end
--endregion

--dialog
local function dialog1_E(self)
	do
		self.colli = false
		_object.set_color(self, "", 0, 255, 255, 255)
		lasttask = task.New(self, function()
			do
				local x, _d_x = (0), (90 / 59)
				for _ = 1, 60 do
					_object.set_color(self, "", 255 * sin(x), 255, 255, 255)
					task._Wait(1)
					x = x + _d_x
				end
			end
		end)
	end
	task._Wait(30)
	local i = ran:Sign()
	lscNoBombCheck(self)
	self._wisys:setAction("cast", 56)
	local ia = i
	local n = 1
	do
		local rr, _d_rr = (120), (240 / 7)
		local dsa, _d_dsa = (180), (-150 / 7)
		for _ = 1, 8 do
			PlaySound("tan00", 0.1, 0, false)
			do
				local sa, _d_sa = (ran:Float(0, 360)), (360 / 2 * ia)
				for _ = 1, 2 do
					last = New(_editor_class["stage_3_boss_marisa_lastspellcard_dialogeffect"], self.x, self.y, i, ia, 255, 255, 255, rr, sa, dsa)
					sa = sa + _d_sa
				end
			end
			ia = -ia
			task._Wait(10)
			rr = rr + _d_rr
			dsa = dsa + _d_dsa
		end
	end
	task._Wait(100)
end
local function dialog1_N(self)
	do
		self.colli = false
		_object.set_color(self, "", 0, 255, 255, 255)
		lasttask = task.New(self, function()
			do
				local x, _d_x = (0), (90 / 59)
				for _ = 1, 60 do
					_object.set_color(self, "", 255 * sin(x), 255, 255, 255)
					task._Wait(1)
					x = x + _d_x
				end
			end
		end)
	end
	task._Wait(30)
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 255, 255, 255, 32, 32, 32, 255, 255 }, { 32, 160, 255, 255, 255, 32, 32, 255 }, { 32, 32, 32, 32, 255, 255, 255, 255 }, { 1, 13, 11, 9, 7, 5, 3, 15 }
	local i = ran:Sign()
	lscNoBombCheck(self)
	self._wisys:setAction("cast", 56)
	local ia = i
	local n = 1
	do
		local rr, _d_rr = (120), (240 / 15)
		local dsa, _d_dsa = (180), (-150 / 15)
		for _ = 1, 16 do
			PlaySound("tan00", 0.1, 0, false)
			do
				local sa, _d_sa = (ran:Float(0, 360)), (360 / 2 * ia)
				for _ = 1, 2 do
					last = New(_editor_class["stage_3_boss_marisa_lastspellcard_dialogeffect"], self.x, self.y, i, ia, circle_redarray[n], circle_greenarray[n], circle_bluearray[n], rr, sa, dsa)
					sa = sa + _d_sa
				end
			end
			if (n < 8) then
				n = n + 1
			else
				n = 1
			end
			ia = -ia
			task._Wait(5)
			rr = rr + _d_rr
			dsa = dsa + _d_dsa
		end
	end
	task._Wait(100)
end
local function dialog1_H(self)
	do
		self.colli = false
		_object.set_color(self, "", 0, 255, 255, 255)
		lasttask = task.New(self, function()
			do
				local x, _d_x = (0), (90 / 59)
				for _ = 1, 60 do
					_object.set_color(self, "", 255 * sin(x), 255, 255, 255)
					task._Wait(1)
					x = x + _d_x
				end
			end
		end)
	end
	task._Wait(30)
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 255, 255, 255, 32, 32, 32, 255, 255 }, { 32, 160, 255, 255, 255, 32, 32, 255 }, { 32, 32, 32, 32, 255, 255, 255, 255 }, { 1, 13, 11, 9, 7, 5, 3, 15 }
	local i = ran:Sign()
	lscNoBombCheck(self)
	self._wisys:setAction("cast", 56)
	local ia = i
	local n = 1
	do
		local rr, _d_rr = (120), (240 / 23)
		local dsa, _d_dsa = (180), (-150 / 23)
		for _ = 1, 24 do
			PlaySound("tan00", 0.1, 0, false)
			do
				local sa, _d_sa = (ran:Float(0, 360)), (360 / 2 * ia)
				for _ = 1, 2 do
					last = New(_editor_class["stage_3_boss_marisa_lastspellcard_dialogeffect"], self.x, self.y, i, ia, circle_redarray[n], circle_greenarray[n], circle_bluearray[n], rr, sa, dsa)
					sa = sa + _d_sa
				end
			end
			if (n < 8) then
				n = n + 1
			else
				n = 1
			end
			ia = -ia
			task._Wait(3)
			rr = rr + _d_rr
			dsa = dsa + _d_dsa
		end
	end
	task._Wait(108)
end
local function dialog1_L(self)
	do
		self.colli = false
		_object.set_color(self, "", 0, 255, 255, 255)
		lasttask = task.New(self, function()
			do
				local x, _d_x = (0), (90 / 59)
				for _ = 1, 60 do
					_object.set_color(self, "", 255 * sin(x), 255, 255, 255)
					task._Wait(1)
					x = x + _d_x
				end
			end
		end)
	end
	task._Wait(30)
	local circle_redarray, circle_greenarray, circle_bluearray, circle_bullet_clarray = { 255, 255, 255, 32, 32, 32, 255, 255 }, { 32, 160, 255, 255, 255, 32, 32, 255 }, { 32, 32, 32, 32, 255, 255, 255, 255 }, { 1, 13, 11, 9, 7, 5, 3, 15 }
	local i = ran:Sign()
	lscNoBombCheck(self)
	self._wisys:setAction("cast", 56)
	local ia = i
	local n = 1
	do
		local rr, _d_rr = (120), (240 / 23)
		local dsa, _d_dsa = (180), (-150 / 23)
		for _ = 1, 24 do
			PlaySound("tan00", 0.1, 0, false)
			do
				local sa, _d_sa = (ran:Float(0, 360)), (360 / 2 * ia)
				for _ = 1, 2 do
					last = New(_editor_class["stage_3_boss_marisa_lastspellcard_dialogeffect"], self.x, self.y, i, ia, circle_redarray[n], circle_greenarray[n], circle_bluearray[n], rr, sa, dsa)
					sa = sa + _d_sa
				end
			end
			if (n < 8) then
				n = n + 1
			else
				n = 1
			end
			ia = -ia
			task._Wait(3)
			rr = rr + _d_rr
			dsa = dsa + _d_dsa
		end
	end
	task._Wait(108)
end

--card
local function card1_init_E(self)
	--New(lscSpecialEvent, self)
	lasttask = task.New(self, function()
		do
			s3C_boss.pic_show1()
			task._Wait(120)
		end
		self._wisys:setAction("cast", 56)
	end)
	local redarray, greenarray, bluearray, bullet_clarray = { 255, 255, 255, 32, 32, 32, 255, 255 }, { 32, 160, 255, 255, 255, 32, 32, 255 }, { 32, 32, 32, 32, 255, 255, 255, 255 }, { 1, 13, 11, 9, 7, 5, 3, 15 }
	self.sign, self.colli = 1, false
	local i = ran:Sign()
	last = New(_editor_class["stage_3_boss_marisa_lastspellcard_all_E"], self.x, self.y, 1, i, self, ran:Float(0, 360))
	self.alp = 255
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("alp", 128, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 60 do
				_object.set_color(self, "", self.alp, 255, 255, 255)
				task._Wait(1)
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				if (self.sign > 0) then
				else
					if true then
						break
					end
				end
				task._Wait(1)
			end
		end
		PlaySound("enep00", 0.1, 0, false)
		local sa = Angle(self, player)
		local ib = i
		do
			local dv, _d_dv = (120), (0)
			for _ = 1, 1 do
				local n = 8
				do
					local a, _d_a = (sa), (360 / 6 * ib)
					for _ = 1, 6 do
						do
							local rsa, _d_rsa = (90 * ib + 360 / 24 * ib), ((180 * ib - 360 / 12 * ib) / 5)
							for _ = 1, 6 do
								last = New(_straight, star_big, bullet_clarray[n], self.x, self.y, Dist(self.x + 128 * cos(a) * cos(rsa) - 64 * sin(a) * sin(rsa), self.y + 64 * cos(a) * sin(rsa) + 128 * sin(a) * cos(rsa), self.x, self.y) / dv, Angle(self.x + 128 * cos(a) * cos(rsa) - 64 * sin(a) * sin(rsa), self.y + 64 * cos(a) * sin(rsa) + 128 * sin(a) * cos(rsa), self.x, self.y), false, 2 * ib, true, true, 0, false, 0, 0, 0, false)
								_object.set_color(last, "mul+add", 255, 255, 255, 255)
								last = New(_straight, star_big, bullet_clarray[n], self.x, self.y, Dist(self.x + 128 * cos(a) * cos(rsa) - 64 * sin(a) * sin(rsa), self.y + 64 * cos(a) * sin(rsa) + 128 * sin(a) * cos(rsa), self.x, self.y) / dv, Angle(self.x + 128 * cos(a) * cos(rsa) - 64 * sin(a) * sin(rsa), self.y + 64 * cos(a) * sin(rsa) + 128 * sin(a) * cos(rsa), self.x, self.y), false, 2 * ib, true, true, 0, false, 0, 0, 0, false)
								last.hscale, last.vscale = 0.75, 0.75
								_object.set_color(last, "mul+rev", 255, 255, 255, 255)
								rsa = rsa + _d_rsa
							end
						end
						if (n < 8) then
							n = n + 1
						else
							n = 1
						end
						a = a + _d_a
					end
				end
				ib = -ib
				dv = dv + _d_dv
			end
		end
	end)
end
local function card1_init_N(self)
	--New(lscSpecialEvent, self)
	lasttask = task.New(self, function()
		do
			s3C_boss.pic_show1()
			task._Wait(120)
		end
		self._wisys:setAction("cast", 56)
	end)
	local redarray, greenarray, bluearray, bullet_clarray = { 255, 255, 255, 32, 32, 32, 255, 255 }, { 32, 160, 255, 255, 255, 32, 32, 255 }, { 32, 32, 32, 32, 255, 255, 255, 255 }, { 1, 13, 11, 9, 7, 5, 3, 15 }
	self.sign, self.colli = 1, false
	local i = ran:Sign()
	last = New(_editor_class["stage_3_boss_marisa_lastspellcard_all_NHL"], self.x, self.y, 2, i, i, self, 270)
	self.alp = 255
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("alp", 128, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 60 do
				_object.set_color(self, "", self.alp, 255, 255, 255)
				task._Wait(1)
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				if (self.sign > 0) then
				else
					if true then
						break
					end
				end
				task._Wait(1)
			end
		end
		PlaySound("enep00", 0.1, 0, false)
		local sa = Angle(self, player)
		local ib = i
		do
			local dv, _d_dv = (120), (0)
			for _ = 1, 1 do
				local n = 8
				do
					local a, _d_a = (sa), (360 / 8 * ib)
					for _ = 1, 8 do
						do
							local rsa, _d_rsa = (90 * ib + 360 / 24 * ib), ((180 * ib - 360 / 12 * ib) / 5)
							for _ = 1, 6 do
								last = New(_straight, star_big, bullet_clarray[n], self.x, self.y, Dist(self.x + 128 * cos(a) * cos(rsa) - 64 * sin(a) * sin(rsa), self.y + 64 * cos(a) * sin(rsa) + 128 * sin(a) * cos(rsa), self.x, self.y) / dv, Angle(self.x + 128 * cos(a) * cos(rsa) - 64 * sin(a) * sin(rsa), self.y + 64 * cos(a) * sin(rsa) + 128 * sin(a) * cos(rsa), self.x, self.y), false, 2 * ib, true, true, 0, false, 0, 0, 0, false)
								_object.set_color(last, "mul+add", 255, redarray[n], greenarray[n], bluearray[n])
								last = New(_straight, star_big, COLOR_DEEP_GRAY, self.x, self.y, Dist(self.x + 128 * cos(a) * cos(rsa) - 64 * sin(a) * sin(rsa), self.y + 64 * cos(a) * sin(rsa) + 128 * sin(a) * cos(rsa), self.x, self.y) / dv, Angle(self.x + 128 * cos(a) * cos(rsa) - 64 * sin(a) * sin(rsa), self.y + 64 * cos(a) * sin(rsa) + 128 * sin(a) * cos(rsa), self.x, self.y), false, 2 * ib, true, true, 0, false, 0, 0, 0, false)
								last.hscale, last.vscale = 0.75, 0.75
								_object.set_color(last, "mul+rev", 255, 255, 255, 255)
								rsa = rsa + _d_rsa
							end
						end
						if (n < 8) then
							n = n + 1
						else
							n = 1
						end
						a = a + _d_a
					end
				end
				ib = -ib
				dv = dv + _d_dv
			end
		end
	end)
end
local function card1_init_H(self)
	--New(lscSpecialEvent, self)
	lasttask = task.New(self, function()
		do
			s3C_boss.pic_show1()
			task._Wait(120)
		end
		self._wisys:setAction("cast", 56)
	end)
	local redarray, greenarray, bluearray, bullet_clarray = { 255, 255, 255, 32, 32, 32, 255, 255 }, { 32, 160, 255, 255, 255, 32, 32, 255 }, { 32, 32, 32, 32, 255, 255, 255, 255 }, { 1, 13, 11, 9, 7, 5, 3, 15 }
	self.sign, self.colli = 1, false
	local i = ran:Sign()
	local ia = i
	do
		local sa, _d_sa = (90 * i), (180 * i)
		for _ = 1, 2 do
			last = New(_editor_class["stage_3_boss_marisa_lastspellcard_all_NHL"], self.x, self.y, 3, i, ia, self, sa)
			ia = -ia
			sa = sa + _d_sa
		end
	end
	self.alp = 255
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("alp", 128, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 60 do
				_object.set_color(self, "", self.alp, 255, 255, 255)
				task._Wait(1)
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				if (self.sign > 0) then
				else
					if true then
						break
					end
				end
				task._Wait(1)
			end
		end
		PlaySound("enep00", 0.1, 0, false)
		local sa = Angle(self, player)
		local ib = i
		do
			local dv, _d_dv = (90), (0)
			for _ = 1, 1 do
				local n = 8
				do
					local a, _d_a = (sa), (360 / 8 * ib)
					for _ = 1, 8 do
						do
							local rsa, _d_rsa = (90 * ib + 360 / 32 * ib), ((180 * ib - 360 / 16 * ib) / 7)
							for _ = 1, 8 do
								last = New(_straight, star_big, bullet_clarray[n], self.x, self.y, Dist(self.x + 128 * cos(a) * cos(rsa) - 64 * sin(a) * sin(rsa), self.y + 64 * cos(a) * sin(rsa) + 128 * sin(a) * cos(rsa), self.x, self.y) / dv, Angle(self.x + 128 * cos(a) * cos(rsa) - 64 * sin(a) * sin(rsa), self.y + 64 * cos(a) * sin(rsa) + 128 * sin(a) * cos(rsa), self.x, self.y), false, 2 * ib, true, true, 0, false, 0, 0, 0, false)
								_object.set_color(last, "mul+add", 255, redarray[n], greenarray[n], bluearray[n])
								last = New(_straight, star_big, COLOR_DEEP_GRAY, self.x, self.y, Dist(self.x + 128 * cos(a) * cos(rsa) - 64 * sin(a) * sin(rsa), self.y + 64 * cos(a) * sin(rsa) + 128 * sin(a) * cos(rsa), self.x, self.y) / dv, Angle(self.x + 128 * cos(a) * cos(rsa) - 64 * sin(a) * sin(rsa), self.y + 64 * cos(a) * sin(rsa) + 128 * sin(a) * cos(rsa), self.x, self.y), false, 2 * ib, true, true, 0, false, 0, 0, 0, false)
								last.hscale, last.vscale = 0.75, 0.75
								_object.set_color(last, "mul+rev", 255, 255, 255, 255)
								rsa = rsa + _d_rsa
							end
						end
						if (n < 8) then
							n = n + 1
						else
							n = 1
						end
						a = a + _d_a
					end
				end
				ib = -ib
				dv = dv + _d_dv
			end
		end
	end)
end
local function card1_init_L(self)
	--New(lscSpecialEvent, self)
	lasttask = task.New(self, function()
		do
			s3C_boss.pic_show1()
			task._Wait(120)
		end
		self._wisys:setAction("cast", 56)
	end)
	local redarray, greenarray, bluearray, bullet_clarray = { 255, 255, 255, 32, 32, 32, 255, 255 }, { 32, 160, 255, 255, 255, 32, 32, 255 }, { 32, 32, 32, 32, 255, 255, 255, 255 }, { 1, 13, 11, 9, 7, 5, 3, 15 }
	self.sign, self.colli = 1, false
	local i = ran:Sign()
	local ia = i
	do
		local sa, _d_sa = (90 * i), (180 * i)
		for _ = 1, 2 do
			last = New(_editor_class["stage_3_boss_marisa_lastspellcard_all_NHL"], self.x, self.y, 4, i, ia, self, sa)
			ia = -ia
			sa = sa + _d_sa
		end
	end
	self.alp = 255
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("alp", 128, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 60 do
				_object.set_color(self, "", self.alp, 255, 255, 255)
				task._Wait(1)
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				if (self.sign > 0) then
				else
					if true then
						break
					end
				end
				task._Wait(1)
			end
		end
		PlaySound("enep00", 0.1, 0, false)
		local sa = Angle(self, player)
		local ib = i
		do
			local dv, _d_dv = (180), (-90 / 1)
			for _ = 1, 2 do
				local n = 8
				do
					local a, _d_a = (sa), (360 / 8 * ib)
					for _ = 1, 8 do
						do
							local rsa, _d_rsa = (90 * ib + 360 / 48 * ib), ((180 * ib - 360 / 24 * ib) / 11)
							for _ = 1, 12 do
								last = New(_straight, star_big, bullet_clarray[n], self.x, self.y, Dist(self.x + 128 * cos(a) * cos(rsa) - 64 * sin(a) * sin(rsa), self.y + 64 * cos(a) * sin(rsa) + 128 * sin(a) * cos(rsa), self.x, self.y) / dv, Angle(self.x + 128 * cos(a) * cos(rsa) - 64 * sin(a) * sin(rsa), self.y + 64 * cos(a) * sin(rsa) + 128 * sin(a) * cos(rsa), self.x, self.y), false, 2 * ib, true, true, 0, false, 0, 0, 0, false)
								_object.set_color(last, "mul+add", 255, redarray[n], greenarray[n], bluearray[n])
								last = New(_straight, star_big, COLOR_DEEP_GRAY, self.x, self.y, Dist(self.x + 128 * cos(a) * cos(rsa) - 64 * sin(a) * sin(rsa), self.y + 64 * cos(a) * sin(rsa) + 128 * sin(a) * cos(rsa), self.x, self.y) / dv, Angle(self.x + 128 * cos(a) * cos(rsa) - 64 * sin(a) * sin(rsa), self.y + 64 * cos(a) * sin(rsa) + 128 * sin(a) * cos(rsa), self.x, self.y), false, 2 * ib, true, true, 0, false, 0, 0, 0, false)
								last.hscale, last.vscale = 0.75, 0.75
								_object.set_color(last, "mul+rev", 255, 255, 255, 255)
								rsa = rsa + _d_rsa
							end
						end
						if (n < 8) then
							n = n + 1
						else
							n = 1
						end
						a = a + _d_a
					end
				end
				ib = -ib
				dv = dv + _d_dv
			end
		end
	end)
end
local function card1_del_ENHL(self)
	Spell_break_eff(self.x, self.y, 255, 255, 0,
			'marisa_star', 'yuyuko_ghost')
end

local function create_boss_class(class_name, group)
	return EISlib.stage.createBossClass(group, class_name, "Marisa", s3C_boss.scbg,
			{ "s3_boss2", stage3_background }, 0, 0,
			function(self)
				lstg.wis.Marisa(self)
			end)
end
local function create_dialog_class(boss_class, t)
	return EISlib.stage.createDialogClass(
			boss_class, false, t)
end
local function create_card_class(boss_class, card_name, tt, hp, dropt, mode, preaction, init, del)
	local sc = EISlib.stage.createCardClass(boss_class, card_name, tt, hp, dropt, mode, preaction)
	sc.init = init
	sc.del = del
end

--boss class
local bossE = create_boss_class("LSC3C:Easy", "Easy")
local bossN = create_boss_class("LSC3C:Normal", "Normal")
local bossH = create_boss_class("LSC3C:Hard", "Hard")
local bossL = create_boss_class("LSC3C:Lunatic", "Lunatic")

create_dialog_class(bossE, dialog1_E)
create_card_class(bossE, "「流浪独星」",
		{ 50, 50, 50 }, 600, {0, 0, 60}, "lastspell", true, card1_init_E, card1_del_ENHL)

create_dialog_class(bossN, dialog1_N)
create_card_class(bossN, "「交食双星」",
		{ 50, 50, 50 }, 600, {0, 0, 60}, "lastspell", true, card1_init_N, card1_del_ENHL)

create_dialog_class(bossH, dialog1_H)
create_card_class(bossH, "「联星融合」",
		{ 50, 50, 50 }, 600, {0, 0, 60}, "lastspell", true, card1_init_H, card1_del_ENHL)

create_dialog_class(bossL, dialog1_L)
create_card_class(bossL, "「联星融合」",
		{ 50, 50, 50 }, 600, {0, 0, 60}, "lastspell", true, card1_init_L, card1_del_ENHL)

function s3C_boss.LSC(diff)
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
