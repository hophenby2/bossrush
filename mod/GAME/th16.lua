local class = {}
_editor_class.TH16 = class
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
local servant = SimpleServant

do
    class.SCBG1 = Class(_SC_BG)
    function class.SCBG1:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th16_5", true, 0, 0, 90, 0.2, -0.2, 0, "mul+rev", 0.6, 0.6)
        function b:Beforeframe()
            self.r = cos(self.timer / 2) * 100 + 150
            self.g = cos(self.timer / 3) * 100 + 150
            self.b = sin(self.timer / 4) * 100 + 150
        end
        b = _SC_BG.AddLayer(self, "th16_5", true, 0, 0, 0, -0.2, -0.2)
        b = _SC_BG.AddLayer(self, "th16_4", true, 0, 0, 0, 0, 0.15)
    end
    class.SCBG2 = Class(_SC_BG)
    function class.SCBG2:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th16_1", true, 0, 0, 0, 1.2, -0.8, 0, "mul+rev")
        b.a = 150
        b = _SC_BG.AddLayer(self, "th16_1", true, 0, 0, 0, 0.5, -0.5)
        b.a = 120
        b = _SC_BG.AddLayer(self, "th06_0", true, 0, 0, 0, 0, 0.1, 0, "mul+add")
        b.a = 40
        b = _SC_BG.AddLayer(self, "th16_0", true, 0, 0, 0, 0, 0.3, 0, "mul+add")
        b.a = 120
        b.r, b.g, b.b = 30, 120, 120
        function b:Beforeframe()
            self.g = 100 + 50 * sin(self.timer / 2)
        end
        b = _SC_BG.AddLayer(self, "th16_0", true, 256, 0, 0, 0, 0.6)
        b.r, b.g, b.b = 20, 80, 40
    end
    class.SCBG3 = Class(_SC_BG)
    function class.SCBG3:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th16_2", true, 0, 0, 0, -0.3, 0.2, 0, "mul+add")
        b.a = 180
        b = _SC_BG.AddLayer(self, "th10_0", false, 64, -32, 0, 0, 0, 0, "mul+rev", 1, 1)
        b.a = 50
        _SC_BG.AddLayer(self, "th16_3", false, 0, 0, 0, 0, 0, 0.2, "mul+add")
        _SC_BG.AddLayer(self, "th16_3", false, 0, 0, 0, 0, 0, -0.2)
    end
    class.SCBG4 = Class(_SC_BG)
    function class.SCBG4:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th16_7", false, 0, 0, 0, 0, 0, 0.2)
        b.a = 180
        b = _SC_BG.AddLayer(self, "th16_6", true, 46, 0, 0, 0, 0.4, 0, "mul+add")
        b.a = 100
        b = _SC_BG.AddLayer(self, "th06_0", true, 0, 0, 0, 0, 0.1, 0, "mul+add")
        b.a = 40
        b = _SC_BG.AddLayer(self, "th16_6", true, 46, 0, 0, -1, 0.5, 0, "")
    end
    class.SCBG5 = Class(_SC_BG)
    function class.SCBG5:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th16_9", false, -180, 0, 0, 0, 0, 0.3, "mul+rev", 2, 2)
        b.a = 180
        function b:Beforeframe()
            self.y = sin(self.timer / 2) * 150
        end
        b = _SC_BG.AddLayer(self, "th16_9", false, 180, 0, 0, 0, 0, -0.3, "mul+rev", 2, 2)
        b.a = 180
        function b:Beforeframe()
            self.y = cos(self.timer / 2) * 150
        end
        b = _SC_BG.AddLayer(self, "th16_8", true, 0, 0, 0, 0, 0.5, 0, "")
    end
    class.SCBG6 = Class(_SC_BG)
    function class.SCBG6:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "img_void")
        function b:Beforerender()
            _SC_BG.PolarCoordinatesRender("th16_10", 0, 120, 0, 500,
                    180, 512, 2, self.timer, "mul+rev",
                    Color(self._cur_alpha * 255,
                            150 + sin(self.timer) * 100,
                            150 + sin(self.timer / 2) * 100,
                            150 + sin(self.timer / 3) * 100))
        end
        b = _SC_BG.AddLayer(self, "th16_11", true, 0, 0, 0, 0, 0.3, 0, "")
    end
end--SCBG
do
    boss.Define("1a", "八云紫", "TH16_0", TH16_bg, { -300, 400 }, _editor_class.TH07.SCBG8, "Yukari", 15)
    local sc = boss.card.New("「不朽的境界」", 1, 2, 40, 750)
    boss.card.add({ { sc, "1a" } }, 15, "「不朽的境界」", 160)
    function sc:before()
        boss.show_aura(self, false)
        PlaySound("ch02")
        New(boss_cast_darkball, 0, 140, 60, 80, 360, 1, 270, 64, 64, 255, 2)
        New(boss_cast_darkball, 0, 140, 60, 80, 360, 1, 270, 255, 64, 64, -2)
        task.Wait(80)
        self.x, self.y = 0, 140
        boss.show_aura(self, true)
        task.MoveTo(0, 100, 60, 2)
    end
    function sc:init()
        boss.card.UnlockOD(self, 17)
        task.New(self, function()
            local arrow = Class(bullet, {
                init = function(self, master, a, o, r, dr)
                    bullet.init(self, arrow_small, 6, false, true)
                    self.master = master
                    self.bound = false
                    self.x, self.y = master.x, master.y
                    task.New(self, function()
                        local l = 0
                        task.New(self, function()
                            while true do
                                if not IsValid(self.master) then
                                    object.Del(self)
                                    NewSimpleBullet(ball_light, 6, self.x, self.y, 6, self.rot)
                                    PlaySound("kira00")
                                    break
                                end
                                self.rot = a

                                self.x, self.y = self.master.x + cos(a) * l, self.master.y + sin(a) * l
                                a = a + o
                                task.Wait()
                            end
                        end)
                        for i = 1, 60 do
                            l = sin(i * 1.5) * r
                            task.Wait()
                        end
                        task.Wait(40)
                        for i = 1, 180 do
                            l = r + sin(i) * dr
                            task.Wait()
                        end

                    end)
                end
            }, true)
            local center = Class(object, {
                init = function(self, x, y, d, ag)
                    self.x, self.y = x, y
                    self.vx = ran:Float(0.2, 0.4) * d
                    self.vy = 2.5
                    self.ag = ag
                    self.maxvy = 4
                    self.group = GROUP.INDES
                    self.colli = false
                    for a in sp.math.AngleIterator(ran:Int(1, 48) * 360 / 48, 48) do
                        New(arrow, self, a, d * 0.15, 100, LineNum(a * 6) * 40)
                        New(arrow, self, a, -d * 0.3, 190, LineNum(a * 6) * 50)
                    end
                end
            }, true)

            Newcharge_in(0, 70, 250, 128, 114)
            task.MoveTo(0, 70, 59, 2)
            task.Wait()
            boss.cast(self, 3600)
            local d = 1
            while true do
                New(center, self.x, self.y, d, 0.03)
                for c = 0, 4 do
                    for a in sp.math.AngleIterator(-90 + c * 5 * d, 18) do
                        object.SetSizeColli(NewSimpleBullet(ball_light, 4, self.x, self.y, 3, a), 0.8 - 0.4 * sin(a / 2 + 45))
                    end
                    PlaySound("tan00")
                    task.Wait(18)
                end
                d = -d
                task.Wait(60)
            end
        end)
    end
    function sc:render()
        local t = self.ani
        SetImageState("yukari-ef", "mul+add", 50 + min(150, t) + sin(t * 0.7 - 90) * 50, 255, 255, 255)
        Render("yukari-ef", self.x, self.y + 4 * sin(t * 4), -0.5 * t, 1.8 + sin(t * 0.7 + 135) * 0.1)
    end

    local scod = boss.card.New("罔两「梦境沉没之日-Special」", 30, 30, 30, 700)
    boss.card.add({ { scod, "1a" } }, 15, "罔两「梦境沉没之日-Special」", 194, 17)
    function scod:before()
        boss.show_aura(self, false)
        PlaySound("ch02")
        New(boss_cast_darkball, 0, 140, 60, 80, 360, 1, 270, 64, 64, 255, 2)
        New(boss_cast_darkball, 0, 140, 60, 80, 360, 1, 270, 255, 64, 64, -2)
        task.Wait(80)
        self.x, self.y = 0, 140
        boss.show_aura(self, true)
        task.MoveTo(0, 100, 60, 2)
    end
    function scod:init()
        task.New(self, function()
            task.init_left_wait(self)
            task.Wait(60)
            self._r, self._g, self._b = 120, 120, 120
            self.colli = false
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            local beat = 22.5
            local fall = function(x, y, v, a, aim_v)
                local self = NewObject(bullet)
                bullet.init(self, arrow_small, 6, false, true)
                self.x, self.y = x, y
                self._blend = "mul+add"
                object.SetV(self, v, a, true)
                task.New(self, function()
                    while not self.flag do
                        task.Wait()
                    end
                    bullet.ChangeImage(self, self.imgclass, 2)
                    Create.bullet_create_eff(self)
                    local na = self.rot
                    local da = (-90 - na) % 360
                    if da > 180 then
                        da = da - 360
                    end
                    object.StopMoving(self)
                    for i = 1, 160 do
                        self.rot = na + da * sin(min(90, i))
                        object.SetV(self, aim_v / 160 * i, self.rot)
                        task.Wait()
                    end
                end)
            end
            local d = 1
            local n = 3
            local bv = 1.8
            task.New(self, function()
                local W = {}
                task.init_left_wait(W)
                task.Wait2(W, beat * 6)
                while true do
                    NewBon(self.x, self.y, 60, 128, 250, 128, 114)
                    NewWave(self.x, self.y, 2, 128, 60, 250, 128, 114)
                    NewPulseScreen(0, { 70, 70, 70 }, "mul+add", 0, 0, 25)
                    object.BulletDo(function(b)
                        b.flag = true
                    end)
                    task.Wait2(W, beat * 8)
                end
            end)
            while true do
                local px, py = player.x, player.y
                task.New(self, function()
                    task.MoveTo(150 * d, -70, beat * 4, 2)
                end)
                servant.init(NewObject(servant), self.x, self.y, 0, 250, 128, 114, 1.5, function(self)
                    task.New(self, function()
                        self:FadeIn(15)
                        object.ChangingSizeColli(self, -0.5, -0.5, 15)
                    end)
                    task.New(self, function()
                        task.init_left_wait(self)
                        for _ = 1, n do
                            for a in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                                Create.bullet_accel(self.x, self.y, ball_mid, 6, 0.5, bv, a, true, false)
                            end
                            PlaySound("tan00")
                            task.Wait2(self, beat)
                        end
                        task.Wait(20)
                        self:FadeOut(10)
                        Del(self)
                    end)

                end)
                for i = 1, 32 do
                    local A = Angle(self, px, py)
                    for a in sp.math.AngleIterator(A + 360 / 13 / 2, 13) do
                        fall(self.x, self.y, 9 - i / 32 * 8, a, 6)
                    end

                    PlaySound("tan00")
                    task.Wait2(self, beat / 8)
                end
                task.New(self, function()
                    task.MoveTo(0, 120, beat * 4, 2)
                end)
                task.Wait2(self, beat * 4)

                d = -d
                beat = beat - 0.23
                n = n + 0.5
                bv = bv + 0.06
            end

        end)
    end
    function scod:render()
        local t = self.ani
        SetImageState("yukari-ef", "mul+add", 50 + min(150, t) + sin(t * 0.7 - 90) * 50, 255, 255, 255)
        Render("yukari-ef", self.x, self.y + 4 * sin(t * 4), -0.5 * t, 1.8 + sin(t * 0.7 + 135) * 0.1)
    end
