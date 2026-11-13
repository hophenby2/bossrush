--弹幕定义
--region
_editor_class["reimu_lsc_yinyang"] = Class(enemy)
_editor_class["reimu_lsc_yinyang"].init = function(self, _x, _y, x, y, t, omiga, r, num, num2, vec, acc, num3, u, sp)
	enemy.init(self, 36, 10, false, false, true, nil, nil, nil, nil, true)
	self.x, self.y = _x, _y
	--self.drop = { 0, 0, 0 }
	task.New(self, function()
		self.protect = true
		task.Wait(1)
		self.protect = false
	end)
	self.omiga = omiga
	self.rot = Angle(self.x, self.y, x, y)
	self.group = GROUP_GHOST
	lasttask = task.New(self, function()
		do
			for _ = 1, _infinite do
				if not IsValid(_boss) then
					break
				end
				task._Wait(1)
			end
		end
		_del(self, true)
	end)
	lasttask = task.New(self, function()
		do
			local omiga_new, _d_omiga_new = (self.omiga - self.omiga / (t - 1)), (-self.omiga / (t - 1))
			for _ = 1, t do
				self.omiga = omiga_new
				task._Wait(1)
				omiga_new = omiga_new + _d_omiga_new
			end
		end
	end)
	--[[lasttask = task.New(self, function()
		do
			local a, _d_a = (ran:Float(0, 360)), (360 / num)
			for _ = 1, num do
				last = New(_editor_class["reimu_lsc_b"], self.x, self.y, self, a, r, vec, acc, t)
				a = a + _d_a
			end
		end
		local a0 = Angle(self.x, self.y, x, y)
		task.MoveTo(x, y, t, MOVE_DECEL)
		task._Wait(150)
		PlaySound("tan00", 0.1, 0, false)
		do
			local a, _d_a = (a0 + 45 * u - 0.5 * (360 - sp)), (-sp / (num2 - 1))
			for _ = 1, num2 do
				do
					local dv, _d_dv = (4), (0.25)
					for _ = 1, num3 do
						last = New(_editor_class["reimu_lsc_b2"], self.x, self.y, a, vec * 0.6, dv)
						dv = dv + _d_dv
					end
				end
				a = a + _d_a
			end
		end
		_del(self, true)
	end)]]
end
_editor_class["reimu_lsc_b"] = Class(bullet)
_editor_class["reimu_lsc_b"].init = function(self, _x, _y, master, angle, radius, v0, v1)
	bullet.init(self, square, COLOR_RED, true, true)
	self.x, self.y = _x, _y
	self.bound = false
	self.navi = true
	self.rot = angle
	local an = angle - master.rot
	lasttask = task.New(self, function()
		self.layer = LAYER_ENEMY_BULLET-1
		do
			local t = 90
			local r, _d_r = (radius / t), (radius / t)
			for _ = 1, t do
				if IsValid(master) then
					local a = master.rot + an
					self.x = master.x + r * cos(a)
					self.y = master.y + r * sin(a)
				else
					break
				end
				task._Wait(1)
				r = r + _d_r
			end
		end
		task._Wait(30)
		local a = Angle(self, player)
		ChangeBulletImage(self, square, COLOR_GRAY)
		self.layer = LAYER_ENEMY_BULLET-1
		PlaySound("kira00", 0.1, 0, false)
		egg.AddAccDecChV(self, v0, a, 20, 0, 60)
		task._Wait(80)
		ChangeBulletImage(self, square, COLOR_RED)
		self.layer = LAYER_ENEMY_BULLET-1
		task.Wait(30)
		a = Angle(self, player)
		egg.AddSimStrChV(self, 1 + v1, v1, a, 20)
		ChangeBulletImage(self, square, COLOR_GRAY)
		self.layer = LAYER_ENEMY_BULLET-1
		self.rot = a
	end)
end
_editor_class["reimu_lsc_b2"] = Class(bullet)
_editor_class["reimu_lsc_b2"].init = function(self, _x, _y, angle, vec, dv)
	bullet.init(self, square, 1, true, true)
	self.x, self.y = _x, _y
	self.bound = false
	lasttask = task.New(self, function()
		self.layer = LAYER_ENEMY_BULLET-1
		self.navi = true
		egg.AddSimStrChV(self, vec, 0, angle, 60)
		task._Wait(60)
		egg.AddSimStrChV(self, 0, dv, angle + 180, 30)
		task._Wait(360)
		self.bound = true
	end)
end
--endregion

