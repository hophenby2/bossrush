stage.group.New('menu', {}, "HSiFS AfterExtra", true, 1)
stage.group.AddStage('HSiFS AfterExtra', 'HSiFS AfterExtra@HSiFS AfterExtra', true)
stage.group.AddStage('HSiFS AfterExtra', 'summary@HSiFS AfterExtra', true)

---@param self stage
stage.group.DefStageValue('HSiFS AfterExtra@HSiFS AfterExtra', 'init', function(self)
    item._init_item(self)
    mask_fader:Do("open")
    New(_G[lstg.var.player_name])
    PlayMusic("TH16_AEX_0")

    self.AllowMissCount = 5
    task.New(self, function()
        task.init_left_wait(self)
        task.Wait(193)
        local beat = 3600 / 160
        local class = _editor_class.TH16_AEX
        local bg = background.Create(TH16_AEX_bg)
        local BOSS_ID = STAGE_COUNT + 1
        bg.timer = bg.timer + 193
        task.New(bg, function()
            task.init_left_wait(bg)
            task.Wait(beat * 64 - 40)
            NewPulseScreen(LAYER.BG + 1, nil, "mul+add", 40, 0, 60)
            task.Wait(40 + beat * 200 - 112)
            local ps = NewPulseScreen(LAYER.BG + 1, nil, "mul+add", 255, 0, 0)
            for _ = 1, 112 do
                bg.speed = bg.speed + 1 / 112
                task.Wait()
            end
            Del(ps)

            NewPulseScreen(LAYER.BG + 1, nil, "mul+add", 0, 0, 60)
            task.Wait2(bg, beat * 128)
            NewPulseScreen(LAYER.BG + 1, nil, "mul+add", 0, 0, 60)
            task.New(bg, function()
                for _ = 1, 600 do
                    bg.speed = bg.speed - 1.8 / 600
                    task.Wait()
                end
            end)
            task.Wait2(bg, beat * 68)
            NewPulseScreen(LAYER.BG + 1, nil, "mul+add", beat * 4, 0, 0)
            task.Wait2(bg, beat * 4)
            task.New(bg, function()
                for _ = 1, 600 do
                    bg.speed = bg.speed + 1.8 / 600
                    task.Wait()
                end
            end)
            task.Wait2(bg, beat * 128 + 60)
            bg.speed = bg.speed - 1.3
            task.Wait2(bg, beat * 134 - 60)
            NewPulseScreen(1, nil, "mul+add", 0, 0, 45)
            NewPulseScreen(0, { 0, 0, 0 }, "", 0, beat * 2, 0)
            object.BulletDo(function(b)
                object.RawDel(b)
            end)
            task.Wait2(bg, beat * 2)
            NewPulseScreen(0, nil, "mul+add", 0, 0, 45)
            bg.speed = bg.speed + 2.6
        end)
        local w2

        do
            task.New(self, function()
                task.Wait(911 - 193 - 80)
                New(class.A2, 0, 250, 0, -3, 0, -1)
                task.Wait(180)
                New(class.A2, 0, 250, 0, -5, 0, -1)
                task.Wait(180)
                New(class.A2, -100, 250, 0, -3, 0, -1)
                New(class.A2, 100, 250, 0, -3, 0, -1)
                task.Wait(360)
                w2 = true
            end)
            for _ = 1, 9 do
                New(class.A1, ran:Float(-220, -240), ran:Float(160, 130), ran:Float(1.8, 2.3), -0.3, 3)
                task.Wait(20)
            end
            task.Wait(120)
            do
                for _ = 1, 9 do
                    New(class.A1, ran:Float(220, 240), ran:Float(160, 130), -ran:Float(1.8, 2.3), -0.3, 3)
                    task.Wait(20)
                end
            end
        end--1
        lstg.var.get_part = lstg.var.get_part + 1
        do
            while true do
                if w2 then
                    break
                end
                task.Wait()
            end
            New(class.B1, -230, 150, 3, -1, 1, -1, 1)
            New(class.B1, 230, 150, -3, -1, -1, -1, -1)
            task.Wait(360)
            New(class.B1, 0, 250, 3, -3, -1, -1, 1)
            New(class.B1, 0, 250, -3, -3, 1, -1, -1)
            task.Wait(360)
            task.New(self, function()
                for _ = 1, 12 do
                    local x, _d_x = (-150), (300 / 3)
                    for _ = 1, 4 do
                        New(class.B2, x, 250, 0, -1)
                        x = x + _d_x
                    end
                    task.Wait(60)
                end
            end)
            New(class.B1, -100, 250, 3, -3, 1, -1, 1)
            New(class.B1, 100, 250, -3, -3, -1, -1, -1)
            task.Wait(360)
            New(class.B1, -100, 250, -1, -3, 1, -1, 1)
            New(class.B1, 100, 250, 1, -3, -1, -1, -1)
            while bg.timer <= 3250 - 1 do
                task.Wait()
            end
        end--2
        lstg.var.get_part = lstg.var.get_part + 1
        do
            NewPulseScreen(0, nil, "mul+add", 0, 0, 60)
            object.BulletDo(function(b)
                object.Kill(b)
            end)
            object.EnemyDo(function(b)
                object.Kill(b)
            end)
            task.New(self, function()
                local W = {}
                task.init_left_wait(W)
                local d = 1
                task.Wait2(W, beat * 4 - 80)
                for _ = 1, 15 do
                    New(class.C1, -180 * d, 250, 3 * d, -3, d, 0.5)
                    d = -d
                    task.Wait2(W, beat * 4)
                end
                for D = -1, 1, 2 do
                    New(class.A2, -100 * D, 250, 0, -3, 0, -1)
                    task.Wait(80)
                    for _ = 1, 9 do
                        New(class.A1, ran:Float(220, 240) * D, ran:Float(160, 130), -ran:Float(1.8, 2.3) * D, -0.3, 3)
                        task.Wait(20)
                    end
                    task.Wait(180 - 80)
                end
                New(class.A2, 0, 250, 0, -3, 0, -1)
                task.Wait(80)
                for _ = 1, 11 do
                    for D = -1, 1, 2 do
                        New(class.A1, ran:Float(220, 240) * D, ran:Float(160, 130), -ran:Float(1.8, 2.3) * D, -0.3, 3)
                    end
                    task.Wait(30)
                end
            end)
            if player.name == "Reimu" or player.name == "Chiruno" then
                boss.CreateGroup(1, BOSS_ID)
            else
                boss.CreateGroup(2, BOSS_ID)
            end
            lstg.var.get_part = lstg.var.get_part + 1
            while bg.timer <= 6030 - 1 do
                task.Wait()
            end
        end--3boss+1get_part
        lstg.var.get_part = lstg.var.get_part + 1
        do
            New(class.D1, -240, 240, 0, 144, 1, -0.5, 1)
            task.Wait(360)
            New(class.D1, 240, 240, 0, 144, -1, -0.5, -1)
            task.Wait(360 + 100)
            local D = 1
            for k = 1, 4 do
                local t = 4 + k * 2
                local x, _d_x = (-170 * D), (340 / (t - 1) * D)
                for _ = 1, t do
                    New(class.D3, x, 250, ran:Float(0, 0.4), -ran:Float(2.5, 3.5))
                    task.Wait(10)
                    x = x + _d_x
                end
                task.Wait(180 - t * 10)
                D = -D
            end
            New(class.D4, 250, 100, -3, 1, 0, -1)
            task.Wait(180)
            New(class.D4, -250, 100, 3, 1, 0, -1)
            task.Wait(180)
            New(class.D5, 0, 250, 0, -3, 0, -1, 1)

            for _ = 1, 11 do
                New(class.D3, -70, 250, ran:Float(-2, 2), -ran:Float(2.5, 3.5))
                New(class.D3, 70, 250, ran:Float(-2, 2), -ran:Float(2.5, 3.5))
                task.Wait(90)
            end

            while bg.timer <= 9010 - 1 do
                task.Wait()
            end
        end--4
        lstg.var.get_part = lstg.var.get_part + 1
        do
            for _ = 1, 25 do
                New(class.E1, -250, 120 + ran:Float(-50, 50), ran:Float(3.5, 4), -ran:Float(0.2, 0.4))
                task.Wait(9)
            end
            task.Wait(135)
            for _ = 1, 25 do
                New(class.E1, 250, 120 + ran:Float(-50, 50), -ran:Float(3.5, 4), -ran:Float(0.2, 0.4))
                task.Wait(9)
            end
            task.Wait(135)
            local a, _d_a = (ran:Float(0, 360)), (360 / 14)
            for _ = 1, 14 do
                New(class.E2, cos(a) * 150, sin(a) * 60 + 300, 0, -0.8)
                a = a + _d_a
            end
            for _ = 1, 12 do
                New(class.E3, ran:Float(-170, 170), 250, ran:Float(-1, 1), -ran:Float(2.5, 3.5),
                        ran:Float(-1, 1), ran:Float(2.5, 3.5))
                New(class.E3, ran:Float(-170, 170), 250, ran:Float(-1, 1), -ran:Float(2.5, 3.5),
                        ran:Float(-1, 1), ran:Float(2.5, 3.5))
                task.Wait(60)
            end
            while bg.timer <= 10630 - 1 do
                task.Wait()
            end
        end--5
        lstg.var.get_part = lstg.var.get_part + 1
        do
            task.New(self, function()
                local W = {}
                task.init_left_wait(W)
                task.Wait2(W, beat * 64)
                for _ = 1, 10 do
                    New(class.E3, ran:Float(-170, 170), 250, ran:Float(-1, 1), -ran:Float(2.5, 3.5),
                            ran:Float(-1, 1), ran:Float(2.5, 3.5))
                    New(class.E3, ran:Float(-170, 170), 250, ran:Float(-1, 1), -ran:Float(2.5, 3.5),
                            ran:Float(-1, 1), ran:Float(2.5, 3.5))
                    task.Wait(60)
                    New(class.D3, -70, 250, ran:Float(-2, 2), -ran:Float(2.5, 3.5))
                    New(class.D3, 70, 250, ran:Float(-2, 2), -ran:Float(2.5, 3.5))
                    task.Wait(60)
                end
            end)
            NewPulseScreen(0, nil, "mul+add", 0, 0, 60)
            object.BulletDo(function(b)
                object.Kill(b)
            end)
            object.EnemyDo(function(b)
                object.Kill(b)
            end)
            boss.CreateGroup(3, BOSS_ID, nil, true)
            task.Wait(beat * 128)

            task.New(self, function()
                for c = 1, 60 do
                    c = c / 60
                    New(class.G1, 0 + 250 * c, 250 - 250 * c, 90, 200, 360, 800, c * 60)
                    task.Wait(15)
                end
            end)
            task.Wait(beat * 16)
            task.New(self, function()
                for c = 1, 60 do
                    c = c / 60
                    New(class.G1, 0 - 250 * c, 250 - 250 * c, 90, 200, -360, 800, c * 60)
                    task.Wait(15)
                end
            end)
            task.Wait(beat * 16)
            task.New(self, function()
                for c = 1, 40 do
                    c = c / 60
                    New(class.G1, 0, -250, 180, 200 + c * 200, -180, 200, c * 60)
                    task.Wait(8)
                end
            end)
            task.Wait(beat * 16)
            task.New(self, function()
                for c = 1, 55 do
                    c = c / 60
                    New(class.G1, 0, -250, 0, 400 - c * 200, 180, 200, c * 60)
                    task.Wait(8)
                end
            end)
            task.Wait(beat * 16)
            task.New(self, function()
                for c = 1, 40 do
                    c = c / 40
                    New(class.G1, -250, 0, 90, 500 - c * 400, -180, 400, c * 60)
                    New(class.G1, -250, 0, -90, 600 - c * 400, 180, 400, c * 60)
                    task.Wait(8)
                end
            end)
            task.Wait(beat * 16)
            task.New(self, function()
                for c = 1, 60 do
                    c = c / 60
                    New(class.G1, 250, 0, 90, 500 - c * 400, 180, 400, c * 60)
                    New(class.G1, 250, 0, -90, 600 - c * 400, -180, 400, c * 60)
                    task.Wait(8)
                end
            end)
            task.Wait(beat * 16)
            task.New(self, function()
                for c = 1, 40 do
                    c = c / 40
                    New(class.G1, 0, 250, 0, 100 + c * 200, -180, 250, c * 120)
                    New(class.G1, 0, 250, 180, 100 + c * 200, 180, 250, c * 120)
                    task.Wait(15)
                end
            end)
            task.Wait(beat * 40)
        end--6咲夜boss+3get_part
        lstg.var.get_part = lstg.var.get_part + 1
        do
            local d = 1
            for _ = 1, 2 do
                task.New(self, function()
                    for c = 1, 90 do
                        c = c / 90
                        New(class.H1, d * (-ran:Float(-45, 150) + c * 100), 250, -0.45 * d, -6 + c * 4, 90 - 90 * d)
                        task.Wait(6)
                    end
                end)
                for _ = 1, 2 do
                    New(class.H2, 250 * d, 150, -3.5 * d, -1.5, -1 * d, 0, d)
                    task.Wait2(self, beat * 16)
                end
                d = -d
            end
            for _ = 1, 2 do
                task.New(self, function()
                    for c = 1, 50 do
                        c = c / 50
                        New(class.H1, -230 * d, ran:Float(100, 224), (6 - 4 * c) * d, -1.5 - c, -90)
                        task.Wait(6)
                    end
                end)
                New(class.H3, -70 * d, 250, 0, -4, 1 * d, 0)
                task.Wait2(self, beat * 16)
                d = -d
            end
            task.New(self, function()
                for c = 1, 140 do
                    c = c / 140
                    New(class.H1, ran:Float(-192, 192), 250, ran:Float(-1, 1), -6 + 4 * c, 90)
                    task.Wait(4)
                end
            end)
            New(class.H3, -60, 250, 0, -3, 0, -1)
            task.Wait2(self, beat * 16)
            New(class.H3, 60, 250, 0, -3, 0, -1)
            task.Wait2(self, beat * 16)


        end--7
        lstg.var.get_part = lstg.var.get_part + 1
        do
            NewPulseScreen(0, nil, "mul+add", 0, 0, 60)
            object.EnemyDo(function(b)
                object.Kill(b)
            end)
            object.BulletDo(function(b)
                object.Kill(b)
            end)

            boss.CreateGroup(4, BOSS_ID)
        end--8阿吽boss
        lstg.var.get_part = lstg.var.get_part + 1
        do
            task.Wait(90)
            task.New(self, function()
                for _ = 1, 180 do
                    bg.speed = bg.speed - 1 / 180
                    task.Wait()
                end
            end)
            stage:ChangeMusicByFade("TH16_AEX_0", "TH16_AEX_1", 180, 0)
            boss.CreateGroup(5, BOSS_ID)
        end--9莉莉白boss+15get_part
        do
            task.Wait(120)
            AddMoney(500)
            New(stage.stage_clear_object, 1000000)
            task.Wait(180)
            task.New(self, function()
                while true do
                    if IsValid(UFO.big_ufo) then
                        Kill(UFO.big_ufo)
                    end
                    task.Wait()
                end
            end)
            sp:UnitListUpdate(UFO.valid)
            for _, p in pairs(UFO.valid) do
                object.RawDel(p)
            end--UFO的处理
            sp:UnitListUpdate(Beast.valid)
            for _, p in pairs(Beast.valid) do
                object.RawDel(p)
            end--动物灵的处理
            player._playersys:lock()
            mask_fader:Do("close")
            do

                local list = {}
                for _, v in pairs(EnumRes2('bgm')) do
                    if GetMusicState(v) == 'playing' then
                        table.insert(list, v)
                    end
                end
                for i = 1, 30 do
                    for _, v in ipairs(list) do
                        SetBGMVolume(v, 1 - i / 30)
                    end
                    task.Wait()
                end
                for _, v in ipairs(list) do
                    StopMusic(v)
                end
            end --音乐的淡出
            stage.group.FinishReplay()
            stage.group.FinishStage()
        end--8
    end)

end)

stage.group.DefStageValue('summary@HSiFS AfterExtra', 'init', function(self)
    self:Option()
    New(_editor_class.TH16_AEX.summary)
    ext.notUIdraw = true
    self.level = 1
    if lstg.var.lost then
        PlayMusic("SCORE")
    else
        PlayMusic("TH16_AEX_2")
    end
end)