Include "THlib\\UI\\font.lua"
Include "THlib\\UI\\title.lua"
Include "THlib\\UI\\sc_pr.lua"
ui = {}
ui.version = "v5.1.2"
local LoadImage = LoadImage
LoadTexture("hint", "THlib\\UI\\hint.png", true)
LoadImage("hint.bonusfail", "hint", 0, 64, 256, 64)
LoadImage("hint.getbonus", "hint", 0, 128, 396, 64)
LoadImage("hint.extend", "hint", 0, 192, 160, 64)
LoadImage("hint.graze", "hint", 86, 12, 74, 32)
LoadImage("hint.life", "hint", 288, 0, 16, 15)
LoadImage("hint.lifeleft", "hint", 304, 0, 16, 15)
LoadImage("hint.bomb", "hint", 320, 0, 16, 16)
LoadImage("hint.bombleft", "hint", 336, 0, 16, 16)
LoadImage("kill_time", "hint", 232, 200, 152, 56, 16, 16)
SetImageCenter("hint.graze", 0, 16)
LoadImage("hint.hiscore", "hint", 424, 8, 80, 20)
LoadImage("hint.score", "hint", 424, 30, 64, 20)
LoadImage("hint.Pnumber", "hint", 352, 8, 56, 20)
LoadImage("hint.Bnumber", "hint", 352, 30, 72, 20)
LoadImage("hint.Cnumber", "hint", 352, 52, 40, 20)
SetImageCenter("hint.hiscore", 0, 10)
SetImageCenter("hint.score", 0, 10)
SetImageCenter("hint.Pnumber", 0, 10)
SetImageCenter("hint.Bnumber", 0, 10)
--"THlib\\UI\\font\\title.otf"
--"THlib\\UI\\font\\default_ttf"


LoadTexture('line', 'THlib\\UI\\line.png', true)
LoadImageGroup('line_', 'line', 0, 0, 128, 8, 1, 8, 0, 0)

ui.menu = {
    font_size = 0.625,
    line_height = 24,
    char_width = 20,
    num_width = 12.5,
    title_color = { 255, 255, 255 },
    unfocused_color = { 190, 190, 190 },
    unfocused_color2 = { 90, 90, 90 },
    focused_color1 = { 255, 255, 255 },
    focused_color2 = { 255, 227, 132 },
    blink_speed = 3,
    shake_time = 9,
    shake_speed = 40,
    shake_range = 3,
    sc_pr_line_per_page = 14,
    sc_pr_line_height = 22,
    sc_pr_width = 700,
    sc_pr_margin = 8,
    rep_font_size = 0.6,
    rep_line_height = 20,
    -- 这个列表的下标必须等于关卡的 level（_sc_pr_table 就是按 level 存的），
    -- 否则符卡练习会把某一关的卡挂到别的标题下面
    difftext = { "红魔乡", "妖妖梦", "永夜抄",
                 "花映塚", "文花帖",
                 "风神录", "地灵殿", "星莲船",
                 "文花帖DS", "大战争",
                 "神灵庙", "辉针城",
                 "天邪鬼",
                 "绀珠传", "天空璋",
                 "梦魇日记",
                 "鬼形兽", "虹龙洞", "弹幕黑市",
                 "未命名关卡",   -- 20  TH00
                 "水月",         -- 21  TH01
                 "星河",         -- 22  TH02
                 "白玉楼",       -- 23  TH03
                 "彼岸",         -- 24  TH04
                 "花园",         -- 25  TH05
                 "地底",         -- 26  TH19（地灵殿全员：7 个 BOSS 各 2 非符 + 3 符卡）
                 "天空璋AEX" },  -- 27  AEX（关卡号是 STAGE_COUNT + 1）
    sntext = { TH06 = "红魔乡", TH07 = "妖妖梦", TH08 = "永夜抄",
               TH09 = "花映塚", TH095 = "文花帖",
               TH10 = "风神录", TH11 = "地灵殿", TH12 = "星莲船",
               TH125 = "文花帖DS", TH128 = "大战争",
               TH13 = "神灵庙", TH14 = "辉针城",
               TH143 = "天邪鬼",
               TH15 = "绀珠传", TH16 = "天空璋",
               TH165 = "梦魇日记",
               TH17 = "鬼形兽",
               TH19 = "地底",
               TH18 = "虹龙洞",
               TH185 = "弹幕黑市",
               TH00 = "未命名关卡",
               TH01 = "水月",
               TH02 = "星河",
               TH03 = "白玉楼",
               TH04 = "彼岸",
               TH05 = "花园",
               SUMMARY = "统计",
               ["HSiFS AfterExtra"] = "天空璋AEX",
               ["Spell Practice"] = "符卡练习" },
    pname = { Reimu = "博丽灵梦", Marisa = "雾雨魔理沙", Chiruno = "琪露诺", Aya = "射命丸文" }
}

