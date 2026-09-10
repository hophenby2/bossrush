local function FullScreen()
    if ext.sc_pr then
        ToBigScreen(60)
    end
end
local class = {}
_editor_class["TH125"] = class
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
    class["SCBG1"] = Class(_SC_BG)
    class["SCBG1"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th11_7", false, 0, 0, 0, 0, 0, -0.5, "mul+add", 2, 2,
                nil,
                function(unit)
                    unit.r = 155 + sin(unit.timer / 3) * 100
                end)
        _SC_BG.AddLayer(self, "th11_8", true, 0, 0, 0, -1, 2,
                nil, nil, nil, nil, nil,
                function(unit)
                    unit.a = 155 + sin(unit.timer / 2) * 100
                end)
        _SC_BG.AddLayer(self, "th09_5_0", false, 0, 0, 0, 0, 0, 0.5, "mul+add", 2.2, 2.2)
        _SC_BG.AddLayer(self, "th08_15_n", false, 0, 0, 0,
                0, 0, 0, "", 1, 1,
                nil,
                function(unit)
                    unit.a = cos(unit.timer / 2) * 100 + 155
                end)


    end
    class["SCBG2"] = Class(_SC_BG)
    class["SCBG2"].init = function(self)
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th12_5_0", true, 0, 0, 0, 0, 0, 0.3, "mul+rev", 3, 3)
        b.Beforeframe = function(unit)
            unit.a = 100 + sin(unit.timer / 5) * 20
        end
        b = _SC_BG.AddLayer(self, "th12_5_0", true, 0, 0, 0, 0, 0, -0.3, "mul+rev", 3, 3)
        b.Beforeframe = function(unit)
            unit.a = 100 + sin(unit.timer / 5) * 20
        end
        b = _SC_BG.AddLayer(self, "th12_5_1", true, 0, 0, 0, 0.5, 0.5)
        b.Beforeframe = function(unit)
            unit.a = 100 + sin(unit.timer / 4) * 60
        end
        b = _SC_BG.AddLayer(self, "th12_5_3_n")
        b.Beforeframe = function(unit)
            unit.a = 150 + sin(unit.timer / 3) * 100
        end
        b = _SC_BG.AddLayer(self, "th12_5_2_n")


    end
    class["SCBG3"] = Class(_SC_BG)
    class["SCBG3"].init = function(self)
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th10_9", true, 0, 0, 0, 0, 0.8, 0, "mul+add")
        b.a = 180
        b.Beforeframe = function(unit)
            unit.r = 150 + cos(unit.timer * 0.4) * 100
            unit.g = 155 + sin(unit.timer * 0.4) * 100
            unit.b = 155 + cos(unit.timer * 0.4) * 100
        end
        _SC_BG.AddLayer(self, "th08_7", false, 0, 0, 0, 0, 0, -0.3, "", 3, 3)
        b = _SC_BG.AddLayer(self, "th08_9", true, 0, 0, 0, 0, 1.5, 0, "mul+add")
        b.a = 160
        b = _SC_BG.AddLayer(self, "th10_12_n")
        b.hscale, b.vscale = 0.5, 0.5
        b.r, b.g, b.b = 150, 150, 150
    end
    class["SCBG4"] = Class(_SC_BG)
    class["SCBG4"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th10_7", true, 0, 0, 0, -0.15, 0.75, 0, "", 1, 1,
                function(unit)
                    unit.a = 150
                end,
                function(unit)
                    unit.r = 150 + cos(unit.timer * 0.4) * 100
                    unit.g = 155 + sin(unit.timer * 0.4) * 100
                    unit.b = 155 + cos(unit.timer * 0.4) * 100
                end)
        _SC_BG.AddLayer(self, "th10_6_n", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
    end
end--scbg

local Rose
do
    class["bullet1-1"] = Class(bullet, {
        init = function(self, master, a, offr)
            bullet.init(self, ellipse, 14, false, true)
            self._blend = "mul+add"
            self.master = master
            self.rot = a
            self.bound = false
            offr = offr or 1
            task.New(self, function()
                while true do
                    if not IsValid(self.master) or self.master.boom then
                        break
                    end
                    self.omiga = self.master.omiga
                    self.x = self.master.x + cos(self.rot) * self.master.r * offr
                    self.y = self.master.y + sin(self.rot) * self.master.r * offr
                    task.Wait()
                end
                object.Del(self)
            end)
        end
    })
    class["bullet1-1star"] = Class(bullet, {
        init = function(self, master, rx, a, r, o)
            bullet.init(self, ball_light, 12, false, false)
            self.hscale = 0.4
            self.vscale = 0.4
            self.a = 0.28 * self.a
            self.b = self.a
            self.master = master
            self.angle = a
            self.adda = o
            self.r = 0
            self.rx = rx
            self.x = self.master.x + rx * cos(a) * self.r - sin(a) * self.r
            self.y = self.master.y + cos(a) * self.r + rx * sin(a) * self.r
            self.bound = false
            task.New(self, function()
                for i = 1, 60 do
                    self.r = r * sin(i * 1.5)
                    task.Wait()
                end
                task.Wait(30)
                self.colli = false
                for i = 1, 60 do
                    self._a = 255 - 255 * sin(i * 1.5)
                    task.Wait()
                end
                task.Wait(30)
                self.colli = true
                local b
                for i = 89, 0, -1 do
                    self._a = 255 * sin(i)
                    if i % 10 == 0 then
                        b = NewSimpleBullet(ball_light, 6, self.x, self.y, Dist(self.master, self) / self.r * 4, self.rot)
                        b.hscale, b.vscale, b.a, b.b = 0.5, 0.5, 0.35 * b.a, 0.35 * b.b
                        PlaySound("tan00")
                    end
                    task.Wait()
                end
                object.RawDel(self)
            end)
        end,
        frame = function(self)
            if not IsValid(self.master) then
                object.Del(self)
                return
            end
            bullet.frame(self)
            self.angle = self.angle + self.adda
            self.x = self.master.x + self.rx * cos(self.angle) * self.r - sin(self.angle) * self.r
            self.y = self.master.y + cos(self.angle) * self.r + self.rx * sin(self.angle) * self.r
            self.rot = Angle(self.master, self)
        end
    })
    class["bullet0-1pendulum"] = Class(bullet, {
        init = function(self, style, index, x, y, radius, range, speed, cr, ca, co)
            bullet.init(self, style, index, false, false)
            self.x, self.y = x, y
            self.r = 0
            self.cr = 0
            self.bound = false
            task.New(self, function()
                local angle = -90
                local c = 90
                while true do
                    self.x = x + cos(angle) * self.r + cos(ca) * self.cr
                    self.y = y + sin(angle) * self.r + sin(ca) * self.cr
                    self.rot = angle
                    ca = ca + co
                    c = c + speed
                    angle = -90 + sin(c) * range
                    task.Wait()
                end
            end)
            task.New(self, function()
                for i = 1, 60 do
                    self.r = radius * sin(i * 1.5)
                    task.Wait()
                end
                for i = 1, 180 do
                    self.cr = cr * sin(i * 0.5)
                    task.Wait()
                end
            end)
        end,
        frame = function(self)
            bullet.frame(self)
            object.smear_add(self, 90)
            object.smear_frame(self, 10)
        end,
        render = function(self)
            object.smear_render(self, "mul+add", { 200, 200, 200 })
            bullet.render(self)
        end
    })
    LoadImageGroupFromFile("Rose", "mod\\GAME\\Rose.png", nil, 4, 1, 18, 18)
    Rose = { index = { nil, 1, nil, nil, nil, 2, nil, nil, nil, 3, nil, 4 } }
    function Rose:GetIndex(index)
        self.rose_index = Rose.index[index] or 1
    end
    function Rose:BulletToRose()
        if self.img == "Rose" .. self.rose_index then
            return
        end
        task.New(self, function()
            PlaySound("kira00")
            self.img = "Rose" .. self.rose_index
            self.hscale, self.vscale = 0.25, 0.25
            self.a, self.b = 4.5, 4.5
            for i = 1, 10 do
                self.hscale = 0.25 + 0.75 * i / 10
                self.vscale = self.hscale
                self.a = self.hscale * 18
                self.b = self.a
                task.Wait()
            end
        end)
    end
    function Rose:RoseToBullet()
        if self.img ~= "Rose" .. self.rose_index then
            return
        end
        task.New(self, function()
            PlaySound("kira00")
            for i = 9, 0, -1 do
                self.hscale = 0.25 + 0.75 * i / 10
                self.vscale = self.hscale
                self.a = self.hscale * 24
                self.b = self.a
                task.Wait()
            end
            self.hscale, self.vscale = 1, 1
            bullet.ChangeImage(self, ball_mid, self._index)
        end)
    end
    function Rose:ChangeByID(id)
        if id == 1 then
            Rose.BulletToRose(self)
        elseif id == 2 then
            Rose.RoseToBullet(self)
        end
    end
    class["bullet0-2Rose"] = Class(bullet, {
        init = function(self, x, y, index, v, a, t)
            bullet.init(self, ball_mid, index, false, true)
            self.x, self.y = x, y
            object.SetV(self, v, a, true)
            Rose.GetIndex(self, index)
            Rose.ChangeByID(self, t)
            bullet.SetLayer(self, LAYER.ENEMY_BULLET - 1)
            task.New(self, function()
                while true do
                    for i = 1, 90 do
                        object.SetV(self, v - v * i / 90, a, true)
                        task.Wait()
                    end
                    t = t % 2 + 1
                    Rose.ChangeByID(self, t)
                end
            end)
        end
    })
    class["bullet0-3polar"] = Class(bullet, {
        init = function(self, x, y, index, v, a, l, r)
            bullet.init(self, star_small, index, false, true)
            self.x, self.y = x, y
            self.omiga = ran:Sign() * 2
            self.bound = false
            task.New(self, function()
                while true do
                    self.colli = self.y < lstg.world.t
                    if Dist(self, x, y) > 600 then
                        object.RawDel(self)
                    end
                    self.x = x + cos(a) * l
                    self.y = y + sin(a) * l
                    a = a + r
                    l = l + v
                    task.Wait()
                end
            end)
        end,
        render = function(self)
            SetImageState("bright", "mul+add", 128, 250, 128, 114)
            Render("bright", self.x, self.y, 0, 0.18)
            bullet.render(self)
        end
    })
end--bullet

do
    class["object1-1"] = Class(object, {
        init = function(self, x, y, mx, my, p1, p2)
            self.group = GROUP.INDES
            self.x, self.y = x, y
            self.img = "servant"
            self.layer = LAYER.ENEMY
            self.colli = false
            self._a = 0
            self.omiga = 5
            task.New(self, function()
                for i = 1, 10 do
                    self._a = 255 * sin(i * 9)
                    task.Wait()
                end
            end)
            task.New(self, function()
                task.MoveTo(mx, my, 30, 0)
                object.Del(self)
            end)
            task.New(self, function()
                local b, _x, _y
                for _ = 1, 30 do
                    for X = -3, 3 do
                        for Y = -3, 3 do
                            if ran:Int(0, p1) == 0 then
                                _x, _y = int(self.x / 16) * 16 + X * 16, int(self.y / 16) * 16 + Y * 16
                                if Dist(_x, _y, player.x, player.y) > 50 then
                                    b = NewSimpleBullet(ball_mid, 6, _x, _y)
                                    b._blend = "mul+add"
                                    b.p2 = p2
                                    b.frame_other = function(unit)
                                        if unit.timer > 75 then
                                            object.Del(unit)
                                            if ran:Int(0, unit.p2) == 0 then
                                                PlaySound("kira00")
                                                Create.bullet_accel(unit.x, unit.y, ball_mid, 5, 0.5, 2, ran:Int(1, 4) * 90, true)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    PlaySound("tan00")
                    task.Wait()
                end
            end)
        end,
        frame = task.Do,
        render = function(self)
            SetImageState(self.img, "mul+add", self._a, 255, 227, 132)
            DefaultRenderFunc(self)
        end
    })
    class["object1-2"] = Class(object, {
        init = function(self, open, d)
            self.x, self.y = player.x, player.y
            self.group = GROUP.INDES
            self.layer = LAYER.ENEMY
            self.colli = false
            self.r = 50
            self.alpha = 0
            PlaySound("explode")
            local a = 90
            for i = 1, 30 do
                New(class["bullet1-1"], self, open + (180 - open * 2) / 30 * i + a)
                New(class["bullet1-1"], self, -open - (180 - open * 2) / 30 * i + a)
            end
            task.New(self, function()
                for i = 1, 60 do
                    self.omiga = 4 * d - 4 * sin(i * 1.5) * d
                    self.x = self.x + (-self.x + player.x) * 0.04
                    self.y = self.y + (-self.y + player.y) * 0.04
                    self.r = 50 + 150 * sin(i * 1.5)
                    task.Wait()
                end
                for i = 1, 120 do
                    self.x = self.x + (-self.x + player.x) * 0.03
                    self.y = self.y + (-self.y + player.y) * 0.03
                    self.omiga = -6 * d + 6 * d * sin(i * 0.75)
                    self.r = 200 - 150 / 120 * i
                    self.alpha = 150 / 120 * i
                    task.Wait()
                end
                NewBon(self.x, self.y, 60, 128, 255, 100, 100)
                NewWave(self.x, self.y, 2, 128, 60, 255, 100, 100)
                PlaySound("slash", 0, self.x / 200)
                self.boom = true
                if Dist(self, player) < 50 then
                    player.class.colli(player, self)
                end
                for i = 1, 60 do
                    self.alpha = 255 * sin(90 - i * 1.5)

                    task.Wait()
                end
                object.Del(self)
            end)
        end,
        frame = task.Do,
        render = function(self)
            SetImageState("white", "mul+add", self.alpha, 250, 128, 114)
            misc.SectorRender(self.x, self.y, 0, self.r, 0, 360, 60, 0)
            SetImageState("white", "mul+add", self.alpha, 255, 255, 255)
            misc.SectorRender(self.x, self.y, self.r - 2, self.r + 2, 0, 360, 60, 0)
        end
    })
    class["object1-3"] = Class(object, {
        init = function(self, x, y)
            self.group = GROUP.INDES
            self.layer = LAYER.ENEMY_BULLET
            self.y = -240
            self.ty = y
            self.x = x
            self.colli = false
            task.New(self, function()
                for i = 1, 10 do
                    self.y = -240 + (240 + self.ty) * sin(i * 9)
                    task.Wait()
                end
                task.Wait(190)
                while true do
                    self.y = self.y - 5
                    task.Wait()
                end
            end)
        end,
        frame = function(self)
            task.Do(self)
            if player.x < self.x + 34 and player.x > self.x - 34 and player.y < self.y + 40 then
                player.y = player.y + (-player.y + self.y + 40) * 0.07
            end
        end,
        render = function(self)
            SetImageState("ball_mid6", "mul+add", 255, 255, 255, 255)
            for y = self.y - 480, self.y, 13 do
                for x = -2, 2 do
                    Render("ball_mid6", self.x + x * 13, y)
                end
            end
            SetImageState("ball_mid6", "", 255, 255, 255, 255)
        end
    })
    LoadAniFromFile("Tenshi_stone", "mod\\GAME\\Stone.png", nil, 3, 1, 5, 10, 10)
    class["object0-1stone"] = Class(object, {
        init = function(self, master, a, r, o, bound)
            self.x, self.y = master.x + cos(a) * r, master.y + sin(a) * r
            self.bound = bound
            self.r = r
            self.img = "Tenshi_stone"
            self.rot = a
            self.omiga = o
            self.master = master
            self.group = GROUP.ENEMY_BULLET
            self.layer = LAYER.ENEMY_BULLET
            self.a, self.b = 10, 10
        end,
        frame = function(self)
            task.Do(self)
            if not IsValid(self.master) then
                object.Del(self)
                return
            end
            if self.y < -300 then
                object.Del(self)
            end
            self.x, self.y = self.master.x + cos(self.rot) * self.r, self.master.y + sin(self.rot) * self.r
        end
    })
    class["object0-2"] = Class(object, {
        init = function(self, x, y)
            self.x, self.y = x, y
            self.group = GROUP.INDES
            self.layer = LAYER.ENEMY
            self.colli = false
            self.alpha = 0
            self.omiga = 0.7
            PlaySound("explode")
            task.New(self, function()
                for i = 1, 90 do
                    self.r = 280 * sin(i)
                    task.Wait()
                end
                task.Wait(30)
                while true do
                    for i = 1, 60 do
                        self.r = 280 - 40 * sin(i * 1.5)
                        task.Wait()
                    end
                    for i = 1, 60 do
                        self.r = 240 + 40 * sin(i * 1.5)
                        task.Wait()
                    end
                end
            end)
            task.New(self, function()
                local s = 0
                while true do
                    self.x = self.x + (-self.x + player.x) * s
                    self.y = self.y + (-self.y + player.y) * s
                    s = min(0.04, s + 0.04 / 180)
                    task.Wait()
                end
            end)
            task.New(self, function()
                task.Wait(120)
                local d = 1
                while true do
                    for i = 60, 360, 60 do
                        i = i + self.rot
                        for c = 90, 360, 90 do
                            New(_editor_class["TH12"]["laser1-2"], self.x + cos(i) * self.r * 0.6, self.y + sin(i) * self.r * 0.6, 0, c + i + 45 * d, 2.1, 0, 6, 3, 9, 10, 70)
                        end
                    end
                    task.Wait(200)
                    PlaySound("tan00")
                    for c = 6, 360, 6 do
                        Create.bullet_decel(self.x + cos(c) * self.r * 0.6, self.y + sin(c) * self.r * 0.6, ellipse, 10, 6, 3, c)
                    end
                    d = -d
                    task.Wait(100)
                end
            end)
        end,
        frame = task.Do,
        render = function(self)
            SetImageState("white", "mul+add", 128, 189, 252, 201)
            misc.SectorRender(self.x, self.y, self.r * 0.92, self.r, 0, 360, 4, self.rot / 2)
            misc.SectorRender(self.x, self.y, self.r * 0.92, self.r, 0, 360, 4, self.rot / 2 + 45)
            misc.SectorRender(self.x, self.y, self.r * 0.5 * 0.91, self.r * 0.5, 0, 360, 6, -self.rot)
            SetImageState("laser_node5", "mul+add")
            for i = 60, 360, 60 do
                Render("laser_node5", self.x + cos(i + self.rot) * self.r * 0.6, self.y + sin(i + self.rot) * self.r * 0.6)
            end
            SetImageState("laser_node5", "")
        end
    })
    class["object0-3photo"] = Class(object, {
        init = function(self, master, x, y, v, a, o)
            self.group = GROUP.INDES
            self.layer = LAYER.ENEMY_BULLET_EF
            self.x, self.y = x, y
            self.img = "photo2OFF"
            self._a = 255
            self._a2 = 0
            self.scale2 = 1
            self.hscale = 1
            self.vscale = 1
            self.a = 128
            self.master = master
            self.b = 64
            self.colli = false
            self.bound = false
            PlaySound("boon00")
            local Math = sp.geom
            local rr, ata
            function self:check(target)
                rr = sqrt(self.a * self.a + self.b * self.b)
                if Dist(self, target) > rr then
                    return false
                end
                ata = math.deg(math.atan2(self.b, self.a))
                return Math.PointInRectangle(Math.NewPoint(target), Math.NewRectangle(
                        Math.NewPoint(self.x + cos(self.rot + ata) * rr, self.y + sin(self.rot + ata) * rr),
                        Math.NewPoint(self.x + cos(self.rot - ata) * rr, self.y + sin(self.rot - ata) * rr),
                        Math.NewPoint(self.x - cos(self.rot + ata) * rr, self.y - sin(self.rot + ata) * rr),
                        Math.NewPoint(self.x - cos(self.rot - ata) * rr, self.y - sin(self.rot - ata) * rr)))
            end
            task.New(self, function()
                for i = 0, 10 do
                    self.hscale = 1 - 0.3 * sin(i * 9)
                    self.vscale = self.hscale
                    self.a = 128 * self.hscale
                    self.b = 64 * self.vscale
                    task.Wait()
                end
            end)
            task.New(self, function()
                while true do
                    while not self:check(player) do
                        task.Wait()
                    end
                    task.New(self, function()
                        task.Wait(22)
                        boss.cast(self.master, 10)
                    end)
                    for i = 1, 30 do
                        self._a2 = 128 * sin(i * 3)
                        task.Wait()
                    end
                    PlaySound("shutter", 1)
                    object.BulletDo(function(unit)
                        if unit._index == 8 and self:check(unit) then
                            object.Del(unit)
                        end
                    end)
                    if self:check(player) then
                        ext.achievement:get(112)
                        player.class.colli(player, self)
                    end
                    for i = 1, 30 do
                        i = task.SetMode[5](i / 30)
                        self._a2 = 255 - 255 * i
                        self.scale2 = 1.3 - 0.3 * i
                        task.Wait()
                    end
                end
            end)
            task.New(self, function()
                local l = 0
                while true do
                    if Dist(self.x, self.y, x, y) > 900 then
                        object.RawDel(self)
                    end
                    self.rot = a
                    self.x = x + cos(a) * l
                    self.y = y + sin(a) * l
                    a = a + o
                    l = l + v
                    task.Wait()
                end
            end)
        end,
        frame = function(self)
            if not IsValid(self.master) then
                object.Kill(self)
                return
            end
            task.Do(self)
        end,
        render = function(self)
            SetImageState(self.img, "mul+add", self._a, 255, 255, 255)
            DefaultRenderFunc(self)
            SetImageState("photo2ON", "mul+add", self._a2, 255, 255, 255)
            Render("photo2ON", self.x, self.y, self.rot, self.hscale * self.scale2, self.vscale * self.scale2)
        end,
        kill = function(self)
            object.Preserve(self)
            task.New(self, function()
                for i = 1, 15 do
                    self._a = 255 - 255 * sin(i * 6)
                    task.Wait()
                end
                object.RawDel(self)
            end)
        end
    })
end--object

do
    class["laser1-1"] = Class(laser, {
        init = function(self, master, a, o, r)
            local l = 1 / tan(18) * r
            laser.init(self, 2, master.x + cos(a + 90) * r - cos(a) * l, master.y + sin(a + 90) * r - sin(a) * l, a, l, 0, l)
            laser.ChangeImage(self, 4, 2)
            self.bound = false
            self.master = master
            self.radius = r
            self.omiga = o
            laser._TurnHalfOn(self, 10)
            task.New(self, function()
                task.Wait(40)
                laser._TurnOn(self, 30, true)
                task.Wait(180)
                laser._TurnOff(self, 30, true)
                object.Del(self)
            end)
        end,
        frame = function(self)
            laser.frame(self)
            if not IsValid(self.master) then
                object.Del(self)
                return
            end
            self.x = self.master.x + cos(self.rot + 90) * self.radius - cos(self.rot) * self.l1
            self.y = self.master.y + sin(self.rot + 90) * self.radius - sin(self.rot) * self.l1
        end,
        render = function(self)
            laser.render(self)
            local l = self.l1 + self.l2 + self.l3
            SetImageState("ball_light1", "mul+add", self.alpha * 255, 255, 255, 255)
            Render("ball_light1", self.x, self.y, 0, 0.3)
            Render("ball_light1", self.x + cos(self.rot) * l, self.y + sin(self.rot) * l, 0, 0.3)
            SetImageState("white", "mul+add", self.alpha * 60, 135, 206, 235)
            Render("white", self.x + cos(self.rot) * l / 2, self.y + sin(self.rot) * l / 2, self.rot, l / 16, 0.3)
            Render("white", self.x + cos(self.rot) * l / 2, self.y + sin(self.rot) * l / 2, self.rot, l / 16, 0.6)
        end
    })
    class["laser0-1"] = Class(global_obj.laser_changeangle, {
        init = function(self, x, y, _a, a, z, t)
            global_obj.laser_changeangle.init(self, x + cos(_a) * 60, y + sin(_a) * 60, 3, 50, 10, 5, z * 1.5 + _a,
                    { r = -z * 1.2, time = 40 },
                    { time = 40, r = -(a / 180 * 2 - 1) * abs(z) / 4 },
                    { time = 30, r = sign(z) })
            self.navi = true
            task.New(self, function()
                for i = 1, t do
                    sakura_big.New(x + cos(_a) * 60, y + sin(_a) * 60, ran:Float(0, 360), ran:Sign() * 1.5, 2.5, z * 1.5 + _a + i * sign(z) * 16)
                    PlaySound("kira00")
                    task.Wait(26)
                end
            end)
        end
    })
    class["laser0-2"] = Class(laser, {
        init = function(self, x, y, rot)
            laser.init(self, 16, x, y, rot, 0, 0, 0, 8, 6, 0)
            laser._TurnHalfOn(self, 1)
            self.bound = false
            self.line = 0
            self.Isradial = true
            self.radial_v = 15
            task.New(self, function()
                for i = 1, 60 do
                    self.line = sin(i * 1.5) * 1000
                    task.Wait()
                end
                task.Wait(30)
                laser._TurnOn(self, 1, true)
                task.New(self, function()
                    for _ = 1, 40 do
                        self.l3 = self.l3 + 15
                        task.Wait()
                    end
                    for _ = 1, 40 do
                        self.l1 = self.l1 + 15
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
    })
end--laser

do
    boss.Define("1a", "星熊勇仪", "TH12_5_1", TH125_bg, { -400, 400 }, class["SCBG1"], "Yugi", 9)
    boss.Define("1b", "伊吹萃香", "TH12_5_1", TH125_bg, { 400, 400 }, class["SCBG1"], "Suika", 9)
    local non_sc1 = boss.card.New("", 1, 1, 45, 800)
    local non_sc2 = boss.card.New("", 1, 1, 45, 800)
    boss.card.add({ { non_sc1, "1a" }, { non_sc2, "1b" } }, 9, "非符", 84)
    function non_sc1:before()
        FullScreen()
        task.MoveTo(-150, 120, 60, 2)
    end
    function non_sc1:init()
        task.New(self, function()
            local dx = 1
            while true do
                local A
                boss.cast(self, 120, true)
                task.New(self, function()
                    task.MoveTo(-50 * dx, 120, 120, 3)
                end)
                for i = 1, 4 do
                    for a in sp.math.AngleIterator(0, 15) do
                        A = a + i * 3 * dx
                        Create.laser_line(self.x + cos(A) * 30 - 12 * dx, self.y + sin(A) * 30 + 24, 5, 8, A, 36, 10, 12)
                        A = a - i * 3 * dx
                        Create.bullet_accel(self.x + cos(A) * 30 - 12 * dx, self.y + sin(A) * 30 + 24, water_drop, 6, 0.6, 8, A)
                    end
                    task.Wait(25)
                end
                task.Wait(120)
                for i = 1, 36 do
                    Create.laser_changeangle(self.x, self.y, 14, 70, 12, 4, 90 - 90 * dx + dx * i * 10,
                            { wait = i, r = dx * 12, time = 30 }, { v = 6, r = -dx * (i % 2 * 2 - 1), time = 120 })
                end
                task.Wait(90)
                task.MoveTo(150 * dx, 120, 60, 2)
                task.Wait(60)
                dx = -dx
            end
        end)
    end
    function non_sc1:del()
        self.cao = true
    end
    non_sc1.frame = boss.card.PublicHP
    function non_sc2:before()
        FullScreen()
        task.MoveTo(150, 120, 60, 2)
    end
    function non_sc2:init()
        task.New(self, function()
            local dx = 1
            while true do
                task.New(self, function()
                    task.MoveTo(50 * dx, 120, 120, 3)
                end)
                local sty = { ball_small, ball_mid, ball_big, ball_huge }
                local A = Angle(self, player)
                for i = 1, 4 do
                    A = Angle(self, player)
                    for a = 30, 360, 30 do
                        NewSimpleBullet(sty[i], 2, self.x + cos(a) * 50, self.y + sin(a) * 50, 7, A)
                    end
                    PlaySound("tan00")
                    task.Wait(25)
                end
                task.Wait(50)
                for i = 1, 15 do
                    for a in sp.math.AngleIterator(0, 7) do
                        for z = -1, 1 do
                            Create.bullet_changeangle(self.x, self.y, water_drop, 4,
                                    4 - i / 15 * 2, a + z * 22.5, true, { time = 90, r = z * 0.1 * i })
                        end
                    end
                    PlaySound('tan00')
                    task.Wait(4)
                end
                task.Wait(100)
                task.MoveTo(-150 * dx, 120, 60, 2)
                task.Wait(60)
                dx = -dx
            end
        end)
    end
    function non_sc2:del()
        self.cao = true
    end
    non_sc2.frame = boss.card.PublicHP

    local name = "鬼符「鬼气上身，密气脱身」"
    local sc1 = boss.card.New(name, 1, 2, 60, 900)
    local sc2 = boss.card.New(name, 1, 2, 60, 900)
    boss.card.add({ { sc1, "1a" }, { sc2, "1b" } }, 9, name, 85)

    function sc1:before()
        FullScreen()
        if self.otherboss[1] then
            if not self.otherboss[1].cao then
                self.otherboss[1].hp = 0
            end
        end
        if ext.sc_pr then
            task.MoveTo(-150, 120, 60, 2)
        else
            task.Wait(60)
        end
    end
    function sc1:init()
        task.New(self, function()
            task.MoveTo(100, 100, 60, 2)
            local dx = 1
            while true do
                Newcharge_in(self.x, self.y, 128, 32, 32)
                task.Wait(60)
                boss.cast(self, 90)
                task.Wait(90)
                Newcharge_out(self.x, self.y, 128, 32, 32)
                local xr = 200
                for x = -1, 1 do
                    New(class["object1-1"], x * xr, 240, x * xr, -240, 10, 2)
                end
                task.Wait(90)
                local A = Angle(self, player)
                for i = 1, 20 do
                    Create.laser_changeangle(self.x - 12 * dx, self.y + 24, 2, 40, 12, 2, i * 18 + A,
                            { v = 1, time = 90 }, { v = 6, r = 0, time = 90 })
                end
                task.MoveToPlayer(95, 0, 150, 80, 120, 20, 40, 16, 32, 2, 1)
                dx = sign(self.dx)
                --  task.Wait(60)
            end
        end)
    end
    sc1.frame = boss.card.PublicHP

    function sc2:before()
        FullScreen()
        if self.otherboss[1] then
            if not self.otherboss[1].cao then
                self.otherboss[1].hp = 0
            end
        end
        if ext.sc_pr then
            task.MoveTo(150, 120, 60, 2)
        else
            task.Wait(60)
        end
    end
    function sc2:init()
        self.shoot = function(x, y, a, v, o, t)
            return function()
                for _ = 1, t do
                    NewSimpleBullet(grain_b, 6, x, y, v, a)
                    PlaySound('tan00')
                    a = a + o
                    v = v - 0.2
                    task.Wait(3)
                end
            end
        end
        task.New(self, function()
            task.MoveTo(-100, 100, 60, 2)
            local d = 1
            while true do
                Newcharge_in(self.x, self.y, 128, 32, 32)
                task.Wait(60)
                New(class["object1-2"], 30, d)
                task.Wait(75)
                task.MoveToPlayer(80, -150, 0, 80, 120,
                        20, 40, 16, 32, 2, 1)
                d = -d
                task.Wait(120)
            end
        end)
    end
    sc2.frame = boss.card.PublicHP
end--boss1

do
    boss.Define("2a", "比那名居天子", "TH12_5_2", TH125_bg, { 0, 400 }, class["SCBG2"], "Tenshi", 9)
    local non = boss.card.New("", 1, 1, 45, 800)
    function non:before()
        FullScreen()
        task.MoveTo(0, 120, 60, 2)
    end
    function non:init()
        task.init_left_wait(self)
        self.shoot = function(x, y, a, v, o, t, d)
            local b = (t - 1) / 2
            for c = -b, b do
                NewSimpleBullet(grain_a, 8, x, y, v + d * abs(c) * 0.1, a)
                a = a + o
            end
            PlaySound('tan00')
        end
        task.New(self, function()
            while true do
                task.Wait()
                boss.cast(self, 120)
                task.Wait(120)
                task.MoveToPlayer(60, -150, 150, 100, 140,
                        20, 40, 16, 32, 2, 1)
            end
        end)
        task.New(self, function()
            local sty = { water_drop, ellipse }
            local b
            local d = 1
            while true do
                for c = 1, 4 do
                    for i = 9, 360, 9 do
                        Create.bullet_dec_setangle(self.x, self.y, sty[i / 9 % 2 + 1], 2, false, { v = 4, a = i, time = 44 }, { v = 2 + c * 0.5, a = i + d * c * 40 })
                    end
                    d = -d
                    PlaySound("tan00")
                    task.Wait2(self, 22.4)
                end
                for _ = 1, 4 do
                    for _ = 1, 40 do
                        b = NewSimpleBullet(sty[ran:Int(1, 2)], 4, self.x, self.y, ran:Float(2, 5), ran:Float(30, 150))
                        b.ag = 0.04
                        b.maxvy = 4
                        b.navi = true
                    end
                    PlaySound("tan00")
                    task.Wait2(self, 22.4)
                end
                for c = 1, 4 do
                    for i = 18, 360, 18 do
                        i = i + c * 7 * d
                        self.shoot(self.x + cos(i) * c * 10, self.y + sin(i) * c * 10, i, 6 - c * 0.5, c * d * 0.4, 9, d)
                    end
                    task.Wait2(self, 22.4)
                end
                task.Wait2(self, 44.8)
                local A, C
                for c = 4, 5 do
                    A = Angle(self, player)
                    C = (c - 1) / 2
                    for i = -C, C do
                        Create.laser_changeangle(self.x, self.y, 6, 20, 8, 4, A + i * 15, { wait = 45, time = 70, r = -i * 0.4 * d })
                    end
                    task.Wait2(self, 22.4)
                end
                d = -d
            end
        end)
    end
    boss.card.add({ { non, "2a" } }, 9, "非符", 86)
    local sc = boss.card.New("乾坤「粗暴而又像母亲般的大地啊」", 1, 2, 50, 930)
    function sc:before()
        FullScreen()
        if ext.sc_pr then
            task.MoveTo(0, 120, 60, 2)
        else
            task.Wait(60)
        end
    end
    function sc:init()

        task.New(self, function()
            task.MoveTo(0, 140, 60, 2)
            Newcharge_in(self.x, self.y, 32, 32, 128)
            task.Wait(60)
            while true do
                local pos = {}
                task.New(self, function()
                    local b, _y
                    for x = -4, 4 do
                        _y = ran:Float(-200, 90)
                        b = NewSimpleBullet(ball_light, 6, self.x, self.y, 0, 0, false, 0, false)
                        bullet.SetLayer(b, LAYER.ENEMY_BULLET + 1)
                        PlaySound("kira00")
                        table.insert(pos, { x * 70, _y })
                        task.New(b, function()
                            task.MoveTo(x * 70, _y, 90, 2)
                            task.Wait(60)
                            object.Del(task.GetSelf())
                        end)
                        task.Wait(10)
                    end
                end)
                task.New(self, function()
                    for t = 1, 8 do
                        for i = 1, 20 do
                            NewSimpleBullet(ball_big, ({ 4, 6 })[(i + t) % 2 + 1], self.x, self.y, ({ 4, 5 })[(i + t) % 2 + 1], i * 18)
                        end
                        PlaySound("tan00")
                        task.Wait(20)
                    end
                end)
                task.MoveToPlayer(90, -200, 200, 120, 160, 40, 80, 20, 40, 2, 1)
                task.Wait(90)
                Newcharge_in(self.x, self.y, 32, 32, 128)
                task.Wait(60)
                boss.cast(self, 90)
                misc.ShakeScreen(60, 1)
                Newcharge_out(self.x, self.y, 32, 32, 128)
                local b
                for _, p in ipairs(pos) do
                    New(class["object1-3"], unpack(p))
                    for x = -1, 1 do
                        b = NewSimpleBullet(ball_light, 6, p[1] + x * 8, 240, 0, 0, false, 0, false)
                        task.New(b, function()
                            task.CRMoveTo(180, 1, p[1] + x * 8, p[2] + 32, p[1] + x * 8, 240)
                            object.Del(task.GetSelf())
                        end)
                    end
                end
                task.Wait(30)
                task.New(self, function()
                    local d = 1
                    for _ = 1, 4 do
                        local A = Angle(self, player)
                        for c = -3.5 * d, 3.5 * d, d do
                            Create.laser_changeangle(self.x, self.y, 6, 25, 8, 4, A + c * 15, { wait = 10, time = 70, r = -c * 0.4 })
                            task.Wait(5)
                        end
                        d = -d
                    end
                end)
                task.MoveToPlayer(90, -200, 200, 120, 160, 40, 80, 20, 40, 2, 1)
                task.Wait(180)
            end
        end)
    end
    boss.card.add({ { sc, "2a" } }, 9, "乾坤「粗暴而又像母亲般的大地啊」", 87)
end--boss2

do
    boss.Define("3a", "永江衣玖", "TH12_5_2", TH125_bg, { 200, 400 }, class["SCBG2"], "Iku", 9)
    local non = boss.card.New("", 1, 1, 45, 800)
    function non:before()
        FullScreen()
        task.MoveTo(0, 120, 60, 2)
    end
    function non:init()
        self.shoot = function(x, y, a, v, o, t)
            return function()
                local b
                for i = 1, t do
                    b = NewSimpleBullet(ball_light, ({ 8, 6 })[i % 2 + 1], x, y, v, a)
                    b.hscale, b.vscale, b.a, b.b = 0.5, 0.5, 0.5 * b.a, 0.5 * b.b
                    PlaySound('tan00')
                    a = a + o
                    v = v - 0.2
                    task.Wait(3)
                end
            end
        end
        task.New(self, function()
            while true do
                task.Wait()
                boss.cast(self, 120)
                task.Wait(120)
                task.MoveToPlayer(60, -150, 150, 100, 140,
                        20, 40, 16, 32, 2, 1)
            end
        end)
        task.New(self, function()
            local d = 1
            while true do
                local b
                for a = 12, 360, 12 do
                    b = Create.bullet_accel(self.x, self.y, ball_light, 4, 0.1, 4, a)
                    b.hscale, b.vscale, b.a, b.b = 0.6, 0.6, 0.6 * b.a, 0.6 * b.b
                end
                for c = -10 * d, 10 * d, d do
                    for i = 90, 360, 90 do
                        Create.laser_changeangle(self.x + cos(i + c * 8) * 30, self.y + sin(i + c * 8) * 30, 8, 20, 8, 3, i + c * 8,
                                { r = c / 8, time = 120, v = 4.2 })
                    end
                    task.Wait(3)
                end
                for v = 1, 3 do
                    for a = 12, 360, 12 do
                        b = Create.bullet_decel(self.x, self.y, ball_light, 4, 6, v, a)
                        b.hscale, b.vscale, b.a, b.b = 0.6, 0.6, 0.6 * b.a, 0.6 * b.b
                    end
                end
                PlaySound("tan00")
                task.Wait(50)
                for i = 30, 360, 30 do
                    for j = 120, 360, 120 do
                        task.New(self, self.shoot(self.x + cos(d * i + j) * 30, self.y + sin(d * i + j) * 30,
                                d * i + j, 4 + i / 270, d * i / 40, 7))
                    end
                    task.Wait(9)
                end
                for v = 1, 3 do
                    for a = 12, 360, 12 do
                        b = Create.bullet_accel(self.x, self.y, ball_light, 10, 0.5, v * 0.6 + 1.5, a)
                        b.hscale, b.vscale, b.a, b.b = 0.6, 0.6, 0.6 * b.a, 0.6 * b.b
                    end
                end
                local A, _a = Angle(self, player)
                for a = 0, 180, 180 do
                    for z = -10.5, 10.5 do
                        _a = z * 1.5 + a + A + 90
                        Create.laser_changeangle(self.x + cos(_a) * 20, self.y + sin(_a) * 20, 6, 50, 10, 4, z * 1.5 + _a,
                                { r = z * 0.9, time = 40 }, { time = 1, v = 1 }, { wait = 20, time = 40, r = (a / 180 * 2 - 1) * abs(z) / 4, v = 7 })
                    end
                end
                d = -d
                task.Wait(180)
            end
        end)
    end
    boss.card.add({ { non, "3a" } }, 9, "非符", 88)
    local sc = boss.card.New("魂符「五爪龙之魂」", 2, 2, 50, 780)
    function sc:before()
        FullScreen()
        if ext.sc_pr then
            task.MoveTo(0, 120, 60, 2)
        else
            task.Wait(60)
        end
    end
    function sc:init()
        local center = Class(object, {
            init = function(self, x, y, v, a, srot, o, r)
                self.x, self.y = x, y
                self.bound = false
                self.group = GROUP.INDES
                self.servant = {}
                for i = 72, 360, 72 do
                    table.insert(self.servant, New(class["laser1-1"], self, i + srot, o, r))
                end
                task.New(self, function()
                    object.SetV(self, 0.6, a)
                    for i = 1, 60 do
                        object.SetV(self, 0.6 + (v - 0.6) * sin(i * 1.5), a)
                        task.Wait()
                    end
                end)
            end,
            frame = function(self)
                task.Do(self)
                sp:UnitListUpdate(self.servant)
                if #self.servant == 0 then
                    object.Del(self)
                end
            end
        }, true)
        local center2 = Class(object, {
            init = function(self, _x, _y, mx, my, D)
                self.x, self.y = _x, _y
                self.bound = false
                self.group = GROUP.INDES
                local x
                local d = 1 / tan(18)
                for a = 72, 360, 72 do
                    x = d
                    for _ = 1, 16 do
                        New(class["bullet1-1star"], self, x, a, 60, 0.6 * D)
                        x = x - 2 * d / 16
                    end
                end
                PlaySound("tan00")
                task.New(self, function()
                    task.MoveTo(mx, my, 120, 3)
                    task.Wait(60)
                    Newcharge_out(self.x, self.y, 32, 32, 128)
                    task.Wait(90)
                    object.Del(self)
                end)
            end,
            frame = task.Do
        }, true)
        self.shoot = function(x, y, a, v, o, t)
            return function()
                local b
                local s = 0.5
                for _ = 1, t do
                    b = NewSimpleBullet(ball_huge, 14, x, y, v, a)
                    b.hscale, b.vscale, b.a, b.b = s, s, s * b.a * 0.7, s * b.b * 0.7
                    PlaySound('tan00')
                    a = a + o
                    v = v - 0.3
                    s = s - 0.02
                    task.Wait(4)
                end
            end
        end
        task.New(self, function()
            task.MoveTo(0, 100, 60, 2)
            task.New(self, function()
                local d = 1
                while true do
                    task.Wait()
                    boss.cast(self, 90)
                    Newcharge_in(self.x, self.y, 32, 32, 128)
                    task.Wait(60)
                    for i = 1, 9 do
                        New(center, self.x, self.y, 2, i * 40, 0, d * (i % 2 * 2 - 1), 40)
                    end
                    task.Wait(60)
                    task.MoveToPlayer(60, -150, 150, 100, 140, 20, 40, 16, 32, 2, 1)
                    task.Wait(60)
                    boss.cast(self, 90)
                    New(center2, self.x, self.y, ran:Float(-180, 180), ran:Float(-160, -40), d)
                    task.Wait(120)
                    task.MoveToPlayer(60, -150, 150, 100, 140, 20, 40, 16, 32, 2, 1)
                    task.Wait(120)
                    d = -d
                end
            end)
            task.Wait(90)
            local r = 0
            local s = 0
            while true do
                for j = 120, 360, 120 do
                    task.New(self, self.shoot(self.x + cos(r + j) * 30, self.y + sin(r + j) * 30, r + j, 3, 1 + sin(s) * 4, 5))
                end
                task.Wait(20)
                r = r + 19
                s = s + 6
            end
        end)
    end
    boss.card.add({ { sc, "3a" } }, 9, "魂符「五爪龙之魂」", 89)
end--boss3

do
    boss.Define("4a", "比那名居天子", "TH12_5_0", TH125_bg, { -500, 0 }, class["SCBG2"], "Tenshi", 9)
    boss.Define("4b", "永江衣玖", "TH12_5_0", TH125_bg, { 500, 0 }, class["SCBG2"], "Iku", 9)
    local name = "「百里之行，羽衣溢樱」"
    local sc1 = boss.card.New(name, 1, 1, 60, 630)
    local sc2 = boss.card.New(name, 1, 1, 60, 630)
    boss.card.add({ { sc1, "4a" }, { sc2, "4b" } }, 9, name, 90)
    function sc1:before()
        FullScreen()
        task.MoveTo(-70, 120, 60, 2)
    end
    function sc1:init()
        local center = Class(bullet, {
            init = function(self, x, y, v, a, d, n, bound, D)
                bullet.init(self, ball_huge, 2, false, false)
                self.bound = false
                self.x, self.y = x, y
                object.SetV(self, v, a, true)
                PlaySound("tan00")
                self.servant = {}
                for i = 1, n do
                    table.insert(self.servant, New(class["object0-1stone"], self, i * 360 / n, 50, d, bound))
                end
                task.New(self, function()
                    task.Wait(20)
                    while true do
                        for i = -3, 3 do
                            for A = 0, 180, 180 do
                                Create.bullet_decel(self.x, self.y, water_drop, 2, 6, 3, self.rot + A + i * 2 * D)
                            end
                            PlaySound("tan00")
                            task.Wait(4)
                        end
                        task.Wait(6)
                    end
                end)
            end,
            frame = function(self)
                bullet.frame(self)
                sp:UnitListUpdate(self.servant)
                if #self.servant == 0 then
                    object.Del(self)
                end
            end
        }, true)
        local wait = 120
        local flag
        task.New(self, function()
            boss.violent(self)
            wait = 60
            flag = true
        end)
        task.New(self, function()
            task.New(self, function()
                local d = 1
                while true do
                    task.Wait()
                    boss.cast(self, 120)
                    local a = Angle(self, player)
                    for i = 1, 9 do
                        New(center, self.x, self.y, 3.3, i * 40 + a, ran:Sign(), 5, true, flag and d or 0)
                    end
                    task.Wait(wait)
                    d = -d
                    task.MoveToPlayer(60, -90, 0, 100, 140,
                            20, 40, 16, 32, 2, 1)
                end
            end)
        end)
    end

    function sc2:before()
        FullScreen()
        task.MoveTo(70, 120, 60, 2)
    end
    function sc2:init()
        local para = { 5.5, 20, 5, 110 }
        task.New(self, function()
            boss.violent(self)
            para = { 7.5, 16, 4, 40 }
        end)
        task.New(self, function()
            while true do
                boss.cast(self, 90)
                local A = Angle(self, player)
                for a = 0, 180, 180 do
                    for z = -para[1], para[1] do
                        New(class["laser0-1"], self.x, self.y, z * para[2] + a + A + 90, a, z, para[3])
                    end
                end
                task.Wait(50)
                task.MoveToPlayer(60, 0, 90, 100, 140,
                        20, 40, 16, 32, 2, 1)
                task.Wait(para[4])
            end
        end)
    end
end--boss4

do
    boss.Define("5a", "古明地觉", "TH12_5_0", TH125_bg, { 20, 400 }, _editor_class["TH11"]["SCBG1"], "Satori", 9)
    boss.Define("5b", "古明地恋", "TH12_5_0", TH125_bg, { -20, 400 }, _editor_class["TH11"]["SCBG1"], "Koishi", 9)
    local name = "心術「钟摆摇闲适，呻吟罔耳边」"
    local sc1 = boss.card.New(name, 1, 1, 60, 900)
    local sc2 = boss.card.New(name, 1, 1, 60, 900)
    boss.card.add({ { sc1, "5a" }, { sc2, "5b" } }, 9, name, 91)

    function sc1:before()
        FullScreen()
        task.MoveTo(-40, 120, 60, 2)
    end
    function sc1:init()
        do
            local speed = 0.7
            local x, y = 0, 240
            local range = 50
            New(class["bullet0-1pendulum"], ball_huge, 2, x, y, 0, range, speed, 0, 0, 0)
            New(class["bullet0-1pendulum"], ball_huge, 2, x, y, 280, range, speed, 0, 0, 0)
            for i = 1, 13 do
                New(class["bullet0-1pendulum"], ellipse, 14, x, y, i * 20, range, speed, 0, 0, 0)
            end
            for i = 1, 12 do
                New(class["bullet0-1pendulum"], ball_big, 14, x, y, 280, range, speed, 36, i * 30, 1)
            end
            for i = 1, 16 do
                New(class["bullet0-1pendulum"], ball_big, 14, x, y, 280, range, speed, 230, i * 360/16, -0.4)
            end
        end
        task.New(self, function()
            while true do
                task.Wait(60)
                for a = 45, 360, 45 do
                    New(class["laser0-2"], self.x + cos(a) * 50, self.y + sin(a) * 50, a)
                    a = a + 22.5
                    New(class["laser0-2"], self.x + cos(a) * 50, self.y + sin(a) * 50, a + 180)
                end
                task.Wait(70)
                task.MoveToPlayer(80, -150, 0, 100, 140, 40, 80, 16, 32, 2, 1)
            end
        end)
    end
    sc1.frame = boss.card.PublicHP

    function sc2:before()
        FullScreen()
        task.MoveTo(40, 120, 60, 2)
    end
    function sc2:init()
        task.New(self, function()
            local d = 1
            while true do
                task.Wait(30)
                boss.cast(self, 60)
                for c = 1, 2 do
                    for a = 1, 30 do
                        New(class["bullet0-2Rose"], self.x, self.y, int(a / 2) % 2 * 4 + 2, 1.3 + c * 0.8, a * 12 + c * 18 * d, a % 2)
                    end
                end
                task.Wait(100)
                task.MoveToPlayer(80, 0, 150, 100, 140,
                        40, 80, 16, 32, 2, 1)
            end
        end)
    end
    sc2.frame = boss.card.PublicHP
end--boss5

do
    boss.Define("6a", "博丽灵梦", "TH12_5_0", TH125_bg, { 0, 400 }, class["SCBG3"], "Reimu", 9)
    boss.Define("6b", "雾雨魔理沙", "TH12_5_0", TH125_bg, { 0, 400 }, class["SCBG3"], "Marisa", 9)
    boss.Define("6c", "东风谷早苗", "TH12_5_0", TH125_bg, { 0, 400 }, class["SCBG3"], "Sanae", 9)
    local name = "「妖魔鬼怪快离开」"
    local sc1 = boss.card.New(name, 1, 1, 60, 1000)
    local sc2 = boss.card.New(name, 1, 1, 60, 1000)
    local sc3 = boss.card.New(name, 1, 1, 60, 1000)
    boss.card.add({ { sc1, "6a" }, { sc2, "6b" }, { sc3, "6c" } }, 9, name, 92)

    function sc1:before()
        FullScreen()
        task.MoveTo(-80, 120, 60, 2)
    end
    function sc1:init()
        local way = Class(object, {
            init = function(self, x, y, v, a, tr, tl, d)
                self.x, self.y = x, y
                self.group = GROUP.INDES
                task.New(self, function()
                    object.SetV(self, v, a + 90 * d, true)
                    task.Wait(tr / 2)
                    while true do
                        object.SetV(self, v, a, true)
                        task.Wait(tl)
                        d = -d
                        object.SetV(self, v, a + 90 * d, true)
                        task.Wait(tr)
                    end
                end)
                task.New(self, function()
                    local V = 2
                    local b
                    local player = player
                    while true do
                        if Dist(self, player) > 48 then
                            PlaySound("tan00")
                            b = Create.bullet_accel(self.x, self.y, square, 2, 0.5, V, a, nil, false, 60, 40)
                            bullet.SetLayer(b, LAYER.ENEMY_BULLET - 1)
                        end
                        V = max(0.1, V + 0.03)
                        task.Wait()
                    end
                end)
            end,
            frame = task.Do }, true)
        task.New(self, function()
            local d = 1
            while true do
                Newcharge_out(self.x, self.y, 128, 32, 32)
                boss.cast(self, 60)
                local a = Angle(self, player)
                for i = -1, 1 do
                    New(way, self.x, self.y, 14, i * 45 + a, 8, 5, d)
                end
                task.Wait(90)
                local h, v = 1, 1
                for _ = 1, 11 do
                    self.vscale = v
                    self.hscale = h
                    task.Wait()
                    h = h - 1 / 10
                    v = v + 0.8 / 10
                end
                self.x = -self.x
                h, v = 0, 1.8
                task.New(self, function()
                    for _ = 1, 11 do
                        self.vscale = v
                        self.hscale = h
                        task.Wait()
                        h = h + 1 / 10
                        v = v - 0.8 / 10
                    end
                end)
                task.MoveToPlayer(60, -200, 200, 100, 140, 60, 70, 16, 32, 2, 3)
                task.Wait(90)
                d = -d
            end
        end)
    end
    sc1.frame = boss.card.PublicHP

    function sc2:before()
        FullScreen()
        task.MoveTo(0, 190, 60, 2)
    end
    function sc2:init()
        task.New(self, function()
            boss.cast(self, 66666)
            local d = 1
            while true do
                for l = 1, 5 do
                    for i = 20, 360, 20 do
                        New(class["bullet0-3polar"], self.x, self.y, l % 2 * 6 + 8, 1, i, l * 12, d * 0.3)
                    end
                end
                for l = 1, 3 do
                    for i = 20, 360, 20 do
                        New(class["bullet0-3polar"], self.x, self.y, l % 2 * 4 + 6, 0.6, i, l * 8.3, -d * 0.1)
                    end
                end
                PlaySound("tan00")
                d = -d
                task.Wait(160)
            end
        end)
    end
    sc2.frame = boss.card.PublicHP

    function sc3:before()
        FullScreen()
        task.MoveTo(0, 80, 60, 2)
    end
    function sc3:init()
        self.group = GROUP.NONTJT
        New(class["object0-2"], self.x, self.y)
        task.New(self, function()
            boss.cast(self, 90)
            task.Wait(120)
            while true do
                boss.cast(self, 190)
                task.Wait(190)
                task.MoveToPlayer(80, -50, 160, 60, 100, 20, 40, 16, 32, 2, 1)
                task.Wait(30)
            end
        end)
    end
    sc3.frame = boss.card.PublicHP
end--boss6

do
    boss.Define("7a", "姬海棠果", "TH12_5_0", TH125_bg, { 0, 400 }, class["SCBG4"], "Hatate", 9)
    local non_sc = boss.card.New("", 1, 1, 45, 800)
    function non_sc:before()
        FullScreen()
        task.MoveTo(0, 120, 60, 2)
    end
    function non_sc:init()
        local ball_circle = Class(object, {
            init = function(self, x, y, v, a, r, o, init_s, inc_s)
                self.x, self.y = x, y
                object.SetV(self, v, a, true)
                self.group = GROUP.INDES
                self.colli = false
                local b
                for i = 360 / 7, 361, 360 / 7 do
                    b = NewSimpleBullet(ball_mid_c, 10, self.x + cos(i) * r * sin(init_s), self.y + sin(i) * r * sin(init_s),
                            nil, nil, nil, nil, false)
                    b.init_s = init_s
                    b.inc_s = inc_s
                    b.rot = i
                    b.omiga = o
                    b.master = self
                    b.frame_other = function(unit)
                        if not IsValid(unit.master) then
                            object.Del(unit)
                            return
                        end
                        unit.init_s = unit.init_s + unit.inc_s
                        unit.x = unit.master.x + cos(unit.rot) * r * sin(unit.init_s)
                        unit.y = unit.master.y + sin(unit.rot) * r * sin(unit.init_s)
                    end
                end
            end
        }, true)
        task.New(self, function()
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            task.New(self, function()
                task.Wait(30)
                while true do
                    local A = Angle(self, player)
                    for v = 1, 3 do
                        for a = 15, 360, 15 do
                            NewSimpleBullet(ellipse, 2, self.x, self.y, 1.5 + v * 0.3, a + v * 7.5 + A)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(100)
                end
            end)
            task.New(self, function()
                task.Wait(120)
                local rot = 0
                while true do
                    for i = 90, 360, 90 do
                        New(ball_circle, self.x, self.y, 2, i + rot, 30, ran:Sign(), ran:Int(1, 360), ran:Float(0.5, 1.2))
                    end
                    PlaySound("kira00")
                    rot = rot + 20
                    task.Wait(25)
                end
            end)
            local d = 1
            while true do
                boss.cast(self, 66)
                Newcharge_out(self.x, self.y, 250, 128, 114)
                for r = 30 * d, -30 * d, -d do
                    for a = 45, 360, 45 do
                        NewSimpleBullet(ball_mid_c, 6, self.x + cos(a) * r * 6, self.y + sin(a) * r * 6,
                                4 - r % 2, -90 + r * 8, nil, nil, false)
                        NewSimpleBullet(ball_mid_c, 2, self.x + cos(a) * r * 6, self.y + sin(a) * r * 6,
                                5 + r % 2, -90 - r * 8, nil, nil, false)
                    end
                    PlaySound("tan00")
                    task.Wait(2)
                end
                task.Wait(90)
                task.MoveToPlayer(60, -180, 180, 100, 140,
                        20, 40, 16, 32, 2, 1)
                task.Wait(60)
            end
        end)
    end
    boss.card.add({ { non_sc, "7a" } }, 9, "非符", 93)

    local sc = boss.card.New("念写「见光死的狗仔队」", 2, 4, 45, 850)
    function sc:before()
        FullScreen()
        if ext.sc_pr then
            task.MoveTo(0, 120, 60, 2)
        else
            task.Wait(60)
        end
    end
    function sc:init()
        task.New(self, function()
            task.MoveTo(0, 100, 60, 2)
            Newcharge_in(self.x, self.y, 32, 32, 128)
            task.Wait(60)

            task.New(self, function()
                local d = 1
                while true do
                    for a = 45, 360, 45 do
                        object.Connect(self, New(class["object0-3photo"], self, self.x, self.y, 1.8, a, 0.3 * d))
                    end
                    d = -d
                    task.Wait(60)
                    local b
                    local A = Angle(self, player)
                    for v = 1, 2 do
                        for a = -90, 90, 2 do
                            b = NewSimpleBullet(arrow_big, ({ 8, 4 })[int(a / 10) % 2 + 1], self.x, self.y, 0.6 + v * 0.2, a + v * 5 + A)
                            b.timer = 11
                            b._blend = "mul+add"
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(100)
                end
            end)
        end)
    end
    boss.card.add({ { sc, "7a" } }, 9, "念写「见光死的狗仔队」", 94)
end--boss7