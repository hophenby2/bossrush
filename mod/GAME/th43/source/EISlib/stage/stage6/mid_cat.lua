-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
--前置文件
lstg.DoFile(EISlib.BossDefinition.path.."Gluttony.lua")

local curpath = EISlib.stage.path.."stage6/spellcard/mid_normal_1.lua" --当前存放目录
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local no_info = 0
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local changeVelocity = EGGlib.ObjectEvent.changeVelocity
local disapear = EGGlib.ObjectEvent.disappear
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local alphaAndSizeChangeTask = EGGlib.ObjectEvent.alphaAndSizeChangeTask
local move = EGGlib.ObjectEvent.moveToPlayerDefault
local setSize = EGGlib.ObjectEvent.setSize
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local spSizeAndColliChange = EGGlib.ObjectEvent.spSizeAndColliChange
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local sizeAndColliChangeTask = EGGlib.ObjectEvent.sizeAndColliChangeTask
local sizeAndColliChange = EGGlib.ObjectEvent.sizeAndColliChange
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local expression = EISlib.Effect.expression
local halfMoveLengthWithPar = EGGlib.ObjectEvent.halfMoveLengthWithPar
local Bclass = EISlib.BossDefinition.Gluttony
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local moveWith = EGGlib.ObjectEvent.moveWith
local sty = EISlib.Enemy.Style
local AbsorbEffect = EGGlib.RenderEffect.AbsorbEffect

