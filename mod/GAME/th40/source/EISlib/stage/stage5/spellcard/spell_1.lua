-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage5/spellcard/spell_1.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local alpAndSizeCh = EGGlib.ObjectEvent.alphaAndSizeChange
local disapear = EGGlib.ObjectEvent.disappear
local accdecVelchTask = EGGlib.ObjectEvent.accDecVelocityChangeTask
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local sizeAndColliChangeTask = EGGlib.ObjectEvent.sizeAndColliChangeTask
local sizeAndColliChange = EGGlib.ObjectEvent.sizeAndColliChange
local warning_laser = EISlib.Bullet.Laser.warning_laser
local sect_normal1 = EGGlib.BulletGroup.Sector.normal1
local simPar = EGGlib.ObjectEvent.simPar
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local alphaAndSizeChangeTask = EGGlib.ObjectEvent.alphaAndSizeChangeTask
local move = EGGlib.ObjectEvent.moveToPlayerDefault

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    --小麦/草 种子
    B.bullet1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local color = switch1(diff, {
                            COLOR_YELLOW, COLOR_YELLOW, COLOR_GREEN, COLOR_GREEN, COLOR_GREEN
                        })
                local color2 = switch1(diff, {
                    Color(175, 255, 255, 0), Color(175, 255, 255, 0), Color(175, 0, 255, 0), Color(175, 0, 255, 0), Color(175, 0, 255, 0)
                })
                local way = (switch1(diff, {
                    1, 1, 4, 4, 4
                }) - 1)/2
                local function create(x, y, t, u, dt)
                    local obj = stg.newSimpleBullet(x, y, stg.ball_light, color, true)
                    obj.bound = false
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    accdecVelchTask(obj, 6, -90, 30, t, 30)
                    setSizeAndColli(obj, 0.1, 0.1)
                    sizeAndColliChangeTask(obj, 1.9, 30)
                    task.New(obj, function()
                        task.Wait(30)
                        sizeAndColliChange(obj, -1.5, t) --匀速下落时
                        sizeAndColliChange(obj, -0.4, 30) --减速下落时
                        for i = -way*u, way*u, u do
                            B.bullet2.create(obj.x, obj.y, 90 + 20*i + ran:Float(-7.5, 7.5), 0.5*(u + 1), dt)
                            task.Wait(4)
                        end
                        _del(obj, true)
                    end)
                    task.New(obj, function()
                        while obj.y > -224 do
                            task.Wait(1)
                        end
                        PlaySound("lazer00")
                        New(warning_laser, obj.x, obj.y,
                                460, 20, 6, 5, 90, --len, l_t, wide, w_t, a
                                "mul+add", color2,
                                60 --disappear
                        )
                    end)
                end
                return create
            end
    )

    --长出来的小麦/草的发弹器
    B.bullet2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v0 = switch1(diff, {
                    4.25, 4.25, 4.25, 4.25, 4.25
                })
                local color = switch1(diff, {
                    COLOR_YELLOW, COLOR_YELLOW, COLOR_GREEN, COLOR_GREEN, COLOR_GREEN
                })
                local function create(x, y, a, i, dt)
                    local obj = stg.newBullet(x, y, stg.grain_a, color, true)
                    obj.colli = false
                    obj.hide = true
                    obj.bound = false
                    obj.navi = true
                    robject.set_color(obj, "", 255, 255, 255, 255)
                    task.New(obj, function()
                        simPar(obj, v0, 90, 0.03*cos(a), ran:Float(-5, 5)) --v, va, acc, acca
                        task.Wait(1)
                        if diff < 3 then --EN难度会长侧枝
                            task.New(obj, function()
                                task.Wait(30)
                                local a
                                for num = 1, 10 do
                                    for u = -1, 1, 2 do
                                        a = obj.rot + 30*u
                                        B.bullet4.create(obj.x + 15*cos(a), obj.y + 15*sin(a), a, i, num)
                                    end
                                    task.Wait(8)
                                end
                            end)
                        end
                        for num = 1, 40 do
                            B.bullet3.create(obj.x, obj.y, obj.rot, i, num, dt)
                            task.Wait(3)
                        end
                        _del(obj, true)
                    end)
                end
                return create
            end
    )


    --长出来的小麦/草
    B.bullet3 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v0 = switch1(diff, {
                    1.81, 1.81, 2.27, 2.72, 2.72
                })*defaultSwitchVelocityByRank(rank)
                local color = switch1(diff, {
                    COLOR_YELLOW, COLOR_YELLOW, COLOR_GREEN, COLOR_GREEN, COLOR_GREEN
                })
                local function create(x, y, a, i, num, dt)
                    local obj = stg.newBullet(x, y, stg.grain_a, color, true)
                    obj.bound = false
                    obj.rot = a
                    robject.set_color(obj, "", 255, 255, 255, 255)
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET - 1
                        task.Wait(60)
                        sizeAndColliChangeTask(obj, -1, 30)
                        velch(obj, 0, v0, a, 30)
                        if diff > 2 and obj.y > -150 and num%4 == 0 and Dist(obj, player) > 80 then
                            PlaySound("stone")
                            stg.newStrChV(obj.x, obj.y, v0,  0.1, -90 + ran:Float(-15, 15), dt, 30, stg.money, COLOR_GREEN, true).omiga = 1
                        end
                        _del(obj, true)
                    end)
                end
                return create
            end
    )

    --长出来的小麦/草(EN限定
    B.bullet4 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v0 = switch1(diff, {
                    2, 2, no_info, no_info, no_info
                })
                local color = switch1(diff, {
                    COLOR_ORANGE, COLOR_ORANGE, no_info, no_info, no_info
                })
                local function create(x, y, a, i, num)
                    local obj = stg.newBullet(x, y, stg.grain_a, color, true)
                    obj.bound = false
                    obj.rot = a
                    obj.navi = true
                    robject.set_color(obj, "", 255, 255, 255, 255)
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET
                        task.Wait(60)
                        velch(obj, 0, v0 + ran:Float(-0.5, 0.5), a, 30)
                        if num%2 == 0 and Dist(obj, player) > 80 then
                            sizeAndColliChangeTask(obj, -1, 30)
                            PlaySound("stone")
                            local b = stg.newStrChV(obj.x, obj.y, 0, 0, obj.rot, 90, 0, stg.money, COLOR_GREEN, true)
                            simPar(b, v0, a, 0.04, -90)
                            b.omiga = 3
                        else
                            obj.ay = -0.02 + ran:Float(0.0025, -0.0025)
                        end
                        obj.bound = true
                    end)
                end
                return create
            end
    )

    --诱导苦无
    B.arrow_small = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v = switch1(diff, {
                    1.2, 1.3, 1.4, 1.5, 1.5
                })*defaultSwitchVelocityByRank(rank)
                local dv = switch1(diff, {
                    0.3, 0.3, 0.3, 0.3, 0.3
                })*defaultSwitchVelocityByRank(rank)
                local function create(x, y, dv_i, a, dt)
                    local obj = stg.newSimpleBullet(x, y, stg.arrow_small, COLOR_PURPLE)
                    obj.rot = a
                    task.New(obj, function()
                        local v = v + dv_i*dv
                        velch(obj, 2, v, a, 20, dt)
                    end)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义
    --飞刀
    P.pointer1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.arrow_small, COLOR_PURPLE
                local way = switch1(diff, {
                    12, 16, 20, 24, 24
                })
                local da = 360/way
                local d_da = da/3
                local function attack(x, y, i, a, u, dt)
                    PlaySound("tan00")
                    local function bullet_func(x, y, _, a)
                        B.arrow_small.create(x, y, i, a, dt)
                    end
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_normal1(x, y, 0, a + i*d_da,
                                        way, da,
                                        bullet_func
                                )
                            end)
                end
                return attack
            end
    )
    --endregion
    --region 自定义敌人
    --endregion
    --region Tasker 任务执行器
    T.tasker1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local way = switch1(diff, {
                    4, 6, 4, 4, 4
                })
                local wait = 40/way
                local x0 = switch(rank, {
                    220, 220, 220, 220, 190
                })
                local dx = switch(rank, {
                    -400, -400, -440, -440, -380
                })/(way - 1)
                local function main(b, u, t, dt)
                    boss.createTasker(b, b.x, b.y,
                            function(obj)
                                task.New(obj, function()
                                    for i = 0, way - 1 do
                                        B.bullet1.create((x0 + dx*i)*u, 190, t, u, dt)
                                        task.Wait(wait)
                                    end
                                    if diff > 3 then --HL有两轮
                                        task.Wait(50)
                                        for i = 0, way - 1 do
                                            B.bullet1.create(-(x0 + dx*i)*u, 190, t, -u, dt)
                                            task.Wait(wait)
                                        end
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --刀子攻击
    T.tasker2 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    3, 4, 4, 5, 5
                })
                local wait = 6
                local function main(b, u)
                    boss.createTasker(b, b.x, b.y,
                            function(obj)
                                task.New(obj, function()
                                    local a = Angle(b, player)
                                    for i = 0, count - 1 do
                                        P.pointer1.attack(b.x, b.y, i, a, u, (wait + 2)*(count - 1 - i))
                                        task.Wait(wait)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
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
    --region 组合攻击
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local rate = switch1(diff, {
                    1, 1, 1.2, 1, 1
                })
                local function main(b)
                    local atkcount = {4, 5, 6, 7}
                    local count
                    local function atk1(i)
                        T.tasker1.main(b, tranU(i), 47 + 1*i, (120 + 20*i)*rate)
                    end
                    local function atk2(count)
                        for i = 1, count do
                            T.tasker2.main(b, tranU(i))
                            move(30, b)
                            task.Wait(30)
                            task.Wait(10)
                        end
                    end
                    atk1(4)
                    atk2(6)
                    task.Wait(120)
                    for i = 3, 0, -1 do
                        reFresh()
                        atk1(i)
                        count = atkcount[4-i]
                        task.Wait(300 - 40*count)
                        atk2(count)
                        task.Wait(80)
                    end
                    while true do
                        reFresh()
                        atk1(0)
                        task.Wait(300 - 40*count)
                        atk2(count)
                        task.Wait(80)
                    end
                end
                return main
            end)
    --endregion
    
    local names = {
        "name-boss7-card2-E",
        "name-boss7-card2-N",
        "name-boss7-card2-H",
        "name-boss7-card2-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "spellcard", --类型
            {3, 3, 50}, --时间
            2400, --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                task.wait(60)
                task.MoveTo(b, 0, 144, 60, MOVE_ACC_DEC)
                PlaySound("wolf")
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 144
                boss.show_aura(b, true)
                PlaySound("wolf")
            end,
            function(b) --main
                reFresh()
                C.FIRST.main(b, 1)
            end,
            function(b) --finish
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
