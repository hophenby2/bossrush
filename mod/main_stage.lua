local sg = stage.group
sg.New('menu', {}, "BossRush", true, 1)

stage_selects = {}
---@param event fun(self:stage)
local function NewStage(name, name2, level, event)
    local s = sg.AddStage("BossRush", name .. '@BossRush', true)
    sg.DefStageValue(s.name, 'displayname', name2)
    sg.DefStageValue(s.name, 'level', level)
    sg.DefStageValue(s.name, 'init', event)
    if name2 then
        ---@class stage_unit
        local unit = {
            id = level,
            title = name2,
            tex = "stage_pic" .. level,
            pulse = 0,
            stage = s,
            unlock_way = function()
                if scoredata.stage_practice[level] then
                    return true
                else
                    return ("请先通关：%s"):format(name2)
                end
            end
        }
        stage_selects[level] = unit
    end
end

NewStage("TH06", "红魔乡", 1, function(self)
    self:Option(TH06_bg, "TH06_0")
    self:Task(function()
        task.Wait(60)
        for i = 1, 3 do
            task.Wait(60)
            boss.CreateGroup(i, self.level)
        end
        task.Wait(60)
        stage.ChangeMusicByFade(self, "TH06_0", "TH06_1", 120, 35)
        boss.CreateGroup(4, self.level)
        ToBigScreen(60)
        task.Wait(60)
        lstg.var.off_getsc = lstg.var.off_getsc + 1
        if player.name == "Reimu" or player.name == "Marisa" then
            boss.CreateGroup(6, self.level)
        else
            boss.CreateGroup(5, self.level)
        end
        task.Wait(120)
    end)
    self:Next(52)
end)--0

NewStage("TH07", "妖妖梦", 2, function(self)
    self:Option(TH07_bg, "TH07_0")
    self:Task(function()
        task.Wait(60)
        for i = 1, 4 do
            task.Wait(60)
            boss.CreateGroup(i, self.level)
        end
        task.Wait(60)
        task.New(self, function()
            for i = 1, 180 do
                lstg.view3d.eye[2] = lstg.view3d.eye[2] + 0.01 * sin(90 - i * 0.5)
                lstg.view3d.eye[1] = lstg.view3d.eye[1] - 0.005 * sin(90 - i * 0.5)
                lstg.view3d.at[2] = lstg.view3d.at[2] - 0.005 * sin(90 - i * 0.5)
                task.Wait()
            end
        end)
        stage.ChangeMusicByFade(self, "TH07_0", "TH07_1", 120, 55)
        for i = 5, 6 do
            boss.CreateGroup(i, self.level)
            task.Wait(60)
        end
        task.New(self, function()
            for _ = 1, 180 do
                lstg.tmpvar.bg.speed = lstg.tmpvar.bg.speed + 0.1 / 180
                task.Wait()
            end
        end)
        task.Wait(60)
        stage.ChangeMusicByFade(self, "TH07_1", "TH07_2", 120, 33)
        --stage.ChangeMusicByNice(self, "TH07_1", "TH07_2", "TH07_1", "TH07_2", 33)
        boss.CreateGroup(7, self.level)
        task.Wait(60)
        ForcePassSpell(true)
        boss.CreateGroup(8, self.level)
        task.Wait(60)
        task.Wait(120)
    end)
    self:Next(53)
end)--1

