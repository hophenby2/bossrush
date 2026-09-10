local cos, sin, abs, min, max, int = cos, sin, abs, min, max, int
local object, boss = object, boss
local task, ran, Create = task, ran, Create
local table = table
local COLOR = COLOR
local New = New
local NewSimpleBullet = NewSimpleBullet
local PlaySound = PlaySound
local IsValid = IsValid
local SetImageState = SetImageState
local Dist, Angle = Dist, Angle
local Render = Render
local Newcharge_in, Newcharge_out = Newcharge_in, Newcharge_out
local _editor_class = _editor_class

local class = _editor_class.TH08

do
    boss.Define("1a", "莉格露·奈特巴格", "TH08_7", TH08_bg, { -400, 0 }, class["SCBG1"], "Nightbug", 3)
    boss.Define("1b", "米斯蒂娅·萝蕾拉", "TH08_7", TH08_bg, { 400, 0 }, class["SCBG1"], "Lorelei", 3)
    local name = "夜蠢「夜虫之歌」"
    local sc1 = boss.card.New(name, 1, 1, 60, 650)
    local sc2 = boss.card.New(name, 1, 1, 60, 650)
    boss.card.add({ { sc1, "1a" }, { sc2, "1b" } }, 3, name, 14)
    function sc1:before()
        task.MoveTo(-70, 100, 60, 2)
    end
    function sc1:init()
        local wi = 2
        task.New(self, function()
            boss.violent(self)
            wi = 4
        end)
        task.New(self, function()
            local d = 1
            local s = 1
            local xx = 1
            do
                local t, _d_t = (6), (2)
                while true do
                    task.Wait()
                    boss.cast(self, 160)
                    local v, a, rot, r2
                    rot = ran:Float(0, 360)
                    for c = 1, 60 do
                        for i = 1, wi do
                            r2 = rot + i * 360 / wi
                            v, a = 6, r2
                            New(class["bullet7-1"], self.x - 11 * xx, self.y + 16, v - c / 11, a, d, s * (70 + c))
                            New(class["bullet7-1"], self.x - 11 * xx, self.y + 16, v - c / 11, 180 - a, -d, s * (70 + c))
                        end
                        s = -s
                        rot = rot + 3 * d
                        task.Wait(3)
                    end
                    d = -d
                    task.Wait(60)

                    do
                        for _ = 1, 12 do
                            do
                                for _a in sp.math.AngleIterator(0, t) do
                                    for _ = 1, t do
                                        New(class["bullet7-3"], self.x - 11 * xx, self.y + 16, 3, _a, 0.7 * d)
                                        if wi > 2 then
                                            New(class["bullet7-3"], self.x - 11 * xx, self.y + 16, 3, _a, -0.7 * d)
                                        end
                                    end
                                end
                            end
                            task.Wait(4)
                        end
                    end
                    task.Wait(12)
                    task.New(self, function()
                        task.Wait(30)
                        if self.dx > 0 then
                            xx = 1
                        end
                        if self.dx < 0 then
                            xx = -1
                        end
                    end)
                    task.MoveToPlayer(60, -150, 150, 50, 100,
                            20, 40, 16, 32, 2, 1)
                    task.Wait(60)
                    t = t + _d_t
                end
            end
        end)
    end
    function sc2:before()
        task.MoveTo(0, 120, 60, 2)
    end
    function sc2:init()
        local yr, w = 0, 4
        task.New(self, function()
            boss.violent(self)
            yr = -2
            w = 5
            while true do
                task.Wait(60)
                local d = 1
                task.New(self, function()
                    do
                        for _ = 1, 2 do
                            task.New(self, function()
                                local rot, x, y, v = 0, self.x, self.y
                                for _ = 1, 60 do
                                    v = 2
                                    for _ = 1, w do
                                        New(class["bullet7-2"], x, y, v, rot, 10)
                                        v = v + 0.2
                                    end
                                    task.Wait()
                                    rot = rot - d * 790 / 59
                                    x = x - 8
                                    y = y - yr
                                end
                            end)
                            local rot, x, y, v = 180, self.x, self.y
                            for _ = 1, 60 do
                                v = 2
                                for _ = 1, w do
                                    New(class["bullet7-2"], x, y, v, rot, 10)
                                    v = v + 0.2
                                end
                                task.Wait()
                                rot = rot + d * 790 / 59
                                x = x + 8
                                y = y - yr
                            end
                            d = -d
                            task.Wait(30)
                        end
                    end
                end)
                task.Wait(160)
            end
        end)
        task.New(self, function()
            do
                while true do
                    task.Wait()
                    boss.cast(self, 160)
                    local d = 1
                    task.New(self, function()
                        do
                            for _ = 1, 2 do
                                task.New(self, function()
                                    local rot, x, y, v = 0, self.x, self.y
                                    for _ = 1, 60 do
                                        v = 2
                                        for _ = 1, w do
                                            New(class["bullet7-2"], x, y, v, rot, COLOR.GREEN)
                                            v = v + 0.2
                                        end
                                        task.Wait()
                                        rot = rot - d * 790 / 59
                                        x = x - 8
                                        y = y + yr
                                    end
                                end)
                                local rot, x, y, v = 180, self.x, self.y
                                for _ = 1, 60 do
                                    v = 2
                                    for _ = 1, w do
                                        New(class["bullet7-2"], x, y, v, rot, COLOR.GREEN)
                                        v = v + 0.2
                                    end
                                    task.Wait()
                                    rot = rot + d * 790 / 59
                                    x = x + 8
                                    y = y + yr
                                end
                                d = -d
                                task.Wait(30)
                            end
                        end
                    end)
                    task.Wait(160)
                    task.MoveToPlayer(60, -150, 150, 50, 144,
                            20, 40, 16, 32, 2, 3)
                    task.Wait(60)
                end
            end
        end)

    end