local cos, sin, screen, abs, int, lstg, table, string, tostring = cos, sin, screen, abs, int, lstg, table, string, tostring
local task, misc = task, misc
local min, max = min, max
local sign = sign
local Color = Color
local SetViewMode = SetViewMode
local SetImageState = SetImageState
local SetFontState = SetFontState
local unpack = unpack
local Render = Render
local RenderTTF2 = RenderTTF2
local RenderRect = RenderRect
local RenderText = RenderText

function ui:RenderText(ttfname, text, x, y, size, color, ...)
    local a = (color:ARGB())
    for i = 1, 4 do
        RenderTTF2(ttfname, text, x + cos(i * 90 + 45), y + sin(i * 90 + 45), size, Color(a, 0, 0, 0), ...)
    end
    RenderTTF2(ttfname, text, x, y, size, color, ...)
end

CreateRenderTarget("test")
function ui:DrawBack(alpha, t)
    SetViewMode('ui')
    SetImageState("sub_menu_bg", '', 255 * alpha, 255, 255, 255)
    Render("sub_menu_bg", 480, 270)
    if not cur_setting.easyrender then
        local scale = 1 + sin(t / 3) * 0.1
        local rot = -90
        local v = t
        misc.RenderTexInRect("menu_bg_2", 0, 960, 0, 540, v * cos(rot), v * sin(rot), rot - 90,
                scale, scale, "mul+rev", Color(alpha * 90, 128 + 64 * sin(t / 2), 128 + 64 * sin(t / 4), 128 + 64 * sin(t / 6)))
    end
end

