-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage1/spellcard/normal_2.lua" --当前存放目录
local expression = EISlib.Effect.expression
local moveWithTask = EGGlib.ObjectEvent.moveWithTask

local function createCard(difficulty)
    --region 自定义子弹
    local velch = EGGlib.ObjectEvent.velocityChange
    local B = {}
    --转折弹
    function B.bullet1(x, y, v, a, da, style, color)
        local obj = stg.newSimpleBullet(x, y, style, color)
        obj.rot = a
        task.New(obj, function()
            velch(obj, 3, 0, a, 60)
            PlaySound("kira00")
            obj.rot = a + da
            velch(obj, 0, v, obj.rot, 20)
        end)
    end
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
            1, 1, 2, 3
        }, 1)
        --case：初始偏折角度
        local da0 = switch(diff, {
            0, 0, 30, 60
        }, 1) --EN为正向直线弹，HL为转折弹
        local da
        if diff < 3 then
            da = 0
        else
            da = 60/(way - 1) --每层偏转角度
        end
        way = (way - 1)/2 --进入循环前处理
        --case：层数
        local layer = switch(diff, {
            1, 2, 2, 2
        }, 1)
        --case：初始弹速
        local v0 = switch(diff, {
            1.25, 1.5, 1.75, 2
        }, 1) + switch(rank, {
            0, 0.2, 0.3, 0.5, 1
        })
        --case：每层弹速差
        local dv = switch(diff, {
            0, 1, 1, 1
        }, 1)

        local way2 = switch(rank, {
            0, 0, 0, 0, 0.5
        })
        local da2 = switch(rank, {
            0, 0, 0, 0, 2
        })
        local style, color = stg.knife, COLOR_BLUE
        local function shooter(x, y, a, u)
            PlaySound("tan00")
            stg.newFadeEffect(x, y, style, color, false,
                    function()
                        for i = -way, way, 1 do
                            sect_layer1(x, y, v0, a, 1, 0, layer, dv, 0,
                                    function(x, y, v, a)
                                        for j = -way2, way2 do
                                            B.bullet1(x, y, v, a, -(da0 + da*(i + way) + da2*j)*u, style, color)
                                        end
                                    end)
                        end
                    end)
        end
        A.shooter1 = shooter --覆盖shooter函数
    end
    --蝙蝠生成点
    local bat_shape = { --每一层按顺序: number, dv, da,
        {2, 0, 10},
        {4, -0.15, 5},
        {3, -0.3, 15},
        {2, -0.35, 12}
    }
    local function bat(x, y, v0, a0, vscale, hscale, func)
        local dv, da, number
        for i = 1, 4 do
            number = (bat_shape[i][1] - 1)/2
            dv = bat_shape[i][2]*vscale
            da = bat_shape[i][3]*hscale
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
            1.75, 2, 2.25, 2.5
        }, 1) + switch(rank, {
            0, 0.2, 0.3, 0.5, 1
        })
        local hscale = switch(diff, {
            0.35, 0.4, 0.45, 0.5
        }, 1) + switch(rank, {
            0, 0, 0, 0, 0.1
        })
        local vscale = switch(diff, {
            0.5, 0.5, 0.75, 1
        }, 1)
        local style, color = stg.ball_mid, COLOR_RED
        local function shooter(x, y, a)
            PlaySound("tan00")
            stg.newFadeEffect(x, y, style, color, false,
                    function()
                        bat(x, y, v0, a,
                                vscale, --vscale
                                hscale, --hscale
                                function(x, y, v, a)
                                    stg.newSimpleStraight(x, y, v, a, style, color)
                                end)
                    end)
        end
        A.shooter2 = shooter --覆盖shooter函数
    end
    --endregion
    local servant --使魔实体引用(在进入二非前创建
    --region Tasker 任务执行器
    local T = {}
    --刀弹发射器（T.tasker1 这个函数由下面这个函数生成！）
    function T.createTasker1()
        local diff = difficulty
        local rank = system.PowerRank.getRank()
        --case:攻击次数
        local count = switch(diff, {
            6, 8, 8, 10
        }, 1)
        local da = 120/count
        --case：攻击初角度
        local da0 = switch(diff, {
            0.5*da, -da, 0, 0
        }, 1)
        local atktimes = switch(rank, {
            40, 40, 40, 30, 20
        })
        local wait = atktimes/count
        local function createtasker(b, u)
            boss.createTasker(b, b.x, b.y, function(obj)
                task.New(obj, function()
                    --要发射的
                    for i = 0, (count - 1)*u, u do
                        A.shooter1(b.x, b.y, -90 + da0*u + i*da, u)
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
            2, 3, 3, 5
        }, 1)
        local da = switch(diff, {
            30, 80, 70, 120
        }, 1)/(way-1)
        --case:攻击间隔
        local atktimes = switch(rank, {
            60, 60, 60, 60, 54
        })
        local wait = atktimes/way
        local leave_wait = atktimes%way --溢出的时间
        way = (way-1)/2 --进入循环前要处理一下
        local function createtasker(b, u)
            boss.createTasker(b, b.x, b.y, function(obj)
                task.New(obj, function()
                    local a = Angle(servant, player)
                    --这里是让使魔发弹幕！
                    if IsValid(servant) then
                        for j = -way, way, 1 do
                            --等待
                            task.Wait(wait)
                            --发弹幕
                            A.shooter2(servant.x, servant.y, a + j*da*u)
                        end
                        task.Wait(leave_wait)
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
        T.tasker1(b, u)
        T.tasker2(b, u) --蝙蝠使魔不需要boss等待
        local wait = switch(system.PowerRank.getRank(), {
            60, 60, 60, 60, 54
        })
        move(wait, b)
        task.Wait(wait)
    end

    function C.servantAction(b)
        local function express(servant, dx, dy)
            local e = New(expression, servant.x + dx, servant.y + dy, "tired")
            moveWithTask(e, servant, dx, dy) --obj, mst, dx ,dy, t
            expression.defaultShow(e, 20, 40, 10) --t0, t1, t2
        end

        local function servantDo(func)
            if IsValid(servant) then
                func(servant)
            end
        end

        task.New(b, function()
            --等待到非符时间过了10秒，进行第一次流汗
            while b.timer < 600 do
                task.Wait(1)
            end
            servantDo(function(servant)
                express(servant, 0, 20)
            end)
            --等待到非符时间过了17.5秒，进行第二次流汗
            while b.timer < 1050 do
                task.Wait(1)
            end
            for i = -1, 1 do
                servantDo(function(servant)
                    express(servant, 15*i + ran:Float(-5, 5), 15 + ran:Float(-5, 5))
                end)
                task.Wait(10)
            end
            --等待到非符时间过了25秒，撑不住了撑不住了
            while b.timer < 1500 do
                task.Wait(1)
            end
            for i = -2, 2 do
                servantDo(function(servant)
                    express(servant, 7.5*i + ran:Float(-5, 5), 15 + ran:Float(-5, 5))
                end)
                task.Wait(5)
            end
            achievement.unlock("s1_ns2", true, true) -- AchievementReminder.unlock("s1_ns2", "晚霞的重量", "拖时间通过蕾米莉亚的第2个通常弹幕")
            servantDo(function(servant)
                PlaySound("bonus2")
                item.Blood.create(servant.x, servant.y, item.Blood.Big)
            end)
        end)
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
        "name-boss2-normal2-E",
        "name-boss2-normal2-N",
        "name-boss2-normal2-H",
        "name-boss2-normal2-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "normal", --类型
    --system.DEFAULT_TIMET, --时间
            {3, 3, 30},
            1200, --耐久
            system.DROP_NORMAL, --掉落
            function(b) --普通模式攻击前动作
                --spawn_fairy(b) --召唤使魔
                servant = b.spawnFairyAndChangeWalkImage(b)
                task.MoveTo(b, 0, 144, 60, MOVE_ACC_DEC)
                task.Wait(150) --再等150f
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 144
                --spawn_fairy(b) --召唤使魔
                servant = b.spawnFairyAndChangeWalkImage(b)
                task.Wait(210)
                boss.show_aura(b, true)
            end,
            function(b) --main
                C.servantAction(b)
                if IsValid(servant) then
                    _connect(b, servant, 0.5, false) --让自己与使魔绑定，并且有伤害传递
                end
                while true do
                    for u = -1, 1, 2 do
                        reFresh()
                        C.FIRST(b, u)
                    end
                end
            end,
            function(b) --finish
                if ext.sc_pr and IsValid(b.servant) then
                    Kill(b.servant)
                end
            end,
            4, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
