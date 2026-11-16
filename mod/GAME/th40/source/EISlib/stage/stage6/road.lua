-----------------------------------------
---东方栖霞园道中 Stage6
-----------------------------------------
---@class  EISlib.stage.stage6.road
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
    local res_name = "s6_road_"
    local path = "res/stage/stage6/"
    --关卡标题
    LoadImageFromFile(res_name.."title1", path.."title1.png")
end


local BS = EISlib.Bullet.Shooter
local no_info = 0
local no_info_t = 9999
local no_func = function() end
local velch = EGGlib.ObjectEvent.velocityChange
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local sect_layer1 = EGGlib.BulletGroup.Sector.layer1
local sect_layer2 = EGGlib.BulletGroup.Sector.layer2
local setProtectTime = EGGlib.ObjectEvent.setProtectTime
local setSizeAndColli = EGGlib.ObjectEvent.setSizeAndColli
local sty = EISlib.Enemy.Style
local switch = EGGlib.Math.spSwitch
local switch1 = EGGlib.Math.spSwitch1
local movePointWithPar = EGGlib.ObjectEvent.movePointWithPar
local arbgCh = EGGlib.ObjectEvent.argbChange
local rotateMoveWith2 = EGGlib.ObjectEvent.rotateMoveWith2
local LS = EISlib.Bullet.Laser.laser
local lead_laser = EISlib.Bullet.Laser.lead_laser
local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
local boundWait = EGGlib.ObjectEvent.boundWait
local clearEnemyAndBullet = EGGlib.ObjectEvent.clearEnemyAndBullet
local moveWithTask = EGGlib.ObjectEvent.moveWithTask
local clearBulletAndIndesAndLaserInRange = EGGlib.ObjectEvent.clearBulletAndIndesAndLaserInRange
local accDecMoveToPoint = EGGlib.ObjectEvent.accDecMoveToPoint
local newSimpleClass = EGGlib.Class.newSimpleClass
local EnemyGroup = EGGlib.Road.EnemyGroup
local accDecMoveToPoint = EGGlib.ObjectEvent.accDecMoveToPoint
local Basic_movement = EGGlib.Class.Frequently.Basic_movement
local accDecVelocityChange2 = EGGlib.ObjectEvent.accDecVelocityChange2
local tranRot = EGGlib.Math.TranRot
local setV = EGGlib.ObjectEvent.setV
local sect_normal1 = EGGlib.BulletGroup.Sector.normal1
local spSizeAndColliChange = EGGlib.ObjectEvent.spSizeAndColliChange
local setSize = EGGlib.ObjectEvent.setSize
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange

--region 类定义
local EnemyLine = newSimpleClass() --妖精线，用于控制一串妖精整体的运动
local GhostMovement = newSimpleClass() --像鬼火一样摆动的类
--endregion

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

