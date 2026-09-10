local class = {}
_editor_class.TH15 = class

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
local SearchStageLevel = SearchStageLevel
local Newcharge_in, Newcharge_out = Newcharge_in, Newcharge_out

do
    class.enemy1_ghost = Class(enemy, {
        init = function(self, x, y, v, a)
            enemy.init(self, 28, 12)
            self.x, self.y = x, y
            task.New(self, function()
                task.New(self, function()
                    for C = 1, 5 do
                        Create.bullet_decel(self.x, self.y, ball_mid, 2, 5, 2 + C / 5, a, nil, false)
                        PlaySound("tan00", 0.05, self.x / 100, true)
                        task.Wait(6)
                    end
                end)
                object.ChangingV(self, v, 0, a, 60, false)
                task.Wait(120)
                task.New(self, function()
                    for C = 1, 5 do
                        Create.bullet_decel(self.x, self.y, ball_mid, 2, 5, 3 - C / 5, a + 180, nil, false)
                        PlaySound("tan00", 0.05, self.x / 100, true)
                        task.Wait(6)
                    end
                end)
                object.ChangingV(self, 0, v, a + 180, 90, false)
            end)
        end,
        drop = function(self)
            if SearchStageLevel[7] then
                Astral.drop(self.x, self.y, 3, 1)
            end
            item.Dropitem(item.obj.point, 1, self.x, self.y)
        end
    })
    class.enemy1_butterfly = Class(enemy, {
        init = function(self, x1, y1, x2, y2, x3, y3, d)
            enemy.init(self, 9, 80)
            self.x, self.y = x1, y1
            task.New(self, function()
                task.BezierMoveTo(180, 3, x2, y2, x3, y3)
                task.Wait(120)
                task.SmoothSetValueTo("vx", -d, 60, 0)
            end)
            task.New(self, function()
                while true do
                    task.Wait(90)
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 18) do
                        NewSimpleBullet(ball_big, 4, self.x, self.y, 1.5, a)
                    end
                end
            end)
            task.New(self, function()
                task.Wait(10)
                for _ = 1, 17 do
                    for a in sp.math.AngleIterator(self.timer * d, 2) do
                        New(class.enemy1_ghost, self.x, self.y, 3, a)
                    end
                    if SearchStageLevel[1] then
                        item.Dropitem(item.obj.sakura, 2, self.x, self.y)
                    end
                    task.Wait(10)
                end
            end)
        end,
        drop = function(self)
            if SearchStageLevel[7] then
                Astral.drop(self.x, self.y, 4, 5)
            end
            item.Dropitem(item.obj.point, 5, self.x, self.y)
            if SearchStageLevel[6] then
                UFO:New(self.x, self.y)
            end
        end
    })
    class.enemy2 = Class(enemy, {
        drop = function(self)
            if SearchStageLevel[7] then
                Astral.drop(self.x, self.y, 3, 5)
            end
            item.Dropitem(item.obj.point, 10, self.x, self.y)
        end,
        init = function(self, x, y, r, a, o, vx, vy)
            enemy.init(self, 26, 35)
            self.x, self.y = x, y
            task.New(self, function()
                local l = 0
                while true do
                    self.x = x + cos(a) * sin(l) * r
                    self.y = y + sin(a) * sin(l) * r
                    l = min(90, l + 1)
                    a = a + o
                    x = x + vx
                    y = y + vy
                    task.Wait()
                end
            end)
            task.New(self, function()
                task.Wait(10)
                while true do
                    object.SetG(NewSimpleBullet(ball_mid_c, 16, self.x, self.y, 0, -90), 0.01)
                    PlaySound("tan00", 0.05, 0, true)
                    task.Wait(10)
                end
            end)
        end
    })
    class.enemy2_prepear = Class(enemy, {
        init = function(self, x, y, mx, my)
            enemy.init(self, 14, 200)
            self.x, self.y = x, y
            self.protect = true
            task.New(self, function()
                task.MoveTo(mx, my, 120, 2)
                task.Wait(140)
                self.protect = false
                for _ = 1, 3 do
                    local A = Angle(self, player)
                    for c = 0, 9 do
                        for d = -1, 1, 2 do
                            for a in sp.math.AngleIterator(A + task.SetMode[2](c / 9) * 15 * d, 7) do
                                NewSimpleBullet(grain_a, 4, self.x + cos(a) * 30, self.y + sin(a) * 30, 1.5, a)
                            end
                        end
                        PlaySound("tan00", 0.05, 0, true)
                        task.Wait(5)
                    end
                    task.Wait(60)
                end
                task.MoveTo(x, y, 90, 1)
                object.RawDel(self)
            end)
        end,
        drop = function(self)
            if SearchStageLevel[6] then
                UFO:New(self.x, self.y)
                UFO:New(self.x, self.y)
            end
            item.Dropitem(item.obj.point, 10, self.x, self.y)
        end
    })
    class.enemy2_prepear2 = Class(enemy, {
        init = function(self, x, y, mx, my, v, a)
            enemy.init(self, 1, 10)
            self.x, self.y = x, y
            task.New(self, function()
                task.MoveTo(mx, my, 60, 2)
                object.ChangeVwithTask(self, 0, v, a, 100, 0, false)
                for i = 0, 15 do
                    for d = -1, 1, 2 do
                        NewSimpleBullet(grain_a, 2, self.x, self.y, 2, 180 + a + i * d)
                    end
                    PlaySound("tan00", 0.05, 0, true)
                    task.Wait(3)
                end
            end)
        end,
        drop = function(self)
            if SearchStageLevel[7] then
                Astral.drop(self.x, self.y, 3, 1)
            end
        end
    })
    class.enemy3 = Class(enemy, {
        init = function(self, x, y, mx, my, v, a)
            enemy.init(self, 9, 100)
            self.x, self.y = x, y
            task.New(self, function()
                task.MoveTo(mx, my, 90, 2)
                task.New(self, function()
                    task.Wait(120)
                    object.ChangingV(self, 0, v, a, 80, false)
                end)
                for _ = 1, 6 do
                    for _, X, Y in sp.math.EllipseIterator(0, 50, 0, 0, 3, 1.7, Angle(self, player) - 90) do
                        NewSimpleBullet(water_drop, 6, self.x, self.y, sp.math.RectangularToPolar(X, Y))
                    end
                    PlaySound("kira00", 0.1, 0, true)
                    task.Wait(89)
                end

            end)
        end,
        drop = function(self)
            if SearchStageLevel[6] then
                UFO:New(self.x, self.y)
            end
            if SearchStageLevel[1] then
                item.Dropitem(item.obj.sakura, 30, self.x, self.y)
            end
            if SearchStageLevel[7] then
                Astral.drop(self.x, self.y, 3, 1)
            end
        end
    })
    class.enemy4_circle = Class(enemy, {
        init = function(self, x, y, a, r, da, time, delay)
            enemy.init(self, 32, 7)
            self.x, self.y = x + cos(a) * r, y + sin(a) * r
            self.bound = false
            local A = a
            task.New(self, function()
                for i = 1, time do
                    A = a + da * i / time
                    self.x, self.y = x + cos(A) * r, y + sin(A) * r
                    task.Wait()
                end
                object.RawDel(self)
            end)
            task.New(self, function()
                task.Wait(delay)
                while true do
                    NewSimpleBullet(grain_a, 15, self.x, self.y, 1, A)
                    PlaySound("tan00", 0.05, 0, true)
                    task.Wait(28)
                end
            end)
        end,
        drop = function(self)
            item.Dropitem(item.obj.point, 1, self.x, self.y)
            if SearchStageLevel[7] then
                Astral.drop(self.x, self.y, 3, 1)
            end
        end
    })
    class.enemy4_main = Class(enemy, {
        init = function(self, x1, y1, x2, y2, x3, y3)
            enemy.init(self, 4, 8)
            self.x, self.y = x1, y1
            task.New(self, function()
                task.BezierMoveTo(180, 0, x2, y2, x3, y3)
                object.RawDel(self)
            end)
            task.New(self, function()
                task.Wait(ran:Int(10, 80))
                Create.bullet_decel(self.x, self.y, ball_big, 2, 4, 2, Angle(self, player))
                PlaySound("tan00", 0.05, 0, true)
            end)
        end,
        drop = function(self)
            if SearchStageLevel[1] then
                item.Dropitem(item.obj.sakura, 2, self.x, self.y)
            end
        end
    })
