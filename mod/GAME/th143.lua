local cos, sin, abs, min, max, sign = cos, sin, abs, min, max, sign
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

local function FullScreen()
    if ext.sc_pr then
        ToBigScreen(60)
    end
end
local function CardBefore(x, y, force)
    return function(self)
        FullScreen()
        self.__dieinstantly = true
        if ext.sc_pr or force then
            task.MoveTo(x, y, 60, 2)
        else
            task.Wait(60)
        end
    end
end
local function Final(self)
    if IsValid(self.main_boss) and self.main_boss.is_combat then
        self.main_boss.hp = 0
        self.main_boss = nil
        return
    end
    if IsValid(self.other_boss) and self.other_boss.is_combat then
        self.other_boss.hp = 0
        self.other_boss = nil
        return
    end
    if ext.sc_pr then
        for _, p in ipairs(boss_group) do
            p.hp = 0
        end
    end
end
local function SetFlag(id)
    return function(self)
        if self.flag then
            self.flag[id] = true
        end
        Final(self)
    end
end
local function Frame(self)
    boss.card.PublicHP(self)
end
local class = {}
_editor_class.TH143 = class
do
    class.SCBG1 = Class(_SC_BG)
    function class.SCBG1:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th14_8", true, 0, 0, 0, 0, -0.2, 0, "mul+rev")
        b = _SC_BG.AddLayer(self, "th14_9", true, 0, 0, 0, 0, 0.2)
    end
    class.SCBG2 = Class(_SC_BG)
    function class.SCBG2:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th13_8", true, 0, 0, 0, 0, 1.9, 0, "mul+rev")
        b.a = 190
        b.b = 100
        _SC_BG.AddLayer(self, "th06_6", false, 0, 0, 0, 0, 0, 0.2, "mul+add", 3, 3)
        b = _SC_BG.AddLayer(self, "th06_7_n")
        b.r, b.g, b.b = 200, 200, 200
    end
    class.SCBG3 = Class(_SC_BG)
    function class.SCBG3:init()
        _SC_BG.init(self)

        local b = _SC_BG.AddLayer(self, "th13_1", true, 0, 0, 0, 0, 1, 0, "mul+add")
        b.Beforeframe = function(self)
            self.a = 150 + 100 * sin(self.timer)
            self.r = 150 + 50 * sin(self.timer * 1.5)
            self.g = 150 + 50 * sin(self.timer / 2)
        end
        b.Afterrender = function(self)
            _SC_BG.PolarCoordinatesRender("th13_1", 0, 50, 0, 400,
                    -self.timer / 4, 512, 4, -self.timer / 2,
                    "", Color(self._cur_alpha * (255 - self.a), 255, self.g, self.b))
        end
        _SC_BG.AddLayer(self, "th09_5_0", false, 0, 0, 0, 0, 0, 0.5, "mul+add", 2.2, 2.2)
        _SC_BG.AddLayer(self, "th08_15_n", false, 0, 0, 0,
                0, 0, 0, "", 1, 1,
                nil,
                function(self)
                    self.r = cos(self.timer / 2) * 50 + 200
                    self.g = self.r
                    self.b = self.b
                end)

    end
    class.SCBG4 = Class(_SC_BG)
    function class.SCBG4:init()
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th08_9", true, 0, 0, 0,
                0, 1.5, 0, "mul+add", 1, 1)
        b.a = 100
        b = _SC_BG.AddLayer(self, "th12_5_0", true, 0, 0, 0,
                0, 0, 0.3, "mul+rev", 3, 3)
        b.Beforeframe = function(unit)
            unit.a = 100 + sin(unit.timer / 5) * 20
        end
        b = _SC_BG.AddLayer(self, "th12_5_0", true, 0, 0, 0,
                0, 0, -0.3, "mul+rev", 3, 3)
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
end--SCBG
do
    LoadImageGroupFromFile("YukariTool", "mod\\GAME\\YukariTool.png", nil, 3, 10)
    for i = 1, 30 do
        SetImageState("YukariTool" .. i, "mul+add")
    end
    --前十开启，中十循环，后十关闭
    class.Yukari = Class(object, {
        init = function(self, x, y, rot)
            object.init(self, x, y, GROUP.INDES, LAYER.ENEMY_BULLET)
            self.hscale = 0.7
            self.vscale = 0.7
            self.id = 1
            self.colli = false
            self.opposite = nil
            self.rot = rot
            self.flag = nil
            self.event = function(o)
                x = o.x - self.x
                y = o.y - self.y
                x, y = cos(self.rot) * x + sin(self.rot) * y, cos(self.rot) * y - sin(self.rot) * x
                if abs(x) < 100 and abs(y) < 3 then
                    if not o.flag then
                        y = -y
                        o.x = self.opposite.x + cos(self.opposite.rot) * x - sin(self.opposite.rot) * y
                        o.y = self.opposite.y + cos(self.opposite.rot) * y + sin(self.opposite.rot) * x
                        local v, a = GetV(o)
                        object.SetV(o, v, a - self.rot + self.opposite.rot, true)
                        if o._index then
                            Create.bullet_create_eff(o)
                        end
                        o.flag = true
                    end
                else
                    o.flag = false
                end
            end
            task.New(self, function()
                for i = 1, 10 do
                    self.id = i
                    task.Wait(3)
                end
                local i = 1
                while not self.dk do
                    self.id = 10 + i
                    i = sp:TweakValue(i + 1, 10, 1)
                    task.Wait(5)
                end
            end)
        end,
        frame = function(self)
            task.Do(self)
            if self.opposite and IsValid(self.opposite) then
                local x, y
                object.BulletDo(self.event)
                for _, u in ObjList(GROUP.PLAYER_BULLET) do
                    self.event(u)
                end
                x = player.x - self.x
                y = player.y - self.y
                x, y = cos(self.rot) * x + sin(self.rot) * y, cos(self.rot) * y - sin(self.rot) * x
                if abs(x) < 100 and abs(y) < 3 then
                    if not self.flag then
                        y = -y
                        player.x = self.opposite.x + cos(self.opposite.rot) * x - sin(self.opposite.rot) * y
                        player.y = self.opposite.y + cos(self.opposite.rot) * y + sin(self.opposite.rot) * x
                        ext.achievement:get(44)
                        self.flag = true
                        self.opposite.flag = true
                        if self.x < 0 then
                            PlaySound("warpl")
                        else
                            PlaySound("warpr")
                        end
                    end
                else
                    self.flag = nil
                end
            end
        end,
        del = function(self)
            if not self.dk then
                object.Preserve(self)
                self.dk = true
                task.New(self, function()
                    for i = 21, 30 do
                        self.id = i
                        task.Wait(3)
                    end
                    object.RawDel(self)
                end)
            end
        end,
        kill = function(self)
            self.class.del(self)
        end,
        render = function(self)
            Render("YukariTool" .. self.id, self.x, self.y, self.rot, self.hscale, self.vscale)
        end
    }, true)
end--object

boss.Define("1a", "鬼人正邪", "TH14_3_0", TH143_bg, { 0, 500 }, class.SCBG1, "Seija", 13)

local non = boss.card.New("", 1, 2, 45, 500)
boss.card.add({ { non, "1a" } }, 13, "非符", 137)
non.before = CardBefore(0, 130, true)
non.frame = Frame
function non:init()
    task.New(self, function()
        boss.card.UnlockOD(self, 13)
        self.bullet = _editor_class.TH14.Sejia_grain
        self.bullet2 = _editor_class.TH14.sejia2
        self.shoot = function(self, x, y, color, radius, angle, da, rotate, dr, way, wait, v)
            task.New(self, function()
                local r
                local time1 = wait * way * 2
                for i = 1, way do
                    r = radius * (1 - i / way)
                    New(self.bullet, color, x + cos(angle) * r, y + sin(angle) * r, 1, angle, time1 - i * (wait * 2), v * 1.5, -rotate, 44, v, rotate, 44)
                    angle = angle + da
                    rotate = rotate + dr
                    task.Wait(wait)
                end
            end)
        end
        Newcharge_in(self.x, self.y, 200, 128, 114)
        task.Wait(60)
        local d = 1
        while true do
            boss.cast(self, 60)
            task.New(self, function()
                for _ = 1, 3 do
                    for a in sp.math.AngleIterator(Angle(self, player), 28) do
                        NewSimpleBullet(ball_big, 6, self.x, self.y, 3.3, a)
                    end
                    PlaySound("tan00")
                    task.Wait(15)
                end
            end)
            for a in sp.math.AngleIterator(ran:Float(0, 360), 8) do
                self:shoot(self.x, self.y, 10, 100, a, 1 * d, 0, 0.1 * d, 25, 2, 2)
                self:shoot(self.x, self.y, 10, -100, a, -1 * d, 0, -0.1 * d, 25, 2, 2.3)
            end
            d = -d
            task.Wait(60)
            task.New(self, function()
                local A = 1
                for _ = 1, 4 do
                    for a = 1, 51 do
                        a = -100 - 340 * task.SetMode[3]((a - 1) / 50)
                        New(self.bullet2, ball_big, 2, 16, self.x, self.y, cos(a) * 3, sin(a) * 3, A * 6, 0, 0, -70)
                    end
                    A = -A
                    task.Wait(15)
                end
            end)
            task.MoveToPlayer(60, -200, 200, 96, 140, 20, 40, 16, 32, 2, 1)
            task.Wait(60)
        end
    end)
