-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage6/spellcard/spell_6.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local disapear = EGGlib.ObjectEvent.disappear
local spSizeAndColliChange = EGGlib.ObjectEvent.spSizeAndColliChange
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local defaultRenderImg = EGGlib.RenderEffect.defaultRenderImg
local sizeAndColliChangeTask = EGGlib.ObjectEvent.sizeAndColliChangeTask
local clearBulletAndLaserInRangeCircle = EGGlib.ObjectEvent.clearBulletAndLaserInRangeCircle
local argbChange = EGGlib.ObjectEvent.argbChange
local extendClass = EGGlib.Math.extendClass
local alphaChange = EGGlib.ObjectEvent.alphaChange
local newTrail = EGGlib.RenderEffect.newTrail
local involuteMoveTask = EGGlib.ObjectEvent.involuteMoveTask
local boundWait = EGGlib.ObjectEvent.boundWait
local circle_normal1 = EGGlib.BulletGroup.Circle.normal1
local setNextCardNoScOpenEffect = EGGlib.BossCard.setNextCardNoScOpenEffect
local sty = EISlib.Enemy.Style
local setProtectTime = EGGlib.ObjectEvent.setProtectTime
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local curve_normalDv1 = EGGlib.BulletGroup.Curve.normalDv1
local warning_laser = EISlib.Bullet.Laser.warning_laser
local lead_laser = EISlib.Bullet.Laser.lead_laser
local laser = EISlib.Bullet.Laser.laser
local movePointWithPar = EGGlib.ObjectEvent.movePointWithPar
local accdecVelch = EGGlib.ObjectEvent.accDecVelocityChange
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local sect_layer1 = EGGlib.BulletGroup.Sector.layer1
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local alphaAndSizeChangeTask = EGGlib.ObjectEvent.alphaAndSizeChangeTask
local move = EGGlib.ObjectEvent.moveToPlayerDefault
local setSize = EGGlib.ObjectEvent.setSize
local sect_normal1 = EGGlib.BulletGroup.Sector.normal1
local AbsorbEffect2 = EGGlib.RenderEffect.AbsorbEffect2
local setNextCardNoScOpenEffect = EGGlib.BossCard.setNextCardNoScOpenEffect


--本张符卡的特殊血灵碎片
local sp_chip = extendClass(item.Blood) --完全继承item.Blood的方法，记得是用create来创建的对象，style填item.Blood.Small
local old_collect = sp_chip.collect
local old_frame = sp_chip.frame
--override
function sp_chip.frame(self)
    --[[范围锁死
    if Dist(self, player) > 80 then
        self.attract = 0
    end]]
    old_frame(self)
end
function sp_chip.collect(self)
    old_collect(self)
    local c = clearBulletAndLaserInRangeCircle(player.x, player.y, 60, 3, 0, 15, false, true) --x, y, range, index, cd, t
    c._a = 100
end
function sp_chip.create(x, y, style)
    return lstg.New(sp_chip, x, y, style)
