local class = {}
_editor_class.TH17 = class
local cos, sin, abs, min, max, int = cos, sin, abs, min, max, int
local bullet, object,  boss = bullet, object, boss
local task, ran, Create, misc, sp = task, ran, Create, misc, sp
local table = table
local GROUP, LAYER = GROUP, LAYER
local New = New
local NewSimpleBullet = NewSimpleBullet
local PlaySound = PlaySound
local SetImageState = SetImageState
local Dist, Angle = Dist, Angle
local Render = Render
local Class = Class
local Newcharge_in, Newcharge_out = Newcharge_in, Newcharge_out
local servant = SimpleServant

do
    LoadImageGroupFromFile("EikaStone", "mod\\GAME\\Stone2.png", nil, 2, 1, 13, 13)
    LoadAniFromFile("Hanakan", "mod\\GAME\\Hanakan.png", nil, 3, 1, 10, 8, 8)

end

do
    class.SCBG1 = Class(_SC_BG)
    function class.SCBG1:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th17_1", true, 0, 0, 0,
                0, 0.8, 0, "mul+rev")
        b.a = 250
        b = _SC_BG.AddLayer(self, "th17_0", false, 0, 0, 0,
                0, 0, -0.2, "mul+rev", 1.5, 1.5)
        b.a = 150
        b = _SC_BG.AddLayer(self, "th16_0", true, 0, 0, 0, 0, 0.8, 0, "")
        b.a = 70
        b.g = 70
        b.b = 70
        b = _SC_BG.AddLayer(self, "th16_0", true, 0, 0, 0, 0, 1.2, 0, "", 0.9, 0.9)
        b.a = 70
        b.g = 70
        b.b = 70
        b = _SC_BG.AddLayer(self, "th17_2", true, 0, 0, 0, 0, 0, 0.2)

        -- b.a = 150

    end

    class.SCBG2 = Class(_SC_BG)
    function class.SCBG2:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th17_3", true, 0, 0, 0, 0, 0, -0.2, "mul+add")
        b.a = 80
        b = _SC_BG.AddLayer(self, "th17_1", true, 0, 0, 0,
                0, 0.8, 0, "mul+rev")
        b.a = 250
        b = _SC_BG.AddLayer(self, "th17_2", true, 0, 0, 0, 0, 0, 0.2, "mul+rev")
        b.a = 150
        b = _SC_BG.AddLayer(self, "th17_4", true, 0, 0, 0, 0, 0.6, 0)
        b.r, b.g, b.b = 100, 100, 100
        -- b.a = 150

    end

    class.SCBG3 = Class(_SC_BG)
    function class.SCBG3:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th17_6", true, 0, 0, 0, 0, 0.4, 0, "mul+add")
        b.a = 175
        b = _SC_BG.AddLayer(self, "img_void")
        function b:Beforerender()
            _SC_BG.PolarCoordinatesRender("th17_11", 0, 0, 0, 500,
                    180, 512, 1, -self.timer * 0.74, "mul+rev",
                    Color(self._cur_alpha * 60, 120, 120, 120))
        end
        b = _SC_BG.AddLayer(self, "img_void")
        function b:Beforerender()
            _SC_BG.PolarCoordinatesRender("th17_12", 0, 0, 0, 500,
                    180, 512, 1, self.timer * 0.74, "mul+rev",
                    Color(self._cur_alpha * 60, 120, 120, 120))
        end
        b = _SC_BG.AddLayer(self, "th17_13", true, 0, 0, 0, 0, 0.5)
        b.a = 100

        b = _SC_BG.AddLayer(self, "th17_5", true, 0, 0, 0, 0, -0.4)
        b.r, b.g, b.b = 110, 110, 110

        -- b.a = 150

    end

    class.SCBG4 = Class(_SC_BG)
    function class.SCBG4:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "img_void")
        function b:Beforerender()
            _SC_BG.PolarCoordinatesRender("th17_9", 0, 120, 0, 500,
                    -self.timer / 3, 512, 2, self.timer, "mul+add",
                    Color(self._cur_alpha * 100,
                            150 + sin(self.timer) * 100,
                            150 + sin(self.timer / 2) * 100,
                            150 + sin(self.timer / 3) * 100))
        end
        b = _SC_BG.AddLayer(self, "th17_8", true, 0, 0, 0, 0.5, -0.5, 0, "mul+rev")
        b.a = 180
        b = _SC_BG.AddLayer(self, "th17_7", true, 0, 0, 0, 0, 0.3, 0, "")
        b.a = 175
        b.r, b.g, b.b = 180, 180, 180

        b = _SC_BG.AddLayer(self, "th17_10")
        b.r, b.g, b.b = 180, 180, 180

    end
end--scbg