NewStage("TH08", "永夜抄", 3, function(self)
    self:Option(TH08_bg, "TH08_7")
    local cm
    self:Task(function()
        local v3d = lstg.view3d
        local bg = lstg.tmpvar.bg
        do
            for i = 1, 2 do
                task.Wait(60)
                boss.CreateGroup(i, self.level)
            end
            task.New(self, function()
                for i = 1, 180 do
                    v3d.at[1] = v3d.at[1] - 0.01 * sin(i)
                    task.Wait()
                end
            end)
            task.Wait(60)
            boss.CreateGroup(3, self.level)
            task.Wait(60)
            task.New(self, function()
                for i = 1, 180 do
                    v3d.at[2] = v3d.at[2] - 0.005 * sin(i)
                    task.Wait()
                end
            end)

            stage.ChangeMusicByNice(self, "TH08_7", "TH08_3", 54)
            cm = "TH08_3"
            task.New(self, function()
                task.Wait(54 + 23.3 * 60)
                local x, y, z = unpack(v3d.eye)
                for i = 1, 3012 do
                    v3d.at[1] = v3d.at[1] + 0.005 * sin(i)
                    Set3D("eye", x, y + sin(i) * 0.5, z)
                    task.Wait()
                end
            end)
            boss.CreateGroup(5, self.level)
            task.Wait(60)
            task.New(self, function()
                for _ = 1, 180 do
                    bg.speed = bg.speed + 0.05 / 180
                    task.Wait()
                end
            end)
            stage.ChangeMusicByFade(self, cm or "TH08_7", "TH08_5", 120, -2)
            cm = "TH08_5"
            --ChangeMusic(self,cm or "TH08_7","TH08_4")
            --cm="TH08_4"
            for i = 6, 7 do
                boss.CreateGroup(i, self.level)
                task.Wait(60)
            end
        end--]]--before lw
        --lw
        ForcePassSpell(true)
        stage.ChangeMusicByFade(self, cm or "TH08_7", "TH08_NEW_0", 120, 11.28)
        --stage.ChangeMusicByNice(self, cm or "TH08_7", "TH08_NEW_0", 0, 13.28)
        ToBigScreen(90)
        task.New(self, function()
            for i = 1, 90 do
                bg.speed = max(0.004, bg.speed - 0.054 / 90)
                v3d.eye[1] = v3d.eye[1] + 0.003 * sin(i * 2)
                bg.lcol = -i
                SetImageState("stg6bg_wall1", "", 255, 255 - i * 2, 255 - i * 2, 255 - i * 2)
                SetImageState("stg6bg_wall2", "", 255, 255 - i * 2, 255 - i * 2, 255 - i * 2)
                SetImageState("stg6bg_floor", "", 255, 255 - i * 2, 255 - i * 2, 255 - i * 2)
                task.Wait()
            end
        end)
        SimpleText.MusicSign("BGM:NAGI☆ - Candor", { 255, 255, 255 })
        ext.achievement:get(7)
        task.Wait(60)
        task.New(self, function()
            for i = 1, 3600 do
                bg.speed = bg.speed + 0.07 / 3600
                v3d.eye[2] = v3d.eye[2] - 0.003 * sin(i / 20) / 20
                task.Wait()
            end
        end)
        for i = 9, 11 do
            boss.CreateGroup(i, self.level)
        end
        for i = 1, 360 do
            bg.speed = max(0.004, bg.speed - 0.07 / 360)
            bg.lcol = -90 + i / 4
            SetImageState("stg6bg_wall1", "", 255, 75 + i / 2, 75 + i / 2, 75 + i / 2)
            SetImageState("stg6bg_wall2", "", 255, 75 + i / 2, 75 + i / 2, 75 + i / 2)
            SetImageState("stg6bg_floor", "", 255, 75 + i / 2, 75 + i / 2, 75 + i / 2)
            task.Wait()
        end

        PlayMusic("TH08_NEW_1")
        SimpleText.MusicSign("BGM:魂音泉 - Interlude ~Emerald~", { 255, 255, 255 })
        task.New(self, function()
            for i = 1, 20 do
                SetBGMVolume("TH08_NEW_0", 1 - i / 20)
                task.Wait()
            end
            StopMusic("TH08_NEW_0")
            for i = 1, 180 do
                bg.speed = max(0.004, bg.speed - 0.054 / 90)
                v3d.up[1] = v3d.up[1] + 0.01 * sin(i)
                v3d.at[2] = v3d.at[2] + 0.01 * sin(i)
                v3d.at[1] = v3d.at[1] - 0.004 * sin(i)
                task.Wait()
            end
            task.Wait(6480 - 600 - 1800)
            for i = 1, 360 do
                v3d.up[1] = v3d.up[1] - 0.005 * sin(i / 2)
                v3d.at[2] = v3d.at[2] - 0.005 * sin(i / 2)
                v3d.at[1] = v3d.at[1] + 0.002 * sin(i / 2)
                task.Wait()
            end
        end)
        task.Wait(111 - 60)
        for i = 13, 15 do
            boss.CreateGroup(i, self.level)
            task.Wait(80)
        end
        StopMusic("TH08_NEW_1")--]]
        StopMusic("TH08_7")
        ToBigScreen()
        PlayMusic("TH08_NEW_2", 0, 128.19)
        SimpleText.MusicSign("BGM:sound sepher - 幽霊楽団", { 255, 255, 255 })
        task.New(self, function()
            for i = 1, 20 do
                SetBGMVolume("TH08_NEW_2", i / 20)
                task.Wait()
            end
            task.Wait(80)
            for i = 1, 5 do
                v3d.eye[1] = v3d.eye[1] + 0.15
                v3d.eye[2] = v3d.eye[2] + 0.15
                v3d.up[1] = v3d.up[1] - 0.15
                task.Wait(9 - i)
            end
            for i = 1, 1800 do
                v3d.at[1] = v3d.at[1] + 0.005 * sin(i)
                v3d.up[1] = v3d.up[1] + 0.005 * sin(i / 2)
                v3d.eye[2] = v3d.eye[2] - 0.005 * sin(i / 3)
                task.Wait()
            end
        end)
        task.Wait(134 - 60)
        for i = 17, 18 do
            boss.CreateGroup(i, self.level)
            task.Wait(80)
        end
        task.New(self, function()
            for i = 1, 60 do
                SetBGMVolume("TH08_NEW_2", 1 - i / 60)
                task.Wait()
            end
        end)
        StopMusic("TH08_NEW_2")

        local s = bg.speed
        for _ = 1, 180 do
            bg.speed = max(0, bg.speed - s / 180)
            task.Wait()
        end
        task.New(self, function()
            task.Wait(5)
            PlayMusic("TH08_NEW_3")
            SimpleText.MusicSign("BGM:ERIS - AM7：15", { 255, 255, 255 })
        end)
        task.New(self, function()
            for i = 19, 21 do
                boss.CreateGroup(i, self.level)
            end
        end)
        task.Wait(2436 + 5)

        task.New(self, function()
            for i = 1, 180 do
                v3d.at[1] = v3d.at[1] - 0.006 * sin(i)
                v3d.up[1] = v3d.up[1] + 0.006 * sin(i)
                task.Wait()
            end
        end)
        task.Wait(90)
        bg.cherry.open = true
        task.Wait(180)

        boss.CreateGroup(22, self.level)
        boss.CreateGroup(23, self.level)
        task.Wait(120)
        ForcePassSpell(false)
    end)
    self:Next(54)
