
--弹幕定义
--region
_editor_class["Seasons_laserwarning2"] = Class(laser)
_editor_class["Seasons_laserwarning2"].init = function(self, _x, _y, i, cl, sa, al, sr, sg, sb, width)
	laser.init(self, cl, _x, _y, 0, 256, 128, 256, width, 0, 0)
	self.rot, self.bound, self.colli, self._colli = sa, false, false, false
	_object.set_color(self, "mul+add", 0, sr, sg, sb)
	self.alp = 0
	lasttask = task.New(self, function()
		laser._TurnHalfOn(self, 0, false)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("alp", al, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 30 do
				_object.set_color(self, "mul+add", self.alp, sr, sg, sb)
				task._Wait(1)
			end
		end
		_del(self, true)
	end)
end
_editor_class["Seasons_laserwarning2"].kill = function(self)
end

_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"] = Class(_object)
_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"].init = function(self, _x, _y, i, mode, sa, sca, red, green, blue, tim)
	self.x, self.y = _x, _y
	self.img = "image:seasons_forge_circle1"
	self.layer = -601
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
	self.alp = 0
	if (mode == 1) then
		self.hscale, self.vscale = sca, sca
		_object.set_color(self, "mul+add", 0, red, green, blue)
		self.alp = 0
		lasttask = task.New(self, function()
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("hscale", 0, tim, MOVE_NORMAL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("vscale", 0, tim, MOVE_NORMAL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("alp", 255, tim, MOVE_NORMAL, nil, 0, MODE_SET)
			end)
			do
				for _ = 1, tim do
					_object.set_color(self, "mul+add", self.alp, red, green, blue)
					task._Wait(1)
				end
			end
			_del(self, false)
		end)
	else
		self.hscale, self.vscale = 0, 0
		_object.set_color(self, "mul+add", 255, red, green, blue)
		self.alp = 255
		lasttask = task.New(self, function()
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("hscale", sca, tim, MOVE_NORMAL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("vscale", sca, tim, MOVE_NORMAL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("alp", 0, tim, MOVE_NORMAL, nil, 0, MODE_SET)
			end)
			do
				for _ = 1, tim do
					_object.set_color(self, "mul+add", self.alp, red, green, blue)
					task._Wait(1)
				end
			end
			_del(self, false)
		end)
	end
end

_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1"] = Class(_object)
_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1"].init = function(self, _x, _y, i, xy, mode, sv, sa)
	self.x, self.y = _x, _y
	self.img = "img_void"
	self.layer = LAYER_ENEMY_BULLET
	self.group = GROUP_INDES
	self.hide = false
	self.bound = true
	self.navi = false
	self.hp = 10
	self.maxhp = 10
	self.colli = false
	self._servants = {}
	self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
	self.xy = xy
	self.del = 1
	self.rot = sa
	local ia = i
	if (mode == 1) then
		do
			local r, _d_r = (-32), (64 / 3)
			for _ = 1, 4 do
				last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1_slavebullet1"], self.x + r * cos(sa), self.y + r * sin(sa), ia, self, sa, r, sa, st, 1)
				r = r + _d_r
			end
		end
		do
			for _ = 1, 2 do
				do
					local r, _d_r = (16), (48 / 3)
					local st, _d_st = (0), (1)
					for _ = 1, 4 do
						last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1_slavebullet1"], self.x + r * cos(sa - 120 * ia), self.y + r * sin(sa - 120 * ia), ia, self, sa, r, sa - 120 * ia, st, 1)
						r = r + _d_r
						st = st + _d_st
					end
				end
				do
					local r, _d_r = (32), (48 / 3)
					local st, _d_st = (0), (1)
					for _ = 1, 4 do
						last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1_slavebullet1"], self.x + r * cos(sa - 135 * ia), self.y + r * sin(sa - 135 * ia), ia, self, sa, r, sa - 135 * ia, st, 1)
						r = r + _d_r
						st = st + _d_st
					end
				end
				ia = -ia
			end
		end
		lasttask = task.New(self, function()
			task._Wait(15)
			SetV2(self, sv, sa, true, false)
		end)
	elseif (mode == 2) then
		do
			local r, _d_r = (-50), (75 / 5)
			for _ = 1, 6 do
				last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1_slavebullet1"], self.x + r * cos(sa), self.y + r * sin(sa), ia, self, sa, r, sa, st, 1)
				r = r + _d_r
			end
		end
		do
			for _ = 1, 2 do
				do
					local r, _d_r = (10), (50 / 5)
					local st, _d_st = (0), (1)
					for _ = 1, 6 do
						last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1_slavebullet1"], self.x + r * cos(sa - 120 * ia), self.y + r * sin(sa - 120 * ia), ia, self, sa, r, sa - 120 * ia, st, 1)
						r = r + _d_r
						st = st + _d_st
					end
				end
				do
					local r, _d_r = (20), (70 / 5)
					local st, _d_st = (0), (1)
					for _ = 1, 6 do
						last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1_slavebullet1"], self.x + r * cos(sa - 135 * ia), self.y + r * sin(sa - 135 * ia), ia, self, sa, r, sa - 135 * ia, st, 1)
						r = r + _d_r
						st = st + _d_st
					end
				end
				do
					local r, _d_r = (70), (50 / 3)
					local st, _d_st = (0), (1)
					for _ = 1, 4 do
						last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1_slavebullet1"], self.x + r * cos(sa - 150 * ia), self.y + r * sin(sa - 150 * ia), ia, self, sa, r, sa - 150 * ia, st, 1)
						r = r + _d_r
						st = st + _d_st
					end
				end
				ia = -ia
			end
		end
		lasttask = task.New(self, function()
			do
				for _ = 1, _infinite do
					if (xy.del > 0) then
						self.x, self.y = xy.x, xy.y
					else
					end
					task._Wait(1)
				end
			end
		end)
	elseif (mode == 3) then
		do
			local r, _d_r = (-16), (32 / 2)
			for _ = 1, 3 do
				last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1_slavebullet1"], self.x + r * cos(sa), self.y + r * sin(sa), ia, self, sa, r, sa, st, 1)
				r = r + _d_r
			end
		end
		do
			for _ = 1, 2 do
				do
					local r, _d_r = (4), (28 / 2)
					local st, _d_st = (0), (1)
					for _ = 1, 3 do
						last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1_slavebullet1"], self.x + r * cos(sa - 120 * ia), self.y + r * sin(sa - 120 * ia), ia, self, sa, r, sa - 120 * ia, st, 1)
						r = r + _d_r
						st = st + _d_st
					end
				end
				do
					local r, _d_r = (16), (32 / 2)
					local st, _d_st = (0), (1)
					for _ = 1, 3 do
						last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1_slavebullet1"], self.x + r * cos(sa - 135 * ia), self.y + r * sin(sa - 135 * ia), ia, self, sa, r, sa - 135 * ia, st, 1)
						r = r + _d_r
						st = st + _d_st
					end
				end
				ia = -ia
			end
		end
		lasttask = task.New(self, function()
			task._Wait(15)
			SetV2(self, sv, sa, true, false)
		end)
	elseif (mode == 4) then
		do
			local r, _d_r = (-8), (16 / 2)
			for _ = 1, 3 do
				last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1_slavebullet1"], self.x + r * cos(sa), self.y + r * sin(sa), ia, self, sa, r, sa, st, 2)
				r = r + _d_r
			end
		end
		do
			for _ = 1, 2 do
				do
					local r, _d_r = (2), (14 / 2)
					local st, _d_st = (0), (1)
					for _ = 1, 3 do
						last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1_slavebullet1"], self.x + r * cos(sa - 120 * ia), self.y + r * sin(sa - 120 * ia), ia, self, sa, r, sa - 120 * ia, st, 2)
						r = r + _d_r
						st = st + _d_st
					end
				end
				do
					local r, _d_r = (8), (16 / 2)
					local st, _d_st = (0), (1)
					for _ = 1, 3 do
						last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1_slavebullet1"], self.x + r * cos(sa - 135 * ia), self.y + r * sin(sa - 135 * ia), ia, self, sa, r, sa - 135 * ia, st, 2)
						r = r + _d_r
						st = st + _d_st
					end
				end
				ia = -ia
			end
		end
		lasttask = task.New(self, function()
			task._Wait(15)
			SetV2(self, sv, sa, true, false)
		end)
	end
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				if (IsValid(self.xy)) then
					if (xy.del > 0) then
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
_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1"].del = function(self)
	self.class.base.del(self)
	self.del = 0
end

_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1_slavebullet1"] = Class(bullet)
_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1_slavebullet1"].init = function(self, _x, _y, i, xy, sa, sr, dra, st, flag)
	bullet.init(self, water_drop_dark, COLOR_RED, false, true)
	self.x, self.y = _x, _y
	self.xy = xy
	local mokou_clarray = { 1, 13, 11 }
	self.rot, self.bound = sa, false
	_object.set_color(self, "mul+add", 255, 255, 255, 255)
	self.flag = flag
	local flagdr = 0
	local flagda = 0
	local flagdacc = 0
	local unit = 0
	self.alp, self.scale = 0, 2
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				if (IsValid(self.xy)) then
					if (xy.del > 0) then
						self.x, self.y = xy.x + sr * cos(dra), xy.y + sr * sin(dra)
						if (self.flag == 1) then
						elseif (self.flag == 2) then
							if (IsValid(lstg.tmpvar.mokounuclear)) then
								unit = lstg.tmpvar.mokounuclear
								if (unit.nuclearflag > 0) then
									if (Dist(self, unit) > unit.scale * 88) then
									else
										flagdr, flagda = Dist(self, unit), Angle(self, unit)
										if true then
											break
										end
									end
								else
								end
							else
							end
						end
					else
						_del(self, true)
					end
				else
					_del(self, true)
				end
				task._Wait(1)
			end
		end
		do
			for _ = 1, _infinite do
				if (IsValid(lstg.tmpvar.mokounuclear)) then
					unit = lstg.tmpvar.mokounuclear
					if (unit.nuclearflag > 0) then
						self.x, self.y = unit.x + flagdr * cos(flagda - 180 * i), unit.y + flagdr * sin(flagda - 180 * i)
					else
						if (unit.yflag == 1) then
							flagdacc = 270
						elseif (unit.yflag == 2) then
							flagdacc = 90
						end
						if true then
							break
						end
					end
				else
					if true then
						break
					end
				end
				task._Wait(1)
			end
		end
		self.navi = true
		local la = flagda
		self.colli, self.rot = false, la
		ChangeBulletImage(self, water_drop_dark, COLOR_BLUE)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("alp", 255, 15, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("scale", 1, 15, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 15 do
				self.hscale, self.vscale = self.scale, self.scale
				_object.set_color(self, "mul+add", self.alp, 255, 255, 255)
				task._Wait(1)
			end
		end
		self.colli = true
		local lsv = ran:Float(1, 4)
		SetV2(self, lsv, la, true, false)
		_set_a(self, 0.015, flagdacc, false)
		task._Wait(180)
		self.bound = true
	end)
end

_editor_tasks["qhm_Stage_3_Zhulin_Mokou_LSC_bullettask1"] = function()
	return function()
		local self = task.GetSelf()
		task._Wait(120)
		_del(self, true)
	end
end

_editor_tasks["qhm_Stage_3_Zhulin_Mokou_LSC_task1"] = function(i, ssr, sr, sa, rsa, tim, dsa, cl, red, green, blue)
	return function()
		local self = task.GetSelf()
		self.rr, self.alp, self.dsa = 0, 0, 0
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("rr", sr, tim, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("alp", 255, tim, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("dsa", dsa, tim, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, tim do
				do
					local a, _d_a = (self.dsa * i), (360 * i / 2)
					for _ = 1, 2 do
						last = New(_editor_class["Seasons_laserwarning2"], self.x - ssr * sin(sa) * sin(rsa) - self.rr * sin(sa) * sin(a), self.y + ssr * cos(sa) * sin(rsa) + self.rr * cos(sa) * sin(a), i, cl, sa, self.alp, red, green, blue, 4)
						a = a + _d_a
					end
				end
				task._Wait(1)
			end
		end
	end
end

_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all2_EN"] = Class(_object)
_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all2_EN"].init = function(self, _x, _y, dimode, i, mi, sv1, sv2, sa)
	self.x, self.y = _x, _y
	self.img = "img_void"
	self.layer = LAYER_ENEMY_BULLET
	self.group = GROUP_INDES
	self.hide = false
	self.bound = false
	self.navi = false
	self.hp = 10
	self.maxhp = 10
	self.colli = false
	self._servants = {}
	self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
	local way, st = { 1, 2, 0, 0 }, { 9, 6, 0, 0 }
	self.dsa = 0
	self.dsa1 = 0
	self.del = 1
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("dsa", 2880 + 90, 720, MOVE_NORMAL, nil, 0, MODE_SET)
		end)
		do
			local sv, _d_sv = (3), (3 / 359)
			local si, _d_si = (0), (2880 * 8 / 359)
			local t, _d_t = (0), (1)
			for _ = 1, 360 do
				local accan = ran:Float(-5, 5)
				last = New(_straight, water_drop_dark, COLOR_BLUE, self.x - 288 * sin(sa) * sin(self.dsa * i - 180 * i), self.y + 288 * cos(sa) * sin(self.dsa * i - 180 * i), sv + sv / 8 * sin(si), sa, false, 0, true, true, 0, false, 0.08, sa - 180 * i + accan, 0, false)
				_object.set_color(last, "mul+add", 255, 255, 255, 255)
				last = New(_straight, water_drop_dark, COLOR_BLUE, self.x - 288 * sin(sa) * sin(self.dsa * i), self.y + 288 * cos(sa) * sin(self.dsa * i), sv + sv / 8 * sin(si), sa, false, 0, true, true, 0, false, 0.08, sa - 180 * i + accan, 0, false)
				_object.set_color(last, "mul+add", 255, 255, 255, 255)
				if (t % st[dimode] == 0) then
					last = New(_straight, water_drop, COLOR_PURPLE, self.x - 288 * sin(sa) * sin(self.dsa * i - 180 * i), self.y + 288 * cos(sa) * sin(self.dsa * i - 180 * i), (sv + sv / 8 * sin(si)) / 2, sa, false, 0, true, true, 0, false, 0, 0, 0, false)
					last = New(_straight, water_drop, COLOR_PURPLE, self.x - 288 * sin(sa) * sin(self.dsa * i), self.y + 288 * cos(sa) * sin(self.dsa * i), (sv + sv / 8 * sin(si)) / 2, sa, false, 0, true, true, 0, false, 0, 0, 0, false)
				else
				end
				task._Wait(2)
				sv = sv + _d_sv
				si = si + _d_si
				t = t + _d_t
			end
		end
	end)
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("dsa1", 1800 + 90, 720, MOVE_NORMAL, nil, 0, MODE_SET)
		end)
		do
			local sv, _d_sv = (2), (1 / 44)
			for _ = 1, 45 do
				do
					local a, _d_a = (self.dsa1 * i - 180 * i), (360 * i / way[dimode])
					for _ = 1, way[dimode] do
						last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1"], self.x - 256 * sin(sa) * sin(a), self.y + 256 * cos(sa) * sin(a), i, self, 3, sv, sa)
						a = a + _d_a
					end
				end
				task._Wait(16)
				sv = sv + _d_sv
			end
		end
	end)
end

_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_laser1"] = Class(laser)
_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_laser1"].init = function(self, _x, _y, dimode, i, sa, cl)
	laser.init(self, cl, _x, _y, 0, 0, 0, 0, 12, 0, 0)
	local dtim = { 0, 0, 3, 2 }
	self.rot = sa
	self.rx, self.y = self.x, self.y
	lasttask = task.New(self, function()
		laser._TurnOn(self, 0, false, false)
		task._Wait(60)
		PlaySound("lazer00", 0.1, 0, false)
		lasttask = task.New(self, function()
			local ia = -i
			do
				for _ = 1, _infinite do
					local way = 1
					do
						local accv, _d_accv = (0.015), (-0.015 / 32 / 1)
						local sp, _d_sp = (0), (2 / 1)
						for _ = 1, 2 do
							local ia0 = ia
							do
								local a, _d_a = (sa - 90 * ia - sp / 2 * ia), (sp * ia / (way - 1))
								for _ = 1, way do
									last = New(_straight, grain_a, cl, self.rx, self.ry, 0, a, false, 0, true, true, 0, false, accv, a, 0, false)
									ia0 = -ia0
									a = a + _d_a
								end
							end
							if (way < 2) then
								way = way + 1
							else
								way = 2
							end
							accv = accv + _d_accv
							sp = sp + _d_sp
						end
					end
					ia = -ia
					task._Wait(dtim[dimode])
				end
			end
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("l1", 144, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("l3", 144, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		task._Wait(60)
		do
			local v, _d_v = (0), (8 / 29)
			for _ = 1, 30 do
				SetV2(self, v, sa, true, false)
				task._Wait(1)
				v = v + _d_v
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				local L = self.l1 + self.l2 + self.l3
				self.rx, self.ry = self.x + L * cos(sa), self.y + L * sin(sa)
				task._Wait(1)
			end
		end
	end)
end

_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all2_HL"] = Class(_object)
_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all2_HL"].init = function(self, _x, _y, dimode, i, i0, mi, sv1, sv2, sa)
	self.x, self.y = _x, _y
	self.img = "img_void"
	self.layer = LAYER_ENEMY_BULLET
	self.group = GROUP_INDES
	self.hide = false
	self.bound = false
	self.navi = false
	self.hp = 10
	self.maxhp = 10
	self.colli = false
	self._servants = {}
	self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
	local tim, way = { 0, 0, 150, 90 }, { 0, 0, 1, 2 }
	self.dsa = 0
	self.dsa1 = 0
	self.del = 1
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("dsa", 5760 + 90, 1800, MOVE_NORMAL, nil, 0, MODE_SET)
		end)
		do
			local sv, _d_sv = (0), (5 / 899)
			local si, _d_si = (0), (5760 * 8 / 899)
			local t, _d_t = (0), (1)
			for _ = 1, 900 do
				local accan = ran:Float(-5, 5)
				last = New(_straight, ball_huge_dark, COLOR_BLUE, self.x - 288 * sin(sa) * sin(self.dsa * i - 180 * i), self.y + 288 * cos(sa) * sin(self.dsa * i - 180 * i), sv + sv / 8 * sin(si), sa, false, 0, true, true, 0, false, 0.08, sa - 180 * i + accan, 0, false)
				_object.set_color(last, "mul+add", 255, 32, 32, 255)
				last = New(_straight, ball_huge_dark, COLOR_BLUE, self.x - 288 * sin(sa) * sin(self.dsa * i), self.y + 288 * cos(sa) * sin(self.dsa * i), sv + sv / 8 * sin(si), sa, false, 0, true, true, 0, false, 0.08, sa - 180 * i + accan, 0, false)
				_object.set_color(last, "mul+add", 255, 32, 32, 255)
				task._Wait(2)
				sv = sv + _d_sv
				si = si + _d_si
				t = t + _d_t
			end
		end
	end)
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("dsa1", 5760 + 90, 1800, MOVE_NORMAL, nil, 0, MODE_SET)
		end)
		do
			local sv, _d_sv = (1), (2 / (tim[dimode] - 1))
			for _ = 1, tim[dimode] do
				do
					local a, _d_a = (self.dsa1 * i - 180 * i), (360 * i / way[dimode])
					for _ = 1, way[dimode] do
						last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1"], self.x - 256 * sin(sa) * sin(a), self.y + 256 * cos(sa) * sin(a), i, self, 4, sv, sa)
						a = a + _d_a
					end
				end
				task._Wait(1800 / tim[dimode])
				sv = sv + _d_sv
			end
		end
	end)
end

_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_nuclear"] = Class(_object)
_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_nuclear"].init = function(self, _x, _y, dimode, i, i0, sa, red, green, blue)
	self.x, self.y = _x, _y
	self.layer = -600
	self.group = GROUP_INDES
	self.hide = false
	self.bound = false
	self.navi = false
	self.hp = 10
	self.maxhp = 10
	self.colli = true
	self._servants = {}
	self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
	local scalearray = { 0, 0, 0.5, 0.75 }
	lstg.tmpvar.mokounuclear = self
	self.nuclearflag, self.yflag, self.sign = 1, 0, 1
	self.img = "qhm_nuclear01"
	self.rot, self.omiga = sa, -2 * i
	self.hscale, self.vscale = 0, 0
	_object.set_color(self, "mul+add", 255, 255, 255, 255)
	self.scale, self.alp = 0, 255
	last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_nuclear_effect"], self.x, self.y, i, i0, self, red, green, blue)
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("scale", scalearray[dimode], 90, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 90 do
				self.hscale, self.vscale = self.scale * i, self.scale
				self.a, self.b = self.scale * 80, self.scale * 80
				task._Wait(1)
			end
		end
		do
			local v, _d_v = (0), (0.15)
			for _ = 1, _infinite do
				SetV2(self, v, sa, false, false)
				if (self.y < -224) then
					self.y = -224
					self.yflag = 1
					SetV2(self, 0, sa, true, false)
					if true then
						break
					end
				elseif (self.y > 224) then
					self.y = 224
					self.yflag = 2
					SetV2(self, 0, sa, true, false)
					if true then
						break
					end
				end
				task._Wait(1)
				v = v + _d_v
			end
		end
		self.nuclearflag, self.sign, self.colli = 0, 0, false
		PlaySound("enep00")
		misc.ShakeScreen(90, 3)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("alp", 0, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("scale", scalearray[dimode] * 4, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 30 do
				self.hscale, self.vscale = self.scale * i, self.scale
				_object.set_color(self, "mul+add", self.alp, 255, 255, 255)
				task._Wait(1)
			end
		end
		_del(self, false)
	end)
end

_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_nuclear_effect"] = Class(_object)
_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_nuclear_effect"].init = function(self, _x, _y, i, i0, xy, red, green, blue)
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
	self.xy = xy
	self.img = "qhm_nuclear02"
	self.rot = xy.rot
	self.hscale, self.vscale = 0, 0
	_object.set_color(self, "mul+add", 255, red, green, blue)
	lasttask = task.New(self, function()
		do
			for _ = 1, 90 do
				if (IsValid(self.xy)) then
					self.hscale, self.vscale = xy.scale, xy.scale
				else
					_del(self, true)
				end
				task._Wait(1)
			end
		end
		do
			for _ = 1, _infinite do
				if (IsValid(self.xy)) then
					if (xy.sign > 0) then
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
				if (IsValid(self.xy)) then
					_object.set_color(self, "mul+add", xy.alp, red, green, blue)
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
				if (IsValid(self.xy)) then
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
--endregion

--妹红的蓄力特效
local function eff1(x, y, t)
	New(AbEff, x, y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
	PlaySound("ch00")
	if t then task.Wait(t) end
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

--对话
local function ls_dialog1_Easy(self)
	--self.sc_bonus_max = 20000000
	--self.sc_bonus_base = 4000000
	--[[self.del = 1
	local i = ran:Sign()
	boss.show_aura(self, false)
	self.colli = false
	_object.set_color(self, "", 0, 255, 255, 255)
	self.alp = 0
	task._Wait(30)
	task.MoveTo(0, 0, 1, MOVE_NORMAL)
	local sa = Angle(self, player)
	self.sa = sa
	do
		local a, _d_a = (sa), (360 / 3 / 2 * i)
		for _ = 1, 2 do
			do
				local a0, _d_a0 = (a), (360 / 3 * i)
				for _ = 1, 3 do
					lasttask = task.New(self, _editor_tasks["qhm_Stage_3_Zhulin_Mokou_LSC_task1"](i, 0, 48, a0, a0, 120, 450, 1, 255, 32, 32))
					a0 = a0 + _d_a0
				end
			end
			a = a + _d_a
		end
	end
	do
		for _ = 1, 4 do
			last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 1, ran:Float(0, 360), 5, 255, 32, 32, 60)
			last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 1, ran:Float(0, 360), 4.75, 255, 160, 32, 60)
			last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 1, ran:Float(0, 360), 4.5, 255, 255, 32, 60)
			task._Wait(30)
		end
	end
	task._Wait(60)]]
	boss_scpr_show1(self, 0, 0)
	self.colli = false
	lscNoBombCheck(self)
end
local function ls_dialog1_Normal(self)
	--self.sc_bonus_max = 20000000
	--self.sc_bonus_base = 4000000
	--[[self.del = 1
	local i = ran:Sign()
	boss.show_aura(self, false)
	self.colli = false
	_object.set_color(self, "", 0, 255, 255, 255)
	self.alp = 0
	task._Wait(30)
	task.MoveTo(0, 0, 1, MOVE_NORMAL)

	self.sa = sa
	do
		local a, _d_a = (sa), (360 / 4 / 2 * i)
		for _ = 1, 2 do
			do
				local a0, _d_a0 = (a), (360 / 4 * i)
				for _ = 1, 4 do
					lasttask = task.New(self, _editor_tasks["qhm_Stage_3_Zhulin_Mokou_LSC_task1"](i, 0, 48, a0, a0, 120, 450, 1, 255, 32, 32))
					a0 = a0 + _d_a0
				end
			end
			a = a + _d_a
		end
	end
	do
		for _ = 1, 4 do
			last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 1, ran:Float(0, 360), 5, 255, 32, 32, 60)
			last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 1, ran:Float(0, 360), 4.75, 255, 160, 32, 60)
			last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 1, ran:Float(0, 360), 4.5, 255, 255, 32, 60)
			task._Wait(30)
		end
	end
	task._Wait(60)]]
	--local sa = Angle(self, player)
	--self.sa = sa
	boss_scpr_show1(self, 0, 0)
	self.colli = false
	lscNoBombCheck(self)