end--start

do
    boss.Define("2a", "莉莉白", "TH16_0", TH16_bg, { 0, 500 }, class.SCBG1, "Whitelily", 15)
    boss.Define("2b", "高丽野阿吽", "TH16_0", TH16_bg, { -300, 300 }, class.SCBG1, "Aunn", 15)
    local non1 = boss.card.New("", 1, 1, 30, 700)
    local non2 = boss.card.New("", 1, 1, 30, 700)
    function non1:before()
        boss.ns_group.init(self)
        boss.show_aura(self, false)
        task.Wait(60)
    end
    function non2:before()
        boss.ns_group.init(self)
        task.MoveTo(0, 80, 60, 2)
        if ext.sc_pr then
            TH16_bg.ToSpring(lstg.tmpvar.bg)
        end
    end
    function non1:init()
        task.New(self, function()
            boss.violent(self)
            self.hp = 0
        end)
    end
    function non2:init()
        task.New(self, function()
            local d = 1
            local grain_a = grain_a
            while true do
                Newcharge_out(self.x, self.y, 250, 128, 114)
                boss.cast(self, 600)
                for c = 1, 14 do
                    for a = -7, 7 do
                        a = 90 + 11 * a
                        task.New(NewSimpleBullet(grain_a, 14, self.x + cos(a + c * d) * -c * 4, self.y + sin(a + c * d) * -c * 4,
                                2, a + c * d), function()
                            task.Wait(60)
                            object.SetG(task.GetSelf(), 0.03, true, 4)
                        end)
                        task.New(NewSimpleBullet(grain_a, 10, self.x + cos(a - c * 0.5 * d) * -c * 4, self.y + sin(a - c * 0.5 * d) * -c * 4,
                                2.1, a - c * 0.5 * d), function()
                            task.Wait(60)
                            object.SetG(task.GetSelf(), 0.05, true, 4)
                        end)
                        NewSimpleBullet(grain_a, 2, self.x, self.y, 2.1, -a - c * 0.3 * d)
                        NewSimpleBullet(grain_a, 15, self.x, self.y, 1, -a + c * 0.6 * d)
                    end
                    PlaySound("tan00")
                    task.Wait(3)
                end
                for c = 15, 28 do
                    for a = -7, 7 do
                        a = 90 + 11 * a
                        NewSimpleBullet(grain_a, 15, self.x, self.y, 1, -a + c * 0.6 * d)
                    end
                    PlaySound("tan00")
                    task.Wait(3)
                end
                for t = 1, 3 do
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 15) do
                        NewSimpleBullet(ball_huge, 2, self.x, self.y, 3 - t * 0.1, a)
                    end
                    PlaySound("tan00")
                    task.Wait(20)
                end
                task.Wait(50)
                d = -d
                task.MoveToPlayer(59, -100, 100, 60, 100, 20, 40, 10, 20, 2, 1)
                task.Wait()
            end
        end)
    end
    boss.card.add({ { non1, "2a" }, { non2, "2b" } }, 15, "非符", 161)
    non1.del = boss.ns_group.del
    non2.del = boss.ns_group.del

    local name = "春守「春日赏花会」"
    local sc1 = boss.card.New(name, 1, 2, 40, 800)
    local sc2 = boss.card.New(name, 1, 2, 40, 800)
    boss.card.add({ { sc1, "2a" }, { sc2, "2b" } }, 15, name, 162)
    sc1.frame = boss.card.PublicHP
    sc2.frame = boss.card.PublicHP
    function sc1:before()
        boss.ns_group.nextcard(self, 0, 400)
        task.MoveTo(0, 60, 60, 2)
        if ext.sc_pr then
            TH16_bg.ToSpring(lstg.tmpvar.bg)
        end
    end
    function sc2:before()
        boss.ns_group.nextcard(self, 0, 400)
        task.MoveTo(0, 150, 60, 2)
    end
    function sc1:init()
        task.New(self, function()
            task.Wait(80)
            while true do
                boss.cast(self, 60)
                for b, x, y in sp.math.EllipseIterator(ran:Float(0, 360), 30, 0, 0, 3, 2, ran:Sign() * 45 + ran:Float(-10, 10)) do
                    b = NewSimpleBullet(flower2, 14, self.x, self.y, sp.math.RectangularToPolar(x, y))
                    object.SetSizeColli(b, 0.3)
                    function b:frame_other()
                        bullet.ReBound(self, { "t" }, nil, true, function(self)
                            object.Del(self)
                            Create.laser_line(self.x, self.y, 14, Dist(0, 0, self.vx, self.vy), self.rot, 30, 8, 8, 8)
                        end)
                    end
                end
                PlaySound("tan00", 0.1, 0, true)
                task.Wait(45)
                task.MoveToPlayer(60, -96, 96, 50, 70, 20, 40, 10, 20, 2, 1)
                task.Wait(10)
            end
        end)
    end
    function sc2:init()
        task.New(self, function()
            local bl = Class(bullet, {
                init = function(self, master, a, o, l)
                    bullet.init(self, sakura, 4, false, true)
                    self.x, self.y = master.x, master.y
                    self.bound = false
                    --object.SetSizeColli(self, 0.8)
                    task.New(self, function()
                        local t = 0
                        while IsValid(master) do
                            self.x = master.x + cos(a) * l * sin(t)
                            self.y = master.y + sin(a) * l * sin(t)
                            a = a + o
                            self.rot = a
                            t = min(t + 1, 90)
                            task.Wait()
                        end
                        object.Del(self)
                    end)
                end
            }, true)
            local center = Class(bullet, {
                init = function(self, x, y, mx, my, v, r, ia)
                    bullet.init(self, ball_light, 2, false, false)
                    self.x, self.y = x, y
                    self.bound = false
                    PlaySound("kira00")
                    task.New(self, function()
                        task.MoveTo(mx, my, 60, 2)
                        for d = 0, 180, 180 do
                            for z = -10, 10 do
                                New(bl, self, d + z * 3 + ia, r, 140 - 140 * abs(z / 10))
                            end
                        end
                        self.vy = -v
                        while true do
                            if self.y < -384 then
                                object.Del(self)
                            end
                            task.Wait()
                        end
                    end)
                end
            }, true)

            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            boss.cast(self, 3600)
            local r = 0
            while true do
                New(center, self.x, self.y, -120, 190, 1.8, 0.55, r)
                task.Wait(28)
                New(center, self.x, self.y, 120, 190, 1.8, -0.55, -r)
                task.Wait(28)
                r = r + 24
            end
        end)
    end
end--spring

do
    boss.Define("3a", "大妖精", "TH16_0", TH16_bg, { 0, 500 }, class.SCBG2, "Daiyousei", 15)
    boss.Define("3b", "爱塔妮缇拉尔瓦", "TH16_0", TH16_bg, { 300, 300 }, class.SCBG2, "EternityLarva", 15)
    local non1 = boss.card.New("", 1, 1, 30, 700)
    local non2 = boss.card.New("", 1, 1, 30, 700)
    function non1:before()
        boss.ns_group.init(self)
        boss.show_aura(self, false)
        task.Wait(60)
    end
    function non2:before()
        boss.ns_group.init(self)
        task.MoveTo(0, 80, 60, 2)
        if ext.sc_pr then
            TH16_bg.ToSummer(lstg.tmpvar.bg)
        end
    end
    function non1:init()
        task.New(self, function()
            boss.violent(self)
            self.hp = 0
        end)
    end
    function non2:init()
        task.New(self, function()
            local b
            local function Rebound(x, y, v, a)
                b = NewSimpleBullet(butterfly, 14, x, y, v, a)
                b.fogtime = 30
                function b:frame_other()
                    bullet.ReBound(self, { "l", "r" }, nil, not self.flag, function(self)
                        self.flag = true
                        Create.bullet_create_eff(self)
                    end)
                end
            end
            local function Line(x, y, a, t, ag)
                task.New(self, function()
                    for _ = 1, t do
                        object.SetG(NewSimpleBullet(ball_huge, 10, x, y, 3.5, a), ag)
                        PlaySound("kira00")
                        task.Wait(7)
                    end
                end)
            end

            Newcharge_in(self.x, self.y, 189, 252, 201)
            task.Wait(60)
            local d = 1
            while true do
                boss.cast(self, 150)
                task.New(self, function()
                    for i = 1, 30 do
                        for a in sp.math.AngleIterator(0, 8) do
                            Rebound(self.x + cos(i * 12 * d + 90) * i * 4, self.y + sin(i * 12 * d + 90) * i * 4, 2, a)
                        end
                        PlaySound("tan00")
                        task.Wait(4)
                    end
                end)
                task.Wait(20)
                for i = -1, 1 do
                    Line(self.x, self.y, i * 10 * d + ran:Float(-3, 3) + 90, 10, 0.03)
                    task.Wait(30)
                end
                task.New(self, function()
                    task.MoveToPlayer(90, -96, 96, 70, 90,
                            40, 60, 10, 20, 2, 1)
                end)
                task.Wait(30)
                for i = 1, 10 do
                    local x, y = self.x + ran:Float(-30, 30), self.y + ran:Float(-30, 30)
                    for _ = 1, i do
                        Create.bullet_dec_acc(x, y, ball_mid, 5, 4, ran:Float(3, 4), ran:Float(0, 360))
                        Create.bullet_decel(x, y, ball_mid, 6, 4, ran:Float(1.2, 2), ran:Float(0, 360))
                    end
                    PlaySound("tan00")
                    task.Wait(5)
                end
                task.Wait(100)
                d = -d
            end
        end)
    end
    boss.card.add({ { non1, "3a" }, { non2, "3b" } }, 15, "非符", 163)
    non1.del = boss.ns_group.del
    non2.del = boss.ns_group.del
    local name = "活蝶「桃花期凤鳞」"
    local sc1 = boss.card.New(name, 1, 2, 60, 800)
    local sc2 = boss.card.New(name, 1, 2, 60, 800)
    boss.card.add({ { sc1, "3a" }, { sc2, "3b" } }, 15, name, 164)
    sc1.frame = boss.card.PublicHP
    sc2.frame = boss.card.PublicHP
    function sc1:before()
        boss.ns_group.nextcard(self, 0, 400)
        task.MoveTo(0, 0, 60, 2)
        if ext.sc_pr then
            TH16_bg.ToSummer(lstg.tmpvar.bg)
        end
    end
    function sc2:before()
        boss.ns_group.nextcard(self, 0, 400)
        task.MoveTo(0, 150, 60, 2)
    end
    local moteki
    function sc1:init()
        moteki = self
        task.New(self, function()
            PlaySound("ch02")
            New(boss_cast_darkball, self.x, self.y, 60, 80, 360, 1, 270, 64, 120, 64, 2)
            New(boss_cast_darkball, self.x, self.y, 60, 80, 360, 1, 270, 64, 120, 64, -2)
            task.Wait(80)
            local t
            task.New(self, function()
                local c, h = 0, -90
                while true do
                    c = min(c + 1, 90)
                    h = h + sin(c)
                    self.x = cos(h) * 80
                    self.y = sin(h) * 30 + 30
                    task.Wait()
                end
            end)
            while true do
                for a in sp.math.AngleIterator(ran:Float(0, 360), 10) do
                    t = NewSimpleBullet(heart, 4, self.x, self.y, 1.5, a)

                    bullet.SetLayer(t, -99)
                end
                PlaySound("kira00")
                task.Wait(80)
                --task.MoveToPlayer(40, -150, 150, 40, 80, 70, 90, 10, 20, 2, 1)
            end
        end)
    end
    function sc2:init()
        task.New(self, function()
            task.Wait(60)
            boss.cast(self, 3600, true)
            Newcharge_in(self.x, self.y, 189, 252, 201)
            task.Wait(60)
            local scale = Class(bullet, {
                init = function(self, x, y, v, a)
                    bullet.init(self, ellipse, 10, false, true)
                    self.x, self.y = x, y
                    object.SetV(self, v, a, true)
                    task.New(self, function()
                        while true do
                            if IsValid(moteki) and Dist(moteki, self) < 32 then
                                break
                            end
                            task.Wait()
                        end
                        bullet.ChangeImage(self, self.imgclass, 2)
                        Create.bullet_create_eff(self)
                        object.ChangingV(self, 0, 6, Angle(self, player), 70, true)
                    end)
                end
            }, true)
            local function shoot(v, a, t, wait)
                task.New(self, function()
                    for _ = 1, t do
                        New(scale, self.x, self.y, v, a)
                        v = v - 0.4
                        task.Wait(wait)
                    end
                end)
            end
            task.New(self, function()
                local wait = 35
                local ang = 75
                while true do
                    shoot(4.5, ang, 7, 2)
                    PlaySound("tan00")
                    wait = max(wait - 3, 6)
                    ang = ang + 78
                    task.Wait(wait)
                end
            end)

            task.New(self, function()
                task.Wait(180)
                while true do
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 76) do
                        for v = 1, 3 do
                            New(scale, self.x, self.y, 2.5 + v * 0.3, a)
                        end
                    end
                    task.MoveToPlayer(80, -50, 50, 140, 160,
                            50, 60, 10, 20, 5, 3)
                    task.Wait(20)
                end
            end)
        end)
    end
end--summer

do
    boss.Define("4a", "秋穰子", "TH16_0", TH16_bg, { 0, 500 }, class.SCBG3, "Minoriko", 15)
    boss.Define("4b", "坂田合欢", "TH16_0", TH16_bg, { -300, 300 }, class.SCBG3, "Nemuno", 15)
    local non1 = boss.card.New("", 1, 1, 30, 700)
    local non2 = boss.card.New("", 1, 1, 30, 700)
    function non1:before()
        boss.ns_group.init(self)
        boss.show_aura(self, false)
        task.Wait(60)
    end
    function non2:before()
        boss.ns_group.init(self)
        task.MoveTo(0, 120, 60, 2)
        if ext.sc_pr then
            TH16_bg.ToAutumn(lstg.tmpvar.bg)
        end
    end
    function non1:init()
        task.New(self, function()
            boss.violent(self)
            self.hp = 0
        end)
    end
    function non2:init()
        task.New(self, function()
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            local d = 1
            while true do
                boss.cast(self, 360)
                task.New(self, function()
                    task.Wait(60)
                    for _ = 1, 5 do
                        for a in sp.math.AngleIterator(ran:Float(0, 360), 10) do
                            NewSimpleBullet(ball_big, 2, self.x, self.y, 2.5, a)
                            Create.bullet_accel(self.x, self.y, ball_big, 2, 1, 3, a)
                        end
                        task.Wait(20)
                    end
                end)
                local x, y = -3 * d, -3
                for i = 1, 40 do
                    for a = -2, 2 do
                        Create.bullet_decel(self.x + x * i + ran:Float(-i / 2, i / 2), self.y + y * i + ran:Float(-i / 2, i / 2), arrow_small, 5 + ran:Sign(),
                                6, 4, Angle(self.x + x * i, self.y + y * i, player) + a * 20 + ran:Float(-2, 2))
                    end
                    PlaySound("tan00")
                    task.Wait(3)
                end
                Newcharge_out(self.x + x * 40, self.y + y * 40, 255, 227, 132)
                task.New(self, function()
                    task.MoveToPlayer(60, -96, 96, 100, 140,
                            20, 40, 10, 20, 2, 1)
                end)
                for t = 1, 15 do
                    for i = -1, 1, 2 do
                        Create.laser_line(self.x + x * 40, self.y + y * 40 + t * 13, 14, 3, -90 + i * t * 14,
                                60, 8, 8, 8)
                        Create.laser_line(self.x + x * 40, self.y + y * 40 + -t * 13, 14, 3, 90 + i * t * 14,
                                60, 8, 8, 8)
                    end
                    task.Wait(2)
                end
                task.Wait(80)
                d = -d
            end
        end)
    end
    boss.card.add({ { non1, "4a" }, { non2, "4b" } }, 15, "非符", 165)
    non1.del = boss.ns_group.del
    non2.del = boss.ns_group.del
    local name = "秋刃「磨刀霍霍向稻谷」"
    local sc1 = boss.card.New(name, 1, 2, 60, 800)
    local sc2 = boss.card.New(name, 1, 2, 60, 800)
    boss.card.add({ { sc1, "4a" }, { sc2, "4b" } }, 15, name, 166)
    sc1.frame = boss.card.PublicHP
    sc2.frame = boss.card.PublicHP
    function sc1:before()
        task.MoveTo(0, 50, 60, 2)
        if ext.sc_pr then
            TH16_bg.ToAutumn(lstg.tmpvar.bg)
        end
    end
    function sc2:before()
        task.MoveTo(0, 140, 60, 2)
    end
    function sc1:init()
        task.New(self, function()
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            local big = Class(bullet, {
                init = function(self, x, y, v, a, fv, mv)
                    bullet.init(self, ball_huge, 12, false, true)
                    self.x, self.y = x, y
                    object.SetV(self, v, a, true)
                    self.ag = 0.04
                    self.navi = true
                    task.New(self, function()
                        while true do
                            for A in sp.math.AngleIterator(self.rot + 90, 2) do
                                Create.bullet_accel(self.x + cos(A) * 16, self.y + sin(A) * 16, grain_a, 14, fv, mv, A, false, true)
                            end
                            task.Wait(5)
                        end
                    end)
                end
            }, true)
            local da = 0
            local d = 1
            while true do
                boss.cast(self, 90)
                local _a
                for a = 1, 6 do
                    New(big, self.x, self.y, 2, a * 5 * d + da, 0.5 - a * 0.03, 4 - a / 3)
                    for t = -12, 12 do
                        _a = a * 5 * d + 180 + t / 13 * 90 + da
                        Create.bullet_accel(self.x + cos(_a) * 16, self.y + sin(_a) * 16, grain_a, 14,
                                1 - abs(t) / 24 - a * 0.03, 4 - a / 3, _a, false, true)
                    end
                    PlaySound("tan00")
                    task.Wait(3)
                end
                da = da + 180
                d = -d
                task.Wait(120)
                task.Wait(100)
            end
        end)
    end
    function sc1:render()
    end
    function sc2:init()
        task.New(self, function()
            Newcharge_in(self.x, self.y, 255, 227, 132)
            task.Wait(60)
            local d = 1
            while true do
                task.Wait(30)
                boss.cast(self, 60)
                Newcharge_out(self.x, self.y, 255, 227, 132, true)
                PlaySound("kira00")
                for x = -7, 7 do
                    task.New(Create.laser_line(d * -x * 31, self.y - 10, 2, 3, -90,
                            50, 8, 8), function()
                        local self = task.GetSelf()
                        for i = 1, 50 do
                            self.y = self.y + (1 - sin(i / 50 * 90)) * 3.6
                            task.Wait()
                        end
                        object.ChangingV(self, 3, 0.5, self.rot, 30)
                        task.Wait(45)
                        object.ChangingV(self, 0.5, 5, self.rot, 70)
                    end)
                end
                for x = -21, 21 do
                    for v = 1, 2 do
                        Create.bullet_accel(-x * 9 * d, self.y - 10, ellipse, 2, ran:Float(0.2, 0.4),
                                3 - v / 4, ran:Float(0, 360), true, true, 100)
                    end
                    task.Wait()
                end
                task.Wait(130 - 43)
                d = -d
                task.MoveToPlayer(78, -96, 140, 150, 130,
                        20, 40, 10, 20, 2, 1)
            end
        end)
    end
