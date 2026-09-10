local class = {}
_editor_class["TH10"] = class

local cos, sin, min, max, int, sign = cos, sin, min, max, int, sign
local bullet, object, laser, boss = bullet, object, laser, boss
local task, ran, Create, misc, sp = task, ran, Create, misc, sp
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
    class.SCBG1 = Class(_SC_BG)
    function class.SCBG1:init()
        _SC_BG.init(self)
        local b
        _SC_BG.AddLayer(self, "th10_0", false, 64, -32, 0, 0, 0, 0, "mul+rev")
        b = _SC_BG.AddLayer(self, "th10_1", true, 0, 0, 0, 0, -0.5, 0, "mul+add", 1, 1)
        b.a = 200
        b = _SC_BG.AddLayer(self, "th10_1", true, 256, 0, 0, 0, 0.5)
        b.r, b.g, b.b = 128, 128, 128
    end
    class.SCBG2 = Class(_SC_BG)
    function class.SCBG2:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th10_3", false, 0, 0, 0, 0, 0, 0.8, "mul+add", 2.3, 2.3)
        function b:Beforeframe()
            self.omiga = 1 + 0.5 * sin(self.timer / 3)
        end
        b = _SC_BG.AddLayer(self, "th10_5", true, 0, 0, 0, -0.3, 1.5, 0, "mul+add")
        b.a = 120
        _SC_BG.AddLayer(self, "th10_2", false, 0, 0, 0, 0, 0, 0, "mul+add")
        _SC_BG.AddLayer(self, "th10_4")
    end
    class.SCBG3 = Class(_SC_BG)
    function class.SCBG3:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th10_7", true, 0, 0, 0, -0.15, 0.75)
        b.a = 150
        function b:Beforeframe()
            self.r = 150 + cos(self.timer * 0.4) * 100
            self.g = 155 + sin(self.timer * 0.4) * 100
            self.b = 155 + cos(self.timer * 0.4) * 100
        end
        _SC_BG.AddLayer(self, "th10_6")
    end
    class.SCBG4 = Class(_SC_BG)
    function class.SCBG4:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th10_9", true, 0, 0, 0, 0, 0.8, 0, "mul+add")
        b.a = 180
        function b:Beforeframe()
            self.r = 150 + cos(self.timer * 0.4) * 100
            self.g = 155 + sin(self.timer * 0.4) * 100
            self.b = 155 + cos(self.timer * 0.4) * 100
        end
        b = _SC_BG.AddLayer(self, "th10_11", true, 0, 0, 0, 0, 0.3, 0, "mul+add")
        function b:Beforeframe()
            self.r = 150 + sin(self.timer * 0.4) * 100
            self.g = 155 + cos(self.timer * 0.4) * 100
            self.b = 155 + sin(self.timer * 0.4) * 100
        end
        b = _SC_BG.AddLayer(self, "th10_8", false, 0, 0, 0, 0, 0, 0, "mul+add")
        b.a = 150
        _SC_BG.AddLayer(self, "th10_10")
    end
    class.SCBG5 = Class(_SC_BG)
    function class.SCBG5:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th10_11", true, 0, 0, 0, 0, 0.3, 0, "mul+add")
        function b:Beforeframe()
            self.r = 150 + sin(self.timer * 0.4) * 100
            self.g = 155 + cos(self.timer * 0.4) * 100
            self.b = 155 + sin(self.timer * 0.4) * 100
        end
        b = _SC_BG.AddLayer(self, "th10_13", true, 0, 0, 0, -0.5, 0, 0, "mul+add")
        function b:Beforeframe()
            self.r = 150 + cos(self.timer * 0.4) * 100
            self.g = 155 + cos(self.timer * 0.4) * 100
            self.b = 155 + sin(self.timer * 0.4) * 100
        end
        b = _SC_BG.AddLayer(self, "th10_12_n", false, 0, 0, 0, 0, 0, 0, "", 0.5, 0.5)
        b.r, b.g, b.b = 150, 150, 150
    end
