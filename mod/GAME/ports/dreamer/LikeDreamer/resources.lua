LikeDreamer = LikeDreamer or {}

if LikeDreamer.Resources and LikeDreamer.Resources._registered then
	return LikeDreamer.Resources
end

local M = {}
LikeDreamer.Resources = M

local ROOT = "res/likedreamer/"
local OPTIMIZED = ROOT .. "optimized/"

local ResourceManager = {}
ResourceManager.__index = ResourceManager
M.ManagerClass = ResourceManager

function ResourceManager.new()
	return setmetatable({
		registered = false,
		activeBackground = nil,
		activeStageGameplay = nil,
		lateGameplayLoaded = false,
		activeStageBgm = nil,
		activeBossBgm = nil,
	}, ResourceManager)
end

local manager = ResourceManager.new()
M.manager = manager

local function addSheet(set, texture, prefix, path, width, height, columns, rows)
	set:AddTexture(texture, ROOT .. path, false)
	set:AddSpriteSequence(prefix, texture, 0, 0, width, height, columns, rows)
end

local function addOptimizedSheet(set, texture, prefix, path, width, height, columns, rows)
	set:AddTexture(texture, OPTIMIZED .. path, false)
	set:AddSpriteSequence(prefix, texture, 0, 0, width, height, columns, rows)
end

local function addOptimizedSingle(set, name, path)
	set:AddSpriteFromFile(name, OPTIMIZED .. path, false)
end

local function registerPlayerResources()
	local set = lstg.ResourceSet.Create("LikeDreamer.Player", "likedreamer")
	addSheet(set, "ld_tex_player", "ld_player_", "player/Player.png", 80, 80, 15, 8)
	addSheet(set, "ld_tex_item", "ld_item_", "player/Item.png", 100, 100, 15, 1)
	addSheet(set, "ld_tex_player_frame", "ld_player_frame_", "player/PlayerFrame.png",
		340, 720, 10, 3)
	addSheet(set, "ld_tex_dream_gauge", "ld_dream_gauge_", "player/DreamGauge.png",
		160, 160, 2, 1)
	addSheet(set, "ld_tex_state", "ld_state_", "player/State.png", 200, 40, 1, 32)
	addSheet(set, "ld_tex_data_window_2", "ld_data_window_2_",
		"player/DataWindow2.png", 60, 60, 10, 1)
	addSheet(set, "ld_tex_result", "ld_result_", "player/Result.png", 240, 60, 1, 20)
	addSheet(set, "ld_tex_effect_s", "ld_effect_s_", "effect/Effect_s.png", 100, 100, 10, 2)
	addSheet(set, "ld_tex_num_s", "ld_num_s_", "system/Num_s.png", 20, 30, 14, 1)
	addSheet(set, "ld_tex_config_number", "ld_config_number_",
		"system/ConfigNumber.png", 30, 40, 1, 11)
	set:AddSpriteFromFile("ld_data_window", ROOT .. "player/DataWindow.png", false)
	set:AddSpriteFromFile("ld_time_window", ROOT .. "player/TimeWindow.png", false)
	set:AddSpriteFromFile("ld_enemy_gauge_fill", ROOT .. "stage/EnemyGauge2.png", false)
	addSheet(set, "ld_player_fx_m_tex", "ld_player_fx_m_", "effect/Effect_m.png",
		200, 200, 10, 3)
	-- Stage 8 boss node 0xab uses the original Effect_m[18] identity.
	set:AddSprite("ld_effect_m_19", "ld_player_fx_m_tex", 1600, 200, 200, 200)
	addSheet(set, "ld_player_fx_l_tex", "ld_player_fx_l_", "effect/Effect_l.png",
		600, 600, 10, 3)
	addOptimizedSingle(set, "ld_effect_m_5", "gameplay/effect_m_05.png")
	addOptimizedSingle(set, "ld_effect_l_1", "gameplay/effect_l_01.png")
	addOptimizedSingle(set, "ld_effect_l_16", "gameplay/effect_l_16.png")
