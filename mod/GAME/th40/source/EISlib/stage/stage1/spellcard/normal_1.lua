-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage1/spellcard/normal_1.lua" --当前存放目录



local function createCard(difficulty)
    --region 自定义子弹
    local B = {}
    --endregion
    --region 子弹发射器定义
    local sect_layer1 = EGGlib.BulletGroup.Sector.layer1
    local switch = EGGlib.Math.spSwitch
    local A = {}
    --刀弹生成点（A.shooter1 这个函数由下面这个函数生成！）
    function A.createShooter1()
        local diff = difficulty --全局难度系数获取
        local rank = system.PowerRank.getRank()
        --case：way数
        local way = switch(diff, {
            2, 3, 4, 4
        }, 1)
        local da = 360/way
        --case：每way中的小way数
        local way1 = (switch(diff, {
            1, 1, 1, 1
        }, 1) + switch(rank, {
            0, 0, 0, 0, 1
        }) - 1)/2
        --每way中的小way数的角度差
        local da1 = switch(rank, {
            0, 0, 0, 0, 4
        })
        --case：层数
        local layer = switch(diff, {
            1, 1, 2, 2
        }, 1)
        --case：初始弹速
        local v0 = switch(diff, {
            1.25, 1.5, 1.75, 2
        }, 1) + switch(rank, {
            0, 0.2, 0.3, 0.5, 1
        })
        --case：每层弹速差
        local dv = switch(diff, {
            0, 0, 1, 1
        }, 1)
        local style, color = stg.knife, COLOR_BLUE
        local function shooter(x, y, a)
            PlaySound("tan00")
            stg.newFadeEffect(x, y, style, color, false,
                    function()
                        for i = -way1, way1, 1 do
                            sect_layer1(x, y, v0, a + da1*i, way, da, layer, dv, 0,
                                    function(x, y, v, a)
                                        stg.newSimpleStraight(x, y, v, a, style, color, false, 1) --最后一个参数，使刀弹layer+1
                                    end)
                        end
                    end)
        end
        A.shooter1 = shooter --覆盖shooter函数
    end
    --蝙蝠生成点
    local bat_shape = { --每一层按顺序: number, dv, da,
        {1, 0, 0},
        {2, -0.1, 2.5},
        {4, -0.2, 5},
        {5, -0.3, 6}
    }
    local function bat(x, y, v0, a0, func)
        local dv, da, number
        for i = 1, 4 do
            number = (bat_shape[i][1] - 1)/2
            dv = bat_shape[i][2]
            da = bat_shape[i][3]
            for j = -number, number, 1 do
                func(x, y, v0 + dv, a0 + da*j)
            end
        end
    end
    function A.createShooter2()
        local diff = difficulty --全局难度系数获取
        local rank = system.PowerRank.getRank()
        --case：初始弹速
        local v0 = switch(diff, {
            1.25, 1.5, 1.75, 2
        }, 1) + switch(rank, {
            0, 0.2, 0.3, 0.5, 1
        })
        local style, color = stg.ball_mid, COLOR_RED
        local function shooter(x, y, a)
            PlaySound("tan00")
            stg.newFadeEffect(x, y, style, color, false,
                    function()
                        bat(x, y, v0, a,
                                function(x, y, v, a)
                                    stg.newSimpleStraight(x, y, v, a, style, color)
                                end)
                    end)
        end
        A.shooter2 = shooter --覆盖shooter函数
    end
    --endregion
    --region Tasker 任务执行器
    local T = {}
    --刀弹发射器（T.tasker1 这个函数由下面这个函数生成！）
    function T.createTasker1()
        local diff = difficulty
        local rank = system.PowerRank.getRank()
        --case:攻击次数
        local count = switch(diff, {
            12, 16, 20, 24
        }, 1)
        local da = 360/(count - 1)
        local atktimes = switch(rank, {
            180, 180, 180, 150, 120
        })
        local wait = atktimes/count
        local function createtasker(b, u)
            boss.createTasker(b, b.x, b.y, function(obj)
                task.New(obj, function()
                    --要发射的
                    local a0 = ran:Float(85, 95)
                    for i = 0, (count - 1)*u, u do
                        A.shooter1(b.x, b.y, a0 + i*da)
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
        --case：几way蝙蝠弹
        local way = switch(diff, {
            1, 2, 2, 3
        }, 1)
        local d360 = 360/way
        way = (way-1)/2 --进入循环前要处理一下
        --case:攻击次数
        local count = switch(diff, {
            6, 8, 10, 12
        }, 1)
        local da = 360/(count - 1)
        local atktimes = switch(rank, {
            180, 180, 180, 150, 120
        })
        local wait = atktimes/count
        local function createtasker(b, u)
            boss.createTasker(b, b.x, b.y, function(obj)
                task.New(obj, function()
                    --要发射的
                    local a0, r, a = ran:Float(-5, 5), 60
                    for i = 0, (count - 1)*u, u do
                        for j = -way, way, 1 do
                            a = a0 + 90*(u-1) + i*da + j*d360
                            A.shooter2(b.x + r*cos(a), b.y + r*sin(a), a)
                        end
                        task.Wait(wait)
                    end
                    Del(obj)
                end)
            end, false)
        end
        T.tasker2 = createtasker --覆盖tasker函数
    end
    --endregion
    --region 组合攻击
    local C = {} --combination
    local move = function(t, obj, y0)
        y0 = y0 or 144
        EGGlib.ObjectEvent.bossMoveTask(obj,
                -40, 40, 15, 20, --x_min, x_max, dx_min, dx_max
                144, 5, 10, 30 --y0, dy_min, dy_max, t
        )
    end
    function C.FIRST(b, u)
        T.tasker2(b, u) --蝙蝠使魔不需要boss等待
        T.tasker1(b, u)
        move(30, b)
        task.Wait(30)
    end
    function C.SECOND(b, u)

    end
    --endregion

    --若rank有变化，则必须更新一次
    local rank = -1
    local function reFresh()
        if rank ~= system.PowerRank.getRank() then --以下两个会受rank影响，需要更新
            A.createShooter1()
            A.createShooter2()
            T.createTasker1()
            T.createTasker2()
            rank = system.PowerRank.getRank()
        end
    end
    
    local names = {
        "name-boss2-normal1-E",
        "name-boss2-normal1-N",
        "name-boss2-normal1-H",
        "name-boss2-normal1-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "normal", --类型
    --system.DEFAULT_TIMET, --时间
            {3, 3, 30},
            1200, --耐久
            system.DROP_NORMAL, --掉落
            function(b) --
                -- 加载
                LoadMusicRecord("s1_boss")
                dialog.utility.cacheResource("Stage1")
                -- 对话
                dialog.scene.stage1_p1s(function()
                    task.MoveTo(b, 0, 144, 60, MOVE_ACC_DEC)
                    system.record.unlockPerformer("Remilia")
                end, true) -- 要解锁音乐室
                boss.setUInameDisplay(b, true)
                -- 开打
                system.PowerRank.resumeHyper() --从这里计时
                boss.show_aura(b, true)
                task.wait(60)
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
            4, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
