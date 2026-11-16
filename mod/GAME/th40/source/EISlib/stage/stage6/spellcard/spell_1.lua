-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage6/spellcard/spell_1.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local sizeAndColliChange = EGGlib.ObjectEvent.sizeAndColliChange
local spSizeAndColliChange = EGGlib.ObjectEvent.spSizeAndColliChange
local appearByAlphaTask = EGGlib.ObjectEvent.appearByAlphaTask
local velch = EGGlib.ObjectEvent.velocityChange
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local lead_laser = EISlib.Bullet.Laser.lead_laser
local omigaChangeTask = EGGlib.ObjectEvent.omigaChangeTask
local accDecVelchTask = EGGlib.ObjectEvent.accDecVelocityChangeTask
local accDecVelch = EGGlib.ObjectEvent.accDecVelocityChange
local boundWait = EGGlib.ObjectEvent.boundWait
local polygon2 = EGGlib.BulletGroup.polygon2
local warning_laser = EISlib.Bullet.Laser.warning_laser

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    local changeVelocity = EGGlib.ObjectEvent.changeVelocity
    local alpAndSizeCh = EGGlib.ObjectEvent.alphaAndSizeChange
    local disapear = EGGlib.ObjectEvent.disappear
    --射出去的转向自机相关弹幕
    B.bullet_demo = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y)
                    local obj = stg.newBullet(x, y, stg.arrow_big, COLOR_RED)
                end
                return create
            end
    )

    B.warning_laser1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(mst, x, y, a)
                    local obj = New(warning_laser,
                            x, y,
                            600, 20, 3, 10, a, --len, l_t, wide, w_t, a
                            "mul+add", Color(200, 255, 0, 0), --blend, color
                            40 --disappear
                    )
                    obj.bound = false
                    --_connect(mst, obj, 0, true)
                    task.New(obj, function()
                        while IsValid(mst) do
                            obj.x, obj.y = mst.x, mst.y
                            task.Wait(1)
                        end
                        task.Wait(30)
                        _del(obj, true)
                    end)
                end
                return create
            end
    )

    --大星星出现
    B.bullet1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                --最好搞成奇数way
                local way = switch1(diff, {
                    17, 17, 17, 19, 19
                })
                local da = 360/way
                local function create(b, x, y)
                    local obj = stg.newSimpleBullet(x, y, stg.star_big, COLOR_DEEP_RED, true)
                    robject.set_color(obj, "", 255, 255, 255, 255)
                    obj.colli = false
                    omigaChangeTask(obj, 3, 0, 90, 60)
                    setSizeAndColli(obj, 0.1, 0.1)
                    accDecVelchTask(obj, 3, 90, 15, 15, 10)
                    EGGlib.RenderEffect.newTrail(
                            obj, -1, 15, 3, --master, dlayer, maxnum, frame,
                            "ball_light4", 0.8, "mul+add", --img, size, blend,
                            120, 0.4, true, 0.1, false, --times, _a_rate, Isdsize, size_min, Isdalpha
                            {255, 255, 0}, {255, 255, 255}
                    )
                    task.New(obj, function()
                        --先撑大再缩小
                        spSizeAndColliChange(obj, 1.9, 60, 140)  --obj, ds, dt, phase
                        local a0 = Angle(obj, player)
                        --task.Wait(60)
                        obj._blend = "mul+add"
                        b.breakEffect(b, 0, obj.x, obj.y)
                        P.pointer1.attack(obj.x, obj.y, a0)
                        P.pointer2.attack(obj.x, obj.y, a0)
                        task.New(obj, function()
                            task.Wait(60)
                            for i = 0, way - 1 do
                                B.bullet2.create(obj.x, obj.y, a0 + da*i, (way - i)*2)
                                --task.Wait(2)
                            end
                        end)
                        alpAndSizeCh(obj, -obj._a, 30, 60)
                        _del(obj, true)
                    end)
                end
                return create
            end
    )

    --红星星
    B.bullet2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local r = 40
                --偶数弹
                local function getEvenAngle(obj)
                    return Angle(obj, player) + 180
                end
                --随机弹
                local function getRanAngle(obj)
                    return ran:Float(0, 360)
                end
                --获取起射角度
                local getAngle = switch(rank, {
                    getEvenAngle, getEvenAngle, getEvenAngle, getEvenAngle, getRanAngle
                })
                local function create(x, y, a)
                    local obj = stg.newSimpleBullet(x + r*cos(a), y + r*sin(a), stg.star_big, COLOR_DEEP_RED, true)
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    obj.colli = true
                    obj.rot = a
                    obj.omiga = 6
                    --[[setSizeAndColli(obj, 3, 3)
                    task.New(obj, function()
                        appearByAlphaTask(obj, 60)
                        sizeAndColliChange(obj, -2, 60)
                    end)]]
                    --移动逻辑
                    task.New(obj, function()
                        --[[local t = 60
                        local da, d_da = 8
                        d_da = -da/t
                        for _ = 1, t do
                            da = da + d_da
                            a = a + da
                            obj.x, obj.y = x + r*cos(a), y + r*sin(a)
                            task.Wait(1)
                        end
                        task.Wait(wt)]]
                        SetV(obj, 6, a)
                        accDecVelch(obj, -12, a, 20, 0, 40)
                        B.warning_laser1.create(obj, obj.x, obj.y, a + 180)
                        B.warning_laser1.create(obj, obj.x, obj.y, a)
                        B.laser1.create(obj, a + 180)
                        while BoxCheck(obj, -162, 162, -194, 194) do
                            task.Wait(1)
                        end
                        velch(obj, 0, -6, a, 10)
                        obj.release = true
                        task.Wait(30 + ran:Int(0, 30))
                        PlaySound("kira00")
                        if obj.y > -100 then
                            P.pointer3.attack(obj.x, obj.y, getAngle(obj))
                        end
                        Del(obj)
                    end)
                end
                return create
            end
    )

    --蓝星星
    B.bullet3 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                --减速后的水平速度
                local vx = switch1(diff, {
                    -1.125, -1.25, -1.375, -1.5, -1.5
                })*defaultSwitchVelocityByRank(rank)*1.25
                --拐弯后的垂直速度
                local vy = vx*2
                local function create(x, y, v0, v1, a, t0, t1, u)
                    local obj = stg.newSimpleBullet(x, y, stg.star_big, COLOR_DEEP_BLUE, true)
                    robject.set_color(obj, "", 255, 255, 255, 255)
                    obj.rot = a
                    obj.omiga = 6
                    --移动逻辑
                    task.New(obj, function()
                        velch(obj, v0, v1, a, t0, t1)
                        --转弯怎么说
                        velchTask(obj, 0, vx - v1, a, 30)
                        velch(obj, 0, vy, a + 90*u, 60)
                        --产生拖尾
                        local a = Angle(0, 0, obj.dx, obj.dy) + 180
                        --B.warning_laser1.create(obj, obj.x, obj.y, a)
                        B.warning_laser1.create(obj, obj.x, obj.y, a + 180)
                        B.laser2.create(obj, a)
                    end)
                    boundWait(obj, 480)
                end
                return create
            end
    )

    --星星后面跟着的激光
    B.laser1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(mst, a)
                    local obj = New(lead_laser,
                            1, COLOR_RED, --type, co
                            mst.x, mst.y, 10, a, --x, y, v, a
                            600, 15, 20, 1, --len, w0, w1, t
                            false, false, 240 --islock, isshoot, last_time
                    )
                    task.New(obj, function()
                        while IsValid(mst) and not mst.release do
                            obj.x, obj.y = mst.x, mst.y
                            task.Wait(1)
                        end
                    end)
                end
                return create
            end
    )

    --炸出的星星后面跟着的激光
    B.laser2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(mst, a)
                    local obj = New(lead_laser,
                            1, COLOR_BLUE, --type, co
                            mst.x, mst.y, 10, a, --x, y, v, a
                            240, 15, 20, 1, --len, w0, w1, t
                            false, false, 240 --islock, isshoot, last_time
                    )
                    obj.bound = false
                    task.New(obj, function()
                        while IsValid(mst) do
                            obj.x, obj.y = mst.x, mst.y
                            task.Wait(1)
                        end
                        Del(obj)
                    end)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义
    local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
    P.pointer_demo = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.arrow_big, COLOR_RED
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v, a, way, layer, dv, da, 0, bullet_func)
                            end)
                end
                return attack
            end
    )

    --炸出来的激光星
    P.pointer1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = switch1(diff, {
                    6, 6, 8, 8, 8
                })
                local da = 360/way
                local layer = switch1(diff, {
                    2, 3, 3, 4, 4
                })
                local v0 = 0.85
                local dv = switch1(diff, {
                    1.1, 1.1, 1.1, 1.1, 1.1
                })
                local style, color = stg.star_big, COLOR_DEEP_BLUE
                local function bullet_func(x, y, v, a)
                    for i = 0, 1 do
                        stg.newSimpleStrChV(x, y, v + 2, v, a + 0.5*da*i, 30, 10, style, color).omiga = 6
                        B.bullet3.create(   x, y, v + 2, v, a + 0.5*da*(i + 0.5), 30, 10, tranU(i))
                    end
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v0, a, way,
                                        layer, dv, 0, 0,
                                        bullet_func)
                            end)
                end
                return attack
            end
    )

    --炸出来的鳞弹
    P.pointer2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = switch1(diff, {
                    1.25, 1.5, 1.75, 2, 2
                })*defaultSwitchVelocityByRank(rank)*1.5
                local dv = switch1(diff, {
                    1.5, 0.75, 0.75, 0.5, 0.5
                })*defaultSwitchVelocityByRank(rank)*1.5
                local layer = switch1(diff, {
                    2, 3, 3, 4, 5
                })
                --case：一条线上有多少个子弹
                local l = switch1(diff, {
                    10, 12, 14, 15, 15
                })
                local dl = switch1(diff, {
                    3, 4, 5, 6, 6
                })
                local style, color = stg.arrow_big, COLOR_BLUE
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                for i = 0, layer - 1 do
                                    polygon2(x, y, v + dv*i, a, 5, l + dl*(layer - 1 - i), bullet_func)
                                end
                            end)
                end
                return attack
            end
    )

    --炸出来的小星星
    P.pointer3 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local way = switch1(diff, {
                    5, 7, 11, 15, 15
                })
                local v0 = switch1(diff, {
                    1.75, 2, 2.25, 2.5, 2.5
                })*defaultSwitchVelocityByRank(rank)
                local style, color = stg.star_big, COLOR_DEEP_RED
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 0, v, a, 90, 0, style, color).omiga = -2
                end
                local function attack(x, y, a)
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v0, a, way,
                                        1, 0, 0, 0,
                                        bullet_func)
                            end)
                end
                return attack
            end
    )

    --endregion
    --region 自定义敌人
    --飞出去的魔法书
    local alphaAndSizeChangeTask = EGGlib.ObjectEvent.alphaAndSizeChangeTask
    E.enemy_demo = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local function create(x, y)
                    local obj = New(enemy, x, y, sty.FAIRY_LARGE_RED, --style
                            120, --hp
                            true,  --show_hpbar
                            system.DROP_MID_ENEMY, --drop
                            false, --no_count
                            nil, --death_func
                            true --type
                    )
                end
                return create
            end
    )
    --endregion
    --region Tasker 任务执行器
    T.tasker_demo = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local function main(b, u, co)
                    boss.createTasker(b, b.x, b.y,
                            function(obj)
                                task.New(obj, function()
                                    Del(obj)
                                end)
                    end, true) --iswait
                end
                return main
            end)
    --endregion
    --region 组合攻击
    local move = EGGlib.ObjectEvent.moveToPlayerDefault
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local function main(b, u)
                    B.bullet1.create(b, b.x, b.y)
                    task.Wait(330)
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
    
    local names = {
        "name-boss8-card1-E",
        "name-boss8-card1-N",
        "name-boss8-card1-H",
        "name-boss8-card1-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "spellcard", --类型
            {3, 3, 50}, --时间
            2400, --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                task.Wait(60)
                task.MoveTo(b, 0, 50, 60, MOVE_ACC_DEC)
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 50
                boss.show_aura(b, true)
            end,
            function(b) --main
                while true do
                    for u = -1, 1, 2 do
                        reFresh()
                        C.FIRST.main(b, u)
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
