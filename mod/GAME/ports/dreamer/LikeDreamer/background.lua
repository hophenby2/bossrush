LikeDreamer = LikeDreamer or {}

local Core = assert(LikeDreamer.Core, "LikeDreamer.Core must be loaded before the background")
local M = {}
LikeDreamer.Background = M

local sin = math.sin
local cos = math.cos
local floor = math.floor
local max = math.max
local pi = math.pi

local TALL_PERIOD = 0x0a00

local dedicated_parts = LikeDreamer.Resources and LikeDreamer.Resources.dedicatedParts or {}

local stage_end_frame = {
	[1] = 5700,
	[2] = 9700,
	[3] = 9500,
	[4] = 11700,
	[5] = 11800,
	[6] = 12500,
	[7] = 12500,
	[8] = 21420,
	[9] = 17900,
}
M.stage_end_frame = stage_end_frame

local function clamp(v, lo, hi)
	if v < lo then return lo end
	if v > hi then return hi end
	return v
end

local function byte(v)
	return clamp(floor(v), 0, 255)
end

local function numeric(value)
	if type(value) == "number" then
		return value
	end
end

local function first_number(source, names, fallback)
	if type(source) == "table" then
		for _, name in ipairs(names) do
			local value = numeric(source[name])
			if value then return value end
		end
	end
	return fallback
end

local function sine_envelope(frame, enter_start, enter_end,
		leave_start, leave_end, outside, inside)
	local value = inside
	if enter_start ~= enter_end then
		if frame < enter_start then
			value = outside
		elseif frame < enter_end then
			local phase = (frame - enter_start) * pi / ((enter_end - enter_start) * 2)
			value = outside + sin(phase) * (inside - outside)
		end
	end
	if leave_start ~= leave_end then
		if frame >= leave_start and frame < leave_end then
			local phase = (frame - (leave_start * 2 - leave_end)) * pi /
				((leave_end - leave_start) * 2)
			value = outside + sin(phase) * (inside - outside)
		elseif frame >= leave_end then
			value = outside
		end
	end
	return value
end

local function image(prefix, zero_based_index)
	return prefix .. tostring(zero_based_index + 1)
end

local function script_random_angle(seed)
	local random = Core.frameRand(seed)
	return Core.angle16(random - floor(random / 0x10001))
end

local function script_random_hundredth(seed, minimum, maximum)
	local minimum100 = floor(minimum * 100)
	local maximum100 = floor(maximum * 100)
	return (minimum100 + Core.frameRand(seed) % (maximum100 - minimum100 + 1)) / 100
end

---@class LikeDreamer.Background.Class : lstg.Class
local Background = Class(object)
M.Class = Background

local function resolve_stage(value)
	if type(value) == "number" then
		return clamp(floor(value), 1, 10)
	end
	if type(value) == "table" then
		local stage_number = first_number(value, {
			"stageNumber", "stage_number", "selectedStage", "selected_stage", "stage",
		}, nil)
		if stage_number then
			return clamp(floor(stage_number), 1, 10)
		end
	end
	return 1
end

function Background:init(stage_or_runtime, runtime)
	if type(stage_or_runtime) == "table" then
		self.runtime = stage_or_runtime
		self.stage = resolve_stage(stage_or_runtime)
	else
		self.stage = resolve_stage(stage_or_runtime)
		self.runtime = runtime
	end
	self.group = GROUP_GHOST
	self.layer = LAYER_BG - 0.1
	self.colli = false
	self.bound = false
	self.scroll = {0, 0, 0, 0}
	self.layers = {}
	self.effects = {}
	self.last_runtime_frame = nil
	self.runtime_frame = 0
	self.gate = false
	self.boss_state = -1
	self.boss_timer = 0
	self.boss_defeat_frames = {}
	if LikeDreamer.Resources and LikeDreamer.Resources.loadStage then
		LikeDreamer.Resources.loadStage(self.stage)
	end
end

function Background:setRuntime(runtime)
	self.runtime = runtime
	local stage_number = first_number(runtime, {
		"stageNumber", "stage_number", "selectedStage", "selected_stage", "stage",
	}, nil)
	if stage_number then self.stage = resolve_stage(stage_number) end
	self.last_runtime_frame = nil
	self.scroll = {0, 0, 0, 0}
	self.effects = {}
end

