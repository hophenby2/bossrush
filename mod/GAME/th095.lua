local cos, sin, min, max, int = cos, sin, min, max, int
local bullet, object, laser, boss = bullet, object, laser, boss
local task, ran, Create = task, ran, Create
local table = table
local New = New
local NewSimpleBullet = NewSimpleBullet
local PlaySound = PlaySound
local IsValid = IsValid
local SetImageState = SetImageState
local Dist, Angle = Dist, Angle
local Render = Render
local Class = Class
local Newcharge_in, Newcharge_out = Newcharge_in, Newcharge_out

local class = {}
_editor_class["TH095"] = class

do
    class.SCBG1 = Class(_SC_BG)
    function class.SCBG1:init()
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th09_5_0", false,
                0, 0, 0, 0, 0, 0.5, "mul+add", 2.2, 2.2)
        _SC_BG.AddLayer(self, "th09_5_1", false,
                0, 0, 0, 0, 0, 0, "", 1, 1)
    end

    class.ran_bg = Class(_SC_BG)
    function class.ran_bg:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th07_8", false, 0, 0, 0, 0, 0,
                0.5, "mul+add", 2.5, 2.5)
        b.a = 150
        b = _SC_BG.AddLayer(self, "th07_8", false, 0, 0, 180, 0, 0,
                -0.4, "mul+rev", 2.7, 2.7)
        b.r = 100

        b = _SC_BG.AddLayer(self, "th07_10")
        b.hscale, b.vscale = 2, 2
    end

    class.komachi_bg = Class(_SC_BG)
    function class.komachi_bg:init()
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th09_6", true, 128, 0, 0, -1.4, 0.9, 0, "mul+rev")
        local b = _SC_BG.AddLayer(self, "th09_6", true, 0, 0, 0, -1.5, 1, 0, "")
        b.r, b.g, b.b = 200, 200, 200
        _SC_BG.AddLayer(self, "th09_5")
    end
end--sc_bg

do
    local RanBack = Class(object, {
        init = function(self, master, interval)
            object.init(self, master.x, master.y, GROUP.INDES, LAYER.ENEMY - 1)
            self.bound = false
            self.img = "ran-ef"
            self._a, self._s = 0, 0
            self._A = 0
            task.New(self, function()
                task.init_left_wait(self)
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
                    task.Wait2(self, interval - 60)
                end
            end)
            task.New(self, function()
                while IsValid(master) do
                    self._A = 100 + sin(self.timer) * 50
                    self.hscale = 1.05 - sin(self.timer) * 0.05
                    self.vscale = self.hscale
                    local x, y = master._wisys:GetFloat(master.ani)
                    self.x, self.y = master.x + x, master.y + y
                    task.Wait()
                end
                Del(self)
            end)
        end,
        frame = task.Do,
        render = function(self)
            SetImageState(self.img, "mul+add", self._A, 255, 255, 255)
            object.render(self)
            if self._a > 0 then
                SetImageState(self.img, "mul+add", 255 * self._a, 255, 255, 255)
                Render(self.img, self.x, self.y, 0, self._s)
            end
        end
    })
    class.RanBack = RanBack
end--object



do
    local function SetRanImage(self)
        self._wisys = BossWalkImageSystemRotate(self)
        self._wisys:SetImageInList("Ran")
        self._wisys:SetFloat(function(ani)
            return 0, 4 * sin(ani * 4)
        end)
        self.back = New(class.RanBack, self, 80)
    end
    boss.Define("2a", "八云蓝", "TH09_5_1", TH095_bg, { 300, 400 }, class.ran_bg, "Ran", 5)

    local non_sc1 = boss.card.New("", 1, 1, 45, 700)
    function non_sc1:before()
        SetRanImage(self)
        task.MoveTo(0, 120, 60, 2)
    end
    function non_sc1:init()
        task.New(self, function()
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            task.New(self, function()
                local shoot_laser = Class(laser, {
                    init = function(self, master, col, w, a, dr, time)
                        laser.init(self, col, master.x, master.y, a, 0, 0, 0, w, w, 0)
                        laser._TurnHalfOn(self, 0, false)
                        self.line = 0
                        self.Isradial = true
                        self.radial_v = 20
                        task.New(self, function()
                            while IsValid(master) do
                                self.x, self.y = master.x, master.y
                                task.Wait()
                            end
                            Del(self)
                        end)
                        task.New(self, function()
                            task.New(self, function()
                                for i = 1, 60 do
                                    self.line = sin(i / 60 * 90) * 600
                                    task.Wait()
                                end
                            end)
                            local slast = 0
                            for i = 1, time do
                                self.rot = self.rot + dr * task.SetMode[2](i / time) - slast
                                slast = dr * task.SetMode[2](i / time)
                                task.Wait()
                            end
                            laser._TurnOn(self, 1, true, false)
                            for _ = 1, 30 do
                                self.l3 = self.l3 + 20
                                task.Wait()
                            end
                            for _ = 1, 30 do
                                self.l1 = self.l1 + 20
                                task.Wait()
                            end
                            laser._TurnOff(self, 30, true)
                            object.Del(self)

                        end)
                    end,
                    render = function(self)
                        SetImageState("white", "mul+add", self.alpha * 180, unpack(ColorList[math.ceil(self.index / 2)]))
                        Render("white", self.x + cos(self.rot) * self.line / 2, self.y + sin(self.rot) * self.line / 2, self.rot, self.line / 16, 0.125)
                        laser.render(self)
                    end
                }, true)
                local d = 1
                while true do
                    task.Wait(75)
                    for x = -1.5, 1.5 do
                        x = x * d
                        NewSimpleServant(self.x, self.y, 0, 255, 227, 132, 1.5, function(unit)
                            unit.omiga = ran:Sign() * ran:Float(2, 3)
                            task.New(unit, function()
                                unit:FadeIn(15)
                                object.ChangingSizeColli(unit, -0.5, -0.5, 15)
                            end)
                            task.New(unit, function()
                                task.MoveTo(x * 100, 224, 80, 2)
                                for a in sp.math.AngleIterator(-90 + ran:Float(-5, 5), 7) do
                                    New(shoot_laser, unit, 14, 12, a, 0, 80)
                                end
                                task.Wait(80)
                                NewBon(unit.x, unit.y, 60, 128, 255, 227, 132)
                                task.Wait(44)
                                object.ChangingSizeColli(unit, -1, -1, 15)
                                Del(unit)
                            end)
                        end)
                        task.Wait(15)
                    end
                    d = -d
                end
            end)
            local d = 1
            local i = 1
            while true do
                if i % 2 == 0 then
                    task.New(self, function()
                        task.MoveToPlayer(45, -96, 96, 100, 144,
                                20, 40, 10, 20, 2, 1)
                    end)
                end
                for a in sp.math.AngleIterator(i * 55, 12) do
                    for v = 1, 4 do
                        Create.bullet_decel(self.x, self.y, square, 14, 4 + v * 0.3,
                                3 + v * 0.3, a + v * d * 2, false, false)
                    end
                end
                PlaySound("tan00")
                d = -d
                i = i + 1
                task.Wait(20)
            end
        end)
    end
    boss.card.add({ { non_sc1, "2a" } }, 5, "非符", 185)

    local cardname1 = "幻神「荼枳尼天结跏跌坐」"
    local sc1 = boss.card.New(cardname1, 1, 3, 50, 900)
    function sc1:before()
        SetRanImage(self)
        if ext.sc_pr then
            task.MoveTo(70, 120, 60, 2)
        else
            task.Wait(60)
        end
    end
    function sc1:init()
        local Fallblock = Class(object, {
            init = function(self, x, y, py)
                object.init(self, x, y, GROUP.INDES, LAYER.ENEMY - 1)
                self.bound = false
                self.img = "ran-ef"
                self._a, self._s = 0, 0
                self._A = 200
                task.New(self, function()
                    task.MoveTo(self.x, py, 90, 2)
                    PlaySound("kira00")
                    NewWave(self.x, self.y, 2, ran:Float(90, 135), 45, 255, 227, 132)
                    task.New(self, function()
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
                    end)
                    for X = -3, 3 do
                        for Y = -5, 5 do
                            if abs(Y) == 5 or abs(X) == 3 then
                                local b = NewSimpleBullet(ball_mid, 14, self.x, self.y, 0, 0)
                                b.fogtime = 0
                                b.master = self
                                b.offx = X * 11
                                b.offy = Y * 11
                                b._blend = "mul+add"
                                function b:frame_other()
                                    if IsValid(self.master) then
                                        self.x = self.master.x + self.offx * self.master.hscale
                                        self.y = self.master.y + self.offy * self.master.vscale
                                    else
                                        Del(self)
                                    end
                                end
                            end
                        end
                    end
                    for a, i in sp.math.AngleIterator(ran:Float(0, 360), 18) do
                        Create.bullet_accel(self.x, self.y, arrow_big, 14, 0.2, i % 2 * 0.5 + 1.5, a, true, false)
                    end
                    self.ag = 0.021
                    while self.y > -300 do

                        self.hscale = self.hscale - 1 / 400
                        self.vscale = self.hscale
                        task.Wait()
                    end
                    Del(self)
                end)
            end,
            frame = task.Do,
            render = function(self)
                SetImageState(self.img, "mul+add", self._A, 255, 255, 255)
                object.render(self)
                if self._a > 0 then
                    SetImageState(self.img, "mul+add", 255 * self._a, 255, 255, 255)
                    Render(self.img, self.x, self.y, 0, self._s * self.hscale)
                end
            end
        }, true)
        task.New(self, function()
            task.MoveTo(0, 120, 60, 2)
            Newcharge_in(0, 120, 180, 250, 185)
            task.Wait(60)
            PlaySound("boon00")
            for x = -2, 2 do
                New(Fallblock, x * 83, 300, player.y + 90)
            end
            task.Wait(240)
            task.New(self, function()
                while true do
                    for a in sp.math.AngleIterator(Angle(self, player), 13) do
                        Create.bullet_decel(self.x, self.y, ball_huge, 2, 5, 3, a, false, false)
                    end
                    PlaySound("tan00")
                    task.Wait(75)
                end
            end)--ball_big
            task.New(self, function()
                while true do
                    task.MoveToPlayer(40, -96, 96, 100, 144,
                            20, 40, 10, 20, 2, 1)
                    task.Wait(50)
                end
            end)--move
            task.New(self, function()
                local t = 280
                while true do
                    Newcharge_in(self.x, self.y, 180, 250, 185)
                    task.Wait(60)
                    PlaySound("boon00")
                    for x = -2, 2 do
                        New(Fallblock, x * 83, 300, player.y + 70)
                    end
                    task.Wait(t)
                    t = max(200, t - 10)
                end
            end)--block

        end)
    end
    boss.card.add({ { sc1, "2a" } }, 5, cardname1, 186)