end--autumn

do
    boss.Define("5a", "蕾蒂·霍瓦特洛克", "TH16_0", TH16_bg, { 0, 500 }, class.SCBG4, "Whiterock", 15)
    boss.Define("5b", "矢田寺成美", "TH16_0", TH16_bg, { 300, 300 }, class.SCBG4, "Narumi", 15)
    local non1 = boss.card.New("", 1, 1, 30, 700)
    local non2 = boss.card.New("", 1, 1, 30, 700)
    function non1:before()
        boss.ns_group.init(self)
        boss.show_aura(self, false)
        task.Wait(60)
    end
    function non2:before()
        boss.ns_group.init(self)
        task.MoveTo(0, 140, 60, 2)
        if ext.sc_pr then
            TH16_bg.ToWinter(lstg.tmpvar.bg)
        end
    end
    function non1:init()
        task.New(self, function()
            boss.violent(self)
            self.hp = 0
        end)
    end
    function non2:init()
        task.New(self, function()
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            local D = 1
            while true do
                local b
                boss.cast(self, 120)
                for i = 1, 18 do
                    for a in sp.math.AngleIterator(0, 16) do
                        for d = -1, 1, 2 do
                            b = Create.bullet_changeangle(self.x + cos(a) * 30, self.y + sin(a) * 30, square, 2, 2, a,
                                    { r = (0.6 + i / 16) * d, time = 80 }, { r = -(0.6 + i / 16) * d, time = 120 })
                            b.stay = false
                            function b:frame_new()
                                bullet.frame(self)
                                self.bound = self.changed or false
                            end
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(4)
                end
                task.New(self, function()
                    for _ = 1, 3 do
                        for a in sp.math.AngleIterator(ran:Float(0, 360), 15) do
                            Create.bullet_dec_setangle(self.x, self.y, ball_huge, 6,
                                    { v = ran:Float(3.5, 4.5), a = a, time = 120, }, { v = ran:Float(1, 2), a = -90 })
                        end
                        PlaySound("kira00")
                        task.Wait(90)
                    end
                end)
                task.Wait(90)
                task.MoveToPlayer(60, -96, 96, 130, 150,
                        20, 40, 10, 20, 2, 1)
                for d = -1, 1, 2 do
                    for i = 1, 8 do
                        for a in sp.math.AngleIterator(0, 16) do
                            Create.bullet_changeangle(self.x + cos(a) * 20, self.y + sin(a) * 20, square, 8, 2, a,
                                    { r = d * D * (0.5 + i / 30), time = 180 })
                        end
                        PlaySound("tan00")
                        task.Wait(5)
                    end
                end
                D = -D
                task.Wait(80)
            end

        end)
    end
    boss.card.add({ { non1, "5a" }, { non2, "5b" } }, 15, "非符", 167)
    non1.del = boss.ns_group.del
    non2.del = boss.ns_group.del

    local name = "魔寒「忽冷忽热」"
    local sc1 = boss.card.New(name, 1, 2, 60, 750)
    local sc2 = boss.card.New(name, 1, 2, 60, 750)
    boss.card.add({ { sc1, "5a" }, { sc2, "5b" } }, 15, name, 168)
    --sc1.frame = boss.card.PublicHP
    sc2.frame = boss.card.PublicHP
    function sc1:before()
        task.MoveTo(0, 150, 60, 2)
        if ext.sc_pr then
            TH16_bg.ToWinter(lstg.tmpvar.bg)
        end
    end
    function sc2:before()
        task.MoveTo(0, 60, 60, 2)
    end
    local nuclear
    function sc1:init()
        task.New(self, function()
            local ice = Class(bullet, {
                init = function(self, x, y, size, lifetime)


                    bullet.init(self, ball_mid, 8, false, true)
                    object.SetSizeColli(self, size)
                    self.x, self.y = x, y
                    self.__a = 255
                    self.colli2 = false
                    self.colli = false
                    if Dist(player, self) < 48 then
                        object.RawDel(self)
                    end
                    bullet.SetLayer(self, LAYER.ENEMY_BULLET - 1)
                    task.New(self, function()

                        for _ = 1, 11 do
                            if Dist(player, self) < 48 then
                                object.RawDel(self)
                            end
                            task.Wait()
                        end
                        self.colli2 = true
                    end)
                    task.New(self, function()
                        task.Wait(lifetime)
                        Create.bullet_create_eff(self.x, self.y, self.imgclass, self._index, 0, 0)
                        object.RawDel(self)
                    end)
                end,
                frame = function(self)
                    bullet.frame(self)
                    if IsValid(nuclear) then
                        local d = Dist(nuclear, self)
                        if d < nuclear.a then
                            object.Del(self)
                        end
                        self.colli = (d > nuclear.hscale * 260) and self.colli2
                        self.__a = self.colli and 255 or 43
                        self._a = self._a + (self.__a - self._a) * 0.08
                    end
                end
            }, true)
            local little = Class(object, {
                frame = task.Do,
                init = function(self, x, y, v, a, times, wait, d, init_size)
                    self.colli = false
                    object.init(self, x, y, GROUP.INDES)
                    object.SetV(self, v, a)
                    local s = 1
                    task.New(self, function()
                        for i = 1, 25 do
                            s = init_size * (1 - i / 50)
                            New(ice, self.x, self.y, s, 280)
                            task.Wait()
                        end
                        object.RawDel(self)
                    end)
                    task.New(self, function()
                        for _ = 1, times do
                            task.Wait(wait + ran:Int(-2, 2))
                            New(self.class, self.x, self.y, v, a + ran:Float(26, 30) * d, ran:Int(0, times - 1), wait, -d, s)
                            a = a - ran:Float(26, 30) * d
                            object.SetV(self, v, a)
                        end
                    end)
                end
            }, true)
            local main = Class(object, {
                init = function(self, x, y, v, a)
                    self.x, self.y = x, y
                    self.colli = false
                    self.img = "servant"
                    self.omiga = ran:Float(2, 3)
                    self._r, self._g, self._b = 135, 206, 235

                end
            }, true)
            Newcharge_in(self.x, self.y, 135, 206, 235)
            task.Wait(60)
            while true do
                boss.cast(self, 150)
                Newcharge_out(self.x, self.y, 255, 255, 255)
                NewSimpleServant(self.x, self.y, 0, 135, 206, 235, 1.5, function(self)
                    local v, a = 6, Angle(self, player)
                    task.New(self, function()
                        self:FadeIn(15)
                        object.ChangingSizeColli(self, -0.5, -0.5, 15)
                    end)
                    task.New(self, function()
                        object.SetV(self, v, a)
                        task.New(self, function()
                            while true do
                                New(ice, self.x, self.y, 1, 280)
                                task.Wait(2)
                            end
                        end)
                        task.New(self, function()
                            local d = 1
                            while true do
                                task.Wait(10 + ran:Int(-3, 3))
                                New(little, self.x, self.y, v * 2, a + (90 + ran:Float(10, 25)) * d, ran:Int(2, 6), 5, d, 1)
                                d = -d
                            end
                        end)
                    end)
                end)
                for a in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                    for v = 1, 3 do
                        NewSimpleBullet(ball_mid_c, 6, self.x, self.y, 1 + v * 0.3, a + v * 9)
                    end
                end
                task.Wait(90)
                task.MoveToPlayer(90, -96, 96, 140, 160,
                        20, 40, 10, 20, 2, 1)
                task.Wait(120)
                task.Wait(120)
            end
        end)
    end
    function sc1:frame()
        CollisionCheck(1, 5)
        boss.card.PublicHP(self)
    end
    function sc2:init()
        task.New(self, function()
            local ball = Class(Nuclear, {
                init = function(self, x, y)
                    Nuclear.init(self, x, y, 1)
                    self.layer = -202
                    self.hscale = 0
                    self.vscale = 0
                    self.a = 0
                    self.b = 0
                    task.New(self, function()
                        for i = 1, 30 do
                            self.hscale = sin(i * 3) * 0.3
                            self.vscale = self.hscale
                            self.a = 86 * self.hscale
                            self.b = self.a
                            task.Wait()
                        end
                    end)
                    task.New(self, function()
                        local c = 0
                        while true do
                            c = c + 1
                            object.SetV(self, 0.6 + 0.4 * sin(c), Angle(self, player))
                            task.Wait()
                        end
                    end)
                    task.New(self, function()
                        local b
                        while true do
                            task.Wait(170)
                            for a in sp.math.AngleIterator(ran:Float(0, 360), 50) do
                                b = Create.bullet_accel(self.x, self.y, water_drop, 2, 0.5, 2, a)
                                b.frame_new = function(unit)
                                    if IsValid(self) and Dist(unit, self) > self.hscale * 260 then
                                        object.Del(unit)
                                    end
                                end
                            end
                            PlaySound("tan00")
                        end
                    end)
                end,
                render = function(self)
                    Nuclear.render(self)
                    SetImageState("circle_charge", "mul+add", 255, 250, 128, 114)
                    Render("circle_charge", self.x, self.y, 0, self.hscale * 260 / 256)
                end
            }, true)
            task.Wait(60)
            PlaySound("ch02")
            New(boss_cast_darkball, self.x, self.y, 60, 60, 360, 1, 270, 150, 64, 64, 2)
            New(boss_cast_darkball, self.x, self.y, 60, 60, 360, 1, 270, 150, 64, 64, -2)
            task.Wait(120)
            boss.cast(self, 6000)
            PlaySound("boon01", 1, 0, true)
            nuclear = New(ball, self.x, self.y)
            task.Wait(180)
            while true do
                for a, i in sp.math.AngleIterator(ran:Float(0, 360), 30) do
                    NewSimpleBullet(square, i % 2 * 6 + 2, self.x + cos(a) * 30, self.y + sin(a) * 30, 0.8, a)
                end
                task.Wait(200)
            end
        end)
    end
