---=====================================
---th style boss system misc
---额外的函数
---=====================================

local pairs, ipairs = pairs, ipairs
local insert, remove = table.insert, table.remove
local IsValid = lstg.IsValid

---@return boss.object[]
local function _init_boss_table()
	if type(lstg.tmpvar._ex_bosss) ~= "table" then
		lstg.tmpvar._ex_bosss = {}
	end
	for i = #lstg.tmpvar._ex_bosss, 1, -1 do
		if not IsValid(lstg.tmpvar._ex_bosss[i]) then
			remove(lstg.tmpvar._ex_bosss, i)
		end
	end
	return lstg.tmpvar._ex_bosss
end

----------------------------------------
---boss 管理

---随机获取一个boss
---@return boss.object
function boss.GetRandomBoss()
	local t = _init_boss_table()
	return t[ran:Int(1, #t)]
end

---拿到第一个槽位的boss
---@return boss.object
function boss.GetFirstBoss()
	local t = _init_boss_table()
	return t[1]
end

---添加一个boss到全局ex.boss表，并设置_boss
---@param boss boss.object
function boss.AddBoss(boss)
	local t = _init_boss_table()
	insert(t, boss)
	_boss = boss
end

---将一个boss从全局ex.boss表移除
---@param boss boss.object
function boss.RemoveBoss(boss)
	local t = _init_boss_table()
	for i = #t, 1, -1 do
		if t[i] == boss then
			remove(t, i)
		end
	end
end

---@return boss.object[]
function boss.GetBossTable()
	local t = _init_boss_table()
	return t
end

----------------------------------------
---boss 额外函数

---清除boss的碎片掉落
---@param spell boolean @bomb碎片不掉落
---@param chip boolean @残机碎片不掉落
---@param drop boolean @各种小道具
function boss.ClearBonus(spell, chip, drop)
	local t = _init_boss_table()
	for _, b in ipairs(t) do
		if b.sc_bonus then
			b.sc_bonus = 0
		end
		if spell then
			b.chip_bonus = false
		end
		if chip then
			b.bombchip_bonus = false
		end
		if drop then
			b.no_drop_item = true
		end
	end
end

--[[
function boss.PopSpellResult(self, c)
	--boss行为结束逻辑，弹出提示文字、写入存档等
	if c.is_combat then
		self.spell_get = false
		if (self.hp <= 0 and self.timeout == 0) or (c.t1 == c.t3 and self.timeout == 1) then
			if c.drop then
				item.DropItem(self.x, self.y, c.drop)
			end
			item.EndChipBonus(self, self.x, self.y)
			if self.sc_bonus and not c.fake then
				if self.sc_bonus > 0 then
					lstg.var.score = lstg.var.score + self.sc_bonus - self.sc_bonus % 10
					PlaySound('cardget', 1.0, 0)
					New(hinter_bonus, 'hint.getbonus', 0.6, 0, 112, 15, 120, true, self.sc_bonus - self.sc_bonus % 10)
					New(kill_timer, 0, 30, self.timer)
					if not ext.replay.IsReplay() then
						scoredata.spell_card_hist[lstg.var.player_name][self.difficulty][c.name][1] = scoredata.spell_card_hist[lstg.var.player_name][self.difficulty][c.name][1] + 1
					end
					self.spell_get = true
				else
					New(hinter, 'hint.bonusfail', 0.6, 0, 112, 15, 120)
					New(kill_timer, 0, 60, self.timer)
				end
			end
		else
			if c.is_sc and self.timeout == 1 then
				PlaySound('fault', 1.0, 0)
			end
			if self.sc_bonus then
				New(hinter, 'hint.bonusfail', 0.6, 0, 112, 15, 120, 15)
			end
		end
		self.spell_timeout = (self.timeout == 1)
		if self.no_clear_buller then
			--结束符卡后是否需要清除子弹
			self.no_clear_buller = nil
		else
			PlaySound('enep02', 0.4, 0)
			local players = { player }
			--Print("Clear ",#players)
			for _, p in pairs(players) do
				New(bullet_killer, p.x, p.y, true)
			end
		end
	end
	if c.is_sc then
		self.ui.sc_left = self.ui.sc_left - 1
	end
end
--]]
---@param self boss.object
function boss.PopSpellResult(self, c)
	-- 用到的flag
	-- no_clear_bullet
	-- no_pop_result
	-- no_drop_item

	-- 用到的变量
	-- slave_boss

	-- 导出的flag
	-- spell_timeout
	-- spell_get

	--boss行为结束逻辑，弹出提示文字、写入存档等
	if c.is_combat then
		self.spell_get = false
		if (self.hp <= 0 and self.timeout == 0) or (c.t1 == c.t3 and self.timeout == 1) then--时符或者没有超时
			--击破了
			if c.drop and not self.no_drop_item then
				if not self.slave_boss then
					item.DropItem(self.x, self.y, c.drop)
				else
					for _, b in pairs(self.slave_boss) do
						if IsValid(b) then
							item.DropItem(b.x, b.y, c.drop)
						end
					end
				end
			end
			if self.sc_bonus and not c.fake then
				if self.sc_bonus > 0 then
					--收卡
					local get_score = self.sc_bonus
					system.addScore(get_score)
					PlaySound('cardget', 1.0, 0)
					if not self.no_pop_result then
						EISlib.Effect.SpellCardFinishEffect(get_score, self.timer/60)
					end
					if not ext.replay.IsReplay() then
						scoredata.spell_card_hist[lstg.var.player_name][self.difficulty][c.name][1] = scoredata.spell_card_hist[lstg.var.player_name][self.difficulty][c.name][1] + 1
					end
					self.spell_get = true
				else
					--没有收卡
					if not self.no_pop_result then
						EISlib.Effect.SpellCardFinishEffect(0, self.timer/60)
					end
				end
			else
				--不是符卡
			end
			-- 消弹逻辑
			if not self.slave_boss then
				New(bullet_killer, self.x, self.y, true, self.no_drop_item) -- (x, y, kill_indes, del_mode)
			else
				for _, b in pairs(self.slave_boss) do
					if IsValid(b) then
						New(bullet_killer, b.x, b.y, true, self.no_drop_item) -- (x, y, kill_indes, del_mode)
					end
				end
			end
		else
			--没有击破，嘲讽模式
			if c.is_sc and self.timeout == 1 then
				PlaySound('fault', 1.0, 0)
			end
			if self.sc_bonus then
				--如果是符卡就弹出结算
				if not self.no_pop_result then
					EISlib.Effect.SpellCardFinishEffect(0, self.timer/60)
				end
			end
			-- 消弹逻辑
			if not self.slave_boss then
				New(bullet_killer, self.x, self.y, true, true) -- (x, y, kill_indes, del_mode) 不掉落点
			else
				for _, b in pairs(self.slave_boss) do
					if IsValid(b) then
						New(bullet_killer, b.x, b.y, true, true) -- (x, y, kill_indes, del_mode) 不掉落点
					end
				end
			end
		end
		self.spell_timeout = (self.timeout == 1)
		if self.no_drop_item then
			self.no_drop_item = false
		end
		if self.no_clear_bullet then
			self.no_clear_bullet = false
		else
			PlaySound('enep02', 0.4, 0)
		end
	end
	if c.is_sc then
		self.ui.sc_left = self.ui.sc_left - 1
	end
end

---@param self boss.object
---@param eff boolean
function boss.explode(self, eff)
	if self.class.spExplode then
		self.class.spExplode(self)
	else
		--boss死亡特效
		if eff then
			self.killed = true
			self.no_killeff = true
			task.Clear(self)
			if self.ex then
				task.Clear(self.ex)
			end
			--[[
			PlaySound("enep01", 0.5, self.x / 256)
			self.colli = false
			self.hp = 0
			self.lr = 28
			task.New(self, function()
				local angle = ran:Float(10, 20)
				self.vx = 0.3 * cos(angle)
				self.vy = 0.3 * sin(angle)
				New(bullet_cleaner, self.x, self.y, 1500, 120, 60, true, true, 0)
				for i = 1, 120 do
					self.hp = 0
					self.timer = self.timer - 1
					local lifetime = ran:Int(60, 90)
					local l = ran:Float(200, 500)
					New(boss_death_ef_unit, self.x, self.y, l / lifetime, ran:Float(0, 360), lifetime, ran:Float(2, 3))
					task.Wait(1)
				end
				PlaySound("enep01", 0.5, self.x / 256)
				New(deatheff, self.x, self.y, 'first')
				New(deatheff, self.x, self.y, 'second')
				Kill(self)
			end)
			--]]
			self.colli = false
			self.hp = 0
			task.New(self, function()
				New(boss_death_ef, self.x, self.y)
				local angle = ran:Float(10, 20)
				self.vx = 0.2 * cos(angle)
				self.vy = 0.2 * sin(angle)
				New(bullet_cleaner, self.x, self.y, 1500, 120, 60, true, true, 0)
				for _ = 1, 60 do
					self.hp = 0
					self.timer = self.timer - 1
					task.Wait(1)
				end
				New(boss_death_ef, self.x, self.y)
				New(boss_death_circle, self.x, self.y)
				Kill(self)
			end)
		else
			Kill(self)
		end
	end
end

---@param self boss.object
---@param show boolean
function boss.show_aura(self, show)
	if show then
		self.aura_alpha_d = 4
	else
		self.aura_alpha_d = -4
	end
end

---@param self boss.object
---@param cast_t number
function boss.cast(self, cast_t)
	self.cast_t = cast_t + 0.5
	self.cast = 1
end

---@param self boss.object
---@param dmg number
function boss.take_damage(self, dmg)
	if self.dmgmaxt then
		self.dmgt = self.dmgmaxt
	end
	if not self.protect then
		local dmg0 = dmg * self.dmg_factor
		self.spell_damage = self.spell_damage + dmg0
		self.hp = self.hp - dmg0
		lstg.var.score = lstg.var.score + 10
	end
end

---@param self boss.object
function boss.GetCurrentCard(self)
	--已整合进boss system，可能不再使用
	local c = self.current_card
	if not (c) and self.cards then
		c = self.cards[self.card_num]
	end
	if boss.ex and boss.ex.status == 1 then
		c = boss.ex.cards[boss.ex.nextcard]
	end
	return c
end

---从符卡表中拿到一个符卡
---@param name string|number @类名或者索引
---@return table
function boss.GetCardObject(name)
	if not _editor_cards[name] then
		lstg.Log(4, "Cant't find card \"" .. name .. "\".")
	end
	return _editor_cards[name]
end

----------------------------------------
---boss ex
---一些boss ex逻辑代码从编辑器中生成

---@return boss.object[]
local function _init_coops_table()
	if type(lstg.tmpvar._ex_boss_coops) ~= "table" then
		lstg.tmpvar._ex_boss_coops = {}
	end
	return lstg.tmpvar._ex_boss_coops
end

function boss:killex()
	if self.ex.status == 1 then
		local c = self.ex.cards[self.ex.nextcard]
		self.ex.lifes[self.ex.nextcard] = 0
		self.ex.nextcard = self.ex.nextcard - 1
		c.del(self)
		boss.PopSpellResult(self, c)
		PreserveObject(self)
		self.hp = 9999
		task.Clear(self)
		self.ex.status = 0
	else
		boss.del(self)
	end
end

function boss:prepareSpellCards(cardlist)
	if self.ex == nil then
		return
	end
	local a = self.ex
	while self.ex.status == 1 do
		task.Wait(1)
	end
	self.ex.lifes = {}
	self.ex.lifesmax = {}
	self.ex.modes = {}
	self.ex.cards = {}
	self.ex.timer = 0
	for i, v in pairs(cardlist) do
		local c = boss.GetCardObject(v)
		a.cards[i] = c
		a.lifes[i] = c.hp
		a.lifesmax[i] = c.hp
		if c.is_sc or c.fake then
			a.modes[i] = 1
		else
			a.modes[i] = 0
		end
	end
	a.nextcard = #cardlist
	a.cardcount = #cardlist
end

function boss:finishSpell(b)
	if self.ex == nil then
		return
	end
	if self.ex.status == 1 then
		if b then
			self.life = 0
		end
		self.life = 0
		Kill(self)
		task.Wait(1)
	end
end

function boss:finishSpellC(b)
	if self.ex == nil then
		return
	end
	if self.ex.status == 1 then
		self.ex.finish = 1
	end
end

function boss:castSpell(spellname, waitforend)
	if self.ex == nil then
		return
	end
	while self.ex.status == 1 do
		task.Wait(1)
	end

	local a = self.ex
	local c = 0
	if spellname == nil then
		c = a.cards[a.nextcard]
	else
		c = boss.GetCardObject(spellname)
	end
	if #a.cards == 0 or a.nextcard == 0 then
		--you have no card left in your hand, get one
		boss.prepareSpellCards(self, { spellname })
	end

	if a.cards[a.nextcard] ~= c then
		--you are using another card to replace your next prepared card
		local i = a.nextcard
		a.cards[i] = c
		a.lifes[i] = c.hp
		a.lifesmax[i] = c.hp
		if c.is_sc then
			a.modes[i] = 1
		else
			a.modes[i] = 0
		end
	end

	a.status = 1
	boss._castcard(self, c)
	if waitforend then
		while a.status == 1 do
			task.Wait(1)
		end
	end
end

--[[
function boss:_castcard(c)
	if c.is_sc then
		if not c.fake then
			self.sc_bonus = self.sc_bonus_max
		end

		--self.ui.hpbarcolor=Color(0xFFFF8080)
		New(spell_card_ef)
		PlaySound('cat00', 0.5)
		if scoredata.spell_card_hist == nil then
			scoredata.spell_card_hist = {}
		end
		if scoredata.spell_card_hist[lstg.var.player_name] == nil then
			scoredata.spell_card_hist[lstg.var.player_name] = {}
		end
		if scoredata.spell_card_hist[lstg.var.player_name][self.difficulty] == nil then
			scoredata.spell_card_hist[lstg.var.player_name][self.difficulty] = {}
		end
		if scoredata.spell_card_hist[lstg.var.player_name][self.difficulty][c.name] == nil then
			scoredata.spell_card_hist[lstg.var.player_name][self.difficulty][c.name] = { 0, 0 }
		end
		if not ext.replay.IsReplay() then
			scoredata.spell_card_hist[lstg.var.player_name][self.difficulty][c.name][2] = scoredata.spell_card_hist[lstg.var.player_name][self.difficulty][c.name][2] + 1
		end
		self.ui.sc_hist = scoredata.spell_card_hist[lstg.var.player_name][self.difficulty][c.name]
	else
		if not c.fake then
			self.sc_bonus = nil
		end
	end
	if c.is_combat
	then
		item.StartChipBonus(self)
		self.spell_damage = 0
	end
	if c.name ~= '' then
		self.ui.sc_name = c.name
	end
	self.ui.countdown = c.t3 / 60
	self.ui.is_combat = c.is_combat
	task.Clear(self.ui)
	task.Clear(self)
	c.init(self)
	self.timer = -1
	self.hp = c.hp
	self.maxhp = c.hp
	self.dmg_factor = 0

	PreserveObject(self)
end
--]]
function boss:_castcard(c)
	if c.is_sc then
		if not c.fake then
			if self.sc_bonus_max > 0 then
				self.sc_bonus = self.sc_bonus_max
			else
				self.sc_bonus = item.sc_bonus_max
			end
		end

		--    self.ui.hpbarcolor=Color(0xFFFF8080)
		--New(spell_card_ef)
		PlaySound('cat00',0.5)
		if scoredata.spell_card_hist==nil then scoredata.spell_card_hist={} end
		if scoredata.spell_card_hist[lstg.var.player_name]==nil then scoredata.spell_card_hist[lstg.var.player_name]={} end
		if scoredata.spell_card_hist[lstg.var.player_name][self.difficulty]==nil then scoredata.spell_card_hist[lstg.var.player_name][self.difficulty]={} end
		if scoredata.spell_card_hist[lstg.var.player_name][self.difficulty][c.name]==nil then scoredata.spell_card_hist[lstg.var.player_name][self.difficulty][c.name]={0,0} end
		if not ext.replay.IsReplay() then
			scoredata.spell_card_hist[lstg.var.player_name][self.difficulty][c.name][2]=scoredata.spell_card_hist[lstg.var.player_name][self.difficulty][c.name][2]+1
		end
		self.ui.sc_hist=scoredata.spell_card_hist[lstg.var.player_name][self.difficulty][c.name]
	else
		if not c.fake then
			self.sc_bonus=nil
		end
	end
	if c.is_combat
	then
		item.StartChipBonus(self)
		self.spell_damage=0
	end
	if c.name~='' then self.ui.sc_name=c.name end
	self.ui.countdown=c.t3/60
	self.ui.is_combat=c.is_combat
	task.Clear(self.ui)
	task.Clear(self)
	c.init(self)
	self.timer=-1
	self.hp=c.hp
	self.maxhp=c.hp
	self.dmg_factor=0

	PreserveObject(self)
end

---ex boss联合符卡事件循环
---！警告：该方法依赖task环境
---@param self boss.object
---@param coopname string|number
---@param mode number
---@param waittime number @所有事件结束后等待事件
function boss.coopSpellCard(self, coopname, mode, waittime)
	--init
	local coops = _init_coops_table()
	coops[coopname] = coops[coopname] or {
		cardcount = 0, -- 总卡数
		firstfinish = 0, -- 第一个完成的时间
		finishcount = 0,
		status = {}, -- 不同符卡的状态
	}

	--join
	local coop = coops[coopname]
	coop.cardcount = coop.cardcount + 1 -- 增加总的符卡计数
	local index = coop.cardcount -- 当前索引
	coop.status[index] = self.ex.status -- 同步状态
	task.Wait(1)

	--coop loop
	while true do
		local finishcount = 0
		coop.status[index] = self.ex.status
		if self.ex.status == 0 then
			finishcount = finishcount + 1
			break
		end

		for i = 1, coop.cardcount do
			finishcount = finishcount + coop.status[i]
		end
		finishcount = coop.cardcount - finishcount

		if mode == 0 then
			if finishcount ~= 0 then
				finishcount = finishcount + 1
				boss.finishSpellC(self, true)
				break
			end
		elseif mode == 1 then
			if finishcount == coop.cardcount - 1 then
				finishcount = finishcount + 1
				boss.finishSpellC(self, true)
				break
			end
		end

		task.Wait(1)
	end

	-- cal time
	if coop.firstfinish == 0 then
		coop.firstfinish = stage.current_stage.timer
	end
	waittime = waittime + (coop.firstfinish - stage.current_stage.timer)

	-- clear status
	coop.finishcount = coop.finishcount + 1
	if coop.finishcount == coop.cardcount then
		coop.cardcount = 0
		coop.firstfinish = 0
		coop.finishcount = 0
		coop.status = {}
	end

	-- wait
	if waittime > 0 then
		task.Wait(waittime)
	end
end
