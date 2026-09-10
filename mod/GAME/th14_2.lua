local cos, sin, abs, min, sign = cos, sin, abs, min, sign
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
local _editor_class = _editor_class

do
    boss.Define("8a", "琪露诺", "TH14_0", TH14_bg, { 100, 400 }, _editor_class.TH14.SCBG1, "Chiruno", 12)
    local name = "不冻水「冰光熠熠，水波粼粼」"
    local sc1 = boss.card.New(name)
    local sc2 = boss.card.New(name)
    boss.card.add({ { sc1, "7a" }, { sc2, "8a" } }, 12, name, 129)
    function sc1:before()
        self.colli = false
        self.navi = true
        if ext.sc_pr then
            _editor_class.TH14.BossAction(self, 8840 - 60)
            task.MoveTo(-200, 50, 60, 2)
        end
    end
    function sc2:before()
        _editor_class.TH14.BossAction(self, 8840 - 60)
        task.MoveTo(-150, 160, 60, 2)
    end

    function sc1:init()
        task.New(self, function()
            task.Wait(700 - 60)
            _editor_class.TH14.JumpCard(self)
        end)
        task.New(self, function()
            local water_line = Class(object, {
                init = function(self, unit_table)
                    self.group = GROUP.INDES
                    self.layer = LAYER.ENEMY_BULLET - 1
                    self.unit_table = unit_table
                end,
                frame = function(self)
                    sp:UnitListUpdate(self.unit_table)
                    local flag
                    for _, o in ipairs(self.unit_table) do
                        if BoxCheck(o, lstg.world.boundl, lstg.world.boundr, lstg.world.boundb, lstg.world.boundt) then
                            flag = true
                            break
                        end
                    end
                    if not flag then
                        for _, o in ipairs(self.unit_table) do
                            object.Del(o)
                        end
                        object.Del(self)
                    end
                end,
                render = function(self)
                    SetImageState("white", "mul+add", 255, 64, 64, 255)
                    sp:UnitListUpdate(self.unit_table)
                    if #self.unit_table > 0 then
                        misc.RenderPointLine("white", self.unit_table, 1, true)
                    end
                end
            }, true)
            local water_drop = water_drop
            local water = Class(bullet, {
                init = function(self, x, y, v, a, c)
                    self.x, self.y = x, y
                    bullet.init(self, water_drop, 6, false, true)
                    object.SetV(self, v, a, true)
                    self._495 = true
                    self.bound = false

                    task.New(self, function()
                        while true do
                            c = c + 4
                            self._a = 128 + 127 * sin(c)
                            self.colli = self._a > 155
                            task.Wait()
                        end
                    end)
                end,
                frame = function(self)
                    bullet.frame(self)
                    bullet.ReBound(self, { "t" }, nil, self._495, function(o)
                        o._495 = false
                    end)
                end
            }, true)
            New(bullet_cleaner, self.x, self.y, 800, 40, 50)
            Newcharge_out(self.x, self.y, 64, 64, 255)
            task.New(self, function()
                self._wisys:SetImageInList("Wakasagihime")
                self.hscale = 0
                self.vscale = 0
                self.rot = 90
                self.navi = false
                for i = 1, 15 do
                    self.hscale = i / 15
                    self.vscale = i / 15
                    self.rot = 90 - 90 * sin(i * 6)
                    task.Wait()
                end
            end)
            task.MoveTo(0, 50, 60, 2)
            task.Wait(27)
            task.New(self, function()
                while true do
                    task.MoveToPlayer(75, -150, 150, 50, 100,
                            80, 100, 30, 40, 2, 1)
                    task.Wait(100)
                end
            end)
            local rrot = 45
            local d = 1
            while true do
                local t = {}
                PlaySound("water")
                for a, i in sp.math.AngleIterator(rrot, 240) do
                    table.insert(t, New(water, self.x, self.y, 2.2, a, i * 1.5))
                end
                New(water_line, t)
                -- rrot = rrot + 20
                d = -d
                for a in sp.math.AngleIterator(ran:Float(0, 360), 8) do
                    for v = 1, 5 do
                        NewSimpleBullet(water_drop, 8, self.x, self.y, 2.2 - v * 0.1, a - 2 + v * d * 2)
                        NewSimpleBullet(water_drop, 8, self.x, self.y, 2.2 - v * 0.1, a + 2 - v * d * 2)
                    end
                end
                task.Wait(200)
            end
        end)
    end
    function sc2:init()
        task.New(self, function()
            task.Wait(700 - 60)
            _editor_class.TH14.JumpCard(self)
        end)
        task.New(self, function()
            New(bullet_cleaner, self.x, self.y, 800, 40, 50)
            task.Wait(60)
            local d = 1
            local l
            while true do
                Newcharge_in(self.x, self.y, 65, 65, 255)
                for a in sp.math.AngleIterator(ran:Float(0, 360), 10) do
                    l = Create.laser_line(self.x, self.y, 6, 7, a, 30, 15, 8, 8)
                    l.timer = ran:Int(1, 12)
                    function l:frame_new()
                        laser.frame(self)
                        if self.timer % 12 == 0 then
                            local L = self.l1 + self.l2 + self.l3
                            New(_editor_class.TH14.Ice, self.x + cos(self.rot) * L, self.y + sin(self.rot) * L, 50)
                        end
                    end
                end
                task.Wait(40)

                task.New(self, function()
                    for x = 18 * sign(self.x), -18 * sign(self.x), -sign(self.x) do
                        bullet.SetLayer(NewSimpleBullet(ball_big, 6, x / 18 * 320, 240, ran:Float(2, 3), -90 + ran:Sign(),
                                nil, nil, false), LAYER.ENEMY_BULLET - 1)
                        PlaySound("tan00")
                        task.Wait()
                    end
                end)
                task.MoveTo(-self.x, self.y, 60, 2)
                Newcharge_out(self.x, self.y, 65, 65, 255)
                --New(_editor_class.TH14.Ice, self.x, self.y, 30)
                task.Wait(72)
                d = -d
            end
        end)
    end
end--wave8

do
    boss.DefineGroup({
        { id = "a", name = "赤蛮奇", x = 0, y = 400, img = "Sekibanki" },
        { id = "b", name = "今泉影狼", x = 0, y = 400, img = "Kagerou" }
    }, 9, "TH14_0", TH14_bg, _editor_class.TH14.SCBG2, 12)
    local name = "「无尽之首，无尽之食」"
    local sc1 = boss.card.New(name)
    local sc2 = boss.card.New(name)
    boss.card.add({ { sc1, "9a" }, { sc2, "9b" } }, 12, name, 130)
    function sc1:before()
        _editor_class.TH14.BossAction(self, 9540 - 60)
        task.MoveTo(0, 120, 60, 2)
    end
    function sc2:before()
        _editor_class.TH14.BossAction(self, 9540 - 60)
        task.MoveTo(0, 80, 60, 2)
    end

    function sc1:init()
        boss.card.UnlockOD(self, 9)
        task.New(self, function()
            task.Wait(700 - 60)
            _editor_class.TH14.JumpCard(self)
        end)
        task.New(self, function()
            local head = Class(object, {
                init = function(self, x, y, a, l, rotate, black)
                    --8行8列
                    self._wisys = BossWalkImageSystem(self)
                    self._wisys:SetImageInList("Sekibanki_head")
                    self.A, self.B = 12, 12
                    object.SetSize(self, 1.3)
                    self.bound = false
                    self.group = GROUP.INDES
                    self.layer = LAYER.ENEMY
                    self.x, self.y = x, y
                    self.bound = false
                    task.New(self, function()
                        local _a, _l = a, 0
                        for i = 1, 87 do
                            i = task.SetMode[2](i / 87)
                            _a = a + rotate * i
                            _l = l * i
                            self.x = x + cos(_a) * _l
                            self.y = y + sin(_a) * _l
                            task.Wait()
                        end
                        -- task.Wait(60)
                        self.bound = true
                        object.ChangingV(self, 0, 5, _a, 60, false, 1)
                    end)
                    self.color = { 218, 112, 214 }
                    if black then
                        _object.set_color(self, "", 255, 50, 50, 50)
                        self.color = { 100, 100, 100 }
                        self.black = true
                    end
                end,
                frame = function(self)
                    task.Do(self)
                    self._wisys:frame()
                    object.smear_add(self, 100)
                    object.smear_frame(self, 10)
                    object.EnemyDo(function(o)
                        if self.black and o.IsWolf and Dist(o, self) < 48 then
                            object.Del(self)
                        end
                    end)
                end,
                render = function(self)
                    object.smear_render(self, "mul+add", { 200, 50, 200 })
                    self._wisys:render()
                end,
                del = function(self)
                    enemy.death_ef(self.x, self.y, 10, 1)
                end
            }, true)

            PlaySound("boon00")
            self._wisys:SetImageInList("Sekibanki2")
            local d = 1
            while true do
                for a in sp.math.AngleIterator(ran:Float(0, 360), 30) do
                    for z = -1.5, 1.5 do
                        NewSimpleBullet(grain_a, 4, self.x, self.y, 1.5, a + z)
                    end
                end
                for a, i in sp.math.AngleIterator(ran:Float(-10, 10), 100) do
                    New(head, self.x, self.y + 24, a * d + 90 - 90 * d, 200, -90 * d, true)
                end
                boss.cast(self, 90)
                task.Wait(50)
                task.MoveToPlayer(75, -200, 200, 100, 140, 32, 64, 20, 40, 2, 3)
                task.Wait(50)
                d = -d
            end
        end)
    end
    function sc2:init()
        task.New(self, function()
            task.Wait(700 - 60)
            _editor_class.TH14.JumpCard(self)
        end)
        task.New(self, function()
            --task.Wait(100)
            Newcharge_in(self.x, self.y, 200, 200, 200)
            boss.cast(self, 60)
            PlaySound("wolf")
            for _ = 1, 44 do
                self.rot = self.rot + 6
                self.cast = self.cast + 1
                task.Wait()
            end
            self.rot = 0
            self.IsWolf = true
            self.colli = true
            self.A, self.B = 24, 24
            object.SetSize(self, 0)
            local S = function(x)
                if x == 0 then
                    return 1
                else
                    return sign(x)
                end
            end

            task.New(New(_editor_class.TH14.Wolf, self.x, self.y, 0, 220, 250, 250, 250, ""), function()
                local unit = task.GetSelf()
                unit.navi = false
                task.New(unit, function()
                    while true do
                        if not IsValid(self) then
                            object.Del(unit)
                            return
                        end
                        unit.rot = math.deg(math.atan2(self.dy, abs(self.dx))) * S(self.dx)
                        unit.hscale = S(self.dx)
                        unit.x, unit.y = self.x, self.y
                        task.Wait()
                    end
                end)
                unit.bound = false
                for i = 1, 10 do
                    object.SetSize(unit, i / 10)
                    task.Wait()
                end
            end)
            task.MoveTo(self.x, 640, 44, 2)
            while true do
                --task.Wait(60)
                self.x = player.x
                PlaySound("wolf")
                task.New(self, function()
                    for _ = 1, 40 do
                        New(_editor_class.TH14.Wolf_big, 6, self.x + ran:Float(-15, 15), self.y + ran:Float(-30, 30), 4, -90, 10, 0.5, ran:Float(-0.1, 0.1), 10)
                        task.Wait(2)
                    end
                end)
                task.MoveTo(self.x, -400, 85, 2)
                self.y = 640
                --  task.Wait()
            end
            --PlaySound("wolf")
        end)
    end

    local sc_od = boss.card.New("杀取「蛇行刃-Special」")
    boss.card.add({ { sc_od, "9a" } }, 12, "杀取「蛇行刃-Special」", 131, 9)
    function sc_od:before()
        _editor_class.TH14.BossAction(self, 9540 - 60)
        task.MoveTo(0, 180, 60, 2)
    end
    function sc_od:init()
        self.render_line = setmetatable({}, { __index = function(t, k)
            return t[sp:TweakValue(k, #t, 1)]
        end })
        task.New(self, function()
            task.Wait(1401 - 60)
            _editor_class.TH14.JumpCard(self)
        end)
        task.New(self, function()
            local array = {}
            local head = Class(object, {
                init = function(unit, cols, rows, start_event, render)
                    unit._wisys = BossWalkImageSystem(unit)
                    unit._wisys:SetImageInList("Sekibanki_head")
                    unit.A, unit.B = 5, 5
                    unit.bound = false
                    unit.group = GROUP.ENEMY_BULLET
                    unit.layer = LAYER.ENEMY_BULLET + 1
                    unit.cols = cols
                    unit.rows = rows
                    unit.colsx, unit.rowsy = (cols - 5.5) * 80, (rows - 5.5) * 80
                    if start_event then
                        task.New(unit, start_event)
                    else
                        unit.x, unit.y = unit.colsx, unit.rowsy
                        unit.continue = true
                    end
                    array[rows] = array[rows] or {}
                    array[rows][cols] = unit
                    if render then
                        self.render_line[#self.render_line + 1] = unit
                    end
                    unit.ddx, unit.ddy = 0, 0

                end,
                frame = function(self)
                    task.Do(self)
                    if self.continue then
                        task.New(self, function()
                            local x, y = 0, 0
                            local flag = (self.rows % 2 == 0)
                            if self.cols == 1 then
                                if (self.rows % 2 == 1) then
                                    y = -1
                                else
                                    x = flag and 1 or -1
                                end
                            elseif self.cols == 10 then
                                if (self.rows % 2 == 0) then
                                    y = 1
                                else
                                    x = flag and 1 or -1
                                end
                            else
                                x = flag and 1 or -1
                            end
                            self.ddx, self.ddy = x, y
                            self.cols = self.cols + x
                            self.rows = self.rows + y
                            task.MoveToEx(80 * x, 80 * y, 60, 3)
                            self.continue = true
                        end)
                        self.continue = false
                    end
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
            boss.cast(self, 90)
            PlaySound("tan00")
            for c = 1, 10 do
                for r = 1, 10 do
                    New(head, c, r, function()
                        local unit = task.GetSelf()
                        unit.x, unit.y = self.x, self.y + 24
                        --task.MoveToEx(0, 60, 30, 2)
                        task.MoveTo(unit.colsx, 150, 60, 2)
                        task.MoveTo(unit.colsx, unit.rowsy, 100, 3)
                        unit.continue = true
                    end, (c <= 5) and (c == r / 3) or (11 - c == r / 3))
                end
            end
            PlaySound("boon00")
            self._wisys:SetImageInList("Sekibanki2")
            task.Wait(115)
            task.MoveTo(0, 50, 60, 2)
            while true do
                for a in sp.math.AngleIterator(ran:Float(0, 360), 30) do
                    for v = 1, 3 do
                        NewSimpleBullet(grain_a, 4, self.x, self.y, 0.5 + 0.8 * v, a + v * 6)
                    end
                end
                PlaySound("tan00")
                task.MoveToPlayer(75, -96, 96, -96, 96, 20, 40, 20, 40, 2, 1)
                task.Wait(100)
            end
        end)

        self.killplayer = false
        task.New(self, function()
            while true do
                if self.killplayer then
                    player.class.colli(player, self)
                    self.killplayer = false
                end
                task.Wait()
            end
        end)
    end
    function sc_od:render()
        if self.render_line then
            SetImageState("white", "mul+add", 255, 255, 64, 64)
            sp:UnitListUpdate(self.render_line)
            local line = self.render_line
            local nopause = ext.pause_menu:IsKilled()
            local rot, len
            local dx, dy
            for i = 1, #self.render_line - 1 do
                rot = math.deg(math.atan2(line[i + 1].y - line[i].y, line[i + 1].x - line[i].x))
                len = Dist(line[i], line[i + 1])
                Render("white", line[i].x + (line[i + 1].x - line[i].x) / 2, line[i].y + (line[i + 1].y - line[i].y) / 2, rot, len / 16, 0.1)
                if nopause then
                    dx, dy = player.x - line[i].x, player.y - line[i].y
                    dx, dy = cos(rot) * dx + sin(rot) * dy, cos(rot) * dy - sin(rot) * dx
                    if dx >= 0 and dx <= len and abs(dy) < 2 then
                        self.killplayer = true
                    end
                end
            end
        end

    end
end --wave9

do
    boss.DefineGroup({
        { id = "a", name = "九十九弁弁", x = -400, y = 120, img = "Benben" },
        { id = "b", name = "九十九八桥", x = 400, y = 120, img = "Yatsuhashi" },
        { id = "c", name = "堀川雷鼓", x = 00, y = 400, img = "Raiko" },
    }, 10, "TH14_0", TH14_bg, _editor_class.TH14.SCBG3, 12)
    local name = "合奏「复鼓重振琴弦」"
    local sc1 = boss.card.New(name)
    local sc2 = boss.card.New(name)
    local sc3 = boss.card.New(name)
    boss.card.add({ { sc1, "10a" }, { sc2, "10b" }, { sc3, "10c" } }, 12, name, 132)
    function sc1:before()
        _editor_class.TH14.BossAction(self, 10240 - 60)
        task.MoveTo(-200, 180, 60, 2)
    end
    function sc2:before()
        _editor_class.TH14.BossAction(self, 10240 - 60)
        task.MoveTo(200, 180, 60, 2)
    end
    function sc3:before()
        _editor_class.TH14.BossAction(self, 10240 - 60)
        task.MoveTo(0, 120, 60, 2)
    end

    function sc1:init()
        task.New(self, function()
            task.Wait(702 - 60)
            _editor_class.TH14.JumpCard(self)
        end)
        task.New(self, function()
            while true do
                task.MoveTo(-self.x, self.y, 240, 3)
            end
        end)
        task.New(self, function()
            task.init_left_wait(self)
            while true do
                for a in sp.math.AngleIterator(ran:Float(0, 360), 48) do
                    New(_editor_class.TH14.music, 10, self.x, self.y, 1.8, a, 1)
                end
                PlaySound("kira00", 0.1, self.x / 400, true)
                task.Wait2(self, 87.6)
            end
        end)
    end
    function sc2:init()
        task.New(self, function()
            task.Wait(702 - 60)
            _editor_class.TH14.JumpCard(self)
        end)
        task.New(self, function()
            while true do
                task.MoveTo(-self.x, self.y, 240, 3)
            end
        end)
        task.New(self, function()
            task.init_left_wait(self)
            while true do
                for a in sp.math.AngleIterator(ran:Float(0, 360), 48) do
                    New(_editor_class.TH14.music, 8, self.x, self.y, 1.8, a, 2)
                end
                PlaySound("kira00", 0.1, self.x / 400, true)
                task.Wait2(self, 87.6)
            end
        end)
    end
    function sc3:init()
        task.New(self, function()
            task.Wait(702 - 60)
            _editor_class.TH14.JumpCard(self)
        end)
        task.New(self, function()
            local DRUM = _editor_class.TH14.drum
            local drum = Class(DRUM, {
                init = function(self, x, y, d, delay)
                    DRUM.init(self, x, y, true)
                    self._rot = 0
                    task.New(self, function()
                        task.MoveTo(230 * d, 0, 90, 2)
                        local a = 90 + 90 * d
                        local t = 0
                        while true do
                            self.x, self.y = cos(a) * 230, sin(a) * 80
                            a = a + sin(t)
                            t = min(t + 1, 90)
                            task.Wait()
                        end
                    end)
                    task.New(self, function()
                        task.init_left_wait(self)
                        task.Wait(delay)
                        while true do
                            NewBon(self.x, self.y, 60, 128, 250, 128, 114)
                            DRUM.don(self)
                            object.BulletDo(function(o)
                                if Dist(o, self) < 150 then

                                    if o.state == 1 then
                                        o.Velocity = 80
                                        o.Angle = Angle(o, self)
                                        Create.bullet_create_eff(o)
                                        task.New(o, function()
                                            local unit = task.GetSelf()
                                            task.MoveToEx(cos(unit.Angle) * unit.Velocity, sin(unit.Angle) * unit.Velocity, 80, 2)
                                        end)
                                    elseif o.state == 2 then
                                        o.Velocity = 30
                                        o.Angle = Angle(self, o)
                                        Create.bullet_create_eff(o)
                                        task.New(o, function()
                                            local unit = task.GetSelf()
                                            task.MoveToEx(cos(unit.Angle) * unit.Velocity, sin(unit.Angle) * unit.Velocity, 80, 2)
                                        end)
                                    end
                                end
                            end)
                            task.Wait2(self, 87.6 / 2)
                        end
                    end)
                end,
                frame = function(self)
                    DRUM.frame(self)
                    self._rot = math.deg(math.atan2(self.dy, self.dx))
                    local da = (self._rot - self.rot) % 360
                    if da > 180 then
                        da = da - 360
                    end
                    self.rot = self.rot + da * 0.2
                end
            }, true)
            New(drum, self.x, self.y, 1, 87.6 / 4)
            New(drum, self.x, self.y, -1, 87.6 / 2)
            local b
            task.init_left_wait(self)
            for _ = 1, 16 do
                boss.cast(self, 1)
                for a in sp.math.AngleIterator(ran:Float(0, 360), 52) do
                    for z = -1, 1 do
                        b = NewSimpleBullet(ellipse, 2, self.x - 5 + cos(a) * 30, self.y - 25 + sin(a) * 30, 2 - abs(z) * 0.02, a + z * 0.5)
                        b.flag = true
                        b._a = 30
                        b.colli = false
                        function b:frame_other()
                            bullet.ReBound(self, { "l", "r" }, nil, self.flag, function(self)
                                self.flag = nil
                                bullet.ChangeImage(self, self.imgclass, 1)
                                Create.bullet_create_eff(self)
                                self._a = 255
                                self.colli = true
                            end)
                        end
                    end
                end
                PlaySound("tan00", 0.1, 0, true)
                task.Wait2(self, 175.25)
            end
        end)
    end

    name = "音艺「高墙不阻绕梁音」"
    local _sc1 = boss.card.New(name)
    local _sc2 = boss.card.New(name)
    boss.card.add({ { _sc1, "10a" }, { _sc2, "10b" } }, 12, name, 133)
    function _sc1:before()
        self.colli = false
        if ext.sc_pr then
            _editor_class.TH14.BossAction(self, 10942 - 60)
            task.MoveTo(-200, 180, 60, 2)
        else
            task.Wait(60)
        end
    end
    function _sc2:before()
        self.colli = false
        if ext.sc_pr then
            _editor_class.TH14.BossAction(self, 10942 - 60)
            task.MoveTo(200, 180, 60, 2)
        else
            task.Wait(60)
        end
    end

    function _sc1:init()
        self._transport = New(Class(object, {
            init = function(self)
                self.group = GROUP.GHOST
                task.New(self, function()
                    while not self.finish do
                        task.Wait()
                    end
                    if self.getcard then
                        ext.achievement:get(33)
                    end
                    object.RawDel(self)
                end)
            end,
            frame = task.Do
        }, true))
        task.New(self, function()
            task.Wait(702 - 60)
            _editor_class.TH14.JumpCard(self)
        end)
        task.New(self, function()
            task.MoveTo(100, 140, 60, 2)
            local floor_table = {}
            local ate_table = {}
            local floor = Class(bullet, {
                init = function(self, state, index, x, my, t)
                    bullet.init(self, state, index, false, false)
                    self.x, self.y = x, 240
                    self.rot = -90
                    self.floor = true
                    floor_table[t] = floor_table[t] or {}
                    table.insert(floor_table[t], self)
                    bullet.SetLayer(self, LAYER.ENEMY_BULLET - 1)
                    task.New(self, function()
                        task.MoveTo(x, my, 40, 2)
                        -- task.Wait(30)
                        self.ag = 0.05
                    end)
                end
            }, true)
            local ate = Class(bullet, {
                init = function(self, state, index, x, t, sound)
                    bullet.init(self, state, index, false, false)
                    self.colli = false
                    self.rot = -90
                    self.x, self.y = x, 100
                    self.vy = 1
                    self.ag = 0.05
                    self.t = t
                    ate_table[t] = ate_table[t] or {}
                    table.insert(ate_table[t], self)
                    self.sound = sound
                    bullet.SetLayer(self, LAYER.ENEMY_BULLET + 1)
                end,
                frame = function(self)
                    bullet.frame(self)
                    if Dist(self, player) < 30 then
                        object.Del(self)
                        sp:UnitListUpdate(ate_table[self.t])
                        for _, p in ipairs(ate_table[self.t]) do
                            object.Del(p)
                        end
                        New(_editor_class.TH14.drum.boom, self.x, self.y)
                        PlaySound("lgods" .. self.sound, 1, 0, true)
                        sp:UnitListUpdate(floor_table[self.t])
                        for _, o in ipairs(floor_table[self.t]) do
                            if o._index == self._index then
                                object.Del(o)
                                Create.bullet_create_eff(o)
                            end
                        end
                    end
                end,
                render = function(self)
                    SetImageState("circle_charge", "mul+add", 128, unpack(ColorList[math.ceil(self._index / 2)]))
                    Render("circle_charge", self.x, self.y, 0, min(self.timer / 30, 1) * 30 / 256)
                    bullet.render(self)
                end
            }, true)
            --我主要操控
            task.Wait(27)
            local index
            local i = 1
            while true do
                index = ran:Int(1, 16)
                for x = -20, 20 do
                    New(floor, ball_big, index, x * 16, 160, i)
                    New(floor, music, index, x * 16, 160, i)
                end
                index = index + (ran:Int(0, 3) * 4 - 6)
                for x = -1.5, 1.5 do
                    New(ate, ball_big, sp:TweakValue(index + x * 4, 16, 1), x * 80, i, x + 2.5)
                    New(ate, music, sp:TweakValue(index + x * 4, 16, 1), x * 80, i, x + 2.5)
                end
                i = i + 1
                task.Wait(87)
            end
        end)
        task.New(self, function()
            task.Wait(87)
            boss.cast(self, 6000)
            while true do
                for a in sp.math.AngleIterator(ran:Float(0, 360), 23) do
                    bullet.GetNavi(NewSimpleBullet(music, 2, self.x, self.y, 1.8, a))
                end
                PlaySound("tan00", 0.1, 0, true)
                task.Wait(87)
            end
        end)
    end
    function _sc2:init()
        task.New(self, function()
            task.Wait(702 - 60)
            _editor_class.TH14.JumpCard(self)
        end)
        task.New(self, function()
            task.MoveTo(-100, 140, 60, 2)
            --主要操控在大姐那里
        end)
        task.New(self, function()
            task.Wait(87 + 44)
            boss.cast(self, 6000)
            while true do
                for a in sp.math.AngleIterator(ran:Float(0, 360), 23) do
                    bullet.GetNavi(NewSimpleBullet(music, 6, self.x, self.y, 1.8, a))
                end
                PlaySound("tan00", 0.1, 0, true)
                task.Wait(87)
            end
        end)
    end
end --wave10

do
    boss.DefineGroup({
        { id = "a", name = "鬼人正邪", x = 400, y = -450, img = "Seija" },
        { id = "b", name = "少名针妙丸", x = 0, y = 500, img = "Shinmyoumaru" },
    }, 11, "TH14_0", TH14_bg, _editor_class.TH14.SCBG4, 12)
    local name = "「后撤的大人」"
    local sc1 = boss.card.New(name)
    local sc2 = boss.card.New(name)
    boss.card.add({ { sc1, "11a" }, { sc2, "11b" } }, 12, name, 134)
    function sc1:before()
        _editor_class.TH14.BossAction(self, 11647 - 60)
        task.MoveTo(-player.x, 30, 60, 2)
    end
    function sc2:before()
        _editor_class.TH14.BossAction(self, 11647 - 60)
        self.bowl = New(_editor_class.TH14.Shinmyoumaru_Bowl, self)
        self.CAST = _editor_class.TH14.Shinmyoumaru_cast
        task.MoveTo(0, 180, 60, 2)
    end

    function sc1:init()
        boss.card.UnlockOD(self, 10)
        task.New(self, function()
            task.Wait(702 - 60)
            _editor_class.TH14.JumpCard(self)
        end)
        task.New(self, function()
            self.bullet = _editor_class.TH14.sejia2
            task.init_left_wait(self)
            while true do
                for z = -10, 10 do
                    for d = -1, 1, 2 do
                        New(self.bullet, grain_c, 16, 6, self.x, self.y, cos(z * 7 + 90), sin(z * 7 + 90), 180 * d - z * 5, 0, 0, 60)
                    end
                end
                for a, i in sp.math.AngleIterator(ran:Float(0, 360), 40) do
                    New(self.bullet, grain_c, 2, 4, self.x, self.y, cos(a) * 1.5, sin(a) * 1.5, (i % 2 * 2 - 1) * 47.25, 0, 90, -50)
                end
                task.Wait2(self, 87.6)
            end
        end)
        task.New(self, function()
            while true do
                object.BulletDo(function(o)

                    if o.wall and not o.flag and Dist(self, o) < 20 then
                        o.flag = true
                        o.vx, o.vy = -o.vx, -o.vy
                        bullet.ChangeImage(o, o.imgclass, 8)
                        Create.bullet_create_eff(o)
                    end
                end)
                self.x = self.x + (-self.x - player.x) * 0.03
                task.Wait()
            end
        end)
    end
    function sc2:init()
        task.New(self, function()
            task.Wait(702 - 60)
            _editor_class.TH14.JumpCard(self)
        end)
        task.New(self, function()
            self.bullet = ball_light
            task.init_left_wait(self)
            self:CAST(6000)
            while true do
                for a in sp.math.AngleIterator(ran:Float(0, 360), 100) do
                    local b = NewSimpleBullet(self.bullet, 2, self.x, self.y, 2, a)
                    b.wall = true
                end
                for a in sp.math.AngleIterator(Angle(self, player), 12) do
                    Create.laser_line(self.x, self.y, 8, 4, a, 30, 8, 5, 8)
                end
                PlaySound("kira00")
                task.Wait2(self, 87.6)
            end
        end)
    end

    local sc3 = boss.card.New("「弗拉维的盛大演出」")
    boss.card.add({ { sc3, "11b" } }, 12, "「弗拉维的盛大演出」", 135)
    function sc3:before()
        self.colli = false
        if ext.sc_pr then
            _editor_class.TH14.BossAction(self, 12349 - 60)
            self.bowl = New(_editor_class.TH14.Shinmyoumaru_Bowl, self)
            self.CAST = _editor_class.TH14.Shinmyoumaru_cast
            task.MoveTo(0, 180, 60, 2)
        else
            task.Wait(60)
        end
    end
    function sc3:init()
        task.New(self, function()
            task.Wait(702)
            _editor_class.TH14.JumpCard(self, true)
        end)
        task.New(self, function()
            local smear = function(index, x, y, v, a)
                rawset(Create.bullet_accel(x, y, grain_a, index, v, 3, a, nil, false, 25), "frame_new", function(self)
                    bullet.frame(self)
                    if self.timer == 60 then
                        object.Del(self)
                    end
                end)
            end
            local light = Class(bullet, {
                init = function(self, index, x, y, v, a)
                    bullet.init(self, ball_light, index, true, true)
                    self.x, self.y = x, y
                    self._vx, self._vy = v * cos(a) / 2, v * sin(a) / 2
                    self.rot = a
                    self.flag = 1
                    task.New(self, function()
                        while true do
                            for _ = 1, 2 do
                                self.x, self.y = self.x + self._vx, self.y + self._vy
                                self.timer = self.timer + 1
                                for A = 0, 180, 180 do
                                    A = A + self.timer * 3 + self.rot
                                    smear(self._index, self.x + cos(A) * 16, self.y + sin(A) * 16, 0.1, A)
                                end
                            end
                            self.timer = self.timer - 1
                            task.Wait()
                        end
                    end)
                end,
                frame = function(self)
                    bullet.frame(self)
                    if self.flag == 1 then
                        if self.x > 320 or self.x < -320 then
                            misc.ShakeScreen(20, 1)
                            Create.laser_line(self.x, self.y, 14, 10, 90 + 90 * sign(self.x), 40, 16)
                            for a in sp.math.AngleIterator(Angle(self, player), 40) do
                                smear(self._index, self.x, self.y, 1, a)
                            end
                            self.flag = 0
                        end
                        if self.y > 240 or self.y < -240 then
                            misc.ShakeScreen(20, 1)

                            self.flag = 0
                        end
                    end
                end
            }, true)
            local line = Class(object, {
                init = function(self, x, y, a, index)
                    self.x, self.y = x, y
                    self.rot = a
                    self.width = 0
                    self.index = index
                    self.group = GROUP.INDES
                    self.colli = false
                    task.New(self, function()
                        New(light, self.index, x, y, 10, self.rot)
                        for i = 0, 10 do
                            self.width = sin(i * 9)
                            task.Wait()
                        end
                        Create.laser_line(self.x, self.y, self.index, 10, self.rot, 60, 16, 8)
                        task.Wait(50)
                        for i = 14, 0, -1 do
                            self.width = sin(i * 6)
                            task.Wait()
                        end
                        object.RawDel(self)
                    end)
                end,
                frame = task.Do,
                render = function(self)
                    SetImageState("white", "mul+add", 60, unpack(ColorList[math.ceil(self.index / 2)]))
                    Render("white", self.x + cos(self.rot) * 400, self.y + sin(self.rot) * 400, self.rot, 50, 0.6 * self.width)
                    Render("white", self.x + cos(self.rot) * 400, self.y + sin(self.rot) * 400, self.rot, 50, 0.2 * self.width)
                end
            }, true)
            task.MoveTo(0, 120, 60, 2)
            task.Wait(27)
            local d = 1
            Newcharge_out(self.x, self.y, 255, 227, 132)

            while true do
                self:CAST(600)
                local A = Angle(self, player)
                for i = 0, 9 do
                    New(line, self.x, self.y, A + i * 36 * d, 14)
                    task.Wait(3)
                end
                task.New(self, function()
                    local _a = ran:Float(0, 360)
                    for i = 1, 10 do
                        for a in sp.math.AngleIterator(_a, 13) do
                            NewSimpleBullet(ball_big, 12, self.x, self.y, 5 - i / 5, a)
                        end
                        PlaySound("tan00")
                        task.Wait(12)
                    end
                end)
                task.New(self, function()
                    local l
                    local x, y = player.x, player.y
                    for i = 1, 120 do
                        l = 200 - i
                        for a in sp.math.AngleIterator(i * 10 * d, 5) do
                            bullet.SetLayer(NewSimpleBullet(ball_mid, 2,
                                    x + cos(a) * l, y + sin(a) * l, 8 - i / 20, a), LAYER.ENEMY_BULLET + 1)
                        end
                        task.Wait()
                    end
                end)
                task.Wait(60)
                task.MoveToPlayer(60, -200, 200, 100, 140,
                        80, 100, 20, 40, 2, 1)
                task.Wait()
                d = -d
            end
        end)
    end

    local sc_od = boss.card.New("「天邪鬼的能力是挪动屏幕-Special」")
    boss.card.add({ { sc_od, "11a" } }, 12, "「天邪鬼的能力是挪动屏幕-Special」", 136, 10)
    CreateRenderTarget("seija")
    function sc_od:before()
        _editor_class.TH14.BossAction(self, 11647 - 60)
        task.MoveTo(0, 120, 60, 2)
    end
    function sc_od:init()
        task.New(self, function()
            task.Wait(1472 - 60)
            _editor_class.TH14.JumpCard(self)
        end)
        task.New(self, function()
            object.Connect(self, New(Class(object, {
                init = function(self)
                    self.layer = LAYER.BG - 2
                end,
                render = function()
                    PushRenderTarget("seija")
                    RenderClear(Color(255, 0, 0, 0))
                end
            }, true)))
            local map = setmetatable({ 1, 2, 3, 6, 9, 8, 7, 4 }, {
                __index = function(t, k)
                    return t[sp:TweakValue(k, #t, 1)]
                end,
                __newindex = function(t, k, v)
                    t[sp:TweakValue(k, #t, 1)] = v
                end
            })
            self.nine = New(Class(object, {
                init = function(self)
                    self.layer = LAYER.TOP - 1
                    local w = lstg.world
                    local scr = screen
                    local k = scr.scale
                    function self.tox(x)
                        return (x - w.l + w.scrl) * k
                    end
                    function self.toy(y)
                        return (scr.height - y + w.b - w.scrb) * k
                    end
                    self.scale = { }
                    self.off = {}
                    self.pro = {}
                    for _ = 1, 9 do
                        table.insert(self.scale, { 1, 1 })
                    end
                    local dx, dy = 640 / 3, 480 / 3
                    for y = 1, -1, -1 do
                        for x = -1, 1 do
                            table.insert(self.off, { x * dx, y * dy })
                            table.insert(self.pro, { x * dx, y * dy })
                        end
                    end
                end,
                render = function(self)
                    PopRenderTarget("seija")
                    -- misc.RenderTexInSize("sejia", 0, 0, 0, 1,1,"",Color(255,255,255,255))
                    local blend = "one"
                    local color = Color(255, 255, 255, 255)
                    local hscale, vscale
                    local dx, dy = 640 / 6, 480 / 6
                    local z = 0.5
                    local x, y, px, py
                    local up = unpack
                    for t = 1, 9 do
                        hscale, vscale = up(self.scale[t])
                        x, y = up(self.off[t])
                        px, py = up(self.pro[t])
                        RenderTexture("seija", blend,
                                { x - dx * hscale, y + dy * vscale, z, self.tox(px - dx), self.toy(py + dy), color },
                                { x + dx * hscale, y + dy * vscale, z, self.tox(px + dx), self.toy(py + dy), color },
                                { x + dx * hscale, y - dy * vscale, z, self.tox(px + dx), self.toy(py - dy), color },
                                { x - dx * hscale, y - dy * vscale, z, self.tox(px - dx), self.toy(py - dy), color })
                    end
                end
            }, true))
            local function Exchange(p1, p2, t)
                task.New(self, function()
                    local x1, y1, x2, y2 = self.nine.off[p1][1], self.nine.off[p1][2], self.nine.off[p2][1], self.nine.off[p2][2]
                    for i = 1, t do
                        i = task.SetMode[2](i / t)
                        self.nine.scale[p1][1] = 1 - 0.2 * sin(i * 180)
                        self.nine.scale[p1][2] = 1 - 0.2 * sin(i * 180)
                        self.nine.scale[p2][1] = 1 - 0.2 * sin(i * 180)
                        self.nine.scale[p2][2] = 1 - 0.2 * sin(i * 180)
                        self.nine.off[p1][1] = x1 + (x2 - x1) * i
                        self.nine.off[p1][2] = y1 + (y2 - y1) * i
                        self.nine.off[p2][1] = x2 + (x1 - x2) * i
                        self.nine.off[p2][2] = y2 + (y1 - y2) * i
                        task.Wait()
                    end
                end)
            end
            object.Connect(self, self.nine)
            task.Wait(60)

            task.New(self, function()
                local last = 5
                local t = 2
                while true do
                    boss.cast(self, 60)
                    local off = sp:CopyTable(self.nine.off)
                    PlaySound("kira00")
                    for i = 1, 50 do
                        i = task.SetMode[2](i / 50)
                        for j = 1, 8 do
                            self.nine.off[map[j]][1] = off[map[j]][1] + (off[map[j + 1]][1] - off[map[j]][1]) * i
                            self.nine.off[map[j]][2] = off[map[j]][2] + (off[map[j + 1]][2] - off[map[j]][2]) * i
                            self.nine.scale[map[j]][1] = 1 - 0.2 * sin(i * 180)
                            self.nine.scale[map[j]][2] = 1 - 0.2 * sin(i * 180)
                        end
                        task.Wait()
                    end
                    t = t - 1
                    task.Wait(10)
                    PlaySound("kira00")
                    Exchange(map[t], last, 50)
                    task.Wait(60)
                    last, map[t] = map[t], last
                end
            end)
            self.bullet = _editor_class.TH14.Sejia_grain
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
                local d = 1
                while true do
                    for _ = 1, 7 do
                        for o = -1, 1 do
                            NewSimpleBullet(ball_big, 16, o * 640 / 3, 240, 2, -90)
                            NewSimpleBullet(ball_big, 16, o * 640 / 3, -240, 2, 90)
                            NewSimpleBullet(ball_big, 16, -320, o * 160, 2, 0)
                            NewSimpleBullet(ball_big, 16, 320, o * 160, 2, 180)
                        end
                        task.Wait(5)
                    end
                    task.Wait(87 - 35)
                    for i = 1, 30 do
                        self:shoot(self.x, self.y, i % 2 * 4 + 10, 130, i * 12, d * 0.5, -0.1, 0, 13, 3, 3)

                    end
                    d = -d
                    task.Wait(87)
                end
            end)
        end)
    end
end--wave11