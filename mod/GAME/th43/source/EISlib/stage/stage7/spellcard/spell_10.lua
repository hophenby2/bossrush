-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage7/spellcard/spell_10.lua" --当前存放目录
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
local simpleclass = EGGlib.Class.newSimpleClass
local Basic_movement = EGGlib.Class.Frequently.Basic_movement --基础运动接口
local Updater = EGGlib.Class.Frequently.Updater --boss战专用类更新器
local setSize = EGGlib.ObjectEvent.setSize
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local spSizeAndColliChange = EGGlib.ObjectEvent.spSizeAndColliChange
local simPar = EGGlib.ObjectEvent.simPar
local setV = EGGlib.ObjectEvent.setV
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local tranRot = EGGlib.Math.TranRot
local boundWait = EGGlib.ObjectEvent.boundWait
local sin = EGGlib.Math.phaseToSin
local cos = EGGlib.Math.phaseToCos
local circle_normal1 = EGGlib.BulletGroup.Circle.normal1

--类声明
local Vine_Unit_1_1 = simpleclass() --p1藤蔓单元（米弹）
local Vine_Unit_1_2 = simpleclass() --p1藤蔓单元（鳞弹）
local Vine1 = simpleclass() --p1整根藤蔓
local Cat_Tail = simpleclass() --猫尾巴
local Vine_Unit_2 = simpleclass() --p3的藤蔓单元


local rampage_hp = 2500 --狂暴血线（届时所有攻击强化）
local rampage_timer = 3240 --狂暴时间（届时所有攻击强化）

