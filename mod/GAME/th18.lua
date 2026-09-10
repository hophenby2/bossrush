local class = {}
_editor_class.TH18 = class
local cos, sin, abs, min, max, int, tan, sign = cos, sin, abs, min, max, int, tan, sign
local bullet, object, laser, boss = bullet, object, laser, boss
local task, ran, Create, misc, sp = task, ran, Create, misc, sp
local table = table
local GROUP, LAYER = GROUP, LAYER
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
    class.SCBG1 = Class(_SC_BG)
    function class.SCBG1:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th18_2", true, 0, 0, 0,
                0, -0.3, 0, "mul+add", 1, 1)
        b.a = 150
        b = _SC_BG.AddLayer(self, "th18_3", false, 0, 0, 0,
                0, 0, -0.2, "mul+rev", 1.3, 1.3)
        b.a = 60
        b = _SC_BG.AddLayer(self, "th18_3", false, 0, 0, 0,
                0, 0, 0.2, "", 1.3, 1.3)
        b.a = 60

        b = _SC_BG.AddLayer(self, "th18_1", true, 0, 0, 0,
                0, 0.4, 0, "mul+rev")
        b.a = 150
        b.r = 50

        b = _SC_BG.AddLayer(self, "th18_0", false, 0, 0, 0,
                0, 0, -0.2, "", 2.5, 2.5)
        b.r, b.g, b.b = 100, 100, 100



        -- b.a = 150

    end

    class.SCBG2 = Class(_SC_BG)
    function class.SCBG2:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th18_5", true, 0, 0, 0,
                0.2, 0.11, 0, "mul+rev", 1, 1)
        b.a = 75
        b = _SC_BG.AddLayer(self, "th18_2", true, 0, 0, 0,
                0, -0.3, 0, "mul+rev", 1, 1)
        b.a = 150
        b = _SC_BG.AddLayer(self, "th18_3", false, 0, 0, 0,
                0, 0, -0.3, "mul+rev", 1.3, 1.3)
        b.a = 74
        b.g = 60

        b = _SC_BG.AddLayer(self, "th18_4", true, 0, 0, 0,
                0, 0, 0.2, "", 1.3, 1.3)
        b.a = 150
        b = _SC_BG.AddLayer(self, "th18_4", true, 0, 0, 0,
                0, 0, -0.2, "", 1.3, 1.3)



        -- b.a = 150

    end

    class.SCBG3 = Class(_SC_BG)
    function class.SCBG3:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th18_7", true, 0, 120, 0,
                0, 0, 0.2, "", 1, 1)
        b.a = 75
        b = _SC_BG.AddLayer(self, "th18_6", false, -192, 224, 0,
                0, 0, -0.8, "mul+rev", 0.7, 0.7)

        b = _SC_BG.AddLayer(self, "th18_6", false, 192, -224, 0,
                0, 0, -0.3, "mul+rev", 1.3, 1.3)

        b = _SC_BG.AddLayer(self, "th18_7", true, 0, 0, 0,
                0, -0.2, 0, "", 1, 1)




        -- b.a = 150

    end

    class.SCBG4 = Class(_SC_BG)
    function class.SCBG4:init()
        _SC_BG.init(self)
        local b
        local world = lstg.world

        b = _SC_BG.AddLayer(self, "th18_9", true, 0, 0, 0,
                0.3, -0.4, 0, "mul+rev", 1, 1)
        b = _SC_BG.AddLayer(self, "img_void", false, 0, 0, 0, 0, 0.2)
        function b:Beforerender()
            misc.RenderTexInRect("th18_8", -70, 70, world.b, world.t, self.x, self.y, self.rot,
                    self.hscale, self.vscale, self.blend, Color(self.a * self._cur_alpha, 255 * 0.5, 100 * 0.5, 255 * 0.5))
            misc.RenderTexInRect("th18_8", -210, -70, world.b, world.t, self.x, -self.y, self.rot,
                    self.hscale, self.vscale, self.blend, Color(self.a * self._cur_alpha, 100 * 0.5, 255 * 0.5, 255 * 0.5))
            misc.RenderTexInRect("th18_8", 70, 210, world.b, world.t, self.x, -self.y, self.rot,
                    self.hscale, self.vscale, self.blend, Color(self.a * self._cur_alpha, 100 * 0.5, 100 * 0.5, 255 * 0.5))
        end


    end

    class.SCBG5 = Class(_SC_BG)
    function class.SCBG5:init()
        _SC_BG.init(self)
        local b

        b = _SC_BG.AddLayer(self, "th18_10", true, 0, 0, 0,
                0, 0.5, 0, "", 1, 1)
        b.a = 100
        function b:Beforeframe()
            self.r = 155 + cos(self.timer * 0.8) * 100
            self.g = 155 + cos(self.timer * 0.4) * 100
            self.b = 155 + sin(self.timer * 0.2) * 100
        end
        b = _SC_BG.AddLayer(self, "img_void")
        function b:Beforerender()
            _SC_BG.PolarCoordinatesRender("th18_11", 0, 120, 0, 500,
                    180, 512, 1, self.timer / 2, "mul+rev",
                    Color(self._cur_alpha * (100 + sin(self.timer) * 50), 180, 180, 180))
        end
        b = _SC_BG.AddLayer(self, "th18_10", true, 0, 0, 0,
                0, -0.3, 0, "", -1, 1)

        function b:Beforeframe()
            self.r = 155 + cos(self.timer * 0.2) * 100
            self.g = 155 + cos(self.timer * 0.4) * 100
            self.b = 155 + sin(self.timer * 0.8) * 100
        end


    end

    class.SCBG6 = Class(_SC_BG)
    function class.SCBG6:init()
        _SC_BG.init(self)
        local b
        local world = lstg.world
        b = _SC_BG.AddLayer(self, "th18_10", true, 0, 0, 0,
                0, 0.5, 0, "mul+add", 1, 1)
        b.a = 150
        function b:Beforeframe()
            self.r = 155 + cos(self.timer * 0.8) * 100
            self.g = 155 + cos(self.timer * 0.4) * 100
            self.b = 155 + sin(self.timer * 0.2) * 100
        end
        b = _SC_BG.AddLayer(self, "th18_9", true, 0, 0, 0,
                0.3, -0.4, 0, "mul+rev", 1, 1)
        b = _SC_BG.AddLayer(self, "img_void", false, 0, 0, 0, 0, 0.2)

        function b:Beforerender()
            misc.RenderTexInRect("th18_8", -70, 70, world.b, world.t, self.x, self.y, self.rot,
                    self.hscale, self.vscale, self.blend, Color(self.a * self._cur_alpha, 255 * 0.5, 100 * 0.5, 255 * 0.5))
            misc.RenderTexInRect("th18_8", -210, -70, world.b, world.t, self.x, -self.y, self.rot,
                    self.hscale, self.vscale, self.blend, Color(self.a * self._cur_alpha, 100 * 0.5, 255 * 0.5, 255 * 0.5))
            misc.RenderTexInRect("th18_8", 70, 210, world.b, world.t, self.x, -self.y, self.rot,
                    self.hscale, self.vscale, self.blend, Color(self.a * self._cur_alpha, 100 * 0.5, 100 * 0.5, 255 * 0.5))
        end


    end

    class.SCBG7 = Class(_SC_BG)
    function class.SCBG7:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "img_void")
        function b:Beforerender()
            _SC_BG.PolarCoordinatesRender("th18_11", -100, 120, 0, 500,
                    0, 512, 1, self.timer + 256, "mul+add",
                    Color(self._cur_alpha * 70, 180, 180, 180))
            _SC_BG.PolarCoordinatesRender("th18_11", 100, 120, 0, 500,
                    0, 512, 1, self.timer, "mul+rev",
                    Color(self._cur_alpha * 150, 180, 180, 180))
        end
        b = _SC_BG.AddLayer(self, "th18_12", true, 0, 0, 0,
                -0.1, 0.7, 0, "", 1, 1)

        function b:Beforeframe()
            self.r = 155 + cos(self.timer * 0.2) * 100
            self.g = 155 + cos(self.timer * 0.4) * 100
            self.b = 155 + sin(self.timer * 0.8) * 100
        end


    end