--灵梦的蓄力特效
local function eff1(x, y, t)
	New(AbEff, x, y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
	PlaySound("ch00")
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

--dialog
local function dialog1_ENHL(self)
	if ext.sc_pr then
		boss_scpr_show1(self, 0, 0)
	else
		self.x, self.y = 0, 0
		boss.show_aura(self, true)
		lscNoBombCheck(self)
	end
end

--card
local function card1_init_E(self)
	--New(lscSpecialEvent, self)
	local f1
	do
		function f1(x, y)
			local obj = New(_editor_class["reimu_lsc_yinyang"], self.x, self.y, x, y, 90, 3)
			task.New(obj, function()
				do
					local num = 6
					local a, _d_a = (ran:Float(0, 360)), (360 / num)
					for _ = 1, num do
						for i = 0, 0 do
							New(_editor_class["reimu_lsc_b"], obj.x, obj.y, obj, a, 35, 1 + 0.25 * i, 1.75)
						end
						a = a + _d_a
					end
				end
				local a0 = Angle(obj.x, obj.y, x, y)
				task.MoveTo(x, y, 90, MOVE_DECEL)
				task.Wait(150)
				PlaySound("tan00")
				do
					local num2 = 6
					local a, _d_a = a0, 360 / num2
					for _ = 1, num2 do
						do
							for i = 0, 1 do
								New(_editor_class["reimu_lsc_b2"], obj.x, obj.y, a, 2, 1.5 + 0.25 * i)
							end
						end
						a = a + _d_a
					end
				end
				_del(obj, true)
			end)
			return obj
		end
	end
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
			task._Wait(60)
			do
				local x, _d_x = (255), (-127 / 59)
				for _ = 1, 60 do
					_object.set_color(self, "", x, 255, 255, 255)
					task._Wait(1)
					x = x + _d_x
				end
			end
		end)
	end
	self.group = GROUP_NONTJT
	task.New(self, function()
		do
			s3B_boss.pic_show1()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
				task._Wait(60)
			end
		end
		--self._wisys:setAction("cast", 48)
		task._Wait(30)
		do
			local i, _d_i = (0), (1)
			local way, _d_way = (4), (2)
			local a, u, da = 90, 1
			for _ = 1, 4 do
				do
					da = 360 / way * u
					for _ = 1, way do
						self._wisys:setAction("cast", 48)
						task.Wait(30)
						PlaySound("tan00")
						--last = New(_editor_class["reimu_lsc_yinyang"], self.x, self.y, self.x + 192 * cos(a), self.y + 192 * sin(a), 180, 3 * (-1) ^ i, 128, 16, 20, 3.2, 0.04, 9, (-1) ^ i, 270)
						last = f1(100 * cos(a), 75 + 100 * sin(a))
						_connect(self, last, 0, true)
						task.MoveTo(50 * cos(a + da), 75 + 50 * sin(a + da), 240 / way, MOVE_ACC_DEC)
						a = a + da
					end
				end
				task._Wait(180)
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
					task._Wait(60)
				end
				i = i + _d_i
				way = way + _d_way
				u = -u
			end
		end
	end)
end
local function card1_init_N(self)
	--New(lscSpecialEvent, self)
	local f1
	do
		function f1(x, y)
			local obj = New(_editor_class["reimu_lsc_yinyang"], self.x, self.y, x, y, 90, 3)
			task.New(obj, function()
				do
					local num = 8
					local a, _d_a = (ran:Float(0, 360)), (360 / num)
					for _ = 1, num do
						for i = 0, 2 do
							New(_editor_class["reimu_lsc_b"], obj.x, obj.y, obj, a, 35, 1 + 0.25 * i, 1.75)
						end
						a = a + _d_a
					end
				end
				local a0 = Angle(obj.x, obj.y, x, y)
				task.MoveTo(x, y, 90, MOVE_DECEL)
				task.Wait(150)
				PlaySound("tan00", 0.1, 0, false)
				do
					local num2 = 8
					local a, _d_a = a0, 360 / num2
					for _ = 1, num2 do
						do
							for i = 0, 3 do
								New(_editor_class["reimu_lsc_b2"], obj.x, obj.y, a, 2, 1.5 + 0.25 * i)
							end
						end
						a = a + _d_a
					end
				end
				_del(obj, true)
			end)
			return obj
		end
	end
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
			task._Wait(60)
			do
				local x, _d_x = (255), (-127 / 59)
				for _ = 1, 60 do
					_object.set_color(self, "", x, 255, 255, 255)
					task._Wait(1)
					x = x + _d_x
				end
			end
		end)
	end
	self.group = GROUP_NONTJT
	task.New(self, function()
		do
			s3B_boss.pic_show1()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
				task._Wait(60)
			end
		end
		--self._wisys:setAction("cast", 48)
		task._Wait(30)
		do
			local i, _d_i = (0), (1)
			local way, _d_way = (4), (2)
			local a, u, da = 90, 1
			for _ = 1, 4 do
				do
					da = 360 / way * u
					for _ = 1, way do
						self._wisys:setAction("cast", 48)
						for i = 1, 8 do
							for j = 0, 0 do
								stg.newBulletStraight(stg.ball_mid, 4, true, self.x, self.y, 0.6 + 0.2*j, a + 45*i + 15*j)
							end
						end
						task.Wait(30)
						PlaySound("tan00")
						--last = New(_editor_class["reimu_lsc_yinyang"], self.x, self.y, self.x + 192 * cos(a), self.y + 192 * sin(a), 180, 3 * (-1) ^ i, 128, 16, 20, 3.2, 0.04, 9, (-1) ^ i, 270)
						last = f1(100 * cos(a), 100 * sin(a))
						_connect(self, last, 0, true)
						task.MoveTo(50 * cos(a + da), 50 * sin(a + da), 240 / way, MOVE_ACC_DEC)
						a = a + da
					end
				end
				task._Wait(180)
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
					task._Wait(60)
				end
				i = i + _d_i
				way = way + _d_way
				u = -u
			end
		end
	end)
