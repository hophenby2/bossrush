---@class EISlib.game
local stage = {}
EISlib.stage = stage
stage.path = EISlib.path .. "stage/"

---@param i number
function stage.loadStage(i)
	i = int(i)
	if i >= 0 and i <= 7 then
		lstg.DoFile(stage.path .. "stage" .. i .. "/s" .. i .. "_enemy.lua")
	end
end

---@param bgmname string
---@param time number
---@param unlock_record boolean
---@param ignore_continue boolean
function stage.playMusic(bgmname, time, unlock_record, ignore_continue)
	-- 录像和练习模式不解锁，续关了无法解锁
	local con_num = 0
	if lstg.var.coun_num then
		con_num = lstg.var.coun_num
	end
	if unlock_record and (not ext.replay.IsReplay()) and (not lstg.var.is_practice) and (ignore_continue or con_num <= 0) then
		scoredata.music_unlock_record = scoredata.music_unlock_record or {
			["menu"] = true,
			["deathmusic"] = true,
		}
		scoredata.music_unlock_record[bgmname] = true
	end
	LoadMusicRecord(bgmname)
	lstg.PlayMusic(bgmname, 1, time)
	EISlib.Effect.PopMusicName(bgmname)
end

---@param name string
---@param time number @frame
function stage.musicFadeOut(name, time)
	if lstg.CheckRes("bgm", name) then
		time = math.max(1, time or 60)
		lstg.New(tasker, function()
			for t = (time - 1), 0, -1 do
				if lstg.CheckRes("bgm", name) then
					if lstg.GetMusicState(name) == "playing" then
						lstg.SetBGMVolume(name, t / time)
					end
				end
				task.Wait(1)
			end
			if lstg.CheckRes("bgm", name) then
				if lstg.GetMusicState(name) == "playing" then
					lstg.StopMusic(name)
				end
			end
		end)
	end
end

---@return boolean
function stage.canDialog()
	if lstg.var.is_practice then
		if lstg.var.disable_dialog then
			return false
		end
	end
	return true
end

---createBossClass
---@param group_name string
---@param class_name string
---@param boss_name string
---@param card_background
---@param scpr_t table @{scpr_bgm_name, scpr_bg_class}
---@param create_x number
---@param create_y number
---@param init_cb fun(self)
function stage.createBossClass(group_name, class_name, boss_name, card_background, scpr_t, create_x, create_y, init_cb)
	local b = Class(boss)
	b.cards = {}
	b._name = class_name
	b.name = boss_name
	b.bgm = scpr_t[1]
	b._bg = scpr_t[2]
	b.difficulty = group_name
	function b:init(cards)
		boss.init(self, create_x, create_y, boss_name, cards, New(card_background), group_name)
		init_cb(self)
	end
	_editor_class[class_name] = b
	return b
end

---@param boss_class
---@param player_dialog boolean
---@param dialog_task_f fun(self)
function stage.createDialogClass(boss_class, player_dialog, dialog_task_f)
	local dlg = boss.dialog.New(true)
	function dlg:init()
		player.dialog = player_dialog -- 控制是否处于对话状态（自机不能射击不能丢雷）
		self.dialog_displayer = New(dialog_displayer)
		self._dialog_maintask = task.New(self, function()
			dialog_task_f(self)
		end)
	end
	table.insert(boss_class.cards, dlg)
	return dlg
end

---@param boss_class
---@param card_name string
---@param time_t number[] @{protect_time, full_damage_time, all_time}
---@param hp number
---@param drop_t number[]
---@param mode string
---@param pre_action boolean
---@param no_record boolean
function stage.createCardClass(boss_class, card_name, time_t, hp, drop_t, mode, pre_action, no_record)
	local sc = boss.card.New(card_name, time_t[1], time_t[2], time_t[3], hp, drop_t, mode == "extra", mode)
	sc.perform = pre_action
	table.insert(boss_class.cards, sc)
	if not no_record then
		table.insert(_sc_table, { boss_class._name, card_name, sc, #boss_class.cards, pre_action })
	end
	return sc
end