do
    boss.Define("1a", "戎璎花", "TH17_0", TH17_bg, { -300, 400 }, class.SCBG1, "Eika", 17)
    boss.Define("1b", "牛崎润美", "TH17_0", TH17_bg, { 300, 400 }, class.SCBG1, "Urumi", 17)
    local non_sc1 = boss.card.New("", 1, 2, 60, 600)
    local non_sc2 = boss.card.New("", 1, 2, 60, 600)
    boss.card.add({ { non_sc1, "1a" }, { non_sc2, "1b" } }, 17, "非符", 189)
    function non_sc1:before()
        boss.ns_group.init(self)
        task.MoveTo(-70, 100, 60, 2)
    end
    non_sc1.del = boss.ns_group.del
    function non_sc2:before()
        boss.ns_group.init(self)
        task.MoveTo(70, 100, 60, 2)
    end
    non_sc2.del = boss.ns_group.del

    function non_sc1:init()
        local para = { r = 145, wait = 100, k = 38, t = 3 }
        task.New(self, function()
            boss.violent(self)
            para = { r = 175, wait = 60, k = 45, t = 6 }
        end)
        task.New(self, function()
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            local d = 1
            while true do
                task.Wait(para.wait)
                boss.cast(self, 90)
                local T = 10
                local A = ran:Float(0, 360)
                for i = 1, para.k do
                    local l = sin(i * 2) * para.r
                    for a in sp.math.AngleIterator(A + i * 38 * d, 14) do
                        Create.bullet_dec_acc(self.x + cos(a) * l, self.y + sin(a) * l,
                                grain_b, 6, 2, 4.5, a)
                    end
                    PlaySound("tan00")
                    task.Wait(T)
                    T = max(T - 1, 2)
                end
                task.New(self, function()
                    for _ = 1, para.t do
                        for a in sp.math.AngleIterator(Angle(self, player), 15) do
                            Create.bullet_decel(self.x, self.y, ball_big, 16, 3, 1.7, a, true, false)
                        end
                        PlaySound("tan00")
                        task.Wait(20)
                    end
                end)
                task.Wait(60)

                task.MoveTo(-self.x, self.y, 60, 2)
                task.Wait()
                d = -d
            end
        end)
    end
    function non_sc2:init()
        local para = { r = 145, wait = 100, k = 38, t = 3 }
        task.New(self, function()
            boss.violent(self)
            para = { r = 10, wait = 60, k = 45, t = 12 }
        end)
        task.New(self, function()
            Newcharge_in(self.x, self.y, 255, 227, 132)
            task.Wait(60)
            local d = 1
            while true do
                boss.cast(self, 90)
                local T = 10
                local A = ran:Float(0, 360)
                for i = 1, para.k do
                    local l = 75 - task.SetMode[1](i / 38) * para.r
                    for a in sp.math.AngleIterator(A - i * 38 * d, 14) do
                        Create.bullet_dec_acc(self.x + cos(a) * l, self.y + sin(a) * l,
                                grain_a, 14, 2, 4.5 + i / 38, a)
                    end
                    PlaySound("tan00")
                    task.Wait(T)
                    T = max(T - 1, 2)
                end
                task.Wait(para.wait)

                task.Wait(60)
                task.New(self, function()
                    for _ = 1, para.t do
                        for a in sp.math.AngleIterator(Angle(self, player), 15) do
                            Create.bullet_accel(self.x, self.y, ball_huge, 8, 1, 4, a, true, false)
                        end
                        PlaySound("tan00")
                        task.Wait(20)
                    end
                end)
                task.MoveTo(-self.x, self.y, 60, 2)
                task.Wait()
                d = -d
            end
        end)
    end

    local name = "石符「沉沦的垒石」"
    local sc1 = boss.card.New(name, 2, 2, 60, 650)
    local sc2 = boss.card.New(name, 2, 2, 60, 500)
    boss.card.add({ { sc1, "1a" }, { sc2, "1b" } }, 17, name, 181)
    function sc1:before()
        boss.ns_group.nextcard(self, 0, 400)
        task.MoveTo(-50, 120, 60, 2)
    end
    function sc2:before()
        boss.ns_group.nextcard(self, 0, 400)
        task.MoveTo(50, 120, 60, 2)
    end
    function sc1:init()
        local stone = Class(enemy, {
            init = function(self, v, x, y, mx, my)
                enemybase.init(self, 69)
                self.death_ef = 1
                self.img = "EikaStone" .. ran:Int(1, 2)
                object.SetSizeColli(self, 1.5)
                self.x, self.y = x, y
                self._a, self._r, self._g, self._b = 0, 255, 255, 255
                self.vy = -v
                self.isstone = true
                self.irot = ran:Float(-20, 20)
                self.rotp = ran:Float(1.3, 2) * ran:Sign()

                task.New(self, function()
                    task.MoveToEx(mx - x, my - y, 60, 2)
                end)
                task.New(self, function()
                    for i = 1, 30 do
                        i = task.SetMode[2](i / 30)
                        object.SetSizeColli(self, 1.5 - 0.5 * i)
                        self._a = 255 * i
                        task.Wait()
                    end
                end)
            end,
            frame = function(self)
                task.Do(self)
                self.rot = self.irot + sin(self.timer * self.rotp) * 8
                enemybase.frame(self)
                if self.dmgt and self.dmgt > 0 then
                    self.dmgt = self.dmgt - 1
                end
                if self.y < -224 then
                    for _ = 1, 6 do
                        Create.bullet_dec_acc(self.x, -224, ball_mid, 14, ran:Float(3, 4),
                                ran:Float(3, 4), ran:Float(0, 180), true, false)
                    end
                    for a in sp.math.AngleIterator(Angle(self, player), 12) do
                        Create.bullet_accel(self.x, -224, arrow_big_c, 8, 0.3, 2.6, a, true, false)
                    end
                    NewBon(self.x, self.y, 60, 128, 255, 227, 132)
                    object.Kill(self)
                end
            end,
            render = function(self)
                SetImgState(self, "", self._a, self._r, self._g, self._b)
                DefaultRenderFunc(self)
            end
        }, true)
        task.New(self, function()

            local d = 1
            task.Wait(60)
            while true do
                Newcharge_in(self.x, self.y, 255, 227, 132)
                task.Wait(60)
                Newcharge_out(self.x, self.y, 250, 128, 114)
                boss.cast(self, 100)
                for k = -4, 4 do
                    object.Connect(self, New(stone, ran:Float(0.2, 0.3), self.x, self.y, k * 45, self.y), 0.5, true)

                end
                task.Wait(60)
                task.New(self, function()
                    task.Wait(60)
                    task.MoveTo(-self.x, self.y, 60, 2)
                end)
                for _ = 1, 5 do
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 15) do
                        Create.bullet_changeangle(self.x, self.y, ball_big, 6, 3, a, false,
                                { r = 0.2 * d, time = 60, v = 2 }, { r = 0.8 * d, time = 180, v = 4 })
                    end
                    PlaySound("tan00")
                    d = -d
                    task.Wait(23)
                end
                task.Wait(60)
                task.Wait(180)
            end

        end)
        task.New(self, function()
            boss.violent(self)
            task.Wait(60)
            task.Clear(self, true)
            object.EnemyDo(function(e)
                if e.isstone then
                    object.Kill(e)
                end
            end)
            task.New(self, function()
                while true do
                    task.Wait(60)
                    task.MoveToPlayer(60, -96, 96, 100, 144,
                            20, 40, 10, 20, 2, 1)
                    task.Wait(60)
                end
            end)
            task.New(self, function()
                local d = 1
                while true do
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 13) do
                        Create.bullet_changeangle(self.x, self.y, ball_big, 6, 3, a, false,
                                { r = 0.2 * d, time = 60, v = 2 }, { r = 0.8 * d, time = 180, v = 4 })
                    end
                    PlaySound("tan00")
                    d = -d
                    task.Wait(45)
                end
            end)
            while true do
                for k = -3, 3 do
                    object.Connect(self, New(stone, ran:Float(1, 1.2), self.x, self.y, k * 60, self.y), 0.5, true)

                end
                task.Wait(160)
            end
        end)

    end
    function sc2:init()
        task.New(self, function()
            task.Wait(60)
            while true do
                task.Wait(60)

                task.Wait(60)
                task.Wait(60)
                task.MoveTo(-self.x, self.y, 60, 2)
                Newcharge_in(self.x, self.y, 250, 128, 114)
                task.Wait(60)
                misc.ShakeScreen(30, 1.5)
                Newcharge_out(self.x, self.y, 189, 252, 201)
                boss.cast(self, 60)
                object.EnemyDo(function(e)
                    if e.isstone then
                        NewWave(e.x, e.y, 2, 69, 30, 255, 227, 132)
                        e._b = 150
                        e.ag = ran:Float(0.06, 0.09)
                    end
                end)
                local _a = Angle(self, player)
                for c = 1, 6 do
                    for k = -1, 1, 2 do
                        local A = _a + 180 * k * (6 - c) / 6
                        for i = 1, 3 do
                            for _ = 1, 2 do
                                Create.bullet_decel(self.x + ran:Float(-30, 30), self.y + ran:Float(-30, 30), grain_a,
                                        ran:Int(13, 14), 12 - i * 1.3, 3 - i * 0.4, A + ran:Float(-10, 10), true, false)
                            end
                            Create.bullet_decel(self.x + ran:Float(-10, 10), self.y + ran:Float(-10, 10), ball_huge,
                                    14, 12 - i * 0.8, 6 - i * 0.8, A + ran:Float(-3, 3), true, false)
                        end
                        PlaySound("tan00")
                    end
                    task.Wait(6)
                end
                task.Wait(180)

            end
        end)
        task.New(self, function()
            boss.violent(self)
            task.Wait(60)
            task.Clear(self, true)
            task.New(self, function()
                while true do
                    task.Wait(60)
                    task.MoveToPlayer(60, -96, 96, 100, 144,
                            20, 40, 10, 20, 2, 1)
                    task.Wait(60)
                end
            end)
            while true do
                for _ = 1, 3 do
                    local _a = Angle(self, player)
                    for c = 1, 6 do
                        for k = -1, 1, 2 do
                            local A = _a + 180 * k * (6 - c) / 6
                            for i = 1, 3 do
                                for _ = 1, 2 do
                                    Create.bullet_decel(self.x + ran:Float(-30, 30), self.y + ran:Float(-30, 30), grain_a,
                                            ran:Int(13, 14), 12 - i * 1.3, 3 - i * 0.4, A + ran:Float(-10, 10), true, false)
                                end
                                Create.bullet_decel(self.x + ran:Float(-10, 10), self.y + ran:Float(-10, 10), ball_huge,
                                        14, 12 - i * 0.8, 6 - i * 0.8, A, true, false)
                            end
                            PlaySound("tan00")
                        end
                        task.Wait(6)
                    end

                end
                task.Wait(55)
            end
        end)
    end