end
local function ls_dialog1_Hard(self)
	--self.sc_bonus_max = 20000000
	--self.sc_bonus_base = 4000000
	--[[self.del = 1
	local i = ran:Sign()
	boss.show_aura(self, false)
	self.colli = false
	_object.set_color(self, "", 0, 255, 255, 255)
	self.alp = 0
	task._Wait(30)
	task.MoveTo(0, 0, 1, MOVE_NORMAL)
	local sa = Angle(self, player)
	lasttask = task.New(self, function()
		local way = 1
		do
			local vr, _d_vr = (0), (14 / 3)
			for _ = 1, 4 do
				local ia = i
				do
					for _ = 1, 2 do
						local ia0 = ia
						do
							for _ = 1, way do
								lasttask = task.New(self, _editor_tasks["qhm_Stage_3_Zhulin_Mokou_LSC_task1"](ia0, vr ^ 2, 16, 90 * ia, -90 * ia0, 15, 45, 1, 255, 32, 32))
								ia0 = -ia0
							end
						end
						ia = -ia
					end
				end
				if (way < 2) then
					way = way + 1
				else
					way = 2
				end
				task._Wait(30)
				vr = vr + _d_vr
			end
		end
		do
			local vr, _d_vr = (0), (14 / 3)
			for _ = 1, 4 do
				local ib = i
				do
					for _ = 1, 2 do
						local ib0 = ib
						do
							for _ = 1, way do
								last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_laser1"], self.x - vr ^ 2 * sin(90 * ib) * sin(-90 * ib0), self.y + vr ^ 2 * cos(90 * ib) * sin(-90 * ib0), 3, ib0, 90 * ib, 1)
								ib0 = -ib0
							end
						end
						ib = -ib
					end
				end
				task._Wait(15)
				vr = vr + _d_vr
			end
		end
	end)
	do
		for _ = 1, 4 do
			last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 1, ran:Float(0, 360), 5, 255, 32, 32, 60)
			last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 1, ran:Float(0, 360), 4.75, 255, 160, 32, 60)
			last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 1, ran:Float(0, 360), 4.5, 255, 255, 32, 60)
			task._Wait(30)
		end
	end
	task._Wait(60)]]
	boss_scpr_show1(self, 0, 0)
	self.colli = false
	lscNoBombCheck(self)
