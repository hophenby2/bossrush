local class = {}
_editor_class["TH128"] = class
local cos, sin, min, int = cos, sin, min, int
local bullet, object, boss = bullet, object, boss
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

class["SCBG1"] = Class(_SC_BG)
class["SCBG1"].init = function(self)
    _SC_BG.init(self)
    local b

    b = _SC_BG.AddLayer(self, "th12_8_0")
    b.blend = "mul+add"
    b.a = 180
    b.hscale, b.vscale = 1.2, 1.2
    b = _SC_BG.AddLayer(self, "th12_8_1", true, 0, 0, 0, 0, 1)
    b.a = 100
    b = _SC_BG.AddLayer(self, "th12_8_1", true, 0, 0, 0, -0.6, -0.7)
    b.Beforeframe = function(self)
        self.r = 150 + sin(self.timer / 3) * 100
        self.g = 150 + sin(self.timer / 6) * 100
        self.b = 150 + sin(self.timer / 9) * 100
    end
end
do
    class["object2-1"] = Class(object, {
        init = function(self)
            self.x, self.y = player.x, player.y
            self.group = GROUP.INDES
            self.layer = LAYER.ENEMY
            self.colli = false
            self.alpha = 0
            self.omiga = 0.7
            PlaySound("explode")
            local music_round = Class(bullet, { init = function(self, index, master, t, a, r, o)
                bullet.init(self, music, index, false, false)
                self.x, self.y = master.x, master.y
                self.bound = false
                self.timer = 11
                self._a = 0
                self.colli = false
                self.rot = -90
                self.master = master
                self.change = function(self, id)
                    PlaySound("kira00")
                    if id == 1 then
                        for i = 1, 90 do
                            self._a = 255 * sin(i)
                            task.Wait()
                        end
                    else
                        if self._a == 0 then
                            task.Wait(90)
                        else
                            for i = 1, 90 do
                                self._a = 255 - 255 * sin(i)
                                task.Wait()
                            end
                        end

                    end
                end
                task.New(self, function()
                    while true do
                        if not IsValid(self.master) then
                            object.Del(self)
                            return
                        end
                        if self._a == 255 then
                            self.colli = true
                        else
                            self.colli = false
                        end
                        self.x = self.master.x + cos(a) * self.master.r * r
                        self.y = self.master.y + sin(a) * self.master.r * r
                        a = a + o
                        task.Wait()
                    end
                end)
                task.New(self, function()
                    while true do
                        self:change((1 + t) % 2)
                        task.Wait(240)
                        self:change((2 + t) % 2)
                        task.Wait(240)
                    end
                end)
            end }, true)
            task.New(self, function()
                for i = 10, 360, 10 do
                    New(music_round, 14, self, 2, i, 1, 2)
                end
                for i = 10, 360, 10 do
                    New(music_round, 10, self, 1, i, 0.01, -2)
                end
                for i = 1, 90 do
                    self.r = 35 * sin(i)
                    task.Wait()
                end
            end)
            task.New(self, function()
                while true do
                    self.x = self.x + (-self.x + player.x) * 0.05
                    self.y = self.y + (-self.y + player.y) * 0.05
                    task.Wait()
                end
            end)
        end,
        frame = task.Do,
        render = function(self)
            SetImageState("white", "mul+add", 128, 255, 227, 132)
            misc.SectorRender(self.x, self.y, self.r - 2, self.r, 0, 360, 40)
            misc.SectorRender(self.x, self.y, self.r * 0.01 - 2, self.r * 0.01, 0, 360, 40)
        end
    })
    class["object2-2"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.x, self.y = master.x, master.y
            self.l = 0
            self.group = GROUP.INDES
            self.layer = LAYER.TOP
            self.colli = false
            task.New(self, function()
                for i = 1, 60 do
                    self.l = sin(i * 1.5)
                    task.Wait()
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
        end,
        render = function(self)
            SetImageState('white', "mul+add", 60, 255, 227, 132)
            for v = 0.2, 0.6, 0.2 do
                Render("white", self.x, self.y, 0, self.l * 192 / 8, v)
            end
        end
    })