end--scbg

do
    boss.Define("1a", "豪德寺三花", "TH18_0", TH18_bg, { -300, 400 }, class.SCBG1, "Mike", 18)
    boss.Define("1b", "山城高岭", "TH18_0", TH18_bg, { 300, 400 }, class.SCBG1, "Takane", 18)

    local name = "金枝「森林中的吉运」"
    local sc1 = boss.card.New(name, 1, 1, 60, 430)
    local sc2 = boss.card.New(name, 1, 1, 60, 830)
    boss.card.add({ { sc1, "1a" }, { sc2, "1b" } }, 18, name, 199)
    function sc1:before()
        task.MoveTo(-130, 50, 59, 2)
        task.Wait()
    end
    function sc2:before()
        task.MoveTo(0, 120, 59, 2)
        task.Wait()
    end
    function sc1:init()
        local n = 19
        local flag
        task.New(self, function()
            boss.violent(self)
            n = 32
            flag = true
        end)
        task.New(self, function()

            local moneylaser = function(x, y, col, v, a, t)
                local self = Create.laser_line(x, y, col, v, a, t, 8, 8, 8)
                self.group = GROUP.ENEMY_BULLET
                task.New(self, function()
                    task.Wait(t)
                    object.ChangingV(self, v, 0, a, 90, false)
                    local L = self.l1 + self.l2 + self.l3
                    local _x, _y = self.x + cos(a) * L, self.y + sin(a) * L
                    Create.bullet_accel(_x, _y, money_big, col, 0.2, 4, a, true, false)
                    for r = 16, L, 16 do
                        _x, _y = self.x + cos(a) * r, self.y + sin(a) * r
                        Create.bullet_accel(_x, _y, money, col, 0.2, 3, Angle(_x, _y, player), true, false)
                    end
                    Del(self)
                end)
            end
            local d = 1
            while true do
                boss.cast(self, 60)
                local A = ran:Float(0, 360)
                for _ = 1, 9 do
                    for a, t in sp.math.AngleIterator(A, n) do
                        Create.bullet_decel(self.x, self.y, ball_mid, t * 2 % 14, 4, 2, a, true, false)
                    end
                    A = A + 13 * d
                    PlaySound("tan00")
                    task.Wait(10)
                end
                Newcharge_in(self.x, self.y, 250, 128, 114)
                task.Wait(60)
                for c = -7, 7 do
                    moneylaser(self.x, self.y, c % 2 * 2 + 14, 4 + c % 2, 90 - 90 * d + c * 13, 25)
                end
                d = -d
                task.Wait(90)
                task.MoveTo(-self.x, self.y, 75, 2)
                if flag then
                    for c = -7, 7 do
                        moneylaser(self.x, self.y, c % 2 * 2 + 14, 4 + c % 2, 90 - 90 * d + c * 13, 25)
                    end
                end
                task.Wait(100)
            end


        end)
    end
    function sc2:init()
        local flag
        local first_flag
        task.New(self, function()
            boss.violent(self)
            flag = true
            first_flag = true
            task.Wait(60)
            local A = ran:Float(0, 360)
            while true do
                for a in sp.math.AngleIterator(A, 9) do
                    Create.bullet_decel(self.x, self.y, ball_big, 10, 3, 1.7, a, false, false)
                end
                A = A + 27
                PlaySound("tan00")
                task.Wait(10)
            end
        end)
        task.New(self, function()
            local d = 1
            while true do
                boss.cast(self, 60)
                if first_flag then
                    first_flag = false
                end
                for z = -3, 3 do
                    NewSimpleServant(self.x, self.y, 0, 189, 252, 201, 1.5, function(self)

                        task.New(self, function()
                            self:FadeIn(15)
                            object.ChangingSizeColli(self, -0.5, -0.5, 15)
                        end)
                        task.New(self, function()
                            task.BezierMoveTo(180 - z * 10, 1, -450 * d, 60 + z * 50, 250 * d, -80 + z * 30)
                            Del(self)
                        end)
                        task.New(self, function()
                            task.Wait(100 - z * 10)
                            for k = 1, 45 do
                                if k % 5 == 3 then
                                    local A = -90
                                    local V = 1.4 - z * 0.1
                                    sakura_big.New(self.x, self.y, ran:Float(0, 360), ran:Sign() * ran:Float(1, 2), 0.1, A, function(unit)
                                        local _A = A
                                        local _V = V
                                        bullet.ChangeImage(unit, diamond, 10)
                                        task.New(unit, function()
                                            task.Wait(60)
                                            for i = 1, 120 do
                                                local v = 0.1 + i / 120 * (_V - 0.1)
                                                unit.mvx = v * cos(_A)
                                                unit.mvy = v * sin(_A)
                                                task.Wait()
                                            end
                                        end)
                                    end)
                                end
                                local A = Angle(0, 0, self.dx, self.dy)
                                local b = NewSimpleBullet(grain_a, 10, self.x, self.y, 0.3, A)
                                b._blend = "mul+add"
                                task.New(b, function()
                                    task.Wait(90)
                                    Del(b)
                                end)
                                PlaySound("tan00")
                                task.Wait(2)
                            end
                        end)
                    end)
                end
                for _ = 1, 290 do
                    if first_flag then
                        first_flag = false
                        break
                    end
                    task.Wait()
                end
                local A = ran:Float(0, 360)
                if not flag then
                    for _ = 1, 9 do
                        for a in sp.math.AngleIterator(A, 9) do
                            Create.bullet_decel(self.x, self.y, ball_big, 10, 3, 1.7, a, false, false)
                        end
                        A = A + 27 * d
                        PlaySound("tan00")
                        task.Wait(10)
                    end
                else
                    task.Wait(25)
                end
                task.Wait(35)
                d = -d
            end
        end)
    end
