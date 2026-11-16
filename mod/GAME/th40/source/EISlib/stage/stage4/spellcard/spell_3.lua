-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage4/spellcard/spell_3.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local alpAndSizeCh = EGGlib.ObjectEvent.alphaAndSizeChange
local disapear = EGGlib.ObjectEvent.disappear
local decAccVelocityChange = EGGlib.ObjectEvent.decAccVelocityChange
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local sect_normal = EGGlib.BulletGroup.Sector.normal1
local sty = EISlib.Enemy.Style
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local tranRot = EGGlib.Math.TranRot
local setSize = EGGlib.ObjectEvent.setSize
local rebound = EGGlib.ObjectEvent.rebound
local AbsorbEffect2 = EGGlib.RenderEffect.AbsorbEffect2
local accDecMoveToPointTask = EGGlib.ObjectEvent.accDecMoveToPointTask
local warning_laser = EISlib.Bullet.Laser.warning_laser
local boundWait = EGGlib.ObjectEvent.boundWait
local tri_circle3 = EGGlib.BulletGroup.TriAngleStroke.circle3

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
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
    --region Bullet 自定义子弹
    --雷电弹幕
    B.lightning = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a, no_create_bullet, dt, co)
                    local obj = stg.newSimpleBullet(x, y, stg.arrow_mid, co)
                    obj.rot = a
                    obj.colli = false
                    robject.set_color(obj, "mul+add", 0, 255, 255, 255)
                    setSize(obj, 6, 6)
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET - 1
                        alphaAndSizeChange(obj, 150, -5, 30)
                        --obj.colli = true
                        task.Wait(dt)
                        if not no_create_bullet then
                            --stg.newStrChV(obj.x, obj.y, 0, v, -90, 120, wt, stg.ball_mid_c, co, false, -1)
                            B.ball_mid_c.create(obj.x, obj.y, co)
                        end
                        _del(obj, true)
                    end)
                end
                return create
            end
    )

    --竖直向下掉的环玉
    B.ball_mid_c = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v = switch1(diff, {
                    1, 1.1, 1.2, 1.3, 1.3
                })*defaultSwitchVelocityByRank(rank)
                local function create(x, y, co)
                    local obj = stg.newBullet(x, y, stg.ball_mid_c, co)
                    velchTask(obj, 0, v, -90, 240)
                    --一定时间后要消失的
                    task.New(obj, function()
                        task.Wait(420)
                        _del(obj, true)
                    end)
                end
                return create
            end
    )

    --大雷电弹幕
    B.big_lightning = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v = switch1(diff, {
                    1, 1, 1, 1, 1
                })*defaultSwitchVelocityByRank(rank)
                local wt = switch1(diff, {
                    120, 120, 120, 120, 120
                })
                local function create(x, y, a, dt, da, u, no_create_bullet)
                    local obj = stg.newSimpleBullet(x + 40*cos(a + 90*u), y + 40*sin(a + 90*u), stg.ball_mid, COLOR_YELLOW, true)
                    obj.rot = a
                    obj.colli = false
                    robject.set_color(obj, "mul+add", 0, 255, 255, 255)
                    setSize(obj, 5, 5)
                    --velchTask(obj, 4, 0, a + da, 60)
                    accDecMoveToPointTask(obj, x - 10*cos(a + 90*u), y - 10*sin(a + 90*u), 1, 0, 59)
                    task.New(obj, function()
                        alphaAndSizeChange(obj, 150, -3, 30 + dt)
                        setSize(obj, 1, 1)
                        if not no_create_bullet then
                            PlaySound("thunder")
                            P.silence.attack(obj.x, obj.y, a + da)
                        end
                        _del(obj, true)
                    end)
                    --判定模块
                    task.New(obj, function()
                        task.Wait(25)
                        obj.a, obj.b = 10, 5
                        obj.colli = true
                        obj.rect = true
                    end)
                end
                return create
            end
    )

    --预警线
    B.warning_laser = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, rot)
                    local obj = New(warning_laser,
                            x, y,
                            600, 10, 15, 5, rot, --len, l_t, wide, w_t, a
                            "mul+add", Color(255, 255, 0, 0), --blend, color
                            45 --disappear
                    )
                    warning_laser.setTrailLength(obj, 40)
                    obj.bound = false
                end
                return create
            end
    )

    --endregion
    --region 子弹发射点定义
    --雷电弹幕
    P.lightning = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local function attack(x, y, a, no_create_bullet, dt, co)
                    PlaySound("kira00")
                    B.lightning.create(x, y, a, no_create_bullet, dt, co)
                end
                return attack
            end
    )

    --大雷电弹幕
    P.big_lightning = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local function attack(x, y, a, dt, da, u, no_create_bullet)
                    PlaySound("kira00")
                    B.big_lightning.create(x, y, a, dt, da, u, no_create_bullet)
                end
                return attack
            end
    )


    P.silence = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = switch1(diff, {
                    1, 1, 1, 1, 1
                })*defaultSwitchVelocityByRank(rank)
                local dv = switch1(diff, {
                    0.5, 0.5, 0.5, 0.5, 0.5
                })*defaultSwitchVelocityByRank(rank)
                local style, color = stg.silence, COLOR_ORANGE
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 0.5, v, a, 30, 30, style, color)
                end
                local function attack(x, y, a)
                    PlaySound("kira00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                for i = 0, 1 do
                                    bullet_func(x, y, v + dv*i, a)
                                end
                                for i = 0, 1 do
                                    bullet_func(x, y, v + dv*(i + 2), a + 180)
                                end
                            end)
                end
                return attack
            end
    )


    P.triangle = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                --case：一侧边有多少个
                local bunch = switch1(diff, {
                    2, 2, 3, 3, 3
                })
                --case:way数
                local way = switch1(diff, {
                    20, 24, 28, 32, 32
                })
                --case：每way之间角度差
                local da = switch1(diff, {
                    1, 1, 1, 1, 1
                }) --每way间的间隔
                --case：初始弹速
                local v0 = switch1(diff, {
                    1.5, 1.75, 2, 2.5, 3
                })*defaultSwitchVelocityByRank(rank)
                --case：相邻弹幕速度差
                local dv0 = switch1(diff, {
                    0.1, 0.1, 0.125, 0.15, 0.2
                })*defaultSwitchVelocityByRank(rank)
                local style, color = stg.ball_mid_c, COLOR_DEEP_RED
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStraight(x, y, v, a, style, color)
                end
                local function attack(x, y, a)
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                tri_circle3(x, y, v0 + dv0*(bunch - 1), -dv0, a, da, bunch, --base
                                        way, --way
                                        bullet_func
                                )
                            end)
                end
                return attack
            end
    )

    --endregion
    --region 死尸弹
    D.death1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local main
                if diff < 3 then --EN
                    function main(e)
                    end
                else --HL
                    function main(e)
                        PlaySound("kira00")
                        local x, y = e.x, e.y
                        enemy.createDeath(
                                20, --total_time,
                                function()
                                    P.pointer2.attack(x, y, Angle(x, y, player.x, player.y), ran:Sign())
                                end)
                    end
                end
                return main
            end)
    --endregion
    --region 自定义敌人
    --endregion
    --region Tasker 任务执行器
    --闪电生成器
    T.lightning = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                --垂直于闪电方向的范围参数
                local range0 = 5
                local d_range = switch1(diff, {
                    2, 2, 2, 2, 2
                })
                local count = switch1(diff, {
                    5, 5, 5, 5, 5
                })
                local rebound_count = switch1(diff, {
                    1, 1, 2, 2, 2
                })
                --每隔n个子弹消除掉会额外生成一个向下的环玉
                local n = switch1(diff, {
                    4, 3, 3, 2, 2
                })
                --生成器飞行速度
                local v = 15
                local color_list = {COLOR_YELLOW, COLOR_YELLOW}
                local function main(b, x, y, a, u, dt)
                    boss.createTasker(b, x, y,
                            function(obj)
                                obj.bound = false
                                SetV(obj, v, a)
                                --发弹逻辑
                                task.New(obj, function()
                                    local dx0, dy0, dx1, dy1, rate, rot
                                    local r = range0
                                    local no_create_bullet = false
                                    local i = 0
                                    while true do
                                        dx0, dy0 = tranRot(0, u*0.5*r, a - 0)
                                        dx1, dy1 = tranRot(0, -u*0.5*(r + d_range), a - 0)
                                        rot = Angle(dx0, dy0, dx1 + count*v*cos(a), dy1 + count*v*sin(a))
                                        for j = 0, count - 1 do
                                            if i%n == 0 then
                                                no_create_bullet = false
                                            else
                                                no_create_bullet = true
                                            end
                                            rate = j/count
                                            P.lightning.attack(obj.x + dx0 + rate*(dx1 - dx0), obj.y + dy0 + rate*(dy1 - dy0),
                                                    rot, no_create_bullet, --a, no_create_bullet
                                                    dt + (130 - 2*i), color_list[i%2+1]
                                            )
                                            task.Wait(1)
                                            i = i + 1
                                        end
                                        r = r + d_range
                                        u = -u
                                    end
                                end)

                                --移动逻辑（反弹）
                                task.New(obj, function()
                                    task.Wait(10)
                                    for _ = 0, rebound_count - 1 do
                                        rebound(obj, 1)
                                        a = Angle(0, 0, obj.vx, obj.vy)
                                        task.Wait(30)
                                    end
                                    obj.bound = true
                                end)
                            end, false) --iswait
                end
                return main
            end)


    --大型自机狙闪电生成器
    T.big_lightning = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                --垂直于闪电方向的范围参数
                local range0 = 0
                local d_range = switch1(diff, {
                    0, 0, 0, 0, 0
                })
                local count = switch1(diff, {
                    5, 5, 5, 5, 5
                })
                --每隔n个子弹消除掉会额外生成一个向下的环玉
                local n = switch1(diff, {
                    5, 4, 3, 2, 2
                })
                local function main(b, x, y, a, u, x0, y0)
                    boss.createTasker(b, x, y,
                            function(obj)
                                boundWait(obj, 180)
                                SetV(obj, 15, a)
                                --发弹逻辑
                                task.New(obj, function()
                                    local dx0, dy0, dx1, dy1, rate
                                    local no_create_bullet = false
                                    local r = range0
                                    local i = 0
                                    while true do
                                        dx0, dy0 = tranRot(0, u*0.5*r, a - 0)
                                        dx1, dy1 = tranRot(0, -u*0.5*(r + d_range), a - 0)
                                        for j = 0, count - 1 do
                                            rate = j/count
                                            if i%n == 0 then
                                                no_create_bullet = false
                                            else
                                                no_create_bullet = true
                                            end
                                            P.big_lightning.attack(obj.x + x0 + dx0 + rate*(dx1 - dx0), obj.y + y0 + dy0 + rate*(dy1 - dy0), a, --x ,y, a
                                                    1*(40 - i), -90*u, u, --dt, da, u
                                                    no_create_bullet
                                            )
                                            i = i + 1
                                            task.Wait(1)
                                        end
                                        r = r + d_range
                                        u = -u
                                    end
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --三角形描边弹
    T.triangle = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                --三角形描边弹
                local da = 180/switch1(diff, {
                    16, 20, 20, 24, 24
                })
                local wait = switch(rank, {
                    30, 30, 30, 30, 30
                })
                local function main(b, x, y, count)
                    boss.createTasker(b, x, y,
                            function(obj)
                                task.New(obj, function()
                                    local a0 = ran:Float(0, 360)
                                    count = min(5, count)
                                    for i = 0, count - 1 do
                                        P.triangle.attack(obj.x, obj.y, a0 + da*i)
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
    --这是一个循环的攻击
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local way = switch1(diff, {
                    6, 8, 6, 8, 8
                })
                local da_w = switch1(diff, {
                    0, 0, 15, 12, 15
                })
                local dx_w = 360/(way - 1)
                local wait = 60/way

                local function main(b, count, u)
                    for i = 0, way - 1 do
                        T.lightning.main(b, (-180 + dx_w*i)*u, 224, ran:Float(-92.5, -87.5) + da_w*i*u, u, 60)
                        task.Wait(wait)
                    end
                    T.triangle.main(b, b.x, b.y, count)
                    task.Wait(90)
                end
                return main
            end)

    --三雷轰顶！
    C.SECOND = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                --这些参数都别乱动！
                local wait1 = switch(rank, {
                    110, 110, 110, 110, 70
                })
                local wait2 = switch(rank, {
                    0, 0, 0, 0, 120
                })
                local count = switch(rank, {
                    3, 3, 3, 3, 2
                })
                local function main(b)
                    --New(AbsorbEffect2, b.x, b.y, 255, 255, 0, "mul+add")
                    b.absorbEffect(b, 0)
                    PlaySound("ch00")
                    task.Wait(30)
                    b.breakEffect(b, 0)
                    PlaySound("enep02")
                    task.Wait(60)
                    local x, y, a, x0, y0
                    for _ = 1, count do
                        x, y, a = b.x, 224, Angle(b.x, 224, player.x, player.y)
                        PlaySound("sword")
                        for _ = 1, 3 do
                            B.warning_laser.create(x, y, a)
                            task.Wait(10)
                        end
                        PlaySound("ch00")
                        x0, y0 = tranRot(ran:Float(-10, 10), 0, a - 0)
                        for u = -1, 1, 2 do
                            T.big_lightning.main(b, x, y, a, u, x0, y0)
                        end
                        task.Wait(wait1)
                    end
                    if rank == 4 then
                        x, y, a = b.x, 224, Angle(b.x, 224, player.x, player.y)
                        PlaySound("sword")
                        for _ = 1, 3 do
                            for i = -1, 1 do
                                B.warning_laser.create(x, y, a + 35*i)
                            end
                            task.Wait(10)
                        end
                        --task.Wait(15)
                        PlaySound("ch00")
                        x0, y0 = tranRot(ran:Float(-10, 10), 0, a - 0)
                        for u = -1, 1, 2 do
                            for i = -1, 1 do
                                T.big_lightning.main(b, x, y, a + 35*i, u, x0, y0)
                            end
                        end
                        task.Wait(wait1)
                    end
                    task.Wait(wait2)
                end
                return main
            end)
    --endregion
    
    local names = {
        "name-boss6-card3-E",
        "name-boss6-card3-N",
        "name-boss6-card3-H",
        "name-boss6-card3-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "spellcard", --类型
            {3, 3, 60}, --时间
            3000, --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                b.cast("cast")
                task.Wait(96)
                task.MoveTo(b, 0, 144, 60, MOVE_NORMAL)
                --task.wait(60)
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 144
                boss.show_aura(b, true)
            end,
            function(b) --main
                b.protect = false --解除自身无敌
                reFresh()
                local count = 1
                while true do
                    reFresh()
                    for u = -1, 1, 2 do
                        C.FIRST.main(b, count, u)
                        C.SECOND.main(b)
                        count = count + 2
                    end
                end
            end,
            function(b) --finish
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