end--enemy
do
    class.SCBG1 = Class(_SC_BG)
    function class.SCBG1:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th15_0", true, 0, 0, 0, 0, 0.2, 0, "mul+rev")
        function b:Beforeframe()
            self.a = cos(self.timer / 2) * 127 + 128
        end
        b = _SC_BG.AddLayer(self, "th15_1", false, 0, 0, 0, 0, 0, 0.5, "", 1.2, 1.2)
        function b:Beforeframe()
            self.a = (cos(self.timer / 2) * 127 + 128) * 0.6
        end
        b = _SC_BG.AddLayer(self, "th15_1", false, 0, 0, 0, 0, 0, -0.5, "", 1.2, 1.2)
        function b:Beforeframe()
            self.a = cos(self.timer / 2) * 127 + 128
        end
        b = _SC_BG.AddLayer(self, "th15_2", true, -64, 0, 0, 0, 0.2, 0, "mul+rev", 0.8, 0.8)
        b.a = 150
        b = _SC_BG.AddLayer(self, "th15_3", false, 0, 0, 0, 0, 0, 0.5, "", 1.2, 1.2)
        b.a = 150
        _SC_BG.AddLayer(self, "th15_3", false, 0, 0, 0, 0, 0, -0.5, "", 1.2, 1.2)
    end
    class.SCBG2 = Class(_SC_BG)
    function class.SCBG2:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "img_void")
        function b:Beforeframe()
            self.r = 90 + sin(self.timer / 3) * 10
            self.g = self.r
            self.b = self.r
        end
        function b:Beforerender()
            _SC_BG.PolarCoordinatesRender("th15_7", 0, 144, 0, 500, 0, 512,
                    1, -self.timer * 2, "mul+rev",
                    Color(self._cur_alpha * 255, self.r, self.g, self.b))
        end

        b = _SC_BG.AddLayer(self, "th15_5", false, 180, -200, 0, 0, 0, -0.2, "mul+add", 2, 2)
        b.a = 128
        b = _SC_BG.AddLayer(self, "th15_5", false, -180, 200, 0, 0, 0, -0.2, "mul+add", 2.5, 2.5)
        b.a = 128
        b = _SC_BG.AddLayer(self, "th15_4", true, 0, 0, 0, 0, 0.5)
        function b:Beforeframe()
            self.a = 200 + sin(180 + self.timer / 3) * 30
        end
        _SC_BG.AddLayer(self, "th15_6")
    end
    class.SCBG3 = Class(_SC_BG)
    function class.SCBG3:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "img_void")
        function b:Beforerender()
            _SC_BG.PolarCoordinatesRender("th15_10", 0, 144, 0, 500, 0, 512,
                    1, -self.timer, "mul+rev",
                    Color(self._cur_alpha * 150, 255, 255, 255))
        end
        b = _SC_BG.AddLayer(self, "th15_11", true, 0, 0, 0, 0, 1)
        b.a = 100

        b = _SC_BG.AddLayer(self, "th15_8")
        b.blend = "mul+rev"
        function b:Beforeframe()
            self.r = 150 + sin(self.timer / 3) * 75
            self.g = self.r
            self.b = self.r
        end
        b = _SC_BG.AddLayer(self, "th15_9", false, 0, 0, 0, 0, 0, -0.1, "", 1.2, 1.2)
    end
    class.SCBG4 = Class(_SC_BG)
    function class.SCBG4:init()
        _SC_BG.init(self)
        local b

        b = _SC_BG.AddLayer(self, "img_void")
        function b:Beforerender()
            _SC_BG.PolarCoordinatesRender("th15_10", 0, 144, 0, 500, 0, 512,
                    1, -self.timer, "mul+rev",
                    Color(self._cur_alpha * 150, 255, 255, 255))
        end
        b = _SC_BG.AddLayer(self, "th15_11", true, 0, 0, 0, 0, 1, 0, "")
        b.a = 50
        b = _SC_BG.AddLayer(self, "th15_8")
        b.blend = "mul+rev"
        function b:Beforeframe()
            self.r = 150 + sin(self.timer / 3) * 75
            self.g = self.r
            self.b = self.r
        end

        b = _SC_BG.AddLayer(self, "th15_13", false, 0, 0, 0, 0, 0, -0.2, "", 1.2, 1.2)

    end
end--scbg

do
    SetImageCenter("junko_back", 0, 42)
    class.JunkoBack = Class(object, {
        init = function(self, master, co, rot)
            self.master = master
            self.x, self.y = self.master.x, self.master.y
            self._r, self._g, self._b = co * 50, 70, 300 - co * 50
            self._a = 200
            self.rot = rot
            self.group = GROUP.GHOST
            self.layer = LAYER.ENEMY - 1
            self.bound = false
            self.img = "junko_back"
            self.vscale = 0
            self.back2 = {}
            task.New(self, function()
                task.SmoothSetValueTo("vscale", 1, 30, 2)
                local r = 0
                local ss = -abs(co - 3) * 40
                while true do
                    self._a = 200 + 50 * sin(r)
                    if ss % 360 == 0 then
                        table.insert(self.back2, { timer = 0 })
                    end
                    r = r + 4
                    ss = ss + 4
                    task.Wait()
                end
            end)
            task.New(self, function()
                while true do
                    for i = 1, 50 do
                        self.hscale = 1 - 0.05 * sin(i * 1.8)
                        task.Wait()
                    end
                    for i = 1, 50 do
                        self.hscale = 0.95 + 0.05 * sin(i * 1.8)
                        task.Wait()
                    end
                end
            end)
        end,
        frame = function(self)
            if not IsValid(self.master) then
                object.Del(self)
                return
            end
            task.Do(self)
            self.x, self.y = self.master.x, self.master.y
            local b
            for i = #self.back2, 1, -1 do
                b = self.back2[i]
                b.timer = b.timer + 1
                b.alpha = 210 - 7 * b.timer
                b.hscale = 1 + 0.75 * sin(b.timer * 3)
                b.vscale = 1 + 0.2 - 0.2 * sin(b.timer * 7.5)
                if b.timer == 30 then
                    table.remove(self.back2, i)
                end
            end
        end,
        render = function(self)
            SetImageState(self.img, "mul+add", self._a, self._r, self._g, self._b)
            DefaultRenderFunc(self)
            for _, p in ipairs(self.back2) do
                SetImageState(self.img, "mul+add", p.alpha, self._r, self._g, self._b)
                Render(self.img, self.x, self.y, self.rot, p.hscale, p.vscale)
            end
        end
    })
end--object