end--boss1

do
    boss.Define("2a", "山城高岭", "TH18_0", TH18_bg, { -300, 400 }, class.SCBG2, "Takane", 18)
    boss.Define("2b", "驹草山如", "TH18_0", TH18_bg, { 300, 400 }, class.SCBG2, "Sannyo", 18)

    local name = "幻森「深间乌羽玉」"
    local sc1 = boss.card.New(name, 1, 1, 60, 450)
    local sc2 = boss.card.New(name, 1, 1, 60, 450)
    boss.card.add({ { sc1, "2a" }, { sc2, "2b" } }, 18, name, 200)
    function sc1:before()
        task.MoveTo(-70, 70, 60, 2)
    end
    function sc2:before()
        task.MoveTo(70, 140, 60, 2)
    end
    function sc1:init()
        local n = 10
        task.New(self, function()
            boss.violent(self)
            n = 18
            task.Wait(60)
            while true do
                for a in sp.math.AngleIterator(Angle(self, player), 19) do
                    Create.bullet_decel(self.x, self.y, ball_huge, 8, 4, 2, a, true, false)
                end
                PlaySound("tan00")
                task.Wait(75)
            end
        end)
        task.New(self, function()
            local s = 180
            while true do
                self.x = cos(s) * 70
                s = s + 1
                task.Wait()
            end
        end)
        task.New(self, function()
            local delusion = function(x, y, v, a, indelu)
                local self = NewObject(bullet)
                bullet.init(self, grain_a, 10 + (indelu and 2 or 0), false, true)
                self.x, self.y = x, y
                object.SetV(self, v, a, true)
                task.New(self, function()
                    task.Wait(60)
                    object.ChangingV(self, v, v * 0.5, a, 120, true)
                end)
                task.New(self, function()
                    while true do
                        local flag
                        for _, o in ObjList(GROUP.INDES) do
                            if o.issmoke then
                                if Dist(o, self) < o.radius then
                                    flag = true
                                    break
                                end
                            end
                        end
                        if indelu then
                            self.__a = flag and 255 or 5
                        else
                            self.__a = flag and 5 or 255
                        end
                        self._a = self._a + (-self._a + self.__a) * 0.2
                        self.colli = self._a > 200
                        task.Wait()
                    end
                end)
            end
            local r = ran:Float(0, 360)
            local j = 1
            while true do
                for a, k in sp.math.AngleIterator(r, n) do
                    delusion(self.x, self.y, 1.8, a, k % 2 == 1)
                end
                r = r + 20 * ((j % 64 <= 31) and 1 or -1)
                j = j + 1
                task.Wait(5)
            end
        end)
    end
    function sc2:init()
        local interval = 42
        task.New(self, function()
            boss.violent(self)
            interval = 21
            task.Wait(60)
            while true do
                for a in sp.math.AngleIterator(Angle(self, player), 19) do
                    Create.bullet_decel(self.x, self.y, ball_huge, 2, 2, 3, a, true, false)
                end
                PlaySound("tan00")
                task.Wait(75)
            end
        end)
        task.New(self, function()
            local s = 0
            while true do
                self.x = cos(s) * 70
                s = s + 1
                task.Wait()
            end
        end)
        task.New(self, function()
            local center = function(x, y, v, a, bn, maxr, is, ds)
                local self = NewObject(Class(object, {
                    frame = function(self)
                        task.Do(self)
                        is = is + ds
                        self.radius = abs(maxr * sin(is))
                        if Dist(self, 0, 0) > 350 then
                            Del(self)
                        end
                    end }, true))
                self.group = GROUP.INDES
                self.colli = false
                self.bound = false
                self.x, self.y = x, y
                self.radius = maxr * sin(is)
                self.issmoke = true
                object.SetV(self, v, a)
                local rotate = ran:Sign() * ran:Float(0.6, 1.3)
                local R = self.radius
                for _a in sp.math.AngleIterator(ran:Float(0, 360), bn) do
                    local b = NewSimpleBullet(ball_mid, 15, self.x + cos(_a) * R, self.y + sin(_a) * R, 0, 0)
                    b.master = self
                    b.angle = _a
                    b.bound = false
                    b.stay = false
                    b._blend = "mul+add"
                    function b:frame_other()
                        if IsValid(self.master) then
                            self.angle = self.angle + rotate
                            self.x = self.master.x + cos(self.angle) * self.master.radius
                            self.y = self.master.y + sin(self.angle) * self.master.radius
                        else
                            Del(self)
                        end
                    end
                end
            end
            local r = ran:Float(0, 360)
            while true do
                for a in sp.math.AngleIterator(r, 3) do
                    center(self.x, self.y, 1.5, a, 20, 70, -r, 0.65)
                end
                PlaySound("kira00")
                r = r + 37
                task.Wait(interval)
            end
        end)
    end

end--boss2

