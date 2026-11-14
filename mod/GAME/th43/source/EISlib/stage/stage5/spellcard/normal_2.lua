-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage5/spellcard/normal_2.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local BS = EISlib.Bullet.Shooter
local no_info = 0
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local alpAndSizeCh = EGGlib.ObjectEvent.alphaAndSizeChange
local disapear = EGGlib.ObjectEvent.disappear
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local polygon3 = EGGlib.BulletGroup.polygon3
local alphaAndSizeChangeTask = EGGlib.ObjectEvent.alphaAndSizeChangeTask
local move = EGGlib.ObjectEvent.moveToPlayerDefault


local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    --endregion
    --region 子弹发射点定义
    --内缩圆弹
    P.pointer1 = BS.createPointer(
            function(diff, rank)
                --case:一团子弹的way数
                local way = 12 + switch(rank, {
                    0, 0, 0, 0, 1
                })
                --
                local layer = 1
                --case：初始弹速
                local v0 = switch1(diff, {
                    1.5, 1.6, 1.45, 1.8, 1.8
                })*defaultSwitchVelocityByRank(rank)
                local dvc = switch1(diff, { --内缩/扩散相对速度
                    0.83, 0.89, 0.8, 1, 1
                })*defaultSwitchVelocityByRank(rank)
                local style, color = stg.ball_mid_c, COLOR_DEEP_RED
                --单个子弹
                local function bullet_func1(x, y, v, a)
                    local obj = stg.newStrChV(x, y, 0.25, v0, a, 60, 20, style, color)
                    stg.setBoundTime(obj, 30)
                    --有弹雾的
                    return obj
                end
                local attack
                if diff == 1 then --E难度只产生内缩的
                    function attack(x, y, r, a, st)
                        style = st or style
                        PlaySound("kira00")
                        --同向的三个子弹呈三角形发射
                        local function bullet_func2(x, y, v, a)
                            for i = 0, layer - 1 do
                                polygon3(x, y, r, --x, y, dsc,
                                        v, -dvc, a, a, --v, dvc, a, rot
                                        way, bullet_func1 --n, singleBulletFunc
                                )
                            end
                        end
                        bullet_func2(x, y, v0, a)
                    end
                elseif diff == 2 then --N难度只产生扩张的
                    function attack(x, y, r, a, st)
                        style = st or style
                        PlaySound("kira00")
                        --同向的三个子弹呈三角形发射
                        local function bullet_func2(x, y, v, a)
                            for i = 0, layer - 1 do
                                polygon3(x, y, r, --x, y, dsc,
                                        v, -0.6*dvc, a, a, --v, dvc, a, rot
                                        way, bullet_func1 --n, singleBulletFunc
                                )
                            end
                        end
                        bullet_func2(x, y, v0, a)
                    end
                elseif diff >= 3 then --HL难度是扩张+内缩的
                    local rate = {-1.05, -0.6}
                    function attack(x, y, r, a)
                        PlaySound("kira00")
                        --同向的三个子弹呈三角形发射
                        local function bullet_func2(x, y, v, a)
                            for i = 1, 2 do
                                style = stg.ball_mid_c + (i - 1)*(stg.ball_mid - stg.ball_mid_c)
                                polygon3(x, y, r, --x, y, dsc,
                                        v, dvc*rate[i], a, a, --v, dvc, a, rot
                                        way, bullet_func1 --n, singleBulletFunc
                                )
                            end
                        end
                        bullet_func2(x, y, v0, a)
                    end
                end
                return attack
            end
    )

    --只是简单的少way开花弹
    P.pointer2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                --一个子弹单元way数
                local way = switch1(diff, {
                    2, 2, 2, 3, 3
                })
                local tmax = 30
                local da = 360/way
                local layer = switch1(diff, {
                    1, 2, 2, 2, 2
                })
                --case:初始低速匀速阶段的速度
                local v00 = switch1(diff, {
                    0.25, 0.25, 0.25, 0.25, 0.1
                })
                local v0 = switch1(diff, {
                    1.75, 2, 2.25, 2.5, 2.5
                })*defaultSwitchVelocityByRank(rank)
                local dv = switch1(diff, {
                    0, 0.2, 0.3, 0.4, 0.5
                })*defaultSwitchVelocityByRank(rank)
                local style = stg.arrow_small
                local function attack(x, y, t, a, color)
                    PlaySound("kira00")
                    local a0, dx, dy, v, dt
                    dt = tmax - t
                    for i = 0, way - 1 do
                        a0 = a + da*i
                        dx, dy = dt*v00*cos(a0), dt*v00*sin(a0)
                        for j = 0, layer - 1 do
                            v = v0 + dv*j
                            stg.newStrChV(x + dx, y + dy, v00, v, a0, 60, t, style, color)
                        end
                    end
                end
                return attack
            end
    )
    --endregion
    --region 自定义敌人
    --endregion
    --region Tasker 任务执行器
    T.tasker1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    20, 20, 20, 20, 18
                })
                local da = 360/count
                local r0 = 100
                local dr = switch1(diff, {
                    50, 50, 50, 50, 50
                })/(count - 1)
                local main
                if diff < 3 then --EN
                    local style_list = {stg.ball_mid_c, stg.ball_mid}
                    function main(b, u, dy)
                        boss.createTasker(b, b.x, b.y,
                                function(obj)
                                    task.New(obj, function()
                                        local a = 90
                                        for i = 0, count - 1 do
                                            P.pointer1.attack(b.x, b.y + dy, r0 + dr*i, a, style_list[diff])
                                            a = a + da*u
                                            task.Wait(3)
                                        end
                                        Del(obj)
                                    end)
                                end, false) --iswait
                    end
                else --HL
                    function main(b, u, dy)
                        boss.createTasker(b, b.x, b.y,
                                function(obj)
                                    task.New(obj, function()
                                        local a = 90
                                        for i = 0, count - 1 do
                                            P.pointer1.attack(b.x, b.y + dy, r0 + dr*i, a + da*i*u)
                                            task.Wait(3)
                                        end
                                        Del(obj)
                                    end)
                                end, false) --iswait
                    end
                end
                return main
            end)

    T.tasker2 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    10, 10, 10, 10, 20
                })
                local way = switch1(diff, {
                    5, 5, 5, 6, 6
                })
                local da_way = 60/way
                local tmax = 30
                local wait = switch1(diff, {
                    3, 3, 3, 3, 3
                })
                local r0 = 50
                local dr = 100/(count - 1)
                local n = switch1(diff, {
                    3, 3, 3, 3, 3
                })
                local function main(b, a, u, co)
                    boss.createTasker(b, b.x, b.y,
                            function(obj)
                                task.New(obj, function()
                                    local x, y, r, a0 = b.x + ran:Float(-5, 5), b.y + ran:Float(-5, 5)
                                    local da0 = 360/count*u
                                    for i = 0, count - 1 do
                                        r = r0 + dr*i
                                        for j = 1, way do
                                            a0 = a + da0*i + da_way*j
                                            P.pointer2.attack(x + r*cos(a0), y + r*sin(a0), tmax - wait*i, a0 - n*da0*i, co)
                                        end
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
                local function main(b, u)
                    T.tasker1.main(b, u, -30)
                    task.Wait(30)
                    move(30, b, 160)
                    task.Wait(30)
                    T.tasker1.main(b, -u, 0)
                    task.Wait(30)
                    move(30, b, 160)
                    task.Wait(30)
                    T.tasker1.main(b, u, 30)
                    task.Wait(30)
                    move(30, b, 160)
                    task.Wait(30)
                    T.tasker2.main(b, 90, -u, COLOR_YELLOW)
                    task.Wait(30)
                    T.tasker2.main(b, 90, u, COLOR_PURPLE)
                    task.Wait(120)
                    move(30, b, 160)
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
        "name-boss7-normal4-E",
        "name-boss7-normal4-N",
        "name-boss7-normal4-H",
        "name-boss7-normal4-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "normal", --类型
            {3, 3, 40}, --时间
            1400, --耐久
            system.DROP_NORMAL, --掉落
            function(b) --普通模式攻击前动作
                task.wait(60)
                task.MoveTo(b, 0, 160, 60, MOVE_ACC_DEC)
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 160
                boss.show_aura(b, true)
            end,
            function(b) --main
                while true do
                    for u = -1, 1, 2 do
                        reFresh()
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