end
local function card1_init_H(self)
	--New(lscSpecialEvent, self)
	local f1
	do
		function f1(x, y)
			local obj = New(_editor_class["reimu_lsc_yinyang"], self.x, self.y, x, y, 90, 3)
			task.New(obj, function()
				do
					local num = 12
					local a, _d_a = (ran:Float(0, 360)), (360 / num)
					for _ = 1, num do
						for i = 0, 3 do
							New(_editor_class["reimu_lsc_b"], obj.x, obj.y, obj, a, 50, 1 + 0.25 * i, 2)
						end
						a = a + _d_a
					end
				end
				local a0 = Angle(obj.x, obj.y, x, y)
				task.MoveTo(x, y, 90, MOVE_DECEL)
				task.Wait(150)
				PlaySound("tan00", 0.1, 0, false)
				do
					local num2 = 12
					local a, _d_a = a0, 360 / num2
					for _ = 1, num2 do
						do
							for i = 0, 5 do
								New(_editor_class["reimu_lsc_b2"], obj.x, obj.y, a, 2, 2 + 0.25 * i)
							end
						end
						a = a + _d_a
					end
				end
				_del(obj, true)
			end)
			return obj
		end
	end
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
			task._Wait(60)
			do
				local x, _d_x = (255), (-127 / 59)
				for _ = 1, 60 do
					_object.set_color(self, "", x, 255, 255, 255)
					task._Wait(1)
					x = x + _d_x
				end
			end
		end)
	end
	self.group = GROUP_NONTJT
	task.New(self, function()
		do
			s3B_boss.pic_show1()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
				task._Wait(60)
			end
		end
		--self._wisys:setAction("cast", 48)
		task._Wait(30)
		do
			local i, _d_i = (0), (1)
			local way, _d_way = (4), (2)
			local a, u, da = 90, 1
			for _ = 1, 4 do
				do
					da = 360 / way * u
					for _ = 1, way do
						self._wisys:setAction("cast", 48)
						for i = 1, 12 do
							for j = 0, 0 do
								stg.newBulletStraight(stg.ball_mid, 4, true, self.x, self.y, 1 + 0.5*j, a + 30*i + 15*j)
							end
						end
						task.Wait(30)
						PlaySound("tan00")
						--last = New(_editor_class["reimu_lsc_yinyang"], self.x, self.y, self.x + 192 * cos(a), self.y + 192 * sin(a), 180, 3 * (-1) ^ i, 128, 16, 20, 3.2, 0.04, 9, (-1) ^ i, 270)
						last = f1(192 * cos(a), 192 * sin(a))
						_connect(self, last, 0, true)
						task.MoveTo(100 * cos(a + da), 100 * sin(a + da), 240 / way, MOVE_ACC_DEC)
						a = a + da
					end
				end
				task._Wait(180)
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
					task._Wait(60)
				end
				i = i + _d_i
				way = way + _d_way
				u = -u
			end
		end
	end)