do
    boss.Define("3a", "菅牧典", "TH18_0", TH18_bg, { -400, 0 }, class.SCBG2, "Tsukasa", 18)

    local sc1 = boss.card.New("", 1, 2, 45, 600)
    boss.card.add({ { sc1, "3a" } }, 18, "非符", 201)
    function sc1:before()
        task.MoveTo(0, 120, 60, 2)
    end
    function sc1:init()
        task.New(self, function()
            while true do
                Newcharge_in(self.x, self.y, 250, 128, 114)
                for d = -1, 1, 2 do
                    NewSimpleServant(self.x, self.y, 0, 250, 128, 114, 1.5, function(unit)
                        task.New(unit, function()
                            unit:FadeIn(15)
                            object.ChangingSizeColli(unit, -0.5, -0.5, 15)
                        end)
                        task.New(unit, function()
                            local A = Angle(unit, d * 75, 50)
                            task.MoveTo(d * 75, 50, 60, 2)
                            task.Wait(90)
                            object.ChangingV(unit, 0, 5, A, 100, false)
                        end)
                        task.New(unit, function()
                            task.Wait(60)
                            local r = -90
                            while true do
                                for a in sp.math.AngleIterator(r, 14) do
                                    Create.bullet_decel(unit.x, unit.y, arrow_small, 2,
                                            5, 2.3, a, false, false)
                                end
                                r = r - d * 2
                                PlaySound("tan00")
                                task.Wait(10)
                            end
                        end)
                    end)
                end
                task.Wait(60)
                task.Wait(20)
                for _ = 1, 6 do
                    local x, y = self.x + ran:Float(-30, 30), self.y + ran:Float(-30, 30)
                    for a in sp.math.AngleIterator(Angle(x, y, player), 22) do
                        for v = 0, 1 do
                            Create.bullet_decel(x, y, arrow_small, 14, 4, 2 + v * 0.1, a, false, false)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(10)
                end
                task.Wait(60)
                task.New(self, function()
                    for v = 1, 5 do
                        local x, y = self.x + ran:Float(-30, 30), self.y + ran:Float(-30, 30)
                        for a in sp.math.AngleIterator(ran:Float(0, 360), 22) do

                            Create.bullet_decel(x, y, ball_huge, 2, 4, 2.3 - v * 0.2, a, false, false)
                        end
                        PlaySound("tan00")
                        task.Wait(20)
                    end
                end)
                task.Wait(40)
                task.MoveToPlayer(60, -96, 96, 100, 144,
                        20, 40, 10, 20, 2, 1)
            end
        end)
    end
    boss.card.addRunEvent("3a", 18, function(self)
        boss.show_aura(self, false)
        task.Wait(30)
        task.MoveTo(300, 0, 45, 1)
    end)
end--boss3菅牧典的各种管事

do
    boss.Define("4a", "玉造魅须丸", "TH18_0", TH18_bg, { 300, 400 }, class.SCBG3, "Misumaru", 18)
    local non_sc = boss.card.New("", 1, 1, 45, 555)
    boss.card.add({ { non_sc, "4a" } }, 18, "非符", 202)
    function non_sc:before()
        task.MoveTo(0, 120, 60, 2)
    end
    function non_sc:init()
        local function NewYinYangYu(x, y, event)
            NewSimpleServant(x, y, 0, 255, 255, 255, 1.5, function(unit)
                unit.omiga = ran:Sign() * ran:Float(3, 4)
                unit.open_smear = true
                unit.smear_maxalpha = 80
                unit.smear_dealpha = 10
                unit.img = "TPyyy"
                unit.a, unit.b = 20, 20
                unit.colli = true
                unit.group = GROUP.ENEMY_BULLET
                unit.IsYinYangYu = true
                task.New(unit, function()
                    unit:FadeIn(15)
                    object.ChangingSizeColli(unit, -0.5, -0.5, 15)
                end)
                if event then
                    event(unit)
                end
            end)
        end
        task.New(self, function()
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            task.New(self, function()
                local d = 1
                while true do
                    for _, vx, vy in sp.math.PolygonIterator2(45, 20, 0, 0, 3.5, 4) do
                        NewYinYangYu(self.x, self.y, function(self)
                            local D = d
                            self.vx, self.vy = vx, vy
                            task.New(self, function()
                                local v, a = GetV(self)
                                for _ = 1, 180 do
                                    object.SetV(self, v, a)
                                    a = a + D * 0.6
                                    task.Wait()
                                end
                            end)
                        end)
                    end
                    PlaySound("kira00")
                    d = -d
                    task.Wait(45)
                end
            end)
            task.Wait(60)
            local d = 1
            while true do
                local A = Angle(self, player)

                for v = 1, 10 do
                    for a in sp.math.AngleIterator(A + d * v, 18 + v) do
                        Create.bullet_decel(self.x + cos(a) * 32, self.y + sin(a) * 32, arrow_big, 4, 5 - v * 0.1, 3 - v * 0.1, a)
                    end
                    PlaySound("tan00")
                    task.Wait(3)
                end
                d = -d
                task.Wait(30)
                task.MoveToPlayer(60, -96, 96, 100, 144,
                        20, 40, 10, 20, 2, 1)
            end

        end)
    end
    local name = "玉将「阴阳青鬼赤鬼」"
    local sc1 = boss.card.New(name, 1, 2, 45, 850)
    boss.card.add({ { sc1, "4a" } }, 18, name, 203)
    function sc1:before()
        if ext.sc_pr then
            task.MoveTo(0, 120, 60, 2)
        else
            task.Wait(60)
        end
    end
    function sc1:init()
        local function NewYinYangYuServant(x, y, event)
            NewSimpleServant(x, y, 0, 255, 255, 255, 1.5, function(unit)
                unit.omiga = ran:Sign() * ran:Float(3, 4)
                unit.open_smear = true
                unit.smear_maxalpha = 80
                unit.smear_dealpha = 10
                unit.img = "TPyyy"
                unit.a, unit.b = 22, 22
                unit.colli = true
                unit.group = GROUP.INDES
                unit.IsYinYangYu = true
                task.New(unit, function()
                    unit:FadeIn(15)
                    object.ChangingSizeColli(unit, -0.5, -0.5, 15)
                end)
                if event then
                    event(unit)
                end
            end)
        end
        task.New(self, function()
            Newcharge_in(0, 100, 250, 128, 114)
            task.MoveTo(0, 100, 60, 2)
            task.Wait()
            boss.cast(self, 33333)
            NewYinYangYuServant(self.x, self.y, function(self)
                self._blend = "mul+rev"
                task.New(self, function()
                    task.MoveTo(-192, 100, 60, 2)
                    local t = 0
                    local s = 0
                    while true do
                        self.y = 100 + sin(3 * t * sin(min(s, 90))) * 50
                        self.x = -192 * cos(t)
                        t = t + 0.6

                        s = s + 1
                        task.Wait()
                    end
                end)
                task.New(self, function()
                    task.Wait(60)
                    local rot = 90
                    while true do
                        Create.laser_line(self.x, self.y, 6, 3, 90, 75, 8, 8, 8)
                        for z = -2, 2 do
                            Create.bullet_accel(self.x, self.y, grain_a, 6, 0.5, 2, rot + z * 15, false, false)
                        end
                        rot = rot - 9.6
                        task.Wait(8)
                    end
                end)
            end)
            NewYinYangYuServant(self.x, self.y, function(self)
                task.New(self, function()
                    task.MoveTo(-192, -100, 60, 2)
                    local t = 0
                    local s = 0
                    while true do
                        self.y = -100 + sin(3 * t * sin(min(s, 90))) * 50
                        self.x = -192 * cos(t)
                        t = t + 0.6
                        s = s + 1
                        task.Wait()
                    end
                end)
                task.New(self, function()
                    task.Wait(60)
                    local rot = 90
                    while true do
                        Create.laser_line(self.x, self.y, 2, 3, -90, 75, 8, 8, 8)
                        for z = -2, 2 do
                            Create.bullet_accel(self.x, self.y, grain_a, 2, 0.5, 2, rot + z * 15, false, false)
                        end
                        rot = rot + 9.6
                        task.Wait(8)
                    end
                end)
            end)
            task.Wait(60)
            while true do
                for a in sp.math.AngleIterator(Angle(self, player), 25) do
                    Create.bullet_accel(self.x, self.y, square, 10, 0.5, 1.5, a, true, false)
                end
                PlaySound("tan00")
                task.Wait(95)
            end
        end)
    end
