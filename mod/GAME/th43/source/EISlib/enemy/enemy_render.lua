---=====================================
---东方祈华梦敌机渲染
---author:Xiliusha
---email:Xiliusha@outlook.com
---=====================================

local path = EISlib.Enemy.path
local respath = "res/enemy/"

local inrange = math.inrange

local Color = lstg.Color
local SetImageState = lstg.SetImageState
local SetAnimationState = lstg.SetAnimationState
local Render = lstg.Render
local RenderAnimation = lstg.RenderAnimation
local DefaultRenderFunc = lstg.DefaultRenderFunc

local COLOR_WHITE = Color(255, 255, 255, 255)
local hitFlashBlue = EGGlib.RenderEffect.hitFlashBlue
local LOAD_SIZE = 1 --资源读取尺寸(为之后低清素材作准备)

----------------------------------------
---res

local function load_res()
	if not lstg.CheckRes("tex", "_enemy_texture_1") then
		local respath = respath
		LoadTexture("_enemy_texture_1", respath .. "fairy_small_mid.png", false)
		LoadTexture("_enemy_texture_2", respath .. "fairy_large.png", false)
		LoadTexture("_enemy_texture_3", respath .. "fairy_small_mid_2.png", false)
		LoadTexture("_enemy_texture_4", respath .. "fairy_small_ball.png", false)
		LoadTexture("_enemy_texture_5", respath .. "fairy_gold_stroke.png", false)
		LoadTexture("_enemy_texture_6", respath .. "fairy_small3.png", false)
		LoadTexture("_enemy_texture_7", respath .. "fairy_mid3.png", false)
		LoadTexture("_enemy_texture_8", respath .. "fairy_large3.png", false)
		LoadTexture("_enemy_texture_9", respath .. "fairy_Remilia_cos.png", false) --cos蕾米小妖精
		LoadTexture("_enemy_texture_10", respath .. "tai_chi.png", false) --阴阳玉
		LoadTexture("_enemy_texture_11", respath .. "rabbit.png", false) --小兔子
		-- 小妖精
		do
			local s = 80*LOAD_SIZE
			for i = 1, 4 do
				LoadImageGroup("fairy_small" .. i, "_enemy_texture_1", 0, (i - 1) * s, s, s, 10, 1)
			end
		end

		-- 中妖精
		do
			local s = 96*LOAD_SIZE
			for i = 1, 4 do
				LoadImageGroup("fairy_mid" .. i, "_enemy_texture_1", 0, 320*LOAD_SIZE + (i - 1) * s, s, s, 9, 1)
			end
		end

		-- 大妖精
		do
			local s = 120*LOAD_SIZE
			for i = 1, 4 do
				LoadImageGroup("fairy_large" .. i, "_enemy_texture_2", 0, (i - 1) * 2*s, s, s, 8, 2)
			end
		end

		-- 仙界小妖精
		do
			local s = 80*LOAD_SIZE
			for i = 1, 4 do
				LoadImageGroup("fairy_small_2_" .. i, "_enemy_texture_3", 0, (i - 1) * s, s, s, 10, 1)
			end
		end

		-- 仙界中妖精
		do
			local s = 96*LOAD_SIZE
			for i = 1, 4 do
				LoadImageGroup("fairy_mid_2_" .. i, "_enemy_texture_3", 0, 320*LOAD_SIZE + (i - 1) * s, s, s, 10, 1)
			end
		end

		-- 外界小妖精
		do
			local w, h = 94*LOAD_SIZE, 92*LOAD_SIZE
			for i = 1, 10 do
				for j = 1, 4 do
					LoadImage("fairy_small_3_" .. j .. i, "_enemy_texture_4", (i - 1) * w, (j - 1) * h, w, h)
				end
			end
			for i = 11, 12 do
				for j = 1, 4 do
					LoadImage("fairy_small_3_" .. j .. i, "_enemy_texture_4", (i - 11) * w + (j - 1) * 2*w, 4*h, w, h)
				end
			end
		end

		-- 外界中妖精
		do
			local s, h0 = 120*LOAD_SIZE, 424*LOAD_SIZE
			for i = 1, 8 do
				LoadImage("fairy_mid_3_1" .. i, "_enemy_texture_4", (i - 1) * s, h0 + 3*s, s, s)
			end
			for i = 1, 2 do
				LoadImage("fairy_mid_3_1" .. (i + 8), "_enemy_texture_4", h0 + 600*LOAD_SIZE - (3-i) * s, h0, s, s)
			end
			for i = 1, 8 do
				LoadImage("fairy_mid_3_2" .. i, "_enemy_texture_4", (i - 1) * s, h0 + 4*s, s, s)
			end
			for i = 1, 2 do
				LoadImage("fairy_mid_3_2" .. (i + 8), "_enemy_texture_4", h0 + 600*LOAD_SIZE - (3-i) * s, h0 + s, s, s)
			end
			for i = 1, 6 do
				LoadImage("fairy_mid_3_3" .. i, "_enemy_texture_4", h0 + 600*LOAD_SIZE - (7-i) * s, h0 + 2*s, s, s)
			end
			for i = 1, 4 do
				LoadImage("fairy_mid_3_3" .. (i + 6), "_enemy_texture_4", h0 + 600*LOAD_SIZE - (7-i) * s, h0 + s, s, s)
			end
		end

		-- xhg小妖精
		do
			local w, h = 94*LOAD_SIZE, 88*LOAD_SIZE --单帧妖精的尺寸
			local function loadXhgSmallFairy(row, col)
				row, col = row - 1, col - 1
				local index = row + 2*col + 1
				LoadImageGroup("fairy_small_4_" .. index, "_enemy_texture_6", row*w*4, col*h*3, w, h, 4, 3)
			end
			--2行3列
			for col = 1, 3 do
				for row = 1, 2 do
					loadXhgSmallFairy(row, col)
				end
			end
		end

		-- xhg中妖精
		do
			local w, h = 118*LOAD_SIZE, 88*LOAD_SIZE --单帧妖精的尺寸
			local function loadXhgMidFairy(col)
				LoadImageGroup("fairy_mid_4_" .. col, "_enemy_texture_7", 0, (col-1)*h*3, w, h, 4, 3)
			end
			--2列
			for col = 1, 2 do
				loadXhgMidFairy(col)
			end
		end

		-- xhg大妖精
		do
			local w, h = 147*LOAD_SIZE, 138*LOAD_SIZE --单帧妖精的尺寸
			local function loadXhgLargeFairy(col)
				LoadImageGroup("fairy_large_4_" .. col, "_enemy_texture_8", 0, (col-1)*h*3, w, h, 4, 3)
			end
			--3列
			for col = 1, 3 do
				loadXhgLargeFairy(col)
			end
		end

		-- xhg鬼火
		do
			local function loadGhostFire(_type, col)
				LoadTexture("_ghost_fire_texture", respath .. "ghost_fire.png", false)
				LoadAnimation("ghost_fire".._type, "_ghost_fire_texture", 0, 74*(col-1), 64, 74, 5, 1, 4)
			end
			local _type = {8, 1, 3, 6, 2, 4, 5, 7} --按type顺序12345678对应的颜色鬼火贴图所在的纵列
			--1红 2蓝 3绿 4灰 5粉红 6紫 7橙 8青
			for i = 1, #_type do
				loadGhostFire(i, _type[i])
			end
		end

		--cos蕾米的小妖精
		do
			for i = 1, 3 do
				LoadImageGroup("fairy_small_5_" .. i, "_enemy_texture_9", 0, 80*(i-1), 80, 80, 9, 1)
			end
			--拿伞的
			LoadAniFromFile("fairy_small_5_sp", respath .. "fairy_Remilia_cos_umbrella.png", true, 4, 1, 8)
		end

		--莉莉白
		do
			LoadImageGroupFromFile("LilyWhite_enemy_", respath.."LilyWhite.png", false, 13, 2)
		end

		--2boss的小动物
		do
			for i = 1, 2 do
				LoadAnimation("rabbit_enemy_"..i, "_enemy_texture_11", 0, 64*(i-1), 64, 64, 4, 1, 8)
			end
		end

		--书本道具
		do
			LoadImageGroupFromFile("s3_book_img", respath.."book.png", true, 12, 2)
		end

		-- 通用魔法阵（按通用的颜色顺序加载）
		do
			local _index = {1, 7, 6, 5, 4, 3, 2, 8} --每个数字代表在原纹理中的第几个素材
			for i = 0, 7 do
				for j = 1, 2 do
					LoadImage("magic"..(2*i + j), "_enemy_texture_1", 128*(_index[i+1] - 1)*LOAD_SIZE, 704*LOAD_SIZE, 128*LOAD_SIZE, 128*LOAD_SIZE)
				end
			end
		end
		LoadImageGroup("magic", "_enemy_texture_1", 0, 704*LOAD_SIZE, 128*LOAD_SIZE, 128*LOAD_SIZE, 8, 1)
		-- 阴阳玉
		LoadImageGroup("fairy_aura", "_enemy_texture_10", 360*LOAD_SIZE, 0, 120*LOAD_SIZE, 120*LOAD_SIZE, 1, 7)
		LoadImageGroup("fairy_aura_magic", "_enemy_texture_10", 0, 0, 120*LOAD_SIZE, 120*LOAD_SIZE, 1, 7)
		--毛玉
		LoadImageGroup("fairy_ball", "_enemy_texture_4", 0, 460*LOAD_SIZE, 128*LOAD_SIZE, 128*LOAD_SIZE, 2, 2)

		--金色传说
		LoadImageGroup("fairy_small_gold_stroke_", "_enemy_texture_5", 0, 0, 80*LOAD_SIZE, 80*LOAD_SIZE, 10, 1)
		LoadImageGroup("fairy_mid_gold_stroke_", "_enemy_texture_5", 0, 80*LOAD_SIZE, 96*LOAD_SIZE, 96*LOAD_SIZE, 9, 1)
		LoadImageGroup("fairy_large_gold_stroke_", "_enemy_texture_5", 0, 176*LOAD_SIZE, 120*LOAD_SIZE, 120*LOAD_SIZE, 8, 2)
		LoadImageGroup("fairy_small_2_gold_stroke_", "_enemy_texture_5", 0, 416*LOAD_SIZE, 80*LOAD_SIZE, 80*LOAD_SIZE, 10, 1)
		LoadImageGroup("fairy_mid_2_gold_stroke_", "_enemy_texture_5", 0, 496*LOAD_SIZE, 96*LOAD_SIZE, 96*LOAD_SIZE, 10, 1)
		LoadImageGroup("fairy_small_3_gold_stroke_", "_enemy_texture_5", 0, 592*LOAD_SIZE, 94*LOAD_SIZE, 92*LOAD_SIZE, 10, 2)
		LoadImageGroup("fairy_mid_3_gold_stroke_", "_enemy_texture_5", 0, 776*LOAD_SIZE, 120*LOAD_SIZE, 120*LOAD_SIZE, 8, 1)
		for i = 1, 2 do
			LoadImage("fairy_mid_3_gold_stroke_" .. (i + 8), "_enemy_texture_5", (720 + (i - 1) * 120)*LOAD_SIZE, 296*LOAD_SIZE, 120*LOAD_SIZE, 120*LOAD_SIZE)
		end
	end
	--这些是体验版之后的！
	if not config.preview_version and not lstg.CheckRes("tex", "_enemy_texture_12") then
		local respath = "res/enemy2/"
		LoadTexture("_enemy_texture_12", respath .. "fairy_small6.png", false) --小女仆妖精1
		LoadTexture("_enemy_texture_13", respath .. "fairy_small7.png", false) --小女仆妖精2
		LoadTexture("_enemy_texture_15", respath .. "fairy_large6_blue.png", false) --大恶魔蓝
		LoadTexture("_enemy_texture_16", respath .. "excos.png", false) --cos主角的小妖精

		--小女仆妖精1
		do
			for i = 1, 3 do
				LoadImageGroup("fairy_small_6_" .. i, "_enemy_texture_12", 0, 80*(i-1), 80, 80, 9, 1)
			end
		end

		--小女仆妖精2
		do
			for i = 1, 4 do
				LoadImageGroup("fairy_small_7_" .. i, "_enemy_texture_13", 0, 120*(i-1), 120, 120, 9, 1)
			end
		end

		--大恶魔
		do
			LoadImageGroupFromFile("BigDevil_Red_", respath.."fairy_large6_red.png", false, 4, 3)
			LoadImageGroupFromFile("BigDevil_Blue_", respath.."fairy_large6_blue.png", false, 4, 3)
		end

		--作为非boss单位的猫
		do
			LoadImageGroupFromFile("Gluttony_enemy_", "res/boss/Gluttony/BossWalkImage1.png", false, 5, 3)
		end

		--ex cos妖精
		do
			LoadImageGroup("fairy_Reimu", "_enemy_texture_16", 0, 0, 80, 80, 9, 1)
			LoadImageGroup("fairy_Marisa", "_enemy_texture_16", 0, 80, 80, 80, 9, 1)
			LoadImageGroup("fairy_Sakuya", "_enemy_texture_16", 0, 160, 80, 80, 9, 1)
		end
	end
