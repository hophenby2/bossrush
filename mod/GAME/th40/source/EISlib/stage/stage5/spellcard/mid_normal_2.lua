-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage5/spellcard/normal_2.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local BS = EISlib.Bullet.Shooter
local no_info = 0
local no_func = function() end
local setNextCardNoScOpenEffect = EGGlib.BossCard.setNextCardNoScOpenEffect

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    local velch = EGGlib.ObjectEvent.velocityChange
    local changeVelocity = EGGlib.ObjectEvent.changeVelocity
    local alpAndSizeCh = EGGlib.ObjectEvent.alphaAndSizeChange
    local disapear = EGGlib.ObjectEvent.disappear
    --射出去的转向自机相关弹幕
    B.bullet_demo = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y)
                    local obj = stg.newBullet(x, y, stg.arrow_big, COLOR_RED)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义
    local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
    P.pointer_demo = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.arrow_big, COLOR_RED
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v, a, way, layer, dv, da, 0, bullet_func)
                            end)
                end
                return attack
            end
    )

    --
    local polygon3 = EGGlib.BulletGroup.polygon3
    P.pointer1 = BS.createPointer(
            function(diff, rank)
                --case:一团子弹的way数
                local way = switch1(diff, {
                    10, 10, 8, 12, 12
                })
                --
                local layer = switch1(diff, {
                    1, 1, 1, 1, 1
                })
                --case：初始弹速
                local v0 = switch1(diff, {
                    1.5, 1.6, 1.7, 1.8, 2.5
                })*defaultSwitchVelocityByRank(rank)
                local dvc = switch1(diff, { --内缩/扩散相对速度
                    0.35, 0.35, 0.325, 0.35, 0.35
                })*switch(rank, {
                    1, 1, 1, 1, 1.5
                })
                local style, color = stg.ball_mid_c, COLOR_DEEP_RED
                --单个子弹
                local function bullet_func1(x, y, v, a)
                    --有弹雾的
                    return stg.newStrChV(x, y, 0.25, v0, a, 60, 20, style, color)
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
                                        v, dvc, a, a, --v, dvc, a, rot
                                        way, bullet_func1 --n, singleBulletFunc
                                )
                            end
                        end
                        bullet_func2(x, y, v0, a)
                    end
                elseif diff >= 3 then --HL难度是扩张+内缩的
                    function attack(x, y, r, a)
                        PlaySound("kira00")
                        --同向的三个子弹呈三角形发射
                        local function bullet_func2(x, y, v, a)
                            for u = -1, 1, 2 do
                                style = stg.ball_mid_c + 0.5*(u + 1)*(stg.ball_mid - stg.ball_mid_c)
                                polygon3(x, y, r, --x, y, dsc,
                                        v, dvc*u, a, a, --v, dvc, a, rot
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
    --endregion
    --region 自定义敌人
    --endregion
    --region Tasker 任务执行器
    T.tasker_demo = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local function main(b, u, co)
                    boss.createTasker(b, b.x, b.y,
                            function(obj)
                                task.New(obj, function()
                                    Del(obj)
                                end)
                    end, true) --iswait
                end
                return main
            end)

    T.tasker1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    30, 30, 60, 60, 18
                })
                local da = 26.7
                local dr = switch1(diff, {
                    -100, -100, -220, -220, -220
                })/(count - 1)
                local main
                if diff < 3 then --EN
                    function main(b, u)
                        boss.createTasker(b, b.x, b.y,
                                function(obj)
                                    task.New(obj, function()
                                        local a = 90
                                        for i = 0, count - 1 do
                                            P.pointer1.attack(b.x, b.y, 100 + dr*i, a, stg.ball_mid_c)
                                            a = a + da*u
                                            task.Wait(4)
                                        end
                                        for i = 0, count - 1 do
                                            P.pointer1.attack(b.x, b.y, -dr*i, a, stg.ball_mid)
                                            a = a + da*u
                                            task.Wait(4)
                                        end
                                        Del(obj)
                                    end)
                                end, false) --iswait
                    end
                else --HL
                    function main(b, u)
                        boss.createTasker(b, b.x, b.y,
                                function(obj)
                                    task.New(obj, function()
                                        local a = 90
                                        for i = 0, count - 1 do
                                            P.pointer1.attack(b.x, b.y, 100 + dr*i, a + da*i*u)
                                            task.Wait(4)
                                        end
                                        Del(obj)
                                    end)
                                end, false) --iswait
                    end
                end
                return main
            end)
    --endregion
    --region 组合攻击
    local move = EGGlib.ObjectEvent.moveToPlayerDefault
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main(b, u)
                    T.tasker1.main(b, u)
                    task.Wait(240)
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
        "name-boss7-normal2-E",
        "name-boss7-normal2-N",
        "name-boss7-normal2-H",
        "name-boss7-normal2-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "normal", --类型
            {1, 1, 7}, --时间
            500, --耐久
            system.DROP_NORMAL, --掉落
            function(b) --普通模式攻击前动作
                task.MoveTo(b, 0, 144, 60, MOVE_ACC_DEC)
                boss.show_aura(b, true)
                setNextCardNoScOpenEffect(b)
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 144
                boss.show_aura(b, true)
                setNextCardNoScOpenEffect(b)
            end,
            function(b) --main
                b.absorbEffect(b)
                while true do
                    reFresh()
                    for u = -1, 1, 2 do
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
