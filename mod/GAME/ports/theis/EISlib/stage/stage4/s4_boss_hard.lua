
local path = ""

--四boss蓄力特效
local eff, dark_eff, bkeff, laser_eff, dark_bkeff = s4_boss.eff, s4_boss.dark_eff, s4_boss.bkeff, s4_boss.laser_eff, s4_boss.dark_bkeff
--四boss默认的随机x朝向自机移动函数
local function move_rd(t, y0, dy)
    y0 = y0 or 75
    dy = dy or 25
    task.MoveToPlayer(t or 60, -40, 40, y0 - dy, y0 + dy, 10, 20, 10, 20, MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER)
end
--泡泡弹幕定义
local bubble, bubble2, bubble_dark, bubble_dark2, bubble_dark3 = s4_boss.bubble, s4_boss.bubble2, s4_boss.bubble_dark, s4_boss.bubble_dark2, s4_boss.bubble_dark3


local atks, scs = {}, {}  --存放非符和符卡函数的表
--开幕演出(
local function boss_first_hide(self)
    self.y = 384
    boss:show_aura(false)
    self.bg.open = false
    self.hide = true
    _object.set_color(self, "", 0, 255, 255, 255)
    self.colli = false
end
local function boss_show(self, x, y)
    self.y = 384
    boss:show_aura(false)
    self.bg.open = false
    self.hide = true
    _object.set_color(self, "", 0, 255, 255, 255)
    self.colli = false
    x, y = x or 0, y or 90
    for _ = 1, 3 do
        dark_eff(x, y, 20)
    end
    self.hide = false
    self.y = 90
    egg.SimAlpCh(self, 0, 255, 60)
    self:flash(x, y)
end
--一非
local function boss_atk1_normal_show(self)
    if EISlib.stage.canDialog() then
        -- 预先设置
        boss_first_hide(self)
        -- 第一段对话
        dialog.player.playScene("Stage4")
        dialog.player.waitSignal("boss fly in", dialog.enum.on)
        -- 出场
        boss_show(self)
        -- 第二段对话
        dialog.player.setSignal("boss fly in complete", dialog.enum.on)
        dialog.player.waitSignal("fade out BGM", dialog.enum.on)
        EISlib.stage.musicFadeOut("s4", 120)
        dialog.player.waitSignal("play BGM", dialog.enum.on)
        LoadMusicRecord("s4_boss")
        EISlib.stage.playMusic("s4_boss", 0, true)
        dialog.player.waitUntilFinish()
        boss.show_aura(self, true)
    else
        -- 预先设置
        boss_first_hide(self)
        -- 出场
        boss_show(self)
        -- BGM
        EISlib.stage.musicFadeOut("s4", 120)
        LoadMusicRecord("s4_boss")
        EISlib.stage.playMusic("s4_boss", 0, true)
        -- 开打
        task.Wait(60)
        boss.show_aura(self, true)
    end
end
local function boss_atk1_scpr_show(self)
    boss_show(self)
    boss.show_aura(self, true)
end
local function boss_atk1(self)
    self.bg.open = false
    local f1, f1_1
    do
        function f1(x, y, u, Isdangerous, even)
            PlaySound("cancel00")
            local obj = bubble_dark2(x, y, 0.35)
            Isdangerous = true
            task.New(obj, function()
                task.Wait(20)
                egg.AddAccDecChV(obj, 2, 90*(1-u), 10, 40, 30)
                task.Wait(30)
                egg.AddSimStrChV(obj, 0, 3, 90, 90)
            end)
            task.New(obj, function()
                while obj.y < 224 do
                    task.Wait(1)
                end
                PlaySound("tan00")
                local a, dsp = Angle(obj, player), 7.5
                if even then
                    dsp = 0.5*dsp
                    if Isdangerous then
                        PlaySound("kira00")
                        for i = -15, 15, 2 do
                            laser_eff(obj.x, obj.y, a + dsp*i)
                        end
                    end
                    for i = -15, 15, 2 do
                        for j = 0, 4 do
                            f1_1(obj.x, obj.y, 0.5*j, a + dsp*i, 1+0.05*j)
                        end
                    end
                else
                    if Isdangerous then
                        PlaySound("kira00")
                        for i = -7, 7 do
                            laser_eff(obj.x, obj.y, a + dsp*i)
                        end
                    end
                    for i = -7, 7 do
                        for j = 0, 4 do
                            f1_1(obj.x, obj.y, 0.5*j, a + dsp*i, 1+0.05*j)
                        end
                    end
                end
            end)
        end
        function f1_1(x, y, v, a, s, u)
            u = u or 0
            local obj = New(straight, ball_mid_c, 3, true, x, y, 0, a)
            _object.set_color(obj, "", 255, 255, 255, 255)
            obj.hscale, obj.vscale = s, s
            obj.a, obj.b = obj.a*obj.hscale, obj.b*obj.vscale
            egg.AddSimStrChV(obj, 0, 3.5, a, 30)
            egg.AddSimStrChV(obj, 0, v, a + 10*u, 30, 30)
        end
    end

    do
        self.x, self.y = 0, 90 --测试用
        dark_eff(self.x, self.y, 60)
        self:cast(60)
        for u = -1, 1, 2 do
            f1(self.x - 15, self.y + 15, u, true)
        end
        task.Wait(60)
        move_rd(60, 90, 10)
        task.Wait(90)
        local a = Angle(self, player)
        for i = 0, 49 do
            laser_eff(self.x, self.y, a + 7.2*i)
            for j = 1, 7 do
                f1_1(self.x, self.y, 0.5*j, a + 7.2*i, 1+0.05*j)
            end
        end
        while true do
            move_rd(30, 90, 10)
            self:cast(180)
            local u = 1
            PlaySound("tan00")
            for _ = 1, 6 do
                f1(self.x - 15, self.y + 15, u)
                move_rd(30, 90, 10)
                u = -u
            end
            for u = -1, 1, 2 do
                f1(self.x - 15, self.y + 15, u, true, true)
            end
            task.Wait(90)
            move_rd(60, 90, 10)
            local dx, px = 0, player.x
            for _ = 1, 90 do  --根据自机走的方向来决定最后一波搞人的方向
                dx = dx + (player.x - px)
                px = player.x
                task.Wait(1)
            end
            u = -u
            PlaySound("tan00")
            for i = 0, 35 do
                --laser_eff(self.x, self.y, a + 8*i)
                for j = 1, 7 do
                    f1_1(self.x, self.y, 0.5*j, a + 10*i, 1+0.05*j, sign(dx))
                end
            end
        end
    end

end
table.insert(atks, {boss_atk1, boss_atk1_normal_show, boss_atk1_scpr_show})
--二非
local function boss_atk2_normal_show(self)
    task.Wait(60)
    self:flash(0, 120)
end
local function boss_atk2_scpr_show(self)
    boss_show(self, 0, 120)
    boss.show_aura(self, true)
end
local function boss_atk2(self)
    self.bg.open = false
    local f1, f2
    do
        function f1(x, y, a0, a1)
            local obj = bubble_dark3(x, y, 0.35)
            task.New(obj, function()
                egg.AddAccDecChV(obj, 2.7, a0, 5, 7, 12)
                egg.AddSimStrChV(obj, 0, 5.4, a1, 120, 25)
                task.Wait(95)
                egg.AddAccDecChV(obj, -3.6, a1, 30, 20, 180)
            end)
        end
        function f2(x, y, v, a)
            local obj = bubble_dark3(x, y, 0.35)
            task.New(obj, function()
                egg.AddSimStrChV(obj, 0, 5, a, 120)
                egg.AddSimStrChV(obj, 0, v-5, a, 30, 90)
            end)
        end
    end

    do
        dark_eff(self.x, self.y, 60)
        --self.x, self.y = 0, 120
        --视觉欺诈弹幕
        local a, da, a0, r, dr, dx, dy, v, dv
        while true do
            for u = -1, 1, 2 do
                a, da = 90*(u+1), 9*u
                for _ = 1, 18 do
                    for i = 1, 8 do
                        a0 = a + 45*i
                        f1(self.x, self.y, a0, a0 - 30)
                        f1(self.x, self.y, a0, a0 + 30)
                    end
                    task.Wait(3)
                    PlaySound("tan00")
                    a = a + da
                end
                move_rd(30, 120, 20)
            end
            task.Wait(30)
            for j = 1, 3 do
                r, dr = -60, 60/5
                v, dv = 2.5, 0.2
                --结果是简单的交叉弹
                for _ = 1, 5 do
                    for i = 1, 16 do
                        a0 = a + 22.5*i + 7*j
                        dx, dy = r*cos(a0), r*sin(a0)
                        f2(self.x + dx, self.y + dy, v, a0 - 27)
                        f2(self.x + dx, self.y + dy, v, a0 + 27)
                    end
                    PlaySound("tan00")
                    task.Wait(7)
                    --a = a + da
                    v = v + dv
                    r = r + dr
                end
            end
            do
                r, dr = -60, 60/5
                v, dv = 2.5, 0.15
                --结果是简单的交叉弹
                for _ = 1, 5 do
                    for i = 1, 16 do
                        a0 = a + 22.5*i + 7
                        dx, dy = r*cos(a0), r*sin(a0)
                        f2(self.x + dx, self.y + dy, v, a0 - 36)
                        f2(self.x + dx, self.y + dy, v, a0 + 36)
                    end
                    PlaySound("cancel00")
                    task.Wait(7)
                    v = v + dv
                    r = r + dr
                end
            end
        end
    end
end
table.insert(atks, {boss_atk2, boss_atk2_normal_show, boss_atk2_scpr_show})
--三非
local function boss_atk3_normal_show(self)
    task.Wait(60)
    self:flash(0, 144)
    self.group = GROUP_ENEMY
end
local function boss_atk3_scpr_show(self)
    boss_show(self, 0, 144)
    boss.show_aura(self, true)
end
local function boss_atk3(self)
    self.bg.open = false
    local f1, f1_1, f1_2, f2
    do
        function f1(x, y, a, u)
            local obj = bubble_dark2(x, y, 0.35)
            task.New(obj, function()
                task.Wait(20)
                egg.AddAccDecChV(obj, 2, a, 10, 20, 20)
                task.Wait(30)
                egg.AddCirMove(obj, a, 0.25*u, u, 0, 300, 120, 120, 60)
            end)
            task.New(obj, function()
                task.Wait(90)
                local a
                for i = 1, 25 do
                    a = Angle(obj.vx, obj.vy, 0, 0)
                    for u = -1, 1, 2 do
                        f1_1(obj.x, obj.y, a + (10 + 0.5*i)*u)
                    end
                    f1_2(obj.x, obj.y, a + 180 + ran:Float(-20, 20))
                    task.Wait(3)
                    PlaySound("kira00")
                end
                for i = 1, 20 do
                    a = Angle(0, 0, obj.vx, obj.vy)
                    for u = -1, 1, 2 do
                        f1_1(obj.x, obj.y, a + (10 + 0.5*i)*u)
                    end
                    f1_2(obj.x, obj.y, a + 180 + ran:Float(-20, 20))
                    task.Wait(3)
                    PlaySound("kira00")
                end
            end)
        end
        function f1_1(x, y, a)
            local obj = New(straight, grain_c, 3, true, x, y, 0, a)
            egg.AddSimStrChV(obj, 0, 1.75, a, 60)
        end
        function f1_2(x, y, a)
            local obj = stg.newBulletStraight(stg.ball_mid_c, 10, true, x, y, 0, a)
            _object.set_color(obj, "mul+rev", 255, 255, 255, 255)
            egg.AddSimStrChV(obj, 0, 2.5, a, 90)
            egg.AddSimStrChV(obj, 0, 5, 90, 90, 75)
        end
        --直线泡泡
        function f2(x, y, v, a)
            local obj = bubble_dark(x, y, 0.25)
            egg.AddSimStrChV(obj, 5, v, a, 20)
        end
    end

    do
        --self.x, self.y = 0, 144
        dark_eff(self.x, self.y, 60)
        local u = 1
        local a, da, v, layer, dsp
        dsp =  15
        layer = 1
        while true do
            for _ = 1, 2 do
                self:cast(90)
                a, da = 90, -120/5*u
                for _ = 1, 6 do
                    f1(self.x - 15, self.y + 15, a, -u)
                    PlaySound("cancel00")
                    task.Wait(15)
                    a = a + da
                end
                u = -u
                move_rd(30, 144, 10)
                do
                    v = 1.75
                    for j = layer, 1, -1 do
                        a = Angle(self, player) - 0.5*(3 + j)*dsp
                        for _ = 1, 4 + j do
                            f2(self.x, self.y, v, a)
                            a = a + dsp
                        end
                        v = v + 0.3
                    end
                    PlaySound("tan00")
                    layer = min(3, layer + 1)
                end
                task.Wait(30)
            end
        end
    end

end
table.insert(atks, {boss_atk3, boss_atk3_normal_show, boss_atk3_scpr_show})
--四非
local function boss_atk4_normal_show(self)
    task.Wait(60)
    self:flash(0, 120)
end
local function boss_atk4_scpr_show(self)
    boss_show(self, 0, 120)
    boss.show_aura(self, true)
end
local function boss_atk4(self)
    local co = {2, 14, 12, 10, 8, 6, 4} --颜色表
    self.bg.open = false
    local f1, f1_1, f2, f3, f4, f5
    do
        --发分段弹幕的泡泡
        function f1(x, y, a, u)
            local obj = bubble_dark2(x, y, 0.35)
            PlaySound("cancel00")
            task.New(obj, function()
                egg.AddAccDecChV(obj, 2, a, 30, 30, 30)
                task.Wait(40)
                egg.AddCirMove(obj, a, 0.25*u, u, 0, 150, 60, 60, 60)
            end)
            task.New(obj, function()
                task.Wait(60)
                local a
                a = Angle(obj, self)
                for i = -3, 3 do
                    _object.set_color(New(straight, ball_mid_c, 5, true, obj.x, obj.y, 2.5, a + 15*i), "", 255, 255, 255, 255)
                end
                task.Wait(30)
                for _ = 1, 3 do
                    for i = 1, 12 do
                        for j = -1, 1 do
                            a = Angle(0, 0, obj.vx, obj.vy) - 90*u + 22.5*j
                            f1_1(obj.x, obj.y, 0.075*i, a)
                        end
                        task.Wait(1)
                        PlaySound("tan00")
                    end
                end
                task.Wait(60)
                local a = Angle(0, 0, obj.vx, obj.vy)
                for i = -3, 3 do
                    _object.set_color(New(straight, ball_mid_c, 5, true, obj.x, obj.y, 2.5, a + 15*i), "", 255, 255, 255, 255)
                end
                Del(obj)
            end)
        end
        function f1_1(x, y, v, a)
            local obj = New(straight, grain_c, 3, true, x, y, 0, a)
            _object.set_color(obj, "", 255, 255, 255, 255)
            task.New(obj, function()
                egg.AddSimStrChV(obj, 0, 1.75, a, 60)
                task.Wait(60)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, v, a, 30)
            end)
        end
        --发正常弹幕的泡泡
        function f2(x, y, a, u)
            local obj = bubble_dark2(x, y, 0.35)
            PlaySound("cancel00")
            task.New(obj, function()
                egg.AddAccDecChV(obj, 2, a, 30, 30, 30)
                task.Wait(40)
                egg.AddCirMove(obj, a, 0.25*u, u, 0, 150, 60, 60, 60)
            end)
            task.New(obj, function()
                task.Wait(60)
                local a
                a = Angle(obj, self)
                for i = -3, 3 do
                    _object.set_color(New(straight, ball_mid_c, 5, true, obj.x, obj.y, 2.5, a + 15*i), "", 255, 255, 255, 255)
                end
                task.Wait(30)
                for _ = 1, 3 do
                    for _ = 1, 12 do
                        for j = -1, 1 do
                            a = Angle(0, 0, obj.vx, obj.vy) - 90*u + 22.5*j
                            f1_1(obj.x, obj.y, 0.75, a)
                        end
                        task.Wait(1)
                        PlaySound("tan00")
                    end
                end
                task.Wait(60)
                local a = Angle(0, 0, obj.vx, obj.vy)
                for i = -3, 3 do
                    _object.set_color(New(straight, ball_mid_c, 5, true, obj.x, obj.y, 2.5, a + 15*i), "", 255, 255, 255, 255)
                end
                Del(obj)
            end)
        end
        function f3(x, y, v, a)
            local obj = New(straight, grain_c, 3, true, x, y, 0, a)
            _object.set_color(obj, "", 255, 255, 255, 255)
            egg.AddSimStrChV(obj, 0, v, a, 60)
        end
        --直线泡泡
        function f4(x, y, v, a)
            local obj = bubble_dark(x, y, 0.25)
            egg.AddSimStrChV(obj, 5, v, a, 20)
        end
        --保护弹幕
        function f5()
            local a0, a, dx, dy = ran:Float(-1, 1)
            for i = -12, 12 do
                a = a0 + 90 + 8*i
                dx, dy = cos(a), sin(a)
                for j = 1, 7 do
                    stg.newBulletStraight(stg.arrow_big, co[j], true, self.x - 100*dx, self.y - 100*dy, 3 + 0.25*j, a)
                end
            end
            PlaySound("kira00")
        end
    end

    --主体攻击
    do
        --self.x, self.y = 0, 120 --测试用
        dark_eff(self.x, self.y, 60)
        self:cast(60)
        local u, a, da = 1
        while true do
            for _ = 1, 2 do
                a, da = 90*(1+u), 210/5*u
                for _ = 1, 6 do
                    f2(self.x - 15, self.y + 15, a, u)
                    a = a + da
                end
                u = -u
                task.Wait(60)
                f5()
                move_rd(30, 120, 10)
            end
            dark_eff(self.x, self.y, 60) --蓄力警告，第三波开始有所不同
            for _ = 1, 2 do
                a, da = 90*(1+u), 210/5*u
                for _ = 1, 6 do
                    f1(self.x - 15, self.y + 15, a, u)
                    a = a + da
                end
                u = -u
                task.Wait(60)
                f5()
                move_rd(30, 120, 10)
            end
            task.Wait(90)
            dark_eff(self.x, self.y, 60)  --蓄力警告，要一大波弹幕攻击了
            for k = 1, 12 do
                for i = 1, 10 do
                    for j = 0, 1 do
                        f3(self.x, self.y, 2 + 1*j + 0.012*k, a + 36*i + 1.25*k + 7.5*j)
                    end
                end
                task.Wait(3)
            end
            task.Wait(60)
            do
                local dsp, v = 9, 1
                local a0 = Angle(self, player)
                for i = 1, 6 do --6way
                    v = 1.75
                    for j = 5, 1, -1 do --5层
                        a = a0 - 0.5*(0 + j)*dsp + 60*i
                        for _ = 1, 1 + j do
                            f4(self.x, self.y, v, a)
                            a = a + dsp
                        end
                        v = v + 0.3
                    end
                end
                PlaySound("cancel00")
            end
            move_rd(30, 120, 10)
        end
    end