end

---@type EISlib.Enemy.WalkImageSystem
local wisys = lstg.DoFile(path .. "enemy_animation.lua")

load_res()
--lstg.EventDispatcher.addListener("EISlib.enemy.render", EVENT.ON_GAME_STAGE_INIT, 0, function()
--	load_res()
--end)

----------------------------------------
---style set

---@param obj enemy.object
---@param style number
local function set_style_fairy_small(obj, style)
	obj._wisys:setAction("normal", false, false, 1, 2, 3, 4, 5)
	obj._wisys:setAction("right", false, false, 6, 7)
	obj._wisys:setAction("rightloop", false, false, 8, 9, 10)
	obj._wisys:setAction("left", true, false, 6, 7)
	obj._wisys:setAction("leftloop", true, false, 8, 9, 10)
	obj._wisys:setImages("fairy_small" .. style, 6)
	enemy.changeDeathFunc(obj, stg.defaultSmallDeathBullet.main)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_mid(obj, style)
	obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._wisys:setAction("right", false, false, 5, 6)
	obj._wisys:setAction("rightloop", false, false, 7, 8, 9)
	obj._wisys:setAction("left", true, false, 5, 6)
	obj._wisys:setAction("leftloop", true, false, 7, 8, 9)
	obj._wisys:setImages("fairy_mid" .. style, 6)
	obj._wisys:setScale(1.25, 1.25)
	enemy.changeDeathFunc(obj, stg.defaultMiddleDeathBullet.main)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_large(obj, style)
	obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._wisys:setAction("right", false, false, 5, 6)
	obj._wisys:setAction("rightloop", false, false, 7, 8, 9)
	obj._wisys:setAction("left", true, false, 5, 6)
	obj._wisys:setAction("leftloop", true, false, 7, 8, 9)
	obj._wisys:setImages("fairy_large" .. style, 6)
	obj._wisys:setScale(1.25, 1.25)
	enemy.changeDeathFunc(obj, stg.defaultMiddleDeathBullet.main)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_small_2(obj, style)
	obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._wisys:setAction("right", false, false, 5, 6)
	obj._wisys:setAction("rightloop", false, false, 7, 8, 9, 10)
	obj._wisys:setAction("left", true, false, 5, 6)
	obj._wisys:setAction("leftloop", true, false, 7, 8, 9, 10)
	obj._wisys:setImages("fairy_small_2_" .. style, 6)
	obj._wisys:setScale(1.15, 1.15)
	enemy.changeDeathFunc(obj, stg.defaultSmallDeathBullet.main)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_mid_2(obj, style)
	obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._wisys:setAction("right", false, false, 5, 6)
	obj._wisys:setAction("rightloop", false, false, 7, 8, 9, 10)
	obj._wisys:setAction("left", true, false, 5, 6)
	obj._wisys:setAction("leftloop", true, false, 7, 8, 9, 10)
	obj._wisys:setImages("fairy_mid_2_" .. style, 6)
	obj._wisys:setScale(1.25, 1.25)
	enemy.changeDeathFunc(obj, stg.defaultMiddleDeathBullet.main)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_small_3(obj, style)
	obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._wisys:setAction("right", false, false, 5, 6, 7, 8)
	obj._wisys:setAction("rightloop", false, false, 9, 10, 11, 12)
	obj._wisys:setAction("left", true, false, 5, 6, 7, 8)
	obj._wisys:setAction("leftloop", true, false, 9, 10, 11, 12)
	obj._wisys:setImages("fairy_small_3_" .. style, 6)
	obj._wisys:setScale(1.0, 1.0)
	enemy.changeDeathFunc(obj, stg.defaultSmallDeathBullet.main)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_mid_3(obj, style)
	style = math.clamp(style, 1, 3)
	obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._wisys:setAction("right", false, false, 5, 6)
	obj._wisys:setAction("rightloop", false, false, 7, 8, 9, 10)
	obj._wisys:setAction("left", true, false, 5, 6)
	obj._wisys:setAction("leftloop", true, false, 7, 8, 9, 10)
	obj._wisys:setImages("fairy_mid_3_" .. style, 6)
	obj._wisys:setScale(1.25, 1.25)
	enemy.changeDeathFunc(obj, stg.defaultMiddleDeathBullet.main)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_small_4(obj, style)
	obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._wisys:setAction("right", false, false, 5, 6, 7, 8)
	obj._wisys:setAction("rightloop", false, false, 9, 10, 11, 12)
	obj._wisys:setAction("left", true, false, 5, 6, 7, 8)
	obj._wisys:setAction("leftloop", true, false, 9, 10, 11, 12)
	obj._wisys:setImages("fairy_small_4_" .. style, 6)
	obj._wisys:setScale(1.0, 1.0)
	enemy.changeDeathFunc(obj, stg.defaultSmallDeathBullet.main)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_mid_4(obj, style)
	obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._wisys:setAction("right", false, false, 5, 6, 7, 8)
	obj._wisys:setAction("rightloop", false, false, 9, 10, 11, 12)
	obj._wisys:setAction("left", true, false, 5, 6, 7, 8)
	obj._wisys:setAction("leftloop", true, false, 9, 10, 11, 12)
	obj._wisys:setImages("fairy_mid_4_" .. style, 6)
	obj._wisys:setScale(1.0, 1.0)
	enemy.changeDeathFunc(obj, stg.defaultMiddleDeathBullet.main)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_large_4(obj, style)
	obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._wisys:setAction("right", false, false, 5, 6, 7, 8)
	obj._wisys:setAction("rightloop", false, false, 9, 10, 11, 12)
	obj._wisys:setAction("left", true, false, 5, 6, 7, 8)
	obj._wisys:setAction("leftloop", true, false, 9, 10, 11, 12)
	obj._wisys:setImages("fairy_large_4_" .. style, 6)
	obj._wisys:setScale(1.0, 1.0)
	enemy.changeDeathFunc(obj, stg.defaultMiddleDeathBullet.main)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_small_stroke(obj, style)
	set_style_fairy_small(obj, style)
	obj._stroke_wisys:setAction("normal", false, false, 1, 2, 3, 4, 5)
	obj._stroke_wisys:setAction("right", false, false, 6, 7)
	obj._stroke_wisys:setAction("rightloop", false, false, 8, 9, 10)
	obj._stroke_wisys:setAction("left", true, false, 6, 7)
	obj._stroke_wisys:setAction("leftloop", true, false, 8, 9, 10)
	obj._stroke_wisys:setImages("fairy_small_gold_stroke_", 6)
	enemy.changeDeathFunc(obj, stg.defaultSmallDeathBullet.main)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_mid_stroke(obj, style)
	set_style_fairy_mid(obj, style)
	obj._stroke_wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._stroke_wisys:setAction("right", false, false, 5, 6)
	obj._stroke_wisys:setAction("rightloop", false, false, 7, 8, 9)
	obj._stroke_wisys:setAction("left", true, false, 5, 6)
	obj._stroke_wisys:setAction("leftloop", true, false, 7, 8, 9)
	obj._stroke_wisys:setImages("fairy_mid_gold_stroke_", 6)
	obj._stroke_wisys:setScale(1.25, 1.25)
	enemy.changeDeathFunc(obj, stg.defaultMiddleDeathBullet.main)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_large_stroke(obj, style)
	set_style_fairy_large(obj, style)
	obj._stroke_wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._stroke_wisys:setAction("right", false, false, 5, 6)
	obj._stroke_wisys:setAction("rightloop", false, false, 7, 8, 9)
	obj._stroke_wisys:setAction("left", true, false, 5, 6)
	obj._stroke_wisys:setAction("leftloop", true, false, 7, 8, 9)
	obj._stroke_wisys:setImages("fairy_large_gold_stroke_", 6)
	obj._stroke_wisys:setScale(1.25, 1.25)
	enemy.changeDeathFunc(obj, stg.defaultMiddleDeathBullet.main)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_small_2_stroke(obj, style)
	set_style_fairy_small_2(obj, style)
	obj._stroke_wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._stroke_wisys:setAction("right", false, false, 5, 6)
	obj._stroke_wisys:setAction("rightloop", false, false, 7, 8, 9, 10)
	obj._stroke_wisys:setAction("left", true, false, 5, 6)
	obj._stroke_wisys:setAction("leftloop", true, false, 7, 8, 9, 10)
	obj._stroke_wisys:setImages("fairy_small_2_gold_stroke_", 6)
	obj._stroke_wisys:setScale(1.15, 1.15)
	enemy.changeDeathFunc(obj, stg.defaultSmallDeathBullet.main)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_mid_2_stroke(obj, style)
	set_style_fairy_mid_2(obj, style)
	obj._stroke_wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._stroke_wisys:setAction("right", false, false, 5, 6)
	obj._stroke_wisys:setAction("rightloop", false, false, 7, 8, 9, 10)
	obj._stroke_wisys:setAction("left", true, false, 5, 6)
	obj._stroke_wisys:setAction("leftloop", true, false, 7, 8, 9, 10)
	obj._stroke_wisys:setImages("fairy_mid_2_gold_stroke_", 6)
	obj._stroke_wisys:setScale(1.25, 1.25)
	enemy.changeDeathFunc(obj, stg.defaultMiddleDeathBullet.main)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_small_3_stroke(obj, style)
	set_style_fairy_small_3(obj, style)
	obj._stroke_wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._stroke_wisys:setAction("right", false, false, 5, 6, 7, 8)
	obj._stroke_wisys:setAction("rightloop", false, false, 9, 10, 11, 12)
	obj._stroke_wisys:setAction("left", true, false, 5, 6, 7, 8)
	obj._stroke_wisys:setAction("leftloop", true, false, 9, 10, 11, 12)
	obj._stroke_wisys:setImages("fairy_small_3_gold_stroke_", 6)
	obj._stroke_wisys:setScale(1.0, 1.0)
	enemy.changeDeathFunc(obj, stg.defaultSmallDeathBullet.main)
end

---@param obj enemy.object
---@param style number
local function set_style_fairy_mid_3_stroke(obj, style)
	set_style_fairy_mid_3(obj, style)
	obj._stroke_wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._stroke_wisys:setAction("right", false, false, 5, 6)
	obj._stroke_wisys:setAction("rightloop", false, false, 7, 8, 9, 10)
	obj._stroke_wisys:setAction("left", true, false, 5, 6)
	obj._stroke_wisys:setAction("leftloop", true, false, 7, 8, 9, 10)
	obj._stroke_wisys:setImages("fairy_mid_3_gold_stroke_", 6)
	obj._stroke_wisys:setScale(1.25, 1.25)
	enemy.changeDeathFunc(obj, stg.defaultMiddleDeathBullet.main)
end

--cos蕾米小妖精
local function set_style_fairy_small_5(obj, style)
	obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._wisys:setAction("right", false, false, 5, 6, 7, 8, 9)
	obj._wisys:setAction("rightloop", false, false, 7, 8, 9)
	obj._wisys:setAction("left", true, false, 5, 6, 7, 8, 9)
	obj._wisys:setAction("leftloop", true, false, 7, 8, 9)
	obj._wisys:setImages("fairy_small_5_" .. style, 6)
	enemy.changeDeathFunc(obj, stg.defaultSmallDeathBullet.main)
end


--莉莉白
local function set_style_fairy_LilyWhite(obj)
	obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
	obj._wisys:setAction("right", false, false, 5, 6, 7, 8, 9)
	obj._wisys:setAction("rightloop", false, false, 6, 7, 8, 9)
	obj._wisys:setAction("left", true, false, 5, 6, 7, 8, 9)
	obj._wisys:setAction("leftloop", true, false, 6, 7, 8, 9)
	obj._wisys:setAction("drop_bomb", false, false, 10, 11, 12, 13) --把b丢掉
	obj.dropBomb = function(obj)
		obj._wisys:cast("drop_bomb", 24)
		task.New(obj, function()
			task.Wait(24)
			--切换行走图
			obj._wisys:setAction("normal", false, false, 14, 15, 16, 17)
			obj._wisys:setAction("right", false, false, 18, 19, 20, 21, 22)
			obj._wisys:setAction("rightloop", false, false, 19, 20, 21, 22)
			obj._wisys:setAction("left", true, false, 18, 19, 20, 21, 22)
			obj._wisys:setAction("leftloop", true, false, 19, 20, 21, 22)
		end)
	end
	obj._wisys:setImages("LilyWhite_enemy_", 8)
end


local function set_style_book(obj)
	obj._wisys:setAction("normal", false, false, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
	obj._wisys:setAction("right", false, false, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
	obj._wisys:setAction("rightloop", false, false, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
	obj._wisys:setAction("left", true, false, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
	obj._wisys:setAction("leftloop", true, false, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
	obj._wisys:setAction("open", false, false, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24)
	obj._wisys:setActionLoop("open", 8)
	obj._wisys:setImages("s3_book_img", 4)
	obj.changeNormalState = function()
		obj._wisys:cast("normal")
	end
	obj.changeOpenState = function(t)
		obj._wisys:cast("open", t or _infinite)
	end
	--enemy.changeDeathFunc(obj, stg.defaultSmallDeathBullet.main)
end

--体验版之后的敌人
local set_style_fairy_small_6, set_style_fairy_small_7, set_style_BigDevil, set_style_enemy_Gluttony, set_style_fairy_Reimu, set_style_fairy_Marisa, set_style_fairy_Sakuya
if not config.preview_version then
	--小女仆妖精1
	function set_style_fairy_small_6(obj, style)
		obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
		obj._wisys:setAction("right", false, false, 5, 6, 7, 8, 9)
		obj._wisys:setAction("rightloop", false, false, 7, 8, 9)
		obj._wisys:setAction("left", true, false, 5, 6, 7, 8, 9)
		obj._wisys:setAction("leftloop", true, false, 7, 8, 9)
		obj._wisys:setImages("fairy_small_6_" .. style, 6)
		enemy.changeDeathFunc(obj, stg.defaultSmallDeathBullet.main)
	end
	--小女仆妖精2
	function set_style_fairy_small_7(obj, style)
		obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
		obj._wisys:setAction("right", false, false, 5, 6, 7, 8, 9)
		obj._wisys:setAction("rightloop", false, false, 7, 8, 9)
		obj._wisys:setAction("left", true, false, 5, 6, 7, 8, 9)
		obj._wisys:setAction("leftloop", true, false, 7, 8, 9)
		obj._wisys:setImages("fairy_small_7_" .. style, 6)
		enemy.changeDeathFunc(obj, stg.defaultSmallDeathBullet.main)
	end
	--大恶魔
	function set_style_BigDevil(obj, style)
		obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
		obj._wisys:setAction("right", false, false, 5, 6, 7, 8, 9, 10)
		obj._wisys:setAction("rightloop", false, false, 7, 8, 9, 10)
		obj._wisys:setAction("left", true, false, 5, 6, 7, 8, 9, 10)
		obj._wisys:setAction("leftloop", true, false, 7, 8, 9, 10)
		local img = "BigDevil_Red_"
		if style == 2 then
			img = "BigDevil_Blue_"
		end
		obj._wisys:setImages(img, 8)
	end
	--非boss单位的猫
	function set_style_enemy_Gluttony(obj)
		obj._wisys:setAction("normal", false, false, 1, 2, 3, 4, 5, 6, 7)
		obj._wisys:setAction("right", false, false, 11, 12, 13, 14)
		obj._wisys:setAction("rightloop", false, false, 13, 14)
		obj._wisys:setAction("left", true, false, 11, 12, 13, 14)
		obj._wisys:setAction("leftloop", true, false, 13, 14)
		obj._wisys:setImages("Gluttony_enemy_", 8)
	end
	--cos灵梦的妖精
	function set_style_fairy_Reimu(obj)
		obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
		obj._wisys:setAction("right", false, false, 5, 6, 7, 8, 9)
		obj._wisys:setAction("rightloop", false, false, 7, 8, 9)
		obj._wisys:setAction("left", true, false, 5, 6, 7, 8, 9)
		obj._wisys:setAction("leftloop", true, false, 7, 8, 9)
		obj._wisys:setImages("fairy_Reimu", 6)
		enemy.changeDeathFunc(obj, stg.defaultSmallDeathBullet.main)
	end
	--cos魔理沙的妖精
	function set_style_fairy_Marisa(obj)
		obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
		obj._wisys:setAction("right", false, false, 5, 6, 7, 8, 9)
		obj._wisys:setAction("rightloop", false, false, 7, 8, 9)
		obj._wisys:setAction("left", true, false, 5, 6, 7, 8, 9)
		obj._wisys:setAction("leftloop", true, false, 7, 8, 9)
		obj._wisys:setImages("fairy_Marisa", 6)
		enemy.changeDeathFunc(obj, stg.defaultSmallDeathBullet.main)
	end
	--cos咲夜的妖精
	function set_style_fairy_Sakuya(obj)
		obj._wisys:setAction("normal", false, false, 1, 2, 3, 4)
		obj._wisys:setAction("right", false, false, 5, 6, 7, 8, 9)
		obj._wisys:setAction("rightloop", false, false, 7, 8, 9)
		obj._wisys:setAction("left", true, false, 5, 6, 7, 8, 9)
		obj._wisys:setAction("leftloop", true, false, 7, 8, 9)
		obj._wisys:setImages("fairy_Sakuya", 6)
		enemy.changeDeathFunc(obj, stg.defaultSmallDeathBullet.main)
	end
end


----------------------------------------
---style manager

---@class EISlib.Enemy.StyleManager : etc.class
local stylemgr = etc.class(false, false)

---@type number[]
local death_color_index = {
	--小妖精
	1, 3, 5, 8,
	--中妖精
	9, 11, 13, 16,
	--大妖精
	17, 19, 21, 24,
	--毛玉
	1, 3, 5, 8,
	--魔法阵鬼火
	3, 2, 5, 3,
	7, 8, 4, 1,
	--仙界小妖精
	1, 3, 5, 7,
	--仙界中妖精
	9, 11, 13, 15,
	--阴阳玉
	1, 6, 3, 5, 8, 2, 7, 7,
	--外界小妖精
	1, 3, 5, 2,
	--外界中妖精
	9, 11, 13, 13,
	-- 49 ~ 60
	1, 1,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	--小妖精（金色描边）
	1, 3, 5, 8,
	--中妖精（金色描边）
	9, 11, 13, 16,
	--大妖精（金色描边）
	17, 19, 21, 24,
	--仙界小妖精（金色描边）
	1, 3, 5, 7,
	--仙界中妖精（金色描边）
	9, 11, 13, 15,
	--外界小妖精（金色描边）
	1, 3, 5, 2,
	--外界中妖精（金色描边）
	9, 11, 13, 13,
	--xhg小妖精
	1, 3, 2, 5, 7, 2,
	--xhg中妖精
	16, 10,
	--xhg大妖精
	19, 17, 18,
	--cos蕾米小妖精
	7, 3, 5, 7, --最后一个是拿伞的
	--为什么要伤害莉莉白？
	7,
	--二面的小怪
	5, 7,
	--书本
	1,
	--小女仆妖精1
	1, 2, 7,
	--小女仆妖精2
	3, 2, 6, 5,
	--大恶魔
	17, 19,
	--血灵碎片（敌机）
	9,
	--非boss的猫
	1,
	--cos三主角的妖精
	1, 8, 3
}

--每一种敌人的更新函数
---@param self table @stylemgr对象
local UPDATE_FUNC = {
	--常见的几种妖精(使用dnh行走图逻辑)
	FAIRY = function(self)
		local obj = self.obj
		obj._wisys:update()
		obj._wisys:setAlpha(self.alpha)
	end,
	--金边妖精
	STROKE_FAIRY = function(self)
		local obj = self.obj
		obj._stroke_wisys:update()
		obj._stroke_wisys:setAlpha(self.alpha)
	end,
	--毛玉
	FAIRY_BALL = function()

	end,
	--鬼火
	GHOST_FIRE = function()

	end,
	--阴阳玉
	TAICHI = function()

	end,
	--血灵碎片
	CHIP = function()

	end
}
--每一种敌人的绘制函数
---@param obj table @enemy对象
---@param color table @COLOR
local DRAW_FUNC = {
	--常见的几种妖精(使用dnh行走图逻辑)
	FAIRY = function(obj, color)
		obj._wisys:drawWithColor(color)
	end,
	--金边妖精
	STROKE_FAIRY = function(obj, color)
		--描边特效
		obj._stroke_wisys:draw()
		--普通妖精渲染
		obj._wisys:drawWithColor(color)
	end,
	--毛玉
	FAIRY_BALL = function(obj, color)
		local _style = obj._stylemgr:getStyle()
		local scale = 0.8
		local index = { 1, 6, 4, 8 }
		local img = "magic" .. index[_style - 12]
		local blend = obj._blend or ""
		if blend then
			SetImageState(img, obj._blend, Color(obj._a, obj._r, obj._g, obj._b))
			Render(img, obj.x, obj.y, obj.ani * 2, scale * obj.hscale, scale * obj.vscale)
			SetImageState(img, "", COLOR_WHITE)
		else
			Render(img, obj.x, obj.y, obj.ani * 2, scale * obj.hscale, scale * obj.vscale)
		end
		img = "fairy_ball" .. (_style - 12)
		--渲染自己
		SetImageState(img, blend, color)
		Render(img, obj.x, obj.y, -obj.ani * 4, 0.54 * obj.hscale, 0.54 * obj.vscale)
	end,
	--鬼火
	GHOST_FIRE = function(obj, color)
		--鬼火
		local ani = ""
		local _style = obj._stylemgr:getStyle()
		local blend = obj._blend or ""

		ani = "ghost_fire" .. (_style - 16)

		if obj.show_aura then --显示结界圈的选项
			local scale = 0.5
			local index = { 1, 5, 9, 15, 3, 3, 13, 7 }
			local img = "magic" .. index[_style - 16] --带法阵的
			if obj._blend then
				SetImageState(img, obj._blend, Color(obj._a, obj._r, obj._g, obj._b))
				Render(img, obj.x, obj.y, obj.ani * 2, scale * obj.hscale, scale * obj.vscale)
				SetImageState(img, "", COLOR_WHITE)
			else
				Render(img, obj.x, obj.y, obj.ani * 2, scale * obj.hscale, scale * obj.vscale)
			end
		end

		local scale = 1
		SetAnimationState(ani, blend, color)
		if RenderAnimation then
			RenderAnimation(ani, obj.ani, obj.x, obj.y, obj.rot, scale * obj.hscale, scale * obj.vscale)
		else
			local lastimg = obj.img
			obj.img = ani
			obj.hscale = obj.hscale * scale
			obj.hscale = obj.vscale * scale
			DefaultRenderFunc(obj)
			obj.img = lastimg
			obj.hscale = obj.hscale / scale
			obj.vscale = obj.vscale / scale
		end
	end,
	--阴阳玉
	TAICHI = function(obj, color)
		local _style = obj._stylemgr:getStyle()
		local blend = obj._blend or ""
		local index = (min(_style - 32, 7))
		local magic_img = "fairy_aura_magic" .. index --只有7种
		local img = "fairy_aura" .. index
		local scale1, scale = 0.75, 1
		if obj._blend then
			SetImageState(magic_img, obj._blend, Color(obj._a, obj._r, obj._g, obj._b))
			for i = 1, 5 do
				Render(magic_img, obj.x, obj.y, 72*i + obj.rot, scale1 * obj.hscale, scale1 * obj.vscale)
			end
			SetImageState(magic_img, "", COLOR_WHITE)
		else
			for i = 1, 5 do
				Render(magic_img, obj.x, obj.y, 72*i + obj.rot, scale1 * obj.hscale, scale1 * obj.vscale)
			end
		end
		SetImageState(img, blend, color)
		Render(img, obj.x, obj.y, 90, scale * obj.hscale, scale * obj.vscale)
	end,
	--血灵碎片
	CHIP = function(obj, color)
		local img = "enemy_mid_chip"
		local blend = obj._blend or ""
		--渲染自己
		SetImageState(img, blend, color)
		Render(img, obj.x, obj.y, obj.rot, obj.hscale, obj.vscale)
	end
}

--region stylemgr 类的构造、更新、渲染 （实际在enemy对象里执行）
---@param obj enemy.object
---@return EISlib.Enemy.StyleManager
function stylemgr:constructor(obj, style)
	self.obj = obj
	self.init = false
	self.alpha = 1
	obj._style = -1 --敌人种类初始化
	self.updateFunc = nil --更新状态的函数，由setStyle设置，被update调用
	self.drawFunc = nil --绘制贴图的函数，由setStyle设置，被draw调用
	obj._wisys = wisys.new():constructor(obj)
	obj._stroke_wisys = wisys.new():constructor(obj)
	stylemgr.setStyle(self, style) --这个函数执行的时候已经给上面的 self.drawFunc 赋值了
	return self
end

function stylemgr:update()
	self:updateFunc() --调用对应种类敌人的更新函数
end

function stylemgr:draw()
	local obj = self.obj
	local color = hitFlashBlue(obj) --闪蓝的Color值
	self.drawFunc(obj, color) --调用渲染对应种类敌人的函数
end
--endregion

--region stylemgr 类的set方法和get方法
---@param style number @每种类型每种颜色的妖精的唯一编号常量
function stylemgr:setStyle(style)
	local obj = self.obj
	if stylemgr.getStyle(self) == style then
		return
	end
	obj._style = style
	obj._death_color = death_color_index[style] or 1
	-- 行走图、碰撞判定大小
	if inrange(style, 1, 4) then
		--小妖精
		set_style_fairy_small(obj, style)
		self.updateFunc = UPDATE_FUNC.FAIRY
		self.drawFunc = DRAW_FUNC.FAIRY
		obj.a, obj.b = 16, 16
	elseif inrange(style, 5, 8) then
		--中妖精
		set_style_fairy_mid(obj, style - 4)
		self.updateFunc = UPDATE_FUNC.FAIRY
		self.drawFunc = DRAW_FUNC.FAIRY
		obj.a, obj.b = 32, 32
	elseif inrange(style, 9, 12) then
		--大妖精
		set_style_fairy_large(obj, style - 8)
		self.updateFunc = UPDATE_FUNC.FAIRY
		self.drawFunc = DRAW_FUNC.FAIRY
		obj.a, obj.b = 32, 32
	elseif inrange(style, 13, 16) then
		--毛玉
		enemy.changeDeathFunc(self, stg.defaultSmallDeathBullet.main)
		self.updateFunc = UPDATE_FUNC.FAIRY_BALL
		self.drawFunc = DRAW_FUNC.FAIRY_BALL
		obj.a, obj.b = 16, 16
	elseif inrange(style, 17, 24) then
		--鬼火
		enemy.changeDeathFunc(self, stg.defaultSmallDeathBullet.main)
		self.show_aura = true --默认是显示结界圈的（暂时不考虑结界圈从无到有
		self.updateFunc = UPDATE_FUNC.GHOST_FIRE
		self.drawFunc = DRAW_FUNC.GHOST_FIRE
		obj.a, obj.b = 16, 16
	elseif inrange(style, 25, 28) then
		--4面小妖精
		set_style_fairy_small_2(obj, style - 24)
		self.updateFunc = UPDATE_FUNC.FAIRY
		self.drawFunc = DRAW_FUNC.FAIRY
		obj.a, obj.b = 16, 16
	elseif inrange(style, 29, 32) then
		--4面中妖精
		set_style_fairy_mid_2(obj, style - 28)
		self.updateFunc = UPDATE_FUNC.FAIRY
		self.drawFunc = DRAW_FUNC.FAIRY
		obj.a, obj.b = 32, 32
	elseif inrange(style, 33, 40) then
		--阴阳玉
		enemy.changeDeathFunc(self, stg.defaultSmallDeathBullet.main)
		self.updateFunc = UPDATE_FUNC.TAICHI
		self.drawFunc = DRAW_FUNC.TAICHI
		obj.omiga = 6
		obj.a, obj.b = 16, 16
	elseif inrange(style, 41, 44) then
		--ex面小妖精
		set_style_fairy_small_3(obj, style - 40)
		self.updateFunc = UPDATE_FUNC.FAIRY
		self.drawFunc = DRAW_FUNC.FAIRY
		obj.a, obj.b = 16, 16
	elseif inrange(style, 45, 48) then
		--ex面中妖精
		set_style_fairy_mid_3(obj, style - 44)
		self.updateFunc = UPDATE_FUNC.FAIRY
		self.drawFunc = DRAW_FUNC.FAIRY
		obj.a, obj.b = 32, 32
	elseif inrange(style, 61, 64) then
		--小妖精（描边特效）
		set_style_fairy_small_stroke(obj, style - 60)
		self.updateFunc = UPDATE_FUNC.STROKE_FAIRY
		self.drawFunc = DRAW_FUNC.STROKE_FAIRY
		obj.a, obj.b = 16, 16
	elseif inrange(style, 65, 68) then
		--中妖精（描边特效）
		set_style_fairy_mid_stroke(obj, style - 64)
		self.updateFunc = UPDATE_FUNC.STROKE_FAIRY
		self.drawFunc = DRAW_FUNC.STROKE_FAIRY
		obj.a, obj.b = 32, 32
	elseif inrange(style, 69, 72) then
		--大妖精（描边特效）
		set_style_fairy_large_stroke(obj, style - 68)
		self.updateFunc = UPDATE_FUNC.STROKE_FAIRY
		self.drawFunc = DRAW_FUNC.STROKE_FAIRY
		obj.a, obj.b = 32, 32
	elseif inrange(style, 73, 76) then
		--4面小妖精（描边特效）
		set_style_fairy_small_2_stroke(obj, style - 72)
		self.updateFunc = UPDATE_FUNC.STROKE_FAIRY
		self.drawFunc = DRAW_FUNC.STROKE_FAIRY
		obj.a, obj.b = 16, 16
	elseif inrange(style, 77, 80) then
		--4面中妖精（描边特效）
		set_style_fairy_mid_2_stroke(obj, style - 76)
		self.updateFunc = UPDATE_FUNC.STROKE_FAIRY
		self.drawFunc = DRAW_FUNC.STROKE_FAIRY
		obj.a, obj.b = 32, 32
	elseif inrange(style, 81, 84) then
		--ex面小妖精（描边特效）
		set_style_fairy_small_3_stroke(obj, style - 80)
		self.updateFunc = UPDATE_FUNC.STROKE_FAIRY
		self.drawFunc = DRAW_FUNC.STROKE_FAIRY
		obj.a, obj.b = 16, 16
	elseif inrange(style, 85, 88) then
		--ex面中妖精（描边特效）
		set_style_fairy_mid_3_stroke(obj, style - 84)
		self.updateFunc = UPDATE_FUNC.STROKE_FAIRY
		self.drawFunc = DRAW_FUNC.STROKE_FAIRY
		obj.a, obj.b = 32, 32
	elseif inrange(style, 89, 94) then
		--xhg小妖精
		set_style_fairy_small_4(obj, style - 88)
		self.updateFunc = UPDATE_FUNC.FAIRY
		self.drawFunc = DRAW_FUNC.FAIRY
		obj.a, obj.b = 16, 16
	elseif inrange(style, 95, 96) then
		--xhg中妖精
		set_style_fairy_mid_4(obj, style - 94)
		self.updateFunc = UPDATE_FUNC.FAIRY
		self.drawFunc = DRAW_FUNC.FAIRY
		obj.a, obj.b = 32, 32
	elseif inrange(style, 97, 99) then
		--xhg大妖精
		set_style_fairy_large_4(obj, style - 96)
		self.updateFunc = UPDATE_FUNC.FAIRY
		self.drawFunc = DRAW_FUNC.FAIRY
		obj.a, obj.b = 32, 32
	elseif inrange(style, 100, 103) then --cos蕾米妖精
		if style == 103 then --拿伞妖精
			self.updateFunc = function() end
			self.drawFunc = function(obj, color)
				local blend = obj._blend or ""
				SetAnimationState("fairy_small_5_sp", blend, color)
				RenderAnimation("fairy_small_5_sp", obj.ani, obj.x, obj.y, obj.rot, obj.hscale, obj.vscale)
			end
		else
			set_style_fairy_small_5(obj, style - 99)
			self.updateFunc = UPDATE_FUNC.FAIRY
			self.drawFunc = DRAW_FUNC.FAIRY
		end
		obj.a, obj.b = 16, 16
	elseif style == 104 then --莉莉白
		set_style_fairy_LilyWhite(obj)
		self.updateFunc = UPDATE_FUNC.FAIRY
		self.drawFunc = DRAW_FUNC.FAIRY
		obj.a, obj.b = 16, 16
	elseif inrange(style, 105, 106) then --兔子
		--调整朝向
		self.updateFunc = function(self)
			local obj = self.obj
			if obj.dx > 0 then
				obj.opposite = -1
			elseif obj.dx < 0 then
				obj.opposite = 1
			else
				obj.opposite = obj.opposite or 1
			end
		end
		self.drawFunc = function(obj, color)
			obj.opposite = obj.opposite or 1
			local img = "rabbit_enemy_"..(style - 104)
			local blend = obj._blend or ""
			SetAnimationState(img, blend, color)
			RenderAnimation(img, obj.ani, obj.x, obj.y, obj.rot, obj.opposite*obj.hscale, obj.vscale)
		end
		obj.a, obj.b = 16, 16
	elseif style == 107 then --三boss的书本
		set_style_book(obj)
		self.updateFunc = UPDATE_FUNC.FAIRY
		self.drawFunc = DRAW_FUNC.FAIRY
		obj.a, obj.b = 16, 16
	elseif inrange(style, 108, 110) then --小女仆妖精1
		set_style_fairy_small_6(obj, style - 107)
		self.updateFunc = UPDATE_FUNC.FAIRY
		self.drawFunc = DRAW_FUNC.FAIRY
		obj.a, obj.b = 16, 16
	elseif inrange(style, 111, 114) then --小女仆妖精2
		set_style_fairy_small_7(obj, style - 110)
		self.updateFunc = UPDATE_FUNC.FAIRY
		self.drawFunc = DRAW_FUNC.FAIRY
		obj.a, obj.b = 16, 16
	elseif inrange(style, 115, 116) then --大恶魔
		set_style_BigDevil(obj, style - 114)
		self.updateFunc = UPDATE_FUNC.FAIRY
		self.drawFunc = DRAW_FUNC.FAIRY
		obj.a, obj.b = 32, 32
	elseif style == 117 then --血灵碎片（敌机）
		enemy.changeDeathFunc(self, stg.defaultSmallDeathBullet.main)
		self.updateFunc = UPDATE_FUNC.CHIP
		self.drawFunc = DRAW_FUNC.CHIP
		obj.a, obj.b = 16, 16
	elseif style == 118 then --非boss的猫
		set_style_enemy_Gluttony(obj)
		self.updateFunc = UPDATE_FUNC.FAIRY
		self.drawFunc = DRAW_FUNC.FAIRY
		obj.a, obj.b = 16, 16
	elseif style == 119 then --cos灵梦的妖精
		set_style_fairy_Reimu(obj)
		self.updateFunc = UPDATE_FUNC.FAIRY
		self.drawFunc = DRAW_FUNC.FAIRY
		obj.a, obj.b = 16, 16
	elseif style == 120 then --cos魔理沙的妖精
		set_style_fairy_Marisa(obj)
		self.updateFunc = UPDATE_FUNC.FAIRY
		self.drawFunc = DRAW_FUNC.FAIRY
		obj.a, obj.b = 16, 16
	elseif style == 121 then --cos咲夜的妖精
		set_style_fairy_Sakuya(obj)
		self.updateFunc = UPDATE_FUNC.FAIRY
		self.drawFunc = DRAW_FUNC.FAIRY
		obj.a, obj.b = 16, 16
	else
		error("Unknown enemy style.", 2)
	end
end

---@return number
function stylemgr:getStyle()
	local obj = self.obj
	return obj._style or 1
end

---@param a number @default to 1
function stylemgr:setAlpha(a)
	a = a or 0
	self.alpha = a
end
--endregion

----------------------------------------
---out

return stylemgr
