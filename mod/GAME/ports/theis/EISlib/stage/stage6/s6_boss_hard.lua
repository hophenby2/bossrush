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
--生成常用加速弹
local function accbullet(st, co, x, y, v, a, t)
    local obj = stg.newBulletStraight(st, co, true, x, y, 0, a)
    egg.AddSimStrChV(obj, 0, v, a, t)
    return obj
end

--五符用酒罐子和妖精
local wine, fairy5, fairy_small5
--增加染色圈范围
local function addDyeRange(self, dr, t)
    dr = dr/t
    task.New(self, function()
        for _ = 1, t do
            self.dye_range = self.dye_range + dr
            task.Wait(1)
        end
    end)
end
do
    wine = Class(object)
    function wine:init(x, y)
        self.x, self.y = x, y
        self.group = GROUP_INDES
        self.layer = LAYER_ENEMY
        self.a, self.b = 8, 8
        self.img = "s6_wine2"
        self.size = 0.5
        self.hscale, self.vscale = 1, 1
        self.rot = 0
        _object.set_color(self, "", 255, 255, 255, 255)
        self.rate = 0 --与开盖动画有关（取值0-90)
        self.drate = 0
        self.hide = false
        self.bound = false
        self.colli = true
    end
    function wine:frame()
        task.Do(self)
        self.rate = min(90, self.rate + self.drate)
        self.hscale, self.vscale = 1 + 0.25*sin(2*self.rate), 1 - 0.175*sin(2*self.rate)
    end
    function wine:render()
        SetImageState("s6_wine2", "", Color(255, 255, 255, 255))
        Render("s6_wine2", self.x, self.y, self.rot, self.hscale*self.size, self.vscale*self.size)
        if self.rate < 90 then
            local rate = min(1, 2*cos(self.rate))
            SetImageState("s6_wine1", "", Color(self._a*rate, self._r, self._g, self._b))
            Render("s6_wine1", self.x, self.y + 30*(1-rate), self.rot, self.hscale*self.size, self.vscale*self.size)
        end
    end
    function wine:open()
        self.drate = 1.5
    end

    fairy5 = Class(enemy)
    function fairy5:init(x, y)
        enemy.init(self, 29, 50, false, false, true, true, 1, 0, 0, true)
        self.group = GROUP_NONTJT
        self.x, self.y = x, y
    end

    fairy_small5 = Class(enemy)
    function fairy_small5:init(x, y)
        enemy.init(self, 25, 50, false, false, true, false, 3, 0, 0, true)
        self.group = GROUP_NONTJT
        self.layer = LAYER_ENEMY+1
        self.x, self.y = x, y
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
            egg.AddSimStrChV(obj, 0, 2.8 + dv, a, 240, 90)
        end
        function f2(x, y, a, da, dv)
            local obj = stg.newBulletStraight(stg.grain_a, 4, true, x, y, 0, a)
            obj.navi = true
            egg.AddAccDecChV(obj, 1, a, 60, 0, 60)
            egg.AddAccDecChV(obj, 1, a, 30, 30, 30)
            egg.AddSimStrChV(obj, 0, 2.8 + dv, a + da, 240, 90)
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
            egg.AddSimStrChV(obj, 0, 1.75, a + ran:Float(0, 30)*u, 180, 0)
        end
    end

    do
        boss.show_aura(self, true)
        pinkeff(self.x, self.y, 60)
        local a, da, r, dr, u, dx, dy = -150, -120/72, 50, 1.5, -1
        a, da = -90 + 60*u, 120/72*u
        r, dr = 50, 1.5
        for _ = 1, 2 do
            for k = 0, 7 do
                dx, dy = r*cos(a), r*sin(a)
                for i = -1, 1 do
                    f1(self.x + dx, self.y + dy, a - (30*i + 120)*u, 0.2*k)
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
            task.Wait(2)
            a = a + da
            for k = 0, 7 do
                dx, dy = r*cos(a), r*sin(a)
                for i = -1, 1 do
                    for j = -1, 1, 2 do
                        f2(self.x + dx, self.y + dy, a - (30*i + 120)*u, 45*j, 0.2*k)
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
            task.Wait(2)
            a = a + da
        end
        u = -u
        task.MoveTo(0, 100, 90, MOVE_ACC_DEC)
        a, da = -90 + 60*u, 120/72*u
        r, dr = 50, 1.5
        for _ = 1, 3 do
            for k = 0, 7 do
                dx, dy = r*cos(a), r*sin(a)
                for i = -2, 2 do
                    f1(self.x + dx, self.y + dy, a - (30*i + 120)*u, 0.2*k)
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
            task.Wait(2)
            a = a + da
            for k = 0, 7 do
                dx, dy = r*cos(a), r*sin(a)
                for i = -2, 2 do
                    for j = -1, 1, 2 do
                        f2(self.x + dx, self.y + dy, a - (30*i + 120)*u, 45*j, 0.2*k)
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
            task.Wait(2)
            a = a + da
        end
        task.MoveTo(0, 144, 60, MOVE_ACC_DEC)
        pinkeff(self.x, self.y, 60)
        r, dr = 50, 1
        while true do
            for _ = 1, 6 do
                for k = 0, 7 do
                    for _ = 0, 1 do  --2way
                        a = a + 180
                        dx, dy = r*cos(a), r*sin(a)
                        for i = -1, 1 do
                            f1(self.x + dx, self.y + dy, a - (45*i + 120)*u, 0.2*k)
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
                task.Wait(2)
                a = a + da
                for k = 0, 7 do
                    for _ = 0, 1 do --2way
                        a = a + 180
                        dx, dy = r*cos(a), r*sin(a)
                        for i = -1, 1 do
                            for j = -1, 1, 2 do
                                f2(self.x + dx, self.y + dy, a - (45*i + 120)*u, 45*j, 0.2*k)
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
                task.Wait(2)
                a = a + da
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
    --self.colli = true
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
            local v0 = 1.75 + dv
            egg.AddSimStrChV(obj, 0, v0, a, 10*v0)
        end
        function f2(x, y, a, dv0, dv1, da)
            local obj = stg.newBulletStraight(stg.grain_a, 3, false, x, y, 0, a)
            local v0 = 1.75 + dv0
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
            egg.AddSimStrChV(obj, 0, 2.25 + dv, a, 30)
        end
    end

    do
        pinkeff(self.x, self.y, 60)
        local flower_pos = s6_boss.back_light.getFlowersPos(self.back_light) --获取花的位置
        local flower_a0 = {0, 180, -90, 180, 0}
        local flower_u = {1, -1, 1, 1, -1}
        --3号炮台
        task.New(self, function()
            task.Wait(160)
            local dsp, da, a = 60, 1
            for way = 1, 3 do
                a = Angle(flower_pos[3][1], flower_pos[3][2], player.x, player.y) - 0.5*dsp*(way-1)
                for i = 1, 3 + way do
                    for j = 0, way - 1 do
                        f3(flower_pos[3][1], flower_pos[3][2], a + j*dsp, 0.2*i)
                    end
                    PlaySound("kira00")
                    task.Wait(6)
                    a = a + da
                end
                task.Wait(54)
                dsp = dsp - 17.5
                da = -da
            end
            while true do
                a = -1.5*dsp + Angle(flower_pos[3][1], flower_pos[3][2], player.x, player.y)
                for i = 1, 6 do
                    for j = 0, 2 do
                        f3(flower_pos[3][1], flower_pos[3][2], a + j*dsp, 0.25*i)
                    end
                    PlaySound("kira00")
                    task.Wait(4)
                    a = a + da
                end
                task.Wait(40)
                da = -da
            end
        end)
        local a, da = 0, 1.25
        local la = 4
        for _ = 1, 5 do
            for k = 1, 1 do
                for j = 1, 5 do
                    if j ~= 3 then
                        for i = -1, 1 do
                            f2(flower_pos[j][1], flower_pos[j][2], flower_a0[j] + a*flower_u[j] + 30*i, 0.1*k, 0.1*k, 0)
                        end
                    end
                end
                PlaySound("tan00")
                task.Wait(6)
                a = a + da
            end
            for k = 2, la do
                for j = 1, 5 do
                    if j ~= 3 then
                        for i = -1, 1 do
                            f1(flower_pos[j][1], flower_pos[j][2], flower_a0[j] + a*flower_u[j] + 30*i, 0.1*k)
                        end
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
                        for i = -1, 1 do
                            f2(flower_pos[j][1], flower_pos[j][2], flower_a0[j] + a*flower_u[j] + 30*i, 0.2*k, 0.15*k, 0*flower_u[j]*k)
                        end
                    end
                end
                task.Wait(3)
                a = a + da
            end
            for k = 2, 10 do
                for j = 1, 5 do
                    if j ~= 3 then
                        for i = -1, 1 do
                            f1(flower_pos[j][1], flower_pos[j][2], flower_a0[j] + a*flower_u[j] + 30*i, 0.2*k)
                        end
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
                obj.layer = LAYER_ENEMY_BULLET+3
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
                obj.layer = LAYER_ENEMY_BULLET+3
                egg.AddSimStrChV(obj, 0, 5, obj.rot + 180, 60)
                egg.AddSimStrChV(obj, 0, -1, a + 150*u, 60)
                task.Wait(90)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, 2.25, obj.rot - 45*u, 60)
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
            for la = 4, 5 do
                for i = 1, 5 do
                    flower_a0[i] = Angle(flower_pos[i][1], flower_pos[i][2], player.x, player.y)
                end
                for j = 1, la do
                    for i = 1, 5 do
                        for k = -3, 3 do
                            for m = -1, 1 do
                                stg.newBulletStraight(stg.grain_a, 3, true, flower_pos[i][1], flower_pos[i][2], 2.5+0.2*j, flower_a0[i] + 60*k + 3*m)
                            end
                        end
                    end
                    task.Wait(6)
                end
                task.Wait(120)
            end
            while true do
                for i = 1, 5 do
                    flower_a0[i] = Angle(flower_pos[i][1], flower_pos[i][2], player.x, player.y)
                end
                for j = 1, 9 do
                    for i = 1, 5 do
                        for k = -3, 3 do
                            for m = -1, 1 do
                                stg.newBulletStraight(stg.grain_a, 3, true, flower_pos[i][1], flower_pos[i][2], 2.5+0.2*j, flower_a0[i] + 60*k + 3*m)
                            end
                        end
                    end
                    task.Wait(2)
                end
                task.Wait(120)
            end
        end)
        local a, da
        --中间攻击
        do
            for u = -1, -1, -2 do
                a, da = 90 - 64*u, 3.5*u
                for _ = 1, 7 do
                    for i = -6, 6 do
                        if i%2 == 1 then
                            f1(self.x, self.y, a + 14*i, u)
                        else
                            f2(self.x, self.y, a + 14*i, u)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(17)
                    a = a + da
                end
                task.Wait(60)
            end
        end
        while true do
            for u = 1, -1, -2 do
                a, da = 90 - 64*u, 3.5*u
                for _ = 1, 10 do
                    for i = -6, 6 do
                        if i%2 == 1 then
                            f1(self.x, self.y, a + 14*i, u)
                        else
                            f2(self.x, self.y, a + 14*i, u)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(10)
                    a = a + da
                end
                task.Wait(38)
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
            egg.AddSimStrChV(obj, 0, 1.35, a + da, t, 30)
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
                SetV(obj, 10, a)
                obj.hide = false
                obj.colli = true
                task.New(obj, function()
                    local dh = 0.5
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
            local way, dsp, a = 6, 25
            while true do
                a = 90 - 0.5*dsp*(way-1)
                for _ = 1, way do
                    for u = -1, 1, 2 do
                        f2(flower_pos[3][1], flower_pos[3][2], a, u)
                    end
                    a = a + dsp
                end
                task.Wait(120)
                way = way + 1
            end
        end)
        --激光
        task.New(self, function()
            task.Wait(60)
            pinkeff(flower_pos[2][1], flower_pos[2][2])
            pinkeff(flower_pos[4][1], flower_pos[4][2], 60)
            local frame = 240
            while true do
                for _ = 1, 2 do
                    for i = -1, 1 do
                        f3(flower_pos[2][1], flower_pos[2][2], Angle(flower_pos[2][1], flower_pos[2][2], player.x, player.y) + 25*i)
                        f3(flower_pos[4][1], flower_pos[4][2], Angle(flower_pos[4][1], flower_pos[4][2], player.x, player.y) + 25*i)
                    end
                    task.Wait(10)
                end
                task.Wait(frame)
                frame = max(frame - 30, 180)
            end
        end)
        local u = 1
        for m = 0, 3 do
            for i = 1, 20 do
                for j = 1, 1 + 1*m do
                    f1(flower_pos[1][1], flower_pos[1][2], -75 - 100*u + (10*i)*u, 2.5*j*u, 50*j)
                    f1(flower_pos[5][1], flower_pos[5][2], -105 + 100*u - (10*i)*u, -2.5*j*u, 50*j)
                end
                PlaySound("tan00")
                task.Wait(4)
            end
            u = -u
        end
        pinkeff(self.x, self.y)
        s6_boss.changeSpeed(1.5)
        while true do
            for i = 1, 20 do
                for j = 1, 4 do
                    f1(flower_pos[1][1], flower_pos[1][2], -75 - 100*u - 9*(u-1) + (10*i)*u, 2.5*j*u, 50*j)
                    f1(flower_pos[5][1], flower_pos[5][2], -105 + 100*u + 9*(u-1) - (10*i)*u, -2.5*j*u, 50*j)
                end
                PlaySound("tan00")
                task.Wait(4)
            end
            u = -u
        end
    end
