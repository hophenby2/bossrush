-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
--前置文件
lstg.DoFile(EISlib.BossDefinition.path.."Gluttony.lua")

local curpath = EISlib.stage.path.."stage7/spellcard/normal_1.lua" --当前存放目录
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
local sty = EISlib.Enemy.Style
local setGravityAndMinV = EGGlib.ObjectEvent.setGravityAndMinV
local halfMoveLengthWithPar = EGGlib.ObjectEvent.halfMoveLengthWithPar
local boundWait = EGGlib.ObjectEvent.boundWait
local Bclass = EISlib.BossDefinition.Gluttony
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local moveWith = EGGlib.ObjectEvent.moveWith
local expression = EISlib.Effect.expression

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

    B.grain_b = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local n = switch1(diff, {
                    5, 4, 3, 2, 2
                })
                local v = switch1(diff, {
                    1.5, 1.75, 2, 2.25, 2.25
                })*defaultSwitchVelocityByRank(rank)
                local function create(x, y, a, i)
                    local obj = stg.newBullet(x, y, stg.grain_b, COLOR_RED)
                    SetV(obj, 1, a)
                    obj.rot = a
                    task.New(obj, function()
                        task.Wait(30)
                        if i % n == 0 and obj.y > -78 then
                            stg.newStrChV(obj.x, obj.y, 0, v, ran:Float(0, 360), 60, 0, stg.ball_mid, COLOR_DEEP_RED)
                        end
                        if rank < 4 then
                            _del(obj, true)
                        end
                    end)
                end
                return create
            end
    )

    B.bool_ball = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v = 4
                local ay = -0.05
                local vymin = -6
                local function create(x, y, a, u)
                    PlaySound("kira00")
                    local obj = stg.newSimpleBullet(x, y, stg.ball_wool, COLOR_DEEP_RED, true)
                    boundWait(obj, 180)
                    --E.ball_collisioner.create(obj) --接入碰撞器
                    obj.omiga = 3
                    setSizeAndColli(obj, 0.1, 0.1)
                    obj.colli = false
                    task.New(obj, function()
                        spSizeAndColliChange(obj, 1.4, 30, 120)
                        obj.colli = true
                        --球逐渐缩小，毛线散开
                        sizeAndColliChangeTask(obj, -0.4, 300)
                        local dx, dy, r = cos(a + 180), sin(a + 180)
                        for i = 0, _infinite do
                            r = -obj.hscale*10
                            B.grain_b.create(obj.x + r*dx, obj.y + r*dy, Angle(0, 0, obj.vx, obj.vy), i)
                            task.Wait(5)
                        end
                    end)
                    --运动逻辑
                    task.New(obj, function()
                        velchTask(obj, 0, v, a, 60)
                        --重力加速度
                        setGravityAndMinV(obj, ay, vymin)
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
                local v0 = 2.5*defaultSwitchVelocityByRank(rank)
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
    --region 自定义敌人
    --毛线球控制器
    E.ball_collisioner = EISlib.Bullet.Shooter.createEnemy(
            function(diff, rank)
                local function create(mst)
                    local obj = New(enemy, mst.x, mst.y, sty.FAIRY_SMALL_7_BLUE, --style
                            20, --hp
                            false,  --show_hpbar
                            system.DROP_NONE, --drop
                            true, --no_count
                            nil, --death_func
                            false --type
                    )
                    _connect(obj, mst, 0, true)
                    obj.hide = true
                    task.New(obj, function()
                        while IsValid(mst) do
                            obj.x, obj.y = mst.x, mst.y
                            task.Wait(1)
                        end
                        _del(obj, true)
                    end)
                    obj.colli = false
                    task.New(obj, function()
                        task.Wait(20)
                        obj.colli = true
                    end)
                end
                return create
            end
    )
    --endregion
    --region Tasker 任务执行器
    --毛线球产生器
    T.wool_ball_creator = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = 6
                local function main(x, y, a0, u)
                    B.bool_ball.create(x, y, a0, u)
                end
                return main
            end)
    --endregion

    --region 组合攻击
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local way = switch1(diff, {
                    4, 6, 7, 8, 8
                })
                local da = 90/(way - 1)
                local function main(b, x, y, u)
                    local a0, a = 90 + ran:Float(-2.5, 2.5)
                    local w = (way - 1)/2
                    for i = -w, w do
                        a = a0 + da*i
                        T.wool_ball_creator.main(b.x, b.y, a, u)
                    end
                    B.rainbow_trail.create(b, 25)
                    halfMoveLengthWithPar(b, x, y, 1, Angle(b.x, b.y, x, y), 20, 5, 5, 0)
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
                    enemy.cancelAura(obj)
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET+1
                        task.MoveTo(obj, -120, 144, 30, MOVE_ACC_DEC)
                        local pos = {
                            {-40, 144}, {40, 100}, {120, 144},
                            {40, 60}, {-40, 100}, {-120, 60},
                            {-40, 80}, {40, 20}, {120, 80}
                        }
                        local i = 1
                        local x, y
                         for _ = 1, 3 do
                             for _ = 1, 3 do
                                 reFresh()
                                 x, y = pos[i][1], pos[i][2]
                                 C.FIRST.main(obj, x, y, tranU(i))
                                 i = i + 1
                             end
                            task.Wait(90)
                        end
                        C.FIRST.main(obj, 40, 0, -tranU(i))
                        C.FIRST.main(obj, -40, 20, -tranU(i))
                        task.Wait(30)
                        --清除子弹
                        for _, b in ObjList(GROUP_ENEMY_BULLET)  do
                            _del(b, true)
                        end
                        for _, b in ObjList(GROUP_INDES)  do
                            _del(b, true)
                        end
                        local e = New(expression, obj.x, obj.y + 30, "shock")
                        expression.defaultShow(e, 20, 40, 10) --t0, t1, t2
                        task.Wait(60)
                        --跑比
                        PlaySound("bonus2")
                        item.Blood.create(obj.x, obj.y, item.Blood.Huge)
                        B.rainbow_trail.create(obj, 60)
                        halfMoveLengthWithPar(obj, 300, 80, 1, Angle(obj.x, obj.y, 300, 80), 30, 15, 20, 0)
                        _del(obj, true)
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
