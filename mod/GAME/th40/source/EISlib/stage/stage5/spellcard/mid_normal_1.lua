-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage5/spellcard/normal_1.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
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
    P.pointer1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = switch1(diff, {
                    4, 4, 4, 4, 5
                })
                local tmax = switch1(diff, {
                    60, 60, 60, 60, 60
                })
                local da = 360/way
                local layer = switch1(diff, {
                    1, 2, 2, 2, 2
                })
                --case:初始低速匀速阶段的速度
                local v00 = switch1(diff, {
                    0.5, 0.5, 0.5, 0.5, 0.25
                })
                local v0 = switch1(diff, {
                    2, 2.25, 2.75, 2.75, 2.75
                })*defaultSwitchVelocityByRank(rank)
                local dv = switch1(diff, {
                    0, 0.1, 0.25, 0.5, 0.5
                })*defaultSwitchVelocityByRank(rank)
                local style = stg.arrow_small
                local function attack(x, y, t, a, color)
                    PlaySound("kira00")
                    local a0, dx, dy, v, dt
                    dt = tmax - t + 5
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
                local tmax = switch1(diff, {
                    60, 60, 60, 60, 60
                })
                local wait = switch1(diff, {
                    3, 2, 1, 1, 1
                })
                local count = tmax/wait
                local function main(b, a, u, r, n, co)
                    boss.createTasker(b, b.x, b.y,
                            function(obj)
                                task.New(obj, function()
                                    local x, y = b.x + ran:Float(-5, 5), b.y + ran:Float(-5, 5)
                                    local da0 = 360/count*u
                                    for i = 0, count - 1 do
                                        P.pointer1.attack(x + r*cos(a), y + r*sin(a), tmax - wait*i, a - n*da0*i, co)
                                        task.Wait(wait)
                                        a = a + da0
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)
    --endregion
    --region 组合攻击
    local move = EGGlib.ObjectEvent.moveToPlayerDefault
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local wait = switch(rank, {
                    34, 32, 30, 28, 20
                })
                local function main(b, u)
                    T.tasker1.main(b, 90 - 90*u, u, 80, 2.5, COLOR_PURPLE)
                    task.Wait(wait)
                    move(30, b)
                    task.Wait(30)
                    T.tasker1.main(b, 90 + 90*u, -u, 100, 2.5, COLOR_YELLOW)
                    task.Wait(wait)
                    move(30, b)
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
        "name-boss7-normal1-E",
        "name-boss7-normal1-N",
        "name-boss7-normal1-H",
        "name-boss7-normal1-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "normal", --类型
            {1, 1, 7}, --时间
            500, --耐久
            system.DROP_NORMAL, --掉落
            function(b) --普通模式攻击前动作
                task.MoveTo(b, 0, 144, 60, MOVE_ACC_DEC)
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
