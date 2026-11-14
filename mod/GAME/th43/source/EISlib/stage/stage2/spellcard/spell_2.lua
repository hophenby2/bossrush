-----------------------------------------
---东方栖霞园符卡 二面sc2
-----------------------------------------
--todo 成就：在这张符卡L难度下不击破任何一只兔子收取
local curpath = EISlib.stage.path.."stage2/spellcard/spell_2.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local setProtectTime = EGGlib.ObjectEvent.setProtectTime
local clearBulletAndLaserInRangeCircle = EGGlib.ObjectEvent.clearBulletAndLaserInRangeCircle
local setARGBAndSize = EGGlib.ObjectEvent.setARGBAndSize
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local accdecVelch = EGGlib.ObjectEvent.accDecVelocityChangeTask
local boundWait = EGGlib.ObjectEvent.boundWait
local roateMoveWith2Task = EGGlib.ObjectEvent.rotateMoveWith2Task
local sty = EISlib.Enemy.Style
local velch_task = EGGlib.ObjectEvent.velocityChangeTask
local tri_circleLayer3 = EGGlib.BulletGroup.TriAngleStroke.circleLayer3
local tri_circle3 = EGGlib.BulletGroup.TriAngleStroke.circle3
local sect_normal1 = EGGlib.BulletGroup.Sector.normal1