end--1八云蓝

do
    boss.Define("3a", "小野塚小町", "TH09_5_1", TH095_bg, { -300, 400 }, class.komachi_bg, "Komachi", 5)

    local non_sc1 = boss.card.New("", 1, 1, 45, 700)
    function non_sc1:before()
        task.MoveTo(0, 120, 60, 2)
    end
    function non_sc1:init()
        task.New(self, function()
            Newcharge_in(self.x, self.y, 189, 252, 201)
            task.Wait(30)

            task.Wait(30)
            task.New(self, function()
                local d = 1
                while true do
                    NewSimpleServant(222 * d, 144, 0, 255, 227, 132, 1.5, function(unit)
                        unit.omiga = ran:Sign() * ran:Float(2, 3)
                        --unit.bound = false
                        task.New(unit, function()
                            unit:FadeIn(15)
                            object.ChangingSizeColli(unit, -0.5, -0.5, 15)
                        end)
                        task.New(unit, function()
                            unit.vy = -ran:Float(0.1, 0.2)
                            unit.vx = -d * ran:Float(2, 3)
                            task.Wait(20)
                            while true do
                                local b = NewSimpleBullet(money, ran:Int(13, 14),
                                        unit.x + ran:Float(-20, 20), unit.y + ran:Float(-20, 20),
                                        ran:Float(2.5, 3.5), 90 + ran:Float(-30, 30))
                                b.fogtime = 30
                                b.ag = 0.023
                                b.maxvy = 3
                                b.omiga = ran:Float(2, 3) * d
                                b._blend = "mul+add"
                                PlaySound("tan00")
                                task.Wait(ran:Int(6, 8))
                            end
                        end)
                    end)
                    task.Wait(70)
                    d = -d
                end
            end)
            task.Wait(60)
            local d = 1
            while true do
                boss.cast(self, 60)
                local A = ran:Float(0, 360)
                NewBon(self.x, self.y, 60, 128, 218, 114, 214)
                for i = 1, 13 do
                    for a in sp.math.AngleIterator(A - task.SetMode[2](i / 13) * 50 * d, 23) do
                        Create.bullet_decel(self.x + cos(a) * 30, self.y + sin(a) * 30, grain_a, 4,
                                4, 3.5 - abs(i - 7) * 0.2, a, true, false)
                    end
                    PlaySound("tan00")
                    task.Wait(2)
                end
                NewBon(self.x, self.y, 60, 128, 135, 206, 235)
                for i = 1, 13 do
                    for a in sp.math.AngleIterator(A + task.SetMode[2](i / 13) * 30 * d, 18) do
                        Create.bullet_decel(self.x + cos(a) * 30, self.y + sin(a) * 30, grain_a, 6,
                                4, 2 - abs(i - 7) * 0.1, a, true, false)
                    end
                    PlaySound("tan00")
                    task.Wait(2)
                end

                task.Wait(60)
                for a in sp.math.AngleIterator(Angle(self, player), 15) do
                    Create.laser_line(self.x, self.y, 2, 6, a, 30, 10, 10)
                end
                task.MoveToPlayer(60, -96, 96, 100, 144,
                        20, 40, 10, 20, 2, 1)
                d = -d
                task.Wait(10)
            end
        end)
    end
    boss.card.add({ { non_sc1, "3a" } }, 5, "非符", 187)

    local cardname1 = " 舟符「曲折的三途河」"
    local sc1 = boss.card.New(cardname1, 1, 1, 55, 550)
    function sc1:before()
        if ext.sc_pr then
            task.MoveTo(-70, 120, 60, 2)
        else
            task.Wait(60)
        end
    end
    function sc1:init()
        task.New(self, function()
            task.MoveTo(-150, 40, 60, 2)
            Newcharge_in(-150, 40, 180, 250, 185)
            task.Wait(60)
            task.New(self, function()
                local k = 10
                local rot = -90
                local radius = 30
                while true do
                    for a in sp.math.AngleIterator(rot + 18, 10) do
                        Create.bullet_accel(self.x + cos(a) * radius, self.y + sin(a) * radius, ball_mid, 2,
                                2.78 - abs(k % 19 + 1 - 10) * 0.09, 1, a, true, false, 120, 45)

                    end
                    PlaySound("tan00", 0.1, 0, true)
                    task.Wait(2)
                    k = k + 1
                    -- rot = rot + 2
                    radius = max(0, radius - 1)
                end
            end)
            task.New(self, function()
                local d = 1
                while true do
                    for k = 0, 2 do
                        for a in sp.math.AngleIterator(Angle(self, player), 17) do
                            local b = NewSimpleBullet(money_big, 14, self.x, self.y, 1.8, a)
                            b.omiga = d * 4
                            b._blend = "mul+add"
                            b.fogtime = 70 + k * 30
                        end
                    end
                    task.BezierMoveTo(152, 3, 0, 120, 150 * d, 40)
                    -- task.Wait(40)
                    d = -d
                end
            end)
        end)
    end
    boss.card.add({ { sc1, "3a" } }, 5, cardname1, 188)
