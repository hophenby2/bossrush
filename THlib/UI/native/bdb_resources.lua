---=====================================
--- Xiliusha
--- 游戏内UI，资源集合
---=====================================

---@class ui.game
local M = ui.game or {}
ui.game = M

----------------------------------------
--- 只在游戏场景内创建的资源集，用于绘制游戏UI

local path = "res/ui/"
local _ui_tex_1 = "_tex_ui_item_1"
local _ui_tex_3 = "_tex_ui_item_16_9_3"

local __tag = "stage"
if EISlib.ui.PRELOAD then
    __tag = "global"
end

local res = lstg.ResourceSet.create("ui.game", __tag)
M.resource_set = res

--region 背景 版面框架 数字字体

local _ui_game_texture1 = "ui.game.texture1"
res:addTexture(_ui_game_texture1, path .. "ui_game_1.png", false)

-- 背景
res:addSprite("ui.game.background1", _ui_game_texture1, 0,    0, 2048, 1440)
res:addSprite("ui.game.background2", _ui_game_texture1, 0, 1536, 1440,  512)
res:setSpriteCenter("ui.game.background1", 2048, 0)
res:setSpriteCenter("ui.game.background2",    0, 0)

-- 版面框架
res:addSprite("ui.game.frame1", _ui_game_texture1, 1456, 1552, 48, 48)
res:addSprite("ui.game.frame2", _ui_game_texture1, 1504, 1552, 64, 48)
res:addSprite("ui.game.frame3", _ui_game_texture1, 1568, 1552, 48, 48)
res:addSprite("ui.game.frame4", _ui_game_texture1, 1456, 1600, 48, 64)
res:addSprite("ui.game.frame5", _ui_game_texture1, 1512, 1608, 48, 48) -- 防止边缘出现红色
res:addSprite("ui.game.frame6", _ui_game_texture1, 1568, 1600, 48, 64)
res:addSprite("ui.game.frame7", _ui_game_texture1, 1456, 1664, 48, 48)
res:addSprite("ui.game.frame8", _ui_game_texture1, 1504, 1664, 64, 48)
res:addSprite("ui.game.frame9", _ui_game_texture1, 1568, 1664, 48, 48)

-- 版面框架九宫格
M.frame1 = ui.Sprite9Define("ui.game.frame", {
    { 48, 48 }, -- 1
    { 64, 48 }, -- 2
    { 48, 48 }, -- 3
    { 48, 64 }, -- 4
    { 64, 64 }, -- 5，这里写的虽然是64，但是实际上是48x48
    { 48, 64 }, -- 6
    { 48, 48 }, -- 7
    { 64, 48 }, -- 8
    { 48, 48 }, -- 9
})

-- 数字字体
local _ui_game_font1_char = {
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    ",", ".", "%", "/", "+", "-", "x", ";", "=",
}
for i, c in ipairs(_ui_game_font1_char) do
    res:addSprite("ui.game.font1[" .. c .. "]", _ui_game_texture1,
            (i - 1) * 48, 1442,
            48, 80)
end

-- 数字字体定义
M.font1 = ui.SpriteFontDefine({
    ["0"] = { "ui.game.font1[0]", 16, 16,  true },
    ["1"] = { "ui.game.font1[1]", 16, 16,  true },
    ["2"] = { "ui.game.font1[2]", 16, 16,  true },
    ["3"] = { "ui.game.font1[3]", 16, 16,  true },
    ["4"] = { "ui.game.font1[4]", 16, 16,  true },
    ["5"] = { "ui.game.font1[5]", 16, 16,  true },
    ["6"] = { "ui.game.font1[6]", 16, 16,  true },
    ["7"] = { "ui.game.font1[7]", 16, 16,  true },
    ["8"] = { "ui.game.font1[8]", 16, 16,  true },
    ["9"] = { "ui.game.font1[9]", 16, 16,  true },
    [","] = { "ui.game.font1[,]", 16,  0,  true },
    ["."] = { "ui.game.font1[.]", 14,  0,  true },
    ["%"] = { "ui.game.font1[%]", 22, 22,  true },
    ["/"] = { "ui.game.font1[/]", 12, 12,  true },
    ["+"] = { "ui.game.font1[+]", 15, 15,  true },
    ["-"] = { "ui.game.font1[-]", 15, 15,  true },
    ["x"] = { "ui.game.font1[x]", 15, 15,  true },
    [";"] = { "ui.game.font1[;]", 15, 15,  true },
    ["="] = { "ui.game.font1[=]", 15, 15,  true },
    [" "] = { ""                , 16, 16, false },
})

--endregion

--region 游戏图标

local _ui_game_texture2 = "ui.game.texture2"
res:addTexture(_ui_game_texture2, path .. "ui_game_2.png", false)

-- 竖着的图标
res:addSprite("ui.game.logo.large1", _ui_game_texture2,   0, 0, 721, 720)
res:addSprite("ui.game.logo.large2", _ui_game_texture2, 722, 0, 721, 720)
res:setSpriteCenter("ui.game.logo.large1", 360, 720)
res:setSpriteCenter("ui.game.logo.large2", 360,   0)
-- 横着的图标
res:addSprite("ui.game.logo.small", _ui_game_texture2, 0, 1398, 1947, 649)

--endregion

--region 第二部分 界面元素
res:addTexture(_ui_tex_3, path .. "ui_item_16_9_3.png", false)
-- 难度/关卡组
for idx = 1, 6 do
    res:addSprite("_ui_16_9_rank" .. idx, _ui_tex_3, 1, 0 + (idx - 1) * 140, 400, 138)
end
-- 一些标识游戏模式的图标
res:addSprite("ui.game.gamemode.practice", _ui_tex_3, 400, 0, 140, 140)
res:addSprite("ui.game.gamemode.replay", _ui_tex_3, 400, 140, 140, 140)
-- 结算
res:addSpriteSequence({
    "ui.popup.background",
    "ui.popup.getspellcard.bonus.gold",
    "ui.popup.clearbullet.bonus",
}, _ui_tex_3, 1278, 871, 770, 108, 1, 3)
res:addSpriteSequence({
    "ui.popup.getspellcard.bonus",
    "_ui_hint_next_stage",
    "ui.popup.losespellcard.bonus",
    "_ui_hint_high_score",
    "_ui_hint_high_extend",
}, _ui_tex_3, 1278, 1408, 770, 107, 1, 5)
-- 符卡时间
res:addSpriteSequence("_ui_hint_boss_card_time", _ui_tex_3, 1530, 1292, 192, 50, 2, 1)
--endregion

--region 第三部分 界面元素、系统槽

res:addTexture(_ui_tex_1, path .. "ui_item_1.png", false)

-- 系统碎片槽底衬
res:addSprite("ui.systemchip.bg", _ui_tex_1, 0, 0, 220, 220)
-- 系统碎片
res:addSpriteSequence("ui.systemchip.v", _ui_tex_1, 220, 0, 220, 220, 6, 1)
-- 系统碎片槽满
res:addSprite("ui.systemchip.top", _ui_tex_1, 0, 220, 220, 220)

-- Hyper时碎片槽
res:addSpriteSequence({
    "ui.hyperchip.bg",
    "ui.hyperchip.chip",
    "ui.hyperchip.v1",
    "ui.hyperchip.v2",
    "ui.hyperchip.v3",
    "ui.hyperchip.v4",
    "ui.hyperchip.v5",
    "ui.hyperchip.v6",
    "ui.hyperchip.ef1",
    "ui.hyperchip.ef3",
    "ui.hyperchip.ef2",
    "ui.hyperchip.ef4",
}, _ui_tex_1, 0, 880, 154, 175, 6, 2)

-- 系统碎片槽闪光特效
res:addSpriteSequence("ui.systemchip.effect.full.", _ui_tex_1, 220, 220, 220, 220, 6, 1)
-- 系统碎片破坏特效
res:addSpriteSequence("ui.systemchip.effect.broken.", _ui_tex_1, 0, 440, 220, 220, 7, 2)
res:setSpriteSequenceState("ui.systemchip.effect.broken.", 7, 2, "mul+add", lstg.Color(255, 255, 255, 255))

-- 碎片栏火焰特效
res:addSpriteSequence("ui.systemchip.effect.fire.", _ui_tex_1, 1542, 180, 46, 60, 6, 1)
res:setSpriteSequenceCenter("ui.systemchip.effect.fire.", 6, 1, 22, 41) -- 23, 14 ?
res:setSpriteSequenceState("ui.systemchip.effect.fire.", 6, 1, "mul+add", lstg.Color(80, 255, 255, 255))

-- 自机HUD托盘
res:addSprite("ui.systembar.tray", _ui_tex_1, 1800, 0, 90, 28)
res:setSpriteCenter("ui.systembar.tray", 85, 5)
-- 自机HUD节点
res:addSpriteSequence("ui.systembar.node.", _ui_tex_1, 1542, 0, 9, 16, 5, 1)

--endregion

--region 雷、残，收点线，Boss战界面，系统信息

local _ui_game_texture3 = "ui.game.texture3"
res:addTexture(_ui_game_texture3, path .. "ui_game_3.png", false)

-- 底端血条
res:addSprite("ui.game.enemy.hpbar.bottom.bg", _ui_game_texture3, 0, 330, 1150, 12)

-- 底端血条定义
M.hp_bar_red = ui.ProgressBarDefine(
        "ui.game.enemy.hpbar.bottom.bg", "img_void", _ui_game_texture3,
        0 + 2, 342 + 2, 1150 - 4, 12 - 4)
M.hp_bar_green = ui.ProgressBarDefine(
        "ui.game.enemy.hpbar.bottom.bg", "img_void", _ui_game_texture3,
        0 + 2, 354 + 2, 1150 - 4, 12 - 4)
M.hp_bar_blue = ui.ProgressBarDefine(
        "ui.game.enemy.hpbar.bottom.bg", "img_void", _ui_game_texture3,
        0 + 2, 366 + 2, 1150 - 4, 12 - 4)
M.hp_bar_gray = ui.ProgressBarDefine(
        "ui.game.enemy.hpbar.bottom.bg", "img_void", _ui_game_texture3,
        0 + 2, 378 + 2, 1150 - 4, 12 - 4)

-- boss血条
res:addSprite("ui.game.boss.hpbar.top", _ui_game_texture3, 0, 0, 1154, 54)
res:addSprite("ui.game.boss.hpbar.bottom", _ui_game_texture3, 0, 275, 1154, 54)

-- boss血条定义
M.boss_hp_bar_red = ui.ProgressBarDefine(
        "img_void", "img_void", _ui_game_texture3,
        0, 110, 1154, 54)
M.boss_hp_bar_green = ui.ProgressBarDefine(
        "img_void", "img_void", _ui_game_texture3,
        0, 165, 1154, 54)
M.boss_hp_bar_blue = ui.ProgressBarDefine(
        "img_void", "img_void", _ui_game_texture3,
        0, 55, 1154, 54)
M.boss_hp_bar_gray = ui.ProgressBarDefine(
        "img_void", "img_void", _ui_game_texture3,
        0, 220, 1154, 54)
M.boss_hp_bar_white = ui.ProgressBarDefine(
    "img_void", "img_void", _ui_game_texture3,
    894, 1192, 1154, 54)

-- 符卡名底衬
local __cardname_bg_names = {
    "ui.game.boss.cardname.bg.blue",
    "ui.game.boss.cardname.bg.red",
    "ui.game.boss.cardname.bg.green",
    "ui.game.boss.cardname.bg.gray",
}
res:addSpriteSequence(__cardname_bg_names, _ui_game_texture3, 0, 390, 712, 76, 1, 4)
res:setSpriteSequenceCenter(__cardname_bg_names, 1, 4, 666, 60) -- 我随便选的

-- 收点线显示
res:addSprite("ui.game.item_collect_line.text", _ui_game_texture3, 0, 694, 770, 50)
res:setSpriteCenter("ui.game.item_collect_line.text", 770 / 2, 49)
res:addSprite("ui.game.item_collect_line", _ui_game_texture3, 0, 744, 770, 16)

-- 碎片槽
res:addSprite("ui.game.powerchipbar.bg", _ui_game_texture3, 316, 760, 436, 16)

-- 碎片槽定义
M.power_chip_bar = ui.ProgressBarDefine(
        "ui.game.powerchipbar.bg", "img_void", _ui_game_texture3,
        316 + 6, 776 + 1, 436 - 12, 12 - 2)

-- 系统信息板 [蓝点数、火力道具数、消弹数、擦弹数]
res:addSpriteSequence("ui.game.system.value.small", _ui_game_texture3, 0, 760, 316, 60, 1, 4)
res:setSpriteSequenceCenter("ui.game.system.value.small", 1, 4, 28, 29)

