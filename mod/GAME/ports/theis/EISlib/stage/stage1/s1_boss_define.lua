--通用的组件
do
	_editor_tasks["sf_时间缩放"] = function(time, h, omiga)
		return function()
			local self = task.GetSelf()
			self.hscale = 0
			self.vscale = 0
			self.omiga = omiga
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (255 / (time - 1))
					for _ = 1, time do
						_object.set_color(self, "", al, 255, 255, 255)
						task._Wait(1)
						al = al + _d_al
					end
				end
			end)
			local colli_a = self.a * h
			local colli_b = self.b * h
			do
				local scale, _d_scale = (0), (1 / (time - 1))
				local t, _d_t = (0), (90 / (time - 1))
				for _ = 1, time do
					self.hscale = h * sin(t)
					self.vscale = h * sin(t)
					self.a = colli_a * sin(t)
					self.b = colli_b * sin(t)
					task._Wait(1)
					scale = scale + _d_scale
					t = t + _d_t
				end
			end
			self._blend = false
		end
	end
end

--辉夜的蓄力特效
local function eff(x, y, t)
	New(AbEff, x, y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
	if t then task.Wait(t) end
end
--符卡练习出场特效
local function boss_scpr_show(self, x, y)
	for _ = 1, 3 do
		eff(x, y, 20)
	end
	task.Wait(20)
	self.x, self.y = x, y
	boss.show_aura(self, true)
end

local function s1_boss_common_action(boss_class)
	local _sc = boss.dialog.New(true)
	function _sc:init()
		player.dialog = true
		self.dialog_displayer = New(dialog_displayer)
		self._dialog_maintask = task.New(self, function()
			if not ext.sc_pr then
				-- 出场设置
				self.x = 0
				self.y = 400
				self.colli = false
				boss.show_aura(self, false)
				task._Wait(60)
				_object.set_color(self, "", 0, 255, 255, 255)
				self.hscale = 0
				self.vscale = 0
				if EISlib.stage.canDialog() then
					-- 第一段对话
					dialog.player.playScene("Stage1")
					dialog.player.waitSignal("boss fly in", dialog.enum.on)
					-- 出场过程
					self.x = 0
					self.y = 194
					task.New(self, function()
						do
							local t, _d_t = (0), (90 / 249)
							for _ = 1, 250 do
								_object.set_color(self, "", 255 * sin(t), 255, 255, 255)
								self.hscale = sin(t)
								self.vscale = sin(t)
								task._Wait(1)
								t = t + _d_t
							end
						end
					end)
					task.MoveTo(0, 94, 250, MOVE_DECEL)
					self.colli = true
					self.x = 0
					self.y = 94
					-- 第二段对话
					dialog.player.setSignal("boss fly in complete", dialog.enum.on)
					dialog.player.waitSignal("fade out BGM", dialog.enum.on)
					EISlib.stage.musicFadeOut("s1", 120)
					dialog.player.waitSignal("play BGM", dialog.enum.on)
					LoadMusicRecord("s1_boss")
					EISlib.stage.playMusic("s1_boss", 0, true)
					dialog.player.waitUntilFinish()
					task._Wait(30)
					boss.show_aura(self, true)
				else
					-- 出场过程
					self.x = 0
					self.y = 194
					task.New(self, function()
						do
							local t, _d_t = (0), (90 / 249)
							for _ = 1, 250 do
								_object.set_color(self, "", 255 * sin(t), 255, 255, 255)
								self.hscale = sin(t)
								self.vscale = sin(t)
								task._Wait(1)
								t = t + _d_t
							end
						end
					end)
					task.MoveTo(0, 94, 250, MOVE_DECEL)
					self.colli = true
					self.x = 0
					self.y = 94
					-- 播放音乐
					EISlib.stage.musicFadeOut("s1", 120)
					LoadMusicRecord("s1_boss")
					EISlib.stage.playMusic("s1_boss", 0, true)
					-- 开打
					task.Wait(60)
					boss.show_aura(self, true)
				end
			else
				player.dialog = false
				boss_scpr_show(self, 0, 94)
			end
		end)
	end
	table.insert(boss_class.cards, _sc)
end

--用于衔接非与符，符与非之间的移动
local function boss_action(boss_class, x, y)
	local _sc = boss.dialog.New(true)
	function _sc:init()
		player.dialog = false
		self.dialog_displayer = New(dialog_displayer)
		self._dialog_maintask = task.New(self, function()
			if ext.sc_pr then
				boss_scpr_show(self, x, y)
			else
				task.Wait(30)
				task.MoveTo(x, y, 60, MOVE_ACC_DEC)
			end
		end)
	end
	table.insert(boss_class.cards, _sc)
end

--Easy
do
	--关底boss子弹，事件定义（以前的东西太乱了先暂时放着，有时间再优化吧
	do
		_editor_class["s1_一符使魔:Easy"] = Class(_object)
		_editor_class["s1_一符使魔:Easy"].init = function(self, _x, _y, a0, i)
			self.x, self.y = _x, _y
			self.img = "magic8"
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
			self.bound = false
			lasttask = task.New(self, function()
				task._Wait(90)
				self.bound = true
			end)
			_object.set_color(self, "mul+add", 255, 255, 255, 255)
			self.vscale = 0.8
			self.hscale = 0.8
			self.omiga = 4
			lasttask = task.New(self, function()
				self.v = 2
				lasttask = task.New(self, function()
					do
						for _ = 1, 60 do
							self.v = self.v + 4 / 60
							task._Wait(1)
						end
					end
					_del(self, true)
				end)
				do
					local a, _d_a = (a0), (3.3 * i)
					local da, _d_da = (90), (-50 / 60)
					local t, _d_t = (120), (-120 / 60)
					for _ = 1, 60 do
						SetV2(self, self.v, a, false, false)
						if (self.timer % 10 == 0 and Dist(self, player) >= 32) then
							last = New(_editor_class["s1_一符米弹:Easy"], self.x, self.y, a - 60 * i, 1, 7 + 3 * i, i, t, da)
							PlaySound("tan00", 0.1, self.x / 256, false)
						else
						end
						task._Wait(1)
						a = a + _d_a
						da = da + _d_da
						t = t + _d_t
					end
				end
			end)
		end
		_editor_class["s1_一符米弹:Easy"] = Class(bullet)
		_editor_class["s1_一符米弹:Easy"].init = function(self, _x, _y, a, v, c, i, t, da)
			bullet.init(self, butterfly, c, true, true)
			self.x, self.y = _x, _y
			self.rot = a
			self.navi = true
			lasttask = task.New(self, function()
				do
					local aerfa, _d_aerfa = (90), (-180 / t)
					for _ = 1, t do
						SetV2(self, v / 4 + v * sin(aerfa) / 4, a, true, false)
						task._Wait(1)
						aerfa = aerfa + _d_aerfa
					end
				end
				last = New(_editor_class["s1_一符最终加速弹"], self.x, self.y, a + 50 * i, v, c, i, arrow_big, da)
				_del(self, true)
			end)
		end
		_editor_class["s1_二符使魔2:Easy"] = Class(_object)
		_editor_class["s1_二符使魔2:Easy"].init = function(self, _x, _y, a, i)
			self.x, self.y = _x, _y
			self.img = "magic3"
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
			self.omiga = 3
			_object.set_color(self, "mul+add", 0, 255, 255, 50)
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (250 / 89)
					for _ = 1, 90 do
						_object.set_color(self, "mul+add", al, 255, 255, 50)
						task._Wait(1)
						al = al + _d_al
					end
				end
				lasttask = task.New(self, function()
					do
						local b, _d_b = (a), (9 * i)
						for _ = 1, _infinite do
							do
								local a1, _d_a1 = (0), (180)
								for _ = 1, 2 do
									last = New(_straight, star_small, COLOR_YELLOW, self.x + 10 * cos(a1), self.y + 10 * sin(a1), 0, a1 + b, false, 3 * i, true, true, 0, false, 0.015, a1 + b, 1, false)
									task._Wait(0)
									a1 = a1 + _d_a1
								end
							end
							task._Wait(40)
							b = b + _d_b
						end
					end
				end)
			end)
			lasttask = task.New(self, function()
				do
					local angle, _d_angle = (a), (7 * i)
					for _ = 1, _infinite do
						_set_rel_pos(self, 100 * cos(angle), 100 * sin(angle), self.rot, false)
						task._Wait(1)
						angle = angle + _d_angle
					end
				end
			end)
		end
	end
	--关底boss定义
	local stage1boss
	do
		-- 定义
		stage1boss = Class(boss)
		stage1boss.cards = {}
		stage1boss.name = "Kaguya"
		stage1boss.init = function(self, cards)
			boss.init(self, 240, 384, "Kaguya", cards, New(s1_boss.scbg), "Easy")
			lstg.wis.Kaguya(self)
		end
		stage1boss.bgm = "s1_boss"
		stage1boss._bg = stage1_background
		stage1boss.difficulty = "Easy"
		-- 出场
		s1_boss_common_action(stage1boss)
		-- 攻击
		_tmp_sc = boss.card.New("常规攻击1", 2, 5, 40, 1200, { 0, 0, 0 }, false, "normal")
		function _tmp_sc:init()
			boss.show_aura(self, true)
			local mode = 'new'
			local i = ran:Sign()
			lasttask = task.New(self, function()
				task.MoveTo(0, 94, 1, MOVE_NORMAL)
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					task._Wait(60)
				end
				local ia = i
				do
					for _ = 1, _infinite do
						ia0, rai, sa = ia, ran:Sign(), ran:Float(0, 360)
						do
							for _ = 1, 2 do
								lasttask = task.New(self, _editor_tasks["seasons_stage_1_boss_nospell1_task"](1, ia0, rai, sa))
								task._Wait(60)
								task.MoveToPlayer(60, -96, 96, 82, 94, 16, 32, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
								task._Wait(60)
								ia0, rai = -ia0, -rai
							end
						end
						task._Wait(60)
						lasttask = task.New(self, function()
							task.MoveToPlayer(120, -96, 96, 82, 94, 64, 112, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
						end)
						local timdiff, dwaydiff, dadiff = { 4, 6, 4, 6 }, { 0, 0, 1, 1 }, { 0, 0, 90, 75 }
						local tim, dway, da = 4, 0, 0
						do
							local way, _d_way = (1), (dway)
							local sp, _d_sp = (0), (da / (tim - 1))
							for _ = 1, tim do
								PlaySound("tan00", 0.1, self.x / 256, false)
								do
									local sv, _d_sv = (1.5), (2 / 7)
									for _ = 1, 2 do
										do
											local sa, _d_sa = (Angle(self, player) - sp / 2 * ia), (sp * ia / (way - 1))
											for _ = 1, way do
												last = New(_straight, ellipse, COLOR_PURPLE, self.x, self.y, sv, sa, false, 0, true, true, 0, false, 0, 0, 0, false)
												sa = sa + _d_sa
											end
										end
										sv = sv + _d_sv
									end
								end
								task._Wait(120 / tim)
								way = way + _d_way
								sp = sp + _d_sp
							end
						end
						task._Wait(60)
						ia = -ia
					end
				end
			end)
		end
		function _tmp_sc:del()
			--self.sc_bonus_max = 10000000
			--self.sc_bonus_base = 2000000
		end
		_editor_cards.s1_01_E = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage1boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage1boss:Easy", "常规攻击1", _tmp_sc, #stage1boss.cards, true })

		boss_action(stage1boss, 0, 112)
		_tmp_sc = boss.card.New("秽花「馥郁的地上界」", 2, 8, 60, 1500, { 10, 20, 30 }, false)
		function _tmp_sc:init()
			lasttask = task.New(self, function()
				do
					s1_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
						task._Wait(60)
					end
				end
				lasttask = task.New(self, function()
					lasttask = task.New(self, function()
						task._Wait(120)
						do
							for _ = 1, _infinite do
								last = New(_editor_class["s1_一符星弹"], ran:Float(-200, 200), 240 + ran:Float(-10, 10), 270, 0, 2 + ran:Float(-0.5, 0.5), COLOR_RED)
								task._Wait(30)
							end
						end
					end)
					do
						local w, _d_w = (1), (1)
						for _ = 1, _infinite do
							do
								local x, _d_x = (-150), (150)
								for _ = 1, 4 do
									last = New(_editor_class["s1_一符背景星弹"], x + ran:Float(-100, 100), self.y + ran:Float(-10, 10), ran:Float(85, 95), w % 10)
									task._Wait(0)
									x = x + _d_x
								end
							end
							task._Wait(3)
							w = w + _d_w
						end
					end
				end)
				local i = 1
				do
					for _ = 1, _infinite do
						do
							local a, _d_a = (Angle(self, player)), (30)
							for _ = 1, 12 do
								last = New(_editor_class["s1_一符使魔:Easy"], self.x, self.y, a, i)
								task._Wait(0)
								a = a + _d_a
							end
						end
						i = -i
						task._Wait(100)
						do
							local a, _d_a = (Angle(self, player)), (30)
							for _ = 1, 12 do
								last = New(_editor_class["s1_一符使魔:Easy"], self.x, self.y, a, i)
								task._Wait(0)
								a = a + _d_a
							end
						end
						task._Wait(120)
						task.MoveToPlayer(60, -16, 16, 112, 124, 5, 6, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
						task._Wait(1)
					end
				end
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 106, 207, 120, "bamboo_leaf_white", "tree_leaf_white")
		end
		_editor_cards.s1_11_E = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage1boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage1boss:Easy", "秽花「馥郁的地上界」", _tmp_sc, #stage1boss.cards, true })

		boss_action(stage1boss, 0, 144)
		_tmp_sc = boss.card.New("常规攻击2", 2, 5, 40, 1500, { 0, 0, 0 }, false, "normal")
		function _tmp_sc:init()
			lasttask = task.New(self, function()
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					task._Wait(60)
				end
				local frame = 8
				local function getRandomSort(t)
					--打乱一个数组元素顺序
					local ori = {}
					for _, v in ipairs(t) do
						table.insert(ori, v)
					end
					local ref = {}
					local r
					while #ori > 0 do
						r = ran:Int(1, #ori)
						table.insert(ref, ori[r])
						table.remove(ori, r)
					end
					return ref
				end

				local function b1(dv, a)
					--开幕绿鳞弹
					local last = New(straight, arrow_big, 10, true, self.x, self.y, 1.5 + dv, a)
					task.New(last, function()
						task.Wait(20)
						AddSimStrChV(last, 0, -1, a, 30)
						task.Wait(120)
						AddSimStrChV(last, 0, 1.5, a, 180)
					end)
				end

				local function b2(dv, a)
					--开幕黄小星星
					local last = New(straight, star_small, 12, true, self.x, self.y, 1.4 + dv, a)
					last.omiga = 1
					task.New(last, function()
						task.Wait(20)
						AddSimStrChV(last, 0, -1, a, 30)
						task.Wait(20)
						AddSimStrChV(last, 0, 1.5, a, 240)
					end)
				end

				local function dragon_ball(x, y, u)
					--龙玉
					local co
					local last2
					task.Wait(15)
					co = ran:Int(1, 14)
					last2 = New(straight, ball_mid, co, true, x, y, ran:Float(2, 3), 90 + ran:Float(-20, -30) * u)
					last2.hscale, last2.vscale = 0, 0
					last2.navi = true
					last2.timer = 11
					last2.a = 0
					last2._blend, last2._a, last2._r, last2._g, last2._b = "mul+add", 255, 255, 255, 255
					AddSimStrChV(last2, 0, 6, -90, 180)
					task.New(last2, function()
						for i = 1, 30 do
							last2.hscale, last2.vscale = last2.hscale + 0.1, last2.vscale + 0.1
							last2.a, last2.b = last2.a + 0.4, last2.b + 0.4
							task.Wait(1)
						end
					end)
				end

				local function stone_bowl(x, y, u)
					local last, _i = {}, 0
					local _r1, _r2, _dy, da, a0 = 25, 10, -24, 20
					local _v, _a = ran:Float(1.5, 1.75), 90 + ran:Float(-30, -45) * u
					for _ = 1, 3 do
						a0 = 0
						local r1, r2 = _r1, _r2
						for _ = 1, 18 do
							_i = _i + 1
							local i = _i
							local a = a0
							local dy = _dy
							last[i] = New(straight, water_drop, 13, true, x, y, _v, _a)
							last[i].timer = 11
							last[i].rot = a
							AddSimStrChV(last[i], 0, 6, -90, 180)
							task.New(last[i], function()
								local _dx, _dy = r1 * cos(a) / 30, (dy + r2 * sin(a)) / 30
								for _ = 1, 30 do
									last[i].x = last[i].x + _dx
									last[i].y = last[i].y + _dy
									task.Wait(1)
								end
							end)
							a0 = a0 + da
						end
						_dy = _dy + 12
						_r1 = _r1 + 16
					end
				end

				local function fire_clothes(x, y, u)
					local last, _i = {}, 0
					local _r1, _r2, _dy, da, a0 = 20, 8, 24, 22
					local _v, _a = ran:Float(1.5, 1.75), 90 + ran:Float(-25, -35) * u
					for _ = 1, 5 do
						a0 = -20
						local r1, r2 = _r1, _r2
						for _ = 1, 10 do
							_i = _i + 1
							local i = _i
							local a = a0
							local dy = _dy
							last[i] = New(straight, water_drop, 2, true, x, y, _v, _a)
							last[i].timer = 11
							last[i].rot = 90
							AddSimStrChV(last[i], 0, 6, -90, 180)
							task.New(last[i], function()
								local _dx, _dy = r1 * cos(a) / 30, (dy + r2 * sin(a)) / 30
								for _ = 1, 30 do
									last[i].x = last[i].x + _dx
									last[i].y = last[i].y + _dy
									task.Wait(1)
								end
							end)
							a0 = a0 + da
						end
						_dy = _dy - 12
						_r1 = _r1 + 8
					end
				end

				local function shell(x, y, u)
					--子安贝
					local last, _i = {}, 0
					local _v, _a = ran:Float(1.5, 1.75), 90 + ran:Float(-25, -35) * u
					local a0, _dh = 30, 0.1
					for _ = 1, 11 do
						_i = _i + 1
						local i = _i
						local dh = _dh
						local a = a0
						last[i] = New(straight, ellipse, 6, true, x, y, _v, _a)
						last[i].timer = 11
						last[i].rot = a
						last[i].hscale, last[i].vscale = 0, 0
						last[i].a, last[i].b = 0, 0
						AddSimStrChV(last[i], 0, 6, -90, 180)
						task.New(last[i], function()
							local _dx, _dy = 15 * cos(a) / 30, 10 * sin(a) / 30
							for _ = 1, 30 do
								last[i].x = last[i].x + _dx
								last[i].y = last[i].y + _dy
								last[i].hscale, last[i].vscale = last[i].hscale + dh, last[i].vscale + 0.05
								last[i].a, last[i].b = last[i].a + 1.25 * dh / 0.175, last[i].b + 0.35
								task.Wait(1)
							end
						end)
						a0 = a0 + 12
						_dh = _dh + 0.007
					end
				end

				local function stick(x, y, u)
					local point = {}
					local len, angle
					--枝干
					len, angle = ran:Int(20, 24), 90 + u * ran:Int(-30, -45)
					point[1] = { x, y }
					point[2] = { x + len * cos(angle), y + len * sin(angle) }
					local _u = u
					--3, 4
					local angle0 = angle
					for i = 1, 2 do
						len, angle = ran:Int(16, 21), angle0 + _u * ran:Int(-30, -40)
						point[2 + i] = { point[2][1] + len * cos(angle), point[2][2] + len * sin(angle) }
						_u = -_u
					end
					--5, 6
					angle0 = Angle(point[2][1], point[2][2], point[3][1], point[3][2])
					for i = 1, 2 do
						len, angle = ran:Int(12, 15), angle0 + _u * ran:Int(-20, -30)
						point[4 + i] = { point[3][1] + len * cos(angle), point[3][2] + len * sin(angle) }
						_u = -_u
					end

					--控制树枝行为的函数
					local function f1(o, p1x, p1y, p2x, p2y)
						o.hscale, o.vscale = 0, 0.7
						o.a = 0
						task.New(o, function()
							local x, y, t = o.x, o.y, 30
							local d1x, d1y, d2x, d2y = (0.5 * (p1x + p2x - x) + p1x - x) / t, (0.5 * (p1y + p2y - y) + p1y - y) / t, (0.5 * (p1x + p2x - x) + p2x - x) / t, (0.5 * (p1y + p2y - y) + p2y - y) / t
							local x1, y1, x2, y2, dl, dx, dy = o.x, o.y, o.x, o.y, 0, d1x, d1x
							for _ = 1, t do
								x1 = x1 + d1x
								y1 = y1 + d1y
								x2 = x2 + d2x
								y2 = y2 + d2y
								o.x, o.y = o.x + d1x, o.y + d1y
								dl = Dist(x1, y1, x2, y2)
								o.hscale, o.a = dl / 8, dl
								task.Wait(1)
							end
						end)
					end
					--控制小玉行为的函数
					local function f2(o, px, py)
						o.hscale, o.vscale = 0, 0
						o.a, o.b = 0, 0
						task.New(o, function()
							local x, y, t = o.x, o.y, 30
							local dx, dy = 1.9 * (px - x) / t, 1.9 * (py - y + 26) / t
							for _ = 1, t do
								o.x, o.y = o.x + dx, o.y + dy
								o.hscale, o.vscale = o.hscale + 1 / 30, o.vscale + 1 / 30
								o.a, o.b = o.a + 4 / 30, o.b + 4 / 30
								task.Wait(1)
							end
						end)
					end
					--创建树枝和小玉
					local s, ball = {}, {}
					s[1] = New(straight, laserbullet, 10, true, self.x, self.y, 0, Angle(point[1][1], point[1][2], point[2][1], point[2][2]))
					f1(s[1], point[1][1], point[1][2], point[2][1], point[2][2])
					s[2] = New(straight, laserbullet, 10, true, self.x, self.y, 0, Angle(point[2][1], point[2][2], point[3][1], point[3][2]))
					f1(s[2], point[2][1], point[2][2], point[3][1], point[3][2])
					s[3] = New(straight, laserbullet, 10, true, self.x, self.y, 0, Angle(point[2][1], point[2][2], point[4][1], point[4][2]))
					f1(s[3], point[2][1], point[2][2], point[4][1], point[4][2])
					s[4] = New(straight, laserbullet, 10, true, self.x, self.y, 0, Angle(point[3][1], point[3][2], point[5][1], point[5][2]))
					f1(s[4], point[3][1], point[3][2], point[5][1], point[5][2])
					s[5] = New(straight, laserbullet, 10, true, self.x, self.y, 0, Angle(point[3][1], point[3][2], point[6][1], point[6][2]))
					f1(s[5], point[3][1], point[3][2], point[6][1], point[6][2])
					local co = { 10, 3, 6, 1, 14 }
					for i = 1, 5 do
						ball[i] = New(straight, ball_mid, co[i], true, self.x, self.y, 0, 0)
						f2(ball[i], point[1 + i][1], point[1 + i][2])
					end
					local v, a = ran:Float(0.5, 0.75), 90 + ran:Float(10, 20) * u
					for i = 1, 5 do
						SetV(s[i], v, a)
						SetV(ball[i], v, a)
						AddSimStrChV(s[i], 0, 6, -90, 180)
						AddSimStrChV(ball[i], 0, 6, -90, 180)
					end
				end

				local laji = { dragon_ball, stone_bowl, fire_clothes, shell, stick }

				local function b3(x, y)
					local last = {}
					--生成随机的垃圾小玉
					task.New(self, function()
						for i = 1, 2 do
							co = ran:Int(1, 14)
							last[i] = New(straight, ball_mid_c, co, false, x + ran:Float(-10, 10), y + ran:Float(-10, 10), ran:Float(1, 1.75), 90 + ran:Float(-45, 45))
							last[i].timer = 11
							last[i].hscale, last[i].vscale = 0, 0
							last[i].a, last[i].b = 0, 0
							last[i]._blend, last[i]._a, last[i]._r, last[i]._g, last[i]._b = "mul+add", 255, 255, 255, 255
							AddSimStrChV(last[i], 0, 5, -90, 300)
							task.New(last[i], function()
								for _ = 1, 10 do
									last[i].hscale, last[i].vscale = last[i].hscale + 0.1, last[i].vscale + 0.1
									last[i].a, last[i].b = last[i].a + 0.4, last[i].b + 0.4
									task.Wait(1)
								end
							end)
							task.Wait(1)
						end
					end)
				end

				do
					local a, _d_a = (0), (30)
					for _ = 1, 12 do
						b1(0.25, a)
						b2(0.25, a)
						a = a + _d_a
					end
				end
				--task._Wait(180)
				task.MoveTo(0, 100, 120, MOVE_NORMAL)
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					task._Wait(60)
				end
				self._wisys:setAction("cast", 64 * 20)
				lasttask = task.New(self, function()
					task._Wait(64 * 20)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					frame = 6
					self._wisys:setAction("cast1", 48 * 20)
					task._Wait(48 * 20)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					frame = 4
					self._wisys:setAction("cast2", 9999)
				end)
				task._Wait(24)
				local u, num = -1
				lasttask = task.New(self, function()
					do
						for _ = 1, _infinite do
							PlaySound("kira00", 0.1, 0, false)
							b3(self.x, self.y)
							task.Wait(10 * frame)
						end
					end
				end)
				lasttask = task.New(self, function()
					task._Wait(60)
					local u, _a, a0 = -1
					do
						for _ = 1, _infinite do
							_a = Angle(self, player)
							do
								local a, _d_a = (-120 * u), (40 / 4 * u)
								for _ = 1, 5 do
									a0 = -90 + 90 * u + a
									last = New(_straight, arrow_small, COLOR_DEEP_GREEN, self.x + 30 * cos(a0), self.y + 30 * sin(a0), 1.5, -90 + 90 * u + a + _a * u, false, 0, true, true, 0, false, 0, 0, 0, false)
									a = a + _d_a
								end
							end
							task.Wait(12 * frame)
							u = -u
						end
					end
				end)
				do
					for _ = 1, _infinite do
						getRandomSort(laji)
						for num = 1, 5 do
							laji[num](self.x - 5 * u, self.y, u)
							u = -u
							task.Wait(8 * frame)
						end
					end
				end
			end)
		end
		function _tmp_sc:del()
			--self.sc_bonus_max = 10000000
			--self.sc_bonus_base = 2000000
		end
		_editor_cards.s1_02_E = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage1boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage1boss:Easy", "常规攻击2", _tmp_sc, #stage1boss.cards, true })

		_tmp_sc = boss.dialog.New(true)
		function _tmp_sc:init()
			player.dialog = false
			self.dialog_displayer = New(dialog_displayer)
			self._dialog_maintask = task.New(self, function()
				task._Wait(60)
				self._wisys:setAction("cast3", 80)
				task._Wait(80)
			end)
		end
		table.insert(stage1boss.cards, _tmp_sc)
		boss_action(stage1boss, 0, 134)
		_tmp_sc = boss.card.New("神宝「天星逆月」", 3, 5, 60, 1600, { 10, 20, 30 }, false)
		function _tmp_sc:init()
			lasttask = task.New(self, function()
				do
					s1_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
						task._Wait(60)
					end
				end
				do
					local a, _d_a = (0), (36)
					for _ = 1, 10 do
						last = New(_editor_class["s1_二符使魔_EN"], self.x, self.y, a, 1, 360)
						task._Wait(0)
						a = a + _d_a
					end
				end
				do
					local a, _d_a = (0), (36)
					for _ = 1, 10 do
						last = New(_editor_class["s1_二符使魔_EN"], self.x, self.y, a, -1, 450)
						task._Wait(0)
						a = a + _d_a
					end
				end
				do
					local a, _d_a = (33), (45)
					for _ = 1, 8 do
						last = New(_editor_class["s1_二符使魔2:Easy"], self.x, self.y, a, -1)
						_connect(self, last, 0, true)
						task._Wait(0)
						a = a + _d_a
					end
				end
				task._Wait(60)
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					task._Wait(60)
				end
				local i = 1
				do
					for _ = 1, _infinite do
						local a = Angle(self, player)
						lasttask = task.New(self, function()
							do
								local b, _d_b = (0), (-2 * i)
								local vv, _d_vv = (1.5), (-0.2)
								for _ = 1, 4 do
									do
										local v, _d_v = (1), (1 / 3)
										for _ = 1, 4 do
											last = New(_editor_class["s1_二符米弹"], self.x, self.y, v + vv, a + b, ball_big, COLOR_CYAN)
											task._Wait(0)
											v = v + _d_v
										end
									end
									task._Wait(5)
									b = b + _d_b
									vv = vv + _d_vv
								end
							end
						end)
						do
							local b, _d_b = (0), (2 * i)
							local vv, _d_vv = (1.5), (-0.2)
							for _ = 1, 4 do
								do
									local v, _d_v = (1), (1 / 3)
									for _ = 1, 4 do
										last = New(_editor_class["s1_二符米弹"], self.x, self.y, v + vv, a + b, ball_big, COLOR_CYAN)
										task._Wait(0)
										v = v + _d_v
									end
								end
								task._Wait(5)
								b = b + _d_b
								vv = vv + _d_vv
							end
						end
						task._Wait(10)
						PlaySound("kira00", 0.4, self.x / 256, false)
						task._Wait(60)
						task._Wait(60)
					end
				end
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 106, 207, 120, "bamboo_leaf_white", "tree_leaf_white")
		end
		_editor_cards.s1_12_E = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage1boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage1boss:Easy", "神宝「天星逆月」", _tmp_sc, #stage1boss.cards, true })
	end
	_editor_class["stage1boss:Easy"] = stage1boss
end

--Normal
do
	--关底boss子弹，事件定义（以前的东西太乱了先暂时放着，有时间再优化吧
	do
		_editor_class["s1_一符使魔:Normal"] = Class(_object)
		_editor_class["s1_一符使魔:Normal"].init = function(self, _x, _y, a0, i)
			self.x, self.y = _x, _y
			self.img = "magic8"
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
			self.bound = false
			lasttask = task.New(self, function()
				task._Wait(90)
				self.bound = true
			end)
			_object.set_color(self, "mul+add", 255, 255, 255, 255)
			self.vscale = 0.8
			self.hscale = 0.8
			self.omiga = 4
			lasttask = task.New(self, function()
				self.v = 2
				lasttask = task.New(self, function()
					do
						for _ = 1, 60 do
							self.v = self.v + 4 / 60
							task._Wait(1)
						end
					end
					_del(self, true)
				end)
				do
					local a, _d_a = (a0), (3.3 * i)
					local da, _d_da = (90), (-50 / 60)
					local t, _d_t = (120), (-120 / 60)
					for _ = 1, 60 do
						SetV2(self, self.v, a, false, false)
						if (self.timer % 10 == 0 and Dist(self, player) >= 32) then
							last = New(_editor_class["s1_一符米弹:Normal"], self.x, self.y, a - 70 * i, 1.5, 7 + 3 * i, i, t, da)
							PlaySound("tan00", 0.1, self.x / 256, false)
						else
						end
						task._Wait(1)
						a = a + _d_a
						da = da + _d_da
						t = t + _d_t
					end
				end
			end)
		end
		_editor_class["s1_一符米弹:Normal"] = Class(bullet)
		_editor_class["s1_一符米弹:Normal"].init = function(self, _x, _y, a, v, c, i, t, da)
			bullet.init(self, butterfly, c, true, true)
			self.x, self.y = _x, _y
			self.rot = a
			self.navi = true
			lasttask = task.New(self, function()
				do
					local aerfa, _d_aerfa = (90), (-180 / t)
					for _ = 1, t do
						SetV2(self, v / 4 + v * sin(aerfa) / 4, a, true, false)
						task._Wait(1)
						aerfa = aerfa + _d_aerfa
					end
				end
				last = New(_editor_class["s1_一符最终加速弹"], self.x, self.y, a + 50 * i, v, c, i, arrow_big, da)
				_del(self, true)
			end)
		end
		_editor_class["s1_二符使魔_EN"] = Class(_object)
		_editor_class["s1_二符使魔_EN"].init = function(self, _x, _y, a0, i, rr)
			self.x, self.y = _x, _y
			self.img = "magic5"
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
			self.omiga = 4 * i
			self.bound = false
			_object.set_color(self, "mul+add", 0, 15, 218, 255)
			self.vscale = 0.8
			self.hscale = 0.8
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (250 / 14)
					for _ = 1, 15 do
						_object.set_color(self, "mul+add", al, 15, 218, 255)
						task._Wait(1)
						al = al + _d_al
					end
				end
			end)
			lasttask = task.New(self, function()
				do
					local aerfa, _d_aerfa = (0), (90 / 119)
					local a, _d_a = (a0), (1.3 * i)
					for _ = 1, 120 do
						local r = 960 - (960 - rr) * sin(aerfa)
						self.x = r * cos(a)
						self.y = -200 + r * sin(a) / 2
						if (self.timer % 2 == 0) then
							last = New(_editor_class["s1_二符火弹"], self.x, self.y, a, 10 + 4 * i)
						else
						end
						task._Wait(1)
						aerfa = aerfa + _d_aerfa
						a = a + _d_a
					end
				end
				do
					local a, _d_a = (a0 + 1.3 * 120 * i), (1.3 * i)
					for _ = 1, _infinite do
						self.x = rr * cos(a)
						self.y = -200 + rr * sin(a) / 2
						if (self.timer % 2 == 0) then
							last = New(_editor_class["s1_二符火弹"], self.x, self.y, a, 10 + 4 * i)
						else
						end
						task._Wait(1)
						a = a + _d_a
					end
				end
			end)
		end
		_editor_class["s1_二符使魔2:Normal"] = Class(_object)
		_editor_class["s1_二符使魔2:Normal"].init = function(self, _x, _y, a, i)
			self.x, self.y = _x, _y
			self.img = "magic3"
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
			self.omiga = 3
			_object.set_color(self, "mul+add", 0, 255, 255, 50)
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (250 / 89)
					for _ = 1, 90 do
						_object.set_color(self, "mul+add", al, 255, 255, 50)
						task._Wait(1)
						al = al + _d_al
					end
				end
				lasttask = task.New(self, function()
					do
						local b, _d_b = (a), (9 * i)
						for _ = 1, _infinite do
							do
								local a1, _d_a1 = (0), (90)
								for _ = 1, 4 do
									last = New(_straight, star_small, COLOR_YELLOW, self.x + 10 * cos(a1), self.y + 10 * sin(a1), 0, a1 + b, false, 3 * i, true, true, 0, false, 0.015, a1 + b, 1.25, false)
									task._Wait(0)
									a1 = a1 + _d_a1
								end
							end
							task._Wait(40)
							b = b + _d_b
						end
					end
				end)
			end)
			lasttask = task.New(self, function()
				do
					local angle, _d_angle = (a), (7 * i)
					for _ = 1, _infinite do
						_set_rel_pos(self, 100 * cos(angle), 100 * sin(angle), self.rot, false)
						task._Wait(1)
						angle = angle + _d_angle
					end
				end
			end)
		end
	end
	--关底boss定义
	local stage1boss
	do
		stage1boss = Class(boss)
		stage1boss.cards = {}
		stage1boss.name = "Kaguya"
		stage1boss.init = function(self, cards)
			boss.init(self, 240, 384, "Kaguya", cards, New(s1_boss.scbg), "Normal")
			lstg.wis.Kaguya(self)
		end
		stage1boss.bgm = "s1_boss"
		stage1boss._bg = stage1_background
		stage1boss.difficulty = "Normal"
		-- 出场
		s1_boss_common_action(stage1boss)
		-- 攻击
		_tmp_sc = boss.card.New("常规攻击1", 2, 5, 40, 1200, { 0, 0, 0 }, false, "normal")
		function _tmp_sc:init()
			boss.show_aura(self, true)
			local mode = 'new'
			local i = ran:Sign()
			lasttask = task.New(self, function()
				task.MoveTo(0, 94, 1, MOVE_NORMAL)
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					task._Wait(60)
				end
				local ia = i
				do
					for _ = 1, _infinite do
						ia0, rai, sa = ia, ran:Sign(), ran:Float(0, 360)
						do
							for _ = 1, 2 do
								lasttask = task.New(self, _editor_tasks["seasons_stage_1_boss_nospell1_task"](2, ia0, rai, sa))
								task._Wait(60)
								task.MoveToPlayer(60, -96, 96, 82, 94, 16, 32, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
								task._Wait(60)
								ia0, rai = -ia0, -rai
							end
						end
						task._Wait(60)
						lasttask = task.New(self, function()
							task.MoveToPlayer(120, -96, 96, 82, 94, 64, 112, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
						end)
						local timdiff, dwaydiff, dadiff = { 4, 6, 4, 6 }, { 0, 0, 1, 1 }, { 0, 0, 90, 75 }
						local tim, dway, da = 6, 0, 0
						do
							local way, _d_way = (1), (dway)
							local sp, _d_sp = (0), (da / (tim - 1))
							for _ = 1, tim do
								PlaySound("tan00", 0.1, self.x / 256, false)
								do
									local sv, _d_sv = (1.5), (2 / 7)
									for _ = 1, 4 do
										do
											local sa, _d_sa = (Angle(self, player) - sp / 2 * ia), (sp * ia / (way - 1))
											for _ = 1, way do
												last = New(_straight, ellipse, COLOR_PURPLE, self.x, self.y, sv, sa, false, 0, true, true, 0, false, 0, 0, 0, false)
												sa = sa + _d_sa
											end
										end
										sv = sv + _d_sv
									end
								end
								task._Wait(120 / tim)
								way = way + _d_way
								sp = sp + _d_sp
							end
						end
						task._Wait(60)
						ia = -ia
					end
				end
			end)
		end
		function _tmp_sc:del()
			--self.sc_bonus_max = 10000000
			--self.sc_bonus_base = 2000000
		end
		_editor_cards.s1_01_N = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage1boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage1boss:Normal", "常规攻击1", _tmp_sc, #stage1boss.cards, true })

		boss_action(stage1boss, 0, 112)
		_tmp_sc = boss.card.New("秽花「馥郁的地上界」", 2, 8, 60, 1500, { 10, 20, 30 }, false)
		function _tmp_sc:init()
			lasttask = task.New(self, function()
				do
					s1_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
						task._Wait(60)
					end
				end
				lasttask = task.New(self, function()
					lasttask = task.New(self, function()
						task._Wait(120)
						do
							for _ = 1, _infinite do
								last = New(_editor_class["s1_一符星弹"], ran:Float(-200, 200), 240 + ran:Float(-10, 10), 270, 0, 2 + ran:Float(-0.5, 0.5), COLOR_RED)
								task._Wait(15)
							end
						end
					end)
					do
						local w, _d_w = (1), (1)
						for _ = 1, _infinite do
							do
								local x, _d_x = (-150), (150)
								for _ = 1, 4 do
									last = New(_editor_class["s1_一符背景星弹"], x + ran:Float(-100, 100), self.y + ran:Float(-10, 10), ran:Float(85, 95), w % 10)
									task._Wait(0)
									x = x + _d_x
								end
							end
							task._Wait(3)
							w = w + _d_w
						end
					end
				end)
				local i = 1
				do
					for _ = 1, _infinite do
						do
							local a, _d_a = (Angle(self, player)), (18)
							for _ = 1, 20 do
								last = New(_editor_class["s1_一符使魔:Normal"], self.x, self.y, a, i)
								task._Wait(0)
								a = a + _d_a
							end
						end
						i = -i
						task._Wait(100)
						do
							local a, _d_a = (Angle(self, player)), (18)
							for _ = 1, 20 do
								last = New(_editor_class["s1_一符使魔:Normal"], self.x, self.y, a, i)
								task._Wait(0)
								a = a + _d_a
							end
						end
						task._Wait(120)
						task.MoveToPlayer(60, -16, 16, 112, 124, 5, 6, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
						task._Wait(1)
					end
				end
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 106, 207, 120, "bamboo_leaf_white", "tree_leaf_white")
		end
		_editor_cards.s1_11_N = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage1boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage1boss:Normal", "秽花「馥郁的地上界」", _tmp_sc, #stage1boss.cards, true })

		boss_action(stage1boss, 0, 144)
		_tmp_sc = boss.card.New("常规攻击2", 2, 5, 40, 1500, { 0, 0, 0 }, false, "normal")
		function _tmp_sc:init()
			lasttask = task.New(self, function()
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					task._Wait(60)
				end
				local frame, way, layer, sp = 8, 6, 1, 64
				local function getRandomSort(t)
					--打乱一个数组元素顺序
					local ori = {}
					for _, v in ipairs(t) do
						table.insert(ori, v)
					end
					local ref = {}
					local r
					while #ori > 0 do
						r = ran:Int(1, #ori)
						table.insert(ref, ori[r])
						table.remove(ori, r)
					end
					return ref
				end

				local function b1(dv, a)
					--开幕绿鳞弹
					local last = New(straight, arrow_big, 10, true, self.x, self.y, 2.5 + dv, a)
					task.New(last, function()
						task.Wait(20)
						AddSimStrChV(last, 0, -2, a, 30)
						task.Wait(120)
						AddSimStrChV(last, 0, 2.5, a, 180)
					end)
				end

				local function b2(dv, a)
					--开幕黄小星星
					local last = New(straight, star_small, 12, true, self.x, self.y, 2.4 + dv, a)
					last.omiga = 1
					task.New(last, function()
						task.Wait(20)
						AddSimStrChV(last, 0, -2.5, a, 30)
						task.Wait(20)
						AddSimStrChV(last, 0, 2, a, 240)
					end)
				end

				local function dragon_ball(x, y, u)
					--龙玉
					local co
					local last2
					task.Wait(15)
					co = ran:Int(1, 14)
					last2 = New(straight, ball_mid, co, true, x, y, ran:Float(2, 3), 90 + ran:Float(-20, -30) * u)
					last2.hscale, last2.vscale = 0, 0
					last2.navi = true
					last2.timer = 11
					last2.a = 0
					last2._blend, last2._a, last2._r, last2._g, last2._b = "mul+add", 255, 255, 255, 255
					AddSimStrChV(last2, 0, 6, -90, 180)
					task.New(last2, function()
						for i = 1, 30 do
							last2.hscale, last2.vscale = last2.hscale + 0.1, last2.vscale + 0.1
							last2.a, last2.b = last2.a + 0.4, last2.b + 0.4
							task.Wait(1)
						end
					end)
				end

				local function stone_bowl(x, y, u)
					local last, _i = {}, 0
					local _r1, _r2, _dy, da, a0 = 25, 10, -24, 20
					local _v, _a = ran:Float(1.5, 1.75), 90 + ran:Float(-30, -45) * u
					for _ = 1, 3 do
						a0 = 0
						local r1, r2 = _r1, _r2
						for _ = 1, 18 do
							_i = _i + 1
							local i = _i
							local a = a0
							local dy = _dy
							last[i] = New(straight, water_drop, 13, true, x, y, _v, _a)
							last[i].timer = 11
							last[i].rot = a
							AddSimStrChV(last[i], 0, 6, -90, 180)
							task.New(last[i], function()
								local _dx, _dy = r1 * cos(a) / 30, (dy + r2 * sin(a)) / 30
								for _ = 1, 30 do
									last[i].x = last[i].x + _dx
									last[i].y = last[i].y + _dy
									task.Wait(1)
								end
							end)
							a0 = a0 + da
						end
						_dy = _dy + 12
						_r1 = _r1 + 16
					end
				end

				local function fire_clothes(x, y, u)
					local last, _i = {}, 0
					local _r1, _r2, _dy, da, a0 = 20, 8, 24, 22
					local _v, _a = ran:Float(1.5, 1.75), 90 + ran:Float(-25, -35) * u
					for _ = 1, 5 do
						a0 = -20
						local r1, r2 = _r1, _r2
						for _ = 1, 10 do
							_i = _i + 1
							local i = _i
							local a = a0
							local dy = _dy
							last[i] = New(straight, water_drop, 2, true, x, y, _v, _a)
							last[i].timer = 11
							last[i].rot = 90
							AddSimStrChV(last[i], 0, 6, -90, 180)
							task.New(last[i], function()
								local _dx, _dy = r1 * cos(a) / 30, (dy + r2 * sin(a)) / 30
								for _ = 1, 30 do
									last[i].x = last[i].x + _dx
									last[i].y = last[i].y + _dy
									task.Wait(1)
								end
							end)
							a0 = a0 + da
						end
						_dy = _dy - 12
						_r1 = _r1 + 8
					end
				end

				local function shell(x, y, u)
					--子安贝
					local last, _i = {}, 0
					local _v, _a = ran:Float(1.5, 1.75), 90 + ran:Float(-25, -35) * u
					local a0, _dh = 30, 0.1
					for _ = 1, 11 do
						_i = _i + 1
						local i = _i
						local dh = _dh
						local a = a0
						last[i] = New(straight, ellipse, 6, true, x, y, _v, _a)
						last[i].timer = 11
						last[i].rot = a
						last[i].hscale, last[i].vscale = 0, 0
						last[i].a, last[i].b = 0, 0
						AddSimStrChV(last[i], 0, 6, -90, 180)
						task.New(last[i], function()
							local _dx, _dy = 15 * cos(a) / 30, 10 * sin(a) / 30
							for _ = 1, 30 do
								last[i].x = last[i].x + _dx
								last[i].y = last[i].y + _dy
								last[i].hscale, last[i].vscale = last[i].hscale + dh, last[i].vscale + 0.05
								last[i].a, last[i].b = last[i].a + 1.25 * dh / 0.175, last[i].b + 0.35
								task.Wait(1)
							end
						end)
						a0 = a0 + 12
						_dh = _dh + 0.007
					end
				end

				local function stick(x, y, u)
					local point = {}
					local len, angle
					--枝干
					len, angle = ran:Int(20, 24), 90 + u * ran:Int(-30, -45)
					point[1] = { x, y }
					point[2] = { x + len * cos(angle), y + len * sin(angle) }
					local _u = u
					--3, 4
					local angle0 = angle
					for i = 1, 2 do
						len, angle = ran:Int(16, 21), angle0 + _u * ran:Int(-30, -40)
						point[2 + i] = { point[2][1] + len * cos(angle), point[2][2] + len * sin(angle) }
						_u = -_u
					end
					--5, 6
					angle0 = Angle(point[2][1], point[2][2], point[3][1], point[3][2])
					for i = 1, 2 do
						len, angle = ran:Int(12, 15), angle0 + _u * ran:Int(-20, -30)
						point[4 + i] = { point[3][1] + len * cos(angle), point[3][2] + len * sin(angle) }
						_u = -_u
					end

					--控制树枝行为的函数
					local function f1(o, p1x, p1y, p2x, p2y)
						o.hscale, o.vscale = 0, 0.7
						o.a = 0
						task.New(o, function()
							local x, y, t = o.x, o.y, 30
							local d1x, d1y, d2x, d2y = (0.5 * (p1x + p2x - x) + p1x - x) / t, (0.5 * (p1y + p2y - y) + p1y - y) / t, (0.5 * (p1x + p2x - x) + p2x - x) / t, (0.5 * (p1y + p2y - y) + p2y - y) / t
							local x1, y1, x2, y2, dl, dx, dy = o.x, o.y, o.x, o.y, 0, d1x, d1x
							for _ = 1, t do
								x1 = x1 + d1x
								y1 = y1 + d1y
								x2 = x2 + d2x
								y2 = y2 + d2y
								o.x, o.y = o.x + d1x, o.y + d1y
								dl = Dist(x1, y1, x2, y2)
								o.hscale, o.a = dl / 8, dl
								task.Wait(1)
							end
						end)
					end
					--控制小玉行为的函数
					local function f2(o, px, py)
						o.hscale, o.vscale = 0, 0
						o.a, o.b = 0, 0
						task.New(o, function()
							local x, y, t = o.x, o.y, 30
							local dx, dy = 1.9 * (px - x) / t, 1.9 * (py - y + 26) / t
							for _ = 1, t do
								o.x, o.y = o.x + dx, o.y + dy
								o.hscale, o.vscale = o.hscale + 1 / 30, o.vscale + 1 / 30
								o.a, o.b = o.a + 4 / 30, o.b + 4 / 30
								task.Wait(1)
							end
						end)
					end
					--创建树枝和小玉
					local s, ball = {}, {}
					s[1] = New(straight, laserbullet, 10, true, self.x, self.y, 0, Angle(point[1][1], point[1][2], point[2][1], point[2][2]))
					f1(s[1], point[1][1], point[1][2], point[2][1], point[2][2])
					s[2] = New(straight, laserbullet, 10, true, self.x, self.y, 0, Angle(point[2][1], point[2][2], point[3][1], point[3][2]))
					f1(s[2], point[2][1], point[2][2], point[3][1], point[3][2])
					s[3] = New(straight, laserbullet, 10, true, self.x, self.y, 0, Angle(point[2][1], point[2][2], point[4][1], point[4][2]))
					f1(s[3], point[2][1], point[2][2], point[4][1], point[4][2])
					s[4] = New(straight, laserbullet, 10, true, self.x, self.y, 0, Angle(point[3][1], point[3][2], point[5][1], point[5][2]))
					f1(s[4], point[3][1], point[3][2], point[5][1], point[5][2])
					s[5] = New(straight, laserbullet, 10, true, self.x, self.y, 0, Angle(point[3][1], point[3][2], point[6][1], point[6][2]))
					f1(s[5], point[3][1], point[3][2], point[6][1], point[6][2])
					local co = { 10, 3, 6, 1, 14 }
					for i = 1, 5 do
						ball[i] = New(straight, ball_mid, co[i], true, self.x, self.y, 0, 0)
						f2(ball[i], point[1 + i][1], point[1 + i][2])
					end
					local v, a = ran:Float(0.5, 0.75), 90 + ran:Float(10, 20) * u
					for i = 1, 5 do
						SetV(s[i], v, a)
						SetV(ball[i], v, a)
						AddSimStrChV(s[i], 0, 6, -90, 180)
						AddSimStrChV(ball[i], 0, 6, -90, 180)
					end
				end

				local laji = { dragon_ball, stone_bowl, fire_clothes, shell, stick }

				local function b3(x, y)
					local last = {}
					--生成随机的垃圾小玉
					task.New(self, function()
						for i = 1, 5 do
							co = ran:Int(1, 14)
							last[i] = New(straight, ball_mid_c, co, false, x + ran:Float(-10, 10), y + ran:Float(-10, 10), ran:Float(1, 1.75), 90 + ran:Float(-45, 45))
							last[i].timer = 11
							last[i].hscale, last[i].vscale = 0, 0
							last[i].a, last[i].b = 0, 0
							last[i]._blend, last[i]._a, last[i]._r, last[i]._g, last[i]._b = "mul+add", 255, 255, 255, 255
							AddSimStrChV(last[i], 0, 5, -90, 300)
							task.New(last[i], function()
								for _ = 1, 10 do
									last[i].hscale, last[i].vscale = last[i].hscale + 0.1, last[i].vscale + 0.1
									last[i].a, last[i].b = last[i].a + 0.4, last[i].b + 0.4
									task.Wait(1)
								end
							end)
							task.Wait(2)
						end
					end)
				end

				do
					local a, _d_a = (0), (22.5)
					for _ = 1, 16 do
						last = New(straight, star_big, 14, true, self.x, self.y, 2.5, a)
						last.omiga = 1
						a = a + _d_a
					end
				end
				do
					local a0, _d_a0 = (0), (15)
					for _ = 1, 24 do
						do
							local dv, _d_dv = (0), (0.5)
							local a, _d_a = (a0), (7.5)
							for _ = 1, 2 do
								b1(dv, a)
								b2(dv, a)
								dv = dv + _d_dv
								a = a + _d_a
							end
						end
						a0 = a0 + _d_a0
					end
				end
				--task._Wait(180)
				task.MoveTo(0, 100, 120, MOVE_NORMAL)
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					task._Wait(60)
				end
				self._wisys:setAction("cast", 64 * 10)
				lasttask = task.New(self, function()
					task._Wait(64 * 10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					frame = 6
					way = 9
					layer = 2
					sp = 90
					self._wisys:setAction("cast1", 48 * 10)
					task._Wait(48 * 10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					frame = 4
					way = 15
					layer = 3
					sp = 120
					self._wisys:setAction("cast2", 9999)
				end)
				task._Wait(24)
				local u, num = -1
				lasttask = task.New(self, function()
					do
						for _ = 1, _infinite do
							PlaySound("kira00", 0.1, 0, false)
							b3(self.x, self.y)
							task.Wait(10 * frame)
						end
					end
				end)
				lasttask = task.New(self, function()
					task._Wait(60)
					local u, _a, a0 = -1
					do
						for _ = 1, _infinite do
							_a = Angle(self, player)
							do
								local a, _d_a = (-80 * u), (sp / (way - 1) * u)
								for _ = 1, way do
									a0 = -90 + 90 * u + a
									for i = 1, layer do
										last = New(_straight, arrow_small, COLOR_DEEP_GREEN, self.x + 30 * cos(a0), self.y + 30 * sin(a0), 2 + 0.5*i, -90 + 90 * u + a + _a * u, false, 0, true, true, 0, false, 0, 0, 0, false)
									end
									a = a + _d_a
								end
							end
							task.Wait(6 * frame)
							u = -u
						end
					end
				end)
				do
					for _ = 1, _infinite do
						getRandomSort(laji)
						for num = 1, 5 do
							laji[num](self.x - 5 * u, self.y, u)
							u = -u
							task.Wait(8 * frame)
						end
					end
				end
			end)
		end
		function _tmp_sc:del()
			--self.sc_bonus_max = 10000000
			--self.sc_bonus_base = 2000000
		end
		_editor_cards.s1_02_N = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage1boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage1boss:Normal", "常规攻击2", _tmp_sc, #stage1boss.cards, true })

		_tmp_sc = boss.dialog.New(true)
		function _tmp_sc:init()
			player.dialog = false
			self.dialog_displayer = New(dialog_displayer)
			self._dialog_maintask = task.New(self, function()
				task._Wait(60)
				self._wisys:setAction("cast3", 80)
				task._Wait(80)
			end)
		end
		table.insert(stage1boss.cards, _tmp_sc)
		boss_action(stage1boss, 0, 134)
		_tmp_sc = boss.card.New("神宝「天星逆月」", 3, 5, 60, 1600, { 10, 20, 30 }, false)
		function _tmp_sc:init()
			lasttask = task.New(self, function()
				do
					s1_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
						task._Wait(60)
					end
				end
				do
					local a, _d_a = (0), (36)
					for _ = 1, 10 do
						last = New(_editor_class["s1_二符使魔_EN"], self.x, self.y, a, 1, 360)
						task._Wait(0)
						a = a + _d_a
					end
				end
				do
					local a, _d_a = (0), (36)
					for _ = 1, 10 do
						last = New(_editor_class["s1_二符使魔_EN"], self.x, self.y, a, -1, 450)
						task._Wait(0)
						a = a + _d_a
					end
				end
				do
					local a, _d_a = (33), (45)
					for _ = 1, 8 do
						last = New(_editor_class["s1_二符使魔2:Normal"], self.x, self.y, a, -1)
						_connect(self, last, 0, true)
						task._Wait(0)
						a = a + _d_a
					end
				end
				task._Wait(60)
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					task._Wait(60)
				end
				local i = 1
				do
					for _ = 1, _infinite do
						local a = Angle(self, player)
						lasttask = task.New(self, function()
							do
								local b, _d_b = (0), (-2 * i)
								local vv, _d_vv = (2), (-0.2)
								for _ = 1, 7 do
									do
										local v, _d_v = (1), (2 / 4)
										for _ = 1, 5 do
											last = New(_editor_class["s1_二符米弹"], self.x, self.y, v + vv, a + b, ball_big, COLOR_CYAN)
											task._Wait(0)
											v = v + _d_v
										end
									end
									task._Wait(5)
									b = b + _d_b
									vv = vv + _d_vv
								end
							end
						end)
						do
							local b, _d_b = (0), (2 * i)
							local vv, _d_vv = (2), (-0.2)
							for _ = 1, 7 do
								do
									local v, _d_v = (1), (2 / 4)
									for _ = 1, 5 do
										last = New(_editor_class["s1_二符米弹"], self.x, self.y, v + vv, a + b, ball_big, COLOR_CYAN)
										task._Wait(0)
										v = v + _d_v
									end
								end
								task._Wait(5)
								b = b + _d_b
								vv = vv + _d_vv
							end
						end
						task._Wait(10)
						PlaySound("kira00", 0.4, self.x / 256, false)
						task._Wait(60)
						task._Wait(60)
					end
				end
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 106, 207, 120, "bamboo_leaf_white", "tree_leaf_white")
		end
		_editor_cards.s1_12_N = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage1boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage1boss:Normal", "神宝「天星逆月」", _tmp_sc, #stage1boss.cards, true })


	end
	_editor_class["stage1boss:Normal"] = stage1boss
end

--Hard
do
	--关底boss子弹，事件定义（以前的东西太乱了先暂时放着，有时间再优化吧
	do
		_editor_class["s1_一符使魔:Hard"] = Class(_object)
		_editor_class["s1_一符使魔:Hard"].init = function(self, _x, _y, a0, i)
			self.x, self.y = _x, _y
			self.img = "magic8"
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
			self.bound = false
			lasttask = task.New(self, function()
				task._Wait(90)
				self.bound = true
			end)
			_object.set_color(self, "mul+add", 255, 255, 255, 255)
			self.vscale = 0.8
			self.hscale = 0.8
			self.omiga = 4
			lasttask = task.New(self, function()
				self.v = 2
				lasttask = task.New(self, function()
					do
						for _ = 1, 60 do
							self.v = self.v + 5 / 60
							task._Wait(1)
						end
					end
					_del(self, true)
				end)
				do
					local a, _d_a = (a0), (2.3 * i)
					local da, _d_da = (90), (-50 / 60)
					local t, _d_t = (120), (-120 / 60)
					for _ = 1, 60 do
						SetV2(self, self.v, a, false, false)
						if (self.timer % 8 == 0 and Dist(self, player) >= 32) then
							last = New(_editor_class["s1_一符米弹:Hard"], self.x, self.y, a - 60 * i, 2.5, COLOR_GRAY, i, t, da)
							PlaySound("tan00", 0.1, self.x / 256, false)
						else
						end
						task._Wait(1)
						a = a + _d_a
						da = da + _d_da
						t = t + _d_t
					end
				end
			end)
		end
		_editor_class["s1_一符椭圆中心:Hard"] = Class(_object)
		_editor_class["s1_一符椭圆中心:Hard"].init = function(self, _x, _y, i)
			self.x, self.y = _x, _y
			self.img = "img_void"
			self.layer = LAYER_ENEMY_BULLET - 1
			self.group = GROUP_INDES
			self.hide = true
			self.bound = true
			self.navi = false
			self.hp = 10
			self.maxhp = 10
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.bound = false
			self.rot = 90 - 45 * i
			lasttask = task.New(self, function()
				do
					local a, _d_a = (0), (180)
					for _ = 1, 2 do
						last = New(_editor_class["s1_一符椭圆使魔:Hard"], self.x, self.y, a, i, i)
						_connect(self, last, 0, true)
						task._Wait(0)
						a = a + _d_a
					end
				end
				task._Wait(80)
				_del(self, true)
			end)
		end
		_editor_class["s1_一符椭圆使魔:Hard"] = Class(bullet)
		_editor_class["s1_一符椭圆使魔:Hard"].init = function(self, _x, _y, a0, i, j)
			bullet.init(self, arrow_big, 8, false, false)
			self.x, self.y = _x, _y
			self.hscale = 0
			self.vscale = 0
			self.a = 0
			self.b = 0
			self.bound = false
			self.navi = true
			lasttask = task.New(self, function()
				local da = 1.1 * i
				local rot = 90 - 45 * j
				do
					local a, _d_a = (a0), (4.73 * i)
					local r, _d_r = (50), (100 / 80)
					for _ = 1, _infinite do
						_set_rel_pos(self, r * cos(a), r * sin(a) * 0.6, self.rot, true)
						if (self.timer % 4 == 0) then
							last = New(_editor_class["s1_花预警"], self.x, self.y, a + rot + 90 * i - da, COLOR_PURPLE)
							da = da + 8.7 * i
						else
						end
						task._Wait(1)
						a = a + _d_a
						r = r + _d_r
					end
				end
			end)
		end
		_editor_class["s1_一符米弹:Hard"] = Class(bullet)
		_editor_class["s1_一符米弹:Hard"].init = function(self, _x, _y, a, v, c, i, t, da)
			bullet.init(self, ellipse, c, true, true)
			self.x, self.y = _x, _y
			self.rot = a
			self.navi = true
			lasttask = task.New(self, function()
				do
					local aerfa, _d_aerfa = (90), (-180 / t)
					for _ = 1, t do
						SetV2(self, v / 4 + v * sin(aerfa) / 4, a, true, false)
						task._Wait(1)
						aerfa = aerfa + _d_aerfa
					end
				end
				last = New(_editor_class["s1_一符最终加速弹"], self.x, self.y, a + 100 * i, v, c, i, arrow_big, da)
				_del(self, true)
			end)
		end
		_editor_class["s1_二符使魔2:Hard"] = Class(_object)
		_editor_class["s1_二符使魔2:Hard"].init = function(self, _x, _y, a, i)
			self.x, self.y = _x, _y
			self.img = "magic3"
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
			self.omiga = 3
			_object.set_color(self, "mul+add", 0, 255, 255, 50)
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (250 / 89)
					for _ = 1, 90 do
						_object.set_color(self, "mul+add", al, 255, 255, 50)
						task._Wait(1)
						al = al + _d_al
					end
				end
				lasttask = task.New(self, function()
					do
						local b, _d_b = (a), (9 * i)
						for _ = 1, _infinite do
							do
								local a1, _d_a1 = (0), (72)
								for _ = 1, 5 do
									last = New(_straight, star_small, COLOR_GRAY, self.x + 10 * cos(a1), self.y + 10 * sin(a1), 0, a1 + b, false, 3 * i, true, true, 0, false, 0.015, a1 + b, 1.75, false)
									task._Wait(0)
									a1 = a1 + _d_a1
								end
							end
							task._Wait(30)
							b = b + _d_b
						end
					end
				end)
			end)
			lasttask = task.New(self, function()
				do
					local angle, _d_angle = (a), (7 * i)
					for _ = 1, _infinite do
						_set_rel_pos(self, 100 * cos(angle), 100 * sin(angle), self.rot, false)
						task._Wait(1)
						angle = angle + _d_angle
					end
				end
			end)
		end
	end
	--关底boss定义
	local stage1boss
	do
		stage1boss = Class(boss)
		stage1boss.cards = {}
		stage1boss.name = "Kaguya"
		stage1boss.init = function(self, cards)
			boss.init(self, 240, 384, "Kaguya", cards, New(s1_boss.scbg), "Hard")
			lstg.wis.Kaguya(self)
		end
		stage1boss.bgm = "s1_boss"
		stage1boss._bg = stage1_background
		stage1boss.difficulty = "Hard"
		-- 出场
		s1_boss_common_action(stage1boss)
		-- 攻击
		_tmp_sc = boss.card.New("常规攻击1", 2, 5, 40, 1200, { 0, 0, 0 }, false, "normal")
		function _tmp_sc:init()
			boss.show_aura(self, true)
			local mode = 'new'
			local i = ran:Sign()
			lasttask = task.New(self, function()
				task.MoveTo(0, 94, 1, MOVE_NORMAL)
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					task._Wait(60)
				end
				local ia = i
				do
					for _ = 1, _infinite do
						ia0, rai, sa = ia, ran:Sign(), ran:Float(0, 360)
						do
							for _ = 1, 2 do
								lasttask = task.New(self, _editor_tasks["seasons_stage_1_boss_nospell1_task"](3, ia0, rai, sa))
								task._Wait(60)
								task.MoveToPlayer(60, -96, 96, 82, 94, 16, 32, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
								task._Wait(60)
								ia0, rai = -ia0, -rai
							end
						end
						task._Wait(60)
						lasttask = task.New(self, function()
							task.MoveToPlayer(120, -96, 96, 82, 94, 64, 112, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
						end)
						local timdiff, dwaydiff, dadiff = { 4, 6, 4, 6 }, { 0, 0, 1, 1 }, { 0, 0, 90, 75 }
						local tim, dway, da = 4, 1, 90
						do
							local way, _d_way = (1), (dway)
							local sp, _d_sp = (0), (da / (tim - 1))
							for _ = 1, tim do
								PlaySound("tan00", 0.1, self.x / 256, false)
								do
									local sv, _d_sv = (1.5), (2 / 7)
									for _ = 1, 6 do
										do
											local sa, _d_sa = (Angle(self, player) - sp / 2 * ia), (sp * ia / (way - 1))
											for _ = 1, way do
												last = New(_straight, ellipse, COLOR_PURPLE, self.x, self.y, sv, sa, false, 0, true, true, 0, false, 0, 0, 0, false)
												sa = sa + _d_sa
											end
										end
										sv = sv + _d_sv
									end
								end
								task._Wait(120 / tim)
								way = way + _d_way
								sp = sp + _d_sp
							end
						end
						task._Wait(60)
						ia = -ia
					end
				end
			end)
		end
		function _tmp_sc:del()
			--self.sc_bonus_max = 10000000
			--self.sc_bonus_base = 2000000
		end
		_editor_cards.s1_01_H = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage1boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage1boss:Hard", "常规攻击1", _tmp_sc, #stage1boss.cards, true })

		boss_action(stage1boss, 0, 112)
		_tmp_sc = boss.card.New("秽土「墨花吐芳」", 2, 8, 60, 1500, { 10, 20, 30 }, false)
		function _tmp_sc:init()
			lasttask = task.New(self, function()
				do
					s1_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
						task._Wait(60)
					end
				end
				lasttask = task.New(self, function()
					lasttask = task.New(self, function()
						task._Wait(120)
						do
							for _ = 1, _infinite do
								last = New(_editor_class["s1_一符星弹"], ran:Float(-200, 200), 240 + ran:Float(-10, 10), 270, 0, 3 + ran:Float(-1, 1), COLOR_PURPLE)
								task._Wait(13)
							end
						end
					end)
					do
						local w, _d_w = (1), (1)
						for _ = 1, _infinite do
							do
								local x, _d_x = (-150), (150)
								for _ = 1, 4 do
									last = New(_editor_class["s1_一符背景星弹"], x + ran:Float(-100, 100), self.y + ran:Float(-10, 10), ran:Float(85, 95), w % 10)
									task._Wait(0)
									x = x + _d_x
								end
							end
							task._Wait(2)
							w = w + _d_w
						end
					end
				end)
				local i = 1
				do
					for _ = 1, _infinite do
						do
							local a, _d_a = (Angle(self, player)), (18)
							for _ = 1, 20 do
								last = New(_editor_class["s1_一符使魔:Hard"], self.x, self.y, a, i)
								task._Wait(0)
								a = a + _d_a
							end
						end
						i = -i
						task._Wait(100)
						do
							local a, _d_a = (Angle(self, player)), (18)
							for _ = 1, 20 do
								last = New(_editor_class["s1_一符使魔:Hard"], self.x, self.y, a, i)
								task._Wait(0)
								a = a + _d_a
							end
						end
						task._Wait(120)
						task.MoveToPlayer(60, -16, 16, 112, 124, 5, 6, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
						last = New(_editor_class["s1_一符椭圆中心:Hard"], self.x, self.y, i)
						task.MoveToPlayer(60, -16, 16, 112, 124, 5, 6, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
						task._Wait(1)
					end
				end
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 106, 207, 120, "bamboo_leaf_white", "tree_leaf_white")
		end
		_editor_cards.s1_11_H = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage1boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage1boss:Hard", "秽土「墨花吐芳」", _tmp_sc, #stage1boss.cards, true })


		boss_action(stage1boss, 0, 144)
		_tmp_sc = boss.card.New("常规攻击2", 2, 5, 40, 1500, { 0, 0, 0 }, false, "normal")
		function _tmp_sc:init()
			lasttask = task.New(self, function()
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					task._Wait(60)
				end
				local frame, way, layer, sp = 8, 8, 1, 64
				local function getRandomSort(t)
					--打乱一个数组元素顺序
					local ori = {}
					for _, v in ipairs(t) do
						table.insert(ori, v)
					end
					local ref = {}
					local r
					while #ori > 0 do
						r = ran:Int(1, #ori)
						table.insert(ref, ori[r])
						table.remove(ori, r)
					end
					return ref
				end

				local function b1(dv, a)
					--开幕绿鳞弹
					local last = New(straight, arrow_big, 10, true, self.x, self.y, 2.5 + dv, a)
					task.New(last, function()
						task.Wait(20)
						AddSimStrChV(last, 0, -2, a, 30)
						task.Wait(120)
						AddSimStrChV(last, 0, 2.5, a, 180)
					end)
				end

				local function b2(dv, a)
					--开幕黄小星星
					local last = New(straight, star_small, 12, true, self.x, self.y, 2.4 + dv, a)
					last.omiga = 1
					task.New(last, function()
						task.Wait(20)
						AddSimStrChV(last, 0, -2.5, a, 30)
						task.Wait(20)
						AddSimStrChV(last, 0, 2, a, 240)
					end)
				end

				local function dragon_ball(x, y, u)
					--龙玉
					local co
					local last2
					task.Wait(15)
					co = ran:Int(1, 14)
					last2 = New(straight, ball_mid, co, true, x, y, ran:Float(2, 3), 90 + ran:Float(-20, -30) * u)
					last2.hscale, last2.vscale = 0, 0
					last2.navi = true
					last2.timer = 11
					last2.a = 0
					last2._blend, last2._a, last2._r, last2._g, last2._b = "mul+add", 255, 255, 255, 255
					AddSimStrChV(last2, 0, 6, -90, 180)
					task.New(last2, function()
						for i = 1, 30 do
							last2.hscale, last2.vscale = last2.hscale + 0.1, last2.vscale + 0.1
							last2.a, last2.b = last2.a + 0.4, last2.b + 0.4
							task.Wait(1)
						end
					end)
				end

				local function stone_bowl(x, y, u)
					local last, _i = {}, 0
					local _r1, _r2, _dy, da, a0 = 25, 10, -24, 20
					local _v, _a = ran:Float(1.5, 1.75), 90 + ran:Float(-30, -45) * u
					for _ = 1, 3 do
						a0 = 0
						local r1, r2 = _r1, _r2
						for _ = 1, 18 do
							_i = _i + 1
							local i = _i
							local a = a0
							local dy = _dy
							last[i] = New(straight, water_drop, 13, true, x, y, _v, _a)
							last[i].timer = 11
							last[i].rot = a
							AddSimStrChV(last[i], 0, 6, -90, 180)
							task.New(last[i], function()
								local _dx, _dy = r1 * cos(a) / 30, (dy + r2 * sin(a)) / 30
								for _ = 1, 30 do
									last[i].x = last[i].x + _dx
									last[i].y = last[i].y + _dy
									task.Wait(1)
								end
							end)
							a0 = a0 + da
						end
						_dy = _dy + 12
						_r1 = _r1 + 16
					end
				end

				local function fire_clothes(x, y, u)
					local last, _i = {}, 0
					local _r1, _r2, _dy, da, a0 = 20, 8, 24, 22
					local _v, _a = ran:Float(1.5, 1.75), 90 + ran:Float(-25, -35) * u
					for _ = 1, 5 do
						a0 = -20
						local r1, r2 = _r1, _r2
						for _ = 1, 10 do
							_i = _i + 1
							local i = _i
							local a = a0
							local dy = _dy
							last[i] = New(straight, water_drop, 2, true, x, y, _v, _a)
							last[i].timer = 11
							last[i].rot = 90
							AddSimStrChV(last[i], 0, 6, -90, 180)
							task.New(last[i], function()
								local _dx, _dy = r1 * cos(a) / 30, (dy + r2 * sin(a)) / 30
								for _ = 1, 30 do
									last[i].x = last[i].x + _dx
									last[i].y = last[i].y + _dy
									task.Wait(1)
								end
							end)
							a0 = a0 + da
						end
						_dy = _dy - 12
						_r1 = _r1 + 8
					end
				end

				local function shell(x, y, u)
					--子安贝
					local last, _i = {}, 0
					local _v, _a = ran:Float(1.5, 1.75), 90 + ran:Float(-25, -35) * u
					local a0, _dh = 30, 0.1
					for _ = 1, 11 do
						_i = _i + 1
						local i = _i
						local dh = _dh
						local a = a0
						last[i] = New(straight, ellipse, 6, true, x, y, _v, _a)
						last[i].timer = 11
						last[i].rot = a
						last[i].hscale, last[i].vscale = 0, 0
						last[i].a, last[i].b = 0, 0
						AddSimStrChV(last[i], 0, 6, -90, 180)
						task.New(last[i], function()
							local _dx, _dy = 15 * cos(a) / 30, 10 * sin(a) / 30
							for _ = 1, 30 do
								last[i].x = last[i].x + _dx
								last[i].y = last[i].y + _dy
								last[i].hscale, last[i].vscale = last[i].hscale + dh, last[i].vscale + 0.05
								last[i].a, last[i].b = last[i].a + 1.25 * dh / 0.175, last[i].b + 0.35
								task.Wait(1)
							end
						end)
						a0 = a0 + 12
						_dh = _dh + 0.007
					end
				end

				local function stick(x, y, u)
					local point = {}
					local len, angle
					--枝干
					len, angle = ran:Int(20, 24), 90 + u * ran:Int(-30, -45)
					point[1] = { x, y }
					point[2] = { x + len * cos(angle), y + len * sin(angle) }
					local _u = u
					--3, 4
					local angle0 = angle
					for i = 1, 2 do
						len, angle = ran:Int(16, 21), angle0 + _u * ran:Int(-30, -40)
						point[2 + i] = { point[2][1] + len * cos(angle), point[2][2] + len * sin(angle) }
						_u = -_u
					end
					--5, 6
					angle0 = Angle(point[2][1], point[2][2], point[3][1], point[3][2])
					for i = 1, 2 do
						len, angle = ran:Int(12, 15), angle0 + _u * ran:Int(-20, -30)
						point[4 + i] = { point[3][1] + len * cos(angle), point[3][2] + len * sin(angle) }
						_u = -_u
					end

					--控制树枝行为的函数
					local function f1(o, p1x, p1y, p2x, p2y)
						o.hscale, o.vscale = 0, 0.7
						o.a = 0
						task.New(o, function()
							local x, y, t = o.x, o.y, 30
							local d1x, d1y, d2x, d2y = (0.5 * (p1x + p2x - x) + p1x - x) / t, (0.5 * (p1y + p2y - y) + p1y - y) / t, (0.5 * (p1x + p2x - x) + p2x - x) / t, (0.5 * (p1y + p2y - y) + p2y - y) / t
							local x1, y1, x2, y2, dl, dx, dy = o.x, o.y, o.x, o.y, 0, d1x, d1x
							for _ = 1, t do
								x1 = x1 + d1x
								y1 = y1 + d1y
								x2 = x2 + d2x
								y2 = y2 + d2y
								o.x, o.y = o.x + d1x, o.y + d1y
								dl = Dist(x1, y1, x2, y2)
								o.hscale, o.a = dl / 8, dl
								task.Wait(1)
							end
						end)
					end
					--控制小玉行为的函数
					local function f2(o, px, py)
						o.hscale, o.vscale = 0, 0
						o.a, o.b = 0, 0
						task.New(o, function()
							local x, y, t = o.x, o.y, 30
							local dx, dy = 1.9 * (px - x) / t, 1.9 * (py - y + 26) / t
							for _ = 1, t do
								o.x, o.y = o.x + dx, o.y + dy
								o.hscale, o.vscale = o.hscale + 1 / 30, o.vscale + 1 / 30
								o.a, o.b = o.a + 4 / 30, o.b + 4 / 30
								task.Wait(1)
							end
						end)
					end
					--创建树枝和小玉
					local s, ball = {}, {}
					s[1] = New(straight, laserbullet, 10, true, self.x, self.y, 0, Angle(point[1][1], point[1][2], point[2][1], point[2][2]))
					f1(s[1], point[1][1], point[1][2], point[2][1], point[2][2])
					s[2] = New(straight, laserbullet, 10, true, self.x, self.y, 0, Angle(point[2][1], point[2][2], point[3][1], point[3][2]))
					f1(s[2], point[2][1], point[2][2], point[3][1], point[3][2])
					s[3] = New(straight, laserbullet, 10, true, self.x, self.y, 0, Angle(point[2][1], point[2][2], point[4][1], point[4][2]))
					f1(s[3], point[2][1], point[2][2], point[4][1], point[4][2])
					s[4] = New(straight, laserbullet, 10, true, self.x, self.y, 0, Angle(point[3][1], point[3][2], point[5][1], point[5][2]))
					f1(s[4], point[3][1], point[3][2], point[5][1], point[5][2])
					s[5] = New(straight, laserbullet, 10, true, self.x, self.y, 0, Angle(point[3][1], point[3][2], point[6][1], point[6][2]))
					f1(s[5], point[3][1], point[3][2], point[6][1], point[6][2])
					local co = { 10, 3, 6, 1, 14 }
					for i = 1, 5 do
						ball[i] = New(straight, ball_mid, co[i], true, self.x, self.y, 0, 0)
						f2(ball[i], point[1 + i][1], point[1 + i][2])
					end
					local v, a = ran:Float(0.5, 0.75), 90 + ran:Float(10, 20) * u
					for i = 1, 5 do
						SetV(s[i], v, a)
						SetV(ball[i], v, a)
						AddSimStrChV(s[i], 0, 6, -90, 180)
						AddSimStrChV(ball[i], 0, 6, -90, 180)
					end
				end

				local laji = { dragon_ball, stone_bowl, fire_clothes, shell, stick }

				local function b3(x, y)
					local last = {}
					--生成随机的垃圾小玉
					task.New(self, function()
						for i = 1, 10 do
							co = ran:Int(1, 14)
							last[i] = New(straight, ball_mid_c, co, false, x + ran:Float(-10, 10), y + ran:Float(-10, 10), ran:Float(1, 1.75), 90 + ran:Float(-45, 45))
							last[i].timer = 11
							last[i].hscale, last[i].vscale = 0, 0
							last[i].a, last[i].b = 0, 0
							last[i]._blend, last[i]._a, last[i]._r, last[i]._g, last[i]._b = "mul+add", 255, 255, 255, 255
							AddSimStrChV(last[i], 0, 5, -90, 300)
							task.New(last[i], function()
								for _ = 1, 10 do
									last[i].hscale, last[i].vscale = last[i].hscale + 0.1, last[i].vscale + 0.1
									last[i].a, last[i].b = last[i].a + 0.4, last[i].b + 0.4
									task.Wait(1)
								end
							end)
							task.Wait(1)
						end
					end)
				end

				do
					local a, _d_a = (0), (18)
					for _ = 1, 20 do
						last = New(straight, star_big, 14, true, self.x, self.y, 3.2, a)
						last.omiga = 1
						a = a + _d_a
					end
				end
				do
					local a0, _d_a0 = (0), (15)
					for _ = 1, 24 do
						do
							local dv, _d_dv = (0), (0.5)
							local a, _d_a = (a0), (7.5)
							for _ = 1, 4 do
								b1(dv, a)
								b2(dv, a)
								dv = dv + _d_dv
								a = a + _d_a
							end
						end
						a0 = a0 + _d_a0
					end
				end
				--task._Wait(180)
				task.MoveTo(0, 100, 120, MOVE_NORMAL)
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					task._Wait(60)
				end
				self._wisys:setAction("cast", 64 * 10)
				lasttask = task.New(self, function()
					task._Wait(64 * 10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					frame = 6
					way = 12
					sp = 90
					layer = 2
					self._wisys:setAction("cast1", 48 * 10)
					task._Wait(48 * 10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					frame = 4
					way = 18
					sp = 120
					layer = 3
					self._wisys:setAction("cast2", 9999)
				end)
				task._Wait(24)
				local u, num = -1
				lasttask = task.New(self, function()
					do
						for _ = 1, _infinite do
							PlaySound("kira00", 0.1, 0, false)
							b3(self.x, self.y)
							task.Wait(10 * frame)
						end
					end
				end)
				lasttask = task.New(self, function()
					task._Wait(60)
					local u, _a, a0 = -1
					do
						for _ = 1, _infinite do
							_a = Angle(self, player)
							do
								local a, _d_a = (-0.5*sp), (sp / (way - 1))
								for _ = 1, way do
									a0 = -90 + 90 * u + a
									for i = 1, layer do
										last = New(_straight, arrow_small, COLOR_DEEP_GREEN, self.x + 30 * cos(a0), self.y + 30 * sin(a0), 2.5 + 0.5*i, -90 + 90 * u + a + _a * u, false, 0, true, true, 0, false, 0, 0, 0, false)
									end
									a = a + _d_a
								end
							end
							task.Wait(6 * frame)
							u = -u
						end
					end
				end)
				do
					for _ = 1, _infinite do
						getRandomSort(laji)
						for num = 1, 5 do
							laji[num](self.x - 5 * u, self.y, u)
							u = -u
							task.Wait(8 * frame)
						end
					end
				end
			end)
		end
		function _tmp_sc:del()
			--self.sc_bonus_max = 10000000
			--self.sc_bonus_base = 2000000
		end
		_editor_cards.s1_02_H = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage1boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage1boss:Hard", "常规攻击2", _tmp_sc, #stage1boss.cards, true })


		_tmp_sc = boss.dialog.New(true)
		function _tmp_sc:init()
			player.dialog = false
			self.dialog_displayer = New(dialog_displayer)
			self._dialog_maintask = task.New(self, function()
				task._Wait(60)
				self._wisys:setAction("cast3", 80)
				task._Wait(80)
			end)
		end
		table.insert(stage1boss.cards, _tmp_sc)
		boss_action(stage1boss, 0, 134)
		_tmp_sc = boss.card.New("地球遗产「月光弹珠」", 3, 5, 60, 1600, { 10, 20, 30 }, false)
		function _tmp_sc:init()
			lasttask = task.New(self, function()
				do
					s1_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
						task._Wait(60)
					end
				end
				do
					local a, _d_a = (0), (36)
					for _ = 1, 10 do
						last = New(_editor_class["s1_二符使魔"], self.x, self.y, a, 1, 360)
						task._Wait(0)
						a = a + _d_a
					end
				end
				do
					local a, _d_a = (0), (36)
					for _ = 1, 10 do
						last = New(_editor_class["s1_二符使魔"], self.x, self.y, a, -1, 240)
						task._Wait(0)
						a = a + _d_a
					end
				end
				do
					local a, _d_a = (33), (45)
					for _ = 1, 8 do
						last = New(_editor_class["s1_二符使魔2:Hard"], self.x, self.y, a, 1)
						_connect(self, last, 0, true)
						task._Wait(0)
						a = a + _d_a
					end
				end
				task._Wait(60)
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					task._Wait(60)
				end
				local i = 1
				do
					local c, _d_c = (0), (17.1 * i)
					for _ = 1, _infinite do
						lasttask = task.New(self, function()
							do
								local b, _d_b = (0), (-1.5 * i)
								local vv, _d_vv = (2.5), (-0.25)
								for _ = 1, 7 do
									do
										local v, _d_v = (1), (2.5 / 5)
										for _ = 1, 6 do
											do
												local a, _d_a = (0), (45)
												for _ = 1, 8 do
													last = New(_editor_class["s1_二符米弹"], self.x, self.y, v + vv, a + b + c, arrow_big, COLOR_CHARTREUSE)
													task._Wait(0)
													a = a + _d_a
												end
											end
											task._Wait(0)
											v = v + _d_v
										end
									end
									task._Wait(3)
									b = b + _d_b
									vv = vv + _d_vv
								end
							end
						end)
						do
							local b, _d_b = (0), (1.5 * i)
							local vv, _d_vv = (2.5), (-0.25)
							for _ = 1, 7 do
								do
									local v, _d_v = (1), (2.5 / 5)
									for _ = 1, 6 do
										do
											local a, _d_a = (0), (45)
											for _ = 1, 8 do
												last = New(_editor_class["s1_二符米弹"], self.x, self.y, v + vv, a + b + c, arrow_big, COLOR_CHARTREUSE)
												task._Wait(0)
												a = a + _d_a
											end
										end
										task._Wait(0)
										v = v + _d_v
									end
								end
								task._Wait(3)
								b = b + _d_b
								vv = vv + _d_vv
							end
						end
						task._Wait(10)
						PlaySound("kira00", 0.4, self.x / 256, false)
						task._Wait(60)
						task._Wait(60)
						c = c + _d_c
					end
				end
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 106, 207, 120, "bamboo_leaf_white", "tree_leaf_white")
		end
		_editor_cards.s1_12_H = _tmp_sc
		_tmp_sc.perform = false
		table.insert(stage1boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage1boss:Hard", "地球遗产「月光弹珠」", _tmp_sc, #stage1boss.cards, true })
	end
	_editor_class["stage1boss:Hard"] = stage1boss
end

--Lunatic
do
	--关底boss子弹，事件定义（以前的东西太乱了先暂时放着，有时间再优化吧
	do
		_editor_tasks["seasons_stage_1_boss_nospell1_task"] = function(dimode, i, i0, sa)
			return function()
				local self = task.GetSelf()
				local waydiff, dadiff, vdiff = { 12, 9, 6, 4 }, { 210, 300, 480, 660 }, { 1.85, 2.25, 2.65, 3 }
				local rai, way, sr, sv, lv = i0, waydiff[dimode], 48, 2, vdiff[dimode]
				do
					local da, _d_da = (-180), (180 / (180 / way - 1))
					for _ = 1, 180 / way do
						PlaySound("tan00", 0.1, self.x / 256, false)
						local cl = 4 + 2 * rai
						do
							local a, _d_a = (sa), (360 / 4 * i)
							for _ = 1, 4 do
								do
									local a0, _d_a0 = (a - 3 * i), (6 * i / 2)
									for _ = 1, 3 do
										last = New(_editor_class["seasons_stage_1_boss_nospell1_task_bullet"], self.x + sr * cos(a0), self.y + sr * sin(a0), i, rai, sv, a0, cl, lv, da)
										a0 = a0 + _d_a0
									end
								end
								a = a + _d_a
							end
						end
						rai, sr, sv, lv, sa = -rai, sr - 32 / (180 / way - 1), sv + 2 / (180 / way - 1), lv - 1.5 / (180 / way - 1), sa + dadiff[dimode] * 1.168 * i / (180 / way - 1)
						task._Wait(way)
						da = da + _d_da
					end
				end
			end
		end
		_editor_class["seasons_stage_1_boss_nospell1_task_bullet"] = Class(bullet)
		_editor_class["seasons_stage_1_boss_nospell1_task_bullet"].init = function(self, _x, _y, i, i0, sv, sa, cl, lv, da)
			bullet.init(self, grain_a, cl, true, true)
			self.x, self.y = _x, _y
			self.rot, self.timer, self.colli = sa, 11, false
			self.hscale, self.vscale = 2, 2
			_object.set_color(self, "", 0, 255, 255, 255)
			lasttask = task.New(self, function()
				do
					local si, _d_si = (0), (90 / 14)
					for _ = 1, 15 do
						self.hscale, self.vscale = 2 - sin(si), 2 - sin(si)
						_object.set_color(self, "", 255 * sin(si), 255, 255, 255)
						task._Wait(1)
						si = si + _d_si
					end
				end
				self.colli = true
				do
					local v, _d_v = (sv), (-sv / 59)
					for _ = 1, 60 do
						SetV2(self, v, sa, true, false)
						task._Wait(1)
						v = v + _d_v
					end
				end
				PlaySound("kira00", 0.1, self.x / 256, false)
				self.colli = false
				local la = sa - 180 * i + da * i0
				self.rot = la
				ChangeBulletImage(self, grain_c, cl)
				do
					local si, _d_si = (0), (90 / 14)
					for _ = 1, 15 do
						self.hscale, self.vscale = 2 - sin(si), 2 - sin(si)
						_object.set_color(self, "", 255 * sin(si), 255, 255, 255)
						task._Wait(1)
						si = si + _d_si
					end
				end
				self.colli = true
				do
					local v, _d_v = (0), (lv / 59)
					for _ = 1, 60 do
						SetV2(self, v, la, true, false)
						task._Wait(1)
						v = v + _d_v
					end
				end
			end)
		end
		_editor_class["s1_一符星弹"] = Class(bullet)
		_editor_class["s1_一符星弹"].init = function(self, _x, _y, a, aa, v, c)
			bullet.init(self, star_big, c, true, true)
			self.x, self.y = _x, _y
			local change_a = aa + ran:Float(-10, 10)
			local change_v = 0.75
			self.vscale = 0
			self.hscale = 0
			self.v = v
			self.angle = a
			self.rot = a
			self.timer = 11
			lasttask = task.New(self, _editor_tasks["s1_1符时间缩放"](10, 0.8, 4))
			lasttask = task.New(self, function()
				do
					local i, _d_i = (1), (79 / 39)
					for _ = 1, 40 do
						SetV2(self, self.v * cos(i), self.angle, false, false)
						task._Wait(1)
						i = i + _d_i
					end
				end
				do
					local t, _d_t = (0), (90 / 179)
					local aa, _d_aa = (self.angle), (change_a / 179)
					for _ = 1, 180 do
						SetV2(self, GetV(self) + change_v * (1 / 90), aa, false, false)
						task._Wait(1)
						t = t + _d_t
						aa = aa + _d_aa
					end
				end
			end)
		end
		_editor_class["s1_一符星弹"].render = function(self)
			self.class.base.render(self)
		end
		_editor_class["s1_一符背景星弹"] = Class(bullet)
		_editor_class["s1_一符背景星弹"].init = function(self, _x, _y, a, wave)
			bullet.init(self, star_big, COLOR_GREEN, true, true)
			self.x, self.y = _x, _y
			self.vscale = 0
			self.hscale = 0
			self.angle = a
			self.timer = 11
			if (wave <= 5) then
				lasttask = task.New(self, _editor_tasks["sf_时间缩放"](50, 0.5, 4 * ran:Sign()))
			else
				lasttask = task.New(self, _editor_tasks["sf_时间缩放"](50, 0.4, 4 * ran:Sign()))
			end
			_set_a(self, 0.04, self.angle, false)
		end
		_editor_class["s1_一符背景星弹"].render = function(self)
			self.class.base.render(self)
		end
		_editor_class["s1_一符使魔:Lunatic"] = Class(_object)
		_editor_class["s1_一符使魔:Lunatic"].init = function(self, _x, _y, a0, i)
			self.x, self.y = _x, _y
			self.img = "magic6"
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
			self.bound = false
			lasttask = task.New(self, function()
				task._Wait(90)
				self.bound = true
			end)
			_object.set_color(self, "mul+add", 255, 255, 255, 255)
			self.vscale = 0.8
			self.hscale = 0.8
			self.omiga = 4
			lasttask = task.New(self, function()
				self.v = 2
				lasttask = task.New(self, function()
					do
						for _ = 1, 60 do
							self.v = self.v + 6 / 60
							task._Wait(1)
						end
					end
					_del(self, true)
				end)
				do
					local a, _d_a = (a0), (2.3 * i)
					local da, _d_da = (90), (-40 / 60)
					local t, _d_t = (120), (-120 / 60)
					for _ = 1, 60 do
						SetV2(self, self.v, a, false, false)
						if (self.timer % 6 == 0 and Dist(self, player) >= 32) then
							last = New(_editor_class["s1_一符米弹:Lunatic"], self.x, self.y, a - 80 * i, 3, 7 + i, i, t, da)
							PlaySound("tan00", 0.1, self.x / 256, false)
						else
						end
						task._Wait(1)
						a = a + _d_a
						da = da + _d_da
						t = t + _d_t
					end
				end
			end)
		end
		_editor_class["s1_一符椭圆中心:Lunatic"] = Class(_object)
		_editor_class["s1_一符椭圆中心:Lunatic"].init = function(self, _x, _y, i)
			self.x, self.y = _x, _y
			self.img = "img_void"
			self.layer = LAYER_ENEMY_BULLET - 1
			self.group = GROUP_INDES
			self.hide = true
			self.bound = true
			self.navi = false
			self.hp = 10
			self.maxhp = 10
			self.colli = false
			self._servants = {}
			self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
			self.bound = false
			self.rot = 90 - 45 * i
			lasttask = task.New(self, function()
				do
					local a, _d_a = (0), (180)
					for _ = 1, 2 do
						last = New(_editor_class["s1_一符椭圆使魔:Lunatic"], self.x, self.y, a, i, i)
						_connect(self, last, 0, true)
						last = New(_editor_class["s1_一符椭圆使魔:Lunatic"], self.x, self.y, a, -i, i)
						_connect(self, last, 0, true)
						task._Wait(0)
						a = a + _d_a
					end
				end
				task._Wait(40)
				_del(self, true)
			end)
		end
		_editor_class["s1_一符椭圆使魔:Lunatic"] = Class(bullet)
		_editor_class["s1_一符椭圆使魔:Lunatic"].init = function(self, _x, _y, a0, i, j)
			bullet.init(self, arrow_big, 8, false, false)
			self.x, self.y = _x, _y
			self.hscale = 0
			self.vscale = 0
			self.a = 0
			self.b = 0
			self.bound = false
			self.navi = true
			lasttask = task.New(self, function()
				local da = 0.5 * i
				local rot = 90 - 45 * j
				do
					local a, _d_a = (a0), (1.73 * i * 2)
					local r, _d_r = (50), (100 / 40)
					for _ = 1, _infinite do
						_set_rel_pos(self, r * cos(a), r * sin(a) * 0.6, self.rot, true)
						if (self.timer % 4 == 0) then
							do
								local b, _d_b = (0), (180)
								for _ = 1, 1 do
									last = New(_editor_class["s1_花预警"], self.x, self.y, a + rot + 90 * i + da + b, COLOR_CYAN)
									b = b + _d_b
								end
							end
							da = da + 3.5 * i
						else
						end
						task._Wait(1)
						a = a + _d_a
						r = r + _d_r
					end
				end
			end)
		end
		_editor_class["s1_一符米弹:Lunatic"] = Class(bullet)
		_editor_class["s1_一符米弹:Lunatic"].init = function(self, _x, _y, a, v, c, i, t, da)
			bullet.init(self, ellipse, c, true, true)
			self.x, self.y = _x, _y
			self.rot = a
			self.navi = true
			lasttask = task.New(self, function()
				do
					local aerfa, _d_aerfa = (90), (-180 / t)
					for _ = 1, t do
						SetV2(self, v / 4 + v * sin(aerfa) / 4, a, true, false)
						task._Wait(1)
						aerfa = aerfa + _d_aerfa
					end
				end
				last = New(_editor_class["s1_一符最终加速弹"], self.x, self.y, a + 50 * i, v, c, i, grain_a, da)
				_del(self, true)
			end)
		end
		_editor_class["s1_一符最终加速弹"] = Class(bullet)
		_editor_class["s1_一符最终加速弹"].init = function(self, _x, _y, a, v, c, i, sty, da)
			bullet.init(self, sty, c, true, true)
			self.x, self.y = _x, _y
			self.rot = a
			self.navi = true
			SetV2(self, 0, a, true, false)
			lasttask = task.New(self, function()
				do
					local aerfa, _d_aerfa = (-90), (180 / 60)
					local aa, _d_aa = (a), (da * i / 60)
					for _ = 1, 60 do
						SetV2(self, v / 2 + v * sin(aerfa) / 2, aa, true, false)
						task._Wait(1)
						aerfa = aerfa + _d_aerfa
						aa = aa + _d_aa
					end
				end
			end)
		end
		_editor_class["s1_花预警"] = Class(laser)
		_editor_class["s1_花预警"].init = function(self, _x, _y, a, c)
			laser.init(self, c, _x, _y, 0, 0, 0, 0, 4, 4, 0)
			lasttask = task.New(self, function()
				laser.ChangeImage(self, 2)
				self.rot = a
				_object.set_color(self, "mul+add", 200, 50, 100, 200)
				lasttask = task.New(self, function()
					do
						local aerfa, _d_aerfa = (0), (90 / 39)
						for _ = 1, 40 do
							self.l1 = 100 * sin(aerfa)
							self.l2 = 300 * sin(aerfa)
							self.l3 = 100 * sin(aerfa)
							task._Wait(1)
							aerfa = aerfa + _d_aerfa
						end
					end
				end)
				laser._TurnHalfOn(self, 5, false)
				task._Wait(60)
				last = New(_editor_class["s1_花射线"], self.x, self.y, 11, a, c)
				_object.set_color(self, "mul+add", 200, 50, 100, 200)
				do
					local w, _d_w = (4), (5 / 10)
					for _ = 1, 10 do
						self.w = w
						task._Wait(1)
						w = w + _d_w
					end
				end
				task._Wait(10)
				_del(self, true)
			end)
		end
		_editor_class["s1_花预警"].kill = function(self)
		end
		_editor_class["s1_花射线"] = Class(laser)
		_editor_class["s1_花射线"].init = function(self, _x, _y, v, a, c)
			laser.init(self, c, _x, _y, 0, 0, 0, 0, 6, 8, 0)
			lasttask = task.New(self, function()
				laser.ChangeImage(self, 2)
				self.rot = a
				laser._TurnOn(self, 1, false, false)
				PlaySound("lazer00", 0.5, 0, false)
				do
					local l, _d_l = (40), (v)
					for _ = 1, 10 do
						self.l1 = 0.9 * l
						self.l2 = 0.2 * l
						self.l3 = 1.3 * l
						task._Wait(1)
						l = l + _d_l
					end
				end
				self.node = 0
				SetV2(self, v, a, true, false)
			end)
		end
		_editor_class["s1_花射线"].kill = function(self)
		end
		_editor_tasks["s1_1符时间缩放"] = function(time, h, omiga)
			return function()
				local self = task.GetSelf()
				self.hscale = 0
				self.vscale = 0
				self.omiga = omiga
				local colli_a = self.a * h
				local colli_b = self.b * h
				do
					local scale, _d_scale = (0), (1 / (time - 1))
					local t, _d_t = (0), (90 / (time - 1))
					for _ = 1, time do
						self.hscale = h * sin(t)
						self.vscale = h * sin(t)
						self.a = colli_a * sin(t)
						self.b = colli_b * sin(t)
						task._Wait(1)
						scale = scale + _d_scale
						t = t + _d_t
					end
				end
				self._blend = false
			end
		end
		_editor_class["s1_二符使魔"] = Class(_object)
		_editor_class["s1_二符使魔"].init = function(self, _x, _y, a0, i, rr)
			self.x, self.y = _x, _y
			self.img = "magic5"
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
			self.omiga = 4 * i
			self.bound = false
			_object.set_color(self, "mul+add", 0, 15, 218, 255)
			self.vscale = 0.8
			self.hscale = 0.8
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (250 / 14)
					for _ = 1, 15 do
						_object.set_color(self, "mul+add", al, 15, 218, 255)
						task._Wait(1)
						al = al + _d_al
					end
				end
			end)
			lasttask = task.New(self, function()
				do
					local aerfa, _d_aerfa = (0), (90 / 119)
					local a, _d_a = (a0), (1.3 * i)
					for _ = 1, 120 do
						local r = 960 - (960 - rr) * sin(aerfa)
						self.x = r * cos(a)
						self.y = -200 + r * sin(a) / 2
						if (self.timer % 2 == 0) then
							last = New(_editor_class["s1_二符火弹"], self.x, self.y, a, 10 + 4 * i)
						else
						end
						task._Wait(1)
						aerfa = aerfa + _d_aerfa
						a = a + _d_a
					end
				end
				do
					local a, _d_a = (a0 + 1.3 * 120 * i), (1.3 * i)
					for _ = 1, _infinite do
						self.x = rr * cos(a)
						self.y = -200 + rr * sin(a) / 2
						if (self.timer % 2 == 0) then
							last = New(_editor_class["s1_二符火弹"], self.x, self.y, a, 10 + 4 * i)
						else
						end
						task._Wait(1)
						a = a + _d_a
					end
				end
			end)
		end
		_editor_class["s1_二符火弹"] = Class(bullet)
		_editor_class["s1_二符火弹"].init = function(self, _x, _y, a, c)
			bullet.init(self, water_drop, COLOR_BLUE, true, true)
			self.group = GROUP_INDES
			self.x, self.y = _x, _y
			self.vscale = 0
			self.hscale = 0
			self.angle = a
			self.v = 5
			self.timer = 11
			lasttask = task.New(self, _editor_tasks["sf_时间缩放"](50, 1, 0))
			lasttask = task.New(self, function()
				do
					local vv, _d_vv = (0), (1 / 9)
					for _ = 1, 10 do
						SetV2(self, vv, self.angle, true, false)
						task._Wait(1)
						vv = vv + _d_vv
					end
				end
				do
					local acc, _d_acc = (0.005), (0.001)
					for _ = 1, _infinite do
						if (sqrt(self.vx ^ 2 + self.vy ^ 2) > self.v) then
							_set_a(self, 0, self.angle, false)
							if true then
								break
							end
						else
							_set_a(self, acc, self.angle, false)
						end
						task._Wait(1)
						acc = acc + _d_acc
					end
				end
			end)
		end
		_editor_class["s1_二符火弹"].render = function(self)
			self.class.base.render(self)
		end
		_editor_class["s1_二符米弹"] = Class(bullet)
		_editor_class["s1_二符米弹"].init = function(self, _x, _y, v, a, sty, c)
			bullet.init(self, sty, c + 1, false, true)
			self.group = GROUP_INDES
			self.x, self.y = _x, _y
			SetV2(self, v, a, true, false)
			self.navi = true
			lasttask = task.New(self, function()
				do
					local v1, _d_v1 = (v), (-v / 15)
					for _ = 1, 15 do
						SetV2(self, v1, a, true, false)
						task._Wait(3)
						v1 = v1 + _d_v1
					end
				end
				_set_a(self, v / 50, a, false)
				task._Wait(100)
				_set_a(self, 0, a, false)
			end)
		end
		_editor_class["s1_二符使魔2:Lunatic"] = Class(_object)
		_editor_class["s1_二符使魔2:Lunatic"].init = function(self, _x, _y, a, i)
			self.x, self.y = _x, _y
			self.img = "magic3"
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
			self.omiga = 3
			_object.set_color(self, "mul+add", 0, 255, 255, 50)
			lasttask = task.New(self, function()
				do
					local al, _d_al = (0), (250 / 89)
					for _ = 1, 90 do
						_object.set_color(self, "mul+add", al, 255, 255, 50)
						task._Wait(1)
						al = al + _d_al
					end
				end
				lasttask = task.New(self, function()
					do
						local b, _d_b = (a), (8 * i)
						for _ = 1, _infinite do
							do
								local a1, _d_a1 = (0), (60)
								for _ = 1, 6 do
									last = New(_straight, star_small, COLOR_GRAY, self.x + 10 * cos(a1), self.y + 10 * sin(a1), 0, a1 + b, false, 3 * i, true, true, 0, false, 0.015, a1 + b, 2, false)
									task._Wait(0)
									a1 = a1 + _d_a1
								end
							end
							task._Wait(30)
							b = b + _d_b
						end
					end
				end)
			end)
			lasttask = task.New(self, function()
				do
					local angle, _d_angle = (a), (7 * i)
					for _ = 1, _infinite do
						_set_rel_pos(self, 100 * cos(angle), 100 * sin(angle), self.rot, false)
						task._Wait(1)
						angle = angle + _d_angle
					end
				end
			end)
		end
	end
	--关底boss定义
	local stage1boss
	do
		stage1boss = Class(boss)
		stage1boss.cards = {}
		stage1boss.name = "Kaguya"
		stage1boss.init = function(self, cards)
			boss.init(self, 240, 384, "Kaguya", cards, New(s1_boss.scbg), "Lunatic")
			lstg.wis.Kaguya(self)
		end
		stage1boss.bgm = "s1_boss"
		stage1boss._bg = stage1_background
		stage1boss.difficulty = "Lunatic"
		-- 出场
		s1_boss_common_action(stage1boss)
		-- 攻击
		_tmp_sc = boss.card.New("常规攻击1", 2, 5, 40, 1200, { 0, 0, 0 }, false, "normal")
		function _tmp_sc:init()
			boss.show_aura(self, true)
			local mode = 'new'
			local i = ran:Sign()
			lasttask = task.New(self, function()
				task.MoveTo(0, 94, 1, MOVE_NORMAL)
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					task._Wait(60)
				end
				local ia = i
				do
					for _ = 1, _infinite do
						ia0, rai, sa = ia, ran:Sign(), ran:Float(0, 360)
						do
							for _ = 1, 2 do
								lasttask = task.New(self, _editor_tasks["seasons_stage_1_boss_nospell1_task"](4, ia0, rai, sa))
								task._Wait(60)
								task.MoveToPlayer(60, -96, 96, 82, 94, 16, 32, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
								task._Wait(60)
								ia0, rai = -ia0, -rai
							end
						end
						task._Wait(60)
						lasttask = task.New(self, function()
							task.MoveToPlayer(120, -96, 96, 82, 94, 64, 112, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
						end)
						local timdiff, dwaydiff, dadiff = { 4, 6, 4, 6 }, { 0, 0, 1, 1 }, { 0, 0, 90, 75 }
						local tim, dway, da = 6, 1, 120
						do
							local way, _d_way = (1), (dway)
							local sp, _d_sp = (0), (da / (tim - 1))
							for _ = 1, tim do
								PlaySound("tan00", 0.1, self.x / 256, false)
								do
									local sv, _d_sv = (1.5), (2 / 7)
									for _ = 1, 6 do
										do
											local sa, _d_sa = (Angle(self, player) - sp / 2 * ia), (sp * ia / (way - 1))
											for _ = 1, way do
												last = New(_straight, ellipse, COLOR_PURPLE, self.x, self.y, sv, sa, false, 0, true, true, 0, false, 0, 0, 0, false)
												sa = sa + _d_sa
											end
										end
										sv = sv + _d_sv
									end
								end
								task._Wait(120 / tim)
								way = way + _d_way
								sp = sp + _d_sp
							end
						end
						task._Wait(60)
						ia = -ia
					end
				end
			end)
		end
		function _tmp_sc:del()
			--self.sc_bonus_max = 10000000
			--self.sc_bonus_base = 2000000
		end
		_editor_cards.s1_01_L = _tmp_sc
		_tmp_sc.perform = true
		table.insert(stage1boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage1boss:Lunatic", "常规攻击1", _tmp_sc, #stage1boss.cards, true })

		boss_action(stage1boss, 0, 112)
		_tmp_sc = boss.card.New("秽土「箣花的桃源乡」", 2, 8, 60, 1500, { 10, 20, 30 }, false)
		function _tmp_sc:init()
			lasttask = task.New(self, function()
				do
					s1_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
						task._Wait(60)
					end
				end
				lasttask = task.New(self, function()
					lasttask = task.New(self, function()
						task._Wait(120)
						do
							for _ = 1, _infinite do
								last = New(_editor_class["s1_一符星弹"], ran:Float(-200, 200), 240 + ran:Float(-10, 10), 270, 0, 3.2 + ran:Float(-1, 1), COLOR_YELLOW)
								task._Wait(9)
							end
						end
					end)
					do
						local w, _d_w = (1), (1)
						for _ = 1, _infinite do
							do
								local x, _d_x = (-150), (150)
								for _ = 1, 4 do
									last = New(_editor_class["s1_一符背景星弹"], x + ran:Float(-100, 100), self.y + ran:Float(-10, 10), ran:Float(85, 95), w % 10)
									task._Wait(0)
									x = x + _d_x
								end
							end
							task._Wait(2)
							w = w + _d_w
						end
					end
				end)
				local i = 1
				do
					for _ = 1, _infinite do
						do
							local a, _d_a = (Angle(self, player)), (18)
							for _ = 1, 20 do
								last = New(_editor_class["s1_一符使魔:Lunatic"], self.x, self.y, a, i)
								task._Wait(0)
								a = a + _d_a
							end
						end
						i = -i
						task._Wait(100)
						do
							local a, _d_a = (Angle(self, player)), (18)
							for _ = 1, 20 do
								last = New(_editor_class["s1_一符使魔:Lunatic"], self.x, self.y, a, i)
								task._Wait(0)
								a = a + _d_a
							end
						end
						task._Wait(120)
						task.MoveToPlayer(60, -16, 16, 112, 124, 5, 6, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
						last = New(_editor_class["s1_一符椭圆中心:Lunatic"], self.x, self.y, i)
						task.MoveToPlayer(60, -16, 16, 112, 124, 5, 6, 8, 16, MOVE_DECEL, MOVE_X_TOWARDS_PLAYER)
						task._Wait(1)
					end
				end
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 106, 207, 120, "bamboo_leaf_white", "tree_leaf_white")
		end
		_editor_cards.s1_11_L = _tmp_sc
		_tmp_sc.perform = true
		table.insert(stage1boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage1boss:Lunatic", "秽土「箣花的桃源乡」", _tmp_sc, #stage1boss.cards, true })

		boss_action(stage1boss, 0, 144)
		_tmp_sc = boss.card.New("常规攻击2", 2, 5, 40, 1500, { 0, 0, 0 }, false, "normal")
		function _tmp_sc:init()
			lasttask = task.New(self, function()
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					task._Wait(60)
				end
				local frame = 8
				local way, layer, sp = 11, 1, 70
				local function getRandomSort(t)
					--打乱一个数组元素顺序
					local ori = {}
					for _, v in ipairs(t) do
						table.insert(ori, v)
					end
					local ref = {}
					local r
					while #ori > 0 do
						r = ran:Int(1, #ori)
						table.insert(ref, ori[r])
						table.remove(ori, r)
					end
					return ref
				end

				local function b1(dv, a)
					--开幕绿鳞弹
					local last = New(straight, arrow_big, 10, true, self.x, self.y, 3 + dv, a)
					task.New(last, function()
						task.Wait(20)
						AddSimStrChV(last, 0, -2.5, a, 30)
						task.Wait(120)
						AddSimStrChV(last, 0, 3, a, 180)
					end)
				end

				local function b2(dv, a)
					--开幕黄小星星
					local last = New(straight, star_small, 12, true, self.x, self.y, 2.9 + dv, a)
					last.omiga = 1
					task.New(last, function()
						task.Wait(20)
						AddSimStrChV(last, 0, -2.5, a, 30)
						task.Wait(20)
						AddSimStrChV(last, 0, 2, a + ran:Float(-120, 120), 240)
					end)
				end

				local function dragon_ball(x, y, u)
					--龙玉
					local co
					local last2
					task.Wait(15)
					co = ran:Int(1, 14)
					last2 = New(straight, ball_mid, co, true, x, y, ran:Float(2, 3), 90 + ran:Float(-20, -30) * u)
					last2.hscale, last2.vscale = 0, 0
					last2.navi = true
					last2.timer = 11
					last2.a = 0
					last2._blend, last2._a, last2._r, last2._g, last2._b = "mul+add", 255, 255, 255, 255
					AddSimStrChV(last2, 0, 6, -90, 180)
					task.New(last2, function()
						for i = 1, 30 do
							last2.hscale, last2.vscale = last2.hscale + 0.1, last2.vscale + 0.1
							last2.a, last2.b = last2.a + 0.4, last2.b + 0.4
							task.Wait(1)
						end
					end)
				end

				local function stone_bowl(x, y, u)
					local last, _i = {}, 0
					local _r1, _r2, _dy, da, a0 = 25, 10, -24, 20
					local _v, _a = ran:Float(1.5, 1.75), 90 + ran:Float(-30, -45) * u
					for _ = 1, 3 do
						a0 = 0
						local r1, r2 = _r1, _r2
						for _ = 1, 18 do
							_i = _i + 1
							local i = _i
							local a = a0
							local dy = _dy
							last[i] = New(straight, water_drop, 13, true, x, y, _v, _a)
							last[i].timer = 11
							last[i].rot = a
							AddSimStrChV(last[i], 0, 6, -90, 180)
							task.New(last[i], function()
								local _dx, _dy = r1 * cos(a) / 30, (dy + r2 * sin(a)) / 30
								for _ = 1, 30 do
									last[i].x = last[i].x + _dx
									last[i].y = last[i].y + _dy
									task.Wait(1)
								end
							end)
							a0 = a0 + da
						end
						_dy = _dy + 12
						_r1 = _r1 + 16
					end
				end

				local function fire_clothes(x, y, u)
					local last, _i = {}, 0
					local _r1, _r2, _dy, da, a0 = 20, 8, 24, 22
					local _v, _a = ran:Float(1.5, 1.75), 90 + ran:Float(-25, -35) * u
					for _ = 1, 5 do
						a0 = -20
						local r1, r2 = _r1, _r2
						for _ = 1, 10 do
							_i = _i + 1
							local i = _i
							local a = a0
							local dy = _dy
							last[i] = New(straight, water_drop, 2, true, x, y, _v, _a)
							last[i].timer = 11
							last[i].rot = 90
							AddSimStrChV(last[i], 0, 6, -90, 180)
							task.New(last[i], function()
								local _dx, _dy = r1 * cos(a) / 30, (dy + r2 * sin(a)) / 30
								for _ = 1, 30 do
									last[i].x = last[i].x + _dx
									last[i].y = last[i].y + _dy
									task.Wait(1)
								end
							end)
							a0 = a0 + da
						end
						_dy = _dy - 12
						_r1 = _r1 + 8
					end
				end

				local function shell(x, y, u)
					--子安贝
					local last, _i = {}, 0
					local _v, _a = ran:Float(1.5, 1.75), 90 + ran:Float(-25, -35) * u
					local a0, _dh = 30, 0.1
					for _ = 1, 11 do
						_i = _i + 1
						local i = _i
						local dh = _dh
						local a = a0
						last[i] = New(straight, ellipse, 6, true, x, y, _v, _a)
						last[i].timer = 11
						last[i].rot = a
						last[i].hscale, last[i].vscale = 0, 0
						last[i].a, last[i].b = 0, 0
						AddSimStrChV(last[i], 0, 6, -90, 180)
						task.New(last[i], function()
							local _dx, _dy = 15 * cos(a) / 30, 10 * sin(a) / 30
							for _ = 1, 30 do
								last[i].x = last[i].x + _dx
								last[i].y = last[i].y + _dy
								last[i].hscale, last[i].vscale = last[i].hscale + dh, last[i].vscale + 0.05
								last[i].a, last[i].b = last[i].a + 1.25 * dh / 0.175, last[i].b + 0.35
								task.Wait(1)
							end
						end)
						a0 = a0 + 12
						_dh = _dh + 0.007
					end
				end

				local function stick(x, y, u)
					local point = {}
					local len, angle
					--枝干
					len, angle = ran:Int(20, 24), 90 + u * ran:Int(-30, -45)
					point[1] = { x, y }
					point[2] = { x + len * cos(angle), y + len * sin(angle) }
					local _u = u
					--3, 4
					local angle0 = angle
					for i = 1, 2 do
						len, angle = ran:Int(16, 21), angle0 + _u * ran:Int(-30, -40)
						point[2 + i] = { point[2][1] + len * cos(angle), point[2][2] + len * sin(angle) }
						_u = -_u
					end
					--5, 6
					angle0 = Angle(point[2][1], point[2][2], point[3][1], point[3][2])
					for i = 1, 2 do
						len, angle = ran:Int(12, 15), angle0 + _u * ran:Int(-20, -30)
						point[4 + i] = { point[3][1] + len * cos(angle), point[3][2] + len * sin(angle) }
						_u = -_u
					end

					--控制树枝行为的函数
					local function f1(o, p1x, p1y, p2x, p2y)
						o.hscale, o.vscale = 0, 0.7
						o.a = 0
						task.New(o, function()
							local x, y, t = o.x, o.y, 30
							local d1x, d1y, d2x, d2y = (0.5 * (p1x + p2x - x) + p1x - x) / t, (0.5 * (p1y + p2y - y) + p1y - y) / t, (0.5 * (p1x + p2x - x) + p2x - x) / t, (0.5 * (p1y + p2y - y) + p2y - y) / t
							local x1, y1, x2, y2, dl, dx, dy = o.x, o.y, o.x, o.y, 0, d1x, d1x
							for _ = 1, t do
								x1 = x1 + d1x
								y1 = y1 + d1y
								x2 = x2 + d2x
								y2 = y2 + d2y
								o.x, o.y = o.x + d1x, o.y + d1y
								dl = Dist(x1, y1, x2, y2)
								o.hscale, o.a = dl / 8, dl
								task.Wait(1)
							end
						end)
					end
					--控制小玉行为的函数
					local function f2(o, px, py)
						o.hscale, o.vscale = 0, 0
						o.a, o.b = 0, 0
						task.New(o, function()
							local x, y, t = o.x, o.y, 30
							local dx, dy = 1.9 * (px - x) / t, 1.9 * (py - y + 26) / t
							for _ = 1, t do
								o.x, o.y = o.x + dx, o.y + dy
								o.hscale, o.vscale = o.hscale + 1 / 30, o.vscale + 1 / 30
								o.a, o.b = o.a + 4 / 30, o.b + 4 / 30
								task.Wait(1)
							end
						end)
					end
					--创建树枝和小玉
					local s, ball = {}, {}
					s[1] = New(straight, laserbullet, 10, true, self.x, self.y, 0, Angle(point[1][1], point[1][2], point[2][1], point[2][2]))
					f1(s[1], point[1][1], point[1][2], point[2][1], point[2][2])
					s[2] = New(straight, laserbullet, 10, true, self.x, self.y, 0, Angle(point[2][1], point[2][2], point[3][1], point[3][2]))
					f1(s[2], point[2][1], point[2][2], point[3][1], point[3][2])
					s[3] = New(straight, laserbullet, 10, true, self.x, self.y, 0, Angle(point[2][1], point[2][2], point[4][1], point[4][2]))
					f1(s[3], point[2][1], point[2][2], point[4][1], point[4][2])
					s[4] = New(straight, laserbullet, 10, true, self.x, self.y, 0, Angle(point[3][1], point[3][2], point[5][1], point[5][2]))
					f1(s[4], point[3][1], point[3][2], point[5][1], point[5][2])
					s[5] = New(straight, laserbullet, 10, true, self.x, self.y, 0, Angle(point[3][1], point[3][2], point[6][1], point[6][2]))
					f1(s[5], point[3][1], point[3][2], point[6][1], point[6][2])
					local co = { 10, 3, 6, 1, 14 }
					for i = 1, 5 do
						ball[i] = New(straight, ball_mid, co[i], true, self.x, self.y, 0, 0)
						f2(ball[i], point[1 + i][1], point[1 + i][2])
					end
					local v, a = ran:Float(0.5, 0.75), 90 + ran:Float(10, 20) * u
					for i = 1, 5 do
						SetV(s[i], v, a)
						SetV(ball[i], v, a)
						AddSimStrChV(s[i], 0, 6, -90, 180)
						AddSimStrChV(ball[i], 0, 6, -90, 180)
					end
				end

				local laji = { dragon_ball, stone_bowl, fire_clothes, shell, stick }

				local function b3(x, y)
					local last = {}
					--生成随机的垃圾小玉
					task.New(self, function()
						for i = 1, 15 do
							co = ran:Int(1, 14)
							last[i] = New(straight, ball_mid_c, co, false, x + ran:Float(-10, 10), y + ran:Float(-10, 10), ran:Float(1.25, 2), 90 + ran:Float(-45, 45))
							last[i].timer = 11
							last[i].hscale, last[i].vscale = 0, 0
							last[i].a, last[i].b = 0, 0
							last[i]._blend, last[i]._a, last[i]._r, last[i]._g, last[i]._b = "mul+add", 255, 255, 255, 255
							AddSimStrChV(last[i], 0, 5, -90, 300)
							task.New(last[i], function()
								for _ = 1, 10 do
									last[i].hscale, last[i].vscale = last[i].hscale + 0.1, last[i].vscale + 0.1
									last[i].a, last[i].b = last[i].a + 0.4, last[i].b + 0.4
									task.Wait(1)
								end
							end)
							task.Wait(1)
						end
					end)
				end

				do
					local a, _d_a = (0), (15)
					for _ = 1, 24 do
						last = New(straight, star_big, 14, true, self.x, self.y, 4, a)
						last.omiga = 1
						last = New(straight, star_big, 14, true, self.x, self.y, 5, a + 7.5)
						last.omiga = 1
						a = a + _d_a
					end
				end
				do
					local a0, _d_a0 = (0), (10)
					for _ = 1, 36 do
						do
							local dv, _d_dv = (0), (0.3)
							local a, _d_a = (a0), (5)
							for _ = 1, 6 do
								b1(dv, a)
								b2(dv, a)
								dv = dv + _d_dv
								a = a + _d_a
							end
						end
						a0 = a0 + _d_a0
					end
				end
				--task._Wait(180)
				task.MoveTo(0, 100, 120, MOVE_NORMAL)
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					task._Wait(60)
				end
				self._wisys:setAction("cast", 64 * 10)
				lasttask = task.New(self, function()
					task._Wait(64 * 10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					frame = 6
					way = 15
					layer = 2
					sp = 100
					self._wisys:setAction("cast1", 48 * 10)
					task._Wait(48 * 10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					frame = 4
					way = 24
					layer = 3
					sp = 150
					self._wisys:setAction("cast2", 9999)
				end)
				task._Wait(24)
				local u, num = -1
				lasttask = task.New(self, function()
					do
						for _ = 1, _infinite do
							PlaySound("kira00", 0.1, 0, false)
							b3(self.x, self.y)
							task.Wait(10 * frame)
						end
					end
				end)
				lasttask = task.New(self, function()
					task._Wait(60)
					local u, _a, a0 = -1
					do
						for _ = 1, _infinite do
							_a = Angle(self, player)
							do
								local a, _d_a = (-0.5*sp), (sp / way-1)
								for _ = 1, way do
									a0 = -90 + 90 * u + a
									for j = 1, layer do
										last = New(_straight, arrow_small, COLOR_DEEP_GREEN, self.x + 30 * cos(a0), self.y + 30 * sin(a0), 3 + 0.5*j, -90 + 90 * u + a + _a * u, false, 0, true, true, 0, false, 0, 0, 0, false)
									end
									a = a + _d_a
								end
							end
							task.Wait(6 * frame)
							u = -u
						end
					end
				end)
				do
					for _ = 1, _infinite do
						getRandomSort(laji)
						for num = 1, 5 do
							laji[num](self.x - 5 * u, self.y, u)
							u = -u
							task.Wait(8 * frame)
						end
					end
				end
			end)
		end
		function _tmp_sc:del()
			--self.sc_bonus_max = 10000000
			--self.sc_bonus_base = 2000000
		end
		_editor_cards.s1_02_L = _tmp_sc
		_tmp_sc.perform = true
		table.insert(stage1boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage1boss:Lunatic", "常规攻击2", _tmp_sc, #stage1boss.cards, true })

		_tmp_sc = boss.dialog.New(true)
		function _tmp_sc:init()
			player.dialog = false
			self.dialog_displayer = New(dialog_displayer)
			self._dialog_maintask = task.New(self, function()
				task._Wait(60)
				self._wisys:setAction("cast3", 80)
				task._Wait(80)
			end)
		end
		table.insert(stage1boss.cards, _tmp_sc)
		boss_action(stage1boss, 0, 134)
		_tmp_sc = boss.card.New("地球遗产「月光弹珠」", 3, 5, 60, 1600, { 10, 20, 30 }, false)
		function _tmp_sc:init()
			lasttask = task.New(self, function()
				do
					s1_boss.pic_show()
					task._Wait(120)
					do
						task._Wait(10)
						New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
						task._Wait(60)
					end
				end
				do
					local a, _d_a = (0), (36)
					for _ = 1, 10 do
						last = New(_editor_class["s1_二符使魔"], self.x, self.y, a, 1, 360)
						task._Wait(0)
						a = a + _d_a
					end
				end
				do
					local a, _d_a = (0), (36)
					for _ = 1, 10 do
						last = New(_editor_class["s1_二符使魔"], self.x, self.y, a, -1, 240)
						task._Wait(0)
						a = a + _d_a
					end
				end
				do
					local a, _d_a = (33), (36)
					for _ = 1, 10 do
						last = New(_editor_class["s1_二符使魔2:Lunatic"], self.x, self.y, a, 1)
						_connect(self, last, 0, true)
						task._Wait(0)
						a = a + _d_a
					end
				end
				task._Wait(60)
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'bamboo_leaf_white', 'tree_leaf_white', 106, 207, 120)
					task._Wait(60)
				end
				local i = 1
				do
					local c, _d_c = (0), (17.1 * i)
					for _ = 1, _infinite do
						lasttask = task.New(self, function()
							do
								local b, _d_b = (0), (-1.7 * i)
								local vv, _d_vv = (2.5), (-0.25)
								for _ = 1, 7 do
									do
										local v, _d_v = (1), (3 / 6)
										for _ = 1, 7 do
											do
												local a, _d_a = (0), (45)
												for _ = 1, 8 do
													last = New(_editor_class["s1_二符米弹"], self.x, self.y, v + vv, a + b + c, arrow_big, COLOR_CHARTREUSE)
													task._Wait(0)
													a = a + _d_a
												end
											end
											task._Wait(0)
											v = v + _d_v
										end
									end
									task._Wait(3)
									b = b + _d_b
									vv = vv + _d_vv
								end
							end
						end)
						do
							local b, _d_b = (0), (1.7 * i)
							local vv, _d_vv = (2.5), (-0.25)
							for _ = 1, 7 do
								do
									local v, _d_v = (1), (3 / 6)
									for _ = 1, 7 do
										do
											local a, _d_a = (0), (45)
											for _ = 1, 8 do
												last = New(_editor_class["s1_二符米弹"], self.x, self.y, v + vv, a + b + c, arrow_big, COLOR_CHARTREUSE)
												task._Wait(0)
												a = a + _d_a
											end
										end
										task._Wait(0)
										v = v + _d_v
									end
								end
								task._Wait(3)
								b = b + _d_b
								vv = vv + _d_vv
							end
						end
						task._Wait(10)
						PlaySound("kira00", 0.4, self.x / 256, false)
						task._Wait(60)
						task._Wait(60)
						c = c + _d_c
					end
				end
			end)
		end
		function _tmp_sc:del()
			Spell_break_eff(self.x, self.y, 106, 207, 120, "bamboo_leaf_white", "tree_leaf_white")
		end
		_editor_cards.s1_12_L = _tmp_sc
		_tmp_sc.perform = true
		table.insert(stage1boss.cards, _tmp_sc)
		table.insert(_sc_table, { "stage1boss:Lunatic", "地球遗产「月光弹珠」", _tmp_sc, #stage1boss.cards, true })
	end
	_editor_class["stage1boss:Lunatic"] = stage1boss
end

function s1_boss.main(diff, nolscachi)
	local boss
	diff = diff or difficulty
	if diff == 1 then
		boss = New(_editor_class["stage1boss:Easy"], _editor_class["stage1boss:Easy"].cards)
	elseif diff == 2 then
		boss = New(_editor_class["stage1boss:Normal"], _editor_class["stage1boss:Normal"].cards)
	elseif diff == 3 then
		boss = New(_editor_class["stage1boss:Hard"], _editor_class["stage1boss:Hard"].cards)
	elseif diff == 4 then
		boss = New(_editor_class["stage1boss:Lunatic"], _editor_class["stage1boss:Lunatic"].cards)
	end
	--关底boss等待
	while IsValid(boss) do
		task.Wait(1)
	end
	if system.checkChainAchieve() then
		if not nolscachi then
			--成就 解锁一面LSC (id:31)
			achievement.unlock("31", true)
		end
		task.Wait(180)
		LSC_eff(0, 0, 106, 207, 120, "bamboo_leaf_white", "tree_leaf_white")
		task.Wait(120)
		s1_boss.LSC()
	end
	do
		for _ = 1, 60 do
			for _, unit in ObjList(GROUP_ENEMY_BULLET) do
				_del(unit, true)
			end
			task.Wait(1)
		end
	end
	if EISlib.stage.canDialog() then
		task.Wait(60)
		dialog.player.playScene("Stage1_after", true)
	end
end
