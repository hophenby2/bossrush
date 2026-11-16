-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
--todo achievement 无字天书：不击破任何鬼火的情况下无伤全避这张符卡
local curpath = EISlib.stage.path.."stage3/spellcard/spell_4.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local changeVelocityTask = EGGlib.ObjectEvent.changeVelocityTask
local alpAndSizeCh = EGGlib.ObjectEvent.alphaAndSizeChange
local disapear = EGGlib.ObjectEvent.disappear
local aimToTarget = EGGlib.ObjectEvent.aimToTarget
local aimToPoint = EGGlib.ObjectEvent.aimToPoint
local warning_laser = EISlib.Bullet.Laser.warning_laser
local lead_laser = EISlib.Bullet.Laser.lead_laser
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local move = EGGlib.ObjectEvent.moveToPlayerDefault
local alphaAndSizeChangeTask = EGGlib.ObjectEvent.alphaAndSizeChangeTask
local sty = EISlib.Enemy.Style
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local setSize = EGGlib.ObjectEvent.setSize
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local accDecMoveToPoint = EGGlib.ObjectEvent.accDecMoveToPoint
local Bclass = EISlib.BossDefinition.Eliphia
local defaultRenderAni = EGGlib.RenderEffect.defaultRenderAni
local defaultRenderImg = EGGlib.RenderEffect.defaultRenderImg
local setV = EGGlib.ObjectEvent.setV
local movePointWithPar = EGGlib.ObjectEvent.movePointWithPar
local stop = EGGlib.ObjectEvent.stop
local accDecMoveToPoint = EGGlib.ObjectEvent.accDecMoveToPoint
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli

--杀人书释放时的鬼脸
local rune = Class(object)
function rune:init(x, y)
    self.x, self.y = x, y
    self.layer = LAYER_TOP
    self.img = Bclass.rune_ani
    robject.set_color(self, "", 255, 255, 255, 255)
end
function rune:frame()
    task.Do(self)
end
function rune:render()
    defaultRenderAni(self)
end

local eff = Class(object)
function eff:init(x, y)
    self.x, self.y = x, y
    self.img = Bclass.rune_eff
    robject.set_color(self, "", 255, 255, 255, 255)
end
function eff:frame()
    task.Do(self)
end
function eff:render()
    defaultRenderImg(self)