end

do
    local card1 = boss.card.New("逆转「天地有用的遮蔽布」", 2, 3, 60, 450)
    boss.card.add({ { card1, "1a" } }, 13, "逆转「天地有用的遮蔽布」", 138)
    card1.before = CardBefore(0, 130)
    card1.frame = Frame
    function card1:init()
        local flag = New(Class(object, {
            init = function(self)
                self.group = GROUP.GHOST
                task.New(self, function()
                    while not self.finish do
                        task.Wait()
                    end
                    if self.getcard and not self.flag then
                        ext.achievement:get(24)
                    end
                    object.RawDel(self)
                end)
            end,
            frame = task.Do
        }, true))
        self._transport = flag
        task.New(self, function()
            local tip = Class(object, {
                init = function(self, x, y, rot)
                    self.x, self.y = x, y
                    self.group = GROUP.INDES
                    self.layer = LAYER.ENEMY_BULLET_EF
                    self.rot = rot - 45
                    self._a = 255
                    self.r = 0
                    task.New(self, function()
                        for i = 1, 60 do
                            self.r = 128 * task.SetMode[4](i / 60)
                            task.Wait()
                        end
                        task.Wait(30)
                        for i = 1, 20 do
                            self._a = 255 - 255 * task.SetMode[3](i / 20)
                            task.Wait()
                        end
                        object.Del(self)
                    end)
                end,
                frame = task.Do,
                render = function(self)
                    SetImageState("white", "mul+add", self._a, 218, 112, 214)
                    misc.SectorRender(self.x, self.y, self.r * 0.95, self.r, 0, 360, 4, self.rot)
                end
            }, true)
            local cloth = Class(object, {
                init = function(self, x, y, rot)
                    self.x, self.y = x, y
                    self.rot = rot
                    self.layer = LAYER.ENEMY_BULLET_EF
                    self.group = GROUP.INDES
                    self._a = 255
                    self.img = "mask_cloth"
                    self.hscale = 0
                    self.vscale = 0
                    task.New(self, function()
                        for i = 1, 60 do
                            self.hscale = 2 * task.SetMode[4](i / 60)
                            self.vscale = self.hscale
                            task.Wait()
                        end
                        task.Wait(60)
                        for i = 1, 20 do
                            self._a = 255 - 255 * task.SetMode[3](i / 20)
                            task.Wait()
                        end
                        object.Del(self)
                    end)
                end,
                frame = function(self)
                    task.Do(self)
                    local Math = sp.geom
                    local rr = self.hscale * 60 * SQRT2
                    if Math.PointInRectangle(Math.NewPoint(player), Math.NewRectangle(
                            Math.NewPoint(self.x + cos(self.rot + 45) * rr, self.y + sin(self.rot + 45) * rr),
                            Math.NewPoint(self.x + cos(self.rot - 45) * rr, self.y + sin(self.rot - 45) * rr),
                            Math.NewPoint(self.x - cos(self.rot + 45) * rr, self.y - sin(self.rot + 45) * rr),
                            Math.NewPoint(self.x - cos(self.rot - 45) * rr, self.y - sin(self.rot - 45) * rr))) then
                        player.protect = 1
                        flag.flag = true
                    end
                end,
                render = function(self)
                    SetImageState(self.img, "", self._a, 255, 255, 255)
                    DefaultRenderFunc(self)
                end
            }, true)
            task.MoveTo(0, 120, 60, 2)
            Newcharge_out(self.x, self.y, 200, 200, 200)
            self.rotate = misc.RotateWorld("seija1")
            task.New(self, function()
                while true do
                    self.rotate.rot = self.rotate.rot + ((self.x - player.x) / 5 - self.rotate.rot) * 0.05
                    task.Wait()
                end
            end)
            New(WhiteScreen, LAYER.BG + 1)

            task.New(self, function()
                while true do
                    for a in sp.math.AngleIterator(0, 9) do
                        object.SetA(NewSimpleBullet(ellipse, 4, self.x, self.y, 3, a, nil, nil, false),
                                0.02, -self.rotate.rot - 90, nil, true)
                    end
                    PlaySound("tan00")
                    task.Wait(10)
                end
            end)
            local x, y, rot
            local pos = setmetatable({ -2, -1, 0, 1, 2, 1, 0, -1 }, { __index = function(t, k)
                return t[sp:TweakValue(k, #t, 1)]
            end })
            local t = 1
            while true do
                task.Wait(60)
                x, y, rot = pos[t] * 130 + ran:Float(-50, 50), ran:Float(-50, -120), ran:Float(0, 360)
                New(tip, x, y, rot)
                PlaySound("kira01")
                task.MoveToPlayer(60, -200, 200, 140, 160, 90, 100, 10, 20, 2, 1)
                for c = 1, 3 do
                    for a in sp.math.AngleIterator(c * 3, 60) do
                        NewSimpleBullet(ball_light, 6, self.x, self.y, 3, a)
                    end
                    task.Wait(10)
                end
                boss.cast(self, 90)
                New(cloth, x, y, rot)
                PlaySound("boon01")
                t = t + 1
                task.Wait(90)
            end
        end)
    end
    function card1:del()
        SetFlag(1)(self)
        if self.rotate then
            New(tasker, function()
                local world = self.rotate
                for _ = 1, 30 do
                    local range = 0.15
                    local da = (-world.rot) % 360
                    if da > 180 then
                        da = da - 360
                    end
                    world.rot = world.rot + da * range
                    task.Wait()
                end
                object.Del(world)
            end)
        end
    end
end--1

do
    boss.Define("2a", "西行寺幽幽子", "TH14_3_0", TH143_bg, { -200, 500 }, class.SCBG1, "Yuyuko", 13)
    local name = "灵童「异界送行提灯」"
    local card2 = boss.card.New(name, 2, 3, 60, 900)
    local card22 = boss.card.New(name, 2, 3, 60, 900)
    boss.card.add({ { card22, "2a" }, { card2, "1a" }, }, 13, name, 139)
    card2.before = CardBefore(0, 130)
    card2.del = SetFlag(2)
    card2.frame = Frame
    function card2:init()
        boss.card.UnlockOD(self, 14)
        task.New(self, function()
            task.MoveTo(0, 80, 60, 2)
            task.Wait(60)
            while true do
                boss.cast(self, 90)
                task.Wait(120)
                Newcharge_in(self.x, self.y, 250, 128, 114)
                task.Wait(60)
                Newcharge_out(self.x, self.y, 250, 128, 114)
                task.New(self, function()
                    task.MoveToPlayer(60, -180, 180, 60, 100, 20, 40, 10, 20, 2, 1)
                end)
                self.DMG_factor = 0.5
                misc.ShakeScreen(120, 1)
                task.New(self, function()
                    for _ = 1, 120 do

                        NewSimpleBullet(ball_big, 16, self.x, self.y, ran:Float(5, 9), ran:Float(0, 360), nil, nil, false)

                        PlaySound('tan00')
                        task.Wait()
                    end
                end)
                for _ = 1, 6 do
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 40) do
                        NewSimpleBullet(ball_big, 10, self.x, self.y, 4, a)
                    end
                    task.Wait(20)
                end
                self.DMG_factor = 1
                task.Wait(120)
            end
        end)
    end

    card22.before = CardBefore(0, 200, true)
    card22.del = Final
    card22.frame = Frame
    function card22:init()
        self._transport = New(Class(object, {
            frame = task.Do,
            init = function(self)
                self.group = GROUP.GHOST
                task.New(self, function()
                    while not self.finish do
                        task.Wait()
                    end
                    if self.getcard and not self.flag then
                        ext.achievement:get(146)

                    end
                    object.RawDel(self)
                end)
            end }, true))
        task.New(self, function()
            New(_editor_class.TH07.fan, self)
            task.MoveTo(0, 150, 60, 2)
            Newcharge_in(self.x, self.y, 218, 112, 214)
            New(SimpleText, 0, 0, LAYER.TOP, "顺着幽魂走到目的地吧！", 0, { 255, 255, 255 }, nil, function()
                local self = task.GetSelf()
                self.vy = -0.1
                self.size = 3
                for i = 1, 30 do
                    i = task.SetMode[2](i / 30)
                    self.alpha = 255 * i
                    self.size = 3 - 1.5 * i
                    task.Wait()
                end
                task.Wait(90)
                for i = 29, 0, -1 do
                    i = task.SetMode[2](i / 30)
                    self.alpha = 255 * i
                    self.size = 3 - 1.5 * i
                    task.Wait()
                end
                object.Del(self)
            end, nil, "centerpoint")
            local function Count(num)
                New(SimpleText, 0, 0, LAYER.TOP, num, 0, { 255, 227, 132 }, nil, function()
                    local self = task.GetSelf()
                    self.vy = -0.05
                    self.size = 3
                    for i = 1, 30 do
                        i = task.SetMode[2](i / 30)
                        self.alpha = 255 * i
                        self.size = 3 - 1.5 * i
                        task.Wait()
                    end
                    for i = 29, 0, -1 do
                        i = task.SetMode[2](i / 30)
                        self.alpha = 255 * i
                        self.size = 3 - 1.5 * i
                        task.Wait()
                    end
                    object.Del(self)
                end, nil, "centerpoint")
            end
            local Insoul = Class(object, {
                init = function(unit)
                    PlaySound("boon01")
                    unit.layer = LAYER.TOP
                    unit.group = GROUP.INDES
                    unit.r = 0
                    player.colli = false
                    self._transport.flag = true
                    task.New(unit, function()
                        for i = 1, 90 do
                            unit.r = 600 * sin(i)
                            task.Wait()
                        end
                        for i = 179, 0, -1 do
                            unit.r = 600 * sin(i * 0.5)
                            task.Wait()
                        end
                        player.colli = true
                        object.Del(unit)
                    end)
                end,
                frame = function(self)
                    task.Do(self)
                end,
                render = function(self)
                    SetImageState("white", "mul+sub", 255, 255, 255, 255)
                    misc.SectorRender(player.x, player.y, 0, self.r, 0, 360, 50)
                end,
                kill = function()
                    player.colli = true
                end,
                del = function()
                    player.colli = true
                end
            }, true)
            local soul = Class(enemy, {
                init = function(self, x, y, last, flag)
                    enemy.init(self, 27, 10)
                    self.layer = LAYER.ENEMY_BULLET_EF
                    self.colli = false
                    self.x, self.y = x, y
                    self.last = last
                    self.flag = flag
                    PlaySound("kira00")
                end,
                frame = function(self)
                    enemy.frame(self)
                    if not IsValid(self.last) and Dist(self, player) < 18 then
                        object.Kill(self)
                        if self.flag then
                            New(Insoul)
                        end
                    end
                end
            }, true)
            task.Wait(60)
            while true do
                local d = ran:Sign()
                local last
                local pointset = sp:GetPointBezier(30, 0, { player.x, player.y,
                                                            d * ran:Float(170, 190), ran:Float(-50, -120),
                                                            -d * ran:Float(170, 190), ran:Float(-50, -120),
                                                            ran:Float(-100, 100), ran:Float(-70, -50) })
                task.New(self, function()
                    for i, p in ipairs(pointset) do
                        last = New(soul, p[1], p[2], last, (i == #pointset))
                        object.Connect(self, last)
                        task.Wait(2)
                    end
                end)
                boss.cast(self, 180)
                for i = 3, 1, -1 do
                    Count(i)
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                        NewSimpleBullet(ball_big, 4, self.x, self.y, 2, a)
                    end
                    for _ = 1, 4 do
                        sakura_big.New(ran:Float(-180, 180), self.y + ran:Float(-30, 30),
                                ran:Float(0, 360), ran:Sign(), 1, -90, function(o)
                                    o.may = -0.01
                                end)
                        task.Wait(15)
                    end
                end
                sp:UnitListUpdate(self._servants)
                for _, l in ipairs(self._servants) do
                    object.Kill(l)
                end
                self.DMG_factor = 0.5
                task.Wait(180)
                self.DMG_factor = 1
                Newcharge_in(self.x, self.y, 218, 112, 214)
                task.Wait(60)
            end
        end)
    end
end--2

do
    boss.Define("3a", "二岩猯藏", "TH14_3_0", TH143_bg, { 200, 500 }, class.SCBG1, "Mamizou", 13)
    local name = "捣蛋「替身地藏破坏战术」"
    local card3 = boss.card.New(name, 1, 1, 60, 600)
    local card32 = boss.card.New(name, 1, 1, 60, 600)
    boss.card.add({ { card32, "3a" }, { card3, "1a" }, }, 13, name, 140)
    local frame = function(self)
        Frame(self)
        if self.is_combat and self.timer <= self.t3 then
            for i = 1, 3 do
                if self.stage[i] and self.hp >= 600 - i * 200 then
                    for _, b in ipairs(boss_group) do
                        b.DMG_factor = 1
                    end
                    break
                else
                    for _, b in ipairs(boss_group) do
                        b.DMG_factor = 0.11
                    end
                end
            end
        end
    end
    card3.before = CardBefore(0, 130)
    card3.del = SetFlag(3)
    card3.frame = frame
    function card3:init()
        boss.card.UnlockOD(self, 21)
        self.stage = {}
        for i = 1, 2 do
            self._bosssys:addAutoSPPoint(i * 200)
        end
        task.New(self, function()
            task.MoveTo(0, 180, 60, 2)
            while true do
                for a in sp.math.AngleIterator(0, 22) do
                    NewSimpleBullet(ball_big, 8, self.x, self.y, 2.5, a, nil, nil, false)
                end
                PlaySound("tan00")
                task.Wait(70)
            end
        end)
    end

    card32.before = CardBefore(100, 120, true)

    card32.frame = frame
    function card32:init()
        self._transport = New(Class(object, {
            frame = task.Do,
            init = function(self)
                self.group = GROUP.GHOST
                task.New(self, function()
                    while not self.finish do
                        task.Wait()
                    end
                    if self.getcard then
                        if not self.stage[1] then
                            ext.achievement:get(144)
                        elseif self.stage[3] then
                            ext.achievement:get(145)
                        end
                    end
                    object.RawDel(self)
                end)
            end }, true))
        self.stage = {}
        self.text_obj = {}
        self._transport.stage = self.stage
        for i = 1, 2 do
            self._bosssys:addAutoSPPoint(i * 200)
        end
        task.New(self, function()
            local function Text(text, c)
                table.insert(self.text_obj, New(SimpleText, 0, 0, LAYER.BG + 5, text, 0, { 200, 210, 200 }, nil, function()
                    local unit = task.GetSelf()
                    unit.type = "title"
                    unit.vy = -0.01
                    unit.size = 3
                    for i = 1, 30 do
                        i = task.SetMode[2](i / 30)
                        unit.alpha = 255 * i
                        unit.size = 3 - 1.5 * i
                        task.Wait()
                    end
                    while not self.stage[c] do
                        task.Wait()
                    end
                    for i = 29, 0, -1 do
                        i = task.SetMode[2](i / 30)
                        unit.alpha = 255 * i
                        unit.size = 3 - 1.5 * i
                        task.Wait()
                    end
                    object.Del(unit)
                end, nil, "centerpoint"))
            end
            task.MoveTo(0, 80, 60, 2)
            task.Wait()
            Text("First!\n想办法进入圈圈里", 1)
            boss.cast(self, 60)
            New(Class(object, {
                init = function(self, master)
                    self.group = GROUP.INDES
                    self.layer = LAYER.ENEMY
                    self.master = master
                    self.x, self.y = self.master.x, self.master.y
                    self._a = 200
                    self.r = 0
                    task.New(self, function()
                        PlaySound("lgods1")
                        for i = 1, 60 do
                            self.r = 80 * sin(i * 1.5)
                            task.Wait()
                        end
                    end)
                    task.New(self, function()
                        while true do
                            self.x, self.y = self.master.x, self.master.y
                            if self.timer % 3 == 0 then
                                for a in sp.math.AngleIterator(sin(self.timer / 2.7) * 360, 5) do
                                    Create.bullet_accel(self.x + cos(a) * self.r, self.y + sin(a) * self.r, grain_a, 2, 0.5, 4, a)
                                end
                                PlaySound("tan00")
                            end
                            if Dist(self, player) < self.r then
                                break
                            end
                            task.Wait()
                        end
                        for _, b in ipairs(boss_group) do
                            b.stage[1] = true
                        end
                        PlaySound("lgods3")
                        for i = 29, 0, -1 do
                            self._a = 200 * sin(i * 3)
                            task.Wait()
                        end
                        object.Del(self)
                    end)
                end,
                frame = task.Do,
                render = function(self)
                    SetImageState("circle_charge", "mul+add", self._a, 250, 128, 124)
                    Render("circle_charge", self.x, self.y, 0, self.r / 256)
                end
            }, true), self)
            while not self.stage[1] do
                task.Wait()
            end
            task.Wait(60)

            local password = {  }
            local input = {}
            do
                local t = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }
                for _ = 1, 6 do
                    table.insert(password, table.remove(t, ran:Int(1, #t)))
                end
            end
            table.insert(self.text_obj, New(SimpleText, -50, 120, LAYER.TOP, table.concat(password), 0, { 255, 255, 255 }, nil, function()
                local unit = task.GetSelf()
                unit.type = "title"
                unit.size = 3
                for i = 1, 30 do
                    i = task.SetMode[2](i / 30)
                    unit.alpha = 255 * i
                    unit.size = 3 - 1.5 * i
                    task.Wait()
                end
                while not self.stage[2] do
                    task.Wait()
                end
                for i = 29, 0, -1 do
                    i = task.SetMode[2](i / 30)
                    unit.alpha = 255 * i
                    unit.size = 3 - 1.5 * i
                    task.Wait()
                end
                object.Del(unit)
            end, nil, "left"))
            table.insert(self.text_obj, New(SimpleText, -50, 120, LAYER.TOP, table.concat(input), 0, { 64, 225, 64 }, nil, function()
                local unit = task.GetSelf()
                unit.type = "title"
                unit.size = 3
                for i = 1, 30 do
                    i = task.SetMode[2](i / 30)
                    unit.alpha = 255 * i
                    unit.size = 3 - 1.5 * i
                    task.Wait()
                end
                while not self.stage[2] do
                    unit.text = table.concat(input)
                    task.Wait()
                end
                for i = 29, 0, -1 do
                    i = task.SetMode[2](i / 30)
                    unit.alpha = 255 * i
                    unit.size = 3 - 1.5 * i
                    task.Wait()
                end
                object.Del(unit)
            end, nil, "left"))
            Text("Second!\n输入正确的数字", 2)
            task.Wait(60)
            local wrongtimes = 0
            local ate = Class(object, {
                init = function(self, t, x)
                    self.group = GROUP.INDES
                    self.layer = LAYER.ENEMY_BULLET
                    self.img = "Ningen1"
                    self.colli = false
                    self.x, self.y = x, 120
                    self.vy = 1
                    self.ag = 0.02
                    self.t = t
                end,
                frame = function(unit)
                    task.Do(unit)
                    if Dist(unit, player) < 20 then
                        object.IndesDo(function(o)
                            if abs(o.y - unit.y) < 10 then
                                object.Del(o)
                            end
                        end)
                        if wrongtimes >= 10 then
                            ext.achievement:get(111)
                        end
                        New(_editor_class.TH14.drum.boom, unit.x, unit.y)
                        PlaySound("ice", 1, 0, true)
                        table.insert(input, unit.t)
                        if input[#input] ~= password[#input] then
                            PlaySound("invalid", 1, 0, true)
                            wrongtimes = wrongtimes + 1
                            input = {}
                        elseif #input == 6 then
                            PlaySound("extend")
                            for _, b in ipairs(boss_group) do
                                b.stage[2] = true
                            end
                            object.IndesDo(function(o)
                                object.Del(o)
                            end)
                        end
                    end
                end,
                del = function(self)
                    enemy.death_ef(self.x, self.y, 10, 3)
                end,
                render = function(self)
                    local b = task.SetMode[2](min(self.timer / 30, 1))
                    SetImageState("circle_charge", "mul+add", 128, 200, 200, 200)
                    Render("circle_charge", self.x, self.y, 0, b * 20 / 256)
                    SetFontState("Score", "", b * 255, 255, 255, 255)
                    RenderText("Score", self.t, self.x, self.y, 0.7)
                    DefaultRenderFunc(self)
                end
            }, true)
            boss.cast(self, 600)
            while not self.stage[2] do
                for a in sp.math.AngleIterator(ran:Float(0, 360), 25) do
                    NewSimpleBullet(ball_big, 2, self.x, self.y, 2.5, a, nil, nil, false)
                end
                PlaySound("tan00")
                for i = 1, 9 do
                    New(ate, i, (i - 5) * 60)
                end
                task.Wait(80)
            end
            task.Wait(60)
            Text("Last!\n让大狸子攻击正邪", 3)
            task.MoveTo(0, -40, 60, 2)
            task.New(self, function()
                while not self.stage[3] do
                    task.MoveToPlayer(60, -180, 180, -50, -30, 20, 40, 10, 20, 2, 1)
                    task.Wait(60)
                end
            end)
            local frame_other = function(unit)
                if not self.stage[3] then
                    object.EnemyDo(function(o)
                        if o ~= self and Dist(unit, o) < 32 then
                            for _, b in ipairs(boss_group) do
                                b.stage[3] = true
                            end
                            New(_editor_class.TH14.drum.boom, o.x, o.y)
                            PlaySound("extend")
                            object.Del(unit)
                        end
                    end)
                end
            end
            while not self.stage[3] do
                PlaySound("tan00")
                for _ = 1, 2 do
                    rawset(NewSimpleBullet(knife, 10, self.x + ran:Float(-15, 15), self.y + ran:Float(-15, 15),
                            ran:Float(2, 4), Angle(self, player) + ran:Float(-15, 15), nil, nil, false), "frame_other", frame_other)
                end
                task.Wait(7)
            end
            task.Wait(60)
        end)
    end
    function card32:del()
        Final(self)
        sp:UnitListUpdate(self.text_obj)
        for _, unit in ipairs(self.text_obj) do
            Del(unit)
        end
    end
end--3

do
    boss.Define("4a", "八云紫", "TH14_3_0", TH143_bg, { 200, 500 }, class.SCBG1, "Yukari", 13)
    local name = "小心！「来去自由的隙间」"
    local card4 = boss.card.New(name, 2, 3, 60, 850)
    local card42 = boss.card.New(name, 2, 3, 60, 850)
    boss.card.add({ { card42, "4a" }, { card4, "1a" }, }, 13, name, 141)
    card4.before = CardBefore(0, 130)
    card4.del = SetFlag(4)
    card4.frame = Frame
    function card4:init()
        task.New(self, function()
            task.MoveTo(-200, 160, 60, 2)
            task.New(self, function()
                local t, c = 1, 180
                while true do
                    t = min(t + 1, 90)
                    c = c + sin(t) * 0.7
                    self.x = cos(c) * 200
                    task.Wait()
                end
            end)
            while true do
                for a in sp.math.AngleIterator(-90, 6) do
                    Create.bullet_decel(self.x, self.y, ball_big, 6, 5, 1.8, a, true, false)
                end
                PlaySound("tan00")
                task.Wait(12)
            end
        end)
    end

    card42.before = CardBefore(0, 200, true)
    card42.del = Final
    card42.frame = Frame
    function card42:init()
        task.New(self, function()
            task.MoveTo(0, 70, 60, 2)
            local t1 = New(class.Yukari, -120, 0, 0)
            local t2 = New(class.Yukari, 120, 0, 0)
            t1.opposite, t2.opposite = t2, t1
            boss.cast(self, 3600)
            task.Wait(60)
            task.New(self, function()
                local v = 1
                while true do
                    NewSimpleBullet(arrow_small, 4, self.x + ran:Float(-20, 20), self.y + ran:Float(-20, 20),
                            ran:Float(v - 1, v + 1), ran:Float(-5, 5) + Angle(self, player))
                    PlaySound("tan00", 0.1, 0, true)
                    v = min(4, v + 0.04)
                    task.Wait(2)
                end
            end)
            task.New(t1, function()
                local self = task.GetSelf()
                while true do
                    task.Wait(120)
                    Newcharge_in(self.x, self.y, 200, 200, 200)
                    task.Wait(60)
                    task.MoveToEx(-80, 30, 60, 2)
                    task.Wait(120)
                    task.SmoothSetValueTo("rot", -80, 60, 4)
                    task.Wait(180)
                    task.New(self, function()
                        task.SmoothSetValueTo("rot", 0, 60, 3)
                    end)
                    task.MoveTo(0, 120, 60, 2)
                    task.Wait(360)
                    task.MoveTo(-120, 0, 60, 2)
                end
            end)
            task.New(t2, function()
                local self = task.GetSelf()
                while true do
                    task.Wait(120)
                    Newcharge_in(self.x, self.y, 200, 200, 200)
                    task.Wait(60)
                    task.MoveToEx(80, -30, 60, 2)
                    task.Wait(120)
                    task.SmoothSetValueTo("rot", 80, 60, 4)
                    task.Wait(180)
                    task.New(self, function()
                        task.SmoothSetValueTo("rot", 0, 60, 3)
                    end)
                    task.MoveTo(0, 20, 60, 2)
                    task.Wait(240)
                    task.MoveTo(120, 0, 60, 2)
                    task.Wait(120)
                end
            end)
        end)
    end
    function card42:render()
        local t = self.ani
        SetImageState("yukari-ef", "mul+add", 50 + min(150, t) + sin(t * 0.7 - 90) * 50, 255, 255, 255)
        Render("yukari-ef", self.x, self.y + sin(t * 4) * 4, -0.5 * t, 1.8 + sin(t * 0.7 + 135) * 0.1)
    end
end--4

do
    boss.Define("5a", "雾雨魔理沙", "TH14_3_1", TH143_bg, { -500, 0 }, class.SCBG1, "Marisa", 13)
    local name = "暴力「魔法炸弹和魔炮」"
    local card5 = boss.card.New(name, 1, 1, 70, 600)
    local card52 = boss.card.New(name, 1, 1, 70, 600)
    boss.card.add({ { card52, "5a" }, { card5, "1a" } }, 13, name, 142)
    card5.before = CardBefore(0, 130)
    card5.del = SetFlag(5)
    card5.frame = Frame
    function card5:init()
        task.New(self, function()
            task.MoveTo(0, 120, 60, 2)
            local bomb = Class(bullet, {
                init = function(self, x, y, mx, my)
                    bullet.init(self, ball_huge, 6, false, false)
                    self.x, self.y = x, y
                    PlaySound("boon01")
                    self.omiga = ran:Sign() * 8
                    task.New(self, function()
                        task.New(self, function()
                            task.Wait(60)
                            for i = 1, 30 do
                                self._r = 255 - 255 * sin(i * 3)
                                self._g = self._r
                                self._b = self._b
                                task.Wait()
                            end
                        end)
                        task.MoveTo(mx, my, 90, 2)

                        object.Del(self)
                        PlaySound("don00", 1, 0, true)
                        New(self.class.bomb, self.x, self.y)
                        NewBon(self.x, self.y, 60, 128, 255, 227, 132)
                        NewWave(self.x, self.y, 2, 180, 45, 255, 227, 132)
                    end)
                end,
                bomb = Class(object, {
                    init = function(self, x, y)
                        object.init(self, x, y, GROUP.INDES, LAYER.ENEMY + 1)
                        self.colli = false
                    end,
                    frame = function(self)
                        if self.timer == 30 then
                            object.Del(self)
                        end
                        if Dist(self, player) < self.timer / 30 * 180 then
                            player.class.colli(player, self)
                        end
                        object.BulletDo(function(o)
                            if Dist(self, o) < self.timer / 30 * 180 then
                                object.Del(o)
                            end
                        end)
                    end,
                    render = function(self)
                        SetImageState("circle_charge", "mul+add", (1 - self.timer / 31) * 255, 255, 227, 132)
                        Render("circle_charge", self.x, self.y, 0, self.timer / 45)
                    end
                }, true)
            }, true)
            while true do
                task.Wait(60)
                task.Wait(30)
                for _ = 1, 3 do
                    New(bomb, self.x, self.y, player.x, player.y)
                    task.MoveToPlayer(60, -200, 200, 100, 140, 30, 45, 20, 40, 2, 1)
                    task.Wait(40)
                end
                task.Wait(20)
                task.Wait(60)
                task.Wait(180)
                task.Wait(60)
            end
        end)
    end

    card52.before = CardBefore(-200, 100, true)
    card52.del = Final
    card52.frame = Frame
    function card52:init()
        task.New(self, function()
            task.MoveTo(-50, 50, 60, 2)
            while true do
                boss.cast(self, 900)
                Newcharge_in(self.x, self.y, 200, 128, 233)
                task.Wait(60)
                Newcharge_out(self.x, self.y, 255, 227, 132)
                local x, y
                for i = 1, 20 do
                    for a in sp.math.AngleIterator(0, 20 + i * 2) do
                        x, y = self.x + cos(a) * i * 28, self.y + sin(a) * i * 28
                        if Dist(player, x, y) > 64 then
                            NewSimpleBullet(star_small, 14, x, y, 0, 0, nil, ran:Sign())
                        end
                    end
                    PlaySound("tan00")
                    task.Wait()
                end
                task.Wait(10)
                task.Wait(320)
                Newcharge_in(self.x, self.y, 200, 128, 233)
                task.Wait(60)
                Newcharge_out(self.x, self.y, 255, 227, 132)
                object.BulletDo(function(o)
                    object.ChangeVwithTask(o, 0, 3, Angle(self, o), 180, 0, false)
                end)
                local a, b
                misc.ShakeScreen(180, 2)
                PlaySound("nep00")
                boss.cast(self, 180, true)
                for _ = 1, 180 do
                    a = Angle(self, player)
                    b = NewSimpleBullet(ball_mid, 2, self.x, self.y, ran:Float(7, 8), ran:Float(0, 360))
                    b.timer = 11
                    b.hide = true
                    b.colli = false
                    b.frame_other = function(self)
                        if self.timer % 20 == 0 then
                            Create.saoqi_wave(self.x, self.y, ran:Float(0, 360), self, 0.6, 255, 227, 132)
                        end
                    end
                    for _ = 1, 4 do
                        b = NewSimpleBullet(ball_light, 14, self.x, self.y, ran:Float(1.8, 2.3), a + ran:Float(-50, 50))
                        b.timer = 11
                        b.ax = 0.11 * cos(a)
                        b.ay = 0.11 * sin(a)
                        b.maxv = ran:Float(9, 11)
                        b.hscale, b.vscale = 0, 0
                        b.a, b.b = 0, 0
                        b.frame_other = function(self)
                            self.hscale = self.hscale + 0.06
                            self.vscale = self.hscale
                            self.a = self.hscale * 11.5
                            self.b = self.a
                        end
                    end
                    self.x, self.y = self.x + cos(a + 180) * 0.3, self.y + sin(a + 180) * 0.3
                    task.Wait()
                end
                task.Wait(60)
            end
        end)
    end
end--5

do
    boss.Define("6a", "爱丽丝·玛格特洛依德", "TH14_3_1", TH143_bg, { -200, 400 }, class.SCBG1, "Alice", 13)
    local name = "嘲讽「巨大引力人偶」"
    local card6 = boss.card.New(name, 2, 3, 60, 500)
    local card62 = boss.card.New(name, 2, 3, 60, 500)
    boss.card.add({ { card62, "6a" }, { card6, "1a" }, }, 13, name, 143)
    card6.before = CardBefore(0, 130)
    card6.del = SetFlag(6)
    card6.frame = Frame
    function card6:init()
        task.New(self, function()
            self.bullet = _editor_class.TH14.Sejia_grain
            task.MoveTo(0, 0, 60, 2)
            local rot = 0
            task.Wait()
            for a in sp.math.AngleIterator(0, 60) do
                a = Create.bullet_decel(self.x, self.y, ball_big, 16, 4, 0, a)
                a.time = 40
                a.group = GROUP.INDES
            end
            boss.cast(self, 3600)
            while true do
                for a in sp.math.AngleIterator(rot, 4) do
                    New(self.bullet, 8, self.x, self.y, 1, a, 45, 3, -1, 44, 1, 0.5, 44)
                    New(self.bullet, 8, self.x, self.y, 1, a, 45, 3, 1, 44, 1, 0.5, 44)
                end
                rot = rot + 9
                task.Wait(14)
            end
        end)
    end

    card62.before = CardBefore(50, 200, true)
    card62.del = Final
    card62.frame = Frame
    function card62:init()
        task.New(self, function()
            local count = 0
            task.New(self, function()
                while count < 31 do
                    task.Wait()
                end
                ext.achievement:get(25)
            end)
            local cao = Class(enemy, {
                init = function(self, x, y, mx, my)
                    enemy.init(self, 1, 20)
                    self.x, self.y = x, y
                    task.New(self, function()
                        task.MoveTo(mx, my, 60, 2)
                        while true do
                            object.SetG(NewSimpleBullet(ball_mid, 16, self.x, self.y, ran:Float(0.5, 1), 90 + ran:Sign()), 0.02)
                            task.Wait(ran:Int(60, 90))
                        end
                    end)
                end,
                kill = function(self)
                    enemy.kill(self)
                    count = count + 1
                end
            }, true)
            task.MoveTo(-120, 120, 60, 2)
            New(Class(enemy, {
                init = function(self, master)
                    self.master = master
                    self.x, self.y = master.x, master.y
                    enemybase.init(self, 9990)
                    self.layer = LAYER.ENEMY - 1
                    self.a = 0
                    self.b = 0
                    self.protect = true
                    PlaySound("heal")
                    task.New(self, function()
                        for i = 1, 60 do
                            self.a = 64 * sin(i * 1.5)
                            self.b = self.a
                            task.Wait()
                        end
                    end)
                end,
                frame = function(self)
                    enemybase.frame(self)
                    if not IsValid(self.master) then
                        object.RawDel(self)
                        return
                    end
                    self.x, self.y = self.master.x, self.master.y
                    local a, da
                    for _, o in ObjList(GROUP.PLAYER_BULLET) do
                        if not o.v then
                            o.v = GetV(o)
                        end
                        a = (Angle(o, self) - o.rot) % 360
                        if a > 180 then
                            a = a - 360
                        end
                        da = (o.trail or 1300) / (Dist(o, self) + 1)
                        if da >= abs(a) then
                            o.rot = Angle(o, self)
                        else
                            o.rot = o.rot + sign(a) * da
                        end
                        o.vx = o.v * cos(o.rot)
                        o.vy = o.v * sin(o.rot)
                    end
                end,
                render = function(self)
                    SetImageState("circle_charge", "mul+add", 255, 250, 128, 114)
                    Render("circle_charge", self.x, self.y, 0, self.a / 256)
                end,
                kill = function()
                end,
                del = function()
                end
            }, true), self)
            self.colli = false
            local l = 120 * SQRT2
            local a = 135
            local rt = 0
            for x = -15, 15 do
                object.Connect(self, New(cao, x * 20, 260, x * 20, 200))
            end
            while true do
                self.x = self.x + (cos(a) * l - self.x) * 0.05
                self.y = self.y + (sin(a) * l - self.y) * 0.05
                rt = min(0.05, rt + 0.05 / 120)
                a = a + 0.5
                task.Wait()
            end
        end)
    end
end--6

do
    boss.Define("7a", "射命丸文", "TH14_3_1", TH143_bg, { -400, 400 }, class.SCBG1, "Aya", 13)
    local name = "玩 具「人形自走相机」"
    local card7 = boss.card.New(name, 2, 4, 60, 800)
    local card72 = boss.card.New(name, 2, 4, 60, 800)
    boss.card.add({ { card72, "7a" }, { card7, "1a" }, }, 13, name, 144)
    card7.before = CardBefore(0, 130)
    card7.del = function(self)
        SetFlag(7)(self)
        object.RawDel(self.laser1)
        object.RawDel(self.laser2)
    end
    card7.frame = Frame
    function card7:init()
        task.New(self, function()
            task.MoveTo(0, 80, 60, 2)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            Newcharge_out(self.x, self.y, 200, 200, 200)
            local r = 90
            while true do
                for c = -1, 1, 2 do
                    Create.bullet_decel(self.x, self.y, ellipse, 4, 5, 3, -90 + c * r + ran:Float(-1, 1), true, false)
                end
                r = r + 2
                PlaySound("tan00", 0.2, 0, true)
                task.Wait(3)
            end
        end)
    end

    card72.before = CardBefore(-200, 150, true)
    card72.del = Final
    card72.frame = Frame
    function card72:init()
        task.New(self, function()
            local camera = Class(object, {
                init = function(self, x, y, rot)
                    self.group = GROUP.INDES
                    self.layer = LAYER.ENEMY_BULLET_EF
                    self.x, self.y = x, y
                    self.img = "photoOFF"
                    self._a = 255
                    self.hscale = 1.5
                    self.vscale = 1.5
                    self.a = 96 * 1.5
                    self.b = 128 * 1.5
                    self.rect = true
                    self.colli = false
                    self.rot = rot
                    task.New(self, function()
                        PlaySound("focus")
                        lstg.var.timeslow = 2
                        for i = 1, 30 do
                            self.hscale = 1.5 - 0.6 * sin(i * 3)
                            self.vscale = self.hscale
                            self.a = 96 * self.hscale
                            self.b = 128 * self.hscale
                            task.Wait()
                        end
                        lstg.var.timeslow = 1
                        PlaySound("shutter", 1)
                        self.colli = true
                        self.on = true
                        local math = sp.geom
                        local getlaser, cx, cy
                        local cosr, sinr = cos(self.rot), sin(self.rot)
                        local rect = math.NewRectangle(
                                { self.x + -self.a * cosr - self.b * sinr, self.y + self.b * cosr - self.a * sinr },
                                { self.x + self.a * cosr - self.b * sinr, self.y + self.b * cosr + self.a * sinr },
                                { self.x + self.a * cosr + self.b * sinr, self.y + -self.b * cosr + self.a * sinr },
                                { self.x + -self.a * cosr + self.b * sinr, self.y + -self.b * cosr - self.a * sinr })
                        object.LaserDo(function(o)
                            getlaser = TenguCamera.GetLaser(rect, o)
                            if getlaser and #getlaser == 2 then
                                cx, cy = cos(o.rot), sin(o.rot)
                                laser.CutOnRadius(o, unpack(getlaser))
                                for l = getlaser[1], getlaser[2], 24 do
                                    BulletBreak_Table:New(o.x + l * cx, o.y + l * cy, o.index)
                                end
                            end
                        end)
                        task.Wait()
                        self.colli = false
                        object.Del(self)
                    end)
                end,
                frame = function(self)
                    task.Do(self)
                    CollisionCheck(self.group, GROUP.ENEMY_BULLET)
                end,
                colli = function(_, other)
                    if other.group == GROUP.ENEMY_BULLET then
                        object.Del(other)
                    end
                end,
                render = function(self)
                    SetImageState(self.img, "mul+add", self._a, 255, 255, 255)
                    DefaultRenderFunc(self)
                    if self.on then
                        SetImageState("photoON", "mul+add", self._a, 255, 255, 255)
                        Render("photoON", self.x, self.y, self.rot, self.hscale * self._a / 255 * 1.2)
                    end
                end,
                kill = function(self)
                    object.Preserve(self)
                    lstg.var.timeslow = 1
                    task.New(self, function()
                        for i = 1, 15 do
                            self._a = 255 - 255 * sin(i * 6)
                            task.Wait()
                        end
                        object.RawDel(self)
                    end)
                end,
                del = function(self)
                    self.class.kill(self)
                end
            }, true)
            task.MoveTo(0, 180, 60, 2)
            while true do
                task.Wait(90)
                boss.cast(self, 60)
                Newcharge_in(self.x, self.y, 250, 128, 114)
                task.Wait(60)
                Newcharge_out(self.x, self.y, 200, 200, 200)
                local A = Angle(self, player)
                task.MoveTo(player.x, player.y, 80, 2)
                New(camera, self.x, self.y, A)
                task.New(self, function()
                    task.Wait(32)
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 10) do
                        for v = 1, 3 do
                            NewSimpleBullet(butterfly, 2, self.x, self.y, 1.2 + v * 0.2, a + v * 18)
                        end
                    end
                end)
            end
        end)
    end
end--7

do
    boss.Define("8a", "博丽灵梦", "TH14_3_1", TH143_bg, { 500, 0 }, class.SCBG1, "Reimu", 13)
    local name = "阴阳人「阴阳玉的阴阳面」"
    local card8 = boss.card.New(name, 2, 3, 60, 600)
    local card82 = boss.card.New(name, 2, 3, 60, 600)
    boss.card.add({ { card82, "8a" }, { card8, "1a" }, }, 13, name, 145)
    card8.before = CardBefore(0, 130)
    card8.del = SetFlag(8)
    card8.frame = Frame
    function card8:init()
        task.New(self, function()
            while true do
                task.MoveTo(-70, 100, 60, 2)
                task.Wait()
                boss.cast(self, 180)
                task.Wait(240)
                task.MoveTo(70, 100, 60, 2)
                task.Wait()
                boss.cast(self, 180)
                task.Wait(240)
            end
        end)
        task.New(self, function()
            local servant = Class(object, {
                init = function(self, master, a, r, o)
                    self.x, self.y = master.x + cos(a) * r, master.y + sin(a) * r
                    self.master = master
                    self.angle = a
                    self.radius = r
                    self.da = o
                    self.rot = ran:Float(0, 360)
                    self.omiga = ran:Sign()
                    self.img = "TPyyy"
                    self._a = 0
                    self.scale = 2
                    self.group = GROUP.INDES
                    self.layer = LAYER.TOP
                    task.New(self, function()
                        for i = 1, 10 do
                            i = task.SetMode[2](i / 10)
                            self._a = 255 * i
                            self.scale = 2 - i
                            task.Wait()
                        end
                        local b
                        while true do
                            b = Create.bullet_accel(self.x, self.y, ball_big, 6, 0.5, 3, self.angle)
                            b._blend = "mul+rev"
                            bullet.SetLayer(b, LAYER.ENEMY_BULLET + 1)
                            task.Wait(18)
                        end
                    end)
                end,
                frame = function(self)
                    task.Do(self)
                    if not IsValid(self.master) then
                        object.RawDel(self)
                        return
                    end
                    self.angle = self.angle + self.da
                    self.x = self.master.x + cos(self.angle) * self.radius
                    self.y = self.master.y + sin(self.angle) * self.radius
                end,
                render = function(self)
                    SetImageState(self.img, "mul+rev", self._a, 255, 255, 255)
                    Render(self.img, self.x, self.y, self.rot, self.scale + sin(self.timer * 6) * 0.05)
                end,
                del = function(self)
                    object.Preserve(self)
                    self.dk = true
                    task.New(self, function()
                        for i = 9, 0, -1 do
                            i = task.SetMode[2](i / 10)
                            self._a = 255 * i
                            self.scale = 2 - i
                            task.Wait()
                        end
                        object.RawDel(self)
                    end)
                end
            }, true)
            task.Wait(60)
            for a in sp.math.AngleIterator(ran:Float(0, 360), 8) do
                New(servant, self, a, 90, 1)
            end
        end)
    end

    card82.before = CardBefore(90, 150, true)
    card82.del = Final
    card82.frame = Frame
    function card82:init()
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
        task.New(self, function()
            local other, x1, y1, x2, y2
            object.EnemyDo(function(o)
                if o ~= self then
                    other = o
                end
            end)
            task.MoveTo(70, 100, 60, 2)
            local YinYangYu = Class(object, {
                init = function(self, master, a, r, d)
                    self.x, self.y = master.x + cos(a) * r, master.y + sin(a) * r
                    self.master = master
                    self.angle = a
                    self.radius = r
                    self.rot = ran:Float(0, 360)
                    self.omiga = d
                    self.img = "TPyyy"
                    self._a = 0
                    self.scale = 2
                    self.group = GROUP.INDES
                    self.layer = LAYER.ENEMY
                    task.New(self, function()
                        for i = 1, 10 do
                            i = task.SetMode[2](i / 10)
                            self._a = 255 * i
                            self.scale = 2 - i
                            task.Wait()
                        end
                    end)
                end,
                frame = function(self)
                    task.Do(self)
                    if not IsValid(self.master) then
                        object.RawDel(self)
                        return
                    end
                    if not self.dk then
                        self.x = self.master.x + cos(self.angle) * self.radius
                        self.y = self.master.y + sin(self.angle) * self.radius
                        self.angle = self.angle + sin(self.angle) * player.dx - cos(self.angle) * player.dy
                    end
                end,
                render = function(self)
                    SetImageState(self.img, "mul+add", self._a, 255, 255, 255)
                    Render(self.img, self.x, self.y, self.rot, self.scale + sin(self.timer * 6) * 0.05)
                end,
                del = function(self)
                    object.Preserve(self)
                    self.dk = true
                    task.New(self, function()
                        for i = 9, 0, -1 do
                            i = task.SetMode[2](i / 10)
                            self._a = 255 * i
                            self.scale = 2 - i
                            task.Wait()
                        end
                        object.RawDel(self)
                    end)
                end
            }, true)
            task.Wait()
            while true do
                local m
                m = New(YinYangYu, player, Angle(player, self), 50, 1)
                PlaySound("goast1")
                Newcharge_in(self.x, self.y, 250, 128, 114)
                boss.cast(self, 90)
                task.Wait(60)
                self.jump[1]()
                self.x, self.y = m.x, m.y
                x1, y1 = self.x, self.y
                StopSound("goast1")
                PlaySound("goast2")
                object.Del(m)
                for a in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                    for v = 1, 3 do
                        Create.bullet_accel(self.x, self.y, square, 1, 0.5, 2 + v * 0.5, a + v * 3)
                    end
                end
                self.jump[2]()
                task.Wait()
                m = New(YinYangYu, other, Angle(player, self), 50, -1)
                PlaySound("goast1")
                Newcharge_in(self.x, self.y, 250, 128, 114)
                boss.cast(self, 90)
                task.Wait(60)
                self.jump[1]()
                self.x, self.y = m.x, m.y
                x2, y2 = self.x, self.y
                StopSound("goast1")
                PlaySound("goast2")
                for a in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                    for v = 1, 3 do
                        Create.bullet_accel(self.x, self.y, square, 1, 0.5, 2 + v * 0.5, a + v * 3)
                    end
                end
                object.Del(m)
                task.New(self, self.jump[2])
                Newcharge_in(self.x, self.y, 200, 200, 200)
                task.Wait(60)
                Newcharge_out(self.x, self.y, 200, 200, 200)
                local A = Angle(x2, y2, x1, y1)
                local ft
                object.SetV(self, 8, A + 180)
                for i = 1, 90 do
                    ft = ran:Int(15, 30)
                    for a = -1, 1, 2 do
                        rawset(NewSimpleBullet(ball_big, 4, self.x + cos(A + 90) * a * 10, self.y + sin(A + 90) * a * 10,
                                6 + sin(i * 8) * 4, A, nil, nil, false), "fogtime", ft)
                    end
                    task.Wait(2)
                end
                object.ChangingV(self, 8, 0, A + 180, 30, false)
                task.Wait(35)
            end
        end)
        task.New(self, function()
            task.New(self, function()
                while true do
                    while true do
                        if self.x > lstg.world.r or self.x < lstg.world.l then
                            break
                        end
                        task.Wait()
                    end
                    self.jump[1]()
                    self.x = -sign(self.x) * lstg.world.r
                    self.jump[2]()
                    task.Wait()
                end
            end)
            while true do
                while true do
                    if self.y > lstg.world.t or self.y < lstg.world.b then
                        break
                    end
                    task.Wait()
                end
                self.jump[1]()
                self.y = -sign(self.y) * lstg.world.t
                self.jump[2]()
                task.Wait()
            end
        end)
    end
end--8

do
    boss.Define("9a", "少名针妙丸", "TH14_3_1", TH143_bg, { 0, 500 }, class.SCBG1, "Shinmyoumaru", 13)
    local name = "无理「物理的武力雾里槌」"
    local card9 = boss.card.New(name, 2, 3, 60, 900)
    local card92 = boss.card.New(name, 2, 3, 60, 900)
    boss.card.add({ { card92, "9a" }, { card9, "1a" }, }, 13, name, 146)
    card9.before = CardBefore(0, 130)
    card9.del = SetFlag(9)
    card9.frame = Frame
    function card9:init()
        task.New(self, function()
            task.MoveTo(0, 190, 60, 2)
            task.Wait(60)
            Newcharge_in(self.x, self.y, 252, 128, 114)
            task.Wait(60)
            task.New(self, function()
                while true do
                    for a in sp.math.AngleIterator(0, 9) do
                        NewSimpleBullet(ball_big, 8, self.x, self.y, 3, a, nil, nil, false)
                    end
                    PlaySound("tan00")
                    task.Wait(15)
                end
            end)
        end)
    end

    card92.before = CardBefore(0, 210, true)
    card92.del = Final
    card92.frame = Frame
    function card92:init()
        self.CAST = _editor_class.TH14.Shinmyoumaru_cast
        task.New(self, function()
            local bon = Class(object, {
                init = function(self, x, y)
                    self.x, self.y = x, y
                    self.layer = LAYER.ENEMY + 1
                    self.group = GROUP.INDES
                    self.colli = false
                end,
                frame = function(self)
                    if self.timer == 30 then
                        object.Del(self)
                    end
                end,
                render = function(self)
                    SetImageState("circle_charge", "mul+add", (1 - self.timer / 31) * 255, 255, 227, 132)
                    Render("circle_charge", self.x, self.y, 0, self.timer / 31 / 2)
                end
            }, true)
            local blackhole = Class(object, {
                init = function(self, x, y)
                    object.init(self, x, y, GROUP.INDES, LAYER.TOP)
                    self.param = {}
                    self.imgx, self.imgy = ran:Float(-256, 256), ran:Float(-256, 256)
                    self.imgvx, self.imgvy = ran:Float(-2, 2), ran:Float(-2, 2)
                    self._a = 0
                    self.colli = false
                    New(bon, x, y)
                    NewBon(self.x, self.y, 60, 128, 255, 227, 132)
                    PlaySound("don00")
                    misc.ShakeScreen(60, 3)
                    task.New(self, function()
                        for i = 1, 10 do
                            self._a = i / 10
                            task.Wait()
                        end
                        task.Wait(200)
                        object.Del(self)
                    end)
                end,
                del = function(self)
                    object.Preserve(self)
                    task.New(self, function()
                        for i = 9, 0, -1 do
                            self._a = i / 10
                            task.Wait()
                        end
                        object.RawDel(self)
                    end)
                end,
                kill = function(self)
                    self.class.del(self)
                end,
                frame = function(self)
                    task.Do(self)
                    self.imgx = self.imgx + self.imgvx
                    self.imgy = self.imgy + self.imgvy
                    local A = Angle(player, self)
                    player.x = player.x + cos(A) * self._a * 0.4
                    player.y = player.y + sin(A) * self._a * 0.4
                    object.BulletDo(function(o)
                        A = Angle(o, self)
                        o.x = o.x + cos(A) * self._a
                        o.y = o.y + sin(A) * self._a
                    end)
                end,
                render = function(self)
                    local color1 = Color(self._a * 255, 255, 255, 255)
                    local color2 = Color(0, 255, 255, 255)
                    local point = 12
                    local r = 100
                    local ang = 360 / (2 * point)
                    for angle = 360 / point, 360, 360 / point do
                        self.param = { cos(angle + ang), sin(angle + ang), cos(angle - ang), sin(angle - ang) }
                        for _ = 1, 2 do
                            RenderTexture("Poison", "mul+rev",
                                    { self.x + r * self.param[1], self.y + r * self.param[2], 0.5, self.imgx + r * self.param[1], self.imgy + r * self.param[2], color2 },
                                    { self.x + r * self.param[3], self.y + r * self.param[4], 0.5, self.imgx + r * self.param[3], self.imgy + r * self.param[4], color2 },
                                    { self.x, self.y, 0.5, self.imgx, self.imgy, color1 },
                                    { self.x, self.y, 0.5, self.imgx, self.imgy, color1 })
                        end
                    end
                end
            }, true)
            task.MoveTo(0, 80, 60, 2)
            task.Wait()
            while true do
                self:CAST(60)
                Newcharge_in(self.x, self.y, 255, 227, 132)
                task.Wait(60)
                for d = -1, 1, 2 do
                    New(blackhole, ran:Float(150, 250) * d, ran:Float(-200, 120))
                end
                task.MoveToPlayer(60, -250, 250, 120, 160,
                        20, 40, 10, 20, 2, 1)
                for a in sp.math.AngleIterator(ran:Float(0, 360), 24) do
                    for v = 1, 3 do
                        NewSimpleBullet(ball_mid, 12, self.x, self.y, 2 + v * 0.2, a + v * 7.5, nil, nil, false)
                    end
                end
                PlaySound("tan00")
                task.Wait(90)
            end
        end)
    end
end--9

do
    boss.Define("10a", "蕾米莉亚·斯卡蕾特", "TH14_3_1", TH143_bg, { 0, 500 }, class.SCBG2, "Remilia", 13)
    boss.Define("10b", "丰聪耳神子", "TH14_3_1", TH143_bg, { 0, 500 }, class.SCBG2, "Miko", 13)
    local name = "「29秒宪法炸弹-Overdrive」"
    local sc1 = boss.card.New(name, 1, 1, 60, 1000)
    local sc2 = boss.card.New(name, 1, 1, 60, 1000)
    boss.card.add({ { sc1, "10a" }, { sc2, "10b" }, }, 13, name, 147, 13)
    function sc1:before()
        FullScreen()
        task.MoveTo(0, 0, 60, 2)
    end
    function sc1:init()
        task.New(self, function()
            while true do
                Newcharge_in(self.x, self.y, 250, 128, 114)
                task.Wait(60)
                Newcharge_out(self.x, self.y, 250, 128, 114)
                local A = 0
                for _ = 1, 720 do
                    for a in sp.math.AngleIterator(A, 8) do
                        Create.bullet_accel(self.x, self.y, knife, 2, 3, 8, a, true, nil, 0, 90)
                    end
                    A = A + 58
                    PlaySound("tan00", 0.1, 0, true)
                    task.Wait()
                end
                task.Wait(300)
            end
        end)
    end
    function sc2:before()
        task.MoveTo(0, 120, 60, 2)
    end
    function sc2:init()
        task.New(self, function()
            local linear = Class(laser, {
                init = function(self, x, y, a)
                    laser.init(self, 8, x, y, a, 0, 0, 0, 8, 12, 0)
                    laser._TurnHalfOn(self, 0, false)
                    self.line = 0
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
            local main = Class(bullet, {
                init = function(self, x, y, my)
                    bullet.init(self, ball_light, 2, false, false)
                    self.x, self.y = x, y
                    task.New(self, function()
                        task.MoveToEx(0, my, 90, 3)
                        task.Wait(30)
                        for _ = 1, 8 do
                            for a in sp.math.AngleIterator(ran:Float(0, 360), 2) do
                                New(linear, self.x, self.y, a)
                                New(_editor_class.TH12['laser1-2'], self.x, self.y, 0, a, 7, 0, 17, 20, 8, 8, 40)
                                New(_editor_class.TH12['laser1-2'], self.x, self.y, 0, a, 7, 0, -17, 20, 8, 8, 40)
                            end
                            task.Wait(2)
                        end
                        object.Del(self)
                    end)
                end
            }, true)
            while true do
                Newcharge_in(self.x, self.y, 250, 128, 114)
                for _ = 1, 60 do
                    boss.cast(self, 60)
                    task.Wait()
                end
                Newcharge_out(self.x, self.y, 250, 128, 114)
                for x = -1, 1 do
                    New(main, x * 200, ran:Float(140, 200), -200)
                end
                task.Wait(400)

            end
        end)
    end
end--od1

do
    boss.Define("11a", "幽谷响子", "TH14_3_1", TH143_bg, { 0, 500 }, class.SCBG3, "Kyouko", 13)
    boss.Define("11b", "伊吹萃香", "TH14_3_1", TH143_bg, { 0, 500 }, class.SCBG3, "Suika", 13)
    local name = "「无限念童-Overdrive」"
    local sc1 = boss.card.New(name, 1, 1, 60, 1000)
    local sc2 = boss.card.New(name, 1, 1, 60, 1000)
    boss.card.add({ { sc1, "11a" }, { sc2, "11b" }, }, 13, name, 148, 14)
    local Suika
    function sc1:before()
        FullScreen()
        task.MoveTo(0, 120, 60, 2)
    end
    function sc2:before()
        task.MoveTo(0, 0, 60, 2)
    end
    function sc1:init()
        task.New(self, function()
            task.Wait(60)
            local small_suika = Class(enemy, {
                init = function(self, x, y, v, a)
                    self.x, self.y = x, y
                    self.hscale = 1
                    self.vscale = 1
                    self._blend, self._a, self._r, self._g, self._b = "", 0, 255, 255, 255
                    self.line = 0
                    self.death_ef = 1

                    object.Connect(Suika, self)
                    enemybase.init(self, 30)
                    self._wisys = BossWalkImageSystem(self)
                    self._wisys:SetImage("Suika", 3, 4, { 4, 4, 1 }, { 1, 1 }, 8, 16, 16)
                    self._wisys:SetFloat(function(ani)
                        return 0, sin(ani * 4)
                    end)
                    self.A = 2.5
                    self.B = 2.5
                    self.flag = 2
                    self.bound = true
                    object.SetV(self, v, a)
                    task.New(self, function()
                        for _ = 1, 11 do
                            self.hscale = max(0.4, self.hscale - 0.6 / 11)
                            self.vscale = self.hscale
                            self._a = min(255, self._a + 255 / 11)
                            coroutine.yield()
                        end
                        task.Wait(ran:Int(60, 150))
                        for A in sp.math.AngleIterator(ran:Float(0, 360), 8) do
                            bullet.RemoveFog(NewSimpleBullet(grain_a, 6, self.x, self.y, 2.3, A))
                        end
                    end)
                end,
                frame = function(self)
                    self._wisys:frame()
                    enemybase.frame(self)
                    object.ReBound(self, { "l", "r", "b", "t" }, nil, self.flag > 0, function(unit)
                        PlaySound("kira00")
                        unit.flag = unit.flag - 1
                    end)
                    self.rot = 0
                end,
                render = function(self)
                    self._wisys:render()
                end
            }, true)
            local yellow = Class(bullet, {
                init = function(self, x, y, v, a)
                    bullet.init(self, square, 13, false, true)
                    self.x, self.y = x, y

                    object.SetV(self, v, a, true)
                    self.flag = 2
                    PlaySound("kira00")
                    task.New(self, function()
                        task.Wait(60)
                        if IsValid(Suika) then
                            PlaySound("kira00")
                            New(small_suika, self.x, self.y, sp.math.RectangularToPolar(self.dx, self.dy))
                            object.Del(self)
                        end
                    end)
                end,
                frame = function(self)
                    bullet.frame(self)
                    object.ReBound(self, { "l", "r", "b", "t" }, nil, self.flag > 0, function(unit)
                        PlaySound("kira00")
                        unit.flag = unit.flag - 1
                    end)
                end
            }, true)
            task.New(self, function()
                while true do
                    task.Wait(90)
                    task.MoveToPlayer(60, -250, 250, 120, 160, 20, 40, 10, 20, 2, 1)
                    task.Wait(60)
                end
            end)
            while true do
                New(yellow, self.x, self.y, 2, Angle(self, player))
                task.Wait(4)
            end
        end)
    end
    function sc2:init()
        Suika = self
    end
end--od2

do

    boss.Define("12a", "比那名居天子", "TH14_3_1", TH143_bg, { 0, 500 }, class.SCBG4, "Tenshi", 13)
    boss.Define("12b", "雾雨魔理沙", "TH14_3_1", TH143_bg, { 0, 500 }, class.SCBG4, "Marisa", 13)
    local name = "「全人类的极限火花-Overdrive」"
    local sc1 = boss.card.New(name, 1, 1, 60, 480)
    local sc2 = boss.card.New(name, 1, 1, 60, 480)
    boss.card.add({ { sc1, "12a" }, { sc2, "12b" }, }, 13, name, 217, 21)
    function sc1:before()
        FullScreen()
        task.MoveTo(-70, 0, 60, 2)
    end
    function sc1:init()
        task.New(self, function()
            while true do
                Newcharge_in(self.x, self.y, 250, 128, 114)
                task.Wait(60)
                boss.cast(self, 80)
                local a = Angle(self, player)
                for _ = 1, 80 do
                    for _ = 1, 3 do
                        local b = NewSimpleBullet(ball_light, 2, self.x, self.y, ran:Float(1.8, 2.3), a + ran:Float(-20, 20))
                        b.timer = 11
                        b.ax = 0.11 * cos(a)
                        b.ay = 0.11 * sin(a)
                        b.maxv = ran:Float(9, 11)
                        b.hscale, b.vscale = 0, 0
                        b.a, b.b = 0, 0
                        function b:frame_other()
                            self.hscale = self.hscale + 0.06
                            self.vscale = self.hscale
                            self.a = self.hscale * 11.5
                            self.b = self.a
                            local w = lstg.world
                            if not self.flag and (self.x < w.l or self.x > w.r or self.y < w.b or self.y > w.t) then
                                local x = Forbid(self.x, w.l, w.r)
                                local y = Forbid(self.y, w.b, w.t)
                                local _b=NewSimpleBullet(water_drop, 2, x, y, ran:Float(0.8, 1.9), ran:Float(0, 360))
                                _b._blend=""
                                self.flag = true
                            end
                        end
                    end
                    task.Wait()
                end
                task.Wait(100)
                task.MoveToPlayer(60, -100, 0, -30, 30,
                        20, 40, 10, 20, 2, 1)
                task.Wait(120)
            end
        end)
    end
    function sc2:before()
        task.MoveTo(70, 0, 60, 2)
    end
    function sc2:init()
        task.New(self, function()
            while true do
                Newcharge_in(self.x, self.y, 255, 227, 132)
                task.Wait(60)
                misc.ShakeScreen(180, 2)
                PlaySound("nep00")
                boss.cast(self, 180, true)
                for _ = 1, 180 do
                    local a = Angle(self, player)
                    local b = NewSimpleBullet(ball_mid, 2, self.x, self.y, ran:Float(7, 8), ran:Float(0, 360))
                    b.timer = 11
                    b.hide = true
                    b.colli = false
                    function b:frame_other()
                        if self.timer % 20 == 0 then
                            Create.saoqi_wave(self.x, self.y, ran:Float(0, 360), self, 0.6, 255, 227, 132)
                        end
                    end
                    for _ = 1, 4 do
                        b = NewSimpleBullet(ball_light, 14, self.x, self.y, ran:Float(1.8, 2.3), a + ran:Float(-40, 40))
                        b.timer = 11
                        b.ax = 0.11 * cos(a)
                        b.ay = 0.11 * sin(a)
                        b.maxv = ran:Float(9, 11)
                        b.hscale, b.vscale = 0, 0
                        b.a, b.b = 0, 0
                        function b:frame_other()
                            self.hscale = self.hscale + 0.06
                            self.vscale = self.hscale
                            self.a = self.hscale * 11.5
                            self.b = self.a
                        end
                    end
                    self.x, self.y = self.x + cos(a + 180) * 0.3, self.y + sin(a + 180) * 0.3
                    task.Wait()
                end
                task.MoveToPlayer(60, 0, 100, -30, 30,
                        20, 40, 10, 20, 2, 1)
                task.Wait(120)
            end
        end)
    end
end