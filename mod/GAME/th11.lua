local function BossAction(self, time)
    if ext.sc_pr then
        StopMusic("TH11_0")
        local _, c = background.Create(TH11_bg)
        if c then
            for _ = 1, time do
                TH11_bg.frame(lstg.tmpvar.bg)
                lstg.tmpvar.bg.timer = lstg.tmpvar.bg.timer + 1
            end
        end
        task.New(self, function()
            PlayMusic("TH11_0", 0, time / 60)
            for i = 1, 60 do
                if GetMusicState("TH11_0") ~= "playing" then
                    PlayMusic("TH11_0", 0, (time + i) / 60)
                end
                SetBGMVolume("TH11_0", i / 60)
                task.Wait()
            end
        end)

        ToBigScreen(60)
    end
    self.ui.no_timeCounter = true
    self.no_hp_render = true
    self.colli = false
    self.NotPlayTimeOutSound = true
    self.__dieinstantly = true
    _object.set_color(self, "", 255, 150, 150, 150)
end
local class = {}
_editor_class["TH11"] = class

local cos, sin, abs, min, max = cos, sin, abs, min, max
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
local charge_out = charge_out

local beat = 3600 / 178

do
    class["SCBG1"] = Class(_SC_BG)
    class["SCBG1"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th11_2", true, 0, 0, 0, 0, 0, -0.1, "mul+add", 1, 1,
                nil,
                function(unit)
                    unit.x = -180 - 44 * cos(unit.timer / 10)
                end)
        _SC_BG.AddLayer(self, "th11_1", true, 0, 0, 0, -0.5, 0, 0, "mul+add", 1, 1,
                function(unit)
                    unit.a = 120
                end,
                function(unit)
                    unit.r = 155 + sin(unit.timer) * 100
                end)
        _SC_BG.AddLayer(self, "th11_0_n", false, 0, 0, 0, 0, 0, 0, "", 1, 1,
                function(unit)
                    unit.r, unit.g, unit.b = 150, 150, 150
                end)
    end
    class["SCBG2"] = Class(_SC_BG)
    class["SCBG2"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th11_3", true, 0, 0, 0, 0, 1, 0, "mul+add", 1, 1,
                nil,
                function(unit)
                    unit.g = 155 + sin(unit.timer) * 100
                end)
        _SC_BG.AddLayer(self, "th11_4", true, 0, 0, 0, 1, -1)
    end
    class["SCBG3"] = Class(_SC_BG)
    class["SCBG3"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th11_6", false, 0, 0, 0, 0, 0, 0.4, "mul+add", 4, 4,
                nil,
                function(unit)
                    unit.b = 155 + sin(unit.timer / 4) * 100
                end)
        _SC_BG.AddLayer(self, "th11_8", true, 0, 0, 0, -1, 2,
                nil, nil, nil, nil, nil,
                function(unit)
                    unit.a = 155 + sin(unit.timer / 2) * 100
                end)
        _SC_BG.AddLayer(self, "th11_7", false, 0, 0, 0, 0, 0, -0.5, "mul+add", 4, 4,
                nil,
                function(unit)
                    unit.r = 155 + sin(unit.timer / 3) * 100
                end)
        _SC_BG.AddLayer(self, "th11_5", false, 0, 0, 0, 0, 0, -0.5, "", 4, 4)

    end
    CreateRenderTarget("SCBG4:TH11-warp")
    class["SCBG4"] = Class(_SC_BG)
    class["SCBG4"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th11_11", false, 0, 0, 0, 0, 0, -0.3, "mul+add", 1.7, 1.7)
        _SC_BG.AddLayer(self, "th11_10", true, 0, 0, 0, 0, 1, 0, "", 1, 1,
                function(unit)
                    unit.a = 180
                end,
                function(unit)
                    unit.r = 155 + sin(unit.timer / 3) * 100
                end)
        _SC_BG.AddLayer(self, "th11_9", false, 0, 0, 0, 0, 0, 0, "mul+add", 2, 2,
                function(unit)
                    unit.a = 150
                end,
                function(unit)
                    unit.b = 155 + sin(unit.timer / 3) * 100
                end)
        _SC_BG.AddLayer(self, "th11_12", true, 0, 0, 0, -0.6, -0.6)
        self.n = {}
    end
    class["SCBG4"].render = function(self)
        if self.alpha <= 0 then
            return
        end
        PushRenderTarget("SCBG4:TH11-warp")
        RenderClear(Color(255, 0, 0, 0))
        _SC_BG.render(self)
        PopRenderTarget("SCBG4:TH11-warp")
        local color = Color(255, 255, 255, 255)
        local N = 120
        local w = 480 / N
        local t
        local radius = 6
        local uv1, uv2, uv3, uv4 = { [3] = 0.5, [6] = color }, { [3] = 0.5, [6] = color }, { [3] = 0.5, [6] = color }, { [3] = 0.5, [6] = color }
        local WorldToScreen = WorldToScreen
        for i = 1, N do
            t = sin(self.timer * 5 + i * 10) * radius
            uv1[1], uv1[2] = -320 - radius + t, 240 - (i - 1) * w
            uv2[1], uv2[2] = 320 - radius + t, 240 - (i - 1) * w
            uv3[1], uv3[2] = 320 - radius + t, 240 - i * w
            uv4[1], uv4[2] = -320 - radius + t, 240 - i * w
            uv1[4], uv1[5] = WorldToScreen(-320 - radius, 240 - (i - 1) * w)
            uv2[4], uv2[5] = WorldToScreen(320 - radius, 240 - (i - 1) * w)
            uv3[4], uv3[5] = WorldToScreen(320 - radius, 240 - i * w)
            uv4[4], uv4[5] = WorldToScreen(-320 - radius, 240 - i * w)
            RenderTexture("SCBG4:TH11-warp", "", uv1, uv2, uv3, uv4)
        end
    end
    class["SCBG5"] = Class(_SC_BG)
    class["SCBG5"].init = function(self)
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th10_9", true, 0, 0, 0, 0, 0.8, 0, "mul+add", 1, 1,
                function(unit)
                    unit.a = 180
                end,
                function(unit)
                    unit.r = 150 + cos(unit.timer * 0.4) * 100
                    unit.g = 155 + sin(unit.timer * 0.4) * 100
                    unit.b = 155 + cos(unit.timer * 0.4) * 100
                end)
        _SC_BG.AddLayer(self, "th11_2", true, 0, 0, 0, 0, 0, -0.1, "mul+add", 1, 1,
                nil,
                function(unit)
                    unit.x = -180 - 44 * cos(unit.timer / 10)
                end)
        _SC_BG.AddLayer(self, "th10_12_n", false, 0, 0, 0,
                0, 0, 0, "", 0.5, 0.5, function(unit)
                    unit.r, unit.g, unit.b = 150, 150, 150
                end)
    end
end---_SC_BG