end

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    local book_inst
    --region Bullet 自定义子弹
    --符文
    B.rune = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y)
                    local obj = New(rune, x, y)
                    robject.set_color(obj, "", 0, 255, 255, 255)
                    setSize(obj, 0, 0)
                    alphaAndSizeChangeTask(obj, 255, 1, 30)
                    task.New(obj, function()
                        velch(obj, 2, 0, 90, 30)
                        B.rune_eff.create(obj.x, obj.y, 0, 1, 6, 255, 255, 0)
                        B.rune_eff.create(obj.x, obj.y, 180, 1, -6, 255, 100, 0)
                        task.Wait(60)
                        alphaAndSizeChangeTask(obj, -255, -1, 30)
                        setV(obj, -1, -90)
                        task.Wait(30)
                        _del(obj, false)
                    end)
                end
                return create
            end
    )

    --符文闪光特效
    B.rune_eff = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, rot, s, omiga, r, g, b)
                    local obj = New(rune, x, y)
                    obj.rot = rot
                    obj.omiga = omiga
                    robject.set_color(obj, "", 0, r, g, b)
                    setSize(obj, s, s)
                    alphaAndSizeChangeTask(obj, 255, 0, 20)
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY - 1
                        task.Wait(60)
                        alphaAndSizeChangeTask(obj, -255, 0, 30)
                        task.Wait(30)
                        _del(obj, false)
                    end)
                end
                return create
            end
    )

    --装饰用光玉粒子
    B.perform_ball_light = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local color = switch1(diff, {
                    COLOR_RED, COLOR_RED, COLOR_CYAN, COLOR_CYAN, COLOR_CYAN
                })
                local function create(x, y)
                    local obj = stg.newSimpleBullet(x, y, stg.ball_light, color)
                    obj.group = GROUP_GHOST
                    setSize(obj, 0.25, 0.25)
                    robject.set_color(obj, "mul+add", 0, 255, 255, 255)
                    task.New(obj, function()
                        obj.layer = LAYER_TOP-1
                        alphaAndSizeChange(obj, 255, 0, 5)
                        alphaAndSizeChange(obj, 0, -0.25, 10)
                        _del(obj, false)
                    end)
                end
                return create
            end
    )

    --拖尾
    B.light = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local color = switch1(diff, {
                    {255, 0, 0}, {255, 0, 0}, {0, 0, 255}, {0, 0, 255}, {255, 255, 0}
                })
                local function create(mst, a)
                    local obj = New(bent_laser_effection, "laser_bent_2", mst.x, mst.y, a,
                            30, 12 --len, wide
                    )
                    robject.set_color(obj, "mul+add", 255, color[1], color[2], color[3])
                    task.New(obj, function()
                        obj.layer = LAYER_TOP - 2
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

    --生成鬼火的弹幕
    B.bullet1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local color = switch1(diff, {
                    COLOR_RED, COLOR_RED, COLOR_BLUE, COLOR_BLUE, no_info
                })
                local create
                if diff < 3 then --EN
                    function create(x, y, a, target_x, target_y, book)
                        local obj = New(enemy,
                                x, y, sty.FIRE_RED, --style
                                999, false, --hp, show_hp
                                system.DROP_NONE, --drop
                                true, --no_count
                                D.death2.main --death_func
                        )
                        _connect(_boss, obj, 0, true)
                        obj.show_aura = true
                        --local obj = stg.newBullet(x, y, stg.ball_light, color)
                        obj.hscale, obj.vscale = 1, 1
                        obj.colli = false
                        robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                        obj.bound = false
                        --运动逻辑
                        task.New(obj, function()
                            local a = Angle(x, y, target_x, target_y)
                            --SetV(obj, 6, a)
                            --task.Wait(10)
                            --velch(obj, 6, 2, a + 180, 10)
                            --stop(obj)
                            movePointWithPar(obj, target_x, target_y, ran:Float(1, 4), 45, ran:Sign())
                            --aimToPoint(obj, target_x, target_y, 0, 60, 0.15, conditionFunc)
                            obj.vx, obj.vy = 0, 0
                            --生成鬼火
                            if IsValid(_boss) then
                                E.enemy2.create(obj.x, obj.y, book)
                            end
                            PlaySound("kira00")
                            D.death1.main(obj, 0, COLOR_DEEP_RED)
                            alphaAndSizeChange(obj, -255, 3, 30)
                            _del(obj, false)
                        end)
                        --拖尾效果
                        B.light.create(obj, 90)
                        task.New(obj, function()
                            obj.layer = LAYER_ENEMY_BULLET - 1
                            while true do
                                B.perform_ball_light.create(obj.x, obj.y)
                                task.Wait(1)
                            end
                        end)
                    end
                else --HL
                    function create(x, y, a, target_x, target_y, book)
                        local obj = New(enemy,
                                x, y, sty.FIRE_BLUE, --style
                                999, false, --hp, show_hp
                                system.DROP_NONE, --drop
                                true, --no_count
                                D.death2.main --death_func
                        )
                        _connect(_boss, obj, 0, true)
                        obj.show_aura = true
                        --local obj = stg.newBullet(x, y, stg.ball_light, color)
                        obj.hscale, obj.vscale = 1, 1
                        obj.colli = false
                        robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                        obj.bound = false
                        --运动逻辑
                        task.New(obj, function()
                            local a = Angle(x, y, target_x, target_y)
                            --SetV(obj, 6, a)
                            --task.Wait(10)
                            --velch(obj, 6, 2, a + 90*ran:Sign(), 10)
                            --stop(obj)
                            movePointWithPar(obj, target_x, target_y, ran:Float(1, 4), 30, ran:Sign())
                            --aimToPoint(obj, target_x, target_y, 0, 60, 0.15, conditionFunc)
                            obj.vx, obj.vy = 0, 0
                            --生成鬼火
                            if IsValid(_boss) then
                                E.enemy2.create(obj.x, obj.y, book)
                            end
                            PlaySound("kira00")
                            D.death2.main(obj)
                            alphaAndSizeChange(obj, -255, 3, 30)
                            _del(obj, false)
                        end)
                        --拖尾效果
                        B.light.create(obj, 90)
                        task.New(obj, function()
                            obj.layer = LAYER_ENEMY_BULLET - 1
                            while true do
                                B.perform_ball_light.create(obj.x, obj.y)
                                task.Wait(1)
                            end
                        end)
                    end
                end
                return create
            end
    )
    --鬼火生成时发出的弹幕
    B.bullet2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local color = switch1(diff, {
                    COLOR_DEEP_RED, COLOR_DEEP_RED, COLOR_DEEP_BLUE, COLOR_DEEP_BLUE, no_info
                })
                local function create(x, y, vx, vy, co)
                    local obj = stg.newBullet(x, y, stg.ball_mid_c, co or color)
                    task.New(obj, function()
                        obj.ax, obj.ay = vx/60, vy/60
                        task.Wait(60)
                        obj.ax, obj.ay = 0, 0
                    end)
                end
                return create
            end
    )

    --鬼火死亡后返回给杀人书的特效
    B.bullet3 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                --判断到达目的地条件
                local function conditionFunc(obj, target)
                    if Dist(obj, target) > 40 then
                        return true
                    else
                        return false
                    end
                end
                local color = switch1(diff, {
                    COLOR_RED, COLOR_RED, COLOR_BLUE, COLOR_BLUE, no_info
                })
                local function create(x, y, book)
                    local obj = stg.newBullet(x, y, stg.ball_light, color)
                    obj.hscale, obj.vscale = 0.4, 0.4
                    obj.colli = false
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    obj.bound = false
                    --运动逻辑
                    task.New(obj, function()
                        --拖影
                        EGGlib.RenderEffect.newTrail(obj, --master,
                                -1, 10, 1, --dlayer, maxnum, frame,
                                obj.img, 1, "mul+add", --img, size, blend,
                                999, 0.75, false --times, _a_rate, Isdsize
                        )
                        if IsValid(book) then
                            SetV(obj, 8, Angle(obj, book) + 180)
                            aimToTarget(obj, book, -2, 60, 0.2, conditionFunc)
                            if IsValid(book) then
                                SetV(obj, 6, Angle(obj, book))
                            end
                            while IsValid(book) and Dist(obj, book) > 5 do
                                task.Wait(1)
                            end
                            obj.vx, obj.vy = 0, 0
                            if IsValid(book) then
                                PlaySound("ding0") --todo 是否再搞一个新的音效？
                                --book.kill_count = book.kill_count + 1
                            end
                            Del(obj)
                        end
                    end)
                end
                return create
            end
    )

    --杀人书发出的星弹
    B.bullet4 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local color = switch1(diff, {
                    COLOR_DEEP_RED, COLOR_DEEP_RED, COLOR_DEEP_BLUE, COLOR_DEEP_BLUE, no_info
                })
                local v0 = switch1(diff, {
                    1.2, 1.3, 1.4, 1.5, no_info
                })*defaultSwitchVelocityByRank(rank)
                local v1 = v0
                local da = switch1(diff, {
                    0, 0, 90, 120, 120
                })
                local function create(x, y, v, a, u, wt)
                    local obj = stg.newSimpleBullet(x, y, stg.star_small, color)
                    obj.omiga = 6
                    obj.bound = false
                    obj.hscale, obj.vscale = 1, 1
                    obj.a, obj.b = obj.a*obj.hscale, obj.b*obj.vscale
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    obj.rot = a
                    task.New(obj, function()
                        velch(obj, v, v0, a, 90, 30)
                        PlaySound("kira00")
                        velch(obj, 0, v1, a + da*u, 60)
                        task.Wait(wt)
                        obj.colli = false
                        disapear(obj, 20)
                        obj.bound = true
                    end)
                end
                return create
            end
    )

    --杀人书发出的激光
    B.bullet5 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local color = switch1(diff, {
                    COLOR_DEEP_RED, COLOR_DEEP_RED, COLOR_DEEP_BLUE, COLOR_DEEP_BLUE, no_info
                })
                local function create(x, y, da)
                    --预警线
                    local obj = New(warning_laser, x, y,
                            450, 10, 1, 5, -90, --len, l_t, wide, w_t, a
                            "mul+add", Color(255, 255, 255, 255), --blend,  color
                            61  --disapear
                    )
                    task.New(obj, function()
                        for x = 1, 90, 3 do
                            EISlib.Bullet.Laser.laser.setRot(obj, -90 + da*sin(x))
                            task.Wait(1)
                        end
                        task.Wait(30)
                        --真激光
                        New(lead_laser, 1, color, obj.x, obj.y, --type, color
                                8, obj.rot, --v, a
                                450, 10, 15, 10, --len, w0, w1, t
                                false, false, 60 --isLock, isShoot, disapear
                        )
                    end)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射器定义
    --鬼火死尸弹
    local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
    P.pointer1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.ball_mid
                local v0 = switch1(diff, {
                    1.25, 1.25, 1.75, 1.5, no_info
                })*defaultSwitchVelocityByRank(rank)
                local dv = switch1(diff, {
                    no_info, 0.5, 0.5, 0.5, no_info
                })
                local layer = switch1(diff, {
                    1, 2, 1, 2, no_info
                })
                local way = switch1(diff, {
                    10, 16, 13, 13, no_info
                })
                local da = 0
                local function attack(x, y, a, u, co)
                    color = co
                    local function bullet_func(x, y, v, a)
                        stg.newSimpleStrChV(x, y, v - 1, v, a, 30, 30, style, color, false, 1)
                    end
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v0, a, way, layer, dv, da*u, 0, bullet_func)
                            end)
                end
                return attack
            end
    )
    --杀人书发激光预警
    P.pointer2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local sp = switch1(diff, {
                    150, 150, 150, 150, no_info
                })
                local way = switch1(diff, {
                    5, 9, 13, 17, no_info
                })
                local function attack(x, y, dway)
                    PlaySound("lazer00")
                    local way0 = way + dway
                    local da = 150/(way0 - 1)
                    way0 = (way0 - 1)/2
                    for i = -way0, way0 do
                        B.bullet5.create(x, y, da*i)
                    end
                end
                return attack
            end
    )
    --杀人书爆炸了
    P.pointer3 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.ball_mid, COLOR_DEEP_PURPLE
                local v0 = switch1(diff, {
                    1, 1, 1, 1, no_info
                })*defaultSwitchVelocityByRank(rank)
                local dv = switch1(diff, {
                    0.6, 0.5, 0.45, 0.4, no_info
                })
                local layer = switch1(diff, {
                    5, 7, 9, 12, no_info
                })
                local way = switch1(diff, {
                    8, 12, 16, 20, no_info
                })
                local wt = switch1(diff, {
                    180, 180, 180, 180, no_info
                })
                local function attack(x, y, u, dway)
                    local function bullet_func(x, y, v, a)
                        B.bullet4.create(x, y, v, a, u, wt)
                        B.bullet4.create(x, y, v, a, -u, wt)
                    end
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v0, -90, way + dway, layer, dv, 0, 0, bullet_func)
                            end)
                end
                return attack
            end
    )
    --endregion
    --region 死尸弹
    --其实这个不算死尸弹
    D.death1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    3, 4, 4, 4, no_info
                })
                local way = switch1(diff, {
                    6, 8, 5, 6, no_info
                })
                local layer = switch1(diff, {
                    1, 1, 2, 2, no_info
                })
                local da = 360/way
                local da_l = da/layer
                --每一个单元朝向的共同速度
                local dvx0 = switch1(diff, {
                    1.5, 1.75, 2, 2.4, no_info
                })*defaultSwitchVelocityByRank(rank)
                local ddvx0_l = switch1(diff, {
                    no_info, no_info, 0.5, 0.5
                })
                --向中间靠拢的速度差（每层）
                local dvy0 = switch1(diff, {
                    -0.1, -0.1, -0.1, -0.12, no_info
                })/1.15*defaultSwitchVelocityByRank(rank)
                --hyper模式下会影响dr使得弹幕变得更加困难
                local dr = switch(rank, {
                    10, 10, 10, 10, 15
                })

                --每颗子弹垂直于移动方向的距离参数
                local dw = switch1(diff, {
                    10, 10, 0, 0, 0
                })
                local main
                if diff < 3 then
                    --a_i参数，填0是奇数狙，填1是偶数狙，默认偶数
                    function main(e, a_i, co)
                        a_i = a_i or 1
                        local x, y, a0 = e.x, e.y, Angle(e, player) + 0.5*da_l*a_i
                        local obj = enemy.createDeath(
                                20, --total_time,
                                function()
                                    local a, r, d, dx, dy, dvx, dvy
                                    for i = 0, count - 1 do
                                        r, d = 20 + dr*i, dw*(count - 1 - i)
                                        for j = 0, way - 1 do
                                            for k = 0, layer  - 1 do
                                                a = a0 + j*da + k*da_l
                                                dx, dy = cos(a), sin(a)
                                                dvx = dvx0 + ddvx0_l*k
                                                dvy = dvy0*(count - 1 - i)
                                                for u = -1, 1, 2 do
                                                    B.bullet2.create(x + r*dx - d*dy*u, y + r*dy + d*dx*u,
                                                            dvx*dx - u*dvy*dy, dvx*dy + u*dvy*dx, co) --vx, vy
                                                end
                                            end
                                        end
                                        task.Wait(1)
                                    end
                                end)
                        obj.group = GROUP_INDES
                    end
                else --HL
                    function main(e, a_i, co)
                        a_i = a_i or 1
                        local x, y, a0 = e.x, e.y, Angle(e, player) + 0.5*da_l*a_i
                        local mst = e.mst
                        --[[if not e.isDel then
                            B.bullet3.create(x, y, mst)
                        end]]
                        local obj = enemy.createDeath(
                                20, --total_time,
                                function()
                                    local a, r, d, dx, dy, dvx, dvy
                                    for i = 0, count - 1 do
                                        r, d = 20 + dr*i, dw*(count - 1 - i)
                                        for j = 0, way - 1 do
                                            for k = 0, layer  - 1 do
                                                a = a0 + j*da + k*da_l
                                                dx, dy = cos(a), sin(a)
                                                dvx = dvx0 + ddvx0_l*k
                                                dvy = dvy0*(count - 1 - i)
                                                for u = -1, 1, 2 do
                                                    B.bullet2.create(x + r*dx - d*dy*u, y + r*dy + d*dx*u,
                                                            dvx*dx - u*dvy*dy, dvx*dy + u*dvy*dx, co) --vx, vy
                                                end
                                            end
                                        end
                                        task.Wait(1)
                                    end
                                end)
                        obj.group = GROUP_INDES
                    end
                end
                return main
            end)
    --鬼火被打爆后会给杀人书叠层数
    D.death2 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local color = switch1(diff, {
                    COLOR_DEEP_BLUE, COLOR_DEEP_BLUE, COLOR_DEEP_RED, COLOR_DEEP_RED, no_info
                })
                local sp = switch(rank, {
                    10, 10, 10, 10, 10
                })/2
                local main
                if diff < 3 then --EN
                    function main(e)
                        PlaySound("kira00")
                        local x, y = e.x, e.y
                        local mst = e.mst
                        local obj = enemy.createDeath(
                                20, --total_time,
                                function()
                                    P.pointer1.attack(x, y, Angle(x, y, player.x, player.y) + ran:Float(-sp, sp), 1, color)
                                end)
                        obj.group = GROUP_INDES
                        if not e.isDel then
                            B.bullet3.create(x, y, mst)
                        end
                    end
                else --HL
                    function main(e)
                        PlaySound("kira00")
                        local x, y = e.x, e.y
                        local obj = enemy.createDeath(
                                20, --total_time,
                                function()
                                    P.pointer1.attack(x, y, Angle(x, y, player.x, player.y) + ran:Float(-sp, sp), 1, color)
                                end)
                        obj.group = GROUP_INDES
                    end
                end
                return main
            end)
    --endregion
    --region 自定义敌人
    --飞出去的魔法书
    local numberDisplayer = Class(object)
    function numberDisplayer:init(book)
        self.book = book
        self.group = GROUP_GHOST
        self.layer = LAYER_ENEMY + 1
    end
    function numberDisplayer:frame()
        if not IsValid(self.book) then
            Del(self)
        end
    end
    function numberDisplayer:render()
        if IsValid(self.book) and self.book.kill_count > 0 then
            local x, y = self.book.x - 8, self.book.y + 25
            RenderTTF('Mono24', string.format("%d", self.book.kill_count), x, y, x, y, 2, Color(255, 255, 255, 255), 'left', 'noclip')
        end
    end
    E.enemy1 = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local function create(b)
                    local obj = b.createBook(b.x, b.y)
                    book_inst = obj
                    obj.mst = b
                    obj.bound = false
                    obj.hscale, obj.vscale = 0, 0
                    obj.a, obj.b = 20, 20
                    obj.kill_count = 0 --杀人书层数
                    obj._a = 0
                    --New(numberDisplayer, obj) --计数器
                    --移动和攻击
                    task.New(obj, function()
                        --透明度变化
                        alphaAndSizeChangeTask(obj, 255, 0.75, 60)
                        obj.colli = true
                        --移动
                        velch(obj, 2, 0, -90, 60, 0)
                        task.Wait(10)
                        obj.class.changeOpenState(obj) --开启书本
                        task.Wait(300)
                        task.MoveTo(obj, obj.x, 180, 60, MOVE_ACC_DEC)
                        --之后合上书本以及放出弹幕的事件在boss身上执行
                    end)
                    --绑定
                    _connect(b, obj, 1, true)
                    return obj
                end
                return create
            end
    )
    --工具人鬼火
    E.enemy2 = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local color = switch1(diff, {
                    COLOR_DEEP_BLUE, COLOR_DEEP_BLUE, COLOR_DEEP_RED, COLOR_DEEP_RED, no_info
                })
                local hp = switch1(diff, {
                    30, 30, 10, 10, 10
                })
                local size = switch1(diff, {
                    1.25, 1.25, 1, 1, 1
                })
                local create
                if diff < 3 then
                    function create(x, y, mst)
                        local obj = New(enemy,
                                x, y, sty.FIRE_RED, --style
                                hp, false, --hp, show_hp
                                system.DROP_NONE, --drop
                                true, --no_count
                                D.death2.main --death_func
                        )
                        obj.show_aura = true
                        robject.set_color(obj, "", 255, 255, 255, 255)
                        obj.mst = mst
                        setSizeAndColli(obj, size, size)
                        --移动
                        task.New(obj, function()
                            obj.layer = LAYER_TOP
                            changeVelocityTask(obj, 0, 0.2, ran:Float(0, 360), 180, 1, 240, false)
                            task.Wait(180)
                            obj.colli = false
                            task.Wait(60)
                            obj.isDel = true --标记不再产生死尸弹
                            D.death2.main(obj)
                            if IsValid(book_inst) then
                                book_inst.kill_count = book_inst.kill_count + 1
                                task.New(obj, function()
                                    while true do
                                        B.perform_ball_light.create(obj.x, obj.y)
                                        task.Wait(1)
                                    end
                                end)
                                alphaAndSizeChangeTask(obj, 0, -obj.hscale, 50)
                                B.light.create(obj, Angle(obj.x, obj.y, book_inst.x, 175))
                                accDecMoveToPoint(obj, book_inst.x, 175, 1, 0, 49)
                            end
                            _del(obj, false) --鬼火一定时间也会自爆，放出死尸弹但不会叠层数
                        end)
                        --绑定
                        _connect(_boss, obj, 0, true)
                    end
                else
                    function create(x, y, mst)
                        local obj = New(enemy,
                                x, y, sty.FIRE_BLUE, --style
                                hp, false, --hp, show_hp
                                system.DROP_NONE, --drop
                                true, --no_count
                                D.death1.main --death_func
                        )
                        obj.show_aura = true
                        robject.set_color(obj, "", 255, 255, 255, 255)
                        obj.mst = mst
                        setSizeAndColli(obj, size, size)
                        --移动
                        task.New(obj, function()
                            obj.layer = LAYER_TOP
                            changeVelocityTask(obj, 0, 0.2, ran:Float(0, 360), 180, 1, 240, false)
                            task.Wait(180)
                            obj.colli = false
                            task.Wait(60)
                            obj.isDel = true --标记不再产生死尸弹
                            D.death1.main(obj, 0, COLOR_DEEP_RED)
                            if IsValid(book_inst) then
                                book_inst.kill_count = book_inst.kill_count + 1
                                task.New(obj, function()
                                    while true do
                                        B.perform_ball_light.create(obj.x, obj.y)
                                        task.Wait(1)
                                    end
                                end)
                                alphaAndSizeChangeTask(obj, 0, -obj.hscale, 50)
                                B.light.create(obj, Angle(obj.x, obj.y, book_inst.x, 175))
                                accDecMoveToPoint(obj, book_inst.x, 175, 1, 0, 49)
                            end
                            _del(obj, false) --鬼火一定时间也会自爆，放出死尸弹但不会叠层数
                        end)
                        --绑定
                        _connect(_boss, obj, 0, true)
                    end
                end
                return create
            end
    )
    --endregion
    --region Tasker 任务执行器
    T.tasker1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local sp = switch1(diff, {
                    120, 120, 180, 180, no_info
                })
                local count = switch1(diff, {
                    4, 4, 9, 9, no_info
                })
                local da = sp/(count - 1)
                --杀人书层数对激光数目的转化率
                local laser_rate = switch1(diff, {
                    1, 2, 0.8, 1, no_info
                })
                --杀人书层数对星弹数目的转化率
                local star_rate = switch1(diff, {
                    3, 6, 1, 1.2, no_info
                })
                local main
                if diff > 2 then --HL有25个
                    local w0 = switch(rank, {
                        0, 0, 0, 0, 1
                    })
                    function main(b, u)
                        boss.createTasker(b, b.x, b.y,
                                function(obj)
                                    obj.group = GROUP_GHOST --不可消
                                    task.New(obj, function()
                                        local book = E.enemy1.create(b) --创建杀人书
                                        local way, ra, rb
                                        --一共20个(+5
                                        for i = 0, 4 do
                                            ra, rb = 120 + 30*(4 - i), 90 + 20*(4 - i)
                                            way = w0 + 2*i
                                            way = (way - 1)/2
                                            for j = -way*u, way*u, u do
                                                B.bullet1.create(b.x, b.y, 90 - j*da, b.x + ra*cos(-90 + da*j), b.y + rb*sin(-90 + da*j) + 10, book)
                                                task.Wait(3)
                                            end
                                        end
                                        task.Wait(240) --等待
                                        if IsValid(book) then
                                            velch(book, 3.5, 0, 90, 60)
                                        end
                                        if IsValid(book) then
                                            B.rune.create(book.x, book.y - 30)
                                            local x, y = book.x, book.y
                                            b.absorbEffect(b, 0, x, y)
                                            P.pointer2.attack(x, y, int(laser_rate*book.kill_count))
                                            task.Wait(60)
                                            b.breakEffect(b, 0, x, y)
                                            P.pointer3.attack(x, y, u, int(star_rate*book.kill_count))
                                            Del(book)
                                        end
                                        Del(obj)
                                    end)
                                end, true)
                    end
                else --EN就10个
                    local w0 = switch(rank, {
                        0, 0, 0, 0, 1
                    })
                    function main(b, u)
                        boss.createTasker(b, b.x, b.y,
                                function(obj)
                                    obj.group = GROUP_GHOST --不可消
                                    task.New(obj, function()
                                        local book = E.enemy1.create(b) --创建杀人书
                                        local way, ra, rb
                                        --一共10个(+4)
                                        for i = 1, 4 do
                                            ra, rb = 120 + 30*(4 - i), 90 + 20*(4 - i)
                                            way = w0 + i
                                            way = (way - 1)/2
                                            for j = -way*u, way*u, u do
                                                B.bullet1.create(b.x, b.y, 90 - j*da, b.x + ra*cos(-90 + da*j), b.y + rb*sin(-90 + da*j) + 10, book)
                                                task.Wait(3)
                                            end
                                        end
                                        task.Wait(240) --等待
                                        if IsValid(book) then
                                            velch(book, 3.5, 0, 90, 60)
                                        end
                                        if IsValid(book) then
                                            B.rune.create(book.x, book.y - 30)
                                            local x, y = book.x, book.y
                                            b.absorbEffect(b, 0, x, y)
                                            P.pointer2.attack(x, y, int(laser_rate*book.kill_count))
                                            task.Wait(60)
                                            b.breakEffect(b, 0, x, y)
                                            P.pointer3.attack(x, y, u, int(star_rate*book.kill_count))
                                            Del(book)
                                        end
                                        Del(obj)
                                    end)
                                end, true)
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
                if rank < 4 then
                    function main(b, u)
                        T.tasker1.main(b, u)
                        task.Wait(60)
                    end
                else
                    function main(b, u)
                        T.tasker1.main(b, u)
                        task.Wait(60)
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

    local function doubleAchievement(b)
        if system.isDoubleGetSpellCardBonus(b) then
            --[[local achi_func = switch1(difficulty, {
                function()
                    AchievementReminder.unlock("s3_sc4", "三女巫:Easy", "成功双倍收取玛修的符卡「黑暗封印」/「梅贾的窃魂卷」")
                end,
                function()
                    AchievementReminder.unlock("s3_sc4", "三女巫:Easy", "成功双倍收取玛修的符卡「黑暗封印」/「梅贾的窃魂卷」")
                    AchievementReminder.unlock("s3_sc4", "三女巫:Normal", "成功双倍收取玛修的符卡「黑暗封印」/「梅贾的窃魂卷」")
                end,
                function()
                    AchievementReminder.unlock("s3_sc4", "三女巫:Easy", "成功双倍收取玛修的符卡「黑暗封印」/「梅贾的窃魂卷」")
                    AchievementReminder.unlock("s3_sc4", "三女巫:Normal", "成功双倍收取玛修的符卡「黑暗封印」/「梅贾的窃魂卷」")
                    AchievementReminder.unlock("s3_sc4", "三女巫:Hard", "成功双倍收取玛修的符卡「黑暗封印」/「梅贾的窃魂卷」")
                end,
                function()
                    AchievementReminder.unlock("s3_sc4", "三女巫:Easy", "成功双倍收取玛修的符卡「黑暗封印」/「梅贾的窃魂卷」")
                    AchievementReminder.unlock("s3_sc4", "三女巫:Normal", "成功双倍收取玛修的符卡「黑暗封印」/「梅贾的窃魂卷」")
                    AchievementReminder.unlock("s3_sc4", "三女巫:Hard", "成功双倍收取玛修的符卡「黑暗封印」/「梅贾的窃魂卷」")
                    AchievementReminder.unlock("s3_sc4", "三女巫:Lunatic", "成功双倍收取玛修的符卡「黑暗封印」/「梅贾的窃魂卷」")
                end,
            })
            if achi_func then
                achi_func()
            end]]
            achievement.unlock("s3_sc4", true, true)
        end
    end
    
    local names = {
        "name-boss4-card4-E",
        "name-boss4-card4-N",
        "name-boss4-card4-H",
        "name-boss4-card4-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "spellcard", --类型
            {3, 3, 60}, --时间
            1800, --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                task.Wait(120) --停滞一会儿，让玩家有时间收道具
                task.MoveTo(b, 0, 144, 60, MOVE_ACC_DEC)
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 144
                boss.show_aura(b, true)
            end,
            function(b) --main
                while true do
                    for u = -1, 1, 2 do
                        reFresh()
                        C.FIRST.main(b, u)
                        b.absorbEffect(b, 60)
                    end
                end
            end,
            function(b) --finish
                doubleAchievement(b)
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard