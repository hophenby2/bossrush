local REPLAY_USER_NAME_MAX = 8
local function FetchReplaySlots()
    local ret = {}
    ext.replay.RefreshReplay()

    for i = 1, ext.replay.GetSlotCount() do
        local text = {}
        local slot = ext.replay.GetSlot(i)
        if slot then
            -- 使用第一关的时间作为录像时间
            local date = os.date("!%Y/%m/%d", slot.stages[1].stageDate + setting.timezone * 3600)

            -- 统计总分数
            local totalScore = 0
            local diff, stage_num = 0, 0
            local tmp
            for j, k in ipairs(slot.stages) do
                totalScore = totalScore + slot.stages[j].score
                diff = string.match(k.stageName, '^.+@(.+)$')
                tmp = string.match(k.stageName, '^(.+)@.+$')
                tmp = ui.menu.sntext[tmp] or tmp
            end
            diff = (diff == 'Spell Practice') and '符卡练习' or "关卡"
            stage_num = (tmp == 'Spell Practice') and "SC" or tmp
            if slot.group_finish == 1 then
                stage_num = 'All'
            end
            text = { string.format('No.%02d', i), slot.userName, date, slot.stages[1].stagePlayer, diff, stage_num }
        else
            text = { string.format('No.%02d', i), '- - - - - - - -', ' ---- / -- / -- ', '--------', '--------', '---' }
        end
        table.insert(ret, text)
    end
    return ret
end

------------------replay_saver-------------------------
local _keyboard = {}
do
    for i = 65, 90 do
        table.insert(_keyboard, i)
    end
    for i = 97, 122 do
        table.insert(_keyboard, i)
    end
    for i = 48, 57 do
        table.insert(_keyboard, i)
    end
    for _, i in ipairs({ 43, 45, 61, 46, 44, 33, 63, 64, 58, 59, 91, 93, 40, 41, 95, 47, 123, 125, 124, 126, 94 }) do
        table.insert(_keyboard, i)
    end
    for i = 35, 38 do
        table.insert(_keyboard, i)
    end
    for _, i in ipairs({ 42, 92, 127, 34 }) do
        table.insert(_keyboard, i)
    end
end
---@class replay_saver
replay_saver = Class(object)

function replay_saver:init(stages, finish, exitCallback)
    self.layer = LAYER.TOP
    self.group = GROUP.GHOST
    self.bound = false
    self.x = screen.width * 0.5
    self.y = screen.height * 0.5
    self.alpha = 0
    self.locked = true
    self.finish = finish or 0
    self.stages = stages
    self.exitCallback = exitCallback
    self.tri = 1
    self.shakeValue = 0
    self.ctri = function()
        task.New(self, function()
            for i = 1, 10 do
                self.tri = sin(i * 9)
                task.Wait()
            end
        end)
    end
    self.state = 0
    self.state1Selected = 1
    self.state1Text = FetchReplaySlots()
    self.state2CursorX = 0
    self.state2CursorY = 0
    self.state2UserName = ""
end