end--winter

do
    boss.Define("6a", "尔子田里乃", "TH16_0", TH16_bg, { -300, 300 }, class.SCBG5, "Satono", 15)
    boss.Define("6b", "丁礼田舞", "TH16_0", TH16_bg, { 300, 300 }, class.SCBG5, "Mai", 15)
    local name = "舞符「Dance With Devils」"
    local sc1 = boss.card.New(name, 1, 2, 60, 860)
    local sc2 = boss.card.New(name, 1, 2, 60, 860)
    boss.card.add({ { sc1, "6a" }, { sc2, "6b" } }, 15, name, 169)
    sc1.frame = boss.card.PublicHP
    sc2.frame = boss.card.PublicHP
    function sc1:before()
        boss.show_aura(self, false)
        task.MoveTo(0, 170, 120, 2)
        boss.show_aura(self, true)
        task.Wait(60)
    end
    function sc2:before()
        boss.show_aura(self, false)
        task.MoveTo(00, 60, 120, 2)
        boss.show_aura(self, true)
        task.Wait(60)
    end
    function sc1:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            boss.cast(self, 6666, true)
            task.New(self, function()
                local s = 90
                local t = 1
                while true do
                    self.x = cos(90 - 90 * cos(s)) * 110
                    self.y = 60 + abs(sin(s) * 110)
                    s = s + sin(t) * 1.1
                    t = min(t + 1, 90)
                    if self.timer % 7 == 0 then
                        local ang = Angle(0, 60, self)
                        for z = -1, 1 do
                            z = ang + z * 18
                            for v = 1, 4 do
                                object.SetG(NewSimpleBullet(arrow_big, 10, self.x + cos(z + 180) * 15, self.y + sin(z + 180) * 15,
                                        2 - v * 0.06, z, nil, 0, false), 0.03 - v * 0.004, true)
                            end

                        end
                        PlaySound("tan00", 0.1, self.x / 50, true)
                    end
                    task.Wait()
                end
            end)
        end)
    end
    function sc2:init()
        task.New(self, function()

            local r = ran:Float(0, 360)
            local square_bullet = function(x, y, fv, v, ftime, a, da, dtime, d)
                if Dist(x, y, player) >= 48 then
                    local self = NewObject(bullet)
                    bullet.init(self, square, 4, true, true)
                    self.x, self.y = x, y
                    PlaySound("tan00", 0.1, 0, true)
                    task.New(self, function()
                        object.ChangingV(self, fv, 0, a, ftime)
                        while true do
                            PlaySound("kira00", 0.2, self.x / 256, true)
                            object.ChangingV(self, v, 0, a + da * d, dtime)
                            d = -d
                        end
                    end)
                end
            end
            local d = 1
            while true do
                Newcharge_in(self.x, self.y, 250, 128, 114)
                task.Wait(60)
                boss.cast(self, 120)
                Newcharge_out(self.x, self.y, 250, 128, 114)
                for l = 1, 20 do
                    for a in sp.math.AngleIterator(r, 20) do
                        square_bullet(self.x + cos(a) * l * 16, self.y + sin(a) * l * 16, 0.1, 3, 90, a, 50, 60, d)
                    end
                    task.Wait(3)
                end
                task.Wait(200)
                for a in sp.math.AngleIterator(ran:Float(0, 360), 25) do
                    for v = 0, 2 do
                        NewSimpleBullet(ball_big, 4, self.x, self.y, 1.5 + v * 0.4, a)
                    end
                end
                task.MoveToPlayer(60, -96, 96, 40, 90, 20, 40, 10, 20, 2, 1)
                d = -d
                task.Wait(60)
            end

        end)

    end
end--尬舞1

do
    boss.Define("7a", "丁礼田舞", "TH16_0", TH16_bg, { 300, 300 }, class.SCBG5, "Mai", 15)
    boss.Define("7b", "尔子田里乃", "TH16_0", TH16_bg, { -300, 300 }, class.SCBG5, "Satono", 15)
    local name = "舞符「ダンデビ」"
    local sc1 = boss.card.New(name, 1, 2, 60, 860)
    local sc2 = boss.card.New(name, 1, 2, 60, 860)
    boss.card.add({ { sc1, "7a" }, { sc2, "7b" } }, 15, name, 170)
    sc1.frame = boss.card.PublicHP
    sc2.frame = boss.card.PublicHP
    function sc1:before()
        boss.show_aura(self, false)
        task.MoveTo(0, 170, 120, 2)
        boss.show_aura(self, true)
        task.Wait(60)
    end
    function sc2:before()
        boss.show_aura(self, false)
        task.MoveTo(00, 60, 120, 2)
        boss.show_aura(self, true)
        task.Wait(60)
    end
    function sc1:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            boss.cast(self, 6666, true)
            task.New(self, function()
                local s = 90
                local t = 1
                while true do
                    self.x = cos(90 - 90 * cos(s)) * 110
                    self.y = 60 + abs(sin(s) * 110)
                    s = s - sin(t) * 1.1
                    t = min(t + 1, 90)
                    if self.timer % 8 == 0 then
                        local ang = Angle(0, 60, self)
                        for z = -1, 1 do
                            z = ang + z * 20
                            for v = 1, 4 do
                                object.SetG(NewSimpleBullet(arrow_big, 4, self.x + cos(z + 180) * 15, self.y + sin(z + 180) * 15,
                                        2 - v * 0.06, z, nil, 0, false), 0.03 - v * 0.004, true)
                            end

                        end
                        PlaySound("tan00", 0.1, self.x / 50, true)
                    end
                    task.Wait()
                end
            end)
        end)
    end
    function sc2:init()
        task.New(self, function()
            local r = ran:Float(0, 360)
            local square_bullet = function(x, y, fv, v, ftime, a, da, dtime, d)
                if Dist(x, y, player) >= 48 then
                    local self = NewObject(bullet)
                    bullet.init(self, square, 10, true, true)
                    self.x, self.y = x, y
                    PlaySound("tan00", 0.1, 0, true)
                    task.New(self, function()
                        object.ChangingV(self, fv, 0, a, ftime)
                        while true do
                            object.ChangingVA(self, v, 0, a, da * d, dtime)
                            d = -d
                        end
                    end)
                end
            end
            local d = 1
            while true do
                Newcharge_in(self.x, self.y, 250, 128, 114)
                task.Wait(60)
                boss.cast(self, 120)
                Newcharge_out(self.x, self.y, 250, 128, 114)
                for l = 1, 20 do
                    for a in sp.math.AngleIterator(r, 16) do
                        square_bullet(self.x + cos(a) * l * 16, self.y + sin(a) * l * 16, 0.1, 2.5, 90, a, 180, 60, d)
                    end
                    task.Wait(3)
                end
                task.Wait(260)

                task.MoveToPlayer(60, -96, 96, 40, 90,
                        20, 40, 10, 20, 2, 1)
                d = -d
                for a in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                    for v = 0, 2 do
                        NewSimpleBullet(ball_big, 10, self.x, self.y, 1.5 + v * 0.4, a)
                    end
                end
                task.Wait(60)
            end

        end)

    end
end--尬舞2

do
    boss.Define("8a", "摩多罗隐岐奈", "TH16_1", TH16_bg, { 0, 500 }, class.SCBG6, "Okina1", 15)
    local non_sc = boss.card.New("", 1, 2, 30, 700)
    boss.card.add({ { non_sc, "8a" } }, 15, "非符", 171)
    function non_sc:before()
        if ext.sc_pr then
            ToBigScreen(60)
        end
        boss.show_aura(self, false)
        PlaySound("ch02")
        New(boss_cast_darkball, 0, 100, 60, 80, 360, 1, 270, 64, 64, 255, 2)
        New(boss_cast_darkball, 0, 100, 60, 80, 360, 1, 270, 255, 64, 64, -2)
        task.Wait(80)
        self.x, self.y = 0, 100
        boss.show_aura(self, true)
        task.Wait(40)
    end
    function non_sc:init()
        task.New(self, function()
            local col = { 2, 10, 14, 6 }
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            local Ar = 45
            while true do
                for A, i in sp.math.AngleIterator(Ar, 4) do
                    NewSimpleServant(self.x, self.y, 0, 200, 200, 200, 1.5, function(self)
                        task.New(self, function()
                            self:FadeIn(15)
                            object.ChangingSizeColli(self, -0.5, -0.5, 15)
                        end)
                        task.New(self, function()
                            task.MoveToEx(cos(A) * 100, sin(A) * 100, 60, 2)
                            for t = 1, 28 do
                                for a in sp.math.AngleIterator(A, 13) do
                                    Create.bullet_accel(self.x + cos(a) * t * 15, self.y + sin(a) * t * 15, ball_mid, col[i], 1, 2 + t / 10, a)
                                end
                                Create.bullet_dec_acc(self.x, self.y, ball_big, 16, 4, ran:Float(0.8, 2), ran:Float(0, 360))
                                PlaySound("tan00")
                                task.Wait(5)
                            end
                            object.ChangingSizeColli(self, -1, -1, 15)
                            Del(self)
                        end)
                    end)
                end
                for a in sp.math.AngleIterator(ran:Float(0, 360), 30) do
                    for v = 1, 3 do
                        for z = -1, 1 do
                            NewSimpleBullet(grain_b, 4, self.x, self.y, 2.5 - abs(z) * 0.1 + v * 0.6, a + z + v * 6)
                        end
                    end
                end
                PlaySound("tan00")
                task.Wait(60)
                task.MoveToPlayer(90, -220, 200, 100, 160,
                        20, 30, 10, 20, 2, 1)
                task.Wait(120)
                Ar = ran:Float(0, 360)
            end
        end)
    end
    local name1 = "里符「Comfort Zone」"
    local sc1 = boss.card.New(name1, 45, 45, 45, 480)
    boss.card.add({ { sc1, "8a" } }, 15, name1, 172)
    function sc1:before()
        if ext.sc_pr then
            ToBigScreen(60)
            task.MoveTo(0, 120, 60, 2)
        else
            task.Wait(60)
        end
    end
    function sc1:init()
        self._transport = New(Class(object, {
            frame = task.Do,
            init = function(self)
                self.group = GROUP.GHOST
                task.New(self, function()
                    while not self.finish do
                        task.Wait()
                    end
                    if self.getcard then
                        ext.achievement:get(130)
                    end
                    object.RawDel(self)
                end)
            end }, true))
        task.New(self, function()
            _object.set_color(self, "", 255, 120, 120, 120)
            self.colli = false
            Newcharge_in(self.x, self.y, 120, 252, 120)
            task.Wait(90)
            task.New(self, function()
                task.MoveTo(0, 500, 120, 1)
            end)
            local Shooter = Class(object, {
                init = function(self, x, y, v, a, d)
                    object.init(self, x, y, GROUP.INDES, LAYER.ENEMY_BULLET - 1)
                    self.colli = false
                    self.bound = false
                    object.ChangeVAwithTask(self, v / 3, v, a, d * 240, 360, 0, true, 2)
                    task.New(self, function()
                        for _ = 1, 30 do
                            if Dist(self, player) > 32 then
                                local b = Create.bullet_changeangle(self.x, self.y, square, 2, 0.8, self.rot,
                                        { v = 4, r = -9 * d, time = 40 }, { v = 4, r = 10.1 * d, time = 120 }, { wait = 30, r = -1 * d, time = 100 })
                                function b:frame_new()
                                    bullet.frame(self)
                                    self.bound = self.changed
                                end
                            end
                            task.Wait(3)
                        end
                        Del(self)
                    end)
                end,
                frame = task.Do
            }, true)
            local Circle = Class(object, {
                init = function(self, x, y, d)
                    object.init(self, x, y, GROUP.INDES, LAYER.ENEMY_BULLET - 1)
                    self.colli = false
                    self.bound = false
                    self.radius = 0
                    self.alpha = 255
                    self.particle = {}
                    self.pcol = { 135, 206, 235 }
                    task.New(self, function()
                        PlaySound("heal")
                        task.SmoothSetValueTo("radius", 100, 60, 2)
                        task.Wait(10)
                        Newcharge_in(self.x, self.y, 135, 206, 235)
                        task.Wait(60)
                        Newcharge_out(self.x, self.y, 135, 206, 235)
                        self.jump = true
                        misc.ShakeScreen(60, 5, 1, 1.5, 1)
                        for a in sp.math.AngleIterator(0, 7) do
                            New(Shooter, self.x + cos(a) * self.radius, self.y + sin(a) * self.radius, 5, a, d)
                        end
                        task.New(self, function()
                            local r = self.radius - 10
                            local _x, _y
                            local a = ran:Float(0, 360)
                            for i = 1, 20 do
                                local l = r + i * 20
                                for A in sp.math.AngleIterator(a, 12) do
                                    for z = -1, 1, 2 do
                                        local _a = A + z * 3 * i
                                        _x, _y = self.x + cos(_a) * l, self.y + sin(_a) * l
                                        if Dist(_x, _y, player) > 48 then
                                            Create.bullet_accel(_x, _y, arrow_big, 8, 0.6, 3, _a + z * 2 * i)
                                        end
                                    end
                                end
                                PlaySound("tan00")
                                task.Wait(3)
                            end
                        end)
                        local a = ran:Float(0, 360)
                        for _ = 1, 40 do
                            Create.bullet_changeangle(self.x + cos(a) * self.radius, self.y + sin(a) * self.radius,
                                    ball_mid, 14, ran:Float(3, 4), a, false, { v = -0.08, time = 56 },
                                    { wait = 160, v = ran:Float(0.4, 0.8), r = ran:Float(-1, 1), time = 30 })
                            a = a + 9 * d
                            task.Wait()
                        end
                        task.Wait(20)
                        self.jump = false
                        task.SmoothSetValueTo("radius", 0, 60, 1)
                        while #self.particle > 0 do
                            task.Wait()
                        end
                        Del(self)
                    end)
                end,
                frame = function(self)
                    task.Do(self)
                    if self.jump then
                        for _ = 1, 3 do
                            local a = ran:Float(0, 360)
                            local v = ran:Float(3, 8)
                            table.insert(self.particle, {
                                x = self.x + cos(a) * self.radius, y = self.y + sin(a) * self.radius,
                                vx = cos(a) * v, vy = sin(a) * v,
                                alpha = ran:Float(200, 250), timer = 0, lifetime = ran:Int(8, 18),
                                r = self.pcol[1], g = self.pcol[2], b = self.pcol[3]
                            })
                        end
                    end
                    local p
                    for i = #self.particle, 1, -1 do
                        p = self.particle[i]
                        p.x = p.x + p.vx
                        p.y = p.y + p.vy
                        p.vx = p.vx - p.vx * 0.04
                        p.vy = p.vy - p.vy * 0.04
                        if p.timer > p.lifetime then
                            p.alpha = max(p.alpha - 5, 0)
                            if p.alpha == 0 then
                                table.remove(self.particle, i)
                            end
                        end
                        p.timer = p.timer + 1
                    end
                end,
                render = function(self)
                    for _, p in ipairs(self.particle) do
                        SetImageState("bright", "mul+add", p.alpha, p.r, p.g, p.b)
                        Render("bright", p.x, p.y, 0, 10 / 150)
                    end
                    SetImageState("circle_charge", "mul+add", self.alpha, 135, 206, 235)
                    Render("circle_charge", self.x, self.y, 0, self.radius / 256)
                end
            }, true)
            New(Circle, 0, 0, 1)
            task.Wait(540)
            New(Circle, -120, 50, 1)
            task.Wait(480)
            New(Circle, 120, 50, -1)
            task.Wait(420)
            New(Circle, 0, -50, -1)
            task.Wait(360)
            New(Circle, 0, 70, 1)
            task.Wait(300)
            New(Circle, 0, 160, -1)
            task.Wait(200)
            New(Circle, 0, 160, -1)
        end)
    end
    function sc1:del()
        _object.set_color(self, "", 255, 255, 255, 255)
    end

    local name2 = "秘术「岐道里的四季」"
    local sc2 = boss.card.New(name2, 2, 7, 60, 750)
    boss.card.add({ { sc2, "8a" } }, 15, name2, 177)
    function sc2:before()
        if ext.sc_pr then
            ToBigScreen(60)
            task.MoveTo(0, 120, 60, 2)
        else
            task.MoveTo(0, 120, 60, 2)
        end
        Newcharge_in(self.x, self.y, 250, 128, 114)
        task.Wait(60)
    end
    function sc2:init()
        task.New(self, function()
            local s = 45
            local t = 0
            local v = 2
            while true do
                local group1, group2 = {}, {}
                New(_editor_class.PointRender, group1, 360, 111, 255, 227, 132, true)
                New(_editor_class.PointRender, group2, 360, 111, 255, 227, 132, true)
                table.insert(group1, NewSimpleBullet(ball_mid, 14, -195 + sin(s) * 125, 270, v, -90))
                table.insert(group1, NewSimpleBullet(ball_mid, 14, -80 + sin(s) * 80, 270, v + sin(s / 3) * 0.2, -90))

                table.insert(group2, NewSimpleBullet(ball_mid, 14, 195 - sin(s) * 125, 270, v, -90))
                table.insert(group2, NewSimpleBullet(ball_mid, 14, 80 - sin(s) * 80, 270, v + sin(s / 3) * 0.2, -90))
                t = min(t + 1, 90)
                s = s + sin(t) * 6
                v = min(v + 0.05, 5)
                task.Wait(4)
            end
        end)
        task.New(self, function()
            task.Wait(200)

        end)
        task.New(self, function()
            CreateRenderTarget("__effect1")
            local Hue = 0
            for a in sp.math.AngleIterator(ran:Float(0, 360), 30) do
                for v = 1, 3 do
                    Create.bullet_decel(self.x, self.y, ball_big, 6, 5, 1 + v * 0.5, a)
                end
            end
            PlaySound("tan00", 0.1, 0, true)
            task.Wait(260)
            local d = (player.x > 0) and 1 or -1
            Newcharge_in(self.x, self.y, 100, 255, 100)
            task.Wait(60)
            Newcharge_out(self.x, self.y, 200, 200, 200)
            --misc.ShakeScreen(60, 3.5, 1, 2.2, 1)
            NewPulseScreen(5, { 0, 0, 0 }, "", 0, 20, 30)
            local EVENT = {
                function()
                    Hue = 0.95
                    task.MoveTo(180 * d, 120, 60, 2)
                    local k = 1
                    while true do
                        task.New(self, function()
                            task.MoveTo((120 - 60 * k) * d, 120, 180, 3)
                        end)
                        for i = 1, 40 do
                            for a in sp.math.AngleIterator(i * 60 + 30, 3) do
                                Create.bullet_accel(self.x + cos(a) * 30, self.y + sin(a) * 30, grain_a, 4, 0.5, 4, a)

                            end
                            local A = ran:Float(0, 360)
                            Create.bullet_accel(self.x + cos(A) * 30, self.y + sin(A) * 30, grain_a, 2, 1, ran:Float(2.5, 3.5), A)
                            PlaySound("tan00")
                            task.Wait(4)
                        end
                        task.Wait(55)
                        k = -k
                    end

                end,
                function()
                    Hue = -0.55
                    task.MoveTo(120 * d, 120, 60, 2)
                    task.New(self, function()
                        task.Wait(180)
                        while true do
                            task.MoveToPlayer(60, 60 * d, 140 * d, 100, 144,
                                    30, 40, 15, 22, 2, 1)
                            task.Wait(100)
                        end
                    end)
                    while true do
                        for a in sp.math.AngleIterator(ran:Float(0, 360), 26) do
                            NewSimpleBullet(ball_mid, 2, self.x, self.y, 1.3, a)
                        end
                        local a = ran:Float(-70, -110)
                        local w = 33
                        for i = 0, 88 do
                            local A = a + w / 2 + (360 - w) / 88 * i
                            object.SetA(NewSimpleBullet(ball_big, 2, self.x, self.y, 0.3, A), 0.006, A)

                        end
                        PlaySound("tan00")
                        task.Wait(100)
                    end
                end,
                function()
                    Hue = 0.05
                    task.MoveTo(120 * d, 120, 60, 2)
                    NewSimpleServant(self.x, self.y, 0, 200, 200, 200, 1.5, function(self)
                        self.group = GROUP.INDES
                        task.New(self, function()
                            self:FadeIn(15)
                            object.ChangingSizeColli(self, -0.5, -0.5, 15)
                        end)
                        task.New(self, function()
                            task.MoveTo(-320 * d, 0, 120, 2)
                            task.New(self, function()
                                while true do
                                    for a in sp.math.AngleIterator(ran:Float(0, 360), 30) do
                                        Create.bullet_accel(self.x, self.y, ellipse, 8, 1, 5, a)
                                    end
                                    task.Wait(150)
                                end
                            end)
                            local r = 0
                            while true do
                                for a in sp.math.AngleIterator(90 - 90 * d + sin(r) * 20 + 15, 12) do
                                    Create.bullet_accel(self.x, self.y, grain_b, 8, 4.5, 8, a).fogtime = 0
                                end
                                PlaySound("tan00", 0.1, 0, true)
                                r = r + 5.1
                                task.Wait(3)
                            end
                        end)
                    end)
                    task.New(self, function()
                        task.Wait(180)
                        while true do
                            task.MoveToPlayer(60, 60 * d, 140 * d, 100, 144,
                                    30, 40, 15, 22, 2, 1)
                            task.Wait(100)
                        end
                    end)
                end,
                function()
                    Hue = -0.4
                    task.MoveTo(120 * d, 120, 60, 2)
                    task.New(self, function()
                        task.Wait(180)
                        while true do
                            task.MoveToPlayer(60, 60 * d, 180 * d, 100, 144,
                                    30, 40, 15, 22, 2, 1)
                            task.Wait(100)
                        end
                    end)
                    local func = function()
                        local self = task.GetSelf()
                        while true do
                            local x = self.x + cos(self.rot) * (self.l1 + self.l2 + self.l3)
                            if d == 1 then
                                if x <= -320 then
                                    break
                                end
                            else
                                if x >= 320 then
                                    break
                                end
                            end
                            task.Wait()
                        end
                        local b = NewSimpleBullet(ball_huge, 8,
                                -320 * d, self.y + sin(self.rot) * (self.l1 + self.l2 + self.l3), 0.1, 90 - 90 * d)
                        b.ax = 0.02 * d
                        b.maxv = 2.5
                    end
                    while true do
                        for a in sp.math.AngleIterator(Angle(self, player), 14) do
                            task.New(Create.laser_line(self.x, self.y, 8, 4.5, a, 44, 8, 8, 8), func)
                        end
                        task.Wait(100)
                        for a in sp.math.AngleIterator(ran:Float(0, 360), 22) do
                            for v = 1, 2 do
                                Create.bullet_decel(self.x, self.y, ball_big, 8, 5, 1.3 + v * 0.5, a)
                            end
                        end
                        PlaySound("tan00")
                        task.Wait(100)
                    end
                end
            }
            local state = { { 1, 4 }, { 2, 3 }, { 3, 2 }, { 4, 1 } }
            self.effect_bottom = New(Class(object, {
                init = function(self)
                    self.group = GROUP.GHOST
                    self.layer = LAYER.BG -5
                end,
                render = function()
                    PushRenderTarget("__effect1")
                    RenderClear(Color(0, 0, 0, 0))
                end
            }, true))
            self.effect_top = New(Class(object, {
                init = function(self)
                    self.group = GROUP.GHOST
                    self.layer = LAYER.TOP + 5
                end,
                render = function()
                    PopRenderTarget("__effect1")
                    PostEffect("fx:color_set", "__effect1", 6, "", {
                        { Hue, 1.0, 1.0, 0.0 }, -- Hue, flag, open, 未使用
                    }, {})
                end
            }, true))
            EVENT[state[lstg.var.seasonid][d / 2 + 1.5]]()


        end)
    end
    function sc2:del()
        if IsValid(self.effect_bottom) then
            Del(self.effect_bottom)
        end
        if IsValid(self.effect_bottom) then
            Del(self.effect_top)
        end
        NewPulseScreen(5, { 0, 0, 0 }, "", 0, 20, 30)
    end
