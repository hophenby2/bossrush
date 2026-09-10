local class = {}
_editor_class["TH07"] = class

local cos, sin, min, max, int, tan, sign = cos, sin, min, max, int, tan, sign
local bullet, object, laser, boss = bullet, object, laser, boss
local task, ran, Create, sp = task, ran, Create, sp
local table = table
local GROUP, LAYER, COLOR = GROUP, LAYER, COLOR
local New = New
local NewSimpleBullet = NewSimpleBullet
local PlaySound = PlaySound
local IsValid = IsValid
local SetImageState = SetImageState
local Dist, Angle = Dist, Angle
local Render = Render
local Class = Class
local Newcharge_in, Newcharge_out = Newcharge_in, Newcharge_out

do

    class["SCBG1"] = Class(_SC_BG)
    class["SCBG1"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th06_0", true, 0, 0, 0, 0, 0.01, 0, "", 1, 1)
    end
    class["SCBG2"] = Class(_SC_BG)
    class["SCBG2"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_0", true, 0, 0, 0, 0, -0.8, 0, "mul+add", 1, 1)
        _SC_BG.AddLayer(self, "th06_0", true, 0, 0, 0, -0.1, 0.2, 0, "", 1, 1)
    end
    class["SCBG3"] = Class(_SC_BG)
    class["SCBG3"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_1", true, 0, 0, 0, 0, 0.6, 0, "mul+add", 1, 1)
        _SC_BG.AddLayer(self, "th07_1", true, -128, 0, 0, 0, -0.6, 0, "", 1, 1)
    end
    class["SCBG4"] = Class(_SC_BG)
    class["SCBG4"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_3", false, 0, 0, 0, 0, 0, 0, "", 1.5, 1.5)
        _SC_BG.AddLayer(self, "th07_2", false, 0, 0, 0, 0, 0, 0.3, "", 2.3, 2.3)
    end
    class["youmu_slash"] = {
        init = function(self)
            self.task = {}
            self.a = 120
            setmetatable(self, {
                __index = function(mytable, key)
                    if key == "slash_time" then
                        if mytable.a == 255 then
                            return true
                        else
                            return false
                        end
                    end
                end,
                __newindex = function(mytable, key, value)
                    if key == "slash_time" then
                        task.New(mytable, function()
                            local unit = task.GetSelf()
                            PlaySound("kira00")
                            unit.a = 255
                            for i = 1, value do
                                unit.omiga = -sin(90 - i / value * 90) * (1 / value * 160)
                                task.Wait()
                            end
                            unit.a = 120
                            unit.omiga = 0.3
                        end)
                    else
                        rawset(mytable, key, value)
                    end
                end
            })
        end,
        frame = task.Do,
        render = function(self)
            if self.slash_time then
                SetImageState("white", "mul+rev", 250, 100, 100, 100)
                RenderRect('white', lstg.world.l, lstg.world.r, lstg.world.t, lstg.world.b)
            end
        end
    }
    class["SCBG5"] = Class(_SC_BG)
    class["SCBG5"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_4", false, 0, 0, 0, 0, 0, 0.3, "", 2.3, 2.3,
                class["youmu_slash"].init,
                class["youmu_slash"].frame, nil,
                class["youmu_slash"].render)
        _SC_BG.AddLayer(self, "th07_5", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
        _SC_BG.AddLayer(self, "th07_6", true, -128, 0, 0, 0, 1, 0, "", 1, 1)
    end
    class["SCBG6"] = Class(_SC_BG)
    class["SCBG6"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_0", true, 0, 0, 0, 0, -0.8, 0, "mul+add", 1, 1)
        _SC_BG.AddLayer(self, "th07_5", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
        _SC_BG.AddLayer(self, "th07_6", true, -128, 0, 0, 0, 1, 0, "", 1, 1)
    end
    class["SCBG7"] = Class(_SC_BG)
    class["SCBG7"].init = function(self)
        _SC_BG.init(self)
        local b = _SC_BG.AddLayer(self, "th07_8", false, 0, 0, 0, 0, 0, 0.2, "mul+add", 2.3, 2.3)
        b.Beforeframe = function(unit)
            unit.a = 150 + 100 * sin(unit.timer / 2)
        end
        _SC_BG.AddLayer(self, "th07_9", false, 0, 0, 0, 0, 0, -0.1, "", 2, 2)
        _SC_BG.AddLayer(self, "th07_7", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
    end
    class["SCBG8"] = Class(_SC_BG)
    class["SCBG8"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_9", false, 0, 0, 0, 0, 0, -0.1, "", 2, 2)
        _SC_BG.AddLayer(self, "th07_7", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
    end
    class["SCBG9"] = Class(_SC_BG)
    class["SCBG9"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_9", false, 0, 0, 0, 0, 0, -0.1, "mul+rev", 2.8, 2.8)
        _SC_BG.AddLayer(self, "th07_6", true, -128, 0, 0, 0, 1, 0, "mul+add", 1, 1, function(unit)
            unit.a = 100
        end)
        _SC_BG.AddLayer(self, "th07_7_n", false, 0, 0, 0, 0, 0, 0, "", 0.5, 0.5, function(unit)
            unit.r, unit.g, unit.b = 150, 150, 150
        end)
    end
end--_SC_BG
do
    boss.Define("1a", "琪露诺", "TH07_0", TH07_bg, { 0, 500 }, class["SCBG1"], "Chiruno", 2)
    boss.Define("1b", "大妖精", "TH07_0", TH07_bg, { 0, 500 }, class["SCBG1"], "Daiyousei", 2)
    local name = "「最讨厌给琪露诺酱起外号了」"
    local sc1 = boss.card.New(name, 1, 1, 60, 600)
    local sc2 = boss.card.New(name, 1, 1, 60, 150)
    boss.card.add({ { sc1, "1a" }, { sc2, "1b" } }, 2, name, 5)
    function sc1:before()
        task.MoveTo(0, 100, 60, 2)
    end
    function sc1:init()
        local _wait1, _wait2 = 60, 400
        task.New(self, function()
            boss.violent(self)
            _wait1 = 30
            _wait2 = 300
            local rot = 0
            while true do
                for _, x, y in sp.math.Ellipse2Iterator(Angle(self, player), 20, 0, 0, 3, 2, rot) do
                    NewSimpleBullet(ball_mid, 5, self.x, self.y, sp.math.RectangularToPolar(x, y))
                end
                rot = rot + 18
                task.Wait(20)
            end
        end)
        task.New(self, function()
            while true do
                New(class["bullet0-1"], self.x, self.y, 1.8, Angle(self, player), 3, 3)
                task.MoveToPlayer(60, -96, 96, 112, 144,
                        20, 40, 16, 32, 2, WANDER_MODE.RANDOM)
                task.Wait(_wait1)
            end
        end)
        task.New(self, function()
            local d = 0
            while true do
                New(class["obj0-1"], 0, 0, self)
                New(class["obj0-2"], 60, 45, d, self)
                task.Wait(200)
                Newcharge_out(self.x, self.y, 255, 255, 100)
                do
                    self.jiu = true
                    task.Wait()
                    self.jiu = false
                end
                d = d + 180
                task.Wait(120)
            end
        end)

    end
    function sc2:before()
        task.MoveTo(-192, 80, 60, 2)
    end
    function sc2:init()
        local T, rt, wait = 3, 11, 30
        task.New(self, function()
            boss.violent(self)
            T, wait, rt = 12, 0, 0.3
            local rot = 0
            while true do
                for _, x, y in sp.math.Ellipse2Iterator(Angle(self, player), 20, 0, 0, 3, 2, rot) do
                    NewSimpleBullet(ball_mid, 5, self.x, self.y, sp.math.RectangularToPolar(x, y))
                end
                rot = rot + 18
                task.Wait(20)
            end
        end)
        task.New(self, function()
            Newcharge_in(self.x, self.y, 255, 255, 100)
            task.Wait(120)
            local d = 1
            while true do
                local A = ran:Float(0, 360)
                for i = 1, 30 do
                    local l = 75 * (30 - i) / 30
                    for a in sp.math.AngleIterator(A, T) do
                        NewSimpleBullet(arrow_big, COLOR.GRAY, self.x + cos(a) * l, self.y + sin(a) * l,
                                1 + i / 30 * 2, a + 180 + rt * d * i, false, 0, true, true)
                    end
                    PlaySound("tan00", 0.1, self.x / 256, false)
                    task.Wait()
                end
                task.MoveTo(-self.x, ran:Float(80, -30), 60, 2)
                d = -d
                task.Wait(wait)
            end
        end)

    end
end--boss1
do
    boss.Define("2a", "蕾蒂·霍瓦特洛克", "TH07_0", TH07_bg, { -500, 500 }, class["SCBG2"], "Whiterock", 2)
    boss.Define("2b", "橙", "TH07_0", TH07_bg, { 500, 500 }, class["SCBG2"], "Chen", 2)
    local name = "冻符「冰封多年的妖猫」"
    local sc1 = boss.card.New(name, 1, 1, 60, 710)
    local sc2 = boss.card.New(name, 1, 1, 60, 150)
    boss.card.add({ { sc1, "2a" }, { sc2, "2b" } }, 2, name, 6)
    function sc1:before()
        self.bright = {}
        task.MoveTo(0, 144, 60, 2)
    end
    function sc1:init()

        local collier = true
        task.New(self, function()
            boss.violent(self)
            collier = false
        end)
        task.New(self, function()
            local T = { 1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3, 2, 1 }
            local d = 1
            while true do
                task.Wait()
                boss.cast(self, 180)
                Newcharge_out(self.x, self.y, 255, 255, 100)
                local v, t, a = 5
                local tt = ran:Int(1, 13)
                local l = 145
                local c = ran:Float(0, 360)
                local A
                for _ = 1, 36 do
                    t = T[tt % 13 + 1]
                    a = (11 * (t - 1))
                    A = a + c + Angle(self, player)
                    for _ = 1, t do
                        New(class["laser0-1"], self.x + cos(A) * l, self.y + sin(A) * l, A, v, 6)
                        for _ = 1, 9 do
                            table.insert(self.bright, { x = self.x + cos(A) * l,
                                                        y = self.y + sin(A) * l, alpha = 150, a = ran:Float(0, 360), v = ran:Float(4, 7) })
                        end
                        if not collier then
                            --New(class["laser0-1"], self.x + cos(A) * l / 2, self.y + sin(A) * l / 2, A + f, v, 2)
                            NewSimpleBullet(ball_mid, 4, self.x + cos(A) * l, self.y + sin(A) * l, 4, A)
                        end
                        A = A + (-22 * (t - 1) / (t - 1))
                    end
                    task.Wait(5)
                    tt = tt + 1
                    l = l - 6
                    c = c + 18 * d
                    --f=f+15
                    v = v - 3 / 35
                end
                task.Wait(60)
                task.MoveToPlayer(60, -120, 120, 100, 144,
                        20, 40, 8, 16, 2, 1)
                task.Wait(60)
                d = -d
            end

        end)

    end
    function sc1:frame()
        for _, b in ipairs(self.bright) do
            b.alpha = max(0, b.alpha - 7)
            b.x = b.x + cos(b.a) * b.v
            b.y = b.y + sin(b.a) * b.v
        end
        for i = #self.bright, 1, -1 do
            if self.bright[i].alpha == 0 then
                table.remove(self.bright, i)
            end
        end
    end
    function sc1:render()
        for _, b in ipairs(self.bright) do
            SetImageState('bright', "mul+add", b.alpha, 135, 206, 235)
            Render('bright', b.x, b.y, 0, 0.05)
        end
    end

    function sc2:before()
        task.MoveTo(0, 80, 60, 2)
    end
    function sc2:init()
        local c = 4
        task.New(self, function()
            boss.violent(self)
            c = 6
        end)
        task.New(self, function()
            boss.cast(self, 120 * 60)
            task.Wait(16)
            local v, a1, l, rot
            while true do
                v = 1
                a1 = ran:Float(0, 360)
                l = 150
                for _ = 1, 60 do
                    for a in sp.math.AngleIterator(a1, c) do
                        Create.bullet_decel(self.x + cos(a) * l, self.y + sin(a) * l, arrow_big, 6, 6, v, a + 160)
                    end
                    PlaySound("tan00", 0.1, self.x / 100, true)
                    task.Wait(2)
                    v = v + 1 / 59
                    a1 = a1 + 11
                    l = l - 150 / 59
                end
                rot = ran:Float(0, 360)
                for _ = 1, 6 do
                    for a in sp.math.AngleIterator(rot, 7) do
                        for i = 0, 4 do
                            NewSimpleBullet(ball_mid_c, 6, self.x, self.y, 1 + i * 0.2, a - 3 * i)
                            if c == 6 then
                                NewSimpleBullet(ball_mid_c, 6, self.x, self.y, 1 + i * 0.2, 180 - (a - 3 * i))
                            end
                        end
                    end
                    PlaySound("tan00", 0.1, self.x, true)
                    task.Wait(20)
                    rot = rot + 17
                end
                v = 1
                a1 = ran:Float(0, 360)
                l = 150
                for _ = 1, 60 do
                    local a = a1
                    for _ = 1, c do
                        Create.bullet_decel(self.x + cos(a) * l, self.y + sin(a) * l, arrow_big, 2, 6, v, a - 160)
                        a = a + 360 / c
                    end
                    PlaySound("tan00", 0.1, self.x / 100, true)
                    task.Wait(2)
                    v = v + 1 / 59
                    a1 = a1 - 11
                    l = l - 150 / 59
                end
                rot = ran:Float(0, 360)
                for _ = 1, 6 do
                    for a in sp.math.AngleIterator(rot, 7) do
                        for i = 0, 4 do
                            NewSimpleBullet(ball_mid_c, 2, self.x, self.y, 1 + i * 0.2, a + 3 * i)

                            if c == 6 then
                                NewSimpleBullet(ball_mid_c, 2, self.x, self.y, 1 + i * 0.2, 180 - (a + 3 * i))
                            end
                        end
                    end
                    PlaySound("tan00", 0.1, self.x, true)
                    task.Wait(20)
                    rot = rot - 17
                end
            end
        end)
        task.New(self, function()
            while true do
                task.MoveTo(320, ran:Float(40, 120), 120, VALUE_SET.ACCEL)
                task.MoveTo(-320, ran:Float(40, 120), 120, VALUE_SET.ACCEL)
                task.Wait()
            end
        end)
    end

end--boss2
do


    boss.Define("3a", "爱丽丝·玛格特洛依德", "TH07_0", TH07_bg, { -400, 0 }, class["SCBG3"], "Alice", 2)
    boss.Define("3b", "莉莉白", "TH07_0", TH07_bg, { 0, 500 }, class["SCBG3"], "Whitelily", 2)
    local name = "春符「天使界的春人偶」"
    local sc1 = boss.card.New(name, 1, 1, 80, 600)
    local sc2 = boss.card.New(name, 1, 1, 80, 690)
    boss.card.add({ { sc1, "3a" }, { sc2, "3b" } }, 2, name, 7)
    function sc1:before()
        task.MoveTo(-120, 120, 60, 2)
    end
    function sc1:init()
        self.enemykill = 0
        task.New(self, function()
            while self.enemykill < 12 do
                task.Wait()
            end
            ext.achievement:get(4)
        end)
        task.New(self, function()
            boss.violent(self)
            local r, d, a, b = nil, 1, nil, nil
            while true do
                r = 90 + 45 * d
                for _ = 1, 16 do
                    a = r - 13
                    for _ = 1, 3 do
                        b = NewSimpleBullet(ball_mid, 2, self.x + cos(a) * 30, self.y + sin(a) * 30, 2, a,
                                false, 0, false, true)
                        b.timer = 11
                        task.New(b, function()
                            local self_ = task.GetSelf()
                            for i = 0, 10 do
                                self_.hscale = sin(i * 9)
                                self_.vscale = sin(i * 9)
                                self_.a = sin(i * 9) * 4
                                self_.b = sin(i * 9) * 4
                                task.Wait()
                            end
                            self_._495 = true
                        end)
                        PlaySound("tan00")
                        a = a + 13
                    end
                    task.Wait(2)
                    r = r - 180 / 15 * d
                end
                task.Wait(80)
                d = -d
            end
        end)
        task.New(self, function()
            object.Connect(self, New(class["enemy0-1"], self.x, self.y, ran:Float(0, 360), 3, self),
                    0, true)
            task.Wait(200)
            task.MoveTo(120, 120, 90, 2)
            object.Connect(self, New(class["enemy0-1"], self.x, self.y, ran:Float(0, 360), -3, self),
                    0, true)
            task.Wait(200)
            task.MoveTo(0, 0, 60, 2)
            Newcharge_in(self.x, self.y, 255, 255, 100)
            task.Wait(60)
            Newcharge_out(self.x, self.y, 255, 255, 100)
            self.shoot = true
            while true do
                task.MoveToPlayer(80, -96, 96, -50, 50,
                        20, 40, 16, 20, 2, 1)
                task.Wait(160)
            end
        end)

    end

    function sc2:before()
        task.MoveTo(0, 255, 60, 2)
    end
    function sc2:init()
        local h
        task.New(self, function()
            local a = ran:Float(0, 360)
            for _ = 1, 40 do
                h = New(class["bullet0-6"], self.x, self.y, 2, a, 1, 0, 0.8, 0, 150, 30, 2.25)
                h.group = GROUP.ENEMY
                object.Connect(self, h, 0, true)

                a = a + 9
            end
            a = ran:Float(0, 360)
            for _ = 1, 40 do
                h = New(class["bullet0-6"], self.x, self.y, 6, a, -1, 90, -0.8, 0, 150, 30, 2.25)
                h.group = GROUP.ENEMY
                object.Connect(self, h, 0, true)
                a = a + 9
            end

        end)
        task.New(self, function()
            boss.violent(self)
            task.Wait(60)
            local a = ran:Float(0, 360)
            for _ = 1, 30 do
                h = New(class["bullet0-6"], self.x, self.y, 4, a, -1, 0, 0, 0, 170, 170, 3.2)
                h.group = GROUP.ENEMY
                object.Connect(self, h, 0, true)

                a = a + 12
            end
        end)
        task.New(self, function()
            task.Wait(180)
            while true do
                task.MoveToPlayer(80, -150, 150, 80, 120, 30, 60, 16, 32, 2, WANDER_MODE.RANDOM)
                task.Wait(120)
            end
        end)
        task.New(self, function()
            task.MoveTo(0, 100, 60, 2)
        end)

    end
end--boss3
do
    boss.Define("4a", "露娜萨·普莉兹姆利巴", "TH07_0", TH07_bg, { 0, 480 }, class["SCBG4"], "Lunasa", 2)
    boss.Define("4b", "梅露兰·普莉兹姆利巴", "TH07_0", TH07_bg, { -560, 400 }, class["SCBG4"], "Merlin", 2)
    boss.Define("4c", "莉莉卡·普莉兹姆利巴", "TH07_0", TH07_bg, { 560, 400 }, class["SCBG4"], "Lyrica", 2)
    local name = "合奏「自建五线谱」"
    local sc1 = boss.card.New(name, 1, 2, 90, 850)
    local sc2 = boss.card.New(name, 1, 1, 90, 400)
    local sc3 = boss.card.New(name, 1, 1, 90, 400)
    boss.card.add({ { sc1, "4a" }, { sc2, "4b" }, { sc3, "4c" } }, 2, name, 8)
    function sc1:before()
        task.MoveTo(0, 120, 60, 2)
    end
    function sc1:init()
        local para = { w1 = 8, v2 = 2.5 }
        local arr = false
        local wait = 340
        task.New(self, function()
            boss.violent(self)
            para = { w1 = 6, v2 = 3 }
            arr = true
            boss.violent(self)
            para = { w1 = 4, v2 = 3.5 }
            wait = 200
        end)
        task.New(self, function()
            boss.cast(self, 120 * 60)
            task.Wait(16)
            local rot, _d_rot = (-90), (360 / 8 / 2 + 10)
            while true do
                local a, _d_a = (rot), (360 / 7)
                for _ = 1, 7 do
                    for d = -1, 1 do
                        NewSimpleBullet(grain_a, 13, self.x + cos(a) * 20, self.y + sin(a) * 20, para.v2, a + d * 2)
                        PlaySound("tan00", 0.1, self.x / 256, false)
                    end
                    a = a + _d_a
                end
                task.Wait(para.w1)
                rot = rot + _d_rot
            end
        end)
        task.New(self, function()
            task.Wait(180)
            Newcharge_in(self.x, self.y, 255, 255, 100)
            task.Wait(60)
            while true do
                task.MoveToPlayer(60, -120, 120, 112, 144,
                        20, 40, 8, 16, 2, 1)
                for i = -2, 2 do
                    New(class["laser0-3"], -200, 25 * i, 2, 0, i * 20)
                end
                task.Wait(340)
                task.MoveToPlayer(60, -120, 120, 112, 144,
                        20, 40, 8, 16, 2, 1)
                for i = -2, 2 do
                    New(class["laser0-3"], 200, 25 * i, 2, 180, -i * 20)
                end
                task.Wait(wait)
            end
        end)

    end
    function sc1:frame()
        -- CollisionCheck(GROUP.GHOST, GROUP.ENEMY_BULLET)
        CollisionCheck(GROUP.ENEMY_BULLET, GROUP.GHOST)
    end
    function sc1:render()
        Render("ins1", sp.math.EllipsePoint(self.x, self.y, 50, 15, 45, stage.current_stage.timer * 3))
    end

    function sc2:before()
        task.MoveTo(-170, 140, 60, 2)
    end
    function sc2:init()
        local para = { w = 1 }
        task.New(self, function()
            boss.violent(self)
            para.w = 8
            boss.violent(self)
            para.w = 16
            local b
            task.New(self, function()
                local ang
                while true do
                    for _ = 1, -self.dx do
                        ang = ran:Float(0, 360)
                        b = NewSimpleBullet(music, COLOR.GREEN, self.x + cos(ang) * 30, self.y + sin(ang) * 30, ran:Float(1, 3), ang, 0, false)
                        b.rot = -90
                        b.frame_other = function()
                            if self.timer < 11 then
                                self.colli = false
                            else
                                self.colli = true
                            end
                        end
                    end
                    task.Wait()
                end
            end)
        end)
        task.New(self, function()
            local s = 90
            local a = 180
            while true do
                self.x = cos(a) * 170
                a = a + sin(90 - max(s, 0))
                s = s - 1
                task.Wait()
            end
        end)

        task.New(self, function()
            local ang
            while true do
                for v = 1, 6 do
                    for i = 1, para.w do
                        ang = -90 + i * 360 / para.w
                        New(class["bullet0-7"], self.x + cos(ang) * 30, self.y + sin(ang) * 30, COLOR.GRAY, 1.5 + v / 6 * 0.5, ang)
                    end
                    task.Wait(4)
                end
                task.Wait(15)
            end
        end)
    end
    function sc2:render()
        Render("ins2", sp.math.EllipsePoint(self.x, self.y, 50, 15, 0, stage.current_stage.timer * 2.5))
    end

    function sc3:before()
        task.MoveTo(170, 140, 60, 2)
    end
    function sc3:init()
        local para = { w = 1 }
        task.New(self, function()
            boss.violent(self)
            para.w = 8
            boss.violent(self)
            para.w = 16
            task.New(self, function()
                local ang
                local b
                while true do
                    for _ = 1, self.dx do
                        ang = ran:Float(0, 360)
                        b = NewSimpleBullet(music, COLOR.GREEN, self.x + cos(ang) * 30, self.y + sin(ang) * 30, ran:Float(1, 3), ang, 0, false)
                        b.rot = -90
                        b.frame_other = function()
                            if self.timer < 11 then
                                self.colli = false
                            else
                                self.colli = true
                            end
                        end
                    end
                    task.Wait()
                end
            end)
        end)
        task.New(self, function()
            local s = 90
            local a = 0
            while true do
                self.x = cos(a) * 170
                a = a + sin(90 - max(s, 0))
                s = s - 1
                task.Wait()
            end
        end)

        task.New(self, function()
            local ang
            while true do
                for v = 1, 6 do
                    for i = 1, para.w do
                        ang = -90 + i * 360 / para.w
                        New(class["bullet0-7"], self.x + cos(ang) * 30, self.y + sin(ang) * 30, COLOR.RED, 1.5 + v / 6 * 0.5, ang)
                    end
                    task.Wait(4)
                end
                task.Wait(15)
            end
        end)
    end
    function sc3:render()
        Render("ins3" .. int(stage.current_stage.timer / 4) % 3 + 1,
                sp.math.EllipsePoint(self.x, self.y, 50, 15, -45, stage.current_stage.timer * 2))
    end
end--boss4
do

    boss.Define("5a", "魂魄妖梦", "TH07_1", TH07_bg, { -360, 0 }, class["SCBG5"], "Youmu", 2, 0.6)
    boss.Define("5b", "西行寺幽幽子", "TH07_1", TH07_bg, { 0, 486 }, class["SCBG5"], "Yuyuko", 2)
    local name = "亡灵剑「花诞日」"
    local sc1 = boss.card.New(name, 1, 1, 60, 700)
    local sc2 = boss.card.New(name, 1, 1, 60, 700)
    boss.card.add({ { sc1, "5a" }, { sc2, "5b" } }, 2, name, 9)
    function sc1:before()
        Youmu = self
        task.MoveTo(-70, 40, 60, 2)
    end
    function sc1:frame()
        CollisionCheck(GROUP.ENEMY_BULLET, GROUP.INDES)
    end
    function sc1:init()
        local cao = false
        task.New(self, function()
            boss.violent(self)
            cao = true
        end)
        task.New(self, function()
            task.Wait(24)
            task.MoveToPlayer(50, -100, 100, 70, 120,
                    32, 64, 16, 32, 2, WANDER_MODE.RANDOM)
            task.Wait(40)
            while true do
                task.New(self, function()
                    for _ = 1, 50 do
                        boss.cast(self, 60)
                        task.Wait()
                    end
                end)
                --lstg.var.gray = true
                SmearScreen(self, 5, 50)
                lstg.var.timeslow = 2
                Newcharge_in(self.x, self.y, 255, 255, 100)
                self.bg.layers[1].slash_time = 50
                PlaySound("power02", 1, self.x, false)
                task.Wait(50)
                PlaySound("slash", 1, self.x, false)
                lstg.var.timeslow = 1
                if cao then
                    task.New(self, function()
                        local x, y
                        for i = 1, 60 do
                            for a = 1, 9 do
                                x, y = sp.math.EllipsePoint(self.x, self.y, 80 + i * 2, 80 - i * 2, a * 40 + 90, i * 6)
                                NewSimpleBullet(sakura, 2, x, y, 1 + i % 2, i * 6)
                            end
                            PlaySound("tan00")
                            task.Wait()

                        end
                    end)
                end
                --lstg.var.gray = false
                for _ = 1, 3 do
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 30) do
                        NewSimpleBullet(sakura, 4, self.x, self.y, 3, a)
                        PlaySound("tan00", 0.1, self.x / 200, true)
                    end
                    task.Wait(20)
                end
                task.MoveToPlayer(60, -100, 100, 70, 120,
                        32, 64, 16, 32, 2, WANDER_MODE.RANDOM)
                task.Wait(114)
            end
        end)
    end
    function sc1:del()
        lstg.var.timeslow = 1
        player.gray = false
        lstg.var.gray = false
    end

    function sc2:before()
        task.MoveTo(0, 100, 60, 2)
    end
    function sc2:init()
        task.New(self, function()
            boss.violent(self)
            while true do
                New(class["bullet1-5"])
                task.Wait(ran:Int(2, 5))
            end
        end)
        task.New(self, function()
            while true do
                do
                    local x = player.x
                    boss.cast(self, 600)
                    Newcharge_in(x, -224, 255, 255, 100)
                    task.Wait(120)
                    New(class["bullet1-1"], x, -224, ran:Float(3.5, 4.5), ran:Float(100, 80), ran:Float(3, 5),
                            ran:Int(80, 100), ran:Float(-20, 10), ran:Float(2.5, 2.7), ran:Int(60, 80), 3)
                    New(class["bullet1-1"], x, -224, ran:Float(2, 3), ran:Float(120, 100), ran:Float(0.5, 1.5),
                            ran:Int(120, 140), ran:Float(10, 20), ran:Float(1, 1.3), ran:Int(40, 70), 2)
                    New(class["bullet1-1"], x, -224, ran:Float(2, 3), ran:Float(110, 80), ran:Float(-0.5, -1.5),
                            ran:Int(300, 400), ran:Float(12, 20), ran:Float(1.2, 1.6), ran:Int(120, 130), 2)
                    New(class["bullet1-1"], x, -224, ran:Float(1.5, 2.5), ran:Float(90, 80), ran:Float(-3, -5),
                            ran:Int(90, 110), ran:Float(15, 25), ran:Float(1.8, 2.2), ran:Int(50, 60), 3)
                    New(class["bullet1-1"], x, -224, ran:Float(5, 7), ran:Float(85, 95), ran:Float(-2, -3),
                            ran:Int(350, 450), ran:Float(-25, -40), ran:Float(1, 1.6), ran:Int(275, 325), 1)
                end
                task.New(self, function()
                    task.Wait(90)
                    local y = -320
                    local ball
                    for s = 1, 500 do
                        for x = 0, 14 do
                            for i = 1, 4 do
                                ball = NewSimpleBullet(ball_light, 4, -192 + x * 384 / 14, y + (50 + sin(s + x * 30) * 10) - i * 15,
                                        0, 0, false, 0, false)
                                _object.set_color(ball, "mul+add", 255, 255, 255, 255)
                                ball.frame_other = function(self)
                                    if self.timer > 1 then
                                        object.RawDel(self)
                                    end
                                end
                            end
                        end
                        player.y = max(player.y, y + 80)
                        task.Wait()
                        y = -320 + 76 * sin(s / 500 * 180)
                    end
                end)
                task.Wait(300)
                task.MoveToPlayer(80, -140, 140, 80, 130, 30, 60, 16, 32, 2, 1)
                task.Wait(420)
            end
        end)
    end
end--boss5
do
    boss.Define("6a", "西行寺幽幽子", "TH07_1", TH07_bg, { 0, 480 }, class["SCBG6"], "Yuyuko", 2)
    boss.Define("6b", "橙", "TH07_1", TH07_bg, { -480, 0 }, class["SCBG6"], "Chen", 2)
    local name = "灵神「毘沙门之诞生」"
    local sc1 = boss.card.New(name, 1, 1, 60, 900)
    local sc2 = boss.card.New(name, 1, 1, 60, 300)
    boss.card.add({ { sc1, "6a" }, { sc2, "6b" } }, 2, name, 10)
    function sc1:before()
        self.fan = New(class["fan"], self)
        task.MoveTo(0, 144, 60, 2)
    end
    function sc1:init()
        local para = { t1 = 7, t2 = 10, t3 = 10, t4 = 1 }
        task.New(self, function()
            boss.violent(self)
            para.t1 = 10
            para.t2 = 20
            para.t3 = 50
            para.t4 = 2
            task.Wait(60)
            local v, a, d = 0, 0, 1
            while true do
                a = -90
                for _ = 1, 16 do
                    v = 4
                    for _ = 1, 3 do
                        New(class["bullet1-6"], self.x - 100 * d, self.y, 7, v, a + Angle(self.x - 100 * d, self.y, player.x, player.y), 0, ball_huge)
                        v = v + 0.8
                    end
                    a = a + 180 / 15
                end
                d = -d
                task.Wait(120)
            end
        end)
        task.New(self, function()
            local col = { 6, 4 }
            local d = 1
            local t = 3
            local a, v, rot
            while true do
                rot = ran:Float(0, 360)
                for _ = 1, para.t1 do
                    a = rot
                    for c = 1, 12 do
                        v = 0.5
                        for _ = 1, 4 do
                            New(class["bullet1-6"], self.x + cos(a) * 60, self.y + sin(a) * 30, col[c % 2 + 1], v, a, 0, butterfly)
                            New(class["bullet1-6"], self.x + cos(a) * 30, self.y + sin(a) * 60, col[c % 2 + 1], v, a, 0, butterfly)
                            v = v + 2
                        end
                        a = a + 360 / 12
                    end
                    task.Wait(10)
                    rot = rot + 360 / 16 / 2
                end
                task.Wait(120 - (para.t1 - 7) * 10)
                local A = 0
                for _ = 1, para.t2 do
                    a = 0
                    for _ = 1, 10 do
                        v = 3
                        for _ = 1, 3 do
                            New(class["bullet1-6"], self.x, self.y, 2, v, a, ((50 + A) % 360) * d, butterfly)
                            v = v + 0.5
                        end
                        a = a + 360 / 10
                    end
                    d = -d
                    task.Wait(10)
                    A = A + 300 / para.t2
                end
                task.Wait(60)
                a = Angle(self, player)
                for _ = 1, para.t3 do
                    v = 4
                    for _ = 1, 3 do
                        New(class["bullet1-6"], self.x, self.y, 1, v, a, 0, butterfly)
                        v = v + 0.8
                    end
                    a = a + 360 / para.t3
                end
                a = -90
                for _ = 1, 60 do
                    if SearchStageLevel[1] then
                        item.Dropitem(item.obj.sakura, 1, self.x + cos(a) * 200, self.y + sin(a) * 200)
                    end
                    task.Wait()
                    a = a + 6
                end
                task.Wait(60)
                a = -90
                for _ = 1, t * para.t4 do
                    object.Connect(self, New(class["laser1-1"], self.x, self.y, COLOR.CYAN, a, 90),
                            0, true)
                    object.Connect(self, New(class["laser1-1"], self.x, self.y, COLOR.PURPLE, a, -90),
                            0, true)
                    a = a + 360 / t / para.t4
                end
                task.Wait(30)
                t = t + 3
            end
        end)
    end

    function sc2:before()
        self.smear = {}
        task.MoveTo(0, -50, 60, 2)
    end
    function sc2:init()
        task.New(self, function()
            while true do
                local a = -90
                for i = 1, 180 do
                    self.x = cos(a) * 200
                    self.y = sin(a) * 100 + 50
                    task.Wait()
                    a = -90 + 360 * sin(i / 2)
                end
                task.MoveTo(-320, 150, 90, 1)
                self.x = -self.x
                task.MoveTo(-320, -90, 90, 1)
                self.x, self.y = 130, 320
                task.MoveTo(250, -320, 90, 1)
                self.x, self.y = 300, 0
                task.MoveTo(-150, 320, 90, 1)
                self.x, self.y = -300, 0
                task.MoveTo(0, -50, 90, 1)
            end
        end)
        local inc = 4
        task.New(self, function()
            local A, a, t
            while true do
                A = Angle(self.x, self.y, 0, 0)--math.deg(math.atan2(self.dy,self.dx))
                t = 3
                a = A + 6 * (t - 1)
                for _ = 1, t do
                    Create.bullet_accel(self.x, self.y, arrow_big, 14, 0.3, 2 + t / 7, a, true, false)
                    PlaySound("tan00")
                    a = a - 12 * (t - 1) / (t - 1)
                end
                task.Wait(inc)
            end
        end)
        task.New(self, function()
            boss.violent(self)
            inc = 3
            task.New(self, function()
                local A, a, t
                while true do
                    A = math.deg(math.atan2(self.dy, self.dx)) + 90
                    t = 3
                    a = A + 6 * (t - 1)
                    for _ = 1, t do
                        --Create.bullet_decel(self.x, self.y, butterfly, 10, 4, 3 + t / 7, a)
                        Create.bullet_decel(self.x, self.y, arrow_big, 10, 4, 3 + t / 7, a - 180, true, false)
                        a = a - 12 * (t - 1) / (t - 1)
                    end
                    PlaySound("tan00")
                    task.Wait(5)
                end
            end)

        end)
    end
    function sc2:frame()
        table.insert(self.smear,
                { x = self.x, y = self.y, rot = self.rot,
                  alpha = 150, img = self.img, hscale = self.hscale, vscale = self.vscale })
        local s
        for i = #self.smear, 1, -1 do
            s = self.smear[i]
            s.alpha = max(0, s.alpha - 8)
            if s.alpha == 0 then
                table.remove(self.smear, i)
            end
        end
    end
    function sc2:render()
        for _, s in ipairs(self.smear) do
            SetImageState(s.img, "add+alpha", s.alpha, 255, 227, 132)
            Render(s.img, s.x, s.y, s.rot, s.hscale, s.vscale)
        end
    end
end--boss6
do
    boss.Define("7a", "八云蓝", "TH07_2", TH07_bg, { -300, 480 }, class["SCBG7"], "Ran", 2)
    boss.Define("7b", "八云紫", "TH07_2", TH07_bg, { 300, 480 }, class["SCBG7"], "Yukari", 2)
    local name = "结界「前鬼后鬼的网孔」"
    local sc1 = boss.card.New(name, 1, 1, 80, 700)
    local sc2 = boss.card.New(name, 1, 1, 80, 900)
    boss.card.add({ { sc1, "7a" }, { sc2, "7b" } }, 2, name, 11)
    function sc1:before()
        task.MoveTo(-70, 120, 60, 2)
    end
    function sc1:init()
        task.New(self, function()
            boss.violent(self)
            task.Wait(60)
            while true do
                for i = 1, 10 do
                    New(class["bullet2-1"], self.x, self.y, 2, i * 36)
                    PlaySound("tan00")
                end
                task.Wait(230)
            end
        end)
        task.New(self, function()
            task.Wait()
            local col = { COLOR.GOLDEN_YELLOW, COLOR.GREEN }
            do
                while true do
                    Newcharge_in(self.x, self.y, 255, 255, 100)
                    boss.cast(self, 300)
                    do
                        local a, _d_a = (ran:Int(0, 1) * 180), (180)
                        for t = 1, 4 do
                            New(class["bullet2-1"], self.x, self.y, col[t % 2 + 1], a)
                            PlaySound("tan00")
                            task.Wait(60)
                            a = a + _d_a
                        end
                    end
                    task.Wait(100)
                    task.MoveToPlayer(60, -96, 96, 112, 144,
                            32, 64, 16, 32, 2, 3)
                    task.Wait(200)
                end
            end
        end)
    end
    function sc1:render()
        local t = self.ani
        SetImageState("ran-ef", "mul+add", 75 + min(75, t) + sin(t * 0.4 - 90) * 75, 255, 255, 255)
        Render("ran-ef", self.x, self.y + 4 * sin(t * 4), 0, 1 + sin(t * 0.4 + 135) * 0.2)
    end

    function sc2:before()
        task.MoveTo(70, 120, 60, 2)
    end
    function sc2:init()
        local flag, wait, rand = false, 32, 20
        local way = 30
        task.New(self, function()
            boss.violent(self)
            flag = true
            wait = 128
            rand = 0
            way = 20
        end)
        task.New(self, function()
            local d = 1
            do
                while true do
                    object.BulletDo(function(unit)
                        if unit.flag then
                            New(class["laser2-1"], unit.x, unit.y, unit._index, unit.rot + 90 * d + ran:Float(-rand, rand))
                        end
                    end)
                    d = -d
                    task.Wait(wait)
                end
            end
        end)
        task.New(self, function()
            task.Wait()
            do
                while true do
                    boss.cast(self, 500)
                    Newcharge_in(self.x, self.y, 255, 255, 100)
                    do
                        local col, _d_col = (2), (2)
                        for _ = 1, 5 do
                            for a in sp.math.AngleIterator(Angle(self, player), way) do
                                for v = 0, 1 do
                                    local b = NewSimpleBullet(arrow_small, col, self.x, self.y, 1 + v * 0.7, a)
                                    b.flag = flag
                                end
                            end
                            PlaySound("tan00")
                            task.Wait(100)
                            col = col + _d_col
                        end
                    end
                    task.MoveToPlayer(60, -96, 96, 112, 144,
                            32, 64, 16, 32, 2, 3)
                    task.Wait(200)
                end
            end
        end)
    end
    function sc2:render()
        local t = self.ani
        SetImageState("yukari-ef", "mul+add", 50 + min(150, t) + sin(t * 0.7 - 90) * 50, 255, 255, 255)
        Render("yukari-ef", self.x, self.y + 4 * sin(t * 4), -0.5 * t, 1.8 + sin(t * 0.7 + 135) * 0.1)
    end
end--boss7
do
    boss.Define("8a", "西行寺幽幽子", "TH07_2", TH07_bg, { 0, 480 }, class["SCBG9"], "Yuyuko", 2)
    boss.Define("8b", "八云紫", "TH07_2", TH07_bg, { 300, 480 }, class["SCBG9"], "Yukari", 2)
    local name = "圣灵「樱花结界」"
    local sc1 = boss.card.New(name, 50, 50, 50, 1500)
    local sc2 = boss.card.New(name, 50, 50, 50, 1500)
    boss.card.add({ { sc1, "8a" }, { sc2, "8b" } }, 2, name, 12)
    function sc1:before()
        --    self.fan = New(class["fan"], self)
        ToBigScreen(60)
        task.MoveTo(0, 144, 60, 2)
    end
    function sc1:init()
        self.colli = false
        _object.set_color(self, "", 255, 120, 120, 120)
        task.New(self, function()
            boss.cast(self, 60 * 120)
            do
                local n = 3
                local c = (180 - 360 / n) / 2
                local d = 1 / tan(c) * 1.5
                local t = 20
                local x, b

                local a = 0
                for _ = 1, n do
                    x = d
                    for _ = 1, t do
                        b = New(class["bullet2-4"], self.x, self.y, sp.math.RectangularToPolar(x * cos(a) - 1.5 * sin(a), x * sin(a) + 1.5 * cos(a)))
                        b.c = nil
                        x = x - 2 * d / t
                    end
                    a = a + 360 / n
                end
                a = 180
                for _ = 1, n do
                    x = d
                    for _ = 1, t do
                        b = New(class["bullet2-4"], self.x, self.y, sp.math.RectangularToPolar(x * cos(a) - 1.5 * sin(a), x * sin(a) + 1.5 * cos(a)))
                        b.c = nil
                        x = x - 2 * d / t
                    end
                    a = a + 360 / n
                end
            end
            task.Wait(80)
            local i = 30
            local x, y
            local by = 230
            while true do
                x, y = ran:Float(-320, 320), ran:Float(230, max(by, -190))
                for a = 1, 2 do
                    New(class["bullet2-4"], x, y, ran:Float(0.5, 2), a * 180 + 90 + ran:Sign() * 3)
                end
                i = i - 1
                task.Wait(max(i, 11))
                by = by - 10
            end
        end)
        task.New(self, function()
            task.Wait(300)
            local wait = 300
            while true do
                New(class["servant2-1"], self.x, self.y, ran:Float(150, 300) * ran:Sign(), ran:Float(80, 180) * ran:Sign())
                task.Wait(wait)
                wait = max(100, wait - 30)
            end
        end)
    end

    function sc2:before()
        task.MoveTo(0, 0, 60, 2)
    end
    function sc2:init()
        boss.card.UnlockOD(self, 8)
        task.New(self, function()
            task.Wait(180)
            Newcharge_in(self.x, self.y, 255, 255, 100)
            self._wisys:SetFloat()
            _object.set_color(self, "", 255, 120, 120, 120)
            self.colli = false
            boss.show_aura(self, false)
            boss.cast(self, 120 * 60)
            task.Wait(120)
            self.hide = true
            player.x = 0
            player.y = 0
            New(WhiteScreen, LAYER.TOP, 30)
            local a = 0
            for _ = 1, 4 do

                object.Connect(self, New(class["laser2-2"], self.x + cos(a) * 260, self.y + sin(a) * 260, a, 1), 0, true)

                a = a + 90
            end
            a = 45
            for _ = 1, 4 do
                object.Connect(self, New(class["laser2-2"], self.x + cos(a) * 260, self.y + sin(a) * 260, a, 1), 0, true)
                a = a + 90
            end
            task.Wait(300)
            Newcharge_in(self.x, self.y, 255, 255, 100)
            task.Wait(60)
            task.MoveTo(180, 0, 240, VALUE_SET.ACC_DEC)
            task.Wait(120)
            task.MoveTo(180, -180, 160, VALUE_SET.ACC_DEC)
            task.Wait(60)
            task.MoveTo(-180, 180, 480, VALUE_SET.ACC_DEC)
            task.Wait(120)
            task.MoveTo(-180, 0, 160, VALUE_SET.ACC_DEC)
            task.Wait(120)
            Newcharge_in(self.x, self.y, 255, 255, 100)
            task.Wait(60)
            do
                local s, _d_s = (180), (0.4)
                while true do
                    self.x = cos(s) * 180
                    self.y = sin(s) * 180
                    task.Wait()
                    s = s + _d_s
                end
            end
        end)
    end
end--boss8
do
    boss.Define("9od", "八云紫", "TH07_2", TH07_bg, { 300, 480 }, class["SCBG8"], "Yukari", 2)
    local sc = boss.card.New("「简单弹幕结界-Special」", 48, 48, 48, 1500)
    boss.card.add({ { sc, "9od" } }, 2, "「简单弹幕结界-Special」", 13, 8)
    function sc:before()
        self._wisys:SetFloat()
        PlaySound("ch00")
        boss.show_aura(self, false)
        New(boss_cast_darkball, 0, 120, 60, 80, 360, 1, 270, 64, 64, 255, 2)
        New(boss_cast_darkball, 0, 120, 60, 80, 360, 1, 270, 255, 64, 64, -2)
        task.Wait(80)
        self.x, self.y = 0, 120
        boss.show_aura(self, true)
        task.Wait(60)
    end
    function sc:init()
        task.New(self, function()
            task.MoveTo(0, 0, 60, 2)
            task.Wait(60)
            _object.set_color(self, "", 255, 120, 120, 120)
            self.colli = false
            boss.cast(self, 80 * 60)

            task.New(self, function()
                Newcharge_in(self.x, self.y, 255, 255, 100)
                for i = 1, 3 do
                    object.Connect(self, New(class["BulletPart.1"], self.x, self.y, i * 120, 1), 0, true)
                    object.Connect(self, New(class["BulletPart.1"], self.x, self.y, i * 120, -1), 0, true)
                end
                task.Wait(240 + 90)
                for _, unit in ObjList(GROUP.NONTJT) do
                    object.Del(unit)
                end
                task.Wait(240)
                Newcharge_out(self.x, self.y, 255, 255, 100)
                do
                    self.d = true
                    task.Wait()
                    self.d = false
                end
                task.Wait(240)
                Newcharge_in(self.x, self.y, 255, 255, 100)
                for i = 1, 10 do
                    object.Connect(self, New(class["BulletPart.2"], self.x, self.y, i * 36))

                end
                task.Wait(360 + 90)
                for _, unit in ObjList(GROUP.NONTJT) do
                    object.Del(unit)
                end
                task.Wait(300)
                Newcharge_out(self.x, self.y, 255, 255, 100)
                do
                    self.d = true
                    task.Wait()
                    self.d = false
                end
                task.Wait(240)
                Newcharge_in(self.x, self.y, 255, 255, 100)
                for i = 1, 2 do
                    object.Connect(self, New(class["BulletPart.3"], self.x, self.y, i * 180))
                end
                task.Wait(420 + 90)
                for _, unit in ObjList(GROUP.NONTJT) do
                    object.Del(unit)
                end
                task.Wait(240)
                Newcharge_out(self.x, self.y, 255, 255, 100)
                do
                    self.d = true
                    task.Wait()
                    self.d = false
                end
                task.Wait(60)
                PlaySound("kira00")
                lstg.var.timeslow = 2
                lstg.var.gray = true
            end)

        end)


    end
    function sc:del()
        New(tasker, function()
            task.Wait(60)
            lstg.var.timeslow = 1
            lstg.var.gray = false
        end)
    end
    function sc:render()
        local t = self.ani
        SetImageState("yukari-ef", "mul+add", 50 + min(150, t) + sin(t * 0.7 - 90) * 50, 255, 255, 255)
        Render("yukari-ef", self.x, self.y, -0.5 * t, 1.8 + sin(t * 0.7 + 135) * 0.1)
    end
end--boss9


do
    class["bullet0-1"] = Class(bullet, { init = function(self, _x, _y, v, a, f, t)
        bullet.init(self, grain_b, COLOR.BLUE, true, true)
        self.x, self.y = _x, _y
        PlaySound("kira00", 0.1, self.x / 256, false)
        object.SetV(self, v, a, true)
        task.New(self, function()
            if f > 0 then
                local V, _d_v = (v), (-v / 39)
                for _ = 1, 40 do
                    object.SetV(self, V, self.rot, true)
                    task.Wait()
                    V = V + _d_v
                end
                object.Del(self)
                local A = 20 * (t - 1) + Angle(self, player)
                for _ = 1, t do
                    New(class["bullet0-1"], self.x, self.y, v, A, f - 1, t + 2)

                    A = A - 40 * (t - 1) / (t - 1)
                end
            end
        end)
    end })
    class["bullet0-2"] = Class(bullet, { init = function(self, _x, _y, a, v, master)
        bullet.init(self, ball_mid_c, COLOR.BLUE, true, true)
        self.x, self.y = _x, _y
        PlaySound("tan00", 0.1, self.x / 256, false)
        _object.set_color(self, "mul+add", 255, 255, 255, 255)
        object.SetV(self, 0, a, true)
        task.New(self, function()
            while true do
                if IsValid(master) and master.jiu then
                    break
                end
                task.Wait()
            end
            PlaySound("kira00", 0.1, self.x / 256, false)
            object.ChangingV(self, 0, v, self.rot, 120, true)
        end)
        task.New(self, function()
            while true do
                if master.otherboss[1] then
                    if Dist(master.otherboss[1], self) < 30 then
                        object.Del(self)
                    end
                end
                task.Wait()
            end
        end)
    end })
    class["bullet0-3"] = Class(bullet, {
        init = function(self, _x, _y, v, a)
            bullet.init(self, arrow_big, COLOR.RED, true, true)
            self.x, self.y = _x, _y
            PlaySound("tan00", 0.1, self.x / 256, false)
            object.SetV(self, 6, a, true)
            self.v = v
            object.ChangeVwithTask(self, 6, v, self.rot, 25, 0, true)
        end,
        colli = function(self, other)
            self.class.base.colli(self, other)
            if other.group == GROUP.GHOST then
                if other.lazer then
                    object.Del(self)
                    NewSimpleBullet(grain_b, COLOR.RED, self.x, self.y, self.v, self.rot + 30, false, 0, true, true)
                end
            end
        end
    })
    class["bullet0-4"] = Class(bullet, {
        init = function(self, _x, _y, v, a)
            bullet.init(self, arrow_big, COLOR.BLUE, true, true)
            self.x, self.y = _x, _y
            PlaySound("tan00", 0.1, self.x / 256, false)
            object.SetV(self, 6, a, true)
            self.v = v
            object.ChangeVwithTask(self, 6, v, self.rot, 25, 0, true)
        end,
    })
    class["bullet0-5"] = Class(bullet, {
        init = function(self, _x, _y, col, v, a)
            bullet.init(self, grain_a, col, true, true)
            self.x, self.y = _x, _y
            PlaySound("tan00", 0.1, self.x, false)
            self.bound = false

            object.SetV(self, 0.5, a, true)
            object.ChangeVwithTask(self, 0.5, v, self.rot, 60, 30, true)
        end,
        frame = function(self)
            self.class.base.frame(self)
            if Dist(self, player) > 700 then
                object.Del(self)
            end
        end
    })
    class["bullet0-6"] = Class(bullet, {
        init = function(self, _x, _y, col, rot, d, cr, acr, t, hr, vr, v)
            bullet.init(self, heart, col, false, false)
            self.x, self.y = _x, _y
            self.bound = false
            PlaySound("kira00", 1, self.x, false)
            self.hr = 0
            self.vr = 0
            task.New(self, function()
                local a = rot
                local r = cr
                local x0, y0, T
                for rx = 0, _infinite do
                    T = sin(min(rx, 90))
                    x0 = cos(a) * hr * T
                    y0 = sin(a) * vr * T
                    self.hr = hr * T
                    self.vr = vr * T

                    object.SetRelPos(self, x0 * cos(r) - y0 * sin(r), x0 * sin(r) + y0 * cos(r), self.rot, false)
                    self.erot = r
                    self.rot = a + 180
                    task.Wait()
                    a = a + d
                    r = r + acr
                end

            end)
            local wait = 75
            task.New(self, function()
                task.Wait(200)
                while true do
                    Create.bullet_accel(self.x, self.y, grain_a, col, 0.2, v, self.rot)
                    PlaySound("tan00")
                    task.Wait(wait + t)
                end
            end)
        end
    })
    class["bullet0-7"] = Class(bullet, {
        init = function(self, _x, _y, col, v, a)
            bullet.init(self, music, col, false, true)
            self.x, self.y = _x, _y
            self.rot = -90
            PlaySound("tan00", 0.1, self.x / 256, false)
            object.SetV(self, v, a, false)
            self.tt = false
            task.New(self, function()
                while true do
                    if self.tt then
                        break
                    end
                    task.Wait()
                end
                bullet.ChangeImage(self, music, 10)
                Create.bullet_create_eff(self)
                for i = 1, 20 do
                    object.SetV(self, v - v * i / 20, self.rot, true)
                    task.Wait()
                end
                local A = ran:Float(0, 360)
                PlaySound("kira00", 0.1, 0, false)
                for i = 1, 80 do
                    object.SetV(self, 2 * i / 80, A, false)
                    task.Wait()
                end
            end)
        end,
        frame = function(self)
            bullet.frame(self)
            if self.timer < 11 then
                self.colli = false
            else
                self.colli = true
            end
        end,
        colli = function(self, other)
            self.class.base.colli(self, other)
            if other.group == GROUP.GHOST then
                if other.lazer then
                    self.tt = true
                end
            end
        end
    })
    class["bullet1-1"] = Class(_object, { init = function(self, _x, _y, v, a, s, t, r, bs, bl, bi)
        self.x, self.y = _x, _y
        self.img = "leaf"
        self.layer = LAYER.ENEMY_BULLET
        self.group = GROUP.INDES
        self.hide = true
        self.bound = false
        self.navi = false
        self.hp = 10
        self.maxhp = 10
        self.colli = false
        self._servants = {}
        self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
        object.Connect(boss_group[#boss_group], self, 0, true)
        object.SetV(self, v, a, true)
        task.New(self, function()
            for i = 1, t do
                object.SetV(self, v, self.rot + sin(i * s), true)
                task.Wait()
            end
            local A = self.rot
            for i = 1, 20 do
                object.SetV(self, v, A + r * i / 20, true)
                task.Wait()
            end
        end)
        task.New(self, function()
            for i = 1, bl do
                New(class["bullet1-2"], self.x, self.y, bs - bs * i / bl)
                task.Wait(bi)
            end
            object.Del(self)
        end)
        task.New(self, function()
            task.Wait(30)
            while true do
                New(class["bullet1-5"])
                task.Wait(ran:Int(10, 20))
            end
        end)
    end })
    class["bullet1-2"] = Class(bullet, { init = function(self, _x, _y, s)
        bullet.init(self, ball_light, COLOR.PURPLE, false, true)
        self.x, self.y = _x, _y
        _object.set_color(self, "mul+add", 190, 255, 255, 255)
        self.vscale = s
        self.hscale = s
        PlaySound("tan00", 0.1, self.x / 256, false)
        self.a = 11.5 * s
        self.b = 11.5 * s
        task.New(self, function()
            task.Wait(600)
            object.Del(self)
        end)
        task.New(self, function()
            while true do
                self.vscale = s
                self.hscale = s
                self.a = 11.5 * s
                self.b = 11.5 * s
                task.Wait()
            end
        end)
    end })
    class["bullet1-5"] = Class(bullet, {
        init = function(self)
            bullet.init(self, sakura, 4, true, true)
            self.x, self.y = ran:Float(-192, 192), 224
            object.SetV(self, ran:Float(0.3, 0.8), ran:Float(-10, 10) - 90)
            self.rot = -90 + ran:Sign() * 20
            self.ag = 0.01
            if ran:Int(0, 2) == 0 then
                self._r, self._g, self._b = 189, 252, 201
            end
        end,
        frame = function(self)
            bullet.frame(self)
            self.rot = self.rot + sin(self.timer * 3)
        end
    })
    class["bullet1-6"] = Class(bullet, { init = function(self, _x, _y, col, v, a, aa, sty)
        bullet.init(self, sty, col, false, true)
        self.x, self.y = _x, _y
        --self._blend = "mul+add"
        task.New(self, function()
            self.navi = true
            self.bound = false
            PlaySound("tan00", 0.1, self.x / 256, false)
            self.a = self.a * 0.8
            self.b = self.b * 0.8
            self.c = col
            object.SetV(self, 1.5, a, true)
            task.Wait(60)
            for _ = 1, 80 do
                object.SetV(self, 1.5, self.rot + aa / 80, true)
                task.Wait()
            end
            object.ChangingV(self, 1.5, v, self.rot, 60, true)
        end)
        task.New(self, function()
            while true do
                if Dist(self.x, self.y, 0, 0) > 500 then
                    object.Del(self)
                end
                task.Wait()
            end
        end)
    end })
    class["bullet2-1"] = Class(bullet, { init = function(self, _x, _y, col, a)
        bullet.init(self, ball_huge, col, true, true)
        self.x, self.y = _x, _y
        _object.set_color(self, "mul+add", 255, 255, 255, 255)
        self.col = col
        PlaySound("kira00", 0.1, self.x, false)
        object.SetV(self, 4, a, true)
        task.New(self, function()
            object.ChangingV(self, 4, 0, self.rot, 60, true)
            self.flag = true
            object.SetV(self, 2, Angle(self, player), true)
        end)
        task.New(self, function()
            for _ = 1, 15 do
                New(class["bullet2-2"], self.x, self.y, col)
                task.Wait(4)
                NewSimpleBullet(ball_mid, col, self.x, self.y, 1, ran:Float(0, 360), false, 0, false)
                task.Wait(4)
            end
        end)
    end })
    class["bullet2-2"] = Class(bullet, { init = function(self, _x, _y, col)
        bullet.init(self, ball_mid_c, col, false, true)
        self.x, self.y = _x, _y
        PlaySound("tan00", 0.1, self.x / 256, false)
        object.SetV(self, 3, ran:Float(0, 360), true)
        task.New(self, function()
            object.ChangingV(self, 3, 0, self.rot, 30, true)
            object.SetV(self, 2, Angle(self, player), true)
        end)
    end })
    class["bullet2-3"] = Class(bullet, {
        init = function(self, _x, _y, v, a, col, w)
            bullet.init(self, square, col, true, false)
            self.x, self.y = _x, _y
            _object.set_color(self, "", 255, 255, 255, 255)
            self.flag = 1
            self.bound = false
            PlaySound("tan00", 0.1, self.x / 256, false)
            object.SetV(self, 0.1, a, true)
            self.v = v
            task.New(self, function()
                task.Wait(20)
                local V = 0.1
                for _ = 1, 40 do
                    if self.flag == 0 then
                        break
                    end
                    object.SetV(self, V, self.rot, true)
                    task.Wait()
                    V = V + (-0.1 + v) / 39
                end
                task.Wait(w - 30)
                V = v
                for _ = 1, 30 do
                    if self.flag == 0 then
                        break
                    end
                    object.SetV(self, V, self.rot, true)
                    task.Wait()
                    V = V - v / 29
                end
            end)
        end,
        frame = function(self)
            bullet.frame(self)
            if _boss.d == true and self.flag == 1 then
                self.flag = 0
                self.bound = true
                PlaySound("kira00")
                object.ChangeVwithTask(self, 0, self.v, self.rot, 40, 0, true)
            end
        end
    })
    class["bullet2-4"] = Class(bullet, {
        init = function(self, _x, _y, v, a)
            bullet.init(self, sakura, COLOR.PURPLE, true, true)
            self.x, self.y = _x, _y
            self.colli = false
            self.a = self.a * 0.5
            self.b = self.b * 0.5
            if Dist(self, player) < 60 then
                object.Del(self)
            end
            self.c = ran:Int(1, 360)
            PlaySound("tan00", 0.1, self.x / 256, false)
            object.SetV(self, 0.1, a, true)
            task.New(self, function()
                self.colli = true
                task.Wait(20)
                object.ChangingV(self, 0.1, v, a, 40, false)
            end)
        end,
        frame = function(self)
            bullet.frame(self)
            if self.c then
                self.rot = self.rot + sin(self.timer * 3 + self.c)
            end
        end
    })
    class["servant2-1"] = Class(object, {
        init = function(self, x, y, mx, my)
            self.x, self.y = x, y
            self.img = "servant"
            self.layer = LAYER.ENEMY
            self.group = GROUP.INDES
            self.bound = false
            self.colli = false
            self._a = 0
            self.omiga = 5
            task.New(self, function()
                task.New(self, function()
                    task.Wait(320)
                    local a = 255
                    for _ = 1, 60 do
                        self._a = a
                        task.Wait()
                        a = a - 255 / 59
                    end
                    object.Del(self)
                end)
                task.BezierMoveTo(380, 3, mx, my, 0, 0, -mx, my)
            end)
            task.New(self, function()
                local a = 0
                for _ = 1, 60 do
                    self._a = a
                    task.Wait()
                    a = a + 255 / 59
                end
                local d, mvx
                while true do
                    d, mvx = ran:Sign(), ran:Float(-1, 1)
                    for i = 1, 5 do
                        New(class["bullet2-5flower"], self.x, self.y, i * 72, d, mvx)
                    end
                    task.Wait(20)
                end
            end)
        end,
        frame = task.Do,
        render = function(self)
            SetImageState("bright", "mul+add", self._a, 218, 112, 214)
            Render("bright", self.x, self.y, 0, 0.4)
            SetImageState(self.img, "mul+add", self._a, 255, 64, 255)
            DefaultRenderFunc(self)
        end
    })
    class["bullet2-5flower"] = Class(bullet, {
        init = function(self, x, y, a, o, mvx)
            bullet.init(self, sakura, 4, false, true)
            self.mx, self.my = x, y
            self.rot = a
            self.x, self.y = self.mx + cos(self.rot + 180) * 8, self.my + sin(self.rot + 180) * 8
            self.omiga = o
            self.mvx, self.mvy = mvx, sign(y)
            self.max, self.may = 0, -sign(y) * 0.03
            self.colli = false
            if Dist(self, player) < 60 then
                object.Del(self)
            end
            task.New(self, function()
                self.colli = true
            end)
        end,
        frame = function(self)
            bullet.frame(self)
            self.x, self.y = self.mx + cos(self.rot + 180) * 8, self.my + sin(self.rot + 180) * 8
            self.mx, self.my = self.mx + self.mvx, self.my + self.mvy
            self.mvx, self.mvy = self.mvx + self.max, self.mvy + self.may
            self.mvy = max(-2.2, min(self.mvy, 2.2))
        end
    })

end --bullet

do
    class["enemy0-1"] = Class(_object, { init = function(self, _x, _y, a, r, master)
        self.x, self.y = _x, _y
        self.img = "leaf"
        self.layer = LAYER.ENEMY_BULLET
        self.group = GROUP.ENEMY
        self.hide = true
        self.bound = false
        self.navi = false
        self.hp = 10
        self.maxhp = 10
        self.colli = false
        self._servants = {}
        self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
        do
            for A in sp.math.AngleIterator(a, 6) do
                object.Connect(self, New(class["enemy0-2"], self.x, self.y, A, r, master))
            end
        end
        task.New(self, function()
            task.Wait(90)
            object.ChangingV(self, 6, 0, -90, 80, false)
        end)
    end })
    class["enemy0-2"] = Class(enemy, {
        init = function(self, _x, _y, a, r, master)
            enemy.init(self, 15, 200, false, false, true)
            self.x, self.y = _x, _y
            self.drop = { 0, 0, 0 }
            self.master = master
            task.New(self, function()
                self.protect = true
                task.Wait(1)
                self.protect = false
            end)
            task.New(self, function()
                local rot = a
                local s = 90
                local len, _d_len = (0), (50 / 89)
                for _ = 1, 90 do
                    object.SetRelPos(self, cos(rot) * len, sin(rot) * len, self.rot, false)
                    rot = rot + r * sin(s)
                    s = s - 1
                    task.Wait()
                    len = len + _d_len
                end
                for _ = 1, 80 do
                    object.SetRelPos(self, cos(rot) * 50, sin(rot) * 50, self.rot, false)
                    task.Wait()
                end
                while true do
                    if master.shoot then
                        break
                    end
                    task.Wait()
                end
                local wait, V = 80, 1.3
                task.New(self, function()
                    boss.violent(master)
                    wait, V = 60, 1.6
                end)

                task.New(self, function()
                    local A
                    while true do
                        local v, _d_v = V, -0.5 / 5
                        for _, t in ipairs({ 1, 2, 3, 4, 5, 4 }) do
                            A = 3 * (t - 1) + rot
                            for _ = 1, t do
                                NewSimpleBullet(grain_b, COLOR.PURPLE, self.x, self.y, v, A, false, 0, true, true)
                                A = A - 6 * (t - 1) / (t - 1)
                            end
                            v = v + _d_v
                        end
                        PlaySound("tan00", 0.1, self.x / 256)
                        task.Wait(wait)
                    end
                end)
                local S = 90
                while true do
                    object.SetRelPos(self, cos(rot) * 50, sin(rot) * 50, self.rot, false)
                    rot = rot + r * sin(90 - max(S, 0)) / 4.3
                    S = S - 1
                    task.Wait()
                end
            end)
        end,
        kill = function(self)
            enemy.kill(self)
            if IsValid(self.master) then
                self.master.enemykill = self.master.enemykill + 1
            end
        end
    })
end--enemy

do
    class["laser0-1"] = Class(bent_laser, { init = function(self, _x, _y, a, v, col)
        bent_laser.init(self, col, _x, _y, 30, 6, 4, 6)
        task.New(self, function()
            PlaySound("lazer00", 0.1, self.x, false)
            object.SetV(self, 0.5, a, true)
            object.ChangeVwithTask(self, 0.5, v, self.rot, 60, 60, true)
        end)
    end })
    class["laser0-3"] = Class(bent_laser, { init = function(self, _x, _y, v, a, r)
        bent_laser.init(self, COLOR.RED, _x, _y, 230, 5, 4, 0)
        PlaySound("boon01", 0.6, self.x / 256, false)
        object.SetV(self, v, a, true)
        task.New(self, function()
            local s = 90
            for _ = 1, 180 do
                object.SetV(self, v, self.rot + sin(s), true)
                task.Wait()
                s = s + 3
            end
            local _a = self.rot
            for _ = 1, 100 do
                object.SetV(self, v, _a, true)
                task.Wait()
                _a = _a + r / 99
            end
        end)
        task.New(self, function()
            local t = 0
            while true do
                object.Connect(self, New(class["laser0-4"], self.x, self.y), 0, true)
                t = t + 1
                task.Wait(4)
            end
        end)
    end })
    class["laser0-4"] = Class(object, {
        init = function(self, _x, _y)
            self.x, self.y = _x, _y
            self.layer = LAYER.ENEMY_BULLET
            self.group = GROUP.GHOST
            self.colli = true
            self.lazer = true
            self.a = 5
            self.b = 5
            task.New(self, function()
                for _ = 1, 230 do
                    if not IsValid(self._master) then
                        object.RawDel(self)
                    end
                    coroutine.yield()
                end
                object.Del(self)
            end)
        end,
        frame = task.Do,
        colli = function(self, other)
            self.class.base.colli(self, other)
            if other.group == GROUP.ENEMY_BULLET then
                object.Del(other)
            end
        end
    })
    class["laser1-1"] = Class(laser, {
        init = function(self, _x, _y, col, a, ra)
            laser.init(self, col, _x, _y, 0, 0, 0, 0, 2, 8, 0)
            self.rot = a
            self.Isradial = true
            self.radial_v = 0
            task.New(self, function()
                task.New(self, function()
                    local slast = 0
                    for s = 1, 90 do
                        self.radial_v = sin(s) * 620 - slast
                        self.l1 = sin(s) * 120
                        self.l2 = sin(s) * 500
                        self.rot = a + ra * sin(s)
                        slast = sin(s) * 620
                        task.Wait()
                    end
                end)
                laser._TurnHalfOn(self, 90, true)
                task.Wait(20)
                self.w0 = 8
                laser._TurnOn(self, 30, true, true)
                task.Wait(60)
                laser._TurnOff(self, 30, true)
                object.Del(self)
            end)
        end,
        frame = function(self)
            self.class.base.frame(self)
            object.SetRelPos(self, cos(self.rot) * 100, sin(self.rot) * 100, self.rot, false)
        end
    })
    class["laser2-1"] = Class(laser, {
        init = function(self, _x, _y, col, a)
            laser.init(self, col, _x, _y, 0, 0, 0, 0, 8.8, 7, 0)
            self.layer = LAYER.ENEMY_BULLET - 1
            self.Isradial = true
            self.radial_v = 8
            laser._TurnOn(self, 0, false, false)
            self.rot = a
            task.New(self, function()
                for i = 1, 90 do
                    self.line = sin(i) * 600
                    task.Wait()
                end
            end)
            task.New(self, function()
                task.Wait(110)
                PlaySound("lazer00")
                task.New(self, function()
                    for _ = 1, 30 do
                        self.l3 = self.l3 + 8
                        task.Wait()
                    end
                    for _ = 1, 30 do
                        self.l2 = self.l2 + 8
                        task.Wait()
                    end
                    for _ = 1, 60 do
                        self.l1 = self.l1 + 8
                        task.Wait()
                    end
                end)

                task.Wait(100)
                laser._TurnOff(self, 30, false)
                object.Del(self)
            end)
        end,
        render = function(self)
            SetImageState("white", "mul+add", self.alpha * 255, unpack(ColorList[math.ceil(self.index / 2)]))
            Render("white", self.x + cos(self.rot) * self.line / 2, self.y + sin(self.rot) * self.line / 2, self.rot, self.line / 16, 0.125)
            laser.render(self)
        end
    })
    class["laser2-2"] = Class(laser, {
        init = function(self, _x, _y, a, d)
            laser.init(self, COLOR.PURPLE, _x, _y, 0, 62, Dist(260, 0, 0, 260) - 124, 62, 8, 0, 0)
            self.group = GROUP.INDES
            self.bound = false
            self.rot = a + 135
            self.omiga = 0.3 * d
            task.New(self, function()
                laser._TurnOn(self, 30, true, true)
            end)
            task.New(self, function()
                local l = 90
                while true do
                    object.SetRelPos(self, cos(a) * (205 + sin(l) * 55), sin(a) * (205 + sin(l) * 55), self.rot, false)
                    self.l2 = Dist(205 + sin(l) * 55, 0, 0, 205 + sin(l) * 55) - 124
                    task.Wait()
                    a = a + 0.3 * d
                    l = l + 0.5
                end
            end)
        end
    })

end--laser

do
    class["obj0-1"] = Class(_object, { init = function(self, _x, _y, master)
        self.x, self.y = _x, _y
        self.img = "leaf"
        self.layer = LAYER.ENEMY_BULLET
        self.group = GROUP.INDES
        self.hide = true
        self.bound = false
        self.navi = false
        self.hp = 10
        self.maxhp = 10
        self.colli = false
        self._servants = {}
        self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
        task.New(self, function()
            local a = 0
            local s = 0
            for _ = 1, 120 do
                New(class["bullet0-2"], self.x + cos(a) * 150, self.y + sin(a) * 150, a + 180, 2 - sin(s % 180), master)
                task.Wait()
                a = a + 3
                s = s + 15
            end
            object.Del(self)
        end)
    end })
    class["obj0-2"] = Class(_object, { init = function(self, _x, _y, d, master)
        self.x, self.y = _x, _y
        self.img = "leaf"
        self.layer = LAYER.ENEMY_BULLET
        self.group = GROUP.INDES
        self.hide = true
        self.bound = false
        self.navi = false
        self.hp = 10
        self.maxhp = 10
        self.colli = false
        self._servants = {}
        self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
        self.rot = -90
        task.New(self, function()
            local D = 1
            if d % 360 > 0 then
                D = -1
            else
                D = 1
            end
            local a = d
            for _ = 1, 85 do
                New(class["bullet0-2"], self.x, self.y, a, 2, master)
                task.Wait()
                a = a + 3 * D
            end
            object.Del(self)
        end)
        task.New(self, function()
            for _ = 1, 64 do
                object.SetV(self, 6, self.rot - 6, true)
                task.Wait()
            end
        end)
    end })
    class["BulletPart.1"] = Class(_object, { init = function(self, _x, _y, a, d)
        self.x, self.y = _x, _y
        self.img = "servant"
        self.layer = LAYER.ENEMY_BULLET
        self.group = GROUP.NONTJT
        self.omiga = 3
        self.bound = false
        self.navi = false
        self.hp = 10
        self.maxhp = 10
        self.colli = false
        self._servants = {}
        self._blend, self._a, self._r, self._g, self._b = 'mul+add', 0, 255, 227, 132
        task.New(self, function()
            for t = 1, _infinite do
                object.SetRelPos(self, cos(a) * 224 * sin(min(t, 90)), sin(a) * 224 * sin(min(t, 90)), self.rot, false)
                self._a = 255 * sin(min(t, 90))
                task.Wait()
                a = a - d
            end
        end)
        task.New(self, function()
            task.Wait(90)
            for i = 1, 47 do
                New(class["bullet2-3"], self.x, self.y, 1.5, Angle(self.x, self.y, 0, 0) + int(i / 8) * 10 * d,
                        ({ 4, 14 })[i % 2 + 1], 60 + int(i / 8) * 40)
                task.Wait(5)
            end
        end)
    end })
    class["BulletPart.2"] = Class(_object, { init = function(self, _x, _y, a)
        self.x, self.y = _x, _y
        self.layer = LAYER.ENEMY_BULLET
        self.group = GROUP.NONTJT
        self.bound = false
        self.navi = false
        self.omiga = 3
        self.hp = 10
        self.maxhp = 10
        self.colli = false
        self._servants = {}
        self.img = "servant"
        self._blend, self._a, self._r, self._g, self._b = 'mul+add', 0, 255, 227, 132
        task.New(self, function()
            for t = 1, _infinite do
                object.SetRelPos(self, cos(a) * 224 * sin(min(t, 90)), sin(a) * 224 * sin(min(t, 90)), self.rot, false)
                self._a = 255 * sin(min(t, 90))
                task.Wait()
                a = a - 2.1
            end
        end)
        task.New(self, function()
            task.Wait(90)
            local t = 160
            for c = 1, 14 do
                for A, col in sp.math.AngleIterator(Angle(self, 0, 0), 11) do
                    New(class["bullet2-3"], self.x, self.y, 1, A, col, t)
                end
                local x, y = self.x, self.y
                for _ = 1, 2 do
                    New(class["bullet2-3"], self.x, self.y, 2, Angle(x, y, 0, 0), 12, 80 - c * 4)
                    task.Wait(15)
                end
                task.Wait(5)
                t = t + 5
            end
        end)
    end })
    class["BulletPart.3"] = Class(_object, { init = function(self, _x, _y, a)
        self.x, self.y = _x, _y
        self.layer = LAYER.ENEMY_BULLET
        self.group = GROUP.NONTJT
        self.bound = false
        self.navi = false
        self.omiga = 3
        self.hp = 10
        self.maxhp = 10
        self.colli = false
        self._servants = {}
        self.img = "servant"
        self._blend, self._a, self._r, self._g, self._b = 'mul+add', 0, 255, 227, 132
        task.New(self, function()
            local l = 30
            for t = 1, _infinite do
                object.SetRelPos(self, cos(a) * l, sin(a) * l, self.rot, false)
                self._a = 255 * sin(min(t, 90))
                task.Wait()
                a = a - 2.1
                l = l + 194 / 419
            end
        end)
        task.New(self, function()
            task.Wait(90)
            local A = 180
            for _ = 1, 210 do
                for v = 0, 2 do
                    New(class["bullet2-3"], self.x, self.y, 1.5 + v * 0.7, Angle(self.x, self.y, 0, 0) + A, COLOR.ORANGE, 180)
                end
                New(class["bullet2-3"], self.x, self.y, 1.5, Angle(self.x, self.y, 0, 0) + A, COLOR.ORANGE, 50)
                task.Wait(2)
                A = A - 180 / 209
            end
        end)
        task.New(self, function()
            task.Wait(90)
            local w = 60
            for i = 1, _infinite do
                for _ = 1, 3 do
                    local A = Angle(self.x, self.y, 0, 0) - (100 - i * 6)
                    for _ = 1, 2 do
                        New(class["bullet2-3"], self.x, self.y, 1, A, COLOR.BLUE, w)
                        A = A + (100 - i * 6) * 2
                    end
                    task.Wait()
                end
                task.Wait(21)
                w = w + 6
            end
        end)
    end })
    class["fan"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.group = GROUP.GHOST
            self.layer = LAYER.ENEMY - 1
            self.hscale, self.vscale = 0, 0
            self.bound = false
            self._a, self._s = 0, 0
            task.New(self, function()
                task.Wait(30)
                self.vscale = 0.1
                for i = 1, 30 do
                    self.hscale = sin(i * 3)
                    task.Wait()
                end
                New(WhiteScreen)
                for i = 1, 30 do
                    self.vscale = 0.1 + 0.9 * sin(i * 3)
                    task.Wait()
                end
                while true do
                    task.New(self, function()
                        for i = 1, 10 do
                            self._a = sin(i * 9)
                            task.Wait()
                        end
                        for i = 29, 0, -1 do
                            self._a = sin(i * 3)
                            task.Wait()
                        end
                    end)
                    for i = 1, 60 do
                        self._s = 1 + 0.35 * sin(i * 1.5)
                        task.Wait()
                    end
                    task.Wait(60)
                end
            end)
        end,
        frame = function(self)
            if not IsValid(self.master) then
                object.Del(self)
                return
            end
            task.Do(self)
            local x, y = self.master._wisys:GetFloat(self.master.ani)
            self.x, self.y = self.master.x + x, self.master.y + y
        end,
        render = function(self)
            SetImageState("fan", "mul+add", 255, 255, 255, 255)
            Render("fan", self.x, self.y, 0, self.hscale, self.vscale)
            if self._a > 0 then
                SetImageState("fan", "mul+add", 255 * self._a, 255, 255, 255)
                Render("fan", self.x, self.y, 0, self._s)
            end
        end
    })

end --object


LoadTexture("instrument", "mod\\GAME\\07-instrument.png")
LoadImage("ins1", "instrument", 0, 0, 32, 32)
LoadImage("ins2", "instrument", 32, 0, 32, 32)
LoadImageGroup("ins3", "instrument", 64, 0, 32, 32, 3, 1)

