local class = {}
_editor_class.TH16_AEX = class

local beat = 3600 / 160

local SPELL_ID = STAGE_COUNT + 1

local SearchStageLevel = SearchStageLevel
local function BeastDrop(x, y, num, state)
    if SearchStageLevel[11] then
        for _ = 1, num do
            Beast:drop(x, y, state or ran:Int(1, 3))
        end
    end
end
local function UFODrop(x, y, num)
    if SearchStageLevel[6] then
        for _ = 1, num do
            UFO:New(x, y)
        end
    end
end
local function SakuraDrop(x, y, num)
    if SearchStageLevel[1] then
        item.Dropitem(item.obj.sakura, num, x, y)
    end
end
local function AstralDrop(x, y, num, id)
    if SearchStageLevel[7] then
        Astral.drop(x, y, id or 3, num)
    end
end
local function PointDrop(x, y, num)
    item.Dropitem(item.obj.point, num, x, y)
end
local function FaithDrop(x, y, num)
    if SearchStageLevel[4] then
        item.Dropitem(item.obj.faith, num, x, y)
    end
end
local function SeasonDrop(x, y, num)
    if SearchStageLevel[10] then
        for _ = 1, num do
            Season.drop(x, y, nil, nil, ran:Float(0.5, 2), ran:Float(0, 360))
        end
    end
end

local function CardBonusDrop(self)
    item.Dropitem(item.obj.addmisscount, 1, self.x, self.y)
end
local function PassDrop()
    if not ext.sc_pr then
        lstg.var.get_part = lstg.var.get_part + 1
    end
end

do

    class.A1 = Class(enemy, {
        init = function(self, _x, _y, vx, vy, bv)
            enemy.init(self, 1, 10, false, true, false)
            self.x, self.y = _x, _y
            if IsValid(_boss) then
                object.RawDel(self)
            end
            task.New(self, function()
                for i = 1, 60 do
                    self.vx = vx * i / 60
                    self.vy = vy * i / 60
                    task.Wait()
                end
                task.Wait(25)
                for i = 1, 60 do
                    self.vx = vx * (1 - i / 60)
                    self.vy = vy * (1 - i / 60)
                    task.Wait()
                end
                task.Wait(25)
                for i = 1, 60 do
                    self.vx = vx * i / 60
                    self.vy = vy * i / 60
                    task.Wait()
                end
            end)
            task.New(self, function()
                task.Wait(30)
                for _ = 1, 4 do
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 9) do
                        Create.bullet_accel(self.x, self.y, diamond, 2, 0.5, bv, a)
                    end
                    PlaySound("tan00")
                    task.Wait(ran:Int(40, 80))
                end
            end)
        end,
        drop = function(self)
            AstralDrop(self.x, self.y, 2)
            PointDrop(self.x, self.y, 1)
        end
    })
    class.A2 = Class(enemy, {
        init = function(self, _x, _y, x1, y1, x2, y2)
            enemy.init(self, 9, 80, false, true, false)
            self.x, self.y = _x, _y
            if IsValid(_boss) then
                object.RawDel(self)
            end
            task.New(self, function()
                self.protect = true
                task.Wait(40)
                self.protect = false
            end)
            task.New(self, function()
                do
                    local vx, _d_vx = (x1), (-x1 / 79)
                    local vy, _d_vy = (y1), (-y1 / 79)
                    for _ = 1, 80 do
                        self.vx = vx
                        self.vy = vy
                        task.Wait()
                        vx = vx + _d_vx
                        vy = vy + _d_vy
                    end
                end
                task.New(self, function()
                    do
                        for _ = 1, 3 do
                            do
                                local a, _d_a = (Angle(self, player)), (60)
                                for _ = 1, 6 do
                                    do
                                        local rot, _d_rot = (a), (30 / 7)
                                        local v, _d_v = (1), (2 / 7)
                                        for _ = 1, 7 do
                                            Create.bullet_accel(self.x + cos(rot) * 30, self.y + sin(rot) * 30, sakura, 4, 0.5, v, rot)

                                            rot = rot + _d_rot
                                            v = v + _d_v
                                        end
                                    end
                                    do
                                        local rot, _d_rot = (a + 30), (30 / 7)
                                        local v, _d_v = (3), (-2 / 7)
                                        for _ = 1, 7 do
                                            Create.bullet_accel(self.x + cos(rot) * 30, self.y + sin(rot) * 30, sakura, 4, 0.5, v, rot)

                                            rot = rot + _d_rot
                                            v = v + _d_v
                                        end
                                    end

                                    a = a + _d_a
                                end
                                PlaySound("kira00")
                            end
                            task.Wait(180)
                        end
                    end
                end)
                task.Wait(430)
                do
                    local vx, _d_vx = (0), (x2 / 79)
                    local vy, _d_vy = (0), (y2 / 79)
                    for _ = 1, 80 do
                        self.vx = vx
                        self.vy = vy
                        task.Wait()
                        vx = vx + _d_vx
                        vy = vy + _d_vy
                    end
                end
            end)
        end,
        drop = function(self)
            AstralDrop(self.x, self.y, 8)
            SakuraDrop(self.x, self.y, 10)
            UFODrop(self.x, self.y, 1)
            PointDrop(self.x, self.y, 7)
        end
    })

    class.B1 = Class(enemy, {
        init = function(self, _x, _y, x1, y1, x2, y2, d)
            enemy.init(self, 7, 75, false, true, false)
            self.x, self.y = _x, _y
            if IsValid(_boss) then
                object.RawDel(self)
            end
            task.New(self, function()
                do
                    local vx, _d_vx = (x1), (-x1 / 79)
                    local vy, _d_vy = (y1), (-y1 / 79)
                    for _ = 1, 80 do
                        self.vx = vx
                        self.vy = vy
                        task.Wait()
                        vx = vx + _d_vx
                        vy = vy + _d_vy
                    end
                end
                task.New(self, function()
                    do
                        local rot, _d_rot = (Angle(self, player)), (d * 23)
                        for _ = 1, 30 do
                            do
                                local a, _d_a = (rot), (180)
                                for _ = 1, 2 do
                                    local b = NewSimpleBullet(arrow_big_c, 8, self.x + cos(rot) * 30, self.y + sin(rot) * 30, 2, a)
                                    b.ag = 0.02
                                    b.maxv = 2.5
                                    b.navi = true
                                    b._blend = "mul+add"
                                    a = a + _d_a
                                end
                                PlaySound("tan00")
                            end
                            task.Wait(5)
                            rot = rot + _d_rot
                        end
                    end
                end)
                do
                    local vx, _d_vx = (0), (x2 / 79)
                    local vy, _d_vy = (0), (y2 / 79)
                    for _ = 1, 80 do
                        self.vx = vx
                        self.vy = vy
                        task.Wait()
                        vx = vx + _d_vx
                        vy = vy + _d_vy
                    end
                end
            end)
        end,
        drop = function(self)
            AstralDrop(self.x, self.y, 5)
            SeasonDrop(self.x, self.y, 15)
            BeastDrop(self.x, self.y, 1, 1)
            PointDrop(self.x, self.y, 7)
        end
    })
    class.B2 = Class(enemy, {
        init = function(self, _x, _y, vx, vy)
            enemy.init(self, 13, 4, false, true, false)
            self.x, self.y = _x, _y
            if IsValid(_boss) then
                object.RawDel(self)
            end
            self.vx = vx
            self.vy = vy
            task.New(self, function()
                do
                    for _ = 1, 9 do
                        if self.y < -180 then
                            break
                        end
                        Create.bullet_accel(self.x, self.y, ball_mid, 6, 0.5, ran:Float(1, 3), ran:Float(0, 360))
                        PlaySound("tan00")
                        task.Wait(ran:Int(20, 30))
                    end
                end
            end)
        end,
        drop = function(self)
            SeasonDrop(self.x, self.y, 4)
            SakuraDrop(self.x, self.y, 3)
            PointDrop(self.x, self.y, 1)
        end
    })

    class.C1 = Class(enemy, {
        init = function(self, _x, _y, x1, y1, x2, y2)
            enemy.init(self, 16, 5, false, true, false)
            self.x, self.y = _x, _y

            task.New(self, function()
                self.protect = true
                task.Wait(80)
                self.protect = false
            end)
            if IsValid(_boss) then
                object.RawDel(self)
            end
            task.New(self, function()
                do
                    local vx, _d_vx = (x1), (-x1 / 79)
                    local vy, _d_vy = (y1), (-y1 / 79)
                    for _ = 1, 80 do
                        self.vx = vx
                        self.vy = vy
                        task.Wait()
                        vx = vx + _d_vx
                        vy = vy + _d_vy
                    end
                end
                task.New(self, function()
                    for _ = 1, 2 do
                        local a, _d_a = (Angle(self, player)), (18)
                        for _ = 1, 20 do
                            Create.bullet_decel(self.x, self.y, butterfly, 4, 5, 2, a)
                            a = a + _d_a
                        end
                        PlaySound("tan00")
                        task.Wait(90)
                    end
                end)
                task.Wait(60)
                do
                    local vx, _d_vx = (0), (x2 / 79)
                    local vy, _d_vy = (0), (y2 / 79)
                    for _ = 1, 80 do
                        self.vx = vx
                        self.vy = vy
                        task.Wait()
                        vx = vx + _d_vx
                        vy = vy + _d_vy
                    end
                end
            end)
        end,
        drop = function(self)
            SakuraDrop(self.x, self.y, 10)
            PointDrop(self.x, self.y, 5)
        end })

    class.D1 = Class(enemy, {
        init = function(self, _x, _y, mx, my, vx, vy, d)
            enemy.init(self, 17, 250, false, true, false)
            self.x, self.y = _x, _y

            task.New(self, function()
                task.New(self, function()
                    task.Wait(20)
                    do
                        local a, _d_a = (ran:Float(0, 360)), (360 / 14)
                        for _ = 1, 14 do
                            object.Connect(self, New(class.D2, self.x, self.y, a, d), 0.7, true)
                            a = a + _d_a
                        end
                    end
                end)
                task.MoveTo(mx, my, 100, 2)
                task.New(self, function()
                    while true do
                        NewSimpleBullet(ball_huge, 4, self.x, self.y, 3, 0, true)
                        PlaySound("kira00")
                        task.Wait(60)
                    end
                end)
                task.Wait(300)
                do
                    local x, _d_x = (0), (vx / 49)
                    local y, _d_y = (0), (vy / 49)
                    for _ = 1, 50 do
                        self.vx = vx
                        self.vy = vy
                        task.Wait()
                        x = x + _d_x
                        y = y + _d_y
                    end
                end
            end)
        end,
        drop = function(self)
            AstralDrop(self.x, self.y, 6)
            FaithDrop(self.x, self.y, 4)
            PointDrop(self.x, self.y, 12)
        end })
    class.D2 = Class(enemy, {
        init = function(self, _x, _y, a, r)
            enemy.init(self, 29, 30, false, false, true)
            self.x, self.y = _x, _y

            task.New(self, function()
                self.protect = true
                task.Wait()
                self.protect = false
            end)
            task.New(self, function()
                task.New(self, function()
                    do
                        local len, _d_len = (0), (100 / 29)
                        local s, _d_s = (0), (r)
                        while IsValid(self._master) do
                            self.r1 = a + 360 * sin(s)
                            self.x = self._master.x + cos(self.r1) * min(len, 100)
                            self.y = self._master.y + sin(self.r1) * min(len, 100)

                            task.Wait()
                            len = len + _d_len
                            s = s + _d_s
                        end
                        Del(self)
                    end
                end)
                task.New(self, function()
                    task.Wait(80)
                    while true do
                        Create.bullet_decel(self.x, self.y, ball_mid, 6, 6, 1.5, self.r1 + r * 155, true)
                        PlaySound("tan00")
                        task.Wait(6)
                    end
                end)
            end)
        end,
        drop = function(self)
            AstralDrop(self.x, self.y, 2)
            SakuraDrop(self.x, self.y, 1)
            PointDrop(self.x, self.y, 2)
        end
    })
    class.D3 = Class(enemy, {
        init = function(self, _x, _y, vx, vy)
            enemy.init(self, 26, 11, false, true, false)
            self.x, self.y = _x, _y
            if IsValid(_boss) and _boss.ui.drawtime then
                object.RawDel(self)
            end
            self.omiga = ran:Sign() * 8
            task.New(self, function()

                local _vx, _d_vx = (vx), (-vx / 70)
                local _vy, _d_vy = (vy), (-vy / 70)
                for _ = 1, 71 do
                    self.vx = _vx
                    self.vy = _vy
                    task.Wait()
                    _vx = _vx + _d_vx
                    _vy = _vy + _d_vy
                end

                task.New(self, function()

                    local rot, _d_rot = (ran:Float(0, 360)), (sign(self.omiga) * 2)
                    local v, _d_v = (1), (0.2)
                    for _ = 1, 4 do
                        for a in sp.math.AngleIterator(rot, 7) do
                            NewSimpleBullet(ball_big, 4, self.x, self.y, v, a)
                        end
                        PlaySound("tan00")
                        task.Wait(5)
                        rot = rot + _d_rot
                        v = v + _d_v
                    end

                end)
                task.Wait(60)
                local A = Angle(self, player)
                do
                    local v, _d_v = (0), (4 / 139)
                    for _ = 1, 140 do
                        object.SetV(self, v, A)
                        task.Wait()
                        v = v + _d_v
                    end
                end
            end)
        end,
        drop = function(self)
            AstralDrop(self.x, self.y, 1)
            SeasonDrop(self.x, self.y, 9)
            PointDrop(self.x, self.y, 5)
        end
    })
    class.D4 = Class(enemy, {
        init = function(self, _x, _y, x1, y1, x2, y2)
            enemy.init(self, 14, 160, false, true, true)
            self.x, self.y = _x, _y

            task.New(self, function()
                self.protect = true
                task.Wait(30)
                self.protect = false
            end)
            task.New(self, function()
                self.vx = x1
                self.vy = y1
                do
                    local a, _d_a = (x1), (-x1 / 99)
                    local b, _d_b = (y1), (-y1 / 99)
                    for _ = 1, 100 do
                        self.vx = a
                        self.vy = b
                        task.Wait()
                        a = a + _d_a
                        b = b + _d_b
                    end
                end
                local x = 0
                local y = 0
                do
                    local ra, _d_ra = (ran:Float(0, 360)), (360 * 4 / 89)
                    local len, _d_len = (0), (75 / 59)
                    for _ = 1, 60 do
                        local a, _d_a = (0), (120)
                        for _ = 1, 3 do
                            Create.bullet_decel(self.x + cos(ra) * len, self.y + sin(ra) * len,
                                    arrow_small, 4, 6, 1.5, a + Angle(self, player))
                            a = a + _d_a
                        end
                        PlaySound("tan00")
                        x = cos(ra) * len
                        y = sin(ra) * len
                        task.Wait()
                        ra = ra + _d_ra
                        len = len + _d_len
                    end
                end
                do
                    local a, _d_a = (ran:Float(0, 360)), (360 / 25)
                    for _ = 1, 25 do
                        local v, _d_v = (0.5), (0.5)
                        for _ = 1, 2 do
                            Create.bullet_decel(self.x + x, self.y + y, ball_mid, 12, 6, v, a)

                            v = v + _d_v
                        end
                        a = a + _d_a
                    end
                end
                PlaySound("tan00")
                task.Wait(40)
                do
                    local a, _d_a = (0), (x2 / 29)
                    local b, _d_b = (0), (y2 / 29)
                    for _ = 1, 30 do
                        self.vx = a
                        self.vy = b
                        task.Wait()
                        a = a + _d_a
                        b = b + _d_b
                    end
                end
            end)
        end,
        drop = function(self)
            AstralDrop(self.x, self.y, 5)
            FaithDrop(self.x, self.y, 3)
            UFODrop(self.x, self.y, 1)
            BeastDrop(self.x, self.y, 1)
            PointDrop(self.x, self.y, 12)
        end
    })
    class.D5 = Class(enemy, {
        init = function(self, _x, _y, x1, y1, x2, y2, d)
            enemy.init(self, 9, 500, false, true, false)
            self.x, self.y = _x, _y
            task.New(self, function()
                do
                    local vx, _d_vx = (x1), (-x1 / 99)
                    local vy, _d_vy = (y1), (-y1 / 99)
                    for _ = 1, 100 do
                        self.vx = vx
                        self.vy = vy
                        task.Wait()
                        vx = vx + _d_vx
                        vy = vy + _d_vy
                    end
                end
                task.New(self, function()
                    do
                        local rot, _d_rot = (0), (13 * d)
                        for _ = 1, 50 do
                            local a, _d_a = (0), (30)
                            for _ = 1, 12 do
                                Create.bullet_accel(self.x + cos(a) * 30, self.y + sin(a) * 30, sakura, 4, 0.5, 3, a + rot)
                                a = a + _d_a
                            end
                            PlaySound("tan00")
                            task.Wait(10)
                            rot = rot + _d_rot
                        end
                    end
                end)
                task.Wait(430)
                do
                    local vx, _d_vx = (0), (x2 / 79)
                    local vy, _d_vy = (0), (y2 / 79)
                    for _ = 1, 80 do
                        self.vx = vx
                        self.vy = vy
                        task.Wait()
                        vx = vx + _d_vx
                        vy = vy + _d_vy
                    end
                end
            end)
        end,
        drop = function(self)
            AstralDrop(self.x, self.y, 20)
            UFODrop(self.x, self.y, 1)
            BeastDrop(self.x, self.y, 1)
            PointDrop(self.x, self.y, 10)
        end
    })

    class.E1 = Class(enemy, {
        init = function(self, _x, _y, vx, vy)
            enemy.init(self, 31, 10, false, true, false)
            self.x, self.y = _x, _y

            task.New(self, function()
                do
                    local _vx, _d_vx = (0), (vx / 59)
                    local _vy, _d_vy = (0), (vy / 59)
                    for _ = 1, 60 do
                        self.vx = _vx
                        self.vy = _vy
                        task.Wait()
                        _vx = _vx + _d_vx
                        _vy = _vy + _d_vy
                    end
                end
            end)
            task.New(self, function()
                task.Wait(ran:Int(10, 20))
                while true do
                    Create.bullet_decel(self.x, self.y, grain_a, 2, 6, ran:Float(0.5, 1.2),
                            -90 + ran:Float(-1, 1), true, false)
                    PlaySound("tan00")
                    task.Wait(20)
                end
            end)
        end,

        drop = function(self)

            SakuraDrop(self.x, self.y, 2)
            PointDrop(self.x, self.y, 2)
        end
    })
    class.E2 = Class(enemy, {
        init = function(self, _x, _y, vx, vy)
            enemy.init(self, 18, 60, false, false, false)
            self.x, self.y = _x, _y

            task.New(self, function()
                self.protect = true
                task.Wait()
                self.protect = false
            end)
            self.vx = vx
            self.vy = vy
            task.New(self, function()
                do
                    while true do
                        if self.y < -300 then
                            object.Del(self)
                        end
                        task.Wait()
                    end
                end
            end)
            task.New(self, function()
                for _ = 1, 8 do
                    NewSimpleBullet(ball_mid, 2, self.x, self.y, 1.2, 0, true)
                    PlaySound("tan00")
                    task.Wait(60)
                end
            end)
        end,
        drop = function(self)
            AstralDrop(self.x, self.y, 5)
            FaithDrop(self.x, self.y, 1)
        end })
    class.E3 = Class(enemy, {
        init = function(self, _x, _y, x1, y1, x2, y2)
            enemy.init(self, 25, 10, false, true, false)
            self.x, self.y = _x, _y
            if IsValid(_boss) and _boss.ui.drawtime then
                object.RawDel(self)
            end
            self.omiga = ran:Sign() * 8
            task.New(self, function()
                do
                    local vx, _d_vx = (x1), (-x1 / 79)
                    local vy, _d_vy = (y1), (-y1 / 79)
                    for _ = 1, 80 do
                        self.vx = vx
                        self.vy = vy
                        task.Wait()
                        vx = vx + _d_vx
                        vy = vy + _d_vy
                    end
                end
                task.Wait(60)
                do
                    local vx, _d_vx = (0), (x2 / 79)
                    local vy, _d_vy = (0), (y2 / 79)
                    for _ = 1, 80 do
                        self.vx = vx
                        self.vy = vy
                        task.Wait()
                        vx = vx + _d_vx
                        vy = vy + _d_vy
                    end
                end
            end)
        end,

        drop = function(self)
            AstralDrop(self.x, self.y, 2)
            PointDrop(self.x, self.y, 10)
        end,
        kill = function(self)
            self.class.base.kill(self)

            for a in sp.math.AngleIterator(Angle(self, player), 6) do
                for v = 1, 4 do
                    NewSimpleBullet(ball_mid_c, 12, self.x, self.y, 1 + v * 0.3, a)
                end
                PlaySound("tan00")
            end

        end
    })

    class.F1 = Class(enemy, { init = function(self, _x, _y, x1, y1, x2, y2)
        enemy.init(self, 5, 10, false, true, false)
        self.x, self.y = _x, _y

        task.New(self, function()
            self.protect = true
            task.Wait(50)
            self.protect = false
        end)
        if IsValid(_boss) then
            object.Del(self)
        end
        task.New(self, function()
            task.New(self, function()
                task.Wait(10)
                while true do
                    Create.bullet_decel(self.x, self.y, ball_mid, 2, 7, ran:Float(1, 3), ran:Float(0, 360))
                    PlaySound("tan00")
                    task.Wait(4)
                end
            end)
            do
                local vx, _d_vx = (x1), (-x1 / 79)
                local vy, _d_vy = (y1), (-y1 / 79)
                for _ = 1, 80 do
                    self.vx = vx
                    self.vy = vy
                    task.Wait()
                    vx = vx + _d_vx
                    vy = vy + _d_vy
                end
            end
            task.Wait(60)
            do
                local vx, _d_vx = (0), (x2 / 79)
                local vy, _d_vy = (0), (y2 / 79)
                for _ = 1, 80 do
                    self.vx = vx
                    self.vy = vy
                    task.Wait()
                    vx = vx + _d_vx
                    vy = vy + _d_vy
                end
            end
        end)
    end })
    class.G1 = Class(enemy, {
        init = function(self, x, y, a, r, da, time, delay)
            enemy.init(self, 31, 7)
            self.x, self.y = x + cos(a) * r, y + sin(a) * r
            self.bound = false
            if IsValid(_boss) then
                object.RawDel(self)
            end
            local A = a
            task.New(self, function()
                for i = 1, time do
                    A = a + da * i / time
                    self.x, self.y = x + cos(A) * r, y + sin(A) * r
                    task.Wait()
                end
                object.RawDel(self)
            end)
            task.New(self, function()
                task.Wait(delay)
                while true do
                    NewSimpleBullet(sakura, 2, self.x, self.y, 1, A)
                    PlaySound("tan00", 0.05, 0, true)
                    task.Wait(28)
                end
            end)
        end,
        drop = function(self)
            item.Dropitem(item.obj.point, 1, self.x, self.y)
            SakuraDrop(self.x, self.y + 25, 1)
        end
    })

    class.H1 = Class(enemy, {
        init = function(self, _x, _y, vx, vy, A)
            enemy.init(self, 32, 10, false, true, false)
            self.x, self.y = _x, _y
            self.vx, self.vy = vx, vy
            task.New(self, function()
                task.Wait(ran:Int(0, 90))
                local w = lstg.world
                while true do
                    if BoxCheck(self, w.l, w.r, w.b, w.t) then
                        Create.bullet_accel(self.x, self.y, ball_mid_c, 6, 0.5, ran:Float(2, 3), A, true, false)
                        PlaySound("tan00")
                    end
                    task.Wait(90)
                end
            end)
        end,
        drop = function(self)

            SakuraDrop(self.x, self.y, 1)
            PointDrop(self.x, self.y, 1)
        end
    })
    class.H2 = Class(enemy, {
        init = function(self, _x, _y, x1, y1, x2, y2, D)
            enemy.init(self, 14, 175, false, true, false)
            self.x, self.y = _x, _y
            if IsValid(_boss) then
                object.RawDel(self)
            end
            task.New(self, function()
                self.protect = true
                task.Wait(40)
                self.protect = false
            end)
            task.New(self, function()
                do
                    local vx, _d_vx = (x1), (-x1 / 89)
                    local vy, _d_vy = (y1), (-y1 / 89)
                    for _ = 1, 90 do
                        self.vx = vx
                        self.vy = vy
                        task.Wait()
                        vx = vx + _d_vx
                        vy = vy + _d_vy
                    end
                end
                task.New(self, function()
                    local d = D
                    for _ = 1, 4 do
                        local rot = ran:Float(0, 360)
                        for k = 1, 7 do
                            for a in sp.math.AngleIterator(rot, 15) do
                                Create.bullet_decel(self.x, self.y, arrow_big, 14, 4, 2 - k / 7 * 0.5, a, true, false)
                            end

                            PlaySound("tan00")
                            rot = rot + d * 3
                            task.Wait(5)
                        end
                        for a in sp.math.AngleIterator(rot, 20) do
                            Create.bullet_decel(self.x, self.y, ball_big, 13, 4, 2, a, true, false)
                        end
                        PlaySound("tan00")
                        d = -d
                        task.Wait(90 - 35)
                    end
                end)
                task.Wait(150)
                do
                    local vx, _d_vx = (0), (x2 / 79)
                    local vy, _d_vy = (0), (y2 / 79)
                    for _ = 1, 80 do
                        self.vx = vx
                        self.vy = vy
                        task.Wait()
                        vx = vx + _d_vx
                        vy = vy + _d_vy
                    end
                end
            end)
        end,
        drop = function(self)
            AstralDrop(self.x, self.y, 25)
            SakuraDrop(self.x, self.y, 15)
            FaithDrop(self.x, self.y, 7)
        end
    })
    class.H3 = Class(enemy, {
        init = function(self, _x, _y, x1, y1, x2, y2)
            enemy.init(self, 14, 175, false, true, false)
            self.x, self.y = _x, _y
            if IsValid(_boss) then
                object.RawDel(self)
            end
            task.New(self, function()
                self.protect = true
                task.Wait(40)
                self.protect = false
            end)
            task.New(self, function()
                task.New(self, function()
                    task.init_left_wait(self)
                    for _ = 1, 16 do
                        local x, y = self.x + ran:Float(-30, 30), self.y + ran:Float(-30, 30)
                        for a in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                            Create.bullet_accel(x, y, ellipse, 2, 1, 4, a, false, false)
                        end
                        PlaySound("tan00")
                        task.Wait2(self, beat)
                    end
                end)
                do
                    local vx, _d_vx = (x1), (-x1 / 89)
                    local vy, _d_vy = (y1), (-y1 / 89)
                    for _ = 1, 90 do
                        self.vx = vx
                        self.vy = vy
                        task.Wait()
                        vx = vx + _d_vx
                        vy = vy + _d_vy
                    end
                end

                task.Wait(150)
                do
                    local vx, _d_vx = (0), (x2 / 79)
                    local vy, _d_vy = (0), (y2 / 79)
                    for _ = 1, 80 do
                        self.vx = vx
                        self.vy = vy
                        task.Wait()
                        vx = vx + _d_vx
                        vy = vy + _d_vy
                    end
                end
            end)
        end,
        drop = function(self)
            AstralDrop(self.x, self.y, 15)
            SakuraDrop(self.x, self.y, 15)
            FaithDrop(self.x, self.y, 7)
        end
    })
end --enemy

do
    boss.Define("1a", "雾雨魔理沙", "TH16_AEX_0", TH16_AEX_bg,
            { -240, 384 }, _editor_class.TH08.SCBG3, "Marisa", SPELL_ID)

    local name = "恋符「樱花喷射」"
    local sc = boss.card.New(name, 1, 2, 20, 800)
    boss.card.add({ { sc, "1a" } }, SPELL_ID, name, 221, nil, true)
    function sc:before()
        boss.show_aura(self, false)
        task.MoveTo(0, 120, 120, 2)
        boss.show_aura(self, true)
        task.Wait(60)
    end
    function sc:init()
        local function warning(_x, _y, a)
            local self = NewObject(laser)
            laser.init(self, 4, _x, _y, 0, 160, 400, 64, 300, 0, 0)
            self.rot = a
            self.group = GROUP.INDES
            task.New(self, function()
                laser._TurnHalfOn(self, 60, true)
                task.Wait(200)
                object.Del(self)
            end)
        end
        local function star(_x, _y, col, rot, d, A)
            local self = NewObject(bullet)
            bullet.init(self, star_big, col, false, true)
            self.x, self.y = _x, _y
            self.rot = ran:Float(0, 360)
            self.omiga = ran:Float(4, 6) * d
            object.SetSizeColli(self, 1.3)
            task.New(self, function()
                do
                    local a, _d_a = (rot), (-d)
                    local rx, _d_rx = (0), (1)
                    local ls, _d_ls = (0), (4)
                    while IsValid(self._master) do
                        local x0 = cos(a) * sin(min(rx, 90)) * (sin(min(90, ls)) * 220)
                        local y0 = sin(a) * 30
                        self.x = self._master.x + x0 * cos(A + 90) - y0 * sin(A + 90)
                        self.y = self._master.y + x0 * sin(A + 90) + y0 * cos(A + 90)
                        if a % 360 > 0 and a % 360 < 180 then
                            _object.set_color(self, "", 255, 255, 255, 255)
                            self.colli = true
                            self.layer = LAYER.ENEMY_BULLET + 1

                        end
                        if a % 360 > 180 and a % 360 < 360 then
                            _object.set_color(self, "", 120, 255, 255, 255)
                            self.colli = false
                            self.layer = LAYER.ENEMY - 1
                        end
                        task.Wait()
                        a = a + _d_a
                        rx = rx + _d_rx
                        ls = ls + _d_ls
                    end
                end
            end)
            task.New(self, function()
                while true do
                    if self.x > 192 or self.x < -192 then
                        Create.bullet_accel(self.x, self.y, ball_mid, self._index,
                                0.5, ran:Float(0.6, 2.2), 90 * sign(self.x) + 90 + ran:Float(-90, 90))
                        break
                    end
                    if self.y > 224 or self.y < -224 then
                        Create.bullet_accel(self.x, self.y, ball_mid, self._index,
                                0.5, ran:Float(0.6, 2.2), -90 * sign(self.y) + ran:Float(-90, 90))

                        break
                    end
                    task.Wait()
                end
            end)
            return self

        end
        local function star_center(_x, _y, col, a)
            local self = NewObject(bullet)
            bullet.init(self, ball_light, col, true, true)
            self.x, self.y = _x, _y
            self.hide = true
            self.bound = false
            local d = ran:Sign()
            object.SetV(self, 1.2, a)
            object.SetA(self, 0.1, a, false)
            self.maxv = ran:Float(7, 9)
            task.New(self, function()
                for A in sp.math.AngleIterator(ran:Float(0, 360), 19) do
                    object.Connect(self, star(self.x, self.y, col, A, d, a), 0, true)

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
        end
        local function spark(x, y, a)
            local self = NewObject(bullet)
            bullet.init(self, ball_light, 4, true, true)
            self.x, self.y = x, y
            self._blend = "mul+add"
            self.fogtime = 0
            self.navi = true
            object.SetV(self, ran:Float(0.8, 1.8), a + ran:Float(-90, 90), true)
            object.SetA(self, 0.11, a, false)
            self.maxv = ran:Float(7, 9)
        end
        task.New(self, function()
            task.init_left_wait(self)
            task.Wait2(self, beat * 4)
            while true do
                local A = Angle(self, player)
                Newcharge_in(self.x, self.y, 250, 128, 114)
                warning(self.x, self.y, A)
                task.Wait2(self, beat * 4)
                boss.cast(self, 240)
                PlaySound("nep00", 1, self.x, false)
                local t = int(beat * 6)
                misc.ShakeScreen(t, 2)
                task.New(self, function()
                    for _ = 1, 9 do
                        star_center(self.x, self.y, ran:Int(1, 8) * 2, A)
                        PlaySound("tan00")
                        task.Wait(t / 9)
                    end
                end)
                for _ = 1, t do
                    for _ = 1, 10 do
                        spark(self.x + cos(A) * 20, self.y + sin(A) * 20, A)
                    end
                    task.Wait()
                end
                task.MoveToPlayer(60, -150, 150, 50, 120,
                        60, 120, 40, 80, 2, 1)
                task.Wait2(self, beat * 6 - 60)
            end
        end)
    end
    function sc:del()
        if IsValid(lstg.tmpvar.shaker) then
            object.Del(lstg.tmpvar.shaker)
        end
    end
    sc.other_bonus_drop = CardBonusDrop
end--魔理沙

do
    boss.Define("2a", "博丽灵梦", "TH16_AEX_0", TH16_AEX_bg,
            { 240, 384 }, _editor_class.TH08.SCBG3, "Reimu", SPELL_ID)

    local name = "结界「轻樱勾勒」"
    local sc = boss.card.New(name, 1, 2, 20, 900)
    boss.card.add({ { sc, "2a" } }, SPELL_ID, name, 222, nil, true)
    function sc:before()
        boss.show_aura(self, false)
        task.MoveTo(0, 120, 120, 2)
        boss.show_aura(self, true)
        task.Wait(60)
    end
    function sc:init()
        local function arrow(_x, _y, v, a)
            local self = NewObject(bullet)
            bullet.init(self, knife_b, 4, true, true)
            self.x, self.y = _x, _y
            PlaySound("tan00")
            self.flag = 1
            object.SetV(self, v, a, true)
            task.New(self, function()
                while true do
                    if self.flag > 0 then

                        if self.x > 192 or self.x < -192 then
                            self.flag = 0
                            self.x = 384 * sign(self.x) - self.x
                            object.SetV(self, v, 180 - self.rot, true)
                        end
                        if self.y > 224 or self.y < -224 then
                            self.flag = 0
                            self.y = 448 * sign(self.y) - self.y
                            object.SetV(self, v, -self.rot, true)
                        end
                    else
                        if self.x > 192 or self.x < -192 then
                            if ran:Int(1, 12) == 1 then
                                PlaySound("kira00")
                                Create.bullet_accel(self.x, self.y, ball_mid, self._index, 0.5, ran:Float(0.6, 2.2),
                                        90 * sign(self.x) + 90 + ran:Float(-90, 90))
                            end
                            break
                        end
                        if self.y > 224 or self.y < -224 then
                            if ran:Int(1, 12) == 1 then
                                PlaySound("kira00")
                                Create.bullet_accel(self.x, self.y, ball_mid, self._index, 0.5, ran:Float(0.6, 2.2),
                                        -90 * sign(self.y) + ran:Float(-90, 90))
                            end
                            break
                        end
                    end
                    task.Wait()
                end
            end)
        end
        task.New(self, function()
            task.init_left_wait(self)

            local t, _d_t = (0.8), (0.3)
            while true do
                Newcharge_in(self.x, self.y, 250, 128, 114)
                task.Wait2(self, beat * 4)
                boss.cast(self, 240)
                local A = Angle(self, player) + 90
                local s, _d_s = (0), (t)
                for _ = 1, beat * 8 do
                    local a, _d_a = (-10 - 60 + A), (10)
                    for _ = 1, 3 do
                        arrow(self.x, self.y, 15, a + sin(s) * 10)
                        a = a + _d_a
                    end
                    a, _d_a = (-10 + 240 + A), (10)
                    for _ = 1, 3 do
                        arrow(self.x, self.y, 15, a - sin(s) * 10)
                        a = a + _d_a
                    end
                    task.Wait()
                    s = s + _d_s
                end
                task.New(self, function()
                    task.MoveToPlayer(60, -150, 150, 50, 120,
                            60, 120, 40, 80, 2, 1)
                end)
                task.Wait2(self, beat * 4)
                t = t + _d_t
            end

        end)
    end
    sc.other_bonus_drop = CardBonusDrop
end--灵梦

do
    boss.Define("3a", "十六夜咲夜", "TH16_AEX_0", TH16_AEX_bg,
            { 400, 0 }, _editor_class.TH06.SCBG3, "Sakuya", SPELL_ID)

    local function bomb_bullet(_x, _y, v, a)
        local self = NewObject(bullet)
        bullet.init(self, ball_huge, 2, false, true)
        self.x, self.y = _x, _y
        PlaySound("tan00")
        self.omiga = 4
        task.New(self, function()
            object.ChangingV(self, v, 0, a, 80)
            for A in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                Create.bullet_accel(self.x, self.y, knife, 2, 0.5, 3, A)
            end
            PlaySound("kira00")
            NewBon(self.x, self.y, 60, 128, 250, 128, 114)
            NewWave(self.x, self.y, 2, 70, 60, 250, 128, 114)
            object.Del(self)

        end)
    end

    local non_sc1 = boss.card.New("", 1, 4, 19, 750)
    boss.card.add({ { non_sc1, "3a" } }, SPELL_ID, "一非", 223, nil, true)
    function non_sc1:before()
        if ext.sc_pr then
            task.MoveTo(0, 120, 60, 2)
        else

            boss.show_aura(self, false)
            task.MoveTo(0, 120, 120, 2)
            boss.show_aura(self, true)
            task.Wait(60)
        end
    end
    function non_sc1:init()
        task.New(self, function()
            Newcharge_in(self.x, self.y, 128, 255, 128)
            task.Wait(60)
            task.New(self, function()
                while true do
                    task.MoveToPlayer(70, -120, 120, 100, 144,
                            30, 40, 20, 40, 2, 1)
                    task.Wait(100)
                end
            end)
            task.New(self, function()
                task.Wait(60)
                while true do
                    local a, _d_a = (Angle(self, player)), (120)
                    for _ = 1, 3 do
                        bomb_bullet(self.x, self.y, 4, a)
                        a = a + _d_a
                    end
                    task.Wait(60)

                end
            end)

            local rot1, _d_rot1 = (Angle(self, player) + 45), (11)
            while true do
                local a, _d_a = (0), (90)
                for _ = 1, 4 do
                    local a1, _d_a1 = (a - 2), (4 / 4)
                    for _ = 1, 5 do
                        NewSimpleBullet(arrow_small, 4, self.x + cos(a) * 15, self.y + sin(a) * 15, 2, a1 + rot1)
                        a1 = a1 + _d_a1
                    end
                    a = a + _d_a
                end
                PlaySound("tan00", 0.1, 0, false)
                task.Wait(13)
                rot1 = rot1 + _d_rot1
            end
        end)
    end
    non_sc1.other_drop = PassDrop

    local non_sc2 = boss.card.New("", 1, 4, 20, 800)
    boss.card.add({ { non_sc2, "3a" } }, SPELL_ID, "二非", 224, nil, true)
    function non_sc2:before()
        task.MoveTo(0, 120, 60, 2)
    end
    function non_sc2:init()
        task.New(self, function()
            Newcharge_in(self.x, self.y, 128, 255, 128)
            task.Wait(60)
            task.New(self, function()
                while true do
                    task.MoveToPlayer(70, -120, 120, 100, 144,
                            30, 40, 20, 40, 2, 1)
                    task.Wait(100)
                end
            end)
            task.New(self, function()
                task.Wait(60)
                local rot, _d_rot = (ran:Float(0, 360)), (-13)
                while true do
                    local a, _d_a = (rot), (180)
                    for _ = 1, 2 do
                        bomb_bullet(self.x, self.y, 3, a)
                        a = a + _d_a
                    end
                    task.Wait(25)
                    rot = rot + _d_rot
                end

            end)
            while true do
                local a, _d_a = (Angle(self, player)), (30)
                for _ = 1, 12 do
                    local v, _d_v = (2), (0.2)
                    local l, _d_l = (50), (-50 / 9)
                    for _ = 1, 10 do
                        Create.bullet_accel(self.x + cos(a) * -l, self.y + sin(a) * -l,
                                sakura, 4, 0.5, v, a, true, false)
                        v = v + _d_v
                        l = l + _d_l
                    end
                    a = a + _d_a
                end
                task.Wait(120)
            end
        end)
    end
    non_sc2.other_drop = PassDrop

    local name = "幻世「樱花将死刻」"
    local sc = boss.card.New(name, 1, 2, 30, 900)
    boss.card.add({ { sc, "3a" } }, SPELL_ID, name, 225, nil, true)
    function sc:before()
        if ext.sc_pr then
            task.MoveTo(0, 50, 90, 2)
        else

            task.Wait(40)
            self.ui.drawtime = false
            self.ui.drawpointer = false
            self.ui.drawname = false
            task.MoveTo(0, 400, 60, 2)
            while self.ani <= beat * 128 - 180 do
                task.Wait()
            end
            object.BulletDo(function(b)
                object.Kill(b)
            end)
            object.EnemyDo(function(b)
                if b ~= self then
                    object.Kill(b)
                end
            end)
            self.ui.drawtime = true
            self.ui.drawpointer = true
            self.ui.drawname = true
            task.MoveTo(0, 50, 120, 2)
            Newcharge_in(0, 50, 250, 128, 114)
            task.Wait(60)
        end

    end
    function sc:init()
        local function knifetoPlayer(_x, _y, col, v, a, d)
            local self = NewObject(bullet)
            bullet.init(self, knife, col, true, true)
            self.x, self.y = _x, _y
            PlaySound("tan00", 0.05)
            object.SetV(self, v, a, true)
            if col == 2 then
                if player.name == "Reimu" or player.name == "Chiruno" then
                    self.colli = false
                    self._a = 80
                end
            end
            if col == 13 then
                if player.name == "Marisa" or player.name == "Aya" then
                    self.colli = false
                    self._a = 80
                end
            end
            task.New(self, function()
                while true do
                    object.SetV(self, v, self.rot + 0.4 * d, true)
                    task.Wait()
                end
            end)
        end
        task.New(self, function()
            NewSimpleServant(self.x, self.y, 0, 250, 250, 250, 1.5, function(self)
                task.New(self, function()
                    self:FadeIn(15)
                    object.ChangingSizeColli(self, -0.5, -0.5, 15)
                end)
                task.New(self, function()
                    task.Wait(60)
                    local d = 1
                    while true do
                        local A, _d_A = (ran:Float(0, 360)), (-d)
                        for k = 1, 20 do
                            local v = 3 - k / 20
                            for a in sp.math.AngleIterator(A, 27) do
                                knifetoPlayer(self.x, self.y, 2, v, a, d)
                            end
                            for a in sp.math.AngleIterator(A, 27) do
                                knifetoPlayer(self.x, self.y, 13, v, a, -d)
                            end
                            task.Wait(10)
                            A = A + _d_A
                        end
                        d = -d
                    end
                end)
            end)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            task.New(self, function()
                local d = -1
                while true do
                    local rot, _d_rot = (ran:Float(0, 360)), (13 * d)
                    for _ = 1, 15 do
                        for a in sp.math.AngleIterator(0, 9) do
                            Create.bullet_accel(self.x + cos(a) * 30, self.y + sin(a) * 30, ball_mid, 4, 0.5, 2.5, a + rot)
                        end
                        PlaySound("kira00")
                        task.Wait(4)
                        rot = rot + _d_rot
                    end
                    d = -d
                    task.MoveToPlayer(70, -120, 120, 40, 70,
                            20, 40, 10, 20, 2, 1)
                    task.Wait(70)
                end
            end)
        end)
    end
    sc.other_bonus_drop = CardBonusDrop
    sc.other_drop = PassDrop
end--十六夜咲夜

do
    boss.Define("4a", "高丽野阿吽", "TH16_AEX_0", TH16_AEX_bg,
            { 300, 300 }, _editor_class.TH16.SCBG1, "Aunn", SPELL_ID)

    local name = "犬符「狛犬的螺旋纹」"
    local sc = boss.card.New(name, 2, 4, 35, 750)
    boss.card.add({ { sc, "4a" } }, SPELL_ID, name, 226, nil, true)
    function sc:before()
        boss.show_aura(self, false)
        task.MoveTo(0, 120, 90, 2)
        boss.show_aura(self, true)
        task.Wait(60)
    end
    function sc:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 128, 252, 128)
            task.Wait(60)
            local shoot_laser = Class(bent_laser, {
                init = function(self, _x, _y, a1, r1, r2)
                    bent_laser.init(self, 4, _x, _y, 128, 10, 4, 7)
                    PlaySound("lazer00")
                    object.SetV(self, 3, a1, true)
                    task.New(self, function()
                        local a, _d_a = (self.rot), (r1)
                        local v, _d_v = (3), (-1 / 109)
                        for _ = 1, 110 do
                            object.SetV(self, v, a, true)
                            task.Wait()
                            a = a + _d_a
                            v = v + _d_v
                        end
                        v, _d_v = (2), (2 / 89)
                        a, _d_a = (self.rot), (r2)
                        for _ = 1, 90 do
                            object.SetV(self, v, a, true)
                            task.Wait()
                            v = v + _d_v
                            a = a + _d_a
                        end
                        a, _d_a = (self.rot), (-r2 / 5)
                        for _ = 1, 120 do
                            object.SetV(self, 4, a, true)
                            task.Wait()
                            a = a + _d_a
                        end
                    end)
                end }, true)
            task.New(self, function()
                task.Wait(120)
                task.New(self, function()
                    while true do
                        for a in sp.math.AngleIterator(-90, 35) do
                            Create.bullet_decel(self.x + cos(a) * 50, self.y + sin(a) * 50,
                                    ball_mid, 2, 7, 2, a, true)
                        end
                        PlaySound("tan00")
                        task.Wait(60)
                    end
                end)
                local a, _d_a = (ran:Float(0, 360)), (79)
                local s, _d_s = (0), (2)
                while true do
                    Create.bullet_decel(self.x + cos(a) * sin(s) * 50, self.y + sin(a) * sin(s) * 50,
                            ball_mid, 14, 7, 2, a, true)
                    task.Wait(2)
                    PlaySound("tan00")
                    a = a + _d_a
                    s = s + _d_s
                end
            end)

            while true do
                local A = Angle(self, player) + 45
                local pl, _d_pl = (50), (-100 / 4)
                local r1, _d_r1 = (-3), (1 / 4)
                local r2, _d_r2 = (7), (-2 / 4)
                for _ = 1, 5 do
                    New(shoot_laser, self.x + cos(A) * pl, self.y + sin(A) * pl, A + 90, r1, r2)

                    pl = pl + _d_pl
                    r1 = r1 + _d_r1
                    r2 = r2 + _d_r2
                end
                A = Angle(self, player) - 45
                pl, _d_pl = (50), (-100 / 4)
                r1, _d_r1 = (3), (-1 / 4)
                r2, _d_r2 = (-7), (2 / 4)
                for _ = 1, 5 do
                    New(shoot_laser, self.x + cos(A) * pl, self.y + sin(A) * pl, A - 90, r1, r2)
                    pl = pl + _d_pl
                    r1 = r1 + _d_r1
                    r2 = r2 + _d_r2
                end
                task.Wait(60)
                task.MoveToPlayer(60, -120, 120, 90, 144,
                        20, 40, 16, 32, 2, 1)
                task.Wait()
                boss.cast(self, 42 * 60)
                task.Wait(60)
            end

        end)

    end
    sc.other_bonus_drop = CardBonusDrop
