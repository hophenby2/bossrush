---@class playdata_menu
playdata_menu = Class(object)
function playdata_menu:init(exitFunc)
    self.x, self.y = 960, 540
    self.alpha = 0
    self.bound = false
    self.locked = true
    self.exit_func = exitFunc
    self.offy1 = 0
    self._offy1 = 0
    self.line_h_1 = 25
    playdata_menu.refresh(self)

end
function playdata_menu:refresh()
    local data = scoredata
    local total_playtime = data.Player_playtime[1] + data.Player_playtime[2] + data.Player_playtime[3] + data.Player_playtime[4]
    local total_finish = data.AllFinishCount[1] + data.AllFinishCount[2] + data.AllFinishCount[3] + data.AllFinishCount[4]
    local function frameTodate(f)
        local date = {}
        local f1 = f % 60
        date[2] = (f - f1) / 60
        date[1] = f1
        local f2 = date[2] % 60
        date[3] = (date[2] - f2) / 60
        date[2] = f2
        local f3 = date[3] % 60
        date[4] = (date[3] - f3) / 60
        date[3] = f3
        local f4 = date[4] % 60
        date[5] = (date[4] - f4) / 60
        date[4] = f4
        return date
    end
    local AchievementData={}
    Achievement.init(AchievementData)
    self.infodata = {
        { "游戏运行时长：", function()
            local time = data.Duration
            return ("%d天%d时%d分%d秒"):format(time[5], time[4], time[3], time[2])
        end },
        { "连续登录天数：", function()
            return data.ContinuousLogin
        end },
        { "成就获得个数", function()
            return ("%d / %d"):format(AchievementData.Tget,AchievementData.Tcount)
        end },
        { "资金力", function()
            return data.money
        end },
        { nil, load("") },
        { "总游玩时长：", function()
            local time = frameTodate(total_playtime)
            return ("%d天%d时%d分%d秒"):format(time[5], time[4], time[3], time[2])
        end, },
        { "博丽灵梦 游玩时长：", function()
            local time = frameTodate(data.Player_playtime[1])
            return ("%d天%d时%d分%d秒"):format(time[5], time[4], time[3], time[2])
        end, },
        { "琪露诺 游玩时长：", function()
            local time = frameTodate(data.Player_playtime[2])
            return ("%d天%d时%d分%d秒"):format(time[5], time[4], time[3], time[2])
        end, },
        { "射命丸文 游玩时长：", function()
            local time = frameTodate(data.Player_playtime[3])
            return ("%d天%d时%d分%d秒"):format(time[5], time[4], time[3], time[2])
        end, },
        { "雾雨魔理沙 游玩时长：", function()
            local time = frameTodate(data.Player_playtime[4])
            return ("%d天%d时%d分%d秒"):format(time[5], time[4], time[3], time[2])
        end, },
        { nil, load("") },
        { "总通关次数", function()
            return total_finish
        end },
        { "博丽灵梦 通关次数", function()
            return data.AllFinishCount[1]
        end },
        { "琪露诺 通关次数", function()
            return data.AllFinishCount[2]
        end },
        { "射命丸文 通关次数", function()
            return data.AllFinishCount[3]
        end },
        { "雾雨魔理沙 通关次数", function()
            return data.AllFinishCount[4]
        end }
    }
end
function playdata_menu:frame()
    task.Do(self)

    if not self.locked then
        local mouse = ext.mouse
        menu:Updatekey()
        menu:ControlExit(0, 30, 540, 510)
        if menu:keyNo() then
            PlaySound("cancel00", 0.3)
            if self.exit_func then
                self.exit_func()
            end
        end

        local alpha = self.alpha
        local x1, x2, y1, y2, h
        x1, x2, y1, y2 = 480 - 250 * alpha, 480 + 250 * alpha, 30, 420
        h = y2 - y1
        self._offy1 = self._offy1 + (-self._offy1 + Forbid(self._offy1, 0, max(self.line_h_1 * #self.infodata - h, 0))) * 0.3
        self.offy1 = self.offy1 + (-self.offy1 + self._offy1) * 0.3
        if sp.math.PointBoundCheck(mouse.x, mouse.y, x1, x2, y1, y2) then
            if mouse._wheel ~= 0 then
                self._offy1 = self._offy1 - sign(mouse._wheel) * self.line_h_1 * 4
                PlaySound("select00")
            end
        end
        if menu:keyUp() then
            self._offy1 = self._offy1 - self.line_h_1 * 4
            PlaySound("select00")
        end
        if menu:keyDown() then
            self._offy1 = self._offy1 + self.line_h_1 * 4
            PlaySound("select00")
        end
    end
    --self.pos = sp:TweakValue(self.pos, #self.list, 1)
    --self._list, self._pos = sp:GetListSection(self.list, 4, self.pos, 2)
end
function playdata_menu:render()
    if self.alpha == 0 then
        return
    end
    SetViewMode("ui")
    ui:DrawBack(self.alpha, self.timer)
    do
        local alpha = self.alpha
        local x1, x2, y1, y2, Y


        x1, x2, y1, y2 = 480 - 220 * alpha, 480 + 220 * alpha, 30, 450
        SetImageState("white", "", alpha * 180, 10, 10, 10)
        RenderRect("white", x1, x2, y1, y2)
        SetImageState("white", "", alpha * 255, 255, 255, 255)
        misc.RenderOutLine("white", x1, x2, y2, y1, 0, 2)
        SetRenderRect(x1, x2, y1 - self.offy1, y2 - self.offy1, x1, x2, y1, y2)
        Y = y2
        RenderRect("white", x1, x2, Y - 0.5, Y + 0.5)
        for _, t in ipairs(self.infodata) do
            if Y < y1 - self.offy1 then
                break
            end
            Y = Y - self.line_h_1
            if Y < y2 - self.offy1 then
                local r, g, b = sp:HSVtoRGB(Y, 0.2, 1)
                ui:RenderText("title", t[1] or "", x1 + 3, Y + self.line_h_1 - 3, 0.9, Color(alpha * 255, r, g, b), "top", "left")
                ui:RenderText("title", t[2]() or "", x2 - 3, Y + self.line_h_1 - 3, 0.9, Color(alpha * 255, r, g, b), "top", "right")
                RenderRect("white", x1, x2, Y - 0.5, Y + 0.5)
            end

        end
        SetViewMode("ui")
    end --其他
    menu:RenderExit(0, 30, 540, 510, self.alpha)
end