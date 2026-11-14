-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage5/spellcard/mid_spell_1.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local disappearByAlpha = EGGlib.ObjectEvent.disappearByAlpha
local sizeAndColliChangeTask = EGGlib.ObjectEvent.sizeAndColliChangeTask
local alphaChange = EGGlib.ObjectEvent.alphaChange
local expression = EISlib.Effect.expression
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local velch = EGGlib.ObjectEvent.velocityChange
local sect_layer1 = EGGlib.BulletGroup.Sector.layer1
local lead_laser = EISlib.Bullet.Laser.lead_laser
local warning_laser = EISlib.Bullet.Laser.warning_laser

local boss_name = "Lycaropia"  --以boss名来作为其相关素材的前缀
local cleft_imgs = {}
for i = 1, 21 do
    cleft_imgs[i] = boss_name.."cleft"..(i - 1)
end
--拉进弹幕、boss、自机
local cleft = Class(object)
function cleft:init(x, y, rot, h, v)
    self.bound = false
    self.trail_x, self.trail_y = x, y
    self.group = GROUP_GHOST
    self.layer = LAYER_PLAYER - 1
    self.x, self.y = x, y
    self.colli = true
    self.rot = rot
    self._dx, self._dy = cos(rot), sin(rot)
    self.hscale, self.vscale = 0, v
    self.a, self.b = 0, 10*v
    robject.set_color(self, "", 255, 255, 255, 255)
    task.New(self, function()
        local t = 30
        local dh = h/t
        for _ = 1, t do
            self.hscale = self.hscale + dh
            self.a = self.a + 150*dh
            task.Wait(1)
        end
        task.Wait(60)
        task.New(self, function()
            local t = 30
            local dv = 10*v/t
            for _ = 1, t do
                self.vscale = self.vscale + dv
                task.Wait(1)
            end
        end)
        alphaChange(self, 255, 0, 90)
    end)
end
function cleft:frame()
    task.Do(self)
    local len = 0.5*cleft.getLength(self)
    self.x, self.y = self.trail_x + len*self._dx, self.trail_y + len*self._dy
end
function cleft:render()
    local img = cleft_imgs[1 + math.floor(self.timer/2)%21]
    SetImageState(img, self._blend, Color(self._a, self._r, self._g, self._b))
    Render(img, self.x, self.y, self.rot, self.hscale, self.vscale)
end
function cleft:getLength()
    return self.hscale*450
end
function cleft:getWide()
    return self.vscale*20
end


