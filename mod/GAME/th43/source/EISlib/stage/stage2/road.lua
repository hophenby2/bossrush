-----------------------------------------
---东方栖霞园道中 Stage2
-----------------------------------------
---@class  EISlib.stage.stage2.road
--现在整个道中也是一个对象
local R = Class(object)
function R:init()
    self.timer = 0
    lstg.tmpvar.current_road = self --当前道中对象是自己
end
function R:frame()
    task.Do(self)
end
--获取当前场景阶段
function R:getSence()
    return self.sence
end

--素材加载
local function loadRes()
    local res_name = "s2_"
    local path = "res/stage/stage2/"
    --关卡标题
    LoadImageFromFile(res_name.."title1", path.."title1.png")
    LoadImageFromFile(res_name.."bubble", path.."bubble_img.png")
    LoadAniFromFile(res_name.."bubble_boom", path.."bubble_boom.png", true, 7, 1, 4)
end


local BS = EISlib.Bullet.Shooter
local no_info = 0
local no_info_t = 9999
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local sty = EISlib.Enemy.Style
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local sect_layer1 = EGGlib.BulletGroup.Sector.layer1
local argbChangeTask = EGGlib.ObjectEvent.argbChangeTask
local setProtectTime = EGGlib.ObjectEvent.setProtectTime
local alphaChange = EGGlib.ObjectEvent.alphaChange
local changeVelocityTask = EGGlib.ObjectEvent.changeVelocityTask
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local setSize = EGGlib.ObjectEvent.setSize
local sizeChange = EGGlib.ObjectEvent.sizeChange
local sect_layer2 = EGGlib.BulletGroup.Sector.layer2
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local moveWith = EGGlib.ObjectEvent.rotateMoveWith2
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local circle_normal1 = EGGlib.BulletGroup.Circle.normal1
local sect_normal1 = EGGlib.BulletGroup.Sector.normal1

local E = {} --enemy define
R.E = E
local B = {} --bullet define
R.B = B
local P = {} --pointer define(one point)
R.P = P
local S = {} --shooter define
R.S = S
local T = {} --task define
R.T = T
local O = {} --object define
R.O = O
local D = {} --death define
R.D = D

--每次rank变化时都要update一次
function R.updateByRankChange()
    local diff = difficulty
    local rank = system.PowerRank.getRank()
    for _, v in pairs(P) do
        v.update(diff, rank)
    end
    for _, v in pairs(S) do
        v.update(diff, rank)
    end
    for _, v in pairs(E) do
        v.update(diff, rank)
    end
    for _, v in pairs(O) do
        v.update(diff, rank)
    end
    for _, v in pairs(T) do
        v.update(diff, rank)
    end
    for _, v in pairs(B) do
        v.update(diff, rank)
    end
    for _, v in pairs(D) do
        v.update(diff, rank)
    end
end

--region Bullet Defined
--tkz二道中粉弹蝴蝶弹幕
B.bullet2 = BS.createBulletClass(
        function(diff, rank)
            local v0 = switch1(diff, {
                2, 2.33, 2.67, 3, 3
            })*switch(rank, {
                0.9, 0.95, 1, 1.05, 1.05
            })
            local function create(x, y, dv, a, u)
                local obj = stg.newSimpleBullet(x, y, stg.grain_a, COLOR_CYAN)
                changeVelocityTask(obj, v0 + dv, v0 + dv, a, 120*u, 1, 60, true)
                return obj
            end
            return create
        end
)
--tkz三面粉中玉大蝴蝶的中玉
B.bullet5 = BS.createBulletClass(
        function(diff, rank)
            local v0 = switch1(diff, {
                2, 2, 2, 2, 2
            })*defaultSwitchVelocityByRank(rank)
            local wait = 6
            local count0 = 16
            local dcount = switch1(diff, {
                3, 2, 1, 0, 0
            })
            local count1 = switch1(diff, {
                1, 1, 2, 2, 2
            })
            local wait1 = 60/count1
            local function create(x, y, a)
                local obj = stg.newSimpleBullet(x, y, stg.ball_mid_c, COLOR_DEEP_BLUE)
                SetV(obj, v0, a)
                --米弹
                task.New(obj, function()
                    task.Wait(wait*dcount)
                    for _ = 1, count0 - 2*dcount do
                        B.bullet5_1.create(obj.x, obj.y, a)
                        task.Wait(wait)
                    end
                end)
                --开花
                task.New(obj, function()
                    task.Wait(60)
                    local r, da
                    for i = 0, count1 - 1 do
                        r, da = ran:Float(30, 50), ran:Float(135, 180)*ran:Sign()
                        B.bullet5_2.create(obj.x + r*cos(a + da), obj.y + r*sin(a + da), a + ran:Float(-15, 15), (count1 - i - 1)*(wait1 + 10))
                        task.Wait(wait1)
                    end
                end)
                return obj
            end
            return create
        end
)

--会逐渐消失的米弹
B.bullet5_1 = BS.createBulletClass(
        function(diff, rank)
            local function create(x, y, a)
                local obj = stg.newBullet(x, y, stg.grain_a, COLOR_DEEP_BLUE)
                obj.rot = a
                robject.set_color(obj, "", 255, 255, 255, 255)
                task.New(obj, function()
                    task.Wait(30)
                    obj.colli = false
                    alphaChange(obj, 255, 0, 30)
                    _del(obj, false)
                end)
                return obj
            end
            return create
        end
)

--花
B.bullet5_2 = BS.createBulletClass(
        function(diff, rank)
            local v0 = switch1(diff, {
                1.25, 1.5, 1.75, 2, 2
            })*defaultSwitchVelocityByRank(rank)
            local function Task(obj, r, a0, a1, s, dt)
                obj.colli = false
                setSize(obj, 0, 0)
                task.New(obj, function()
                    local dr, ds, x, y, dx, dy = r/20, s/20, obj.x, obj.y, cos(a0), sin(a0)
                    r = 0
                    for _ = 1, 20 do
                        obj.hscale, obj.vscale = obj.hscale + ds, obj.vscale + ds
                        r = r + dr
                        obj.x, obj.y = x + r*dx, y + r*dy
                        task.Wait(1)
                    end
                    obj.colli = true
                    task.Wait(30 + dt)
                    velch(obj, 0, v0, a1, 60)
                end)
            end
            local function create(x, y, a, dt)
                local obj = stg.newSimpleBullet(x, y, stg.ball_mid_c, COLOR_BLUE)
                robject.set_color(obj, "", 255, 255, 255, 255)
                Task(obj, 0, a, a, 0.75, dt)
                for i = 1, 6 do
                    obj = stg.newSimpleBullet(x, y, stg.grain_a, COLOR_BLUE)
                    robject.set_color(obj, "", 255, 255, 255, 255)
                    obj.rot = a + 60*i
                    Task(obj, 8, a + 60*i, a, 0.6, dt)
                end
                return obj
            end
            return create
        end
)