end)--2

NewStage("TH09", "花映冢", 4, function(self)
    self:Option(TH09_bg, "TH09_2")
    self:Task(function()
        task.Wait(60)
        --ext.manual:FlyIn(8)
        local WAY = 1
        local way = New(Class(object, {
            init = function(o)
                o.sign = -((sign(player.y) == 0) and 1 or sign(player.y))
                o.layer = LAYER.BG + 5
                o._a = 0
                task.New(o, function()
                    for i = 1, 20 do
                        o._a = sin(i * 4.5)
                        task.Wait()
                    end
                end)
            end,
            frame = function(o)
                task.Do(o)
                if not o.d then
                    if player.y * o.sign > 120 then
                        if player.x < 0 then
                            WAY = 1
                        else
                            WAY = 2
                        end
                        object.Del(o)
                    end
                    if o.timer > 3600 then
                        ext.achievement:get(46)
                    end--但是，我拒绝！
                end
            end,
            render = function(o)
                SetImageState("white", "", o._a * 100, 255, 227, 132)
                RenderRect("white", -2, 2, -224, 224)
                RenderRect("white", -4, 4, -224, 224)
                ui:RenderText("title", "Way1", -120, 0,
                        1, Color(o._a * 255, 255, 255, 255), "centerpoint")
                ui:RenderText("title", "Way2", 120, 0,
                        1, Color(o._a * 255, 255, 255, 255), "centerpoint")
                RenderRect("white", -192, 192, o.sign * 120 - 2, o.sign * 120 + 2)
                RenderRect("white", -192, 192, o.sign * 120 - 4, o.sign * 120 + 4)
                ui:RenderText("title", "OK!", 0, 180 * o.sign,
                        1, Color(o._a * 255, 255, 227, 132), "centerpoint")
            end,
            del = function(o)
                object.Preserve(o)
                o.d = true
                task.New(o, function()
                    for i = 19, 0, -1 do
                        o._a = sin(i * 4.5)
                        task.Wait()
                    end
                    object.RawDel(o)
                end)
            end
        }, true))
        while IsValid(way) do
            task.Wait()
        end
        if WAY == 1 then
            lstg.var.off_getsc = lstg.var.off_getsc + 5
            for i = 1, 3 do
                task.Wait(60)
                boss.CreateGroup(i, self.level)
            end
        else
            lstg.var.off_getsc = lstg.var.off_getsc + 6
            for i = 4, 5 do
                task.Wait(60)
                boss.CreateGroup(i, self.level)
            end
        end
        task.Wait(60)
        --ChangeMusic(self,cm,"TH09_5")
        stage.ChangeMusicByFade(self, "TH09_2", "TH09_5", 120, -3)
        lstg.tmpvar.bg.change = true
        task.Wait(365 - 60)
        for i = 6, 9 do
            task.Wait(60)
            boss.CreateGroup(i, self.level)
        end
        task.Wait(120)
    end)
    self:Next(55)
end)--3

NewStage("TH095", "文花帖", 5, function(self)
    self:Option(TH095_bg, "TH09_5_1")

    self:Task(function()
        task.Wait(60)
        for i = 2, 3 do
            boss.CreateGroup(i, self.level)
            task.Wait(60)
        end
        task.Wait(60)
        stage.ChangeMusicByFade(self, "TH09_5_1", "TH09_5_0", 120, 45.62 - 1)
        boss.CreateGroup(1, self.level)
        task.Wait(120)
    end)
    self:Next(56)
end)--3

NewStage("TH10", "风神录", 6, function(self)
    self:Option(TH10_bg, "TH10_4")
    self:Task(function()
        task.Wait(120)
        for i = 1, 3 do
            boss.CreateGroup(i, self.level)
            task.Wait(60)
        end
        lstg.tmpvar.bg.change = true
        stage.ChangeMusicByFade(self, "TH10_4", "TH10_2", 120, ran:Float(30, 50))
        boss.CreateGroup(4, self.level)
        task.Wait(60)
        ForcePassSpell(true)
        boss.CreateGroup(5, self.level)
        task.Wait(60)
        task.Wait(120)
    end)
    self:Next(57)
end)--4