--开始定义每段的敌人及组合
local s6_enemy_manager = EnemyGroup.new()
do
    s6_enemy_manager:initEnemyListByTable({
        --region part1 enemy
        {
            --追人妖精
            ["blue"] = function(x, y)
                local obj = E.mid1.create(x, y, 30, 10) --x, y, dt, hp
                setProtectTime(obj, 30)
                --固定向下移动
                task.New(obj, function()
                    --从屏幕上方下来
                    accDecMoveToPoint(obj, x, y - 100, 1, 29, 30)
                    --去追自机
                    local a = Angle(obj, player)
                    velch(obj, 0, 4, a + 45*sign(a + 90), 60)
                end)
                return obj
            end,
            --快速摆动+移动的一队列鬼火（控制器对象，只是直接生成对象会不执行任务，需要一个总控制器控制更新模块）
            ["ghost"] = function(x, y, a, u)
                local obj = GhostMovement.new(
                        E.ghost1.create(x, y,
                                1, 0 --hp, dt
                        ),
                        x, y)
                accDecVelocityChange2(obj,
                        4.5, a, 30, --vx, a, wt
                        30, 999, 999, --tx0, tx1, tx2
                        0, --dt
                        3, -u, 15, 0, 15, --vy, u, ty0, ty1, ty2,
                        true)
                return obj
            end,
        },
        --endregion
        --region part2 enemy
        {
        },
        --endregion
        --region part3 enemy
        {
            --在一条线上运动的妖精
            ["line"] = function(x, y, a, line)
                local obj = E.mid2.create(
                        0, -224, a, --x, y
                        2, 60  --hp, dt
                )
                setProtectTime(obj, 90)
                --变化逻辑
                obj.colli = false
                arbgCh(obj, 150, 0, 0, 0, 60, false, true)
                --移动逻辑
                task.New(obj, function()
                    accDecMoveToPoint(obj, x, y, 1, 58, 1)
                    setV(obj, 4, a)
                    while true do
                        obj.x, obj.y = obj.x + line.vx, obj.y + line.vy
                        task.Wait(1)
                    end
                end)
                return obj
            end,
            ["circle"] = function(a, u, dt, i)
                local obj = E.mid3.create(0, 0, 150 + dt, 50, u, i) -- x, y, dt, hp
                setProtectTime(obj, 150)
                --变化逻辑
                obj.colli = false
                arbgCh(obj, 150, 0, 0, 0, 90, false, true)
                --移动逻辑
                task.New(obj, function()
                    local t = 90
                    local da = -120/t*u --刚好能绕一圈
                    local r = 0
                    local dr = 290/t
                    for _ = 1, t do
                        r = r + dr
                        a = a + da
                        obj.x, obj.y = r*cos(a), r*sin(a)
                        task.Wait(1)
                    end
                    t = 120
                    da = -240/t*u
                    dr = -200/t
                    for _ = 1, t do
                        r = r + dr
                        a = a + da
                        obj.x, obj.y = r*cos(a), r*sin(a)
                        task.Wait(1)
                    end
                    t = 60
                    local ddr = (200/t - dr)/t
                    for _ = 1, t do
                        dr = dr + ddr
                        r = r + dr
                        a = a + da
                        obj.x, obj.y = r*cos(a), r*sin(a)
                        task.Wait(1)
                    end
                    t = 120
                    --dr = 200/t
                    for _ = 1, t do
                        r = r + dr
                        a = a + da
                        obj.x, obj.y = r*cos(a), r*sin(a)
                        task.Wait(1)
                    end
                    obj.vx, obj.vy = obj.dx, obj.dy
                end)
                return obj
            end
        },
        --endregion
        --region part4 enemy
        {
        },
        --endregion
        --region part5 enemy
        {

        },
        --endregion
    })
    s6_enemy_manager:initGroupListByTable({
        --region part1 group
        {
            --一组左右对称出的妖精
            ["blue"] = function()
                --一共26个敌人，每个敌人掉5个红
                local ce = s6_enemy_manager:getCreateEnemyFunc(1, "blue")
                local total_time = 380 --从roadtime 460出，到840截止， 920清空全屏
                local c = 2
                local n = 7
                local wait = math.floor(total_time/(c*n))
                local x0, dx = 120, -240/(n - 1)
                tasker(function()
                    for _ = 0, c - 1 do
                        for i = 0, n - 1 do
                            if i == (n - 1)/2 then
                                ce(0, 280)
                            else
                                for u = -1, 1, 2 do
                                    ce(x0*u, 280)
                                end
                            end

                            task.Wait(wait)
                            x0 = x0 + dx
                        end
                        x0 = 120
                    end
                end)
            end,
            --在一条线上运动的鬼火
            ["ghost_line"] = function()
                local total_time = 420 --从roadtime 460出，到880截止， 920清空全屏，理想来看最后一组鬼火能在此前达到中线并且被自机击破
                local n = 80 --一共40个敌人,每个敌人掉3个红
                local wait = math.floor(total_time/n)
                local ce = s6_enemy_manager:getCreateEnemyFunc(1, "ghost")
                local line = EnemyLine.new(0, 0)
                local isFinish = false --本组敌人生成完毕的flag
                --敌人生成逻辑
                tasker(function()
                    local u = 1
                    for _ = 0, n - 1 do
                        line:addEnemy(ce(-(192 + ran:Float(0, 30))*u, 144 + ran:Float(-25, 25), 90 - 90*u, u))
                        task.Wait(wait)
                        u = -u
                    end
                    isFinish = true
                end)
                --以下tasker作为线对象本身帧逻辑的更新器，在敌人产生完毕并且全部被消灭时结束更新
                tasker(function()
                    local t = 0
                    while not (isFinish and line:isNoEnemy()) do
                        line:update()
                        local ls = line:getEnemyList()
                        for k, ghost_movement in pairs(ls) do
                            if ghost_movement:isValid() then
                                ghost_movement:update()
                            else
                                table.remove(ls, k)
                            end
                        end
                        t = t + 1
                        task.Wait(1)
                    end
                    --SystemLog("当前组敌人已被消灭，用时："..t)
                end)
            end,
        },
        --endregion
        --region part2 group
        {

        },
        --endregion
        --region part3 group
        {
            --在一条线上运动的妖精
            ["line"] = function()
                local ymin = -224  --最低生成高度
                local ymax = 800 --最高生成高度
                local n = 17 --生成轮数
                local dy = 75 --每阵列间隔y
                local total_time = 480 --从1800f开始
                local wait = math.floor(total_time/n)
                local ce = s6_enemy_manager:getCreateEnemyFunc(3, "line")
                local line = EnemyLine.new(0, 150)
                local isFinish = false --本组敌人生成完毕的flag
                --设置整体向下的速度
                setV(line, 4, -90)
                --敌人生成逻辑
                tasker(function()
                    local y, i, u
                    for _ = 0, n - 1 do
                        y = line.y
                        i = 0
                        while y <= ymax do
                            if y >= ymin then
                                 u = tranU(i)
                                --line:addEnemy(ce(-224*u, y, 90 - 45*u, line))
                                ce(-224*u, y, 90 - 45*u, line)
                            end
                            y = y + dy
                            i = i + 1
                        end
                        task.Wait(wait)
                    end
                    task.Wait(60)
                    isFinish = true
                end)
                --以下tasker作为线对象本身帧逻辑的更新器，在敌人产生完毕并且全部被消灭时结束更新
                tasker(function()
                    local t = 0
                    for _ = 1, 640 do
                        line:update()
                        --[[for _, obj in ObjList(GROUP_ENEMY_BULLET) do
                            obj.x, obj.y = obj.x + line.vx, obj.y + line.vy
                        end]]
                        t = t + 1
                        task.Wait(1)
                    end
                    for _ = 1, 360 do
                        line:update()
                        t = t + 1
                        task.Wait(1)
                    end
                    --SystemLog("当前组敌人已被消灭，用时："..t)
                end)
            end,
            --圆
            ["circle"] = function()
                local ce = s6_enemy_manager:getCreateEnemyFunc(3, "circle")
                local total_time = 360 --只有这么一些时间
                local n = 16
                local n2 = 30
                local da = 360/n
                local wait = 120/n2
                tasker(function()
                    tasker(function()
                        local a0 = ran:Float(0, 360)
                        local enemy_list = {}
                        for i = 0, n - 1 do
                            table.insert(enemy_list, ce(a0 - da*i, -1, 0*wait*i, i))
                        end
                        local flag = true
                        while flag do
                            for _, e in pairs(enemy_list) do
                                if not IsValid(e) then
                                    flag = false
                                    break
                                end
                            end
                            task.Wait(1)
                        end
                        --只要一只死了其他都会死
                        for _, e in pairs(enemy_list) do
                            if IsValid(e) then
                                Kill(e)
                            end
                        end
                    end)

                    task.Wait(300)
                    tasker(function()
                        local a0 = ran:Float(0, 360)
                        local enemy_list = {}
                        for i = 0, n - 1 do
                            table.insert(enemy_list, ce(a0 - da*i, 1, 0*wait*i, i))
                        end
                        local flag = true
                        while flag do
                            for _, e in pairs(enemy_list) do
                                if not IsValid(e) then
                                    flag = false
                                    break
                                end
                            end
                            task.Wait(1)
                        end
                        --只要一只死了其他都会死
                        for _, e in pairs(enemy_list) do
                            if IsValid(e) then
                                Kill(e)
                            end
                        end
                    end)
                end)
            end,
        },
        --endregion
        --region part4 group
        {

        },
        --endregion
        --region part5 group
        {

        },
        --endregion
    })