end
local function ls_dialog1_Lunatic(self)
	--self.sc_bonus_max = 20000000
	--self.sc_bonus_base = 4000000
	--[[self.del = 1
	local i = ran:Sign()
	boss.show_aura(self, false)
	self.colli = false
	_object.set_color(self, "", 0, 255, 255, 255)

	task._Wait(30)
	task.MoveTo(0, 0, 1, MOVE_NORMAL)
	local sa = Angle(self, player)
	lasttask = task.New(self, function()
		local way = 1
		do
			local vr, _d_vr = (0), (14 / 5)
			for _ = 1, 6 do
				local ia = i
				do
					for _ = 1, 2 do
						local ia0 = ia
						do
							for _ = 1, way do
								lasttask = task.New(self, _editor_tasks["qhm_Stage_3_Zhulin_Mokou_LSC_task1"](ia0, vr ^ 2, 16, 90 * ia, -90 * ia0, 15, 45, 1, 255, 32, 32))
								ia0 = -ia0
							end
						end
						ia = -ia
					end
				end
				if (way < 2) then
					way = way + 1
				else
					way = 2
				end
				task._Wait(20)
				vr = vr + _d_vr
			end
		end
		do
			local vr, _d_vr = (0), (14 / 5)
			for _ = 1, 6 do
				local ib = i
				do
					for _ = 1, 2 do
						local ib0 = ib
						do
							for _ = 1, way do
								last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_laser1"], self.x - vr ^ 2 * sin(90 * ib) * sin(-90 * ib0), self.y + vr ^ 2 * cos(90 * ib) * sin(-90 * ib0), 4, ib0, 90 * ib, 1)
								ib0 = -ib0
							end
						end
						ib = -ib
					end
				end
				task._Wait(10)
				vr = vr + _d_vr
			end
		end
	end)
	do
		for _ = 1, 4 do
			last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 1, ran:Float(0, 360), 5, 255, 32, 32, 60)
			last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 1, ran:Float(0, 360), 4.75, 255, 160, 32, 60)
			last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 1, ran:Float(0, 360), 4.5, 255, 255, 32, 60)
			task._Wait(30)
		end
	end
	task._Wait(60)]]
	boss_scpr_show1(self, 0, 0)
	self.colli = false
	lscNoBombCheck(self)
