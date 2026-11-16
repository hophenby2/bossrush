-----------------------------------------
---东方栖霞园道中 Stage4
-----------------------------------------
---@class  EISlib.stage.stage4.road
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
    local res_name = "s4_road_"
    local path = "res/stage/stage4/"
    --关卡标题
    LoadImageFromFile(res_name.."title1", path.."title1.png")
end

--由随机数生成器产生的1-100随机整数（之后转化为比率小数）
local ranRate = {
    6, 30, 59, 56, 53, 54, 65, 88, 92, 26,
    48, 89, 28, 70, 36, 17, 65, 8, 37, 79,
    68, 17, 25, 64, 32, 72, 56, 79, 72, 43,
    16, 40, 3, 90, 29, 7, 44, 44, 24, 23,
    78, 53, 59, 11, 42, 42, 71, 99, 92, 61,
    80, 24, 4, 2, 20, 73, 81, 53, 33, 10,
    5, 98, 7, 28, 85, 17, 33, 24, 69, 95,
    51, 15, 94, 71, 63, 61, 88, 27, 99, 75,
    21, 39, 89, 24, 11, 53, 64,59, 93, 47,
    20, 4, 66, 20, 51, 21, 11, 79, 34, 57
}
for k, v in ipairs(ranRate) do
    ranRate[k] = v/100
end
local function getRate(i) return ranRate[i] end
local function getSignRate(i) return 2*(ranRate[i] - 0.5) end


local BS = EISlib.Bullet.Shooter
local no_info = 0
local no_info_t = 9999
local no_func = function() end
local accdecChV = EGGlib.ObjectEvent.accDecVelocityChange
local accdecChVTask = EGGlib.ObjectEvent.accDecVelocityChangeTask
local velch = EGGlib.ObjectEvent.velocityChange
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local movePointWithPar = EGGlib.ObjectEvent.movePointWithPar
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local argbChange = EGGlib.ObjectEvent.argbChange
local argbChangeToMax = EGGlib.ObjectEvent.argbChangeToMax
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local alphaChange = EGGlib.ObjectEvent.alphaChange
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
local boundWait = EGGlib.ObjectEvent.boundWait
local sty = EISlib.Enemy.Style
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local setProtectTime = EGGlib.ObjectEvent.setProtectTime
local clearEnemyAndBullet = EGGlib.ObjectEvent.clearEnemyAndBullet
local sect_layer1 = EGGlib.BulletGroup.Sector.layer1
local sect_layer2 = EGGlib.BulletGroup.Sector.layer2
local circle_normal1 = EGGlib.BulletGroup.Circle.normal1
local polygon3 = EGGlib.BulletGroup.polygon3
local TriAngle = EGGlib.BulletGroup.TriAngle
local sect_sect1 = EGGlib.BulletGroup.Sector.sector1
local curve_normaldv1 = EGGlib.BulletGroup.Curve.normalDv1

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
B.bullet2 = BS.createBulletClass(
        function(diff, rank)
            local v = switch1(diff, {
                1.75, 2, 2.25, 2.5, 2.5
            })*defaultSwitchVelocityByRank(rank)
            local acc = 0.05
            local function create(x, y, dv, a, style, color)
                local obj = stg.newSimpleBullet(x, y, style, color, false)
                obj.navi = true
                local t = math.floor((v + dv)/acc)
                velchTask(obj, 0, v + dv, a, t)
                return obj
            end
            return create
        end
)

--甩出去的鬼火（并不是真正的子弹）
B.bullet4 = BS.createBulletClass(
        function(diff, rank)
            local function create(x, y, v, a, i)
                local obj = New(enemy, x, y, sty.FIRE_CYAN, --style
                        5, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY, --drop
                        false, --no_count
                        D.death7_1.main, --death
                        false --type
                )
                obj.show_aura = true
                obj.hscale, obj.vscale = 0.1, 0.1
                obj.i = i
                --变化逻辑
                obj.bound = false
                obj.colli = false
                robject.set_color(obj, "", 0, 0, 0, 0)
                obj.hscale, obj.vscale = 0, 0
                task.New(obj, function()
                    local t = 30
                    local s, ds = 0, 1/t
                    local d_a = 255/t
                    local d_c = 255/t
                    for _ = 1, t do
                        s = s + ds
                        obj.hscale, obj.vscale = s, s
                        obj._a = obj._a + d_a
                        obj._r, obj._g, obj._b = obj._r + d_c, obj._g + d_c, obj._b + d_c
                        task.Wait(1)
                    end
                    --自爆
                    item.DropItem(obj.x, obj.y, obj._drop) --道具是给的
                    D.death7_1.main(obj) --死尸弹也是给的
                    --但是连击就不给了
                    _del(obj, true)
                end)
                --移动逻辑
                task.New(obj, function()
                    velch(obj, v, 1.5, a, 60, 240)
                end)
                return obj
            end
            return create
        end
)
--endregion
--region Pointer Defined
--小型自机狙
P.pointer1 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                1, 2, 3, 4, 4
            }) + switch(rank, {
                0, 0, 0, 0, 1
            })
            local da = 3.3 --每way间的间隔

            --case：层数
            local layer = 1 + switch(rank, {
                0, 0, 0, 0, 1
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                2, 2.5, 3, 3.5, 3.5
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv0 = -0.1*v0

            local v1 = switch1(diff, {
                2, 2.75, 3.5, 4.25, 4.25
            })*defaultSwitchVelocityByRank(rank)
            local dv1 = -0.1*v1

            local style, color = stg.grain_b, COLOR_BLUE
            local function bullet_func(x, y, v, a)
                stg.newSimpleStraight(x, y, v, a, style, color)
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            sect_layer1(x, y, v0, a, way, da, --base
                                    layer, dv0, 0, --layer, dv_l, da_l
                                    bullet_func
                            )
                            for i = 0, layer - 1 do
                                stg.newSimpleStrChV(x, y, 0, v1 + dv1*i, a, 60, 0, stg.ball_mid, COLOR_BLUE)
                            end
                        end)
            end
            return attack
        end
)

--鬼火向下鳞弹
P.pointer2 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                1, 3, 5, 7, 7
            })
            local da = switch1(diff, {
                0, 50, 40, 30, 30
            }) --每way间的间隔
            --case：层数
            local layer = 1 + switch(rank, {
                0, 0, 0, 0, 1
            })
            --case：每层弹速差
            local dv = switch1(diff, {
                -0.35, -0.4, -0.45, -0.5, -0.5
            })
            local style, color = stg.arrow_big, COLOR_BLUE
            local function bullet_func(x, y, dv0, a)
                for i = 0, layer - 1 do
                    B.bullet2.create(x, y, dv0 + dv*i, a, style, color)
                end
            end
            local function attack(x, y, dv0, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            sect_layer1(x, y, dv0, a, way, da, --base
                                    1, 0, 0, --layer, dv_l, da_l
                                    bullet_func
                            )
                        end)
            end
            return attack
        end
)

--鬼火逃逸时放出的额外开花弹
P.pointer2_1 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                6, 8, 9, 11, 11
            })
            local da = 360/way --每way间的间隔
            --case：层数
            local layer = switch1(diff, {
                1, 3, 5, 6, 6
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                1.25, 1.5, 1.75, 2, 2
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = switch1(diff, {
                0, 0.375, 0.425, 0.5, 0.5
            })*defaultSwitchVelocityByRank(rank)
            local style, color = stg.ball_mid_c, COLOR_DEEP_BLUE
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

--连续弹幕攻击
P.pointer3_1 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                4, 4, 6, 8, 8
            })
            local sp = 140
            local n = 3 + switch(rank, {
                0, 0, 0, 0, 1
            })
            --case：层数
            local layer = 1
            --case：初始弹速
            local v0 = switch1(diff, {
                1.5, 2, 2.5, 3, 3.5
            })*defaultSwitchVelocityByRank(rank)
            local dvc = switch1(diff, {
                0.125, 0.125, 0.125, 0.125, 0.125
            })*defaultSwitchVelocityByRank(rank)
            local style, color = stg.ball_big_c, COLOR_DEEP_BLUE
            local function bullet_func(x, y, v, a)
                return stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color)
            end
            local function bullet_func1(x, y, v, a)
                polygon3(x, y, 2, --x, y, dsc,
                        v, dvc, a, 0, --v, dvc, a, rot
                        n, bullet_func --n, singleBulletFunc
                )
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            sect_layer2(x, y, v0, a, way, sp, --base
                                    layer, 0, 0, --layer, dv_l, da_l
                                    bullet_func1
                            )
                        end)
            end
            return attack
        end
)