function replay_saver:frame()
    task.Do(self)
    if self.locked then
        return
    end

    if self.shakeValue > 0 then
        self.shakeValue = self.shakeValue - 1
    end
    local mouse = ext.mouse
    menu:Updatekey()
    menu:ControlExit(0, 30, 540, 510)
    -- 控制逻辑
    local count = ext.replay.GetSlotCount()
    if self.state == 0 then
        self.state1Selected = sp:TweakValue(self.state1Selected, count, 1)
        local function Yes(self)
            self.state = 1
            scoredata.repsaver = scoredata.repsaver or ""
            self.state2UserName = scoredata.repsaver
            if self.state2UserName ~= "" then
                self.state2CursorX = 12
                self.state2CursorY = 6
            else
                self.state2CursorX = 0
                self.state2CursorY = 0
            end
            PlaySound("ok00", 0.3)
        end
        if menu:keyUp() then
            self.ctri()
            self.state1Selected = self.state1Selected - 1
            self.shakeValue = ui.menu.shake_time
            PlaySound('select00', 0.3)
        elseif menu:keyDown() then
            self.ctri()
            self.state1Selected = self.state1Selected + 1
            self.shakeValue = ui.menu.shake_time
            PlaySound('select00', 0.3)
        elseif menu:keyYes() then
            Yes(self)
        elseif menu:keyNo() then
            if self.exitCallback then
                self.exitCallback()
            end
            PlaySound('cancel00', 0.3)
        end
        if mouse:isDown(1) then
            local height = ui.menu.rep_line_height
            local selected = menu:mouseCheck(self.y + (count - 1) * ui.menu.sc_pr_line_height * 0.5, 0, height, count)
            if selected then
                if selected ~= self.state1Selected then
                    self.ctri()
                    self.state1Selected = selected
                    self.shakeValue = ui.menu.shake_time
                    PlaySound('select00', 0.3)
                else
                    Yes(self)
                end
            end
        end
        if mouse._wheel ~= 0 then
            self.ctri()
            self.state1Selected = sp:TweakValue(self.state1Selected + sign(mouse._wheel), count, 1)
            self.shakeValue = ui.menu.shake_time
            PlaySound('select00', 0.3)
        end
    elseif self.state == 1 then
        local function Yes(self)
            if self.state2CursorX == 12 and self.state2CursorY == 6 then
                if self.state2UserName == "" then
                    self.state2UserName = "Anonymous"
                else
                    --由OLC添加，保存rep时菜单用来记录名称的参数
                    scoredata.repsaver = self.state2UserName
                end
                -- 保存录像
                ext.replay.SaveReplay(self.stages, self.state1Selected, self.state2UserName, self.finish)

                if self.exitCallback then
                    self.exitCallback()
                end
                PlaySound("extend", 0.5)
            else
                if self.state2CursorX == 10 and self.state2CursorY == 6 then
                    local char = string.char(0x20)
                    self.state2UserName = self.state2UserName .. char
                    PlaySound('ok00', 0.3)
                elseif self.state2CursorX == 11 and self.state2CursorY == 6 then
                    if #self.state2UserName == 0 then
                        self.state = 0
                    else
                        self.state2UserName = string.sub(self.state2UserName, 1, -2)
                    end
                    PlaySound('cancel00', 0.3)
                elseif #self.state2UserName == REPLAY_USER_NAME_MAX then
                    self.state2CursorX = 12
                    self.state2CursorY = 6
                else
                    local char = string.char(_keyboard[self.state2CursorY * 13 + self.state2CursorX + 1])
                    self.state2UserName = self.state2UserName .. char
                    PlaySound('ok00', 0.3)
                end
            end
        end
        if menu:keyYes() then
            Yes(self)
        elseif menu:keyNo() then
            if #self.state2UserName == 0 then
                self.state = 0
            else
                self.state2UserName = string.sub(self.state2UserName, 1, -2)
            end
            PlaySound('cancel00', 0.3)
        else
            if menu:keyUp() then
                self.state2CursorY = self.state2CursorY - 1
                self.shakeValue = ui.menu.shake_time
                PlaySound('select00', 0.3)
            end
            if menu:keyDown() then
                self.state2CursorY = self.state2CursorY + 1
                self.shakeValue = ui.menu.shake_time
                PlaySound('select00', 0.3)
            end
            if menu:keyLeft() then
                self.state2CursorX = self.state2CursorX - 1
                self.shakeValue = ui.menu.shake_time
                PlaySound('select00', 0.3)
            end
            if menu:keyRight() then
                self.state2CursorX = self.state2CursorX + 1
                self.shakeValue = ui.menu.shake_time
                PlaySound('select00', 0.3)
            end
            if mouse:isDown(1) then
                local width, height = ui.menu.char_width, ui.menu.line_height
                local x, y = (function()
                    for x = 0, 12 do
                        for y = 0, 6 do
                            if abs(mouse.x - (self.x + (x - 5.5) * width)) < width / 2 and abs(mouse.y - (self.y - (y - 3.5) * height)) < height / 2 then
                                return x, y
                            end
                        end
                    end
                end)()
                if x and y then
                    self.state2CursorX = x
                    self.state2CursorY = y
                    Yes(self)
                    PlaySound('select00', 0.3)
                end
            end
            if mouse._wheel ~= 0 then
                self.ctri()
                self.state2CursorX = self.state2CursorX - sign(mouse._wheel)
                if self.state2CursorX == 13 then
                    self.state2CursorY = self.state2CursorY + 1
                    self.state2CursorX = 0
                end
                if self.state2CursorX == -1 then
                    self.state2CursorY = self.state2CursorY - 1
                    self.state2CursorX = 12
                end
                self.shakeValue = ui.menu.shake_time
                PlaySound('select00', 0.3)
            end
            self.state2CursorX = sp:TweakValue(self.state2CursorX, 13, 0)
            self.state2CursorY = sp:TweakValue(self.state2CursorY, 7, 0)
        end


    end
end

function replay_saver:render()
    if self.alpha == 0 then
        return
    end
    SetViewMode('ui')
    ui:DrawBack(self.alpha, self.timer)
    menu:RenderExit(0, 30, 540, 510, self.alpha)
    if self.state == 0 then
        ui:DrawRepText(self.state1Text, self.state1Selected, self.x, self.y + 320 - self.alpha * 320, self.alpha, self.tri)
    elseif self.state == 1 then
        ---- 绘制键盘
        -- 未选中按键
        SetFontState("replay", "", 255 * self.alpha, unpack(ui.menu.unfocused_color))
        for x = 0, 12 do
            for y = 0, 6 do
                if x ~= self.state2CursorX or y ~= self.state2CursorY then
                    RenderText("replay", string.char(_keyboard[y * 13 + x + 1]),
                            self.x + (x - 5.5) * ui.menu.char_width, self.y - (y - 3.5) * ui.menu.line_height + 320 - self.alpha * 320,
                            ui.menu.font_size, 'centerpoint')
                end
            end
        end
        -- 激活按键
        local color = {}
        local k = cos(self.timer * ui.menu.blink_speed) ^ 2
        for i = 1, 3 do
            color[i] = ui.menu.focused_color1[i] * k + ui.menu.focused_color2[i] * (1 - k)
        end
        SetFontState("replay", "", 255 * self.alpha, unpack(color))
        RenderText("replay", string.char(_keyboard[self.state2CursorY * 13 + self.state2CursorX + 1]),
                self.x + (self.state2CursorX - 5.5) * ui.menu.char_width + ui.menu.shake_range * sin(ui.menu.shake_speed * self.shakeValue),
                self.y - (self.state2CursorY - 3.5) * ui.menu.line_height + 320 - self.alpha * 320,
                ui.menu.font_size, "centerpoint")

        -- 标题
        SetFontState("replay", "", 255 * self.alpha, unpack(ui.menu.title_color))
        RenderText("replay", self.state2UserName, self.x, self.y - 5.5 * ui.menu.line_height + 320 - self.alpha * 320, ui.menu.font_size, "centerpoint")
    end
end
----------------------------------------------------------------------------
-------------------------replay_loader--------------------------------------
---@class replay_loader
replay_loader = Class(object)

function replay_loader:init(exitCallback)
    self.layer = LAYER.TOP
    self.group = GROUP.GHOST
    self.bound = false
    self.x = screen.width * 0.5
    self.y = screen.height * 0.5
    self.alpha = 0
    -- 是否可操作
    self.locked = true
    self.tri = 1
    self.ctri = function()
        task.New(self, function()
            for i = 1, 10 do
                self.tri = sin(i * 9)
                task.Wait()
            end
        end)
    end
    self.exitCallback = exitCallback

    self.shakeValue = 0

    self.state = 0
    self.state1Selected = 1
    self.state1Text = {}
    self.state2Selected = 1
    self.state2Text = {}

    replay_loader.Refresh(self)
end

function replay_loader:Refresh()
    self.state1Text = FetchReplaySlots()
end

