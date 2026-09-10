local class = {}
_editor_class.TH185 = class
local cos, sin, min, max = cos, sin, min, max
local bullet, object, boss = bullet, object, boss
local task, ran, Create, misc, sp = task, ran, Create, misc, sp
local GROUP, LAYER = GROUP, LAYER
local New = New
local NewSimpleBullet = NewSimpleBullet
local PlaySound = PlaySound
local IsValid = IsValid
local SetImageState = SetImageState
local Dist, Angle = Dist, Angle
local Render = Render
local Class = Class

local function FullScreen()
    if ext.sc_pr then
        ToBigScreen(60)
    end
end

do
    class.SCBG1 = Class(_SC_BG)
    function class.SCBG1:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th12_3", false, -320, 0, 0,
                0, 0, 0.1, "mul+add", 2, 2)
        b.a = 56
        b = _SC_BG.AddLayer(self, "th12_3", false, 320, 0, 0,
                0, 0, 0.1, "mul+add", 2, 2)
        b.a = 56

        b = _SC_BG.AddLayer(self, "th12_2", true, 0, 0, 0,
                0, 0.75, 0, "mul+add", 1.6, 1.6)
        b.a = 200
        b = _SC_BG.AddLayer(self, "th14_2", true, 0, 0, 0, -0.2)
        b.blend = "mul+rev"
        b.Beforeframe = function(unit)
            unit.a = 100 + 50 * cos(unit.timer / 4)
        end
        b = _SC_BG.AddLayer(self, "th14_2", true, 0, 128, 0, 0.2)
        b.blend = "mul+add"
        b.Beforeframe = function(unit)
            unit.a = 100 + 50 * cos(unit.timer / 4)
        end
        b = _SC_BG.AddLayer(self, "th14_3", true, 0, 0, 0, -0.1, -0.3)
        b.a = 100
        b = _SC_BG.AddLayer(self, "th14_3", true, 0, 128, 0, 0.1, -0.3)
    end

    class.SCBG2 = Class(_SC_BG)
    function class.SCBG2:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th07_5", false, 0, -200, 0, 0, 0, 0, "", 2, 2)
        b.a = 150
        b = _SC_BG.AddLayer(self, "th17_3", true, 0, 0, 0, 0, 0, -0.2, "")
        b.a = 100
        _SC_BG.AddLayer(self, "th07_6", true, -128, 0, 60,
                0.5, -0.3, 0, "", 1.5, 1.5)
        --
        b = _SC_BG.AddLayer(self, "th17_4", true, 0, 0, 0, 0, 0.6, 0)
        b.r, b.g, b.b = 100, 100, 100
    end

    class.SCBG3 = Class(_SC_BG)
    function class.SCBG3:init()
        _SC_BG.init(self)
        local b

        b = _SC_BG.AddLayer(self, "th18_3", false, 0, 0, 0,
                0, 0, -0.2, "mul+rev", 1.55, 1.55)
        b.a = 120

        b = _SC_BG.AddLayer(self, "th18_3", false, 0, 0, 0,
                0, 0, 0.2, "", 1.55, 1.55)
        b.a = 100
        b = _SC_BG.AddLayer(self, "th10_5", true, 0, 0, 0, 0.3, -1.3, 0, "mul+add")
        b.a = 120
        _SC_BG.AddLayer(self, "th10_4", false, 0, 0, 90,
                0, 0, 0, "", 1.45, 1.45)

    end
end--scbg