end

do
    boss.Define("9a", "摩多罗隐岐奈", "TH16_1", TH16_bg, { 0, 500 }, class.SCBG6, "Okina2", 15)
    local non_sc = boss.card.New("", 1, 2, 30, 700)
    boss.card.add({ { non_sc, "9a" } }, 15, "非符", 197)
    function non_sc:before()
        if ext.sc_pr then
            ToBigScreen(60)
        end
        boss.show_aura(self, false)
        PlaySound("ch02")
        New(boss_cast_darkball, 0, 100, 60, 80, 360, 1, 270, 64, 64, 255, 2)
        New(boss_cast_darkball, 0, 100, 60, 80, 360, 1, 270, 255, 64, 64, -2)
        task.Wait(80)
        self.x, self.y = 0, 100
        boss.show_aura(self, true)
        task.Wait(40)
    end
    function non_sc:init()
        task.New(self, function()
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)

            local d = 1
            while true do
                local rot = 0
                task.New(self, function()
                    task.Wait(60)
                    task.MoveToPlayer(90, -220, 200, 100, 160,
                            20, 30, 10, 20, 2, 1)
                end)
                for i = 1, 64 do
                    for a in sp.math.AngleIterator(rot, 2) do
                        for t = 1, 3 do
                            local A = a + t * 2 * d
                            NewSimpleBullet(grain_b, 10,
                                    self.x + cos(A) * 30, self.y + sin(A) * 30,
                                    3 + t * 0.7 - i / 64 * 2, A).fogtime = 5
                        end
                        local b = Create.bullet_changeangle(self.x, self.y, ball_mid, 8, 3 - i / 64 * 2, -a,
                                { r = -0.5 * d, time = 180, wait = 40 })
                        b.fogtime = 5
                        b._blend = "mul+add"
                    end
                    rot = rot + (18 - 18 * (i / 64)) * d
                    PlaySound("tan00")
                    task.Wait(3)
                end
                d = -d
                for a in sp.math.AngleIterator(Angle(self, player), 28) do
                    Create.laser_line(self.x, self.y, 2, 5, a, 60, 8, 8, 8)
                end
                task.Wait(60)
            end
        end)

    end
    local name1 = "秘符「COMFORT ZONE」"
    local sc1 = boss.card.New(name1, 2, 5, 60, 900)
    boss.card.add({ { sc1, "9a" } }, 15, name1, 178)
    function sc1:before()
        if ext.sc_pr then
            ToBigScreen(60)
            task.MoveTo(0, 120, 60, 2)
        else
            task.Wait(60)
        end
    end
    function sc1:init()

        task.New(self, function()
            Newcharge_in(0, 120, 250, 128, 114)
            task.MoveTo(0, 120, 60, 2)
            task.Wait(60)
            local bullet_class = _editor_class.TH14.sejia2
            local A = ran:Float(0, 360)
            local d = 1
            while true do
                for r = 1, 15 do
                    local group = {}
                    New(_editor_class.PointRender, group, 360, 50, 189, 252, 201)
                    for a in sp.math.AngleIterator(A, 30) do
                        local b = New(bullet_class, grain_b, 8, 10, self.x, self.y,
                                cos(a) * 2.5, sin(a) * 2.5, task.SetMode[1](r / 15) * 20 * d, 0, 0, task.SetMode[4](r / 15) * 150 - 25, 37 + r)
                        table.insert(group, b)
                        task.New(b, function()
                            local self = task.GetSelf()
                            for _ = 1, 300 do
                                self.bound = false
                                task.Wait()
                            end
                            self.bound = true
                        end)
                    end
                end
                for k = 1, 6 do
                    local v = 1.4 + k * 0.2
                    for a in sp.math.AngleIterator(A, 30) do
                        New(bullet_class, ball_mid, 2, 2, self.x, self.y, cos(a) * v, sin(a) * v, d * (30 - k * 5 + 90), 0, 120, 0, 37 + k)
                        NewSimpleBullet(ball_mid, 6, self.x, self.y, v + 2, a)
                    end
                end
                PlaySound("tan00", 0.1, 0, true)
                task.Wait(60)
                task.MoveToPlayer(90, -220, 200, 100, 160,
                        20, 30, 10, 20, 2, 1)
                for r = 1, 7 do
                    for a in sp.math.AngleIterator(r * 6 * d, 12) do
                        NewSimpleBullet(ball_mid_c, 14, self.x, self.y, 1 + r * 0.2, a)
                    end
                end
                PlaySound("tan00", 0.1, 0, true)
                d = -d
                task.Wait(120)
            end
        end)
    end
