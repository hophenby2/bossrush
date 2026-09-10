local class = {}
_editor_class["TH12"] = class

local cos, sin, abs, min, max, sign =  cos, sin, abs, min, max, sign
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
    local function numbercount()
        local s = stage.current_stage
        if s.enemy_number then
            s.enemy_number = s.enemy_number - 1
            if s.enemy_number == 0 then
                ext.achievement:get(18)
            end
        end
    end
    class["enemy0-1"] = Class(enemy, {
        init = function(self, x, y, mx, my)
            enemy.init(self, 9, 90)
            self.x, self.y = x, y
            task.New(self, function()
                task.MoveTo(mx, my, 60, 2)
                for _ = 1, 3 do
                    for i = 1, 3 do
                        for a = 1, 30 do
                            NewSimpleBullet(ball_mid, 6, self.x, self.y, 1 + i * 0.3, a * 18 + i * 9)
                        end
                    end
                    PlaySound("tan00", 0.1, 0, true)
                    task.Wait(80)
                end
                self.ay = 0.05
            end)
        end,
        kill = function(self)
            enemy.kill(self)
            numbercount()
            if SearchStageLevel[6] then
                UFO:New(self.x, self.y)
                UFO:New(self.x, self.y)
            end
        end
    })
    class["enemy0-2"] = Class(enemy, {
        init = function(self, x, y, x1, y1, x2, y2)
            enemy.init(self, 1, 8)
            self.x, self.y = x, y
            task.New(self, function()
                task.CRMoveTo(240, 1, x1, y1, x2, y2)
                self.vx, self.vy = self.dx, self.dy
            end)
        end,
        kill = function(self)
            enemy.kill(self)
            numbercount()
            item.Dropitem(item.obj.point, 1, self.x, self.y)
        end
    })
    class["enemy0-3"] = Class(enemy, {
        init = function(self, x, y, mx, my)
            enemy.init(self, 11, 13)
            self.x, self.y = x, y
            task.New(self, function()
                task.MoveTo(mx, my, 60, 2)
                local b
                for i = 18, 360, 18 do
                    PlaySound("tan00", 0.1, 0, true)
                    b = NewSimpleBullet(ball_small, 14, self.x + cos(i) * 40, self.y + sin(i) * 40, 0, i)
                    b.i, b.master = i, self
                    b.navi = true
                    b.frame_other = function(self)
                        if not IsValid(self.master) then
                            object.Del(self)
                            return
                        end
                        self.x, self.y = self.master.x + cos(self.i) * 40, self.master.y + sin(self.i) * 40
                    end
                end
                local ang = Angle(self, player) + ran:Float(-45, 45)
                self.ax = 0.03 * cos(ang)
                self.ay = 0.03 * sin(ang)
            end)
        end,
        kill = function(self)
            enemy.kill(self)
            numbercount()
            item.Dropitem(item.obj.point, 1, self.x, self.y)
        end
    })
end--enemy
do
    class["SCBG1"] = Class(_SC_BG)
    class["SCBG1"].init = function(self)
        _SC_BG.init(self)
        local b

        b = _SC_BG.AddLayer(self, "th12_1", true, 0, 0, 0, 0, 1.5)
        b.Beforeframe = function(self)
            self.a = 100 + sin(self.timer / 2) * 80
        end
        b = _SC_BG.AddLayer(self, "th12_3", false, 0, 224, 0, 0, 0, 0.1, "mul+add", 2, 2)
        b.a = 160
        b = _SC_BG.AddLayer(self, "th12_3", false, 0, -224, 0, 0, 0, 0.1, "mul+add", 2, 2)
        b.a = 160

        _SC_BG.AddLayer(self, "th12_2", true, 0, 0, 0, 0, 1.2, 0, "mul+add")
        _SC_BG.AddLayer(self, "th12_0", true, 0, 0, 0, 0, -0.5)

    end
    class["SCBG2"] = Class(_SC_BG)
    class["SCBG2"].init = function(self)
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th12_5", true, 0, 0, 0, -0.1, 0.8, 0, "")
        b.a = 100
        b = _SC_BG.AddLayer(self, "th12_7", true, 0, 0, 0, 0.8, -0.5, 0, "mul+add")
        b.a = 130
        b.Beforeframe = function(self)
            self.g = 100 + sin(self.timer / 2) * 80
        end
        b = _SC_BG.AddLayer(self, "th12_6", false, 0, 0, 0, 0, 0, 0.2, "mul+add", 2, 2)
        b.Beforeframe = function(self)
            self.a = 100 + cos(self.timer / 2) * 80
        end
        _SC_BG.AddLayer(self, "th12_4")
    end
    class["SCBG3"] = Class(_SC_BG)
    class["SCBG3"].init = function(self)
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th12_1", true, 0, 0, 0, 0, 1.5)
        b.Beforeframe = function(self)
            self.a = 100 + sin(self.timer / 2) * 80
        end
        b = _SC_BG.AddLayer(self, "th12_9", true, 0, 0, 0, -0.8, -1)
        b.Beforeframe = function(self)
            self.r = 100 + sin(self.timer / 2) * 80
            self.g = 100 + sin(self.timer / 5) * 80
            self.b = 100 + sin(self.timer / 3) * 80
        end
        _SC_BG.AddLayer(self, "th12_0", true, 0, 0, 0, 0, -0.5, 0, "mul+add")

        _SC_BG.AddLayer(self, "th12_8")
    end
    class["SCBG4"] = Class(_SC_BG)
    class["SCBG4"].init = function(self)
        _SC_BG.init(self)
        local b
        b = _SC_BG.AddLayer(self, "th12_11", false, 0, 0, 0, 0, 0, 0.5)
        b.Beforeframe = function(self)
            self.r = 150 + sin(self.timer / 8) * 80
            self.g = 150 + sin(self.timer / 10) * 80
            self.b = 150 + sin(self.timer / 6) * 80
        end
        _SC_BG.AddLayer(self, "th12_10", true, 0, 0, 0, 0, 1, 0, "mul+add", 1.5, 1.5)
        b = _SC_BG.AddLayer(self, "th12_9", true, 0, 0, 0, -0.8, -1)
        b.Beforeframe = function(self)
            self.r = 100 + sin(self.timer / 2) * 80
            self.g = 100 + sin(self.timer / 5) * 80
            self.b = 100 + sin(self.timer / 3) * 80
        end
        _SC_BG.AddLayer(self, "th12_8")
    end
    class["SCBG5"] = Class(_SC_BG)
    class["SCBG5"].init = function(self)
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
        b.a = 150
        b = _SC_BG.AddLayer(self, "th12_11", false, 0, 0, 0, 0, 0, 0.5)
        b.Beforeframe = function(self)
            self.r = 150 + sin(self.timer / 8) * 80
            self.g = 150 + sin(self.timer / 10) * 80
            self.b = 150 + sin(self.timer / 6) * 80
        end
        _SC_BG.AddLayer(self, "th12_10", true, 0, 0, 0, 0, 1, 0, "mul+add", 1.5, 1.5)
        _SC_BG.AddLayer(self, "th12_12")
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
        b.a = 150
        b = _SC_BG.AddLayer(self, "th12_3", false, 0, 224, 0, 0, 0, 0.1, "mul+add", 2, 2)
        b.a = 160
        b = _SC_BG.AddLayer(self, "th12_3", false, 0, -224, 0, 0, 0, 0.1, "mul+add", 2, 2)
        b.a = 160

        b = _SC_BG.AddLayer(self, "th12_2", true, 0, 0, 0, 0, 1.2, 0, "mul+add")
        b.a = 200
        b = _SC_BG.AddLayer(self, "th12_12")
        b.r, b.g, b.b = 150, 150, 150
    end