function ui:DrawMenu(title, text, pos, x, y, alpha, timer, shake, align, tri, nopos)
    align = align or "center"
    local ttfname = "title"
    local yos
    if title == "" then
        yos = (#text + 1) * self.menu.line_height * 0.5
    else
        yos = (#text - 1) * self.menu.line_height * 0.5
        self:RenderText(ttfname, title, x, y + yos + self.menu.line_height, 1,
                Color(alpha * 255, unpack(self.menu.title_color)), "center", "vcenter")
    end
    local t, now, color, k, xos
    for i = 1, #text do
        if i == pos then
            if text[i] ~= "" then
                color = {}
                k = cos(timer * self.menu.blink_speed)
                k = k * k
                for j = 1, 3 do
                    color[j] = self.menu.focused_color1[j] * k + self.menu.focused_color2[j] * (1 - k)
                end
                xos = self.menu.shake_range * sin(self.menu.shake_speed * shake)
                t = self.menu.sntext[text[i]] or text[i]
                now = t
                self:RenderText(ttfname, "♪" .. t, x + xos, y - i * self.menu.line_height + yos, 1 + 0.2 * tri * tri,
                        Color(alpha * 255, unpack(color)), align, "vcenter")
            end
        else
            t = self.menu.sntext[text[i]] or text[i]
            self:RenderText(ttfname, t, x, y - i * self.menu.line_height + yos, 1,
                    Color(alpha * 255, unpack(self["menu"]["unfocused_color" .. ((nopos and nopos[i]) and "2" or "")])), align, "vcenter")
        end
    end
end

function ui:DrawList(text, pos, x, y, alpha, timer, shake, tri, nopos, selected)
    local ttfname = "title"
    local t, now, color, k, xos
    for i = 1, #text do
        if i == pos then
            if text[i] ~= "" then
                color = {}
                k = cos(timer * self.menu.blink_speed)
                k = k * k
                for j = 1, 3 do
                    color[j] = self.menu.focused_color1[j] * k + self.menu.focused_color2[j] * (1 - k)
                end
                xos = self.menu.shake_range * sin(self.menu.shake_speed * shake)
                t = self.menu.sntext[text[i]] or text[i]
                now = t
                tri = tri * tri
                if selected and selected[i] then
                    self:RenderText(ttfname, "♪" .. t, x, y - i * self.menu.line_height, 1 + 0.2 * tri,
                            Color(alpha * 255, color[1] / 2, color[2], color[3]), "center", "vcenter")
                else
                    self:RenderText(ttfname, "♪" .. t, x + xos, y - i * self.menu.line_height, 1 + 0.2 * tri,
                            Color(alpha * 255, unpack(color)), "center", "vcenter")
                end
            end
        else
            t = self.menu.sntext[text[i]] or text[i]
            if selected and selected[i] then
                self:RenderText(ttfname, t, x, y - i * self.menu.line_height, 1,
                        Color(alpha * 255, 100, 200, 255), "center", "vcenter")
            else
                self:RenderText(ttfname, t, x, y - i * self.menu.line_height, 1,
                        Color(alpha * 255, unpack(self["menu"]["unfocused_color" .. ((nopos and nopos[i]) and "2" or "")])), "center", "vcenter")
            end
        end
    end
end

function ui:DrawMenuTTF(text, pos, x, y, alpha, timer, align, tri)
    align = align or "center"
    local yos = (#text + 1) * self.menu.sc_pr_line_height * 0.5
    local color, k
    for i = 1, #text do
        if i == pos then
            color = {}
            k = cos(timer * self.menu.blink_speed)
            k = k * k
            for j = 1, 3 do
                color[j] = self.menu.focused_color1[j] * k + self.menu.focused_color2[j] * (1 - k)
            end
            self:RenderText("sc_menu", text[i], x, y - i * self.menu.sc_pr_line_height + yos, 1 + 0.1 * (tri or 0),
                    Color(alpha * 255, unpack(color)), align, "vcenter", "noclip")
        else
            self:RenderText("sc_menu", text[i], x, y - i * self.menu.sc_pr_line_height + yos, 1,
                    Color(alpha * 255, unpack(self.menu.unfocused_color)), align, "vcenter", "noclip")
        end
    end
end

function ui:DrawRepText(text, pos, x, y, alpha, tri)
    local yos = (#text - 1) * self.menu.sc_pr_line_height * 0.5
    local _text = text
    local xos = { -300, -240, -120, 12, 100, 220 }
    for i = 1, #_text do
        if i == pos then
            for m = 1, 6 do
                self:RenderText("title", _text[i][m], x + xos[m], y - i * self.menu.rep_line_height + yos, 1 + 0.2 * (tri or 0),
                        Color(255 * alpha, 255, 255, 48), "vcenter", "left")
            end
        else
            for m = 1, 6 do
                self:RenderText("title", _text[i][m], x + xos[m], y - i * self.menu.rep_line_height + yos, 1,
                        Color(255 * alpha, 128, 128, 128), "vcenter", "left")
            end
        end
    end
end

function ui:DrawRepText2(text, pos, x, y, alpha, tri)
    local yos = (#text - 1) * self.menu.sc_pr_line_height * 0.5
    local _text = text
    local xos = { -200, 200 }
    for i = 1, #_text do
        if i == pos then
            self:RenderText("title", _text[i][1], x + xos[1], y - i * self.menu.rep_line_height + yos, 1 + 0.2 * (tri or 0),
                    Color(255 * alpha, 255, 255, 48), "vcenter", "left")
            self:RenderText("title", _text[i][2], x + xos[2], y - i * self.menu.rep_line_height + yos, 1 + 0.2 * (tri or 0),
                    Color(255 * alpha, 255, 255, 48), "vcenter", "right")
        else
            self:RenderText("title", _text[i][1], x + xos[1], y - i * self.menu.rep_line_height + yos, 1,
                    Color(255 * alpha, 128, 128, 128), "vcenter", "left")
            self:RenderText("title", _text[i][2], x + xos[2], y - i * self.menu.rep_line_height + yos, 1,
                    Color(255 * alpha, 128, 128, 128), "vcenter", "right")
        end
    end
end

local function formatnum(num)
    local S = sign(num)
    num = abs(num)
    local tmp = {}
    local var
    while num >= 1000 do
        var = num - int(num / 1000) * 1000
        table.insert(tmp, 1, string.format("%03d", var))
        num = int(num / 1000)
    end
    table.insert(tmp, 1, tostring(num))
    var = table.concat(tmp, ",")
    if S < 0 then
        var = string.format("-%s", var)
    end
    return var, #tmp - 1
end
local function RenderScore(fontname, score, x, y, size, mode)
    if score < 10000000000000 then
        RenderText(fontname, formatnum(score), x, y, size, mode)
    else
        RenderText(fontname, "9,999,999,999,990", x, y, size, mode)
    end
end
_G.RenderScore = RenderScore

---@class lstg.lstg_ui
---@return lstg.lstg_ui
lstg.lstg_ui = plus.Class()
local lstg_ui = lstg.lstg_ui

local res_list = {
    ["tex"] = {
        "ui_bg",
        "ui_bg2",
        "menu_bg",
        "menu_bg2",
        integer = 1,
    },
    ["img"] = {
        "ui_bg",
        "ui_bg2",
        "menu_bg",
        "menu_bg2",
        integer = 2,
    },
}
function lstg_ui:reloadUI()
    for type, list in pairs(res_list) do
        for _, res in pairs(list) do
            if CheckRes(type, res) == "global" then
                RemoveResource("global", list.integer, res)
            end
        end
    end
    local pool = GetResourceStatus() or "global"
    SetResourceStatus("global")
    if self.type == 1 then
        LoadImageFromFile("ui_bg", "THlib\\UI\\ui_bg.png")
        LoadImageFromFile("menu_bg", "THlib\\UI\\menu_bg.png")
        LoadImageFromFile("sub_menu_bg", "THlib\\UI\\menu_bg_sub.png")
        LoadTexture2("menu_bg_2", "THlib\\UI\\menu_bg2.png")
        LoadTexture2("ui_bg2", "THlib\\UI\\ui_bg2.png")
        LoadImageFromFile("title", "THlib\\UI\\title.png")
    elseif self.type == 2 then
        if FileExist("User\\menu_bg_2.png") then
            LoadImageFromFile("menu_bg2", "User\\menu_bg_2.png")
        end
    end
    SetResourceStatus(pool)
end
function lstg_ui:init()
    if setting.resx > setting.resy then
        self.type = 1
    else
        self.type = 2
    end
    self.rot = ran:Float(-85, 85)
    self.x, self.y = 198 + ran:Float(-120, 120), 264 + ran:Float(-120, 120)

    self.rotate = 0
    self:reloadUI()
end
function lstg_ui:drawFrame()
    self["drawFrame" .. self.type](self)
end
function lstg_ui:drawFrame1()
    SetViewMode "ui"
    Render("ui_bg", 480, 270, 0, 0.5)

    local t = stage.current_stage.timer
    if not cur_setting.easyrender then
        local rot = int((t + 90) / 360) * 36
        misc.RenderTexInRect("ui_bg2", 0, screen.width, 0, screen.height,
                cos(rot + 90) * t, sin(rot + 90) * t, rot, 0.3, 0.3, "mul+add",
                Color(32 + 32 * sin(t), sp:HSVtoRGB(t / 2, 0.6, 1)))
    end
    local w = lstg.world
    local x1, x2, y1, y2 = w.scrl, w.scrr, w.scrb, w.scrt
    for i = 1, 8 do
        SetImageState("white", "", 155 / 8 * (8 - i), 0, 0, 0)
        RenderRect("white", x1 - i * 2, x2 + i * 2, y1 - i * 2, y2 + i * 2)
    end

    SetViewMode "world"
end
function lstg_ui:drawFrame2()
    SetViewMode "ui"
    Render("ui_bg2", 198, 264)
    SetViewMode "world"
end
function lstg_ui:drawMenuBG()
    self["drawMenuBG" .. self.type](self)
end
function lstg_ui:drawMenuBG1()
    task.Do(self)
    SetViewMode "ui"
    Render("menu_bg", 480, 270)

    local t = stage.current_stage.timer
    local alpha = (t > 90) and 1 or task.SetMode[5](min(t / 90, 1))
    SetImageState("title", "mul+add", 255 * alpha, 255, 255, 255)
    Render("title", 675, 305 + (cur_setting.easyrender and 0 or sin(t / 2) * 5))

    if not cur_setting.easyrender then
        menu:Updatekey()
        if menu:keyYes() then
            task.New(self, function()
                local slast = 0
                for i = 1, 20 do
                    i = task.SetMode[2](i / 20) * 50
                    self.rotate = self.rotate + (i - slast)
                    slast = i
                    task.Wait()
                end
            end)
        end
        if menu:keyNo() then
            task.New(self, function()
                local slast = 0
                for i = 1, 20 do
                    i = -task.SetMode[2](i / 20) * 50
                    self.rotate = self.rotate + (i - slast)
                    slast = i
                    task.Wait()
                end
            end)
        end
        local init_s = (t > 90) and 0 or task.SetMode[3](max(1 - t / 90, 0))
        local scale = 1.5 + sin(t / 6) * 0.3 + init_s
        local rot = (30 + t / 100 + self.rotate) % 360
        local v = t * 1.5
        misc.RenderTexInRect("menu_bg_2", 0, screen.width, 0, screen.height,
                v * cos(rot), v * sin(rot), rot + 90, scale, scale,
                "mul+rev", Color(alpha * 40, 128 + 64 * sin(t / 2), 128 + 64 * sin(t / 4), 128 + 64 * sin(t / 6)))
    end
    SetViewMode "world"
end
function lstg_ui:drawMenuBG2()
    SetViewMode "ui"
    if CheckRes("img", 'menu_bg2') then
        SetImageState("menu_bg2", "", 255, 90, 90, 90)
        Render("menu_bg2", self.x, self.y, self.rot)
    end
    SetFontState("Score", "", 255, 255, 255, 255)
    RenderText("Score", ui.version,
            392, 10, 0.25, "right", "bottom")
    RenderText("Score",
            string.format("%.1ffps", GetFPS()),
            392, 1, 0.25, "right", "bottom")
    SetViewMode "world"
end
function lstg_ui:ScoreUpdate()
    local var = lstg.var
    local cur_score = var.score
    local score = self.score or cur_score
    local score_tmp = self.score_tmp or cur_score
    if score_tmp < cur_score then
        if cur_score - score_tmp <= 100 then
            score = score + 10
        elseif cur_score - score_tmp <= 1000 then
            score = score + 100
        else
            score = int(score / 10 + int((cur_score - score_tmp) / 600)) * 10 + cur_score % 10
        end
    end
    if score_tmp > cur_score then
        score_tmp = cur_score
        score = cur_score
    end
    if score >= cur_score then
        score_tmp = cur_score
        score = cur_score
    end
    self.score = score
    self.score_tmp = score_tmp
end
function lstg_ui:drawScore()
    self:ScoreUpdate()
    self["drawScore" .. self.type](self)
end
function lstg_ui:drawScore1()
    SetViewMode "ui"
    self:drawInfo1()
    SetViewMode "world"
end
function lstg_ui:drawScore2()
end
function lstg_ui:countdist(x, y)
    local player = player
    if lstg.world.t > 224 and IsValid(player) and Dist(player.x + 320, player.y + 240, x, y) <= 90 then
        return 1 - (90 - max(Dist(player.x + 320, player.y + 240, x, y), 40)) / 55
    else
        return 1
    end
end

local white = "white"
local blend = ""
local ttf = "title"
local center = "center"
local bottom, top = "bottom", "top"
local left = "left"
local right = "right"
local biggest = 9999999999990
local Forbid = Forbid
function lstg_ui:drawInfo1()
    local s = stage.current_stage
    local alpha = min(s.timer / 120, 1)
    local falpha = alpha * 255
    local w = lstg.world
    local scrl, scrr, scrb, scrt = w.scrl, w.scrr, w.scrb, w.scrt
    local ui = ui
    local hiscore = lstg.tmpvar.hiscore or 0
    local score = self.score or 0
    local var = lstg.var
    do
        ui:RenderText(ttf, "最高分", scrl - 2, scrt + 4,
                0.8, Color(falpha, 200, 200, 230), right, bottom)
        ui:RenderText(ttf, formatnum(Forbid(hiscore, score, biggest)), scrl, scrt + 4,
                0.8, Color(falpha, 173, 173, 173), left, bottom)

        ui:RenderText(ttf, "当前分数", scrr + 2, scrt + 4,
                0.8, Color(falpha, 200, 200, 230), left, bottom)
        ui:RenderText(ttf, formatnum(min(score, biggest)), scrr, scrt + 4,
                0.8, Color(falpha, 255, 255, 255), right, bottom)
    end--score

    do
        local sg = stage.current_stage
        ui:RenderText(ttf, "死亡数", scrr + 6, scrt - 30,
                0.8, Color(falpha, 200, 100, 100), left, bottom)
        if sg.AllowMissCount then
            local r, g, b = 255, 255, 255
            local pmc = sg.AllowMissCount
            if pmc and var.dead > pmc then
                r, g, b = 155 + 100 * sin(s.timer * 3), 100, 100
            end
            ui:RenderText(ttf, ("%d / %s"):format(var.dead, pmc), scrr + 6, scrt - 45,
                    0.8, Color(falpha, r, g, b), left, bottom)
        else
            if lstg.var.is_practice or sg.group._name ~= "BossRush" then
                ui:RenderText(ttf, ("%d"):format(var.dead), scrr + 6, scrt - 45,
                        0.8, Color(falpha, 255, 255, 255), left, bottom)
            else
                local r, g, b = 255, 255, 255
                local pmc = s.PassMissCount[s.level + 1]
                if pmc and var.dead > pmc then
                    r, g, b = 155 + 100 * sin(s.timer * 3), 100, 100
                end
                ui:RenderText(ttf, ("%d / %s"):format(var.dead, pmc or "Null"), scrr + 6, scrt - 45,
                        0.8, Color(falpha, r, g, b), left, bottom)
            end
        end


        ui:RenderText(ttf, "收卡数", 960 - 6, scrt - 30,
                0.8, Color(falpha, 100, 200, 100), right, bottom)
        ui:RenderText(ttf, ("%d"):format(var.getsc), 960 - 6, scrt - 45,
                0.8, Color(falpha, 255, 255, 255), right, bottom)

        local x1, x2, y1, y2 = scrr + 6 + 45, 960 - 6 - 45, scrt - 30 + 3, scrt - 16 - 3
        SetImageState(white, blend, falpha, 200, 200, 200)
        misc.RenderOutLine(white, x1, x2, y2, y1, 0, 1)
        if var.dead + var.getsc ~= 0 then
            local b = (x2 - x1) * var.dead / (var.dead + var.getsc)
            RenderRect(white, x1 + b - 1, x1 + b + 1, y1, y2)
            SetImageState(white, blend, alpha * 128, 200, 100, 100)
            RenderRect(white, x1, x1 + b, y1, y2)
            SetImageState(white, blend, alpha * 128, 100, 200, 100)
            RenderRect(white, x1 + b, x2, y1, y2)

        end

    end--dead&getsc

    do
        SetImageState("line_7", "", falpha, 255, 255, 255)
        RenderRect("line_7", scrr + 6, 960 - 6, scrt - 66, scrt - 74)
        ui:RenderText(ttf, "擦弹：", scrr + 6, scrt - 70,
                0.8, Color(falpha, 173, 173, 173), left, bottom)
        ui:RenderText(ttf, var.graze, 960 - 6, scrt - 70,
                0.8, Color(falpha, 173, 173, 173), right, bottom)
        RenderRect("line_7", scrr + 6, 960 - 6, scrt - 96, scrt - 104)
        ui:RenderText(ttf, "资金力：", scrr + 6, scrt - 100,
                0.8, Color(falpha, 255, 227, 132), left, bottom)
        ui:RenderText(ttf, scoredata.money, 960 - 6, scrt - 100,
                0.8, Color(falpha, 255, 227, 132), right, bottom)
        if var.saving > 0 then
            RenderRect("line_7", scrr + 6, 960 - 6, scrt - 126, scrt - 134)
            ui:RenderText(ttf, "读档次数：", scrr + 6, scrt - 130,
                    0.8, Color(falpha, 150, 150, 150), left, bottom)
            ui:RenderText(ttf, var.saving, 960 - 6, scrt - 130,
                    0.8, Color(falpha, 150, 150, 150), right, bottom)
        end
    end--other


end

function ResetUI()
    lstg.ui = lstg.lstg_ui()
    function ui.DrawFrame()
        if lstg.ui then
            lstg.ui:drawFrame()
        end
    end
    function ui.DrawMenuBG()
        if lstg.ui then
            lstg.ui:drawMenuBG()
        end
    end
    function ui.DrawScore()
        if lstg.ui then
            lstg.ui:drawScore()
        end
    end
end

ResetUI()