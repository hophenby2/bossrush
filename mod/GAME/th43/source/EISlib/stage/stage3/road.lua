-----------------------------------------
---东方栖霞园道中 Stage3
-----------------------------------------
---@class  EISlib.stage.stage3.road
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
    local res_name = "s3_road_"
    local path = "res/stage/stage3/"
    LoadImageFromFile(res_name.."flower_fairy", path.."flower_fairy.png")
    LoadImageFromFile(res_name.."flower_fairy2", path.."flower_fairy2.png")
    --关卡标题
    LoadImageFromFile(res_name.."title1", path.."title1.png")
    -- 开场对话
    local tex_ = r18g.findfile("dialog/stage3p1.png")
    if not tex_ then
        tex_ = "res/lang/zh_cn/dialog/stage3p1.png" -- fallback
    end
    if tex_ then
        lstg.LoadTexture("tex:stage3-dialog1", tex_)
        lstg.LoadImage(res_name.."dialog1", "tex:stage3-dialog1", 0,   0, 610, 294)
        lstg.LoadImage(res_name.."dialog2", "tex:stage3-dialog1", 0, 294, 610, 294)
    else
        -- fallback
        lstg.LoadImage(res_name.."dialog1", "basic", 2, 46, 1, 1)
        lstg.LoadImage(res_name.."dialog2", "basic", 2, 46, 1, 1)
    end
end

--region 藏妖精的花定义
local flower_fairy = Class(object)
function flower_fairy:init(x, y, type)
    self.x, self.y = x, y
    if type then
        self.img = "s3_road_flower_fairy2"
    else
        self.img = "s3_road_flower_fairy"
    end
    self.layer = LAYER_ENEMY + 1
    robject.set_color(self, "", 0, 255, 255, 255)
end
function flower_fairy:frame()
    task.Do(self)
end
function flower_fairy:render()
    EGGlib.RenderEffect.defaultRenderImg(self)
end
--endregion

local BS = EISlib.Bullet.Shooter
local no_info = 0
local no_info_t = 9999
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local sty = EISlib.Enemy.Style
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local setProtectTime = EGGlib.ObjectEvent.setProtectTime
local LS = EISlib.Bullet.Laser.laser
local lead_laser = EISlib.Bullet.Laser.lead_laser
local sect_layer1 = EGGlib.BulletGroup.Sector.layer1
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local tri_circle4 = EGGlib.BulletGroup.TriAngleStroke.circle4
local sect_normal1 = EGGlib.BulletGroup.Sector.normal1
local sect_normal2 = EGGlib.BulletGroup.Sector.normal2
local circle_normal1 = EGGlib.BulletGroup.Circle.normal1
local polygon3 = EGGlib.BulletGroup.polygon3
local sect_layer2 = EGGlib.BulletGroup.Sector.layer2

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

B.laser1 = BS.createBulletClass(
        function(diff, rank)
            local count = switch1(diff, {
                6, 9, 12, 15, 15
            }) + switch(rank, {
                0, 0, 0, 0, 3
            })
            local vy = switch1(diff, {
                1.5, 1.75, 2, 2.25, 2.25
            })/1.15*defaultSwitchVelocityByRank(rank)
            --比较特殊的参数，与层数有关
            local dd = switch1(diff, {
                3, 3, 1.75, 1.75
            })
            local color = {COLOR_GREEN, COLOR_BLUE, COLOR_RED, COLOR_PURPLE, COLOR_CYAN}
            local function create(mst1, mst2, n)
                local obj = New(lead_laser,
                        1, color[n - 2], --type, co
                        mst1.x, mst1.y, 10, Angle(mst1, mst2), --x, y, v, a
                        Dist(mst1, mst2), 12, 15, 1, --len, w0, w1, 1
                        true, false, 360 --islock, isshoot, last_time
                )
                obj.bound = false
                task.New(obj, function()
                    local head_len, trail_len = LS.getMaxLength(obj, 1), LS.getMaxLength(obj, 3)
                    local a, d
                    while IsValid(mst1) and IsValid(mst2) do
                        a, d = Angle(mst1, mst2), Dist(mst1, mst2)
                        obj.x, obj.y = mst1.x, mst1.y
                        LS.setRot(obj, a)
                        LS.setMaxLength(obj, 2, d - head_len - trail_len)
                        task.Wait(1)
                    end
                    while not obj.death do
                        task.Wait(1)
                    end
                    --死尸弹
                    PlaySound("kira00")
                    local dx, dy = cos(a), sin(a)
                    local dr, r = d/(count - 1)
                    local d_cen_len --距离中心多长
                    local h = 0.5*d*lstg.tan(90*(n - 2)/n) --赣你妈为什么math.tan是错的
                    local bullet
                    for i = 0, count - 1 do
                        for u = 1, -0.75, -dd do
                            r = dr*i
                            d_cen_len = 0.5*d - r
                            bullet = stg.newBullet(obj.x + r*dx, obj.y + r*dy, stg.grain_b, color[n - 2])
                            EGGlib.ObjectEvent.addV3(bullet,
                                    vy*d_cen_len/h*u, vy*u, a --vx, vy, drot
                            )
                            bullet.rot = Angle(0, 0, bullet.vx, bullet.vy)
                        end
                    end
                    Del(obj)
                end)
                return obj
            end
            return create
        end
)

--region Pointer Defined
--基础道中自机狙发射点
P.pointer1 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                1, 1, 3, 3, 1
            }) + switch(rank, {
                0, 0, 0, 0, 2
            })
            --E难度锁定1way
            if diff == 1 then
                way = 1
            end
            --是1颗单独的子弹还是三颗并排
            local way2
            if diff == 1 and rank < 4 then
                way2 = 1
            else
                way2 = 3
            end
            --每way间的间隔
            local da = 35
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
            local style, color = stg.grain_a, COLOR_RED
            local function bullet_func0(x, y, v, a)
                --有弹雾的
                return stg.newStrChV(x, y, 0.25, v0, a, 60, 20, style, color)
            end
            local function bullet_func(x, y, v, a)
                polygon3(x + 10*cos(a), y + 10*sin(a), 5, --x, y, dsc,
                        v, 0, a, 0, --v, dvc, a, rot
                        way2, bullet_func0 --n, singleBulletFunc
                )
            end
            local function attack(x, y, a, co)
                PlaySound("tan00")
                color = co or COLOR_RED
                sect_layer1(x, y, v0, a, way, da, --base
                        layer, dv, 0, --layer, dv_l, da_l
                        bullet_func
                )
            end
            return attack
        end
)
--中型敌人的固定角度扩散攻击
P.pointer2 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = 3 + switch(rank, {
                0, 0, 0, 0, 2
            })
            local da = switch1(diff, {
                15, 15, 15, 15, 15
            }) --每way间的间隔
            --case：层数
            local layer = 1
            --case：初始弹速
            local v0 = switch1(diff, {
                1.75, 2, 2.5, 3, 1.55
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv_l = switch1(diff, {
                0.25, 0.3, 0.35, 0.4, 0.4
            })
            local style, color = stg.grain_b, COLOR_RED
            local function bullet_func(x, y, v, a)
                setSizeAndColli(stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color), 1, 1)
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            sect_layer1(x, y, v0, a, way, da, --base
                                    layer, dv_l, 0, --layer, dv_l, da_l
                                    bullet_func
                            )
                        end)
            end
            return attack
        end
)
--中型敌人的使魔的自机狙
P.pointer2_1 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = 2 + switch(rank, {
                0, 0, 0, 0, 2
            })
            local da = 25
            --每way间的间隔
            --case：层数
            local layer = 1
            --case：初始弹速
            local v0 = switch1(diff, {
                1.75, 2, 2.5, 3, 1.55
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv_l = switch1(diff, {
                0.25, 0.3, 0.35, 0.4, 0.4
            })
            local style, color = stg.grain_b, COLOR_CYAN
            local function bullet_func(x, y, v, a)
                setSizeAndColli(stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color), 1, 1)
            end
            local function attack(x, y, a, co)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            sect_layer1(x, y, v0, a, way, da, --base
                                    layer, dv_l, 0, --layer, dv_l, da_l
                                    bullet_func
                            )
                        end)
            end
            return attack
        end
)

