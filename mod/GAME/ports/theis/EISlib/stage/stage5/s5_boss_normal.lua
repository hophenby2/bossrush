--祈华梦五面boss lunatic难度定义
--if not s5_boss then s5_boss = {} end

--五boss蓄力特效
local eff, dark_eff, bkeff, laser_eff = s5_boss.eff, s5_boss.dark_eff, s5_boss.bkeff, s5_boss.laser_eff
--五boss默认的随机x朝向自机移动函数
local move_rd
do
    function move_rd(t, y0, dy, self)
        y0 = y0 or 75
        dy = dy or 25
        if self then
            task.New(self, function()
                task.MoveToPlayer(t or 60, -40, 40, y0 - dy, y0 + dy, 10, 20, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
            end)
        else
            task.MoveToPlayer(t or 60, -40, 40, y0 - dy, y0 + dy, 10, 20, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
        end
    end
end

local atks, scs = {}, {}  --存放非符和符卡函数的表
--开幕演出
local function boss_show(self, x, y, IsDialog)
    self.aura_alpha = 0
    boss.show_aura(self, false)
    task.Wait(60)
    x, y = x or 0, y or 144
    task.MoveTo(0, 144, 60, MOVE_DECEL)
    if not IsDialog then
        boss.show_aura(self, true)
    end
end
local function boss_scpr_show(self, x, y)
    for _ = 1, 3 do
        eff(x, y, 20)
        PlaySound("ch00")
    end
    task.Wait(20)
    self.x, self.y = x, y
    boss.show_aura(self, true)
end
--一非
local function boss_atk1_normal_show(self)
    if EISlib.stage.canDialog() then
        -- 出场
        boss_show(self, 0, 150, true)
        -- 对话
        dialog.player.playScene("Stage5")
        dialog.player.waitSignal("fade out BGM", dialog.enum.on)
        EISlib.stage.musicFadeOut("s5", 120)
        dialog.player.waitSignal("play BGM", dialog.enum.on)
        LoadMusicRecord("s5_boss1")
        EISlib.stage.playMusic("s5_boss1", 0, true)
        dialog.player.waitUntilFinish()
        boss.show_aura(self, true) --打开法阵
    else
        -- 出场
        boss_show(self, 0, 150, true)
        -- BGM
        EISlib.stage.musicFadeOut("s5", 120)
        LoadMusicRecord("s5_boss1")
        EISlib.stage.playMusic("s5_boss1", 0, true)
        -- 开打
        task.Wait(60)
        boss.show_aura(self, true) --打开法阵
    end
end
local function boss_atk1_scpr_show(self)
    boss_scpr_show(self, 0, 150)
end
local function boss_atk1(self)
    local f1, f2
    do
        function f1(x, y, dv, a, da)
            local obj = stg.newBulletStraight(stg.square, 5, true, x, y, 0, a)
            obj.rot = a
            obj.navi = true
            egg.AddSimStrChV(obj, 0, 2.5 + dv, a, 20)
            egg.AddSimStrChV(obj, 0, -0.6 - dv, a, 20, 35)
            egg.AddSimStrChV(obj, 0, -1, a + da, 30, 35)
            task.New(obj, function()
                task.Wait(35)
                PlaySound("kira00")
            end)
        end
        function f2(x, y, dv, a, da)
            local obj = stg.newBulletStraight(stg.square, 7, true, x, y, 0, a)
            obj.rot = a
            obj.navi = true
            egg.AddSimStrChV(obj, 0, 2.5 + dv, a, 20)
            task.New(obj, function()
                task.Wait(35)
                PlaySound("kira00")
                egg.AddAccDecChV(obj, -0.5 - dv, a, 40, 30, 30)
                task.Wait(45)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, -0.5, a + da, 60)
            end)
        end
    end

    do
        eff(self.x, self.y, 90)
        local r, dr, a, da, dx, dy, a0
        local u1 = 1
        local count = 1
        while true do
            a0 = ran:Float(-5, 5)
            if count %2 == 0 then
                self:cast_rl()
            else
                self:cast_lr()
            end
            for u = u1, -u1, -2*u1 do
                a, da = -90 + 30*u + a0, -120/15*u
                r, dr = 30, 90/15
                for _ = 1, 15 do
                    a = a + da
                    r = r + dr
                    dx, dy = r*cos(a), r*sin(a)
                    for i = 0, 3 do
                        for j = -1, 1, 2 do
                            f1(self.x + dx, self.y + dy, 0.4*i, a + 75*u, 120*j)
                        end
                    end
                    f1(self.x + dx, self.y + dy, 2, a + (75 + 120)*u, 0) --这波是往头上打的，主要是防一波内避
                    task.Wait(2)
                    PlaySound("tan00")
                end
                task.Wait(10)
            end
            --转一圈青弹
            a, da = 90 + 30*u1 + a0, -360/30*u1
            r, dr = -90, 90/30
            for _ = 1, 30 do
                a = a + da
                r = r + dr
                dx, dy = r*cos(a), r*sin(a)
                for i = 0, 4 do
                    for j = -1, 1, 2 do
                        f2(self.x + dx, self.y + dy, 0.175*i, a, 120*j)
                    end
                end
                task.Wait(1)
                PlaySound("tan00")
            end
            task.Wait(60)
            move_rd(60, 150, 10)
            u1 = -u1
            count = count + 1
        end
    end
end
table.insert(atks, {boss_atk1, boss_atk1_normal_show, boss_atk1_scpr_show})
--二非
local function boss_atk2_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 150, 60, MOVE_NORMAL)
end
local function boss_atk2_scpr_show(self)
    boss_scpr_show(self, 0, 150)
end
local function boss_atk2(self)
    local f1, f2, f3
    do
        function f1(x, y, dv, a, da, co)
            local obj = stg.newBulletStraight(stg.square, co or 9, true, x, y, 0, a)
            obj.rot = a
            obj.navi = true
            egg.AddSimStrChV(obj, 0, 1.75 + dv, a, 20)
            egg.AddSimStrChV(obj, 0, -1, a, 20, 35)
            egg.AddSimStrChV(obj, 0, 1.25, a + da, 30, 35)
            task.New(obj, function()
                task.Wait(35)
                PlaySound("kira00")
            end)
        end
        function f2(x, y, dv, a, da)
            local obj = stg.newBulletStraight(stg.square, 3, true, x, y, 0, a)
            obj.rot = a
            obj.navi = true
            egg.AddSimStrChV(obj, 0, 2.25 + dv, a, 20)
            task.New(obj, function()
                task.Wait(35)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, -1 - dv, a, 60)
                task.Wait(45)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, 1.25, a + da, 60)
            end)
        end
        function f3(x, y, a, dv)
            local obj = stg.newBulletStraight(stg.ball_mid, 2, true, x, y, 0, a)
            obj.rot = a
            obj.navi = true
            obj.hscale, obj.vscale = 1.5, 1.5
            obj.a, obj.b = obj.a*obj.hscale, obj.b*obj.vscale
            task.New(obj, function()
                egg.AddSimStrChV(obj, 0, 3 + 0, a, 20)
                task.Wait(30)
                egg.AddSimStrChV(obj, 0, -3 + 1.25 + dv, a, 20)
            end)
        end
    end

    do
        eff(self.x, self.y, 90)
        local r, dr, a, da, dx, dy, a0
        local u1 = 1
        local count = 1
        while true do
            a0 = ran:Float(-5, 5)
            if count %2 == 0 then
                self:cast_rl()
            else
                self:cast_lr()
            end
            for u = u1, -u1, -2*u1 do
                a, da = -90 + 30*u + a0, -120/20*u
                r, dr = 30, 90/20
                for k = 1, 20 do
                    a = a + da
                    r = r + dr
                    dx, dy = r*cos(a), r*sin(a)
                    for i = 0, 2 do
                        for j = -1, 1, 2 do
                            f1(self.x + dx, self.y + dy, 0.4*i, a + (60 - 7.5*k)*u, 100*j)
                        end
                        f1(self.x + dx, self.y + dy, 0.3*(i-1), a + (60 -120 - 7.5*k)*u, 0, 11)
                    end
                    task.Wait(2)
                    PlaySound("tan00")
                end
            end
            --转一圈青弹
            a, da = 90 + 30*u1 + a0, -360/30*u1
            r, dr = -90, 90/30
            for k = 1, 30 do
                a = a + da
                r = r + dr
                dx, dy = r*cos(a), r*sin(a)
                for i = 0, 2 do
                    for j = -1, 1, 2 do
                        f2(self.x + dx, self.y + dy, 0.5*i, a + (75 - 7.5*k)*u1, 120*j)
                    end
                end
                dx, dy = r*cos(a + 0.5*da), r*sin(a + 0.5*da)
                for i = 0, 2 do
                    f3(self.x + dx, self.y + dy, a + (75 - 7.5*k + 7.5*i)*u1 + da, 0.25*i)
                end
                task.Wait(1)
                PlaySound("tan00")
            end
            task.Wait(60)
            move_rd(60, 150, 10)
            u1 = -u1
            count = count + 1
        end
    end
end
table.insert(atks, {boss_atk2, boss_atk2_normal_show, boss_atk2_scpr_show})
--三非
local function boss_atk3_normal_show(self)
    egg.SimAlpCh(self, 0, 255, 60)
    task.Wait(60)
    task.MoveTo(0, 150, 60, MOVE_NORMAL)
    task.Wait(60)
end
local function boss_atk3_scpr_show(self)
    boss_scpr_show(self, 0, 150)
end
local function boss_atk3(self)
    local f1, f2
    do
        function f1(x, y, dv, a, da, co)
            local obj = stg.newBulletStraight(stg.square, co, true, x, y, 0, a)
            obj.rot = a
            obj.navi = true
            egg.AddSimStrChV(obj, 0, 2 + dv, a, 20)
            egg.AddSimStrChV(obj, 0, -1.25, a, 20, 35)
            egg.AddSimStrChV(obj, 0, 1, a + da, 30, 35)
            task.New(obj, function()
                task.Wait(35)
                PlaySound("kira00")
            end)
        end
        function f2(x, y, dv, a, da)
            local obj = stg.newBulletStraight(stg.square, 1, true, x, y, 0, a)
            obj.rot = a
            obj.navi = true
            egg.AddSimStrChV(obj, 0, 2 + dv, a, 20)
            task.New(obj, function()
                task.Wait(35)
                PlaySound("kira00")
                --egg.AddAccDecChV(obj, -1 - dv, a, 40, 30, 30)
                egg.AddSimStrChV(obj, 0, -1, a, 30)
                task.Wait(45)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, 0.75, a + da, 60)
            end)
        end
    end

    do
        eff(self.x, self.y, 90)
        local r, dr, a, da, dx, dy, co, da0, a0
        local u1 = 1
        local count = 1
        while true  do
            a0 = ran:Float(-5, 5)
            if count%2 == 0 then
                self:cast_rlrl()
            else
                self:cast_lrlr()
            end

            for m = 0, 1 do
                co = 5 + 2*m
                for u = u1, -u1, -2*u1 do
                    a, da = -90 + 100*u + a0, -140/15*u
                    r, dr = 30, 90/15
                    for k = 1, 15 do
                        a = a + da
                        r = r + dr
                        dx, dy = r*cos(a), r*sin(a)
                        da0 = (-60+60*m)*u - 6*u*k
                        for i = 0, 1 do
                            for j = -1, 1, 2 do
                                f1(self.x + dx, self.y + dy, 0.175*i, a + da0, 60*j, co + 2*j)
                            end
                            f1(self.x + dx, self.y + dy, 0.175*(i-1), a -120*u + da0, 0, co)
                        end
                        task.Wait(2)
                        PlaySound("tan00")
                    end
                    task.Wait(10)
                end
            end
            --转一圈青弹
            a, da = 90 + 30*u1 + a0, -720/60*u1
            r, dr = 120, -90/60
            for k = 1, 60 do
                a = a + da
                r = r + dr
                dx, dy = r*cos(a), r*sin(a)
                for i = 0, 2 do
                    for j = -1, 1, 2 do
                        f2(self.x + dx, self.y + dy, 0.125*i, a + (30*k)*u1, 90*j)
                    end
                end
                task.Wait(1)
                PlaySound("tan00")
            end
            task.Wait(60)
            move_rd(60, 150, 10)
            u1 = -u1
        end
    end
end
table.insert(atks, {boss_atk3, boss_atk3_normal_show, boss_atk3_scpr_show})
--四非
local function boss_atk4_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 150, 60, MOVE_NORMAL)
end
local function boss_atk4_scpr_show(self)
    boss_scpr_show(self, 0, 150)
end
local function boss_atk4(self)
    local f1, f2, f3
    do
        function f1(x, y, dv, a, da, co)
            local obj = stg.newBulletStraight(stg.square, co, true, x, y, 0, a)
            obj.rot = a
            obj.navi = true
            egg.AddSimStrChV(obj, 0, 2.25 + dv, a, 20)
            egg.AddSimStrChV(obj, 0,  - dv, a, 20, 35)
            egg.AddSimStrChV(obj, 0, -0.5, a + da, 30, 35)
            task.New(obj, function()
                task.Wait(35)
                PlaySound("kira00")
            end)
        end
        function f2(x, y, dv, a, da)
            local obj = stg.newBulletStraight(stg.square, 1, true, x, y, 0, a)
            obj.rot = a
            obj.navi = true
            egg.AddSimStrChV(obj, 0, 2.25 + dv, a, 20)
            task.New(obj, function()
                task.Wait(35)
                PlaySound("kira00")
                egg.AddAccDecChV(obj, - dv, a, 40, 20, 20)
                task.Wait(25)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, -0.125, a + da, 60)
            end)
        end
        function f3(x, y, a)
            local obj = stg.newBulletStraight(stg.ball_mid, 2, true, x, y, 0, a)
            obj.rot = a
            obj.navi = true
            obj.hscale, obj.vscale = 1.2, 1.2
            obj.a, obj.b = obj.a*obj.hscale, obj.b*obj.vscale
            egg.AddSimStrChV(obj, 0, 2.25, a, 20)
        end
    end

    local co = {5, 7, 9, 3}
    do
        eff(self.x, self.y, 90)
        local r, dr, a, da, dx, dy, da0, a0
        local u1 = 1
        while true do
            a0 = ran:Float(-5, 5)
            self:cast_lrlrlrlr()
            for m = 0, 3 do
                for u = u1, -u1, -2*u1 do
                    a, da = -90 + 90*u + a0, -120/15*u
                    r, dr = 30, 90/15
                    for k = 1, 15 do
                        a = a + da
                        r = r + dr
                        dx, dy = r*cos(a), r*sin(a)
                        for i = 0, 2 do
                            for j = -1, 1, 2 do
                                f1(self.x + dx, self.y + dy, 0.4*i, a + (-60+30*m)*u - 4*u*k, (100 - 6*i)*j, co[m+1])
                            end
                            f1(self.x + dx, self.y + dy, 0.5*(i-1), a + (-150-60+30*m)*u - 4*u*k, 0, co[(m+1)%4+1])
                        end
                        task.Wait(2)
                        PlaySound("tan00")
                    end
                    task.Wait(10)
                end
            end
            --转两圈红弹
            a, da = -90 + 90*u1 + a0, -3*360/120*u1
            r, dr = 120, -90/120
            for k = 1, 120 do
                a = a + da
                r = r + dr
                dx, dy = r*cos(a), r*sin(a)
                da0 = (-90-9*k)*u1
                for i = 0, 2 do
                    for j = -1, 1, 2 do
                        f2(self.x + dx, self.y + dy, 0.15*i, a + da0, (60 + 5*i)*j)
                    end
                end
                f3(self.x + dx, self.y + dy, a + da0) --多出来的红中玉
                task.Wait(1)
                PlaySound("tan00")
            end
            u1 = -u1
            move_rd(60, 150, 10)
        end
    end
end
table.insert(atks, {boss_atk4, boss_atk4_normal_show, boss_atk4_scpr_show})


--一符 H/L 奇术「神代祈仪」（这张符卡结束后要停留一段时间
local function boss_sc1_normal_show(self)
    task.Wait(60)
    if EISlib.stage.canDialog() then
        --这里插入额外对话
        dialog.player.playScene("Stage5_Bossmid")
        dialog.player.waitSignal("fade out BGM", dialog.enum.on)
        EISlib.stage.musicFadeOut("s5_boss1", 120)
        dialog.player.waitSignal("play BGM", dialog.enum.on)
        LoadMusicRecord("s5_boss2")
        EISlib.stage.playMusic("s5_boss2", 0, true)
        dialog.player.waitUntilFinish()
    else
        EISlib.stage.musicFadeOut("s5_boss1", 120)
        LoadMusicRecord("s5_boss2")
        EISlib.stage.playMusic("s5_boss2", 0, true)
    end
    --正片开始
    task.MoveTo(0, 100, 60, MOVE_NORMAL)
    for _ = 1, 3 do
        eff(self.x, self.y, 20)
    end
    task.Wait(60)
    self.sc_bonus_max = 20000000
    self.sc_bonus_base = 20000000
end
local function boss_sc1_scpr_show(self)
    boss_scpr_show(self, 0, 100)
    self.sc_bonus_max = 20000000
    self.sc_bonus_base = 20000000
end
local function boss_sc1(self)
    local f1, f1_1, f2
    do
        function f1(x, y, a, t)
            local obj = stg.newBulletStraight(stg.ball_light, 8, true, x, y, 0, 0, true)
            obj.timer = 11
            obj.colli = false
            obj.hscale, obj.vscale = 0, 0
            obj.layer = LAYER_ENEMY_BULLET+1
            obj.bound = false
            _object.set_color(obj, "mul+add", 0, 255, 255, 255)
            egg.SimAlpCh(obj, 0, 255, 60)
            egg.SimSizeCh(obj, 5, 3, 60)
            --靠近boss
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET+1
                task.Wait(60)
                obj.colli = true
                task.Wait(t)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, 2, a, 180)
                egg.SimSizeCh(obj, 3, 0.5, 120, true)
                task.Wait(60)
                for i = 1, 5 do
                    f1_1(obj.x, obj.y, obj.vx, obj.vy, a + 72*i)
                end
                task.Wait(30)
                while IsValid(self) and Dist(obj, self) > 50 do
                    task.Wait(1)
                end
                obj.colli = false
                egg.SimAlpCh(obj, 255, 0, 60)
                egg.AddSimStrChV(obj, 0, -2, a, 60)
                task.Wait(60)
                Del(obj)
            end)
        end
        --光玉花的花瓣
        function f1_1(x, y, vx, vy, a)
            local obj = stg.newBulletStraight(stg.ball_mid, 3, false, x, y, 0, 0, true)
            obj.timer = 11
            --obj.vx, obj.vy = vx, vy
            obj.img = "Lily_Cherry_bullet"
            _object.set_color(obj, "", 255, 255, 255, 255)
            obj.hscale, obj.vscale = 0.75, 0.75
            obj.a, obj.b = 2, 2
            obj.rot = a + 180
            obj.bound = false
            --加速
            egg.AddV1(obj, 0.1, a)
            egg.AddSimStrChV(obj, 0, 1.2, a, 360, 90)
            --减速
            local v, a = Dist(0, 0, vx, vy), Angle(0, 0, vx, vy)
            egg.AddSimStrChV(obj, v, 0, a, 90)
            --转回来
            task.New(obj, function()
                task.Wait(120)
                local drot, ddrot = 0, 6/30
                for _ = 1, 30 do
                    drot = drot + ddrot
                    obj.rot = obj.rot + drot
                    task.Wait(1)
                end
                ddrot = -ddrot
                for _ = 1, 30 do
                    drot = drot + ddrot
                    obj.rot = obj.rot + drot
                    task.Wait(1)
                end
            end)
        end
        --时符结束后的花瓣
        function f2(x, y, a)
            local obj = stg.newBulletStraight(stg.arrow_big, 3, true, x, y, 0, a)
            local v0 = ran:Float(1, 3)
            egg.AddSimStrChV(obj, v0, 0.5*v0, a, 30)
            obj.navi = true
            local size = ran:Float(0.75, 0.9)
            obj.hscale, obj.vscale = size, size
            obj.img = "Lily_Cherry_bullet"
            local v0, a0 = ran:Float(1, 1.75), a + 90*ran:Sign()
            egg.AddSimStrChV(obj, 0, v0, a0, 120, 60)
            task.New(obj, function()
                task.Wait(60)
                PlaySound("kira00")
                obj.a, obj.b = 2*size, 2*size
                egg.AddAccDecChV(obj, -0.5*v0, a0, 30, 30, 60)
            end)
        end
    end

    do
        --25s内缓慢回血
        task.New(self, function()
            self.hp = 1
            local dhp = self.maxhp/1200
            for _ = 1, 1140 do
                self.hp = self.hp + dhp
                task.Wait(1)
            end
            eff(self.x, self.y, 0)
            for _ = 1, 60 do
                self.hp = self.hp + dhp
                task.Wait(1)
            end
            PlaySound("enep01")
            misc.ShakeScreen(20, 3)
            for i = 1, 40 do
                for j = 1, 3 do
                    f2(self.x, self.y, 9*i + 3*j)
                end
            end
            task.Wait(150)
            self.colli = true
            self._a = 255
            self.hp = self.hp - 99999
        end)
        s5_boss.pic_show()
        task.Wait(90)
        self.colli = false
        egg.SimAlpCh(self, 255, 150, 60)
        self.x, self.y = 0, 100
        eff(self.x, self.y, 90)
        local a, way, da, r, t, a0
        for i = 1, 5 do
            way = 9 + i*3
            a, da, r, t = 180/way, 360/way, 90 + 30*i, 30*i
            for j = way, 1, -1 do
                a0 = a + j*da
                f1(self.x + r*cos(a0), self.y + r*sin(a0), a0 + 180, t + j)
                task.Wait(1)
                PlaySound("kira00")
            end
        end
    end
end
table.insert(scs, {boss_sc1, boss_sc1_normal_show, boss_sc1_scpr_show})
--二符 里神乐「樱国扇舞·祈」
local function boss_sc2_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 144, 60, MOVE_NORMAL)
    self.sc_bonus_max = nil
    self.sc_bonus_base = nil
end
local function boss_sc2_scpr_show(self)
    boss_scpr_show(self, 0, 144)
end
local function boss_sc2(self)
    local f1, f1_1, f2, f2_1, f2_2, f3, f3_1, f3_2, f4
    do
        --扇形弹幕展开
        function f1(x, y, a, u)
            New(tasker, function()
                for i = -2, 2 do
                    New(tasker, function()
                        local dx, dy = 90*cos(a), 90*sin(a)
                        local a0, r = a + 22.5*i - 75*u, -18
                        local dx0, dy0 = cos(a0), sin(a0)
                        for _ = 0, 3 do
                            r = r - 3
                            f1_1(x + dx + r*dx0, y + dy + r*dy0, a0)
                            task.Wait(2)
                        end
                    end)
                    --task.Wait(4)
                end
            end)
        end
        function f1_1(x, y, a)
            local obj = stg.newBulletStraight(stg.square, 7, true, x, y, 0, a)
            egg.AddSimStrChV(obj, 0, 2, a, 60)
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET-1
            end)
        end
        --普通旋转扇形弹幕
        function f2(x, y, a, u, co)
            local obj = stg.newBulletStraight(stg.square, co, true, x, y, 0, a, true)
            obj.hide, obj.colli = true, false
            obj.bound = false
            obj.rot = a - 150*u
            egg.AddSimStrChV(obj, 4, 2, a - 150*u + ran:Float(-5, 5), 120)
            egg.AddSimStrChO(obj, 6*u, 2*u, 120)
            task.New(obj, function()
                for i = -3, 3 do
                    New(tasker, function()
                        local r = -12
                        for j = 1, 0, -1 do
                            r = r - 8
                            f2_1(r, 15*i, obj, co+j)
                            task.Wait(2)
                        end
                        f4(10, 15*i, obj, co)
                    end)
                end
            end)
            task.New(obj, function()
                for _ = 1, 24 do
                    for i = 0, 1 do
                        f2_2(obj.x, obj.y, 1 + 0.25*i, obj.rot + 90*u, co)
                    end
                    task.Wait(12)
                end
                task.Wait(300)
                obj.bound = true
            end)
        end
        function f2_1(r, da, mst, co)
            local obj = stg.newBulletStraight(stg.square, co, false, mst.x + r*cos(mst.rot + da), mst.y + r*sin(mst.rot + da), 0, mst.rot, true)
            task.New(obj, function()
                while IsValid(mst) do
                    obj.rot = mst.rot + da
                    obj.x, obj.y = mst.x + r*cos(obj.rot), mst.y + r*sin(obj.rot)
                    task.Wait(1)
                end
                egg.AddSimStrChV(obj, 4, 1, obj.rot, 30)
            end)
            task.New(obj, function()
                local v, dv = 0, 2/30
                for _ = 1, 30 do
                    v = v + dv
                    r = r + v
                    task.Wait(1)
                end
                dv = -2/30
                for _ = 1, 30 do
                    v = v + dv
                    r = r + v
                    task.Wait(1)
                end
            end)
        end
        function f2_2(x, y, v, a, co)
            local obj = stg.newBulletStraight(stg.arrow_big, co + 1, true, x, y, 0, a)
            egg.AddSimStrChV(obj, 0, v, a, 60)
        end
        --爆炸扇形弹幕
        function f3(x, y, a, u)
            local obj = stg.newBulletStraight(stg.square, 2, true, x, y, 0, a, true)
            obj.hide, obj.colli = true, false
            obj.bound = false
            obj.rot = a
            egg.AddSimStrChV(obj, 2, 0, obj.rot, 240)
            obj.rot = obj.rot + 180
            egg.AddSimStrChO(obj, 6*u, 0, 240)
            task.New(obj, function()
                for i = -3, 3 do
                    New(tasker, function()
                        local r = -12
                        for j = 0, 1 do
                            r = r - 8
                            f3_1(r, 15*i, obj, 1 + j)
                            task.Wait(2)
                        end
                        f4(10, 15*i, obj, 1)
                    end)
                end
            end)
            task.New(obj, function()
                for _ = 1, 24 do
                    for i = 0, 1 do
                        f2_2(obj.x, obj.y, 1 + 0.25*i, obj.rot + 90*u, 1)
                    end
                    task.Wait(10)
                end
                local x, y, a = obj.x, obj.y
                obj.explode = true
                task.Wait(45)
                PlaySound("enep00", 0.1)
                a = ran:Float(0, 360)
                for i = 1, 16 do
                    for j = -1, 1 do
                        f3_2(x, y, 1.25 - 0.05*abs(j), a + 0.25*j + i*22.5)
                    end
                end
                Del(obj)
            end)
        end
        function f3_1(r, da, mst)
            local obj = stg.newBulletStraight(stg.square, 1, false, mst.x + r*cos(mst.rot + da), mst.y + r*sin(mst.rot + da), 0, mst.rot, true)
            _object.set_color(obj, "", 255, 255, 255, 255)
            task.New(obj, function()
                while IsValid(mst) and not mst.explode do
                    obj.rot = mst.rot + da
                    obj.x, obj.y = mst.x + r*cos(obj.rot), mst.y + r*sin(obj.rot)
                    task.Wait(1)
                end
                local d = -255/45
                for _ = 1, 45 do
                    obj._g, obj._b = obj._g + d, obj._b + d
                    task.Wait(1)
                end
                stg.setBulletStyle(obj, stg.ball_light, 1)
                _object.set_color(obj, "mul+add", 255, 255, 255, 255)
                egg.SimSizeCh(obj, 0.25, 3, 20)
                task.Wait(30)
                Del(obj)
            end)
            task.New(obj, function()
                local v, dv = 0, 2/30
                for _ = 1, 30 do
                    v = v + dv
                    r = r + v
                    task.Wait(1)
                end
                dv = -2/30
                for _ = 1, 30 do
                    v = v + dv
                    r = r + v
                    task.Wait(1)
                end
            end)
        end
        function f3_2(x, y, v, a)
            local obj = stg.newBulletStraight(stg.grain_b, 1, true, x, y, 0, a)
            egg.AddSimStrChV(obj, 0, v, a, 60)
        end
        function f4(r, da, mst, co)
            local obj = stg.newBulletStraight(stg.ball_light, co, false, mst.x + r*cos(mst.rot + da), mst.y + r*sin(mst.rot + da), 0, mst.rot, true)
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            obj.hscale, obj.vscale = 1, 0.15
            obj.a, obj.b = obj.a*obj.hscale, obj.b*obj.vscale
            task.New(obj, function()
                while IsValid(mst) do
                    obj.rot = mst.rot + da
                    obj.x, obj.y = mst.x + r*cos(obj.rot), mst.y + r*sin(obj.rot)
                    task.Wait(1)
                end
                Del(obj)
                egg.AddSimStrChV(obj, 4, 1, obj.rot, 30)
            end)
        end
    end

    do
        s5_boss.pic_show()
        task.Wait(90)
        self.x, self.y = 0, 144
        local u1 = 1
        while true do
            eff(self.x, self.y, 90)
            self:cast_lr()
            for u = u1, -u1, -2*u1 do
                for i = 0, 9 do
                    f1(self.x, self.y, 90 + (45 + 30*i)*u, u)
                    task.Wait(4)
                    PlaySound("tan00")
                end
            end
            --丢出一圈扇子
            local a
            for i = 0, 10 do
                a = -90 + 25*i*u1 + ran:Float(-2, 2)
                f2(self.x + 90*cos(a), self.y + 90*sin(a), a, u1, 3 + 6*(i%2))
                task.Wait(5)
                PlaySound("kira00")
            end
            task.Wait(60)
            --移动
            task.New(self, function()
                for i = 0, 9 do
                    f1(self.x, self.y, 90 + (70 + 25*i)*-u1, -u1)
                    task.Wait(6)
                    PlaySound("tan00")
                end
            end)
            task.MoveTo(-120*u1, 120, 60, MOVE_NORMAL)
            eff(self.x, self.y, 90)
            --丢出爆炸扇子
            self:cast_l()
            a = Angle(self, player)
            local dx, dy = 0*cos(a), 0*sin(a)
            for u = 1, -1, -2 do
                laser_eff(self.x + 25*cos(a + 90*u), self.y + 25*sin(a + 90*u), a, 255, 0, 0)
            end
            task.Wait(30)
            for u = 1, -1, -2 do
                f3(self.x + dx + 45*cos(a + 90*u), self.y + dy + 45*sin(a + 90*u), a, u)
                PlaySound("kira00")
            end
            task.Wait(60)
            --移动
            task.New(self, function()
                for i = 0, 9 do
                    f1(self.x, self.y, 90 + (70 + 25*i)*u1, u1)
                    task.Wait(12)
                    PlaySound("tan00")
                end
            end)
            task.MoveTo(120*u1, 120, 120, MOVE_NORMAL)
            --丢出爆炸扇子
            eff(self.x, self.y, 90)
            self:cast_l()
            a = Angle(self, player)
            local dx, dy = 0*cos(a), 0*sin(a)
            for u = 1, -1, -2 do
                laser_eff(self.x + 25*cos(a + 90*u), self.y + 25*sin(a + 90*u), a, 255, 0, 0)
            end
            task.Wait(30)
            for u = 1, -1, -2 do
                f3(self.x + dx + 45*cos(a + 90*u), self.y + dy + 45*sin(a + 90*u), a, u)
                PlaySound("kira00")
            end
            task.Wait(60)
            task.MoveTo(0, 144, 60, MOVE_NORMAL)
            task.Wait(120)
            u1 = -u1
        end
    end