--逐渐消失的环玉
B.bullet9 = BS.createBulletClass(
        function(diff, rank)
            local v0 = switch1(diff, {
                1.4, 1.6, 1.8, 2, 2
            })*defaultSwitchVelocityByRank(rank)
            local wait = switch1(diff, {
                120, 120, 120, 120, 120
            })
            local function create(x, y, a)
                local obj = stg.newStrChV(x, y, 0, v0, a, 120, 0, stg.ball_mid_c, COLOR_CYAN)
                robject.set_color(obj, "mul+add", 255, 255, 255, 255)
                task.New(obj, function()
                    task.Wait(wait)
                    obj.colli = false
                    alphaChange(obj, 255, 0, 30)
                    Del(obj)
                end)
                return obj
            end
            return create
        end
)
--endregion

--region Pointer Defined
--基础道中自机狙发射点
P.pointer1 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                1, 2, 3, 4, 4
            }) + switch(rank, {
                0, 0, 0, 0, 1
            })
            local da = 10
            --case：层数
            local layer = switch1(diff, {
                1, 1, 1, 1, 1
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                1.5, 2, 2.5, 3, 3
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = switch1(diff, {
                no_info, no_info, no_info, no_info, no_info
            })
            local style, color = stg.grain_a, COLOR_CYAN
            local function bullet_func(x, y, v, a)
                stg.newSimpleStraight(x, y, v, a, style, color)
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            sect_layer1(x, y, v0, a, way, da, --base
                                    layer, dv, 0, --layer, dv_l, da_l
                                    bullet_func
                            )
                        end)
            end
            return attack
        end
)

--tkz二道中粉弹蝴蝶弹幕
P.pointer2 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                9, 12, 15, 18, 18
            })
            --case：层数
            local layer = 1
            --case:hyper模式下变成螺旋状子弹
            local way_hyper = switch(rank, {
                1, 1, 1, 1, 2
            })
            --case：每层弹速差
            local dv = switch1(diff, {
                -0.5, -0.5, -0.5, -0.5, -0.5
            })
            local style, color = stg.grain_a, COLOR_CYAN
            local function attack(x, y, a, da, u)
                PlaySound("kira00")
                local u0 = (way_hyper - 1)/2*u
                local function bullet_func(x, y, dv, a)
                    if way_hyper == 1 then
                        B.bullet2.create(x, y, dv, a + da*u, u)
                    else
                        for u = -u0, u0, 2*u0 do
                            B.bullet2.create(x, y, dv, a + da*u, u)
                        end
                    end
                end
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            --注意，因为已经事先在特殊子弹里定义好了初弹速，所以填0
                            circle_layer1(x, y, 0, a, way, --x, y, v, a, way
                                    layer, dv, 0, 0, bullet_func --layer, dv, da, dway, func
                            )
                        end)
            end
            return attack
        end
)

--tkz二道中粉开花弹蝴蝶
P.pointer3 = BS.createPointer(
        function(diff, rank)
            local style, color = stg.ball_mid_c, COLOR_DEEP_BLUE
            local way = switch1(diff, {
                8, 12, 16, 20, 20
            })
            local layer = switch1(diff, {
                1, 2, 3, 4, 4
            }) + switch(rank, {
                0, 0, 0, 0, 1
            })
            local v0 = switch1(diff, {
                2, 2.2, 2.35, 2.5, 2.5
            })*defaultSwitchVelocityByRank(rank)
            local dv = switch1(diff, {
                0.45, 0.45, 0.45, 0.45, 0.45
            })*defaultSwitchVelocityByRank(rank)
            local function bullet_func(x, y, v, a)
                for i = 0, layer - 1 do
                    stg.newSimpleStrChV(x, y, 0.5, v + dv*i, a, 30, 30, style, color)
                end
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            circle_normal1(x, y, v0, a, way, bullet_func)
                        end)
            end
            return attack
        end
)

--独立的鬼火自机狙
P.pointer4 = BS.createPointer(
        function(diff, rank)
            local layer = switch1(diff, {
                1, 2, 3, 3, 3
            })
            local way = switch1(diff, {
                1, 1, 1, 3, 3
            })
            local da = switch1(diff, {
                0, 0, 0, 40, 40
            })
            local v0 = switch1(diff, {
                1.5, 1.75, 2, 2.25, 2.25
            })*defaultSwitchVelocityByRank(rank)
            local dv = switch1(diff, {
                0.22, 0.22, 0.22, 0.22, 0.22
            })*defaultSwitchVelocityByRank(rank)
            local style, color = stg.ball_mid, COLOR_DEEP_BLUE
            local function bullet_func(x, y, v, a)
                stg.newSimpleStraight(x, y, v, a, style, color)
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            sect_layer1(x, y, v0, a,
                                    way, da,
                                    layer, dv, 0,
                                    bullet_func
                            )
                        end)
            end
            return attack
        end
)

--tkz三面大蝴蝶
P.pointer5 = BS.createPointer(
        function(diff, rank)
            local style, color = stg.grain_a, COLOR_RED
            local way = switch1(diff, {
                6, 9, 12, 15, 18
            }) + switch(rank, {
                0, 0, 0, 0, 3
            })
            local function bullet_func(x, y, v, a)
                B.bullet5.create(x, y, a)
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            circle_normal1(x, y, 0, a, way, bullet_func)
                        end)
            end
            return attack
        end
)

--tkz三面阴阳玉
P.pointer6 = BS.createPointer(
        function(diff, rank)
            local way = switch(rank, {
                1, 1, 1, 1, 2
            })
            local layer = switch1(diff, {
                1, 2, 2, 3, 3
            })
            local v0 = switch1(diff, {
                1.5, 1.75, 2, 2.25, 2.25
            })*defaultSwitchVelocityByRank(rank)
            local dv = switch1(diff, {
                0.22, 0.22, 0.22, 0.22, 0.22
            })*defaultSwitchVelocityByRank(rank)
            local style, color = stg.ball_mid, COLOR_DEEP_BLUE
            local function bullet_func(x, y, v, a)
                for i = 0, layer - 1 do
                    for j = 0, way - 1 do
                        stg.newSimpleStraight(x, y, v + dv*i, a + 180*j, style, color)
                    end
                end
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            bullet_func(x, y, v0, a)
                        end)
            end
            return attack
        end
)

--tkz三面鬼火(独立的鬼火自机狙强化）
P.pointer7 = BS.createPointer(
        function(diff, rank)
            local way = switch1(diff, {
                1, 3, 3, 3, 3
            }) + switch(rank, {
                0, 0, 0, 0, 2
            })
            local da = 30
            local layer = switch1(diff, {
                1, 1, 2, 3, 3
            })
            local v0 = switch1(diff, {
                1.5, 1.5, 2, 2, 2
            })*defaultSwitchVelocityByRank(rank)
            local dv = switch1(diff, {
                0, 0.5, 1, 1, 1
            })*defaultSwitchVelocityByRank(rank)
            local s0, ds = 1, 0
            local style, color = stg.ball_mid_c, COLOR_DEEP_BLUE
            local function bullet_func(x, y, v, a)
                for i = 0, layer - 1 do
                    setSizeAndColli(stg.newSimpleStraight(x, y, v + dv*i, a, style, color), s0 + ds*i, s0 + ds*i)
                end
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            sect_normal1(x, y, v0, a, way, da, bullet_func)
                        end)
            end
            return attack
        end
)

