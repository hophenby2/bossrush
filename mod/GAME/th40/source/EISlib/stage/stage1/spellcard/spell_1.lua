-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage1/spellcard/spell_1.lua" --当前存放目录
local function createCard(difficulty)
    local A, B, C, T, E = {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    local addVeloCh = EGGlib.ObjectEvent.velocityChange
    local chVelo = EGGlib.ObjectEvent.addChangeVelocity
    --转折弹
    function B.bullet1(x, y, v0, a, dv, da, func)
        local obj = stg.newBullet(x, y, stg.ball_huge, COLOR_RED)
        robject.set_color(obj, "mul+add", 255, 255, 255, 255)
        obj.bound = false
        obj.rot = a
        task.New(obj, function()
            obj.layer = LAYER_ENEMY_BULLET-1
            addVeloCh(obj, v0, 0.5, a, 90)
            obj.rot = a + da
            EGGlib.RenderEffect.simpleTrail(obj, -1) --创建一个默认拖影
            --生成子弹模块
            local u = sign(da)
            SetV(obj, 0.01, a + da)
            task.New(obj, function()
                func(obj, -u)
            end)
            PlaySound("kira00")
            chVelo(obj, dv, 30*u, 30, 60, true)
            obj.bound = true
        end)
    end
    --endregion
    --region 子弹发射器定义
    local sect_layer1 = EGGlib.BulletGroup.Sector.layer1
    local switch = EGGlib.Math.spSwitch
    --大玉衍生的小玉一次性的发弹
    function A.createShooter1()
        local diff = difficulty
        local rank = system.PowerRank.getRank()
        local v = switch(diff, {
            1.75, 2, 2.25, 2.5
        }, 1)*switch(rank, {
            1, 1.1, 1.2, 1.3, 1.5
        })
        local function shooter(x, y, a)
            stg.newStrChV(x, y, 0, v, a, 60, 0, stg.ball_mid, COLOR_RED)
        end
        A.shooter1 = shooter --覆盖shooter函数
    end
    --大玉衍生的小玉的事件发弹函数
    function E.createEvent1()
        local diff = difficulty
        local rank = system.PowerRank.getRank()
        --case：生成子弹次数
        local count = switch(diff, {
            4, 6, 8, 10
        }, 1)
        --case：生成子弹总时间
        local times = switch(rank, {
            60, 60, 60, 60, 60
        })
        local wait = times/count
        --case：生成子弹角度与大玉的角度差
        local da = switch(diff, {
            -45, -45, 75, 75
        }, 1)
        local function event(o, u)
            local a
            for _ = 0, count - 1 do
                task.Wait(wait)
                a = Angle(o.vx, o.vy, 0, 0) + da*u
                A.shooter1(o.x, o.y, a)
            end
        end
        E.event1 = event
    end
    --大玉生成（A.shooter2 这个函数由下面这个函数生成！）
    function A.createShooter2()
        local diff = difficulty --全局难度系数获取
        local rank = system.PowerRank.getRank()
        local hypersign = switch(rank, {
            3, 3, 3, 3, 2
        }) --hyper模式各种标志
        --case：层数
        local layer = switch(diff, {
            1, 1, 2, 2
        }, 1)
        --case：初始弹速
        local v0 = 4
        --case：每层弹速差
        local dv = switch(diff, {
            0, 0, -2, -2
        }, 1)
        --case：转折后的增加的最大速度
        local dv1 = switch(diff, {
            4, 4.25, 4.5, 5
        }, 1)
        local style, color = stg.knife, COLOR_BLUE
        local function shooter(x, y, a, da, u)
            PlaySound("tan00")
            stg.newFadeEffect(x, y, style, color, false,
                    function()
                        for i = -u, u, hypersign*u do
                            --sect_layer1(x, y, v0, 90*(1-i) - a*i, 1, layer, dv, 0)
                            sect_layer1(x, y, v0, 90*(1-i) - a*i, 1, 0, layer, dv, 0,
                                    function(x, y, v, a)
                                        B.bullet1(x, y, v, a, dv1, da, E.event1) --最后一个传进去的是发弹幕的函数
                                    end)
                        end
                    end)
        end
        A.shooter2 = shooter --覆盖shooter函数
    end
    --蝙蝠生成点
    local bat_shape = { --每一层按顺序: number, dv, da,
        {1, 0, 0},
        {2, -0.2, 45},
        {2, -0.4, 90},
        {2, 0, 108},
        {2, 0.5, 112}
    }
    local function bat(x, y, v0, a0, func)
        local dv, da, number
        for i = 1, 5 do
            number = (bat_shape[i][1] - 1)/2
            dv = bat_shape[i][2]
            da = bat_shape[i][3]
            for j = -number, number, 1 do
                func(x, y, v0 + dv, a0 + da*j)
            end
        end
    end
    function A.createShooter3()
        local diff = difficulty --全局难度系数获取
        local rank = system.PowerRank.getRank()
        --case：初始弹速
        local v0 = switch(diff, {
            1.25, 1.5, 1.75, 2
        }, 1) + switch(rank, {
            0, 0.2, 0.3, 0.5, 1
        })
        --case：层数
        local layer = switch(diff, {
            1, 1, 1, 2
        }, 1)
        local dv = switch(diff, {
            0, 0, 0, 1
        }, 1)
        local style, color = stg.ball_big, COLOR_RED
        local function shooter(x, y, a)
            PlaySound("tan00")
            stg.newFadeEffect(x, y, style, color, false,
                    function()
                        for i = 0, layer - 1 do
                            bat(x, y, v0 + dv*i, a,
                                    function(x, y, v, a)
                                        stg.newSimpleStraight(x, y, v, a, style, color)
                                    end)
                        end
                    end)
        end
        A.shooter3 = shooter --覆盖shooter函数
    end
    --endregion
    --region Tasker 任务执行器
    --大玉发射器
    function T.createTasker1()
        local diff = difficulty
        local rank = system.PowerRank.getRank()
        --case:攻击次数
        local count = switch(diff, {
            3, 4, 5, 6
        }, 1)
        --case：相邻大玉发射角度差
        local dsp = switch(diff, {
            60, 60, 120, 120
        }, 1)/(count - 1)
        --case：大玉转折的角度
        local da = switch(diff, {
            135, 135, 90, 90
        }, 1)
        local atktimes = switch(rank, {
            90, 90, 90, 80, 60
        })
        local wait = atktimes/count
        local function createtasker(b, u)
            boss.createTasker(b, b.x, b.y, function(obj)
                task.New(obj, function()
                    --要发射的
                    for i = 0, (count - 1) do
                        A.shooter2(b.x, b.y, 60 - dsp*i, da*u, u)
                        task.Wait(wait)
                    end
                    Del(obj)
                end)
            end, true)
        end
        T.tasker1 = createtasker --覆盖tasker函数
    end
    --蝙蝠发射器（T.tasker2 这个函数由下面这个函数生成！）
    function T.createTasker2()
        local diff = difficulty
        local rank = system.PowerRank.getRank()
        local count = switch(diff, {
            1, 2, 3, 3
        }, 1)
        local atktimes = switch(rank, {
            90, 90, 90, 78, 60
        })
        local wait = atktimes/count
        local function createtasker(b)
            boss.createTasker(b, b.x, b.y, function(obj)
                task.New(obj, function()
                    for _ = 0, count - 1 do
                        task.Wait(wait)
                        A.shooter3(b.x, b.y, Angle(b, player))
                    end
                    Del(obj)
                end)
            end, false)
        end
        T.tasker2 = createtasker --覆盖tasker函数
    end
    --endregion
    --region combination 组合攻击
    local move = function(t, obj, y0)
        y0 = y0 or 144
        EGGlib.ObjectEvent.bossMoveTask(obj,
                -40, 40, 15, 20, --x_min, x_max, dx_min, dx_max
                144, 5, 10, 30 --y0, dy_min, dy_max, t
        )
    end
    function C.createFirst()
        local wait = switch(system.PowerRank.getRank(), {
            30, 30, 30, 15, 0
        })
        local function first(b, u)
            T.tasker1(b, u) --发大玉
            T.tasker2(b) --自机狙，不等待
            task.Wait(wait)
            move(30, b)
            task.Wait(30)
        end
        C.FIRST = first
    end
    --endregion

    --若rank有变化，则必须更新一次
    local rank = -1
    local function reFresh()
        if rank ~= system.PowerRank.getRank() then --以下两个会受rank影响，需要更新
            A.createShooter1()
            E.createEvent1()
            A.createShooter2()
            A.createShooter3()
            T.createTasker1()
            T.createTasker2()
            C.createFirst()
            rank = system.PowerRank.getRank()
        end
    end
    
    local names = {
        "name-boss2-card1-E",
        "name-boss2-card1-N",
        "name-boss2-card1-H",
        "name-boss2-card1-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "spellcard", --类型
            {3, 3, 40}, --时间
            1600, --耐久
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
                while true do
                    for u = -1, 1, 2 do
                        reFresh()
                        C.FIRST(b, u)
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