end--object
do
    class["bullet2-1"] = Class(bullet, {
        init = function(self, x, other)
            bullet.init(self, star_big, 6, true, true)
            self.x, self.y = x, 250
            self.bound = false
            object.SetV(self, 2.5, -90, true)
            self.omiga = ran:Sign() * 2
            self.other = other
            bullet.SetLayer(self, LAYER.ENEMY_BULLET + 1)
            self.__a = self._a
        end,
        frame = function(self)
            bullet.frame(self)
            self._a = self._a + (-self._a + self.__a) * 0.05
            if self.y < -250 then
                object.Del(self)
            end
            if IsValid(self.other) then
                if self.y < self.other.y then
                    self.__a = 10
                else
                    self.__a = 255
                end
            end
        end,
        render = function(self)
            SetImageState("bright", "mul+add", self._a / 2, 255, 227, 132)
            Render("bright", self.x, self.y, 0, 50 / 150)
            bullet.render(self)
        end
    })
end--bullet
do
    boss.Define("1a", "露娜切露德", "TH12_8_2", TH128_bg, { 0, 300 }, class["SCBG1"], "LunaChild", 10)
    local _tmp_sc = boss.card.New("幽寂「月下无声胜有声」", 1, 2, 45, 750)
    function _tmp_sc:before()
        self.group = GROUP.NONTJT
        task.MoveTo(0, 90, 60, 2)
    end
    function _tmp_sc:del()
        SetBGMVolume("TH12_8_2", 1)
    end
    function _tmp_sc:init()
        self._transport = New(Class(object, {
            frame = task.Do,
            init = function(self)
                self.group = GROUP.GHOST
                task.New(self, function()
                    while not self.finish do
                        task.Wait()
                    end
                    if self.getcard then
                        ext.achievement:get(134)
                    end
                    object.RawDel(self)
                end)
            end }, true))
        task.New(self, function()
            boss.cast(self, 3600)
            self.sound = 0.3
            New(class["object2-1"])
            task.New(self, function()
                while true do
                    Newcharge_in(self.x, self.y, 32, 32, 128)
                    for i = 1, 90 do
                        SetBGMVolume("TH12_8_2", 1 - 0.6 * sin(i))
                        self.sound = 0.3 - 0.25 * sin(i)
                        task.Wait()
                    end
                    task.Wait(240)
                    Newcharge_out(self.x, self.y, 32, 32, 128)
                    for i = 1, 90 do
                        SetBGMVolume("TH12_8_2", 0.4 + 0.6 * sin(i))
                        self.sound = 0.05 + 0.25 * sin(i)
                        task.Wait()
                    end
                    task.Wait(240)
                end
            end)
            task.Wait(60)
            local r = 0
            local d = 45
            local a
            local v = 1
            while true do
                for c = -1, 1, 2 do
                    for z = -2, 2 do
                        a = -90 + c * r + z * 1.7
                        Create.bullet_changeangle(self.x + cos(a) * 30, self.y + sin(a) * 30, arrow_big, 13, 1.5 + v * 0.1, a,
                                { wait = 12, time = 90, r = sin(d) * c })
                    end
                end
                PlaySound("tan00", self.sound or 0.1, 0, true)
                r = r + 29
                v = -v
                d = d + 9
                task.Wait(4)
            end
        end)
    end
    boss.card.add({ { _tmp_sc, "1a" } }, 10, "幽寂「月下无声胜有声」", 95)
end--boss1