end--boss1
do
    boss.Define("2a", "米斯蒂娅·萝蕾拉", "TH08_7", TH08_bg, { -400, 0 }, class["SCBG2"], "Lorelei", 3)
    boss.Define("2b", "上白泽慧音", "TH08_7", TH08_bg, { 400, 400 }, class["SCBG2"], "Kamishirasawa", 3)
    local name = "野符「鹈鴂鵷鶵」"
    local sc1 = boss.card.New(name, 1, 1, 80, 670)
    local sc2 = boss.card.New(name, 1, 1, 80, 670)
    boss.card.add({ { sc1, "2a" }, { sc2, "2b" } }, 3, name, 15)
    function sc1:before()
        task.MoveTo(0, 160, 60, 2)
    end
    function sc1:init()
        local tb = 3
        task.New(self, function()
            boss.violent(self)

            tb = 6
            if self.blind and IsValid(self.blind) then
                object.Del(self.blind)
            end
            task.Wait(60)
            New(class["Blindness"], self.x, self.y, 2, self.y)
        end)
        self.blind = New(class["Blindness"], self.x, self.y, 4, self.y)
        task.New(self, function()
            do
                while true do
                    task.Wait()
                    boss.cast(self, 160)
                    local d = 1
                    task.New(self, function()
                        do
                            for _ = 1, 2 do
                                do
                                    local rot, _d_rot = (ran:Float(0, 360)), (d * 800 / 59)
                                    local t, _d_t = (90), (45 / 59)
                                    for _ = 1, 60 do
                                        do
                                            local v, _d_v = (2), (0.6 / tb)
                                            local a, _d_a = (rot), (1 * d)
                                            for _ = 1, tb do
                                                New(class["bullet7-2"], self.x + cos(a + t * d) * 150, self.y + sin(a + t * d) * 35, v, a, 5)
                                                v = v + _d_v
                                                a = a + _d_a
                                            end
                                        end
                                        task.Wait()
                                        rot = rot + _d_rot
                                        t = t + _d_t
                                    end
                                end
                                d = -d
                                task.Wait(30)
                            end
                        end
                    end)
                    task.Wait(160)
                    task.MoveToPlayer(60, -150, 150, 50, 144,
                            32, 64, 16, 32, 2, 3)
                    task.Wait(60)
                end
            end
        end)

    end

    function sc2:before()
        task.MoveTo(0, 70, 60, 2)
    end
    function sc2:init()
        local wait = 10
        local cao = false
        task.New(self, function()
            boss.violent(self)
            wait = 5
            cao = true
        end)
        task.New(self, function()
            local d = 1
            do
                local w, _d_w = (3), (1)
                while true do
                    task.Wait()
                    Newcharge_out(self.x, self.y, 255, 255, 100)
                    boss.cast(self, w * 100)
                    task.New(self, function()
                        do
                            for _ = 1, w do
                                PlaySound("nice", 1, self.x, false)
                                do
                                    local a, _d_a = (ran:Float(0, 360)), (360 / (w * 2))
                                    for _ = 1, w * 2 do
                                        object.Connect(self, New(class["laser7-1"], self.x, self.y, d * 0.2, a, 150),
                                                0, true)
                                        if cao then
                                            object.Connect(self, New(class["laser7-1"], self.x, self.y, -d * 0.1, a, 150),
                                                    0, true)
                                        end
                                        a = a + _d_a
                                    end
                                end
                                d = -d
                                task.Wait(100)
                            end
                        end
                    end)
                    task.Wait(w * 0.7 * 100)
                    task.MoveToPlayer(60, -96, 96, 90, 40, 20, 40, 16, 32, 2, 1)
                    task.Wait(180)
                    w = w + _d_w
                end
            end
        end)
        task.New(self, function()
            local posa
            do
                while true do
                    posa = ran:Float(0, 360)
                    do
                        local a, _d_a = (ran:Float(0, 360)), (120)
                        for _ = 1, 3 do
                            NewSimpleBullet(arrow_big, COLOR.ORANGE, self.x + cos(posa) * 50, self.y + sin(posa) * 50, 2, a, false, 0, true, true)

                            a = a + _d_a
                        end
                    end
                    task.Wait(wait)
                end
            end
        end)

    end
end--boss2
do
    boss.Define("3a", "博丽灵梦", "TH08_7", TH08_bg, { 0, 500 }, class["SCBG3"], "Reimu", 3)
    boss.Define("3b", "雾雨魔理沙", "TH08_7", TH08_bg, { 0, 500 }, class["SCBG3"], "Marisa", 3)
    local non_sc1 = boss.card.New("", 1, 3, 60, 300)
    local non_sc2 = boss.card.New("", 1, 2, 60, 650)
    boss.card.add({ { non_sc1, "3a" }, { non_sc2, "3b" } }, 3, "非符", 16)
    function non_sc1:before()
        self.smear = {}
        boss.ns_group.init(self)
        task.MoveTo(-70, 100, 60, 2)
    end
    function non_sc1:init()
        local para = { w1 = 9, s1 = 6 }
        task.New(self, function()
            boss.violent(self)
            para = { w1 = 16, s1 = 12 }
        end)
        task.New(self, function()
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            local d, v = 1, ran:Float(12, 14)
            while true do
                for i = 1, 180 do
                    object.SetV(self, v * sin(i) * d, 0)
                    task.Wait()
                    if self.x * d > 330 then
                        self.x = -self.x
                        self.y = ran:Float(100, 160)
                    end

                end
                task.Wait(80)
                d = -d
                v = ran:Float(12, 14)
            end
        end)
        task.New(self, function()
            task.Wait(80)
            local tem
            while true do
                for i = 1, 8 do
                    tem = 90
                    for _ = 1, para.w1 do
                        Create.bullet_dec_setangle(self.x, self.y, square, 8,
                                { v = 2, a = tem / 6 + i * 45, time = 50, wait = 25 },
                                { v = 2, a = tem / 3 + i * 45, time = 30, wait = 0 },
                                { v = 2, a = tem + i * 45, time = 30, wait = 0 },
                                { v = 2, a = tem / 0.5 + i * 45, time = 30, wait = 0 })
                        tem = tem - 180 / (para.w1 - 1)
                    end
                    for v = 2, 3.4, 0.2 do
                        Create.bullet_dec_setangle(self.x, self.y, square, 2,
                                { v = v, a = i * 45, time = 50, wait = 25 }, { v = v, a = i * 45, time = 50, wait = 25 })
                    end
                    PlaySound("tan00", 0.1, 0, true)
                end
                task.Wait(60)
                for _ = 1, para.s1 do
                    tem = 90
                    for _ = 1, 10 do
                        Create.bullet_dec_setangle(self.x, self.y, square, 6,
                                { v = 2, a = tem / 6 - 90, time = 50, wait = 25 },
                                { v = 2, a = tem / 3 - 90, time = 30, wait = 0 },
                                { v = 2, a = tem - 90, time = 30, wait = 0 },
                                { v = 2, a = tem / 0.5 - 90, time = 30, wait = 0 })
                        tem = tem - 180 / 9
                    end
                    for v = 2, 3.4, 0.2 do
                        Create.bullet_dec_setangle(self.x, self.y, square, 2,
                                { v = v, a = -90, time = 50, wait = 25 }, { v = v, a = -90, time = 50, wait = 25 })
                    end
                    PlaySound("tan00", 0.1, 0, true)
                    task.Wait(36 / para.s1)
                end

                task.Wait(80)
            end
        end)
    end
    function non_sc1:frame()
        table.insert(self.smear, { x = self.x, y = self.y + 4 * sin(self.ani * 4), rot = self.rot,
                                   alpha = 150, img = self.img, hscale = self.hscale, vscale = self.vscale })
        for _, s in ipairs(self.smear) do
            s.alpha = max(0, s.alpha - 8)
        end
        for i = #self.smear, 1, -1 do
            if self.smear[i].alpha == 0 then
                table.remove(self.smear, i)
            end
        end
    end
    function non_sc1:render()
        for _, s in ipairs(self.smear) do
            SetImageState(s.img, "mul+add", s.alpha, 255, 227, 132)
            Render(s.img, s.x, s.y, s.rot, s.hscale, s.vscale)
        end
    end
    function non_sc1:del()
        object.StopMoving(self)
        boss.ns_group.del(self)
    end

    function non_sc2:before()
        boss.ns_group.init(self)
        task.MoveTo(30, 100, 60, 2)
    end
    function non_sc2:init()
        local dv = 0
        task.New(self, function()
            boss.violent(self)
            dv = 0.6
            task.Wait(60)
            local r, R = 90, -90
            local rot
            while true do
                rot = 1
                for v = 2.5, 3.5, 0.5 do
                    Create.bullet_dec_setangle(self.x + cos(R) * 30, self.y + sin(R) * 30, grain_a, 14,
                            { v = v, a = r, time = 50, wait = 25 },
                            { v = 2, a = r + 120 * rot, time = 50, wait = 25 })
                    Create.bullet_dec_setangle(self.x + cos(180 - R) * 30, self.y + sin(180 - R) * 30, grain_a, 14,
                            { v = v, a = 180 - r, time = 50, wait = 25 },
                            { v = 2, a = 180 - r - 120 * rot, time = 50, wait = 25 })
                    rot = rot - 0.5
                end
                PlaySound("tan00")
                task.Wait(3)
                r = r + 13
                R = R + 7
            end
        end)
        task.New(self, function()
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            local r, a, angle
            local s = 0
            local b
            while true do
                boss.cast(self, 120)
                r = 0
                angle = Angle(self, player)
                for i = 1, 120 do
                    a = angle + r * 70 * LineNum(s)
                    b = Create.bullet_changeangle(self.x + cos(a) * i, self.y + sin(a) * i,
                            star_small, ({ 2, 6 })[i % 2 + 1], ({ 1, 2 })[i % 2 + 1] + dv, angle, { wait = 0, time = 50, r = r })
                    b.omiga = -3
                    a = angle - r * 70 * LineNum(s)
                    b = Create.bullet_changeangle(self.x + cos(a) * i, self.y + sin(a) * i,
                            star_small, ({ 6, 2 })[i % 2 + 1], ({ 1, 2 })[i % 2 + 1] + dv, angle, { wait = 0, time = 50, r = -r })
                    b.omiga = 3

                    r = r + 0.1
                    PlaySound("tan00")
                    task.Wait()
                end
                task.MoveToPlayer(60, -96, 96, 80, 120,
                        20, 40, 16, 32, 2, 1)
                task.Wait(40)
                s = (s + 25) % 180
            end
        end)
    end
    non_sc2.del = boss.ns_group.del

    local name = "恋灵「阴阳光线」"
    local sc1 = boss.card.New(name, 1, 1, 60, 900)
    local sc2 = boss.card.New(name, 1, 1, 60, 900)
    boss.card.add({ { sc1, "3a" }, { sc2, "3b" } }, 3, name, 17)
    function sc1:before()
        boss.ns_group.nextcard(self)
        task.MoveTo(-70, 120, 60, 2)
    end
    function sc1:init()
        local way = 10
        boss.card.UnlockOD(self, 11)
        task.New(self, function()
            boss.violent(self)
            way = 20
            task.Wait(60)
            local rot = 0
            local s = 0
            while true do
                for _ = 1, abs(math.ceil(cos(s) * 10)) do
                    for a = 1, 2 do
                        for t = -1, 1 do
                            NewSimpleBullet(square, 2, self.x, self.y, 5, a * 180 + t * 18 + rot)
                        end
                    end
                    PlaySound("tan00", 0.1, 0, false)
                    task.Wait(2)
                end
                rot = rot + 13
                s = s + 7
                task.Wait(5)
            end
        end)
        task.New(self, function()
            local d = 1
            local a
            while true do
                for v = 1, 3 do
                    a = ran:Float(0, 360)
                    for _ = 1, way do
                        Create.bullet_changeangle(self.x, self.y, ball_light, ran:Int(1, 7) * 2, v, a, { wait = 0, time = 120, r = d * 0.6 })
                        PlaySound("kira00")
                        a = a + 360 / way
                    end
                    d = -d
                end
                task.Wait(100)
            end
        end)
        task.New(self, function()
            while true do
                task.Wait(180)
                task.MoveToPlayer(180, -120, 120, 110, 160,
                        80, 120, 16, 32, 2, 1)
                boss.cast(self, 120 * 60)
            end
        end)

    end

    function sc2:before()
        boss.ns_group.nextcard(self)
        task.MoveTo(0, 50, 60, 2)
    end
    function sc2:init()
        local way = 3
        local wait = 420
        boss.card.UnlockOD(self, 12)
        task.New(self, function()
            boss.violent(self)
            way = 5
            wait = 300
        end)
        task.New(self, function()
            do
                while true do
                    task.Wait()
                    boss.cast(self, 60)
                    do
                        local a = Angle(self, player)
                        for _ = 1, way do
                            object.Connect(self, New(class["laser7-2"], self.x, self.y, COLOR.GREEN, a + 75, 30, -90 / 240, -150))
                            object.Connect(self, New(class["laser7-2"], self.x, self.y, COLOR.GOLDEN_YELLOW, a - 180, 120, 180 / 330, -150))
                            a = a + 360 / way
                        end
                    end
                    do
                        local a = Angle(self, player)
                        for _ = 1, way do
                            object.Connect(self, New(class["laser7-2"], self.x, self.y, COLOR.GREEN, a + 75, 30, -90 / 240, 0))
                            object.Connect(self, New(class["laser7-2"], self.x, self.y, COLOR.GOLDEN_YELLOW, a - 180, 120, 180 / 330, 0))

                            a = a + 360 / way
                        end
                    end
                    task.Wait(wait)
                end
            end
        end)
    end
end--boss3
do
    boss.Define("4a", "博丽灵梦", "TH08_7", TH08_bg, { -400, 0 }, class["SCBG3+"], "Reimu", 3)
    local sc1 = boss.card.New("梦符「行星大结界-Special」", 53, 53, 53, 2100)
    boss.card.add({ { sc1, "4a" } }, 3, "梦符「行星大结界-Special」", 18, 11)
    function sc1:before()
        if ext.sc_pr then
            ToBigScreen(60)
        end
        self.before = lstg.var.graze
        task.MoveTo(0, 160, 60, 2)
    end
    function sc1:init()
        self.colli = false
        _object.set_color(self, "", 255, 150, 150, 150)
        task.New(self, function()
            task.Wait()
            boss.cast(self, 120 * 60)
            Newcharge_in(self.x, self.y, 255, 255, 100)
            task.Wait(120)
            task.New(self, function()
                do
                    local a, _d_a = (90), (0.5)
                    for _ = 1, 720 do
                        self.x = cos(a) * 160
                        self.y = sin(a) * 160
                        task.Wait()
                        a = a + _d_a
                    end
                end
            end)
            PlaySound("boon01", 1, 0, false)
            local A = Angle(self, player) + 360 / 16 / 2
            local rot2, rot1 = A, A
            task.New(self, function()
                do
                    local _A, _d_A = (Angle(self, player) + 360 / 16 / 2), (-360 / 16 / 2)
                    for _ = 1, 4 do
                        do
                            local s2, _d_s2 = (90), (-0.5)
                            for _ = 1, 180 do
                                do
                                    local a, _d_a = (rot2), (360 / 16)
                                    for _ = 1, 16 do
                                        NewSimpleBullet(ball_big, int(sin(s2) * 8) + 8, self.x + cos(a) * 25, self.y + sin(a) * 25, 50, a)

                                        a = a + _d_a
                                    end
                                end
                                rot2 = _A - sin(90 - s2) * (360 / 16 / 2)
                                task.Wait()
                                s2 = s2 + _d_s2
                            end
                        end

                        _A = _A + _d_A
                    end
                end
            end)
            do
                local _A, _d_A = (Angle(self, player) + 360 / 16 / 2), (360 / 16 / 2)
                for _ = 1, 4 do
                    do
                        local s1, _d_s1 = (90), (-0.5)
                        for _ = 1, 180 do
                            do
                                local a, _d_a = (rot1), (360 / 16)
                                for _ = 1, 16 do
                                    NewSimpleBullet(ball_big, int(sin(s1) * 8) + 8, self.x, self.y, 50, a)

                                    a = a + _d_a
                                end
                            end
                            rot1 = _A + sin(90 - s1) * (360 / 16 / 2)
                            task.Wait()
                            s1 = s1 + _d_s1
                        end
                    end

                    _A = _A + _d_A
                end
            end
            Newcharge_out(self.x, self.y, 255, 255, 100)
            task.Wait(120)
            boss.cast(self, 120 * 60)
            Newcharge_in(self.x, self.y, 255, 255, 100)
            task.Wait(120)
            task.New(self, function()
                do
                    for _ = 1, 12 do
                        do
                            local a, _d_a = (Angle(self, player)), (360 / 9)
                            for _ = 1, 9 do
                                do
                                    local v, _d_v = (1), (1)
                                    for _ = 1, 2 do
                                        NewSimpleBullet(ball_light, 2, self.x + cos(a) * 50, self.y + sin(a) * 50, v, a)

                                        v = v + _d_v
                                    end
                                end

                                a = a + _d_a
                            end
                        end
                        task.Wait(60)
                    end
                end
            end)
            task.New(self, function()
                do
                    local a, _d_a = (90), (-0.5)
                    for _ = 1, 720 do
                        self.x = cos(a) * 160
                        self.y = sin(a) * 160
                        task.Wait()
                        a = a + _d_a
                    end
                end
            end)
            PlaySound("boon01", 1, 0, false)
            local S = 0
            local _A = Angle(self, player) + 15
            local _rot2, _rot1 = _A, _A
            task.New(self, function()
                do
                    local A2, _d_A = (Angle(self, player) + 15), (-15)
                    for _ = 1, 5 do
                        do
                            local s2, _d_s2 = (90), (-0.625)
                            for _ = 1, 144 do
                                local v = 100 + sin(S) * 30
                                do
                                    local a, _d_a = (_rot2), (30)
                                    for _ = 1, 12 do
                                        NewSimpleBullet(ball_big, int(sin(s2) * 8) + 8, self.x + cos(a) * v / 2, self.y + sin(a) * v / 2, v, a)

                                        a = a + _d_a
                                    end
                                end
                                _rot2 = A2 - sin(90 - s2) * 15
                                task.Wait()
                                s2 = s2 + _d_s2
                            end
                        end

                        A2 = A2 + _d_A
                    end
                end
            end)
            do
                local _A2, _d_A = (Angle(self, player) + 15), (15)
                for _ = 1, 5 do
                    do
                        local s1, _d_s1 = (90), (-0.625)
                        for _ = 1, 144 do
                            S = S + 1
                            local v = 100 + sin(S) * 30
                            do
                                local a, _d_a = (_rot1), (30)
                                for _ = 1, 12 do
                                    NewSimpleBullet(ball_big, int(sin(s1) * 8) + 8, self.x, self.y, v, a)

                                    a = a + _d_a
                                end
                            end
                            _rot1 = _A2 + sin(90 - s1) * 15
                            task.Wait()
                            s1 = s1 + _d_s1
                        end
                    end

                    _A2 = _A2 + _d_A
                end
            end
            Newcharge_out(self.x, self.y, 255, 255, 100)
            task.Wait(120)
            boss.cast(self, 120 * 60)
            Newcharge_in(self.x, self.y, 255, 255, 100)
            task.Wait(120)
            task.New(self, function()
                do
                    while true do
                        do
                            local rot, _d_rot = (Angle(self, player)), (15)
                            for _ = 1, 24 do
                                do
                                    local v, _d_v = (1), (0.3)
                                    local a, _d_a = (rot), (7.5)
                                    for _ = 1, 3 do
                                        NewSimpleBullet(square, 2, self.x, self.y, v, a)

                                        v = v + _d_v
                                        a = a + _d_a
                                    end
                                end

                                rot = rot + _d_rot
                            end
                        end
                        task.Wait(70)
                    end
                end
            end)
            task.New(self, function()
                do
                    local a, _d_a = (90), (0.4)
                    while true do
                        self.x = cos(a) * 160
                        self.y = sin(a) * 160
                        task.Wait()
                        a = a + _d_a
                    end
                end
            end)
            PlaySound("boon01", 1, 0, false)
            do
                local __rot1, _d_rot1 = (Angle(self, player) + 15), (-0.2)
                local _S, _d_S = (0), (1)
                while true do
                    do
                        local a, _d_a = (__rot1), (360 / 15)
                        for _ = 1, 16 do
                            local v = 90 + sin(_S) * 40
                            NewSimpleBullet(ball_big, int(sin(_S) * 8) + 8, self.x, self.y, v, a)

                            a = a + _d_a
                        end
                    end
                    task.Wait()
                    __rot1 = __rot1 + _d_rot1
                    _S = _S + _d_S
                end
            end
        end)
    end
    function sc1:del()
        self.after = lstg.var.graze, lstg.var.dead
        if self.after - self.before >= 10000 then
            ext.achievement:get(5)
        end
    end

    boss.Define("4b", "雾雨魔理沙", "TH08_7", TH08_bg, { 400, 0 }, class["SCBG3+"], "Marisa", 3)
    local sc2 = boss.card.New("魔符「星中壳-Special」", 38, 38, 38, 2100)
    boss.card.add({ { sc2, "4b" } }, 3, "魔符「星中壳-Special」", 19, 12)
    function sc2:before()
        if ext.sc_pr then
            ToBigScreen(60)
        end
        task.MoveTo(0, 0, 60, 2)
    end
    function sc2:init()
        self.colli = false
        _object.set_color(self, "", 255, 150, 150, 150)
        task.New(self, function()
            boss.cast(self, 120 * 60)
            local bulletshooter = function(D, n)
                return function()
                    local self = task.GetSelf()
                    local rot = 0
                    local d = 1
                    local s = 90
                    local S = 0
                    local c = ran:Int(1, 7) * 2
                    for _ = 1, 200 do
                        for i = 1, n do
                            New(class["bullet7-4"], self.x, self.y, c, i * 360 / n + rot, 65 + sin(S) * 18, (180 - (180 - 360 / n) / 2) * d, n)
                        end
                        rot = rot + (0.4 - (sin(s) * sin(s) * sin(s)) * 0.7) * D
                        d = -d
                        s = max(0, s - 0.6)
                        task.Wait()
                        S = S + 360 / 199
                    end
                end
            end
            local D = 1
            local n, tt = 3, 200
            while true do
                for i = 1, n do
                    New(class["bullet7-5"], self.x, self.y, i * 360 / n)
                end
                Newcharge_in(self.x, self.y, 255, 255, 100)
                task.Wait(60)
                task.New(self, bulletshooter(D, n))
                task.Wait(tt)
                D = -D
                task.Wait(30)
                n = n + 1
                tt = tt - 15
            end
        end)
    end
end--boss4
do
    boss.Define("5a", "因幡帝", "TH08_3", TH08_bg, { -200, 500 }, class["SCBG4"], "Tewi", 3)
    boss.Define("5b", "铃仙·优昙华院·因幡", "TH08_3", TH08_bg, { 200, 500 }, class["SCBG4"], "Reisen", 3)
    local non_sc1 = boss.card.New("", 50, 50, 50, 1000)
    local non_sc2 = boss.card.New("", 50, 50, 50, 1000)
    boss.card.add({ { non_sc1, "5a" }, { non_sc2, "5b" } }, 3, "时非1", 20)
    function non_sc1:before()
        boss.show_aura(self, false)
        if ext.sc_pr then
            task.New(self, function()
                for i = 1, 54 do
                    SetBGMVolume("TH08_3", 1 - i / 54)
                    task.Wait()
                end
                PlayMusic("TH08_3")
            end)
        end
        task.MoveTo(0, 50, 60, 2)
    end
    function non_sc1:init()
        _object.set_color(self, "", 255, 120, 120, 120)
        self.colli = false
        local ball_mid_c = ball_mid_c
        local grain_a = grain_a
        local ball_big = ball_big
        task.New(self, function()
            local t = 25
            local v = 2
            local c = 2
            for _ = 1, 7 do
                local a = 0
                for _ = 1, t do
                    Create.bullet_accel(self.x + cos(a) * 50, self.y + sin(a) * 50, ball_mid_c, c, 0.8, v, a * c)
                    a = a - 180 / t
                end
                PlaySound("kira00", 0.2, self.x, false)
                task.Wait(26)
                t = t + 2
                v = v - 0.5 / 6
                c = c + 1
            end
            task.MoveTo(-150, 144, 25, 2)
            task.New(self, function()
                local x = 0
                for _ = 1, 3 do
                    task.MoveTo(150 + x, 144, 26, 2)
                    task.MoveTo(-150 - x, 144, 26, 2)
                    x = x - 20
                end
                task.MoveTo(0, 120, 26, 2)
            end)
            local d = 1
            for _ = 1, 7 do
                local a = -45 * d - 90
                v = 1
                for _ = 1, 10 do
                    NewSimpleBullet(ball_big, 16, self.x, self.y, v, a, false, 0, false, true)
                    PlaySound("nice", 0.5, self.x, false)

                    a = a + 10 * d
                    v = v + 2 / 9
                end
                d = -d
                task.Wait(27)
            end
            task.Wait(21)
            for e = 60, 10, -10 do
                for a = -6, 6 do
                    a = -90 + a * 10
                    Create.bullet_dec_setangle(self.x, self.y, grain_a, 4,
                            { v = 5, a = a, time = 30, wait = 30 }, { v = 2, a = a + e, time = 30, wait = 30 })
                    Create.bullet_dec_setangle(self.x, self.y, grain_a, 4,
                            { v = 5, a = a, time = 30, wait = 30 }, { v = 2, a = a - e, time = 30, wait = 30 })
                end
                task.Wait(14)
                for a = -6, 6 do
                    a = 90 + a * 10
                    Create.bullet_dec_setangle(self.x, self.y, grain_a, 4,
                            { v = 5, a = a, time = 30, wait = 30 }, { v = 2, a = a + e, time = 30, wait = 30 })
                    Create.bullet_dec_setangle(self.x, self.y, grain_a, 4,
                            { v = 5, a = a, time = 30, wait = 30 }, { v = 2, a = a - e, time = 30, wait = 30 })
                end
                task.Wait(13)
            end
            for a = 1, 13 do
                a = 90 + a * 10
                Create.bullet_dec_setangle(self.x, self.y, grain_a, 4,
                        { v = 5, a = a, time = 30, wait = 30 }, { v = 2, a = a, time = 30, wait = 30 })
                Create.bullet_dec_setangle(self.x, self.y, grain_a, 4,
                        { v = 5, a = a, time = 30, wait = 30 }, { v = 2, a = a, time = 30, wait = 30 })
            end
        end)
        task.New(self, function()
            task.Wait(1335 - 120)
            task.MoveTo(-100, 120, 60, 2)
            object.Kill(self)
        end)
    end
    function non_sc1:del()
        Newcharge_out(self.x, self.y, 255, 255, 100)
    end

    function non_sc2:before()
        boss.show_aura(self, false)
        task.MoveTo(0, 144, 60, 2)
    end
    function non_sc2:init()
        _object.set_color(self, "", 255, 120, 120, 120)
        local gun_bullet = gun_bullet
        task.New(self, function()
            self.colli = false
            local c = ran:Float(0, 360)
            for _ = 1, 7 do
                for _ = 1, 13 do
                    local a = c
                    for _ = 1, 2 do
                        Create.bullet_decel(self.x, self.y, gun_bullet, 6, 4, 2, a)
                        PlaySound("tan00", 0.1, self.x / 200)
                        a = a + 180
                    end
                    task.Wait(2)
                    c = c - 11
                end
            end
            task.MoveTo(0, 50, 25, 2)
            task.Wait(39)
            local a = 0
            for _ = 1, 3 do
                for Y = -1, 1, 2 do
                    for x = -1.5, 1.5, 3 / 14 do
                        Create.bullet_setvxvy(self.x, self.y, gun_bullet, 1, x * cos(a) - (Y * 1.5) * sin(a), x * sin(a) + (Y * 1.5) * cos(a))
                    end
                end
                for X = -1, 1, 2 do
                    for y = 1.5, -1.5, -3 / 14 do
                        Create.bullet_setvxvy(self.x, self.y, gun_bullet, 1, (X * 1.5) * cos(a) - y * sin(a), (X * 1.5) * sin(a) + y * cos(a))
                    end
                end
                PlaySound("tan00", 0.1, self.x / 200)
                task.Wait(52)
                a = a + 45
            end
            task.Wait(15)
            for i = 1, 94 do
                for A in sp.math.AngleIterator(0, 5) do
                    Create.bullet_accel(self.x + cos(A) * i * 1.2, self.y + sin(A) * i * 1.2, gun_bullet, 2, 0.1, 0.9 - i / 94 * 0.6, A + i * 40)
                    PlaySound("tan00", 0.1, 0, true)
                end
                task.Wait(2)
            end
        end)
        task.New(self, function()
            task.MoveTo(-100, 50, 26, 2)
            task.MoveTo(0, -30, 26, 2)
            task.MoveTo(100, 50, 26, 2)
            task.MoveTo(0, 144, 26, 2)
            task.MoveTo(-100, 50, 26, 2)
            task.MoveTo(0, -30, 26, 2)
            task.MoveTo(100, 50, 26, 2)
        end)
        task.New(self, function()
            task.Wait(1335 - 120)
            task.MoveTo(100, 120, 60, 2)
            object.Kill(self)
        end)
    end
    function non_sc2:del()
        Newcharge_out(self.x, self.y, 255, 255, 100)
    end

    local non_sc3 = boss.card.New("", 60, 60, 60, 600)
    local non_sc4 = boss.card.New("", 60, 60, 60, 600)
    boss.card.add({ { non_sc3, "5a" }, { non_sc4, "5b" } }, 3, "时非2", 21)
    function non_sc3:before()
        self.colli = false
        if ext.sc_pr then
            _object.set_color(self, "", 255, 120, 120, 120)
            boss.show_aura(self, false)
            task.New(self, function()
                for i = 1, 54 do
                    SetBGMVolume("TH08_3", 1 - i / 54)
                    task.Wait()
                end
                PlayMusic("TH08_3", 1, 23.29 - 2)
            end)
            task.MoveTo(-100, 120, 60, 2)
        end
    end
    function non_sc3:init()
        local ball_mid, ball_mid_c, grain_a = ball_mid, ball_mid_c, grain_a
        task.New(self, function()
            task.Wait(120)
            for _, T in ipairs({ 40, 47, 49, 20, 18, 10, 39, 29, 12, 24, 11, 15, 12, 45, 21, 25, 16, 18, 12, 23, 23, 21, 17, 14, 23, 23, 17, 18, 12, 62 }) do
                for a, i in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                    Create.bullet_dec_acc(self.x, self.y, ball_mid, ({ 10, 11 })[i % 2 + 1], 6, ({ 3, 2 })[i % 2 + 1], a, false, false)
                end
                PlaySound("kira00", 0.5, 0, true)
                task.Wait(T)
            end
        end)
        task.New(self, function()
            task.Wait(120)
            while true do
                task.MoveToPlayer(60, -96, 96, 112, 144,
                        32, 64, 16, 32, 2, 3)
                task.Wait(60)
            end
        end)
        task.New(self, function()
            task.Wait(729 + 120)
            object.BulletDo(function(unit)
                object.Kill(unit)
            end)
            local t = { 21, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 2, 0, 0 }
            local w = { 15, 15, 16, 7, 5, 3, 19, 3, 5, 7, 3, 5, 4, 15 }
            local d = 1
            local rot, a
            for T = 1, 14 do
                task.Wait(t[T])
                rot = 90
                for _ = 1, w[T] do
                    a = rot
                    for i = 1, 18 do
                        Create.bullet_accel(self.x, self.y, ball_mid_c, ({ 2, 6 })[i % 2 + 1], 1, 5, a, false, true)
                        PlaySound("tan00", 0.1, self.x / 256, true)
                        a = a + 20
                    end
                    task.Wait(3)
                    rot = rot + d
                end
                d = -d
            end
            w = { 46, 17, 16, 14, 65, 21, 46, 49, 95 }
            t = { 0, 0, 0, 0, 0, 7, 0, 0, 0 }
            local i = { 3, -3, 2, -2, 4, -4, 5, -5, 3 }
            local l = 4
            for T = 1, 9 do
                task.Wait(t[T])
                a = -90
                for _ = 1, w[T] do
                    rot = a
                    for _ = 1, l do
                        Create.bullet_dec_setangle(self.x + cos(rot) * 50, self.y + sin(rot) * 50, grain_a, 4,
                                { v = 5, a = rot, time = 30, wait = 30 }, { v = 3, a = rot * 2, time = 30, wait = 30 })
                        PlaySound("tan00", 0.1, self.x / 256, true)
                        rot = rot + 360 / l
                    end
                    task.Wait(3)
                    a = a + i[T]
                end
                l = l + 1
            end
        end)
        task.New(self, function()
            task.Wait(1503 + 120)
            object.Kill(self)
        end)
    end
    function non_sc3:del()
        Newcharge_out(self.x, self.y, 255, 255, 100)
        _object.set_color(self, "", 255, 255, 255, 255)
    end

    function non_sc4:before()
        self.colli = false
        if ext.sc_pr then
            _object.set_color(self, "", 255, 120, 120, 120)
            boss.show_aura(self, false)
            task.New(self, function()
                for i = 1, 54 do
                    SetBGMVolume("TH08_3", 1 - i / 54)
                    task.Wait()
                end
                PlayMusic("TH08_3", 1, 23.29 - 2)
            end)
            task.MoveTo(100, 120, 60, 2)
        end
    end
    function non_sc4:init()
        local gun_bullet = gun_bullet
        task.New(self, function()
            task.Wait(120)
            local w = { 22, 23, 18, 10, 9, 5, 20, 14, 6, 12, 5, 8, 6, 17, 10, 13, 8, 9, 6, 12, 11, 10, 9, 7, 11, 12, 8, 9, 6, 31 }
            local r = { 3, -3, 7, -7, 11, -11, 17, -17, 23, -23, 29, -29, 31, -31, 2, -2, 4, -4, 6, -6, 8, -8, 10, -10, 12, 12, 14, -14, 16, -16 }
            local t = { 1, 1, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 }
            local rot
            for T = 1, 30 do
                rot = Angle(self, player)
                for i = 1, w[T] do
                    for a in sp.math.AngleIterator(rot, 3) do
                        NewSimpleBullet(gun_bullet, ((T <= 14) and 2) or 4, self.x + cos(a) * 30, self.y + sin(a) * 30,
                                3 + sin(i * 2) * 2, a, false, 0, false)
                        PlaySound("tan00", 0.1, self.x / 256, true)
                    end
                    task.Wait(2)
                    rot = rot + r[T]
                end
                task.Wait(t[T])
            end
        end)
        task.New(self, function()
            task.Wait(60)
            while true do
                task.MoveToPlayer(60, -96, 96, 112, 144,
                        32, 64, 16, 32, 2, WANDER_MODE.RANDOM)
                task.Wait(60)
            end
        end)
        task.New(self, function()
            task.Wait(729 + 120)
            object.BulletDo(function(unit)
                object.Kill(unit)
            end)
            task.Wait(21)
            local w = { 15, 15, 16, 7, 5, 3, 19, 3, 5, 7, 3, 5, 4, 15 }
            local t = { 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 2, 0, 0, 0 }
            local rot, _d_rot
            for T = 1, 14 do
                local c = Angle(self, player)
                NewSimpleBullet(ball_big, 2, self.x, self.y, 4, c)
                PlaySound("kira00")
                task.Wait(t[T] + w[T] * 3)
            end
            w = { 23, 8, 8, 7, 33 }
            for T = 1, 5 do
                for _ = 1, w[T] do
                    task.Wait(2)
                end
            end
            task.Wait(7)
            for _ = 1, 21 do
                task.Wait()
            end
            rot, _d_rot = -90, 55
            for _ = 1, 23 do
                for a in sp.math.AngleIterator(rot, 10) do
                    NewSimpleBullet(gun_bullet, 2, self.x, self.y, 2, a, false, 0, false)
                end
                PlaySound("tan00", 0.1, self.x / 256, true)
                task.Wait(2)
                rot = rot + _d_rot
            end
            rot, _d_rot = -90, -37
            for _ = 1, 24 do
                for a in sp.math.AngleIterator(rot, 10) do
                    NewSimpleBullet(gun_bullet, 2, self.x, self.y, 2, a, false, 0, false)
                end
                PlaySound("tan00", 0.1, self.x / 256, true)
                task.Wait(2)
                rot = rot + _d_rot
            end
            task.Wait()
            rot, _d_rot = -90, 49
            for _ = 1, 47 do
                for a in sp.math.AngleIterator(rot, 10) do
                    NewSimpleBullet(gun_bullet, 2, self.x, self.y, 2, a, false, 0, false)
                end
                PlaySound("tan00", 0.1, self.x / 256, true)
                task.Wait(2)
                rot = rot + _d_rot
            end
            task.Wait()
        end)
        task.New(self, function()
            task.Wait(1503 + 120)
            object.Kill(self)
        end)
    end
    function non_sc4:del()
        Newcharge_out(self.x, self.y, 255, 255, 100)
        _object.set_color(self, "", 255, 255, 255, 255)
    end

    local name = "狂符「赤眼逃脱」"
    local sc1 = boss.card.New(name, 1, 1, 60, 700)
    local sc2 = boss.card.New(name, 1, 1, 60, 700)
    boss.card.add({ { sc1, "5a" }, { sc2, "5b" } }, 3, name, 22)
    function sc1:before()
        lstg.var.eye = false
        task.MoveTo(-100, 120, 60, 2)
    end
    function sc1:init()
        boss.show_aura(self, true)
        self.colli = true
        local wait, _d_c = 0, 45
        local v = 1.2
        task.New(self, function()
            boss.violent(self)
            _boss = self
            self.violent = true
            _d_c = 13
            v = 2.3
            wait = -30
            self.eye = true

        end)
        task.New(self, function()
            local c = 0
            local A, x, y, a, vx, vy
            while true do
                A = Angle(self, player) + c
                for Y = -1, 1, 2 do
                    x = -v
                    a = A + 90 * Y - 45 * -Y
                    for _ = 1, 14 do
                        vx, vy = x * cos(A) - Y * v * sin(A), x * sin(A) + Y * v * cos(A)
                        New(class["bullet3-1"], self.x, self.y, vx, vy, arrow_small, 2, a, 0.5)
                        x = x + v * 2 / 13
                        a = a + 90 / 13 * -Y
                    end
                end
                for X = -1, 1, 2 do
                    y = v
                    a = A + 90 - 90 * X + 45 * X
                    for _ = 1, 14 do
                        vx, vy = X * v * cos(A) - y * sin(A), X * v * sin(A) + y * cos(A)
                        New(class["bullet3-1"], self.x, self.y, vx, vy, arrow_small, 2, a, 0.5)
                        y = y - v * 2 / 13
                        a = a - 90 / 13 * X
                    end
                end
                task.Wait(55 + wait)
                c = c + _d_c
            end
        end)
        task.New(self, function()
            task.Wait(60)
            do
                while true do
                    task.MoveToPlayer(70, -150, 0, 112, 144,
                            20, 40, 16, 32, 2, 1)
                    task.Wait(160)
                end
            end
        end)
    end

    function sc2:before()
        lstg.var.eye = false
        task.MoveTo(100, 120, 60, 2)
    end
    function sc2:init()
        local wait = 0
        task.New(self, function()
            boss.violent(self)
            wait = -80
            task.Wait(60)
            local rot = 0
            while true do
                for a = 1, 4 do
                    New(class["bullet3-2"], self.x, self.y, a * 90 + rot, 2, 180 - a * 90 - rot)
                end
                rot = rot + 13
                task.Wait(5)
            end
        end)
        boss.show_aura(self, true)
        self.colli = true
        self.q = true
        task.New(self, function()
            task.Wait(150)
            do
                while true do
                    object.Connect(self, New(class["RedScreen"], 0, 0), 0, true)
                    do
                        local x1, _d_x1 = (-140), (50 / 39)
                        local x2, _d_x2 = (140), (-50 / 39)
                        local a, _d_a = (1.6), (-0.6 / 39)
                        local t, _d_t = (11), (1)
                        for _ = 1, 40 do
                            object.Connect(self, New(class["RedEye"], x1, 50, t, a, "L"), 0, true)
                            object.Connect(self, New(class["RedEye"], x2, 50, t, a, "R"), 0, true)
                            task.Wait()
                            x1 = x1 + _d_x1
                            x2 = x2 + _d_x2
                            a = a + _d_a
                            t = t + _d_t
                        end
                    end
                    task.Wait(250 + wait)
                end
            end
        end)
        task.New(self, function()
            task.Wait(75)
            do
                local ae, _d_ae = (-90), (30)
                while true do
                    do
                        local rot, _d_rot = (ran:Float(0, 360)), (360 / 25 / 2)
                        for _ = 1, 4 do
                            do
                                local a, _d_a = (rot), (360 / 25)
                                for _ = 1, 25 do
                                    New(class["bullet3-2"], self.x, self.y, a, 1, ae)
                                    New(class["bullet3-2"], self.x, self.y, a, 1, ae + 180)
                                    a = a + _d_a
                                end
                            end
                            task.Wait(10)
                            rot = rot + _d_rot
                        end
                    end
                    task.MoveToPlayer(60, 0, 150, 112, 144,
                            32, 64, 16, 32, 2, 1)
                    task.Wait(190 + wait)
                    ae = ae + _d_ae
                end
            end
        end)
    end
