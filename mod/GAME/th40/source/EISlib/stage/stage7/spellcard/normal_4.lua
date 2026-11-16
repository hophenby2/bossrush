-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."stage7/spellcard/normal_5.lua" --当前存放目录
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

local function createCard(difficulty)
    local B, P, S, C, T, E, D = {}, {}, {}, {}, {}, {}, {}
    --region Bullet 自定义子弹
    B.bool_ball = EISlib.Bullet.Shooter.createBulletClass(
            function(diff, rank)
                local v = 4*defaultSwitchVelocityByRank(rank)
                local v0 = 3*defaultSwitchVelocityByRank(rank)
                local wait = switch(rank, {
                    3, 3, 3, 3, 2
                })
                local da = 5*wait
                local function create(x, y, a, u)
                    PlaySound("kira00")
                    local obj = stg.newSimpleBullet(x, y, stg.ball_wool, COLOR_DEEP_RED, true)
                    obj.omiga = 3
                    setSizeAndColli(obj, 0.1, 0.1)
                    obj.colli = false
                    task.New(obj, function()
                        spSizeAndColliChange(obj, 2.9, 30, 120)
                        obj.colli = true
                        --球逐渐缩小，毛线散开
                        sizeAndColliChangeTask(obj, -2.5, 180)
                        velchTask(obj, 0, v, a, 60)
                        local dx, dy, r = cos(a + 180), sin(a + 180)
                        for i = 0, _infinite do
                            r = obj.hscale*10
                            stg.newStrChV(obj.x + r*dx, obj.y + r*dy, 0, v0, a + (180 + da*i)*u, 300, 0, stg.grain_b, COLOR_RED, false, 1)
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
                local t0 = 64
                local dt = 1
                local ds = -2/t0
                local v0 = 1.25*defaultSwitchVelocityByRank(rank)
                local dv = 0.0225*defaultSwitchVelocityByRank(rank)
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
                    --setSize(obj, 3 + ds*i*dt, 3 + ds*i*dt)
                    task.New(obj, function()
                        --alphaAndSizeChange(obj, 255, 1 - obj.hscale, t)
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

    --endregion
    --region 自定义敌人
    --endregion
    --region Tasker 任务执行器
    --毛线球产生器
    T.wool_ball_creator = EISlib.Bullet.Shooter.createTasker(
            function(diff, rank)
                local count = 64
                local da = switch(rank, {
                    720, 720, 720, 720, 840
                })/count
                local wait = 1
                local function main(x, y, a0, u)
                    boss.createTasker(_boss, x, y,
                            function(obj)
                                task.New(obj, function()
                                    for i = 0, count - 1 do
                                        B.ball_mid.create(x, y, a0 + da*i*u, i)
                                        task.Wait(wait)
                                    end
                                    --task.Wait(12)
                                    B.bool_ball.create(x, y, a0, u)
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
                local way = 6
                local da = 360/way
                local da_c = 0.33*da
                local function main(b, count_i, u)
                    local a0, a = ran:Float(-95, -85) + count_i*da_c
                    for i = 0, way - 1 do
                        a = a0+da*i
                        T.wool_ball_creator.main(b.x + 100*cos(a), b.y + 100*sin(a), a, u)
                    end
                    task.Wait(180)
                    move(60, b)
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

    local card = EGGlib.BossCard.createFullCard(
            "name-boss9-normal4", --非/符卡名
            "normal", --类型
            {3, 3, 40}, --时间
            1600, --耐久
            system.DROP_NORMAL, --掉落
            function(b) --普通模式攻击前动作
                boss.show_aura(b, true)
                task.wait(60)
                task.MoveTo(b, 0, 144, 60, MOVE_ACC_DEC)
            end,
            function(b) --练习模式攻击前动作
                b.x, b.y = 0, 144
                boss.show_aura(b, true)
            end,
            function(b) --main
                local i = 1
                while true do
                    for u = -1, 1, 2 do
                        reFresh()
                        C.FIRST.main(b, i, u)
                        i = i + 1
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