end--boss1

do

    boss.Define("2a", "牛崎润美", "TH17_0", TH17_bg, { 0, 400 }, class.SCBG2, "Urumi", 17)
    boss.Define("2b", "庭渡久侘歌", "TH17_0", TH17_bg, { 0, 400 }, class.SCBG2, "Kutaka", 17)
    local non_sc1 = boss.card.New("", 1, 1, 45, 600)
    local non_sc2 = boss.card.New("", 1, 1, 45, 750)
    boss.card.add({ { non_sc1, "2a" }, { non_sc2, "2b" } }, 17, "非符", 190)
    function non_sc1:before()
        boss.ns_group.init(self)
        task.Wait(60)
    end
    non_sc1.del = boss.ns_group.del
    function non_sc2:before()
        boss.ns_group.init(self)
        task.MoveTo(0, 120, 60, 2)
    end
    non_sc2.del = boss.ns_group.del

    function non_sc1:init()
        task.New(self, function()
            boss.violent(self)
            self.hp = 0
        end)
    end
    function non_sc2:init()
        task.New(self, function()
            Newcharge_in(self.x, self.y, 255, 227, 132)
            task.Wait(60)
            local d = 1
            while true do
                boss.cast(self, 120)
                task.New(self, function()
                    task.Wait(40)
                    local rot = ran:Float(-20, 20) - 90
                    for k = 1, 10 do
                        for p = -7, 7 do
                            Create.bullet_dec_acc(self.x, self.y, grain_a, 2, 3, 3.6 + k * 0.16, rot + p * 12)
                        end
                        rot = rot - 1* d
                        PlaySound("tan00")
                        task.Wait(7)
                    end
                end)
                local rot = ran:Float(-20, 20) - 90
                for k = 1, 10 do
                    for p = -8, 8 do
                        Create.bullet_dec_acc(self.x, self.y, grain_a, 14, 3, 3.5 - k * 0.1, rot + p * 10)
                    end
                    rot = rot + 1.6 * d
                    PlaySound("tan00")
                    task.Wait(8)
                end
                task.New(self, function()
                    for _ = 1, 3 do
                        for a in sp.math.AngleIterator(ran:Float(0, 360), 16) do
                            Create.bullet_decel(self.x, self.y, ball_light, 6, 5, 3, a, true, false)
                        end
                        PlaySound("kira00")
                        task.Wait(23)
                    end
                end)
                task.Wait(60)
                task.MoveToPlayer(60, -96, 96, 100, 144,
                        20, 40, 10, 20, 2, 1)
                d = -d
            end
        end)
    end

    local name = "溺战「蝉蜕浊秽之试炼」"
    local sc1 = boss.card.New(name, 2, 3, 60, 900)
    local sc2 = boss.card.New(name, 2, 3, 60, 900)
    boss.card.add({ { sc1, "2a" }, { sc2, "2b" } }, 17, name, 182)
    function sc1:before()
        boss.ns_group.nextcard(self, 0, 400)
        task.MoveTo(-50, 120, 60, 2)
    end
    function sc2:before()
        boss.ns_group.nextcard(self, 0, 400)
        task.MoveTo(50, 120, 60, 2)
    end
    function sc1:init()
        task.New(self, function()
            task.Wait(60)
            local d = 1
            for a in sp.math.AngleIterator(ran:Float(0, 360), 18) do
                Create.bullet_decel(self.x, self.y, ball_light, 14, 3, 2, a, true, false)
            end
            while true do

                PlaySound("tan00")
                task.Wait(130)
                Newcharge_in(self.x, self.y, 189, 252, 201)
                task.Wait(60)
                boss.cast(self, 80)
                local rot = ran:Float(0, 360)
                for v = 1, 16 do
                    local l = 80 - v * 10
                    for a in sp.math.AngleIterator(rot + v * d * 10, 35) do
                        local b = Create.bullet_accel(self.x + cos(a - v * 10) * l, self.y + sin(a - v * 10) * l,
                                grain_a, 14, 0.5, 4, a + ran:Float(-2, 2))
                        b.flag = true
                        b.navi = true
                    end
                    for _ = 1, 10 do
                        local b = Create.bullet_accel(self.x, self.y, ball_light, 14, ran:Float(0.5, 1),
                                ran:Float(3, 3.5), ran:Float(0, 360), true, false)
                        b.flag = true
                    end
                    PlaySound("tan00")
                    task.Wait(5)
                end--80
                task.Wait(40)
                task.MoveTo(-self.x, self.y, 60, 2)
                for v = 1, 16 do
                    for a in sp.math.AngleIterator(rot + v * d * 10, 10) do
                        local b = Create.bullet_accel(self.x, self.y, grain_a, 2, 2, 3.6, a)
                        b.flag = true
                        b.navi = true
                    end
                    PlaySound("tan00")
                    task.Wait(5)
                end
                task.Wait(40)

                d = -d
            end
        end)
    end
    function sc2:init()
        task.New(self, function()
            local big_laser_warning = function(x, y, wait, rot, col)
                local self = NewObject(Class(bullet, {
                    frame = function(self)
                        bullet.frame(self)
                        local l
                        for i = #self.renderline, 1, -1 do
                            l = self.renderline[i]
                            l.time = max(l.time - 1, 0)
                            if l.time == 0 then
                                table.remove(self.renderline, i)
                            end
                        end
                    end,
                    render = function(self)
                        for _, l in ipairs(self.renderline) do
                            SetImageState("white", "mul+add", 100 * l.time / l.maxtime, self.linecol[1], self.linecol[2], self.linecol[3])
                            Render("white", self.x - sin(rot) * l.offx, self.y + cos(rot) * l.offx, rot, 100, 1.6 / 8)
                        end
                    end
                }, true))
                bullet.init(self, ball_huge, col, false, false)
                self.timer = 11
                self._blend = "mul+add"
                self.x, self.y = x, y
                self.colli = false
                self.linecol = ColorList[math.ceil(col / 2)]
                self.renderline = {}
                task.New(self, function()
                    local n = int(wait) - 1
                    for i = 0, n do
                        for z = -1, 1, 2 do
                            table.insert(self.renderline, { offx = z * task.SetMode[2](i / n) * 32, time = 30, maxtime = 30 })
                        end
                        task.Wait()
                    end
                    while #self.renderline > 0 do
                        task.Wait()
                    end
                    object.RawDel(self)
                end)
            end
            local polarb = function(x, y, a, o, r)
                local self = NewObject(bullet)
                bullet.init(self, ball_mid_c, 10, false, true)
                self.x, self.y = x, y
                self.bound = false
                task.New(self, function()
                    local l = 0
                    local t = 0
                    while true do
                        self.x = x + cos(a) * l
                        self.y = y + sin(a) * l
                        l = r * sin(min(t, 90))
                        a = a + o
                        t = t + 1
                        if t >= 180 then
                            r = r + sin(max(0, min(t - 180, 90))) * 5
                        end
                        if t == 240 then
                            self.bound = true
                            local b = Create.bullet_accel(self.x, self.y, ball_mid_c, 10, 0.5, 5, a + 180, true, false)
                            b.bound = false
                            task.New(b, function()
                                task.Wait(180)
                                b.bound = true
                            end)
                        end
                        task.Wait()
                    end
                end)
            end
            task.Wait(60)
            local D = 1
            while true do
                Newcharge_in(self.x, self.y, 255, 227, 132)
                task.Wait(60)
                boss.cast(self, 120)
                servant.init(NewObject(servant), self.x, self.y, 0, 189, 252, 201, 1.5, function(self)
                    task.New(self, function()
                        self:FadeIn(15)
                        object.ChangingSizeColli(self, -0.5, -0.5, 15)
                    end)
                    task.New(self, function()
                        task.MoveTo(ran:Float(60, 120) * D, -100, 60, 2)
                        task.New(self, function()
                            for _ = 1, 5 do
                                NewWave(self.x, self.y, 2, 75, 60, 189, 252, 201)
                                task.Wait(3)
                            end
                        end)
                        big_laser_warning(self.x, 224, 60, -90, 10)
                        task.Wait(60)
                        big_laser_warning(self.x, 224, 60, -90, 16)
                        misc.ShakeScreen(30, 1.5)
                        for d = -1, 1, 2 do
                            for i = 1, 3 do
                                for _ = 1, 2 do
                                    Create.bullet_decel(self.x + ran:Float(-30, 30), self.y + ran:Float(-30, 30), grain_a,
                                            ran:Int(9, 10), 12 - i * 1.3, 3 - i * 0.4, 90 * d + ran:Float(-10, 10), true, false)
                                end
                                Create.bullet_decel(self.x + ran:Float(-20, 20), self.y + ran:Float(-20, 20), ball_huge,
                                        10, 12 - i * 0.8, 6 - i * 0.8, 90 * d + ran:Float(-3, 3), true, false)
                            end
                        end
                        PlaySound("tan00")
                        for d = -1, 1, 2 do
                            for z = -1, 1 do
                                ParticleLaserLine(189, 252, 201, self.x + z * 20, self.y - abs(z) * 10 * d, 10, 18,
                                        -90 * d, 26, 20, 10, 10)
                            end
                        end
                        task.Wait(30)
                        task.New(self, function()
                            for k = 1, 260 do
                                local m = 1 - max(0, k - 200) / 60
                                object.BulletDo(function(b)
                                    if b.flag then
                                        if Dist(b, self) < 120 then
                                            local v = (120 - Dist(b, self)) * 0.1 * m
                                            local A = Angle(self, b)
                                            b.x = b.x + cos(A) * v
                                            b.y = b.y + sin(A) * v
                                        end
                                    end
                                end)
                                task.Wait()
                            end
                        end)
                        local d = D
                        for i = 1, 15 do
                            i = i * d
                            for a = 0, 180, 180 do
                                polarb(self.x, self.y, i * 180 / 15 + a + 0.6 * 4 * i, 0.6 * d, 100)
                            end
                            PlaySound("tan00")
                            task.Wait(4)
                        end
                        task.Wait(180)
                        self:FadeOut(15)
                        object.ChangingSizeColli(self, -1, -1, 15)
                        Del(self)
                    end)
                end)
                task.Wait(180)
                for _ = 1, 5 do
                    for a in sp.math.AngleIterator(Angle(self, player), 25) do
                        Create.bullet_decel(self.x, self.y, ball_mid, 2, 4, 2.15, a, true, false)
                        Create.bullet_decel(self.x, self.y, arrow_big, 2, 4, 2.2, a, true, false)
                    end
                    PlaySound("tan00", 0.1, 0, true)
                    task.Wait(18)
                end

                task.MoveTo(-self.x, self.y, 60, 2)
                task.Wait(120)
                D = -D
            end
        end)
    end
    sc1.frame = boss.card.PublicHP
    sc2.frame = boss.card.PublicHP
end--boss2

do

    boss.Define("3a", "吉吊八千慧", "TH17_0", TH17_bg, { -400, -300 }, class.SCBG3, "Yachie", 17)
    boss.Define("3b", "骊驹早鬼", "TH17_0", TH17_bg, { 400, 100 }, class.SCBG3, "Saki", 17)

    local non_sc1 = boss.card.New("", 1, 2, 60, 411)
    local non_sc2 = boss.card.New("", 1, 2, 60, 600)
    boss.card.add({ { non_sc1, "3a" }, { non_sc2, "3b" } }, 17, "非符", 191)
    function non_sc1:before()
        boss.ns_group.init(self)
        task.Wait(60)
    end
    non_sc1.del = boss.ns_group.del
    function non_sc2:before()
        boss.ns_group.init(self)
        task.MoveTo(0, 120, 60, 2)
    end
    non_sc2.del = boss.ns_group.del

    function non_sc1:init()
        task.New(self, function()
            boss.violent(self)
            while true do
                for a in sp.math.AngleIterator(Angle(self, player), 10) do
                    Create.bullet_accel(self.x, self.y, ball_big, 6, 0.7, 2.5, a, true, false)
                end

                task.Wait(45)
            end
        end)
        task.New(self, function()
            task.Wait(60)
            local d = 1
            while true do
                task.New(self, function()

                    for i = 1, 160 do
                        for a in sp.math.AngleIterator(-90 + sin(i * 3) * 150 * d, 5) do
                            Create.bullet_accel(self.x + cos(a) * 15, self.y + sin(a) * 15, grain_b, 10,
                                    0.3, 3.3, a, false, false)
                        end
                        PlaySound('tan00', 0.1, self.x)
                        task.Wait(3)
                    end
                end)
                task.CRMoveTo(500, 0, -d * 120, -150, d * 90, -75, -d * 70, 0, d * 90, 75, -d * 120, 150, -d * 400, 300)
                self.x, self.y = 400 * d, -300
                task.Wait(30)
                d = -d
            end
        end)
    end
    function non_sc2:init()
        local flag = true
        task.New(self, function()
            boss.violent(self)
            flag = false
            while true do
                local v = ran:Float(2, 3)
                for a in sp.math.AngleIterator(Angle(self, player), 25) do
                    Create.bullet_accel(self.x, self.y, grain_a, 14, 4.5, v, a, true, false)
                end
                PlaySound("tan00")
                task.Wait(8)
            end
        end)
        task.New(self, function()

            local sty = { ball_huge, ball_big, ball_mid }
            while true do

                task.Wait(60)
                if flag then
                    boss.cast(self, 240)
                    for k = 1, 3 do
                        for a in sp.math.AngleIterator(ran:Float(0, 360), 18 + k * 4) do
                            Create.bullet_decel(self.x, self.y, sty[k], 2, 4.5, 2.8, a, true, false)
                        end
                        PlaySound("tan00")
                        task.Wait(80)

                    end
                end
                Newcharge_in(self.x, self.y, 255, 227, 132)
                task.Wait(60)
                PlaySound("kira00", 0.3, 0, true)
                Newcharge_out(self.x, self.y, 250, 128, 114, true)
                object.BulletDo(function(obj)
                    task.New(obj, function()
                        local A = Angle(obj, self)
                        for i = 1, 60 do
                            i = sin(i / 60 * 180)
                            obj.x = obj.x + cos(A) * 4 * i
                            obj.y = obj.y + sin(A) * 4 * i
                            task.Wait()
                        end
                    end)
                end)
                task.New(self, function()
                    for v = 7, 1, -1 do
                        for a in sp.math.AngleIterator(ran:Float(0, 360), 35) do
                            Create.bullet_decel(self.x, self.y, arrow_big_c, 2, 3 + v * 0.5, 2 + v * 0.2, a, true, false)
                        end
                        PlaySound("tan00")
                        task.Wait(11)
                    end
                end)

                task.Wait(75)
                task.MoveToPlayer(60, -96, 96, 100, 144,
                        20, 40, 10, 20, 2, 1)
                task.Wait(35)
            end
        end)
    end

    local name = "龟劲「成城断金的追击」"
    local sc1 = boss.card.New(name, 2, 3, 65, 700)
    local sc2 = boss.card.New(name, 2, 3, 65, 700)
    boss.card.add({ { sc1, "3a" }, { sc2, "3b" } }, 17, name, 183)
    function sc1:before()
        boss.ns_group.nextcard(self, 0, 400)
        task.MoveTo(0, 120, 60, 2)
    end
    function sc2:before()
        boss.ns_group.nextcard(self, 0, 400)
        task.MoveTo(100, 100, 60, 2)
    end
    function sc1:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 189, 252, 201)
            task.Wait(60)
            boss.cast(self, 3600)
            PlaySound("boon01")
            local color = { 189, 252, 201 }
            local rotate = 0.0
            local roll_diamond = function(y, vy, offrst, event)
                local self = NewObject(Class(bullet, {
                    frame = function(self)
                        object.smear_add(self, self._a * 0.3)
                        object.smear_frame(self, 12)
                        bullet.frame(self)
                    end,
                    render = function(self)
                        object.smear_render(self, "mul+add", color)
                        OriginalSetImageState(self.img, "mul+add")
                        bullet.render(self)
                    end
                }, true))
                bullet.init(self, diamond, 10, false, false, 0)
                self._blend = "mul+add"
                self._y = y
                self.bound = false
                self._vy = vy
                self._a = 0
                self.f_a = 1
                self.offrst = offrst
                self.rot = -90
                if event then
                    event(self)
                end
                task.New(self, function()
                    while true do
                        local rot = self.offrst
                        self.x = cos(rot) * 190
                        self.y = self._y
                        self._y = self._y + self._vy
                        self.offrst = self.offrst + rotate

                        self.__a = (rot % 360 >= 180) and 50 or 255
                        self._a = self._a + (-self._a + self.__a) * 0.1 * self.f_a
                        self.colli = (self._a > 200)
                        task.Wait()
                    end
                end)
            end
            local pillar_effect = Class(object, {
                init = function(self, offrst, Hue)
                    self.rx, self.ry = 0, 0
                    self.rot = -90
                    self.offrst = offrst
                    self.width = 15
                    self.layer = LAYER.BG + 10
                    self.group = GROUP.INDES
                    self.colli = false
                    self.bound = false
                    self.Hue = Hue
                    self.linew = 1
                    self.S = 0.4
                    self.V = 1
                    self._a = 0
                    self.f_a = 1
                    task.New(self, function()
                        while true do
                            local rot = self.offrst
                            self.x = cos(rot) * 190
                            self.offrst = self.offrst + rotate * 1.2
                            self.__a = (rot % 360 >= 180) and 30 or 130
                            self._a = self._a + (-self._a + self.__a) * 0.1 * self.f_a
                            self.layer = (rot % 360 >= 180) and (LAYER.BG + 10) or (LAYER.ENEMY_BULLET_EF)
                            task.Wait()
                        end
                    end)
                end,
                frame = function(self)
                    task.Do(self)
                end,
                render = function(self)
                    local r, g, b = sp:HSVtoRGB(self.Hue, self.S, self.V)
                    OriginalSetImageState("white", "mul+add",
                            Color(self._a, r, g, b),
                            Color(self._a, r, g, b),
                            Color(0, r, g, b), Color(0, r, g, b))
                    local w = self.width / 2 - self.linew
                    Render("white",
                            self.x + cos(self.rot + 90) * w,
                            self.y + sin(self.rot + 90) * w,
                            self.rot + 180, 100, self.width / 16)
                    Render("white",
                            self.x + cos(self.rot - 90) * w,
                            self.y + sin(self.rot - 90) * w,
                            self.rot, 100, self.width / 16)
                end
            }, true)
            local function CreateDiamond(y, offrst, size)
                for k = size, 1, -1 do
                    local c = (k - 1) / 2
                    if k == size then
                        for z = -c, c do
                            roll_diamond(y, 0, offrst + z * 4.7)
                        end
                    else
                        for z = -c, c do
                            for _y = -1, 1, 2 do
                                roll_diamond(y + _y * 12.8 * (size - k), 0, offrst + z * 4.7)
                            end
                        end
                    end
                end
            end
            local c = {
                { { -145, 60 }, { -133, 77 }, { -190, -156 }, { -90, 23 }, { -45, 46 }, { -20, 37 }, { 70, 150 }, { 78, 188 }, { 90, 75 }, { 123, 180 }, { 150, 200 } },
                { { 145, 60 }, { 0, -74 }, { 0, 74 }, { 40, 180 }, { -70, 60 }, { -50, 240 } },
                { { 180, 45 }, { 120, -74 }, { -30, 0 }, { -100, 160 }, { -50, -60 }, { 20, 190 }, { -20, 165 } },
                { { -180, -80 }, { -100, -30 }, { 40, 90 }, { 100, 170 }, { 130, 110 }, { -130, 200 } },
                { { 100, 220 }, { 210, 230 }, { -100, 270 }, { -200, 20 }, { 150, -17 } },
                { { -110, 120 }, { -224, 70 }, { 150, 20 } },
            }
            for a in sp.math.AngleIterator(27, 8) do
                New(pillar_effect, a, 75)
            end
            for i, p in ipairs(c) do
                for _, k in ipairs(p) do
                    CreateDiamond(k[1], k[2], i)
                end
            end
            task.Wait(30)
            for i = 1, 180 do
                rotate = task.SetMode[1](i / 180) * 0.5
                task.Wait()
            end
            boss.violent(self)
            self.DMG_factor = 0.1
            task.Wait(60)
            for a in sp.math.AngleIterator(27, 8) do
                New(pillar_effect, a, 75)
            end
            PlaySound("boon01")
            rotate = -0.5
            for i, p in ipairs(c) do
                for _, k in ipairs(p) do
                    CreateDiamond(k[1], k[2], i)
                end
            end
            task.New(self, function()
                task.Wait(60)
                self.DMG_factor = 1
            end)
            while true do
                for v = 1, 2 do
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 12) do
                        local b = NewSimpleBullet(ball_huge, 14, self.x, self.y, 1.5 + v * 0.7, a)
                        b.omiga = ran:Float(2, 3) * ran:Sign()
                    end
                end
                PlaySound("tan00")
                task.Wait(85)
            end
        end)
    end
    function sc2:init()
        task.New(self, function()
            boss.violent(self)
            task.New(self, function()
                self.DMG_factor = 0.1
                task.Wait(90)
                self.DMG_factor = 1
            end)
            task.Wait(60)
            while true do
                for a in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                    for v = 0, 1 do

                        local b = NewSimpleBullet(arrow_big_c, 4, self.x, self.y, 2 + v * 0.3, a)
                        b._blend = "mul+add"
                    end
                end
                PlaySound("tan00")
                task.Wait(45)
            end
        end)
        task.New(self, function()
            task.Wait(120)
            while true do
                servant.init(NewObject(servant), self.x, self.y, 0, 250, 128, 114, 1.5, function(unit)
                    task.New(unit, function()
                        unit:FadeIn(15)
                        object.ChangingSizeColli(unit, -0.5, -0.5, 15)
                    end)
                    task.New(unit, function()
                        for _ = 1, 3 do
                            Newcharge_in(unit.x, unit.y, 250, 128, 114)
                            task.Wait(60)
                            for a in sp.math.AngleIterator(Angle(unit, player), 9) do
                                Create.laser_line(unit.x, unit.y, 6, 5, a, 16, 8, 8, 8)
                            end
                            task.New(unit, function()
                                for _ = 1, 20 do
                                    Create.bullet_accel(unit.x, unit.y, ball_mid, 2, 0.5, ran:Float(2.5, 3.5),
                                            ran:Float(0, 360), false, false)
                                    PlaySound("tan00")
                                    task.Wait(3)
                                end
                            end)
                            object.ChangingV(unit, 5, 0, Angle(unit, player), 75, false)

                        end

                        unit:FadeOut(15)
                        object.ChangingSizeColli(unit, -1, -1, 15)
                        Del(unit)
                    end)
                end)
                task.Wait(250)
                task.MoveTo(-self.x, self.y, 80, 2)
                task.Wait(100)
            end
        end)
    end