end

do
    boss.Define("10a", "丁礼田舞", "TH16_1", TH16_bg, { 300, 500 }, class.SCBG6, "Mai", 15)
    boss.Define("10b", "尔子田里乃", "TH16_1", TH16_bg, { -300, 500 }, class.SCBG6, "Satono", 15)
    boss.Define("10c", "摩多罗隐岐奈", "TH16_1", TH16_bg, { 0, 500 }, class.SCBG6, "Okina2", 15)
    local name = "「四季的交谊舞」"
    local sc1 = boss.card.New(name, 1, 8, 120, 2600)
    local sc2 = boss.card.New(name, 1, 8, 120, 2600)
    local sc3 = boss.card.New(name, 1, 8, 120, 2600)
    boss.card.add({ { sc1, "10a" }, { sc2, "10b" }, { sc3, "10c" } }, 15, name, 179)
    sc1.frame = boss.card.PublicHP
    sc2.frame = boss.card.PublicHP
    sc3.frame = boss.card.PublicHP
    function sc1:before()
        if ext.sc_pr then
            ToBigScreen(60)
        end
        task.MoveTo(250, 50, 90, 2)
    end
    function sc2:before()
        task.MoveTo(-250, 50, 90, 2)
    end
    function sc3:before()
        task.MoveTo(0, 140, 90, 2)
    end
    function sc1:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 189, 252, 201)
            task.Wait(60)
            boss.cast(self, 10000)
            task.New(self, function()
                task.Wait(60)
                local s, t = 0, 0
                while true do
                    self.y = 50 + sin(s * 0.4) * 100
                    s = s + sin(t)
                    t = min(t + 1, 90)
                    task.Wait()
                end
            end)
            while true do
                for a in sp.math.AngleIterator(sin(self.timer / 2) * 10 + 15, 12) do
                    NewSimpleBullet(arrow_big, 10, self.x, self.y, 5.5, a, nil, 0, false).fogtime = 5
                end
                PlaySound("tan00", 0.2, 0, true)
                task.Wait(5)
            end
        end)
    end
    function sc2:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 218, 112, 214)
            task.Wait(60)
            boss.cast(self, 10000)
            task.New(self, function()
                task.Wait(60)
                local s, t = 0, 0
                while true do
                    self.y = 50 - sin(s * 0.7) * 100
                    s = s + sin(t)
                    t = min(t + 1, 90)
                    task.Wait()
                end
            end)
            while true do
                for a in sp.math.AngleIterator(-sin(self.timer / 2) * 10 + 15, 12) do
                    NewSimpleBullet(arrow_big, 4, self.x, self.y, 5.5, a, nil, 0, false).fogtime = 5
                end
                PlaySound("tan00", 0.2, 0, true)
                task.Wait(5)
            end
        end)
    end
    function sc3:init()
        self._transport = New(Class(object, {
            frame = task.Do,
            init = function(self)
                self.group = GROUP.GHOST
                task.New(self, function()
                    while not self.finish do
                        task.Wait()
                    end
                    if self.getcard then
                        ext.achievement:get(129)
                    end
                    object.RawDel(self)
                end)
            end }, true))
        self._bosssys:addAutoSPPoint(600, 60 * 20)
        self._bosssys:addAutoSPPoint(1200, 60 * 45)
        self._bosssys:addAutoSPPoint(1600, 60 * 70)
        local max_spPoint = #self._sp_point_auto
        task.New(self, function()
            task.Wait(180)
            task.New(self, function()
                while true do
                    local b = NewSimpleBullet(ellipse, 6, ran:Float(-320, 320), 270, 0.4, -90 + ran:Float(-1, 1))
                    b.maxv = 3.4
                    b.ag = 0.02
                    task.Wait(12)
                end
            end)

        end)
        task.New(self, function()
            while #self._sp_point_auto >= max_spPoint do
                task.Wait()
            end
            Newcharge_in(self.x, self.y, 255, 227, 132)
            PlaySound("explode")
            task.New(self, function()
                task.Wait(180)
                while true do
                    task.MoveToPlayer(90, -100, 100, 100, 160,
                            40, 50, 30, 40, 2, 1)
                    task.Wait(70)
                end
            end)
            task.Wait(60)
            local d = 1

            while true do
                local A = ran:Float(0, 360)
                for r = 1, 8 do
                    for a in sp.math.AngleIterator(A + r * 3.6 * d, 10) do
                        Create.bullet_decel(self.x, self.y, grain_a, 14, 4, 2 - r / 8, a)
                    end
                    PlaySound("tan00")
                    task.Wait(5)

                end
                d = -d
                task.Wait(100)
            end
        end)
        task.New(self, function()
            while #self._sp_point_auto >= max_spPoint - 1 do
                task.Wait()
            end
            Newcharge_in(self.x, self.y, 255, 227, 132)
            PlaySound("explode")
            task.Wait(60)
            while true do
                for a in sp.math.AngleIterator(Angle(self, player), 15) do
                    sakura_big.New(self.x, self.y, ran:Float(0, 360), ran:Sign(), 1, a)
                end
                task.Wait(150)
            end
        end)
        task.New(self, function()
            while #self._sp_point_auto >= max_spPoint - 2 do
                task.Wait()
            end
            object.BulletDo(function(b)
                Del(b)
            end)
            Newcharge_in(self.x, self.y, 255, 227, 132)
            PlaySound("explode")
            task.Wait(60)
            while true do
                Create.bullet_accel(self.x, self.y, ball_light, 8, 1, 5, Angle(self, player))
                task.Wait(60)
            end
        end)
    end
end