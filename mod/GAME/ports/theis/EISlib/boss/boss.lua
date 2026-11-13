---=====================================
---祈华梦版boss
---code by Xiliusha
---=====================================

---@class EISlib.Boss
local M = {}

---@type EISlib.Boss
EISlib.Boss = M

M.path = EISlib.path .. "boss/"

local path = M.path

----------------------------------------
---res

local function load_res()
	local S = lstg.ResourceSet.Create("EISlib.boss", "global")
	S:AddTexture("_boss_aura_texture", "res/effect/boss_aura.png", false)
	S:AddSprite("boss_aura_flat", "_boss_aura_texture", 0, 0, 512, 512)
end
load_res()

----------------------------------------
---define

lstg.wis = lstg.wis or {}

lstg.DoFile(path .. "boss_index.lua")
lstg.DoFile(path .. "boss_ui.lua")

---@param self boss.object
---@param x number
---@param y number
---@param name string
---@param cards table[]
---@param bg object
---@param diff string
---@param no_deatheff boolean
function boss.init(self, x, y, name, cards, bg, diff, no_deatheff)
	enemybase.init(self, 999999999)
	self._private_type_boss = true
	self.x = x
	self.y = y
	self.img = "img_void"
	--boss魔法阵
	self.aura_alpha = 0 --法阵透明度
	self.aura_alpha_d = 0 --法阵透明度单帧变化值
	self.aura_scale = 1 --法阵大小比例
	--boss骚气(与魔法阵共用一个透明度
	self.saoqiR, self.saoqiG, self.saoqiB, self.saoqiBlend = 255, 0, 0, "mul+add" --骚气默认颜色
	--boss系统
	self._bosssys = BossSystem(self, name, cards, bg, diff, no_deatheff)
	--boss行走图系统
	self._wisys = BossWalkImageSystem(self)
	self._wisys:SetFloat(function(ani)
		return 0, 4 * sin(ani * 4)
	end)
	boss.AddBoss(self) --加入ex的boss表中
	background.AddWarpEffect(self)
	--判定x2
	self.a, self.b = 32, 32
	if not self.ex then
		Kill(self) --开始执行通常符卡系统
	end
end

---@param self boss.object
function boss.render(self)
	SetImageState("boss_aura_flat", "mul+add", Color(self.aura_alpha, 255, 255, 255))
	Render("boss_aura_flat", self.x, self.y, self.ani * 0.8, 1.0, 1.0)
	self._bosssys:render()
	self._wisys:render(self.dmgt, self.dmgmaxt) --by OLC，行走图系统
end

---@param self boss.object
---@param other object
function boss.colli(self, other)
	enemybase.colli(self, other)
	system.setCurDamageEnemy(self)
end

---@param self boss.object
---@param dmg number
function boss.take_damage(self, dmg)
	if self.dmgmaxt then
		self.dmgt = self.dmgmaxt
	end
	if not self.protect then
		local _dmg = dmg * self.dmg_factor * self.dmgrate
		self.spell_damage = self.spell_damage + _dmg
		self.hp = self.hp - _dmg
		system.damageEnemyBonus(_dmg)
	end
end

--- boss的LSC检测器，执行LSC必要的特殊事件，目前仅针对魔理沙的罩子
lscSpecialEvent = Class(object)
function lscSpecialEvent:init(mst)
	self.hide = true
	self.colli = false
	self.bound = false
	if ext.sc_pr then
		self.status = "del" -- 符卡练习就不需要了
	else
		self.open = true -- 标记自己处于正常运行状态
		self.done = false -- 是否已经执行过一次
		lstg.tmpvar._last_spell_host_instance = self -- 提供给UI
		self.mst = mst
		self.player_death = player.death
		self.player_shield = player.shield -- 专门针对魔理沙罩子情况
		--self.bomb_num = lstg.var.bomb
		self.disp_times = 0 -- 延迟消失计数器
		removeYuyukoShield()
		player.lockspell = 2 --不允许放雷
	end
end
function lscSpecialEvent:frame()
	if self.open then
		-- 只有自己处于正常运行状态才执行以下逻辑
		task.Do(self)
		-- 延迟处理功能，在boss死亡后的一段时间里面都继续执行一些逻辑
		if IsValid(self.mst) then
			self.disp_times = 0
			player.lockspell = 2 --不允许放雷
		else
			self.disp_times = self.disp_times + 1
		end
		if self.disp_times > 2 then
			self.status = "del"
		else
			-- 清空符卡分已经写进自机的colli里面
			-- 但是掉落物清空得写在这
			if player.death > self.player_death then
				boss.ClearBonus(false, false, true)
			end
			if not self.done then
				if (player.death >= 90) then
					player.death = 0 -- 死者回生
					player.protect = max(player.protect, 180)
					if IsValid(self.mst) then
						boss.ClearBonus(false, false, true)
						self.mst.hp = 0
						self.done = true
					end
				--[[elseif (self.player_shield ~= player.shield) then
					if IsValid(self.mst) then
						boss.ClearBonus(false, false, true)
						self.mst.hp = 0
						self.done = true
					end]]
				end
			end
		end
	end
end

function lscNoBombCheck(mst)
	New(lscSpecialEvent, mst)
	--只要有b或自机无敌，就不给开卡
	while player.death > 0 or player.nextspell > 0 do
		task.Wait(1)
	end
end

----------------------------------------
--- simple boss

---@class stg.simpleboss.object : enemybase.object
local simple_boss = Class(enemybase)
function simple_boss:init(x, y, hp, initcb)
	enemybase.init(self, hp, true)
	self.dmg_factor = 1
	self.x = x
	self.y = y
	self.img = "img_void"
	--boss魔法阵
	self.aura_alpha = 0 --法阵透明度
	self.aura_alpha_d = 0 --法阵透明度单帧变化值
	self.aura_scale = 1 --法阵大小比例
	self._aura_alpha = 0
	self._aura_alpha_d = 0
	--boss行走图系统
	--self.dmgmaxt = 10
	--self.dmgt = 0
	self._wisys = BossWalkImageSystem(self)
	self._wisys:SetFloat(function(ani)
		return 0, 4 * lstg.sin(ani * 4)
	end)
	background.AddWarpEffect(self)
	callback.initialize(self, "before_update", "after_update", "before_draw", "after_draw", "on_kill", "on_delete", "on_trigger")
	initcb(self)
end
function simple_boss:frame()
	-- 出屏判定关闭
	-- 血量下限
	self.hp = math.max(0, self.hp)
	callback.execute(self, "before_update")
	-- task 更新
	task.Do(self)
	-- 行走图系统帧逻辑
	self._wisys:frame()
	-- 受击闪烁
	if self.dmgt then
		self.dmgt = math.max(0, self.dmgt - 1)
	end
	-- 魔法阵透明度更新
	self.aura_alpha = self.aura_alpha + self.aura_alpha_d
	self.aura_alpha = math.clamp(self.aura_alpha, 0, 128)
	self._aura_alpha = self._aura_alpha + self._aura_alpha_d
	self._aura_alpha = math.clamp(self._aura_alpha, 0, 1)
	callback.execute(self, "after_update")
end
function simple_boss:render()
	callback.execute(self, "before_draw")
	lstg.SetImageState("boss_aura_flat", "mul+add", lstg.Color(self._aura_alpha * 128, 255, 255, 255))
	lstg.Render("boss_aura_flat", self.x, self.y, self.ani * 0.8, self.aura_scale)
	self._wisys:render(self.dmgt, self.dmgmaxt)
	callback.execute(self, "after_draw")
end
function simple_boss:kill()
	enemybase.kill(self)
	callback.execute(self, "on_kill")
end
function simple_boss:del()
	enemybase.del(self)
	callback.execute(self, "on_delete")
end
function simple_boss:colli(other)
	enemybase.colli(self, other)
	callback.execute(self, "on_trigger", other)
end
function simple_boss:take_damage(dmg)
	if self.dmgmaxt then
		self.dmgt = self.dmgmaxt
	end
	if not self.protect then
		local _dmg = dmg * self.dmgrate * self.dmg_factor
		system.damageEnemyBonus(_dmg)
		self.hp = self.hp - _dmg
	end
end

stg = stg or {}

---@param x number
---@param y number
---@param hp number
---@param callback fun(self:stg.simpleboss.object)
---@return stg.simpleboss.object
function stg.newSimpleBoss(x, y, hp, callback)
	return lstg.New(simple_boss,
			x, y, hp, callback or function() end)
end

---@param bossobject stg.simpleboss.object
---@param show boolean
---@param immediate boolean
---@param alpha number @from 0 to 1
function stg.setBossMagicCircle(bossobject, show, immediate, alpha)
	if show then
		bossobject._aura_alpha_d = 1 / 60
	else
		bossobject._aura_alpha_d = -1 / 60
	end
	if immediate then
		if alpha then
			bossobject._aura_alpha = alpha
		else
			if show then
				bossobject._aura_alpha = 1
			else
				bossobject._aura_alpha = 0
			end
		end
	end
end

---@param bossobject stg.simpleboss.object
---@param show boolean
---@param immediate boolean
---@param alpha number @from 0 to 1
function stg.setBossWarp(bossobject, show, immediate, alpha)
	if show then
		bossobject.aura_alpha_d = 128 / 60
	else
		bossobject.aura_alpha_d = -128 / 60
	end
	if immediate then
		if alpha then
			bossobject.aura_alpha = alpha * 128
		else
			if show then
				bossobject.aura_alpha = 128
			else
				bossobject.aura_alpha = 0
			end
		end
	end
end