end--boss4

do
    boss.Define("5a", "菅牧典", "TH18_0", TH18_bg, { 400, 0 }, class.SCBG4, "Tsukasa", 18)
    boss.Define("5b", "饭纲丸龙", "TH18_0", TH18_bg, { -400, 0 }, class.SCBG4, "Megumu", 18)
    local name = "星狐「吸血鬼恒星」"
    local sc1 = boss.card.New(name, 1, 1, 60, 460)
    local sc2 = boss.card.New(name, 1, 1, 60, 900)
    boss.card.add({ { sc1, "5a" }, { sc2, "5b" } }, 18, name, 204)
    function sc1:before()
        task.MoveTo(90, 90, 60, 2)
    end
    function sc2:before()
        task.MoveTo(0, 120, 60, 2)
    end
    function sc1:init()

        task.New(self, function()
            boss.violent(self)
            task.Wait(60)
            task.Clear(self, true)
            task.New(self, function()
                task.Wait(60)
                while true do
                    task.MoveTo(-self.x, self.y, 60, 2)
                    task.Wait(100)
                end
            end)
            local d = 1
            while true do
                for a in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                    Create.bullet_dec_setangle(self.x, self.y, arrow_small, 2, false,
                            { v = 3, a = a, time = 60 }, { func = function(self)
                                object.ChangingV(self, 0, 2.5, Angle(self, player), 90)
                            end })
                    Create.bullet_dec_setangle(self.x, self.y, arrow_small, 4, false,
                            { v = 3, a = a, time = 90 }, { v = 2.5, a = a + d * 30 })
                end
                d = -d
                task.Wait(30)
            end
        end)
        task.New(self, function()
            while true do
                for k = 1, 3 do
                    local c = (k - 1) / 2
                    for z = -c, c do
                        for a in sp.math.AngleIterator(ran:Float(0, 360), 25) do
                            Create.bullet_dec_setangle(self.x, self.y, arrow_small, 2, false,
                                    { v = 3, a = a, time = 60 }, { func = function(self)
                                        object.ChangingV(self, 0, 2.5, Angle(self, player) + z * 29, 90)
                                    end })
                        end
                    end
                    task.Wait(60)
                end
                Newcharge_in(self.x, self.y, 250, 128, 114)
                task.Wait(60)
                Newcharge_out(self.x, self.y, 250, 128, 114)
                for i = 1, 120 do
                    i = task.SetMode[2](i / 120 * 2)
                    object.BulletDo(function(b)
                        if b.star then

                            local A = Angle(b, self)
                            b.x = b.x + cos(A) * i * 3
                            b.y = b.y + sin(A) * i * 3
                        end
                    end)
                    task.Wait()
                end
                object.BulletDo(function(b)
                    if b.star then
                        b.star = false
                    end
                end)
                task.MoveTo(-self.x, self.y, 60, 2)
                task.Wait(30)
            end
        end)
    end
    function sc2:init()
        local wait = 120
        local n = 20
        task.New(self, function()
            boss.violent(self)
            wait = 10
            n = 30
        end)
        task.New(self, function()
            local d = -1
            while true do
                for p = 1, 2 do
                    for _ = 1, 15 do
                        for a in sp.math.AngleIterator(0, n) do
                            local b = Create.bullet_changeangle(self.x, self.y, star_small, 10 + p * 2, 3, a, false,
                                    { r = 3 * d, time = 60 }, { r = 1 * d, time = 15 },
                                    { r = d * ((p == 2) and -3 or -ran:Float(2.5, 3)), time = 60, v = (p == 2) and 1.5 or ran:Float(1, 1.5) })
                            b.omiga = ran:Float(2, 3)
                            b.star = true
                        end
                        PlaySound("tan00")
                        task.Wait(6)
                    end
                    task.Wait(wait)
                end
                d = -d
                task.Wait(30)
            end
        end)
    end
end--boss5菅牧典的各种管事

