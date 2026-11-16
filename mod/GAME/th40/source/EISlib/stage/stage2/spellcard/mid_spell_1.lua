-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage2/spellcard/mid_spell_1.lua" --当前存放目录
local no_info = 0
local boss_name = "Artemina"
local light_tex = boss_name.."_light"
local velch = EGGlib.ObjectEvent.velocityChange
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local warning_laser = EISlib.Bullet.Laser.warning_laser
local sect_layer2 = EGGlib.BulletGroup.Sector.layer2
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local move = EGGlib.ObjectEvent.moveToPlayerDefault
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local movePointWithPar = EGGlib.ObjectEvent.movePointWithPar

local function createCard(difficulty)
    --region 自定义子弹
    local B = {}
    --流星箭！
    B.bullet1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                --case：初速度
                local v = switch1(diff, {
                    8, 10, 12, 15, 15
                })*defaultSwitchVelocityByRank(rank)
                --额外产生的低速弓箭速度
                local v0 = switch1(diff, {
                    1.5, 1.75, 2, 1.75, 2.25
                })*defaultSwitchVelocityByRank(rank)
                local layer = switch1(diff, {
                    0, 1, 1, 2, 2
                })
                local dv = switch1(diff, {
                    0, 0, 0, 0.5, 0.5
                })
                local function create(x, y, x1, y1, a, da0, da1)
                    local obj = stg.newBullet(x, y, stg.arrow_mid, COLOR_DEEP_GREEN)
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    obj.rot = a + 180 + da0
                    obj.bound = false
                    obj.navi = true
                    B.light.create(obj, x, y, a + 180 + da0)
                    task.New(obj, function()
                        obj.a = 6
                        obj.rect = true
                        movePointWithPar(obj, x1, y1, 8*cos(obj.rot), 30, 1)
                        warning_laser.setTrailLength(New(warning_laser, obj.x, obj.y,
                                600, 20, --len, l_t
                                3, 10, --wide, w_t
                                a + da1, "mul+add", Color(200, 255, 0, 0), 40), 40)
                        --再biu出去
                        for i = 0, layer - 1 do
                            stg.newSimpleStraight(obj.x, obj.y, v0 + dv*i, a + da1, stg.arrow_mid, COLOR_DEEP_RED)
                        end
                        velch(obj, 0, v, a + da1, 30)
                        obj.bound = true
                    end)
                end
                return create
            end
    )

    --箭拖尾
    B.light = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(mst, x, y, a)
                    local obj = New(bent_laser_effection, light_tex, x, y, a,
                            60, 12 --len, wide
                    )
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    task.New(obj, function()
                        while IsValid(mst) do
                            obj.x, obj.y = mst.x + 5*cos(mst.rot), mst.y + 5*sin(mst.rot)
                            task.Wait(1)
                        end
                        bent_laser_effection.disappear(obj, 30)
                    end)
                end
                return create
            end
    )
    --endregion
    --region 子弹发射器定义
    local P = {}
    --2way发弹点
    P.pointer1 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                --case：way数
                local way = 2 --始终2way
                --case：层数
                local layer = switch1(diff, {
                    1, 1, 1, 1, no_info
                })
                --case：每层弹速差
                local dv = switch1(diff, {
                    no_info, no_info, no_info, no_info
                })
                --case：最终弹速
                local v0 = switch1(diff, {
                    2, 2.5, 3, 3.5, no_info
                })*defaultSwitchVelocityByRank(rank)
                local style = stg.arrow_mid
                local function attack(x, y, a, sp, color)
                    local function bullet_func(x, y, v, a)
                        --stg.newSimpleStraight(x, y, v, a, style, color)
                        stg.newSimpleStrChV(x, y, 0, v, a, 60, 0, style, color)
                    end
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_layer2(x, y, v0, a, way, sp, --base
                                        layer, dv, 0, --layer, dv_l, da_l
                                        bullet_func
                                )
                            end)
                end
                return attack
            end
    )
    --从两边向中间扩张的弹幕点
    P.pointer2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                --case：way数
                local way = switch1(diff, {
                    1, 1, 1, 2, no_info
                })
                --case:扩散角
                local sp = switch1(diff, {
                    no_info, no_info, no_info, 15
                })
                --case：层数
                local layer = switch1(diff, {
                    1, 1, 1, 1, no_info
                })
                --case：每层弹速差
                local dv = switch1(diff, {
                    no_info, no_info, no_info, no_info
                })
                --case：最终弹速
                local v1 = switch1(diff, {
                    2, 2.5, 3, 3.5, no_info
                })*defaultSwitchVelocityByRank(rank)
                local style = stg.arrow_mid
                local function attack(x, y, a, da, color)
                    local function bullet_func(x, y, v, a)
                        stg.newSimpleStrChV(x, y, 1, v, a, 30, 10, style, color)
                    end
                    PlaySound("tan00")
                    local dx, dy = 80*cos(a + 90), 80*sin(a + 90)
                    local _x, _y
                    for u = -1, 1, 2 do
                        _x, _y = x + dx*u, y + dy*u
                        stg.newFadeEffect(_x, _y, style, color, false,
                                function(obj)
                                    sect_layer2(obj.x, obj.y, v1, a + da*u, way, sp, --base
                                            layer, dv, 0, --layer, dv_l, da_l
                                            bullet_func
                                    )
                                end)
                    end
                end
                return attack
            end
    )
    --闪电箭
    P.pointer3 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                --case：way数
                local way = switch1(diff, {
                    4, 5, 5, 7, 7
                })
                way = int(way)--要取整的
                local da0 = 180/(way - 1)
                local da1 = switch1(diff, {
                    75, 85, 75, 75, no_info
                })/(way - 1)
                local style, color = stg.arrow_mid, COLOR_DEEP_GREEN
                local function attack(x, y, x1, y1, a, dway)
                    PlaySound("lazer00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                local w = (way + dway - 1)/2
                                for i = -w, w do
                                    B.bullet1.create(x, y, x1, y1, a, da0*i, da1*i)
                                end
                            end)
                end
                return attack
            end
    )
    --endregion
    --region Shooter 发射器
    local S = {}
    --endregion
    --region movement
    local M = {}
    --endregion
    --region Tasker 任务执行器
    local T = {}
    --生成屏幕里的弹幕箭
    T.tasker1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                --case：发射次数
                local count = switch1(diff, {
                    9, 12, 15, 20, no_info
                })
                local wait = 60/count
                --case：角度差
                local da0 = switch1(diff, {
                    15, 15, 7.5, 5, no_info
                })
                local da = 180/(count - 1)
                --case：向内的箭弹初始张开角度的一半
                local da10 = 80
                local da1 = switch1(diff, {
                    120, 120, 95, 90, no_info
                })/(count - 1)
                local function main(b, x, y, x1, y1, a)
                    boss.createTasker(b, x, y,
                            function(obj)
                                task.New(obj, function()
                                    P.pointer3.attack(obj.x, obj.y, x1, y1, a, 0) --闪电箭
                                    task.Wait(10)
                                    if system.PowerRank.getRank() >= 4 then
                                        P.pointer3.attack(obj.x, obj.y, x1, y1, a, 1) --爆H再来一轮
                                    end
                                end)
                                task.New(obj, function()
                                    task.MoveTo(obj, x1, y1, 50, MOVE_NORMAL)
                                    velchTask(obj, 6, 3, a, 20, 0)
                                    if difficulty > 2 then --hl
                                        for i = 0, count - 1 do
                                            P.pointer1.attack(obj.x, obj.y, a, da0 + 2*da*i, COLOR_DEEP_BLUE)
                                            P.pointer2.attack(obj.x, obj.y, a, da10 - da1*i, COLOR_DEEP_GREEN)
                                            task.Wait(wait)
                                        end
                                    else --en
                                        for i = 0, count - 1 do
                                            P.pointer2.attack(obj.x, obj.y, a, da10 - da1*i, COLOR_DEEP_GREEN)
                                            task.Wait(wait)
                                        end
                                    end
                                end)
                            end, false
                    ) --不拖延
                end
                return main
            end)
    --endregion
    --region 自定义敌人
    local E  = {}
    --endregion
    --region 组合攻击
    local C = {} --combination
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                local wait = switch(rank, {
                    60, 60, 60, 60, 50
                })
                local function main(b, u)
                    task.New(b, function()
                        b.cast("attack_up_before")
                        task.Wait(32)
                        b.cast("attack_up_ing")
                        task.Wait(12)
                        b.cast("attack_up_after")
                    end)
                    task.Wait(44)
                    T.tasker1.main(b, b.x, b.y + 30, b.x, 245, Angle(b.x, 245, player.x, player.y))
                    move(30, b, 75)
                    task.Wait(30)
                    task.Wait(wait - 44)
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
            rank = new_rank
        end
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
                    AchievementReminder.unlock("s2_mid_sc1", "绿林好汉:Easy", "成功双倍收取露妮的符卡「Lokheira」")
                end,
                function()
                    AchievementReminder.unlock("s2_mid_sc1", "绿林好汉:Easy", "成功双倍收取露妮的符卡「Lokheira」")
                    AchievementReminder.unlock("s2_mid_sc1", "绿林好汉:Normal", "成功双倍收取露妮的符卡「Lokheira」")
                end,
                function()
                    AchievementReminder.unlock("s2_mid_sc1", "绿林好汉:Easy", "成功双倍收取露妮的符卡「Lokheira」")
                    AchievementReminder.unlock("s2_mid_sc1", "绿林好汉:Normal", "成功双倍收取露妮的符卡「Lokheira」")
                    AchievementReminder.unlock("s2_mid_sc1", "绿林好汉:Hard", "成功双倍收取露妮的符卡「Lokheira」")
                end,
                function()
                    AchievementReminder.unlock("s2_mid_sc1", "绿林好汉:Easy", "成功双倍收取露妮的符卡「Lokheira」")
                    AchievementReminder.unlock("s2_mid_sc1", "绿林好汉:Normal", "成功双倍收取露妮的符卡「Lokheira」")
                    AchievementReminder.unlock("s2_mid_sc1", "绿林好汉:Hard", "成功双倍收取露妮的符卡「Lokheira」")
                    AchievementReminder.unlock("s2_mid_sc1", "绿林好汉:Lunatic", "成功双倍收取露妮的符卡「Lokheira」")
                end,
            })
            if achi_func then
                achi_func()
            end]]
            achievement.unlock("s2_mid_sc1", true, true)
        end
    end
    
    local names = {
        "name-boss3-card1-E",
        "name-boss3-card1-N",
        "name-boss3-card1-H",
        "name-boss3-card1-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "spellcard", --类型
            {3, 3, 25},
            1200, --耐久
            system.DROP_SPELL, --掉落
            function(b) --普通模式攻击前动作
                task.Wait(60)
                task.MoveTo(b, 0, 75, 60, MOVE_ACC_DEC)
            end,
            function(b) --练习模式攻击前动作
                bgChangePr()
                b.x, b.y = 0, 75
                boss.show_aura(b, true)
            end,
            function(b) --main
                reFresh()
                while true do
                    for u = -1, 1, 2 do
                        reFresh()
                        C.FIRST.main(b, u)
                    end
                end
            end,
            function(b) --finish
                doubleAchievement(b)
            end,
            4, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard