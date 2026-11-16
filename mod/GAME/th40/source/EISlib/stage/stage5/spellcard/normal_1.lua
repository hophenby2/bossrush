-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage5/spellcard/normal_1.lua" --当前存放目录
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
                local way = 12
                --
                local layer = 1
                --case：初始弹速
                local v0 = switch1(diff, {
                    1.75, 2.25, 2.75, 3.2, 3.2
                })*defaultSwitchVelocityByRank(rank)
                local dvc = switch1(diff, { --内缩/扩散相对速度
                    0.6, 0.5, 0.86, 1, 1
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
                                        v, -dvc, a, a, --v, dvc, a, rot
                                        way, bullet_func1 --n, singleBulletFunc
                                )
                            end
                        end
                        bullet_func2(x, y, v0, a)
                    end
                elseif diff >= 3 then --HL难度是扩张+内缩的
                    local rate = {-0.7, -1.35}
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

    P.pointer2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = switch1(diff, {
                    3, 4, 4, 3, 4
                })
                local tmax = 30
                local da = 360/way
                local layer = switch1(diff, {
                    1, 1, 2, 2, 2
                })
                --case:初始低速匀速阶段的速度
                local v00 = switch1(diff, {
                    0.5, 0.5, 0.5, 0.5, 0.5
                })
                local v0 = switch1(diff, {
                    1.5, 1.75, 2, 2.2, 2.2
                })*defaultSwitchVelocityByRank(rank)
                local dv = switch1(diff, {
                    0, 0, 0, 0.5, 0.75
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
                            stg.newStrChV(x + dx, y + dy, v00, v, a0, 30, t, style, color)
                        end
                    end
                end
                return attack
            end
    )
    --endregion
    --region Tasker 任务执行器
    T.tasker1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = 6
                local r0 = 120
                local dr = -70
                local style_list = {stg.ball_mid_c, stg.ball_mid, stg.ball_mid_c, stg.ball_mid}
                local function main(b, u, dy, dcount)
                    local count = count + dcount
                    local dr = dr/(count - 1)
                    local da = 180/count
                    boss.createTasker(b, b.x, b.y,
                            function(obj)
                                task.New(obj, function()
                                    local a = 90 + 90*u + ran:Float(-5, 5)
                                    for i = 0, count - 1 do
                                        P.pointer1.attack(b.x, b.y + dy, r0 + dr*i, a, style_list[diff])
                                        a = a + da*u
                                        task.Wait(4)
                                    end
                                    Del(obj)
                                end)
                            end, true) --iswait
                end
                return main
            end)

    T.tasker2 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local tmax = switch1(diff, {
                    40, 25, 30, 35, 35
                })
                local wait = switch1(diff, {
                    2, 1, 1, 1, 1
                })
                local count = tmax/wait
                local main
                if rank < 4 then
                    function main(b, a, u, co, dy)
                        boss.createTasker(b, b.x, b.y,
                                function(obj)
                                    task.New(obj, function()
                                        local x, y = b.x, b.y
                                        local a0, da0 = 90 - 90*u + a, 240/count*u
                                        for i = 0, count - 1 do
                                            for _ = 0, 0.5*(tranU(i) + 1) do
                                                P.pointer2.attack(x + 100*cos(a0), y + dy + 100*sin(a0), tmax - wait*i, a0, co)
                                                a0 = a0 + da0
                                            end
                                            task.Wait(wait)
                                        end
                                        Del(obj)
                                    end)
                                end, true) --iswait
                    end
                else
                    function main(b, a, u, co, dy)
                        boss.createTasker(b, b.x, b.y,
                                function(obj)
                                    task.New(obj, function()
                                        local x, y = b.x, b.y
                                        local a0, da0 = 90 - 90*u + a, 180/count*u
                                        for i = 0, count - 1 do
                                            for _ = 0, 1 do
                                                P.pointer2.attack(x + 100*cos(a0), y + dy + 100*sin(a0), tmax - wait*i, a0, co)
                                                a0 = a0 + da0
                                            end
                                            task.Wait(wait)
                                        end
                                        Del(obj)
                                    end)
                                end, true) --iswait
                    end
                end
                return main
            end)
    --endregion
    --region 组合攻击
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main(b, u)
                    for i = 0, 3 do
                        T.tasker1.main(b, u*tranU(i), 0, 2*i)
                    end
                    local a = ran:Float(-5, 5)
                    T.tasker2.main(b, a, u, COLOR_YELLOW, 0)
                    T.tasker2.main(b, a, u, COLOR_PURPLE, 0)
                    task.Wait(90)
                    move(45, b)
                    task.Wait(45)
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
        "name-boss7-normal3-E",
        "name-boss7-normal3-N",
        "name-boss7-normal3-H",
        "name-boss7-normal3-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "normal", --类型
            {3, 3, 40}, --时间
            1400, --耐久
            system.DROP_NORMAL, --掉落
            function(b) --普通模式攻击前动作
                -- 加载
                LoadMusicRecord("s5_boss")
                dialog.utility.cacheResource("Stage5")
                -- 直接进场对线
                task.MoveTo(b, 0, 144, 60, MOVE_ACC_DEC)
                system.record.unlockPerformer("Hearn")
                -- 对话
                dialog.scene.stage5_p1s(true) -- 得解锁音乐室
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