end

--1卡
local function ls_card1_init_Easy(self)
	--New(lscSpecialEvent, self)

	local i = ran:Sign()
	local mi = 1
	local rsa = ran:Float(0, 360)
	local mokou_clarray = { 1, 13, 11 }
	self.del = 1
	self.alp = 0
	lasttask = task.New(self, function()
		--[[do
			local sa = self.sa
			lasttask = task.New(self, function()
				lasttask = task.New(self, function()
					ex.SmoothSetValueTo("alp", 128, 60, MOVE_NORMAL, nil, 0, MODE_SET)
				end)
				do
					for _ = 1, 60 do
						_object.set_color(self, "", self.alp, 255, 255, 255)
						task._Wait(1)
					end
				end
			end)
			New(boss_death_ef, self.x, self.y)
			last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 2, ran:Float(0, 360), 5, 255, 32, 32, 60)
			last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 2, ran:Float(0, 360), 4.75, 255, 160, 32, 60)
			last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 2, ran:Float(0, 360), 4.5, 255, 255, 32, 60)
			do
				local a, _d_a = (sa), (360 / 3 / 2 * i)
				local sv, _d_sv = (1), (2 / 2)
				for _ = 1, 3 do
					do
						local a0, _d_a0 = (a), (360 / 3 * i)
						for _ = 1, 3 do
							last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1"], self.x, self.y, i, self, 3, sv, a0)
							a0 = a0 + _d_a0
						end
					end
					a = a + _d_a
					sv = sv + _d_sv
				end
			end
			task._Wait(60)
		end]]
		egg.SimAlpCh(self, 255, 128, 60)
		do
			s3A_boss.pic_show1()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		local ia = i
		local rx = 0
		local px = 0
		do
			for _ = 1, 2 do
				task.MoveTo(px, -160 * mi, 60, MOVE_DECEL)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
						task._Wait(60)
					end
				end)
				self._wisys:setAction("cast", 64)
				local sa = 90 * mi
				lasttask = task.New(self, _editor_tasks["qhm_Stage_3_Zhulin_Mokou_LSC_task1"](ia, 0, 64, sa, sa, 60, 45, 1, 255, 32, 32))
				task._Wait(90)
				last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1"], self.x, self.y, ia, self, 2, 0, sa)
				task._Wait(15)
				local v = 0
				do
					for _ = 1, _infinite do
						local rr = ran:Float(0, 64) * ran:Sign()
						last = New(_straight, water_drop, mokou_clarray[ran:Int(1, 3)], self.x + rr * cos(sa - 90 * ia), self.y + rr * sin(sa - 90 * ia), 0, sa, false, 0, true, true, 0, false, 0.15, sa, 9, false)
						lasttask = task.New(last, _editor_tasks["qhm_Stage_3_Zhulin_Mokou_LSC_bullettask1"]())
						last = New(_straight, water_drop, mokou_clarray[ran:Int(1, 3)], self.x + rr * cos(sa - 90 * ia), self.y + rr * sin(sa - 90 * ia), 0, sa, false, 0, true, true, 0, false, 0.2, sa, 9, false)
						lasttask = task.New(last, _editor_tasks["qhm_Stage_3_Zhulin_Mokou_LSC_bullettask1"]())
						SetV2(self, v, sa, false, false)
						if (self.y < -224) then
							self.y = -224
							SetV2(self, 0, sa, false, false)
							rsa = 90
							if true then
								break
							end
						elseif (self.y > 224) then
							self.y = 224
							SetV2(self, 0, sa, false, false)
							rsa = 270
							if true then
								break
							end
						end
						v = v + 0.3
						task._Wait(1)
					end
				end
				PlaySound("enep00", 0.1, 0, false)
				last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 2, ran:Float(0, 360), 2, 255, 32, 32, 30)
				last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 2, ran:Float(0, 360), 1.9, 255, 160, 32, 30)
				last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 2, ran:Float(0, 360), 1.8, 255, 255, 32, 30)
				do
					local sa, _d_sa = (-90 * mi - 360 * ia / 4 / 2), (360 * ia / 4)
					for _ = 1, 4 do
						local way = 1
						do
							local sv, _d_sv = (4), (-2 / 11)
							local sp, _d_sp = (0), (180 / 11)
							for _ = 1, 12 do
								do
									local a, _d_a = (sa - sp / 2 * ia), (sp * ia / (way - 1))
									for _ = 1, way do
										last = New(_straight, water_drop, COLOR_RED, self.x, self.y, sv, a, false, 0, true, true, 0, false, 0, 0, 0, false)
										last = New(_straight, water_drop, COLOR_GOLDEN_YELLOW, self.x, self.y, sv / (1.25 / 1.125), a, false, 0, true, true, 0, false, 0, 0, 0, false)
										last = New(_straight, water_drop, COLOR_CHARTREUSE, self.x, self.y, sv / 1.25, a, false, 0, true, true, 0, false, 0, 0, 0, false)
										a = a + _d_a
									end
								end
								if (way < 2) then
									way = way + 1
								else
									way = 2
								end
								sv = sv + _d_sv
								sp = sp + _d_sp
							end
						end
						sa = sa + _d_sa
					end
				end
				misc.ShakeScreen(120, 3)
				task._Wait(60)
				self.del = 0
				last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all2_EN"], self.x, self.y, 1, ia, mi, 3, 3, -90 * mi)
				task._Wait(630)
				self.del = 1
				ia, mi = -ia, -mi
				if (player.x > -112 and player.x < 112) then
					px = player.x
				elseif (player.x < -112) then
					px = -112
				elseif (player.x > 112) then
					px = 112
				end
			end
		end
		--[[task.MoveTo(0, 0, 120, MOVE_DECEL)
		task._Wait(30)
		lasttask = task.New(self, function()
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
		end)
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		local dtim = 30
		local sv = 3
		do
			local sa, _d_sa = (270), (5880 / 89 * i)
			for _ = 1, _infinite do
				last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1"], self.x, self.y, i, self, 3, sv, sa)
				if (dtim > 10) then
					dtim = dtim - 1
					sv = sv + 0.2
				else
					dtim = 10
				end
				task._Wait(dtim)
				sa = sa + _d_sa
			end
		end]]
	end)
end
local function ls_card1_init_Normal(self)
	--New(lscSpecialEvent, self)
	local i = ran:Sign()
	local mi = 1
	local rsa = ran:Float(0, 360)
	local mokou_clarray = { 1, 13, 11 }
	self.del = 1
	self.alp = 0
	lasttask = task.New(self, function()
		--[[do
			local sa = self.sa
			lasttask = task.New(self, function()
				lasttask = task.New(self, function()
					ex.SmoothSetValueTo("alp", 128, 60, MOVE_NORMAL, nil, 0, MODE_SET)
				end)
				do
					for _ = 1, 60 do
						_object.set_color(self, "", self.alp, 255, 255, 255)
						task._Wait(1)
					end
				end
			end)
			New(boss_death_ef, self.x, self.y)
			last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 2, ran:Float(0, 360), 5, 255, 32, 32, 60)
			last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 2, ran:Float(0, 360), 4.75, 255, 160, 32, 60)
			last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 2, ran:Float(0, 360), 4.5, 255, 255, 32, 60)
			do
				local a, _d_a = (sa), (360 / 4 / 2 * i)
				local sv, _d_sv = (1), (3 / 3)
				for _ = 1, 4 do
					do
						local a0, _d_a0 = (a), (360 / 4 * i)
						for _ = 1, 4 do
							last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1"], self.x, self.y, i, self, 3, sv, a0)
							a0 = a0 + _d_a0
						end
					end
					a = a + _d_a
					sv = sv + _d_sv
				end
			end
			task._Wait(60)
		end]]
		egg.SimAlpCh(self, 255, 128, 60)
		do
			s3A_boss.pic_show1()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		local ia = i
		local px = 0
		do
			for _ = 1, 2 do
				task.MoveTo(px, -160 * mi, 60, MOVE_DECEL)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
						task._Wait(60)
					end
				end)
				self._wisys:setAction("cast", 64)
				local sa = 90 * mi
				lasttask = task.New(self, _editor_tasks["qhm_Stage_3_Zhulin_Mokou_LSC_task1"](ia, 0, 64, sa, sa, 60, 45, 1, 255, 32, 32))
				task._Wait(90)
				last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1"], self.x, self.y, ia, self, 2, 0, sa)
				task._Wait(15)
				local v = 0
				do
					for _ = 1, _infinite do
						local rr = ran:Float(0, 64) * ran:Sign()
						last = New(_straight, water_drop, mokou_clarray[ran:Int(1, 3)], self.x + rr * cos(sa - 90 * ia), self.y + rr * sin(sa - 90 * ia), 0, sa, false, 0, true, true, 0, false, 0.15, sa, 9, false)
						lasttask = task.New(last, _editor_tasks["qhm_Stage_3_Zhulin_Mokou_LSC_bullettask1"]())
						last = New(_straight, water_drop, mokou_clarray[ran:Int(1, 3)], self.x + rr * cos(sa - 90 * ia), self.y + rr * sin(sa - 90 * ia), 0, sa, false, 0, true, true, 0, false, 0.2, sa, 9, false)
						lasttask = task.New(last, _editor_tasks["qhm_Stage_3_Zhulin_Mokou_LSC_bullettask1"]())
						SetV2(self, v, sa, false, false)
						if (self.y < -224) then
							self.y = -224
							SetV2(self, 0, sa, false, false)
							rsa = 90
							if true then
								break
							end
						elseif (self.y > 224) then
							self.y = 224
							SetV2(self, 0, sa, false, false)
							rsa = 270
							if true then
								break
							end
						end
						v = v + 0.3
						task._Wait(1)
					end
				end
				PlaySound("enep00", 0.1, 0, false)
				last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 2, ran:Float(0, 360), 2, 255, 32, 32, 30)
				last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 2, ran:Float(0, 360), 1.9, 255, 160, 32, 30)
				last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 2, ran:Float(0, 360), 1.8, 255, 255, 32, 30)
				do
					local sa, _d_sa = (-90 * mi - 360 * ia / 6 / 2), (360 * ia / 6)
					for _ = 1, 6 do
						local way = 1
						do
							local sv, _d_sv = (4), (-2 / 11)
							local sp, _d_sp = (0), (120 / 11)
							for _ = 1, 12 do
								do
									local a, _d_a = (sa - sp / 2 * ia), (sp * ia / (way - 1))
									for _ = 1, way do
										last = New(_straight, water_drop, COLOR_RED, self.x, self.y, sv, a, false, 0, true, true, 0, false, 0, 0, 0, false)
										last = New(_straight, water_drop, COLOR_GOLDEN_YELLOW, self.x, self.y, sv / (1.25 / 1.125), a, false, 0, true, true, 0, false, 0, 0, 0, false)
										last = New(_straight, water_drop, COLOR_CHARTREUSE, self.x, self.y, sv / 1.25, a, false, 0, true, true, 0, false, 0, 0, 0, false)
										a = a + _d_a
									end
								end
								if (way < 2) then
									way = way + 1
								else
									way = 2
								end
								sv = sv + _d_sv
								sp = sp + _d_sp
							end
						end
						sa = sa + _d_sa
					end
				end
				misc.ShakeScreen(120, 3)
				task._Wait(60)
				self.del = 0
				last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all2_EN"], self.x, self.y, 2, ia, mi, 3, 3, -90 * mi)
				task._Wait(630)
				self.del = 1
				ia, mi = -ia, -mi
				if (player.x > -112 and player.x < 112) then
					px = player.x
				elseif (player.x < -112) then
					px = -112
				elseif (player.x > 112) then
					px = 112
				end
			end
		end
		--[[task.MoveTo(0, 0, 120, MOVE_DECEL)
		task._Wait(30)
		lasttask = task.New(self, function()
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
		end)
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		local dtim = 30
		local sv = 3
		do
			local sa, _d_sa = (270), (5880 / 89 * i)
			for _ = 1, _infinite do
				do
					local a, _d_a = (sa), (360 / 2 * i)
					for _ = 1, 2 do
						last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all1"], self.x, self.y, i, self, 3, sv, a)
						a = a + _d_a
					end
				end
				if (dtim > 10) then
					dtim = dtim - 1
					sv = sv + 0.2
				else
					dtim = 10
				end
				task._Wait(dtim)
				sa = sa + _d_sa
			end
		end]]
	end)
