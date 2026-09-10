local class = {}
_editor_class["TH09"] = class

local cos, sin, abs, min, max, int, sign = cos, sin, abs, min, max, int, sign
local bullet, object, boss = bullet, object, boss
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
    class["SCBG1"] = Class(_SC_BG)
    class["SCBG1"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_4", false, 0, 0, 0, 0, 0, 0.3, "", 2.3, 2.3,
                _editor_class["TH07"]["youmu_slash"].init,
                _editor_class["TH07"]["youmu_slash"].frame, nil,
                _editor_class["TH07"]["youmu_slash"].render)
        _SC_BG.AddLayer(self, "th09_0", false, 0, 0, 0, 0, 0, 0, "mul+add", 1, 1)
        _SC_BG.AddLayer(self, "th08_7", false, 0, 0, 0, 0, 0, -0.3, "", 2.1, 2.1)
        _SC_BG.AddLayer(self, "th08_6", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
    end
    class["SCBG2"] = Class(_SC_BG)
    class["SCBG2"].init = function(self)
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
        _SC_BG.AddLayer(self, "th08_8", false, 0, 0, 0, 0, 0, 0, "mul+add", 1, 1)
        _SC_BG.AddLayer(self, "th08_10", false, 0, 0, 0, 0, 0, 0.5, "", 1.2, 1.2)
    end
    class["SCBG3"] = Class(_SC_BG)
    class["SCBG3"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th06_0", true, 0, 0, 0, 0, -0.07, 0, "mul+add", 1, 1)
        _SC_BG.AddLayer(self, "th08_1", true, 0, 0, 0, 0.4, 1, 0, "", 1, 1)
        _SC_BG.AddLayer(self, "th08_2", true, 0, 0, 0, -0.4, 1.5, 0, "", 1, 1)
    end
    class["SCBG4"] = Class(_SC_BG)
    class["SCBG4"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th08_12", false, 0, 0, 0, 0, 0, 0, "mul+add", 1, 1)
        _SC_BG.AddLayer(self, "th06_5", false, 0, 0, 0, 0, 0, -0.5, "", 2.3, 2.3)
        _SC_BG.AddLayer(self, "th08_21", false, 0, 0, 0, 0, 0, -0.8, "", 2.2, 2.2)
    end
    class["SCBG5"] = Class(_SC_BG)
    class["SCBG5"].init = function(self)
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th07_2", false, 0, 0, 0,
                0, 0, 0.3, "mul+add", 2, 2)
        b.a = 150
        _SC_BG.AddLayer(self, "th06_5", false, 0, 0, 0,
                0, 0, -0.5, "", 2.5, 2.5)
        _SC_BG.AddLayer(self, "th08_21", false, 0, 0, 0,
                0, 0, -0.8, "", 2.2, 2.2)
    end
    class["SCBG6"] = Class(_SC_BG)
    class["SCBG6"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th09_1", false, 0, 0, 0, 0, 0, -0.4, "mul+add", 2.2, 2.2,
                function(unit)
                    unit.a = 150
                end)
        _SC_BG.AddLayer(self, "th09_3", false, 0, 0, 0, 0, 0, 0.3, "", 2.3, 2.3,
                function(unit)
                    unit.a = 150
                end)
        _SC_BG.AddLayer(self, "th09_2", true, 0, 0, 0, 0, 1.8, 0, "", 1, 1)
    end
    class["SCBG9"] = Class(_SC_BG)
    class["SCBG9"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th09_8", true, 0, 0, 0, 0, 1, 0, "mul+add", 1, 1)
        _SC_BG.AddLayer(self, "th09_6", true, 0, 0, 0, -1.5, 1, 0, "", 1, 1)
        _SC_BG.AddLayer(self, "th09_7", false, 0, 0, 0, 0, 0, 0.3, "", 2.2, 2.2)
        _SC_BG.AddLayer(self, "th09_5", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
    end
    class["SCBG10"] = Class(_SC_BG)
    class["SCBG10"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th09_8", true, 0, 0, 0, 0, 1, 0, "mul+add", 1, 1)
        _SC_BG.AddLayer(self, "th09_7", false, 0, 0, 0, 0, 0, 0.3, "", 2, 2)
        _SC_BG.AddLayer(self, "th09_4", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
    end
end--_SC_BG
do
    class["bullet1-1"] = Class(bullet, {
        init = function(self, _x, _y, v, a, master)
            bullet.init(self, ball_huge, COLOR.GREEN, true, false)
            self.x, self.y = _x, _y
            self.wave = {}
            self.alpha = 250
            PlaySound("option", 1, 0, false)
            object.SetV(self, v, a, true)
            task.New(self, function()
                do
                    local v, _d_v = (v), (-v / 79)
                    for _ = 1, 80 do
                        if self.x < -192 or self.x > 192 then
                            self.rot = 180 - self.rot
                            self.x = sign(self.x) * 384 - self.x
                        end
                        if self.y > 224 or self.y < -224 then
                            self.rot = -self.rot
                            self.y = sign(self.y) * 448 - self.y
                        end
                        object.SetV(self, v, self.rot, true)
                        task.Wait()
                        v = v + _d_v
                    end
                end
                task.Wait(20)
                Newcharge_out(self.x, self.y, 30, 230, 30)
                task.New(self, function()
                    task.Wait(160)
                    for i = 1, 10 do
                        self.alpha = 250 - 250 * sin(i * 9)
                        task.Wait()
                    end
                end)
                for i = 1, 50 do
                    self.wave[i] = { x = self.x, y = self.y, alpha = 250 }
                    task.New(self.wave[i], function()
                        task.MoveTo(self.x + cos(i * 7.2) * 130, self.y + sin(i * 7.2) * 130, 80, 2)
                    end)
                end
                self.hide_2 = true
                self.colli = false
                do
                    local l, _d_l = (0), (90 / 79)
                    for _ = 1, 170 do
                        if Dist(self, player) < 130 * sin(min(90, l)) then
                            lstg.var.timeslow = 2
                            player.own_gray = true
                            if IsValid(master) then
                                master.noache = true
                                master.bg.layers[1].slash_time = 1
                            end
                        else
                            lstg.var.timeslow = 1
                            player.own_gray = false
                        end
                        object.BulletIndesDo(function(unit)
                            if Dist(self, unit) < 130 * sin(min(90, l)) then
                                unit.own_gray = true
                            elseif unit.own_gray then
                                unit.own_gray = nil
                            end
                        end)
                        object.EnemyNontjtDo(function(unit)
                            if Dist(self, unit) < 130 * sin(min(90, l)) then
                                unit.own_gray = true
                            elseif unit.own_gray then
                                unit.own_gray = nil
                            end
                        end)
                        task.Wait()
                        l = l + _d_l
                    end
                end
                PlaySound("kira00", 0.1, 0, false)
                lstg.var.timeslow = 1
                if player.own_gray then
                    player.own_gray = false
                end
                object.BulletIndesDo(function(unit)
                    if unit.own_gray then
                        unit.own_gray = nil
                    end
                end)
                object.EnemyNontjtDo(function(unit)
                    if unit.own_gray then
                        unit.own_gray = nil
                    end
                end)
                self.x = 500
                self.y = 500
                object.Del(self)
            end)
        end,
        frame = function(self)
            for _, w in ipairs(self.wave) do
                task.Do(w)
            end
            bullet.frame(self)
        end,
        render = function(self)
            for _, w in ipairs(self.wave) do
                SetImageState("bright", "mul+add", self.alpha, 218, 112, 214)
                Render("bright", w.x, w.y, 0, 25 / 150)
            end
            if not self.hide_2 then
                bullet.render(self)
            end
        end,
        del = function(self)
            bullet.del(self)
            lstg.var.timeslow = 1
        end,
        kill = function(self)
            bullet.kill(self)
            lstg.var.timeslow = 1
        end })
    class["bullet1-2"] = Class(bullet, {
        init = function(self, _x, _y, col, v, a)
            bullet.init(self, star_big, col, true, true)
            self.x, self.y = _x, _y
            PlaySound("tan00", 0.1, self.x / 256, false)
            object.SetV(self, 0.4, a, false)
            self.rot = 0
            self.omiga = ran:Sign() * 2
            self.bound = false
            local d = 1
            self.v = 0.3
            task.New(self, function()
                for _ = 1, 10 do
                    New(class["bullet1-3"], self.x, self.y, col, v, a, d)
                    d = -d
                    task.Wait(3)
                end
                do
                    local v, _d_v = (0.3), ((-0.3 + v) / 59)
                    for _ = 1, 60 do
                        object.SetV(self, v, a, false)
                        self.v = v
                        task.Wait()
                        v = v + _d_v
                    end
                end
            end)
            task.New(self, function()
                do
                    while true do
                        if _boss.eye then
                            object.SetV(self, -self.v, a, false)
                            self.colli = false
                            _object.set_color(self, "", 150, 255, 255, 255)
                        else
                            object.SetV(self, self.v, a, false)
                            self.colli = true
                            _object.set_color(self, "", 255, 255, 255, 255)
                        end
                        task.Wait()
                    end
                end
            end)
        end,
        frame = function(self)
            self.class.base.frame(self)
            if Dist(self.x, self.y, 0, 0) > 400 then
                object.Del(self)
            end
        end })
    class["bullet1-3"] = Class(bullet, {
        init = function(self, _x, _y, col, v, a, d)
            bullet.init(self, star_small, col, false, true)
            self.x, self.y = _x, _y
            self.bound = false
            self.rot = 0
            self.omiga = ran:Sign() * 2
            object.SetV(self, 0.3, a, false)
            self.v = 0.3
            task.New(self, function()
                task.Wait(30)
                do
                    local v, _d_v = (0.3), ((-0.3 + v) / 59)
                    for _ = 1, 60 do
                        object.SetV(self, v, a, false)
                        self.v = v
                        task.Wait()
                        v = v + _d_v
                    end
                end
            end)
            task.New(self, function()
                do
                    while true do
                        if _boss.eye then
                            self.vx = cos(a + 135 * d)
                            self.vy = sin(a + 135 * d)
                            self.colli = false
                            _object.set_color(self, "", 150, 255, 255, 255)
                        else
                            object.SetV(self, self.v, a, false)
                            self.colli = true
                            _object.set_color(self, "", 255, 255, 255, 255)
                        end
                        task.Wait()
                    end
                end
            end)
        end,
        frame = function(self)
            self.class.base.frame(self)
            if Dist(self.x, self.y, 0, 0) > 400 then
                object.Del(self)
            end
        end })
    class["bullet1-4"] = Class(bullet, {
        init = function(self, _x, _y, a, v, col)
            bullet.init(self, gun_bullet, col, true, true)
            self.x, self.y = _x, _y
            PlaySound("tan00", 0.1, self.x, false)
            object.SetV(self, v, a, true)
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
                                object.SetV(self, v, self.rot, true)
                                _object.set_color(self, "", a, 255, 255, 255)
                                task.Wait()
                                a = a + _d_a
                                v = v + _d_v
                            end
                        end
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
                                object.SetV(self, v, self.rot, true)
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
        end })
    class["bullet1-5"] = Class(bullet, {
        init = function(self, _x, _y, l, s, a, bb, i)
            bullet.init(self, ball_big, COLOR.PURPLE, false, false)
            self.group = GROUP.ENEMY
            self.x, self.y = _x, _y
            self._ice = true
            self.layer = LAYER.ENEMY_BULLET_EF
            self.bound = false
            self.navi = true
            self.ice = 0
            task.New(self, function()
                local S, B
                for rx = 1, _infinite do
                    S = sin(min(rx, 90))
                    B = sin(i) * bb
                    object.SetRelPos(self, cos(a + B) * l * S, sin(a + B) * l * S, self.rot, false)
                    task.Wait()
                    i = i + s
                end
            end)
            task.New(self, function()
                while true do
                    self.ice = max(0, self.ice - 1)
                    task.Wait()
                end
            end)
            task.New(self, function()
                do
                    while true do
                        while self.ice <= 0 do
                            task.Wait()
                        end
                        bullet.ChangeImage(self, ball_big, COLOR.BLUE)
                        do
                            local a, _d_a = (self.rot), (13 * ran:Sign())
                            for _ = 1, 30 do
                                Create.bullet_accel(self.x, self.y, grain_b, 8, 0.1, 1.5, a)
                                task.Wait(2)
                                a = a + _d_a
                            end
                        end
                        bullet.ChangeImage(self, ball_big, COLOR.PURPLE)
                        task.Wait()
                    end
                end
            end)
        end })
    class["bullet2-1"] = Class(bullet, {
        init = function(self, _x, _y, v, a)
            bullet.init(self, arrow_small, COLOR.ORANGE, false, true)
            self.x, self.y = _x, _y
            self.flag = 0
            self.nopause = true
            PlaySound("kira00", 0.5, self.x / 256, false)
            object.SetV(self, v, a, true)
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
                        while true do
                            if self.flag == 1 then
                                break
                            end
                            task.Wait()
                        end
                        object.SetV(self, 0, self.rot + 180, true)
                        while true do
                            if self.flag == 0 then
                                break
                            end
                            task.Wait()
                        end
                        do
                            local v, _d_v = (0), (v / 79)
                            for _ = 1, 80 do
                                object.SetV(self, v, self.rot, true)
                                task.Wait()
                                v = v + _d_v
                            end
                        end

                    end
                end
            end)
        end })
    class["bullet2-2"] = Class(bullet, {
        init = function(self, _x, _y, v, a)
            bullet.init(self, arrow_small, 6, false, true)
            self.x, self.y = _x, _y
            PlaySound("tan00", 0.1, 0, false)
            object.SetV(self, v, a, true)
            task.New(self, function()
                while true do
                    while not _boss.t do
                        task.Wait()
                    end
                    local t = ran:Int(80, 140)
                    object.SetV(self, 0, self.rot, true)
                    task.Wait(50)
                    local _d_a = ran:Sign() * ran:Float(0.4, 0.8)
                    local V, _d_v = 0, (v + 0.01 * t) / (t - 1)
                    for _ = 1, t do
                        object.SetV(self, V, self.rot + _d_a, true)
                        task.Wait()
                        a = a + _d_a
                        V = V + _d_v
                    end
                    task.Wait()
                end
            end)
        end })
    class["bullet2-3"] = Class(bullet, {
        init = function(self, _x, _y, a, v)
            bullet.init(self, music, 6, true, true)
            self.x, self.y = _x, _y
            self.rot = -90
            task.New(self, function()
                local t = 1
                local A = a + Angle(0, 30, player.x, player.y)
                local l, _d_l = (0), (v)
                while true do
                    if t == 1 then
                        A = a + Angle(0, 30, player.x, player.y)
                    else
                        bullet.ChangeImage(self, music, 2)
                    end
                    self.x = cos(A) * l
                    self.y = 30 + sin(A) * l
                    if _boss.t then
                        t = 0
                        task.New(self, function()
                            for _ = 1, 60 do
                                l = l - v
                                task.Wait()
                            end
                        end)
                    end
                    task.Wait()
                    l = l + _d_l
                end
            end)
        end })
    class["bullet5-1"] = Class(bullet, {
        init = function(self, _x, _y, v, a, n, r, col, bb, list, poison)
            bullet.init(self, ball_big, col, false, true)
            self.x, self.y = _x, _y
            self.boss = bb
            self.list = list
            self.poison = poison
            PlaySound("kira00", 0.1, 0, false)
            self.timer = 11
            self.hscale, self.vscale, self.a, self.b = 0, 0, 0, 0
            self.rotate = 0
            do
                local a, _d_a = (ran:Float(0, 360)), (360 / n)
                for _ = 1, n do
                    object.Connect(self, New(class["bullet5-2"], self.x, self.y, a, r, col), 0, true)
                    a = a + _d_a
                end
            end
            object.SetV(self, v, a, true)
            task.New(self, function()
                do
                    local s, _d_s = (0), (0.8 / 14)
                    for _ = 1, 15 do
                        self.hscale, self.vscale, self.a, self.b = s, s, s * 8, s * 8
                        task.Wait()
                        s = s + _d_s
                    end
                end
            end)
            task.New(self, function()
                do
                    while true do
                        if self.t then
                            break
                        end
                        task.Wait()
                    end
                end
                do
                    local v, _d_v = (v), ((-v + 8) / 59)
                    for _ = 1, 60 do
                        object.SetV(self, v, self.rot, true)
                        task.Wait()
                        v = v + _d_v
                    end
                end
            end)
        end,
        frame = function(self)
            self.class.base.frame(self)
            if self.t then
                if self.x > 192 or self.x < -192 or self.y > 224 or self.y < -224 then
                    PlaySound("kira00", 0.1, 0, false)
                    local b = New(class["Poison"], self.x, self.y, 0.6, self.rot + 180)
                    object.Connect(self.boss, b, 0, true)
                    self.list.i = self.list.i + 1
                    for i = 1, #self.poison do
                        if not IsValid(self.poison[i]) then
                            self.poison[i] = b
                        end
                    end
                    self.poison[self.list.i] = b
                    object.Del(self)
                end
            end
        end,
        colli = function(self, other)
            self.class.base.colli(self, other)
            if other.group == GROUP.GHOST and other.wind then
                self.t = true
            end
        end })
    class["bullet5-2"] = Class(bullet, {
        init = function(self, _x, _y, a, r, col)
            bullet.init(self, grain_b, col, true, true)
            self.x, self.y = _x, _y
            self.timer = 11
            self.hscale, self.vscale, self.a, self.b = 0, 0, 0, 0
            task.New(self, function()
                do
                    local s, _d_s = (0), (0.8 / 14)
                    for _ = 1, 15 do
                        self.hscale, self.vscale, self.a, self.b = s, s, s * 2.5, s * 2.5
                        task.Wait()
                        s = s + _d_s
                    end
                end
            end)
            task.New(self, function()
                do
                    local a, _d_a = (a), (r)
                    local s, _d_s = (0), (90 / 14)
                    while true do
                        self.rot = a
                        if not IsValid(self._master) then
                            object.Del(self)
                        end
                        object.SetRelPos(self, cos(a) * 10 * sin(min(s, 90)), sin(a) * 10 * sin(min(s, 90)), self.rot, false)
                        task.Wait()
                        a = a + _d_a
                        s = s + _d_s
                    end
                end
            end)
        end })
    class["bullet5-3"] = Class(bullet, {
        init = function(self, _x, _y, v, a)
            bullet.init(self, butterfly, COLOR.RED, true, true)
            self.x, self.y = _x, _y
            self.timer = 11
            self.wind = true
            self.group = GROUP.GHOST
            object.SetV(self, v, a, true)
            self.hide = true
            task.New(self, function()
                do
                    while true do
                        if self.t then
                            break
                        end
                        Create.saoqi_wave(self.x, self.y, ran:Float(0, 360), self, 0.1, 220, 220, 220)
                        task.Wait(13)
                    end
                end
            end)
        end })
    class["bullet5-4"] = Class(_object, {
        init = function(self, _x, _y, x, y, r, len, c)
            self.x, self.y = _x, _y
            self.img = "leaf"
            self.layer = LAYER.ENEMY_BULLET
            self.group = GROUP.INDES
            self.bound = false
            self.navi = false
            self.hp = 10
            self.maxhp = 10
            self.colli = false
            self._servants = {}
            self.bright = {}
            self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
            task.New(self, function()
                do
                    local a, _d_a = (ran:Float(0, 360)), (72)
                    for j = 1, 5 do
                        local rot, _d_rot, v, _d_v
                        rot, _d_rot = (a), (36 / 16)
                        v, _d_v = (2), ((len - 2) / 16)
                        for i = 1, 16 do
                            self.bright[i + (j - 1) * 32] = { x = self.x, y = self.y, a = rot, fl = 3 * 25, l = (v - 3) * 25, r = r }
                            task.New(self.bright[i + (j - 1) * 32], function()
                                local self = task.GetSelf()
                                local a, fl, l, r = self.a, self.fl, self.l, self.r
                                for i = 1, 60 do
                                    self.x, self.y = cos(a) * fl * sin(i * 1.5), sin(a) * fl * sin(i * 1.5)
                                    task.Wait()
                                    a = a + r
                                end
                                for _ = 1, 30 do
                                    self.x, self.y = cos(a) * fl, sin(a) * fl
                                    task.Wait()
                                    a = a + r
                                end
                                for i = 1, 60 do
                                    self.x, self.y = cos(a) * (fl + l * sin(i * 1.5)), sin(a) * (fl + l * sin(i * 1.5))
                                    task.Wait()
                                    a = a + r
                                end
                                while true do
                                    self.x, self.y = cos(a) * (fl + l), sin(a) * (fl + l)
                                    task.Wait()
                                    a = a + r
                                end
                            end)
                            rot = rot + _d_rot
                            v = v + _d_v
                        end
                        rot, _d_rot = (a + 36), (36 / 16)
                        v, _d_v = (len), ((2 - len) / 16)
                        for i = 17, 32 do
                            self.bright[i + (j - 1) * 32] = { x = self.x, y = self.y, a = rot, fl = 3 * 25, l = (v - 3) * 25, r = r }
                            task.New(self.bright[i + (j - 1) * 32], function()
                                local self = task.GetSelf()
                                local a, fl, l, r = self.a, self.fl, self.l, self.r
                                for i = 1, 60 do
                                    self.x, self.y = cos(a) * fl * sin(i * 1.5), sin(a) * fl * sin(i * 1.5)
                                    task.Wait()
                                    a = a + r
                                end
                                for _ = 1, 30 do
                                    self.x, self.y = cos(a) * fl, sin(a) * fl
                                    task.Wait()
                                    a = a + r
                                end
                                for i = 1, 60 do
                                    self.x, self.y = cos(a) * (fl + l * sin(i * 1.5)), sin(a) * (fl + l * sin(i * 1.5))
                                    task.Wait()
                                    a = a + r
                                end
                                while true do
                                    self.x, self.y = cos(a) * (fl + l), sin(a) * (fl + l)
                                    task.Wait()
                                    a = a + r
                                end
                            end)
                            rot = rot + _d_rot
                            v = v + _d_v
                        end
                        rot, _d_rot = (a), (36 / c)
                        v, _d_v = (2), ((len - 2) / c)
                        for _ = 1, c do
                            object.Connect(self, New(class["bullet5-5"], self.x, self.y, rot, 3 * 25, (v - 3) * 25, r), 0, true)
                            rot = rot + _d_rot
                            v = v + _d_v
                        end
                        rot, _d_rot = (a + 36), (36 / c)
                        v, _d_v = (len), ((2 - len) / c)
                        for _ = 1, c do
                            object.Connect(self, New(class["bullet5-5"], self.x, self.y, rot, 3 * 25, (v - 3) * 25, r), 0, true)
                            rot = rot + _d_rot
                            v = v + _d_v
                        end
                        a = a + _d_a
                    end
                end
                task.MoveTo(x, y, 60, 2)
                task.Wait(30)
                local A = Angle(self, player) + ran:Float(-10, 10)
                Newcharge_out(self.x, self.y, 250, 128, 114)
                task.Wait(60)
                do
                    local v, _d_v = (0), (1.7 / 34)
                    for _ = 1, 35 do
                        object.SetV(self, v, A, true)
                        task.Wait()
                        v = v + _d_v
                    end
                end
            end)
        end,
        frame = function(self)
            self.class.base.frame(self)
            for _, r in ipairs(self.bright) do
                task.Do(r)
            end
            if self.y < -500 then
                object.Del(self)
            end
        end,
        render = function(self)
            for _, w in ipairs(self.bright) do
                SetImageState("bright", "mul+add", 200, 250, 128, 114)
                Render("bright", self.x + w.x, self.y + w.y, 0, 15 / 150)
            end
        end })
    class["bullet5-5"] = Class(bullet, {
        init = function(self, _x, _y, a, fl, l, r)
            bullet.init(self, heart, COLOR.RED, false, true)
            self.x, self.y = _x, _y
            self.hscale, self.vscale, self.a, self.b = 0.7, 0.7, 0.5 * self.a, 0.5 * self.b
            self.bound = false
            self.rot = a
            PlaySound("kira00", 0.1, 0, false)
            task.New(self, function()
                for i = 1, 60 do
                    object.SetRelPos(self, cos(a) * fl * sin(i * 1.5), sin(a) * fl * sin(i * 1.5), self.rot)
                    self.rot = a
                    task.Wait()
                    a = a + r
                end
                for _ = 1, 30 do
                    object.SetRelPos(self, cos(a) * fl, sin(a) * fl, self.rot)
                    self.rot = a
                    task.Wait()
                    a = a + r
                end
                for i = 1, 60 do
                    object.SetRelPos(self, cos(a) * (fl + l * sin(i * 1.5)), sin(a) * (fl + l * sin(i * 1.5)), self.rot)
                    self.rot = a
                    task.Wait()
                    a = a + r
                end
                while true do
                    object.SetRelPos(self, cos(a) * (fl + l), sin(a) * (fl + l), self.rot)
                    self.rot = a
                    task.Wait()
                    a = a + r
                end
            end)
        end })
    class["bullet5-6"] = Class(bullet, {
        init = function(self, _x, _y, v, a, t, d)
            bullet.init(self, money, COLOR.ORANGE, false, true)
            self.x, self.y = _x, _y
            PlaySound("tan00", 0.1, 0, false)
            self.colli = false
            self.omiga = d
            object.SetV(self, 0.2, a, false)
            task.New(self, function()
                for _ = 1, 11 do
                    if Dist(self, player) < 40 then
                        object.Del(self)
                    end
                    task.Wait()
                end
                self.colli = true
            end)
            task.New(self, function()
                task.Wait(120)
                Create.bullet_create_eff(self.x, self.y, money, 16)
                bullet.ChangeImage(self, money, 14)
                if t ~= 1 then
                    self.x = 500
                    self.y = 500
                    object.Del(self)
                end
                self.omiga = 0
                task.Wait(11)
                do
                    local v, _d_v = (v * 2), (-v * 2 / 24)
                    for _ = 1, 25 do
                        object.SetV(self, v, a, false)
                        task.Wait()
                        v = v + _d_v
                    end
                end
                task.Wait(60)
                do
                    local v, _d_v = (0), (v / 2 / 119)
                    local d, _d_d = (0), (d / 119)
                    for _ = 1, 120 do
                        self.omiga = d
                        object.SetV(self, v, a, false)
                        task.Wait()
                        v = v + _d_v
                        d = d + _d_d
                    end
                end
            end)
        end,
        render = function(self)
            SetImageState("bright", "mul+add", 160, 255, 227, 132)
            Render("bright", self.x, self.y, 0, 25 / 150)
            bullet.render(self)
        end })
    class["bullet5-7"] = Class(_object, {
        init = function(self, _x, _y, col, v, a)
            self.x, self.y = _x, _y
            self.img = "bright"
            self.layer = LAYER.ENEMY_BULLET - 1
            self.group = GROUP.GHOST
            self.hide = false
            self.bound = true
            self.navi = false
            self.hp = 10
            self.maxhp = 10
            self.colli = false
            self._servants = {}
            self._blend, self._a, self._r, self._g, self._b = "mul+add", 255, col[1], col[2], col[3]
            self.vscale = 25 / 150
            self.hscale = 25 / 150
            object.SetV(self, v, a, true)
            task.New(self, function()
                do
                    local v, _d_v = (v), (-v / 49)
                    local a, _d_a = (255), (-255 / 129)
                    for _ = 1, 130 do
                        object.SetV(self, max(0, v), self.rot, true)
                        self._a = a
                        task.Wait()
                        v = v + _d_v
                        a = a + _d_a
                    end
                end
                object.Del(self)
            end)
        end })
    class["bullet5-8"] = Class(bullet, {
        init = function(self, _x, _y, col, v, a, ca, rgb)
            bullet.init(self, grain_b, col, true, true)
            self.x, self.y = _x, _y
            self.colli = false
            _object.set_color(self, "", 0, 255, 255, 255)
            self.timer = 11
            self.rgb = rgb
            task.New(self, function()
                object.SetV(self, v, a + ca, true)
                do
                    local a, _d_a = (0), (90 / 44)
                    for _ = 1, 45 do
                        _object.set_color(self, "", 255 * sin(a), 255, 255, 255)
                        task.Wait()
                        a = a + _d_a
                    end
                end
                self.colli = true
            end)
        end,
        render = function(self)
            SetImageState("bright", "mul+add", 250, unpack(self.rgb))
            Render("bright", self.x, self.y, 0, 14 / 150)
            bullet.render(self)
        end })
    class["bullet5-9"] = Class(bullet, {
        init = function(self, _x, _y, v, a, t, c)
            bullet.init(self, ball_big, 10, true, true)
            self.x, self.y = _x, _y
            _object.set_color(self, "", 255, 255, 255, 255)
            self.flag = t
            object.SetV(self, v, a, true)
            self.navi = true
            PlaySound("tan00", 0.1, 0, false)
            task.New(self, function()
                do
                    while true do
                        if self.x < -192 or self.x > 192 then
                            self.vx = -self.vx
                        end
                        if self.y > 224 and self.flag > 0 then
                            self.flag = 0
                            object.SetV(self, 0, self.rot, true)
                            self.y = 224
                            Create.little_charge_out(self.x, self.y, 180, 189, 252, 201, 0.8)
                            task.New(self, function()
                                local rgb = { 189, 252, 201 }
                                do
                                    local a, _d_a = (ran:Float(0, 360)), (360 / c)
                                    for _ = 1, c do
                                        New(class["bullet5-8"], self.x, self.y, COLOR.GREEN, 2.5, a, 0, rgb)
                                        a = a + _d_a
                                    end
                                end
                            end)
                            task.New(self, function()
                                do
                                    local s, _d_s = (1), (2 / 10)
                                    local a, _d_a = (255), (-255 / 10)
                                    for _ = 1, 11 do
                                        self.hscale = s
                                        self.vscale = s
                                        _object.set_color(self, "mul+add", a, 255, 255, 255)
                                        task.Wait()
                                        s = s + _d_s
                                        a = a + _d_a
                                    end
                                end
                                object.Del(self)
                            end)
                        end
                        task.Wait()
                    end
                end
            end)
        end })
    class["bullet5-10"] = Class(bullet, {
        init = function(self, _x, _y, v, a, col, d, rgb)
            bullet.init(self, butterfly, col, false, false)
            self.x, self.y = _x, _y
            self.bound = false
            PlaySound("tan00", 0.1, self.x / 256, false)
            object.SetV(self, v, a, true)
            task.New(self, function()
                do
                    local v, _d_v = (v), (-v / 49)
                    local a, _d_a = (255), (-255 / 49)
                    for _ = 1, 50 do
                        object.SetV(self, v, self.rot, true)
                        _object.set_color(self, "", a, 255, 255, 255)
                        task.Wait()
                        v = v + _d_v
                        a = a + _d_a
                    end
                end
                self.colli = false
                task.Wait(80)
                object.SetV(self, 0, self.rot + 30 * d, true)
                task.New(self, function()
                    local a, _d_a = (self.rot + 180), (120)
                    for _ = 1, 3 do
                        New(class["bullet5-8"], self.x, self.y, col, 1, a, 0, rgb)

                        a = a + _d_a
                    end
                    PlaySound("kira00", 0.1, self.x / 256, false)
                    local ca, _d_ca = (0), (0.13)
                    while true do
                        New(class["bullet5-8"], self.x, self.y, col, 2, self.rot, ran:Float(-ca, ca), rgb)
                        task.Wait(3)
                        ca = ca + _d_ca
                    end
                end)
                do
                    local v, _d_v = (0), (5 / 29)
                    for _ = 1, 30 do
                        object.SetV(self, v, self.rot, true)
                        task.Wait()
                        v = v + _d_v
                    end
                end
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
end--bullet
do
    LoadTexture2("Poison", "mod\\GAME\\Poison.png")

    class["Ice"] = Class(_object, {
        colli = function(self, other)
            self.class.base.colli(self, other)
            if other.group == GROUP.ENEMY and other._ice then
                other.ice = 2
            end
        end,
        init = function(self, _x, _y, v, a)
            self.x, self.y = _x, _y
            self.img = "ice"
            self.a, self.b = 18, 2
            self.layer = LAYER.ENEMY_BULLET_EF
            self.group = GROUP.ENEMY_BULLET
            self.hide = false
            self.bound = true
            self.navi = true
            self.hp = 10
            self.maxhp = 10
            self.colli = true
            self._servants = {}
            self._blend, self._a, self._r, self._g, self._b = '', 255, 255, 255, 255
            self.ice = true
            object.SetV(self, 0.2, a, true)
            self.hscale = 0
            self.vscale = 0
            task.New(self, function()
                do
                    local s, _d_s = (0), (1 / 15)
                    local ss, _d_ss = (0), (0.1 / 15)
                    for _ = 1, 16 do
                        self.hscale = s
                        self.vscale = ss
                        task.Wait()
                        s = s + _d_s
                        ss = ss + _d_ss
                    end
                end
                do
                    local s, _d_s = (0.1), (0.9 / 15)
                    for _ = 1, 16 do
                        self.vscale = s
                        task.Wait()
                        s = s + _d_s
                    end
                end
                do
                    local v, _d_v = (0.2), ((-0.2 + v) / 59)
                    for _ = 1, 60 do
                        object.SetV(self, v, self.rot, true)
                        task.Wait()
                        v = v + _d_v
                    end
                end
            end)
        end })
    class["Poison"] = Class(_object, {
        init = function(self, _x, _y, v, a)
            self.x, self.y = _x, _y
            self.img = "img_void"
            self.layer = LAYER.TOP
            self.group = GROUP.INDES
            self.imgx, self.imgy = ran:Float(-256, 256), ran:Float(-256, 256)
            self.imgvx, self.imgvy = ran:Float(-2, 2), ran:Float(-2, 2)
            self.hide = false
            self.navi = false
            self.hp = 10
            self.maxhp = 10
            self.colli = false
            self._servants = {}
            self._blend, self._a, self._r, self._g, self._b = '', 0, 255, 255, 255
            self.angle = a
            self.omiga = ran:Sign() * ran:Float(0.5, 1)
            self.rot = ran:Float(0, 360)
            object.SetV(self, v, a, true)
            task.New(self, function()
                do
                    local a, _d_a = (0), (180 / 29)
                    for _ = 1, 30 do
                        _object.set_color(self, "", a, 255, 255, 255)
                        task.Wait()
                        a = a + _d_a
                    end
                end
            end)
        end,
        frame = function(self)
            self.class.base.frame(self)
            self.imgx = self.imgx + self.imgvx
            self.imgy = self.imgy + self.imgvy
        end,
        render = function(self)
            local color1 = Color(self._a, self._r, self._g, self._b)
            local color2 = Color(0, self._r, self._g, self._b)
            local point = 32
            local r = 100
            local b = {}
            local ang = 360 / (2 * point)
            for angle = 360 / point, 360, 360 / point do
                b = { cos(angle + ang), sin(angle + ang), cos(angle - ang), sin(angle - ang) }
                RenderTexture("Poison", "",
                        { self.x + r * b[1], self.y + r * b[2], 0.5, self.imgx + r * b[1], self.imgy + r * b[2], color2 },
                        { self.x + r * b[3], self.y + r * b[4], 0.5, self.imgx + r * b[3], self.imgy + r * b[4], color2 },
                        { self.x, self.y, 0.5, self.imgx, self.imgy, color1 },
                        { self.x, self.y, 0.5, self.imgx, self.imgy, color1 })
            end
        end })
end--_object
do
    boss.Define("1a", "博丽灵梦", "TH09_2", TH09_bg, { -400, 0 }, class["SCBG1"], "Reimu", 4)
    boss.Define("1b", "魂魄妖梦", "TH09_2", TH09_bg, { -360, 0 }, class["SCBG1"], "Youmu", 4, 0.6)
    local name = "灵冥「小年虚知，大年实明」"
    local sc1 = boss.card.New(name, 1, 1, 60, 400)
    local sc2 = boss.card.New(name, 1, 1, 60, 700)
    boss.card.add({ { sc1, "1a" }, { sc2, "1b" } }, 4, name, 40)
    local reimu, youmu
    function sc1:before()
        reimu = self
        self.smear = {}
        self.jump = { function()
            local h, v = 1, 1
            for _ = 1, 11 do
                self.vscale = v
                self.hscale = h
                task.Wait()
                h = h - 1 / 10
                v = v + 0.8 / 10
            end
        end, function()
            local h, v = 0, 1.8
            for _ = 1, 11 do
                self.vscale = v
                self.hscale = h
                task.Wait()
                h = h + 1 / 10
                v = v - 0.8 / 10
            end
        end }
        task.MoveTo(100, 100, 60, 2)
    end
    function sc1:frame()
        if self.own_gray then
            _object.set_color(self, "mul+rev", 255, 255, 255, 255)
        else
            _object.set_color(self, "", 255, 255, 255, 255)
        end
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
    function sc1:render()
        for _, s in ipairs(self.smear) do
            SetImageState(s.img, "mul+add", s.alpha, 255, 227, 132)
            Render(s.img, s.x, s.y, s.rot, s.hscale, s.vscale)
        end
    end
    function sc1:init()
        local cao, way = false, 15
        local co = 30
        local n = 25
        task.New(self, function()
            boss.violent(self)
            cao = true
            way = 40
            co = 40
            n = 30
        end)
        task.New(self, function()
            local A, v = 0
            do
                while true do
                    Newcharge_in(self.x, self.y, 200, 10, 10)
                    task.Wait(60)
                    v = Dist(self, player)
                    A = 180 + Angle(self, player)
                    v = v / (2 * Dist(self, player)) * 22
                    local V, _d_V = (v), (-v / 59)
                    for j = 1, 60 do
                        object.SetV(self, V, A, false)
                        task.Wait()
                        if cao then
                            for i = -1, 1 do
                                Create.bullet_changeangle(self.x, self.y, ball_mid, 2, 2, 180 + A + i * 25,
                                        { wait = 0, time = 120 - j * 2, r = -i })
                            end
                            PlaySound("tan00", 0.1, self.x / 256, true)
                        end
                        V = V + _d_V
                    end

                    task.Wait(30)
                    boss.cast(self, 60)
                    Newcharge_out(self.x, self.y, 200, 10, 10)
                    if Dist(self, player) < 100 then
                        do
                            local a, _d_a = (Angle(self, player)), (360 / n)
                            for _ = 1, n do
                                do
                                    local l, _d_l = (5), (5)
                                    local _v, _d_v = (1), (1)
                                    for _ = 1, 2 do
                                        Create.bullet_accel(self.x + cos(a) * l, self.y + sin(a) * l, grain_a, 6, 0.5, _v, a)
                                        l = l + _d_l
                                        _v = _v + _d_v
                                    end
                                end
                                a = a + _d_a
                            end
                        end
                    else
                        local x, y = 0, 0
                        task.New(self, function()
                            local a = Angle(self, player)
                            do
                                local _A, _d_A = (0), (15)
                                local _v, _d_v = (0.3), (3 / (co - 1))
                                for _ = 1, co do
                                    do
                                        local a1, _d_a1 = (_A), (-2 * _A)
                                        for _ = 1, 2 do
                                            Create.bullet_accel(self.x + x + cos(a1 + a) * 18, self.y + y + sin(a1 + a) * 18, square, 2, 0.5, _v, a1 + a)
                                            PlaySound("tan00", 0.1, 0, true)
                                            a1 = a1 + _d_a1
                                        end
                                    end
                                    task.Wait(120 / co)
                                    x, y = x + cos(a) * 120 / co, y + sin(a) * 120 / co
                                    _A = _A + _d_A
                                    _v = _v + _d_v
                                end
                            end
                        end)
                    end
                    do
                        local a1, a2 = Angle(player, self) + 50, Angle(player, self) - 50
                        local _V = 0.5
                        local b
                        for _ = 1, way do
                            do
                                local _v, _d_v = (_V), (0.8)
                                for _ = 1, 2 do
                                    b = Create.bullet_changeangle(self.x, self.y, ball_mid_c, 6, _v, a2 - 35, { wait = 0, time = 120, r = 1 })
                                    b._blend = "mul+add"
                                    b = Create.bullet_changeangle(self.x, self.y, ball_mid_c, 6, _v, a1 + 35, { wait = 0, time = 120, r = -1 })
                                    b._blend = "mul+add"
                                    _v = _v + _d_v
                                end
                            end
                            task.Wait(2)
                            a1 = a1 - 180 / (way - 1)
                            a2 = a2 + 180 / (way - 1)
                            _V = _V + 2.5 / (way - 1)
                        end
                    end
                    task.Wait(150 - 2 * way)
                end
            end
        end)
        task.New(self, function()
            task.New(self, function()
                while true do
                    while true do
                        if self.x > 192 or self.x < -192 then
                            break
                        end
                        task.Wait()
                    end
                    self.jump[1]()
                    self.x = -sign(self.x) * 192
                    self.jump[2]()
                    task.Wait()
                end
            end)
            while true do
                while true do
                    if self.y > 224 or self.y < -224 then
                        break
                    end
                    task.Wait()
                end
                self.jump[1]()
                self.y = -sign(self.y) * 224
                self.jump[2]()
                task.Wait()
            end
        end)
    end

    function sc2:before()
        lstg.var.timeslow = 1
        youmu = self
        task.MoveTo(-100, 100, 60, 2)
    end
    function sc2:frame()
        --CollisionCheck(GROUP.ENEMY_BULLET,GROUP.INDES)
        if self.own_gray then
            _object.set_color(self, "mul+rev", 255, 255, 255, 255)
        else
            _object.set_color(self, "", 255, 255, 255, 255)
        end
    end
    function sc2:init()
        task.New(self, function()
            boss.violent(self)
            task.Wait(60)
            local rot = 0
            while true do
                NewSimpleBullet(ball_big, 1, self.x, self.y, 3, rot, false, 0, false)
                NewSimpleBullet(ball_big, 1, self.x, self.y, 3, 180 - rot * 1.1, false, 0, false)
                PlaySound("tan00", 0.1, 0, true)
                task.Wait(2)
                rot = rot + 13
            end
        end)
        task.New(self, function()
            local d = 1
            do
                while true do
                    task.Wait(60)
                    object.Connect(self, New(class["bullet1-1"], self.x, self.y, 6, Angle(self, player), self), 0, true)
                    task.Wait(30)
                    task.MoveToPlayer(30, -150, 0, 25, 144,
                            20, 40, 10, 20, 2, 1)
                    for j = 1, 6 do
                        for a in sp.math.AngleIterator(0, 45 + j * 3) do
                            Create.bullet_dec_acc(self.x, self.y, grain_b, 4, 3, 7, a)
                        end
                        task.Wait(5)
                    end
                    d = -d
                    task.Wait(220)
                end
            end
        end)
    end
    function sc2:del()
        New(tasker, function()
            for _ = 1, 60 do
                if lstg.var.timeslow ~= 1 then
                    lstg.var.timeslow = 1
                end
                if player.own_gray then
                    player.own_gray = false
                end
                object.BulletIndesDo(function(unit)
                    if unit.own_gray then
                        unit.own_gray = nil
                    end
                end)
                object.EnemyNontjtDo(function(unit)
                    if unit.own_gray then
                        unit.own_gray = nil
                    end
                end)
                task.Wait()
            end
        end)
        _object.set_color(self, "", 255, 255, 255, 255)
    end
end--boss1
do
    boss.Define("2a", "雾雨魔理沙", "TH09_2", TH09_bg, { 0, 500 }, class["SCBG2"], "Marisa", 4)
    boss.Define("2b", "铃仙·优昙华院·因幡", "TH09_2", TH09_bg, { 0, 500 }, class["SCBG2"], "Reisen", 4)
    local name = "赤魔「重折光幻月」"
    local sc1 = boss.card.New(name, 1, 1, 70, 680)
    local sc2 = boss.card.New(name, 1, 1, 70, 680)
    boss.card.add({ { sc1, "2a" }, { sc2, "2b" } }, 4, name, 41)
    function sc1:before()
        task.MoveTo(-70, 60, 60, 2)
    end
    function sc1:init()
        local para = { v = 2, w = 7, wait = 150, offa = 0 }
        task.New(self, function()
            boss.violent(self)
            para = { v = 3, w = 20, wait = 50, offa = 46 }
        end)
        task.New(self, function()
            task.Wait()
            local d = 1
            do
                while true do
                    boss.cast(self, 140)
                    Newcharge_out(self.x, self.y, 230, 230, 30)
                    do
                        local rot, _d_rot = (0), (22 * d)
                        local l, _d_l = (50), (-50 / 6)
                        for _ = 1, para.w do
                            do
                                local a, _d_a = (30 + rot), (60)
                                for _ = 1, 6 do
                                    New(class["bullet1-2"], self.x + cos(a) * l, self.y + sin(a) * l, COLOR.RED, para.v, a + para.offa * d)
                                    a = a + _d_a
                                end
                            end
                            do
                                local a, _d_a = (rot), (60)
                                for _ = 1, 6 do
                                    New(class["bullet1-2"], self.x + cos(a) * l, self.y + sin(a) * l, COLOR.PURPLE, para.v, a + para.offa * d)
                                    a = a + _d_a
                                end
                            end
                            task.Wait(140 / para.w)
                            rot = rot + _d_rot
                            l = l + _d_l
                        end
                    end
                    task.MoveToPlayer(60, -170, 0, 70, 144, 32, 64, 16, 32, 2, 1)
                    d = -d
                    task.Wait(para.wait)
                end
            end
        end)
    end

    function sc2:before()
        lstg.var.eye = false
        task.MoveTo(70, 133, 60, 2)
    end
    function sc2:init()
        task.New(self, function()
            boss.violent(self)
            task.Wait(60)
            local s = 0
            while true do
                New(class["bullet1-4"], sin(s - 90) * 192, 224, -90, 1.4 + ran:Float(-0.08, 0.08), 6)
                New(class["bullet1-4"], sin(-s + 90) * 192, 224, -90, 1.4 + ran:Float(-0.08, 0.08), 6)
                s = s + 1
                task.Wait(3)
            end
        end)
        task.New(self, function()
            task.Wait(261 - 45)
            local d = 1
            do
                while true do
                    do
                        local rot, _d_rot = (ran:Float(0, 360)), (3 * d)
                        for _ = 1, 3 do
                            do
                                local a, _d_a = (rot), (360 / 135)
                                for _ = 1, 135 do
                                    New(class["bullet1-4"], self.x, self.y, a, 5 / 6, COLOR.RED)
                                    a = a + _d_a
                                end
                            end
                            task.Wait(15)
                            rot = rot + _d_rot
                        end
                    end
                    d = -d
                    Newcharge_in(self.x, self.y, 230, 15, 30)
                    object.Connect(self, New(_editor_class["TH08"]["RedScreen"], 0, 0), 0, true)
                    do
                        local x1, _d_x1 = (-140), (50 / 39)
                        local x2, _d_x2 = (140), (-50 / 39)
                        local a, _d_a = (1.6), (-0.6 / 39)
                        local t, _d_t = (11), (1)
                        for _ = 1, 40 do
                            object.Connect(self, New(_editor_class["TH08"]["RedEye"], x1, 50, t, a, "L"), 0, true)
                            object.Connect(self, New(_editor_class["TH08"]["RedEye"], x2, 50, t, a, "R"), 0, true)
                            task.Wait()
                            x1 = x1 + _d_x1
                            x2 = x2 + _d_x2
                            a = a + _d_a
                            t = t + _d_t
                        end
                    end
                    task.Wait(5)
                    task.MoveToPlayer(60, 0, 170, 70, 144, 32, 64, 16, 32, 2, WANDER_MODE.RANDOM)
                    task.Wait(200)
                end
            end
        end)
    end
    function sc2:del()
        lstg.var.eye = false
        self.eye = false
    end
end--boss2
do
    boss.Define("3a", "琪露诺", "TH09_2", TH09_bg, { 200, 500 }, class["SCBG3"], "Chiruno", 4)
    boss.Define("3b", "米斯蒂娅·萝蕾拉", "TH09_2", TH09_bg, { 400, 0 }, class["SCBG3"], "Lorelei", 4)
    local name = "冰蛾「针叶林中的天籁之音」"
    local sc1 = boss.card.New(name, 1, 1, 70, 680)
    local sc2 = boss.card.New(name, 1, 1, 70, 900)
    boss.card.add({ { sc1, "3a" }, { sc2, "3b" } }, 4, name, 42)

    function sc1:before()
        task.MoveTo(0, 120, 60, 2)
    end
    function sc1:frame()
        CollisionCheck(GROUP.ENEMY_BULLET, GROUP.ENEMY)
    end
    function sc1:init()
        local wait = 60
        local offa = 0
        local w = 10
        local mint = 6
        task.New(self, function()
            boss.violent(self)
            wait = 10
            offa = 30
            w = 45
            mint = 12
        end)
        task.New(self, function()
            task.Wait(120)
            local d = 1
            do
                local T, _d_T = (2), (1)
                while true do
                    Newcharge_out(self.x, self.y, 20, 20, 200)
                    do
                        local a, _d_a = (Angle(self, player)), (12)
                        for _ = 1, 30 do
                            local t = min(T, mint)
                            do
                                local l, _d_l = (50), (-100 / (t - 1))
                                for _ = 1, t do
                                    Create.bullet_decel(self.x + cos(a) * l, self.y + sin(a) * l, ball_mid, 6, 4, 1, a + offa)
                                    l = l + _d_l
                                end
                            end
                            a = a + _d_a
                        end
                    end
                    offa = -offa
                    do
                        local a, _d_a = (ran:Float(0, 360)), (360 / w)
                        for _ = 1, w do
                            New(class["Ice"], self.x, self.y, 2.5, a)
                            a = a + _d_a
                        end
                    end
                    task.Wait(wait)
                    task.MoveToPlayer(100, -100, 100, 100, 144,
                            20, 40, 10, 20, 2, 1)
                    d = -d
                    task.Wait(wait)
                    T = T + _d_T
                end
            end
        end)
    end

    function sc2:before()
        task.MoveTo(0, 0, 60, 2)
    end
    function sc2:init()
        local wait = 60
        task.New(self, function()
            boss.violent(self)
            wait = 30
            task.Wait(60)
            while true do
                for _, s in ipairs(self._servants) do
                    NewSimpleBullet(grain_a, 8, s.x, s.y, 2, s.rot)
                    NewSimpleBullet(grain_a, 8, s.x, s.y, 2, s.rot + 180)
                end
                task.Wait(7)
            end
        end)
        task.New(self, function()
            Newcharge_in(self.x, self.y, 200, 20, 200)
            task.Wait(60)
            boss.cast(self, 120 * 60)
            Newcharge_out(self.x, self.y, 200, 20, 200)
            local t, s, bb, i = 8, 0.6, 180, 18
            do
                local l, _d_l = (18), (18)
                local I, _d_I = (i), (-i / (t - 1))
                for _ = 1, t do
                    object.Connect(self, New(class["bullet1-5"], self.x, self.y, l, s, -90, bb, I), 0, true)
                    l = l + _d_l
                    I = I + _d_I
                end
            end
            do
                while true do
                    Create.bullet_accel(self.x, self.y, ball_huge, 6, 0.5, 4, Angle(self, player))
                    task.Wait(wait)
                end
            end
        end)
    end
end--boss3
do
    boss.Define("4a", "十六夜咲夜", "TH09_2", TH09_bg, { 300, 500 }, class["SCBG4"], "Sakuya", 4)
    boss.Define("4b", "因幡帝", "TH09_2", TH09_bg, { -200, 500 }, class["SCBG4"], "Tewi", 4)
    local name = "假象「Lying World」"
    local sc1 = boss.card.New(name, 1, 1, 80, 700)
    local sc2 = boss.card.New(name, 1, 1, 80, 400)
    boss.card.add({ { sc1, "4a" }, { sc2, "4b" } }, 4, name, 43)
    function sc1:before()
        sakuya = self
        self.bulletlist = {}
        task.MoveTo(0, 0, 60, 2)
    end
    function sc1:init()
        self.nopause = true
        local cao = false
        local way = 20
        task.New(self, function()
            boss.violent(self)
            cao = true
            way = 30
            task.Wait(60)
            local rot = 0
            while true do
                NewSimpleBullet(ball_mid, 5, self.x, self.y, 2, rot)
                NewSimpleBullet(ball_mid, 5, self.x, self.y, 2, rot + 180)
                rot = rot + 11
                task.Wait(7)
            end
        end)
        task.New(self, function()
            local d = 1
            local B
            do
                while true do
                    do
                        local a, _d_a = (Angle(self, player)), (360 / way)
                        for _ = 1, way do
                            table.insert(self.bulletlist,
                                    NewSimpleBullet(knife, 6, self.x + cos(a + 70 * d) * 50, self.y + sin(a + 70 * d) * 50, 0.6, a))
                            a = a + _d_a
                        end
                    end
                    task.MoveToPlayer(60, -150, 150, -20, 120, 40, 60, 20, 40, 2, 1)
                    Newcharge_in(self.x, self.y, 30, 30, 200)
                    task.Wait(60)
                    Newcharge_out(self.x, self.y, 30, 30, 200)
                    task.New(self, function()
                        local li = 15
                        local x, y
                        for i = 1, 60 do
                            AddSuperPause(1)
                            for _, b in ipairs(self.bulletlist) do
                                if IsValid(b) then
                                    x, y = b.x + cos(b.rot) * i * li, b.y + sin(b.rot) * i * li
                                    if x > -250 and x < 250 and y > -250 and y < 250 then
                                        B = NewSimpleBullet(knife, 16, x, y, 8, b.rot, false, 0, false)
                                        if not cao then
                                            B.timer = 11
                                            B.nopause = true
                                            task.New(B, function()
                                                local self = task.GetSelf()
                                                task.Wait()
                                                self.nopause = nil
                                            end)
                                        end
                                    end
                                    x, y = b.x - cos(b.rot) * i * li, b.y - sin(b.rot) * i * li
                                    if x > -250 and x < 250 and y > -250 and y < 250 then
                                        B = NewSimpleBullet(knife, 16, x, y, 8, b.rot, false, 0, false)
                                        if not cao then
                                            B.timer = 11
                                            B.nopause = true
                                            task.New(B, function()
                                                local self = task.GetSelf()
                                                task.Wait()
                                                self.nopause = nil
                                            end)
                                        end
                                    end
                                end
                            end
                            task.Wait()
                        end
                    end)
                    PlaySound("kira00", 1, self.x, false)
                    task.Wait(90)
                    d = -d
                    task.Wait(120)
                end
            end
        end)
    end
    function sc1:render()
        if GetCurrentSuperPause() > 0 then
            SetImageState("white", "", 200, 41, 36, 33)
            RenderRect("white", -192, 192, 224, -224)
        end
    end
    function sc1:frame()
        if GetCurrentSuperPause() > 0 then
            self.timer = self.timer - 1
        end
        for i = #self.bulletlist, 1, -1 do
            if not IsValid(self.bulletlist[i]) then
                table.remove(self.bulletlist, i)
            end
        end
    end

    function sc2:before()
        task.MoveTo(0, 100, 60, 2)
    end
    function sc2:frame()
        if GetCurrentSuperPause() > 0 then
            self.timer = self.timer - 1
        end
    end
    function sc2:init()
        self.nopause = true
        task.New(self, function()
            boss.violent(self)
            task.Wait(60)
            while true do
                for i = 1, 60 do
                    Create.bullet_accel(self.x, self.y, ball_mid, 10, 0.5, ({ 2, 3, 1 })[i % 3 + 1], i * 6)
                end
                PlaySound("tan00")
                task.Wait(80)
            end
        end)
        task.New(self, function()
            do
                while true do
                    if IsValid(sakuya) then
                        do
                            local s, _d_s = (180), (90)
                            for _ = 1, 4 do
                                while GetCurrentSuperPause() > 0 do
                                    task.Wait()
                                end
                                if not IsValid(sakuya) then
                                    break
                                end
                                do
                                    local a, _d_a = (Angle(self, sakuya) - 50), (100 / 13)
                                    local s, _d_s = (90), (180 / 13)
                                    for _ = 1, 14 do
                                        New(class["bullet2-1"], self.x, self.y, 1.6 + sin(s % 180), a)
                                        a = a + _d_a
                                        s = s + _d_s
                                    end
                                end
                                task.MoveTo(sakuya.x + cos(s) * 100, sakuya.y + sin(s) * 100, 20, 2)
                                s = s + _d_s
                            end
                        end
                    else
                        do
                            for _ = 1, 4 do
                                do
                                    for _ = 1, 25 do
                                        New(class["bullet2-1"], self.x, self.y, ran:Float(1, 3), ran:Float(-45, 45) + Angle(self, player))
                                    end
                                end
                                task.MoveToPlayer(20, -120, 120, 0, 144, 70, 100, 50, 60, 2, WANDER_MODE.RANDOM)
                            end
                        end
                    end
                    task.Wait(60)
                end
            end
        end)
    end
end--boss4
do
    boss.Define("5a", "露娜萨·普莉兹姆利巴", "TH09_2", TH09_bg, { -100, 500 }, class["SCBG5"], "Lunasa", 4)
    boss.Define("5b", "梅露兰·普莉兹姆利巴", "TH09_2", TH09_bg, { 100, 500 }, class["SCBG5"], "Merlin", 4)
    boss.Define("5c", "莉莉卡·普莉兹姆利巴", "TH09_2", TH09_bg, { 0, 500 }, class["SCBG5"], "Lyrica", 4)
    local name = "「咲夜大人传授的技法」"
    local sc1 = boss.card.New(name, 1, 1, 80, 1100)
    local sc2 = boss.card.New(name, 1, 1, 80, 1100)
    local sc3 = boss.card.New(name, 1, 1, 80, 1100)
    boss.card.add({ { sc1, "5a" }, { sc2, "5b" }, { sc3, "5c" } }, 4, name, 44)

    local function Round(self, d, a, event)
        local s = 90
        local S = 0
        local v = 4
        for _ = 1, 320 do
            a = a + (6 - sin(max(0, s)) * 6) * d
            self.x, self.y = cos(a) * (150 - 120 * sin(min(90, S))), sin(a) * (150 - 120 * sin(min(90, S))) + 30
            event(v, a)
            task.Wait()
            s = s - 90 / 200
            S = S + 90 / 400
            v = v - 3.9 / 319
        end
    end

    function sc1:before()
        task.MoveTo(cos(90) * 150, sin(90) * 150 + 30, 60, 2)
    end
    function sc1:init()
        boss.card.UnlockOD(self, 15)
        task.New(self, function()
            local a = 90
            local d = 1

            while true do
                for i = 1, 40 do
                    for v = 0, 2 do
                        New(class["bullet2-3"], 0, 30, i * 9, 0.6 - v * 0.2)
                    end
                end
                Newcharge_in(self.x, self.y, 240, 230, 250)
                task.Wait(60)
                task.New(self, function()
                    task.Wait(260)
                    Newcharge_in(0, 30, 240, 230, 250)
                end)
                Round(self, d, a, function(v, A)
                    if self.timer % 2 == 0 then
                        New(class["bullet2-2"], self.x, self.y, v, A + 180)
                    end
                end)
                Newcharge_out(self.x, self.y, 240, 230, 250)
                self.t = true
                task.Wait()
                self.t = false
                task.Wait(59)
                task.MoveTo(cos(a) * 150, sin(a) * 150 + 30, 60, 2)
                d = -d
            end
        end)
    end
    sc1.frame = boss.card.PublicHP
    function sc1:render()
        Render("ins1", sp.math.EllipsePoint(self.x, self.y, 50, 15, 45, stage.current_stage.timer * 3))
    end

    function sc2:before()
        task.MoveTo(cos(210) * 150, sin(210) * 150 + 30, 60, 2)
    end
    function sc2:init()
        task.New(self, function()
            local a = 210
            local d = 1
            while true do
                Newcharge_in(self.x, self.y, 240, 230, 250)
                task.Wait(60)
                Round(self, d, a, function(v, A)
                    if self.timer % 2 == 0 then
                        New(class["bullet2-2"], self.x, self.y, v, A + 180)
                    end
                end)
                misc.ShakeScreen(40, 2)
                Newcharge_out(self.x, self.y, 240, 230, 250)
                self.t = true
                task.Wait()
                self.t = false
                task.Wait(59)
                task.MoveTo(cos(a) * 150, sin(a) * 150 + 30, 60, 2)
                d = -d
            end
        end)
    end
    sc2.frame = boss.card.PublicHP
    function sc2:render()
        Render("ins2", sp.math.EllipsePoint(self.x, self.y, 50, 15, 0, stage.current_stage.timer * 2.5))
    end

    function sc3:before()
        task.MoveTo(cos(330) * 150, sin(330) * 150 + 30, 60, 2)
    end
    function sc3:init()
        task.New(self, function()
            local a = 330
            local d = 1
            while true do
                Newcharge_in(self.x, self.y, 240, 230, 250)
                task.Wait(60)
                Round(self, d, a, function(v, A)
                    if self.timer % 2 == 0 then
                        New(class["bullet2-2"], self.x, self.y, v, A + 180)
                    end
                end)
                Newcharge_out(self.x, self.y, 240, 230, 250)
                self.t = true
                task.Wait()
                self.t = false
                task.Wait(59)
                task.MoveTo(cos(a) * 150, sin(a) * 150 + 30, 60, 2)
                d = -d
            end
        end)
    end
    sc3.frame = boss.card.PublicHP
    function sc3:render()
        Render("ins3" .. int(stage.current_stage.timer / 4) % 3 + 1,
                sp.math.EllipsePoint(self.x, self.y, 50, 15, -45, stage.current_stage.timer * 2))
    end

    name = "「我和咲夜有什么关系-Overdrive」"
    local od1, od2, od3 = sp:CopyTable(sc1), sp:CopyTable(sc2), sp:CopyTable(sc3)
    od1.name, od2.name, od3.name = name, name, name
    boss.card.add({ { od1, "5a" }, { od2, "5b" }, { od3, "5c" } }, 4, name, 45, 15)
    function od1:init()

        task.New(self, function()
            local b = Class(bullet, {
                init = function(self, _x, _y, a, v)
                    bullet.init(self, music, 8, true, true)
                    self.x, self.y = _x, _y
                    self.rot = -90
                    task.New(self, function()
                        local t = 1
                        local A = a + Angle(_x, _y, player)
                        local l = 0
                        while true do
                            if t == 1 then
                                local da = (Angle(_x, _y, player) - A - a) % 360
                                if da > 180 then
                                    da = da - 360
                                end
                                A = A + da * 0.1
                            else
                                bullet.ChangeImage(self, music, 10)
                            end
                            self.x = cos(A) * l
                            self.y = 30 + sin(A) * l
                            if _boss.t then
                                t = 0
                                task.New(self, function()
                                    for i = 1, 60 do
                                        l = l - v * sin(90 - i * 1.5)
                                        v = v + 1 / 60
                                        task.Wait()
                                    end
                                end)
                            end
                            task.Wait()
                            l = l + v
                        end
                    end)
                end
            }, true)
            local a = 90
            local d = 1
            while true do
                for z = -8, 8 do
                    for v = 0, 10 do
                        New(b, 0, 30, z * 9, 1.2 - v * 0.1)
                    end
                end
                Newcharge_in(self.x, self.y, 240, 230, 250)
                task.Wait(60)
                task.New(self, function()
                    task.Wait(260)
                    Newcharge_in(0, 30, 240, 230, 250)
                end)
                Round(self, d, a, function(v, A)
                    if self.timer % 2 == 0 then
                        New(class["bullet2-2"], self.x, self.y, v, A + 180)
                    end
                    if self.timer % 3 == 0 then
                        New(class["bullet2-2"], self.x, self.y, v, a)
                    end
                end)
                Newcharge_out(self.x, self.y, 240, 230, 250)
                self.t = true
                task.Wait()
                self.t = false
                task.Wait(59)
                task.MoveTo(cos(a) * 150, sin(a) * 150 + 30, 60, 2)
                d = -d
            end
        end)
    end
    function od2:init()
        task.New(self, function()
            local a = 210
            local d = 1
            while true do
                Newcharge_in(self.x, self.y, 240, 230, 250)
                task.Wait(60)
                Round(self, d, a, function(v, A)
                    if self.timer % 2 == 0 then
                        New(class["bullet2-2"], self.x, self.y, v, A + 180)
                    end
                    if self.timer % 3 == 0 then
                        New(class["bullet2-2"], self.x, self.y, v, a)
                    end
                end)
                misc.ShakeScreen(40, 2)
                Newcharge_out(self.x, self.y, 240, 230, 250)
                self.t = true
                task.Wait()
                self.t = false
                task.Wait(59)
                task.MoveTo(cos(a) * 150, sin(a) * 150 + 30, 60, 2)
                d = -d
            end
        end)
    end
    function od3:init()
        task.New(self, function()
            local a = 330
            local d = 1
            while true do
                Newcharge_in(self.x, self.y, 240, 230, 250)
                task.Wait(60)
                Round(self, d, a, function(v, A)
                    if self.timer % 2 == 0 then
                        New(class["bullet2-2"], self.x, self.y, v, A + 180)
                    end
                    if self.timer % 3 == 0 then
                        New(class["bullet2-2"], self.x, self.y, v, a)
                    end
                end)
                Newcharge_out(self.x, self.y, 240, 230, 250)
                self.t = true
                task.Wait()
                self.t = false
                task.Wait(59)
                task.MoveTo(cos(a) * 150, sin(a) * 150 + 30, 60, 2)
                d = -d
            end
        end)
    end
end--boss5
do
    boss.Define("6a", "射命丸文", "TH09_5", TH09_bg, { 100, 400 }, class["SCBG6"], "Aya", 4)
    boss.Define("6b", "梅蒂欣·梅兰可莉", "TH09_5", TH09_bg, { 100, 400 }, class["SCBG6"], "Medicine", 4)
    local name = "毒风「夜中飘毒香」"
    local sc1 = boss.card.New(name, 1, 1, 80, 700)
    local sc2 = boss.card.New(name, 1, 1, 80, 700)
    boss.card.add({ { sc1, "6a" }, { sc2, "6b" } }, 4, name, 46)

    function sc1:before()
        lstg.tmpvar.bg.change = true
        task.MoveTo(100, 50, 60, 2)
    end
    function sc1:init()
        local cao
        local w = 20
        local b
        task.New(self, function()
            boss.violent(self)
            cao = true
            w = 50
            while true do
                for _ = 1, abs(self.dx) * 10 do
                    b = Create.bullet_accel(self.x, self.y, grain_a, 2, 0.2, ran:Float(1, 3), ran:Float(0, 360), false, false)
                    b.timer = ran:Int(1, 11)
                    PlaySound("tan00")
                end
                task.Wait()
            end
        end)
        task.New(self, function()
            task.Wait(60)
            local d = 1
            while true do
                Newcharge_in(self.x, self.y, 220, 220, 220)
                task.Wait(60)
                PlaySound("boon01", 1, 0, false)
                boss.cast(self, 60)
                local a, x, y = -90 - 45 * d, -50 * d, -45
                for j = 1, 20 do
                    New(class["bullet5-3"], self.x + x, self.y + y, 6, a)
                    task.Wait()
                    a = a + 90 * d / 19
                    x = x + 100 / 19 * d
                    y = y + 45 / 19
                    if cao then
                        for i = 1, 6 do
                            Create.bullet_accel(self.x + x, self.y + y, butterfly, 2, 0.5, 3 + LineNum(j * 48), a + i * 60)
                        end
                    end
                end
                local s = 0
                a = 90 - 45 * d
                local A
                for _ = 1, w do
                    A = a
                    for _ = 1, 2 do
                        NewSimpleBullet(butterfly, COLOR.PURPLE, self.x + 30 * d, self.y + 30, 1 + 2 * sin(s), A)
                        A = A + 180
                    end
                    PlaySound("tan00", 0.1, 0, false)
                    s = s + 180 / (w - 1)
                    a = a + 180 / (w - 1)
                end
                task.Wait(40)
                task.New(self, function()
                    task.Wait(30)
                    if self.dx > 0 then
                        d = 1
                    else
                        d = -1
                    end
                end)
                task.MoveToPlayer(60, -100, 100, 80, 144, 20, 40, 8, 16, 2, WANDER_MODE.RANDOM)
                task.Wait(60)
            end
        end)
    end
    function sc1:del()
        lstg.var.timeslow = 1
    end

    function sc2:before()
        lstg.tmpvar.bg.change = true
        self.poison = {}
        task.MoveTo(-100, 60, 60, 2)
        self.hspeed, self.lspeed = player.hspeed, player.lspeed
    end
    function sc2:frame()
        if self.is_combat then
            CollisionCheck(GROUP.ENEMY_BULLET, GROUP.GHOST)
            local flag = false
            for _, p in ipairs(self.poison) do
                if IsValid(p) then
                    flag = (Dist(p, player) < 70)
                    if flag then
                        break
                    end
                end
            end
            if flag then
                player.hspeed = self.hspeed / 2
                player.lspeed = self.lspeed / 2
            else
                player.hspeed = self.hspeed
                player.lspeed = self.lspeed
            end
        end
    end
    function sc2:init()
        local list = { i = 0 }
        local w = 4
        local v = 1.3
        local wait = 60
        task.New(self, function()
            boss.violent(self)
            w = 6
            v = 3.5
            wait = 20
            task.Wait(60)
            while true do
                for j = 1, 3 do
                    for i = 1, 60 do
                        NewSimpleBullet(grain_a, 15, self.x, self.y, j + LineNum(i * 6 * j * 2) * 0.5, i * 6)
                    end
                end
                PlaySound("tan00")
                task.Wait(120)
            end
        end)
        task.New(self, function()
            local col = { COLOR.GREEN, COLOR.DEEP_GRAY, 4, 2 }
            local t, c, d
            while true do
                t = ran:Int(8, 10)
                c = ran:Int(1, 4)
                d = (w - 1) / 2
                for i = -d, d do
                    New(class["bullet5-1"], self.x, self.y, v, i * 180 / w + Angle(self, player), t, ran:Sign(), col[c], self, list, self.poison)
                end
                task.Wait(wait)
            end
        end)
        task.New(self, function()
            task.Wait(150)
            while true do
                task.MoveToPlayer(60, -100, 50, -20, 120, 20, 40, 48, 50, 2, 1)
                task.Wait(150)
            end
        end)
    end
    function sc2:del()
        player.hspeed = self.hspeed
        player.lspeed = self.lspeed
    end
end--boss6
do
    boss.Define("7a", "小野塚小町", "TH09_5", TH09_bg, { 500, -500 }, class["SCBG9"], "Komachi", 4)
    boss.Define("7b", "风见幽香", "TH09_5", TH09_bg, { -500, -500 }, class["SCBG9"], "Yuka", 4)
    local name = "死花「不朽的曼珠沙华」"
    local sc1 = boss.card.New(name, 1, 1, 80, 800)
    local sc2 = boss.card.New(name, 1, 1, 80, 800)
    boss.card.add({ { sc1, "7a" }, { sc2, "7b" } }, 4, name, 47)

    function sc1:before()
        lstg.tmpvar.bg.change = true
        task.MoveTo(100, 120, 60, 2)
    end
    function sc1:init()
        local w = 10
        local wait = 200
        local Tb = 5
        task.New(self, function()
            boss.violent(self)
            w = 13
            wait = 100
            Tb = 3
            task.Wait(60)
            local d = 1
            while true do
                for j = 1, 9 do
                    for i = 1, 30 do
                        NewSimpleBullet(money, 15, self.x, self.y, 1 + j / 4, i * 12 + j * 2 * d, true)
                    end
                end
                task.Wait(230)
                d = -d
                PlaySound("kira00")
            end
        end)
        task.New(self, function()
            local d = 1
            do
                while true do
                    task.New(self, function()
                        local x, y = self.x, self.y
                        local A = Angle(self, player)
                        for T = 1, 120 do
                            for i = 1, w do
                                New(class["bullet5-6"], x + cos(i * 360 / w + A + 18) * T * 6, y + sin(i * 360 / w + A + 360 / w / 2) * T * 6,
                                        1.2, i * 360 / w + A + 360 / w / 2 + T * 12, T % Tb, d)
                            end
                            task.Wait()
                        end
                    end)
                    d = -d
                    task.Wait(60)
                    if d == 1 then
                        task.MoveToPlayer(60, -30, -90, 70, 144, 20, 40, 12, 24, 2, 1)
                    else
                        task.Wait(60)
                    end
                    task.Wait(wait)
                end
            end
        end)
    end

    function sc2:before()
        lstg.tmpvar.bg.change = true
        task.MoveTo(-100, 120, 60, 2)
    end
    function sc2:init()
        local len = 6
        local wait = 60
        local c = 3
        task.New(self, function()
            boss.violent(self)
            len = 7
            wait = 0
            c = 3
        end)
        task.New(self, function()
            local d = 1
            task.Wait(30)
            local i = 90
            do
                while true do
                    boss.cast(self, 100)
                    task.Wait(30)
                    New(class["bullet5-4"], self.x, self.y, self.x + ran:Float(-50, 50), self.y + ran:Float(-50, 50), d * 0.4, len, c)
                    task.Wait(wait)
                    d = -d
                    if d == -1 then
                        task.MoveToPlayer(60, -30, -90, 70, 144, 20, 40, 12, 24, 2, 1)
                    else
                        task.Wait(60)
                    end
                    i = max(30, i - 8)
                    task.Wait(i)
                end
            end
        end)
    end

end--boss7
do
    boss.Define("8a", "四季映姬·亚玛萨那度", "TH09_5", TH09_bg, { 500, -500 }, class["SCBG10"], "Shikieiki", 4)
    boss.Define("8b", "风见幽香", "TH09_5", TH09_bg, { 500, -500 }, class["SCBG10"], "Yuka", 4)
    local name = "审花「隐世涅槃之花」"
    local sc1 = boss.card.New(name, 1, 1, 80, 880)
    local sc2 = boss.card.New(name, 1, 1, 80, 880)
    boss.card.add({ { sc1, "8a" }, { sc2, "8b" } }, 4, name, 48)

    function sc1:before()
        lstg.tmpvar.bg.change = true
        task.MoveTo(-70, 100, 60, 2)
    end
    function sc1:init()
        local wait = 80
        local c = 18
        task.New(self, function()
            boss.violent(self)
            wait = 30
            c = 36
        end)
        task.New(self, function()
            local a
            do
                while true do
                    a = -45 + Angle(self, player)
                    for _ = 1, 8 do
                        New(class["bullet5-9"], self.x, self.y, 2, a, 1, c)
                        a = a + 90 / 7
                    end
                    task.Wait(wait)
                    a = Angle(self, player)
                    for _ = 1, 10 do
                        New(class["bullet5-9"], self.x, self.y, 1.5, a, 1, c)
                        a = a + 36
                    end
                    task.Wait(wait)
                    a = -60 + 90
                    for _ = 1, 7 do
                        New(class["bullet5-9"], self.x, self.y, 4, a, 1, c)
                        a = a + 120 / 6
                    end
                    task.MoveToPlayer(60, -150, 150, 70, 110,
                            20, 40, 12, 24, 2, 1)
                    task.Wait(wait + 40)
                end
            end
        end)
    end

    function sc2:before()
        lstg.tmpvar.bg.change = true
        task.MoveTo(70, 144, 60, 2)
    end
    function sc2:init()
        local wait = 60
        local c = 3
        task.New(self, function()
            boss.violent(self)
            wait = 0
            c = 5
        end)
        task.New(self, function()
            local d = 1
            local col = { COLOR.RED, COLOR.BLUE, COLOR.PURPLE }
            local rgb = { { 250, 128, 114 }, { 135, 206, 235 }, { 221, 160, 221 } }
            for T = 0, _infinite do
                local t = T % 3 + 1
                Newcharge_in(self.x, self.y, 189, 252, 201)
                task.Wait(60)
                local rot, _d_rot, v, _d_v
                do
                    local a, _d_a = (ran:Float(0, 360)), (72)
                    for _ = 1, 5 do
                        rot, _d_rot = (a), (36 / 8)
                        v, _d_v = (5), (2 / 8)
                        for _ = 1, 8 do
                            New(class["bullet5-7"], self.x, self.y, rgb[t], v, rot)
                            rot = rot + _d_rot
                            v = v + _d_v
                        end
                        rot, _d_rot = (a + 36), (36 / 8)
                        v, _d_v = (7), (-2 / 8)
                        for _ = 1, 8 do
                            New(class["bullet5-7"], self.x, self.y, rgb[t], v, rot)
                            rot = rot + _d_rot
                            v = v + _d_v
                        end
                        rot, _d_rot = (a), (36 / c)
                        v, _d_v = (5), (2 / c)
                        for _ = 1, c do
                            New(class["bullet5-10"], self.x, self.y, v, rot, col[t], d, rgb[t])
                            rot = rot + _d_rot
                            v = v + _d_v
                        end
                        rot, _d_rot = (a + 36), (36 / c)
                        v, _d_v = (7), (-2 / c)
                        for _ = 1, c do
                            New(class["bullet5-10"], self.x, self.y, v, rot, col[t], d, rgb[t])
                            rot = rot + _d_rot
                            v = v + _d_v
                        end
                        a = a + _d_a
                    end
                end
                d = -d
                task.Wait(wait)
                task.MoveToPlayer(60, -150, 150, 70, 110, 20, 40, 12, 24, 2, 1)
                task.Wait(40)
            end
        end)
    end

end--boss8