end
table.insert(atks, {boss_atk4, boss_atk4_normal_show, boss_atk4_scpr_show})


--一符 影符「天海激流」
local function boss_sc1_normal_show(self)
    self:flash(0, 144)
end
local function boss_sc1_scpr_show(self)
    boss_show(self, 0, 144)
    boss.show_aura(self, true)
end
local function boss_sc1(self)
    self.bg.open = true
    local fog_table = {}
    local co = {1, 13, 11, 9, 7, 5, 3} --颜色表
    local f1, f1_1, f2, f2_1, f2_2, f2_3
    do
        function f1(x, y, a, u, i, times)
            local obj = New(s4_boss.bentlaser, x, y, 32, 16)
            task.New(obj, function()
                egg.AddAccDecChV(obj, 3, a, 10, 20, 15)
                task.Wait(40)
                egg.AddChV(obj, 0, 5, a, 60*u, 40, 40)
            end)
            --处理激光与雾的碰撞
            task.New(obj, function()
                while true do
                    if IsValid(fog_table[i]) then
                        local d = Dist(obj.x, obj.y, x, y)
                        if (fog_table[i].dist - d) < 10 and (fog_table[i].dist - d) > -10 then
                            break
                        end
                    end
                    task.Wait(1)
                end
                --减速
                egg.AddChV(obj, 0, -3, Angle(0, 0, obj.vx, obj.vy), 60*u, 20, 20)
                local x, y, a, j = obj.x, obj.y, Angle(0, 0, obj.vx, obj.vy)
                for _ = 1, times do
                    j = ran:Int(1, 7)
                    f1_1(x, y, co[j], 4 - 0.2*j, a + ran:Float(12*(j-1), 12*(j-1)+12)*u)
                    task.Wait(1)
                end
            end)
        end
        --虹色弹幕
        function f1_1(x, y, co, v, a)
            local obj = New(straight, grain_a, co, true, x, y, 0, a)
            --_object.set_color(obj, "mul+add", 255, 255, 255, 255)
            egg.AddSimStrChV(obj, 0, v, a, 120)
        end
        --装有贝壳的泡泡
        function f2(x, y, a, i)
            local obj = bubble2(x, y, 0.75)
            task.New(obj, function()
                egg.AddAccDecChV(obj, 3, a, 10, 20, 15)
                f2_1(x, y, a, 45, obj, i) --生成贝壳
                task.Wait(45)
                --泡泡爆炸后会生成水滴的
                for i = -2, 2 do
                    f2_2(obj.x, obj.y, 90 + 10*i)
                end
                Del(obj)
            end)
        end
        --吐出蜃气的贝壳
        function f2_1(x, y, a, t, mst, i)
            local obj = New(s4_boss.shell_class, x, y, 35)
            _connect(self, obj, 0, true) --保证符卡击破后即时消除
            obj.dist = 0 --与最初生成位置的距离
            obj.bound = false
            obj.colli = false
            obj.hscale, obj.vscale = 0, 0
            _object.set_color(obj, "", 0, 255, 255, 255)
            task.New(obj, function()
                local ds, d_a = 1/t, 255/t
                for _ = 1, t do
                    if IsValid(mst) then
                        obj.hscale, obj.vscale = obj.hscale + ds, obj.vscale + ds
                        obj._a = obj._a + d_a
                        obj.x, obj.y = mst.x, mst.y
                    else
                        Del(obj)
                        break
                    end
                    task.Wait(1)
                end
                obj.colli = true
                task.Wait(60)
                s4_boss.shell_class.open(obj) --扇贝打开产生雾气
                f2_3(obj, a) --产生雾对象
                task.Wait(40)
                obj.colli = false
                task.Wait(20)
                --s4_boss.shell_class.del(obj) --创建一个自爆的假象
                egg.AddSimStrChV(obj, 0, 2, a, 360) --带着蜃气向外移动
                local d_a = -255/30
                for _ = 1, 30 do
                    obj._a = obj._a + d_a
                    task.Wait(1)
                end
                obj.hide = true --把自己隐藏起来
                --task.Wait(60)
                fog_table[i] = obj --开始处理碰撞
                for _ = 1, 600 do
                    obj.dist = Dist(obj.x, obj.y, x, y)
                    task.Wait(1)
                end
                obj.bound = true
            end)
        end
        --生成的水滴
        function f2_2(x, y, a)
            local obj = New(straight, kite, 8, true, x, y, 2, a)
            obj.ay = -0.025
            obj.navi = true
            task.New(obj,function()
                task.Wait(180)
                obj.ay = 0
            end)
        end
        --生成雾气
        function f2_3(mst, a)
            local obj = New(s4_boss.fog, a)
            obj.hscale, obj.vscale = 0, 0
            _object.set_color(obj, "", 0, 255, 255, 255)
            --跟随主人
            task.New(obj, function()
                while IsValid(mst) do
                    obj.x, obj.y = mst.x, mst.y
                    task.Wait(1)
                end
                task.Clear(obj, true)
                local d_a = -obj._a/30
                for _ = 1, 30 do
                    obj._a = obj._a + d_a
                    task.Wait(1)
                end
                Del(obj)
            end)
            --变化过程
            task.New(obj, function()
                local d_a, ds, dh, dv = 255/60, 0.5/60
                for _ = 1, 60 do
                    obj._a = obj._a + d_a
                    obj.hscale, obj.vscale = obj.hscale + ds, obj.vscale + ds
                    task.Wait(1)
                end
                dh, dv = 0.001, 0.003
                for _ = 1, 120 do
                    obj.hscale, obj.vscale = obj.hscale + dh, obj.vscale + dv
                    task.Wait(1)
                end
                d_a = -255/90
                for _ = 1, 90 do
                    obj._a = obj._a + d_a
                    obj.hscale, obj.vscale = obj.hscale + dh, obj.vscale + dv
                    task.Wait(1)
                end
                Del(obj)
            end)
        end
    end
    --主体攻击
    do
        s4_boss.pic_show()
        task.Wait(90)
        eff(self.x, self.y, 60)
        local u = 1
        while true do
            for _ = 1, 2 do
                PlaySound("cancel00")
                for i = 1, 10 do
                    f2(self.x, self.y, 36*i-18, i)
                end
                task.Wait(180)
                PlaySound("lazer01")
                for i = 1, 10 do
                    --生成相邻两道激光
                    f1(self.x, self.y, 36*i, u, 1+(i + 0.5*(u-1))%10, 30)
                    f1(self.x, self.y, 36*i + 18*u, u, 1+(i + 0.5*(u-1))%10, 30)
                end
                move_rd(60, 144, 10)
                u = -u
            end
            eff(self.x, self.y, 60)
            do
                PlaySound("cancel00")
                for i = 1, 10 do
                    f2(self.x, self.y, 36*i-18, i)
                end
                task.Wait(180)
                PlaySound("lazer01")
                for i = 1, 10 do
                    --生成相邻两道激光
                    for _ = 1, 2 do
                        f1(self.x, self.y, 36*i, u, 1+(i + 0.5*(u-1))%10, 15)
                        f1(self.x, self.y, 36*i + 18*u, u, 1+(i + 0.5*(u-1))%10, 15)
                        u = -u
                    end
                end
                move_rd(60, 144, 10)
            end
            task.Wait(60)
            u = -u
        end
    end
