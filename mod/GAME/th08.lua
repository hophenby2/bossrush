local class = {}
_editor_class["TH08"] = class

local cos, sin, min, max, int = cos, sin, min, max, int
local bullet, object, laser, enemy = bullet, object, laser, enemy
local task, ran, Create = task, ran, Create
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

do
    do
        class["SCBG1"] = Class(_SC_BG)
        class["SCBG1"].init = function(self)
            _SC_BG.init(self)
            _SC_BG.AddLayer(self, "th08_3", true, 0, 0, 0, 0, -0.3, 0, "", 1, 1)
            _SC_BG.AddLayer(self, "th08_1", true, 0, 0, 0, 0.4, 1, 0, "", 1, 1)
            _SC_BG.AddLayer(self, "th08_0", true, 0, 0, 0, 0, 1, 0, "mul+add", 1, 1)
            _SC_BG.AddLayer(self, "th08_2", true, 0, 0, 0, -0.4, 1.5, 0, "", 1, 1)
        end
        class["SCBG2"] = Class(_SC_BG)
        class["SCBG2"].init = function(self)
            _SC_BG.init(self)
            _SC_BG.AddLayer(self, "th08_5", true, 0, 0, 0, -1, 2, 0, "", 1, 1)
            _SC_BG.AddLayer(self, "th08_4", false, 0, 0, 0, 0, 0, 0, "mul+add", 1, 1)
            _SC_BG.AddLayer(self, "th08_1", true, 0, 0, 0, 0.4, 1, 0, "", 1, 1)
            _SC_BG.AddLayer(self, "th08_2", true, 0, 0, 0, -0.4, 1.5, 0, "", 1, 1)
        end
        class["SCBG3"] = Class(_SC_BG)
        class["SCBG3"].init = function(self)
            _SC_BG.init(self)
            _SC_BG.AddLayer(self, "th08_7", false, 0, 0, 0, 0, 0, -0.3, "", 2.1, 2.1)
            _SC_BG.AddLayer(self, "th08_9", true, 0, 0, 0, 0, 1.5, 0, "mul+add", 1, 1)
            _SC_BG.AddLayer(self, "th08_8", false, 0, 0, 0, 0, 0, 0, "mul+add", 1, 1)
            _SC_BG.AddLayer(self, "th08_6", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
        end
        class["SCBG3+"] = Class(_SC_BG)
        class["SCBG3+"].init = function(self)
            _SC_BG.init(self)
            _SC_BG.AddLayer(self, "th08_7", false, 0, 0, 0, 0, 0, -0.3, "", 3, 3)
            _SC_BG.AddLayer(self, "th08_9", true, 0, 0, 0, 0, 1.5, 0, "mul+add", 1, 1)
            _SC_BG.AddLayer(self, "th08_8_n", false, 0, 0, 0, 0, 0, 0, "", 0.5, 0.5)
        end
        class["SCBG4"] = Class(_SC_BG)
        class["SCBG4"].init = function(self)
            _SC_BG.init(self)
            _SC_BG.AddLayer(self, "th08_11", false, 0, 0, 0, 0, 0, -0.5, "", 2.5, 2.5,
                    nil,
                    function(unit)
                        if lstg.var.eye then
                            unit.omiga = -1.5
                        else
                            unit.omiga = -0.5
                        end
                    end)
            _SC_BG.AddLayer(self, "th08_12", false, 0, 0, 0, 0, 0, 0, "mul+add", 1, 1)
            _SC_BG.AddLayer(self, "th08_10", false, 0, 0, 0, 0, 0, 0.5, "", 1.2, 1.2)
        end
        class["SCBG5"] = Class(_SC_BG)
        class["SCBG5"].init = function(self)
            _SC_BG.init(self)
            _SC_BG.AddLayer(self, "th08_15", false, 0, 0, 0, 0, 0, 0, "", 1, 1,
                    function(unit)
                        unit.a = 170
                    end)
            _SC_BG.AddLayer(self, "th08_13", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
            _SC_BG.AddLayer(self, "th08_14", true, 0, 0, 0, 0, 2, 0, "", 1, 1)
        end
        class["SCBG6"] = Class(_SC_BG)
        class["SCBG6"].init = function(self)
            _SC_BG.init(self)
            _SC_BG.AddLayer(self, "th08_19", true, 0, 0, 0, -1, 2, 0, "mul+add", 1, 1)
            _SC_BG.AddLayer(self, "th08_16", false, 0, 0, 0, 0, 0, 0, "", 1, 1,
                    function(unit)
                        unit.task = {}
                        unit.a = 180
                    end)
            _SC_BG.AddLayer(self, "th08_18", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
        end
        class["SCBG7"] = Class(_SC_BG)
        class["SCBG7"].init = function(self)
            _SC_BG.init(self)
            _SC_BG.AddLayer(self, "th08_16", false, 0, 0, 0, 0, 0, 0, "mul+sub", 1, 1)
            _SC_BG.AddLayer(self, "th08_15", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
            _SC_BG.AddLayer(self, "th08_20", true, 0, 0, 0, 0, 2, 0, "", 1, 1)
        end
    end--before lw
    class["SCBG-LW1"] = Class(_SC_BG)
    class["SCBG-LW1"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th08_1", true,
                0, 0, 0, 0.4, 1, 0, "", 1, 1,
                function(unit)
                    unit.task = {}
                    unit.a = 120
                    unit.r, unit.g, unit.b = 0, 0, 0
                    task.New(unit, function()
                        local a, _d_a = (0), (255 / (35 * 60 * 2 - 1))
                        for _ = 1, 35 * 60 do
                            unit.r, unit.g, unit.b = a, a, a
                            task.Wait()
                            a = a + _d_a
                        end
                    end)
                end, task.Do)
        _SC_BG.AddLayer(self, "th08_2", true,
                0, 0, 0, -0.4, 1.5, 0, "", 1, 1,
                function(unit)
                    unit.task = {}
                    unit.a = 120
                    unit.r, unit.g, unit.b = 0, 0, 0
                    task.New(unit, function()
                        local a, _d_a = (0), (255 / (35 * 60 * 2 - 1))
                        for _ = 1, 35 * 60 do
                            unit.r, unit.g, unit.b = a, a, a
                            task.Wait()
                            a = a + _d_a
                        end
                    end)
                end, task.Do)
        _SC_BG.AddLayer(self, "th08_3", true,
                0, 0, 0, 0, -0.3, 0, "", 1, 1,
                function(unit)
                    unit.task = {}
                    unit.r, unit.g, unit.b = 0, 0, 0
                    task.New(unit, function()
                        local a, _d_a = (0), (255 / (35 * 60 * 2 - 1))
                        for _ = 1, 35 * 60 do
                            unit.r, unit.g, unit.b = a, a, a
                            task.Wait()
                            a = a + _d_a
                        end
                    end)
                end, task.Do)
        _SC_BG.AddLayer(self, "th08_0", true,
                0, 0, 0, 0, 1, 0, "", 1, 1,
                function(unit)
                    unit.task = {}
                    unit.r, unit.g, unit.b = 0, 0, 0
                    task.New(unit, function()
                        local a, _d_a = (0), (255 / (35 * 60 * 2 - 1))
                        for _ = 1, 35 * 60 do
                            unit.r, unit.g, unit.b = a, a, a
                            task.Wait()
                            a = a + _d_a
                        end
                    end)
                end, task.Do)
    end
    class["SCBG-LW3"] = Class(_SC_BG)
    class["SCBG-LW3"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th08_5", true, 0, 0, 0, -1, 2, 0, "", 1, 1)
        _SC_BG.AddLayer(self, "th08_4_n", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
    end
    class["SCBG-LW4"] = Class(_SC_BG)
    class["SCBG-LW4"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th08_11", false, 0, 0, 0, 0, 0, -0.5, "", 2.5, 2.5,
                nil,
                function(unit)
                    if lstg.var.eye then
                        unit.omiga = -1.5
                    else
                        unit.omiga = -0.5
                    end
                end)
        _SC_BG.AddLayer(self, "th08_10", false, 0, 0, 0, 0, 0, 0.5, "", 1.8, 1.8)
    end
    class["SCBG-LW5"] = Class(_SC_BG)
    class["SCBG-LW5"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th08_14", true, 0, 0, 0,
                0, 2, 0, "mul+add", 1, 1,
                function(unit)
                    unit.a = 150
                end)
        _SC_BG.AddLayer(self, "th08_13_n", false, 0, 0, 0,
                0, 0, 0, "", 1, 1)

    end
    class["SCBG-LW6"] = Class(_SC_BG)
    class["SCBG-LW6"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th08_17", false, 0, 0, 0,
                0, 0, 0.5, "mul+add", 1.5, 1.5,
                function(unit)
                    unit.a = 150
                end,
                function(unit)
                    unit.g, unit.b = sin(unit.timer / 2) * 255 / 2 + 255 / 2, sin(unit.timer / 2) * 255 / 2 + 255 / 2
                end)

        _SC_BG.AddLayer(self, "th08_20", true, 0, 0, 0,
                0, 2, 0, "mul+add", 1, 1,
                function(unit)
                    unit.r = 150
                    unit.g = 150
                    unit.b = 150
                end,
                function(unit)
                    unit.a = sin(unit.timer / 2) * 100 + 155
                end)
        _SC_BG.AddLayer(self, "th08_15_n", false, 0, 0, 0,
                0, 0, 0, "", 1, 1,
                nil,
                function(unit)
                    unit.a = cos(unit.timer / 2) * 100 + 155
                end)
    end
    class["SCBG-LW8"] = Class(_SC_BG)
    class["SCBG-LW8"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th08_12", false, 0, 0, 0, 0, 0, 0, "", 2, 2,
                function(unit)
                    unit.task = {}
                end,
                function(unit)
                    task.Do(unit)
                    unit.r, unit.g, unit.b = 255 / 2 + sin(unit.timer * 0.3) * 255 / 2, 255 / 2 + sin(unit.timer * 0.3) * 255 / 2, 255 / 2 + sin(unit.timer * 0.3) * 255 / 2
                end)
        _SC_BG.AddLayer(self, "th08_22", true, 0, 0, 0, 0, 1, 0, "", 1, 1)
    end
    class["SCBG-LW9"] = Class(_SC_BG)
    class["SCBG-LW9"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th08_19", true, 0, 0, 0, -1, 2, 0, "", 1, 1)
        _SC_BG.AddLayer(self, "th08_18_n", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
    end
    class["SCBG-LW10"] = Class(_SC_BG)
    class["SCBG-LW10"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th06_5", false, 0, 0, 0, 0, 0, 0.5, "", 3.3, 3.3)
        _SC_BG.AddLayer(self, "th08_21", false, 0, 0, 0, 0, 0, -0.8, "", 3.2, 3.2)
    end
    class["SCBG-LW11"] = Class(_SC_BG)
    class["SCBG-LW11"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_4", true, 100, 100, 0, 0, 0, 0.3, "", 1.5, 1.5,
                _editor_class["TH07"]["youmu_slash"].init,
                _editor_class["TH07"]["youmu_slash"].frame, nil,
                _editor_class["TH07"]["youmu_slash"].render)
        _SC_BG.AddLayer(self, "th09_0_n", false, 0, 0, 0, 0, 0, 0, "", 1, 1, function(unit)
            unit.r = 128
            unit.g = 128
            unit.b = 128
        end)
    end
    class["SCBG-LW12"] = Class(_SC_BG)
    class["SCBG-LW12"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_1", true, 0, 0, 0, 0, 0.6, 0, "mul+add", 1, 1)
        _SC_BG.AddLayer(self, "th07_1", true, -128, 0, 0, 0, -0.6, 0, "", 1, 1)
    end
    class["SCBG-LW13"] = Class(_SC_BG)
    class["SCBG-LW13"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th06_6", false, 0, 0, 0, 0, 0, 0.2, "mul+add", 3, 3)
        _SC_BG.AddLayer(self, "th06_7_n", false, 0, 0, 0, 0, 0, 0, "", 1, 1, function(unit)
            unit.r = 128
            unit.g = 128
            unit.b = 128
        end)
    end
    class["SCBG-LW14"] = Class(_SC_BG)
    class["SCBG-LW14"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_5", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
        _SC_BG.AddLayer(self, "th07_6", true, -128, 0, 0, 0, 1, 0, "", 1, 1)
    end
end
---_SC_BG
do
    class["enemy3-1"] = Class(enemy, {
        init = function(self, _x, _y, x, y)
            enemy.init(self, 2, 10, false, true, false)
            self.x, self.y = _x, _y
            self.drop = { 0, 0, 0 }
            self.colli = false
            task.New(self, function()
                task.MoveTo(x, y, 120, VALUE_SET.ACC_DEC)
                while true do
                    while not _boss.t do
                        task.Wait()
                    end
                    local r = { 255, 128, 227, 65, 135, 192, 255 }
                    local g = { 235, 138, 27, 105, 206, 192, 227 }
                    local b = { 205, 135, 13, 225, 235, 192, 132 }
                    local t = ran:Int(1, 7)
                    local a, _d_a = (ran:Float(0, 360)), (360 / 70)
                    for _ = 1, 70 do
                        New(class["bullet_lw3-3"], self.x, self.y, r[t], g[t], b[t], a)
                        a = a + _d_a
                    end
                    task.Wait()
                end
            end)
        end })
end
---enemy
do
    class["laser7-1"] = Class(laser, {
        init = function(self, _x, _y, rot, a, t)
            laser.init(self, COLOR.RED, _x, _y, 0, 0, 0, 0, 12, 12, 0)
            laser._TurnHalfOn(self, 0, false)
            object.SetV(self, 0, a, true)
            self.Isradial = true
            self.radial_v = 8
            task.New(self, function()
                for i = 1, 45 do
                    self.line = sin(i * 2) * 500
                    task.Wait()
                end
                laser._TurnOn(self, 1, true, false)
                task.New(self, function()
                    for _ = 1, 40 do
                        self.l3 = self.l3 + 8
                        task.Wait()
                    end
                    for _ = 1, 120 do
                        self.l1 = self.l1 + 8
                        task.Wait()
                    end
                end)
            end)
            task.New(self, function()
                do
                    local s, _d_s = (1), (90)
                    while true do
                        self.rot = self.rot + rot * sin(min(s, 90))
                        object.SetRelPos(self, 0, 0, self.rot, false)
                        task.Wait()
                        s = s + _d_s
                    end
                end
            end)
            task.New(self, function()
                task.Wait(t - 30)
                laser._TurnOff(self, 30, true)
                object.Del(self)
            end)
        end,
        render = function(self)
            SetImageState("white", "mul+add", self.alpha * 255, unpack(ColorList[math.ceil(self.index / 2)]))
            Render("white", self.x + cos(self.rot) * self.line / 2, self.y + sin(self.rot) * self.line / 2, self.rot, self.line / 16, 0.125)
            laser.render(self)
        end })
    class["laser7-2"] = Class(laser, {
        init = function(self, _x, _y, col, a, w, d, L)
            laser.init(self, col, _x, _y, 0, 128, 0, 128, 2, 8, 0)
            self.navi = true
            self.bound = false
            object.SetV(self, 0, a, true)
            task.New(self, function()
                laser._TurnHalfOn(self, w, true)
                self.w0 = 8
                laser._TurnOn(self, 30, true, true)
                task.Wait(150)
                self.stop = true
                laser._TurnOff(self, 30, true)
                object.Del(self)
            end)
            task.New(self, function()
                local r, _d_r = (a), (d)
                local l, _d_l = (L), (-L * 2 / 180)
                while true do
                    self.r = r
                    self.rot = self.rot + d
                    object.SetRelPos(self, cos(r) * l, sin(r) * l, self.rot, false)
                    task.Wait()
                    r = r + _d_r
                    l = l + _d_l
                end
            end)
            task.New(self, function()
                task.Wait(45)
                while true do
                    if self.stop then
                        break
                    end
                    NewSimpleBullet(star_small, self.index, self.x, self.y, 1.5, self.rot + 180, false, ran:Sign() * 3, true, true)
                    PlaySound("tan00", 0.1, self.x / 256, false)
                    task.Wait(15)
                end
            end)
        end })
    class["laser4-1"] = Class(laser, {
        init = function(self, _x, _y, a, d)
            laser.init(self, COLOR.GOLDEN_YELLOW, _x, _y, 0, 0, 0, 0, 4, 4, 0)
            local angle = Angle(self, player)
            laser._TurnHalfOn(self, 0, false)
            object.SetV(self, 0, a - 180 * d + angle, true)
            self.Isradial = true
            self.radial_v = 12
            task.New(self, function()
                task.New(self, function()
                    local s, _d_s = (0), (90 / 99)
                    for _ = 1, 100 do
                        object.SetV(self, 0, a - 180 * d + sin(s) * 180 * d + angle, true)
                        task.Wait()
                        s = s + _d_s
                    end
                end)
                for i = 1, 45 do
                    self.line = sin(i * 2) * 500
                    task.Wait()
                end
                task.Wait(105)
                laser._TurnOn(self, 1, true, false)
                task.New(self, function()
                    for _ = 1, 60 do
                        self.l3 = self.l3 + 12
                        task.Wait()
                    end
                    for _ = 1, 120 do
                        self.l1 = self.l1 + 12
                        task.Wait()
                    end
                end)
                task.Wait(120)
                NewSimpleBullet(ball_huge, COLOR.RED, self.x, self.y, 0.5, self.rot + 30 * d, false, 0, true, true)
                PlaySound("enep02", 0.1, self.x, false)
                laser._TurnOff(self, 30, true)
                object.Del(self)
            end)
        end,
        render = function(self)
            SetImageState("white", "mul+add", self.alpha * 255, unpack(ColorList[math.ceil(self.index / 2)]))
            Render("white", self.x + cos(self.rot) * self.line / 2, self.y + sin(self.rot) * self.line / 2, self.rot, self.line / 16, 0.125)
            laser.render(self)
        end })
end
---laser
do
    class["bullet7-1"] = Class(bullet, {
        init = function(self, _x, _y, v, a, d, s)
            bullet.init(self, ball_small, COLOR.GRAY, true, true)
            self.x, self.y = _x, _y
            self.bound = false
            PlaySound("tan00", 0.1, self.x / 256)
            object.SetV(self, v, a, true)
            task.New(self, function()
                object.ChangingV(self, v, 0, a, 60, true)
                bullet.ChangeImage(self, ball_mid, COLOR.DEEP_GRAY)
                Create.bullet_create_eff(self)
                object.ChangingV(self, v / 2, 0, a + 90 * d, 80, true)
                task.Wait(60)
                NewSimpleBullet(grain_a, ((s > 0) and 8) or 13, self.x, self.y, 1.5, self.rot + s)
                object.RawDel(self)
            end)
        end })
    class["bullet7-2"] = Class(bullet, {
        init = function(self, _x, _y, v, a, col)
            bullet.init(self, ball_mid, COLOR.GRAY, false, true)
            self.x, self.y = _x, _y
            PlaySound("tan00", 0.1, self.x / 256, false)
            object.SetV(self, v * 2, a, true)
            self.colli = false
            task.New(self, function()
                task.New(self, function()
                    task.Wait(11)
                    self.colli = true
                    bullet.ChangeImage(self, ball_mid, col)
                end)
                object.ChangingV(self, v * 2, 0, self.rot, 25, true)
                task.Wait(30)
                PlaySound("kira00", 0.1, self.x / 256)
                object.ChangingV(self, 0, v, self.rot, 30, true)
            end)
        end })
    class["bullet7-3"] = Class(bullet, {
        init = function(self, _x, _y, v, a, r)
            bullet.init(self, ball_big, COLOR.ORANGE, true, true)
            self.x, self.y = _x, _y
            PlaySound("tan00", 0.1, self.x / 256, false)
            object.SetV(self, 1, a, true)
            task.New(self, function()
                for _ = 1, 120 do
                    object.SetV(self, 1, self.rot + r, true)
                    task.Wait()
                end
                local s = v
                while true do
                    local V = max(1, s)
                    object.SetV(self, V, self.rot, true)
                    if s < 1 then
                        s = v
                    end
                    task.Wait()
                    s = s - v / 79
                end
            end)
        end })
    class["bullet7-4"] = Class(bullet, {
        init = function(self, _x, _y, col, a, t, ba, n)
            bullet.init(self, grain_b, col, true, true)
            self.x, self.y = _x, _y
            self.bound = false
            PlaySound("tan00", 0.1, 0, false)
            object.SetV(self, 5, a, true)
            task.New(self, function()
                local c = t - int(t)
                task.Wait(t)
                self.x = self.x - cos(self.rot + ba) * 5 * c
                self.y = self.y - sin(self.rot + ba) * 5 * c
                object.SetV(self, 5, self.rot + ba, true)
                task.Wait(t / sin((180 - 360 / n) / 2) * sin(360 / n))
                if ran:Int(1, 6) == 1 then
                    NewSimpleBullet(star_small, col, self.x, self.y, ran:Float(0.5, 1.3), ran:Float(0, 360), false, ran:Sign() * 2, false)
                    PlaySound("kira00", 0.1, self.x / 100, false)
                end
                object.Del(self)
            end)
        end })
    class["bullet7-5"] = Class(laser, {
        init = function(self, _x, _y, a)
            laser.init(self, COLOR.GRAY, _x, _y, 0, 300, 300, 300, 5, 2, 0)
            self.rot = a
            task.New(self, function()
                laser._TurnHalfOn(self, 30, true)
                task.Wait(60)
                laser._TurnOff(self, 30, true)
                object.Del(self)
            end)
        end })
    class["bullet3-1"] = Class(bullet, {
        init = function(self, _x, _y, vx, vy, style, col, a, v)
            bullet.init(self, style, col, false, true)
            self.x, self.y = _x, _y
            self.navi = true
            PlaySound("tan00", 0.1, 0, false)
            task.New(self, function()
                while true do
                    if IsValid(_boss) and _boss.eye == true then
                        self.vx = vx
                        self.vy = vy
                        _object.set_color(self, "", 150, 255, 255, 255)
                        if IsValid(_boss) and _boss.violent then
                            self.colli = true
                            _object.set_color(self, "", 255, 255, 255, 255)
                        else
                            self.colli = false
                            _object.set_color(self, "", 150, 255, 255, 255)
                        end
                    else
                        object.SetV(self, v, a, true)
                        _object.set_color(self, "", 255, 255, 255, 255)
                        self.colli = true
                    end
                    task.Wait()
                end
            end)
        end,
        render = function(self)
            SetImageState("bright", "mul+add", 250, 255, 50, 50)
            Render("bright", self.x, self.y, 0, 14 / 150)
            bullet.render(self)
        end })
    class["bullet3-2"] = Class(bullet, {
        init = function(self, _x, _y, a, v, ae)
            bullet.init(self, gun_bullet, COLOR.BLUE, true, true)
            self.x, self.y = _x, _y
            PlaySound("tan00", 0.1, self.x, false)
            object.SetV(self, v, a, true)
            task.New(self, function()
                do
                    while true do
                        if IsValid(_boss) and _boss.eye then
                            self.vx = cos(ae)
                            self.vy = sin(ae)
                            self._a = 120
                            self.colli = false
                        else
                            object.SetV(self, v, self.rot, true)
                            self._a = 255
                            self.colli = true
                        end
                        task.Wait()
                    end
                end
            end)
        end,
        render = function(self)
            SetImageState("bright", "mul+add", 250, 50, 50, 255)
            Render("bright", self.x, self.y, 0, 14 / 150)
            bullet.render(self)
        end })
    class["bullet4-1"] = Class(bullet, {
        init = function(self, _x, _y, v, a, aa)
            bullet.init(self, arrow_mid, COLOR.BLUE, true, true)
            self.x, self.y = _x, _y
            object.ForbidV(self, 3.2)
            self.bound = false
            PlaySound("kira00", 0.1, self.x, false)
            self.navi = true
            object.SetV(self, v, a, true)
            object.SetA(self, 0.04, aa, false)
            task.New(self, function()
                local b
                while true do
                    b = Create.bullet_accel(self.x, self.y, grain_a, 2, 0.2, 2, self.rot + 180 + ran:Float(-5, 5))
                    b.render_new = function(unit)
                        SetImageState("bright", "mul+add", 250, 250, 128, 114)
                        Render("bright", unit.x, unit.y, 0, 14 / 150)
                        bullet.render(unit)
                    end
                    task.Wait(11)
                end
            end)
        end,
        render = function(self)
            SetImageState("bright", "mul+add", 250, 33, 33, 200)
            Render("bright", self.x, self.y, 0, 25 / 150)
            bullet.render(self)
        end,
        frame = function(self)
            self.class.base.frame(self)
            if self.y < -224 then
                if self.x < 192 and self.x > -192 then
                    local v, _d_v = (1), (-0.2 / 4)
                    local b
                    for t = 1, 5 do
                        local x, _d_x = (2 * (t - 1)), (-4 * (t - 1) / (t - 1))
                        for _ = 1, t do
                            b = Create.bullet_accel(self.x + x, self.y, grain_b, 6, 0.2, v, 90)
                            b.render_new = function(unit)
                                SetImageState("bright", "mul+add", 250, 135, 206, 235)
                                Render("bright", unit.x, unit.y, 0, 14 / 150)
                                bullet.render(unit)
                            end
                            x = x + _d_x
                        end
                        v = v + _d_v
                    end
                end
                object.Del(self)
            end
        end })
    class["bullet5-1"] = Class(bullet, {
        init = function(self, _x, _y, v, a, col, boss)
            bullet.init(self, ball_mid_c, col, false, true)
            self.x, self.y = _x, _y
            self.boss = boss
            self.a = self.a * 0.6
            self.b = self.b * 0.6
            object.SetV(self, v, a, true)
            self.bound = false
            self.real = ((GetGlobal("player_name") == "reimu_player") and 2) or 6
        end,
        frame = function(self)
            self.class.base.frame(self)
            if self._index == self.real then
                if Dist(self, player) < 50 then
                    if IsValid(self.boss) then
                        for _ = 1, 5 do
                            New(class["7-Addhppar"], self.x, self.y, self.boss)
                        end
                    end
                    object.Del(self)
                end
            end
            if Dist(self.x, self.y, 0, 0) > 700 then
                object.RawDel(self)
            end
        end })
    class["bullet_lw0-1"] = Class(bullet, { init = function(self, _x, _y, v, a, s, t)
        bullet.init(self, ball_light, 14, false, true)
        self.x, self.y = _x, _y
        self.layer = LAYER.TOP
        self.timer = 11
        local c = ran:Float(0.2, 0.4)
        self.vscale, self.hscale = c, c
        self.a, self.b = self.a * c, self.b * c
        task.New(self, function()
            object.SetV(self, v, a, true)
            local S = 90
            while true do
                object.SetV(self, v, self.rot + 2 * sin(S), true)
                task.Wait()
                S = S + s
            end
        end)
        task.New(self, function()
            self.colli = false
            _object.set_color(self, "mul+add", 0, 255, 255, 255)
            task.Wait(t)
            local s = -90
            while true do
                _object.set_color(self, "mul+add", 255 / 2 + sin(s) * 255 / 2, 255, 255, 255)
                if s % 360 > 60 and s % 360 < 120 then
                    self.colli = true
                else
                    self.colli = false
                end
                if self.timer > 500 and s == -90 then
                    object.Del(self)
                end
                task.Wait()
                s = s + 1
            end
        end)
    end })
    class["bullet_lw0-2"] = Class(bullet, {
        init = function(self, _x, _y, col)
            bullet.init(self, ball_light, col, false, false)
            self.x, self.y = _x, _y
            self.timer = 11
            self.vscale = 0
            self.hscale = 0
            self.a = 0
            self.b = 0
            task.New(self, function()
                for i = 1, 90 do
                    i = sin(i)
                    self.vscale = i * 2
                    self.hscale = i * 2
                    self.a = 11.5 * i * 2
                    self.b = 11.5 * i * 2
                    task.Wait()
                end
            end)
        end,
        frame = function(self)
            self.class.base.frame(self)
            _object.set_color(self, "mul+add", 255, 255, 255, 255)
            object.SetRelPos(self, 0, 0, self.rot, false)
        end })
    class["bullet_lw0-3"] = Class(bullet, {
        init = function(self, _x, _y, v, a, s, S, scale)
            bullet.init(self, ball_big, COLOR.GRAY, false, true)
            self.x, self.y = _x, _y
            _object.set_color(self, "", 150, 100, 100, 100)
            self.group = GROUP.GHOST
            self.a = 6 * S
            self.b = 6 * S
            self.hscale, self.vscale = S, S
            self.timer = 11
            task.New(self, function()
                object.SetV(self, v, a, false)
                local ss = 90
                while true do
                    object.SetV(self, v, a + 18 * sin(ss), false)
                    task.Wait()
                    ss = ss + s
                end
            end)
            task.New(self, function()
                while not self.jump do
                    task.Wait()
                end
                PlaySound("kira00", 0.1, self.x, false)
                scale.scale_s = max(0.3, scale.scale_s - 0.07)
                for i = 0, 10 do
                    self.vscale = S - S * i / 10
                    self.hscale = self.vscale
                    _object.set_color(self, "", 255 - 255 * i / 10, 100, 100, 100)
                    task.Wait()
                end
                object.Del(self)
            end)
        end,
        render = function(self)
            SetImageState("bright", "mul+add", 250, 0, 0, 255)
            Render("bright", self.x, self.y, 0, 25 / 150 * self.hscale)
            bullet.render(self)
        end,
        colli = function(self, other)
            self.class.base.colli(self, other)
            if other.group == GROUP.PLAYER then
                self.jump = true
            end
        end })
    class["bullet_lw0-4"] = Class(_object, {
        init = function(self, _x, _y, a)
            self.x, self.y = _x, _y
            self.img = "servant"
            self.layer = LAYER.ENEMY
            self.group = GROUP.INDES
            self.hide = false
            self.bound = false
            self.navi = false
            self.hp = 10
            self.maxhp = 10
            self.colli = false
            self._servants = {}
            self._blend, self._a, self._r, self._g, self._b = 'mul+add', 0, 200, 33, 33
            self.omiga = ran:Sign()
            task.New(self, function()
                local A = a
                task.New(self, function()
                    task.MoveTo(cos(A) * 250, sin(A) * 250, 60, 2)
                    local s = 90
                    do
                        local l, _d_l = (250), (-240 / 800)
                        while true do
                            s = max(0, s - 1)
                            A = A - 1 + sin(s)
                            self.x = cos(A) * l
                            self.y = sin(A) * l
                            task.Wait()
                            l = l + _d_l
                        end
                    end
                end)
                do
                    local a, _d_a = (0), (255 / 59)
                    for _ = 1, 60 do
                        _object.set_color(self, "mul+add", a, 200, 33, 33)
                        task.Wait()
                        a = a + _d_a
                    end
                end
                task.Wait(60)
                do
                    local s, _d_s = (0), (6)
                    while true do
                        NewSimpleBullet(arrow_small, COLOR.RED, self.x, self.y, 3.5 + sin(s) * 2, A + 90, false, 0, true, true)
                        task.Wait(2)
                        s = s + _d_s
                    end
                end
            end)
        end })
    class["bullet_lw0-5"] = Class(bullet, {
        init = function(self, _x, _y, a, v, x, y, rot)
            bullet.init(self, gun_bullet, COLOR.RED, false, true)
            self.x, self.y = _x, _y
            PlaySound("tan00", 0.1, self.x, false)
            self.v = v
            self.A = a
            task.New(self, function()
                do
                    while true do
                        do
                            while true do
                                if _boss.eye then
                                    break
                                end
                                task.Wait()
                            end
                        end
                        self.colli = false
                        do
                            local a, _d_a = (255), (-255 / 24)
                            local v, _d_v = (v), (-v / 24)
                            for _ = 1, 25 do
                                self.v = v
                                _object.set_color(self, "", a, 255, 255, 255)
                                task.Wait()
                                a = a + _d_a
                                v = v + _d_v
                            end
                        end
                        self.A = self.A + rot
                        do
                            while true do
                                if _boss.eye == false then
                                    break
                                end
                                task.Wait()
                            end
                        end
                        do
                            local a, _d_a = (0), (255 / 24)
                            local v, _d_v = (0), (v / 24)
                            for _ = 1, 25 do
                                self.v = v
                                _object.set_color(self, "", a, 255, 255, 255)
                                task.Wait()
                                a = a + _d_a
                                v = v + _d_v
                            end
                        end
                        self.colli = true

                    end
                end
            end)
            task.New(self, function()
                local l = 0
                do
                    while true do
                        self.x = x + cos(self.A) * l
                        self.y = y + sin(self.A) * l
                        l = l + self.v
                        self.rot = self.A
                        task.Wait()
                    end
                end
            end)
        end })

    class["bullet_lw1-1"] = Class(_object, {
        init = function(self, _x, _y, s)
            self.x, self.y = _x, _y
            self.img = "servant"
            self.layer = LAYER.ENEMY
            self.group = GROUP.INDES
            self.hide = false
            self.bound = false
            self.navi = false
            self.hp = 10
            self.maxhp = 10
            self.colli = false
            self._servants = {}
            self._blend, self._a, self._r, self._g, self._b = 'mul+add', 255, 0, 255, 255
            self.omiga = ran:Sign()
            task.New(self, function()
                task.New(self, function()
                    task.MoveTo(cos(s) * 250, 160, 60, 2)
                    do
                        local s, _d_s = (s), (0.6)
                        while true do
                            self.x = cos(s) * 250
                            task.Wait()
                            s = s + _d_s
                        end
                    end
                end)
                do
                    local a, _d_a = (0), (255 / 59)
                    for _ = 1, 60 do
                        _object.set_color(self, "mul+add", a, 0, 255, 255)
                        task.Wait()
                        a = a + _d_a
                    end
                end
            end)
        end })
    class["bullet_lw1-2"] = Class(_object, {
        init = function(self, _x, _y, s, y)
            self.fxsize = 0
            self.x, self.y = _x, _y
            self.img = "servant"
            self.group = GROUP.INDES
            self.hide = false
            self.bound = false
            self.navi = false
            self.hp = 10
            self.maxhp = 10
            self.colli = false
            self._servants = {}
            self._blend, self._a, self._r, self._g, self._b = 'mul+add', 0, 255, 255, 40
            self.omiga = ran:Sign()
            task.New(self, function()
                task.New(self, function()
                    task.MoveTo(cos(s) * 250, y, 60, 2)
                    do
                        local s = s
                        while true do
                            self.x = cos(s) * 250
                            task.Wait()
                            s = s + 0.3
                        end
                    end
                end)
                do
                    local a, _d_a = (0), (255 / 59)
                    for _ = 1, 60 do
                        _object.set_color(self, "mul+add", a, 255, 255, 40)
                        task.Wait()
                        a = a + _d_a
                    end
                end
                task.Wait(60)
                local a = 0
                local l, t, rot, r
                task.New(self, function()
                    for i = 1, 60 do
                        self.fxsize = sin(i * 1.5)
                        task.Wait()
                    end
                end)
                for _ = 1, 3 do
                    l = 10
                    t = 1
                    r = 3
                    for _ = 1, 10 do
                        rot = a - r
                        for _ = 1, int(t) do
                            object.Connect(self, New(class["bullet_lw1-3"], self.x, self.y, l, rot, 0.7))
                            rot = rot + 2 * r / (int(t) - 1)
                        end
                        r = r + 2
                        l = l + 10
                        t = t + 0.8
                        task.Wait()
                    end
                    a = a + 120
                end
            end)
        end })
    class["bullet_lw1-3"] = Class(bullet, {
        init = function(self, _x, _y, l, a, r)
            bullet.init(self, ball_big, COLOR.RED, false, false)
            self.x, self.y = _x, _y

            self.bound = false
            PlaySound("tan00", 0.1, self.x / 256, false)
            task.New(self, function()
                self.layer = LAYER.ENEMY_BULLET - 1
                do
                    local s, _d_s = (0), (90 / 59)
                    local rot, _d_rot = (a), (r)
                    for _ = 1, 60 do
                        object.SetRelPos(self, cos(rot) * (l * sin(s)), sin(rot) * (l * sin(s)), self.rot, false)
                        self.rot = rot
                        task.Wait()
                        s = s + _d_s
                        rot = rot + _d_rot
                    end
                end
                do
                    local rot, _d_rot = (a + r * 60), (r)
                    while true do
                        object.SetRelPos(self, cos(rot) * l, sin(rot) * l, self.rot, false)
                        self.rot = rot
                        task.Wait()
                        rot = rot + _d_rot
                    end
                end
            end)
        end })
    class["bullet_lw1-4"] = Class(bullet, {
        init = function(self, _x, _y, col, a, x, y, l)
            bullet.init(self, heart, col, false, true)
            self.x, self.y = _x, _y
            self.jump = false
            self.navi = true
            self._a = 150
            self.group = GROUP.GHOST
            self.a = self.a * 1.6
            self.b = self.b * 1.6
            PlaySound("tan00", 0.1, 0, false)
            task.New(self, function()
                task.New(self, function()
                    do
                        for _ = 1, 50 do
                            while self.jump do
                                task.Wait()
                            end
                            task.Wait()
                        end
                    end
                    PlaySound("kira00", 0.1, 0, false)
                    bullet.ChangeImage(self, heart, col + 2)
                    local v1, a1 = GetV(self)
                    Create.bullet_create_eff(self.x, self.y, heart, col + 2, v1, a1)
                end)
                task.MoveTo(x + cos(a) * l, y + sin(a) * l, 80, 2)
                task.Wait(20)
                local A = Angle(self, player) + ran:Float(-25, 25)
                do
                    local v, _d_v = (0), (3 / 119)
                    for _ = 1, 120 do
                        object.SetV(self, v, A, true)
                        task.Wait()
                        v = v + _d_v
                    end
                end
            end)
            task.New(self, function()
                while not self.jump do
                    task.Wait()
                end
                bullet.ChangeImage(self, heart, col - 2)
                local v1, a1 = GetV(self)
                Create.bullet_create_eff(self.x, self.y, heart, col - 2, v1, a1)
                PlaySound("kira01", 0.1, self.x, false)
            end)
        end,
        colli = function(self, other)
            self.class.base.colli(self, other)
            if other.group == GROUP.PLAYER then
                self.jump = true

            end
        end,
        frame = function(self)
            self.class.base.frame(self)
            if not self.jump then
                if self.x > lstg.world.r or self.x < lstg.world.l or self.y > lstg.world.t or self.y < lstg.world.b then
                    if IsValid(self._master) then
                        self._master._transport.flag = true
                    end--成就的判定
                    for _ = 1, 4 do
                        New(class["bullet_lw1-5"], self.x, self.y, ran:Float(0.5, 1.2), ran:Float(0, 360))
                    end
                    object.Del(self)
                end
            end
        end })
    class["bullet_lw1-5"] = Class(bullet, {
        init = function(self, _x, _y, v, a)
            bullet.init(self, ball_big, COLOR.RED, true, true)
            self.x, self.y = _x, _y
            self.ps = {}
            _object.set_color(self, "mul+add", 255, 255, 255, 255)
            object.SetV(self, 0.2, a, true)
            PlaySound("tan00", 0.1, self.x, false)
            task.New(self, function()
                task.Wait(60)
                do
                    local v, _d_v = (0.2), ((-0.2 + v) / 119)
                    for _ = 1, 120 do
                        object.SetV(self, v, self.rot, true)
                        task.Wait()
                        v = v + _d_v
                    end
                end
            end)
        end,
        frame = function(self)
            bullet.frame(self)
            if self.timer % 12 == 0 then
                table.insert(self.ps, { x = self.x + ran:Float(-8, 8), y = self.y + ran:Float(-8, 8),
                                        vx = 0, vy = 0, ax = 0, ay = -0.02, alpha = 200, timer = 0 })
            end
            for _, p in ipairs(self.ps) do
                p.x = p.x + p.vx
                p.y = p.y + p.vy
                p.vx = p.vx + p.ax
                p.vy = p.vy + p.ay
                if p.timer > 70 then
                    p.alpha = max(0, p.alpha - 11)
                end
                p.timer = p.timer + 1
            end
            for i = #self.ps, 1, -1 do
                if self.ps[i].alpha == 0 then
                    table.remove(self.ps, i)
                end
            end
        end,
        render = function(self)
            for _, p in ipairs(self.ps) do
                SetImageState("bright", "mul+add", p.alpha, 250, 128, 114)
                Render("bright", p.x, p.y, 0, 6 / 150)
            end
            bullet.render(self)
        end })

    class["bullet_lw2-1"] = Class(bullet, {
        init = function(self, _x, _y, vx, vy, style, col, a, v)
            bullet.init(self, style, COLOR.RED, false, true)
            self.x, self.y = _x, _y
            self.timer = 11
            self.bound = false
            self.rot = Angle(0, 0, vx, vy)
            self.vx = vx
            self.vy = vy
            PlaySound("tan00", 0.1, 0, false)
            task.New(self, function()
                do
                    local vx, _d_vx = (vx), (-vx / 79)
                    local vy, _d_vy = (vy), (-vy / 79)
                    for _ = 1, 80 do
                        self.vx = vx
                        self.vy = vy
                        task.Wait()
                        vx = vx + _d_vx
                        vy = vy + _d_vy
                    end
                end
                task.Wait(60)
                PlaySound("kira00", 0.1, 0, false)
                object.SetV(self, v, a, true)
            end)
        end,
        frame = function(self)
            self.class.base.frame(self)
            if Dist(self.x, self.y, 0, 0) > 500 then
                object.RawDel(self)
            end
        end })
    class["bullet_lw2-2"] = Class(bullet, {
        init = function(self, _x, _y, v, a)
            bullet.init(self, ball_big, COLOR.BLUE, true, true)
            self.x, self.y = _x, _y
            _object.set_color(self, "mul+add", 255, 255, 255, 255)
            object.SetV(self, v, a, true)
            task.New(self, function()
                do
                    while true do
                        do
                            while true do
                                if _boss.out then
                                    break
                                end
                                task.Wait()
                            end
                        end
                        if IsValid(_boss) then
                            if Dist(self, _boss) < 150 then
                                do
                                    local v, _d_v = (4.3), (-4.3 / 59)
                                    for _ = 1, 60 do
                                        if IsValid(_boss) then
                                            object.SetV(self, v, Angle(_boss, self), true)
                                            if self.vy < 0 then
                                                self.vy = -self.vy
                                            end
                                        end
                                        task.Wait()
                                        v = v + _d_v
                                    end
                                end
                            end
                        end
                        object.SetV(self, v, a, true)
                        task.Wait()
                    end
                end
            end)
        end })
    class["bullet_lw2-3"] = Class(bullet, {
        init = function(self, _x, _y, d)
            bullet.init(self, knife, COLOR.GRAY, true, true)
            PlaySound("tan00", 0.1, self.x / 256, false)
            self.x, self.y = _x, _y
            object.SetV(self, 4, Angle(self, player) + d, true)
            self.timer = 11
            self.nopause = true
            self.flag = 0
            task.New(self, function()
                while GetCurrentSuperPause() > 0 do
                    task.Wait()
                end
                if ran:Int(1, 50) == 1 then
                    New(class["bullet_lw2-4"], self.x, self.y, ran:Float(0.5, 1.4), ran:Float(0, 360))
                end
            end)
            task.New(self, function()
                do
                    while true do
                        if GetCurrentSuperPause() > 0 then
                            self.flag = 1
                        else
                            self.flag = 0
                        end
                        task.Wait()
                    end
                end
            end)
            task.New(self, function()
                do
                    while true do
                        while self.flag ~= 1 do
                            task.Wait()
                        end
                        object.SetV(self, 0, self.rot, true)
                        while self.flag ~= 0 do
                            task.Wait()
                        end
                        do
                            local v, _d_v = (8), (-4 / 24)
                            for _ = 1, 25 do
                                object.SetV(self, v, self.rot, true)
                                task.Wait()
                                v = v + _d_v
                            end
                        end
                    end
                end
            end)
        end,
        frame = function(self)
            self.class.base.frame(self)
            if self.timer > 12 and GetCurrentSuperPause() > 0 then
                _object.set_color(self, "", 0, 255, 255, 255)
            else
                _object.set_color(self, "", 255, 255, 255, 255)
            end
        end
    })
    class["bullet_lw2-4"] = Class(bullet, {
        init = function(self, _x, _y, v, a)
            bullet.init(self, ball_mid_c, COLOR.BLUE, true, true)
            self.x, self.y = _x, _y
            self.bound = false
            self.nopause = true
            self.flag = 0
            self.layer = LAYER.TOP - 1
            PlaySound("tan00", 0.1, self.x / 256, false)
            object.SetV(self, v, a, true)
            self.timer = 11
            task.New(self, function()
                do
                    while true do
                        if GetCurrentSuperPause() > 0 then
                            self.flag = 1
                        else
                            self.flag = 0
                        end
                        task.Wait()
                    end
                end
            end)
            task.New(self, function()
                do
                    while true do

                        while self.flag ~= 0 do
                            task.Wait()
                        end
                        do
                            local v, _d_v = (0), (v / 119)
                            for _ = 1, 120 do
                                object.SetV(self, v, self.rot, true)
                                task.Wait()
                                v = v + _d_v
                            end
                        end
                        while self.flag ~= 1 do
                            task.Wait()
                        end
                        object.SetV(self, 0, self.rot, true)
                    end
                end
            end)
        end
    })

    class["bullet_lw3-1"] = Class(bullet, {
        init = function(self, _x, _y, v, a)
            bullet.init(self, grain_a, COLOR.RED, true, true)
            self.x, self.y = _x, _y
            self.group = GROUP.GHOST
            self._no_gray = true
            _object.set_color(self, "mul+rev", 150, 255, 255, 255)
            object.SetV(self, 7, a, true)
            PlaySound("tan00", 0.1, self.x, false)
            task.New(self, function()
                do
                    local v, _d_v = (7), ((-7 + v) / 19)
                    for _ = 1, 20 do
                        object.SetV(self, v, self.rot, true)
                        task.Wait()
                        v = v + _d_v
                    end
                end
            end)
        end,
        colli = function(self, other)
            self.class.base.colli(self, other)
            if other.group == GROUP.INDES then
                Create.bullet_accel(self.x, self.y, ball_mid_c, 4, 0.2, ran:Float(1, 3), ran:Float(0, 360))
                Create.bullet_accel(self.x, self.y, grain_b, 6, 0.2, GetV(self), 180 - self.rot)
                object.Del(self)
            end
        end })
    class["bullet_lw3-2"] = Class(bullet, {
        init = function(self, _x, _y, v, a, x, y)
            bullet.init(self, ball_mid, COLOR.DEEP_GREEN, false, true)
            self.x, self.y = _x, _y
            self.bound = false
            self.timer = 11
            self.navi = true
            object.SetV(self, v, a, true)
            task.New(self, function()
                do
                    local v, _d_v = (v), (-v / 39)
                    for _ = 1, 40 do
                        object.SetV(self, v, self.rot, true)
                        task.Wait()
                        v = v + _d_v
                    end
                end
                task.Wait(20)
                task.MoveTo(x, y, 80, VALUE_SET.ACC_DEC)
                while not (IsValid(_boss) and _boss.t) do
                    task.Wait()
                end
                do
                    local v, _d_v = (0), (0.8 / 119)
                    for _ = 1, 120 do
                        object.SetV(self, v, a, true)
                        task.Wait()
                        v = v + _d_v
                    end
                end
            end)
        end,
        frame = function(self)
            self.class.base.frame(self)
            if Dist(self.x, self.y, 0, 0) > 500 then
                object.RawDel(self)
            end
        end })
    class["bullet_lw3-3"] = Class(bullet, {
        init = function(self, _x, _y, r, g, b, a)
            bullet.init(self, butterfly, COLOR.RED, true, true)
            self.x, self.y = _x, _y
            self.hide = true
            self.group = GROUP.GHOST
            object.SetV(self, 4, a, true)
            PlaySound("tan00", 0.1, self.x, false)
            task.New(self, function()
                while true do
                    Create.saoqi_wave(self.x, self.y, ran:Float(0, 360), self, 0.1, r, g, b)
                    task.Wait(13)
                end
            end)
        end,
        frame = function(self)
            self.class.base.frame(self)
            if Dist(self, player) < 48 then
                local b = Create.bullet_accel(self.x, self.y, grain_b, 16, 0.2, ran:Float(0.5, 1.2), ran:Float(0, 360))
                b.timer = 11
                object.Del(self)
            end
        end,
        del = function(self)
            if not self.dk then
                self.dk = true
                object.Preserve(self)
            end
            task.New(self, function()
                for i = 1, 60 do
                    self.alpha = sin(90 - i * 1.5)
                    task.Wait()
                end
                object.RawDel(self)
            end)
        end
    })
    class["bullet_lw3-4"] = Class(bullet, {
        init = function(self, _x, _y, l, a, x, y, v)
            bullet.init(self, knife, COLOR.RED, true, true)
            self.x, self.y = _x, _y
            PlaySound("tan00", 0.1, 0, false)
            self.navi = true
            self.timer = 11
            task.New(self, function()
                task.Wait(ran:Int(0, 100))

                New(class["bullet_lw3-5"], self.x, self.y, 2, ball_mid, 0, ran:Float(1, 2), ran:Float(0, 360))
            end)
            task.New(self, function()
                task.MoveTo(x + cos(a) * l, y + sin(a) * l, 100, 2)
                do
                    while true do
                        if _boss.t then
                            break
                        end
                        task.Wait()
                    end
                end
                object.SetV(self, v, a, true)
            end)
        end
    })
    class["bullet_lw3-5"] = Class(bullet, {
        init = function(self, _x, _y, col, style, fv, v, a)
            bullet.init(self, style, col, true, true)
            self.x, self.y = _x, _y
            self.timer = 11
            PlaySound("tan00", 0.1, 0, false)
            object.SetV(self, fv, a, true)
            task.New(self, function()
                do
                    while true do
                        if _boss.t then
                            break
                        end
                        task.Wait()
                    end
                end
                do
                    local v, _d_v = (fv), ((-fv + v) / 119)
                    for _ = 1, 120 do
                        object.SetV(self, v, self.rot, true)
                        task.Wait()
                        v = v + _d_v
                    end
                end
            end)
        end
    })
    class["bullet_lw3-6"] = Class(bullet, {
        init = function(self, _x, _y, v, a, col)
            bullet.init(self, butterfly, col, true, true)
            self.x, self.y = _x, _y
            PlaySound("tan00", 0.1, 0, false)
            object.SetV(self, v, a, true)
        end,
        render = function(self)
            SetImageState("bright", "mul+add", self._a, 250, 128, 214)
            Render("bright", self.x, self.y, 0, 25 / 150)
            bullet.render(self)
        end,
        colli = function(self, other)
            self.class.base.colli(self, other)
            if self.timer > 25 then
                if other.group == GROUP.GHOST then
                    if other.fan then
                        object.Del(self)
                    end
                end
                if other.group == GROUP.INDES then
                    if other.fan then
                        object.Del(self)
                    end
                end
            end
        end
    })

end
---bullet
do
    class["Blindness"] = Class(_object, {
        init = function(self, _x, _y, scale, y)
            self.x, self.y = _x, _y
            self.img = "Blindness"
            self.layer = LAYER.ENEMY_BULLET_EF + 1
            self.group = GROUP.INDES
            self.hide = false
            self.bound = false
            self.navi = false
            self.hp = 10
            self.maxhp = 10
            self.colli = false
            self._servants = {}
            self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
            self.vscale = 3
            self.hscale = 3
            New(WhiteScreen, LAYER.TOP, 30)
            object.Connect(player, self, 0, true)
            task.New(self, function()
                do
                    local s, _d_s = (90), (-90 / 89)
                    for _ = 1, 90 do
                        object.SetRelPos(self, 0, sin(s) * y, self.rot, false)
                        self.vscale = scale + sin(s) * (3 - scale)
                        self.hscale = scale + sin(s) * (3 - scale)
                        task.Wait()
                        s = s + _d_s
                    end
                end
                do
                    while true do
                        object.SetRelPos(self, 0, 0, self.rot, false)
                        task.Wait()
                    end
                end
            end)
        end,
        render = function(self)
            _object.render(self)
            SetImageState("white", "", self._a, 0, 0, 0)
            local w = lstg.world
            if self.x - 64 * self.hscale > w.l then
                RenderRect("white", w.l, self.x - 64 * self.hscale, w.t, w.b)
            end
            if self.x + 64 * self.hscale < w.r then
                RenderRect("white", self.x + 64 * self.hscale, w.r, w.t, w.b)
            end
            if self.y - 64 * self.hscale > w.b then
                RenderRect("white", w.l, w.r, self.y - 64 * self.hscale, w.b)
            end
            if self.y + 64 * self.hscale < w.t then
                RenderRect("white", w.l, w.r, w.t, self.y + 64 * self.hscale)
            end
        end,
        del = function()
        end,
        kill = function()
        end })
    class["RedScreen"] = Class(_object, {
        init = function(self, _x, _y, t)
            self.x, self.y = _x, _y
            self.img = "white"
            self.layer = LAYER.ENEMY_BULLET + 1
            self.group = GROUP.GHOST
            self.hide = false
            self.bound = false
            self.navi = false
            self.hp = 10
            self.maxhp = 10
            self.colli = false
            self._servants = {}
            self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
            self.hscale = lstg.world.r / 8
            self.vscale = lstg.world.t / 8
            t = t or 90
            _boss.eye = true
            lstg.var.eye = true
            PlaySound("slash", 1, 0, false)
            _object.set_color(self, "", 0, 200, 0, 0)
            task.New(self, function()
                do
                    local a, _d_a = (0), (50 / 9)
                    for _ = 1, 10 do
                        _object.set_color(self, "", a, 200, 0, 0)
                        task.Wait()
                        a = a + _d_a
                    end
                end
                task.Wait(t - 10)
                _boss.eye = false
                lstg.var.eye = false
                PlaySound("kira00", 1, 0, false)
                object.Del(self)
            end)
        end
    })
    class["RedEye"] = Class(_object, {
        init = function(self, _x, _y, t, a, i)
            self.x, self.y = _x, _y
            self.img = "eye" .. i
            self.layer = LAYER.ENEMY_BULLET_EF
            self.group = GROUP.GHOST
            self.hide = false
            self.bound = true
            self.navi = false
            self.hp = 10
            self.maxhp = 10
            self.colli = true
            self._servants = {}
            self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
            self.vscale = a
            self.hscale = a
            _object.set_color(self, "mul+add", 255, 255, 255, 255)
            task.New(self, function()
                task.Wait(t)
                object.Del(self)
            end)
        end
    })
    class["7-Addhppar"] = Class(_object, {
        init = function(self, x, y, boss)
            self.x, self.y = x, y
            self.img = "bright"
            self.layer = LAYER.ENEMY_BULLET_EF
            self.group = GROUP.INDES
            self.hp = 10
            self.maxhp = 10
            self.colli = false
            self._servants = {}
            local col = { 250, 128, 114 }
            if GetGlobal("player_name") == "reimu_player" or GetGlobal("player_name") == "chiruno_player" then
                col = { 135, 206, 235 }
            end
            self._blend, self._a, self._r, self._g, self._b = 'mul+add', 160, unpack(col)
            self.vscale = 8 / 150
            self.hscale = 8 / 150
            task.New(self, function()
                local a, l = ran:Float(0, 360), ran:Float(40, 80)
                task.MoveToEx(cos(a) * l, sin(a) * l, ran:Int(45, 70), 2)
                task.Wait(10)
                if IsValid(boss) then
                    task.MoveTo(boss.x, boss.y, 45, VALUE_SET.ACCEL)
                end
                if IsValid(boss) then
                    boss.hp = min(boss.maxhp, boss.hp + 1)
                end
                task.Wait(30)
                object.Del(self)
            end)
        end
    })
    class["Blindness with Feather"] = Class(_object, {
        init = function(self, _x, _y, scale, y)
            self.x, self.y = _x, _y
            self.img = "Blindness"
            self.layer = LAYER.ENEMY_BULLET_EF + 1
            self.group = GROUP.INDES
            self.hide = false
            self.bound = false
            self.navi = false
            self.hp = 10
            self.maxhp = 10
            self.colli = false
            self._servants = {}
            self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
            self.vscale = 3
            self.hscale = 3
            New(WhiteScreen, LAYER.TOP, 30)
            object.Connect(player, self, 0, true)
            task.New(self, function()
                do
                    local s, _d_s = (90), (-90 / 89)
                    for _ = 1, 90 do
                        object.SetRelPos(self, 0, sin(s) * y, self.rot, false)
                        self.vscale = scale.scale_s + sin(s) * (3 - scale.scale_s)
                        self.hscale = scale.scale_s + sin(s) * (3 - scale.scale_s)
                        task.Wait()
                        s = s + _d_s
                    end
                end
                do
                    while true do
                        object.SetRelPos(self, 0, 0, self.rot, false)
                        self.vscale = scale.scale_s
                        self.hscale = scale.scale_s
                        task.Wait()
                    end
                end
            end)
        end,
        render = function(self)
            _object.render(self)
            SetImageState("white", "", self._a, 0, 0, 0)
            local w = lstg.world
            if self.x - 64 * self.hscale > w.l then
                RenderRect("white", w.l, self.x - 64 * self.hscale, w.t, w.b)
            end
            if self.x + 64 * self.hscale < w.r then
                RenderRect("white", self.x + 64 * self.hscale, w.r, w.t, w.b)
            end
            if self.y - 64 * self.hscale > w.b then
                RenderRect("white", w.l, w.r, self.y - 64 * self.hscale, w.b)
            end
            if self.y + 64 * self.hscale < w.t then
                RenderRect("white", w.l, w.r, w.t, self.y + 64 * self.hscale)
            end
        end,
        del = function()
        end,
        kill = function()
        end
    })
    class["Slash_1"] = Class(_object, {
        init = function(self, _x, _y, len, rot)
            self.x, self.y = _x, _y
            self.img = "Slash"
            self.layer = LAYER.ENEMY_BULLET
            self.group = GROUP.INDES
            self.hide = false
            self.bound = false
            self.navi = false
            self.hp = 322323
            self.maxhp = 322323
            self.colli = true
            self._servants = {}
            self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
            self.rot = rot

            self.hscale = len / 249
            self.vscale = 0.3
            self.a = len / 2
            self.b = 2
            self.rect = true
            task.New(self, function()
                do
                    local s, _d_s = (0.3), (0.7 / 24)
                    for _ = 1, 25 do
                        self.vscale = s
                        task.Wait()
                        s = s + _d_s
                    end
                end
                task.Wait(150)
                do
                    local s, _d_s = (1), (-1 / 24)
                    for _ = 1, 25 do
                        self.vscale = s
                        task.Wait()
                        s = s + _d_s
                    end
                end
                _object.set_color(self, "", 0, 255, 255, 255)
                object.Del(self)
            end)
        end
    })
    LoadTexture("Lfan", "mod\\GAME\\Lfan.png")
    LoadImageGroup("Lfan", "Lfan", 0, 0, 500, 256, 1, 5, 30, 30)
    class["Little_Fan"] = Class(_object, {
        init = function(self, _x, _y, img)
            self.x, self.y = _x, _y
            self.smear = {}
            self.img = img
            self.layer = LAYER.ENEMY
            self.group = GROUP.GHOST
            self.hide = false
            self.bound = false
            self.navi = false
            self.hp = 10
            self.maxhp = 10
            self.colli = true
            self._servants = {}
            self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
            self.fan = true
        end,
        frame = function(self)
            _object.frame(self)
            object.smear_add(self, 255)
            object.smear_frame(self, 13)
        end,
        render = function(self)
            object.smear_render(self, "mul+add", { 150, 150, 150 })
            _object.render(self)
        end
    })
    class["Little_Fan_Golden"] = Class(class["Little_Fan"], {
        init = function(self, _x, _y, a, l, l2, r, t, bb)
            class["Little_Fan"].init(self, _x, _y, "Lfan4")
            self.hscale = 0
            self.vscale = 0
            task.New(self, function()
                do
                    local s, _d_s = (0), (90 / 11)
                    for _ = 1, 12 do
                        self.vscale = sin(s) * 0.3
                        self.hscale = sin(s) * 0.08
                        task.Wait()
                        s = s + _d_s
                    end
                end
                do
                    local s, _d_s = (0), (90 / 11)
                    for _ = 1, 12 do
                        self.hscale = 0.08 + 0.22 * sin(s)
                        task.Wait()
                        s = s + _d_s
                    end
                end
            end)
            task.New(self, function()
                do
                    local s, _d_s = (0), (90 / 29)
                    for _ = 1, 30 do
                        object.SetRelPos(self, cos(a) * sin(s) * l, sin(a) * sin(s) * l, self.rot, false)
                        self.rot = a - 90
                        task.Wait()
                        s = s + _d_s
                    end
                end
                do
                    for _ = 1, 30 do
                        object.SetRelPos(self, cos(a) * l, sin(a) * l, self.rot, false)
                        self.rot = a - 90
                        task.Wait()
                    end
                end
                local rot = a
                do
                    local sl, _d_sl = (0), (90 / 19)
                    local as, _d_as = (0), (180 / (t - 1))
                    local v, _d_v = (3), (-2 / (t - 1))
                    for _ = 1, t do
                        if self.timer % 3 == 0 then
                            local _a, _d_a = (-50 + rot), (100 / 3)
                            for _ = 1, 4 do
                                New(class["bullet_lw3-6"], bb.x + cos(_a) * 100, bb.y + sin(_a) * 100, v, _a, 13)
                                _a = _a + _d_a
                            end
                        end
                        local L = l + sin(min(sl, 90)) * l2
                        rot = rot + r * sin(as)
                        object.SetRelPos(self, cos(rot) * L, sin(rot) * L, self.rot, false)
                        self.rot = rot - 90
                        task.Wait()
                        sl = sl + _d_sl
                        as = as + _d_as
                        v = v + _d_v
                    end
                end
                do
                    local s, _d_s = (0), (90 / 29)
                    for _ = 1, 30 do
                        local L = l + l2 - sin(s) * l2
                        object.SetRelPos(self, cos(rot) * L, sin(rot) * L, self.rot, false)
                        task.Wait()
                        s = s + _d_s
                    end
                end
                task.New(self, function()
                    do
                        local s, _d_s = (0), (90 / 11)
                        for _ = 1, 12 do
                            self.hscale = 0.3 - 0.22 * sin(s)
                            task.Wait()
                            s = s + _d_s
                        end
                    end
                    do
                        local s, _d_s = (90), (-90 / 11)
                        for _ = 1, 12 do
                            self.vscale = sin(s) * 0.3
                            self.hscale = sin(s) * 0.08
                            task.Wait()
                            s = s + _d_s
                        end
                    end
                    object.Del(self)
                end)
            end)
        end
    })
    class["Little_Fan_Blue"] = Class(class["Little_Fan"], {
        init = function(self, _x, _y, d, A)
            class["Little_Fan"].init(self, _x, _y, "Lfan3")
            self.hscale = 0
            self.vscale = 0
            task.New(self, function()
                self.rot = A - 90
                do
                    local s, _d_s = (0), (90 / 11)
                    for _ = 1, 12 do
                        self.vscale = sin(s) * 0.3
                        self.hscale = sin(s) * 0.08
                        task.Wait()
                        s = s + _d_s
                    end
                end
                do
                    local s, _d_s = (0), (90 / 11)
                    for _ = 1, 12 do
                        self.hscale = 0.08 + 0.22 * sin(s)
                        task.Wait()
                        s = s + _d_s
                    end
                end
                task.New(self, function()
                    local x1, y1, x2, y2 = player.x, player.y, self.x, self.y
                    do
                        local s, _d_s = (0), (180 / 149)
                        local as, _d_as = (0), (90 / 149)
                        local v, _d_v = (1), (2 / 149)
                        for _ = 1, 150 do
                            if self.timer % 4 == 0 then
                                New(class["bullet_lw3-6"], self.x, self.y, v, self.rot + 90, COLOR.BLUE)
                            end
                            self.x, self.y = x2 + (-x2 + x1) * sin(s), y2 + (-y2 + y1) * sin(s)
                            self.rot = A - 90 + sin(as) * 360 * 2 * d
                            task.Wait()
                            s = s + _d_s
                            as = as + _d_as
                            v = v + _d_v
                        end
                    end
                    task.New(self, function()
                        do
                            local s, _d_s = (0), (90 / 11)
                            for _ = 1, 12 do
                                self.hscale = 0.3 - 0.22 * sin(s)
                                task.Wait()
                                s = s + _d_s
                            end
                        end
                        do
                            local s, _d_s = (90), (-90 / 11)
                            for _ = 1, 12 do
                                self.vscale = sin(s) * 0.3
                                self.hscale = sin(s) * 0.08
                                task.Wait()
                                s = s + _d_s
                            end
                        end
                        object.Del(self)
                    end)
                end)
            end)
        end
    })
    class["Little_Fan_Green"] = Class(class["Little_Fan"], {
        init = function(self, _x, _y, d, l, a, x, y, r)
            class["Little_Fan"].init(self, _x, _y, "Lfan2")
            self.hscale = 0
            self.vscale = 0
            task.New(self, function()
                local s, _d_s = (0), (90 / 11)
                for _ = 1, 12 do
                    self.vscale = sin(s) * 0.3
                    self.hscale = sin(s) * 0.08
                    task.Wait()
                    s = s + _d_s
                end
                local s, _d_s = (0), (90 / 11)
                for _ = 1, 12 do
                    self.hscale = 0.08 + 0.22 * sin(s)
                    task.Wait()
                    s = s + _d_s
                end
            end)
            task.New(self, function()
                do
                    local s, _d_s = (0), (d)
                    while true do
                        self.x, self.y = x + cos(sin(s) * a + 90) * l, y + sin(sin(s) * a + 90) * l
                        self.rot = sin(s) * a + r
                        task.Wait()
                        s = s + _d_s
                    end
                end
            end)
        end
    })
end
---_object
DoFile("mod\\GAME\\th08-boss1.lua")
DoFile("mod\\GAME\\th08-boss_lastword.lua")