do
    boss.Define("1a", "清兰", "TH15_0", TH15_bg, { -200, 300 }, class.SCBG1, "Seiran", 14)
    boss.Define("1b", "铃瑚", "TH15_0", TH15_bg, { 200, 300 }, class.SCBG1, "Ringo", 14)
    local non1 = boss.card.New("", 1, 1, 70, 500)
    local non2 = boss.card.New("", 1, 1, 70, 900)
    boss.card.add({ { non1, "1a" } }, 14, "非符", 149)
    boss.card.add({ { non2, "1b" } }, 14, "非符", 150)
    non1.del = boss.ns_group.del
    non2.del = boss.ns_group.del
    function non1:before()
        boss.ns_group.init(self)
        task.MoveTo(0, 140, 60, 2)
    end
    function non2:before()
        boss.ns_group.init(self)
        boss.show_aura(self, false)
        task.Wait(60)
    end
    function non1:init()
        task.New(self, function()
            local shoot = function(W, wait, A, da, color, v)
                local w
                return function()
                    for i = 1, W do
                        w = (i - 1) / 2
                        for a = -w, w do
                            a = A + a * task.SetMode[2](i / W) * da / i
                            bullet.SetLayer(NewSimpleBullet(gun_bullet, color, self.x + cos(a) * 10, self.y + sin(a) * 10, v, a,
                                    nil, nil, false), LAYER.ENEMY_BULLET - 100 - i * 0.001)
                        end
                        PlaySound("tan00", 0.1, 0, true)
                        task.Wait(wait)
                    end
                end
            end
            Newcharge_in(self.x, self.y, 135, 206, 235)
            task.Wait(60)
            local u
            while true do
                boss.cast(self, 150)
                local A = Angle(self, player)
                for i = 1, 5 do
                    local t = ran:Float(-15, 15)
                    for m = -9, 9 do
                        object.SetA(NewSimpleBullet(ball_huge, 6, self.x, self.y, 3, A + 180 + m * 10 + t), 0.04, A)
                    end
                    u = i % 2 / 2
                    for r = -u, u do
                        task.New(self, shoot(9, 2, Angle(self, player) + r * 50, 15, 4, 5))
                    end
                    for c = 1, 4 do
                        for m = -5 - i, 5 + i do
                            Create.bullet_decel(self.x, self.y, ball_big, 8, 6, 4, A + m * 24 + c % 2 * 10 + i % 2 * 12)
                        end
                        task.Wait(6)
                    end

                end
                task.Wait(60)
                task.MoveToPlayer(60, -100, 100, 130, 150,
                        20, 40, 10, 20, 2, 3)
            end
        end)
    end
    function non2:init()
        local I = 1
        local index = 2
        local wait = 80
        task.New(self, function()
            boss.violent(self)
            boss.show_aura(self, true)
            task.MoveTo(0, 80, 60, 2)
            Newcharge_in(self.x, self.y, 135, 206, 235)
            task.Wait(60)
            local d = 1
            while true do
                boss.cast(self, 150)
                Newcharge_out(self.x, self.y, 250, 128, 114)
                task.New(self, function()
                    task.Wait(210 - 60)
                    task.MoveToPlayer(60, -100, 100, 70, 90,
                            20, 40, 10, 20, 2, 1)
                end)
                local v
                for i = 1, 35 do
                    v = 2 + i / 35 * index
                    for a in sp.math.AngleIterator(90 - 90 * d + i * 5 * d, 2 + i * I) do
                        object.ChangeVAwithTask(Create.bullet_decel(self.x + cos(a) * (60 - i) * 2, self.y + sin(a) * (60 - i) * 2,
                                ball_mid, 6, 4 - i / 35 * index, v, a),
                                v, v + 1, a, d * 45, 90, 30, true, 3)
                        object.ChangeVAwithTask(Create.bullet_decel(self.x + cos(a) * (60 - i) * 2, self.y + sin(a) * (60 - i) * 2,
                                ball_mid, 6, 4 - i / 35 * index, v, a),
                                v, v + 1, a, -d * 45, 90, 30, true, 3)
                    end
                    PlaySound("tan00", 0.1, self.x / 100, true)
                    task.Wait(6)
                end
                for a in sp.math.AngleIterator(ran:Float(0, 360), 50) do
                    for V = 5, 7 do
                        NewSimpleBullet(grain_a, 2, self.x, self.y, 0.3 + V * 0.3, a + V)
                    end
                end
                task.Wait(wait)
                d = -d
            end
        end)
    end

    local name = "「山寺月中寻桂子，郡亭枕上看潮头」"
    local sc1 = boss.card.New(name, 1, 2, 60, 1000)
    local sc2 = boss.card.New(name, 1, 2, 60, 1000)
    boss.card.add({ { sc1, "1a" }, { sc2, "1b" } }, 14, name, 151)
    function sc1:before()
        boss.ns_group.nextcard(self, 300, 200)
        task.MoveTo(0, 150, 60, 2)
    end
    function sc2:before()
        boss.ns_group.nextcard(self, -300, 200)
        boss.show_aura(self, true)
        task.MoveTo(0, 50, 60, 2)
    end
    function sc1:init()
        local big = Class(bullet, {
            init = function(self, a, o, master, scale)
                bullet.init(self, flower2, 14, false, true)
                self.rot = a
                self.omiga = o
                self.master = master
                self.hscale = 0.1
                self.vscale = 0.1
                self.a, self.b = 0.8, 0.8
                self.flower = true
                bullet.RemoveFog(self)
                object.ChangeSizeColliWithTask(self, scale - 0.1, scale - 0.1, 20, 2)
                self.bound = false
                task.New(self, function()
                    task.Wait(200)
                    self.bound = true
                end)
                task.New(self, function()
                    while not self.flag do
                        task.Wait()
                    end
                    while IsValid(self.flag) and Dist(self, self.flag) > 53 * self.hscale + 8 do
                        task.Wait()
                    end
                    object.Del(self)
                    Create.laser_line(self.x, self.y, 14, 6, self.rot, 8, 8, 6, 8)
                end)
            end,
            frame = function(self)
                if not IsValid(self.master) then
                    object.Del(self)
                    return
                end
                bullet.frame(self)
                self.x, self.y = self.master.x + cos(self.rot + 180) * self.hscale * 53, self.master.y + sin(self.rot + 180) * self.hscale * 53
            end
        }, true)
        local center = Class(object, {
            init = function(self, x, y, fa, fo, v, a)
                object.init(self, x, y, GROUP.INDES)
                self.colli = false
                self.flower = {}
                self.bound = false
                local s = ran:Float(0.3, 0.6)
                for A in sp.math.AngleIterator(fa, 5) do
                    table.insert(self.flower, New(big, A, fo, self, s))
                end
                object.SetV(self, v, a)
            end,
            frame = function(self)
                task.Do(self)
                sp:UnitListUpdate(self.flower)
                if #self.flower == 0 then
                    object.RawDel(self)
                end
            end
        }, true)
        task.New(self, function()
            boss.cast(self, 60)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            Newcharge_out(self.x, self.y, 135, 206, 235)
            PlaySound("water")
            task.New(self, function()
                while true do
                    object.SetG(NewSimpleBullet(water_drop, 6, -210, 190 + ran:Float(-40, 40),
                            ran:Float(1, 2), ran:Float(60, 85)), ran:Float(0.03, 0.04), true, 4)
                    object.SetG(NewSimpleBullet(water_drop, 6, 210, 190 + ran:Float(-40, 40),
                            ran:Float(1, 2), ran:Float(95, 120)), ran:Float(0.03, 0.04), true, 4)
                    task.Wait(3)
                end
            end)
            task.New(self, function()
                while true do
                    object.SetG(New(center, -210, 190 + ran:Float(-40, 40), ran:Float(0, 360), ran:Sign(),
                            ran:Float(1, 2), ran:Float(30, 55)), ran:Float(0.02, 0.03), true, 3)
                    object.SetG(New(center, 210, 190 + ran:Float(-40, 40), ran:Float(0, 360), ran:Sign(),
                            ran:Float(1, 2), ran:Float(125, 150)), ran:Float(0.02, 0.03), true, 6)
                    task.Wait(ran:Int(40, 70))
                end
            end)
            task.Wait(90)
            while true do
                task.MoveToPlayer(60, -100, 100, 140, 160, 20, 40, 10, 20, 2, 1)
                task.Wait(100)
            end
        end)
    end
    function sc2:init()
        task.New(self, function()
            task.Wait(120)
            while true do
                for v = 1, 4 do
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 10 + v * 3) do
                        NewSimpleBullet(ball_big, 4, self.x, self.y, 2 + v * 0.1, a)
                    end
                    PlaySound("tan00")
                    task.Wait(40)
                end
                boss.cast(self, 180)
                object.IndesDo(function(o)
                    if o.flower then
                        sp:UnitListUpdate(o.flower)
                        for _, u in ipairs(o.flower) do
                            Create.bullet_create_eff(u)
                            u.flag = self
                        end
                        object.ChangeVwithTask(o, 0, 6, Angle(o, self), 90, 0, true, 1)
                    end
                end)
                Newcharge_in(self.x, self.y, 255, 227, 132)
                task.Wait(60)
            end
        end)
    end
    sc1.frame = boss.card.PublicHP
    sc2.frame = boss.card.PublicHP
end--boss1

do
    boss.Define("2a", "哆来咪·苏伊特", "TH15_0", TH15_bg, { -200, 300 }, class.SCBG2, "Doremy", 14)
    boss.Define("2b", "稀神探女", "TH15_0", TH15_bg, { 200, 300 }, class.SCBG2, "Sagume", 14)
    local non1 = boss.card.New("", 1, 2, 80, 750)
    local non2 = boss.card.New("", 1, 1, 80, 600)
    boss.card.add({ { non1, "2a" } }, 14, "非符", 152)
    boss.card.add({ { non2, "2b" } }, 14, "非符", 153)
    non1.del = boss.ns_group.del
    non2.del = boss.ns_group.del
    function non1:before()
        boss.ns_group.init(self)
        task.MoveTo(0, 100, 60, 2)
    end
    function non2:before()
        boss.ns_group.init(self)
        boss.show_aura(self, false)
        task.Wait(60)
    end
    function non1:init()
        task.New(self, function()
            Newcharge_in(self.x, self.y, 200, 100, 100)
            task.Wait(60)
            local d = 1
            while true do
                boss.cast(self, 90)
                local b
                local A = Angle(self, player) - 50
                task.New(self, function()
                    for da, r, v, s, col in sp.math.Advanced.Iterator(240, { "Increment", A, 16 * d }, { "Increment", 90, -3 * d },
                            { "SetValue", 4, 2, 1 }, { "Oscillation", 0.45, 0.6, A + 100, 30 }, { "TwoValues", 6, 8 }) do
                        for a in sp.math.AngleIterator(r, 2) do
                            for ra in sp.math.AngleIterator(da, 2) do
                                b = NewSimpleBullet(ball_big, col, self.x + cos(ra) * 60, self.y + sin(ra) * 60, v, a)
                                b.v = v
                                bullet.SetLayer(b, LAYER.ENEMY_BULLET - 1)
                                object.SetSizeColli(b, s, s)
                                self.a, self.b = self.a * 0.6, self.b * 0.6
                                task.New(b, function()
                                    local self = task.GetSelf()
                                    object.ChangingV(self, b.v, 0.8, self.rot, 60)
                                    object.ChangingV(self, 0.8, b.v, self.rot, 90)
                                end)
                            end
                        end
                        PlaySound("tan00", 0.1, 0, true)
                        task.Wait()
                    end
                end)
                task.Wait(140)
                task.New(self, function()
                    for _ = 1, 6 do
                        for a in sp.math.AngleIterator(Angle(self, player), 18) do
                            NewSimpleBullet(ball_huge, 16, self.x, self.y, 3.5, a)
                        end
                        task.Wait(25)
                    end
                    for a in sp.math.AngleIterator(Angle(self, player), 30) do
                        Create.laser_line(self.x, self.y, 16, 4, a, 60, 8, 100, 8)
                        Create.laser_line(self.x, self.y, 16, 1.5, a + 6, 120, 8, 100, 8)
                    end
                end)
                task.MoveToPlayer(100, -100, 100, 100, 140,
                        50, 70, 10, 20, 2, 1)
                d = -d
                task.Wait(180)
            end
        end)
    end
    function non2:init()
        task.New(self, function()
            boss.violent(self)
            boss.show_aura(self, true)
            task.MoveTo(0, 120, 60, 2)
            Newcharge_in(self.x, self.y, 200, 100, 100)
            task.Wait(60)
            local Ball = Class(enemy, {
                init = function(self, x, y, v, a, o, sty, col, offa)
                    enemy.init(self, sty, 40)
                    task.New(self, function()
                        self.colli = false
                        self._r, self._g, self._b = 50, 50, 50
                        task.Wait(80)
                        self.colli = true
                        self._r, self._g, self._b = 255, 255, 255
                    end)
                    self.x, self.y = x, y
                    task.New(self, function()
                        while true do
                            Create.bullet_decel(self.x, self.y, square, col, 6, 3, a * 2 + offa, nil, false)
                            PlaySound("tan00", 0.1, 0, true)
                            task.Wait(8)
                        end
                    end)
                    task.New(self, function()
                        local l = 0
                        while true do
                            self.x = x + cos(a) * l
                            self.y = y + sin(a) * l
                            a = a + o
                            l = l + v
                            task.Wait()
                        end
                    end)
                end
            }, true)
            while true do
                PlaySound("boon01")
                for a = 1, 15 do
                    object.Connect(self, New(Ball, self.x, self.y, 0.8, a * 12, 3, 23, 2, 0), 0.05, true)
                    task.Wait()
                end
                task.Wait(80)
                PlaySound("boon01")
                for a = 15, 1, -1 do
                    object.Connect(self, New(Ball, self.x, self.y, 0.8, a * 12, -3, 25, 6, 180), 0.05, true)
                    task.Wait()
                end
                task.Wait(60)
                task.MoveToPlayer(60, -100, 100, 100, 140,
                        20, 40, 10, 20, 2, 1)
                task.New(self, function()
                    for _ = 1, 4 do
                        for a in sp.math.AngleIterator(Angle(self, player), 20) do
                            for z = -3, 3 do
                                NewSimpleBullet(grain_b, 16, self.x, self.y, 4 - abs(z) * 0.2, a + z * 1.5)
                            end
                        end
                        PlaySound("kira00")
                        task.Wait(30)
                    end
                end)
                task.Wait(60)
            end
        end)
    end

    local name = "「雾失楼台，月迷津渡」"
    local sc1 = boss.card.New(name, 1, 2, 60, 700)
    local sc2 = boss.card.New(name, 1, 2, 60, 600)
    boss.card.add({ { sc1, "2a" }, { sc2, "2b" } }, 14, name, 154)
    function sc1:before()
        boss.ns_group.nextcard(self, 0, 400)
        task.MoveTo(0, 150, 60, 2)
    end
    function sc2:before()
        boss.ns_group.nextcard(self, 0, 400)
        boss.show_aura(self, true)
        task.MoveTo(0, 50, 60, 2)
    end
    function sc1:init()
        local interval = 15
        local wait = 200
        task.New(self, function()
            boss.violent(self)
            interval = 6
            wait = 150
        end)
        task.New(self, function()
            local Moon = Class(object, {
                init = function(self, d)
                    self.x, self.y = player.x, player.y
                    self.group = GROUP.INDES
                    self.layer = LAYER.ENEMY_BULLET + 1
                    self.r = 0
                    self.colli = false
                    self.a = 255
                    PlaySound("explode")
                    task.New(self, function()
                        task.SmoothSetValueTo("r", 70, 60, 2)
                        task.Wait(180)
                        task.SmoothSetValueTo("a", 0, 30, 2)
                        object.Del(self)
                    end)
                    task.New(self, function()
                        local b
                        while true do
                            if self.timer > 30 and self.timer % interval == 0 then
                                for a in sp.math.AngleIterator(self.timer * 2 * d+12, 2) do
                                    for da = -1, 1, 2 do
                                        a = a + da
                                        b = NewSimpleBullet(grain_a, 14, self.x + cos(a) * self.r, self.y + sin(a) * self.r,
                                                2.5, a, nil, nil, false)
                                        object.SetA(b, 0.03, a + 180, nil, true)
                                        b.maxv = 3
                                    end
                                end
                                PlaySound("tan00")
                            end
                            self.x = self.x + (-self.x + player.x) * 0.03
                            self.y = self.y + (-self.y + player.y) * 0.03
                            task.Wait()
                        end
                    end)
                end,
                frame = task.Do,
                render = function(self)
                    SetImageState("white", "mul+add", self.a, 255, 227, 132)
                    misc.SectorRender(self.x, self.y, self.r - 3, self.r, 0, 360, int(self.r))
                end
            }, true)
            local fog = Class(object, {
                init = function(self, x, y, v, a)
                    object.init(self, x, y, GROUP.INDES, LAYER.TOP)
                    self.imgx, self.imgy = ran:Float(-256, 256), ran:Float(-256, 256)
                    self.imgvx, self.imgvy = ran:Float(-2, 2), ran:Float(-2, 2)
                    self._a = 0
                    self.colli = false
                    self.bound = false
                    object.SetV(self, v, a)
                    task.New(self, function()
                        for i = 1, 30 do
                            self._a = i / 30
                            task.Wait()
                        end
                    end)
                end,
                frame = function(self)
                    task.Do(self)
                    if not BoxCheck(self, -280, 280, -300, 300) then
                        object.Del(self)
                    end
                end,
                render = function(self)
                    local color1 = Color(self._a * 255, 255, 255, 255)
                    local color2 = Color(0, 255, 255, 255)
                    local point = 12
                    local r = 100
                    local param
                    local RenderTexture = RenderTexture

                    local ang = 360 / (2 * point)
                    for angle = 360 / point, 360, 360 / point do
                        param = { cos(angle + ang), sin(angle + ang), cos(angle - ang), sin(angle - ang) }
                        RenderTexture("Poison", "mul+rev",
                                { self.x + r * param[1], self.y + r * param[2], 0.5, self.imgx + r * param[1], self.imgy + r * param[2], color2 },
                                { self.x + r * param[3], self.y + r * param[4], 0.5, self.imgx + r * param[3], self.imgy + r * param[4], color2 },
                                { self.x, self.y, 0.5, self.imgx, self.imgy, color1 },
                                { self.x, self.y, 0.5, self.imgx, self.imgy, color1 })
                    end

                end
            }, true)
            task.Wait(60)
            local d = 1
            while true do
                Newcharge_out(self.x, self.y, 255, 227, 132)
                New(Moon, d)
                boss.cast(self, 180)
                task.Wait(wait)
                PlaySound("boon00")
                for a in sp.math.AngleIterator(ran:Float(0, 360), 15) do
                    New(fog, self.x, self.y, ran:Float(0.6, 1.3), a)
                end
                task.MoveToPlayer(60, -100, 100, 100, 140, 20, 40, 10, 20, 2, 1)
                task.Wait(60)
                d = -d
            end
        end)
    end
    function sc2:init()
        local Ball = Class(enemy, {
            init = function(self, x1, y1, x2, y2, x3, y3, col, offt)
                enemy.init(self, 26, 40)
                self.x, self.y = x1, y1
                task.New(self, function()
                    task.Wait(offt or 0)
                    while true do
                        Create.bullet_decel(self.x, self.y, grain_b, col, 6, 1, -90, nil, false)
                        PlaySound("tan00", 0.1, 0, true)
                        task.Wait(16)
                    end
                end)
                task.New(self, function()
                    task.BezierMoveTo(180, 0, x2, y2, x3, y3)
                    object.RawDel(self)
                end)
            end
        }, true)
        task.New(self, function()
            Newcharge_in(self.x, self.y, 200, 200, 200)
            task.Wait(60)
            while true do
                for x = -8, 8 do
                    object.Connect(self, New(Ball, self.x, self.y, x * 32, 200 + (x + 8) * 2, -250, 0, 4, 3 * (x + 8)), 0.2, true)
                    task.Wait(10)
                end
                task.Wait(120+60)
                for x = -8, 8 do
                    object.Connect(self, New(Ball, self.x, self.y, -x * 32, 200 + (x + 8) * 2, 250, 0, 4, 3 * (x + 8)), 0.2, true)
                    task.Wait(10)
                end
                task.Wait(120+60)
            end
        end)
    end