do
    boss.Define("2a", "斯塔萨菲雅", "TH12_8_2", TH128_bg, { 300, 300 }, class["SCBG1"], "StarSapphire", 10)
    local _tmp_sc = boss.card.New("环星「充满活力的繁星」", 1, 2, 45, 750)
    function _tmp_sc:before()
        self.group = GROUP.NONTJT
        task.MoveTo(0, 90, 60, 2)
    end
    function _tmp_sc:init()
        self._transport = New(Class(object, {
            frame = task.Do,
            init = function(self)
                self.group = GROUP.GHOST
                task.New(self, function()
                    while not self.finish do
                        task.Wait()
                    end
                    if self.getcard then
                        scoredata["UnlockSC"][24] = true
                        ext.achievement:get(135)
                    end
                    object.RawDel(self)
                end)
            end }, true))
        local ball_circle = Class(object, {
            init = function(self, x, y, v, a, r, o)
                self.x, self.y = x, y
                self.group = GROUP.INDES
                self.bound = false
                self.colli = false
                object.SetV(self, v, a, true)
                self.servant = {}
                self.l = 0
                self.r = r
                local b
                for _a, i in sp.math.AngleIterator(0, 12) do
                    b = NewSimpleBullet(star_small, int(i / 2) % 2 * 4 + 2, self.x, self.y, nil, nil, nil, 2, false)
                    table.insert(self.servant, b)
                    b._rot = _a
                    b._omiga = o
                    b.master = self
                    b.frame_other = function(unit)
                        if not IsValid(unit.master) then
                            object.Del(unit)
                            return
                        end
                        unit._rot = unit._rot + unit._omiga
                        unit.x = unit.master.x + cos(unit._rot) * r * unit.master.l
                        unit.y = unit.master.y + sin(unit._rot) * r * unit.master.l
                    end
                end
            end,
            frame = function(self)
                self.l = self.l + (-self.l + min(1, 50 / Dist(self, player))) * 0.05
                sp:UnitListUpdate(self.servant)
                if #self.servant == 0 then
                    object.Del(self)
                end
            end,
            render = function(self)
                local alpha = (self.l - 0.5) * 2 * 200
                if alpha > 0 then
                    SetImageState("white", "mul+add", alpha, 189, 252, 201)
                    misc.SectorRender(self.x, self.y, self.l * self.r - 1, self.l * self.r + 1, 0, 360, math.ceil(40 * self.l), 0)
                end
            end
        }, true)
        task.New(self, function()
            boss.cast(self, 3600)
            task.New(self, function()
                task.Wait(100)
                local rot = 0
                local d = 1
                local a, b
                while true do
                    for i = 1, 5 do
                        for c = -2 * d, 2 * d, d do
                            a = i * 72 + c * d * 2 + rot
                            b = NewSimpleBullet(grain_a, 4, self.x + cos(a) * (30 + c * 3), self.y + sin(a) * (30 + c * 3), 1.3 + c * 0.02 + d * 0.1, a)
                            b._blend = "mul+add"
                        end
                    end
                    PlaySound("tan00")
                    d = -d
                    rot = rot + 13
                    task.Wait(14)
                end
            end)
            while true do
                local d = 1
                local a = ran:Float(0, 360)
                for i = 36, 360, 36 do
                    New(ball_circle, self.x, self.y, 1.5, i + a, 120, 0.3 * d, -90, 0.5)
                    d = -d
                end
                task.Wait(110)
            end
        end)
    end
    boss.card.add({ { _tmp_sc, "2a", } }, 10, "环星「充满活力的繁星」", 96)

    local sc_od = boss.card.New("星符「含羞草之星-Overdrive」", 1, 2, 45, 750)
    function sc_od:before()
        self.group = GROUP.NONTJT
        task.MoveTo(0, 90, 60, 2)
    end
    function sc_od:init()
        local ball_circle = Class(object, {
            init = function(self, x, y, v, a, r, o)
                self.x, self.y = x, y
                self.group = GROUP.INDES
                self.bound = false
                self.colli = false
                object.SetV(self, v, a, true)
                self.servant = {}
                self.l = 0
                self.r = r
                local b
                for _a, i in sp.math.AngleIterator(0, 12) do
                    b = NewSimpleBullet(star_small, int(i / 2) % 2 * 4 + 6, self.x, self.y, nil, nil, nil, 2, false)
                    table.insert(self.servant, b)
                    b._rot = _a
                    b._omiga = o
                    b.master = self
                    b.frame_other = function(unit)
                        if not IsValid(unit.master) then
                            object.Del(unit)
                            return
                        end
                        unit._rot = unit._rot + unit._omiga
                        unit.x = unit.master.x + cos(unit._rot) * r * unit.master.l
                        unit.y = unit.master.y + sin(unit._rot) * r * unit.master.l
                    end
                end
            end,
            frame = function(self)
                self.l = self.l + (-self.l + 1.05 - min(1, 50 / Dist(self, player))) * 0.05
                sp:UnitListUpdate(self.servant)
                if #self.servant == 0 then
                    object.Del(self)
                end
            end,
            render = function(self)
                local alpha = (self.l - 0.5) * 2 * 200
                if alpha > 0 then
                    SetImageState("white", "mul+add", alpha, 250, 128, 114)
                    misc.SectorRender(self.x, self.y, self.l * self.r - 1, self.l * self.r + 1, 0, 360, math.ceil(40 * self.l), 0)
                end
            end
        }, true)
        task.New(self, function()
            task.Wait(100)

            while true do
                for a in sp.math.AngleIterator(Angle(self, player), 20) do
                    Create.bullet_decel(self.x, self.y, ellipse, 2, 4, 2, a, true, false)
                end
                PlaySound("tan00")
                task.Wait(45)
            end
        end)
        task.New(self, function()
            boss.cast(self, 3600)
            local d = 1
            while true do
                local a = ran:Float(0, 360)
                for i = 30, 360, 30 do
                    New(ball_circle, self.x, self.y, 1.5, i + a, 120, 0.3 * d, -120, 0.5)
                end
                task.Wait(60)
                d = -d
            end
        end)
    end
    boss.card.add({ { sc_od, "2a", } }, 10, "星符「含羞草之星-Overdrive」", 220, 24)
