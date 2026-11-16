-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage2/spellcard/normal_3.lua" --当前存放目录
local no_info = 0
local velch = EGGlib.ObjectEvent.velocityChange
local boundWait = EGGlib.ObjectEvent.boundWait
local setSize = EGGlib.ObjectEvent.setSize
local sect_layer2 = EGGlib.BulletGroup.Sector.layer2
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local sector_circle2 = EGGlib.BulletGroup.Sector.circle2
local velch_task = EGGlib.ObjectEvent.velocityChangeTask
local move = EGGlib.ObjectEvent.moveToPlayerDefault

local function createCard(difficulty)
    --region 自定义子弹
    local B = {}
    --自定义子弹
    function B.bullet1(x, y, v0, v1, a, style, color)
        local obj = stg.newSimpleBullet(x, y, style, color)
        obj.rot = a
        setSize(obj, 1, 1)
        boundWait(obj, 180) --出屏
        task.New(obj, function()
            velch(obj, v0, 0, a, 10, 30)
            PlaySound("kira00")
            velch(obj, 0, v1, a, 150, 0)
        end)
    end
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
                    1.8, 2.15, 2.5, 3, no_info
                })*defaultSwitchVelocityByRank(rank)
                --case：每层弹速差
                local dv = switch1(diff, {
                    no_info, no_info, no_info, no_info
                })
                --case:最终弹速
                local v1 = switch1(diff, {
                    2, 2.75, 3.5, 4.5, no_info
                })*defaultSwitchVelocityByRank(rank)
                local style = stg.arrow_mid
                local function attack(x, y, a, sp, color)
                    local function bullet_func(x, y, v, a)
                        B.bullet1(x, y, v, v1, a, style, color)
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
    --开花
    P.pointer2 = EISlib.Bullet.Shooter.createPointer(
            function(diff, rank)
                local maxv = 3 --最大初始速度
                --case：每扇way数
                local way = switch1(diff, {
                    2, 3, 4, 5, no_info
                })
                --case：way数
                local way1 = switch1(diff, {
                    12, 15, 18, 24, no_info
                }) + switch(rank, {
                    0, 0, 0, 0, 6
                })
                --case：扩散角
                local sp = switch1(diff, {
                    2, 3, 4, 5, no_info
                }) + switch(rank, {
                    0, 0, 0, 0, 8
                })
                --case：初速度
                local v0 = switch1(diff, {
                    1.25, 1.5, 1.75, 2, no_info
                })*switch(rank, {
                    1, 1.05, 1.1, 1.15, 1.35
                })
                local style, color = stg.arrow_mid, COLOR_DEEP_RED
                local function bullet_func(x, y, v, a)
                    setSize(stg.newSimpleStrChV(x, y, v + (maxv - v), v, a, 20, 45, style, color), 0.75, 0.75)
                end
                local function attack(x, y, a)
                    PlaySound("kira00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sector_circle2(x, y, v0, a, way, sp, way1, bullet_func)
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
                    3, 3, 4, 5, no_info
                }) + switch(rank, {
                    0, 0, 0, 0, 1
                })
                local wait = 30/count
                --case：角度差
                local da = 60/count
                local function main(b, x, y, a, color)
                    boss.createTasker(b, x, y, function(obj)
                        velch_task(obj, 5, 0, a, 60, 0)
                        task.New(obj, function()
                            for i = 1, count do
                                P.pointer1.attack(obj.x, obj.y, a, 2*da*i, color)
                                task.Wait(wait)
                            end
                            Del(obj)
                        end)
                    end, false) --不拖延
                end
                return main
            end)
    --开花弹
    T.tasker2 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                --case：发射次数
                local count = switch1(diff, {
                    1, 2, 3, 4, no_info
                })*switch(rank, {
                    1, 1, 1, 1, 1.5
                })
                local wait = 60/count
                local function main(b, x, y, a)
                    boss.createTasker(b, x, y, function(obj)
                        task.New(obj, function()
                            for _ = 0, count - 1 do
                                P.pointer2.attack(b.x, b.y, a)
                                task.Wait(wait)
                            end
                            Del(obj)
                        end)
                    end, false)
                end
                return main
            end)
    --最恐怖的是tasker里套着tasker
    T.tasker3 = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                --case：发射次数
                local count = switch1(diff, {
                    4, 6, 6, 6, no_info
                }) + switch(rank, {
                    0, 0, 0, 0, 2
                })
                --套娃
                local function main(b, x, y, a, dcount, color)
                    local count = count + dcount
                    local wait = 60/count
                    --case：角度差
                    local da = 135/count
                    boss.createTasker(b, x, y, function(obj)
                        velch_task(obj, 5, 0, a, 60, 0)
                        task.New(obj, function()
                            local r, dr, dx, dy = -100, 120/(count - 1), cos(a), sin(a)
                            for i = 1, count do
                                for u = -1, 1, 2 do
                                    T.tasker1.main(b, obj.x + r*dx, obj.y + r*dy, a + (20 + da*i)*u, color) --套娃
                                end
                                task.Wait(wait)
                                r = r + dr
                            end
                            Del(obj)
                        end)
                    end, false) --不拖
                end
                return main
            end)
    --endregion
    --region 组合攻击
    local C = {} --combination
    C.FIRST = EISlib.Bullet.Shooter.createStep(
            function(diff, rank)
                --case：发射次数
                local way = switch1(diff, {
                    3, 3, 3, 3, no_info
                })
                local sp = 360*(way - 1)/way
                --case：角度差
                local a0 = switch1(diff, {
                    0, 0, 0, 0, no_info
                })
                --case：每波次数差比率
                local dcount_rate = switch1(diff, {
                    1, 2, 3, 4, no_info
                })/2
                local color = {COLOR_DEEP_BLUE, COLOR_DEEP_GREEN, COLOR_DEEP_RED}
                local function main(b, dcount)
                    task.New(b, function()
                        b.cast("attack_down_before")
                        task.Wait(48)
                        b.cast("attack_down_ing")
                    end)
                    local a = a0 + Angle(b, player) + ran:Float(-10, 10)
                    local way0 = (way - 1)/2
                    local count = 1
                    for i = -way0, way0 do
                        T.tasker3.main(b, b.x, b.y, a + sp*i, int(dcount*dcount_rate), color[count])
                        count = count + 1
                    end
                    task.Wait(120)
                    move(60, b)
                    task.Wait(60)
                end
                return main
            end)
    --endregion

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
            rank = new_rank
        end
    end
    
    local names = {
        "name-boss3-normal4-E",
        "name-boss3-normal4-N",
        "name-boss3-normal4-H",
        "name-boss3-normal4-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            names[difficulty], --非/符卡名
            "normal", --类型
            {3, 3, 30},
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
                local i = 0
                while true do
                    reFresh()
                    C.FIRST.main(b, min(2, i))
                    i = i + 1
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