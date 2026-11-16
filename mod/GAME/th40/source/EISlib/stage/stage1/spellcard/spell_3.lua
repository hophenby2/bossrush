-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage1/spellcard/spell_3.lua" --当前存放目录
local no_info = 0
local function createCard(difficulty)
    local A, B, C, T = {}, {}, {}, {}
    --region Function 自定义函数
    --region Bullet 自定义子弹
    local addVeloCh = EGGlib.ObjectEvent.velocityChange
    local chVelo = EGGlib.ObjectEvent.addChangeVelocity
    local warning_laser = EISlib.Bullet.Laser.warning_laser
    local lead_laser = EISlib.Bullet.Laser.lead_laser
    --转折弹
    function B.bullet1(x, y, v0, a, dv, da, func)
        local obj = stg.newBullet(x, y, stg.ball_light, COLOR_RED)
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
    local tri = EGGlib.BulletGroup.TriAngle
    local tristro_circle_layer1 = EGGlib.BulletGroup.TriAngleStroke.circleLayer2
    local sect_sector_layer2 = EGGlib.BulletGroup.Sector.sectorLayer2
    local eaflower = EGGlib.BulletGroup.equalAngleFlowerShooter
    local singleFlower = EGGlib.BulletGroup.singleFlowerShooter
    local bunch = EGGlib.BulletGroup.bunch
    local switch = EGGlib.Math.spSwitch
    local switch1 = EGGlib.Math.spSwitch1
    --产生激光连线的球
    function A.createShooter1()
        local diff = difficulty
        local rank = system.PowerRank.getRank()
        --case：way数
        local way = switch1(diff, {
            6, 6, 6, 8
        })
        local da = 360/way
        --case：初速度
        local v0 = switch1(diff, {
            2.4, 2.5, 2.6, 2.7
        })
        --case：每层速度差
        local dv = switch1(diff, {
            2, 2, 2, 2
        })
        local style, color = stg.ball_light, switch1(diff, {
            COLOR_ORANGE, COLOR_ORANGE, COLOR_RED, COLOR_RED
        })
        local function shooter(x, y, a, u)
            local laser_balls = {}  --用激光连线组成的球的表
            PlaySound("tan00")
            stg.newFadeEffect(x, y, style, color, false, function() end) --注意，不要在里面发射
            singleFlower(x, y, v0, a + 0.25*da*u, way,
                    function(x, y, v, a)
                        --一串弹幕
                        local objs = {}
                        bunch(x, y, 2, v0, dv, a, 0.5*da*u,
                                function(x, y, v, a)
                                    local bullet = stg.newSimpleStrChV(x ,y, v, 0, a, 30, 30, style, color, true)
                                    robject.set_color(bullet, "mul+add", 255, 255, 255, 255)
                                    bullet.bound = false
                                    bullet.hscale, bullet.vscale = 0.75, 0.75
                                    table.insert(objs, bullet)
                                end
                        )
                        table.insert(laser_balls, objs)
                        --
                    end)
            return laser_balls --返回一个已经建立好联系的激光球表
        end
        A.shooter1 = shooter --覆盖shooter函数
    end
    --光玉炸裂后产生的弹幕
    function A.createShooter2()
        local diff = difficulty --全局难度系数获取
        local rank = system.PowerRank.getRank()
        --case：层数
        local layer = switch1(diff, {
            1, 1, 1, 1
        }) + switch(rank, {
            0, 0, 0, 0, 1
        })
        --case：way数 en为一个扇形子弹的way数 hl为一个开花弹的way数
        local way = switch1(diff, {
            1, 1, 4, 5
        })
        --case:en限定，一个发弹点会发射多少way扇形
        local way1 = max(1, switch1(diff, {
            5, 9, no_info, no_info, no_info
        }))
        --case：en限定，一个发弹点每way扇形角度差
        local da_w = 360/way1
        --case: en为单个扇形弹幕扩散角 hl为单个三角形弹幕总扩散角
        local sp = switch1(diff, {
            10, 2, 4, 4
        })
        --case：初始弹速
        local v0
        if diff < 3 then --en
            v0 = switch1(diff, {
                1, 1.25, no_info, no_info
            })*defaultSwitchVelocityByRank(rank)
        else --hl
            v0 = switch1(diff, {
                no_info, no_info, 1.7, 1.7
            }) + switch(rank, {
                0, 0.4, 0.8, 1.2, 0.4
            })
        end
        --case：每层弹速差
        local dv0 = switch1(diff, {
            0.25, 0.25, 1.25, 1.25
        })
        --case：三角形中每颗子弹速度差
        local dv1 = switch1(diff, {
            0, 0, -0.1, -0.1
        })
        local shooter
        if diff < 3 then --en
            local style, color = stg.ball_mid, COLOR_YELLOW
            function shooter(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            sect_sector_layer2(x, y, v0, a, way, sp, --base
                                    way1, da_w, --way
                                    layer, dv0, 0, 0, --layer, dv, da, dway
                                    function(x, y, v, a)
                                        stg.newSimpleStraight(x, y, v, a, style, color, false)
                                    end)
                        end)
            end
        else --hl
            local style, color = stg.grain_b, COLOR_RED
            function shooter(x, y, a0)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            eaflower(x, y, v0, dv0, a0, way, layer,
                                    function(x, y, v, a)
                                        tri(x, y, v, dv1, a, sp, 3,
                                                function(x, y, v, a)
                                                    stg.newSimpleStrChV(x, y, 1.5, v, a, 120, false, style, color)
                                                end)
                                    end)
                        end)
            end
        end
        A.shooter2 = shooter --覆盖shooter函数
    end
    --产生连接球的刀弹
    function A.createShooter3()
        local diff = difficulty
        local rank = system.PowerRank.getRank()
        --case：总way数
        local way = switch1(diff, {
            4, 5, 6, 6
        })
        --case：总层数
        local layer0 = switch1(diff, {
            0, 1, 1, 1
        })
        --case：每一个三角描边弹的层数
        local layer1 = switch1(diff, {
            3, 4, 4, 6
        })
        --case：初速度
        local v0 = switch1(diff, {
            1.5, 1.67, 1.83, 2
        }) + switch(rank, {
            -0.2, -0.1, 0, 0.1, 0.2
        })
        --case：一个三角描边弹中每层速度差
        local dv0 = switch1(diff, {
            -0.1, -0.1, -0.1, -0.1
        })
        --case：总体每层速度差
        local dv1 = switch1(diff, {
            0.7, 0.75, 0.8, 0.9
        })
        local style, color = switch1(diff, {
            stg.knife, stg.knife, stg.knife, stg.knife
        }), switch1(diff, {COLOR_RED, COLOR_RED, COLOR_RED, COLOR_RED})
        local function shooter(x, y, a0, dlayer)
            stg.newFadeEffect(x, y, style, color, false, function()
                tristro_circle_layer1(x, y, v0, dv0, a0, layer1,  --base
                        way + layer0 + dlayer, --way(因为是反着来的
                        layer0 + dlayer, dv1, 0, -1,  --layer, dv, da, dway
                        function(x, y, v, a)
                            stg.newSimpleStraight(x, y, v, a, style, color)
                        end)
            end)
        end
        A.shooter3 = shooter --覆盖shooter函数
    end
    --endregion
    --region Tasker 任务执行器
    --大玉发射器
    function T.createTasker1()
        local diff = difficulty
        --case：laser color
        local co1 = switch1(diff, {
            COLOR_YELLOW, COLOR_YELLOW, COLOR_RED, COLOR_RED
        })
        local co2 = switch1(diff, {
            COLOR_YELLOW, COLOR_YELLOW, COLOR_RED, COLOR_RED
        })
        local function createtasker(b, a, dlayer)
            boss.createTasker(b, b.x, b.y, function(obj)
                task.New(obj, function()
                    local bx, by = b.x, b.y --记录当前发射位置
                    local balls = A.shooter1(b.x, b.y, a, 1)
                    local da0 = {30, 60, 120, 150} --几种随机的形状
                    da0 = da0[ran:Int(1, 4)]*ran:Sign()
                    if diff < 3 then --en特殊处理
                        da0 = 0
                    end
                    EGGlib.Math.linkTwoTable(balls, A.shooter1(b.x, b.y, a, -1)) --这里生成的表也被连在balls里了
                    task.Wait(30)
                    A.shooter3(b.x, b.y, ran:Float(0, 360), dlayer)
                    task.Wait(30)
                    b.absorbEffect(b, 30)
                    --引爆激光球
                    local function oneLayerBallAttack(j)
                        local o
                        for i = 1, #balls do
                            o = balls[i][j]
                            if IsValid(o) then
                                A.shooter2(o.x, o.y, Angle(o.x, o.y, bx, by) + da0)
                                Del(o)
                            end
                        end
                    end
                    --将激光和弹幕连接
                    local function link_laser(new_laser_func, wait)
                        local ls
                        local angle_list = {}
                        for i = 1, #balls do
                            ls = balls[i][1]
                            if IsValid(ls) then
                                table.insert(angle_list, -Angle(b, ls))
                                new_laser_func(b.x, b.y, co1, 10, -angle_list[i], Dist(b, ls), 10, 12)
                                new_laser_func(b.x, b.y, co2, 8, -angle_list[i], 500, 10, 12)
                            else
                                table.insert(angle_list, 0)
                            end
                        end
                        task.Wait(wait)
                        local ls1, ls2
                        for i = 1, #balls do
                            ls1 = balls[i][1]
                            ls2 = balls[i][2]
                            if IsValid(ls1) and IsValid(ls2) then
                                table.insert(angle_list, Angle(ls1, ls2))
                                new_laser_func(ls1.x, ls1.y, co1, 10, angle_list[i + #balls], Dist(ls1, ls2), 10, 12)
                            else
                                table.insert(angle_list, 0)
                            end
                        end
                        task.Wait(wait)
                        local u = 1
                        for i = 1, #balls do
                            ls = balls[i][2]
                            u = -u
                            if IsValid(ls) then
                                new_laser_func(ls.x, ls.y, co1, 10, angle_list[i] + 2*angle_list[i + #balls], 400, 10, 12)
                            end
                        end
                    end
                    --生成预警激光函数
                    local function new_warning_laser_func(x, y, co, v, a, len, w0, w1)
                        local t = len/v
                        New(warning_laser, x, y, len, t, 1, 5, a, "mul+add", Color(255, 255, 255, 255), 60)
                    end
                    --生成激光函数
                    local function new_laser_func(x, y, co, v, a, len, w0, w1)
                        New(lead_laser, 1, co, x, y, v, a, len, w0, w1, 1, true, false, 60)
                    end
                    --预警激光
                    link_laser(new_warning_laser_func, 15)
                    task.Wait(30)
                    --为最里层弹幕连上激光
                    PlaySound("lazer00")
                    link_laser(new_laser_func, 10)
                    --激光球爆炸
                    oneLayerBallAttack(1)
                    task.Wait(10)
                    oneLayerBallAttack(2)
                    Del(obj)
                end)
            end, true)
        end
        T.tasker1 = createtasker --覆盖tasker函数
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
        local diff = difficulty
        local wait = switch(system.PowerRank.getRank(), {
            120, 120, 120, 120, 90
        })
        local max_dlayer = switch1(diff, {
            1, 2, 3, 3
        })
        local function first(b, dlayer)
            dlayer = int(dlayer) --向下取整
            dlayer = min(dlayer, max_dlayer) --有上限的
            T.tasker1(b, 90 + ran:Float(-5, 5), dlayer) --发大玉
            task.Wait(wait)
            move(60, b)
            task.Wait(60)
        end
        C.FIRST = first
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
            C.createFirst()
            rank = system.PowerRank.getRank()
        end
    end
    
    local names = {
        "name-boss2-card3-E",
        "name-boss2-card3-N",
        "name-boss2-card3-H",
        "name-boss2-card3-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "spellcard", --类型
            {3, 3, 60},
            2000, --耐久
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
                local dlayer = 0
                while true do
                    reFresh()
                    C.FIRST(b, dlayer)
                    dlayer = dlayer + 1
                end
            end,
            function(b) --finish
                if IsValid(b.servant) then
                    Kill(b.servant)
                end
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
