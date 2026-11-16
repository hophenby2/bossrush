-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage3/spellcard/spell_1.lua" --当前存放目录
local no_func = function() end
local no_info = 0
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local warning_laser = EISlib.Bullet.Laser.warning_laser
local lead_laser = EISlib.Bullet.Laser.lead_laser
local circle_normal1 = EGGlib.BulletGroup.Circle.normal1
local alphaAndSizeChangeTask = EGGlib.ObjectEvent.alphaAndSizeChangeTask

local function createCard(difficulty)
    local B, P, S, C, T, E = {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    B.laser1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v = switch1(diff, {
                    6, 7, 8, 10, 10
                })
                local function create(x, y, a)
                    local obj = New(warning_laser,
                            x, y,
                            600, 30, 1, 5, a, --len, l_t, wide, w_t, a
                            "", Color(255, 255, 255, 255), --blend, color
                            60 --disappear
                    )
                    _connect(_boss, obj, 0, true)
                    task.New(obj, function()
                        task.Wait(40)
                        PlaySound("lazer01")
                        New(lead_laser,
                                1, COLOR_YELLOW, --type, co
                                x, y, v, a, --x, y, v, a
                                600, 6, 10, 1, --len, w0, w1, w_t
                                false, false, 180 --islock, isshoot, disappear
                        )
                    end)
                end
                return create
            end
    )
    --抓痕
    B.laser2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a, len, u)
                    local obj = New(warning_laser,
                            x, y,
                            600, 30, 5, 10, a, --len, l_t, wide, w_t, a
                            "mul+add", Color(200, 255, 0, 0), --blend, color
                            61 --disappear
                    )
                    _connect(_boss, obj, 0, true)
                    obj.bound = false
                    task.New(obj, function()
                        task.Wait(60)
                        PlaySound("lazer01")
                        B.laser3.create(x, y, a, len, u)
                    end)
                end
                return create
            end
    )

    --抓痕的实体激光
    B.laser3 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v = switch1(diff, {
                    no_info, no_info, 20, 20, no_info
                })
                local wait = switch1(diff, {
                    no_info, no_info, 3, 2, no_info
                })
                local v0 = switch1(diff, {
                    no_info, no_info, 1.5, 2, no_info
                })*defaultSwitchVelocityByRank(rank)
                local da0 = switch1(diff, {
                    no_info, no_info, 80, 80, no_info
                }) + switch(rank, {
                    0, 0, 0, 0, 25
                })
                local da = switch1(diff, {
                    no_info, no_info, 1, 1, no_info
                })*switch(rank, {
                    1, 1, 1, 1, 1
                })
                local dt = switch(rank, {
                    60, 60, 60, 60, 30
                })
                local function create(x, y, a, len, u)
                    local obj = New(lead_laser,
                            1, COLOR_RED, --type, co
                            x, y, v, a, --x, y, v, a
                            len, 20, 30, 1, --len, w0, w1, w_t
                            false, false, 180 --islock, isshoot, disappear
                    )
                    _connect(_boss, obj, 0, true)
                    obj.bound = false
                    task.New(obj, function()
                        task.Wait(len/v)
                        local a, dx, dy, x, y = obj.rot + 180, 40*cos(obj.rot), 40*sin(obj.rot)
                        for i = 0, 60 do
                            x, y = obj.x + dx, obj.y + dy
                            if Dist(x, y, player.x, player.y) > 45 and obj.y > -192 then
                                robject.set_color(stg.newStrChV(x, y, 0.5, v0, a - (da0 + da*i)*u, 60, dt, stg.water_drop, COLOR_RED), "mul+add", 255, 255, 255, 255)
                            end
                            task.Wait(wait)
                        end
                    end)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射器定义
    P.pointer1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.arrow_big, COLOR_RED
                local function bullet_func(x, y, v, a)
                    robject.set_color(stg.newSimpleStraight(x, y, v, a, style, color), "", 255, 255, 255, 255)
                end
                local v0 = switch1(diff, {
                    0.75, 0.75, 1.75, 1.75, no_info
                })*defaultSwitchVelocityByRank(rank)
                local way = switch1(diff, {
                    10, 12, 16, 18, no_info
                })
                local function attack(x, y, dv, a, dway)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_normal1(x, y, v0 + dv, a, way + dway, bullet_func)
                            end)
                end
                return attack
            end
    )
    --自机狙激光
    P.pointer2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = switch1(diff, {
                    2, 3, 5, 7, no_info
                })
                local function attack(x, y, sp)
                    local way = way
                    local da = sp/(way - 1)
                    way = (way - 1)/2
                    local a = Angle(x, y, player.x, player.y)
                    for i = -way, way do
                        B.laser1.create(x, y, a + da*i)
                    end
                end
                return attack
            end
    )
    --endregion
    --region Shooter 普通小怪仅作发射子弹的任务

    --endregion
    --region 自定义敌人
    --飞出去的魔法书
    E.enemy1 = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local function create(b, u, isEffect)
                    local obj = b.createBook(b.x, b.y)
                    obj.colli = false
                    obj.mst = b
                    obj.bound = false
                    obj.hscale, obj.vscale = 0, 0
                    obj._a = 0
                    --移动和攻击
                    task.New(obj, function()
                        --透明度变化
                        alphaAndSizeChangeTask(obj, 255, 0.75, 30)
                        task.MoveTo(obj, b.x, b.y - 40, 60, MOVE_ACC_DEC)
                        obj.class.changeOpenState(obj) --开启书本
                        task.Wait(16)
                        --召唤使魔
                        for i = -1, 1 do
                            E.enemy2.create(obj.x, obj.y, 90 + 60*i*u, b, 20*(i + 1), isEffect)
                        end
                        task.Wait(48)
                        alphaAndSizeChangeTask(obj, -255, -1.5, 30)
                        task.Wait(30)
                        obj.status = "del"
                    end)
                    --绑定
                    _connect(b, obj, 0.75, true)
                end
                return create
            end
    )

    E.enemy2 = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                --case:自机狙激光攻击次数
                local count = switch1(diff, {
                    3, 4, 3, 4, no_info
                })
                --case：自机狙激光的初始扩散角
                local sp0 = switch1(diff, {
                    180, 180, 180, 180, no_info
                })
                local dsp = switch1(diff, {
                    -90, -90, -90, -90, no_info
                })/(count - 1)
                local wait = switch1(diff, {
                    90, 90, 180, 180, 180
                })/count
                local wait1 = switch(rank, {
                    60, 60, 60, 60, 0
                })
                local create
                if diff < 3 then
                    function create(x, y, a, b, dt, isEffect)
                        local obj = b.createMagic(x, y,
                                9999, false, --hp, show_hp
                                system.DROP_NONE, --drop
                                no_func, --death_func
                                COLOR_YELLOW, COLOR_RED --co1, co2
                        )
                        obj.colli = false
                        obj.bound = false
                        obj.hscale, obj.vscale = 0, 0
                        obj.a, obj.b = 32, 32
                        obj._a = 0
                        --拖影
                        EGGlib.RenderEffect.newTrail(obj, --master,
                                -1, 15, 2, --dlayer, maxnum, frame,
                                obj.img, 1, "mul+add", --img, size, blend,
                                45, 0.5, false --times, _a_rate, Isdsize
                        )
                        --移动和攻击
                        task.New(obj, function()
                            --透明度变化
                            alphaAndSizeChangeTask(obj, 255, 1.5, 30)
                            task.MoveTo(obj, b.x + 120*cos(a), b.y + 90*sin(a), 60, MOVE_ACC_DEC)
                            if isEffect then
                                New(EGGlib.RenderEffect.AbsorbEffect, obj.x, obj.y, 'tree_leaf_white', 'Cherry_eff', 150, 150, 0)
                                PlaySound("ch00")
                            end
                            --发射激光预警
                            for u = -1, 1, 2 do
                                T.tasker2.main(obj, -90, u)
                            end
                            task.Wait(60)
                            --New(EGGlib.RenderEffect.BreakEffect, obj.x, obj.y, 'tree_leaf_white', 'Cherry_eff', 150, 150, 0)
                            PlaySound("enep03")
                            T.tasker1.main(obj)
                            task.Wait(90 + wait1)
                            --自机狙激光
                            for i = 0, count - 1 do
                                P.pointer2.attack(obj.x, obj.y, sp0 + dsp*i)
                                task.Wait(wait)
                            end
                            task.Wait(30)
                            alphaAndSizeChangeTask(obj, -255, -1.5, 30)
                            task.Wait(30)
                            obj.status = "del"
                        end)
                        --绑定
                        _connect(b, obj, 0.75, true)
                    end
                else
                    function create(x, y, a, b, dt, isEffect)
                        local obj = b.createMagic(x, y,
                                9999, false, --hp, show_hp
                                system.DROP_NONE, --drop
                                no_func, --death_func
                                COLOR_YELLOW, COLOR_RED --co1, co2
                        )
                        obj.colli = false
                        obj.bound = false
                        obj.hscale, obj.vscale = 0, 0
                        obj.a, obj.b = 32, 32
                        obj._a = 0
                        --拖影
                        EGGlib.RenderEffect.newTrail(obj, --master,
                                -1, 15, 2, --dlayer, maxnum, frame,
                                obj.img, 1, "mul+add", --img, size, blend,
                                45, 0.5, false --times, _a_rate, Isdsize
                        )
                        --移动和攻击
                        task.New(obj, function()
                            --透明度变化
                            alphaAndSizeChangeTask(obj, 255, 1.5, 30)
                            task.MoveTo(obj, b.x + 120*cos(a), b.y + 90*sin(a), 60, MOVE_ACC_DEC)
                            --发射激光预警
                            if isEffect then
                                New(EGGlib.RenderEffect.AbsorbEffect, obj.x, obj.y, 'tree_leaf_white', 'Cherry_eff', 150, 150, 0)
                                PlaySound("ch00")
                            end
                            task.Wait(30 + dt)
                            T.tasker3.main(obj, -90)
                            task.Wait(120 - dt + wait1)
                            --自机狙激光
                            for i = 0, count - 1 do
                                T.tasker1.main(obj)
                                P.pointer2.attack(obj.x, obj.y, sp0 + dsp*i)
                                task.Wait(wait)
                            end
                            task.Wait(30)
                            alphaAndSizeChangeTask(obj, -255, -1.5, 30)
                            task.Wait(30)
                            obj.status = "del"
                        end)
                        --绑定
                        _connect(b, obj, 0.75, true)
                    end
                end
                return create
            end
    )
    --endregion
    --region Tasker 任务执行器
    --休止符发射器
    T.tasker1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    4, 6, 2, 3, no_info
                })
                if diff < 3 and rank == 4 then --hyper下再加一层休止符
                    count = count + 1
                end
                local dv = switch1(diff, {
                    0.3, 0.3, 0.8, 0.5, no_info
                })
                local dway = switch1(diff, {
                    2, 4, 12, 6, no_info
                }) + switch(rank, {
                    0, 0, 0, 0, 2
                })
                local wait = 30/count
                local da = switch1(diff, {
                    30, 30, 30, 30, no_info
                })/(count - 1)
                local function main(e)
                    boss.createTasker(_boss, e.x, e.y,
                            function(obj)
                                local a = ran:Float(0, 360)
                                task.New(obj, function()
                                    for i = 0, count - 1 do
                                        P.pointer1.attack(e.x, e.y, dv*i, a + da*i*0, (count - 1 - i)*dway)
                                        task.Wait(wait)
                                    end
                                    Del(obj)
                                end)
                            end, false) --不拖延
                end
                return main
            end)

    --激光发射器
    T.tasker2 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    9, 12, 12, 15, no_info
                })
                local wait = 1
                local da = 120/(count - 1)
                local function main(e, a, u)
                    boss.createTasker(_boss, e.x, e.y,
                            function(obj)
                                task.New(obj, function()
                                    for i = 0, count - 1 do
                                        B.laser1.create(e.x, e.y, a + da*u*i)
                                        task.Wait(wait)
                                    end
                                    Del(obj)
                                end)
                            end, false) --不拖延
                end
                return main
            end)

    --抓痕发射器
    T.tasker3 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local dr = switch1(diff, {
                    no_info, no_info, 100, 50, no_info
                })
                local count = switch1(diff, {
                    no_info, no_info, 2, 3, no_info
                })
                local function main(e, a)
                    boss.createTasker(_boss, e.x, e.y,
                            function(obj)
                                local x, y = e.x - 100*cos(a), e.y - 100*sin(a)
                                local dx, dy = -sin(a), cos(a)
                                task.New(obj, function()
                                    for i = 0, count - 1 do
                                        for u = -1, 1, 2 do
                                            B.laser2.create(x + u*i*dr*dx, y + u*i*dr*dy, a, 600 - 100*i, u)
                                        end
                                        task.Wait(2)
                                    end
                                    Del(obj)
                                end)
                            end, false) --不拖延
                end
                return main
            end)


    --endregion
    --region 组合攻击
    local move = EGGlib.ObjectEvent.moveToPlayerDefault
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local wait = switch1(diff, {
                    300, 300, 330, 330, 600
                }) + switch(rank, {
                    120, 120, 120, 120, 60
                })
                local function main(b, u, isEffect)
                    E.enemy1.create(b, u, isEffect)
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
            for _, v in pairs(B) do
                v.update(difficulty, new_rank)
            end
            rank = new_rank
        end
    end
    
    local names = {
        "name-boss4-card1-E",
        "name-boss4-card1-N",
        "name-boss4-card1-H",
        "name-boss4-card1-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "spellcard", --类型
            {3, 3, 60}, --时间
            2000, --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                task.Wait(60)
                task.MoveTo(b, 0, 100, 60, MOVE_ACC_DEC)
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 100
                boss.show_aura(b, true)
            end,
            function(b) --main
                reFresh()
                C.FIRST.main(b, -1, true)
                while true do
                    reFresh()
                    for u = 1, -1, -2 do
                        C.FIRST.main(b, u, false)
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