---@class music_bar
music_bar = Class(object)
function music_bar:init()
    self.bound = false
    self.group = GROUP.GHOST
    self.layer = 1
    self.x = 960
    self.y = 540
    self.alpha = 0
    self.locked = true
    self.salpha = 1
    self.text, self.content, self.musicend, self.musicbegin = {}, {}, {}, {}
    self.ox = 0
    self.playmode = scoredata.music_bar_playmode or 2
    self.pmodelist = { "单曲循环", "列表循环", "随机播放" }
    self.ptimer = 240
    self.music_timer = scoredata.music_bar_time or 0
    self.pos = scoredata.music_bar_pos or 1
    scoredata.music_bar_pos = self.pos
    for _, o in ipairs(musicBarList) do
        table.insert(self.text, o[2])
        table.insert(self.content, o[1])
        table.insert(self.musicend, o[3])
        table.insert(self.musicbegin, o[3] - o[4])
    end
    local t = { __index = function(t, k)
        return rawget(t, (k - 1) % #t + 1)
    end }
    setmetatable(self.text, t)
    setmetatable(self.content, t)
    setmetatable(self.musicend, t)
    setmetatable(self.musicbegin, t)
    self.now = self.content[self.pos]
    ext.MusicChange:change(nil, self.now, 20, self.music_timer / 60)

    self.ChangeMusic = function(before, now, time)
        ext.MusicChange:change(before, now, time)
    end
    self.key = { M = KEY.M, F1 = KEY.F1, F2 = KEY.F2, F3 = KEY.F3 }
    self.key_state = {}
    self.last_key_state = {}
    self.openMenu = false
end
function music_bar:frame()
    task.Do(self)
    if self.locked then
        return
    end

    for k, v in pairs(self.key) do
        self.last_key_state[k] = self.key_state[k]
        self.key_state[k] = GetKeyState(v)
    end
    self.ox = self.ox - self.ox * 0.09
    local key = GetLastKey()
    if key == KEY.PERIOD then
        self.ChangeMusic(self.content[self.pos], self.content[self.pos + 1])
        self.pos = self.pos + 1
        self.ox = self.ox + 300
        self.music_timer = 0
        scoredata["music_bar_pos"] = self.pos
        self.now = self.content[self.pos]
        PlaySound('select00', 0.3)
    end
    if key == KEY.COMMA then
        self.ChangeMusic(self.content[self.pos], self.content[self.pos - 1])
        self.pos = self.pos - 1
        self.ox = self.ox - 300
        self.music_timer = 0
        scoredata["music_bar_pos"] = self.pos
        self.now = self.content[self.pos]
        PlaySound('select00', 0.3)
    end
    self.pos = sp:TweakValue(self.pos, #self.content, 1)
    if key == KEY.SPACE then
        local p = ran:Int(1, #self.content)
        while p == self.pos do
            p = ran:Int(1, #self.content)
        end
        self.ChangeMusic(self.content[self.pos], self.content[p])
        self.ox = self.ox + 300 * (p - self.pos)
        self.music_timer = 0
        self.pos = p
        scoredata["music_bar_pos"] = self.pos
        self.now = self.content[self.pos]
        PlaySound('select00', 0.3)
    end

    local mouse = ext.mouse
    local PBC = sp.math.PointBoundCheck

    if PBC(mouse.x, mouse.y, 0, 960, 510, 493) and not self.openMenu then
        menu:Updatekey()
        if mouse:isDown(1) then
            local x
            for i = -3, 3 do
                x = 300 * i + self.ox + 480
                if abs(x - mouse.x) < 150 and i ~= 0 then
                    self.ChangeMusic(self.content[self.pos], self.content[self.pos + i])
                    self.pos = self.pos + i
                    self.ox = self.ox + 300 * i
                    self.music_timer = 0
                    scoredata["music_bar_pos"] = self.pos
                    self.now = self.content[self.pos]
                    PlaySound('select00', 0.3)
                end
            end
        end
        if mouse._wheel ~= 0 then

            local t = -sign(mouse._wheel)
            self.ChangeMusic(self.content[self.pos], self.content[self.pos + t])
            self.pos = self.pos + t
            self.ox = self.ox + 300 * t
            self.music_timer = 0
            scoredata["music_bar_pos"] = self.pos
            self.now = self.content[self.pos]
            PlaySound('select00', 0.3)
        end
    elseif PBC(mouse.x, mouse.y, 18, 943, 493 + 20 * (1 - self.salpha), 485 + 20 * (1 - self.salpha)) then
        if mouse:isPress(1) then
            local timer = self.musicend[self.pos] * (mouse.x - 18) / 925
            PlayMusic(self.content[self.pos], 1, int(timer * 60) / 60)
            self.music_timer = int(timer * 60)
        end
    elseif self.openMenu then
        menu:Updatekey()
        if mouse:isDown(1) then
            local y
            for i = -15, 15 do
                y = -i * 20 - self.ox / 15 + 270
                if abs(y - mouse.y) < 10 and i ~= 0 then
                    self.ChangeMusic(self.content[self.pos], self.content[self.pos + i])
                    self.pos = self.pos + i
                    self.ox = self.ox + 300 * i
                    self.music_timer = 0
                    scoredata["music_bar_pos"] = self.pos
                    self.now = self.content[self.pos]
                    PlaySound('select00', 0.3)
                end
            end
        end
        if mouse._wheel ~= 0 then
            local t = -sign(mouse._wheel)
            self.ChangeMusic(self.content[self.pos], self.content[self.pos + t])
            self.pos = self.pos + t
            self.ox = self.ox + 300 * t
            self.music_timer = 0
            scoredata["music_bar_pos"] = self.pos
            self.now = self.content[self.pos]
            PlaySound('select00', 0.3)
        end
    end

    if not self.last_key_state.M and self.key_state.M then
        self.openMenu = true
        task.New(self, function()
            for i = 1, 15 do
                self.salpha = 1 - task.SetMode[2](i / 15)
                task.Wait()
            end
        end)
    end
    if not self.key_state.M and self.last_key_state.M then
        self.openMenu = false
        task.New(self, function()
            for i = 1, 15 do
                self.salpha = task.SetMode[2](i / 15)
                task.Wait()
            end
        end)
    end
    self.music_timer = self.music_timer + 1
    if self.ptimer < 240 then
        self.ptimer = self.ptimer + 1
    end
    for i = 1, 3 do
        if not self.key_state["F" .. i] and self.last_key_state["F" .. i] then
            if i ~= self.playmode then
                self.playmode = i
                self.ptimer = 0
                scoredata.music_bar_playmode = i
                PlaySound("explode")
            end
        end
    end
    if self.playmode == 1 then
        if self.music_timer >= self.musicend[self.pos] * 60 then
            self.music_timer = self.musicbegin[self.pos] * 60
        end
    elseif self.playmode == 2 then
        if self.music_timer >= self.musicend[self.pos] * 60 then
            self.ChangeMusic(self.content[self.pos], self.content[self.pos + 1], 100)
            self.pos = self.pos + 1
            self.ox = self.ox + 300
            self.music_timer = 0
            scoredata["music_bar_pos"] = self.pos
            self.now = self.content[self.pos]
            PlaySound('select00', 0.3)
        end
    elseif self.playmode == 3 then
        if self.music_timer >= self.musicend[self.pos] * 60 then
            local p = ran:Int(1, #self.content)
            self.pos = (self.pos - 1) % #self.content + 1
            while p == self.pos do
                p = ran:Int(1, #self.content)
            end
            self.ChangeMusic(self.content[self.pos], self.content[p])
            self.ox = self.ox + 300 * (p - self.pos)
            self.music_timer = 0
            self.pos = p
            scoredata["music_bar_pos"] = self.pos
            self.now = self.content[self.pos]
            PlaySound('select00', 0.3)
        end
    end
end
function music_bar:render()
    SetViewMode("ui")
    local r, g, b = sp:HSVtoRGB(self.timer / 3, 0.9, 0.9)
    if self.salpha > 0 then
        OriginalSetImageState("white", "",
                Color(0, 0, 0, 0),
                Color(200 * self.alpha * self.salpha, 0, 0, 0),
                Color(200 * self.alpha * self.salpha, 0, 0, 0),
                Color(0, 0, 0, 0))
        RenderRect("white", 10, 480, 510, 490)
        RenderRect("white", 950, 480, 510, 490)
        SetImageState("white", "", 255, 0, 0, 0)
        local x
        for i = -15, 15 do
            x = 300 * i + self.ox
            if x > -500 and x < 500 then
                ui:RenderText("title", self.text[self.pos + i], 480 + x, 500, 1,
                        Color((((i == 0) and 255) or 120) * self.salpha * self.alpha, 255, 255, 255), "centerpoint")
            end
        end
    end
    if self.salpha < 1 then

        local t = 1 - self.salpha

        SetImageState("white", "", 150 * self.alpha * t, 0, 0, 0)
        RenderRect("white", 0, 960, 0, 540)

        SetImageState("white", "", 150 * self.alpha * t, 0, 0, 0)
        RenderRect("white", 480 - 160 * t, 480 + 160 * t, 40, 500)
        SetImageState("white", "", 255 * self.alpha * t, 255, 255, 255)
        misc.RenderOutLine("white", 480 - 160 * t, 480 + 160 * t, 500, 40, 0, 1)
        SetRenderRect(480 - 160 * t, 480 + 160 * t, 40, 500, 480 - 160 * t, 480 + 160 * t, 40, 500)
        local y
        for i = -40, 40 do
            y = -i * 20 - self.ox / 15
            if y > -270 and y < 270 then
                ui:RenderText("title", self.text[self.pos + i], 480, 270 + y * t, 1,
                        Color((((i == 0) and 255) or 120) * t * self.alpha, 255, 255, 255), "centerpoint")
            end
        end
        SetViewMode("ui")
    end

    if self.ptimer < 240 then
        SetImageState("white", "", 180 * self.alpha * (240 - self.ptimer) / 240, 0, 0, 0)
        RenderRect("white", 280, 680, 290, 250)
        RenderTTF("sc_menu", self.pmodelist[self.playmode], 480, 270,
                Color(255 * self.alpha * (240 - self.ptimer) / 240, 255, 255, 255), "centerpoint")
    end
    ui:RenderText("manual", "按\"<\"(Comma)和\">\"(Period)选曲，空格(Space)键随机选曲，\nM键详细列表，F1F2F3播放模式",
            480, 526, 1, Color(255 * self.alpha, 255, 255, 255), "centerpoint")

    local len = self.music_timer / (self.musicend[self.pos] * 60)
    SetImageState("white", "", 200 * self.alpha, 200, 200, 200)
    RenderRect("white", 17, 943, 490 + 20 * (1 - self.salpha), 487 + 20 * (1 - self.salpha))
    SetImageState("white", "", 255 * self.alpha, r, g, b)
    RenderRect("white", 18, 18 + 924 * len, 489 + 20 * (1 - self.salpha), 488 + 20 * (1 - self.salpha))
    SetImageState("white", "", 255 * self.alpha, 255, 255, 255)
    misc.SectorRender(18 + 924 * len, 488.5 + 20 * (1 - self.salpha), 0, 3, 0, 360, 10)
    SetViewMode("world")
end

---@type ext