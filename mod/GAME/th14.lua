local class = {}
_editor_class["TH14"] = class
local cos, sin, abs, min, max, int = cos, sin, abs, min, max, int
local bullet, object, boss = bullet, object, boss
local task, ran, Create, sp = task, ran, Create, sp
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

local function BossAction(self, time)
    if ext.sc_pr then
        StopMusic("TH14_0")
        if time ~= lstg.tmpvar.bg.timer then
            background.DelBG()
            local _, c = background.Create(TH14_bg)
            if c then
                TH14_bg.fall_leaf = nil
                for _ = 1, time do
                    TH14_bg.frame(lstg.tmpvar.bg)
                    lstg.tmpvar.bg.timer = lstg.tmpvar.bg.timer + 1
                end
                TH14_bg.fall_leaf = true
            end
        end
        task.New(self, function()
            PlayMusic("TH14_0", 0, time / 60)
            for i = 1, 60 do
                if GetMusicState("TH14_0") ~= "playing" then
                    PlayMusic("TH14_0", 0, (time + i) / 60)
                end
                SetBGMVolume("TH14_0", i / 60)
                task.Wait()
            end
        end)
        ToBigScreen(60)
    end
    self.ui.no_timeCounter = true
    self.no_hp_render = true
    self.colli = false
    self.NotPlayTimeOutSound = true
    self.__NoPlayerProtect = true
    self.__dieinstantly = true
    _object.set_color(self, "", 255, 150, 150, 150)
end
class.BossAction = BossAction
local function JumpCard(self, clean)
    self.hp = 0
    self.__NoCleanBullet = not clean
    object.BulletIndesDo(function(o)
        object.Kill(o)
    end)
    object.LaserDo(function(o)
        object.Kill(o)
    end)
end
class.JumpCard = JumpCard
local function Shinmyoumaru_cast(self, time, force)
    task.New(self, function()
        local t = 1
        while true do
            for d = 1, -1, -2 do
                for i = 1, 50 do
                    self.lr = int(sin(i * 3.6) * 28) * d
                    if (not force and self.dx ~= 0) or t >= time then
                        return
                    end
                    t = t + 1
                    task.Wait()
                end
            end
        end
    end)
end
class.Shinmyoumaru_cast = Shinmyoumaru_cast

do
    LoadAniFromFile("Wolf", "mod\\GAME\\Wolf.png", nil, 2, 3, 7)
    class["Wolf"] = Class(object, {
        init = function(self, x, y, rot, a, r, g, b, _blend, smeared)
            self.x, self.y = x or 0, y or 0
            self.rot = rot or 0
            self._a = a or 0
            self._r, self._g, self._b = r or 0, g or 0, b or 160
            self._blend = _blend or "mul+add"
            self.img = "Wolf"
            self.smeared = smeared
            self.group = GROUP.GHOST
            self.layer = LAYER.ENEMY - 1
        end,
        frame = function(self)
            task.Do(self)
            if not self.smeared then
                task.New(New(self.class, self.x, self.y, self.rot, self._a, self._r, self._g, self._b, self._blend, true), function()
                    local _self = task.GetSelf()
                    local a = _self._a
                    for i = 10, 0, -1 do
                        if not IsValid(self) then
                            break
                        end
                        object.SetSize(_self, self.hscale, self.vscale)
                        _self._a = sin(i * 9) * a
                        task.Wait()
                    end
                    object.Del(_self)
                end)
            end
        end,
        render = function(self)
            SetImgState(self, self._blend, self._a, self._r, self._g, self._b)
            DefaultRenderFunc(self)
        end
    })
    LoadTexture("bowl_tex", "mod\\GAME\\Bowl.png")
    LoadImageGroup("Bowl_", "bowl_tex", 0, 0, 256, 144, 2, 1)
    LoadImageGroup("Bowl_ps", "bowl_tex", 0, 144, 32, 32, 2, 1)
    class["Shinmyoumaru_Bowl"] = Class(object, {
        back = Class(object, {
            init = function(self, master)
                self.master = master
                self.alpha = self.master.alpha
                self.img = "Bowl_2"
                self.layer = LAYER.ENEMY - 5.1
                self.group = GROUP.GHOST
                self.bound = false
                task.New(self, function()
                    for i = 1, 60 do
                        i = i / 60
                        self.hscale = i * 2 - i * i * i
                        self.vscale = self.hscale
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
                self.rot = self.master.rot
                self.alpha = self.master.alpha
                self.x, self.y = self.master.x, self.master.y
            end,
            render = function(self)
                SetImgState(self, "", self.alpha, 255, 255, 255)
                DefaultRenderFunc(self)
            end
        }, true),
        init = function(self, master)
            self.master = master
            self.img = "Bowl_1"
            self.bound = false
            self.layer = LAYER.ENEMY + 1
            self.group = GROUP.GHOST
            self.alpha = 0
            self.ps = {}
            self.back = New(self.class.back, self)
            task.New(self, function()
                for i = 1, 60 do
                    i = i / 60
                    self.alpha = sin(i * 90) * 255
                    self.hscale = i * 2 - i * i * i
                    self.vscale = self.hscale
                    task.Wait()
                end
                self.drop_ps = true
            end)
            self.float = background.RanFloat
            self.offx = 0--x偏移量
            self.offy = 0--y偏移量
            self.offrot = 0--角度偏移量
            self.delay = nil--跟随boss是否有延迟性
        end,
        frame = function(self)
            if not IsValid(self.master) then
                object.Del(self)
                return
            end
            task.Do(self)
            if self.delay then
                self.x = self.x + (-self.x + self.master.x + self.offx) * self.delay
                self.y = self.y + (-self.y + self.master.y + self.offy - 40) * self.delay
            else
                self.x = self.master.x + self.offx
                self.y = self.master.y + self.offy - 40
            end
            self.rot = sin(self.timer * 2) * 6 + self.offrot
            local p
            if self.drop_ps then
                table.insert(self.ps, { img = math.random(1, 2),
                                        x = self.x + cos(self:float(0, -180) + self.rot) * self:float(1, 100),
                                        y = self.y + cos(self:float(0, -180) + self.rot) * self:float(30, 40) + 10,
                                        rot = self:float(0, 360), scale = self:float(0.8, 1.2),
                                        vx = self:float(-0.5, 0.5), vy = self:float(-1.5, -2.5), omiga = self:float(-1, 1),
                                        color = { self:float(150, 200), 0, 0 }, t = self.timer })
                p = self.ps[#self.ps]
                p.vx, p.vy = cos(self.rot) * p.vx - sin(self.rot) * p.vy, cos(self.rot) * p.vy + sin(self.rot) * p.vx
                table.insert(self.ps, { img = math.random(1, 2),
                                        x = self.x + cos(self:float(0, -180) + self.rot) * self:float(1, 100),
                                        y = self.y + cos(self:float(0, -180) + self.rot) * self:float(30, 40) + 20,
                                        rot = self:float(0, 360), scale = self:float(0.8, 1.2),
                                        vx = self:float(-0.3, 0.3), vy = self:float(-0.8, -1.5), omiga = self:float(-1, 1),
                                        color = { 0, 0, self:float(150, 200) }, t = self.timer })
                p = self.ps[#self.ps]
                p.vx, p.vy = cos(self.rot) * p.vx - sin(self.rot) * p.vy, cos(self.rot) * p.vy + sin(self.rot) * p.vx
            end
            for i = #self.ps, 1, -1 do
                p = self.ps[i]
                p.x = p.x + p.vx
                p.y = p.y + p.vy
                p.rot = p.rot + p.omiga
                p.scale = max(0, p.scale - 0.02)
                p.color[1] = max(0, p.color[1] - 6)
                p.color[2] = max(0, p.color[2] - 6)
                p.color[3] = max(0, p.color[3] - 6)
                if p.scale == 0 then
                    table.remove(self.ps, i)
                end
            end

        end,
        render = function(self)
            SetImgState(self, "", self.alpha, 255, 255, 255)
            DefaultRenderFunc(self)
            for _, p in ipairs(self.ps) do
                SetImageState("Bowl_ps" .. p.img, '', min(240, (self.timer - p.t) * 5), unpack(p.color))
                Render("Bowl_ps" .. p.img, p.x, p.y, p.rot, p.scale)
            end
        end
    })
    LoadTexture("Ice_block", "mod\\GAME\\Ice_block.png")
    LoadImageGroup("Ice_block", "Ice_block", 0, 0, 64, 64, 4, 1, 32, 32)
    LoadImageGroup("Ice_block_ef", "Ice_block", 0, 64, 64, 64, 4, 1, 0, 0)
    class["Ice"] = Class(object, {
        init = function(self, x, y, time, lock_player)
            self.group = GROUP.INDES
            self.layer = LAYER.ENEMY_BULLET - 1
            self.rot = ran:Float(0, 360)
            self.t = ran:Int(1, 4)
            self.img = "Ice_block_ef" .. self.t
            self._a = 0
            self.colli = false
            self.colli2 = false
            self.scale = ran:Float(0.8, 1.2)
            self.hscale = self.scale + 0.5
            self.vscale = self.hscale
            self.x, self.y = x, y
            if time <= 0 then
                object.RawDel(self)
                self.time = time
            else
                self.time = time
            end
            self.lock_player = lock_player
            self.playerice = lock_player
            if self.lock_player then
                if player.name == "Chiruno" then
                    ext.achievement:get(138)--冰块被冰块冻住
                end
                player.lock = true
                _object.set_color(player, "", 255, 135, 206, 235)
            end
            PlaySound("ice", 0.2, 0, true)
            task.New(self, function()
                for i = 0, 10 do
                    i = task.SetMode[4](i / 10)
                    self._a = i * 180
                    self.hscale = self. scale + 0.5 - 0.5 * i
                    self.vscale = self.hscale
                    task.Wait()
                end
                self.colli2 = true
                self.img = "Ice_block" .. self.t
                self.a, self.b = 0, 0
                task.Wait(self.time)
                object.Del(self)
            end)
            task.New(self, function()
                task.Wait(self.time)
                object.Del(self)
            end)
            task.New(self, function()
                task.Wait(3)
                self.colli2 = true
            end)
        end,
        del = function(self)
            if not self.dk then
                self.dk = true
                self.colli2 = false
                object.Preserve(self)
                task.New(self, function()
                    if self.lock_player then
                        player.lock = nil
                        _object.set_color(player)
                    end
                    for i = 10, 0, -1 do
                        i = task.SetMode[4](i / 10)
                        self._a = i * 180
                        self.hscale = self.scale + 0.5 - 0.5 * i
                        self.vscale = self.hscale
                        task.Wait()
                    end
                    object.RawDel(self)
                end)

            end
        end,
        kill = function(self)
            self.class.del(self)
        end,
        frame = function(self)
            task.Do(self)
            if self.colli2 then
                if not self.playerice and not player.lock and Dist(self, player) < 32 then
                    self.time = self.time - 1
                    self.playerice = true
                    New(class.Ice, player.x, player.y, self.time, true)
                end
            end
        end,
        render = function(self)
            SetImgState(self, "mul+add", self._a, 255, 255, 255)
            DefaultRenderFunc(self)
        end
    })
    LoadAniFromFile("Drum", "mod\\GAME\\Drum.png", nil, 2, 1, 8, 24, 24)
    local drum = Class(object, { frame = task.Do })
    class["drum"] = drum
    drum.boom = Class(object, {
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
            SetImageState("circle_charge", "mul+add", (1 - self.timer / 31) * 255, 127, 255, 212)
            Render("circle_charge", self.x, self.y, 0, self.timer / 31 / 2)
        end
    }, true)
    drum.frame = task.Do
    function drum:render()
        SetImgState(self, "", self._a, 255, 255, 255)
        DefaultRenderFunc(self)
    end
    function drum:init(x, y, colli)
        self.x, self.y = x, y
        self.layer = LAYER.ENEMY
        self.group = GROUP.INDES
        self.img = "Drum"
        self.colli = colli
        self._a = 0
        object.SetSize(self, 1.2)
        task.New(self, function()
            PlaySound("don00", 0.3, self.x / 300, true)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                object.SetSize(self, 1.2 - 0.2 * i)
                self._a = i * 255
                task.Wait()
            end
        end)
    end
    function drum:don()
        task.New(self, function()
            PlaySound("don00", 0.3, self.x / 300, true)
            self.vscale = 1.5
            self.hscale = 0.7
            New(drum.boom, self.x, self.y)
            for i = 1, 25 do
                i = task.SetMode[2](i / 25)
                object.SetSize(self, 0.7 + 0.3 * i, 1.5 - 0.5 * i)
                task.Wait()
            end
        end)
    end
end--object

do
    class["spray"] = Class(bullet, {
        init = function(self, x, y, v, a, time)
            bullet.init(self, water_drop, 6, false, true)
            self.x, self.y = x, y
            object.SetV(self, v, a, true)
            self.navi = true
            self.ag = ran:Float(0.01, 0.03)
            task.New(self, function()
                local A = self.a
                for i = 1, time do
                    i = 1 - sin(90 - i / time * 90)
                    self.hscale = 1 - i
                    self.vscale = self.hscale
                    self.a = A * self.hscale
                    self.b = self.a
                    task.Wait()
                end
                object.RawDel(self)
            end)
        end
    })
    class["Wolf_big"] = Class(bullet, { init = function(self, col, x, y, v1, a, time1, v2, r, time2, event)
        bullet.init(self, ball_big, col, true, true)
        self.x, self.y = x, y

        self._blend = "mul+add"
        object.SetV(self, v1, a, true)
        task.New(self, function()
            for i = 1, time1 do
                object.SetV(self, v1 - v1 * i / time1, a, true)
                task.Wait()
            end
            for i = 1, time2 do
                object.SetV(self, v2 * i / time2, a, true)
                a = a + r
                task.Wait()
            end
            object.Del(self)
            if event then
                event(self)
            end
        end)
    end })
    class["Sejia_grain"] = Class(bullet, { init = function(self, index, x, y, v, a, time, v1, r1, time1, v2, r2, time2)
        bullet.init(self, grain_c, index, false, true)
        self.x, self.y = x, y
        object.SetV(self, v, a, true)
        PlaySound("tan00", 0.1, self.x / 200, true)
        task.New(self, function()
            task.Wait(time)
            object.RawDel(self)
            local b = NewSimpleBullet(grain_a, self._index, self.x, self.y, v, self.rot, nil, nil, false)
            PlaySound("kira00", 0.2, self.x / 200, true)
            b.v = v
            b.v1 = v1
            b.r1 = r1
            b.time1 = time1
            b.v2 = v2
            b.r2 = r2
            b.time2 = time2
            task.New(b, function()
                self = task.GetSelf()
                local _v1 = self.v1 - self.v
                for i = 1, self.time1 do
                    i = i / self.time1
                    i = 2 * i - i * i
                    object.SetV(self, self.v + _v1 * i, self.rot + self. r1, true)
                    task.Wait()
                end
                object.RawDel(self)
                b = NewSimpleBullet(grain_c, self._index, self.x, self.y, self.v1, self.rot, nil, nil, false)
                PlaySound("kira01", 0.2, self.x / 200, true)
                b.v1 = self.v1
                b.v2 = self.v2
                b.r2 = self.r2
                b.time2 = self.time2
                task.New(b, function()
                    self = task.GetSelf()
                    local _v2 = self.v2 - self.v1
                    for i = 1, self.time2 do
                        i = i / self.time2
                        i = i * i
                        object.SetV(self, self.v1 + _v2 * i, self.rot + self.r2, true)
                        task.Wait()
                    end
                end)
            end)
        end)
    end })
    class["music"] = Class(bullet, {
        init = function(self, color, x, y, v, a, state)
            bullet.init(self, music, color, false, true)
            self.x, self.y = x, y
            self.rot = -90
            self.state = state
            object.SetV(self, v, a)
        end
    })
    class["sejia2"] = Class(bullet, {
        init = function(self, style, index1, index2, x, y, vx, vy, dr, dx, dy, dl, time1, time2, time3)
            bullet.init(self, style, index1, false, true)
            self.x, self.y = x, y
            local v, a = sp.math.RectangularToPolar(vx, vy)
            local l = 0
            dr, dx, dy, dl = dr or 0, dx or 0, dy or 0, dl or 0
            task.New(self, function()
                while true do
                    self.rot = a
                    self.x = x + cos(a) * l
                    self.y = y + sin(a) * l
                    l = l + v
                    task.Wait()
                end
            end)
            task.New(self, function()
                self.bound = false
                task.Wait(time1 or 37)
                local _v = v
                for i = 1, time2 or 30 do
                    v = _v * (1 - i / ((time2 or 30) + 20))
                    task.Wait()
                end
                task.Wait(time3 or 20)
                task.New(self, function()
                    local __v = v
                    for i = 1, 90 do
                        v = __v + (_v - __v) * i / 90
                        task.Wait()
                    end
                end)
                local slast = 0
                bullet.ChangeImage(self, self.imgclass, index2)
                if not self.nocreate_eff then
                    Create.bullet_create_eff(self)
                end
                PlaySound("kira00")
                for i = 1, 60 do
                    i = task.SetMode[2](i / 60)
                    a = a + (i - slast) * dr
                    x = x + (i - slast) * dx
                    y = y + (i - slast) * dy
                    l = l + (i - slast) * dl
                    slast = i
                    task.Wait()
                end
                self.bound = true
            end)
        end
    })
end--bullet

do
    class["SCBG1"] = Class(_SC_BG)
    class["SCBG1"].init = function(self)
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th14_1", true, 0, 0, 0, -0.2)
        b.blend = "mul+rev"
        b.a = 150
        b = _SC_BG.AddLayer(self, "th14_1", true, 0, 128, 0, 0.2)
        b.blend = "mul+add"
        b.a = 150
        b = _SC_BG.AddLayer(self, "th14_0", true, 0, 0, 0, -0.1, -0.3)
        b.a = 100
        b = _SC_BG.AddLayer(self, "th14_0", true, 0, 128, 0, 0.1, -0.3)
    end
    class["SCBG2"] = Class(_SC_BG)
    class["SCBG2"].init = function(self)
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th14_5", true, 0, 0, 0, -0.3, 0.1)
        b.blend = "mul+rev"
        b.Beforeframe = function(unit)
            unit.a = 30 + 20 * sin(unit.timer / 3)
        end
        b = _SC_BG.AddLayer(self, "th14_5", true, 0, 0, 0, 0.3, 0.1)
        b.blend = "mul+rev"
        b.Beforeframe = function(unit)
            unit.a = 30 + 20 * sin(unit.timer / 3)
        end
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
    class["SCBG3"] = Class(_SC_BG)
    class["SCBG3"].init = function(self)
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th14_6", true, 0, 0, 0, 0.13, 0.01, 0, "mul+rev", 0.8, 0.8)
        function b:Beforeframe()
            self.a = 178 + 70 * cos(self.timer / 2.5)
        end
        b = _SC_BG.AddLayer(self, "img_void")
        function b:Beforerender()
            _SC_BG.PolarCoordinatesRender("th14_13", 0, 120, 0, 800,
                    self.timer / 15, 512, 1, -self.timer, "",
                    Color(self._cur_alpha * (178 + 70 * sin(self.timer / 2)), 255, 255, 255))
        end
        b = _SC_BG.AddLayer(self, "th14_7")
        function b:Beforeframe()
            self.a = 108 + 70 * sin(self.timer / 2.5)
        end
        b = _SC_BG.AddLayer(self, "th14_12")
        function b:Beforeframe()
            self.a = 178 + 70 * cos(self.timer / 2)
        end
    end
    class["SCBG4"] = Class(_SC_BG)
    class["SCBG4"].init = function(self)
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th14_8", true, 0, 0, 0, 0, -0.2, 0, "mul+rev")
        function b:Beforeframe()
            self.a = 100 + 50 * sin(self.timer / 2)
        end
        b = _SC_BG.AddLayer(self, "img_void")
        function b:Beforeframe()
            self.a = 120 + 50 * cos(self.timer / 2)
        end
        function b:Beforerender()
            _SC_BG.PolarCoordinatesRender("th14_11", 0, 120, 0, 800,
                    0, 512, 1, -self.timer / 2, "",
                    Color(self._cur_alpha * self.a, 255, 255, 255))
        end
        b = _SC_BG.AddLayer(self, "th14_9", true, 0, 0, 0, 0, 0.2)
        b.a = 150
        _SC_BG.AddLayer(self, "th14_10", true, 0, 0, 0, 0.3, -0.3, 0, "mul+rev")
        b = _SC_BG.AddLayer(self, "img_void")
        function b:Beforerender()
            SetImageState("white", "mul+sub", self._cur_alpha * 255, 255, 255, 255)
            Render("white", 0, 0, 0, 40, 30)
        end
        _SC_BG.AddLayer(self, "th14_10", true, 0, 0, 0, -0.25)


    end
end--SCBG


do
    boss.Define("1a", "琪露诺", "TH14_0", TH14_bg, { -200, 300 }, nil, "Chiruno", 12)
    local n1 = boss.card.New()
    boss.card.add({ { n1, "1a" } }, 12, "第一回合", 114)
    function n1:before()
        BossAction(self, 0)
        task.MoveTo(0, 100, 60, 2)
    end
    function n1:init()
        local action = {
            function()
                task.MoveToPlayer(60, -250, 250, 50, 144, 100, 150, 24, 48, 2, 3)
            end,
            function()
                task.MoveToPlayer(60, -250, 250, 50, 144, 100, 150, 24, 48, 2, 3)
            end,
            function()
                task.MoveToPlayer(60, -250, 250, 50, 144, 100, 150, 24, 48, 2, 3)
            end,
            function()
                --local self = task.GetSelf()
                task.MoveTo(0, 200, 60, 2)
                --self._bosssys:SpecialCheckGetCard()
                --object.Del(self)
            end,
        }
        local K = Class(bullet, {
            init = function(self, x, y, v, a, time)
                bullet.init(self, ellipse, 6, false, true)
                self.x, self.y = x, y
                PlaySound("tan00")
                object.SetV(self, v, a, true)
                task.New(self, function()
                    for i = 1, time do
                        object.SetV(self, v - v * i / time, a, true)
                        task.Wait()
                    end
                    object.Del(self)
                    local sty = { ball_mid, ball_small }
                    for _ = 1, 8 do
                        NewSimpleBullet(sty[ran:Int(1, #sty)], 7 + ran:Sign(), self.x, self.y, ran:Float(1, 3), self.rot + ran:Float(-20, 20))
                    end
                end)
            end
        }, true)
        task.New(self, function()
            task.init_left_wait(self)
            for i = 1, 4 do
                task.New(self, action[i])
                for a = 60, 360, 60 do
                    for z = -1.5, 1.5 do
                        New(K, self.x, self.y, 4, a + z * 3, 87)
                    end
                end
                task.Wait2(self, 87.75 / 4)
                if i % 2 == 0 then
                    for v = 1, 3 do
                        for a = 24, 360, 24 do
                            NewSimpleBullet(ball_big, 6, self.x, self.y, 2 + v * 0.4, a + v * 10)
                        end
                    end
                    PlaySound("tan00")
                end
                task.Wait2(self, 87.75 / 4)
                local A = Angle(self, player)
                for d = -1, 1, 2 do
                    for a = 40, 360, 40 do
                        for z = -5, 5 do
                            NewSimpleBullet(ball_mid_c, 6, self.x, self.y, 3 - z / 4, A + a + (z + 9) * d * 0.5, nil, nil, false)
                        end
                    end
                    PlaySound("kira00")
                    task.Wait2(self, 87.75 / 8)
                end
                task.Wait2(self, 87.75 / 4)
            end
            for _ = 1, 6 do
                local A = Angle(self, player)
                for v = 1, 3 do
                    for a = 20, 360, 20 do
                        NewSimpleBullet(ball_big, 6, self.x, self.y, 2 + v * 0.4, A + a + v * 10)
                    end
                end
                PlaySound("tan00")
                task.Wait2(self, 175.8)
            end
            task.MoveTo(0, 500, 60, 1)
            self._bosssys:SpecialCheckGetCard()
            object.Del(self)
        end)
    end

    boss.Define("1b", "若鹭姬", "TH14_0", TH14_bg, { -500, 200 }, nil, "Wakasagihime", 12)
    local n2 = boss.card.New()
    boss.card.add({ { n2, "1b" } }, 12, "第一回合", 115)
    function n2:before()
        BossAction(self, 149)
        self._wisys:SetImageInList("Wakasagihime2")
        boss.show_aura(self, false)
        local spray = class.spray
        task.New(self, function()
            task.Wait(180)
            boss.show_aura(self, true)
        end)
        task.New(self, function()
            for _ = 1, 240 do
                self.rot = math.deg(math.atan2(self.dy, self.dx))
                New(spray, self.x, self.y, ran:Float(1, 2), self.rot + ran:Float(-30, 30) + 180, ran:Int(50, 90))
                task.Wait()
            end
        end)
        task.BezierMoveTo(240, 2, 300, 150, 150, 80)
        local x, y
        for i = 6, 360, 6 do
            x, y = self.x + cos(i) * 60, self.y + 60 + sin(i) * 20
            New(spray, self.x, self.y, Dist(self.x, self.y, x, y) / 40, Angle(self.x, self.y, x, y), ran:Int(80, 140))
            New(spray, self.x, self.y, ran:Float(1, 2), ran:Float(30, 150), ran:Int(80, 140))
        end
        PlaySound("water")
    end
    function n2:init()
        local c = 0
        local b
        self.shoot = function(x, y, a, v, o, t)
            return function()
                for i = 1, t do
                    b = Create.bullet_dec_acc(x + cos(a) * 30, y + sin(a) * 30, arrow_big, i % 2 * 2 + 6, 4, v, a, nil, nil, false)
                    b.time1 = 60
                    b.time2 = 10
                    b.time3 = 80
                    PlaySound('tan00', 0.1, x / 200, true)
                    a = a + o / t
                    v = v + 0.05
                    if c == 6 then
                        return
                    end
                    task.Wait(6)
                end
            end
        end
        task.New(self, function()
            self._wisys:SetImageInList("Wakasagihime")
            self.hscale = 0
            self.vscale = 0
            self.rot = 90
            for i = 1, 15 do
                self.hscale = i / 15
                self.vscale = i / 15
                self.rot = 90 - 90 * sin(i * 6)
                task.Wait()
            end
        end)
        task.New(self, function()
            task.init_left_wait(self)
            task.Wait2(self, 87.75 / 4)
            boss.cast(self, 3600, true)
            task.New(self, function()
                local a = 0
                while c < 6 do
                    task.New(self, self.shoot(self.x, self.y, a, 4, sin(a * 0.5) * 40, 5))
                    a = a + 13
                    task.Wait(5)
                end
                local d
                while true do
                    d = ran:Float(1, 3)
                    for z = -2, 2 do
                        for A = 0, 180, 180 do
                            A = A + a
                            Create.bullet_changeangle(self.x + cos(A + z * 5) * 30, self.y + sin(A + z * 5) * 30, ball_mid_c, 6, d + 1, A + z, false,
                                    { v = d + 1 - abs(z) * 0.1, time = 60 })
                            Create.bullet_changeangle(self.x + cos(A + z * 5) * 30, self.y + sin(A + z * 5) * 30, ball_mid_c, 6, d + 1, A + z, false,
                                    { v = d + 0.6 + abs(z) * 0.1, time = 60 })
                        end
                    end
                    PlaySound("tan00", 0.1, self.x / 200, true)
                    a = a - 19
                    task.Wait(4)
                end
            end)
            while c < 10 do
                task.BezierMoveTo(175, 3, 0, 300, -self.x, self.y)
                c = c + 1
                task.Wait2(self, 0.8 + 175.8)
                c = c + 1
            end
            task.MoveTo(0, 500, 351, 3)
            self._bosssys:SpecialCheckGetCard()
            object.Del(self)
        end)
    end
end--wave1

do
    boss.DefineGroup({
        { id = "a", name = "赤蛮奇的头", x = 0, y = 400, img = "Sekibanki_head" },
        { id = "b", name = "赤蛮奇的头", x = 0, y = 400, img = "Sekibanki_head" },
        { id = "c", name = "赤蛮奇", x = 0, y = 400, img = "Sekibanki" }
    }, 2, "TH14_0", TH14_bg, nil, 12)
    local n1 = boss.card.New()
    boss.card.add({ { n1, "2a" } }, 12, "第一回合", 116)
    function n1:before()
        BossAction(self, 703)
        boss.show_aura(self, false)
        self._wisys:SetFloat()
        self.layer = LAYER.ENEMY_BULLET_EF + 1
        task.MoveTo(0, 120, 60, 2)
    end
    function n1:init()
        self.angle = 0
        task.init_left_wait(self)
        task.New(self, function()
            local b
            task.Wait(5)
            while not self.stop do
                b = NewSimpleBullet(ellipse, 2, self.x, self.y)
                b._blend = "mul+add"
                b.rot = self.angle
                b.frame_other = function(self)
                    if self.timer > 130 then
                        object.Del(self)
                    end
                end
                task.Wait(7)
            end
        end)
        task.New(self, function()
            for _ = 1, 8 do
                for i = 1, 175 do
                    self.angle = Angle(self, player)
                    object.SetV(self, sin(i / 175 * 180) * 1.8, self.angle)
                    task.Wait()
                end
                task.Wait2(self, 0.8)
            end
            self.angle = Angle(self.x, self.y, 0, 160)
            task.MoveTo(0, 160, 175, 3)
            task.Wait2(self, 0.8)
            self.stop = true
            self.angle = -90
            task.MoveTo(0, 120, 175, 1)
            task.Wait2(self, 0.8)
            self._bosssys:SpecialCheckGetCard()
            object.Del(self)
        end)
    end
    local n2 = boss.card.New()
    boss.card.add({ { n2, "2b" } }, 12, "第一回合", 117)
    function n2:before()
        BossAction(self, 1406)
        boss.show_aura(self, false)
        self._wisys:SetFloat()
        self.layer = LAYER.ENEMY_BULLET_EF + 1
        task.MoveTo(0, 120, 60, 2)
    end
    function n2:init()
        task.init_left_wait(self)
        task.New(self, function()
            for _ = 1, 4 do
                local A = Angle(self, player)
                for z = -1, 1, 2 do
                    for a = 60, 360, 60 do
                        a = a + A
                        Create.laser_line(self.x + cos(A + 90 * z) * 8, self.y + sin(A + 90 * z) * 8, 2, 5, a, 40, 6, 8, 6)
                    end
                end
                task.MoveToPlayer(175, -200, 200, 100, 140, 80, 100, 20, 40, 2, 0)

                task.Wait2(self, 0.8)
            end
            local A = Angle(self, player)
            for z = -1, 1, 2 do
                for a = 40, 360, 40 do
                    a = a + A
                    Create.laser_line(self.x + cos(A + 90 * z) * 8, self.y + sin(A + 90 * z) * 8, 2, 5, a, 40, 6, 8, 6)
                end
            end
            task.MoveTo(0, 160, 175, 3)
            task.Wait2(self, 0.8)
            for v = 1, 5 do
                for a = 12, 360, 12 do
                    Create.bullet_accel(self.x, self.y, arrow_big, 6, 0.5, 3 + v * 0.5, a + v * 6)
                end
            end
            PlaySound("tan00")
            task.MoveTo(0, 120, 175, 1)
            task.Wait2(self, 0.8)
            self._bosssys:SpecialCheckGetCard()
            object.Del(self)
        end)
    end

    local n3 = boss.card.New()
    boss.card.add({ { n3, "2c" } }, 12, "第二回合", 118)
    function n3:before()
        BossAction(self, 2519 - 180)
        self._wisys:SetImageInList("Sekibanki2")
        boss.show_aura(self, false)
        self._wisys:SetFloat()
        task.New(self, function()
            task.Wait(120)
            boss.show_aura(self, true)
        end)
        task.MoveTo(0, 96, 180, 2)
    end
    function n3:init()
        self._wisys:SetImageInList("Sekibanki")
        self._wisys:SetFloat(function(ani)
            return 0, 4 * sin(ani * 4)
        end)
        task.New(self, function()
            local b
            self.shoot = function(self, x, y, v, a)
                b = NewSimpleBullet(ball_mid, 2, x, y, v, a, nil, nil, false)
                b._blend = "mul+add"
                b.master = player
                b.rot = 0
                b.frame_other = function(unit)
                    if not IsValid(unit.master) then
                        object.Del(unit)
                        return
                    end
                    unit.ax = cos(Angle(unit, unit.master)) * 0.04
                    unit.ay = sin(Angle(unit, unit.master)) * 0.04
                end
                object.Connect(self, b)
            end
            task.init_left_wait(self)
            for i = 1, 4 do
                boss.cast(self, 100)
                NewBon(self.x, self.y, 60, 128, 250, 128, 114)
                for a in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                    b = NewSimpleBullet(ball_big, 4, self.x, self.y, 2, a)
                end
                local A = Angle(self, player) + 360 / 7 / 2
                for a = 1, 7 do
                    for v = 0, 26 do
                        for d = -1, 1, 2 do
                            self:shoot(self.x, self.y, 8 - v * 0.24, A + a * 360 / 7 + v * 15 / 14 / 2 * d)
                        end
                    end
                end
                for a = 1, 24 do
                    self:shoot(self.x, self.y, 1, a * 15)
                end
                PlaySound("kira00")
                task.Wait2(self, 175.2 - 60)
                if i == 4 then
                    task.MoveTo(0, 400, 60, 1)
                    self._bosssys:SpecialCheckGetCard()
                    object.Del(self)
                else
                    task.MoveToPlayer(59, -200, 200, 80, 110, 40, 50, 10, 20, 2, 3)
                end
                task.Wait()
            end
        end)
    end
end--wave2

do
    boss.Define("3a", "今泉影狼", "TH14_0", TH14_bg, { -500, 0 }, nil, "Kagerou", 12)
    local n1 = boss.card.New()
    boss.card.add({ { n1, "3a" } }, 12, "第三回合", 119)
    function n1:before()
        BossAction(self, 3221 - 180)
        boss.show_aura(self, false)
        New(boss_cast_darkball, 0, 120, 60, 120, 500, 1, 270, 64, 64, 255, 1.5)
        New(boss_cast_darkball, 0, 120, 60, 120, 500, 1, 270, 255, 64, 64, -1.5)
        task.Wait(120)
        local b
        for i = 20, 360, 20 do
            b = New(class["Wolf"], cos(i) * 450, 120 + sin(i) * 450, i + 180, 0)
            b.bound = false
            task.New(b, function()
                task.MoveTo(0, 120, 60, 1)
                object.Del(task.GetSelf())
            end)
            task.New(b, function()
                local self = task.GetSelf()
                for j = 1, 10 do
                    self._a = sin(j * 9) * 255
                    task.Wait()
                end
                task.Wait(40)
                for j = 9, 0, -1 do
                    self._a = sin(j * 9) * 255
                    task.Wait()
                end
            end)
        end
        boss.show_aura(self, true)
        self.x, self.y = 0, 120
        task.Wait(60)
    end
    function n1:init()
        task.New(self, function()
            task.init_left_wait(self)
            local b
            local event = function(self)
                for v = 1, 2 do
                    b = Create.bullet_dec_acc(self.x, self.y, ball_mid, 8 + v, 4, 2 + v, self.rot + self.offrot, true, false)
                    b.time2 = 30 - v * 10
                    b.time3 = self.time / 5
                    b.time1 = 60
                end
                Create.bullet_dec_acc(self.x, self.y, ball_mid, 4, 4, 1.2 + ran:Float(0.5, 1.5), self.rot + ran:Float(-30, 30), true, false)
            end
            for i = 4, 1, -1 do
                local A = Angle(self, player)
                for a = 6, 360, 6 do
                    b = New(class.Wolf_big, 4, self.x, self.y, 4, a + A, 30, 2, i, 30 + a / 6, event)
                    b.time = a
                    b.offrot = a / 6
                    b = New(class.Wolf_big, 4, self.x, self.y, 4, -a + A, 30, 2, -i, 30 + a / 6, event)
                    b.time = a
                    b.offrot = -a / 6
                end

                PlaySound("tan00")
                task.Wait2(self, 175.2 - 60)
                if i == 1 then
                    task.MoveTo(0, 400, 60, 1)
                    self._bosssys:SpecialCheckGetCard()
                    object.Del(self)
                else
                    task.MoveToPlayer(59, -200, 200, 80, 110, 40, 50, 10, 20, 2, 3)
                end
                task.Wait()
            end
        end)
        task.New(self, function()
            local b
            local event = function(self)
                b = NewSimpleBullet(ellipse, 6, self.x, self.y, ran:Float(4, 6), self.rot, nil, nil, false)
                b._blend = "mul+add"
            end
            self._wait = {}
            task.init_left_wait(self._wait)
            for _, w in ipairs({ 0.5, 0.75, 0.25, 0.25, 0.25, 0.5, 0.75, 0.25, 0.25, 0.25, 0.75, 0.25, 0.25, 0.125, 0.25, 0.25, 1.125 }) do
                b = New(class["Wolf"], player.x + ran:Float(80, 200) * ran:Sign(), 240, -90, 0)
                task.New(b, function()
                    local self = task.GetSelf()
                    for j = 1, 30 do
                        object.SetV(self, sin(j * 3) * 10, -90, true)
                        self._a = sin(j * 3) * 255
                        task.Wait()
                    end
                end)
                task.New(b, function()
                    local self = task.GetSelf()
                    while true do
                        New(class.Wolf_big, 6, self.x + ran:Float(-15, 15), self.y + ran:Float(-30, 30), 4, -90, 30, 0.5, ran:Float(-0.1, 0.1), 30, event)
                        task.Wait(3)
                    end
                end)
                PlaySound("kira00")
                task.Wait2(self._wait, 87.6 * w)
            end
        end)
    end
end--wave3

do
    boss.DefineGroup({
        { id = "a", name = "九十九弁弁", x = -400, y = 120, img = "Benben" },
        { id = "b", name = "九十九八桥", x = 400, y = 120, img = "Yatsuhashi" },
    }, 4, "TH14_0", TH14_bg, nil, 12)
    local n1 = boss.card.New()
    local n2 = boss.card.New()
    boss.card.add({ { n1, "4a" }, { n2, "4b" } }, 12, "第四回合", 120)
    function n1:before()
        BossAction(self, 3923 - 120)
        New(bullet_cleaner, self.x, self.y, 400, 100, 100, false, false, 0, 3)
        task.New(self, function()
            boss.show_aura(self, false)
            task.Wait(60)
            boss.show_aura(self, true)
        end)
        task.MoveTo(00, 140, 120, 2)
    end
    function n1:init()
        local laser0 = function(x, y, index, a1, r1, r2)
            return Create.laser_changeangle(x, y, index, 60, 10, 3, a1,
                    { v = 4, time = 55, r = r1 * 2 }, { v = 10, time = 30, r = r2 * 3 }, { time = 40, r = -r2 / 3, v = 3 }, { v = 5, time = 450, r = r2 / 12 })
        end
        task.New(self, function()
            task.init_left_wait(self)
            for i = 5, 8 do
                boss.cast(self, 42 * 60)
                local A = Angle(self, player)
                local r1 = 3
                local r2 = 7
                for pl = -5, 5 do
                    for d = -1, 1, 2 do
                        laser0(self.x + cos(A - 45 * d) * pl * 10, self.y + sin(A - 45 * d) * pl * 10,
                                7 + pl % 2 * 7, A - 45 * d - 90 * d, r1 * -d, r2 * d)
                    end
                    r2 = r2 - 4 / 5 / 2
                    r1 = r1 - 0.6 / 5 / 2
                end
                task.Wait2(self, 175.2 - 60)
                if i == 8 then
                    task.MoveTo(400, 120, 60, 1)
                    self._bosssys:SpecialCheckGetCard()
                    object.Del(self)
                else
                    task.MoveToPlayer(59, -200, 200, 120, 160,
                            40, 50, 10, 20, 2, 3)
                end
                task.Wait()
            end
        end)

    end

    function n2:before()
        BossAction(self, 3923 - 120)
        New(bullet_cleaner, self.x, self.y, 400, 100, 100, false, false, 0, -3)
        task.New(self, function()
            boss.show_aura(self, false)
            task.Wait(60)
            boss.show_aura(self, true)
        end)
        task.MoveTo(00, 60, 120, 2)
    end
    function n2:init()
        local polar = Class(bullet, {
            init = function(self, x, y, v, a, o)
                bullet.init(self, music, 10, false, true)
                self.x, self.y = x, y
                self.rot = -90
                task.New(self, function()
                    local l = v
                    while true do
                        self.x = x + cos(a) * l
                        self.y = y + sin(a) * l
                        l = l + v
                        a = a + o
                        task.Wait()
                    end
                end)
            end
        }, true)
        task.New(self, function()
            task.init_left_wait(self)
            task.Wait2(self, 175.2 * 4 - 60)
            task.MoveTo(-400, 120, 60, 1)
            self._bosssys:SpecialCheckGetCard()
            object.Del(self)
        end)
        task.New(self, function()
            self._wait = {}
            local d = 1
            local b
            task.init_left_wait(self._wait)
            for _, w in ipairs({ 1, 0.5, 0.25, 0.25, 1.625, 0.125, 0.125, 0.125, 0.5, 0.125, 0.25, 0.375, 0.125, 0.125, 0.125, 0.125, 0.25, 1, 1 }) do
                if w >= 0.5 then
                    task.New(self, function()
                        local rot = 0
                        task.Wait(10)
                        self.jump = nil
                        while not self.jump do
                            for a = 0, 180, 180 do
                                for z = -1, 1, 2 do
                                    b = Create.bullet_changeangle(self.x, self.y, music, 2, 4, rot + a, false,
                                            { r = z * 0.25, time = 90 }, { r = -z * 0.5, time = 45 })
                                    task.New(b, function()
                                        local self = task.GetSelf()
                                        for i = 1, 40 do
                                            self.v = 4 - 3 * i / 40
                                            task.Wait()
                                        end
                                        task.Wait(60)
                                        for i = 1, 60 do
                                            self.v = 1 + 3 * i / 60
                                            object.SetV(self, self.v, self.angle, self.AutoRot)
                                            task.Wait()
                                        end
                                    end)
                                end
                            end
                            rot = rot + 55 * d
                            task.Wait(2)
                        end
                    end)
                else
                    for i = 1, 30 do
                        New(polar, self.x, self.y, 1.5, i * 12, 0.1 * d)
                    end
                end
                PlaySound("kira00")
                d = -d
                task.Wait2(self._wait, 87.6 * w)
                self.jump = true
            end
        end)
    end
end--wave4

do
    boss.Define("5a", "鬼人正邪", "TH14_0", TH14_bg, { -400, -400 }, nil, "Seija", 12)
    local n1 = boss.card.New()
    boss.card.add({ { n1, "5a" } }, 12, "第五回合", 121)
    function n1:before()
        BossAction(self, 4625 - 180)

        boss.show_aura(self, false)
        task.MoveTo(-150, -150, 80, 2)
        New(bullet_cleaner, -150, -192, 400, 99, 99, false, false)
        task.Wait(40)
        boss.cast(self, 60)
        boss.show_aura(self, true)
        task.Wait(60)
    end
    function n1:init()
        self.bullet = class["Sejia_grain"]
        self.shoot = function(self, x, y, color, radius, angle, da, rotate, dr, way, wait, v)
            task.New(self, function()
                local r
                local time1 = wait * way * 2 + 16
                v = v or 2.5
                for i = 1, way do
                    r = radius * (1 - i / way)
                    New(self.bullet, color, x + cos(angle) * r, y + sin(angle) * r, 1, angle, time1 - i * (wait * 2), v, -rotate / 2, 87, 0.6, rotate, 44)
                    angle = angle + da
                    rotate = rotate + dr
                    task.Wait(wait)
                end
            end)
        end
        task.New(self, function()
            task.init_left_wait(self)
            for i = 1, 24 do
                self:shoot(self.x, self.y, i % 2 * 4 + 2, 80, i * 15, 0, 1, 0.1, 8, 3)
                self:shoot(self.x, self.y, 6 - i % 2 * 4, 80, i * 15, 0, -1, -0.1, 8, 3)
            end
            task.BezierMoveTo(175, 3, 0, 0, 150, -150)
            task.Wait2(self, 0.2)
            for i = 1, 30 do
                self:shoot(self.x, self.y, i % 2 * 4 + 10, 130, i * 12, -0.7, -0.1, 0, 12, 3, 4)
                self:shoot(self.x, self.y, 14 - i % 2 * 4, 100, i * 12, 0.7, -1, 0, 12, 3)
            end
            task.BezierMoveTo(175, 3, 0, 0, 150, 150)
            task.Wait2(self, 0.2)
            for i = 1, 24 do
                self:shoot(self.x, self.y, i % 2 * 4 + 2, 80, i * 15, 0, 1, 0.1, 8, 3)
                self:shoot(self.x, self.y, 6 - i % 2 * 4, 80, i * 15, 0, -1, -0.1, 8, 3)
            end
            task.BezierMoveTo(175, 3, 0, 0, -150, 150)
            task.Wait2(self, 0.2)
            for i = 1, 30 do
                self:shoot(self.x, self.y, i % 2 * 4 + 10, 130, i * 12, 0.7, 0.1, 0, 12, 3, 4)
                self:shoot(self.x, self.y, 14 - i % 2 * 4, 100, i * 12, -0.7, 1, 0, 12, 3)
            end
            task.BezierMoveTo(175, 1, 0, 0, -400, -150)
            self._bosssys:SpecialCheckGetCard()
            object.Del(self)
        end)

    end
end--wave5

do

    boss.Define("6a", "少名针妙丸", "TH14_0", TH14_bg, { 0, 400 }, nil, "Shinmyoumaru", 12)
    boss.Define("6b", "鬼人正邪", "TH14_0", TH14_bg, { -400, 100 }, nil, "Seija", 12)
    boss.Define("6c", "堀川雷鼓", "TH14_0", TH14_bg, { 0, 400 }, nil, "Raiko", 12)

    local n1 = boss.card.New()
    boss.card.add({ { n1, "6a" } }, 12, "第六回合", 122)
    function n1:before()
        BossAction(self, 5327 - 180)
        self.CAST = Shinmyoumaru_cast
        boss.show_aura(self, false)
        self.back = New(class["Shinmyoumaru_Bowl"], self)
        self.back.offy = 50
        task.New(self, function()
            for i = 1, 120 do
                self.back.offrot = 360 - 360 * task.SetMode[2](i / 120)
                task.Wait()
            end
            for i = 1, 60 do
                self.back.offy = 50 - 50 * task.SetMode[2](i / 60)
                task.Wait()
            end
        end)
        task.MoveTo(0, 90, 80, 2)
        task.Wait(40)
        boss.show_aura(self, true)
        task.MoveTo(0, 140, 60, 4)
    end

    function n1:init()
        NewPulseScreen(0, nil, "mul+add", 0, 0, 30)
        object.BulletDo(function(b)
            object.RawDel(b)
        end)
        New(_editor_class.EFF_BRIGHTPILLAR, 64 * 21.9, 0, 0, 90, 400, 0, 0.3, function(self)
            self.layer = 0
            task.New(self, function()
                local k = 0
                while true do
                    self.x = sin(k * 0.3) * 200 + sin(k * 0.5) * 50
                    self.rot = sin(k * 0.6) * 5 + 90
                    k = k + 1
                    task.Wait()
                end
            end)

        end)
        New(_editor_class.EFF_BRIGHTPILLAR, 64 * 21.9, 0, 0, 90, 400, 180, 0.3, function(self)
            self.layer = 0
            task.New(self, function()
                local k = 0
                while true do
                    self.x = sin(k * 0.35) * 200 + sin(k * 0.6) * 50
                    self.rot = sin(k * 0.5) * 5 + 90
                    k = k - 1
                    task.Wait()
                end
            end)

        end)
        task.New(self, function()
            task.Wait(1526 - 180 + 60)
            JumpCard(self)
        end)
        task.New(self, function()
            task.init_left_wait(self)
            for _ = 1, 32 do
                PlaySound("kira00", 0.1, 0, true)
                task.Wait2(self, 21.9)
            end
            self.jump = true
            task.init_left_wait(self)
            task.New(self, function()
                self.back.delay = 0.1
                task.MoveTo(150, 0, 175, 3)
                task.MoveTo(-150, 0, 175, 3)
                task.MoveTo(0, 140, 175, 3)
                task.MoveTo(60, 100, 175, 3)
                self.back.delay = nil
            end)
            local _3d = Class(bullet, {
                init = function(self, x, y, z, vx, vy, vz, master, index)
                    bullet.init(self, ball_light, index, false, true)
                    PlaySound("kira00")
                    self.hscale, self.vscale = 0.4, 0.4
                    self.a, self.b = 2, 2
                    --self._blend = "mul+add"
                    --self._a = 200
                    self._x, self._y, self._z = x, y, z
                    self._vx, self._vy, self._vz = vx, vy, vz
                    self.master = master
                    bullet.SetLayer(self, LAYER.ENEMY_BULLET + (self._z + self._vz) / 10000)
                end,
                frame = function(self)
                    if not IsValid(self.master) then
                        object.Del(self)
                        return
                    end
                    bullet.frame(self)
                    self._x = self._x + self._vx
                    self._y = self._y + self._vy
                    self._z = self._z + self._vz
                    --vx是绕y轴旋转，vy是绕x轴旋转，vz是旋转比例(伪概念)
                    self.x, self.y, self.z = sp.math.ProjectionInPlane(self._x, self._y, self._z,
                            sp.math.VectorPointToPlane(self.master.x / 100, self.master.y / 100 - 1.4, 3, 0, 0, 0))
                end
            }, true)
            for a = 18, 360, 18 do
                for c = 12, 180 - 12, 12 do
                    New(_3d, 0, 100, 0, cos(a) * sin(c), sin(a) * sin(c), cos(c), self, 2)
                end
            end
            for c = -5.5, 5.5 do
                New(_3d, 0, 100, 0, 0, 0, c / 5.5, self, 2)
            end
            for _ = 1, 8 do
                for a in sp.math.AngleIterator(Angle(self, player), 17) do
                    Create.bullet_dec_acc(self.x, self.y, ball_huge, 16, 4, 4, a)
                end
                PlaySound("tan00")
                task.Wait2(self, 87.6)
            end

        end)
        task.New(self, function()
            self:CAST(176 * 4)

            local function shoot(x, y, v, a, s)
                local b = NewSimpleBullet(ball_light, 6, x, y, v, a, nil, nil, false)
                b.hscale, b.vscale = s, s
                b.a = s * 6
                b.b = b.a
                return b
            end
            local x, y
            local xl, yl
            local A = 0
            local c = 30
            while not self.jump do
                A = A + 5
                c = c + 70
                xl, yl = cos(A + 180) * 90, sin(A + 180) * 90
                for a = 36, 360, 36 do
                    x, y = cos(a) * 90 + xl, sin(a) * 90 + yl
                    local b = shoot(self.x + x / 2, self.y + y / 2,
                            Dist(0, 0, x, y) / 50, Angle(0, 0, x, y), sin(A * 5) * 0.2 + 0.6)
                    object.SetA(b, ((x - xl) * cos(A) - (y - yl) * sin(A)) / c * 0.02 + 0.02, A, false, true)
                end
                PlaySound("tan00", 0.1, 0, true)
                task.Wait(5)

            end
        end)

    end

    local n2_1 = boss.card.New()
    local n2_2 = boss.card.New()
    boss.card.add({ { n2_1, "6a" }, { n2_2, "6b" } }, 12, "第六回合", 123)
    function n2_1:before()
        self.CAST = Shinmyoumaru_cast
        self.colli = false
        if IsValid(self.back) then
            object.Del(self.back)
        end
        if ext.sc_pr then
            BossAction(self, 6733 - 60)
            task.MoveTo(60, 100, 60, 2)
        end
    end
    function n2_2:before()
        BossAction(self, 6733 - 60)
        task.MoveTo(-60, 140, 60, 2)
    end

    function n2_1:init()
        task.New(self, function()
            for _ = 1, 4 do
                task.MoveToPlayer(100, -240, 240, 80, 140, 150, 190, 25, 45, 2, 3)
                task.Wait()
                self:CAST(75)
                task.Wait(74)
            end
            task.Wait()
            JumpCard(self)
        end)
        task.New(self, function()
            task.init_left_wait(self)
            local xr, yr
            for i = 1, 4 * 10 do
                PlaySound("tan00", 0.1, self.x / 200, true)
                for a in sp.math.AngleIterator(0, 13) do
                    xr, yr = sp.math.EllipsePoint(0, 0, 2, 1, i * 55, a)
                    object.SetSizeColli(NewSimpleBullet(ball_light, 14, self.x + xr * 50, self.y + yr * 50,
                            Dist(xr * 15, yr * 15, cos(i * 55) * 80, sin(i * 55) * 80) / 50,
                            Angle(xr * 15, yr * 15, cos(i * 55) * 80, sin(i * 55) * 80), nil, nil, false), 0.5)
                end
                task.Wait(175.2 / 10)

            end
        end)
    end
    function n2_2:init()
        self.bullet = class["Sejia_grain"]
        local c = 90
        self.shoot = function(self, x, y, color, radius, angle, da, rotate, dr, _v, dv, way, wait)
            task.New(self, function()
                local r
                local time1 = wait * way * 2 + 16
                for i = 1, way do
                    r = radius * LineNum(i / way * 180 + c)
                    New(self.bullet, color, x + cos(angle) * r, y + sin(angle) * r, 1, angle, time1 - i * (wait * 2), 2, -rotate / 2, 87, _v, rotate, 44)
                    angle = angle + da
                    rotate = rotate + dr
                    _v = _v + dv
                    task.Wait(wait)
                end
            end)
        end
        task.New(self, function()
            task.init_left_wait(self)
            for _ = 1, 4 do
                for a, i in sp.math.AngleIterator(ran:Float(0, 360), 9) do
                    self:shoot(self.x, self.y, 4 + i % 2 * 2, 80, a, 1, -2, 0.12, 2, -1 / 30, 30, 1)
                    self:shoot(self.x, self.y, 6 - i % 2 * 2, 80, a, -1, 2, -0.12, 2, -1 / 30, 30, 1)
                end
                boss.cast(self, 120)
                task.Wait(60)
                task.MoveToPlayer(60, -160, 160, 130, 150, 60, 80, 20, 40, 2, 3)
                task.Wait2(self, 55.2)
                c = c + 90
            end
            task.Wait()
            JumpCard(self)
        end)

    end

    local n3_1 = boss.card.New()
    local n3_2 = boss.card.New()
    local n3_3 = boss.card.New()
    boss.card.add({ { n3_1, "6a" }, { n3_2, "6b" }, { n3_3, "6c" } }, 12, "第六回合", 124)
    function n3_1:before()
        self.CAST = Shinmyoumaru_cast
        self.colli = false
        if ext.sc_pr then
            BossAction(self, 7433 - 60)
            task.MoveTo(100, 120, 60, 2)
        end
    end
    function n3_2:before()
        self.colli = false
        if ext.sc_pr then
            BossAction(self, 7433 - 60)
            task.MoveTo(-100, 120, 60, 2)
        end
    end
    function n3_3:before()
        BossAction(self, 7433 - 60)
        task.MoveTo(0, 120, 60, 2)
    end

    function n3_1:init()
        task.New(self, function()
            local b, l
            local shoot = function(x, y, t, v, a)
                b = NewSimpleBullet(ellipse, 12, x, y, v, a, nil, nil, false)
                if t == 4 then
                    task.New(b, function()
                        local self = task.GetSelf()
                        self.bound = false
                        object.ChangingV(self, v, 0, a, 87, true)
                        l = Create.laser_line(self.x, self.y, 14, v * 2, self.rot + 150, 20, 8, 5, 8)
                        l.layer = LAYER.ENEMY_BULLET - 1
                        l = Create.laser_line(self.x, self.y, 14, v * 2, self.rot + 210, 20, 8, 5, 8)
                        l.layer = LAYER.ENEMY_BULLET - 1
                        self.bound = true
                        object.SetV(self, v * 1.5, a, true)
                        BulletBreak_Table:New(self.x, self.y, 12)
                    end)
                end
            end
            for i = 1, 4 do
                for _, x, y in sp.math.EllipseIterator(0, 30, 0, 0, 1, 0.5, Angle(self, player) + 90) do
                    for v = 1, 3 do
                        v = 3.7 + v * 0.3
                        shoot(self.x, self.y, v, sp.math.RectangularToPolar(x * v, y * v))
                    end
                end
                if i < 4 then
                    task.Wait(175)
                end
            end
            task.MoveTo(0, 500, 100, 1)
            object.Del(self)
            self._bosssys:SpecialCheckGetCard()
        end)
        task.New(self, function()
            local t = 0
            local x, y
            while true do
                x, y = 100 * cos(t), 120 + 70 * sin(t)
                self.x = self.x + (-self.x + x) * 0.05
                self.y = self.y + (-self.y + y) * 0.05
                t = t + 1
                task.Wait()
            end
        end)
    end
    function n3_2:init()
        task.New(self, function()
            local rotating = class["sejia2"]
            local d = 1
            for k = 1, 4 do
                for i, x, y in sp.math.PolygonIterator(0, 80, 0, 0, 3, 4, ran:Float(0, 360)) do
                    if int((i + 2) / 5) % 2 == 0 then
                        for v = 1, 3 do
                            New(rotating, ellipse, 2, 4, self.x, self.y, x, y, v * 45 * d, 0, 0, -20 * sqrt(x * x + y * y) * v)
                        end
                    end
                end
                d = -d
                PlaySound("tan00")
                if k < 4 then
                    task.Wait(175)
                end
            end
            task.MoveTo(0, 500, 100, 1)
            object.Del(self)
            self._bosssys:SpecialCheckGetCard()
        end)
        task.New(self, function()
            local t = 180
            local x, y
            while true do
                x, y = 100 * cos(t), 120 + 70 * sin(t)
                self.x = self.x + (-self.x + x) * 0.05
                self.y = self.y + (-self.y + y) * 0.05
                t = t + 1
                task.Wait()
            end
        end)
    end
    function n3_3:init()
        task.New(self, function()
            local b
            local shoot = function(x, y, v, a)
                b = NewSimpleBullet(grain_a, 8, x, y, v, a, nil, nil, false)
                b.flag = 1
                b.frame_other = function(self)
                    bullet.ReBound(self, { "t" }, nil, self.flag > 0, function(o)
                        o.flag = 0
                        bullet.ChangeImage(self, self.imgclass, 16)
                        Create.bullet_create_eff(o)
                    end)
                end
            end
            local boom = Class(object, {
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
                    SetImageState("circle_charge", "mul+add", (1 - self.timer / 31) * 255, 127, 255, 212)
                    Render("circle_charge", self.x, self.y, 0, self.timer / 31 / 2)
                end
            }, true)
            task.init_left_wait(self)
            for i = 1, 8 do
                boss.cast(self, 10)
                for a in sp.math.AngleIterator(ran:Float(0, 360), 30) do
                    for z = -1, 1 do
                        shoot(self.x + cos(a) * 30, self.y + sin(a) * 30 - 30, 2 - abs(z) * 0.05, a + z)
                    end
                end
                PlaySound("don00")
                New(boom, self.x, self.y - 30)
                if i < 8 then
                    task.Wait2(self, 175.2 / 2)
                end
            end
            task.MoveTo(0, 500, 60, 1)
            object.Del(self)
            self._bosssys:SpecialCheckGetCard()
        end)
    end
end--wave6

do
    boss.DefineGroup({
        { id = "a", name = "若鹭姬", x = -300, y = 400, img = "Wakasagihime2" },
        { id = "b", name = "赤蛮奇", x = 0, y = 400, img = "Sekibanki" },
        { id = "c", name = "今泉影狼", x = -500, y = 0, img = "Kagerou" },
        { id = "d", name = "九十九弁弁", x = -400, y = 400, img = "Benben" },
        { id = "e", name = "九十九八桥", x = 400, y = 400, img = "Yatsuhashi" },
    }, 7, "TH14_0", TH14_bg, class.SCBG1, 12)
    local Wakasagihime_attack = function(...)
        local arg = { ... }
        return function(self)
            self.navi = true
            task.New(self, function()
                task.BezierMoveTo(174, 2, unpack(arg))
                self.jump = true
                task.Wait()
                JumpCard(self)
                self.jump = nil
            end)
            task.New(self, function()
                local b
                self.shoot = function(x, y, a, v, o, t)
                    return function()
                        for i = 1, t do
                            b = Create.bullet_dec_acc(x + cos(a) * 30, y + sin(a) * 30, arrow_big, i % 2 * 2 + 6, 4, v, a, nil, nil, false)
                            b.time1 = 30
                            b.time2 = 0
                            b.time3 = 40
                            PlaySound('tan00', 0.1, x / 200, true)
                            a = a + o / t
                            v = v + 0.05
                            if self.jump then
                                break
                            end
                            task.Wait(6)
                        end
                    end
                end
                local o = 10
                task.init_left_wait(self)
                while not self.jump do
                    New(class.spray, self.x, self.y, ran:Float(1, 2), self.rot + ran:Float(-30, 30) + 180, ran:Int(50, 90))
                    task.New(self, self.shoot(self.x, self.y, self.rot + 90, 3, o, 3))
                    task.New(self, self.shoot(self.x, self.y, self.rot - 90, 3, o, 3))
                    o = o - 10
                    --Create.bullet_accel(self.x, self.y, ball_light, 6, 1, ran:Float(1, 3), ran:Float(0, 360))
                    task.Wait(4)
                end
            end)
        end
    end
    local Sekibanki_attack = function(d)
        return function(self)
            task.New(self, function()
                task.MoveToPlayer(175, -200, 200, 150, 170,
                        110, 150, 10, 20, 2, 3)
                JumpCard(self)
            end)
            task.New(self, function()
                local polar = Class(bullet, {
                    init = function(unit, master, v, a, l)
                        bullet.init(unit, ellipse, 2, false, true)
                        unit.x = master.x
                        unit.y = master.y
                        task.New(unit, function()
                            while true do
                                if not IsValid(master) then
                                    object.Del(unit)
                                    return
                                end
                                unit.x = master.x + cos(a) * l
                                unit.y = master.y + sin(a) * l
                                unit.rot = a
                                l = l + v
                                a = a - master.dx / 3
                                task.Wait()
                            end
                        end)
                    end
                }, true)
                for a in sp.math.AngleIterator(ran:Float(0, 360), 23) do
                    for v = 2, 10 do
                        New(polar, self, 0.5 + v * 0.4, a + v * d, 0)
                    end
                end
            end)
        end
    end
    local Kagerou_attack = function(n)
        return function(self)
            task.New(self, function()
                local b
                local shoot = function(rx, ry, mx, my, wait)
                    for a, i in sp.math.AngleIterator(ran:Float(0, 360), 3) do
                        b = NewSimpleBullet(arrow_big, 6, rx, ry, ran:Float(1, 3), a, nil, nil, false)
                        b._blend = "mul+add"
                        b.i = i
                        b.mx, b.my = mx * 5, my * 5
                        b.afv, b.afa = sp.math.RectangularToPolar(mx, my)
                        b.wait = wait
                        bullet.SetLayer(b, LAYER.ENEMY_BULLET + 1)
                        task.New(b, function()
                            local unit = task.GetSelf()
                            object.ChangingV(unit, GetV(unit), 0, unit.rot, 60 - unit.wait)
                            bullet.ChangeImage(unit, ball_mid, 6)
                            Create.bullet_create_eff(unit)
                            PlaySound("kira00")
                            object.ChangeVwithTask(unit, 0, unit .afv, unit.afa, 30)
                            task.MoveToEx(unit.mx * unit.i - unit.x, unit.my * unit.i - unit.y, 30, 2)
                        end)
                    end
                end
                for i, x, y in sp.math.PolygonIterator(0, n * 8, 0, 0, 4, n, ran:Float(0, 360)) do
                    shoot(self.x + ran:Float(-50, 50), self.y + ran:Float(-50, 50), x, y, i)
                    task.Wait()
                end
                task.Wait(175 - n * 8)
                JumpCard(self)
            end)
        end
    end
    local Tsukumo_attack = function(d, col)
        return function(self)
            task.New(self, function()
                task.Wait(175)
                JumpCard(self)
            end)
            task.New(self, function()
                local b
                local rot = 0
                while not self.jump do
                    for a = 0, 180, 180 do
                        for z = -1, 1, 2 do
                            b = Create.bullet_changeangle(self.x, self.y, music, col, 4, rot + a, false,
                                    { r = -z * 0.25, time = 90 }, { r = z * 0.4, time = 45 })
                            task.New(b, function()
                                local unit = task.GetSelf()
                                for i = 1, 80 do
                                    unit.v = 4 - 4 * i / 80
                                    task.Wait()
                                end
                                for i = 1, 30 do
                                    unit.v = 3 * i / 30
                                    object.SetV(unit, unit.v, unit.angle, unit.AutoRot)
                                    task.Wait()
                                end
                            end)
                        end
                    end
                    rot = rot + 20 * d
                    task.Wait(3)
                end
            end)
        end
    end
    local n1_1 = boss.card.New()
    boss.card.add({ { n1_1, "7a" } }, 12, "第七回合", 125)
    function n1_1:before()
        BossAction(self, 8138 - 60)
        task.Wait(60)
    end

    n1_1.init = Wakasagihime_attack(-100, -100, 500, -100)

    local n2_1 = boss.card.New()
    local n2_2 = boss.card.New()
    boss.card.add({ { n2_1, "7a" }, { n2_2, "7b" } }, 12, "第七回合", 126)
    function n2_1:before()
        self.colli = false
        self.x, self.y = 0, 500
        if ext.sc_pr then
            BossAction(self, 8138 - 60 + 175)
            task.Wait(60)
        end
    end
    function n2_2:before()
        BossAction(self, 8138 - 60 + 175)
        task.MoveTo(0, 150, 60, 2)
    end

    n2_1.init = Wakasagihime_attack(-300, 100, -300, -500)
    n2_2.init = Sekibanki_attack(1)

    local n3_1 = boss.card.New()
    local n3_2 = boss.card.New()
    local n3_3 = boss.card.New()
    boss.card.add({ { n3_1, "7a" }, { n3_2, "7b" }, { n3_3, "7c" } }, 12, "第七回合", 127)
    function n3_1:before()
        self.colli = false
        self.x, self.y = 300, -500
        if ext.sc_pr then
            BossAction(self, 8138 - 60 + 175 * 2)
            task.Wait(60)
        end
    end
    function n3_2:before()
        self.colli = false
        if ext.sc_pr then
            BossAction(self, 8138 - 60 + 175 * 2)
            task.MoveTo(0, 150, 60, 2)
        end
    end
    function n3_3:before()
        BossAction(self, 8138 - 60 + 175 * 2)
        object.SetSize(self, 0)
        task.New(New(class.Wolf, self.x, self.y, Angle(self, 0, 50), 220, 250, 250, 250, ""), function()
            local self = task.GetSelf()
            self.bound = false
            task.MoveTo(0, 50, 50, 2)
            for i = 1, 10 do
                object.SetSize(self, 1 - i / 10)
                task.Wait()
            end
            object.Del(self)
        end)
        task.MoveTo(0, 50, 50, 2)
        for i = 1, 10 do
            object.SetSize(self, i / 10)
            task.Wait()
        end
    end

    n3_1.init = Wakasagihime_attack(300, 300, -500, 500, -200, 100)
    n3_2.init = Sekibanki_attack(-1)
    n3_3.init = Kagerou_attack(4)

    local n4_1 = boss.card.New("", 60, 60, 60, 600)
    local n4_2 = boss.card.New("", 60, 60, 60, 600)
    local n4_3 = boss.card.New("", 60, 60, 60, 600)
    local n4_4 = boss.card.New("", 60, 60, 60, 600)
    local n4_5 = boss.card.New("", 60, 60, 60, 600)
    boss.card.add({ { n4_1, "7a" }, { n4_2, "7b" }, { n4_3, "7c" }, { n4_4, "7d" }, { n4_5, "7e" } }, 12, "第七回合", 128)
    function n4_1:before()
        --self.__no_drop_explode_cherry=true
        self.colli = false
        self.x, self.y = 500, 0
        if ext.sc_pr then
            BossAction(self, 8138 - 60 + 175 * 3)
            task.Wait(60)
        end
    end
    function n4_2:before()
        self.__no_drop_explode_cherry = true
        self.colli = false
        if ext.sc_pr then
            BossAction(self, 8138 - 60 + 175 * 3)
            task.MoveTo(0, 150, 60, 2)
        end
    end
    function n4_3:before()
        self.__no_drop_explode_cherry = true
        self.colli = false
        if ext.sc_pr then
            BossAction(self, 8138 - 60 + 175 * 3)
            object.SetSize(self, 0)
            task.New(New(class.Wolf, self.x, self.y, Angle(self, 0, 50), 220, 250, 250, 250, ""), function()
                local self = task.GetSelf()
                self.bound = false
                task.MoveTo(0, 50, 50, 2)
                for i = 1, 10 do
                    object.SetSize(self, 1 - i / 10)
                    task.Wait()
                end
                object.Del(self)
            end)
            task.MoveTo(0, 50, 50, 2)
            for i = 1, 10 do
                object.SetSize(self, i / 10)
                task.Wait()
            end
        end
    end
    function n4_4:before()
        self.__no_drop_explode_cherry = true
        BossAction(self, 8138 - 60 + 175 * 3)
        task.MoveTo(-120, 70, 60, 2)
    end
    function n4_5:before()
        self.__no_drop_explode_cherry = true
        BossAction(self, 8138 - 60 + 175 * 3)
        task.MoveTo(120, 70, 60, 2)
    end

    n4_1.init = Wakasagihime_attack(0, 300, -200, 0)
    n4_2.init = Sekibanki_attack(0)
    n4_3.init = Kagerou_attack(5)
    n4_4.init = Tsukumo_attack(1, 2)
    n4_5.init = Tsukumo_attack(-1, 6)
end--wave7

DoFile("mod\\GAME\\th14_2.lua")