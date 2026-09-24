menu = {  }
function menu:FadeIn()
    self.x = screen.width * 0.5
    task.Clear(self)
    task.New(self, function()
        for i = 1, 30 do
            self.alpha = task.SetMode[2](i / 30)
            task.Wait()
        end
        self.locked = false
    end)
end

function menu:FadeOut()
    task.Clear(self)
    if not self.locked then
        task.New(self, function()
            self.locked = true
            for i = 1, 30 do
                self.alpha = 1 - task.SetMode[2](i / 30)
                task.Wait()
            end
        end)
    end
end
function menu:Updatekey()
    ext.mouse:frame()
    self.key = GetLastKey()
    return true
end
function menu:keyYes()
    if self.yesflag then
        self.yesflag = false
        return true
    end
    return self.key == KEY.Z or
            self.key == KEY.ENTER
end
function menu:keyNo()
    if self.noflag then
        self.noflag = false
        return true
    end
    return self.key == KEY.X or
            self.key == KEY.ESCAPE
end
function menu:keyLeft()
    return self.key == setting.keys.left or
            self.key == KEY.NUMPAD4 or
            self.key == KEY.NUMPAD1 or
            self.key == KEY.NUMPAD7
end
function menu:keyRight()
    return self.key == setting.keys.right or
            self.key == KEY.NUMPAD6 or
            self.key == KEY.NUMPAD3 or
            self.key == KEY.NUMPAD9
end
function menu:keyUp()
    return self.key == setting.keys.up or
            self.key == KEY.NUMPAD8 or
            self.key == KEY.NUMPAD7 or
            self.key == KEY.NUMPAD9
end
function menu:keyDown()
    return self.key == setting.keys.down or
            self.key == KEY.NUMPAD2 or
            self.key == KEY.NUMPAD1 or
            self.key == KEY.NUMPAD3
end

function menu:ControlExit(x1, x2, y1, y2, action)
    local mouse = ext.mouse
    if sp.math.PointBoundCheck(mouse.x, mouse.y, x1, x2, y1, y2) and mouse:isDown(1) then
        if action then
            action()
        else
            self.noflag = true
        end
    end
end
function menu:RenderExit(x1, x2, y1, y2, alpha)
    alpha = alpha * 255
    SetImageState("white", "", alpha * 0.6, 0, 0, 0)
    RenderRect("white", x1, x2, y1, y2)
    ui:RenderText("big_text", "×", (x1 + x2) / 2, (y1 + y2) / 2 + 3,
            abs(x2 - x1) / 45, Color(alpha, 255, 255, 255), "centerpoint")
end

function menu:mouseCheck(main_y, offy, height, list_count)
    local mouse = ext.mouse
    local y
    local selected
    for i = 1, list_count do
        y = main_y - i * height
        if abs(mouse.y - y) + offy < height / 2 then
            selected = i
            break
        end
    end
    return selected
end