end
table.insert(atks, {boss_atk4, boss_atk4_normal_show, boss_atk4_scpr_show})
--一符
local function boss_sc1_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 120, 60, MOVE_NORMAL)
end
local function boss_sc1_scpr_show(self)
    boss_scpr_show(self, 0, 120)
end
local function boss_sc1(self)
    local f1, f1_1, f1_2, f2, f3, f4, f5, f5_1, f5_2, f6, f6_1

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
            if self.timer%15 == 0 then
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
                for k = 1, 19 do
                    for j = 0, 2 do
                        PlaySound("kira00")
                        r = 30 + 6.8*j + 20.4*k
                        for i = 1, 4 do
                            a = (6*j + 18*k)*u + 90*i
                            _x, _y = x + r*cos(a), y + r*sin(a)
                            if Dist(_x, _y, player.x, player.y) > 30 then
                                f3(_x, _y, 0.75, 1, a + 180, 20*j*u, 60 + 12*k + 4*j)
                            end
                        end
                        task.Wait(4)
                    end
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
                local a
                while self.timer < 1500 do
                    a = Angle(obj, player)
                    PlaySound("tan00")
                    for i = 1, 16 do
                        for j = 0, 1 do
                            f5_2(obj.x, obj.y, 1 + 0.25*j, 22.5*i + 11.25*j + a)
                        end
                    end
                    task.Wait(100)
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
        --大花发出的鳞弹
        function f5_2(x, y, v, a)
            local obj = stg.newBulletStraight(stg.arrow_big, 10, true, x, y, 0, a)
            _object.set_color(obj, "", 0, 255, 255, 255)
            egg.AddSimStrChV(obj, 2.5, v, a, 60)
            egg.SimAlpCh(obj, 0, 255, 60, true)
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET+3
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
                --[[while IsValid(self) and not self.release do
                    task.Wait(1)
                end
                egg.AddSimStrChV(obj, 0, ran:Float(1, 1.5), ran:Float(-85, -95), 90)]]
                if isRelease then
                    egg.AddSimStrChV(obj, 0, ran:Float(1.15, 1.5), ran:Float(-100, -80), 240)
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
        --self.x, self.y = 0, 100
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
            for _ = 1, 30 do
                f6(ran:Float(-192, 192), ran:Float(50, 192), ran:Sign(), true)
                task.Wait(30)
            end
            for _ = 1, 25 do
                f6(ran:Float(-192, 192), ran:Float(50, 192), ran:Sign(), true)
                task.Wait(6)
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
                        for j = 1, 3 do
                            f1_1(obj.x, obj.y, 0.9 + 0.225*j, a + i*45, 5)
                        end
                        for j = 1, 3 do
                            f1_1(obj.x, obj.y, 1.8 + 0.325*j, a + i*45 + 22.5, 8)
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
                        for i = -2, 2 do
                            f1_2(obj.x, obj.y, 1 - 0.075*abs(i), a + 2.5*i + 45*j, 5)
                        end
                    end
                    task.Wait(12)
                    for j = 1, 8 do
                        for i = -2, 2 do
                            f1_2(obj.x, obj.y, 1 - 0.075*abs(i), a + 2.5*i + 45*j + 22.5, 8)
                        end
                    end
                    task.Wait(12)
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
                        for j = 1, 3 do
                            f1_1(obj.x, obj.y, 0.9 + 0.25*j, a + i*60, 5)
                        end
                        for j = 1, 3 do
                            f1_1(obj.x, obj.y, 1.8 + 0.35*j, a + i*60 + 30, 8)
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
                        for i = -2, 2 do
                            f1_2(obj.x, obj.y, 1.25 - 0.1*abs(i), a + 2.25*i + 60*j, 5)
                        end
                    end
                    task.Wait(12)
                    for j = 1, 6 do
                        for i = -2, 2 do
                            f1_2(obj.x, obj.y, 1.25 - 0.1*abs(i), a + 2.25*i + 60*j + 22.5, 8)
                        end
                    end
                    task.Wait(12)
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
                        for j = 1, 3 do
                            f1_1(obj.x, obj.y, 0.9 + 0.25*j, a + i*60, 5)
                        end
                        for j = 1, 3 do
                            f1_1(obj.x, obj.y, 1.8 + 0.35*j, a + i*60 + 30, 8)
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
                        for i = -2, 2 do
                            f1_2(obj.x, obj.y, 1.25 - 0.1*abs(i), a + 2.5*i + 60*j, 5)
                        end
                    end
                    task.Wait(12)
                    for j = 1, 6 do
                        for i = -2, 2 do
                            f1_2(obj.x, obj.y, 1.25 - 0.1*abs(i), a + 2.5*i + 60*j + 22.5, 8)
                        end
                    end
                    task.Wait(12)
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
            f1(-192, 50, 10 + ran:Float(0, 5), 1, 10)
            task.Wait(150)
            pinkeff(192, 50, 60)
            f1(192, 50, 170 + ran:Float(0, -5), -1, 10)
            task.Wait(240)
            pinkeff(-192, -50)
            pinkeff(192, -50, 0)
            f2(-192, -50, 60 + ran:Float(-2, 2), 1, 13)
            f2(192, -50, 120 + ran:Float(-2, 2), -1, 13)
            task.Wait(180)
            pinkeff(self.x, self.y, 60)
            --发射炎弹
            do
                local r, a
                for k = 1, 12 do
                    r = 60 - 3*k
                    a = 6*k
                    for _ = 1, 20 do
                        a = a + 18
                        f3(self.x + r*cos(a), self.y + r*sin(a), 0.9, a, 5)
                    end
                    PlaySound("kira00")
                    task.Wait(4)
                end
                for k = 12, 1, -1 do
                    r = 60 - 3*k
                    a = 6*k + 3
                    for _ = 1, 20 do
                        a = a + 18
                        f3(self.x + r*cos(a), self.y + r*sin(a), 1.6 + 0.075*k, a, 8)
                    end
                    PlaySound("kira00")
                    task.Wait(4)
                end
            end
            task.Wait(60)
            pinkeff(-100, 224)
            pinkeff(100, 224, 60)
            f4(-100, 224, -150 + ran:Float(-2, 2), -1, 9)
            f4(100, 224, -30 + ran:Float(-2, 2), 1, 9)
            task.Wait(300)
        end
        --循环波（虽然也就两波233
        while true do
            pinkeff(-192, 50, 60)
            f1(-192, 50, 10 + ran:Float(0, 5), 1, 8)
            task.Wait(120)
            pinkeff(-192, 50, 60)
            f1(192, 50, 170 + ran:Float(0, -5), -1, 8)
            task.Wait(240)
            pinkeff(-192, -50)
            pinkeff(192, -50, 0)
            f2(-192, -50, 60 + ran:Float(-2, 2), 1, 11)
            f2(192, -50, 120 + ran:Float(-2, 2), -1, 11)
            task.Wait(180)
            pinkeff(self.x, self.y, 60)
            --发射炎弹
            do
                local r, a
                for k = 1, 15 do
                    r = 60 - 3*k
                    a = 5*k
                    for _ = 1, 24 do
                        a = a + 15
                        f3(self.x + r*cos(a), self.y + r*sin(a), 1, a, 5)
                    end
                    task.Wait(3)
                end
                for k = 15, 1, -1 do
                    r = 60 - 3*k
                    a = 5*k + 2.5
                    for _ = 1, 24 do
                        a = a + 15
                        f3(self.x + r*cos(a), self.y + r*sin(a), 1.5 + 0.05*k, a, 8)
                    end
                    task.Wait(3)
                end
            end
            task.Wait(30)
            pinkeff(-100, 224)
            pinkeff(100, 224, 60)
            f4(-100, 224, -150 + ran:Float(-2, 2), -1, 7)
            f4(100, 224, -30 + ran:Float(-2, 2), 1, 7)
            task.Wait(300)
        end
    end