--发固定弹的小妖精
P.pointer8 = BS.createPointer(
        function(diff, rank)
            local way = 4 + switch(rank, {
                0, 0, 0, 0, 1
            })
            local da = 30
            local layer = switch1(diff, {
                2, 3, 4, 5, 5
            })
            local v0 = switch1(diff, {
                1.3, 1.3, 1.3, 1.3, 1.3
            })*defaultSwitchVelocityByRank(rank)
            local dv = switch1(diff, {
                0.43, 0.43, 0.43, 0.43, 0.43
            })*defaultSwitchVelocityByRank(rank)
            local style, color = stg.ball_mid, COLOR_BLUE
            local function bullet_func(x, y, v, a)
                stg.newSimpleStraight(x, y, v, a, style, color)
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            sect_layer1(x, y, v0, a,
                                    way, da,
                                    layer, dv, 0,
                                    bullet_func
                            )
                        end)
            end
            return attack
        end
)

--endregion

--region Shooter Defined
--向下发射的弹幕
S.shooter1 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                60, 45, 30, 15, 0
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                180, 180, 180, 180, 180
            })

            local wait = switch1(diff, {
                80, 70, 60, 60, 60
            })

            local a_range = switch1(diff, {
                10, 15, 20, 30, 30
            })/2
            local function shooter(e, dt, co)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            local da
                            while true do
                                da = ran:Float(-a_range, a_range)
                                P.pointer1.attack(e.x, e.y, -90 + da, co)
                                P.pointer1.attack(e.x, e.y, -90 + da + 180, co)
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

--tkz二道中粉弹蝴蝶弹幕
S.shooter2 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                20, 15, 10, 0, 0
            }) + switch(rank, {
                30, 30, 30, 30, 30
            })
            --case：持续攻击时间
            local total_time = 600

            local count = switch1(diff, {
                6, 8, 10, 12, 12
            })
            local wait = 120/count
            local da = 6
            local function shooter(e, u, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            local a
                            for _ = 1, 2 do
                                a = ran:Float(0, 360)
                                for i = 0, count - 1 do
                                    P.pointer2.attack(e.x, e.y, a, da*i, u)
                                    task.Wait(wait)
                                end
                                task.Wait(120)
                            end
                        end
                )
            end
            return shooter
        end
)

--tkz二道中粉开花弹蝴蝶
S.shooter3 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                40, 40, 35, 30, 30
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                180, 180, 180, 180, 180
            })
            local count = 2
            local wait = switch1(diff, {
                120, 110, 100, 90, 90
            })
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            for _ = 0, count - 1 do
                                P.pointer3.attack(e.x, e.y, Angle(e, player))
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

--独立的鬼火自机狙
S.shooter4 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                60, 50, 40, 30, 30
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                180, 180, 180, 180, 180
            })
            local count = switch1(diff, {
                1, 3, 5, 7, 7
            })
            local wait = switch1(diff, {
                60, 50, 40, 30, 30
            })
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            for _ = 0, count - 1 do
                                P.pointer4.attack(e.x, e.y, Angle(e, player))
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

--tkz三面大蝴蝶
S.shooter5 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                50, 45, 40, 30, 30
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                180, 180, 180, 180, 180
            })
            local count = switch1(diff, {
                2, 2, 3, 3, 3
            })
            local wait = 180/count
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            for _ = 0, count - 1 do
                                P.pointer5.attack(e.x, e.y, -90)
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

--tkz三面阴阳玉
S.shooter6 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                45, 40, 35, 30, 30
            })
            --case：持续攻击时间
            local total_time = 180 + start_time_left
            local wait = switch1(diff, {
                30, 30, 20, 20, 20
            })
            local da = 2*wait
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            local a, i = Angle(e.vx, e.vy, 0, 0), 0
                            while true do
                                P.pointer6.attack(e.x, e.y, a + da*i)
                                task.Wait(wait)
                                i = i + 1
                            end
                        end
                )
            end
            return shooter
        end
)

--tkz三面鬼火(独立的鬼火自机狙强化）
S.shooter7 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                45, 40, 35, 30, 30
            })
            --case：持续攻击时间
            local total_time = 225
            local count = switch1(diff, {
                3, 3, 5, 5, 5
            })
            local wait = math.floor(225/count)
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            for _ = 0, count - 1 do
                                P.pointer7.attack(e.x, e.y, Angle(e, player))
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

--发自机狙的小妖精
S.shooter8 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = 0
            --case：持续攻击时间
            local total_time = 121
            local count = switch1(diff, {
                2, 2, 3, 3, 3
            })
            local wait = 60
            local function shooter(e, u, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            for _ = 0, count - 1 do
                                PlaySound("tan00")
                                P.pointer8.attack(e.x, e.y, Angle(e, player))
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

--泡泡产生的弹幕
S.shooter9 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = 30
            --case：持续攻击时间
            local total_time = 91
            local sp = 4
            local count = switch1(diff, {
                4, 6, 8, 10, 10
            }) + switch(rank, {
                0, 0, 0, 0, 2
            })
            local wait = math.floor((total_time - start_time_left - 1)/(count - 1))
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            for _ = 0, count - 1 do
                                PlaySound("kira00")
                                B.bullet9.create(e.x, e.y, -90 + ran:Float(-0.5*sp, 0.5*sp))
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

--下蛋
S.shooter9_1 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                20, 20, 20, 20, 20
            })
            --case：持续攻击时间
            local total_time = 180
            local function shooter(e, dt, u)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            for _ = 1, 8 do
                                PlaySound("cancel00") --吹泡泡的声音
                                O.bubble1.create(e.x, e.y, u, dt)
                                task.Wait(10)
                            end
                        end
                )
            end
            return shooter
        end
)
--endregion

--region Tasker Defined
--小怪向某方向离开屏幕
T.leaveScreen1 = BS.createTasker(
        function(diff, rank)
            local function main(obj, a)
                task.New(obj, function()
                    velch(obj, 0, 2.5, a, 30)
                end)
            end
            return main
        end
)

--先停留一会儿，再向某方向离开屏幕
T.leaveScreen2 = BS.createTasker(
        function(diff, rank)
            local function main(obj, a)
                task.New(obj, function()
                    velch(obj, -0.1, 1.2, a, 90, 150)
                end)
            end
            return main
        end
)

--排队快速离开屏幕的妖精
T.leaveScreen3 = BS.createTasker(
        function(diff, rank)
            local function main(obj, a)
                task.New(obj, function()
                    velch(obj, 1, 4, a, 90)
                end)
            end
            return main
        end
)

--快速溜出屏幕的下蛋妖精
local accDecVelch = EGGlib.ObjectEvent.accDecVelocityChange
T.leaveScreen4 = BS.createTasker(
        function(diff, rank)
            local function main(obj, u)
                robject.set_color(obj, "", 200, 0, 0, 0)
                obj.colli = false
                argbChangeTask(obj, obj._a, obj._r, obj._g, obj._b, 110, false, true)
                task.New(obj, function()
                    accDecVelch(obj, 5.5, 90 - 80*u, 30, 50, 30)
                    velch(obj, 0, 4, 90 + 90*u, 30)
                end)
            end
            return main
        end
)

--鬼火移动
T.ghostFireMove1 = BS.createTasker(
        function(diff, rank)
            local function main(obj, u)
                local x0 = obj.x --中心x坐标
                --纵向动作
                task.New(obj, function()
                    velchTask(obj, 2, 0, -90, 60, 120)
                    task.Wait(60)
                    --横向移动
                    task.New(obj, function()
                        local v, dv = 0, 2/60*u
                        for _ = 1, 60 do
                            v = v + dv
                            x0 = x0 + v
                            task.Wait(1)
                        end
                        dv = -dv
                        for _ = 1, 60 do
                            v = v + dv
                            x0 = x0 + v
                            task.Wait(1)
                        end
                    end)
                    task.Wait(60)
                    velchTask(obj, 0, 2, 90, 60)
                end)
                --横向动作
                task.New(obj, function()
                    local t = 0
                    while true do
                        obj.x = x0 + 30*sin(t)
                        task.Wait(1)
                        t = t + 3*u
                    end
                end)
            end
            return main
        end
)

--移动到指定位置然后离开，移动的过程中处于黑渐变无判定状态
T.move1_2 = BS.createTasker(
        function(diff, rank)
            local function main(obj, x, y, r, a, a2)
                robject.set_color(obj, "", 100, 0, 0, 0)
                obj.colli = false
                task.New(obj, function()
                    argbChangeTask(obj, obj._a, obj._r, obj._g, obj._b, 60)
                    task.MoveTo(obj, x + r*cos(a), y + r*sin(a), 60, MOVE_ACC_DEC)
                    obj.colli = true
                    velch(obj, 0, 2, a2, 120)
                end)
            end
            return main
        end
)

--移动到指点位置然后离开
T.moveTo1 = BS.createTasker(
        function(diff, rank)
            local function main(obj, x, y, r, a)
                task.New(obj, function()
                    task.MoveTo(obj, x + r*cos(a), y + r*sin(a), 60, MOVE_ACC_DEC)
                    velch(obj, 0, 2, a, 120)
                end)
            end
            return main
        end
)

--移动到指点位置然后离开（更慢）
T.moveTo2 = BS.createTasker(
        function(diff, rank)
            local function main(obj, x, y, r, a)
                task.New(obj, function()
                    task.MoveTo(obj, x + r*cos(a), y + r*sin(a), 90, MOVE_ACC_DEC)
                    task.Wait(60)
                    velch(obj, 0, 2, a, 120)
                end)
            end
            return main
        end
)

--阴阳玉移动到指点位置然后离开（更慢）
T.moveTo3 = BS.createTasker(
        function(diff, rank)
            local function main(obj, x, y, r, a, a2)
                a2 = a2 or 90
                obj.colli = false
                robject.set_color(obj, "", 0, 0, 0, 0)
                task.New(obj, function()
                    local dr, d = r/90, 255/90
                    r = 0
                    for _ = 1, 90 do
                        r = r + dr
                        a = a + 1
                        obj.x, obj.y = x + r*cos(a), y + r*sin(a)
                        obj._a, obj._r, obj._g, obj._b = obj._a + d, obj._r + d, obj._g + d, obj._b + d
                        task.Wait(1)
                    end
                    obj.colli = true
                    task.Wait(60)
                    velch(obj, 0, 2, a2, 120)
                end)
            end
            return main
        end
)

--同上，不过速度会更慢一些，适用于中型敌人
T.moveAndLeaveScreen1 = BS.createTasker(
        function(diff, rank)
            local function main(obj, a)
                task.New(obj, function()
                    velch(obj, 2, 0.5, a, 30, 30)
                    task.Wait(90)
                    velch(obj, 0, 1, a, 30)
                end)
            end
            return main
        end
)

--
T.move2_1 = BS.createTasker(
        function(diff, rank)
            local function main(obj, a)
                task.New(obj, function()
                    velch(obj, 2, 0.125, a, 30, 30)
                    task.Wait(480)
                    velch(obj, 0, 1, a, 30)
                end)
            end
            return main
        end
)

--从一个方向运动，然后旋转90度离开
local vach2 = EGGlib.ObjectEvent.addChangeVelocity
T.moveAndLeaveScreen2 = BS.createTasker(
        function(diff, rank)
            local function main(obj, a, u)
                task.New(obj, function()
                    velch(obj, 3, 2, a, 30)
                    vach2(obj, 2.5, 90*u, 45, 45) --dv, da, tv, ta
                    obj.bound = true
                end)
            end
            return main
        end
)

--同上，移动一会儿，停一会儿，再移动（适用于大型敌人）
T.moveAndLeaveScreen3 = BS.createTasker(
        function(diff, rank)
            local function main(obj, a)
                task.New(obj, function()
                    velch(obj, 2, 0.25, a, 30, 30)
                    task.Wait(240)
                    velch(obj, 0, 0.5, a, 30)
                end)
            end
            return main
        end
)

--高潮部分的小怪
T.moveAndLeaveScreen4 = BS.createTasker(
        function(diff, rank)
            local function main(obj, a, u)
                task.New(obj, function()
                    velch(obj, 3.5, 0.25, a, 60, 60)
                    task.Wait(60)
                    velch(obj, 0, 3, a - 90, 30)
                end)
            end
            return main
        end
)
--跟随
T.moveWith1 = BS.createTasker(
        function(diff, rank)
            local function main(obj, mst, r, a)
                _connect(mst, obj, 0.75, true)
                robject.set_color(obj, "", 0, 255, 255, 255)
                alphaChangeTask(obj, 0, 255, 30)
                obj.colli = false
                task.New(obj, function()
                    moveWith(obj, mst, r, a, 0, 30)
                    obj.colli = true
                end)
            end
            return main
        end
)

T.moveWith2 = BS.createTasker(
        function(diff, rank)
            local function main(obj, mst, dx, dy)
                _connect(mst, obj, 0.75, true)
                robject.set_color(obj, "", 0, 255, 255, 255)
                alphaChangeTask(obj, 0, 255, 30)
                obj.colli = false
                task.New(obj, function()
                    local t, x, y = 30, 0, 0
                    dx, dy = dx/t, dy/t
                    for _ = 1, t do
                        if IsValid(mst) then
                            x, y = x + dx, y + dy
                            obj.x, obj.y = mst.x + x, mst.y + y
                        else
                            break
                        end
                        task.Wait(1)
                    end
                    obj.colli = true
                    while IsValid(mst) do
                        obj.x, obj.y = mst.x + x, mst.y + y
                        task.Wait(1)
                    end
                end)
            end
            return main
        end
)
--endregion


--region Enemy Defined
--向下发射的弹幕（秋天妖精
E.enemy1 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, hp, dt)
                local obj = New(enemy, x, y, sty.FAIRY_SMALL_BLUE, --style
                        hp, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                S.shooter1.main(obj, dt)
                return obj
            end
            return create
        end
)