end
---_SC_BG
do
    class["bullet4-1"] = Class(bullet, {
        init = function(self, _x, _y, a, r, A, ag)
            bullet.init(self, ball_light, COLOR.ORANGE, false, true)
            self.x, self.y = _x, _y
            self.group = GROUP.ENEMY
            self.bound = false
            self.shoot = false
            self.navi = true
            local v = -2
            self.angle = A
            task.New(self, function()
                local xl = 0.7
                local l = 40
                local L
                while true do
                    L = sin(min(90, xl))
                    self.x = _x + cos(a) * L * l * cos(A + 90) - sin(a) * L * 40 * sin(A + 90)
                    self.y = _y + sin(a) * L * 40 * cos(A + 90) + cos(a) * L * l * sin(A + 90)
                    if a % 360 > 0 and a % 360 < 180 and self._a == 255 then
                        task.New(self, function()
                            self.colli = false
                            task.SmoothSetValueTo("_a", 80, 30, 2)
                        end)
                        task.New(self, function()
                            task.SmoothSetValueTo("hscale", 0.8, 30, 2)
                        end)
                        task.New(self, function()
                            task.SmoothSetValueTo("vscale", 0.8, 30, 2)
                        end)
                        self.layer = LAYER.ENEMY - 1
                    end
                    if a % 360 > 180 and a % 360 < 360 and self._a == 80 then
                        task.New(self, function()
                            task.SmoothSetValueTo("_a", 255, 30, 2)
                            self.colli = true
                        end)
                        task.New(self, function()
                            task.SmoothSetValueTo("hscale", 1, 30, 2)
                        end)
                        task.New(self, function()
                            task.SmoothSetValueTo("vscale", 1, 30, 2)
                        end)
                        self.layer = LAYER.ENEMY_BULLET + 1
                    end
                    task.Wait()
                    a = a + r
                    xl = xl + 0.7
                    l = l + 0.6
                    v = v + ag
                    _x = _x + cos(A) * v
                    _y = _y + sin(A) * v
                    if v > 0 and not self.shoot then
                        self.shoot = true
                    end
                end
            end)
            task.New(self, function()
                while not self.shoot do
                    coroutine.yield()
                end
                local d = 0
                while true do
                    New(class["bullet4-2"], self.x, self.y, self.colli, self.rot + d)
                    d = d + 180
                    task.Wait(3)
                end
            end)
        end,
        frame = function(self)
            bullet.frame(self)
            if Dist(self.x, self.y, 0, 0) > 450 then
                object.Del(self)
            end
        end })
    class["bullet4-2"] = Class(bullet, {
        init = function(self, _x, _y, colli, a)
            bullet.init(self, arrow_big, COLOR.ORANGE, true, true)
            self.x, self.y = _x, _y
            self.a = 0
            self.b = 0
            self.hscale = 0
            self.vscale = 0
            self.timer = 11
            PlaySound("kira00", 0.1, self.x / 256, true)
            if colli then
                _object.set_color(self, "mul+add", 255, 255, 255, 255)
                self.colli = true
                task.New(self, function()
                    for i = 0, 10 do
                        self.hscale = sin(i * 9)
                        self.vscale = self.hscale
                        self.a = 2.5 * self.hscale
                        self.b = self.a
                        coroutine.yield()
                    end
                end)
                self.layer = LAYER.ENEMY_BULLET + 1
            else
                _object.set_color(self, "mul+add", 70, 255, 255, 255)
                self.colli = false
                task.New(self, function()
                    for i = 0, 10 do
                        self.hscale = sin(i * 9) * 0.8
                        self.vscale = self.hscale
                        coroutine.yield()
                    end
                end)
                self.layer = LAYER.ENEMY - 1
            end
            object.ChangeVwithTask(self, 0, 3, a, 240)
        end,
        frame = function(self)
            bullet.frame(self)
            if self.y < -400 then
                object.Del(self)
            end
        end
    })
    class["bullet4-3"] = Class(bullet, {
        init = function(self, x, y, v, a, t, r, A)
            bullet.init(self, ball_huge, 2, false, true)
            self.x, self.y = x, y
            PlaySound("tan00")
            for i = 1, t do
                New(class["laser4-1"], self, i * 360 / t + A, r)
            end
            task.New(self, function()
                for i = 1, 60 do
                    object.SetV(self, v * sin(i * 1.5), a, true)
                    coroutine.yield()
                end
            end)
            task.New(self, function()
                while self.y > player.y do
                    coroutine.yield()
                end
                task.Wait()
                for i = 1, 30 do
                    object.SetV(self, v - (v / 3 * 2) * sin(i * 3), a, true)
                    coroutine.yield()
                end
            end)
        end
    })
    class["bullet4-4"] = Class(bullet, {
        init = function(self, master, range)
            bullet.init(self, water_drop, 6, true, true)
            PlaySound("tan00")
            self.master = master
            self.x, self.y = ran:Float(-192, 192), 236
            self.colli = false
            self._a = 50
            self.hscale = ran:Float(0.8, 1.6)
            self.vscale = self.hscale
            self.a = self.hscale * self.a
            self.b = self.a
            local v = 3.6
            object.SetV(self, v, ran:Float(-10, 10) - 90, true)
            local A = Angle(self, self.master)
            task.New(self, function()
                for i = 1, _infinite do
                    object.SetV(self, v, self.rot + (A - self.rot) * range * sin(min(i, 90)), true)
                    v = v + 0.01
                    coroutine.yield()
                    if IsValid(Hina) and Dist(self, Hina) < 48 then
                        break
                    end
                end
                self.colli = true
                self._a = 255
                Create.bullet_create_eff(self)
                object.SetV(self, ran:Float(2, 3), Angle(Hina, self), true)
                self.ag = 0.02
                self.navi = true
            end)
        end })
    class["bullet4-5"] = Class(bullet, {
        init = function(self, x, y, v, a, da, s, range)
            bullet.init(self, square, 8, false, true)
            self.timer = 11
            self.x, self.y = x, y
            self.s = s
            self.range = range
            object.SetV(self, v, a, true)
            task.New(self, function()
                task.Wait(15)
                object.SetV(self, v, a + da, true)
                task.Wait(15)
                object.SetV(self, v, a, true)
            end)
        end,
        frame = function(self)
            bullet.frame(self)
            self.s = self.s + self.range
            self._a = 128 + 127 * sin(self.s)
            if self._a > 220 then
                self.colli = true
            else
                self.colli = false
            end
        end })
    class["bullet4-6"] = Class(bullet, {
        init = function(self, col, x, y, l, a, r, v)
            bullet.init(self, water_drop, col, false, true)
            self.x, self.y = x + cos(a) * l, y + sin(a) * l
            self.colli = false

            self.rot = a + 180
            self.bound = false
            PlaySound("tan00")
            task.New(self, function()
                for i = 10, 0, -1 do
                    self.x, self.y = x + cos(a) * l, y + sin(a) * l
                    if Dist(self.x, self.y, player.x, player.y) < 48 then
                        object.Del(self)
                    end
                    l = l - v * sin(i * 9)
                    coroutine.yield()
                end
                self.colli = true
                task.Wait(60)
                for i = 1, _infinite do
                    self.rot = a + 180
                    self.x, self.y = x + cos(a) * l, y + sin(a) * l
                    if l < 8 then
                        object.Del(self)
                    end
                    a = a + r * sin(min(i, 90))
                    l = l - v * sin(min(i / 2, 90))
                    coroutine.yield()
                end
            end)
        end })
    class["bullet2-1"] = Class(bullet, {
        init = function(self, x, y, _x, _y, d)
            bullet.init(self, grain_b, 8, false, true)
            self.x, self.y = x, y
            self._x, self._y = _x, _y
            self.bound = false
            self.colli = false
            PlaySound("tan00", 0.1, self.x / 100, false)
            task.New(self, function()
                task.Wait(11)
                self.colli = true
            end)
            task.New(self, function()
                local a, l
                task.New(self, function()
                    while true do
                        a = Angle(self._x, self._y, self.x, self.y)
                        l = Dist(self._x, self._y, self.x, self.y)
                        self.rot = a + d
                        self.x, self.y = self._x + cos(a + d) * l, self._y + sin(a + d) * l
                        task.Wait()
                    end
                end)
                task.Wait(190)
                self.colli = false
                for i = 0, 10 do
                    self._a = 255 - 255 * sin(i * 9)
                    task.Wait()
                end
                object.RawDel(self)
            end)
        end })
end
---bullet
do
    class["laser4-1"] = Class(laser, {
        init = function(self, master, a, r)
            laser.init(self, COLOR.ORANGE, master.x, master.y, 0, 0, 0, 0, 12, 12, 0)
            laser._TurnHalfOn(self, 0, false)
            self.line = 0
            self.rot = a
            self.bound = false
            self.master = master
            self.Isradial = true
            self.radial_v = 8
            task.New(self, function()
                for i = 1, 45 do
                    self.line = sin(i * 2) * 500
                    self.omiga = r * sin(i * 2)
                    task.Wait()
                end
                while self.y > player.y do
                    coroutine.yield()
                end
                laser._TurnOn(self, 1, true, false)
                laser.ChangeImage(self, 1, 2)
                task.New(self, function()
                    for _ = 1, 40 do
                        self.l3 = self.l3 + 8
                        task.Wait()
                    end
                    for _ = 1, 40 do
                        self.l1 = self.l1 + 8
                        task.Wait()
                    end
                    laser._TurnOff(self, 30, true)
                    object.Del(self)
                end)
            end)
            task.New(self, function()
                while not self.jump do
                    task.Wait()
                end
                laser._TurnOff(self, 30, true)
                object.Del(self)
            end)
        end,
        frame = function(self)
            laser.frame(self)
            if IsValid(self.master) then
                self.x, self.y = self.master.x, self.master.y
            else
                self.jump = true
            end
        end,
        render = function(self)
            SetImageState("white", "mul+add", self.alpha * 180, unpack(ColorList[math.ceil(self.index / 2)]))
            Render("white", self.x + cos(self.rot) * self.line / 2, self.y + sin(self.rot) * self.line / 2, self.rot, self.line / 16, 0.125)
            laser.render(self)
        end
    })
    class["laser2-1"] = Class(bent_laser, {
        init = function(self, x, y, a, _x, _y, c, v, j, shoot)
            bent_laser.init(self, 6, x, y, 90, 8, 4, 6)
            object.SetV(self, v or 10, a, true)
            PlaySound("lazer00")
            c = c or 6
            task.New(self, function()
                task.CRMoveTo(200, 1,
                        x + cos(a + ran:Float(-15, 15)) * 100, y + sin(a + ran:Float(-15, 15)) * 100,
                        ran:Float(-150, 150), ran:Float(-120, 120),
                        _x, _y)
                local i = 1
                while shoot do
                    Create.bullet_dec_setangle(self.x, self.y, grain_a, 6,
                            { v = 1, a = self.rot + 180 + sin(i * 3) * 30, time = 50, wait = 30 }, { v = 2, a = self.rot + i * c })
                    Create.bullet_dec_setangle(self.x, self.y, grain_a, 6,
                            { v = 1, a = self.rot - 180 - sin(i * 3) * 30, time = 50, wait = 30 }, { v = 2, a = self.rot - i * c })
                    i = i + 1
                    task.Wait(j or 2)
                end
            end)
        end })
    class["laser2-2"] = Class(laser, {
        init = function(self, x, y, i, w)
            laser.init(self, 6, x, y + 1024, -90, 512, 10, 512, 32, 0, 0)
            self.layer = LAYER.ENEMY_BULLET - 1
            laser._TurnOn(self, 1, true)
            self.bound = false
            task.New(self, function()
                task.MoveTo(x, y + 768, 60, 2)
                task.Wait(w or 140)
                if i then
                    laser.ChangeImage(self, 1, 2)
                    self._a = 150
                    self.colli = false
                end
                task.Wait(w or 120)
                PlaySound("boon00")
                for v = 1, 90 do
                    object.SetV(self, 10 * sin(v), -90)
                    task.Wait()
                end
                while true do
                    if self.y < -230 then
                        object.Del(self)
                    end
                    coroutine.yield()
                end
            end)
        end })
    class["laser2-3"] = Class(laser, {
        init = function(self, master, rot, omiga)
            laser.init(self, 2, master.x, master.y, rot, 0, 0, 0, 18, 10, 0)
            laser._TurnHalfOn(self, 0, false)
            self.master = master
            self.omiga = omiga
            self.line = 0
            self.Isradial = true
            self.radial_v = 20
            task.New(self, function()
                for i = 1, 45 do
                    self.line = sin(i * 2) * 700
                    task.Wait()
                end
                for i = 1, 8 do
                    Create.laser_line(self.x, self.y, 2, 10 + i / 4, self.rot, 15 + i * 3, 6)
                    task.Wait(10 - i)
                end
                laser._TurnOn(self, 1, true, false)
                task.New(self, function()
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
            end)
        end,
        frame = function(self)
            laser.frame(self)
            if not IsValid(self.master) then
                object.Del(self)
                return
            end
            self.x, self.y = self.master.x, self.master.y
        end,
        render = function(self)
            SetImageState("white", "mul+add", self.alpha * 180, unpack(ColorList[math.ceil(self.index / 2)]))
            Render("white", self.x + cos(self.rot) * self.line / 2, self.y + sin(self.rot) * self.line / 2, self.rot, self.line / 16, 0.125)
            laser.render(self)
        end })
end
---laser
do
    CreateRenderTarget("_KanakoLightBack_")
    class["KanakoLightBack"] = Class(object, {
        init = function(self, master, radius, range)
            self.master = master
            self.group = GROUP.GHOST
            self.layer = LAYER.BG + 0.8
            self.bound = false
            self.circle = {
                { color = { 255, 0, 0 }, x = 500, y = 500 },
                { color = { 0, 255, 0 }, x = 500, y = 500 },
                { color = { 0, 0, 255 }, x = 500, y = 500 },
            }
            self.pillar = { New(self.class.pillar, self, "left", -500, 0), New(self.class.pillar, self, "right", 500, 0) }
            self.event = {}
            self.rotate = false
            self.rotate_radius = radius or 100
            self.rotate_timer = 0
            self.rotate_range = range or 3
            setmetatable(self.event, {
                __newindex = function(_, k, v)
                    if k == "open" then
                        task.New(self, function()
                            for i = 1, v do
                                for a, c in ipairs(self.circle) do
                                    c.x = cos(a * 120 + 360 * sin(i / v * 90)) * 400 * (1 - i / v)
                                    c.y = sin(a * 120 + 360 * sin(i / v * 90)) * 400 * (1 - i / v)
                                end
                                self.pillar[1]._x = -500 + 500 * sin(i / v * 90)
                                self.pillar[2]._x = 500 - 500 * sin(i / v * 90)
                                coroutine.yield()
                            end
                        end)
                    elseif k == "close" then
                        self.circle = {
                            { color = { 255, 0, 0 }, x = 500, y = 500 },
                            { color = { 0, 255, 0 }, x = 500, y = 500 },
                            { color = { 0, 0, 255 }, x = 500, y = 500 },
                        }
                        self.pillar = { New(self.class.pillar, self, "left", -500, 0), New(self.class.pillar, self, "right", 500, 0) }
                        enemy.death_ef(self.x, self.y, 10, 1)
                        PlaySound("explode")
                    elseif k == "rotate" then
                        self.rotate = v
                        if not v then
                            enemy.death_ef(self.x, self.y, 10, 1)
                        end
                        self.rotate_timer = 0
                        for _, c in ipairs(self.circle) do
                            c.x = 0
                            c.y = 0
                        end
                    end
                end })
        end,
        frame = function(self)
            if not IsValid(self.master) then
                object.Del(self)
                return
            end
            task.Do(self)
            self.x, self.y = self.master.x, self.master.y + 4 * sin(self.master.ani * 4)
            if self.rotate then
                local t, rad, range = self.rotate_timer, self.rotate_radius, self.rotate_range
                for a, c in ipairs(self.circle) do
                    c.x = cos(t * sign(range) + a * 120) * rad + cos(t * range + a * 120 + 180) * rad
                    c.y = sin(t * sign(range) + a * 120) * rad + sin(t * range + a * 120 + 180) * rad
                end
                self.rotate_timer = self.rotate_timer + 1
            end
        end,
        render = function(self)
            if not IsValid(self.master) then
                return
            end
            for _, c in ipairs(self.circle) do
                SetImageState("kanako-ef", "mul+add", 128, unpack(c.color))
                Render("kanako-ef", self.x + c.x, self.y + c.y)
            end
        end,
        pillar = Class(object, {
            init = function(self, master, img, x, y)
                self.group = GROUP.GHOST
                self.layer = LAYER.BG + 10
                self.master = master
                self.img = "kanako-ef2_" .. img
                self._x = x
                self._y = y
                self.x = self.master.x + self._x
                self.y = self.master.y + self._y
                self.bound = false
            end,
            frame = function(self)
                task.Do(self)
                if not IsValid(self.master) then
                    object.Del(self)
                    return
                end
                self.x = self.master.x + self._x
                self.y = self.master.y + self._y
            end,
        }, true),
        del = function(self)
            enemy.death_ef(self.x, self.y, 10, 1)
        end,
        kill = function(self)
            self.class.del(self)
        end,
    })
    class["StarDrawer"] = Class(object, {
        init = function(self, x, y, n, rot, len, v, interval, event)
            local a = 360 / n + 90
            local l = (len * v / 2) * (1 / cos(180 - a))
            self.x, self.y = x + cos(a + rot) * l, y + sin(a + rot) * l
            self._x, self._y = x, y
            self.group = GROUP.INDES
            self.hide = true
            self.bound = false
            self.n = n
            self.len = len
            self.interval = interval
            self.event = event
            self.rot = rot
            self.FrameCount = 0
            task.New(self, function()
                local V, A
                for _ = 1, n do
                    V, A = v * self.interval, self.rot
                    for _ = 1, len / self.interval do
                        self.x = self.x + cos(A) * V
                        self.y = self.y + sin(A) * V
                        self.event(self, self._x, self._y)
                        coroutine.yield()
                    end
                    self.timer = 0
                    self.rot = self.rot - 720 / n
                end
                object.RawDel(self)
            end)
        end,
        frame = function(self)
            self.FrameCount = self.FrameCount + 1 / self.interval
            for _ = 1, self.FrameCount do
                self.timer = self.timer + 1
                task.Do(self)
                self.FrameCount = self.FrameCount - 1
            end
            self.timer = self.timer - 1
        end })
end
---_object
do
    boss.Define("1a", "秋静叶", "TH10_4", TH10_bg, { -400, 0 }, class["SCBG1"], "Sizuha", 6)
    boss.Define("1b", "秋穰子", "TH10_4", TH10_bg, { -400, 0 }, class["SCBG1"], "Minoriko", 6)
    local name = "丰报「秋分立秋社」"
    local sc1 = boss.card.New(name, 1, 1, 60, 550)
    local sc2 = boss.card.New(name, 1, 1, 60, 550)
    boss.card.add({ { sc1, "1a" }, { sc2, "1b" } }, 6, name, 53)
    function sc1:before()
        self.bright = {}
        task.MoveTo(-50, 144, 60, 2)
    end
    function sc1:init()
        local wait = 120
        task.New(self, function()
            boss.violent(self)
            boss.card.UnlockOD(self, 22)
            wait = 0
            task.Wait(60)
            local a, d
            while true do
                d = ran:Sign()
                a = ran:Float(0, 360)
                for i = 1, 180 do
                    table.insert(self.bright, { x = self.x, y = self.y, _x = self.x, _y = self.y,
                                                a = i * 2, timer = 1, A = -90, xl = 40, yl = 40, v = -2, ag = 0.03,
                                                _a = ((i * 2 % 360 > 180 and i * 2 % 360 < 360) and 255) or 80 })
                end
                PlaySound("nice", 1)
                for _ = 1, 6 do
                    object.Connect(self, New(class["bullet4-1"], self.x, self.y, a, d, -90, 0.03), 0, true)
                    a = a + 60
                end
                task.Wait(240)
            end
        end)
        task.New(self, function()
            local a, d
            while true do
                d = ran:Sign()
                a = ran:Float(0, 360)
                for i = 1, 180 do
                    table.insert(self.bright, { x = self.x, y = self.y, _x = self.x, _y = self.y,
                                                a = i * 2, timer = 1, A = Angle(self, player), xl = 40, yl = 40, v = -2, ag = 0.02,
                                                _a = ((i * 2 % 360 > 180 and i * 2 % 360 < 360) and 255) or 80 })
                end
                PlaySound("nice", 1)
                for _ = 1, 7 do
                    object.Connect(self, New(class["bullet4-1"], self.x, self.y, a, d * 0.7, Angle(self, player), 0.02), 0, true)
                    a = a + 360 / 7
                end
                task.Wait(120)
                task.MoveToPlayer(60, -120, 0, 100, 144, 20, 40, 10, 20, 2, 1)
                task.Wait(wait)
            end
        end)
    end
    function sc1:frame()
        local b
        for i = #self.bright, 1, -1 do
            b = self.bright[i]
            b.x, b.y = sp.math.EllipsePoint(b._x, b._y, b.xl * sin(min(90, b.timer * 0.7)), b.yl * sin(min(90, b.timer * 0.7)), b.A + 90, b.a)
            b.xl = b.xl + 0.6
            b.v = b.v + b.ag
            b._x = b._x + cos(b.A) * b.v
            b._y = b._y + sin(b.A) * b.v
            b.timer = b.timer + 1
            if Dist(b.x, b.y, 0, 0) > 450 then
                table.remove(self.bright, i)
            end
        end
    end
    function sc1:render()
        local b
        for i = #self.bright, 1, -1 do
            b = self.bright[i]
            SetImageState("bright", "mul+add", b._a, 127, 113, 66)
            Render("bright", b.x, b.y, 0, 0.06)
        end
    end

    function sc2:before()
        task.MoveTo(50, 80, 60, 2)
    end
    function sc2:init()
        local w
        local c = 8
        local lw = 7
        task.New(self, function()
            boss.violent(self)
            w = 22
            c = 12
            lw = 15
        end)
        task.New(self, function()
            while true do
                Newcharge_in(self.x, self.y, 250, 128, 114)
                task.Wait(60)
                if w then
                    for i = 1, w do
                        Create.bullet_decel(self.x, self.y, grain_b, 2, 4, ({ 1.5, 2 })[i % 2 + 1], i * 360 / w)
                    end
                end
                New(class["bullet4-3"], self.x, self.y, 3, Angle(self, player), lw, ran:Sign() * 0.4, Angle(self, player))
                task.Wait(260)
                if w then
                    for v = 1, 6 do
                        for i = 1, w do
                            Create.bullet_accel(self.x, self.y, grain_b, 2, 0.5, 2 + v * 0.3, i * 360 / w + v * 360 / w / 2)
                        end
                    end
                end
                local j = 1
                for i = 1, c do
                    New(class["bullet4-3"], self.x, self.y, 2, i * 360 / c, 5, j * 0.3, i * 360 / c)
                    j = -j
                end
                task.MoveToPlayer(120, 0, 120, 100, 144,
                        20, 40, 10, 20, 2, 1)
                task.Wait(100)
            end
        end)
    end

    local od_name="丰报「翻滚的稻穗-Overdrive」"
    local od_sc = boss.card.New(od_name, 2, 4, 60, 700)
    boss.card.add({ { od_sc, "1a" } }, 6, od_name, 218, 22)
    function od_sc:before()
        self.bright = {}
        task.MoveTo(0, 120, 60, 2)
    end
    function od_sc:init()
        task.New(self, function()
            local d = 1
            while true do
                local A = Angle(self, player)

                local a = ran:Float(0, 360)
                for k = -1, 1 do
                    for m in sp.math.AngleIterator(0, 200) do
                        table.insert(self.bright, { x = self.x, y = self.y, _x = self.x, _y = self.y,
                                                    a = m, timer = 1, A = A, xl = 40, yl = 40, v = -2, ag = 0.02 + 0.0005 * k,
                                                    _a = ((m % 360 > 180 and m % 360 < 360) and 255) or 80 })
                    end
                end
                PlaySound("nice", 1)
                for _a in sp.math.AngleIterator(a, 16) do
                    object.Connect(self, New(class["bullet4-1"], self.x, self.y, _a, d, A, 0.02), 0, true)
                end
                task.Wait(180)
                task.MoveToPlayer(60, -96, 96, 100, 144,
                        20, 40, 10, 20, 2, 1)
                d = -d
            end
        end)
    end
    function od_sc:frame()
        local b
        for i = #self.bright, 1, -1 do
            b = self.bright[i]
            b.x, b.y = sp.math.EllipsePoint(b._x, b._y, b.xl * sin(min(90, b.timer * 0.7)), b.yl * sin(min(90, b.timer * 0.7)), b.A + 90, b.a)
            b.xl = b.xl + 0.6
            b.v = b.v + b.ag
            b._x = b._x + cos(b.A) * b.v
            b._y = b._y + sin(b.A) * b.v
            b.timer = b.timer + 1
            if Dist(b.x, b.y, 0, 0) > 450 then
                table.remove(self.bright, i)
            end
        end
    end
    function od_sc:render()
        local b
        for i = #self.bright, 1, -1 do
            b = self.bright[i]
            SetImageState("bright", "mul+add", b._a, 127, 113, 66)
            Render("bright", b.x, b.y, 0, 0.06)
        end
    end
end
---boss1
do
    boss.Define("2a", "键山雏", "TH10_4", TH10_bg, { 400, 0 }, class["SCBG2"], "Hina", 6)
    boss.Define("2b", "河城荷取", "TH10_4", TH10_bg, { 400, 0 }, class["SCBG2"], "Nitori", 6)
    local name = "厄水「江淮水灾之惩」"
    local sc1 = boss.card.New(name, 1, 1, 60, 500)
    local sc2 = boss.card.New(name, 1, 1, 61, 500)
    boss.card.add({ { sc1, "2a" }, { sc2, "2b" } }, 6, name, 54)
    function sc1:before()
        Hina = self
        self.smear = {}
        task.BezierMoveTo(120, 2, 200, 0, -370, 120)
    end
    function sc1:init()
        local wait = 6
        local s_d = 4
        local v = 3
        local a_v = 0
        local at = 60
        task.New(self, function()
            boss.violent(self)
            wait = 4
            s_d = 17
            v = 3
            at = 150
            a_v = 0.7
        end)
        task.New(self, function()
            local s = 0
            while true do
                task.BezierMoveTo(200, 3, ran:Float(-100, 100), ran:Float(-100, 100), 380 * cos(s), ran:Float(100, 160))
                s = s + 25
                task.BezierMoveTo(200, 3, ran:Float(-100, 100), ran:Float(-100, 100), -380 * cos(s), ran:Float(100, 160))
                s = s + 25
            end
        end)
        local a
        task.New(self, function()
            local s = 0
            local t = 0
            while true do
                for j = -1, 1 do
                    a = math.deg(math.atan2(self.dy, self.dx)) + j * (10 + sin(s) * at)
                    Create.bullet_dec_setangle(self.x + cos(a) * 48, self.y + sin(a) * 48, square, 3 + t % 2,
                            { v = v, a = a, time = 60, wait = 10 },
                            { v = 1 + t % 2 + a_v, a = Angle(self, player) + j * 10, time = 60, wait = 10 })
                end
                s = s + s_d
                t = t + 1
                task.Wait(wait)
            end
        end)
    end
    function sc1:frame()
        if self.ani % 3 == 0 then
            table.insert(self.smear, { x = self.x, y = self.y + 4 * sin(self.ani * 4), rot = self.rot,
                                       alpha = 250, img = self.img, hscale = self.hscale, vscale = self.vscale })
        end
        for _, s in ipairs(self.smear) do
            s.alpha = max(0, s.alpha - 8)
        end
        for i = #self.smear, 1, -1 do
            if self.smear[i].alpha == 0 then
                table.remove(self.smear, i)
            end
        end
    end
    function sc1:render()
        for _, s in ipairs(self.smear) do
            SetImageState(s.img, "mul+add", s.alpha, 153, 51, 250)
            Render(s.img, s.x, s.y, s.rot, s.hscale, s.vscale)
        end
        SetImageState("circle_charge", "mul+add", 255 * min(1, self.ani / 90), 218, 112, 214)
        Render('circle_charge', self.x, self.y, 0, 48 / 256)
    end

    function sc2:before()
        task.MoveTo(0, 120, 60, 2)
    end
    function sc2:init()
        local open
        local para = { v = 3, w = 18, wait = 6, range = 5 }
        task.New(self, function()
            local s = 0
            while true do
                for i = 1, para.w do
                    New(class["bullet4-5"], self.x, self.y, para.v, i * 360 / para.w, 30 + sin(s) * 30, s + i * 360 / para.w, para.range)
                end
                s = (s + 5) % 360
                if s == 0 then
                    PlaySound("kira00")
                end
                task.Wait(para.wait)
            end
        end)
        task.New(self, function()
            boss.violent(self)
            open = true
            para = { v = 6, w = 36, wait = 3, range = 10 }
            task.Wait(60)
            Newcharge_out(self.x, self.y, 32, 32, 128)

            task.New(self, function()
                while true do
                    NewSimpleBullet(water_drop, 6, ran:Float(-192, 192), 224, ran:Float(2, 3), -90)
                    task.Wait(10)
                end
            end)
        end)
        task.New(self, function()
            while true do
                for _ = 1, 2 do
                    New(class["bullet4-4"], self, 0.05)
                end
                coroutine.yield()
            end
        end)
        task.New(self, function()
            while true do
                task.Wait(160)
                task.MoveToPlayer(120, -170, 170, 80, 144,
                        80, 120, 30, 60, 2, 3)
            end
        end)
    end
end
---boss2
do
    boss.Define("3a", "犬走椛", "TH10_4", TH10_bg, { 200, 400 }, class["SCBG3"], "Momizi", 6)
    boss.Define("3b", "射命丸文", "TH10_4", TH10_bg, { -200, 400 }, class["SCBG3"], "Aya", 6)
    local name = "祸斗「焚爇墙宇，烟焰四合」"
    local sc1 = boss.card.New(name, 1, 1, 60, 650)
    local sc2 = boss.card.New(name, 1, 1, 60, 400)
    boss.card.add({ { sc1, "3a" }, { sc2, "3b" } }, 6, name, 55)

    function sc1:before()
        task.MoveTo(0, 30, 60, 2)
    end
    function sc1:init()
        local w = 5
        task.New(self, function()
            boss.violent(self)
            w = 12
        end)
        task.New(self, function()
            local d = 1
            while true do
                boss.cast(self, 60)
                for i = 1, 12 do
                    for j = 1, w do
                        New(class["bullet4-6"], 2, self.x, self.y, 150 + j * 30, i * 30 + j * 15, (0.5 + j * 0.2) * d, 8)
                    end
                end
                task.Wait(150)
                Newcharge_out(self.x, self.y, 128, 114, 128)
                for i = 1, 12 do
                    for j = 1, w do
                        (NewSimpleBullet(ball_big, 14, self.x, self.y, 2 + j * 0.5, i * 30 + j * 15))._blend = "mul+add"
                    end
                end
                d = -d
                task.MoveToPlayer(60, -96, 96, 0, 60,
                        20, 40, 12, 24, 2, 1)
            end
        end)
    end

    function sc2:before()
        self.aimline = {}
        task.MoveTo(70, 120, 60, 2)
    end
    function sc2:init()
        local cao
        task.New(self, function()
            boss.violent(self)
            cao = true
        end)
        task.New(self, function()
            while not cao do
                task.Wait(60)
                local x, y = ran:Float(-100, 100), ran:Float(400, 450)
                self.aimline = { x = x, y = y, rot = Angle(x, y, player.x, player.y), w = 0 }
                task.New(self, function()
                    for i = 1, 30 do
                        self.aimline.w = sin(i * 3) * 30
                        coroutine.yield()
                    end
                end)
                if cao then
                    break
                end
                task.MoveToPlayer(60, -96, 96, 100, 144,
                        20, 40, 12, 24, 2, 1)
                if cao then
                    break
                end
                boss.cast(self, 120)
                Newcharge_in(self.x, self.y, 128, 32, 32)
                task.Wait(60)
                if cao then
                    break
                end
                task.MoveTo(x, y, 60, 2)
                if cao then
                    break
                end
                task.New(self, function()
                    self.aimline.lock = true
                    for i = 29, 0, -1 do
                        self.aimline.w = sin(i * 3) * 30
                        coroutine.yield()
                    end
                    self.aimline = {}
                end)
                local a = self.aimline.rot
                local b = Create.laser_line(self.x, self.y, 2, 14, a, 40, 25, 10)
                b.bound = false
                b.frame_new = function(self)
                    laser.frame(self)
                    if self.y < -224 then
                        object.Del(self)
                    end
                end
                object.SetV(self, 10, a)
                misc.ShakeScreen(100, 2)
                for _ = 1, 100 do
                    b = NewSimpleBullet(grain_b, ran:Int(1, 2),
                            self.x + ran:Float(-15, 15), self.y + ran:Float(-15, 15),
                            ran:Float(1, 2), a + 180 + ran:Float(-45, 45))
                    PlaySound("tan00", 0.1, self.x / 256)
                    b.ag = 0.02
                    b.maxvy = 3
                    b.navi = true
                    coroutine.yield()
                end
                if cao then
                    break
                end
                object.StopMoving(self)
                task.Wait(60)
                if cao then
                    break
                end
                self.x, self.y = 400, 400
                task.MoveTo(ran:Float(30, 120), ran:Float(100, 120), 60, 2)
                if cao then
                    break
                end
            end
            self.aimline = { x = 0, y = 400, rot = Angle(0, 400, player.x, player.y), w = 0 }
            task.New(self, function()
                for i = 1, 30 do
                    self.aimline.w = sin(i * 3) * 30
                    coroutine.yield()
                end
            end)
            task.MoveTo(0, 400, 60, 2)
            local b
            while true do
                object.SetV(self, 15, self.aimline.rot)
                b = Create.laser_line(self.x, self.y, 2, 20, self.aimline.rot, 40, 25, 10)
                b.bound = false
                b.frame_new = function(self)
                    laser.frame(self)
                    if self.y < -224 then
                        object.Del(self)
                    end
                end
                misc.ShakeScreen(60, 1)
                for _ = 1, 60 do
                    b = NewSimpleBullet(grain_b, ran:Int(1, 2),
                            self.x + ran:Float(-15, 15), self.y + ran:Float(-15, 15),
                            ran:Float(1, 2), self.aimline.rot + 180 + ran:Float(-45, 45))
                    PlaySound("tan00", 0.1, self.x / 256)
                    b.ag = 0.02
                    b.maxvy = 3
                    b.navi = true
                    coroutine.yield()
                end
                task.Wait(20)
                self.x, self.y = 0, 400
            end
        end)
    end
    function sc2:frame()
        if self.aimline.rot and not self.aimline.lock then
            self.aimline.rot = self.aimline.rot + (Angle(self.aimline.x, self.aimline.y, player.x, player.y) - self.aimline.rot) * 0.1
        end
    end
    function sc2:render()
        if self.aimline.w then
            SetImageState("white", "mul+add", 30, 250, 128, 114)
            Render("white", self.aimline.x, self.aimline.y, self.aimline.rot, 187, (self.aimline.w * 1.5) / 8)
            SetImageState("white", "mul+add", 120, 250, 128, 114)
            Render("white", self.aimline.x, self.aimline.y, self.aimline.rot, 187, self.aimline.w / 8)
        end
    end
    function sc2:del()
        object.StopMoving(self)
    end
end
---boss3
do
    boss.Define("4a", "东风谷早苗", "TH10_2", TH10_bg, { 200, 400 }, class["SCBG4"], "Sanae", 6)
    boss.Define("4b", "八坂神奈子", "TH10_2", TH10_bg, { -200, 400 }, class["SCBG4"], "Kanako", 6)
    local non_sc1 = boss.card.New("", 1, 1, 60, 600)
    local non_sc2 = boss.card.New("", 1, 1, 60, 600)
    boss.card.add({ { non_sc1, "4a" }, { non_sc2, "4b" } }, 6, "非符", 56)

    function non_sc1:before()
        boss.ns_group.init(self)
        if ext.sc_pr then
            lstg.tmpvar.bg.change = true
        end
        task.MoveTo(0, 160, 120, 2)
    end
    function non_sc1:init()
        local para = { m = 18, ra = 1, i = 30, v = 1.9 }
        task.New(self, function()
            boss.violent(self)
            para = { m = 36, ra = 1.5, i = 59, cao = true, v = 3.3 }
        end)
        task.New(self, function()
            local d = 1
            while true do
                local a1 = ran:Float(0, 360)
                local a2 = ran:Float(0, 360)
                local A
                local t
                boss.cast(self, 180)
                for _ = 1, para.m do
                    PlaySound("tan00")
                    for v = 1, 5 do
                        for a = 1, 4 do
                            t = 25 + v * 0.5
                            A = a * 90 + a1 + v * para.ra
                            NewSimpleBullet(grain_a, 4, self.x + cos(A) * t, self.y + sin(A) * t, 2 + v * 0.08, A)
                            A = a * 90 + a2 - v * para.ra
                            NewSimpleBullet(grain_a, 2, self.x + cos(A) * t, self.y + sin(A) * t, 2 + v * 0.08, A)
                        end
                    end
                    a1 = a1 + 18 - d * 8
                    a2 = a2 - 18 + d * 8
                    task.Wait(180 / para.m)
                end
                task.Wait(50)
                task.MoveTo(130 * d, 60, 59, 2)
                task.Wait()
                PlaySound("kira00")
                boss.cast(self, 180)
                local b
                for v = para.v, para.v + 1, 0.3 do
                    for i = 1, para.i do
                        b = NewSimpleBullet(ellipse, 10, self.x, self.y, v, Angle(self, player) + i * 360 / para.i)
                        b.timer = 11
                    end
                end
                local ang = Angle(self, player)
                if para.cao then
                    New(class["StarDrawer"], self.x, self.y, 5, ang + 180, 24, 5, 1, function(self, x, y)
                        Create.bullet_dec_setangle(self.x, self.y, grain_b, 10,
                                { v = Dist(x, y, self.x, self.y) / 60, a = Angle(x, y, self.x, self.y), time = 60, wait = 120 - self.ani },
                                { v = 2, a = 70 + self.rot + self.timer / 24 * 180 })
                    end)
                end
                New(class["StarDrawer"], self.x, self.y, 5, ang, 24, 5, 1, function(self, x, y)
                    Create.bullet_dec_setangle(self.x, self.y, grain_b, 10,
                            { v = Dist(x, y, self.x, self.y) / 60, a = Angle(x, y, self.x, self.y), time = 60, wait = 120 - self.ani },
                            { v = 2, a = 70 + self.rot + self.timer / 24 * 180 })
                end)
                task.Wait(60)
                d = -d
                task.Wait(120)
                task.MoveTo(0, 160, 59, 2)
                task.Wait()
            end
        end)
    end
    non_sc1.del = boss.ns_group.del

    function non_sc2:before()
        boss.ns_group.init(self)
        if ext.sc_pr then
            lstg.tmpvar.bg.change = true
        end
        self.lightback = New(class["KanakoLightBack"], self)
        self.lightback.event.open = 120
        task.MoveTo(0, 80, 120, 2)
    end
    function non_sc2:init()
        local para = { i = 30, v = 1.9, w = 2, fv = 0.5 }
        task.New(self, function()
            boss.violent(self)
            para = { i = 59, v = 3.3, w = 5, fv = 1.5 }
        end)
        task.New(self, function()
            local d = 1
            while true do
                Newcharge_out(self.x, self.y, 128, 32, 32)
                boss.cast(self, 180)
                local a
                for i = 1, 60 do
                    for v = 1, 6 do
                        for c = 1, para.w do
                            a = i * 55 * d + c * 360 / para.w
                            NewSimpleBullet(grain_a, 6, self.x + cos(a) * 20, self.y + sin(a) * 20, 2 + v * 0.3, a)
                        end
                        PlaySound("tan00")
                    end
                    task.Wait(3)
                end

                task.Wait(50)
                task.MoveTo(-130 * d, 60, 59, 2)
                task.Wait()
                PlaySound("kira00")
                boss.cast(self, 180)
                local b
                for v = para.v, para.v + 1, 0.3 do
                    for i = 1, para.i do
                        b = NewSimpleBullet(ellipse, 8, self.x, self.y, v, Angle(self, player) + i * 360 / para.i)
                        b.timer = 11
                    end
                end
                for i = 0, 59 do
                    for A = 1, 6 do
                        for v = 0.5, para.fv do
                            Create.bullet_dec_setangle(self.x, self.y, grain_b, 8,
                                    { v = v + 2 * sin(90 * sin(i * 3)), a = A * 60 + i * d, time = 80, wait = 30 },
                                    { v = v + 1.5, a = 180 + A * 60 + int(i / 5) * 33 - (i % 5 - 2) * 3 })
                        end
                    end
                    coroutine.yield()
                end
                d = -d
                task.Wait(120)
                task.MoveTo(0, 80, 59, 2)
                task.Wait()
            end
        end)
    end
    function non_sc2:del()
        self.lightback.event.close = true
        boss.ns_group.del(self)
    end

    local name = "「御柱祭-寒水豪血」"
    local sc1 = boss.card.New(name, 1, 1, 60, 900)
    local sc2 = boss.card.New(name, 1, 1, 60, 900)
    boss.card.add({ { sc1, "4a" }, { sc2, "4b" } }, 6, name, 57)

    function sc1:before()
        boss.ns_group.nextcard(self)
        Sanae = self
        if ext.sc_pr then
            lstg.tmpvar.bg.change = true
        end
        task.MoveTo(0, 50, 60, 2)
    end
    function sc1:init()
        local cao
        task.New(self, function()
            boss.violent(self)
            cao = true
        end)
        task.New(self, function()
            while true do
                boss.cast(self, 240)
                New(class["StarDrawer"], self.x, self.y, 7, 0, 3, 40, 0.15, function(self, x, y)
                    Create.bullet_dec_setangle(self.x, self.y, grain_a, 4,
                            { v = 4, a = 180 + Angle(x, y, self.x, self.y), time = 60, wait = 21 - self.ani },
                            { v = self.timer % 2 + 2, a = self.rot + self.timer / 30 * 90, time = 60, wait = 30 - self.ani })
                    Create.bullet_dec_setangle(self.x, self.y, ball_small, 4,
                            { v = 3, a = 180 + Angle(x, y, self.x, self.y), time = 60, wait = 21 - self.ani },
                            { v = (self.timer - 1) % 2 + 2, a = self.rot + self.timer / 30 * 180, time = 60, wait = 30 - self.ani })
                end)
                task.MoveToPlayer(92, -100, 100, 50, 120, 32, 64, 20, 40, 2, 1)
                Newcharge_out(self.x, self.y, 32, 128, 32)
                task.Wait(87)
                if cao then
                    while true do
                        boss.cast(self, 120)
                        local t, y, a = ran:Int(0, 12), ran:Float(100, 160), ran:Float(0, 360)
                        for i = 1, 9 do
                            New(class["laser2-1"], self.x, self.y, i * 40 + a, t * 32 - 192, y, 9, 6, 4, true)
                        end
                        task.Wait(80)
                    end
                else
                    boss.cast(self, 240)
                    local t, y = ran:Int(0, 12), ran:Float(100, 160)
                    self["laser_x" .. t] = true
                    for i = 1, 8 do
                        New(class["laser2-1"], self.x, self.y, i * 45, t * 32 - 192, y)
                    end
                    task.Wait(360)
                end

            end
        end)
    end

    function sc2:before()
        boss.ns_group.nextcard(self)
        if ext.sc_pr then
            lstg.tmpvar.bg.change = true
            self.lightback = New(class["KanakoLightBack"], self)
        end
        self.lightback.event.open = 60
        task.MoveTo(0, 180, 60, 2)
    end
    function sc2:init()
        local cao
        task.New(self, function()
            boss.violent(self)
            cao = true
        end)
        task.New(self, function()
            while true do
                if cao then
                    break
                end
                task.Wait(181)
                if cao then
                    break
                end
                boss.cast(self, 720)
                self.lightback.event.rotate = true
                if Sanae and IsValid(Sanae) then
                    for i = 0, 12 do
                        New(class["laser2-2"], i * 32 - 192, 224, Sanae["laser_x" .. i])
                        Sanae["laser_x" .. i] = nil
                    end
                end
                for _ = 1, 3 do
                    for v = 1, 3 do
                        for a = 1, 30 do
                            Create.bullet_decel(self.x, self.y, ball_big, 2, 4, v, a * 12 + Angle(self, player))
                        end
                    end
                    PlaySound("tan00")
                    if cao then
                        break
                    end
                    task.MoveToPlayer(60, -100, 100, 130, 160,
                            20, 40, 20, 40, 2, 1)
                end
                if cao then
                    break
                end
                task.Wait(180)
                if cao then
                    break
                end
            end
            task.Wait(60)
            while true do
                for v = 1, 3 do
                    for a = 1, 40 do
                        Create.bullet_decel(self.x, self.y, ball_mid, 2, 5, v * 0.5 + 1, a * 9 + Angle(self, player))
                    end
                end
                PlaySound("tan00")
                for i = 0, 12 do
                    New(class["laser2-2"], i * 32 - 192, 224, ({ false, true })[ran:Int(1, 2)], 30)
                end
                if ran:Int(1, 2) == 1 then
                    task.Wait(180)
                else
                    task.MoveToPlayer(80, -100, 100, 130, 160,
                            20, 40, 20, 40, 2, 1)
                    task.Wait(100)
                end

            end
        end)
    end
end
---boss4
do
    boss.Define("5a", "东风谷早苗", "TH10_2", TH10_bg, { 0, 500 }, class["SCBG5"], "Sanae", 6)
    boss.Define("5b", "八坂神奈子", "TH10_2", TH10_bg, { -300, 500 }, class["SCBG5"], "Kanako", 6)
    boss.Define("5c", "洩矢诹访子", "TH10_2", TH10_bg, { 300, 500 }, class["SCBG5"], "Suwako", 6)
    local cardname = "秘式「阴阳星转，潜龙反复」"
    local function fullscreen()
        ToBigScreen(60)
    end

    local sc1 = boss.card.New(cardname, 1, 1, 90, 1400)
    local sc2 = boss.card.New(cardname, 1, 1, 90, 1400)
    local sc3 = boss.card.New(cardname, 1, 1, 90, 1400)
    boss.card.add({ { sc1, "5a" }, { sc2, "5b" }, { sc3, "5c" } }, 6, cardname, 58)

    function sc1:before()
        if ext.sc_pr then
            lstg.tmpvar.bg.change = true
        end
        fullscreen()
        task.New(player, function()
            task.SmoothSetValueTo("x", 0, 60, 2)
        end)
        task.New(player, function()
            task.SmoothSetValueTo("y", -50, 60, 2)
        end)
        task.MoveTo(0, 0, 60, 2)
    end
    function sc1:init()
        task.New(self, function()
            New(WhiteScreen)
            player.x, player.y = 0, -50
            local d = 1
            while true do
                boss.cast(self, 100)
                local a, l, t
                New(class["StarDrawer"], self.x, self.y, 5, 0, 25, 28, 0.5, function(self, x, y)
                    a = Angle(x, y, self.x, self.y)
                    l = Dist(x, y, self.x, self.y)
                    t = (self.ani - 1) * 0.5 * d
                    New(class["bullet2-1"], x + cos(a + t) * l, y + sin(a + t) * l, x, y, 0.5 * d)
                    Create.bullet_accel(x + cos(a + t) * l, y + sin(a + t) * l, ball_mid, 4,
                            2, 2, a + t + 90 - self.ani * 4, nil, nil, 0, 180)
                end)
                task.Wait(200)
                task.MoveTo(0, 150, 90, 2)
                task.Wait(120)
                boss.cast(self, 100)
                for j = 1, 10 do
                    for i = 1, 10 do
                        for A = -4, 4 do
                            Create.bullet_dec_acc(self.x, self.y, ball_mid, 4, 4, 4, i * 36 + A * 1.2 + d * j * 12)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(15)
                end
                task.Wait(90)
                task.MoveTo(0, 0, 90, 2)
                task.Wait(20)
                Newcharge_in(self.x, self.y, 32, 128, 32)
                task.Wait(60)
                d = -d
            end
        end)

    end
    sc1.frame = boss.card.PublicHP

    function sc2:before()
        if ext.sc_pr then
            lstg.tmpvar.bg.change = true
            fullscreen()
        end
        self.lightback = New(class["KanakoLightBack"], self)
        self.lightback.event.open = 60
        task.MoveTo(-160, 150, 60, 2)
    end
    function sc2:init()
        task.New(self, function()
            local d = 1
            while true do
                boss.cast(self, 180)
                local A = ran:Float(0, 360)
                for _ = 1, 3 do
                    for a = 0, 59 do
                        Create.bullet_dec_acc(self.x, self.y, water_drop, 2, 3, 2 + d * (a % 4 - 1.5) / 3.2, a * 6 + A)
                    end
                    PlaySound("tan00")
                    task.Wait(65)
                end
                task.Wait(130)
                task.MoveToPlayer(60, -200, 200, 100, 150, 20, 40, 20, 40, 2, 1)
                task.Wait(90)
                Newcharge_in(self.x, self.y, 250, 128, 114)
                task.Wait(60)
                self.lightback.event.rotate = true
                for i = 1, 8 do
                    New(class["laser2-3"], self, i * 45, 0.6 * d)
                end
                Newcharge_out(self.x, self.y, 250, 128, 114)
                task.MoveTo(self.x, -240, 120, 1)
                misc.ShakeScreen(30, 1)
                task.Wait(60)
                self.lightback.event.rotate = false
                local h, v = 1, 1
                for _ = 1, 11 do
                    self.vscale = v
                    self.hscale = h
                    task.Wait()
                    h = h - 1 / 10
                    v = v + 0.8 / 10
                end
                self.x, self.y = -160 * sign(self.x), 150
                h, v = 0, 1.8
                for _ = 1, 11 do
                    self.vscale = v
                    self.hscale = h
                    task.Wait()
                    h = h + 1 / 10
                    v = v - 0.8 / 10
                end
                task.Wait(80)
                d = -d
            end
        end)
    end
    sc2.frame = boss.card.PublicHP

    function sc3:before()
        if ext.sc_pr then
            lstg.tmpvar.bg.change = true
            fullscreen()
        end
        task.MoveTo(160, 150, 60, 2)
    end
    function sc3:init()
        task.New(self, function()
            local d = 1
            while true do
                boss.cast(self, 180)
                local A = ran:Float(0, 360)
                for _ = 1, 2 do
                    for a = 0, 59 do
                        Create.bullet_dec_acc(self.x, self.y, water_drop, 10, 3, 2 - d * (a % 4 - 1.5) / 3.2, a * 6 + A)
                    end
                    PlaySound("tan00")
                    task.Wait(60)
                end
                task.MoveToPlayer(60, -200, 200, 100, 150,
                        20, 40, 20, 40, 2, 1)
                task.Wait(80)
                Newcharge_in(self.x, self.y, 189, 252, 201)
                task.Wait(60)
                boss.cast(self, 180)
                Newcharge_out(self.x, self.y, 189, 252, 201)
                local x, y
                for l = 0, 24 do
                    l = l * 20
                    for t = -1.5, 1.5 do
                        for a = 1, 8 do
                            a = a * 45 + sin(l) * 20 * d + Angle(self, player) + 22.5 + t * 2 * d
                            x, y = self.x + cos(a) * l, self.y + sin(a) * l
                            if Dist(x, y, player.x, player.y) > 50 then
                                Create.bullet_accel(x, y, grain_b, 10, 0.2, 5, a + 180 + l / 5 * d)
                            end
                        end
                    end
                    task.Wait()
                end
                task.Wait(30 + 75)
                task.Wait(140 + 80)
                task.MoveTo(-160 * sign(self.x), 150, 150, 2)
                --task.Wait(150)
                d = -d
            end
        end)
    end
    function sc3:render()
        SetImageState("frog", "mul+add", 150 - 75 * sin(self.ani * 2), 255, 255, 255)
        Render("frog", self.x, self.y + 4 * sin(self.ani * 4), 0, 0.9 + 0.1 * sin(self.ani * 2))
    end
    sc3.frame = boss.card.PublicHP
end---boss5