function Background:_readRuntime()
	local runtime = self.runtime
	local frame = first_number(runtime, {
		"frame", "stageFrame", "stage_frame", "frameNumber", "frame_number", "timer",
	}, self.timer or 0)
	self.runtime_frame = max(0, floor(frame))
	local stage_number = first_number(runtime, {
		"stageNumber", "stage_number", "selectedStage", "selected_stage", "stage",
	}, nil)
	if stage_number then self.stage = resolve_stage(stage_number) end
	self.gate = type(runtime) == "table" and
		(runtime.gate == true or runtime.stageGateOpen == true or runtime.stage_gate_open == true) or false

	local boss = type(runtime) == "table" and
		(runtime.boss or runtime.activeBoss or runtime.active_boss) or nil
	self.boss_state = first_number(runtime, {
		"backgroundBossState", "background_boss_state",
		"stage08BossState", "stage08_boss_state", "stage09BossState", "stage09_boss_state",
		"bossState", "boss_state",
	}, first_number(boss, {"helperState", "helper_state", "state"}, -1))
	self.boss_timer = first_number(runtime, {
		"backgroundBossTimer", "background_boss_timer",
		"stage08BossTimer", "stage08_boss_timer", "stage09BossTimer", "stage09_boss_timer",
		"bossTimer", "boss_timer",
	}, first_number(boss, {"helperTimer", "helper_timer", "timer"}, 0))

	if type(runtime) == "table" then
		self.boss_defeat_frames = runtime.stage09BossDefeatFrames or
			runtime.stage09_boss_defeat_frames or runtime.bossDefeatFrames or
			runtime.boss_defeat_frames or self.boss_defeat_frames
	end
end

function Background:_animationFrame(frame)
	local runtime = self.runtime
	local value = first_number(runtime, {
		"animationFrame", "animation_frame", "drawAnimationClock", "draw_animation_clock",
	}, nil)
	if value then return max(0, floor(value)) end
	local p = rawget(_G, "player")
	if type(p) == "table" then
		value = first_number(p, {"drawAnimationClock", "draw_animation_clock", "timer"}, nil)
		if value then return max(0, floor(value)) end
	end
	return max(0, frame)
end

function Background:_addScrolled(layers, layer, slot, img, x,
		red, green, blue, alpha, speed, additive)
	if self._advance_scroll then
		local index = slot + 1
		self.scroll[index] = (self.scroll[index] + speed) % TALL_PERIOD
	end
	if not layers then return end
	layers[#layers + 1] = {
		kind = "scroll",
		layer = layer,
		order = #layers + 1,
		slot = slot,
		img = img,
		x = x,
		red = red,
		green = green,
		blue = blue,
		alpha = alpha,
		additive = additive == true,
	}
end

function Background:_addDedicated(layers, layer, img, x, y, bottom_anchor,
		red, green, blue, alpha, additive)
	if not layers then return end
	layers[#layers + 1] = {
		kind = "dedicated",
		layer = layer,
		order = #layers + 1,
		img = img,
		x = x,
		y = y,
		bottom_anchor = bottom_anchor == true,
		red = red or 255,
		green = green or 255,
		blue = blue or 255,
		alpha = alpha or 255,
		additive = additive == true,
	}
end

function Background:_addEffect(layers, effect)
	if not layers or not effect.draw then return end
	layers[#layers + 1] = {
		kind = "effect",
		layer = effect.draw_layer,
		order = #layers + 1,
		img = effect.img,
		x = effect.draw_x,
		y = effect.draw_y,
		angle16 = effect.draw_angle16,
		scale_x = effect.draw_scale_x,
		scale_y = effect.draw_scale_y,
		top_anchor = effect.top_anchor == true,
		red = effect.red,
		green = effect.green,
		blue = effect.blue,
		alpha = effect.draw_alpha,
		additive = effect.additive == true,
	}
end