do
    boss.Define("6a", "天弓千亦", "TH18_1", TH18_bg2, { 400, 0 }, class.SCBG5, "Chimata", 18)
    local name = "「强买强卖的市场」"
    local sc = boss.card.New(name, 1, 3, 45, 999)
    boss.card.add({ { sc, "6a" } }, 18, name, 205)
    function sc:before()
        boss.show_aura(self, false)
        PlaySound("ch02")
        New(boss_cast_darkball, 0, 120, 60, 80, 360, 1, 270, 64, 64, 255, 2)
        New(boss_cast_darkball, 0, 120, 60, 80, 360, 1, 270, 255, 64, 64, -2)
        task.Wait(90)
        self.x, self.y = 0, 120
        boss.show_aura(self, true)
        task.Wait(60)
    end
    function sc:init()
        boss.card.UnlockOD(self, 19)
        task.New(self, function()
            local lock = function(x, y, v, a, t)
                local unit = NewObject(bullet)
                bullet.init(unit, ball_big, 8, false, true)
                unit.x, unit.y = x, y
                unit.bound = false
                task.New(unit, function()
                    object.ChangingV(unit, v, 0, a, t, false)
                    PlaySound("kira00")
                    bullet.ChangeImage(unit, unit.imgclass, 4)
                    Create.bullet_create_eff(unit)
                    local dx, dy = player.x - self.x, player.y - self.y
                    task.MoveToEx(dx, dy, t * 2, 3)
                    unit.bound = true
                    object.ChangingV(unit, 0, v, a, t, false)
                end)
            end
            for a in sp.math.AngleIterator(ran:Float(0, 360), 12) do
                for v = 1, 6 do
                    lock(self.x, self.y, 1.5 + v * 0.8, a, 60)
                end
            end
            task.Wait(60)
            do
                local x, y = player.x, player.y
                local r, g, b = 218, 112, 214
                NewBon(x, y, 60, 128, r, g, b)
                NewWave(x, y, 2, 128, 60, r, g, b)
            end
            task.Wait(120)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            local d = 1
            while true do
                task.New(self, function()
                    task.MoveToPlayer(80, -96, 96, 100, 144,
                            40, 50, 20, 30, 3, 1)
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 12) do
                        for v = 1, 6 do
                            lock(self.x, self.y, 1.5 + v * 0.8, a - v * 3 * d, 60)
                        end
                    end
                    task.Wait(60)
                    local x, y = player.x, player.y
                    local r, g, b = 218, 112, 214
                    NewBon(x, y, 60, 128, r, g, b)
                    NewWave(x, y, 2, 128, 60, r, g, b)
                end)
                local rot = ran:Float(0, 360)
                for c = 1, 25 do
                    for a in sp.math.AngleIterator(rot, 9) do
                        Create.bullet_decel(self.x, self.y, square, 10,
                                4.5 + c / 25, 2 - c / 25, a, false, false)
                    end
                    PlaySound("tan00")
                    rot = rot + 35 * d
                    task.Wait(5)
                end
                d = -d
                task.Wait(120)
            end
        end)
    end

    name = "「强迫交易理当立罪-Overdrive」"
    local sc_od = boss.card.New(name, 1, 3, 45, 999)
    boss.card.add({ { sc_od, "6a" } }, 18, name, 211, 19)
    function sc_od:before()
        boss.show_aura(self, false)
        PlaySound("ch02")
        New(boss_cast_darkball, 0, 120, 60, 80, 360, 1, 270, 64, 64, 255, 2)
        New(boss_cast_darkball, 0, 120, 60, 80, 360, 1, 270, 255, 64, 64, -2)
        task.Wait(90)
        self.x, self.y = 0, 120
        boss.show_aura(self, true)
        task.Wait(60)
    end
    function sc_od:init()
        task.New(self, function()
            local lock = function(x, y, v, a, t)
                local unit = NewObject(bullet)
                bullet.init(unit, ball_big, 8, false, true)
                unit.x, unit.y = x, y
                unit.bound = false
                task.New(unit, function()
                    object.ChangingV(unit, v, 0, a, t, false)
                    PlaySound("kira00")
                    bullet.ChangeImage(unit, unit.imgclass, 2)
                    Create.bullet_create_eff(unit)
                    local dx, dy = player.x - self.x, player.y - self.y
                    task.MoveToEx(dx, dy, t * 2, 3)

                    object.ChangingV(unit, 0, -v, a, t * 2, false)
                    unit.bound = true
                end)
            end
            for a in sp.math.AngleIterator(ran:Float(0, 360), 10) do
                for v = 1, 6 do
                    lock(self.x, self.y, 1.5 + v * 0.8, a, 60)
                end
            end
            task.Wait(60)
            do
                local x, y = player.x, player.y
                local r, g, b = 250, 128, 114
                NewBon(x, y, 60, 128, r, g, b)
                NewWave(x, y, 2, 128, 60, r, g, b)
            end
            task.Wait(120)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            local d = 1
            while true do
                task.New(self, function()
                    task.MoveToPlayer(80, -96, 96, 100, 144,
                            40, 50, 20, 30, 3, 1)
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 10) do
                        for v = 1, 6 do
                            lock(self.x, self.y, 1.5 + v * 0.8, a, 60)
                        end
                    end
                    task.Wait(60)
                    local x, y = player.x, player.y
                    local r, g, b = 250, 128, 114
                    NewBon(x, y, 60, 128, r, g, b)
                    NewWave(x, y, 2, 128, 60, r, g, b)
                end)
                local rot = ran:Float(0, 360)
                for c = 1, 25 do
                    for a in sp.math.AngleIterator(rot, 8) do
                        Create.bullet_decel(self.x, self.y, square, 10,
                                4.5 + c / 25, 2 - c / 25, a, false, false)
                    end
                    PlaySound("tan00")
                    rot = rot + 35 * d
                    task.Wait(5)
                end
                d = -d
                task.Wait(120)
            end
        end)
    end
end--boss6

