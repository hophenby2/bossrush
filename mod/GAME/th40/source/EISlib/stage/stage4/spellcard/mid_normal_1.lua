-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage4/spellcard/mid_normal_1.lua" --当前存放目录
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
local circle_normal1 = EGGlib.BulletGroup.Circle.normal1
local Bclass = EISlib.BossDefinition.LilyWhite
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local moveWith = EGGlib.ObjectEvent.moveWith
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local aimToTarget = EGGlib.ObjectEvent.aimToTarget
local boundWait = EGGlib.ObjectEvent.boundWait

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    --莉莉基础变向弹幕
    B.base = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v = 1.5
                --每层速度差
                local dv_l = 0.4
                local da_l = switch1(diff, {
                    5, 5, 5, 5, 5
                })
                --单层相邻速度差
                local dv_b = switch1(diff, {
                    -0.25, -0.25, -0.25, -0.25, -0.25
                })
                local da_b = switch1(diff, {
                    0, 0, 5, 10, 5
                })

                --衍生出去的弹幕的弹速
                local v0 = switch1(diff, {
                    1.25, 1.5, 1.75, 2, 2
                })*defaultSwitchVelocityByRank(rank)
                local function create(x, y, vl_i, vb_i, a)
                    local obj = stg.newBullet(x, y, stg.arrow_big + (vl_i%2)*(stg.grain_a - stg.arrow_big), COLOR_PURPLE)
                    obj.rot = a
                    task.New(obj, function()
                        --匀速->匀减速到0
                        velch(obj, v + dv_l*vl_i + dv_b*abs(vb_i), 0, a, 7*(7 - vl_i), 30)
                        --task.Wait(7*(7 - vl_i))
                        PlaySound("kira00")
                        --变化
                        local u = sign(vb_i)
                        --stg.newStrChV(obj.x, obj.y, 0, v0, a + da_b*vb_i + da_l*(7 - vl_i)*u + ran:Float(-5, 5), 30, 0, stg.grain_a + (vl_i%2)*(stg.arrow_big - stg.grain_a), COLOR_ORANGE + (vl_i%2)*(COLOR_RED - COLOR_ORANGE))
                        stg.newStrChV(obj.x, obj.y, 0, v0, a + da_b*vb_i + da_l*(7 - vl_i)*u + ran:Float(-5, 5), 30, 0, stg.grain_a + (vl_i%2)*(stg.arrow_big - stg.grain_a), COLOR_RED)
                        _del(obj, true)
                    end)
                end
                return create
            end
    )


    --跟踪弹
    B.arrow_big = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local p = 0.3
                local function create(x, y, dv_i, a)
                    PlaySound("cancel00")
                    local obj = stg.newBullet(x, y, stg.arrow_big, COLOR_PURPLE)
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    boundWait(obj, 180)
                    obj.navi = true
                    obj.rot = a
                    setSizeAndColli(obj, 1.5, 1.5)
                    B.trail.create(obj)
                    task.New(obj, function()
                        obj.rect = true
                        obj.a = 8
                        velch(obj, ran:Int(10, 15)*(1 - 0.5*dv_i), 2, a, 20)
                        PlaySound("kira00")
                        aimToTarget(obj, player, 4, 15, p)
                        velch(obj, 0, 6, obj.rot, 30)
                    end)
                end
                return create
            end
    )

    --拖尾
    B.trail = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(mst)
                    local obj = New(bent_laser_effection, Bclass.pink_light_tex, mst.x, mst.y, mst.rot, 30, 20) --tex, x, y, rot, len, wide
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    task.New(obj, function()
                        moveWith(obj, mst, 0, 0, _infinite)
                        bent_laser_effection.disappear(obj, 10)
                    end)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射点定义
    P.base = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local style, color = stg.arrow_big, COLOR_RED
                local bunch = switch1(diff, {
                    5, 7, 9, 11, 11
                })
                local da = 72/bunch
                local function bullet_func(x, y, vl_i, a)
                    local w = (bunch - 1)/2
                    for vb_i = -w, w do
                        B.base.create(x, y, vl_i, vb_i, a + da*vb_i)
                    end
                end
                local function attack(x, y, vl_i, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                circle_normal1(x, y, vl_i, a, 5, --x, y, vl_i, a, way
                                        bullet_func
                                )
                            end)
                end
                return attack
            end
    )


    --endregion
    --region 自定义任务
    --莉莉基础开花变向弹幕
    T.base = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local layer = switch1(diff, {
                    5, 6, 6, 6, 6
                }) + switch(rank, {
                    0, 0, 0, 0, 1
                })
                local wait = 4
                local function main(x, y)
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                task.New(obj, function()
                                    local a = Angle(x, y, player.x, player.y)
                                    for i = 0, layer - 1 do
                                        P.base.attack(x, y, i, a)
                                        task.Wait(wait)
                                    end
                                    Del(obj)
                                end)
                            end, false) --iswait
                end
                return main
            end)

    --跟踪弹
    T.missile = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local way = switch1(diff, {
                    8, 10, 10, 12, 12
                })
                local da = 240/(way - 1)
                local count = switch1(diff, {
                    2, 3, 3, 4, 4
                })
                local layer = switch1(diff, {
                    1, 2, 2, 2, 2
                })
                local wait = 60/count
                local function main()
                    boss.createTasker(_boss, _boss.x, _boss.y,
                            function(obj)
                                task.New(obj, function()
                                    local w
                                    for _ = 0, count - 1 do
                                        for i = 0, layer - 1 do
                                            w = (way - 1 - i)/2
                                            for j = -w, w do
                                                B.arrow_big.create(_boss.x, _boss.y, i, 90 + da*j)
                                            end
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
                local function main(b, u)
                    T.base.main(b.x, b.y)
                    task.Wait(40)
                    task.MoveTo(b, 50*u, 125, 30, MOVE_ACC_DEC)
                    T.base.main(b.x, b.y)
                    task.Wait(40)
                    task.MoveTo(b, -50*u, 150, 30, MOVE_ACC_DEC)
                    T.base.main(b.x, b.y)
                    task.Wait(30)
                    task.MoveTo(b, 0, 150, 30, MOVE_ACC_DEC)
                    task.Wait(60)
                    T.missile.main()
                    task.MoveTo(b, 0, 100, 60, MOVE_ACC_DEC)
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

    local function bgChangePr()
        local bg = lstg.tmpvar.bg
        if IsValid(bg) and  bg.class.Sence3 then
            bg.class.Sence3(bg, true)
        end
    end
    
    local names = {
        "name-boss5-normal1-E",
        "name-boss5-normal1-N",
        "name-boss5-normal1-H",
        "name-boss5-normal1-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "normal", --类型
            {3, 3, 20}, --时间
            900, --耐久
            system.DROP_NORMAL, --掉落
            function(b) --普通模式攻击前动作
                task.MoveTo(b, 0, 100, 60, MOVE_NORMAL)
                system.record.unlockPerformer("Lily")
                boss.show_aura(b, true)
            end,
            function(b) --练习模式攻击前动作
                bgChangePr()
                b.x, b.y = 0, 100
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