--tkz二道中粉弹蝴蝶
E.enemy2 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, hp, dt, u)
                local obj = New(enemy, x, y, sty.FAIRY_LARGE_4_BLUE, --style
                        hp, --hp
                        true,  --show_hpbar
                        system.DROP_MID_ENEMY, --drop
                        false, --no_count
                        nil, --death_func
                        true --type
                )
                enemy.changeAura(obj, COLOR_RED, "middle")
                S.shooter2.main(obj, u, dt)
                return obj
            end
            return create
        end
)

--tkz二道中粉开花弹蝴蝶
E.enemy3 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, hp, dt)
                local obj = New(enemy, x, y, sty.FAIRY_MIDDLE_RED, --style
                        hp, --hp
                        true,  --show_hpbar
                        system.DROP_MID_ENEMY, --drop
                        false, --no_count
                        nil, --death_func
                        true --type
                )
                S.shooter3.main(obj, dt)
                return obj
            end
            return create
        end
)

--独立的鬼火自机狙
E.enemy4 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, hp, dt)
                local obj = New(enemy, x, y, sty.FIRE_BLUE, --style
                        hp, --hp
                        false, --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                obj.show_aura = true
                S.shooter7.main(obj, dt)
                return obj
            end
            return create
        end
)

--tkz三面大蝴蝶
E.enemy5 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, hp, dt)
                local obj = New(enemy, x, y, sty.FAIRY_LARGE_4_BLACK, --style
                        hp, --hp
                        true,  --show_hpbar
                        system.DROP_MID_ENEMY, --drop
                        false, --no_count
                        nil, --death_func
                        true --type
                )
                enemy.changeAura(obj, COLOR_BLUE, "middle")
                S.shooter5.main(obj, dt)
                return obj
            end
            return create
        end
)

--tkz三面阴阳玉
E.enemy6 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, hp, dt)
                local obj = New(enemy, x, y, sty.TAICHI_BLUE, --style
                        hp, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                obj.rot = 6
                S.shooter6.main(obj, dt)
                return obj
            end
            return create
        end
)

--tkz三面鬼火(独立的鬼火自机狙强化）
E.enemy7 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, hp, dt)
                local obj = New(enemy, x, y, sty.FIRE_BLUE, --style
                        hp, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                S.shooter7.main(obj, dt)
                obj.show_aura = true
                return obj
            end
            return create
        end
)

--发固定弹的小妖精
E.enemy8 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, hp)
                local obj = New(enemy, x, y, sty.FAIRY_SMALL_5_YELLOW, --style
                        hp, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                --S.shooter8.main(obj, u, dt)
                return obj
            end
            return create
        end
)

--下蛋妖精
E.enemy9 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, hp, dt, u)
                local obj = New(enemy, x, y, sty.FAIRY_MIDDLE_2_BLUE, --style
                        hp, --hp
                        true,  --show_hpbar
                        system.DROP_BIG_ENEMY, --drop
                        false, --no_count
                        nil, --death_func
                        true --type
                )
                S.shooter9_1.main(obj, dt, u)
                return obj
            end
            return create
        end
)
--endregion

--region Object Defined
--泡泡爆炸的效果
local bubble_boom = Class(object)
function bubble_boom:init(x, y, size)
    self.x, self.y = x, y
    self.size = size
    self.img = "s2_bubble_boom"
end
function bubble_boom:frame()
    if self.timer >= 27 then Del(self) end
end
function bubble_boom:render()
    SetAnimationState(self.img, "mul+add", Color(255, 255, 255, 255))
    RenderAnimation(self.img, self.timer, self.x, self.y, 0, self.size)
end

--泡泡类定义
local bubble_class = Class(bullet)
function bubble_class:init(x, y, rot, size)
    robject.set_color(self, "", 255, 255, 255, 255)
    self.timer = 11
    self.group = GROUP_GHOST
    self.colli = false
    self.x, self.y = x, y
    self.size = size
    self.rot = rot
    self.img = "s2_bubble"
    self.hscale, self.vscale = 0, 0
end
function bubble_class:frame()
    task.Do(self)
end
function bubble_class:render()
    robject.render(self)
end
function bubble_class:colli(other)
    bullet.colli(self, other)
end
function bubble_class:kill()
    if not self.hide then
        New(bubble_boom, self.x, self.y, self.size)
    end
end
function bubble_class:del()
    if not self.hide then
        New(bubble_boom, self.x, self.y, self.size)
    end
end

--生成泡泡
local function createBubble(x, y, size, t0, t1)
    local obj = New(bubble_class, x, y, 0, size)
    robject.set_color(obj,"",255,255,255,255)
    --泡泡动态效果（代码太丑了别看了）
    local rate
    task.New(obj, function()
        t0 = t0 or 20
        t1 = t1 or 15
        local size
        do local x,_d_x=(0),(90/(t0 -1)) for _=1,t0 do
            size = obj.size
            rate = sin(x)
            obj.hscale, obj.vscale = rate*size, rate*size
            obj.a, obj.b = 16*obj.hscale, 16*obj.vscale
            task.Wait(1)
            x=x+_d_x end end
        do local x,_d_x=(0),(180/(t1 - 1)) for _=1,t1 do
            size = obj.size
            rate = sin(x)
            obj.vscale = (1 - 0.25*rate)*size
            obj.hscale = (1 + 0.1*rate)*size
            obj.a, obj.b = 16*obj.hscale, 16*obj.vscale
            task.Wait(1)
            x=x+_d_x end end
        obj.colli = true
        --泡泡的动态变化
        do local x,_d_x=(180),(6) for _=1,_infinite do
            size = obj.size
            rate = sin(x)
            obj.vscale = (1 - 0.05*rate)*size
            obj.hscale = (1 + 0.05*rate)*size
            obj.a, obj.b = 16*obj.hscale, 16*obj.vscale
            task.Wait(1)
            x=x+_d_x end end
    end)
    return obj
end


O.bubble1 = BS.createBulletClass(
        function(diff, rank)
            local function create(x, y, u, dt)
                local obj = createBubble(x, y, 0.75)
                local e = E.enemy8.create(x, y, 5) --x, y, hp
                S.shooter9.main(e, 10)
                e.colli = false
                task.New(obj, function()
                    velchTask(obj, -1, 3, 90, 30)
                    while obj.y < 210 do
                        e.x, e.y = obj.x, obj.y
                        task.Wait(1)
                    end
                    e.colli = true
                    setProtectTime(e, 30)
                    S.shooter8.main(e, u, dt)
                    T.leaveScreen1.main(e, Angle(e, player))
                    Del(obj)
                end)
                return obj
            end
            return create
        end
)
--endregion

--region 标题定义

local title, white
title = Class(object)
function title:init(x, y)
    self.x, self.y = x, y
    self.img = "s2_title1"
    self.layer = LAYER_BG + 1
    self.hscale, self.vscale = 0.75, 0
    robject.set_color(self, "", 255, 255, 255, 255)
    --形状，透明度变化
    task.New(self, function()
        for x = 0, 90, 90/30 do
            self.vscale = 0.75*sin(x)
            task.Wait(1)
        end
        task.Wait(180)
        for x = 0, 90, 90/30 do
            self._a = 255*cos(x)
            task.Wait(1)
        end
        Del(self)
    end)
end
function title:frame()
    task.Do(self)
