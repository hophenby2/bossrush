-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage3/spellcard/spell_3.lua" --当前存放目录
local no_func = function() end
local no_info = 0
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local RGB = {}
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local setV = EGGlib.ObjectEvent.setV
local velch = EGGlib.ObjectEvent.velocityChange
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local warning_laser = EISlib.Bullet.Laser.warning_laser
local lead_laser = EISlib.Bullet.Laser.lead_laser
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local curve_layerDv2 = EGGlib.BulletGroup.Curve.layerDv2
local circle_normal1 = EGGlib.BulletGroup.Circle.normal1

RGB[COLOR_YELLOW] = {255, 255, 0}

--region 方形子弹拖尾
local function createBentEffection(mst, co)
    local obj =  New(bent_laser_effection, "laser_bent_2", mst.x, mst.y, mst.rot, 20, 20) --tex, x, y, rot, len, wide
    robject.set_color(obj, "mul+add", 255, RGB[co][1], RGB[co][2], RGB[co][3])
    task.New(obj, function()
        --如果主人在就跟随
        while IsValid(mst) do
            obj.x, obj.y = mst.x, mst.y
            task.Wait(1)
        end
        obj.vx, obj.vy = obj.dx, obj.dy
        --否则变短消失
        local t = 20
        local len = laser_bent.getLength(obj)
        local alpha = laser_bent.getAlpha(obj)
        local dlen, dalpha = (2 - len)/t, -alpha/t
        for _ = 1, t do
            alpha = alpha + dalpha
            len = len + dlen
            laser_bent.setLength(obj, len)
            laser_bent.setAlpha(obj, alpha)
            task.Wait(1)
        end
        _del(obj, false)
    end)
