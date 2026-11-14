-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage7/spellcard/spell_5.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local alpAndSizeCh = EGGlib.ObjectEvent.alphaAndSizeChange
local disapear = EGGlib.ObjectEvent.disappear
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local alphaAndSizeChangeTask = EGGlib.ObjectEvent.alphaAndSizeChangeTask
local move = EGGlib.ObjectEvent.moveToPlayerDefault
local boundWait = EGGlib.ObjectEvent.boundWait
local Bclass = EISlib.BossDefinition.Gluttony
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local warning_laser = EISlib.Bullet.Laser.warning_laser
local moveWithTask = EGGlib.ObjectEvent.moveWithTask
local Bclass = EISlib.BossDefinition.Gluttony
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local moveWith = EGGlib.ObjectEvent.moveWith
local sty = EISlib.Enemy.Style


local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    local cat_inst --傀儡猫
    local bird_list = {}
    local catch_list = {}
    local catch_count = 0 --抓到的鸟的数量
    --region Bullet 自定义子弹

    --鸟
    B.bird = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, v, a, co)
                    local obj = stg.newSimpleBullet(x, y, stg.bird, co)
                    robject.set_color(obj, "", 255, 255, 255, 255)
                    obj.rot = a
                    obj.navi = true
                    boundWait(obj, 180)
                    velchTask(obj, 0, v + ran:Float(-0.05, 0.05), a, 180)
                    table.insert(bird_list, obj)
                end
                return create
            end
    )

    --彩虹拖尾
    B.rainbow_trail = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(mst, t)
                    local obj = New(bent_laser_effection, Bclass.rainbow_tex, mst.x, mst.y, mst.rot, t, 20) --tex, x, y, rot, len, wide
                    obj.bound = false
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    task.New(obj, function()
                        moveWith(obj, mst, 0, 0, t)
                        bent_laser_effection.disappear(obj, t)
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
                    warning_laser.setTrailLength(obj, 40)
                end
                return create
            end
    )

    B.feather = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local vmin = 0.75*defaultSwitchVelocityByRank(rank)
                local vmax = 1*defaultSwitchVelocityByRank(rank)
                local function create(x, y, a)
                    local obj = stg.newBullet(x, y, stg.ellipse, COLOR_GRAY)
                    obj.rot = a
                    obj.navi = true
                    local v = ran:Float(vmin, vmax)
                    velchTask(obj, v + 2, v, a, 30)
                end
                return create
            end
    )
    --endregion
    --region 自定义敌人
    E.cat = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local function create(x, y)
                    local obj = New(enemy, x, y, sty.CAT, --style
                            _infinite, --hp
                            false,  --show_hpbar
                            system.DROP_NONE, --drop
                            true, --no_count
                            nil, --death_func
                            false --type
                    )
                    enemy.setBoundTime(obj, _infinite)
                    obj.colli = false
                    moveWithTask(obj, _boss, 0, 0, _infinite)
                    return obj
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义
    P.bird = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = 0.5*defaultSwitchVelocityByRank(rank)
                local dv = 0.125*defaultSwitchVelocityByRank(rank)
                local layer = 3
                local a_range = 0.5*switch(rank, {
                    5, 5, 5, 5, 10
                })
                local style, color = stg.arrow_big, COLOR_RED
                local function bullet_func(x, y, v_i, a)
                    B.bird.create(x, y, v + dv*v_i, a + ran:Float(-a_range, a_range), COLOR_GRAY)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    circle_layer1(x, y, 0, a, 1, layer, 1, 0, 0, bullet_func)
                end
                return attack
            end
    )
    --endregion
    --region 自定义敌人
    --endregion
    --region Tasker 任务执行器
    --一轮鸟
    T.bird = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                --一列鸟的数量
                local count = 12
                local dx = 500/count
                local function main(u0)
                    boss.createTasker(_boss, _boss.x, _boss.y,
                            function(obj)
                                task.New(obj, function()
                                    local x0 = ran:Float(-20, 20)
                                    local c = (count - 1)/2
                                    for i = -c*u0, c*u0, u0 do
                                        for u = -1, 1, 2 do
                                            P.bird.attack(x0 + dx*i, -245*u, 90*u + 2*i*u + 0*ran:Float(-2, 2))
                                        end
                                        task.Wait(10)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --两侧保护弹幕
    T.protect = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local function main()
                    boss.createTasker(_boss, _boss.x, _boss.y,
                            function(obj)
                                task.New(obj, function()
                                    while true do
                                        for u = -1, 1, 2 do
                                            stg.newStraight(ran:Float(100, 192)*u, ran:Float(224, 245), 3, -90 + ran:Float(-5, 5), stg.ball_mid_c, COLOR_GRAY)
                                        end
                                        task.Wait(4)
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
                    T.bird.main(u)
                    task.Wait(72)
                end
                return main
            end)

    --捕捉鸟
    local function catchBird()
        sp.UnitListUpdate(bird_list)
        for i, obj in pairs(bird_list) do
            if IsValid(obj) and Dist(_boss, obj) < 60 then
                --加入到被捕捉的表里
                catch_count = catch_count + 1
                if catch_count == 800 then
                    achievement.unlock("s7_sc5", true, true)  -- AchievementReminder.unlock("s7_sc5", "捕鸟达人")
                end
                table.insert(catch_list, obj)
                task.clear(obj)
                obj.vx, obj.vy, obj.ax, obj.ay = 0, 0, 0, 0
                obj.colli = false
                obj.hide = true
                moveWithTask(obj, _boss, obj.x - _boss.x, obj.y - _boss.y, _infinite)
                bird_list[i] = nil --移出本表
            end
        end
    end
    --弄爆被捕捉的鸟
    local function killBird()
        PlaySound("tan03")
        sp.UnitListUpdate(catch_list)
        for i, obj in pairs(catch_list) do
            if system.PowerRank.getRank() == 4 then
                for _ = 1, 2 do
                    B.feather.create(obj.x, obj.y, Angle(obj, player) + ran:Float(-90, 90))
                end
            else
                B.feather.create(obj.x, obj.y, Angle(obj, player) + ran:Float(-90, 90))
            end
            _del(obj, true)
        end
    end
    --猫追人
    local function pounceToPlayer()
        local a = Angle(_boss, player)
        --
        PlaySound("ch01")
        B.warning_laser.create(_boss.x, _boss.y, a)
        task.Wait(30)
        --增加彩虹屁
        B.rainbow_trail.create(_boss, 40)
        --预警
        local dx, dy = cos(a), sin(a)

        local timer = 0 --计时器
        local v = 0
        --加速时间
        local t = 15
        local dv = 15/t
        for _ = 1, t do
            v = v + dv
            _boss.x = _boss.x + v*dx
            _boss.y = _boss.y + v*dy
            timer = timer + 1
            if abs(_boss.x) > 192 or abs(_boss.y) > 224 then
                break
            end
            catchBird()
            task.Wait(1)
        end
        --匀速时间
        local t = 25
        for _ = 1, t do
            _boss.x = _boss.x + v*dx
            _boss.y = _boss.y + v*dy
            timer = timer + 1
            if abs(_boss.x) > 192 or abs(_boss.y) > 224 then
                break
            end
            catchBird()
            task.Wait(1)
        end
        killBird()
        --补充时间，保证一次扑击的时间是60帧
        --task.Wait(40 - timer)
        --复位
        if _boss.x < -192 then
            task.MoveTo(_boss, -180, _boss.y, 10, MOVE_ACC_DEC)
        elseif _boss.x > 192 then
            task.MoveTo(_boss, 180, _boss.y, 10, MOVE_ACC_DEC)
        end
        if _boss.y < -224 then
            task.MoveTo(_boss, _boss.x, -200, 10, MOVE_ACC_DEC)
        elseif _boss.y > 224 then
            task.MoveTo(_boss, _boss.x, 200, 10, MOVE_ACC_DEC)
        end

    end
    C.SECOND = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main()
                    for _ = 1, 2 do
                        pounceToPlayer()
                        task.Wait(30)
                    end
                    if rank < 4 then
                        task.MoveTo(_boss, player.x, 144, 30, MOVE_ACC_DEC)
                        --休息一会儿
                        task.Wait(30)
                    else
                        --休息好久了
                        --task.Wait(60)
                    end
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

    local function bossAction(b)
        b.absorbEffect(b, 60)
        b.breakEffect(b, 0)
        robject.set_color(b, "", 1, 255, 255, 255)
        cat_inst = E.cat.create(b.x, b.y)
        task.Wait(60)
    end

    local card = EGGlib.BossCard.createFullCard(
            "name-boss9-card5", --非/符卡名
            "extra", --类型
            {3, 3, 50}, --时间
            2000, --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                task.wait(60)
                task.MoveTo(b, 0, 144, 60, MOVE_NORMAL)
                bossAction(b)
                PlaySound("cat01")
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 144
                boss.show_aura(b, true)
                bossAction(b)
                PlaySound("cat01")
            end,
            function(b) --main
                catch_count = 0
                task.New(b, function()
                    T.protect.main()
                    while true do
                        reFresh()
                        for u = -1, 1, 2 do
                            C.FIRST.main(b, u)
                        end
                    end
                end)
                task.Wait(120)
                --猫追人
                while true do
                    C.SECOND.main()
                end
            end,
            function(b) --finish
                b._a = 255
                if IsValid(cat_inst) then
                    _del(cat_inst, false)
                end
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