function replay_loader:frame()
    task.Do(self)
    if self.locked then
        return
    end

    if self.shakeValue > 0 then
        self.shakeValue = self.shakeValue - 1
    end

    local mouse = ext.mouse
    menu:Updatekey()
    menu:ControlExit(0, 30, 540, 510)
    -- 控制逻辑
    local count = ext.replay.GetSlotCount()
    if self.state == 0 then
        self.state1Selected = sp:TweakValue(self.state1Selected, count, 1)
        local function Yes()
            -- 构造关卡列表
            self.ctri()
            local slot = ext.replay.GetSlot(self.state1Selected)
            if slot ~= nil then
                self.state = 1
                self.state2Text = {}
                self.state2Selected = 1
                self.shakeValue = ui.menu.shake_time
                for _, v in ipairs(slot.stages) do
                    local stage = string.match(v.stageName, '^(.+)@.+$')
                    stage = ui.menu.sntext[stage] or stage
                    if stage == "符卡练习" then
                        local var = DeSerialize(v.stageExtendInfo)
                        local group, index = var.sc_group[1], var.sc_group[2]
                        stage = _sc_pr_table[group][index].sc_group[1].card.name
                    end
                    table.insert(self.state2Text, { stage, string.format("%012d", v.score) })
                end
                PlaySound('ok00', 0.3)
            end
        end
        if menu:keyNo() then
            if self.exitCallback then
                self.exitCallback()
            end
            PlaySound('cancel00', 0.3)
        elseif menu:keyYes() then
            Yes()
        elseif menu:keyDown() then
            self.ctri()
            self.state1Selected = self.state1Selected + 1
            self.shakeValue = ui.menu.shake_time
            PlaySound('select00', 0.3)
        elseif menu:keyUp() then
            self.ctri()
            self.state1Selected = self.state1Selected - 1
            self.shakeValue = ui.menu.shake_time
            PlaySound('select00', 0.3)
        else
            if mouse:isDown(1) then
                local height = ui.menu.rep_line_height
                local selected = menu:mouseCheck(self.y + (count - 1) * ui.menu.sc_pr_line_height * 0.5, 0, height, count)
                if selected then
                    if selected ~= self.state1Selected then
                        self.ctri()
                        self.state1Selected = selected
                        self.shakeValue = ui.menu.shake_time
                        PlaySound('select00', 0.3)
                    else
                        Yes()
                    end
                end
            end
            if mouse._wheel ~= 0 then
                self.ctri()
                self.state1Selected = sp:TweakValue(self.state1Selected + sign(mouse._wheel), ext.replay.GetSlotCount(), 1)
                self.shakeValue = ui.menu.shake_time
                PlaySound('select00', 0.3)
            end
        end
    elseif self.state == 1 then
        local slot = ext.replay.GetSlot(self.state1Selected)
        local function Yes()
            -- 转场
            slot = ext.replay.GetSlot(self.state1Selected)
            if self.exitCallback then
                self.exitCallback(slot.path, slot.stages[self.state2Selected].stageName)
            end
            PlaySound('ok00', 0.3)
        end
        self.state2Selected = sp:TweakValue(self.state2Selected, #slot.stages, 1)
        if menu:keyNo() then
            self.shakeValue = ui.menu.shake_time
            self.state = 0
        elseif menu:keyYes() then
            Yes()
        elseif menu:keyUp() then
            self.ctri()
            self.state2Selected = self.state2Selected - 1
            self.shakeValue = ui.menu.shake_time
            PlaySound('select00', 0.3)
        elseif menu:keyDown() then
            self.ctri()
            self.state2Selected = self.state2Selected + 1
            self.shakeValue = ui.menu.shake_time
            PlaySound('select00', 0.3)
        else
            if mouse:isDown(1) then
                local height = ui.menu.rep_line_height
                local selected = menu:mouseCheck(self.y + (#slot.stages - 1) * ui.menu.sc_pr_line_height * 0.5, 0, height, #slot.stages)
                if selected then
                    if selected ~= self.state2Selected then
                        self.ctri()
                        self.state2Selected = selected
                        self.shakeValue = ui.menu.shake_time
                        PlaySound('select00', 0.3)
                    else
                        Yes()
                    end
                end
            end
            if mouse._wheel ~= 0 then
                self.ctri()
                self.state2Selected = sp:TweakValue(self.state2Selected + sign(mouse._wheel), #slot.stages, 1)
                self.shakeValue = ui.menu.shake_time
                PlaySound('select00', 0.3)
            end
        end
    end
end

function replay_loader:render()
    if self.alpha == 0 then
        return
    end

    SetViewMode('ui')
    ui:DrawBack(self.alpha, self.timer)
    if self.state == 0 then
        ui:DrawRepText(self.state1Text, self.state1Selected, self.x, self.y + 320 - self.alpha * 320, self.alpha, self.tri)
    elseif self.state == 1 then
        ui:DrawRepText2(self.state2Text, self.state2Selected, self.x, self.y + 320 - self.alpha * 320, self.alpha, self.tri)
    end
    menu:RenderExit(0, 30, 540, 510, self.alpha)
end