end--boss5
do
    boss.Define("6a", "八意永琳", "TH08_5", TH08_bg, { -400, 100 }, class["SCBG5"], "Yagokoro", 3)
    boss.Define("6b", "蓬莱山辉夜", "TH08_5", TH08_bg, { 400, 100 }, class["SCBG5"], "Neet", 3)
    local name = "新难题「收取日食之法」"
    local sc1 = boss.card.New(name, 1, 1, 60, 850)
    local sc2 = boss.card.New(name, 1, 1, 60, 850)
    boss.card.add({ { sc1, "6a" }, { sc2, "6b" } }, 3, name, 23)
    function sc1:before()
        task.MoveTo(-50, 120, 60, 2)
    end
    function sc1:init()
        local w = 11
        task.New(self, function()
            boss.violent(self)
            w = 16
        end)
        task.New(self, function()
            local d = 1
            do
                while true do
                    boss.cast(self, 10)
                    task.Wait(24)
                    do
                        local a, _d_a = (90 + 40 * d), (80 / w * -d)
                        for _ = 1, w do
                            New(class["bullet4-1"], self.x - 18 * d, self.y + 27, 4, a, -90)
                            a = a + _d_a
                        end
                    end
                    task.Wait(60)
                    task.New(self, function()
                        task.Wait(30)
                        if self.dx > 0 then
                            d = 1
                        else
                            d = -1
                        end
                    end)
                    task.MoveToPlayer(60, -96, 0, 112, 144,
                            20, 40, 16, 32, 2, 1)
                    task.Wait()
                end
            end
        end)
    end

    function sc2:before()
        task.MoveTo(50, 120, 60, 2)
    end
    function sc2:init()
        local wait = 0
        local way = 28
        local i = 210
        task.New(self, function()
            boss.violent(self)
            wait = -70
            way = 42
            i = 0
            task.Wait(60)
            local rot = 0
            for t = 1, _infinite do
                for a = 1, 5 do
                    NewSimpleBullet(ball_mid, t * 2 % 14,
                            self.x + cos(rot + a * 72) * 20,
                            self.y + sin(rot + a * 72) * 20,
                            2, rot + a * 72)
                end
                PlaySound("tan00")
                task.Wait(4)
                rot = rot + 30
            end
        end)
        task.New(self, function()
            local d = 1
            do
                while true do
                    Newcharge_in(self.x, self.y, 255, 255, 100)
                    for j = 1, way do
                        New(class["laser4-1"], self.x + cos(j * 360 / way) * 40, self.y + sin(j * 360 / way) * 40, j * 360 / way, d)
                    end
                    task.Wait(120)
                    d = -d
                    task.MoveToPlayer(60, 0, 96, 112, 144,
                            32, 64, 16, 32, 2, 1)
                    i = i - 20
                    task.Wait(max(70, i) + wait)
                end
            end
        end)
    end