end
local function ls_card1_init_Hard(self)
	--New(lscSpecialEvent, self)
	local i = ran:Sign()
	local mi = 1
	local rsa = ran:Float(0, 360)
	local mokou_clarray = { 1, 13, 11 }
	self.del = 1
	self.alp = 0
	lasttask = task.New(self, function()
		do
			lasttask = task.New(self, function()
				lasttask = task.New(self, function()
					ex.SmoothSetValueTo("alp", 128, 60, MOVE_NORMAL, nil, 0, MODE_SET)
				end)
				do
					for _ = 1, 60 do
						_object.set_color(self, "", self.alp, 255, 255, 255)
						task._Wait(1)
					end
				end
			end)
			--New(boss_death_ef, self.x, self.y)
			--last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 2, ran:Float(0, 360), 5, 255, 32, 32, 60)
			--last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 2, ran:Float(0, 360), 4.75, 255, 160, 32, 60)
			--last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 2, ran:Float(0, 360), 4.5, 255, 255, 32, 60)
			--task._Wait(60)
		end
		do
			s3A_boss.pic_show1()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		local ia = i
		do
			for _ = 1, 2 do
				last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all2_HL"], self.x, self.y - 224 * ia, 3, i, ia, mi, 0, 0, 90 * ia)
				ia = -ia
			end
		end
		task._Wait(120)
		local px = 0
		local sa = 0
		do
			for _ = 1, 4 do
				task.MoveTo(px, self.y, 60, MOVE_DECEL)
				task._Wait(30)
				self._wisys:setAction("cast", 64)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
						task._Wait(60)
					end
				end)
				if (player.y < self.y) then
					sa = 270
				elseif (player.y >= self.y) then
					sa = 90
				end
				lasttask = task.New(self, _editor_tasks["qhm_Stage_3_Zhulin_Mokou_LSC_task1"](ia, 0, 88, sa, sa, 90, 45, 5, 32, 32, 255))
				last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_nuclear"], self.x, self.y, 3, ia, ia0, sa, 32, 32, 255)
				task._Wait(360)
				if (player.x > -112 and player.x < 112) then
					px = player.x
				elseif (player.x < -112) then
					px = -112
				elseif (player.x > 112) then
					px = 112
				end
				ia = -ia
			end
		end
		--[[lasttask = task.New(self, function()
			do
				for _ = 1, 6 do
					local sr = ran:Float(0, 48)
					local rsa = ran:Float(0, 360)
					local x, y = self.x + sr * cos(rsa), self.y + sr * sin(rsa)
					local sa = Angle(self.x + sr * cos(rsa), self.y + sr * sin(rsa), player)
					do
						local sv, _d_sv = (1), (0.5 / 1)
						local n, _d_n = (1), (1)
						for _ = 1, 2 do
							do
								local a, _d_a = (sa), (360 / 24 * i)
								for _ = 1, 24 do
									last = New(_straight, square, mokou_clarray[n], x, y, sv, a, false, 0, true, true, 0, false, 0, 0, 0, false)
									a = a + _d_a
								end
							end
							sv = sv + _d_sv
							n = n + _d_n
						end
					end
					task._Wait(20)
				end
			end
		end)
		task.MoveTo(0, 0, 120, MOVE_DECEL)
		task._Wait(30)
		lasttask = task.New(self, function()
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
		end)
		self._wisys:setAction("cast", 64)
		local dtim = 30
		do
			local sa, _d_sa = (270), (5880 / 89 * i)
			for _ = 1, _infinite do
				do
					local a, _d_a = (sa), (360 / 2 * i)
					for _ = 1, 2 do
						lasttask = task.New(self, _editor_tasks["qhm_Stage_3_Zhulin_Mokou_LSC_task1"](i, 0, 16, a, a, 15, 45, 1, 255, 32, 32))
						last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_laser1"], self.x, self.y, 3, i, a, 1)
						a = a + _d_a
					end
				end
				if (dtim > 10) then
					dtim = dtim - 2
				else
					dtim = 10
				end
				task._Wait(dtim)
				sa = sa + _d_sa
			end
		end]]
	end)