simple_menu = Class(object)
function simple_menu:init(title, content, closepos)
    self.layer = LAYER.TOP
    self.group = GROUP.GHOST
    self.alpha = 0
    self.offx = 0
    self.x = screen.width * 0.5
    self.y = screen.height * 0.5
    self.bound = false
    self.locked = true
    self.title = title
    self.closepos = closepos or {}
    self.nopos = {}

    self.content = content
    self.text = {}
    self.func = {}
    self.tri_alpha = 1
    for i = 1, #content do
        self.text[i] = content[i][1]
        self.func[i] = content[i][2]
    end
    self.pos = 1
    self.pos_pre = 1
    self.pos_changed = 0
    self.no_pos_change = false
    if content[#content][1] == 'exit' then
        self.exit_func = content[#content][2]
        self.text[#content] = nil
        self.func[#content] = nil
    end
end
function simple_menu:frame()
    task.Do(self)
    if self.alpha == 0 then
        return
    end
    for i, p in pairs(self.closepos) do
        self.nopos[i] = p()
    end
    if self.locked then
        return
    end
    menu:Updatekey()
    if menu:keyUp() and (not self.no_pos_change) then
        self.pos = sp:TweakValue(self.pos - 1, #self.text, 1)
        while self.nopos[self.pos] do
            self.pos = sp:TweakValue(self.pos - 1, #self.text, 1)
        end
        task.New(self, function()
            for i = 1, 10 do
                self.tri_alpha = sin(i * 9)
                task.Wait()
            end
        end)
        PlaySound('select00', 0.3)
    end
    if menu:keyDown() and (not self.no_pos_change) then
        self.pos = sp:TweakValue(self.pos + 1, #self.text, 1)
        while self.nopos[self.pos] do
            self.pos = sp:TweakValue(self.pos + 1, #self.text, 1)
        end
        task.New(self, function()
            for i = 1, 10 do
                self.tri_alpha = sin(i * 9)
                task.Wait()
            end
        end)
        PlaySound('select00', 0.3)
    end
    if menu:keyYes() and self.func[self.pos] then
        self.func[self.pos]()
        PlaySound('ok00', 0.3)
    elseif menu:keyNo() and self.exit_func then
        self.exit_func()
        PlaySound('cancel00', 0.3)
    end
    if self.pos_changed > 0 then
        self.pos_changed = self.pos_changed - 1
    end
    if self.pos_pre ~= self.pos then
        self.pos_changed = ui.menu.shake_time
    end
    self.pos_pre = self.pos
end
function simple_menu:render()
    if self.alpha == 0 then
        return
    end
    SetViewMode('ui')
    ui:DrawBack(self.alpha, self.timer)
    ui:DrawMenu(self.title, self.text, self.pos, self.x + self.offx, self.y + 320 - self.alpha * 320,
            self.alpha, self.timer, self.pos_changed, nil, self.tri_alpha, self.nopos)
end

local list = {
    { price = 2000, dx = 0, pic = 2, title = "<妖妖梦>樱花系统", achievementid = 85 },
    { price = 1700, dx = 0, pic = 3, title = "<永夜抄>人态系统", achievementid = 86 },
    { price = 2400, dx = 0, pic = 4, title = "<花映冢>蓄力系统", achievementid = 87 },
    { price = 2200, dx = 0, pic = 6, title = "<风神录>信仰系统", achievementid = 88 },
    { price = 1800, dx = 0, pic = 7, title = "<地灵殿>信号系统", achievementid = 89 },
    { price = 2500, dx = 0, pic = 8, title = "<星莲船>飞碟系统", achievementid = 90 },
    { price = 2800, dx = 0, pic = 11, title = "<神灵庙>灵界系统", achievementid = 91 },
    { price = 1800, dx = 0, pic = 12, title = "<辉针城>道具系统", achievementid = 92 },
    { price = 3000, dx = 0, pic = 14, title = "<绀珠传>擦弹系统", achievementid = 93 },
    { price = 3200, dx = 0, pic = 15, title = "<天空璋>季节系统", achievementid = 94 },
    { price = 2800, dx = 0, pic = 17, title = "<鬼形兽>暴走系统", achievementid = 95 },

}
_G.SystemList = list

main_menu = Class(simple_menu)
function main_menu:init(title, content, exit_func, closepos)
    simple_menu.init(self, title, content, closepos)
    for i, p in pairs(self.closepos) do
        self.nopos[i] = p
    end
    self.exit_func = exit_func
    self.sub_title = {}
    for i = 1, #content do
        self.sub_title[i] = content[i][3]
    end
    self._pos = self.pos
end
function main_menu:frame()
    task.Do(self)

    self._pos = self._pos + (self.pos - self._pos) * 0.05
    if self.alpha == 0 or self.locked then
    else
        menu:Updatekey()
        menu:ControlExit(0, 30, 540, 510, function()
            self.pos = #self.text
            self.exit_func()
            PlaySound('cancel00', 0.3)
        end)
        if menu:keyYes() and self.func[self.pos] then
            self.func[self.pos]()
            PlaySound('ok00', 0.3)
        elseif menu:keyNo() and self.exit_func then
            self.exit_func()
            PlaySound('cancel00', 0.3)
        else
            if menu:keyUp() and (not self.no_pos_change) then
                self.pos = sp:TweakValue(self.pos - 1, #self.text, 1)
                while self.nopos[self.pos] do
                    self.pos = sp:TweakValue(self.pos - 1, #self.text, 1)
                end
                self.tri_alpha = 0
                task.New(self, function()
                    for i = 1, 30 do
                        self.tri_alpha = sin(i * 3)
                        task.Wait()
                    end
                end)
                PlaySound('select00', 0.3)
            end
            if menu:keyDown() and (not self.no_pos_change) then
                self.pos = sp:TweakValue(self.pos + 1, #self.text, 1)
                while self.nopos[self.pos] do
                    self.pos = sp:TweakValue(self.pos + 1, #self.text, 1)
                end
                self.tri_alpha = 0
                task.New(self, function()
                    for i = 1, 30 do
                        self.tri_alpha = sin(i * 3)
                        task.Wait()
                    end
                end)
                PlaySound('select00', 0.3)
            end
            local mouse = ext.mouse
            if mouse:isDown(1) then
                local height = ui.menu.line_height * 1.2
                local selected = menu:mouseCheck(430, 0, height, #self.text)
                if selected then
                    if selected ~= self.pos and not self.nopos[selected] then
                        PlaySound("select00")
                        self.pos = selected
                        task.New(self, function()
                            for i = 1, 30 do
                                self.tri_alpha = sin(i * 3)
                                task.Wait()
                            end
                        end)
                    else
                        PlaySound('ok00', 0.3)
                        self.func[self.pos]()
                    end
                end
            end
            if mouse._wheel ~= 0 then
                local t = -sign(mouse._wheel)
                self.pos = sp:TweakValue(self.pos + t, #self.text, 1)
                while self.nopos[self.pos] do
                    self.pos = sp:TweakValue(self.pos + t, #self.text, 1)
                end
                PlaySound("select00")
                self.tri_alpha = 0
                task.New(self, function()
                    for i = 1, 30 do
                        self.tri_alpha = sin(i * 3)
                        task.Wait()
                    end
                end)
            end
        end
        if self.pos_changed > 0 then
            self.pos_changed = self.pos_changed - 1
        end
        if self.pos_pre ~= self.pos then
            self.pos_changed = ui.menu.shake_time
        end
        self.pos_pre = self.pos


    end

end
function main_menu:render()
    if self.alpha == 0 then
        return
    end

    SetViewMode('ui')
    local timer = self.timer
    local ttfname = "pretty"
    local xos
    local ui = ui
    local x, y = -60 + 300 * sin(self.alpha * 90), 430
    local count = #self.text
    local r2
    local height = ui.menu.line_height * 1.2
    local R, G, B
    local sub_x, sub_y = 0, 0
    for i = 1, count do
        sub_x = cur_setting.easyrender and 0 or 4 + sin(timer / 2 + i * 45) * 2
        sub_y = cur_setting.easyrender and 0 or sin(timer / 3 + i * 30) * 2.5
        r2 = cur_setting.easyrender and 0 or task.SetMode[5](i / count + self._pos / count + timer / 720)
        R, G, B = sp:HSVtoRGB(self.timer / 5, 0.3 + i / count * 0.2, 1)
        if i == self.pos then
            xos = ui.menu.shake_range * sin(ui.menu.shake_speed * self.pos_changed)
            R, G, B = sp:HSVtoRGB(timer / 5, 0.1, 1)
            ui:RenderText(ttfname, "♪" .. self.text[i], x + xos + r2 * 60, y - i * height,
                    1.2 + 0.2 * self.tri_alpha, Color(self.alpha * 255, R, G, B), "right", "vcenter")
            ui:RenderText(ttfname, self.sub_title[i], x + xos + r2 * 60 + sub_x, y - i * height + sub_y,
                    0.7 + 0.2 * self.tri_alpha, Color(self.alpha * 255, R, G, B), "left", "vcenter")
        else
            if self.nopos[i] then
                R = R / 2
                G = G / 2
                B = B / 2
            end
            ui:RenderText(ttfname, self.text[i], x + r2 * 60, y - i * height, 1.2,
                    Color(self.alpha * 255, R, G, B), "right", "vcenter")
            ui:RenderText(ttfname, self.sub_title[i], x + r2 * 60 + sub_x, y - i * height + sub_y, 0.7,
                    Color(self.alpha * 255, R, G, B), "left", "vcenter")
        end
    end
    menu:RenderExit(0, 30, 540, 510, self.alpha)
end

LoadTexture("badapplePIC", "mod\\badapple.png")
LoadTexture("th16AEXPIC", "mod\\th16AEX.png")
local white = "white"
stage_select = Class(object)
function stage_select:fresh()
    self.stage_text = {}
    for i, p in pairs(stage_selects) do
        self.stage_text[i] = p
    end
    self.unlocked_day = {}
    self.stage_selects = {}
    table.insert(self.stage_selects, {
        id = -1,
        title = "天空璋AfterExtra",
        tex = "th16AEXPIC",
        pulse = 0,
        stage = function()
            stage.group.Start(stage.groups["HSiFS AfterExtra"])
        end,
        unlock_way = function()
            if scoredata.bought[2] then
                return true
            else
                return "请前往商店购买解锁"
            end
        end
    })
    table.insert(self.stage_selects, {
        id = 0,
        title = "Bad Apple!!",
        tex = "badapplePIC",
        pulse = 0,
        stage = function()
            stage.group.Start(stage.groups["Bad Apple!!"])
        end,
        unlock_way = function()
            if scoredata.bought[1] then
                return true
            else
                return "请前往商店购买解锁"
            end
        end
    })
    for _, d in pairs(self.stage_text) do
        table.insert(self.stage_selects, d)
    end
    for t, d in ipairs(self.stage_selects) do
        self.unlocked_day[t] = true
    end --单篇章游玩已移除解锁限制
    self.stage_count = #self.stage_selects
end
function stage_select:init(exit_func, choose_func)
    self.exit_func = exit_func
    self.choose_func = choose_func
    self.x = 480
    self.y = 270
    self.bound = false
    self.locked = true
    self.pos = scoredata.stageselectPos or 2
    self.alpha = 0
    self.ox = 0
    self.moveUnit = 70
    self.pulseUnit = 100
    self.select_buling = 0
    stage_select.fresh(self)
end
function stage_select:frame()
    task.Do(self)
    scoredata.stageselectPos = self.pos
    self.ox = self.ox - self.ox * 0.07
    if self.locked then
        return
    end
    menu:Updatekey()
    menu:ControlExit(0, 30, 540, 510)
    if menu:keyLeft() then
        local t = self.pos
        while true do
            self.pos = sp:TweakValue(self.pos - 1, self.stage_count, 1)
            self.ox = self.ox + (self.pos - t) * self.moveUnit
            if self.stage_selects[self.pos] then
                break
            end
        end
        PlaySound('select00', 0.3)
    end
    if menu:keyRight() then
        local t = self.pos
        while true do
            self.pos = sp:TweakValue(self.pos + 1, self.stage_count, 1)
            self.ox = self.ox + (self.pos - t) * self.moveUnit
            if self.stage_selects[self.pos] then
                break
            end
        end
        PlaySound('select00', 0.3)
    end
    if menu:keyYes() then
        if self.unlocked_day[self.pos] then
            self.choose_func(self.pos)
            task.New(self, function()
                task.SmoothSetValueTo("select_buling", 1, 30, 0)
                self.select_buling = 0
            end)
            PlaySound("ok00")
        else
            New(info, "解锁方式：" .. (self.stage_selects[self.pos].unlock_way()))
            PlaySound("invalid")
        end

    end
    if menu:keyNo() then
        if self.exit_func then
            self.exit_func()
            PlaySound("cancel00")
        end
    end
    local mouse = ext.mouse
    local Pos = self.pos
    local width = self.moveUnit / 2 / 1.4
    local pulseUnit = self.pulseUnit
    local x
    ---@param u stage_unit
    for i, u in pairs(self.stage_selects) do
        x = self.x + self.ox + (i - Pos) * self.moveUnit
        local pulse = u.pulse
        local way = sign(i - Pos) * pulseUnit * (1 - u.pulse)
        if mouse:isDown(1) then
            if sp.math.PointBoundCheck(mouse.x, mouse.y,
                    x - width - pulseUnit * pulse + way,
                    x + width + pulseUnit * pulse + way,
                    self.y + 140 + 30 * pulse,
                    self.y - 140 - 30 * pulse) then
                if i == Pos then
                    if self.unlocked_day[self.pos] then
                        self.choose_func(self.pos)
                        task.New(self, function()
                            task.SmoothSetValueTo("select_buling", 1, 30, 0)
                            self.select_buling = 0
                        end)
                        PlaySound("ok00")
                    else
                        New(info, "解锁方式：" .. (self.stage_selects[self.pos].unlock_way()))
                        PlaySound("invalid")
                    end
                    break
                elseif self.stage_selects[i] then
                    self.ox = self.ox + (i - Pos) * self.moveUnit
                    self.pos = i
                    PlaySound("select00")
                    break
                end
            end
        end
    end
    if mouse._wheel ~= 0 then
        local t = self.pos
        while true do
            self.pos = sp:TweakValue(self.pos - sign(mouse._wheel), self.stage_count, 1)
            self.ox = self.ox + (self.pos - t) * self.moveUnit
            if self.stage_selects[self.pos] then
                break
            end
        end
        PlaySound('select00', 0.3)
    end

end
function stage_select:render()
    if self.alpha == 0 then
        return
    end
    local t = self.timer
    local ui = ui
    local Pos = self.pos
    SetViewMode("ui")
    ui:DrawBack(self.alpha, self.timer)
    local alpha = self.alpha
    local x
    local width = self.moveUnit / 2 / 1.4
    local pulseUnit = self.pulseUnit
    for i, u in pairs(self.stage_selects) do
        x = self.x + self.ox + (i - Pos) * self.moveUnit
        if x > -width and x < self.x * 2 + width then
            local colorindex = self.unlocked_day[i] and 1 or 0.3
            if i == Pos then
                u.pulse = u.pulse + (-u.pulse + (1 + self.select_buling)) * 0.1
            else
                u.pulse = u.pulse + (-u.pulse) * 0.1
                colorindex = colorindex * 0.5
            end
            local pulse = u.pulse
            local way = sign(i - Pos) * pulseUnit * (1 - pulse + self.select_buling)
            local x1, x2 = x - width - pulseUnit * pulse + way, x + width + pulseUnit * pulse + way
            local y1, y2 = self.y - 140 - 30 * pulse, self.y + 140 + 30 * pulse
            local r, g, b = sp:HSVtoRGB(tonumber(u.diff or 2) * 18 + t / 2 + x / 30, 1, 1)
            for l = 1, 16 do
                SetImageState(white, "mul+add", (17 - l) * alpha, r * colorindex, g * colorindex, b * colorindex)
                RenderRect("white", x1 - l, x2 + l, y1 - l, y2 + l)
            end
            if u.tex and CheckRes("tex", u.tex) then
                misc.RenderTexInRect(u.tex, x1, x2, y1, y2, 0, 0, 0, 0.7, 0.7, "",
                        Color(255 * alpha, 120 * colorindex, 120 * colorindex, 120 * colorindex))
            end
            SetImageState(white, "", 255 * alpha, 255 * colorindex, 255 * colorindex, 255 * colorindex)

            misc.RenderOutLine(white, x1, x2, y2, y1, 0, 2)

            ui:RenderText("title", u.title, x + way, self.y - 90 - 50 * pulse, 0.4 + 1.1 * pulse,
                    Color(255 * alpha, 255 * colorindex, 255 * colorindex, 255 * colorindex), "centerpoint")
            ui:RenderText("title", ("<%d>"):format(u.id), x + way, self.y + 130 + 20 * pulse, 0.5 + 0.7 * pulse,
                    Color(255 * alpha, 255 * colorindex, 255 * colorindex, 255 * colorindex), "centerpoint")
            if not self.unlocked_day[i] then
                ui:RenderText("title", "Locked", x + way, self.y, 0.7 + 1 * pulse,
                        Color(255 * alpha, 255 * colorindex, 255 * colorindex, 255 * colorindex), "centerpoint")
            end
        end

    end

    menu:RenderExit(0, 30, 540, 510, self.alpha)
end

for i = 1, 4 do
    LoadTexture(("title_pl%d"):format(i), ("THlib\\UI\\title_pl%d.png"):format(i))
end
LoadImageFromFile("weapon_arrow", "THlib\\UI\\weapon_arrow.png")
LoadImageFromFile("general_button", "THlib\\UI\\general_button.png")

player_system_select = Class(object)
function player_system_select:fresh()
    self.unlocksystem = {}
    self.unlockplayer = { true, scoredata.UnlockChiruno or "前往商店购买解锁", scoredata.UnlockAya or "前往商店购买或通关解锁", true }
    for i, p in ipairs(scoredata.UnlockSystem) do
        self.unlocksystem[i] = p or "前往商店购买解锁"
    end
    self.keyname = KeyCodeToName()
end
function player_system_select:init(exit_func)
    self.fresh = player_system_select.fresh
    self.alpha = 0
    self.exit_func = exit_func
    self.bound = false
    self.locked = true
    self.pos1 = scoredata.player_select or 1
    self.pos2 = 1
    self:fresh()
    self.title = "选择玩家与系统"
    self.orot = 0
    self.oy = 0
    self.liney = 45
    self.tri = 1
    self.wa_index = { 0, 0, 0, 0 }
    function self:settri()
        self.tri = 0
        task.New(self, function()
            for i = 1, 10 do
                self.tri = sin(i * 9)
                task.Wait()
            end
        end)
    end
    self.playername = { "博丽灵梦", "琪露诺", "射命丸文", "雾雨魔理沙" }
    self.systemdata = SystemList
    self.system_selectid = sp:CopyTable(scoredata.system_selectid or { })
    self.colindex = 0
    self.maxcolindex = 0
    self.state = "stage"
    function self:yes()
        if self.unlockplayer[self.pos1] == true then
            scoredata.player_select = self.pos1
            lstg.var.player_name = player_list[self.pos1][2]
            lstg.var.rep_player = player_list[self.pos1][3]
            lstg.var.current_system = ""
            for i, u in pairs(self.system_selectid) do
                if u then
                    lstg.var.current_system = lstg.var.current_system .. tostring(i + 64):char()
                end
            end
            scoredata.system_selectid = sp:CopyTable(self.system_selectid)

            self.exit_func(self.state)
            PlaySound("ok00")
        else
            New(info, "玩家未解锁；请" .. self.unlockplayer[self.pos1])
            PlaySound("invalid")
        end
    end
    function self:no()
        self.exit_func()
        PlaySound("cancel00")
    end
    function self:setsystem()
        if self.unlocksystem[self.pos2] == true then
            for i = 1, self.pos2 - 1 do
                self.system_selectid[i] = self.system_selectid[i] or false
            end--以防传入scoredata时出什么毛病
            self.system_selectid[self.pos2] = not self.system_selectid[self.pos2]
            PlaySound("ok00")
        else
            New(info, "系统未解锁；请" .. self.unlocksystem[self.pos2])
            PlaySound("invalid")
        end
    end
    function self:addpos1(num)
        self.pos1 = sp:TweakValue(self.pos1 + num, 4, 1)
        self.orot = self.orot - 90 * num
        self:settri()
        self.wa_index[(num < 0) and 1 or 2] = 1
        PlaySound("select00")
    end
    function self:addpos2(num)
        self.pos2 = sp:TweakValue(self.pos2 + num, SYSTEM_COUNT, 1)
        self.oy = self.oy - self.liney * num
        self.wa_index[(num < 0) and 3 or 4] = 1
        PlaySound("select00")
    end
end
function player_system_select:frame()
    task.Do(self)
    self.orot = self.orot - self.orot * 0.1
    self.oy = self.oy - self.oy * 0.1
    self.colindex = self.colindex + (-self.colindex + self.maxcolindex) * 0.2
    for i in ipairs(self.wa_index) do
        self.wa_index[i] = self.wa_index[i] - self.wa_index[i] * 0.1
    end
    if self.locked then
        return
    end
    local mouse = ext.mouse
    menu:Updatekey()
    menu:ControlExit(0, 30, 540, 510)
    if menu:keyYes() then
        self:yes()
    elseif GetLastKey() == setting.keys.special then
        self:setsystem()
    elseif menu:keyNo() then
        self:no()
    else
        if menu:keyLeft() then
            self:addpos1(-1)
        end
        if menu:keyRight() then
            self:addpos1(1)
        end
        if menu:keyUp() then
            self:addpos2(-1)
        end
        if menu:keyDown() then
            self:addpos2(1)
        end
        self.maxcolindex = 0
        local mx, my, r = 240, 250, 155 + sin(self.timer * 3) * 2
        if Dist(mouse.x, mouse.y, mx, my) < r then
            if mouse._wheel ~= 0 then
                self:addpos1(-sign(mouse._wheel))
            end
            if mouse:isDown(1) then
                local a = (Angle(mouse.x, mouse.y, mx, my) - self.orot) % 360
                self:addpos1((a >= 225 and a < 315) and 0 or (a >= 135 and a < 225) and 1 or (a >= 45 and a < 135) and 2 or -1)
            end
        elseif sp.math.PointBoundCheck(mouse.x, mouse.y, 480 - 60, 480 + 60, 30, 60) then
            if mouse:isDown(1) then
                self:yes()
            end
            self.maxcolindex = 1
        elseif Dist(mouse.x, mouse.y, 240 + r + 45, 250) < 30 then
            if mouse:isDown(1) then
                self:addpos1(1)
            end
        elseif Dist(mouse.x, mouse.y, 240 - r - 45, 250) < 30 then
            if mouse:isDown(1) then
                self:addpos1(-1)
            end
        elseif Dist(mouse.x, mouse.y, 880, 420) < 30 then
            if mouse:isDown(1) then
                self:addpos2(-1)
            end
        elseif Dist(mouse.x, mouse.y, 880, 120) < 30 then
            if mouse:isDown(1) then
                self:addpos2(1)
            end
        else
            if mouse._wheel ~= 0 then
                self:addpos2(-sign(mouse._wheel))
            end
            if mouse:isDown(1) then
                local lines = 8
                for k = -lines, lines do

                    if abs(270 - k * self.liney - mouse.y) < self.liney / 2 then
                        if k == 0 then
                            self:setsystem()
                        else
                            self:addpos2(k)
                        end
                    end
                end
            end
        end
    end
end
function player_system_select:render()
    if self.alpha == 0 then
        return
    end
    local Alpha = self.alpha
    ui:DrawBack(Alpha, self.timer)
    menu:RenderExit(0, 30, 540, 510, Alpha)
    local mx, my, r = 240, 250, 155 + (cur_setting.easyrender and 0 or sin(self.timer * 3) * 2)
    ui:RenderText("title", self.title, Alpha * 200 - 100, 460, 1.25,
            Color(255 * Alpha, 230, 230, 230), "centerpoint")
    SetImageState("bright_line", "mul+add", Alpha * 255, 255, 255, 255)
    Render("bright_line", Alpha * 200 - 100, 446, 0, 0.5, 0.5)

    SetImageState("white", "", Alpha * 150, 52, 52, 52)
    misc.SectorRender(mx, my, 0, r, 0, 360, 40)
    local rot = self.orot + Alpha * 360 - 360
    for i = 0, 3 do
        local pos = sp:TweakValue(i + self.pos1, 4, 1)
        local blk = ((i == 0) and 255 or 52) * ((self.unlockplayer[pos] == true) and 1 or 0.5)
        local col = Color(Alpha * 230, blk, blk, blk)
        local uv1, uv2, uv3, uv4 = { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }
        uv1[1], uv1[2], uv1[4], uv1[5] = mx, my, 256, 256
        uv4[1], uv4[2], uv4[4], uv4[5] = mx, my, 256, 256
        uv1[6], uv2[6], uv3[6], uv4[6] = col, col, col, col
        for a = -4, 4 do
            a = 90 - 90 * i + a * 10 + rot
            uv2[1], uv2[2], uv2[4], uv2[5] = mx + cos(a - 5) * r, my + sin(a - 5) * r, 256 + cos(a - 5) * 256, 256 - sin(a - 5) * 256
            uv3[1], uv3[2], uv3[4], uv3[5] = mx + cos(a + 5) * r, my + sin(a + 5) * r, 256 + cos(a + 5) * 256, 256 - sin(a + 5) * 256
            RenderTexture(("title_pl%d"):format(pos), "", uv1, uv2, uv3, uv4)
        end
        if self.unlockplayer[pos] ~= true then
            local a = 90 - 90 * i + rot
            ui:RenderText("title", "Locked", mx + cos(a) * r / 2, my + sin(a) * r / 2, 1.2, col, "centerpoint")
        end
    end
    SetImageState("white", "", Alpha * 200, 200, 200, 200)
    Render("white", mx, my, rot + 45, r / 8, 3 / 16)
    Render("white", mx, my, rot - 45, r / 8, 3 / 16)
    SetImageState("white", "", Alpha * 200, 200, 200, 200)
    misc.SectorRender(mx, my, r, r + 3, 0, 360, 40)
    ui:RenderText("title", self.playername[self.pos1], mx, my + r, 1,
            Color(255 * Alpha * self.tri, 189, 252, 201), "center", "bottom")

    local lines = 8
    for k = -lines, lines do
        local pos = sp:TweakValue(-k + self.pos2, SYSTEM_COUNT, 1)
        local y = 270 + k * self.liney + self.oy
        local yindex = abs(y - 270) / self.liney / lines
        local x = 780 - task.SetMode[2](yindex) * 100 * Alpha
        local size = 1 - yindex * 0.5
        local alpha = (1 - yindex) * Alpha
        local blk = (k == 0) and 255 or 150
        local unit = self.systemdata[pos]
        local img = ("stage_pic%d"):format(unit.pic)
        local R, G, B = blk, blk, blk
        if self.unlocksystem[pos] ~= true then
            R, G, B = 125, 64, 57
            ui:RenderText("title", "locked", x - 40 - 20, y, 0.8, Color(alpha * 255, 100, 100, 100), "right", "vcenter")
        elseif self.system_selectid[pos] then
            R, G, B = 189, 252, 201
            ui:RenderText("title", "√", x - 40 - 20, y, 1, Color(alpha * 255, R, G, B), "right", "vcenter")
        end
        SetImageState("bright_line", "mul+add", alpha * 255, R, G, B)
        Render("bright_line", x + 47, y - 13, 0, 0.5, 0.3)
        ui:RenderText("title", unit.title, x, y, size, Color(alpha * 255, R, G, B), "left", "vcenter")
        SetImageState(img, "", alpha * 255, blk, blk, blk)
        Render(img, x - 40, y, 0, 15 / 256)
        SetImageState("white", "", alpha * 255, blk, blk, blk)
        misc.RenderOutLine("white", x - 40 - 15, x - 40 + 15, y - 15, y + 15, 0, 1)
    end
    ui:RenderText("title", ("按%s键选择系统"):format(self.keyname[setting.keys.special]),
            930, 83 + Alpha * 400, 1, Color(Alpha * (155 + 50 * sin(self.timer * 4)), 255, 255, 255), "right")

    local wa = self.wa_index
    SetImageState("weapon_arrow", "", Alpha * (150 + wa[1] * 75), 175 - wa[1] * 75, 175, 175 - wa[1] * 75)
    Render("weapon_arrow", 240 - r - 45, 250, 0, 0.8 + wa[1] * 0.1)
    SetImageState("weapon_arrow", "", Alpha * (150 + wa[2] * 75), 175 - wa[2] * 75, 175, 175 - wa[2] * 75)
    Render("weapon_arrow", 240 + r + 45, 250, 180, 0.8 + wa[2] * 0.1)
    SetImageState("weapon_arrow", "", Alpha * (150 + wa[3] * 75), 175 - wa[3] * 75, 175, 175 - wa[3] * 75)
    Render("weapon_arrow", 880, 420, 270, 0.8 + wa[3] * 0.1)
    SetImageState("weapon_arrow", "", Alpha * (150 + wa[4] * 75), 175 - wa[4] * 75, 175, 175 - wa[4] * 75)
    Render("weapon_arrow", 880, 120, 90, 0.8 + wa[4] * 0.1)

    SetImageState("general_button", "", Alpha * 200, 255, 255, 255)
    Render("general_button", 480, 45, 0, 0.3 + self.colindex * 0.05)
    ui:RenderText("title", ("准备就绪(%s)"):format(self.keyname[setting.keys.shoot]), 480, 45, 1,
            Color(Alpha * 255, 255, 255, 255 - self.colindex * 100), "centerpoint")

end

local valid
local info = Class(object, { frame = task.Do })
function info:init(text, w, h)
    if IsValid(valid) then
        if text == valid.text then
            object.RawDel(self)
            return
        else
            object.Del(valid)
        end
    end
    valid = self
    self.bound = false
    self.colli = false
    object.init(self, 480, 270, GROUP.GHOST, 0)
    self.text = text
    self.w = w or sp.string(text):GetLength() * 5 + 3
    self.h = h or 20
    self.alpha = 255
    task.New(self, function()
        task.Wait(60)
        if valid == self then
            valid = nil
        end
        for i = 1, 60 do
            self.alpha = 255 - 255 * sin(i * 1.5)
            task.Wait()
        end
        Del(self)
    end)
end
function info:del()
    valid = nil
end
function info:render()
    SetImageState("white", "", self.alpha / 2, 0, 0, 0)
    RenderRect("white", self.x - self.w, self.x + self.w, self.y - self.h, self.y + self.h)
    ui:RenderText("title", self.text, self.x, self.y, 1, Color(self.alpha, 255, 255, 255), "centerpoint")
end
_G.info = info

------------------------------------------------------------
Include("THlib\\UI\\menus\\menu_obj.lua")
Include("THlib\\UI\\menus\\music_bar.lua")
Include("THlib\\UI\\menus\\manual.lua")
Include("THlib\\UI\\menus\\KeySettings.lua")
Include("THlib\\UI\\menus\\achievement.lua")
Include("THlib\\UI\\menus\\system_store.lua")
Include("THlib\\UI\\menus\\scpr_menu.lua")
Include("THlib\\UI\\menus\\replay_menu.lua")
Include("THlib\\UI\\menus\\game_setting.lua")
Include("THlib\\UI\\menus\\playdata.lua")