local function createCard(difficulty)
    local B, P, S, C, T, E, M, D = {}, {}, {}, {}, {}, {}, {}, {}
    local achi = true --成就达成flag
    --region Bullet 自定义子弹
    --endregion
    --region 子弹发射器定义
    --三角型描边弹幕
    P.pointer1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                --case:way数
                local way = switch1(diff, {
                    8, 12, 10, 12, no_info
                })
                --case：每way之间角度差
                local da = switch1(diff, {
                    1, 1, 1, 1, no_info
                }) + switch(rank, {
                    0, 0, 0, 0, 0.25
                }) --每way间的间隔
                --case:层数
                local layer = switch1(diff, {
                    1, 2, 2, 2, no_info
                })
                local dv_l = switch1(diff, {
                    no_info, 1, 1, 1, no_info
                })
                local da_l = 360/way/layer
                local dway = switch1(diff, {
                    no_info, 1, 1, 1
                })
                --case：一侧边有多少个
                local bunch = switch1(diff, {
                    3, 4, 3, 4, no_info
                })
                --case：初始弹速
                local v0 = switch1(diff, {
                    1.75, 2, 1.75, 2, no_info
                })*defaultSwitchVelocityByRank(rank)
                --case：相邻弹幕速度差
                local dv0 = switch1(diff, {
                    0.05, 0.05, 0.05, 0.05, no_info
                })
                local style = stg.arrow_mid
                local function attack(x, y, a, u, color)
                    PlaySound("tan00")
                    local function bullet_func(x, y, v, a)
                        local obj = stg.newSimpleStraight(x, y, v, a, style, color)
                        obj.hscale = 0.75
                    end
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                tri_circleLayer3(x, y, v0 + dv0*(bunch - 1), -dv0, a, da, bunch, --base
                                        way, layer, --way, layer2
                                        dv_l, da_l*u, dway, --dv_l2, da_l2, dway,
                                        bullet_func
                                )
                            end)
                end
                return attack
            end
    )
    --鬼火死尸弹
    P.pointer2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = switch1(diff, {
                    no_info, 3, 5, 7, no_info
                })
                local layer = switch1(diff, {
                    no_info, 1, 1, 1, no_info
                })
                local v0 = switch1(diff, {
                    no_info, 1.5, 2, 2.5, no_info
                })*defaultSwitchVelocityByRank(rank)
                local dv = switch1(diff, {
                    no_info, no_info, no_info, 0.05, no_info
                })
                local da = switch1(diff, {
                    no_info, no_info, no_info, 1, no_info
                })
                local style, color = stg.arrow_small, COLOR_DEEP_RED
                local function attack(x, y, a, co)
                    local function bullet_func(x, y, v, a)
                        stg.newSimpleStrChV(x, y, v + 2, v, a, 30, 0, style, co)
                    end
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, co, false,
                            function()
                                tri_circle3(x, y, v0, dv, a, da, layer, --base
                                        way, --way,
                                        bullet_func)
                            end)
                end
                return attack
            end
    )

    --星弹小妖精
    P.pointer3 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = switch1(diff, {
                    1, 1, 1, 2, 2
                }) + switch(rank, {
                    0, 0, 0, 0, 1
                })
                local da = switch1(diff, {
                    30, 30, 30, 15, 15
                })
                local layer = switch(rank, {
                    1, 1, 1, 1, 1
                })
                local v0 = switch1(diff, {
                    1.5, 2, 2.25, 2.5, no_info
                })*defaultSwitchVelocityByRank(rank)
                local dv = -0.2*v0
                local style, color = stg.star_small, COLOR_DEEP_GREEN
                local function attack(x, y, a)
                    local function bullet_func(x, y, v, a)
                        for i = 0, layer - 1 do
                            stg.newSimpleStrChV(x, y, 0, v + dv*i, a, 60, 0, style, color).omiga = 6
                        end
                    end
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_normal1(x, y, v0, a, way,
                                        da, bullet_func)
                            end)
                end
                return attack
            end
    )
    --
    --endregion
    --region Shooter 普通小怪仅作发射子弹的任务
    S.shooter1 = EISlib.Bullet.Shooter.createShooter(
            function (diff, rank)
                local start_time = 0
                local total_time = 360
                local wait = switch1(diff, {
                    30, 14, 14, 14, 14
                })
                local function main(e, a, co)
                    enemy.createShooter(e,
                            start_time, total_time, --start_time_left total_time
                            function()
                                while true do
                                    P.pointer3.attack(e.x, e.y, a, co)
                                    task.Wait(wait)
                                end
                            end
                    )
                end
                return main
            end
    )
    --endregion
    --region 死尸弹
    --大妖精死后的染色效果
    D.death1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local rmax = switch1(diff, {
                    30, 30, 75, 75, no_info
                }) + 16
                local function main(e)
                    local x, y, obj = e.x, e.y
                    system.PowerRank.clear_bullet_circle(x, y, rmax, 30, 2)
                    clearBulletAndLaserInRangeCircle(x, y, rmax, 2, 0, 1, false, true)
                    --清除小怪
                    for i = 1, #e.children do
                        obj = e.children[i]
                        if IsValid(obj) then
                            --obj.drop = {0, 2} --转为蓝点
                            --enemy.changeDrop(obj, {0, 2}) --转为蓝点
                            Kill(obj)
                        end
                    end
                    achi = false --你成就没了
                end
                return main
            end)
    --普通小妖精死后的死尸弹
    D.death2 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    no_info, 1, 2, 2, no_info
                })
                local function main(e)
                    local x, y, co = e.x, e.y, e.bullet_co
                    enemy.createDeath(
                            20, --total_time,
                            function()
                                --[[for _ = 1, count do
                                    if Dist(x, y, player.x, player.y) > 30 then
                                        P.pointer2.attack(x, y, Angle(x, y, player.x, player.y), co)
                                    end
                                    task.Wait(10)
                                end]]
                            end)
                end
                return main
            end)
    --endregion
    --region 自定义移动方式和状态变化
    --大鬼火的移动
    M.task1 = EISlib.Bullet.Shooter.createAction(
            function(diff, rank)
                local way = 7
                local da = 360/way
                local v = switch(rank, {
                    4, 4, 4, 4, 4
                })

                local y = switch1(diff, {
                    50, 50, 144, 144, 144
                })
                local color = {
                    COLOR_DEEP_RED, COLOR_GOLDEN_YELLOW, COLOR_CHARTREUSE,
                    COLOR_DEEP_GREEN, COLOR_ROYAL_BLUE, COLOR_DEEP_BLUE,
                    COLOR_DEEP_PURPLE
                }
                local function main(obj, a, u)
                    obj.children = {}
                    obj.u = u
                    --obj.hscale, obj.vscale = 1.5, 1.5
                    --boundWait(obj, 600)
                    enemy.setBoundTime(obj, 600)
                    setARGBAndSize(obj, 0, 255, 255, 255, 2, 2)
                    --accdecVelch(obj, v, a, 30)
                    task.New(obj, function()
                        task.MoveTo(obj, (135 + ran:Float(-10, 10))*u, y + ran:Float(-15, 15), 30, MOVE_DECEL)
                    end)
                    task.New(obj, function()
                        alphaAndSizeChange(obj, 255, -1, 30)
                        --obj.colli = true
                        --创建小鬼火
                        local a0 = 90
                        for i = 1, 7 do
                            table.insert(obj.children, E.enemy2.create(obj.mst, obj, obj.x, obj.y, a0 + da*i, u, color[i]))
                        end
                    end)
                end
                return main
            end
    )
    --小鬼火的移动
    M.task2 = EISlib.Bullet.Shooter.createAction(
            function(diff, rank)
                local rmax = switch1(diff, {
                    50, 50, 75, 75, no_info
                })
                local function main(obj, mst, a, u)
                    obj.u = u
                    obj.hscale, obj.vscale = 1, 1
                    obj.mst = mst
                    obj.colli = false
                    --boundWait(obj, 600)
                    enemy.setBoundTime(obj, 600)
                    setARGBAndSize(obj, 0, 255, 255, 255, 2, 2)
                    roateMoveWith2Task(obj, mst, rmax, a, --小鬼火生成的动画
                            0, 45, 0, false) --omiga, t0, t1, isRotChange
                    task.New(obj, function()
                        alphaAndSizeChange(obj, 255, -1, 45)
                    end)
                end
                return main
            end
    )
    --大鬼火变成大妖精后动作
    M.targetAction1 = EISlib.Bullet.Shooter.createAction(
            function(diff, rank)
                local v = switch1(diff, {
                    1.5, 1.5, 1.2, 1.2, 1.2
                }) + switch(rank, {
                    0, 0, 0, 0, 0.4
                })
                local da = switch1(diff, {
                    90, 90, 0, 0, 0
                })
                local function main(obj, target)
                    Del(obj) --删除弓
                    enemy.change_style(target, sty.FAIRY_MIDDLE_2_BLUE) --蓝妖精
                    enemy.changeDeathFunc(target, D.death1.main)
                    --enemy.setTauntRank(target, boss.class.TAUNT_RANK + 1) --比boss还要优先诱导
                    target.colli = true
                    if IsValid(target.mst) then
                        local a = -90 - da*target.u
                        velch_task(target, 0, v, a, 120)
                    else
                       Del(target)
                    end
                end
                return main
            end
    )
    --小鬼火变成小妖精后的动作
    M.targetAction2 = EISlib.Bullet.Shooter.createAction(
            function(diff, rank)
                local rmax = switch1(diff, {
                    50, 50, 75, 75, 75
                })
                local function main(obj, target)
                    Del(obj) --删除弓
                    enemy.change_style(target, sty.FAIRY_SMALL_2_RED)
                    robject.set_color(target, "", 150, 255, 255, 255)
                    --攻击
                    if IsValid(target.mst) then
                        S.shooter1.main(target, Angle(target, target.mst), target.bullet_co)
                        roateMoveWith2Task(target, target.mst, rmax, Angle(target.mst, target), --小妖精旋转
                                0.8*target.u, 1, 999, false) --omiga, t0, t1, isRotChange
                    else
                        Del(target)
                    end
                end
                return main
            end
    )
    --endregion
    --region 自定义敌人
    --大鬼火
    E.enemy1 = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local dmg_tran_rate = 2
                local function create(mst, x, y, a, u)
                    local obj = New(enemy, x, y, sty.RABBIT_YELLOW, --style
                            100, --hp
                            true,  --show_hpbar
                            {0, 5}, --drop
                            true, --no_count
                            D.death1.main   --death_func
                    )
                    obj.colli = false
                    setProtectTime(obj, 270)
                    --EGGlib.ObjectEvent.setDecDmgTime(obj, 0, 1, 270, 1)
                    robject.set_color(obj, "", 255, 255, 255, 255)
                    _connect(mst, obj, dmg_tran_rate, true)
                    obj.mst = mst
                    M.task1.main(obj, a, u)
                    return obj
                end
                return create
            end
    )
    --小鬼火
    E.enemy2 = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local function create(boss, mst, x, y, a, u, co)
                    local obj = New(enemy, x, y, sty.RABBIT_GREEN, --style
                            180, --hp
                            false,  --show_hpbar
                            system.DROP_NONE, --drop
                            true, --no_count
                            D.death2.main   --death_func
                    )
                    obj.colli = false
                    obj.bullet_co = co
                    robject.set_color(obj, "", 100, 255, 255, 255)
                    _connect(boss, obj, 0, true) --不传递伤害
                    M.task2.main(obj, mst, a, u)
                    return obj
                end
                return create
            end
    )
    --endregion
    --region Tasker 任务执行器
    --endregion
    --region 组合攻击
    local move = function (t, obj)
        EGGlib.ObjectEvent.moveToPlayerByCenter(0, 20, 144, 20, 20, 30, 20, 30, t, obj)
    end
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function action(b)
                    b.cast("attack_up_before")
                    task.Wait(32)
                    b.cast("attack_up_ing")
                    task.Wait(12)
                    b.cast("attack_up_after")
                end
                local wait = switch(rank, {
                    60, 60, 55, 50, 42
                })

                local function main(b, u)
                    action(b)
                    local n, obj = 1
                    P.pointer1.attack(b.x, b.y + 30, Angle(b, player), -u, COLOR_DEEP_RED)
                    task.Wait(wait - 44)
                    for _ = -u, u, 2*u do
                        if IsValid(obj) then
                            PlaySound("lazer00")
                            --箭指向大鬼火
                            b.createSpArrow(obj, b.x, b.y + 30, 90 + 90*u, COLOR_BLUE, M.targetAction1.main)
                            --箭指向小鬼火
                            for i = 1, #obj.children do
                                b.createSpArrow(obj.children[i], b.x, b.y + 30, 90 + 90*u, COLOR_BLUE, M.targetAction2.main)
                            end
                        else
                            obj = E.enemy1.create(b, b.x, b.y + 30, -90 + ran:Float(70, 75)*u, u)
                        end
                        task.Wait(wait - 44)
                        action(b)
                        n = n + 1
                    end
                    P.pointer1.attack(b.x, b.y + 30, Angle(b, player), -u, COLOR_DEEP_RED)
                    task.Wait(wait)
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
            for _, v in pairs(S) do
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
            for _, v in pairs(M) do
                v.update(difficulty, new_rank)
            end
            for _, v in pairs(D) do
                v.update(difficulty, new_rank)
            end
            rank = new_rank
        end
    end
    
    local hp = {1350, 1350, 1800, 1800}
    local names = {
        "name-boss3-card3-E",
        "name-boss3-card3-N",
        "name-boss3-card3-H",
        "name-boss3-card3-L",
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
                achi = true --成就达成flag
                  --测试用对象，可更新当前脚本
                while true do
                    for u = -1, 1, 2 do
                        reFresh()
                        C.FIRST.main(b, u)
                    end
                end
            end,
            function(b) --finish
                if achi then
                    achievement.unlock("s2_sc2", true, true) -- AchievementReminder.unlock("s2_sc2", "染不了色了", "在不击破任何一只大型妖精的前提下，收取「拟态侘寂异变的动物灵」")
                end
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard