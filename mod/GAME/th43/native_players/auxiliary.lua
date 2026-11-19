local SC=system.spellcard
local SCA = {}
SC.auxiliary = SCA

---@return system.spellcard.auxiliary.data
function SCA._init()
	if lstg.tmpvar._system_spellcard_auxiliary_data then
		return lstg.tmpvar._system_spellcard_auxiliary_data
	else
		---@class system.spellcard.auxiliary.data
		local data_ = {
			death = 0,
			bomb = 0,
			hyper_break = 0,
			spellcard_x2 = 0, -- 双倍符卡奖励（Hyper下收的卡数量）
			bonus_drop_rate = 1.0, -- 符卡分降低率
			--- 符卡基础分，负数代表使用默认的
			bonus_base = -1,
			--- 连锁基础分，负数代表使用默认的
			chain_base = -1,
		}
		lstg.tmpvar._system_spellcard_auxiliary_data = data_
		return data_
	end
end
function SCA.reset()
	local t = SCA._init()
	t.death = 0
	t.bomb = 0
	t.hyper_break = 0
	t.spellcard_x2 = 0
	t.bonus_drop_rate = 1.0
	t.bonus_base = -1
	t.chain_base = -1
end
function SCA.resetCardScope()
	local t = SCA._init()
	t.death = 0
	t.bomb = 0
	t.hyper_break = 0
end

function SCA.addPlayerDeath()
	local t = SCA._init()
	t.death = t.death + 1
end
---@return number
function SCA.getPlayerDeath()
	local t = SCA._init()
	return t.death
end

function SCA.addPlayerSpell()
	local t = SCA._init()
	t.bomb = t.bomb + 1
end
---@return number
function SCA.getPlayerSpell()
	local t = SCA._init()
	return t.bomb
end

function SCA.addPlayerHyperBreak()
	local t = SCA._init()
	t.hyper_break = t.hyper_break + 1
end
---@return number
function SCA.getPlayerHyperBreak()
	local t = SCA._init()
	return t.hyper_break
end

function SCA.addSpellCardx2()
	local t = SCA._init()
	t.spellcard_x2 = t.spellcard_x2 + 1
end
---@return number
function SCA.getSpellCardx2()
	local t = SCA._init()
	return t.spellcard_x2
end

--- 符卡分数随时间流逝速率比率（默认是1倍速）
function SCA.setSpellBonusDropRate(rate)
	local t = SCA._init()
	t.bonus_drop_rate = rate or 1.0
end
---@return number
function SCA.getSpellBonusDropRate()
	local t = SCA._init()
	return t.bonus_drop_rate
end

---@param v number
---@overload fun()
function SCA.setCardBonusBase(v)
	local t = SCA._init()
	t.bonus_base = v or -1
end
---@return number
function SCA.getCardBonusBase()
	local t = SCA._init()
	return t.bonus_base
end

---@param v number
---@overload fun()
function SCA.setChainBonusBase(v)
	local t = SCA._init()
	t.chain_base = v or -1
end
---@return number
function SCA.getChainBonusBase()
	local t = SCA._init()
	return t.chain_base
end

--endregion
----------------------------------------
