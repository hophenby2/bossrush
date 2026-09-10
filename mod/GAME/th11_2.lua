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
local Newcharge_in, Newcharge_out = Newcharge_in, Newcharge_out
local class = _editor_class.TH11

local beat = 3600 / 178

LoadAniFromFile("small_frog", "mod\\GAME\\frog.png", nil, 3, 1, 10, 9, 9)

do
    boss.Define("7a", "古明地觉", "TH11_0", TH11_bg, { 0, 400 }, nil, "Satori", 7)
    local AutoNext = function(self)
        if self.is_combat then
            if self.timer >= 160 then
                if IsValid(self) then
                    self.hp = 0
                end
            end
            if player.death > 80 and not self.death_add and self._achievement and IsValid(self._achievement) then
                self._achievement.dead = self._achievement.dead + 1
                self.death_add = true
            end
        end
    end
    local DelBullet = function()
        object.BulletIndesDo(function(u)
            object.Kill(u)
        end)
        object.LaserDo(function(u)
            object.Kill(u)
        end)
    end
    local NewBefore = function(self, time)
        BossAction(self, 1942 + 161 * time)
        self.death_add = nil
        if ext.sc_pr then
            self.__NoCleanBullet = true
            self.__dieinstantly = true
            self.NotPlayTimeOutSound = true
            self.player_name = GetGlobal("player_name")
            task.MoveTo(0, 0, 60, 2)
        else
            task.Wait()
        end
    end
    local GetAchievement = Class(object, {
        frame = task.Do,
        init = function(self)
            self.dead = 0
            task.New(self, function()
                while self.dead < 4 do
                    task.Wait()
                end
                ext.achievement:get(40)
                object.Del(self)
            end)
        end
    })

    local card1 = boss.card.New("想起「所长之技」", 1, 1, 11, 80)
    function card1:before()
        self.__NoCleanBullet = true
        self.__dieinstantly = true
        self.__NoPlayerProtect = true
        self.player_name = GetGlobal("player_name")
        self._achievement = New(GetAchievement)
        BossAction(self, 1942)
        task.MoveTo(0, 0, 60, 2)
    end
    function card1:init()
        if self.player_name == "reimu_player" then
            New(class["object0-1_1"], self)
            New(class["object0-1_2"], self)
            task.New(self, function()
                local a = ran:Float(0, 360)
                local t = 0
                while true do
                    for i = 1, 2 do
                        for z = -2, 2 do
                            NewSimpleBullet(square, 1 + t, self.x, self.y, 2 + t * 0.5, a + z + 180 * i)
                        end
                    end
                    PlaySound("tan00", 0.1, 0, true)
                    t = t % 2 + 1
                    a = a + 7
                    task.Wait(3)
                end
            end)
        end
        if self.player_name == "marisa_player" then
            New(WhiteScreen)
            self.x = -250
            self.y = 160
            New(class["laser0-2"], self)
            task.New(self, function()
                task.Wait(60)
                task.MoveTo(250, 100, 100, 2)
            end)
        end
        if self.player_name == "aya_player" then
            for _ = 1, 100 do
                aya_player.NewSp(player, self.x, self.y)
            end
            task.New(self, function()
                local d = 1
                local b
                while true do
                    b = Create.laser_line(-350 * d, ran:Float(10, -60), 2, 40, ran:Float(-15, 15) + 90 - 90 * d, 15, 20, 16)
                    b.frame_new = function(self)
                        laser.frame(self)
                        local z
                        local x, y = self.x + cos(self.rot) * (self.l1 + self.l2 + self.l3), self.y + sin(self.rot) * (self.l1 + self.l2 + self.l3)
                        for _ = 1, 2 do
                            z = NewSimpleBullet(grain_b, 10, x + ran:Float(-45, 45), y + ran:Float(-45, 45),
                                    ran:Float(2, 4), 90 + ran:Float(-10, 10), false, 0, false)
                            z.ag = 0.06
                            z.maxvy = ran:Float(3, 4)
                            z.navi = true
                        end
                        NewSimpleBullet(grain_b, 10, x + ran:Float(-45, 45), y + ran:Float(-45, 45),
                                ran:Float(2, 4), 90 + ran:Float(-10, 10), false, 0, false)
                    end
                    d = -d
                    task.Wait(10)
                end
            end)
        end
        if self.player_name == "chiruno_player" then
            New(WhiteScreen)
            player.x, player.y = 0, -180
            task.New(self, function()
                for t = 1, 7 do
                    for i = 0, 60 do
                        NewSimpleBullet(ball_mid, t * 2, self.x, self.y, 3 + t, -90 + 30 + i / 60 * 300)
                    end
                end
                PlaySound("tan00")
                task.Wait(42)
                object.BulletDo(function(obj)
                    object.StopMoving(obj)
                    bullet.ChangeImage(obj, obj.imgclass, 16)
                    Create.bullet_create_eff(obj)
                    object.ChangeVwithTask(obj, 0, ran:Float(1, 3), ran:Float(0, 360), 150, 0, true)
                end)
            end)
        end
    end
    card1.frame = AutoNext
    card1.del = DelBullet
    boss.card.add({ { card1, "7a" } }, 7, "想起「所长之技」", 65)

    local card2 = boss.card.New("想起「所爱之物」", 1, 1, 11, 80)
    function card2:before()
        NewBefore(self, 1)
    end
    function card2:init()
        if self.player_name == "reimu_player" then
            New(WhiteScreen)
            player.x, player.y = 0, -180
            self.x, self.y = 0, 180
            local a = ran:Float(0, 360)
            for y = -160, 320, 48 do
                for i = -1, 1 do
                    New(class["bullet0-3"], y, 70, 180 + i * 10 + y + a, 1)
                    New(class["bullet0-3"], y, 70, i * 10 + y + a, -1)
                end
            end
            local y = -240
            for _ = 1, 40 do
                NewSimpleBullet(money, 14, -70, y, 0, ran:Float(0, 360), false, 3)
                NewSimpleBullet(money, 14, 70, y, 0, ran:Float(0, 360), false, -3)
                y = y + 480 / 39
            end
            task.New(self, function()
                for i = 1, 35 do
                    y = -240 + 480 - 480 * sin(90 - i / 35 * 90)
                    NewSimpleBullet(ball_huge, 4, -320, y, 5, 0, false, 0, false)
                    NewSimpleBullet(ball_huge, 4, 320, y, 5, 180, false, 0, false)
                    PlaySound("tan00", 0.1, 0, true)
                    task.Wait(4)
                end
            end)
        end
        if self.player_name == "marisa_player" then
            New(WhiteScreen)
            self.x = 0
            self.y = 0
            task.New(self, function()
                local c = math.ceil((player.x + 320) / 128) - 3
                local way = { [c] = true, time = 0 }
                while true do
                    for x = -3, 3 do
                        New(class["object0-3"], 10, x, way[x])
                    end
                    if way.time == 0 then
                        way.time = 1
                        c = max(-2, min(2, c + ran:Sign()))
                        way[c] = true
                    else
                        c = c
                        way = { [c] = true, time = 0 }
                    end
                    task.Wait(20)
                end
            end)

        end
        if self.player_name == "aya_player" then
            New(WhiteScreen)
            self.x, self.y = 0, 160
            for _ = 1, 100 do
                aya_player.NewSp(player, self.x, self.y)
            end
            New(class["object0-5"], self.x, self.y, 1.2, Angle(self, player))
        end
        if self.player_name == "chiruno_player" then
            task.New(self, function()
                local frog = Class(enemy, {
                    init = function(self)
                        enemybase.init(self, 10)
                        self.group = GROUP.NONTJT
                        self.layer = LAYER.ENEMY + 1
                        self.x = ran:Float(-320, 320)
                        self.y = 270
                        self.img = "small_frog"

                        self.omiga = ran:Sign() * ran:Float(8, 12)
                        self.death_ef = 3
                        self.bound = false
                        local a = ran:Float(-60, -120)
                        object.SetV(self, ran:Float(7, 8), a)
                        task.New(self, function()
                            while true do
                                NewSimpleBullet(ball_mid_c, 8, self.x, self.y, 4, a)
                                PlaySound("tan00", 0.14, 0, true)
                                task.Wait(5)
                            end
                        end)
                    end,
                    frame = enemybase.frame,
                    render = DefaultRenderFunc
                }, true)
                while true do
                    object.Connect(self, New(frog))
                    task.Wait(6)
                end
            end)
        end
    end
    card2.frame = AutoNext
    card2.del = DelBullet

    boss.card.add({ { card2, "7a" } }, 7, "想起「所爱之物」", 66)

    local card3 = boss.card.New("想起「所傲之宝」", 1, 1, 11, 80)
    function card3:before()
        NewBefore(self, 2)
    end
    function card3:init()
        if self.player_name == "reimu_player" then
            New(WhiteScreen)
            player.x, player.y = 0, -180
            self.x, self.y = 0, 0
            local d = ran:Sign()
            for i = 1, 6 do
                New(class["laser0-1"], i * 60, d*0.6)
            end
            task.New(self, function()
                local l = 6
                while true do
                    Create.laser_line(ran:Int(-32, 32) * 10, 240, 14, 8, -90, 10, 8, 15, 8)
                    l = l + 3
                    task.Wait(4)
                end
            end)
        end
        if self.player_name == "marisa_player" then
            task.New(self, function()
                Newcharge_in(self.x, self.y, 128, 32, 32)
                task.Wait(60)
                Newcharge_out(self.x, self.y, 128, 32, 32)
                local a, b
                misc.ShakeScreen(100, 2)
                PlaySound("nep00")
                for _ = 1, 100 do
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
                    for _ = 1, 6 do
                        b = NewSimpleBullet(ball_light, 14, self.x + cos(a) * 20, self.y + sin(a) * 20,
                                ran:Float(1.8, 2.3), a + ran:Float(-70, 70))
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

                    self.x, self.y = self.x + cos(a + 180), self.y + sin(a + 180)
                    task.Wait()
                end
                StopSound("nep00")
            end)
        end
        if self.player_name == "aya_player" then
            New(WhiteScreen)
            self.x, self.y = 0, 0
            for _ = 1, 100 do
                aya_player.NewSp(player, self.x, self.y)
            end
            task.New(self, function()
                while true do
                    New(class["object0-6"], self.x, self.y)
                    task.MoveToPlayer(40, -200, 200, -190, 190,
                            80, 100, 80, 100, 2, 0)
                end
            end)

        end
        if self.player_name == "chiruno_player" then
            task.New(self, function()
                local ice = Class(object, {
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
                                New(self.class, player.x, player.y, 50, true)
                            end
                        end
                    end,
                    render = function(self)
                        SetImgState(self, "mul+add", self._a, 255, 255, 255)
                        DefaultRenderFunc(self)
                    end
                }, true)
                task.New(self, function()
                    while true do
                        for a in sp.math.AngleIterator(ran:Float(0, 360), 8) do
                            local b = New(ice, self.x, self.y, 1000)
                            object.SetV(b, 4, a)
                            b.omiga = ran:Sign() * ran:Float(3, 5)
                        end
                        task.Wait(45)
                    end
                end)
                while true do
                    for a in sp.math.AngleIterator(ran:Float(0, 360), 24) do
                        Create.bullet_accel(self.x, self.y, ball_big, 6, 0.5, 3, a, false, false, 20, 45)
                    end
                    PlaySound("tan00")
                    task.Wait(31)
                end
            end)
        end
    end
    card3.frame = AutoNext
    card3.del = DelBullet

    boss.card.add({ { card3, "7a" } }, 7, "想起「所傲之宝」", 67)

    local card4 = boss.card.New("想起「所忘之事」", 1, 1, 11, 80)
    function card4:before()
        NewBefore(self, 3)
    end
    function card4:init()

        self.__NoPlayerProtect = nil
        self.__NoCleanBullet = nil
        if self.player_name == "reimu_player" then
            New(WhiteScreen)
            player.x, player.y = 0, -180
            New(class["object0-2"], 0, 180, self)
            task.New(self, function()
                local a = ran:Float(0, 360)
                local t = 1
                local A
                while true do
                    t = t % 2 + 1
                    for i = 1, 2 do
                        for z = -2, 2 do
                            A = a + z + 180 * i
                            Create.bullet_changeangle(self.x + cos(A + t * 90) * (20 - t * 10), self.y + sin(A + t * 90) * (20 - t * 10),
                                    square, 1 + t, 2.2 + t * 0.5, A, false,
                                    { wait = t * 10, time = 180, r = 1.4 - t })
                        end
                    end
                    PlaySound("tan00", 0.1, 0, true)
                    a = a - 7
                    task.Wait(2)
                end
            end)
        end
        if self.player_name == "marisa_player" then
            New(WhiteScreen)
            player.x, player.y = 0, -180
            task.New(self, function()
                while true do
                    New(class["object0-4"], ran:Float(-280, 280), ran:Float(-70, 70), 30, function(self)
                        local b
                        for _ = 1, 20 do
                            b = NewSimpleBullet(water_drop, 2, self.x + ran:Float(-30, 30), self.y + ran:Float(-30, 30),
                                    ran:Float(2, 4), ran:Float(0, 360))
                            b.ag = 0.02
                            b.maxv = 6
                            b.navi = true
                        end
                    end)
                    task.Wait(16)
                end
            end)

        end
        if self.player_name == "aya_player" then

        end
        if self.player_name == "chiruno_player" then
            task.New(self, function()
                local index = {}
                for i = 1, 16 do
                    index[i] = {  }
                    if i >= 3 and i <= 14 then
                        table.insert(index[i], 0)
                        table.insert(index[i], -16)
                        table.insert(index[i], 18)
                        if i >= 8 then
                            table.insert(index[i], 12)
                        end
                        if i == 8 then
                            for x = -10, -6 do
                                if x ~= -8 then
                                    table.insert(index[i], x)
                                end
                            end
                        end
                        if i == 3 or i == 8 or i == 14 then
                            for x = 13, 17 do
                                table.insert(index[i], x)
                            end
                        end
                        if i == 6 or i == 10 then
                            for x = 5, 9 do
                                table.insert(index[i], x)
                            end
                        end
                    end
                end
                for i = 6, 10 do
                    table.insert(index[i], -8)
                end
                for y = -7.5, 7.5 do
                    for _, x in ipairs(index[y + 8.5]) do
                        local b = NewSimpleBullet(ball_mid_c, 6, x * 16, y * 16, 1, 90 + ran:Float(-2, 2))
                        object.SetA(b, 0.03, -90 + ran:Float(-2, 2))
                    end
                    PlaySound("tan00")
                    task.Wait()
                end
            end)
        end
    end
    card4.frame = AutoNext
    card4.del = function(self)
        DelBullet(self)
        if self._achievement and IsValid(self._achievement) then
            object.Del(self._achievement)
        end
    end

    boss.card.add({ { card4, "7a" } }, 7, "想起「所忘之事」", 68)
end---wave3

do
    boss.Define("8a", "灵乌路空", "TH11_0", TH11_bg, { -400, 120 }, nil, "Utsuho", 7)
    boss.Define("8b", "火焰猫燐", "TH11_0", TH11_bg, { 0, 500 }, nil, "Rin", 7)

    local non_sc1 = boss.card.New("", 60, 60, 60, 60)
    function non_sc1:before()
        self.smear = {}
        BossAction(self, 2913)
        task.MoveTo(-250, 120, 60, 2)
    end
    function non_sc1:init()
        local aa = -90
        local b
        task.New(self, function()
            for _ = 1, 2 do
                task.MoveTo(400, 120 + ran:Float(-50, 50), 120, 3)
                aa = -90
                task.MoveTo(-400, 120 + ran:Float(-50, 50), 120, 3)
                aa = -90
            end
            task.MoveTo(-150, 50, 120, 3)
        end)
        task.New(self, function()
            for _ = 1, 138 do
                for v = 6, 1, -0.7 do
                    b = Create.bullet_accel(self.x, self.y, ball_big, 4, 0.5, v, aa, true)
                    b.wait = 30
                    b.time = 30
                end
                PlaySound("tan00")
                aa = aa + 180 + self.dx
                task.Wait(4)
            end
        end)
        task.New(self, function()
            task.Wait(647)
            local A
            for _ = 1, 8 do
                A = Angle(self, player)
                task.New(self, function()
                    for _ = 1, 15 do
                        for i = 1, 8 do
                            b = Create.bullet_accel(self.x, self.y, ball_big, 13, 0.5, 6, A + i * 45, true)
                            b.wait = 30
                            b.time = 30
                        end
                        PlaySound("tan00")
                        task.Wait(4)
                    end
                end)
                task.MoveToPlayer(81, -250, 250, 50, 144,
                        40, 50, 30, 60, 2, 3)
            end
            task.MoveTo(0, 500, 81, 3)
            self._bosssys:SpecialCheckGetCard()
            object.Del(self)
        end)
    end
    function non_sc1:frame()
        table.insert(self.smear, { x = self.x, y = self.y + 4 * sin(self.ani * 4), rot = self.rot,
                                   alpha = 150, img = self.img, hscale = self.hscale, vscale = self.vscale })
        for _, s in ipairs(self.smear) do
            s.alpha = max(0, s.alpha - 8)
        end
        for i = #self.smear, 1, -1 do
            if self.smear[i].alpha == 0 then
                table.remove(self.smear, i)
            end
        end
    end
    function non_sc1:render()
        for _, s in ipairs(self.smear) do
            SetImageState(s.img, "mul+add", s.alpha, 255, 227, 132)
            Render(s.img, s.x, s.y, s.rot, s.hscale, s.vscale)
        end
    end
    boss.card.add({ { non_sc1, "8a" } }, 7, "第三回合", 69)

    local non_sc2 = boss.card.New("", 60, 60, 60, 60)
    function non_sc2:before()
        BossAction(self, 3520)
        task.MoveTo(0, 100, 60, 2)
    end
    function non_sc2:init()
        task.New(self, function()
            local event = {
                function()
                    task.MoveToPlayer(60, -120, 120, 90, 120,
                            80, 160, 16, 32, 2, 3)
                    task.Wait(25)
                end,
                function()
                    task.MoveToPlayer(60, -120, 120, 90, 120,
                            80, 160, 16, 32, 2, 3)
                    task.Wait(86)
                end,
                function()
                    task.MoveToPlayer(60, -120, 120, 90, 120,
                            80, 160, 16, 32, 2, 3)
                    task.Wait(86)
                end,
                function()
                    local self = task.GetSelf()
                    task.MoveTo(300, 300, 120, 2)
                    self._bosssys:SpecialCheckGetCard()
                    object.Del(self)
                end
            }
            local da = { 0, 0, 185, 175 }
            local rot, l, t, a, b, x, y
            local d = 1
            for i = 1, 4 do
                PlaySound("kira00", 1, self.x / 200)
                rot = ran:Float(0, 360)
                l = 20
                t = 100
                for _ = 1, 16 do
                    for j = 1, 15 do
                        a = rot + 24 * j
                        x, y = self.x + cos(a) * l, self.y + sin(a) * l
                        if Dist(player.x, player.y, x, y) >= 60 then
                            b = Create.bullet_accel(x, y, grain_b, ({ 2, 6 })[i % 2 + 1], 0, 4, a + da[i])
                            b.wait = t
                            b.time = 60
                        end
                    end
                    task.Wait()
                    rot = rot + 2.3 * d
                    l = l + 500 / 15
                    t = t - 4
                end
                d = -d
                event[i]()
            end
        end)
    end
    boss.card.add({ { non_sc2, "8b" } }, 7, "第三回合", 70)
end---wave4

do
    boss.Define("9a", "古明地恋", "TH11_0", TH11_bg, { 400, 120 }, class["SCBG1"], "Koishi", 7)
    boss.Define("9b", "古明地觉", "TH11_0", TH11_bg, { -400, 120 }, class["SCBG1"], "Satori", 7)
    local non_sc1 = boss.card.New("", 60, 60, 60, 60)
    function non_sc1:before()
        BossAction(self, 4166)
        task.MoveTo(0, 120, 60, 2)
    end
    function non_sc1:init()
        local b
        local function shootb(x, y, col, v, a)
            b = Create.bullet_accel(x, y, ball_mid_c, col, 0, v, a, true)
            if Dist(player.x, player.y, x, y) < 50 then
                object.Del(b)
            end
        end
        task.New(self, function()
            boss.cast(self, 666)
            local s = 90
            local a, x, y
            for i = -1, 1, 2 do
                s = 90
                PlaySound("nice", 1, 150, false)
                for _ = 1, 6 do
                    a = Angle(self, player)
                    for j = 1, 20 do
                        NewSimpleBullet(grain_a, 6 + 4 * i, cos(s) * 200, sin(s) * 200, 1.5, a + j * 18)
                    end
                    task.Wait(2)
                    s = s - 140 / 5 * i
                end
                task.Wait(8)
            end
            task.Wait(21)
            local a1, a2 = 0, 180
            local rs = 0
            for j = 1, 320 - 60 do
                self.x = sin(j / 320 * 360) * 150 * sin(min(j, 90))
                if j % 2 == 1 then
                    x, y = sp.math.EllipsePoint(self.x, self.y, 130 * sin(rs), 40 * sin(rs), 45, a1)
                    shootb(x, y, 6, 4.5, a1)
                    shootb(x, y, 2, 3, a2)
                    x, y = sp.math.EllipsePoint(self.x, self.y, 130 * sin(rs), 40 * sin(rs), -45, a2)
                    shootb(x, y, 6, 4.5, a2)
                    shootb(x, y, 2, 3, a1)
                    PlaySound("tan00", 0.1, 0, true)
                    a1 = a1 + 7
                    a2 = a2 - 7
                end
                task.Wait()

                rs = rs + 180 / 359

            end
            task.Wait(1 + 60)
            task.New(self, function()
                task.MoveTo(0, 120, 60, 2)
                task.Wait(60)
                task.MoveToPlayer(60, -170, 170, -120, 120,
                        32, 64, 16, 32, 2, 2)
                task.Wait(60)
                task.MoveTo(0, 0, 60, 2)
                task.Wait()
                boss.cast(self, 120 * 60)
            end)
            task.New(self, function()
                local ca = 45
                for _ = 1, 4 do
                    NewSimpleBullet(heart, 10, self.x, self.y, 4.6, Angle(self, player))
                    PlaySound("tan00")
                    task.Wait(30)
                    NewSimpleBullet(heart, 10, self.x, self.y, 4.6, Angle(self, player))
                    PlaySound("tan00")
                    task.Wait(51)
                    ca = ca + 45
                end
            end)
            for _ = 1, 15 do
                a = Angle(self, player) - 90
                for _ = 1, 2 do
                    for v = 1, 16 do
                        Create.bullet_dec_setangle(self.x, self.y, grain_a, 4,
                                { v = v + 0.5, a = a, time = 60, wait = 0 }, { v = 3.8, a = Angle(self, player) })
                        Create.bullet_dec_setangle(self.x, self.y, grain_a, 4,
                                { v = v + 0.5, a = a, time = 60, wait = 0 }, { v = 3.8, a = Angle(self, player) + 180 })
                    end
                    a = a + 180
                end
                task.Wait(20)
            end
        end)
        task.New(self, function()
            task.Wait(707)
            local d = 1
            local ca = 45
            local a
            for _ = 1, 4 do
                a = 90
                for _ = 1, 15 do
                    for _ = 1, 2 do
                        shootb(cos(a) * 160, sin(a) * 160, 2, 2, a + 15 * d)
                        a = a + 180 / 29 * d
                    end
                    PlaySound("tan00")
                    task.Wait(2)
                end
                a = -90
                for _ = 1, 15 do
                    for _ = 1, 2 do
                        shootb(cos(a) * 80, sin(a) * 80 - 80, 6, 2, a - 15 * d)
                        a = a - 180 / 29 * d
                    end
                    PlaySound("tan00")
                    task.Wait(2)
                end
                d = -d
                task.Wait(20)
                ca = ca + 45
            end
        end)
        task.New(self, function()
            task.Wait(981)
            task.MoveTo(100, -400, 60, 2)
            task.Wait(1335 - 1041)
            self.hp = 0
        end)
    end
    boss.card.add({ { non_sc1, "9a" } }, 7, "第四回合", 71)
    local non_sc2 = boss.card.New("", 60, 60, 60, 60)
    function non_sc2:before()
        BossAction(self, 5178)
        task.MoveTo(0, 120, 60, 2)
    end
    function non_sc2:init()
        task.New(self, function()
            for i = 1, 3 do
                task.MoveToPlayer(60, -200, 200, 100, 144,
                        80, 100, 20, 40, 2, 3)
                task.Wait(21)
            end
        end)
        task.New(self, function()
            local s = 90
            local a = 0
            local r = 0
            local t = 1
            while true do
                for z = 0, 1 do
                    for j = -1, 1, 2 do
                        Create.bullet_decel(self.x + cos(-90 + r * j + z * 180) * sin(s) * 100, self.y + sin(-90 + r * j + z * 180) * sin(s) * 100,
                                grain_a, ({ 2, 6 })[t % 2 + 1], 6, 2, -90 + a * j + z * 180)
                        if t % 15 == 0 then
                            Create.bullet_decel(self.x, self.y, ball_huge, ({ 6, 2 })[t % 2 + 1], 5, 2.5, -90 + a * j + z * 180)
                        end
                    end
                end
                PlaySound('tan00', 0.1, 0, true)
                a = a + 1.2
                r = r + 24
                s = s + 0.8
                t = t + 1
                task.Wait()
            end
            self.hp = 0

        end)
        task.New(self, function()
            task.Wait(1335 - 1012)
            self.hp = 0
        end)
    end
    boss.card.add({ { non_sc2, "9b" } }, 7, "第四回合", 72)

    local name = "「恐惧为梦，两线为醒」"
    local sc1 = boss.card.New(name, 60, 60, 60, 60)--恋
    local sc2 = boss.card.New(name, 60, 60, 60, 60)--觉
    boss.card.add({ { sc1, "9a" }, { sc2, "9b" } }, 7, name, 73)
    function sc1:before()
        BossAction(self, 5501)
        if ext.sc_pr then
            self.x = 100
            self.y = -400
            task.Wait(60)
        end
    end
    function sc1:init()
        self.angle = 0
        self.line_angle = 0
        self.line_color = {}
        task.New(self, function()
            while self.timer < 910 do
                task.Wait()
            end
            self.hp = 0
        end)
        task.New(self, function()
            task.CRMoveTo(300, 3, -300, 0, -300, 200, 0, 200)
            local c = 90
            local d = 0
            while true do
                self.x = cos(c) * 200
                self.y = sin(c) * 200
                d = min(d + 1, 90)
                c = c - 0.7 * sin(d)
                task.Wait()
            end
        end)
        task.New(self, function()
            local a = 0
            local b, x, y
            while true do
                for i = 1, 2 do
                    x, y = sp.math.EllipsePoint(self.x, self.y, 70, 0, self.angle + 90, self.line_angle + i * 180)
                    if Dist(player.x, player.y, x, y) > 50 then
                        b = NewSimpleBullet(heart, 6 * i - 2, x, y, 0.1, a + i * 180)
                        if self.line_angle % 360 > 179 then
                            bullet.SetLayer(b, -200 + i)
                        else
                            bullet.SetLayer(b, -200 - i)
                        end
                        PlaySound("tan00", 0.2, self.x / 300, true)
                        task.New(b, function()
                            local self = task.GetSelf()
                            task.Wait(100)
                            object.Del(self)
                        end)
                    end
                end
                task.Wait(2)
                a = a - 5
            end
        end)
    end
    function sc1:frame()
        if not self.is_combat then
            return
        end
        self.line_angle = self.line_angle + 2.8
        self.angle = math.deg(math.atan2(self.dy, self.dx))
        local x, y
        local _x, _y, _rot
        for i = 1, 2 do
            x, y = sp.math.EllipsePoint(self.x, self.y, 70, 0, self.angle + 90, self.line_angle + i * 180)
            _x = player.x - x
            _y = player.y - y
            _rot = self.line_angle / 10 * i + i * 180
            _x, _y = _x * cos(_rot) + _y * sin(_rot), _y * cos(_rot) - _x * sin(_rot)
            if abs(_y) < 16 then
                self.line_color[i] = { 250, 128, 114 }
                for _, p in ipairs(sp.geom.LinePointWorld(sp.geom.NewLine(sp.geom.NewPoint(x, y), sp.geom.NewPoint(x + cos(_rot), y + sin(_rot))))) do
                    Create.bullet_accel(p[1], p[2], heart, 2, 0.2, 2, Angle(p[1], p[2], x, y))
                end
            else
                self.line_color[i] = nil
            end
        end
    end
    function sc1:render()
        if not self.is_combat then
            return
        end
        local a = 128 * min(self.timer / 90, 1)
        local x, y, rot

        for i = 1, 2 do
            x, y = sp.math.EllipsePoint(self.x, self.y, 70, 0, self.angle + 90, self.line_angle + i * 180)
            rot = self.line_angle / 10 * i + i * 180
            SetImageState("white", "mul+add", a / 2, unpack(self.line_color[i] or ColorList[3 * i - 1]))
            Render("white", x, y, rot, 100, 0.5)
            Render("white", x, y, rot, 100, 1)
        end
    end

    function sc2:before()
        BossAction(self, 5501)
        if ext.sc_pr then
            task.MoveTo(0, 120, 60, 2)
        end
    end
    function sc2:init()
        task.New(self, function()
            while self.timer < 910 do
                task.Wait()
            end
            self.hp = 0
        end)
        task.New(self, function()
            local d = 1
            while true do
                Newcharge_out(self.x, self.y, 128, 32, 32)
                task.New(self, function()
                    local a, b
                    for i = 1, 50 do
                        for w = 1, 6 do
                            a = w * 60 + i * 18 * d
                            b = Create.bullet_changeangle(self.x, self.y, ball_mid, 14, 2, a, false, { r = (i % 2 * 2 - 1) * (1 + i / 80), time = 100, wait = i / 2 })
                            bullet.SetLayer(b, -98)
                        end
                        PlaySound("tan00")
                        task.Wait(3)
                    end
                end)
                task.MoveToPlayer(60, -180, 180, 120, 180,
                        60, 80, 30, 40, 2, 1)
                for i = 1, 30 do
                    New(class["laser0-3"], self.x, self.y, i * 12, 1.2 * d, 1.5, i * 12, 120)
                end
                task.Wait(320)
                d = -d
            end
        end)
    end