end--boss6
do
    boss.Define("7a", "上白泽慧音", "TH08_5", TH08_bg, { 300, -70 }, class["SCBG6"], "Kamishirasawa2", 3)
    boss.Define("7b", "藤原妹红", "TH08_5", TH08_bg, { -300, -70 }, class["SCBG6"], "Mokou", 3)
    local name = "亡史「老死之时」"
    local sc1 = boss.card.New(name, 1, 1, 60, 700)
    local sc2 = boss.card.New(name, 1, 1, 60, 700)
    boss.card.add({ { sc1, "7a" }, { sc2, "7b" } }, 3, name, 24)
    function sc1:before()
        self.bright = {}
        task.MoveTo(0, 0, 60, 2)
    end
    function sc1:frame()
        local b
        for i = #self.bright, 1, -1 do
            b = self.bright[i]
            b.x = b.x + b.v * cos(b.a)
            b.y = b.y + b.v * sin(b.a)
            if Dist(b.x, b.y, 0, 0) > 300 then
                table.remove(self.bright, i)
            end
        end
    end
    function sc1:render()
        local col = { 250, 128, 114 }
        if GetGlobal("player_name") == "marisa_player" then
            col = { 135, 206, 235 }
        end
        for _, b in ipairs(self.bright) do
            SetImageState("bright", "mul+add", 255, unpack(col))
            Render("bright", b.x, b.y, 0, 22 / 150)
        end
        SetImageState("circle_charge", "mul+add", 255 * min(1, self.ani / 90), unpack(col))
        Render('circle_charge', player.x, player.y, 0, 50 / 256)
    end
    function sc1:init()
        local way = 4
        local v = 1.5
        task.New(self, function()
            boss.violent(self)
            way = 6
            self.bright = {}
            v = 2
            task.Wait(60)
            while true do
                for i = 1, 30 do
                    New(class["bullet5-1"], self.x, self.y, 1, i * 12 + Angle(self, player), ({ 2, 6 })[ran:Int(1, 2)], self)
                end
                PlaySound("tan00")
                for i = 1, 60 do
                    table.insert(self.bright, { x = self.x, y = self.y, v = 1, a = i * 6 })
                end
                task.Wait(83)
            end
        end)
        task.New(self, function()
            task.Wait()
            boss.cast(self, 120 * 60)
            task.Wait(24)
            local colt = { 2, 6 }
            local colc = ran:Int(1, 2)
            local rot = 45
            local s = 0
            local a
            while true do
                a = rot
                for _ = 1, way do
                    New(class["bullet5-1"], self.x + cos(a) * 275, self.y + sin(a) * 275, v, a + 180 + sin(s) * 10, colt[colc], self)
                    table.insert(self.bright, { x = self.x + cos(a) * 275, y = self.y + sin(a) * 275, v = v, a = a + 180 + sin(s) * 10 })
                    a = a + 360 / way
                end
                colc = ran:Int(1, 2)
                task.Wait(6)
                rot = rot - 0.8
                s = s + 2
            end
        end)
    end

    function sc2:before()
        task.MoveTo(0, 144, 60, 2)
    end
    function sc2:init()
        local para = { t1 = 3, w1 = 30, f = 1 }
        task.New(self, function()
            boss.violent(self)
            para = { t1 = 3, w1 = 45, f = 3 }
        end)
        task.New(self, function()
            local d = 1
            local r, a, angle, x, y
            do
                while true do
                    boss.cast(self, 100)
                    task.Wait(24)
                    do
                        local _a, _d_a = (ran:Float(0, 360)), (360 / para.w1)
                        for _ = 1, para.w1 do
                            do
                                local v, _d_v = (2), (3 / para.t1)
                                local A, _d_A = (45), (135 / para.t1)
                                for _ = 1, para.t1 do
                                    Create.bullet_dec_setangle(self.x - 9 * d, self.y + 24, square, 4,
                                            { v = v, a = _a, time = 60, wait = 30 },
                                            { v = v / 2, a = _a + A * d, time = 30, wait = 0 })
                                    v = v + _d_v
                                    A = A + _d_A
                                end
                            end
                            _a = _a + _d_a
                        end
                    end
                    r = 0
                    angle = Angle(self, player)
                    x, y = self.x, self.y
                    for i = 1, 120 do
                        for _ = 1, para.f do
                            a = angle
                            Create.bullet_changeangle(x + cos(a) * i, y + sin(a) * i,
                                    ball_mid, ({ 1, 2 })[i % 2 + 1], ({ 1, 2 })[i % 2 + 1], angle, { wait = 0, time = 120, r = r })
                            a = angle
                            Create.bullet_changeangle(x + cos(a) * i, y + sin(a) * i,
                                    ball_mid, ({ 1, 2 })[i % 2 + 1], ({ 1, 2 })[i % 2 + 1], angle, { wait = 0, time = 120, r = -r })
                            r = r + 0.1
                        end
                        PlaySound("tan00", 0.1, self.x / 256, true)
                        task.Wait()
                    end
                    task.New(self, function()
                        task.Wait(30)
                        if self.dx > 0 then
                            d = 1
                        else
                            d = -1
                        end
                    end)
                    task.MoveToPlayer(60, -170, 170, -20, 144,
                            32, 64, 16, 32, 2, WANDER_MODE.RANDOM)
                    task.Wait(95)
                end
            end
        end)
    end
end--boss7