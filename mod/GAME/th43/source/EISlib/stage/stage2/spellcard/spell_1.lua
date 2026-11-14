-----------------------------------------
---东方栖霞园符卡 二面sc1
-----------------------------------------
--todo 成就，击破所有的兔子并且收取符卡   或者  全避这张符卡并且不击破任何一只兔子
--boss素材
local boss_name = "Artemina"
local normal_apple_img = boss_name.."_apple_normal"
local bad_apple_img = boss_name.."_apple_bad"
local cyan_apple_img = boss_name.."_apple_cyan"
local golden_apple_img = boss_name.."_apple_golden"

--其他变量或者函数
local curpath = EISlib.stage.path.."stage2/spellcard/spell_1.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local velch = EGGlib.ObjectEvent.velocityChange
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local no_info = 0
local tranRot = EGGlib.Math.TranRot
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local sizeChange = EGGlib.ObjectEvent.sizeChange
local setSize = EGGlib.ObjectEvent.setSize
local spSizeAndColliChange = EGGlib.ObjectEvent.spSizeAndColliChange
local sect_layer2 = EGGlib.BulletGroup.Sector.layer2
local SIN = EGGlib.Math.SIN
local COS = EGGlib.Math.COS
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local alphaAndSizeChangeTask = EGGlib.ObjectEvent.alphaAndSizeChangeTask
local sty = EISlib.Enemy.Style
local halfMoveLengthWithPar = EGGlib.ObjectEvent.halfMoveLengthWithPar
local expression = EISlib.Effect.expression
local moveWithTask = EGGlib.ObjectEvent.moveWithTask

--本例特有obj定义
--苹果
local apple = Class(object)
do
    function apple:init(x, y, type)
        apple.changeType(self, type)
        self.x, self.y = x, y
        self.hscale, self.vscale = 1, 1
        self.group = GROUP_GHOST
        self.layer = LAYER_ENEMY_BULLET
        self.a, self.b = 32, 32
        self.maxhp = 50
        self.hp = self.maxhp
        self.type = true --这个算大怪的
        robject.set_color(self, "", 255, 255, 255, 255)
    end
    function apple:frame()
        task.Do(self)
        if self.hp < 0 then
            Kill(self)
        end
    end
    function apple:render()
        --简单实现一下苹果晃动的效果
        local t = 4*self.timer
        SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
        Render(self.img, self.x, self.y, self.rot + 5*SIN[t%360 + 1], 0.75*self.hscale, 0.75*self.vscale)
    end
    function apple:del()
        New(enemy_death_ef, self._death_color, self.x, self.y, max(self.hscale, self.vscale), false)
    end
    function apple:kill()
        New(enemy_death_ef, self._death_color, self.x, self.y, max(self.hscale, self.vscale), false)
    end
    function apple:colli(other)
        enemybase.colli(self, other)
    end
    function apple:take_damage(dmg)
        self.hp = self.hp - dmg
    end
    function apple:changeType(type)
        if type == "normal" then
            self.img = normal_apple_img
            self._death_color = 9
        elseif type == "bad" then
            self.img = bad_apple_img
            self._death_color = 16
        elseif type == "cyan" then
            self.img = cyan_apple_img
            self._death_color = 13
        elseif type == "golden" then
            self.img = golden_apple_img
            self._death_color = 14
        end
    end
end

--小动物目标预警线
local target_line = Class(laser_bent)
do
    function target_line:init(x, y, target)
        laser_bent.init(self, 1, x, y, 60, 15, "_reimutrail_eff1", 0) --x, y, len, wide
        self.rot = Angle(self, target)
        self.alpha = 1
        self.group = GROUP_GHOST -- 特效用曲线激光
        self.colli = false -- 特效用曲线激光
        self.bound = false
        task.New(self, function()
            if IsValid(target) then
                task.MoveTo(self, target.x, target.y, 40, MOVE_NORMAL)
            end
            --在t时间内变短至消失
            local t = 60
            local l0 = self.l
            local dl = -l0/t
            while l0 + dl > 2 do
                l0 = l0 + dl
                self.l = math.ceil(l0)
                task.Wait(1)
            end
            self.status = 'del'
        end)
    end
    function target_line:frame()
        laser_bent.frame(self)
    end
end


--符卡定义
local function createCard(difficulty)
    local B, P, S, C, T, E, M, D = {}, {}, {}, {}, {}, {}, {}, {}
    local achi1_flag = false --成就判断flag1（无伤全避并且不击破一只兔子）
    local achi2_flag = false --成就判断flag2（强化攻击收取并且击破所有的兔子）
    --region Bullet 自定义子弹
    B.bullet_demo = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y)
                    local obj = stg.newBullet(x, y, stg.arrow_big, COLOR_RED)
                end
                return create
            end
    )

    --藤蔓弹幕
    B.vine = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v = switch1(diff, {
                    1.75, 2.25, 2.75, 3.25, 3.25
                })*defaultSwitchVelocityByRank(rank)
                local function create(x, y, rot, dt, a, isCreate)
                    local obj = stg.newBullet(x, y, stg.grain_a, COLOR_GREEN, false)
                    robject.set_color(obj, "", 255, 255, 255, 255)
                    obj.rot = rot
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET - 1
                        task.Wait(dt)
                        PlaySound("kira00")
                        if isCreate and Dist(obj, player) > 100 then
                            stg.newStrChV(obj.x, obj.y, 0, v, a, 120, 0, stg.arrow_big, COLOR_GREEN)
                        end
                        Del(obj)
                    end)
                end
                return create
            end
    )

    --花
    B.flower = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a, dt)
                    local obj = stg.newSimpleBullet(x, y, stg.ball_mid_c, COLOR_DEEP_RED)
                    robject.set_color(obj, "", 255, 255, 255, 255)
                    obj.colli = false
                    setSizeAndColli(obj, 0.01, 0.01)
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET + 1
                        spSizeAndColliChange(obj, 1.99, 30, 150) --obj, ds, dt, phase
                        obj.colli = true
                        for i = 1, 5 do
                            B.flower_1.create(x, y, a + 72*i, dt)
                        end
                        task.Wait(30 + dt)
                        spSizeAndColliChange(obj, -obj.hscale, 30, 150) --obj, ds, dt, phase
                        _del(obj, true)
                        --velch(obj, 0, v0, a, 60)
                    end)
                    return obj
                end
                return create
            end
    )
    --花瓣
    B.flower_1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local r0 = 20
                local s0 = 1.5
                local function create(x, y, a, dt)
                    local obj = stg.newSimpleBullet(x, y, stg.arrow_big, COLOR_RED)
                    obj.rot = a
                    obj.colli = false
                    --setSizeAndColli(obj, s0, s0) --同步一下判定
                    setSize(obj, 0, 0)
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET + 2
                        local t = 20
                        local r, s = r0, s0
                        local dr, ds, x, y, dx, dy = r/t, s/t, obj.x, obj.y, cos(a), sin(a)
                        r = 0
                        for _ = 1, t do
                            obj.hscale, obj.vscale = obj.hscale + ds, obj.vscale + ds
                            r = r + dr
                            obj.x, obj.y = x + r*dx, y + r*dy
                            task.Wait(1)
                        end
                        obj.colli = true
                        task.Wait(dt)
                        task.New(obj, function()
                            task.Wait(15)
                            P.flower_1.attack(obj.x, obj.y, a)
                        end)
                        spSizeAndColliChange(obj, -obj.hscale, 30, 150) --obj, ds, dt, phase
                        Del(obj)
                    end)
                    return obj
                end
                return create
            end
    )

    --苹果
    B.apple = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, type, a, dt)
                    local obj = New(apple, x, y, type)
                    setSizeAndColli(obj, 0.01, 0.01)
                    _connect(_boss, obj, 0, true)
                    task.New(obj, function()
                        spSizeAndColliChange(obj, 0.99, 30, 150)
                        --task.Wait(30)
                        a = -a - 180
                        local r = 200
                        obj.rabbit = E.rabbit.create(min(180, max(-180, 0 + r*cos(a))), max(-100, 200 + r*sin(a)), obj) --兔子与苹果反着生成
                        task.Wait(360 + dt)
                        --苹果变小消失了
                        spSizeAndColliChange(obj, -1, 60, 90)
                        Del(obj)
                    end)
                    return obj
                end
                return create
            end
    )
    --endregion
    --region 子弹发射器定义
    --花瓣散开后
    P.flower_1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = switch1(diff, {
                    1, 1.25, 0, 0, 0
                })*defaultSwitchVelocityByRank(rank)

                local way = switch1(diff, {
                    3, 4, _, _, _
                })
                local sp_w = switch1(diff, {
                    12, 36, _, _, _
                })

                local layer = switch1(diff, {
                    1, 2, _, _, _
                })
                local dv_l = switch1(diff, {
                    0.5, 0.5, 0.5, 0.5, 0.5
                })*defaultSwitchVelocityByRank(rank)
                local style, color = stg.arrow_big, COLOR_RED
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStraight(x, y, v, a, style, color)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_layer2(x, y, v, a, way, sp_w,
                                        layer, dv_l, 0,
                                        bullet_func
                                )
                            end)
                end
                return attack
            end
    )


    --苹果被吃炸了
    P.apple = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = switch1(diff, {
                    1.75, 1.25, 1.25, 1.25, 2
                })*defaultSwitchVelocityByRank(rank)
                local way = switch1(diff, {
                    0, 0, 20, 30, 30
                })
                local layer = switch1(diff, {
                    0, 0, 3, 4, 4
                })
                local dv = switch1(diff, {
                    0.25, 0.25, 0.25, 0.25, 0.35
                })*defaultSwitchVelocityByRank(rank)

                local style, color = stg.ball_mid_c, COLOR_DEEP_RED
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v, a,
                                        way, layer,
                                        dv, 0, 0,
                                        bullet_func
                                )
                            end)
                end
                return attack
            end
    )

    --苹果自然炸了
    P.apple2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = switch1(diff, {
                    1.75, 1.25, 2.25, 2.25, 2
                })*defaultSwitchVelocityByRank(rank)
                local way = switch1(diff, {
                    0, 0, 10, 16, 16
                })
                local layer = switch1(diff, {
                    0, 0, 1, 1, 1
                })
                local dv = switch1(diff, {
                    0.25, 0.25, 0.5, 0.5, 0.35
                })*defaultSwitchVelocityByRank(rank)

                local style, color = stg.ball_mid_c, COLOR_DEEP_RED
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v, a,
                                        way, layer,
                                        dv, 0, 0,
                                        bullet_func
                                )
                            end)
                end
                return attack
            end
    )
    --endregion
    --region Shooter 普通小怪仅作发射子弹的任务

    --endregion
    --region 自定义敌人
    M.rabbitChangeAction = EISlib.Bullet.Shooter.createAction(
            function(diff, rank)
                local function f(self)
                    local x, y = self.x, self.y
                    enemy.createDeath(
                            1, --total_time,
                            function()
                                achi1_flag = false --你动物守护者没了
                                stg.newSimpleStraight(x, y, 0, 0, stg.ball_mid, COLOR_RED)
                            end)
                end

                local death_func = switch1(diff, {
                    nil,
                    nil,
                    f,
                    f,
                    f
                })
                local function main(bow, rabbit)
                    Del(bow) --删除弓
                    if IsValid(rabbit) then
                        enemy.change_style(rabbit, sty.RABBIT_GREEN)
                        enemy.changeDeathFunc(rabbit, death_func)
                        --enemy.setTauntRank(rabbit, boss.class.TAUNT_RANK + 1) --比boss还要优先诱导
                        --行为动作
                        setSizeAndColli(rabbit, 0.01, 0.01)
                        task.New(rabbit, function()
                            local x, y = rabbit.x, rabbit.y
                            local apple = rabbit.apple
                            local a_x, a_y = apple.x, apple.y
                            local a = Angle(rabbit, apple)
                            spSizeAndColliChange(rabbit, 0.99, 30, 150)
                            rabbit.colli = true
                            robject.set_color(rabbit, "", 255, 255, 255, 255)
                            New(target_line, x, y, apple) --拉出预警线
                            --亮表情
                            local e = New(expression, x, y, "love")
                            moveWithTask(e, rabbit, 0, 10) --obj, mst, dx ,dy, t
                            expression.defaultShow(e, 30, 0, 30) --t0, t1, t2
                            --
                            task.Wait(50)
                            for i = 1, 4 do
                                if IsValid(apple) then
                                    halfMoveLengthWithPar(rabbit, x + i/4*(a_x - x), y + i/4*(a_y - y), 0, a + 180, 20, 10, 1, 0) --x, y, vy, a, t0, t1, t2, t3
                                    task.Wait(10)
                                end
                            end
                            --吃到苹果了
                            if IsValid(apple) then
                                achi2_flag = false --你还不够魔鬼
                                P.apple.attack(rabbit.x, rabbit.y, -90)
                                Del(apple)
                            end
                            Del(rabbit)
                        end)
                    end
                end
                return main
            end
    )

    D.death3 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local function main(e)
                    local x, y, dr = e.x, e.y, e.dr
                    enemy.createDeath(
                            1, --total_time,
                            function()
                                EGGlib.ObjectEvent.clearBulletAndLaserInRangeCircle(
                                        x, y, 120 + dr, 2 --x, y, rmax, index
                                )
                            end)
                end
                return main
            end)

    --动物灵->兔子
    E.rabbit = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local hp = switch(rank, {
                    50, 50, 50, 50, 25
                })

                local function f(self)
                    local x, y = self.x, self.y
                    enemy.createDeath(
                            1, --total_time,
                            function()
                                achi1_flag = false --你动物守护者没了
                                stg.newSimpleStraight(x, y, 0, 0, stg.ball_mid, COLOR_RED)
                            end)
                end

                local death_func = switch1(diff, {
                    nil,
                    nil,
                    f,
                    f,
                    f
                })
                local function create(x, y, apple)
                    local obj = New(enemy, x, y, sty.FIRE_GREEN, --style
                            hp, --hp
                            false,  --show_hpbar
                            {0, 0}, --drop
                            true, --no_count
                            f,   --death_func
                            false
                    )
                    obj.show_aura = true
                    obj.colli = false
                    robject.set_color(obj, "", 150, 255, 255, 255)
                    if IsValid(_boss) then
                        _connect(_boss, obj, 0, true) --不传递伤害
                    else
                        Del(obj)
                    end
                    --出现
                    obj.colli = false
                    setSizeAndColli(obj, 0.01, 0.01)
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET + 1
                        spSizeAndColliChange(obj, 0.99, 60, 150)
                    end)
                    obj.apple = apple
                    --兔子行为函数定义在上面，被箭射中的事件中
                    return obj
                end
                return create
            end
    )


    --endregion
    --region 死尸弹

    --endregion
    --region 任务执行器
    --一串藤蔓
    T.vine = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local v = 3
                --周期
                local T = 60
                --振幅
                local A = switch1(diff, {
                    45, 45, 45, 50, 45
                })
                local dp = 360/T
                --事先把要用到的正弦值算好
                local sin_tb = {}
                for i = 1, T do
                    sin_tb[i] = A*sin(dp*i)
                end

                --弹幕片组数
                local count = switch1(diff, {
                    20, 20, 20, 20, 20
                })
                --组与组之间的角度差
                local da_c = switch1(diff, {
                    50, 50, 50, 50, 50
                })

                --一个弹幕片的弹幕数量
                local n = 80/count
                --一个弹幕片最终生成散开的弹幕数量
                local nmax = n - switch1(diff, {
                    2, 1, 1, 0, 0
                })
                --一个弹幕片中每个弹幕的角度差
                local da_n = switch1(diff, {
                    5, 10, 20, 20, 20
                })/(n - 1)
                --弹幕自下而上展开的时间差参数（填0就是全部同时展开）
                local dt = 2
                --藤蔓散开的等待时间
                local wt = switch1(diff, {
                    120, 120, 0, 0, 0
                })
                local function main(b, a, u0)
                    boss.createTasker(b, 0, 224,
                            function(obj)
                                obj.bound = false
                                SetV(obj, v, a)
                                task.New(obj, function()
                                    local da = a - 0
                                    local dx0, dy0 = v*cos(a), v*sin(a)
                                    local dx, dy = tranRot(0, 1, da)
                                    local sin, sin_n, index, isCreate
                                    for i = 0, count - 1 do
                                        for j = 0, n - 1 do
                                            index = i*n + j + 1 --第index发生成的子弹，从1开始
                                            --是否生成散开弹幕检测
                                            if j < nmax then
                                                isCreate = true
                                            else
                                                isCreate = false
                                            end
                                            for u = -1, 1, 2 do
                                                sin = sin_tb[index%T+1]*u
                                                sin_n = sin_tb[(index + 1)%T+1]*u
                                                B.vine.create(obj.x + dx*sin, obj.y + dy*sin, Angle(0, 0, dx0 + dx*(sin_n - sin), dy0 + dy*(sin_n - sin)), --x, y, rot
                                                        wt + 2*(n - 1 - j) + (2*n + dt)*(count - 1 - i), a + (80 + da_c*i + da_n*(j - (n-1)/2))*u0, --dt, a
                                                        isCreate
                                                )
                                            end
                                            task.Wait(2)
                                        end
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --一圈花
    T.flower = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                --多少way花
                local way0 = switch(rank, {
                    3, 3, 3, 3, 5
                })
                local layer = switch1(diff, {
                    3, 3, 3, 3, 3
                })
                local sp = switch1(diff, {
                    170, 170, 0, 0, 00
                })
                local r0 = 60
                local dr = 60

                local wait = 5
                local function main(b, u)
                    boss.createTasker(b, b.x, b.y,
                            function(obj)
                                task.New(obj, function()
                                    local way, da, r, a = way0
                                    for i = 0, layer - 1 do
                                        r = r0 + dr*i
                                        da = sp/(way - 1)
                                        for j = 0, way - 1 do
                                            a = -90 + da*(j - (way - 1)/2)*u + ran:Float(-5, 5)
                                            B.flower.create(0 + r*cos(a), 224 + r*sin(a), a, wait*(way - 1 - j) + (wait*way + 20)*(layer - 1 - i)) --x, y, a, dt
                                            task.Wait(wait)
                                        end
                                        way = way + 1
                                        u = -u
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --一圈苹果
    T.apple = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                --多少way花
                local way0 = switch(rank, {
                    4, 4, 4, 4, 6
                })
                local layer = switch1(diff, {
                    2, 2, 2, 2, 2
                })
                local da = switch1(diff, {
                    30, 30, 30, 30, 30
                })
                local r0 = 120
                local dr = 40

                local wait = 3
                local function main(b, u)
                    local apple_ls = {}
                    boss.createTasker(b, b.x, b.y,
                            function(obj)
                                task.New(obj, function()
                                    local way, r, a = way0
                                    for i = 0, layer - 1 do
                                        r = r0 + dr*i
                                        for j = 0, way - 1 do
                                            a = -90 + da*(j - (way - 1)/2)*u + ran:Float(-5, 5)
                                            table.insert(apple_ls, B.apple.create(0 + r*cos(a), 200 + r*sin(a), "normal", a, wait*(way - 1 - j) + (wait*way + 20)*(layer - 1 - i))) --x, y, a, dt
                                            task.Wait(wait)
                                        end
                                        way = way + 1
                                        u = -u
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                    return apple_ls
                end
                return main
            end)
    --endregion
    --region 组合攻击
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function action(b)
                    b.cast("attack_up_before")
                    task.Wait(32)
                    b.cast("attack_up_ing")
                    task.Wait(12)
                    b.cast("attack_up_after")
                end
                --藤蔓的way数
                local way = switch1(diff, {
                    6, 6, 8, 8, 8
                })
                local da = switch1(diff, {
                    180, 180, 180, 180, 180
                })/(way - 1)
                local main
                if diff < 3 then --EN
                    function main(b, u)
                        local w = (way - 1)/2
                        for i = -w, w do
                            T.vine.main(b, -90 + i*da + ran:Float(-2.5, 2.5), u)
                        end
                        task.Wait(60)
                        T.flower.main(b, u)
                        task.Wait(480)
                    end
                else --HL
                    function main(b, u)
                        local w = (way - 1)/2
                        for i = -w, w do
                            T.vine.main(b, -90 + i*da + ran:Float(-2.5, 2.5), u)
                        end
                        task.Wait(10)
                        local apple_ls = T.apple.main(b, u)
                        task.Wait(76)
                        action(b) --44f
                        for k, apple in pairs(apple_ls) do
                            if IsValid(apple) and IsValid(apple.rabbit) then
                                b.createSpArrow(apple.rabbit, b.x, b.y + 30, 90, COLOR_RED, M.rabbitChangeAction.main)
                            end
                        end
                        task.Wait(270)
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
            for _, v in pairs(P) do
                v.update(difficulty, new_rank)
            end
            for _, v in pairs(S) do
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
            for _, v in pairs(M) do
                v.update(difficulty, new_rank)
            end
            for _, v in pairs(D) do
                v.update(difficulty, new_rank)
            end
            rank = new_rank
        end
    end
    
    local names = {
        "name-boss3-card2-E",
        "name-boss3-card2-N",
        "name-boss3-card2-H",
        "name-boss3-card2-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "spellcard", --类型
            {3, 3, 50}, --时间
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
                if difficulty > 2 then
                    achi1_flag = true
                    achi2_flag = true
                    --成就1无伤判断
                    task.New(b, function()
                        while player.death == 0 do
                            task.Wait(1)
                        end
                        achi1_flag = false
                    end)
                end
                reFresh()
                while true do
                    for u = -1, 1, 2 do
                        reFresh()
                        C.FIRST.main(b, u)
                    end
                end
            end,
            function(b) --finish
                if achi2_flag and b.sc_bonus > 0 then --不仅要满足flag还要满足收卡条件
                    achievement.unlock("s2_sc1", true, true) -- AchievementReminder.unlock("s2_sc1", "谁才是恶魔？")
                end
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard