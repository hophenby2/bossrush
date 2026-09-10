local task = task
local cos, sin = cos, sin

local units = {}

CreateRenderTarget("th16_aex_back")
CreateRenderTarget("th16_aex_back2")
local SUMMARY = Class(object)
_editor_class.TH16_AEX.summary = SUMMARY
function SUMMARY:init()
    player.hide = true
    player.realrealreal_lock = true
    --Print(stage.groups["BossRush"].number)
    self.layer = 0
    self.bound = false
    self.alpha = 0
    self.x, self.y = 480, 270
    self.scale = 0.7
    self.z = 0
    task.New(self, function()
        New(units.title)
        task.New(self, function()
            task.New(self, function()
                task.SmoothSetValueTo("alpha", 1, 120, 3)
            end)
            task.SmoothSetValueTo("scale", 0.38, 120, 3)
            NewPulseScreen(5, nil, "mul+add", 0, 0, 60, "ui")
            local s, t = 0, 0
            while true do
                self.x = 480 + sin(s) * 10 + sin(s * 0.7) * 5
                self.y = 270 + sin(s * 0.7) * 10 - sin(s) * 5
                self.scale = 0.38 + sin(s * 0.5) * 0.02
                s = s + sin(t)
                t = min(t + 1, 90)
                task.Wait()
            end
        end)
    end)
    task.New(self, function()
        local var = lstg.var
        local maxgetsc = 20
        local maxsystem = SYSTEM_COUNT
        local curscore = var.score
        local curgetsc = var.getsc
        local curdead = var.dead
        local cursystem = #var.current_system
        task.Wait(60)
        self.curscore_obj = New(units.tag_obj, ("分数：%d"):format(curscore),
                230, 380, 150, 240, 240, 240, 0.2, 30, 35)
        self.curgetsc_obj = New(units.tag_obj, ("收卡数：%d / %d"):format(curgetsc, maxgetsc),
                220, 320, 150, 189, 252, 201, 0.3, 30, 35)
        self.curdead_obj = New(units.tag_obj, ("死亡数：%d"):format(curdead),
                240, 260, 150, 255, 99, 71, 0.3, 30, 35)
        self.cursystem_obj = New(units.tag_obj, ("携带系统数：%d / %d"):format(cursystem, maxsystem),
                260, 200, 150, 255, 227, 132, 0.4, 30, 35)
        self.cursystem_obj = New(units.tag_obj, ("完成度：%d%%"):format(lstg.var.get_part / 27 * 100),
                250, 140, 150, 230, 230, 230, 0.5, 30, 35)
        self.total = New(units.total_score, 100)
        local proportion = {}
        do
            self.final_score = 0
            local maxforbid = 1
            if curgetsc == maxgetsc then
                proportion.getsc = 280
            else
                maxforbid = max(0, curgetsc / maxgetsc * 1.5 - 0.4)
                proportion.getsc = curgetsc / maxgetsc * 260
            end
            if curdead == 0 then
                proportion.dead = 220
            else
                proportion.dead = 200 / (curdead * 0.2 + 0.8)
            end
            proportion.score = curscore / 100000000
            proportion.getsc = proportion.getsc / 5
            proportion.dead = proportion.dead / 5
            proportion.score = proportion.score * (curgetsc / maxgetsc) * 200 / (curdead * 0.2 + 0.8)
            self.final_score = self.final_score + proportion.getsc--FS得56.0%分，否则按52.0%获分
            self.final_score = self.final_score + proportion.dead --NM得44.0%分，否则按40.0%获分
            if cursystem == 0 then
                maxforbid = maxforbid * 1.1
                proportion.score = proportion.score * 1.1--不携带系统稍微加分
            else
                maxforbid = maxforbid * (1 - cursystem / maxsystem * 0.3)
                proportion.score = proportion.score * (1 - cursystem / maxsystem * 0.2)--携带系统稍微扣分
            end
            local left = max(100 - self.final_score, 0)

            proportion.score = left * (-maxforbid / (proportion.score + 1) + maxforbid)
            self.final_score = self.final_score + proportion.score--用分数加附加分

        end--计算得分
        task.Wait(60)

        New(units.text_obj, ("Player：%s"):format(scoredata.PlayerBrand), 480, 500, { 230, 250, 230 }, 0, 400, 0, 0.7, "centerpoint", 200, function(self)
            task.Clear(self)
            task.New(self, function()
                while true do
                    self.lifetime = self.lifetime + 1
                    task.Wait()
                end
            end)
        end).layer = 10
        New(units.text_obj, "Pic Author：ファルケン", 955, 535, { 230, 230, 230 }, 90, 400, 60, 0.4, "right", 200).layer = 10
        New(units.text_obj, "Special Thanks：@SAHB_", 955, 510, { 230, 230, 230 }, 90, 400, 60, 0.4, "right", 200).layer = 10
        New(units.img_obj, "title", 480, 70, nil, 0, 600, 0, 0.7, "", 200, function(self)
            task.Clear(self)
            task.New(self, function()
                while true do
                    self.lifetime = self.lifetime + 1
                    task.Wait()
                end
            end)
            task.New(self, function()
                for i = 1, 30 do
                    self.hscale = 0.6 - 0.1 * sin(i * 3)
                    self.vscale = self.hscale
                    task.Wait()
                end
            end)
            task.New(self, function()
                local s, t = 0, 0
                while true do
                    self.y = 70 + sin(s * 0.2) * 7 - sin(s * 0.4) * 10
                    s = s + sin(t)
                    t = min(t + 1, 90)
                    task.Wait()
                end
            end)
        end)
        New(units.img_obj, ("%s_tachie"):format(var.player_name), 750, 270, nil, 0, 600, 0, 0.7, "", 250, function(self)
            task.Clear(self)
            task.New(self, function()
                while true do
                    self.lifetime = self.lifetime + 1
                    task.Wait()
                end
            end)
            task.New(self, function()
                for i = 1, 30 do
                    self.hscale = 0.7 - 0.1 * sin(i * 3)
                    self.vscale = self.hscale
                    task.Wait()
                end
            end)
            task.New(self, function()
                local s, t = 0, 0
                while true do
                    self.y = 270 + sin(s * 0.3) * 7 - sin(s * 0.5) * 10
                    s = s + sin(t)
                    t = min(t + 1, 90)
                    task.Wait()
                end
            end)
        end)

        do
            local eff = units.add_effect
            local main = self.total
            local obj, rgb
            obj = self.curscore_obj
            rgb = { obj._r, obj._g, obj._b }
            for _ = 1, proportion.score do
                New(eff, obj.x, obj.y, main.x, main.y, 1, main, rgb)
            end
            New(eff, obj.x, obj.y, main.x, main.y, proportion.score - int(proportion.score), main, rgb)
            obj = self.curgetsc_obj
            rgb = { obj._r, obj._g, obj._b }
            for _ = 1, proportion.getsc do
                New(eff, obj.x, obj.y, main.x, main.y, 1, main, rgb)
            end
            New(eff, obj.x, obj.y, main.x, main.y, proportion.getsc - int(proportion.getsc), main, rgb)
            obj = self.curdead_obj
            rgb = { obj._r, obj._g, obj._b }
            for _ = 1, proportion.dead do
                New(eff, obj.x, obj.y, main.x, main.y, 1, main, rgb)
            end
            New(eff, obj.x, obj.y, main.x, main.y, proportion.dead - int(proportion.dead), main, rgb)
        end
        task.Wait(120)
        task.New(self, function()
            for i = 1, 60 do
                self.z = sin(i * 1.5)
                task.Wait()
            end
        end)
        menu:Updatekey()
        while not menu:keyYes() and not ext.mouse:isDown(1) do
            menu:Updatekey()
            coroutine.yield()
        end
        var.score = ("%0.1f"):format(self.final_score)

        mask_fader:Do("close")
        local list = {}
        for _, v in pairs(EnumRes2('bgm')) do
            if GetMusicState(v) == 'playing' then
                table.insert(list, v)
            end
        end
        for i = 1, 30 do
            for _, v in pairs(list) do
                SetBGMVolume(v, 1 - i / 30)
            end
            task.Wait()
        end
        for _, v in pairs(list) do
            StopMusic(v)
        end
        if not ext.replay.IsReplay() then
            scoredata.UnlockAya = true
        end
        stage.group.FinishReplay()
        stage.group.FinishStage()
    end)