local function createCard(difficulty)
    local updater
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region 类实现
    --region Vine_Unit_1
    do
        local this = Vine_Unit_1_1
        function this.constructor(self, x, y, a)
            self.grain_a = B.grain_a.create(x, y, a)
            self.status = "normal"
            self.release_left = 180
        end
        function this.update(self)
            if self.release_left > 0 then
                self.release_left = self.release_left - 1
            else
                self:release()
            end
        end
        --同update一起在外部调用，且比update早，若为false则update也不调用
        function this.isValid(self)
            if self.status == "normal" and IsValid(self.grain_a) then
                return true
            else
                return false
            end
        end
        --释放所控制的弹幕
        function this.release(self)
            --为弹幕添加运动事件，散出去
            if IsValid(self.grain_a) then
                T.grain_a_release.main(self.grain_a)
            end
            self.status = "del" --已经释放了，没有价值了
        end
    end

    do
        local this = Vine_Unit_1_2
        this.da = 51
        function this.constructor(self, x, y, a, i, u)
            self.arrow_big = B.arrow_big.create(x, y, a + this.da*i*u)
            self.status = "normal"
            self.release_left = 180
        end
        function this.update(self)
            if self.release_left > 0 then
                self.release_left = self.release_left - 1
            else
                self:release()
            end
        end
        --同update一起在外部调用，且比update早，若为false则update也不调用
        function this.isValid(self)
            if self.status == "normal" and IsValid(self.arrow_big) then
                return true
            else
                return false
            end
        end
        --释放所控制的弹幕
        function this.release(self)
            --为弹幕添加运动事件，散出去
            if IsValid(self.arrow_big) then
                T.arrow_big_release.main(self.arrow_big)
            end
            self.status = "del" --已经释放了，没有价值了
        end
    end

    --用到的弹幕定义
    do
        B.grain_a = EISlib.Bullet.Shooter.createBulletClass(
                function(diff, rank)
                    local function create(x, y, a)
                        local obj = stg.newSimpleBullet(x, y, stg.grain_a, COLOR_GREEN, true)
                        obj.rot = a
                        obj.colli = false
                        setSize(obj, 3, 3)
                        robject.set_color(obj, "mul+add", 0, 255, 255, 255)
                        task.New(obj, function()
                            alphaAndSizeChange(obj, 255, -2, 30)
                            obj.colli = true
                        end)
                        return obj
                    end
                    return create
                end
        )

        T.grain_a_release = EISlib.Bullet.Shooter.createTasker(
                function(diff, rank)
                    local v = 1.25*defaultSwitchVelocityByRank(rank)
                    local function main(obj)
                        task.New(obj, function()
                            velch(obj, 0, v, obj.rot, 60)
                        end)
                    end
                    return main
                end)

        B.arrow_big = EISlib.Bullet.Shooter.createBulletClass(
                function(diff, rank)
                    local function create(x, y, a)
                        local obj = stg.newSimpleBullet(x, y, stg.arrow_big, COLOR_GREEN, true)
                        obj.rot = a
                        obj.colli = false
                        setSizeAndColli(obj, 0.01, 0.01)
                        robject.set_color(obj, "", 255, 255, 255, 255)
                        obj.hide = true
                        task.New(obj, function()
                            task.Wait(15)
                            obj.hide = false
                            velchTask(obj, 0.25, 0, a, 45)
                            spSizeAndColliChange(obj, 1, 45, 135)
                            obj.colli = true
                        end)
                        return obj
                    end
                    return create
                end
        )

        T.arrow_big_release = EISlib.Bullet.Shooter.createTasker(
                function(diff, rank)
                    local v = 1.5*defaultSwitchVelocityByRank(rank)
                    local function main(obj)
                        task.New(obj, function()
                            velch(obj, 0, v, obj.rot, 90)
                        end)
                    end
                    return main
                end)
    end
    --endregion

    --region Vine1
    do
        local this = Vine1
        function this.constructor(self, x, y, u)
            Basic_movement.implement(self, x, y) --继承基础运动类接口
            self.vine_unit_list = {} --存储藤蔓单元的表
            self.u = u
            self.count = 0 --生成的藤蔓次数计数器
            self.status = "normal"
            --运动 与 生成弹幕 行为由实例创建后外部实现
        end
        function this.update(self)
            task.Do(self)
            Basic_movement.update(self) --执行基础运动类的功能
            self:updateList() --更新藤蔓单元表
        end
        function this.updateList(self)
            for k, vine_unit in pairs(self.vine_unit_list) do
                if vine_unit:isValid() then
                    vine_unit:update()
                else
                    table.remove(self.vine_unit_list, k)
                end
            end
        end
        function this.isValid(self)
            if #self.vine_unit_list > 0 and self.status == "normal" then
                return true
            else
                return false
            end
        end
        --原地生成一个米弹
        function this.addUnit1(self)
            PlaySound("kira00")
            table.insert(self.vine_unit_list, Vine_Unit_1_1.new(self.x, self.y, Angle(self.vx, self.vy, 0, 0), self.count, self.u))
        end
        function this.addUnit2(self)
            PlaySound("kira00")
            local a = Angle(self.vx, self.vy, 0, 0)
            table.insert(self.vine_unit_list, Vine_Unit_1_2.new(self.x, self.y, a, self.count, self.u))
            table.insert(self.vine_unit_list, Vine_Unit_1_2.new(self.x, self.y, a + 180, self.count, self.u))
            self.count = self.count + 1
        end
    end
    --endregion


    --endregion

    --region Bullet 自定义子弹

    --开幕心形藤蔓
    B.heart_shape_vine = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v = 6
                local function create(x, y, u)
                    local vine1 = Vine1.new(x, y, u)
                    updater:add(vine1) --加入更新器列表
                    vine1.vy = 1
                    vine1:addUnit1() --立即生成一个藤蔓，防止被判定为失效对象
                    vine1.vy = 0
                    --移动逻辑
                    task.New(vine1, function()
                        local a = 90
                        local t, da = 45, 195*u
                        da = da/t
                        for _ = 1, t do
                            a = a + da
                            setV(vine1, v, a)
                            task.Wait(1)
                        end
                        t, da = 45, 60*u
                        da = da/t
                        for _ = 1, t do
                            a = a + da
                            setV(vine1, v, a)
                            task.Wait(1)
                        end
                        t, da = 45, 30*u
                        da = da/t
                        for _ = 1, t do
                            a = a + da
                            setV(vine1, v, a)
                            task.Wait(1)
                        end
                    end)
                    --单元生成逻辑
                    task.New(vine1, function()
                        for i = 1, 120 do
                            if i%2 == 0 then
                                vine1:addUnit1()
                            end
                            if i%3 == 0 then
                                vine1:addUnit2()
                            end
                            task.Wait(1)
                        end
                        task.Wait(210)
                        vine1.status = "del"
                    end)
                end
                return create
            end
    )

    --直线+弯曲扭动形藤蔓
    B.straight_vine = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v = 6
                --local accmax = 0.01
                local function create(x, y, a, u)
                    local vine1 = Vine1.new(x, y, u)
                    updater:add(vine1) --加入更新器列表
                    --simPar(vine1, v, a, ran:Float(0, accmax), a + 90*u) --抛物线运动
                    setV(vine1, v, a)
                    vine1:addUnit1() --立即生成一个藤蔓，防止被判定为失效对象
                    --移动逻辑
                    task.New(vine1, function()
                        while true do --每15帧更新一次方向
                            setV(vine1, v, a + ran:Float(-10, 10))
                            task.Wait(15)
                        end
                    end)
                    --单元生成逻辑
                    task.New(vine1, function()
                        for i = 1, 70 do
                            if i%2 == 0 then
                                vine1:addUnit1()
                            end
                            if i%3 == 0 then
                                vine1:addUnit2()
                            end
                            task.Wait(1)
                        end
                        task.Wait(210)
                        vine1.status = "del"
                    end)
                end
                return create
            end
    )

    --猫草生成弹幕
    B.ball_big = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v = 2.5
                local function create(x, y, a, u)
                    local obj = stg.newBullet(x, y, stg.ball_big, COLOR_PURPLE, true)
                    setV(obj, v, a)
                    task.New(obj, function()
                        while obj.x > -192 and obj.x < 192 and obj.y > -224 and obj.y < 224 do
                            task.Wait(1)
                        end
                        --生成猫草
                        local da = 75*u
                        local a
                        if obj.x <= -192 then
                            a = 0 + da
                        elseif obj.x >= 192 then
                            a = 180 + da
                        elseif obj.y <= -224 then

                        elseif obj.y >= 224 then
                            a = -90 + da
                        end

                        --屁股底下不生成东西的
                        if obj.y > -224 then
                            obj.hide = true
                            obj.colli = false
                            local t = 30
                            local v = v
                            da = -da/t
                            local i = 0
                            for _ = 1, t do
                                a = a + da
                                setV(obj, v, a)
                                if i%2 == 0 then
                                    B.grain_a2.create(obj.x, obj.y, a + 90)
                                    PlaySound("kira00")
                                end
                                task.Wait(1)
                                i = i + 1
                            end
                            --转一圈
                            local t = 90
                            da = -540/t*u
                            local dv = -v/t
                            for _ = 1, t do
                                v = v + dv
                                a = a + da
                                setV(obj, v, a)
                                if i%2 == 0 then
                                    B.grain_a2.create(obj.x, obj.y, a + 90)
                                    PlaySound("kira00")
                                end
                                task.Wait(1)
                                i = i + 1
                            end
                            B.flower.create(obj.x, obj.y, ran:Float(0, 360))
                            _del(obj, false)
                        else
                            _del(obj, true)
                        end
                    end)
                end
                return create
            end
    )

    --只是用来装饰的猫草
    B.grain_a2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a)
                    local obj = stg.newSimpleBullet(x, y, stg.grain_a, COLOR_GREEN, true)
                    obj.rot = a
                    obj.colli = false
                    setSize(obj, 3, 3)
                    robject.set_color(obj, "mul+add", 0, 255, 255, 255)
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET - 1
                        alphaAndSizeChange(obj, 255, -2, 30)
                        obj.colli = true
                        task.Wait(180)
                        obj.colli = false
                        alphaAndSizeChange(obj, 0, -1, 20)
                        _del(obj, false)
                    end)
                    return obj
                end
                return create
            end
    )

    --花
    B.flower = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a)
                    local obj = stg.newSimpleBullet(x, y, stg.ball_mid, COLOR_PURPLE, false, 1)
                    robject.set_color(obj, "", 255, 255, 255, 255)
                    setSizeAndColli(obj, 0.1, 0.1)
                    task.New(obj, function()
                        spSizeAndColliChange(obj, 0.9, 20, 150)
                        --[[for i = 1, 5 do
                            B.flower_petal.create(x, y, a + 72*i)
                        end]]
                        P.flower_petal.attack(x, y, a)
                        task.Wait(120)
                        alphaAndSizeChange(obj, -255, -1, 30)
                        _del(obj, false)
                    end)
                end
                return create
            end
    )

    --花瓣
    B.flower_petal = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v = 1*defaultSwitchVelocityByRank(rank)
                local dv = 0.25*defaultSwitchVelocityByRank(rank)
                local function create(x, y, dv_i, a)
                    local obj = stg.newSimpleBullet(x, y, stg.arrow_big, COLOR_PURPLE, false, 2)
                    obj.rot = a
                    velchTask(obj, 1, 0, a, 20)
                    robject.set_color(obj, "", 255, 255, 255, 255)
                    setSizeAndColli(obj, 0.1, 0.1)
                    task.New(obj, function()
                        spSizeAndColliChange(obj, 0.9, 20, 150)
                        task.Wait(90)
                        PlaySound("kira00")
                        velch(obj, 0, 2*(v + dv*dv_i), a, 5)
                        velch(obj, 0, -(v + dv*dv_i), a, 5)
                    end)
                end
                return create
            end
    )

    --p3藤蔓
    B.vine3 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v = 6
                local amplitude = 30
                local function create(x, y, a, u)
                    local obj = stg.newSimpleBullet(x, y, stg.arrow_big, COLOR_PURPLE)
                    obj.hide = true
                    obj.colli = false
                    boundWait(obj, 180)
                    setV(obj, v, a)
                    --弹幕生成逻辑
                    task.New(obj, function()
                        local dx, dy = tranRot(0, amplitude, a)
                        local phase = 0
                        local x0, y0 = obj.x + dx*cos(phase)*u, obj.y + dy*cos(phase)*u
                        local last = B.vine_unit_3.create(x0, y0, a + 180)
                        while true do
                            task.Wait(2)
                            phase = phase + 12
                            x0, y0 = obj.x + dx*cos(phase)*u, obj.y + dy*cos(phase)*u
                            if IsValid(last) then
                                last = B.vine_unit_3.create(x0, y0, Angle(x0, y0, last.x, last.y))
                                PlaySound("kira00")
                            end
                        end
                    end)
                end
                return create
            end
    )


    B.vine_unit_3 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v = 2.5*defaultSwitchVelocityByRank(rank)
                local function create(x, y, a)
                    local obj = stg.newSimpleBullet(x, y, stg.ellipse, COLOR_GREEN, true, 1)
                    obj.rot = a
                    obj.colli = false
                    setSize(obj, 3, 3)
                    robject.set_color(obj, "mul+add", 0, 255, 255, 255)
                    task.New(obj, function()
                        alphaAndSizeChange(obj, 255, -2, 30)
                        obj.colli = true
                        task.Wait(180)
                        PlaySound("kira00")
                        obj._blend = ""
                        velch(obj, 0, v, a, 180)
                    end)
                    return obj
                end
                return create
            end
    )

    --endregion
    --region 子弹发射点定义
    P.flower_petal = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = 5
                local layer = 1
                local function bullet_func(x, y, dv_i, a)
                    B.flower_petal.create(x, y, dv_i, a)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    if _boss.hp > rampage_hp and _boss.timer < rampage_timer then
                        circle_layer1(x, y, 0, a, way, layer, 1, 0, 0, bullet_func)
                    else
                        circle_layer1(x, y, 0, a, way, layer + 1, 1, 0, 0, bullet_func)
                    end
                end
                return attack
            end
    )

    --一圈札弹
    P.square = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = 1.25*defaultSwitchVelocityByRank(rank)
                local dv = 0.1*defaultSwitchVelocityByRank(rank)
                local way = 50
                local layer = 1
                local style, color = stg.square, COLOR_DEEP_GREEN
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, v + 2, v, a, 60, 10, style, color)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    if _boss.hp > rampage_hp and _boss.timer < rampage_timer then
                        stg.newFadeEffect(x, y, style, color, false,
                                function()
                                    circle_layer1(x, y, v, a, way, layer, dv, 0, 0, bullet_func)
                                end)
                    else
                        stg.newFadeEffect(x, y, style, color, false,
                                function()
                                    circle_layer1(x, y, v, a, way, layer + 1, dv, 0, 0, bullet_func)
                                end)
                    end
                end
                return attack
            end
    )

    --护身弹幕
    P.protect = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = 3
                local way = 48
                local da = 360/way
                local style, color = stg.ball_big, COLOR_GREEN
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStraight(x, y, v, a, style, color)
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
    --region 自定义敌人
    --endregion
    --region Tasker 任务执行器
    --护身弹，禁止自机靠近屏幕一半以上的高度
    T.protect = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local wait = 20
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
                local function main(b)
                    for u = -1, 1, 2 do
                        B.heart_shape_vine.create(0, b.y, u)
                    end
                    task.New(b, function()
                        task.Wait(180)
                        local u = 1
                        while b.hp > rampage_hp and b.timer < rampage_timer do
                            B.straight_vine.create(-224*u, ran:Float(60, 150), 90 - 90*u, u)
                            task.Wait(60)
                            u = -u
                        end
                        --狂暴
                        while true do
                            B.straight_vine.create(-224*u, ran:Float(60, 150), 90 - 90*u, u)
                            task.Wait(30) --狂暴后改为30f一次
                            u = -u
                        end
                    end)
                end
                return main
            end)

    C.SECOND = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local da = 360/23
                local function main(b)
                    task.New(b, function()
                        for i = 1, 11 do
                            B.ball_big.create(b.x, b.y, 180 - da*i, 1)
                            task.Wait(30)
                        end
                        for i = 12, _infinite do
                            B.ball_big.create(b.x, b.y, 180 - da*i, 1)
                            B.ball_big.create(b.x, b.y, 180 + da*i, -1)
                            task.Wait(30)
                        end
                    end)
                end
                return main
            end)

    C.THIRD = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main(b)
                    task.New(b, function()
                        local a0, a1
                        while true do
                            a0 = 90 + ran:Float(-5, 5)
                            a1 = 90 + ran:Float(-5, 5)
                            B.vine3.create(ran:Int(140, 150), ran:Int(-245, -224), a0, 1)
                            B.vine3.create(-ran:Int(140, 150), ran:Int(-245, -224), a1, 1)
                            task.Wait(120)
                            B.vine3.create(ran:Int(140, 150), ran:Int(-245, -224), a0, -1)
                            B.vine3.create(-ran:Int(140, 150), ran:Int(-245, -224), a1, -1)
                            task.Wait(120)
                        end
                    end)
                end
                return main
            end)

    C.FORTH = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main(b)
                    task.New(b, function()
                        while true do
                            P.square.attack(b.x, b.y, ran:Float(0, 360))
                            task.Wait(60)
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

    local card = EGGlib.BossCard.createFullCard(
            "name-boss9-card10", --非/符卡名
            "extrafinal", --类型
            {3, 3, 75}, --时间
            7000, --耐久
            {0, 100}, --掉落
            function(b) --普通模式攻击前动作
                player_class.setHUDhide(b)
                --强制结束hyper
                if system.PowerRank.isInHyper() then
                    system.PowerRank.hyperNormalEnd(player)
                end
                task.wait(60)
                task.MoveTo(b, 0, 144, 60, MOVE_NORMAL)
                for _ = 1, 3 do
                    PlaySound("ch00")
                    b.absorbEffect(b, 20)
                end
                system.PowerRank.openInfiniteHyperMode()
                system.PowerRank.setHyperTime(system.PowerRank.getHyperMaxTime())
                system.PowerRank.hyperStart()
                system.PowerRank.pauseHyper()
                task.Wait(30)
            end,
            function(b) --练习模式攻击前动作
                player_class.setHUDhide(b)
                system.PowerRank.openInfiniteHyperMode()
                system.PowerRank.setHyperTime(system.PowerRank.getHyperMaxTime())
                system.PowerRank.hyperStart()
                system.PowerRank.pauseHyper()
                b.x, b.y = 0, 144
                boss.show_aura(b, true)
            end,
            function(b) --main
                local dmg_rate = 1
                if player.name then --针对不同自机伤害倍率调整
                    if player.name == "reimu" then
                        dmg_rate = 1.02
                    elseif player.name == "marisa" then
                        dmg_rate = 0.95
                    end
                end
                b.dmgrate = dmg_rate --针对不同机体的减伤机制

                b.protect = false
                T.protect.main()
                updater = Updater.new() --实例化更新器
                reFresh()
                --攻击
                task.New(b, function()
                    C.FIRST.main(b)
                    --[[while b.timer < 1800 and b.hp > 5000 do
                        task.Wait(1)
                    end]]
                    task.Wait(180)
                    C.SECOND.main(b)
                    while b.timer < 1080 and b.hp > 5500 do
                        task.Wait(1)
                    end
                    C.THIRD.main(b)
                    while b.timer < 2160 and b.hp > 4000 do
                        task.Wait(1)
                    end
                    C.FORTH.main(b)
                end)

                --本例中每帧都更新rank
                task.New(b, function()
                    b.layer = LAYER_ENEMY_BULLET+10
                    while true do
                        reFresh()
                        updater:update() --更新更新器里的所有东西
                        task.Wait(1)
                    end
                end)
            end,
            function(b) --finish
                b.dmgrate = 1 --请恢复，不过因为是最后一个阶段，好像不恢复也没啥事
                if ext.sc_pr then
                    system.PowerRank.resumeHyper()
                    system.PowerRank.hyperNormalEnd(player)
                end
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