end
local function card1_init_L(self)
	--New(lscSpecialEvent, self)
	local f1
	do
		function f1(x, y)
			local obj = New(_editor_class["reimu_lsc_yinyang"], self.x, self.y, x, y, 90, 3)
			task.New(obj, function()
				do
					local num = 16
					local a, _d_a = (ran:Float(0, 360)), (360 / num)
					for _ = 1, num do
						for i = 0, 4 do
							New(_editor_class["reimu_lsc_b"], obj.x, obj.y, obj, a, 100, 1.2 + 0.3 * i, 2.5)
						end
						a = a + _d_a
					end
				end
				local a0 = Angle(obj.x, obj.y, x, y)
				task.MoveTo(x, y, 90, MOVE_DECEL)
				task.Wait(150)
				PlaySound("tan00", 0.1, 0, false)
				do
					local num2 = 16
					local a, _d_a = a0, 360 / num2
					for _ = 1, num2 do
						do
							for i = 0, 8 do
								New(_editor_class["reimu_lsc_b2"], obj.x, obj.y, a, 2.5, 1.5 + 0.25 * i)
							end
						end
						a = a + _d_a
					end
				end
				_del(obj, true)
			end)
			return obj
		end
	end
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
			task._Wait(60)
			do
				local x, _d_x = (255), (-127 / 59)
				for _ = 1, 60 do
					_object.set_color(self, "", x, 255, 255, 255)
					task._Wait(1)
					x = x + _d_x
				end
			end
		end)
	end
	self.group = GROUP_NONTJT
	task.New(self, function()
		do
			s3B_boss.pic_show1()
			task._Wait(120)
			do
				task._Wait(10)
				New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
				task._Wait(60)
			end
		end
		--self._wisys:setAction("cast", 48)
		task._Wait(30)
		do
			local i, _d_i = (0), (1)
			local way, _d_way = (4), (2)
			local a, u, da = 90, 1
			for _ = 1, 4 do
				do
					da = 360 / way * u
					for _ = 1, way do
						self._wisys:setAction("cast", 48)
						for i = 1, 12 do
							for j = 0, 1 do
								stg.newBulletStraight(stg.ball_mid, 4, true, self.x, self.y, 0.6 + 0.2*j, a + 30*i + 15*j)
							end
						end
						task.Wait(30)
						PlaySound("tan00")
						--last = New(_editor_class["reimu_lsc_yinyang"], self.x, self.y, self.x + 192 * cos(a), self.y + 192 * sin(a), 180, 3 * (-1) ^ i, 128, 16, 20, 3.2, 0.04, 9, (-1) ^ i, 270)
						last = f1(192 * cos(a), 192 * sin(a))
						_connect(self, last, 0, true)
						task.MoveTo(100 * cos(a + da), 100 * sin(a + da), 240 / way, MOVE_ACC_DEC)
						PlaySound("tan00")
						a = a + da
					end
				end
				task._Wait(180)
				do
					task._Wait(10)
					New(AbEff, self.x, self.y, 'yukari_star', 'reimu_leaf', 255, 0, 0)
					task._Wait(60)
				end
				i = i + _d_i
				way = way + _d_way
				u = -u
			end
		end
	end)
end
local function card1_del_ENHL(self)
	Spell_break_eff(self.x, self.y, 255, 0, 0,
			'yukari_star', 'reimu_leaf')
end

local function create_boss_class(class_name, group)
	return EISlib.stage.createBossClass(group, class_name, "Reimu", s3B_boss.scbg,
			{ "s3_boss1", stage3_background }, 0, 384,
			function(self)
				lstg.wis.Reimu(self)
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
local bossE = create_boss_class("LSC3B:Easy", "Easy")
local bossN = create_boss_class("LSC3B:Normal", "Normal")
local bossH = create_boss_class("LSC3B:Hard", "Hard")
local bossL = create_boss_class("LSC3B:Lunatic", "Lunatic")

create_dialog_class(bossE, dialog1_ENHL)
create_card_class(bossE, "缚灵「梦想封印 阵」", -- 幻灵
		{ 53, 53, 53 }, 1800, {0, 0, 60}, "lastspell", true, card1_init_E, card1_del_ENHL)

create_dialog_class(bossN, dialog1_ENHL)
create_card_class(bossN, "缚灵「梦想封印 阵」",
		{ 53, 53, 53 }, 1800, {0, 0, 60}, "lastspell", true, card1_init_N, card1_del_ENHL)

create_dialog_class(bossH, dialog1_ENHL)
create_card_class(bossH, "幻灵「梦想封印 界」",
		{ 53, 53, 53 }, 1800, {0, 0, 60}, "lastspell", true, card1_init_H, card1_del_ENHL)

create_dialog_class(bossL, dialog1_ENHL)
create_card_class(bossL, "幻灵「梦想封印 界」",
		{ 53, 53, 53 }, 1800, {0, 0, 60}, "lastspell", true, card1_init_L, card1_del_ENHL)

function s3B_boss.LSC(diff)
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