end---wave5

do
    boss.Define("10a", "琪斯美", "TH11_0", TH11_bg, { -120, 400 }, class["SCBG2"], "Kisume", 7)
    boss.Define("10b", "黑谷山女", "TH11_0", TH11_bg, { 120, 400 }, class["SCBG2"], "Yamame", 7)
    local name = "井网「满布蛛网之天」"
    local sc1 = boss.card.New(name, 60, 60, 60, 60)
    local sc2 = boss.card.New(name, 60, 60, 60, 60)
    boss.card.add({ { sc1, "10a" }, { sc2, "10b" } }, 7, name, 74)
    function sc1:before()
        BossAction(self, 6472)
        task.MoveTo(-180, 60, 60, 2)
    end
    function sc1:init()
        task.New(self, function()
            while self.timer < 906 do
                task.Wait()
            end
            self.hp = 0
        end)
        task.New(self, function()
            while true do
                Newcharge_in(self.x, self.y, 200, 200, 200)
                task.Wait(60)
                local x
                task.New(self, function()
                    while self.y > -240 do
                        task.Wait()
                    end
                    misc.ShakeScreen(20, 1.2)
                    x = self.x
                    PlaySound("water", 0.1, x / 100)
                    for i = 1, 12 do
                        for j = 1, 3 do
                            NewSimpleBullet(water_drop, 6, x, -240, 1.5 + j * 0.5, i * 30 + j * 15)
                        end
                    end
                    local b
                    local d = 1
                    for _ = 1, 3 do
                        b = Create.bullet_decel(x, -240, ball_big, 4, ran:Float(5, 8), 0, ran:Float(20, 160))
                        b.lifetime = ran:Int(50, 120)
                        b.d = d
                        b.frame_new = function(self)
                            bullet.frame(self)
                            if self.timer >= self.lifetime then
                                object.Del(self)
                                local c = New(tasker, function()
                                    local _d = self.d
                                    local _x, _y = self.x, self.y
                                    local a = Angle(_x, _y, player.x, player.y)
                                    for c = 1, 8 do
                                        NewSimpleBullet(knife, 2, _x, _y, 4, a)
                                        _x, _y = _x - cos(a), _y - sin(a)
                                        a = a + _d * 0.5
                                        PlaySound("tan00")
                                        task.Wait(4)
                                    end
                                end)
                                c.group = GROUP.ENEMY_BULLET
                            end
                        end
                        task.Wait(4)
                        d = -d
                    end
                end)
                for i = 1, 60 do
                    object.SetV(self, sin(i * 1.5) * 7, -90)
                    task.Wait()
                end
                while self.y > -400 do
                    task.Wait()
                end
                self.vy = 0
                self.y = 500
                self.x = -self.x + ran:Float(-50, 50)
                task.MoveTo(self.x, ran:Float(80, 120), 40, 2)
            end
        end)
    end

    function sc2:before()
        BossAction(self, 6472)
        task.MoveTo(0, 0, 60, 2)
        player.x, player.y = 0, -180
        New(WhiteScreen)
    end
    function sc2:init()
        task.New(self, function()
            while self.timer < 906 do
                task.Wait()
            end
            self.hp = 0
        end)
        task.New(self, function()
            self.angle = 0
            self.shoot = function(way)
                local a = way * 36
                for _ = 1, 86 do
                    New(class["bullet0-4"], self.x + cos(a + self.angle) * 500, self.y + sin(a + self.angle) * 500, a + 180 + self.angle, 3, 0, self)
                    a = a + 324 / 85
                end
            end
            local l = 1
            local cao = {}
            local x, y
            boss.cast(self, 6666)
            for _ = 1, 25 do
                for i = 1, 10 do
                    x, y = self.x + cos(i * 36 + self.angle) * l, self.y + sin(i * 36 + self.angle) * l
                    if Dist(player.x, player.y, x, y) > 30 then
                        New(class["bullet0-4"], x, y, i * 36 + 180, 3, 60, self)
                    end
                end
                l = l + 18
                task.Wait(2)
            end
            task.Wait(30)
            task.New(self, function()
                task.New(self, function()
                    task.Wait(90)
                    local d = 1
                    while true do
                        d = d + 1
                        self.angle = self.angle - 0.6 * sin(d)
                        task.Wait()
                    end
                end)
                local t = 8
                while true do
                    self.shoot((t - 1) % 10 + 1)
                    cao = { [(t - 1) % 10 + 1] = true }
                    task.Wait(70)
                    t = t + 1
                end
            end)
            while true do
                for i = 1, 10 do
                    x, y = self.x + cos(i * 36 + self.angle) * 500, self.y + sin(i * 36 + self.angle) * 500
                    New(class["bullet0-4"], x, y, i * 36 + 180 + self.angle, 3, 0, self, cao[i])
                end
                task.Wait(6)
            end
        end)
    end
end---wave6

do
    boss.Define("11a", "水桥帕露西", "TH11_0", TH11_bg, { -400, -400 }, class["SCBG3"], "Parsee", 7)
    boss.Define("11b", "星熊勇仪", "TH11_0", TH11_bg, { 400, -400 }, class["SCBG3"], "Yugi", 7)
    local name = "妒力「艸道，茻道」"
    local sc1 = boss.card.New(name, 60, 60, 60, 60)
    local sc2 = boss.card.New(name, 60, 60, 60, 60)
    boss.card.add({ { sc1, "11a" }, { sc2, "11b" } }, 7, name, 75)

    function sc1:before()
        BossAction(self, 7443)
        task.MoveTo(-180, 60, 60, 2)
    end
    function sc1:init()
        New(class["FakeParsee"], 180, 60)
        task.New(self, function()
            while self.timer < 885 do
                task.Wait()
            end
            self.hp = 0
        end)
        task.New(self, function()
            boss.cast(self, 999)
            task.Wait(60)
            task.New(self, function()
                task.Wait(60)
                local a = 180
                local c = 0
                while true do
                    c = min(c + 1, 90)
                    a = a + 0.9 * sin(c)
                    self.x, self.y = cos(a) * 180, sin(a) * 60 + 60
                    task.Wait()
                end
            end)
            local a = -90
            local c = -90
            while true do
                Create.bullet_accel(self.x + cos(a) * 50, self.y + sin(a) * 50, grain_a, 10, 0, 2, c)
                PlaySound("tan00", 0.1, self.x / 100, true)
                a = a + 3
                c = c - 2
                task.Wait(2)
            end
        end)
    end

    function sc2:before()
        BossAction(self, 7443)
        task.MoveTo(0, 60, 60, 2)
    end
    function sc2:init()
        task.New(self, function()
            while self.timer < 885 do
                task.Wait()
            end
            self.hp = 0
        end)
        task.New(self, function()
            local b
            self.shoot = function(x, a)
                return function()
       --             NewSimpleBullet(ball_small, 14, x, 260, ran:Float(0.5, 1.2), ran:Float(0, -180))
                    for _ = 1, ran:Int(6, 12) do
                        PlaySound("tan00", 0.1, x / 100, true)
                        b = NewSimpleBullet(ellipse, 10, x, 260, 4.5, a)
                        b._blend = "mul+add"
                        b.ag = 0.033

                        b.navi = true
                        task.Wait(4)
                    end
                end
            end

            boss.cast(self, 999)
            Newcharge_out(self.x, self.y, 255, 227, 132)
            for i = 1, 100 do
                b = NewSimpleBullet(ellipse, 10, self.x, self.y, ran:Float(4, 11), ran:Float(30, 150), false, 0, false)
                b._blend = "mul+add"
            end
            task.Wait(60)
            local c = -90
            while true do
                task.New(self, self.shoot(350 * LineNum(c), -90 + 16 * cos(c * 2.3)))
                c = c + 11
                task.Wait(4)
            end
        end)
    end