end
table.insert(scs, {boss_sc2, boss_sc2_normal_show, boss_sc2_scpr_show})
--三符
local small_fairy, big_fairy
do
    small_fairy = Class(enemy)
    function small_fairy:init(x, y, hp)
        enemy.init(self, 25, hp, false, false, true, false, 1, 0, 1, true)
        self.x, self.y = x, y
        --self.pos = 0
        --self.u = 1 --先初始化，以免炸游戏
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
    function big_fairy:init(x, y, hp)
        enemy.init(self, 29, hp, false, false, true, true, 1, 0, 1, true)
        self.x, self.y = x, y
        self.normalKill = function() end
    end
    function big_fairy:kill()
        self.normalKill(self)
        enemy.kill(self)
    end
end
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
    local flower_pos  --获取花的位置
    local f1, f1_1, f2, f2_2, f2_1, f3, f3_1, f4, f4_2, f4_1, f5
    local drot = {5, 10, 15, 20}
    local _x0, _y0, _a0, _b0 = 0, 100, 120, 90  --椭圆圆心，长轴
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
        function f2(a, u, a0, t, x, y)
            local obj
            if x and y then
                obj = stg.newBulletStraight(stg.star_small, 3, true, x, y, 0, a0)
            else
                obj = stg.newBulletStraight(stg.star_small, 3, true, _x0 + _a0*cos(a), _y0 + _b0*sin(a), 0, a0)
            end
            _connect(self, obj, 0, true)
            obj.group = GROUP_INDES
            obj.hscale, obj.vscale = 1.5, 1.5
            obj.a, obj.b = 4, 4
            obj._a = 255
            obj.fairy = nil --自己的妖精对象
            obj.spawn = false  --spawn由外面操纵
            do--创建绑定的花瓣对象
                local da = -15
                for _ = 1, 5 do
                    da = -90
                    for _ = 1, 2 do
                        f2_1(obj, 12*cos(a0), 12*sin(a0), a0, da)
                        da = da + 180
                    end
                    a0 = a0 + 72
                end
            end
            task.New(obj, function ()
                obj.layer = LAYER_ENEMY_BULLET+3
                while not obj.spawn do
                    task.Wait(1)
                end
                PlaySound("kira00")
                obj.group = GROUP_ENEMY_BULLET
                egg.AddSimStrChV(obj, 0, 1.5, Angle(obj, player), 30)
                egg.AddSimStrChO(obj, 0, 2, 60)
            end)
            table.insert(my_flower, {obj, a, u, t, 10, x, y})
            return obj
        end
        function f2_2(a, u, a0, t, x, y)
            local obj
            if x and y then
                obj = stg.newBulletStraight(stg.star_small, 3, true, x, y, 0, a0)
            else
                obj = stg.newBulletStraight(stg.star_small, 3, true, _x0 + _a0*cos(a), _y0 + _b0*sin(a), 0, a0)
            end
            _connect(self, obj, 0, true)
            obj.group = GROUP_INDES
            obj.hscale, obj.vscale = 1.5, 1.5
            obj.a, obj.b = 4, 4
            obj._a = 255
            obj.fairy = nil --自己的妖精对象
            obj.spawn = false  --spawn由外面操纵
            do--创建绑定的花瓣对象
                local da = -15
                for _ = 1, 5 do
                    da = -90
                    for _ = 1, 1 do
                        f2_1(obj, 12*cos(a0), 12*sin(a0), a0, da)
                        da = da + 180
                    end
                    a0 = a0 + 72
                end
            end
            task.New(obj, function ()
                while not obj.spawn do
                    task.Wait(1)
                end
                obj.group = GROUP_ENEMY_BULLET
                egg.AddSimStrChV(obj, 0, 1.5, Angle(obj, player), 30)
                egg.AddSimStrChO(obj, 0, 2, 60)
            end)
            table.insert(my_flower, {obj, a, u, t, 10, x, y})
        end
        function f2_1(mst, x, y, a, da)
            local obj = stg.newBulletStraight(stg.arrow_big, 4, true, mst.x, mst.y, 0, a)
            _connect(self, obj, 0, true)
            obj.group = GROUP_INDES
            obj.bound = false
            --obj.layer = LAYER_ENEMY_BULLET-1
            obj.hscale, obj.vscale = 1, 1
            obj._a = 255
            task.New(obj, function ()
                obj.layer = LAYER_ENEMY_BULLET+3
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
                egg.AddSimStrChV(obj, 0, 1, obj.rot, 30)
                task.Wait(30)
                egg.AddSimStrChV(obj, 0, 1, obj.rot + da, 90)
            end)
        end
        --生成小妖精
        function f3(a, u, t, x, y)
            t = t or 0
            local obj
            if x and y then
                obj = New(small_fairy, x, y, 50)
                obj.IsnAttack = true
            else
                obj = New(small_fairy, _x0 + _a0*cos(a), _y0 + _b0*sin(a), 50)
            end
            obj.pos = a
            obj.u = u
            table.insert(self.fairys, obj)
            _object.set_color(obj, "", 0, 255, 255, 255)
            egg.SimSizeCh(obj, 0, 1, 30)
            egg.SimAlpCh(obj, 0, 255, 30, true)
            if not obj.IsnAttack then
                --小妖精固定移动
                task.New(obj, function()
                    task.Wait(60 + t)
                    --椭圆运动
                    --加速
                    local da, dda = 0, 1/60*u
                    for _ = 1, 60 do
                        da = da + dda
                        obj.pos = obj.pos + da
                        obj.x, obj.y = _x0 + _a0*cos(obj.pos), _y0 + _b0*sin(obj.pos)
                        task.Wait(1)
                    end
                    while true do
                        obj.pos = obj.pos + da
                        obj.x, obj.y = _x0 + _a0*cos(obj.pos), _y0 + _b0*sin(obj.pos)
                        task.Wait(1)
                    end
                end)
                --小妖精随时间强化的攻击
                task.New(obj, function()
                    task.Wait(90 + t)
                    --渐强攻击
                    local frame, da, dv, dda = 20, 0, 0, 12*u
                    while true do
                        for _ = 1, 10 do
                            --accbullet(stg.arrow_big, 10, obj.x, obj.y, 1 + dv, obj.pos + da, 60)
                            f3_1(obj.x, obj.y, 0.8 + dv, obj.pos + da)
                            task.Wait(frame)
                            PlaySound("tan00")
                            da = da + dda
                            dv = min(1, dv + 0.0125)
                        end
                        frame = max(12, frame - 1)
                    end
                end)
            end
            --死亡
            obj.normalKill = function()
                if obj.IsnAttack then
                    f2_2(obj.pos, obj.u, Angle(obj, player), 30, obj.x, obj.y)
                else
                    f2(obj.pos, obj.u, Angle(obj, player), 30)
                end
            end
            --染死
            obj._dyeKill = function()
                if obj.IsnAttack then
                    f2_2(obj.pos, obj.u, Angle(obj, player), 60, obj.x, obj.y)
                else
                    f2_2(obj.pos, obj.u, Angle(obj, player), 60)
                end
            end
            return obj
        end
        --小妖精的加速弹
        function f3_1(x, y, v, a)
            local obj = stg.newBulletStraight(stg.arrow_big, 10, true, x, y, 0, a)
            --local obj = accbullet(stg.arrow_big, 10, x, y, v, a, 30)
            egg.AddSimStrChV(obj, 3, v, a, 30)
            obj.timer = 11
            _object.set_color(obj, "", 0, 255, 255, 255)
            egg.SimAlpCh(obj, 0, 255, 60, true)
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET+3
            end)
        end
        --大花~!
        function f4(x, y, i)
            local obj = stg.newBulletStraight(stg.ball_light, 3, true, x, y, 0, 0, true)
            _connect(self, obj, 0, true)
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
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
                obj.layer = LAYER_ENEMY_BULLET-2
                for i = 3, 1, -1 do
                    for j = 1, 8 do
                        f4_1(obj, 0.4 + 0.1*i, 10 + 4*i, 90 + 45*j + 22.5*i)
                    end
                end
                while not obj.spawn do
                    task.Wait(1)
                end
                PlaySound("kira00")
                obj.group = GROUP_ENEMY_BULLET
                --obj.layer = LAYER_ENEMY_BULLET-2
                _object.set_color(obj, "mul+add", 255, 255, 255, 255)
                egg.AddSimStrChV(obj, 2, 1, Angle(obj, player), 60)
            end)
            table.remove(my_flower_big, i)
            table.insert(my_flower_big, i, {obj, 120, 30})
            --my_flower_big[i] = {obj, 120} --替换表
        end
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
                while IsValid(mst) and not mst.spawn do
                    task.Wait(1)
                end
                obj.group = GROUP_ENEMY_BULLET
                egg.AddSimStrChV(obj, 2, 0.75 + 0.25*s, obj.rot, 30)
            end)
        end
        --生成大蝴蝶
        function f5(x, y, i)
            local obj = New(big_fairy, x, y, 32, i)
            table.insert(self.fairys, obj)
            _object.set_color(obj, "", 0, 255, 255, 255)
            egg.SimSizeCh(obj, 0, 1, 30)
            egg.SimAlpCh(obj, 0, 255, 30, true)
            --大蝴蝶不动
            --染色圈变大
            task.New(obj, function()
                for x = 1, 100 do
                    obj.dye_range = 90*sin(x)
                    task.Wait(1)
                end
            end)
            obj.pos = i
            --死亡
            obj.normalKill = function()
                f4(obj.x, obj.y, obj.pos)
            end
            return obj
        end
    end

    do
        --self.x, self.y = 0, 50
        s6_boss.pic_show()
        task.Wait(90)
        flower_pos = s6_boss.back_light.getFlowersPos(self.back_light) --获取花的位置
        --s6_boss.back_light.appear(self.back_light) --测试用亮光背
        pinkeff(self.x, self.y, 30)
        do
            f1(self.x, self.y - 30, 25, 1)
            f1(self.x, self.y - 30, 65, 1)
            f1(self.x, self.y - 30, 115, -1)
            f1(self.x, self.y - 30, 155, -1)
            task.Wait(60)
            --生成小妖精的花
            for i = 0, 23 do
                f2(15*i, -1 + 2*(i%2), 15*i, 120)
            end
            --生成大妖精的花
            local da, obj = 360/7
            for i = 1, 5 do
                f4(flower_pos[i][1], flower_pos[i][2], i)
                for j = 1, 7 do
                    obj = f2_2(15*i, -1 + 2*(i%2), 15*i, 120, flower_pos[i][1] + 40*cos(da*j), flower_pos[i][2] + 40*sin(da*j))
                end
            end
            pinkeff(self.x, self.y, 60)
            pinkbkeff(self.x, self.y)
            --重置，同时使所有花的开花时间为0
            for i = 1, #my_flower do
                my_flower[i][4] = 0
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
                        if my_flower[i][4] <= 0 then
                            self.hp = self.hp - 5
                            if my_flower[i][6] and my_flower[i][7] then --6 7是固定妖精的位置参数，如果没有就是旋转的妖精
                                New(dye_fly_to_enemy, self.x, self.y, f3(my_flower[i][6], my_flower[i][7], 90, my_flower[i][6], my_flower[i][7]))--生成小妖精和染色特效
                            else
                                New(dye_fly_to_enemy, self.x, self.y, f3(my_flower[i][2], my_flower[i][3], 90))--生成小妖精和染色特效
                            end
                            obj.spawn = true
                            table.remove(my_flower, i)
                            n = n - 1
                        else
                            my_flower[i][4] = my_flower[i][4] - 1
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
                            self.hp = self.hp - 5
                            local enemy = f5(obj.x, obj.y, i)
                            table.remove(my_flower_big, i)
                            table.insert(my_flower_big, i, {enemy, 999999, 0})
                            --my_flower_big[i] = {enemy, 999999}
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
                        if my_flower[i][4] <= 0 then
                            self.hp = self.hp - 5 --
                            if my_flower[i][6] and my_flower[i][7] then
                                New(dye_fly_to_enemy, self.x, self.y, f3(my_flower[i][6], my_flower[i][7], 90, my_flower[i][6], my_flower[i][7]))--生成小妖精和染色特效
                            else
                                New(dye_fly_to_enemy, self.x, self.y, f3(my_flower[i][2], my_flower[i][3], 90))--生成小妖精和染色特效
                            end
                            obj.spawn = true
                            table.remove(my_flower, i)
                            n = n - 1
                        else
                            my_flower[i][4] = my_flower[i][4] - 1
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
                            self.hp = self.hp - 5
                            local enemy = f5(obj.x, obj.y, i)
                            table.remove(my_flower_big, i)
                            table.insert(my_flower_big, i, {enemy, 999999, 0})
                            --my_flower_big[i] = {enemy, 999999}
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
        --发射弹幕
        task.New(self, function()
            task.Wait(200)
            local frame, way, a, da = 210, 4
            while true do
                a = Angle(self, player)
                da = 30/way
                for k = 0, 2 do
                    for i = 1, 6 do
                        for j = -way, way do
                            stg.newBulletStraight(stg.ball_mid_c, 3, false, self.x, self.y, 0.25*k + 1.5 - 0.1*abs(j), 60*i + da*j)
                        end
                    end
                end
                task.Wait(frame)
                frame = max(frame - 30, 120)
                way = min(way + 1, 8)
            end
        end)
    end