end
function SUMMARY:frame()
    task.Do(self)
    if self.timer % 25 == 0 then
        New(units.drop_particle, ran:Float(0, 960), ran:Float(600, 540), ran:Float(1, 3), -90 + ran:Float(-5, 5))
    end
end
function SUMMARY:render()
    SetViewMode("ui")
    SetImageState("white", "", 255, 0, 0, 0)
    RenderRect("white", 0, 960, 0, 540)
    if lstg.var.lost then
        PushRenderTarget("th16_aex_back")
        RenderClear(Color(255, 0, 0, 0))
    end
    SetImageState("summary_back2", "", self.alpha * 255,
            200 + 30 * sin(self.timer), 200 + 30 * sin(self.timer), 200 + 30 * sin(self.timer))
    Render("summary_back2", self.x, self.y, 0, self.scale)
    if lstg.var.lost then
        PopRenderTarget("th16_aex_back")
        PostEffectGrayColor("th16_aex_back", 0.8)
    end
    if self.z > 0 then
        ui:RenderText("title", "按确定键结束", 0, 0,
                1, Color(255 * self.z, 200, 200 + 55 * sin(self.timer), 200), "left", "bottom")
    end
end

local title = Class(object)
units.title = title
function title:init()
    self.layer = 1
    self.text = "Stage\nSummary"
    self.angle = 0
    self.r = 150
    self.x, self.y = -90, 540
    self.tx, self.ty = -90, 505
    self.bound = false
    task.New(self, function()
        for i = 1, 60 do
            i = task.SetMode[2](i / 60)
            self.angle = -180 * i
            self.r = 150 - 50 * i
            self.x = -90 + 140 * i
            task.Wait()
        end
        for i = 1, 90 do
            i = task.SetMode[2](i / 90)
            self.tx = -90 + 155 * i
            task.Wait()
        end
    end)