end---wave7

do

    boss.Define("12a", "火焰猫燐", "TH11_0", TH11_bg, { 400, 100 }, class["SCBG4"], "Rin", 7)
    boss.Define("12b", "灵乌路空", "TH11_0", TH11_bg, { 0, 500 }, class["SCBG4"], "Utsuho", 7)
    local name = "「岩屑上的活魂啊，跟我走吧」"
    local sc1 = boss.card.New(name, 60, 60, 60, 60)
    local sc2 = boss.card.New(name, 60, 60, 60, 60)
    boss.card.add({ { sc1, "12a" }, { sc2, "12b" } }, 7, name, 76)

    function sc1:before()
        BossAction(self, 8495)
        task.MoveTo(-170, 150, 60, 2)
    end
    function sc1:init()
        task.New(self, function()
            while self.timer < 1294 - 60 do
                task.Wait()
            end
            self.hp = 0
        end)
        task.New(self, function()
            local rot, l, t, a, b, x, y
            local d = 1
            while true do
                boss.cast(self, 90)
                PlaySound("kira00", 0.5, self.x / 200, true)
                rot = 0
                l = 20
                t = 100
                for _ = 1, 60 do
                    for j = 1, 15 do
                        a = rot + 24 * j
                        x, y = self.x + cos(a) * l, self.y + sin(a) * l
                        if Dist(player.x, player.y, x, y) >= 60 then
                            b = Create.bullet_accel(x, y, grain_b, 9 - d, 0, 4, a)
                            b.wait = t
                            b.time = 60
                            bullet.SetLayer(b, LAYER.ENEMY_BULLET + 5)
                        end
                    end
                    task.Wait()
                    rot = rot + d * 0.6
                    l = l + 700 / 59
                    t = t - 1
                end
                d = -d
                task.Wait(40)
                PlaySound("kira00", 0.4, self.x / 200, true)
                local s = ran:Float(0.5, 1)
                for i = 1, 80 do
                    New(class["bullet0-6wheel"], self.x, self.y, i * 4.5, 180, d * 0.7, s, 0, -1)
                end
                for i = 1, 15 do
                    New(class["laser0-4wheel"], self.x, self.y, i * 24, 180, -d * 0.7, s, 0, -1)
                end
                task.Wait(30)
                task.MoveTo(-self.x, 150, 60, 2)
                task.Wait()
            end
        end)
    end

    function sc2:before()
        BossAction(self, 8495)
        task.MoveTo(0, 160, 60, 2)
    end
    function sc2:init()
        task.New(self, function()
            while self.timer < 1294 - 60 do
                task.Wait()
            end
            self.hp = 0
        end)
        task.New(self, function()
            boss.cast(self, 1294)
            New(class["Nuclear1"], self.x, self.y)
            for i = 1, 4 do
                New(class["Nuclear2"], self.x, self.y, i * 90, 30, 1)
            end
            for i = 1, 4 do
                New(class["Nuclear2"], self.x, self.y, i * 90, 60, -1)
            end
        end)
    end