end
--[[local function boss_sc3(self)
    local my_flower = {} --等待boss开花的表
    local my_flower_big = {{}, {}, {}, {}, {}} --大蝴蝶的花(五个固定位置
    local flower_pos  --获取花的位置
    local f1, f1_1, f2, f2_2, f2_1, f3, f3_1, f4, f4_2, f4_1, f5
    local drot = {5, 10, 15, 20}
    local V = 2.5  --小怪弹速随时间狂暴
    local _x0, _y0, _a0, _b0 = 0, 100, 120, 90  --椭圆圆心，长轴
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
        function f2(a, u, a0, t)
            local obj = stg.newBulletStraight(stg.star_small, 3, true, _x0 + _a0*cos(a), _y0 + _b0*sin(a), 0, a0)
            _connect(self, obj, 0, true)
            obj.group = GROUP_INDES
            obj.hscale, obj.vscale = 1.5, 1.5
            obj.a, obj.b = 4, 4
            obj._a = 255
            obj.fairy = nil --自己的妖精对象
            obj.spawn = false  --spawn由外面操纵
            do--创建绑定的花瓣对象
                local da = -15
                for _ = 1, 5 do
                    da = -90
                    for _ = 1, 3 do
                        f2_1(obj, 12*cos(a0), 12*sin(a0), a0, da)
                        da = da + 90
                    end
                    a0 = a0 + 72
                end
            end
            task.New(obj, function ()
                obj.layer = LAYER_ENEMY_BULLET+3
                while not obj.spawn do
                    task.Wait(1)
                end
                PlaySound("kira00")
                obj.group = GROUP_ENEMY_BULLET
                egg.AddSimStrChV(obj, 0, 1.25, Angle(obj, player), 30)
                egg.AddSimStrChO(obj, 0, 2, 60)
            end)
            table.insert(my_flower, {obj, a, u, t, 10})
        end
        function f2_2(a, u, a0, t)
            local obj = stg.newBulletStraight(stg.star_small, 3, true, _x0 + _a0*cos(a), _y0 + _b0*sin(a), 0, a0)
            _connect(self, obj, 0, true)
            obj.group = GROUP_INDES
            obj.hscale, obj.vscale = 1.5, 1.5
            obj.a, obj.b = 4, 4
            obj._a = 255
            obj.fairy = nil --自己的妖精对象
            obj.spawn = false  --spawn由外面操纵
            do--创建绑定的花瓣对象
                local da = -15
                for _ = 1, 5 do
                    da = -90
                    for _ = 1, 2 do
                        f2_1(obj, 12*cos(a0), 12*sin(a0), a0, da)
                        da = da + 180
                    end
                    a0 = a0 + 72
                end
            end
            task.New(obj, function ()
                while not obj.spawn do
                    task.Wait(1)
                end
                obj.group = GROUP_ENEMY_BULLET
                egg.AddSimStrChV(obj, 0, 1.25, Angle(obj, player), 30)
                egg.AddSimStrChO(obj, 0, 2, 60)
            end)
            table.insert(my_flower, {obj, a, u, t, 10})
        end
        spawn_flower_small1 = f2   --直接击破生成这个
        spawn_flower_small2 = f2_2  --染色击破生成这个
        function f2_1(mst, x, y, a, da)
            local obj = stg.newBulletStraight(stg.arrow_big, 4, true, mst.x, mst.y, 0, a)
            _connect(self, obj, 0, true)
            obj.group = GROUP_INDES
            obj.bound = false
            --obj.layer = LAYER_ENEMY_BULLET-1
            obj.hscale, obj.vscale = 1, 1
            obj._a = 255
            task.New(obj, function ()
                obj.layer = LAYER_ENEMY_BULLET+3
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
                egg.AddSimStrChV(obj, 0, 0.8, obj.rot, 30)
                task.Wait(30)
                egg.AddSimStrChV(obj, 0, 0.8, obj.rot + da, 90)
            end)
        end
        --生成小妖精
        function f3(a, u, t)
            t = t or 0
            local obj = New(small_fairy, _x0 + _a0*cos(a), _y0 + _b0*sin(a), 50)
            obj.pos = a
            obj.u = u
            _connect(self, obj, 0, true)
            _object.set_color(obj, "", 0, 255, 255, 255)
            egg.SimSizeCh(obj, 0, 1, 30)
            egg.SimAlpCh(obj, 0, 255, 30, true)
            --小妖精固定移动
            task.New(obj, function()
                task.Wait(60 + t)
                --椭圆运动
                --加速
                local da, dda = 0, 1/60*u
                for _ = 1, 60 do
                    da = da + dda
                    obj.pos = obj.pos + da
                    obj.x, obj.y = _x0 + _a0*cos(obj.pos), _y0 + _b0*sin(obj.pos)
                    task.Wait(1)
                end
                while true do
                    obj.pos = obj.pos + da
                    obj.x, obj.y = _x0 + _a0*cos(obj.pos), _y0 + _b0*sin(obj.pos)
                    task.Wait(1)
                end
            end)
            --小妖精随时间强化的攻击
            task.New(obj, function()
                task.Wait(90 + t)
                --渐强攻击
                local frame, da, dv, dda = 20, 0, 0, 12*u
                while true do
                    for _ = 1, 10 do
                        --accbullet(stg.arrow_big, 10, obj.x, obj.y, 1 + dv, obj.pos + da, 60)
                        f3_1(obj.x, obj.y, 0.8 + dv, obj.pos + da)
                        task.Wait(frame)
                        PlaySound("tan00")
                        da = da + dda
                        dv = min(1, dv + 0.0125)
                    end
                    frame = max(12, frame - 1)
                end
            end)
            return obj
        end
        --小妖精的加速弹
        function f3_1(x, y, v, a)
            local obj = stg.newBulletStraight(stg.arrow_big, 10, true, x, y, 0, a)
            --local obj = accbullet(stg.arrow_big, 10, x, y, v, a, 30)
            egg.AddSimStrChV(obj, 3, v, a, 30)
            obj.timer = 11
            _object.set_color(obj, "", 0, 255, 255, 255)
            egg.SimAlpCh(obj, 0, 255, 60, true)
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET+3
            end)
        end
        --大花~!
        function f4(x, y, i)
            local obj = stg.newBulletStraight(stg.ball_light, 3, true, x, y, 0, 0, true)
            _connect(self, obj, 0, true)
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
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
                obj.layer = LAYER_ENEMY_BULLET-2
                for i = 3, 1, -1 do
                    for j = 1, 8 do
                        f4_1(obj, 0.4 + 0.1*i, 10 + 4*i, 90 + 45*j + 22.5*i)
                    end
                end
                while not obj.spawn do
                    task.Wait(1)
                end
                PlaySound("kira00")
                obj.group = GROUP_ENEMY_BULLET
                --obj.layer = LAYER_ENEMY_BULLET-2
                _object.set_color(obj, "mul+add", 255, 255, 255, 255)
                egg.AddSimStrChV(obj, 2, 0.8, Angle(obj, player), 60)
            end)
            table.remove(my_flower_big, i)
            table.insert(my_flower_big, i, {obj, 200, 30})
            --my_flower_big[i] = {obj, 120} --替换表
        end
        spawn_flower_big1 = f4
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
                while IsValid(mst) and not mst.spawn do
                    task.Wait(1)
                end
                obj.group = GROUP_ENEMY_BULLET
                egg.AddSimStrChV(obj, 2, 0.8 + 0.1*s, obj.rot, 30)
            end)
        end
        --生成大蝴蝶
        function f5(x, y, i)
            local obj = New(big_fairy, x, y, 40, i)
            _connect(self, obj, 0, true)
            _object.set_color(obj, "", 0, 255, 255, 255)
            egg.SimSizeCh(obj, 0, 1, 30)
            egg.SimAlpCh(obj, 0, 255, 30, true)
            --大蝴蝶不动
            --染色圈变大
            task.New(obj, function()
                for x = 1, 100 do
                    obj.dye_range = 90*sin(x)
                    task.Wait(1)
                end
            end)
            return obj
        end
    end

    do
        s6_boss.pic_show()
        task.Wait(90)
        flower_pos = s6_boss.back_light.getFlowersPos(self.back_light) --获取花的位置
        --s6_boss.back_light.appear(self.back_light) --测试用亮光背
        pinkeff(self.x, self.y, 30)
        do
            f1(self.x, self.y - 30, 25, 1)
            f1(self.x, self.y - 30, 65, 1)
            f1(self.x, self.y - 30, 115, -1)
            f1(self.x, self.y - 30, 155, -1)
            task.Wait(60)
            --生成小妖精的花
            for i = 0, 23 do
                f2(15*i, -1 + 2*(i%2), 15*i, 120)
            end
            --生成大妖精的花
            for i = 1, 5 do
                f4(flower_pos[i][1], flower_pos[i][2], i)
            end
            pinkeff(self.x, self.y, 60)
            pinkbkeff(self.x, self.y)
            --重置，同时使所有花的开花时间为0
            for i = 1, #my_flower do
                my_flower[i][4] = 0
            end
            for i = 1, 5 do
                my_flower_big[i][4] = 0
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
                        if my_flower[i][4] <= 0 then
                            self.hp = self.hp - 10
                            New(dye_fly_to_enemy, self.x, self.y, f3(my_flower[i][2], my_flower[i][3], 90))--生成小妖精和染色特效
                            obj.spawn = true
                            table.remove(my_flower, i)
                            n = n - 1
                        else
                            my_flower[i][4] = my_flower[i][4] - 1
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
                            self.hp = self.hp - 10
                            local enemy = f5(obj.x, obj.y, i)
                            table.remove(my_flower_big, i)
                            table.insert(my_flower_big, i, {enemy, 999999, 0})
                            --my_flower_big[i] = {enemy, 999999}
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
                        if my_flower[i][4] <= 0 then
                            self.hp = self.hp - 10 --3号位是伤害值
                            New(dye_fly_to_enemy, self.x, self.y, f3(my_flower[i][2], my_flower[i][3]))--生成小妖精和染色特效
                            obj.spawn = true
                            table.remove(my_flower, i)
                            n = n - 1
                        else
                            my_flower[i][4] = my_flower[i][4] - 1
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
                            self.hp = self.hp - 10
                            local enemy = f5(obj.x, obj.y, i)
                            table.remove(my_flower_big, i)
                            table.insert(my_flower_big, i, {enemy, 999999, 0})
                            --my_flower_big[i] = {enemy, 999999}
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
            while true do
                V = V + 0.05
                task.Wait(60)
            end
        end)
        --发射弹幕
        task.New(self, function()
            task.Wait(200)
            local frame, way, a, da = 270, 3
            while true do
                a = Angle(self, player)
                da = 30/way
                for k = 0, 1 do
                    for i = 1, 6 do
                        for j = -way, way do
                            stg.newBulletStraight(stg.ball_mid_c, 3, false, self.x, self.y, 0.25*k + 1.5 - 0.1*abs(j), 60*i + da*j)
                        end
                    end
                end
                task.Wait(frame)
                frame = max(frame - 30, 150)
                way = min(way + 1, 6)
            end
        end)
    end
end]]
table.insert(scs, {boss_sc3, boss_sc3_normal_show, boss_sc3_scpr_show})
--四符
local function boss_sc4_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 120, 60, MOVE_NORMAL)
    task.Wait(30)
end
local function boss_sc4_scpr_show(self)
    boss_scpr_show(self, 0, 120)
    s6_boss.back_light.appear(self.back_light)
    task.Wait(30)
end
local function boss_sc4(self)
    local f1, f1_1, f1_2, f2, f2_1, f3
    local flower_pos
    local co = {1, 3, 5}
    do
        --大*激光
        function f1(x, y, a, u, atk)
            local obj = stg.newBulletStraight(stg.ball_light, 3, true, x, y, 0, a, true)
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            obj.undestoryable = true --真正不可消除
            obj.hscale, obj.vscale = 0, 0.35
            obj.a, obj.b = 0, 0.35*obj.b
            obj.bound = false
            obj.hide = true
            obj.colli = false
            task.New(obj, function()
                laser_eff(x, y, a, 255, 0, 255)
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
                --[[樱花
                task.New(obj, function()
                    for i = 1, 4 do
                        if Dist(obj, player) > 50 then
                            for u = -1, 1, 2 do
                                f1_1(obj.x, obj.y, a, (60 - 4*i)*u, 240 - 24*i)
                                f1_1(obj.x, obj.y, a + 180, (60 - 4*i)*u, 240 - 24*i)
                            end
                        end
                        task.Wait(5)
                    end
                end)]]
                --鳞弹
                if atk then
                    task.New(obj, function()
                        for k = 1, 13 do
                            f1_2(obj.x, obj.y, a + (-270 + 20*k)*u)
                            task.Wait(2)
                        end
                    end)
                else
                    a = a + ran:Float(-5, 5)
                    for i = 1, 6 do
                        for j = 0, 0 do
                            f1_1(obj.x, obj.y, 1 + 0.5*j, a + 60*i + 30*j)
                        end
                    end
                end
                task.Wait(10)
            end)
        end
        function f1_1(x, y, v, a)
            local obj = stg.newBulletStraight(stg.ball_mid, 3, true, x, y, 0, a, true)
            obj.img = "Lily_Cherry_bullet"
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            obj.timer = 11
            obj.colli = false
            obj.hscale, obj.vscale = 0, 0
            obj.a, obj.b = 4, 4
            task.New(obj, function()
                egg.SimSizeCh(obj, 1, 0.65, 30)
                egg.SimAlpCh(obj, 0, 255, 30)
                task.Wait(30)
                _object.set_color(obj, "", 255, 255, 255, 255)
                obj.colli = true
            end)
            egg.AddSimStrChV(obj, 0, v, a, 120)
        end
        function f1_2(x, y, a)
            local obj = stg.newBulletStraight(stg.arrow_big, 10, true, x, y, 0, a)
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            task.New(obj, function()
                _object.set_color(obj, "", 255, 255, 255, 255)
                egg.AddSimStrChV(obj, -0.5, 1.25, a, 90)
            end)
        end
        function f2(x, y, a)
            local dsp, da = 10
            for i = 0, 1 do
                da = -0.5*(3+i)*dsp
                for _ = 0, 3 + i do
                    f2_1(x, y, 0.3-0.15*i, a, da, co[i+1])
                    da = da + dsp
                end
            end
        end
        function f2_1(x, y, dv, a, da, co)
            local obj = stg.newBulletStraight(stg.water_drop, co, true, x, y, 0, a)
            --_object.set_color(obj, "mul+add", 0, 255, 255, 255)
            obj.navi = true
            --obj.hscale, obj.vscale = 0.75, 0.75
            --obj.a, obj.b = obj.hscale*obj.a, obj.vscale*obj.b
            SetV(obj, -2.5, a + da)
            egg.AddSimStrChV(obj, 0, 3.25 + dv, a, 120)
        end
        --炎弹攻击总和
        function f3()
            local a0
            PlaySound("kira00")
            a0 = -90
            for j = -3, 3 do
                f2(self.x, self.y, j*60 + a0)
            end
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
        local u, a, a0 = 1
        while true do
            for k = 1, 12 do
                f1(flower_pos[1][1], flower_pos[1][2], 180 + 15*k, u, true)
                f1(flower_pos[5][1], flower_pos[5][2], 0 - 15*k, u, true)
                task.Wait(5)
            end
            task.Wait(30)
            f3()
            task.MoveTo(40*u, 144, 120, MOVE_ACC_DEC)
            task.Wait(30)
            for k = 1, 12 do
                f1(flower_pos[2][1], flower_pos[2][2], 0 - 15*k, -u, true)
                f1(flower_pos[4][1], flower_pos[4][2], 180 + 15*k, -u, true)
                task.Wait(5)
            end
            f3()
            task.Wait(60)
            task.New(self, function()
                for k = 1, 24 do
                    f1(flower_pos[2][1], flower_pos[2][2], 90 - 90*u + 15*k*u, 1)
                    f1(flower_pos[5][1], flower_pos[5][2], 90 + 90*u + 15*k*u, -1)
                    task.Wait(5)
                end
            end)
            task.MoveTo(-40*u, 144, 120, MOVE_ACC_DEC)
            f3()
            task.Wait(60)
            task.New(self, function()
                local u = u
                for i = 1, 5 do
                    if i ~= 3 then
                        for k = -3, 2 do
                            a = Angle(flower_pos[i][1], flower_pos[i][2], player.x, player.y)
                            f1(flower_pos[i][1], flower_pos[i][2], a + 25*k*u, u)
                            task.Wait(6)
                        end
                        u = -u
                    end
                end
                for _ = 1, 1 do
                    for k = -3, 2 do
                        a = Angle(flower_pos[3][1], flower_pos[3][2], player.x, player.y)
                        f1(flower_pos[3][1], flower_pos[3][2], a + 25*k*u, u)
                        task.Wait(6)
                    end
                    u = -u
                end
            end)
            task.MoveTo(0, 100, 120, MOVE_ACC_DEC)
            f3()
            task.Wait(240)
            u = -u
        end
    end