end--高丽野阿吽

LoadAniFromFile("Bird", "mod\\th16AEX\\bird.png", nil, 3, 1, 5, 4, 4)
do
    local card_start = function()
        task.MoveTo(0, 120, 60, 2)

    end
    local Heart_obj = function(master, _x, _y, col, rot, d, cr, acr, t, bv, xl, yl)
        local self = NewObject(bullet)
        bullet.init(self, heart, col, false, false)
        self.x, self.y = _x, _y
        self.bound = false
        PlaySound("kira00", 1, self.x, false)
        self.master = master
        task.New(self, function()
            local a, _d_a = (rot), (d)
            local rx, _d_rx = (0), (1)
            local r, _d_r = (cr), (acr)
            while IsValid(self.master) do
                local x0 = cos(a) * sin(min(rx, 90)) * xl
                local y0 = sin(a) * yl
                self.x = self.master.x + x0 * cos(r) - y0 * sin(r)
                self.y = self.master.y + x0 * sin(r) + y0 * cos(r)
                self.rot = a + 180
                task.Wait()
                a = a + _d_a
                rx = rx + _d_rx
                r = r + _d_r
            end

        end)
        task.New(self, function()
            local sty = { grain_a, arrow_big }
            local k = 1
            while true do
                Create.bullet_accel(self.x, self.y, sty[k % 2 + 1], col, 0.5, bv, self.rot, true)
                PlaySound("tan00")
                k = k + 1
                task.Wait(t)
            end
        end)
    end

    boss.Define("5a", "莉莉白", "TH16_AEX_1", TH16_AEX_bg,
            { -300, 300 }, _editor_class.TH16.SCBG1, "Whitelily", SPELL_ID)

    local non_sc1 = boss.card.New("", 1, 3, 36, 900)
    boss.card.add({ { non_sc1, "5a" } }, SPELL_ID, "一非", 227, nil, true)
    function non_sc1:before()
        if ext.sc_pr then
            task.MoveTo(0, 120, 60, 2)
        else
            boss.show_aura(self, false)
            task.MoveTo(0, 120, 120, 2)
            boss.show_aura(self, true)
            task.Wait(60)
        end
    end
    function non_sc1:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            boss.cast(self, 60)
            for a in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                Heart_obj(self, self.x, self.y, 2, a, 1, 0, 0.8, 10, 2.5, 150, 30)
            end
            task.New(self, function()
                task.Wait(60)
                while true do
                    task.MoveToPlayer(70, -120, 120, 90, 144,
                            20, 40, 16, 32, 2, 1)
                    task.Wait(110)
                end
            end)
        end)
    end

    local sc_name1 = "春式一「白雪却嫌春色晚」"
    local sc1 = boss.card.New(sc_name1, 3, 7, 42, 1000)
    boss.card.add({ { sc1, "5a" } }, SPELL_ID, sc_name1, 228, nil, true)
    sc1.before = card_start
    function sc1:init()
        local whitesnow = function(_x, _y, y, r)
            local self = NewObject(bullet)
            bullet.init(self, ball_big, 15, false, false)
            self.x, self.y = _x, _y
            self._blend = "mul+add"
            PlaySound("boon01")
            self.bound = false
            self.flag = 1
            task.New(self, function()
                task.MoveTo(0, y, 120, 3)
                task.Wait(60)
                local s = 90
                local S = 90
                while true do
                    s = s + r * sin(90 - S)
                    self.x = cos(s) * 200
                    S = max(0, S - 1)
                    task.Wait()

                end
            end)
            task.New(self, function()
                while true do
                    if self.flag > 0 then
                        if self.x > 192 or self.x < -192 then
                            self.flag = 0
                            local a, _d_a = (0), (90)
                            for _ = 1, 4 do
                                do
                                    local rot, _d_rot = (a), (15 / 4)
                                    local v, _d_v = (0.8), (0.6 / 4)
                                    for _ = 1, 4 do
                                        Create.bullet_accel(self.x + cos(rot) * 12, self.y + sin(rot) * 12,
                                                sakura, 4, 0.5, v, rot, true, false)

                                        rot = rot + _d_rot
                                        v = v + _d_v
                                    end
                                end
                                do
                                    local rot, _d_rot = (a + 15), (15 / 4)
                                    local v, _d_v = (1.4), (-0.6 / 4)
                                    for _ = 1, 4 do
                                        Create.bullet_accel(self.x + cos(rot) * 12, self.y + sin(rot) * 12,
                                                sakura, 4, 0.5, v, rot, true, false)
                                        rot = rot + _d_rot
                                        v = v + _d_v
                                    end
                                end
                                a = a + _d_a
                            end
                        end
                    end
                    task.Wait()
                end

            end)
            task.New(self, function()
                while true do
                    while true do
                        if self.flag == 0 then
                            break
                        end
                        task.Wait()
                    end
                    task.Wait(120)
                    self.flag = 1
                    task.Wait()
                end
            end)
        end
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            boss.cast(self, 60)
            local d = 1
            for k = 0, 10 do
                whitesnow(self.x, self.y, 224 - 448 * k / 10, d * (0.6 + 0.01 * k))
                d = -d
            end
            task.New(self, function()
                task.Wait(60)
                while true do
                    task.MoveToPlayer(70, -120, 120, 90, 144,
                            20, 40, 16, 32, 2, 1)
                    task.Wait()
                    boss.cast(self, 130)
                    task.Wait(130)
                end
            end)
            task.Wait(120)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            local gravity = function(x, y, v, a)
                local self = NewObject(bullet)
                bullet.init(self, arrow_big, 2, true, true)
                self.x, self.y = x, y
                self.navi = true
                PlaySound("tan00")
                object.SetV(self, v, a, true)
                self.maxv = 2
                task.New(self, function()
                    task.Wait(60)
                    object.SetA(self, 0.01, Angle(self, player))
                end)
            end
            task.New(self, function()
                local rot, _d_rot = (ran:Float(0, 360)), (13)
                while true do
                    local a, _d_a = (rot), (180)
                    for _ = 1, 2 do
                        gravity(self.x, self.y, 1, a)
                        a = a + _d_a
                    end
                    task.Wait(12)
                    rot = rot + _d_rot
                end
            end)
            while true do
                for a in sp.math.AngleIterator(ran:Float(0, 360), 18) do
                    gravity(self.x, self.y, 1.5, a)
                end
                task.Wait(100)
            end

        end)
    end
    sc1.other_bonus_drop = CardBonusDrop

    local non_sc2 = boss.card.New("", 1, 3, 36, 900)
    boss.card.add({ { non_sc2, "5a" } }, SPELL_ID, "二非", 229, nil, true)
    non_sc2.before = card_start
    function non_sc2:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            boss.cast(self, 60)
            do
                local d, _d_d = (1), (-0.6 / 9)
                local l, _d_l = (15), (400 / 9)
                local bv, _d_bv = (3), (-2 / 9)
                for _ = 1, 10 do
                    Heart_obj(self, self.x, self.y, 6, 0, d, 0, 0.04, 10, bv, l, l, 0.4)
                    d = d + _d_d
                    l = l + _d_l
                    bv = bv + _d_bv
                end
            end
            task.New(self, function()
                task.Wait(60)
                while true do
                    task.MoveToPlayer(70, -120, 120, 90, 144,
                            20, 40, 16, 32, 2, 1)
                    task.Wait(110)
                end
            end)
        end)
    end

    local sc_name2 = "春式二「春雨贵如油」"
    local sc2 = boss.card.New(sc_name2, 3, 7, 42, 1300)
    boss.card.add({ { sc2, "5a" } }, SPELL_ID, sc_name2, 230, nil, true)
    sc2.before = card_start
    function sc2:init()
        local Bean = function(_x, _y, x)
            local self = NewObject(bullet)
            bullet.init(self, ball_big, 2, true, false)
            self.x, self.y = _x, _y
            self._blend = "mul+add"
            PlaySound("boon01")
            task.New(self, function()
                task.MoveTo(self.x, -224, 180, 3)
                task.MoveTo(x, -224, 120, 3)
            end)
            task.New(self, function()
                while true do
                    if self.vscale > 2 then
                        break
                    end
                    task.Wait()
                end
                Newcharge_in(self.x, self.y, 189, 252, 201)
                task.Wait(60)
                while true do
                    local a, _d_a = (ran:Float(0, 360)), (36)
                    for _ = 1, 10 do
                        local l = self.vscale * 12
                        Create.bullet_decel(self.x + cos(a) * l, self.y + sin(a) * l, grain_a, 10, 1, 1, a, true, false)
                        PlaySound("tan00")
                        a = a + _d_a
                    end
                    task.Wait(ran:Int(100, 140))
                end
            end)
            task.New(self, function()
                while true do
                    if self.vscale == 16 then
                        break
                    end
                    task.Wait()
                end
                self.a = 0
                self.b = 0
                do
                    local s, _d_s = (16), (-16 / 10)
                    for _ = 1, 11 do
                        self.vscale = s
                        self.hscale = s
                        task.Wait()
                        s = s + _d_s
                    end
                end
                do
                    local v, _d_v = (1), (0.3)
                    local rot, _d_rot = (Angle(self, player)), (7)
                    for _ = 1, 5 do
                        do
                            local a, _d_a = (rot), (12)
                            for _ = 1, 30 do
                                local l = self.vscale * 12
                                Create.bullet_decel(self.x + cos(a) * l, self.y + sin(a) * l, grain_a, 10, 1, 1, a, true, false)
                                a = a + _d_a
                            end
                        end
                        v = v + _d_v
                        rot = rot + _d_rot
                    end
                end
                PlaySound("enep00", 0.1, 0, false)
                object.Del(self)
            end)
        end
        local Rain = Class(bullet, {
            init = function(self, _x, _y)
                bullet.init(self, water_drop, 6, true, true)
                self.x, self.y = _x, _y
                PlaySound("tan00")
                object.SetV(self, ran:Float(1, 2), ran:Float(-6, 6) - 90, true)
            end,
            colli = function(self, other)
                self.class.base.colli(self, other)
                if other.group == GROUP.INDES then
                    PlaySound("kira00")
                    other.vscale = min(16, other.vscale + 0.2)
                    other.hscale = min(16, other.hscale + 0.2)
                    other.a = other.vscale * 8
                    other.b = other.hscale * 8
                    object.Del(self)
                end
            end
        }, true)
        task.New(self, function()
            while true do
                CollisionCheck(GROUP.ENEMY_BULLET, GROUP.INDES)
                task.Wait()
            end
        end)
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            boss.cast(self, 60)
            local x, _d_x = (192), (-384 / 11)
            for _ = 1, 12 do
                Bean(self.x, self.y, x)
                x = x + _d_x
            end
            task.New(self, function()
                task.Wait(60)
                while true do
                    task.MoveToPlayer(70, -120, 120, 90, 144,
                            20, 40, 16, 32, 2, 1)
                    task.Wait()
                    boss.cast(self, 130)
                    task.Wait(130)
                end
            end)
            task.Wait(120)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            task.New(self, function()
                local rot, _d_rot = (ran:Float(0, 360)), (-13)
                while true do
                    local a, _d_a = (rot), (180)
                    for _ = 1, 2 do
                        Create.bullet_decel(self.x, self.y, ball_mid, 2, 5, 2, a)
                        PlaySound("tan00")
                        a = a + _d_a
                    end
                    task.Wait(10)
                    rot = rot + _d_rot
                end


            end)
            while true do
                New(Rain, ran:Float(-192, 192), 224)
                task.Wait(6)
            end
        end)
    end
    sc2.other_bonus_drop = CardBonusDrop

    local non_sc3 = boss.card.New("", 1, 3, 36, 900)
    boss.card.add({ { non_sc3, "5a" } }, SPELL_ID, "三非", 231, nil, true)
    non_sc3.before = card_start
    function non_sc3:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            boss.cast(self, 60)
            do
                local a, _d_a = (0), (18)
                local l, _d_l = (15), (200 / 17)
                for _ = 1, 20 do
                    Heart_obj(self, self.x, self.y, 6, a, -1, 0, 0.8, 20, 1.5, l, l, 0.4)
                    a = a + _d_a
                    l = l + _d_l
                end
            end
            do
                local a, _d_a = (180), (18)
                local l, _d_l = (15), (200 / 17)
                for _ = 1, 20 do
                    Heart_obj(self, self.x, self.y, 2, a, -1, 0, 0.8, 20, 2, l, l, 0.4)
                    a = a + _d_a
                    l = l + _d_l
                end
            end
            task.New(self, function()
                task.Wait(60)
                while true do
                    task.MoveToPlayer(70, -120, 120, 90, 144,
                            20, 40, 16, 32, 2, 1)
                    task.Wait(110)

                end
            end)
        end)
    end

    local sc_name3 = "春式三「轻雷隐隐初惊蛰」"
    local sc3 = boss.card.New(sc_name3, 3, 7, 42, 950)
    boss.card.add({ { sc3, "5a" } }, SPELL_ID, sc_name3, 232, nil, true)
    sc3.before = card_start
    function sc3:init()
        local lightning = function(_x, _y, a, r, v)
            local self = NewObject(Class(bent_laser, {
                frame = function(self)
                    bent_laser.frame(self)
                    if self.timer < 90 then
                        for _ = 1, 4 do
                            local _a = ran:Float(0, 360)
                            local _v = ran:Float(3, 6)
                            table.insert(self.particle, {
                                x = self.x, y = self.y,
                                vx = cos(_a) * _v, vy = sin(_a) * _v,
                                alpha = ran:Float(200, 250), timer = 0,
                                r = self.pcol[1], g = self.pcol[2], b = self.pcol[3]
                            })
                        end
                    end
                    local p
                    for i = #self.particle, 1, -1 do
                        p = self.particle[i]
                        p.x = p.x + p.vx
                        p.y = p.y + p.vy
                        p.vx = p.vx - p.vx * 0.04
                        p.vy = p.vy - p.vy * 0.04
                        if p.timer > 10 then
                            p.alpha = max(p.alpha - 5, 0)
                            if p.alpha == 0 then
                                table.remove(self.particle, i)
                            end
                        end
                        p.timer = p.timer + 1
                    end
                    self.bound = (#self.particle == 0) and (self.timer > 30)
                end,
                render = function(self)
                    bent_laser.render(self)
                    for _, p in ipairs(self.particle) do
                        SetImageState("bright", "mul+add", p.alpha, p.r, p.g, p.b)
                        Render("bright", p.x, p.y, 0, 10 / 150)
                    end
                end
            }, true))
            bent_laser.init(self, 6, _x, _y, 60, 26, 0, 5)
            object.SetV(self, v, a, true)
            self.particle = {}
            self.pcol = { 250, 250, 250 }
            task.New(self, function()
                local s = 90
                while true do
                    object.SetV(self, v, a + sin(s) * r, true)
                    task.Wait()
                    s = s + 40
                end
            end)
        end
        local cloud = function(_x, _y, x, y)
            local self = NewObject(bullet)
            bullet.init(self, ball_huge, 6, true, false)
            self.x, self.y = _x, _y
            task.New(self, function()
                PlaySound("kira00")
                task.MoveTo(x, y, 120, 2)
                Newcharge_in(self.x, self.y, 250, 128, 114)
                for _ = 1, 10 do
                    Create.bullet_decel(self.x, self.y, ball_big, 6, 7, 7, -90, true, false)
                    PlaySound("tan00")
                    task.Wait(3)
                end
                task.Wait(30)
                for _ = 1, 6 do
                    lightning(self.x + ran:Float(-12, 12), self.y, ran:Float(-7, 7) - 90, ran:Float(8, 20) * ran:Sign(), ran:Float(35, 60))
                end
                PlaySound("Lightning", 2, self.x, false)
                object.Del(self)
            end)
        end
        local ball_center = Class(obejct, {
            frame = task.Do,
            init = function(self, x, y, v, a, r, o, is, ts)
                self.x, self.y = x, y
                self.group = GROUP.INDES
                self.colli = false
                object.SetV(self, v, a)
                self.bound = false
                task.New(self, function()
                    local w = lstg.world
                    while BoxCheck(self, w.l - r, w.r + r, w.b - r, w.t + r) do
                        task.Wait()
                    end
                    Del(self)
                end)
                for k = 1, 2 do
                    for A, i in sp.math.AngleIterator(ran:Float(0, 360), 7 + k * 9) do
                        local R = r * sin(is) * k / 2
                        local b = NewSimpleBullet(ball_small, 2 + 14 * i % 2, self.x + cos(A) * R, self.y + sin(A) * R)
                        b.bound = false
                        b.stay = false
                        b._blend = "mul+add"
                        b.radius = r * k / 2
                        b.is = is
                        b.ts = ts
                        b.rangle = A
                        b.rotate = o * k / 2 * (k % 2 * 2 - 1)
                        b.master = self
                        function b:frame_other()
                            if IsValid(self.master) then
                                self.x = self.master.x + cos(self.rangle) * self.radius * sin(self.is)
                                self.y = self.master.y + sin(self.rangle) * self.radius * sin(self.is)
                                self.rangle = self.rangle + self.rotate
                                self.is = self.is + self.ts
                            else
                                Del(self)
                            end
                        end
                    end
                end
            end
        }, true)
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            boss.cast(self, 60)
            task.New(self, function()
                local t = 120
                while true do
                    cloud(self.x, self.y, -170, 220)
                    cloud(self.x, self.y, 170, 220)
                    task.Wait(t)
                    task.New(self, function()
                        task.MoveTo(player.x, 120, 60, 2)
                    end)
                    cloud(self.x, self.y, player.x, 220)
                    t = max(50, t - 10)
                    task.Wait(t)
                end
            end)
            task.Wait(180)

            local rot, _d_rot = (ran:Float(0, 360)), (23)
            while true do
                for A in sp.math.AngleIterator(rot, 3) do
                    New(ball_center, self.x, self.y, 1.35, A, ran:Float(30, 50), ran:Float(0.7, 1.4) * ran:Sign(),
                            ran:Float(0, 360), ran:Float(0.7, 1.5))
                end
                task.Wait(29)
                rot = rot + _d_rot

            end
        end)
    end
    sc3.other_bonus_drop = CardBonusDrop

    local non_sc4 = boss.card.New("", 1, 3, 36, 900)
    boss.card.add({ { non_sc4, "5a" } }, SPELL_ID, "四非", 233, nil, true)
    non_sc4.before = card_start
    function non_sc4:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            do
                for _ = 1, 60 do
                    lstg.tmpvar.bg.speed = lstg.tmpvar.bg.speed + 1 / 60
                    task.Wait()
                end
            end
            boss.cast(self, 60)
            do
                local a, _d_a = (ran:Float(0, 360)), (18)
                for _ = 1, 20 do
                    Heart_obj(self, self.x, self.y, 2, a, 1, 0, 0.8, 15, 2.5, 150, 50)
                    a = a + _d_a
                end
            end
            do
                local a, _d_a = (ran:Float(0, 360)), (18)
                for _ = 1, 20 do
                    Heart_obj(self, self.x, self.y, 6, a, -1, 90, -0.8, 15, 2.5, 150, 50)
                    a = a + _d_a
                end
            end
            task.New(self, function()
                task.Wait(60)
                while true do
                    task.MoveToPlayer(70, -120, 120, 90, 144,
                            20, 40, 16, 32, 2, 1)
                    task.Wait(110)
                end
            end)
        end)
    end

    local sc_name4 = "春式四「仲春初四日」"
    local sc4 = boss.card.New(sc_name4, 3, 7, 55, 1600)
    boss.card.add({ { sc4, "5a" } }, SPELL_ID, sc_name4, 234, nil, true)
    sc4.before = card_start
    function sc4:init()
        local function fadeaway(_x, _y, v, a, t)
            local self = NewObject(bullet)
            bullet.init(self, grain_b, 10, true, true)
            self.x, self.y = _x, _y
            PlaySound("kira00")
            object.SetV(self, v, a, true)
            task.New(self, function()
                if t ~= 0 then
                    task.New(self, function()
                        task.Wait(t / 2)
                        self.colli = false
                    end)
                    local A, _d_a = (255), (-255 / t)
                    for _ = 1, t do
                        self._a = A
                        task.Wait()
                        A = A + _d_a
                    end
                    object.RawDel(self)
                end
            end)
        end
        local function Line(master, _x, _y, col, rot, d, l, f)
            local self = NewObject(Class(bullet, {
                colli = function(self, other)
                    bullet.colli(self, other)
                    if other.group == GROUP.NONTJT then
                        if self.timer % 3 == 0 then
                            fadeaway(self.x, self.y, ran:Float(0.5, 1.2), ran:Float(0, 360), self.flag)
                        end
                    end
                end
            }, true))
            bullet.init(self, ball_big, col, false, false)
            self.x, self.y = _x, _y
            self.flag = f
            self.bound = false
            PlaySound("kira00")
            self._blend = "mul+add"
            self.__a = 255
            self._a = 0
            task.New(self, function()
                local a, _d_a = (rot), (d)
                local rx, _d_rx = (0), (0.5)
                while IsValid(master) do
                    self.rot = a
                    local x0 = cos(a) * sin(min(rx, 90)) * l
                    local y0 = sin(a) * 12
                    self.x = master.x + x0 * cos(-23.26) - y0 * sin(-23.26)
                    self.y = master.y + x0 * sin(-23.26) + y0 * cos(-23.26)
                    if a % 360 > 0 and a % 360 < 180 then
                        self.__a = 120
                        self.layer = LAYER.ENEMY - 1
                    end
                    if a % 360 > 180 and a % 360 < 360 then
                        self.__a = 255
                        self.layer = LAYER.ENEMY_BULLET + 1
                    end
                    self._a = self._a + (-self._a + self.__a) * 0.1
                    self.colli = self._a > 200
                    task.Wait()
                    a = a + _d_a
                    rx = rx + _d_rx
                end
                Del(self)
            end)
        end
        local function center2(_x, _y, col, rot, d, l)
            local self = NewObject(bullet)
            bullet.init(self, ball_big, col, false, false)
            self.x, self.y = _x, _y
            self.colli = false
            PlaySound("kira00")
            self.bound = false
            self._a = 0
            self._blend = "mul+add"
            self.timer = 11
            task.New(self, function()
                local a, _d_a = (rot), (d)
                while true do
                    self.rot = a
                    self.x = cos(a) * l
                    self.y = sin(a) * l
                    task.Wait()
                    a = a + _d_a
                end
            end)
            task.New(self, function()
                task.Wait(30)
                do
                    local a, _d_a = (0), (255 / 89)
                    for _ = 1, 90 do
                        self._a = a
                        task.Wait()
                        a = a + _d_a
                    end
                end
                self.colli = true
                local k = 1
                while true do
                    for a in sp.math.AngleIterator(self.rot, 3) do
                        local b = NewSimpleBullet(arrow_big, 15, self.x, self.y, 3, a)
                        b.stay = false
                        b._blend = "add+add"
                        b._r, b._g, b._b = sp:HSVtoRGB(k * 6 + self.rot, 1, 0.5)
                    end
                    PlaySound("tan00")
                    k = k + 1
                    task.Wait(9)

                end
            end)
        end
        local checkColli = Class(object, {
            frame = task.Do,
            init = function(self, _x, _y, a)
                self.x, self.y = _x, _y
                self.group = GROUP.NONTJT
                self.bound = false
                self.colli = true
                self.rot = a
                self.a = 8
                self.b = 5
                task.New(self, function()
                    task.Wait(90)
                    object.Del(self)
                end)
            end
        }, true)
        local circleCenter = Class(object, {
            frame = task.Do,
            init = function(self, _x, _y, x, y, l, d, f)
                self.x, self.y = _x, _y
                self.group = GROUP.INDES
                self.bound = false
                self.colli = false
                task.New(self, function()
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 30) do
                        Line(self, self.x, self.y, 6, a, d, l, f)
                    end
                    task.MoveTo(x, y, 120, 2)
                end)
            end
        }, true)
        local shoot_laser = Class(laser, {
            init = function(self, x, y, col, w, a, dr, time)
                laser.init(self, col, x, y, a, 0, 0, 0, w, w, 0)
                laser._TurnHalfOn(self, 0, false)
                self.line = 0
                self.Isradial = true
                self.radial_v = 20
                task.New(self, function()
                    task.New(self, function()
                        for i = 1, 60 do
                            self.line = sin(i / 60 * 90) * 600
                            task.Wait()
                        end
                    end)
                    local slast = 0
                    for i = 1, time do
                        self.rot = self.rot + dr * task.SetMode[2](i / time) - slast
                        slast = dr * task.SetMode[2](i / time)
                        task.Wait()
                    end
                    laser._TurnOn(self, 1, true, false)
                    task.New(self, function()
                        local l, _d_l = (0), (20)
                        for _ = 1, 40 do
                            New(checkColli, self.x + cos(self.rot) * l, self.y + sin(self.rot) * l, self.rot)
                            task.Wait()
                            l = l + _d_l
                        end
                    end)
                    for _ = 1, 30 do
                        self.l3 = self.l3 + 20
                        task.Wait()
                    end
                    for _ = 1, 30 do
                        self.l2 = self.l2 + 20
                        task.Wait()
                    end
                    for _ = 1, 30 do
                        self.l1 = self.l1 + 20
                        task.Wait()
                    end
                    laser._TurnOff(self, 30, true)
                    object.Del(self)

                end)
            end,
            render = function(self)
                SetImageState("white", "mul+add", self.alpha * 180, unpack(ColorList[math.ceil(self.index / 2)]))
                Render("white", self.x + cos(self.rot) * self.line / 2, self.y + sin(self.rot) * self.line / 2, self.rot, self.line / 16, 0.125)
                laser.render(self)
            end
        }, true)
        task.New(self, function()
            while true do
                CollisionCheck(GROUP.INDES, GROUP.NONTJT)
                task.Wait()
            end
        end)
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            ToBigScreen(60)
            task.Wait(120)
            boss.cast(self, 60)
            task.New(self, function()
                local T, P = 23.26 * 3, 66.34 * 3
                local c = cos(23.26) * 23.26
                local Ar, Tr, Pr = 6378.2 / 20, 6378.2 / 20 * cos(c), 6378.2 / 20 * cos(43.08)
                for a in sp.math.AngleIterator(ran:Float(0, 360), 30) do
                    center2(0, 0, 6, a, 0.4, Ar)
                end
                New(circleCenter, self.x, self.y, 0, 0, Ar, 0.4, 0)
                New(circleCenter, self.x, self.y, cos(90 - 23.26) * T, sin(90 - 23.26) * T, Tr, -0.3, 120)
                New(circleCenter, self.x, self.y, cos(90 - 23.26 + 180) * T, sin(90 - 23.26 + 180) * T, Tr, -0.3, 120)
                New(circleCenter, self.x, self.y, cos(90 - 23.26) * P, sin(90 - 23.26) * P, Pr, 0.5, 60)
                New(circleCenter, self.x, self.y, cos(90 - 23.26 + 180) * P, sin(90 - 23.26 + 180) * P, Pr, 0.5, 60)
            end)
            task.Wait(60)
            local d = 1
            local t = 4
            while true do
                task.MoveToPlayer(60, -300, 300, 80, 120,
                        20, 40, 16, 32, 2, 1)
                for a in sp.math.AngleIterator(Angle(self, player) - 360 / t * 2 * d, t) do
                    New(shoot_laser, self.x, self.y, 14, 10, a, 360 / t * 2 * d, 90)
                end
                d = -d
                for _ = 1, 3 do
                    for a in sp.math.AngleIterator(Angle(self, player), t * 2) do
                        Create.bullet_decel(self.x, self.y, ball_huge, 14, 4, 2, a, true, false)
                    end
                    task.Wait(47)
                end
                t = min(t + 1, 9)
            end

        end)
    end
    function sc4:del()
        ToNormalScreen(60)
    end
    sc4.other_bonus_drop = CardBonusDrop

    local non_sc5 = boss.card.New("", 1, 3, 36, 900)
    boss.card.add({ { non_sc5, "5a" } }, SPELL_ID, "五非", 235, nil, true)
    non_sc5.before = card_start
    function non_sc5:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            boss.cast(self, 60)
            for a in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                Heart_obj(self, self.x, self.y, 8, a, 1, 0, 0.2, 15, 2.5, 150, 50)
            end
            for a in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                Heart_obj(self, self.x, self.y, 6, a, 1, 120, 0.2, 20, 2.5, 150, 50)
            end
            for a in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                Heart_obj(self, self.x, self.y, 13, a, 1, 240, 0.2, 25, 2.5, 150, 50)
            end
            task.New(self, function()
                task.Wait(60)
                while true do
                    task.MoveToPlayer(70, -120, 120, 90, 144,
                            20, 40, 16, 32, 2, 1)
                    task.Wait(110)

                end
            end)
        end)
    end

    local sc_name5 = "春式五「恻恻轻寒翦翦风」"
    local sc5 = boss.card.New(sc_name5, 3, 5, 47, 1450)
    boss.card.add({ { sc5, "5a" } }, SPELL_ID, sc_name5, 236, nil, true)
    sc5.before = card_start
    function sc5:init()
        local w = lstg.world
        local bright = function(_x, _y, v, a, v2)
            local self = NewObject(bullet)
            bullet.init(self, ball_big, 4, true, true)
            self.x, self.y = _x, _y
            PlaySound("kira00")
            self._blend = "mul+add"
            object.SetV(self, v, a, true)
            task.New(self, function()
                local _v, _d_v = (v), (-v / 49)
                for _ = 1, 50 do
                    object.SetV(self, _v, self.rot, true)
                    task.Wait()
                    _v = _v + _d_v
                end
                task.Wait(40)
                object.SetV(self, 0, ran:Float(0, 360), true)
                _v, _d_v = (0), (v2 / 89)
                for _ = 1, 90 do
                    object.SetV(self, _v, self.rot, true)
                    task.Wait()
                    _v = _v + _d_v
                end
            end)
        end
        local flower = function(master, _x, _y, a, r)
            local self = NewObject(bullet)
            bullet.init(self, grain_b, 4, false, false)
            self.x, self.y = _x, _y
            self.bound = false
            task.New(self, function()
                while IsValid(master) do
                    if not BoxCheck(self, w.l - 30, w.r + 30, w.b - 30, w.t + 30) then
                        break
                    end
                    self.rot = a
                    self.x = master.x + cos(a) * 8
                    self.y = master.y + sin(a) * 8
                    task.Wait()
                    a = a + r
                end
                Del(self)
            end)
            local s = 90
            task.New(self, function()
                while true do
                    if IsValid(_boss) then
                        if _boss.wind then
                            self._r = 190 + 65 * sin(s)

                            s = max(0, s - 0.9)
                        else
                            object.SetA(self, 0, self.rot)
                        end
                    end
                    task.Wait()
                end
            end)
        end
        local flowerstalk = function(_x, _y, A, v)
            local self = NewObject(bullet)
            bullet.init(self, ball_mid, 2, true, false)
            self.x, self.y = _x, _y
            self.bound = false
            self.navi = true
            PlaySound("kira00")
            object.SetV(self, v, ran:Float(-6, 6) - 90, true)
            do
                local a, _d_a = (ran:Float(0, 360)), (72)
                local d, _d_d = (ran:Sign() * ran:Float(0.8, 1.2)), (0)
                for _ = 1, 5 do
                    flower(self, self.x + cos(a) * 8, self.y + sin(a) * 8, a, d)
                    a = a + _d_a
                    d = d + _d_d
                end
            end
            local s = 90
            task.New(self, function()
                local i = ran:Float(0.1, 1)
                while true do
                    if IsValid(_boss) then
                        if _boss.wind then
                            object.SetA(self, 0.0078, A.aa)
                            self._r = 190 + 65 * sin(s)
                            s = max(0, s - i)
                            if s == 0 then
                                bright(self.x, self.y, v, self.rot, ran:Float(1, 2.5))
                                Del(self)
                            end
                        else
                            object.SetA(self, 0, self.rot)
                        end
                    end
                    task.Wait()
                end
            end)
            task.New(self, function()
                while true do
                    if not BoxCheck(self, w.l - 30, w.r + 30, w.b - 30, w.t + 30) then
                        object.Del(self)
                    end
                    task.Wait()
                end
            end)

        end
        local butterflyb = function(_x, _y, v, a)
            local self = NewObject(bullet)
            bullet.init(self, butterfly, 2, true, false)
            self.x, self.y = _x, _y
            PlaySound("kira00", 0.1)
            object.SetV(self, 0.08, a, true)
            task.New(self, function()
                task.Wait(120)
                local _v, _d_v = (0.08), ((-0.08 + v) / 119)
                for _ = 1, 120 do
                    object.SetV(self, _v, self.rot, true, false)
                    task.Wait()
                    _v = _v + _d_v
                end
            end)
        end
        local butterflyshooter = Class(object, {
            frame = task.Do,
            init = function(self, _x, _y, A, i, d)
                self.x, self.y = _x, _y
                self.group = GROUP.INDES
                self.colli = false
                object.SetV(self, 3, A, true)
                task.New(self, function()
                    local a, _d_a = (i), (d)
                    while true do
                        butterflyb(self.x, self.y, 2, a)
                        task.Wait(4)
                        a = a + _d_a
                    end
                end)
                task.New(self, function()
                    local s, _d_s = (90), (4)
                    while true do
                        object.SetV(self, 3, self.rot + sin(s) * 2, true)
                        task.Wait()
                        s = s + _d_s
                    end
                end)
            end
        }, true)

        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            boss.cast(self, 60)
            local A = { aa = 0 }
            task.New(self, function()
                while true do
                    flowerstalk(ran:Float(-300, 300), 240, A, ran:Float(1, 2.6))
                    task.Wait(3)

                end
            end)
            task.Wait(90)
            local d = 1

            local a, _d_a = (0), (180)
            while true do
                task.MoveToPlayer(70, -120, 120, 90, 144,
                        20, 40, 16, 32, 2, 1)
                task.Wait(60)
                Newcharge_in(self.x, self.y, 250, 128, 114)
                task.Wait(60)
                do
                    local y, _d_y = (120), (-100 / 2)
                    for _ = 1, 3 do
                        New(butterflyshooter, -192 * d, y, a + ran:Float(-10, 10), ran:Float(0, 360), d * 17)
                        y = y + _d_y
                    end
                end
                self.wind = true
                A.aa = a
                task.Wait(300)
                self.wind = false
                d = -d
                task.Wait(70)
                a = a + _d_a
            end
        end)
    end
    sc5.other_bonus_drop = CardBonusDrop

    local non_sc6 = boss.card.New("", 1, 3, 36, 900)
    boss.card.add({ { non_sc6, "5a" } }, SPELL_ID, "六非", 237, nil, true)
    non_sc6.before = card_start
    function non_sc6:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            boss.cast(self, 60)
            for a in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                Heart_obj(self, self.x, self.y, 4, a, -1, 0, -1, 9, 1.5, 200, 100)
            end
            task.New(self, function()
                task.Wait(60)
                while true do
                    task.MoveToPlayer(70, -120, 120, 90, 144,
                            20, 40, 16, 32, 2, 1)
                    task.Wait(110)
                end
            end)
        end)
    end

    local sc_name6 = "春式终「杨花落尽子规啼」"
    local sc6 = boss.card.New(sc_name6, 3, 5, 50, 1250)
    boss.card.add({ { sc6, "5a" } }, SPELL_ID, sc_name6, 238, nil, true)
    sc6.before = card_start
    function sc6:init()
        local pillow = function(master, _x, _y, l, s, a, bb, i)
            local self = NewObject(bullet)
            bullet.init(self, grain_a, 10, false, false)
            self.x, self.y = _x, _y
            self.bound = false
            task.New(self, function()
                local rx = 0
                while IsValid(master) do
                    local S = sin(min(rx, 90))
                    local B = sin(i) * bb
                    self.x = master.x + cos(a + B) * l * S
                    self.y = master.y + sin(a + B) * l * S
                    self.rot = a + B
                    task.Wait()
                    i = i + s
                    rx = rx + 1
                end
                Del(self)
            end)
            task.New(self, function()
                local T = ran:Int(1, 12)
                if T == 1 then
                    while true do
                        local b = NewSimpleBullet(ball_mid, 16, self.x, self.y, 0, 0)
                        b.ag = ran:Float(0.001, 0.01)
                        b._blend = "mul+add"
                        PlaySound("tan00")
                        task.Wait(ran:Int(75, 110))
                    end
                end
            end)
        end
        local pillowtop = Class(object, {
            frame = task.Do,
            init = function(self, _x, _y, t, s, bb, x, y, i)
                self.x, self.y = _x, _y
                self.group = GROUP.INDES
                self.bound = false
                self.colli = false
                self.bound = false
                do
                    local l, _d_l = (0), (6)
                    local I, _d_I = (i), (-i / (t - 1))
                    for _ = 1, t do
                        pillow(self, self.x, self.y, l, s, -90, bb, I)
                        l = l + _d_l
                        I = I + _d_I
                    end
                end
                task.New(self, function()
                    task.MoveTo(x, y, 150, 3)
                end)
            end
        }, true)
        local Bird = Class(object, {
            frame = task.Do,
            render = function(self)
                SetAnimationState(self.img, self._blend, self._a, self._r, self._g, self._b)
                DefaultRenderFunc(self)
            end,
            init = function(self, _x, _y, V, A, r, T)
                self.x, self.y = _x, _y
                self.img = "Bird"
                self.layer = LAYER.ENEMY
                self.group = GROUP.INDES
                self.bound = false
                self.colli = true
                self._blend = "mul+add"
                self._a, self._r, self._g, self._b = 0, 255, 255, 255
                PlaySound("kira00")
                object.SetV(self, V, A, true)
                task.New(self, function()
                    do
                        local s, _d_s = (1.5), (-0.5 / 15)
                        local a, _d_a = (0), (255 / 15)
                        for _ = 1, 16 do
                            self.hscale = s
                            self.vscale = s
                            self._a = a
                            task.Wait()
                            s = s + _d_s
                            a = a + _d_a
                        end
                    end
                end)
                task.New(self, function()
                    for _ = 1, 90 do
                        object.SetV(self, V, self.rot + r, true)
                        task.Wait()
                    end
                    if T == 1 then
                        local v = ran:Float(2, 4)
                        for a in sp.math.AngleIterator(Angle(self, player), 10) do
                            Create.bullet_dec_acc(self.x, self.y, ball_mid, 2, 5, v, a)
                        end
                    end
                    object.Del(self)
                end)
            end
        }, true)
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            boss.cast(self, 60)
            local I, _d_I = (ran:Float(50, 120)), (0)
            local x, _d_x = (-192), (384 / 9)
            for _ = 1, 10 do
                New(pillowtop, x, 300, ran:Int(20, 45), 1.2, 12 + ran:Float(2, -2), x + ran:Float(-15, 15), 224, I)
                I = I + _d_I
                x = x + _d_x
            end
            while true do
                NewSimpleBullet(ball_huge, 4, self.x, self.y, 0.9, 0, true, 3, false)
                local rot, _d_rot = (Angle(self, player) - 60), (120 / 5)
                for _ = 1, 6 do
                    local a, _d_a = (-45), (90)
                    local r, _d_r = (1), (-2)
                    for _ = 1, 2 do
                        New(Bird, self.x, self.y, 2, rot + a, r, r)
                        a = a + _d_a
                        r = r + _d_r
                    end
                    rot = rot + _d_rot
                end
                task.Wait(60)
                task.MoveToPlayer(60, -100, 100, 90, 144,
                        20, 40, 8, 16, 2, 1)
                task.Wait(60)
            end
        end)
    end
    sc6.other_bonus_drop = CardBonusDrop

    local non_sc7 = boss.card.New("", 1, 3, 36, 900)
    boss.card.add({ { non_sc7, "5a" } }, SPELL_ID, "七非", 239, nil, true)
    non_sc7.before = card_start
    function non_sc7:init()
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            local A, _d_A = (Angle(self, player)), (-17)
            local s, _d_s = (0), (15)
            local ta, _d_ta = (0), (60)
            while true do
                local l = sin(s) * 100
                local a, _d_a = (A), (72)
                for _ = 1, 5 do
                    do
                        local rot, _d_rot = (a), (36 / 4)
                        local v, _d_v = (2), (2 / 4)
                        for _ = 1, 4 do
                            Create.bullet_dec_acc(self.x + cos(rot + ta) * l, self.y + sin(rot + ta) * l,
                                    grain_b, 2, 5, v, rot, true, false)
                            PlaySound("tan00")
                            rot = rot + _d_rot
                            v = v + _d_v
                        end
                    end
                    do
                        local rot, _d_rot = (a + 36), (36 / 4)
                        local v, _d_v = (4), (-2 / 4)
                        for _ = 1, 4 do
                            Create.bullet_dec_acc(self.x + cos(rot + ta) * l, self.y + sin(rot + ta) * l,
                                    grain_b, 2, 5, v, rot, true, false)
                            PlaySound("tan00")

                            rot = rot + _d_rot
                            v = v + _d_v
                        end
                    end

                    a = a + _d_a
                end
                task.Wait(12)
                A = A + _d_A
                s = s + _d_s
                ta = ta + _d_ta
            end

        end)
        task.New(self, function()
            task.Wait(120)
            while true do
                task.MoveToPlayer(70, -120, 120, 90, 144,
                        20, 40, 16, 32, 2, 1)
                task.Wait(110)

            end
        end)
    end

    local sc_name7 = "樱花「醍醐の花见」"
    local sc7 = boss.card.New(sc_name7, 43, 43, 43, 1000)
    boss.card.add({ { sc7, "5a" } }, SPELL_ID, sc_name7, 240, nil, true)
    sc7.before = card_start
    function sc7:del()
        self.colli = true
        self._r, self._g, self._b = 255, 255, 255
    end
    function sc7:init()
        local function flower(_x, _y, a, r, t)
            local self = NewObject(bullet)
            bullet.init(self, heart, 2, true, false)
            self.x, self.y = _x, _y
            -- self.layer=self.layer+1000
            self.colli = false
            self.bound = false
            self._a = 0
            self._blend = "mul+add"
            self.timer = 11
            task.New(self, function()
                local s = 1
                while true do
                    local l = 175 * sin(min(s, 90))
                    self.x, self.y = cos(a) * l, sin(a) * l
                    self.rot = a + 180
                    task.Wait()
                    a = a + r
                    s = s + 1
                end
            end)
            task.New(self, function()
                local _a, _d_a = (0), (255 / 119)
                for _ = 1, 120 do
                    self._a = _a
                    task.Wait()
                    _a = _a + _d_a
                end
                self.colli = true
                while true do
                    Create.bullet_dec_acc(self.x, self.y, grain_b, 2, 6, 1, self.rot)
                    PlaySound("tan00")
                    task.Wait(t + 60)
                end
            end)
        end
        local function flower2(master, _x, _y, a, r, t)
            local self = NewObject(bullet)
            bullet.init(self, music, 2, true, false)
            self.x, self.y = _x, _y
            self.rot = -90
            self.colli = false
            self.bound = false
            self._blend = "mul+add"
            self._a = 0
            self.__a = 0
            self.timer = 11
            task.New(self, function()
                while true do
                    if self.timer > 70 then
                        if Dist(self.x, self.y, 0, 0) < 175 then
                            self.__a = 44
                            self.colli = false
                        else
                            self.__a = 255
                            self.colli = true
                        end
                        if t > 60 then
                            self.__a = 44
                            self.colli = false
                        end
                    else
                        self.__a = self.timer / 70 * 85
                        self.colli = false
                    end
                    self._a = self._a + (-self._a + self.__a) * 0.1
                    task.Wait()
                end

            end)
            task.New(self, function()
                while IsValid(master) do
                    self.x = master.x + cos(a) * 150
                    self.y = master.y + sin(a) * 150
                    task.Wait()
                    a = a + r
                end
                Del(self)
            end)
        end
        local flowerCenter2 = Class(object, {
            frame = task.Do,
            init = function(self, _x, _y, A, r)
                self.x, self.y = _x, _y
                self.group = GROUP.INDES
                self.bound = false
                self.colli = false
                task.New(self, function()
                    while true do
                        self.x, self.y = cos(A) * 300, sin(A) * 300
                        task.Wait()
                        A = A + r
                    end
                end)
                task.New(self, function()
                    local t = 1.5
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 90) do
                        flower2(self, self.x, self.y, a, 1.6, t)
                        t = t + 1.5
                    end
                end)
            end
        }, true)
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            ToBigScreen(60)
            task.Wait(60)
            boss.cast(self, 120 * 60)
            self.colli = false
            self._r, self._g, self._b = 120, 120, 120
            task.MoveTo(0, 0, 60, 2)

            task.New(self, function()
                for a, t in sp.math.AngleIterator(ran:Float(0, 360), 60) do
                    flower(self.x, self.y, a, 0.4, t)
                end
                task.Wait(120)
                for a in sp.math.AngleIterator(-90, 5) do
                    New(flowerCenter2, self.x, self.y, a, -0.2)
                end
            end)
            task.Wait(600)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            task.New(self, function()
                while true do
                    for a in sp.math.AngleIterator(Angle(self, player), 5) do
                        Create.bullet_dec_acc(self.x, self.y, ball_light, 10, 7, 1, a)
                        PlaySound("tan00")
                    end
                    task.Wait(60)
                end
            end)
            task.Wait(600)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            while true do
                sakura_big.New(-340, ran:Float(-240, 240), ran:Float(0, 360),
                        ran:Sign(), ran:Float(1, 2), ran:Float(-30, 30))
                sakura_big.New(340, ran:Float(-240, 240), ran:Float(0, 360),
                        ran:Sign(), ran:Float(1, 2), ran:Float(-30, 30) + 180)
                task.Wait(20)
            end
        end)
    end
    sc7.other_bonus_drop = CardBonusDrop

    local sc_name8 = "春熙「百花齐放」"
    local sc8 = boss.card.New(sc_name8, 1, 1, 90, 3750)
    boss.card.add({ { sc8, "5a" } }, SPELL_ID, sc_name8, 242, nil, true)
    sc8.before = card_start
    function sc8:init()
        self._bosssys:addAutoSPPoint(800, 20 * 60)
        self._bosssys:addAutoSPPoint(1600, 40 * 60)
        self._bosssys:addAutoSPPoint(2400, 60 * 60)
        local max_spPoint = #self._sp_point_auto
        local shooter = Class(object, {
            frame = task.Do,
            init = function(self, _x, _y, v, a)
                self.x, self.y = _x, _y
                self.group = GROUP.INDES
                self.bound = false
                self.colli = false

                object.SetV(self, v, a, true)
                task.New(self, function()
                    local _v, _d_v = (v), (-v / 59)
                    for _ = 1, 60 do
                        object.SetV(self, _v, self.rot, true)
                        task.Wait()
                        _v = _v + _d_v
                    end
                    Del(self)
                end)
                task.New(self, function()
                    local l, _d_l = (90), (-90 / 19)
                    local A, _d_A = (ran:Float(0, 360)), (0)
                    for _ = 1, 20 do
                        for _a in sp.math.AngleIterator(A, 12) do
                            Create.bullet_dec_acc(self.x + cos(_a) * l, self.y + sin(_a) * l,
                                    grain_a, 15, 5, 2.5, _a + 180, true, false)
                        end
                        PlaySound("tan00")
                        task.Wait(3)
                        l = l + _d_l
                        A = A + _d_A
                    end

                end)
            end
        }, true)
        task.New(self, function()
            task.Wait(120)
            while true do
                task.MoveToPlayer(70, -300, 300, 160, 80,
                        20, 40, 16, 32, 2, 1)
                task.Wait()
                boss.cast(self, 130)
                task.Wait(130)
            end
        end)
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            if ext.sc_pr then
                ToBigScreen(60)
            else
                task.Wait(60)
            end
            task.New(self, function()
                local rot, _d_rot = (ran:Float(0, 360)), (-23)
                while true do
                    New(shooter, self.x, self.y, 2, ran:Float(0, 360))
                    task.Wait(55)
                    rot = rot + _d_rot
                end
            end)
            task.New(self, function()
                while #self._sp_point_auto >= max_spPoint do
                    task.Wait()
                end
                object.BulletDo(function(b)
                    object.Del(b)
                end)
                Newcharge_in(self.x, self.y, 255, 227, 132)
                PlaySound("explode")
                local grav = function(_x, _y, v, a)
                    local self = NewObject(bullet)
                    bullet.init(self, ball_mid_c, 14, true, true)
                    self.x, self.y = _x, _y
                    PlaySound("tan00")
                    object.SetV(self, v, a, true)
                    self._blend = "mul+add"
                    self.maxv = 2
                    task.New(self, function()
                        task.Wait(60)
                        object.SetA(self, 0.02, Angle(self, player), false)
                    end)
                end
                task.New(self, function()
                    while true do
                        local A, _d_A = (ran:Float(0, 360)), (72)
                        for _ = 1, 5 do
                            for t = -1, 1 do
                                grav(self.x, self.y, 2, A + t * 1.8)
                            end
                            A = A + _d_A
                        end
                        task.Wait(23)
                    end
                end)
            end)
            task.New(self, function()
                while #self._sp_point_auto >= max_spPoint - 1 do
                    task.Wait()
                end
                object.BulletDo(function(b)
                    object.Del(b)
                end)
                Newcharge_in(self.x, self.y, 255, 227, 132)
                PlaySound("explode")
                local function ball(_x, _y, v, a)
                    local self = NewObject(bullet)
                    bullet.init(self, ball_light, 4, true, true)
                    self.x, self.y = _x, _y
                    self.vscale = 0.5
                    self.hscale = 0.5
                    self.a = self.a * 0.5
                    self.b = self.b * 0.5
                    PlaySound("kira00", 0.1, self.x, false)
                    object.SetV(self, 0.5, a, true)
                    task.New(self, function()
                        task.Wait(60)
                        local _v, _d_v = (0.5), ((-0.5 + v) / 79)
                        for _ = 1, 80 do
                            object.SetV(self, _v, self.rot, true)
                            task.Wait()
                            _v = _v + _d_v
                        end
                    end)
                end
                local function shooter2(_x, _y, v, a)
                    local self = NewObject(bullet)
                    bullet.init(self, ball_light, 4, true, true)
                    self.x, self.y = _x, _y
                    object.SetV(self, v, a, true)
                    task.New(self, function()
                        do
                            local _v, _d_v = (v), (-v / 99)
                            for _ = 1, 100 do
                                object.SetV(self, _v, self.rot, true, false)
                                task.Wait()
                                _v = _v + _d_v
                            end
                        end

                        local _a, _d_a = (Angle(self, player)), (90)
                        for _ = 1, 4 do
                            do
                                local rot, _d_rot = (_a), (45 / 2)
                                local _v, _d_v = (0.6), (0.5 / 2)
                                for _ = 1, 2 do
                                    ball(self.x + cos(rot) * 15, self.y + sin(rot) * 15, _v, rot)

                                    rot = rot + _d_rot
                                    _v = _v + _d_v
                                end
                            end
                            do
                                local rot, _d_rot = (_a + 45), (45 / 2)
                                local _v, _d_v = (1.1), (-0.5 / 2)
                                for _ = 1, 2 do
                                    ball(self.x + cos(rot) * 15, self.y + sin(rot) * 15, _v, rot)

                                    rot = rot + _d_rot
                                    _v = _v + _d_v
                                end
                            end

                            _a = _a + _d_a
                        end

                        Del(self)
                    end)
                end
                task.New(self, function()
                    local d = 1
                    while true do
                        local a, _d_a = (90 - 60 * d), (-110 / 4 * d)
                        for _ = 1, 5 do
                            shooter2(320 * -d, ran:Float(20, -20), 4, a)
                            task.Wait(12)
                            a = a + _d_a
                        end

                        d = -d
                        task.Wait(140)
                    end

                end)
            end)
            task.New(self, function()
                while #self._sp_point_auto >= max_spPoint - 2 do
                    task.Wait()
                end
                object.BulletDo(function(b)
                    object.Del(b)
                end)
                Newcharge_in(self.x, self.y, 255, 227, 132)
                PlaySound("explode")
                local flow = function(x, y)
                    task.New(self, function()
                        local A = ran:Float(-10, 10) - 90
                        for p = 1, 5 do
                            local self = NewObject(bullet)
                            bullet.init(self, ellipse, 14, true, true)
                            self.x, self.y = x, y

                            object.SetV(self, 1, A, true)
                            task.New(self, function()
                                local s, _d_s = (90 + p * 7), (2)
                                local v = 1
                                while true do
                                    object.SetV(self, v, A + sin(s) * 20, true)
                                    task.Wait()
                                    s = s + _d_s
                                    v = v + 0.005
                                end
                            end)
                            task.Wait(9)
                        end
                    end)

                end
                task.New(self, function()
                    local d = 1
                    while true do
                        local x, _d_x = (-250 * d), (500 / 4 * d)
                        for _ = 1, 5 do
                            flow(x, 240)
                            task.Wait(12)
                            x = x + _d_x
                        end
                        d = -d
                        task.Wait(130)
                    end
                end)
            end)
        end)
    end

    non_sc1.other_drop = PassDrop
    non_sc2.other_drop = PassDrop
    non_sc3.other_drop = PassDrop
    non_sc4.other_drop = PassDrop
    non_sc5.other_drop = PassDrop
    non_sc6.other_drop = PassDrop
    non_sc7.other_drop = PassDrop
    sc1.other_drop = PassDrop
    sc2.other_drop = PassDrop
    sc3.other_drop = PassDrop
    sc4.other_drop = PassDrop
    sc5.other_drop = PassDrop
    sc6.other_drop = PassDrop
    sc7.other_drop = PassDrop
    sc8.other_drop = PassDrop
end --莉莉白