end
--endregion

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    local book_inst --书对象
    --若rank有变化，则必须更新一次
    local rank = -1
    local function reFresh()
        local new_rank = system.PowerRank.getRank()
        if rank ~= new_rank then --以下两个会受rank影响，需要更新
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
            for _, v in pairs(B) do
                v.update(difficulty, new_rank)
            end
            for _, v in pairs(D) do
                v.update(difficulty, new_rank)
            end
            rank = new_rank
        end
    end
    --region Bullet 自定义子弹
    --鬼火生成时发出的弹幕
    B.laser1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a)
                    local obj = New(warning_laser,
                            x, y,
                            600, 20, 3, 10, a, --len, l_t, wide, w_t, a
                            "mul+add", Color(200, 255, 0, 0), --blend, color
                            60 --disappear
                    )
                    _connect(_boss, obj, 0, true)
                    task.New(obj, function()
                        task.Wait(30)
                        B.arrow_big.create(obj.x, obj.y, a)
                    end)
                end
                return create
            end
    )

    --快速闪过的黄弹
    B.arrow_big = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, a)
                    local obj = stg.newBullet(x, y, stg.kite_b, COLOR_YELLOW)
                    obj.rot = a
                    obj.rect = true
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    createBentEffection(obj, COLOR_YELLOW)
                    setSizeAndColli(obj, 2, 1.5)
                    --velchTask(obj, 0, 10, a, 20)
                    setV(obj, 10, a)
                    task.New(obj, function()
                        task.Wait(5)
                        for _ = 0, 8 do
                            stg.newStrChV(obj.x, obj.y, 1, -4, a, 60, 0, stg.star_small, COLOR_YELLOW - 1).omiga = 3
                            task.Wait(3)
                        end
                    end)
                end
                return create
            end
    )

    --晶弹
    B.bullet1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local da = switch1(diff, {
                    0, 0, 60, 60, no_info
                })
                local function create(x, y, v, a, u, co)
                    local obj = stg.newSimpleBullet(x, y, stg.arrow_big, co)
                    task.New(obj, function()
                        robject.set_color(obj, "", 255, 255, 255, 255)
                        changeVelocity(obj, v + 2, v, a, da*u, 30, 30, true)
                    end)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射器定义
    P.pointer1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.star_small, COLOR_BLUE
                local function bullet_func(x, y, v, a)
                    B.bullet1.create(x, y, v, a, color)
                end
                local v = switch1(diff, {
                    1.75, 2, 1.75, 2, no_info
                })*defaultSwitchVelocityByRank(rank)
                local function attack(x, y, a, sp, co)
                    color = co
                    sp = 0.5*sp
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                for u = -1, 1, 2 do
                                    bullet_func(x, y, v, a + u*sp)
                                end
                            end)
                end
                return attack
            end
    )
    --偏角晶弹
    P.pointer2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color, u0 = stg.kite, COLOR_BLUE
                local way  = switch1(diff, {
                    6, 8, 10, 12, no_info
                })
                local da = 60
                --bunch
                local bunch = switch1(diff, {
                    6, 9, 11, 13, no_info
                })
                local dv_b = switch1(diff, {
                    0.1, 0.1, 0.1, 0.1, no_info
                })
                --layer
                local layer = switch1(diff, {
                    2, 2, 2, 2, no_info
                })
                local dv_l = switch1(diff, {
                    1.5, 1.6, 1.7, 1.8, no_info
                })
                local v0 = switch1(diff, {
                    0.65, 0.7, 0.75, 0.8, no_info
                })*defaultSwitchVelocityByRank(rank)
                local function bullet_func1(x, y, v, a)
                    B.bullet1.create(x, y, v, a, u0, color)
                end
                local function bullet_func2(x, y, v, a)
                    curve_layerDv2(x, y, v, a, bunch, dv_b, da*u0, --x, y, v, a, bunch, dv, sp
                            layer, dv_l, 0, -1, --layer, dv_l, da_l, d_bunch,
                            bullet_func1)
                end
                local function attack(x, y, a, u, co)
                    u0, color = u, co
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_normal1(x, y, v0, a, way, bullet_func2)
                            end)
                end
                return attack
            end
    )
    --第三波晶弹
    local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
    P.pointer3 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.arrow_big, COLOR_GREEN
                local way = switch1(diff, {
                    12, 18, 24, 30, no_info
                }) + switch(rank, {
                    0, 0, 0, 0, 6
                })
                local da = 180/way
                --layer
                local layer = switch1(diff, {
                    3, 4, 5, 6, no_info
                })
                local dv_l = switch1(diff, {
                    0.425, 0.45, 0.475, 0.5, no_info
                })
                local v0 = switch1(diff, {
                    0.85, 0.9, 0.95, 1, no_info
                })*defaultSwitchVelocityByRank(rank)
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, v + 2, v, a, 20, 20, style, color)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v0, a, way,
                                        layer, dv_l, da, 0, --layer, dv_l, da, way,
                                        bullet_func
                                )
                            end)
                end
                return attack
            end
    )
    --endregion
    --region 自定义敌人
    --飞出去的魔法书
    local alphaAndSizeChangeTask = EGGlib.ObjectEvent.alphaAndSizeChangeTask
    E.enemy1 = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local function create(b)
                    local obj = b.createBook(b.x, b.y)
                    obj.mst = b
                    obj.bound = false
                    obj.hscale, obj.vscale = 0, 0
                    obj._a = 0
                    obj.isAttack = false --用于判断汇聚攻击
                    --移动和攻击
                    task.New(obj, function()
                        --透明度变化
                        alphaAndSizeChangeTask(obj, 255, 0.75, 30)
                        task.MoveTo(obj, b.x, b.y - 60, 60, MOVE_ACC_DEC)
                        obj.class.changeOpenState(obj) --开启书本
                        task.Wait(16)
                    end)
                    --绑定
                    _connect(b, obj, 0, true)
                    return obj
                end
                return create
            end
    )

    local aimToPoint = EGGlib.ObjectEvent.aimToPoint
    E.enemy2 = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local function conditionFunc(obj, target_x, target_y)
                    if Dist(obj.x, obj.y, target_x, target_y) > 10 then
                        return true
                    else
                        return false
                    end
                end
                local function create(x, y, a, b, target_x, target_y)
                    local obj = b.createMagic(x, y,
                            120, false, --hp, show_hp
                            system.DROP_NONE, --drop
                            no_func, --death_func
                            COLOR_YELLOW, COLOR_RED --co1, co2
                    )
                    _connect(_boss, obj, 0, true)
                    --obj.bound = false
                    obj.hscale, obj.vscale = 0, 0
                    obj.a, obj.b = 27, 27
                    obj._a = 0
                    obj.colli = false --现在它甚至没判定
                    --拖影
                    EGGlib.RenderEffect.newTrail(obj, --master,
                            -1, 15, 1, --dlayer, maxnum, frame,
                            obj.img, 1, "mul+add", --img, size, blend,
                            45, 0.25, false --times, _a_rate, Isdsize
                    )
                    --移动和攻击
                    task.New(obj, function()
                        --透明度变化
                        alphaAndSizeChangeTask(obj, 255, 1.25, 30)
                        --初始发射
                        --velch(obj, 6, 4, Angle(target_x, target_y, obj.x, obj.y), 30)
                        aimToPoint(obj, target_x, target_y, 12, 60, 0.2, conditionFunc)
                        New(EGGlib.RenderEffect.ScBreakCircle, obj.x, obj.y, 1, 100, 100, 0)
                        for u = -1, 1, 2 do
                            T.laser1.main(obj.x, obj.y, a, u)
                        end
                        Del(obj)
                    end)
                    --绑定
                    return obj
                end
                return create
            end
    )
    --endregion
    --region Tasker 任务执行器
    T.laser1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    2, 3, 4, 4, no_info
                }) + switch(rank, {
                    0, 0, 0, 0, 1
                })
                local function main(x, y, a, u)
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                obj.bound = true
                                SetV(obj, 20, 90*(1-u))
                                task.New(obj, function()
                                    for _ = 0, count - 1 do
                                        PlaySound("kira00")
                                        B.laser1.create(obj.x, obj.y, a + ran:Float(-5, 5))
                                        task.Wait(6)
                                    end
                                    Del(obj)
                                end)
                    end, false) --不拖延
                end
                return main
            end)

    --endregion
    --region 组合攻击
    local move = EGGlib.ObjectEvent.moveToPlayerDefault
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local count = switch1(diff, {
                    3, 4, 5, 6, no_info
                })
                local wait0 = switch(rank, {
                    120, 120, 120, 120, 110
                })
                local wait = switch(rank, {
                    75, 75, 75, 75, 40
                })
                local dx = 150/(count - 1)
                local color = {COLOR_RED, COLOR_BLUE}
                local function main(b, u, isEffect)
                    local obj = book_inst
                    if isEffect then
                        New(EGGlib.RenderEffect.AbsorbEffect, obj.x, obj.y, 'tree_leaf_white', 'Cherry_eff', 255, 255, 0)
                        PlaySound("ch00")
                    end
                    task.Wait(60)
                    if isEffect then
                        New(EGGlib.RenderEffect.BreakEffect, obj.x, obj.y, 'tree_leaf_white', 'Cherry_eff', 255, 255, 0)
                        PlaySound("enep03")
                    end
                    for i = 0, count - 1 do
                        for u = -1, 1, 2 do
                            E.enemy2.create(obj.x, obj.y, -90 - (5 + 10*i)*u, b, dx*(i - 0.5)*u, 245)
                        end
                        task.Wait(5)
                    end
                    task.Wait(wait0)
                    local i = 1
                    for u0 = -u, u, 2*u do
                        P.pointer2.attack(obj.x, obj.y, Angle(b, player), u0, color[i])
                        i = i + 1
                        task.Wait(wait)
                    end
                    P.pointer3.attack(obj.x, obj.y, Angle(b, player))
                end
                return main
            end)
    --endregion
    
    local names = {
        "name-boss4-card3-E",
        "name-boss4-card3-N",
        "name-boss4-card3-H",
        "name-boss4-card3-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "spellcard", --类型
            {3, 3, 50}, --时间
            2200, --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                task.Wait(60)
                task.MoveTo(b, 0, 144, 60, MOVE_ACC_DEC)
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 144
                boss.show_aura(b, true)
            end,
            function(b) --main
                reFresh()
                book_inst = E.enemy1.create(b)
                task.Wait(76)
                C.FIRST.main(b, -1, true)
                while true do
                    reFresh()
                    for u = 1, -1, -2 do
                        C.FIRST.main(b, u, false)
                    end
                end
            end,
            function(b) --finish
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard