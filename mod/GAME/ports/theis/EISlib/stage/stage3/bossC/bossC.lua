s3C_boss = {}

local path = "EISlib/stage/stage3/bossC/"
Include(path .. "Marisa_boss.lua")
Include(path .. "Yuyuko_boss.lua")
Include(path .. "bossC_mid.lua")
Include(path .. "bossC_main.lua")
Include(path .. "bossC_ls.lua")

--region 通用组件

_editor_class["Seasons_laserwarning1"] = Class(laser)
_editor_class["Seasons_laserwarning1"].init = function(self, _x, _y, i, x, y, cl, sa, al, sr, sg, sb, width)
	laser.init(self, cl, _x, _y, 0, 256, 128, 256, width, 0, 0)
	self.rot, self.bound = sa, false
	_object.set_color(self, "mul+add", 0, sr, sg, sb)
	lasttask = task.New(self, function()
		laser._TurnHalfOn(self, 0, false)
		lasttask = task.New(self, function()
			do
				local si, _d_si = (0), (90 / 29)
				for _ = 1, 30 do
					_object.set_color(self, "mul+add", al * sin(si), sr, sg, sb)
					task._Wait(1)
					si = si + _d_si
				end
			end
		end)
		task.MoveTo(x, y, 30, MOVE_DECEL)
		_del(self, true)
	end)
end
_editor_class["Seasons_laserwarning1"].kill = function(self)
end

