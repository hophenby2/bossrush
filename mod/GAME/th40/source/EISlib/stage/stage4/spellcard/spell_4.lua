-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage6/spellcard/spell_6.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local velch = EGGlib.ObjectEvent.velocityChange
local involuteMoveTask = EGGlib.ObjectEvent.involuteMoveTask
local boundWait = EGGlib.ObjectEvent.boundWait
local circle_normal1 = EGGlib.BulletGroup.Circle.normal1
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local warning_laser = EISlib.Bullet.Laser.warning_laser2
local lead_laser = EISlib.Bullet.Laser.lead_laser
local accdecVelch = EGGlib.ObjectEvent.accDecVelocityChange
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local sect_normal1 = EGGlib.BulletGroup.Sector.normal1
local setSize = EGGlib.ObjectEvent.setSize
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local AbsorbEffect2 = EGGlib.RenderEffect.AbsorbEffect2
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    B.warning_laser1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a)
                    local obj = New(warning_laser,
                            x, y, --x, y,
                            600, 30, 10, 10, --maxlen, len_t, maxwide, wide_t,
                            a,  --rot
                            "mul+add", Color(255, 255, 0, 0), "mul+add", Color(255, 255, 255, 0), --b1, c1, b2, c2
                            60, 30 --left_time, disappear_time
                    )
                    return obj
                end
                return create
            end
    )

    --激光
    B.laser1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a)
                    B.warning_laser1.create(x, y, a)
                    local obj = New(lead_laser,
                            1, COLOR_PURPLE, --type, co
                            x, y, 10, a, --x, y, v, a
                            600, 20, 20, 1, --len, w0, w1, t
                            true, false, _infinite --islock, isshoot, last_time
                    )
                    return obj
                end
                return create
            end
    )

    --中间的小星弹
    B.bullet2_1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, v0, v1, a, t0, t1, style, color)
                    local obj = stg.newSimpleBullet(x, y, style, color)
                    task.New(obj, function()
                        velch(obj, v0, v1, a, t0, t1)
                    end)
                    return obj
                end
                return create
            end
    )

    B.bullet3_1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local style, color = stg.arrow_small_b, COLOR_CYAN
                local function create(x, y, v, a, dt, v1, a1)
                    local obj = stg.newSimpleBullet(x, y, stg.star_small, color)
                    obj.bound = false
                    obj.rot = a
                    obj.omiga = 6
                    robject.set_color(obj, "mul+add", 0, 255, 255, 255)
                    alphaChangeTask(obj, 0, 255, 60)
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET - 1
                        accdecVelch(obj, v, a, 60, 60 + dt, 1)
                        PlaySound("kira00")
                        stg.setBoundTime(stg.newStrChV(obj.x, obj.y, 0.5, v1, a1, 60, 20, style, color), 90)
                        _del(obj, true)
                    end)
                end
                return create
            end
    )

    --大光玉
    B.bullet4 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v2 = switch1(diff, {
                    1.25, 1.35, 1.45, 1.55, 1.55
                })*defaultSwitchVelocityByRank(rank)
                local count = switch1(diff, {
                    4, 6, 7, 8, 8
                }) + switch(rank, {
                    0, 0, 0, 0, 2
                })
                local dv = switch1(diff, {
                    0.25, 0.25, 0.25, 0.25, 0.25
                })*defaultSwitchVelocityByRank(rank)
                local wait = 4
                local function create(x, y, a)
                    local obj = stg.newBullet(x, y, stg.ball_light, COLOR_DEEP_BLUE)
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    obj.rot = a
                    obj.hide = true
                    obj.colli = false
                    obj.bound = false
                    task.New(obj, function()
                        SetV(obj, 6, 90)
                        for i = 0, count - 1 do
                            B.grain_a.create(obj.x, obj.y, 0, v2 + dv*i, -90, 30, 0)
                            task.Wait(wait)
                        end
                        obj.bound = true
                    end)
                end
                return create
            end
    )

    B.grain_a = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, v0, v1, a, t0, t1)
                    local obj = stg.newSimpleBullet(x, y, stg.water_drop, COLOR_RED)
                    robject.set_color(obj, "mul+add", 0, 255, 255, 255)
                    obj.colli = false
                    obj.rot = -90
                    boundWait(obj, 60)
                    setSize(obj, 5, 5)
                    task.New(obj, function()
                        alphaAndSizeChange(obj, 255, -4, 30)
                        obj._blend = ""
                        obj.colli = true
                        velch(obj, v0, v1, a, t0, t1)
                    end)
                end
                return create
            end
    )

    --endregion
    --region 子弹发射点定义
    --偏向一侧的加速串弹
    P.pointer1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = 8*defaultSwitchVelocityByRank(rank)
                local way = 4
                local style, color = stg.grain_a, COLOR_ORANGE
                local function attack(x, y, a, da)
                    PlaySound("tan00")
                    local function bullet_func(x, y, v, a)
                        robject.set_color(stg.newSimpleStraight(x, y, v, a, style, color), "", 255, 255, 255, 255)
                    end
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_normal1(x, y, v, a, way, da, bullet_func)
                            end)
                end
                return attack
            end
    )

    --画星星的单个弹幕
    P.pointer2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = 6
                local r = 30
                local function attack(b, x, y, a, u, dway)
                    PlaySound("kira00")
                    local function bullet_func(x, y, v, a)
                        T.tasker2.main(b, x, y, r, a, u)
                    end
                    circle_normal1(x, y, 0, a, way + dway, bullet_func)
                end
                return attack
            end
    )

    P.pointer2_1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = switch1(diff, {
                    2, 3, 3, 3, 3
                })
                local da = switch1(diff, {
                    4, 4, 20, 20, 5
                })
                local style, color = stg.star_small, COLOR_YELLOW - 1
                local function attack(x, y, v, a, t0, t1, u)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                local w = (way - 1)/2
                                for i = -w, w do
                                    B.bullet2_1.create(x, y, 0, v, a + da*i, t0, t1, style, color).omiga = 3*u
                                end
                            end)
                end
                return attack
            end
    )

    P.pointer3_1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.ball_big, COLOR_RED
                local v = switch1(diff, {
                    1, 1, 1, 1.5, 1
                })*defaultSwitchVelocityByRank(rank)
                local layer = switch1(diff, {
                    1, 1, 1, 1, 1
                }) + switch(rank, {
                    0, 0, 0, 0, 1
                })
                local dv = 0.25*defaultSwitchVelocityByRank(rank)
                local function attack(x, y, a)
                    --PlaySound("tan00")
                    for i = 0, layer - 1 do
                        robject.set_color(stg.newStrChV(x, y, 0, v + dv*i, a, 30, 0, style, color), "mul+add", 255, 255, 255, 255)
                    end
                end
                return attack
            end
    )

    --大光玉
    P.pointer4 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local function attack(x, y)
                    B.bullet4.create(x, y, -90)
                end
                return attack
            end
    )

    --护身弹
    P.pointer5 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = 59
                local v = 6*defaultSwitchVelocityByRank(rank)
                local style, color = stg.ball_mid_c, COLOR_YELLOW
                local function bullet_func(x, y, v, a)
                    local obj = stg.newSimpleStraight(x, y, v, a, style, color)
                    --obj.a, obj.b = 1.25*obj.a, 1.25*obj.b
                end
                local function attack(x, y, a)
                    circle_normal1(x, y, v, a, way, bullet_func)
                end
                return attack
            end
    )
    --endregion
    --region Death Defined
    --endregion
    --region 自定义敌人
    --endregion
    --region Tasker 任务执行器
    --开幕四个机翼的演出
    T.tasker1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local wait = 4
                local da0 = 25
                --达到最小移动范围要攻击的次数
                local t = switch1(diff, {
                    600, 550, 500, 450, 450
                })
                local d_da = -10/t
                local function main(b, u)
                    boss.createTasker(b, b.x, b.y,
                            function(obj)
                                local x, y = -150*u, 175
                                task.New(obj, function()
                                    local da = da0
                                    for _ = 1, t do
                                        P.pointer1.attack(x, y, Angle(x, y, player.x, player.y), da)
                                        task.Wait(wait)
                                        da = da + d_da
                                    end
                                    for _ = 1, _infinite do
                                        P.pointer1.attack(x, y, Angle(x, y, player.x, player.y), da)
                                        task.Wait(wait)
                                    end
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --中间的大星星
    T.tasker2 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local dr = 1
                local count = switch1(diff, {
                    6, 6, 6, 6, 6
                })
                local wait = switch1(diff, {
                    8, 7, 8, 6, 6
                })
                local da = 30/(count*wait)
                local layer = 2
                local v0 = switch1(diff, {
                    1.5, 2, 2.5, 3, 3
                })
                local da_c = -3*da*wait
                local function main(b, x, y, r, a, u)
                    boss.createTasker(b, x + r*cos(a), y + r*sin(a),
                            function(obj)
                                boundWait(obj, 180)
                                --移动逻辑
                                involuteMoveTask(obj, x, y, r, dr, a, da*u, _infinite)
                                --产生子弹
                                task.New(obj, function()
                                    task.Wait(1)
                                    local c = (count - 1)/2
                                    for i = 0, layer - 1 do
                                        for j = -c, c do
                                            a = Angle(0, 0, obj.dx, obj.dy) + 0*u
                                            P.pointer2_1.attack(obj.x, obj.y, v0, a + da_c*j*u, 60, 45 + (wait + 6)*(count - 1 - (j+c)) + 5*i*count, u)
                                            task.Wait(wait)
                                        end
                                    end
                                    _del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --非符流星弹
    T.tasker3 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    8, 10, 13, 16, 18
                })
                local da0 = switch(rank, {
                    120, 120, 120, 120, 100
                })
                local da = (switch1(diff, {
                    -60, -60, -60, -60, -60
                })*switch(rank, {
                    1, 1, 1, 1, 0.25
                }))/(count - 1)
                local wait = 80/count
                local function main(b, x, y, a, u)
                    boss.createTasker(b, x, y,
                            function(obj)
                                obj.bound = false
                                task.New(obj, function()
                                    velchTask(obj, 4, 8, a, 60)
                                    task.Wait(ran:Int(0, wait))
                                    for i = 0, count - 1 do
                                        P.pointer3_1.attack(obj.x, obj.y, a - (da0 + da*i)*u)
                                        task.Wait(wait)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --坠落之星
    T.tasker4 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local t = 30
                local count = 30
                local wait = 4
                local function main(b, x, y, a)
                    boss.createTasker(b, x, y,
                            function(obj)
                                obj.bound = false
                                task.New(obj, function()
                                    velchTask(obj, 4, 12, a, t)
                                    task.Wait(ran:Int(0, wait))
                                    for j = 0, count - 1 do
                                        P.pointer4.attack(obj.x, obj.y)
                                        task.Wait(wait)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --护身弹
    T.tasker5 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local wait = 10
                local function main()
                    boss.createTasker(_boss, _boss.x, _boss.y,
                            function(obj)
                                task.New(obj, function()
                                    while true do
                                        if Dist(_boss, player) < 100 then
                                            P.pointer5.attack(_boss.x, _boss.y, Angle(_boss, player))
                                        end
                                        task.Wait(wait)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --endregion
    --region 组合攻击
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main()
                    T.tasker5.main()
                end
                return main
            end)

    C.SECOND = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local wait = switch1(diff, {
                    144, 135, 144, 120, 120
                })
                local function main(b)
                    task.New(b, function()
                        local a
                        while true do
                            if system.PowerRank.getRank() == 4 then
                                a = Angle(b, player)
                            else
                                a = -90
                            end
                            for u = -1, 1, 2 do
                                P.pointer2.attack(b, b.x, b.y, a, u, 0)
                            end
                            task.Wait(wait)
                        end
                    end)
                    task.Wait(120)
                end
                return main
            end)

    C.THIRD = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main(b)
                    task.New(b, function()
                        while true do
                            for u = -1, 1, 2 do
                                T.tasker3.main(b, -224*u, 150, 90*(1-u), u)
                                task.Wait(90)
                            end
                        end
                    end)
                end
                return main
            end)

    C.FORTH = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main(b)
                    task.New(b, function()
                        while true do
                            for u = -1, 1, 2 do
                                T.tasker4.main(b, -224*u, 50, -90 + 95*u)
                                task.Wait(90)
                            end
                        end
                    end)
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
                    AchievementReminder.unlock("s4_sc4", "海底的大教堂:Easy", "成功双倍收取勒夏的符卡「中世纪的魔女偶像」")
                end,
                function()
                    AchievementReminder.unlock("s4_sc4", "海底的大教堂:Easy", "成功双倍收取勒夏的符卡「中世纪的魔女偶像」")
                    AchievementReminder.unlock("s4_sc4", "海底的大教堂:Normal", "成功双倍收取勒夏的符卡「中世纪的魔女偶像」")
                end,
                function()
                    AchievementReminder.unlock("s4_sc4", "海底的大教堂:Easy", "成功双倍收取勒夏的符卡「中世纪的魔女偶像」")
                    AchievementReminder.unlock("s4_sc4", "海底的大教堂:Normal", "成功双倍收取勒夏的符卡「中世纪的魔女偶像」")
                    AchievementReminder.unlock("s4_sc4", "海底的大教堂:Hard", "成功双倍收取勒夏的符卡「中世纪的魔女偶像」")
                end,
                function()
                    AchievementReminder.unlock("s4_sc4", "海底的大教堂:Easy", "成功双倍收取勒夏的符卡「中世纪的魔女偶像」")
                    AchievementReminder.unlock("s4_sc4", "海底的大教堂:Normal", "成功双倍收取勒夏的符卡「中世纪的魔女偶像」")
                    AchievementReminder.unlock("s4_sc4", "海底的大教堂:Hard", "成功双倍收取勒夏的符卡「中世纪的魔女偶像」")
                    AchievementReminder.unlock("s4_sc4", "海底的大教堂:Lunatic", "成功双倍收取勒夏的符卡「中世纪的魔女偶像」")
                end,
            })
            if achi_func then
                achi_func()
            end]]
            achievement.unlock("s4_sc4", true, true)
        end
    end
    
    local function bossAction(b)
        task.Wait(60)
        for _ = 1, 3 do
            New(AbsorbEffect2, b.x, b.y, 255, 255, 0, "mul+add")
            PlaySound("ch00")
            task.Wait(20)
        end
    end
    
    local names = {
        "name-boss6-card4-E",
        "name-boss6-card4-N",
        "name-boss6-card4-H",
        "name-boss6-card4-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "finalspell", --类型
            {3, 3, 60}, --时间
            3600, --耐久
            {50, 50}, --掉落
            function(b) --普通模式攻击前动作
                task.Wait(60)
                task.MoveTo(b, 0, 120, 60, MOVE_NORMAL)
                bossAction(b)
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 120
                bossAction(b)
                boss.show_aura(b, true)
            end,
            function(b) --main
                reFresh()
                --护身弹
                C.FIRST.main()
                task.New(b, function()
                    while true do
                        reFresh()
                        task.Wait(1)
                    end
                end)
                --开幕
                do
                    for u = -1, 1, 2 do
                        --四个机翼
                        T.tasker1.main(b, -u)
                        T.tasker1.main(b,  u)
                        --拉线弹幕
                    end
                    C.SECOND.main(b)
                    task.Wait(240)
                    C.FORTH.main(b)
                    task.Wait(300)
                    C.THIRD.main(b)
                end
                task.Wait(60)
            end,
            function(b) --finish
                doubleAchievement(b)
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
