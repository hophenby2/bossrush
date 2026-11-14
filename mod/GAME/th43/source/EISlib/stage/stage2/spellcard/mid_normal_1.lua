-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage2/spellcard/mid_normal_1.lua" --当前存放目录
local no_info = 0
local boss_name = "Artemina"
local light_tex = boss_name.."_light"
local warning_laser = EISlib.Bullet.Laser.warning_laser
local velch = EGGlib.ObjectEvent.velocityChange
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local boundWait = EGGlib.ObjectEvent.boundWait
local bent_laser_effection = EGGlib.RenderEffect.bent_laser_effection
local disappearByAlpha = EGGlib.ObjectEvent.disappearByAlpha
local sect_layer2 = EGGlib.BulletGroup.Sector.layer2
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local move = EGGlib.ObjectEvent.moveToPlayerDefault

local function createCard(difficulty)
    --region 自定义子弹
    local B = {}
    B.bullet1 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local function create(x, y, v0, v1, a, style, color)
                    local obj = stg.newSimpleBullet(x, y, style, color)
                    obj.rot = a
                    boundWait(obj, 180) --出屏
                    task.New(obj, function()
                        velch(obj, v0, 0, a, 10, 30)
                        PlaySound("kira00")
                        velch(obj, 0, v1, a, 150, 0)
                    end)
                end
                return create
            end
    )

    --流星箭！
    B.bullet2 = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                --case：拖影箭饱和弹速
                local v = switch1(diff, {
                    6, 8, 10, 12, 12
                })*defaultSwitchVelocityByRank(rank)
                local function create(x, y, a, color)
                    local obj = stg.newBullet(x, y, stg.arrow_mid, COLOR_GREEN)
                    robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                    obj.rot = a
                    obj.bound = true
                    velchTask(obj, 2, v, a, 20, 20)
                    New(warning_laser, obj.x, obj.y,
                            600, 20, --len, l_t
                            2.5, 10, --wide, w_t
                            a, "mul+add", Color(200, 255, 0, 0), 30)
                    --生成拖尾
                    B.light.create(obj, x, y, obj.rot)
                    task.New(obj, function()
                        obj.rect = true
                        obj.a = 6
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
                            obj.x, obj.y = mst.x, mst.y
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
                --case：初始弹速
                local v0 = switch1(diff, {
                    2, 2.25, 2.5, 2.75, no_info
                })*defaultSwitchVelocityByRank(rank)
                --case：每层弹速差
                local dv = switch1(diff, {
                    no_info, no_info, no_info, no_info
                })
                --case：最终弹速
                local v1 = switch1(diff, {
                    2, 2.5, 3, 3.5, no_info
                })*defaultSwitchVelocityByRank(rank)
                local style = stg.arrow_mid
                local function attack(x, y, a, sp, color)
                    local function bullet_func(x, y, v, a)
                        B.bullet1.create(x, y, v0, v, a, style, color)
                    end
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_layer2(x, y, v1, a, way, sp, --base
                                        layer, dv, 0, --layer, dv_l, da_l
                                        bullet_func
                                )
                            end)
                end
                return attack
            end
    )
    --endregion
    --region Tasker 任务执行器
    local T = {}
    --弓形发射器
    T.tasker1 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                --case：发射次数
                local count = switch1(diff, {
                    6, 10, 12, 15, no_info
                })
                local wait = 60/count
                --case：角度差
                local da0 = switch1(diff, {
                    17.5, 15, 12.5, 10, no_info
                })
                local da = 120/count
                local function create(b, x, y, a, color)
                    boss.createTasker(b, x, y, function(obj)
                        velchTask(obj, 4, 0, a, 60, 0)
                        task.New(obj, function()
                            for i = 0, count - 1 do
                                P.pointer1.attack(obj.x, obj.y, a, (da0 + 2*da)*i, color)
                                task.Wait(wait)
                            end
                            PlaySound("lazer00")
                            B.bullet2.create(obj.x, obj.y, a, color) --拖尾弹
                            Del(obj)
                        end)
                    end, false) --不拖延
                end
                return create
            end)
    --endregion
    --region 组合攻击
    local C = {} --combination
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                --case：攻击次数
                local count = switch1(diff, {
                    3, 4, 5, 6, no_info
                })*switch(rank, {
                    1, 1, 1, 1, 2
                })
                --case：每次攻击间隔
                local wait = switch(rank, {
                    80, 80, 80, 70, 60
                })/count
                --每次攻击角度差
                local da = 120*switch(rank, {
                    1, 1, 1, 1, 2
                })/(count - 1)
                --case：移动时间
                local move_wait = switch(rank, {
                    60, 60, 50, 50, 30
                })
                local function main(b, u, m_t)
                    task.MoveTo(b, -150*u, 144, m_t or move_wait, MOVE_ACC_DEC)
                    task.New(b, function()
                        b.cast("attack_down_before")
                        task.Wait(48)
                        for _ = 1, wait*count/12 do
                            b.cast("attack_down_ing")
                            task.Wait(12)
                        end
                    end)
                    local a0, a = 90*(u-1)
                    for i = 0, count - 1 do
                        for u = -1, 1, 2 do
                            a = a0 + da*(i + 0.5)*u
                            T.tasker1.main(b, b.x, b.y, a, COLOR_ROYAL_BLUE + 2*u)
                        end
                        task.Wait(wait)
                    end
                end
                return main
            end)
    --边移动边攻击
    C.SECOND = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                --case：攻击次数
                local count = switch1(diff, {
                    3, 4, 5, 6, no_info
                })*switch(rank, {
                    1, 1, 1, 1, 1.5
                })
                local dx = 300/count
                --case：每次攻击间隔
                local wait = switch(rank, {
                    120, 120, 120, 110, 90
                })/count
                local function main(b, u)
                    local a = -90
                    for i = 1, count do
                        task.MoveTo(b, (150 - dx*i)*u, 144, wait, MOVE_ACC_DEC)
                        T.tasker1.main(b, b.x, b.y, a, COLOR_DEEP_RED)
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
        "name-boss3-normal1-E",
        "name-boss3-normal1-N",
        "name-boss3-normal1-H",
        "name-boss3-normal1-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "normal", --类型
            {2, 2, 25},
            1200, --耐久
            system.DROP_NORMAL, --掉落
            function(b) --普通模式攻击前动作
                b.x, b.y = -300, 144
            end,
            function(b) --练习模式攻击前动作
                bgChangePr()
                b.x, b.y = -300, 144
            end,
            function(b) --main
                reFresh()
                C.FIRST.main(b, 1, 60)
                boss.show_aura(b, true)
                while true do
                    for u = -1, 1, 2 do
                        task.Wait(60)
                        reFresh()
                        C.SECOND.main(b, u)
                        --task.Wait(60)
                        C.FIRST.main(b, u)
                    end
                end
            end,
            function(b) --finish
            end,
            4, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end
return createCard