end
function title:frame()
    task.Do(self)
end
function title:render()
    SetViewMode("ui")
    for i = 1, 5 do
        SetImageState("white", "", 15 * (6 - i), 0, 0, 0)
        misc.SectorRender(self.x + 3, self.y - 3, 0, self.r + i, self.angle, 40, 50)
    end
    SetImageState("white", "", 200, 50, 50, 50)
    misc.SectorRender(self.x, self.y, 0, self.r, self.angle, 40, 50)
    ui:RenderText("big_text", self.text, self.tx, self.ty, 0.6, Color(255, 255, 255, 255), "centerpoint")
end

local tag_obj = Class(object, { frame = task.Do })
units.tag_obj = tag_obj
function tag_obj:init(text, x, y, a, r, g, b, float, head, width)
    self.layer = 2
    self.text = text
    self.angle = 0
    self.x, self.y = 0, y
    self.bound = false
    self._a, self._r, self._g, self._b = a, r, g, b
    self.head = head
    self.width = width
    task.New(self, function()
        task.SmoothSetValueTo("x", x, 60, 2)
        local s, t = 0, 0
        while true do
            self.x = x + sin(s) * 7 + sin(s * 0.7) * 3
            self.y = y + sin(s * 0.7) * 7 - sin(s) * 3
            s = s + sin(t) * float
            t = min(t + 1, 90)
            task.Wait()
        end
    end)
end
function tag_obj:render()
    SetViewMode("ui")
    local x1 = self.x
    local x2 = self.x - self.head
    local y = self.y
    local w = self.width / 2
    for i = 1, 5 do
        SetImageState("white", "", self._a / 10 * (7 - i), 0, 0, 0)
        RenderRect("white", 0, x2 + i, y - w - i, y + w - i)
        Render4V("white",
                x2 + i, y + w - i, 0.5, x1 + i, y - i, 0.5,
                x1 + i, y - i, 0.5, x2 + i, y - w - i, 0.5)
    end
    SetImageState("white", "", self._a, self._r * 0.4, self._g * 0.4, self._b * 0.4)
    RenderRect("white", 0, x2, y - w, y + w)
    Render4V("white",
            x2, y + w, 0.5, x1, y, 0.5,
            x1, y, 0.5, x2, y - w, 0.5)
    ui:RenderText("big_text", self.text, x2, y, w / 85 * 2, Color(255, self._r, self._g, self._b), "right", "vcenter")
end

