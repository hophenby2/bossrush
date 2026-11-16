-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage4/spellcard/normal_1.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local disapear = EGGlib.ObjectEvent.disappear
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local sty = EISlib.Enemy.Style
local warning_laser2 = EISlib.Bullet.Laser.warning_laser2
local lead_laser = EISlib.Bullet.Laser.lead_laser
local rotateMoveWith2Task = EGGlib.ObjectEvent.rotateMoveWith2Task
local move = EGGlib.ObjectEvent.moveToPlayerDefault

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    --endregion
    --region 子弹发射点定义
    P.ball_mid_c = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = switch1(diff, {
                    1, 1, 1, 1, 2
                })
                local v = switch1(diff, {
                    1.75, 2, 2.25, 2.5, 3.25
                })*defaultSwitchVelocityByRank(rank)
                local style, color = stg.ball_mid_c, COLOR_YELLOW
                local function bullet_func(x, y, v, a)
                    stg.setBoundTime(stg.newSimpleStraight(x, y, v, a, style, color), 30)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v, a, way, --x, y, v, a, way
                                        1, 0, 0, 0, --layer, dv, da, dway
                                        bullet_func
                                )
                            end, true)
                end
                return attack
            end
    )

    P.grain_a = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = switch1(diff, {
                    2.25, 2.5, 2.75, 3, 1
                })*defaultSwitchVelocityByRank(rank)
                local dv = switch1(diff, {
                    0.15, 0.166, 0.18, 0.2, 0.25
                })*defaultSwitchVelocityByRank(rank)
                local count = switch1(diff, {
                    5, 6, 7, 8, 8
                }) + switch(rank, {
                    0, 0, 0, 0, 2
                })
                local style, color = stg.grain_a, COLOR_ORANGE
                local function attack(r, a)
                    local x, y, dx, dy = _boss.x, _boss.y, cos(a), sin(a)
                    boss.createTasker(_boss, x + r*dx, y + r*dy,
                            function(obj)
                                task.New(obj, function()
                                    for i = 0, count - 1 do
                                        r = r - 20
                                        obj.x, obj.y = x + r*dx, y + r*dy
                                        PlaySound("kira00")
                                        stg.newStraight(obj.x, obj.y, v + dv*i, a, style, color)
                                        task.Wait(3)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return attack
            end
    )

    P.ball_big = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = switch1(diff, {
                    16, 24, 28, 32, 32
                })
                local v = switch1(diff, {
                    1.75, 2, 2.25, 2.5, 2.5
                })*defaultSwitchVelocityByRank(rank)
                local style, color = stg.ball_big, COLOR_RED
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStraight(x, y, v, a, style, color)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v, a, way, 1, 0, 0, 0, bullet_func)
                            end)
                end
                return attack
            end
    )
    --endregion

    --region 使魔定义
    --endregion
    --region Tasker 任务执行器
    T.ball_mid_c = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                --转一圈需要的时间
                local T = 120
                --转一圈攻击的次数
                local count = switch1(diff, {
                    16, 24, 40, 48, 48
                })
                --攻击间隔
                local wait = switch1(diff, {
                    2, 2, 2, 2, 2
                })
                --转速
                local omiga = 144/count

                local da = switch1(diff, {
                    0, 90, 90, 90, 90
                })
                local function main(r, a, u)
                    boss.createTasker(_boss, _boss.x, _boss.y,
                            function(obj)
                                task.New(obj, function()
                                    obj.bound = false
                                    robject.set_color(obj, "", 0, 255, 255, 255)
                                    obj.colli = false
                                    rotateMoveWith2Task(obj, _boss, r, a, omiga*u, 60, _infinite, false) --obj, mst, rmax, a, omiga, t0, t1, IsRotChange
                                    alphaChangeTask(obj, 0, 255, 60)
                                    task.Wait(60)
                                    for _ = 0, count - 1 do
                                        if IsValid(_boss) then
                                            a = Angle(_boss, obj)
                                            P.ball_mid_c.attack(obj.x, obj.y, a - da*u)
                                        else
                                            break
                                        end
                                        task.Wait(wait)
                                    end
                                    _del(obj, false)
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --搞个狙狙死你
    T.aimToPlayer = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    3, 6, 8, 10, 8
                })
                local wait = 360/count
                local function main(b)
                    boss.createTasker(b, b.x, b.y,
                            function(obj)
                                task.New(obj, function()
                                    local a
                                    for _ = 0, count - 1 do
                                        if rank == 4 then
                                            a = ran:Float(0, 360)
                                        else
                                            a = Angle(b, player)
                                        end
                                        P.ball_big.attack(b.x, b.y, a)
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
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local wait = 2
                local function main(b)
                    b.cast("cast")
                    --狙
                    T.aimToPlayer.main(b)
                    --半固定部分
                    local a0 = ran:Float(-5, 5)
                    for i = 0, 10 do
                        for u = -1, 1, 2 do
                            T.ball_mid_c.main(100 - 6*i, 90 + (120 + a0 - 20*i)*u, u)
                        end
                        for j = 0, 4 do
                            for u = -1, 1, 2 do
                                P.grain_a.attack(100 - 3*(5*i + j), 90 + (180 - 6.5*(5*i + j))*u)
                            end
                            task.Wait(5)
                        end
                    end
                    task.Wait(150)
                    move(30, b, 120)
                    task.Wait(30)
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
    
    local names = {
        "name-boss6-normal1-E",
        "name-boss6-normal1-N",
        "name-boss6-normal1-H",
        "name-boss6-normal1-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "normal", --类型
            {3, 3, 30}, --时间
            1600, --耐久
            system.DROP_NORMAL, --掉落
            function(b) --普通模式攻击前动作
                -- 加载
                LoadMusicRecord("s4_boss")
                dialog.utility.cacheResource("Stage4")
                -- 对话
                dialog.scene.stage4_p1s(function()
                    task.MoveTo(b, 0, 120, 60, MOVE_ACC_DEC)
                    system.record.unlockPerformer("Lechat")
                end, true) -- 要解锁音乐室的
                boss.setUInameDisplay(b, true)
                -- 开打
                system.PowerRank.resumeHyper() --从这里计时
                boss.show_aura(b, true)
                task.wait(60)
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 120
                boss.show_aura(b, true)
            end,
            function(b) --main
                reFresh()
                while true do
                    reFresh()
                    C.FIRST.main(b)
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