-- 系统信息板 [最高得分，当前得分，残机，符卡，最大得点，连击数，火力等级]
res:addSpriteSequence("ui.game.system.value", _ui_game_texture3, 0, 1024, 564, 88, 1, 7)
res:setSpriteSequenceCenter("ui.game.system.value", 1, 7, 17, 58)

-- hyper槽
res:addSpriteSequence({
    "ui.game.system.hyperbar.bg",
    "ui.game.system.hyperbar.__",
    "ui.game.system.hyperbar.enable",
    "ui.game.system.hyperbar.ready",
}, _ui_game_texture3, 0, 1642, 650, 70, 1, 4)

-- hyper槽定义
M.hyper_bar = ui.ProgressBarDefine(
        "ui.game.system.hyperbar.bg", "img_void", _ui_game_texture3,
        0 + 4, 1712 + 4, 650 - 8, 70 - 8) -- 642, 62

-- hyper槽粒子
res:addSprite("ui.game.system.hyperbar.par", _ui_game_texture3, 712, 535, 24, 24)
-- hyper槽火焰特效定义
---@type ui.ProgressBarDefine[]
local _hyperbar_effects = {}
M.hyper_bar_effects = _hyperbar_effects
for i = 0, 9 do
    _hyperbar_effects[i + 1] = ui.ProgressBarDefine(
            "img_void", "img_void", _ui_game_texture3,
            832 + 1, 1248 + i * 80 + 9,
            608 - 2, 80 - 18)
    _hyperbar_effects[10 + i + 1] = ui.ProgressBarDefine(
            "img_void", "img_void", _ui_game_texture3,
            1440 + 1, 1248 + i * 80 + 9,
            608 - 2, 80 - 18)
end

-- 火力等级值（贴图右上角）
res:addSpriteSequence({
    "ui.game.system.powerrank.value.bg",
    "ui.game.system.powerrank.value.ef1",
    "ui.game.system.powerrank.value.ef2",
    "ui.game.system.powerrank.value.ef3",
    "ui.game.system.powerrank.value.ef4",
    "ui.game.system.powerrank.value.ef5",
    "ui.game.system.powerrank.value.ef6",
    "ui.game.system.powerrank.value.ef7",
    "ui.game.system.powerrank.value.ef8",
    "ui.game.system.powerrank.value.ef9",
    "ui.game.system.powerrank.value.ef10",
    "ui.game.system.powerrank.value.0",
    "ui.game.system.powerrank.value.1",
    "ui.game.system.powerrank.value.2",
    "ui.game.system.powerrank.value.3",
    "ui.game.system.powerrank.value.4",
}, _ui_game_texture3, 1704, 0, 172, 90, 2, 8)

-- 计时器板
res:addSprite("ui.game.boss.attacktime.bg", _ui_game_texture3, 712, 390, 138, 87)
res:setSpriteCenter("ui.game.boss.attacktime.bg", 0, 0)

-- boss位置指示器
res:addSprite("ui.game.boss.pos", _ui_game_texture3, 712, 478, 152, 24)
res:setSpriteCenter("ui.game.boss.pos", 152 / 2, 23)

-- 符卡星星
res:addSpriteSequence("ui.game.boss.stage.mark", _ui_game_texture3, 712, 503, 33, 32, 4, 1)

-- 雷、残
res:addSprite("ui.game.player.life0", _ui_game_texture3, 864     , 390     , 72, 72)
res:addSprite("ui.game.player.life1", _ui_game_texture3, 864 + 72, 390     , 72, 72)
res:addSprite("ui.game.player.bomb0", _ui_game_texture3, 864     , 390 + 72, 72, 72)
res:addSprite("ui.game.player.bomb1", _ui_game_texture3, 864 + 72, 390 + 72, 72, 72)
-- hyper时显示的
res:addSprite("ui.game.player.hbomb0", _ui_game_texture3, 864     , 390 + 144, 72, 72)
res:addSprite("ui.game.player.hbomb1", _ui_game_texture3, 864 + 72, 390 + 144, 72, 72)

--endregion

--region 其他界面

-- 关卡结算时用的
M.box1 = ui.Sprite9Define("ui.sprite9.frame1.", { 96, 96, 14 })

--endregion

if EISlib.ui.PRELOAD then
    res:load()
end