--大型敌人本体的开花攻击
P.pointer3 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                6, 6, 6, 6, 6
            })
            local sp = 2*360/way
            --case：层数
            local layer = switch1(diff, {
                6, 8, 10, 12, 12
            }) + switch(rank, {
                0, 0, 0, 0, 2
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                1.25, 1.5, 1.5, 1.75, 2
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv_l = switch1(diff, {
                0.17, 0.17, 0.17, 0.17, 0.17
            })*defaultSwitchVelocityByRank(rank)
            local style, color = stg.star_small, COLOR_DEEP_PURPLE
            local function bullet_func(x, y, v, a)
                stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color).omiga = -3
            end
            local function attack(x, y, a)
                PlaySound("kira00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            tri_circle4(x, y, v0, dv_l, a, sp, layer,
                                    way,
                                    bullet_func
                            )
                        end)
            end
            return attack
        end
)

--大型敌人一侧使魔的攻击
P.pointer3_1 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                3, 4, 4, 4, 4
            }) + switch(rank, {
                0, 0, 0, 0, 1
            })
            local da = switch1(diff, {
                3, 3, 3, 3, 3
            }) --每way间的间隔
            --case：层数
            local layer = switch1(diff, {
                1, 1, 2, 2, 2
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                2, 2.25, 2.5, 3, 2
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv_l = switch1(diff, {
                0, 0, 0.3, 0.3, 0.3
            })
            local style, color = stg.star_big, COLOR_DEEP_RED
            local function bullet_func(x, y, v, a)
                stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color).omiga = -3
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            sect_layer1(x, y, v0 , a, way, da, --base
                                    layer, dv_l, 0, --layer, dv_l, da_l
                                    bullet_func
                            )
                        end)
            end
            return attack
        end
)

--大型敌人另两个使魔不断攻击
P.pointer3_2 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                4, 5, 6, 7, 7
            })
            local da = switch1(diff, {
                90, 90, 90, 90, 90
            })/(way - 1) --每way间的间隔
            --case：层数
            local layer = switch1(diff, {
                1, 1, 1, 1, 1
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                1.5, 1.75, 2, 2.25, 3
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv0 = switch1(diff, {
                no_info, no_info, no_info, no_info, no_info
            })
            local style, color = stg.star_small, COLOR_DEEP_RED, 1
            local function attack(x, y, dv, a, dway, s)
                PlaySound("tan00")
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStraight(x, y, v, a, style, color).omiga = -3
                end
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            sect_layer1(x, y, v0 + dv, a, way + dway, da, --base
                                    layer, dv0, 0, --layer, dv_l, da_l
                                    bullet_func
                            )
                        end)
            end
            return attack
        end
)

--中型长条弹敌人攻击
P.pointer4 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = 1
            local da = 0
            --case：层数
            local layer = switch1(diff, {
                2, 3, 4, 4, 5
            })
            local ds = 0.4/(layer - 1)
            --case：初始弹速
            --case：每层弹速差
            local dv = switch1(diff, {
                0.125, 0.125, 0.125, 0.125, 0.125
            })
            local style, color = stg.grain_b, COLOR_BLUE
            local function bullet_func(x, y, v, a)
                local dx, dy = -5*sin(a), 5*cos(a)
                for i = 0, layer - 1 do
                    for u = -1, 1, 2 do
                        setSizeAndColli(stg.newSimpleStraight(x + dx*u, y + dy*u, v + dv*i, a, style, color), 0.8 + ds*i, 0.8 + ds*i)
                    end
                end
            end
            local tb = {no_func, bullet_func}
            local function attack(x, y, a)
                --[[PlaySound("tan00")
                local dx, dy = -5*sin(a), 5*cos(a)
                for u = -1, 1, 2 do
                    local i = 1 + 0.5*(u + 1) --其实就是1和2
                    stg.newFadeEffect(x + dx*u, y + dy*u, style, color, false,
                            function()
                                sect_normal1(x, y, v0, a, way, da, --base
                                        tb[i]
                                )
                            end)
                end]]
            end
            return attack
        end
)

--黑蝴蝶
P.pointer6 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                6, 6, 8, 8, 6
            })
            local sp = 2*360/way
            --case：层数
            local layer = switch1(diff, {
                9, 10, 11, 12, 12
            }) + switch(rank, {
                0, 0, 0, 0, 1
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                1.5, 1.75, 2, 2.25, 2
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv_l = switch1(diff, {
                0.2, 0.2, 0.2, 0.2, 0.2
            })
            local style, color = stg.star_small, COLOR_DEEP_PURPLE
            local function bullet_func(x, y, v, a)
                local obj = stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color)
                obj.omiga = 3
                setSizeAndColli(obj, 1.2, 1.2)
            end
            local function attack(x, y, a)
                PlaySound("kira00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            tri_circle4(x, y, v0, dv_l, a, sp, layer,
                                    way,
                                    bullet_func
                            )
                        end)
            end
            return attack
        end
)

--黑蝴蝶一侧使魔的攻击
P.pointer6_1 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                4, 5, 5, 5, 4
            })
            local da = 5 --每way间的间隔
            --case：层数
            local layer = switch1(diff, {
                1, 1, 2, 2, 2
            }) + switch(rank, {
                0, 0, 0, 0, 1
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                1.5, 2, 2.8, 3.3, 3.3
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv_l = -0.3*defaultSwitchVelocityByRank(rank)
            local style, color = stg.star_big, COLOR_DEEP_RED
            local function bullet_func(x, y, v, a)
                local obj = stg.newSimpleStrChV(x, y, 0, v, a, 30, 0, style, color)
                obj.omiga = -3
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            sect_layer1(x, y, v0 , a, way, da, --base
                                    layer, dv_l, 0, --layer, dv_l, da_l
                                    bullet_func
                            )
                        end)
            end
            return attack
        end
)

--黑蝴蝶另两个使魔不断攻击
P.pointer6_2 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                3, 5, 7, 9, 9
            })
            local da = switch1(diff, {
                90, 90, 90, 90, 90
            })/(way - 1) --每way间的间隔
            --case：层数
            local layer = switch1(diff, {
                1, 1, 1, 1, 1
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                1.75, 2, 2.25, 2.5, 3
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv0 = switch1(diff, {
                no_info, no_info, no_info, no_info, no_info
            })
            local style, color = stg.star_small, COLOR_BLUE, 1
            local function attack(x, y, dv, a, dway)
                PlaySound("tan00")
                local function bullet_func(x, y, v, a)
                    local obj = stg.newSimpleStraight(x, y, v, a, style, color)
                    obj.omiga = 3
                end
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            sect_layer1(x, y, v0 + dv, a, way + dway, da, --base
                                    layer, dv0, 0, --layer, dv_l, da_l
                                    bullet_func
                            )
                        end)
            end
            return attack
        end
)

--叶子消失后产生的弹幕
P.leaf1 = BS.createPointer(
        function(diff, rank)
            --case:way数
            local way = switch1(diff, {
                1, 3, 4, 6, 6
            }) + switch(rank, {
                0, 0, 0, 0, 2
            })
            --
            local layer = switch1(diff, {
                1, 1, 1, 1, 1
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                1.5, 2, 2.5, 3, 3
            })*defaultSwitchVelocityByRank(rank)
            local style, color = stg.grain_a, COLOR_DEEP_RED
            --单个子弹
            local function bullet_func1(x, y, v, a)
                --有弹雾的
                return stg.newStrChV(x, y, 0.25, v0, a, 60, 20, style, color)
            end
            --同向的三个子弹呈三角形发射
            local function bullet_func2(x, y, v, a)
                for i = 0, layer - 1 do
                    polygon3(x + 10*cos(a), y + 10*sin(a), 5, --x, y, dsc,
                            v, 0, a, 60*i, --v, dvc, a, rot
                            3, bullet_func1 --n, singleBulletFunc
                    )
                end
            end
            local function attack(x, y, a, co)
                color = co or COLOR_DEEP_RED
                PlaySound("kira00")
                --因为原子弹生成时已经有弹雾了，所以不用再搞弹雾
                circle_normal1(x, y, v0, a, way, --base
                        bullet_func2
                )
            end
            return attack
        end
)

P.leaf2 = BS.createPointer(
        function(diff, rank)
            --case:way数
            local way = switch1(diff, {
                5, 6, 7, 9, 9
            })
            -- 一侧的排数
            local layer = 4
            --case：初始弹速
            local v0 = switch1(diff, {
                1.25, 1.5, 1.75, 2, 2
            })*defaultSwitchVelocityByRank(rank)
            local style, color = stg.grain_a, COLOR_DEEP_RED
            --单个子弹
            local function bullet_func1(x, y, v, a)
                --有弹雾的
                return stg.newStrChV(x, y, 0.25 + v, 2*v, a, 60, 20, style, color)
            end
            --同向的三个子弹呈三角形发射
            local function bullet_func2(x, y, v, a)
                local b = layer - 1
                local dx, dy
                for i = -b, b do
                    dx = 10 - 10*abs(i)
                    dy = 5*i
                    bullet_func1(x + dx*cos(a) + dy*cos(a + 90), y + dx*sin(a) + dy*sin(a + 90), v, a)
                end
            end

            local attack
            if rank < 4 then
                function attack(x, y, a)
                    PlaySound("kira00")
                    circle_normal1(x, y, v0, a, way, --base
                            bullet_func2
                    )
                end
            else
                --爆H则再加一层弹速偏慢，错开的开花
                local da = 180/way
                local dv = -0.4*v0
                function attack(x, y, a)
                    PlaySound("kira00")
                    for i = 0, 1 do
                        circle_normal1(x, y, v0 + dv*i, a + da*i, way, --base
                                bullet_func2
                        )
                    end
                end
            end
            return attack
        end
)


--endregion

--region Shooter Defined
--基础道中自机狙发射器
S.shooter1_1 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                15, 15, 0, 0, 0
            })
            --case：持续攻击时间
            local total_time = 150
            --case：攻击间隔
            local wait = switch1(diff, {
                60, 50, 40, 30, 20
            })
            local function shooter(e, dt, co)
                dt = dt or 0
                dt = max(-start_time_left, dt) --限制一下
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            while true do
                                P.pointer1.attack(e.x, e.y, Angle(e, player), co)
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

--绑给小妖精的开花弹幕
S.shooter1_2 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = 0
            --case：持续攻击时间
            local total_time = switch1(diff, {
                130, 130, 131, 130, 130
            })
            --case：攻击间隔
            local wait = switch1(diff, {
                90, 90, 65, 60, 60
            })
            local function shooter(e, dt, co)
                dt = dt or 0
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            while true do
                                P.leaf1.attack(e.x, e.y, Angle(e, player) + ran:Float(-2, 2), co)
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)
--中型敌人本体发射的连续自机狙
S.shooter2 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                105, 90, 75, 60, 60
            })
            --case：持续攻击时间
            local total_time = 299
            local count = switch1(diff, {
                3, 4, 5, 6, 6
            })
            local wait0 = 5
            --case：攻击间隔
            local wait = 60
            local function shooter(e, dt, co)
                dt = dt or 0
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            local a
                            for _ = 0, 3 do
                                a = Angle(e, player)
                                task.New(e, function()
                                    for _ = 0, count - 1 do
                                        P.pointer2.attack(e.x, e.y, a, co)
                                        task.Wait(wait0)
                                    end
                                end)
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)
--中型敌人的使魔发射的连续自机狙
S.shooter2_1 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                105, 90, 75, 60, 60
            })
            --case：持续攻击时间
            local total_time = 300
            local count = switch1(diff, {
                1, 2, 3, 4, 4
            })
            local wait0 = 5
            --case：攻击间隔
            local wait = 60
            local function shooter(e, dt, co)
                dt = dt or 0
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            local a
                            for _ = 0, 3 do
                                a = Angle(e, player)
                                task.New(e, function()
                                    for _ = 0, count - 1 do
                                        P.pointer2_1.attack(e.x, e.y, a, co)
                                        task.Wait(wait0)
                                    end
                                end)
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

--大型敌人本体子弹发射器
S.shooter3 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                50, 45, 40, 30, 30
            })
            local wait = 60
            local total_time = 180 + wait
            local function shooter(e, dt)
                dt = dt or 0
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            local a
                            while true do
                                a = Angle(e, player)
                                P.pointer3.attack(e.x, e.y, a)
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

--大型敌人一侧使魔的固定角度扩散攻击发射器
S.shooter3_1 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                0, 0, 0, 0, 0
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                241, 241, 241, 241, 241
            })
            local count = switch1(diff, {
                5, 5, 7, 9, 9
            })
            local da = 180/(count - 1)
            local wait0 = 60/count
            local function shooter(e, u, dt)
                dt = dt or 0
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            local way, a = (count - 1)/2
                            while true do
                                a = Angle(e, player)
                                task.New(e, function()
                                    for i = -way, way do
                                        P.pointer3_1.attack(e.x, e.y, a + da*i*u)
                                        task.Wait(wait0)
                                    end
                                end)
                                task.Wait(60)
                            end
                        end
                )
            end
            return shooter
        end
)

