-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage4/spellcard/spell_1.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local AbsorbCircle = EGGlib.RenderEffect.AbsorbCircle
local ScBreakCircle = EGGlib.RenderEffect.ScBreakCircle
local warning_laser = EISlib.Bullet.Laser.warning_laser
local decAccVelocityChange = EGGlib.ObjectEvent.decAccVelocityChange
local velch = EGGlib.ObjectEvent.velocityChange
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local alpAndSizeCh = EGGlib.ObjectEvent.alphaAndSizeChange
local disapear = EGGlib.ObjectEvent.disappear
local rebound = EGGlib.ObjectEvent.rebound
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local alphaAndSizeChangeTask = EGGlib.ObjectEvent.alphaAndSizeChangeTask

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    local chain_bullets = {}
    --使魔触墙后返射回去的锁链发射器
    B.bullet1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function reboundEvent(obj)
                    obj.vx, obj.vy = 0, 0
                end
                local wait = 4
                local v = 9
                local da = 0
                local function create(x, y, a)
                    local obj = stg.newBullet(x, y, stg.ball_big, COLOR_RED)
                    SetV(obj, v, a)
                    obj.colli = false
                    obj.bound = false
                    obj.hide = true
                    --撞墙检测
                    task.New(obj, function()
                        task.Wait(20)
                        rebound(obj, 1, nil, reboundEvent)
                        P.pointer1.attack(obj.x, obj.y, Angle(obj, player), COLOR_YELLOW)
                        _del(obj, false)
                    end)
                    --发射锁链
                    task.New(obj, function()
                        local i = 0
                        while true do
                            for u = -1, 1, 2 do
                                B.bullet2.create(obj.x, obj.y, a + 90*(u + 1), u, da*i*u)
                            end
                            task.Wait(wait)
                            i = i + 1
                        end
                    end)
                end
                return create
            end
    )

    --锁链苦无
    B.bullet2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v = switch1(diff, {
                    2.5, 3, 3.5, 4, 4
                })*defaultSwitchVelocityByRank(rank)
                local function create(x, y, a, u, da)
                    local obj = stg.newBullet(x, y, stg.arrow_small, COLOR_YELLOW)
                    obj.rot = a
                    obj.release = false
                    table.insert(chain_bullets, obj)
                    task.New(obj, function()
                        velch(obj, 0.7, 0, obj.rot, 30)
                        while not obj.release do
                            task.Wait(1)
                        end
                        PlaySound("kira00")
                        robject.set_color(stg.newStrChV(obj.x, obj.y, 0, v, a + da, 30, 0, stg.water_drop, COLOR_ORANGE), "mul+add", 255, 255, 255, 255)
                        _del(obj)
                    end)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义
    --一圈环弹
    P.pointer1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = switch1(diff, {
                    1, 1.25, 1.25, 1.25, 1.25
                })*defaultSwitchVelocityByRank(rank)
                local way = switch1(diff, {
                    10, 15, 15, 20, 20
                })
                local da = 180/way
                local layer = switch1(diff, {
                    1, 1, 2, 2, 2
                }) + switch(rank, {
                    0, 0, 0, 0, 1
                })
                local dv = 0.25*defaultSwitchVelocityByRank(rank)
                local style, color = stg.ball_mid, COLOR_RED
                local function bullet_func(x, y, v, a)
                    New(warning_laser,
                            x, y,
                            700, 30, 3, 5, a, --len, l_t, wide, w_t, a
                            "mul+add", Color(200, 255, 0, 0), --blend, color
                            60 --disappear
                    ).bound = false
                    for i = 0, layer - 1 do
                        stg.newSimpleStrChV(x, y, 0, v + dv*i, a, 30, 0, style, color)
                    end
                end
                local function attack(x, y, a)
                    if not (diff == 1 and y < 0) then
                        PlaySound("tan00")
                        stg.newFadeEffect(x, y, style, color, false,
                                function()
                                    circle_layer1(x, y, v, a + da, way, 1, 0, 0, 0, bullet_func)
                                end)
                    end
                end
                return attack
            end
    )

    --一圈大玉
    P.huge = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = switch1(diff, {
                    1, 1, 1, 1, 1
                })*defaultSwitchVelocityByRank(rank)
                local layer = switch1(diff, {
                    2, 3, 4, 5, 5
                }) + switch(rank, {
                    0, 0, 0, 0, 1
                })
                local dv = switch1(diff, {
                    0.5, 0.5, 0.5, 0.5, 0.5
                })*defaultSwitchVelocityByRank(rank)
                local way = switch1(diff, {
                    16, 21, 27, 33, 33
                })
                local da = switch1(diff, {
                    180/way, 0, 0, 0, 0
                })
                local style, color = stg.ball_huge, COLOR_YELLOW
                local function bullet_func(x, y, v, a)
                    robject.set_color(stg.newSimpleStraight(x, y, v, a, style, color), "mul+add", 255, 255, 255, 255)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v, a + da, way, layer, dv, 0, 0, bullet_func)
                            end)
                end
                return attack
            end
    )
    --endregion
    --region 自定义敌人
    E.enemy1 = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local function reboundEvent(obj)
                    obj.vx, obj.vy = 0, 0
                    velch(obj, 2, 0, obj.angle, 10)
                end
                local function create(b, a, da)
                    local obj = b.createMagic(b.x, b.y,
                            120, false, --hp, show_hp
                            {0, 0}, --drop
                            no_func, --death_func
                            COLOR_RED, COLOR_YELLOW --co1, co2
                    )
                    _connect(b, obj, 0, true)
                    --拖影
                    EGGlib.RenderEffect.newTrail(
                            obj, -1, 20, 1, --master, dlayer, maxnum, frame,
                            obj.img, 1.5, "mul+add", --img, size, blend,
                            999, 0.5, true, 0.1, false, --times, _a_rate, Isdsize, size_min, Isdalpha
                            {255, 255, 0}, {255, 255, 255}
                    )
                    obj.bound = false
                    obj.colli = false
                    obj.angle = a
                    task.New(obj, function()
                        decAccVelocityChange(obj,
                                3, 1, 6, a, --v0, v1, v2, a
                                0, 20, 0, 30--wt, t0, t1, t2
                        )
                        rebound(obj, 1, nil, reboundEvent)
                        --放出预警线和锁链
                        New(warning_laser,
                                obj.x, obj.y,
                                700, 30, 3, 10, a + 180 + da, --len, l_t, wide, w_t, a
                                "", Color(200, 255, 255, 100), --blend, color
                                60 --disappear
                        ).bound = false
                        New(AbsorbCircle, obj.x, obj.y, 1, 150, 150, 0, "mul+add")
                        B.bullet1.create(obj.x, obj.y, a + 180 + da)--锁链生成器
                        task.Wait(30)
                        New(ScBreakCircle, obj.x, obj.y, 1, 150, 150, 0)
                        P.pointer1.attack(obj.x, obj.y, Angle(obj, player), COLOR_ORANGE)
                        _del(obj, false)
                    end)
                end
                return create
            end
    )

    --endregion
    --region Tasker 任务执行器
    --发射最初的使魔
    T.tasker1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    8, 8, 8, 8, 8
                })
                local wait = 64/count
                local da = 180/count
                --使魔衍生锁链发射器偏角
                local da0 = switch1(diff, {
                    -10, -10, -10, -10, -10
                }) + switch(rank, {
                    0, 0, 0, 0, 5
                })
                local function main(b)
                    boss.createTasker(b, b.x, b.y,
                            function(obj)
                                task.New(obj, function()
                                    for i = 0.5, count - 0.5 do
                                        for u = -1, 1, 2 do
                                            E.enemy1.create(b, -90 + da*u*i, da0*u)
                                        end
                                        task.Wait(wait)
                                    end
                                    Del(obj)
                                end)
                    end, true) --iswait
                end
                return main
            end)

    --生成火弹，引爆锁链
    T.tasker2 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local way = switch1(diff, {
                    3, 4, 5, 6, 6
                })*switch(rank, {
                    1, 1, 1, 1, 1.34
                })
                way = math.floor(way) --向下取整
                local count = switch1(diff, {
                    60, 60, 60, 60, 60
                })
                local da_w = 45/(way - 1)
                local da_c = 360/(count - 1)
                local wait = 1
                local r0, dr_c, dr_w = -300, 250/(count - 1), 50/(way - 1)
                local v0 = switch1(diff, {
                    1, 1, 1, 1.25, 1.25
                })*defaultSwitchVelocityByRank(rank)
                local v_range = 0.2*defaultSwitchVelocityByRank(rank)
                local dv_w = switch1(diff, {
                    0.25, 0.25, 0.25, 0.25, 0.25
                })*defaultSwitchVelocityByRank(rank)
                local function main(b, u)
                    boss.createTasker(b, b.x, b.y,
                            function(obj)
                                task.New(obj, function()
                                    b.absorbEffect(b)
                                    PlaySound("ch00")
                                    local a, r, x, y
                                    for i = 0, count - 1 do
                                        for j = 0, way - 1 do
                                            a = -90 + (30 + da_c*i + da_w*j)*u
                                            r = r0 + dr_c*i + dr_w*j
                                            x, y = b.x + r*cos(a), b.y + r*sin(a)
                                            if Dist(x, y, player.x, player.y) > 50 then
                                                robject.set_color(stg.newStrChV(x, y, 4, v0 + ran:Float(-0.5*v_range, 0.5*v_range) + dv_w*j, a + ran:Float(-2.5, 2.5), 30, 20, stg.water_drop, COLOR_RED), "mul+add", 255, 255, 255, 255)
                                            end
                                        end
                                        task.Wait(wait)
                                    end
                                    --task.Wait(60)
                                    b.breakEffect(b)
                                    PlaySound("enep02")
                                    local r, dr = 0, 600/90
                                    for _ = 1, 90 do
                                        r = r + dr
                                        sp.UnitListUpdate(chain_bullets) --先把无效对象剔除
                                        --锁链断开
                                        for _, obj in pairs(chain_bullets) do
                                            if not obj.release and r > Dist(obj.x, obj.y, b.x, b.y) then
                                                obj.release = true
                                            end
                                        end
                                        task.Wait(1)
                                    end
                                    Del(obj)
                                end)
                            end, true) --iswait
                end
                return main
            end)

    --endregion
    --region 组合攻击
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main(b, u)
                    P.huge.attack(b.x, b.y, Angle(b, player))
                    T.tasker1.main(b)
                    task.Wait(90)
                    task.MoveTo(b, b.x, max(0, b.y - 20), 120, MOVE_ACC_DEC)
                    T.tasker2.main(b, u)
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
        "name-boss6-card1-E",
        "name-boss6-card1-N",
        "name-boss6-card1-H",
        "name-boss6-card1-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "spellcard", --类型
            {3, 3, 45}, --时间
            3000, --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                task.Wait(60)
                task.MoveTo(b, 0, 144, 60, MOVE_NORMAL)
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 144
                boss.show_aura(b, true)
            end,
            function(b) --main
                chain_bullets = {}
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