end
table.insert(scs, {boss_sc4, boss_sc4_normal_show, boss_sc4_scpr_show})
--五符
local function boss_sc5_normal_show(self)
    s6_boss.back_light.disAppear(self.back_light) --关掉光背
    task.Wait(30)
    task.MoveTo(0, 150, 60, MOVE_NORMAL)
    task.Wait(30)
end
local function boss_sc5_scpr_show(self)
    boss_scpr_show(self, 0, 150)
end
local function boss_sc5(self)
    local f1, f1_1, f1_2, f1_3, f2, f2_1, f3, f3_1, f3_2, f4, f4_1
    do
        --左右一般通过倒酒的妖精
        function f1()
            for i = 0, 2 do
                for u = -1, 1, 2 do
                    f1_1((-150 + 60*i)*u, 400 - 60*i)
                end
                task.Wait(30)
            end
        end
        function f1_1(x, y)
            local obj = New(fairy5, x, y)
            _connect(self, obj, 0, true)
            obj.wine = f1_2(x, y, obj) --产生酒
            --移动
            task.New(obj, function()
                egg.AddSimStrChV(obj, 5, 0, -90, 90)
                task.Wait(90)
                local u
                if obj.x < 0 then
                    u = 1
                else
                    u = -1
                end
                for i = 4, 1, -1 do
                    f3(obj.x, obj.y, 90*i, u, -30*i)
                    task.Wait(20)
                end
                addDyeRange(obj, 45, 60)
                --开盖有奖
                if IsValid(obj.wine) then
                    wine.open(obj.wine)
                end
                --pinkeff(obj.x, obj.y)
                task.Wait(30)
                --三吴克从酒罐子里出来啦
                if IsValid(obj.wine) then
                    for i = -1, 1 do
                        f1_3(obj.wine, -90 + 45*i)
                    end
                end
                task.Wait(150)
                obj.release = true --放开罐子，跑了，接下来动作由罐子定义里的内容完成
                obj.ay = 0.05
                while IsValid(obj.wine) do
                    task.Wait(1)
                end
                obj.bound = true
            end)
        end
        --酒罐
        function f1_2(x, y, mst)
            local obj = New(wine, x, y)
            --obj.vscale = obj.vscale*u
            --obj.rot = -15*u --稍微倾斜
            obj.bound = false
            --跟随主人 + 发弹
            task.New(obj, function()
                local t, flag = 0, true
                --酒扔出来之前要是主人死了酒罐子就不发弹幕了
                while true do
                    if IsValid(mst) then
                        obj.x, obj.y = mst.x, mst.y - 25
                        if mst.release then
                            break
                        end
                    else
                        flag = false
                        break
                    end
                    task.Wait(1)
                    t = t + 1
                end
                --被释放
                egg.AddSimStrChV(obj, 0, 3, -90, 60)
                obj.bound = true
                --发弹幕
                if flag then
                    for i = 20, 1, -1 do
                        f2(obj.x, obj.y + 20, 1 + 0.25*(20-i), 90, 20, -90, int(i/3))
                        PlaySound("kira00")
                        task.Wait(10)
                    end
                end
            end)
            return obj
        end
        --藏酒罐里妖精
        function f1_3(mst, a)
            local obj = New(fairy_small5, mst.x, mst.y)
            _connect(self, obj, 0, true)
            obj.hscale, obj.vscale = 0, 0
            obj.colli = false
            --移动
            local x, y, dx, dy = obj.x, obj.y, 25*cos(a), 15*sin(a)
            task.New(obj, function()
                egg.SimAlpCh(obj, 0, 255, 30, true)
                egg.SimSizeCh(obj, 0, 1, 30)
                --出现，移动到罐子的位置
                task.MoveTo(x + 0.5*dx, y + 30, 30, MOVE_ACC_DEC)
                task.MoveTo(x + dx, y + dy, 30, MOVE_ACC_DEC)
                --相对罐子运动
                while IsValid(mst) and obj.y > -192 do
                    obj.x, obj.y = mst.x + dx, mst.y + dy
                    task.Wait(1)
                end
                obj.vy, obj.ay = 0.5, 0.05 --跑了跑了~
                obj.bound = true
                task.Wait(80)
                while true do
                    for i = -3, 3 do
                        accbullet(stg.ball_mid_c, 3, obj.x, obj.y, 1, a + 30*i, 60)
                    end
                    PlaySound("tan00")
                    task.Wait(25)
                end
            end)
            return obj
        end
        --酒发炎弹
        function f2(x, y, v, a, da, acc_a, n)
            a = a - 0.5*(n-1)*da
            for _ = 1, n do
                f2_1(x, y, v, a, acc_a)
                a = a + da
            end
        end
        function f2_1(x, y, v, a, acc_a)
            local obj = stg.newBulletStraight(stg.water_drop, 14, true, x, y, v, a)
            obj.navi = true
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            egg.AddSimStrChV(obj, 0, v + 1.5, acc_a, (v + 1.5)*50)
        end
        --酒下挂花
        function f3(x, y, a, u, dy)
            local obj = stg.newBulletStraight(stg.star_big, 3, true, x, y, 0, a)
            obj.omiga = 3*u
            --生成花瓣
            for i = 1, 5 do
                f3_1(72*i, obj)
            end
            task.New(obj, function()
                task.MoveTo(x, y + dy, 0.5*abs(dy), MOVE_ACC_DEC)
                egg.AddSimStrChO(obj, 0, -3*u, 30)
                task.Wait(30)
                --产生一圈大星弹
                for i = 0, 5 do
                    stg.newBulletStraight(stg.star_big, 1, true, obj.x, obj.y, 1, a + 60*i).omiga = 3
                end
                PlaySound("kira00")
                Del(obj)
            end)
        end
        --花瓣
        function f3_1(a, mst)
            local obj = stg.newBulletStraight(stg.arrow_big, 4, true, mst.x, mst.y, 0, a)
            task.New(obj, function()
                local r, dr = 0, 0.35
                for _ = 1, 30 do
                    r = r + dr
                    if IsValid(mst) then
                        obj.rot = mst.rot + a
                        obj.x, obj.y = mst.x + r*cos(obj.rot), mst.y + r*sin(obj.rot)
                    end
                    task.Wait(1)
                end
                while IsValid(mst) do
                    obj.rot = mst.rot + a
                    obj.x, obj.y = mst.x + r*cos(obj.rot), mst.y + r*sin(obj.rot)
                    task.Wait(1)
                end
                for j = 0, 0 do
                    for u = -1, 1, 2 do
                        f3_2(obj.x, obj.y, 0.5 + 0.25*j, obj.rot, 30*j + 60*u)
                    end
                end
                Del(obj)
            end)
        end
        --花瓣散开
        function f3_2(x, y, v, a, da)
            local obj = stg.newBulletStraight(stg.arrow_big, 4, true, x, y, 0, a)
            obj.timer = 11
            task.New(obj, function()
                --星星散开之后
                egg.AddSimStrChV(obj, 0, 0.5*v, a, 30)
                egg.AddSimStrChV(obj, 0, v, a + da, 90, 30)
                obj.navi = true
            end)
        end
    end

    do
        s6_boss.pic_show()
        task.Wait(90)
        local u = 1
        while true do
            f1()
            task.Wait(300)
        end
    end
