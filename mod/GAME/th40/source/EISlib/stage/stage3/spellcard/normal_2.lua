-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage3/spellcard/normal_2.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local alpAndSizeCh = EGGlib.ObjectEvent.alphaAndSizeChange
local disapear = EGGlib.ObjectEvent.disappear
local aimToTarget = EGGlib.ObjectEvent.aimToTarget
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local RGB = {}
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange

RGB[COLOR_DEEP_RED] = {255, 0, 0}
RGB[COLOR_DEEP_BLUE] = {0, 0, 255}
RGB[COLOR_DEEP_GREEN] = {0, 255, 0}

--region 方形子弹拖尾
local function createBentEffection(mst, co)
    local obj =  New(bent_laser_effection, "laser_bent_2", mst.x, mst.y, mst.rot, 20, 20) --tex, x, y, rot, len, wide
    robject.set_color(obj, "mul+add", 255, RGB[co][1], RGB[co][2], RGB[co][3])
    _connect(mst, obj, 0, true)
    task.New(obj, function()
        --如果主人在就跟随
        while IsValid(mst) do
            obj.x, obj.y = mst.x, mst.y
            task.Wait(1)
        end
        obj.vx, obj.vy = obj.dx, obj.dy
    end)
end
--endregion

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    local function createStar(x, y, v, a, wt, co)
        local obj = stg.newSimpleBullet(x, y, stg.arrow_big, co+1)
        --obj.omiga = 6
        obj.bound = false
        obj.hscale, obj.vscale = 0, 0
        robject.set_color(obj, "mul+add", 0, 255, 255, 255)
        obj.colli = false
        obj.rot = a
        task.New(obj, function()
            SetV(obj, 0.25, a)
            alpAndSizeCh(obj, 255, 1, 20)
            obj.colli = true
            obj._blend = ""
            velch(obj, 0, v - 0.25, a, 60)
            task.Wait(wt)
            obj.bound = true
        end)
    end
    --射出去的转向自机相关弹幕
    B.bullet1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                --case：本身的弹速
                local v0 = switch1(diff, {
                    2.75, 3.5, 4.25, 5, no_info
                })*switch(rank, {
                    1, 1.05, 1.075, 1.1, 1.2
                })
                --跟踪弹波弹速
                local v1 = switch1(diff, {
                    1.5, 1.75, 2, 2.25, no_info
                })*switch(rank, {
                    1, 1.05, 1.075, 1.1, 1.2
                })
                --汇聚中点离自机的比率（0为在boss处汇聚，1为自机处汇聚）
                local rate = switch1(diff, {
                    1, 1, 1, 1, no_info
                }) + switch(rank, {
                    0, 0, 0, 0, -0.2
                })
                --case：衍生星弹的弹速
                local v = switch1(diff, {
                    1.25, 1.5, 1.75, 2, no_info
                })*defaultSwitchVelocityByRank(rank)
                local dv = switch1(diff, {
                    0.125, 0.15, 0.175, 0.2, no_info
                })
                local wt = switch1(diff, {
                    120, 120, 120, 120, no_info
                })*switch(rank, {
                    1, 1/1.05, 1/1.1, 1/1.15, 0.7
                })
                local wait = switch1(diff, {
                    30, 20, 12, 10, no_info
                })
                local count = switch1(diff, {
                    2, 3, 3, 3, no_info
                })
                local layer = switch1(diff, {
                    3, 4, 5, 6, no_info
                })
                local wait0 = 2
                local da = switch1(diff, {
                    -135, -135, -135, -135, no_info
                })
                local da1 = switch1(diff, {
                    -10, -10, -10, -10, no_info
                })
                local function create(boss, x, y, a, u, co)
                    local obj = stg.newBullet(x, y, stg.kite_b, co)
                    setSizeAndColli(obj, 2, 1.5)
                    obj.a, obj.b = 6, 6
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    obj.navi = true
                    obj.bound = false
                    --运动逻辑
                    task.New(obj, function()
                        --拖影
                        createBentEffection(obj, co)
                        local x0, y0 = boss.x + (player.x - boss.x)*rate, boss.y + (player.y - boss.y)*rate
                        if co ~= COLOR_DEEP_GREEN then
                            velch(obj, 4.5, 2, a, 30)
                            PlaySound("lazer00")
                            if IsValid(boss) then
                                changeVelocity(obj, 2, v0, Angle(obj.x, obj.y, x0, y0), 0, 30, 1, true)
                            end
                        else
                            velch(obj, 4.5, 2, a, 30)
                            PlaySound("lazer00")
                            --强力跟踪弹
                            aimToTarget(obj, player, (v0 - 2), 30, 0.09,
                                    function(o, target)
                                        if Dist(o, target) > 40 then
                                            return true
                                        else --false时就跳出循环了，进行下一步
                                            return false
                                        end
                                    end)
                        end
                    end)
                    --生成星星
                    task.New(obj, function()
                        task.Wait(5)
                        for _ = 0, count - 1 do
                            for i = 0, layer - 1 do
                                createStar(obj.x, obj.y, v + dv*i, obj.rot + (da + da1*i)*u, wt, co)
                                task.Wait(wait0)
                            end
                            task.Wait(wait)
                        end
                        obj.bound = true
                    end)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射器定义
    local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
    P.pointer1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.star_big
                local layer = switch1(diff, {
                    no_info, 1, 1, 2, no_info
                })
                local v = switch1(diff, {
                    no_info, 2.25, 3, 2.25, no_info
                })*defaultSwitchVelocityByRank(rank)
                local dv = switch1(diff, {
                    no_info, no_info, no_info, 1, no_info
                })
                local way = switch1(diff, {
                    1, 1, 2, 2, no_info
                })
                local da = 360/way/layer
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color).omiga = -4.5
                end
                local function attack(x, y, a, co)
                    color = co
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_layer1(x, y, v, a, way, layer, dv, da, 0, bullet_func)
                            end)
                end
                return attack
            end
    )
    --endregion
    --region 自定义敌人
    --飞出去的魔法书
    local oblique2 = EGGlib.ObjectEvent.obliqueRotateMoveWith2
    local alphaAndSizeChangeTask = EGGlib.ObjectEvent.alphaAndSizeChangeTask
    E.enemy1 = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local dmg_tran = switch(rank, {
                    0.75, 0.75, 0.75, 0.75, 0.25
                })
                local function create(b, a, u, co)
                    local obj = b.createMagic(b.x, b.y,
                            120, false, --hp, show_hp
                            {0, 0}, --drop
                            no_func, --death_func
                            COLOR_YELLOW, COLOR_RED --co1, co2
                    )
                    obj.colli = false
                    obj.mst = b
                    obj.bound = false
                    obj.hscale, obj.vscale = 0, 0
                    obj._a = 0
                    --移动和攻击
                    task.New(obj, function()
                        --透明度变化
                        alphaAndSizeChangeTask(obj, 255, 1, 30)
                        --正常旋转
                        oblique2(obj, b, --self, mst,
                                80, 50, a, --amax, bmax, angle,
                                -0.2*u, 30, 0, 10, --omiga, t0, t1, t2
                                -30*u, false --obliqueAngle, IsRotChange
                        )
                        --obj.class.changeOpenState(obj) --开启书本
                        task.Wait(20)
                        local a = Angle(b.x, b.y, obj.x, obj.y)
                        PlaySound("kira00")
                        B.bullet1.create(b, obj.x, obj.y, a, u, co)
                        --obj.changeNormalState() --合上书本
                        velch(obj, 0, 3, a - 60*u, 60)
                        PlaySound("kira00")
                        --P.pointer1.attack(obj.x, obj.y, a, co)
                        alphaAndSizeChange(obj, -255, -0.8, 30)
                        _del(obj, false)
                    end)
                    --绑定
                    _connect(b, obj, dmg_tran, true)
                end
                return create
            end
    )
    --endregion
    --region Tasker 任务执行器
    T.tasker1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    9, 12, 15, 18, no_info
                }) + switch(rank, {
                    0, 0, 0, 0, 4
                })
                local da = 360/(count)
                local function main(b, u, co)
                    boss.createTasker(b, b.x, b.y,
                            function(obj)
                                task.New(obj, function()
                                    for i = 0, count - 1 do
                                        E.enemy1.create(b, 90 + da*i*u, u, co)
                                        task.Wait(1)
                                    end
                                    Del(obj)
                                end)
                    end, true)
                end
                return main
            end)
    --第三波
    T.tasker2 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    12, 16, 20, 24, no_info
                }) + switch(rank, {
                    0, 0, 0, 0, 4
                })
                local da = 360/(count)
                local function main(b, u, co)
                    boss.createTasker(b, b.x, b.y,
                            function(obj)
                                task.New(obj, function()
                                    for i = 0, count - 1 do
                                        E.enemy1.create(b, da*i*u, 0, co)
                                        task.Wait(1)
                                    end
                                    Del(obj)
                                end)
                            end, true)
                end
                return main
            end)
    --endregion
    --region 组合攻击
    local move = EGGlib.ObjectEvent.moveToPlayerDefault
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local wait = switch(rank, {
                    60, 50, 40, 30, 0
                })
                local co = {COLOR_DEEP_RED, COLOR_DEEP_BLUE, COLOR_DEEP_GREEN}
                local main
                if rank < 4 then
                    function main(b, u)
                        local i = 1
                        for u0 = -u, u, 2*u do
                            T.tasker1.main(b, u0, co[i])
                            task.Wait(30)
                            task.Wait(30)
                            i = i + 1
                        end
                        b.absorbEffect(b, 60)
                        T.tasker2.main(b, u, co[i])
                        task.Wait(120 + wait)
                        move(30, b)
                        task.Wait(30)
                    end
                else
                    function main(b, u)
                        local i = 1
                        for u0 = -u, u, 2*u do
                            T.tasker1.main(b, u0, co[i])
                            task.Wait(30)
                            task.Wait(30)
                            i = i + 1
                        end
                        b.absorbEffect(b, 60)
                        T.tasker2.main(b, u, co[i])
                        task.Wait(120 + wait)
                        move(30, b)
                        task.Wait(30)
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
    
    local names = {
        "name-boss4-normal2-E",
        "name-boss4-normal2-N",
        "name-boss4-normal2-H",
        "name-boss4-normal2-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "normal", --类型
            {3, 3, 30}, --时间
            1400, --耐久
            system.DROP_NORMAL, --掉落
            function(b) --普通模式攻击前动作
                task.Wait(60)
                task.MoveTo(b, 0, 144, 60, MOVE_ACC_DEC)
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 144
                boss.show_aura(b, true)
            end,
            function(b) --main
                while true do
                    reFresh()
                    for u = -1, 1, 2 do
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