end---wave8

do
    boss.Define("13a", "东风谷早苗", "TH11_0", TH11_bg, { 0, 400 }, class["SCBG5"], "Sanae", 7)
    boss.Define("13b", "古明地恋", "TH11_0", TH11_bg, { -400, 400 }, class["SCBG5"], "Koishi", 7)
    local name = "「涌泉之心，非闭而不兴」"
    local sc1 = boss.card.New(name, 60, 60, 60, 60)
    local sc2 = boss.card.New(name, 60, 60, 60, 60)
    boss.card.add({ { sc1, "13a" }, { sc2, "13b" } }, 7, name, 77)
    function sc1:before()
        BossAction(self, 9789)
        task.MoveTo(0, 80, 60, 2)
    end
    function sc1:init()
        task.New(self, function()
            while self.timer < 1294 do
                task.Wait()
            end
            self.hp = 0
        end)
        task.New(self, function()
            boss.cast(self, 1294)
            task.MoveTo(0, 180, 60, 2)
            local d = 1
            while true do
                local y = player.y
                for i = 0, 30 do
                    New(class["object0-8laserline"], y + 72 + i * 18, d, 90, 6)
                    New(class["object0-8laserline"], y - 72 - i * 18, d, 90, 6)
                end
                Newcharge_in(self.x, self.y, 250, 128, 114)
                for i = 18, 360, 18 do
                    for v = 1, 3 do
                        NewSimpleBullet(ellipse, 10, self.x + cos(i + v * 9) * 20, self.y + sin(i + v * 9) * 20, v / 2, i + v * 9)
                    end
                end
                task.Wait(140)
                for i = -3, 3 do
                    New(class["object0-8laserline"], y + i * 18, -d, 60, 2)
                end
                task.Wait(170)
                d = -d
            end
        end)
    end

    function sc2:before()
        BossAction(self, 9789)
        task.MoveTo(-300, 400, 60, 2)
    end
    function sc2:init()
        task.New(self, function()
            while self.timer < 1294 do
                task.Wait()
            end
            self.hp = 0
        end)
        task.New(self, function()
            while true do
                task.CRMoveTo(220, 3, 45, ran:Float(30, 120), 450, 200)
                task.CRMoveTo(220, 3, -45, ran:Float(30, 120), -450, 200)
            end
            New(class["object0-7center"], self.x, self.y, 3, 0, 40, 0, 80)
        end)
        task.New(self, function()
            local r
            while true do
                task.Wait(14)
                r = math.deg(math.atan2(self.dy, self.dx))
                New(class["object0-7center"], self.x, self.y, 3, r, 40, r + 180, 40)
            end
        end)
    end
end---wave9