do
    boss.Define("7a", "菅牧典", "TH18_1", TH18_bg2, { -200, 400 }, class.SCBG5, "Tsukasa", 18)
    boss.Define("7b", "天弓千亦", "TH18_1", TH18_bg2, { 200, 400 }, class.SCBG5, "Chimata", 18)
    local name = "「市场消费欺诈主义」"
    local sc1 = boss.card.New(name, 1, 1, 60, 1666)
    local sc2 = boss.card.New(name, 1, 1, 60, 1666)
    boss.card.add({ { sc1, "7a" }, { sc2, "7b" } }, 18, name, 206)
    function sc1:before()
        task.MoveTo(0, -125, 60, 2)
    end
    function sc2:before()
        task.MoveTo(0, 0, 60, 2)
    end
    function sc1:init()
        task.New(self, function()
            self.__draw_sc_ring = false
            boss.show_aura(self, false)
            while true do
                self.DMG_factor = 1
                task.Wait(30)
                for i = 1, 30 do
                    object.SetSize(self, 1 - i / 30)
                    task.Wait()
                end
                local inball
                for _, b in ObjList(GROUP.INDES) do
                    if b.hideball and b.id == 0 then
                        inball = b
                        b.tsukasa = true
                        break
                    end
                end
                for _ = 1, 240 do
                    if IsValid(inball) then
                        self.x, self.y = inball.x, inball.y
                    end
                    task.Wait()
                end
                task.Wait(60 + 60)
                Newcharge_out(self.x, self.y, 250, 128, 114)
                task.New(self, function()
                    for i = 1, 30 do
                        object.SetSize(self, i / 30)
                        task.Wait()
                    end
                end)
                object.IndesDo(function(b)
                    if b.hideball then
                        Del(b)
                    end
                end)
                object.BulletDo(function(b)
                    if b.square then
                        b.jump = true
                        object.ChangeVwithTask(b, 0, 4,
                                Angle(b, self) + ran:Float(-9, 9), 150)
                    end
                end)
                self.DMG_factor = 0.5
                task.Wait(40 * 2 + 60)
            end
        end)
    end
    function sc2:init()
        task.New(self, function()
            local hideball = function(cx, cy, r, ia, da, t, id)
                local self = NewObject(Class(bullet, {
                    frame = function(self)
                        bullet.frame(self)
                        self.x, self.y = cx + cos(ia) * r, cy + sin(ia) * r
                        if Dist(self, 0, 0) > 350 then
                            Del(self)
                        end
                    end }, true))
                bullet.init(self, ball_huge, 8, false, false)
                self.id = id
                self.hideball = true
                self.group = GROUP.INDES
                self.bound = false
                self.x, self.y = cx + cos(ia) * r, cy + sin(ia) * r
                for _a in sp.math.AngleIterator(ran:Float(0, 360), 16) do
                    local b = NewSimpleBullet(square, 2, self.x + cos(_a) * 35, self.y + sin(_a) * 35, 0, 0)
                    b.master = self
                    b.rot = _a
                    b.stay = false
                    b.square = true
                    function b:frame_other()
                        if IsValid(self.master) and not self.jump then
                            self.x = self.master.x + cos(self.rot) * 40
                            self.y = self.master.y + sin(self.rot) * 40
                        end
                    end
                end
                task.New(self, function()
                    task.Wait(60)
                    local slast = 0
                    for i = 1, t do
                        i = task.SetMode[3](i / t)
                        ia = ia + da * (i - slast)
                        slast = i
                        task.Wait()
                    end
                end)

            end
            local d = 1
            local dr = -90
            while true do
                self.DMG_factor = 1
                local R = ran:Float(-36, 36)

                local offset = ran:Int(-1, 1)
                for z = -2, 2 do
                    hideball(self.x, self.y, 125, dr + z * 45, R + 360 * (z % 2 * 2 - 1) + 360 / 5 * (z + offset) - z * 45, 240, z)
                end
                task.Wait(60)
                local rot = ran:Float(0, 360)
                for k = 1, 20 do
                    for a in sp.math.AngleIterator(rot, 5 + k % 2 * 5) do
                        Create.bullet_decel(self.x, self.y, arrow_big, 10 + k % 2 * 2, 4, 2.2 - k / 60, a)
                    end
                    PlaySound("tan00")
                    rot = rot + 52 * d
                    task.Wait(8)
                end
                task.Wait(80)
                task.Wait(60)
                Newcharge_in(self.x, self.y, 250, 128, 114)
                task.Wait(60)
                self.DMG_factor = 0.5
                misc.ShakeScreen(60, 2)
                for _ = 1, 40 do
                    for a in sp.math.AngleIterator(dr + R - 36, 5) do
                        local b = NewSimpleBullet(ball_light, ran:Int(1, 7) * 2, self.x, self.y,
                                ran:Float(1.8, 2.3), a + ran:Float(-30, 30))
                        --b.timer = 11
                        b.stay = false
                        b.ax = 0.11 * cos(a)
                        b.ay = 0.11 * sin(a)
                        b.maxv = ran:Float(9, 11)
                        b.hscale, b.vscale = 0.2, 0.2
                        b.a, b.b = 0, 0
                        b.frame_other = function(self)
                            self.hscale = self.hscale + 0.04
                            self.vscale = self.hscale
                            self.a = self.hscale * 11.5
                            self.b = self.a
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(2)
                end
                task.Wait(60)
                dr = dr + R + offset * 360 / 5
                d = -d
            end

        end)
    end
    sc1.frame = boss.card.PublicHP
    sc2.frame = boss.card.PublicHP
end--boss7菅牧典的各种管事

do
    boss.Define("8a", "饭纲丸龙", "TH18_1", TH18_bg2, { -100, 400 }, class.SCBG6, "Megumu", 18)
    boss.Define("8b", "天弓千亦", "TH18_1", TH18_bg2, { 100, 400 }, class.SCBG6, "Chimata", 18)
    local Chimata
    local name = "「精神控制的营销手段」"
    local sc1 = boss.card.New(name, 1, 1, 60, 1350)
    local sc2 = boss.card.New(name, 1, 1, 60, 1350)
    boss.card.add({ { sc1, "8a" }, { sc2, "8b" } }, 18, name, 207)
    function sc1:before()

        task.MoveTo(0, 120, 60, 2)
    end
    function sc2:before()
        Chimata = self
        task.MoveTo(0, 40, 60, 2)
    end
    function sc1:init()
        task.New(self, function()
            local polar = function(x, y, center, col, a, v, o)
                local self = NewObject(bullet)
                bullet.init(self, ellipse, col, false, true)
                self.x, self.y = x, y
                self.bound = false

                local cx, cy = x, y
                PlaySound("tan00")
                task.New(self, function()
                    task.Wait(300)
                    Del(self)
                end)
                task.New(self, function()
                    for i = 1, 60 do
                        i = task.SetMode[3](i / 60)
                        if IsValid(center) then
                            cx = x + (-x + center.x) * i
                            cy = y + (-y + center.y) * i
                        end
                        task.Wait()
                    end
                    while true do
                        if IsValid(center) then
                            cx = center.x
                            cy = center.y
                        end
                        task.Wait()
                    end
                end)
                task.New(self, function()
                    local l = 0
                    while true do
                        self.rot = a
                        self.x = cx + cos(a) * l
                        self.y = cy + sin(a) * l
                        a = a + o
                        l = l + v
                        task.Wait()
                    end
                end)
            end
            local d = 1
            while true do
                local rot = ran:Float(0, 360)
                for _ = 1, 3 do
                    for a in sp.math.AngleIterator(rot, 20) do
                        polar(self.x, self.y, self, 14, a, 2, 0.3 * d)
                    end
                    task.Wait(10)
                end
                task.Wait(20)
                for k = 1, 6 do
                    for a in sp.math.AngleIterator(rot, 20) do
                        polar(self.x, self.y, Chimata, 10, a, 2.3 - k * 0.13, 0)
                    end
                    task.Wait(5)
                end
                d = -d
                task.Wait(35)
            end
        end)
    end
    function sc2:init()
        self._transport = New(Class(object, {
            frame = task.Do,
            init = function(self)
                self.group = GROUP.GHOST
                task.New(self, function()
                    while not self.finish do
                        task.Wait()
                    end
                    if self.getcard then
                        ext.achievement:get(151)
                        scoredata["UnlockSC"][20] = true
                    end
                    object.RawDel(self)
                end)
            end }, true))
        task.New(self, function()
            task.Wait(120)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            local s, t = 0, 0
            while true do
                if self.timer % 115 == 30 then
                    for a in sp.math.AngleIterator(Angle(self, player), 10) do
                        Create.bullet_decel(self.x, self.y, ball_huge, 6, 4, 2, a, true, false)
                    end
                    PlaySound("tan00")
                end
                self.x = sin(s) * 132
                s = s + sin(t) * 0.6
                t = min(t + 1, 90)
                task.Wait()
            end
        end)
    end
    sc1.frame = boss.card.PublicHP
    sc2.frame = boss.card.PublicHP

    name = "「盈利颇丰的中间商-Overdrive」"
    local sc_od1 = boss.card.New(name, 1, 1, 60, 1100)
    local sc_od2 = boss.card.New(name, 1, 1, 60, 1100)
    boss.card.add({ { sc_od1, "8a" }, { sc_od2, "8b" } }, 18, name, 212, 20)
    function sc_od1:before()

        task.MoveTo(0, 120, 60, 2)
    end
    function sc_od2:before()
        Chimata = self
        task.MoveTo(0, 40, 60, 2)
    end
    function sc_od1:init()
        task.New(self, function()
            local polar = function(x, y, center, col, a, v, o)
                local self = NewObject(bullet)
                bullet.init(self, ellipse, col, false, true)
                self.x, self.y = x, y
                self.bound = false

                local cx, cy = x, y
                PlaySound("tan00")
                task.New(self, function()
                    task.Wait(300)
                    Del(self)
                end)
                task.New(self, function()
                    for i = 1, 60 do
                        i = task.SetMode[3](i / 60)
                        if IsValid(center) then
                            cx = x + (-x + center.x) * i
                            cy = y + (-y + center.y) * i
                        end
                        task.Wait()
                    end
                    while true do
                        if IsValid(center) then
                            cx = center.x
                            cy = center.y
                        end
                        task.Wait()
                    end
                end)
                task.New(self, function()
                    local l = 0
                    while true do
                        self.rot = a
                        self.x = cx + cos(a) * l
                        self.y = cy + sin(a) * l
                        a = a + o
                        l = l + v
                        task.Wait()
                    end
                end)
            end
            local d = 1
            while true do
                local rot = ran:Float(0, 360)
                for _ = 1, 3 do
                    for a in sp.math.AngleIterator(rot, 25) do
                        polar(self.x, self.y, Chimata, 6, a, 2, 0.41 * d)
                    end
                    task.Wait(10)
                end
                task.Wait(20)
                for k = 1, 6 do
                    for a in sp.math.AngleIterator(rot, 25) do
                        polar(self.x, self.y, self, 2, a, 2.5 - k * 0.16, 0)
                    end
                    task.Wait(5)
                end
                d = -d
                task.Wait(35)
            end
        end)
    end
    function sc_od2:init()
        self._transport = New(Class(object, {
            frame = task.Do,
            init = function(self)
                self.group = GROUP.GHOST
                task.New(self, function()
                    while not self.finish do
                        task.Wait()
                    end
                    if self.getcard then
                        ext.achievement:get(151)

                    end
                    object.RawDel(self)
                end)
            end }, true))
        task.New(self, function()
            task.Wait(120)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            local s, t = 0, 0
            while true do
                if self.timer % 115 == 30 then
                    for a in sp.math.AngleIterator(Angle(self, player), 10) do
                        Create.bullet_decel(self.x, self.y, ball_huge, 8, 4, 2, a, true, false)
                    end
                    PlaySound("tan00")
                end
                self.x = sin(s) * 132
                s = s + sin(t) * 0.6
                t = min(t + 1, 90)
                task.Wait()
            end
        end)
    end
    sc_od1.frame = boss.card.PublicHP
    sc_od2.frame = boss.card.PublicHP