NewStage("TH11", "地灵殿", 7, function(self)
    self:Option(TH11_bg, "TH11_0", true)
    --[[
    local function jumpto(time)
        background.create(TH11_bg)
        for _ = 1, time do
            TH11_bg.frame(lstg.tmpvar.bg)
            lstg.tmpvar.bg.timer = lstg.tmpvar.bg.timer + 1
        end
        PlayMusic("TH11_0", 1, time / 60)
    end--]]
    self:Task(function()
        task.init_left_wait(self)
        local beat = 3600 / 178
        local b
        for u = 1, 4 do
            boss.Create(u .. "a7")
            task.Wait2(self, beat * 12)
        end
        for u = 5, 6 do
            boss.Create(u .. "a7")
            boss.Create(u .. "b7")
            task.Wait2(self, beat * 24)
        end
        New(bullet_cleaner, self.x, self.y, 600, 50, 59)
        boss.Create("7a7")
        task.Wait2(self, beat * 8 * 6)
        --jumpto(2973 - 60)
        New(_editor_class["TH11"]["object0-piano"])
        boss.Create("8a7")
        task.Wait(607)
        --jumpto(3520)
        boss.Create("8b7")
        task.Wait(646)
        --jumpto(4166)
        task.New(self, function()
            task.Wait(60)
            if IsValid(ext.YingYangYu) then
                ext.achievement:get(12)
            end
        end)
        boss.Create("9a7")
        task.Wait(1012)
        --jumpto(5178)
        b = boss.Create("9b7")
        while IsValid(b) do
            task.Wait()
        end
        --jumpto(6472)
        boss.Create("10a7")
        b = boss.Create("10b7")
        while IsValid(b) do
            task.Wait()
        end
        --jumpto(7443)
        boss.Create("11a7")
        b = boss.Create("11b7")
        while IsValid(b) do
            task.Wait()
        end
        --jumpto(8393)
        New(_editor_class["TH11"]["Alert"])
        task.Wait(102)
        boss.Create("12a7")
        b = boss.Create("12b7")
        while IsValid(b) do
            task.Wait()
        end--]]
        --jumpto(9789)
        boss.Create("13a7")
        b = boss.Create("13b7")
        while IsValid(b) do
            task.Wait()
        end
        task.Wait(120)
        if IsValid(ext.YingYangYu) then
            ext.achievement:get(13)
        end
    end)
    self:Next(58)
end)--5

NewStage("TH12", "星莲船", 8, function(self)
    self:Option(TH12_bg, "TH12_0")
    self:Task(function()
        task.New(self, function()
            local class = _editor_class["TH12"]
            self.enemy_number = 51
            task.Wait(23)
            New(class["enemy0-1"], 0, 250, 0, 140)
            for _ = 1, 8 do
                New(class["enemy0-2"], -120, 250, 170, 50, 120, -40)
                New(class["enemy0-2"], 0, 250, 170, 0, 120, 0)
                New(class["enemy0-3"], ran:Float(60, 160), 250, ran:Float(60, 160), 100)
                task.Wait(20)
            end
            New(class["enemy0-1"], -120, 250, -120, 140)
            for _ = 1, 8 do
                New(class["enemy0-2"], 120, 250, -170, 50, -120, -40)
                New(class["enemy0-2"], 0, 250, -170, 0, -120, 0)
                New(class["enemy0-3"], -ran:Float(60, 160), 250, -ran:Float(60, 160), 100)
                task.Wait(20)
            end
            New(class["enemy0-1"], 120, 250, 120, 140)
        end)
        task.Wait(664 - 60)
        New(bullet_cleaner, self.x, self.y, 400, 50, 59)
        for i = 1, 3 do
            boss.CreateGroup(i, self.level)
            task.Wait(60)
        end--]]
        stage:ChangeMusicByFade("TH12_0", "TH12_1", 120, -2)
        task.Wait(35)
        for i = 4, 6 do
            boss.CreateGroup(i, self.level)
            task.Wait(60)
        end
        task.Wait(120)
    end)
    self:Next(59)
end)--6

NewStage("TH125", "文花帖DS", 9, function(self)
    self:Option(TH125_bg, "TH12_5_1", true)
    self:Task(function()
        task.Wait(143)
        boss.CreateGroup(1, self.level)
        task.Wait(60)
        stage:ChangeMusicByFade("TH12_5_1", "TH12_5_2", 60, 17.78 - 2)
        for i = 2, 3 do
            boss.CreateGroup(i, self.level)
            task.Wait(60)
        end
        for i = 1, 60 do
            SetBGMVolume("TH12_5_2", 1 - i / 60)
            coroutine.yield()
        end
        StopMusic("TH12_5_2")
        task.New(self, function()
            task.Wait(55)
            PlayMusic("TH12_5_0")
        end)
        for i = 4, 7 do
            boss.CreateGroup(i, self.level)
            task.Wait(60)
        end
        task.Wait(120)
    end)
    self:Next(60)
end)--6