end
local function ls_card1_init_Lunatic(self)
	--New(lscSpecialEvent, self)

	local i = ran:Sign()
	local mi = 1
	local rsa = ran:Float(0, 360)
	local mokou_clarray = { 1, 13, 11 }
	self.del = 1
	self.alp = 0
	lasttask = task.New(self, function()
		do
			lasttask = task.New(self, function()
				lasttask = task.New(self, function()
					ex.SmoothSetValueTo("alp", 128, 60, MOVE_NORMAL, nil, 0, MODE_SET)
				end)
				do
					for _ = 1, 60 do
						_object.set_color(self, "", self.alp, 255, 255, 255)
						task._Wait(1)
					end
				end
			end)
			--New(boss_death_ef, self.x, self.y)
			--last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 2, ran:Float(0, 360), 5, 255, 32, 32, 60)
			--last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 2, ran:Float(0, 360), 4.75, 255, 160, 32, 60)
			--last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_dialogeffect"], self.x, self.y, i, 2, ran:Float(0, 360), 4.5, 255, 255, 32, 60)
			--task._Wait(60)
		end
		do
			s3A_boss.pic_show1()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
		end
		self._wisys:setAction("cast", 64)
		task._Wait(30)
		local ia = i
		do
			for _ = 1, 2 do
				last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_all2_HL"], self.x, self.y - 224 * ia, 4, i, ia, mi, 0, 0, 90 * ia)
				ia = -ia
			end
		end
		task._Wait(120)
		local px = 0
		local sa = 0
		do
			for _ = 1, 4 do
				task.MoveTo(px, self.y, 60, MOVE_DECEL)
				task._Wait(30)
				self._wisys:setAction("cast", 64)
				lasttask = task.New(self, function()
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
						task._Wait(60)
					end
				end)
				if (player.y < self.y) then
					sa = 270
				elseif (player.y >= self.y) then
					sa = 90
				end
				lasttask = task.New(self, _editor_tasks["qhm_Stage_3_Zhulin_Mokou_LSC_task1"](ia, 0, 88, sa, sa, 90, 45, 5, 32, 32, 255))
				last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_nuclear"], self.x, self.y, 4, ia, ia0, sa, 32, 32, 255)
				task._Wait(360)
				if (player.x > -112 and player.x < 112) then
					px = player.x
				elseif (player.x < -112) then
					px = -112
				elseif (player.x > 112) then
					px = 112
				end
				ia = -ia
			end
		end
		--[[lasttask = task.New(self, function()
			do
				for _ = 1, 6 do
					local sr = ran:Float(0, 48)
					local rsa = ran:Float(0, 360)
					local x, y = self.x + sr * cos(rsa), self.y + sr * sin(rsa)
					local sa = Angle(self.x + sr * cos(rsa), self.y + sr * sin(rsa), player)
					do
						local sv, _d_sv = (1), (1 / 2)
						local n, _d_n = (1), (1)
						for _ = 1, 3 do
							do
								local a, _d_a = (sa), (360 / 24 * i)
								for _ = 1, 24 do
									last = New(_straight, square, mokou_clarray[n], x, y, sv, a, false, 0, true, true, 0, false, 0, 0, 0, false)
									a = a + _d_a
								end
							end
							sv = sv + _d_sv
							n = n + _d_n
						end
					end
					task._Wait(20)
				end
			end
		end)
		task.MoveTo(0, 0, 120, MOVE_DECEL)
		task._Wait(30)
		self._wisys:setAction("cast", 64)
		lasttask = task.New(self, function()
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 255, 0, 0)
				task._Wait(60)
			end
		end)]]
		--[[local dtim = 30
		do
			local sa, _d_sa = (270), (5880 / 89 * i)
			for _ = 1, _infinite do
				do
					local a, _d_a = (sa), (360 / 2 * i)
					for _ = 1, 2 do
						lasttask = task.New(self, _editor_tasks["qhm_Stage_3_Zhulin_Mokou_LSC_task1"](i, 0, 16, a, a, 15, 45, 1, 255, 32, 32))
						last = New(_editor_class["qhm_Stage_3_Zhulin_Mokou_LSC_laser1"], self.x, self.y, 4, i, a, 1)
						a = a + _d_a
					end
				end
				if (dtim > 10) then
					dtim = dtim - 3
				else
					dtim = 10
				end
				task._Wait(dtim)
				sa = sa + _d_sa
			end
		end]]
	end)
