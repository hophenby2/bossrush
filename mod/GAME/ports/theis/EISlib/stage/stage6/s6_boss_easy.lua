--祈华梦六面boss lunatic难度定义
--if not s6_boss then s6_boss = {} end

--boss蓄力特效
local eff, pinkeff, pinkbkeff, bkeff, scbkeff, laser_eff, appear_eff = s6_boss.eff, s6_boss.pinkeff, s6_boss.pinkbkeff, s6_boss.bkeff, s6_boss.scbkeff, s6_boss.laser_eff
--六boss默认的随机x朝向自机移动函数
local move_rd
do
    function move_rd(t, y0, dy, Istask)
        y0 = y0 or 144
        dy = dy or 20
        if Istask then
            task.New(self, function()
                task.MoveToPlayer(t or 60, -40, 40, y0 - dy, y0 + dy, 10, 20, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
            end)
        else
            task.MoveToPlayer(t or 60, -40, 40, y0 - dy, y0 + dy, 10, 20, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
        end
    end
end

local small_fairy, big_fairy
--二符用的小妖精
local spawn_flower_small1, spawn_flower_small2, spawn_flower_big1
do
    small_fairy = Class(enemy)
    function small_fairy:init(x, y, hp)
        enemy.init(self, 25, hp, false, false, true, false, 1, 0, 1, true)
        self.x, self.y = x, y
        self.normalKill = function() end
        self._dyeKill = function() end
    end
    function small_fairy:kill()
        self.normalKill(self)
        enemy.kill(self)
    end
    function small_fairy:dyeKill()
        self._dyeKill(self)
        enemy.kill(self)
        Del(self)
    end
    big_fairy = Class(enemy)
    function big_fairy:init(x, y, hp, i)
        enemy.init(self, 29, hp, false, false, true, true, 1, 0, 1, true)
        self.x, self.y = x, y
        self.pos = i
        self.normalKill = function() end
    end
    function big_fairy:kill()
        self.normalKill(self)
        enemy.kill(self)
    end
end

local atks, scs = {}, {}  --存放非符和符卡函数的表
--开幕演出
local function boss_show(self)
    boss.show_aura(self, false)
    --boss出场前对话插入
    self:show_eff(0, 50) --这是boss出场特效
    --boss出场后对话插入
    boss.show_aura(self, true)
end
local function boss_scpr_show(self, x, y)
    boss.show_aura(self, false)
    self:show_eff(x, y) --这是boss出场特效
    boss.show_aura(self, true)
end
--一非
local function boss_atk1_normal_show(self)
    if EISlib.stage.canDialog() then
        -- 第一段对话
        dialog.player.playScene("LastStage")
        dialog.player.waitSignal("boss fly in", dialog.enum.on)
        -- 出场
        boss_show(self)
        -- 第二段对话
        dialog.player.setSignal("boss fly in complete", dialog.enum.on)
        dialog.player.waitSignal("fade out BGM", dialog.enum.on)
        EISlib.stage.musicFadeOut("s6", 120)
        dialog.player.waitSignal("play BGM", dialog.enum.on)
        LoadMusicRecord("s6_boss")
        EISlib.stage.playMusic("s6_boss", 0, true)
        dialog.player.waitUntilFinish()
        boss.show_aura(self, true) --打开法阵
    else
        -- 出场
        boss_show(self)
        -- BGM
        EISlib.stage.musicFadeOut("s6", 120)
        LoadMusicRecord("s6_boss")
        EISlib.stage.playMusic("s6_boss", 0, true)
        -- 开打
        task.Wait(60)
        boss.show_aura(self, true) --打开法阵
    end
end
local function boss_atk1_scpr_show(self)
    boss_scpr_show(self, 0, 50)
end
local function boss_atk1(self)
    local f1, f2, f3
    do
        function f1(x, y, a, dv)
            local obj = stg.newBulletStraight(stg.grain_a, 3, true, x, y, 0, a)
            egg.AddAccDecChV(obj, 1, a, 60, 0, 60)
            egg.AddAccDecChV(obj, 1, a, 30, 30, 30)
            egg.AddSimStrChV(obj, 0, 1.75 + dv, a, 240, 90)
        end
        function f2(x, y, a, da, dv)
            local obj = stg.newBulletStraight(stg.grain_a, 4, true, x, y, 0, a)
            obj.navi = true
            egg.AddAccDecChV(obj, 1, a, 60, 0, 60)
            egg.AddAccDecChV(obj, 1, a, 30, 30, 30)
            egg.AddSimStrChV(obj, 0, 1.75 + dv, a + da, 240, 90)
        end
        --
        function f3(x, y, a, u)
            local obj = stg.newBulletStraight(stg.ball_mid, 3, true, x, y, 0, a)
            _object.set_color(obj, "", 255, 255, 255, 255)
            obj.img = "Lily_Cherry_bullet"
            obj.hscale, obj.vscale = 0.75, 0.75
            obj.a, obj.b = 2, 2
            obj.rot = a
            obj.navi = true
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET+1
            end)
            egg.AddAccDecChV(obj, 2, a, 10, 0, 50)
            egg.AddSimStrChV(obj, 0, 1, a + ran:Float(0, 30)*u, 180, 0)
        end
    end

    do
        boss.show_aura(self, true)
        pinkeff(self.x, self.y, 60)
        local a, da, r, dr, u, dx, dy = -150, -120/72, 50, 1.5, -1
        a, da = -90 + 60*u, 120/72*u
        r, dr = 50, 1.5
        for _ = 1, 2 do
            for k = 0, 3 do
                dx, dy = r*cos(a), r*sin(a)
                for i = -1, 1 do
                    f1(self.x + dx, self.y + dy, a - (30*i + 120)*u, 0.125*k)
                end
                if k%4 == 0 then
                    for i = -1, 1, 2 do
                        f3(self.x + dx, self.y + dy, a - (15*i + 120)*u, u)
                    end
                end
                task.Wait(2)
                PlaySound("kira00")
                a = a + da
                r = r + dr
            end
            task.Wait(10)
            a = a + 5*da
            for k = 0, 3 do
                dx, dy = r*cos(a), r*sin(a)
                for i = -1, 1 do
                    for j = -1, 1, 2 do
                        f2(self.x + dx, self.y + dy, a - (30*i + 120)*u, 45*j, 0.175*k)
                    end
                end
                if k%4 == 0 then
                    for i = -1, 1, 2 do
                        f3(self.x + dx, self.y + dy, a - (15*i + 120)*u, u)
                    end
                end
                task.Wait(2)
                PlaySound("kira00")
                a = a + da
                r = r + dr
            end
            task.Wait(10)
            a = a + 5*da
        end
        u = -u
        task.MoveTo(0, 100, 90, MOVE_ACC_DEC)
        a, da = -90 + 60*u, 120/72*u
        r, dr = 50, 1.5
        for _ = 1, 3 do
            for k = 0, 3 do
                dx, dy = r*cos(a), r*sin(a)
                for i = -2, 2 do
                    f1(self.x + dx, self.y + dy, a - (30*i + 120)*u, 0.125*k)
                end
                if k%4 == 0 then
                    for i = -3, 3, 2 do
                        f3(self.x + dx, self.y + dy, a - (15*i + 120)*u, u)
                    end
                end
                PlaySound("kira00")
                task.Wait(2)
                a = a + da
                r = r + dr
            end
            task.Wait(10)
            a = a + 5*da
            for k = 0, 3 do
                dx, dy = r*cos(a), r*sin(a)
                for i = -2, 2 do
                    for j = -1, 1, 2 do
                        f2(self.x + dx, self.y + dy, a - (30*i + 120)*u, 45*j, 0.125*k)
                    end
                end
                if k%4 == 0 then
                    for i = -3, 3, 2 do
                        f3(self.x + dx, self.y + dy, a - (15*i + 120)*u, u)
                    end
                end
                task.Wait(2)
                a = a + da
                r = r + dr
            end
            task.Wait(10)
            a = a + 5*da
        end
        task.MoveTo(0, 144, 60, MOVE_ACC_DEC)
        pinkeff(self.x, self.y, 60)
        r, dr = 50, 1
        while true do
            for _ = 1, 6 do
                for k = 0, 3 do
                    for _ = 0, 1 do  --2way
                        a = a + 180
                        dx, dy = r*cos(a), r*sin(a)
                        for i = -1, 1 do
                            f1(self.x + dx, self.y + dy, a - (45*i + 120)*u, 0.175*k)
                        end
                        if k%4 == 0 then
                            for i = -1, 1, 2 do
                                f3(self.x + dx, self.y + dy, a - (30*i + 120)*u, u)
                            end
                        end
                    end
                    task.Wait(2)
                    PlaySound("kira00")
                    a = a + da
                    r = r + dr
                end
                task.Wait(10)
                a = a + 5*da
                for k = 0, 3 do
                    for _ = 0, 1 do --2way
                        a = a + 180
                        dx, dy = r*cos(a), r*sin(a)
                        for i = -1, 1 do
                            for j = -1, 1, 2 do
                                f2(self.x + dx, self.y + dy, a - (45*i + 120)*u, 45*j, 0.175*k)
                            end
                        end
                        if k%3 == 0 then
                            for i = -1, 1, 2 do
                                f3(self.x + dx, self.y + dy, a - (30*i + 120)*u, u)
                            end
                        end
                    end
                    task.Wait(2)
                    PlaySound("kira00")
                    a = a + da
                    r = r + dr
                end
                task.Wait(10)
                a = a + 5*da
            end
            u = -u
            da = -da
            dr = -dr
        end
    end
end
table.insert(atks, {boss_atk1, boss_atk1_normal_show, boss_atk1_scpr_show})
--二非
local function boss_atk2_normal_show(self)
    egg.SimAlpCh(self, 100, 255, 60)
    task.Wait(30)
    task.MoveTo(0, 100, 60, MOVE_NORMAL)
    if IsValid(lstg.tmpvar.bg) then  --切换背景
        stage6_background.senceBoss3(lstg.tmpvar.bg)
    end
    self.colli = true
end
local function boss_atk2_scpr_show(self)
    boss_scpr_show(self, 0, 100)
    s6_boss.back_light.appear(self.back_light)
    task.Wait(30)
end
local function boss_atk2(self)
    local f1, f2, f3
    do
        function f1(x, y, a, dv)
            local obj = stg.newBulletStraight(stg.grain_a, 3, false, x, y, 0, a)
            local v0 = 1.5 + dv
            egg.AddSimStrChV(obj, 0, v0, a, 10*v0)
        end
        function f2(x, y, a, dv0, dv1, da)
            local obj = stg.newBulletStraight(stg.grain_a, 3, false, x, y, 0, a)
            local v0 = 1.5 + dv0
            obj.navi = true
            egg.AddSimStrChV(obj, 0, v0, a, 10*v0)
            task.New(obj, function()
                task.Wait(60)
                task.New(obj, function()
                    obj.img = "Lily_Cherry_bullet"
                    obj.layer = LAYER_ENEMY_BULLET+1
                    obj.hscale, obj.vscale = 1.5, 1.5
                    obj.a, obj.b = 2, 2
                    egg.SimAlpCh(obj, 0, 255, 15)
                    egg.SimSizeCh(obj, 2, 0.75, 15)
                end)
                egg.AddSimStrChV(obj, 0, v0 + 1.75 + dv1, a + 180 + da, 60)
            end)
        end
        function f3(x, y, a, dv)
            local obj = stg.newBulletStraight(stg.grain_a, 5, true, x, y, 0, a)
            egg.AddSimStrChV(obj, 0, 2 + dv, a, 30)
        end
    end

    do
        pinkeff(self.x, self.y, 60)
        local flower_pos = s6_boss.back_light.getFlowersPos(self.back_light) --获取花的位置
        local flower_a0 = {0, 180, -90, 180, 0}
        local flower_u = {1, -1, 1, 1, -1}
        --3号炮台
        task.New(self, function()
            task.Wait(240)
            local dsp, da, a = 45, 1
            for way = 1, 1 do
                a = Angle(flower_pos[3][1], flower_pos[3][2], player.x, player.y) - 0.5*dsp*(way-1)
                for i = 1, 3 + way do
                    for j = 0, way - 1 do
                        f3(flower_pos[3][1], flower_pos[3][2], a + j*dsp, 0.175*i)
                    end
                    PlaySound("kira00")
                    task.Wait(6)
                    a = a + da
                end
                task.Wait(80)
                dsp = dsp - 20
                da = -da
            end
            while true do
                a = Angle(flower_pos[3][1], flower_pos[3][2], player.x, player.y)
                for i = 1, 5 do
                    f3(flower_pos[3][1], flower_pos[3][2], a, 0.225*i)
                    PlaySound("kira00")
                    task.Wait(4)
                    a = a + da
                end
                task.Wait(40)
                da = -da
            end
        end)
        local a, da = 0, 1.5
        local la = 4
        for _ = 1, 5 do
            for k = 1, 1 do
                for j = 1, 5 do
                    if j ~= 3 then
                        f2(flower_pos[j][1], flower_pos[j][2], flower_a0[j] + a*flower_u[j], 0.1*k, 0.1*k, 0)
                    end
                end
                PlaySound("tan00")
                task.Wait(6)
                a = a + da
            end
            for k = 2, la do
                for j = 1, 5 do
                    if j ~= 3 then
                        f1(flower_pos[j][1], flower_pos[j][2], flower_a0[j] + a*flower_u[j], 0.1*k)
                    end
                end
                PlaySound("tan00")
                task.Wait(6)
                a = a + da
            end
            task.Wait(42-la*3)
            la = la + 1
            a = a + 25*da
        end
        --la达到最大值,此后开始加速
        pinkeff(self.x, self.y, 0)
        s6_boss.changeSpeed(1.5)
        while true do
            for k = 1, 1 do
                for j = 1, 5 do
                    if j ~= 3 then
                        f2(flower_pos[j][1], flower_pos[j][2], flower_a0[j] + a*flower_u[j], 0.2*k, 0.15*k, 0*flower_u[j]*k)
                    end
                end
                task.Wait(3)
                a = a + da
            end
            for k = 2, 10 do
                for j = 1, 5 do
                    if j ~= 3 then
                        f1(flower_pos[j][1], flower_pos[j][2], flower_a0[j] + a*flower_u[j], 0.2*k)
                    end
                end
                task.Wait(3)
                a = a + da
            end
            task.Wait(6)
            a = a + 25*da
        end
    end
end
table.insert(atks, {boss_atk2, boss_atk2_normal_show, boss_atk2_scpr_show})
--三非
local function boss_atk3_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 90, 60, MOVE_NORMAL)
    if IsValid(lstg.tmpvar.bg) then  --切换背景
        stage6_background.senceBoss4(lstg.tmpvar.bg)
    end