end
function title:render()
    --DefaultRenderFunc(self)
    SetImageState(self.img, "", Color(self._a, 255, 255, 255))
    Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

--
white = Class(object)
function white:init(x, y, vy, r, g, b)
    self.x, self.y = x, y
    self.img = "white"
    self.layer = LAYER_BG
    self.vy = vy
    self.hscale, self.vscale = 100, 0
    robject.set_color(self, "", 200, r, g, b)
    task.New(self, function()
        for x = 0, 90, 90/45 do
            self.vscale = 5*sin(x)
            self._a = 200*cos(x)
            task.Wait(1)
        end
        Del(self)
    end)
end
function white:frame()
    task.Do(self)
end
function white:render()
    --DefaultRenderFunc(self)
    SetImageState(self.img, "", Color(self._a, self._r, self._g, self._b))
    Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

--title生成函数
local function createTitle(x, y)
    tasker(function()
        New(title, x, y)
        for _ = 1, 5 do
            for u = -1, 1, 2 do
                New(white, x, y - 15*u, 2*u, 65, 195, 204)
            end
            task.Wait(8)
        end
    end)
end

--endregion

function R.INIT(sence)
    system.PowerRank.resumeHyper() --从这里计时
    local self = New(R) --创建自己
    self.sence = sence or 0
    New(stage2_background, self.sence)
    loadRes()
    LoadMusicRecord("s2")

    R.updateByRankChange() --初始化一次
    
    task.Wait(60)
    self.timer = 0 --计时清零
end

--道中片段1
function R.FIRST(pratice)
    local self = lstg.tmpvar.current_road
    --0f
    local t = 0
    if IsValid(self) then
        EISlib.stage.playMusic("s2", t / 60, true) -- 要解锁音乐室
        if pratice then
            self.timer = t
        else
            --等到tf
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer >= t then
            self.sence = 1
            --小怪定义
            local createEnemyFunc1, createEnemyFunc2, createEnemyFunc3,
            createEnemyFunc4, createEnemyFunc5
            do
                --开幕扔乱弹的小怪
                function createEnemyFunc1(x, y, a)
                    local obj = E.enemy1.create(x, y, 4, 0) --x, y, hp, dt
                    T.leaveScreen1.main(obj, a)
                end
                --全屏开花小怪
                function createEnemyFunc2(x, y, a, co)
                    local obj = E.enemy3.create(x, y, 90, 0) --x, y, hp, dt
                    T.moveAndLeaveScreen1.main(obj, a)
                    enemy.changeAura(obj, co, "normal")
                end
                --扔乱弹的小怪2
                function createEnemyFunc3(x, y, a, u)
                    local obj = E.enemy1.create(x, y, 4, 0) --x, y, hp, dt
                    T.moveAndLeaveScreen2.main(obj, a, u)
                end

            end
            --道中本体
            do
                local dys = {21, 17, 13, 30, 17, 13, 17, 18, 12, 16, 25, 23}
                local das = {0, 0, 0, 10, 1, 9, 1, 3, 1, 5, 3, 7}
                for i = 1, 12 do
                    for u = -1, 1, 2 do
                        for j = 0, 1 do
                            createEnemyFunc1((-224 - 20*j)*u, 120 + 50*j + dys[i], -90 + (65 + das[i])*u)
                        end
                        task.Wait(15)
                    end
                end
                --中型怪
                for u = -1, 1, 2 do
                    for u0 = -1, 1, 2 do
                        createEnemyFunc2(224*u0, 120, 90 + 85*u0, COLOR_RED + 0.5*(1 + u0*u)*(COLOR_BLUE - COLOR_RED))
                    end
                    for i = 1, 6 do
                        for j = 0, 1 do
                            createEnemyFunc1((-224 - 20*j)*u, 120 + 50*j + dys[i], -90 + (65 + das[i])*u)
                        end
                        task.Wait(30)
                    end
                    task.Wait(60)
                end
                --再刷两只
                for u = -1, 1, 2 do
                    createEnemyFunc2(-64*u, 240, -90, COLOR_RED + 0.5*(1 + u)*(COLOR_BLUE - COLOR_RED))
                end
                --task.Wait(90)
                for u0 = -1, 1, 2 do
                    for i = 1, 6 do
                        for u = -1, 1, 2 do
                            for j = 0, 1 do
                                createEnemyFunc3(-(dys[i] + 60 + 30*j)*u, 245 + 40*j, -90, u)
                            end
                            task.Wait(20)
                        end
                    end
                    for u = -1, 1, 2 do
                        createEnemyFunc2(-64*u, 240, -90, COLOR_RED + 0.5*(1 + u*u0)*(COLOR_BLUE - COLOR_RED))
                    end
                end
            end
        end
    end
end

--道中片段2
function R.SECOND(pratice)
    local self = lstg.tmpvar.current_road
    --1560f
    local t = 1560
    if IsValid(self) then
        if pratice then
            self.timer = t
            audio.playMusic("s2", 1.0, t/60)
        else
            --等到tf
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer == t then
            self.sence = 2
            --小怪定义
            local createEnemyFunc1, createEnemyFunc2, createEnemyFunc3,
            createEnemyFunc4, createEnemyFunc5
            do
                --樱吹雪大怪
                function createEnemyFunc1(x, y, u)
                    local obj = E.enemy2.create(x, y, 240, 30, u) --x, y, hp, dt, u
                    setProtectTime(obj, 60)
                    T.move2_1.main(obj, -90)
                end
                --鬼火
                function createEnemyFunc2(x, y, u)
                    local obj = E.enemy4.create(x, y, 5, 0)
                    T.ghostFireMove1.main(obj, u)
                end
                --开幕扔乱弹的小怪
                function createEnemyFunc3(x, y, a)
                    local obj = E.enemy1.create(x, y, 4, 0) --x, y, hp, dt
                    T.leaveScreen1.main(obj, a)
                end
                --全屏开花小怪
                function createEnemyFunc4(x, y, a, co)
                    local obj = E.enemy3.create(x, y, 90, 0) --x, y, hp, dt
                    T.moveAndLeaveScreen1.main(obj, a)
                    enemy.changeAura(obj, co, "normal")
                end
            end
            --道中本体
            do
                for u1 = 1, -1, -2 do
                    createEnemyFunc1(-64*u1, 245, u1)
                    for u0 = u1, -u1, -2*u1 do
                        task.Wait(30)
                        for i = 1, 5 do
                            if u0==u1 then --只出一半，但不破坏以前的时间轴
                                for u = -1, 1, 2 do
                                    createEnemyFunc2((140 - 20*i)*u0 + 25*u*u0, 265 + 20*u, -u0)
                                end
                            end
                            task.Wait(20)
                        end
                    end
                end
                createEnemyFunc1(0, 245, 1)
                task.Wait(60)
                for i = 1, 5 do
                    for u = -1, 1, 2 do
                        for u0 = -1, 1, 2 do
                            createEnemyFunc2((140 - 20*i)*u0 + 25*u*u0, 265 + 20*u, -u0)
                        end
                    end
                    task.Wait(20)
                end
                task.Wait(60)
                --
                local dys = {21, 17, 13, 30, 17, 13, 17, 18, 12, 16, 25, 23}
                local das = {0, 0, 0, 10, 1, 9, 1, 3, 1, 5, 3, 7}
                for u0 = -1, 1, 2 do
                    createEnemyFunc4(224*u0, 84, 90 + 90*u0, COLOR_BLUE)
                    task.Wait(60)
                    for i = 1, 4 do
                        for j = 0, 1 do
                            createEnemyFunc3(-(-224 - 20*j)*u0, 120 + 50*j + dys[i], -90 - (65 + das[i])*u0)
                        end
                        task.Wait(25)
                    end
                    createEnemyFunc4(-224*u0, 144, 90 - 90*u0, COLOR_RED)
                    for i = 5, 8 do
                        for u = -1, 1, 2 do
                            createEnemyFunc2(-(175 - 15*i)*u0 + 25*u*u0, 265 - 20*u, -u0)
                        end
                        for j = 0, 1 do
                            createEnemyFunc3(-(-224 - 20*j)*u0, 120 + 50*j + dys[i], -90 - (65 + das[i])*u0)
                        end
                        task.Wait(25)
                    end
                end
            end
        end
    end