end

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
                6, 8, 8, 10, 10
            })
            local vy = switch1(diff, {
                1.5, 1.75, 2, 2.25, 2.25
            })
            local atk = switch1(diff, {
                6, 7, 8, 9, 9
            }) + switch(rank, {
                0, 0, 0, 0, 3
            })
            local wait = 360/atk
            local function create(mst1, mst2, n, co)
                n = 3
                co = co or COLOR_BLUE
                local obj = New(lead_laser,
                        1, co, --type, co
                        mst1.x, mst1.y, 10, Angle(mst1, mst2), --x, y, v, a
                        Dist(mst1, mst2), 12, 15, 1, --len, w0, w1, 1
                        true, false, 600 --islock, isshoot, last_time
                )
                obj.bound = false
                _connect(mst1, obj, 0, true)
                _connect(mst2, obj, 0, true)
                --存在性检测
                local a, d
                task.New(obj, function()
                    local head_len, trail_len = LS.getMaxLength(obj, 1), LS.getMaxLength(obj, 3)
                    while IsValid(mst1) and IsValid(mst2) do
                        a, d = Angle(mst1, mst2), Dist(mst1, mst2)
                        obj.x, obj.y = mst1.x, mst1.y
                        LS.setRot(obj, a)
                        LS.setMaxLength(obj, 2, d - head_len - trail_len)
                        task.Wait(1)
                    end
                    Del(obj)
                end)
                --发弹幕
                task.New(obj, function()
                    task.Wait(60)
                    local dx, dy
                    local dr, r
                    local d_cen_len --距离中心多长
                    local h
                    local bullet
                    for _ = 0, atk - 1 do
                        dx, dy = cos(a), sin(a)
                        dr, r = d/(count - 1)
                        h = 0.5*d*lstg.tan(90*(n - 2)/n) --赣你妈为什么math.tan是错的
                        PlaySound("kira00")
                        for i = 0, count - 1 do
                            r = dr*i
                            d_cen_len = 0.5*d - r
                            bullet = stg.newBullet(obj.x + r*dx, obj.y + r*dy, stg.star_small, co)
                            boundWait(bullet, 120)
                            bullet.omiga = 3
                            EGGlib.ObjectEvent.addV3(bullet,
                                    vy*d_cen_len/h, vy, a --vx, vy, drot
                            )
                            bullet.rot = Angle(0, 0, bullet.vx, bullet.vy)
                        end
                        task.Wait(wait)
                    end
                end)
                return obj
            end
            return create
        end
)

--region Pointer Defined
--六芒星中心大妖精发弹
P.pointer4 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                20, 24, 28, 32, 32
            })
            --case：层数
            local layer = switch1(diff, {
                1, 1, 1, 1, 1
            })
            --case：初始弹速
            local v = switch1(diff, {
                2.5, 3, 3.5, 4, 4
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = switch1(diff, {
                0, 0, 1, 1, 1
            })
            local style, color = stg.star_small, COLOR_DEEP_BLUE
            local function attack(x, y, a, co)
                PlaySound("tan00")
                co = co or color
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStraight(x, y, v, a, style, co).omiga = -3
                end
                stg.newFadeEffect(x, y, style, co, false,
                        function()
                            circle_layer1(x, y, v, a, way,
                                    layer, dv, 0, 0,
                                    bullet_func
                            )
                        end)
            end
            return attack
        end
)

--六芒星内圈使魔发弹幕
P.pointer4_2 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = 4
            local da = 72/(way - 1) --每way间的间隔
            --case：层数
            local layer = switch(rank, {
                1, 1, 1, 1, 2
            })
            --case：初始弹速
            local v = switch1(diff, {
                1.25, 1.5, 1.75, 2, 2
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = switch(diff, {
                0.625, 0.75, 0.875, 1, 1
            })
            local way2 = switch1(diff, {
                1, 2, 3, 4, 4
            })
            local da2 = 2
            way2 = (way2 - 1)/2
            local style, color = stg.star_small, COLOR_DEEP_GREEN
            local function attack(x, y, a, co)
                PlaySound("tan00")
                co = co or color
                local function bullet_func(x, y, v, a)
                    stg.newSimpleStraight(x, y, v, a, style, co).omiga = 3
                end
                local function bullet_func1(x, y, v, a)
                    for i = -way2, way2 do
                        bullet_func(x, y, v, a + da2*i)
                    end
                end
                stg.newFadeEffect(x, y, style, co, false,
                        function()
                            sect_layer1(x, y, v, a, way, da, --base
                                    layer, dv, 0, --layer, dv_l, da_l
                                    bullet_func1
                            )
                        end)
            end
            return attack
        end
)
--endregion

--region Shooter Defined
S.shooter4 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                20, 15, 10, 0, 0
            })
            --case：持续攻击时间
            local total_time = 360
            local wait = switch1(diff, {
                45, 30, 25, 20, 15
            }) + switch(rank, {
                0, 0, 0, 0, -5
            })
            local function shooter(e, dt, co)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            if co == COLOR_RED then
                                while true do
                                    P.pointer4.attack(e.x, e.y, ran:Float(0, 360), co)
                                    task.Wait(wait)
                                end
                            else
                                while true do
                                    P.pointer4.attack(e.x, e.y, -90, co)
                                    task.Wait(wait)
                                end
                            end
                        end
                )
            end
            return shooter
        end
)

S.shooter4_2 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = switch1(diff, {
                20, 15, 10, 0, 0
            })
            --case：持续攻击时间
            local total_time = 360

            local wait = switch1(diff, {
                90, 80, 70, 60, 60
            })
            local function shooter(e, dt, co)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            while IsValid(e.mst) do
                                P.pointer4_2.attack(e.x, e.y, Angle(e, e.mst) + 180, co)
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
T.move4_1 = BS.createTasker(
        function(diff, rank)
            local function main(obj, u)
                task.New(obj, function()
                    accDecMoveToPoint(obj, -70*u, 120, 1, 0, 119)
                    --velch(obj, 3, 0.25, -90 + 80*u, 120)
                    --task.Wait(240)
                    velch(obj, 0, 1, -90, 600)
                end)
            end
            return main
        end
)

T.move4_2 = BS.createTasker(
        function(diff, rank)
            local function main(obj)
                task.New(obj, function()
                    velch(obj, 1.5, 0.125, -90, 120)
                    task.Wait(240)
                    velch(obj, 0, 1, -90, 180)
                end)
            end
            return main
        end
)
--endregion

--region Death Defined
--六芒星大蝴蝶消弹
D.death4 = EISlib.Bullet.Shooter.createTasker(
        function(diff, rank)
            local function main(e)
                enemy.createDeath(
                        1, --total_time,
                        function()
                            PlaySound("enep05")
                            clearBulletAndIndesAndLaserInRange(e.x, e.y, _infinite, 0, false)
                        end)
            end
            return main
        end)
--endregion

--region Enemy Defined
--六芒星大怪
E.enemy4 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, dt, hp, a, u, co0, co1, co2)
                local obj = New(enemy, x, y, sty.FAIRY_LARGE_6_RED, --style
                        hp or 300, --hp
                        true,  --show_hpbar
                        system.DROP_MID_ENEMY, --drop
                        false, --no_count
                        D.death4.main, --death
                        true --type
                )
                enemy.changeAura(obj, co1, "big") --激光颜色与法阵颜色要一致
                obj.a, obj.b = 72, 72
                boundWait(obj, 600)
                S.shooter4.main(obj, dt, co0) --给这个小怪装上发射器
                local enemy_list = {}
                for i = 1, 6 do
                    enemy_list[i] = E.enemy4_1.create(obj, a + 60*i, u, co1)
                    E.enemy4_2.create(obj, a + 60*i + 30, u, dt, co2)
                end
                for i = 0, 5 do
                    B.laser1.create(enemy_list[i%6 + 1], enemy_list[(i + 2)%6+1], 6, co1)
                end
                return obj
            end
            return create
        end
)

local tai_chi_style_list = {
    sty.TAICHI_RED, sty.TAICHI_RED,
    sty.TAICHI_PURPLE, sty.TAICHI_PURPLE,
    sty.TAICHI_BLUE, sty.TAICHI_BLUE,
    sty.TAICHI_BLUE, sty.TAICHI_BLUE,
    sty.TAICHI_GREEN, sty.TAICHI_GREEN,
    sty.TAICHI_YELLOW, sty.TAICHI_YELLOW,
    sty.TAICHI_ORANGE, sty.TAICHI_ORANGE,
    sty.TAICHI_GRAY, sty.TAICHI_GRAY
}
--六芒星外圈
E.enemy4_1 = BS.createEnemy(
        function(diff, rank)
            local function create(mst, a, u, co)
                local obj = New(enemy, mst.x, mst.y, tai_chi_style_list[co], --style
                        9999, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                enemy.setTauntRank(obj, enemy.SERVANT_TAUNT)
                enemy.setBoundTime(obj, _infinite)
                obj.colli = false
                obj.mst = mst
                obj.omiga = -6*u
                obj.bound = false
                _connect(mst, obj, 1, true)
                --跟随
                task.New(obj, function()
                    rotateMoveWith2(obj, mst, 300*2/3, a, 0.5*u, 60, _infinite, false) --obj, mst, rmax, a, omiga, t0, t1, IsRotChange
                end)
                return obj
            end
            return create
        end
)

--六芒星内圈
E.enemy4_2 = BS.createEnemy(
        function(diff, rank)
            local function create(mst, a, u, dt, co)
                local obj = New(enemy, mst.x, mst.y, tai_chi_style_list[co], --style
                        9999, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                enemy.setTauntRank(obj, enemy.SERVANT_TAUNT)
                enemy.setBoundTime(obj, _infinite)
                obj.colli = false
                obj.mst = mst
                obj.omiga = -6*u
                obj.bound = false
                _connect(mst, obj, 1, true)
                S.shooter4_2.main(obj, dt, co)
                --跟随
                task.New(obj, function()
                    rotateMoveWith2(obj, mst, 173*2/3, a, 0.5*u, 60, _infinite, false) --obj, mst, rmax, a, omiga, t0, t1, IsRotChange
                end)
                return obj
            end
            return create
        end
)

--最后一只六芒星大怪
E.enemy4_3 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, dt, hp, u, co0, co1, co2)
                local obj = New(enemy, x, y, sty.FAIRY_LARGE_6_RED, --style
                        hp or 300, --hp
                        true,  --show_hpbar
                        system.DROP_MID_ENEMY, --drop
                        false, --no_count
                        D.death4.main, --death
                        true --type
                )
                enemy.changeAura(obj, COLOR_ORANGE, "big") --激光颜色与法阵颜色要一致
                obj.a, obj.b = 72, 72
                boundWait(obj, 600)
                S.shooter4.main(obj, dt, co0) --给这个小怪装上发射器
                local a0 = ran:Float(0, 360)
                local enemy_list = {}
                for i = 1, 6 do
                    enemy_list[i] = E.enemy4_1.create(obj, a0 + 60*i, -u, co1)
                    E.enemy4_2.create(obj, a0 + 60*i + 30, -u, dt, co2)
                end
                for i = 0, 5 do
                    B.laser1.create(enemy_list[i%6 + 1], enemy_list[(i + 2)%6+1], 6, co1)
                end
                return obj
            end
            return create
        end
)
--endregion

--region 从两侧出来的敌人
--妖精线类定义
do
    --妖精线的坐标为生成妖精的坐标， 由该妖精线生成的其他妖精也必须遵循矩阵的运动来相对运动
    local this = EnemyLine
    function this.constructor(self, x, y)
        Basic_movement.implement(self, x, y)
        self.enemyList = {} --存放由自己生成的敌人表
    end
    function this.update(self)
        Basic_movement.update(self)
        for k, e in pairs(self.enemyList) do
            if (e.isValid and e:isValid()) then
                e.x, e.y = e.x + e.vx, e.y + e.vy
            else
                table.remove(self.enemyList, k)
            end
        end
    end
    --把某只妖精加入本条线
    function this.addEnemy(self, e)
        table.insert(self.enemyList, e)
        --如果传入的参数是lstg.object
        if not e.isValid then
            e.isValid = function(self)
                return IsValid(self)
            end
        end
    end
    --检测还有没有剩下有效的敌机单位在这个线上
    function this.isNoEnemy(self)
        if #self.enemyList > 0 then
            return false
        else
            return true
        end
    end
    function this.getEnemyList(self)
        return self.enemyList
    end
end
--像鬼火一样摆动的类
do
    local this = GhostMovement
    this.amplitude = 10 --振幅
    function this.constructor(self, e, x, y)
        Basic_movement.implement(self, x, y)
        self.enemy = e
        self.status = "normal"
        self.amplitude = this.amplitude
        self.phase = 0
        self.dphase = 10
    end
    function this.update(self)
        Basic_movement.update(self)
        self.phase = self.phase + self.dphase
        local e = self.enemy
        if IsValid(e) then
            task.Do(self)
            local a = Angle(0, 0, e.vx, e.vy)
            local dx, dy = tranRot(0, self.amplitude*sin(self.phase), a)
            e.x, e.y = self.x + dx, self.y + dy
        else
            self.status = "del" --标记失效，等待控制者移除
        end
    end
    function this.getEnemy(self)
        return self.enemy
    end
    function this.setPhase(self, phase)
        self.phase = phase
    end
    function this.setDphase(self, dphase)
        self.dphase = dphase
    end
    function this.isValid(self)
        if self.status == "del" then
            return false
        end
        return true
    end
end

E.ghost1 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, hp, dt)
                local obj = New(enemy, x, y, sty.FIRE_BLUE, --style
                        hp, --hp
                        false,  --show_hpbar
                        {1, 1} --drop
                )
                S.ghost1.main(obj, dt)
                obj.show_aura = true
                return obj
            end
            return create
        end
)

--乱弹糊脸
S.ghost1 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = 1
            --case：持续攻击时间
            local total_time = 360
            local wait = switch(rank, {
                24, 20, 16, 12, 12
            })
            local function shooter(e, dt)
                dt = dt + math.floor(ran:Float(0, 0.25)*wait)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            while true do
                                P.ghost1.attack(e.x, e.y, ran:Float(0, 360))
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

P.ghost1 = BS.createPointer(
        function(diff, rank)
            local layer = switch1(diff, {
                1, 1, 1, 1, 1
            })
            local way = switch1(diff, {
                6, 10, 12, 16, 18
            }) + switch(rank, {
                0, 0, 0, 0, 2
            })
            local da = 360/way
            local a_range = 0.25*da
            --初始弹速
            local v0 = switch1(diff, {
                9, 9, 9, 9, 9
            })*defaultSwitchVelocityByRank(rank)
            --稳定之后的弹速
            local v = switch1(diff, {
                1.5, 1.75, 2, 2.25, 2.5
            })*defaultSwitchVelocityByRank(rank)
            --速度随机范围
            local v_range = switch1(diff, {
                0.25, 0.33, 0.4, 0.475, 0.475
            })*defaultSwitchVelocityByRank(rank)/2
            --每层速度差
            local dv = switch1(diff, {
                0, 0, 1, 1, 1
            })*defaultSwitchVelocityByRank(rank)
            local style, color = stg.arrow_big, COLOR_CYAN
            local function attack(x, y, a)
                local function bullet_func(x, y, v, da_i)
                    stg.newSimpleStrChV(x, y, v0, v + ran:Float(-v_range, v_range), a + ran:Float(-a_range, a_range) + da*da_i, 20, 0, style, COLOR_BLUE)
                end
                PlaySound("kira00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            sect_layer1(x, y, v, 0, way, 1, --base
                                    layer, dv, 0, --layer, dv_l, da_l
                                    bullet_func
                            )
                        end)
            end
            return attack
        end
)

--endregion

--region 从中间出现的敌人
E.mid1 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, dt, hp)
                local obj = New(enemy, x, y, sty.FAIRY_SMALL_7_PINK, --style
                        hp or 10, --hp
                        true,  --show_hpbar
                        {6, 3} --drop
                )
                S.mid1.main(obj, dt) --给这个小怪装上发射器
                return obj
            end
            return create
        end
)

S.mid1 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = 0
            --case：持续攻击时间
            local total_time = 360
            local wait = switch1(diff, {
                35, 30, 25, 20, 20
            })
            local function shooter(e, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            while e.y > 0 do
                                P.mid1.attack(e.x, e.y, Angle(e, player) + ran:Float(-2, 2))
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

--扩散弹
P.mid1 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                4, 4, 6, 8, 10
            })
            local sp = 180 --总张角
            --case：层数
            local layer = switch1(diff, {
                1, 1, 2, 2, 1
            }) + switch(rank, {
                0, 0, 0, 0, 1
            })
            --稳定之后的弹速
            local v = switch1(diff, {
                1.25, 1.5, 1.75, 2, 2
            })*defaultSwitchVelocityByRank(rank)
            --每层弹速差
            local dv = 1*defaultSwitchVelocityByRank(rank)
            local style, color = stg.ball_mid, COLOR_BLUE
            local function bullet_func(x, y, v, a)
                stg.newSimpleStrChV(x, y, 0, v, a, 60, 0, style, color)
            end
            local function attack(x, y, a)
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            PlaySound("tan00")
                            sect_layer2(x, y, v, a, way, sp, --base
                                    layer, dv, 0, --layer, dv_l, da_l
                                    bullet_func
                            )
                        end)
            end
            return attack
        end
)

--endregion

--region 菱形阵列
E.mid2 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, a, hp, dt)
                local obj = New(enemy, x, y, sty.FAIRY_SMALL_7_GREEN, --style
                        hp, --hp
                        false,  --show_hpbar
                        system.DROP_SMALL_ENEMY --drop
                )
                enemy.cancelClashColli(obj) --取消撞击判定
                --这种妖精弹幕攻击方向与移动方向相同
                S.mid2.main(obj, a, dt) --给这个小怪装上发射器
                return obj
            end
            return create
        end
)


--斜向下阵列妖精连续发射4way固定角度弹幕
S.mid2 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = 1
            --case：持续攻击时间
            local total_time = 120
            local c = switch1(diff, {
                1, 2, 3, 3, 2
            })
            local wait = switch1(diff, {
                4, 4, 4, 4, 6
            })
            local wait2 = switch1(diff, {
                52 + 61, 34 + 75, 30 + 42, 16, 24
            })
            local count = switch1(diff, {
                2, 2, 2, 2, 2
            })
            local function shooter(e, a, dt)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function(obj)
                            obj.bound = false
                            local b
                            for _ = 0, count - 1 do
                                for i = 0, c - 1 do
                                    if i == 1 then
                                        b = 1
                                    else
                                        b = 0
                                    end
                                    P.mid2.attack(e.x, e.y, a, b)
                                    task.Wait(wait)
                                end
                                task.Wait(wait2)
                            end
                        end
                )
            end
            return shooter
        end
)