end
local function boss_atk3_scpr_show(self)
    boss_scpr_show(self, 0, 90)
    s6_boss.back_light.appear(self.back_light)
    task.Wait(30)
end
local function boss_atk3(self)
    local f1, f2
    do
        function f1(x, y, a, u)
            local obj = stg.newBulletStraight(stg.ball_mid, 3, false, x, y, 0, a)
            _object.set_color(obj, "", 255, 255, 255, 255)
            obj.img = "Lily_Cherry_bullet"
            obj.hscale, obj.vscale = 0.75, 0.75
            obj.a, obj.b = 2, 2
            obj.bound = false
            obj.navi = true
            egg.AddSimStrChV(obj, 0, 4, a, 10)
            egg.AddSimStrChV(obj, 0, 4, a + 150*u, 120)
            task.New(obj, function()
                task.Wait(85)
                obj.layer = LAYER_ENEMY_BULLET+1
                egg.AddSimStrChV(obj, 0, 4.5, obj.rot + 180, 120)
                task.Wait(90)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, 0.35, obj.rot + 45*u, 90)
                task.Wait(300)
                obj.bound = true
            end)
        end
        function f2(x, y, a, u)
            local obj = stg.newBulletStraight(stg.ball_mid, 3, false, x, y, 0, a)
            _object.set_color(obj, "", 255, 255, 255, 255)
            obj.img = "Lily_Cherry_bullet"
            obj.hscale, obj.vscale = 0.75, 0.75
            obj.a, obj.b = 2, 2
            obj.bound = false
            obj.navi = true
            egg.AddSimStrChV(obj, 0, 4, a, 10)
            egg.AddSimStrChV(obj, 0, 4, a + 150*u, 120)
            task.New(obj, function()
                task.Wait(75)
                obj.layer = LAYER_ENEMY_BULLET+1
                egg.AddSimStrChV(obj, 0, 5, obj.rot + 180, 60)
                egg.AddSimStrChV(obj, 0, -1, a + 150*u, 60)
                task.Wait(90)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, 1.25, obj.rot - 45*u, 60)
                task.Wait(300)
                obj.bound = true
            end)
        end
    end

    do
        --变速特效
        task.New(self, function()
            task.Wait(300)
            pinkeff(self.x, self.y)
            s6_boss.changeSpeed(1.5)
        end)
        local flower_pos = s6_boss.back_light.getFlowersPos(self.back_light) --获取花的位置
        local flower_a0 = {0, 180, -90, 180, 0}
        pinkeff(self.x, self.y, 90)
        task.New(self, function()
            --自机狙
            task.Wait(120)
            for la = 2, 3 do
                for i = 1, 5 do
                    flower_a0[i] = Angle(flower_pos[i][1], flower_pos[i][2], player.x, player.y)
                end
                for j = 1, la do
                    for i = 1, 5 do
                        for k = -1, 1 do
                            stg.newBulletStraight(stg.grain_a, 3, true, flower_pos[i][1], flower_pos[i][2], 2+0.2*j, flower_a0[i] + 50*k)
                        end
                    end
                    task.Wait(8)
                end
                task.Wait(120)
            end
            while true do
                for i = 1, 5 do
                    flower_a0[i] = Angle(flower_pos[i][1], flower_pos[i][2], player.x, player.y)
                end
                for j = 1, 5 do
                    for i = 1, 5 do
                        for k = -1, 1 do
                            stg.newBulletStraight(stg.grain_a, 3, true, flower_pos[i][1], flower_pos[i][2], 2+0.2*j, flower_a0[i] + 50*k)
                        end
                    end
                    task.Wait(3)
                end
                task.Wait(120)
            end
        end)
        local a, da
        --中间攻击
        do
            for u = -1, -1, -2 do
                a, da = 90 - 64*u, 3.5*u
                for _ = 1, 4 do
                    for i = -4, 4 do
                        if i%2 == 1 then
                            f1(self.x, self.y, a + 20*i, u)
                        else
                            f2(self.x, self.y, a + 20*i, u)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(30)
                    a = a + da
                end
                task.Wait(120)
            end
        end
        while true do
            for u = 1, -1, -2 do
                a, da = 90 - 64*u, 3.5*u
                for _ = 1, 6 do
                    for i = -4, 4 do
                        if i%2 == 1 then
                            f1(self.x, self.y, a + 20*i, u)
                        else
                            f2(self.x, self.y, a + 20*i, u)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(25)
                    a = a + da
                end
                task.Wait(100)
            end
        end
    end
end
table.insert(atks, {boss_atk3, boss_atk3_normal_show, boss_atk3_scpr_show})
--四非
local function boss_atk4_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 144, 60, MOVE_NORMAL)
end
local function boss_atk4_scpr_show(self)
    boss_scpr_show(self, 0, 144)
    s6_boss.back_light.appear(self.back_light)
    task.Wait(30)
end
local function boss_atk4(self)
    local f1, f2, f3
    do
        function f1(x, y, a, da, t)
            local obj = stg.newBulletStraight(stg.ball_mid_c, 3, false, x, y, 0, a)
            egg.AddAccDecChV(obj, 2, a, 10, 20, 60)
            egg.AddSimStrChV(obj, 0, 1, a + da, t, 30)
            task.New(obj, function()
                task.Wait(30 + t)
                stg.setBulletStyle(obj, stg.ball_mid, 4)
            end)
        end
        function f2(x, y, a, u)
            local obj = stg.newBulletStraight(stg.ball_mid_c, 3, false, x, y, 0, a)
            _object.set_color(obj, "", 255, 255, 255, 255)
            obj.img = "Lily_Cherry_bullet"
            obj.hscale, obj.vscale = 0.75, 0.75
            obj.a, obj.b = 2, 2
            obj.bound = false
            obj.navi = true
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET+2
                egg.AddAccDecChV(obj, 1, a, 30, 30, 60)
                egg.AddSimStrChV(obj, 0, 1, a + 60*u, 60, 30)
            end)
        end
        function f3(x, y, a)
            local obj = stg.newBulletStraight(stg.ball_light, 10, true, x, y, 0, a, true)
            _object.set_color(obj, "mul+rev",255, 255, 255, 255)
            obj.undestoryable = true --真正不可消除
            obj.hscale, obj.vscale = 0, 0.25
            obj.a, obj.b = 0, 0.25*obj.b
            obj.bound = false
            obj.hide = true
            obj.colli = false
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET-2
                _object.set_color(laser_eff(x, y, a, 0, 0, 0, 0.4), "mul+rev", 100, 0, 255, 0)
                PlaySound("lazer00")
                task.Wait(45)
                PlaySound("lazer01")
                SetV(obj, 5, a)
                obj.hide = false
                obj.colli = true
                task.New(obj, function()
                    local dh = 0.15
                    for _ = 1, 20 do
                        obj.hscale = obj.hscale + dh
                        obj.a = obj.a + 8*dh
                        task.Wait(1)
                    end
                    task.Wait(120)
                    obj.bound = true
                end)
            end)
        end
    end

    do
        pinkeff(self.x, self.y, 60)
        local flower_pos = s6_boss.back_light.getFlowersPos(self.back_light) --获取花的位置
        local flower_a0 = {0, 180, -90, 180, 0}
        --花瓣
        task.New(self, function()
            task.Wait(180)
            pinkeff(flower_pos[3][1], flower_pos[3][2], 60)
            local way, dsp, a = 6, 30
            while true do
                a = 90 - 0.5*dsp*(way-1)
                for _ = 1, way do
                    for u = -1, 1, 2 do
                        f2(flower_pos[3][1], flower_pos[3][2], a, u)
                    end
                    a = a + dsp
                end
                task.Wait(180)
                way = way + 1
            end
        end)
        --激光
        task.New(self, function()
            task.Wait(60)
            pinkeff(flower_pos[2][1], flower_pos[2][2])
            pinkeff(flower_pos[4][1], flower_pos[4][2], 60)
            local frame = 250
            while true do
                for i = -1, 1 do
                    f3(flower_pos[2][1], flower_pos[2][2], Angle(flower_pos[2][1], flower_pos[2][2], player.x, player.y) + 30*i)
                    f3(flower_pos[4][1], flower_pos[4][2], Angle(flower_pos[4][1], flower_pos[4][2], player.x, player.y) + 30*i)
                end
                task.Wait(frame)
                frame = max(frame - 20, 210)
            end
        end)
        local u = 1
        for m = 0, 2 do
            for i = 1, 10 do
                for j = 1, 1 + 1*m do
                    f1(flower_pos[1][1], flower_pos[1][2], -75 - 100*u + (19.5*i)*u, 4.5*j*u, 60*j)
                    f1(flower_pos[5][1], flower_pos[5][2], -105 + 100*u - (19.5*i)*u, -4.5*j*u, 60*j)
                end
                PlaySound("tan00")
                task.Wait(9)
            end
            u = -u
        end
        pinkeff(self.x, self.y)
        s6_boss.changeSpeed(1.5)
        while true do
            for i = 1, 10 do
                for j = 1, 3 do
                    f1(flower_pos[1][1], flower_pos[1][2], -75 - 100*u - 17.5*(u-1) + (19.5*i)*u, 4.5*j*u, 60*j)
                    f1(flower_pos[5][1], flower_pos[5][2], -105 + 100*u + 17.5*(u-1) - (19.5*i)*u, -4.5*j*u, 60*j)
                end
                PlaySound("tan00")
                task.Wait(9)
            end
            u = -u
        end
    end