end--boss2

do
    boss.Define("3a", "桑尼米尔克", "TH12_8_2", TH128_bg, { -300, 300 }, class["SCBG1"], "SunnyMilk", 10)
    local _tmp_sc = boss.card.New("散光「不会迷路的光亮」", 1, 2, 45, 700)
    function _tmp_sc:before()
        self.group = GROUP.NONTJT
        task.MoveTo(0, 90, 60, 2)
    end
    function _tmp_sc:init()
        self._transport = New(Class(object, {
            frame = task.Do,
            init = function(self)
                self.group = GROUP.GHOST
                task.New(self, function()
                    while not self.finish do
                        task.Wait()
                    end
                    if self.getcard then
                        ext.achievement:get(136)
                    end
                    object.RawDel(self)
                end)
            end }, true))
        task.New(self, function()
            boss.cast(self, 3600)
            task.New(self, function()
                task.Wait(150)
                Newcharge_out(self.x, self.y, 255, 227, 132)
                task.New(self, function()
                    local b
                    local rot = 0
                    local orot = 0
                    task.New(self, function()
                        for i = 1, 90 do
                            rot = 150 * sin(i)
                            task.Wait()
                        end
                        task.Wait(90)
                        local t = 1
                        while true do
                            orot = sin(t / 3) * sin(min(90, t)) * 40
                            t = t + 1
                            task.Wait()
                        end
                    end)
                    while true do
                        for d = -1, 1, 2 do
                            b = NewSimpleBullet(ellipse, 14, self.x, self.y, 8, 90 + d * rot + orot, nil, nil, false)
                            b._blend = "mul+add"
                            b.timer = 11
                        end
                        task.Wait(2)
                    end
                end)
                while true do
                    local A = Angle(self, player)
                    for v = 1, 2 do
                        for j = 20, 360, 20 do
                            Create.bullet_decel(self.x, self.y, ball_big, 12, 5, 1 + v * 0.5, j + v * 10 + A, true)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(90)
                end
            end)
            local rot = 90
            while true do
                for a = 18, 360, 18 do
                    Create.bullet_dec_setangle(self.x, self.y, grain_b, 2, false,
                            { v = 5, a = a + rot, time = 20 }, { v = 5, a = a * 2 + rot, time = 20 },
                            { v = 5, a = a * 3 + rot, time = 20 }, { v = 5, a = a * 4 + rot, time = 20 }, { v = 3, a = a * 5 + rot, time = 20 })
                end
                rot = rot + sin(min(90, self.timer)) * 4.8
                task.Wait(12)
            end
        end)
    end
    boss.card.add({ { _tmp_sc, "3a" } }, 10, "散光「不会迷路的光亮」", 97)