end
table.insert(scs, {boss_sc1, boss_sc1_normal_show, boss_sc1_scpr_show})
--二符 幻符「mayhem assault」
local function boss_sc2_normal_show(self)
    self:flash(0, 144)
end
local function boss_sc2_scpr_show(self)
    boss_show(self, 0, 144)
    boss.show_aura(self, true)
end
local function boss_sc2(self)
    self.bg.open = true
    local f1, f1_1, f2
    do
        --包裹自己的泡泡
        function f1(x, y)
            local obj = bubble2( x, y, 1.25, 40, 30)
            PlaySound("cancel00")
            task.New(obj, function()
                local t, b = 0
                local a = 0
                while t<240 do
                    if IsValid(self) then
                        obj.x, obj.y = obj.x + self.vx, obj.y + self.vy
                        if t%20 == 0 and t > 120 then
                            a = ran:Float(0, 360)
                            for _ = 1, 15 do
                                b = New(straight, kite, 6, true, obj.x + 20*cos(a), obj.y + 30 + 20*sin(a), 1.05 + ran:Float(-0.2, 0.2), a + ran:Float(-2, 2))
                                b.timer = 11
                                b.navi = true
                                b.ay = -0.01
                                egg.SimAlpCh(b, 0, 255, 30, true)
                                a = a + 24
                            end
                        end
                    else
                        _kill(obj)
                    end
                    task.Wait(1)
                    t = t + 1
                end
                --产生大量瀑布弹幕
                task.New(obj, function()
                    local x, y, a = obj.x, obj.y
                    for j = 0, 12 do
                        PlaySound("kira00")
                        for i = 1, 18 do
                            a = 20*i
                            f1_1(x + 50*cos(a), y + 50*sin(a), 1.85 + 0.15*j, a, 60-4*j)
                        end
                        task.Wait(4)
                    end
                end)
                --继续跟随
                for _ = 1, 20 do
                    if IsValid(self) then
                        obj.x, obj.y = obj.x + self.vx, obj.y + self.vy
                    else
                        _kill(obj)
                    end
                    task.Wait(1)
                end
                for _ = 1, 30 do
                    if IsValid(self) then
                        obj.x, obj.y = obj.x + self.vx, obj.y + self.vy
                        obj._a = obj._a - 8
                    else
                        _kill(obj)
                    end
                    task.Wait(1)
                end
                _kill(obj)
            end)
        end
        --泡泡爆裂后出来的弹幕
        function f1_1(x, y, v, a, dt)
            local obj = New(straight, ball_mid, ran:Int(7, 8), true, x, y, v + ran:Float(0, 0.175), a + ran:Float(-7.5, 7.5))
            obj.timer = 11
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET-1
                task.Wait(dt)
                obj.ay = 0.05
                task.Wait(30)
                while obj.y < 224 and obj.x > -192 and obj.x < 192 do
                    task.Wait(1)
                end
                local last = New(straight, grain_b, 5, true, obj.x, obj.y, 0, -90)
                egg.AddSimStrChV(last, 0, ran:Float(2, 2.5), -90, 30)
                last.navi = true
                if obj.y > 224 then
                    last.vx = ran:Float(-0.2, 0.2)
                elseif obj.x < -192 then
                    last.vx = ran:Float(0.8, 1.6)
                elseif obj.x > 192 then
                    last.vx = ran:Float(-0.8, -1.6)
                end
                Del(obj)
            end)
        end
        --两侧的泡泡
        function f2(x, y, da0, u)
            local obj = bubble2( x, y, 0.5, 40, 30)
            obj.group = GROUP_INDES
            egg.AddAccDecChV(obj, 2, -90 + 45*u, 40, 0, 30)
            egg.AddSimStrChV(obj, 0, 0.5, -90 + 45*u, 150)
            task.New(obj, function()
                local t, a, da = 0, 90 + da0*u, 10*u
                while t < 210 do
                    if IsValid(self) then
                        obj.x, obj.y = obj.x + self.vx, obj.y + self.vy
                        if t%10 == 0 and t > 40 then
                            PlaySound("kira00")
                            for i = 1, 11 do
                                New(straight, ball_mid, 8, true, obj.x, obj.y, 1.75 + 0.2*i, a - 4*i*u)
                            end
                            a = a + da
                        end
                    else
                        _kill(obj)
                    end
                    task.Wait(1)
                    t = t + 1
                end
                if IsValid(self) then
                    obj.vx, obj.vy = self.vx, self.vy
                else
                    _kill(obj)
                end
            end)
        end
    end
    --起飞!
    do
        s4_boss.pic_show()
        task.Wait(90)
        while true do
            self.group = GROUP_NONTJT
            local a0 = -30 --使魔丢出小玉的初始角度相关参数
            local x, y, a, da, v = nil, nil, nil, 360/18
            for _ = 1, 1 do
                x, y = max(-144, min(144, player.x)), -144
                eff(x, y, 60)
                self.flash(self, x, y)
                self.cast(self, 180, true)
                task.Wait(90)
                f1(self.x, self.y)
                task.Wait(30)
                f2(self.x, self.y, a0, 1)
                f2(self.x, self.y, a0, -1)
                task.Wait(30)
                egg.AddAccDecChV(self, 2.5, 90, 150, 30, 20)
                task.Wait(240)
                v, a = 2.75, Angle(self, player)
                for _ = 1, 7 do
                    for _ = 1, 18 do
                        New(straight, arrow_small, 6, true, self.x, self.y, v, a)
                        a = a + da
                    end
                    a = a + 1.5
                    v = v + 0.15
                    PlaySound("tan00")
                    task.Wait(4)
                end
            end
            self.group = GROUP_ENEMY
            task.Wait(60)
        end
    end