local total_score = Class(object, { frame = task.Do })
units.total_score = total_score
function total_score:init(maxscore)
    self.x = 480
    self.y = 270
    self.layer = 2
    self.bound = false
    self.score = 0
    self.maxscore = maxscore
    self.angle = 360
    self.r = 0
    task.New(self, function()
        for i = 1, 120 do
            i = task.SetMode[2](i / 120)
            --self.angle = 360 * i
            self.r = 120 * i
            task.Wait()
        end

    end)
end
function total_score:render()
    SetViewMode("ui")
    local r = self.r + sin(self.timer * 3) * 3
    for i = 1, 5 do
        SetImageState("white", "", 15 * (6 - i), 0, 0, 0)
        misc.SectorRender(self.x + 3, self.y - 3, 0, r + i, 0, self.angle, 50)
    end
    local ang
    local angle
    do
        PushRenderTarget("th16_aex_back2")
        RenderClear(Color(255, 0, 0, 0))
        ang = 6
        local wht = 255
        local bcolor = Color(255, wht, wht, wht)
        local mx, my = self.x, self.y
        local r1 = r
        local tex = "th16AEXPIC"
        local tsize = GetTextureSize(tex) / 2
        local uv1, uv2, uv3, uv4 = { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }
        uv2[1], uv2[2], uv2[4], uv2[5], uv2[6] = mx, my, tsize, tsize, bcolor
        uv3[1], uv3[2], uv3[4], uv3[5], uv3[6] = mx, my, tsize, tsize, bcolor
        uv1[6] = bcolor
        uv4[6] = bcolor
        for i = 1, 30 do
            angle = 12 * i
            uv1[1], uv1[2] = mx + r1 * cos(angle + ang), my + r1 * sin(angle + ang)
            uv1[4], uv1[5] = tsize + tsize * cos(angle + ang), tsize - tsize * sin(angle + ang)
            uv4[1], uv4[2] = mx + r1 * cos(angle - ang), my + r1 * sin(angle - ang)
            uv4[4], uv4[5] = tsize + tsize * cos(angle - ang), tsize - tsize * sin(angle - ang)
            RenderTexture(tex, "", uv1, uv2, uv3, uv4)
        end
        PopRenderTarget("th16_aex_back2")
        PostEffectGrayColor("th16_aex_back2", 1 - self.score / self.maxscore, 1)
    end
    SetImageState("white", "", 100, 0, 0, 0)
    misc.SectorRender(self.x, self.y, 0, r - 3, 0, self.angle, 50)
    SetImageState("white", "", 255, 255, 255, 255)
    misc.SectorRender(self.x, self.y, r - 3, r + 1, 0, self.angle, 50)
    ui:RenderText("big_text", "Final Score", self.x, self.y + 64,
            0.5, Color(self.r * 2, 200, 200, 200), "centerpoint")
    ui:RenderText("big_text", ("%0.1f / %d"):format(self.score, self.maxscore), self.x, self.y,
            0.9, Color(self.r * 2, 255, 255, 255), "centerpoint")
end

local add_effect = Class(object, { frame = task.Do })
units.add_effect = add_effect
function add_effect:init(x, y, mx, my, score, master, col)
    self.x, self.y = x, y
    self.layer = 3
    self.bound = false
    self.scale = 0
    self.color = { 200, 200, 200 }
    self.omiga = ran:Sign()
    task.New(self, function()
        local v, a = ran:Float(1, 3), ran:Float(0, 360)
        local time = ran:Int(30, 60)
        for i = time - 1, 0, -1 do
            self.scale = sin(90 - i / time * 90) * 1
            self.x = self.x + cos(a) * v * sin(i * 3)
            self.y = self.y + sin(a) * v * sin(i * 3)
            coroutine.yield()
        end
        task.Wait(ran:Int(1, 30))
        task.MoveTo(mx, my, 60, 1)
        PlaySound("item00")
        master.score = min(master.maxscore, master.score + score)
        self.color = col
        v, a = ran:Float(2, 5), ran:Float(0, 360)
        for i = 59, 0, -1 do
            self.scale = 1.6 - sin(90 - i * 1.5) * 0.6
            self.x = self.x + cos(a) * v * sin(i * 1.5)
            self.y = self.y + sin(a) * v * sin(i * 1.5)
            coroutine.yield()
        end
        task.New(self, function()
            for i = 59, 0, -1 do
                self.scale = sin(i * 1.5)
                coroutine.yield()
            end
        end)
        task.MoveTo(mx, my, 60, 1)
        object.Del(self)
    end)
end
function add_effect:render()
    SetViewMode("ui")
    SetImageState("bright", "mul+add", 128, unpack(self.color))
    Render("bright", self.x, self.y, self.rot, self.scale * 10 / 150)
    Render("bright", self.x, self.y, self.rot, self.scale * 5 / 150)
end

local drop_particles = Class(object)
units.drop_particle = drop_particles
function drop_particles:init(x, y, v, a)
    self.img = "bright"
    self.x, self.y = x, y
    self.bound = false
    self.layer = 0.5
    self.smear = {}
    self.dealpha = ran:Float(2, 5)
    self.color = { 135, 206, 235 }
    local scale = ran:Float(7, 15)
    self.hscale = scale / 150
    self.vscale = scale / 150
    task.New(self, function()
        local index, range = ran:Float(2, 3), ran:Float(12, 45)
        local s = -45
        while true do
            object.SetV(self, v, a + sin(s * index) * range)
            s = s + 1
            task.Wait()
        end
    end)
end
function drop_particles:frame()
    if self.y < 0 then
        if #self.smear == 0 then
            object.Del(self)
        end
    else
        task.Do(self)
        object.smear_add(self, 100)
    end
    object.smear_frame(self, self.dealpha)
end
function drop_particles:render()
    SetViewMode("ui")
    object.smear_render(self, "mul+add", self.color)
    SetImageState("bright", "mul+add", 150, unpack(self.color))
    object.render(self)
end

local text_obj = Class(object, {
    init = function(self, text, x, y, col, fade_in, stay, fade_out, size, mode, maxalpha, action)
        self.layer = 1.5
        self.text = text or ""
        self.x, self.y = x, y
        self.mode = mode
        self.size = size or 1
        self.maxalpha = maxalpha or 255
        self.bound = false
        self._r, self._g, self._b = unpack(col or { 255, 255, 255 })
        fade_in = fade_in or 0
        stay = stay or 0
        fade_out = fade_out or 0
        self.lifetime = fade_in + stay + fade_out
        if fade_in > 0 then
            self._a = 0
        else
            self._a = self.maxalpha
        end
        task.New(self, function()
            for i = 1, fade_in do
                self._a = i / fade_in * self.maxalpha
                task.Wait()
            end
            task.Wait(stay)
            for i = 1, fade_out do
                self._a = self.maxalpha - i / fade_out * self.maxalpha
                task.Wait()
            end
        end)
        if action then
            action(self)
        end

    end,
    frame = function(self)
        task.Do(self)
        if self.timer >= self.lifetime then
            object.RawDel(self)
        end
    end,
    render = function(self)
        SetViewMode("ui")
        ui:RenderText("big_text", self.text, self.x, self.y, self.size, Color(self._a, self._r, self._g, self._b), self.mode)
    end
})
units.text_obj = text_obj
local img_obj = Class(object, {
    init = function(self, img, x, y, col, fade_in, stay, fade_out, size, blend, maxalpha, action)
        self.layer = 1.5
        self.img = img or "img_void"
        self.x, self.y = x, y
        self.blend = blend or ""
        self.hscale = size or 1
        self.bound = false
        self.vscale = self.hscale
        self.maxalpha = maxalpha or 255
        self._r, self._g, self._b = unpack(col or { 255, 255, 255 })
        fade_in = fade_in or 0
        stay = stay or 0
        fade_out = fade_out or 0
        self.lifetime = fade_in + stay + fade_out
        if fade_in > 0 then
            self._a = 0
        else
            self._a = self.maxalpha
        end
        task.New(self, function()
            for i = 1, fade_in do
                self._a = i / fade_in * self.maxalpha
                task.Wait()
            end
            task.Wait(stay)
            for i = 1, fade_out do
                self._a = self.maxalpha - i / fade_out * self.maxalpha
                task.Wait()
            end
        end)
        if action then
            action(self)
        end

    end,
    frame = function(self)
        task.Do(self)
        if self.timer >= self.lifetime then
            object.RawDel(self)
        end
    end,
    render = function(self)
        SetViewMode("ui")
        SetImageState(self.img, self.blend, self._a, self._r, self._g, self._b)
        object.render(self)
    end
})
units.img_obj = img_obj
