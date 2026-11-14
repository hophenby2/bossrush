-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage3/spellcard/spell_2.lua" --当前存放目录
local no_func = function() end
local no_info = 0
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local velch = EGGlib.ObjectEvent.velocityChange
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local boundWait = EGGlib.ObjectEvent.boundWait
local polygon2 = EGGlib.BulletGroup.polygon2
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local alphaAndSizeChangeTask = EGGlib.ObjectEvent.alphaAndSizeChangeTask
local sty = EISlib.Enemy.Style
local setSize = EGGlib.ObjectEvent.setSize
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local tranRot = EGGlib.Math.TranRot
local aimToTargetTask = EGGlib.ObjectEvent.aimToTargetTask
local ScBreakCircle = EGGlib.RenderEffect.ScBreakCircle


local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    local book_inst
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
            for _, v in pairs(D) do
                v.update(difficulty, new_rank)
            end
            rank = new_rank
        end
    end
    --region Bullet 自定义子弹
    --装饰用光玉粒子
    B.perform_ball_light = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local color = switch1(diff, {
                    COLOR_CYAN, COLOR_CYAN, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE
                })
                local function create(x, y)
                    local obj = stg.newSimpleBullet(x, y, stg.ball_light, color)
                    obj.group = GROUP_GHOST
                    setSize(obj, 0.25, 0.25)
                    robject.set_color(obj, "mul+add", 0, 255, 255, 255)
                    task.New(obj, function()
                        alphaAndSizeChange(obj, 255, 0, 5)
                        alphaAndSizeChange(obj, 0, -0.25, 20)
                        _del(obj, false)
                    end)
                end
                return create
            end
    )


    B.light = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local color = switch1(diff, {
                    {0, 0, 255}, {0, 0, 255}, {255, 0, 255}, {255, 0, 255}, {255, 0, 255}
                })
                local function create(mst, a)
                    local obj = New(bent_laser_effection, "laser_bent_2", mst.x, mst.y, a,
                            30, 12 --len, wide
                    )
                    robject.set_color(obj, "mul+add", 255, color[1], color[2], color[3])
                    task.New(obj, function()
                        while IsValid(mst) do
                            obj.x, obj.y = mst.x, mst.y
                            task.Wait(1)
                        end
                        bent_laser_effection.disappear(obj, 30)
                    end)
                end
                return create
            end
    )


    --鬼火生成时发出的弹幕
    B.bullet1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local create
                local style = stg.arrow_big
                if diff < 3 then
                    function create(x, y, v, a, co)
                        local obj = stg.newSimpleBullet(x, y, style, co)
                        boundWait(obj, 240)
                        --obj.omiga = 3
                        obj.rot = a + 180
                        velchTask(obj, -1, v, a, 60, 60)
                        task.New(obj, function()
                            task.Wait(60)
                            local dv = (v + 1)/60
                            local t = 1/dv
                            task.Wait(t)
                            obj.rot = a
                            PlaySound("kira00")
                            stg.newFadeEffect(obj.x, obj.y, style, co, false, function() end)
                        end)
                    end
                else
                    function create(x, y, v, a, dv, co)
                        local obj = stg.newSimpleBullet(x, y, style, co)
                        boundWait(obj, 240)
                        --obj.omiga = 3
                        obj.rot = a + 180
                        local t = 60 + (v + 0.6)/60*dv
                        velchTask(obj, -0.6, v + dv, a, t, 60)
                        task.New(obj, function()
                            task.Wait(60)
                            local dv0 = (v + dv + 0.6)/t
                            local t1 = 0.6/dv0
                            task.Wait(t1)
                            obj.rot = a
                            PlaySound("kira00")
                            stg.newFadeEffect(obj.x, obj.y, style, co, false, function() end)
                        end)
                    end
                end
                return create
            end
    )

    --HL难度的核弹
    B.bullet2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v0 = switch1(diff, {
                    no_info, no_info, 2.75, 3.5, 2
                })*defaultSwitchVelocityByRank(rank)
                local wait = switch1(diff, {
                    no_info, no_info, 15, 10, 10
                })
                local v1 = switch1(diff, {
                    no_info, no_info, 1.75, 2, 1.75
                })
                local da = 1*wait
                local function create(x, y, a)
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                obj.rot = a
                                obj.bound = false
                                --产生子鬼火
                                for i = 1, 3 do
                                    E.ghost.create(obj, 120*i)
                                end
                                --自己的运动逻辑
                                task.New(obj, function()
                                    task.New(obj, function()
                                        task.Wait(30)
                                        local i = 1
                                        while true do
                                            for u = -1, 1, 2 do
                                                stg.newStrChV(obj.x, obj.y, 0, v1, a + (-90 + da*i)*u, 30, 0, stg.star_big, COLOR_DEEP_PURPLE).omiga = -3
                                            end
                                            task.Wait(wait)
                                            i = i + 1
                                        end
                                    end)
                                    velch(obj, 0, v0, a, 60)
                                    obj.bound = true
                                end)
                            end, false) --不拖延
                end
                return create
            end
    )

    --endregion
    --region 子弹发射器定义
    P.pointer1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.arrow_big, COLOR_BLUE
                local v = switch1(diff, {
                    1.25, 1.5, 1.25, 1.5, no_info
                })*defaultSwitchVelocityByRank(rank)
                local attack
                if diff < 3 then --EN
                    function attack(x, y, a, sp, co)
                        local function bullet_func(x, y, v, a)
                            B.bullet1.create(x, y, v, a, co)
                        end
                        sp = 0.5*sp
                        PlaySound("tan00")
                        stg.newFadeEffect(x, y, style, co, false,
                                function()
                                    for u = -1, 1, 2 do
                                        bullet_func(x, y, v, a + u*sp)
                                    end
                                end, true)
                    end
                else --HL
                    function attack(x, y, dv, a, sp, co)
                        local function bullet_func(x, y, v, a)
                            B.bullet1.create(x, y, v, a, dv, co)
                        end
                        sp = 0.5*sp
                        PlaySound("tan00")
                        stg.newFadeEffect(x, y, style, co, false,
                                function()
                                    for u = -1, 1, 2 do
                                        bullet_func(x, y, v, a + u*sp)
                                    end
                                end, true)
                    end
                end
                return attack
            end
    )
    --五角星/核弹 攻击
    P.pointer2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.star_big, COLOR_DEEP_PURPLE
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStraight(x, y, v, a, style, color).omiga = 6
                end
                local v = switch1(diff, {
                    2.25, 2.6, 2.25, 2.6, no_info
                })*defaultSwitchVelocityByRank(rank)
                --case：一条线上有多少个子弹
                local l = switch1(diff, {
                    7, 11, 12, 15, no_info
                })
                --hyper模式为两层
                local layer = switch(rank, {
                    1, 1, 1, 1, 1
                })
                local attack
                if diff < 3 then --en
                    function attack(x, y, a)
                        PlaySound("tan00")
                        stg.newFadeEffect(x, y, style, color, false,
                                function()
                                    for i = 0, layer - 1 do
                                        color = COLOR_DEEP_PURPLE - 2*i
                                        polygon2(x, y, v + 1*i, a + 36*i, 5, l, bullet_func)
                                    end
                                end)
                    end
                else --hl
                    function attack(x, y, a)
                        local a = Angle(x, y, player.x, player.y)
                        for u = -1, 1, 2 do
                            B.bullet2.create(x, y, a + 30*u)
                        end
                    end
                end
                return attack
            end
    )
    P.pointer3 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.arrow_big, COLOR_BLUE
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 0.5, v, a, 30, 30, style, color)
                end
                local v0 = switch1(diff, {
                    no_info, no_info, 1.75, 1, no_info
                })*defaultSwitchVelocityByRank(rank)
                local dv = switch1(diff, {
                    no_info, no_info, no_info, 2, no_info
                })
                local layer = switch1(diff, {
                    no_info, no_info, 1, 2, no_info
                })
                local way = switch1(diff, {
                    5, 5, 6, 6, no_info
                })
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v0, a, way,
                                        layer, dv, 0, 0,
                                        bullet_func)
                            end)
                end
                return attack
            end
    )
    --endregion
    --region Shooter 普通小怪仅作发射子弹的任务
    --排弹发射器
    S.shooter1 = EISlib.Bullet.Shooter.createShooter(
            function (diff, rank)
                local start_time = 0
                local total_time = 360
                local count = switch1(diff, {
                    3, 4, 4, 4, no_info
                })
                local wait = switch1(diff, {
                    2, 2, 2, 2, 2
                })
                local num = switch1(diff, {
                    3, 4, 3, 4, no_info
                }) + switch(rank, {
                    0,
                    0,
                    0,
                    0,
                    switch1(diff, {
                        1, 1, 0, 0, 0
                    })
                })
                local sp0 = 0
                local dsp_c = switch1(diff, {
                    -240, -240, -300, -300, 30
                })/(count - 1)
                local dsp_n = 1*dsp_c/num
                local color = {COLOR_BLUE, COLOR_RED}
                local main
                if diff < 3 then
                    function main(e, a, co)
                        enemy.createShooter(e,
                                start_time, total_time, --start_time_left total_time
                                function(obj)
                                    for i = 0, count - 1 do
                                        for j = 0, num - 1 do
                                            P.pointer1.attack(e.x, e.y, a, sp0 + dsp_c*i + dsp_n*j, co or color[i%2 + 1])
                                            task.Wait(wait)
                                        end
                                    end
                                    Del(obj)
                                end
                        )
                    end
                else
                    local dv = switch1(diff, {
                        no_info, no_info, 0.03, 0.04, 0.04
                    })/1.15*defaultSwitchVelocityByRank(rank)
                    function main(e, a, co)
                        enemy.createShooter(e,
                                start_time, total_time, --start_time_left total_time
                                function(obj)
                                    for i = 0, count - 1 do
                                        for j = 0, num - 1 do
                                            P.pointer1.attack(e.x, e.y, dv*(count*num - (i*num + j)), a, sp0 + dsp_c*i + dsp_n*j, co or color[i%2 + 1])
                                            task.Wait(wait)
                                        end
                                    end
                                    Del(obj)
                                end
                        )
                    end
                end
                return main
            end
    )

    --endregion
    --region 死尸弹
    --鬼火死尸弹
    D.death1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    no_info, no_info, 4, 6, no_info
                })
                local wait = 26/count
                local da = switch1(diff, {
                    no_info, no_info, 30, 45, no_info
                })/(count - 1)
                local function main(e)
                    local x, y, a, u = e.x, e.y, Angle(e, player), e.u
                    enemy.createDeath(
                            20, --total_time,
                            function()
                                for i = 0, count - 1 do
                                    P.pointer3.attack(x, y, a + da*i*u)
                                    task.Wait(wait)
                                end
                            end)
                end
                return main
            end)
    --endregion
    --region 自定义敌人
    --飞出去的魔法书
    E.book = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local create
                if diff < 3 then --EN
                    function create(b)
                        local obj = b.createBook(b.x, b.y,
                                9999, false, --hp, show_hp
                                system.DROP_NONE, --drop
                                no_func --death_func
                        )
                        --绑定
                        _connect(b, obj, 0.75, true)
                        obj.mst = b
                        obj.bound = false
                        obj.hscale, obj.vscale = 0, 0
                        obj._a = 0
                        obj.isAttack = false --用于判断汇聚攻击
                        --移动和攻击
                        task.New(obj, function()
                            --透明度变化
                            alphaAndSizeChangeTask(obj, 255, 0.75, 30)
                            task.MoveTo(obj, b.x, b.y - 60, 60, MOVE_ACC_DEC)
                            obj.class.changeOpenState(obj) --开启书本
                            task.Wait(16)
                        end)
                        --汇聚攻击更新
                        task.New(obj, function()
                            while true do
                                if obj.isAttack then
                                    task.Wait(1)
                                    obj.isAttack = false
                                else
                                    task.Wait(1)
                                end
                            end
                        end)
                        return obj
                    end
                else --HL
                    function create(b)
                        local obj = b.createBook(b.x, b.y,
                                9999, false, --hp, show_hp
                                system.DROP_NONE, --drop
                                no_func --death_func
                        )
                        --绑定
                        _connect(b, obj, 0.75, true)
                        obj.mst = b
                        obj.bound = false
                        obj.hscale, obj.vscale = 0, 0
                        obj._a = 0
                        obj.isAttack = false --用于判断汇聚攻击
                        --移动和攻击
                        task.New(obj, function()
                            --透明度变化
                            alphaAndSizeChangeTask(obj, 255, 0.75, 30)
                            task.MoveTo(obj, b.x, b.y - 60, 60, MOVE_ACC_DEC)
                            obj.class.changeOpenState(obj)
                            task.Wait(16)
                        end)
                        --汇聚攻击更新
                        task.New(obj, function()
                            while true do
                                if obj.isAttack then
                                    task.Wait(1)
                                    obj.isAttack = false
                                else
                                    task.Wait(1)
                                end
                            end
                        end)
                        return obj
                    end
                end
                return create
            end
    )

    E.enemy2 = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local da = 36
                local color_list = {}
                color_list[COLOR_RED] = sty.FIRE_RED
                color_list[COLOR_BLUE] = sty.FIRE_BLUE
                local function create(x, y, r, a, b, mst, target_x, target_y, co)
                    local obj = New(enemy, mst.x, mst.y, color_list[co], --style
                            120, --hp
                            false,  --show_hpbar
                            system.DROP_NONE, --drop
                            true, --no_count
                            no_func --D.death1.main   --death_func
                    )
                    obj.show_aura = true
                    obj.bound = false
                    obj.hscale, obj.vscale = 0, 0
                    obj.a, obj.b = 27, 27
                    obj._a = 0
                    obj.colli = false --现在它甚至没判定
                    --移动和攻击
                    task.New(obj, function()
                        --透明度变化
                        alphaAndSizeChangeTask(obj, 255, 1, 30)
                        task.MoveTo(obj, x + r*cos(a), y + r*sin(a), 60, MOVE_ACC_DEC)
                        local enemy = E.enemy3.create(obj.x, obj.y, a, obj, co)
                        task.Wait(120)
                        local x, y = target_x or player.x, target_y or max(player.y, -50)
                        task.New(enemy, function()
                            enemy.vx, enemy.vy = 0, 0
                            task.MoveTo(enemy, x, y, 120, MOVE_ACC_DEC)
                            if IsValid(mst) and not mst.isAttack then
                                New(ScBreakCircle, x, y, 1, 255, 0, 255)
                                P.pointer2.attack(x, y, Angle(x, y, player.x, player.y) + da, u)
                                mst.isAttack = true  --只允许一次
                            end
                            enemy.status = "del"
                        end)
                        alphaAndSizeChangeTask(obj, -255, -0.5, 120)
                        task.MoveTo(obj, x, y, 60, MOVE_ACC_DEC)
                        task.Wait(60)
                        obj.status = "del"
                    end)
                    --绑定
                    _connect(b, obj, 0.5, true)
                    return obj
                end
                return create
            end
    )

    E.enemy3 = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local color_list = {}
                color_list[COLOR_RED] = sty.FIRE_RED
                color_list[COLOR_BLUE] = sty.FIRE_BLUE
                local function create(x, y, a, mst, co)
                    local obj = New(enemy, x, y, color_list[co], --style
                            100, --hp
                            false,  --show_hpbar
                            system.DROP_NONE, --drop
                            true, --no_count
                            no_func --D.death1.main   --death_func
                    )
                    obj.show_aura = true
                    obj.colli = false
                    obj.hscale, obj.vscale = 1, 1
                    obj.a, obj.b = obj.hscale*obj.a, obj.vscale*obj.b
                    obj.bound = false
                    robject.set_color(obj, "", 255, 255, 255, 255)
                    --移动与攻击
                    task.New(obj, function()
                        S.shooter1.main(obj, a, co)
                        velch(obj, 3, 0.5, a, 60, 60)
                        --返回原点由enemy2控制
                    end)
                    _connect(mst, obj, 0, true)
                    return obj
                end
                return create
            end
    )

    --三子鬼火
    E.ghost = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local a, b = 10, 15
                local dp = 6
                local style = switch1(diff, {
                    sty.FIRE_CYAN, sty.FIRE_CYAN, sty.FIRE_PURPLE, sty.FIRE_PURPLE, sty.FIRE_PURPLE
                })
                local function create(mst, phase)
                    local obj = New(enemy, mst.x, mst.y, style, --style
                            120, --hp
                            false,  --show_hpbar
                            system.DROP_NONE, --drop
                            true, --no_count
                            nil, --death_func
                            false --type
                    )
                    obj.bound = false
                    obj.show_aura = true
                    obj.group = GROUP_INDES
                    obj.a, obj.b = obj.a/2, obj.b/2
                    setSize(obj, 0, 0)
                    robject.set_color(obj, "", 0, 255, 255, 255)
                    alphaAndSizeChangeTask(obj, 255, 1, 30)
                    B.light.create(obj, 90)
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET - 1
                        local i, dx, dy = 0
                        while IsValid(mst) do
                            phase = phase + dp
                            dx, dy = tranRot(a*cos(phase), b*sin(phase), mst.rot)
                            obj.rot = mst.rot + 90
                            obj.x, obj.y = mst.x + dx, mst.y + dy
                            if i%2 == 0 then
                                B.perform_ball_light.create(obj.x, obj.y)
                            end
                            task.Wait(1)
                            i = i + 1
                        end
                        Del(obj)
                    end)
                end
                return create
            end
    )
    --endregion
    --region Tasker 任务执行器
    T.ghost_controller = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local wait = switch1(diff, {
                    20, 15, 12, 10, 10
                })
                local main
                if diff < 3 then --EN
                    function main(x, y, a, u)
                        boss.createTasker(_boss, x, y,
                                function(obj)
                                    obj.rot = a
                                    obj.bound = false
                                    --产生子鬼火
                                    for i = 1, 3 do
                                        E.ghost.create(obj, 120*i)
                                    end
                                    --自己的运动逻辑
                                    task.New(obj, function()
                                        velch(obj, 0, 4, a, 30)
                                        task.Wait(90)
                                        SetV(obj, 5, -90 + 30*u, true)
                                        obj.x, obj.y = ran:Float(30, 90)*u, 245
                                        P.arrow_big.attack(obj.x, obj.y, ran:Float(0, 360))
                                        task.Wait(30)
                                        obj.navi = true
                                        --追得更猛
                                        aimToTargetTask(obj, player, 2, 45, 0.1)
                                        local i = 0
                                        while obj.y > -224 do
                                            if i % wait == 0 then
                                                P.ball_mid.attack(obj.x, obj.y, obj.rot + 90)
                                            end
                                            task.Wait(1)
                                            i = i + 1
                                        end
                                        obj.bound = true
                                    end)
                                end, false) --不拖延
                    end
                else-- HL
                    function main(x, y, a, u)
                        boss.createTasker(_boss, x, y,
                                function(obj)
                                    obj.rot = a
                                    obj.bound = false
                                    --产生子鬼火
                                    for i = 1, 3 do
                                        E.ghost.create(obj, 120*i)
                                    end
                                    --自己的运动逻辑
                                    task.New(obj, function()
                                        velch(obj, 0, 4, a, 30)
                                        task.Wait(60)
                                        obj.vx, obj.vy = 0, -3
                                        obj.x, obj.y = ran:Float(90, 180)*u, 245
                                        obj.rot = -90
                                        task.Wait(30)
                                        --会追踪的
                                        aimToTargetTask(obj, player, 0, 60, 0.01)
                                        local i = 0
                                        while obj.y > -224 do
                                            task.Wait(1)
                                            i = i + 1
                                        end
                                        P.arrow_big.attack(obj.x, obj.y, 90)
                                        obj.bound = true
                                    end)
                                end, false) --不拖延
                    end
                end
                return main
            end)
    --endregion
    --region 组合攻击
    local move = EGGlib.ObjectEvent.moveToPlayerDefault
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local way = switch1(diff, {
                    6, 6, 3, 3, no_info
                })
                local da = 360/way

                local main
                if diff < 3 then --EN
                    function main(b)
                        book_inst = E.book.create(b)
                        task.Wait(76)
                        local a0, a
                        while IsValid(book_inst) do
                            reFresh()
                            for u = -1, 1, 2 do
                                a0 = ran:Float(0, 360)
                                for i = 0, way - 1 do
                                    a = a0 + da*i
                                    E.enemy2.create(book_inst.x - 150*u, book_inst.y + 50, 50, a, b, book_inst, book_inst.x + 100*u, book_inst.y, COLOR_BLUE)
                                end
                                task.Wait(60)
                            end
                            task.Wait(120)
                            --这一波是在自机中间汇聚的
                            b.absorbEffect(b, 60, b.x, b.y)
                            a0 = ran:Float(0, 360)
                            for i = 0, way - 1 do
                                a = a0 + da*i
                                E.enemy2.create(book_inst.x, 144, 50, a, b, book_inst, nil, nil, COLOR_BLUE)
                            end
                            task.Wait(180)
                        end
                    end
                else --HL
                    local n = switch1(diff, {
                        no_info, no_info, 3, 3, 3
                    }) + switch(rank, {
                        0, 0, 0, 0, 1
                    })
                    local da0 = 180/(n - 1)
                    local color = {COLOR_BLUE, COLOR_RED, COLOR_BLUE, COLOR_RED}
                    function main(b)
                        book_inst = E.book.create(b)
                        task.Wait(76)
                        local a0, a
                        while IsValid(book_inst) do
                            for u = -1, 1, 2 do
                                reFresh()
                                for j = 0, n - 1 do
                                    a0 = ran:Float(0, 360)
                                    for i = 0, way - 1 do
                                        a = a0 + da*i
                                        E.enemy2.create(book_inst.x - 150*cos(-180 + da0*j)*u, book_inst.y + 50*sin(-180 + da0*j), -70, a, b, book_inst, b.x + 100*cos(180 - da0*j)*u, b.y + 100*sin(180 - da0*j), color[j+1])
                                    end
                                    task.Wait(20)
                                end
                                task.Wait(120)
                            end
                        end
                    end
                end
                return main
            end)
    --endregion
    
    local names = {
        "name-boss4-card2-E",
        "name-boss4-card2-N",
        "name-boss4-card2-H",
        "name-boss4-card2-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "spellcard", --类型
            {3, 3, 50}, --时间
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
                reFresh()
                C.FIRST.main(b)
            end,
            function(b) --finish
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