end--2小野塚小町


do
    boss.Define("1a", "伊吹萃香", "TH09_5_0", TH095_bg, { 500, 0 }, class.SCBG1, "Suika", 5)

    local non_sc1 = boss.card.New("", 1, 1, 45, 800)
    function non_sc1:before()
        self.fog = {}
        self.hscale = 0
        self.vscale = 0
        local b
        task.New(self, function()
            for j = 1, 390 do
                for i = -1, 1 do
                    NewSimpleBullet(water_drop, 2, self.x, self.y, ({ 4, 6 })[j % 2 + 1], math.deg(math.atan2(self.dy, self.dx)) + 180 + i * 10, false, 0, false)
                end
                task.Wait()
                b = Create.bullet_accel(self.x + ran:Float(-30, 30), self.y + ran:Float(-30, 30), grain_b, 4, 0.2, 1.5, ran:Float(0, 360), true)
                b.frame_new = function(self)
                    bullet.frame(self)
                    if self.timer > 120 then
                        object.Del(self)
                    end
                end
                PlaySound("tan00", 0.2, 0, true)
            end

        end)
        task.BezierMoveTo(260, 2, -200, 60, player.x, player.y)
        task.MoveTo(player.x, player.y, 70, 3)
        task.MoveTo(0, 120, 60, 3)
        for v = 3, 5, 0.3 do
            for i = 1, 45 do
                NewSimpleBullet(ball_mid_c, 2, self.x, self.y, v, Angle(self, player) + i * 8)
            end
        end
        local h, v = 0, 1.8
        Newcharge_out(self.x, self.y, 250, 128, 114)
        for _ = 1, 11 do
            self.vscale = v
            self.hscale = h
            task.Wait()
            h = h + 1 / 10
            v = v - 0.8 / 10
        end
        self.jump = true
    end
    function non_sc1:init()
        local b
        self.shoot = function(x, y, col, v, a, t, time1, time3)
            return function()
                for i = 1, t do
                    b = Create.bullet_dec_acc(x, y, grain_c, col, 4, v, a)
                    b.time1 = time1
                    b.time2 = 20
                    b.time3 = time3 - 30 * i / t
                    --NewSimpleBullet(grain_a, col, x, y, v, a)
                    PlaySound("tan00")
                    time1 = time1 - 2
                    v = v - 0.1
                    task.Wait(4)
                end
            end
        end
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 128, 32, 32)
            task.Wait(60)
            task.New(self, function()
                while true do
                    task.Wait(120)
                    task.MoveToPlayer(80, -96, 96, 80, 144,
                            32, 64, 16, 32, 2, 1)
                end
            end)
            local sty = { ball_mid, ball_big }
            while true do
                local c = 1
                for t = 1, 20 do
                    for r = 90, -90, -20 do
                        task.New(self, self.shoot(self.x + cos(90 + r) * sin(self.timer) * 80, self.y + sin(90 + r) * sin(self.timer) * 80,
                                16, int(t / 2) % 2 + 3, 90 - r * c, 5, 30 + t, 40 + t))
                    end
                    task.Wait(5)
                    c = c + 0.6
                end
                task.Wait(100)
                local a = Angle(self, player)
                for i = 1, 60 do
                    Create.laser_line(self.x, self.y, 6, 4.2, i * 6 + a, 40 + LineNum(i * 6 * 8) * 20, 6, 9, 6)
                end
                local x, y
                for i = 1, 3 do
                    x, y = ran:Float(-96, 96), ran:Float(0, 10) + i * 60 + 30
                    for _ = 1, 20 do
                        b = NewSimpleBullet(sty[ran:Int(1, 2)], ran:Int(1, 2) * 2, x, y, ran:Float(0.1, 1.6), ran:Float(-160, -20))
                        b._blend = "mul+add"
                        b.ag = 0.02 - i * 0.002
                        b.maxvy = 4
                    end
                    task.Wait(10)
                end

                task.Wait(80)
            end
        end)
    end
    function non_sc1:frame()
        if not self.jump then
            if self.ani % 6 == 0 then
                table.insert(self.fog, { x = ran:Float(-10, 10), y = ran:Float(-10, 10),
                                         rot = ran:Float(0, 360), alpha = 0, scale = 1, timer = 1 })
            end
        end
        local f
        for i = #self.fog, 1, -1 do
            f = self.fog[i]
            f.scale = f.scale - 1 / 60
            if f.timer <= 10 then
                f.alpha = min(180, f.alpha + 180 / 10)
            else
                f.alpha = max(0, f.alpha - 180 / 30)
            end
            f.timer = f.timer + 1
            if f.alpha == 0 then
                table.remove(self.fog, i)
            end
        end
    end
    function non_sc1:render()
        if #self.fog > 0 then
            for _, f in ipairs(self.fog) do
                SetImageState("suika_fog", "mul+add", f.alpha, 255, 255, 255)
                Render("suika_fog", self.x + f.x, self.y + f.y, f.rot, f.scale)
            end
        end
    end
    boss.card.add({ { non_sc1, "1a" } }, 5, "一非", 49)

    local sc1 = boss.card.New("热浪「地狱之轮回」", 1, 3, 45, 900)
    function sc1:before()
        if not ext.sc_pr then
            task.Wait(60)
        end
        task.MoveTo(0, 30, 60, 2)
    end
    function sc1:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 128, 32, 32)
            task.Wait(60)
            local d = 1
            for o = 1, 20 do
                PlaySound("boon01")
                if o > 2 then
                    for i = 1, 45 do
                        NewSimpleBullet(ball_mid, 1, self.x, self.y, 2, Angle(self, player) + i * 8)
                    end
                    PlaySound("tan00")
                end
                task.New(self, function()
                    task.Wait(150)
                    for i = 1, 8 do
                        New(class["laser0-1"], self.x, self.y, i * 45, 0.2 * d, 180)
                    end
                end)
                for _ = 1, 120 do
                    New(class["bullet0-1"], self.x, self.y,
                            ran:Float(0, 360), ran:Float(0.2, 0.6) * d, ran:Float(10, 450), 180)
                end
                for i = 1, 300 do
                    player.x = player.x + cos(Angle(self, player) + 90 * d) * sin(i / 300 * 180) * 0.8
                    player.y = player.y + sin(Angle(self, player) + 90 * d) * sin(i / 300 * 180) * 0.8
                    task.Wait()
                end

                d = -d
            end
        end)
    end
    boss.card.add({ { sc1, "1a" } }, 5, "热浪「地狱之轮回」", 50)

    local non_sc2 = boss.card.New("", 1, 1, 45, 700)
    function non_sc2:before()
        self.fog = {}
        --self.__show_scbg=false
        task.New(self, function()
            PlayMusic("TH09_5_4", 0, 81.33 - 3)
            for i = 1, 60 do
                SetBGMVolume("TH09_5_0", 1 - i / 60)
                SetBGMVolume("TH09_5_4", i / 60)
                coroutine.yield()
            end
            StopMusic("TH09_5_0")
        end)
        task.MoveTo(0, 100, 60, 2)
    end
    function non_sc2:init()
        task.New(self, function()
            task.init_left_wait(self)
            local beat = 3600 / 172
            task.Wait(60)
            Newcharge_in(self.x, self.y, 128, 32, 32)
            task.Wait(60)
            local t
            task.New(self, function()
                local h, v = 1, 1
                for _ = 1, 11 do
                    self.vscale = v
                    self.hscale = h
                    task.Wait()
                    h = h - 1 / 10
                    v = v + 0.8 / 10
                end
            end)
            self.open_fog = true
            task.New(self, function()
                while true do
                    task.Wait(80)
                    task.MoveToPlayer(150, -150, 150, 40, 144,
                            120, 130, 40, 80, 3, 1)
                end
            end)
            while true do
                t = ran:Int(5, 10)
                for i = 1, t do
                    New(class["bullet0-2"], -192 + 384 / (t - 1) * (i - 1), 4, 8)
                end
                task.Wait2(self, beat)
            end
        end)
    end
    function non_sc2:frame()
        if self.open_fog then
            if self.ani % 6 == 0 then
                table.insert(self.fog, { x = ran:Float(-10, 10), y = ran:Float(-10, 10),
                                         rot = ran:Float(0, 360), alpha = 0, scale = 1, timer = 1 })
            end
        end
        for _, f in ipairs(self.fog) do
            f.scale = f.scale - 1 / 60
            if f.timer <= 10 then
                f.alpha = min(180, f.alpha + 180 / 10)
            else
                f.alpha = max(0, f.alpha - 180 / 30)
            end
            f.timer = f.timer + 1
        end
        for i = #self.fog, 1, -1 do
            if self.fog[i].alpha == 0 then
                table.remove(self.fog, i)
            end
        end
    end
    function non_sc2:render()
        if #self.fog > 0 then
            for _, f in ipairs(self.fog) do
                SetImageState("suika_fog", "mul+add", f.alpha, 255, 255, 255)
                Render("suika_fog", self.x + f.x, self.y + f.y, f.rot, f.scale)
            end
        end
    end
    function non_sc2:del()
        self.open_fog = false
        New(tasker, function()
            local h, v = 0, 1.8
            for _ = 1, 11 do
                self.vscale = v
                self.hscale = h
                task.Wait()
                h = h + 1 / 10
                v = v - 0.8 / 10
            end
        end)
    end
    boss.card.add({ { non_sc2, "1a" } }, 5, "二非", 51)

    local sc2 = boss.card.New("源赖光「童子切安纲」", 1, 3, 45, 900)
    function sc2:before()
        if ext.sc_pr then
            task.New(self, function()
                PlayMusic("TH09_5_4", 0, 92.48 - 1)
                for i = 1, 60 do
                    SetBGMVolume("TH09_5_0", 1 - i / 60)
                    SetBGMVolume("TH09_5_4", i / 60)
                    coroutine.yield()
                end
                StopMusic("TH09_5_0")
            end)
        end
        task.MoveTo(0, 100, 60, 2)
    end
    function sc2:init()
        task.New(self, function()
            local d = 1
            while true do
                for i = 1, 36 do
                    object.Connect(self, New(class["Small Suika"], self.x, self.y, 3, i * 10), 0.3, true)
                end
                task.Wait(60)
                task.MoveToPlayer(80, -96, 96, 80, 144,
                        32, 64, 16, 32, 2, 1)
                for v = 3, 5, 0.3 do
                    for i = 1, 45 do
                        task.New(NewSimpleBullet(ball_mid_c, 2, self.x, self.y, v, Angle(self, player) + i * 8), function()
                            task.Wait(30)
                            object.SetV(task.GetSelf(), 3, Angle(self, player) + i * 8)
                        end)
                    end
                end
                PlaySound("tan00")
                task.Wait(60)
                Newcharge_in(self.x, self.y, 255, 227, 132)
                task.Wait(60)
                Newcharge_out(self.x, self.y, 255, 227, 132)
                task.Wait(60)
                PlaySound("slash")
                local a = 90 - 90 * d
                local y = -10
                local x = -192 * d
                for j = 1, 20 do
                    for _ = 1, 3 do
                        for i = 1, 4 do
                            NewSimpleBullet(knife_b, ({ 6, 8 })[j % 2 + 1], x, y * y, ({ 1.5, 2 })[j % 2 + 1], a + 90 * i)
                        end
                        a = a + 180 / 59 * d
                        y = y + 20 / 59
                        x = x + 384 / 59 * d
                    end
                    task.Wait()
                end
                task.Wait(60)
                d = -d
            end
        end)

    end
    boss.card.add({ { sc2, "1a" } }, 5, "源赖光「童子切安纲」", 52)