end

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    --魔法导弹
    B.missile1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y)
                    local obj = stg.newSimpleBullet(x, y, stg.star_big, COLOR_ROYAL_BLUE, true)
                    setSizeAndColli(obj, 0.1, 0.1)
                    sizeAndColliChangeTask(obj, 1.15, 20)
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

    --星弹变链弹
    B.perform_star_small = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, h, a, dt)
                    local obj = stg.newSimpleBullet(x, y, stg.star_small, COLOR_ROYAL_BLUE, true)
                    obj.bound = false
                    obj.rot = a
                    obj.omiga = 6
                    robject.set_color(obj, "mul+add", 0, 255, 255, 255)
                    setSize(obj, 3, 3)
                    alphaAndSizeChangeTask(obj, 255, -2, 30)
                    task.New(obj, function()
                        local v = h/30
                        obj.layer = LAYER_ENEMY_BULLET - 1
                        accdecVelch(obj, v, a, 30, 0, 30)
                        task.Wait(dt)
                        PlaySound("kira00")
                        _del(obj, true)
                    end)
                end
                return create
            end
    )

    --生小星星的大星星
    B.star_big = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local range = switch1(diff, {
                    10, 10, 10, 30, 10
                })
                local v = switch1(diff, {
                    1.5, 1.5, 1.5, 1.5, 1.5
                })
                local dv = switch1(diff, {
                    0.75, 0.75, 0.75, 0.75, 0.75
                })
                local dt = 8
                local function create(x, y, dv_i, a)
                    local o = stg.newStraight(x, y, v + dv*dv_i, a, stg.star_big, COLOR_DEEP_BLUE, true) --上层叠一个大星星
                    o.omiga = 3
                    setSize(o, 1.25, 1.25)
                    local obj = stg.newBullet(x, y, stg.star_big, COLOR_BLUE, true)
                    obj.omiga = 3
                    obj.rot = a
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    SetV(obj, v + dv*dv_i, a)
                    task.New(obj, function()
                        --setSizeAndColli(obj, 1.5, 1.5)
                        for i = 0, _infinite do
                            if Dist(obj, player) > 60 then
                                B.star_small.create(obj.x, obj.y, a + ran:Float(-0.5*range, 0.5*range), 120 + dt*dv_i*i)
                            end
                            task.Wait(20)
                        end
                    end)
                    task.New(obj, function()
                        task.Wait(30)
                        obj._blend = ""
                    end)
                end
                return create
            end
    )

    --小星星
    B.star_small = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v = switch1(diff, {
                    1.5, 1.5, 1.5, 1.5, 1.5
                })
                local function create(x, y, a, dt)
                    local obj = stg.newSimpleBullet(x, y, stg.star_small, COLOR_BLUE)
                    robject.set_color(obj, "mul+add", 0, 255, 255, 255)
                    obj.colli = false
                    obj.omiga = 3
                    obj.rot = a
                    --渐变
                    setSize(obj, 3, 3)
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET - 1
                        alphaAndSizeChange(obj, 255, -2, 30)
                        obj.colli = true
                    end)
                    --移动
                    task.New(obj, function()
                        --SetV(obj, 0.1, ran:Float(0, 360), true)
                        task.Wait(dt)
                        obj._blend = ""
                        PlaySound("kira00")
                        velch(obj, 0, v, a, 60)
                    end)
                end
                return create
            end
    )

    --激光
    B.laser1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, h, a, da, dt)
                    local obj = stg.newSimpleBullet(x, y, stg.star_big, COLOR_DEEP_BLUE, true)
                    obj.bound = false
                    obj.rot = a
                    obj.omiga = 6
                    robject.set_color(obj, "mul+add", 0, 255, 255, 255)
                    setSize(obj, 3, 3)
                    alphaAndSizeChangeTask(obj, 255, -2, 30)
                    task.New(obj, function()
                        local v = h/30
                        obj.layer = LAYER_ENEMY_BULLET - 1
                        accdecVelch(obj, v, a, 30, 0, 30)
                        a = Angle(obj, player) + da
                        New(warning_laser,
                                obj.x, obj.y, --x, y
                                600, 30, --len, l_t
                                4, 10, --wide, w_t
                                a, "mul+add", Color(200, 255, 0, 0), 60).bound = false
                        PlaySound("lazer00")
                        task.Wait(30 + dt)
                        PlaySound("lazer01")
                        New(lead_laser,
                                1, COLOR_RED, --type, co
                                obj.x, obj.y, 15, a, --x, y, v, a
                                450, 12, 15, 1, --len, w0, w1, t
                                false, false, 90 --islock, isshoot, last_time
                        )._blend = "mul+add"
                        task.Wait(180)
                        _del(obj, true)
                    end)
                    return obj
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义
    P.arrow_small_b = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = switch1(diff, {
                    2, 3, 3, 4, 4
                })
                local da = switch1(diff, {
                    0.75, 0.8, 0.75, 1, 1
                })
                local v0 = switch1(diff, {
                    0.75, 0.8, 0.9, 1, 1
                })
                local layer = 1
                local dv_l = 1.5
                local dv = switch1(diff, {
                    0.05, 0.05, 0.45, 0.5, 0.5
                })
                local style, color = stg.arrow_small_b, COLOR_ROYAL_BLUE
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 2.5, v, a, 30, 30, style, color, false, 1)
                end
                --dv_i是for循环里的自增量i
                --da_rate是用于处理不同阶段每way链弹的圆心角间隔倍率
                local function attack(x, y, dv_i, a, da_rate)
                    PlaySound("kira00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_layer1(x, y, v0 + dv*dv_i, a, way, da*da_rate,
                                        layer, dv_l, 0,
                                        bullet_func)
                            end)
                end
                return attack
            end
    )

    --开幕大星星
    P.first_star_big = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = switch1(diff, {
                    16, 16, 24, 32, 32
                })
                local layer = switch1(diff, {
                    2, 3, 3, 3, 3
                })
                local da = 360/way/layer
                local style, color = stg.star_big, COLOR_BLUE
                local function bullet_func(x, y, dv_i, a)
                    B.star_big.create(x, y, dv_i, a)
                end
                local function attack(x, y, a, u)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, 0, a, way, --x, y, i, a, way
                                        layer, 1, da*u, 0, --layer, di, da, dway
                                        bullet_func)
                            end)
                end
                return attack
            end
    )

    --常规波大星星
    P.star_big = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = switch1(diff, {
                    12, 12, 14, 16, 16
                })
                local layer = switch1(diff, {
                    3, 3, 3, 3, 3
                })
                local da = 360/way/layer
                local style, color = stg.star_big, COLOR_BLUE
                local function bullet_func(x, y, dv_i, a)
                    B.star_big.create(x, y, dv_i, a)
                end
                local function attack(x, y, a, u)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, 0, a, way, --x, y, i, a, way
                                        layer, 1, da*u, 0, --layer, di, da, dway
                                        bullet_func)
                            end)
                end
                return attack
            end
    )

    P.arrow_small_b2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = switch1(diff, {
                    1, 2, 2, 2, 2
                })
                local da = switch1(diff, {
                    0.5, 0.5, 0.75, 1, 1
                })
                local v0 = switch1(diff, {
                    0.56, 0.64, 0.72, 0.8, 0.8
                })
                local dv = switch1(diff, {
                    0, 0, 0.18, 0.2, 0.2
                })
                local style, color = stg.arrow_small_b, COLOR_DEEP_BLUE
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color, false, 2)
                end
                --dv_i是for循环里的自增量i
                --da_rate是用于处理不同阶段每way链弹的圆心角间隔倍率
                local function attack(x, y, dv_i, a, da_rate)
                    PlaySound("kira00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_normal1(x, y, v0 + dv*dv_i, a, way, da*da_rate,
                                        bullet_func)
                            end)
                end
                return attack
            end
    )

    --护身弹幕
    P.protect = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = 3
                local way_c = switch1(diff, {
                    5, 5, 5, 5, 5
                })
                local da_c = 6/(way_c - 1)
                way_c = (way_c - 1)/2
                local way = switch1(diff, {
                    16, 16, 16, 16, 16
                })
                local da = 360/way
                local style, color = stg.arrow_small_b, COLOR_DEEP_RED
                local function bullet_func(x, y, v, a)
                    for i = -way_c, way_c do
                        stg.newSimpleStraight(x, y, v, a + da_c*i, style, color)
                    end
                end
                local function attack(x, y, i)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_normal1(x, y, v, -90 + 0.4*da*i, way, bullet_func)
                            end)
                end
                return attack
            end
    )
    --endregion
    --region Death Defined
    --血灵碎片破碎后的消弹效果
    D.death1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local function main(e)
                    local x, y = e.x, e.y
                    enemy.createDeath(
                            1, --total_time,
                            function()
                                EGGlib.ObjectEvent.clearBulletAndLaserInRangeCircle(
                                        x, y, 60, 2 --x, y, rmax, index
                                )
                            end)
                end
                return main
            end)
    --endregion
    --region 自定义敌人
    --endregion
    --region Tasker 任务执行器
    --蓝青苦无
    T.arrow_small_b = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local function main(x, y, a, dt, dv_i, da_rate)
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                task.New(obj, function()
                                    task.Wait(dt)
                                    P.arrow_small_b.attack(obj.x, obj.y, dv_i, a, da_rate)
                                    --if _boss.timer > 1380 - 90 - 90 - 90 - 90 then
                                        P.arrow_small_b2.attack(x, y, dv_i, a, da_rate)
                                    --end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)


    --非符弹幕生成
    T.missile1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local t = 60
                local layer = 2
                local count = 30
                local interval = 1
                local wait = 1
                --激光的密度参数（越大密度越小
                local n = switch1(diff, {
                    4, 4, 3, 2, 3
                })

                local da0 = switch1(diff, {
                    -30, -30, -30, -30, -30
                })
                local da = -da0/(count - 1)
                local ls_da = switch1(diff, {
                    6, 4.5, 4.5, 6, 4.5
                })
                local function main(b, x, y, u, da_rate)
                    local obj = B.missile1.create(b.x, b.y)
                    obj.bound = false
                    _connect(b, obj, 0, true)
                    task.New(obj, function()
                        movePointWithPar(obj, x, y, 4, 50, u)
                        local a = 90 - 70*u
                        velchTask(obj, 4.8, 14.4, a, t)
                        task.New(obj, function()
                            task.Wait(ran:Int(0, 5))
                            local l, dl = 0, 4
                            a = a - 90*u
                            local dx, dy = cos(a), sin(a)
                            for i = 0, count - 1 do
                                for j = 0, layer - 1 do
                                    B.perform_star_small.create(
                                            obj.x, obj.y, --x, y
                                            l, a, --l, a
                                            interval*(count - 1 - i) + (layer - 1 - j)*wait --dt
                                    )
                                    task.Wait(wait)
                                    l = l + dl
                                end
                                --青、蓝苦无
                                T.arrow_small_b.main(
                                        obj.x + l*dx, obj.y + l*dy, a + (da0 + da*i)*u, --x, y, a
                                        60 + interval*(count - 1 - i) + layer*wait, --dt
                                        i%3, da_rate --dv_i, da_rate
                                )
                                --激光
                                if _boss.timer > 780 and i % n == 0 then
                                    B.laser1.create(
                                            obj.x, obj.y,  --x, y
                                            l, a, --l, a
                                            ls_da*(i - 12)*u, interval*(count - 1 - i) --da , dt
                                    )
                                end
                            end
                            Del(obj)
                        end)
                    end)
                end
                return main
            end)

    T.chip_creater = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = 4
                local x_range = 350
                local dx = x_range/count
                local function main(b, u)
                    boss.createTasker(b, b.x, b.y,
                            function(obj)
                                local x0 = ran:Float(-10, 10) - 0.5*x_range*u
                                task.New(obj, function()
                                    for i = 0, count - 1 do
                                        sp_chip.create(
                                                x0 + dx * i * u,
                                                ran:Float(245, 255),
                                                item.Blood.Small)
                                        task.Wait(60)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --护身弹，禁止自机靠近屏幕一半以上的高度
    T.protect = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local wait = 10
                local function main()
                    boss.createTasker(_boss, _boss.x, _boss.y,
                            function(obj)
                                task.New(obj, function()
                                    for i = 0, _infinite do
                                        if player.y > -100 then
                                            P.protect.attack(_boss.x, _boss.y, i)
                                        end
                                        task.Wait(wait)
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
                local function main(b, u, da_rate)
                    T.missile1.main(b, -224*u, 200, u, da_rate)
                    task.Wait(90)
                end
                return main
            end)

    C.SECOND = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main(b, u)
                    P.first_star_big.attack(b.x, b.y, Angle(b, player), u)
                    task.Wait(20)
                    T.chip_creater.main(b, u)
                    task.Wait(210)
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
    
    local function bgChange()
        local bg = lstg.tmpvar.bg
        if IsValid(bg) and bg.class.moonAppear then
            bg.class.moonAppear(bg)
        end
    end

    local function bgChangePr()
        local bg = lstg.tmpvar.bg
        if IsValid(bg) and bg.class.flyToSky then
            bg.class.flyToSky(bg, true)
            if bg.class.moonAppear then
                bg.class.moonAppear(bg)
            end
        end
    end

    local function bossAction(b)
        for _ = 1, 3 do
            PlaySound("ch00")
            b.absorbEffect(b, 20)
        end
        setNextCardNoScOpenEffect(b)
    end

    local function bossActionPrac(b)
        task.New(b, function()
            --强制结束hyper
            if system.PowerRank.isInHyper() then
                system.PowerRank.hyperNormalEnd(player)
            end
            system.PowerRank.openInfiniteHyperMode()
            system.PowerRank.setHyperTime(system.PowerRank.getHyperMaxTime())
            system.PowerRank.hyperStart()
            system.PowerRank.pauseHyper()
        end)
        b.openBacklight()
        effect.shakeScreen(120, 10)
        setNextCardNoScOpenEffect(b)
    end
    
    local names = {
        "name-boss8-card6-E",
        "name-boss8-card6-N",
        "name-boss8-card6-H",
        "name-boss8-card6-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "finalspell", --类型
            {3, 3, 75}, --时间
            8800, --耐久
            {0, 100}, --掉落
            function(b) --普通模式攻击前动作
                player_class.setHUDhide(b)
                task.Wait(120)
                task.MoveTo(b, 0, 120, 60, MOVE_NORMAL)
                bossAction(b)
            end,
            function(b) --练习模式攻击前动作
                player_class.setHUDhide(b)
                bgChangePr()
                b.x, b.y = 0, 120
                bossActionPrac(b)
                boss.show_aura(b, true)
            end,
            function(b) --main
                local dmg_rate = 1
                if player.name then --针对不同自机伤害倍率调整
                    if player.name == "reimu" then
                        dmg_rate = 1.02
                    elseif player.name == "marisa" then
                        dmg_rate = 0.96
                    elseif player.name == "sakuya" then
                        dmg_rate = 0.96
                    end
                end
                b.dmgrate = dmg_rate --针对不同机体的减伤机制

                reFresh()
                --自己再加开卡演出
                b.scOpenEffect(b)
                --护身弹
                T.protect.main()
                --星星变链弹
                task.New(b, function()
                    local da_rate = 1
                    while b.timer < 480 - 90 - 90 - 90 do
                        task.Wait(1)
                    end
                    while true do
                        for u = -1, 1, 2 do
                            C.FIRST.main(b, u, da_rate)
                        end
                    end
                end)
                --多way弹
                task.New(b, function()
                    b.breakEffect(b, 0)
                    PlaySound("enep04")
                    P.first_star_big.attack(b.x, b.y, -90, 1)
                    T.chip_creater.main(b, 1)
                    task.Wait(240)
                    while true do
                        for u = -1, 1, 2 do
                            C.SECOND.main(b, u)
                        end
                    end
                end)
            end,
            function(b) --finish
                b.dmgrate = 1 --请恢复，不过因为是最后一个阶段，好像不恢复也没啥事
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )

    local _sc = EGGlib.BossCard.getFullCardMain(card)
    --override
    --在符卡最开始时取消自机hud（先于通用模板的立绘演出和强制等待）
    function _sc.inTheFrontOfInit(b)
        player_class.setHUDhide(b)
    end

    return card
end
return createCard