--一颗星星
P.mid2 = BS.createPointer(
        function(diff, rank)
            local v = switch1(diff, {
                1.5, 2, 2.5, 3, 2
            })*0.9
            local way = 1
            local style, color = stg.star_small, COLOR_DEEP_GREEN

            local function attack(x, y, a, b)
                local function bullet_func(x, y, v, a)
                    B.mid2.create(x, y, v, a, b)
                    --stg.newSimpleStrChV(x, y, 0, v, a, 60, 0, style, color).omiga = 3
                end
                PlaySound("kira00")
                sect_normal1(x, y, v, a, way, 0, bullet_func)
            end
            return attack
        end
)

B.mid2 = BS.createBulletClass(
        function(diff, rank)
            local style, color = stg.star_small, COLOR_DEEP_GREEN
            local function create(x, y, v, a, b)
                if rank < 4 then
                    b = 0
                elseif diff < 3 then
                    b = 1
                end
                local obj = stg.newSimpleBullet(x, y, stg.star_small + (stg.star_big - stg.star_small)*b, color)
                robject.set_color(obj, "mul+add", 0, 255, 255, 255)
                obj.omiga = 3
                obj.colli = false
                setV(obj, 4, -90)
                velchTask(obj, 0, v, a, 60)
                setSize(obj, 2, 2)
                obj.bound = false
                task.New(obj, function()
                    alphaAndSizeChange(obj, 255, -1, 11)
                    obj._blend = ""
                    obj.colli = true
                    task.Wait(420)
                    obj.bound = true
                end)
                return obj
            end
            return create
        end
)
--endregion

--region 绕圈敌人
E.mid3 = BS.createEnemy(
        function(diff, rank)
            local function create(x, y, dt, hp, u, i)
                local obj = New(enemy, x, y, sty.FAIRY_MIDDLE_3_RED, --style
                        hp or 10, --hp
                        false,  --show_hpbar
                        system.DROP_MID_ENEMY, --drop
                        false, --no_count
                        nil, --death_func
                        true --type
                )
                enemy.changeAura(obj, COLOR_RED + 0.5*(1+tranU(i))*(COLOR_BLUE - COLOR_RED), "normal")
                enemy.cancelClashColli(obj) --取消撞击判定
                S.mid3.main(obj, dt, u, i) --给这个小怪装上发射器
                return obj
            end
            return create
        end
)

S.mid3 = BS.createShooter(
        function (diff, rank)
            --case：初始攻击等待
            local start_time_left = 0
            --case：持续攻击时间
            local total_time = 4
            local wait = switch1(diff, {
                20, 15, 10, 5, 10
            })
            local n = switch1(diff, {
                2, 2, 2, 1, 1
            })
            local function shooter(e, dt, u, i)
                enemy.createShooter(e,
                        start_time_left + dt, total_time + dt, --start_time_left total_time
                        function()
                            if i%n == 0 then
                                P.mid3.attack(e.x, e.y, Angle(e, player))
                            end
                            while true do
                                PlaySound("kira00")
                                P.mid3_1.attack(e.x, e.y, Angle(e.x, e.y, 0, 0), u)
                                task.Wait(wait)
                            end
                        end
                )
            end
            return shooter
        end
)

--全方位弹幕
P.mid3 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                5, 6, 7, 8, 8
            }) + switch(rank, {
                0, 0, 0, 0, 2
            })
            --case：层数
            local layer = switch1(diff, {
                1, 1, 2, 2, 2
            })
            --case：初始弹速
            local v = switch1(diff, {
                1, 1.5, 1, 1.25, 1
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = switch1(diff, {
                0, 0, 0.75, 1, 1
            })*defaultSwitchVelocityByRank(rank)
            local style, color = stg.ball_mid_c, COLOR_GREEN
            local function bullet_func(x, y, v, a)
                stg.setBoundTime(stg.newSimpleStrChV(x, y, 0, v, a, 120, 0, style, color, false, 1), 180)
            end
            local function attack(x, y, a)
                PlaySound("tan00")
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            circle_layer1(x, y, v, a, way,
                                    layer, dv, 0, 0,
                                    bullet_func
                            )
                        end, true)
            end
            return attack
        end
)

P.mid3_1 = BS.createPointer(
        function(diff, rank)
            --case：way数
            local way = switch1(diff, {
                3, 4, 5, 6, 6
            }) + switch(rank, {
                0, 0, 0, 0, 2
            })
            local da = switch1(diff, {
                210, 240, 270, 300, 330
            })/(way - 1) --每way间的间隔
            --case：层数
            local layer = switch1(diff, {
                3, 6, 7, 8, 8
            }) + switch(rank, {
                0, 0, 0, 0, 2
            })
            --case：初始弹速
            local v0 = switch1(diff, {
                2, 2, 2, 2, 2
            })*defaultSwitchVelocityByRank(rank)
            --case：每层弹速差
            local dv = switch1(diff, {
                1, 1, 1, 1, 1
            })*defaultSwitchVelocityByRank(rank)
            local style, color = stg.star_small, COLOR_GREEN
            local function bullet_func(x, y, v, a)
                local obj = stg.newSimpleStraight(x, y, v, a, style, color)
                stg.setBoundTime(obj, 60)
                obj.omiga = 3
            end
            local function attack(x, y, a)
                stg.newFadeEffect(x, y, style, color, false,
                        function()
                            --偶数弹
                            sect_layer1(x, y, v0, a + 180, way, da, --base
                                    layer, dv, 0, --layer, dv_l, da_l
                                    bullet_func
                            )
                            --随机弹

                        end, true)
            end
            return attack
        end
)
--endregion

--region 标题定义

local title, white
title = Class(object)
function title:init(x, y)
    self.x, self.y = x, y
    self.img = "s6_road_title1"
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
                New(white, x, y - 15*u, 2*u, 51, 51, 158)
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
    New(stage6_background, self.sence)
    loadRes()
    LoadMusicRecord("s6")
    R.updateByRankChange() --初始化一次
    task.Wait(60)
    self.timer = 0 --计时清零
end

local createCatClass = lstg.DoFile(EISlib.stage.path.."stage6/mid_cat.lua")
--道中片段1
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
        EISlib.stage.playMusic("s6", t / 60, true) -- 要解锁音乐室
        if self.timer == t then
            self.sence = 1
            --道中本体
            local g1 = s6_enemy_manager:getCreateGroupFunc(1, "ghost_line")
            local g2 = s6_enemy_manager:getCreateGroupFunc(1, "blue")

            task.Wait(240)
            createTitle(0, 100)
            task.Wait(210)
            g1()
            g2()
        end
    end
end

--道中片段2
function R.SECOND(pratice)
    local self = lstg.tmpvar.current_road
    --920f
    local t = 920
    --SystemLog("current_timer:"..self.timer)
    if IsValid(self) then
        if pratice then
            self.timer = t
            audio.playMusic("s6", 1.0, t/60)
        else
            --等到tf
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer == t then
            self.sence = 2

            EGGlib.ObjectEvent.clearEnemyAndBullet()
            task.Wait(1)
            EGGlib.ObjectEvent.clearEnemyAndBullet()
            createCatClass(difficulty, 0, 384) --猫快速入场
        end
    end
end

function R.THIRD(pratice)
    local self = lstg.tmpvar.current_road
    --1700f
    local t = 1700
    if IsValid(self) then
        if pratice then
            self.timer = t
            audio.playMusic("s6", 1.0, t/60)
        else
            --等到1700f
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer == t then
            self.sence = 3
            --道中本体
            local g1 = s6_enemy_manager:getCreateGroupFunc(3, "line")
            local g2 = s6_enemy_manager:getCreateGroupFunc(3, "circle")

            task.Wait(100)
            g1()
            task.Wait(620)
            g2()
        end
    end
end

function R.FOURTH(pratice)
    local self = lstg.tmpvar.current_road
    --3160f
    local t = 3160
    if IsValid(self) then
        if pratice then
            self.timer = t
            audio.playMusic("s6", 1.0, t/60)
        else
            --等待到3160f
            while self.timer < t do
                task.Wait(1)
            end
        end
        if self.timer >= t then
            self.sence = 4
            --小怪定义
            local ce1, ce2
            do
                function ce1(x, y, a, u, co0, co1, co2)
                    local obj = E.enemy4.create(x, y, 60, 375, a, u, co0, co1, co2) --x, y, dt, hp, u, co0, co1, co2
                    setProtectTime(obj, 45)
                    T.move4_1.main(obj, u)
                    return obj
                end

                --最后一只
                function ce2(x, y, u, co0, co1, co2)
                    local obj = E.enemy4_3.create(x, y, 60, 600, u, co0, co1, co2) --x, y, dt, hp, u, co0, co1, co2
                    setProtectTime(obj, 45)
                    T.move4_2.main(obj)
                    return obj
                end
            end

            --道中本体
            do
                clearEnemyAndBullet()
                --第一只
                ce1(-224, 150, -90 + ran:Float(0, 360), 1, COLOR_RED, COLOR_ORANGE, COLOR_YELLOW)
                while self.timer < 3330 do
                    task.Wait(1)
                end
                ce1(224, 150, -90 + ran:Float(0, 360), -1, COLOR_RED, COLOR_ORANGE, COLOR_YELLOW)
                while self.timer < 3500 do
                    task.Wait(1)
                end
                local a = ran:Float(0, 360)
                ce1(-224, 150, -90 + a, 1, COLOR_ORANGE, COLOR_RED, COLOR_YELLOW)
                ce1(224, 150, -90 - a, -1, COLOR_ORANGE, COLOR_RED, COLOR_YELLOW)
                while self.timer < 3850 do
                    task.Wait(1)
                end
                a = ran:Float(0, 360)
                ce1(-224, 150, -90 + a, 1, COLOR_BLUE, COLOR_GREEN, COLOR_CYAN)
                ce1(224, 150, -90 - a, -1, COLOR_BLUE, COLOR_GREEN, COLOR_CYAN)
                while self.timer < 4200 do
                    task.Wait(1)
                end
                ce2(0, 245, -1, COLOR_RED, COLOR_PURPLE, COLOR_ORANGE)
                task.Wait(350)
                clearEnemyAndBullet()
                system.PowerRank.pauseHyper()
                task.Wait(360)
            end
        end
    end
end


return R