end--萃香

do
    class["bullet0-1"] = Class(bullet, { init = function(self, x, y, a, r, l, lifetime)
        bullet.init(self, water_drop, 2, false, true)
        self.x, self.y = x + cos(a) * l, y + sin(a) * l
        self._a = 0
        self.navi = true
        self.bound = false
        self.timer = 11
        self.colli = false
        local l2 = l
        task.New(self, function()
            for i = 1, 60 do
                l = sin(i * 1.5) * l2
                self._a = 255 * sin(i * 1.5)
                task.Wait()
            end
            self.colli = true
            task.Wait(lifetime)
            self.colli = false
            PlaySound("boon00")
            for i = 1, 60 do
                self._a = 255 - 255 * sin(i * 1.5)
                l = sin(90 - i * 1.5) * l2
                task.Wait()
            end
            object.RawDel(self)
        end)
        task.New(self, function()
            while true do
                self.x, self.y = x + cos(a) * l, y + sin(a) * l
                task.Wait()
                a = a + r
            end
        end)
    end })
    class["laser0-1"] = Class(laser, {
        init = function(self, x, y, a, r, lifetime)
            laser.init(self, 14, x, y, 0, 0, 0, 0, 12, 12, 0)
            laser._TurnHalfOn(self, 0, false)
            self.rot = a
            self.omiga = r
            self.Isradial = true
            self.radial_v = 6
            task.New(self, function()
                for i = 1, 60 do
                    self.line = sin(i * 1.5) * 500
                    task.Wait()
                end
                task.Wait(120)
                laser._TurnOn(self, 1, true, false)
                task.New(self, function()
                    for _ = 1, 40 do
                        self.l3 = self.l3 + 6
                        task.Wait()
                    end
                    for _ = 1, 120 do
                        self.l1 = self.l1 + 6
                        task.Wait()
                    end
                end)
                task.Wait(lifetime)
                laser._TurnOff(self, 30, true)
                object.Del(self)
            end)
        end,
        render = function(self)
            SetImageState("white", "mul+add", self.alpha * 255, unpack(ColorList[math.ceil(self.index / 2)]))
            Render("white", self.x + cos(self.rot) * self.line / 2, self.y + sin(self.rot) * self.line / 2, self.rot, self.line / 16, 0.125)
            laser.render(self)
        end
    })
    class["bullet0-2"] = Class(bullet, {
        init = function(self, x, v, col)
            bullet.init(self, ball_big, col, true, true)
            PlaySound("tan00", 0.1, 0, true)
            self.x = x
            self.y = 224
            object.SetV(self, v, -90, true)
            self.sty = { ball_mid, ball_small, ball_mid_c }
        end,
        frame = function(self)
            bullet.frame(self)
            if _boss and IsValid(_boss) and Dist(self, _boss) < 56 then
                local b
                for _ = 1, 5 do
                    b = NewSimpleBullet(self.sty[ran:Int(1, 3)], ran:Int(2, 3) * 2, self.x, self.y, ran:Float(0.5, 1), ran:Float(0, 360))
                    --b._blend = "mul+add"
                    b.ag = ran:Float(0.01, 0.02)
                end
                object.Del(self)
            end
        end
    })
    class["Small Suika"] = Class(enemy, {
        init = function(self, x, y, v, a)
            self.x, self.y = x, y
            self.hscale = 1
            self.vscale = 1
            self._blend, self._a, self._r, self._g, self._b = "", 0, 255, 255, 255
            self.line = 0
            self.angle = Angle(self, player)
            self.aura = _enemy_aura_tb[1]
            self.death_ef = _death_ef_tb[1]
            enemybase.init(self, 50)
            self._wisys = BossWalkImageSystem(self)
            self._wisys:SetImage("Suika", 3, 4, { 4, 4, 1 }, { 1, 1 }, 8, 16, 16)
            self._wisys:SetFloat(function(ani)
                return 0, sin(ani * 4)
            end)
            self.A = 4
            self.B = 4
            task.New(self, function()
                for _ = 1, 11 do
                    self.hscale = max(0.4, self.hscale - 0.6 / 11)
                    self.vscale = self.hscale
                    self._a = min(255, self._a + 255 / 11)
                    coroutine.yield()
                end
                for i = 29, 0, -1 do
                    object.SetV(self, v * sin(i * 3), a)
                    coroutine.yield()
                end
                local b
                while true do
                    task.Wait(60)
                    b = NewSimpleBullet(sakura, ran:Int(3, 4) * 2,
                            self.x, self.y, ran:Float(0.5, 1), ran:Float(0, 360))
                    b.ag = ran:Float(0.01, 0.02)
                    b.frame_other = function(unit)
                        unit.rot = unit.rot + sin(unit.timer * 3)
                    end

                    PlaySound("tan00")
                    task.MoveToPlayer(80, -150, 150, -150, 150,
                            40, 80, 40, 80, 2, WANDER_MODE.RANDOM)
                end
            end)
            task.New(self, function()
                for i = 1, 60 do
                    self.line = sin(i * 1.5) * 500
                    task.Wait()
                end
                task.Wait(200)
                Create.laser_line(self.x, self.y, 2, 8, self.angle, 50, 8, 16)
                Create.laser_line(self.x, self.y, 2, 8, self.angle + 180, 50, 8, 16)
                object.Del(self)
            end)
        end,
        frame = function(self)
            enemybase.frame(self)
            self.angle = self.angle + (Angle(self, player) - self.angle) * 0.1
            self._wisys:frame()
        end,
        render = function(self)
            self._wisys:render()
            SetImageState("white", "mul+add", 50, unpack(ColorList[1]))
            Render("white", self.x, self.y, self.angle, self.line / 8, 0.125)
            SetImageState("white", "mul+add", 30, unpack(ColorList[1]))
            Render("white", self.x, self.y, self.angle, self.line / 8, 0.5)
        end })
end--other