do
    boss.Define("1a", "爱塔妮缇拉尔瓦", "TH18_5_0", TH185_bg,
            { 500, 500 }, _editor_class.TH16.SCBG2, "EternityLarva", 19)
    local name = "「新世界的神」"
    local sc1 = boss.card.New(name, 1, 1, 45, 500)
    boss.card.add({ { sc1, "1a" } }, 19, name, 213)
    function sc1:before()
        FullScreen()
        boss.show_aura(self, false)
        PlaySound("ch02")
        New(boss_cast_darkball, 0, 160, 60, 80, 360, 1, 270, 64, 64, 255, 2)
        New(boss_cast_darkball, 0, 160, 60, 80, 360, 1, 270, 255, 64, 64, -2)
        task.Wait(90)
        self.x, self.y = 0, 160
        boss.show_aura(self, true)
        task.Wait(60)
    end
    function sc1:init()
        local ChirunoPlayer = lstg.var.seasonid == 2
        task.New(self, function()
            local t, s = 90, 0
            while true do
                self.x = cos(t) * 100
                self.y = 100 + sin(t) * 60

                t = t - sin(s) * 0.7
                s = min(s + 1, 90)
                task.Wait()
            end
        end)
        task.New(self, function()
            local sty = ChirunoPlayer and grain_b or arrow_big_c
            local size = ChirunoPlayer and 2.5 or 1.6
            while true do
                for a in sp.math.AngleIterator(ran:Float(0, 360), 10) do
                    local b = Create.bullet_accel(self.x + cos(a) * 45, self.y + sin(a) * 45, sty,
                            6, 0.6, 4.5, a, true, false)
                    b.wait = 15
                    object.SetSizeColli(b, size)
                end
                PlaySound("kira00")
                task.Wait(15)
            end
        end)
        task.New(self, function()
            local sty = ChirunoPlayer and ball_big or butterfly
            local size = ChirunoPlayer and 0.7 or 1
            local function aimbutterfly(x, y, v, a)
                local self = NewObject(bullet)
                bullet.init(self, sty, 14, false, true)
                self.x, self.y = x, y
                PlaySound("tan00")
                object.SetSizeColli(self, size)
                task.New(self, function()
                    object.ChangingV(self, v, 0.5, a, 60)
                    local da = (Angle(self, player) - a) % 360
                    if da > 180 then
                        da = da - 360
                    end
                    object.ChangingVA(self, 0.5, v, a, da, 60)
                end)
            end
            while true do
                for v = 1, 3 do
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                        aimbutterfly(self.x, self.y, 4 - v * 0.5, a)
                    end
                    task.Wait(22)
                end
                task.Wait(90)
            end
        end)
    end


end--boss1

