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
local tranRot = EGGlib.Math.TranRot
local sect_layer2 = EGGlib.BulletGroup.Sector.layer2
local clearAllAndGetBonus = EGGlib.ObjectEvent.clearAllAndGetBonus
local AbsorbCircle = EGGlib.RenderEffect.AbsorbCircle
local ScBreakCircle = EGGlib.RenderEffect.ScBreakCircle
local Bclass = EISlib.BossDefinition.Sonia
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local moveWith = EGGlib.ObjectEvent.moveWith


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
    for i = 0, 3 do
        local obj = New(swordLight, self, start_r + add_r*i*self.hscale, u, 20 + 20*i, 30 + 30*(3-i)) --mst, dr, u, len, wide
        task.New(obj, function()
            task.Wait(30)
            local t = 20
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

local mask = Class(object)
function mask:init()
    self.x, self.y = 0, 0
    self.layer = LAYER_BG+1
    self.img = "white"
    self.hscale, self.vscale = 60, 70
    robject.set_color(self, "", 0, 0, 0, 50)
    task.New(self, function()
        --一开始先黑一点
        local t = 2*60
        local d_a = 100/t
        for _ = 1, t do
            self._a = self._a + d_a
            task.Wait(1)
        end

        --然后慢慢得变黑
        t = 33*60
        d_a = 155/t
        for _ = 1, t do
            self._a = self._a + d_a
            task.Wait(1)
        end
    end)
end
function mask:frame()
    task.Do(self)
end
function mask:render()
    defaultRenderImg(self)
end
function mask:close()
    task.New(self, function()
        local t = 60
        local d_a = -self._a/t
        for _ = 1, t do
            self._a = self._a + d_a
            task.Wait(1)
        end
        Del(self)
    end)
end

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    local mask_inst
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

    --狂暴模式下的激光预警
    B.warning_laser1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, rot)
                    local obj = New(warning_laser,
                            x, y,
                            600, 20, --len, l_t
                            20, 10, --wide, w_t
                            rot,
                            "mul+add", Color(150, 255, 0, 0), 55)
                    warning_laser.setTrailLength(obj, 20)
                    warning_laser.setHeadLength(obj, 20)
                    obj.bound = false
                    --
                    task.New(obj, function()
                        task.Wait(45)
                        local ls =  New(lead_laser,
                                1, COLOR_RED, --type, co
                                obj.x, obj.y, 15, rot, --x, y, v, a
                                450, 24, 30, 1, --len, w0, w1, t
                                false, false, 90 --islock, isshoot, last_time
                        )
                        PlaySound("lazer00")
                        ls._blend = "mul+add"
                        P.ball_mid_big_huge.attack(obj.x, obj.y, rot)
                    end)
                end
                return create
            end
    )

    --剑挥一圈
    B.sword1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local way = switch1(diff, {
                    7, 7, 9, 9, 9
                })
                local da = switch1(diff, {
                    120, 160, 160, 160, 160
                })/(way - 1)
                local function create(mst, u)
                    local dr = 16
                    local a = -90 + 90*u
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
                        spSizeAndColliChange(obj, 0.74, 30, 135) --obj, ds, dt, phase
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
                        local wait = math.floor(30/way)
                        local w = (way - 1)/2
                        local a, a0 = Angle(mst, player)
                        for i = -w, w do
                            a0 = a - da*i*u
                            B.warning_laser1.create(mst.x, mst.y, a0) --x, y, len, rot
                            task.Wait(wait)
                        end
                        task.Wait(30)
                        --刮一圈
                        PlaySound("sword02")
                        t = 30
                        --B.laser1.create(obj, obj.length, -u) --产生判定体激光（被隐藏
                        sword.createLight(obj, u, 90, 45) --产生拖尾
                        --T.tasker1.main(obj, t, 130*u, -u) --产生刀弹
                        local a = obj.rot
                        local sp = 270 --扫的角度
                        local x0, dx0 = -90, 180/t
                        for _ = 1, t do
                            x0 = x0 + dx0
                            obj.rot = a - u*sp*0.5*(1 + sin(x0))
                            task.Wait(1)
                        end
                        --缩回去
                        spSizeAndColliChange(obj, -0.75, 30, 90) --obj, ds, dt, phase
                        _del(obj, false)
                    end)
                end
                return create
            end
    )


    --拖尾弹
    B.arrow_big = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local p = 0.3
                local function create(x, y, v, a)
                    local obj = stg.newBullet(x, y, stg.arrow_big, COLOR_CYAN)
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    obj.rot = a
                    setSizeAndColli(obj, 1.5, 1.5)
                    B.trail.create(obj)
                    task.New(obj, function()
                        obj.rect = true
                        obj.a = 8
                        SetV(obj, v, a)
                    end)
                end
                return create
            end
    )

    --拖尾
    B.trail = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(mst)
                    local obj = New(bent_laser_effection, Bclass.blue_light_tex, mst.x, mst.y, mst.rot, 20, 20) --tex, x, y, rot, len, wide
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    task.New(obj, function()
                        moveWith(obj, mst, 0, 0, _infinite)
                        bent_laser_effection.disappear(obj, 10)
                    end)
                end
                return create
            end
    )

    --过场
    B.performed_sword = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a, u)
                    PlaySound("lazer00")
                    local obj = New(sword, x, y)
                    setSize(obj, 1.5, -1.5*u)
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    EGGlib.RenderEffect.newTrail(
                            obj, -1, 45, 1, --master, dlayer, maxnum, frame,
                            obj.img, 1, "mul+add", --img, size, blend,
                            999, 0.5, false, 0.1, true, --times, _a_rate, Isdsize, size_min, Isdalpha
                            {255, 255, 255}, {255, 0, 0}
                    )
                    --_connect(_boss, obj, 0, true)
                    obj.rot = a
                    obj.bound = false
                    obj.class.createLight(obj, u, 45, 90, 35)
                    obj.class.createLight(obj, u, 45, 195, 35)
                    --角度更新
                    task.New(obj, function()
                        local t = 45
                        local phase, dphase = 0, 90/t
                        for _ = 1, t do
                            phase = phase + dphase
                            obj.rot = a + 180*u*sin(phase)
                            task.Wait(1)
                        end
                        alphaChange(obj, obj._a, 0, 10)
                        _del(obj, false)
                    end)
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

    --射出来的大玉等杂乱的子弹
    P.ball_mid_big_huge = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                --中玉的数目
                local count1 = switch1(diff, {
                    8, 8, 8, 8, 8
                })
                --小玉的数目
                local count2 = switch1(diff, {
                    16, 16, 16, 16, 16
                })
                local v = 8
                local v_range = -5
                local function attack(x, y, a)
                    --PlaySound("tan00")
                    local dx, dy, r = -sin(a), cos(a)
                    local rate
                    --生成大玉
                    robject.set_color(stg.newStraight(x, y, v, a, stg.ball_huge, COLOR_RED, false, 2), "mul+add", 255, 255, 255, 255)
                    for _ = 0, count1 - 1 do
                        rate = ran:Float(0, 0.5)
                        r = (1-rate)*8*ran:Sign()
                        stg.newStraight(x + r*dx, y + r*dy, v + rate*v_range, a, stg.ball_big, COLOR_RED, false, 1)
                    end
                    for _ = 0, count2 - 1 do
                        rate = ran:Float(0.5, 1)
                        r = (1-rate)*12*ran:Sign()
                        stg.newStraight(x + r*dx, y + r*dy, v + rate*v_range, a, stg.ball_mid, COLOR_DEEP_RED)
                    end
                end
                return attack
            end
    )

    --狂暴后扔的小星星
    P.star_small = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = switch1(diff, {
                    1.15, 1.3, 1.45, 1.6, 1.6
                })
                local dv = switch1(diff, {
                    0.35, 0.4, 0.45, 0.5, 0.5
                })
                local way = switch1(diff, {
                    10, 12, 14, 16, 16
                })
                local layer = 1
                local sp = 150
                local style, color = stg.star_small, COLOR_DEEP_BLUE
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStraight(x, y, v, a, style, color).omiga = 3
                end
                local function attack(x, y, a)
                    local dl, dway, dsp = 0, 0, 0
                    if _boss.timer > 2820 then
                        dl = 1
                    end
                    if _boss.timer > 3120 then
                        dway = 20
                        dsp = 210
                    end
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_layer2(
                                        x, y, v, a,
                                        way + dway, sp + dsp,
                                        layer + dl, dv, 0, --layer, dv, da
                                        bullet_func
                                )
                            end)
                end
                return attack
            end
    )

    --狂暴后扔的全方位大星星
    P.star_big2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = switch1(diff, {
                    1.65, 1.9, 2.15, 2.4, 2.4
                })
                local way = switch1(diff, {
                    14, 16, 18, 20, 20
                })
                local style, color = stg.star_big, COLOR_BLUE
                local function bullet_func(x, y, v, a)
                    local o = stg.newSimpleStraight(x, y, v, a, style, color - 1, false, -1)
                    o.omiga = 3
                    setSize(o, 1.25, 1.25)
                    stg.newSimpleStraight(x, y, v, a, style, color, false, -1).omiga = 3
                end
                local function attack(x, y, a)
                    PlaySound("kira00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_normal1(x, y, v, a, way, bullet_func)
                            end)
                end
                return attack
            end
    )

    --狂暴后扔刀弹
    P.knife = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = switch1(diff, {
                    2.25, 2.5, 2.75, 3, 3
                })
                local way = switch1(diff, {
                    4, 5, 6, 7, 7
                })
                local style, color = stg.knife, COLOR_DEEP_RED
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStraight(x, y, v, a, style, color)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_normal1(x, y, v, a, way, bullet_func)
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
                                        if player.y > -100 or _boss.timer > 70*60 then --符卡剩5s时强制攻击
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

    --狂暴后小星弹
    T.star_small = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local wait = switch1(diff, {
                    30, 30, 20, 20, 20
                })
                local function main()
                    boss.createTasker(_boss, _boss.x, _boss.y,
                            function(obj)
                                task.New(obj, function()
                                    for i = 0, _infinite do
                                        P.star_small.attack(obj.x, obj.y, Angle(obj, player) + ran:Float(-3, 3))
                                        task.Wait(wait)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --狂暴后大星弹
    T.star_big2 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local wait = switch1(diff, {
                    40, 40, 30, 30, 30
                })
                local function main()
                    boss.createTasker(_boss, _boss.x, _boss.y,
                            function(obj)
                                task.New(obj, function()
                                    for i = 0, _infinite do
                                        P.star_big2.attack(obj.x, obj.y, Angle(obj, player) + ran:Float(-3, 3))
                                        task.Wait(wait)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)


    --狂暴后发射小刀子
    T.knife = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local wait = 5
                local way = switch1(diff, {
                    4, 5, 6, 7, 7
                })
                local da = 360/way*(0.618*0.618)
                local function main()
                    boss.createTasker(_boss, _boss.x, _boss.y,
                            function(obj)
                                task.New(obj, function()
                                    local a0 = -90 + ran:Float(-20, 20)
                                    for i = 0, _infinite do
                                        P.knife.attack(obj.x, obj.y, a0 + da*i)
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

    --狂暴后翅尖发弹
    C.THIRD = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local wait = 4
                local function main(b)
                    task.New(b, function()
                        local back = b.getBacklight() --获取光背
                        local right = back.class.getPart(back, "wing_right") --获取右翅
                        local left = back.class.getPart(back, "wing_left") --获取左翅

                        local root_list = {} --翅根表(其实应该是drumette_list，但是直接把根译作root可读性应该会更好一点）
                        for i = 1, 3 do
                            table.insert(root_list, right.class.getWing(right, i))
                            table.insert(root_list, left.class.getWing(left, i))
                        end

                        local x, y, a, u
                        PlaySound("ch00")
                        --翅尖蓄力
                        for _, root in pairs(root_list) do
                            x, y = root.class.getHeadPos(root) --获取翅尖位置
                            New(AbsorbCircle, x, y, 2, 0, 100, 100, "mul+add")
                        end
                        task.Wait(60)
                        --翅尖爆出
                        for _, root in pairs(root_list) do
                            x, y = root.class.getHeadPos(root) --获取翅尖位置
                            New(ScBreakCircle, x, y, 2, 0, 100, 100)
                        end
                        if diff < 3 then
                            while true do
                                for k, root in pairs(root_list) do
                                    x, y = root.class.getHeadPos(root) --获取翅尖位置
                                    a = root.rot
                                    u = tranU(k)
                                    for i = 0, 1 do
                                        if i > 0 or k > 2 then --EN难度下最里面那条不发弹的
                                            B.arrow_big.create(x, y, 10, a + 20*i*u)
                                        end
                                    end
                                end
                                task.Wait(wait)
                            end
                        else
                            while true do
                                for k, root in pairs(root_list) do
                                    x, y = root.class.getHeadPos(root) --获取翅尖位置
                                    a = root.rot
                                    u = tranU(k)
                                    for i = 0, 1 do
                                        B.arrow_big.create(x, y, 10, a + 20*i*u)
                                    end
                                end
                                task.Wait(wait)
                            end
                        end
                    end)
                end
                return main
            end)

    --狂暴后大砍刀
    C.FORTH = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local wait = switch1(diff, {
                    240, 240, 200, 200, 200
                })
                local function main(b)
                    task.New(b, function()
                        for i = 0, _infinite do
                            B.sword1.create(b, tranU(i))
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
                mask_inst = New(mask)
            end,
            function(b) --练习模式攻击前动作
                player_class.setHUDhide(b)
                bgChangePr()
                b.x, b.y = 0, 120
                bossActionPrac(b)
                boss.show_aura(b, true)
                mask_inst = New(mask)
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
                --region 原版
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
                --endregion

                --region 狂暴阶段
                while b.timer < 30*60 do --剩余倒数45秒时
                    task.Wait(1)
                end
                task.New(b, function()
                    if IsValid(mask_inst) then
                        mask_inst.class.close(mask_inst)
                    end
                    effect.shakeScreen(30, 20)
                    PlaySound("explode")
                    b.breakEffect(b)
                    clearAllAndGetBonus(true) --消除所有子弹
                    item.Blood.killAllChip() --清掉屏幕上所有的碎片
                    --清除自身任务执行器
                    if #b.taskers > 0 then
                        for _, obj in ipairs(b.taskers) do
                            if lstg.IsValid(obj) then
                                task.clear(obj)
                                Del(obj)
                            end
                        end
                    end
                    for _ = 1, #b.taskers do
                        table.remove(b.taskers)
                    end
                    _del_servants(b) --消除附属物
                    task.clear(b, true)
                    player_class.setHUDhide(b) --重置一次hud
                    --动作表演
                    b.changeToSword()
                    task.Wait(60)
                    --翅尖发弹1860f
                    C.THIRD.main(b)
                    task.Wait(6)
                    --强制关闭当前符卡背景
                    b.isCloseScbg = true
                    b.leftAttack()
                    B.performed_sword.create(0, 350, -90 + 90*1, -1)
                    --1866f
                    task.Wait(42)
                    b.changeToStaff()
                    --护身弹
                    T.protect.main()
                    --1908f
                    task.Wait(12)
                    --小星星 1920f
                    T.star_small.main()
                    task.Wait(48)
                    --1968f
                    --大砍刀
                    C.FORTH.main(b)
                    task.Wait(120)
                    --2088f
                    task.Wait(132)
                    --2220f (倒数38s)
                    T.star_big2.main()
                    task.Wait(300)
                    --2520f（倒数33s)
                    T.knife.main()
                end)
                --endregion
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