--两侧的棍子弹幕
P.pointer3_2 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                3, 5, 5, 7, 7
            })
            local da = 72/(way - 1) --每way间的间隔
            --case：层数
            local layer = switch1(diff, {
                1, 1, 2, 2, 2
            }) + switch(rank, {
                0, 0, 0, 0, 1
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                1.75, 2.25, 2.75, 3.25, 3.25
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = -0.25*defaultSwitchVelocityByRank(rank)
            local style, color = stg.grain_e, COLOR_BLUE
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

--三角弹
P.pointer4 = BS.createPointer(
        function(diff, rank)
            --case:way数
            local way = switch1(diff, {
                6, 8, 10, 12, 12
            })
            local da_w = 360/way
            --case：层数
            local layer = 3 + switch(rank, {
                0, 0, 0, 0, 1
            })
            local da = switch1(diff, {
                10, 6, 5, 4.5, 4.5
            }) --每way间的间隔
            --case：初始弹速
            local v0 = switch1(diff, {
                1.5, 1.75, 1.75, 2, 2
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = switch1(diff, {
                -0.25, -0.25, -0.25, -0.25, -0.25
            })*defaultSwitchVelocityByRank(rank)
            local style, color = stg.arrow_big, COLOR_BLUE
            local function bullet_func(x, y, v, a)
                stg.newSimpleStraight(x, y, v, a, style, color)
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            for i = 0, way - 1 do
                                TriAngle(x, y, v0, dv, a + i*da_w, da, layer, bullet_func)
                            end
                        end)
            end
            return attack
        end
)

--3way弹
P.pointer5_1 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                1, 1, 3, 3, 3
            })
            if diff == 4 and rank == 4 then
                way = way + 2
            end
            --case：层数
            local layer = 1
            --case：初始弹速
            local v0 = switch1(diff, {
                2.5, 3, 3.5, 4, 4
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = 0
            local style, color = stg.grain_e, COLOR_DEEP_BLUE
            local function bullet_func(x, y, v, a)
                stg.newSimpleStraight(x, y, v, a, style, color)
            end
            local function attack(x, y, dv0, a, sp)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            sect_layer2(x, y, v0 + dv0, a, way, sp, --base
                                    layer, dv, 0, --layer, dv_l, da_l
                                    bullet_func
                            )
                        end)
            end
            return attack
        end
)

--扇形套扇形弹
P.pointer5_2 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way1 = switch1(diff, {
                3, 5, 5, 7, 7
            })
            local da1 = switch1(diff, {
                50, 40, 35, 30, 30
            }) --每way间的间隔
            --case：层数
            local layer = switch1(diff, {
                1, 1, 2, 2, 2
            }) + switch(rank, {
                0, 0, 0, 0, 1
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                2, 2.5, 3, 3.5, 3.5
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = -0.5*defaultSwitchVelocityByRank(rank)

            --一扇的way数
            local way = switch1(diff, {
                4, 4, 5, 5, 5
            })
            local da = 4
            local style, color = stg.ball_big_c, COLOR_BLUE
            local function bullet_func(x, y, v, a)
                stg.newSimpleStraight(x, y, v, a, style, color)
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            for i = 0, layer - 1 do
                                sect_sect1(x, y, v0 + dv*i, a,
                                        way, da,
                                        way1, da1, bullet_func
                                )
                            end
                        end)
            end
            return attack
        end
)

--一串子弹
P.pointer6_1 = BS.createPointer(
        function(diff, rank)
            --case：条数
            local bunch = switch1(diff, {
                3, 4, 5, 6, 6
            })
            local da = 10 --每条间的间隔
            --case：初始弹速
            local v0 = switch1(diff, {
                1.75, 2, 2.25, 2.5, 2.5
            })*defaultSwitchVelocityByRank(rank)
            --case：每条弹速差
            local dv = switch1(diff, {
                0.2, 0.2, 0.2, 0.2, 0.2
            })*defaultSwitchVelocityByRank(rank)

            local way_c = switch(rank, {
                3, 3, 3, 3, 4
            })
            local da_c = 360/way_c
            local style, color = stg.arrow_big, COLOR_RED
            local function bullet_func(x, y, v, a)
                stg.newSimpleStraight(x, y, v, a, style, color, false, 1)
            end
            local function attack(x, y, a, u)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            for i = 0, way_c - 1 do
                                curve_normaldv1(x, y, v0, a + da_c*i,
                                        bunch, dv, da*u,
                                        bullet_func)
                            end
                        end)
            end
            return attack
        end
)

--小玉套中玉风车
P.pointer6_2 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                9, 12, 15, 18, 18
            })
            local da = 360/way
            --case：层数
            local layer = 1
            --case：初始弹速
            local v0 = switch1(diff, {
                1.75, 2, 2.25, 2.5, 2.5
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = 0
            local style, color = stg.ball_mid, COLOR_RED
            local bullet_func
            if diff == 1 then
                function bullet_func(x, y, v, a)
                    stg.newSimpleStraight(x, y, v, a, style, color)
                end
            elseif diff == 2 then
                function bullet_func(x, y, v, a)
                    for i = 0, 1 do
                        stg.newSimpleStraight(x, y, v - 0.1*i, a, style, color)
                    end
                end
            elseif diff == 3 then
                function bullet_func(x, y, v, a)
                    setSizeAndColli(stg.newSimpleStraight(x, y, v, a, style, color), 1.5, 1.5)
                end
            else
                function bullet_func(x, y, v, a)
                    setSizeAndColli(stg.newSimpleStraight(x, y, v, a, style, color), 1.5, 1.5)
                    stg.newSimpleStraight(x, y, v - 0.1, a, style, color)
                end
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

--多层自机狙
P.pointer6_3 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                1, 3, 5, 7, 3
            })
            --case：层数
            local layer = switch1(diff, {
                1, 2, 2, 3, 3
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                1.5, 2, 2.5, 3, 3
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = switch1(diff, {
                0, 0.25, 0.25, 0.25, 0.25
            })
            local style, color = stg.grain_e, COLOR_RED
            local function bullet_func(x, y, v, a)
                stg.newSimpleStraight(x, y, v, a, style, color)
            end
            local function attack(x, y, a, da)
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

--大阴阳玉向下发的弹幕
P.pointer7_1_1 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                1, 1, 2, 2, 2
            })
            local da = switch1(diff, {
                0, 0, 5, 7.5, 7.5
            }) --每way间的间隔
            --case：层数
            local layer = 1
            --case：初始弹速
            local v0 = switch1(diff, {
                2, 3, 3.5, 4, 4
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = 0
            local style, color = stg.water_drop, COLOR_BLUE
            local function bullet_func(x, y, v, a)
                local obj = stg.newSimpleStrChV(x, y, 0.25, v, a, 60, 60, style, color)
                stg.setBoundTime(obj, 90)
                robject.set_color(obj, "mul+add", 255, 255, 255, 255)
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, true,
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

--开花小型子弹
P.pointer7_1_2 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                12, 12, 18, 24, 24
            })
            local da = 360/way --每way间的间隔
            --case：层数
            local layer = switch1(diff, {
                1, 1, 1, 1, 1
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                1.25, 1.5, 1.75, 2.25, 2.25
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = 0
            local style, color = stg.grain_e, COLOR_BLUE
            local function bullet_func(x, y, v, a)
                stg.newSimpleStraight(x, y, v, a, style, color)
            end
            local function attack(x, y, a)
                if diff > 1 or rank == 4 then
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_layer1(x, y, v0, a, way, da, --base
                                        layer, dv, 0, --layer, dv_l, da_l
                                        bullet_func
                                )
                            end)
                end
            end
            return attack
        end
)

