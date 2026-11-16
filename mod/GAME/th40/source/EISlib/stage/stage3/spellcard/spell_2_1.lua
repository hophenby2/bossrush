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
local sizeAndColliChange = EGGlib.ObjectEvent.sizeAndColliChange
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local alphaAndSizeChangeTask = EGGlib.ObjectEvent.alphaAndSizeChangeTask
local sty = EISlib.Enemy.Style
local setSize = EGGlib.ObjectEvent.setSize
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local tranRot = EGGlib.Math.TranRot
local sect_normal1 = EGGlib.BulletGroup.Sector.normal1
local aimToTargetTask = EGGlib.ObjectEvent.aimToTargetTask

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
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
    B.bullet_demo = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y)
                    local obj = stg.newBullet(x, y, stg.arrow_big, COLOR_RED)
                end
                return create
            end
    )

    --装饰用光玉粒子
    B.perform_ball_light = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local color = switch1(diff, {
                    COLOR_CYAN, COLOR_CYAN, COLOR_ORANGE, COLOR_ORANGE, COLOR_ORANGE
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
                    {0, 0, 255}, {0, 0, 255}, {255, 255, 0}, {255, 255, 0}, {255, 255, 0}
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

    --爆炸小玉(HL)
    B.boom_ball_mid = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, v, a)
                    local obj = stg.newBullet(x, y, stg.ball_mid, COLOR_RED)
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    setSizeAndColli(obj, 3, 3)
                    SetV(obj, v, a)
                    task.New(obj, function()
                        sizeAndColliChange(obj, -2, 90)
                        obj._blend = ""
                    end)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射器定义
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

    P.arrow_big = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = switch1(diff, {
                    1, 1.2, 1.35, 1, 1.5
                })*defaultSwitchVelocityByRank(rank)
                local way = switch1(diff, {
                    8, 12, 24, 24, 24
                })
                local layer = switch1(diff, {
                    1, 1, 1, 2, 1
                })
                local dv = 0.25
                local da = 0
                local style, color = stg.ball_mid, COLOR_BLUE
                local bullet_func
                if diff < 3 then --EN
                    function bullet_func(x, y, v, a)
                        stg.newSimpleStraight(x, y, v, a, style, color)
                    end
                else --HL
                    function bullet_func(x, y, v, a)
                        B.boom_ball_mid.create(x, y, v, a)
                    end
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

    P.ball_mid = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = switch1(diff, {
                    1.5, 2, 0, 0, 0
                })*defaultSwitchVelocityByRank(rank)
                local way = switch1(diff, {
                    1, 2, 0, 0, 0
                })
                local da = 180
                local style, color = stg.ball_mid, COLOR_CYAN
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_normal1(x, y, v, a, way, da, --base
                                        bullet_func
                                )
                            end)
                end
                return attack
            end
    )
    --endregion
    --region 自定义敌人
    --魔法书
    E.book = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local function create(b)
                    local obj = b.createBook(b.x, b.y)
                    b.book = obj
                    obj.colli = false
                    obj.mst = b
                    obj.bound = false
                    obj.hscale, obj.vscale = 0, 0
                    obj._a = 0
                    --移动和攻击
                    task.New(obj, function()
                        --透明度变化
                        alphaAndSizeChangeTask(obj, 255, 0.75, 30)
                        task.MoveTo(obj, 0, 0, 60, MOVE_ACC_DEC)
                        obj.class.changeOpenState(obj) --开启书本
                    end)
                    --绑定
                    _connect(b, obj, 0, true)
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
                    sty.FIRE_CYAN, sty.FIRE_CYAN, sty.FIRE_ORANGE, sty.FIRE_ORANGE, sty.FIRE_ORANGE
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
                                            --[[if i % wait == 0 then
                                                P.ball_mid.attack(obj.x, obj.y, -90 + ran:Float(-5, 5))
                                            end]]
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
                local main
                if diff < 3 then --EN
                    function main(b)
                        local book = E.book.create(b)
                        task.New(b, function()
                            task.Wait(60)
                            for i = 1, _infinite do
                                for _ = 1, 2 do
                                    for u = -1, 1, 2 do
                                        T.ghost_controller.main(book.x, book.y, ran:Float(45, 135), u)
                                        task.Wait(5)
                                    end
                                end
                                T.ghost_controller.main(book.x, book.y, ran:Float(45, 135), 0)
                                task.Wait(180)
                            end
                        end)
                    end
                else --HL
                    function main(b)
                        local book = E.book.create(b)
                        task.New(b, function()
                            task.Wait(60)
                            for i = 1, _infinite do
                                for _ = 1, 2 do
                                    for u = -1, 1, 2 do
                                        T.ghost_controller.main(book.x, book.y, ran:Float(45, 135), u)
                                        task.Wait(30)
                                    end
                                end
                                T.ghost_controller.main(book.x, book.y, ran:Float(45, 135), 0)
                                task.Wait(30)
                            end
                        end)
                    end
                end
                return main
            end)

    --endregion
    
    local hp_list = {1800, 1800, 2500, 2500}
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
            hp_list[difficulty], --耐久
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
                task.Wait(180)
            end,
            function(b) --finish
                --task.MoveTo(b, 0, 144, 60, MOVE_ACC_DEC)
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
