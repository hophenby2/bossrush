---=====================================
---东方祈华梦符卡名、boss名
---=====================================

---@type EISlib.Boss
local lib = EISlib.Boss

---@class EISlib.Boss.Index
local M = {}

---@type EISlib.Boss.Index
lib.Index = M

local path = lib.path

M.tex1 = "_boss_ui_tex"
M.tex2 = "_boss_ui_name_tex"

----------------------------------------
---res

local function load_res_0()
	local S = lstg.ResourceSet.Find("EISlib.boss")
	S:AddTexture(M.tex1, path .. "boss_ui_dd.png", false)
	S:AddSprite("boss_ui_graybar", M.tex1, 0, 0, 682, 38)
	S:SetSpriteCenter("boss_ui_graybar", 339, 16)
	S:AddSprite("boss_ui_flower", M.tex1, 1367, 0, 507, 64)
	S:SetSpriteCenter("boss_ui_flower", 0, 0)
	S:AddSprite("boss_ui_pointer", M.tex1, 1871, 0, 82, 20)
	S:SetSpriteCenter("boss_ui_pointer", 41, 3)
	S:AddSprite("boss_ui_stagebar", M.tex1, 1364, 62, 264, 33)
	S:SetSpriteCenter("boss_ui_stagebar", 6, 12)
	S:AddSprite("boss_ui_scnamebar", M.tex1, 1628, 62, 293, 51)
	S:SetSpriteCenter("boss_ui_scnamebar", 284, 10)
	S:AddSpriteSequence("boss_ui_attatype", M.tex1,1364,128,32,32,3,1)
end
load_res_0()

----------------------------------------
---boss name

local boss_name_index = {
	"Unknown", --？？
	"Kaguya", --辉夜
	false,
	"Keine", --慧音
	"Mokou", --妹红
	"Emitsu", --绘光
	"Egg", --三吴克
	"Reimu",--灵梦
	"Yukari",--紫
	"Marisa",--魔理沙
	"Yuyuko",--幽幽子
	"Hisoka", -- 贝贝佳
	"Jinguuji", -- 巫女小姐
	"Oukain", -- 富士山神
	"Iwabuchi", -- 八岳山神
	"Lily White", -- 主催老婆
}

local boss_name_check = {}

local function load_res_1()
	for i, v in ipairs(boss_name_index) do
		boss_name_check[v] = "_ui_16_9_bossname" .. i
	end
end
load_res_1()

function M.GetImageByName(bossname)
	if boss_name_check[bossname] then
		return boss_name_check[bossname]
	else
		return boss_name_check["Unknown"]
	end
end

----------------------------------------
--- spellcard practice index

local _card_index = {}

local _boss_index = {
	"Egg",
	"Kaguya",
	"Emitsu",
	"Reimu",
	"Yukari",
	"Marisa",
	"Yuyuko",
	"Mokou",
	"Keine",
	"Hisoka",
	"Lily White", -- Lily
	"Jinguuji", -- Inori
	"Oukain", -- Shizuka
	"Iwabuchi",
	"Xiliusha", -- test
	"Unknown",
}

local _diff_index = {
	"Easy",
	"Normal",
	"Hard",
	"Lunatic",
	"Extra",
	--"Ultra",
	"All",
}

function boss.refreshActionIndex()
	_card_index = {} -- 全部清空
	if type(_sc_table) == "table" and type(_editor_class) == "table" then
		for i, v in ipairs(_sc_table) do
			local boss_class
			-- 查找boss的class
			if type(v[1]) == "string" and type(_editor_class[v[1]]) == "table" and _editor_class[v[1]].is_class then
				boss_class = _editor_class[v[1]]
			elseif type(v[1]) == "table" and v[1].is_class then
				boss_class = v[1]
			end
			-- 插入信息
			if boss_class then
				local list
				-- 查找组
				if type(boss_class.difficulty) == "string" then
					_card_index[boss_class.difficulty] = _card_index[boss_class.difficulty] or {}
					list = _card_index[boss_class.difficulty]
				else
					_card_index["All"] = _card_index["All"] or {}
					list = _card_index["All"]
				end
				local boss
				-- 查找boss
				if type(boss_class.name) == "string" then
					list[boss_class.name] = list[boss_class.name] or {}
					boss = list[boss_class.name]
				else
					list["Unknown"] = list["Unknown"] or {}
					boss = list["Unknown"]
				end
				-- 查找符卡
				if type(v[4]) == "number" and type(boss_class.cards) == "table" and type(boss_class.cards[v[4]]) == "table" then
					local card = boss_class.cards[v[4]]
					table.insert(boss, {i, card.name})
				end
			end
		end
	end
	--lstg.Log(1, utility.serialize(_card_index, true))
end

---@return string[]
function boss.listGroup()
	local ret = {}
	for _, v in ipairs(_diff_index) do
		if _card_index[v] then
			table.insert(ret, v)
		end
	end
	return ret
end

---@param group string
---@return string[]
function boss.listBossByGroup(group)
	local ret = {}
	if _card_index[group] then
		for _, v in ipairs(_boss_index) do
			if _card_index[group][v] then
				table.insert(ret, v)
			end
		end
	end
	return ret
end

---@param group string
---@param boss string
---return {index, name}
function boss.listActionByBoss(group, boss)
	if _card_index[group] and _card_index[group][boss] then
		return _card_index[group][boss]
	end
	return {}
end
