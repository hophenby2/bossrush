-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage7/spellcard/mid_spell_2.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local alpAndSizeCh = EGGlib.ObjectEvent.alphaAndSizeChange
local disapear = EGGlib.ObjectEvent.disappear
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local alphaAndSizeChangeTask = EGGlib.ObjectEvent.alphaAndSizeChangeTask
local move = EGGlib.ObjectEvent.moveToPlayerDefault
local accDecMoveToPoint = EGGlib.ObjectEvent.accDecMoveToPoint
local sty = EISlib.Enemy.Style
local warning_laser = EISlib.Bullet.Laser.warning_laser
local lead_laser = EISlib.Bullet.Laser.lead_laser
local boss_name = "Artemina"  --以boss名来作为其相关素材的前缀
local light_red_tex = boss_name.."_light_red"
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local move = function(obj)
    EGGlib.ObjectEvent.bossMoveTask(obj,
            -40, 40, 15, 20, --x_min, x_max, dx_min, dx_max
            100, 5, 10, 30 --y0, dy_min, dy_max, t
    )
end
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local Bclass = EISlib.BossDefinition.Artemina
local boom_effect = Bclass.boom_effect


local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --敌人变身
    local function changeStyle(obj)
        New(boom_effect, obj.x, obj.y)
        enemy.change_style(obj, sty.FAIRY_MARISA)
        task.New(obj, function()
            obj.layer = LAYER_ENEMY_BULLET + 2
            local a = obj.angle
            B.laser.create(obj.x, obj.y, a)
            --T.star_small.main(obj, a)
            S.star_small.main(obj, a)
            velchTask(obj, 0, 6, a, 180)
            task.Wait(60)
            obj.colli = true
            obj.bound = true
        end)
    end
    --region Bullet 自定义子弹
    --射出去的转向自机相关弹幕
    B.bullet_demo = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y)
                    local obj = stg.newBullet(x, y, stg.arrow_big, COLOR_RED)
                end
                return create
            end
    )

    --用来攻击动物灵的箭
    B.perform_arrow = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                --case：初速度
                local function create(x, y, x1, y1, target)
                    local a = Angle(x, y, x1, y1)
                    local ls =  New(warning_laser, x, y,
                            600, 10, --len, l_t
                            3, 20, --wide, w_t
                            a, "mul+add", Color(255, 255, 0, 0), 60)
                    --PlaySound("lazer00")
                    task.New(ls, function()
                        task.Wait(40)
                        --以下是产生新的弹幕
                        local obj = stg.newBullet(x, y, stg.arrow_mid, COLOR_DEEP_RED, true)
                        robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                        obj.rot = a
                        obj.navi = true
                        B.light.create(obj, x, y, a)
                        task.New(obj, function()
                            task.MoveTo(obj, x1, y1, 30, MOVE_NORMAL)
                            --命中后目标变身
                            changeStyle(target)
                            --销毁自己
                            _del(obj, false)
                        end)
                    end)
                end
                return create
            end
    )

    B.laser = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a)
                    local obj =  New(warning_laser, x, y,
                            600, 10, --len, l_t
                            3, 20, --wide, w_t
                            a, "mul+add", Color(255, 0, 0, 255), 60)
                    PlaySound("lazer00")
                    _connect(_boss, obj, 0, true)
                    task.New(obj, function()
                        task.Wait(60)
                        PlaySound("lazer01")
                        _connect(_boss, New(lead_laser,
                                1, COLOR_BLUE, --type, co
                                x, y, 20, a, --x, y, v, a
                                600, 10, 12, 1, --len, w0, w1, t
                                true, false, 120 --islock, isshoot, last_time
                        ), 0, true)
                    end)
                end
                return create
            end
    )

    --箭拖尾
    B.light = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(mst, x, y, a)
                    local obj = New(bent_laser_effection, light_red_tex, x, y, a,
                            60, 12 --len, wide
                    )
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    task.New(obj, function()
                        while IsValid(mst) do
                            obj.x, obj.y = mst.x + 5*cos(mst.rot), mst.y + 5*sin(mst.rot)
                            task.Wait(1)
                        end
                        bent_laser_effection.disappear(obj, 30)
                    end)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义
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

    --一圈星星
    P.star_big = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = switch(rank, {
                    23, 23, 23, 23, 27
                })
                local layer = 1
                local v = 2*defaultSwitchVelocityByRank(rank)
                local style, color = stg.star_big, COLOR_DEEP_PURPLE
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color).omiga = -3
                end
                local function attack(x, y, a)
                    PlaySound("kira00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v, a, way, layer, 0, 0, 0, bullet_func)
                            end)
                end
                return attack
            end
    )
    --endregion

    --region 自定义敌人
    E.rabbit = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local function create(x, y, x1, y1, a)
                    local obj = New(enemy, x, y, sty.RABBIT_YELLOW, --style
                            1, --hp
                            false,  --show_hpbar
                            system.DROP_NONE, --drop
                            true, --no_count
                            nil, --death_func
                            false --type
                    )
                    obj.angle = a
                    _connect(_boss, obj, 0, true)
                    obj.colli = false
                    task.New(obj, function()
                        --小兔子一蹦一跳
                        local c = 6 --跳的次数
                        local dx, dy = (x1 - x)/c, (y1 - y)/c
                        for _ = 0, c - 1 do
                            accDecMoveToPoint(obj, obj.x + dx, obj.y + dy, 10, 0, 10) --x, y, t0, t1, t2
                           -- task.Wait(10)
                        end
                    end)
                    return obj
                end
                return create
            end
    )
    --endregion
    --region shooter 敌机发弹逻辑
    S.star_small = EISlib.Bullet.Shooter.createShooter(
            function (diff, rank)
                --case：初始攻击等待
                local start_time_left = 0
                --case：持续攻击时间
                local total_time = _infinite
                local v0 = 6*defaultSwitchVelocityByRank(rank)
                local count = switch(rank, {
                    8, 8, 8, 8, 10
                })
                local dv = (2*defaultSwitchVelocityByRank(rank) - v0)/(count - 1)
                local function shooter(e, a)
                    enemy.createShooter(e,
                            start_time_left, total_time, --start_time_left total_time
                            function()
                                for i = 0, count - 1 do
                                    stg.newStraight(e.x, e.y, v0 + dv*i, a, stg.star_small, COLOR_YELLOW - 1).omiga = 3
                                    PlaySound("kira00")
                                    task.Wait(6)
                                end
                            end
                    )
                end
                return shooter
            end
    )
    --endregion
    --region Tasker 任务执行器
    --往一个方向不断发射速度逐渐减小的星星弹
    T.star_small = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local v0 = 6*defaultSwitchVelocityByRank(rank)
                local count = switch(rank, {
                    10, 10, 10, 10, 10
                })
                local dv = (2*defaultSwitchVelocityByRank(rank) - v0)/(count - 1)
                local function main(x, y, a)
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                task.New(obj, function()
                                    for i = 0, count - 1 do
                                        stg.newStraight(x, y, v0 + dv*i, a, stg.star_small, COLOR_YELLOW - 1).omiga = 3
                                        PlaySound("kira00")
                                        task.Wait(6)
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
                local d = 40 --每个敌人的间隔长度
                local x_range = 400
                local y_range = 480
                local function main(b, u)
                    local rabbit_list = {}
                    local xn = x_range/d
                    local yn = y_range/d
                    xn = (xn - 1)/2
                    yn = (yn - 1)/2
                    task.New(b, function()
                        local x0 = ran:Float(-15, 15)
                        for i = -xn, xn do
                            table.insert(rabbit_list, E.rabbit.create(x0 + b.x, b.y, i*d*u, 224, -90 + ran:Float(-5, 5)))
                            task.Wait(5)
                        end
                    end)
                    task.Wait(40)
                    local index = 1
                    for i = -xn, xn do
                        B.perform_arrow.create(b.x, b.y, i*d*u, 224, rabbit_list[index])
                        index = index + 1
                        task.Wait(5)
                    end
                    --move(b)
                    --task.Wait(50)
                    --P.star_big.attack(b.x, b.y, Angle(b, player))
                end
                return main
            end)

    C.SECOND = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local wait = 40
                local function main(b)
                    task.New(b, function()
                        while true do
                            P.star_big.attack(b.x, b.y, Angle(b, player))
                            task.Wait(wait)
                        end
                    end)
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

    local function bgChangePr()
        local bg = lstg.tmpvar.bg
        if IsValid(bg) then
            Del(bg)
        end
        New(stage7_background, true)
    end
    
    local card = EGGlib.BossCard.createFullCard(
            "name-boss3-card6", --非/符卡名
            "spellcard", --类型
            {3, 3, 30}, --时间
            2000, --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                boss.show_aura(b, true)
                task.wait(120) --留比较长的站桩时间
                task.MoveTo(b, 0, 100, 60, MOVE_ACC_DEC)
            end,
            function(b) --练习模式攻击前动作
                bgChangePr()
                b.x, b.y = 0, 100
                boss.show_aura(b, true)
            end,
            function(b) --main
                --持续自机狙攻击
                C.SECOND.main(b)
                while true do
                    for u = -1, 1, 2 do
                        reFresh()
                        C.FIRST.main(b, u)
                    end
                end
            end,
            function(b) --finish
                if system.isDoubleGetSpellCardBonus(b) and b.is_get_double_sc_bonus_list then
                    b.is_get_double_sc_bonus_list[2] = true
                end
                if not b.spell_timeout then
                    item.PlayerLife.create(b.x, b.y)
                end
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
