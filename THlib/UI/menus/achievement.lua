
---@class Achievement
Achievement = Class(object)
function Achievement:init(exitFunc)
    self.x, self.y = 960, 540
    self.alpha = 0
    self.bound = false
    self.locked = true
    self.list = {}
    self.cache = {}
    self.maxdx = 15
    self.dxt = 5
    self.pos = 1
    self.exit_func = exitFunc
    self.tri = 0
    self.tri2 = 1
    self.ox = 0
    ------------------------------------------

    self.now = nil
    self.select = nil
    self.rank_color = sp:CopyTable(ext.achievement.rank)
    setmetatable(self.rank_color, { __index = function(t, k)
        return t[(k - 1) % #t + 1]
    end })
    self.rank_power = { 1, 3, 5, 10, 25, 50 }
    self.rank_select = { "简易[+1]", "微妙[+3]", "精良[+5]", "优质[+10]", "传说[+25]", "非人类[+50]" }
    setmetatable(self.rank_select, { __index = function(t, k)
        return t[(k - 1) % #t + 1]
    end })
    self.rank_pos = 1
    Achievement.Refresh(self)
    self.Cget, self.Ccount = Achievement.GetCount(self.list)
    self.Cscore = self.Cget * self.rank_power[self.pos]
    function self:refreshlist()
        self.list = self.mainlist[self.rank_pos]
        self.pos = min(self.pos, #self.list)
        self._list, self._pos = sp:GetListSection(self.list, 11, self.pos, 7)
        self.now = nil
        self.Cget, self.Ccount = Achievement.GetCount(self.list)
        self.Cscore = self.Cget * self.rank_power[self.rank_pos]
        task.New(self, function()
            for i = 1, 10 do
                self.tri2 = sin(i * 9)
                task.Wait()
            end
        end)
    end
end
function Achievement.GetCount(list)
    local get = 0
    for _, m in ipairs(list) do
        if m.IsGet then
            get = get + 1
        end
    end
    return get, #list
end
function Achievement:frame()
    task.Do(self)

    for i, o in ipairs(self.list) do
        if i == self.pos then
            o.dx = o.dx + (self.maxdx - o.dx) * 0.08
        else
            if scoredata.NoticeAchievement[o.real_id] then
                o.dx = o.dx + (self.maxdx / 2 - o.dx) * 0.08
            else
                o.dx = o.dx - o.dx * 0.08
            end
        end
    end
    if self.locked then
        return
    end
    local mouse = ext.mouse
    menu:Updatekey()
    menu:ControlExit(0, 30, 540, 510)

    self.ox = self.ox - self.ox * 0.08
    self.pos = sp:TweakValue(self.pos, #self.list, 1)
    if menu:keyYes() then
        self.now = self.list[self.pos]
        self.select = self.pos
        scoredata.NoticeAchievement[self.now.real_id] = false
        task.New(self, function()
            for i = 1, 15 do
                self.tri = sin(i * 6)
                task.Wait()
            end
        end)
    elseif menu:keyNo() then
        PlaySound("cancel00", 0.3)
        if self.exit_func then
            self.exit_func()
        end
    else
        if menu:keyUp() then
            self.pos = self.pos - 1
            PlaySound("select00", 0.3)
        end
        if menu:keyDown() then
            self.pos = self.pos + 1
            PlaySound("select00", 0.3)
        end
        if menu:keyLeft() then
            self.pos_changed = ui.menu.shake_time
            self.rank_pos = sp:TweakValue(self.rank_pos - 1, #self.rank_select, 1)
            self.ox = self.ox - 170
            self:refreshlist()
            PlaySound('select00', 0.3)
        end
        if menu:keyRight() then
            self.pos_changed = ui.menu.shake_time
            self.rank_pos = sp:TweakValue(self.rank_pos + 1, #self.rank_select, 1)
            self.ox = self.ox + 170
            self:refreshlist()
            PlaySound('select00', 0.3)
        end
        if sp.math.PointBoundCheck(mouse.x, mouse.y, 0, 960, 460, 440) then
            if mouse:isDown(1) then
                for i = -3, 3 do
                    if i ~= 0 and abs(mouse.x - (480 + 170 * i + self.ox)) < 75 then
                        self.rank_pos = sp:TweakValue(self.rank_pos + i, #self.rank_select, 1)
                        self.ox = self.ox + 170 * i
                        self:refreshlist()
                        PlaySound("select00")
                    end
                end
            end
            if mouse._wheel ~= 0 then
                self.rank_pos = sp:TweakValue(self.rank_pos - sign(mouse._wheel), #self.rank_select, 1)
                self.ox = self.ox - sign(mouse._wheel) * 170
                self:refreshlist()
                PlaySound("select00")
            end
        elseif sp.math.PointBoundCheck(mouse.x, mouse.y, 90, 670, 439, 186) then
            if mouse:isDown(1) then
                for p = 1, 11 do
                    if abs(mouse.y - (456 - 22 * p - 6)) < 11 then
                        self.pos = Forbid(self.pos + (p - self._pos), 1, #self.list)
                        PlaySound("select00", 0.3)
                        self.now = self.list[self.pos]
                        self.select = self.pos
                        scoredata.NoticeAchievement[self.now.real_id] = false
                        task.New(self, function()
                            for i = 1, 15 do
                                self.tri = sin(i * 6)
                                task.Wait()
                            end
                        end)
                    end
                end
            end
            if mouse._wheel ~= 0 then
                self.pos = self.pos - sign(mouse._wheel)
                PlaySound("select00", 0.3)
            end
        end
    end
    self._list, self._pos = sp:GetListSection(self.list, 11, self.pos, 7)

end
function Achievement:render()
    if self.alpha == 0 then
        return
    end

    ui:DrawBack(self.alpha, self.timer)
    OriginalSetImageState("white", "",
            Color(0, 0, 0, 0),
            Color(200 * self.alpha, 0, 0, 0),
            Color(200 * self.alpha, 0, 0, 0),
            Color(0, 0, 0, 0))
    RenderRect("white", 76, 480, 460, 440)
    RenderRect("white", 884, 480, 460, 440)
    SetImageState("white", "", 255, 0,0,0)
    for i = -3, 3 do
        ui:RenderText("title", self.rank_select[i + self.rank_pos], 480 + 170 * i + self.ox, 450, 1,
                Color((((i == 0) and 255) or 120) * self.alpha, unpack(self.rank_color[i + self.rank_pos])), "centerpoint")
    end
    SetImageState("white", '', self.alpha * 150, 0, 0, 0)
    RenderRect("white", 120, 840, 439, 186)
    ui:RenderText("title", scoredata.PlayerBrand, 480, 475, 1,
            Color(255 * self.alpha, 255, 255, 255), "centerpoint")
    local text = "(%d/%d)\n%0.1f%%"
    ui:RenderText("title", text:format(self.Cget, self.Ccount, self.Cget / self.Ccount * 100), 60, 186, 1,
            Color(255 * self.alpha * self.tri2, unpack(self.rank_color[self.rank_pos])), "center", "bottom")
    ui:RenderText("title", self.Cscore, 60, 230, 1,
            Color(255 * self.alpha * self.tri2, unpack(self.rank_color[self.rank_pos])), "center", "bottom")
    ui:RenderText("title", text:format(self.Tget, self.Tcount, self.Tget / self.Tcount * 100), 900, 186, 1,
            Color(255 * self.alpha, 150 + sin(self.timer / 2) * 100, 150 + sin(self.timer) * 100, 150 + cos(self.timer / 4) * 100), "center", "bottom")
    ui:RenderText("title", self.Tscore, 900, 230, 1,
            Color(255 * self.alpha, 150 + cos(self.timer / 2) * 100, 150 + cos(self.timer) * 100, 150 + sin(self.timer / 4) * 100), "center", "bottom")
    local dy = 22
    local x, y = 130, 434
    local name, getway
    for i, o in ipairs(self._list) do
        name = string.format("%02d. %s %s %s", o.id,
                o.IsGet and o.name:Get() or "? ? ?",
                o.hide and "(hide)" or "",
                scoredata.NoticeAchievement[o.real_id] and "[New!!!]" or "")
        if self._pos == i then
            ui:RenderText("achievement", name, x + o.dx, y, 1 + o.dx / 200,
                    Color(self.tri2 * self.alpha * 255, o.rank[1] * (o.hide and 0.8 or 1), o.rank[2], o.rank[3]), "left", "top")
        else
            local scale = scoredata.NoticeAchievement[o.real_id] and (0.7 + 0.3 * sin(self.timer * 2)) or 0.6
            ui:RenderText("achievement", name, x + o.dx, y, 1 + o.dx / 200,
                    Color(self.tri2 * self.alpha * 255, o.rank[1] * scale * (o.hide and 0.8 or 1), o.rank[2] * scale, o.rank[3] * 0.6), "left", "top")
        end
        y = y - dy
    end
    SetImageState("white", '', self.alpha * 200, 0, 0, 0)
    RenderRect("white", 50, 910, 186, 10)
    if self.now then
        local now = self.now
        local y0 = 160, 165
        name = string.format("%02d. %s", now.id, (now.IsGet and now.name:Get() or "? ? ?"))
        if now.IsGet or DEBUG then
            getway = now.getway
            getway = getway .. (now.hide and " (hide)" or "")
        else
            getway = (now.hide and "(hide)" or now.getway)
        end
        ui:RenderText("achievement", name, 480, y0 + 13,
                self.alpha * self.tri, Color(self.alpha * self.tri * 255, unpack(now.rank)), "center", "top")
        y = 90
        ui:RenderText("achievement", string.format("获取方式：%s", getway),
                898, y + 64, 1, Color(self.alpha * 255 * self.tri, 255, 255, 255), "right", "top")
        for _, str in ipairs(now.info) do
            str = now.IsGet and str or "? ? ?"
            ui:RenderText("achievement", string.format("%s", str),
                    70, y + 64, 1, Color(self.alpha * 255 * self.tri, 255, 255, 255), "left", "top")
            y = y - dy
        end
    end
    menu:RenderExit(0, 30, 540, 510, self.alpha)
end
function Achievement:Refresh()
    local sp = sp
    self.cache = AchievementInfo
    self.mainlist = {}
    self.list = {}
    local o = 0
    for i, list in pairs(self.cache) do
        if not self.mainlist[list[5]] then
            self.mainlist[list[5]] = {}
        end
        table.insert(self.mainlist[list[5]], {
            real_id = i,
            id = i,
            name = sp.string(list[1]),
            IsGet = scoredata["Achievement"][i],
            getway = list[2],
            info = list[3],
            dx = 0,
            hide = list[4],
            rank = ext.achievement.rank[list[5]],
            sort = list[5]
        })
        o = o + 1
    end
    for _, m in ipairs(self.mainlist) do
        table.sort(m, function(a, b)
            if a.hide ~= b.hide then
                return b.hide and not a.hide
                --elseif a.name:GetLength() ~= b.name:GetLength() then
                --    return a.name:GetLength() < b.name:GetLength()--不使用字符长度排序
            else
                return a.id < b.id
            end
        end)
        for i, n in ipairs(m) do
            n.id = i
        end
    end
    self.rank_pos = sp:TweakValue(self.rank_pos, #self.rank_select, 1)
    self.list = self.mainlist[self.rank_pos]
    self._list, self._pos = sp:GetListSection(self.list, 11, self.pos, 7)
    if self.now then
        self.now = self.list[self.pos]
    end
    self.Tget = 0
    self.Tcount = o
    for _, p in ipairs(self.mainlist) do
        self.Tget = self.Tget + Achievement.GetCount(p)
    end
    self.Tscore = 0
    for i, p in ipairs(self.mainlist) do
        self.Tscore = self.Tscore + Achievement.GetCount(p) * self.rank_power[i]
    end
end