end--_SC_BG
do
    class["laser0-1"] = Class(laser, {
        init = function(self, x, y)
            laser.init(self, 6, x, y, 90, 0, 12, 12, 12, 12, 0)
            laser._TurnHalfOn(self, 0, false)
            self.line = 0
            self.Isradial=true
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
    })
    class["laser1-1"] = Class(laser, {
        init = function(self, x, y, a, oa)
            laser.init(self, 14, x, y, a + oa, 0, 0, 0, 18, 18, 0)
            self.line = 0
            self.Isradial=true
            self.radial_v = 16
            laser._TurnHalfOn(self, 0, false)
            task.New(self, function()
                for i = 1, 60 do
                    self.line = sin(i * 1.5) * 600
                    self.rot = a + oa - oa * sin(i * 1.5)
                    task.Wait()
                end
                laser._TurnOn(self, 1, true, false)
                task.New(self, function()
                    for _ = 1, 30 do
                        self.l3 = self.l3 + 16
                        task.Wait()
                    end
                    for _ = 1, 20 do
                        self.l2 = self.l2 + 16
                        task.Wait()
                    end
                    for _ = 1, 30 do
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
    })
    class["laser1-2"] = Class(bent_laser, {
        init = function(self, x, y, l, a, v, c, t, r, index, w, len)
            bent_laser.init(self, index or 6, x, y, len or 40, w or 10, 4, w or 10)
            PlaySound("lazer00")
            task.New(self, function()
                while true do
                    self.x = x + cos(a) * l + cos(a + 90) * r * sin(c)
                    self.y = y + sin(a) * l + sin(a + 90) * r * sin(c)
                    task.Wait()
                    l = l + v
                    c = c + t
                end
            end)
        end })
end--laser
do
    class["bullet0-1"] = Class(bullet, {
        init = function(self, master, l, v, _rot)
            bullet.init(self, ellipse, 14, false, true)
            self.master = master
            self.timer = 11
            self._rot = _rot
            self.rot = self._rot + self.master.rot
            self._blend = "mul+add"
            self.l = l
            self.v = v
            self.x, self.y = self.master.x + cos(self.rot) * self.l, self.master.y + sin(self.rot) * self.l
        end,
        frame = function(self)
            bullet.frame(self)
            if not IsValid(self.master) then
                object.Del(self)
                return
            end
            self.rot = self._rot + self.master.rot
            self.x, self.y = self.master.x + cos(self.rot) * self.l, self.master.y + sin(self.rot) * self.l
            self.l = self.l + self.v
        end
    })
    class["bullet0-2"] = Class(bullet, { init = function(self, x, y, v, a, t)
        bullet.init(self, water_drop, 14, false, true)
        PlaySound("tan00")
        self.x, self.y = x, y
        object.SetV(self, v, a, true)
        task.New(self, function()
            for i = 1, 60 do
                object.SetV(self, v - v * sin(i * 1.5), a, true)
                self._a = 255 * sin(90 - i * 1.5)
                task.Wait()
            end
            task.Wait(t - 60)
            for i = 1, 30 do
                object.SetV(self, sin(i * 3), a, true)
                self._a = 255 * sin(i * 3)
                task.Wait()
            end
            for i = 1, 60 do
                object.SetV(self, 1 + sin(i * 1.5) * 5, a, true)
                task.Wait()
            end
            self.ax = 0.03 * cos(self.rot)
            self.ay = 0.03 * sin(self.rot)
        end)
    end })
end --bullet
do
    class["object0-1"] = Class(object, {
        init = function(self, x, y, a)
            self.x, self.y = x, y
            self.img = "machine"
            self.layer = LAYER.ENEMY
            self.group = GROUP.INDES
            self.bound = false
            self._a = 0
            self.stop = false
            self.a = 8
            self.b = 8
            PlaySound("heal", 1, self.x)
            self.hscale = 1
            self.vscale = 1
            object.SetV(self, 3, a)
            self.navi = true
            object.SetG(self, 0.04)
            object.ForbidV(self, 3.5)
            task.New(self, function()
                for i = 0, 15 do
                    self.hscale = 1 - 0.5 * sin(i * 6)
                    self.vscale = 1 - 0.5 * sin(i * 6)
                    self._a = sin(i * 6) * 255
                    task.Wait()
                end
            end)
            task.New(self, function()
                while not self.stop do
                    task.Wait()
                end
                misc.ShakeScreen(10, 0.6)
                self.navi = false
                New(class["laser0-1"], self.x, self.y)
                object.StopMoving(self)
                object.Del(self)
            end)
        end,
        frame = function(self)
            task.Do(self)
            if self.x > 192 or self.x < -192 then
                self.vx = -self.vx
            end
            if self.y < -224 then
                self.stop = true
            end
        end,
        render = function(self)
            SetImageState(self.img, "", self._a, 255, 255, 255)
            DefaultRenderFunc(self)
        end,
        del = function(self)
            object.Preserve(self)
            task.New(self, function()
                for i = 0, 10 do
                    self.hscale = 0.5 + sin(i * 9)
                    self.vscale = 0.5 + sin(i * 9)
                    self._a = 255 - sin(i * 9) * 255
                    task.Wait()
                end
                object.RawDel(self)
            end)
        end
    })
    class["object0-2circle"] = Class(object, {
        init = function(self, x, y, master)
            self.x, self.y = x, y

            self.group = GROUP.ENEMY
            self.layer = LAYER.ENEMY_BULLET
            self.colli = false
            self.line = 0
            self.omiga = -0.5
            local b
            for i = 18, 360, 18 do
                b = NewSimpleBullet(ball_mid_c, 14, self.x, self.y, 0, i, false, 5, false, false)
                b.master = self
                function b:frame_other()
                    if not IsValid(self.master) then
                        object.Del(self)
                        return
                    end
                    self.x, self.y = self.master.x + cos(self.rot) * 40, self.master.y + sin(self.rot) * 40
                end
            end
            PlaySound("boon00")
            task.New(self, function()
                for i = 1, 60 do
                    self.line = 600 * sin(i * 1.5)
                    task.Wait()
                end
                task.Wait(60)
                Newcharge_out(self.x, self.y, 255, 227, 132)
                task.New(self, function()
                    boss.violent(master)
                    PlaySound("lazer00")
                    task.New(self, function()
                        task.Wait(60)
                        for i = 18, 360, 18 do
                            b = NewSimpleBullet(ball_mid_c, 14, self.x, self.y, 0, i, false, 5, false, false)
                            b.master = self
                            function b:frame_other()
                                if not IsValid(self.master) then
                                    object.Del(self)
                                    return
                                end
                                self.x, self.y = self.master.x + cos(self.rot) * 40, self.master.y + sin(self.rot) * 40
                            end
                        end
                    end)
                    while true do
                        for i = 1, 8 do
                            New(class["bullet0-1"], self, 40, 8, i * 45)
                        end
                        task.Wait(3)
                    end
                end)
                task.Wait(120)
                while true do
                    for i = 1, 12 do
                        New(class["bullet0-1"], self, 40, 1, i * 30)
                        PlaySound("tan00")
                    end
                    task.Wait(78)
                end
            end)
        end,
        frame = function(self)
            task.Do(self)
            self.ax = -player.x / 180 * 0.04
            self.ay = -player.y / 180 * 0.04
            local offset = 20
            if self.x < lstg.world.l + offset then
                self.vx = -self.vx * 0.8
                self.x = 2 * (lstg.world.l + offset) - self.x
            end
            if self.x > lstg.world.r - offset then
                self.vx = -self.vx * 0.8
                self.x = 2 * (lstg.world.r - offset) - self.x
            end
            if self.y < lstg.world.b + offset then
                self.vy = -self.vy * 0.8
                self.y = 2 * (lstg.world.b + offset) - self.y
            end
            if self.y > lstg.world.t - offset then
                self.vy = -self.vy * 0.8
                self.y = 2 * (lstg.world.t - offset) - self.y
            end
        end,
        render = function(self)
            local a
            local l = self.line / 2 + 40
            for i = 1, 8 do
                a = i * 45 + self.rot
                SetImageState("white", "mul+add", 180, 255, 227, 132)
                Render("white", self.x + cos(a) * l, self.y + sin(a) * l, a, self.line / 16, 0.125)
                SetImageState('laser_node7', "mul+add", 128, 255, 255, 255)
                Render('laser_node7', self.x + cos(a) * 40, self.y + sin(a) * 40, 18 * self.timer, 1)
                Render('laser_node7', self.x + cos(a) * 40, self.y + sin(a) * 40, -18 * self.timer, 1)
            end
        end
    })
    class["ByakurenLightBack"] = Class(object, {
        init = function(self, master)
            self.x, self.y = master.x, master.y
            self.master = master
            self.layer = LAYER.ENEMY - 6
            self.group = GROUP.GHOST
            self.bound = false
            self.offx, self.offy = 0, 0
            self.back_a = { hscale = 0, vscale = 1 }
            self.back_b = { rot = 90, hscale = 0, vscale = 0 }
            self.back_c = {
                { t = 1, x = 114, y = -56, rot = 0, hscale = 0, vscale = 0 },
                { t = 1, x = -114, y = -56, rot = 0, hscale = 0, vscale = 0 },
                { t = 2, x = 64, y = 80, rot = 0, hscale = 0, vscale = 0 },
                { t = 2, x = -64, y = 80, rot = 0, hscale = 0, vscale = 0 },
            }
            function self:GetAngle(b)
                return Angle(self.x + b.x, self.y + b.y, player)
            end--flower的朝向事件，可更改
            local pos = { {}, {}, {}, {} }
            function self:GetFlowerPos()
                local b = self.back_c
                pos[1][1], pos[1][2], pos[1][3] = self.x + b[1].x, self.y + b[1].y, b[1].rot
                pos[2][1], pos[2][2], pos[2][3] = self.x + b[2].x, self.y + b[2].y, b[2].rot
                pos[3][1], pos[3][2], pos[3][3] = self.x + b[3].x, self.y + b[3].y, b[3].rot
                pos[4][1], pos[4][2], pos[4][3] = self.x + b[4].x, self.y + b[4].y, b[4].rot
                return pos
            end--获取flower的坐标与朝向
            task.New(self, function()
                PlaySound("boon01")
                for i = 1, 30 do
                    self.back_b.rot = 90 - sin(i * 3) * 90
                    self.back_b.hscale = sin(i * 3)
                    self.back_b.vscale = sin(i * 3)
                    task.Wait()
                end
                for i = 1, 30 do
                    self.back_a.hscale = sin(i * 3)
                    task.Wait()
                end
                task.New(self, function()
                    while true do
                        for i = 1, 50 do
                            self.back_a.hscale = 1 - 0.05 * sin(i * 1.8)
                            task.Wait()
                        end
                        for i = 1, 50 do
                            self.back_a.hscale = 0.95 + 0.05 * sin(i * 1.8)
                            task.Wait()
                        end
                    end
                end)
                PlaySound("tan00")
                for i = 1, 30 do
                    for _, b in ipairs(self.back_c) do
                        b.hscale = sin(i * 3)
                        b.vscale = sin(i * 3)
                    end
                    task.Wait()
                end
                task.Wait(20)
                task.New(self, function()
                    while true do
                        for i = 1, 50 do
                            self.back_b.hscale = 1 - 0.05 * sin(i * 1.8)
                            self.back_b.vscale = self.back_b.hscale
                            task.Wait()
                        end
                        for i = 1, 50 do
                            self.back_b.hscale = 0.95 + 0.05 * sin(i * 1.8)
                            self.back_b.vscale = self.back_b.hscale
                            task.Wait()
                        end
                    end
                end)
            end)
            task.New(self, function()
                while true do
                    for i = 1, 50 do
                        for t, b in ipairs(self.back_c) do
                            b.rot = sign(b.x) * 10 * sin(i * 1.8) + self:GetAngle(b, t)
                        end
                        task.Wait()
                    end
                    for i = 1, 50 do
                        for t, b in ipairs(self.back_c) do
                            b.rot = sign(b.x) * 10 * (1 - sin(i * 1.8)) + self:GetAngle(b, t)
                        end
                        task.Wait()
                    end
                end
            end)
        end,
        frame = function(self)
            task.Do(self)
            if not IsValid(self.master) then
                object.Del(self)
                return
            end
            local x, y = self.master._wisys:GetFloat(self.master.ani)
            self.x = self.master.x + x + self.offx
            self.y = self.master.y + y + self.offy
        end,
        render = function(self)

            Render("byakuren_b", self.x, self.y, self.back_b.rot, self.back_b.hscale, self.back_b.vscale)
            Render("byakuren_a", self.x, self.y, 0, self.back_a.hscale, self.back_a.vscale)
            for t, b in ipairs(self.back_c) do
                Render('byakuren_d', self.x + b.x + 5 * cos(self:GetAngle(b, t)), self.y + b.y + 5 * sin(self:GetAngle(b, t)), 0, b.hscale, b.vscale)
                Render("byakuren_c" .. b.t, self.x + b.x, self.y + b.y, b.rot, b.hscale, b.vscale)
            end
        end,
        del = function(self)
            for _, p in ipairs(self:GetFlowerPos()) do
                enemy.death_ef(p[1], p[2], 10, 1)
            end
            enemy.death_ef(self.x, self.y, 10, 1)
        end,
        kill = function(self)
            self.class.del(self)
        end
    })
    class["DamageCircle"] = Class(enemy, {
        init = function(self, master)
            self.x, self.y = master.x, master.y
            enemybase.init(self, 1000, true)
            self.layer = LAYER.ENEMY - 1
            object.Connect(master, self, 1.2, true)
            self.a = 0
            self.b = 0
            self.protect = true
            self.d_hp = { self.hp, self.hp }
            self.damaged = 0
            task.New(self, function()
                for i = 1, 60 do
                    self.a = 100 * sin(i * 1.5)
                    self.b = self.a
                    task.Wait()
                end
                self.protect = false
                for _ = 1, 180 do
                    if not IsValid(master) then
                        object.Del(self)
                        return
                    end
                    if master.attack then
                        if self.a <= 16 then
                            master.attack = false
                            master.cast = 0
                            master.cast_t = 0
                            PlaySound("explode")
                            enemy.death_ef(self.x, self.y, 10, 1)
                            local b
                            for i = 1, 30 do
                                b = NewSimpleBullet(ellipse, 14, master.x, master.y, 1, i * 12)
                                b._blend = "mul+add"
                            end
                            object.Del(self)
                        end
                        if self.damaged ~= 0 then
                            self.a = self.a - self.damaged * 1.6
                            self.b = self.a
                        end
                    end
                    task.Wait()
                end
                object.Del(self)
            end)
        end,
        frame = function(self)
            enemybase.frame(self)
            self.d_hp[self.ani % 2 + 1] = self.hp
            self.damaged = abs(self.d_hp[1] - self.d_hp[2])
        end,
        render = function(self)
            SetImageState("circle_charge", "mul+add", 255, 250, 128, 114)
            Render("circle_charge", self.x, self.y, 0, self.a / 256)
        end,
        del = function()
        end,
        kill = function()
        end
    })
    class["object1-1circle"] = Class(object, {
        init = function(self, x, y, pr, a, o, cr)
            self.group = GROUP.INDES
            self.layer = LAYER.ENEMY_BULLET_EF
            self.bound = false
            self.x, self.y = x + cos(a) * pr, y + sin(a) * pr
            self._a = 0
            self.__r, self.__g, self.__b = 100, 100, 100
            self._r, self._g, self._b = 100, 100, 100
            self.radius = cr
            self.colli = false

            task.New(self, function()
                task.Wait(180)
                local c = 0
                while true do
                    self.x = x + cos(a) * pr
                    self.y = y + sin(a) * pr
                    a = a + o * sin(c)
                    c = min(c + 0.4, 90)
                    task.Wait()
                end
            end)
            task.New(self, function()
                for i = 1, 60 do
                    self._a = sin(i * 1.5)
                    task.Wait()
                end
            end)
        end,
        frame = function(self)
            task.Do(self)
            self._r = self._r + (-self._r + self.__r) * 0.08
            self._g = self._g + (-self._g + self.__g) * 0.08
            self._b = self._b + (-self._b + self.__b) * 0.08
        end,
        render = function(self)
            SetImageState("circle_charge", "mul+add", self._a * 180, self._r, self._g, self._b)
            Render("circle_charge", self.x, self.y, 0, self.radius / 256)
        end
    })
end--_object


do
    boss.Define("1a", "娜兹玲", "TH12_0", TH12_bg, { 0, 400 }, class["SCBG1"], "Nazrin", 8)
    boss.Define("1b", "多多良小伞", "TH12_0", TH12_bg, { 0, 400 }, class["SCBG1"], "Kogasa", 8)
    local name = "恐吓「缝里的珍宝」"
    local sc1 = boss.card.New(name, 1, 1, 60, 700)
    local sc2 = boss.card.New(name, 1, 1, 60, 700)
    boss.card.add({ { sc1, "1a" }, { sc2, "1b" } }, 8, name, 78)

    function sc1:before()
        task.MoveTo(-50, 50, 60, 2)
    end
    function sc1:init()
        local n = 30
        local num = 3
        local wait = 160
        task.New(self, function()
            boss.violent(self)
            n = 90
            num = 7
            wait = 80
        end)
        task.New(self, function()
            while true do
                boss.cast(self, 60)
                for i = -num, num do
                    New(class["object0-1"], self.x, self.y, i * 36 / num + ran:Float(-15, 15) + 90)
                end
                task.Wait(wait)
                PlaySound("tan00")
                for i = 360 / n, 360, 360 / n do
                    NewSimpleBullet(grain_b, 8, self.x + cos(i) * 30, self.y, 1, i)
                    NewSimpleBullet(grain_b, 8, self.x, self.y + sin(i) * 30, 1, i)
                end
                task.MoveToPlayer(60, -96, 20, 30, 60, 20, 40, 16, 32, 2, 1)
                task.Wait(wait - 60)
            end
        end)
    end

    function sc2:before()
        task.MoveTo(50, 120, 60, 2)
    end
    function sc2:init()
        local wait = 60
        local n = 10
        local L = 40
        local v = 5
        task.New(self, function()
            boss.violent(self)
            wait = 20
            n = 14
            L = 56
            v = 7
        end)
        task.New(self, function()
            while true do
                Newcharge_in(self.x, self.y, 250, 128, 114)
                task.Wait(60)
                boss.cast(self, 240)
                local a = ran:Float(0, 360)
                local c = 240 / L + 0.2
                for l = 1, L do
                    for i = 360 / n, 361, 360 / n do
                        for j = -1, 1, 2 do
                            Create.bullet_accel(self.x + cos(i + a) * sin(l * c) * 150, self.y + sin(i + a) * sin(l * c) * 150,
                                    water_drop, 6, 0.5, v, i + a + j * 360 / n * 1.16)
                        end
                    end
                    PlaySound("tan00", 0, self.x / 100)
                    task.Wait(240 / L)
                end
                task.Wait(wait)
                task.MoveToPlayer(60, -20, 96, 100, 144, 20, 40, 16, 32, 2, 1)
            end
        end)
    end
end---boss1

do
    boss.Define("2a", "云居一轮", "TH12_0", TH12_bg, { -200, 400 }, class["SCBG2"], "Ichirin", 8)
    boss.Define("2b", "村纱水蜜", "TH12_0", TH12_bg, { 200, 400 }, class["SCBG2"], "Murasa", 8)
    local name = "必杀「金环光，截长勺」"
    local sc1 = boss.card.New(name, 1, 1, 60, 650)
    local sc2 = boss.card.New(name, 30, 30, 30, 300)
    boss.card.add({ { sc1, "2a" }, { sc2, "2b" } }, 8, name, 79)

    function sc1:before()
        self.particle = {}
        task.MoveTo(0, 50, 60, 2)
        self.group = GROUP.NONTJT
    end
    function sc1:init()
        _object.set_color(self, "", 255, 200, 200, 200)
        object.Connect(self, New(class["object0-2circle"], self.x, self.y, self))
        task.New(self, function()
            boss.cast(self, 66666)
        end)
    end
    function sc1:frame()
        if self.is_combat then
            table.insert(self.particle, {
                x = self.x + ran:Float(-75, 75),
                y = self.y + ran:Float(-75, 75),
                rot = ran:Float(0, 360),
                alpha = 0,
                color = { 255, 227, 132 } })
            local p
            for i = #self.particle, 1, -1 do
                p = self.particle[i]
                p.x = p.x + (-p.x + self.x) * 0.05
                p.y = p.y + (-p.y + self.y) * 0.05
                p.rot = p.rot + 3
                p.alpha = min(p.alpha + 150 / 15, 150)
                if Dist(p.x, p.y, self.x, self.y) < 1 then
                    table.remove(self.particle, i)
                end
            end
        end
    end
    function sc1:render()
        for _, s in ipairs(self.particle) do
            SetImageState("white", "mul+add", s.alpha / 2, unpack(s.color))
            Render("white", s.x, s.y, s.rot, 0.5)
            SetImageState("white", "mul+add", s.alpha, unpack(s.color))
            Render("white", s.x, s.y, s.rot, 0.25)
        end
    end

    function sc2:before()
        task.MoveTo(50, 100, 60, 2)
    end
    function sc2:init()
        self.attack = function(self)
            local a = Angle(self, player)
            local a2
            for i = 1, 10 do
                for j = -2, 2 do
                    a2 = i * 36 + j * 2
                    NewSimpleBullet(diamond, 8, self.x + cos(a2) * 10, self.y + sin(a2) * 10, 1.5, a2)
                end
                for j = -2, 2 do
                    a2 = i * 36 + j * 2 + 18
                    NewSimpleBullet(diamond, 8, self.x + cos(a2) * 20, self.y + sin(a2) * 20, 0.5, a2)
                end
            end
            PlaySound("kira00")
        end
        task.New(self, function()
            boss.violent(self)
            self.attack = function(self)
                local a = Angle(self, player)
                for i = 1, 20 do
                    Create.laser_line(self.x, self.y, 6, 6, i * 18 + a, 40, 8, 10, 8)
                end
                local a2
                for i = 1, 10 do
                    for v = 2, 5 do
                        for j = -2, 2 do
                            a2 = i * 36 + j * 1.2 + v * 17
                            NewSimpleBullet(diamond, 8, self.x + cos(a2) * (30 - v * 5), self.y + sin(a2) * (30 - v * 5), v * 0.4, a2)
                        end
                    end
                end
            end
        end)
        self.tp = function(self, x, y)
            PlaySound("boon01")
            local j = 1
            for i = 1, 40 do
                self._wisys:SetFloat(sin(i * 2.25) * 30 * j, 0)
                j = -j
                task.Wait()
            end
            self.x, self.y = x, y
            PlaySound("boon01")
            for i = 39, 0, -1 do
                self._wisys:SetFloat(sin(i * 2.25) * 30 * j, 0)
                j = -j
                task.Wait()
            end
        end
        task.New(self, function()
            self.colli = false
            Newcharge_in(self.x, self.y, 125, 125, 125)
            task.Wait(60)
            self._wisys:SetFloat()
            self._wisys:SetImageInList("Murasa2")
            task.Wait(30)
            self:tp(0, 0)
            local wait = 130
            while true do
                boss.cast(self, 60)
                self:attack()
                task.Wait(wait)
                self:tp(player.x + ran:Float(-25, 25), player.y + ran:Float(-25, 25))
                wait = max(0, wait - 10)
            end
        end)
    end
end---boss2

do
    boss.Define("3a", "娜兹玲", "TH12_0", TH12_bg, { 300, 400 }, class["SCBG3"], "Nazrin", 8)
    boss.Define("3b", "寅丸星", "TH12_0", TH12_bg, { 300, 400 }, class["SCBG3"], "Shou", 8)
    local name = "奋探「勇攻狭道的猛虎」"
    local sc1 = boss.card.New(name, 1, 1, 60, 500)
    local sc2 = boss.card.New(name, 1, 1, 60, 700)
    boss.card.add({ { sc1, "3a" }, { sc2, "3b" } }, 8, name, 80)

    function sc1:before()
        task.MoveTo(-140, 100, 60, 2)
    end
    function sc1:init()
        local r = 50
        local wait1, wait2 = 24, 7
        task.New(self, function()
            boss.violent(self)
            wait1, wait2 = 12, 4
            task.Wait(60)
            while true do
                NewSimpleBullet(ball_mid_c, 4, self.x + ran:Float(-40, 40), self.y + ran:Float(-40, 40), 3, -90)
                task.Wait(wait1)
            end
        end)
        self.pos = { { -r, 0 }, { r, 0 } }
        task.New(self, function()
            while true do
                NewSimpleBullet(ball_mid_c, 4, self.x + ran:Float(-40, 40), self.y + ran:Float(-40, 40), 2, -90)
                task.Wait(wait1)
            end
        end)
        task.New(self, function()
            while true do
                for _, p in ipairs(self.pos) do
                    NewSimpleBullet(square, 3, self.x + p[1], self.y + p[2],
                            2, -90, false, 0, false)
                    NewSimpleBullet(square, 3, self.x + p[1], self.y + p[2],
                            2, 90, false, 0, false)
                    PlaySound("tan00")
                end
                task.Wait(wait2)
            end
        end)
        task.New(self, function()
            while true do
                task.Wait(30)
                task.New(self, function()
                    local d = sign(-self.x)
                    for i = 59, 0, -1 do
                        self.pos[1][2] = r * d * sin(90 - i * 1.5)
                        self.pos[2][2] = -r * d * sin(90 - i * 1.5)
                        self.pos[1][1] = -r * sin(i * 1.5)
                        self.pos[2][1] = r * sin(i * 1.5)
                        task.Wait()
                    end
                    task.Wait(60)
                    for i = 59, 0, -1 do
                        self.pos[1][2] = r * d * sin(i * 1.5)
                        self.pos[2][2] = -r * d * sin(i * 1.5)
                        self.pos[1][1] = -r * sin(90 - i * 1.5)
                        self.pos[2][1] = r * sin(90 - i * 1.5)
                        task.Wait()
                    end
                end)
                boss.cast(self, 180, true)
                task.MoveTo(-self.x, self.y, 180, 3)
            end
        end)
    end

    function sc2:before()
        task.MoveTo(0, 0, 60, 2)
    end
    function sc2:init()
        local rand = 20
        local V = 1
        task.New(self, function()
            boss.violent(self)
            rand = 30
            V = 3
        end)
        task.New(self, function()
            boss.cast(self, 3600)
            local d = 1
            while true do
                for v = 1, 5 do
                    for i = 1, 60 do
                        New(class["bullet0-2"], self.x, self.y, v, -80 + 340 / 60 * i + (v - 1) * 10 * d, 60 + v * 13)
                    end
                end
                task.Wait(90)
                Newcharge_in(self.x, self.y, 255, 227, 132)
                task.Wait(60)
                local A = Angle(self, player)
                for i = 1, 20 do
                    for v = 1, V do
                        Create.laser_line(self.x, self.y, 14, 2 + v, i * 18 + v * 9, 30, 6, 12)
                    end
                end
                local a, l
                for i = 1, 30 do
                    for _ = 1, 4 do
                        a = A + ran:Float(-15, 15)
                        l = i * 7 + ran:Float(-10, 10)
                        NewSimpleBullet(arrow_big, 14, self.x + cos(a) * l, self.y + sin(a) * l, ran:Float(3, 6), A + ran:Float(-rand, rand))
                        PlaySound("tan00")
                    end
                    task.Wait()
                end
                task.Wait(22)
                d = -d
            end
        end)
    end
end---boss3

do
    boss.Define("4a", "寅丸星", "TH12_1", TH12_bg, { -400, 0 }, class["SCBG4"], "Shou", 8)
    boss.Define("4b", "圣白莲", "TH12_1", TH12_bg, { -400, 0 }, class["SCBG4"], "Byakuren", 8)
    local name = "护法「密切守护绝对真理」"
    local sc1 = boss.card.New(name, 1, 1, 60, 1500)
    local sc2 = boss.card.New(name, 1, 1, 60, 1500)
    boss.card.add({ { sc1, "4a" }, { sc2, "4b" } }, 8, name, 81)

    function sc1:before()
        self.A, self.B = 24, 24
        self.DMG_factor = 0.7
        task.MoveTo(0, 0, 60, 2)
    end
    function sc1:init()
        task.New(self, function()
            local b
            local d = 1
            while true do
                for j = 1, 240 do
                    if j % 3 == 0 then
                        b = NewSimpleBullet(ball_mid, 14, self.x, self.y, ran:Float(0.5, 3), ran:Float(0, 360))
                        b._blend = "mul+add"
                        b.cao = 240 - j - 11
                        b.frame_other = function(self)
                            if self.timer > self.cao then
                                object.Del(self)
                            end
                        end
                        PlaySound("tan00", 0, self.x / 100)
                    end
                    self.x = self.x + (-self.x + player.x) * 0.025
                    task.Wait()
                end
                d = -d
                boss.cast(self, 10, true)
                for i = 1, 20 do
                    for v = 2, 4 do
                        b = Create.bullet_accel(self.x, self.y, ellipse, 14, 0.3, v, i * 18 + v * 9)
                        b._blend = "mul+add"
                    end
                end
                task.Wait(60)
            end
        end)
    end
    sc1.frame = boss.card.PublicHP

    function sc2:before()
        self.lightback = New(class["ByakurenLightBack"], self)
        self.lightback.GetAngle = function(self)
            return -90
        end
        task.MoveTo(0, 140, 60, 2)
    end
    function sc2:init()
        self.colli = false
        self.particle = {}
        task.New(self, function()
            task.Wait(60)
            local j = 1
            local ang = {}
            while true do
                ang = { j * 1.5, j * -1.5, -j, j }
                self.lightback.GetAngle = function(self, b, t)
                    return -90 + ang[t]
                end
                if j % 15 == 0 then
                    for t, p in ipairs(self.lightback:GetFlowerPos()) do
                        Create.laser_line(p[1], p[2], 14, 3, -90 + ang[t], 35, 6, 8)
                    end
                end
                j = j + 1
                task.Wait()
            end
        end)
        task.New(self, function()
            while true do
                Newcharge_in(self.x, self.y, 128, 32, 32)
                self.attack = true
                New(class["DamageCircle"], self)
                task.Wait(60)
                boss.cast(self, 180)
                PlaySound("ch00")
                task.Wait(180)
                self.lightback.GetAngle = function()
                    return -90
                end
                if self.attack then
                    enemy.death_ef(self.x, self.y, 10, 2)
                    self.attack = false
                    local A, b = Angle(self, player)+22.5
                    for a = 1, 8 do
                        for v = 1, 4 do
                            for t = -6, 6 do
                                b = NewSimpleBullet(ellipse, 2, self.x, self.y, 6 + v * 0.9 - abs(t) / 4, A + t * 2.5 + a * 45)
                                b._blend = "mul+add"
                                b.interval = ran:Int(60, 90)
                                b.c = ran:Int(25, 45)
                                b.frame_other = function(self)
                                    if (self.timer + self.c) % self.interval == 0 then
                                        local c = NewSimpleBullet(ball_mid_c, 14, self.x, self.y, ran:Float(1, 2), ran:Float(0, 360))
                                        c._blend = "mul+add"
                                        PlaySound("tan00")
                                    end
                                end
                            end
                        end
                    end
                    Newcharge_out(self.x, self.y, 255, 227, 132)
                end
                task.Wait(60)
            end
        end)
    end
    function sc2:frame()
        boss.card.PublicHP(self)
        if self.is_combat then
            if self.attack then
                for _ = 1, 2 do
                    table.insert(self.particle, {
                        x = self.x + ran:Float(-180, 180),
                        y = self.y + ran:Float(-180, 180),
                        rot = ran:Float(0, 360),
                        alpha = 0,
                        color = { 250, 128, 114 },
                        scale = ran:Float(0.6, 1) })

                end
            end
            local p
            for i = #self.particle, 1, -1 do
                p = self.particle[i]
                p.x = p.x + (-p.x + self.x) * 0.05
                p.y = p.y + (-p.y + self.y) * 0.05
                p.rot = p.rot + 3
                p.alpha = min(p.alpha + 150 / 15, 150)
                if Dist(p.x, p.y, self.x, self.y) < 1 then
                    table.remove(self.particle, i)
                end
            end
        end

    end
    function sc2:render()
        if self.is_combat then
            for _, s in ipairs(self.particle) do
                SetImageState("white", "mul+add", s.alpha / 2, unpack(s.color))
                Render("white", s.x, s.y, s.rot, s.scale)
                SetImageState("white", "mul+add", s.alpha, unpack(s.color))
                Render("white", s.x, s.y, s.rot, s.scale * 0.6)
            end
        end
    end
end---boss4

do
    boss.Define("5a", "圣白莲", "TH12_1", TH12_bg, { 400, 0 }, class["SCBG5"], "Byakuren", 8)
    boss.Define("5b", "封兽鵺", "TH12_1", TH12_bg, { 0, 400 }, class["SCBG5"], "Nue", 8)
    local name = "立场不明「混沌正邪的冲突」"
    local sc1 = boss.card.New(name, 1, 1, 60, 700)
    local sc2 = boss.card.New(name, 1, 1, 60, 700)
    boss.card.add({ { sc1, "5a" }, { sc2, "5b" } }, 8, name, 82)

    function sc1:before()
        self.lightback = New(class["ByakurenLightBack"], self)
        task.MoveTo(0, 100, 60, 2)
    end
    function sc1:init()
        local b
        local n, w = 8, 7
        local n2 = 30
        local rand = 3
        local wait = 240
        task.New(self, function()
            boss.violent(self)
            n, w = 10, 5
            n2 = 50
            rand = 5
            wait = 120
        end)
        self.shoot = function(self, v, a)
            b = NewSimpleBullet(ball_mid, 6, self.x, self.y, v, a)
            b._blend = "mul+add"
            b.group = GROUP.INDES
        end
        task.New(self, function()
            local com = { -1, 1, -1, 1 }
            local d = 1
            local a
            while true do
                local x, y = player.x, player.y
                for t, p in ipairs(self.lightback:GetFlowerPos()) do
                    a = Angle(p[1], p[2], x, y)
                    for i = 1, n do
                        New(class["laser1-1"], p[1], p[2], a + i * 360 / n, com[t] * d * 120)
                    end
                end
                task.Wait(60)
                for _, p in ipairs(self.lightback:GetFlowerPos()) do
                    a = Angle(p[1], p[2], x, y)
                    for i = 1, n do
                        for v = 1, w do
                            (NewSimpleBullet(ball_big, 14, p[1], p[2],
                                    v * 4.2 / w + ran:Float(-0.2, 0.2),
                                    a + i * 360 / n + ran:Float(-rand, rand)))._blend = "mul+add"
                        end
                    end
                end
                a = Angle(self.x, self.y, x, y)
                for i in sp.math.AngleIterator(a, n2) do
                    self:shoot(2, i)
                    self:shoot(1.6, i)
                    self:shoot(LineNum(i * 7) * 0.15 + 1.8, i)
                end
                d = -d
                task.Wait(wait)
                task.MoveToPlayer(60, -96, 96, 90, 120,
                        20, 40, 16, 32, 2, 1)
            end
        end)
    end

    function sc2:before()
        task.MoveTo(-100, 140, 60, 2)
    end
    function sc2:init()
        local violent
        task.New(self, function()
            boss.violent(self)
            violent = true
            task.Wait(60)
            local d = 1
            while true do
                for i = 20, 360, 20 do
                    New(class["laser1-2"], self.x, self.y, 0, i, 3, 0, d * 2, 80)
                end
                d = -d
                task.Wait(43)
            end
        end)
        task.New(self, function()
            while true do
                task.Wait(90)
                local A = Angle(self, player)
                for i = 20, 360, 20 do
                    New(class["laser1-2"], self.x, self.y, 0, i + A, 2, 0, 9, 6)
                    New(class["laser1-2"], self.x, self.y, 0, i + A, 2, 0, -9, 6)
                end
                Newcharge_in(self.x, self.y, 128, 32, 32)
                boss.cast(self, 180)
                object.BulletDo(function(unit)
                    unit.master = self
                    unit.cao = ran:Int(0, 1)
                    if unit.cao == 1 then
                        Create.bullet_create_eff(unit.x, unit.y, ball_big, 6, nil, nil, true)
                        bullet.ChangeImage(unit, ball_big, 6)
                    end
                    unit.frame_other = function(self)
                        if not IsValid(self.master) then
                            object.Del(self)
                            return
                        end
                        if not self.boom then
                            self.ax = cos(Angle(self, self.master)) * 0.05
                            self.ay = sin(Angle(self, self.master)) * 0.05
                            if self.master.boom then
                                self.boom = true
                                object.SetV(self, Dist(self, self.master) / 30, Angle(self, self.master) + self.cao * 180, true)
                                self.ax, self.ay = 0, 0
                            end
                        end
                        if Dist(self, self.master) < 16 then
                            object.Del(self)
                        end
                    end
                end)
                task.Wait(150)
                if not violent then
                    self.boom = true
                    Newcharge_out(self.x, self.y, 255, 227, 132)
                    local a = ran:Float(0, 360)
                    for i = 20, 360, 20 do
                        New(class["laser1-2"], self.x, self.y, 0, i + a, 3, 90, -2, 50)
                        New(class["laser1-2"], self.x, self.y, 0, i + a, 3, -90, 2, 50)
                        New(class["laser1-2"], self.x, self.y, 0, i + a, 3, 0, 4, 30)
                        New(class["laser1-2"], self.x, self.y, 0, i + a, 3, 0, -4, 30)
                    end
                    task.Wait(60)
                    self.boom = false
                end
                local h, v = 1, 1
                for _ = 1, 11 do
                    self.vscale = v
                    self.hscale = h
                    task.Wait()
                    h = h - 1 / 10
                    v = v + 0.8 / 10
                end
                self.x = -self.x
                task.MoveToPlayer(0, -120, 120, 120, 160, 20, 40, 16, 32, 0, 1)
                h, v = 0, 1.8
                for _ = 1, 11 do
                    self.vscale = v
                    self.hscale = h
                    task.Wait()
                    h = h + 1 / 10
                    v = v - 0.8 / 10
                end
                task.Wait(38)
            end
        end)
    end
end---boss5

do
    boss.Define("6a", "多多良小伞", "TH12_1", TH12_bg, { 0, 300 }, class["SCBG6"], "Kogasa", 8)
    boss.Define("6b", "封兽鵺", "TH12_1", TH12_bg, { 0, 300 }, class["SCBG6"], "Nue", 8)
    local name = "「血バサミ女の観覧车」"
    local circle_table = {}

    local sc_frame = function(self, angle)
        if not self.is_combat then
            return
        end
        boss.card.PublicHP(self)
        local _x = player.x - self.x
        local _y = player.y - self.y
        local _rot = angle
        _x, _y = _x * cos(_rot) + _y * sin(_rot), _y * cos(_rot) - _x * sin(_rot)
        if abs(_y) < 12 then
            self.line_color = { 128, 128, 128 }
        else
            self.line_color = nil
        end
    end
    local sc_render = function(self, color, angle)
        if not self.is_combat then
            return
        end
        local a = 128 * min(self.timer / 90, 1)
        local rot = angle
        SetImageState("white", "mul+add", a / 2, unpack(self.line_color or color))
        Render("white", self.x, self.y, rot, 600 / 8, 0.5)
        Render("white", self.x, self.y, rot, 600 / 8, 1)
    end
    local CreateCircle = function()
        sp:UnitListUpdate(circle_table)
        if #circle_table == 0 then
            local a = ran:Float(0, 360)
            for i = 1, 4 do
                table.insert(circle_table, New(class["object1-1circle"], 0, 0, 90, i * 95 + a, 0.6, 40))
            end
            a = ran:Float(0, 360)
            for i = 1, 6 do
                table.insert(circle_table, New(class["object1-1circle"], 0, 0, 198, i * 60 + a, -0.3, 65))
            end
        end
    end
    local GetCircleData = function(key)
        sp:UnitListUpdate(circle_table)
        return circle_table[key]
    end
    local sc_normal_action = function(self, id, index, condition)
        CreateCircle()
        self.circle = GetCircleData(id)
        self.circle.__r, self.circle.__g, self.circle__b = unpack(self.self_color)
        task.New(self, function()
            boss.cast(self, 3600, true)
            task.Wait(60)
            task.MoveTo(self.circle.x, self.circle.y, 60, 2)
            task.Wait(60)
            while true do
                self.x, self.y = self.circle.x, self.circle.y
                task.Wait()
            end
        end)
        task.New(self, function()
            task.Wait(190)
            while true do
                while not self.line_color do
                    task.Wait()
                end
                local b
                for a = 3, 360, 3 do
                    b = NewSimpleBullet(arrow_big, index, self.x + cos(a) * 40, self.y + sin(a) * 40, 0.5, a, nil, nil, false)
                    b.__a = 255
                    b.colli = false
                    b.condition = condition
                    function b:frame_other()
                        local flag
                        for _, u in ipairs(circle_table) do
                            if IsValid(u) then
                                if Dist(self, u) < u.radius then
                                    flag = true
                                    break
                                end
                            end
                        end
                        flag = self.condition(flag)
                        self.__a = flag and 255 or 20
                        self.colli = flag and true
                        self._a = self._a + (-self._a + self.__a) * 0.1
                    end
                end
                PlaySound("kira00")
                task.Wait(30)
                while self.line_color do
                    task.Wait()
                end

            end
        end)
    end
    local global_action = function()

    end

    local sc1 = boss.card.New(name, 3, 3, 60, 900)
    local sc2 = boss.card.New(name, 3, 3, 60, 900)
    boss.card.add({ { sc1, "6a" }, { sc2, "6b" } }, 8, name, 83)
    function sc1:before()
        self._wisys:SetFloat()
        task.MoveTo(50, 120, 60, 2)
    end
    function sc1:init()
        sc_normal_action(self, 2, 2, function(flag)
            return flag
        end)
        global_action(self, true)
    end
    function sc1:frame()
        sc_frame(self, Angle(self.x, self.y, 0, 224) + self.timer / 2)
    end
    function sc1:render()
        sc_render(self, { 250, 128, 114 }, Angle(self.x, self.y, 0, 224) + self.timer / 2)
    end

    function sc2:before()
        self._wisys:SetFloat()
        task.MoveTo(-50, 120, 60, 2)
    end
    function sc2:init()
        sc_normal_action(self, 4, 10, function(flag)
            return not flag
        end)
        global_action(self, ext.sc_pr)
    end
    function sc2:frame()
        sc_frame(self, Angle(self.x, self.y, 0, -224) - self.timer / 2)
    end
    function sc2:render()
        sc_render(self, { 189, 252, 201 }, Angle(self.x, self.y, 0, -224) - self.timer / 2)
    end
end---boss6