-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage1/spellcard/spell_2.lua" --当前存放目录
local warning_laser = EISlib.Bullet.Laser.warning_laser
local no_info = 0
local function createCard(difficulty)
    --region 自定义子弹
    local B = {}
    --跟踪弹(超高速拖影刀
    function B.bullet1(x, y, v, a, style, color)
        local obj = stg.newSimpleStraight(x, y, v, a, style, color)
        robject.set_color(obj, "mul+add", 255, 255, 255, 255)
        EGGlib.RenderEffect.simpleTrail(obj, -1) --创建一个默认拖影
    end

    --激光预警
    local function moveWithMaster(obj)
        if IsValid(obj.master) then
            obj.x, obj.y = obj.master.x, obj.master.y
        else
            Del(obj)
        end
    end
    --大玉激光预警
    function B.laser1(master, a)
        local obj = New(warning_laser, master.x, master.y,
                600, 10, --len ,t
                20, 30, --wide , t
                a, --rot
                "mul+add", Color(200, 255, 0, 0), --blend, Color
                30, --创建后多少f后关闭
                20 --消失动画时间
        )
        warning_laser.setTrailLength(obj, 40)
        obj.master = master
        EGGlib.ObjectEvent.addFrame(obj, moveWithMaster)
    end
    --炎弹激光预警
    function B.laser2(x, y, a)
        local obj = New(warning_laser, x, y,
                600, 1, --len ,t
                10, 15, --wide , t
                a, --rot
                "", Color(100, 200, 0, 0), --blend, Color
                20, --创建后多少f后关闭
                10 --消失动画时间
        )
        warning_laser.setTrailLength(obj, 40)
    end
    --神枪激光预警
    function B.laser3(x, y, a)
        local obj = New(warning_laser, x, y,
                600, 15, --len ,t
                20, 10, --wide , t
                a, --rot
                "mul+add", Color(100, 190, 80, 0), --blend, Color
                20, --创建后多少f后关闭
                10 --消失动画时间
        )
        warning_laser.setTrailLength(obj, 40)
    end
    --endregion
    --region 子弹发射器定义
    local curve_layerDv1 = EGGlib.BulletGroup.Curve.layerDv1
    local curve_layer1 = EGGlib.BulletGroup.Curve.layer1
    local switch = EGGlib.Math.spSwitch
    local switch1 = EGGlib.Math.spSwitch1
    local A = {}
    --大玉与小玉发弹点
    function A.createShooter1()
        local diff = difficulty --全局难度系数获取
        local rank = system.PowerRank.getRank()
        local style, color = stg.ball_huge, COLOR_RED
        local function creat_bullet_func1(x, y, v, a)
            B.bullet1(x, y, v, a, style, color)
        end
        local function creat_bullet_func2(x, y, v, a)
            stg.newSimpleStraight(x, y, v, a, stg.ball_mid_c, color-1)
        end
        --case：一条弹幕上有几个弹幕数
        local bunch = switch1(diff, {
            1, 2, 3, 4
        })
        --case：光速弹层数
        local layer0 = switch1(diff, {
            1, 2, 2, 3
        })
        --case：光速弹初始弹速
        local v0 = switch1(diff, {
            3, 3.5, 4, 4
        })
        local dv0 = switch1(diff, {
            no_info, 1.75, 2, 2.5
        })
        --case：正常弹幕初始弹速
        local v1 = switch1(diff, {
            1.5, 1.5, 1.5, 1.5
        })
        local dv1 = switch1(diff, {
            0.75, 0.75, 0.75, 0.75
        })
        --case：正常弹幕层数
        local layer1 = switch1(diff, {
            1, 2, 2, 3
        })
        --case：改变小玉形状的标志（很抽象，调好了就别乱动）
        local hypersign = switch(rank, {
            1, 1, 1, 1, -1.025
        })
        local shooter
        if diff > 2 then --hl
            function shooter(x, y, a, da)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            curve_layer1(x, y, v0, a, 2, 2.5*da, layer0, dv0, 0, 0, creat_bullet_func1)
                            curve_layerDv1(x, y, v1, a, bunch, 1, hypersign*da, layer1, dv1, 0, 0, creat_bullet_func2)
                        end)
            end
        else --en
            function shooter(x, y, a, da)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            curve_layer1(x, y, v0, a, 2, -2.5*da, layer0, dv0, 0, 0, creat_bullet_func1)
                            curve_layerDv1(x, y, v1, a, bunch, 1, hypersign*da, layer1, dv1, 0, 0, creat_bullet_func2)
                        end)
            end
        end
        A.shooter1 = shooter --覆盖shooter函数
    end
    --神枪长矛头
    local tir_layer2 = EGGlib.BulletGroup.TriAngleStroke.layer2
    local lead_laser = EISlib.Bullet.Laser.lead_laser
    function A.createShooter2()
        local diff = difficulty --全局难度系数获取
        local rank = system.PowerRank.getRank()
        local style, color = stg.water_drop, COLOR_RED
        local function creat_bullet_func0(x, y, v, a)
            robject.set_color(stg.newSimpleStraight(x, y, v, a, style, color), "mul+add", 255, 255, 255, 255)
        end
        local function creat_bullet_func1(x, y, v, a)
            local obj = stg.newSimpleStraight(x, y, v, a, stg.heart, color)
            robject.set_color(obj, "mul+add", 255, 255, 255, 255)
            obj.hscale, obj.vscale = 1.5, 1.5
            obj.a, obj.b = obj.a*obj.hscale, obj.b*obj.vscale
        end
        --case：初速度
        local v0 = switch1(diff, {
            5, 6, 4.5, 5, no_info
        })*defaultSwitchVelocityByRank(rank)
        local dv0 = switch1(diff, {
            no_info, no_info, -0.1, -0.125
        })
        --case：扩散角
        local sp0 = switch1(diff, {
            no_info, no_info, 9, 12
        })
        --case：单个三角形弹幕有几层
        local bunch = switch1(diff, {
            no_info, no_info, 4, 5
        })
        --case：有多少层三角形描边弹幕
        local layer0 = switch1(diff, {
            no_info, no_info ,3, 5
        })
        --case：每层三角形描边弹幕速度差
        local dv_l0 = switch1(diff, {
            no_info, no_info, 0.75, 0.75
        })
        local shooter
        if diff > 2 then
            function shooter(x, y, a)
                PlaySound("lazer00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            tir_layer2(x, y, v0, dv0, a, sp0, bunch, --base
                                    layer0, dv_l0, 0,  --layer, dv, da
                                    creat_bullet_func0)
                            --神枪大激光
                            New(lead_laser, 1, COLOR_RED, x, y, v0 + dv_l0*(layer0 - 1), a,
                                    400, --len
                                    30, 30, --w0, w1
                                    1, --turn time
                                    false, --is lock
                                    false, --is shoot
                                    180) --alive time left
                        end)
            end
        else
            function shooter(x, y, a)
                PlaySound("lazer00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            creat_bullet_func1(x, y, v0, a)
                            --神枪大激光
                            New(lead_laser, 1, COLOR_RED, x, y, v0, a,
                                    400, --len
                                    30, 30, --w0, w1
                                    1, --turn time
                                    false, --is lock
                                    false, --is shoot
                                    180) --alive time left
                        end)
            end
        end
        A.shooter2 = shooter --覆盖shooter函数
    end
    --神枪两侧弹幕
    function A.createShooter3()
        local diff = difficulty --全局难度系数获取
        local rank = system.PowerRank.getRank()
        local style, color = stg.knife, COLOR_RED
        local function creat_bullet_func0(x, y, v, a)
            stg.newSimpleStraight(x, y, v, a, style, color)
        end
        --case：初速度
        local v0 = switch1(diff, {
            no_info, no_info, 2, 3
        }) + switch(rank, {
            0, 0.25, 0.5, 0.75, 1
        })
        local dv0 = switch1(diff, {
            no_info, no_info, -0.1, -0.1
        })
        --case：单个弧形弹幕相邻角度差
        local da0 = switch1(diff, {
            no_info, no_info, 8, 6
        })
        --case：单个弧形弹幕有几个
        local bunch0 = switch1(diff, {
            no_info, no_info, 6, 8
        })
        --case：有多少层弧形弹幕
        local layer0 = switch1(diff, {
            no_info, no_info ,3, 4
        })
        --case：每层弧形弹幕速度差
        local dv_l0 = switch1(diff, {
            no_info, no_info, 1, 1
        })
        local shooter
        if diff > 2 then
            function shooter(x, y, a, u, dlayer)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            curve_layerDv1(x, y, v0, a, bunch0, dv0, da0*u, --base
                                    1 + dlayer, dv_l0, 0, 1, --layer dv da dway
                                    creat_bullet_func0)
                        end)
            end
        else
            function shooter(x, y, a, u, dlayer)
            end
        end
        A.shooter3 = shooter --覆盖shooter函数
    end
    --endregion
    --region Tasker 任务执行器
    local T = {}
    --task1 task2
    function T.createTasker1()
        local diff = difficulty
        local rank = system.PowerRank.getRank()
        --case：一侧的串数
        local bunch = switch1(diff, {
            18, 30, 16, 20
        })
        local da0 = switch1(diff, {
            30, 10, no_info, no_info
        })
        local da = switch1(diff, {
           270, 320, 160, 165
        })/(bunch - 1)
        local wait = 60/bunch
        --预警发射
        local createtasker1
        if diff > 2 then
            function createtasker1(b)
                boss.createTasker(b, b.x, b.y, function(obj)
                    task.New(obj, function()
                        --要发射的
                        for i = 0, bunch - 1 do
                            for u = -1, 1, 2 do
                                B.laser1(b, 90 + i*da*u)
                            end
                            task.Wait(wait)
                        end
                        Del(obj)
                    end)
                end, false)
            end
        else
            function createtasker1(b, u)
                boss.createTasker(b, b.x, b.y, function(obj)
                    task.New(obj, function()
                        --要发射的
                        for i = 0, bunch - 1 do
                            B.laser1(b, -90 + (da0 + i*da)*u)
                            task.Wait(wait)
                        end
                        Del(obj)
                    end)
                end, false)
            end
        end
        T.tasker1 = createtasker1


        --攻击发射
        local createtasker2
        if diff > 2 then
            function createtasker2(b)
                boss.createTasker(b, b.x, b.y, function(obj)
                    task.New(obj, function()
                        --要发射的
                        for i = 0, bunch - 1 do
                            for u = -1, 1, 2 do
                                A.shooter1(b.x, b.y, 90 + i*da*u, -da*u)
                            end
                            task.Wait(wait)
                        end
                        Del(obj)
                    end)
                end, false)
            end
        else
            function createtasker2(b, u)
                boss.createTasker(b, b.x, b.y, function(obj)
                    task.New(obj, function()
                        --要发射的
                        for i = 0, bunch - 1 do
                            A.shooter1(b.x, b.y, -90 + (da0 + i*da)*u, -da*u)
                            task.Wait(wait)
                        end
                        Del(obj)
                    end)
                end, false)
            end
        end
        T.tasker2 = createtasker2
    end
    --task3
    function T.createTasker3()
        local diff = difficulty
        local rank = system.PowerRank.getRank()
        --case：激光预警串数
        local bunch = switch1(diff, {
            no_info, no_info, 2, 3
        })
        --case：预警扩散角
        local da = switch1(diff, {
            no_info, no_info, 10, 15
        })/(bunch - 1)/2
        local wait = 20/bunch
        --case：神枪两侧的弹幕向外朝角度
        local da0 = switch(rank, {
            30, 29, 28, 25, 10
        })
        local function createtasker(b, dlayer)
            boss.createTasker(b, b.x, b.y, function(obj)
                task.New(obj, function()
                    b.cast("laser_attack") --动作
                    b.absorbEffect(b, 30)
                    --预警线
                    local a = Angle(b, player)
                    for i = 0, bunch - 1 do
                        for u = -1, 1, 2 do
                            B.laser2(b.x, b.y, a + da*i*u)
                        end
                        task.Wait(wait)
                    end
                    B.laser3(b.x, b.y, a)
                    --真正攻击了
                    A.shooter2(b.x, b.y, a)
                    for i = -0.5, 0.5 do
                        A.shooter3(b.x, b.y, a + da0*i, 2*i, dlayer)
                    end
                    task.Wait(60)
                    Del(obj)
                end)
            end, true)
        end
        T.tasker3 = createtasker --覆盖tasker函数
    end
    --endregion
    --region 组合攻击
    local C = {} --combination
    local move = function(b, u, t)
        task.MoveTo(b, -90*u, 144, t, MOVE_ACC_DEC)
    end
    function C.createFIRST()
        --case：影响停留时间
        local wait = switch(system.PowerRank.getRank(), {
            60, 55, 50, 40, 20
        })
        local function first(b, u)
            T.tasker1(b, u)
            task.Wait(30)
            T.tasker2(b, u)
            --task.Wait(20)
            move(b, u, 60)
            task.Wait(wait)
        end
        C.FIRST = first
    end

    function C.createSECOND()
        local max_dlayer = switch1(difficulty, {
            no_info, no_info, 2, 3
        })
        local function second(b, dlayer)
            dlayer = min(max_dlayer, dlayer)
            T.tasker3(b, dlayer) --随机往板边打偏一点点
            task.MoveTo(b, 0, 144, 60, MOVE_ACC_DEC)
        end
        C.SECOND = second
    end
    --endregion

    --若rank有变化，则必须更新一次
    local rank = -1
    local function reFresh()
        if rank ~= system.PowerRank.getRank() then --以下两个会受rank影响，需要更新
            A.createShooter1()
            A.createShooter2()
            A.createShooter3()
            T.createTasker1()
            T.createTasker3()
            C.createFIRST()
            C.createSECOND()
            rank = system.PowerRank.getRank()
        end
    end

    local function doubleAchievement(b)
        if system.isDoubleGetSpellCardBonus(b) then
            --[[local achi_func = switch1(difficulty, {
                function()
                    AchievementReminder.unlock("s1_sc2", "大小姐的仁爱:Easy", "成功双倍收取蕾米莉亚的符卡「奥丁之矛」")
                end,
                function()
                    AchievementReminder.unlock("s1_sc2", "大小姐的仁爱:Easy", "成功双倍收取蕾米莉亚的符卡「奥丁之矛」")
                    AchievementReminder.unlock("s1_sc2", "大小姐的仁爱:Normal", "成功双倍收取蕾米莉亚的符卡「奥丁之矛」")
                end,
                function()
                    AchievementReminder.unlock("s1_sc2", "大小姐的仁爱:Easy", "成功双倍收取蕾米莉亚的符卡「奥丁之矛」")
                    AchievementReminder.unlock("s1_sc2", "大小姐的仁爱:Normal", "成功双倍收取蕾米莉亚的符卡「奥丁之矛」")
                    AchievementReminder.unlock("s1_sc2", "大小姐的仁爱:Hard", "成功双倍收取蕾米莉亚的符卡「奥丁之矛」")
                end,
                function()
                    AchievementReminder.unlock("s1_sc2", "大小姐的仁爱:Easy", "成功双倍收取蕾米莉亚的符卡「奥丁之矛」")
                    AchievementReminder.unlock("s1_sc2", "大小姐的仁爱:Normal", "成功双倍收取蕾米莉亚的符卡「奥丁之矛」")
                    AchievementReminder.unlock("s1_sc2", "大小姐的仁爱:Hard", "成功双倍收取蕾米莉亚的符卡「奥丁之矛」")
                    AchievementReminder.unlock("s1_sc2", "大小姐的仁爱:Lunatic", "成功双倍收取蕾米莉亚的符卡「奥丁之矛」")
                end,
            })
            if achi_func then
                achi_func()
            end]]
            achievement.unlock("s1_sc2", true, true)
        end
    end
    
    local names = {
        "name-boss2-card2-E",
        "name-boss2-card2-N",
        "name-boss2-card2-H",
        "name-boss2-card2-L",
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
                b.spawnFairyAndChangeWalkImage(b)
                task.Wait(210)
                boss.show_aura(b, true)
            end,
            function(b) --main
                local i = 0
                while true do
                    for u = -1, 1, 2 do
                        reFresh()
                        C.FIRST(b, u)
                        C.SECOND(b, i)
                        i = i + 1
                    end
                end
            end,
            function(b) --finish
                doubleAchievement(b)
                if ext.sc_pr and IsValid(b.servant) then
                    Kill(b.servant)
                end
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