NewStage("TH128", "大战争", 10, function(self)
    self:Option(TH128_bg, "TH12_8_2")
    self:Task(function()
        task.Wait(60)
        for i = 1, 4 do
            boss.CreateGroup(i, self.level)
            task.Wait(60)
        end
        task.Wait(120)
    end)
    self:Next(61)
end)--6

NewStage("TH13", "神灵庙", 11, function(self)
    self:Option(TH13_bg, "TH13_0")
    self:Task(function()
        for i = 1, 4 do
            boss.CreateGroup(i, self.level)
            task.Wait(60)
        end
        stage:ChangeMusicByFade("TH13_0", "TH13_1", 120, 35.97 - 2 - 2)
        --task.Wait(60)
        for i = 5, 7 do
            boss.CreateGroup(i, self.level)
            task.Wait(60)
        end
        task.Wait(120)
    end)
    self:Next(62)
end)--7

NewStage("TH14", "辉针城", 12, function(self)
    self:Option(TH14_bg, "TH14_0", true)
    --[[
    local function jumpto(time)
        background.Create(TH14_bg)
        TH14_bg.fall_leaf = nil
        for _ = 1, time do
            TH14_bg.frame(lstg.tmpvar.bg)
            lstg.tmpvar.bg.timer = lstg.tmpvar.bg.timer + 1
        end
        TH14_bg.fall_leaf = true
        PlayMusic("TH14_0", 1, time / 60)
    end--]]
    self:Task(function()
        boss.Create("1a12")
        task.Wait(149)--389-240
        boss.Create("1b12")
        task.Wait(554)--763-149-60
        boss.Create("2a12")
        task.Wait(703)
        --jumpto(703 + 554 + 149)
        boss.Create("2b12")
        task.Wait(933)--2519-703-554-149-180
        --jumpto(2519 - 180)
        boss.Create("2c12")
        task.Wait(702)--3221-2519
        boss.Create("3a12")
        task.Wait(762)--3923-3221+60
        --jumpto(3923 - 120)
        boss.Create("4a12")
        boss.Create("4b12")
        task.Wait(642)--702-60
        --jumpto(3923 - 120 + 642)
        boss.Create("5a12")
        task.Wait(702)
        --jumpto(3923 - 120 + 642 + 702)
        boss.Create("6a12")
        task.Wait(1526)
        --jumpto(6733 - 60)
        boss.Create("6b12")
        task.Wait(700)
        --jumpto(7433 - 60)
        boss.Create("6c12")
        task.Wait(704)--]]
        task.Wait()
        --jumpto(8138 - 60)
        boss.Create("7a12")
        task.Wait(175)
        boss.Create("7b12")
        task.Wait(175)
        boss.Create("7c12")
        task.Wait(175)
        boss.Create("7d12")
        boss.Create("7e12")
        task.Wait(175)
        boss.Create("8a12")
        task.Wait(700)
        boss.CreateGroup(9, 12, nil, true)
        task.Wait(700)
        boss.CreateGroup(10, 12, nil, true)
        task.Wait(1407)
        boss.CreateGroup(11, 12, nil, true)
        task.Wait(1464)
        task.Wait(230)
    end)
    self:Next(63)
end)--8

NewStage("TH143", "天邪鬼", 13, function(self)
    self:Option(TH143_bg, "TH14_3_0", true)
    self:Task(function()
        LoadMusic("TH14_3_1", "music\\TH14_3_1.ogg", musicList.TH14_3_1[1], musicList.TH14_3_1[2])--提前加载吧，预防卡顿
        task.Wait(5)
        local main = boss.Create("1a13")
        main.flag = {}
        for i = 1, 9 do
            while IsValid(main) and not main.flag[i] do
                task.Wait()
            end
            if i <= 8 then
                if i == 4 then
                    task.New(self, function()
                        stage:ChangeMusicByFade("TH14_3_0", "TH14_3_1", 60)
                    end)
                end
                local b = boss.Create((i + 1) .. "a13")
                b.main_boss = main
                main.other_boss = b
                while IsValid(b) do
                    task.Wait()
                end
            end
        end
        task.Wait(90)
    end)
    self:Next(64)
end)--8

