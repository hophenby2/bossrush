-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage7/spellcard/spell_7.lua" --当前存放目录
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
local Bclass = EISlib.BossDefinition.Gluttony
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local sizeChangeTask = EGGlib.ObjectEvent.sizeChangeTask
local setSize = EGGlib.ObjectEvent.setSize
local moveWith = EGGlib.ObjectEvent.moveWith
local accDecVelChange = EGGlib.ObjectEvent.accDecVelocityChange
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local sizeChangeAlwaysTask = function(obj, phase0, t)
    local c = {} --controller
    task.New(obj, function()
        c.s, c.ds = 0, 1/t
        c.phase, c.dphase = phase0, 5
        local SIN
        for _ = 1, t do
            c.s = c.s + c.ds
            c.phase = c.phase + c.dphase
            SIN = sin(c.phase)
            obj.hscale, obj.vscale = c.s + 0.15*SIN, c.s + 0.15*SIN
            task.Wait(1)
        end
        for _ = 1, _infinite do
            c.phase = c.phase + c.dphase
            SIN = sin(c.phase)
            obj.hscale, obj.vscale = c.s + 0.15*SIN, c.s + 0.15*SIN
            task.Wait(1)
        end
    end)
    return c
end

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    local cat_king --猫王控制者索引
    local performed_cat_list = {}
    --region Bullet 自定义子弹
    --猫拖尾
    B.cat_trail = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local co_list = {COLOR_RED, COLOR_DEEP_RED, COLOR_PURPLE, COLOR_DEEP_PURPLE, COLOR_GRAY, COLOR_DEEP_GRAY, COLOR_BLUE, COLOR_DEEP_BLUE}
                local color_list = {}
                color_list[COLOR_RED] = {255, 0, 0}
                color_list[COLOR_DEEP_RED] = {255, 0, 0}
                color_list[COLOR_PURPLE] = {255, 0, 255}
                color_list[COLOR_DEEP_PURPLE] = {255, 0, 255}
                color_list[COLOR_GRAY] = {255, 255, 255}
                color_list[COLOR_DEEP_GRAY] = {255, 255, 255}
                color_list[COLOR_BLUE] = {0, 0, 255}
                color_list[COLOR_DEEP_BLUE] = {0, 0, 255}
                local function create(cat, t, co)
                    local co = co_list[ran:Int(1, #co_list)]
                    local obj = New(bent_laser_effection, Bclass.servant_trail_tex, cat.x, cat.y, cat.rot, 30, 20) --tex, x, y, rot, len, wide
                    robject.set_color(obj, "mul+add", 255, color_list[co][1], color_list[co][2], color_list[co][3])
                    task.New(obj, function()
                        moveWith(obj, cat, 0, 0, t)
                        bent_laser_effection.disappear(obj, 30)
                    end)
                end
                return create
            end
    )

    --猫王控制者
    B.cat_king_controller = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y)
                    local obj = stg.newBullet(x, y, stg.arrow_big, COLOR_RED, true)
                    obj.hide = true
                    obj.bound = false
                    obj.group = GROUP_ENEMY
                    obj.colli = false
                    obj.hp = 999999
                    cat_king = obj
                end
                return create
            end
    )

    --演出用的猫
    B.cat_performer = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local co_list = {COLOR_RED, COLOR_DEEP_RED, COLOR_PURPLE, COLOR_DEEP_PURPLE, COLOR_GRAY, COLOR_DEEP_GRAY, COLOR_BLUE, COLOR_DEEP_BLUE}
                local da = 1
                local radius = 5 --单个猫头活动半径
                local function create(layer, a, u, isperform)
                    local color = co_list[ran:Int(1, #co_list)]
                    local obj = New(Bclass.servant1, cat_king.x, cat_king.y,
                            9999, false, system.DROP_NONE, --hp, show_hpbar, drop,
                            nil, color --death_func, color
                    )
                    setSize(obj, 0, 0)
                    obj.rot = a - 90
                    obj.group = GROUP_GHOST
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY + 1 + 0.1*(10 - layer)
                        local t = 120
                        local r = 100 + 50*layer
                        if isperform then
                            sizeChangeTask(obj, 1, 20)
                            B.cat_trail.create(obj, 120, color)
                            local phase, dphase = 0, 180/t
                            local d
                            local function move()
                                if IsValid(cat_king) then
                                    phase = phase + dphase
                                    a = a + da*u
                                    d = r*sin(phase)
                                    obj.rot = a
                                    obj.x, obj.y = cat_king.x + d*cos(a), cat_king.y + d*sin(a)
                                else
                                    Del(obj)
                                end
                                task.Wait(1)
                            end
                            for _ = 1, t - 20 do
                                move()
                            end
                            --缩小
                            sizeChangeTask(obj, -1, 20)
                            for _ = 1, 20 do
                                move()
                            end
                        end
                        --再变回来
                        obj.rot = ran:Float(0, 360)
                        sizeChangeAlwaysTask(obj, ran:Int(-90, 90), 20)
                        r = 25 + 20*layer
                        local x0, y0 = r*cos(a), r*sin(a)
                        if IsValid(cat_king) then
                            if not isperform then
                                task.New(obj, function()
                                    task.Wait(10)
                                    P.cat_appear.attack(obj.x, obj.y, a)
                                end)
                            end
                            task.MoveTo(obj, cat_king.x + x0, cat_king.y + y0, 20, MOVE_DECEL)
                        else
                            Del(obj)
                        end
                        --鬼畜抖动+跟随
                        local x, y, dx, dy, a = 0, 0
                        while IsValid(cat_king) do
                            a = ran:Float(0, 360)
                            dx, dy = 0.5*cos(a), 0.5*sin(a)
                            --预移动，判断情况，限制范围
                            if Dist(0, 0, x + dx, y + dy) >= radius then
                                dx, dy = -dx, -dy
                            end
                            x, y = x + dx, y + dy
                            obj.x, obj.y = cat_king.x + x0 + x, cat_king.y + y0 + y
                            task.Wait(1)
                        end
                        Del(obj)
                    end)
                    table.insert(performed_cat_list, obj)
                end
                return create
            end
    )

    --血滴弹
    B.blood = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v0 = 1*defaultSwitchVelocityByRank(rank)
                local v_range = 0.5*defaultSwitchVelocityByRank(rank)
                local vv = 2
                local vx_base = 0.2*defaultSwitchVelocityByRank(rank)
                local function create(r, a)
                    local obj = stg.newBullet(cat_king.x + r*cos(a), cat_king.y + r*sin(a), stg.drop, COLOR_RED)
                    obj.navi = true
                    if a > -180 and a < 0 then
                        obj.rot = -90
                    else
                        --在上方生成的可以带一点随机的横向速度
                        local dx = cos(a)
                        velchTask(obj, 3*vx_base*dx, vx_base*dx, 0, 30, 30)
                        obj.rot = 90 - 90*sign(dx)
                    end
                    --纵向是通用的
                    --加速再减速
                    task.New(obj, function()
                        velch(obj, 0, v0 + ran:Float(-0.5*v_range, 0.5*v_range), -90, 30)
                        accDecVelChange(obj, vv, -90, 30, 0, 30)
                    end)
                end
                return create
            end
    )

    --冲出去的猫头
    B.cat = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local co_list = {COLOR_RED, COLOR_DEEP_RED, COLOR_PURPLE, COLOR_DEEP_PURPLE, COLOR_GRAY, COLOR_DEEP_GRAY, COLOR_BLUE, COLOR_DEEP_BLUE}
                local wait = 4
                local function create(a)
                    local color = co_list[ran:Int(1, #co_list)]
                    local obj = New(Bclass.servant1, cat_king.x + 150*cos(a), cat_king.y + 150*sin(a),
                            9999, false, system.DROP_NONE, --hp, show_hpbar, drop,
                            nil, color --death_func, color
                    )
                    obj.group = GROUP_INDES
                    _connect(_boss, obj, 0, true)
                    obj.bound = true
                    B.cat_trail.create(obj, 120, color)
                    obj.rot = ran:Float(0, 360)
                    obj.omiga = 12*ran:Sign()
                    task.New(obj, function()
                        P.cat_appear.attack(obj.x, obj.y, a)
                        velchTask(obj, 6, 1, a, 30, 0)
                        while obj.y > -100 do
                            P.cat_blood.attack(obj.x, obj.y, obj.rot)
                            task.Wait(wait)
                        end
                    end)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义

    --开卡散出的一圈弹幕
    P.sc_open = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = 0.75
                local dv = 0.075
                local way = 60
                local layer = 3
                local style, color = stg.ball_big, COLOR_RED
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 3*v, v, a, 30, 45, style, color)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v, a, way, layer, dv, 0, 0, bullet_func)
                            end)
                end
                return attack
            end
    )

    --猫头窜出来！
    P.cat_appear = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local angle_range = 0
                local v0 = 1.25*defaultSwitchVelocityByRank(rank)
                local way = switch(rank, {
                    9, 9, 9, 9, 9
                })
                local da = 40/(way - 1)
                local dv = 0.175*defaultSwitchVelocityByRank(rank)
                local function attack(x, y, a)
                    PlaySound("tan00")
                    --stg.newSimpleStrChV(x, y, 2*v0, 0.5*v0, a + ran:Float(-0.25*angle_range, 0.25*angle_range), 20, 0, stg.ball_big, COLOR_RED)
                    local w = (way - 1)/2
                    for i = -w, w do
                        stg.newSimpleStrChV(x, y, 9*(v0 - dv*abs(i)), (v0 - dv*abs(i)), a + da*i + ran:Float(-0.5*angle_range, 0.5*angle_range), 20, 0, stg.arrow_big, COLOR_RED)
                    end
                end
                return attack
            end
    )

    --旋转猫头洒出来的血滴弹
    P.cat_blood = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.ball_mid, COLOR_RED
                local v = 0.9*defaultSwitchVelocityByRank(rank)
                local function bullet_func(x, y, v, a)
                    stg.newStrChV(x, y, 3*v, v, a, 20, 0, style, color)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    bullet_func(x, y, v, a)
                end
                return attack
            end
    )
    --endregion
    --region 自定义敌人
    --endregion
    --region Tasker 任务执行器
    --endregion
    --region 组合攻击
    local isOver = false
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main()
                    isOver = false
                    task.New(_boss, function()
                        local da
                        local list = {}
                        local num_list = {}
                        local index, a0
                        for i = 2, 7 do
                            a0 = ran:Float(0, 360)
                            da = 360/(6+4*i)
                            for j = 1, 6 + 4*i do
                                list[j] = j
                            end
                            for j = 1, #list do
                                index = ran:Int(1, #list)
                                num_list[j] = list[index]
                                table.remove(list, index)
                            end
                            for j = 1, #num_list do
                                B.cat_performer.create(i, a0 + da*num_list[j], 1, false)
                                if system.PowerRank.getRank() == 4 then
                                    task.Wait(4)
                                else
                                    task.Wait(5)
                                end
                            end
                        end
                        isOver = true
                        --之后都是从最外圈出猫头
                        local way = 32
                        while true do
                            a0 = ran:Float(0, 360)
                            da = 360/way
                            for j = 1, way do
                                list[j] = j
                            end
                            for j = 1, #list do
                                index = ran:Int(1, #list)
                                num_list[j] = list[index]
                                table.remove(list, index)
                            end
                            for j = 1, way do
                                B.cat.create(a0 + da*num_list[j])
                                if system.PowerRank.getRank() == 4 then
                                    task.Wait(8)
                                else
                                    task.Wait(10)
                                end
                            end
                        end
                    end)
                end
                return main
            end)

    --血滴
    C.SECOND = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main()
                    task.New(_boss, function()
                        local r
                        while not isOver do
                            r = ran:Float(0, 224)
                            if r < _boss.a then
                                B.blood.create(r, ran:Float(0, 360))
                            end
                            task.Wait(2)
                        end
                        for _ = 1, _infinite do
                            r = ran:Float(0, 224)
                            if r < _boss.a then
                                B.blood.create(r, ran:Float(0, 360))
                            end
                            task.Wait(2)
                        end
                    end)
                    task.New(_boss, function()
                        while true do
                            PlaySound("drop01")
                            task.Wait(300)
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

    local function bossAction(b)
        --生成猫王
        B.cat_king_controller.create(b.x, b.y)
        local da
        for i = 0, 1 do
            da = 360/(6+4*i)
            for j = 1, 6 + 4*i do
                B.cat_performer.create(i, 90 + da*j, tranU(i), true)
                task.Wait(1)
            end
        end
        task.Wait(120)
        --[[tasker(function()
            task.Wait(1)
            P.sc_open.attack(b.x, b.y, -90)
        end)]]
    end

    local card = EGGlib.BossCard.createFullCard(
            "name-boss9-card7", --非/符卡名
        "extrafinal", --类型
            {3, 3, 60}, --时间
            4000, --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                task.wait(60)
                task.MoveTo(b, 0, 50, 60, MOVE_NORMAL)
                bossAction(b)
                PlaySound("gluttony02")
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 50
                boss.show_aura(b, true)
                bossAction(b)
                PlaySound("gluttony02")
            end,
            function(b) --main
                reFresh()
                boss.show_aura(b, false)
                task.Wait(60)
                b.a, b.b = 60, 60
                b.hide = true
                --猫团向上移动
                task.New(b, function()
                    local x, y, dx, dy, a = 0, 0
                    for _ = 1, 900 do
                        a = ran:Float(0, 360)
                        dx = 0.25*cos(a)
                        if abs(x + dx) > 20 then
                            dx = -dx
                        end
                        x = x + dx
                        b.x, b.y = x, b.y + 0.15
                        cat_king.x, cat_king.y = b.x, b.y
                        b.a, b.b = b.a + 0.15, b.b + 0.15
                        task.Wait(1)
                    end
                end)
                C.FIRST.main()
                C.SECOND.main()
            end,
            function(b) --finish
                b.a, b.b = 32, 32
                b.hide = false
                effect.shakeScreen(60, 10)
                sp.UnitListUpdate(performed_cat_list)
                for _, obj in pairs(performed_cat_list) do
                    task.clear(obj)
                    obj.omiga = 6*ran:Sign()
                    task.New(obj, function()
                        SetV(obj, ran:Float(3, 10), Angle(b, obj))
                        alphaChangeTask(obj, 255, 0, 60)
                        task.Wait(60)
                        _del(obj, false)
                    end)
                end
                --移除猫王控制器
                _del(cat_king, false)
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