end
table.insert(scs, {boss_sc2, boss_sc2_normal_show, boss_sc2_scpr_show})
--三符 未定
local function boss_sc3_normal_show(self)
    self:flash(0, 144)
end
local function boss_sc3_scpr_show(self)
    boss_show(self, 0, 144)
    boss.show_aura(self, true)
end
local function boss_sc3(self)
    self.bg.open = true
    local f1, f1_1, f1_2, f1_3, f1_4, f1_5, f1_6, f1_7
    local co = {2, 14, 12, 10, 8, 6, 4} --颜色表
    do
        --装有贝壳的泡泡
        function f1(x, y, x1, y1, v, spawns)
            local obj = bubble2(x, y, 0.75)
            task.New(obj, function()
                f1_1(x, y, 45, obj, v, spawns) --生成贝壳
                task.MoveTo(x1, y1, 45, MOVE_ACC_DEC)
                --[[泡泡爆炸后会生成水滴的
                local a = Angle(obj, player)
                for i = 0, 8 do
                    for j = -2, 2 do
                        f1_2(obj.x, obj.y, 1.75 - 0.05*abs(j), a + 40*i + 0.5*j)
                    end
                end]]
                Del(obj)
            end)
        end
        --吐出蜃气的贝壳
        function f1_1(x, y, t, mst, v, spawns)
            local obj = New(s4_boss.shell_class, x, y, 75)
            _connect(self, obj, 0, true)
            obj.bound = false
            obj.group = GROUP_GHOST
            obj.hscale, obj.vscale = 0, 0
            _object.set_color(obj, "", 0, 255, 255, 255)
            task.New(obj, function()
                local ds, d_a = 1/t, 255/t
                for _ = 1, t do
                    if IsValid(mst) then
                        obj.hscale, obj.vscale = obj.hscale + ds, obj.vscale + ds
                        obj._a = obj._a + d_a
                        obj.x, obj.y = mst.x, mst.y
                    else
                        Del(obj)
                        break
                    end
                    task.Wait(1)
                end
                s4_boss.shell_class.open(obj) --扇贝打开产生雾气
                task.Wait(40)
                f1_3(obj, -90, v, spawns) --产生雾对象
                egg.AddSimStrChV(obj, 0, v, -90, 60) --开始移动
                task.Wait(20)
                s4_boss.shell_class.close(obj) --扇贝关
                obj.bound = false
                for _ = 1, 300 do
                    f1_7(obj.x, obj.y)
                    task.Wait(15)
                end
            end)
        end
        --简单的水滴
        function f1_2(x, y, v, a)
            local obj = stg.newBulletStraight(stg.kite, 6, true, x, y, 0, a)
            egg.AddV1(obj, v, a)
            egg.AddSimStrChV(obj, 0, 2.5, -90, 120)
            obj.navi = true
        end
        --雾气
        function f1_3(mst, a, v, spawns)
            local obj = New(s4_boss.fog, a)
            obj.hscale, obj.vscale = 0, 0
            _object.set_color(obj, "", 0, 255, 255, 255)
            obj.bound = false
            --跟随主人
            obj.x, obj.y = mst.x, mst.y
            --判断是否有贝壳触发了
            local function IsnSpawn()
                local flag = false
                if spawns[1] then flag = true end
                return flag
            end
            task.New(obj, function()
                while IsValid(mst) and (Dist(obj, player) > 40 or IsnSpawn()) do --主人消失或者自机靠太近了就会消失
                    obj.x, obj.y = mst.x, mst.y
                    task.Wait(1)
                end
                PlaySound("kira00")
                if IsValid(mst) then
                    task.New(mst, function()
                        spawns[1] = true
                        task.Clear(mst, true)
                        egg.AddSimStrChV(mst, 0, v, 90, 20)
                        local v = (-50 - obj.y + 10*v)/40 --无论如何，最低也会上升到 y = 0
                        egg.AddAccDecChV(mst, max(1, v), 90, 20, 20, 20)
                        task.Wait(60)
                        s4_boss.shell_class.open(mst) --扇贝打开产生珍珠！
                        PlaySound("kira00")
                        f1_4(mst.x, mst.y, co[ran:Int(1, 7)])--生成惊喜！
                        task.Wait(120)
                        Del(mst)--清除主人对象
                    end)
                end
                task.Clear(obj, true)
                local d_a = -obj._a/60
                for _ = 1, 60 do
                    obj._a = obj._a + d_a
                    task.Wait(1)
                end
                Del(obj)
            end)
            --变化过程
            task.New(obj, function()
                local d_a, ds = 200/60, 0.75/60
                for _ = 1, 60 do
                    obj._a = obj._a + d_a
                    obj.hscale, obj.vscale = obj.hscale + ds, obj.vscale + ds
                    task.Wait(1)
                end
                task.Wait(30)
                egg.SimAlpCh(obj, 200, 0, 60)
                --现在泡泡爆炸后会生成水滴移到这里来了
                PlaySound("kira00")
                local a = 90
                for i = -2, 2 do
                    for j = -1, 1 do
                        f1_2(obj.x, obj.y, ran:Float(1.25, 1.75), a + 30*i + 10*j)
                    end
                end
            end)
        end
        --珍珠
        function f1_4(x, y, co)
            local obj = New(straight, ball_light, co, true, x, y, 0, 0)
            _object.set_color(obj, "mul+add", 0, 255, 255, 255)
            obj.hscale, obj.vscale = 0, 0
            egg.SimSizeCh(obj, 0, 1.5, 60, true)
            egg.SimAlpCh(obj, 0, 255, 60)
            task.New(obj, function()
                task.Wait(120)
                PlaySound("kira00")
                for i = 1, 12 do
                    f1_5(x, y, i*30, co, 120, 10)
                end
                Del(obj)
            end)
        end
        --珍珠分裂出的光玉
        function f1_5(x, y, a, co, sp, way)
            local obj = New(straight, ball_light, co, true, x, y, 0, a)
            obj.hscale, obj.vscale = 0.75, 0.75
            obj.a, obj.b = obj.a*obj.hscale, obj.b*obj.vscale
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            task.New(obj, function()
                egg.AddAccDecChV(obj, 3, a, 20, 0, 30)
                task.Wait(50)
                way = way or 14
                local sp, dsp = -0.5*(sp or 900), (sp or 900)/(way - 1)
                for _ =  1, way do
                    f1_6(obj.x, obj.y, a, sp, co)
                    sp = sp + dsp
                end
                Del(obj)
            end)
        end
        --光玉分裂的小玉
        function f1_6(x, y, a, sp, co)
            local obj = New(straight, ball_mid, co, true, x, y, 0, a)
            task.New(obj, function()
                sp = sp/150
                for _ = 1, 150 do
                    a = a + sp
                    AddV1(obj, 0.015, a)
                    task.Wait(1)
                end
                task.Wait(60)
                egg.AddSimStrChV(obj, 0, 3, Angle(0, 0, obj.vx, obj.vy), 180)
            end)
        end
        --扇贝吐出的泡泡
        function f1_7(x, y)
            local obj = bubble2(x, y, 0.3)
            obj.vx, obj.ay = ran:Float(-0.15, 0.15), 0.04
        end
    end
    local function spawnShells(x)
        local spawn = {false}
        for i = -3, 3 do
            f1(self.x, self.y, x + 80*i, 192, 2, spawn)
        end
    end
    --主体攻击内容
    do
        s4_boss.pic_show()
        task.Wait(90)
        eff(self.x, self.y, 60)
        self:cast(60)
        spawnShells(0)
        --[[for i = -3, 3 do
            f1(self.x, self.y, 80*i, 192, 2)
        end]]
        task.Wait(90)
        eff(self.x, self.y, 60)
        task.New(self, function()
            local a0, a, da = 0, 0, 360/7
            task.Wait(300)
            eff(self.x, self.y, 60)
            while true do
                for i = 1, 7 do
                    a = a0 + da*i
                    stg.newBulletStraight(stg.arrow_big, co[i], true, self.x + 40*cos(a), self.y + 40*sin(a), 1.35, a)
                end
                task.Wait(8)
                a0 = a0 + 10
            end
        end)
        self:cast(999)
        local x
        while true do
            x = ran:Float(-40, 40)
            spawnShells(x)
            PlaySound("cancel00")
            task.Wait(240)
        end
    end