NewStage("TH15", "绀珠传", 14, function(self)
    self:Option(TH15_bg, "TH15_0")
    local formal = true
    self:Task(function()
        local E = _editor_class.TH15
        if formal then
            do
                task.Wait(60)
                New(E.enemy1_butterfly, 220, 100, 20, 190, -150, 20, 1)
                task.Wait(360)
                New(E.enemy1_butterfly, -220, 100, -20, 190, 150, 20, -1)
                task.Wait(260)
                New(E.enemy2_prepear, 0, 250, 0, 80)
                task.Wait(200)
                New(E.enemy2_prepear2, -200, 250, -120, 150, 3, 90)
                New(E.enemy2_prepear2, 200, 250, 120, 150, 3, 90)
                task.Wait(60)
                New(E.enemy2_prepear2, 0, 250, -90, 100, 3, 80)
                New(E.enemy2_prepear2, 0, 250, 90, 100, 3, 100)
                task.Wait(60)
                New(E.enemy2_prepear2, -120, 250, -60, 100, 3, 100)
                New(E.enemy2_prepear2, 120, 250, 60, 100, 3, 80)
                task.Wait(292)
            end--Part1
            do
                --1292
                for a in sp.math.AngleIterator(ran:Float(0, 360), 3) do
                    New(E.enemy2, -150, 250, 60, a, 1, 0.2, -1)
                    New(E.enemy2, 150, 250, 60, a, -1, -0.2, -1)
                end
                for a = 1, 17 do
                    New(E.enemy1_ghost, 0, 250, 3, 180 + a * 10)
                end
                New(E.enemy3, -200, 250, -120, 120, 1, 0)
                task.Wait(270)
                New(E.enemy3, 200, 250, 120, 120, 1, 180)
                task.Wait(90)
                for a = 1, 17 do
                    New(E.enemy1_ghost, 0, 250, 3, 180 + a * 10)
                end
                task.Wait(356)
            end--Part2
            do
                --2008
                task.New(self, function()
                    task.Wait(150)
                    for c = 1, 20 do
                        New(E.enemy4_circle, 250, -c * 3, 90, 200, 180, 180 + c * 3, c)
                        New(E.enemy4_circle, 250, c * 3, -90, 150, -180, 180 + c * 3, c)
                        New(E.enemy4_main, 200, 250, 0, c * 5, -250, 120)
                        task.Wait(15)
                    end
                end)
                for c = 1, 20 do
                    New(E.enemy4_circle, -250, -c * 3, 90, 200, -180, 180 + c * 3, c)
                    New(E.enemy4_circle, -250, c * 3, -90, 150, 180, 180 + c * 3, c)
                    New(E.enemy4_main, -200, 250, 0, c * 5, 250, 120)
                    task.Wait(15)
                end
                task.Wait(140)
                New(E.enemy2_prepear, 0, 250, 0, 160)
                task.Wait(260)
                task.New(self, function()
                    for _ = 1, 10 do
                        New(E.enemy4_main, -150, 250, -100, 0, -150, -250)
                        New(E.enemy4_main, 150, 250, 100, 0, 150, -250)
                        task.Wait(50)
                    end
                end)
                for c = 1, 50 do
                    New(E.enemy4_circle, 0, 230, 180, 140, 180, 180 + c * 3, c)
                    New(E.enemy4_circle, 0, 230, 0, 180, -180, 180 + c * 3, c)
                    task.Wait(10)
                end
            end--Part3
            task.Wait(3416 - 3208 - 60)
        else
            PlayMusic("TH15_0", 1, 3356 / 60)
        end
        --3208
        New(bullet_cleaner, self.x, self.y, 400, 50, 59)
        for i = 1, 4 do
            boss.CreateGroup(i, self.level)
            task.Wait(60)
        end
        task.Wait(120)
    end)
    self:Task(function()
        LoadMusic("TH15_1", "music\\TH15_1.ogg", musicList.TH15_1[1], musicList.TH15_1[2])--提前加载吧，预防卡顿
        if formal then
            task.Wait(152.73 * 60 - 600)--musicList.TH15_0[2]
        else
            task.Wait(152.73 * 60 - 600 - 3208)
        end
        stage:ChangeMusicByFade("TH15_0", "TH15_1", 240)
    end)
    self:Next(65)
end)--9