end--boss3

do
    boss.Define("4a", "露娜切露德", "TH12_8_2", TH128_bg, { -300, -300 }, class["SCBG1"], "LunaChild", 10)
    boss.Define("4b", "斯塔萨菲雅", "TH12_8_2", TH128_bg, { 0, 300 }, class["SCBG1"], "StarSapphire", 10)
    boss.Define("4c", "桑尼米尔克", "TH12_8_2", TH128_bg, { 0, -400 }, class["SCBG1"], "SunnyMilk", 10)
    local name = "「かたわれ時」"
    local Moon, Star, Sunny
    local sc1 = boss.card.New(name, 1, 1, 80, 1200)
    local sc2 = boss.card.New(name, 1, 1, 80, 1200)
    local sc3 = boss.card.New(name, 1, 1, 80, 1200)
    boss.card.add({ { sc1, "4a" }, { sc2, "4b" }, { sc3, "4c" } }, 10, name, 98)

    function sc1:before()
        Moon = self
        self.group = GROUP.NONTJT
        task.MoveTo(0, -140, 60, 2)
    end
    function sc1:init()
        task.New(self, function()
            task.New(self, function()
                while true do
                    boss.cast(self, 3600)
                    task.Wait(180)
                    task.MoveToPlayer(80, -96, 96, -160, -120, 30, 60, 16, 32, 2, 1)
                    task.Wait()
                end
            end)
            local a, b
            while true do
                local c = ran:Float(-70, 70)
                for x = -2, 2 do
                    for t = 1, 3 do
                        for n = 1, t * 4 do
                            a = 360 / t / 4 * n
                            b = NewSimpleBullet(ball_mid, 2, x / 2 * 250 + c + cos(a) * t * 7, -260 + sin(a) * t * 7, 1, 90)
                            b.other = Sunny
                            b.__a = b._a
                            b.bound = false
                            b.frame_other = function(self)
                                if self.y > 250 then
                                    object.Del(self)
                                end
                                self._a = self._a + (-self._a + self.__a) * 0.05
                                if IsValid(self.other) then
                                    if self.y > self.other.y then
                                        self.__a = 10
                                    else
                                        self.__a = 255
                                    end
                                end
                            end
                        end
                    end
                end
                task.Wait(120)
            end
        end)
    end
    sc1.frame = boss.card.PublicHP
    function sc2:before()
        Star = self
        self.group = GROUP.NONTJT
        task.MoveTo(0, 140, 60, 2)
    end
    function sc2:init()
        task.New(self, function()
            task.New(self, function()
                while true do
                    boss.cast(self, 3600)
                    task.Wait(180)
                    task.MoveToPlayer(80, -96, 96, 120, 160, 30, 60, 16, 32, 2, 1)
                    task.Wait()
                end
            end)

            while true do
                local c = ran:Float(-40, 40)
                for x = -4, 4 do
                    New(class["bullet2-1"], x / 4 * 250 + c, Sunny)
                end
                task.Wait(38)
            end
        end)
    end
    sc2.frame = boss.card.PublicHP
    function sc3:before()
        Sunny = self
        self.group = GROUP.NONTJT
        task.MoveTo(0, 0, 60, 2)
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
                        ext.achievement:get(137)
                    end
                    object.RawDel(self)
                end)
            end }, true))
        New(class["object2-2"], self)
        task.New(self, function()
            boss.cast(self, 3600)
            local a, c = 0, 0
            while true do
                self.y = 120 * sin(a)
                c = min(90, c + 1)
                a = a + sin(c) * 0.6
                task.Wait()
            end
        end)
    end
    sc3.frame = boss.card.PublicHP
end