end
table.insert(scs, {boss_sc3, boss_sc3_normal_show, boss_sc3_scpr_show})
--四符 「miraculous mirage（蜃气秘影）」
local function boss_sc4_normal_show(self)
    self.bg.open = false
    local f1, f1_1
    local co = {1, 13, 11, 9, 7, 5, 3} --颜色表
    do
        --生成彩虹的泡泡
        function f1(x, y, a, u, co, dr, wt, dt, way, t)
            local obj = bubble_dark2(x, y, 0.6)
            PlaySound("cancel00")
            obj.group = GROUP_INDES
            task.New(obj, function()
                task.Wait(20)
                egg.AddAccDecChV(obj, 2, a, 30, 30, 10)
                task.Wait(10)
                egg.AddCirMove(obj, a, 0, 2*u, 0, 150 + dr, 10, 30, 150, 30)
                task.Wait(70)
                local v = 1.25
                local tt = t-100  --换组计时器
                local t = 120 + wt
                local _a = 60
                for j = 1, dt do
                    _a = 180
                    for i = 0, 0 do
                        f1_1(obj.x, obj.y, v, -90 + (-180 + 10*j + 60*i)*u, co, t, _a, tt)
                        _a = 0
                    end
                    tt = tt - 2
                    PlaySound("kira00")
                    task.Wait(2)
                end
                Del(obj)
            end)
            task.New(obj, function()
                task.Wait(t)
                obj.group = GROUP_GHOST
                task.Wait(10)
                obj.group = GROUP_ENEMY_BULLET
            end)
        end
        --衍生弹幕
        function f1_1(x, y, v, a, co, t, alp, dt)
            local obj = New(straight, ball_mid, co, true, x, y, 0, a, alp)
            _object.set_color(obj, "mul+add", alp, 255, 255, 255)
            egg.AddSimStrChV(obj, 0, v, a, 60, t)
            task.New(obj, function()
                task.Wait(t)
                local d_a = (255 - alp)/30
                for _ = 1, 30 do
                    obj._a = obj._a + d_a
                    task.Wait(1)
                end
                obj._blend = ""
            end)
            task.New(obj, function()
                task.Wait(dt)
                obj.group = GROUP_GHOST
                task.Wait(10)
                obj.group = GROUP_ENEMY_BULLET
            end)
        end
    end

    do
        self.group = GROUP_NONTJT
        self:flash(15, -50)
        dark_eff(self.x, self.y, 60)
        local r, u, t, a, da, dx, wt
        u = 1
        local dt = 170 --换组计时器
        do
            r, t = 0, 40
            a, da = 0, -2
            dx, wt = 0, 0
            for i = 7, 1, -1 do
                f1(self.x - 15 - u*dx, self.y + 15, -90 + a*u, u, co[i], r, wt, t, 2, dt)
                task.Wait(20)
                r = r + 4
                a = a + da
                t = t + 1
                dx = dx + 2.5
                wt = wt + 20
                dt = dt - 20
            end
            u = -u
        end
    end