end

local function registerGameplayResources()
	local set = lstg.ResourceSet.Create("LikeDreamer.Gameplay", "likedreamer")
	addSheet(set, "ld_tex_enemy_s", "ld_enemy_s_", "stage/Enemy_s.png", 100, 100, 10, 17)
	addOptimizedSheet(set, "ld_tex_enemy_m", "ld_enemy_m_",
			"gameplay/enemy_m_140.png", 200, 200, 10, 14)
	addSheet(set, "ld_tex_boss", "ld_boss_", "stage/Boss.png", 200, 200, 10, 16)
	addSheet(set, "ld_tex_bullet", "ld_bullet_", "stage/Bullet.png", 60, 60, 10, 4)
	addSheet(set, "ld_tex_boss_hud_gauge", "ld_boss_hud_gauge_",
		"stage/BossGauge.png", 500, 30, 1, 10)
	addSheet(set, "ld_tex_boss_hud_name", "ld_boss_hud_name_",
		"stage/BossName.png", 400, 30, 1, 22)
	addSheet(set, "ld_tex_text_box", "ld_text_box_",
		"system/TextBox.png", 600, 100, 1, 2)
	addSheet(set, "ld_tex_text_icon", "ld_text_icon_",
		"system/TextIcon.png", 80, 80, 10, 2)
	addSheet(set, "ld_tex_boss_approach_1", "ld_boss_approach_1_",
		"stage/BossApproach1.png", 400, 100, 1, 14)
	addSheet(set, "ld_tex_boss_approach_1_ch1", "ld_boss_approach_1_ch1_",
		"stage/BossApproach1_ch1.png", 400, 100, 1, 14)
	addSheet(set, "ld_tex_boss_approach_1_ch2", "ld_boss_approach_1_ch2_",
		"stage/BossApproach1_ch2.png", 400, 100, 1, 14)
	set:AddSpriteFromFile("ld_boss_approach_2", ROOT .. "stage/BossApproach2.png", false)
	set:AddSpriteFromFile("ld_white_back", ROOT .. "system/WhiteBack.png", false)
	addOptimizedSingle(set, "ld_enemy_gauge_1", "gameplay/enemy_gauge_01.png")
	addOptimizedSingle(set, "ld_boss_gauge_1", "gameplay/boss_gauge_01.png")
end

-- Enemy_l is a 6000x6600 atlas (about 151 MiB decoded).  The original groups
-- its frames by stage, so keep the source frame numbers but load only the
-- current stage's individually sliced images.
local enemy_l_ranges = {
	[1] = {0, 5},   [2] = {6, 12},  [3] = {13, 18}, [4] = {19, 21},
	[5] = {22, 35}, [6] = {36, 44}, [7] = {45, 53}, [8] = {54, 60},
	[9] = {61, 62}, [10] = {63, 109},
}

local enemy_l_extra_frames = {
	[2] = {5},
	[3] = {9, 10, 11, 12},
	[4] = {17, 18},
	[5] = {21},
	[6] = {35},
	[7] = {41, 42, 43, 44},
	[8] = {5, 9, 10, 11, 12, 17, 35, 45, 49, 50, 51, 52},
	-- Stage 9's six midbosses deliberately reuse the visual assemblies from
	-- Stages 1-6 before the Stage 9 root switches to frames 61 and 62.
	[9] = {0, 7, 8, 9, 10, 13, 15, 19, 20, 21, 29, 33, 34, 36, 37, 38, 39, 40},
}

local function addEnemyLargeFrame(set, frame)
	addOptimizedSingle(set, "ld_enemy_l_" .. tostring(frame + 1),
		string.format("gameplay/enemy_l/enemy_l_%03d.png", frame))
end

local function registerStageGameplayResources()
	for stage_number = 1, 10 do
		local set = lstg.ResourceSet.Create(
			"LikeDreamer.Gameplay.Stage." .. stage_number, "likedreamer.gameplay.stage")
		local range = enemy_l_ranges[stage_number]
		for frame = range[1], range[2] do
			addEnemyLargeFrame(set, frame)
		end
		for _, frame in ipairs(enemy_l_extra_frames[stage_number] or {}) do
			addEnemyLargeFrame(set, frame)
		end
		if stage_number == 10 then
			addSheet(set, "ld_tex_enemy_xl", "ld_enemy_xl_",
				"stage/Enemy_xl.png", 800, 800, 4, 2)
		end
		if stage_number == 4 then
			-- Stand.png decodes to about 153 MiB; this presentation only uses frame 33.
			addOptimizedSingle(set, "ld_stage04_stand_33",
				"gameplay/stage04_stand_33.png")
		end
	end

	local set = lstg.ResourceSet.Create("LikeDreamer.Gameplay.Late", "likedreamer.gameplay.late")
	local names = {}
	for frame = 140, 229 do
		names[#names + 1] = "ld_enemy_m_" .. tostring(frame + 1)
	end
	set:AddTexture("ld_tex_enemy_m_late",
		OPTIMIZED .. "gameplay/enemy_m_140_229.png", false)
	set:AddSpriteSequence(names, "ld_tex_enemy_m_late", 0, 0, 200, 200, 10, 9)
	addOptimizedSingle(set, "ld_effect_l_7", "gameplay/effect_l_07.png")
end

local background_prefix = {
	back1 = "ld_stageback1_",
	back1b = "ld_stageback1b_",
	back1c = "ld_stageback1c_",
	back1d = "ld_stageback1d_",
	back2 = "ld_stageback2_",
}

local background_frames = {
	[1] = {back1 = {2, 3, 4, 5}},
	[2] = {back1 = {6, 7}},
	[3] = {back1 = {8, 9}},
	[4] = {back1b = {0, 1}},
	[5] = {back1b = {2, 3, 4, 5}, back2 = {1, 2}},
	[6] = {back1b = {6, 7, 8, 9}},
	[7] = {back1 = {2, 3}, back1c = {0, 1, 2}, back2 = {3}},
	[8] = {
		back1 = {1, 2, 3, 4},
		back1c = {3, 4, 5, 6, 7, 8, 9, 10, 11},
		back2 = {4, 5, 6},
	},
	[9] = {back1c = {7, 8, 9}, back1d = {0, 1, 2}},
	[10] = {back1d = {3, 4, 5}},
}

local background_effect_frames = {
	[3] = {effect_l = {5, 13}},
	[4] = {effect_l = {14}, effect_m = {19}},
}

local background_effect_sheets = {
	effect_l = {path = "effect/Effect_l.png", width = 600, height = 600, columns = 10},
	effect_m = {path = "effect/Effect_m.png", width = 200, height = 200, columns = 10},
}

M.dedicatedParts = {
	ld_stage2back = {
		height = 8400,
		stem = "stage2",
		heights = {2048, 2048, 2048, 2048, 208},
	},
	ld_stage3back = {
		height = 7400,
		stem = "stage3",
		heights = {2048, 2048, 2048, 1256},
	},
	ld_stage6back = {
		height = 10550,
		stem = "stage6",
		heights = {2048, 2048, 2048, 2048, 2048, 310},
	},
	ld_stage8back1 = {
		height = 5700,
		stem = "stage8a",
		heights = {2048, 2048, 1604},
	},
	ld_stage8back2 = {
		height = 5700,
		stem = "stage8b",
		heights = {2048, 2048, 1604},
	},
}

local stage_dedicated = {
	[2] = {"ld_stage2back"},
	[3] = {"ld_stage3back"},
	[6] = {"ld_stage6back"},
	[8] = {"ld_stage8back1", "ld_stage8back2"},
}

local function registerBackgroundFrame(set, family, index)
	local sprite = background_prefix[family] .. tostring(index + 1)
	local path = string.format("background/%s_%02d.png", family, index)
	addOptimizedSingle(set, sprite, path)
end

local function registerBackgroundEffectFrames(set, stage_number, family, indices)
	local sheet = assert(background_effect_sheets[family])
	local texture = string.format("ld_bg_stage_%d_%s_tex", stage_number, family)
	set:AddTexture(texture, ROOT .. sheet.path, false)
	for _, index in ipairs(indices) do
		set:AddSprite("ld_" .. family .. "_" .. tostring(index + 1), texture,
			sheet.width * (index % sheet.columns),
			sheet.height * math.floor(index / sheet.columns),
			sheet.width, sheet.height)
	end
end

local function registerDedicated(set, name)
	local definition = M.dedicatedParts[name]
	definition.parts = {}
	local offset = 0
	for index, height in ipairs(definition.heights) do
		local sprite = string.format("%s_part_%d", name, index)
		local path = string.format("background/%s_%02d.png", definition.stem, index - 1)
		addOptimizedSingle(set, sprite, path)
		definition.parts[index] = {
			img = sprite,
			offset = offset,
			height = height,
		}
		offset = offset + height
	end
	assert(offset == definition.height, "Like Dreamer background split height mismatch: " .. name)
end

local function registerBackgroundResources()
	for stage_number = 1, 10 do
		local set = lstg.ResourceSet.Create(
			"LikeDreamer.Background." .. stage_number, "likedreamer.background")
		for family, indices in pairs(background_frames[stage_number]) do
			for _, index in ipairs(indices) do
				registerBackgroundFrame(set, family, index)
			end
		end
		for family, indices in pairs(background_effect_frames[stage_number] or {}) do
			registerBackgroundEffectFrames(set, stage_number, family, indices)
		end
		for _, name in ipairs(stage_dedicated[stage_number] or {}) do
			registerDedicated(set, name)
		end
	end
end

local sound_names = {
	"Alert",
	"Blast1", "Blast2", "Bomb1", "Bomb2", "Bomb3", "Bomb4", "Bomb5", "Bomb6", "Bomb7", "Bomb8",
	"BossApproach",
	"BossSE4", "DreamPower", "EnemyDown1", "EnemyDown2", "EnemyDown3", "Extend",
	"Fever1", "Fever2", "Fever3", "Fever4", "Graze", "Item1", "Item2", "Item3",
	"Miss", "Shot1", "Shothit", "Text", "Text2",
}

local original_sound_paths = {
	Alert = "se/Alert.wav",
	BossApproach = "se/BossApproach.wav",
	Text = "se/Text.wav",
	Text2 = "se/Text2.wav",
}

local function registerSounds()
	local set = lstg.ResourceSet.Create("LikeDreamer.SE", "likedreamer")
	for _, source_name in ipairs(sound_names) do
		local name = "ld_se_" .. source_name
		local path = original_sound_paths[source_name] and
			(ROOT .. original_sound_paths[source_name]) or
			(OPTIMIZED .. "se/" .. source_name .. ".wav")
		set:AddSound(name, path)
		-- THEIS's global PlaySound wrapper only plays sounds present in its
		-- private record. ResourceSet still owns the actual stage-pool resource.
		if type(LoadSound) == "function" then
			LoadSound(name, path, 1.0, true)
		end
	end
end

local music_duration = {
	Stage1 = 96.169025,
	Stage2 = 203.378707,
	Stage3 = 208.993719,
	Stage4 = 198.270385,
	Stage5 = 201.600000,
	Stage6 = 245.800249,
	Stage7 = 255.172426,
	Stage8 = 358.466372,
	Stage9 = 302.142857,
	Stage10 = 306.000000,
	Boss1 = 70.588254,
	Boss2 = 115.955170,
	Boss3 = 230.440249,
	Boss4 = 153.600000,
	Boss5 = 137.600000,
}

local function registerMusicTrack(kind, index)
	local source_name = kind .. index
	local set_name = string.format("LikeDreamer.BGM.%s.%d", kind, index)
	local set = lstg.ResourceSet.Create(set_name, "likedreamer.bgm")
	local duration = assert(music_duration[source_name])
	set:AddMusic("ld_bgm_" .. source_name,
		ROOT .. "bgm/" .. source_name .. ".ogg", duration, duration)
end

local function registerMusic()
	for index = 1, 10 do registerMusicTrack("Stage", index) end
	for index = 1, 5 do registerMusicTrack("Boss", index) end
end

function ResourceManager:register()
	if self.registered then return end
	self.registered = true
	registerPlayerResources()
	registerGameplayResources()
	registerStageGameplayResources()
	registerBackgroundResources()
	registerSounds()
	registerMusic()
	M._registered = true
end

local function loadSets(owner, ...)
	if owner == manager then
		M.register()
	else
		owner:register()
	end
	lstg.ResourceSet.LoadByName(false, ...)
end

local function normalizeStage(stage_number)
	stage_number = tonumber(stage_number) or
		(LikeDreamer.runtime and (LikeDreamer.runtime.stageNumber or LikeDreamer.runtime.stage))
	stage_number = math.floor(stage_number or 1)
	assert(stage_number >= 1 and stage_number <= 10,
		"Like Dreamer resource stage must be 1..10")
	return stage_number
end

function ResourceManager:loadPlayer()
	loadSets(self, "LikeDreamer.Player", "LikeDreamer.SE")
end

function ResourceManager:loadStage(stage_number)
	stage_number = normalizeStage(stage_number)
	if self.activeBackground and self.activeBackground ~= stage_number then
		lstg.ResourceSet.UnloadByName("LikeDreamer.Background." .. self.activeBackground)
	end
	if self.activeStageGameplay and self.activeStageGameplay ~= stage_number then
		lstg.ResourceSet.UnloadByName(
			"LikeDreamer.Gameplay.Stage." .. self.activeStageGameplay)
	end
	if self.lateGameplayLoaded and stage_number < 7 then
		lstg.ResourceSet.UnloadByName("LikeDreamer.Gameplay.Late")
		self.lateGameplayLoaded = false
	end
	self.activeBackground = stage_number
	self.activeStageGameplay = stage_number
	loadSets(self,
		"LikeDreamer.Gameplay",
		"LikeDreamer.Gameplay.Stage." .. stage_number,
		"LikeDreamer.Background." .. stage_number)
	if stage_number >= 7 then
		loadSets(self, "LikeDreamer.Gameplay.Late")
		self.lateGameplayLoaded = true
	end
end

function ResourceManager:loadBgm(stage_number)
	stage_number = normalizeStage(stage_number)
	local boss_number = math.min(5, math.floor((stage_number + 1) / 2))
	if self.activeStageBgm and self.activeStageBgm ~= stage_number then
		lstg.ResourceSet.UnloadByName("LikeDreamer.BGM.Stage." .. self.activeStageBgm)
	end
	if self.activeBossBgm and self.activeBossBgm ~= boss_number then
		lstg.ResourceSet.UnloadByName("LikeDreamer.BGM.Boss." .. self.activeBossBgm)
	end
	self.activeStageBgm = stage_number
	self.activeBossBgm = boss_number
	loadSets(self,
		"LikeDreamer.BGM.Stage." .. stage_number,
		"LikeDreamer.BGM.Boss." .. boss_number)
end

function ResourceManager:load(stage_number)
	stage_number = normalizeStage(stage_number)
	self:loadPlayer()
	self:loadStage(stage_number)
	self:loadBgm(stage_number)
end

-- Compatibility facade retained for existing scripts and replay entry points.
function M.register() return manager:register() end
function M.loadPlayer() return manager:loadPlayer() end
function M.loadStage(stage_number) return manager:loadStage(stage_number) end
function M.loadBgm(stage_number) return manager:loadBgm(stage_number) end
function M.load(stage_number)
	stage_number = normalizeStage(stage_number)
	M.loadPlayer()
	M.loadStage(stage_number)
	M.loadBgm(stage_number)
end

manager:register()

return M
