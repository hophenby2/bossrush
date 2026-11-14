-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage6/spellcard/spell_2.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local tranRot = EGGlib.Math.TranRot
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local sizeAndColliChange = EGGlib.ObjectEvent.sizeAndColliChange
local spSizeAndColliChange = EGGlib.ObjectEvent.spSizeAndColliChange
local appearByAlphaTask = EGGlib.ObjectEvent.appearByAlphaTask
local lead_laser = EISlib.Bullet.Laser.lead_laser
local warning_laser = EISlib.Bullet.Laser.warning_laser
local laser = EISlib.Bullet.Laser.laser
local sty = EISlib.Enemy.Style
local allEnemyAndNontjtDo = EGGlib.ObjectEvent.allEnemyAndNontjtDo
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local sect_layer1 = EGGlib.BulletGroup.Sector.layer1
local BS = EISlib.Bullet.Shooter
local boundWait = EGGlib.ObjectEvent.boundWait
local simPar = EGGlib.ObjectEvent.simPar
local expression = EISlib.Effect.expression
local alphaChange = EGGlib.ObjectEvent.alphaChange
local velch = EGGlib.ObjectEvent.velocityChange
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local alpAndSizeCh = EGGlib.ObjectEvent.alphaAndSizeChange
local disapear = EGGlib.ObjectEvent.disappear

--剑拖影
local swordLight = Class(laser_bent)
function swordLight:init(mst, dr, u, len, wide)
    if IsValid(mst) then
        local a = mst.rot + 90*u
        self._da = 90*u
        self.getPos = function()
            local dx, dy = tranRot(dr, 0, -5*u + mst.rot - 0)
            return dx, dy
        end
        local dx, dy = self.getPos()
        laser_bent.init(self, 1, mst.x + dx, mst.y + dy, len, wide, "Sonia_sword_light", 0)
        self.rot = a
        self.alpha = 1
        self.group = GROUP_GHOST -- 特效用曲线激光
        self.colli = false -- 特效用曲线激光
        self.bound = false
        self.mst = mst
        self.release = false
        robject.set_color(self, "mul+add", 255, 255, 255, 255)
    else
        self.status = "del"
    end
end
function swordLight:frame()
    if not self.release then
        if IsValid(self.mst) then
            local dx, dy = self.getPos()
            self.rot = self.mst.rot + self._da
            self.x, self.y = self.mst.x + dx, self.mst.y + dy
        end
    elseif self.alpha > 0 then
        self.alpha = max(0, self.alpha - 0.025)
    else
        self.status = "del"
    end

    if self.timer > 60 then
        self.bound = true
    end
    laser_bent.frame(self)
end

--剑
local sword = Class(object)
function sword:init(x, y)
    self.img = "Sonia_sword"
    self.x, self.y = x, y
    self.layer = LAYER_PLAYER - 1
    robject.set_color(self, "", 255, 255, 255, 255)
end
function sword:frame()
    if self.status == "normal" then
        task.Do(self)
    end
end
function sword:render()
    EGGlib.RenderEffect.defaultRenderImg(self)
end
function sword:createLight(u, start_r, add_r)
    if difficulty < 3 then
        for i = 0, 3 do
            local obj = New(swordLight, self, start_r + add_r*i*self.hscale, u, 20 + 20*i, 30 + 30*(3-i)) --mst, dr, u, len, wide
            task.New(obj, function()
                local t = 30
                local l0 = obj.l
                local dl = -l0/t
                while l0 + dl > 2 do
                    l0 = l0 + dl
                    obj.l = math.ceil(l0)
                    task.Wait(1)
                end
                obj.status = 'del'
            end)
        end
    else
        for i = 0, 3 do
            local obj = New(swordLight, self, start_r + add_r*i*self.hscale, u, 20 + 20*i, 30 + 30*(3-i)) --mst, dr, u, len, wide
            task.New(obj, function()
                task.Wait(60)
                local t = 30
                local l0 = obj.l
                local dl = -l0/t
                while l0 + dl > 2 do
                    l0 = l0 + dl
                    obj.l = math.ceil(l0)
                    task.Wait(1)
                end
                obj.status = 'del'
            end)
        end
    end
end

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    --刀
    B.bullet1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, v, a)
                    local obj = stg.newSimpleBullet(x, y, stg.knife, COLOR_RED)
                    boundWait(obj, 120)
                    robject.set_color(obj, "", 0, 255, 255, 255)
                    --obj.colli = false
                    obj.rot = a
                    setSizeAndColli(obj, 3, 3)
                    task.New(obj, function()
                        appearByAlphaTask(obj, 45, true) --obj, t, isnChangeColli
                        sizeAndColliChange(obj, -2, 45)
                        --obj.colli = true
                    end)
                    velchTask(obj, -0.125*v, v, a, 30, 60)
                end
                return create
            end
    )

    --垂直掉落的弹幕
    B.bullet2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, v, va, acc, style, color)
                    local obj = stg.newBullet(x, y, style, color)
                    boundWait(obj, 180)
                    simPar(obj, v, va, acc, -90) --obj, v, va, acc, acca
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET - 1
                    end)
                    return obj
                end
                return create
            end
    )

    B.warning_laser1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local w = switch1(diff, {
                    5, 5, 20, 20, 20
                })
                local t = switch1(diff, {
                    40, 40, 60, 60, 60
                })
                local function create(x, y, len, rot)
                    local obj = New(warning_laser,
                            x, y,
                            len, 20, --len, l_t
                            w, 10, --wide, w_t
                            rot,
                            "mul+add", Color(150, 255, 0, 0), t)
                    warning_laser.setTrailLength(obj, 20)
                    warning_laser.setHeadLength(obj, 20)
                    obj.bound = false
                    --warning_laser.setAlpha(obj, 0.5)
                end
                return create
            end
    )

    B.laser1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(mst, len, u)
                    local obj = New(lead_laser,
                            1, COLOR_RED, --_type, color,
                            mst.x, mst.y, 50, mst.rot, --x, y, v, rot,
                            len, 60, 60, 1, --L, w0, w1, t,
                            true, false, 60--islocked, isshoot, left_time
                    )
                    obj.bound = false
                    obj._blend = ""
                    obj.hide = true --要显示实际判定把这个取消掉就行
                    laser.setMaxLength(obj, 1, 0)
                    laser.setMaxLength(obj, 2, len)
                    laser.setMaxLength(obj, 3, 0)
                    task.New(obj, function()
                        while IsValid(mst) do
                            obj.x, obj.y = mst.x, mst.y
                            laser.setRot(obj, mst.rot)
                            task.Wait(1)
                        end
                        Del(obj)
                    end)
                    --撵走小怪
                    if diff == 4 then
                        task.New(obj, function()
                            while true do
                                allEnemyAndNontjtDo(
                                        function(enemy)
                                            if enemy.canRemove and laser.colliOther(obj, enemy) then --某些倒霉蛋会被扫出屏幕xxxx
                                                enemy.omiga = 12
                                                SetV(enemy, 10, obj.rot + 110*u)
                                                obj.canRemove = false
                                            end
                                        end
                                )
                                task.Wait(1)
                            end
                        end)
                    end
                end
                return create
            end
    )

    --剑挥一圈
    B.sword1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local create
                if diff < 3 then --EN
                    function create(mst, r0, u)
                        PlaySound("wind")
                        local a = 90 - (60 + ran:Float(-15, 15))*u
                        local dr = 16
                        local dx, dy = tranRot(dr, 0, a)
                        local obj = New(sword, mst.x + dx, mst.y + dy)
                        robject.set_color(obj, "", 150, 255, 255, 255)
                        EGGlib.RenderEffect.newTrail(
                                obj, -1, 24, 1, --master, dlayer, maxnum, frame,
                                obj.img, 1, "mul+add", --img, size, blend,
                                999, 0.5, false, 0.1, true, --times, _a_rate, Isdsize, size_min, Isdalpha
                                {255, 255, 255}, {255, 0, 0}
                        )
                        _connect(_boss, obj, 0, true)
                        obj.rot = a
                        setSizeAndColli(obj, 0.25, 0.25*u)
                        --位置更新
                        task.New(obj, function()
                            while IsValid(mst) do
                                dx, dy = tranRot(dr, 0, obj.rot)
                                obj.x, obj.y = mst.x + dx, mst.y + dy
                                task.Wait(1)
                            end
                            obj.status = 'del'
                        end)
                        --角度更新
                        task.New(obj, function()
                            obj.length = 50
                            --简单挥一下
                            local t = 24
                            B.laser1.create(obj, obj.length, -u) --产生判定体激光（被隐藏
                            sword.createLight(obj, u, 90, 45) --产生拖尾
                            T.tasker1.main(obj, r0, a, -u) --产生刀弹
                            local a = obj.rot
                            local x0, dx0 = -90, 180/t
                            for _ = 1, t do
                                x0 = x0 + dx0
                                obj.rot = a - u*270*0.5*(1 + sin(x0))
                                task.Wait(1)
                            end
                            --缩回去
                            alphaChange(obj, obj._a, 0, 10)
                            _del(obj, false)
                        end)
                    end
                elseif diff == 3 then --H
                    function create(mst, u)
                        local a = 90 - 45*u
                        local dr = 16
                        local dx, dy = tranRot(dr, 0, a)
                        local obj = New(sword, mst.x + dx, mst.y + dy)
                        _connect(_boss, obj, 0, true)
                        obj.rot = a
                        setSizeAndColli(obj, 0.01, 0.01*u)
                        --位置更新
                        task.New(obj, function()
                            while IsValid(mst) do
                                dx, dy = tranRot(dr, 0, obj.rot)
                                obj.x, obj.y = mst.x + dx, mst.y + dy
                                task.Wait(1)
                            end
                            obj.status = 'del'
                        end)

                        --角度更新
                        task.New(obj, function()
                            --变出来
                            spSizeAndColliChange(obj, 0.74, 60, 135) --obj, ds, dt, phase
                            obj.length = 200
                            --匀速
                            local t = 30
                            local drot = 45/(1.5*t)*u
                            for _ = 1, t do
                                obj.rot = obj.rot + drot
                                task.Wait(1)
                            end
                            --减速
                            t = 30
                            local d_drot = -drot/t
                            for _ = 1, t do
                                drot = drot + d_drot
                                obj.rot = obj.rot + drot
                                task.Wait(1)
                            end
                            --闪出预警
                            t = 30
                            local count = 5
                            local wait = t/count
                            local dx = 192/(count - 1)
                            for i = 0, count - 1 do
                                B.warning_laser1.create((192 - dx*i)*u, 245, 600, -90) --x, y, len, rot
                                task.Wait(wait)
                            end
                            task.Wait(30)
                            --P.pointer3.attack(mst.x, mst.y, Angle(mst, player), u)
                            --刀平放
                            PlaySound("sword02")
                            B.laser1.create(obj, obj.length, -u) --产生判定体激光（被隐藏
                            sword.createLight(obj, u, 90, 45) --产生拖尾
                            T.tasker1.main(obj, u) --产生刀弹
                            --匀速
                            t = 15
                            local drot = -90/(1.5*t)*u
                            for _ = 1, t do
                                obj.rot = obj.rot + drot
                                task.Wait(1)
                            end
                            --减速
                            d_drot = -drot/t
                            for _ = 1, t do
                                drot = drot + d_drot
                                obj.rot = obj.rot + drot
                                task.Wait(1)
                            end
                            task.Wait(60)
                            --缩回去
                            spSizeAndColliChange(obj, -0.75, 60, 90) --obj, ds, dt, phase
                            _del(obj, false)
                        end)
                    end
                elseif diff == 4 then --L
                    function create(mst, a, u)
                        local dr = 16
                        local dx, dy = tranRot(dr, 0, a)
                        local obj = New(sword, mst.x + dx, mst.y + dy)
                        _connect(_boss, obj, 0, true)
                        obj.rot = a
                        setSizeAndColli(obj, 0.01, 0.01*u)
                        --位置更新
                        task.New(obj, function()
                            while IsValid(mst) do
                                dx, dy = tranRot(dr, 0, obj.rot)
                                obj.x, obj.y = mst.x + dx, mst.y + dy
                                task.Wait(1)
                            end
                            obj.status = 'del'
                        end)
                        --角度更新
                        task.New(obj, function()
                            --变出来
                            spSizeAndColliChange(obj, 0.74, 60, 135) --obj, ds, dt, phase
                            obj.length = 200
                            --匀速
                            local t = 30
                            local drot = 45/t*u
                            for _ = 1, t do
                                obj.rot = obj.rot + drot
                                task.Wait(1)
                            end
                            --减速
                            t = 30
                            local d_drot = -drot/t
                            for _ = 1, t do
                                drot = drot + d_drot
                                obj.rot = obj.rot + drot
                                task.Wait(1)
                            end
                            --闪出预警
                            t = 30
                            local da, a = 360/t
                            for i = 1, t do
                                a = obj.rot - da*i*u
                                B.warning_laser1.create(mst.x + dr*cos(a), mst.y + dr*sin(a), obj.length, a) --x, y, len, rot
                                task.Wait(1)
                            end
                            task.Wait(30)
                            P.pointer3.attack(mst.x, mst.y, Angle(mst, player), u)
                            --刮一圈
                            PlaySound("sword02")
                            t = 60
                            B.laser1.create(obj, obj.length, -u) --产生判定体激光（被隐藏
                            sword.createLight(obj, u, 90, 45) --产生拖尾
                            T.tasker1.main(obj, t, 130*u, -u) --产生刀弹
                            local a = obj.rot
                            local x0, dx0 = -90, 180/t
                            for _ = 1, t do
                                x0 = x0 + dx0
                                obj.rot = a - u*360*0.5*(1 + sin(x0))
                                task.Wait(1)
                            end
                            --缩回去
                            spSizeAndColliChange(obj, -0.75, 60, 90) --obj, ds, dt, phase
                            _del(obj, false)
                        end)
                    end
                end
                return create
            end
    )

    --没想到吧，还能倒着用
    B.sword2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(mst, a, u)
                    local dr = 30
                    local dx, dy = tranRot(dr, 0, a)
                    local obj = New(sword, mst.x + dx, mst.y + dy)
                    _connect(_boss, obj, 0, true)
                    obj.bound = false
                    obj.rot = a
                    local da = 0
                    setSizeAndColli(obj, 0.01, -0.01*u)
                    --角度更新
                    task.New(obj, function()
                        --变出来
                        spSizeAndColliChange(obj, 0.74, 60, 135) --obj, ds, dt, phase
                        obj.length = 250
                        --匀速
                        local t = 30
                        local drot = 45/t*u
                        local d_da = -180/t*u
                        local d_dr = (obj.length - dr)/t
                        for _ = 1, t do
                            obj.rot = obj.rot + drot - d_da
                            da = da + d_da
                            dr = dr + d_dr
                            task.Wait(1)
                        end
                        --减速
                        t = 30
                        local d_drot = -drot/t
                        for _ = 1, t do
                            drot = drot + d_drot
                            obj.rot = obj.rot + drot
                            task.Wait(1)
                        end
                        --闪出预警
                        t = 30
                        local da, da0, a = 360/t, da
                        for i = 1, t do
                            a = obj.rot - da*i*u + da0
                            B.warning_laser1.create(mst.x + obj.length*cos(a), mst.y + obj.length*sin(a), 125, a + 180) --x, y, len, rot
                            task.Wait(1)
                        end
                        task.Wait(30)
                        --刮一圈
                        PlaySound("sword02")
                        t = 60
                        B.laser1.create(obj, 125, -u) --mst, len
                        sword.createLight(obj, -u, 75, -75/3)
                        T.tasker2.main(obj, mst.x, mst.y, t, 130*u, -u) --产生刀弹
                        local a = obj.rot
                        local x0, dx0 = -90, 180/t
                        for _ = 1, t do
                            x0 = x0 + dx0
                            obj.rot = a - u*360*0.5*(1 + sin(x0))
                            task.Wait(1)
                        end
                        --缩回去
                        spSizeAndColliChange(obj, -0.75, 60, 90) --obj, ds, dt, phase
                        _del(obj, false)
                    end)
                    --位置更新
                    task.New(obj, function()
                        while IsValid(mst) do
                            dx, dy = tranRot(dr, 0, obj.rot + da)
                            obj.x, obj.y = mst.x + dx, mst.y + dy
                            task.Wait(1)
                        end
                        obj.status = 'del'
                    end)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义
    --扫出的规则刀弹
    P.pointer1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = switch1(diff, {
                    1.5, 1.5, 1.5, 2, 2
                })*defaultSwitchVelocityByRank(rank)
                local dv = switch1(diff, {
                    1.5, 1.5, 0.5, 0.75, 0.75
                })*defaultSwitchVelocityByRank(rank)
                local layer = switch1(diff, {
                    2, 2, 2, 4, 4
                })
                local way = switch1(diff, {
                    5, 6, 3, 6, 6
                })
                local da_w = switch1(diff, {
                    20, 60, 30, 12, 12
                })
                local da_l = 0
                local style, color = stg.knife, COLOR_RED
                local function bullet_func(x, y, v, a)
                    if diff < 3 then
                        stg.newSimpleStraight(x, y, v, a, style, color)
                    else
                        B.bullet1.create(x, y, v, a)
                    end

                end
                local function attack(x, y, a)
                    PlaySound("kira00")
                    sect_layer1(
                            x, y, v, a, way, da_w,
                            layer, dv, da_l,
                            bullet_func
                    )
                end
                return attack
            end
    )

    --扫出的规则刀弹2
    P.pointer2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = switch1(diff, {
                    4, 4, 4, 4, 4
                })*defaultSwitchVelocityByRank(rank)
                local dv = switch1(diff, {
                    0.2, 0.2, 0.2, 0.2, 0.2
                })*defaultSwitchVelocityByRank(rank)
                local layer = switch1(diff, {
                    1, 2, 3, 4, 4
                }) + switch(rank, {
                    0, 0, 0, 0, 1
                })
                local way = switch1(diff, {
                    1, 2, 3, 6, 6
                })
                local da_w = 20
                local da_l = 0
                local style, color = stg.knife, COLOR_RED
                local function bullet_func(x, y, v, a)
                    B.bullet1.create(x, y, v, a)
                end
                local function attack(x, y, a)
                    PlaySound("kira00")
                    sect_layer1(
                            x, y, v, a, way, da_w,
                            layer, dv, da_l,
                            bullet_func
                    )
                end
                return attack
            end
    )

    --护身中玉
    P.pointer3 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = switch1(diff, {
                    12, 16, 0, 24, 24
                }) + switch(rank, {
                    0, 0, 0, 0, 0
                })
                local layer = switch1(diff, {
                    3, 6, 0, 6, 4
                })
                local v0 = switch1(diff, {
                    1, 1, 3.75, 3.75, 3.75
                })*defaultSwitchVelocityByRank(rank)
                local dv = switch1(diff, {
                    0.5, 0.25, -0.25, -0.25, -0.25
                })*defaultSwitchVelocityByRank(rank)
                local da = switch1(diff, {
                    180/way, 180/way, 360/way/layer, 360/way/layer
                })
                local style, color = stg.ball_big, COLOR_RED
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, v0, v, a, 30, 20, style, color)
                end
                local function attack(x, y, a, u)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(
                                        x, y, v0, a, way,
                                        layer, dv, da*u, 0,
                                        bullet_func)
                                --还能再加一层
                                if diff > 2 and system.PowerRank.getRank() == 4 then
                                    circle_layer1(
                                            x, y, v0, a, way,
                                            layer, -dv, da*u, 0,
                                            bullet_func)
                                end
                            end)
                end
                return attack
            end
    )

    --扫出来的大玉等杂乱的子弹
    P.pointer4 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                --中玉的数目
                local count1 = switch1(diff, {
                    10, 10, 10, 10, 10
                })
                --小玉的数目
                local count2 = switch1(diff, {
                    20, 20, 20, 20, 20
                })
                local style, color = stg.arrow_big, COLOR_RED
                local v = switch1(diff, {
                    2.25, 2.5, 2.75, 3, 3
                })*defaultSwitchVelocityByRank(rank)
                local acc = 0.0475*defaultSwitchVelocityByRank(rank)
                local function attack(x, y, a)
                    PlaySound("tan00")
                    --生成大玉
                    robject.set_color(B.bullet2.create(x, y, v, a, acc, stg.ball_huge, COLOR_RED), "mul+add", 255, 255, 255, 255)
                    local obj
                    for _ = 1, count1 do
                        obj = B.bullet2.create(x, y, v, a, acc, stg.ball_big, COLOR_RED)
                        obj.vx = ran:Float(-0.05, 0.05)
                        obj.vy = obj.vy + ran:Float(0.1, 1.5)
                    end
                    for _ = 1, count2 do
                        obj = B.bullet2.create(x, y, v, a, acc, stg.ball_mid, COLOR_DEEP_RED)
                        obj.vx = ran:Float(-0.1, 0.1)
                        obj.vy = obj.vy + ran:Float(0.1, 2)
                    end
                end
                return attack
            end
    )

    --扫出来的大玉等杂乱的子弹
    P.pointer5 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                --中玉的数目
                local count1 = switch1(diff, {
                    10, 10, 10, 15, 15
                })
                --小玉的数目
                local count2 = switch1(diff, {
                    20, 20, 20, 30, 30
                })
                local style, color = stg.arrow_big, COLOR_RED
                local v = switch1(diff, {
                    2.25, 2.5, 2.75, 3, 3
                })*defaultSwitchVelocityByRank(rank)
                local acc = 0.0475*defaultSwitchVelocityByRank(rank)
                local function attack(x, y, a)
                    PlaySound("tan00")
                    --生成大玉
                    robject.set_color(B.bullet2.create(x, y, v, a, acc, stg.ball_huge, COLOR_RED), "mul+add", 255, 255, 255, 255)
                    local obj
                    for _ = 1, count1 do
                        obj = B.bullet2.create(x, y, v, a, acc, stg.ball_big, COLOR_RED)
                        obj.vx = obj.vx + ran:Float(-0.5, 0.5)
                        obj.vy = obj.vy + ran:Float(0, 1.5)
                    end
                    for _ = 1, count2 do
                        obj = B.bullet2.create(x, y, v, a, acc, stg.ball_mid, COLOR_DEEP_RED)
                        obj.vx = obj.vx + ran:Float(-0.5, 0.5)
                        obj.vy = obj.vy + ran:Float(0, 2)
                    end
                end
                return attack
            end
    )

    --小妖精发的弹幕
    P.enemy1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.ball_mid_c, COLOR_DEEP_RED
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color)
                end
                local attack
                if diff < 3 then
                    local v = 1.5*defaultSwitchVelocityByRank(rank)
                    local way = 1 + switch(rank, {
                        0, 0, 0, 0, 1
                    })
                    local da_w = switch1(diff, {
                        2.5, 5, 0, 0, 0
                    })
                    local function bullet_func(x, y, v, a)
                        stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color)
                    end
                    function attack(x, y, a)
                        for i = 1, 3 do
                            sect_layer1(
                                    x, y, v, a + 120*i, way, da_w,
                                    1, 0, 0,
                                    bullet_func
                            )
                        end
                    end
                elseif diff == 3 then
                    local way = 10
                    local v = 1.5*defaultSwitchVelocityByRank(rank)
                    function attack(x, y, a)
                        circle_layer1(
                                x, y, v, a, way,
                                1, 0, 0, 0,
                                bullet_func)
                    end
                elseif diff == 4 then
                    --谁不想当一个混吃等死的废物呢？.jpg
                    function attack(x, y, a)
                    end
                end
                return attack
            end
    )

    P.enemy2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.ball_mid_c, COLOR_DEEP_RED
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color)
                end
                local attack
                if diff < 3 then
                    function attack(x, y, a)
                    end
                elseif diff == 3 then
                    local way = 16
                    local v = 1.5*defaultSwitchVelocityByRank(rank)
                    local dv = 0.25*defaultSwitchVelocityByRank(rank)
                    local layer = 2
                    function attack(x, y, a)
                        circle_layer1(
                                x, y, v, a, way,
                                layer, dv, 0, 0,
                                bullet_func)
                    end
                elseif diff == 4 then
                    --谁不想当一个混吃等死的废物呢？.jpg
                    function attack(x, y, a)
                    end
                end
                return attack
            end
    )
    --endregion
    --region 自定义敌人
    --小妖精
    E.enemy1 = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local function create(x, y, a, dy)
                    local obj = New(enemy, x, y, sty.FAIRY_SMALL_6_RED, --style
                            100, --hp
                            false,  --show_hpbar
                            {0, 0}, --drop
                            true, --no_count
                            nil, --death_func
                            false --type
                    )
                    _connect(_boss, obj, 0, true)
                    obj.colli = false
                    obj.canRemove = true --代表可以被撵走
                    task.New(obj, function()
                        local v = dy/60
                        velch(obj, v, 0, 90, 60, 30)
                    end)
                    T.enemy1.main(obj, a)
                    return obj
                end
                return create
            end
    )

    --中妖精
    E.enemy2 = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local function create(x, y, a, dx)
                    local obj = New(enemy, x, y, sty.FAIRY_LARGE_6_BLUE, --style
                            300, --hp
                            false,  --show_hpbar
                            {0, 0}, --drop
                            true, --no_count
                            nil, --death_func
                            false --type
                    )
                    _connect(_boss, obj, 0, true)
                    obj.angle = a
                    obj.colli = false
                    obj.canRemove = true --代表可以被撵走
                    task.New(obj, function()
                        local v = dx/60
                        velch(obj, v, 0, 0, 60, 30)
                    end)
                    T.enemy2.main(obj, a)
                    return obj
                end
                return create
            end
    )
    --endregion
    --region Tasker 任务执行器
    --甩出一圈刀
    T.tasker1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local main
                if diff < 3 then
                    local count = switch1(diff, {
                        8, 12, 0, 0, 0
                    })
                    local wt = 24/count
                    local da = 270/(count - 1)
                    function main(obj, r, a, u)
                        task.New(obj, function()
                            for _ = 0, count - 1 do
                                a = a + da*u
                                P.pointer1.attack(obj.x + r*cos(a), obj.y + r*sin(a), a + ran:Float(-2.5, 2.5))
                                --P.pointer4.attack(ran:Float(20, 192)*u, obj.y, 90)
                                task.Wait(wt)
                            end
                        end)
                    end
                elseif diff == 3 then
                    local t = 40
                    local count = 15
                    local bunch = 4
                    local dx = 192/bunch
                    local wt = t/count
                    local c = count*bunch
                    local da = 110/c
                    function main(obj, u)
                        task.New(obj, function()
                            local i = 0
                            for _ = 0, count - 1 do
                                for j = 1, bunch do
                                    P.pointer1.attack(obj.x + dx*j*u, obj.y, 90+(90 - 90 + da*i)*u)
                                    i = i + 1
                                end
                                P.pointer4.attack(ran:Float(20, 192)*u, obj.y, 90)
                                task.Wait(wt)
                            end
                        end)
                    end
                elseif diff == 4 then
                    local way = switch1(diff, {
                        30, 30, 30, 30, 30
                    })
                    local n = 4
                    function main(obj, t, da0, u)
                        task.New(obj, function()
                            local a0, da, a, l = obj.rot, 360/way*u
                            local wt = math.ceil(t/way)
                            for i = 1, way do
                                a = a0 + da*i
                                l = obj.length - 50
                                P.pointer1.attack(obj.x + l*cos(a), obj.y + l*sin(a), a + da0)
                                if i%n == 3 then
                                    P.pointer4.attack(obj.x + l*cos(a), obj.y + l*sin(a), 90)
                                end
                                task.Wait(wt)
                            end
                        end)
                    end
                end
                return main
            end)

    --甩出一圈刀(内避
    T.tasker2 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local way = switch1(diff, {
                    30, 30, 30, 30, 30
                })
                local n = 2
                local function main(obj, x0, y0, t, da0, u)
                    task.New(obj, function()
                        local a0, da, a, l = obj.rot + 180, 360/way*u
                        local wt = math.ceil(t/way)
                        for i = 1, way do
                            a = a0 + da*i
                            l = obj.length
                            P.pointer2.attack(x0 + l*cos(a), y0 + l*sin(a), a + da0)
                            --if i%n == 1 then
                                P.pointer5.attack(x0 + l*cos(a), y0 + l*sin(a), a)
                            --end
                            task.Wait(wt)
                        end
                    end)
                end
                return main
            end)

    T.enemy1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local main
                if diff < 3 then
                    function main(obj, a)
                    end
                elseif diff == 3 then
                    function main(obj, a)
                        task.New(obj, function()
                            task.Wait(60)
                            while true do
                                P.enemy1.attack(obj.x, obj.y, ran:Float(0, 360))
                                task.Wait(120)
                            end
                        end)
                    end
                elseif diff == 4 then
                    --谁不想当一个混吃等死的废物呢？.jpg
                    function main(obj, a)
                    end
                end
                return main
            end)

    T.enemy2 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local main
                if diff < 3 then
                    function main(obj, a)
                    end
                elseif diff == 3 then
                    function main(obj, a)
                        task.New(obj, function()
                            task.Wait(60)
                            while true do
                                P.enemy2.attack(obj.x, obj.y, ran:Float(0, 360))
                                task.Wait(180)
                            end
                        end)
                    end
                elseif diff == 4 then
                    --谁不想当一个混吃等死的废物呢？.jpg
                    function main(obj, a)
                    end
                end
                return main
            end)

    --en难度的攻击
    T.enemyEN = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local wait = switch1(diff, {
                    60, 30, 0, 0, 0
                })
                local function main(obj, i)
                    task.New(obj, function()
                        task.Wait(ran:Int(0, 30))
                        --大王有令，活捉对面的人类者重重有赏！
                        local e = New(expression, obj.x, obj.y + 30, "angry")
                        expression.defaultShow(e, 20, 40, 10) --t0, t1, t2
                        task.Wait(30)
                        local da = 60*((i%3) - 1)
                        local a = Angle(obj, player) + ran:Float(-5, 5) + da
                        B.warning_laser1.create(obj.x, obj.y, 600, a)
                        velchTask(obj, 0, ran:Float(3, 4), a, 120)
                        while obj.y > -100 do
                            P.enemy1.attack(obj.x, obj.y, a + ran:Float(-5, 5))
                            task.Wait(wait)
                        end
                    end)
                end
                return main
            end)
    --endregion
    --region 组合攻击
    local move = EGGlib.ObjectEvent.moveToPlayerDefault
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                --召唤小妖精
                local function createSmall(x0, y0, sp, way, r)
                    local da = sp/(way - 1)
                    way = (way - 1)/2
                    local a, y
                    for i = -way, way do
                        a = -90 + da*i
                        y = y0 + r*sin(a)
                        E.enemy1.create(x0 + r*cos(a), 224, a, y - 224)
                    end
                end
                --召唤中妖精
                local function createMiddle(x0, y0, sp, way, r)
                    local da = sp/(way - 1)
                    way = (way - 1)/2
                    local a, x, u
                    for i = -way, way do
                        a = -90 + da*i
                        if a < -90 then
                            u = -1
                        else
                            u = 1
                        end
                        x = x0 + r*cos(a)
                        E.enemy2.create(224*u, y0 + r*sin(a), a, x - 224*u)
                    end
                end
                local main
                if diff < 3 then
                    local n = switch1(diff, {
                        switch(rank, {
                            6, 6, 6, 6, 8
                        }),
                        switch(rank, {
                            10, 10, 10, 10, 12
                        }),
                        0,
                        0,
                        0
                    })
                    function main(b)
                        --召唤中妖精
                        createMiddle(0, 144, 180, 6, 80) --x0, y0, sp, way, r
                        --召唤小妖精
                        createSmall(0, 144, 210, n, 130) --x0, y0, sp, way, r
                        --召唤小妖精
                        createSmall(0, 144, 180, n, 180) --x0, y0, sp, way, r
                        task.Wait(90)
                    end
                elseif diff == 3 then
                    local n = switch(rank, {
                        6, 6, 6, 6, 8
                    })
                    function main(b)
                        --召唤小妖精
                        createSmall(0, 144, 180, n, 80) --x0, y0, sp, way, r
                        --召唤中妖精
                        createMiddle(0, 144, 180, 4, 120) --x0, y0, sp, way, r
                        --召唤小妖精
                        createSmall(0, 144, 90, n, 160) --x0, y0, sp, way, r
                    end
                elseif diff == 4 then
                    function main(b)
                        --召唤小妖精
                        createSmall(0, 144, 180, 7, 80) --x0, y0, sp, way, r
                        --召唤中妖精
                        createMiddle(0, 144, 180, 6, 180) --x0, y0, sp, way, r
                        --召唤小妖精
                        createSmall(0, 144, 90, 7, 280) --x0, y0, sp, way, r
                    end
                end
                return main
            end)

    C.SECOND = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local main
                if diff < 3 then
                    function main(b, u0)
                        --三连击
                        local u
                        for i = 0, 2 do
                            u = tranU(i)*u0
                            if u < 0 then
                                b.rightAttack()
                            else
                                b.leftAttack()
                            end
                            B.sword1.create(b, 30*(2 - i), u)
                            task.Wait(24)
                        end
                        --task.Wait(60)
                        b.absorbEffect(b, 60)
                        b.breakEffect(b, 0)
                        P.pointer3.attack(b.x, b.y, Angle(b, player), u)
                    end
                elseif diff == 3 then
                    function main(b, u)
                        B.sword1.create(b, u)
                        task.Wait(60)
                        task.MoveTo(b, -40*u, 144, 30, MOVE_NORMAL)
                        allEnemyAndNontjtDo(
                                function(enemy)
                                    --情况不对，赶快撤退
                                    if u < 0 and enemy.x < 0 then
                                        local e = New(expression, enemy.x, enemy.y + 30, "shock")
                                        expression.defaultShow(e, 20, 40, 10) --t0, t1, t2
                                        velchTask(enemy, 0, 6, 90 + 60*u, 30, 30)
                                    elseif u > 0 and enemy.x > 0 then
                                        local e = New(expression, enemy.x, enemy.y + 30, "shock")
                                        expression.defaultShow(e, 20, 40, 10) --t0, t1, t2
                                        velchTask(enemy, 0, 6, 90 + 60*u, 30, 40)
                                    end
                                end
                        )
                        task.Wait(90)
                        task.MoveTo(b, -40*u, -300, 45, MOVE_ACCEL)
                    end
                elseif diff == 4 then
                    function main(b, u)
                        B.sword1.create(b, 90*(1-u) + ran:Float(-2, 2), u)
                        task.Wait(260)
                        --剩下的小怪溜了溜了
                        allEnemyAndNontjtDo(
                                function(enemy)
                                    local u
                                    if enemy.canRemove then --没被扫出屏幕的小怪都溜了233
                                        if enemy.x < 0 then
                                            u = -1
                                        else
                                            u = 1
                                        end
                                        local e = New(expression, enemy.x, enemy.y + 30, "question")
                                        expression.defaultShow(e, 20, 40, 10) --t0, t1, t2
                                        velchTask(enemy, 0, 5*u, 0, 30, 45)
                                        enemy.canRemove = false
                                    end
                                end
                        )
                        --task.Wait(20)
                    end
                end
                return main
            end)

    C.THIRD = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local main
                if diff < 3 then
                    function main(b, u)
                        local i = 0
                        allEnemyAndNontjtDo(
                                function(enemy)
                                    if enemy ~= _boss then
                                        T.enemyEN.main(enemy, i)
                                        i = i + 1
                                    end
                                end
                        )
                        task.Wait(150)
                        C.FIRST.main(b)
                        task.Wait(90)
                    end
                elseif diff == 3 then
                    function main(b, u)
                        b.y = 384 --我又跑到上边了
                        task.MoveTo(b, -40*u, 144, 60, MOVE_DECEL)
                        if u == 1 then
                            C.FIRST.main(b)
                        end
                        task.Wait(60)
                        task.MoveTo(b, 0, 144, 30, MOVE_DECEL)
                    end
                elseif diff == 4 then
                    function main(b, u)
                        task.MoveTo(b, 0, -50, 60, MOVE_NORMAL)
                        B.sword2.create(b, 90*(1-u) + ran:Float(-2, 2), u)
                        task.Wait(240)
                        task.MoveTo(b, 0, 100, 60, MOVE_NORMAL)
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
                    AchievementReminder.unlock("s6_sc2", "恶魔灭绝者:Easy", "成功双倍收取索尼娅的符卡「午夜的狩猎场」/「血肉的圣餐」/「鲜血盛宴」")
                end,
                function()
                    AchievementReminder.unlock("s6_sc2", "恶魔灭绝者:Easy", "成功双倍收取索尼娅的符卡「午夜的狩猎场」/「血肉的圣餐」/「鲜血盛宴」")
                    AchievementReminder.unlock("s6_sc2", "恶魔灭绝者:Normal", "成功双倍收取索尼娅的符卡「午夜的狩猎场」/「血肉的圣餐」/「鲜血盛宴」")
                end,
                function()
                    AchievementReminder.unlock("s6_sc2", "恶魔灭绝者:Easy", "成功双倍收取索尼娅的符卡「午夜的狩猎场」/「血肉的圣餐」/「鲜血盛宴」")
                    AchievementReminder.unlock("s6_sc2", "恶魔灭绝者:Normal", "成功双倍收取索尼娅的符卡「午夜的狩猎场」/「血肉的圣餐」/「鲜血盛宴」")
                    AchievementReminder.unlock("s6_sc2", "恶魔灭绝者:Hard", "成功双倍收取索尼娅的符卡「午夜的狩猎场」/「血肉的圣餐」/「鲜血盛宴」")
                end,
                function()
                    AchievementReminder.unlock("s6_sc2", "恶魔灭绝者:Easy", "成功双倍收取索尼娅的符卡「午夜的狩猎场」/「血肉的圣餐」/「鲜血盛宴」")
                    AchievementReminder.unlock("s6_sc2", "恶魔灭绝者:Normal", "成功双倍收取索尼娅的符卡「午夜的狩猎场」/「血肉的圣餐」/「鲜血盛宴」")
                    AchievementReminder.unlock("s6_sc2", "恶魔灭绝者:Hard", "成功双倍收取索尼娅的符卡「午夜的狩猎场」/「血肉的圣餐」/「鲜血盛宴」")
                    AchievementReminder.unlock("s6_sc2", "恶魔灭绝者:Lunatic", "成功双倍收取索尼娅的符卡「午夜的狩猎场」/「血肉的圣餐」/「鲜血盛宴」")
                end,
            })
            if achi_func then
                achi_func()
            end]]
            achievement.unlock("s6_sc2", true, true)
        end
    end
    
    local hp_list = {2400, 2400, 2400, 3000, 3000}
    local names = {
        "name-boss8-card2-E",
        "name-boss8-card2-N",
        "name-boss8-card2-H",
        "name-boss8-card2-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "spellcard", --类型
            {3, 3, 60}, --时间
            hp_list[difficulty], --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                task.Wait(60)
                if difficulty == 4 then
                    task.MoveTo(b, 0, 100, 60, MOVE_NORMAL)
                else
                    task.MoveTo(b, 0, 144, 60, MOVE_NORMAL)
                end
            end,
            function(b) --练习模式攻击前动作
                if difficulty == 4 then
                    b.x, b.y = 0, 100
                else
                    b.x, b.y = 0, 144
                end
                boss.show_aura(b, true)
            end,
            function(b) --main
                reFresh()
                C.FIRST.main(b)
                b.changeToStaff()
                task.Wait(42)
                while true do
                    for u = -1, 1, 2 do
                        reFresh()
                        C.SECOND.main(b, u)
                        reFresh()
                        C.THIRD.main(b, u)
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