--开花中型子弹
P.pointer7_1_3 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                4, 6, 10, 12, 12
            })
            local da = 360/way --每way间的间隔
            --case：层数
            local layer = 1
            --case：初始弹速
            local v0 = switch1(diff, {
                1.5, 2, 2.5, 3, 3
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = 0
            local style, color = stg.ball_big_c, COLOR_DEEP_BLUE
            local function bullet_func(x, y, v, a)
                stg.newSimpleStraight(x, y, v, a, style, color)
            end
            local function attack(x, y, a)
                if diff > 2 then
                    PlaySound("tan00")
                    stg.newFadeEffect(x, y, style, color, false,
                            function()
                                sect_layer1(x, y, v0, a, way, da, --base
                                        layer, dv, 0, --layer, dv_l, da_l
                                        bullet_func
                                )
                            end)
                end
            end
            return attack
        end
)
--endregion

--region Shooter Defined
--基础道中自机狙发射器
S.shooter1 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                15, 10, 5, 0, 0
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                120, 240, 300, 300, 300
            })
            --case：攻击间隔
            local wait = switch1(diff, {
                60, 60, 45, 45, 0
            })
            local function shooter(e, dt)
                dt = dt or 0
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            while e.y > -112 do
                                P.pointer1.attack(e.x, e.y, Angle(e, player))
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)
--
S.shooter2 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                15, 10, 5, 0, 0
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                180, 180, 180, 180, 180
            })
            local wait = switch1(diff, {
                70, 60, 50, 40, 40
            })
            local function shooter(e, dt, dt2)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function(obj)
                            --[[task.New(obj, function()
                                task.Wait(dt2)
                                P.pointer2_1.attack(e.x, e.y, Angle(e, player))
                            end)]]
                            while true do
                                P.pointer2.attack(e.x, e.y, e.dv, Angle(e, player) + ran:Float(-3, 3))
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

S.shooter3_1 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                15, 10, 5, 0, 0
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                240, 240, 240, 240, 240
            })
            local wait = switch1(diff, {
                140, 120, 100, 80, 80
            })
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            local x, y, a
                            while true do
                                x, y, a = e.x, e.y, Angle(e, player)
                                P.pointer3_1.attack(x, y, a)
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

S.shooter3_2 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                15, 10, 5, 0, 0
            })
            --case：持续攻击时间
            local total_time = 240
            local wait = switch1(diff, {
                140, 120, 100, 80, 80
            })
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            while true do
                                P.pointer3_2.attack(e.x, e.y, Angle(e, player))
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

S.shooter4 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                15, 10, 5, 0, 0
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                180, 180, 180, 180, 180
            })
            local count = 7
            local wait_c = 28/count
            local v = 1 --发出鬼火使魔的速度
            local da = 360/count
            local dv = switch1(diff, {
                0.5, 0.5, 0.5, 0.5, 0.5
            })
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            local way, a = (count - 1)/2
                            local enemy_list = {}
                            a = Angle(e, player)
                            --[[连锁爆炸
                            tasker(function()
                                while IsValid(e) do
                                    task.Wait(1)
                                end
                                for _, obj in pairs(enemy_list) do
                                    if IsValid(obj) then
                                        Kill(obj)
                                    end
                                    task.Wait(2)
                                end
                            end)]]
                            for i = -way, way do
                                table.insert(enemy_list, B.bullet4.create(e.x, e.y, v, a + i*da, i + way))
                                task.Wait(wait_c)
                            end
                            while true do
                                P.pointer4.attack(e.x, e.y, Angle(e, player))
                                task.Wait(60)
                            end
                        end
                )
            end
            return shooter
        end
)

S.shooter5_1 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                15, 10, 5, 0, 0
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                300, 300, 360, 360, 360
            })
            local count = switch1(diff, {
                8, 12, 16, 20, 20
            })
            local dv = 0.2*defaultSwitchVelocityByRank(rank)
            local wait = 120
            local sp0 = switch1(diff, {
                90, 90, 60, 45, 45
            })
            local dsp = switch1(diff, {
                2, 2, 2, 2, 2
            })
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            local a
                            while true do
                                a = Angle(e, player)
                                for i = 0, count - 1 do
                                    P.pointer5_1.attack(e.x, e.y, dv*i, a, sp0+dsp*(count - 1 - i))
                                    task.Wait(3)
                                end
                                task.Wait(wait - 3*count)
                            end
                        end
                )
            end
            return shooter
        end
)

S.shooter5_2 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                15, 10, 5, 0, 0
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                300, 300, 360, 360, 360
            })
            local wait = 120
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            local a
                            while true do
                                a = Angle(e, player)
                                P.pointer5_2.attack(e.x, e.y, a)
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

S.shooter6_1 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                15, 10, 5, 0, 0
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                360, 360, 360, 360, 360
            })
            local wait = switch1(diff, {
                12, 10, 8, 6, 6
            })
            local da = 10
            local function shooter(e, dt, u0, u1)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            local a, da = 90, da*u0
                            while true do
                                P.pointer6_1.attack(e.x, e.y, a, u1)
                                task.Wait(wait)
                                a = a + da
                            end
                        end
                )
            end
            return shooter
        end
)

S.shooter6_2 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                15, 10, 5, 0, 0
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                360, 360, 360, 360, 360
            })
            local wait = 15
            local da = switch1(diff, {
                21.3, 16, 9.6, 8, 8
            })
            local function shooter(e, dt, u)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            local a, da = 0, da*u
                            while true do
                                P.pointer6_2.attack(e.x, e.y, a)
                                task.Wait(wait)
                                a = a + da
                            end
                        end
                )
            end
            return shooter
        end
)

S.shooter6_3 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                15, 10, 5, 0, 0
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                360, 360, 360, 360, 360
            })
            local count = switch1(diff, {
                1, 2, 3, 4, 4
            })
            local wait_c = 60/count
            local wait = switch1(diff, {
                150, 130, 110, 90, 90
            })
            local da0 = switch1(diff, {
                0, 0, 20, 20, 20
            })
            local da = switch1(diff, {
                0, 0, 10, 10, 10
            })
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            local a
                            while true do
                                for i = 0, count - 1 do
                                    a = Angle(e, player)
                                    P.pointer6_3.attack(e.x, e.y, a, da0 + da*i)
                                    task.Wait(wait_c)
                                end
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

S.shooter7_1_1 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = 0
            --case：持续攻击时间
            local total_time = switch1(diff, {
                600, 600, 600, 600, 600
            })
            local wait = switch1(diff, {
                10, 8, 7, 6, 6
            })
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            while true do
                                P.pointer7_1_1.attack(e.x, e.y, -90 + ran:Float(-1, 1))
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

S.shooter7_1_2 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                15, 10, 5, 0, 0
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                600, 600, 600, 600, 600
            })
            local wait = 120

            local count = switch1(diff, {
                0, 1, 2, 2, 2
            }) + switch(rank, {
                0, 0, 0, 0, 1
            })
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            task.Wait(60)
                            task.Wait((3-count)*wait)
                            local a
                            for _ = 0, count - 1 do
                                if e.y > -50 then
                                    a = Angle(e, player)
                                    P.pointer7_1_2.attack(e.x, e.y, a)
                                    P.pointer7_1_3.attack(e.x, e.y, a)
                                end
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)
--endregion

--region Tasker Defined
local function alphaChange(obj, t)
    t = t or 90
    obj.colli = false
    robject.set_color(obj, "", 0, 100, 100, 100)
    obj.hscale, obj.vscale = 0.1, 0.1
    task.New(obj, function()
        alphaAndSizeChange(obj, 150, 0.9, math.floor(2/3*t))
        argbChangeToMax(obj, math.floor(1/3*t)) --t
        task.Wait(math.floor(1/3*t))
        obj.colli = true
    end)
end

--开幕小怪运动方式
T.move1_1 = BS.createTasker(
        function(diff, rank)
            local function main(obj, a)
                obj.bound = false
                obj.colli = false
                robject.set_color(obj, "", 0, 100, 100, 100)
                obj.hscale, obj.vscale = 0.1, 0.1
                task.New(obj, function()
                    alphaAndSizeChange(obj, 150, 0.9, 60)
                    argbChangeToMax(obj, 30) --t
                    task.Wait(30)
                    obj.colli = true
                end)
                task.New(obj, function()
                    velch(obj, 2, 1, a, 30, 90)
                    local u
                    if obj.dx > 0 then --小怪于左侧生成
                        u = -1
                    else
                        u = 1
                    end
                    accdecChVTask(obj, 2, a + 90*u, 60, 60, 60)
                    velch(obj, 0, 3, a - 150*u, 120)
                    obj.bound = true
                end)
            end
            return main
        end
)

--从上边下来然后冲向自机
T.move1_2 = BS.createTasker(
        function(diff, rank)
            local function main(obj, da)
                alphaChange(obj, 90)
                obj.bound = false
                local x, y = obj.x, obj.y
                obj.x, obj.y = ran:Float(-50, 50), -50
                task.New(obj, function()
                    task.MoveTo(obj, x, y, 60, MOVE_NORMAL)
                    velch(obj, 3, 2, -90 + da, 20, 30) --先飞下来，然后减速
                    velchTask(obj, 0, 3, -90, 120) --然后纵向再加速
                    obj.bound = true
                    local vx, dvx = 0
                    while true do --横向追自机
                        dvx = min(0.1, max(-0.1, (player.x - obj.x)/1000)) --x坐标超过100加速度拉到最大
                        vx = min(3, max(-3, vx + dvx))
                        obj.x = obj.x + vx
                       task.Wait(1)
                    end
                end)
            end
            return main
        end
)

--鬼火运动方式（从上往下再回去）
T.move2_1 = BS.createTasker(
        function(diff, rank)
            local function main(obj, u, x0, y0)
                --进入场景模块
                obj.bound = false
                obj.colli = false
                robject.set_color(obj, "", 0, 100, 100, 100)
                obj.hscale, obj.vscale = 0.1, 0.1
                task.New(obj, function()
                    alphaAndSizeChange(obj, 150, 0.9, 60)
                    argbChangeToMax(obj, 30) --t
                    task.Wait(30)
                    obj.colli = true
                end)
                --移动模块
                task.New(obj, function()
                    task.MoveTo(obj, x0, y0, 60, MOVE_NORMAL)
                    --纵向动作
                    task.New(obj, function()
                        velchTask(obj, 2.5, 0, -90, 20, 105)
                        task.Wait(105)
                        --横向移动
                        task.New(obj, function()
                            local v, dv = 0, -4.5/30*u
                            for _ = 1, 30 do
                                v = v + dv
                                x0 = x0 + v
                                task.Wait(1)
                            end
                            dv = -dv
                            for _ = 1, 30 do
                                v = v + dv
                                x0 = x0 + v
                                task.Wait(1)
                            end
                        end)
                        velchTask(obj, 0, 3, 90, 20)
                        obj.bound = true
                    end)
                    --横向动作
                    task.New(obj, function()
                        local t = 0
                        while true do
                            obj.x = x0 + 45*sin(t)
                            task.Wait(1)
                            t = t + 3*u
                        end
                    end)
                end)
            end
            return main
        end
)

--鬼火运动方式（从上往下然后向左或向右
T.move2_2 = BS.createTasker(
        function(diff, rank)
            local function main(obj, u, x0, y0)
                --进入场景模块
                obj.bound = false
                obj.colli = false
                robject.set_color(obj, "", 0, 100, 100, 100)
                obj.hscale, obj.vscale = 0.1, 0.1
                task.New(obj, function()
                    alphaAndSizeChange(obj, 150, 1.3, 60)
                    --task.Wait(30)
                    argbChangeToMax(obj, 30) --t
                    task.Wait(10)
                    obj.colli = true
                end)
                --移动模块
                task.New(obj, function()
                    task.MoveTo(obj, x0, y0, 60, MOVE_NORMAL)
                    --纵向动作
                    task.New(obj, function()
                        velchTask(obj, 1.75, 0.5, -90, 30, 150)
                        task.Wait(140)
                        obj.bound = true
                        --横向移动
                        task.New(obj, function()
                            local v, dv = 0, 3/180*u
                            for _ = 1, 180 do
                                v = v + dv
                                x0 = x0 + v
                                task.Wait(1)
                            end
                        end)
                    end)
                    --横向动作
                    task.New(obj, function()
                        local t = 0
                        while true do
                            obj.x = x0 + 45*sin(t)
                            task.Wait(1)
                            t = t + 3*u
                        end
                    end)
                end)
            end
            return main
        end
)

--中型敌人运动方式
T.move3_1 = BS.createTasker(
        function(diff, rank)
            local function main(obj, u)
                obj.bound = false
                alphaChange(obj, 60)
                setProtectTime(obj, 120)
                task.New(obj, function()
                    accdecChVTask(obj, 3, 90, 20, 40, 30) --纵向上升
                    task.Wait(50)
                    accdecChVTask(obj, 1, 90*(1-u), 20, 0, 20) --横向倾斜
                    task.Wait(40)
                    velch(obj, 0, 1, -90 - 30*u, 30) --斜向向下
                    task.Wait(90)
                    velch(obj, 0, 3, 90 - 75*u, 180) --斜向离开
                    obj.bound = true
                end)
            end
            return main
        end
)

--从远处抛物线式出现
T.move3_2 = BS.createTasker(
        function(diff, rank)
            local function main(obj, u, x0, y0)
                alphaChange(obj, 60)
                setProtectTime(obj, 120)
                task.New(obj, function()
                    movePointWithPar(obj, x0, y0, 2, 70, u)
                    velchTask(obj, 1, 0.5, 90 - 90*u, 60) --横向平移
                    --velch(obj, -0.5, 0, 30, 180) --纵向上升
                    velch(obj, 0, 2.5, 90 - 90*u, 360) --溜了溜了
                end)
            end
            return main
        end
)

--生蛋妖精正常出现
T.move4 = BS.createTasker(
        function(diff, rank)
            local function main(obj)
                obj.bound = false
                --移动模块
                task.New(obj, function()
                    velch(obj, 2, 0.5, -90, 60, 60)
                    obj.bound = true
                    task.Wait(60)
                    velch(obj, 0, 1, -90, 60)
                end)
            end
            return main
        end
)


--移动一会儿，停一会儿，再移动（适用于大型敌人）
T.move5_1 = BS.createTasker(
        function(diff, rank)
            local function main(obj)
                task.New(obj, function()
                    velch(obj, 2, 0.25, -90, 30, 60)
                    task.Wait(240)
                    velch(obj, 0, 0.5, -90, 30)
                end)
            end
            return main
        end
)

--先移到下边，然后再往上走，横向离开屏幕
T.move6_2 = BS.createTasker(
        function(diff, rank)
            local function main(obj, u)
                task.New(obj, function()
                    velchTask(obj, 2, 0, -90, 30, 80)
                    velchTask(obj, 2, 0.25, 90*(1-u), 60, 60)
                    task.Wait(100)
                    velch(obj, 1, 0, 90, 20)
                    task.Wait(20)
                    velchTask(obj, 0, 1.25, 90*(1-u), 480)
                    velch(obj, 0, 1, 90, 480)
                end)
            end
            return main
        end
)

--向某方向离开屏幕
T.leaveScreen1 = BS.createTasker(
        function(diff, rank)
            local function main(obj, a)
                task.New(obj, function()
                    velch(obj, 0, 1.2, a, 30)
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

--同上，不过速度会更慢一些，适用于中大型敌人
T.moveAndLeaveScreen1 = BS.createTasker(
        function(diff, rank)
            local function main(obj, a)
                task.New(obj, function()
                    velch(obj, 2, 0.5, a, 30, 30)
                    task.Wait(90)
                    velch(obj, -0.5, -0.25, a, 30)
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
                    velch(obj, 4, 3, a, 30)
                    vach2(obj, 3.5, 90*u, 45, 45) --dv, da, tv, ta
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

--跟随
local moveWith = EGGlib.ObjectEvent.rotateMoveWith2
local alphaChangeTask = EGGlib.ObjectEvent.alphaChangeTask
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

--region Death Defined
--鬼火死尸弹
D.death4 = EISlib.Bullet.Shooter.createTasker(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                1, 3, 3, 5, 5
            })
            local da = switch1(diff, {
                0, 45, 45, 45, 45
            }) --每way间的间隔
            --case：层数
            local layer = 1
            --case：初始弹速
            local v0 = switch1(diff, {
                2, 2, 2.5, 3, 3
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = 0
            local style, color = stg.grain_e, COLOR_ORANGE
            local function bullet_func(x, y, v, a)
                stg.newSimpleStrChV(x, y, 0, v, a, 60, 0, style, color)
            end
            local function main(e)
                local x, y, a, dv0 = e.x, e.y, Angle(e, player), e.dv
                enemy.createDeath(
                        1, --total_time,
                        function()
                            stg.newFadeEffect(x, y, style, color, false,
                                    function()
                                        sect_layer1(x, y, v0 + dv0, a, way, da, --base
                                                layer, dv, 0, --layer, dv_l, da_l
                                                bullet_func
                                        )
                                    end)
                        end)
            end
            return main
        end)

--特殊鬼火死尸弹，以标号i来确定死尸弹弹速
D.death7_1 = EISlib.Bullet.Shooter.createTasker(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                1, 1, 3, 5, 5
            })
            if diff >= 3 then
                way = way + switch(rank, {
                    0, 0, 0, 0, 2
                })
            end
            local da = switch1(diff, {
                0, 0, 30, 30, 30
            }) --每way间的间隔
            --case：层数
            local layer = switch1(diff, {
                0, 1, 1, 1, 1
            }) + switch(rank, {
                0, 0, 0, 0, 1
            })
            local dv_l = switch1(diff, {
                1, 1, 1, 1, 1
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                1.5, 2, 2, 2.5, 2.5
            })*defaultSwitchVelocityByRank(rank)
            --case：每i弹速差
            local dv = switch1(diff, {
                0.3, 0.4, 0.45, 0.5, 0.5
            })
            local style, color = stg.grain_e, COLOR_BLUE
            local function bullet_func(x, y, v, a)
                stg.newSimpleStrChV(x, y, 0, v, a, 60, 0, style, color)
            end
            local function main(e)
                if diff > 1 or rank == 4 then
                    local x, y, a, i = e.x, e.y, Angle(e, player), e.i
                    enemy.createDeath(
                            1, --total_time,
                            function()
                                stg.newFadeEffect(x, y, style, color, false,
                                        function()
                                            sect_layer1(x, y, v0 + dv*i, a, way, da, --base
                                                    layer, dv_l, 0, --layer, dv_l, da_l
                                                    bullet_func
                                            )
                                        end)
                            end)
                end
            end
            return main
        end)

D.clearBullet = EISlib.Bullet.Shooter.createTasker(
        function(diff, rank)
            local function main(e)
                local x, y, dr = e.x, e.y, e.clear_bullet_range or 600
                enemy.createDeath(
                        1, --total_time,
                        function()
                            PlaySound("enep05")
                            EGGlib.ObjectEvent.clearBulletAndLaserInRangeCircle(
                                    x, y, dr, 2 --x, y, rmax, index
                            )
                        end)
            end
            return main
        end)
--endregion

--region Enemy Defined
--最普通的自机狙杂鱼
E.enemy1 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, dt, hp)
                local obj = New(enemy, x, y, sty.FAIRY_SMALL_3_BLUE, --style
                        hp or 8, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                S.shooter1.main(obj, dt) --给这个小怪装上发射器
                return obj
            end
            return create
        end
)

E.enemy2 = BS.createEnemy(
        function(diff, rank)
            local dv = 0.6*defaultSwitchVelocityByRank(rank)
            local function create(x, y, dt, dt2, i, hp)
                local obj = New(enemy, x, y, sty.FIRE_BLUE, --style
                        hp or 10, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                obj.show_aura = true
                obj.dv = dv*i
                S.shooter2.main(obj, dt, dt2) --给这个小怪装上发射器
                return obj
            end
            return create
        end
)
--第一种中型妖精
E.enemy3 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, dt)
                local obj = New(enemy, x, y, sty.FAIRY_MIDDLE_3_BLUE, --style
                        60, --hp
                        true,  --show_hpbar
                        system.DROP_MID_ENEMY --drop
                )
                enemy.setBoundTime(obj, 900)
                S.shooter3_1.main(obj, dt) --给这个小怪装上发射器
                task.New(obj, function()
                    task.Wait(30)
                    --召唤小怪
                    for u = -1, 1, 2 do
                        _connect(obj, E.enemy3_2.create(obj, 60*u, -15, dt), 1, true)
                    end
                end)
                return obj
            end
            return create
        end
)

--鬼火
E.enemy3_2 = BS.createEnemy(
        function(diff, rank)
            local function create(mst, dx, dy, dt)
                local obj = New(enemy, mst.x, mst.y, sty.FIRE_BLUE, --style
                        9999, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                enemy.setBoundTime(obj, 900)
                enemy.setTauntRank(obj, enemy.SERVANT_TAUNT)
                --小怪颜色变化逻辑
                alphaChange(obj, 60)
                obj.show_aura = true
                S.shooter3_2.main(obj, dt) --给这个小怪装上发射器
                --小怪移动逻辑
                task.New(obj, function()
                    local t = 60
                    dx, dy = dx/t, dy/t
                    local x, y = 0, 0
                    for _ = 1, t do
                        if IsValid(mst) then
                            x, y = x + dx, y + dy
                            obj.x, obj.y = mst.x + x, mst.y + y
                        else
                            Del(obj)
                            break
                        end
                        task.Wait(1)
                    end
                    while IsValid(mst) do
                        obj.x, obj.y = mst.x + x, mst.y + y
                        task.Wait(1)
                    end
                end)
                return obj
            end
            return create
        end
)

--生蛋妖精
E.enemy4 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, dt)
                local obj = New(enemy, x, y, sty.FAIRY_MIDDLE_2_YELLOW, --style
                        75, --hp
                        true,  --show_hpbar
                            system.DROP_MID_ENEMY --drop
                )
                enemy.changeAura(obj, COLOR_BLUE, "normal")
                enemy.setBoundTime(obj, 900)
                setProtectTime(obj, 48)
                S.shooter4.main(obj, dt) --给这个小怪装上发射器
                return obj
            end
            return create
        end
)

