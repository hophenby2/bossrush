-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage7/spellcard/normal_1.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local disapear = EGGlib.ObjectEvent.disappear
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local move = EGGlib.ObjectEvent.moveToPlayerDefault
local addV2 = EGGlib.ObjectEvent.addV2
local setSize = EGGlib.ObjectEvent.setSize
local tranRot = EGGlib.Math.TranRot
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local BreakEffect = EGGlib.RenderEffect.BreakEffect

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    --猫脸单个弹幕
    B.cat_shape_unit = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local style, color = stg.jewel, COLOR_GRAY
                local function create(x, y, vx, vy, t)
                    local obj = stg.newSimpleBullet(x, y, style, color - ran:Int(0, 3))
                    obj.omiga = 3*ran:Sign()
                    robject.set_color(obj, "", 255, 255, 255, 255)
                    --setSize(obj, 1, 2)
                    addV2(obj, vx, vy)
                    obj.rot = Angle(0, 0, vx, vy)
                    obj.rot = ran:Int(0, 360)
                end
                return create
            end
    )


    B.money = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, v, a)
                    local obj = stg.newSimpleBullet(x, y, stg.jewel, COLOR_YELLOW - ran:Int(0, 4))
                    obj.rot = ran:Float(0, 360)
                    --setSize(obj, 0.75, 1.5)
                    obj.omiga = 3*ran:Sign()
                    velchTask(obj, v, v, a, 30, 20)
                    addV2(obj, 0, -0.5)
                    --velchTask(obj, 0, ran:Float(0, 1), a + 90*ran:Sign(), 60, 20)
                end
                return create
            end
    )

    --钻石块
    B.diamond = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, v, a)
                    local obj = stg.newSimpleBullet(x, y, stg.jewel, COLOR_BLUE - ran:Int(0, 4))
                    obj.rot = ran:Float(0, 360)
                    --setSize(obj, 1, 2)
                    obj.omiga = 3*ran:Sign()
                    velchTask(obj, v, v, a, 30, 20)
                    addV2(obj, 0, -0.5)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义
    --猫头形的弹幕
    P.cat_shape = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                --猫脸点集（左半边）
                local p = {
                    {0, 122},
                    {-30, 121},
                    {-60, 114},
                    {83, 128},
                    {106, 140},
                    {131, 142},
                    {141, 117},
                    {147, 85},
                    {149, 64},
                    {150, 44},
                    {162, 21},
                    {170, -1},
                    {176, -24},
                    {176, -50},
                    {173, -75},
                    {163, -100},
                    {146, -120},
                    {125, -135},
                    {101, -144},
                    {73, -150},
                    {47, -153},
                    {24, -154},
                    {0, -155}
                }
                --点集坐标转成vx vy的比率
                local r = 0.01*defaultSwitchVelocityByRank(rank)
                for _, v in pairs(p) do
                    v[1], v[2] = v[1]*r, (v[2] - 80)*r
                end

                --每层速度差比率
                local d_v_rate = 0.25*defaultSwitchVelocityByRank(rank)
                --密度倍率
                local density_rate = 1
                local function attack(x, y, a, t, v_rate_i)
                    local rate = 1 + d_v_rate*v_rate_i
                    local da, vx, vy = a + 90
                    for u = -1, 1, 2 do
                        for k, v in pairs(p) do
                            if p[k+1] then
                                for i = 0, density_rate - 1 do
                                    vx, vy = tranRot((v[1] + i/density_rate*(p[k+1][1] - v[1]))*u, (v[2] + i/density_rate*(p[k+1][2] - v[2])), da)
                                    B.cat_shape_unit.create(x, y, vx*rate, vy*rate, t)
                                end
                            else
                                vx, vy = tranRot(v[1]*u, v[2], da)
                                B.cat_shape_unit.create(x, y, vx*rate, vy*rate, t)
                            end
                        end
                    end
                end
                return attack
            end
    )


    P.money = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = 18
                local layer = switch(rank, {
                    3, 3, 3, 3, 4
                })
                local dv = 0.5*defaultSwitchVelocityByRank(rank)
                local v = 1.5*defaultSwitchVelocityByRank(rank)
                local style, color = stg.money, COLOR_YELLOW
                local function bullet_func(x, y, v, a)
                    B.money.create(x, y, v + ran:Float(-0.1, 0.1), a)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(
                                        x, y, v, a, way,
                                        layer, dv, ran:Float(0, 360), 0,
                                        bullet_func)
                            end)
                end
                return attack
            end
    )

    P.diamond = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = 24
                local layer = switch(rank, {
                    2, 2, 2, 2, 3
                })
                local dv = 0.5*defaultSwitchVelocityByRank(rank)
                local v = 1.5*defaultSwitchVelocityByRank(rank)
                local style, color = stg.money, COLOR_YELLOW
                local function bullet_func(x, y, v, a)
                    B.diamond.create(x, y, v + ran:Float(-0.25, 0.25), a + ran:Float(-3, 3))
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(
                                        x, y, v, a, way,
                                        layer, dv, ran:Float(0, 360), 0,
                                        bullet_func)
                            end)
                end
                return attack
            end
    )
    --endregion
    --region 自定义敌人
    --endregion
    --region Tasker 任务执行器
    T.cat_shape = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local layer = switch(rank, {
                    2, 2, 2, 2, 3
                })
                local function main(x, y)
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                PlaySound("stone")
                                task.New(obj, function()
                                    for i = 0, layer - 1 do
                                        P.cat_shape.attack(x, y, -90, 1, i)
                                        task.Wait(0)
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
                    New(BreakEffect, b.x, b.y,  'tree_leaf_white', 'Cherry_eff', 255, 255, 0, "mul+add")
                    T.cat_shape.main(b.x, b.y)
                    P.money.attack(b.x, b.y, ran:Float(0, 360))
                    P.diamond.attack(b.x, b.y, ran:Float(0, 360))
                    task.Wait(60)
                    --移动攻击
                    task.New(b, function()
                        local t = 300
                        local x, dx, d_dx = 0, 0, 0.6/t
                        for _ = 1, t do
                            dx = dx + d_dx
                            x = x + dx
                            b.x = 120*sin(x)
                            task.Wait(1)
                        end
                        while true do
                            x = x + dx
                            b.x = 120*sin(x)
                            task.Wait(1)
                        end
                    end)
                    task.Wait(120)
                end
                return main
            end)

    C.SECOND = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main(b, u)
                    T.cat_shape.main(b.x, b.y)
                    task.Wait(30)
                    P.money.attack(b.x, b.y, ran:Float(0, 360))
                    task.Wait(30)
                    P.diamond.attack(b.x, b.y, ran:Float(0, 360))
                    task.Wait(30)
                end
                return main
            end)

    C.THIRD = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main(b, u)
                    T.cat_shape.main(b.x, b.y)
                    task.Wait(30)
                    P.money.attack(b.x, b.y, ran:Float(0, 360))
                    task.Wait(30)
                    P.diamond.attack(b.x, b.y, ran:Float(0, 360))
                    task.Wait(30)
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
            "name-boss9-card4", --非/符卡名
            "extra", --类型
            {3, 3, 50}, --时间
            3000, --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                task.wait(60)
                task.MoveTo(b, 0, 144, 60, MOVE_NORMAL)
                PlaySound("cat01")
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 144
                boss.show_aura(b, true)
                PlaySound("cat01")
            end,
            function(b) --main
                reFresh()
                C.FIRST.main(b, 1)
                while true do
                    reFresh()
                    for u = -1, 1, 2 do
                        C.SECOND.main(b, u)
                    end
                end
            end,
            function(b) --finish
                if not b.spell_timeout then
                    item.PlayerLife.create(b.x, b.y)
                end
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
