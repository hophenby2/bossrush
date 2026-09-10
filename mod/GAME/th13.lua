local class = {}
_editor_class["TH13"] = class
local UnlockOD = boss.card.UnlockOD

local cos, sin, abs, min, max, int, sign = cos, sin, abs, min, max, int, sign
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
        _SC_BG.AddLayer(self, "th07_5", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
        _SC_BG.AddLayer(self, "th07_6", true, -128, 0, 0, 0, 1, 0, "", 1, 1)
    end
    class["SCBG2"] = Class(_SC_BG)
    class["SCBG2"].init = function(self)
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th12_2", true, 0, 0, 0, 0, 1.2, 0, "mul+add")
        b.a = 150
        b = _SC_BG.AddLayer(self, "th13_1", true, 0, 0, 0, 0, 1, 0, "")
        b.a = 150
        b.Beforeframe = function(self)
            self.a = 100 + 80 * sin(self.timer)
            self.r = 150 + 50 * sin(self.timer * 1.5)
            self.g = 150 + 50 * sin(self.timer / 2)
        end
        b.Afterrender = function(self)
            _SC_BG.PolarCoordinatesRender("th13_1", 0, 50, 0, 400,
                    -self.timer / 4, 512, 4, -self.timer / 2,
                    "", Color(self._cur_alpha * (255 - self.a), 255, self.g, self.b))
        end
        b = _SC_BG.AddLayer(self, "th12_3", false, 0, 224, 0, 0, 0, 0.1, "mul+add", 2, 2)
        b.a = 160
        b = _SC_BG.AddLayer(self, "th12_3", false, 0, -224, 0, 0, 0, 0.1, "mul+add", 2, 2)
        b.a = 160

        _SC_BG.AddLayer(self, "th13_0")
    end
    class["SCBG3"] = Class(_SC_BG)
    class["SCBG3"].init = function(self)
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th13_3", true, 0, 0, 40, -0.8, 0.8, 0, "mul+rev", 0.8, 0.8)
        b.r, b.g, b.b = 150, 150, 150
        b = _SC_BG.AddLayer(self, "th13_3", true, 0, 0, 40, -1, 1, 0, "mul+add")
        b.Beforeframe = function(self)
            self.r = 150 + sin(self.timer / 2) * 100
            self.g = 150 + cos(self.timer) * 100
            self.b = 150 + cos(self.timer / 3) * 100
        end
        b = _SC_BG.AddLayer(self, "th13_5", true, 0, 0, 40, 0, -2, 0, "mul+add")
        b.a = 100
        b.Beforeframe = function(self)
            self.r = 150 + sin(self.timer / 4) * 100
            self.g = 150 + cos(self.timer / 2) * 100
            self.b = 150 + cos(self.timer / 6) * 100
        end
        b = _SC_BG.AddLayer(self, "th13_2")
        b.a = 100
        _SC_BG.AddLayer(self, "th13_4", false, 0, 0, 0, 0, 0, 0.3)

    end
    class["SCBG4"] = Class(_SC_BG)
    class["SCBG4"].init = function(self)
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th13_7", true, 0, 0, 0, 0.4, -0.4, 0, "mul+rev")
        b.a = 180
        b.Beforeframe = function(self)
            self.r = 150 + sin(self.timer / 2) * 100
            self.g = 150 + cos(self.timer / 5) * 100
            self.b = 150 + cos(self.timer / 3) * 100
        end
        _SC_BG.AddLayer(self, "th13_6", true, 0, 0, 0, 0, 0.8)
    end
    class["SCBG5"] = Class(_SC_BG)
    class["SCBG5"].init = function(self)
        _SC_BG.init(self)
        local b

        b = _SC_BG.AddLayer(self, "th13_8", true, 0, 0, 0, 0, 1.9, 0, "mul+rev")
        b.a = 190
        b.r = 100
        _SC_BG.AddLayer(self, "th13_9")
        b = _SC_BG.AddLayer(self, "th13_8", true, 0, 0, 0, 0, 0.8)

    end
    class["SCBG6"] = Class(_SC_BG)
    class["SCBG6"].init = function(self)
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th12_13", true, 0, 0, 0, 1.5, -0.5)
        b.Beforeframe = function(self)
            self.a = 150 + sin(self.timer / 3) * 80
        end
        b = _SC_BG.AddLayer(self, "th12_13", true, 0, 0, 0, -1, -0.5, 0, "", -1, 1)
        b.Beforeframe = function(self)
            self.a = 150 + sin(self.timer / 3) * 80
        end
        b = _SC_BG.AddLayer(self, "img_void")
        b.Beforerender = function(self)
            _SC_BG.PolarCoordinatesRender("th13_11", 83, 120, 0, 460,
                    0, 512, 1.8, -self.timer * 4,
                    "mul+rev", Color(0, 128, 255, 255),
                    Color(self._cur_alpha * 255, 128, 255, 255))
        end

        b = _SC_BG.AddLayer(self, "th12_12")
        b.a = 90
        _SC_BG.AddLayer(self, "th13_10")
    end
end--_SC_BG

do
    class["object0-1ReboundBoard"] = Class(object, {
        init = function(self, x, y, v, a, index, time)
            self.x, self.y = x, y
            self.colli = false
            self.group = GROUP.INDES
            self.layer = LAYER.ENEMY_BULLET
            self.bound = false
            object.SetV(self, v, a, true)
            self.angle = self.rot + 90
            self._a = 0
            self.index = index
            self.color = ColorList[math.ceil(index / 2)]
            PlaySound("ch00")
            task.New(self, function()
                for i = 1, 60 do
                    self._a = sin(i * 1.5)
                    task.Wait()
                end
                task.Wait(time)
                for i = 59, 0, -1 do
                    self._a = sin(i * 1.5)
                    task.Wait()
                end
                object.Del(self)
            end)
        end,
        frame = function(self)
            task.Do(self)
            local x, y
            object.BulletDo(function(unit)
                if unit._index ~= self.index and unit._index ~= 16 then
                    if not unit.angle then
                        unit.angle = unit.rot
                    end
                    x = unit.x - self.x
                    y = unit.y - self.y
                    x, y = x * cos(self.angle) + y * sin(self.angle), y * cos(self.angle) - x * sin(self.angle)
                    if abs(y) < 8 then
                        unit.angle = unit.angle - 2 * (unit.angle - self.rot) + 180
                        local l = 8 - abs(y)
                        unit.x = unit.x + cos(unit.angle) * l
                        unit.y = unit.y + sin(unit.angle) * l
                    end
                end
            end)
        end,
        render = function(self)
            OriginalSetImageState("white", "mul+add",
                    Color(self._a * 100, unpack(self.color)), Color(0, unpack(self.color)),
                    Color(0, unpack(self.color)), Color(self._a * 100, unpack(self.color)))
            Render("white", self.x + cos(self.rot) * 16, self.y + sin(self.rot) * 16, self.rot, 2, 600 / 8)
            Render("white", self.x + cos(self.rot + 180) * 16, self.y + sin(self.rot + 180) * 16, self.rot + 180, 2, 600 / 8)
            SetImageState("white", "mul+add", self._a * 200, unpack(self.color))
            Render("white", self.x, self.y, self.rot, 0.2, 600 / 8)
        end
    })
    class["object0-2BalanceCircle"] = Class(enemy, {
        init = function(self, x, y, mx, master, percent, sx, sy)
            self.x, self.y = x, y
            self.bound = false
            self.CD = 80
            self._no_drop_astral = true
            self.percent = percent or 25
            self.sx, self.sy = sx, sy
            enemybase.init(self, 11451419)
            self.layer = LAYER.ENEMY + 1
            if IsValid(master) then
                object.Connect(master, self, 0.6, true)
            end
            self.a, self.b = 0, 0
            task.New(self, function()
                task.MoveTo(mx, 0, 60, 2)
            end)
            task.New(self, function()
                for i = 1, 60 do
                    self.a = sin(i * 1.5) * 45
                    self.b = self.a
                    task.Wait()
                end
            end)
        end,
        frame = function(self)
            enemybase.frame(self)
            local flag
            if self.y > 200 then
                self.vy = min(-1, -self.vy)
                self.y = 400 - self.y
                flag = true
            end
            if self.y < -200 then
                self.vy = max(1, -self.vy)
                self.y = -400 - self.y
                flag = true
            end
            if flag and self.CD == 0 then
                if self.has_boss then
                    for a = 6, 360, 6 do
                        for v = 1, 3 do
                            Create.bullet_accel((self.sx or self.x) + cos(a) * self.a, (self.sy or self.y) + sin(a) * self.b, grain_b, 10, 0.5, v, a + v * 3)
                        end
                    end
                else
                    for a = 12, 360, 12 do
                        Create.bullet_accel((self.sx or self.x) + cos(a) * self.a, (self.sy or self.y) + sin(a) * self.b, grain_b, 10, 0.5, 2, a)
                    end
                end
                PlaySound("kira00")
                self.CD = 80
            end
            self.CD = max(0, self.CD - 1)
        end,
        colli = function(self, other)
            enemy.colli(self, other)
            if other.dmg then
                local dmg = other.dmg
                self.y = self.y + dmg
                self.vy = max(0, self.vy + 0.02 / self.percent)
                if IsValid(self.other) then
                    self.other.y = self.other.y - dmg
                    self.other.vy = min(0, self.other.vy - 0.02 / self.percent)
                end
            end
        end,
        render = function(self)
            SetImageState("circle_charge", "mul+add", 255, 189, 252, 201)
            Render("circle_charge", self.x, self.y, 0, self.a / 256)
        end,
        del = function()
        end,
        kill = function()
        end
    })
    class["MikoBack"] = Class(object, {
        init = function(self, master, rot, d, wait, color, alphaer, offx, offy)
            self.master = master
            d = d or 1
            self.rot = rot - 90 * d
            self.bound = false
            self.group = GROUP.GHOST
            self.layer = LAYER.ENEMY - 2
            self.color = color or { 255, 255, 255 }
            self.offx, self.offy = offx or 0, offy or 0
            self.x = self.master.x + self.offx
            self.y = self.master.y + self.offy
            self.scale = 0
            self.alpha = 0
            self.alphaer = alphaer or 1
            self.ss = 0
            task.New(self, function()
                task.Wait(wait or 0)
                PlaySound("kira00")
                local Smooth = task.Smooth
                for i = 1, 60 do
                    i = i / 60
                    i = i * 2 - i * i
                    self.rot = rot - 90 * d + 90 * i * d
                    self.scale = i
                    self.alpha = i * 128
                    task.Wait()
                end
                for i = 1, 80 do
                    i = Smooth(i / 80)
                    self.ss = -20 * i
                    self.alpha = 128 - 32 * i
                    task.Wait()
                end
                while true do
                    for i = 1, 80 do
                        i = Smooth(i / 80)
                        self.ss = -20 + 40 * i
                        self.alpha = 96 + 32 * i
                        task.Wait()
                    end
                    for i = 1, 80 do
                        i = Smooth(i / 80)
                        self.ss = 20 - 40 * i
                        self.alpha = 128 - 32 * i
                        task.Wait()
                    end
                end
            end)
        end,
        del = function(self)
            enemy.death_ef(self.x, self.y, 10, 1)
        end,
        kill = function(self)
            self.class.del(self)
        end,
        frame = function(self)
            if not IsValid(self.master) then
                object.Del(self)
                return
            end
            task.Do(self)
            self.x = self.master.x + self.offx
            self.y = self.master.y + self.offy
        end,
        render = function(self)
            Set3Dwithmode('world')
            local p0, p1, p2, p3 = CalculatePosition(self.ss * sin(self.rot), self.ss * cos(self.rot), self.rot, 0, 1, -0.5, 0.5)
            SetImageState("miko_back", "mul+add", self.alpha * self.alphaer, unpack(self.color))
            local x, y = WorldToBillBoard(self.x), WorldToBillBoard(self.y)
            Render4V("miko_back",
                    x + self.scale * p0[1], y + self.scale * p0[2], self.scale * p0[3],
                    x + self.scale * p1[1], y + self.scale * p1[2], self.scale * p1[3],
                    x + self.scale * p2[1], y + self.scale * p2[2], self.scale * p2[3],
                    x + self.scale * p3[1], y + self.scale * p3[2], self.scale * p3[3]
            )
            SetViewMode("world")
        end
    })
    class["FutoBoat"] = Class(object, {
        init = function(self, x, y, master)
            self.img = "Boat"
            self.master = master
            self.x, self.y = master.x + x, master.y + y
            self.group = GROUP.GHOST
            self.layer = LAYER.ENEMY - 10
            self.bound = false
            task.New(self, function()
                task.MoveTo(master.x, master.y - 40, 60, 2)
                self.lock = true
            end)
        end,
        frame = function(self)
            if not IsValid(self.master) then
                object.Del(self)
                return
            end
            task.Do(self)
            self.hscale = sign(self.master.lr)
            if self.lock then
                self.x = self.master.x
                self.y = self.master.y - 40
            end
        end,
        del = function(self)
            enemy.death_ef(self.x, self.y, 10, 1)
        end,
        kill = function(self)
            self.class.del(self)
        end,
    })
    LoadTexture("Ningen", "mod\\GAME\\Ningen.png")
    LoadAnimation("Ningen1", "Ningen", 0, 0, 32, 32, 3, 1, 8, 8, 8)
    LoadAnimation("Ningen2", "Ningen", 0, 32, 32, 32, 3, 1, 8, 16, 16)
    class["Human"] = Class(object, {
        init = function(self, x, vy, target, offx)
            self.x = x
            self.y = 250
            self.vy = vy
            self.group = GROUP.ENEMY_BULLET
            self.img = "Ningen1"
            self.layer = LAYER.ENEMY_BULLET - 1
            self.human = true
            task.New(self, function()
                while self.img == "Ningen2" or not self.jump do
                    task.Wait()
                end
                self.a, self.b = 14, 14
                self.hscale, self.vscale = 1.75, 1.75
                PlaySound("kira01")
                Create.bullet_create_eff(self.x, self.y, ball_big, 6, self.vy, 90, true)
                task.MoveToEx(offx, 0, 60, 2)
            end)
            task.New(self, function()
                while self.jump or (IsValid(target) and self.y > target.ty) do
                    task.Wait()
                end
                PlaySound("kira00")
                self.img = "Ningen2"
                self.hscale = 2
                self.vscale = 2
                Create.bullet_create_eff(self.x, self.y, ball_big, 2, self.vy, 90, true)
                task.MoveToEx(offx, 0, 300, 0)
            end)
        end,
        frame = function(self)
            task.Do(self)
        end,
        del = function(self)
            enemy.death_ef(self.x, self.y, 10, (self.img == "Ningen1") and 3 or 1)
        end,
        kill = function(self)
            self.class.del(self)
        end,
    })
end--object

do
    boss.Define("1a", "西行寺幽幽子", "TH13_0", TH13_bg, { 300, -100 }, class["SCBG1"], "Yuyuko", 11)
    local nonsc = boss.card.New("", 1, 1, 45, 700)
    function nonsc:before()
        task.New(self, function()
            boss.show_aura(self, false)
            task.Wait(140)
            boss.cast(self, 60)
            boss.show_aura(self, true)
            task.Wait(60)
        end)
        task.MoveTo(-90, 0, 100, 2)
        task.MoveTo(0, 120, 100, 3)
    end
    function nonsc:init()
        task.New(self, function()
            local d = 1
            local sty = { sakura, grain_a }
            while true do
                boss.cast(self, 600)
                Newcharge_out(self.x, self.y, 218, 112, 214)
                task.New(self, function()
                    for _ = 1, 6 do
                        for _ = 1, 8 do
                            sakura_big.New(self.x, self.y, ran:Float(0, 360), ran:Sign() * 2,
                                    ran:Float(1.5, 2.3), ran:Float(20, 160),
                                    function(self)
                                        self.may = -0.02
                                    end)
                        end
                        PlaySound("kira00")
                        task.Wait(20)
                    end
                end)
                task.New(self, function()
                    for j = 1, 2 do
                        for a = 18, 360, 18 do
                            for z = -1, 1, 2 do
                                a = a + j * 30 * d
                                Create.bullet_changeangle(self.x, self.y, butterfly, 2, 1.5, a, false, { r = z, time = 90 })
                            end
                        end
                        PlaySound("tan00")
                        task.Wait(60)
                    end
                end)
                local a
                for i = 1, 60 do
                    for z = -5, 5 do
                        a = 90 + 90 * d + i * 3 * d + z * 6
                        Create.bullet_changeangle(self.x + cos(a) * 30, self.y + sin(a) * 30, sty[int(z + 4) % 2 + 1], 4, 2, a, false,
                                { r = 5 * d, time = i * 2, wait = 10 }, { v = 2 + sin(i * 10.5) - i / 120, time = 30 })
                    end
                    PlaySound("tan00")
                    task.Wait(2)
                end
                task.Wait(60)
                task.MoveToPlayer(60, -96, 96, 120, 144, 20, 40, 16, 32, 2, 1)
                d = -d
                task.Wait(60)
            end
        end)
    end
    boss.card.add({ { nonsc, "1a" } }, 11, "非符", 99)

    local sc = boss.card.New("「桜吹雪～千年の恋をしました」", 2, 2, 45, 800)
    function sc:before()
        if ext.sc_pr then
            task.MoveTo(0, 120, 60, 2)
        else
            task.Wait(60)
        end
    end
    function sc:init()
        UnlockOD(self, 1)
        local polar = Class(bullet, { init = function(self, x, y, a, r, l, v, t)
            bullet.init(self, ball_mid, 4, false, true)
            self._blend = "mul+add"
            self.x, self.y = x + cos(a) * l, y + sin(a) * l
            PlaySound("kira00")
            task.New(self, function()
                while true do
                    self.x = x + cos(a) * l
                    self.y = y + sin(a) * l
                    self.rot = a
                    a = a + r
                    l = l + v

                    task.Wait()
                end
            end)
            task.New(self, function()
                task.Wait(t)
                Create.laser_line(self.x, self.y, 4, 9, Angle(player, self), 30, 8, 8)
                Create.bullet_accel(self.x, self.y, ball_mid, 2, 0.5, 6, self.rot, true)
            end)
        end }, true)
        task.New(self, function()
            self.fan = New(_editor_class["TH07"]["fan"], self)
            task.MoveTo(0, 50, 60, 2)
            boss.cast(self, 3120)
            Newcharge_in(self.x, self.y, 128, 32, 32)
            task.Wait(60)
            task.New(self, function()
                local d = 1
                local rot = 0
                local time = 300
                while true do
                    for i = 30, 360, 30 do
                        New(polar, 0, 50, i + rot * d, 0.1 * d, 0, 1.1, time)
                    end
                    d = -d
                    rot = rot + 2
                    if time == 60 then
                        Newcharge_in(self.x, self.y, 250, 128, 114)
                    end
                    if time == 0 then
                        time = 320
                    end
                    time = time - 20
                    task.Wait(20)
                end
            end)
            task.Wait(120)
            task.New(self, function()
                while true do
                    local A = Angle(self, player) + ran:Float(-20, 20)
                    for i = 1, 121 do
                        NewSimpleBullet(sakura, 4, self.x, self.y, 1.5, A + 10 + 340 / 120 * (i - 1))
                    end
                    PlaySound("tan00")
                    task.Wait(90)
                end
            end)
            task.MoveTo(0, 120, 90, 3)
        end)
    end
    boss.card.add({ { sc, "1a" } }, 11, "「桜吹雪～千年の恋をしました」", 100)

    local sc_od = boss.card.New("「回レ! 雪月花-Overdrive」", 1, 1, 45, 600)
    function sc_od:before()
        task.MoveTo(0, 120, 60, 2)
    end
    function sc_od:init()
        local polar = Class(bullet, { init = function(self, x, y, a, r, l, v, t)
            bullet.init(self, ball_mid, 4, false, true)
            self._blend = "mul+add"
            self.x, self.y = x + cos(a) * l, y + sin(a) * l
            PlaySound("kira00")
            task.New(self, function()
                while true do
                    self.x = x + cos(a) * l
                    self.y = y + sin(a) * l
                    self.rot = a
                    a = a + r
                    l = l + v

                    task.Wait()
                end
            end)
            task.New(self, function()
                task.Wait(t)
                Create.laser_line(self.x, self.y, 4, 9, Angle(self, player), 30, 8, 8)
                Create.bullet_dec_acc(self.x, self.y, ball_mid, 2, 3, 4, self.rot + 180, true)
            end)
        end }, true)
        task.New(self, function()
            local r = 0
            self.fan = New(_editor_class["TH07"]["fan"], self)
            task.MoveTo(0, 50, 60, 2)
            boss.cast(self, 3600)
            Newcharge_in(self.x, self.y, 128, 32, 32)
            task.Wait(60)
            task.New(self, function()
                local d = 1
                local time = 300
                while true do
                    for i = 18, 180, 18 do
                        New(polar, 0, 50, i + r, 0.1 * d, 0, 1.8, time)
                    end
                    d = -d
                    r = r + 9
                    if time == 60 then
                        Newcharge_in(self.x, self.y, 250, 128, 114)
                    end
                    if time == 0 then
                        time = 320
                    end
                    time = time - 20
                    task.Wait(20)
                end
            end)
            task.Wait(120)
            task.New(self, function()
                while true do
                    local A = r + 270 + ran:Float(-5, 5)
                    for i = 1, 121 do
                        NewSimpleBullet(sakura, 4, self.x, self.y, 2.5, A + 10 + 340 / 120 * (i - 1))
                    end
                    PlaySound("tan00")
                    task.Wait(90)
                end
            end)
        end)
    end
    boss.card.add({ { sc_od, "1a" } }, 11, "「回レ! 雪月花-Overdrive」", 101, 1)
end--boss1

do
    boss.Define("2a", "幽谷响子", "TH13_0", TH13_bg, { 0, 300 }, class["SCBG2"], "Kyouko", 11)
    boss.Define("2b", "多多良小伞", "TH13_0", TH13_bg, { 0, 300 }, class["SCBG2"], "Kogasa", 11)
    local name = "合力「彩虹音爆」"
    local color = { 4, 2, 14, 13, 10, 8, 6 }--紫红橙黄绿青蓝
    local sc1 = boss.card.New(name, 1, 1, 80, 820)
    local sc2 = boss.card.New(name, 1, 1, 80, 820)
    boss.card.add({ { sc1, "2a" }, { sc2, "2b" } }, 11, name, 102)

    function sc1:before()
        task.MoveTo(-60, 140, 60, 2)
    end
    function sc1:init()
        local w = 0
        local wait = 140
        local time = 240
        task.New(self, function()
            local dead = 0
            while dead < 5 do
                if player.death == 88 then
                    --为了确保检测得到，比90少点
                    dead = dead + 1
                end
                task.Wait()
            end
            ext.achievement:get(38)
        end)
        task.New(self, function()
            boss.violent(self)
            w = 3
            wait = 133
            time = 150
            UnlockOD(self, 2)
        end)
        task.New(self, function()
            while true do
                boss.cast(self, 600)
                local col = color[ran:Int(1, #color)]
                local b
                for i = 1, 4 do
                    for a = 18, 360, 18 do
                        for z = -w, w do
                            b = NewSimpleBullet(ball_mid, col + sign(abs(z)), self.x, self.y, 1.3, a + i * 9 + z * 2)
                            b.angle = a + i * 9 + z * 2
                            b.rot = 0
                            b.v = 1.3
                            b.frame_other = function(self)
                                object.SetV(self, self.v, self.angle)
                            end
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(30)
                end
                local A = Angle(self, player)
                for d = -1, 1, 2 do
                    New(class["object0-1ReboundBoard"], cos(A + 90 * d) * 140, sin(A + 90 * d) * 140, 0.2, A - 90 * d, col, time)
                end
                task.Wait(wait)
                task.Wait(154)
            end
        end)
    end

    function sc2:before()
        task.MoveTo(60, 140, 60, 2)
    end
    function sc2:init()
        local rainbow = Class(bullet, {
            init = function(self, x, y, id, v, a, ...)
                global_obj["bullet_changeangle"].init(self, x, y, grain_b, color[id], v, a, ...)
                bullet.SetLayer(self, LAYER.ENEMY_BULLET + 1)
                self._blend = "mul+add"
                self.bound = false
                self.rainbow = true
            end,
            frame = function(self)
                bullet.frame(self)
                if self.x > 224 or self.x < -224 then
                    object.RawDel(self)
                end
            end
        }, true)
        local p = -6.5
        task.New(self, function()
            local d = 1
            local key = { 1, 2, 3, 4, 5, 6, 7, 7, 6, 5, 4, 3, 2, 1 }
            while true do
                boss.cast(self, 600)
                Newcharge_in(self.x, self.y, 128, 32, 32)
                task.Wait(60)
                task.New(self, function()
                    for y = 18, -25, -1 do
                        for c = 6.5, p, -1 do
                            New(rainbow, -224 * d, y * 13 - c * 15, key[c + 7.5], 2, 90 - 70 * d, { r = -0.25 * d, time = 6660, wait = 0 })
                        end
                        task.Wait(8)
                    end
                end)
                task.Wait(236)
                for i = 6, 360, 6 do
                    NewSimpleBullet(ball_mid_c, 16, self.x, self.y, 1 + LineNum(i * 3) * 0.3, i)
                    NewSimpleBullet(ball_mid_c, 16, self.x, self.y, 1 - LineNum(i * 3) * 0.3, i)
                end
                PlaySound("tan00")
                task.Wait(60)
                task.MoveToPlayer(90, 30, 120, 90, 120,
                        20, 40, 16, 32, 2, 1)
                task.Wait()
                d = -d
            end
        end)
        task.New(self, function()
            boss.violent(self)
            UnlockOD(self, 2)
            p = -0.5
        end)
    end

    name = "合力「双虹音爆-Overdrive」"
    local sc_od1 = boss.card.New(name, 1, 1, 80, 900)
    local sc_od2 = boss.card.New(name, 1, 1, 80, 900)
    boss.card.add({ { sc_od1, "2a" }, { sc_od2, "2b" } }, 11, name, 103, 2)
    sc_od1.frame = boss.card.PublicHP
    sc_od2.frame = boss.card.PublicHP
    function sc_od1:before()
        task.MoveTo(-60, 140, 60, 2)
    end
    function sc_od1:init()
        local w = 2
        local wait = 140
        local time = 100
        task.New(self, function()
            local dead = 0
            while dead < 5 do
                if player.death == 88 then
                    --为了确保检测得到，比90少点
                    dead = dead + 1
                end
                task.Wait()
            end
            ext.achievement:get(38)
        end)
        task.New(self, function()
            while true do
                boss.cast(self, 600)
                local col = color[ran:Int(1, #color)]
                local b
                for i = 1, 8 do
                    for a = 18, 360, 18 do
                        for z = -w, w do
                            b = NewSimpleBullet(ball_mid, col, self.x, self.y, 2, a + i * 9 + z * 1.3)
                            b.angle = a + i * 9 + z * 1.3
                            b.rot = 0
                            b.v = 2
                            b.frame_other = function(self)
                                object.SetV(self, self.v, self.angle)
                            end
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(25)
                end
                local A = Angle(self, player)
                for d = -1, 1, 2 do
                    New(class["object0-1ReboundBoard"], cos(A + 90 * d) * 190, sin(A + 90 * d) * 190, 0.8, A - 90 * d, col, time)
                end
                task.Wait(wait)
                task.Wait(74)
            end
        end)
    end
    function sc_od2:before()
        task.MoveTo(60, 140, 60, 2)
    end
    function sc_od2:init()
        local rainbow = Class(bullet, {
            init = function(self, x, y, id, v, a, ...)
                global_obj["bullet_changeangle"].init(self, x, y, grain_b, color[id], v, a, ...)
                bullet.SetLayer(self, LAYER.ENEMY_BULLET + 1)
                self._blend = "mul+add"
                self.bound = false
                self.rainbow = true
            end,
            frame = function(self)
                bullet.frame(self)
                if self.x > 224 or self.x < -224 then
                    object.RawDel(self)
                end
            end
        }, true)
        task.New(self, function()
            local d = 1
            local key = { 1, 2, 3, 4, 5, 6, 7, 7, 6, 5, 4, 3, 2, 1 }
            while true do
                boss.cast(self, 600)
                Newcharge_in(self.x, self.y, 128, 32, 32)
                task.Wait(60)
                task.New(self, function()
                    for y = 18, -25, -1 do
                        for c = 6.5, -6.5, -1 do
                            New(rainbow, -224 * d, y * 13 - c * 15, key[c + 7.5], 3, 90 - 70 * d, { r = -0.375 * d, time = 6660, wait = 0 })
                        end
                        task.Wait(6)
                    end
                end)
                task.Wait(236)
                for i = 6, 360, 6 do
                    for v = 1, 2 do
                        NewSimpleBullet(ball_mid_c, 16, self.x, self.y, v + LineNum(i * 3) * 0.3, i)
                        NewSimpleBullet(ball_mid_c, 16, self.x, self.y, v - LineNum(i * 3) * 0.3, i)
                    end
                end
                PlaySound("tan00")
                task.Wait(60)
                task.MoveToPlayer(90, 30, 120, 90, 120, 20, 40, 16, 32, 2, 1)
                task.Wait()
                d = -d
            end
        end)
    end
end--boss2

do
    boss.Define("3a", "宫古芳香", "TH13_0", TH13_bg, { 300, 0 }, class["SCBG3"], "Yoshika", 11)
    boss.Define("3b", "霍青娥", "TH13_0", TH13_bg, { -200, 300 }, class["SCBG3"], "NyanNyan", 11)

    local name = "灵衡「阎罗殿的天平」"
    local servant
    local circle = {}
    local sc1 = boss.card.New(name, 1, 2, 60, 200)
    local sc2 = boss.card.New(name, 1, 2, 60, 600)
    boss.card.add({ { sc1, "3a" }, { sc2, "3b" } }, 11, name, 104)
    function sc1:before()
        servant = self
        self.__dieinstantly = true
        self.cannot_kill = true
        task.MoveTo(0, 0, 60, 2)
    end
    function sc1:init()
        task.New(self, function()
            while true do
                while not self.dead do
                    task.Wait()
                end
                self._wisys:SetImageInList("Yoshika_dead")
                self._wisys:SetFloat()
                boss.show_aura(self, false)
                while self.dead do
                    task.Wait()
                end
                self.DMG_factor = 1
                self._no_drop_astral = nil
                self._wisys:SetImageInList("Yoshika")
                self._wisys:SetFloat(function(ani)
                    return 0, sin(ani * 4) * 4
                end)
                self.hp = self.maxhp
                self.colli = true
                boss.show_aura(self, true)
                Newcharge_out(self.x, self.y, 250, 128, 114)
            end
        end)
        task.New(self, function()
            self._wisys:SetImageInList("Yoshika_dead")
            task.MoveTo(0, 100, 60, 2)
            task.Wait(60)
            Newcharge_out(self.x, self.y, 250, 128, 114)
            self._wisys:SetImageInList("Yoshika")
            sp:UnitListUpdate(circle)
            if #circle > 0 then
                task.New(self, function()
                    local rot, a = 0
                    while true do
                        task.Wait(180)
                        local wait = 25
                        while not self.dead do
                            for i = 120, 360, 120 do
                                for z = -1, 1 do
                                    a = i + rot + z * 2
                                    Create.bullet_decel(self.x + cos(a) * 20, self.y + sin(a) * 20, arrow_small, 2, 3, 1, a)
                                end
                            end
                            PlaySound("tan00")
                            rot = rot + 55
                            wait = max(3, wait - 0.6)
                            task.Wait(wait)
                        end
                        while self.dead do
                            task.Wait()
                        end
                    end
                end)
                local b = circle[self.Goto]
                task.MoveToTarget(b, 60, 2)
                b.has_boss = true
                while true do
                    self.x, self.y = b.x, b.y
                    b.ag = self.dead and -0.02 or 0.02
                    b.other.ag = -b.ag
                    if self.dead and (self.y > 140 or self.y < -140) then
                        self.resurrection = true
                        b.has_boss = nil
                        task.MoveTo(0, 100, 90, 2)
                        task.New(b, function()
                            task.MoveTo((task.GetSelf()).x, 0, 60, 2)
                        end)
                        task.New(b.other, function()
                            task.MoveTo((task.GetSelf()).x, 0, 60, 2)
                        end)
                        task.Wait(30)
                        self.Goto = self.Goto % 2 + 1
                        b = circle[self.Goto]
                        b.has_boss = true
                        self.dead = nil
                        self.resurrection = nil
                        task.MoveToTarget(b, 60, 2)
                    end
                    task.Wait()
                end
            end
        end)
    end
    function sc1:del()
        self.dead = true
        self.colli = false
        PlaySound("enep01", 0.2, self.x / 256, true)
        New(boss_explode_cherry, self.x, self.y)
        self.hp = 1
        self.DMG_factor = 0
        self._no_drop_astral = true
    end

    function sc2:before()
        self.effect = { alpha = 0, ps = {}, arg = false }
        self.__dieinstantly = true
        task.MoveTo(0, 140, 60, 2)
    end
    function sc2:init()
        UnlockOD(self, 3)
        local sp = sp
        local Set = { {}, {} }
        local pointer = Class(bullet, {
            init = function(self, set, t)
                bullet.init(self, ball_mid, 10, false, false)
                self._blend = "mul+add"
                self.t = t
                self.set = set
                self.x, self.y = unpack(Set[self.set][self.t])
            end,
            frame = function(self)
                bullet.frame(self)
                self.x, self.y = unpack(Set[self.set][self.t])
            end
        }, true)
        local w, wait = 0, 40
        task.New(self, function()
            task.Wait(60)
            boss.cast(self, 3600)
            if IsValid(servant) then
                servant.Goto = ran:Int(1, 2)
            end
            Newcharge_in(self.x, self.y, 200, 50, 50)
            local c1 = New(class["object0-2BalanceCircle"], self.x, self.y, -150, servant)
            local c2 = New(class["object0-2BalanceCircle"], self.x, self.y, 150, servant)
            c1.other = c2
            c2.other = c1
            table.insert(circle, c1)
            table.insert(circle, c2)
            Set[1] = sp:GetPointLine(20, self.x, self.y, c1.x, c1.y)
            Set[2] = sp:GetPointLine(20, self.x, self.y, c2.x, c2.y)
            task.New(self, function()
                while true do
                    Set[1] = sp:GetPointLine(20, self.x, self.y, c1.x, c1.y)
                    Set[2] = sp:GetPointLine(20, self.x, self.y, c2.x, c2.y)
                    task.Wait()
                end
            end)
            for i = 1, 20 do
                for z = 1, 2 do
                    New(pointer, z, i)
                end
            end
            task.Wait(60)
            self.effect.arg = true
            for i = 1, 60 do
                self.effect.alpha = sin(i * 1.5)
                task.Wait()
            end
            local d = 1
            while true do
                if not servant.resurrection then
                    local A = Angle(self, player)
                    for i = 1, 30 do
                        for z = -w, w do
                            NewSimpleBullet(ball_mid, 16, self.x, self.y, 2.5 + w * 0.3 + abs(z) * 0.05 * d, i * 12 + A + z)
                        end
                    end
                    PlaySound("tan00")
                    d = -d
                end
                task.Wait(wait)
            end
        end)
        task.New(self, function()
            while true do
                while IsValid(servant) and not servant.dead do
                    task.Wait()
                end
                w = 3
                wait = 18
                while IsValid(servant) and not servant.resurrection do
                    task.Wait()
                end
                w = 0
                wait = 40
                task.Wait(60)
                Newcharge_in(self.x, self.y, 189, 252, 201)
                task.Wait(60)
                while IsValid(servant) and servant.dead and servant.resurrection do
                    task.Wait()
                end
            end
        end)
    end
    function sc2:frame()
        if self.effect.arg then
            for y = -1, 1, 2 do
                table.insert(self.effect.ps, {
                    x = ran:Float(-192, 192),
                    y = 224 * y,
                    rot = ran:Float(0, 360),
                    alpha = 0,
                    scale = ran:Float(0.6, 1),
                    vy = -ran:Float(0.8, 2) * y,
                    timer = 0 })
            end
        end
        local p
        for i = #self.effect.ps, 1, -1 do
            p = self.effect.ps[i]
            p.y = p.y + p.vy
            p.rot = p.rot + 3
            if p.timer < 10 then
                p.alpha = min(p.alpha + 15, 150)
            else
                p.alpha = max(0, p.alpha - 8)
                if p.alpha == 0 then
                    table.remove(self.effect.ps, i)
                end
            end
            p.timer = p.timer + 1
        end
    end
    function sc2:render()
        if self.effect.alpha > 0 then
            for _, s in ipairs(self.effect.ps) do
                SetImageState("white", "mul+add", self.effect.alpha * s.alpha / 2, 250, 128, 114)
                Render("white", s.x, s.y, s.rot, s.scale)
                SetImageState("white", "mul+add", self.effect.alpha * s.alpha, 250, 128, 114)
                Render("white", s.x, s.y, s.rot, s.scale * 0.6)
            end
            OriginalSetImageState("white", "mul+add",
                    Color(self.effect.alpha * 255, 250, 128, 114),
                    Color(self.effect.alpha * 255, 250, 128, 114),
                    Color(0, 250, 128, 114),
                    Color(0, 250, 128, 114))
            RenderRect("white", -192, 192, 140, 224)
            RenderRect("white", -192, 192, -140, -224)
        end
    end
    function sc2:del()
        if IsValid(servant) then
            servant.cannot_kill = nil
            servant.hp = 0
        end
    end

    name = "灾衡「Invalid Astraea-Overdrive」"
    local sc_od1 = boss.card.New(name, 1, 2, 60, 150)
    local sc_od2 = boss.card.New(name, 1, 2, 60, 600)
    boss.card.add({ { sc_od1, "3a" }, { sc_od2, "3b" } }, 11, name, 105, 3)
    function sc_od1:before()
        servant = self
        self.__dieinstantly = true
        self.cannot_kill = true
        task.MoveTo(0, 0, 60, 2)
    end
    function sc_od1:init()
        task.New(self, function()
            self.w = 1
            self._wisys:SetImageInList("Yoshika_dead")
            task.MoveTo(0, 100, 60, 2)
            task.Wait(60)
            Newcharge_out(self.x, self.y, 250, 128, 114)
            self._wisys:SetImageInList("Yoshika")
            sp:UnitListUpdate(circle)
            if #circle > 0 then
                task.New(self, function()
                    local rot, a = 0
                    while true do
                        task.Wait(80)
                        local wait = 15
                        while not self.dead do
                            for z = -int(self.w), int(self.w) do
                                a = rot + z * 2
                                Create.bullet_decel(self.x + cos(a) * 20, self.y + sin(a) * 20, arrow_small, 2, 4, 2, a)
                            end
                            PlaySound("tan00", 0.1, self.x / 100, true)
                            rot = rot + 55
                            wait = max(2, wait - 0.3)
                            task.Wait(wait)
                        end
                        while self.dead do
                            task.Wait()
                        end
                    end
                end)
                local b = circle[self.Goto]
                task.MoveToTarget(b, 60, 2)
                b.has_boss = true
                while true do
                    self.x, self.y = b.x, b.y
                    --b.ag = self.dead and -0.05 or 0.05
                    --b.other.ag = -b.ag
                    task.Wait()
                end
            end
        end)
    end
    function sc_od1:frame()
        if not self.dead then
            if self.y > 140 or self.y < -140 then
                self.DMG_factor = 0.2
            else
                self.DMG_factor = 1
            end
        end
    end
    function sc_od1:del()
        self.dead = true
        self.colli = false
        PlaySound("enep01", 0.2, self.x / 256, true)
        New(boss_explode_cherry, self.x, self.y)
        Newcharge_out(self.x, self.y, 255, 255, 255)
        New(bullet_cleaner, self.x, self.y, 600, 50, 59)
        self.hp = 1
        self.DMG_factor = 0
        self._no_drop_astral = true
        self._wisys:SetImageInList("Yoshika_dead")
        self._wisys:SetFloat()
        boss.show_aura(self, false)
    end

    function sc_od2:before()
        self.__dieinstantly = true
        task.MoveTo(0, 140, 60, 2)
    end
    function sc_od2:init()
        UnlockOD(self, 3)
        local sp = sp
        local Set = { {}, {} }
        local pointer = Class(bullet, {
            init = function(self, set, t)
                bullet.init(self, ball_mid, 10, false, false)
                self._blend = "mul+add"
                self.t = t
                self.set = set
                self.x, self.y = unpack(Set[self.set][self.t])
            end,
            frame = function(self)
                bullet.frame(self)
                self.x, self.y = unpack(Set[self.set][self.t])
            end
        }, true)
        local w, wait = 1, 30
        task.New(self, function()
            task.Wait(60)
            boss.cast(self, 3600)
            servant.Goto = ran:Int(1, 2)
            Newcharge_in(self.x, self.y, 200, 50, 50)
            local c1 = New(class["object0-2BalanceCircle"], self.x, self.y, -150, servant, 1, 0, 0)
            local c2 = New(class["object0-2BalanceCircle"], self.x, self.y, 150, servant, 1, 0, 0)
            c1.other = c2
            c2.other = c1
            table.insert(circle, c1)
            table.insert(circle, c2)
            Set[1] = sp:GetPointLine(20, self.x, self.y, c1.x, c1.y)
            Set[2] = sp:GetPointLine(20, self.x, self.y, c2.x, c2.y)
            task.New(self, function()
                while true do
                    Set[1] = sp:GetPointLine(20, self.x, self.y, c1.x, c1.y)
                    Set[2] = sp:GetPointLine(20, self.x, self.y, c2.x, c2.y)
                    task.Wait()
                end
            end)
            for i = 1, 20 do
                for z = 1, 2 do
                    New(pointer, z, i)
                end
            end
            task.Wait(60)

            local d = 1
            while true do
                local A = Angle(self, player)
                for i = 1, 20 do
                    for z = -w, w do
                        NewSimpleBullet(ball_mid, 16, self.x, self.y, 2.5 + w * 0.3 + abs(z) * 0.05 * d, i * 18 + A + z)
                    end
                end
                if servant.dead then
                    w = 2.5
                end
                servant.w = servant.w + 0.2
                PlaySound("tan00")
                d = -d
                task.Wait(wait)
            end
        end)
    end
    function sc_od2:frame()
        if servant.dead then
            self.DMG_factor = 1
        else
            self.DMG_factor = 0.4
        end
    end
    function sc_od2:del()
        if IsValid(servant) then
            servant.cannot_kill = nil
            servant.hp = 0
        end
    end
end--boss3

do
    boss.DefineGroup({
        { id = "a", name = "苏我屠自古", x = 300, y = 300, img = "Toziko" },
        { id = "b", name = "物部布都", x = 300, y = 140, img = "Futo" },
    }, 4, "TH13_0", TH13_bg, class["SCBG4"], 11)
    local name = "神霄「八百蛟龙护南岳」"
    local sc1 = boss.card.New(name, 1, 1, 60, 750)
    local sc2 = boss.card.New(name, 2, 3, 60, 750)
    boss.card.add({ { sc1, "4a" }, { sc2, "4b" } }, 11, name, 106)
    function sc1:before()
        task.Wait(20)
        self.x, self.y = -120, 160
        Newcharge_out(self.x, self.y, 135, 206, 235, true)
        self.rot = -90
        self.hscale, self.vscale = 0.1, 1.3
        for i = 1, 40 do
            i = i / 40
            self.rot = -90 + 90 * (i * 2 - i * i * i)
            self.hscale = 0.1 + 0.9 * (i - 0.5) * 2
            self.vscale = 1.3 - 0.3 * i
            task.Wait()
        end
    end
    function sc1:init()
        local w, t, v = 12, 13, 0.5
        local maxba = 15
        task.New(self, function()
            boss.violent(self)
            w, t, v = 10, 18, 0.7
            maxba = 25
            UnlockOD(self, 4)
            task.Wait(60)
            while true do
                local A = Angle(self, player)
                for a = 1, 20 do
                    NewSimpleBullet(ball_mid_c, 16, self.x, self.y, 2, A + a * 18)
                end
                PlaySound("tan00")
                task.Wait(20)
            end
        end)
        task.New(self, function()
            task.Wait(60)
            local c = 0
            local d = 1
            local ba
            local function change(self)
                bullet.ChangeImage(self, arrow_mid, self._index + 2)
                Create.bullet_create_eff(self.x, self.y, arrow_mid, self._index, GetV(self))
            end
            while true do
                task.New(self, function()
                    for _ = 1, t do
                        ba = sin(c) * maxba
                        for a = 360 / w, 361, 360 / w do
                            for z = -1, 1 do
                                Create.bullet_dec_setangle(self.x, self.y, arrow_mid, 2,
                                        { v = 3, a = a, time = 40 },
                                        { v = 3, a = a + z * (40 + ba), time = 40, func = change },
                                        { v = 3, a = a - z * (20 + ba), time = 40, func = change },
                                        { v = 3, a = a + z * (30 + ba / 2), time = 40, func = change })
                            end
                        end
                        c = c + 7
                        task.Wait(140 / t)
                    end
                end)
                object.SetV(self, v, 90 - 90 * d)
                task.Wait(160)
                object.StopMoving(self)
                for i = 39, 0, -1 do
                    i = i / 40
                    self.rot = -90 + 90 * (i * 2 - i * i * i)
                    self.hscale = max(0, 0.1 + 0.9 * (i - 0.5) * 2)
                    self.vscale = 1.3 - 0.3 * i
                    task.Wait()
                end
                self.x = 120 * d
                Newcharge_out(self.x, self.y, 135, 206, 235)
                for i = 1, 40 do
                    i = i / 40
                    self.rot = -90 + 90 * (i * 2 - i * i * i)
                    self.hscale = 0.1 + 0.9 * (i - 0.5) * 2
                    self.vscale = 1.3 - 0.3 * i
                    task.Wait()
                end
                task.Wait(60)
                d = -d
            end
        end)
    end
    function sc1:frame()
        self.hscale = sign(self.lr) * abs(self.hscale)
    end

    function sc2:before()
        task.MoveTo(60, 140, 60, 2)
    end
    function sc2:init()
        local w = 1
        task.New(self, function()
            boss.violent(self)
            w = 2
            UnlockOD(self, 4)
        end)
        local YinYang = Class(object, {
            frame = task.Do,
            init = function(self)
                self.x, self.y = player.x, player.y
                self.group = GROUP.GHOST
                self.colli = false
                local b
                local d = 1
                self.new = function(x, y, _rot, __rot, frame)
                    for s = 1, 2 do
                        b = NewSimpleBullet(grain_a, 15, x, y)
                        b.group = GROUP.ENEMY
                        b._r = ({ 255, 0 })[(d + s) % 2 + 1]
                        b._g, b._b = b._r, b._r
                        b.stay = false
                        b.bound = false
                        b._rot = _rot
                        b.rot = b._rot
                        b.__rot = __rot
                        b.master = self
                        b.frame_other = frame
                        b.hscale = 1.4 - s * 0.3
                        b.colli = ({ true, false })[s]
                        b.vscale = b.hscale
                        PlaySound("tan00")
                    end
                    d = d % 2 + 1
                end
                task.New(self, function()
                    task.MoveTo(0, -50, 180, 3)
                end)
                task.New(self, function()
                    for i = 3, 180, 3 do
                        for a = 0, 180, 180 do
                            self.new(self.x + cos(i + a) * 180, self.y + sin(i + a) * 180, i + a, nil, function(self)
                                if not IsValid(self.master) then
                                    object.Del(self)
                                    return
                                end
                                local rot = self._rot + self.master.rot
                                self.x, self.y = self.master.x + cos(rot) * 180, self.master.y + sin(rot) * 180
                                self.rot = rot
                            end)
                        end
                        if i % 6 == 0 then
                            for a = 0, 180, 180 do
                                self.new(self.x + cos(a) * 90 + cos(i * 2 + a) * 30, self.y + sin(a) * 90 + sin(i * 2 + a) * 30, i * 2 + a, a, function(self)
                                    if not IsValid(self.master) then
                                        object.Del(self)
                                        return
                                    end
                                    local rot = self._rot + self.master.rot
                                    local rot2 = self.__rot + self.master.rot
                                    self.x, self.y = self.master.x + cos(rot2) * 90 + cos(rot) * 30, self.master.y + sin(rot2) * 90 + sin(rot) * 30
                                    self.rot = rot
                                end)
                            end
                        end
                        task.Wait()
                    end
                    for i = 6, 180, 6 do
                        for a = 0, 180, 180 do
                            self.new(self.x + cos(a) * 90 + cos(i + a) * 90, self.y + sin(a) * 90 + sin(i + a) * 90, i + a, a, function(self)
                                if not IsValid(self.master) then
                                    object.Del(self)
                                    return
                                end
                                local rot = self._rot + self.master.rot
                                local rot2 = self.__rot + self.master.rot
                                self.x, self.y = self.master.x + cos(rot2) * 90 + cos(rot) * 90, self.master.y + sin(rot2) * 90 + sin(rot) * 90
                                self.rot = rot
                            end)
                        end
                        task.Wait()
                    end
                end)
                task.New(self, function()
                    task.Wait(60)
                    for i = 1, 360 do
                        self.omiga = sin(i / 4) * 0.5
                        task.Wait()
                    end
                    local rot = 0
                    local wait = 7
                    while true do
                        for i = 1, w do
                            Create.bullet_accel(self.x + cos(rot) * 180, self.y + sin(rot) * 180, square, 14, 0.5, 2, rot + i * 360 / w)
                        end
                        PlaySound("tan00", 0.1, 0, true)
                        rot = rot + 55
                        wait = max(3, wait - 0.1)
                        task.Wait(wait)
                    end
                end)
            end
        }, true)
        task.New(self, function()
            task.MoveTo(0, -50, 60, 2)
            task.Wait()
            boss.cast(self, 3600)
            object.Connect(self, New(YinYang), 0, true)
            task.Wait(120)
            task.MoveTo(0, 120, 60, 2)
        end)
    end

    name = "神霄「千叟宴-Overdrive」"
    local sc_od1 = boss.card.New(name, 2, 2, 60, 1400)
    local sc_od2 = boss.card.New(name, 2, 3, 60, 1400)
    boss.card.add({ { sc_od1, "4a" }, { sc_od2, "4b" } }, 11, name, 107, 4)
    function sc_od1:before()
        task.Wait(20)
        self.x, self.y = -120, 160
        Newcharge_out(self.x, self.y, 135, 206, 235, true)
        self.rot = -90
        self.hscale, self.vscale = 0.1, 1.3
        for i = 1, 40 do
            i = i / 40
            self.rot = -90 + 90 * (i * 2 - i * i * i)
            self.hscale = 0.1 + 0.9 * (i - 0.5) * 2
            self.vscale = 1.3 - 0.3 * i
            task.Wait()
        end
    end
    function sc_od1:init()
        local w = 8
        task.New(self, function()
            task.Wait(60)
            while true do
                local A = Angle(self, player)
                for a = 1, 15 do
                    NewSimpleBullet(ball_mid_c, 16, self.x, self.y, 1.5, A + a * 24)
                end
                PlaySound("tan00")
                task.Wait(40)
            end
        end)
        task.New(self, function()
            task.Wait(60)
            task.New(self, function()
                local c = 0
                local ba
                local function change(self)
                    bullet.ChangeImage(self, arrow_mid, self._index + 2)
                    Create.bullet_create_eff(self.x, self.y, arrow_mid, self._index, GetV(self))
                end
                while true do
                    for _ = 1, 13 do
                        ba = sin(c) * 10
                        for a = 360 / w, 361, 360 / w do
                            for z = -1, 1 do
                                Create.bullet_dec_setangle(self.x, self.y, arrow_mid, 2,
                                        { v = 3, a = a, time = 40 },
                                        { v = 3, a = a + z * (40 + ba), time = 40, func = change },
                                        { v = 3, a = a - z * (20 + ba), time = 40, func = change },
                                        { v = 3, a = a + z * (30 + ba), time = 40, func = change })
                            end
                        end
                        c = c + 6
                        task.Wait(5)
                    end
                    task.Wait(60)
                end
            end)
            while true do
                task.Wait(160)
                for i = 39, 0, -1 do
                    i = i / 40
                    self.rot = -90 + 90 * (i * 2 - i * i * i)
                    self.hscale = max(0, 0.1 + 0.9 * (i - 0.5) * 2)
                    self.vscale = 1.3 - 0.3 * i
                    task.Wait()
                end
                task.MoveToPlayer(0, -120, 120, 100, 144, 60, 80, 20, 40, 0, 0)
                Newcharge_out(self.x, self.y, 135, 206, 235)
                for i = 1, 40 do
                    i = i / 40
                    self.rot = -90 + 90 * (i * 2 - i * i * i)
                    self.hscale = 0.1 + 0.9 * (i - 0.5) * 2
                    self.vscale = 1.3 - 0.3 * i
                    task.Wait()
                end
                task.Wait(60)
            end
        end)
    end
    function sc_od1:frame()
        self.hscale = sign(self.lr) * abs(self.hscale)
        boss.card.PublicHP(self)
    end

    function sc_od2:before()
        task.MoveTo(60, 140, 60, 2)
    end
    function sc_od2:init()
        local w = 2
        local YinYang = Class(object, {
            frame = task.Do,
            init = function(self)
                self.x, self.y = player.x, player.y
                self.group = GROUP.GHOST
                self.colli = false
                local b
                local d = 1
                self.new = function(x, y, _rot, __rot, frame)
                    for s = 1, 2 do
                        b = NewSimpleBullet(grain_a, 15, x, y)
                        b.group = GROUP.INDES
                        b._r = ({ 255, 0 })[(d + s) % 2 + 1]
                        b._g, b._b = b._r, b._r
                        b.stay = false
                        b.bound = false
                        b._rot = _rot
                        b.rot = b._rot
                        b.__rot = __rot
                        b.master = self
                        b.frame_other = frame
                        b.hscale = 1.4 - s * 0.3
                        b.colli = ({ true, false })[s]
                        b.vscale = b.hscale
                        bullet.SetLayer(b, LAYER.ENEMY_BULLET - 1)
                        PlaySound("tan00")
                    end
                    d = d % 2 + 1
                end
                task.New(self, function()
                    task.MoveTo(0, -50, 180, 3)
                end)
                task.New(self, function()
                    for i = 3, 180, 3 do
                        for a = 0, 180, 180 do
                            self.new(self.x + cos(i + a) * 180, self.y + sin(i + a) * 180, i + a, nil, function(self)
                                if not IsValid(self.master) then
                                    object.Del(self)
                                    return
                                end
                                local rot = self._rot + self.master.rot
                                self.x, self.y = self.master.x + cos(rot) * 180, self.master.y + sin(rot) * 180
                                self.rot = rot
                            end)
                        end
                        if i % 6 == 0 then
                            for a = 0, 180, 180 do
                                self.new(self.x + cos(a) * 90 + cos(i * 2 + a) * 30, self.y + sin(a) * 90 + sin(i * 2 + a) * 30, i * 2 + a, a, function(self)
                                    if not IsValid(self.master) then
                                        object.Del(self)
                                        return
                                    end
                                    local rot = self._rot + self.master.rot
                                    local rot2 = self.__rot + self.master.rot
                                    self.x, self.y = self.master.x + cos(rot2) * 90 + cos(rot) * 30, self.master.y + sin(rot2) * 90 + sin(rot) * 30
                                    self.rot = rot
                                end)
                            end
                        end
                        task.Wait()
                    end
                    for i = 6, 180, 6 do
                        for a = 0, 180, 180 do
                            self.new(self.x + cos(a) * 90 + cos(i + a) * 90, self.y + sin(a) * 90 + sin(i + a) * 90, i + a, a, function(self)
                                if not IsValid(self.master) then
                                    object.Del(self)
                                    return
                                end
                                local rot = self._rot + self.master.rot
                                local rot2 = self.__rot + self.master.rot
                                self.x, self.y = self.master.x + cos(rot2) * 90 + cos(rot) * 90, self.master.y + sin(rot2) * 90 + sin(rot) * 90
                                self.rot = rot
                            end)
                        end
                        task.Wait()
                    end
                end)
                task.New(self, function()
                    task.Wait(60)
                    for i = 1, 270 do
                        self.omiga = sin(i / 3) * 0.5
                        task.Wait()
                    end
                    local rot = 0
                    local wait = 7
                    while true do
                        for a = 180, 360, 180 do
                            for i = 1, w do
                                Create.bullet_accel(self.x + cos(rot + a) * 180, self.y + sin(rot + a) * 180, square, 14, 0.5, 2, rot + i * 360 / w + 40 - sin(rot / 50) * 20 + a)
                            end
                        end
                        PlaySound("tan00")
                        rot = rot + 55
                        wait = max(3, wait - 0.1)
                        task.Wait(wait)
                    end
                end)
            end
        }, true)
        task.New(self, function()
            task.MoveTo(0, -50, 60, 2)
            task.Wait()
            boss.cast(self, 3600)
            object.Connect(self, New(YinYang), 0, true)
            task.Wait(120)
            task.MoveTo(0, 120, 60, 2)
        end)
    end
    sc_od2.frame = boss.card.PublicHP
end--boss4

do
    boss.Define("5a", "丰聪耳神子", "TH13_1", TH13_bg, { 0, 300 }, class["SCBG5"], "Miko", 11)
    local non_sc = boss.card.New("", 2, 2, 45, 700)
    boss.card.add({ { non_sc, "5a" } }, 11, "非符", 108)
    function non_sc:before()
        do
            New(class["MikoBack"], self, -45, 1, nil, { 135, 206, 235 }, 1.4)
            New(class["MikoBack"], self, -135, -1, nil, { 250, 128, 114 }, 1.4)
            New(class["MikoBack"], self, 90, 1, 20, { 255, 227, 132 })
        end
        task.MoveTo(0, 80, 60, 2)
    end
    function non_sc:init()
        local laser_shoot = Class(laser, {
            init = function(self, x, y, a)
                laser.init(self, 14, x, y, a, 0, 0, 0, 12, 12, 0)
                laser._TurnHalfOn(self, 0, false)
                self.line = 0
                self.Isradial = true
                self.radial_v = 16
                task.New(self, function()
                    for i = 1, 45 do
                        self.line = sin(i * 2) * 500
                        task.Wait()
                    end
                    task.Wait(15)
                    laser._TurnOn(self, 1, true, false)
                    task.New(self, function()
                        for _ = 1, 40 do
                            self.l3 = self.l3 + 16
                            task.Wait()
                        end
                        for _ = 1, 40 do
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
        task.New(self, function()
            local d = 1
            while true do
                Newcharge_in(self.x, self.y, 255, 227, 132)
                for _ = 1, 60 do
                    boss.cast(self, 600)
                    task.Wait()
                end
                task.Wait(20)
                local rot = ran:Float(0, 360)
                local drot = 0
                local a
                for i = 1, 70 do
                    for z = -1, 1, 2 do
                        New(laser_shoot, self.x, self.y + 70, rot + drot + z * 3)
                    end
                    for z = -3, 3 do
                        a = rot - drot
                        bullet.SetLayer(NewSimpleBullet(square, 13, self.x, self.y + 70, 4 - abs(z) * 0.1, a + z), LAYER.ENEMY_BULLET + 1)

                    end
                    for z = -5, 5 do
                        a = rot - drot
                        Create.bullet_dec_setangle(self.x + cos(a) * 40, self.y + 70 + sin(a) * 40, square, 14,
                                { v = 2.5 - i * 0.034, a = a + z * 0.5, time = 230 - i }, { v = 3 - i * 0.01, a = a + z * 2.5 })
                    end
                    PlaySound("tan00")
                    drot = drot + 55 * d
                    task.Wait(2)
                end
                task.Wait(60)
                d = -d
                task.MoveToPlayer(60, -96, 96, 60, 100, 20, 40, 16, 32, 2, 1)
            end
        end)
    end
    local sc = boss.card.New("神引「玄女娘娘兴儒度世大慈尊」", 2, 2, 60, 1000)
    boss.card.add({ { sc, "5a" } }, 11, "神引「玄女娘娘兴儒度世大慈尊」", 109)
    function sc:before()
        do
            if ext.sc_pr then
                New(class["MikoBack"], self, -45, 1, nil, { 135, 206, 235 }, 1.4)
                New(class["MikoBack"], self, -135, -1, nil, { 250, 128, 114 }, 1.4)
                New(class["MikoBack"], self, 90, 1, 20, { 255, 227, 132 })
            end
            New(class["MikoBack"], self, 45, 1, 0, nil, 0.6, 70, 20)
            New(class["MikoBack"], self, 135, -1, 0, nil, 0.6, -70, 20)
        end
        if ext.sc_pr then
            task.MoveTo(0, 100, 60, 2)
        else
            task.Wait(60)
        end
    end
    function sc:init()
        UnlockOD(self, 5)
        task.New(self, function()
            task.MoveTo(0, 120, 60, 2)
            local d = 1
            while true do
                Newcharge_in(self.x, self.y, 250, 128, 114)
                boss.cast(self, 160)
                task.Wait(60)
                local b
                self.DMG_factor = 0.5
                for i = 1, 50 do
                    for a = 180, 360, 180 do
                        b = Create.bullet_changeangle(self.x, self.y, ball_light, 14, 4, a + i * 55 * d, { r = i * 0.05 * d, time = 100 })
                        b.frame_new = function(self)
                            bullet.frame(self)
                            if self.changed then
                                self.bound = true
                            else
                                self.bound = false
                            end
                        end
                        NewSimpleBullet(ball_huge, 13, self.x, self.y, 3 - i * 0.015, a + i * 55 * d)
                    end
                    PlaySound("tan00")
                    task.Wait(2)
                end
                PlaySound("kira00")
                local a = -90 - d * 20
                for c = 1, 101 do
                    Create.bullet_accel(self.x, self.y, square, 2, 0.5, 4, a + 15 + 330 * (c - 1) / 100)
                end
                task.Wait(160)
                Newcharge_in(self.x, self.y, 250, 128, 114)
                boss.cast(self, 600)
                task.Wait(60)
                self.DMG_factor = 1
                for i = 1, 180 do
                    for c = 1, 71 do
                        b = Create.bullet_accel(self.x, self.y, ball_light, 14, 10, 23 + sin(i * 4) * 6, a + 15 + 330 * (c - 1) / 70)
                        b.wait = 10
                        b.time = 30
                        bullet.SetLayer(b, LAYER.ENEMY_BULLET_EF)
                    end
                    PlaySound("kira00")
                    b = Create.bullet_accel(self.x, self.y, square, 6, 0.5, 3, -i * 55 * d)
                    b.wait = 180
                    task.Wait(2)
                    a = a + d * sin(i / 2) ^ 4
                end
                task.Wait(120)
                d = -d
            end
        end)
    end
    local sc_od = boss.card.New("神斥「预于未来，斥于正路-Overdrive」", 2, 2, 60, 1000)
    boss.card.add({ { sc_od, "5a" } }, 11, "神斥「预于未来，斥于正路-Overdrive」", 110, 5)
    function sc_od:before()
        do
            New(class["MikoBack"], self, -45, 1, nil, { 135, 206, 235 }, 1.8)
            New(class["MikoBack"], self, -135, -1, nil, { 250, 128, 114 }, 1.8)
            New(class["MikoBack"], self, 90, 1, 20, { 255, 227, 132 })
            New(class["MikoBack"], self, -90, 1, 20, { 255, 227, 132 }, 0.5)
            New(class["MikoBack"], self, 45, 1, 0, nil, 0.6, 70, 20)
            New(class["MikoBack"], self, 135, 1, 0, nil, 1, 70, 20)
            New(class["MikoBack"], self, 45, -1, 0, nil, 1, -70, 20)
            New(class["MikoBack"], self, 135, -1, 0, nil, 0.6, -70, 20)
        end
        task.MoveTo(0, 100, 60, 2)
    end
    function sc_od:init()
        task.New(self, function()
            task.MoveTo(0, 120, 60, 2)
            local d = 1
            while true do
                Newcharge_in(self.x, self.y, 250, 128, 114)
                boss.cast(self, 160)
                task.Wait(40)
                local b
                self.DMG_factor = 0.5
                for i = 1, 40 do
                    for a = 180, 360, 180 do
                        b = Create.bullet_changeangle(self.x, self.y, ball_light, 12, 4, a + i * 55 * d, { r = i * 0.08 * d, time = 100 })
                        b.frame_new = function(self)
                            bullet.frame(self)
                            if self.changed then
                                self.bound = true
                            else
                                self.bound = false
                            end
                        end
                        NewSimpleBullet(ball_huge, 13, self.x, self.y, 3 - i * 0.015, a + i * 55 * d)
                    end
                    PlaySound("tan00")
                    task.Wait(2)
                end
                PlaySound("kira00")
                local a = -90 + ran:Float(-30, 30)
                for c = 1, 101 do
                    Create.bullet_accel(self.x, self.y, square, 2, 0.5, 4, a + 15 + 330 * (c - 1) / 100)
                end
                task.Wait(100)
                Newcharge_in(self.x, self.y, 250, 128, 114)
                boss.cast(self, 600)
                task.Wait(60)
                self.DMG_factor = 1
                task.New(self, function()
                    local D = 1
                    local _a = a - 22.5 * d
                    for _ = 1, 4 do
                        for i = 1, 40 do
                            for A = 45, 360, 45 do
                                for z = -1, 1, 2 do
                                    Create.bullet_decel(self.x, self.y, square, 6, 6, 3, _a + A + D * d * i + z * 8)
                                end
                            end
                            task.Wait(2)
                        end
                        task.Wait(10)
                        _a = _a + 22.5
                        D = -D
                    end
                end)
                for i = 1, 180 do
                    for c = 1, 61 do
                        b = Create.bullet_accel(self.x, self.y, ball_light, 14, 10, 188 + sin(i * 4) * 5, a + 15 + 330 * (c - 1) / 60)
                        b.wait = 10
                        b.time = 30
                        bullet.SetLayer(b, LAYER.ENEMY_BULLET - 1)
                    end
                    PlaySound("kira00")
                    b = Create.bullet_accel(self.x, self.y, square, 6, 0.5, 3, -i * 55 * d)
                    b.wait = 180
                    task.Wait(2)
                    a = a + d * sin(i / 2) ^ 4
                end
                task.Wait(120)
                d = -d
            end
        end)
    end
end--boss5

do
    boss.DefineGroup({
        { id = "a", name = "苏我屠自古", x = 300, y = 300, img = "Toziko" },
        { id = "b", name = "物部布都", x = -300, y = 300, img = "Futo" },
        { id = "c", name = "丰聪耳神子", x = 0, y = 300, img = "Miko" },
    }, 6, "TH13_1", TH13_bg, class["SCBG5"], 11)
    local name = "「豪族乱舞·改」"
    local sc1 = boss.card.New(name, 1, 3, 77, 700)
    local sc2 = boss.card.New(name, 2, 2, 77, 300)
    local sc3 = boss.card.New(name, 1, 2, 77, 700)
    boss.card.add({ { sc1, "6a" }, { sc2, "6b" }, { sc3, "6c" } }, 11, name, 111)
    function sc1:before()
        task.Wait(20)
        self.x, self.y = 120, 80
        Newcharge_out(self.x, self.y, 135, 206, 235, true)
        self.rot = -90
        self.hscale, self.vscale = 0.1, 1.3
        for i = 1, 40 do
            i = i / 40
            self.rot = -90 + 90 * (i * 2 - i * i * i)
            self.hscale = 0.1 + 0.9 * (i - 0.5) * 2
            self.vscale = 1.3 - 0.3 * i
            task.Wait()
        end
    end
    function sc1:frame()
        self.hscale = sign(self.lr) * abs(self.hscale)
    end
    function sc2:before()
        self._wisys:SetFloat()
        task.MoveTo(-120, 80, 60, 2)
    end
    function sc3:before()
        do
            New(class["MikoBack"], self, 90, 1, 20, { 255, 227, 132 })
            New(class["MikoBack"], self, 45, 1, 0, { 135, 206, 235 }, 0.6, 70, 20)
            New(class["MikoBack"], self, 135, -1, 0, { 189, 252, 201 }, 0.6, -70, 20)
        end
        task.MoveTo(0, 80, 60, 2)
    end

    function sc1:init()
        local W = 0
        task.New(self, function()
            boss.violent(self)
            W = 1
            boss.violent(self)
            W = 2
        end)
        task.New(self, function()
            task.Wait(60)
            local d = 1
            local w = 7
            local b
            while true do
                for c = 1, 30 do
                    for a = 360 / w, 361, 360 / w do
                        a = a + c * 2 * d
                        for _w = 0, W do
                            b = Create.bullet_dec_setangle(self.x + cos(a) * 40, self.y + sin(a) * 40, arrow_mid, 8,
                                    { v = 2, a = a, time = 40 },
                                    { v = 2, a = a + 45 * d, time = 40 },
                                    { v = 3, a = a + (90 + c * (2 + _w)) * d, time = 40 },
                                    { v = 2.5, a = a + (135 - c * (3 - _w)) * d, time = 40 })
                            bullet.SetLayer(b, LAYER.ENEMY_BULLET - 1)
                        end
                    end
                    c = c + d * 2
                    task.Wait(2)
                end
                task.Wait(60)
                for i = 39, 0, -1 do
                    i = i / 40
                    self.rot = -90 + 90 * (i * 2 - i * i * i)
                    self.hscale = max(0, 0.1 + 0.9 * (i - 0.5) * 2)
                    self.vscale = 1.3 - 0.3 * i
                    task.Wait()
                end
                self.x = -120 * d
                Newcharge_out(self.x, self.y, 135, 206, 235, true)
                for i = 1, 40 do
                    i = i / 40
                    self.rot = -90 + 90 * (i * 2 - i * i * i)
                    self.hscale = 0.1 + 0.9 * (i - 0.5) * 2
                    self.vscale = 1.3 - 0.3 * i
                    task.Wait()
                end
                task.MoveToPlayer(80, -120, 120, 100, 140,
                        20, 40, 16, 32, 2, 0)
                d = -d
            end
        end)
    end
    function sc2:init()
        self.A, self.B = 32, 32
        local wait = 30
        local time = 200
        task.New(self, function()
            boss.violent(self)
            boss.violent(self)
            wait = 20
            time = 180
        end)
        local circle = Class(object, {
            init = function(self, x, y, vy, ag, r, n, o)
                self.x, self.y = x, y
                self.vy = vy
                self.ag = ag
                self.r = 0
                self.group = GROUP.INDES
                self.layer = LAYER.ENEMY_BULLET - 1
                PlaySound("kira00", 0.1, self.x / 100)
                self.bound = false
                task.New(self, function()
                    for i = 1, 180 do
                        self.r = sin(i / 2) * r
                        task.Wait()
                    end
                end)
                local b
                for a = 1, n do
                    b = NewSimpleBullet(ball_big, 6, self.x, self.y)
                    b.stay = false
                    b.rot = a * 360 / n
                    b.bound = false
                    b.omiga = o
                    b.master = self
                    b.frame_other = function(self)
                        if not IsValid(self.master) then
                            object.Del(self)
                            return
                        end
                        self.x = self.master.x + cos(self.rot) * self.master.r
                        self.y = self.master.y + sin(self.rot) * self.master.r
                    end
                end
            end,
            frame = function(self)
                task.Do(self)
                if self.y < -224 - self.r - 18 then
                    object.Del(self)
                end
            end,
            render = function(self)
                SetImageState("white", "mul+add", 180, 135, 206, 235)
                misc.SectorRender(self.x, self.y, self.r - 1, self.r + 1, 0, 360, int(self.r / 2))
            end
        }, true)
        task.New(self, function()
            self._wisys.hscale = -1
            New(class["FutoBoat"], -180, 30, self)
            boss.cast(self, 3600, true)
            task.Wait(90)
            task.New(self, function()
                task.Wait(90)
                while true do
                    New(circle, self.x, self.y, ran:Float(1, 3), ran:Float(0.02, 0.04), ran:Float(80, 120),
                            ran:Int(5, 10), ran:Float(0.5, 1) * ran:Sign())
                    task.Wait(wait)
                end
            end)
            while true do
                task.MoveTo(-370, self.y - 60, time, 3)
                self.y = ran:Float(60, 120)
                task.MoveTo(370, self.y - 60, time, 3)
            end
        end)
    end
    function sc3:init()
        local laser_shoot = Class(laser, {
            init = function(self, x, y, a)
                laser.init(self, 14, x, y, a, 0, 0, 0, 12, 12, 0)
                laser._TurnHalfOn(self, 0, false)
                self.line = 0
                self.Isradial = true
                self.radial_v = 16
                task.New(self, function()
                    for i = 1, 45 do
                        self.line = sin(i * 2) * 500
                        task.Wait()
                    end
                    task.Wait(15)
                    laser._TurnOn(self, 1, true, false)
                    task.New(self, function()
                        for _ = 1, 40 do
                            self.l3 = self.l3 + 16
                            task.Wait()
                        end
                        for _ = 1, 40 do
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
        local wait = 240
        task.New(self, function()
            boss.violent(self)
            wait = 120
            boss.violent(self)
            wait = 0
        end)
        task.New(self, function()
            local d = 1
            while true do
                Newcharge_in(self.x, self.y, 255, 227, 132)
                for _ = 1, 60 do
                    boss.cast(self, 600)
                    task.Wait()
                end
                task.Wait(20)
                local rot = ran:Float(0, 360)
                local drot = 0
                local a
                local D = 1
                for i = 1, 70 do
                    for z = -5, 5 do
                        a = rot - drot
                        Create.bullet_dec_setangle(self.x, self.y + 70, square, D * 6 + 8,
                                { v = 3.3 - i * 0.035, a = a + z * 0.3, time = 230 - i }, { v = 2.5, a = a + z * (1 + D * 1.2) })
                    end
                    PlaySound("tan00")
                    drot = drot + 55 * d
                    task.Wait(2)
                    D = -D
                end
                task.Wait(wait)
                d = -d
                task.MoveToPlayer(90, -96, 96, 60, 100,
                        20, 40, 16, 32, 2, 1)
                local A = Angle(self, player)
                for i = 1, 21 do
                    New(laser_shoot, self.x, self.y, A - 20 - 320 * (i - 1) / 20)
                end
            end
        end)
    end
end--boss6

do
    boss.DefineGroup({
        { id = "a", name = "封兽鵺", x = -120, y = 300, img = "Nue" },
        { id = "b", name = "二岩猯藏", x = 0, y = 300, img = "Mamizou" }
    }, 7, "TH13_1", TH13_bg, class["SCBG6"], 11)
    local name = "「にんげんって弱いな」"
    local sc1 = boss.card.New(name, 1, 2, 60, 900)
    local sc2 = boss.card.New(name, 1, 2, 60, 900)
    local Nue
    boss.card.add({ { sc1, "7a" }, { sc2, "7b" } }, 11, name, 112)
    function sc1:before()
        Nue = self
        self.group = GROUP.NONTJT
        self._wisys:SetFloat()
        task.MoveTo(0, -10, 60, 2)
    end
    function sc1:init()
        task.New(self, function()
            task.Wait(100)
            while true do
                local A = Angle(self, player)
                for i = 1, 15 do
                    for z = -2, 2 do
                        z = i * 24 + A + z * 1.5
                        NewSimpleBullet(square, 4, 192 + cos(z) * 30, self.ty + sin(z) * 30, 0.5, z)
                        NewSimpleBullet(square, 4, -192 + cos(z) * 30, self.ty + sin(z) * 30, 0.5, z)
                    end
                end
                PlaySound("tan00")
                task.Wait(200)
            end
        end)
        task.New(self, function()
            boss.cast(self, 3600)
            local s, t = 0, 0
            while true do
                self.y = -10 - sin(t / 2) * 60
                s = min(90, s + 1)
                t = t + sin(s)
                task.Wait()
            end
        end)
    end
    function sc1:frame()
        boss.card.PublicHP(self)
        self.ty = self.y + 46
    end
    function sc1:render()
        if self.is_combat then
            local alpha = min(self.timer / 90, 1)
            SetImageState("white", "mul+add", alpha * 100, 250, 128, 114)
            RenderRect("white", -192, 192, self.ty - 5, self.ty + 5)
            RenderRect("white", -192, 192, self.ty - 3, self.ty + 3)
        end
    end
    function sc2:before()
        task.MoveTo(0, 150, 60, 2)
    end
    function sc2:init()
        UnlockOD(self, 6)
        New(Class(object, {
            init = function(self)
                self.x, self.y = player.x, player.y
                self.group = GROUP.INDES
                self.colli = false
                self.layer = LAYER.PLAYER + 1
                self.r = 0
                task.New(self, function()
                    for i = 1, 60 do
                        self.r = 70 * sin(i * 1.5)
                        task.Wait()
                    end
                end)
            end,
            frame = function(self)
                task.Do(self)
                self.x = self.x + (-self.x + player.x) * 0.02
                self.y = self.y + (-self.y + player.y) * 0.02
                object.BulletDo(function(b)
                    if b.human and Dist(b, self) < self.r then
                        b.jump = true
                    end
                end)
            end,
            render = function(self)
                SetImageState("circle_charge", "mul+add", 200, 135, 206, 235)
                Render("circle_charge", self.x, self.y, 0, self.r / 256)
            end }, true))
        task.New(self, function()

            local X
            local d = 1
            while true do
                boss.cast(self, 3600)
                X = ran:Float(-48, 48)
                for x = -20, 20 do
                    New(class["Human"], x * 12 + X, -1.5, Nue, -(x % 9 - 4) * 6)
                end
                task.Wait(90)
                for i = 1, 80 do
                    Create.bullet_dec_acc(self.x, self.y, ball_big, 8, 4, 4, i * 55 * d)
                    PlaySound("tan00")
                    task.Wait()
                end
                task.MoveToPlayer(60, -96, 96, 130, 160, 20, 40, 16, 32, 2, 1)
                task.Wait()
                d = -d
            end
        end)
    end
    sc2.frame = boss.card.PublicHP

    name = "「にんげんって強いな-Overdrive」"
    local sc_od1 = boss.card.New(name, 1, 2, 60, 900)
    local sc_od2 = boss.card.New(name, 1, 2, 60, 900)
    boss.card.add({ { sc_od1, "7a" }, { sc_od2, "7b" } }, 11, name, 113, 6)
    function sc_od1:before()
        Nue = self
        self.group = GROUP.NONTJT
        self._wisys:SetFloat()
        task.MoveTo(0, -90, 60, 2)
    end
    function sc_od1:init()
        task.New(self, function()
            task.Wait(100)
            while true do
                local A = Angle(self, player)
                for i = 1, 15 do
                    for z = -1, 1 do
                        z = i * 24 + A + z * 1.5
                        NewSimpleBullet(square, 4, 192 + cos(z) * 30, self.ty + sin(z) * 30, 0.5, z)
                        NewSimpleBullet(square, 4, -192 + cos(z) * 30, self.ty + sin(z) * 30, 0.5, z)
                    end
                end
                PlaySound("tan00")
                task.Wait(200)
            end
        end)
        task.New(self, function()
            boss.cast(self, 3600)
            local s, t = 0, 0
            while true do
                self.y = -90 - sin(t / 2) * 30
                s = min(90, s + 1)
                t = t + sin(s)
                task.Wait()
            end
        end)
    end
    function sc_od1:frame()
        boss.card.PublicHP(self)
        self.ty = self.y + 46
    end
    function sc_od1:render()
        if self.is_combat then
            local alpha = min(self.timer / 90, 1)
            SetImageState("white", "mul+add", alpha * 100, 250, 128, 114)
            RenderRect("white", -192, 192, self.ty - 5, self.ty + 5)
            RenderRect("white", -192, 192, self.ty - 3, self.ty + 3)
        end
    end
    function sc_od2:before()
        task.MoveTo(0, 150, 60, 2)
    end
    function sc_od2:init()
        New(Class(object, {
            init = function(self)
                self.x, self.y = player.x, player.y
                self.group = GROUP.INDES
                self.colli = false
                self.layer = LAYER.PLAYER + 1
                self.r = 0
                task.New(self, function()
                    for i = 1, 60 do
                        self.r = 150 * sin(i * 1.5)
                        task.Wait()
                    end
                end)
            end,
            frame = function(self)
                task.Do(self)
                self.x = self.x + (-self.x + player.x) * 0.005
                self.y = self.y + (-self.y + player.y) * 0.005
                object.BulletDo(function(b)
                    if b.human and Dist(b, self) < self.r then
                        b.jump = true
                    end
                end)
            end,
            render = function(self)
                SetImageState("circle_charge", "mul+add", 200, 135, 206, 235)
                Render("circle_charge", self.x, self.y, 0, self.r / 256)
            end }, true))
        task.New(self, function()
            local d = 1
            while true do
                boss.cast(self, 3600)
                for x = -20, 20 do
                    New(class["Human"], x * 12, -1.5, Nue, -(x % 9 - 4) * 36)
                end
                task.Wait(30)
                for i = 1, 60 do
                    Create.bullet_dec_acc(self.x, self.y, ball_big, 8, 4, 2 - i / 60, i * 55 * d)
                    PlaySound("tan00")
                    task.Wait()
                end
                task.MoveToPlayer(60, -96, 96, 130, 160, 20, 40, 16, 32, 2, 1)
                task.Wait()
                d = -d
            end
        end)
    end
    sc_od2.frame = boss.card.PublicHP
end--boss7