--大型敌人另两个使魔不断攻击
S.shooter3_2 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                0, 0, 0, 0, 0
            })
            --case：持续攻击时间
            local dv = switch1(diff, {
                -0.5, -0.5, -0.5, -0.5, -0.25
            })
            --case：攻击间隔
            local wait = switch1(diff, {
                60, 50, 40, 30, 30
            })
            local total_time = 211
            local function shooter(e, dt0, w_rate, u)
                w_rate = w_rate or 0
                local dt = 0*wait*w_rate + dt0
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            while true do
                                for i = 0, 1 do
                                    P.pointer3_2.attack(e.x, e.y, dv*i, -90 + 45*u, i)
                                end
                                if system.PowerRank.getRank() == 4 then
                                    task.Wait(0.5*wait)
                                else
                                    task.Wait(wait)
                                end
                            end
                        end
                )
            end
            return shooter
        end
)

--连续狙
S.shooter4 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                20, 15, 10, 0, 0
            }) + switch(rank, {
                30, 30, 30, 30, 30
            })
            --case：持续攻击时间
            local total_time = switch1(diff, {
                240, 240, 240, 240, 240
            })
            --case：攻击间隔
            local wait = switch1(diff, {
                40, 35, 30, 25, 25
            })*switch(rank, {
                1, 1, 1, 1, 0.75
            })
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            local a
                            while true do
                                a = Angle(e, player)
                                P.pointer4.attack(e.x, e.y, a)
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

--绑给中妖精的开花弹幕
S.shooter4_1 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                0, 0, 0, 0, 0
            })
            --case：持续攻击时间
            local total_time = 241
            --case：攻击间隔
            local wait = 80
            local function shooter(e, dt, co)
                dt = dt or 0
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            while true do
                                P.leaf2.attack(e.x, e.y, Angle(e, player) + ran:Float(-2, 2), co)
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

--黑蝴蝶本体子弹发射器
S.shooter6 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                50, 45, 40, 30, 30
            })
            --case：持续攻击时间
            local count = switch1(diff, {
                2, 3, 4, 5, 5
            })
            local wait = 240/count
            local total_time = 270
            local function shooter(e, dt)
                dt = dt or 0
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            local a
                            for _ = 0, count - 1 do
                                a = Angle(e, player)
                                P.pointer6.attack(e.x, e.y, a)
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

--黑蝴蝶一侧使魔的固定角度扩散攻击发射器
S.shooter6_1 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                50, 45, 40, 30, 30
            })
            --case：持续攻击时间
            local count = switch1(diff, {
                5, 5, 7, 9, 9
            })
            local da = 240/(count - 1)
            local wait0 = 60/count
            local total_time = 270
            local function shooter(e, u, dt)
                dt = dt or 0
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            local way, a = (count - 1)/2, Angle(e, player)
                            for i = -way, _infinite do
                                P.pointer6_1.attack(e.x, e.y, a + da*i*u)
                                task.Wait(wait0)
                            end
                        end
                )
            end
            return shooter
        end
)

--黑蝴蝶另两个使魔不断攻击
S.shooter6_2 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                50, 45, 40, 30, 30
            })
            --case：持续攻击时间
            local count = switch1(diff, {
                4, 6, 7, 9, 6
            })
            local dv = switch1(diff, {
                -0.5, -0.5, -0.5, -0.5, -0.25
            })
            --case：攻击间隔
            local wait = switch1(diff, {
                60, 50, 45, 40, 40
            })
            local total_time = 210
            local function shooter(e, dt0, w_rate)
                w_rate = w_rate or 0
                local dt = wait*w_rate + dt0
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            local a
                            for _ = 0, count - 1 do
                                a = Angle(e, player)
                                for i = 0, 1 do
                                    P.pointer6_2.attack(e.x, e.y, dv*i, a, i)
                                end
                                if system.PowerRank.getRank() < 4 then
                                    task.Wait(wait)
                                else
                                    task.Wait(0.5*wait)
                                end

                            end
                        end
                )
            end
            return shooter
        end
)
--endregion

--region Tasker Defined
--向某方向离开屏幕
T.leaveScreen1 = BS.createTasker(
        function(diff, rank)
            local function main(obj, a)
                task.New(obj, function()
                    task.Wait(120)
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
                    task.Wait(240)
                    velch(obj, -0.1, 1.2, a, 90, 150)
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
                    velch(obj, 4, 0.5, a, 15, 15)
                    task.Wait(420)
                    velch(obj, 0, 0.5, a, 30)
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
                    velch(obj, 5, 5, a, 30)
                    vach2(obj, 0, 90*u, 45, 45) --dv, da, tv, ta
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
D.death3 = EISlib.Bullet.Shooter.createTasker(
        function(diff, rank)
            local function main(e)
                local x, y, dr = e.x, e.y, e.dr
                enemy.createDeath(
                        1, --total_time,
                        function()
                            PlaySound("enep05")
                            EGGlib.ObjectEvent.clearBulletAndLaserInRangeCircle(
                                    x, y, 120 + dr, 2 --x, y, rmax, index
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
            local function create(x, y, hp, dt, st, co)
                local obj = New(enemy, x, y, st or sty.FAIRY_SMALL_BLUE, --style
                        hp, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                S.shooter1_1.main(obj, dt, co) --给这个小怪装上发射器
                return obj
            end
            return create
        end
)
--固定角度发射中玉的中型妖精
E.enemy2 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, st, dt, co)
                local obj = New(enemy, x, y, sty.FAIRY_MIDDLE_3_RED, --style
                        90, --hp
                        true,  --show_hpbar
                        system.DROP_MID_ENEMY, --drop
                        false, --no_count
                        nil, --death_func
                        true --type
                )
                S.shooter2.main(obj, st, dt, co) --给这个小怪装上发射器
                return obj
            end
            return create
        end
)
--用作中型妖精使魔的自机狙鬼火
E.enemy2_1 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, hp, co, dt)
                local obj = New(enemy, x, y, sty.FIRE_BLUE, --style
                        9999, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                enemy.setTauntRank(obj, enemy.SERVANT_TAUNT)
                obj.show_aura = true
                S.shooter2_1.main(obj, dt, co) --给这个小怪装上发射器
                return obj
            end
            return create
        end
)
--大型妖精
E.enemy3 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, hp, dt, dr)
                local obj = New(enemy, x, y, sty.FAIRY_LARGE_RED, --style
                        hp, --hp
                        true,  --show_hpbar
                        system.DROP_BIG_ENEMY, --drop
                        false, --no_count
                        D.death3.main, --death
                        true --type
                )
                enemy.changeAura(obj, COLOR_RED, "big")
                obj.dr = dr or 0
                S.shooter3.main(obj, dt)
                return obj
            end
            return create
        end
)

--用作大型妖精使魔的自机狙鬼火
E.enemy3_1 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, hp, u, dt)
                local obj = New(enemy, x, y, sty.FIRE_RED, --style
                        9999, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                enemy.setTauntRank(obj, enemy.SERVANT_TAUNT)
                setSizeAndColli(obj, 1.25, 1.25)
                obj.show_aura = true
                S.shooter3_1.main(obj, u, dt) --给这个小怪装上发射器
                return obj
            end
            return create
        end
)