NewStage("TH16", "天空璋", 15, function(self)
    self:Option(TH16_bg, "TH16_0")
    self:Task(function()
        self.total_score = 0
        task.Wait(47)
        boss.CreateGroup(1, self.level)
        local flag = true
        local way = { Reimu = { 1, 4, 3, 2 }, Marisa = { 4, 3, 1, 2 }, Aya = { 3, 1, 4, 2 }, Chiruno = { 2, 3, 1, 4 } }
        local season = {
            function()
                TH16_bg.ToSpring(lstg.tmpvar.bg)
                task.Wait(90)
                boss.CreateGroup(2, self.level)
                return true
            end,
            function()
                if not scoredata.UnlockChiruno then
                    lstg.var.off_getsc = lstg.var.off_getsc + 1
                    return false
                end
                TH16_bg.ToSummer(lstg.tmpvar.bg)
                task.Wait(90)
                boss.CreateGroup(3, self.level)
                return true
            end,
            function()
                if not scoredata.UnlockAya then
                    lstg.var.off_getsc = lstg.var.off_getsc + 1
                    return false
                end
                TH16_bg.ToAutumn(lstg.tmpvar.bg)
                task.Wait(90)
                boss.CreateGroup(4, self.level)
                return true
            end,
            function()
                TH16_bg.ToWinter(lstg.tmpvar.bg)
                task.Wait(90)
                boss.CreateGroup(5, self.level)
                return true
            end,
        }
        local j = 1
        for i = 1, 4 do
            if flag then
                j = j + 1
            end
            flag = season[way[player.name][i]]()
        end
        TH16_bg.ToDefault(lstg.tmpvar.bg)
        lstg.var.off_getsc = lstg.var.off_getsc + 1
        if player.name == "Reimu" or player.name == "Chiruno" then
            boss.CreateGroup(6, self.level)
        else
            boss.CreateGroup(7, self.level)
        end
        ToBigScreen(120)
        stage:ChangeMusicByFade("TH16_0", "TH16_1", 180)--, 139.24 - 5
        boss.CreateGroup(8, self.level)
        task.Wait(60)
        if scoredata.UnlockChiruno and scoredata.UnlockAya then
            boss.CreateGroup(9, self.level)
            task.Wait(60)
            boss.CreateGroup(10, self.level)
            task.Wait(60)
        else
            lstg.var.off_getsc = lstg.var.off_getsc + 5
        end
    end)
    self:Next(66)
end)--10

NewStage("TH165", "梦魇日记", 16, function(self)
    self:Option(TH165_bg, "TH16_5_0")
    self:Task(function()
        task.Wait(60)
        local b = boss.Create("1a16")
        while IsValid(b) do
            task.Wait()
        end
        task.Wait(120)
    end)
    self:Next(51)
end)--10

NewStage("TH17", "鬼形兽", 17, function(self)
    self:Option(TH17_bg, "TH17_0")
    self:Task(function()
        task.Wait(60)
        for i = 1, 5 do
            boss.CreateGroup(i, self.level)
            task.Wait(60)
        end
        ForcePassSpell(true)
        ToBigScreen(60)
        boss.CreateGroup(6, self.level)
        task.Wait(60)
    end)
    self:Task(function()
        LoadMusic("TH17_1", "music\\TH17_1.ogg", musicList.TH17_1[1], musicList.TH17_1[2])--提前加载吧，预防卡顿
        task.Wait(116.76 * 60)
        stage:ChangeMusicByFade("TH17_0", "TH17_1", 240, 103.11)
    end)
    self:Next(102)
end)--11

NewStage("TH18", "虹龙洞", 18, function(self)
    self:Option(TH18_bg, "TH18_0")
    self:Task(function()
        task.Wait(60)
        for i = 1, 5 do
            boss.CreateGroup(i, self.level)
            if i ~= 3 then
                task.Wait(60)
            end
        end
        task.New(self, function()
            NewPulseScreen(LAYER.BG + 10, nil, "mul+add", 60, 0, 60)
            task.Wait(60)
            background.Create(TH18_bg2)
        end)
        stage:ChangeMusicByFade("TH18_0", "TH18_1", 120, 90.91 - 4.5)
        for i = 6, 9 do
            boss.CreateGroup(i, self.level)
            task.Wait(60)
        end

    end)
    self:Next(131)
end)--12

NewStage("TH185", "弹幕黑市", 19, function(self)
    self:Option(TH185_bg, "TH18_5_0", true)
    self:Task(function()
        task.Wait(60)
        for i = 1, 4 do
            boss.CreateGroup(i, self.level)
            task.Wait(60)
        end
    end)
    self:Next(132)
end)--12



NewStage("TH00", "未命名关卡", 20, function(self)
    TH00_bg.ResetSpace()
    self:Option(TH00_bg, "TH00_0")
    self:Task(function()
        local E = _editor_class["TH00"]
        --=========== 道中（暂时停用） ===========
        --[[
        --Part1：两侧小妖精交错下压
        task.Wait(60)
        for i = 0, 3 do
            New(E.th00_fairy, -170 + i * 16, 250, -150 + i * 20, 140)
            New(E.th00_fairy, 170 - i * 16, 250, 150 - i * 20, 140)
            task.Wait(18)
        end
        task.Wait(300)
        --Part2：斜向切入的编队妖精
        New(E.th00_wave, -150, 240, -110, 130, -60)
        New(E.th00_wave, 150, 240, 110, 130, -120)
        task.Wait(90)
        New(E.th00_wave, 0, 250, 0, 150, -90)
        task.Wait(300)
        --Part3：中央中型妖精
        New(E.th00_mid, 0, 250, 0, 110, 0)
        task.Wait(360)
        --]]
        --=========== 冲破大气层 ===========
        local w = lstg.world
        task.Wait(60)
        --1) 预设弹：先跑一批随机 xy 键值对（y 全部在屏幕上方 230 以上），
        --   上升期间一直按对铺出（含冲破过渡），直到背景透明度降到 0 才停；
        --   与云层同速下坠，透明度也跟云层一致，飞出下边界即回收（不循环）
        do
            local imgs = { "ball_small8", "ball_small12", "ball_mid8", "grain_a8" }
            local pos = {}
            for i = 1, 128 do
                pos[i] = { x = ran:Float(w.boundl, w.boundr), y = 230 + ran:Float(0, 220) }
            end
            local n, i = #pos, 0
            local function Spawn()
                i = i % n + 1
                local p = pos[i]
                New(E.th00_sky_bullet,
                        imgs[ran:Int(1, #imgs)],
                        p.x, p.y,
                        ran:Float(0.55, 1.3),
                        1,
                        ran:Int(140, 255),
                        210, 240, 255)
            end
            for k = 1, 8 do
                Spawn()
            end
            --后台铺弹：间隔跟着云层速度走，屏幕上弹的疏密基本不变；
            --背景彻底透明（alpha 降到 0）才收手
            task.New(self, function()
                local bg, ba, spd
                while true do
                    bg = TH00_bg.current
                    if bg and IsValid(bg) then
                        ba, spd = bg.opacity, bg.speed
                    else
                        ba, spd = 255, 1.2
                    end
                    if ba <= 0 then
                        break
                    end
                    Spawn()
                    task.Wait(max(2, int(28 / max(0.5, spd))))
                end
            end)
        end
        task.Wait(45)
        --2) 加速：整片天空连同预设弹一起高速下坠
        TH00_bg.SetSpeed(14, 90)
        TH00_bg.current.turb = 1.4
        for i = 1, 6 do
            PlaySound("kira00", 0.06, 0, true)
            task.Wait(20)
        end
        task.Wait(150)
        --3) 冲破：不切场景，云层在同一个画面里淡出、星空淡入（一镜到底）
        TH00_bg.SetSpeed(22, 40)
        task.Wait(40)
        New(WhiteScreen, LAYER.TOP, 45)
        PlaySound("big", 0.5, 0, true)
        TH00_bg.Warp(90)
        PlaySound("explode", 0.35, 0, true)
        task.Wait(110)
        --=========== BOSS ===========
        New(bullet_cleaner, self.x, self.y, 400, 50, 59)
        task.Wait(60)
        boss.CreateGroup(1, self.level)
        task.Wait(120)
    end)
    self:Next(156)
end)--20

NewStage("TH01", "水月", 21, function(self)
    self:Option(TH01_bg, "TH01_0")
    self:Task(function()
        --=========== 道中（暂无，先给玩家两秒看看夜色） ===========
        task.Wait(120)
        --=========== BOSS ===========
        boss.CreateGroup(1, self.level)
        task.Wait(120)
    end)
    self:Next(157)
end)--21

NewStage("TH02", "星河", 22, function(self)
    self:Option(TH02_bg, "TH02_0")
    self:Task(function()
        --=========== 道中（暂无，先给玩家两秒看看深空） ===========
        task.Wait(120)
        --=========== BOSS ===========
        boss.CreateGroup(1, self.level)
        task.Wait(120)
    end)
    self:Next(158)
end)--22

NewStage("TH03", "白玉楼", 23, function(self)
    self:Option(TH03_bg, "TH03_0")
    self:Task(function()
        --=========== 道中：先让冥界的樱吹雪飘一会儿 ===========
        --纯装饰的落樱（无判定），先把玩家带进白玉楼的气氛里
        local E = _editor_class["TH03"]
        local w = lstg.world
        for _ = 1, 90 do
            New(E.th03_petal_sky, ran:Float(w.boundl, w.boundr), w.boundt + 24)
            task.Wait(ran:Int(1, 3))
        end
        task.Wait(150)
        New(bullet_cleaner, 0, 0, 400, 50, 59)
        task.Wait(40)
        --=========== BOSS ===========
        boss.CreateGroup(1, self.level)
        task.Wait(120)
    end)
    self:Next(159)
end)--23

NewStage("TH04", "彼岸", 24, function(self)
    self:Option(TH04_bg, "TH04_0")
    self:Task(function()
        --=========== 道中：三途川上飘的魂火 ===========
        --纯装饰（无判定），先把玩家带进彼岸的气氛里
        local E = _editor_class["TH04"]
        local w = lstg.world
        for _ = 1, 80 do
            New(E.th04_wisp, ran:Float(w.boundl, w.boundr), w.boundb - 20)
            task.Wait(ran:Int(1, 3))
        end
        task.Wait(150)
        New(bullet_cleaner, 0, 0, 400, 50, 59)
        task.Wait(40)
        --=========== BOSS ===========
        boss.CreateGroup(1, self.level)
        task.Wait(120)
    end)
    self:Next(160)
end)--24

NewStage("SUMMARY", nil, 1, function(self)
    self:Option()
    New(SUMMARY)
    ext.notUIdraw = true
    self.level = 1
end)



