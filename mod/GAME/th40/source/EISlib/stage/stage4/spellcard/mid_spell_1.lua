-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage4/spellcard/mid_normal_1.lua" --当前存放目录
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
local circle_normal1 = EGGlib.BulletGroup.Circle.normal1
local Bclass = EISlib.BossDefinition.LilyWhite
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local moveWith = EGGlib.ObjectEvent.moveWith
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local aimToTarget = EGGlib.ObjectEvent.aimToTarget
local AbsorbEffect2 = EGGlib.RenderEffect.AbsorbEffect2
local setNextCardNoScOpenEffect = EGGlib.BossCard.setNextCardNoScOpenEffect
local setV = EGGlib.ObjectEvent.setV
local sect_layer1 = EGGlib.BulletGroup.Sector.layer1
local isInLaser2  = EGGlib.ObjectEvent.isInLaser2
local tranRot = EGGlib.Math.TranRot
local aimToPoint = EGGlib.ObjectEvent.aimToPoint

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    --莉莉基础变向弹幕
    B.base = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local layer = switch1(diff, {
                    4, 6, 8, 10, 10
                })
                local wait = switch(rank, {
                    40, 40, 40, 40, 55
                })/layer
                local v = switch1(diff, {
                    1.5, 1.5, 1.5, 1.5, 1.5
                })
                --每层速度差
                local dv_l = switch1(diff, {
                    0.4, 0.4, 0.4, 0.4, 0.4
                })
                --单层相邻速度差
                local dv_b = switch1(diff, {
                    -0.25, -0.25, -0.25, -0.25, -0.25
                })
                --衍生出去的弹幕的弹速
                local v0 = switch1(diff, {
                    4, 4, 4, 4, 2
                })*defaultSwitchVelocityByRank(rank)
                local v1 = switch1(diff, {
                    1.35, 1.6, 1.8, 2.25, 2
                })*defaultSwitchVelocityByRank(rank)
                local function create(x, y, vl_i, vb_i, a)
                    local obj = stg.newBullet(x, y, stg.arrow_big + (vl_i%2)*(stg.grain_a - stg.arrow_big), COLOR_RED)
                    obj.rot = a
                    task.New(obj, function()
                        --匀速->匀减速到0
                        velch(obj, v + dv_l*vl_i + dv_b*abs(vb_i), 0, a, wait*(layer - vl_i), 30)
                        PlaySound("kira00")
                        --变化
                        robject.set_color(stg.newStrChV(obj.x, obj.y, v0, v1, a + ran:Float(-1, 1), 15, 0, stg.water_drop, COLOR_RED), "mul+add", 255, 255, 255, 255)
                        _del(obj, true)
                    end)
                end
                return create
            end
    )


    --跟踪弹
    B.arrow_big = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                --检测自机相对自身朝向横向距离 的长度（参数越小越靠近自机才会变成弹幕散开
                local h = 350
                local w = 150
                local p = 0.1
                local function create(x, y, a)
                    local obj = stg.newBullet(x, y, stg.heart, COLOR_DEEP_PURPLE)
                    obj.navi = true
                    obj.bound = false
                    obj.rot = a
                    B.trail.create(obj)
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET + 10
                        velch(obj, ran:Float(10, 20), 6, a, 10)
                        local u = sign(obj.x)
                        PlaySound("kira00")
                        --aimToPoint(obj, player.x + ran:Float(-200, 200), player.y, 4, 30, p)
                        aimToPoint(obj, -ran:Float(0, 100)*u, ran:Float(0, -100), 4, 30, p)
                        velchTask(obj, 0, 6, obj.rot, 15)
                        for _ = 1, 90 do
                            if isInLaser2(player, obj.x, obj.y, obj.rot, h, w) and obj.y - player.y > 75 then
                                P.spread.attack(obj.x, obj.y, obj.rot)
                                _del(obj, false)
                            end
                            task.Wait(1)
                        end
                        obj.bound = true
                    end)
                end
                return create
            end
    )

    --拖尾
    B.trail = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(mst)
                    local obj = New(bent_laser_effection, Bclass.pink_light_tex, mst.x, mst.y, mst.rot, 60, 20) --tex, x, y, rot, len, wide
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    obj.bound = false
                    task.New(obj, function()
                        obj.layer = LAYER_ENEMY_BULLET - 1
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

    --分裂弹
    P.spread = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local v = switch1(diff, {
                    0.7, 0.8, 0.9, 1, 1
                })*defaultSwitchVelocityByRank(rank)
                local way = switch1(diff, {
                    1, 3, 5, 7, 7
                })
                local da = switch1(diff, {
                    0, 45, 35, 25, 25
                })
                local layer = switch1(diff, {
                    1, 1, 1, 1, 1
                })
                local dv = switch1(diff, {
                    1, 1, 1, 1, 1
                })*defaultSwitchVelocityByRank(rank)
                local style, color = stg.arrow_big, COLOR_PURPLE
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStrChV(x, y, v+2, v, a, 60, 0, style, color)
                end
                local function attack(x, y, a)
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_layer1(x, y, v, a, way, da, --base
                                        layer, dv, 0, --layer, dv_l, da_l
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
                    4, 6, 8, 10, 10
                })
                local wait = 60/layer
                local da = switch(rank, {
                    0, 0, 0, 0, 0
                })
                local function main(x, y)
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                task.New(obj, function()
                                    local a = Angle(x, y, player.x, player.y) + da
                                    for i = layer - 1, 0, -1 do
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
                    4, 5, 6, 7, 7
                })
                local da = 180/way
                local count = 3
                local wait = 150/way
                local function main(u)
                    boss.createTasker(_boss, _boss.x, _boss.y,
                            function(obj)
                                task.New(obj, function()
                                    local w = (way - 1)/2
                                    for _ = 0, count - 1 do
                                        for i = -w, w do
                                            for u0 = -1, 1, 2 do
                                                B.arrow_big.create(_boss.x, _boss.y, 90 + da*i*u*u0 + ran:Float(-5, 5))
                                            end
                                            task.Wait(wait)
                                        end
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
                    task.Wait(75)
                    T.missile.main(u)
                    task.Wait(75)
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
        setNextCardNoScOpenEffect(b)
    end

    local function bgChangePr()
        local bg = lstg.tmpvar.bg
        if IsValid(bg) and  bg.class.Sence3 then
            bg.class.Sence3(bg, true)
        end
    end

    local function doubleAchievement(b)
        if system.isDoubleGetSpellCardBonus(b) then
            --[[local achi_func = switch1(difficulty, {
                function()
                    AchievementReminder.unlock("s4_mid_sc1", "花开之日:Easy", "成功双倍收取莉莉霍瓦特的符卡 火符「异域的花海」")
                end,
                function()
                    AchievementReminder.unlock("s4_mid_sc1", "花开之日:Easy", "成功双倍收取莉莉霍瓦特的符卡 火符「异域的花海」")
                    AchievementReminder.unlock("s4_mid_sc1", "花开之日:Normal", "成功双倍收取莉莉霍瓦特的符卡 火符「异域的花海」")
                end,
                function()
                    AchievementReminder.unlock("s4_mid_sc1", "花开之日:Easy", "成功双倍收取莉莉霍瓦特的符卡 火符「异域的花海」")
                    AchievementReminder.unlock("s4_mid_sc1", "花开之日:Normal", "成功双倍收取莉莉霍瓦特的符卡 火符「异域的花海」")
                    AchievementReminder.unlock("s4_mid_sc1", "花开之日:Hard", "成功双倍收取莉莉霍瓦特的符卡 火符「异域的花海」")
                end,
                function()
                    AchievementReminder.unlock("s4_mid_sc1", "花开之日:Easy", "成功双倍收取莉莉霍瓦特的符卡 火符「异域的花海」")
                    AchievementReminder.unlock("s4_mid_sc1", "花开之日:Normal", "成功双倍收取莉莉霍瓦特的符卡 火符「异域的花海」")
                    AchievementReminder.unlock("s4_mid_sc1", "花开之日:Hard", "成功双倍收取莉莉霍瓦特的符卡 火符「异域的花海」")
                    AchievementReminder.unlock("s4_mid_sc1", "花开之日:Lunatic", "成功双倍收取莉莉霍瓦特的符卡 火符「异域的花海」")
                end,
            })
            if achi_func then
                achi_func()
            end]]
            achievement.unlock("s4_mid_sc1", true, true)
        end
    end
    
    local names = {
        "name-boss5-card1-E",
        "name-boss5-card1-N",
        "name-boss5-card1-H",
        "name-boss5-card1-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "spellcard", --类型
            {3, 3, 27}, --时间
            1800, --耐久
            {50, 30}, --掉落
            function(b) --普通模式攻击前动作
                task.Wait(60)
                task.MoveTo(b, 0, 144, 60, MOVE_NORMAL)
                bossAction(b)
            end,
            function(b) --练习模式攻击前动作
                bgChangePr()
                b.x, b.y = 0, 144
                boss.show_aura(b, true)
                bossAction(b)
            end,
            function(b) --main
                --没想到吧，是莉莉黑爆的hyper
                PlaySound("nep00")
                effect.shakeScreen(90, 10)
                New(AbsorbEffect2, b.x, b.y, 255, 100, 100, "mul+add")
                b.scOpenEffect(b)
                while true do
                    for u = -1, 1, 2 do
                        reFresh()
                        C.FIRST.main(b, u)
                    end
                end
            end,
            function(b) --finish
                doubleAchievement(b)
                if b.timeout == 0 then
                    item.PlayerBomb.create(b.x, b.y)
                end
            end,
            difficulty, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard
