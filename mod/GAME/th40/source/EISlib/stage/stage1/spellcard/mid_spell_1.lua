-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."sence1/spellcard/mid_spell_1.lua" --当前存放目录
local no_info = 0
local function createCard(difficulty)
    --region 自定义子弹
    local velChange = EGGlib.ObjectEvent.velocityChange
    local switch = EGGlib.Math.spSwitch
    local switch1 = EGGlib.Math.spSwitch1
    local B = {}
    --变成冰花的中玉
    local ice_flower = {} --存放冰花对象的表
    function B.createBullet1()
        local rank = system.PowerRank.getRank()
        --case:衍生冰花瓣弹幕速度
        --深色
        local v0 = switch1(difficulty, {
            1.5, 1.75, 2, 2.25
        }) + switch(rank, {
            0, 0.1, 0.2, 0.3, 0.5
        })
        --浅色
        local v1 = switch1(difficulty, {
            no_info, no_info, 1.75, 2
        }) + switch(rank, {
            0, 0.1, 0.2, 0.3, 0.5
        })
        local func = switch1(difficulty, {
            function(obj)
                for i = 0, 5 do
                    B.Bullet2(obj, v0, obj.rot + 60*i, 15, COLOR_BLUE)
                end
            end, --easy
            function(obj)
                for i = 0, 5 do
                    B.Bullet2(obj, v0, obj.rot + 60*i, 15, COLOR_BLUE)
                end
            end, --normal
            function(obj)
                for i = 0, 5 do
                    B.Bullet2(obj, v0, obj.rot + 60*i, 15, COLOR_BLUE)
                    --
                    B.Bullet2(obj, v1, obj.rot + 60*i + 30, 10, COLOR_CYAN)
                end
            end, --hard
            function(obj)
                for i = 0, 5 do
                    B.Bullet2(obj, v0, obj.rot + 60*i, 15, COLOR_BLUE)
                    --
                    B.Bullet2(obj, v1, obj.rot + 60*i + 30, 10, COLOR_CYAN)
                end
            end, --lunatic
        })
        function B.bullet1(x, y, v, a, style, color)
            local obj = stg.newBullet(x, y, style, color)
            if rank == 4 then
                obj.rot = Angle(x + 50*v*cos(a), y + 50*v*sin(a), _boss.x, _boss.y + 40) + 15
            end
            table.insert(ice_flower, obj) --加入表
            obj.release = false --释放花瓣的标记（由外部修改）
            task.New(obj, function()
                velChange(obj, v, 0, a, 60, 20)
                func(obj) --生成冰花（根据难度不同生成不同）
                while not obj.release do
                    task.Wait(1)
                end
                EGGlib.ObjectEvent.sizeChange(obj, -1, 30, false) --变小
                Del(obj)
            end)
        end
    end
    --冰花花瓣弹
    function B.Bullet2(mst, v0, a, r0, co)
        local obj = stg.newSimpleBullet(mst.x, mst.y, stg.grain_b, co, false, 1)
        obj.rot = a
        task.New(obj, function()
            local dx, dy, r, dr = cos(a), sin(a), 0, r0/60
            for _ = 0, 59 do
                if IsValid(mst) then
                    r = r + dr
                    obj.x, obj.y = mst.x + r*dx, mst.y + r*dy
                else
                    Del(obj)
                end
                task.Wait(1)
            end
            --等到释放消息时
            while IsValid(mst) and not mst.release do
                task.Wait(1)
            end
            velChange(obj, 1, v0, a, 120, 60)
        end)
    end
    --endregion
    --region 子弹发射器定义
    local A = {}
    --多边形弹幕单元发射器(x, y, a, u)
    local curve_normalDv1 = EGGlib.BulletGroup.Curve.normalDv1
    function A.createShooter1()
        local diff = difficulty --全局难度系数获取
        local rank = system.PowerRank.getRank()
        --case：弹幕单元n边形
        local n = switch1(diff, {
            3, 3, 4, 4
        })
        local da_n = 360/n
        --case：n边形与中心的相对速度(反映扩散程度
        local dvc = switch1(diff, {
            0.035, 0.04, 0.045, 0.05
        }) + switch(rank, {
            0, 0, 0, 0, 0.01
        }) --hyper模式下扩散得很大
        --每个弹幕单元
        local style, color = stg.kite_b, COLOR_BLUE
        local function creat_bullet_func(x, y, v, a)
            local vx, vy = v*cos(a), v*sin(a)
            local obj
            for i = 0, n - 1 do
                obj = stg.newSimpleBullet(x, y, style, color)
                EGGlib.ObjectEvent.addV2(obj, vx + dvc*cos(a + i*da_n), vy + dvc*sin(a + i*da_n))
                obj.rot = a
            end
        end
        --case：串数
        local bunch = switch1(diff, {
            2, 4, 6, 8
        })
        --case：每串角度差
        local da = switch1(diff, {
            30, 22.5, 15, 10
        })
        --case：初始弹速
        local v0 = switch1(diff, {
            1.5, 1.6, 1.7, 1.8
        }) + switch(rank, {
            0, 0.1, 0.2, 0.3, 0.6
        })
        local dv = switch1(diff, {
            0.25, 0.25, 0.25, 0.25
        })
        function A.shooter1(x, y, a, u)
            PlaySound("tan00")
            stg.newFadeEffect(x, y, style, color, false,
                    function()
                        curve_normalDv1(x, y, v0, a, bunch, dv, da*u, --base
                                creat_bullet_func)
                    end)
        end
    end
    --冰花(x, y, a, u)
    function A.createShooter2()
        local diff = difficulty --全局难度系数获取
        local rank = system.PowerRank.getRank()
        local style, color = stg.ball_mid, COLOR_BLUE
        local function creat_bullet_func(x, y, v, a)
            B.bullet1(x, y, v, a, style, color)
        end
        --case：串数
        local bunch = switch1(diff, {
            1, 2, 3, 4
        })
        --case：每串角度差
        local da = switch1(diff, {
            30, 25, 22.5, 15
        })
        --case：初始弹速
        local v0 = switch1(diff, {
            1.25, 1.25, 1.25, 1.25
        })
        --case：相邻串弹速差
        local dv = switch1(diff, {
            1.25, 1.25, 1.25, 1.25
        })
        function A.shooter2(x, y, a, u)
            PlaySound("tan00")
            stg.newFadeEffect(x, y, style, color, false,
                    function()
                        curve_normalDv1(x, y, v0, a, bunch, dv, da*u, --base
                                creat_bullet_func)
                    end)
        end
    end
    --endregion
    --region Tasker 任务执行器
    local T = {}
    --四边形晶弹发射器(b, a0, u)
    function T.createTasker1()
        --case：攻击次数
        local count = switch1(difficulty, {
            5, 8, 12, 15
        })
        local wait = 60/count
        --case：每次攻击角度差
        local da = switch1(difficulty, {
            30, 22.5, 18.75, 15
        })
        function T.tasker1(b, a0, u, noWait)
            boss.createTasker(b, b.x, b.y, function(obj)
                task.New(obj, function()
                    for i = 0, count - 1 do
                        A.shooter1(b.x, b.y, a0 + da*i*u, u)
                        task.Wait(wait)
                    end
                    Del(obj)
                end)
            end, not noWait)
        end
    end
    --冰花发射器(b, a0, u)
    function T.createTasker2()
        --case：攻击次数
        local count = switch1(difficulty, {
            5, 8, 9, 12
        })
        local wait = 60/count
        --case：每次攻击角度差
        local da = switch1(difficulty, {
            30, 25, 25, 20
        })
        function T.tasker2(b, a0, u)
            boss.createTasker(b, b.x, b.y, function(obj)
                task.New(obj, function()
                    local w = (count - 1)/2
                    for i = -w, w do
                        A.shooter2(b.x, b.y, a0 + da*i*u, -u)
                        task.Wait(wait)
                    end
                    Del(obj)
                end)
            end, true)
        end
    end
    --endregion
    --region 组合攻击
    local C = {} --combination
    local move = function(t, obj, y0)
        y0 = y0 or 120
        EGGlib.ObjectEvent.bossMoveTask(obj,
                -40, 40, 15, 20, --x_min, x_max, dx_min, dx_max
                120, 5, 10, 30 --y0, dy_min, dy_max, t
    )
    end
    function C.createFIRST()
        local rank = system.PowerRank.getRank()
        local wait = switch(rank, {
            60, 50, 40, 30, 0
        })
        local noWait = false
        if rank == 4 then noWait = true end
        function C.FIRST(b, u)
            T.tasker1(b, -90 - 120*u, u, noWait)
            b.cast("revolve")
            T.tasker2(b, -90, -u)
            task.Wait(wait)
            move(60, b)
            task.Wait(60)
        end
    end
    function C.createSECOND()
        local wait = switch(rank, {
            60, 50, 40, 30, 0
        })
        function C.SECOND(b)
            --让全屏的冰花绽开
            b.cast("revolve")
            b.absorbEffect(b, 60)
            b.breakEffect(b, 0)
            local r, dr = 0, 600/60
            for _ = 1, 60 do
                r = r + dr
                sp.UnitListUpdate(ice_flower) --先把无效对象剔除
                --冰花绽放
                for _, obj in pairs(ice_flower) do
                    if not obj.release and r > Dist(obj.x, obj.y, b.x, b.y) then
                        obj.release = true
                    end
                end
                task.Wait(1)
            end
            task.Wait(wait)
            move(60, b)
            task.Wait(60)
        end
    end
    --endregion

    --若rank有变化，则必须更新一次
    local rank = -1
    local function reFresh()
        if rank ~= system.PowerRank.getRank() then --以下两个会受rank影响，需要更新
            B.createBullet1()
            A.createShooter1()
            A.createShooter2()
            T.createTasker1()
            T.createTasker2()
            C.createFIRST()
            C.createSECOND()
            rank = system.PowerRank.getRank()
        end
    end
    
    local function bgChangePr()
        local bg = lstg.tmpvar.bg
        if IsValid(bg) and  bg.class.Sence3And4 then
            bg.class.Sence3And4(bg, true, true)
        end
    end
    
    local function doubleAchievement(b)
        if system.isDoubleGetSpellCardBonus(b) then
            --[[local achi_func = switch1(difficulty, {
                function()
                    AchievementReminder.unlock("s1_mid_sc1", "太阳花田之雪:Easy", "成功双倍收取琪露诺的符卡「Cool Sunflower」")
                end,
                function()
                    AchievementReminder.unlock("s1_mid_sc1", "太阳花田之雪:Easy", "成功双倍收取琪露诺的符卡「Cool Sunflower」")
                    AchievementReminder.unlock("s1_mid_sc1", "太阳花田之雪:Normal", "成功双倍收取琪露诺的符卡「Cool Sunflower」")
                end,
                function()
                    AchievementReminder.unlock("s1_mid_sc1", "太阳花田之雪:Easy", "成功双倍收取琪露诺的符卡「Cool Sunflower」")
                    AchievementReminder.unlock("s1_mid_sc1", "太阳花田之雪:Normal", "成功双倍收取琪露诺的符卡「Cool Sunflower」")
                    AchievementReminder.unlock("s1_mid_sc1", "太阳花田之雪:Hard", "成功双倍收取琪露诺的符卡「Cool Sunflower」")
                end,
                function()
                    AchievementReminder.unlock("s1_mid_sc1", "太阳花田之雪:Easy", "成功双倍收取琪露诺的符卡「Cool Sunflower」")
                    AchievementReminder.unlock("s1_mid_sc1", "太阳花田之雪:Normal", "成功双倍收取琪露诺的符卡「Cool Sunflower」")
                    AchievementReminder.unlock("s1_mid_sc1", "太阳花田之雪:Hard", "成功双倍收取琪露诺的符卡「Cool Sunflower」")
                    AchievementReminder.unlock("s1_mid_sc1", "太阳花田之雪:Lunatic", "成功双倍收取琪露诺的符卡「Cool Sunflower」")
                end,
            })
            if achi_func then
                achi_func()
            end]]
            achievement.unlock("s1_mid_sc1", true, true)
        end
    end
    
    local card_name = {
        "name-boss1-card1-E",
        "name-boss1-card1-N",
        "name-boss1-card1-H",
        "name-boss1-card1-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            card_name[difficulty], --非/符卡名
            "spellcard", --类型
            {3, 3, 26}, --时间
            1200, --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                task.Wait(60)
                task.MoveTo(b, 0, 120, 60, MOVE_ACC_DEC)
            end,
            function(b) --练习模式攻击前动作
                bgChangePr()
                b.x, b.y = 0, 120
                boss.show_aura(b, true)
            end,
            function(b) --main
                while true do
                    for u = 1, -1, -2 do
                        reFresh()
                        C.FIRST(b, u)
                        C.SECOND(b)
                    end
                end
            end,
            function(b) --finish
                --双倍收取判断
                doubleAchievement(b)
            end,
            4, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end

return createCard
