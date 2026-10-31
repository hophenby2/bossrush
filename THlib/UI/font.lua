local path = "THlib\\UI\\font\\"
local ntext1 = path .. "text.ttf"
local ntext2 = path .. "text2.ttf"
local fallback = path .. "NotoSansCJKjp-Bold.otf"
-- 粗黑宋简体不含「剣／斬／閃」等日文汉字；Sub 的字体组按字形回退，保留已有字的外观。
-- LuaSTG-x 的兼容接口只有单字体加载，使用同包的完整中日文字库。
-- Sub 0.21.2 的字体组接口存在越界（引擎 e1704a92 在0.21.24修复），不能仅按函数存在判断。
local major, minor, patch = lstg.GetVersionNumber()
local font_group_safe = major == 0 and minor == 21 and patch and patch >= 24
local function load_text(name, size)
    if font_group_safe and type(lstg.LoadTrueTypeFont) == "function" then
        assert(lstg.LoadTrueTypeFont(name, {
            { source = ntext1, height = size },
            { source = fallback, height = size },
        }), "界面字体加载失败：" .. name)
    else
        LoadTTF(name, fallback, size)
    end
end
load_text('boss_name', 20)
--LoadTTF("text", ntext1[1], 32)
load_text("title", 32)
load_text("big_text", 80)
load_text("sc_menu", 26)
load_text("achievement", 28)
load_text("manual", 25)

LoadTTF("pretty", ntext2, 32)
LoadFont('Score', path .. 'score_new.fnt', false)
--LoadFont('time', path .. 'score_new_score.fnt', true)
LoadFont('replay', path .. 'replay.fnt', false)