--扩散型多way自机狙+散弹扇形自机狙
E.enemy5 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, dt, range)
                local obj = New(enemy, x, y, sty.FAIRY_MIDDLE_2_RED, --style
                        250, --hp
                        true,  --show_hpbar
                        system.DROP_MID_ENEMY, --drop
                        false, --no_count
                        D.clearBullet.main, --death
                        true --type
                )
                enemy.changeAura(obj, COLOR_ORANGE, "big")
                enemy.setBoundTime(obj, 1200)
                obj.clear_bullet_range = range --全屏消弹
                S.shooter5_1.main(obj, dt) --给这个小怪装上发射器
                for u = -1, 1, 2 do
                    _connect(obj, E.enemy5_2.create(obj, 100*u, 60, dt + 60), 1, true)
                end
                return obj
            end
            return create
        end
)
E.enemy5_2 = BS.createEnemy(
        function(diff, rank)
            local function create(mst, dx, dy, dt)
                local obj = New(enemy, mst.x, mst.y, sty.FIRE_RED, --style
                        9999, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                enemy.setBoundTime(obj, 1200)
                obj.show_aura = true
                enemy.setTauntRank(obj, enemy.SERVANT_TAUNT)
                setSizeAndColli(obj, 1.25, 1.25)
                S.shooter5_2.main(obj, dt) --给这个小怪装上发射器
                task.New(obj, function()
                    local t = 60
                    dx, dy = dx/t, dy/t
                    local x, y = 0, 0
                    for _ = 1, t do
                        if IsValid(mst) then
                            x, y = x + dx, y + dy
                            obj.x, obj.y = mst.x + x, mst.y + y
                        else
                            Del(obj)
                            break
                        end
                        task.Wait(1)
                    end
                    while IsValid(mst) do
                        obj.x, obj.y = mst.x + x, mst.y + y
                        task.Wait(1)
                    end
                end)
                return obj
            end
            return create
        end
)

--是个大家伙
E.enemy6 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, dt, u, hp, aura_color)
                local obj = New(enemy, x, y, sty.FAIRY_MIDDLE_3_RED, --style
                        hp or 500, --hp
                        true,  --show_hpbar
                        system.DROP_BIG_ENEMY, --drop
                        false, --no_count
                        D.clearBullet.main, --death
                        true --type
                )
                enemy.setBoundTime(obj, 1200)
                enemy.changeAura(obj, aura_color, "big")
                enemy.setTauntRank(obj, enemy.BIG_TAUNT)
                setProtectTime(obj, 120)
                S.shooter6_2.main(obj, dt + 30, u) --给这个小怪装上发射器
                for u = -1, 1, 2 do
                    _connect(obj, E.enemy6_1.create(obj, 100*u, 40, dt, u), 1, true)
                    _connect(obj, E.enemy6_3.create(obj, 60*u, -20, dt), 1, true)
                end
                return obj
            end
            return create
        end
)
E.enemy6_1 = BS.createEnemy(
        function(diff, rank)
            local function create(mst, dx, dy, dt, u)
                local obj = New(enemy, mst.x, mst.y, sty.FIRE_RED, --style
                        9999, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                enemy.setBoundTime(obj, 1200)
                obj.show_aura = true
                enemy.setTauntRank(obj, enemy.SERVANT_TAUNT)
                setSizeAndColli(obj, 1.25, 1.25)
                S.shooter6_1.main(obj, dt, u, -u) --给这个小怪装上发射器
                task.New(obj, function()
                    local t = 60
                    dx, dy = dx/t, dy/t
                    local x, y = 0, 0
                    for _ = 1, t do
                        if IsValid(mst) then
                            x, y = x + dx, y + dy
                            obj.x, obj.y = mst.x + x, mst.y + y
                        else
                            Del(obj)
                            break
                        end
                        task.Wait(1)
                    end
                    while IsValid(mst) do
                        obj.x, obj.y = mst.x + x, mst.y + y
                        task.Wait(1)
                    end
                end)
                return obj
            end
            return create
        end
)
E.enemy6_3 = BS.createEnemy(
        function(diff, rank)
            local function create(mst, dx, dy, dt)
                local obj = New(enemy, mst.x, mst.y, sty.FIRE_RED, --style
                        9999, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                obj.show_aura = true
                enemy.setTauntRank(obj, enemy.SERVANT_TAUNT)
                setSizeAndColli(obj, 1.25, 1.25)
                S.shooter6_3.main(obj, dt) --给这个小怪装上发射器
                task.New(obj, function()
                    local t = 60
                    dx, dy = dx/t, dy/t
                    local x, y = 0, 0
                    for _ = 1, t do
                        if IsValid(mst) then
                            x, y = x + dx, y + dy
                            obj.x, obj.y = mst.x + x, mst.y + y
                        else
                            Del(obj)
                            break
                        end
                        task.Wait(1)
                    end
                    while IsValid(mst) do
                        obj.x, obj.y = mst.x + x, mst.y + y
                        task.Wait(1)
                    end
                end)
                return obj
            end
            return create
        end
)

--正弦波妖精
E.enemy7 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, dt1, dt2, p, u)
                local obj = New(enemy, x, y, sty.TAICHI_BLUE, --style
                        80, --hp
                        true,  --show_hpbar
                        system.DROP_MID_ENEMY --drop
                )
                S.shooter7_1_1.main(obj, dt1)
                S.shooter7_1_2.main(obj, dt2)
                --boundWait(obj, 600)
                enemy.setBoundTime(obj, 600)
                obj.c_x, obj.c_y = x, y
                setSizeAndColli(obj, 2, 2)
                task.New(obj, function()
                    local vy = -1
                    local dp = 3*u
                    while true do
                        p = p + dp
                        obj.c_y = obj.c_y + vy
                        obj.x, obj.y = obj.c_x + 50*sin(0.75*p), obj.c_y + 30*sin(p)
                        task.Wait(1)
                    end
                end)
                return obj
            end
            return create
        end
)
--连线鬼火
E.enemy7_1 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, p, u)
                local obj = New(enemy, x, y, sty.FIRE_CYAN, --style
                        9999, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY, --drop
                        false, --no_count
                        D.death7_1.main, --death
                        false --type
                )
                obj.show_aura = true
                obj.i = 0 --为死尸弹之用，先赋值默认值0
                enemy.setBoundTime(obj, 600)
                obj.colli = false --鬼火是没判定的
                robject.set_color(obj, "", 100, 255, 255, 255)
                setSizeAndColli(obj, 1.5, 1.5)
                task.New(obj, function()
                    obj.layer = LAYER_ENEMY - 1
                    obj.c_x, obj.c_y = x, y
                    local vy = -1
                    local dp = 3*u
                    local t = 0
                    while true do
                        p = p + dp
                        obj.c_y = obj.c_y + vy
                        obj.x, obj.y = obj.c_x + 50*sin(0.75*p), obj.c_y + 30*sin(p)
                        t = t - 1
                        if Dist(obj, player) < 32 and t <= 0 then
                            PlaySound("kira00")
                            stg.newStrChV(obj.x, obj.y, 0.25, 3, Angle(obj, player), 30, 30, stg.arrow_big, COLOR_BLUE)
                            t = 4
                        end
                        task.Wait(1)
                    end
                end)
                return obj
            end
            return create
        end
)
--endregion

--region Object Defined
--endregion

--region 标题定义

local title, white
title = Class(object)
function title:init(x, y)
    self.x, self.y = x, y
    self.img = "s4_road_title1"
    self.layer = LAYER_BG + 1
    self.hscale, self.vscale = 0.75, 0
    robject.set_color(self, "", 255, 255, 255, 255)
    --形状，透明度变化
    task.New(self, function()
        for x = 0, 90, 90/60 do
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
    robject.set_color(self, "", 255, r, g, b)
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
                New(white, x, y - 15*u, 2*u, 255, 255, 100)
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
    New(stage4_background, self.sence)
    loadRes()
    LoadMusicRecord("s4")

    R.updateByRankChange() --初始化一次
    
    task.Wait(60)
    self.timer = 0 --计时清零
end

--道中片段1
local createMidBoss = lstg.DoFile(EISlib.stage.path.."stage4/mid_boss.lua")
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
s4_road.midBoss = midBossMain
function R.FIRST(pratice)
    local self = lstg.tmpvar.current_road
    --0f
    local t = 0
    if IsValid(self) then
        if pratice then
            self.timer = t
        else
            --等到tf
            while self.timer < t do
                task.Wait(1)
            end
        end
        EISlib.stage.playMusic("s4", t / 60, true) -- 要解锁音乐室
        if self.timer == t then
            self.sence = 1
            --敌人定义
            local ce1, ce2, ce3, ce4
            local ce4group
            do
                --开幕仅一只大型敌人
                function ce1(x, y)
                    local obj = E.enemy6.create(x, y, 60, 1, 500, COLOR_ORANGE)
                    T.moveAndLeaveScreen1.main(obj, -90)
                end
                --远处出现的小型敌人
                function ce2(x, y, a)
                    local obj = E.enemy1.create(x, y, 100)
                    T.move1_1.main(obj, a)
                end
                --中型敌人
                function ce3(x, y, u)
                    local obj = E.enemy3.create(x, y, 60)
                    T.move3_1.main(obj, u)
                end
                function ce4(x, y, da)
                    local obj = E.enemy1.create(x, y, 90)
                    T.move1_2.main(obj, da)
                end
                function ce4group(n, x0, xrange)
                    local dx = xrange/(n-1)
                    x0 = x0 - 0.5*xrange
                    tasker(function()
                        for i = 0, n - 1 do
                            ce4(x0 + dx*i, 245 + 30*getRate(20+i), 5*getRate(40+i))
                            task.Wait(4)
                        end
                    end)
                end
            end
            local function ce2group(x, y, u)
                tasker(function()
                    for i = 1, 26 do
                        ce2(x, y, 90 + (80 + 30*getSignRate(i))*u)
                        task.Wait(10)
                    end
                end)
            end

            --道中版面定义
            do
                task.Wait(400)
                --createTitle(0, 100)
                task.Wait(240)
                ce1(0, 260)
                task.Wait(80)
                for u = -1, 1, 2 do
                    ce2group(100*u, 80, u) --x, y, u
                end
                task.Wait(210)
                ce3(30, 0, 1) --x, y, u
                task.Wait(90)
                ce3(-30, 0, 1) --x, y, u
                task.Wait(90)
                ce3(-100, 0, 1) --x, y, u
                task.Wait(90)
                for i = 0, 2 do
                    ce4group(6, -30 + 30*i, 150)
                    task.Wait(30)
                end
                for i = 0, 2 do
                    ce4group(6, 30 - 30*i, 150)
                    task.Wait(30)
                end
                task.Wait(120)
                createTitle(0, 100)
            end
        end
    end
end

--道中片段2
function R.SECOND(pratice)
    local self = lstg.tmpvar.current_road
    --1800f
    local t = 1700
    if IsValid(self) then
        if pratice then
            self.timer = t
            audio.playMusic("s4", 1.0, t/60)
        else
            --等到tf
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer == t then
            self.sence = 2
            local ce1, ce2, ce3, ce4 --鬼火 中怪 小怪 下蛋怪
            local ce1group, ce2group, ce3group, ce4group
            do
                function ce1(x, y, x1, y1, u, i)
                    local obj = E.enemy2.create(x, y, 90, 125, i)
                    T.move2_1.main(obj, u, x1, y1)
                end
                function ce1group(n, u)
                    tasker(function()
                        for i = 1, n do
                            ce1(50*getRate(50 + i), 40 + 60*getRate(i)*u, (-50 + 10*(i - 1) + 6*getSignRate(20 + i))*u, 245 + 30*getRate(30 + i), u, i-1)
                            task.Wait(3)
                        end
                    end)
                end
                function ce2(y, u)
                    local obj = E.enemy3.create(-300*u, 60, 90) --x, y, dt
                    T.move3_2.main(obj, u, -120*u, y)
                end
                function ce2group(n, y0, u, wait)
                    wait = wait or 60
                    tasker(function()
                        for i = 0, n - 1 do
                            ce2(y0 - 20*i, u)
                            task.Wait(wait)
                            u = -u
                        end
                    end)
                end
                function ce3(x, y, da)
                    local obj = E.enemy1.create(x, y, 90)
                    T.move1_2.main(obj, da)
                end
                function ce3group(n, x0, xrange)
                    local dx = xrange/(n-1)
                    x0 = x0 - 0.5*xrange
                    tasker(function()
                        for i = 0, n - 1 do
                            ce3(x0 + dx*i, 245 + 30*getRate(20+i), 5*getRate(40+i))
                            task.Wait(4)
                        end
                    end)
                end
                function ce4(x, y)
                    local obj = E.enemy4.create(x, y, 20)
                    T.move4.main(obj)
                end
                function ce4group(n, x0, xrange, y0, u, wait)
                    local dx = xrange/(n-1)
                    tasker(function()
                        for i = -(n-1)/2, (n-1)/2 do
                            ce4(x0 + dx*i*u, y0)
                            task.Wait(wait)
                        end
                    end)
                end
            end

            --道中本体
            do
                --鬼火+中妖精
                local n = 8
                for i = 0, 1 do
                    for _ = 1, 2 do
                        for u = -1, 1, 2 do
                            ce1group(n, u*tranU(i))
                            task.Wait(3*n)
                            n = n + 1
                            task.Wait(30)
                        end
                    end
                    task.Wait(60)
                    ce2group(2, 144, tranU(i))
                    if i == 1 then
                        task.Wait(30)
                    else
                        task.Wait(60*(2+i))
                    end
                end
                task.Wait(120)
                --2606
                task.Wait(94)
                --2700
                tasker(function()
                    for u0 = -1, 1, 2 do
                        ce2group(2, 144, u0, 100) --n, y, u, wait
                        task.Wait(200)
                    end
                end)
                task.Wait(100)
                tasker(function()
                    for u0 = -1, 1, 2 do
                        for u = -u0, u0, 2*u0 do
                            --SystemLog("出现时间："..self.timer)
                            ce3group(8, 50*u, 250*u) --n, x0, xrange
                            task.Wait(100)
                        end
                    end
                end)
                task.Wait(380-94)

                task.Wait(120)
                ce4group(2, 0, 128, 255, tranU(1), 30) --n, x0, xrange, y0, u, wait
                task.Wait(180)
                ce4group(3, 0, 192, 255, tranU(2), 30) --n, x0, xrange, y0, u, wait
                task.Wait(210)
                ce4group(4, 0, 288, 255, tranU(3), 30) --n, x0, xrange, y0, u, wait
                task.Wait(300)
                --
                for _ = 1, 2 do
                    for u0 = -1, 1, 2 do
                        ce2group(2, 144, u0, 90) --n, y, u, wait
                        for u = -u0, u0, 2*u0 do
                            task.Wait(80)
                            ce1group(8, u) --n, u
                        end
                        task.Wait(20)
                    end
                end
            end
        end
    end
end

function R.THIRD(pratice)
    local self = lstg.tmpvar.current_road
    --4800f
    local t = 4800
    if IsValid(self) then
        if pratice then
            self.timer = t
            audio.playMusic("s4", 1.0, t/60)
        else
            --等到4800f
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer == t then
            self.sence = 3
            --小怪定义
            local ce1, ce1group
            do
                function ce1(x, y)
                    local obj = E.enemy4.create(x, y, 20)
                    T.move4.main(obj)
                end
                function ce1group(n, x0, xrange, y0, u, wait)
                    local dx = xrange/(n-1)
                    tasker(function()
                        for i = -(n-1)/2, (n-1)/2 do
                            if not IsValid(_boss) then
                                ce1(x0 + dx*i*u, y0)
                            end
                            task.Wait(wait)
                        end
                    end)
                end
            end

            --道中本体(增援
            do
                clearEnemyAndBullet()
                New(mid_bosses[difficulty])
                local n = 3
                while self.timer < 5750 do
                    ce1group(n, 30, 180, 245, tranU(n), 30)
                    task.Wait(n*30 + 180)
                    n = min(n + 1, 5)
                end
            end
        end
    end
end

function R.FOURTH(pratice)
    local self = lstg.tmpvar.current_road
    --6000f
    local t = 6000
    if IsValid(self) then
        if pratice then
            self.timer = t
            audio.playMusic("s4", 1.0, t/60)
        else
            --等待到6080f
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer >= t then
            self.sence = 4
            --小怪定义
            local ce1 --锯刀阵
            local ce3
            local ce3group
            do
                function ce1(n, x0, xrange, y0, u)
                    --n个鬼火，一共n+2个敌人
                    xrange = xrange*u
                    local dx = xrange/(n+1)
                    x0 = x0 - 0.5*xrange - dx
                    local dp = 540/(n + 1)*u
                    local p = -dp + 180
                    local function phaseAddAdd()
                        p = p + dp
                        return p
                    end
                    local function x0AddAdd()
                        x0 = x0 + dx
                        return x0
                    end
                    local obj1 = E.enemy7.create(x0AddAdd(), y0, 0, 0, phaseAddAdd(), u) --(x, y, dt1, dt2, p, u)
                    local objs = {}
                    for _ = 0, n - 1 do
                        table.insert(objs,
                                E.enemy7_1.create(x0AddAdd(), y0, phaseAddAdd(), u) --x, y, p, u
                        )
                    end
                    local obj2 = E.enemy7.create(x0AddAdd(), y0, 0, 0, phaseAddAdd(), u) --x, y, p, dt1, dt2, u
                    obj1.twin = obj2 --互相绑定
                    obj2.twin = obj1
                    --连锁爆炸
                    tasker(function()
                        while IsValid(obj1) and IsValid(obj2) do
                            task.Wait(1)
                        end
                        local obj
                        if IsValid(obj2) then
                            for i = 1, n do
                                obj = objs[i]
                                if IsValid(obj) then
                                    obj.i = i - 1
                                    Kill(obj)
                                end
                                task.Wait(3)
                            end
                            if IsValid(obj2) then
                                Kill(obj2)
                            end
                        else
                            for i = n, 1, -1 do
                                obj = objs[i]
                                if IsValid(obj) then
                                    obj.i = (n - i)
                                    Kill(obj)
                                end
                                task.Wait(3)
                            end
                            if IsValid(obj1) then
                                Kill(obj1)
                            end
                        end
                    end)
                end

                function ce3(x, y, da)
                    local obj = E.enemy1.create(x, y, 90)
                    T.move1_2.main(obj, da)
                end
                function ce3group(n, x0, xrange)
                    local dx = xrange/(n-1)
                    x0 = x0 - 0.5*xrange
                    tasker(function()
                        for i = 0, n - 1 do
                            ce3(x0 + dx*i, 245 + 30*getRate(20+i), 5*getRate(40+i))
                            task.Wait(4)
                        end
                    end)
                end
            end

            --道中本体
            do
                task.New(self, function()
                    --6000
                    local u
                    for i = 0, 11 do
                        u = tranU(i)
                        if not IsValid(_boss) then
                            ce3group(8, 50*u, 250*u) --n, x0, xrange
                        end
                        task.Wait(100)
                    end
                end)
                task.Wait(140)
                local wt, dwt = 200, -40/9
                for i = 0, 10 do
                    if not IsValid(_boss) and i > 5 then
                        --SystemLog("阴阳玉出现时间："..self.timer)
                        ce1(16 + 1*i, -30*tranU(i), 250, 270, tranU(i)) --n, x0, xrange, y0, u
                    end
                    task.Wait(wt)
                    wt = wt + dwt
                end
                --task.Wait(300)
            end
        end
    end
end

function R.FIFTH(pratice)
    local self = lstg.tmpvar.current_road
    --8310f
    local t = 8310
    if IsValid(self) then
        if pratice then
            self.timer = t
            audio.playMusic("s4", 1.0, t/60)
        else
            --等待到8310f
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer == t then
            self.sence = 5
            --小怪定义
            local ce1, ce2, ce3, ce4, ce5 --超大怪，一排鬼火，一排小怪, 中怪
            local ce2group, ce3group, ce4group
            do
                --开幕仅一只大型敌人
                function ce1(x, y)
                    local obj = E.enemy6.create(x, y, 60, -1, 500, COLOR_ORANGE)
                    T.moveAndLeaveScreen1.main(obj, -90)
                end
                function ce2(x, y, x1, y1, u, i)
                    local obj = E.enemy2.create(x, y, 90, 125, i, 8)
                    T.move2_1.main(obj, u, x1, y1)
                end
                function ce2group(n, x0, xrange, u)
                    x0 =  x0 - 0.5*xrange
                    local dx = xrange/(n - 1)
                    tasker(function()
                        for i = 1, n do
                            ce2(50*getRate(50 + i), 40 + 60*getRate(i)*u, (x0 + dx*i + 6*getSignRate(20 + i))*u, 245 + 30*getRate(30 + i), u, i-1)
                            task.Wait(3)
                        end
                    end)
                end
                function ce3(x, y, da)
                    local obj = E.enemy1.create(x, y, 90, 6)
                    T.move1_2.main(obj, da)
                end
                function ce3group(n, x0, xrange)
                    local dx = xrange/(n-1)
                    x0 = x0 - 0.5*xrange
                    tasker(function()
                        for i = 0, n - 1 do
                            ce3(x0 + dx*i, 245 + 30*getRate(20+i), 5*getRate(40+i))
                            task.Wait(4)
                        end
                    end)
                end
                function ce4(x, y, u)
                    local obj = E.enemy3.create(x, y, 60)
                    T.move3_1.main(obj, u)
                end
                function ce4group(n, x, y, u0)
                    local dx, dy = 40, 0
                    tasker(function()
                        for _ = 0, n - 1 do
                            for u = -u0, u0, 2*u0 do
                                ce4(x + dx*u + 20*u, y + dy - 195, u)
                                task.Wait(60)
                                dy = dy + 15
                            end
                            dx = dx + 20
                        end
                    end)
                end
                function ce5(x, y)
                    local obj = E.enemy5.create(x, y, 90, 360) --x, y, dt, range
                    T.move5_1.main(obj)
                end
            end

            --道中本体
            do
                local u = 1
                for _ = 0, 5 do
                    ce2group(10, 0, 270, u) --n, x0, xrange, u
                    ce3group(10, 0, 300*u) --n, x0, xrange
                    task.Wait(120)
                    u = -u
                end
                task.Wait(30)
                ce4group(3, 0, 120, 1) --n, x, y, u0
                task.Wait(120)
                ce5(0, 250)
                task.Wait(330)
                for _ = 1, 3 do
                    for u = -1, 1, 2 do
                        ce3group(7, 30*u, 300*u) --n, x, xrange
                        task.Wait(15)
                    end
                end
                task.Wait(90)
                ce4group(4, 0, 120, 1) --n, x, y, u0
                task.Wait(120)
                for u = -1, 1, 2 do
                    ce5(80*u, 250)
                end
                --SystemLog("p5结束时间："..self.timer)
            end
        end
    end
end

function R.SIXTH(pratice)
    local self = lstg.tmpvar.current_road
    --10360f
    local t = 10360
    if IsValid(self) then
        if pratice then
            self.timer = t
            audio.playMusic("s4", 1.0, t/60)
        else
            --等待到10420f
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer == t then
            self.sence = 6
            --小怪定义
            local ce1, ce2, ce3, ce4, ce5, ce6 --超大怪，一排鬼火，一排小怪, 中怪， 超大怪
            local ce2group, ce3group, ce4group
            do
                --开幕仅一只大型敌人
                function ce1(x, y)
                    local obj = E.enemy6.create(x, y, 60, -1, 500, COLOR_ORANGE)
                    T.moveAndLeaveScreen1.main(obj, -90)
                end
                function ce2(x, y, x1, y1, u, i)
                    local obj = E.enemy2.create(x, y, 90, 125, i, 8)
                    T.move2_1.main(obj, u, x1, y1)
                end
                function ce2group(n, x0, xrange, u)
                    x0 =  x0 - 0.5*xrange
                    local dx = xrange/(n - 1)
                    tasker(function()
                        for i = 1, n do
                            ce2(50*getRate(50 + i), 40 + 60*getRate(i)*u, (x0 + dx*i + 6*getSignRate(20 + i))*u, 245 + 30*getRate(30 + i), -u, i-1)
                            task.Wait(5)
                        end
                    end)
                end
                function ce3(x, y, da)
                    local obj = E.enemy1.create(x, y, 90, 6)
                    T.move1_2.main(obj, da)
                end
                function ce3group(n, x0, xrange)
                    local dx = xrange/(n-1)
                    x0 = x0 - 0.5*xrange
                    tasker(function()
                        for i = 0, n - 1 do
                            ce3(x0 + dx*i, 245 + 30*getRate(20+i), 5*getRate(40+i))
                            task.Wait(4)
                        end
                    end)
                end
                function ce4(x, y, u)
                    local obj = E.enemy3.create(x, y, 60)
                    T.move3_1.main(obj, u)
                end
                function ce4group(n, x, y, u0)
                    local dx, dy = 40, 0
                    tasker(function()
                        for _ = 0, n - 1 do
                            for u = -u0, u0, 2*u0 do
                                ce4(x + dx*u + 20*u, y + dy - 195, u)
                                task.Wait(60)
                                dy = dy + 15
                            end
                            dx = dx + 20
                        end
                    end)
                end
                function ce5(x, y)
                    local obj = E.enemy5.create(x, y, 90, 360) --x, y, dt, range
                    T.move5_1.main(obj)
                end
                --与开幕仅一只大型敌人相同的敌人
                function ce6(x, y, aura_color)
                    local obj = E.enemy6.create(x, y, 60, 1, 500, aura_color)
                    T.moveAndLeaveScreen1.main(obj, -90)
                end
            end

            --道中本体
            do
                --一群小怪中夹着一只大怪
                for _ = 1, 3 do
                    for u = -1, 1, 2 do
                        ce3group(7, 30*u, 300*u) --n, x, xrange
                        task.Wait(15)
                    end
                end
                for _ = 1, 1 do
                    for u = -1, 1, 2 do
                        ce3group(7, 30*u, 300*u) --n, x, xrange
                        task.Wait(15)
                    end
                end
                task.Wait(90+60)
                ce6(0, 260, COLOR_ORANGE) --x, y
                task.Wait(330)
                --一群鬼火 + 两只消弹妖精
                ce5(-60, 320)
                for i = 0, 2 do
                    for u = -1, 1, 2 do
                        ce2group(8, (120 - 60*i)*u, 60, u) --n, x0, xrange, u
                        task.Wait(40)
                    end
                end
                ce5(60, 320)
                for i = 3, 4 do
                    for u = -1, 1, 2 do
                        ce2group(8, (120 - 60*i)*u, 60, u) --n, x0, xrange, u
                        task.Wait(40)
                    end
                end
                for i = 0, 2 do
                    for u = -1, 1, 2 do
                        ce2group(8, -(60 - 60*i)*u, 60, u) --n, x0, xrange, u
                        task.Wait(40)
                    end
                end
                task.Wait(150)
                ce6(0, 260, COLOR_GREEN) --x, y
                task.Wait(510)
                --12260
                task.Wait(190)
                --12450
                clearEnemyAndBullet()
                system.PowerRank.pauseHyper()
                task.Wait(420)
            end
        end
    end
end

return R