local function createSpEnemy(difficulty, x, y)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    --彩虹拖尾（跟着猫屁股后面的）
    B.rainbow_trail = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(mst, t)
                    local obj = New(bent_laser_effection, Bclass.rainbow_tex, mst.x, mst.y, mst.rot, t, 20) --tex, x, y, rot, len, wide
                    obj.bound = false
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET + 1
                        moveWith(obj, mst, 0, 0, t)
                        bent_laser_effection.disappear(obj, t)
                    end)
                end
                return create
            end
    )

    --会甩的棱弹
    B.grain_b = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                --local v0 = 2
                local v1 = switch1(diff, {
                    1, 1.2, 1.375, 1.5, 1.5
                })*defaultSwitchVelocityByRank(rank)
                local t = 40
                local function create(x, y, a, da)
                    local obj = stg.newBullet(x, y, stg.grain_b, COLOR_RED)
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET+1
                        local v0 = abs(da/180)
                        changeVelocity(obj, v0, v0, a, da, t, t, true)
                        velch(obj, 0, v1 - v0, obj.rot, 30)
                    end)
                end
                return create
            end
    )

    B.bool_ball = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v = 4
                local wait = switch1(diff, {
                    4, 3, 3, 2, 2
                })
                local da = 5*wait
                local function create(x, y, a, u)
                    PlaySound("kira00")
                    local obj = stg.newSimpleBullet(x, y, stg.ball_wool, COLOR_DEEP_RED, true)
                    obj.omiga = 3
                    setSizeAndColli(obj, 0.1, 0.1)
                    obj.colli = false
                    task.New(obj, function()
                        spSizeAndColliChange(obj, 1.9, 30, 120)
                        obj.colli = true
                        --球逐渐缩小，毛线散开
                        sizeAndColliChangeTask(obj, -1.75, 120)
                        velchTask(obj, 0, v, a, 60)
                        local dx, dy, r = cos(a + 180), sin(a + 180)
                        for i = 0, _infinite do
                            r = -obj.hscale*10
                            B.grain_b.create(obj.x + r*dx, obj.y + r*dy, a, (540 - da*i)*u)
                            task.Wait(wait)
                        end
                    end)
                    return obj
                end
                return create
            end
    )

    B.ball_mid = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local t0 = 36
                local dt = 3
                local v0 = switch1(diff, {
                    1.2, 1.4, 1.6, 1.8, 1.8
                })*defaultSwitchVelocityByRank(rank)
                local dv = 0*defaultSwitchVelocityByRank(rank)
                --center_x, center_y 这一组弹幕生成的中心
                --a 移动方向
                --i 这一组弹幕中的第i个弹幕
                local function create(center_x, center_y, a, i)
                    PlaySound("tan00")
                    local v = v0 + dv*i
                    local t = t0 - i*dt
                    local r = v*t - 30
                    local obj = stg.newBullet(center_x + r*cos(a), center_y + r*sin(a), stg.ball_mid, COLOR_RED)
                    SetV(obj, v0 + dv*i, a + 180)
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    obj.colli = false
                    obj.bound = false
                    task.New(obj, function()
                        obj.colli = true
                        obj._blend = ""
                        task.Wait(120)
                        obj.bound = true
                    end)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义
    --endregion
    --region Tasker 任务执行器
    --毛线球产生器
    T.wool_ball_creator = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = switch1(diff, {
                    2, 3, 4, 4, 4
                })
                local da = 120/count
                local wait = 3
                local function main(x, y, a0, u)
                    local obj = stg.newSimpleBullet(0, 0, stg.arrow_big, COLOR_RED, true)
                    obj.hide = true
                    obj.colli = false
                    task.New(obj, function()
                        for i = 0, count - 1 do
                            B.ball_mid.create(x, y, a0 + da*i*u, i)
                            task.Wait(wait)
                        end
                        B.bool_ball.create(x, y, a0, u)
                        _del(obj, false)
                    end)
                end
                return main
            end)
    --endregion
    --region 组合攻击
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local way0 = switch1(diff, {
                    5, 6, 6, 7, 7
                })
                local dway = 0.5
                local max_way = switch1(diff, {
                    8, 10, 12, 14, 14
                })
                local wait = switch1(diff, {
                    10, 8, 7, 6, 6
                })
                local function main(b, way_i)
                    local way = min(math.floor(way0 + way_i*dway), max_way)
                    local da = 360/way
                    local da_c = 0.5*da
                    local a0, a = -90 - da_c
                    for i = 0, way - 1 do
                        a = a0 + da*i
                        T.wool_ball_creator.main(b.x + 100*cos(a), b.y + 100*sin(a), a + ran:Float(-2.5, 2.5), sign(cos(a)))
                        task.Wait(wait)
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

    --猫
    E.cat = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local function create(x, y)
                    local obj = New(enemy, x, y, sty.CAT, --style
                            _infinite, --hp
                            false,  --show_hpbar
                            system.DROP_NONE, --drop
                            true, --no_count
                            nil, --death_func
                            true --type
                    )
                    PlaySound("cat03")
                    obj.colli = false
                    obj.bound = false
                    enemy.setBoundTime(obj, _infinite)
                    enemy.cancelAura(obj)
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET+1
                        B.rainbow_trail.create(obj, 30)
                        task.MoveTo(obj, 0, 144, 30, MOVE_ACC_DEC)
                        PlaySound("ch00")
                        New(AbsorbEffect, obj.x, obj.y, 'tree_leaf_white', 'Cherry_eff', 255, 100, 100)
                        local i = 1
                        while true do
                            reFresh()
                            for u = -1, 1, 2 do
                                C.FIRST.main(obj, i, u)
                                i = i + 1
                            end
                        end
                    end)
                    --跑比
                    task.New(obj, function()
                        task.Wait(660)--坚持11秒就行
                        task.clear(obj, true)
                        --清除子弹、停止发弹
                        for _, b in ObjList(GROUP_ENEMY_BULLET)  do
                            _del(b, true)
                        end
                        for _, b in ObjList(GROUP_INDES)  do
                            _del(b, true)
                        end

                        --惊了！
                        local e = New(expression, obj.x, obj.y + 30, "shock")
                        expression.defaultShow(e, 10, 20, 10) --t0, t1, t2
                        task.Wait(30)
                        --跑比
                        --掉一个六级碎片
                        PlaySound("bonus2")
                        item.Blood.create(obj.x, obj.y, item.Blood.Huge)
                        B.rainbow_trail.create(obj, 60)
                        task.MoveTo(obj, 0, 384, 30, MOVE_ACC_DEC)
                        _del(obj)
                    end)
                    return obj
                end
                return create
            end
    )
    reFresh()
    return E.cat.create(x, y)
end
return createSpEnemy