do
    class["bullet0-1"] = Class(bullet, {
        init = function(self, _x, _y, a)
            bullet.init(self, ball_huge, COLOR.GREEN, false, true)
            self.x, self.y = _x, _y
            PlaySound("tan00", 0.1, self.x / 256)
            object.SetV(self, 1, a, true)
            object.SetA(self, 0.05, a, false)
            task.New(self, function()
                local t = 100
                local posa, posl, A, b
                while true do
                    posa = ran:Float(0, 360)
                    posl = ran:Float(0, 30)
                    A = ran:Float(0, 360)
                    for _ = 1, 5 do
                        b = NewSimpleBullet(grain_b, 4, self.x + cos(posa) * posl + cos(A) * 7, self.y + sin(posa) * posl + sin(A) * 7, 0, A)
                        b.waiting = t
                        b.frame_other = function(unit)
                            if unit.timer == unit.waiting then
                                bullet.ChangeImage(unit, unit.imgclass, 3)
                            end
                            if unit.timer == unit.waiting + 100 then
                                bullet.ChangeImage(unit, unit.imgclass, 2)
                            end
                            if unit.timer == unit.waiting + 200 then
                                bullet.ChangeImage(unit, unit.imgclass, 15)
                            end
                            if unit.timer == unit.waiting + 300 then
                                object.Del(unit)
                            end
                        end
                        A = A + 72
                    end
                    PlaySound("kira00", 0.1, self.x / 100)
                    task.Wait(10)
                    t = t - 10
                end
            end)

        end
    })
    class["bullet0-2"] = Class(bullet, {
        init = function(self, _x, _y, v, a)
            bullet.init(self, ball_huge, COLOR.ORANGE, true, false)
            self.x, self.y = _x, _y
            PlaySound("nice", 1, self.x / 256, false)
            _object.set_color(self, "mul+add", 255, 255, 255, 255)
            self.flag = 1
            self.omiga = ran:Sign()
            object.SetV(self, v, a)
        end,
        frame = function(self)
            bullet.frame(self)
            if self.x < lstg.world.l or self.x > lstg.world.r then
                self.vx = -self.vx
            end
            if self.y > lstg.world.t and self.flag > 0 then
                object.Del(self)
            end
            if self.y < lstg.world.b and self.flag > 0 then
                object.Del(self)
            end
        end,
        del = function(self)
            if not self.dk then
                self.dk = true
                object.Preserve(self)
                PlaySound("enep00")
                object.StopMoving(self)
                self.flag = 0
                for a = -1, 1 do
                    Create.laser_line(self.x, self.y, 14, 7, Angle(self, player) + a * 20, 30, 12)
                end
                local b
                for _ = 1, 30 do
                    b = NewSimpleBullet(ball_mid_c, 14, self.x, self.y, ran:Float(0.5, 1.2), ran:Float(0, 360))
                    b._blend = "mul+add"
                end
                task.New(self, function()
                    local s = 1
                    local a = 255
                    for _ = 1, 11 do
                        self.hscale = s
                        self.vscale = s
                        _object.set_color(self, "mul+add", a, 255, 255, 255)
                        task.Wait()
                        s = s + 2 / 10
                        a = a + -255 / 10
                    end
                    object.RawDel(self)
                end)
            end
        end
    })
    class["bullet0-3"] = Class(bullet, {
        init = function(self, y, len, r, rd)
            bullet.init(self, money, 14, false, true)
            self.len = len
            self.r = r
            self.rd = rd
            self.x = cos(self.r) * self.len
            self.y = y
        end,
        frame = function(self)
            bullet.frame(self)
            self.r = self.r + self.rd
            self.x = cos(self.r) * self.len
        end
    })
    class["bullet0-4"] = Class(bullet, {
        init = function(self, x, y, a, v, t, master, cao)
            bullet.init(self, grain_b, 2, false, true)
            self.x, self.y = x, y
            if cao then
                object.RawDel(self)
            end
            self.bound = false
            object.SetV(self, 0.3, a, true)
            PlaySound("tan00")
            task.New(self, function()
                task.Wait(t)
                for i = 1, 40 do
                    object.SetV(self, 0.3 + (v - 0.3) * sin(i * 2.5), a)
                    task.Wait()
                end
            end)
            task.New(self, function()
                while IsValid(master) do
                    if Dist(self, master) < 4 then
                        break
                    end
                    task.Wait()
                end
                object.Del(self)
            end)
        end
    })
    class["bullet0-53D"] = Class(bullet, {
        init = function(self, master, mx, my, mz, a, r, r2, vy, omiga, projection)
            bullet.init(self, ball_small, 2, false, true)
            PlaySound("tan00", 0.3, self.x / 300, true)
            self._x, self._y, self._z = mx + cos(a) * r, my, mz + sin(a) * r
            self.master = master
            self.projection = projection
            self.x, self.y = sp.math.ProjectionInPlane(self._x, self._y, self._z, unpack(self.projection))
            self.refresh = function()
                if self._z > 0 and self._a == 255 then
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
                    bullet.SetLayer(self, LAYER.ENEMY - 1)
                end
                if self._z < 0 and self._a == 80 then
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
                    bullet.SetLayer(self, LAYER.ENEMY_BULLET + 1)
                end
            end
            self.refresh()
            self.navi = true
            task.New(self, function()
                local dx = mx + cos(a) * r2 - self._x
                local dz = my + sin(a) * r2 - self._z
                local xs = self._x
                local zs = self._z
                for s = 1 / 60, 1 + 0.5 / 60, 1 / 60 do
                    s = s * 2 - s * s
                    self._x = xs + s * dx
                    self._z = zs + s * dz
                    coroutine.yield()
                end
                local c = 0
                while true do
                    self.refresh()
                    c = min(90, c + 1)
                    a = a + omiga * sin(c)
                    self._x, self._z = mx + cos(a) * r2, my + sin(a) * r2
                    self._y = self._y + vy * sin(c)
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
            self.x, self.y = sp.math.ProjectionInPlane(self._x, self._y, self._z, unpack(self.projection))
        end
    })
    class["bullet0-6wheel"] = Class(bullet, {
        init = function(self, x, y, a, r, o, s, vx, vy)
            bullet.init(self, water_drop, 6, false, true)
            self.x, self.y = x, y
            self.bound = false
            self.rot = a
            task.New(self, function()
                local c = 0
                while true do
                    x = x + vx
                    y = y + vy
                    c = c + s
                    a = a + o
                    self.x, self.y = x + cos(a) * r * abs(sin(c)), y + sin(a) * r * abs(sin(c))
                    self.rot = a
                    if self.y < lstg.world.b - r then
                        object.Del(self)
                        break
                    end
                    task.Wait()
                end
            end)
        end
    })
    class["bullet0-7heart"] = Class(bullet, {
        init = function(self, master, r, a)
            bullet.init(self, water_drop, 10, false, true)
            self.x, self.y = master.x, master.y
            self._a = 0
            self.rot = Angle(master, self)
            self.hscale, self.vscale, self.a, self.b = 0.7, 0.7, self.a * 0.7, self.b * 0.7
            task.New(self, function()
                for i = 1, 90 do
                    if not IsValid(master) then
                        object.Del(self)
                        return
                    end
                    self._a = abs(sin(i * 3)) * 255
                    self.rot = Angle(master, self)
                    self.x, self.y = sp.math.HeartPoint(master.x, master.y, r * sin(i * 3), master.hrot, a)
                    task.Wait()
                end
                for i = 1, 60 do
                    if not IsValid(master) then
                        object.Del(self)
                        return
                    end
                    self.rot = Angle(master, self)
                    self.x, self.y = sp.math.HeartPoint(master.x, master.y, -r, master.hrot, a)
                    task.Wait()
                end
                --掉下去时的变化
                --如果掉下去r变成0就是240
                --如果掉下去过程中r还要变大，就对240进行处理
                --240*((变小的过程占路径的几份)/(把掉下去的路径平均分成几份))
                local sy = master.y + 120
                local x, y, _r
                while IsValid(master) do
                    self.rot = Angle(master, self)
                    self.x, self.y = sp.math.HeartPoint(master.x, master.y, -r * (master.y + 120) / sy, master.hrot, a)
                    x, y = master.x, master.y
                    _r = -r * (master.y + 120) / sy
                    task.Wait()
                end
                self.colli = false
                Create.bullet_create_eff(self.x, self.y, water_drop, 2)
                bullet.ChangeImage(self, water_drop, 2)
                for i = 1, 60 do
                    self._a = 255 - 255 * sin(i * 1.5)
                    self.rot = Angle(x, y, self.x, self.y)
                    self.x, self.y = sp.math.HeartPoint(x, y, _r + i, 90, a)
                    task.Wait()
                end
                object.RawDel(self)
            end)
        end
    })
end---bullet

do
    class["laser0-1"] = Class(WideLaser, {
        init = function(self, rot, omiga)
            WideLaser.init(self, 0, 0, Color(255, 255, 60, 60), rot, 32, true)
            self.omiga = -omiga
            task.New(self, function()
                task.SmoothSetValueTo("omiga", omiga, 60, 1)
                WideLaser.TurnOn(self, 30, true)
            end)
        end
    })
    class["laser0-2"] = Class(laser, {
        init = function(self, master)
            laser.init(self, 2, master.x, master.y, Angle(0, 240, master.x, master.y), 180, 0, 180, 8, 10, 0)
            self.master = master
            task.New(self, function()
                laser._TurnHalfOn(self, 60, true)
                laser._TurnOn(self, 20, true)
                local v
                while true do
                    v = 5
                    for j = -4, 4 do
                        NewSimpleBullet(grain_b, 2, self.x, self.y, v, self.rot + 180 + j * 15, false, 0, false)
                    end
                    for i = 0, 340, 34 do
                        NewSimpleBullet(grain_b, 2, self.x + cos(self.rot) * i, self.y + sin(self.rot) * i,
                                v, self.rot + 90, false, 0, false)
                        NewSimpleBullet(grain_b, 2, self.x + cos(self.rot) * i, self.y + sin(self.rot) * i,
                                v, self.rot - 90, false, 0, false)
                        v = v - 4 / 10
                    end
                    task.Wait(2)
                end
            end)
        end,
        frame = function(self)
            laser.frame(self)
            if not IsValid(self.master) then
                object.Del(self)
                return
            end
            self.rot = Angle(0, 240, self.master.x, self.master.y)
            self.x, self.y = self.master.x, self.master.y
        end,
    })
    class["laser0-3"] = Class(laser, {
        init = function(self, x, y, rot, r, v, a, t)
            laser.init(self, 16, x, y, rot, 0, 0, 0, 8, 6, 0)
            laser._TurnHalfOn(self, 1)
            object.SetV(self, v, a)
            self.bound = false
            self.omiga = r
            self.line = 0
            self.Isradial = true
            self.radial_v = 13
            task.New(self, function()
                task.New(self, function()
                    for i = 1, 45 do
                        self.line = sin(i * 2) * 1000
                        task.Wait()
                    end
                end)
                while true do
                    task.Wait()
                    t = t - 1
                    if t <= 0 then
                        break
                    end
                    if self.jump then
                        break
                    end
                end
                laser.ChangeImage(self, 1, 2)
                task.New(self, function()
                    local vx, vy = self.vx, self.vy
                    for i = 29, 0, -1 do
                        self.omiga = sin(i * 3) * r
                        self.vx, self.vy = sin(i * 3) * vx, sin(i * 3) * vy
                        coroutine.yield()
                    end
                end)
                task.Wait(t)
                task.Wait(30)
                laser._TurnOn(self, 1, true)
                task.New(self, function()
                    for _ = 1, 40 do
                        self.l3 = self.l3 + 13
                        task.Wait()
                    end
                    for _ = 1, 40 do
                        self.l1 = self.l1 + 13
                        task.Wait()
                    end
                    laser._TurnOff(self, 30, true)
                    object.Del(self)
                end)
            end)
        end,
        frame = function(self)
            laser.frame(self)
            if not self.jump then
                local x, y = player.x - self.x, player.y - self.y
                x, y = x * cos(self.rot) + y * sin(self.rot), y * cos(self.rot) - x * sin(self.rot)
                if x > 0 then
                    if abs(y) < 7 then
                        self.jump = true
                    end
                end
            end
        end,
        render = function(self)
            SetImageState("white", "mul+add", self.alpha * 180, unpack(ColorList[math.ceil(self.index / 2)]))
            Render("white", self.x + cos(self.rot) * self.line / 2, self.y + sin(self.rot) * self.line / 2, self.rot, self.line / 16, 0.125)
            laser.render(self)
        end
    })
    class["laser0-4wheel"] = Class(laser, {
        init = function(self, x, y, a, r, o, s, vx, vy)
            laser.init(self, 6, x, y, a, 0, 0, 0, 10, 6, 0)
            self.vx, self.vy = vx, vy
            self.omiga = o
            self.bound = false
            laser._TurnOn(self, 1)
            task.New(self, function()
                local c, R = 0
                while true do
                    c = c + s
                    R = abs(r * sin(c))
                    self.l1, self.l3 = R / 2, R / 2
                    if self.y < lstg.world.b - r then
                        object.Del(self)
                        break
                    end
                    task.Wait()
                end
            end)
        end
    })
end---laser

do
    CreateRenderTarget("objectTH11_0-1")
    class["object0-1_1"] = Class(object, {
        init = function(self, master)
            object.Connect(master, self)
            self.group = GROUP.GHOST
            self.layer = LAYER.BG - 2
        end,
        render = function()
            PushRenderTarget("objectTH11_0-1")
            RenderClear(Color(0, 0, 0, 0))
        end
    })
    class["object0-1_2"] = Class(object, {
        init = function(self, master)
            self.x, self.y = master.x - 200, master.y
            object.Connect(master, self)
            self.group = GROUP.GHOST
            self.layer = LAYER.TOP - 1
            self.rot = ran:Float(0, 360)
            self.omiga = 5
            self.r = 0

            task.New(self, function()
                task.MoveToEx(400, 0, 160, 3)
            end)
            task.New(self, function()
                for i = 1, 160 do
                    self.r = 150 * sin(i / 160 * 180)
                    coroutine.yield()
                end
            end)

            self.uv1, self.uv2, self.uv3, self.uv4 = { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }
            local color = Color(255, 255, 255, 255)
            local w = lstg.world
            self.uv1[1], self.uv1[2] = w.l, w.t
            self.uv2[1], self.uv2[2] = w.r, w.t
            self.uv3[1], self.uv3[2] = w.r, w.b
            self.uv4[1], self.uv4[2] = w.l, w.b
            self.uv1[4], self.uv1[5] = WorldToScreen(w.l, w.t)
            self.uv2[4], self.uv2[5] = WorldToScreen(w.r, w.t)
            self.uv3[4], self.uv3[5] = WorldToScreen(w.r, w.b)
            self.uv4[4], self.uv4[5] = WorldToScreen(w.l, w.b)
            self.uv1[6] = color
            self.uv2[6] = color
            self.uv3[6] = color
            self.uv4[6] = color
        end,
        frame = task.Do,
        render = function(self)
            local color = Color(255, 255, 255, 255)
            PopRenderTarget("objectTH11_0-1")
            RenderTexture("objectTH11_0-1", "", self.uv1, self.uv2, self.uv3, self.uv4)
            local n = 30
            local k = screen.scale
            for i = 1, n do
                RenderTexture("objectTH11_0-1", "",
                        { self.x - cos(i * 360 / n) * self.r, self.y - sin(i * 360 / n) * self.r, 0.5,
                          k * (self.x + 480 + cos(i * 360 / n) * self.r), k * (270 - self.y - sin(i * 360 / n) * self.r), color },
                        { self.x - cos(i * 360 / n + 360 / n) * self.r, self.y - sin(i * 360 / n + 360 / n) * self.r, 0.5,
                          k * (self.x + 480 + cos(i * 360 / n + 360 / n) * self.r), k * (270 - self.y - sin(i * 360 / n + 360 / n) * self.r), color },
                        { self.x, self.y, 0.5, k * (self.x + 480), k * (270 - self.y), color },
                        { self.x, self.y, 0.5, k * (self.x + 480), k * (270 - self.y), color })
            end
            for i = 1, 16 do
                SetImageState("c_attack" .. i, '', 255, 255, 255, 255)
            end
            misc.RenderRing("c_attack", self.x, self.y, self.r * 0.8, self.r * 1.2, self.rot, 32, 16)
        end
    })
    class["object0-2"] = Class(object, {
        init = function(self, x, y, master)
            ext.YingYangYu = self
            self.x, self.y = x, y
            self.master = master
            self.ag = 0.08
            self.img = "YinYangYu"
            self.omiga = 5
            self.hscale, self.vscale = 2, 2
            self.group = GROUP.SPELL
            self.a, self.b = 30, 30
            self.layer = LAYER.ENEMY_BULLET
            self.bound_times = 0
        end,
        frame = function(self)
            self.vx = self.vx - self.vx / 80
            if self.x < player.x + 60 and self.x > player.x - 60 and self.y < player.y + 60 and self.y > player.y then
                self.vy = -self.vy * 0.6 + player.dy
                self.y = (player.y + 60) * 2 - self.y
                self.vx = max(-abs(player.hspeed), min(abs(player.hspeed), self.vx + player.dx / player.hspeed / 2))
            end
            if self.y > lstg.world.t - 30 then
                self.bound_times = self.bound_times + 1
                self.vy = -self.vy
                self.y = (lstg.world.t - 30) * 2 - self.y
            end
            if self.x < lstg.world.l + 30 then
                self.bound_times = self.bound_times + 1
                self.vx = -self.vx
                self.x = (lstg.world.l + 30) * 2 - self.x
            end
            if self.x > lstg.world.r - 30 then
                self.bound_times = self.bound_times + 1
                self.vx = -self.vx
                self.x = (lstg.world.r - 30) * 2 - self.x
            end
            if self.bound_times >= 10 then
                ext.achievement:get(48)
            end
            cutLasersByCircle(self.x, self.y, self.a)
            object.BulletDo(function(o)
                if Dist(self, o) < self.a then
                    object.Del(o)
                end
            end)
            object.LaserDo(function(o)
                if Dist(self, o) < self.a then
                    if not (o.Isradial or not o.Isgrowing) then
                        object.Del(o)
                    end
                end
            end)
        end,
        render = function(self)
            DefaultRenderFunc(self)
            SetImageState("ball_mid2", "", 255, 255, 255, 255)
            for z = -3, 3 do
                Render("ball_mid2", player.x + z * 10, player.y + 30)
            end
        end,
        del = function(self)
            for z = -3, 3 do
                New(bubble3, "ball_mid2", player.x + z * 10, player.y + 30, 0, 0, 0, 0, 15, 1, 1,
                        Color(255, 255, 255, 255), Color(0, 255, 255, 255), LAYER.ENEMY, "")
            end
            if IsValid(self.master) and self.master.is_combat then
                player.class.colli(player, self)
            end
        end,
        kill = function(self)
            for z = -3, 3 do
                New(bubble3, "ball_mid2", player.x + z * 10, player.y + 30, 0, 0, 0, 0, 15, 1, 1,
                        Color(255, 255, 255, 255), Color(0, 255, 255, 255), LAYER.ENEMY, "")
            end
            if IsValid(self.master) and self.master.is_combat then
                player.class.colli(player, self)
            end
        end
    })
    class["object0-3"] = Class(object, {
        init = function(self, v, x, del)
            if del then
                object.RawDel(self)
                return
            end
            self.a = 60
            self.b = 80
            self.rect = true
            self.vy = -v
            self.group = GROUP.INDES
            self.layer = LAYER.ENEMY_BULLET
            self.x, self.y = x * 120, 240 + self.b
            self.bound = false
            self.IsLaser = true
        end,
        frame = function(self)
            if self.y < -240 - self.b then
                object.RawDel(self)
            end
            if player.x > self.x - self.a - 32 and player.x < self.x + self.a + 32 and player.y > self.y - self.b - 32 and player.y < self.y + self.b + 32 then
                if self.timer % 4 == 0 then
                    player.grazer.class.colli(player.grazer, self, true)
                end
            end
        end,
        render = function(self)
            SetImageState("ball_mid6", "", 255, 255, 255, 255)
            for i = -6, 6 do
                Render("ball_mid6", self.x + i * 10, self.y + self.b)
                Render("ball_mid6", self.x + i * 10, self.y - self.b)
            end
            for i = -7, 7 do
                Render("ball_mid6", self.x - self.a, self.y + i * 10)
                Render("ball_mid6", self.x + self.a, self.y + i * 10)
            end
            local text = "魔\n\n法\n\n书"
            for i = 1, 8 do
                RenderTTF("title", text, self.x + cos(i * 45), self.y + sin(i * 45),
                        Color(255, 0, 0, 0), "centerpoint")
            end
            RenderTTF("title", text, self.x, self.y, Color(255, 255, 255, 255), "centerpoint")
        end,
        del = function(self)
            for i = -6, 6 do
                BulletBreak_Table:New(self.x + i * 10, self.y + self.b, 6)
                BulletBreak_Table:New(self.x + i * 10, self.y - self.b, 6)
            end
            for i = -7, 7 do
                BulletBreak_Table:New(self.x - self.a, self.y + i * 10, 6)
                BulletBreak_Table:New(self.x + self.a, self.y + i * 10, 6)
            end
            enemy.death_ef(self.x, self.y, 10, 1)
        end,
        kill = function(self)
            self.class.del(self)
            for i = -6, 6 do
                New(item.obj.faith_minor, self.x + i * 10, self.y + self.b)
                New(item.obj.faith_minor, self.x + i * 10, self.y - self.b)
            end
            for i = -7, 7 do
                New(item.obj.faith_minor, self.x - self.a, self.y + i * 10)
                New(item.obj.faith_minor, self.x + self.a, self.y + i * 10)
            end
        end
    })
    class["object0-4"] = Class(object, {
        init = function(self, x, my, t, func)
            self.ag = 0.01
            self.a = 50
            self.b = 50
            self.x = x
            self.y = 240 + self.b
            self.group = GROUP.INDES
            self.layer = LAYER.ENEMY_BULLET
            self.IsLaser = true
            self.bound = false
            task.New(self, function()
                task.MoveTo(self.x, my, t, 2)
                if func then
                    func(self)
                end
                object.Del(self)
            end)
        end,
        frame = function(self)
            task.Do(self)
            if Dist(self, player) < self.a + 32 then
                if self.timer % 4 == 0 then
                    player.grazer.class.colli(player.grazer, self, true)
                end
            end
            if Dist(self.x, self.y + 60, player.x, player.y) < 30 then
                player.class.colli(player, self)
            end
            if player.x > self.x - 2 and player.x < self.x + 2 and player.y > self.y + 100 and player.y < self.y + 120 then
                player.class.colli(player, self)
            end
        end,
        render = function(self)
            local img = "ball_mid14"
            SetImageState(img, "", 200, 255, 255, 255)
            local a
            for i = 0, 5 do
                for z = 1, 1 + i * 6 do
                    a = z * 360 / (1 + i * 6)
                    Render(img, self.x + cos(a) * i * 10, self.y + sin(a) * i * 10)
                end
            end
            for i = 0, 3 do
                for z = 1, 1 + i * 6 do
                    a = z * 360 / (1 + i * 6)
                    Render(img, self.x + cos(a) * i * 10, self.y + 60 + sin(a) * i * 10)
                end
            end
            for y = 1, 3 do
                Render(img, self.x, self.y + 90 + y * 10)
            end
        end,
        del = function(self)
            local a
            for i = 0, 5 do
                for z = 1, 1 + i * 6 do
                    a = z * 360 / (1 + i * 6)
                    BulletBreak_Table:New(self.x + cos(a) * i * 10, self.y + sin(a) * i * 10, 14)
                end
            end
            for i = 0, 3 do
                for z = 1, 1 + i * 6 do
                    a = z * 360 / (1 + i * 6)
                    BulletBreak_Table:New(self.x + cos(a) * i * 10, self.y + 60 + sin(a) * i * 10, 14)
                end
            end
            for y = 1, 3 do
                BulletBreak_Table:New(self.x, self.y + 90 + y * 10, 14)
            end
        end,
        kill = function(self)
            self.class.del(self)
            local a
            for i = 0, 5 do
                for z = 1, 1 + i * 6 do
                    a = z * 360 / (1 + i * 6)
                    New(item.obj.faith_minor, self.x + cos(a) * i * 10, self.y + sin(a) * i * 10)
                end
            end
            for i = 0, 3 do
                for z = 1, 1 + i * 6 do
                    a = z * 360 / (1 + i * 6)
                    New(item.obj.faith_minor, self.x + cos(a) * i * 10, self.y + 60 + sin(a) * i * 10)
                end
            end
            for y = 1, 3 do
                New(item.obj.faith_minor, self.x, self.y + 90 + y * 10)
            end
        end,
    })
    class["object0-5"] = Class(object, {
        init = function(self, x, y, size, a)
            self.x, self.y = x, y
            self._a = 0
            self.img = "photo_block"

            self.hscale = size * 1.3
            self.vscale = self.hscale

            self.group = GROUP.ENEMY_BULLET
            self.layer = LAYER.ENEMY - 1
            self.a = size * 100
            self.b = self.a
            self.rect = true
            object.SetV(self, 5, a, true)
            task.New(self, function()
                local c = 0
                local l = 100 * sqrt(2)
                local A
                for i = 1, 90 do
                    c = min(i * 3, 90)
                    self.hscale = size * (1.3 - 0.3 * sin(c)) * sin(90 - i)
                    self.vscale = self.hscale
                    self.a = size * 100 * sin(90 - i)
                    self.b = self.a
                    self._a = sin(c) * 255
                    object.SetV(self, 5 * sin(90 - i), a)
                    self.rot = self.rot + 8 * sin(90 - i)
                    for j = 1, 4 do
                        A = self.rot + j * 90 + 45
                        NewSimpleBullet(square, 14 + i % 2,
                                self.x + cos(A) * self.hscale * l, self.y + sin(A) * self.hscale * l,
                                5, A + 180 * (i % 2), false, 0, false)
                    end
                    PlaySound("tan00")
                    task.Wait()
                end
                object.Del(self)
            end)
        end,
        frame = task.Do,
        render = function(self)
            SetImageState(self.img, "", self._a, 255, 255, 255)
            DefaultRenderFunc(self)
        end,
        kill = function(self)
            for i = 1, 30 do
                for v = 1, 3 do
                    (NewSimpleBullet(ball_mid, 6, self.x, self.y, 1 + v * 0.5, i * 12 + v * 30)).blend = "mul+add"
                end
            end
            New(bubble3, self.img, self.x, self.y, self.rot, self.dx, self.dy, self.omiga, 15, self.hscale, self.hscale,
                    Color(self._a, 255, 255, 255), Color(0, 255, 255, 255), self.layer, self._blend)
            enemy.death_ef(self.x, self.y, 10, 1)
        end,
        del = function(self)
            self.class.kill(self)
        end
    })
    class["object0-6"] = Class(object, {
        init = function(self, x, y)
            self.group = GROUP.INDES
            self.layer = LAYER.ENEMY_BULLET_EF
            self.x, self.y = x, y
            self.img = "photoOFF"
            self._a = 255
            self.hscale = 1.2
            self.vscale = 1.2
            self.a = 96 * 1.2
            self.b = 128 * 1.2
            self.rect = true
            self.colli = false
            object.SetV(self, 1, Angle(self, player), true)
            task.New(self, function()
                PlaySound("focus")
                lstg.var.timeslow = 2
                for i = 1, 30 do
                    object.SetV(self, 5.5, Angle(self, player), true)
                    self.hscale = 1.2 - 0.5 * sin(i * 3)
                    self.vscale = self.hscale
                    self.a = 96 * self.hscale
                    self.b = 128 * self.hscale
                    task.Wait()
                end
                lstg.var.timeslow = 1
                PlaySound("shutter", 1)
                object.StopMoving(self)
                self.colli = true
                self.on = true
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
                Render("photoON", self.x, self.y, self.rot, self.hscale, self.vscale)
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
            for i = 1, 20 do
                for v = 1, 4 do
                    (NewSimpleBullet(arrow_big, 14, self.x, self.y, 3 + v * 0.4, i * 18 + v * 30)).blend = "mul+add"
                end
            end
        end
    })
    class["object0-piano"] = Class(object, {
        init = function(self)
            self.group = GROUP.GHOST
            self.layer = LAYER.ENEMY
            self.bound = false
            self.y = 300
            self.black_x = { 2, 3, 5, 6, 7, 9, 10, 12, 13, 14, 16, 17, 19, 20, 21, 23, 24, 26, 27, 28 }
            self.color = {}
            for z = 3, 6 do
                for i = 1, 7 do
                    self.color[z .. i] = { 255, 255, 255 }
                end
                for _, p in ipairs({ 1.5, 2.5, 4.5, 5.5, 6.5 }) do
                    self.color[z .. p] = { 50, 50, 50 }
                end
            end
            self.default = function(v1, v2)
                if string.len(v2) == 1 then
                    self.color[v1 .. v2] = { 255, 255, 255 }
                else
                    self.color[v1 .. v2] = { 50, 50, 50 }
                end
            end
            self.main_set = function(v1, v2, v3)
                self.color[v1 .. v2] = { 250, 128, 114, 2 }
                task.New(self, function()
                    task.Wait(v3 * 0.8)
                    self.default(v1, v2)
                end)
            end
            self.other_set = function(v1, v2, v3)
                self.color[v1 .. v2] = { 255, 227, 132, 14 }
                task.New(self, function()
                    task.Wait(v3 * 0.8)
                    self.default(v1, v2)
                end)
            end
            task.New(self, function()
                local v = 10.1
                task.MoveTo(0, 240, 60, 2)
                local main = {
                    { 4, 4, 4 }, { 5, 1, 4 },
                    { 4, 5, 6 }, { 4, 4, 1 }, { 4, 5, 1 },
                    { 4, 5.5, 4 }, { 4, 5.5, 1.5 }, { 4, 6.5, 1.5 }, { 4, 5, 1 },
                    { 4, 5.5, 6 }, { 5, 1, 1 }, { 5, 2.5, 1 },
                    { 5, 4, 3 }, { 5, 2.5, 3 }, { 5, 1.5, 2 },
                    { 5, 2.5, 2 }, { 5, 5.5, 2 }, { 5, 5, 2 }, { 5, 2.5, 2 },
                    { 5, 1, 8 + 6 }, { 4, 5.5, 1 }, { 4, 6.5, 1 },
                    { 5, 1, 4 }, { 5, 2.5, 4 },
                    { 4, 6.5, 5 }, { 5, 3, 2 }, { 5, 4, 1 + 1 },
                    { 5, 1, 1 }, { 4, 6.5, 1 }, { 5, 5, 1 }, { 5, 1, 1 }, { 4, 6.5, 1 }, { 5, 5.5, 1 }, { 5, 6.5, 1 },
                    { 5, 5.5, 2 }, { 5, 5, 2 }, { 5, 5.5, 2 }, { 5, 4, 1 }, { 5, 5, 1 },
                    { 5, 5.5, 1 }, { 5, 5, 1 }, { 5, 4, 1 }, { 5, 2.5, 1 }, { 5, 4, 3 }, { 5, 5.5, 1 + 1 },
                    { 5, 5, 1 }, { 5, 4, 1 }, { 5, 2.5, 1 }, { 5, 4, 1 }, { 5, 5, 1 }, { 5, 1, 1 }, { 5, 2.5, 1 },
                    { 5, 4, 8 } }
                task.New(self, function()
                    PlayPiano(v, main, 1, self.main_set)
                end)
                local key = {}
                setmetatable(key, {
                    __index = function(t, k)
                        rawset(t, k, { string.sub(k, 1, 1), tonumber(string.sub(k, 2, -1)), 1 })
                        return { string.sub(k, 1, 1), tonumber(string.sub(k, 2, -1)), 1 }
                    end })
                local other = {
                    key[34], key[35.5], key[41], key[44], key[45.5], key[44], key[41], key[35.5],
                    key[33], key[35], key[41], key[43], key[45], key[43], key[41], key[35],
                    key[32.5], key[35], key[36.5], key[42.5], key[45], key[42.5], key[36.5], key[35],
                    key[32], key[34], key[36.5], key[42], key[44], key[42], key[36.5], key[34],
                    key[31.5], key[35.5], key[41.5], key[44], key[45.5], key[44], key[41.5], key[35.5],
                    key[32.5], key[36.5], key[42.5], key[45], key[46.5], key[45], key[42.5], key[36.5],
                    key[34], key[35.5], key[41], key[44], key[45.5], key[44], key[41], key[35.5],
                    key[34], key[35.5], key[41], key[44], key[45.5], key[44], key[41], key[35.5],
                    key[34], key[35.5], key[41], key[44], key[45.5], key[44], key[41], key[35.5],
                    key[33], key[35], key[36.5], key[43], key[45], key[43], key[36.5], key[35],
                    key[32.5], key[35], key[36.5], key[42.5], key[45], key[42.5], key[36.5], key[35],
                    key[32], key[34], key[36.5], key[42], key[44], key[42], key[36.5], key[34],
                    key[31.5], key[35.5], key[41.5], key[44], key[45.5], key[44], key[41.5], key[35.5],
                    key[32.5], key[36.5], key[42.5], key[45], key[46.5], key[45], key[42.5], key[36.5],
                    key[34], key[35.5], key[41], key[44], key[45.5], key[44], key[41], key[35.5],
                    key[34], key[35.5], key[41], key[44], key[45.5], key[44], key[41], key[35.5]
                }
                PlayPiano(v, other, 0, self.other_set)
                task.MoveTo(0, 300, 60, 1)
                object.RawDel(self)
            end)
        end,
        frame = function(self)
            task.Do(self)
            local k = 28
            local y = self.y
            local white_y = 60
            local black_y = 36
            local lx, ex = lstg.world.l, lstg.world.r - lstg.world.l
            local key
            if self.timer % 3 == 0 then
                for i = 1, k do
                    key = 2 + math.ceil(i / 7) .. (i - 1) % 7 + 1
                    if self.color[key][4] then
                        Create.bullet_decel(lx + (i - 0.5) * ex / k, y - white_y, square, self.color[key][4], 6, 3, -90)
                        Create.leaf_eff(lx + (i - 0.5) * ex / k, y - white_y,
                                ran:Float(2, 3), ran:Float(0, 360), ran:Float(30, 60), ran:Float(0.8, 1.8), unpack(self.color[key]))
                    end
                end
                local black = { 1.5, 2.5, 4.5, 5.5, 6.5 }
                for i, x in ipairs(self.black_x) do
                    key = 2 + math.ceil(i / 5) .. black[(i - 1) % 5 + 1]
                    if self.color[key][4] then
                        Create.bullet_decel(lx + (x - 1) * ex / k, y - black_y, square, self.color[key][4], 5, 3, -90)
                        Create.leaf_eff(lx + (i - 0.5) * ex / k, y - white_y,
                                ran:Float(2, 3), ran:Float(0, 360), ran:Float(30, 60), ran:Float(0.8, 1.8), unpack(self.color[key]))
                    end
                end
            end
        end,
        render = function(self)
            local k = 28
            local lx, ex = lstg.world.l, lstg.world.r - lstg.world.l
            local img = "white"
            local w = ex / k / 3
            local ol = 1
            local y = self.y
            local white_y = 60
            local black_y = 36
            local SIS = SetImageState
            local RR = RenderRect
            for i = 1, k do
                SIS(img, "", Color(255, unpack(self.color[2 + math.ceil(i / 7) .. (i - 1) % 7 + 1])))
                RR(img, lx + (i - 1) * ex / k, lx + i * ex / k, y, y - white_y)
            end
            for i = 1, k + 1 do
                SIS(img, "", Color(255, 0, 0, 0))
                RR(img, lx + (i - 1) * ex / k + ol, lx + (i - 1) * ex / k - ol, y, y - white_y)
            end
            RR(img, lx, lx + ex, y - white_y - ol, y - white_y + ol)
            local black = { 1.5, 2.5, 4.5, 5.5, 6.5 }
            local c
            for i, x in ipairs(self.black_x) do
                c = lx + (x - 1) * ex / k
                SIS(img, "", Color(255, unpack(self.color[2 + math.ceil(i / 5) .. black[(i - 1) % 5 + 1]])))
                RR(img, c + w, c - w, y, y - black_y)
                SIS(img, "", Color(255, 0, 0, 0))
                RR(img, c + w + ol, c - w - ol, y - black_y - ol, y - black_y + ol)
                RR(img, c + w + ol, c + w - ol, y, y - black_y)
                RR(img, c - w + ol, c - w - ol, y, y - black_y)
            end
        end
    })
    class["FakeParsee"] = Class(object, {
        init = function(self, x, y)
            self.x, self.y = x, y
            self._blend, self._a, self._r, self._g, self._b = "", 255, 130, 130, 130
            self.group = GROUP.INDES
            self.layer = LAYER.ENEMY
            self.hscale = 0
            self.vscale = 2
            self._wisys = BossWalkImageSystem(self)
            self._wisys:SetImageInList("Parsee")
            self._wisys:SetFloat(function(ani)
                return 0, sin(ani * 4)
            end)
            self.colli = false
            task.New(self, function()
                boss.cast(self, 999)
                for i = 0, 10 do
                    self.hscale = sin(i * 9)
                    self.vscale = 2 - sin(i * 9)
                    task.Wait()
                end
                task.Wait(50)
                task.New(self, function()
                    task.Wait(60)
                    local a = 0
                    local c = 0
                    while true do
                        c = min(c + 1, 90)
                        a = a + 0.9 * sin(c)
                        self.x, self.y = cos(a) * 180, sin(a) * 60 + 60
                        task.Wait()
                    end
                end)
                local a = -90
                local _a
                local c = -90
                while true do
                    for d = 1, 2 do
                        _a = c + d * 180
                        Create.bullet_accel(self.x + cos(a + d * 180) * 50, self.y + sin(a + d * 180) * 50, grain_b, 10, 0, 2.5, _a)
                    end
                    PlaySound("tan00", 0.1, self.x / 100, true)
                    a = a - 6
                    c = c + 5
                    task.Wait(2)
                end
            end)
        end,
        frame = function(self)
            task.Do(self)
            self._wisys:frame()
        end,
        render = function(self)

            self._wisys:render()
        end
    })
    LoadTexture2("Alert", "mod\\GAME\\Alert.png")
    class["Alert"] = Class(object, {
        init = function(self)
            PlaySound("alert")
            self.group = GROUP.GHOST
            self.layer = 0
            self.x, self.y = 0, 0
            self.tex = "Alert"
            self.alpha = 0
        end,
        frame = function(self)
            if self.timer < 15 then
                self.alpha = min(255, self.alpha + 255 / 15)
            elseif self.timer > 145 then
                self.alpha = max(0, self.alpha - 255 / 15)
                if self.alpha == 0 then
                    object.Del(self)
                end
            end
        end,
        render = function(self)
            local color = Color(self.alpha, 255, 255, 255)
            local x = self.timer * 1.3
            RenderTexture(self.tex, "",
                    { -320, 64, 0.5, x, 0, color },
                    { 320, 64, 0.5, 640 + x, 0, color },
                    { 320, -64, 0.5, 640 + x, 128, color },
                    { -320, -64, 0.5, x, 128, color })
            RenderTexture(self.tex, "",
                    { -320, 110, 0.5, -x, 220, color },
                    { 320, 110, 0.5, 640 - x, 220, color },
                    { 320, 74, 0.5, 640 - x, 256, color },
                    { -320, 74, 0.5, -x, 256, color })
            RenderTexture(self.tex, "",
                    { -320, -74, 0.5, -x, 220, color },
                    { 320, -74, 0.5, 640 - x, 220, color },
                    { 320, -110, 0.5, 640 - x, 256, color },
                    { -320, -110, 0.5, -x, 256, color })
        end
    })
    Nuclear = Class(object)
    function Nuclear:init(x, y, a, r, g, b)
        self.x, self.y = x or 0, y or 0
        self._a = a or 1
        self._r, self._g, self._b = r or 255, g or 64, b or 64
        self.layer = LAYER.ENEMY_BULLET
        self.group = GROUP.INDES
        self.IsLaser = true
    end
    function Nuclear:frame()
        task.Do(self)
        if Dist(self, player) < self.a + player.grazer.a then
            if self.timer % 4 == 0 then
                player.grazer.class.colli(player.grazer, self, true)
            end
        end
    end
    function Nuclear:del()
        enemy.death_ef(self.x, self.y, 10, 1)
    end
    function Nuclear:kill()
        Nuclear.del(self)
        New(item.obj.faith_minor, self.x, self.y)
    end
    function Nuclear:render()
        local s = 0.95 + 0.05 * sin(self.timer * 4)
        SetImageState("Nuclear2", "mul+add", self._a * 255, self._r, self._g, self._b)
        Render("Nuclear2", self.x, self.y, self.rot, self.hscale * s, self.vscale * s)
        SetImageState("Nuclear1", "mul+add", self._a * 224, 255, 255, 255)
        Render("Nuclear1", self.x, self.y, self.rot, self.hscale, self.vscale)
    end
    class["Nuclear1"] = Class(Nuclear, {
        init = function(self, x, y)
            Nuclear.init(self, x, y)
            self.hscale = 0
            self.vscale = 0
            self.a = 0
            self.b = 0
            task.New(self, function()
                task.MoveTo(0, 0, 40, 2)
                Newcharge_out(self.x, self.y, 250, 128, 114)
                for i = 1, 30 do
                    self.hscale = 0.1 + sin(i * 3) * 0.9
                    self.vscale = self.hscale
                    self.a = 8.6 + 86 * sin(i * 3) * 0.9
                    self.b = self.a
                    task.Wait()
                end
                local a, _d_a = ran:Float(0, 360), 9.3
                while true do
                    New(class["bullet0-53D"], self, 0, 0, 0, a, 96, 320, -2.3, -0.3, { 0, -1.8, 1, 5 })
                    New(class["bullet0-53D"], self, 0, 0, 0, 180 - a, 96, 320, 2.3, 0.3, { 0, 1.8, 1, 5 })
                    task.Wait(2)
                    a = a + _d_a
                end
            end)
            task.New(self, function()
                for i = 1, 30 do
                    self.hscale = sin(i * 3) * 0.1
                    self.vscale = self.hscale
                    self.a = 86 * sin(i * 3) * 0.1
                    self.b = self.a
                    task.Wait()
                end
            end)
        end
    })
    class["Nuclear2"] = Class(Nuclear, {
        init = function(self, x, y, a, r, o)
            Nuclear.init(self, x, y, 1, 255, 64, 255)
            self.hscale = 0
            self.vscale = 0
            self.a = 0
            self.b = 0
            task.New(self, function()
                for i = 1, 30 do
                    self.hscale = sin(i * 3) * 0.15
                    self.vscale = self.hscale
                    self.a = 86 * sin(i * 3) * 0.15
                    self.b = self.a
                    task.Wait()
                end
            end)
            task.New(self, function()
                local c = 0
                while true do
                    c = c + 1
                    a = a + o
                    self.x, self.y = x + cos(a) * r * sin(c), y + sin(a) * r * sin(c)
                    task.Wait()
                end
            end)
        end
    })
    class["object0-7center"] = Class(object, {
        init = function(self, x, y, v, a, r, hrot, n)
            self.x, self.y = x, y
            PlaySound("kira00", 0.1, self.x / 150)
            self.group = GROUP.INDES
            self.colli = false
            self.hrot = hrot
            for i = 1, n do
                New(class["bullet0-7heart"], self, r, 360 / n * i)
            end
            task.New(self, function()
                for i = 1, 60 do
                    object.SetV(self, v - v * sin(i * 1.5), a)
                    task.Wait()
                end
                task.New(self, function()
                    task.Wait(30)
                    task.SmoothSetValueTo("hrot", 90, 80, 3)
                end)
                local b
                task.Wait(60)
                while self.y > -240 do
                    if self.timer % 2 == 0 then
                        for i = -1, 1, 2 do
                            b = NewSimpleBullet(ellipse, 8, self.x, self.y, 7, self.hrot + i * 5)
                            b.navi = true
                            b.master = self
                            task.New(b, function()
                                local unit = task.GetSelf()
                                while IsValid(unit.master) and not unit.master.jump do
                                    task.Wait()
                                end
                                while unit.vy > -6 do
                                    unit.vy = unit.vy - 0.1
                                    task.Wait()
                                end
                            end)
                        end
                    end
                    self.vy = max(-8, self.vy - 0.09)
                    task.Wait()
                end
                self.y = -240
                self.jump = true
                PlaySound("water", 0.3, self.x / 150, true)
                misc.ShakeScreen(20, 0.5)
                object.Del(self)
            end)
        end,
        frame = task.Do
    })
    class["object0-8laserline"] = Class(object, {
        init = function(self, y, d, time, index)
            self.y = y
            self.l = 0
            self.x = 320 * d
            self.x1 = 0
            self.layer = LAYER.BG + 1
            self.group = GROUP.INDES
            self.index = index
            task.New(self, function()
                for i = 1, 60 do
                    self.l = sin(i * 1.5) * 6
                    self.x1 = sin(i * 1.5) * 640 * -d
                    task.Wait()
                end
                task.Wait(time)
                Create.laser_line(self.x, self.y, index, 18, 90 + 90 * d, 60, 16)
                for i = 1, 60 do
                    self.l = 6 + sin(i * 1.5) * 4
                    task.Wait()
                end
                for i = 59, 0, -1 do
                    self.l = sin(i * 1.5) * 10
                    self.x1 = sin(i * 1.5) * 640 * -d
                    task.Wait()
                end
                object.Del(self)
            end)
        end,
        frame = task.Do,
        render = function(self)
            SetImageState("white", "mul+add", 50, unpack(ColorList[math.ceil(self.index / 2)]))
            RenderRect("white", self.x, self.x + self.x1, self.y + self.l * 0.6, self.y - self.l * 0.6)
            RenderRect("white", self.x, self.x + self.x1, self.y + self.l, self.y - self.l)
        end
    })
end---_object

do
    boss.Define("1a", "琪斯美", "TH11_0", TH11_bg, { 400, 400 }, nil, "Kisume", 7)
    local c1 = boss.card.New("", 60, 60, 60, 600)
    function c1:before()
        BossAction(self, 0)
        task.MoveTo(0, 120, 60, 2)
    end
    function c1:init()
        task.init_left_wait(self)
        task.New(self, function()
            local t = 10
            local a
            for j = 1, 6 do
                a = Angle(self, player) + 360 / t / 2 * j
                for _ = 1, t do
                    Create.bullet_decel(self.x, self.y, ball_mid, 6, 6, 3, a)
                    Create.laser_line(self.x, self.y, 1, 5, a + 360 / t / 2, 20, 6)
                    a = a + 360 / t
                end
                task.Wait2(self, beat)
                t = t + 3
            end
            t = 25
            for j = 1, 6 do
                a = Angle(self, player) + 360 / t / 2 * j
                for _ = 1, t do
                    Create.bullet_decel(self.x, self.y, ball_mid, 2, 6, 3, a)
                    Create.laser_line(self.x, self.y, 5, 5, a + 360 / t / 2, 20, 6)
                    a = a + 360 / t
                end
                task.Wait2(self, beat)
                t = t - 3
            end
        end)
        task.New(self, function()
            for _ = 1, 3 do
                task.MoveToPlayer(beat * 3, -250, 250, 50, 144,
                        100, 150, 24, 48, 2, WANDER_MODE.RANDOM)
            end
            task.New(self, function()
                for _ = 1, 30 do
                    for t = 1, 10 do
                        Create.laser_line(self.x, self.y, 5, 5, t * 36 + Angle(self, player), 20, 6)
                    end
                    task.Wait(2)
                end
            end)
            task.MoveTo(500 * ran:Sign(), -100, 60, VALUE_SET.ACCEL)
            self._bosssys:SpecialCheckGetCard()
            object.Del(self)
        end)
    end
    boss.card.add({ { c1, "1a" } }, 7, "第一回合", 59)

    boss.Define("2a", "黑谷山女", "TH11_0", TH11_bg, { -400, 400 }, nil, "Yamame", 7)
    local c2 = boss.card.New("", 60, 60, 60, 600)
    function c2:before()
        BossAction(self, 240)
        task.MoveTo(0, 120, 60, 2)
    end
    function c2:init()
        task.init_left_wait(self)
        task.New(self, function()
            local d = 1
            local a, rot, t
            for _ = 1, 4 do
                rot = ran:Float(0, 360)
                t = 1 + d
                for _ = 1, 15 do
                    a = rot
                    for _ = 1, 3 do
                        PlaySound("tan00")
                        for i = 1, 2 do
                            Create.bullet_dec_setangle(self.x, self.y, ball_mid, 6, false,
                                    { v = 6 + i, a = a, time = 35, wait = 0 },
                                    { v = 2, a = ({ a + 180, -90 })[t % 2 + 1], func = function(self)
                                        Create.bullet_create_eff(self.x, self.y, ball_mid, 2, GetV(self))
                                        bullet.ChangeImage(self, ball_mid, 2)
                                    end })

                        end
                        a = a + 120
                        t = t + 1
                    end
                    task.Wait(2)
                    rot = rot + 7 * d
                end
                d = -d
                task.Wait2(self, beat * 3 - 30)
            end
        end)
        task.New(self, function()
            for _ = 1, 3 do
                task.MoveToPlayer(beat * 3, -250, 250, 50, 144,
                        100, 150, 24, 48, 2, WANDER_MODE.RANDOM)
            end
            task.MoveTo(500 * ran:Sign(), -100, beat * 3, VALUE_SET.ACCEL)
            self._bosssys:SpecialCheckGetCard()
            object.Del(self)
        end)
    end
    boss.card.add({ { c2, "2a" } }, 7, "第一回合", 60)

    boss.Define("3a", "水桥帕露西", "TH11_0", TH11_bg, { -400, -400 }, nil, "Parsee", 7)

    local c3 = boss.card.New("", 60, 60, 60, 600)
    function c3:before()
        BossAction(self, 480)
        task.MoveTo(-250, 120, 60, 2)
    end
    function c3:init()
        task.init_left_wait(self)
        task.New(self, function()
            for _ = 1, 4 do
                New(class["bullet0-1"], self.x, self.y, Angle(self, player))
                New(class["bullet0-1"], self.x, self.y, Angle(self, player) + 180)
                task.Wait2(self, beat * 3)
            end
        end)
        task.New(self, function()
            task.MoveTo(500, 120, 240, VALUE_SET.ACCEL)
            self._bosssys:SpecialCheckGetCard()
            object.Del(self)
        end)
    end
    boss.card.add({ { c3, "3a" } }, 7, "第一回合", 61)

    boss.Define("4a", "星熊勇仪", "TH11_0", TH11_bg, { 400, -400 }, nil, "Yugi", 7)
    local c4 = boss.card.New("", 60, 60, 60, 600)
    function c4:before()
        BossAction(self, 720)
        task.MoveTo(0, 0, 60, 2)
    end
    function c4:init()
        task.init_left_wait(self)
        task.New(self, function()
            local x, y = self.x, self.y
            local col = { 6, 2, 14, 4 }
            local d = 1
            boss.cast(self, 180)
            local l = 0
            local A, a, rot, a1, rot1, x1, y1
            for t = 1, 4 do
                PlaySound("nice", 1, self.x, false)
                A = 45
                a = A
                rot = A
                for _ = 1, 10 do
                    a1 = a
                    rot1 = rot
                    for _ = 1, 6 do
                        x1, y1 = x + cos(a1) * l, y + sin(a1) * l
                        if Dist(player.x, player.y, x1, y1) > 35 then
                            Create.bullet_dec_setangle(x1, y1, ball_big, col[t],
                                    { time = 0, v = 0, a = a1, wait = 109 }, { v = 1.5, a = a1, func = function(self)
                                        Create.bullet_create_eff(self.x, self.y, ball_big, self._index + 2, GetV(self))
                                        bullet.ChangeImage(self, ball_big, self._index + 2)
                                    end })
                        end
                        a1 = a1 + 60
                        rot1 = rot1 + 60
                    end
                    task.Wait(3)
                    l = l + 9
                    a = a + 20 / 9 * d
                    rot = rot - 100 / 9 * d
                end
                d = -d
                task.Wait2(self, beat * 3 - 30)
            end
        end)
        task.New(self, function()
            task.Wait(180)
            task.MoveTo(0, 500, 60, VALUE_SET.ACCEL)
            self._bosssys:SpecialCheckGetCard()
            object.Del(self)
        end)
    end
    boss.card.add({ { c4, "4a" } }, 7, "第一回合", 62)
end ---wave1

do
    boss.Define("5a", "琪斯美", "TH11_0", TH11_bg, { 400, 400 }, nil, "Kisume", 7)
    boss.Define("5b", "黑谷山女", "TH11_0", TH11_bg, { -400, 400 }, nil, "Yamame", 7)
    local c1 = boss.card.New("", 60, 60, 60, 600)
    local c2 = boss.card.New("", 60, 60, 60, 600)
    boss.card.add({ { c1, "5a" }, { c2, "5b" } }, 7, "第二回合", 63)
    function c1:before()
        BossAction(self, 971)
        task.MoveTo(-70, 150, 60, 2)
    end
    function c1:init()

        task.New(self, function()
            local a = ran:Float(0, 360)
            for _ = 1, 120 do
                Create.laser_line(self.x + cos(a) * 20, self.y + sin(a) * 20, 4, 5, a, 20, 8, 33)
                Create.laser_line(self.x + cos(a) * 20, self.y + sin(a) * 20, 2, 6, a, 20, 20, 33)
                task.Wait(2)
                a = a + 80
            end
        end)
        task.New(self, function()
            for _ = 1, 3 do
                task.MoveToPlayer(beat * 3, -250, 250, 50, 144,
                        100, 150, 24, 48, 2, WANDER_MODE.RANDOM)
            end
            task.MoveTo(400 * ran:Sign(), -100, 60, VALUE_SET.ACCEL)
            self._bosssys:SpecialCheckGetCard()
            object.Del(self)
        end)
    end
    function c2:before()
        BossAction(self, 971)
        task.MoveTo(70, 150, 60, 2)
    end
    function c2:init()
        task.init_left_wait(self)
        task.New(self, function()
            for _ = 1, 3 do
                task.MoveToPlayer(60, -250, 250, 50, 144,
                        100, 150, 24, 48, 2, WANDER_MODE.RANDOM)
            end
            task.MoveTo(400 * ran:Sign(), -100, 60, VALUE_SET.ACCEL)
            self._bosssys:SpecialCheckGetCard()
            object.Del(self)
        end)
        task.New(self, function()
            local b
            for t = 1, 4 do
                PlaySound("nice", 1)
                local a = Angle(self, player)
                for c = 1, 81 do
                    b = Create.bullet_accel(self.x + cos(a) * 75, self.y + sin(a) * 75,
                            grain_b, 6, 0.3, 3 + LineNum(c * 360 / 81 * 6) * 2, a * t)
                    a = a + 360 / 81
                end
                task.Wait2(self, beat * 3)
            end
        end)
    end

    boss.Define("6a", "水桥帕露西", "TH11_0", TH11_bg, { 400, -400 }, nil, "Parsee", 7)
    boss.Define("6b", "星熊勇仪", "TH11_0", TH11_bg, { 400, -400 }, nil, "Yugi", 7)
    local c3 = boss.card.New("", 60, 60, 60, 600)
    local c4 = boss.card.New("", 60, 60, 60, 600)
    boss.card.add({ { c3, "6a" }, { c4, "6b" } }, 7, "第二回合", 64)
    function c3:before()
        BossAction(self, 1456)
        task.MoveTo(170, 120, 60, 2)
    end
    function c3:init()
        task.init_left_wait(self)
        task.New(self, function()
            local a2
            for _ = 1, 4 do
                local a = ran:Float(0, 360)
                for t = 1, 20 do
                    for a1 = -6, 6, 6 do
                        for v = 4, 5 do
                            a2 = a + v * 10 - 30
                            Create.bullet_dec_setangle(self.x, self.y, grain_b, 8, false,
                                    { v = v, a = a2 + a1, time = 60, wait = 49 }, { v = ({ 3, 2 })[t % 2 + 1], a = ({ a2 - a1, a2 - a1 + 180 })[t % 2 + 1] })
                        end
                    end
                    a = a + 18
                end
                task.Wait2(self, beat * 3)
            end
        end)
        task.New(self, function()
            task.MoveTo(-500, 120, 240, VALUE_SET.ACCEL)
            self._bosssys:SpecialCheckGetCard()
            object.Del(self)
        end)
    end

    function c4:before()
        BossAction(self, 1456)
        task.MoveTo(0, 0, 60, 2)
    end
    function c4:init()

        task.New(self, function()
            task.init_left_wait(self)
            for k = -1.5, 1.5 do
                New(class["bullet0-2"], self.x, self.y, 3, 90 + k * 45)
                task.Wait2(self, beat * 3)
            end
        end)
        task.New(self, function()
            task.Wait(180)
            task.MoveTo(0, 400, 60, 1)
            self._bosssys:SpecialCheckGetCard()
            object.Del(self)
        end)
    end

end---wave2

DoFile("mod\\GAME\\th11_2.lua")