end

--道中boss
--道中片段3（道中boss）
local createMidBoss = lstg.DoFile(EISlib.stage.path.."stage2/mid_boss.lua")
local mid_bosses = {}
for diff = 1, 4 do
    mid_bosses[diff] = createMidBoss(diff)
end
local function midBossMain()
    local boss = New(mid_bosses[difficulty])
    while IsValid(boss) do
        task.Wait(1)
    end
end
s2_road.midBoss = midBossMain
function R.THIRD(pratice)
    local self = lstg.tmpvar.current_road
    --2900f
    local t = 2900
    if IsValid(self) then
        if pratice then
            self.timer = t
            audio.playMusic("s2", 1.0, t/60)
        else
            --等到3550f
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer == t then
            self.sence = 3
            --小怪定义
            local createEnemyFunc1, createEnemyFunc2, createEnemyFunc3,
            createEnemyFunc4, createEnemyFunc5, createEnemyFunc6, createEnemyFunc7, createEnemyFunc8
            do
                --第一种小怪团
                function createEnemyFunc1(x0, y0, x1, y1)
                    local obj
                    for i = 1, 6 do
                        obj = E.enemy1.create(x0, y0, 10, 40 + 60) --x, y, hp, dt
                        T.move1_2.main(obj, x1, y1, 60, 60*i, 90)
                        setProtectTime(obj, 10)
                        --T.moveTo1.main(obj, x1, y1, 60, 60*i) --x, y, r, a
                    end
                    obj = E.enemy3.create(x0, y0, 90, 10) --x, y, hp, dt
                    setProtectTime(obj, 10)
                    T.moveTo1.main(obj, x1, y1, 0, 90) --x, y, r, a
                end

                --开幕扔乱弹的小怪
                function createEnemyFunc2(x, y, a)
                    local obj = E.enemy1.create(x, y, 2, 30) --x, y, hp, dt
                    setProtectTime(obj, 30)
                    T.leaveScreen3.main(obj, a)
                end

                --全屏开花小怪
                function createEnemyFunc3(x, y, a)
                    local obj = E.enemy3.create(x, y, 60, 0) --x, y, hp, dt
                    setProtectTime(obj, 30)
                    T.leaveScreen3.main(obj, a)
                end

                --后半增援
                function createEnemyFunc4(x0, y0, x1, y1)
                    local obj
                    for i = 1, 6 do
                        obj = E.enemy6.create(x1, y1, 20, 30) --x, y, hp, dt
                        setProtectTime(obj, 10)
                        T.moveTo3.main(obj, x1, y1, 60, 60*i, -90) --x, y, r, a
                    end
                    obj = E.enemy5.create(x0, y0, 90, 30)
                    setProtectTime(obj, 60)
                    T.moveTo2.main(obj, x1, y1, 0, -90) --x, y, r, a
                end

                --白给小怪群
                function createEnemyFunc5(x, y, a)
                    local obj = E.enemy8.create(x, y, 10) --x, y, hp
                    setProtectTime(obj, 30)
                    S.shooter1.main(obj, 0, COLOR_CYAN) --e, dt, co
                    T.leaveScreen3.main(obj, a)
                end


                --莉莉白
                function createEnemyFunc7(x, y, a)
                    local obj = New(enemy, x, y, sty.FAIRY_LILY_WHITE, --style
                            10000, --hp
                            false,  --show_hpbar
                            {0, 0} --drop
                    )
                    enemy.changeAura(obj, COLOR_GREEN, "normal")
                    obj.colli = false
                    task.New(obj, function()
                        velch(obj, 1, 3, a, 70)
                        velch(obj, 0, -3, a, 70)
                        task.Wait(30)
                        PlaySound("ch00")
                        New(EGGlib.RenderEffect.AbsorbEffect, obj.x, obj.y, 'tree_leaf_white', 'Cherry_eff', 0, 255, 0)
                        task.Wait(40+90)
                        obj.dropBomb(obj)
                        task.Wait(32)
                        item.PlayerBomb.create(obj.x, obj.y + 20)
                        PlaySound("bonus2")
                        item.Blood.create(obj.x, obj.y + 20, item.Blood.Huge)
                        PlaySound("enep01")
                        --effect.shakeScreen(60, 10)
                        for _ = 0, 1 do
                            New(EGGlib.RenderEffect.BreakEffect, obj.x, obj.y, 'tree_leaf_white', 'Cherry_eff', 0, 255, 0)
                        end
                        task.Wait(30)
                        velch(obj, 0, 4, a, 30)
                    end)
                end

                --boss后的增援
                function createEnemyFunc8(x, y, a, u)
                    local obj = E.enemy8.create(x, y, 4) --x, y, hp, dt
                    S.shooter1.main(obj, 0, COLOR_CYAN) --e, dt, co
                    T.moveAndLeaveScreen2.main(obj, a, u)
                end
            end
            --道中本体
            do
                local pos = {{-110, 100}, {-20, 90}, {70, 100},
                             {110, 100}, {20, 90}, {-70, 100}}
                for i = 1, 6 do
                    createEnemyFunc1(pos[i][1], 245, pos[i][1], pos[i][2])
                    task.Wait(80)
                end
                --一群排队妖精
                local dys = {21, 17, 13, 30, 17, 13, 17, 18, 12, 16, 25, 23}
                local das = {0, 0, 0, 0, 1, 9, 1, 3, 1, 5, 3, 7}
                local u0
                for i = 0, 3 do
                    u0 = tranU(i)
                    createEnemyFunc3(-224*u0, 120, 90 - (90 + 10)*u0)
                    task.Wait(10)
                    for j = 1, 5 do
                        for u = -1, 1, 2 do
                            createEnemyFunc2((-239 + 15*u)*u0, 120 + 15*u + dys[j], 90 - (90 + 10)*u0)
                        end
                        task.Wait(15)
                    end
                    task.Wait(5)
                end
                task.Wait(30)
                createTitle(0, 100)
                task.Wait(80)
                EGGlib.ObjectEvent.clearEnemyAndBullet()
                --道中boss
                self.midboss = New(mid_bosses[difficulty])
                task.Wait(750)
                task.New(self, function()
                    local t = 0
                    for _ = 1, 5 do
                        for i = 1, 6 do
                            for u = -1, 1, 2 do
                                if not IsValid(self.midboss) and t <= 800 then
                                    for j = 0, 1 do
                                        createEnemyFunc8(-(dys[i] + 60 + 30*j)*u, 245 + 40*j, -90, u)
                                    end
                                end
                                task.Wait(15)
                                t = t + 15
                            end
                        end
                    end
                end)
                task.Wait(890)
                --task.Wait(1500)
                for i = 1, 6 do
                    if not IsValid(self.midboss) then
                        createEnemyFunc4(-pos[i][1], 245, -pos[i][1], pos[i][2])
                    end
                    task.Wait(120)
                end
                --注意，比原来多了180
                task.Wait(60)
                local u0
                for i = 0, 3 do
                    u0 = tranU(i)
                    if not IsValid(self.midboss) then
                        createEnemyFunc3(224*u0, 120, 90 + (90 + 10)*u0)
                    end
                    task.Wait(10)
                    for j = 1, 5 do
                        if i == 3 and j == 1 then
                            --莉莉白
                            if not IsValid(self.midboss) then --能拖到这里也是很神奇了，那你b没了
                                createEnemyFunc7(239, 80, 180)
                            end
                        end
                        for u = -1, 1, 2 do
                            if not IsValid(self.midboss) then
                                createEnemyFunc5((239 - 15*u)*u0, 120 + 15*u + dys[j], 90 + (90 + 10)*u0)
                            end
                        end
                        task.Wait(15)
                    end
                    task.Wait(5)
                end
                task.Wait(120)
                --6750
                for i = 1, 8 do
                    for u = -1, 1, 2 do
                        if not IsValid(self.midboss) then
                            for j = 0, 1 do
                                createEnemyFunc8(-(dys[i] + 60 + 30*j)*u, 245 + 40*j, -90, u)
                            end
                        end
                        task.Wait(15)
                    end
                end
            end
        end
    end
end

function R.FOURTH(pratice)
    local self = lstg.tmpvar.current_road
    --7090f
    local t = 7090
    if IsValid(self) then
        if pratice then
            self.timer = t
            audio.playMusic("s2", 1.0, t/60)
        else
            --等待到7090f
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer >= t then
            self.sence = 4
            --小怪定义
            local createEnemyFunc1, createEnemyFunc2, createEnemyFunc3,
            createEnemyFunc4, createEnemyFunc5, createEnemyFunc6, createEnemyFunc7
            do
                --白给小怪群
                function createEnemyFunc1(x, y, a, u)
                    local obj = E.enemy8.create(x, y, 4) --x, y, hp
                    setProtectTime(obj, 20)
                    S.shooter1.main(obj, 30, COLOR_CYAN) --e, dt, co
                    T.moveAndLeaveScreen4.main(obj, a, u)
                end

                --下蛋妖精
                function createEnemyFunc2(x, y, u)
                    local obj = E.enemy9.create(x, y, 60, 0, u)
                    setProtectTime(obj, 100)
                    T.leaveScreen4.main(obj, u)
                end

                --阴阳玉
                function createEnemyFunc3(x, y, r, a)
                    local obj = E.enemy6.create(x + (-r + 20)*cos(a), y + (-r + 20)*sin(a), 5, 40) --x, y, hp, dt
                    setProtectTime(obj, 10)
                    T.moveTo3.main(obj, x, y, -r, a, -90) --x, y, r, a
                end

                --鬼火
                function createEnemyFunc4(x, y, u)
                    local obj = E.enemy7.create(x, y, 5, 10) --x, y, hp, dt
                    T.ghostFireMove1.main(obj, u)
                end

                --后半增援
                function createEnemyFunc5(x0, y0, x1, y1)
                    local obj
                    --[[for i = 1, 6 do
                        obj = E.enemy4.create(x1, y1, 5, 75) --x, y, hp, dt
                        T.moveTo3.main(obj, x1, y1, 60, 6 + 60*i) --x, y, r, a
                    end]]
                    obj = E.enemy3.create(x0, y0, 90, 10)
                    setProtectTime(obj, 10)
                    T.moveTo2.main(obj, x1, y1, 0, -90) --x, y, r, a
                end

                --后半增援
                function createEnemyFunc6(x0, y0, x1, y1)
                    local obj
                    obj = E.enemy5.create(x0, y0, 90, 30)
                    setProtectTime(obj, 60)
                    T.moveTo2.main(obj, x1, y1, 0, -90) --x, y, r, a
                end

                --樱吹雪大怪
                function createEnemyFunc7(x, y, u)
                    local obj = E.enemy2.create(x, y, 240, 60, u) --x, y, hp, dt, u
                    --T.moveAndLeaveScreen1.main(obj, -90)
                    setProtectTime(obj, 60)
                    T.move2_1.main(obj, -90)
                end
            end

            --道中本体
            do
                local x0, dx = -150, 180/6
                for _ = 0, 5 do
                    for j = 0, 3 do
                        for k = 0, 1 do
                            createEnemyFunc1(x0 + 1.5*k*dx, 245 + 50*(j + k), -90 + 10*(j + k - 1), -1 + 2*((j + k)%2))
                        end
                    end
                    x0 = x0 + dx
                    task.Wait(15)
                end
                task.Wait(15)
                createEnemyFunc2(224, -100, -1)
                task.Wait(240)
                for i = 1, 20 do
                    for j = 0, 1 do
                        createEnemyFunc3(0, 50, 20 + 7.5*(20 - i), 24*i + 180*j)
                    end
                    task.Wait(5)
                end
                task.Wait(60)
                for i = 1, 20 do
                    for j = 0, 1 do
                        createEnemyFunc3(0, 50, 20 + 7.5*i, 24*i + 180*j)
                    end
                    task.Wait(5)
                end
                task.Wait(120)
                createEnemyFunc2(-224, -100, 1)
                task.Wait(120)
                local x0, dx = 120, -240/5
                for _ = 1, 5 do
                    for i = 0, 5 do
                        for u = -1, 1, 2 do
                            createEnemyFunc4(x0 + dx*i - 5*u, 260 + 20*u, u)
                            task.Wait(5)
                        end
                    end
                    x0 = -x0
                    dx = -dx
                end
                task.Wait(60)
                local pos = {{-110, 100}, {0, 70}, {110, 85}}
                for i = 1, 3 do
                    createEnemyFunc5(pos[i][1], 245, pos[i][1], pos[i][2])
                    task.Wait(40)
                end
                task.Wait(50)
                for i = 1, 3 do
                    createEnemyFunc6(-pos[i][1], 245, -pos[i][1], pos[i][2])
                    task.Wait(40)
                end
                task.Wait(90)
                createEnemyFunc7(-75, 245, -1)
                task.Wait(120)
                createEnemyFunc7(75, 245, 1)
                task.Wait(585)
                EGGlib.ObjectEvent.clearEnemyAndBullet()
                system.PowerRank.pauseHyper() --从这里停止计时
                task.Wait(30)
            end
        end
    end
end

return R