end
table.insert(atks, {boss_atk4, boss_atk4_normal_show, boss_atk4_scpr_show})
--一符
local function boss_sc1_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 100, 60, MOVE_NORMAL)
end
local function boss_sc1_scpr_show(self)
    boss_scpr_show(self, 0, 100)
end
local function boss_sc1(self)
    local f1, f1_1, f1_2, f2, f3, f4, f5, f5_1, f6, f6_1

    local drot = {5, 10, 15, 20}

    do
        function f1(x, y, rot, u)
            local b1 = New(s6_boss.branch, x, y, rot, 120, 20, 15)
            _connect(self, b1, 0, true)
            local branchs = {{7.5, 90, 12, 5}, {7.5, 70, 10, 5}, {10, 50, 8, 5}, {15, 30, 5, 5}}
            local t
            task.New(b1, function()
                for i = 1, #branchs do
                    t = branchs[i][2] --根据长度来决定生长时间
                    s6_boss.branch.addMainBranch(b1, branchs[i][1]*u, branchs[i][2], branchs[i][3], branchs[i][4])
                    s6_boss.branch.grow(b1, 0.33*t, i - 1, i - 1 + 0.33, true, f1_2)
                    f1_1(b1, i, 0.33, 35*u, 100 - 10*i, s6_boss.branch.getWide(b1, i, 0.33), 5-i, 0.5*u)
                    s6_boss.branch.grow(b1, 0.33*t, i - 1 + 0.33, i - 1 + 0.66, true, f1_2)
                    f1_1(b1, i, 0.66, (-15 + 2*i)*u, 120 - 10*i, s6_boss.branch.getWide(b1, i, 0.66), 5-i, 0.5*u)
                    s6_boss.branch.grow(b1, 0.34*t, i - 1 + 0.66, i, true, f1_2)
                end
            end)
        end
        --为某个branch的某节i生成一整条侧枝
        function f1_1(branch, i, rate, da, length, w0, count, u)
            local dlength = (30 - length)/count
            local dw = (5 - w0)/count
            local obj = s6_boss.branch.addOtherBranch(branch, i, rate, da, length, w0, w0 + dw)
            _connect(self, obj, 0, true)
            local t
            task.New(obj, function()
                for i = 1, count do
                    length = length + dlength
                    t = length
                    w0 = w0 + dw
                    s6_boss.branch.addMainBranch(obj, drot[i]*u, length, w0, 2)
                    s6_boss.branch.grow(obj, t, i - 1, i, true, f1_2)
                end
            end)
        end
        --生成时的帧事件
        function f1_2(self)
            if self.timer%40 == 0 then
                PlaySound("kira00")
                local x, y = s6_boss.branch.getHeadPos(self)
                f2(x, y, s6_boss.branch.getHeadRot(self) - 90)
            end
        end
        --生成时的花瓣
        function f2(x, y, a)
            a = a + ran:Float(-60, 35)
            local obj = stg.newBulletStraight(stg.ball_mid, 3, true, x, y, 0, a, true)
            obj.timer = 11
            _object.set_color(obj, "", 0, 255, 255, 255)
            obj.colli = false
            obj.img = "Lily_Cherry_bullet"
            obj.hscale, obj.vscale = 0.75, 0.75
            obj.a, obj.b = 2*obj.hscale, 2*obj.vscale
            obj.rot = a
            obj.navi = true
            egg.AddSimStrChV(obj, 0, 0.5, a, 60)
            egg.AddSimStrChV(obj, 0, ran:Float(1.5, 2), a, 60, 60)
            task.New(obj, function()
                egg.SimAlpCh(obj, 0, 255, 30)
                task.Wait(20)
                obj.colli = true
            end)
        end
        --集中的花瓣
        function f3(x, y, v0, v1, a, da, t)
            local obj = stg.newBulletStraight(stg.ball_mid, 3, true, x, y, 0, a, true)
            obj.timer = 11
            obj.bound = false
            _object.set_color(obj, "", 0, 255, 255, 255)
            obj.colli = false
            obj.img = "Lily_Cherry_bullet"
            obj.hscale, obj.vscale = 0.75, 0.75
            obj.a, obj.b = 2*obj.hscale, 2*obj.vscale
            obj.rot = a
            obj.navi = true
            egg.AddSimStrChV(obj, 0, v0, a, 90)
            egg.AddSimStrChV(obj, 0, v1, a + da, 240, 90)
            task.New(obj, function()
                egg.SimSizeCh(obj, 1.5, 0.75, 30)
                egg.SimAlpCh(obj, 0, 255, 30)
                task.Wait(30)
                obj.colli = true
                task.Wait(t - 20 + 60)
                Del(obj)
            end)
        end
        --产生花
        function f4(x, y, u)
            f5(x, y, u)
            task.New(self, function()
                local r, a, _x, _y
                for k = 1, 24 do
                    PlaySound("kira00")
                    r = 30 + 20*k
                    for i = 1, 4 do
                        a = 10*k*u + 90*i
                        _x, _y = x + r*cos(a), y + r*sin(a)
                        if Dist(_x, _y, player.x, player.y) > 50 then
                            f3(_x, _y, 0.75, 1, a + 180, 0, 120 + 12*k)
                        end
                    end
                    task.Wait(8)
                end
            end)
        end
        --大花~!
        function f5(x, y, u)
            local obj = stg.newBulletStraight(stg.ball_light, 3, true, x, y, 0, 0, true)
            _object.set_color(obj, "", 255, 255, 255, 255)
            obj.colli = false
            obj.timer = 11
            obj.hscale, obj.vscale = 0, 0
            task.New(obj, function()
                local rate
                for x = 1, 60 do
                    rate = sin(x)
                    obj.hscale, obj.vscale = rate, rate
                    task.Wait(1)
                end
                obj.colli = true
            end)
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET+2
                for i = 3, 1, -1 do
                    for j = 1, 8 do
                        f5_1(obj, 0.4 + 0.1*i, 10 + 4*i, 90 + 45*j*u + 22.5*i)
                        task.Wait(20)
                    end
                end
                while self.timer < 1500 do
                    PlaySound("tan00")
                    task.Wait(150)
                end
                while not self.release do
                    task.Wait(1)
                end
                egg.SimSizeCh(obj, 1, 3, 60)
                egg.SimAlpCh(obj, 255, 0, 60)
                task.Wait(60)
                Del(obj)
            end)
        end
        --大花花瓣
        function f5_1(mst, s, r, a)
            local obj = stg.newBulletStraight(stg.ball_mid, 3, true, mst.x, mst.y, 0, 0, true)
            _object.set_color(obj, "", 0, 255, 255, 255)
            obj.img = "Lily_Cherry_bullet"
            obj.hscale, obj.vscale = s, s
            obj.size = 0
            obj.a, obj.b = 2*s, 2*s
            obj.rot = a
            task.New(obj, function()
                local x = 0
                while true do
                    obj.hscale, obj.vscale = obj.size*s, obj.size*s
                    x = x + 1
                    task.Wait(1)
                end
            end)
            --最开始变大
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET+1
                local dx, dy, ds = cos(a), sin(a), 1/30
                for _ = 1, 30 do
                    if IsValid(mst) then
                        obj.size = obj.size + ds
                        obj.x, obj.y = mst.x + obj.size*r*dx, mst.y + obj.size*r*dy
                        obj._a = 255*obj.size
                    end
                    task.Wait(1)
                end
                while IsValid(mst) and not self.release do
                    task.Wait(1)
                end
                egg.AddSimStrChV(obj, 2.5, 1 + s, obj.rot, 30)
            end)
        end
        --小花
        function f6(x, y, u, isRelease)
            local obj = stg.newBulletStraight(stg.ball_mid_c, 3, true, x, y, 0, 0, true)
            obj.colli = false
            obj.timer = 11
            obj.hscale, obj.vscale = 0, 0
            task.New(obj, function()
                local rate
                for x = 1, 60 do
                    rate = sin(x)
                    obj.hscale, obj.vscale = 1.5*rate, 1.5*rate
                    task.Wait(1)
                end
                obj.colli = true
            end)
            task.New(obj, function()
                for j = 1, 5 do
                    f6_1(obj, 0.75, 10, 90 + 72*j*u )
                    task.Wait(10)
                end
                if isRelease then
                    egg.AddSimStrChV(obj, 0, ran:Float(0.75, 1), ran:Float(-95, -85), 240)
                end
            end)
        end
        --小花花瓣
        function f6_1(mst, s, r, a)
            local obj = stg.newBulletStraight(stg.ball_mid, 3, true, mst.x, mst.y, 0, 0, true)
            _object.set_color(obj, "", 0, 255, 255, 255)
            obj.hscale, obj.vscale = s, 0.75*s
            obj.size = 0
            obj.a, obj.b = 2*s, 2*s
            obj.rot = a
            task.New(obj, function()
                local x,  rate = 0
                while true do
                    rate = 1.05 + 0.05*sin(x)
                    obj.hscale, obj.vscale = obj.size*s*rate, 1.2*obj.size*s*rate
                    x = x + 1
                    task.Wait(1)
                end
            end)
            --最开始变大
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET-1
                local dx, dy, ds = cos(a), sin(a), 1/30
                for _ = 1, 30 do
                    if IsValid(mst) then
                        obj.size = obj.size + ds
                        obj.x, obj.y = mst.x + obj.size*r*dx, mst.y + obj.size*r*dy
                        obj._a = 255*obj.size
                    end
                    task.Wait(1)
                end
                while IsValid(mst) do
                    obj.vx, obj.vy = mst.vx, mst.vy
                    task.Wait(1)
                end
                Del(obj)
            end)
        end
    end

    do
        s6_boss.pic_show()
        task.Wait(90)
        self.colli = false
        egg.SimAlpCh(self, 255, 100, 60)
        self.x, self.y = 0, 100
        f1(-240, -100, 55, 1)
        f1(-220, -100, 20, 1)
        task.Wait(270)
        --树
        --[[f1(0, -224, 55, 1)
        f1(0, -224, 20, 1)
        f1(0, -224, 125, -1)
        f1(0, -224, 160, -1)]]
        --生成其他小花
        task.New(self, function()
            for _ = 1, 15 do
                f6(ran:Float(-192, 192), ran:Float(50, 192), ran:Sign(), true)
                task.Wait(60)
            end
            for _ = 1, 10 do
                f6(ran:Float(-192, 192), ran:Float(50, 192), ran:Sign(), true)
                task.Wait(15)
            end
        end)
        --召唤五朵花
        do
            local r, a
            f4(0, self.y - 105, 1)
            for i = 1, 9 do
                r, a = ran:Float(40, 50), 90 + 40*(i-1) + ran:Float(-10,10)
                f6(r*cos(a), self.y - 105 + r*sin(a), ran:Sign())
                task.Wait(35)
            end
            task.Wait(60)
            f4(self.x - 95, self.y - 65, -1)
            f4(self.x + 95, self.y - 65, 1)
            for i = 1, 9 do
                r, a = ran:Float(50, 80), 90 + 40*(i-1) + ran:Float(-10,10)
                f6(self.x - 95 + r*cos(a), self.y - 65 + r*sin(a), ran:Sign())
                r, a = ran:Float(50, 80), 90 - 40*(i-1) + ran:Float(-10,10)
                f6(self.x + 95+ r*cos(a), self.y - 65 + r*sin(a), ran:Sign())
                task.Wait(35)
            end
            task.Wait(60)
            f4(self.x - 140, self.y - 15, -1)
            f4(self.x + 140, self.y - 15, 1)
            for i = 1, 9 do
                r, a = ran:Float(50, 80), 90 + 40*(i-1) + ran:Float(-10,10)
                f6(self.x - 140 + r*cos(a), self.y - 15 + r*sin(a), ran:Sign())
                task.Wait(35)
            end
            task.Wait(75)
            s6_boss.pinkeff(self.x, self.y, 70)
            task.Wait(60)
            --五波蓄力
            do
                s6_boss.pinkeff(0, self.y - 105)
                s6_boss.pinkeff(self.x - 95, self.y - 65)
                s6_boss.pinkeff(self.x + 95, self.y - 65)
                s6_boss.pinkeff(self.x - 140, self.y - 15)
                s6_boss.pinkeff(self.x + 140, self.y - 15)
            end
            task.Wait(40)
            misc.ShakeScreen(120, 2)
            s6_boss.back_light.appear(self.back_light)
            task.Wait(120)
            misc.ShakeScreen(30, 5)
            --五处爆炸
            do
                s6_boss.pinkbkeff(0, self.y - 105)
                s6_boss.pinkbkeff(self.x - 95, self.y - 65)
                s6_boss.pinkbkeff(self.x + 95, self.y - 65)
                s6_boss.pinkbkeff(self.x - 140, self.y - 15)
                s6_boss.pinkbkeff(self.x + 140, self.y - 15)
            end
            self.release = true
        end
    end

end
table.insert(scs, {boss_sc1, boss_sc1_normal_show, boss_sc1_scpr_show})
--二符
local function boss_sc2_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 100, 60, MOVE_NORMAL)
end
local function boss_sc2_scpr_show(self)
    boss_scpr_show(self, 0, 100)
    s6_boss.back_light.appear(self.back_light)
    task.Wait(30)
end
local function boss_sc2(self)
    local f1, f1_1, f1_2, f2, f3, f4, f5
    do
        --产生瀑布弹的使魔
        function f1(x, y, a, u, wt)
            local obj = stg.newBulletStraight(stg.ball_mid, 5, true, x, y, 4.5, a, true)
            obj.hide = true
            egg.AddSimStrChV(obj, 0, 3, a + 90*u, 120)
            --产生小玉
            task.New(obj, function()
                local a
                for k = 1, 15 do
                    a = Angle(0, 0, obj.dx, obj.dy) - 3*k*u - 15
                    for i = 1, 8 do
                        for j = 1, 2 do
                            f1_1(obj.x, obj.y, 0.65 + 0.35*j, a + i*60, 5)
                        end
                        for j = 1, 2 do
                            f1_1(obj.x, obj.y, 1.15 + 0.4*j, a + i*60 + 30, 8)
                        end
                    end
                    PlaySound("kira00")
                    task.Wait(wt)
                end
            end)
            --产生锥形弹幕
            task.New(obj, function()
                local a
                for _ = 1, 5 do
                    a = Angle(obj, player)
                    for j = 1, 8 do
                        f1_2(obj.x, obj.y, 1.5, a + 45*j, 5)
                    end
                    task.Wait(20)
                    for j = 1, 8 do
                        f1_2(obj.x, obj.y, 1.5, a + 45*j + 22.5, 8)
                    end
                    task.Wait(20)
                end
            end)
            --产生特效
            task.New(obj, function()
                while true do
                    f5(obj.x, obj.y)
                    task.Wait(3)
                end
            end)
        end
        function f1_1(x, y, v, a, co)
            local obj = stg.newBulletStraight(stg.ball_mid_c, co, true, x, y, 0, a, true)
            obj.timer = 11
            _object.set_color(obj, "", 0, 255, 255, 255)
            egg.SimAlpCh(obj, 0, 255, 10)
            egg.AddSimStrChV(obj, 0, v, a, 30)
        end
        function f1_2(x, y, v, a, co)
            local obj = stg.newBulletStraight(stg.grain_b, co, true, x, y, 0, a, true)
            obj.timer = 11
            _object.set_color(obj, "", 0, 255, 255, 255)
            egg.SimAlpCh(obj, 0, 255, 10)
            egg.AddSimStrChV(obj, 0, v, a, 120)
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET+1
            end)
        end
        --1的弱化版
        function f2(x, y, a, u, wt)
            local obj = stg.newBulletStraight(stg.ball_mid, 5, true, x, y, 2, a, true)
            obj.hide = true
            egg.AddSimStrChV(obj, 0, 1.5, a + 90*u, 120)
            task.New(obj, function()
                task.Wait(30)
                local a
                for k = 1, 15 do
                    a = (45 + 7.5*k)*u
                    for i = 1, 6 do
                        for j = 1, 2 do
                            f1_1(obj.x, obj.y, 0.65 + 0.35*j, a + i*60, 5)
                        end
                        for j = 1, 2 do
                            f1_1(obj.x, obj.y, 1.15 + 0.4*j, a + i*60 + 30, 8)
                        end
                    end
                    PlaySound("kira00")
                    task.Wait(wt)
                end
            end)
            task.New(obj, function()
                task.Wait(70)
                local a
                for _ = 1, 5 do
                    a = Angle(obj, player)
                    for j = 1, 6 do
                        f1_2(obj.x, obj.y, 1.5, a + 60*j, 5)
                    end
                    task.Wait(20)
                    for j = 1, 6 do
                        f1_2(obj.x, obj.y, 1.5, a + 60*j + 22.5, 8)
                    end
                    task.Wait(20)
                end
            end)
            task.New(obj, function()
                while true do
                    f5(obj.x, obj.y)
                    task.Wait(3)
                end
            end)
        end
        --boss自身发射的炎弹
        function f3(x, y, v, a, co)
            local obj = stg.newBulletStraight(stg.water_drop, co, true, x, y, 0, a, true)
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            egg.AddSimStrChV(obj, 0, v, a, 120)
        end
        --循环结束波
        function f4(x, y, a, u, wt)
            local obj = stg.newBulletStraight(stg.ball_mid, 5, true, x, y, 2, a, true)
            obj.hide = true
            egg.AddSimStrChV(obj, 0, 1.5, a + 90*u, 120)
            task.New(obj, function()
                local a
                for k = 1, 15 do
                    a = (30 + 5*k)*u
                    for i = 1, 6 do
                        for j = 1, 2 do
                            f1_1(obj.x, obj.y, 0.65 + 0.35*j, a + i*60, 5)
                        end
                        for j = 1, 2 do
                            f1_1(obj.x, obj.y, 1.15 + 0.4*j, a + i*60 + 30, 8)
                        end
                    end
                    PlaySound("kira00")
                    task.Wait(wt)
                end
            end)
            task.New(obj, function()
                local a
                for _ = 1, 5 do
                    a = Angle(obj, player)
                    for j = 1, 6 do
                        f1_2(obj.x, obj.y, 1.5, a + 60*j, 5)
                    end
                    task.Wait(20)
                    for j = 1, 6 do
                        f1_2(obj.x, obj.y, 1.5, a + 60*j + 22.5, 8)
                    end
                    task.Wait(20)
                end
            end)
            task.New(obj, function()
                while true do
                    f5(obj.x, obj.y)
                    task.Wait(3)
                end
            end)
        end
        --放大的光玉特效
        function f5(x, y)
            local obj = stg.newBulletStraight(stg.ball_light, 8, true, x, y, 0, 0)
            _connect(self, obj, 0, true)
            obj.group = GROUP_GHOST
            _object.set_color(obj, "mul+add", 0, 150, 150, 255)
            obj.timer = 11
            obj.hscale, obj.vscale = 0, 0
            egg.SimSizeCh(obj, 0, 6, 60)
            egg.SimAlpCh(obj, 150, 0, 60)
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET+3
                task.Wait(60)
                Del(obj)
            end)
        end
    end

    do
        --self.x, self.y = 0, 100
        s6_boss.pic_show()
        task.Wait(90)
        --第一波
        do
            pinkeff(-192, 50, 60)
            f1(-192, 50, 10 + ran:Float(0, 5), 1, 15)
            task.Wait(150)
            pinkeff(192, 50, 60)
            f1(192, 50, 170 + ran:Float(0, -5), -1, 15)
            task.Wait(240)
            pinkeff(-192, -50)
            pinkeff(192, -50, 0)
            f2(-192, -50, 60 + ran:Float(-2, 2), 1, 20)
            f2(192, -50, 120 + ran:Float(-2, 2), -1, 20)
            task.Wait(180)
            pinkeff(self.x, self.y, 60)
            --发射炎弹
            do
                local r, a
                for k = 1, 8 do
                    r = 60 - 3*k
                    a = 6*k
                    for _ = 1, 9 do
                        a = a + 40
                        f3(self.x + r*cos(a), self.y + r*sin(a), 0.9, a, 5)
                    end
                    PlaySound("kira00")
                    task.Wait(6)
                end
                for k = 8, 1, -1 do
                    r = 60 - 3*k
                    a = 6*k + 3
                    for _ = 1, 9 do
                        a = a + 40
                        f3(self.x + r*cos(a), self.y + r*sin(a), 1.6 + 0.075*k, a, 8)
                    end
                    PlaySound("kira00")
                    task.Wait(6)
                end
            end
            task.Wait(60)
            pinkeff(-100, 224)
            pinkeff(100, 224, 60)
            f4(-100, 224, -150 + ran:Float(-2, 2), -1, 15)
            f4(100, 224, -30 + ran:Float(-2, 2), 1, 15)
            task.Wait(300)
        end
        --循环波（虽然也就两波233
        while true do
            pinkeff(-192, 50, 60)
            f1(-192, 50, 10 + ran:Float(0, 5), 1, 12)
            task.Wait(120)
            pinkeff(-192, 50, 60)
            f1(192, 50, 170 + ran:Float(0, -5), -1, 12)
            task.Wait(240)
            pinkeff(-192, -50)
            pinkeff(192, -50, 0)
            f2(-192, -50, 60 + ran:Float(-2, 2), 1, 17)
            f2(192, -50, 120 + ran:Float(-2, 2), -1, 17)
            task.Wait(180)
            pinkeff(self.x, self.y, 60)
            --发射炎弹
            do
                local r, a
                for k = 1, 8 do
                    r = 60 - 3*k
                    a = 6*k
                    for _ = 1, 12 do
                        a = a + 30
                        f3(self.x + r*cos(a), self.y + r*sin(a), 0.9, a, 5)
                    end
                    PlaySound("kira00")
                    task.Wait(6)
                end
                for k = 8, 1, -1 do
                    r = 60 - 3*k
                    a = 6*k + 3
                    for _ = 1, 12 do
                        a = a + 30
                        f3(self.x + r*cos(a), self.y + r*sin(a), 1.6 + 0.075*k, a, 8)
                    end
                    PlaySound("kira00")
                    task.Wait(6)
                end
            end
            task.Wait(30)
            pinkeff(-100, 224)
            pinkeff(100, 224, 60)
            f4(-100, 224, -150 + ran:Float(-2, 2), -1, 12)
            f4(100, 224, -30 + ran:Float(-2, 2), 1, 12)
            task.Wait(300)
        end
    end
