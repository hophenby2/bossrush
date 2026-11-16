-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage2/spellcard/spell_3.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local function createCard(difficulty)
    local B, P, S, C, T, E = {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    local velch = EGGlib.ObjectEvent.velocityChange
    local accdecTask = EGGlib.ObjectEvent.accDecVelocityChangeTask
    local stopV = EGGlib.ObjectEvent.stopV
    --EN难度箭弹
    function B.bullet1(x, y, v0, dt, v1, a, style, color)
        local obj = stg.newSimpleBullet(x, y, style, color)
        obj.rot = a
        accdecTask(obj, v0, a, 30, dt, 30)
        task.New(obj, function()
            task.Wait(dt)
            task.clear(obj, true)
            stopV(obj, 30)
            PlaySound("kira00")
            velch(obj, 0, v1, a, 90, 0)
        end)
    end
    --HL难度箭弹（由EN改）
    local changeVelocity = EGGlib.ObjectEvent.changeVelocity
    function B.bullet2(x, y, v0, dt, v1, v2, a, da, style, color)
        local obj = stg.newSimpleBullet(x, y, style, color)
        obj.rot = a
        accdecTask(obj, v0, a, 30, dt, 30)
        task.New(obj, function()
            task.Wait(dt)
            task.clear(obj, true)
            stopV(obj, 30)
            PlaySound("kira00")
            changeVelocity(obj, 0, v1, a, da, 90, 90, true)
            velch(obj, 0, (v2 - v1), a + da, 45, 0)
            velch(obj, 0, (v1 - v2), a + da, 45, 0)
        end)
    end
    --HL难度旋转心弹
    function B.bullet3(x, y, v, a, u, style, color)
        local obj = stg.newSimpleBullet(x, y, style, color, false, -1)
        obj.rot = a
        task.New(obj, function()
            velch(obj, 0, v, a, 60, 0)
            changeVelocity(obj, v, v, a, 200*u, 360, 360, true)
        end)
    end
    --endregion
    --region 子弹发射器定义
    local curve_layerDv1 = EGGlib.BulletGroup.Curve.layerDv1
    P.pointer1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                --case：way数
                local bunch = switch1(diff, {
                    2, 3, 2, 3, no_info
                })
                local dv_b = switch1(diff, {
                    -0.5, -0.5, -0.5, -0.5, no_info
                })
                local da = switch1(diff, {
                    60, 30, 60, 30, no_info
                })
                --case：层数
                local layer = switch1(diff, {
                    1, 1, 1, 1, no_info
                })
                --case：每层弹速差
                local dv = switch1(diff, {
                    0.45, 0.3, 0.45, 0.3, no_info
                })
                --case：弹速
                local v0 = 2
                --case:最终速度
                local v1 = switch1(diff, {
                    2, 2.25, 2.5, 3, no_info
                })*defaultSwitchVelocityByRank(rank)
                local style, color = stg.arrow_mid, COLOR_YELLOW
                local attack
                if diff > 2 then --HL
                    --case:箭弹变向的偏转角度
                    local da0 = switch1(diff, {
                        no_info, no_info, 60, 60, no_info
                    }) + switch(rank, {
                        0, 0, 0, 0, 30
                    })
                    --减速后的速度
                    local v2 = switch1(diff, {
                        no_info, no_info, 1.75, 2, no_info
                    })
                    --创建子弹生成函数的函数
                    local function createBulletFuncFunc(dt, u)
                        local function bullet_func(x, y, v, a)
                            B.bullet2(x, y, v, dt, v1, v2, a, -da0*u, style, color)
                        end
                        return bullet_func
                    end
                    function attack(x, y, a, w, sp, dt)
                        w = w*0.5
                        PlaySound("tan00")
                        for u = -1, 1, 2 do
                            stg.newFadeEffect(x + w*cos(a + 90)*u, y + w*sin(a + 90)*u, style, color, false,
                                    function(obj)
                                        curve_layerDv1(obj.x, obj.y, v0, a + 0.5*sp*u, bunch, dv_b, da*u, --base
                                                layer, dv, 0, 0, --layer, dv_l, da_l, d_bunch
                                                createBulletFuncFunc(dt, u)
                                        )
                                    end)
                        end
                    end
                else --EN
                    function attack(x, y, a, w, sp, dt)
                        w = w*0.5
                        local function bullet_func(x, y, v, a)
                            B.bullet1(x, y, v, dt, v1, a, style, color)
                        end
                        PlaySound("tan00")
                        for u = -1, 1, 2 do
                            stg.newFadeEffect(x + w*cos(a + 90)*u, y + w*sin(a + 90)*u, style, color, false,
                                    function(obj)
                                        curve_layerDv1(obj.x, obj.y, v0, a + 0.5*sp*u, bunch, dv_b, da*u, --base
                                                layer, dv, 0, 0, --layer, dv_l, da_l, d_bunch
                                                bullet_func
                                        )
                                    end)
                        end
                    end
                end
                return attack
            end
    )
    --连续的红小玉
    local curve_normalDv1 = EGGlib.BulletGroup.Curve.normalDv1
    P.pointer2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local da
                --case：层数
                local bunch = switch1(diff, {
                    2, 4, 4, 6, no_info
                })
                --case：每层弹速差
                local dv = switch1(diff, {
                    0.5, 0.4, 0.4, 0.3, no_info
                })
                --case：弹速
                local v0 = switch1(diff, {
                    1, 1, 1, 1, no_info
                })*switch(rank, {
                    1, 1, 1, 1, 0.8
                })
                local style, color = stg.knife, COLOR_RED
                local attack
                if diff > 2 then
                    da = switch(rank, {
                        0, 0, 0, 0, -1
                    })
                else
                    da = switch(rank, {
                        0, 0, 0, 0, -3
                    })
                end
                function attack(x, y, a, w, sp)
                    w = w*0.5
                    local function bullet_func(x, y, v, a)
                        stg.newSimpleStrChV(x, y, v + 2, v, a, 20, 30, style, color)
                    end
                    PlaySound("tan00")
                    for u = -1, 1, 2 do
                        stg.newFadeEffect(x + w*cos(a + 90)*u, y + w*sin(a + 90)*u, style, color, false,
                                function(obj)
                                    curve_normalDv1(obj.x, obj.y, v0, a + 0.5*sp*u, bunch, dv, da*u,
                                            bullet_func
                                    )
                                end)
                    end
                end
                return attack
            end
    )
    --开花
    local circle_normal1 = EGGlib.BulletGroup.Circle.normal1
    local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
    P.pointer3 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                --case：way数
                local way = switch1(diff, {
                    12, 24, 12, 24, no_info
                })
                --case：初速度
                local v0 = switch1(diff, {
                    1.5, 2, 2.5, 2.5, no_info
                })*defaultSwitchVelocityByRank(rank)

                local layer = switch1(diff, {
                    1, 1, 1, 1, 1
                })

                local dv = switch1(diff, {
                    0, 0, 0, 0.5, 0.5
                })*defaultSwitchVelocityByRank(rank)
                local style, color = stg.heart, COLOR_GREEN
                local attack
                if diff > 2 then
                    --创建子弹生成函数的函数
                    local function createBulletFuncFunc(u)
                        local function bullet_func(x, y, v, a)
                            B.bullet3(x, y, v, a, u, style, color)
                        end
                        return bullet_func
                    end
                    function attack(x, y, a, u)
                        PlaySound("kira00")
                        stg.newFadeEffect(x, y, style, color, false,
                                function()
                                    circle_layer1(x, y, v0, a, way, layer, dv, 0, 0, createBulletFuncFunc(u))
                                end)
                    end
                elseif diff == 2 then
                    local function bullet_func(x, y, v, a)
                        stg.newSimpleStrChV(x, y, 0, v, a, 60, 0, style, color, false, -1)
                    end
                    function attack(x, y, a)
                        PlaySound("kira00")
                        stg.newFadeEffect(x, y, style, color, false,
                                function()
                                    circle_normal1(x, y, v0, a, way, bullet_func)
                                end)
                    end
                elseif diff == 1 then --E难度不发心弹
                    function attack(x, y, a)
                    end
                end
                return attack
            end
    )

    --防内避用的护身弹幕
    P.pointer4 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local maxv = 5 --最大初始速度
                --case：way数
                local way = switch1(diff, {
                    12, 18, 24, 36, no_info
                }) + switch(rank, {
                    0, 0, 0, 0, 12
                })
                --case：初速度
                local v0 = switch1(diff, {
                    1.5, 1.75, 2, 2.25, no_info
                })*defaultSwitchVelocityByRank(rank)
                local style, color = stg.arrow_mid, COLOR_DEEP_GREEN
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, v + (maxv - v0), v, a, 20, 20, style, color)
                end
                local function attack(x, y, a)
                    PlaySound("kira00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_normal1(x, y, v0, a, way, bullet_func)
                            end)
                end
                return attack
            end
    )
    --endregion
    --region Tasker 任务执行器
    --发黄箭
    T.tasker1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    10, 20, 20, 20, no_info
                })
                local wait = 40/count
                local da = 240/(count - 1)
                local w0 = switch1(diff, {
                    15, 10, 15, 10, no_info
                })
                local dw = (150 - w0)/(count - 1)
                local function main(b, x, y, a)
                    boss.createTasker(b, x, y,
                            function(obj)
                                SetV(obj, 2.25, a)
                                task.New(obj, function()
                                    for i = count - 1, 0, -1 do
                                        P.pointer1.attack(obj.x, obj.y, a, w0 + dw*i, da*i, wait*i)
                                        task.Wait(wait)
                                    end
                                    Del(obj)
                                end)
                    end, false) --不拖延
                end
                return main
            end)
    --发红刀子
    T.tasker2 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    10, 20, 15, 20, no_info
                })
                local wait = 40/count
                local w0 = switch1(diff, {
                    15, 10, 15, 10, no_info
                })
                local dw = (150 - w0)/(count - 1)
                --红小玉部分
                local a0 = switch1(diff, {
                    15, -360, 90, 90, no_info
                })
                local da0 = switch1(diff, {
                    540, 720, -430, -420, no_info
                })/(count - 1)
                local function main(b, x, y, a)
                    boss.createTasker(b, x, y,
                            function(obj)
                                SetV(obj, 2.25, a)
                                task.New(obj, function()
                                    for i = count - 1, 0, -1 do
                                        P.pointer2.attack(obj.x, obj.y, a, w0 + dw*i, a0 + da0*i)
                                        task.Wait(wait)
                                    end
                                    Del(obj)
                                end)
                            end, false) --不拖延
                end
                return main
            end)
    --endregion
    --region 组合攻击
    local move = function(t, obj)
        EGGlib.ObjectEvent.bossMoveTask(obj,
                -60, 60, 25, 30, --x_min, x_max, dx_min, dx_max
                144, 5, 10, t --y0, dy_min, dy_max, t
        )
    end
    local action = function(b)
        task.New(b, function()
            b.cast("attack_down_before")
            task.Wait(48)
            b.cast("attack_down_ing")
        end)
    end
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local wait = switch(rank, {
                    85, 80, 75, 70, 45
                })
                local main
                if rank < 4 then
                    function main(b, u)
                        action(b)
                        task.Wait(30)
                        T.tasker1.main(b, b.x, b.y, -90)
                        T.tasker2.main(b, b.x, b.y, -90)
                        task.Wait(wait - 30)
                        P.pointer3.attack(b.x, b.y, Angle(b, player), u)
                        task.Wait(30)
                        P.pointer3.attack(b.x, b.y, Angle(b, player), u)
                        move(30, b)
                        task.Wait(30)
                    end
                else
                    function main(b, u)
                        action(b)
                        task.Wait(30)
                        T.tasker1.main(b, b.x, b.y, -90)
                        T.tasker2.main(b, b.x, b.y, -90)
                        task.Wait(wait)
                        action(b)
                        T.tasker1.main(b, b.x, b.y, -90)
                        for u0 = -u, u, 2*u do
                            P.pointer3.attack(b.x, b.y, Angle(b, player), u0)
                            task.Wait(30)
                        end
                        move(30, b)
                        task.Wait(30)
                    end
                end
                return main
            end)

    --护身弹
    C.SECOND = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local wait = switch(rank, {
                    85, 80, 75, 70, 45
                })
                local function main(b)
                    task.New(b, function()
                        while true do
                            if Dist(b, player) < 200 then
                                P.pointer4.attack(b.x, b.y, Angle(b, player))
                                task.Wait(20)
                            end
                            task.Wait(1)
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
            rank = new_rank
        end
    end
    
    local names = {
        "name-boss3-card4-E",
        "name-boss3-card4-N",
        "name-boss3-card4-H",
        "name-boss3-card4-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "spellcard", --类型
            {3, 3, 60}, --时间
            2000, --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                task.Wait(60)
                task.MoveTo(b, 0, 144, 60, MOVE_ACC_DEC)
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 144
                boss.show_aura(b, true)
            end,
            function(b) --main
                C.SECOND.main(b)
                while true do
                    reFresh()
                    for u = -1, 1, 2 do
                        C.FIRST.main(b, u)
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