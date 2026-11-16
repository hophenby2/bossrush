-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage7/spellcard/spell_6.lua" --当前存放目录
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
local setSize = EGGlib.ObjectEvent.setSize
local boss_name = "Lycaropia"  --以boss名来作为其相关素材的前缀
local fog_img = boss_name.."fog"
local boundWait = EGGlib.ObjectEvent.boundWait
local alphaChange = EGGlib.ObjectEvent.alphaChange
local warning_laser = EISlib.Bullet.Laser.warning_laser

local fog = Class(object)
function fog:init(x, y)
    self.x, self.y = x, y
    self.layer = LAYER_ENEMY_BULLET + 10
    self.hscale, self.vscale = 1, 1
    self.rot = 0
    self.omiga = 0
    self.img = fog_img
    self.group = GROUP_INDES
    self.colli = false
    robject.set_color(self, "", 255, 255, 255, 255)
end
function fog:frame()
    task.Do(self)
end
function fog:render()
    EGGlib.RenderEffect.defaultRenderImg(self)
end

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    --遮挡用的沙暴
    B.fog1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local vx = 8
                local vy = -4.5
                local function create(x, y, s, alpha, u)
                    local obj = New(fog, x, y)
                    obj.rot = ran:Float(0, 360)
                    obj.omiga = 0.25*ran:Sign()
                    robject.set_color(obj, "", 0, 235, 157, 92)
                    boundWait(obj, 180)
                    setSize(obj, s, s)
                    velchTask(obj, 0, vx*u, 0, 30)
                    velchTask(obj, 0, vy, 90, 60)
                    task.New(obj, function()
                        local t = 30
                        local d_a = (alpha - obj._a)/t
                        for _ = 1, t do
                            obj._a = obj._a + d_a
                            task.Wait(1)
                        end
                        obj._blend = ""
                        while obj.y > -100 do
                            task.Wait(1)
                        end
                        alphaChange(obj, alpha, 0, 30)
                        _del(obj, false)
                    end)
                end
                return create
            end
    )

    --遮挡用的沙暴
    B.fog3 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local vx = 8
                local vy = 0
                local function create(x, y, s, alpha, u)
                    local obj = New(fog, x, y)
                    obj.rot = ran:Float(0, 360)
                    obj.omiga = 0.25*ran:Sign()
                    robject.set_color(obj, "", 0, 235, 157, 92)
                    boundWait(obj, 180)
                    setSize(obj, s, s)
                    velchTask(obj, 0, vx*u, 0, 30)
                    velchTask(obj, 0, vy, 90, 60)
                    task.New(obj, function()
                        local t = 30
                        local d_a = (alpha - obj._a)/t
                        for _ = 1, t do
                            obj._a = obj._a + d_a
                            task.Wait(1)
                        end
                        obj._blend = ""
                        while obj.y > -100 do
                            task.Wait(1)
                        end
                        alphaChange(obj, alpha, 0, 30)
                        _del(obj, false)
                    end)
                end
                return create
            end
    )

    --沙尘颗粒弹
    B.grain_a1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local d = 15
                local v_rate = 0.06
                local function create(x, y, vx, vy, dt, dv_i)
                    local a = Angle(0, 0, vx, vy)
                    local dx, dy = cos(a), sin(a)
                    local rate = 1 + v_rate*(8 - dv_i) --速度比率
                    local obj = stg.newBullet(x + d*dv_i*dx, y + d*dv_i*dy, stg.grain_a, COLOR_ORANGE-1, true)
                    obj.rot = a
                    task.New(obj, function()
                        task.Wait(dt)
                        PlaySound("kira00")
                        velchTask(obj, 0, vy*rate, 90, 60)
                        velchTask(obj, 0, vx*rate, 0, 60)
                    end)
                end
                return create
            end
    )

    --旋转的沙尘颗粒弹
    B.grain_a2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local d = 15
                local v_rate = 0.075
                local function create(x, y, a, omiga, u, dt, dv_i)
                    local rate = 1 + v_rate*(3 - dv_i) --速度比率
                    local r
                    if rank == 4 then
                        r = 30 + (dv_i - 2)*d
                    else
                        r = 30 + dv_i*d
                    end
                    local obj = stg.newBullet(x + r*cos(a), y + r*sin(a), stg.grain_a, COLOR_ORANGE-1, true)
                    boundWait(obj, 240)
                    obj.rot = a + 90*u
                    task.New(obj, function()
                        task.Wait(dt)
                        PlaySound("kira00")
                        local t = 30
                        local v = 0
                        local dv = 1.25*rate/t
                        local da = 0
                        local d_da = omiga/t
                        for _ = 1, t do
                            v = v + dv
                            r = r + v
                            da = da + d_da
                            a = a + da
                            obj.rot = a + 90*u
                            obj.x, obj.y = x + r*cos(a), y + r*sin(a)
                            task.Wait(1)
                        end
                        for _ = 1, _infinite do
                            r = r + v
                            a = a + da
                            obj.rot = a + 90*u
                            obj.x, obj.y = x + r*cos(a), y + r*sin(a)
                            task.Wait(1)
                        end
                    end)
                end
                return create
            end
    )


    --旋转的然后变向沙尘颗粒弹
    B.grain_a3 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local d = 15
                local v_rate = 0.1
                local function create(x, y, a, omiga, u, dt, dv_i)
                    local rate = 1 + v_rate*(3 - dv_i) --速度比率
                    local r
                    if rank == 4 then
                        r = 30 + (dv_i - 2)*d
                    else
                        r = 30 + dv_i*d
                    end
                    local obj = stg.newBullet(x + r*cos(a), y + r*sin(a), stg.grain_a, COLOR_ORANGE-1, true)
                    boundWait(obj, 240)
                    obj.rot = a + 90*u
                    task.New(obj, function()
                        task.Wait(dt)
                        PlaySound("kira00")
                        local t = 60
                        local v = 0
                        local dv = 1.5*rate/t
                        local da = 0
                        local d_da = omiga/t
                        for _ = 1, t do
                            v = v + dv
                            r = r + v
                            da = da + d_da
                            a = a + da
                            obj.rot = a + 90*u
                            obj.x, obj.y = x + r*cos(a), y + r*sin(a)
                            task.Wait(1)
                        end
                        local t = 60
                        dv = -v/t
                        d_da = -da/t
                        for _ = 1, t do
                            v = v + dv
                            r = r + v
                            da = da + d_da
                            a = a + da
                            obj.rot = a + 90*u
                            obj.x, obj.y = x + r*cos(a), y + r*sin(a)
                            task.Wait(1)
                        end
                        PlaySound("kira00")
                        obj.rot = a
                        velchTask(obj, 0, 2*rate, a, 30)
                    end)
                end
                return create
            end
    )


    --绞肉机
    B.grain_a4 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local d = 15
                local v_rate = 0.1
                local function create(x, y, a, omiga, u, dt, dv_i)
                    local rate = 1 + v_rate*(3 - dv_i) --速度比率
                    local r = 60 + dv_i*d
                    local obj = stg.newBullet(x + r*cos(a), y + r*sin(a), stg.grain_a, COLOR_ORANGE-1, true)
                    boundWait(obj, 420)
                    obj.rot = a + 90*u
                    task.New(obj, function()
                        task.Wait(dt)
                        PlaySound("kira00")
                        local t = 30
                        local v = 0
                        local dv = 1.5*rate/t
                        local da = 0
                        local d_da = omiga/t
                        for _ = 1, t do
                            v = v + dv
                            r = r + v
                            da = da + d_da
                            a = a + da
                            obj.rot = a + 90*u
                            obj.x, obj.y = x + r*cos(a), y + r*sin(a)
                            task.Wait(1)
                        end
                        for _ = 1, _infinite do
                            r = r + v
                            a = a + da
                            obj.rot = a + 90*u
                            obj.x, obj.y = x + r*cos(a), y + r*sin(a)
                            task.Wait(1)
                        end
                    end)
                end
                return create
            end
    )

    --预警线
    B.warning_laser = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a, w)
                    w = w or 5
                    local obj = New(warning_laser,
                            x, y,
                            600, 10, w, w, a, --len, l_t, wide, w_t, a
                            "", Color(255, 255, 0, 0), --blend, color
                            30 --disappear
                    )
                    warning_laser.setTrailLength(obj, 40)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义
    --连续的沙尘弹幕
    P.grain_a1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local vy = -3*defaultSwitchVelocityByRank(rank)
                local vx_range = 0.1*defaultSwitchVelocityByRank(rank)
                local layer = 8
                local function attack(x, y, dt, isWarning)
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                local vx = ran:Float(-0.5*vx_range, 0.5*vx_range)
                                if isWarning then
                                    B.warning_laser.create(x, y, Angle(0, 0, vx, vy))
                                end
                                task.New(obj, function()
                                    for i = 0, layer - 1 do
                                        PlaySound("kira00")
                                        B.grain_a1.create(x, y, vx, vy, dt + (layer - 1 - i), i)
                                        task.Wait(1)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return attack
            end
    )

    --环形沙尘弹幕
    P.grain_a2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local layer = 4 + switch(rank, {
                    0, 0, 0, 0, 4
                })
                local function attack(x, y, a, omiga, u, dt, isWarning)
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                task.New(obj, function()
                                    for i = 0, layer - 1 do
                                        PlaySound("kira00")
                                        B.grain_a2.create(obj.x, obj.y, a + 0*i*u, omiga, u, dt + (layer - 1 - i), i)
                                        task.Wait(1)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return attack
            end
    )

    --环形沙尘弹幕
    P.grain_a3 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local layer = 6 + switch(rank, {
                    0, 0, 0, 0, 4
                })
                local function attack(x, y, a, omiga, u, dt, isWarning)
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                task.New(obj, function()
                                    for i = 0, layer - 1 do
                                        PlaySound("kira00")
                                        B.grain_a3.create(obj.x, obj.y, a + 0*i*u, omiga, u, dt + (layer - 1 - i), i)
                                        task.Wait(1)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return attack
            end
    )

    --绞肉机
    P.grain_a4 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local layer = 6 + switch(rank, {
                    0, 0, 0, 0, 2
                })
                local function attack(x, y, a, omiga, u, dt, isWarning)
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                task.New(obj, function()
                                    for i = 0, layer - 1 do
                                        PlaySound("kira00")
                                        B.grain_a4.create(obj.x, obj.y, a + 0*i*u, omiga*tranU(i), u, dt + (layer - 1 - i), i)
                                        task.Wait(1)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return attack
            end
    )

    P.grain_a5 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local layer = 6 + switch(rank, {
                    0, 0, 0, 0, 2
                })
                local function attack(x, y, a, omiga, u, dt, isWarning)
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                task.New(obj, function()
                                    for i = 0, layer - 1 do
                                        PlaySound("kira00")
                                        B.grain_a4.create(obj.x, obj.y, a + 0*i*u, omiga*tranU(i), u, dt + (layer - 1 - i), i)
                                        B.grain_a4.create(obj.x, obj.y, a + 0*i*u + 180, omiga*tranU(i), u, 13 + dt + (layer - 1 - i), -8 - i)
                                        task.Wait(1)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return attack
            end
    )
    --endregion
    --region 自定义敌人
    --endregion
    --region Tasker 任务执行器
    --从一侧挂沙子弹幕(封死上面）
    T.sandStorm = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local function main(t, y, yrange, u)
                    boss.createTasker(_boss, _boss.x, _boss.y,
                            function(obj)
                                task.New(obj, function()
                                    for i = 1, t/2 do
                                        for _ = 1, 2 do
                                            stg.newStrChV(ran:Float(-224, -180)*u, y + ran:Float(-0.5*yrange, 0.5*yrange), 0, ran:Float(6, 10), 90*(1-u) + ran:Float(-5, 5), 30, 0, stg.ball_mid_c, COLOR_ORANGE, true)
                                        end
                                        stg.newStrChV(ran:Float(-224, -180)*u, y + ran:Float(-0.5*yrange, 0.5*yrange), 0, ran:Float(6, 10), 90*(1-u) + ran:Float(-5, 5), 45, 0, stg.ball_big, COLOR_ORANGE, true)
                                        task.Wait(2)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --生成沙尘暴
    T.fog1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local vy = -4.5*defaultSwitchVelocityByRank(rank)
                local function main(x, y, u)
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                PlaySound("wind02")
                                obj.bound = false
                                velchTask(obj, 0, vy, 90, 60)
                                task.New(obj, function()
                                    T.sandStorm.main(90, 112, 224, u)
                                    while obj.y > -100 do
                                        B.fog1.create(obj.x, obj.y, 1.25, 220, u)
                                        B.fog1.create(obj.x, obj.y, 2.5, 50, u)
                                        task.Wait(8)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --生成沙尘暴2
    T.fog2 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local vy = -4.5*defaultSwitchVelocityByRank(rank)
                local function main(x, y, u)
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                PlaySound("wind02")
                                obj.bound = false
                                T.sandStorm.main(90, 112, 224, u)
                                velchTask(obj, 0, vy, 90, 60)
                                task.New(obj, function()
                                    while obj.y > -50 do
                                        B.fog1.create(obj.x, obj.y, 2, 200, u)
                                        B.fog1.create(obj.x, obj.y, 3.5, 50, u)
                                        task.Wait(8)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --生成沙尘暴3
    T.fog3 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local function main(x, y, u)
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                PlaySound("wind02")
                                obj.bound = false
                                task.New(obj, function()
                                    for _ = 1, 15 do
                                        B.fog3.create(obj.x, obj.y, 2, 250, u)
                                        B.fog3.create(obj.x, obj.y, 3.5, 100, u)
                                        task.Wait(8)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --竖直
    T.grain_a1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local function main(y, n, u)
                    boss.createTasker(_boss, -224*u, y,
                            function(obj)
                                local isWarning = false
                                if n == 20 then
                                    isWarning = true
                                end
                                task.New(obj, function()
                                    if rank == 4 then
                                        n = math.floor(1.2*n)
                                    end
                                    local dx = 500/(n - 1)
                                    local dt = 60 - n
                                    n = (n - 1)/2
                                    for i = -n, n do
                                        P.grain_a1.attack(dx*i, y, dt + n + 1 - i, isWarning)
                                        task.Wait(1)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --环形
    T.grain_a2 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local function main(a, way, sp, u)
                    local x, y = 0, 40
                    local omiga = 1.25
                    local omiga_range = 0.3
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                local isWarning = false
                                task.New(obj, function()
                                    local da = sp/(way - 1)*u
                                    local dt = 60 - way
                                    way = (way - 1)/2
                                    local omiga = omiga*u + ran:Float(-0.5*omiga_range, 0.5*omiga_range)
                                    for i = -way, way do
                                        P.grain_a2.attack(x, y, a + 180 + da*i, omiga, u, dt + way + 1 - i, isWarning)
                                        task.Wait(1)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --环形然后直线
    T.grain_a3 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local function main(a, way, sp, u, t0)
                    local x, y = 0, 40
                    local omiga = 3
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                local isWarning = false
                                task.New(obj, function()
                                    local da = sp/(way - 1)*u
                                    local dt = 60 - way
                                    way = (way - 1)/2
                                    local omiga = omiga*u
                                    for i = -way, way do
                                        P.grain_a3.attack(x, y, a + 180 + da*i, omiga, u, t0 + dt + way + 1 - i, isWarning)
                                        task.Wait(1)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --环形然后直线
    T.grain_a4 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local function main(a, way, sp, u, t0)
                    local x, y = 0, 40
                    local omiga = 3
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                local isWarning = false
                                task.New(obj, function()
                                    local da = sp/(way - 1)*u
                                    local dt = 60 - way
                                    way = (way - 1)/2
                                    local omiga = omiga*u
                                    for i = -way, way do
                                        P.grain_a4.attack(x, y, a + 180 + da*i, omiga, u, t0 + dt + way + 1 - i, isWarning)
                                        task.Wait(1)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    T.grain_a5 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local function main(a, way, sp, u, t0)
                    local x, y = 0, 40
                    local omiga = 3
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                local isWarning = false
                                task.New(obj, function()
                                    local da = sp/(way - 1)*u
                                    local dt = 60 - way
                                    way = (way - 1)/2
                                    local omiga = omiga*u
                                    for i = -way, way do
                                        P.grain_a5.attack(x, y, a + 180 + da*i, omiga, u, t0 + dt + way + 1 - i, isWarning)
                                        task.Wait(1)
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
                local function main(n, u, wait)
                    --预警
                    if n == 20 then
                        tasker(function()
                            local count = 8
                            local y = 100
                            local dy = 200/(count - 1)
                            local c = (count - 1)/2
                            for i = -c, c do
                                for u = -1, 1, 2 do
                                    B.warning_laser.create(-224*u, y + dy*i, 90*(1-u), 20)
                                end
                                task.Wait(2)
                            end
                        end)
                        task.Wait(30)
                    end
                    T.grain_a1.main(200, n, u)
                    task.Wait(60)
                    T.fog1.main(-300*u, 180, u)
                    task.Wait(wait)
                end
                return main
            end)

    C.SECOND = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local a0 = 90
                local a_range = 30
                local way0 = 30
                local dway = 5
                local sp = 320
                local dsp = 5
                local function main(i, u, wait)
                    local a = a0 + ran:Float(0.25*a_range, 0.75*a_range)*u
                    T.grain_a2.main(a, way0 + dway*i, sp + dsp*i, u)
                    task.Wait(60)
                    --预警
                    if i == 0 then
                        tasker(function()
                            local count = 8
                            local y = 100
                            local dy = 200/(count - 1)
                            local c = (count - 1)/2
                            for i = -c, c do
                                for u = -1, 1, 2 do
                                    B.warning_laser.create(-224*u, y + dy*i, 90*(1-u), 20)
                                end
                                task.Wait(2)
                            end
                        end)
                    end
                    task.Wait(60)
                    T.fog2.main(-300*u, 180, u)
                    task.Wait(20)
                    T.fog2.main(300*u, 180, -u)
                    task.Wait(wait)
                end
                return main
            end)

    C.THIRD = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local a0 = 90
                local a_range = switch(rank, {
                    30, 30, 30, 30, 90
                })
                local way0 = 40
                local dway = 5
                local sp = 315
                local dsp = 10
                local function main(i, u, wait)
                    local a = a0 + ran:Float(-0.5*a_range, 0.5*a_range)
                    local way = way0 + dway*i
                    T.grain_a3.main(a, way, sp + dsp*i, u, 30)
                    task.Wait(60)
                    --预警
                    if i == 0 then
                        tasker(function()
                            local count = 8
                            local y = 100
                            local dy = 200/(count - 1)
                            local c = (count - 1)/2
                            for i = -c, c do
                                for u = -1, 1, 2 do
                                    B.warning_laser.create(-224*u, y + dy*i, 90*(1-u), 20)
                                end
                                task.Wait(2)
                            end
                        end)
                    end
                    task.Wait(60)
                    T.fog3.main(-300*u, -100, u)
                    T.sandStorm.main(90, 100, 200, u)
                    task.Wait(20)
                    T.fog3.main(300*u, -100, -u)
                    T.sandStorm.main(90, 100, 200, -u)
                    task.Wait(wait)
                end
                return main
            end)

    C.FORTH = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local a0 = -90
                local a_range = 30
                local way0 = 60
                local sp = 330
                local u = 1
                local t = 60
                local function main()
                    local a = a0 + ran:Float(-0.5*a_range, 0.5*a_range) + ran:Float(-30, 30)
                    T.grain_a4.main(a, way0, sp, u, t + 30)
                    task.Wait(60)
                    --预警
                    tasker(function()
                        local count = 8
                        local y = 50
                        local dy = 200/(count - 1)
                        local c = (count - 1)/2
                        for i = -c, c do
                            for u = -1, 1, 2 do
                                B.warning_laser.create(-224*u, y + 150*u + dy*i, 90*(1-u), 20)
                            end
                            task.Wait(2)
                        end
                    end)
                    task.Wait(t + 60)
                    T.fog3.main(-300*u, 250, u)
                    T.sandStorm.main(120, 200, 150, u)
                    task.Wait(20)
                    T.fog3.main(300*u, -250, -u)
                    T.sandStorm.main(120, -100, 150, -u)
                    task.Wait(70)
                end
                return main
            end)

    C.FIFTH = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local a0 = 90
                local way0 = 80
                local sp = 340
                local u = -1
                local t = 160
                local function main()
                    local a = a0 + 45*ran:Sign()
                    local way = way0
                    T.grain_a5.main(a, way, sp, u, t + 30)
                    task.Wait(120)
                    --预警
                    tasker(function()
                        local count = 8
                        local y = 35
                        local dy = 240/(count - 1)
                        local c = (count - 1)/2
                        for i = -c, c do
                            for u = -1, 1, 2 do
                                B.warning_laser.create(-224*u, y + 65*u + dy*i, 90*(1-u), 20)
                            end
                            task.Wait(2)
                        end
                    end)
                    task.Wait(t)
                    T.fog3.main(-300*u, 150, u)
                    T.sandStorm.main(90, 100, 200, u)
                    task.Wait(20)
                    --T.fog3.main(300*u, 100, -u)
                    T.sandStorm.main(90, -30, 200, u)
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

    local function bossAction(b)
        alphaChange(b, 255, 100, 30, true, false)
    end

    local card = EGGlib.BossCard.createFullCard(
            "name-boss9-card6", --非/符卡名
            "timespell", --类型
            {55, 55, 55}, --时间
            1800, --耐久
            {50, 50}, --掉落
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
                local u
                --四条腿
                for i = 0, 3 do
                    u = tranU(i)
                    reFresh()
                    C.FIRST.main(20 + 5*i, u, 150 - 30*i)
                end
                task.Wait(60)
                PlaySound("tan00")
                b.absorbEffect(b, 60)
                --两条腿
                for i = 0, 3 do
                    u = tranU(i)
                    reFresh()
                    C.SECOND.main(i, u, 120 - 30*i)
                end
                task.Wait(60)
                PlaySound("tan00")
                b.absorbEffect(b, 60)
                --三条腿
                for i = 0, 2 do
                    u = tranU(i)
                    reFresh()
                    C.THIRD.main(i, u, 60)
                end
                task.Wait(60)
                PlaySound("tan00")
                b.absorbEffect(b, 60)
                --最后两波
                C.FORTH.main()
                C.FIFTH.main()
            end,
            function(b) --finish
                item.PlayerBomb.create(b.x, b.y)
                b.colli = true
                b._a = 255
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