end
table.insert(scs, {boss_sc2, boss_sc2_normal_show, boss_sc2_scpr_show})
--三符
local function boss_sc3_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 100, 60, MOVE_NORMAL)
end
local function boss_sc3_scpr_show(self)
    boss_scpr_show(self, 0, 100)
    s6_boss.back_light.appear(self.back_light)
    task.Wait(30)
end
local function boss_sc3(self)
    local my_flower = {} --等待boss开花的表
    local my_flower_big = {{}, {}, {}, {}, {}} --大蝴蝶的花(五个固定位置
    local big_flower --大蝴蝶复活点(en
    local flower_pos  --获取花的位置
    local f1, f1_1, f2, f2_2, f2_1, f3, f4, f4_2, f4_1, f5
    local drot = {5, 10, 15, 20}
    local V = 0.6  --小怪弹速随时间狂暴
    self.fairys = {} --del妖精表
    do
        function f1(x, y, rot, u)
            local b1 = New(s6_boss.branch, x, y, rot, 90, 20, 15)
            _connect(self, b1, 0, true)
            local branchs = {{10, 50, 10, 5}, {10, 40, 8, 5}, {15, 90, 6, 5}}
            local t
            task.New(b1, function()
                b1.layer = LAYER_ENEMY-2
                for i = 1, #branchs do
                    t = branchs[i][2] --根据长度来决定生长时间
                    s6_boss.branch.addMainBranch(b1, branchs[i][1]*u, branchs[i][2], branchs[i][3], branchs[i][4])
                    s6_boss.branch.grow(b1, 0.33*t, i - 1, i - 1 + 0.33, true)
                    f1_1(b1, i, 0.33, 30*u, 60 - 8*i, s6_boss.branch.getWide(b1, i, 0.33), 5-i, 0.5*u)
                    s6_boss.branch.grow(b1, 0.33*t, i - 1 + 0.33, i - 1 + 0.66, true)
                    f1_1(b1, i, 0.66, (-15 + 2*i)*u, 60 - 8*i, s6_boss.branch.getWide(b1, i, 0.66), 5-i, 0.5*u)
                    s6_boss.branch.grow(b1, 0.34*t, i - 1 + 0.66, i, true)
                end
            end)
        end
        --为某个branch的某节i生成一整条侧枝
        function f1_1(branch, i, rate, da, length, w0, count, u)
            local dlength = (20 - length)/count
            local dw = (5 - w0)/count
            local obj = s6_boss.branch.addOtherBranch(branch, i, rate, da, length, w0, w0 + dw)
            _connect(self, obj, 0, true)
            local t
            task.New(obj, function()
                obj.layer = LAYER_ENEMY-2
                --obj.tt = 0
                for i = 1, count do
                    length = length + dlength
                    t = length
                    w0 = w0 + dw
                    s6_boss.branch.addMainBranch(obj, drot[i]*u, length, w0, 2)
                    --obj.tt = obj.tt + t + (count - i - 1)--给obj长出fa的计时器
                    --s6_boss.branch.grow(obj, t, i - 1, i, true, f1_2)
                    s6_boss.branch.grow(obj, t, i - 1, i, true)
                end

            end)
            local len = length
            task.New(obj, function()
                local t = 0
                for i = 1, count do
                    len = len + dlength
                    t = t + len
                end
                task.Wait(t - 10)
                --local x, y = s6_boss.branch.getHeadPos(obj)
                --f2(x, y, 0, 120)
            end)
        end
        --藏小妖精的樱花弹
        function f2(x, y, a, t)
            local obj = stg.newBulletStraight(stg.star_small, 3, true, x, y, 0, a)
            _connect(self, obj, 0, true)
            obj.group = GROUP_INDES
            obj.hscale, obj.vscale = 1.5, 1.5
            obj.a, obj.b = 4, 4
            obj._a = 255
            obj.fairy = nil --自己的妖精对象
            obj.spawn = false  --spawn由外面操纵
            do--创建绑定的花瓣对象
                for _ = 1, 5 do
                    f2_1(obj, 12*cos(a), 12*sin(a), a, 0)
                    a = a + 72
                end
            end
            task.New(obj, function ()
                while not obj.spawn do
                    task.Wait(1)
                end
                PlaySound("kira00")
                obj.group = GROUP_ENEMY_BULLET
                Del(obj)
                --egg.AddSimStrChV(obj, 0, 1, Angle(obj, player), 30)
                --egg.AddSimStrChO(obj, 0, 2, 60)
            end)
            table.insert(my_flower, {obj, t, 30})
        end
        function f2_2(x, y, a, t)
            local obj = stg.newBulletStraight(stg.star_small, 3, true, x, y, 0, a)
            _connect(self, obj, 0, true)
            obj.group = GROUP_INDES
            obj.hscale, obj.vscale = 1.5, 1.5
            obj.a, obj.b = 4, 4
            obj._a = 255
            obj.fairy = nil --自己的妖精对象
            obj.spawn = false  --spawn由外面操纵
            do--创建绑定的花瓣对象
                for _ = 1, 5 do
                    f2_1(obj, 12*cos(a), 12*sin(a), a, 0)
                    a = a + 72
                end
            end
            task.New(obj, function ()
                while not obj.spawn do
                    task.Wait(1)
                end
                obj.group = GROUP_ENEMY_BULLET
                Del(obj)
                --egg.AddSimStrChV(obj, 0, 1.5, Angle(obj, player), 30)
                --egg.AddSimStrChO(obj, 0, 2, 60)
            end)
            table.insert(my_flower, {obj, t, 40})
        end
        --spawn_flower_small1 = f2   --直接击破生成这个
        --spawn_flower_small2 = f2_2  --染色击破生成这个
        function f2_1(mst, x, y, a, da)
            local obj = stg.newBulletStraight(stg.arrow_big, 4, true, mst.x, mst.y, 0, a)
            _connect(self, obj, 0, true)
            obj.group = GROUP_INDES
            obj.bound = false
            obj.layer = LAYER_ENEMY_BULLET-1
            obj.hscale, obj.vscale = 1, 1
            obj._a = 255
            task.New(obj, function ()
                local rate, drate = 0, 1/30
                for _ = 1, 30 do
                    if IsValid(mst) and not mst.spawn then
                        rate = rate + drate
                        obj.x, obj.y = mst.x + rate*x, mst.y + rate*y
                        task.Wait(1)
                    else
                        break
                    end
                end
                while IsValid(mst) and not mst.spawn do
                    task.Wait(1)
                end
                obj.group = GROUP_ENEMY_BULLET
                obj.omiga = 0
                obj.bound = true
                obj.navi = true
                --散开之后变化
                egg.AddSimStrChV(obj, 0, 0.5, obj.rot, 30)
                task.Wait(30)
                egg.AddSimStrChV(obj, 0, 0.5, obj.rot + da, 90)
            end)
        end
        --生成小妖精
        function f3(x, y, t)
            t = t or 0
            local obj = New(small_fairy, x, y, 100)
            table.insert(self.fairys, obj)
            _object.set_color(obj, "", 0, 255, 255, 255)
            egg.SimSizeCh(obj, 0, 1, 30)
            egg.SimAlpCh(obj, 0, 255, 30, true)
            --en难度下小妖精不会移动
            --小妖精随时间强化的攻击
            task.New(obj, function()
                task.Wait(240 + t)
                local frame, a = 360
                for _ = 1, 5 do
                    if Dist(obj, player) > 30 then
                        a = Angle(obj, player) + ran:Float(-1, 1)
                        stg.newBulletStraight(stg.ball_mid_c, 3, true, obj.x, obj.y, V, a)
                        stg.newBulletStraight(stg.ball_mid_c, 3, true, obj.x, obj.y, V, a + 180)
                    end
                    PlaySound("tan00")
                    task.Wait(frame)
                    frame = frame - 20
                end
                while true do
                    if Dist(obj, player) > 30 then
                        a = Angle(obj, player) + ran:Float(-1, 1)
                        stg.newBulletStraight(stg.ball_mid_c, 3, true, obj.x, obj.y, V, a)
                        stg.newBulletStraight(stg.ball_mid_c, 3, true, obj.x, obj.y, V, a + 180)
                    end
                    PlaySound("tan00")
                    task.Wait(frame)
                end
            end)
            --死亡
            obj.normalKill = function()
                f2(obj.x, obj.y, Angle(obj, player), 30)
            end
            --染死
            obj._dyeKill = function()
                f2_2(obj.x, obj.y, Angle(obj, player), 60)
            end
            return obj
        end
        --大花~!
        function f4(i)
            local obj = stg.newBulletStraight(stg.ball_light, 3, true, big_flower[i][1], big_flower[i][2], 0, 0, true)
            _connect(self, obj, 0, true)
            _object.set_color(obj, "", 255, 255, 255, 255)
            obj.colli = false
            obj.timer = 11
            obj.hscale, obj.vscale = 0, 0
            obj.spawn = false
            task.New(obj, function()
                local rate
                for x = 1, 60 do
                    rate = sin(x)
                    obj.hscale, obj.vscale = rate, rate
                    task.Wait(1)
                end
                obj.colli = true
            end)
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET-1
                for i = 3, 1, -1 do
                    for j = 1, 8 do
                        f4_1(obj, 0.4 + 0.1*i, 10 + 4*i, 90 + 45*j + 22.5*i)
                    end
                end
                while not obj.spawn do
                    task.Wait(1)
                end
                _object.set_color(obj, "mul+add", 255, 255, 255, 255)
                PlaySound("kira00")
                obj.group = GROUP_ENEMY_BULLET
                --egg.AddSimStrChV(obj, 0, 0.8, Angle(obj, player), 30)
                Del(obj)
            end)
            table.remove(my_flower_big, i)
            table.insert(my_flower_big, i, {obj, 180, 30})
            --my_flower_big[i] = {obj, 120} --替换表
        end
        --spawn_flower_big1 = f4
        --大花花瓣
        function f4_1(mst, s, r, a)
            local obj = stg.newBulletStraight(stg.ball_mid, 3, true, mst.x, mst.y, 0, 0, true)
            _connect(self, obj, 0, true)
            _object.set_color(obj, "", 0, 255, 255, 255)
            obj.img = "Lily_Cherry_bullet"
            obj.hscale, obj.vscale = s, s
            obj.size = 0
            obj.a, obj.b = 2*s, 2*s
            obj.rot = a
            task.New(obj, function()
                local x = 0
                while true do
                    obj.hscale, obj.vscale = obj.size*s, obj.size*s
                    x = x + 1
                    task.Wait(1)
                end
            end)
            --最开始变大
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET
                local dx, dy, ds = cos(a), sin(a), 1/30
                for _ = 1, 30 do
                    if IsValid(mst) then
                        obj.size = obj.size + ds
                        obj.x, obj.y = mst.x + obj.size*r*dx, mst.y + obj.size*r*dy
                        obj._a = 255*obj.size
                    end
                    task.Wait(1)
                end
                while IsValid(mst) and not mst.spawn do
                    task.Wait(1)
                end
                obj.group = GROUP_ENEMY_BULLET
                --egg.AddSimStrChV(obj, 0, 0.9 + 0.1*s, obj.rot, 30)
                Del(obj)
            end)
        end
        --生成大蝴蝶
        function f5(x, y, i)
            local obj = New(big_fairy, x, y, 32, i)
            table.insert(self.fairys, obj)
            _object.set_color(obj, "", 0, 255, 255, 255)
            egg.SimSizeCh(obj, 0, 1, 30)
            egg.SimAlpCh(obj, 0, 255, 30, true)
            --en难度下大蝴蝶向下移动
            --egg.AddSimStrChV(obj, 0, 0.75, -90, 120)
            egg.AddAccDecChV(obj, 1, -90, 40, 40, 40)
            --染色圈变大
            task.New(obj, function()
                for x = 1, 100 do
                    obj.dye_range = 60*sin(x)
                    task.Wait(1)
                end
            end)
            --死亡
            obj.normalKill = function()
                f4(obj.pos)
            end
            return obj
        end
    end

    do
        s6_boss.pic_show()
        task.Wait(90)
        flower_pos = s6_boss.back_light.getFlowersPos(self.back_light) --获取花的位置
        --大妖精复活点
        big_flower = {{flower_pos[1][1], 160}, {flower_pos[2][1], 120}, {flower_pos[3][1], 80}, {flower_pos[4][1], 120}, {flower_pos[5][1], 160}}
        pinkeff(self.x, self.y, 30)
        do
            f1(self.x, self.y - 30, 25, 1)
            f1(self.x, self.y - 30, 65, 1)
            f1(self.x, self.y - 30, 115, -1)
            f1(self.x, self.y - 30, 155, -1)
            task.Wait(120)
            --en改成上面生成大妖精，下面生成小妖精
            for i = 1, 5 do
                f4(i)
                for j = 1, 8 do
                    f2(flower_pos[i][1] + 30*cos(45*j), flower_pos[i][2] + 30*sin(45*j), 45*j+180, 120)
                end
            end
            pinkeff(self.x, self.y, 60)
            pinkbkeff(self.x, self.y)
            --重置，同时使所有花的开花时间为0
            for i = 1, #my_flower do
                my_flower[i][2] = 0
            end
            for i = 1, 5 do
                my_flower_big[i][2] = 0
            end
        end
        --每帧检查表复活妖精
        task.New(self, function()
            local i, n, obj
            do
                i = 1
                n = #my_flower
                while i <= n do
                    obj = my_flower[i][1]
                    if IsValid(obj) then
                        if my_flower[i][2] <= 0 then
                            self.hp = self.hp - 8
                            New(dye_fly_to_enemy, self.x, self.y, f3(obj.x, obj.y, 90 + 15*ran:Int(1, 14)))--生成小妖精和染色特效
                            obj.spawn = true
                            table.remove(my_flower, i)
                            n = n - 1
                        else
                            my_flower[i][2] = my_flower[i][2] - 1
                            i = i + 1
                        end
                    else
                        table.remove(my_flower, i)
                        n = n - 1
                    end
                end
                for i = 1, 5 do
                    obj = my_flower_big[i][1]
                    if IsValid(obj) then
                        if my_flower_big[i][2] <= 0 then
                            self.hp = self.hp - 8
                            local enemy = f5(big_flower[i][1], big_flower[i][2], i)
                            table.remove(my_flower_big, i)
                            table.insert(my_flower_big, i, {enemy, 999999, 0})
                            New(dye_fly_to_enemy, self.x, self.y, enemy)--生成大蝴蝶和染色特效
                            obj.spawn = true
                        else
                            my_flower_big[i][2] = my_flower_big[i][2] - 1
                        end
                    end
                end
                task.Wait(1)
            end
            while true do
                i = 1
                n = #my_flower
                while i <= n do
                    obj = my_flower[i][1]
                    if IsValid(obj) then
                        if my_flower[i][2] <= 0 then
                            self.hp = self.hp - 8 --3号位是伤害值
                            New(dye_fly_to_enemy, self.x, self.y, f3(obj.x, obj.y))--生成小妖精和染色特效
                            obj.spawn = true
                            table.remove(my_flower, i)
                            n = n - 1
                        else
                            my_flower[i][2] = my_flower[i][2] - 1
                            i = i + 1
                        end
                    else
                        table.remove(my_flower, i)
                        n = n - 1
                    end
                end
                for i = 1, 5 do
                    obj = my_flower_big[i][1]
                    if IsValid(obj) then
                        if my_flower_big[i][2] <= 0 then
                            self.hp = self.hp - 8
                            local enemy = f5(big_flower[i][1], big_flower[i][2], i)
                            table.remove(my_flower_big, i)
                            table.insert(my_flower_big, i, {enemy, 999999, 0})
                            New(dye_fly_to_enemy, self.x, self.y, enemy)--生成大蝴蝶和染色特效
                            obj.spawn = true
                        else
                            my_flower_big[i][2] = my_flower_big[i][2] - 1
                        end
                    end
                end
                task.Wait(1)
            end
        end)
        task.New(self, function()
            task.Wait(360)
            local frame, way, da = 300, 9
            while true do
                da = 360/way
                for j = 0, 0 do
                    for i = 1, way do
                        stg.newBulletStraight(stg.arrow_big, 10, false, self.x, self.y, 0.75 + 0.25*j, da*i)
                    end
                end
                PlaySound("kira00")
                task.Wait(frame)
                frame = max(frame - 30, 180)
                way = min(way + 3, 21)
            end
        end)
    end
end
table.insert(scs, {boss_sc3, boss_sc3_normal_show, boss_sc3_scpr_show})
--四符
local function boss_sc4_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 120, 60, MOVE_NORMAL)
end
local function boss_sc4_scpr_show(self)
    boss_scpr_show(self, 0, 120)
    s6_boss.back_light.appear(self.back_light)
    task.Wait(30)
end
local function boss_sc4(self)
    local f1, f1_1, f2, f2_1, f3
    local flower_pos
    do
        --大*激光
        function f1(x, y, a)
            local obj = stg.newBulletStraight(stg.ball_light, 1, true, x, y, 0, a, true)
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            obj.hscale, obj.vscale = 0, 0.5
            obj.undestoryable = true --真正不可消除
            obj.a, obj.b = 0, 0.35*obj.b
            obj.bound = false
            obj.hide = true
            obj.colli = false
            task.New(obj, function()
                laser_eff(x, y, a, 255, 0, 0)
                task.Wait(30)
                PlaySound("lazer01")
                SetV(obj, 15, a)
                obj.hide = false
                obj.colli = true
                task.New(obj, function()
                    local dh = 0.75
                    for _ = 1, 20 do
                        obj.hscale = obj.hscale + dh
                        obj.a = obj.a + 12*dh
                        task.Wait(1)
                    end
                    task.Wait(120)
                    obj.bound = true
                end)
                task.New(obj, function()
                    for i = 1, 2 do
                        if Dist(obj, player) > 50 then
                            for u = -1, 1, 2 do
                                f1_1(obj.x, obj.y, a + ran:Float(-1, 1), (60 - 4*i)*u, 14)
                            end
                            f1_1(obj.x, obj.y, a + 180 + ran:Float(-1, 1), 0, 2)
                        end
                        task.Wait(8)
                    end
                end)
            end)
        end
        function f1_1(x, y, a, da, co)
            local obj = stg.newBulletStraight(stg.water_drop, co, true, x, y, 0, a, true)
            obj.colli = false
            obj.hscale, obj.vscale = 0, 0
            --大小，透明度
            task.New(obj, function()
                egg.SimSizeCh(obj, 1.25, 1, 30, true)
                egg.SimAlpCh(obj, 0, 255, 30)
                task.Wait(30)
                obj.colli = true
            end)
            --变速
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET+1
                local v, dv, da = 0, 1/120, da/120
                for _ = 1, 120 do
                    obj.rot = obj.rot + da
                    v = v + dv
                    SetV(obj, v, obj.rot)
                    task.Wait(1)
                end
                --egg.AddSimStrChV(obj, 0, 1.25, obj.rot, 90 + t)
            end)
        end
        function f2(x, y, a)
            for i = 0, 2 do
                for j = 0, 16 do
                    f2_1(x, y, 0.3*i, a + 22.5*j + 7*i)
                end
            end
        end
        function f2_1(x, y, dv, a)
            local obj = stg.newBulletStraight(stg.water_drop, 1, true, x, y, 0, a)
            obj.img = "Lily_Cherry_bullet"
            obj.hscale, obj.vscale = 0.75, 0.75
            obj.a, obj.b = 3, 3
            obj.navi = true
            egg.AddSimStrChV(obj, 2, 0.6 + dv, a, 60)
        end
        --炎弹攻击总和
        function f3()
            PlaySound("kira00")
            f2(self.x, self.y, 0)
        end
    end

    do
        s6_boss.pic_show()
        task.Wait(90)
        flower_pos = s6_boss.back_light.getFlowersPos(self.back_light) --获取花的位置
        --s6_boss.back_light.appear(self.back_light) --测试用亮光背
        pinkeff(self.x, self.y, 60)
        --每帧获取光背的位置
        task.New(self, function()
            while true do
                flower_pos = s6_boss.back_light.getFlowersPos(self.back_light)
                task.Wait(1)
            end
        end)
        local u, a = 1
        while true do
            for k = 1, 10 do
                f1(flower_pos[1][1], flower_pos[1][2], 180 + 18*k)
                f1(flower_pos[5][1], flower_pos[5][2], 0 - 18*k)
                task.Wait(9)
            end
            task.Wait(45)
            f3()
            task.Wait(45)
            for k = 1, 10 do
                f1(flower_pos[2][1], flower_pos[2][2], 0 - 18*k)
                f1(flower_pos[4][1], flower_pos[4][2], 180 + 18*k)
                task.Wait(9)
            end
            task.Wait(90)
            f3()
            task.Wait(90)
            task.New(self, function()
                for k = 1, 20 do
                    f1(flower_pos[2][1], flower_pos[2][2], 90 - 90*u + 18*k*u)
                    f1(flower_pos[5][1], flower_pos[5][2], 90 + 90*u + 18*k*u)
                    task.Wait(9)
                end
            end)
            task.MoveTo(100*u, 144, 180, MOVE_ACC_DEC)
            f3()
            task.Wait(90)
            task.New(self, function()
                local u = u
                for i = 1, 3 do
                    if i ~= 3 then
                        for k = -3, 2 do
                            a = Angle(flower_pos[i][1], flower_pos[i][2], player.x, player.y)
                            f1(flower_pos[i][1], flower_pos[i][2], a + 30*k*u)
                            task.Wait(9)
                        end
                        u = -u
                    end
                end
                --中间的发激光
                for _ = 1, 1 do
                    for k = -3, 2 do
                        a = Angle(flower_pos[3][1], flower_pos[3][2], player.x, player.y)
                        f1(flower_pos[3][1], flower_pos[3][2], a + 30*k*u)
                        task.Wait(9)
                    end
                    u = -u
                end
            end)
            task.MoveTo(0, 100, 180, MOVE_ACC_DEC)
            f3()
            task.Wait(200)
            u = -u
        end
    end
end
table.insert(scs, {boss_sc4, boss_sc4_normal_show, boss_sc4_scpr_show})
--[[五符
local function boss_sc5_normal_show(self)
    s6_boss.back_light.disAppear(self.back_light) --关掉光背
    task.Wait(30)
    task.MoveTo(0, 100, 60, MOVE_NORMAL)
end
local function boss_sc5_scpr_show(self)
    boss_scpr_show(self, 0, 100)
end
local function boss_sc5(self)
    local f1, f1_1, f1_2, f2, f2_1, f2_2, f3
    do
        --仅仅左右运动的使魔
        function f1()
            local obj = stg.newBulletStraight(stg.ball_mid_c, 1, true, 0, 100, 0, 0, true)
            obj.hide = true
            obj.bound = false
            task.New(obj, function()
                local a, da = 22.5, 0
                --封位
                for _ = 1, 15 do
                    for i = 1, 8 do
                        f1_1(obj.x, obj.y, 45*i + a)
                        f1_2(obj.x, obj.y, 45*i + a)
                    end
                    PlaySound("tan00")
                    task.Wait(4)
                end
                --开始摆动
                for _ = 1, 20 do
                    for i = 1, 8 do
                        f1_1(obj.x, obj.y, 45*i + a)
                        f1_2(obj.x, obj.y, 45*i + a)
                    end
                    PlaySound("tan00")
                    task.Wait(4)
                    da = da + 0.15
                    a = a + da
                end
                --循环摇摆
                da = -da
                while true do
                    for _ = 1, 20 do
                        for i = 1, 8 do
                            f1_1(obj.x, obj.y, 45*i + a)
                            f1_2(obj.x, obj.y, 45*i + a)
                        end
                        PlaySound("tan00")
                        task.Wait(4)
                        a = a + da
                    end
                    da = -da
                end
            end)
        end
        function f1_1(x, y, a)
            local obj = stg.newBulletStraight(stg.water_drop, 5, true, x, y, 0, a, true)
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            egg.AddSimStrChV(obj, 0, 5, a, 20)
            --obj.navi = true
        end
        function f1_2(x, y, a)
            local obj = stg.newBulletStraight(stg.water_drop, 3, true, x, y, 0, a, true)
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            egg.AddSimStrChV(obj, 0, 7, a, 20)
            --obj.navi = true
        end
        function f2(x, y, a)
            local obj = stg.newBulletStraight(stg.ball_light, 12, false, x, y, 4, a, true)
            obj.group = GROUP_GHOST
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            obj.bound = false
            task.New(obj, function()
                task.Wait(120)
                obj.bound = true
            end)
            task.New(obj, function()
                for _ = 1, 5 do
                    f2_1(obj.x, obj.y)
                    task.Wait(15)
                end
            end)
        end
        function f2_1(x, y)
            local obj = stg.newBulletStraight(stg.ball_light, 14, false, x, y, 0, 0)
            obj.group = GROUP_GHOST
            obj.bound = false
            obj.timer = 11
            _object.set_color(obj, "mul+add", 0, 255, 255, 255)
            egg.SimAlpCh(obj, 0, 90, 45)
            egg.SimSizeCh(obj, 0, 6, 45)
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET+1
                task.Wait(120)
                egg.SimAlpCh(obj, 90, 0, 60)
                task.Wait(60)
                Del(obj)
            end)
        end
        function f2_2(x, y)
            local obj = stg.newBulletStraight(stg.ball_light, 14, false, x, y, 0, 0)
            _connect(self, obj, 0, true)
            obj.group = GROUP_GHOST
            obj.bound = false
            obj.timer = 11
            _object.set_color(obj, "mul+add", 0, 255, 255, 255)
            egg.SimAlpCh(obj, 0, 90, 45)
            egg.SimSizeCh(obj, 0, 4, 45)
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET+2
            end)
        end
    end

    do
        self.x, self.y = 0, 100
        s6_boss.pic_show()
        task.Wait(90)
        --这才是主体攻击
        task.New(self, function ()
            local frame, a = 30
            task.Wait(180)
            f1()
            task.Wait(120)
            --偶数弹出现
            while true do
                a = Angle(self, player) + 36
                for i = 1, 5 do
                    stg.newBulletStraight(stg.water_drop, 14, false, self.x, self.y, 4, a + 72*i, true)
                end
                PlaySound("kira00")
                task.Wait(frame)
                frame = max(5, frame - 5)
            end
        end)
        --符卡开启10s后若玩家miss则减少大量符卡持续时间
        task.New(self, function ()
            task.Wait(600)
            while true do
                if player.death > 0 and player.death < 90 then
                    self.timer = self.timer + 10
                end  --自机miss则减少符卡持续时间
                task.Wait(1)
            end
        end)
        do
            local a
            for i = 1, 8 do
                a = 45*i
                f2(400*cos(a), -50 + 400*sin(a), a + 170)
                f2(400*cos(a), -50 + 400*sin(a), a + 190)
            end
            PlaySound("kira00")
            task.Wait(120)
            --偷偷在四周都布满光玉
            do
                local x, dx, y, dy = -245, 490/11, -270, 540/13
                for _ = 1, 12 do
                    f2_2(x, 260)
                    f2_2(x, -260)
                    x = x + dx
                end
                for _ = 1, 14 do
                    f2_2(-240, y)
                    f2_2(240, y)
                    y = y + dy
                end
            end
            task.Wait(180)
            task.Wait(360)
            pinkeff(self.x, self.y, 60)
            local dx, dy
            --眩晕强化
            task.New(self, function()
                local r, a = 0, 0
                for _ = 1, 600 do
                    r = r + 0.125
                    a = a + 1
                    dx, dy = r*(cos(a) - cos(a-1)), r*(sin(a) - sin(a-1))
                    task.Wait(1)
                end
                local da = 1
                for _ = 1, 1200 do
                    r = r + 0.125
                    da = da + 0.00075
                    a = a + da
                    dx, dy = r*(cos(a) - cos(a-1)), r*(sin(a) - sin(a-1))
                    task.Wait(1)
                end
                while true do
                    a = a + 1
                    dx, dy = r*(cos(a) - cos(a-1)), r*(sin(a) - sin(a-1))
                    task.Wait(1)
                end
            end)
            --更新boss，自机，子弹的位置
            task.New(self, function()
                while true do
                    for _, o in ObjList(GROUP_ENEMY_BULLET) do
                        o.x, o.y = o.x + dx, o.y + dy
                    end
                    for _, o in ObjList(GROUP_INDES) do
                        o.x, o.y = o.x + dx, o.y + dy
                    end
                    self.x, self.y = self.x + dx, self.y + dy
                    player.x, player.y = player.x + dx, player.y + dy
                    task.Wait(1)
                end
            end)
        end
    end
end
table.insert(scs, {boss_sc5, boss_sc5_normal_show, boss_sc5_scpr_show})]]
--终符
local function boss_sc5_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 169, 60, MOVE_NORMAL)
    for _ = 1, 3 do
        pinkeff(self.x, self.y, 20)
    end
    s6_boss.back_light.appear(self.back_light) --测试用亮光背
    task.Wait(90)
end
local function boss_sc5_scpr_show(self)
    boss_scpr_show(self, 0, 169)
    s6_boss.back_light.appear(self.back_light) --测试用亮光背
    task.Wait(90)
end
local function boss_sc5(self)
    local flower_pos
    local f1, f1_1, f2, f3
    do
        function f1(x, y, a, co, da1, dt, dv)
            local obj = stg.newBulletStraight(stg.square, co, false, x, y, 0, a, true)
            obj.bound = false
            obj.navi = true
            _object.set_color(obj, "", 255, 255, 255, 255)
            egg.AddAccDecChV(obj, 2, a, 75, 0, 75)
            task.New(obj, function()
                task.Wait(360) --t是绕一圈的时间
                egg.SimAlpCh(obj, 255, 0, 60) --消失
                task.Wait(60)
                egg.AddSimStrChV(obj, 0, 1.25, a + 165, 30)
                task.Wait(60)
                if co == 1 then co = 5
                else
                    co = 1
                end
                stg.setBulletStyle(obj, stg.square, co)
                egg.SimAlpCh(obj, 0, 255, 30) --重现
                task.Wait(120)
                egg.SimAlpCh(obj, 255, 0, 30) --消失
                task.Wait(40 + dt)
                egg.AddSimStrChV(obj, 0, dv, a + 165 + da1, 60)
                if co == 1 then
                    co = 4
                else
                    co = 8
                end
                stg.setBulletStyle(obj, stg.square, co)
                egg.SimAlpCh(obj, 0, 255, 20) --重现
                PlaySound("kira00")
                local a0 = ran:Float(-1, 1)
                for i = -3, 3, 2 do
                    f1_1(obj.x, obj.y, a - 15 + a0, co, 0, 0.9*(1 + dv), 30*i)
                end
                obj.bound = true
                task.Wait(1)
                obj.layer = LAYER_ENEMY_BULLET+4
            end)
        end
        function f1_1(x, y, a, co, t, dv, da)
            local obj = stg.newBulletStraight(stg.square, co, false, x, y, 0, a, true)
            obj.timer = 11
            _object.set_color(obj, "", 0, 255, 255, 255)
            egg.SimAlpCh(obj, 0, 255, 20) --重现
            obj.navi = true
            --obj.vx, obj.vy = vx, vy
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET+4
                task.Wait(t)
                egg.AddSimStrChV(obj, 0, dv, a + da, 60)
            end)
        end
        --开幕演出
        function f2(x, y, v, a)
            local obj = stg.newBulletStraight(stg.grain_a, 3, true, x, y, 0, a)
            egg.AddSimStrChV(obj, 0, v, a, 1)
        end
    end
    --boss对自机无敌减伤
    New(tasker, function()
        while IsValid(self) do
            self.dmgrate = min(self.dmgrate + 0.01, 1)
            if IsValid(player) and player.protect > 0 then
                self.dmgrate = 0.75
            end
            task.Wait(1)
        end
    end)
    do
        s6_boss.pic_show()
        task.Wait(90)
        flower_pos = s6_boss.back_light.getFlowersPos(self.back_light) --获取花的位置
        --s6_boss.back_light.appear(self.back_light) --测试用亮光背
        --开始转起来了
        local a, da, rate = 0, 8, 1.1
        task.New(self, function()
            task.Wait(240) --每15s变一次速
            rate = 1.2
            pinkeff(self.x, self.y)
            task.Wait(540)
            pinkeff(self.x, self.y)
            s6_boss.changeSpeed(1.1, true, true)
            task.Wait(240) --每15s变一次速
            rate = 1.3
            task.Wait(540)
            pinkeff(self.x, self.y)
            s6_boss.changeSpeed(1.2, true, true)
            task.Wait(240) --每15s变一次速
            rate = 1.4
            task.Wait(540)
            pinkeff(self.x, self.y)
            s6_boss.changeSpeed(1.3, true, true)
            task.Wait(240) --每15s变一次速
            rate = 1.5
            task.Wait(540)
            pinkeff(self.x, self.y)
            s6_boss.changeSpeed(1.4, true, true)
            task.Wait(240)
            rate = 1.6
            task.Wait(540)
            pinkeff(self.x, self.y)
            s6_boss.changeSpeed(1.5, true, true)
            task.Wait(240)
            rate = 1.7
            task.Wait(540)
            pinkeff(self.x, self.y)
            s6_boss.changeSpeed(1.6, true, true)
        end)
        --开幕演出
        task.New(self, function()
            task.Wait(90)
            pinkeff(flower_pos[2][1], flower_pos[2][2])
            pinkeff(flower_pos[4][1], flower_pos[4][2])
            task.Wait(50)
            pinkeff(flower_pos[1][1], flower_pos[1][2], 0)
            pinkeff(flower_pos[5][1], flower_pos[5][2], 30)
            misc.ShakeScreen(60, 5)
            local ang = {}
            for i = 1, 5 do
                if i ~= 3 then
                    ang[i] = Angle(flower_pos[i][1], flower_pos[i][2], player.x, player.y)
                end
            end
            --攻击
            for k = 1, 9 do
                for i = 1, 5 do
                    if i ~= 3 then
                        for j = 1, 6 do
                            for u = -1, 1, 2 do
                                f2(flower_pos[i][1], flower_pos[i][2], 0.75 + 0.09*k, ang[i] + (9 - 1*k)*u + 60*j)
                            end
                        end
                    end
                end
                PlaySound("kira00")
                task.Wait(10)
            end
            task.Wait(60)
            for i = 1, 5 do
                if i ~= 3 then
                    ang[i] = Angle(flower_pos[i][1], flower_pos[i][2], player.x, player.y)
                end
            end
            local u = 1
            for i = 1, 5 do
                if i ~= 3 then
                    if i < 3 then u = 1 else u = -1 end
                    for k = 0, 5 do
                        for j = 0, 5 do
                            stg.newBulletStraight(stg.ball_mid_c, 3, true, flower_pos[i][1], flower_pos[i][2], 1 + 0.15*k, ang[i] + 60*j + 1*k*u)
                        end
                    end
                end
            end
            PlaySound("kira00")
            task.Wait(30)
            PlaySound("kira00")
            for i = 1, 5 do
                if i ~= 3 then
                    ang[i] = Angle(flower_pos[i][1], flower_pos[i][2], player.x, player.y)
                end
            end
            for k = 0, 5 do
                for i = 1, 5 do
                    if i ~= 3 then
                        for j = 0, 7 do
                            _object.set_color(stg.newBulletStraight(stg.ball_light, 3, true, flower_pos[i][1], flower_pos[i][2], 1 + 0.175*k, ang[i] + 45*j), "mul+add", 255, 255, 255, 255)
                        end
                    end
                end
                PlaySound("kira00")
                task.Wait(7)
            end
        end)
        pinkeff(flower_pos[3][1], flower_pos[3][2], 60)
        while true do
            for i = 0, 1 do
                for u = -1, 1, 2 do
                    f1(flower_pos[3][1], flower_pos[3][2], a + 90*u, 3 + 2*u, -7.5*(i-2), -5*i, 1.25*rate)
                end
                PlaySound("tan00")
                task.Wait(8)
                a = a + da
            end
        end
    end
end
table.insert(scs, {boss_sc5, boss_sc5_normal_show, boss_sc5_scpr_show})

-- 创建一个 boss 类
local function create_boss_class(class_name, group_name)
    local cls = Class(boss)
    _editor_class[class_name] = cls
    cls.cards = {}
    cls._name = class_name
    cls.name = "Oukain"
    cls.bgm = "s6_boss"
    cls._bg = function() return stage6_background end
    cls.difficulty = group_name
    function cls:init(cards)
        boss.init(self, 0, 384, "Oukain", cards, New(s6_boss.scbg), group_name)
        lstg.wis.Oukain(self)
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
            self._wisys:setAction("normal")
            s6_boss.recoverSpeed()
        end
    elseif mode == "spellcard" then
        function _sc:init()
            task.New(self,function()
                scs[index][1](self)
            end)
        end
        function _sc:del()
            self._wisys:setAction("normal")
            s6_boss.recoverSpeed()
            scbkeff(self.x, self.y)
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
            self._wisys:setAction("normal")
            s6_boss.recoverSpeed()
        end
    elseif mode == "spellcard" then
        function _sc:init()
            task.New(self,function()
                scs[index][1](self)
            end)
        end
        function _sc:del()
            self._wisys:setAction("normal")
            s6_boss.recoverSpeed()
            --scbkeff(self.x, self.y)
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
local stage6boss
do
    stage6boss = create_boss_class("stage6boss:Easy", "Easy")
    local card_info = {
        {"常规攻击1", {2, 6, 40}, 900, {0,0,0}, "normal", false},
        {"时魔法「梦见花开」",{30, 30, 30}, 1000, {10, 20, 30}, "spellcard", false},
        {"常规攻击2", {2, 6, 40}, 1200, {0,0,0}, "normal", false},
        {"水魔法「雾气弥漫的喜雨泉」",{2, 8, 60}, 2500, {10, 20, 30}, "spellcard", false},
        {"常规攻击3", {2, 10, 40}, 1800, {0,0,0}, "normal", false},
        {"生符「浴火的诞生」",{5, 5, 40}, 2500, {10, 20, 30}, "spellcard", false},
        {"常规攻击4", {2, 4, 40}, 2000, {0,0,0}, "normal", false},
        {"炎咲「富士山流火」",{3, 5, 60}, 2500, {10, 20, 30}, "spellcard", false},
        {"「双树花与黄粱梦」",{5, 20, 120}, 5000, {0,0,0}, "spellcard", false}
    }
    stage6boss.cards={}
    local i, info = 1
    --如果要插入新的card，请务必在local n之上插入，否则会影响后面二符的del函数
    local n = #stage6boss.cards
    --六boss非和符插入
    --前四个非和符
    for i = 1, 4 do
        info = card_info[2*i-1]
        table.insert(stage6boss.cards, create_normal_show_class(i, info[5]))
        table.insert(stage6boss.cards, create_card_class(i, info[1], info[2], info[3], info[4], info[5], info[6]))
        info = card_info[2*i]
        table.insert(stage6boss.cards, create_normal_show_class(i, info[5]))
        table.insert(stage6boss.cards, create_card_class(i, info[1], info[2], info[3], info[4], info[5], info[6]))
    end
    --终符
    do
        info = card_info[9]
        table.insert(stage6boss.cards, create_normal_show_class(5, info[5]))
        table.insert(stage6boss.cards, create_card_class(5, info[1], info[2], info[3], info[4], info[5], info[6]))
    end
    local _sc = stage6boss.cards[n+4] --定位到一符，不需要爆炸效果
    function _sc:del()
        self._wisys:setAction("normal")
    end
    _sc = stage6boss.cards[n+12] --定位到三符，需要击杀所有妖精
    function _sc:del()
        self._wisys:setAction("normal")
        s6_boss.recoverSpeed()
        scbkeff(self.x, self.y)
        for _, o in ipairs(self.fairys) do
            Del(o)
        end
        self.fairys = nil
    end
    _sc = stage6boss.cards[n+16] --定位到四符，击破后光闭光背
    function _sc:del()
        s6_boss.back_light.disAppear(self.back_light) --关掉光背
        self._wisys:setAction("normal")
        s6_boss.recoverSpeed()
        scbkeff(self.x, self.y)
    end
    _sc = stage6boss.cards[n+18]  --定位到终符，不需要爆炸效果，爆炸效果额外弄
    function _sc:del()
        s6_boss.recoverSpeed()
        self._wisys:setAction("normal")
    end
    --最后boss的爆炸演出
    do
        local _tmp_sc = boss.dialog.New(true)
        function _tmp_sc:init()
            player.dialog=false
            self.dialog_displayer=New(dialog_displayer)
            self._dialog_maintask=task.New(self,function()
                s6_boss.back_light.disAppear(self.back_light) --关掉光背
                lstg.var.timeslow = 2
                move_rd(60, self.y, 20)
                PlaySound("enep00")
                misc.ShakeScreen(60, 5)
                New(boss_death_circle, self.x, self.y)
                for _ = 1, 3 do
                    bkeff(self.x, self.y)
                    task.Wait(10)
                end
                lstg.var.timeslow = nil
                item.DropItem(self.x, self.y, {0, 0, 100})
                Del(self)
            end)
        end
        table.insert(stage6boss.cards,_tmp_sc)
    end
    --防止boss直接自爆的工具非
    do
        local _tmp_sc = boss.card.New("", 2, 4, 40, 900, {0,0,0}, false)
        function _tmp_sc:init()
        end
        function _tmp_sc:del()
        end
        _tmp_sc.perform=false
        table.insert(stage6boss.cards,_tmp_sc)
    end
end
_editor_class["stage6boss:Easy"] = stage6boss

--符卡练习boss定义
local stage6bossScpr
do
    stage6bossScpr = create_boss_class("stage6bossScpr:Easy", "Easy")
    local card_info = {
        {"常规攻击1", {2, 6, 40}, 900, {0,0,0}, "normal", false},
        {"时魔法「梦见花开」",{30, 30, 30}, 1000, {10, 20, 30}, "spellcard", false},
        {"常规攻击2", {2, 6, 40}, 1200, {0,0,0}, "normal", false},
        {"水魔法「雾气弥漫的喜雨泉」",{2, 8, 60}, 2500, {10, 20, 30}, "spellcard", false},
        {"常规攻击3", {2, 10, 40}, 1800, {0,0,0}, "normal", false},
        {"生符「浴火的诞生」",{5, 5, 40}, 2500, {10, 20, 30}, "spellcard", false},
        {"常规攻击4", {2, 4, 40}, 2000, {0,0,0}, "normal", false},
        {"炎咲「富士山流火」",{3, 5, 60}, 2500, {10, 20, 30}, "spellcard", false},
        {"「双树花与黄粱梦」",{5, 20, 120}, 5000, {0,0,0}, "spellcard", false}
    }
    stage6bossScpr.cards={}
    local i, info = 1
    --如果要插入新的card，请务必在local n之上插入，否则会影响后面二符的del函数
    local n = #stage6bossScpr.cards
    --六boss非和符插入
    --前四个非和符
    for i = 1, 4 do
        info = card_info[2*i-1]
        table.insert(stage6bossScpr.cards, create_scpr_show_class(i, info[5]))
        table.insert(stage6bossScpr.cards, create_cardpr_class(i, info[1], info[2], info[3], info[4], info[5], stage6bossScpr))
        info = card_info[2*i]
        table.insert(stage6bossScpr.cards, create_scpr_show_class(i, info[5]))
        table.insert(stage6bossScpr.cards, create_cardpr_class(i, info[1], info[2], info[3], info[4], info[5], stage6bossScpr))
    end
    --终符
    do
        info = card_info[9]
        table.insert(stage6bossScpr.cards, create_scpr_show_class(5, info[5]))
        table.insert(stage6bossScpr.cards, create_cardpr_class(5, info[1], info[2], info[3], info[4], info[5], stage6bossScpr))
    end
    local _sc = stage6bossScpr.cards[n+4] --定位到一符，不需要爆炸效果
    function _sc:del()
        self._wisys:setAction("normal")
    end
    _sc = stage6bossScpr.cards[n+12] --定位到三符，需要击杀所有妖精
    function _sc:del()
        self._wisys:setAction("normal")
        s6_boss.recoverSpeed()
        scbkeff(self.x, self.y)
        for _, o in ipairs(self.fairys) do
            Del(o)
        end
        self.fairys = nil
    end
    _sc = stage6bossScpr.cards[n+16] --定位到四符，击破后光闭光背
    function _sc:del()
        s6_boss.back_light.disAppear(self.back_light) --关掉光背
        self._wisys:setAction("normal")
        s6_boss.recoverSpeed()
        scbkeff(self.x, self.y)
    end
    _sc = stage6bossScpr.cards[n+18]  --定位到终符，不需要爆炸效果，爆炸效果额外弄
    function _sc:del()
        s6_boss.recoverSpeed()
        self._wisys:setAction("normal")
    end
    --最后boss的爆炸演出
    do
        local _tmp_sc = boss.dialog.New(true)
        function _tmp_sc:init()
            player.dialog=false
            self.dialog_displayer=New(dialog_displayer)
            self._dialog_maintask=task.New(self,function()
                s6_boss.back_light.disAppear(self.back_light) --光背关闭
                lstg.var.timeslow = 2
                move_rd(60, self.y, 20)
                PlaySound("enep00")
                misc.ShakeScreen(60, 5)
                for _ = 1, 3 do
                    bkeff(self.x, self.y)
                    task.Wait(10)
                end
                lstg.var.timeslow = nil
                item.DropItem(self.x, self.y, {0, 0, 100})
                Del(self)
            end)
        end
        table.insert(stage6bossScpr.cards,_tmp_sc)
    end
    --防止boss直接自爆的工具非
    do
        local _tmp_sc = boss.card.New("", 2, 4, 40, 900, {0,0,0}, false)
        function _tmp_sc:init()
        end
        function _tmp_sc:del()
        end
        _tmp_sc.perform=false
        table.insert(stage6bossScpr.cards,_tmp_sc)
    end
end
_editor_class["stage6bossScpr:Easy"] = stage6bossScpr