end--boss3

do

    boss.Define("4a", "杖刀偶磨弓", "TH17_1", TH17_bg, { -400, 200 }, class.SCBG4, "Mayumi", 17)
    boss.Define("4b", "埴安神袿姬", "TH17_1", TH17_bg, { 400, 200 }, class.SCBG4, "Keiki", 17)

    local non_sc1 = boss.card.New("", 1, 2, 60, 800)
    local non_sc2 = boss.card.New("", 1, 2, 60, 800)
    boss.card.add({ { non_sc1, "4a" }, { non_sc2, "4b" } }, 17, "非符", 192)
    function non_sc1:before()
        boss.ns_group.init(self)
        task.MoveTo(00, 50, 60, 2)
    end
    non_sc1.del = boss.ns_group.del
    function non_sc2:before()
        boss.ns_group.init(self)
        task.MoveTo(00, 140, 60, 2)
    end
    non_sc2.del = boss.ns_group.del

    function non_sc1:init()
        task.New(self, function()
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)

            local d = 1
            local c = 180
            while true do
                boss.cast(self, 90)
                for i = 1, 20 do
                    for z = -2, 2 do
                        local A = i * 18 * d
                        local L = z * 25
                        for a in sp.math.AngleIterator(i * 23 * d, 3) do
                            Create.bullet_accel(self.x + cos(A) * L, self.y + sin(A) * L,
                                    arrow_mid, 8, 0.5, 3.5, a + z * 5)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(3)
                end
                task.Wait(60)
                task.MoveTo(cos(c) * 100, 50, 60, 2)
                task.Wait(10)
                c = c + 90
                d = -d
            end
        end)
    end
    function non_sc2:init()
        task.New(self, function()
            Newcharge_in(self.x, self.y, 255, 227, 132)
            task.Wait(60)
            local d = 1
            while true do
                for z = -1, 1 do
                    z = z * d
                    servant.init(NewObject(servant), self.x, self.y, 0, 189, 252, 201, 1.5, function(unit)
                        task.New(unit, function()
                            unit:FadeIn(15)
                            object.ChangingSizeColli(unit, -0.5, -0.5, 15)
                        end)
                        task.New(unit, function()
                            object.ChangingV(unit, 4.5, 0, Angle(self, player) + z * 30, 60, false)
                            for _, vx, vy in sp.math.PolygonIterator2(Angle(unit, player), 24, 0, 0, 3, 4) do
                                Create.bullet_setvxvy(unit.x, unit.y, ball_mid, 2, vx, vy, false)
                                Create.bullet_setvxvy(unit.x, unit.y, grain_a, 2, vx * 0.95, vy * 0.95, false)
                            end
                            PlaySound("tan00")
                            unit:FadeOut(15)

                            object.ChangingSizeColli(unit, -1, -1, 15)
                            Del(unit)
                        end)
                    end)
                    task.Wait(14)
                end
                task.Wait(70)
                for a in sp.math.AngleIterator(Angle(self, player), 22) do
                    for v = 0, 2 do
                        Create.bullet_decel(self.x, self.y, ball_big, 6, 4 - v * 0.3, 2 - v * 0.1, a, true, false)
                    end
                end
                PlaySound("tan00")
                task.MoveToPlayer(60, -96, 96, 100, 144,
                        20, 40, 10, 20, 2, 1)
                d = -d
            end
        end)
    end
    non_sc1.frame = boss.card.PublicHP
    non_sc2.frame = boss.card.PublicHP

    local name = "埴轮「爆破埴轮造型术」"
    local sc1 = boss.card.New(name, 2, 2, 60, 1000)
    local sc2 = boss.card.New(name, 2, 2, 60, 1000)
    boss.card.add({ { sc1, "4a" }, { sc2, "4b" } }, 17, name, 184)
    function sc1:before()
        boss.ns_group.nextcard(self, 0, 400)
        task.MoveTo(-70, 140, 60, 2)
    end
    function sc2:before()
        boss.ns_group.nextcard(self, 0, 400)
        task.MoveTo(0, 50, 60, 2)
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
                        if not self.kill_hanakan then
                            ext.achievement:get(147)
                        elseif self.kill_all_hanakan then
                            ext.achievement:get(148)
                        end
                    end
                    object.RawDel(self)
                end)
            end }, true))
        self._transport.kill_all_hanakan = true
        task.New(self, function()
            local hanakan = Class(enemy, {
                init = function(unit, x, y, v, a, t, hp)
                    enemybase.init(unit, hp)
                    unit.death_ef = 1
                    unit.img = "Hanakan"
                    object.SetSizeColli(unit, 1.5)
                    unit.x, unit.y = x, y
                    unit._a, unit._r, unit._g, unit._b = 0, 255, 255, 255
                    unit.isstone = true
                    unit.irot = 0
                    unit.radius = 0
                    unit.bound = false
                    unit.rotp = ran:Float(1.3, 2) * ran:Sign()
                    task.New(unit, function()
                        local w = lstg.world
                        while BoxCheck(unit, w.boundl, w.boundr, w.boundb, w.boundt) do
                            task.Wait()
                        end
                        self._transport.kill_all_hanakan = false
                        object.RawDel(unit)
                    end)
                    task.New(unit, function()
                        object.ChangingV(unit, v, 0, a, t, false)

                        task.Wait(t)
                        local A = Angle(unit, player)
                        for z = -2, 2 do
                            for bv = 1, 3 do
                                Create.bullet_decel(unit.x, unit.y, arrow_mid, 14, 4, 2 + bv * 0.5, A + z * 15)
                            end
                        end
                        PlaySound("tan00")
                        object.ChangingV(unit, 0, v, a, t, false)
                    end)
                    task.New(unit, function()
                        for i = 1, 30 do
                            i = task.SetMode[2](i / 30)
                            object.SetSizeColli(unit, 1.5 - 0.5 * i)
                            unit._a = 255 * i
                            task.Wait()
                        end
                    end)
                    task.New(unit, function()
                        for i = 1, 30 do
                            i = task.SetMode[2](i / 60)
                            unit.radius = 80 * i
                            task.Wait()
                        end
                    end)
                end,
                kill = function(unit)
                    enemy.kill(unit)
                    NewBon(unit.x, unit.y, 60, 128, 250, 128, 114)
                    New(bomb_bullet_killer, unit.x, unit.y, unit.radius, unit.radius)
                    self._transport.kill_hanakan = true
                end,
                frame = function(self)
                    task.Do(self)
                    self.rot = self.irot + sin(self.timer * self.rotp) * 8
                    enemybase.frame(self)
                    if self.dmgt and self.dmgt > 0 then
                        self.dmgt = self.dmgt - 1
                    end
                end,
                render = function(self)
                    SetImgState(self, "", self._a, self._r, self._g, self._b)
                    DefaultRenderFunc(self)
                    SetImageState("circle_charge", "mul+add", 255, 250, 128, 114)
                    Render("circle_charge", self.x, self.y, 0, self.radius / 256)
                end
            }, true)
            task.Wait(60)
            local d = 1
            while true do
                PlaySound("tan00")
                PlaySound("boon01")
                boss.cast(self, 65)
                local h1 = New(hanakan, self.x, self.y, 3.5, Angle(self, player), 150, 70)
                local h2 = New(hanakan, self.x, self.y, 4, Angle(self, -self.x, self.y), 150, 40)
                object.Connect(self, h1, 0.5, true)
                object.Connect(self, h2, 0.5, true)
                task.New(self, function()
                    for k = 1, 5 do
                        for a in sp.math.AngleIterator(Angle(self, player), 30) do
                            for v = 1, 5 do
                                Create.bullet_decel(self.x, self.y, arrow_big_c, 2, 4,
                                        3 + v * 0.1 - k * 0.3, a + v * (k - 1) * 1 * d)
                            end
                        end
                        d = -d
                        PlaySound("tan00")
                        task.Wait(45)
                    end
                end)
                task.Wait(120 + 3 * 45)
                task.MoveTo(-self.x, self.y, 65, 2)
            end
        end)
    end
    function sc2:init()
        task.New(self, function()
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            local function making(x, y, iv, ia, wait, time, mx, my, v, a)
                local self = NewObject(bullet)
                bullet.init(self, ball_mid, 8, false, true)
                self.x, self.y = x, y
                self._blend = "mul+add"
                object.SetSizeColli(self, 1.3)
                object.SetV(self, iv, ia)
                PlaySound("tan00")
                task.New(self, function()
                    task.Wait(wait)
                    object.StopMoving(self)
                    task.MoveTo(mx, my, time, 2)
                    object.ChangingV(self, 0, v, a, 60)
                end)
            end
            while true do
                local wait = 260
                local ia = ran:Float(0, 360)
                for t = 1, 100 do
                    local a = 360 * 7 / 100 * t + ia
                    --  local float = t * 2
                    for k = 1, 2 do
                        local r = k * 50
                        local floatr = ran:Float(0, t * 2)
                        making(self.x + cos(a) * floatr, self.y + sin(a) * floatr,
                                0.09, ran:Float(0, 360), wait + 1 - t, 60,
                                self.x + cos(a) * r, self.y + sin(a) * r, 4, a)
                    end
                    task.Wait()
                end
                task.Wait(wait - 100 - 60)
                Newcharge_in(self.x, self.y, 128, 255, 128)
                task.Wait(60)
                PlaySound("kira00")
                NewWave(self.x, self.y, 2, 50, 60, 135, 206, 235)
                NewWave(self.x, self.y, 2, 100, 60, 135, 206, 235)
                NewBon(self.x, self.y, 60, 128, 135, 206, 235)
                task.Wait(60)
            end
        end)
    end
    sc1.frame = boss.card.PublicHP
    sc2.frame = boss.card.PublicHP
end--boss4

do
    boss.Define("5a", "埴安神袿姬", "TH17_1", TH17_bg, { 400, 0 }, class.SCBG4, "Keiki", 17)
    local name = "「灵长园的里世界」"
    local sc1 = boss.card.New(name, 38, 38, 38, 750)
    boss.card.add({ { sc1, "5a" } }, 17, name, 209)
    function sc1:before()
        boss.show_aura(self, false)
        PlaySound("ch02")
        New(boss_cast_darkball, 0, 120, 60, 80, 360, 1, 270, 64, 64, 255, 2)
        New(boss_cast_darkball, 0, 120, 60, 80, 360, 1, 270, 255, 64, 64, -2)
        task.Wait(90)
        self.x, self.y = 0, 120
        boss.show_aura(self, true)
        task.Wait(60)
    end
    function sc1:init()
        local interval = 45
        task.New(self, function()
            while not self.flag do
                task.Wait()
            end
            while true do
                Create.bullet_decel(self.x, self.y, ball_huge, 2, 3, 2, Angle(self, player), true, false)
                PlaySound("tan00")
                task.Wait(interval)
            end
        end)
        task.New(self, function()
            task.MoveTo(0, 0, 60, 2)
            self._r, self._g, self._b = 120, 120, 120
            self.colli = false
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            Newcharge_out(self.x, self.y, 135, 206, 235)
            local polar = function(cx, cy, ia, r, da, t)
                local self = NewObject(bullet)
                bullet.init(self, ball_mid, 8, false, true)
                self.x = cx + cos(ia) * r
                self.y = cy + sin(ia) * r
                self.bound = false
                self.wall = true
                task.New(self, function()
                    while true do
                        local slast = 0
                        for i = 1, t do
                            i = i / t
                            ia = ia + da * (i - slast)
                            slast = i
                            task.Wait()
                        end
                    end
                end)
                task.New(self, function()
                    while true do
                        self.x = cx + cos(ia) * r
                        self.y = cy + sin(ia) * r
                        task.Wait()
                    end
                end)
            end
            local A = Angle(self, player)
            local R = 50
            local inc = 16
            for a in sp.math.AngleIterator(A, 20) do
                Create.bullet_dec_acc(self.x, self.y, ball_huge, 2, 4, 4, a, true, false)
            end
            for c = 0, 30 do
                local da = (c % 6 <= 2) and 9 or -9
                for d = -1, 1, 2 do
                    for a in sp.math.AngleIterator(A, 2) do
                        polar(self.x, self.y, a + Angle(0, 0, R, c * d * inc),
                                Dist(0, 0, R, inc * c * d), da, 40)

                    end
                end
                PlaySound("tan00")
                task.Wait(3)
            end
            task.Wait(150)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            self.flag = true
            PlaySound("kira00")
            object.BulletDo(function(b)
                if b.wall then
                    local k = Create.bullet_accel(b.x, b.y, ball_mid, 2, 0.2, 0, Angle(b, player), true, false)
                    k.group = GROUP.INDES
                    Del(b)
                end
            end)
            A = Angle(self, player) + 45
            inc = 14
            for c = 0, 30 do
                local da = (c % 12 <= 5) and 9 or -9
                for d = -1, 1, 2 do
                    for a in sp.math.AngleIterator(A, 4) do
                        polar(self.x, self.y, a + Angle(0, 0, R, c * d * inc),
                                Dist(0, 0, R, inc * c * d), da, 35)

                    end
                end
                PlaySound("tan00")
                task.Wait(3)
            end
            task.Wait(250)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            object.BulletDo(function(b)
                if b.wall then
                    local k = Create.bullet_accel(b.x, b.y, ball_mid, 4, 0.1, 0, Angle(b, player), true, false)
                    k.group = GROUP.INDES
                    Del(b)
                end
            end)
            interval = 35
            task.Wait(60)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            A = Angle(self, player)
            inc = 12
            for c = 0, 30 do
                local da = (c % 6 <= 2) and 9 or -9
                for d = -1, 1, 2 do
                    for a in sp.math.AngleIterator(A, 2) do
                        polar(self.x, self.y, a + Angle(0, 0, R, c * d * inc),
                                Dist(0, 0, R, inc * c * d), da, 33)

                    end
                end
                PlaySound("tan00")
                task.Wait(3)
            end
            task.Wait(450)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            interval = 18
            object.BulletDo(function(b)
                if b.wall then
                    local k = Create.bullet_accel(b.x, b.y, ball_mid, 6, 0, 0, Angle(b, player), true, false)
                    k.group = GROUP.INDES
                    Del(b)
                end
            end)
            task.Wait(240)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            interval = 9
        end)
    end


end--boss5

do
    boss.Define("6a", "骊驹早鬼", "TH17_1", TH17_bg, { 400, 0 }, class.SCBG3, "Saki", 17)
    local name = "劲疾技「野狼的咆哮」"
    local sc1 = boss.card.New(name, 1, 1, 45, 1400)
    boss.card.add({ { sc1, "6a" } }, 17, name, 210)
    function sc1:before()
        if ext.sc_pr then
            ToBigScreen(60)
        end
        boss.show_aura(self, false)
        PlaySound("ch02")
        New(boss_cast_darkball, 0, 120, 60, 80, 360, 1, 270, 64, 64, 255, 2)
        New(boss_cast_darkball, 0, 120, 60, 80, 360, 1, 270, 255, 64, 64, -2)
        task.Wait(90)
        self.x, self.y = 0, 120
        boss.show_aura(self, true)
        task.Wait(60)
    end
    function sc1:frame()
        local v = lstg.var
        if v.beast_charging_time > 0 and v.hyper_mode == 1 then
            self.DMG_factor = -0.05
            ext.achievement:get(150)
        else
            self.DMG_factor = 1
        end
        self.rank = 0
        for _, p in ipairs(lstg.var.beast) do
            if p == 1 then
                self.rank = self.rank + 1
                if self._transport then
                    self._transport.flag1 = true
                end
            end
        end--弹幕根据所获得的红色动物灵的个数变化
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
                    if self.getcard and not self.flag1 then
                        ext.achievement:get(149)

                    end
                    object.RawDel(self)
                end)
            end }, true))
        if SearchStageLevel[11] then
            task.New(self, function()
                NewSimpleServant(0, 0, 0, 250, 128, 114, 1.5, function(unit)
                    unit.omiga = ran:Sign() * ran:Float(2, 3)
                    task.New(unit, function()
                        unit:FadeIn(15)
                        object.ChangingSizeColli(unit, -0.5, -0.5, 15)
                    end)
                end)
                while true do

                    New(Beast.simple, 0, 0, 1)
                    task.Wait(90)
                end
            end)
        end
        task.New(self, function()
            local d = 1
            while true do
                task.New(self, function()
                    task.MoveTo(-300, -70, 45, 2)
                    task.MoveTo(300, -70, 45, 2)
                    task.MoveTo(0, 120, 45, 2)
                    task.Wait(45)
                    task.MoveTo(0, -180, 45, 1)
                    task.MoveTo(0, 120, 90, 2)
                end)

                for _ = 1, 3 do
                    for k = 1, 15 do
                        local A = Angle(self, player)
                        local l = -50 + task.SetMode[2](k / 15 * 2) * 50
                        for a in sp.math.AngleIterator(A, 25) do
                            local b = Create.bullet_dec_acc(self.x + cos(a) * l, self.y + sin(a) * l,
                                    arrow_big_c, 4, 7, 4, a, true, false)
                            b.time1 = 60
                        end
                        PlaySound("tan00")
                        task.Wait(3)
                    end
                    Newcharge_out(self.x, self.y, 250, 250, 250)
                    NewWave(self.x, self.y, 2, 128, 60, 218, 112, 214)
                    task.Wait(45)
                end
                task.Wait(90)
                local R = -90
                task.New(self, function()
                    for k = 1, 15 do
                        local v = 1.7 - k / 15 + min(2.5, self.rank / 3)
                        for a in sp.math.AngleIterator(R + d * (1.95 + self.rank / 9 * 3) * k, 27) do
                            Create.bullet_decel(self.x, self.y, ball_mid, 14, 2, v, a)
                        end
                        task.Wait(3)
                    end
                end)
                for k = 1, 3 do
                    local v = 1.7 - k * 0.2 + min(2.5, self.rank / 2.5)
                    local n = int(20 + self.rank / 2)
                    for a in sp.math.AngleIterator(R + k * 360 / n / 2, n) do
                        Create.bullet_decel(self.x, self.y, ball_huge, 2, 1.5, v, a, true, false)
                    end
                    PlaySound("kira00")
                    task.Wait(15)
                end
                d = -d
                Newcharge_in(self.x, self.y, 250, 128, 114)
                task.Wait(60)
            end
        end)
    end
end--boss6