--用作大型妖精使魔的自机狙鬼火
E.enemy3_2 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, hp, dt0, w_rate, u)
                local obj = New(enemy, x, y, sty.FIRE_RED, --style
                        9999, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                enemy.setTauntRank(obj, enemy.SERVANT_TAUNT)
                setSizeAndColli(obj, 1.25, 1.25)
                obj.show_aura = true
                S.shooter3_2.main(obj, dt0, w_rate, u) --给这个小怪装上发射器
                return obj
            end
            return create
        end
)

--连续发长条狙的中型杂鱼
E.enemy4 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, hp, dt)
                local obj = New(enemy, x, y, sty.FAIRY_MIDDLE_3_BLUE, --style
                        hp, --hp
                        true,  --show_hpbar
                        system.DROP_MID_ENEMY --drop
                )
                S.shooter4.main(obj, dt) --给这个小怪装上发射器
                return obj
            end
            return create
        end
)

--排队枪毙的小怪
E.enemy5 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, hp, dt, st, co)
                local obj = New(enemy, x, y, st or sty.FAIRY_SMALL_RED, --style
                        hp, --hp
                        false,  --show_hpbar
                        {0, 1} --drop
                )
                S.shooter1_1.main(obj, dt, co) --给这个小怪装上发射器
                return obj
            end
            return create
        end
)

--黑蝴蝶
E.enemy6 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, hp, dt, dr)
                local obj = New(enemy, x, y, sty.FAIRY_LARGE_4_BLACK, --style
                        hp, --hp
                        true,  --show_hpbar
                        {30, 30}, --drop
                        false, --no_count
                        D.death3.main, --death
                        true --type
                )
                enemy.changeAura(obj, COLOR_GREEN, "middle")
                obj.dr = dr or 0
                S.shooter6.main(obj, dt)
                return obj
            end
            return create
        end
)

--用作大型妖精使魔的自机狙鬼火
E.enemy6_1 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, hp, u, dt)
                local obj = New(enemy, x, y, sty.FIRE_CYAN, --style
                        9999, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                enemy.setTauntRank(obj, enemy.SERVANT_TAUNT)
                setSizeAndColli(obj, 1.25, 1.25)
                obj.show_aura = true
                S.shooter6_1.main(obj, u, dt) --给这个小怪装上发射器
                return obj
            end
            return create
        end
)

--用作大型妖精使魔的自机狙鬼火
E.enemy6_2 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, hp, dt0, w_rate)
                local obj = New(enemy, x, y, sty.FIRE_CYAN, --style
                        9999, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                enemy.setTauntRank(obj, enemy.SERVANT_TAUNT)
                setSizeAndColli(obj, 1.25, 1.25)
                obj.show_aura = true
                S.shooter6_2.main(obj, dt0, w_rate) --给这个小怪装上发射器
                return obj
            end
            return create
        end
)

--隧道阴阳玉
E.enemy7 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y)
                local obj = New(enemy, x, y, sty.TAICHI_BLUE, --style
                        30, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY, --drop
                        false, --no_count
                        nil, --death
                        false --type
                )
                return obj
            end
            return create
        end
)
--endregion

--region Object Defined
local omigaChangeTask = EGGlib.ObjectEvent.omigaChangeTask
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
O.leaf1 = BS.createBulletClass(
        function(diff, rank)
            local function create(x, y, a, co)
                local obj = New(flower_fairy, x, y, co)
                obj.hscale, obj.vscale = 0.5, 0.5
                --移动
                velchTask(obj, 2.5, 0, a, 120)
                omigaChangeTask(obj, 3, 0.25, 60, 60)
                task.New(obj, function()
                    alphaAndSizeChange(obj, 255, 0.25, 90)
                    task.Wait(30)
                    --P.leaf1.attack(obj.x, obj.y, Angle(obj, player) + ran:Float(-2, 2), co)
                    velchTask(obj, 2, 4, -90, 45)
                    alphaAndSizeChange(obj, -255, -0.75, 45)
                    Del(obj)
                end)
                return obj
            end
            return create
        end
)