end
local function boss_sc4_scpr_show(self)
    boss_show(self, 0, 144)
    boss.show_aura(self, true)
    boss_sc4_normal_show(self)
end
local function boss_sc4(self)
    self.bg.open = true
    local f1, f1_1, f2, f2_1, f3, f3_1
    local co = {1, 13, 11, 9, 7, 5, 3} --颜色表
    do
        --生成彩虹的泡泡
        function f1(x, y, a, u, co, dr, wt, dt, way)
            local obj = bubble2(x, y, 0.6)
            PlaySound("cancel00")
            obj.group = GROUP_INDES
            task.New(obj, function()
                task.Wait(20)
                egg.AddAccDecChV(obj, 2, a, 30, 30, 10)
                task.Wait(10)
                egg.AddCirMove(obj, a, 0, 2*u, 0, 150 + dr, 10, 30, 150, 30)
                task.Wait(70)
                local v = 1.25
                local t = 120 + wt
                local _a = 60
                for j = 1, dt do
                    _a = 180
                    for i = 0, 0 do
                        f1_1(obj.x, obj.y, v, -90 + (-180 + 10*j + 60*i)*u, co, t, _a)
                        _a = 0
                    end
                    PlaySound("kira00")
                    task.Wait(2)
                end
                Del(obj)
            end)
        end
        --衍生弹幕
        function f1_1(x, y, v, a, co, t, alp)
            local obj = New(straight, ball_mid, co, true, x, y, 0, a, alp)
            _object.set_color(obj, "mul+add", alp, 255, 255, 255)
            egg.AddSimStrChV(obj, 0, v, a, 60, t)
            task.New(obj, function()
                task.Wait(t)
                local d_a = (255 - alp)/30
                for _ = 1, 30 do
                    obj._a = obj._a + d_a
                    task.Wait(1)
                end
                obj._blend = ""
            end)
        end

        local size = {1.5, 1.4, 1.3, 1.2, 1.1, 1, 0.9}
        local co = {1, 13, 11, 9, 7, 5, 3} --颜色表
        function f2(x, y, a, u)
            local obj = New(straight, ball_mid, co[1], true, x, y, 0, 0)
            obj.hscale, obj.vscale = size[1], size[1]
            obj.bound = false
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            obj.pos = {} --记录自己之前的位置表
            task.New(obj, function()
                for i = 2, 7 do
                    table.insert(obj.pos, {obj.x, obj.y})
                    f2_1(obj.x, obj.y, i, obj, a + (100 - 10*(i-1))*u, u)
                    task.Wait(1)
                end
                for _ = 1, 300 do
                    table.remove(obj.pos)
                    table.insert(obj.pos, 1, {obj.x, obj.y})
                    task.Wait(2)
                end
            end)
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET-1
                SetV(obj, 6, a)
                local a = {a}
                task.Wait(20)
                egg.AimTo(obj, player, 6, 3, 45, 0.1, a)
                task.Wait(45)
                --egg.AddSimStrChV(obj, 0, 3, Angle(0, 0, obj.dx, obj.dy), 30)
            end)
        end
        function f2_1(x, y, i, mst, a, u)
            local obj = New(straight, ball_mid, co[i], true, x, y, 0, 0)
            obj.hscale, obj.vscale = size[i], size[i]
            obj.a, obj.b = obj.hscale*obj.a, obj.vscale*obj.b
            obj.timer = 11
            obj.bound = false
            _object.set_color(obj, "mul+add", 255, 255, 255, 255)
            task.New(obj, function()
                obj.layer = LAYER_ENEMY_BULLET-1
                for _ = 1, 170 do
                    if IsValid(mst) then
                        obj.x, obj.y = mst.pos[i-1][1], mst.pos[i-1][2]
                    else
                        break
                    end
                    task.Wait(1)
                end
                Del(obj)
            end)
        end

        --上升的彩虹泡泡
        function f3(x, y, a0, dx, c)
            local obj = bubble2(x, y, 0.5)
            task.New(obj, function()
                task.Wait(20)
                egg.AddAccDecChV(obj, dx/30, 0, 10, 20, 20)
                egg.AddAccDecChV(obj, 2, 90, 10, 20, 20)
                task.Wait(40)
                egg.AddSimStrChV(obj, 0, 3, 90, 90)
                --task.Wait(30)
                local k = 0
                while true do
                    for u = -1, 1, 2 do
                        for j = 0, 2 do
                            for u1 = -1, 1, 2 do
                                f3_1(obj.x, obj.y, -90 + 45*u1, (a0 + k-2*j)*u, co[c])
                            end
                            task.Wait(3)
                            k = k + 3
                        end
                    end
                end
            end)
        end
        --发射出来一堆奇怪的东西
        function f3_1(x, y, a, da, co)
            local obj = stg.newBulletStraight(stg.arrow_big, co + 1, true, x, y, 0, a)
            task.New(obj, function()
                egg.AddAccDecChV(obj, 2, a, 30, 30, 30)
                task.Wait(90)
                PlaySound("kira00")
                egg.AddSimStrChV(obj, 0, 1.25, a + da, 60)
                obj.rot = a + da
            end)
        end
    end

    do
        s4_boss.pic_show()
        --立绘演出会挡子弹，为了保护自机所以要消弹
        task.Wait(30)
        eff(self.x, self.y, 60)
        local r, u, t, a, da, dx, wt
        u = -1
        local a0
        while true do
            self:flash(15 - 3*20*1.4*u, -50 + 3*20*1.4)
            for k = 1, 3 do
                PlaySound("cancel00")
                f3(self.x, self.y, -60 + 60*(k-2) + ran:Float(-5, 5), -30*(3-k)*u, ran:Int(1, 7))
                a0 = Angle(self, player) + 180
                for i = -1, 1, 2 do
                    f2(self.x, self.y, a0 - 20*i, u)
                end
                egg.AddAccDecChV(self, 2, -90 + 45*u, 10, 10, 10)
                task.Wait(30)
            end
            r, t = 0, 40
            a, da = 0, -2
            dx, wt = 0, 0
            for i = 7, 1, -1 do
                f1(self.x - 15 - u*dx, self.y + 15, -90 + a*u, u, co[i], r, wt, t, 2)
                task.Wait(20)
                r = r + 4
                a = a + da
                t = t + 1
                dx = dx + 2.5
                wt = wt + 20
            end
            u = -u
        end
    end
end
table.insert(scs, {boss_sc4, boss_sc4_normal_show, boss_sc4_scpr_show})
--LSC
local function boss_LSC(self)
    local co = {1, 13, 11, 9, 7, 5, 3} --颜色表
    local rx, ry = 163*2, 195*2 --贝壳移动范围
    local f1, f1_1, f2,  f2_1, f2_2, f2_3, f2_4
    do
        --遮挡雾气
        function f1(x, y, vx, vy)
            local obj = New(s4_boss.fog, 0)
            _connect(self, obj, 0, true)
            obj.x, obj.y = x, y
            obj.vx, obj.vy = vx, vy
            obj.hscale, obj.vscale = 0.45, 0.45
            obj.omiga = 0.05
            _object.set_color(obj, "", 0, 255, 255, 255)
            task.New(obj, function()
                local t = 180
                local dvx, dvy, d_a = -vx/t, -vy/t, 175/t
                for _ = 1, 180 do
                    obj.vx, obj.vy, obj._a = obj.vx + dvx, obj.vy + dvy, obj._a + d_a
                    task.Wait(1)
                end
            end)
        end
        --贝壳
        function f2(x, y)
            local obj = New(s4_boss.shell_class, x, y, 40)
            f2_1(obj) --生成泡泡
            _connect(self, obj, 0, true)
            obj.group = GROUP_GHOST
            obj.hscale, obj.vscale = 0, 0
            --贝壳变大动画
            task.New(obj, function()
                for x = 0, 90, 3 do
                    obj.hscale, obj.vscale = sin(x), sin(x)
                    task.Wait(1)
                end
                task.MoveTo(0, 0.5*ry, 90, MOVE_ACC_DEC)
                --这个时候泡泡应该炸了
                local dx, dy = rx/4, ry/4
                --往左走到最边
                for i = 1, 2 do
                    task.MoveTo(-dx*i, 0.5*ry, 40, MOVE_ACC_DEC)
                    f2_2(obj.x, obj.y)
                    s4_boss.shell_class.open(obj)
                    task.Wait(40)
                    s4_boss.shell_class.close(obj)
                end
                --循环方形绕圈
                while true do
                    for i = 1, 4 do
                        task.MoveTo(-0.5*rx, 0.5*ry - dy*i, 40, MOVE_ACC_DEC)
                        f2_2(obj.x, obj.y)
                        s4_boss.shell_class.open(obj)
                        task.Wait(40)
                        s4_boss.shell_class.close(obj)
                    end
                    for i = 1, 4 do
                        task.MoveTo(-0.5*rx + dx*i, -0.5*ry, 40, MOVE_ACC_DEC)
                        f2_2(obj.x, obj.y)
                        s4_boss.shell_class.open(obj)
                        task.Wait(40)
                        s4_boss.shell_class.close(obj)
                    end
                    for i = 1, 4 do
                        task.MoveTo(0.5*rx, -0.5*ry + dy*i, 40, MOVE_ACC_DEC)
                        f2_2(obj.x, obj.y)
                        s4_boss.shell_class.open(obj)
                        task.Wait(40)
                        s4_boss.shell_class.close(obj)
                    end
                    for i = 1, 4 do
                        task.MoveTo(0.5*rx - dx*i, 0.5*ry, 40, MOVE_ACC_DEC)
                        f2_2(obj.x, obj.y)
                        s4_boss.shell_class.open(obj)
                        task.Wait(40)
                        s4_boss.shell_class.close(obj)
                    end
                end
            end)
        end
        --承载贝壳的泡泡
        function f2_1(mst)
            local obj = bubble2(mst.x, mst.y, 0.75)
            task.New(obj, function()
                for _ = 1, 120 do
                    if IsValid(mst) then
                        obj.x, obj.y = mst.x, mst.y
                    else
                        break
                    end
                    task.Wait(1)
                end
                Del(obj)
            end)
        end
        --贝壳喷雾
        function f2_2(x, y)
            local obj = New(s4_boss.fog, 0)
            obj.x, obj.y = x, y
            _connect(self, obj, 0, true)
            obj.omiga = 0.05
            obj.hscale, obj.vscale = 0.65, 0.65
            _object.set_color(obj, "", 0, 255, 255, 255)
            egg.SimAlpCh(obj, 0, 255, 40)
            task.New(obj, function()
                task.Wait(40 + 160)
                PlaySound("kira00")
                local a = Angle(obj, player)
                for i = 1, 10 do
                    for j = -1, 1 do
                        f2_3(obj.x, obj.y, a + 36*i + 1.25*j)
                    end
                end
                for i = 1, 18 do
                    f2_4(obj.x, obj.y, a + i*20)
                end
                egg.SimAlpCh(obj, 255, 0, 60)
                task.Wait(90)
            end)
        end
        --雾里生成的弹幕
        function f2_3(x, y, a)
            local obj = stg.newBulletStraight(stg.arrow_big, 6, true, x, y, 0, a)
            egg.AddSimStrChV(obj, 1.5, 0.25, a, 60)
            task.New(obj, function()
                task.Wait(90)
                egg.AddSimStrChV(obj, 0, 1, a, 60)
            end)
        end
        --雾里生成的弹幕(小玉
        function f2_4(x, y, a)
            local obj = stg.newBulletStraight(stg.ball_mid_c, 8, true, x, y, 0, a)
            egg.AddSimStrChV(obj, 0, 0.25, a, 60)
            task.New(obj, function()
                task.Wait(60)
                egg.AddSimStrChV(obj, 0, 0.75, a, 150)
            end)
        end
    end

    do
        self.x, self.y = 0, 0
        s4_boss.pic_show()
        task.Wait(90)
        eff(self.x, self.y, 60)
        self:cast(90)
        PlaySound("kira00")
        for u = -1, 1, 2 do
            for i = -3, 3 do
                f1(self.x, self.y, 0.4*i, 1.2*u)
            end
            for i = -3, 3 do
                f1(self.x, self.y, 1.2*u, 0.4*i)
            end
        end
        task.Wait(30)
        for j = 1, 30 do
            PlaySound("tan00")
            for i = 1, 20 do
                stg.newBulletStraight(stg.grain_a, co[j%7+1], true, self.x, self.y, 3 - 0.09*j, 18*i + 6*j)
            end
            task.Wait(3)
        end
        task.Wait(60)
        self:flash(0, 144)
        eff(self.x, self.y, 60)
        for _ = 1, 4 do
            self:cast()
            PlaySound("cancel00")
            f2(self.x, self.y)
            task.Wait(296)
        end
    end
end


-- 创建一个 boss 类
local function create_boss_class(class_name, group_name)
    local cls = Class(boss)
    _editor_class[class_name] = cls
    cls.cards = {}
    cls._name = class_name
    cls.name = "Hisoka"
    cls.bgm = "s4_boss"
    cls._bg = function() return stage4_background end
    cls.difficulty = group_name
    function cls:init(cards)
        boss.init(self, 0, 90, "Hisoka", cards, New(s4_boss.scbg), group_name)
        lstg.wis.Hisoka(self)
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
    elseif mode == "spellcard" then
        function _sc:init()
            task.New(self,function()
                scs[index][1](self)
            end)
        end
        function _sc:del()
            dark_bkeff(self.x, self.y)
            self.bg.open = false
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
        end
    elseif mode == "spellcard" then
        function _sc:init()
            task.New(self,function()
                scs[index][1](self)
            end)
        end
        function _sc:del()
            self._wisys:setAction("normal")
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
local stage4boss
do
    stage4boss = create_boss_class("stage4boss:Hard", "Hard")
    local card_info = {
        {"常规攻击1", {2, 10, 40}, 1200, {0,0,0}, "normal", false},
        {"影符「天海激流」", {2, 6, 50}, 2000, {10, 20, 30}, "spellcard", false},
        {"常规攻击2", {2, 5, 40}, 1500, {0,0,0}, "normal", false},
        {"幻符「Mayhem Assault(恐惧突袭)」", {2, 10, 50}, 2000, {10, 20, 30}, "spellcard", false},
        {"常规攻击3", {2,10,40}, 1500,{0,0,0}, "normal", false},
        {"幻术「Unknown Luminous Orb(不明夜光珠)」", {3, 5, 60}, 2500, {10, 20, 30}, "spellcard", false},
        {"常规攻击4", {2,5,40}, 1500,{0,0,0}, "normal", false},
        {"「Miraculous Mirage(蜃气秘影)」", {2, 5, 60}, 2000, {10, 20, 30}, "spellcard", false}
    }
    stage4boss.cards={}
    local i, info = 1
    --如果要插入新的card，请务必在local n之上插入，否则会影响后面二符的del函数
    local n = #stage4boss.cards
    for index = 1, 4 do
        info = card_info[i]
        table.insert(stage4boss.cards, create_normal_show_class(index, info[5]))
        table.insert(stage4boss.cards, create_card_class(index, info[1], info[2], info[3], info[4], info[5], info[6]))
        i = i + 1
        info = card_info[i]
        table.insert(stage4boss.cards, create_normal_show_class(index, info[5]))
        table.insert(stage4boss.cards, create_card_class(index, info[1], info[2], info[3], info[4], info[5], info[6]))
        i = i + 1
    end
    local _sc = stage4boss.cards[n+8] --这里要保证精准定位到二符，修改二符的del函数
    function _sc:del()
        dark_bkeff(self.x, self.y)
        self.bg.open = false
        self.vx, self.vy = 0, 0 --该停下来啦
        self.ax, self.ay = 0, 0
    end
    _sc = stage4boss.cards[n+16] --这里要保证精准定位到终符
    function _sc:del()
        dark_bkeff(self.x, self.y)
        self.vx, self.vy = 0, 0 --该停下来啦
        self.ax, self.ay = 0, 0
    end
end
_editor_class["stage4boss:Hard"] = stage4boss

--符卡练习定义
local stage4bossScpr
do
    stage4bossScpr = create_boss_class("stage4bossScpr:Hard", "Hard")
    local card_info = {
        {"常规攻击1", {2, 10, 40}, 1200, {0,0,0}, "normal", false},
        {"影符「天海激流」", {2, 6, 50}, 2000, {10, 20, 30}, "spellcard", false},
        {"常规攻击2", {2, 5, 40}, 1500, {0,0,0}, "normal", false},
        {"幻符「Mayhem Assault(恐惧突袭)」", {2, 10, 50}, 2000, {10, 20, 30}, "spellcard", false},
        {"常规攻击3", {2,10,40}, 1500,{0,0,0}, "normal", false},
        {"幻术「Unknown Luminous Orb(不明夜光珠)」", {3, 5, 60}, 2500, {10, 20, 30}, "spellcard", false},
        {"常规攻击4", {2,5,40}, 1500,{0,0,0}, "normal", false},
        {"「Miraculous Mirage(蜃气秘影)」", {2, 5, 60}, 2000, {10, 20, 30}, "spellcard", false}
    }
    stage4bossScpr.cards={}
    local i, info = 1
    --如果要插入新的card，请务必在local n之上插入，否则会影响后面二符的del函数
    local n = #stage4bossScpr.cards
    for index = 1, 4 do
        info = card_info[i]
        table.insert(stage4bossScpr.cards, create_scpr_show_class(index, info[5]))
        table.insert(stage4bossScpr.cards, create_cardpr_class(index, info[1], info[2], info[3], info[4], info[5], stage4bossScpr))
        i = i + 1
        info = card_info[i]
        table.insert(stage4bossScpr.cards, create_scpr_show_class(index, info[5]))
        table.insert(stage4bossScpr.cards, create_cardpr_class(index, info[1], info[2], info[3], info[4], info[5], stage4bossScpr))
        i = i + 1
    end
    local _sc = stage4bossScpr.cards[n+8] --这里要保证精准定位到二符，修改二符的del函数
    function _sc:del()
        --dark_bkeff(self.x, self.y)
        self.vx, self.vy = 0, 0 --该停下来啦
        self.ax, self.ay = 0, 0
    end
    local _sc = stage4bossScpr.cards[n+16] --这里要保证精准定位到四符，修改四符的del函数
    function _sc:del()
        dark_bkeff(self.x, self.y)
        self.vx, self.vy = 0, 0 --该停下来啦
        self.ax, self.ay = 0, 0
    end
end
_editor_class["stage4bossScpr:Hard"] = stage4bossScpr

--LSC定义
local LSC4
do
    LSC4=Class(boss)
    LSC4.cards={}
    LSC4.name="Hisoka"
    function LSC4:init(cards)
        boss.init(self,0, 384, "Hisoka", cards, New(s4_boss.scbg), "Hard")
        lstg.wis.Hisoka(self) --需要使用dnh行走图的对象第一行必须执行该函数
    end
    LSC4.bgm = "s4_boss"
    LSC4._bg = function() return stage4_background end
    LSC4.difficulty = "Hard"
    --对话内容
    do
        local _tmp_sc = boss.dialog.New(true)
        function _tmp_sc:init()
            player.dialog = false
            self.dialog_displayer=New(dialog_displayer)
            self._dialog_maintask=task.New(self,function()
                boss:show_aura(false)
                self.bg.open = false
                self.hide = true
                _object.set_color(self, "", 0, 255, 255, 255)
                self.colli = false
                for _ = 1, 3 do
                    dark_eff(0, 0, 20)
                end
                self.hide = false
                self.y = 0
                egg.SimAlpCh(self, 0, 255, 60)
                self:flash(self.x, self.y)
                boss.show_aura(self, true)
                lscNoBombCheck(self)
            end)
        end
        table.insert(LSC4.cards,_tmp_sc)
    end
    --LSC
    do
        local _tmp_sc = boss.card.New("「氤氲的九重楼阁」",2, 25, 70, 2500, {0, 0, 60}, false, "lastspell")
        function _tmp_sc:init()
            --New(lscSpecialEvent, self)
            task.New(self,function()
                boss_LSC(self)
            end)
        end
        function _tmp_sc:del()
            dark_bkeff(self.x, self.y)
            self.bg.open = false
        end
        _tmp_sc.perform=true
        table.insert(LSC4.cards,_tmp_sc)
        table.insert(_sc_table,{"LSC4:Hard", "「氤氲的九重楼阁」", _tmp_sc, #LSC4.cards, true})
    end
    _editor_class["LSC4:Hard"] = LSC4
end
