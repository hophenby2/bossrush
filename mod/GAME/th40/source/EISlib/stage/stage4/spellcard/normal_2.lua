-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage4/spellcard/normal_2.lua" --当前存放目录
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
local simPar = EGGlib.ObjectEvent.simPar
local boundWait = EGGlib.ObjectEvent.boundWait
local move = EGGlib.ObjectEvent.moveToPlayerDefault


local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    --endregion
    --region 子弹发射点定义
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
                local function attack(x, y, a)
                    local dx, dy = cos(a), sin(a)
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                task.New(obj, function()
                                    local r = 0
                                    for i = 0, count - 1 do
                                        PlaySound("kira00")
                                        stg.newStraight(obj.x, obj.y, v + dv*i, a, style, color)
                                        task.Wait(3)
                                        r = r - 20
                                        obj.x, obj.y = x + r*dx, y + r*dy
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
                    15, 20, 25, 30, 30
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

    --二阶段弹幕1
    P.ball_mid_c = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local r0 = 100
                local yDr = 0.8 --圆高度与半径的比值
                local way = switch1(diff, {
                    12, 16, 16, 24, 24
                }) + switch(rank, {
                    0, 0, 0, 0, 8
                })
                local da = 360/way
                local da0 = 30
                local v = switch1(diff, {
                    1.75, 2, 2.25, 2.5, 2.25
                })*defaultSwitchVelocityByRank(rank)
                local style, color = stg.ball_mid_c, COLOR_YELLOW
                local function bullet_func(x, y, v, a)
                    stg.newStraight(x, y, v, a, style, color)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    for i = 0, way - 1 do
                        for u = -1, 1, 2 do
                            bullet_func(x + r0*cos(a + da*i), y + yDr*r0*sin(a + da*i), v, a + da*i + da0*u)
                        end
                    end
                end
                return attack
            end
    )
    --endregion

    --region 使魔定义
    --endregion
    --region Tasker 任务执行器
    --搞个狙狙死你
    T.aimToPlayer = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    2, 2, 4, 4, 4
                })
                local wait = 180/count
                local function main(b)
                    boss.createTasker(b, b.x, b.y,
                            function(obj)
                                task.New(obj, function()
                                    for _ = 0, count - 1 do
                                        P.ball_big.attack(b.x, b.y, Angle(b, player))
                                        task.Wait(wait)
                                        P.ball_mid_c.attack(b.x, b.y, Angle(b, player))
                                        task.Wait(wait)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)


    --
    T.grain_b = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local wait = switch1(diff, {
                    10, 9, 8, 7, 7
                })
                local function main(b, x0, y0, a, da, u, style, color)
                    boss.createTasker(b, x0, y0,
                            function(obj)
                                boundWait(obj, 60)
                                simPar(obj, 4, a, 0.05, a + 90*u)
                                task.New(obj, function()
                                    while true do
                                        P.grain_a.attack(obj.x, obj.y, Angle(0, 0, obj.vx, obj.vy) + da*u, style, color)
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
                local wait = 60
                local function main(b)
                    --狙
                    T.aimToPlayer.main(b)
                    --半固定部分
                    for u = -1, 1, 2 do
                        T.grain_b.main(b, b.x - 192*u, b.y - 100, 90*(1-u), -135, u)
                        T.grain_b.main(b, b.x - 192*u, b.y - 100, 90*(1-u), 135, u)
                        task.Wait(wait)
                    end
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
        "name-boss6-normal2-E",
        "name-boss6-normal2-N",
        "name-boss6-normal2-H",
        "name-boss6-normal2-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "normal", --类型
            {3, 3, 30}, --时间
            1600, --耐久
            system.DROP_NORMAL, --掉落
            function(b) --普通模式攻击前动作
                task.wait(60)
                task.MoveTo(b, 0, 120, 60, MOVE_NORMAL)
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
                effect.shakeScreen(20, 3)
                for _ = 1, 2 do
                    b.breakEffect(b)
                end
                New(boss_death_circle, b.x, b.y)
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