function Background:_spawnEffect(effect)
	effect.age = 0
	effect.draw = false
	effect.red = effect.red or 255
	effect.green = effect.green or 255
	effect.blue = effect.blue or 255
	effect.alpha = effect.alpha or 255
	effect.scale_x = effect.scale_x or 0
	effect.scale_y = effect.scale_y or effect.scale_x
	self.effects[#self.effects + 1] = effect
end

function Background:_spawnBackgroundEffects(frame)
	local animation_frame = Background._animationFrame(self, frame)
	if self.stage == 3 then
		local towers
		if frame == 0x578 then
			towers = {492}
		elseif frame == 0x10b8 then
			towers = {213}
		elseif frame == 0x1c0c then
			towers = {105, 622}
		end
		for _, x in ipairs(towers or {}) do
			Background._spawnEffect(self, {
				type = 0x3a, img = "ld_effect_l_14", draw_layer = 0x13,
				x = x, y = -200, angle16 = 0, scale_x = 1, scale_y = 1,
				extent = 600, creation_frame = frame, additive = true,
				top_anchor = true,
			})
		end
	elseif self.stage == 4 then
		local brightness = 0xc0
		if frame >= 0 and frame < 11700 then
			brightness = 0x80 + floor(sin((frame + 11700) * pi / 23400) * 64)
		elseif frame >= 11700 then
			brightness = 0x80
		end
		if frame % 0x28 == 5 then
			Background._spawnEffect(self, {
				type = 0x3b, img = "ld_effect_l_15", draw_layer = 5,
				x = 360, y = 750, angle16 = 0xc000, speed = 1,
				scale_x = 0, scale_y = 0, lifetime = 0x5a,
				creation_clock = animation_frame, red = brightness,
				green = brightness, blue = brightness, alpha = 0x60,
				additive = true,
			})
		end
		if frame % 0x3f == 5 then
			local random = Core.frameRand(frame)
			Background._spawnEffect(self, {
				type = 0x3c, img = "ld_effect_m_20", draw_layer = 6,
				x = 360, y = 750,
				angle16 = Core.angle16(random % 0x5dc1 - 0x6ee0),
				speed = script_random_hundredth(frame, 1.5, 3),
				scale_x = 0, scale_y = 0, lifetime = 0x96,
				red = brightness, green = brightness, blue = brightness,
				alpha = 0x60, additive = true,
			})
		end
	elseif self.stage == 5 and frame <= 11800 - 600 then
		if animation_frame % 0x18 == 0 then
			Background._spawnEffect(self, {
				type = 0x3d, img = image("ld_stageback2_", 1), draw_layer = 5,
				x = 360, y = 640, angle16 = 0xc000, speed = 0.5,
				scale_x = 0, scale_y = 0, lifetime = 0x78,
				creation_clock = animation_frame,
			})
		end
		if animation_frame % 0x13 == 0 then
			Background._spawnEffect(self, {
				type = 0x3e, img = image("ld_stageback2_", 2), draw_layer = 10,
				x = 360, y = 640, angle16 = 0xc000, speed = 0.5,
				scale_x = 0, scale_y = 0, lifetime = 0x78,
				creation_clock = animation_frame, alpha = 0x80, additive = true,
			})
		end
	elseif self.stage == 8 and frame >= 0x1a90 and frame < 0x2968 and
			animation_frame % 0x20 == 0 then
		Background._spawnEffect(self, {
			type = 0x42, img = image("ld_stageback2_", 5), draw_layer = 5,
			x = 360, y = 640, angle16 = 0xc000, speed = 2,
			scale_x = 0, scale_y = 0, lifetime = 100,
		})
	end
end

local function lifetime_alpha(age, lifetime, alpha)
	if age < 0 then return 0 end
	if age < 0x20 then
		return sin(age * pi / 64) * alpha
	end
	if age >= lifetime - 0x10 then
		if age < lifetime then
			return sin((age - (lifetime - 0x20)) * pi / 32) * alpha
		end
		return 0
	end
	return alpha
end

local function effect_brightness(age, lifetime, rise_start)
	local rise_end = lifetime - 0x10
	if age >= rise_start and age < rise_end then
		return floor(sin((age - rise_start) * pi /
			(2 * (rise_end - rise_start))) * 255)
	end
	if age >= rise_end and age < lifetime then
		return floor(sin((age - (rise_end * 2 - lifetime)) * pi /
			(2 * (lifetime - rise_end))) * 255)
	end
	return 0
end

function Background:_updateEffect(effect, frame, animation_frame)
	local age = effect.age
	local type_id = effect.type
	if type_id == 0x3a then
		effect.y = effect.y + 1
		effect.draw_x, effect.draw_y = effect.x, effect.y
		effect.draw_angle16 = effect.angle16
		effect.draw_scale_x = effect.scale_x
		effect.draw_scale_y = (sin(age * 2 * pi / 3) * 0.1 + 1) * effect.scale_y
		effect.draw_alpha = effect.alpha
		local player_x = Core.playerLD()
		local origin = player_x / 6
		if effect.x < origin - effect.extent or
				effect.x > origin + 600 + effect.extent or
				effect.y < -effect.extent or effect.y > 720 + effect.extent then
			effect.dead = true
		end
	elseif type_id == 0x3b or type_id == 0x3c then
		local dx, dy = Core.polar(effect.angle16, effect.speed)
		effect.x, effect.y = effect.x + dx, effect.y + dy
		if type_id == 0x3c then effect.speed = effect.speed + 0.04 end
		effect.scale_x = effect.scale_x +
			(age * (type_id == 0x3b and 0.00002 or 0.000001) +
			(type_id == 0x3b and 0.0005 or 0.00012)) * age
		effect.scale_y = effect.scale_x
		effect.draw_x, effect.draw_y = effect.x, effect.y
		if type_id == 0x3b then
			effect.draw_angle16 = script_random_angle(effect.creation_clock)
		else
			local orbit_angle = Core.angle16(
				(floor((animation_frame + age) / 2) % 0x10000) * 0x22b)
			local ox, oy = Core.polar(orbit_angle, effect.scale_x * 60)
			effect.draw_x, effect.draw_y = effect.x + ox, effect.y + oy
			effect.draw_angle16 = 0
		end
		effect.draw_scale_x, effect.draw_scale_y = effect.scale_x, effect.scale_y
		effect.draw_alpha = lifetime_alpha(age, effect.lifetime, effect.alpha)
		if age == effect.lifetime or frame == 11701 then effect.dead = true end
	elseif type_id == 0x3d or type_id == 0x3e then
		local dx, dy = Core.polar(effect.angle16, effect.speed)
		effect.x, effect.y = effect.x + dx, effect.y + dy
		local brightness = effect_brightness(age, effect.lifetime, 0x18)
		local stage_alpha = 0
		if frame > 180 and frame < 600 then
			stage_alpha = sin((frame - 180) * pi / 840) * effect.alpha
		elseif frame >= 600 then
			stage_alpha = effect.alpha
		end
		effect.speed = effect.speed + 0.08
		effect.scale_x = effect.scale_x + (age * 0.00002 + 0.0005) * age
		effect.scale_y = effect.scale_x
		effect.red, effect.green, effect.blue = brightness, brightness, brightness
		effect.draw_layer = type_id == 0x3d and 5 + floor(age / 0x18) or 10
		effect.draw_x, effect.draw_y = effect.x, effect.y
		effect.draw_angle16 = script_random_angle(effect.creation_clock)
		effect.draw_scale_x, effect.draw_scale_y = effect.scale_x, effect.scale_y
		effect.draw_alpha = stage_alpha
		if age == effect.lifetime then effect.dead = true end
	elseif type_id == 0x42 then
		local dx, dy = Core.polar(effect.angle16, effect.speed)
		effect.x, effect.y = effect.x + dx, effect.y + dy
		local brightness = effect_brightness(age, effect.lifetime, 0x10)
		local stage_alpha = 0
		if frame >= 0x1af4 and frame < 0x1ce8 then
			stage_alpha = sin((frame - 0x1af4) * pi / 1000) * effect.alpha
		elseif frame >= 0x1ce8 then
			stage_alpha = effect.alpha
		end
		effect.scale_x = effect.scale_x + (age * 0.00003 + 0.0001) * age
		effect.scale_y = effect.scale_x
		effect.red, effect.green, effect.blue = brightness, brightness, brightness
		effect.draw_layer = 5 + floor(age / 0x18)
		effect.draw_x, effect.draw_y = effect.x, effect.y
		effect.draw_angle16 = 0
		effect.draw_scale_x, effect.draw_scale_y = effect.scale_x, effect.scale_y
		effect.draw_alpha = stage_alpha
		if age == effect.lifetime then effect.dead = true end
	end
	effect.draw = true
	effect.age = age + 1
end

function Background:_updateBackgroundEffects(frame)
	local retained = {}
	for _, effect in ipairs(self.effects) do
		if not effect.dead then retained[#retained + 1] = effect end
	end
	self.effects = retained
	Background._spawnBackgroundEffects(self, frame)
	local animation_frame = Background._animationFrame(self, frame)
	for _, effect in ipairs(self.effects) do
		Background._updateEffect(self, effect, frame, animation_frame)
	end
end

function Background:_stage01(frame, layers)
	local speed = sine_envelope(frame, 600, 0x348, 5400, 5700, 10, 2.5)
	Background._addScrolled(self, layers, 1, 1, image("ld_stageback1_", 4), 360,
		255, 255, 255, 255, speed * 0.5)
	Background._addScrolled(self, layers, 3, 2, image("ld_stageback1_", 5), 360,
		255, 255, 255, 255, speed)
	if frame <= 600 then
		local alpha = 0
		if frame < 300 then
			alpha = 255
		elseif frame < 600 then
			alpha = sin(frame * pi / 600) * 255
		end
		Background._addScrolled(self, layers, 4, 0, image("ld_stageback1_", 2), 360,
			255, 255, 255, alpha, speed * 2)
	end
	Background._addScrolled(self, layers, 5, 3, image("ld_stageback1_", 3), 360,
		255, 255, 255, 128, speed * 3, true)
end

function Background:_stage02(frame, layers)
	local speed = sine_envelope(frame, 0, 300, 9700, 10300, 20, 1)
	Background._addScrolled(self, layers, 2, 0, image("ld_stageback1_", 6), 360,
		255, 255, 255, 255, speed * 0.5)
	Background._addScrolled(self, layers, 4, 1, image("ld_stageback1_", 7), 360,
		255, 255, 255, 255, speed * 0.75)
	if frame >= 750 and frame <= 10000 then
		Background._addDedicated(self, layers, 0x14, "ld_stage2back", 360, frame - 4970,
			false, 0, 0, 0, 0x30)
		Background._addDedicated(self, layers, 0x14, "ld_stage2back", 360, frame - 5000, false)
	end
end

function Background:_stage03(frame, layers)
	Background._addScrolled(self, layers, 2, 0, image("ld_stageback1_", 8), 360,
		255, 255, 255, 255, 6)
	if layers then
		local animation_frame = Background._animationFrame(self, frame)
		for i = 0, 6 do
			local edge = animation_frame * 2 % 0x96 + i * 0x96
			local top = animation_frame * 0x0f % 200 + i * 200
			for _, particle in ipairs({
				{x = edge, y = 360, angle16 = 0x4000},
				{x = 720 - edge, y = 360, angle16 = 0x4000},
				{x = 360, y = top, angle16 = 0},
			}) do
				Background._addEffect(self, layers, {
					draw = true, draw_layer = 3, img = "ld_effect_l_6",
					draw_x = particle.x, draw_y = particle.y,
					draw_angle16 = particle.angle16,
					draw_scale_x = 2, draw_scale_y = 1,
					red = 0, green = 255, blue = 0xc0, draw_alpha = 0x30,
					additive = true,
				})
			end
		end
	end
	Background._addScrolled(self, layers, 4, 1, image("ld_stageback1_", 9), 360,
		255, 255, 255, 255, 12, true)
	if frame >= 0x5dc and frame <= 9500 then
		Background._addDedicated(self, layers, 0x14, "ld_stage3back", 360, frame - 0x5dc, true)
	end
end

function Background:_stage04(frame, layers)
	local fade
	if frame < 0 then
		fade = 1
	elseif frame < 11700 then
		fade = cos(frame * pi / (11700 * 2))
	else
		fade = 0
	end
	local red_green = 32 + fade * 223
	local blue = 96 + fade * 159
	Background._addScrolled(self, layers, 1, 0, image("ld_stageback1b_", 0), 360,
		red_green, red_green, blue, 255, -0.7)
	Background._addScrolled(self, layers, 3, 1, image("ld_stageback1b_", 1), 360,
		red_green, red_green, blue, 0x48, -1.5, true)
end

function Background:_stage05(frame, layers)
	local end_frame = 11800
	if frame <= end_frame - 600 then return end
	local alpha = 0
	if frame >= end_frame then
		alpha = 255
	elseif frame >= end_frame - 450 then
		alpha = sin((frame - (end_frame - 450)) * pi / 900) * 255
	end
	local speed = 0.2
	if frame >= end_frame + 600 then
		speed = 3
	elseif frame >= end_frame then
		speed = 0.2 + sin((frame - end_frame) * pi / 1200) * 2.8
	end
	Background._addScrolled(self, layers, 1, 0, image("ld_stageback1b_", 2), 360,
		alpha, alpha, alpha, 255, speed)
	Background._addScrolled(self, layers, 2, 1, image("ld_stageback1b_", 3), 360,
		alpha, alpha, alpha, 255, speed * 2.2)
	Background._addScrolled(self, layers, 3, 2, image("ld_stageback1b_", 4), 360,
		alpha, alpha, alpha, 255, speed * 3.4)
	Background._addScrolled(self, layers, 4, 3, image("ld_stageback1b_", 5), 360,
		alpha, alpha, alpha, 255, speed * 4.6)
end

function Background:_stage06(frame, layers)
	local end_frame = 12500
	local speed = frame < 0 and 20 or 1
	if frame >= 0 and frame < 300 then
		speed = 20 - sin(frame * pi / 600) * 19
	elseif frame >= end_frame + 300 and frame < end_frame + 900 then
		speed = 10 - sin((frame - (end_frame - 300)) * pi / 1200) * 9
	elseif frame >= end_frame + 900 then
		speed = 10
	end
	Background._addScrolled(self, layers, 1, 0, image("ld_stageback1b_", 6), 360,
		255, 255, 255, 255, speed * 0.5)
	Background._addScrolled(self, layers, 2, 1, image("ld_stageback1b_", 7), 360,
		128, 128, 255, 0x32, speed * 0.7, true)
	Background._addScrolled(self, layers, 3, 2, image("ld_stageback1b_", 8), 360,
		192, 192, 255, 0x4b, speed, true)
	Background._addScrolled(self, layers, 4, 3, image("ld_stageback1b_", 9), 360,
		255, 255, 255, 100, speed * 1.4, true)
	if frame > 0x419 and frame <= end_frame + 300 then
		Background._addDedicated(self, layers, 0x14, "ld_stage6back", 360, frame - 0x44c, true)
	end
end

local stage07_palette = {
	{255, 120, 120}, {255, 200, 110}, {255, 255, 120},
	{120, 255, 120}, {120, 255, 255}, {120, 120, 255},
	{220, 120, 255},
}

function Background:_stage07(frame, layers)
	local animation_frame = Background._animationFrame(self, frame)
	local palette_index = floor(animation_frame / 300) % #stage07_palette + 1
	local palette_next = palette_index % #stage07_palette + 1
	local local_frame = animation_frame % 300
	local color = {}
	for channel = 1, 3 do
		local current = stage07_palette[palette_index][channel]
		local target = stage07_palette[palette_next][channel]
		color[channel] = current - (current - target) * local_frame / 300
	end
	Background._addScrolled(self, layers, 1, 0, image("ld_stageback1c_", 0), 360,
		color[1], color[2], color[3], 255, 8)
	Background._addScrolled(self, layers, 2, 1, image("ld_stageback1c_", 1), 360,
		color[1] / 3, color[2] / 3, color[3] / 3, 255, 4.8)
	Background._addScrolled(self, layers, 4, 2, image("ld_stageback1_", 3), 360,
		128, 128, 128, 192, 12.8, true)
	if frame < 12500 - 480 then
		local fade = 0
		if frame >= 300 then
			fade = 255
		elseif frame >= 0 then
			fade = 255 * sin(frame * pi / 600)
		end
		local x = 360 + 80 * sin(frame * 2 * pi / 3300)
		Background._addScrolled(self, layers, 0x14, 2, image("ld_stageback1c_", 2), x,
			fade, fade, fade, 255, 16)
	end
	if frame >= 12500 - 600 and frame < 12500 - 300 then
		local local_transition = frame - (12500 - 600)
		local envelope
		if local_transition < 120 then
			envelope = sin(local_transition * pi / 240)
		else
			envelope = sin((300 - local_transition) * pi / 360)
		end
		Background._addScrolled(self, layers, 0x18, 3, image("ld_stageback1_", 2), 360,
			128, 128, 128, 255 * max(0, envelope), 32)
	end
end

function Background:_languageVariant()
	local runtime = self.runtime
	local language = first_number(runtime, {"language", "languageIndex", "language_index"}, 0)
	local variants = {5, 6, 10, 11}
	return variants[clamp(floor(language), 0, 3) + 1]
end

function Background:_stage08(frame, layers)
	local end_frame = 21420
	if frame < 0x1af4 then
		local layer_alpha = 255
		if frame >= 240 and frame < 360 then
			layer_alpha = sin((frame - 120) * pi / 240) * 255
		elseif frame >= 360 then
			layer_alpha = 0
		end
		local speed = 10
		if frame >= 240 and frame < 360 then
			speed = 10 - sin((frame - 240) * pi / 240) * 9
		elseif frame >= 360 then
			speed = 1
		end
		if frame < 6001 then
			Background._addScrolled(self, layers, 1, 1, image("ld_stageback1_", 4), 360,
				255, 255, 255, 255, speed * 0.5)
			Background._addScrolled(self, layers, 3, 2, image("ld_stageback1_", 3), 360,
				255, 255, 128, 128, speed * 7)
		end
		if frame < 401 then
			Background._addScrolled(self, layers, 4, 0, image("ld_stageback1_", 2), 360,
				128, 128, 128, layer_alpha, 32)
		end
		if frame >= 400 then
			Background._addDedicated(self, layers, 0x14, "ld_stage8back1", 360, frame - 400, true)
		end
		if frame >= 6000 then
			local alpha = 255
			if frame >= 0x1a5e then
				alpha = sin((frame - 6600) * pi / 300) * 255
			end
			Background._addDedicated(self, layers, 1, image("ld_stageback2_", 4), 360, 360,
				false, 255, 255, 255, alpha, true)
		end
	end

	if frame < 0x29cc then return end
	local alpha = 0
	if frame > 0x29cc and frame < 0x2c24 then
		alpha = sin((frame - 0x29cc) * pi / 1200) * 255
	elseif frame >= 0x2c24 then
		alpha = 255
	end
	if frame >= end_frame - 600 then
		if frame < end_frame - 480 then
			alpha = sin((frame - (end_frame - 720)) * pi / 240) * 255
		else
			alpha = 0
		end
	end
	if frame >= end_frame - 300 then
		if frame < end_frame then
			alpha = sin((frame - (end_frame - 300)) * pi / 600) * 255
		else
			alpha = 255
		end
	end
	local speed = 0
	if frame > 0x29cc and frame < 0x300c then
		speed = sin((frame - 0x29cc) * pi / 3200)
	elseif frame >= 0x300c then
		speed = 1
	end
	if frame >= 0x4394 then
		speed = sine_envelope(frame, 0x4394, 0x45ec,
			end_frame - 480, end_frame - 300, 1, 12)
	end
	if frame >= end_frame and self.gate and self.boss_state > 10 then
		speed = 10
		if self.boss_state == 11 and self.boss_timer >= 0 and self.boss_timer < 300 then
			speed = 1 + sin(self.boss_timer * pi / 600) * 9
		end
	end
	Background._addScrolled(self, layers, 1, 0, image("ld_stageback1c_", 3), 360,
		255, 255, 255, alpha, speed * 0.3)
	if frame < end_frame - 480 then
		Background._addScrolled(self, layers, 2, 1, image("ld_stageback1c_", 4), 360,
			255, 255, 255, alpha * 0.6, speed * 0.5)
		Background._addScrolled(self, layers, 3, 2, image("ld_stageback1c_", Background._languageVariant(self)), 360,
			255, 255, 255, alpha * 0.8, speed * 0.7)
		Background._addScrolled(self, layers, 4, 3, image("ld_stageback1_", 1), 360,
			64, 255, 192, alpha * 0.3, speed * 1.5)
	end
	if frame >= end_frame - 300 then
		local amount = frame < end_frame and
			sin((frame - (end_frame - 300)) * pi / 600) or 1
		Background._addScrolled(self, layers, 2, 3, image("ld_stageback1c_", 7), 360,
			0, amount * 255 * 0.3, amount * 192 * 0.3, 255, speed * 0.5)
		Background._addScrolled(self, layers, 3, 2, image("ld_stageback1c_", 8), 360,
			0, amount * 255 * 0.55, amount * 192 * 0.55, 255, speed * 0.8)
		Background._addScrolled(self, layers, 4, 1, image("ld_stageback1c_", 9), 360,
			0, amount * 255 * 0.8, amount * 192 * 0.8, 255, speed * 1.2)
	end
	if frame >= 0x2a30 and frame <= end_frame then
		Background._addDedicated(self, layers, 0x14, "ld_stage8back2", 360, frame - 0x2a30, true)
	end
end

local stage09_color_start = {1350, 4100, 6200, 9000, 11860, 13900}
local stage09_targets = {
	{64, 192, 192}, {192, 128, 64}, {64, 192, 64},
	{64, 64, 192}, {64, 64, 64}, {128, 64, 192},
}

function Background:_stage09Color(frame)
	local base = {192, 64, 64}
	local color = {base[1], base[2], base[3]}
	local color_index
	for i, start in ipairs(stage09_color_start) do
		if frame >= start then color_index = i end
	end
	if not color_index or frame >= 16099 then return color end
	local target = stage09_targets[color_index]
	local defeat
	if self.boss_defeat_frames[0] ~= nil then
		defeat = self.boss_defeat_frames[color_index - 1]
	else
		defeat = self.boss_defeat_frames[color_index]
	end
	local returning = type(defeat) == "number" and defeat >= 0 and frame >= defeat
	local local_frame = returning and (frame - defeat) or
		(frame - stage09_color_start[color_index])
	local amount = clamp(local_frame, 0, 180)
	for channel = 1, 3 do
		local from = returning and target[channel] or base[channel]
		local to = returning and base[channel] or target[channel]
		color[channel] = (from * (180 - amount) + to * amount) / 180
	end
	return color
end

function Background:_stage09(frame, layers)
	local end_frame = 17900
	local base = {192, 64, 64}
	local color = Background._stage09Color(self, frame)
	if frame < end_frame - 480 then
		local alpha = 0
		if frame >= 300 and frame < 1500 then
			alpha = 255 * sin((frame - 300) * pi / 2400)
		elseif frame >= 1500 and frame < end_frame - 600 then
			alpha = 255
		elseif frame >= end_frame - 600 then
			alpha = 255 * sin((frame - (end_frame - 720)) * pi / 240)
		end
		Background._addScrolled(self, layers, 1, 0, image("ld_stageback1d_", 0), 360,
			color[1], color[2], color[3], alpha, 3)
		Background._addScrolled(self, layers, 2, 1, image("ld_stageback1d_", 1), 360,
			color[1], color[2], color[3], alpha, 7)
		Background._addScrolled(self, layers, 4, 2, image("ld_stageback1d_", 2), 360,
			color[1], color[2], color[3], alpha, 10)
		return
	end

	local amount = 0
	if frame >= end_frame then
		amount = 1
	elseif frame >= end_frame - 300 then
		amount = sin((frame - (end_frame - 300)) * pi / 600)
	end
	local speed = 10 - 10 * sin((frame - (end_frame - 480)) * pi / 960)
	if frame >= end_frame then speed = 0 end
	if frame >= end_frame and self.gate and self.boss_state >= 11 then
		speed = 16
		if (self.boss_state == 11 or self.boss_state == 111) and self.boss_timer < 300 then
			speed = 16 * sin(max(0, self.boss_timer) * pi / 600)
		end
	end
	Background._addScrolled(self, layers, 1, 0, image("ld_stageback1d_", 0), 360,
		base[1], base[2], base[3], amount * 255, speed * 0.3)
	Background._addScrolled(self, layers, 2, 1, image("ld_stageback1c_", 7), 360,
		base[1] * amount * 0.3, base[2] * amount * 0.3,
		base[3] * amount * 0.3, 255, speed * 0.5)
	Background._addScrolled(self, layers, 3, 2, image("ld_stageback1c_", 8), 360,
		base[1] * amount * 0.55, base[2] * amount * 0.55,
		base[3] * amount * 0.55, 255, speed * 0.8)
	Background._addScrolled(self, layers, 4, 3, image("ld_stageback1c_", 9), 360,
		base[1] * amount * 0.8, base[2] * amount * 0.8,
		base[3] * amount * 0.8, 255, speed * 1.2)
end

function Background:_stage10(frame, layers)
	local speed
	if frame < 0 then
		speed = 10
	elseif frame < 480 then
		speed = 10 - 8 * sin(frame * pi / 960)
	else
		speed = 2
	end
	Background._addScrolled(self, layers, 1, 0, image("ld_stageback1d_", 3), 360,
		255, 255, 255, 255, speed * 0.4)
	Background._addScrolled(self, layers, 1, 1, image("ld_stageback1d_", 4), 360,
		255, 255, 255, 255, speed)
	Background._addScrolled(self, layers, 3, 2, image("ld_stageback1d_", 5), 360,
		255, 255, 255, 255, 16)
end

function Background:_scene(frame, layers)
	local handler = Background["_stage" .. string.format("%02d", self.stage)]
	if handler then handler(self, frame, layers) end
end

function Background:frame()
	Background._readRuntime(self)
	local frame = self.runtime_frame
	if self.last_runtime_frame and frame < self.last_runtime_frame then
		self.scroll = {0, 0, 0, 0}
		self.effects = {}
		self.last_runtime_frame = nil
	end
	if frame ~= self.last_runtime_frame then
		local first = self.last_runtime_frame and self.last_runtime_frame + 1 or frame
		self._advance_scroll = true
		for current = first, frame do
			if self.stage == 8 and current == 0x29cc then
				self.scroll = {0, 0, 0, 0}
			end
			Background._scene(self, current, nil)
			Background._updateBackgroundEffects(self, current)
		end
		self._advance_scroll = false
		self.last_runtime_frame = frame
	end
	local layers = {}
	Background._scene(self, frame, layers)
	for _, effect in ipairs(self.effects) do Background._addEffect(self, layers, effect) end
	table.sort(layers, function(a, b)
		if a.layer == b.layer then return a.order < b.order end
		return a.layer < b.layer
	end)
	self.layers = layers
end

function Background:_worldX(logical_x, layer)
	local player_x = Core.playerLD()
	local parallax = layer < 6 and layer / 30 or 1 / 6
	local sx = Core.worldScale()
	return (lstg.world.l+lstg.world.r)/2 +
		((logical_x-360)+(360-player_x)*parallax)*sx
end

function Background:_worldY(logical_y)
	local _,sy = Core.worldScale()
	return lstg.world.t-logical_y*sy
end

local function set_image_state(node)
	lstg.SetImageState(node.img, node.additive and "mul+add" or "",
		lstg.Color(byte(node.alpha), byte(node.red), byte(node.green), byte(node.blue)))
end

local function reset_image_state(img)
	lstg.SetImageState(img, "", lstg.Color(255, 255, 255, 255))
end

function Background:_renderScrolled(node)
	if node.alpha <= 0 then return end
	set_image_state(node)
	local x = Background._worldX(self, node.x, node.layer)
	local scroll = self.scroll[node.slot + 1]
	local sx,sy = Core.worldScale()
	for _, offset in ipairs({0, TALL_PERIOD, -TALL_PERIOD}) do
		lstg.Render(node.img, x, Background._worldY(self, scroll + offset), 0,
			sx*1.005,sy)
	end
	reset_image_state(node.img)
end

function Background:_renderDedicated(node)
	if node.alpha <= 0 then return end
	local definition = dedicated_parts[node.img]
	local height = definition and definition.height or 720
	local logical_y = node.y
	if node.bottom_anchor then
		logical_y = logical_y - height * 0.5
	end
	local sx,sy = Core.worldScale()
	if node.img:find("^ld_stageback2_") then sx=sx*1.005 end
	local x = Background._worldX(self, node.x, 6)
	if not definition then
		set_image_state(node)
		lstg.Render(node.img, x, Background._worldY(self, logical_y), 0, sx, sy)
		reset_image_state(node.img)
		return
	end

	local top = logical_y - height * 0.5
	for _, part in ipairs(definition.parts) do
		local part_node = {
			img = part.img,
			additive = node.additive,
			alpha = node.alpha,
			red = node.red,
			green = node.green,
			blue = node.blue,
		}
		set_image_state(part_node)
		local part_y = top + part.offset + part.height * 0.5
		lstg.Render(part.img, x, Background._worldY(self, part_y), 0, sx, sy)
		reset_image_state(part.img)
	end
end

function Background:_renderEffect(node)
	if node.alpha <= 0 or node.scale_x == 0 or node.scale_y == 0 then return end
	set_image_state(node)
	local logical_y = node.y
	local sx,sy = Core.worldScale()
	if node.top_anchor then
		logical_y = logical_y + 300 * node.scale_y
	end
	lstg.Render(node.img, Background._worldX(self, node.x, 6), Background._worldY(self, logical_y),
		Core.angleToDeg(node.angle16 or 0),
		node.scale_x * sx, node.scale_y * sy)
	reset_image_state(node.img)
end

function Background:render()
	SetViewMode("world")
	lstg.RenderClear(lstg.Color(255, 0, 0, 0))
	for _, node in ipairs(self.layers) do
		if node.kind == "scroll" then
			Background._renderScrolled(self, node)
		elseif node.kind == "dedicated" then
			Background._renderDedicated(self, node)
		else
			Background._renderEffect(self, node)
		end
	end
end

function M.create(stage_or_runtime, runtime)
	return lstg.New(Background, stage_or_runtime, runtime)
end

return M
