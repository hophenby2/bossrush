-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage4/spellcard/spell_1.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local setSize = EGGlib.ObjectEvent.setSize
local movePointWithPar = EGGlib.ObjectEvent.movePointWithPar
local warning_laser = EISlib.Bullet.Laser.warning_laser
local sect_layer1 = EGGlib.BulletGroup.Sector.layer1
local velch = EGGlib.ObjectEvent.velocityChange
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local alpAndSizeCh = EGGlib.ObjectEvent.alphaAndSizeChange
local sizeChangeTask = EGGlib.ObjectEvent.sizeChangeTask
local sizeChange = EGGlib.ObjectEvent.sizeChange
local disapear = EGGlib.ObjectEvent.disappear
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local simPar = EGGlib.ObjectEvent.simPar
local boundWait = EGGlib.ObjectEvent.boundWait
local AbsorbEffect2 = EGGlib.RenderEffect.AbsorbEffect2
local sty = EISlib.Enemy.Style
local expression = EISlib.Effect.expression
local moveWithTask = EGGlib.ObjectEvent.moveWithTask
local boss_name = "Marguerite"
local light_tex = boss_name.."_light"
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local halfMoveLengthWithPar = EGGlib.ObjectEvent.halfMoveLengthWithPar

--血灵碎片拖影
local chipLight = Class(laser_bent)
function chipLight:init(mst, len, wide)
    if IsValid(mst) then
        laser_bent.init(self, 1, mst.x, mst.y, len, wide, "Sonia_chip_light", 0)
        local a = Angle(0, 0, mst.vx, mst.vy)
        self.rot = a
        self.alpha = 1
        self.group = GROUP_GHOST -- 特效用曲线激光
        self.layer = LAYER_ENEMY
        self.colli = false -- 特效用曲线激光
        self.bound = false
        self.mst = mst
        self.release = false
        robject.set_color(self, "mul+add", 255, 255, 255, 255)
    else
        self.status = "del"
    end
end
function chipLight:frame()
    if IsValid(self.mst) then
        self.x, self.y = self.mst.x, self.mst.y
    else
        self.status = "del"
    end

    if self.timer > 120 then
        self.bound = true
    end
    laser_bent.frame(self)
end

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    B.fire = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, v0, v1, a, t0, t1)
                    local obj = stg.newSimpleBullet(x, y, stg.water_drop, COLOR_ORANGE, true)
                    robject.set_color(obj, "mul+add", 0, 255, 255, 255)
                    velchTask(obj, v0, v1, a, t0, t1)
                    obj.rot = a
                    setSize(obj, 4, 4)
                    task.New(obj, function()
                        alphaAndSizeChange(obj, 255, -3, 60)
                        robject.set_color(obj, "", 255, 255, 255, 255)
                    end)
                end
                return create
            end
    )

    --砌墙的弹幕
    B.wall = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v = switch1(diff, {
                    1, 1.33, 1.67, 2, 2
                })
                local function create(x, y, dt)
                    local obj = stg.newSimpleBullet(x, y, stg.water_drop, COLOR_RED, true)
                    robject.set_color(obj, "mul+add", 0, 255, 255, 255)
                    setSize(obj, 5, 5)
                    obj.colli = false
                    obj.rot = -90
                    task.New(obj, function()
                        velchTask(obj, 8, 0, 90, 60)
                        alphaAndSizeChange(obj, 255, -3.5, 60)
                        --velch(obj, 1, 0, -90, 60)
                        obj.colli = true
                        task.Wait(dt)
                        PlaySound("kira00")
                        velch(obj, 0, v, -90, 120)
                    end)
                end
                return create
            end
    )

    --最后一堵墙
    B.final_wall = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v = switch1(diff, {
                    1.5, 1.5, 1.5, 1.5, 1.5
                })*defaultSwitchVelocityByRank(rank)
                local n = 1
                local function create(x, y, dt, i)
                    local obj = stg.newSimpleBullet(x, y, stg.water_drop, COLOR_RED, true)
                    boundWait(obj, 240)
                    robject.set_color(obj, "mul+add", 0, 255, 255, 255)
                    setSize(obj, 5, 5)
                    obj.colli = false
                    obj.rot = -90
                    task.New(obj, function()
                        velchTask(obj, 4, 0, 90, 60)
                        alphaAndSizeChange(obj, 255, -2, 60)
                        obj.colli = true
                        task.Wait(dt)
                        PlaySound("kira00")
                        task.New(obj, function()
                            while obj.y > -150 do
                                task.Wait(1)
                            end
                            if i%n == 0 then
                                sizeChange(obj, -2, 30)
                            else
                                sizeChange(obj, -3, 30)
                                _del(obj, false)
                            end
                        end)
                        velch(obj, 0, v, -90, 120)
                    end)
                end
                return create
            end
    )

    --聚集在boss身上的能量气旋
    B.light = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, x1, y1, a)
                    local obj = New(bent_laser_effection, light_tex, x, y, a,
                            30, 9 --len, wide
                    )
                    task.New(obj, function()
                        halfMoveLengthWithPar(obj, x1, y1, 0, a,
                                30, 10, 10, 0  --t0, t1, t2, t3
                        )
                        bent_laser_effection.disappear(obj, 30)
                    end)
                end
                return create
            end
    )

    --用作特效的光球
    B.ball_light_effect = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y)
                    local obj = stg.newSimpleBullet(x, y, stg.ball_light, COLOR_YELLOW)
                    robject.set_color(obj, "mul+add", 0, 255, 255, 255)
                    obj.group = GROUP_GHOST
                    setSize(obj, 4, 4)
                    task.New(obj, function()
                        alphaAndSizeChange(obj, 255, -4, 30)
                        _del(obj, false)
                    end)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义
    P.fire = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = switch1(diff, {
                    1.5, 1.75, 2, 2.25, 2.25
                })*defaultSwitchVelocityByRank(rank)
                local style, color = stg.water_drop, COLOR_ORANGE
                local function bullet_func(x, y, v, a)
                    B.fire.create(x, y, 0, v, a, 120, 0)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    for i = 0, 1 do
                        bullet_func(x, y, v, a + 180*i)
                    end
                end
                return attack
            end
    )

    P.wall = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local layer = switch1(diff, {
                    1, 2, 2, 3, 3
                })
                local function attack(x, y, dt)
                    PlaySound("kira00")
                    for i = 0, layer - 1 do
                        B.wall.create(x, y + 15*i, dt)
                    end
                end
                return attack
            end
    )

    P.final_wall = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local layer = 1
                local function attack(x, y, dt, c)
                    PlaySound("kira00")
                    for i = 0, layer - 1 do
                        B.final_wall.create(x, y + 15*i, dt, c)
                    end
                end
                return attack
            end
    )


    --endregion
    --region Enemy 使魔
    E.enemy1 = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local function create(x, y, x1, y1)
                    local obj = New(enemy, x, y, sty.FAIRY_MIDDLE_3_RED, --style
                            20, --hp
                            false,  --show_hpbar
                            system.DROP_NONE, --drop
                            true, --no_count
                            nil, --death_func
                            false --type
                    )
                    obj.colli = false
                    task.New(obj, function()
                        local t = math.floor(Dist(x, y, x1, y1)/2)
                        task.MoveTo(obj, x1, y1, t, MOVE_ACC_DEC)
                        task.Wait(120 - t)
                        --急了急了
                        local e = New(expression, x, y, "tired")
                        moveWithTask(e, obj, 0, 20) --obj, mst, dx ,dy, t
                        expression.defaultShow(e, 20, 40, 10) --t0, t1, t2
                        task.Wait(90)
                        local a = Angle(obj, _boss)
                        while true do
                            for u = -1, 1, 2 do
                                B.light.create(obj.x, obj.y, 0, 120, a + ran:Float(90, 135)*u)
                                task.Wait(15)
                            end
                        end
                    end)
                    return obj
                end
                return create
            end
    )
    --endregion
    --region Tasker 任务执行器
    --一串火焰生成器
    T.fire = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                --直接影响炎弹生成密度的参数，越小密度越大
                local v_rate = switch1(diff, {
                    1.35, 1.25, 1.15, 1, 1
                })
                local function main(b, x, y, u, interval, i)
                    boss.createTasker(b, x, y,
                            function(obj)
                                boundWait(obj, 120)
                                --移动逻辑
                                simPar(obj, 2*v_rate, -90 + 0*u, 0.1*v_rate, 90*(1 - u))
                                --发弹逻辑
                                task.New(obj, function()
                                    task.Wait(i%interval)
                                    while true do
                                        P.fire.attack(obj.x, obj.y, Angle(0, 0, obj.vx, obj.vy) + 90*u)
                                        task.Wait(interval)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --一串火焰生成器2（最后砌墙攻击前用的）
    T.fire2 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local v = switch(rank, {
                    2, 2, 2, 2, 1.33
                })
                local acc = switch(rank, {
                    0.1, 0.1, 0.1, 0.1, 0.067
                })
                local function main(b, x, y, u, interval, i)
                    boss.createTasker(b, x, y,
                            function(obj)
                                boundWait(obj, 120)
                                --移动逻辑
                                simPar(obj, v, -90 + 0*u, acc, 90*(1 - u))
                                --发弹逻辑
                                task.New(obj, function()
                                    task.Wait(i%interval)
                                    while true do
                                        P.fire.attack(obj.x, obj.y, Angle(0, 0, obj.vx, obj.vy) + 90*u)
                                        task.Wait(interval)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --砌墙
    T.wall = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local interval = 1
                local dt0 = 40
                --缝的中心x与x=0的x坐标距离
                local x_dist_to_center = switch1(diff, {
                    35, 40, 45, 50, 60
                })
                local d_x_dist_to_center = switch(rank, {
                    0, 0, 0, 0, 20
                })
                local x_range = switch1(diff, {
                    65, 60, 55, 50, 30
                })
                local function main(x, y, i, u)
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                boundWait(obj, 120)
                                --移动逻辑
                                SetV(obj, 10, 90*(1-u))
                                --发弹逻辑
                                task.New(obj, function()
                                    --决定缝在哪
                                    local x0 = (x_dist_to_center + d_x_dist_to_center*math.ceil(i/2))*u
                                    local xim, xmax = x0 - 0.5*x_range, x0 + 0.5*x_range
                                    for i = 0, _infinite do
                                        if obj.x < xim or obj.x > xmax then
                                            P.wall.attack(obj.x, obj.y, dt0 - interval*i)
                                        end
                                        task.Wait(interval)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)


    --最后一堵墙
    T.final_wall = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local interval = 1
                local dt0 = 30
                local function main(b, x, y, u)
                    boss.createTasker(b, x, y,
                            function(obj)
                                boundWait(obj, 60)
                                --移动逻辑
                                SetV(obj, 20, 90*(1-u))
                                --发弹逻辑
                                task.New(obj, function()
                                    --决定缝在哪
                                    for i = 0, _infinite do
                                        P.final_wall.attack(obj.x, obj.y, dt0 - interval*i, i)
                                        task.Wait(interval)
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
                local t = 900
                local interval = switch1(diff, {
                    12, 9, 6, 5, 5
                })
                local wait = 3*interval
                local count = t/(2*wait)
                --local count = 1
                local function main(b)
                    task.New(b, function()
                        local y0, dy = 224, -150/(2*count - 1)
                        for i = 0, count - 1 do
                            for u = -1, 1, 2 do
                                T.fire.main(b, -180*u, y0, u, interval, i)
                                task.Wait(wait)
                                y0 = y0 + dy
                            end
                        end
                    end)
                end
                return main
            end)

    C.SECOND = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local t = 900
                local wait = 180
                local count = t/wait
                local function main(b)
                    task.New(b, function()
                        local u
                        for i = 0, count - 1 do
                            u = tranU(i)
                            T.wall.main(-224*u, -50, i, u)
                            task.Wait(wait)
                        end
                    end)
                end
                return main
            end)

    C.THIRD = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local interval = switch1(diff, {
                    12, 9, 6, 5, 5
                })
                local wait = interval
                local count = switch1(diff, {
                    3, 4, 6, 7, 7
                })
                --最高一层火弹的初始生成高度
                local ymax = switch1(diff, {
                    125, 175, 208, 255, 255
                })
                local function main(b)
                    task.New(b, function()
                        local y0, dy = 0, ymax/(2*count - 1)
                        for i = 0, count - 1 do
                            for u = -1, 1, 2 do
                                T.fire2.main(b, -180*u, y0, u, interval, i)
                                task.Wait(wait)
                                y0 = y0 + dy
                            end
                        end
                    end)
                end
                return main
            end)

    --最后一轮砌墙攻击
    C.FORTH = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local wait = 2
                local count = 24
                local function main(b)
                    local x0 = ran:Float(-5, 5)
                    local y0, dy = -200, 500/count
                    task.New(b, function()
                        local u
                        for i = 0, count - 1 do
                            u = tranU(i)
                            T.final_wall.main(b, -220.25*u + x0, y0 + dy*i, u)
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

    local function boss_action(b)
        robject.set_color(b, "", 0, 255, 255, 255)
        b.x, b.y = 0, 120
        boss.show_aura(b, false)
        b.colli = false
        task.Wait(90)
        local way, r
        local da = 180/3
        b.enemy_list = {}
        for i = 0, 1 do
            way = 4+i
            way = (way - 1)/2
            r = 90 + 60*i
            for j = -way, way do
                if j == 0 then
                    table.insert(b.enemy_list, E.enemy1.create(0, 224, 0 + r*cos(-90 + da*j), 120 + r*sin(-90 + da*j)))
                else
                    table.insert(b.enemy_list, E.enemy1.create(sign(j)*224, 120 + r*sin(-90 + da*j), 0 + r*cos(-90 + da*j), 120 + r*sin(-90 + da*j)))
                end
            end
        end
        task.Wait(180)
        for _ = 1, 5 do
            B.ball_light_effect.create(0, 120)
            task.Wait(15)
        end
        New(AbsorbEffect2, b.x, b.y, 255, 255, 0, "mul+add")
        PlaySound("ch00")
        for _ = 1, 4 do
            B.ball_light_effect.create(0, 120)
            task.Wait(15)
        end
    end
    
    local names = {
        "name-boss6-card2-E",
        "name-boss6-card2-N",
        "name-boss6-card2-H",
        "name-boss6-card2-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "timespell", --类型
            {26, 26, 26}, --时间
            1300, --耐久
            {50, 50}, --掉落
            function(b) --普通模式攻击前动作
                boss_action(b)
            end,
            function(b) --练习模式攻击前动作
                boss_action(b)
            end,
            function(b) --main
                --播放音效
                task.New(b, function()
                    while true do
                        PlaySound("fire")
                        task.Wait(1800)
                    end
                end)
                task.New(b, function()
                    while true do
                        B.ball_light_effect.create(0, 120)
                        task.Wait(15)
                    end
                end)
                reFresh()
                C.FIRST.main(b)
                C.SECOND.main(b)
                task.Wait(1020)
                New(AbsorbEffect2, b.x, b.y, 255, 0, 0, "mul+add")
                --task.Wait(30)
                C.THIRD.main(b)
                task.Wait(150)
                C.FORTH.main(b)
            end,
            function(b) --finish
                b.colli = true
                b._a = 255
                for k, obj in pairs(b.enemy_list) do
                    if IsValid(obj) then
                        _del(obj, false)
                    end
                end
                effect.shakeScreen(20, 10)
                boss.show_aura(b, true)
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