O.leaf2 = BS.createBulletClass(
        function(diff, rank)
            local function create(x, y, a)
                local obj = New(flower_fairy, x, y)
                obj.hscale, obj.vscale = 0.6, 0.6
                --移动
                velchTask(obj, 1, 0, a, 120)
                omigaChangeTask(obj, 3, 0.25, 60, 60)
                task.New(obj, function()
                    alphaAndSizeChange(obj, 255, 0.25, 90)
                    task.Wait(30)
                    --P.leaf2.attack(obj.x, obj.y, Angle(obj, player) + ran:Float(-2, 2))
                    velchTask(obj, 2, 4, -90, 45)
                    alphaAndSizeChange(obj, -255, -0.75, 45)
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
    self.img = "s3_road_title1"
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
                New(white, x, y - 15*u, 2*u, 200, 133, 65)
            end
            task.Wait(8)
        end
    end)
end

--endregion

function R.INIT(sence)
    local self = New(R) --创建自己
    sence = sence or 0
    self.sence = sence
    if sence == 0 or sence == 1 then
        system.PowerRank.pauseHyper() --如果是要与小鹿对话，则一开始就把hyper时间流逝锁定
    end
    New(stage3_background, self.sence)
    loadRes()
    LoadMusicRecord("s3")

    R.updateByRankChange() --初始化一次

    task.Wait(60)
    self.timer = 0 --计时清零
end

--道中片段1
local createMidBoss = lstg.DoFile(EISlib.stage.path.."stage3/mid_boss.lua")
local mid_bosses = {}
for diff = 1, 4 do
    mid_bosses[diff] = createMidBoss(diff)
end
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
        EISlib.stage.playMusic("s3", t / 60, true) -- 要解锁音乐室
        if self.timer == t then
            self.sence = 1
            --阴阳玉定义
            local createEnemy
            do
                local function change(obj)
                    obj.colli = false
                    robject.set_color(obj, "", 0, 0, 0, 0)
                    task.New(obj, function()
                        local d = 255/30
                        for _ = 1, 30 do
                            obj._a, obj._r, obj._g, obj._b = obj._a + d, obj._r + d, obj._g + d, obj._b + d
                            task.Wait(1)
                        end
                        obj.colli = true
                    end)
                end
                local function move(obj, a, a1)
                    EGGlib.ObjectEvent.boundWait(obj, 300)
                    task.New(obj, function()
                        --朝一个共同方向移动
                        task.New(obj, function()
                            local v, dv, dx, dy = 0, 0.025, cos(a1), sin(a1)
                            while true do
                                v = v + dv
                                obj.x, obj.y =  obj.x + v*dx, obj.y + v*dy
                                task.Wait(1)
                            end
                        end)
                        EGGlib.ObjectEvent.changeVelocity(obj, 0, 4, a, 360, 120, 360, false)
                    end)
                end

                function createEnemy(x, y, n)
                    local a0, a, da = ran:Float(-30, 30), nil, 360/n
                    local enemys, lasers = {}, {}
                    for i = 1, n do
                        a = a0 + da*i
                        table.insert(enemys, E.enemy7.create(x + 50*cos(a), y + 50*sin(a)))
                        change(enemys[#enemys])
                    end
                    --连带死亡
                    tasker(function()
                        task.Wait(30)
                        --连上激光
                        PlaySound("lazer00")
                        local a1 = Angle(x, y, player.x, player.y)

                        for i = 1, n do
                            a = da*i
                            move(enemys[i], a, a1) --跑了
                            table.insert(lasers, B.laser1.create(enemys[i], enemys[i%n + 1], n))
                        end
                        local flag = true
                        while flag do
                            for _, v in ipairs(enemys) do
                                if not IsValid(v) then
                                    flag = false
                                end
                            end
                            task.Wait(1)
                        end
                        for _, v in ipairs(enemys) do
                            if IsValid(v) then
                                Kill(v)
                            end
                        end
                        for _, v in ipairs(lasers) do
                            if IsValid(v) then
                                v.death = true
                            end
                        end
                    end)
                end
            end

            task.Wait(360)
            New(mid_bosses[difficulty])
            task.Wait(600)
            system.PowerRank.resumeHyper() --hyper时间重新开始流动
            local pos = {{0, 50}, {0, 100}, {0, 144}, {0, 192}}
            local wait = 60
            for n = 3, 6 do
                for u = -1, 1 do
                    createEnemy(pos[n - 2][1] + 30*u, pos[n - 2][2], n)
                    task.Wait(wait)
                    wait = max(20, wait - 10)
                end
            end
            --player.protect = max(300, player.protect)
            task.Wait(160)
            for _ = 1, 10 do
                EGGlib.ObjectEvent.clearEnemyAndBullet()
                task.Wait(1)
            end
            task.Wait(180)
            createTitle(0, 100)
            task.Wait(60)
        end
    end
end

--道中片段2
function R.SECOND(pratice)
    local self = lstg.tmpvar.current_road
    --1800f
    local t = 1800
    if IsValid(self) then
        if pratice then
            self.timer = t
            audio.playMusic("s3", 1.0, t/60)
        else
            --等到tf
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer == t then
            self.sence = 2
            local dys = {0, -20, 10, 20, -10}
            local leave_angle
            --生成小怪
            local function createEnemyFunc1(x, y)
                local a = leave_angle
                local obj = O.leaf1.create(x, y, 90)
                task.New(obj, function()
                    task.Wait(120)
                    local e = E.enemy1.create(obj.x, obj.y, 5, 9999)
                    T.leaveScreen1.main(e, a)
                    S.shooter1_2.main(e, 0) --给这个小怪装上发射器
                end)
            end
            --生成中怪
            local function createEnemyFunc2(x, y)
                local obj = E.enemy2.create(x, y, stg.ball_big, 0)  --x, y, dt
                setProtectTime(obj, 60)
                T.moveAndLeaveScreen1.main(obj, -90)
                local child
                for u = -1, 1, 2 do
                    child = E.enemy2_1.create(x, y, 50, nil, 10)
                    T.moveWith1.main(child, obj, 30, 90*(1-u))
                end
            end
            --第一轮，只有小怪
            for u = -1, 1, 2 do
                leave_angle = 90 + 95*u
                for i = 0, 4 do
                    createEnemyFunc1((10 + 35*i)*u, dys[i + 1] + -50 - 30*u)
                    task.Wait(10)
                end
                task.Wait(30)
            end
            --第二轮，大怪里夹着小怪
            tasker(function()
                task.Wait(160)
                createEnemyFunc2(75, 245)
                task.Wait(100)
                createEnemyFunc2(-75, 245)
            end)
            for j = 0, 2 do
                for u = -1, 1, 2 do
                    leave_angle = 90 + 95*u
                    for i = 0, 4 do
                        createEnemyFunc1((10 + 35*i)*u, dys[i + 1] + -50 - 30*u*tranU(j))
                        task.Wait(10)
                    end
                    task.Wait(30)
                end
            end
            task.Wait(30)
            for u = -1, 1, 2 do
                leave_angle = 90 + 95*u
                for i = 0, 4 do
                    createEnemyFunc1((10 + 35*i)*u, dys[i + 1] + -50 - 30*u)
                    task.Wait(10)
                end
                task.Wait(30)
            end
            task.Wait(60 + 20 + 60)
            --生成一大群排队枪毙小怪
            local function createEnemyFunc3(x, y, a, u)
                local r, obj
                for i = -1, 1 do
                    r = 60*i
                    obj = E.enemy5.create(x - r*sin(a), y + r*cos(a), 2, 0, sty.FAIRY_SMALL_RED)
                    T.moveAndLeaveScreen2.main(obj, a, -u)
                    task.Wait(5)
                end
            end
            for _ = 0, 1 do
                for u = 1, -1, -2 do
                    createEnemyFunc2(-75*u, 245)
                    for i = 0, 3 do
                        createEnemyFunc3(50*u, 245, -90 + 4*i*u, u)
                    end
                    for i = 0, 3 do
                        createEnemyFunc3(50*u, 245, -90 + 4*i*u, u)
                    end
                end
                task.Wait(60)
            end
            for u = -1, 1, 2 do
                createEnemyFunc2(-60*u, 245)
            end
        end
    end
end

function R.THIRD(pratice)
    local self = lstg.tmpvar.current_road
    --3550f
    local t = 3550
    if IsValid(self) then
        if pratice then
            self.timer = t
            audio.playMusic("s3", 1.0, t/60)
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
            createEnemyFunc4, createEnemyFunc5
            do
                --生成小怪
                function createEnemyFunc1(x, y, a)
                    local obj = O.leaf1.create(x, y, 90)
                    task.New(obj, function()
                        task.Wait(120)
                        local e = E.enemy1.create(obj.x, obj.y, 2, 9999)
                        T.leaveScreen1.main(e, a)
                        S.shooter1_2.main(e, 0) --给这个小怪装上发射器
                    end)
                end

                --生成大怪
                function createEnemyFunc2(x, y)
                    local dt0 = 60
                    local big = E.enemy3.create(x, y, 180, dt0, 240) --x, y, hp, dt
                    setProtectTime(big, 180)
                    T.moveAndLeaveScreen1.main(big, -90)
                    local child
                    for u = -1, 1, 2 do
                        child = E.enemy3_1.create(x, y, 180, u, dt0) --x, y, hp, u, dt
                        T.moveWith2.main(child, big, 60*u, 60)
                        _connect(big, child, 1, true)
                        setProtectTime(child, 180)
                        child = E.enemy3_2.create(x, y, 180, dt0, 0.25*(1 + u), u) --x, y, hp, dt0, w_rate
                        T.moveWith2.main(child, big, 90*u, 20)
                        _connect(big, child, 1, true)
                        setProtectTime(child, 180)
                    end
                end

                --排队枪毙小怪
                function createEnemyFunc3(x, y, a, u)
                    local r, obj
                    for i = -1, 1 do
                        r = 60*i
                        obj = E.enemy5.create(x - r*sin(a), y + r*cos(a), 2, 0, sty.FAIRY_SMALL_RED)
                        T.moveAndLeaveScreen2.main(obj, a, -u)
                        task.Wait(5)
                    end
                end

                --连续发狙的中型敌人
                function createEnemyFunc4(x, y, co)
                    local obj = O.leaf2.create(x, y, 90)
                    task.New(obj, function()
                        task.Wait(120)
                        local e = E.enemy4.create(obj.x, obj.y, 60, 30) --x, y, hp, dt
                        enemy.changeAura(e, co, "normal")
                        S.shooter4_1.main(e, 0)
                        T.leaveScreen2.main(e, -90)
                    end)
                end

                --排队枪毙小怪2
                function createEnemyFunc5(x, y, a, u)
                    local r, obj
                    for i = -1, 1, 2 do
                        r = 30*i
                        obj = E.enemy5.create(x - r*sin(a), y + r*cos(a), 4, 0, sty.FAIRY_SMALL_RED)
                        T.moveAndLeaveScreen2.main(obj, a, -u)
                        task.Wait(7)
                    end
                end
            end

            --道中本体
            do
                local dys, a = {0, -20, 10, 20, -10, 20, -20, 0}
                for u = -1, 1, 2 do
                    createEnemyFunc2(-30*u, 245) --先来一只大怪
                    task.Wait(45)
                    a = 90 + 95*u
                    for i = 0, 7 do
                        createEnemyFunc1((-10 + 25*i)*u, dys[i + 1] + -50 - 30*u, a)
                        task.Wait(10)
                    end
                    task.Wait(40)
                    for i = 0, 7 do
                        createEnemyFunc1((-10 + 25*i)*u, dys[i + 1] + -50 - 30*u, a)
                        task.Wait(10)
                    end
                    for i = 0, 5 do
                        createEnemyFunc3(-210*u, 50, 90 - 90*u - 6*i*u, -u)
                    end
                    task.Wait(30)
                end
                --中妖精段
                createEnemyFunc4(0, 50, COLOR_RED)
                task.Wait(60)
                for u = -1, 1, 2 do
                    for i = 0, 5 do
                        createEnemyFunc5(-210*u, 50, 90 + (-90 - 6*i)*u, -u)
                    end
                end
                local pos = {{100, 0}, {-60, 50}, {40, 100}}
                local dxs = {-50, -30, 0, 10, 40}
                local co_list = {COLOR_RED, COLOR_RED, COLOR_BLUE}
                local u = -1
                for i = 1, 3 do
                    createEnemyFunc4(pos[i][1], pos[i][2], co_list[i])
                    a = 90 + 95*u
                    for j = 0, 4 do
                        createEnemyFunc1(-pos[i][1] + dxs[j + 1]*u, pos[i][2] + dys[j + 1] + -120 - 30*u, -90)
                        task.Wait(10)
                    end
                    task.Wait(30)
                    u = -u
                end
                for u = -1, 1, 2 do
                    for i = 0, 5 do
                        createEnemyFunc5(90*u, 245, -90 - 6*i*u, u)
                    end
                end
                pos = {{-50, 0}, {90, 75}, {-10, 30},
                       {50, 0}, {-60, 100}, {100, 30},
                       {-120, 100}, {135, 60}, {30, 75}}
                u = -u
                for i = 1, 3 do
                    createEnemyFunc4(pos[i][1], pos[i][2], co_list[i])
                    for j = 0, 4 do
                        createEnemyFunc1(-pos[i][1] + dxs[j + 1]*u, pos[i][2] + dys[j + 1] + -120 - 30*u, -90)
                        task.Wait(10)
                    end
                    task.Wait(20)
                    u = -u
                end
                task.Wait(60)
                tasker(function()
                    for u = -1, 1, 2 do
                        for i = 0, 4 do
                            createEnemyFunc5(-210*u, 150, 90 + (-90 - 6*i)*u, u)
                        end
                    end
                end)
                SystemLog("modify_timer:"..self.timer)
            end
        end
    end
end

function R.FOURTH(pratice)
    local self = lstg.tmpvar.current_road
    --5266f
    local t = 5266
    if IsValid(self) then
        if pratice then
            self.timer = t
            audio.playMusic("s3", 1.0, t/60)
        else
            --等待到5240f
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer >= t then
            self.sence = 4
            --小怪定义
            local createEnemyFunc1, createEnemyFunc2, createEnemyFunc3,
            createEnemyFunc4, createEnemyFunc5, createEnemyFunc6
            do
                --排队枪毙小怪2
                function createEnemyFunc1(x, y, a, u)
                    local r, obj
                    for i = -1, 1 do
                        r = 60*i
                        obj = E.enemy5.create(x - r*sin(a), y + r*cos(a), 4, 0, sty.FAIRY_SMALL_RED)
                        T.moveAndLeaveScreen2.main(obj, a, -u)
                        task.Wait(4)
                    end
                    task.Wait(2)
                end
                --连续发狙的中型敌人
                function createEnemyFunc2(x, y, co)
                    local obj = O.leaf2.create(x, y, 90)
                    task.New(obj, function()
                        task.Wait(120)
                        local e = E.enemy4.create(obj.x, obj.y, 60, 50) --x, y, hp, dt
                        enemy.changeAura(e, co, "normal")
                        S.shooter4_1.main(e, 0)
                        T.leaveScreen2.main(e, -90)
                    end)
                end
                --生成小怪1
                function createEnemyFunc3(x, y, a)
                    local obj = O.leaf1.create(x, y, 90)
                    task.New(obj, function()
                        task.Wait(120)
                        local e = E.enemy1.create(obj.x, obj.y, 2, 9999)
                        T.leaveScreen1.main(e, a)
                        S.shooter1_2.main(e, 0) --给这个小怪装上发射器
                    end)
                end

                --生成中怪
                function createEnemyFunc4(x, y)
                    local obj = O.leaf2.create(x, y, 90)
                    task.New(obj, function()
                        task.Wait(120)
                        local e = E.enemy2.create(obj.x, obj.y, stg.ball_big, 0)  --x, y, dt
                        setProtectTime(e, 60)
                        S.shooter4_1.main(e, 0)
                        T.leaveScreen2.main(e, -90)
                        local child
                        for u = -1, 1, 2 do
                            child = E.enemy2_1.create(obj.x, obj.y, 50, nil, 10)
                            T.moveWith1.main(child, e, 30, 90*(1-u))
                        end
                    end)
                end

                --生成大怪
                function createEnemyFunc6(x, y)
                    local dt0 = 60
                    local big = E.enemy3.create(x, y, 180, dt0, 240) --x, y, hp, dt, dr
                    enemy.changeAura(big, COLOR_ORANGE, "big")
                    setProtectTime(big, 180)
                    T.moveAndLeaveScreen1.main(big, -90)
                    local child
                    for u = -1, 1, 2 do
                        child = E.enemy3_1.create(x, y, 180, u, dt0) --x, y, hp, u, dt
                        T.moveWith2.main(child, big, 60*u, 60)
                        _connect(big, child, 1, true)
                        setProtectTime(child, 180)
                        child = E.enemy3_2.create(x, y, 180, dt0, 0.25*(1 + u), u) --x, y, hp, dt0, w_rate
                        T.moveWith2.main(child, big, 90*u, 20)
                        _connect(big, child, 1, true)
                        setProtectTime(child, 180)
                    end
                end
            end

            --道中本体
            do
                task.Wait(120)
                --四只开花
                local pos = {{-100, 0}, {-50, 87}, {50, 87}, {100, 0}}
                for i = 1, 4 do
                    createEnemyFunc2(pos[i][1], pos[i][2], COLOR_BLUE)
                end
                task.Wait(150)
                --左右的小怪
                for u = 1, -1, -2 do
                    for i = 0, 5 do
                        createEnemyFunc1(-210*u, 150, 90 + (-100 + 4.5*i)*u, u)
                    end
                end
                task.Wait(30)
                for i = 0, 5 do
                    for u = 1, -1, -2 do
                        createEnemyFunc1(-210*u, 150, 90 + (-100 + 4.5*i)*u, u)
                    end
                end
                task.Wait(24)
                --
                local dxs = {-50, -30, 0, 10, 40}
                local dys = {0, -20, 10, 20, -10, 20, -20, 0}
                pos = {
                       {50, 0}, {-60, 100}, {100, 30},
                       {-120, 100}, {135, 60}, {30, 75},
                       {50, 0}, {-60, 100}, {100, 30},
                       {-120, 100}, {135, 60}, {30, 75},
                }
                local big_x = {-50, 50, 0}
                local u, count = -1
                local co_list = {
                    {COLOR_RED, COLOR_BLUE, COLOR_RED},
                    {COLOR_RED, COLOR_BLUE, COLOR_RED},
                    {COLOR_BLUE, COLOR_RED, COLOR_RED}
                }
                for i = 0, 2 do
                    for j = 1, 3 do
                        --SystemLog("第"..(i*4 + j).."只time："..self.timer)
                        count = 4*i + j
                        createEnemyFunc2(pos[count][1], pos[count][2] + 30, co_list[i+1][j])
                        task.Wait(20)
                        for j = 0, 4 do
                            createEnemyFunc3(-pos[count][1] + dxs[j + 1]*u, pos[count][2] + dys[j + 1] + -70 - 30*u, -90)
                            task.Wait(10)
                        end
                        task.Wait(30)
                    end
                    task.Wait(100)
                    --SystemLog("第一只大的time："..self.timer)
                    createEnemyFunc6(big_x[i+1], 245)
                    task.Wait(150)
                    u = -u
                end
            end
        end
    end
end

function R.FIFTH(pratice)
    local self = lstg.tmpvar.current_road
    --7740f
    local t = 7740
    if IsValid(self) then
        if pratice then
            self.timer = t
            audio.playMusic("s3", 1.0, t/60)
        else
            --等待到7740f
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer == t then
            self.sence = 5
            --小怪定义
            local createEnemyFunc1, createEnemyFunc2, createEnemyFunc3,
            createEnemyFunc4, createEnemyFunc5, createEnemyFunc6
            do
                --生成小怪
                function createEnemyFunc1(x, y, a)
                    local obj = O.leaf1.create(x, y, 90, COLOR_ROYAL_BLUE)
                    task.New(obj, function()
                        task.Wait(120)
                        local e = E.enemy1.create(obj.x, obj.y, 5, 9999, sty.FAIRY_SMALL_3_BLUE, COLOR_ROYAL_BLUE)
                        T.leaveScreen1.main(e, a)
                        S.shooter1_2.main(e, 0, COLOR_ROYAL_BLUE) --给这个小怪装上发射器
                    end)
                end
                --生成中怪
                function createEnemyFunc2(x, y)
                    local obj = E.enemy2.create(x, y, stg.star_big, 0)  --x, y, dt
                    T.moveAndLeaveScreen1.main(obj, -90)
                    setProtectTime(obj, 60)
                    local child
                    for u = -1, 1, 2 do
                        child = E.enemy2_1.create(x, y, 50, COLOR_ROYAL_BLUE, 10)
                        T.moveWith1.main(child, obj, 30, 90*(1-u))
                    end
                end
                --生成一大群排队枪毙小怪
                function createEnemyFunc3(x, y, a, u, u1)
                    local r, obj
                    for i = -1, 1, 2 do
                        r = 60*i
                        obj = E.enemy5.create(x - r*sin(a), y + r*cos(a), 2, 0, sty.FAIRY_SMALL_3_BLUE, COLOR_CYAN)
                        T.moveAndLeaveScreen2.main(obj, a, i*u*u1)
                        r = 20*i
                        obj = E.enemy5.create(x - r*sin(a), y + r*cos(a), 2, 0, sty.FAIRY_SMALL_3_BLUE, COLOR_CYAN)
                        T.moveAndLeaveScreen2.main(obj, a, i*u*u1)
                        task.Wait(5)
                    end
                end

                function createEnemyFunc4(x, y)
                    local obj = E.enemy4.create(x, y, 60, 50)  --x, y, dt
                    T.moveAndLeaveScreen1.main(obj, -90)
                end

                --生成黑蝴蝶大怪
                function createEnemyFunc6(x, y)
                    local dt0 = 90
                    local big = E.enemy6.create(x, y, 180, dt0, 240) --x, y, hp, dt, dr
                    T.moveAndLeaveScreen1.main(big, -90)
                    setProtectTime(big, 240)
                    local child
                    for u = -1, 1, 2 do
                        child = E.enemy6_1.create(x, y, 180, u, dt0) --x, y, hp, u, dt
                        T.moveWith2.main(child, big, 60*u, 60)
                        _connect(big, child, 1, true)
                        setProtectTime(child, 60)
                        child = E.enemy6_2.create(x, y, 180, dt0, 0.25*(1 + u)) --x, y, hp, dt0, w_rate
                        T.moveWith2.main(child, big, 90*u, 20)
                        _connect(big, child, 1, true)
                        setProtectTime(child, 60)
                    end
                end
            end

            --道中本体
            do
                local dys = {0, -20, 10, 20, -10}
                for u0 = -1, 1, 2 do
                    for u = -1*u0, 1*u0, 2*u0 do
                        for i = 0, 4 do
                            createEnemyFunc1(-(10 + 35*i)*u*u0, dys[i + 1] + -50 - 30*u, 90 - 95*u*u0)
                            task.Wait(5)
                        end
                    end
                    task.Wait(60)
                    createEnemyFunc2(-75*u0, 245)
                end
                --六只大怪
                for i = 0, 2 do
                    task.Wait(120)
                    for u = -1, 1, 2 do
                        createEnemyFunc2((125 - 50*i)*u, 245)
                    end
                end
                task.Wait(90)
                --又是一群排队枪毙妖精
                local function f1(u, u1)
                    for i = 0, 9 do
                        createEnemyFunc3(50*u, 245, -90 + 2*i*u, u, u1)
                    end
                end
                task.Wait(60)
                f1(-1, 1)
                --四只并排发狙大妖精
                tasker(function()
                    for i = 0, 1 do
                        for u = -1, 1, 2 do
                            createEnemyFunc2((30 + 60*i)*u, 245)
                        end
                        task.Wait(60)
                    end
                end)
                f1(1, -1)
                task.Wait(60)
                --超级大怪
                createEnemyFunc6(0, 275)
                task.Wait(720)
                EGGlib.ObjectEvent.clearEnemyAndBullet()
                system.PowerRank.pauseHyper() --从这里停止计时
                task.Wait(180)
            end
        end
    end
end


return R
