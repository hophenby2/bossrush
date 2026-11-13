--弹幕定义
do
	_editor_class["s1_LSC_eff"] = Class(_object)
	_editor_class["s1_LSC_eff"].init = function(self, _x, _y, size)
		self.x, self.y = _x, _y
		self.img = "preimg10"
		self.layer = LAYER_BG
		self.group = GROUP_ENEMY_BULLET
		self.hide = false
		self.bound = true
		self.navi = false
		self.hp = 10
		self.maxhp = 10
		self.colli = false
		self._servants = {}
		self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
		lasttask = task.New(self, function()
			do
				local x, _d_x = (0), (1 / 59)
				for _ = 1, 60 do
					_object.set_color(self, "mul+add", 255 * x, 255, 255, 255)
					self.hscale, self.vscale = size * (1 - x), size * (1 - x)
					task._Wait(1)
					x = x + _d_x
				end
			end
			_del(self, true)
		end)
	end
	_editor_class["s1_LSC_bamboo_spawn"] = Class(_object)
	_editor_class["s1_LSC_bamboo_spawn"].init = function(self, _x, _y, _)
		self.x, self.y = _x, _y
		self.img = "img_void"
		self.layer = LAYER_BG
		self.group = GROUP_ENEMY_BULLET
		self.hide = false
		self.bound = true
		self.navi = false
		self.hp = 10
		self.maxhp = 10
		self.colli = false
		self._servants = {}
		self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
		self.bound = false
		lasttask = task.New(self, function()
			if (difficulty == 4) then
				local a, len, size, wide = 90 + ran:Float(-5, 5), 80, 0.9, 2.65
				local u = ran:Sign()
				do
					local i, _d_i = (1), (1)
					for _ = 1, 9 do
						last = New(_editor_class["s1_LSC_stick"], self.x, self.y, a, len, 15, wide)
						task._Wait(10)
						self.x, self.y = self.x + len * cos(a), self.y + len * sin(a)
						last = New(_editor_class["s1_LSC_stick_spawn"], self.x, self.y, 2, 2, a + ran:Float(30, 45) * u)
						_connect(self, last, 0, true)
						last = New(_editor_class["s1_LSC_flat_ball"], self.x, self.y, a, size, 15)
						a = a + ran:Float(2, 4) * u
						len = max(40, len - 8)
						size = size - 0.07
						wide = wide - 0.175
						task._Wait(5)
						u = -u
						i = i + _d_i
					end
				end
			elseif (difficulty == 3) then
				local a, len, size, wide = 90 + ran:Float(-5, 5), 80, 0.9, 2.65
				local u = ran:Sign()
				do
					local i, _d_i = (1), (1)
					for _ = 1, 8 do
						last = New(_editor_class["s1_LSC_stick"], self.x, self.y, a, len, 15, wide)
						task._Wait(10)
						self.x, self.y = self.x + len * cos(a), self.y + len * sin(a)
						last = New(_editor_class["s1_LSC_stick_spawn"], self.x, self.y, 3, 3, a + ran:Float(30, 45) * u)
						_connect(self, last, 0, true)
						last = New(_editor_class["s1_LSC_flat_ball"], self.x, self.y, a, size, 15)
						a = a + ran:Float(2, 4) * u
						len = max(40, len - 8)
						size = size - 0.07
						wide = wide - 0.175
						task._Wait(5)
						u = -u
						i = i + _d_i
					end
				end
			elseif (difficulty == 2) then
				local a, len, size, wide = 90 + ran:Float(-5, 5), 80, 0.9, 2.65
				local u = ran:Sign()
				do
					local i, _d_i = (1), (1)
					for _ = 1, 7 do
						last = New(_editor_class["s1_LSC_stick"], self.x, self.y, a, len, 15, wide)
						task._Wait(10)
						self.x, self.y = self.x + len * cos(a), self.y + len * sin(a)
						last = New(_editor_class["s1_LSC_stick_spawn"], self.x, self.y, 3, 3, a + ran:Float(30, 45) * u)
						_connect(self, last, 0, true)
						last = New(_editor_class["s1_LSC_flat_ball"], self.x, self.y, a, size, 15)
						a = a + ran:Float(2, 4) * u
						len = max(40, len - 8)
						size = size - 0.07
						wide = wide - 0.175
						task._Wait(5)
						u = -u
						i = i + _d_i
					end
				end
			else
				local a, len, size, wide = 90 + ran:Float(-5, 5), 80, 0.9, 2.65
				local u = ran:Sign()
				do
					local i, _d_i = (1), (1)
					for _ = 1, 6 do
						last = New(_editor_class["s1_LSC_stick"], self.x, self.y, a, len, 15, wide)
						task._Wait(10)
						self.x, self.y = self.x + len * cos(a), self.y + len * sin(a)
						last = New(_editor_class["s1_LSC_stick_spawn"], self.x, self.y, 2, 2, a + ran:Float(30, 45) * u)
						_connect(self, last, 0, true)
						last = New(_editor_class["s1_LSC_flat_ball"], self.x, self.y, a, size, 15)
						a = a + ran:Float(2, 4) * u
						len = max(40, len - 8)
						size = size - 0.07
						wide = wide - 0.175
						task._Wait(5)
						u = -u
						i = i + _d_i
					end
				end
			end
			task._Wait(540)
			_del(self, false)
		end)
	end
	_editor_class["s1_LSC_stick_spawn"] = Class(_object)
	_editor_class["s1_LSC_stick_spawn"].init = function(self, _x, _y, flag, maxflag, a0)
		self.x, self.y = _x, _y
		self.img = "img_void"
		self.layer = LAYER_BG
		self.group = GROUP_ENEMY_BULLET
		self.hide = false
		self.bound = true
		self.navi = false
		self.hp = 10
		self.maxhp = 10
		self.colli = false
		self._servants = {}
		self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
		self.bound = false
		if (difficulty == 4) then
			lasttask = task.New(self, function()
				task._Wait(10)
				local a, len, size, wide = a0 + ran:Float(-10, 10), 20 + 20 * flag, 0.2 + 0.2 * flag, 0.25 + 0.25 * flag
				if (flag == maxflag) then
					task.Wait(60) --长出侧枝的时间
					last = New(_editor_class["s1_LSC_stick"], self.x, self.y, a, len, 15, wide)
					task._Wait(5)
					self.x, self.y = self.x + len * cos(a), self.y + len * sin(a)
					last = New(_editor_class["s1_LSC_ball"], self.x, self.y, a, size, 15)
					last = New(_editor_class["s1_LSC_stick_spawn"], self.x, self.y, flag - 1, maxflag, a0 + ran:Float(-10, 10))
					task.Wait(60) --长叶时间
					last = New(_editor_class["s1_LSC_leaf_spawn"], self.x, self.y, a0)
					task.Wait(90) --开花时间
					last = New(_editor_class["s1_LSC_flower"], self.x, self.y, a, 1.6, 15, 300)
				elseif (flag >= 0) then
					local _a = { a + ran:Float(20, 40), a - ran:Float(20, 40) }
					do
						local i, _d_i = (1), (1)
						for _ = 1, 2 do
							last = New(_editor_class["s1_LSC_stick"], self.x, self.y, _a[i], len, 15, wide)
							i = i + _d_i
						end
					end
					task._Wait(5)
					if (flag > 0) then
						do
							local i, _d_i = (1), (1)
							for _ = 1, 2 do
								last = New(_editor_class["s1_LSC_ball"], self.x + len * cos(_a[i]), self.y + len * sin(_a[i]), a, size, 15)
								last = New(_editor_class["s1_LSC_stick_spawn"], self.x + len * cos(_a[i]), self.y + len * sin(_a[i]), flag - 1, maxflag, a0 + ran:Float(-10, 10))
								i = i + _d_i
							end
						end
					elseif (flag == 0) then
						do
							local i, _d_i = (1), (1)
							for _ = 1, 2 do
								last = New(_editor_class["s1_LSC_stick_spawn"], self.x + len * cos(_a[i]), self.y + len * sin(_a[i]), flag - 1, maxflag, a0 + ran:Float(-10, 10))
								i = i + _d_i
							end
						end
						task.Wait(60) --长叶时间
						do
							local i, _d_i = (1), (1)
							for _ = 1, 2 do
								last = New(_editor_class["s1_LSC_leaf_spawn"], self.x, self.y, a0)
								i = i + _d_i
							end
						end
					end
				end
				_del(self, true)
			end)
		elseif (difficulty == 3) then
			lasttask = task.New(self, function()
				task._Wait(10)
				local a, len, size, wide = a0 + ran:Float(-10, 10), 20 + 20 * flag, 0.2 + 0.2 * flag, 0.25 + 0.25 * flag
				if (flag >= maxflag - 1) then
					task.Wait(60) --长出侧枝的时间
					last = New(_editor_class["s1_LSC_stick"], self.x, self.y, a, len, 15, wide)
					task._Wait(5)
					self.x, self.y = self.x + len * cos(a), self.y + len * sin(a)
					last = New(_editor_class["s1_LSC_ball"], self.x, self.y, a, size, 15)
					last = New(_editor_class["s1_LSC_stick_spawn"], self.x, self.y, flag - 1, maxflag, a0 + ran:Float(-10, 10))
					task.Wait(60) --长叶时间
					last = New(_editor_class["s1_LSC_leaf_spawn"], self.x, self.y, a0)
					task.Wait(90) --开花时间
					if (flag == maxflag) then
						last = New(_editor_class["s1_LSC_flower"], self.x, self.y, a, 1.6, 15, 300)
					else
					end
				elseif (flag >= 0) then
					local _a = { a + ran:Float(20, 40), a - ran:Float(20, 40) }
					do
						local i, _d_i = (1), (1)
						for _ = 1, 2 do
							last = New(_editor_class["s1_LSC_stick"], self.x, self.y, _a[i], len, 15, wide)
							i = i + _d_i
						end
					end
					task._Wait(5)
					if (flag > 0) then
						do
							local i, _d_i = (1), (1)
							for _ = 1, 2 do
								last = New(_editor_class["s1_LSC_ball"], self.x + len * cos(_a[i]), self.y + len * sin(_a[i]), a, size, 15)
								last = New(_editor_class["s1_LSC_stick_spawn"], self.x + len * cos(_a[i]), self.y + len * sin(_a[i]), flag - 1, maxflag, a0 + ran:Float(-10, 10))
								i = i + _d_i
							end
						end
					elseif (flag == 0) then
						do
							local i, _d_i = (1), (1)
							for _ = 1, 2 do
								last = New(_editor_class["s1_LSC_stick_spawn"], self.x + len * cos(_a[i]), self.y + len * sin(_a[i]), flag - 1, maxflag, a0 + ran:Float(-10, 10))
								i = i + _d_i
							end
						end
						task.Wait(60) --长叶时间
						do
							local i, _d_i = (1), (1)
							for _ = 1, 2 do
								last = New(_editor_class["s1_LSC_leaf_spawn"], self.x, self.y, a0)
								i = i + _d_i
							end
						end
					end
				end
				_del(self, true)
			end)
		elseif (difficulty == 2) then
			lasttask = task.New(self, function()
				task._Wait(10)
				local a, len, size, wide = a0 + ran:Float(-10, 10), 20 + 20 * flag, 0.2 + 0.2 * flag, 0.25 + 0.25 * flag
				if (flag >= maxflag - 1) then
					task.Wait(60) --长出侧枝的时间
					last = New(_editor_class["s1_LSC_stick"], self.x, self.y, a, len, 15, wide)
					task._Wait(5)
					self.x, self.y = self.x + len * cos(a), self.y + len * sin(a)
					last = New(_editor_class["s1_LSC_ball"], self.x, self.y, a, size, 15)
					last = New(_editor_class["s1_LSC_stick_spawn"], self.x, self.y, flag - 1, maxflag, a0 + ran:Float(-10, 10))
					task.Wait(60) --长叶时间
					last = New(_editor_class["s1_LSC_leaf_spawn"], self.x, self.y, a0)
					task.Wait(90) --开花时间(然而EN难度并不开花)
				elseif (flag >= 0) then
					local _a = { a + ran:Float(20, 40), a - ran:Float(20, 40) }
					do
						local i, _d_i = (1), (1)
						for _ = 1, 2 do
							last = New(_editor_class["s1_LSC_stick"], self.x, self.y, _a[i], len, 15, wide)
							i = i + _d_i
						end
					end
					task._Wait(5)
					if (flag > 0) then
						do
							local i, _d_i = (1), (1)
							for _ = 1, 2 do
								last = New(_editor_class["s1_LSC_ball"], self.x + len * cos(_a[i]), self.y + len * sin(_a[i]), a, size, 15)
								last = New(_editor_class["s1_LSC_stick_spawn"], self.x + len * cos(_a[i]), self.y + len * sin(_a[i]), flag - 1, maxflag, a0 + ran:Float(-10, 10))
								i = i + _d_i
							end
						end
					elseif (flag == 0) then
						do
							local i, _d_i = (1), (1)
							for _ = 1, 2 do
								last = New(_editor_class["s1_LSC_stick_spawn"], self.x + len * cos(_a[i]), self.y + len * sin(_a[i]), flag - 1, maxflag, a0 + ran:Float(-10, 10))
								i = i + _d_i
							end
						end
						task.Wait(60) --长叶时间
						do
							local i, _d_i = (1), (1)
							for _ = 1, 2 do
								last = New(_editor_class["s1_LSC_leaf_spawn"], self.x, self.y, a0)
								i = i + _d_i
							end
						end
					end
				end
				_del(self, true)
			end)
		else
			lasttask = task.New(self, function()
				task._Wait(10)
				local a, len, size, wide = a0 + ran:Float(-10, 10), 20 + 20 * flag, 0.2 + 0.2 * flag, 0.25 + 0.25 * flag
				if (flag == maxflag) then
					task.Wait(60) --长出侧枝的时间
					last = New(_editor_class["s1_LSC_stick"], self.x, self.y, a, len, 15, wide)
					task._Wait(5)
					self.x, self.y = self.x + len * cos(a), self.y + len * sin(a)
					last = New(_editor_class["s1_LSC_ball"], self.x, self.y, a, size, 15)
					last = New(_editor_class["s1_LSC_stick_spawn"], self.x, self.y, flag - 1, maxflag, a0 + ran:Float(-10, 10))
					task.Wait(60) --长叶时间
					last = New(_editor_class["s1_LSC_leaf_spawn"], self.x, self.y, a0)
					task.Wait(90) --开花时间(然而EN难度并不开花)
				elseif (flag >= 0) then
					local _a = { a + ran:Float(20, 40), a - ran:Float(20, 40) }
					do
						local i, _d_i = (1), (1)
						for _ = 1, 2 do
							last = New(_editor_class["s1_LSC_stick"], self.x, self.y, _a[i], len, 15, wide)
							i = i + _d_i
						end
					end
					task._Wait(5)
					if (flag > 0) then
						do
							local i, _d_i = (1), (1)
							for _ = 1, 2 do
								last = New(_editor_class["s1_LSC_ball"], self.x + len * cos(_a[i]), self.y + len * sin(_a[i]), a, size, 15)
								last = New(_editor_class["s1_LSC_stick_spawn"], self.x + len * cos(_a[i]), self.y + len * sin(_a[i]), flag - 1, maxflag, a0 + ran:Float(-10, 10))
								i = i + _d_i
							end
						end
					elseif (flag == 0) then
						do
							local i, _d_i = (1), (1)
							for _ = 1, 2 do
								last = New(_editor_class["s1_LSC_stick_spawn"], self.x + len * cos(_a[i]), self.y + len * sin(_a[i]), flag - 1, maxflag, a0 + ran:Float(-10, 10))
								i = i + _d_i
							end
						end
						task.Wait(60) --长叶时间
						do
							local i, _d_i = (1), (1)
							for _ = 1, 2 do
								last = New(_editor_class["s1_LSC_leaf_spawn"], self.x, self.y, a0)
								i = i + _d_i
							end
						end
					end
				end
				_del(self, true)
			end)
		end
	end
	_editor_class["s1_LSC_stick"] = Class(bullet)
	_editor_class["s1_LSC_stick"].init = function(self, _x, _y, a, len, t, wide)
		bullet.init(self, laserbullet, COLOR_GREEN, true, true)
		self.x, self.y = _x, _y
		_object.set_color(self, "mul+add", 255, 255, 255, 255)
		self.hscale, self.vscale = 0, wide
		self.b = 4 * wide
		local dh = len / 21 / t
		local dx, dy = len / 2 / t * cos(a), len / 2 / t * sin(a)
		self.rot = a
		lasttask = task.New(self, function()
			do
				for _ = 1, t do
					self.hscale = self.hscale + dh
					self.a = 10 * self.hscale
					self.x, self.y = self.x + dx, self.y + dy
					task._Wait(1)
				end
			end
			task._Wait(540)
			self.colli = false
			do
				local x, _d_x = (1), (-1 / 59)
				for _ = 1, 60 do
					_object.set_color(self, "mul+add", 255 * x, 255, 255, 255)
					task._Wait(1)
					x = x + _d_x
				end
			end
			_del(self, false)
		end)
	end
	_editor_class["s1_LSC_flat_ball"] = Class(bullet)
	_editor_class["s1_LSC_flat_ball"].init = function(self, _x, _y, a, size, t)
		bullet.init(self, ball_mid, COLOR_GREEN, true, true)
		self.x, self.y = _x, _y
		self.colli = false
		_object.set_color(self, "mul+add", 255, 255, 255, 255)
		self.rot = a
		self.hscale, self.vscale = 0, 0
		local ds = size / t
		lasttask = task.New(self, function()
			do
				for _ = 1, t do
					self.hscale, self.vscale = self.hscale + ds, self.vscale + 1.5 * ds
					self.a, self.b = 6 * self.hscale, 9 * self.vscale
					task._Wait(1)
				end
			end
			self.colli = true
			task._Wait(540)
			self.colli = false
			do
				local x, _d_x = (1), (-1 / 59)
				for _ = 1, 60 do
					_object.set_color(self, "mul+add", 255 * x, 255, 255, 255)
					task._Wait(1)
					x = x + _d_x
				end
			end
			_del(self, false)
		end)
	end
	_editor_class["s1_LSC_ball"] = Class(bullet)
	_editor_class["s1_LSC_ball"].init = function(self, _x, _y, a, size, t)
		bullet.init(self, ball_mid, COLOR_GREEN, true, true)
		self.x, self.y = _x, _y
		self.colli = false
		_object.set_color(self, "mul+add", 255, 255, 255, 255)
		self.rot = a
		self.hscale, self.vscale = 0, 0
		local ds = size / t
		lasttask = task.New(self, function()
			do
				for _ = 1, t do
					self.hscale, self.vscale = self.hscale + ds, self.vscale + ds
					self.a, self.b = 6 * self.hscale, 6 * self.vscale
					task._Wait(1)
				end
			end
			self.colli = true
			task._Wait(540)
			self.colli = false
			do
				local x, _d_x = (1), (-1 / 59)
				for _ = 1, 60 do
					_object.set_color(self, "mul+add", 255 * x, 255, 255, 255)
					task._Wait(1)
					x = x + _d_x
				end
			end
			_del(self, false)
		end)
	end
	_editor_class["s1_LSC_leaf_spawn"] = Class(_object)
	_editor_class["s1_LSC_leaf_spawn"].init = function(self, _x, _y, a)
		self.x, self.y = _x, _y
		self.img = "img_void"
		self.layer = LAYER_BG
		self.group = GROUP_ENEMY_BULLET
		self.hide = false
		self.bound = true
		self.navi = false
		self.hp = 10
		self.maxhp = 10
		self.colli = false
		self._servants = {}
		self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
		self.bound = false
		lasttask = task.New(self, function()
			local u = ran:Sign()
			do
				local dt, _d_dt = (30), (-10)
				local a0, _d_a0 = (a - 30 * u), (30 * u)
				for _ = 1, 3 do
					PlaySound("kira00", 0.1, 0, false)
					last = New(_editor_class["s1_LSC_leaf"], self.x + 10 * cos(a0), self.y + 10 * sin(a0), a0, 1, 20, 120 + dt, a)
					task._Wait(10)
					dt = dt + _d_dt
					a0 = a0 + _d_a0
				end
			end
			_del(self, true)
		end)
	end
	_editor_class["s1_LSC_leaf"] = Class(bullet)
	_editor_class["s1_LSC_leaf"].init = function(self, _x, _y, a, size, t, dt, a0)
		bullet.init(self, kite, COLOR_GREEN, true, true)
		self.x, self.y = _x, _y
		self.colli = false
		self.rot = a
		self.hscale, self.vscale = 0, 0
		local ds = size / t
		lasttask = task.New(self, function()
			self.layer = LAYER_ENEMY_BULLET+1
			do
				for _ = 1, t do
					self.hscale, self.vscale = self.hscale + ds, self.vscale + 0.75 * ds
					self.a, self.b = 6 * self.hscale, 4.5 * self.vscale
					task._Wait(1)
				end
			end
			self.colli = true
			task._Wait(dt)
			PlaySound("kira00", 0.1, 0, false)
			self.navi = true
			local da = a - a0
			self.layer = LAYER_ENEMY_BULLET+2
			if (difficulty == 4) then
				AddSimStrChV(self, 0, -0.25, a, 60, nil, nil, nil)
				AddSimStrChV(self, 0, 2, a + 180 - 2.5 * da, 240, nil, nil, 30)
			elseif (difficulty == 3) then
				AddSimStrChV(self, 0, -0.25, a, 60, nil, nil, nil)
				AddSimStrChV(self, 0, 1.75, a + 180 - 2.5 * da, 240, nil, nil, 30)
			elseif (difficulty == 2) then
				AddSimStrChV(self, 0, -0.25, a, 60, nil, nil, nil)
				AddSimStrChV(self, 0, 1.5, a + 180 - 2.5 * da, 240, nil, nil, 30)
			else
				AddSimStrChV(self, 0, -0.25, a, 60, nil, nil, nil)
				AddSimStrChV(self, 0, 1.25, a + 180 - 2.5 * da, 240, nil, nil, 30)
			end
		end)
	end
	_editor_class["s1_LSC_flower"] = Class(bullet)
	_editor_class["s1_LSC_flower"].init = function(self, _x, _y, a, size, t, dt)
		bullet.init(self, ball_mid, COLOR_DEEP_PURPLE, true, true)
		self.x, self.y = _x, _y
		self.bound = false
		self.colli = false
		self.rot = a
		self.hscale, self.vscale = 0, 0
		local ds = size / t
		lasttask = task.New(self, function()
			self.layer = LAYER_ENEMY_BULLET + 1
			do
				local a, _d_a = (0), (60)
				for _ = 1, 6 do
					last = New(_editor_class["s1_LSC_petal"], self.x, self.y, self, a, 15)
					a = a + _d_a
				end
			end
		end)
		lasttask = task.New(self, function()
			do
				for _ = 1, t do
					self.hscale, self.vscale = self.hscale + ds, self.vscale + ds
					self.a, self.b = 3 * self.hscale, 3 * self.vscale
					task._Wait(1)
				end
			end
			self.colli = true
			task._Wait(dt)
			PlaySound("kira00", 0.1, 0, false)
			AddSimStrChV(self, 0, ran:Float(-0.5, 0.5), 0, 120)
			AddSimStrChV(self, 0, 3, -90, 240)
			lasttask = task.New(self, function()
				do
					for _ = 1, 120 do
						self.omiga = self.omiga + 0.02
						task._Wait(1)
					end
				end
			end)
		end)
	end
	_editor_class["s1_LSC_flower"].frame = function(self)
		self.class.base.frame(self)
		if self.y <= -300 then
			Del(self)
		end
	end
	_editor_class["s1_LSC_petal"] = Class(bullet)
	_editor_class["s1_LSC_petal"].init = function(self, _x, _y, mst, a0, t)
		bullet.init(self, arrow_big, 4, true, true)
		self.x, self.y = _x, _y
		self.bound = false
		self.mst = mst
		self._da = a0
		self.hscale, self.vscale = 0, 0
		local ds = 0.8 / t
		self.colli = false
		lasttask = task.New(self, function()
			self.layer = LAYER_ENEMY_BULLET + 1
			do
				for _ = 1, t do
					self.hscale, self.vscale = self.hscale + 0.75 * ds, self.vscale + 1.8 * ds
					self.a, self.b = 4 * self.hscale, 4 * self.vscale
					task._Wait(1)
				end
			end
			self.colli = true
		end)
	end
	_editor_class["s1_LSC_petal"].frame = function(self)
		self.class.base.frame(self)
		if IsValid(self.mst) then
			self.rot = self.mst.rot + self._da
			self.x, self.y = self.mst.x + 13 * cos(self.rot), self.mst.y + 13 * sin(self.rot)
		else
			Del(self)
		end
	end