end
table.insert(scs, {boss_sc2, boss_sc2_normal_show, boss_sc2_scpr_show})
--三符 里神乐「出云剑舞·序」(这张符卡结束后要中止boss的vx vy速度！）
local function boss_sc3_normal_show(self)
    task.MoveTo(0, 144, 60, MOVE_NORMAL)
end
local function boss_sc3_scpr_show(self)
    boss_scpr_show(self, 0, 144)
end
local function boss_sc3(self)
    local f1, f2, f3, f4, f5, f5_1
    do
        function f1(x, y, dv, a)
            local obj = stg.newBulletStraight(stg.knife, 3, true, x, y, 0, a)
            egg.AddSimStrChV(obj, 0, 1.5 + dv, a, 120)
        end
        function f2(x, y, dv, a, p, t)
            p = p or 0.025
            t = t or 60
            local obj = stg.newBulletStraight(stg.knife,  5,  true, x, y, 0, a)
            egg.AddSimStrChV(obj, 0, 1.75 + dv, a, 60)
            task.New(obj, function()
                task.Wait(60)
                egg.AimTo(obj, player, 1.75 + dv, 3.5, t, p)
            end)
        end
        function f3(x, y, a)
            local obj = stg.newBulletStraight(stg.arrow_big, 4, true, x, y, 0, a)
            obj.navi = true
            local rate = ran:Float(0.2, 1)
            egg.AddSimStrChV(obj, 0, 2*rate, a, 30)
            egg.AddSimStrChV(obj, 0, 4*rate, -90, 240)
        end
        function f4(x, y, dv, a)
            local obj = stg.newBulletStraight(stg.ball_big, 2, true, x, y, 1.75 + dv, a)
            task.New(obj, function()
                task.Wait(40)
                egg.AddSimStrChV(obj, 0, -1, a, 30)
            end)
        end
        --花
        function f5(x, y, a, t)
            local obj = stg.newBulletStraight(stg.ball_light, 3, true, x, y, 0, a)
            obj.timer = 11
            obj.colli = false
            _object.set_color(obj, "", 0, 255, 255, 255)
            egg.SimSizeCh(obj, 2, 1, 30)
            --生成花瓣
            for i = 0, 4 do
                for j = 0, 0 do
                    f5_1(obj, 18, 1*abs(j), a + 72*i, 45*j, t)
                end
            end
            task.New(obj, function()
                egg.SimAlpCh(obj, 0, 255, 30)
                task.Wait(30)
                task.Wait(t)
                obj._blend = ""
                obj.colli = true
                egg.SimAlpCh(obj, 255, 0, 30)
                task.Wait(30)
                Del(obj)
            end)
        end
        function f5_1(mst, r, v, a, _da, t)
            local dx, dy = r*cos(a), r*sin(a)
            local obj = stg.newBulletStraight(stg.ball_mid, 1, true, mst.x + dx + ran:Float(-30, 30), mst.y + dy + ran:Float(-30, 30), 0, a)
            obj.timer = 11
            obj.bound = false
            obj.img = "Lily_Cherry_bullet"
            obj.colli = false
            _object.set_color(obj, "mul+add", 0, 255, 255, 255)
            egg.SimSizeCh(obj, 1.5, 0.75, 30)
            local da = 60*ran:Sign()
            a = a + 180
            obj.rot = a + da
            task.New(obj, function()
                egg.SimAlpCh(obj, 0, 255, 30)
                task.New(obj, function()
                    for x = 1, 30 do
                        obj.rot = a + 180 + da*cos(3*x)
                        task.Wait(1)
                    end
                end)
                task.MoveTo(mst.x + dx, mst.y + dy, 30, MOVE_DECEL)
                obj._blend = ""
                obj.colli = true
                obj.a, obj.b = 2, 2
                task.Wait(t)
                PlaySound("kira00")
                obj.navi = true
                obj.bound = true
                egg.AddSimStrChV(obj, 0, 1.25, a, 60)
                egg.AddSimStrChV(obj, 0, v, a + _da, 30, 60)
            end)
        end
    end

    do
        s5_boss.pic_show()
        task.Wait(90)
        eff(self.x, self.y, 0)
        local x, y
        for i = 1, 6 do
            for u = -1, 1, 2 do
                x, y = -160*u, 180 - 40*i
                f5(x, y, Angle(x, y, player.x, player.y) + 36, 0)
            end
            PlaySound('kira00')
            task.Wait(15)
        end
        local u, a, da, r, dr, dx, dy = 1
        self:cast_lrlr()
        for u1 = u, -u, -2*u do
            a, da = 90 + 90*u1, 180/15*u1
            r, dr = 120, -240/20
            for k = 1, 15 do
                a = a + da
                r = r + dr
                dx, dy = r*cos(a), r*sin(a)
                for i = 0, 1 do
                    f1(self.x + dx, self.y + dy, 0.6*i, a + (6*k - 30 + 2*i)*u1)
                end
                task.Wait(3)
                PlaySound("kira00")
            end
        end
        a, da = 90 + 90*u, 180/16*u
        r = 60
        for k = 1, 16 do
            a = a + da
            dx, dy = r*cos(a), r*sin(a)
            for i = 0, 1 do
                f2(self.x + dx, self.y + dy, 0.4*i, a + (10*k - 90)*u)
            end
            task.Wait(2)
            PlaySound("kira00")
        end
        task.Wait(60)
        while true do
            eff(self.x, self.y, 90)
            a = -60
            for _ = 1, 3 do
                laser_eff(self.x, self.y, a, 255, 0, 0)
                --新增的花
                task.New(self, function()
                    local x, y, a = self.x, self.y, a
                    local dx, dy = cos(a), sin(a)
                    for i = 2, 8 do
                        f5(x + 50*i*dx, y + 50*i*dy, a + 60*i, 80)
                        task.Wait(10)
                    end
                end)
                task.Wait(60)
                egg.AddAccDecChV(self, 5, a, 60, 10, 60) --快速冲向自机
                a = a + 180
                --洒花
                task.New(self, function()
                    for _ = 1, 45 do
                        f3(self.x, self.y, a + ran:Float(-30, 30))
                        task.Wait(4)
                    end
                end)
                task.Wait(30)
                --丢刀子
                for k = 1, 10 do
                    for u = 1, -1, -2 do
                        for i = 0, 1 do
                            f1(self.x, self.y, 0.5*i, a + (90 - 30 + 5*k + i)*u)
                        end
                        f2(self.x, self.y, 1, a + (90 - 30 - 15*k)*u, 0.05, 60)
                    end
                    task.Wait(8)
                    PlaySound("kira00")
                end
                task.Wait(10)
                for i = 1, 6 do
                    for j = 1, 3 do
                        for k = 0, j do
                            f4(self.x, self.y, 1.25 - 0.25*j, 60*i + (-0.5*j + k)*10)
                        end
                    end
                end
                PlaySound("tan00")
                task.Wait(80)
                a = a + 60
            end
            self.vx, self.vy = 0, 0
            --这次是倒三角
            task.MoveTo(175, 144, 60, MOVE_ACC_DEC)
            eff(self.x, self.y, 90)
            a = 180
            for _ = 1, 3 do
                laser_eff(self.x, self.y, a, 255, 0, 0)
                --新增的花
                task.New(self, function()
                    local x, y, a = self.x, self.y, a
                    local dx, dy = cos(a), sin(a)
                    for i = 2, 8 do
                        f5(x + 50*i*dx, y + 50*i*dy, a + 60*i, 80)
                        task.Wait(10)
                    end
                end)
                egg.AddAccDecChV(self, 5, a, 60, 10, 60) --快速冲向自机
                a = a + 180
                --洒花
                task.New(self, function()
                    for _ = 1, 45 do
                        f3(self.x, self.y, a + ran:Float(-30, 30))
                        task.Wait(4)
                    end
                end)
                task.Wait(30)
                --丢刀子
                for k = 1, 10 do
                    for u = 1, -1, -2 do
                        for i = 0, 1 do
                            f1(self.x, self.y, 0.5*i, a + (90 - 30 + 5*k + i)*u)
                        end
                        f2(self.x, self.y, 1, a + (90 - 30 - 15*k)*u, 0.05, 60)
                    end
                    task.Wait(8)
                    PlaySound("kira00")
                end
                task.Wait(10)
                for i = 1, 6 do
                    for j = 1, 3 do
                        for k = 0, j do
                            f4(self.x, self.y, 1.25 - 0.25*j, 60*i + (-0.5*j + k)*10)
                        end
                    end
                end
                PlaySound("tan00")
                task.Wait(80)
                a = a - 60
            end
            task.MoveTo(0, 144, 60, MOVE_ACC_DEC)
        end
    end
end
table.insert(scs, {boss_sc3, boss_sc3_normal_show, boss_sc3_scpr_show})
--四符 御神乐「神樱花演舞·降神」
local function boss_sc4_normal_show(self)
    task.MoveTo(0, 50, 60, MOVE_NORMAL)
end
local function boss_sc4_scpr_show(self)
    boss_scpr_show(self, 0, 50)
end
local function boss_sc4(self)
        local f1, f1_1, f2, f2_1, f3, f4, f4_1
        do
            function f1(x, y, r, a, u, t)
                New(tasker, function()
                    for _ = 1, 8 do
                        r = r + 10
                        a = a + 1.25*u
                        f1_1(x + r*cos(a), y + r*sin(a), a, t)
                        task.Wait(3)
                        t = t - 3
                    end
                    for _ = 1, 8 do
                        r = r - 3.5
                        a = a + 1.25*u
                        f1_1(x + r*cos(a), y + r*sin(a), a, t)
                        task.Wait(3)
                        t = t - 3
                    end
                end)
            end
            function f1_1(x, y, a, t)
                local obj = stg.newBulletStraight(stg.grain_a, 3, true, x, y, 1, a, true)
                obj.bound = false
                task.New(obj, function()
                    task.Wait(t)
                    egg.AddSimStrChV(obj, 0, 1.5, a, 60)
                    task.Wait(180)
                    obj.bound = true
                end)
            end
            function f2(x, y, r ,a, u)
                New(tasker, function()
                    for i = 1, 15 do
                        r = r + 15.6
                        a = a + 1.95*u
                        f2_1(x + r*cos(a), y + r*sin(a), a + 6.24*i*u)
                        task.Wait(4)
                    end
                end)
            end
            function f2_1(x, y, a)
                local obj = stg.newBulletStraight(stg.square, 3, true, x, y, 0, a, true)
                obj.bound = false
                egg.AddSimStrChV(obj, 1.5, 0.75, a, 60)
                task.New(obj, function()
                    task.Wait(180)
                    obj.bound = true
                end)
            end
            function f3(x, y, a, da)
                local obj = stg.newBulletStraight(stg.music, 9, true, x, y, 0, a)
                obj.bound = false
                obj.navi = true
                egg.AddSimStrChV(obj, 3, 1, a, 60)
                egg.AddSimStrChV(obj, 0, 1.2, a + da, 60, 60)
                task.New(obj, function()
                    obj.layer = LAYER_ENEMY_BULLET-2
                    task.Wait(180)
                    obj.bound = true
                end)
            end
            function f4(x, y, r, a, u)
                task.New(self, function()
                    for i = 1, 6 do
                        r = r + 5
                        a = a - 1.5*u
                        f4_1(x + r*cos(a), y + r*sin(a), a + 3*i*u)
                        task.Wait(3)
                    end
                end)
            end
            function f4_1(x, y, a)
                local obj = stg.newBulletStraight(stg.square, 5, true, x, y, 0, a)
                obj.rot = a
                obj.bound = false
                obj.navi = true
                egg.AddSimStrChV(obj, 2.5, 1.25, a, 60)
                task.New(self, function()
                    obj.layer = LAYER_ENEMY_BULLET-1
                end)
            end
        end

        do
            s5_boss.pic_show()
            task.Wait(90)
            eff(self.x, self.y, 75)
            self:cast_rl()
            do
                local a0 = 45
                for u = -1, 1, 2 do
                    for i = 1, 6 do
                        f2(self.x, self.y, 0 ,60*i + a0, u)
                        PlaySound("kira00")
                        task.Wait(6)
                    end
                    a0 = a0 + 30
                end
            end
            local t0 = 80
            local r0 = -200
            for j = 1, 3 do
                task.New(self, function()
                    local t = t0
                    local r = r0
                    local a = 30*j
                    for i = 0, 5 do
                        f1(self.x, self.y, r + 6*i, 60*i + a, 1, t)
                        PlaySound("kira00")
                        task.Wait(5)
                        t = t - 5
                    end
                end)
                task.Wait(20)
                r0 = r0 + 30
                t0 = t0 + 10
            end
            task.MoveTo(0, 120, 60, MOVE_ACC_DEC)
            eff(self.x, self.y, 60)
            --循环大风车
            task.New(self, function()
                task.Wait(180)
                local a
                while true do
                    for i = 1, 16 do
                        a = Angle(self, player)
                        stg.newBulletStraight(stg.silence, 3, true, self.x, self.y, 1.5, a + i*22.5)
                    end
                    task.Wait(90)
                end
            end)
            task.New(self, function()
                task.Wait(360)
                local a, da = 0, 35
                while true do
                    for i = 0, 2 do
                        f4(self.x, self.y, -60, a + 90*i, 1)
                    end
                    PlaySound("kira00")
                    task.Wait(30)
                    a = a + da
                end
            end)
            local a, da = 0, 2
            while true do
                for u1 = -1, 1, 2 do --这层主要是控制总体移偏移方向
                    for _ = 1, 3 do
                        for i = 1, 6 do
                            for u = -1, 1, 2 do
                                f3(self.x, self.y, a*u + 60*i, 60*u1*u)
                            end
                        end
                        PlaySound("tan00")
                        task.Wait(6)
                        a = a + da
                    end
                end
            end
        end
    end
table.insert(scs, {boss_sc4, boss_sc4_normal_show, boss_sc4_scpr_show})
--LSC
local function boss_LSC(self)
    local f1, f1_1, f1_2, f2
    do
        --札弹连弹
        function f1(x, y, a, r0, u0, da)
            da = da or 0
            New(tasker, function()
                local dx, dy, r = cos(a), sin(a), r0
                for k = 0, 4 do
                    f1_1(x + r*dx, y + r*dy, a + 4*k*u0 + da)
                    for u = -1, 1, 2 do
                        f1_2(x + r*dx, y + r*dy, a + 4*k*u0 + da, (45 - 3*k)*u)
                    end
                    task.Wait(4)
                    r = r + 35
                    PlaySound("tan00")
                end
            end)
        end
        function f1_1(x, y, a)
            local obj = stg.newBulletStraight(stg.square, 5, true, x, y, 0, a)
            egg.AddSimStrChV(obj, 2.75, 1.25, a, 60)
        end
        function f1_2(x, y, a, da)
            local obj = stg.newBulletStraight(stg.square, 3, true, x, y, 0, a)
            obj.img = "Lily_Cherry_bullet"
            obj.hscale, obj.vscale = 0.75, 0.75
            obj.a, obj.b = 2, 2
            obj.navi = true
            egg.ChV(obj, 2.75, 1.25, a, da, 60, 60)
        end
        --光玉特效
        function f2(x, y, v, a)
            local obj = stg.newBulletStraight(stg.ball_light, 10, true, x, y, 0, 0)
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            obj.timer = 11
            obj.colli = false
            egg.SimAlpCh(obj, 0, 255, 30, true)
            egg.SimSizeCh(obj, 2.5, 0.75, 30, true)
            egg.AddSimStrChV(obj, 2.75, v, a, 60)
        end
    end

    do
        s5_boss.pic_show()
        task.Wait(90)
        eff(self.x, self.y, 75)
        --一大波弹幕
        local a, r
        for k = 1, 8 do
            r = -90 + 10*k
            for i = 1, 16 do
                for j = -1, 1 do
                    a = 22.5*i + 1.5*j + 11.25*k
                    stg.newBulletStraight(stg.square, 3, true, self.x + r*cos(a), self.y + r*sin(a), 1 + 0.2*k, a)
                end
            end
            PlaySound("kira00")
            task.Wait(3)
        end
        task.Wait(90)
        eff(self.x, self.y, 75)
        local a, da, r, dr, dx, dy, a0
        local u = 1
        while true do
            if u == 1 then
                self:cast_rl()
            else
                self:cast_lr()
            end
            for u1 = u, -u, -2*u do
                a, da, r, dr = -90 - 60*u1, 180/10*u1, 120, -90/10
                for i = 1, 10 do
                    a, r = a + da, r + dr
                    dx, dy = r*cos(a), r*sin(a)
                    f1(self.x, self.y, a + 3*i*u1, r - 60, u1)
                    for j = 0, 1 do
                        f2(self.x + dx, self.y + dy, 1 + 0.3*j, a + (5*i + 5*j)*u1)
                    end
                    task.Wait(4)
                end
            end
            --一大串
            a, da, r, dr = -90 - 90*u, 360/15*u, 120, -150/15
            for i = 1, 15 do
                a, r = a + da, r + dr
                dx, dy = r*cos(a), r*sin(a)
                f1(self.x, self.y, a + 3*i*u, r - 60, u, (-120 + 6*i)*u)
                for j = 0, 1 do
                    f2(self.x + dx, self.y + dy, 1 + 0.2*j, a + (5*i + 2.5*j)*u)
                end
                task.Wait(4)
            end
            task.Wait(80)
            eff(self.x, self.y, 60)
            move_rd(60, 169, 10, self)
            --自机狙
            a, da, r, dr = -90 + 60*u, 120/5*u, 0, 10
            for _ = 1, 5 do
                dx, dy = self.x + r*cos(a), self.y + r*sin(a)
                a0 = Angle(dx, dy, player.x, player.y)
                for i = -1, 1 do
                    f1(dx, dy, a0 + 60*i, r, u)
                end
                task.Wait(12)
                a = a + da
                r = r + dr
            end
            r, dr = -30, 30
            for i = 1, 5 do
                a = Angle(self, player)
                for j = -3, 3 do
                    a0 = a + 30*j
                    f2(self.x + r*cos(a0), self.y + r*sin(a0), 1.25 + 0.25*i, a0)
                end
                task.Wait(12)
                r = r + dr
            end
            task.Wait(90)
            u = -u
        end
    end
end


-- 创建一个 boss 类
local function create_boss_class(class_name, group_name)
    local cls = Class(boss)
    _editor_class[class_name] = cls
    cls.cards = {}
    cls._name = class_name
    cls.name = "Jinguuji"
    cls.bgm = "s5_boss2"
    cls._bg = function () return stage5_background end
    cls.difficulty = group_name
    function cls:init(cards)
        boss.init(self, 224, 256, "Jinguuji", cards, New(s5_boss.scbg), group_name)
        lstg.wis.Jinguuji(self)
    end
    return cls
end
-- 创建一个符卡
local function create_card_class(index, name, timet, hp, dropt, mode, advance)
    local _sc = boss.card.New(name, timet[1], timet[2], timet[3], hp, dropt, false, mode)
    _sc.perform = advance
    if mode == "normal" then
        function _sc:init()
            task.New(self,function()
                atks[index][1](self)
            end)
        end
        function _sc:del()
            self.hscale = 1
            self._wisys:setAction("normal")
            self.vx, self.vy = 0, 0 --该停下来啦
            self.ax, self.ay = 0, 0
        end
    elseif mode == "spellcard" then
        function _sc:init()
            task.New(self,function()
                scs[index][1](self)
            end)
        end
        function _sc:del()
            self.hscale = 1
            self._wisys:setAction("normal")
            bkeff(self.x, self.y)
            self.vx, self.vy = 0, 0 --该停下来啦
            self.ax, self.ay = 0, 0
        end
    end
    --table.insert(boss_class.cards, _sc)
    --table.insert(_sc_table, { boss_class._name, name, _sc, #boss_class.cards, advance })
    return _sc
end
-- 创建一个符卡练习
local function create_cardpr_class(index, name, timet, hp, dropt, mode, boss_class)
    local _sc = boss.card.New(name, timet[1], timet[2], timet[3], hp, dropt, false, mode)
    _sc.perform = true
    if mode == "normal" then
        function _sc:init()
            task.New(self,function()
                atks[index][1](self)
            end)
        end
        function _sc:del()
            self.hscale = 1
            self._wisys:setAction("normal")
            self.vx, self.vy = 0, 0 --该停下来啦
            self.ax, self.ay = 0, 0
        end
    elseif mode == "spellcard" then
        function _sc:init()
            task.New(self,function()
                scs[index][1](self)
            end)
        end
        function _sc:del()
            self.hscale = 1
            self._wisys:setAction("normal")
            self.vx, self.vy = 0, 0 --该停下来啦
            self.ax, self.ay = 0, 0
        end
    end
    table.insert(_sc_table, { boss_class._name, name, _sc, #boss_class.cards+1, true })
    --table.insert(_sc_table, { boss_class._name, name, _sc, #boss_class.cards, advance })
    return _sc
end
-- 创建一个正常的演出
local function create_normal_show_class(index, mode)
    local _show = boss.dialog.New(true)
    function _show:init()
        player.dialog=false
        self.dialog_displayer=New(dialog_displayer)
        self._dialog_maintask=task.New(self,function()
            if mode == "normal" then
                atks[index][2](self)
            elseif mode == "spellcard" then
                scs[index][2](self)
            end
        end)
    end
    return _show
end
-- 创建一个符卡练习的演出
local function create_scpr_show_class(index, mode)
    local _show = boss.dialog.New(true)
    function _show:init()
        player.dialog=false
        self.dialog_displayer=New(dialog_displayer)
        self._dialog_maintask=task.New(self,function()
            if mode == "normal" then
                atks[index][3](self)
            elseif mode == "spellcard" then
                scs[index][3](self)
            end
        end)
    end
    return _show
end

--boss定义
local stage5boss
do
    stage5boss = create_boss_class("stage5boss:Normal", "Normal")
    local card_info = {
        {"常规攻击1", {2, 6, 40}, 1500, {0,0,0}, "normal", false},
        {"常规攻击2", {2, 6, 40}, 1500, {0,0,0}, "normal", false},
        {"灵符「清洁仪式」", {22, 22, 23}, 1000, {10, 20, 30}, "spellcard", false},
        {"常规攻击3", {2,6,40},1500,{0,0,0}, "normal", false},
        {"里神乐「樱国扇舞」", {2, 5, 40}, 2000, {10, 20, 30}, "spellcard", false},
        {"常规攻击4", {2,6,40}, 2000, {0,0,0}, "normal", false},
        {"里神乐「出云剑舞·序」", {4, 12, 60}, 1300, {10, 20, 30}, "spellcard", false},
        {"御神乐「琴歌神宴舞」",{2, 10, 60}, 2000, {10, 20, 30}, "spellcard", false}
    }
    stage5boss.cards={}
    local i, info = 1
    --如果要插入新的card，请务必在local n之上插入，否则会影响后面二符的del函数
    local n = #stage5boss.cards
    --五boss比较特殊，手动插入
    local index = {1, 2, 1, 3, 2, 4, 3, 4}
    for i = 1, #index do
        info = card_info[i]
        table.insert(stage5boss.cards, create_normal_show_class(index[i], info[5]))
        table.insert(stage5boss.cards, create_card_class(index[i], info[1], info[2], info[3], info[4], info[5], info[6]))
    end
    local _sc = stage5boss.cards[n+4] --定位到二非，需要爆炸效果
    function _sc:del()
        self.hscale = 1
        self._wisys:setAction("normal")
        bkeff(self.x, self.y)
        New(boss_death_circle, self.x, self.y)
        misc.ShakeScreen(30, 5)
        PlaySound("enep00")
        self.vx, self.vy = 0, 0 --该停下来啦
        self.ax, self.ay = 0, 0
    end
    _sc = stage5boss.cards[n+6]  --定位到一符，一符结束后不需要爆炸效果
    function _sc:del()
        self.hscale = 1
        self._wisys:setAction("normal")
        self.vx, self.vy = 0, 0 --该停下来啦
        self.ax, self.ay = 0, 0
    end
end
_editor_class["stage5boss:Normal"] = stage5boss

--符卡练习定义
local stage5bossScpr
do
    stage5bossScpr = create_boss_class("stage5bossScpr:Normal", "Normal")
    local card_info = {
        {"常规攻击1", {2, 6, 40}, 1500, {0,0,0}, "normal", false},
        {"常规攻击2", {2, 6, 40}, 1500, {0,0,0}, "normal", false},
        {"灵符「清洁仪式」", {22, 22, 23}, 1000, {10, 20, 30}, "spellcard", false},
        {"常规攻击3", {2,6,40},1500,{0,0,0}, "normal", false},
        {"里神乐「樱国扇舞」", {2, 5, 40}, 2000, {10, 20, 30}, "spellcard", false},
        {"常规攻击4", {2,6,40}, 2000, {0,0,0}, "normal", false},
        {"里神乐「出云剑舞·序」", {4, 12, 60}, 1300, {10, 20, 30}, "spellcard", false},
        {"御神乐「琴歌神宴舞」",{2, 10, 60}, 2000, {10, 20, 30}, "spellcard", false}
    }
    stage5bossScpr.cards={}
    local i, info = 1
    --如果要插入新的card，请务必在local n之上插入，否则会影响后面二符的del函数
    local n = #stage5bossScpr.cards
    --五boss比较特殊，手动插入
    local index = {1, 2, 1, 3, 2, 4, 3, 4}
    for i = 1, #index do
        info = card_info[i]
        table.insert(stage5bossScpr.cards, create_scpr_show_class(index[i], info[5]))
        table.insert(stage5bossScpr.cards, create_cardpr_class(index[i], info[1], info[2], info[3], info[4], info[5], stage5bossScpr))
    end
    local _sc = stage5bossScpr.cards[n+4] --定位到二非，需要爆炸效果
    function _sc:del()
        self.hscale = 1
        self._wisys:setAction("normal")
        bkeff(self.x, self.y)
        PlaySound("enep00")
        self.vx, self.vy = 0, 0 --该停下来啦
        self.ax, self.ay = 0, 0
    end
    _sc = stage5bossScpr.cards[n+6]  --定位到一符，一符结束后不需要爆炸效果
    function _sc:del()
        self.hscale = 1
        self._wisys:setAction("normal")
        self.vx, self.vy = 0, 0 --该停下来啦
        self.ax, self.ay = 0, 0
    end
end
_editor_class["stage5bossScpr:Normal"] = stage5bossScpr

--LSC定义
local LSC5
do
    LSC5 = create_boss_class("LSC5:Normal", "Normal")
    LSC5.cards={}
    --对话内容
    do
        local _tmp_sc = boss.dialog.New(true)
        function _tmp_sc:init()
            player.dialog = false
            self.dialog_displayer=New(dialog_displayer)
            self._dialog_maintask=task.New(self,function()
                boss_scpr_show(self, 0, 169)
                lscNoBombCheck(self)
            end)
        end
        table.insert(LSC5.cards,_tmp_sc)
    end
    --LSC
    do
        local _tmp_sc = boss.card.New("狂舞「樱神神乐」",2, 10, 60, 2500, {0,0,60}, false, "lastspell")
        function _tmp_sc:init()
            --New(lscSpecialEvent, self)
            task.New(self,function()
                boss_LSC(self)
            end)
        end
        function _tmp_sc:del()
            bkeff(self.x, self.y)
        end
        _tmp_sc.perform=true
        table.insert(LSC5.cards,_tmp_sc)
        table.insert(_sc_table,{"LSC5:Normal", "狂舞「樱神神乐」", _tmp_sc, #LSC5.cards, true})
    end
    _editor_class["LSC5:Normal"] = LSC5
end