end--boss8

do
    boss.Define("9a", "菅牧典", "TH18_1", TH18_bg2, { -400, 0 }, class.SCBG7, "Tsukasa", 18)
    boss.Define("9b", "姬虫百百世", "TH18_1", TH18_bg2, { 0, 400 }, class.SCBG7, "Momoyo", 18)
    local name = "蛊毒「狡猾的食人蜈蚣」"
    local sc1 = boss.card.New(name, 1, 1, 60, 1200)
    local sc2 = boss.card.New(name, 1, 1, 60, 1200)
    boss.card.add({ { sc1, "9a" }, { sc2, "9b" } }, 18, name, 208)
    function sc1:before()
        task.MoveTo(0, 40, 60, 2)
    end
    function sc2:before()
        task.MoveTo(0, 120, 60, 2)
    end
    function sc1:init()
        task.New(self, function()
            local d = 1
            while true do
                task.New(self, function()
                    task.Wait(120)
                    task.MoveTo(100 * d, self.y, 180, 3)
                end)
                local R = -90
                for i = 1, 50 do
                    local l = sin(i / 50 * 170) * 156
                    for a in sp.math.AngleIterator(R, 19) do
                        Create.bullet_changeangle(self.x + cos(a) * l, self.y + sin(a) * l, arrow_small, 8,
                                1, a, { r = i / 65 * (i % 2 * 2 - 1), time = 90, wait = 25, v = 3 })
                    end
                    PlaySound("tan00")
                    --   R = R - 1 * d
                    task.Wait(6)
                end
                task.MoveTo(0, self.y, 30, 2)
                task.Wait(100)
                d = -d
            end
        end)
    end
    function sc2:init()
        task.New(self, function()
            local d = 1
            while true do
                task.Wait(120)
                boss.cast(self, 60)
                task.Wait(60)
                task.MoveTo(100 * d, self.y, 60, 2)
                Newcharge_in(self.x, self.y, 218, 112, 214)
                task.Wait(60)
                Newcharge_out(self.x, self.y, 218, 112, 214)
                for a in sp.math.AngleIterator(ran:Float(0, 360), 30) do
                    Create.bullet_dec_acc(self.x, self.y, ball_huge, 2, ran:Float(6, 8),
                            ran:Float(3, 5), a, true, false)
                    Create.bullet_dec_acc(self.x, self.y, ball_mid, 4, ran:Float(3, 4),
                            ran:Float(3, 5), a, true, false)
                end
                task.New(self, function()
                    misc.ShakeScreen(100, 2.5, 1, 1.5, 1)
                    local sty={ball_huge,ball_light}
                    for k = 1, 100 do
                        local x = 100 * d + sin(k * (35 - k / 100 * 15)) * 15
                        local by = ran:Float(200 - 400 * min(k / 15, 1), 200)
                        NewBon(x, by, 20, 60, 218, 112, 214)
                        local b = NewSimpleBullet(sty[k%2+1], 4, x, 250, 25 - k / 100 * 15, -90)

                        b.bound = false
                        b.timer = 11
                        object.SetSizeColli(b, 2 - k / 100)
                        function b:frame_other()
                            if self.timer > 100 then
                                Del(self)
                            end
                        end
                        PlaySound("heal")
                        task.Wait()
                    end
                end)

                task.MoveTo(0, self.y, 30, 2)
                task.Wait(100)
                d = -d
            end

        end)
    end
    sc1.frame = boss.card.PublicHP
    sc2.frame = boss.card.PublicHP
end--boss9菅牧典的各种管事