local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    --激光
    B.laser1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a)
                    local obj = New(lead_laser, 1, COLOR_PURPLE, --type, co
                            x, y, 10, a, --x, y, v, a,
                            1200, 30, 30, 1, --len, w0, w1, dt
                            true, false, 110
                    )
                    _connect(_boss, obj, 0, true)
                    obj.bound = false
                end
                return create
            end
    )

    --预警线
    B.warning_laser = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a)
                    local obj = New(warning_laser,
                            x, y,
                            600, 10, 10, 5, a, --len, l_t, wide, w_t, a
                            "", Color(255, 255, 0, 0), --blend, color
                            60 --disappear
                    )
                    obj.bound = false
                    warning_laser.setTrailLength(obj, 40)
                    task.New(obj, function()
                        task.Wait(45)
                        B.laser1.create(x, y, a)
                    end)
                end
                return create
            end
    )

    --作为荧幕的光玉
    B.bullet1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local color = switch1(diff, {COLOR_YELLOW, COLOR_YELLOW, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE})
                local v0 = 3
                local dv0 = switch1(diff, {
                    0.5, 0.5, 0.15, 0.15, 0.15
                })
                local create
                if diff < 2 then --E
                    function create(x, y, v, a, dt, da, dv_i, dx)
                        local obj = stg.newSimpleBullet(x, y, stg.ball_light, color, true, 1)
                        robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                        obj.bound = false
                        setSizeAndColli(obj, 0.05, 0.05)
                        sizeAndColliChangeTask(obj, 1.45, 40)
                        task.New(obj, function()
                            velch(obj, v, 0, a, 30, 60)
                            task.Wait(30 + dt)
                            P.pointer3.attack(obj.x + dx, obj.y, -90, 0)
                            PlaySound("kira00")
                            velch(obj, 0, v0, a + da, 30)
                            while obj.x > -204 and obj.x < 204 do
                                task.Wait(1)
                            end
                            --反弹生成新子弹
                            if dv_i > 0 then
                                P.pointer2.attack(obj.x, obj.y, dv_i*dv0, Angle(obj.x, obj.y, player.x, player.y) + 15)
                            end
                            _del(obj)
                        end)
                    end
                elseif diff < 3 then --N
                    function create(x, y, v, a, dt, da, dv_i, dx)
                        local obj = stg.newSimpleBullet(x, y, stg.ball_light, color, true, 1)
                        robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                        obj.bound = false
                        setSizeAndColli(obj, 0.05, 0.05)
                        sizeAndColliChangeTask(obj, 1.45, 40)
                        task.New(obj, function()
                            velch(obj, v, 0, a, 30, 60)
                            task.Wait(30 + dt)
                            P.pointer3.attack(obj.x + dx, obj.y, -90, 0)
                            PlaySound("kira00")
                            velch(obj, 0, v0, a + da, 30)
                            while obj.x > -192 and obj.x < 192 do
                                task.Wait(1)
                            end
                            --反弹生成新子弹
                            if dv_i ~= 6 then
                                P.pointer2.attack(obj.x, obj.y, dv_i*dv0, Angle(obj.x, obj.y, player.x, player.y))
                            end
                            _del(obj)
                        end)
                    end
                else --HL
                    function create(x, y, v, a, dt, da, dv_i)
                        local obj = stg.newSimpleBullet(x, y, stg.ball_light, color, true, 1)
                        robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                        obj.bound = false
                        setSizeAndColli(obj, 0.05, 0.05)
                        sizeAndColliChangeTask(obj, 1.45, 40)
                        task.New(obj, function()
                            velch(obj, v, 0, a, 30, 60)
                            task.Wait(30 + dt)
                            PlaySound("kira00")
                            velch(obj, 0, v0, a + da, 30)
                            while obj.x > -204 and obj.x < 204 do
                                task.Wait(1)
                            end
                            --反弹生成新子弹
                            if dv_i ~= 6 then
                                P.pointer2.attack(obj.x, obj.y, dv0*dv_i, (a - da))
                            end
                            _del(obj)
                        end)
                    end
                end
                return create
            end
    )

    --
    B.bullet2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, v, a, dt)
                    local obj = stg.newSimpleBullet(x, y, stg.ball_light, COLOR_PURPLE, true, 1)
                    obj.group = GROUP_GHOST
                    robject.set_color(obj, "mul+add", 255, 255, 0, 255)
                    obj.bound = false
                    setSizeAndColli(obj, 0.05, 0.05)
                    sizeAndColliChangeTask(obj, 1.45, 40)
                    task.New(obj, function()
                        obj.layer = LAYER_PLAYER - 1
                        velch(obj, v, 0, a, 30, 60)
                        task.Wait(90 + dt)
                        disappearByAlpha(obj, 20)
                        Del(obj)
                    end)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义
    local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
    --光玉幕布的其中一条
    P.pointer1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local dv = switch1(diff, {
                    0.45, 0.45, 0.45, 0.45, 0.45
                }) + switch(rank, {
                    0, 0, 0, 0, 0.1
                })
                local dt = switch1(diff, {
                    7, 7, 7, 7, 7
                })
                local layer = switch1(diff, {
                    8, 8, 8, 8, 8
                })
                --EN限定
                local dx = switch1(diff, {
                    30, 60, no_info, no_info, no_info
                })/(layer - 1)
                local hyperU = switch(rank, {
                    1, 1, 1, 1, -1
                })
                local function attack(x, y, dv_i, a, da, dt0, u)
                    PlaySound("kira00")
                    local d = (layer - 1)/2
                    for i = 0, layer - 1 do
                        B.bullet1.create(x, y, dv*i, a, dt0 + dt*(layer - 1 - i), da, dv_i, hyperU*u*dx*(i - d))
                    end
                end
                return attack
            end
    )

    --光玉撞墙产生链弹
    P.pointer2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.arrow_small, COLOR_YELLOW
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color, true)
                end
                local v0 = switch1(diff, {
                    1.5, 1.5, 1.5, 1.5, 2
                })*defaultSwitchVelocityByRank(rank)
                local dv0 = switch1(diff, {
                    0, 0, 1, 1, 1.5
                })*defaultSwitchVelocityByRank(rank)
                local layer = switch1(diff, {
                    1, 1, 1, 1, 1
                })
                local way = switch1(diff, {
                    7, 7, 7, 7, 7
                })
                local da = switch1(diff, {
                    30, 30, 35, 25, 25
                })
                local function attack(x, y, dv, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, true,
                            function()
                                sect_layer1(x, y, v0 + dv, a, way, da, layer, dv0, 0, bullet_func)
                            end)
                end
                return attack
            end
    )

    --幕布光玉开始移动时向下发的弹幕
    P.pointer3 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.ball_big, COLOR_PURPLE
                local v = switch1(diff, {
                    2, 2, 2.5, 3, 3
                })*defaultSwitchVelocityByRank(rank)
                local v1 = switch1(diff, {
                    no_info, 1.15, 1.25, 1.35, 1.35
                })*defaultSwitchVelocityByRank(rank)

                local layer = switch1(diff, {
                    1, 1, 1, 1, 1
                })
                local dv = switch1(diff, {
                    -0.25, -0.25, -0.25, -0.25, -0.25
                })
                local attack
                if diff < 2 then  --E
                    function attack(x, y, a, dt)
                        PlaySound("tan00")
                        local function bullet_func(x, y, v, a)
                            stg.newSimpleStrChV(x, y, 0.1, v, a, 30, 120 + dt, stg.star_small, color, true).omiga = 6
                        end
                        stg.newFadeEffect(x, y, style, color, true,
                                function()
                                    circle_layer1(x, y, v, a, 1, layer, dv, 0, 0, bullet_func)
                                end)
                    end
                else --NHL
                    local way = switch1(diff, {
                        0, 1, 2, 2, 2
                    })
                    function attack(x, y, a, dt, sp)
                        local da = 360/way
                        if way == 1 then
                            da = 0
                        end
                        PlaySound("tan00")
                        local function bullet_func(x, y, v, a)
                            stg.newSimpleStrChV(x, y, 0, v, a, 30, dt, style, color, true).omiga = 6
                        end
                        local function bullet_func2(x, y, v, a)
                            stg.newSimpleStrChV(x, y, 0.1, v, a, 30, 120 + dt, stg.ball_mid_c, COLOR_DEEP_RED, true)
                        end
                        stg.newFadeEffect(x, y, style, color, true,
                                function()
                                    circle_layer1(x, y, v, a, 1, layer, dv, 0, 0, bullet_func)
                                    sect_layer1(x, y, v1, a, way, da,
                                            layer, dv, 0,
                                            bullet_func2
                                    )
                                end)
                    end
                end
                return attack
            end
    )

    --装饰光玉
    P.pointer4 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local dv = switch1(diff, {
                    0.45, 0.45, 0.45, 0.45, 0.45
                }) + switch(rank, {
                    0, 0, 0, 0, 0.1
                })
                local dt = 3
                local layer = 15
                local function attack(x, y, a, dt0)
                    PlaySound("kira00")
                    local d = (layer - 1)/2
                    for i = 0, layer - 1 do
                        B.bullet2.create(x, y, dv*i, a, dt0 + dt*(layer - 1 - i))
                    end
                end
                return attack
            end
    )

    --封位链弹
    P.pointer5 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = 0.4*defaultSwitchVelocityByRank(rank)
                local dv = switch1(diff, {
                    0.4, 0.4, 0.4, 0.4, 0.4
                })*defaultSwitchVelocityByRank(rank)
                local layer = 15
                local style, color = stg.arrow_small, COLOR_YELLOW+1
                local function attack(x, y)
                    stg.newFadeEffect(x, y, style, color, true,
                            function()
                                for i = 0, layer - 1 do
                                    stg.newSimpleStraight(x, y, v + dv*i, -90, style, color, true)
                                end
                            end)
                end
                return attack
            end
    )
    --endregion
    --region Tasker 任务执行器
    --光玉幕布
    T.tasker1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    8, 8, 8, 8, 8
                })
                local wait = 10
                local dx = switch1(diff, {
                   240, 240, 180, 180, 180
                }) /(count - 1)
                local function main(b)
                    boss.createTasker(b, b.x, b.y,
                            function(obj)
                                task.New(obj, function()
                                    for i = count - 1, 0, -1 do
                                        for u = -1, 1, 2 do
                                            P.pointer1.attack(dx*(i + 0.5)*u, 224 + 10*i, i, -90, 85*u, (wait + 10)*i, u)
                                        end
                                        task.Wait(wait)
                                    end
                                    Del(obj)
                                end)
                            end, true) --iswait
                end
                return main
            end)

    --幕布揭开后产生的大星星(HL限定
    T.tasker2 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    no_info, no_info, 20, 24, 24
                })
                local da = 180/(count - 1)
                local wait = math.floor(30/count)
                local function main(b, x, y, a0, u, r, sp)
                    local count = (count - 1)/2
                    boss.createTasker(b, x, y,
                            function(obj)
                                task.New(obj, function()
                                    local a
                                    for i = -count, count do
                                        a = a0 + da*i*u
                                        P.pointer3.attack(x + r*cos(a), y + r*sin(a), a, 0, sp)
                                        task.Wait(wait)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)


    --装饰用光玉幕布
    T.tasker3 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    8, 8, 8, 8, 8
                })
                local wait = 6
                local d = switch(rank, {
                    3, 3, 3, 3, 1.33
                })
                local dx = 180/(count - 1)
                local function main(b)
                    boss.createTasker(b, 0, 144,
                            function(obj)
                                task.New(obj, function()
                                    for i = count - 1, 0, -1 do
                                        for u = -1, 1, 2 do
                                            P.pointer4.attack(dx*(i + 0.5)*u, 224 + 5*i, -90, (wait + 4)*i)
                                            for u0 = -1, 1, 2 do
                                                --P.pointer5.attack(dx*(i + 0.625 + 0.25*u0)*u, 245)
                                                B.warning_laser.create(dx*(i + d + 0.25*u0)*u, 275, -90)
                                            end
                                        end
                                        task.Wait(wait)
                                    end
                                    Del(obj)
                                end)
                            end, true) --iswait
                end
                return main
            end)
    --endregion
    --region 组合攻击
    local move = EGGlib.ObjectEvent.moveToPlayerDefault
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local main
                if diff < 3 then --EN
                    function main(b)
                        T.tasker1.main(b)
                        task.Wait(100)
                        b.y = 144
                        b.hide = true
                        task.Wait(260)
                    end
                else --HL
                    function main(b)
                        T.tasker1.main(b)
                        task.Wait(90)
                        for i = 3, 1, -1 do
                            for j = -1, 1 do
                                T.tasker2.main(b, 192*j, 224, ran:Float(-95, -85) + 30*j, tranU(i), 20 + 60*i, 1*(4-i))
                            end
                            task.Wait(20)
                        end
                        b.y = 144
                        b.hide = true
                        task.Wait(210)
                    end
                end
                return main
            end)

    C.SECOND = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main(b)
                    T.tasker3.main(b)
                    task.Wait(60)
                    New(cleft, 0, 400, -90, 2, 2)
                end
                return main
            end)
    --endregion

    --若rank有变化，则必须更新一次
    local rank = -1
    local function reFresh()
        local new_rank = system.PowerRank.getRank()
        if rank ~= new_rank then --以下两个会受rank影响，需要更新
            for _, v in pairs(B) do
                v.update(difficulty, new_rank)
            end
            for _, v in pairs(P) do
                v.update(difficulty, new_rank)
            end
            for _, v in pairs(T) do
                v.update(difficulty, new_rank)
            end
            for _, v in pairs(C) do
                v.update(difficulty, new_rank)
            end
            for _, v in pairs(E) do
                v.update(difficulty, new_rank)
            end
            for _, v in pairs(S) do
                v.update(difficulty, new_rank)
            end
            for _, v in pairs(D) do
                v.update(difficulty, new_rank)
            end
            rank = new_rank
        end
    end

    local function doubleAchievement(b)
        if system.isDoubleGetSpellCardBonus(b) then
            --[[local achi_func = switch1(difficulty, {
                function()
                    AchievementReminder.unlock("s5_mid_sc1", "铁幕:Easy", "成功双倍收取莱卡的符卡「满月帷幕」")
                end,
                function()
                    AchievementReminder.unlock("s5_mid_sc1", "铁幕:Easy", "成功双倍收取莱卡的符卡「满月帷幕」")
                    AchievementReminder.unlock("s5_mid_sc1", "铁幕:Normal", "成功双倍收取莱卡的符卡「满月帷幕」")
                end,
                function()
                    AchievementReminder.unlock("s5_mid_sc1", "铁幕:Easy", "成功双倍收取莱卡的符卡「满月帷幕」")
                    AchievementReminder.unlock("s5_mid_sc1", "铁幕:Normal", "成功双倍收取莱卡的符卡「满月帷幕」")
                    AchievementReminder.unlock("s5_mid_sc1", "铁幕:Hard", "成功双倍收取莱卡的符卡「满月帷幕」")
                end,
                function()
                    AchievementReminder.unlock("s5_mid_sc1", "铁幕:Easy", "成功双倍收取莱卡的符卡「满月帷幕」")
                    AchievementReminder.unlock("s5_mid_sc1", "铁幕:Normal", "成功双倍收取莱卡的符卡「满月帷幕」")
                    AchievementReminder.unlock("s5_mid_sc1", "铁幕:Hard", "成功双倍收取莱卡的符卡「满月帷幕」")
                    AchievementReminder.unlock("s5_mid_sc1", "铁幕:Lunatic", "成功双倍收取莱卡的符卡「满月帷幕」")
                end,
            })
            if achi_func then
                achi_func()
            end]]
            achievement.unlock("s5_mid_sc1", true, true)
        end
    end
    
    local names = {
        "name-boss7-card1-E",
        "name-boss7-card1-N",
        "name-boss7-card1-H",
        "name-boss7-card1-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "timespell", --类型
            {12, 12, 12}, --时间
            1350, --耐久
            {50, 50}, --掉落
            function(b) --普通模式攻击前动作
                b.x, b.y = -300, 144
                task.MoveTo(b, -120, 144, 30, MOVE_ACC_DEC)
                local e = New(expression, b.x, b.y + 30, "angry")
                expression.defaultShow(e, 20, 40, 10) --t0, t1, t2
                task.Wait(60)
                task.MoveTo(b, 0, 144, 30, MOVE_ACC_DEC)
                dialog.scene.stage5_mid()
                boss.show_aura(b, true)
                b.colli = false
                robject.set_color(b, "", 150, 255, 255, 255)
                PlaySound("wolf")
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 144
                boss.show_aura(b, true)
                b.colli = false
                robject.set_color(b, "", 150, 255, 255, 255)
                PlaySound("wolf")
            end,
            function(b) --main
                reFresh()
                C.FIRST.main(b)
                C.SECOND.main(b)
            end,
            function(b) --finish
                doubleAchievement(b)
                if b.timeout ~= 0 then --超时就先标记着，下一个阶段就不掉出道具了
                    b.no_drop = true
                end
                local R = lstg.tmpvar.current_road
                if IsValid(R) then
                    R.sence = 4 --背景进入第四阶段
                end
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