end
table.insert(scs, {boss_sc5, boss_sc5_normal_show, boss_sc5_scpr_show})
--终符
local function boss_sc6_normal_show(self)
    task.Wait(30)
    task.MoveTo(0, 169, 60, MOVE_NORMAL)
    for _ = 1, 3 do
        pinkeff(self.x, self.y, 20)
    end
    s6_boss.back_light.appear(self.back_light) --测试用亮光背
    task.Wait(90)
end
local function boss_sc6_scpr_show(self)
    boss_scpr_show(self, 0, 169)
    s6_boss.back_light.appear(self.back_light) --测试用亮光背
    task.Wait(90)
end
local function boss_sc6(self)
    local flower_pos
    local f1, f1_1, f2, f3, f3_1, f3_2
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
                local a0 = ran:Float(1, -1)
                for i = -2, 2 do
                    f1_1(obj.x, obj.y, a - 15 + a0, co, 0, (0.9 + 0*i)*(1 + dv), 30*i)
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
        --激光
        function f3()
            New(tasker, function()
                local a = {}
                PlaySound("lazer00")
                for i = 1, 5 do
                    if i ~= 3 then
                        a[i] = Angle(flower_pos[i][1], flower_pos[i][2], player.x, player.y)
                        for j = -3, 3 do
                            f3_1(flower_pos[i][1], flower_pos[i][2], a[i] + 45*j)
                        end
                    end
                end
                task.Wait(45)
                PlaySound("lazer01")
                for i = 1, 5 do
                    if i ~= 3 then
                        for j = -3, 3 do
                            f3_2(flower_pos[i][1], flower_pos[i][2], a[i] + 45*j)
                        end
                    end
                end
            end)
        end
        function f3_2(x, y, a)
            local obj = stg.newBulletStraight(stg.ball_light, 3, true, x, y, 0, a, true)
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            obj.undestoryable = true --真正不可消除
            obj.hscale, obj.vscale = 0, 0.35
            obj.a, obj.b = 0, 0.35*obj.b
            obj.bound = false
            obj.hide = true
            obj.colli = false
            task.New(obj, function()
                --laser_eff(x, y, a, 255, 0, 255)
                --task.Wait(30)
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
            end)
        end
        --伸展开的预警
        function f3_1(x, y, a)
            local obj = laser_eff(x, y, a, 255, 0, 255)
        end
    end
    --boss对自机无敌减伤
    New(tasker, function()
        while IsValid(self) do
            self.dmgrate = min(self.dmgrate + 0.01, 1)
            if IsValid(player) and player.protect > 0 then
                self.dmgrate = 0.5
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
        local a, da, rate = 0, 5, 1.75
        task.New(self, function()
            task.Wait(240) --每15s变一次速
            rate = 2
            pinkeff(self.x, self.y)
            task.Wait(540)
            pinkeff(self.x, self.y)
            s6_boss.changeSpeed(1.25, true, true)
            task.Wait(240) --每15s变一次速
            rate = 2.15
            task.Wait(540)
            pinkeff(self.x, self.y)
            s6_boss.changeSpeed(1.35, true, true)
            task.Wait(240) --每15s变一次速
            rate = 2.3
            task.Wait(540)
            pinkeff(self.x, self.y)
            s6_boss.changeSpeed(1.45, true, true)
            task.Wait(240) --每15s变一次速
            rate = 2.45
            task.Wait(540)
            pinkeff(self.x, self.y)
            s6_boss.changeSpeed(1.6, true, true)
            task.Wait(240)
            rate = 2.6
            task.Wait(540)
            pinkeff(self.x, self.y)
            s6_boss.changeSpeed(1.75, true, true)
            task.Wait(240)
            rate = 2.75
            task.Wait(540)
            pinkeff(self.x, self.y)
            s6_boss.changeSpeed(2, true, true)
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
            for k = 1, 30 do
                for i = 1, 5 do
                    if i ~= 3 then
                        for j = 1, 6 do
                            for u = -1, 1, 2 do
                                f2(flower_pos[i][1], flower_pos[i][2], 0.75 + 0.09*k, ang[i] + (18 - 0.6*k)*u + 60*j)
                            end
                        end
                    end
                end
                PlaySound("kira00")
                task.Wait(3)
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
                    for k = 0, 10 do
                        for j = 0, 5 do
                            stg.newBulletStraight(stg.ball_mid_c, 3, true, flower_pos[i][1], flower_pos[i][2], 1 + 0.1*k, ang[i] + 60*j + 15*k*u)
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
            for k = 0, 6 do
                for i = 1, 5 do
                    if i ~= 3 then
                        for j = 0, 15 do
                            _object.set_color(stg.newBulletStraight(stg.ball_light, 3, true, flower_pos[i][1], flower_pos[i][2], 1 + 0.175*k, ang[i] + 22.5*j), "mul+add", 255, 255, 255, 255)
                        end
                    end
                end
                PlaySound("kira00")
                task.Wait(5)
            end
            task.Wait(360)
            while true do
                f3()
                task.Wait(180)
            end
        end)
        pinkeff(flower_pos[3][1], flower_pos[3][2], 60)
        while true do
            for i = 0, 3 do
                for u = -1, 1, 2 do
                    f1(flower_pos[3][1], flower_pos[3][2], a + 90*u, 3 + 2*u, -7.5*(i-2), -5*i, 1.25*rate)
                end
                PlaySound("tan00")
                task.Wait(5)
                a = a + da
            end
        end
    end
end
table.insert(scs, {boss_sc6, boss_sc6_normal_show, boss_sc6_scpr_show})

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
    stage6boss = create_boss_class("stage6boss:Hard", "Hard")
    local card_info = {
        {"常规攻击1", {2, 6, 40}, 900, {0,0,0}, "normal", false},
        {"时魔法「湛樱花海」",{30, 30, 30}, 1000, {10, 20, 30}, "spellcard", false},
        {"常规攻击2", {2, 10, 40}, 1200, {0,0,0}, "normal", false},
        {"大水魔法「龙之涌动的珍珠泉」",{2, 8, 60}, 2000, {10, 20, 30}, "spellcard", false},
        {"常规攻击3", {2, 5, 40}, 1800, {0,0,0}, "normal", false},
        {"灵符「生命力波动」",{5, 5, 40}, 2500, {10, 20, 30}, "spellcard", false},
        {"常规攻击4", {2, 4, 40}, 2000, {0,0,0}, "normal", false},
        {"炎花「澎湃的浅间信仰」",{3, 5, 60}, 2500, {10, 20, 30}, "spellcard", false},
        {"酒符「梅宫大社的天甜酒」",{2, 6, 60}, 2400, {10, 20, 30}, "spellcard", false},
        {"「从三位之神阶」",{5, 20, 120}, 5000, {0,0,0}, "spellcard", false}
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
    --后两个符
    for i = 5, 6 do
        info = card_info[4 + i]
        table.insert(stage6boss.cards, create_normal_show_class(i, info[5]))
        table.insert(stage6boss.cards, create_card_class(i, info[1], info[2], info[3], info[4], info[5], info[6]))
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
    --[[_sc = stage6boss.cards[n+16] --定位到四符，击破后光闭光背
    function _sc:del()
        s6_boss.back_light.disAppear(self.back_light) --关掉光背
        self._wisys:setAction("normal")
        s6_boss.recoverSpeed()
        scbkeff(self.x, self.y)
    end]]
    _sc = stage6boss.cards[n+20]  --定位到终符，不需要爆炸效果，爆炸效果额外弄
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
_editor_class["stage6boss:Hard"] = stage6boss

--符卡练习boss定义
local stage6bossScpr
do
    stage6bossScpr = create_boss_class("stage6bossScpr:Hard", "Hard")
    local card_info = {
        {"常规攻击1", {2, 6, 40}, 900, {0,0,0}, "normal", false},
        {"时魔法「湛樱花海」",{30, 30, 30}, 1000, {10, 20, 30}, "spellcard", false},
        {"常规攻击2", {2, 6, 40}, 1200, {0,0,0}, "normal", false},
        {"大水魔法「龙之涌动的珍珠泉」",{2, 8, 60}, 2000, {10, 20, 30}, "spellcard", false},
        {"常规攻击3", {2, 10, 40}, 1800, {0,0,0}, "normal", false},
        {"灵符「生命力波动」",{5, 5, 40}, 2500, {10, 20, 30}, "spellcard", false},
        {"常规攻击4", {2, 4, 40}, 2000, {0,0,0}, "normal", false},
        {"炎花「澎湃的浅间信仰」",{3, 5, 60}, 2500, {10, 20, 30}, "spellcard", false},
        {"酒符「梅宫大社的天甜酒」",{2, 6, 60}, 2400, {10, 20, 30}, "spellcard", false},
        {"「从三位之神阶」",{5, 20, 120}, 5000, {0,0,0}, "spellcard", false}
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
    --后两个符
    for i = 5, 6 do
        info = card_info[4 + i]
        table.insert(stage6bossScpr.cards, create_scpr_show_class(i, info[5]))
        table.insert(stage6bossScpr.cards, create_cardpr_class(i, info[1], info[2], info[3], info[4], info[5], stage6bossScpr))
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
    --[[_sc = stage6bossScpr.cards[n+16] --定位到四符，击破后光闭光背
    function _sc:del()
        self._wisys:setAction("normal")
        s6_boss.recoverSpeed()
        scbkeff(self.x, self.y)
    end]]
    _sc = stage6bossScpr.cards[n+20]  --定位到终符，不需要爆炸效果，爆炸效果额外弄
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
_editor_class["stage6bossScpr:Hard"] = stage6bossScpr

--准备挪给ex
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
        --[[符卡开启10s后若玩家miss则减少大量符卡持续时间
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
                local r, a, da = 0, 0, 0.5
                for _ = 1, 600 do
                    r = r + 0.05
                    a = a + da
                    dx, dy = r*(cos(a) - cos(a-1)), r*(sin(a) - sin(a-1))
                    task.Wait(1)
                end
                for _ = 1, 1200 do
                    r = r + 0.05
                    da = da + 0.0005
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
                    --player.x, player.y = player.x + dx, player.y + dy
                    task.Wait(1)
                end
            end)
        end
    end
end
table.insert(scs, {boss_sc5, boss_sc5_normal_show, boss_sc5_scpr_show})]]

--五符废案2
--[[
local function boss_sc5_normal_show(self)
    s6_boss.back_light.disAppear(self.back_light) --关掉光背
    task.Wait(30)
    task.MoveTo(0, 100, 60, MOVE_NORMAL)
    task.Wait(30)
end
local function boss_sc5_scpr_show(self)
    boss_scpr_show(self, 0, 100)
end
local function boss_sc5(self)
    local ymin, ymax = 30, 224
    local f1, f1_1, f1_2, f1_3, f2, f2_1, f3, f3_1, f4, f4_1
    do
        --左右一般通过倒酒的妖精
        function f1(n, u)
            local dy = (ymin - ymax)/(n-1)
            local dx = 20
            for i = 0, n - 1 do
                pinkeff(-192*u, ymax + dy*i, 0)
                task.Wait(10)
            end
            task.Wait(40)
            for i = 0, n - 1 do
                f1_1(-(224 + dx)*u, ymax + dy*i, u)
                task.Wait(30)
            end
        end
        function f1_1(x, y, u)
            local obj = New(fairy5, x, y)
            _connect(self, obj, 0, true)
            f1_2(x, y, obj, u) --产生酒
            --移动
            task.New(obj, function()
                SetV(obj, 2, -90 + 60*u)
                egg.AddSimStrChV(obj, 0, 2.25, -90 + 150*u, 180)
                if u == 1 then
                    while (obj.x - player.x) < -20 or obj.y < player.y do
                        task.Wait(1)
                    end
                    obj.release = true
                else
                    while (obj.x - player.x) > 20 or obj.y < player.y  do
                        task.Wait(1)
                    end
                    obj.release = true
                end
                PlaySound("kira00")
                f2(obj.x, obj.y)
                --释放完后溜得更快
                egg.AddSimStrChV(obj, 0, 1.75, -90 + 150*u, 90)
            end)
        end
        --酒罐
        function f1_2(x, y, mst, u)
            local obj = New(wine, x, y)
            obj.vscale = obj.vscale*u
            obj.rot = -15*u --稍微倾斜
            obj.bound = false
            --wine.open(obj) --这个是已经开盖的了
            obj.rate = 90 --开盖了
            --跟随主人 + 发弹
            task.New(obj, function()
                local t, a = 0
                while IsValid(mst) and not mst.release do
                    obj.x, obj.y = mst.x, mst.y - 35
                    if t%7 == 0 then
                        a = Angle(0, 0, mst.vx, mst.vy) + 180
                        for i = -1, 1 do
                            f1_3(obj.x, obj.y + 25, a + 75*i + ran:Float(-2, 2))
                        end
                        PlaySound("tan00")
                    end
                    task.Wait(1)
                    t = t + 1
                end
                --被释放
                obj.vx, obj.vy = obj.dx, obj.dy
                egg.AddSimStrChV(obj, 0, 3, -90, 60)
                while obj.y > -224 and obj.x < 192 and obj.x > -192 do
                    if t%7 == 0 then
                        a = Angle(0, 0, obj.vx, obj.vy) + 180
                        for i = -1, 1 do
                            f1_3(obj.x, obj.y + 25, a + 75*i + ran:Float(-2, 2))
                        end
                        PlaySound("tan00")
                    end
                    task.Wait(1)
                    t = t + 1
                end
                PlaySound("enep00")
                f4(obj.x, obj.y, a - 30*u)
                Del(obj)
            end)
        end
        --酒弹幕
        function f1_3(x, y, a)
            local obj = stg.newBulletStraight(stg.water_drop, 14, true, x, y, 0, a)
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            obj.navi = true
            obj.hscale, obj.vscale = 0.75, 0.75
            obj.a, obj.b = obj.a*obj.hscale, obj.b*obj.vscale
            egg.AddSimStrChV(obj, 0, 1.15 + ran:Float(-0.15, 0.15), a, 90)
        end

        --一圈炎弹
        function f2(x, y)
            local a = ran:Float(0, 360)
            for i = 1, 24 do
                f2_1(x, y, 1, a + 15*i, 3)
            end
            for i = 1, 16 do
                f2_1(x, y, 1.25, a + 22.5*i, 5)
            end
        end
        function f2_1(x, y, v, a, co)
            local obj = stg.newBulletStraight(stg.water_drop, co, true, x, y, 0, a)
            obj.hscale, obj.vscale = 0.75, 0.75
            obj.a, obj.b = obj.a*obj.hscale, obj.b*obj.vscale
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            egg.AddSimStrChV(obj, 0, v, a, 120)
            egg.AddAccDecChV(obj, 0.5, a, 20, 20, 20)
        end

        --藏妖精的酒罐
        function f3(x, y)
            local obj = New(wine, x, y)
            obj.rot = 0 --稍微倾斜
            obj.bound = false
            --wine.open(obj) --这个是已经开盖的了
            --生成主人
            task.New(obj, function()
                --从顶上出现的酒罐子
                egg.AddAccDecChV(obj, 3, -90, 20, 20, 20)
                task.Wait(60)
                wine.open(obj) --这个是已经开盖的了
                pinkeff(obj.x, obj.y)
                task.Wait(30)
                local mst = f3_1(obj.x, obj.y)
                local t, a = 0
                task.Wait(60)
                while IsValid(mst) and not mst.release do
                    obj.x, obj.y = mst.x, mst.y - 35
                    if t%7 == 0 then
                        a = Angle(0, 0, mst.vx, mst.vy) + 180
                        for i = -1, 1 do
                            f1_3(obj.x, obj.y + 25, a + 75*i + ran:Float(-2, 2))
                        end
                        PlaySound("tan00")
                    end
                    task.Wait(1)
                    t = t + 1
                end
                --被释放
                obj.vx, obj.vy = obj.dx, obj.dy
                egg.AddSimStrChV(obj, 0, 3, -90, 60)
                while obj.y > -224 and obj.x < 192 and obj.x > -192 do
                    if t%5 == 0 then
                        a = Angle(0, 0, obj.vx, obj.vy) + 180
                        for i = -1, 1 do
                            f1_3(obj.x, obj.y + 25, a + 75*i + ran:Float(-2, 2))
                        end
                        PlaySound("tan00")
                    end
                    task.Wait(1)
                    t = t + 1
                end
                PlaySound("enep00")
                f4(obj.x, obj.y, a)
                Del(obj)
            end)
        end
        --藏酒罐里妖精
        function f3_1(x, y)
            local obj = New(fairy5, x, y)
            _connect(self, obj, 0, true)
            obj.hscale, obj.vscale = 0, 0
            obj.colli = false
            obj.dye_range = 0
            --移动
            task.New(obj, function()
                egg.SimAlpCh(obj, 0, 255, 60, true)
                egg.SimSizeCh(obj, 0, 1, 60)
                task.MoveTo(obj.x, obj.y + 35, 60, MOVE_ACC_DEC)
                task.Wait(60)
                local u = -sign(obj.x - player.x) --往自机方向靠
                egg.AddSimStrChV(obj, 0, 2, -90 + 60*u, 45)
                egg.AddSimStrChV(obj, 0, 2.25, -90 + 150*u, 180, 45)
                if u == 1 then
                    while (obj.x - player.x) < 30 or obj.y < player.y do
                        task.Wait(1)
                    end
                    obj.release = true
                else
                    while (obj.x - player.x) > -30 or obj.y < player.y  do
                        task.Wait(1)
                    end
                    obj.release = true
                end
                PlaySound("kira00")
                f2(obj.x, obj.y)
                --释放完后溜得更快
                egg.AddSimStrChV(obj, 0, 1.75, -90 + 150*u, 90)
            end)
            --染色圈变化
            task.New(obj, function()
                task.Wait(60)
                for i = 1, 30 do
                    obj.dye_range = 60*sin(3*i)
                    task.Wait(1)
                end
            end)
            return obj
        end

        --酒罐砸地上
        function f4(x, y, a)
            for _ = 1, 40 do
                f4_1(x, y, ran:Float(0.5, 3), a + ran:Float(-30, 30), 13)
            end
        end
        --酒罐的炎弹
        function f4_1(x, y, v, a, co)
            local obj = stg.newBulletStraight(stg.water_drop, co, true, x, y, 0, a)
            obj.navi = true
            obj.hscale, obj.vscale = 0.75, 0.75
            obj.a, obj.b = obj.a*obj.hscale, obj.b*obj.vscale
            _object.set_color(obj, "", 255, 255, 255, 255)
            egg.AddSimStrChV(obj, 0.25 + ran:Float(0, 5), v, a, 90)
            egg.AddSimStrChV(obj, 0, 1.5 + ran:Float(-0.3, 0.3), -90, 150, 60)
        end
    end

    do
        self.x, self.y = 0, 100
        s6_boss.pic_show()
        task.Wait(90)
        local u = 1
        while true do
            f1(4, u)
            task.Wait(90)
            f1(4, -u)
            task.Wait(60)
            pinkeff(self.x, self.y, 0)
            for i = 0, 1 do
                for u = -1, 1, 2 do
                    f3((120 + 30*i)*u, 224 + 45*i)
                end
            end
            task.Wait(300)
            u = -u
        end

    end
end
table.insert(scs, {boss_sc5, boss_sc5_normal_show, boss_sc5_scpr_show})]]