end

-- 创建一个 辉夜 boss 类
local function create_boss_class(class_name, group_name)
	local cls = Class(boss)
	_editor_class[class_name] = cls
	cls.cards = {}
	cls._name = class_name
	cls.name = "Kaguya"
	cls.bgm = "s1_boss"
	cls._bg = stage1_background
	cls.difficulty = group_name
	function cls:init(cards)
		boss.init(self, 0, 0, "Kaguya", cards, New(s1_boss.scbg), group_name)
		lstg.wis.Kaguya(self)
	end
	return cls
end

-- lsc符卡前事件
local function create_lscEvent_class(self)
	local _show = boss.dialog.New(true)
	function _show:init()
		player.dialog=false
		self.dialog_displayer=New(dialog_displayer)
		self._dialog_maintask=task.New(self,function()
			lscNoBombCheck(self)
		end)
	end
	return _show
end

-- 创建一个符卡
local function create_card_class(boss_class, name, timet, hp, dropt, mode, advance)
	local _sc = boss.card.New(name, timet[1], timet[2], timet[3], hp, dropt, false, mode)
	_sc.perform = true
	table.insert(boss_class.cards, _sc)
	table.insert(_sc_table, { boss_class._name, name, _sc, #boss_class.cards, true })
	return _sc
end

-- 公共事件
local function common_card_action_before(self)
	-- last spell 特殊事件
	--New(lscSpecialEvent, self)
	boss.show_aura(self, true)
	-- 淡入事件
	self.colli = false
	_object.set_color(self, "", 0, 255, 255, 255)
	task.New(self, function()
		do
			local x, _d_x = (0), (90 / 59)
			for _ = 1, 60 do
				_object.set_color(self, "", 255 * sin(x), 255, 255, 255)
				task._Wait(1)
				x = x + _d_x
			end
		end
		self.colli = true
	end)
	-- 移动事件
	task.New(self, function()
		task.Wait(60)
		task.MoveTo(0, 144, 60, MOVE_NORMAL)
		task.Wait(420)
		while true do
			task.MoveToPlayer(60,
					-96, 96, 112, 144,
					16, 32, 8, 16,
					MOVE_NORMAL, MOVE_TOWARDS_PLAYER)
			task.Wait(180)
		end
	end)
	-- 开卡特效
	task.New(self, function()
		s1_boss.pic_show()
		task.Wait(120)
		task.Wait(10)
		New(AbEff, self.x, self.y, "bamboo_leaf_white", "tree_leaf_white", 106, 207, 120)
		task.Wait(60)
	end)
end

--Easy
do
	local boss_class = create_boss_class("LSC1:Easy", "Easy")
	table.insert(boss_class.cards, create_lscEvent_class(self))
	local boss_card = create_card_class(boss_class, "「青竹葳蕤 其势之盛」",
			{ 5, 5, 55 }, 3000, { 0, 0, 60 }, "lastspell", false)
	function boss_card:init()
		common_card_action_before(self)
		lasttask = task.New(self, function()
			task.Wait(190)
			do
				do
					local dy, _d_dy = (480), (-40)
					for _ = 1, 12 do
						do
							local x, _d_x = (-175), (350 / 2)
							for _ = 1, 3 do
								last = New(_editor_class["s1_LSC_eff"], x, -224 + dy, 10)
								x = x + _d_x
							end
						end
						task._Wait(6)
						dy = dy + _d_dy
					end
				end
				task._Wait(10)
				lasttask = task.New(self, function()
					do
						local dy, _d_dy = (0), (25)
						for _ = 1, 20 do
							do
								local x, _d_x = (-175), (350 / 2)
								for _ = 1, 3 do
									last = New(_editor_class["s1_LSC_eff"], x, -224 + dy, 12)
									x = x + _d_x
								end
							end
							task._Wait(6)
							dy = dy + _d_dy
						end
					end
				end)
				do
					local x, _d_x = (-175), (350 / 2)
					for _ = 1, 3 do
						last = New(_editor_class["s1_LSC_bamboo_spawn"], x, -235, _)
						_connect(self, last, 0, true)
						x = x + _d_x
					end
				end
			end
			task._Wait(720)
			do
				for _ = 1, _infinite do
					do
						local dy, _d_dy = (480), (-40)
						for _ = 1, 12 do
							do
								local x, _d_x = (-175), (350 / 3)
								for _ = 1, 4 do
									last = New(_editor_class["s1_LSC_eff"], x, -224 + dy, 10)
									x = x + _d_x
								end
							end
							task._Wait(6)
							dy = dy + _d_dy
						end
					end
					task._Wait(10)
					lasttask = task.New(self, function()
						do
							local dy, _d_dy = (0), (25)
							for _ = 1, 20 do
								do
									local x, _d_x = (-175), (350 / 3)
									for _ = 1, 4 do
										last = New(_editor_class["s1_LSC_eff"], x, -224 + dy, 12)
										x = x + _d_x
									end
								end
								task._Wait(6)
								dy = dy + _d_dy
							end
						end
					end)
					do
						local x, _d_x = (-175), (350 / 3)
						for _ = 1, 4 do
							last = New(_editor_class["s1_LSC_bamboo_spawn"], x, -235, _)
							_connect(self, last, 0, true)
							x = x + _d_x
						end
					end
					task._Wait(720)
				end
			end
		end)
	end
	function boss_card:del()
		Spell_break_eff(self.x, self.y, 106, 207, 120,
				"bamboo_leaf_white", "tree_leaf_white")
	end
end

--Normal
do
	local boss_class = create_boss_class("LSC1:Normal", "Normal")
	table.insert(boss_class.cards, create_lscEvent_class(self))
	local boss_card = create_card_class(boss_class, "「青竹葳蕤 其势之盛」",
			{ 5, 5, 55 }, 3000, { 0, 0, 60 }, "lastspell", false)
	function boss_card:init()
		common_card_action_before(self)
		lasttask = task.New(self, function()
			task.Wait(190)
			do
				do
					local dy, _d_dy = (480), (-40)
					for _ = 1, 12 do
						do
							local x, _d_x = (-175), (350 / 2)
							for _ = 1, 3 do
								last = New(_editor_class["s1_LSC_eff"], x, -224 + dy, 10)
								x = x + _d_x
							end
						end
						task._Wait(6)
						dy = dy + _d_dy
					end
				end
				task._Wait(10)
				lasttask = task.New(self, function()
					do
						local dy, _d_dy = (0), (25)
						for _ = 1, 20 do
							do
								local x, _d_x = (-175), (350 / 2)
								for _ = 1, 3 do
									last = New(_editor_class["s1_LSC_eff"], x, -224 + dy, 12)
									x = x + _d_x
								end
							end
							task._Wait(6)
							dy = dy + _d_dy
						end
					end
				end)
				do
					local x, _d_x = (-175), (350 / 2)
					for _ = 1, 3 do
						last = New(_editor_class["s1_LSC_bamboo_spawn"], x, -235, _)
						_connect(self, last, 0, true)
						x = x + _d_x
					end
				end
			end
			task._Wait(720)
			do
				for _ = 1, _infinite do
					do
						local dy, _d_dy = (480), (-40)
						for _ = 1, 12 do
							do
								local x, _d_x = (-175), (350 / 3)
								for _ = 1, 4 do
									last = New(_editor_class["s1_LSC_eff"], x, -224 + dy, 10)
									x = x + _d_x
								end
							end
							task._Wait(6)
							dy = dy + _d_dy
						end
					end
					task._Wait(10)
					lasttask = task.New(self, function()
						do
							local dy, _d_dy = (0), (25)
							for _ = 1, 20 do
								do
									local x, _d_x = (-175), (350 / 3)
									for _ = 1, 4 do
										last = New(_editor_class["s1_LSC_eff"], x, -224 + dy, 12)
										x = x + _d_x
									end
								end
								task._Wait(6)
								dy = dy + _d_dy
							end
						end
					end)
					do
						local x, _d_x = (-175), (350 / 3)
						for _ = 1, 4 do
							last = New(_editor_class["s1_LSC_bamboo_spawn"], x, -235, _)
							_connect(self, last, 0, true)
							x = x + _d_x
						end
					end
					task._Wait(720)
				end
			end
		end)
	end
	function boss_card:del()
		Spell_break_eff(self.x, self.y, 106, 207, 120,
				"bamboo_leaf_white", "tree_leaf_white")
	end
end

--Hard
do
	local boss_class = create_boss_class("LSC1:Hard", "Hard")
	table.insert(boss_class.cards, create_lscEvent_class(self))
	local boss_card = create_card_class(boss_class, "「竹花之辉 生之须臾」",
			{ 5, 5, 55 }, 3000, { 0, 0, 60 }, "lastspell", false)
	function boss_card:init()
		common_card_action_before(self)
		lasttask = task.New(self, function()
			task.Wait(190)
			do
				do
					local dy, _d_dy = (480), (-40)
					for _ = 1, 12 do
						do
							local x, _d_x = (-175), (350 / 3)
							for _ = 1, 4 do
								last = New(_editor_class["s1_LSC_eff"], x, -224 + dy, 10)
								x = x + _d_x
							end
						end
						task._Wait(6)
						dy = dy + _d_dy
					end
				end
				task._Wait(10)
				lasttask = task.New(self, function()
					do
						local dy, _d_dy = (0), (25)
						for _ = 1, 20 do
							do
								local x, _d_x = (-175), (350 / 3)
								for _ = 1, 4 do
									last = New(_editor_class["s1_LSC_eff"], x, -224 + dy, 12)
									x = x + _d_x
								end
							end
							task._Wait(6)
							dy = dy + _d_dy
						end
					end
				end)
				do
					local x, _d_x = (-175), (350 / 3)
					for _ = 1, 4 do
						last = New(_editor_class["s1_LSC_bamboo_spawn"], x, -235, _)
						_connect(self, last, 0, true)
						x = x + _d_x
					end
				end
			end
			task._Wait(720)
			do
				for _ = 1, _infinite do
					do
						local dy, _d_dy = (480), (-40)
						for _ = 1, 12 do
							do
								local x, _d_x = (-175), (350 / 4)
								for _ = 1, 5 do
									last = New(_editor_class["s1_LSC_eff"], x, -224 + dy, 10)
									x = x + _d_x
								end
							end
							task._Wait(6)
							dy = dy + _d_dy
						end
					end
					task._Wait(10)
					lasttask = task.New(self, function()
						do
							local dy, _d_dy = (0), (25)
							for _ = 1, 20 do
								do
									local x, _d_x = (-175), (350 / 4)
									for _ = 1, 5 do
										last = New(_editor_class["s1_LSC_eff"], x, -224 + dy, 12)
										x = x + _d_x
									end
								end
								task._Wait(6)
								dy = dy + _d_dy
							end
						end
					end)
					do
						local x, _d_x = (-175), (350 / 4)
						for _ = 1, 5 do
							last = New(_editor_class["s1_LSC_bamboo_spawn"], x, -235, _)
							_connect(self, last, 0, true)
							x = x + _d_x
						end
					end
					task._Wait(720)
				end
			end
		end)
	end
	function boss_card:del()
		Spell_break_eff(self.x, self.y, 106, 207, 120,
				"bamboo_leaf_white", "tree_leaf_white")
	end
end

--Lunatic
do
	local boss_class = create_boss_class("LSC1:Lunatic", "Lunatic")
	table.insert(boss_class.cards, create_lscEvent_class(self))
	local boss_card = create_card_class(boss_class, "「竹花之辉 生之须臾」",
			{ 5, 5, 55 }, 3000, { 0, 0, 60 }, "lastspell", false)
	function boss_card:init()
		common_card_action_before(self)
		lasttask = task.New(self, function()
			task.Wait(190)
			do
				do
					local dy, _d_dy = (480), (-40)
					for _ = 1, 12 do
						do
							local x, _d_x = (-175), (350 / 3)
							for _ = 1, 4 do
								last = New(_editor_class["s1_LSC_eff"], x, -224 + dy, 10)
								x = x + _d_x
							end
						end
						task._Wait(6)
						dy = dy + _d_dy
					end
				end
				task._Wait(10)
				lasttask = task.New(self, function()
					do
						local dy, _d_dy = (0), (25)
						for _ = 1, 20 do
							do
								local x, _d_x = (-175), (350 / 3)
								for _ = 1, 4 do
									last = New(_editor_class["s1_LSC_eff"], x, -224 + dy, 12)
									x = x + _d_x
								end
							end
							task._Wait(6)
							dy = dy + _d_dy
						end
					end
				end)
				do
					local x, _d_x = (-175), (350 / 3)
					for _ = 1, 4 do
						last = New(_editor_class["s1_LSC_bamboo_spawn"], x, -235, _)
						_connect(self, last, 0, true)
						x = x + _d_x
					end
				end
			end
			task._Wait(720)
			do
				for _ = 1, _infinite do
					do
						local dy, _d_dy = (480), (-40)
						for _ = 1, 12 do
							do
								local x, _d_x = (-175), (350 / 4)
								for _ = 1, 5 do
									last = New(_editor_class["s1_LSC_eff"], x, -224 + dy, 10)
									x = x + _d_x
								end
							end
							task._Wait(6)
							dy = dy + _d_dy
						end
					end
					task._Wait(10)
					lasttask = task.New(self, function()
						do
							local dy, _d_dy = (0), (25)
							for _ = 1, 20 do
								do
									local x, _d_x = (-175), (350 / 4)
									for _ = 1, 5 do
										last = New(_editor_class["s1_LSC_eff"], x, -224 + dy, 12)
										x = x + _d_x
									end
								end
								task._Wait(6)
								dy = dy + _d_dy
							end
						end
					end)
					do
						local x, _d_x = (-175), (350 / 4)
						for _ = 1, 5 do
							last = New(_editor_class["s1_LSC_bamboo_spawn"], x, -235, _)
							_connect(self, last, 0, true)
							x = x + _d_x
						end
					end
					task._Wait(720)
				end
			end
		end)
	end
	function boss_card:del()
		Spell_break_eff(self.x, self.y, 106, 207, 120,
				"bamboo_leaf_white", "tree_leaf_white")
	end
end

function s1_boss.LSC(diff)
	local boss
	diff = diff or difficulty
	if diff == 1 then
		boss = New(_editor_class["LSC1:Easy"], _editor_class["LSC1:Easy"].cards)
	elseif diff == 2 then
		boss = New(_editor_class["LSC1:Normal"], _editor_class["LSC1:Normal"].cards)
	elseif diff == 3 then
		boss = New(_editor_class["LSC1:Hard"], _editor_class["LSC1:Hard"].cards)
	elseif diff == 4 then
		boss = New(_editor_class["LSC1:Lunatic"], _editor_class["LSC1:Lunatic"].cards)
	end
	--关底boss等待
	while IsValid(boss) do
		task.Wait(1)
	end
end