end
local function ls_card1_del(self)
	Spell_break_eff(self.x, self.y, 255, 0, 0, 'bamboo_leaf_white', 'tree_leaf_white')
	self.del = 0
end

local function create_boss_class(class_name, group)
	return EISlib.stage.createBossClass(group, class_name, "Mokou", s3A_boss.scbg,
			{"s3_boss3", stage3_background}, 0, 384,
			function(self)
				lstg.wis.Mokou(self)
			end)
end
local function create_dialog_class(boss_class, t)
	return EISlib.stage.createDialogClass(
			boss_class, false, t)
end
local function create_card_class(boss_class, card_name, tt, hp, dropt, mode, preaction, init, del)
	local sc =  EISlib.stage.createCardClass(boss_class, card_name, tt, hp, dropt, mode, preaction)
	sc.init = init
	sc.del = del
end

--boss class
local bossE = create_boss_class("LSC3A:Easy", "Easy")
local bossN = create_boss_class("LSC3A:Normal", "Normal")
local bossH = create_boss_class("LSC3A:Hard", "Hard")
local bossL = create_boss_class("LSC3A:Lunatic", "Lunatic")

--card
create_dialog_class(bossE, ls_dialog1_Easy)
create_card_class(bossE, "不知火「不死鸟爆裂飓风」",
		{35, 35, 35}, 600, {0, 0, 60}, "lastspell", true, ls_card1_init_Easy, ls_card1_del)

create_dialog_class(bossN, ls_dialog1_Normal)
create_card_class(bossN, "不知火「不死鸟爆裂飓风」",
		{35, 35, 35}, 600, {0, 0, 60}, "lastspell", true, ls_card1_init_Normal, ls_card1_del)

create_dialog_class(bossH, ls_dialog1_Hard)
create_card_class(bossH, "不知火「不死鸟爆裂飓风」",
		{35, 35, 35}, 600, {0, 0, 60}, "lastspell", true, ls_card1_init_Hard, ls_card1_del)

create_dialog_class(bossL, ls_dialog1_Lunatic)
create_card_class(bossL, "不知火「不死鸟爆裂飓风」",
		{35, 35, 35}, 600, {0, 0, 60}, "lastspell", true, ls_card1_init_Lunatic, ls_card1_del)

function s3A_boss.LSC(diff)
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