end--boss2

do
    boss.Define("3a", "克劳恩皮丝", "TH15_1", TH15_bg, { -200, 300 }, class.SCBG3, "Clownpiece", 14)
    boss.Define("3b", "纯狐", "TH15_1", TH15_bg, { 0, 400 }, class.SCBG3, "Junko", 14)
    local non1 = boss.card.New("", 1, 4, 80, 850)
    local non2 = boss.card.New("", 1, 1, 80, 1100)
    boss.card.add({ { non1, "3a" } }, 14, "非符", 155)
    boss.card.add({ { non2, "3b" } }, 14, "非符", 156)
    non1.del = boss.ns_group.del
    non2.del = boss.ns_group.del
    function non1:before()
        boss.ns_group.init(self)
        task.MoveTo(0, 100, 60, 2)
    end
    function non2:before()
        boss.ns_group.init(self)
        boss.show_aura(self, false)
        task.Wait(60)
    end
    function non1:init()
        task.New(self, function()
            local Laser = Class(laser, {
                init = function(self, x, y, a, d)
                    laser.init(self, 6, x, y, a, 0, 0, 0, 12, 12, 0)
                    laser._TurnHalfOn(self, 0, false)
                    self.line = 0
                    self.Isradial = true
                    self.radial_v = 16
                    task.New(self, function()
                        for i = 1, 40 do
                            self.rot = a - d * 90 * task.SetMode[2](i / 40)
                            self.line = sin(i * 2.25) * 500
                            task.Wait()
                        end
                        laser._TurnOn(self, 1, true, false)
                        task.New(self, function()
                            for i = 1, 60 do
                                self.rot = self.rot + d * 0.25 * task.SetMode[2](i / 60)
                                self.l3 = self.l3 + 16
                                task.Wait()
                            end
                            for i = 1, 40 do
                                self.rot = self.rot + d * 0.25 * task.SetMode[2](1 - i / 40)
                                self.l1 = self.l1 + 16
                                task.Wait()
                            end
                            laser._TurnOff(self, 30, true)
                            object.Del(self)
                        end)
                    end)
                end,
                render = function(self)
                    SetImageState("white", "mul+add", self.alpha * 180, unpack(ColorList[math.ceil(self.index / 2)]))
                    Render("white", self.x + cos(self.rot) * self.line / 2, self.y + sin(self.rot) * self.line / 2, self.rot, self.line / 16, 0.125)
                    laser.render(self)
                end
            }, true)
            local center = Class(bullet, {
                init = function(self, x, y, v, a, d)
                    bullet.init(self, ball_big, 6, true, false)
                    self.x, self.y = x, y
                    self._blend = "mul+add"
                    task.New(self, function()
                        object.ChangingV(self, v, 0, a, 60)
                        object.Del(self)
                        for A in sp.math.AngleIterator(0, 14) do
                            New(Laser, self.x, self.y, A, d)
                        end
                    end)
                end
            }, true)
            local d = 1
            while true do
                boss.cast(self, 60)
                Newcharge_in(self.x, self.y, 250, 128, 114)
                task.Wait(60)
                Newcharge_out(self.x, self.y, 255, 227, 132)
                New(center, self.x, self.y, 3, 90 + 45, 1)
                New(center, self.x, self.y, 3, 90 - 45, -1)
                for a in sp.math.AngleIterator(ran:Float(0, 360), 36) do
                    for z = 0, 12 do
                        NewSimpleBullet(star_small, 6, self.x, self.y, 3.5 - z * 0.12, a + sin(z * 40) * 2.2 * d, nil, 2)
                    end
                end
                for a in sp.math.AngleIterator(-90, 19) do
                    for z = 0, 12 do
                        NewSimpleBullet(star_small, 4, self.x, self.y, 1.5 - z * 0.07, a - sin(z * 21) * 4.8 * d, nil, -2)
                    end
                end
                task.Wait(90)
                task.MoveToPlayer(90, -100, 100, 100, 140, 40, 50, 10, 20, 2, 1)
                PlaySound("kira00", 0.2, 0, true)
                for a in sp.math.AngleIterator(ran:Float(0, 360), 25) do
                    NewSimpleBullet(star_small, 16, self.x, self.y,
                            Dist(self, player.x + cos(a) * 100, player.y + sin(a) * 100) / 150,
                            Angle(self, player.x + cos(a) * 100, player.y + sin(a) * 100), nil, 3)
                end
                d = -d
                task.Wait(90)
            end
        end)
    end
    function non2:init()
        task.New(self, function()
            boss.violent(self)
            boss.show_aura(self, true)
            task.MoveTo(0, 120, 60, 2)
            boss.cast(self, 90)
            Newcharge_in(self.x, self.y, 200, 100, 100)
            task.Wait(60)
            local d = 1
            while true do
                for i = 1, 3 do
                    for a in sp.math.AngleIterator(0, 20) do
                        task.New(Create.laser_changeangle(self.x, self.y, 8, 16, 8, 6 - i * 1.2, a,
                                { r = d * (6 - i * 0.08), time = 60 },
                                { r = d * (-2 - i * 0.1), time = 40 },
                                { r = d * (3 - i * 0.1), time = 59 }, { r = d * 0.4, time = 90 }), function()
                            local self = task.GetSelf()
                            self.bound = false
                            task.Wait(320)
                            self.bound = true
                        end)
                    end
                end
                task.Wait(50)
                for t = 1, 5 do
                    for a in sp.math.AngleIterator(0, 18) do
                        for z = -2, 2 do
                            rawset(NewSimpleBullet(ball_mid, 6, self.x, self.y, 2.5, a + z * 1.2 + t * 10), "_blend", "mul+add")
                        end
                    end
                    PlaySound("tan00", 0.1, 0, true)
                    task.Wait(18)
                end
                for c = 1, 5 do
                    for i = 0, 50 do
                        NewSimpleBullet(ball_light, 2, self.x, self.y, 1.8, -90 + c * d - 6 - 348 * i / 50)
                    end
                    task.Wait(8)
                end
                for c = 4, 1, -1 do
                    for i = 0, 50 do
                        NewSimpleBullet(ball_light, 2, self.x, self.y, 1.8, -90 + c * d - 6 - 348 * i / 50)
                    end
                    task.Wait(8)
                end
                task.Wait(100 - 32)
                d = -d
            end
        end)
    end

    local name = "「料得年年肠断处，明月夜，短松冈」"
    local sc1 = boss.card.New(name, 1, 2, 60, 1100)
    local sc2 = boss.card.New(name, 1, 2, 60, 1100)
    sc1.frame = boss.card.PublicHP
    sc2.frame = boss.card.PublicHP
    boss.card.add({ { sc1, "3a" }, { sc2, "3b" } }, 14, name, 157)
    function sc1:before()
        boss.ns_group.nextcard(self, 0, 400)
        task.MoveTo(0, 30, 60, 2)
    end
    function sc2:before()
        boss.ns_group.nextcard(self, 0, 400)
        boss.show_aura(self, true)
        task.MoveTo(0, 150, 60, 2)
    end
    function sc1:init()
        local flag = true
        local Line = {}
        local point = Class(bullet, {
            init = function(self, x, y, t, master)
                bullet.init(self, star_big, 2, false, false)
                --self._blend = "mul+add"
                self.x, self.y = x, y
                self.omiga = 3
                self.master = master
                --bullet.SetLayer(self, LAYER.ENEMY_BULLET + 1)
                task.New(self, function()
                    local c = 0.1
                    while true do
                        if Line[t] and IsValid(self.master) then
                            --self.rot = Angle(Line[t][1], Line[t][2], Line[t + 1][1], Line[t + 1][2])
                            self.x = self.x + (-self.x + Line[t][1]) * c
                            self.y = self.y + (-self.y + Line[t][2]) * c
                            c = min(0.8, c + 0.1 / 120)
                        else
                            break
                        end
                        task.Wait()
                    end
                    object.Del(self)
                end)
            end,
            colli = function(self, other)
                if other.img == "moon" then
                    NewSimpleBullet(ball_small, 2, self.x, self.y, ran:Float(0.5, 1.6), ran:Float(0, 360))
                    flag = false
                end
            end
        }, true)
        self._transport = New(Class(object, {
            frame = task.Do,
            init = function(self)
                self.group = GROUP.GHOST
                task.New(self, function()
                    while not self.finish do
                        task.Wait()
                    end
                    if self.getcard and flag then
                        ext.achievement:get(50)
                    end
                    object.RawDel(self)
                end)
            end }, true))
        task.New(self, function()
            task.Wait(60)
            task.MoveTo(-170, 30, 60, 2)
            task.Wait()
            boss.cast(self, 90)
            task.New(self, function()
                while true do
                    Line = sp:GetPointLine(22, self.x, self.y, player.x, player.y)
                    task.Wait()
                end
            end)
            for a in sp.math.AngleIterator(ran:Float(0, 360), 30) do
                for v = 1, 3 do
                    NewSimpleBullet(ball_mid, 2, self.x, self.y, 1.5 + v * 0.2, a + v * 6)
                end
            end
            for i = 4, 19 do
                New(point, self.x, self.y, i, self)
            end
            task.New(self, function()
                local a = 180
                while true do
                    self.x = self.x + (-self.x + cos(a) * 170) * 0.05
                    self.y = self.y + (-self.y + sin(a) * 30 + 30) * 0.05
                    a = a + 0.4
                    task.Wait()
                end
            end)
        end)
    end
    function sc2:init()
        for a = -2, 2 do
            New(class.JunkoBack, self, 3 - abs(a), 90 + a * 40)
        end
        task.New(self, function()
            local moon = Class(object, {
                init = function(self, x, y)
                    object.init(self, x, y, GROUP.ENEMY, LAYER.ENEMY)
                    self.img = "moon"
                    self.omiga = -1
                    self.ag = 0.03
                    self.a = 4.5
                    self.b = 4.5
                    self.hscale = 0.1
                    self.vscale = 0.1
                    self.bound = false
                    task.New(self, function()
                        object.ChangingSizeColli(self, 0.9, 0.9, 60, 2)
                        while true do
                            if self.y < lstg.world.boundb - self.a then
                                object.Del(self)
                            end
                            task.Wait()
                        end
                    end)
                end,
                frame = function(self)
                    task.Do(self)
                    CollisionCheck(GROUP.INDES, GROUP.ENEMY)
                end
            }, true)
            task.Wait(60)
            Newcharge_out(self.x, self.y, 250, 128, 114, true)
            boss.cast(self, 3600)
            task.New(self, function()
                local d = 1
                while true do
                    for c = 1, 16 do
                        for a in sp.math.AngleIterator(-90 + c * d, 15) do
                            NewSimpleBullet(ball_mid, 6, self.x - 50 * d + cos(a) * 15, self.y + sin(a) * 15,
                                    2 + c / 16 + c % 2 / 40, a)
                        end
                    end
                    PlaySound("tan00", 0.1, -d, true)
                    d = -d
                    task.Wait(65)
                end
            end)
            task.Wait(100)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            Newcharge_out(self.x, self.y, 200, 200, 200)
            while true do
                object.Connect(self, New(moon, Forbid(player.x + ran:Sign() * ran:Float(-20, 20), -180, 180), 224))
                task.Wait(200)
            end
        end)
    end
end--boss3

do
    boss.Define("4a", "纯狐", "TH15_1", TH15_bg, { -200, 400 }, class.SCBG4, "Junko", 14)
    boss.Define("4b", "赫卡提亚·拉碧斯拉祖利", "TH15_1", TH15_bg, { 0, 400 }, class.SCBG4, "Hecatia1", 14)
    local non1 = boss.card.New("", 1, 4, 80, 850)
    local non2 = boss.card.New("", 1, 1, 80, 1500)
    boss.card.add({ { non1, "4a" }, { non2, "4b" } }, 14, "非符", 158)
    non1.del = boss.ns_group.del
    non2.del = boss.ns_group.del
    function non1:before()
        boss.ns_group.init(self)
        boss.show_aura(self, false)
        task.Wait(60)
    end
    function non2:before()
        boss.ns_group.init(self)
        task.MoveTo(0, 100, 60, 2)

    end
    function non1:init()
        task.New(self, function()
            boss.violent(self)
            self.hp = 0
        end)
    end
    function non2:init()
        self.state = 1
        self.ChangeState = function()
            task.New(self, function()
                PlaySound("heal")
                boss.cast(self, 0)
                task.Wait(self.ani_intv * 3 - 1)
                self.state = self.state % 3 + 1
                self._wisys:SetImageInList("Hecatia" .. self.state)
            end)
        end
        local moon = Class(bullet, {
            init = function(self, x, y, v1, a1, v2, a2)
                bullet.init(self, ball_huge, 12, true, true)
                self.x, self.y = x, y
                self.omiga = 3
                task.New(self, function()
                    object.ChangingV(self, v1, 0, a1, 75, false)
                    object.SetV(self, v2, a2)
                    for i = 1, 30 do
                        for a in sp.math.AngleIterator(45, 4) do
                            for z = -1, 1, 2 do
                                bullet.RemoveFog(NewSimpleBullet(arrow_small, 13, self.x + cos(a + 90 * z) * 5, self.y + sin(a + 90 * z) * 5, 2 + i / 6, a))
                            end
                        end
                        PlaySound('tan00', 0.1, self.x / 200, true)
                        task.Wait(2)
                    end
                end)

            end
        }, true)
        task.New(self, function()
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            while true do
                self.ChangeState()
                Newcharge_out(self.x, self.y, 255, 227, 132, true)
                task.New(self, function()
                    task.Wait(60)
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 30) do
                        for v = 1, 3 do
                            Create.bullet_accel(self.x, self.y, ball_big, 14, 0.4, 2.5 + v * 0.6, a, true, true, 170)
                        end
                    end
                    task.New(self, function()
                        for _ = 1, 10 do
                            for a in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                                for z = -1, 1, 2 do
                                    Create.bullet_accel(self.x + cos(a + 90 * z) * 3, self.y + sin(a + 90 * z) * 3, arrow_small, 14, 2.5, 8, a)
                                end
                            end
                            PlaySound("tan00", 0.1, 0, true)
                            task.Wait(16)
                        end
                    end)
                end)
                local d = ran:Sign()
                for _ = 1, 7 do
                    New(moon, self.x, self.y, ran:Float(3, 4), 90 + 80 * d + ran:Float(-10, 10), 3, -90)
                    task.Wait(30)
                    d = -d
                end
                task.Wait(30)
                self.ChangeState()
                Newcharge_out(self.x, self.y, 135, 206, 235, true)
                task.Wait(80)
                task.New(self, function()
                    task.Wait(30)
                    local D = 1
                    for _ = 1, 4 do
                        for t = 1, 10 do
                            for a in sp.math.AngleIterator(t * 1.5 * D, 14) do
                                for z = -1, 1, 2 do
                                    Create.bullet_decel(self.x + cos(a + 90 * z) * 3, self.y + sin(a + 90 * z) * 3, arrow_small, 6, 6, 4, a)
                                end
                            end
                            for a in sp.math.AngleIterator(-t * 2 * D, 12) do
                                for z = -1, 1, 2 do
                                    Create.bullet_decel(self.x + cos(a + 90 * z) * 3, self.y + sin(a + 90 * z) * 3, arrow_small, 6, 3, 1.2, a)
                                end
                            end
                            PlaySound("tan00", 0.1, 0, true)
                            task.Wait(3)
                        end
                        task.Wait(25)
                        D = -D
                    end
                end)
                for _ = 1, 8 do
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 25) do
                        Create.laser_line(self.x, self.y, 6, 5, a, 18, 8, 8)
                    end
                    task.Wait(24)
                end
                task.Wait(60 - 24)
                self.ChangeState()
                Newcharge_out(self.x, self.y, 250, 128, 114, true)
                task.Wait(40)
                d = 1
                for _ = 1, 4 do
                    local r = Angle(self, player)
                    for y = 19, 10, -1 do
                        for a in sp.math.AngleIterator(r, 14) do
                            for z = -1.5, 1.5 do
                                Create.bullet_accel(self.x + cos(a + 90) * y * z, self.y + sin(a + 90) * y * z, arrow_small, 4, 1, 8, a)
                            end
                        end
                        for a in sp.math.AngleIterator(r + y * d * 7, 4) do
                            bullet.RemoveFog(Create.bullet_decel(self.x, self.y, ball_mid, 4, 4, 1.5, a))
                        end
                        PlaySound("tan00", 0.1, 0, true)
                        task.Wait(3)
                    end
                    d = -d
                    task.MoveToPlayer(30, -100, 100, 120, 140,
                            10, 20, 10, 20, 2, 1)
                end
            end
        end)
    end
    local name = "「月落乌啼霜满天，江枫渔火对愁眠」"
    local sc1 = boss.card.New(name, 2, 2, 60, 1200)
    local sc2 = boss.card.New(name, 2, 2, 60, 1200)
    sc1.frame = boss.card.PublicHP
    sc2.frame = boss.card.PublicHP
    boss.card.add({ { sc1, "4a" }, { sc2, "4b" } }, 14, name, 159)
    function sc1:before()
        boss.ns_group.nextcard(self, 0, 400)
        task.MoveTo(0, 50, 60, 2)
    end
    function sc2:before()
        boss.ns_group.nextcard(self, 0, 400)
        boss.show_aura(self, true)
        task.MoveTo(0, 150, 60, 2)
    end
    function sc1:init()
        boss.card.UnlockOD(self, 16)
        task.New(self, function()
            local aim = Class(bullet, {
                init = function(self, x, y, v, a, t, v2)
                    bullet.init(self, ball_huge, 16, false, true)
                    self.x, self.y = x, y
                    self.omiga = 2
                    object.SetV(self, v, a)
                    task.New(self, function()
                        x, y = player.x, player.y
                        object.ChangingV(self, v, 0, a, t, false)
                        task.Wait(30)
                        object.ChangingV(self, 0, v2, Angle(self, x, y) + ran:Float(-5, 5), 110, false)
                    end)
                end
            }, true)
            task.Wait(60)
            PlaySound("ch02")
            New(boss_cast_darkball, self.x, self.y, 60, 80, 360, 1, 270, 64, 64, 255, 2)
            New(boss_cast_darkball, self.x, self.y, 60, 80, 360, 1, 270, 255, 64, 64, -2)
            task.Wait(80)
            boss.cast(self, 3600)
            task.Wait(60)
            while true do
                for a in sp.math.AngleIterator(ran:Float(0, 360), 10) do
                    New(aim, self.x, self.y, ran:Float(2.8, 3.2), a, ran:Int(60, 70), 5)
                end
                PlaySound("kira00")
                task.Wait(180)
            end
        end)
    end
    function sc2:init()
        task.New(self, function()
            self.state = self.state or 1
            self.ChangeState = self.ChangeState or function()
                task.New(self, function()
                    PlaySound("heal")
                    boss.cast(self, 0)
                    task.Wait(self.ani_intv * 3 - 1)
                    self.state = self.state % 3 + 1
                    self._wisys:SetImageInList("Hecatia" .. self.state)
                end)
            end
            while self.state ~= 3 do
                self.ChangeState()
                task.Wait(24)
            end
        end)
        task.New(self, function()
            local attack = Class(bullet, {
                init = function(self, x, y)
                    bullet.init(self, arrow_small, 6, false, true)
                    self.x, self.y = x, y
                    self.vy = -4
                    self.rot = -90
                    PlaySound("tan00")
                end
            }, true)
            local center = Class(bullet, {
                init = function(self, x, y, mx, my)
                    bullet.init(self, ball_light, 6, false, false)
                    --object.SetSizeColli(self, 0.8, 0.8)
                    self.x, self.y = x, y
                    self.bound = false
                    self.dis = -180
                    task.New(self, function()
                        task.MoveToEx(mx - x, my - y, 100, 2)
                        while true do
                            New(attack, self.x - 5, self.y)
                            New(attack, self.x + 5, self.y)
                            task.Wait(6)
                        end
                    end)
                    task.New(self, function()
                        while true do
                            self.y = min(208, self.y + (-self.y + (player.y - self.dis) * min(1, 1 - abs(self.x - player.x) / 190) + my) * 0.05)
                            task.Wait()
                        end
                    end)
                end
            }, true)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            for x = -3, 3 do
                New(center, self.x, self.y, x * 60, ran:Float(50, 120))
            end
            task.Wait(100)
            Newcharge_out(self.x, self.y, 135, 206, 235, true)
            while true do
                task.MoveToPlayer(60, -120, 120, 140, 160,
                        23, 35, 10, 20, 2, 1)
                task.Wait(120)
            end
        end)
    end

    local od_name = "「溪云初起，山雨欲来-Overdrive」"
    local sc_od1 = boss.card.New(od_name, 2, 2, 60, 1200)
    local sc_od2 = boss.card.New(od_name, 2, 2, 60, 1200)
    sc_od1.frame = boss.card.PublicHP
    sc_od2.frame = boss.card.PublicHP
    boss.card.add({ { sc_od1, "4a" }, { sc_od2, "4b" } }, 14, od_name, 193, 16)
    function sc_od1:before()
        boss.ns_group.nextcard(self, 0, 400)
        task.MoveTo(0, 50, 60, 2)
    end
    function sc_od2:before()
        boss.ns_group.nextcard(self, 0, 400)
        boss.show_aura(self, true)
        task.MoveTo(0, 150, 60, 2)
    end
    function sc_od1:init()
        task.New(self, function()
            local aim = Class(bullet, {
                init = function(self, x, y, v, a, t, v2)
                    bullet.init(self, ball_huge, 16, false, true)
                    self.x, self.y = x, y
                    self.omiga = 2
                    object.SetV(self, v, a)
                    task.New(self, function()
                        x, y = player.x, player.y
                        object.ChangingV(self, v, 0, a, t, false)
                        task.Wait(30)
                        object.ChangingV(self, 0, v2, Angle(self, x, y) + ran:Float(-5, 5), 110, false)
                    end)
                end
            }, true)
            task.Wait(60)
            PlaySound("ch02")
            New(boss_cast_darkball, self.x, self.y, 60, 80, 360, 1, 270, 64, 64, 255, 2)
            New(boss_cast_darkball, self.x, self.y, 60, 80, 360, 1, 270, 255, 64, 64, -2)
            task.Wait(80)
            boss.cast(self, 3600)
            task.Wait(60)
            local a = ran:Float(0, 360)
            while true do

                New(aim, self.x, self.y, ran:Float(2.8, 3.2), a, ran:Int(60, 70), 5)
                PlaySound("kira00")
                task.Wait(10)
                a = a + 36
            end
        end)
    end
    function sc_od2:init()
        task.New(self, function()
            self.state = self.state or 1
            self.ChangeState = self.ChangeState or function()
                task.New(self, function()
                    PlaySound("heal")
                    boss.cast(self, 0)
                    task.Wait(self.ani_intv * 3 - 1)
                    self.state = self.state % 3 + 1
                    self._wisys:SetImageInList("Hecatia" .. self.state)
                end)
            end
            while self.state ~= 3 do
                self.ChangeState()
                task.Wait(24)
            end
        end)
        task.New(self, function()
            local attack = Class(bullet, {
                init = function(self, x, y)
                    bullet.init(self, arrow_small, 8, false, true)
                    self.x, self.y = x, y
                    self.vy = -3.7
                    self.rot = -90
                    PlaySound("tan00")
                end
            }, true)
            local center = Class(bullet, {
                init = function(self, x, y, mx, my)
                    bullet.init(self, ball_light, 8, false, false)
                    --object.SetSizeColli(self, 0.8, 0.8)
                    self.x, self.y = x, y
                    self.bound = false
                    self.dis = player.y
                    task.New(self, function()
                        task.MoveToEx(mx - x, my - y, 100, 2)
                        while true do
                            New(attack, self.x - 5, self.y)
                            New(attack, self.x + 5, self.y)
                            task.Wait(7)
                        end
                    end)
                    task.New(self, function()
                        while true do
                            self.y = min(208, self.y + (-self.y + (player.y - self.dis) * min(1, 1 - abs(self.x - player.x) / 190) + my) * 0.05)
                            task.Wait()
                        end
                    end)
                end
            }, true)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            for x = -3, 3 do
                New(center, self.x, self.y, x * 60, ran:Float(50, 120))
            end
            task.Wait(100)
            Newcharge_out(self.x, self.y, 135, 206, 235, true)
            while true do
                task.MoveToPlayer(60, -120, 120, 140, 160,
                        23, 35, 10, 20, 2, 1)
                task.Wait(120)
            end
        end)
    end
end--boss4