do
    boss.Define("2a", "多多良小伞", "TH18_5_0", TH185_bg, { -500, -500 }, class.SCBG1, "Kogasa", 19)
    boss.Define("2b", "赤蛮奇", "TH18_5_0", TH185_bg, { 200, 500 }, class.SCBG1, "Sekibanki", 19)
    local name = "惊符「逼近的恫吓」"
    local sc1 = boss.card.New(name, 1, 1, 60, 777)
    local sc2 = boss.card.New(name, 1, 1, 60, 777)
    boss.card.add({ { sc1, "2a" }, { sc2, "2b" } }, 19, name, 214)
    function sc1:before()
        FullScreen()
        task.Wait(60)
    end
    function sc2:before()
        task.MoveTo(0, 120, 60, 2)
    end
    function sc1:init()
        task.New(self, function()
            while true do
                for d = -1, 1, 2 do
                    self.y = player.y
                    self.x = 500 * d
                    task.New(self, function()
                        for _ = 1, 70 do
                            local x, y = self.x + ran:Float(-30, 30), self.y + ran:Float(-30, 30)
                            local b = NewSimpleBullet(ball_mid, 8, x, y, 0.08, ran:Float(0, 360))
                            b._blend = "mul+add"
                            task.New(b, function()
                                task.Wait(60)
                                Del(b)
                            end)
                            PlaySound("tan00")
                            task.Wait()
                        end
                    end)
                    task.MoveTo(player.x + 90 * d, self.y, 35, 2)
                    PlaySound("nice", 1, d * 500)
                    NewWave(self.x, self.y, 2, 128, 60, 255, 227, 132)
                    NewBon(self.x, self.y, 60, 128, 255, 227, 132)
                    for a in sp.math.AngleIterator(Angle(self, player), 22) do
                        for v = 0, 2 do
                            Create.bullet_dec_acc(self.x, self.y, ellipse, 14,
                                    2 + v * 0.6, 2 + v * 0.3, a, true, false)
                        end
                    end
                    task.MoveTo(500 * d, self.y, 35, 1)

                end
                task.Wait(130)
            end
        end)
    end
    function sc2:init()
        task.New(self, function()
            local head = Class(object, {
                init = function(unit)
                    unit._wisys = BossWalkImageSystem(unit)
                    unit._wisys:SetImageInList("Sekibanki_head")
                    unit.A, unit.B = 5, 5
                    unit.bound = false
                    unit.group = GROUP.INDES
                    unit.layer = LAYER.ENEMY_BULLET + 1
                    unit.x, unit.y = self.x, self.y + 24 + sin(self.ani * 4) * 4
                    task.New(unit, function()
                        task.MoveToEx(0, 60, 60, 2)
                        task.New(unit, function()
                            for i = 1, 90 do
                                i = task.SetMode[3](i / 90)
                                unit.hscale = 1 + 3 * i
                                unit.vscale = 1 + 3 * i
                                unit.A = 5 * unit.hscale
                                unit.B = 5 * unit.vscale
                                task.Wait()
                            end
                        end)
                        object.ChangingV(unit, 0, 6, Angle(unit, player), 90, false)
                        task.Wait(45)
                        object.SetSizeColli(unit, 1)
                        unit.x, unit.y = self.x, 400
                        object.StopMoving(unit)
                        task.MoveTo(self.x, self.y + 24 + sin(self.ani * 4 + 240) * 4, 60, 2)
                        object.RawDel(unit)
                    end)
                end,
                frame = function(self)
                    task.Do(self)
                    self._wisys:frame()
                    object.smear_add(self, 100)
                    object.smear_frame(self, 10)
                end,
                render = function(self)
                    object.smear_render(self, "mul+add", { 200, 50, 200 })
                    self._wisys:render()
                end,
                kill = function(self)
                    enemy.death_ef(self.x, self.y, 10, 1)
                end,
                del = function(self)
                    self.class.kill(self)
                end
            }, true)
            local d = 1
            while true do
                boss.cast(self, 60)

                task.New(self, function()
                    local rot = ran:Float(0, 360)
                    for k = 1, 12 do
                        for a in sp.math.AngleIterator(rot + sin(k / 12 * 180) * 15 * d, 20) do
                            for z = -0.5, 0.5 do
                                Create.bullet_accel(self.x, self.y, grain_a, 4, 0.5, 2, a + z, false, false)
                            end
                        end
                        task.Wait(10)
                    end
                end)

                PlaySound("boon00")
                self._wisys:SetImageInList("Sekibanki2")
                New(head)
                task.Wait(100)
                task.MoveToPlayer(90, -150, 150, 90, 146,
                        45, 50, 10, 20, 2, 1)
                task.Wait(65)
                self._wisys:SetImageInList("Sekibanki")
                task.Wait(15)
                d = -d
            end
        end)
    end
    sc1.frame = boss.card.PublicHP
    sc2.frame = boss.card.PublicHP
end--boss2

do
    boss.Define("3a", "西行寺幽幽子", "TH18_5_0", TH185_bg, { 300, 500 }, class.SCBG2, "Yuyuko", 19)
    boss.Define("3b", "庭渡久侘歌", "TH18_5_0", TH185_bg, { -300, 500 }, class.SCBG2, "Kutaka", 19)
    local name = "「优质的上等食材！」"
    local sc1 = boss.card.New(name, 1, 1, 45, 333)
    local sc2 = boss.card.New(name, 1, 1, 45, 333)
    boss.card.add({ { sc1, "3a" }, { sc2, "3b" } }, 19, name, 215)
    function sc1:before()
        FullScreen()
        task.MoveTo(0, 160, 60, 2)
    end
    function sc2:before()
        task.MoveTo(160, 0, 60, 2)
    end
    function sc1:init()


        local rotate = true
        self._transport = New(Class(object, {
            frame = task.Do,
            init = function(self)
                self.group = GROUP.GHOST
                task.New(self, function()
                    while not self.finish do
                        task.Wait()
                    end
                    if not self.getcard and rotate and self.timeout then
                        ext.achievement:get(152)
                    end
                    object.RawDel(self)
                end)
            end }, true))
        task.New(self, function()
            boss.violent(self)
            ext.achievement:get(153)
            rotate = false
            self.DMG_factor = 0
            task.MoveTo(0, 120, 60, 2)
            self.DMG_factor = 0.7
            local boom = function(x, y, mx, my)
                local self = NewObject(bullet)
                bullet.init(self, ball_huge, 2, false, false)
                self.x, self.y = x, y
                task.New(self, function()
                    task.MoveTo(mx, my, 55, 2)
                    PlaySound("enep00")
                    NewWave(self.x, self.y, 2, 50, 60, 250, 128, 114)
                    NewWave(self.x, self.y, 2, 100, 60, 250, 128, 114)
                    NewBon(self.x, self.y, 60, 128, 205, 128, 114)
                    Del(self)
                    for _ = 1, 20 do
                        Create.bullet_decel(self.x, self.y, ball_big, 2, 2,
                                ran:Float(2, 5), ran:Float(0, 360), true, false)
                    end
                    for _ = 1, 50 do
                        Create.bullet_decel(self.x, self.y, ball_mid, 2, 6,
                                ran:Float(2, 5), ran:Float(0, 360), true, false)
                    end
                end)
            end
            while true do
                NewWave(player.x, player.y, 2, 100, 60, 250, 128, 114)
                boom(self.x, self.y, player.x, player.y)
                task.Wait(136)
            end
        end)
        task.New(self, function()
            local r = 90
            while rotate do
                self.x = cos(r) * 160
                self.y = sin(r) * 160
                r = r - 2 - 80 / 45 / 60
                object.BulletDo(function(b)
                    if b.kutaka and Dist(b, self) < 36 then
                        Del(b)
                    end
                end)
                task.Wait()
            end
        end)
        task.New(self, function()
            local wait = 55
            while true do
                for a in sp.math.AngleIterator(ran:Float(0, 360), 12 + int(self.y / 30)) do
                    for v = 0, 2 do
                        local b = Create.bullet_accel(self.x, self.y, butterfly, 6, 0.6, 3 + v * 0.5, a, true, false)
                        b.wait = 10
                        b.yuyuko = true
                    end
                end
                PlaySound("kira00")
                task.Wait(wait)
                wait = max(wait - 0.7, 30)
            end
        end)
    end
    function sc2:init()
        local rotate = true
        task.New(self, function()
            boss.violent(self)
            ext.achievement:get(154)
            rotate = false
            self.DMG_factor = 0
            self.omiga = 0
            self.rot = 0
            task.MoveTo(0, 120, 60, 2)
            PlaySound("bonus")
            boss.cast(self, 60)
            for _ = 1, 2 do
                if SearchStageLevel[6] then
                    UFO:New(self.x, self.y)
                end
                for i = 1, 3 do
                    if SearchStageLevel[7] then
                        Beast:drop(self.x, self.y, i)
                    end

                    task.Wait(6)
                end
            end

            if SearchStageLevel[10] then
                for _ = 1, 30 do
                    Season.drop(self.x, self.y, nil, nil, ran:Float(0.5, 2), ran:Float(0, 360))
                end
            end
            if SearchStageLevel[7] then
                Astral.drop(self.x, self.y, 4, 15)
            end
            for i = 1, 10 do
                if SearchStageLevel[1] then
                    item.Dropitem(item.obj.sakura, i, self.x, self.y)
                end
                item.Dropitem(item.obj.point, i, self.x, self.y)
                task.Wait()
            end
            task.Wait(60)
            self.hp = 0
        end)
        task.New(self, function()
            self.omiga = 7
            local r = 0
            while rotate do
                self.x = cos(r) * 160
                self.y = sin(r) * 160
                r = r - 2
                object.BulletDo(function(b)
                    if b.yuyuko and Dist(b, self) < 36 then
                        Del(b)
                    end
                end)
                task.Wait()
            end
        end)
        task.New(self, function()
            local sty = { ball_mid, grain_a }
            while rotate do
                local a = ran:Float(0, 360)
                local b = NewSimpleBullet(sty[ran:Int(1, #sty)], 16,
                        self.x + ran:Float(-30, 30), self.y + ran:Float(-30, 30), 1, a)
                b.stay = false
                b._blend = "mul+add"
                b.kutaka = true
                object.ChangeVwithTask(b, 1, ran:Float(1.7, 2.3), a, 120, 60, false)
                b.omiga = ran:Sign() * ran:Float(4, 5)
                PlaySound("tan00")
                task.Wait(2)
            end
        end)
    end
end--boss3

do
    boss.Define("4a", "河城荷取", "TH18_5_0", TH185_bg, { 0, 500 }, class.SCBG3, "Nitori", 19)
    boss.Define("4b", "山城高岭", "TH18_5_0", TH185_bg, { 0, 500 }, class.SCBG3, "Takane", 19)
    local name = "「现代流行的线上支付」"
    local sc1 = boss.card.New(name, 1, 3, 60, 900)
    local sc2 = boss.card.New(name, 1, 3, 60, 900)
    boss.card.add({ { sc1, "4a" }, { sc2, "4b" } }, 19, name, 216)
    local ScanMachine
    function sc1:before()
        FullScreen()
        task.MoveTo(-200, 100, 60, 2)
    end
    function sc2:before()
        task.MoveTo(200, 100, 60, 2)
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
                    if self.getcard and not self.flag then
                        ext.achievement:get(155)
                    end
                    object.RawDel(self)
                end)
            end }, true))
        task.New(self, function()
            local Scanning = Class(object, {
                init = function(self)
                    self.group = GROUP.INDES
                    self.layer = LAYER.ENEMY_BULLET_EF
                    self.colli = false
                    self.rot = 0
                    self.size = 250
                    self._a = 0
                    self.x, self.y = player.x, player.y
                    self.get = false
                    self.circler = 0
                    task.New(self, function()
                        for i = 1, 15 do
                            i = task.SetMode[2](i / 15)
                            self.size = 250 - 85 * i
                            self._a = 160 * i
                            task.Wait()
                        end
                        task.Wait(37 * 2 - 15)
                        self.scan = true
                    end)
                    task.New(self, function()
                        while not self.flag or self.stop do
                            task.Wait()
                        end
                        object.IndesDo(function(d)
                            if d ~= self then
                                d.flag = true
                            end
                        end)
                        PlaySound("heal", 1, 0, true)
                        PlaySound("lgods1", 1, 0, true)
                        PlaySound("lgods2", 1, 0, true)
                        PlaySound("lgods3", 1, 0, true)
                        self._a = 222
                        self.get = true
                        for i = 1, 25 do
                            i = task.SetMode[2](min(1, i / 13))
                            self.circler = i * 18
                            self.x = self.x - self.x * 0.1
                            self.y = self.y - self.y * 0.1
                            task.Wait()
                        end
                        object.IndesDo(function(d)
                            if d ~= self then
                                Del(d)
                            end
                        end)
                        for i = 1, 15 do
                            i = task.SetMode[2](i / 15)
                            self.size = 165 + 85 * i
                            self._a = 222 - 222 * i
                            task.Wait()
                        end
                        Del(self)
                    end)
                    task.New(self, function()
                        task.Wait(300)
                        if not self.flag then
                            self.stop = true
                            PlaySound("invalid")
                            for i = 1, 15 do
                                i = task.SetMode[2](i / 15)
                                self.size = 165 + 85 * i
                                self._a = 160 - 160 * i
                                task.Wait()
                            end
                            Del(self)
                        end
                    end)
                end,
                frame = function(self)
                    task.Do(self)
                    local R = self.size - 108
                    if not self.flag then
                        self.x, self.y = player.x, player.y
                        if self.scan and sp.math.PointBoundCheck(self.x, self.y, -R, R, -R, R) then
                            self.flag = true
                        end
                    end
                end,

                render = function(self)
                    SetImageState("2dcodeOutline", "mul+add", self._a, 255, 255, 255)
                    Render("2dcodeOutline", self.x, self.y, 0, self.size / 256)
                    if self.timer < 300 and not self.flag then
                        ui:RenderText("title", ("%0.2f"):format((300 - self.timer) / 60), self.x, self.y + 45,
                                1, Color(self._a * 0.7, 200, 255, 200), "centerpoint")
                    end

                    if self.get then
                        SetImageState("white", "", self._a, 255, 255, 255)
                        misc.SectorRender(0, 0, 0, self.circler, 0, 360, 40)
                        SetImageState("white", "", self._a, 64, 255, 64)
                        misc.SectorRender(0, 0, 0, self.circler * 0.8, 0, 360, 40)
                    else
                        SetImageState("2dcodeScan", "mul+add", self._a, 255, 255, 255)
                        local offy = -2 * self.size * (self.timer % 90) / 90 + self.size
                        Render("2dcodeScan", self.x, self.y + offy, 0, self.size / 256)
                    end
                end
            }, true)
            while true do
                ScanMachine = New(Scanning)
                while IsValid(ScanMachine) do
                    self.DMG_factor = 0.65
                    self.flag = ScanMachine.flag
                    task.Wait()
                end
                self.DMG_factor = 1
                if self.flag then
                    self._transport.flag = true
                    task.New(self, function()
                        for _ = 1, 60 do
                            for z = -1, 1, 2 do
                                local b = NewSimpleBullet(money, ran:Int(11, 16), z * 200 + ran:Float(-60, 60), -255, ran:Float(5, 8), 90)
                                b.omiga = ran:Float(2, 3) * ran:Sign()
                                b._a = 99
                                b.colli = false
                                b._blend = "mul+add"
                            end
                            PlaySound("tan00")
                            task.Wait()
                        end
                    end)
                end
                for k = 1, 4 do
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 25) do
                        Create.bullet_decel(self.x, self.y, ellipse, 8, 4, 3 - k * 0.2, a, true, false)
                    end
                    PlaySound("kira00")
                    task.Wait(20)
                end
                task.Wait(60)
            end
        end)
    end
    function sc2:init()
        task.New(self, function()

            local twodCode = function(x, y, t)
                local self = NewObject(bullet)
                bullet.init(self, square, 16, false, false)
                self.x, self.y = x, y
                object.SetSizeColli(self, 0.6)
                self._blend = "mul+add"
                task.New(self, function()
                    task.Wait(t)
                    if not self.flag then
                        bullet.ChangeImage(self, self.imgclass, 2)
                        object.ChangingV(self, 0, ran:Float(2, 3), ran:Float(0, 360), 90)

                    end
                end)
            end
            local function CreateCode()
                --二维码
                --37*37
                --左上右上左下有方格，内3*3，外7*7，还有一个空边框
                local t = {}
                for i = 1, 37 do
                    t[i] = {}
                    for j = 1, 37 do
                        t[i][j] = (ran:Int(0, 4) == 1) and 1 or 0
                    end
                end--先随机填充
                --再把方格覆盖
                for k = 4, 1, -1 do
                    local value = k % 2
                    for i = -k, k do
                        for j = -k, k do
                            t[max(1, i + 4)][max(1, j + 4)] = value
                            t[min(37, i + 34)][max(1, j + 4)] = value
                            t[max(1, i + 4)][min(37, j + 34)] = value
                        end
                    end
                end
                for k = 2, 0, -1 do
                    local value = (k+1) % 2
                    for i = -k, k do
                        for j = -k, k do
                            t[i + 31][ j + 31] = value
                        end
                    end
                end
                for i = 1, 37 do
                    for j = 1, 37 do
                        if t[i][j] == 1 then
                            --108半边长
                            local x, y = (i - 19) * 6, -(j - 19) * 6
                            twodCode(x, y, 300 + 2 - i * 2)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(2)
                end
            end
            while true do

                CreateCode()
                while IsValid(ScanMachine) do
                    self.DMG_factor = 0.65
                    task.Wait()
                end
                self.DMG_factor = 1
                for k = 1, 4 do
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 25) do
                        Create.bullet_decel(self.x, self.y, ellipse, 10, 4, 3 - k * 0.2, a, true, false)
                    end
                    PlaySound("kira00")
                    task.Wait(20)
                end
                task.Wait(60)
            end
        end)
    end
    sc1.frame = boss.card.PublicHP
    sc2.frame = boss.card.PublicHP
end--boss4