_editor_class["stage3_boss_marisa_circle_smear"] = Class(_object)
_editor_class["stage3_boss_marisa_circle_smear"].init = function(self, _x, _y, i, sa, sca, red, green, blue)
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
	_object.set_color(self, "mul+add", 255, red, green, blue)
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("hscale", 0, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("vscale", 0, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		task._Wait(30)
		_del(self, false)
	end)
end

--endregion

--region 弹幕组件

_editor_tasks["stage_3_boss_marisa_NoSpell_circle_task"] = function(lv, sa)
	return function()
		local self = task.GetSelf()
		do
			local v, _d_v = (2), (-2 / 59)
			for _ = 1, 60 do
				SetV2(self, v, sa, true, false)
				task._Wait(1)
				v = v + _d_v
			end
		end
		do
			local v, _d_v = (0), (lv / 119)
			for _ = 1, 120 do
				SetV2(self, v, sa, true, false)
				task._Wait(1)
				v = v + _d_v
			end
		end
	end
end

_editor_class["stage_3_boss_marisa_NoSpell1_circle"] = Class(_object)
_editor_class["stage_3_boss_marisa_NoSpell1_circle"].init = function(self, _x, _y, dimode, i, sr, sa, da, red, green, blue, bcl, la)
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
	local tim, way = { 60, 80, 96, 160 }, { 10, 15, 20, 25 }
	self.rot, self.omiga = sa, -8 * i
	self.hscale, self.vscale = 0, 0
	_object.set_color(self, "mul+add", 255, red, green, blue)
	local ra = sa
	self.rr = 0
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("rr", sr / 2, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("hscale", 0.4, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("vscale", 0.4, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 60 do
				_set_rel_pos(self, self.rr * cos(ra), self.rr * sin(ra), self.rot, false)
				task._Wait(1)
			end
		end
		lasttask = task.New(self, function()
			local ia = i
			local sv = 3
			do
				local bsa, _d_bsa = (ra), (1440 * i / (tim[dimode] - 1))
				for _ = 1, tim[dimode] do
					PlaySound("kira02", 0.1, 0, false)
					last = New(_straight, star_small, bcl, self.x, self.y, sv, bsa, false, 4 * ia, true, true, 0, false, 0, 0, 0, false)
					_object.set_color(last, "", 255, 255, 255, 255)
					ia, sv = -ia, sv - 2 / (tim[dimode] - 1)
					task._Wait(480 / tim[dimode])
					bsa = bsa + _d_bsa
				end
			end
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("rr", sr, 480, MOVE_NORMAL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 480 do
				_set_rel_pos(self, self.rr * cos(ra), self.rr * sin(ra), self.rot, false)
				task._Wait(1)
			end
		end
		PlaySound("enep00", 0.1, 0, false)
		do
			local bla, _d_bla = (ra), (360 * i / way[dimode])
			for _ = 1, way[dimode] do
				do
					local lv, _d_lv = (1), (0.5)
					local ba, _d_ba = (bla), (360 / way[dimode] / 2 * i)
					for _ = 1, 2 do
						last = New(_straight, ball_mid_c, bcl, self.x, self.y, lv, ba, false, 0, true, true, 0, false, 0, 0, 0, false)
						lasttask = task.New(last, _editor_tasks["stage_3_boss_marisa_NoSpell_circle_task"](lv, ba))
						lv = lv + _d_lv
						ba = ba + _d_ba
					end
				end
				bla = bla + _d_bla
			end
		end
		_del(self, true)
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				ra = ra + da * i
				last = New(_editor_class["stage3_boss_marisa_circle_smear"], self.x, self.y, i, ra, self.hscale, red, green, blue)
				task._Wait(1)
			end
		end
	end)
end

_editor_class["stage_3_boss_marisa_Spell1"] = Class(_object)
_editor_class["stage_3_boss_marisa_Spell1"].init = function(self, _x, _y, dimode, i, i0, sign, sa, rsa, lsa)
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
	self.rot = sa
	local xy = { rx = self.x, ry = self.y, lr = 0, an = self.rot, ran = lsa, del = 1 }
	self.xy = xy
	self.r, self.lr, self.an, self.ran = 0, 0, sa, 0
	local laser1_redarray, laser1_greenarray, laser1_bluearray, laser1_bullet_clarray = {}, {}, {}, {}
	if (dimode == 1) then
		laser1_redarray, laser1_greenarray, laser1_bluearray, laser1_bullet_clarray = { 255, 255, 255, 255, 255, 255 }, { 255, 255, 255, 255, 255, 255 }, { 255, 255, 255, 255, 255, 255 }, { 1, 13, 11, 9, 7, 5, 3, 15 }
	elseif (dimode >= 2) then
		laser1_redarray, laser1_greenarray, laser1_bluearray, laser1_bullet_clarray = { 255, 255, 255, 32, 32, 32, 255, 255 }, { 32, 160, 255, 255, 255, 32, 32, 255 }, { 32, 32, 32, 32, 255, 255, 255, 255 }, { 1, 13, 11, 9, 7, 5, 3, 15 }
	end
	local way = { 6, 8, 8, 8 }
	do
		local bsa, _d_bsa = (rsa), (360 / way[dimode] * i)
		local n, _d_n = (1), (1)
		local t, _d_t = (0), (5)
		for _ = 1, way[dimode] do
			if (dimode < 3) then
			else
				last = New(_editor_class["stage_3_boss_marisa_Spell1_bullet1"], self.x, self.y, dimode, i, i0, sign, xy, bsa, laser1_redarray[n], laser1_greenarray[n], laser1_bluearray[n], laser1_bullet_clarray[n])
				_connect(self, last, 0, true)
			end
			last = New(_editor_class["stage_3_boss_marisa_Spell1_warning"], self.x, self.y, dimode, i, i0, sign, xy, bsa, laser1_redarray[n], laser1_greenarray[n], laser1_bluearray[n], laser1_bullet_clarray[n], t)
			_connect(self, last, 0, false)
			bsa = bsa + _d_bsa
			n = n + _d_n
			t = t + _d_t
		end
	end
	local anglearray = { 0, 0, 360, 720 }
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("rot", sa + 180 * i, 360, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("an", sa + 180 * i, 360, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("r", 300, 360, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("lr", 150, 360, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("ran", anglearray[dimode], 360, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 360 do
				xy.rx, xy.ry, xy.an, xy.ran = self.x, self.y, self.rot, self.an + lsa - self.ran * i
				self.x, self.y = sign.x + self.r * cos(self.rot), sign.y + self.r * sin(self.rot)
				xy.lr = self.lr
				task._Wait(1)
			end
		end
		_del(self, true)
	end)
end
_editor_class["stage_3_boss_marisa_Spell1"].del = function(self)
	self.class.base.del(self)
	self.xy.del = 0
end
_editor_class["stage_3_boss_marisa_Spell1_warning"] = Class(laser)
_editor_class["stage_3_boss_marisa_Spell1_warning"].init = function(self, _x, _y, dimode, i, i0, sign, sxy, bsa, red, green, blue, cl, st)
	laser.init(self, cl, _x, _y, 0, 0, 0, 0, 4, 4, 0)
	self.rot, self.l1, self.l2, self.l3, self.bound = Angle(self, sign.x, sign.y), 0, 0, 0, false
	_object.set_color(self, "mul+add", 255, red, green, blue)
	local xy = { x = self.x, y = self.y, an = Angle(self, sign.x, sign.y), del = 1 }
	self.xy = xy
	local tim, bustylearray = { 4, 4, 5, 5 }, { BULLETSTYLE[13], BULLETSTYLE[14], BULLETSTYLE[5], BULLETSTYLE[5] }
	do
		local mr, _d_mr = (1), ((tim[dimode] - 2) / (tim[dimode] - 1))
		local t, _d_t = (0), (5)
		local lv, _d_lv = (1), (1 / (tim[dimode] - 1))
		for _ = 1, tim[dimode] do
			last = New(_editor_class["stage_3_boss_marisa_Spell1_warning_bullet1"], self.x, self.y, dimode, i, i0, sign, xy, red, green, blue, cl, t, tim[dimode], mr, bsa, sxy, lv, bustylearray[dimode])
			_connect(self, last, 0, false)
			mr = mr + _d_mr
			t = t + _d_t
			lv = lv + _d_lv
		end
	end
	lasttask = task.New(self, function()
		laser._TurnHalfOn(self, 0, false)
		do
			for _ = 1, 360 do
				_set_rel_pos(self, sxy.lr * cos(sxy.ran + bsa), sxy.lr * sin(sxy.ran + bsa), self.rot, false)
				self.rot, self.l1, self.l2, self.l3 = Angle(self, sign.x, sign.y), 0, Dist(self, sign.x, sign.y) / 2, Dist(self, sign.x, sign.y) / 2
				xy.x, xy.y = self.x, self.y
				task._Wait(1)
			end
		end
		laser._TurnOff(self, 30, true)
		_del(self, true)
	end)
end
_editor_class["stage_3_boss_marisa_Spell1_warning"].kill = function(self)
end
_editor_class["stage_3_boss_marisa_Spell1_warning"].del = function(self)
	self.class.base.del(self)
	self.xy.del = 0
end
_editor_class["stage_3_boss_marisa_Spell1_warning_bullet1"] = Class(bullet)
_editor_class["stage_3_boss_marisa_Spell1_warning_bullet1"].init = function(self, _x, _y, dimode, i, i0, sign, sxy, red, green, blue, cl, st, tim, mr, bsa, ssxy, lv, bustyle)
	bullet.init(self, bustyle, cl, true, false)
	self.x, self.y = _x, _y
	self.rot, self.timer, self.bound = Angle(self, sign.x, sign.y) - 180 * i, 11, false
	self.hscale, self.vscale, self.a, self.b = 0, 0, 0, 0
	if (dimode < 3) then
		self.colli = true
		_object.set_color(self, "mul+add", 255, 255, 255, 255)
		self.omiga = -4 * i
	else
		self.colli = false
		_object.set_color(self, "mul+add", 128, 255, 255, 255)
	end
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("hscale", 0.25, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("vscale", 0.25, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			do
				for _ = 1, 30 do
					self.a, self.b = 2.5 * self.hscale, 2.5 * self.vscale
					task._Wait(1)
				end
			end
		end)
		task._Wait(30)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("hscale", 1, 330, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("vscale", 1, 330, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 330 do
				self.a, self.b = 2.5 * self.hscale, 2.5 * self.vscale
				task._Wait(1)
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, 360 do
				if (dimode < 3) then
				else
					self.rot = Angle(self, sign.x, sign.y) - 180 * i
				end
				_set_rel_pos(self, (Dist(sxy.x, sxy.y, sign.x, sign.y) - Dist(sxy.x, sxy.y, sign.x, sign.y) / tim * mr) * cos(sxy.an + Angle(sxy.x, sxy.y, sign.x, sign.y)), (Dist(sxy.x, sxy.y, sign.x, sign.y) - Dist(sxy.x, sxy.y, sign.x, sign.y) / tim * mr) * sin(sxy.an + Angle(sxy.x, sxy.y, sign.x, sign.y)), self.rot, false)
				task._Wait(1)
			end
		end
		task._Wait(st)
		PlaySound("kira01", 0.1, 0, false)
		self.bound = true
		if (Dist(self, player) >= 60) and self.y > -192 then
			local way, bustylearray = { 2, 2, 3, 4 }, { star_small, ball_mid_c, butterfly, butterfly }
			do
				local sa, _d_sa = (ssxy.ran - 180 * i + bsa), (360 / way[dimode] * i)
				for _ = 1, way[dimode] do
					last = New(_straight, bustylearray[dimode], cl, self.x, self.y, 0, sa, false, 0, true, true, 0, false, 0, 0, 0, false)
					if dimode == 1 then last.omiga = 3 end
					--last.bound = false
					lasttask = task.New(last, _editor_tasks["stage_3_boss_marisa_Spell1_warning_bullet1_bullettask"](lv, sa))
					sa = sa + _d_sa
				end
			end
		end
		_del(self, true)
	end)
end
_editor_tasks["stage_3_boss_marisa_Spell1_warning_bullet1_bullettask"] = function(sv, sa)
	return function()
		local self = task.GetSelf()
		do
			local v, _d_v = (0), (sv / 179)
			for _ = 1, 180 do
				SetV2(self, v, sa)
				task._Wait(1)
				v = v + _d_v
			end
		end
	end
end
_editor_class["stage_3_boss_marisa_Spell1_bullet1"] = Class(bullet)
_editor_class["stage_3_boss_marisa_Spell1_bullet1"].init = function(self, _x, _y, dimode, i, i0, sign, sxy, bsa, red, green, blue, cl)
	bullet.init(self, star_big, cl, true, false)
	self.x, self.y = _x, _y
	self.rot, self.timer, self.colli, self.bound, self.omiga = sxy.an, 11, false, false, -4 * i
	self.hscale, self.vscale, self.a, self.b = 0, 0, 0, 0
	_object.set_color(self, "mul+add", 255, 255, 255, 255)
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("hscale", 1, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("vscale", 1, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 30 do
				self.a, self.b = 8 * self.hscale, 8 * self.vscale
				task._Wait(1)
			end
		end
		self.colli = true
	end)
	lasttask = task.New(self, function()
		local tim = { 0, 0, 24, 36 }
		do
			local sv, _d_sv = (2), (-1 / (tim[dimode] - 1))
			for _ = 1, tim[dimode] do
				last = New(_straight, star_small, cl, self.x, self.y, 0, Angle(self, sxy.rx, sxy.ry) - 180 * i, false, 4 * i, true, true, 0, false, 0, 0, 0, false)
				_object.set_color(last, "", 255, 255, 255, 255)
				last.bound = false
				lasttask = task.New(last, _editor_tasks["stage_3_boss_marisa_Spell1_bullet1_task"](sv, Angle(self, sxy.rx, sxy.ry) - 180 * i))
				task._Wait(360 / tim[dimode])
				sv = sv + _d_sv
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, 360 do
				_set_rel_pos(self, sxy.lr * cos(sxy.ran + bsa), sxy.lr * sin(sxy.ran + bsa), self.rot, false)
				task._Wait(1)
			end
		end
		_del(self, true)
	end)
end
_editor_tasks["stage_3_boss_marisa_Spell1_bullet1_task"] = function(sv, sa)
	return function()
		local self = task.GetSelf()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("_speed", sv, 180, MOVE_ACCEL, nil, 0, MODE_ADD)
		end)
		task._Wait(720)
		self.bound = true
	end
end
_editor_tasks["stage_3_boss_marisa_Spell1_bullettask"] = function(sv, sa)
	return function()
		local self = task.GetSelf()
		do
			local v, _d_v = (0), (sv / 89)
			for _ = 1, 90 do
				SetV2(self, v, sa, false, false)
				task._Wait(1)
				v = v + _d_v
			end
		end
	end
end
_editor_tasks["stage_3_boss_yuyuko_Spell1_task"] = function(dimode, i, i0, sa)
	return function()
		local self = task.GetSelf()
		local i0a = i0
		do
			for _ = 1, 2 do
				lasttask = task.New(self, _editor_tasks["stage_3_boss_yuyuko_Spell1_task_task"](dimode, i, i0, i0a, sa))
				i0a = -i0a
			end
		end
	end
end
_editor_tasks["stage_3_boss_yuyuko_Spell1_task_task"] = function(dimode, i, i0, i1, sa)
	return function()
		local self = task.GetSelf()
		local sra = -135
		local tim = { 12, 24 }
		do
			local sv, _d_sv = (3), (-2 / (tim[dimode] - 1))
			local a, _d_a = (sa), (45 * i1 / (tim[dimode] - 1))
			for _ = 1, tim[dimode] do
				PlaySound("kira00", 0.1, 0, false)
				last = New(_straight, butterfly, COLOR_RED, self.x, self.y, sv, a, false, 0, true, true, 0, false, 0, 0, 0, false)
				lasttask = task.New(last, _editor_tasks["stage_3_boss_yuyuko_Spell1_bullettask1"](i1, i1, sv, a, sra, 0))
				sra = sra + 135 / 23
				task._Wait(120 / tim[dimode])
				sv = sv + _d_sv
				a = a + _d_a
			end
		end
	end
end
_editor_tasks["stage_3_boss_yuyuko_Spell1_bullettask1"] = function(i, i0, sv, sa, sra, ra)
	return function()
		local self = task.GetSelf()
		do
			local v, _d_v = (sv), (-sv / 89)
			for _ = 1, 90 do
				SetV2(self, v, sa, true, false)
				task._Wait(1)
				v = v + _d_v
			end
		end
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("rot", sra * i + ra * i, 60, MOVE_DECEL, nil, 0, MODE_ADD)
		end)
		task._Wait(60)
		local la = self.rot
		do
			local v, _d_v = (0), (sv / 89)
			for _ = 1, 90 do
				SetV2(self, v, la, true, false)
				task._Wait(1)
				v = v + _d_v
			end
		end
	end
end
_editor_tasks["stage_3_boss_yuyuko_Spell1_bullettask2"] = function(sv, addv, sa)
	return function()
		local self = task.GetSelf()
		task._Wait(30)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("_speed", addv, 60, MOVE_ACCEL, nil, 0, MODE_ADD)
		end)
	end
end

_editor_class["stage_3_boss_marisa_NoSpell2_circle"] = Class(_object)
_editor_class["stage_3_boss_marisa_NoSpell2_circle"].init = function(self, _x, _y, dimode, i, sr, sa, da, red, green, blue, bcl, la, xy)
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
	local tim, way1, way2 = { 60, 80, 96, 160 }, { 10, 10, 10, 10 }, { 2, 3, 4, 5 }
	self.rot, self.omiga = sa, -8 * i
	self.hscale, self.vscale = 0, 0
	_object.set_color(self, "mul+add", 255, red, green, blue)
	local ra = sa
	local ra0 = sa
	self.rr = 0
	self.rr0 = 0
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("rr", sr, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("rr0", sr, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("hscale", 0.3, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("vscale", 0.3, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 60 do
				_set_rel_pos(self, self.rr * cos(ra), self.rr * sin(ra), self.rot, false)
				task._Wait(1)
			end
		end
		lasttask = task.New(self, function()
			local ia = i
			local sv = 1
			do
				for _ = 1, tim[dimode] do
					PlaySound("kira02", 0.1, 0, false)
					last = New(_straight, star_small, bcl, self.x, self.y, sv, ra0, false, -4 * ia, true, true, 0, false, 0, 0, 0, false)
					_object.set_color(last, "", 255, 255, 255, 255)
					ia, sv = -ia, sv + 2 / (tim[dimode] - 1)
					task._Wait(480 / tim[dimode])
				end
			end
		end)
		local lra = Angle(xy.x, xy.y, player)
		lasttask = task.New(self, function()
			do
				local rr, _d_rr = (sr), (-sr / 2 / 479)
				local rr0, _d_rr0 = (sr), (-sr * 2 / 479)
				for _ = 1, 480 do
					self.rr, self.rr0 = rr, rr0
					task._Wait(1)
					rr = rr + _d_rr
					rr0 = rr0 + _d_rr0
				end
			end
		end)
		do
			for _ = 1, 480 do
				_set_rel_pos(self, self.rr0 * cos(lra) * cos(ra - lra) - self.rr * sin(lra) * sin(ra - lra), self.rr * cos(lra) * sin(ra - lra) + self.rr0 * sin(lra) * cos(ra - lra), self.rot, false)
				task._Wait(1)
			end
		end
		PlaySound("enep00", 0.1, 0, false)
		do
			local bla, _d_bla = (ra), (360 * i / way1[dimode])
			for _ = 1, way1[dimode] do
				do
					local lv, _d_lv = (1), (0.5 / (way2[dimode] - 1))
					local ba, _d_ba = (bla), (36 * i / (way2[dimode]))
					for _ = 1, way2[dimode] do
						last = New(_straight, ball_mid_c, bcl, self.x, self.y, lv, ba, false, 0, true, true, 0, false, 0, 0, 0, false)
						lasttask = task.New(last, _editor_tasks["stage_3_boss_marisa_NoSpell_circle_task"](lv, ba))
						lv = lv + _d_lv
						ba = ba + _d_ba
					end
				end
				bla = bla + _d_bla
			end
		end
		_del(self, true)
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				ra = ra + da * i
				ra0 = ra0 - da * i
				last = New(_editor_class["stage3_boss_marisa_circle_smear"], self.x, self.y, i, ra, self.hscale, red, green, blue)
				task._Wait(1)
			end
		end
	end)
end
_editor_tasks["stage_3_boss_yuyuko_NoSpell2_bullettask"] = function(i, sv, sa, rsa)
	return function()
		local self = task.GetSelf()
		do
			local v, _d_v = (sv), (-sv / 59)
			for _ = 1, 60 do
				SetV2(self, v, sa, true, false)
				task._Wait(1)
				v = v + _d_v
			end
		end
		local la = Angle(self, player) + rsa * i
		do
			local v, _d_v = (0), (sv / 119)
			for _ = 1, 120 do
				SetV2(self, v, la, true, false)
				task._Wait(1)
				v = v + _d_v
			end
		end
	end
end

_editor_class["stage_3_boss_marisa_Spell2_star1"] = Class(bullet)
_editor_class["stage_3_boss_marisa_Spell2_star1"].init = function(self, _x, _y, dimode, i, i0, sv, sa)
	bullet.init(self, star_big, COLOR_BLUE, true, false)
	self.x, self.y = _x, _y
	self.rot, self.timer, self.colli, self.omiga, self.bound = sa, 11, false, 4 * i0, false
	self.hscale, self.vscale = 0, 0
	_object.set_color(self, "mul+add", 0, 128, 128, 128)
	local flag = { flag = 1 }
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("hscale", 1, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("vscale", 1, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			local v, _d_v = (sv), (-sv / 59)
			local si, _d_si = (0), (90 / 59)
			for _ = 1, 60 do
				SetV2(self, v, sa, false, false)
				_object.set_color(self, "mul+add", 255 * sin(si), 128, 128, 128)
				task._Wait(1)
				v = v + _d_v
				si = si + _d_si
			end
		end
		local dtim = 8
		do
			for _ = 1, 8 do
				last = New(_editor_class["stage_3_boss_marisa_Spell2_star1_effect"], self.x, self.y, 0.5, 32, 32, 255)
				task._Wait(dtim)
				if (dtim > 1) then
					dtim = dtim - 1
				else
					dtim = 1
				end
			end
		end
		task._Wait(30)
		PlaySound("don00", 0.1, 0, false)
		last = New(_editor_class["stage_3_boss_marisa_Spell2_star1_nuclear"], self.x, self.y, dimode, i, i0, flag, sa, 0.5, 32, 32, 255)
		lasttask = task.New(self, function()
			task._Wait(30)
			do
				local a, _d_a = (sa - 90 * i0), (180 * i0)
				for _ = 1, 2 do
					lasttask = task.New(self, _editor_tasks["stage_3_boss_marisa_Spell2_star1_task"](i, i0, a, 0.5 * 40))
					a = a + _d_a
				end
			end
		end)
		task._Wait(90)
		do
			local a, _d_a = (sa - 90 * i0), (180 * i0)
			for _ = 1, 2 do
				do
					local bsv, _d_bsv = (1), (11 / 7)
					local la, _d_la = (90 * i0), (360 / 2 * i0)
					for _ = 1, 8 do
						last = New(_editor_class["stage_3_boss_marisa_Spell2_star1_bullet"], self.x, self.y, dimode, i, i0, bsv, a, la)
						bsv = bsv + _d_bsv
						la = la + _d_la
					end
				end
				a = a + _d_a
			end
		end
		_del(self, true)
	end)
end
_editor_class["stage_3_boss_marisa_Spell2_star1_bullet"] = Class(bullet)
_editor_class["stage_3_boss_marisa_Spell2_star1_bullet"].init = function(self, _x, _y, dimode, i, i0, sv, sa, la)
	bullet.init(self, star_big, COLOR_DEEP_BLUE, true, false)
	self.x, self.y = _x, _y
	self.rot, self.omiga = sa, 4 * i0
	_object.set_color(self, "mul+add", 255, 255, 255, 255)
	self.starbutterflyflagen = 0
	lasttask = task.New(self, function()
		do
			local v, _d_v = (sv), (-sv / 59)
			for _ = 1, 60 do
				SetV2(self, v, sa, false, false)
				task._Wait(1)
				v = v + _d_v
			end
		end
		_object.set_color(self, "", 255, 255, 255, 255)
		do
			local v, _d_v = (0), (1 / 89)
			for _ = 1, 90 do
				SetV2(self, v, sa + la, false, false)
				task._Wait(1)
				v = v + _d_v
			end
		end
		self.starbutterflyflagen = 1
		lasttask = task.New(self, function()
			do
				for _ = 1, _infinite do
					for _, unit in ObjList(GROUP_INDES) do
						if (unit.starbutterflysignen == 1 and Dist(self, unit) < 16) then
							self.starbutterflyflagen = 0
							if true then
								break
							end
						else
						end
					end
					if (self.starbutterflyflagen == 0) then
						if true then
							break
						end
					else
					end
					task._Wait(1)
				end
			end
			PlaySound("nodamage", 1, 0, true)
			local la = Angle(self, player)
			local an = { an = self.rot, rx = 0, ry = 0 }
			lasttask = task.New(self, function()
				do
					for _ = 1, _infinite do
						an.an = self.rot
						task._Wait(1)
					end
				end
			end)
			do
				local bsa, _d_bsa = (0), (360 / 5 * i0)
				for _ = 1, 5 do
					last = New(_editor_class["stage_3_boss_marisa_Spell2_star1_bullet_slave"], self.x + 8 * cos(an.an + bsa), self.y + 8 * sin(an.an + bsa), dimode, i, i0, an, bsa)
					_connect(self, last, 0, false)
					bsa = bsa + _d_bsa
				end
			end
			self.rot, self.colli, self.bound = la, false, false
			_object.set_color(self, "", 0, 255, 255, 255)
			task._Wait(30)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("_speed", 0, 120, MOVE_DECEL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("omiga", 0, 120, MOVE_DECEL, nil, 0, MODE_SET)
			end)
			task._Wait(120)
			_del(self, false)
		end)
	end)
end
_editor_class["stage_3_boss_marisa_Spell2_star1_bullet_slave"] = Class(bullet)
_editor_class["stage_3_boss_marisa_Spell2_star1_bullet_slave"].init = function(self, _x, _y, dimode, i, i0, an, sa)
	bullet.init(self, grain_a, COLOR_DEEP_BLUE, true, false)
	self.x, self.y = _x, _y
	self.rot, self.timer, self.colli, self.bound = an.an + sa, 11, false, false
	self.hscale, self.vscale = 2, 2
	_object.set_color(self, "mul+add", 0, 255, 255, 255)
	self.sscale, self.alp = 2, 0
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("sscale", 1, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("alp", 255, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 30 do
				self.hscale, self.vscale = self.sscale, self.sscale
				_object.set_color(self, "mul+add", self.alp, 255, 255, 255)
				task._Wait(1)
			end
		end
		self.colli = true
	end)
	lasttask = task.New(self, function()
		if (dimode < 3) then
			do
				for _ = 1, 150 do
					_set_rel_pos(self, 8 * cos(an.an + sa), 8 * sin(an.an + sa), an.an + sa, false)
					task._Wait(1)
				end
			end
			self.bound = true
			_object.set_color(self, "", 255, 255, 255, 255)
			do
				local v, _d_v = (0), (2 / 119)
				for _ = 1, 120 do
					SetV2(self, v, select(2, GetV(self)), true, false)
					task._Wait(1)
					v = v + _d_v
				end
			end
		else
			do
				for _ = 1, 30 do
					_set_rel_pos(self, 8 * cos(an.an + sa), 8 * sin(an.an + sa), an.an + sa, false)
					task._Wait(1)
				end
			end
			do
				for _ = 1, 120 do
					_set_rel_pos(self, 8 * cos(an.an + sa), 8 * sin(an.an + sa), an.an + sa, false)
					task._Wait(1)
				end
			end
			self.bound = true
			do
				local v, _d_v = (3), (-3 / 29)
				for _ = 1, 30 do
					SetV2(self, v, select(2, GetV(self)), true, false)
					task._Wait(1)
					v = v + _d_v
				end
			end
			_del(self, true)
		end
	end)
end
_editor_tasks["stage_3_boss_marisa_Spell2_star1_task"] = function(i, i0, la, sr)
	return function()
		local self = task.GetSelf()
		self.r, self.alp = 0, 0
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("r", sr, 15, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("alp", 255, 15, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		local ia0, a = i0, la
		do
			for _ = 1, 15 do
				do
					for _ = 1, 2 do
						last = New(_editor_class["Seasons_laserwarning1"], self.x + self.r * cos(a), self.y + self.r * sin(a), ia0, self.x + self.r * cos(a), self.y + self.r * sin(a), 5, la, self.alp, 32, 32, 255, 4)
						ia0, a = -ia0, la - 90 * ia0
					end
				end
				task._Wait(1)
			end
		end
	end
end
_editor_class["stage_3_boss_marisa_Spell2_star1_nuclear"] = Class(_object)
_editor_class["stage_3_boss_marisa_Spell2_star1_nuclear"].init = function(self, _x, _y, dimode, i, i0, flag, sa, sca, red, green, blue)
	self.x, self.y = _x, _y
	self.layer = LAYER_ENEMY_BULLET - 1
	self.group = GROUP_INDES
	self.undestoryable = true
	self.hide = false
	self.bound = false
	self.navi = false
	self.hp = 10
	self.maxhp = 10
	self.colli = true
	self._servants = {}
	self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
	self.img = "qhm_nuclear01"
	self.rot, self.omiga = sa, 4 * i0
	self.hscale, self.vscale, self.a, self.b = 0, 0, 0, 0
	_object.set_color(self, "mul+add", 255, 255, 255, 255)
	last = New(_editor_class["stage_3_boss_marisa_Spell2_star1_nuclear_effect"], self.x, self.y, dimode, i, i0, flag, sa, sca, red, green, blue)
	_connect(self, last, 0, true)
	lasttask = task.New(self, function()
		if (dimode < 3) then
			do
				local si, _d_si = (0), (90 / 29)
				for _ = 1, 30 do
					self.hscale, self.vscale, self.a, self.b = -sca * sin(si) * i, sca * sin(si), 80 * self.hscale, 80 * self.vscale
					task._Wait(1)
					si = si + _d_si
				end
			end
			task._Wait(60)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("hscale", 0, 30, MOVE_ACCEL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("vscale", 0, 30, MOVE_ACCEL, nil, 0, MODE_SET)
			end)
			do
				for _ = 1, 30 do
					self.a, self.b = 80 * self.hscale, 80 * self.vscale
					task._Wait(1)
				end
			end
			_del(self, false)
		else
			do
				local si, _d_si = (0), (90 / 59)
				for _ = 1, 60 do
					self.hscale, self.vscale, self.a, self.b = -sca * sin(si) * i0, sca * sin(si), 80 * self.hscale, 80 * self.vscale
					task._Wait(1)
					si = si + _d_si
				end
			end
			do
				for _ = 1, _infinite do
					if (flag.flag > 0) then
						_set_rel_pos(self, 0, 0, self.rot, false)
					else
						if true then
							break
						end
					end
					task._Wait(1)
				end
			end
			task._Wait(90)
			self.colli = false
			do
				local si, _d_si = (0), (90 / 59)
				for _ = 1, 60 do
					self.hscale, self.vscale = -sca * i0 - sca * sin(si) * i0, sca + sca * sin(si)
					_object.set_color(self, "mul+add", 255 - 255 * sin(si), 255, 255, 255)
					task._Wait(1)
					si = si + _d_si
				end
			end
			_del(self, false)
		end
	end)
end
_editor_class["stage_3_boss_marisa_Spell2_star1_nuclear_effect"] = Class(_object)
_editor_class["stage_3_boss_marisa_Spell2_star1_nuclear_effect"].init = function(self, _x, _y, dimode, i, i0, flag, sa, sca, red, green, blue)
	self.x, self.y = _x, _y
	self.layer = LAYER_ENEMY_BULLET - 1
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
	self.img = "qhm_nuclear02"
	self.rot, self.omiga = sa, 4 * i0
	self.hscale, self.vscale = 0, 0
	_object.set_color(self, "mul+add", 255, red, green, blue)
	lasttask = task.New(self, function()
		if (dimode < 3) then
			do
				local si, _d_si = (0), (90 / 29)
				for _ = 1, 30 do
					self.hscale, self.vscale = -sca * sin(si) * i0, sca * sin(si)
					task._Wait(1)
					si = si + _d_si
				end
			end
			task._Wait(60)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("hscale", 0, 30, MOVE_ACCEL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("vscale", 0, 30, MOVE_ACCEL, nil, 0, MODE_SET)
			end)
			task._Wait(30)
			_del(self, false)
		else
			do
				local si, _d_si = (0), (90 / 59)
				for _ = 1, 60 do
					self.hscale, self.vscale = -sca * sin(si) * i, sca * sin(si)
					task._Wait(1)
					si = si + _d_si
				end
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				if (flag.flag > 0) then
					_set_rel_pos(self, 0, 0, self.rot, false)
				else
					if true then
						break
					end
				end
				task._Wait(1)
			end
		end
		task._Wait(90)
		do
			local si, _d_si = (0), (90 / 59)
			for _ = 1, 60 do
				self.hscale, self.vscale = -sca * i0 - sca * sin(si) * i0, sca + sca * sin(si)
				_object.set_color(self, "mul+add", 255 - 255 * sin(si), red, green, blue)
				task._Wait(1)
				si = si + _d_si
			end
		end
		_del(self, false)
	end)
end
_editor_class["stage_3_boss_marisa_Spell2_star1_effect"] = Class(_object)
_editor_class["stage_3_boss_marisa_Spell2_star1_effect"].init = function(self, _x, _y, sca, rr, gg, bb)
	self.x, self.y = _x, _y
	self.img = "image:seasons_forge_circle1"
	self.layer = LAYER_ENEMY + 1
	self.group = GROUP_GHOST
	self.hide = false
	self.bound = false
	self.navi = false
	self.hp = 10
	self.maxhp = 10
	self.colli = false
	self._servants = {}
	self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
	self.rot = ran:Float(0, 360)
	self.hscale, self.vscale = 0, 0
	_object.set_color(self, "mul+add", 255, rr, gg, bb)
	lasttask = task.New(self, function()
		do
			local si, _d_si = (0), (90 / 59)
			for _ = 1, 60 do
				_object.set_color(self, "mul+add", 255 - 255 * sin(si), rr, gg, bb)
				self.hscale, self.vscale = sca * sin(si), sca * sin(si)
				task._Wait(1)
				si = si + _d_si
			end
		end
		_del(self, false)
	end)
end
_editor_class["stage_3_boss_marisa_Spell2_star1_HL"] = Class(bullet)
_editor_class["stage_3_boss_marisa_Spell2_star1_HL"].init = function(self, _x, _y, dimode, i, i0, im, sv, sa)
	bullet.init(self, star_big, COLOR_BLUE, true, false)
	self.x, self.y = _x, _y
	self.rot, self.timer, self.colli, self.omiga, self.bound = sa, 11, false, 4 * i0, false
	self.hscale, self.vscale = 0, 0
	_object.set_color(self, "mul+add", 0, 128, 128, 128)
	self.alp = 0
	local flag = { flag = 1 }
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("hscale", 2, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("vscale", 2, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("alp", 128, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 30 do
				_object.set_color(self, "mul+add", self.alp, 128, 128, 128)
				task._Wait(1)
			end
		end
		lasttask = task.New(self, function()
			do
				for _ = 1, 6 do
					PlaySound("kira00", 0.1, 0, false)
					last = New(_editor_class["stage_3_boss_marisa_Spell2_star1_effect"], self.x, self.y, 1.5, 32, 32, 255)
					task._Wait(10)
				end
			end
			local dtim = 12
			do
				for _ = 1, 12 do
					PlaySound("kira00", 0.1, 0, false)
					last = New(_editor_class["stage_3_boss_marisa_Spell2_star1_effect"], self.x, self.y, 1.5, 32, 32, 255)
					task._Wait(dtim)
					if (dtim > 1) then
						dtim = dtim - 1
					else
						dtim = 1
					end
				end
			end
			task._Wait(30)
			New(boss_death_ef, self.x, self.y)
			last = New(_editor_class["stage_3_boss_marisa_Spell2_star1_nuclear"], self.x, self.y, dimode, i, i0, flag, sa, 1.5, 32, 32, 255)
			task._Wait(30)
			local way, dsca = { 0, 0, 12, 6 }, { 0, 0, 5, 3 }
			local ia0 = i0
			local im0 = im
			do
				local sca, _d_sca = (1.5), (dsca[dimode] / (way[dimode] - 1))
				local dr, _d_dr = (1), (5 / (way[dimode] - 1))
				for _ = 1, way[dimode] do
					PlaySound("tan00", 0.1, 0, false)
					last = New(_editor_class["stage_3_boss_marisa_Spell2_star1_HL_ring"], self.x, self.y, flag, sca, sa)
					_connect(self, last, 0, true)
					local way = { 0, 0, 30, 20 }
					do
						local st, _d_st = (1), (1)
						local a, _d_a = (sa), (360 / (2 * way[dimode] / 1) * ia0)
						for _ = 1, 2 do
							do
								local a0, _d_a0 = (a), (360 / way[dimode] * i0)
								for _ = 1, way[dimode] do
									last = New(_editor_class["stage_3_boss_marisa_Spell2_star1_HL_bullet"], self.x, self.y, dimode, i0, ia0, im0, flag, sca * 96, a0, st, 0.2, dr, self.x, self.y)
									_connect(self, last, 0, false)
									a0 = a0 + _d_a0
								end
							end
							st = st + _d_st
							a = a + _d_a
						end
					end
					ia0, im0 = -ia0, -im0
					sca = sca + _d_sca
					dr = dr + _d_dr
				end
			end
		end)
		lasttask = task.New(self, function()
			local sxarray, syarray = { 0, 0, 0, -224 * i0 }, { 0, 0, 256, 0 }
			task.MoveTo(sxarray[dimode], syarray[dimode], 90, MOVE_ACCEL)
			task._Wait(300)
			local dtim = 45
			do
				for _ = 1, 8 do
					local lsa = Angle(self, player)
					lasttask = task.New(self, _editor_tasks["stage_3_boss_marisa_Spell2_star1_HL_task"](dimode, i0, lsa))
					task._Wait(dtim)
					if (dtim > 5) then
						dtim = dtim - 5
					else
						dtim = 5
					end
				end
			end
			task._Wait(30)
			flag.flag = 0
			PlaySound("boon01", 0.1, 0, false)
			task._Wait(90)
			PlaySound("enep00", 0.1, 0, false)
			_del(self, true)
		end)
	end)
end
_editor_class["stage_3_boss_marisa_Spell2_star1_HL_bullet"] = Class(bullet)
_editor_class["stage_3_boss_marisa_Spell2_star1_HL_bullet"].init = function(self, _x, _y, dimode, i, i0, im, flag, sr, sa, st, ra, dr, lx, ly)
	bullet.init(self, star_big, COLOR_DEEP_BLUE, true, false)
	self.x, self.y = _x, _y
	self.rot, self.timer, self.colli, self.bound, self.omiga = sa, 11, false, false, -4 * i0
	self.hscale, self.vscale = 3, 3
	_object.set_color(self, "", 0, 255, 255, 255)
	self.alp, self.r, self.ra, self.dra, self.sign = 0, 0, 0, 0, 1
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("hscale", 1, 90, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("vscale", 1, 90, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("alp", 64, 90, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("r", sr, 90, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 90 do
				_object.set_color(self, "", self.alp, 255, 255, 255)
				task._Wait(1)
			end
		end
		task._Wait(15)
		PlaySound("kira00", 0.1, 0, false)
		if (st > 1) then
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("hscale", 0, 15, MOVE_DECEL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("vscale", 0, 15, MOVE_DECEL, nil, 0, MODE_SET)
			end)
			task._Wait(15)
			_del(self, false)
		else
			ChangeBulletImage(self, ball_light_dark, COLOR_DEEP_BLUE)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("hscale", 1, 0, MOVE_DECEL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("vscale", 1, 0, MOVE_DECEL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("hscale", 0.5, 15, MOVE_DECEL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("vscale", 0.5, 15, MOVE_DECEL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("alp", 255, 15, MOVE_DECEL, nil, 0, MODE_SET)
			end)
			do
				for _ = 1, 15 do
					_object.set_color(self, "mul+add", self.alp, 255, 255, 255)
					self.a, self.b = self.hscale * 12.5, self.vscale * 12.5
					task._Wait(1)
				end
			end
			self.colli = true
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("dra", ra, 60, MOVE_ACCEL, nil, 0, MODE_SET)
			end)
			do
				for _ = 1, _infinite do
					self.ra = self.ra + self.dra * im
					task._Wait(1)
				end
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				if (self.sign > 0) then
					_set_rel_pos(self, self.r * cos(sa + self.ra), self.r * sin(sa + self.ra), self.rot, false)
				else
					if true then
						break
					end
				end
				task._Wait(1)
			end
		end
		task._Wait(30)
		local way, angle = { 0, 0, 3, 2 }, { 0, 0, 180, 120 }
		PlaySound("kira00", 0.1, 0, false)
		do
			local bsa, _d_bsa = (Angle(self, lx, ly) - 180 * i - angle[dimode] / 2 * i0), (angle[dimode] * i0 / (way[dimode] - 1))
			for _ = 1, way[dimode] do
				last = New(_editor_class["stage_3_boss_marisa_Spell2_star1_HL_bullet_HL"], self.x, self.y, dimode, i, i0, 1, bsa)
				bsa = bsa + _d_bsa
			end
		end
		_del(self, true)
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				if (flag.flag > 0) then
				else
					if true then
						break
					end
				end
				task._Wait(1)
			end
		end
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("dra", 0, 60, MOVE_ACCEL, nil, 0, MODE_SET)
		end)
		task._Wait(60)
		self.sign = 0
	end)
end
_editor_class["stage_3_boss_marisa_Spell2_star1_HL_bullet_HL"] = Class(bullet)
_editor_class["stage_3_boss_marisa_Spell2_star1_HL_bullet_HL"].init = function(self, _x, _y, dimode, i, i0, sv, sa)
	bullet.init(self, star_small, COLOR_DEEP_BLUE, true, false)
	self.x, self.y = _x, _y
	self.rot, self.omiga = sa, 4 * i0
	_object.set_color(self, "mul+add", 255, 255, 255, 255)
	self.starbutterflyflaghl = 0
	lasttask = task.New(self, function()
		do
			local v, _d_v = (0), (sv / 89)
			for _ = 1, 90 do
				SetV2(self, v, sa, false, false)
				task._Wait(1)
				v = v + _d_v
			end
		end
		_object.set_color(self, "", 255, 255, 255, 255)
		self.starbutterflyflaghl = 1
		lasttask = task.New(self, function()
			do
				for _ = 1, _infinite do
					for _, unit in ObjList(GROUP_INDES) do
						if (unit.starbutterflysignhl == 1 and Dist(self, unit) < 16) then
							self.starbutterflyflaghl = 0
							if true then
								break
							end
						else
						end
					end
					if (self.starbutterflyflaghl == 0) then
						if true then
							break
						end
					else
					end
					task._Wait(1)
				end
			end
			PlaySound("nodamage", 1, 0, true)
			local la = Angle(self, player)
			local an = { an = self.rot }
			lasttask = task.New(self, function()
				do
					for _ = 1, _infinite do
						an.an = self.rot
						task._Wait(1)
					end
				end
			end)
			do
				local bsa, _d_bsa = (0), (360 / 5 * i0)
				for _ = 1, 5 do
					last = New(_editor_class["stage_3_boss_marisa_Spell2_star1_bullet_slave"], self.x + 8 * cos(an.an + bsa), self.y + 8 * sin(an.an + bsa), dimode, i, i0, an, bsa)
					_connect(self, last, 0, false)
					bsa = bsa + _d_bsa
				end
			end
			self.rot, self.colli, self.bound = la, false, false
			_object.set_color(self, "", 0, 255, 255, 255)
			task._Wait(30)
			self.colli = true
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("_speed", 0, 120, MOVE_DECEL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("omiga", 0, 120, MOVE_DECEL, nil, 0, MODE_SET)
			end)
			task._Wait(120)
			local lsa = Angle(self, player)
			--last = New(_editor_class["stage_3_boss_marisa_Spell2_star1_HL_bullet_laser"], self.x, self.y, i0, lsa, 5, 32, 32, 255, 480, 120, 6, 12, 12, 2)
			if difficulty == 4 then
				for i = 1, 8 do
					for j = 0, 1 do
						egg.AddSimStrChV(stg.newBulletStraight(stg.butterfly, 5, true, self.x, self.y, 0, 45 * i + 22.5 * j), 0, 1 + 0.5 * j, 45 * i + 22.5 * j, 60)
					end
				end
			else
				for i = 1, 6 do
					for j = 0, 0 do
						egg.AddSimStrChV(stg.newBulletStraight(stg.butterfly, 5, true, self.x, self.y, 0, 60 * i), 0, 1.25 + 1 * j, 60 * i, 60)
					end
				end
			end
			--task._Wait(30)
			_del(self, false)
		end)
	end)
end
_editor_tasks["stage_3_boss_marisa_Spell2_star1_HL_bullet_bullettask"] = function(sv, sa)
	return function()
		local self = task.GetSelf()
		do
			local v, _d_v = (0), (sv / 89)
			for _ = 1, 90 do
				SetV2(self, v, sa, false, false)
				task._Wait(1)
				v = v + _d_v
			end
		end
	end
end
_editor_class["stage_3_boss_marisa_Spell2_star1_HL_ring"] = Class(_object)
_editor_class["stage_3_boss_marisa_Spell2_star1_HL_ring"].init = function(self, _x, _y, flag, sca, sa)
	self.x, self.y = _x, _y
	self.img = "image:seasons_forge_ring1"
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
	self.hscale, self.vscale = 0, 0
	_object.set_color(self, "mul+add", 255, 32, 32, 255)
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("hscale", sca, 90, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("vscale", sca, 90, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, _infinite do
				if (flag.flag > 0) then
				else
					if true then
						break
					end
				end
				task._Wait(1)
			end
		end
		task._Wait(90)
		_del(self, true)
	end)
end
_editor_tasks["stage_3_boss_marisa_Spell2_star1_HL_task"] = function(dimode, i, sa)
	return function()
		local self = task.GetSelf()
		local way = 1
		local tim = { 0, 0, 20, 15 }
		do
			local sp, _d_sp = (0), (360 / (tim[dimode] - 1))
			for _ = 1, tim[dimode] do
				PlaySound("tan00", 0.1, 0, false)
				do
					local a, _d_a = (sa - sp / 2 * i), (sp * i / (way - 1))
					for _ = 1, way do
						--last = New(_editor_class["stage_3_boss_marisa_Spell2_star1_HL_bullet_laser"], self.x, self.y, i, a, 5, 96, 96, 255, 240, 60, 3, 18, 6, 1)
						if difficulty == 4 then
							for i = 0, 4 do
								egg.AddSimStrChV(stg.newBulletStraight(stg.butterfly, 5, true, self.x, self.y, 0, a), 0, 3 + 0.25 * i, a, 60)
							end
						else
							for i = 0, 2 do
								egg.AddSimStrChV(stg.newBulletStraight(stg.butterfly, 5, true, self.x, self.y, 0, a), 0, 2 + 0.3 * i, a, 60)
							end
						end

						a = a + _d_a
					end
				end
				task._Wait(60 / tim[dimode])
				if (way < 2) then
					way = way + 1
				else
					way = 2
				end
				sp = sp + _d_sp
			end
		end
	end
end
_editor_class["stage_3_boss_marisa_Spell2_star1_HL_bullet_laser"] = Class(laser)
_editor_class["stage_3_boss_marisa_Spell2_star1_HL_bullet_laser"].init = function(self, _x, _y, i, sa, cl, red, green, blue, L, dtim, sv, hw, w, lasermode)
	laser.init(self, cl, _x, _y, 0, 0, 0, 0, w, 0, 0)
	self.rot, self.l1, self.l3 = sa, 0, 0
	last = New(_editor_class["Seasons_laserwarning1"], self.x, self.y, i, self.x, self.y, cl, sa, 255, red, green, blue, hw)
	lasttask = task.New(self, function()
		task._Wait(30)
		laser._TurnOn(self, 0, false, false)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("l1", L / 2, dtim / 2, MOVE_NORMAL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("l3", L / 2, dtim / 2, MOVE_NORMAL, nil, 0, MODE_SET)
		end)
		task._Wait(15)
		SetV2(self, sv, sa, true, false)
	end)
	if (lasermode == 1) then
	elseif (lasermode == 2) then
		self.rx, self.ry = self.x, self.y
		lasttask = task.New(self, function()
			task._Wait(30)
			lasttask = task.New(self, function()
				do
					for _ = 1, _infinite do
						local rl = self.l1 + self.l3
						self.rx, self.ry = self.x + rl * cos(sa), self.y + rl * sin(sa)
						task._Wait(1)
					end
				end
			end)
			lasttask = task.New(self, function()
				do
					local lv, _d_lv = (1), (0.05)
					local si, _d_si = (0), (2880 / 359)
					for _ = 1, _infinite do
						last = New(_straight, grain_a, cl, self.rx, self.ry, 0, sa + 240 * sin(si) * i, false, 0, true, true, 0, false, 0, 0, 0, false)
						lasttask = task.New(last, _editor_tasks["stage_3_boss_marisa_Spell2_star1_HL_bullet_laser_bullettask"](lv, sa + 240 * sin(si) * i))
						task._Wait(3)
						lv = lv + _d_lv
						si = si + _d_si
					end
				end
			end)
		end)
	end
end
_editor_tasks["stage_3_boss_marisa_Spell2_star1_HL_bullet_laser_bullettask"] = function(lv, sa)
	return function()
		local self = task.GetSelf()
		do
			local v, _d_v = (0), (lv / 119)
			for _ = 1, 120 do
				SetV2(self, v, sa, true, false)
				task._Wait(1)
				v = v + _d_v
			end
		end
		task._Wait(120)
		_del(self, true)
	end
end
_editor_class["stage_3_boss_yuyuko_Spell2_starbutterfly"] = Class(bullet)
_editor_class["stage_3_boss_yuyuko_Spell2_starbutterfly"].init = function(self, _x, _y, dimode, i, sa, lx, ly, sscale)
	bullet.init(self, butterfly, COLOR_GRAY, true, false)
	self.x, self.y = _x, _y
	self.rot, self.timer, self.colli = sa, 11, false
	self.hscale, self.vscale = 0, 0
	_object.set_color(self, "mul+add", 128, 32, 32, 255)
	self.alp = 128
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("hscale", sscale, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("vscale", sscale, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		task._Wait(30)
		task.MoveTo(lx, ly, 120, MOVE_ACC_DEC)
		local dtim = 8
		do
			for _ = 1, 8 do
				PlaySound("kira00", 0.1, 0, false)
				last = New(_editor_class["stage_3_boss_marisa_Spell2_star1_effect"], self.x, self.y, sscale, 32, 32, 255)
				task._Wait(dtim)
				if (dtim > 1) then
					dtim = dtim - 1
				else
					dtim = 1
				end
			end
		end
		PlaySound("don00", 0.1, 0, false)
		local way = { 45, 60, 30, 45 }
		do
			local a, _d_a = (sa), (360 / way[dimode] * i)
			for _ = 1, way[dimode] do
				last = New(_editor_class["stage_3_boss_yuyuko_Spell2_starbutterfly_bullet1"], self.x + 12 * cos(a), self.y + 12 * sin(a), dimode, i, sscale, a, self.x + 92 * sscale * cos(a), self.y + 92 * sscale * sin(a))
				a = a + _d_a
			end
		end
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("alp", 0, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 60 do
				_object.set_color(self, "mul+add", self.alp, 32, 32, 255)
				task._Wait(1)
			end
		end
		_del(self, false)
	end)
	lasttask = task.New(self, function()
		task._Wait(30)
		do
			for _ = 1, 120 do
				last = New(_editor_class["stage_3_boss_yuyuko_Spell2_starbutterfly_effect"], self.x, self.y, u, sa, sscale, 32, 32, 255)
				task._Wait(1)
			end
		end
	end)
end
_editor_class["stage_3_boss_yuyuko_Spell2_starbutterfly_bullet1"] = Class(bullet)
_editor_class["stage_3_boss_yuyuko_Spell2_starbutterfly_bullet1"].init = function(self, _x, _y, dimode, i, sca, sa, lx, ly)
	bullet.init(self, butterfly, COLOR_BLUE, true, false)
	self.x, self.y = _x, _y
	self.rot, self.timer, self.colli = sa, 11, false
	self.hscale, self.vscale = sca * 2, sca * 2
	_object.set_color(self, "", 0, 255, 255, 255)
	self.alp = 0
	if (dimode < 3) then
		self.starbutterflysignen = 0
		lasttask = task.New(self, function()
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("hscale", sca, 15, MOVE_ACCEL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("vscale", sca, 15, MOVE_ACCEL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("alp", 128, 15, MOVE_ACCEL, nil, 0, MODE_SET)
			end)
			do
				for _ = 1, 15 do
					_object.set_color(self, "", self.alp, 255, 255, 255)
					task._Wait(1)
				end
			end
			self.starbutterflysignen = 1
			task.MoveTo(lx, ly, 120, MOVE_DECEL)
			_del(self, true)
		end)
	else
		self.starbutterflysignhl = 0
		lasttask = task.New(self, function()
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("hscale", sca, 15, MOVE_ACCEL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("vscale", sca, 15, MOVE_ACCEL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("alp", 128, 15, MOVE_ACCEL, nil, 0, MODE_SET)
			end)
			do
				for _ = 1, 15 do
					_object.set_color(self, "", self.alp, 255, 255, 255)
					task._Wait(1)
				end
			end
			self.starbutterflysignhl = 1
			task.MoveTo(lx, ly, 120, MOVE_DECEL)
			_del(self, true)
		end)
	end
end
_editor_class["stage_3_boss_yuyuko_Spell2_starbutterfly_effect"] = Class(bullet)
_editor_class["stage_3_boss_yuyuko_Spell2_starbutterfly_effect"].init = function(self, _x, _y, i, sa, sca, red, green, blue)
	bullet.init(self, butterfly, COLOR_GRAY, true, false)
	self.x, self.y = _x, _y
	self.rot, self.timer, self.colli = sa, 11, false
	self.hscale, self.vscale = sca, sca
	_object.set_color(self, "mul+add", 255, red, green, blue)
	self.alp = 255
	lasttask = task.New(self, function()
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
end

_editor_class["stage_3_boss_marisa_NoSpell3_circle"] = Class(_object)
_editor_class["stage_3_boss_marisa_NoSpell3_circle"].init = function(self, _x, _y, dimode, i, sr, sa, da, red, green, blue, bcl, la, xy)
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
	local tim, way1, way2, way3 = { 60, 80, 96, 160 }, { 6, 7, 8, 10 }, { 2, 2, 3, 3 }, { 3, 3, 5, 5 }
	self.rot, self.omiga = sa, -8 * i
	self.hscale, self.vscale = 0, 0
	_object.set_color(self, "mul+add", 255, red, green, blue)
	local ra = sa
	local ra0 = sa
	self.rr = 0
	self.rr0 = 0
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("rr", sr, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("rr0", sr, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("hscale", 0.3, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("vscale", 0.3, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 60 do
				_set_rel_pos(self, self.rr * cos(ra), self.rr * sin(ra), self.rot, false)
				task._Wait(1)
			end
		end
		lasttask = task.New(self, function()
			local ia = i
			local sv = 1
			do
				for _ = 1, tim[dimode] do
					PlaySound("kira02", 0.1, 0, false)
					last = New(_straight, star_small, bcl, self.x, self.y, sv, ra0, false, -4 * ia, true, true, 0, false, 0, 0, 0, false)
					_object.set_color(last, "", 255, 255, 255, 255)
					ia, sv = -ia, sv + 2 / (tim[dimode] - 1)
					task._Wait(480 / tim[dimode])
				end
			end
		end)
		local lra = Angle(xy.x, xy.y, player)
		lasttask = task.New(self, function()
			do
				local rr, _d_rr = (sr), (-sr / 2 / 479)
				local rr0, _d_rr0 = (sr), (-sr * 2 / 479)
				for _ = 1, 480 do
					self.rr, self.rr0 = rr, rr0
					task._Wait(1)
					rr = rr + _d_rr
					rr0 = rr0 + _d_rr0
				end
			end
		end)
		do
			for _ = 1, 480 do
				_set_rel_pos(self, self.rr0 * cos(lra) * cos(ra - lra) - self.rr * sin(lra) * sin(ra - lra), self.rr * cos(lra) * sin(ra - lra) + self.rr0 * sin(lra) * cos(ra - lra), self.rot, false)
				lra = Angle(self, player)
				task._Wait(1)
			end
		end
		PlaySound("enep00", 0.1, 0, false)
		do
			local bla, _d_bla = (ra), (360 * i / way1[dimode])
			for _ = 1, way1[dimode] do
				local way, sp = 1, 0
				do
					local lv, _d_lv = (1.5), (-0.5 / (way2[dimode] - 1))
					for _ = 1, way2[dimode] do
						do
							local ba, _d_ba = (bla - sp / 2 * i), (sp * i / (way - 1))
							for _ = 1, way do
								last = New(_straight, ball_mid_c, bcl, self.x, self.y, lv, ba, false, 0, true, true, 0, false, 0, 0, 0, false)
								lasttask = task.New(last, _editor_tasks["stage_3_boss_marisa_NoSpell_circle_task"](lv, ba))
								ba = ba + _d_ba
							end
						end
						if (way < 2) then
							way = way + 1
						else
							way = 2
						end
						sp = sp + 360 / way1[dimode] / way3[dimode] * 2 * i
						lv = lv + _d_lv
					end
				end
				bla = bla + _d_bla
			end
		end
		_del(self, true)
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				ra = ra + da * i
				ra0 = ra0 - da * i
				last = New(_editor_class["stage3_boss_marisa_circle_smear"], self.x, self.y, i, ra, self.hscale, red, green, blue)
				task._Wait(1)
			end
		end
	end)
end
_editor_class["stage_3_boss_yuyuko_NoSpell3_all"] = Class(_object)
_editor_class["stage_3_boss_yuyuko_NoSpell3_all"].init = function(self, _x, _y, dimode, i, sa)
	self.x, self.y = _x, _y
	self.img = "img_void"
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
	local laserlength, bullet1radius, bullet1tim, bullet1way, bullet2tim, bullet2way1, bullet2da1, bullet2way2, bullet2da2 = { 7.5, 7.5, 15, 15 }, { 22.5, 22.5, 45, 45 }, { 3, 3, 5, 5 }, { 12, 12, 16, 16 }, { 30, 40, 60, 80 }, { 3, 3, 4, 5 }, { 90, 90, 90, 90 }, { 1, 2, 3, 3 }, { 0, 30, 30, 30 }
	self.rot = sa
	self.rr, self.ra = 0, 0
	local an = { an = sa }
	local rsa = sa
	--[[这个戏是挺好的但是不适合放在三面
	--创建扇柄
	do
		local dsa, _d_dsa = (-45), (90 / (bullet1way[dimode] / 2 - 1))
		for _ = 1, bullet1way[dimode] / 2 do
			last = New(_editor_class["stage_3_boss_yuyuko_NoSpell3_all_lasereffect"], self.x, self.y, i, an, laserlength[dimode], laserlength[dimode], dsa)
			_connect(self, last, 0, true)
			dsa = dsa + _d_dsa
		end
	end
	--创建扇叶
	do
		local r, _d_r = (bullet1radius[dimode]), (bullet1radius[dimode] / (bullet1tim[dimode] - 1))
		for _ = 1, bullet1tim[dimode] do
			do
				local dsa, _d_dsa = (-45), (90 / (bullet1way[dimode] - 1))
				for _ = 1, bullet1way[dimode] do
					last = New(_editor_class["stage_3_boss_yuyuko_NoSpell3_all_bulleteffect"], self.x + r * cos(an.an), self.y + r * sin(an.an), i, an, r, dsa)
					_connect(self, last, 0, true)
					dsa = dsa + _d_dsa
				end
			end
			r = r + _d_r
		end
	end]]
	lasttask = task.New(self, function()
		task._Wait(15)
		PlaySound("kira00", 0.1, 0, false)
		task._Wait(45)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("rr", 45, 480, MOVE_ACC_DEC, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("ra", 1080, 480, MOVE_ACC_DEC, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			local bsv = 3
			do
				for _ = 1, bullet2tim[dimode] do
					do
						local dsa, _d_dsa = (-bullet2da1[dimode] / 2), (bullet2da1[dimode] / (bullet2way1[dimode] - 1))
						for _ = 1, bullet2way1[dimode] do
							last = New(_straight, butterfly, COLOR_GOLDEN_YELLOW, self.x + bullet1radius[dimode] * 2 * cos(an.an + dsa * i), self.y + bullet1radius[dimode] * 2 * sin(an.an + dsa * i), bsv, an.an + dsa * i, false, 0, true, true, 0, false, 0, 0, 0, false)
							last.bound = false
							lasttask = task.New(last, _editor_tasks["stage_3_boss_yuyuko_NoSpell3_all_bullettask"]())
							dsa = dsa + _d_dsa
						end
					end
					do
						local dsa, _d_dsa = (-bullet2da2[dimode] / 2), (bullet2da2[dimode] / (bullet2way2[dimode] - 1))
						for _ = 1, bullet2way2[dimode] do
							last = New(_straight, butterfly, COLOR_ROYAL_BLUE, self.x + bullet1radius[dimode] * 2 * cos(an.an + dsa * i), self.y + bullet1radius[dimode] * 2 * sin(an.an + dsa * i), bsv, an.an + dsa * i - 180 * i, false, 0, true, true, 0, false, 0, 0, 0, false)
							last.bound = false
							lasttask = task.New(last, _editor_tasks["stage_3_boss_yuyuko_NoSpell3_all_bullettask"]())
							dsa = dsa + _d_dsa
						end
					end
					bsv = bsv - 2 / (bullet2tim[dimode] - 1)
					task._Wait(480 / bullet2tim[dimode])
				end
			end
		end)
		do
			for _ = 1, 480 do
				_set_rel_pos(self, self.rr * cos(rsa + self.ra * i), self.rr * sin(rsa + self.ra * i), self.rot, false)
				an.an = rsa + self.ra * i
				task._Wait(1)
			end
		end
		task._Wait(60)
		_del(self, true)
	end)
end
_editor_tasks["stage_3_boss_yuyuko_NoSpell3_all_bullettask"] = function()
	return function()
		local self = task.GetSelf()
		task._Wait(60)
		self.bound = true
	end
end
_editor_class["stage_3_boss_yuyuko_NoSpell3_all_lasereffect"] = Class(laser)
_editor_class["stage_3_boss_yuyuko_NoSpell3_all_lasereffect"].init = function(self, _x, _y, i, an, l1, l2, dsa)
	laser.init(self, COLOR_DEEP_GREEN, _x, _y, 0, l1, l2, l1, 4, 0, 0)
	self.rot, self.bound = an.an, false
	self.da = 0
	lasttask = task.New(self, function()
		laser._TurnOn(self, 15, false, true)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("da", dsa, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 30 do
				self.rot = an.an + self.da * i
				task._Wait(1)
			end
		end
		task._Wait(15)
		do
			for _ = 1, 480 do
				self.rot = an.an + dsa * i
				task._Wait(1)
			end
		end
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("da", 0, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 30 do
				self.rot = an.an + self.da * i
				task._Wait(1)
			end
		end
		laser._TurnOff(self, 15, true)
		_del(self, false)
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				_set_rel_pos(self, 0, 0, self.rot, false)
				task._Wait(1)
			end
		end
	end)
end
_editor_class["stage_3_boss_yuyuko_NoSpell3_all_bulleteffect"] = Class(bullet)
_editor_class["stage_3_boss_yuyuko_NoSpell3_all_bulleteffect"].init = function(self, _x, _y, i, an, r, dsa)
	bullet.init(self, square, COLOR_DEEP_GREEN, true, false)
	self.x, self.y = _x, _y
	self.rot, self.timer, self.colli, self.bound = an.an, 11, false, false
	_object.set_color(self, "", 0, 255, 255, 255)
	self.vscale = 0
	self.da = 0
	lasttask = task.New(self, function()
		do
			local si, _d_si = (0), (90 / 14)
			for _ = 1, 15 do
				_object.set_color(self, "", 255 * sin(si), 255, 255, 255)
				self.vscale = sin(si)
				task._Wait(1)
				si = si + _d_si
			end
		end
		self.colli = true
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("da", dsa, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 30 do
				_set_rel_pos(self, r * cos(an.an + self.da * i), r * sin(an.an + self.da * i), self.rot, false)
				self.rot = an.an + self.da * i
				task._Wait(1)
			end
		end
		task._Wait(15)
		do
			for _ = 1, 480 do
				_set_rel_pos(self, r * cos(an.an + dsa * i), r * sin(an.an + dsa * i), self.rot, false)
				self.rot = an.an + dsa * i
				task._Wait(1)
			end
		end
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("da", 0, 30, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 30 do
				_set_rel_pos(self, r * cos(an.an + self.da * i), r * sin(an.an + self.da * i), self.rot, false)
				self.rot = an.an + self.da * i
				task._Wait(1)
			end
		end
		do
			local si, _d_si = (0), (90 / 14)
			for _ = 1, 15 do
				_object.set_color(self, "", 255 - 255 * sin(si), 255, 255, 255)
				self.vscale = 1 - sin(si)
				task._Wait(1)
				si = si + _d_si
			end
		end
		_del(self, false)
	end)
end

_editor_class["stage_3_boss_marisa_Spell3_obj1"] = Class(_object)
_editor_class["stage_3_boss_marisa_Spell3_obj1"].init = function(self, _x, _y, dimode, i, i0, im, sa, sway, red, green, blue, scl)
	self.x, self.y = _x, _y
	self.img = "image:seasons_forge_ring6"
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
	--[[ 以下难度列表分别是：自身自转速度，导入其他obj或者子弹的横向，导入其他obj或者子弹的纵向，圆环和子弹的发射间隔，圆环和子弹从起始到达终点的时间。 --]]--[=[
--]=]
	local omarray, shscale, svscale, dtim, btim, dran = { 0.25, 0.3, 0.4, 0.3 }, { 0.25, 0.25, 0.3, 0.3 }, { 0.5, 0.5, 0.6, 0.6 }, { 180, 120, 120, 180 }, { 540, 360, 360, 540 }, { 0.3, 0.3, 0.6, 0.6 }
	local xy = { x = self.x, y = self.y, rx = self.x, ry = self.y, rr = 0, rhscale = 0, rvscale = 0, an = sa, ran = 0 }
	self.rot, self.omiga = sa, omarray[dimode] * i
	self.hscale, self.vscale = 0, 0
	_object.set_color(self, "mul+add", 128, red, green, blue)
	last = New(_editor_class["stage_3_boss_marisa_Spell3_obj1_obj1"], self.x, self.y, dimode, i, i0, xy, red, green, blue)
	_connect(self, last, 0, true)
	do
		local bsa, _d_bsa = (0), (360 / sway * i)
		for _ = 1, sway do
			last = New(_editor_class["stage_3_boss_marisa_Spell3_obj1_laser"], self.x, self.y, dimode, i, i0, im, xy, bsa, red, green, blue, scl, dtim[dimode], btim[dimode])
			_connect(self, last, 0, true)
			bsa = bsa + _d_bsa
		end
	end
	self.rr = 0
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("rr", 272, 180, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("hscale", shscale[dimode], 180, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("vscale", svscale[dimode], 180, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 180 do
				xy.rr, xy.rhscale, xy.rvscale, xy.rr0 = self.rr, self.hscale, self.vscale, 96 * self.vscale
				task._Wait(1)
			end
		end
		xy.rr, xy.rhscale, xy.rvscale = 272, shscale[dimode], svscale[dimode]
		lasttask = task.New(self, function()
			--[[ 废弃 --]]
			do
				for _ = 1, _infinite do
					last = New(_editor_class["stage_3_boss_marisa_Spell3_obj1_obj2"], self.x, self.y, dimode, i, i0, im, xy, red, green, blue, btim[dimode], 1)
					_connect(self, last, 0, true)
					task._Wait(dtim[dimode])
				end
			end
		end)
		lasttask = task.New(self, function()
			--[[ 废弃 --]]
			if (dimode < 4) then
			else
				task._Wait(dtim[dimode] / 2)
				do
					for _ = 1, _infinite do
						last = New(_editor_class["stage_3_boss_marisa_Spell3_obj1_obj2"], xy.rx, xy.ry, dimode, i, i0, im, xy, red, green, blue, btim[dimode], 2)
						_connect(self, last, 0, true)
						task._Wait(dtim[dimode])
					end
				end
			end
		end)
		lasttask = task.New(self, function()
			task._Wait(360)
			local ia = i
			do
				for _ = 1, _infinite do
					do
						local om, _d_om = (omarray[dimode] * ia), (-omarray[dimode] * 2 * ia / 119)
						for _ = 1, 120 do
							self.omiga = om
							task._Wait(1)
							om = om + _d_om
						end
					end
					task._Wait(600)
					ia = -ia
				end
			end
		end)
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				xy.an, xy.ran = self.rot, xy.ran - dran[dimode] * i0
				xy.x, xy.y, xy.rx, xy.ry = self.x, self.y, self.x + xy.rr * cos(xy.an), self.y + xy.rr * sin(xy.an)
				task._Wait(1)
			end
		end
	end)
end
_editor_class["stage_3_boss_marisa_Spell3_obj1"].kill = function(self)
end
_editor_class["stage_3_boss_marisa_Spell3_obj1_obj1"] = Class(_object)
_editor_class["stage_3_boss_marisa_Spell3_obj1_obj1"].init = function(self, _x, _y, dimode, i, i0, sxy, red, green, blue)
	self.x, self.y = _x, _y
	self.img = "image:seasons_forge_ring6"
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
	self.rot = sxy.an
	self.hscale, self.vscale = 0, 0
	_object.set_color(self, "mul+add", 255, red, green, blue)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				_set_rel_pos(self, sxy.rr * cos(sxy.an), sxy.rr * sin(sxy.an), sxy.an, false)
				self.hscale, self.vscale = sxy.rhscale, sxy.rvscale
				task._Wait(1)
			end
		end
	end)
end
_editor_class["stage_3_boss_marisa_Spell3_obj1_obj1"].kill = function(self)
end
_editor_class["stage_3_boss_marisa_Spell3_obj1_obj2"] = Class(_object)
_editor_class["stage_3_boss_marisa_Spell3_obj1_obj2"].init = function(self, _x, _y, dimode, i, i0, im, sxy, red, green, blue, btim, mode)
	self.x, self.y = _x, _y
	self.img = "image:seasons_forge_ring4"
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
	self.rot = sxy.an
	self.hscale, self.vscale = sxy.rhscale, sxy.rvscale
	_object.set_color(self, "mul+add", 0, red, green, blue)
	local rr = 0
	lasttask = task.New(self, function()
		if (mode == 1) then
			task._Wait(30)
			_object.set_color(self, "mul+add", 128, red, green, blue)
			do
				for _ = 1, btim do
					rr = rr + sxy.rr / (btim - 1)
					_set_rel_pos(self, rr * cos(sxy.an), rr * sin(sxy.an), sxy.an, false)
					task._Wait(1)
				end
			end
			_del(self, false)
		elseif (mode == 2) then
			rr = Dist(sxy.rx, sxy.ry, sxy.x, sxy.y)
			task._Wait(30)
			_object.set_color(self, "mul+add", 128, red, green, blue)
			do
				for _ = 1, btim do
					rr = rr - sxy.rr / (btim - 1)
					_set_rel_pos(self, rr * cos(sxy.an), rr * sin(sxy.an), sxy.an, false)
					task._Wait(1)
				end
			end
			_del(self, false)
		end
	end)
end
_editor_class["stage_3_boss_marisa_Spell3_obj1_obj2"].kill = function(self)
end
_editor_class["stage_3_boss_marisa_Spell3_obj1_laser"] = Class(laser)
_editor_class["stage_3_boss_marisa_Spell3_obj1_laser"].init = function(self, _x, _y, dimode, i, i0, im, sxy, bsa, red, green, blue, scl, dtim, btim)
	laser.init(self, scl, _x, _y, 0, 0, 0, 0, 0, 0, 0)
	local xy = { x = self.x, y = self.y, an = sxy.an, r = 0 }
	self.rot, self.l2, self.w = sxy.an, 0, 0
	_object.set_color(self, "mul+add", 128, red, green, blue)
	laser._TurnHalfOn(self, 0, false)
	self.rx, self.ry = 0, 0
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("w", 2, 180, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		task._Wait(180)
		lasttask = task.New(self, function()
			if (dimode < 4) then
			else
				task._Wait(dtim / 2)
				do
					for _ = 1, _infinite do
						last = New(_editor_class["stage_3_boss_marisa_Spell3_obj1_laser_bullet"], self.rx, self.ry, dimode, i, i0, im, sxy, xy, bsa, scl, btim, 2)
						_connect(self, last, 0, true)
						task._Wait(dtim)
					end
				end
			end
		end)
		do
			for _ = 1, _infinite do
				last = New(_editor_class["stage_3_boss_marisa_Spell3_obj1_laser_bullet"], self.x, self.y, dimode, i, i0, im, sxy, xy, bsa, scl, btim, 1)
				_connect(self, last, 0, true)
				task._Wait(dtim)
			end
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				--[[ 废弃 --]]--[=[
            self.l2=Dist(sxy.x+96*sxy.rhscale*cos(sxy.an)*cos(sxy.ran+bsa)-96*sxy.rvscale*sin(sxy.an)*sin(sxy.ran+bsa),sxy.y+96*sxy.rvscale*cos(sxy.an)*sin(sxy.ran+bsa)+96*sxy.rhscale*sin(sxy.an)*cos(sxy.ran+bsa),sxy.rx+96*sxy.rhscale*cos(sxy.an)*cos(sxy.ran+bsa-180*i)-96*sxy.rvscale*sin(sxy.an)*sin(sxy.ran+bsa-180*i),sxy.ry+96*sxy.rvscale*cos(sxy.an)*sin(sxy.ran+bsa-180*i)+96*sxy.rhscale*sin(sxy.an)*cos(sxy.ran+bsa-180*i))
            xy.an=Angle(self,sxy.rx+96*sxy.rhscale*cos(sxy.an)*cos(sxy.ran+bsa-180*i)-96*sxy.rvscale*sin(sxy.an)*sin(sxy.ran+bsa-180*i),sxy.ry+96*sxy.rvscale*cos(sxy.an)*sin(sxy.ran+bsa-180*i)+96*sxy.rhscale*sin(sxy.an)*cos(sxy.ran+bsa-180*i))
            _set_rel_pos(self,96*sxy.rhscale*cos(sxy.an)*cos(sxy.ran+bsa)-96*sxy.rvscale*sin(sxy.an)*sin(sxy.ran+bsa),96*sxy.rvscale*cos(sxy.an)*sin(sxy.ran+bsa)+96*sxy.rhscale*sin(sxy.an)*cos(sxy.ran+bsa),Angle(self,sxy.rx+96*sxy.rhscale*cos(sxy.an)*cos(sxy.ran+bsa-180*i)-96*sxy.rvscale*sin(sxy.an)*sin(sxy.ran+bsa-180*i),sxy.ry+96*sxy.rvscale*cos(sxy.an)*sin(sxy.ran+bsa-180*i)+96*sxy.rhscale*sin(sxy.an)*cos(sxy.ran+bsa-180*i)),false)
        --]=]
				self.l2 = Dist(sxy.x, sxy.y, sxy.rx, sxy.ry)
				xy.an, xy.r = sxy.an, self.l2
				self.rx, self.ry = self.x + self.l2 * cos(sxy.an + bsa), self.y + self.l2 * sin(sxy.an + bsa)
				_set_rel_pos(self, 96 * sxy.rhscale * cos(sxy.an) * cos(sxy.ran + bsa) - 96 * sxy.rvscale * sin(sxy.an) * sin(sxy.ran + bsa), 96 * sxy.rvscale * cos(sxy.an) * sin(sxy.ran + bsa) + 96 * sxy.rhscale * sin(sxy.an) * cos(sxy.ran + bsa), sxy.an, false)
				task._Wait(1)
			end
		end
	end)
end
_editor_class["stage_3_boss_marisa_Spell3_obj1_laser"].kill = function(self)
end
_editor_class["stage_3_boss_marisa_Spell3_obj1_laser_bullet"] = Class(bullet)
_editor_class["stage_3_boss_marisa_Spell3_obj1_laser_bullet"].init = function(self, _x, _y, dimode, i, i0, im, sxy, xy, bsa, scl, btim, mode)
	bullet.init(self, star_small, scl, false, false)
	self.x, self.y = _x, _y
	local lr = last
	self.rot, self.timer, self.colli, self.bound, self.omiga = xy.an, 11, false, false, 2 * i
	self.hscale, self.vscale = 0, 0
	_object.set_color(self, "mul+add", 255, 255, 255, 255)
	self.rr = 0
	self.sign = 0
	local la = Angle(self, player)
	lasttask = task.New(self, function()
		if (mode == 1) then
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("hscale", 1, 30, MOVE_DECEL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("vscale", 1, 30, MOVE_DECEL, nil, 0, MODE_SET)
			end)
			task._Wait(30)
			self.colli, self.sign = true, 1
			do
				for _ = 1, btim do
					self.rr = self.rr + xy.r / (btim - 1)
					task._Wait(1)
				end
			end
			self.colli, self.sign = false, 0
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("hscale", 0, 30, MOVE_DECEL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("vscale", 0, 30, MOVE_DECEL, nil, 0, MODE_SET)
			end)
			task._Wait(30)
			_del(self, false)
		elseif (mode == 2) then
			self.rr = xy.r
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("hscale", 1, 30, MOVE_DECEL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("vscale", 1, 30, MOVE_DECEL, nil, 0, MODE_SET)
			end)
			task._Wait(30)
			self.colli, self.sign = true, 1
			do
				for _ = 1, btim do
					self.rr = self.rr - xy.r / (btim - 1)
					task._Wait(1)
				end
			end
			self.colli, self.sign = false, 0
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("hscale", 0, 30, MOVE_DECEL, nil, 0, MODE_SET)
			end)
			lasttask = task.New(self, function()
				ex.SmoothSetValueTo("vscale", 0, 30, MOVE_DECEL, nil, 0, MODE_SET)
			end)
			task._Wait(30)
			_del(self, false)
		end
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				_set_rel_pos(self, self.rr * cos(xy.an), self.rr * sin(xy.an), self.rot, false)
				task._Wait(1)
			end
		end
	end)
	if (dimode < 3) then
	else
		self.marisa_spell3_flag = 1
		lasttask = task.New(self, function()
			do
				for _ = 1, _infinite do
					if (IsValid(lstg.tmpvar.SPR)) then
						local unit = lstg.tmpvar.SPR
						if (unit.yuyuko_spell3_sign == 1 and self.sign == 1 and Dist(self, unit) < 96 * unit.rscale) then
							self.marisa_spell3_flag = 0
							if true then
								break
							end
						else
						end
					else
					end
					if (self.marisa_spell3_flag == 0) then
						if true then
							break
						end
					else
					end
					task._Wait(1)
				end
			end
			PlaySound("tan00", 0.1, 0, false)
			if (Dist(self, player) < 90) then
			elseif (dimode == 3) then
				la, way, sp = xy.an - 90 * i0, 1, 0
				do
					local sv, _d_sv = (1.1), (-0.1 / 1)
					for _ = 1, 2 do
						do
							local a, _d_a = (la - sp / 2 * i0), (sp * i0 / (way - 1))
							for _ = 1, way do
								last = New(_straight, butterfly, scl, self.x, self.y, 0, a, false, 0, true, true, 0, false, 0, 0, 0, false)
								lasttask = task.New(last, _editor_tasks["stage_3_boss_marisa_Spell3_obj1_laser_bullet_bullettask"](sv, a))
								a = a + _d_a
							end
						end
						way, sp = way + 1, sp + 10 * i0 / 1
						sv = sv + _d_sv
					end
				end
			elseif (dimode == 4) then
				la = xy.an - 90 * i0
				do
					local sv, _d_sv = (1), (0.25 / 1)
					for _ = 1, 2 do
						last = New(_straight, butterfly, scl, self.x, self.y, 0, la, false, 0, true, true, 0, false, 0, 0, 0, false)
						lasttask = task.New(last, _editor_tasks["stage_3_boss_marisa_Spell3_obj1_laser_bullet_bullettask"](sv, la))
						sv = sv + _d_sv
					end
				end
			end
			_del(self, true)
		end)
	end
end
_editor_tasks["stage_3_boss_marisa_Spell3_obj1_laser_bullet_bullettask"] = function(sv, sa)
	return function()
		local self = task.GetSelf()
		do
			local v, _d_v = (0), (sv / 119)
			for _ = 1, 120 do
				SetV2(self, v, sa, true, false)
				task._Wait(1)
				v = v + _d_v
			end
		end
	end
end
_editor_class["stage_3_boss_yuyuko_Spell3_dialog_lasereffect"] = Class(laser)
_editor_class["stage_3_boss_yuyuko_Spell3_dialog_lasereffect"].init = function(self, _x, _y, i, sa, l1, l2, dsa, xy)
	laser.init(self, COLOR_PURPLE, _x, _y, 0, l1, l2, l1, 4, 0, 0)
	self.group, self.layer = GROUP_GHOST, -605
	self.rot, self.colli, self.bound = sa, false, false
	self.da = 0
	lasttask = task.New(self, function()
		laser._TurnOn(self, 15, false, true)
		_object.set_color(self, "", 128, 255, 255, 255)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("da", dsa, 165, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 165 do
				self.rot = sa + self.da * i
				task._Wait(1)
			end
		end
		do
			for _ = 1, _infinite do
				if (IsValid(_boss)) then
				else
					if true then
						break
					end
				end
				task._Wait(1)
			end
		end
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("da", 0, 45, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 45 do
				self.rot = sa + self.da * i
				task._Wait(1)
			end
		end
		laser._TurnOff(self, 15, true)
		_del(self, false)
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				self.layer = -605
				if (IsValid(_boss)) then
					self.x, self.y = xy.x, xy.y
				else
					if true then
						break
					end
				end
				task._Wait(1)
			end
		end
	end)
end
_editor_class["stage_3_boss_yuyuko_Spell3_dialog_bulleteffect"] = Class(bullet)
_editor_class["stage_3_boss_yuyuko_Spell3_dialog_bulleteffect"].init = function(self, _x, _y, i, sa, r, dsa, xy)
	bullet.init(self, square, COLOR_PURPLE, true, false)
	self.x, self.y = _x, _y
	self.group, self.layer = GROUP_GHOST, -605
	self.rot, self.timer, self.colli, self.bound = sa, 11, false, false
	_object.set_color(self, "", 0, 255, 255, 255)
	self.vscale = 0
	self.da = 0
	lasttask = task.New(self, function()
		do
			local si, _d_si = (0), (90 / 14)
			for _ = 1, 15 do
				_object.set_color(self, "", 128 * sin(si), 255, 255, 255)
				self.vscale = sin(si)
				task._Wait(1)
				si = si + _d_si
			end
		end
		self.colli = true
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("da", dsa, 165, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 165 do
				self.x, self.y = xy.x + r * cos(sa + self.da * i), xy.y + r * sin(sa + self.da * i)
				self.rot = sa + self.da * i
				task._Wait(1)
			end
		end
		do
			for _ = 1, _infinite do
				if (IsValid(_boss)) then
					self.x, self.y = xy.x + r * cos(self.rot), xy.y + r * sin(self.rot)
				else
					if true then
						break
					end
				end
				task._Wait(1)
			end
		end
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("da", 0, 45, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 45 do
				self.x, self.y = xy.x + r * cos(sa + self.da * i), xy.y + r * sin(sa + self.da * i)
				self.rot = sa + self.da * i
				task._Wait(1)
			end
		end
		do
			local si, _d_si = (0), (90 / 14)
			for _ = 1, 15 do
				_object.set_color(self, "", 128 - 128 * sin(si), 255, 255, 255)
				self.vscale = 1 - sin(si)
				task._Wait(1)
				si = si + _d_si
			end
		end
		_del(self, false)
	end)
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				self.layer = -605
				task._Wait(1)
			end
		end
	end)
end
_editor_class["stage_3_boss_yuyuko_Spell3_spread"] = Class(_object)
_editor_class["stage_3_boss_yuyuko_Spell3_spread"].init = function(self, _x, _y, red, green, blue)
	self.x, self.y = _x, _y
	self.img = "image:seasons_forge_circle1"
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
	lstg.tmpvar.SPR = self   --用于与魔理沙星星碰撞的对象
	self.rot, self.yuyuko_spell3_sign = ran:Float(0, 360), 1
	self.hscale, self.vscale = 0, 0
	_object.set_color(self, "mul+add", 128, red, green, blue)
	self.rscale, self.alp = 0, 128
	lasttask = task.New(self, function()
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("hscale", 6, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("vscale", 6, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		lasttask = task.New(self, function()
			ex.SmoothSetValueTo("alp", 0, 60, MOVE_DECEL, nil, 0, MODE_SET)
		end)
		do
			for _ = 1, 60 do
				self.rscale = self.hscale
				_object.set_color(self, "mul+add", self.alp, red, green, blue)
				task._Wait(1)
			end
		end
		_del(self, false)
	end)
end

--endregion
