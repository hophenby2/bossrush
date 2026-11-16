-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage6/spellcard/normal_2.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local Bclass = EISlib.BossDefinition.Sonia
local sword = Bclass.sword
local sin = EGGlib.Math.phaseToSin
local alphaChange = EGGlib.ObjectEvent.alphaChange
local setSize = EGGlib.ObjectEvent.setSize
local warning_laser = EISlib.Bullet.Laser.warning_laser
local accdecVelch = EGGlib.ObjectEvent.accDecVelocityChange
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local move = EGGlib.ObjectEvent.moveToPlayerDefault
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local sizeAndColliChangeTask = EGGlib.ObjectEvent.sizeAndColliChangeTask
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    --剑挥一圈
    B.sword = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a, u)
                    PlaySound("lazer00")
                    local obj = New(sword, x, y)
                    setSize(obj, 1.5, -1.5*u)
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    EGGlib.RenderEffect.newTrail(
                            obj, -1, 45, 1, --master, dlayer, maxnum, frame,
                            obj.img, 1, "mul+add", --img, size, blend,
                            999, 0.5, false, 0.1, true, --times, _a_rate, Isdsize, size_min, Isdalpha
                            {255, 255, 255}, {255, 0, 0}
                    )
                    --_connect(_boss, obj, 0, true)
                    obj.rot = a
                    obj.bound = false
                    obj.class.createLight(obj, u, 45, 90, 35)
                    obj.class.createLight(obj, u, 45, 195, 35)
                    --角度更新
                    task.New(obj, function()
                        local t = 45
                        local phase, dphase = 0, 90/t
                        for _ = 1, t do
                            phase = phase + dphase
                            obj.rot = a + 180*u*sin(phase)
                            task.Wait(1)
                        end
                        alphaChange(obj, obj._a, 0, 10)
                        _del(obj, false)
                    end)
                end
                return create
            end
    )

    --预警线
    B.warning_laser = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a)
                    local obj = New(warning_laser,
                            x, y,
                            600, 10, 10, 5, a, --len, l_t, wide, w_t, a
                            "", Color(255, 255, 0, 0), --blend, color
                            30 --disappear
                    )
                    obj.bound = false
                    warning_laser.setTrailLength(obj, 40)
                end
                return create
            end
    )

    --变速弹
    B.bullet1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local style, color = stg.arrow_small_b, COLOR_CYAN
                local function create(x, y, v, a, dt, v1, a1, color)
                    local obj = stg.newSimpleBullet(x, y, stg.star_small, color, true)
                    obj.bound = false
                    obj.rot = a
                    obj.omiga = 6
                    robject.set_color(obj, "mul+add", 0, 255, 255, 255)
                    alphaChangeTask(obj, 0, 255, 60)
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET - 1
                        accdecVelch(obj, v, a, 30, 0, 30)
                        task.Wait(dt)
                        PlaySound("kira00")
                        stg.setBoundTime(stg.newStrChV(obj.x, obj.y, 0.5, v1, a1, 60, 30, style, color, true), 60)
                        _del(obj, true)
                    end)
                end
                return create
            end
    )

    --大星弹
    B.bullet2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, v, a, dt, v1, da)
                    local obj = stg.newSimpleBullet(x, y, stg.star_big, COLOR_RED, true)
                    obj.rot = a
                    obj.bound = false
                    obj.omiga = -6
                    robject.set_color(obj, "mul+add", 0, 255, 255, 255)
                    alphaChangeTask(obj, 0, 255, 60)
                    task.New(obj, function()
                        accdecVelch(obj, v, a, 60, 0, 60)
                        task.Wait(dt)
                        PlaySound("kira00")
                        local b = stg.newStrChV(obj.x, obj.y, 0, v1, a + da, 30, 0, stg.star_big, COLOR_DEEP_RED, true)
                        stg.setBoundTime(b, 60)
                        b.omiga = -6
                        _del(obj, true)
                    end)
                end
                return create
            end
    )

    --魔法导弹
    B.bullet3 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y)
                    local obj = stg.newSimpleBullet(x, y, stg.star_big, COLOR_CYAN, true)
                    setSizeAndColli(obj, 0.1, 0.1)
                    sizeAndColliChangeTask(obj, 0.9, 20)
                    local tr = EGGlib.RenderEffect.newTrail(
                            obj, -1, 30, 1, --master, dlayer, maxnum, frame,
                            "ball_light8", 1, "mul+add", --img, size, blend,
                            999, 1, true, 0.1, false, --times, _a_rate, Isdsize, size_min, Isdalpha
                            {0, 0, 255}, {255, 255, 255}
                    )
                    tr.hscale = 1.5
                    return obj
                end
                return create
            end
    )

    --endregion
    --region 子弹发射点定义
    local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
    P.pointer1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.arrow_small_b, COLOR_ROYAL_BLUE
                local layer = switch1(diff, {
                    1, 1, 2, 2, 2
                })
                local v1 = switch1(diff, {
                    1.5, 1.5, 1.75, 2, 2
                })*defaultSwitchVelocityByRank(rank)
                local dv_l = switch1(diff, {
                    0, 0.25, 0.5, 0.85, 0.85
                })*defaultSwitchVelocityByRank(rank)
                local function attack(x, y, v0, a, dt, dv, a1)
                    --PlaySound("tan00")
                    local function bullet_func(x, y, i, a)
                        B.bullet1.create(x, y, v0, a, dt, v1 + dv + dv_l*i, a1, COLOR_DEEP_BLUE + 2*i)
                    end
                    --stg.newFadeEffect(x, y, style, color, false,
                            --function()
                                circle_layer1(x, y, 0, a, --x, y, i, a
                                        1, layer, --way, layer,
                                        1, 0, 0, --di, da, dway
                                        bullet_func)
                            --end, true)
                end
                return attack
            end
    )

    local sect_layer1 = EGGlib.BulletGroup.Sector.layer1
    --大星弹
    P.pointer2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = switch1(diff, {
                    3, 3.75, 3, 3.75, 3.75
                })*defaultSwitchVelocityByRank(rank)
                local way = switch1(diff, {
                    1, 1, 2, 2, 1
                })
                local w = max(1, way - 1)
                local da = switch1(diff, {
                    0, 0, 30, 30, 30
                })/w
                local layer = switch1(diff, {
                    1, 2, 2, 3, 3
                })
                local dv = switch1(diff, {
                    0, 0, 1, 0.5, 0.5
                })
                local style, color = stg.star_big, COLOR_RED
                local function attack(x, y, v0, a, dt, da0)
                    --PlaySound("tan00")
                    local function bullet_func(x, y, v, da) --注意最后一个是da不是a
                        B.bullet2.create(x, y, v0, a, dt, v, da)
                    end
                    stg.newFadeEffect(x, y, style, color, true,
                            function()
                                sect_layer1(x, y, v, da0,
                                        way, da, --way, da,
                                        layer, dv, 0, --layer, dv_l, da_l
                                        bullet_func)
                            end)
                end
                return attack
            end
    )

    --boss本体发射的星弹
    P.pointer3 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.star_big, COLOR_BLUE
                local function bullet_func(x, y, v, a)
                    local obj = stg.newSimpleStrChV(x, y, 0.5, v, a, 120, 60, style, color)
                    obj.omiga = -6
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                end
                local v = switch1(diff, {
                    1.5, 2, 2.5, 3, 3
                })
                local layer = switch1(diff, {
                    1, 2, 3, 4, 4
                }) + switch(rank, {
                    0, 0, 0, 0, 1
                })
                local dv = switch1(diff, {
                    1, 1, 1, 1, 1
                })
                local way = switch1(diff, {
                    16, 24, 36, 48, 48
                })
                local da = 180/way
                local function attack(x, y, a)
                    PlaySound("kira00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v, a, way, layer, dv, da, 0, bullet_func)
                            end)
                end
                return attack
            end
    )
    --endregion
    --region Tasker 任务执行器
    local movePointWithPar = EGGlib.ObjectEvent.movePointWithPar
    T.tasker1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local t = 60
                local layer = switch1(diff, {
                    2, 3, 3, 3, 3
                })
                local count = 60/layer
                local wait = switch1(diff, {
                    2, 1, 1, 1, 1
                })
                local dv = switch1(diff, {
                    0.05, 0.025, 0.1, 0.1, 0.1
                })
                local function main(b, x, y, da, u)
                    PlaySound("lazer01")
                    local obj = B.bullet3.create(b.x - 25 - 10*(1-u), b.y - 10)
                    obj.bound = false
                    task.New(obj, function()
                        movePointWithPar(obj, x, y, 4, 50, u)
                        local a = Angle(obj, player) + da
                        B.warning_laser.create(obj.x, obj.y, a)
                        velchTask(obj, 4.8, 14.4, a, t) --变狙
                        task.New(obj, function()
                            local v0, dv0 = 0, 0.05
                            local n, da
                            for j = 0, count - 1 do
                                n = ran:Int(1, 3)
                                da = ran:Float(-1, 1)
                                for i = 0, layer - 1 do
                                    if j%2 == 0 and i == n then
                                        P.pointer2.attack(obj.x, obj.y, v0, a - 180*u, (count - 1 - j)*layer*(wait + 1) + (layer - 1 - i)*wait, (120 + 10*j)*u)
                                    end
                                    P.pointer1.attack(obj.x, obj.y, v0, a - 25*u, (count - 1 - j)*layer*(wait + 1) + (layer - 1 - i)*wait, dv*i, a + (70 - 6*j + 3*(i - 2))*u + da)
                                    task.Wait(wait)
                                    v0 = v0 + dv0
                                end
                            end
                            Del(obj)
                        end)
                    end)
                end
                return main
            end)
    --endregion
    --region 组合攻击
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local hyper_add_n = switch(rank, {
                    0, 0, 0, 0, 1
                })
                local function main(b, u0, n)
                    n = min(7, n + hyper_add_n)
                    b.revolveStaff()
                    local da = 95/(n - 1)
                    local x0, dx = -260, 300/(n - 1)
                    for u = -u0, u0, 2*u0 do
                        for i = 0, n - 1 do
                            T.tasker1.main(b, (x0 + dx*i)*u, 275, u*da*(i - 1), u)
                            task.Wait(10)
                        end
                    end
                    task.Wait(12)
                    b.changeToSword()
                    task.Wait(156)
                    if u0 < 0 then
                        b.rightAttack()
                    else
                        b.leftAttack()
                    end
                    B.sword.create(0, 350, -90 + 90*u0, -u0)
                    task.Wait(42)
                    b.changeToStaff()
                    task.Wait(60)
                    P.pointer3.attack(b.x, b.y, Angle(b, player))
                    task.Wait(90)
                    move(30, b, 90)
                    task.Wait(60)
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
        "name-boss8-normal2-E",
        "name-boss8-normal2-N",
        "name-boss8-normal2-H",
        "name-boss8-normal2-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "normal", --类型
            {3, 3, 40}, --时间
            1800, --耐久
            system.DROP_NORMAL, --掉落
            function(b) --普通模式攻击前动作
                task.wait(60)
                task.MoveTo(b, 0, 90, 60, MOVE_ACC_DEC)
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 90
                boss.show_aura(b, true)
            end,
            function(b) --main
                local n = switch1(difficulty, {
                    4, 5, 4, 5, 5
                })
                while true do
                    for u = -1, 1, 2 do
                        reFresh()
                        C.FIRST.main(b, u, n)
                        n = n + 1
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
